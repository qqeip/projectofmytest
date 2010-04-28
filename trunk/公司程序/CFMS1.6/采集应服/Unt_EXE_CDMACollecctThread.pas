unit Unt_EXE_CDMACollecctThread;

interface

uses
  Classes, SysUtils, Windows, UntBaseDBThread, ComCtrls, StdCtrls, Variants, Forms;

type
  TInitCorba = function(IOR: string): boolean; stdcall;
  TFreeCorba = procedure; stdcall;
  TInitAlarmIRP = function: boolean; stdcall;
  TGetAlarmRecordFilter = function(var flag: Boolean; TypeFlag: integer=0): OleVariant; stdcall;
  TGetNextAlarmInformations = function(const how_many :Word; out alarm_informations: OleVariant): boolean; stdcall;  

  TCDMACollecctThread = class(TBaseDBThread)
  private
    blFistTime, blSendToMTS: boolean;
    CurrentIOR: Integer;
    slCorbaIOR: TStringList;  //��������ַ��
    sCityID: string;
    blSaveErrLog: Boolean;

    function  InitServerPos: boolean;
    procedure DoAll;
    procedure ClearHisData;
    function  CallCorbaInterface: boolean;
    procedure DoCollectData;

    procedure CallAllAlarmCollect;   //�ɼ�ȫ���澯�����ݸ澯���ͣ�����Clear�澯
    procedure CallFastAlarmCollect;  //�ɼ��¸澯���������θ澯�����������죬����Clear�澯
    function  CollectAlarmData(TypeFlag: integer=0): boolean; //ͨ��Corba�ӿڲɼ��澯 TypeFlag: 0 ��Clear�澯 1�¸澯 2Clear�澯 ����False��ʾû�вɼ����澯����
    function  SaveAlarmDataToDB: boolean; //���������ݼ��ĸ澯��Ϣ�������ݿ�
    procedure SaveAlarmDataToHis(IsClearAlarm: boolean=false);          //��ԭʼ�澯��Ϣ���ݵ���ʷ��
    procedure SendAlarmData(IsClearAlarm: boolean=false);  //�ɷ��澯
    procedure SendSimulateClearAlarmData; //�ɷ�Clear�澯
    procedure ClearAllAlarmData;     //��ղɼ���ʱ������
    procedure PrepareSimulateClearAlarmEvn;      //׼��ģ��Clear�澯���ݻ���

    procedure AnalysisAlarmData(AlarmRecordList: OleVariant);          //��Corba��ȡ�ĸ澯��Ϣ�������ݼ�
    function GetCoDeviceID(sAlarmLocation: string): string;
    function GetErrorContent(contentcode: integer; sAlarmLocation: string): string;

    function  GetServerID: integer;  // ��ǰ���������CurrentIOR

    function LoadCBLibrary: boolean;
    procedure FreeCBLibrary;
  protected
    procedure DoExecute; override;   
  public
    blIsNoClearHis: boolean;

    procedure SetDebug(pBlDebug: Boolean);
    constructor Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
    destructor Destroy; override;  
  end;

const cb_hwi32 = 'cb_hwi.dll';

var
  DllHandle: THandle;
  InitCorba: TInitCorba;
  FreeCorba: TFreeCorba;
  InitAlarmIRP: TInitAlarmIRP;
  GetAlarmRecordFilter: TGetAlarmRecordFilter;
  GetNextAlarmInformations: TGetNextAlarmInformations;

implementation

uses UntFunc, Unt_EXE_Main;

constructor TCDMACollecctThread.Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
begin
  inherited Create(DBConn, reRunLog, btRunThread);

  blDebug := true;
  blIsNoClearHis := false;
  blSaveErrLog := false;

  blFistTime := true;
  blSendToMTS := false;
  CurrentIOR := 0;
  sCityID := '571';

  slCorbaIOR := TStringList.Create;
end;

destructor TCDMACollecctThread.Destroy;
begin   
  slCorbaIOR.Free;

  FrmMain.blSaveLogInDepend := blSaveErrLog;
  FrmMain.tTime.Enabled := true;  

  inherited;
end;

procedure TCDMACollecctThread.DoExecute;
begin
  self.Terminate;
  
  if not ConnectDB then exit;
  if blFistTime and not InitServerPos then exit;

  ClearHisData; //�����ʷ��ʱ����

  if not LoadCBLibrary then exit;

  repeat
    DoAll; 
  until CurrentIOR=0;

  FreeCBLibrary;  

end;  

procedure TCDMACollecctThread.DoAll;
begin
  try
    if CurrentIOR = 0 then
    begin
      AppendRunLog('�����ɼ��̣߳�׼���ɼ��澯������', true);
      FrmMain.GiveMainCDMAMsg(1);
    end;

    if CallCorbaInterface then DoCollectData;
            
  except
    blSaveErrLog := true;
    AppendRunLog('Corba�ӿڲɼ������쳣���������Ա��ϵ��', true);
    exit;
  end;

  CurrentIOR := CurrentIOR+1;
  if CurrentIOR >= slCorbaIOR.Count then CurrentIOR := 0;

  if CurrentIOR = 0 then
  begin
    AppendRunLog('һ�ֲɼ���ɣ���ͣ�ɼ��̡߳�����', true);
    FrmMain.GiveMainCDMAMsg(8);
  end;   

end;

function TCDMACollecctThread.CallCorbaInterface: boolean;
begin
  Result := false;
  try
    InitCorba(trim(slCorbaIOR[CurrentIOR]));
  except
    on E: Exception do
    begin
      blSaveErrLog := true;
      FrmMain.GiveMainCDMAMsg(10,CurrentIOR+1);
      AppendRunLog('������� '+IntToStr(CurrentIOR+1)+' �ӿ�����ʧ�ܣ�������������������ӣ�'+E.Message, true);
      exit;
    end;
  end;

  try  
    InitAlarmIRP;
  except
    blSaveErrLog := true;
    FrmMain.GiveMainCDMAMsg(10,CurrentIOR+1);
    AppendRunLog('������� '+IntToStr(CurrentIOR+1)+' �ӿ�����ʧ�ܣ�������������������ӣ�', true);
    exit;
  end;
  Result := true;
end;

procedure TCDMACollecctThread.DoCollectData;
begin
  AppendRunLog('��ǰ�ɼ����������Ϊ��'+IntToStr(CurrentIOR+1), true);
  FrmMain.GiveMainCDMAMsg(2,CurrentIOR+1);

  if blFistTime then
  begin
    //CallAllAlarmCollect;    ���comp ��������
    CallFastAlarmCollect;
    if CurrentIOR = slCorbaIOR.Count-1 then
      blFistTime := false;
  end
  else
    CallFastAlarmCollect;

  AppendRunLog('������ '+IntToStr(CurrentIOR+1)+' �ɼ���ɡ�����', true);
  FrmMain.GiveMainCDMAMsg(7,CurrentIOR+1);
end;

function TCDMACollecctThread.InitServerPos: boolean;
begin
  Result := false;
  
  OpenQuery('select serverpos from fms_cbserver_info order by SERVERBH');
  if Ado_Query.IsEmpty then
  begin
    AppendRunLog('Corba��������ַδ���ã�ȡ���ɼ���', true);
    exit;
  end;

  Ado_Query.First;
  slCorbaIOR.Clear;
  while not Ado_Query.Eof do
  begin 
    slCorbaIOR.Add(Ado_Query.FieldByName('serverpos').AsString);
    Ado_Query.Next;
  end;
  
  Result := true;
end;

//------------------------------------------------------------------------------     

procedure TCDMACollecctThread.CallAllAlarmCollect;
begin
  if CollectAlarmData(2) then
  begin
    ClearAllAlarmData;
    SaveAlarmDataToDB;
    //SaveAlarmDataToHis(true);
    SendAlarmData(true);
  end;

  if CollectAlarmData then
  begin
    ClearAllAlarmData;
    SaveAlarmDataToDB;
    //SaveAlarmDataToHis;
    SendAlarmData;
  end;
end;

procedure TCDMACollecctThread.CallFastAlarmCollect;
begin
  if not CollectAlarmData(1) then exit;

  Ado_DBConn.BeginTrans;
  try
    try
      PrepareSimulateClearAlarmEvn;
    except
      on E: Exception do
      begin
        blSaveErrLog := true;
        AppendRunLog('����澯�Ƚ������쳣��'+E.Message, true);
      end;
    end;

    SaveAlarmDataToDB;
    SaveAlarmDataToHis;
    SendAlarmData;

    try
      SendSimulateClearAlarmData;
    except
      on E: Exception do
      begin
        blSaveErrLog := true;
        AppendRunLog('����ģ��Clear�澯�쳣��'+E.Message, true);
      end;
    end;

    Ado_DBConn.CommitTrans;
  except
    on E: Exception do
    begin
      blSaveErrLog := true;
      AppendRunLog('�ɼ��쳣��'+E.Message, true);
      Ado_DBConn.RollbackTrans;
    end;
  end;      

end;

function TCDMACollecctThread.CollectAlarmData(TypeFlag: integer): boolean;
var
  Flag: boolean;
  HasAlarmsLeft: boolean;
  sAlarmType: string;
  LowArr, HighArr, AlarmCount: integer;
  AlarmRecordList: OleVariant;
begin
  case TypeFlag of
    0: sAlarmType := '��Clear�澯';
    1: sAlarmType := '�¸澯';
    2: sAlarmType := 'Clear�澯';
  end;  

  AppendRunLog('��ʼ'+sAlarmType+'�ɼ�������');

  AlarmRecordList := GetAlarmRecordFilter(Flag, TypeFlag);
  OpenQuery('select * from alarm_data_huawei_temp where 1=2');

  HasAlarmsLeft := true;
  while HasAlarmsLeft do
  begin   
    if Flag then
    begin
      HasAlarmsLeft := false;
    end
    else
      HasAlarmsLeft := GetNextAlarmInformations(1000, AlarmRecordList);

    LowArr:=VarArrayLowBound(AlarmRecordList,1);
    HighArr:=VarArrayHighBound(AlarmRecordList,1);
    AlarmCount := HighArr-LowArr+1;

    AppendRunLog('�Ѳɼ�'+IntToStr(AlarmCount)+'��');

    if AlarmCount > 0 then
    begin
      try
        AnalysisAlarmData(AlarmRecordList);
      except      
        on E: Exception do
        begin
          blSaveErrLog := true;
          AppendRunLog('���ݷ����׶��쳣��'+e.Message, true);
        end;
      end;  
    end;
  end;

  AlarmRecordList := null;

  AppendRunLog(sAlarmType+'�ɼ�����������');

  Result := not Ado_Query.IsEmpty;
end;

procedure TCDMACollecctThread.AnalysisAlarmData(AlarmRecordList: OleVariant);
var
  AlarmCount: Integer;
var
  I: Integer;
  TempValue, DeviceID, ERRORCONTENT: string;
  DeviceIDPos: Integer;
begin
  //0 domain_name, 1 type_name, 2 event_name, 3 d, 4 e, 5 b, 6 c, 7 g, 8 h, 9 f, 10 i, 11 j, 12 jj

  AlarmCount := VarArrayHighBound(AlarmRecordList,1)-VarArrayLowBound(AlarmRecordList,1)+1;
  for I := 0 to AlarmCount-1 do
  begin
    Ado_Query.Append;

    Ado_Query.FieldByName('domain_name').Value :=AlarmRecordList[I][0];
    Ado_Query.FieldByName('type_name').Value :=AlarmRecordList[I][1];
    Ado_Query.FieldByName('event_name').Value :=AlarmRecordList[I][2];
    Ado_Query.FieldByName('d').Value :=AlarmRecordList[I][3];
    Ado_Query.FieldByName('e').Value :=AlarmRecordList[I][4];
    Ado_Query.FieldByName('b').Value :=AlarmRecordList[I][5];
    Ado_Query.FieldByName('c').Value :=AlarmRecordList[I][6];
    Ado_Query.FieldByName('g').Value :=AlarmRecordList[I][7];
    Ado_Query.FieldByName('h').Value :=AlarmRecordList[I][8];
    Ado_Query.FieldByName('f').Value :=AlarmRecordList[I][9];
    Ado_Query.FieldByName('i').Value :=AlarmRecordList[I][10];
    Ado_Query.FieldByName('j').Value :=AlarmRecordList[I][11];
    Ado_Query.FieldByName('jj').Value :=AlarmRecordList[I][12];

    Ado_Query.FieldByName('ID').Value := Ado_Query.FieldByName('f').Value;
    Ado_Query.FieldByName('ServerID').Value := GetServerID;

    //'��վ���=363, '
        
    TempValue := AlarmRecordList[I][11];
    DeviceIDPos := pos('��վ���=', TempValue);
    if DeviceIDPos>0 then
    begin
      TempValue := copy(TempValue, DeviceIDPos+9, Length(TempValue)-DeviceIDPos);
      DeviceIDPos := pos(',', TempValue);
      DeviceID := copy(TempValue, 1, DeviceIDPos-1);

      try
        StrToInt(DeviceID);
      except
        AppendRunLog('��վ��Ŵ���'+DeviceID+#13#10+'������ϸ��־��'+AlarmRecordList[I][11], true);
        DeviceID := '0';
      end;
    end
    else
    begin
      DeviceID:='0';
    end;   
    Ado_Query.FieldByName('DeviceID').Value := DeviceID;

    Ado_Query.FieldByName('CODeviceID').Value := GetCoDeviceID(TempValue); 
    Ado_Query.FieldByName('ERRORCONTENT').Value := GetErrorContent(Ado_Query.FieldByName('i').Value, TempValue);

    if Ado_Query.FieldByName('i').AsInteger = 2312 then
    begin
      ERRORCONTENT := trim(Ado_Query.FieldByName('ERRORCONTENT').AsString);
      if ERRORCONTENT <> '' then
      begin
        if pos('1X', ERRORCONTENT) > 0 then Ado_Query.FieldByName('i').Value := 231200001;
      end;
    end;
  end;   

  Ado_Query.CheckBrowseMode;

end;

function TCDMACollecctThread.SaveAlarmDataToDB: boolean;  
begin
  Result := false;

  AppendRunLog('��ʼ�澯���ݱ��������ݿ⡣����');
  
  try
    //Ado_DBConn.BeginTrans;
    Ado_Query.UpdateBatch;       
    //Ado_DBConn.CommitTrans;

    AppendRunLog('�澯���ݱ��������ݿ���ɡ�����');

    Result := true;
  except    
    on E: Exception do
    begin
      blSaveErrLog := true;
      AppendRunLog('�澯���ݱ��������ݿ��쳣��'+e.Message, true);
      //Ado_DBConn.RollbackTrans;
    end;
  end;
end;

procedure TCDMACollecctThread.SaveAlarmDataToHis(IsClearAlarm: boolean);
var
  FieldsList, FieldsListT, DataSQL: string;
  ServerID: Integer;
begin
  ServerID := GetServerID;
  FieldsList := 'id, serverid, domain_name, type_name, event_name, d, e, b, c, g, h, f, i, j, jj';
  FieldsListT := 't.id, t.serverid, t.domain_name, t.type_name, t.event_name, t.d, t.e, t.b, t.c, t.g, t.h, t.f, t.i, t.j, t.jj';

  if IsClearAlarm then
  begin
    DataSQL := 'insert into alarm_data_huawei_history '+
      '( '+FieldsList+' ) select '+FieldsListT+' from alarm_data_huawei_temp t'+
      'left join alarm_data_huawei_history a on a.serverid=t.serverid and a.id=t.id '+
      'where serverid='+IntToStr(ServerID)+' and a.serverid is null';
    ExecSQL(DataSQL);
  end
  else
  begin
    DataSQL := 'insert into alarm_data_huawei_history '+
      '( '+FieldsList+' ) select '+FieldsListT+' from alarm_data_huawei_online t '+
      'left join alarm_data_huawei_history a on a.serverid=t.serverid and a.id=t.id '+
      'where t.serverid='+IntToStr(ServerID)+' and a.serverid is null';
    ExecSQL(DataSQL);
    
    ExecSQL('delete alarm_data_huawei_online where serverid='+IntToStr(ServerID));

    DataSQL := 'insert into alarm_data_huawei_online '+
      '( '+FieldsList+' ) select '+FieldsList+' from alarm_data_huawei_temp '+
      'where serverid='+IntToStr(ServerID);
    ExecSQL(DataSQL); 
  end;
end;

procedure TCDMACollecctThread.SendAlarmData(IsClearAlarm: boolean);
var
  DataSQL, ISALARM: string;
  ServerID: Integer;

  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  strBH : String;
begin
  AppendRunLog('��ʼ�澯�����ɷ�������');

  ServerID := GetServerID;
  ISALARM := '1';
  if IsClearAlarm then ISALARM := '0';

  Present:= Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  strBH := Format('%.4d',[Year])+Format('%.2d',[month])+Format('%.2d',[day])+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+Format('%.4d',[MSec]);

  //into gather history    ���� alarm_data_gather_history ���ڷ����߳���
  DataSQL := 'insert into alarm_data_gather_history '+
    '(alarmautoid, collectid, deviceid, codeviceid, contentcode, isalarm, createtime, operatetime, BH) '+
    'select t.alarmautoid, t.collectid, t.deviceid, t.codeviceid, t.contentcode, t.isalarm, t.createtime, sysdate operatetime, '+strBH+' BH '+
    'from alarm_data_huawei_view t '+
    'where t.serverid='+IntToStr(ServerID);
  try
    ExecSQL(DataSQL);
  except  
    on E: Exception do
    begin
      blSaveErrLog := true;
      AppendRunLog('alarm_data_gather����ʷ�����'+E.Message, true);
    end;
  end;

  DataSQL := 'insert into alarm_data_gather '+
    '(alarmautoid, alarmtype, deviceid, CODEVICEID, contentcode,ISALARM,createtime, '+
    'collectid,errorcontent,cityid,isprocess,collectionkind,collectioncode,ALARMLOCATION) '+
    'select t.alarmautoid, t.alarmtype,t. deviceid, t.codeviceid, t.contentcode, t.isalarm, t.createtime, '+
    't.collectid, t.errorcontent, '+sCityID+' cityid, t.isprocess, t.collectionkind, t.collectioncode,t.ALARMLOCATION '+
    'from alarm_data_huawei_view t '+
    'left join alarm_data_gather a '+
    'on a.cityid='+sCityID+' and a.collectid=t.collectid '+
    'where t.serverid='+IntToStr(ServerID)+' and a.collectid is null';
  ExecSQL(DataSQL);

  if blSendToMTS then
  begin 
    if IsClearAlarm then      //---------------------�ƺ�û��
    begin
      DataSQL := 'delete mtu_alarm_assistant where id in ('+
      'select collectid from alarm_data_huawei_comp t '+
      'where serverid='+IntToStr(ServerID)+' and '+
      't.collectid not in (select collectid from alarm_data_huawei_view) )';
    end
    else
    begin
      DataSQL := 'insert into mtu_alarm_assistant '+
      '(id, csid, sector, contentcode, ServerID, collecttime ) '+
      'select collectid id, DEVICEID csid, CODEVICEID sector, contentcode, ServerID, '+
      'createtime collecttime '+
      'from alarm_data_huawei_view '+
      'where serverid='+IntToStr(ServerID)+' and '+
      ' collectid not in (select id from mtu_alarm_assistant where serverid='+IntToStr(ServerID)+' )';
    end;
    ExecSQL(DataSQL);
  end;

  AppendRunLog('�澯�����ɷ�����������');
end;

procedure TCDMACollecctThread.SendSimulateClearAlarmData;
var
  DataSQL, TableFields: string;
  ServerID: Integer;

  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  strBH : String;
begin
  AppendRunLog('��ʼģ��Clear�澯�ɷ�������');
  ServerID := GetServerID;

  TableFields := 'alarmautoid, alarmtype, deviceid, codeviceid, contentcode, isalarm, createtime, collectid, errorcontent, '+
                 'cityid, isprocess, collectionkind, collectioncode, serverid';  

  DataSQL := 'insert into alarm_data_gather '+
            '(alarmautoid, alarmtype, DEVICEID, CODEVICEID, contentcode,ISALARM,createtime, '+
            'collectid,errorcontent,cityid,isprocess,collectionkind,collectioncode,ALARMLOCATION ) '+
            'select '+IntToStr(slCorbaIOR.Count+ServerID)+' alarmautoid, t.alarmtype, t.DEVICEID, t.CODEVICEID, t.contentcode,'+
            '0 ISALARM, sysdate createtime, t.collectid, t.errorcontent,'+
            sCityID+' cityid, t.isprocess, t.collectionkind, t.collectioncode , '''' ALARMLOCATION '+
            'from ALARM_DATA_HUAWEI_COMP t '+   
            'left join alarm_data_huawei_WG_view a '+
            'on a.serverid='+IntToStr(ServerID)+' and a.collectid=t.collectid '+
            'left join alarm_data_gather b '+
            'on b.cityid='+sCityID+' and b.ISALARM=0 and b.collectid=t.collectid '+
            'where t.serverid='+IntToStr(ServerID)+' and a.collectid is null and b.collectid is null ';
  ExecSQL(DataSQL);  

  Present:= Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  strBH := Format('%.4d',[Year])+Format('%.2d',[month])+Format('%.2d',[day])+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+Format('%.4d',[MSec]);

   //ģ��clear�澯����ʷ gather history
  DataSQL := 'insert into alarm_data_gather_history '+
     '(alarmautoid, collectid, deviceid, codeviceid, contentcode, isalarm, createtime, operatetime, BH) '+  
     'select '+IntToStr(slCorbaIOR.Count+ServerID)+' alarmautoid, t.collectid, t.deviceid, t.codeviceid, t.contentcode, 0 isalarm, t.createtime,  '+
     '  sysdate operatetime, '+strBH+' BH '+
     ' from ALARM_DATA_HUAWEI_COMP t '+                           
     'left join alarm_data_huawei_view a '+
     'on a.serverid='+IntToStr(ServerID)+' and a.collectid=t.collectid '+   
     'where t.serverid='+IntToStr(ServerID)+' and a.collectid is null ';
  try
    ExecSQL(DataSQL);
  except  
    on E: Exception do
    begin
      blSaveErrLog := true;
      AppendRunLog('alarm_data_gather Clear�澯����ʷ�����'+E.Message, true);
    end;
  end; 
             
  // ģ��clear�澯����ʷ �����ظ� ��alarmautoid��ֵ
  DataSQL := 'insert into alarm_data_huawei_comp_history ( '+TableFields +') '+
             'select nvl(b.alarmautoid, '+IntToStr(slCorbaIOR.Count-1+ServerID)+')+1 alarmautoid, t.alarmtype, t.deviceid, t.codeviceid, t.contentcode, 0 isalarm, sysdate createtime, t.collectid, '+
             't.errorcontent, t.cityid, t.isprocess, t.collectionkind, t.collectioncode, t.serverid '+
             ' from ALARM_DATA_HUAWEI_COMP t '+
             'left join alarm_data_huawei_view a '+
             'on a.serverid='+IntToStr(ServerID)+' and a.collectid=t.collectid '+
             'left join alarm_data_huawei_comp_history b on b.serverid='+IntToStr(ServerID)+' and b.isalarm=0 and b.collectid=t.collectid '+
             'where t.serverid='+IntToStr(ServerID)+' and a.collectid is null ';
  try
    ExecSQL(DataSQL);
  except  
    on E: Exception do
    begin
      //blSaveErrLog := true;
      AppendRunLog('ģ��Clear�澯����ʷ�����'+E.Message, true);
    end;
  end;  

  if blSendToMTS then
  begin
    DataSQL := 'delete mtu_alarm_assistant where id in ('+
              'select collectid '+
              'from ALARM_DATA_HUAWEI_COMP t '+
              'where serverid='+IntToStr(ServerID)+' and '+
              't.collectid not in (select id collectid from alarm_data_huawei_temp where serverid='+IntToStr(ServerID)+' ) )';

    ExecSQL(DataSQL);
  end;

  AppendRunLog('ģ��Clear�澯�ɷ�����������');
end;

procedure TCDMACollecctThread.ClearAllAlarmData;
var
  ServerID: Integer;
begin
  ServerID := GetServerID;
  ExecSQL('delete alarm_data_huawei_temp where serverid='+IntToStr(ServerID));
  ExecSQL('delete alarm_data_huawei_comp where serverid='+IntToStr(ServerID));
  //ExecSQL('delete alarm_data_huawei_comp_history where serverid='+IntToStr(ServerID));
  ExecSQL('delete mtu_alarm_assistant where serverid='+IntToStr(ServerID));
end;

procedure TCDMACollecctThread.PrepareSimulateClearAlarmEvn;
var
  TableFields, TableFieldsT, DataSQL: string;
  ServerID: Integer;
begin
  ServerID := GetServerID;

  TableFields := 'alarmautoid, alarmtype, deviceid, codeviceid, contentcode, isalarm, createtime, collectid, errorcontent, '+
                 'cityid, isprocess, collectionkind, collectioncode, serverid';
  TableFieldsT := 't.alarmautoid, t.alarmtype, t.deviceid, t.codeviceid, t.contentcode, t.isalarm, t.createtime, t.collectid, '+
                  't.errorcontent, t.cityid, t.isprocess, t.collectionkind, t.collectioncode, t.serverid';
  
  ExecSQL('delete ALARM_DATA_HUAWEI_COMP where serverid='+IntToStr(ServerID));

  DataSQL := 'insert into ALARM_DATA_HUAWEI_COMP ' +
             '( '+TableFields +') select '+TableFields+' from alarm_data_huawei_view where serverid='+IntToStr(ServerID);  
  ExecSQL(DataSQL);  

  DataSQL := 'insert into alarm_data_huawei_comp_history ' +
             '( '+TableFields +') select '+TableFieldsT+' from ALARM_DATA_HUAWEI_COMP t '+
             'left join alarm_data_huawei_comp_history a '+
             'on a.serverid='+IntToStr(ServerID)+' and a.collectid=t.collectid '+
             'where t.serverid='+IntToStr(ServerID)+' and a.serverid is null '; 
  ExecSQL(DataSQL);


  ExecSQL('delete alarm_data_huawei_temp where serverid='+IntToStr(ServerID));
end;

function TCDMACollecctThread.GetServerID: integer;
begin
  Result := CurrentIOR;
  //if not IsFastCollect then  Result := slCorbaIOR.Count+10;
end;  

function TCDMACollecctThread.LoadCBLibrary: boolean;
begin
  Result := false;

  DllHandle := LoadLibrary(PChar(extractfilepath(application.ExeName) + cb_hwi32));
  if DllHandle = 0 then begin
    AppendRunLog('Corba Dll δ�ҵ�', true);
    exit;
  end;

  try
    @InitCorba := GetProcAddress(DllHandle, 'InitCorba');
    if @InitCorba = nil then exit;
    @FreeCorba := GetProcAddress(DllHandle, 'FreeCorba');
    if @FreeCorba = nil then exit;
    @InitAlarmIRP := GetProcAddress(DllHandle, 'InitAlarmIRP');
    if @InitAlarmIRP = nil then exit;
    @GetAlarmRecordFilter := GetProcAddress(DllHandle, 'GetAlarmRecordFilter');
    if @GetAlarmRecordFilter = nil then exit;
    @GetNextAlarmInformations := GetProcAddress(DllHandle, 'GetNextAlarmInformations');
    if @GetNextAlarmInformations = nil then exit;

    Result := true;
  except
    blSaveErrLog := true;
    AppendRunLog('Corba Dll �쳣', true);
    FreeCBLibrary;
  end;
        
end;

procedure TCDMACollecctThread.FreeCBLibrary;
begin
  FreeCorba;
  FreeLibrary(DllHandle);
end;


function TCDMACollecctThread.GetCoDeviceID(sAlarmLocation: string): string;
var
  iPos, I: Integer;
  sAlarmLocationBak: string;   
begin
  //'�����������=1, '     '������ʶ='      '������ʶ��3�� '

  sAlarmLocationBak := sAlarmLocation;
  Result := '0'; 
  
  for I := 2 to 4 do
  begin
    sAlarmLocation := sAlarmLocationBak;
    
    iPos := pos('�������', sAlarmLocation);
    if iPos>0 then
    begin
      sAlarmLocation := trim(copy(sAlarmLocation, iPos+8, Length(sAlarmLocation)-iPos));
      Result := copy(sAlarmLocation, I, 1);
    end
    else
    begin
      iPos := pos('������ʶ', sAlarmLocation);
      if iPos>0 then
      begin
        sAlarmLocation := trim(copy(sAlarmLocation, iPos+8, Length(sAlarmLocation)-iPos));
        Result := copy(sAlarmLocation, I, 1);
      end;
    end;  

    if Result = '0' then break;

    try      
      StrToInt(Result);
      break;
    except
      if I<4 then continue;
      Result:='0';
      AppendRunLog('������Ŵ���'+Result+#13#10+'������ϸ��־��'+sAlarmLocationBak, true);    
    end;      

  end;
end;

function TCDMACollecctThread.GetErrorContent(contentcode: integer; sAlarmLocation: string): string;
var
  iPos: Integer;      
begin
  //2312 С���˷�  ��������=1X| appendInfo:  ��������=EV-DO| appendInfo:
  Result := '';

  try
    case contentcode of
      2312:
      begin
        sAlarmLocation := trim(sAlarmLocation);
        if sAlarmLocation = '' then exit;

        iPos := pos('��������=', sAlarmLocation);
        if iPos>0 then
        begin
          sAlarmLocation := copy(sAlarmLocation, iPos+9, Length(sAlarmLocation)-iPos);
          iPos := pos('|', sAlarmLocation);
          Result := copy(sAlarmLocation, 1, iPos-1);
          Result := '��������='+Result;
        end;
      end;

    end;

  except
    on E: exception do
    begin
      AppendRunLog('��ȡErrorContent����ʧ�ܣ�'+E.Message, true);   
    end;
  end;

end;

procedure TCDMACollecctThread.ClearHisData;
var
  iRecordCount, iCountMax, iCountDel: Integer;
  blDoDelete: boolean;
  strSQL: string;
begin
  if not blIsNoClearHis then
  begin
    try
      iCountMax := 100000;
      iCountDel := 20000;
      AppendRunLog('��ʼ��ʷ��ʱ����ɾ��������');

      OpenQuery('select count(*) count from alarm_data_huawei_history');  
      iRecordCount := Ado_Query.FieldByName('count').AsInteger;
      blDoDelete := (iRecordCount-iCountMax)>0;
      AppendRunLog('��ǰalarm_data_huawei_history����'+inttostr(iRecordCount)+'�����ݡ���ֵ��'+inttostr(iCountMax)+'����', blDoDelete); 
      if blDoDelete then
      begin
       strSQL := 'delete alarm_data_huawei_history c where c.rowid in '
             +'(select a.rowid from (select t.rowid from alarm_data_huawei_history t order by t.b ) a '
             +'where rownum <='+inttostr(iRecordCount-iCountMax+iCountDel)+' )';
       ExecSQL(strSQL);             
      end;

      OpenQuery('select count(*) count from alarm_data_huawei_comp_history');
      iRecordCount := Ado_Query.FieldByName('count').AsInteger;
      blDoDelete := (iRecordCount-iCountMax)>0;
      AppendRunLog('��ǰalarm_data_huawei_comp_history����'+inttostr(iRecordCount)+'�����ݡ���ֵ��'+inttostr(iCountMax)+'����', blDoDelete); 
      if blDoDelete then
      begin
       strSQL := 'delete alarm_data_huawei_comp_history c where c.rowid in '
             +'(select a.rowid from (select t.rowid from alarm_data_huawei_comp_history t order by t.createtime ) a '
             +'where rownum <='+inttostr(iRecordCount-iCountMax+iCountDel)+' )';
       ExecSQL(strSQL);
      end;
          
      AppendRunLog('������ʷ��ʱ����ɾ��������');
    except
      on E: exception do
      begin
        blSaveErrLog := true;
        AppendRunLog('��ʷ��ʱ����ɾ��ʧ�ܣ�'+E.Message, true);
      end;
    end;
  end;   
end;


procedure TCDMACollecctThread.SetDebug(pBlDebug: Boolean);
begin
  self.blDebug := pBlDebug;
end;

end.
