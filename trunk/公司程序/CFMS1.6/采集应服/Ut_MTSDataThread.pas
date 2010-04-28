unit Ut_MTSDataThread;

interface

uses
  Classes,ADODB,DB,Variants,SysUtils,ComCtrls,Windows,Controls,StrUtils,Forms;

type
  TRemoteSource = record
    RemoteConn: string;
    CityID : integer;
    SetValue : integer;
    NetAddressSplit :String;
  end;

  TMTSDataThread = class(TThread)
  private
    AdoQDy :TAdoQuery;
    Ado_LocalConn: TADOConnection;
    Ado_RemoteConn: TADOConnection;
    Ado_LocalQuery: TADOQuery;
    Ado_RemoteQuery: TADOQuery;
    //�����Ҫͬ����MTS����Ϣ
    RemoteSource : array of TRemoteSource;
    MessageContent,TableName : String;
    ButtonIsEnable:Boolean;

    procedure SetName;
    //ͬ��MTS�豸��Ϣ
    procedure SynData;
    procedure OpenTheDataSet(TheADOQuery: TADOQuery; thesql: string);
    procedure MTS_IsEnable;
    function GetRemoteTableName(cityid: integer): String;
    function SynchronizeData(cityid: integer; aTableName: String): Integer;
    procedure AppendRunLog;
  protected
    procedure Execute; override;
  public
    bStop : Boolean;//�Ƿ���ֹ
    constructor Create(LocalConn:String);
    destructor Destroy;override;
  end;

implementation

uses Ut_RunLog,Ut_Flowtache_Monitor;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TMTSDataThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;
{$ENDIF}

{ TMTSDataThread }

procedure TMTSDataThread.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'TMTSDataThread';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;

procedure TMTSDataThread.Execute;
begin
  SetName;
  { Place thread code here }
  while (not terminated) do
  begin
    try
      //ͬ����
      SynData;
    finally
      Suspend;
    end;
  end;
end;

procedure TMTSDataThread.SynData;
var
  i,j,iCount,CurrConn: integer;
  starttime,endtime:TTime;
  lTalbeName:String;
begin
  starttime := now;
  try
    ButtonIsEnable:=false;
    Synchronize(MTS_IsEnable);
    for CurrConn:=Low(RemoteSource) to High(RemoteSource) do
    begin
     iCount := 0;
     Ado_RemoteConn.Connected:=false;
     Ado_RemoteConn.ConnectionString:=RemoteSource[CurrConn].RemoteConn;
     Ado_RemoteConn.Connected:=true;
     lTalbeName:=GetRemoteTableName(RemoteSource[CurrConn].cityid);
     SynchronizeData(RemoteSource[CurrConn].cityid,lTalbeName);
     endtime := now;
     MessageContent:=datetimetostr(now)+'   �ɹ�ͬ���� cityid = '+IntToStr(RemoteSource[CurrConn].cityid)+' ��MTS���е�'+lTalbeName+',������ʱ�䣺'+timetostr(endtime-starttime);
     Synchronize(AppendRunLog);
    end;
  except
    MessageContent:=datetimetostr(now)+'   ���ԡ�ͬ��MTS�����̡߳�����Ϣ����ͬ��ͳ��ʧ�ܣ���֪ͨϵͳ����Ա����';
    Synchronize(AppendRunLog);
  end;
  TableName := '';
  ButtonIsEnable:=true;
  Synchronize(MTS_IsEnable);
end;

procedure TMTSDataThread.AppendRunLog;
begin
    if Fm_RunLog = nil then Exit;
    Fm_RunLog.Re_RunLog.Lines.Add(MessageContent);
end;

function TMTSDataThread.SynchronizeData(cityid:integer;aTableName:String):Integer;
var
  i : integer;
  sqlstr : String;
  lareaid,locationid,lSUBSTATIONID,lSUBSTATIONTOPID:integer;
  function GetIdFromarea(aAreaName:String;alevel:integer):Integer;
  begin
    Result:=0;
    sqlstr:='select id from pop_area t where t.cityid='+inttostr(cityid)+' and t.name='+Quotedstr(aAreaName)+
            ' and t.layer='+inttostr(alevel);
    with Ado_LocalQuery do
    begin
       Close;
       SQL.Clear;
       SQL.Add(sqlstr);
       Open;
       if RecordCount > 0 then Result:=fieldByname('id').AsInteger
       else Result:=0;
    end;
  end;
  function Getsubstationid(aBranchName:String;alocationid:Integer):Integer;
  begin
    Result:=0;
    sqlstr:='select id from pop_branch t where t.cityid='+inttostr(cityid)+' and t.name='+Quotedstr(aBranchName)+
            ' and AREA_ID='+inttostr(alocationid);
    with Ado_LocalQuery do
    begin
       Close;
       SQL.Clear;
       SQL.Add(sqlstr);
       Open;
       if RecordCount > 0 then Result:=fieldByname('id').AsInteger
       else Result:=0;
    end;
  end;
begin
  result := 0;
  try
    lareaid:=GetIdFromarea('MTU�澯����',2);
    locationid:=GetIdFromarea('MTU�澯�־�',3);
    if locationid=0 then lSUBSTATIONTOPID :=lareaid else lSUBSTATIONTOPID := locationid;
    lSUBSTATIONID:=Getsubstationid('MTU',lSUBSTATIONTOPID);
    //��ȡ����MTS�豸��Ϣ
    sqlstr:='Select nodeaddress,cityid,cityname,csid,csname,SUBSTATIONID,SUBSTATION,LOCATIONID,LOCATION,AREA_ID,AREA,'+
            'CS_ADDRESS,CS_STATUS_ID,CS_STATUS,LEVELFLAGCODE,LEVELFLAG,SURVEY_ID,DEVICETYPE,SUBSTATIONTOPID '+
            ' from alarm_cs_detail_view where nvl(devicetype,1)=2 and cityid='+inttostr(cityid);
    with Ado_LocalQuery do
    begin
        Close;
        SQL.Clear;
        SQL.Add(sqlstr);
        Open;
        if RecordCount > 0 then First;
    end;
    //MTS�ⲻ��Ҫ�Ӳ�ѯ����������Ҫ�ֹ���ֵcityid
    sqlstr:='select mtuno as nodeaddress,'+inttostr(cityid) +' as cityid,cityname cityname,mtuid csid,mtuname csname,'+
            inttostr(lSUBSTATIONID)+' as SUBSTATIONID,''MTU'' SUBSTATION,'+
            inttostr(locationid)+' as locationid,''MTU�澯�־�'' location,' +inttostr(lareaid)+' as AREA_ID,''MTU�澯����'' AREA,'+
            'Mtu_address CS_ADDRESS,4 CS_STATUS_ID,''��ͨ'' CS_STATUS,6 LEVELFLAGCODE,''MTU�ȼ�'' LEVELFLAG,'+
            ' mtuname SURVEY_ID,2 DEVICETYPE, '+inttostr(lSUBSTATIONTOPID)+' SUBSTATIONTOPID ' +
            ' from @Tablename ';
    //�滻@table ���õ�Զ�̱���
    sqlstr:=StringReplace(sqlstr, '@Tablename',aTableName, [rfReplaceAll, rfIgnoreCase]);
    with Ado_RemoteQuery do
    begin
        Close;
        SQL.Clear;
        SQL.Add(sqlstr);
        Open;
        if RecordCount <= 0 then Exit;
    end;
    except
      MessageContent:=datetimetostr(now)+'   ��ȡ cityid = '+IntToStr(cityid)+' ��MTS���е� '+aTableName+' ����ʧ��,����ϵϵͳ����Ա!';
      Synchronize(AppendRunLog);
    end;

    Ado_LocalConn.BeginTrans;
    try
      //ɾ�������ж�MTS����û�еļ�¼
      with Ado_LocalQuery do
      begin
        if not IsEmpty then
        begin
          first;
          while not eof do
          begin
            //���û���ж�Ӧ�ļ�¼
            if not Ado_RemoteQuery.Locate('NODEADDRESS',FieldByName('NODEADDRESS').AsString,[loCaseInsensitive]) then
                Ado_LocalQuery.Delete;
            Next;
            Application.ProcessMessages;
          end;
        end
      end;
      //����MTS�����ж�����û�е���Ϣ  �����MTS�б����е���Ϣ
      with Ado_RemoteQuery do
      begin
          if not IsEmpty then
          begin
            first;
            while not eof do
            begin
              //����ж�Ӧ�ļ�¼
              if Ado_LocalQuery.Locate('NODEADDRESS',FieldByName('NODEADDRESS').AsString,[loCaseInsensitive]) then
              begin
                  Ado_LocalQuery.Edit;
                  for i := 0 to Fields.Count -1 do
                      Ado_LocalQuery.Fields[i].Value := Fields[i].Value;
                  Ado_LocalQuery.Post;
              end
              else //û��������
              begin
                  Ado_LocalQuery.Append;
                  for i := 0 to Fields.Count -1 do
                     Ado_LocalQuery.Fields[i].Value := Fields[i].Value;
                  Ado_LocalQuery.Post;
              end;
              Next;
              Application.ProcessMessages;
            end;
          end;
      end;
      Ado_LocalConn.CommitTrans;
      result := 1;
    except
      Ado_LocalConn.RollbackTrans;
      MessageContent:=datetimetostr(now)+'   ͬ�� cityid = '+IntToStr(cityid)+' ��MTS���е� '+aTableName+' ʧ�ܣ�����ϵϵͳ����Ա!';
      Synchronize(AppendRunLog);
    end;
end;

function TMTSDataThread.GetRemoteTableName(cityid: integer): String;
begin
  result :='';
  with AdoQDy do
  begin
    Close;
    SQL.Clear;
    SQL.Add(' select increment_column as Tablename from alarm_collection_cyc_list where COLLECTIONKIND = 15 and cityid =:cityid ');
    Parameters.ParamByName('cityid').Value :=cityid;
    Open;
    if RecordCount = 0 then Exit;
    if Trim(FieldByName('Tablename').AsString)<>'' then
      result := FieldByName('Tablename').AsString
  end;
end;

procedure TMTSDataThread.MTS_IsEnable;
begin
  Fm_FlowMonitor.Btn_MTS.Enabled:=ButtonIsEnable;
end;

constructor TMTSDataThread.Create(LocalConn: String);
var
  sqlstr:String;
  i:integer;
begin
  inherited Create(true);
  //��������(FMS)
  Ado_LocalConn := TADOConnection.Create(nil);
  Ado_LocalConn.LoginPrompt := false;
  Ado_LocalConn.ConnectionString := LocalConn;

  Ado_LocalQuery := TAdoQuery.Create(nil);
  Ado_LocalQuery.CommandTimeout := 70;
  Ado_LocalQuery.Connection := Ado_LocalConn;
  //��̬��ѯ
  AdoQDy:= TAdoQuery.Create(nil);
  AdoQDy.Connection :=Ado_LocalConn;
  //��ʼ��MTS����Ϣ
  sqlstr:=' select Last_DataSource,increment_column,cityid,SetValue from alarm_collection_cyc_list where collectionkind=15 order by collectioncode ';
  OpenTheDataSet(Ado_LocalQuery,sqlstr);
  with Ado_LocalQuery do
  begin
     SetLength(RemoteSource, Recordcount);
     first;   i:=0;
     while not eof do
     begin
       RemoteSource[i].RemoteConn:=fieldbyname('Last_DataSource').AsString;
       //RemoteSource[i].RemoteTable :=ReturnPopTableList(fieldbyname('CityID').AsInteger);
       RemoteSource[i].CityID:=fieldbyname('CityID').AsInteger;
       RemoteSource[i].NetAddressSplit := FieldByName('increment_column').AsString;
       inc(i);
       next;
     end;
  end;
  //��ʼ������Դ����(POP)
  Ado_RemoteConn := TADOConnection.Create(nil);
  Ado_RemoteConn.LoginPrompt:=false;
  Ado_RemoteQuery := TAdoQuery.Create(nil);
  Ado_RemoteQuery.Connection := Ado_RemoteConn;
end;

procedure TMTSDataThread.OpenTheDataSet(TheADOQuery: TADOQuery;
  thesql: string);
begin
  with TheADOQuery do
  begin
    close;
    sql.Clear;
    sql.Add(thesql);
    open;
  end;
end;

destructor TMTSDataThread.Destroy;
begin
  Ado_RemoteQuery.Close;
  Ado_RemoteQuery.Free;
  if Ado_LocalQuery <> nil then
  begin
    Ado_LocalQuery.Close;
    Ado_LocalQuery.Free;
  end;
  AdoQDy.Close;
  AdoQDy.Free;
  Ado_RemoteConn.Connected := false;
  Ado_RemoteConn.Free;
  inherited;
end;

end.
