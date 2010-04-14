{ **********************************************************
  MTU测试结果解析线程
********************************************************** }
unit Ut_ParseDataThread;

interface

uses
  Windows, Classes, Log, SysUtils,DateUtils, IniFiles, IdGlobal,
  Forms,Ut_BaseThread,ADODB,DB,Variants,Ut_MtuInfo;

type
  TParseDataThread = class(TMyThread)
  private
    { Private declarations }
    FAdoCon : TAdoConnection;
    FQuery,FQueryFree: TAdoQuery;
    FLog :TLog;
    FSQLList :TStringList;
    FMTULIst :TStringList;
  protected
    function GetTaskId : integer;
    procedure ExecSQLList(FMyQuery :TAdoQuery;sqllist:TStringList);
    Procedure ExecMySQL(FMyQuery :TAdoQuery;sqlstr:String);
    function StrToIdBytes(sValue :String): TIdBytes;
    function ParseSQL(baseid,cityid:integer;MsgData:TIdBytes):Boolean;
    procedure DoExecute; override;
  public
    constructor Create(Log :TLog;ConnStr :String);
    destructor Destroy; override;
  end;

implementation

{ TParseDataThread }

constructor TParseDataThread.Create(Log: TLog; ConnStr: String);
begin
  inherited create;
  FAdoCon := TAdoConnection.Create(nil);
  with FAdoCon do
  begin
    ConnectionString :=ConnStr;
    LoginPrompt := false;
    KeepConnection := true;
  end;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FAdoCon;

  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection := FAdoCon;

  FLog := Log;
  FSQLList :=TStringList.Create;
end;

destructor TParseDataThread.destroy;
begin
  FSQLList.Free;
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FAdoCon.Close;
  FAdoCon.Free;
  inherited destroy;
end;

procedure TParseDataThread.DoExecute;
var
  MsgData :TIdBytes;
begin
  //inherited;
  if not FAdoCon.Connected then
  try
    FAdoCon.Connected := true;
  except
    FLog.Write('MTU测试数据解析线程异常：无法连接数据库!',1);
    Exit;
  end;

  //获取MTU列表
  FMTULIst :=TStringList.Create;
  with FQueryFree do
  begin
    close;
    sql.Text:='select t.mtuno from mtu_info t group by mtuno';
    open;
    while not eof do
    begin
      FMTULIst.Add(Fieldbyname('mtuno').AsString);
      Next;
    end;
  end;
  while True do
  begin
    try
      with FQuery do
      begin
        Close;
        SQL.Clear;
        //由于数据量可能比较大，所以就分批解析
        SQL.Add('select a.* from'+
                ' (select t.*,row_number() over (order by t.baseid) rn'+
                ' from mtu_testresult_base t where t.isprocess=0) a'+
                ' where a.rn<=5000');                      
        Open;
        if RecordCount <= 0 then Break;//如果没有记录，就退出
        begin
          first;
          while Not Eof do
          begin
            MsgData := StrToIdBytes(FieldByName('testvalue').AsString);
            if ParseSQL(FieldByName('Baseid').AsInteger,FieldByName('cityid').AsInteger,MsgData) then
            begin
              Edit;
              FieldByName('IsProcess').AsInteger :=1;
              Post;                                         //1表示已经解决  Modiby by cdj 20081007
            end
            else
            begin
              Edit;
              FieldByName('IsProcess').AsInteger :=3;
              Post;                                         //3为异常数据
            end;
            Next;
          end;
        end;
      end;
    except
      On E:Exception do
      begin
        FLog.Write('MTU数据解析线程异常: '+E.Message,1);
      end;
    end;
    //清理工作
    FAdoCon.BeginTrans;
    try
      //1未处理2已发送3已执行4成功5失败6未响应7停止命令
      //更新超时命令 系统时间-发送时间>30分钟  by cdj
      //可能由于对方控制器下线，而我们采集服务还在进行，发送的测试命令不返回结果
      ExecMySQL(FQueryFree,'update mtu_testtask_online set status=5 where status in (2,3) and  sysdate-sendtime>30*1/24/60');
      //删除自动测试任务及其参数
      ExecMySQL(FQueryFree,'delete from mtu_testtaskparam_online a'+
                           ' where exists (select 1 from mtu_testtask_online b where a.taskid=b.taskid'+
                           ' and b.status in (4,5,6) and b.userid=-1)');
      ExecMySQL(FQueryFree,'delete from mtu_testtask_online where  status in (4,5,6) and userid=-1');
      //删除已经处理的原始数据
      //异常数据也移到历史表里
      ExecMySQL(FQueryFree,'insert into mtu_testresult_base_history'+
                           ' select baseid, testvalue, isprocess, cityid,sysdate from mtu_testresult_base'+
                           ' where isprocess in (1,3)');
      ExecMySQL(FQueryFree,'delete from mtu_testresult_base where isprocess in (1,3)');
      FAdoCon.CommitTrans;
    Except
      On E:Exception do
      begin
        FLog.Write('MTU数据解析线程清理任务数据异常: '+E.Message,1);
        FAdoCon.RollbackTrans;
      end;
    end;
  end;
  FAdoCon.Connected := false;
  FMTULIst.Free;
end;

procedure TParseDataThread.ExecMySQL(FMyQuery: TAdoQuery; sqlstr: String);
begin
  with FMyQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    ExecSQL;
    Close;
  end;
end;

procedure TParseDataThread.ExecSQLList(FMyQuery :TAdoQuery;sqllist:TStringList);
var
  i : integer;
begin
  try
    for I := 0 to sqllist.Count - 1 do
      with FMyQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add(sqllist.Strings[i]);
        ExecSQL;
        Close;
      end;
  except
    On E:Exception do
      Raise Exception.Create('MTU测试结果解析入库失败 - '+E.Message);
  end;
end;

function TParseDataThread.GetTaskId: integer;
begin
  result :=-1;
  try
    with FQueryFree do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select MTU_TASKID.nextval as TaskId from dual');
      Open;
      result := FieldByName('TaskId').AsInteger;
      Close;
    end;
  Except
    FLog.Write('获取任务编号失败!',1);
  end;
end;

function TParseDataThread.ParseSQL(baseid,cityid:integer;MsgData: TIdBytes): Boolean;
var
  Mtu :TMtuBase;
begin
  result := true;
  FSQLList.Clear;
  try
    //第四字节为消息编号
    case MsgData[4] of
      MTU_REPORT_SELF :
        begin
          Mtu :=TMtuSelf.create;
          try
            Mtu.Cityid := cityid;
            Mtu.TaskId :=Baseid;//GetTaskId;  Moidy by cdj 20081007
            Mtu.MtuList:=FMTULIst;
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_REPORT_CCH :
        begin
          Mtu := TMtuCch.create;
          Mtu.TaskId :=Baseid;    //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_TEST_CALL_RESULT :
        begin
          Mtu := TMtuCall.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_TEST_TCH_RESULT :
        begin
          Mtu := TMtuTch.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_TEST_HANDOVER_RESULT :
        begin
          Mtu := TMtuHandOver.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_TEST_MOS_RESULT :
        begin
          Mtu := TMtuMos.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_TEST_VOICE_RESULT :
        begin
          Mtu := TMtuVoice.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_TEST_CALLEE_DELAY_RESULT :
        begin
          Mtu := TMtuCallEEDelay.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_REPORT_WLAN :
        begin
          Mtu := TMtuWLan.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_TEST_WLAN_SPEED_RESULT :
        begin
          Mtu := TMtuWLanSpeed.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_TEST_WLAN_DELAY_RESULT :
        begin
          Mtu := TMtuWLanDelay.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_REPORT_STATUS :
        begin
          Mtu := TMtuStatus.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_GET_STATUS_RESULT :
        begin
          Mtu := TMtuGetStatus.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_REPORT_WLAN_ERROR :
        begin
          Mtu := TMtuWLanError.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_REPORT_WLAN_OK :
        begin
          Mtu := TMtuWLanOK.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_GET_CALLEE_RESULT :
        begin
          Mtu := TMtuGetCallEE.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
            FLog.Write(Mtu.DecodeResult,3);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_COMMAND_ACK :
        begin
          Mtu := TMtuCmdAck.create;
          Mtu.TaskId :=Baseid;   //Moidy by cdj 20081007
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end
        end;
      MTU_NOWLAN_REPORT :
        begin
          Mtu := TMtuNoLan.create;
          Mtu.TaskId :=Baseid;
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end;
        end;
      MTU_NOCCH_REPORT :
        begin
          Mtu := TMtuNoCCH.create;
          Mtu.TaskId :=Baseid;
          Mtu.MtuList:=FMTULIst;
          Mtu.Cityid := cityid;
          try
            Mtu.DecodeMsgSQL(MsgData,FSQLList);
          finally
            if Mtu <> nil then
              Mtu.Free;
          end;
        end;
    end;
    if FSQLList.Count >0 then
      ExecSQLList(FQueryFree,FSQLList);
  Except
    On E:Exception do
    begin
      FLog.Write('解析编号为< '+IntToStr(Baseid)+' >的测试结果数据时失败: '+E.Message,1);
      result := false;
    end;
  end;
end;

function TParseDataThread.StrToIdBytes(sValue: String): TIdBytes;
var
  i : integer;
  Msg :String;
begin
  Msg := StringReplace(sValue,' ','',[rfReplaceAll]);
  if Msg<>'' then
  begin
    SetLength(Result,Length(Msg) div 2);
    for I := 0 to Length(Msg) div 2-1 do
      Result[i] :=StrToInt('$'+Copy(Msg,i*2+1,2));
  end;
end;

end.
