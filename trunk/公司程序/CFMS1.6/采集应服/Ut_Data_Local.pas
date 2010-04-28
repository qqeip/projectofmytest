unit Ut_Data_Local;

interface

uses
  SysUtils, Classes, DB, ADODB, DBClient, Provider, Windows, Variants,  MD5,
  IdBaseComponent, IdComponent, IdTCPServer, Forms, ADOInt, Controls,StrUtils,
  MConnect, SConnect,Ut_PubObj_Define,AlarmServiceApp_TLB;


//��ϵͳ�ӿ� �ṹ��
type
  TInterFaceSource = record
    RemoteConn: string;  // ��ϵͳ���ݿ�������Ϣ
    CityID : integer;
    EventType : integer; //����ӿڵ��¼����ͣ����ֲ�ͬ��ϵͳ��ҵ�����:  1- ����10000��;2- һվʽ
    SystemID :integer;   //��ϵͳ���������ϵͳ�ı��
    QUCode :integer;     //������ �� 0751
    LevelCode :String;   //��ϵͳ���յĻ�վ�ȼ���Ϣ
    collectioncode :integer; //��ϵͳ���ӱ��
    AlarmContentFilter:String;  // ��Ҫ���˵��ĸ澯����
  end;
type
  TSendTimeList = record
    TimeList : TStringList;
    CsLevelCode: integer;
    AllowSend : boolean;
    SA_StartTime : string;   //һ����������ʼʱ��
    SA_EndTime : string;     //һ�������Ͻ���ʱ��
  end;

  TTheAreaAlarmParam = record//���Ϲ���ȫ�ֽṹ
    Cs_Status_Str : string;  //��վ״̬����
    Cs_Area_Str : string;    //��վ�����������
    Cs_Power_Str : string;   //��վ���緽ʽ����
    ManualLimit : string;  //��Ԥʱ��
    
    SA_StartTime : string;   //һ����������ʼʱ��
    SA_EndTime : string;     //һ�������Ͻ���ʱ��
    IsAutoWrecker : integer; //�Ƿ��Զ�����
    IsAutoSend : boolean;    //������ʽ�����Զ����ϻ��Ƕ������� ,trueΪ��ʱ���ϣ�falseΪ��������
    sendtimeList: Array of TSendTimeList; //����ʱ���
    SendDateList: Array of TSendTimeList; //�������������б�
    WeekSendList: Array of record Code : integer; SetValue : boolean; end; //ÿ�������б�
    WarnCount :Integer;      //Ԥ���� Ͻ��Ԥ��
    WarnCount_CSC :integer;  // ��������Ԥ����
    WarnConent :String; // Ԥ��
  end;

  TAlarmParam = record   //Ƕ�׼�¼���ͣ��洢��
    CityID:integer;
    CityName:string;
    TodayIsSend :boolean;
    CityParam:TTheAreaAlarmParam;
    TestIP :String;    //�澯����
    TestPort :Integer; //�澯����

  end;

  TCsLevelLimitedHour = record
    CsLevel,
    LimitedHour:integer
  end;
  //���ò���
  TPublicParam = Record
    ClearLog_Time,
    ClearLog_Day,
    IsAutoClearLog,
    RepStatTime,
    IsAutoStatRep,
    IsAutoSynPOP,
    IsAutoSyn10000,
    SA_StartTime,   //һ����ʡ�ֿ�����ʼʱ��
    SA_EndTime : string;     //һ����ʡ�ֿ��˽���ʱ��
    CollectIsModify : boolean;  //
    CSExamTimeLimit: array of TCsLevelLimitedHour;
  end;

  TDm_Collect_Local = class(TDataModule)
    Ado_Dynamic: TADOQuery;
    Ado_Free: TADOQuery;
    Ado_Collection_Cyc: TADOQuery;
    Ds_Collection_Cyc: TDataSource;
    Ado_Collection_Cfg: TADOQuery;
    Ds_Collection_Cfg: TDataSource;
    Ado_Synchronize_Cfg: TADOQuery;
    Ds_Synchronize_Cfg: TDataSource;
    ADO_SynchronizePOP: TADOQuery;
    Ds_SynchronizePOP: TDataSource;
    Ds_AlarmTest: TDataSource;
    Ado_AlarmTest: TADOQuery;
    Ado_Conn: TADOConnection;
    Sc_Client: TSocketConnection;
    Cb_Client: TConnectionBroker;
    ADO_temp: TADOQuery;
    procedure SynchronizationSysTime;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure Sc_ClientAfterConnect(Sender: TObject);
    procedure Sc_ClientAfterDisconnect(Sender: TObject);
  private
    //��ʼ�� ��ϵͳ��Ϣ
    procedure InitInterfaceSource;
    // ��ȡ������ϵͳ�Ļ�վ�ȼ���Ϣ
    function GetInitInterfaceFilter(id,cityid:Integer):String;

    { Private declarations }
  public
    AlarmServer : Variant;
    TempInterface: ICollectServerDisp;
    Operator:string;
    AlarmParam : Array of TAlarmParam;
    PublicParam :TPublicParam;

    InterFaceSource : Array of TInterFaceSource;  //�����ϵͳ��Ϣ
    
    Function GetCitySN(CityID:integer):integer;

    function LogEntry(Dig: MD5Digest): string;

    function LogIn(bAliasName,sPassword:String) :Boolean;

    function GetSysDateTime():TDateTime;  //�õ����ݿ������ʱ��

    function ConfigDBConn(IsNew:boolean=true; EditedConnStr:string=''):String;
    function GetTimeLimitFromCsLevel(CsLevel:integer):integer; //���ݻ�վ�ȼ��õ�ʡ�ֹ��ϻ�վ�޸�ʱ��

    function ConnectDB: boolean;  
    { Public declarations }
  end;

var
  Dm_Collect_Local: TDm_Collect_Local;

implementation

uses Ut_Collection_Data, Ut_RunLog, Ut_Main_Build,
  Ut_ComponentFactory,MSDASC_TLB;

{$R *.dfm}
function TDm_Collect_Local.LogEntry(Dig: MD5Digest): string;
begin
  Result := Format('%s', [MD5Print(Dig)]);
end;

Function TDm_Collect_Local.GetCitySN(CityID:integer):integer;
var
  i:integer;
begin
  Result:=-1;
  for i:=low(AlarmParam) to high(AlarmParam) do
  if AlarmParam[i].CityID=CityID then
  begin
    Result:=i;
    break;
  end;
end;

function TDm_Collect_Local.LogIn(bAliasName, sPassword: String): Boolean;
var
  sqlString,PassWord:String;
begin
  result := false;
  PassWord := LogEntry(MD5String(String(bAliasName)+String(sPassword)));
  sqlString := 'select UserID,UserName from UserInfo where UserNo=' + '''' + bAliasName + ''' and ';
  sqlString := sqlString + ' userpwd=' + '''' + PassWord + '''';
  with Ado_Dynamic do
  begin
    Close;
    SQL.Clear;
    SQl.Add(sqlString);
    Open;
    if RecordCount > 0 then
      Result := true;
  end;
end;

function TDm_Collect_Local.GetSysDateTime():TDateTime;
begin
  with Ado_Dynamic do
  begin
    close;
    SQL.Clear;
    SQL.Add('select sysdate from dual');
    open;
    result:=fieldbyname('sysdate').asdatetime;
    close;
  end;
end;

procedure TDm_Collect_Local.SynchronizationSysTime;
var
  ServerTime : TSystemTime;                  //ϵͳʱ��
  Today: tdatetime;
begin
  today:=GetSysDateTime;  // ��ȡϵͳʱ��
  DateTimeToSystemTime(today,ServerTime);
  SetLocalTime(ServerTime);      //���ñ���ʱ��ͬ��Serverϵͳʱ��
end;

procedure TDm_Collect_Local.DataModuleCreate(Sender: TObject);
begin
  with Fm_Main_Build_Server.ServiceInfo do
  begin
    Sc_Client.ServerGUID := ServerGUID;
    Sc_Client.Address := ServerIP;
    Sc_Client.Port := DBPort;
    try
      //Sc_Client.Open;        -------------------------------------------------
    except
      Application.MessageBox('�������Ϸ���ʧ��,���ϡ����ϡ�ʵʱͳ�ƽ��޷����͸����Ϸ���!', '����', MB_OK + MB_ICONINFORMATION);
    end;
  end;
  Ado_Conn.ConnectionString:=Fm_Main_Build_Server.ConnectionString;

end;

procedure TDm_Collect_Local.DataModuleDestroy(Sender: TObject);
var i,j:integer;
begin
  for i := Low(AlarmParam) to High(AlarmParam) do
    for j:=0 to high(AlarmParam[i].CityParam.sendtimeList) do
    begin
      if AlarmParam[i].CityParam.sendtimeList[j].TimeList<>nil then
         AlarmParam[i].CityParam.sendtimeList[j].TimeList.Free;
    end;
  SetLength(InterFaceSource,0);
end;

function TDm_Collect_Local.ConfigDBConn(IsNew: boolean;
  EditedConnStr: string): String;
var
   DataSourceLocator : IDataSourceLocator;
   ADOConn : IDispatch;
   ADODbConn : TADOConnection;
begin
   ADODbConn := TADOConnection.Create(self);
   ADODbConn.ConnectionString := EditedConnStr;
   DataSourceLocator  :=  CoDataLinks.Create;     //�����ӿ�ָ��
   try
     if IsNew then //Ϊtrue���������ã�Ϊfalse�༭����
     begin
       ADOConn  :=  DataSourceLocator.PromptNew;      //�����ô���
       ADODbConn.ConnectionObject  :=  IDispatch(ADOConn)  as  _Connection;//��ֵ��ADOConnection
     end else
     try
       ADOConn:=IDispatch(ADODbConn.ConnectionObject);
       DataSourceLocator.PromptEdit(ADOConn);
     except
       on E : Exception do
          raise Exception.Create('����ʶ�����е����ݿ����Ӵ�������<�ؽ����ݿ�����>�������������ݿ����Ӵ���');
     end;
   finally
     Result:=ADODbConn.ConnectionString;
     DataSourceLocator  :=  nil;        //�����ͷŰ�
     ADODbConn.Free;
   end;
end;

function TDm_Collect_Local.GetTimeLimitFromCsLevel(
  CsLevel: integer): integer;
var
  i:integer;
begin
  Result:=8;
  with Dm_Collect_Local.PublicParam do
  for i:=low(CSExamTimeLimit) to high(CSExamTimeLimit) do
  if CsLevel=CSExamTimeLimit[i].CsLevel then
  begin
    Result:=CSExamTimeLimit[i].LimitedHour;
    break;
  end;
end;

// ��ȡ������ϵͳ�Ļ�վ�ȼ���Ϣ ���� ���˸澯����
function TDm_Collect_Local.GetInitInterfaceFilter(id,cityid:Integer):String;
var
  sqlstr :String;
begin
  result :='-1';
  sqlstr := ' select setvalue from alarm_sys_function_set where kind = 16 and code = :code and cityid=:cityid';
  with Ado_Free do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    Parameters.ParamByName('cityid').Value := cityid;
    Parameters.ParamByName('code').Value := ID;
    Open;
    if RecordCount > 0 then
      result := Trim(FieldByName('setvalue').AsString);
    Close;
  end;
end;

//��ʼ����ϵͳ�ӿ���Ϣ
procedure TDm_Collect_Local.InitInterfaceSource;
var
  i :integer;
begin
  with Ado_Dynamic do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select collectioncode,Last_DataSource,cityid,setvalue,increment_column,TABLENAME from alarm_collection_cyc_list where collectionkind =14');
    Open;
    if RecordCount = 0 then Exit;
    SetLength(InterFaceSource, Recordcount);
    first;   i:=0;
    while not eof do
    begin
      InterFaceSource[i].RemoteConn:=fieldbyname('Last_DataSource').AsString;
      InterFaceSource[i].CityID :=fieldbyname('CityID').AsInteger;
      InterFaceSource[i].EventType :=fieldbyname('SetValue').AsInteger;
      if fieldbyname('increment_column').AsString ='' then
        InterFaceSource[i].SystemID :=0
      else
        InterFaceSource[i].SystemID :=fieldbyname('increment_column').AsInteger;
      InterFaceSource[i].LevelCode := GetInitInterfaceFilter(1,fieldbyname('CityID').AsInteger);
      InterFaceSource[i].AlarmContentFilter := GetInitInterfaceFilter(2,fieldbyname('CityID').AsInteger);
      InterFaceSource[i].collectioncode := fieldbyname('collectioncode').AsInteger;
      if Trim(fieldbyname('TABLENAME').AsString) ='' then
        InterFaceSource[i].QUCode :=0
      else
        InterFaceSource[i].QUCode :=fieldbyname('TABLENAME').AsInteger;
      inc(i);
      next;
    end;
    Close;
  end;
end;

procedure TDm_Collect_Local.Sc_ClientAfterConnect(Sender: TObject);
begin
  TempInterface := ICollectServerDisp(IDispatch(Sc_Client.AppServer));
  AlarmServer :=  Sc_Client.AppServer;
end;

procedure TDm_Collect_Local.Sc_ClientAfterDisconnect(Sender: TObject);
begin
  TempInterface := nil;
end;

function TDm_Collect_Local.ConnectDB: boolean;
begin
  result := false;
  try
    Ado_Conn.Connected := true;

    SynchronizationSysTime;
    //��ʼ����ϵͳ��Ϣ
    InitInterfaceSource;
  except   
    Application.MessageBox('���ݿ����Ӵ�����ȷ�����ݿ��ַ������ȷ!', '����', MB_OK + MB_ICONINFORMATION);

    exit;
  end;
  result := true;
end;

end.


