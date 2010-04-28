unit UnitDataModuleLocal;

interface

uses
  SysUtils, Classes, IniFiles, Windows, Forms, Controls, DB, ADODB,
  uConnectionPool, uADOConnectionPool;

type
  //初始化系统功能设置表Alarm_sys_function_set时用到
  TSysFunction=^TSysFunSet;
  TSysFunSet = record
    Code : integer;
    SetValue : String;
    Content :string;
    Condition:String;
  end;

  TSendTimeList = record
    DeviceLevel: integer;    //设备等级
    AlarmLevel:integer;      //告警等级
    TimeList : TStringList;  //定点派障时间点列表
    AllowSend : boolean;     //是否允许派障
    SA_StartTime : string;   //一天中派障起始时间
    SA_EndTime : string;     //一天中派障结束时间
  end;

  TTheAreaAlarmParam = record//派障规则全局结构
    ManualLimit : string;  //干预时限  
    IsAutoWrecker : integer; //是否自动消障
    IsAutoSend : boolean;    //派障形式：是自动派障还是定点派障 ,true为即时派障，false为定点派障
    sendtimeList: Array of TSendTimeList; //派障时点表
    SendDateList: Array of TSendTimeList; //派障起始结束时间
    WarnCount :Integer;      //预警线
    WreckerLimit:integer;   //自动消障时限  N分钟没有告警则认为排障
  end;

  //嵌套记录类型，存储各系统参数
  TAlarmParam = record
    CityID:integer;
    CityName:string;
    CityParam:TTheAreaAlarmParam;
  end;

  //首次启动应服及
  TServiceInfo = Record
    ServiceName: String;
    UserName: String;
    Password: String;
    MsgPort :integer;
  end;


  TDataModuleLocal = class(TDataModule)
    ADOConnPool: TADOConnectionPool;
    Sp_FlowNumber: TADOStoredProc;
  private
    { Private declarations }
  public
    ServiceInfo: TServiceInfo;
    AlarmParam : Array of TAlarmParam;
    //初始化采集参数 干预排障和手工派障用到
    procedure InitVariable;
    //系统登录初始化
    function FirstLoginInit: boolean;
    function ProduceFlowNumID(CurrConn: TAdoConnection;I_FLOWNAME:string;I_SERIESNUM:integer):Integer; //得到指定类型的流水号
  end;

var
  DataModuleLocal: TDataModuleLocal;

implementation

uses UnitServerSet, UnitComponentFactory;

{$R *.dfm}

{ TDataModuleLocal }

function TDataModuleLocal.FirstLoginInit: boolean;
var
  IniFile : TIniFile;
  temForm : TFormServerSet;
begin
  with ServiceInfo do
  begin
    iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'CFMSServiceInfo.ini');
    try
      ServiceName := IniFile.ReadString('Server Config','DB_ServiceName','0');
      UserName := IniFile.ReadString('Server Config','DB_LoginName','0');
      Password := IniFile.ReadString('Server Config','DB_LoginPassword','0');
      MsgPort := IniFile.ReadInteger('Server Config','ComPort',0);
      if (ServiceName = '0') or (UserName = '0') or (Password = '0') or (MsgPort = 0) then
      begin
        temForm := TFormServerSet.Create(nil);
        try
          if temForm.ShowModal = mrOk then
          with temForm do
          begin
            ServiceName := Trim(Ed_ServiceName.Text);
            UserName := Trim(Ed_UserName.Text);
            Password := Trim(Ed_Password.Text);
            MsgPort := StrToInt(Trim(Ed_ComPort.Text));
            iniFile.WriteString('Server Config','DB_ServiceName', ServiceName);
            iniFile.WriteString('Server Config','DB_LoginName', UserName);
            iniFile.WriteString('Server Config','DB_LoginPassword', Password);
            iniFile.WriteInteger('Server Config','ComPort', MsgPort);
            Result := true;
          end
          else
            Result := false;
        finally
          temForm.Free;
        end;
      end
      else
        Result := True;
      ADOConnPool.ConnectionString:='Provider=MSDAORA.1;Password='+Password+';User ID='+UserName+';Data Source='+ServiceName+';Persist Security Info=True;Extended Properties="PLSQLRSET=1"';
    finally
      iniFile.Free;
    end;
  end;
end;

procedure TDataModuleLocal.InitVariable;   {mark}
begin

end;
{var
  i,CitySN:integer;
  FunList:TList;
  tempSysFun : TSysFunction;
  Conn: TAdoConnection;
  temQ :TADOQuery;
begin
  Conn:=ADOConnPool.GetConnection as TADOConnection;
  temQ := GetNewAdoquery(Conn);
  with temQ, FunList do
  try
    close;
    sql.clear;
    sql.Add('select id as cityid,area_name as cityname from areas where area_level=2 and id in ( select distinct cityid from alarm_sys_function_set )');
    open;
    setlength(AlarmParam,RecordCount);
    temQ.first;
    CitySN:=0;
    while not eof do
    begin
      AlarmParam[CitySN].CityID:=fieldbyname('CityID').AsInteger;
      AlarmParam[CitySN].CityName:=fieldbyname('CityName').AsString;
      //获取即时派障的派障开始截止时间 、定点派障的派障时间点列表 kind=2 kind=3 kind=4
      if not GetDeviceLevelList(Conn,CitySN) then
        application.MessageBox('初始化设备等级信息失败,请检查设备等级信息编码表是否缺失或无记录！','提示',mb_ok+mb_defbutton1);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,6);  //kind=6，是否启用干预派障规则
      for i:=0 to Count-1 do
      begin
        tempSysFun:=Items[i];
        if tempSysFun.Content='1' then
        begin
          if tempSysFun.SetValue ='' then
             AlarmParam[CitySN].CityParam.ManualLimit:='0'
          else
             AlarmParam[CitySN].CityParam.ManualLimit:=tempSysFun.SetValue;  //code=1，为干预派障时限
        end;
      end;
      FreeTheList(FunList);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,5); //kind=5，为应用服务功能设置
      for i:=0 to count-1 do
      begin
        tempSysFun:=Items[i];
        if tempSysFun.SetValue='1' then IfAutoRun :=true else IfAutoRun :=false;
      end;
      FreeTheList(FunList);
      inc(CitySN);
      next;
    end;
  finally
    temQ.Free;
  end;
end;}

function TDataModuleLocal.ProduceFlowNumID(CurrConn: TAdoConnection;
  I_FLOWNAME: string; I_SERIESNUM: integer): Integer;
var
  CL:TRTLCriticalSection;
begin
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    with Sp_FlowNumber do
    begin
      close;
      Connection:=CurrConn;
      Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //流水号命名
      Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //申请的连续流水号个数
      execproc;
      result:=Parameters.parambyname('O_FLOWVALUE').Value; //返回值为整型，过程只返回序列的第一个值，但下次返回值为：result+I_SERIESNUM
      close;
    end;
  finally
    LeaveCriticalSection(CL);
  end;
end;

end.
