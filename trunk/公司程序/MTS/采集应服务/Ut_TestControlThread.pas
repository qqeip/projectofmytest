{ ****************************************************
  测试任务调度线程 (cyx)
  1、捡索数据库中的待测(未发送、已发送但未回复收到命令)试任务.
  2、根据待测试任务选择构造MTU类对象，组织编码测试消息数据。
  3、根据MTU所属地市挑选测试MTU控制器发送,写已发送标识。
******************************************************}
unit Ut_TestControlThread;

interface

uses
  Classes,ADODB,DB,SysUtils,IdContext,IdGlobal,Ut_BaseThread;

type
  TTestControlThread = class(TMyThread)
  private
    FConn :TAdoConnection;
    FQuery :TAdoQuery;
    FQuery_Free :TAdoQuery;
    { Private declarations }
  protected
    procedure DoExecute; override;
    //获取未测试任务
    function GetTaskNoTest:boolean;
    //获取测试编码数据
    function GetTestEnCode(TaskID,CommandId :integer;MtuNo:String;var EnCode:TIdBytes):boolean;
    //从数据集里获取指定参数值
    function GetParamValue(FDataSet:TDataSet;ParamId :integer):String;

    procedure ExecMySQL(FMyQuery:TAdoQuery;FSQL:String);
    procedure PrintEnCode(Codes :TIdBytes);
    //保存测试命令在线表
    procedure SaveTestTaskHistroy(aTaskID :integer);
    //删除测试命令在线表
    procedure DelTestTaskOnline(aTaskID :integer);
  public
    constructor Create(ConStr:String);
    destructor destroy; override;
  end;

implementation
uses Ut_MtuInfo,Ut_Global,Ut_MtuDataProcess;
{ TTestControlThread }

constructor TTestControlThread.Create(ConStr: String);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := false;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection :=FConn;
  FQuery_Free :=TAdoQuery.Create(nil);
  FQuery_Free.Connection :=FConn;

end;

procedure TTestControlThread.DelTestTaskOnline(aTaskID: integer);
var
  lsqlstr:string;
begin
  lsqlstr:='delete from mtu_testtask_online where taskid='+inttostr(aTaskID);
  ExecMySQL(FQuery_Free,lSqlstr);
  lsqlstr:='delete from mtu_testtaskparam_online where taskid='+inttostr(aTaskID);
  ExecMySQL(FQuery_Free,lSqlstr);
end;

destructor TTestControlThread.destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQuery_Free.Close;
  FQuery_Free.Free;
  FConn.Connected := false;
  FConn.Free;
  inherited destroy;
end;

//监测任务并测试
procedure TTestControlThread.DoExecute;
var
  sqlstr :String;
  i : integer;
  P :TMtuDataProcess;
  EnCode: TIdBytes;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write('测试任务调度线程异常: 无法连接数据库!',1);
    Exit;
  end;
  //如果获取到待测任务
  if GetTaskNoTest then
  begin
    with FQuery do
    begin
      first;
      while not Eof do
      begin
        //如果获取编码成功,遍历发送命令
        if GetTestEnCode(FieldByName('TaskID').AsInteger,FieldByName('comid').AsInteger,FieldByName('MtuNo').AsString,EnCode) then
        begin
          //打印编码
          //PrintEnCode(EnCode);
          //找到对应的MTU控制器发送测试命令
          with MtuClients.LockList do
          try
            for I := 0 to Count - 1 do
            begin
              P := TMtuDataProcess(Items[i]);
              if (P.Context <> nil) and (P.Cityid = FieldByName('cityid').AsInteger) then
              begin
                P.Context.Connection.IOHandler.Write(EnCode);
                if FieldByName('userid').AsInteger=-1 then   //自动测试就直接删除
                begin
                  SaveTestTaskHistroy(FieldByName('TaskID').AsInteger);
                  DelTestTaskOnline(FieldByName('TaskID').AsInteger);
                end else
                begin
                  //写入已发送标志
                  sqlstr :=' update mtu_testtask_online set status = 2,SendTime = sysdate where status =1 and Taskid ='+FieldByName('TaskID').AsString;
                  ExecMySQL(FQuery_Free,sqlstr);
                end;
                Break;
              end;
            end;
          finally
            MtuClients.UnlockList;
          end;
        end;
        Sleep(10);   //测试验证发现需要1S
        Next;
      end;
    end;
  end;
  FConn.Connected := false;
end;

procedure TTestControlThread.ExecMySQL(FMyQuery:TAdoQuery;
  FSQL: String);
begin
  try
    with FMyQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(FSQL);
      ExecSQL;
    end;
  except
    On E:Exception do
    Log.Write('更新测试任务发送标识时失败!-'+E.Message,1);
  end;
end;

function TTestControlThread.GetParamValue(FDataSet: TDataSet;
  ParamId: integer): String;
begin
  result := '';
  if FDataSet.Active then
    with FDataSet do
    begin
      if Locate('PARAMID',ParamId,[]) then
        result := FieldByName('PARAMVALUE').AsString;
    end;
end;

function TTestControlThread.GetTaskNoTest: boolean;
var
  sqlstr :string;
begin
  result :=false;
  sqlstr :='select a.taskid, a.cityid, b.mtuno, a.comid, a.userid from mtu_testtask_online a'+
           ' inner join mtu_info b on a.mtuid=b.mtuid where a.status =1';
  try
    with FQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      Open;
      result := RecordCount > 0;
    end;
  except
    Log.Write('获取MTU待测试任务失败!',1);
  end;
end;
//根据任务号、命令号、MTU号获取参数后编码测试数据
function TTestControlThread.GetTestEnCode(TaskID, CommandId: integer;
  MtuNo: String; var EnCode: TIdBytes): boolean;
var
  sqlstr :String;
  Mtu :TMtuBase;
begin
  result := false;
  try
    sqlstr :='select * from mtu_testtaskparam_online where taskid =:TaskID';
    with FQuery_Free do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      Parameters.ParamByName('TaskID').Value := TaskId;
      Open;
    end;
    if FQuery_Free.RecordCount >0 then
    begin
      //根据不同命令分类来构造测试数据
      case CommandId of
        MTU_TEST_CALL : //呼叫测试命令
          begin
            Mtu := TMtuCall.create(true);
            TMtuCall(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuCall(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuCall(Mtu).TalkDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TALK_DURATION));
          end;
        MTU_TEST_MOS : //MOS值测试命令
          begin
            Mtu := TMtuMos.create(true);
            TMtuCall(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuCall(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuMos(Mtu).PlayVoice :=GetParamValue(FQuery_Free,MTUPARAM_PLAY_VOCFILE);
          end;
        MTU_TEST_VOICE : //语音单通测试命令
          begin
            Mtu := TMtuVoice.create(true);
            TMtuVoice(Mtu).MtuEr :=GetParamValue(FQuery_Free,MTUPARAM_CALLER_DEVICEID);
            TMtuVoice(Mtu).MtuEE :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE_DEVICEID);
            TMtuVoice(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuVoice(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuVoice(Mtu).TalkDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TALK_DURATION));
          end;
        MTU_TEST_CALLEE_DELAY :
          begin
            Mtu := TMtuCallEEDelay.create(true);
            TMtuCallEEDelay(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuCallEEDelay(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
          end;
        MTU_TEST_WLAN_SPEED : //WLAN速率测试命令
          begin
            Mtu := TMtuWLanSpeed.create(true);
            TMtuWLanSpeed(Mtu).TestDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TEST_DURATION));
          end;
        MTU_TEST_WLAN_DELAY :  //WLAN时延、丢包、误码率测试命令
          begin
            Mtu := TMtuWLanDelay.create(true);
            TMtuWLanDelay(Mtu).TestDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TEST_DURATION));
            TMtuWLanDelay(Mtu).REQUENCY :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_FREQUENCY));
            TMtuWLanDelay(Mtu).PingDest :=GetParamValue(FQuery_Free,MTUPARAM_PING_DEST);
          end;
        MTU_GET_STATUS :  //WLAN时延、丢包、误码率测试命令
          begin
            Mtu := TMtuGetStatus.create(true);
            TMtuGetStatus(Mtu).SearchFlag :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_SEARCH_FLAG));
          end;
        MTU_SET_PARAMETER :  //配置MTU检测参数
          begin
            Mtu :=TMtuSetParam.create;
            TMtuSetParam(Mtu).MTUDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_MTU_DURATION));
            TMtuSetParam(Mtu).CCHDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_CCH_DURATION));
            TMtuSetParam(Mtu).WLanDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_WLAN_DURATION));
          end;
        MTU_STOP_TASK :  //停止测试命令 未定义
          begin
            Mtu :=TMtuStopTask.create;
            TMtuStopTask(Mtu).TaskId :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TASKID));
            TMtuStopTask(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_GET_CALLEE :
          begin
            Mtu :=TMtuGetCallEE.create(true);
            TMtuGetCallEE(Mtu).SearchFlag :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_SEARCH_FLAG));
            TMtuGetCallEE(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
      end;

      if Mtu <> nil then
      begin
        Mtu.MtuNo :=MtuNo;
        Mtu.TaskId :=TaskID;
        case CommandId of
          6,8,10,160: ;
        else
          begin
            Mtu.TestTimes :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TIMES));
            Mtu.TestInterval :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_INTERVAL));
          end;
        end;
        //取编码后的数据
        result := Mtu.GetTestEnCode(EnCode);
      end;
    end;
    FQuery_Free.Close;
  Except
    On E:Exception do
      Log.Write('构造测试编码失败:[Taskid:'+IntToStr(TaskId)+']'+E.Message,1);
  end;
end;

procedure TTestControlThread.PrintEnCode(Codes: TIdBytes);
var
  i : integer;
  s :string;
begin
  for I := Low(Codes) to High(Codes) do
    s :=s+' '+Format('%-.2x',[Codes[i]]);
  Log.Write('发：'+s,3);
end;

procedure TTestControlThread.SaveTestTaskHistroy(aTaskID: integer);
var
  lSqlstr:string;
begin
  lSqlstr:='insert into mtu_testtask_histroy select * from mtu_testtask_online where taskid='+inttostr(aTaskID);
  ExecMySQL(FQuery_Free,lSqlstr);
end;

end.
