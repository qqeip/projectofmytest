unit Ut_AlarmTestDefine;

interface
uses
  WinSock,SysUtils;
  
//�澯�������
type
  RTestPack = record
    TestSn :integer;
    IP :String;
    Port :integer;
    deviceid:String;
    ContentCode :integer;
    batchid : integer;
    Cityid :integer;
    TestCode :String;
  end;
  TLXTEST= record
    Ver :Byte; //�汾��
    csc_slot :array[0..4] of Byte;
    csc_port :array[0..4] of Byte;
    csc_ip :array[0..14] of char;
    csc_uncp :array[0..14] of char;
  end;
  TTestResult = record
		cityid :integer;
    deviceid :String;
    ALARMCONTENTCODE :integer;
    Uac_ab: String;//ab������ѹ��
    Uac_ag: String;//ag������ѹ��
    Uac_bg: String;//bg������ѹ��
    Udc_ab: String;//abֱ����ѹ��
    Udc_ag: String;//agֱ����ѹ��
    Udc_bg: String;//bgֱ����ѹ��
    IR_ab: String;//ab��Ե����ֵ��
    IR_ag: String;//ag��Ե����ֵ��
    IR_bg: String;//bg��Ե����ֵ��
    SR_ab: String;//ab��Ե����ֵ��
    SR_ag: String;//ag��Ե����ֵ��
    SR_bg: String;//bg��Ե����ֵ��
    C_ab: String;//ab��·����ֵ��
    C_ag: String;//ag��·����ֵ��
    C_bg: String;//bg��·����ֵ��
    Uact : String ;//U�ڼ���״̬
    BERTS : String ;//���ͱ�����
    BERTE : String ;//���������
    WML   :String;
    TestResult: String;//���Խ��
  end;

  SIFRequest = Record
	   IProtocol: Integer;  //��Ϣ���         1001
	   TestSN: string[30];  //�����������кţ��ɷ������ɣ���ʽ����Ϊ��YYYYMMDDHHMMSSNNN
     CSCName: String[100];//��վ���������   0101
     CSCUNCP:string [100];//��վ������UNCP   1.38.1
     CSCIPAddr: String[15];//��վ������IP��ַ      10.180.11.1
     CSCClass:string [20]; //��վ����������״̬    ' '
     CsName:string [100];  //��վ����              010101
     CSNumber: String[100];//��վ���              ' '
     PortNumber: String[1];//���Զ˿ںţ�����վ�ϵ��߶Զ˿ڣ���1,2,3,4
     PortID: String[30];   //���Զ˿ڱ�ţ����߶Ա�ţ���    1-2-6
     PortStatus: String[20];//���Զ˿�״̬
     ComNo:Integer;       //���ںţ�δʹ��
     Force : Boolean;     // ǿ��ץ�ߣ�ȱʡΪFalse;
     AutoFlag : Boolean;  //�Ƿ�ǿ��ץ�ߣ�ȱʡΪFalse;
     TestType : Integer;  //�����������ͣ���Ϊ0���������ԡ�1�����в��ԡ�2���澯����
     ACTT : Integer;      //U�ڼ���ʱ��������Ϊ��λ
     BERTT : Integer;     //�����ʲ���ʱ��������Ϊ��λ
  end;
  
  SIFResult = record
		Iprotocol:Integer;//��Ϣ���
	  TestSN: String[30];//�����������к�
    Uac_ab: String[5];//ab������ѹ��
    Uac_ag: String[5];//ag������ѹ��
    Uac_bg: String[5];//bg������ѹ��
    Udc_ab: String[5];//abֱ����ѹ��
    Udc_ag: String[5];//agֱ����ѹ��
    Udc_bg: String[5];//bgֱ����ѹ��
    IR_ab: String[5];//ab��Ե����ֵ��
    IR_ag: String[5];//ag��Ե����ֵ��
    IR_bg: String[5];//bg��Ե����ֵ��
    SR_ab: String[5];//ab��Ե����ֵ��
    SR_ag: String[5];//ag��Ե����ֵ��
    SR_bg: String[5];//bg��Ե����ֵ��
    C_ab: String[5];//ab��·����ֵ��
    C_ag: String[5];//ag��·����ֵ��
    C_bg: String[5];//bg��·����ֵ��
    Uact : String[1];//U�ڼ���״̬
    BERTS : String[8];//���ͱ�����
    BERTE : String[8];//���������
    ACTC : String[2];//δʹ��
    ACTE : String[2];// δʹ��
    ACTL : String[8];// δʹ��
    SYCE : String[2];// δʹ��
    BO : String[2]; //δʹ��
    BE: String[1];// δʹ��
    IB: String[1];// δʹ��
    TWIST: String[5];//����
    BREAK: String[5];//����
    LR: String[1];// δʹ��
    COM: String[1];//�˿ںţ�δʹ�ã�
    Result: String[1];//���Խ��ۣ�
    Other: String[10];//���Ա�ע
    OccurTime: TDateTime;
    LineCode: String[2];//�߶Բ��Խ��
    Distance: String[5];//��·����
    Ustatus: String[2];//U�ڲ��Խ��
    ResultCode: String[2];//������Խ��
  end;

  function SendTestAlarm(R :RTestPack):Boolean;
  function GetPortID(CS, LineID: Integer): String;
  function GetSIFRequest(var RD : SIFRequest;R :RTestPack):boolean;
  function LineTestResult(R:SIFResult):String;
  //function TestResultProcess(TestSN,vResult:String):Boolean;
  function TestResultProcess(R :SIFResult;vResult:String):Boolean;
  function GetAlarmTestInfo(var R :RTestPack;cityid:integer):Boolean;overload;
  function GetAlarmTestInfo(cityid:integer;deviceid :String):Boolean;overload;
  function CSIsTest(cityid:integer;deviceid:String):Boolean;
  function CityIsTest(cityid:integer):Boolean;
  function SaveAlarmTestResult(R:TTestResult):Boolean;
  function GetLXSlot(port :integer) :integer;
  function GetLXPort(port :integer;Line:integer) :integer;
  procedure FillDefaultValue(var Test: TLXTEST);
  
implementation

uses Ut_Data_Local,Ut_RunLog;

procedure FillDefaultValue(var Test: TLXTEST);
begin
  with Test do
  begin
    Ver :=$EE;
    FillChar(csc_slot,SizeOf(csc_slot), $0);
    FillChar(csc_port, SizeOf(csc_port), $0);
    FillChar(csc_ip, SizeOf(csc_ip), $0);
    FillChar(csc_uncp, SizeOf(csc_uncp),$0);
  end
end;

//���ݻ�վ�˿ںż�������������˿�
function GetLXPort(port :integer;Line:integer) :integer;
begin
  if (port mod 2 = 0) then
  case Line of
    1:  result := 3;
    2:  result := 7;
    3:  result := 4;
    4:  result := 8;
  end
  else
  case Line of
    1:  result := 1;
    2:  result := 5;
    3:  result := 2;
    4:  result := 6;
  end;
end;
//���ݻ�վ�˿ںż� ���������ۺ�
function GetLXSlot(port :integer) :integer;
begin
  result :=trunc((Port-1)/2)+2;
end;

//�ж�ĳ�����Ƿ�����澯����
function CityIsTest(cityid:integer):Boolean;
begin
  result := false;
  with Dm_Collect_Local.Ado_Free do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from alarm_sys_function_set where kind =22 and code =1 and cityid=:cityid ');
    parameters.ParamByName('cityid').Value :=  cityid;
    Open;
    if (RecordCount > 0) and (FieldByName('content').AsInteger=1) then
      result := true;
    Close;
  end;
end;
//�ж�ĳ���е�ĳ����վ�Ƿ�����澯����
function CSIsTest(cityid:integer;deviceid:String):Boolean;
begin
  result := false;
  with Dm_Collect_Local.Ado_Free do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from alarm_cs_fortest where cityid=:cityid and deviceid=:deviceid');
    parameters.ParamByName('deviceid').Value :=  deviceid;
    parameters.ParamByName('cityid').Value :=  cityid;
    Open;
    if RecordCount > 0 then result := true;
    Close;
  end;
end;
function GetSIFRequest(var RD : SIFRequest;R :RTestPack):boolean;
var
  sqlstr :String;
begin
  result := false;
  sqlstr :=' select GW,CSC,deviceid,substr(deviceid,1,instr(deviceid,''@'')-1) as UNCP,cs_index,'+
           ' substr(deviceid,instr(deviceid,''@'')+1,instr(deviceid,''_'')-1-instr(deviceid,''@'') ) as CSCIP'+
           ' from fms_device_info where deviceid=:deviceid and cityid=:cityid';
  try
    with Dm_Collect_Local.Ado_Free do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      parameters.ParamByName('deviceid').Value := R.deviceid;
      parameters.ParamByName('cityid').Value := R.cityid;
      Open;
      if RecordCount > 0 then
      begin
        With RD do
        begin
          IProtocol   := 1101;  //��Ϣ���
	        TestSN      :=IntToStr(R.TestSn);
          CSCName     :=FieldByName('GW').AsString+FieldByName('CSC').AsString;//��վ���������   GW-CSC
          CSCUNCP     :=FieldByName('UNCP').AsString;//��վ������UNCP
          CSCIPAddr   :=FieldByName('CSCIP').AsString;//��վ������IP��ַ
          CSCClass    :=''; //��վ����������״̬
          CsName      :=FieldByName('GW').AsString+FieldByName('CSC').AsString+FieldByName('cs_index').AsString;//��վ���� GW-CSC-CS
          CSNumber    := '';//��վ���
          PortNumber  := R.TestCode;//���Զ˿ںţ�����վ�ϵ��߶Զ˿ڣ���1,2,3,4
          PortID      :=GetPortID(FieldByName('cs_index').AsInteger,StrToInt(R.TestCode));   //���Զ˿ڱ�ţ����߶Ա�ţ���
          PortStatus  := '' ;//���Զ˿�״̬
          ComNo       :=1;    //���ںţ�δʹ��
          Force       :=false;// ǿ��ץ�ߣ�ȱʡΪFalse;
          AutoFlag    :=false;  //�Ƿ�ǿ��ץ�ߣ�ȱʡΪFalse;
          TestType    :=0;  //�����������ͣ���Ϊ0���������ԡ�1�����в��ԡ�2���澯����
          ACTT        :=65;     //U�ڼ���ʱ��������Ϊ��λ
          BERTT       :=30;    //�����ʲ���ʱ��������Ϊ��λ
        end;
      end;
      result := true;
      Close;
    end;
  except
  end;
end;

function SendTestAlarm(R :RTestPack):Boolean;
var
  RD : SIFRequest;
begin
  result := true;
  try
    if GetSIFRequest(RD,R) then
    begin
      Fm_RunLog.AlarmTestClient.Host := R.IP;
      Fm_RunLog.AlarmTestClient.Port := R.Port;
      Fm_RunLog.AlarmTestClient.Active := true;
      Fm_RunLog.AlarmTestClient.SendBuffer(RD,Sizeof(SIFRequest));
    end;
  except
    result := false;
  end;
end;

function GetPortID(CS, LineID: Integer): String;
begin
  result :='';
  Case LineID of
      1:
      begin
        case (CS mod 2) of
          0: result := '1-' + IntToStr(CS div 2 + 1) + '-3';
          1: result := '1-' + IntToStr((CS+1) div 2 + 1) + '-1';
        end;
      end;//end of 1

      2:
      begin
        case (CS mod 2) of
          0: result := '1-' + IntToStr(CS div 2 + 1) + '-7';
          1: result := '1-' + IntToStr((CS+1) div 2 + 1) + '-5';
        end;
      end;//end of 2

      3:
      begin
        case (CS mod 2) of
          0: result := '1-' + IntToStr(CS div 2 + 1) + '-4';
          1: result := '1-' + IntToStr((CS+1) div 2 + 1) + '-2';
        end;
      end;//end of 3

      4:
      begin
        case (CS mod 2) of
          0: result := '1-' + IntToStr(CS div 2 + 1) + '-8';
          1: result := '1-' + IntToStr((CS+1) div 2 + 1) + '-6';
        end;
      end;//end of 4
    end;//end of case
end;
// ��ȡ���Խ��
function LineTestResult(R:SIFResult):String;
var
  vUactive,vResult,vResultAll :String;
begin
  result :='';
  if R.Other <> '' then    //����ʧ�ܻ�ȡʧ������
  begin
    if R.Other='-1;' then Result := '����ʧ��: δ�������'
    else if R.Other='-2;' then Result := '����ʧ��: ��·æ���У�'
    else if R.Other='-3;' then Result := '����ʧ��: �Ƿ���ˮ�ţ�'
    else if R.Other='-4;' then Result := '����ʧ��: �ظ�ץ�ߣ�'
    else if R.Other='-5;' then Result := '����ʧ��: �˿ڲ����ڣ�'
    else if R.Other='-6;' then Result := '����ʧ��: ���߶Բ���ʧ�ܣ�'
    else if R.Other='-7;' then Result := '����ʧ��: �ظ�ץ�ߣ�'
    else if R.Other='-8;' then Result := '����ʧ��: �ظ����ߣ�'
    else if R.Other='-9;' then Result := '����ʧ��: ����ʧ�ܣ�'
    else if R.Other='-10;' then Result := '����ʧ��: ץ���ߵ��߶Բ�ƥ�䣡'
    else if R.Other='-101;' then Result := '����ʧ��: ��ʶ��Ĳ������'
    else if R.Other='-104;' then Result := '����ʧ��: ����ʱ�䳬ʱ��'
    else if R.Other='-106;' then Result := '����ʧ��: LTP��δ���ø�CSC��'
    else if R.Other='-107;' then Result := '����ʧ��: ����һ���Կͻ����ڶ�ͬһ����ͷ������ԣ�' 
    else  Result :='����ʧ��: δ֪����';
  end
  else //���Գɹ���ȡ���Խ������
  begin
    if R.Ustatus = '01' then vUActive := '���ܼ���޻�Ӧ';
    if R.Ustatus = '02' then vUActive := 'ͨ��״���ϲ�����ȶ�����';
    if R.Ustatus = '03' then vUActive := '�ɹ����ͨ��״������';
    if R.Ustatus = '04' then vUActive := '�ɹ����������';
    if R.Ustatus = '05' then vUActive := '�ɹ����������';

    if R.LineCode = '01' then vResult := '��·����';
    if R.LineCode = '02' then vResult := '��·�ڶ�';
    if R.LineCode = '03' then vResult := '��·��� ' + R.Distance + ' ǧ��';
    if R.LineCode = '04' then vResult := '��·�ڽ�';
    if R.LineCode = '05' then vResult := '��·��� ' + R.Distance + ' ǧ��';
    if R.LineCode = '06' then vResult := '��Ե����';
    if R.LineCode = '07' then vResult := 'ԧ����';
    if R.LineCode = '08' then vResult := '��·����';

    if R.ResultCode = '01' then vResultAll := '����ͨ��';
    if R.ResultCode = '02' then vResultAll := '����δͨ��';
    if R.ResultCode = '03' then vResultAll := '��վ����ͣ��';

    if R.LineCode = '06' then
    begin
        if (Pos('<',R.C_ag) >= 0) or (Pos('=', R.C_ag) >=0) then vResult := 'A�ߵ���';
        if (Pos('<',R.C_bg) >= 0) or (Pos('=', R.C_bg) >=0) then vResult := 'B�ߵ���';
    end;
    if  R.BERTS ='0' then
      result := vUactive + ' ' + vResult + ' ' + vResultAll+' �����ʣ�>10%'
    else
      result := vUactive + ' ' + vResult + ' ' + vResultAll+' �����ʣ�'+FloatToStr((StrToInt(R.BERTE)/StrToInt(R.BERTS))*100)+'%';
  end;
end;

function SaveAlarmTestResult(R:TTestResult):Boolean;
var
  sqlstr :String;
begin
  result := true;
  try
    sqlstr :=' insert into alarm_test_feedback (cityid, updatetime, alarmcontentcode, deviceid, uac_ab, uac_ag, uac_bg, udc_ab, udc_ag, udc_bg, ir_ab, ir_ag, ir_bg, sr_ab, sr_ag, sr_bg, c_ab, c_ag, c_bg, uact, berts, berte, testresult,WML)'+
             ' values (:cityid, sysdate, :alarmcontentcode, :deviceid, :uac_ab, :uac_ag, :uac_bg, :udc_ab, :udc_ag, :udc_bg, :ir_ab, :ir_ag, :ir_bg, :sr_ab, :sr_ag, :sr_bg, :c_ab, :c_ag, :c_bg, :uact, :berts, :berte, :testresult,:WML)';
    with Dm_Collect_Local.Ado_Dynamic,R do
    begin
      Close;
      SQL.Clear;
      SQL.Add('delete from ALARM_TEST_FEEDBACK where cityid=:cityid and deviceid=:deviceid and alarmcontentcode=:alarmcontentcode');
      Parameters.ParamByName('deviceid').Value := deviceid;
      Parameters.ParamByName('cityid').Value := cityid;
      Parameters.ParamByName('alarmcontentcode').Value := alarmcontentcode;
      ExecSql;
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      Parameters.ParamByName('deviceid').Value := deviceid;
      Parameters.ParamByName('cityid').Value := cityid;
      Parameters.ParamByName('alarmcontentcode').Value := alarmcontentcode;
      Parameters.ParamByName('UAC_AB').Value := UAC_AB;
      Parameters.ParamByName('UAC_AG').Value := UAC_AG;
      Parameters.ParamByName('UAC_BG').Value := UAC_BG;
      Parameters.ParamByName('UDC_AB').Value := UDC_AB;
      Parameters.ParamByName('UDC_AG').Value := UDC_AG;
      Parameters.ParamByName('UDC_BG').Value := UDC_BG;
      Parameters.ParamByName('IR_AB').Value := IR_AB;
      Parameters.ParamByName('IR_AG').Value := IR_AG;
      Parameters.ParamByName('IR_BG').Value := IR_BG;
      Parameters.ParamByName('SR_AB').Value := SR_AB;
      Parameters.ParamByName('SR_AG').Value := SR_AG;
      Parameters.ParamByName('SR_BG').Value := SR_BG;
      Parameters.ParamByName('C_AB').Value := C_AB;
      Parameters.ParamByName('C_AG').Value := C_AG;
      Parameters.ParamByName('C_BG').Value := C_BG;
      Parameters.ParamByName('UACT').Value := UACT;
      Parameters.ParamByName('BERTS').Value := BERTS;
      Parameters.ParamByName('BERTE').Value := BERTE;
      Parameters.ParamByName('TESTRESULT').Value := TESTRESULT;
      Parameters.ParamByName('WML').Value := WML;
      ExecSql;
    end;
  except
    result := false;
  end;
end;

//�����Խ�����µ�ҵ����У����Ӳ��Ա���ɾ��      TestSN -> �����alarm_test_result ���� ��ΪΨһ��������
function TestResultProcess(R :SIFResult;vResult:String):Boolean;
var
  batchid,iCount :Integer;
  TR :TTestResult;
begin
  result := true;
  try
    //ͨ���������к��һ�վ���澯��Ϣ
    with Dm_Collect_Local.Ado_Dynamic,R do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from alarm_test_asklist where testsn='''+testsn+'''');
      Open;
      if RecordCount = 0 then
      begin
        Close;
        Exit;
      end;
      TR.cityid := FieldByName('cityid').AsInteger;
      TR.ALARMCONTENTCODE := FieldByName('contentcode').AsInteger;
      batchid := FieldByName('batchid').AsInteger;
      TR.deviceid :=FieldByName('deviceid').AsString;
      TR.Uac_ab := Uac_ab;
      TR.Uac_ag := Uac_ag;
      TR.Uac_bg := Uac_bg;
      TR.Udc_ab := Udc_ab;
      TR.Udc_ag := Udc_ag;
      TR.Udc_bg := Udc_bg;
      TR.IR_ab  := IR_ab;
      TR.IR_ag  := IR_ag;
      TR.IR_bg  := IR_bg;
      TR.SR_ab  := SR_ab;
      TR.SR_ag  := SR_ag;
      TR.SR_bg  := SR_bg;
      TR.C_ab   := C_ab;
      TR.C_ag   := C_ag;
      TR.C_bg   := C_bg;
      TR.Uact   := Uact ;
      TR.BERTS  := BERTS;
      TR.BERTE  := BERTE;
      if (BERTE='') or (BERTS='') or (BERTS='0') then
        TR.WML  :=''
      else
        TR.WML  := FloatToStr((StrToInt(BERTE)/StrToINt(BERTS))*100)+'%';
      TR.TestResult :=vResult;
    end;
    //������Խ��
    SaveAlarmTestResult(TR);
    //�����û��Ĳ��������б��Ѿ�������ɣ����Բ鿴
    with Dm_Collect_Local.Ado_Dynamic do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update alarm_usertest_asklist set istest =1 where cityid=:cityid and deviceid=:deviceid');
      Parameters.ParamByName('cityid').Value := TR.cityid;
      Parameters.ParamByName('deviceid').Value := TR.deviceid;
      ExecSQL;
    end;

    if batchid=-1 then   //˵���Ǹ澯�ɼ���
      with Dm_Collect_Local.Ado_Dynamic,TR do
      begin
        Close;
        SQL.Clear;
        SQL.Add('update alarm_data_collect  set  ERRORCONTENT=:errorcontent where contentcode = :contentcode and deviceid=:deviceid and cityid=:cityid');
        Parameters.ParamByName('deviceid').Value := deviceid;
        Parameters.ParamByName('cityid').Value := cityid;
        Parameters.ParamByName('errorcontent').Value := vResult;
        Parameters.ParamByName('contentcode').Value := alarmcontentcode;
        iCount := ExecSQL;
        if iCount = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add('update fault_detail_online  set  ERRORCONTENT=:errorcontent where alarmcontentcode = :contentcode and deviceid=:deviceid and cityid=:cityid');
          Parameters.ParamByName('deviceid').Value := deviceid;
          Parameters.ParamByName('cityid').Value := cityid;
          Parameters.ParamByName('errorcontent').Value := vResult;
          Parameters.ParamByName('contentcode').Value := alarmcontentcode;
          ExecSQL;
        end;

        Close;
        SQL.Clear;
        SQL.Add('delete from alarm_test_asklist where contentcode = :contentcode and deviceid=:deviceid and cityid=:cityid');
        Parameters.ParamByName('deviceid').Value := deviceid;
        Parameters.ParamByName('cityid').Value := cityid;
        Parameters.ParamByName('contentcode').Value := alarmcontentcode;
        ExecSQL;
      end
    else   // batchid <> -1 ˵���û�����
      with Dm_Collect_Local.Ado_Dynamic,TR do
      begin
        Close;
        SQL.Clear;
        SQL.Add('update fault_detail_online  set  ERRORCONTENT=:errorcontent where alarmcontentcode = :contentcode and deviceid=:deviceid and batchid=:batchid and cityid=:cityid');
        Parameters.ParamByName('deviceid').Value := deviceid;
        Parameters.ParamByName('cityid').Value := cityid;
        Parameters.ParamByName('errorcontent').Value := vResult;
        Parameters.ParamByName('contentcode').Value := alarmcontentcode;
        Parameters.ParamByName('batchid').Value := batchid;
        iCount := ExecSQL;
        if iCount = 0 then
        begin
          Close;
          SQL.Clear;
          SQL.Add('update fault_detail_history  set  ERRORCONTENT=:errorcontent where alarmcontentcode = :contentcode and deviceid=:deviceid and batchid=:batchid and cityid=:cityid');
          Parameters.ParamByName('deviceid').Value := deviceid;
          Parameters.ParamByName('cityid').Value := cityid;
          Parameters.ParamByName('errorcontent').Value := vResult;
          Parameters.ParamByName('contentcode').Value := alarmcontentcode;
          Parameters.ParamByName('batchid').Value := batchid;
          ExecSQL;
        end;
        Close;
        SQL.Clear;
        SQL.Add('delete from alarm_test_asklist where contentcode = :contentcode and deviceid=:deviceid and cityid=:cityid');
        Parameters.ParamByName('deviceid').Value := deviceid;
        Parameters.ParamByName('cityid').Value := cityid;
        Parameters.ParamByName('contentcode').Value := alarmcontentcode;
        ExecSQL;
      end;
  except
    on E:Exception do
      Fm_RunLog.WriteMessageLog('���³ɶ��ķ��澯���Խ��ʧ��:'+E.Message);
  end;
end;


//���ݳ��б�Ż�ȡ�澯���Է�����IP���˿�
function GetAlarmTestInfo( var R :RTestPack; cityid:integer):Boolean;
var
  i:integer;
begin
  Result:=false;
  with Dm_Collect_Local do
  begin
    for i:=low(AlarmParam) to high(AlarmParam) do
    if AlarmParam[i].CityID=CityID then
    begin
      if AlarmParam[i].TestIP <> '' then
      begin
        R.IP := AlarmParam[i].TestIP;
        R.Port := AlarmParam[i].TestPort;
        result := true;
        break;
      end;
    end;
  end;
end;
function GetAlarmTestInfo(cityid:integer;deviceid :String):Boolean;overload;
var
  i:integer;
begin
  Result:=false;
  with Dm_Collect_Local do
  begin
    for i:=low(AlarmParam) to high(AlarmParam) do
    if AlarmParam[i].CityID=CityID then
    begin
      if AlarmParam[i].TestIP <> '' then
      begin
        result :=CityIsTest(cityid) and CSIsTest(cityid,deviceid);
        break;
      end;
    end;
  end;
end;

end.
 