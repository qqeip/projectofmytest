unit UnitDataModuleLocal;

interface

uses
  SysUtils, Classes, IniFiles, Windows, Forms, Controls, DB, ADODB,
  uConnectionPool, uADOConnectionPool;

type
  //��ʼ��ϵͳ�������ñ�Alarm_sys_function_setʱ�õ�
  TSysFunction=^TSysFunSet;
  TSysFunSet = record
    Code : integer;
    SetValue : String;
    Content :string;
    Condition:String;
  end;

  TSendTimeList = record
    DeviceLevel: integer;    //�豸�ȼ�
    AlarmLevel:integer;      //�澯�ȼ�
    TimeList : TStringList;  //��������ʱ����б�
    AllowSend : boolean;     //�Ƿ���������
    SA_StartTime : string;   //һ����������ʼʱ��
    SA_EndTime : string;     //һ�������Ͻ���ʱ��
  end;

  TTheAreaAlarmParam = record//���Ϲ���ȫ�ֽṹ
    ManualLimit : string;  //��Ԥʱ��  
    IsAutoWrecker : integer; //�Ƿ��Զ�����
    IsAutoSend : boolean;    //������ʽ�����Զ����ϻ��Ƕ������� ,trueΪ��ʱ���ϣ�falseΪ��������
    sendtimeList: Array of TSendTimeList; //����ʱ���
    SendDateList: Array of TSendTimeList; //������ʼ����ʱ��
    WarnCount :Integer;      //Ԥ����
    WreckerLimit:integer;   //�Զ�����ʱ��  N����û�и澯����Ϊ����
  end;

  //Ƕ�׼�¼���ͣ��洢��ϵͳ����
  TAlarmParam = record
    CityID:integer;
    CityName:string;
    CityParam:TTheAreaAlarmParam;
  end;

  //�״�����Ӧ����
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
    //��ʼ���ɼ����� ��Ԥ���Ϻ��ֹ������õ�
    procedure InitVariable;
    //ϵͳ��¼��ʼ��
    function FirstLoginInit: boolean;
    function ProduceFlowNumID(CurrConn: TAdoConnection;I_FLOWNAME:string;I_SERIESNUM:integer):Integer; //�õ�ָ�����͵���ˮ��
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
      //��ȡ��ʱ���ϵ����Ͽ�ʼ��ֹʱ�� ���������ϵ�����ʱ����б� kind=2 kind=3 kind=4
      if not GetDeviceLevelList(Conn,CitySN) then
        application.MessageBox('��ʼ���豸�ȼ���Ϣʧ��,�����豸�ȼ���Ϣ������Ƿ�ȱʧ���޼�¼��','��ʾ',mb_ok+mb_defbutton1);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,6);  //kind=6���Ƿ����ø�Ԥ���Ϲ���
      for i:=0 to Count-1 do
      begin
        tempSysFun:=Items[i];
        if tempSysFun.Content='1' then
        begin
          if tempSysFun.SetValue ='' then
             AlarmParam[CitySN].CityParam.ManualLimit:='0'
          else
             AlarmParam[CitySN].CityParam.ManualLimit:=tempSysFun.SetValue;  //code=1��Ϊ��Ԥ����ʱ��
        end;
      end;
      FreeTheList(FunList);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,5); //kind=5��ΪӦ�÷���������
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
      Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //��ˮ������
      Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //�����������ˮ�Ÿ���
      execproc;
      result:=Parameters.parambyname('O_FLOWVALUE').Value; //����ֵΪ���ͣ�����ֻ�������еĵ�һ��ֵ�����´η���ֵΪ��result+I_SERIESNUM
      close;
    end;
  finally
    LeaveCriticalSection(CL);
  end;
end;

end.
