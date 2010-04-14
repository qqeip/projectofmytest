unit Ut_DataCollectThread;

interface

uses
  Windows, Classes, Log, SysUtils,DateUtils, IniFiles,
  Forms,Ut_BaseThread,ADODB,DB,Variants,UnitMosReader;

const
  ROLL_INTERVAL=300000;

type
  TAlarmArray = Array of Array of integer;
  
  TCollectThread = class(TMyThread)
  private
    { Private declarations }
    FAdoCon : TAdoConnection;
    FQuery,FQueryFree,FQueryDataCollect,FQueryAlarmContent : TAdoQuery;
    Sp_Alarm_FlowNumber: TADOStoredProc;
    MosReader :TMosReader;
    FIsConncetFtp : Boolean;
  protected
    procedure DoExecute; override;
    function ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer;
    // 0: δ֪  1���澯 2:
    function JudgeIsAlarm(ParamValue,AlarmValue,RemoveValue:String):integer;
    procedure JudgeAlarmContent(const comid,paramid :integer;ParamValue:String;var AlarmS:TAlarmArray);
    //����MTU������״̬
    procedure UpdateMtuStatus;
    //��ȡ¼���ļ�����MOSֵ
    procedure TreatmentMosValue;
    function ExecMySQL(TheQuery :TADOQUERY;sqlstr :String):integer;
    function GetSysDateTime():TDateTime;  //�õ����ݿ������ʱ��
  public
    constructor Create(ConnStr :String);
    destructor Destroy; override;
  end;

implementation
uses Ut_Global;

constructor TCollectThread.Create(ConnStr :String);
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

  FQueryDataCollect :=TAdoQuery.Create(nil);
  FQueryDataCollect.Connection := FAdoCon;

  FQueryAlarmContent :=TAdoQuery.Create(nil);
  FQueryAlarmContent.Connection := FAdoCon;

  Sp_Alarm_FlowNumber:= TADOStoredProc.Create(nil);
  with Sp_Alarm_FlowNumber do
  begin
    Close;
    Connection := FAdoCon;
    ProcedureName:='MTS_GET_FLOWNUMBER';
    Parameters.Clear;
    Parameters.CreateParameter('I_FLOWNAME',ftString,pdInput,100,null);
    Parameters.CreateParameter('I_SERIESNUM',ftInteger,pdInput,0,null);
    Parameters.CreateParameter('O_FLOWVALUE',ftInteger,pdOutput,0,null);
    Prepared;
  end;
  MosReader :=TMosReader.Create;
end;

destructor TCollectThread.destroy;
begin
  MosReader.Free;
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FQueryAlarmContent.Close;
  FQueryAlarmContent.Free;
  FQueryDataCollect.Close;
  FQueryDataCollect.Free;
  Sp_Alarm_FlowNumber.Close;
  Sp_Alarm_FlowNumber.Free;
  FAdoCon.Close;
  FAdoCon.Free;
  inherited destroy;
end;

procedure TCollectThread.DoExecute;
var
  sqlstr,sql_collect,sql_del :String;
  AlarmS:TAlarmArray;
  i,iCount :integer;
  AData :PThreadData;
  handleCount :integer;
begin
  sqlstr :=' select a.*,b.mtuid from mtu_testresult_online a'+
           ' inner join mtu_info b on a.mtuno=b.mtuno'+
           ' order by a.taskid,a.execid,a.comid,a.paramid,a.valueindex';
  sql_collect :=' select COLLECTID,taskid, execid, mtuid, alarmcontentcode, status, collecttime from alarm_data_collect';
  iCount :=0;
  handleCount :=0;
  if not FAdoCon.Connected then
  try
    FAdoCon.Connected := true;
  Except
    self.Log.Write('MTU�澯�ɼ��̴߳����������ݿ�ʧ�ܣ�',1);
    Exit;
  end;
  try
    //����MTU����״̬
    UpdateMtuStatus;
    //Mosֵ����
    TreatmentMosValue;
    //���Խ�������
    with FQueryDataCollect do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sql_collect);
      Open;
    end;
    //���Խ����
    with FQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      Open;
      First;
      while Not Eof do
      begin
        if (FieldByName('valueindex').AsInteger=0) and (Trim(FieldByName('TESTRESULT').AsString)<>'') then
        begin
          //��������š������š�ֵ �ж��Ƿ�澯״̬��ͬʱ��ȡ�澯���ݱ��
          JudgeAlarmContent(FieldByName('COMID').AsInteger,FieldByName('PARAMID').AsInteger,FieldByName('TESTRESULT').AsString,AlarmS);
          if AlarmS <> nil then
          begin
            for I := Low(AlarmS) to High(AlarmS) do
            begin
              if AlarmS[i,1] > 0 then
              begin
                FQueryDataCollect.Append;
                FQueryDataCollect.FieldByName('COLLECTID').Value := ProduceFlowNumID('COLLECTID',1);
                FQueryDataCollect.FieldByName('taskid').Value := FieldByName('taskid').AsInteger;
                FQueryDataCollect.FieldByName('execid').Value := FieldByName('execid').AsInteger;
                FQueryDataCollect.FieldByName('mtuid').Value := FieldByName('mtuid').AsInteger;
                FQueryDataCollect.FieldByName('alarmcontentcode').Value := AlarmS[i,0];
                FQueryDataCollect.FieldByName('status').Value := AlarmS[i,1];
                FQueryDataCollect.FieldByName('collecttime').Value := FieldByName('collecttime').AsDateTime;
                FQueryDataCollect.Post;
                Inc(iCount);
              end;
            end;
            SetLength(AlarmS,0);
          end;
        end;
        //д�Ѵ����ʶ
        Edit;
        FieldByName('ISPROCESS').AsInteger :=1;
        Post;
        Next;
      end;
    end;
    self.Log.Write('�ɼ��ɹ�����[ '+IntToStr(iCount)+' ]��',3);
  except
    on E:Exception do
    begin
      self.Log.Write('�ɼ�ʧ�ܣ�'+E.Message,1);
    end;
  end;

  FAdoCon.BeginTrans;
  try
    //�����Ѿ�������ֶ����Խ��
    //����ֶ����Խ��û�������ԣ���������ֶ����Խ�������ƶ��������߳���
    sql_del :='update mtu_testtask_online a set status=4'+
              ' where exists (select 1 from mtu_testresult_online b where a.taskid=b.taskid'+
              ' and b.Isprocess=1 and b.userid <>-1)';
    ExecMySQL(FQueryFree,sql_del);
    //���û��Ѿ�����Ĳ��Խ���ƶ����û���������ű���
    sql_del :='insert into mtu_usertestresult'+
              ' select a.* from mtu_testresult_online a'+
              ' inner join mtu_testtask_online b on a.taskid = b.taskid'+
              ' where a.Isprocess=1 and b.STATUS=4 and b.userid <>-1';
    handleCount := ExecMySQL(FQueryFree,sql_del);
    //������������ƶ�����ʷ��
    sql_del :='insert into mtu_testresult_history select * from mtu_testresult_online where Isprocess=1';
    ExecMySQL(FQueryFree,sql_del);
    //ɾ�����߱�����
    sql_del :='delete from mtu_testresult_online where Isprocess=1';
    ExecMySQL(FQueryFree,sql_del);
    FAdoCon.CommitTrans;
  except
     On E:Exception do
    begin
      FAdoCon.RollbackTrans;
      Log.Write('MTU�澯�ɼ��߳�������Խ�������쳣��'+E.Message,1);
      Log.Write(sql_del,1);
    end;
  end;
  if handleCount > 0 then
  begin
    New(AData);
    AData.command := 3;
    AData.cityid := 0;
    AData.Msg := '�ֶ�����';
    PostMessage(Application.MainForm.Handle, WM_SENDTHREAD_MSG, 0, Longint(AData));
  end;

  FAdoCon.Connected := false;
end;

function TCollectThread.ExecMySQL(TheQuery: TADOQUERY; sqlstr: String):integer;
begin
  result :=0;
  with TheQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add(sqlstr);
    result :=ExecSQL;
    close;
  end;
end;

function TCollectThread.GetSysDateTime: TDateTime;
begin
  with FQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add('select sysdate from dual');
    open;
    result:=fieldbyname('sysdate').asdatetime;
    close;
  end;
end;

procedure TCollectThread.JudgeAlarmContent(const comid, paramid: integer;
  ParamValue: String; var AlarmS:TAlarmArray);
var
  sqlstr :String;
  vIndex :integer;
begin
  try
    sqlstr :='select * from mtu_alarm_content where comid=:comid and paramid=:paramid and sendtype =0 and IFINEFFECT =1 order by alarmcontentcode';
    with FQueryAlarmContent do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      parameters.ParamByName('comid').Value := comid;
      parameters.ParamByName('paramid').Value := paramid;
      Open;
      if RecordCount >0 then
      begin
        vIndex :=0;
        SetLength(AlarmS,RecordCount);
        first;
        while not Eof do
        begin
          SetLength(AlarmS[vIndex],2);
          AlarmS[vIndex,0] := FieldByName('ALARMCONTENTCODE').AsInteger;
          if (Trim(FieldByName('ALARMCONDITION').AsString)<>'') and (Trim(FieldByName('REMOVECONDITION').AsString)<>'') then
            AlarmS[vIndex,1] := JudgeIsAlarm(ParamValue,FieldByName('ALARMCONDITION').AsString,FieldByName('REMOVECONDITION').AsString)
          else
            AlarmS[vIndex,1] :=0;
          Next;
          Inc(vIndex);
        end;
      end;
      Close;
    end;
  except

  end;
end;
//// 0: δ֪  1���澯 2:����
function TCollectThread.JudgeIsAlarm(ParamValue,AlarmValue, RemoveValue: String): integer;
var
  sqlstr :string;
begin
  result :=0;
  sqlstr :='select 1 from dual where ';
  AlarmValue :=StringReplace(AlarmValue, '@Value',ParamValue, [rfReplaceAll, rfIgnoreCase]);
  RemoveValue :=StringReplace(RemoveValue, '@Value',ParamValue, [rfReplaceAll, rfIgnoreCase]);
  try
    with FQueryFree do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr+AlarmValue);
      Open;
      if IsEmpty then
      begin
        Close;
        SQL.Clear;
        SQL.Add(sqlstr+RemoveValue);
        Open;
        if not IsEmpty then
          result :=2;
      end
      else
        result :=1;
      Close;
    end;
  Except
    On E :Exception do
      self.Log.Write('�ж��Ƿ�澯ʱ�쳣:'+E.Message,1);
  end;
end;

function TCollectThread.ProduceFlowNumID(I_FLOWNAME: string;
  I_SERIESNUM: integer): Integer;
begin
  with Sp_Alarm_FlowNumber do
  begin
    close;
    Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //��ˮ������
    Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //�����������ˮ�Ÿ���
    execproc;
    result:=Parameters.parambyname('O_FLOWVALUE').Value; //����ֵΪ���ͣ�����ֻ�������еĵ�һ��ֵ�����´η���ֵΪ��result+I_SERIESNUM
    close;
  end;
end;

//����MOSֵ�����
procedure TCollectThread.TreatmentMosValue;
const
  SQLMOS =' select a.taskid,a.mtuno,a.comid,a.cityid,a.execid,'+
          ' a.testresult as PlayVoice ,b.testresult as RecordVoice'+
          ' from mtu_testresult_online a'+
          ' inner join mtu_testresult_online b on a.taskid= b.taskid and a.comid=b.comid'+
          ' and a.execid=b.execid and a.execid =b.execid'+
          ' where a.paramid=21 and b.paramid=22';
  SQLINS =' insert into mtu_testresult_online(taskid, cityid, mtuno, comid, paramid, valueindex, testresult, collecttime, execid, isprocess)'+
          ' values (%d, %d, %s, %d, %d, %d, %s, sysdate, %d, 0)';
  SQLFTP =' select * from mtu_controlconfig where ftpip is not null';
var
  MosValue,LogStr :string;
begin
  with FQueryFree do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLFTP);
    Open;
    //ѭ������
    while not eof do
    begin
      FIsConncetFtp := MosReader.ConnectToFTP(FieldByName('username').AsString,
                       FieldByName('passwd').AsString,FieldByName('ftpip').AsString,
                       FieldByName('ftpport').AsInteger);
      //�Ƿ�������FTP
      if FIsConncetFtp then
      begin
        try
          FQuery.Close;
          FQuery.SQL.Text := SQLMOS+ ' and a.cityid='+FieldByName('cityid').AsString;
          FQuery.Open;
          //ѭ��ĳ���е�MOS���Խ��������
          while not FQuery.Eof do
          begin
            case MosReader.GetMos(FQuery.FieldByName('playvoice').AsString,
                        FQuery.FieldByName('recordvoice').AsString,
                        FieldByName('ftppath').AsString,MosValue) of
              1: ExecMySQL(FQueryDataCollect,Format(SQLINS,
                               [FQuery.FieldByName('taskid').AsInteger,
                                FQuery.FieldByName('cityid').AsInteger,
                                QuotedStr(FQuery.FieldByName('mtuno').AsString),
                                FQuery.FieldByName('comid').AsInteger,FQuery.FieldByName('paramid').AsInteger,
                                FQuery.FieldByName('valueindex').AsInteger,FQuery.FieldByName('execid').AsInteger]));
              -1: Log.Write(LogStr+'���ز�����MOSĿ¼',1);
              -3: Log.Write(LogStr+'�����ļ�ʧ��',1);
              -4: Log.Write(LogStr+'�����ⲿ����ʧ��',1);
              -5: Log.Write(LogStr+'�����õ��ļ�����򲻴���',1);
            end;
          end;
          //�Ƿ��޸Ľ��������
        finally
          if not MosReader.DisConnectToFTP then
            Log.Write('���б��Ϊ'+FieldByName('cityid').AsString+'�Ͽ�FTPʧ��',1);
        end;
      end
      else
      begin
        Log.Write('���б��Ϊ'+FieldByName('cityid').AsString+'�������ӵ�FTP',1);
      end;
    end;
  end;
end;

procedure TCollectThread.UpdateMtuStatus;
var
  sqlstr,sql_status :string;
  CurTime :TDateTime;
begin
  sqlstr :=' select b.mtuid,decode(TESTRESULT,''1'',1,''0'',0) as status '+
           ' from mtu_testresult_online a'+
           ' inner join mtu_info b on a.mtuno=b.mtuno'+
           ' where (comid=68 or comid=136) and paramid=35 and valueindex=0';
  sql_status :='select * from mtu_status_list ';
  CurTime :=GetSysDateTime;
  with FQueryFree do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sql_status);
    Open;
  end;

  with FQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    Open;
    if RecordCount > 0 then
    begin
      First;
      while Not Eof do
      begin
        Log.Write('MTUID= '+FieldByName('MTUID').AsString+' Status='+FieldByName('STATUS').AsString,3);
        if not FQueryFree.Locate('MTUID',FieldByName('MTUID').AsInteger,[loCaseInsensitive]) then
        begin
          FQueryFree.Append;
          FQueryFree.FieldByName('MTUID').AsInteger := FieldByName('MTUID').AsInteger;
        end
        else
          FQueryFree.Edit;
        FQueryFree.FieldByName('STATUS').AsInteger :=FieldByName('STATUS').AsInteger;
        FQueryFree.FieldByName('UPDATETIME').AsDateTime :=CurTime;
        FQueryFree.Post;
        Next;
      end;                  
      Close;
    end;
  end;
  FQueryFree.Close;
end;

end.
