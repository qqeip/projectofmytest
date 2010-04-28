unit Ut_RunLog;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    StdCtrls, ComCtrls, WinSock, IdSocketHandle, IdBaseComponent,
    IdComponent, IdTCPServer, IdUDPBase, IdUDPServer, IdTCPConnection,
    IdTCPClient, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase,ADODB,
    IdAntiFreeze, Ut_Main_Build, ExtCtrls,Dialogs,Ut_common, IdUDPClient,Ut_AlarmTestDefine;

type    
    TFm_RunLog = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Re_RunLog: TRichEdit;
    Message_Log: TRichEdit;
    AlarmTestClient: TIdUDPClient;
    AlarmTestServer: TIdUDPServer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AlarmTestServerUDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    private
    { Private declarations }
        function GetAlarmTestPort:Integer;
    public
        LocalIP : String;
        DeptStat : Array of Array of integer;
        function GetLocalIP: string;
        //登陆用户信息管理
        procedure WriteMessageLog(msg : String);

        procedure SaveRunLog(var RunLog:TRichEdit; KindStr:string);
        //通知预警信息
        function ReceiveCmd(cmd:integer;Filter:String):Boolean;
    { Public declarations }
    end;

var
    Fm_RunLog: TFm_RunLog;

    isStat : Boolean;
implementation

uses Ut_Data_Local, Ut_Flowtache_Monitor;

{$R *.dfm}
{  实时消息定义
0   ——即时消息    —— 表示从第三位开始为“即时消息”
00  ——广播消息
1   ——无  效      —— 表示已发生采集操作
11  ——实时消息采集—— 表示已发生实时消息采集操作
12  ——15分轮询告警—— 表示已发生15分钟轮询告警采集操作
13  ——一小时告警  —— 表示已发生一小时轮询告警采集操作
2   ——遗  留      —— 表示已有遗留故障产生(无线中心确认为遗留故障)
3   ——暂不派      —— 表示已有暂不派故障产生(无线中心确认为暂不派)
4   ——采  集      ——
5   ——已派障      —— 表示已发生派障操作
6   ——已排障(主)  —— 表示某批排障已完成
61  ——已排障(细)  —— 表示某告警记录排障已完成
7		——已提交      —— 表示已有代维公司回单（提交批告警）
8		——申请疑难    —— 表示已有代维公司申请疑难（提交疑难完成）
9		——已完成      —— 表示网控中心已确认消障
90  --  发送客户端基本信息供服务器存储    格式  命令(2)+部门号(5)+部门类型(2)+上级部门号(5)
91 --更新统计项
99  --  服务器断开
}

function TFm_RunLog.GetLocalIP: string;
var
    HostEnt: PHostEnt;
    addr: pchar;
    Buffer: array[0..63] of char;
    GInitData: TWSADATA;
    sIp: string; //存放本机IP
begin
    try // 绑定本机IP
        WSAStartup(2, GInitData);
        GetHostName(Buffer, SizeOf(Buffer));
        HostEnt := GetHostByName(Buffer);
        if HostEnt = nil then Exit;
        addr := HostEnt^.h_addr_list^;
        sIp := Format('%d.%d.%d.%d', [byte(addr[0]),
            byte(addr[1]), byte(addr[2]), byte(addr[3])]);
        result := sIP;
    finally
        WSACleanup;
    end;
end;

procedure TFm_RunLog.SaveRunLog(var RunLog:TRichEdit; KindStr:string);
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  filename,FilePath : String;
begin
   Present:= Now;
   DecodeDate(Present, Year, Month, Day);
   DecodeTime(Present, Hour, Min, Sec, MSec);
   filename :=Format('%.4d',[year])+Format('%.2d',[month])+Format('%.2d',[day])+'_'+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+'_'+Format('%.4d',[MSec])+'.Txt';
   FilePath:=ExtractFilePath(ParamStr(0))+'RunLog\';    //FilePath
   if not DirectoryExists(FilePath) then
     ForceDirectories(FilePath);
   with RunLog.Lines do
   begin
       SaveToFile(FilePath+KindStr+filename);
       Clear;
   end;
end;

procedure TFm_RunLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   SaveRunLog(Re_RunLog,'RunLog');
   SaveRunLog(Message_Log,'MsgLog');
   action := cafree;
   Fm_RunLog := nil;
end;

procedure TFm_RunLog.FormShow(Sender: TObject);
var
  Bindings: TIdSocketHandles;
begin
  Bindings := TIdSocketHandles.Create(self);
  try
    try
      with Bindings.Add do
      begin
          IP := LocalIP;
          Port := GetAlarmTestPort;
      end;
      AlarmTestServer.Bindings := Bindings;
      AlarmTestServer.Active := TRUE;
      if AlarmTestServer.Active then
      begin
          WriteMessageLog( '告警测试接收服务启动成功!');
      end;
    except on E: exception do
      begin
          WriteMessageLog('告警测试接收服务启动失败 : ' + e.Message);
          MessageBox(Handle, '告警测试接收服务启动失败,程序退出!', '提示', MB_ICONINFORMATION + MB_OK);
      end;
    end;
  finally
    Bindings.Free;
  end;
end;

procedure TFm_RunLog.FormCreate(Sender: TObject);
begin
  isStat := false;
  //Maxlength属性设置为$7FFFFFF0,可存放接近2GB的文本
  Re_RunLog.MaxLength := $7FFFFFF0;
  Re_RunLog.PlainText := true;
  Message_Log.MaxLength := $7FFFFFF0;
  Message_Log.PlainText := true;
end;

procedure TFm_RunLog.WriteMessageLog(msg: String);
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  filename,FilePath : String;
  Present: TDateTime;
begin
   Present:= Now;
   DecodeDate(Present, Year, Month, Day);
   DecodeTime(Present, Hour, Min, Sec, MSec);
   filename :=Format('%.4d',[year])+Format('%.2d',[month])+Format('%.2d',[day])+'_'+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+'_'+Format('%.4d',[MSec])+'.Txt';
   with Message_Log.Lines do
   begin
       if Count > 10000 then
       begin
          FilePath:=ExtractFilePath(ParamStr(0))+'RunLog\';    //FilePath
          if not DirectoryExists(FilePath) then
            ForceDirectories(FilePath);
          SaveToFile(FilePath+'MsgLog_'+filename);
          Clear;
          Add(Format('%-8s  %-20s  %-16s  %-20s  %-20s  %-14s  %-14s', ['[ 序号 ]', '[ 时间 ]', '[ IP地址 ]', '[ 操作人 ]', '[ 环节 ]', '[ 告警数量(主) ]', '[ 告警数量(细) ]']));
       end;
       Add(DateTimeToStr(now)+'  '+msg);
   end;

end;

procedure TFm_RunLog.AlarmTestServerUDPRead(Sender: TObject;
  AData: TStream; ABinding: TIdSocketHandle);
var
  tem :TMemoryStream;
  R :SIFResult;
begin
  tem :=TMemoryStream.Create;
  try
    tem.LoadFromStream(Adata);
    try
      tem.ReadBuffer(R,Sizeof(SIFResult));
      TestResultProcess(R,LineTestResult(R));
    except
      on E:Exception do
        WriteMessageLog('读取告警测试结果或处理告警测试结果时发生异常，异常提示：'+E.Message);
    end;
  finally
    tem.Free;
  end;
end;

function TFm_RunLog.GetAlarmTestPort: Integer;
begin
  result := 20001;
  with Dm_Collect_Local.Ado_Free do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from alarm_sys_public where kind = 7 and code =1');
    Open;
    if RecordCount > 0 then
      result := FieldByName('setvalue').AsInteger;
    Close;
  end;
end;


function TFm_RunLog.ReceiveCmd(cmd:integer;Filter:String):Boolean;
begin
  result := false;
  if Pos(','+IntToStr(cmd)+',',','+Filter+',') > 0 then
    result := true;
end;

end.


