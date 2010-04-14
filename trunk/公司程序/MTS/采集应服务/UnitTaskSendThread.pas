{MTU�����������߳�}
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
    //��ȡ���Ա�������
    function GetTestEnCode(TaskID,CommandId :integer;MtuNo:String;var EnCode:TIdBytes):boolean;
    //�����ݼ����ȡָ������ֵ
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
    FLog.Write('�������߳��쳣: �޷��������ݿ�!',1);
    Exit;
  end;
  try
    while True do   //����ѭ��
    begin
      //����������Ϣ
      lSqlstr := 'update mtu_testtask_online a set status=7 where status=0'+
                 ' and exists (select 1 from mtu_shield_list b where a.mtuid=b.mtuid and b.status=0)';
      ExecMySQL(FQuery_Free,lSqlstr);
      //����MTU�Լ� (״̬��ѯû���Լ�)
      lSqlstr := 'update mtu_testtask_online a set status=8 where status=0 and comid<>6'+
                 ' and exists (select 1 from mtu_status_list b where a.mtuid=b.mtuid and nvl(b.status,1)=0)';
      ExecMySQL(FQuery_Free,lSqlstr);
      //���³�ʱ
      lSqlstr := 'update mtu_testtask_online a set status=6 where ((status=1) or (status=2) or (status=3))'+
                 ' and sysdate-sendtime>30*1/24/60'; //ϵͳʱ��-����ʱ��>30����Ϊ��ʱ
      ExecMySQL(FQuery_Free,lSqlstr);
      //�����Ѿ����͵����ò���Ϊ���Գɹ�
      lSqlstr := 'update mtu_testtask_online a set status=4 where status=2'+
                 ' and comid=8';
      ExecMySQL(FQuery_Free,lSqlstr);
      //ɾ��MTUIDƥ�䲻�ϵĲ�������,��������������Ϣ�ǿյ�
      lSqlstr := 'delete from mtu_testtask_online a'+
                 ' where exists (select 1 from mtu_info_view b where a.mtuid=b.mtuid and b.cityid is null)';
      ExecMySQL(FQuery_Free,lSqlstr);
      //ɾ������ƥ�䲻�ϵĲ�������  ��һ����������ܷ�����
      lSqlstr := 'delete from mtu_testtask_online a'+
                 ' where not exists (select 1 from mtu_testtaskparam_online b where a.taskid=b.taskid)';
      ExecMySQL(FQuery_Free,lSqlstr);
      //�����ֶ���ϵͳ�ٲ�
      lSqlstr:= 'update mtu_testtask_online a set a.status=1 where a.status=0 and a.TASKLEVEL<>3';
      //����ǰN����¼��״̬���ȴ�ִ��(�����������)
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
              //�ҵ���Ӧ��MTU���������Ͳ�������
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
                end;//������ѭ������
              finally
                MtuClients.UnlockList;
              end;
              Sleep(30);   //������֤������Ҫ10mS
            end else
            //����BCD��ʧ��
            begin
              edit;
              FieldByName('status').AsInteger := 5;
              post;
            end;
            Next;
          except
            FLog.Write('���������߳�:TASKID< '+FieldByname('TaskID').AsString+' >ִ��ʧ��',1);
          end;
        end;//N��ѭ������
        //��������������BCD�������״̬Ϊ�ѷ���
        ExecMySQL(FQuery_Free,'update mtu_testtask_online set status =2,SENDTIME=sysdate where status=1');
      end;
      FCurrentDateTime:= GetSysDateTime(FQuery_Free);
      FLog.Write('����'+inttostr(FQuery.RecordCount)+'�����񻨷�'+FormatDatetime('HH:MM:SS��',FCurrentDateTime-FCounterDatetime),3);
      //�ֶ��˳�
      if self.IsStop then
        break;
    end;//����ѭ��
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
      //���ݲ�ͬ��������������������
      case CommandId of
        MTU_TEST_CALL : //���в�������
          begin
            Mtu := TMtuCall.create(true);
            TMtuCall(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuCall(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuCall(Mtu).TalkDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TALK_DURATION));
            TMtuCall(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_MOS : //MOSֵ��������
          begin
            Mtu := TMtuMos.create(true);
            TMtuMos(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuMos(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuMos(Mtu).PlayVoice :=GetParamValue(FQuery_Free,MTUPARAM_PLAY_VOCFILE);
            TMtuMos(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_VOICE : //������ͨ��������
          begin
            Mtu := TMtuVoice.create(true);
            TMtuVoice(Mtu).MtuEr :=GetParamValue(FQuery_Free,MTUPARAM_CALLER_DEVICEID);
            TMtuVoice(Mtu).MtuEE :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE_DEVICEID);
            TMtuVoice(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuVoice(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuVoice(Mtu).TalkDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TALK_DURATION));
            TMtuVoice(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_CALLEE_DELAY ://����ʱ�Ӳ�������
          begin
            Mtu := TMtuCallEEDelay.create(true);
            TMtuCallEEDelay(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuCallEEDelay(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuCallEEDelay(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_WLAN_SPEED : //WLAN���ʲ�������
          begin
            Mtu := TMtuWLanSpeed.create(true);
            TMtuWLanSpeed(Mtu).TestDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TEST_DURATION));
            TMtuWLanSpeed(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_TEST_WLAN_DELAY :  //WLANʱ�ӡ������������ʲ�������
          begin
            Mtu := TMtuWLanDelay.create(true);
            TMtuWLanDelay(Mtu).TestDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TEST_DURATION));
            TMtuWLanDelay(Mtu).REQUENCY :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_FREQUENCY));
            TMtuWLanDelay(Mtu).PingDest :=GetParamValue(FQuery_Free,MTUPARAM_PING_DEST);
            TMtuWLanDelay(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_GET_STATUS :  //MTU״̬��ѯ����
          begin
            Mtu := TMtuGetStatus.create(true);
            TMtuGetStatus(Mtu).SearchFlag :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_SEARCH_FLAG));
            TMtuGetStatus(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_SET_PARAMETER :  //����MTU������
          begin
            Mtu :=TMtuSetParam.create;
            TMtuSetParam(Mtu).MTUDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_MTU_DURATION));
            TMtuSetParam(Mtu).CCHDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_CCH_DURATION));
            TMtuSetParam(Mtu).WLanDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_WLAN_DURATION));
            TMtuSetParam(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_STOP_TASK :  //ֹͣ�������� δ����
          begin
            Mtu :=TMtuStopTask.create;
            TMtuStopTask(Mtu).TaskId :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TASKID));
            TMtuStopTask(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        MTU_GET_CALLEE :  //MTU�����ѯ����
          begin
            Mtu :=TMtuGetCallEE.create(true);
            TMtuGetCallEE(Mtu).SearchFlag :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_SEARCH_FLAG));
            TMtuGetCallEE(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
            TMtuGetCallEE(Mtu).MtuNo := GetParamValue(FQuery_Free,MTUPARAM_DEVICEID) ;
          end;
        //20090612
        MTU_PPP_TEST:     //PPP���Ų�������
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
        //ȡ����������
        result := Mtu.GetTestEnCode(EnCode);
      end;
    end;
    FQuery_Free.Close;
  Except
    On E:Exception do
      Log.Write('������Ա���ʧ��,����������Ϊ:['+IntToStr(TaskId)+']'+E.Message,1);
  end;
end;

procedure TTaskSendThread.PrintEnCode(Codes: TIdBytes);
var
  i : integer;
  s :string;
begin
  for I := Low(Codes) to High(Codes) do
    s :=s+' '+Format('%-.2x',[Codes[i]]);
  Log.Write('����'+s,3);
end;

end.
