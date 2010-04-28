unit Ut_Data_Local;

interface

uses
  SysUtils, Classes, DB, ADODB, DBClient, Provider, Windows, Variants,  MD5,
  IdBaseComponent, IdComponent, IdTCPServer, Forms, ADOInt, Controls,StrUtils,
  MConnect, SConnect,Ut_PubObj_Define,AlarmServiceApp_TLB;


//外系统接口 结构体
type
  TInterFaceSource = record
    RemoteConn: string;  // 外系统数据库连接信息
    CityID : integer;
    EventType : integer; //对外接口的事件类型，区分不同外系统的业务规则:  1- 绍兴10000号;2- 一站式
    SystemID :integer;   //外系统分配给派障系统的编号
    QUCode :integer;     //地区号 如 0751
    LevelCode :String;   //外系统接收的基站等级信息
    collectioncode :integer; //外系统连接编号
    AlarmContentFilter:String;  // 需要过滤掉的告警内容
  end;
type
  TSendTimeList = record
    TimeList : TStringList;
    CsLevelCode: integer;
    AllowSend : boolean;
    SA_StartTime : string;   //一天中派障起始时间
    SA_EndTime : string;     //一天中派障结束时间
  end;

  TTheAreaAlarmParam = record//派障规则全局结构
    Cs_Status_Str : string;  //基站状态过滤
    Cs_Area_Str : string;    //基站所属区域过滤
    Cs_Power_Str : string;   //基站供电方式过滤
    ManualLimit : string;  //干预时限
    
    SA_StartTime : string;   //一天中派障起始时间
    SA_EndTime : string;     //一天中派障结束时间
    IsAutoWrecker : integer; //是否自动消障
    IsAutoSend : boolean;    //派障形式：是自动派障还是定点派障 ,true为即时派障，false为定点派障
    sendtimeList: Array of TSendTimeList; //派障时点表
    SendDateList: Array of TSendTimeList; //派障特殊日子列表
    WeekSendList: Array of record Code : integer; SetValue : boolean; end; //每周派障列表
    WarnCount :Integer;      //预警线 辖区预警
    WarnCount_CSC :integer;  // 控制器下预警数
    WarnConent :String; // 预警
  end;

  TAlarmParam = record   //嵌套记录类型，存储各
    CityID:integer;
    CityName:string;
    TodayIsSend :boolean;
    CityParam:TTheAreaAlarmParam;
    TestIP :String;    //告警测试
    TestPort :Integer; //告警测试

  end;

  TCsLevelLimitedHour = record
    CsLevel,
    LimitedHour:integer
  end;
  //公用参数
  TPublicParam = Record
    ClearLog_Time,
    ClearLog_Day,
    IsAutoClearLog,
    RepStatTime,
    IsAutoStatRep,
    IsAutoSynPOP,
    IsAutoSyn10000,
    SA_StartTime,   //一天中省局考核起始时间
    SA_EndTime : string;     //一天中省局考核结束时间
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
    //初始化 外系统信息
    procedure InitInterfaceSource;
    // 获取送往外系统的基站等级信息
    function GetInitInterfaceFilter(id,cityid:Integer):String;

    { Private declarations }
  public
    AlarmServer : Variant;
    TempInterface: ICollectServerDisp;
    Operator:string;
    AlarmParam : Array of TAlarmParam;
    PublicParam :TPublicParam;

    InterFaceSource : Array of TInterFaceSource;  //存放外系统信息
    
    Function GetCitySN(CityID:integer):integer;

    function LogEntry(Dig: MD5Digest): string;

    function LogIn(bAliasName,sPassword:String) :Boolean;

    function GetSysDateTime():TDateTime;  //得到数据库服务器时间

    function ConfigDBConn(IsNew:boolean=true; EditedConnStr:string=''):String;
    function GetTimeLimitFromCsLevel(CsLevel:integer):integer; //根据基站等级得到省局故障基站修复时限

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
  ServerTime : TSystemTime;                  //系统时间
  Today: tdatetime;
begin
  today:=GetSysDateTime;  // 提取系统时间
  DateTimeToSystemTime(today,ServerTime);
  SetLocalTime(ServerTime);      //设置本机时间同步Server系统时间
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
      Application.MessageBox('连接派障服务失败,派障、排障、实时统计将无法发送给派障服务!', '警告', MB_OK + MB_ICONINFORMATION);
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
   DataSourceLocator  :=  CoDataLinks.Create;     //创建接口指针
   try
     if IsNew then //为true生成新配置，为false编辑配置
     begin
       ADOConn  :=  DataSourceLocator.PromptNew;      //打开配置窗体
       ADODbConn.ConnectionObject  :=  IDispatch(ADOConn)  as  _Connection;//赋值给ADOConnection
     end else
     try
       ADOConn:=IDispatch(ADODbConn.ConnectionObject);
       DataSourceLocator.PromptEdit(ADOConn);
     except
       on E : Exception do
          raise Exception.Create('不能识别已有的数据库连接串，请用<重建数据库连接>来重新生成数据库连接串！');
     end;
   finally
     Result:=ADODbConn.ConnectionString;
     DataSourceLocator  :=  nil;        //记着释放啊
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

// 获取送往外系统的基站等级信息 或者 过滤告警内容
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

//初始化外系统接口信息
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
    //初始化外系统信息
    InitInterfaceSource;
  except   
    Application.MessageBox('数据库链接错误，请确认数据库地址配置正确!', '错误', MB_OK + MB_ICONINFORMATION);

    exit;
  end;
  result := true;
end;

end.


