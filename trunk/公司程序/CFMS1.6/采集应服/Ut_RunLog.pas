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
        //��½�û���Ϣ����
        procedure WriteMessageLog(msg : String);

        procedure SaveRunLog(var RunLog:TRichEdit; KindStr:string);
        //֪ͨԤ����Ϣ
        function ReceiveCmd(cmd:integer;Filter:String):Boolean;
    { Public declarations }
    end;

var
    Fm_RunLog: TFm_RunLog;

    isStat : Boolean;
implementation

uses Ut_Data_Local, Ut_Flowtache_Monitor;

{$R *.dfm}
{  ʵʱ��Ϣ����
0   ������ʱ��Ϣ    ���� ��ʾ�ӵ���λ��ʼΪ����ʱ��Ϣ��
00  �����㲥��Ϣ
1   ������  Ч      ���� ��ʾ�ѷ����ɼ�����
11  ����ʵʱ��Ϣ�ɼ����� ��ʾ�ѷ���ʵʱ��Ϣ�ɼ�����
12  ����15����ѯ�澯���� ��ʾ�ѷ���15������ѯ�澯�ɼ�����
13  ����һСʱ�澯  ���� ��ʾ�ѷ���һСʱ��ѯ�澯�ɼ�����
2   ������  ��      ���� ��ʾ�����������ϲ���(��������ȷ��Ϊ��������)
3   �����ݲ���      ���� ��ʾ�����ݲ��ɹ��ϲ���(��������ȷ��Ϊ�ݲ���)
4   ������  ��      ����
5   ����������      ���� ��ʾ�ѷ������ϲ���
6   ����������(��)  ���� ��ʾĳ�����������
61  ����������(ϸ)  ���� ��ʾĳ�澯��¼���������
7		�������ύ      ���� ��ʾ���д�ά��˾�ص����ύ���澯��
8		������������    ���� ��ʾ���д�ά��˾�������ѣ��ύ������ɣ�
9		���������      ���� ��ʾ����������ȷ������
90  --  ���Ϳͻ��˻�����Ϣ���������洢    ��ʽ  ����(2)+���ź�(5)+��������(2)+�ϼ����ź�(5)
91 --����ͳ����
99  --  �������Ͽ�
}

function TFm_RunLog.GetLocalIP: string;
var
    HostEnt: PHostEnt;
    addr: pchar;
    Buffer: array[0..63] of char;
    GInitData: TWSADATA;
    sIp: string; //��ű���IP
begin
    try // �󶨱���IP
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
          WriteMessageLog( '�澯���Խ��շ��������ɹ�!');
      end;
    except on E: exception do
      begin
          WriteMessageLog('�澯���Խ��շ�������ʧ�� : ' + e.Message);
          MessageBox(Handle, '�澯���Խ��շ�������ʧ��,�����˳�!', '��ʾ', MB_ICONINFORMATION + MB_OK);
      end;
    end;
  finally
    Bindings.Free;
  end;
end;

procedure TFm_RunLog.FormCreate(Sender: TObject);
begin
  isStat := false;
  //Maxlength��������Ϊ$7FFFFFF0,�ɴ�Žӽ�2GB���ı�
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
          Add(Format('%-8s  %-20s  %-16s  %-20s  %-20s  %-14s  %-14s', ['[ ��� ]', '[ ʱ�� ]', '[ IP��ַ ]', '[ ������ ]', '[ ���� ]', '[ �澯����(��) ]', '[ �澯����(ϸ) ]']));
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
        WriteMessageLog('��ȡ�澯���Խ������澯���Խ��ʱ�����쳣���쳣��ʾ��'+E.Message);
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


