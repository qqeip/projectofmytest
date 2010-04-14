{MTU测试任务发送线程}
unit UnitTaskSendThread;

interface
uses
  Classes,ADODB,DB,SysUtils,IdContext,IdGlobal,Ut_BaseThread;

type
  TTaskSendThread = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn :TAdoConnection;
    FQuery :TAdoQuery;
    FQuery_Free :TAdoQuery;
    //获取测试编码数据
    function GetTestEnCode(TaskID,CommandId :integer;MtuNo:String;var EnCode:TIdBytes):boolean;
    //从数据集里获取指定参数值
    function GetParamValue(FDataSet:TDataSet;ParamId :integer):String;
    procedure PrintEnCode(Codes :TIdBytes);
  protected
    procedure DoExecute; override;

  public
    constructor Create(ConStr:String);
    destructor Destroy; override;
  end;

implementation
uses Ut_Global, Ut_MtuInfo, Ut_MtuDataProcess, UnitThreadCommon;
{ TTaskSendThread }

constructor TTaskSendThread.Create(ConStr: String);
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

destructor TTaskSendThread.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQuery_Free.Close;
  FQuery_Free.Free;
  FConn.Close;
  FConn.Free;
  inherited destroy;
end;

procedure TTaskSendThread.DoExecute;
var
  EnCode: TIdBytes;
  i : integer;
  P :TMtuDataProcess;
  lSqlstr :string;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write('任务发送线程异常: 无法连接数据库!',1);
    Exit;
  end;
  try
    while True do   //无限循环
    begin
      //更新屏蔽信息
      lSqlstr := 'update mtu_testtask_online a set status=7 where status=0'+
                 ' and exists (select 1 from mtu_shield_list b where a.mtuid=b.mtuid and b.status=0)';
      ExecMySQL(FQuery_Free,lSqlstr);
      //更新MTU自检 (状态查询没有自检)
      lSqlstr := 'update mtu_testtask_online a set status=8 where status=0 and comid<>6'+
                 ' and exists (select 1 from mtu_status_list b where a.mtuid=b.mtuid and nvl(b.status,1)=0)';
      ExecMySQL(FQuery_Free,lSqlstr);
      //更新超时
      lSqlstr := 'update mtu_testtask_online a set status=6 where ((status=1) or (status=2) or (status=3))'+
                 ' and sysdate-sendtime>30*1/24/60'; //系统时间-发送时间>30分钟为超时
      ExecMySQL(FQuery_Free,lSqlstr);
      //更新已经发送的配置参数为测试成功
      lSqlstr := 'update mtu_testtask_online a set status=4 where status=2'+
                 ' and comid=8';
      ExecMySQL(FQuery_Free,lSqlstr);
      //删除MTUID匹配不上的测试任务,可能他的区域信息是空的
      lSqlstr := 'delete from mtu_testtask_online a'+
                 ' where exists (select 1 from mtu_info_view b where a.mtuid=b.mtuid and b.cityid is null)';
      ExecMySQL(FQuery_Free,lSqlstr);
      //删除参数匹配不上的测试任务  （一般情况不可能发生）
      lSqlstr := 'delete from mtu_testtask_online a'+
                 ' where not exists (select 1 from mtu_testtaskparam_online b where a.taskid=b.taskid)';
      ExecMySQL(FQuery_Free,lSqlstr);
      //更新手动和系统再测
      lSqlstr:= 'update mtu_testtask_online a set a.status=1 where a.status=0 and a.TASKLEVEL<>3';
      //更新前N条记录的状态，等待执行(级别和任务编号)
      lSqlstr := 'update mtu_testtask_online a set a.status=1 where a.status=0'+
                 ' and taskid<=(select min(taskid)+100 from mtu_testtask_online where status=0)';
      ExecMySQL(FQuery_Free,lSqlstr);
      FCounterDatetime:= GetSysDateTime(FQuery_Free);
      with FQuery do
      begin
        close;
        Sql.Text := 'select * from mtu_testtask_online where status=1 order by TASKLEVEL,taskid';
        open;
        if recordcount=0 then break;
        first;
        while not eof do
        begin
          try                                                                                     //FieldByName('MtuNo').AsString
            if GetTestEnCode(FieldByName('TaskID').AsInteger,FieldByName('comid').AsInteger,'',EnCode) then
            begin
//              PrintEnCode(EnCode);
              //找到对应的MTU控制器发送测试命令
              with MtuClients.LockList do
              try
                for I := 0 to Count - 1 do
                begin
                  P := TMtuDataProcess(Items[i]);
                  if (P.Context <> nil) and (P.Cityid = FieldByName('cityid').AsInteger) then
                  begin
                    P.Context.Connection.IOHandler.Write(EnCode);
//                    Break;
                  end;
                end;//控制器循环结束
              finally
                MtuClients.UnlockList;
              end;
              Sleep(30);   //测试验证发现需要10mS
            end else
            //构造BCD码失败
            begin
              edit;
              FieldByName('status').AsInteger := 5;
              post;
            end;
            Next;
          except
            FLog.Write('发送任务线程:TASKID< '+FieldByname('TaskID').AsString+' >执行失败',1);
          end;
        end;//N条循环结束
        //更新能正常构造BCD码任务的状态为已发送
        ExecMySQL(FQuery_Free,'update mtu_testtask_online set status =2,SENDTIME=sysdate where status=1');
      end;
      FCurrentDateTime:= GetSysDateTime(FQuery_Free);
      FLog.Write('发送'+inttostr(FQuery.RecordCount)+'条任务花费'+FormatDatetime('HH:MM:SS秒',FCurrentDateTime-FCounterDatetime),3);
      //手动退出
      if self.IsStop then
        break;
    end;//无限循环
  finally
    FConn.Connected := false;
  end;
end;

function TTaskSendThread.GetParamValue(FDataSet: TDataSet;
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

function TTaskSendThread.GetTestEnCode(TaskID, CommandId: integer;
  MtuNo: String; var EnCode: TIdBytes): boolean;
var
  sqlstr :String;
  Mtu :TMtuBase;
begin
  result := false;
  Mtu:=nil;
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
            TMtuCall(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_MOS : //MOS值测试命令
          begin
            Mtu := TMtuMos.create(true);
            TMtuMos(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuMos(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuMos(Mtu).PlayVoice :=GetParamValue(FQuery_Free,MTUPARAM_PLAY_VOCFILE);
            TMtuMos(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_VOICE : //语音单通测试命令
          begin
            Mtu := TMtuVoice.create(true);
            TMtuVoice(Mtu).MtuEr :=GetParamValue(FQuery_Free,MTUPARAM_CALLER_DEVICEID);
            TMtuVoice(Mtu).MtuEE :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE_DEVICEID);
            TMtuVoice(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuVoice(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuVoice(Mtu).TalkDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TALK_DURATION));
            TMtuVoice(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_CALLEE_DELAY ://被叫时延测试命令
          begin
            Mtu := TMtuCallEEDelay.create(true);
            TMtuCallEEDelay(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuCallEEDelay(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuCallEEDelay(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_WLAN_SPEED : //WLAN速率测试命令
          begin
            Mtu := TMtuWLanSpeed.create(true);
            TMtuWLanSpeed(Mtu).TestDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TEST_DURATION));
            TMtuWLanSpeed(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_WLAN_DELAY :  //WLAN时延、丢包、误码率测试命令
          begin
            Mtu := TMtuWLanDelay.create(true);
            TMtuWLanDelay(Mtu).TestDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TEST_DURATION));
            TMtuWLanDelay(Mtu).REQUENCY :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_FREQUENCY));
            TMtuWLanDelay(Mtu).PingDest :=GetParamValue(FQuery_Free,MTUPARAM_PING_DEST);
            TMtuWLanDelay(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_GET_STATUS :  //MTU状态查询命令
          begin
            Mtu := TMtuGetStatus.create(true);
            TMtuGetStatus(Mtu).SearchFlag :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_SEARCH_FLAG));
            TMtuGetStatus(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_SET_PARAMETER :  //配置MTU检测参数
          begin
            Mtu :=TMtuSetParam.create;
            TMtuSetParam(Mtu).MTUDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_MTU_DURATION));
            TMtuSetParam(Mtu).CCHDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_CCH_DURATION));
            TMtuSetParam(Mtu).WLanDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_WLAN_DURATION));
            TMtuSetParam(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_STOP_TASK :  //停止测试命令 未定义
          begin
            Mtu :=TMtuStopTask.create;
            TMtuStopTask(Mtu).TaskId :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TASKID));
            TMtuStopTask(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_GET_CALLEE :  //MTU号码查询命令
          begin
            Mtu :=TMtuGetCallEE.create(true);
            TMtuGetCallEE(Mtu).SearchFlag :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_SEARCH_FLAG));
            TMtuGetCallEE(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
            TMtuGetCallEE(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        //20090612
        MTU_PPP_TEST:     //PPP拨号测试命令
          begin
            Mtu := TMtuPPPTest.create(true);
            TMtuPPPTest(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_CALL_CENTER:
          begin
            Mtu := TMtuCallCenter.create(true);
            TMtuCallCenter(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
            TMtuCallCenter(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuCallCenter(Mtu).TalkDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TALK_DURATION));
          end;
      end;
      if Mtu <> nil then
      begin
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
      Log.Write('构造测试编码失败,测试任务编号为:['+IntToStr(TaskId)+']'+E.Message,1);
  end;
end;

procedure TTaskSendThread.PrintEnCode(Codes: TIdBytes);
var
  i : integer;
  s :string;
begin
  for I := Low(Codes) to High(Codes) do
    s :=s+' '+Format('%-.2x',[Codes[i]]);
  Log.Write('发：'+s,3);
end;

end.
