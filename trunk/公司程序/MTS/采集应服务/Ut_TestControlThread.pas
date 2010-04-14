{ ****************************************************
  ������������߳� (cyx)
  1���������ݿ��еĴ���(δ���͡��ѷ��͵�δ�ظ��յ�����)������.
  2�����ݴ���������ѡ����MTU�������֯���������Ϣ���ݡ�
  3������MTU����������ѡ����MTU����������,д�ѷ��ͱ�ʶ��
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
    //��ȡδ��������
    function GetTaskNoTest:boolean;
    //��ȡ���Ա�������
    function GetTestEnCode(TaskID,CommandId :integer;MtuNo:String;var EnCode:TIdBytes):boolean;
    //�����ݼ����ȡָ������ֵ
    function GetParamValue(FDataSet:TDataSet;ParamId :integer):String;

    procedure ExecMySQL(FMyQuery:TAdoQuery;FSQL:String);
    procedure PrintEnCode(Codes :TIdBytes);
    //��������������߱�
    procedure SaveTestTaskHistroy(aTaskID :integer);
    //ɾ�������������߱�
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

//������񲢲���
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
    FLog.Write('������������߳��쳣: �޷��������ݿ�!',1);
    Exit;
  end;
  //�����ȡ����������
  if GetTaskNoTest then
  begin
    with FQuery do
    begin
      first;
      while not Eof do
      begin
        //�����ȡ����ɹ�,������������
        if GetTestEnCode(FieldByName('TaskID').AsInteger,FieldByName('comid').AsInteger,FieldByName('MtuNo').AsString,EnCode) then
        begin
          //��ӡ����
          //PrintEnCode(EnCode);
          //�ҵ���Ӧ��MTU���������Ͳ�������
          with MtuClients.LockList do
          try
            for I := 0 to Count - 1 do
            begin
              P := TMtuDataProcess(Items[i]);
              if (P.Context <> nil) and (P.Cityid = FieldByName('cityid').AsInteger) then
              begin
                P.Context.Connection.IOHandler.Write(EnCode);
                if FieldByName('userid').AsInteger=-1 then   //�Զ����Ծ�ֱ��ɾ��
                begin
                  SaveTestTaskHistroy(FieldByName('TaskID').AsInteger);
                  DelTestTaskOnline(FieldByName('TaskID').AsInteger);
                end else
                begin
                  //д���ѷ��ͱ�־
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
        Sleep(10);   //������֤������Ҫ1S
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
    Log.Write('���²��������ͱ�ʶʱʧ��!-'+E.Message,1);
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
    Log.Write('��ȡMTU����������ʧ��!',1);
  end;
end;
//��������š�����š�MTU�Ż�ȡ����������������
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
      //���ݲ�ͬ��������������������
      case CommandId of
        MTU_TEST_CALL : //���в�������
          begin
            Mtu := TMtuCall.create(true);
            TMtuCall(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuCall(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuCall(Mtu).TalkDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TALK_DURATION));
          end;
        MTU_TEST_MOS : //MOSֵ��������
          begin
            Mtu := TMtuMos.create(true);
            TMtuCall(Mtu).Caller :=GetParamValue(FQuery_Free,MTUPARAM_CALLER);
            TMtuCall(Mtu).Callee :=GetParamValue(FQuery_Free,MTUPARAM_CALLEE);
            TMtuMos(Mtu).PlayVoice :=GetParamValue(FQuery_Free,MTUPARAM_PLAY_VOCFILE);
          end;
        MTU_TEST_VOICE : //������ͨ��������
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
        MTU_TEST_WLAN_SPEED : //WLAN���ʲ�������
          begin
            Mtu := TMtuWLanSpeed.create(true);
            TMtuWLanSpeed(Mtu).TestDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TEST_DURATION));
          end;
        MTU_TEST_WLAN_DELAY :  //WLANʱ�ӡ������������ʲ�������
          begin
            Mtu := TMtuWLanDelay.create(true);
            TMtuWLanDelay(Mtu).TestDuration :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_TEST_DURATION));
            TMtuWLanDelay(Mtu).REQUENCY :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_FREQUENCY));
            TMtuWLanDelay(Mtu).PingDest :=GetParamValue(FQuery_Free,MTUPARAM_PING_DEST);
          end;
        MTU_GET_STATUS :  //WLANʱ�ӡ������������ʲ�������
          begin
            Mtu := TMtuGetStatus.create(true);
            TMtuGetStatus(Mtu).SearchFlag :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_SEARCH_FLAG));
          end;
        MTU_SET_PARAMETER :  //����MTU������
          begin
            Mtu :=TMtuSetParam.create;
            TMtuSetParam(Mtu).MTUDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_MTU_DURATION));
            TMtuSetParam(Mtu).CCHDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_CCH_DURATION));
            TMtuSetParam(Mtu).WLanDURATION :=StrToInt(GetParamValue(FQuery_Free,MTUPARAM_WLAN_DURATION));
          end;
        MTU_STOP_TASK :  //ֹͣ�������� δ����
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
        //ȡ����������
        result := Mtu.GetTestEnCode(EnCode);
      end;
    end;
    FQuery_Free.Close;
  Except
    On E:Exception do
      Log.Write('������Ա���ʧ��:[Taskid:'+IntToStr(TaskId)+']'+E.Message,1);
  end;
end;

procedure TTestControlThread.PrintEnCode(Codes: TIdBytes);
var
  i : integer;
  s :string;
begin
  for I := Low(Codes) to High(Codes) do
    s :=s+' '+Format('%-.2x',[Codes[i]]);
  Log.Write('����'+s,3);
end;

procedure TTestControlThread.SaveTestTaskHistroy(aTaskID: integer);
var
  lSqlstr:string;
begin
  lSqlstr:='insert into mtu_testtask_histroy select * from mtu_testtask_online where taskid='+inttostr(aTaskID);
  ExecMySQL(FQuery_Free,lSqlstr);
end;

end.
