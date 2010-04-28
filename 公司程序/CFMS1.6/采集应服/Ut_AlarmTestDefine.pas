unit Ut_AlarmTestDefine;

interface
uses
  WinSock,SysUtils;
  
//告警测试相关
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
    Ver :Byte; //版本号
    csc_slot :array[0..4] of Byte;
    csc_port :array[0..4] of Byte;
    csc_ip :array[0..14] of char;
    csc_uncp :array[0..14] of char;
  end;
  TTestResult = record
		cityid :integer;
    deviceid :String;
    ALARMCONTENTCODE :integer;
    Uac_ab: String;//ab交流电压；
    Uac_ag: String;//ag交流电压；
    Uac_bg: String;//bg交流电压；
    Udc_ab: String;//ab直流电压；
    Udc_ag: String;//ag直流电压；
    Udc_bg: String;//bg直流电压；
    IR_ab: String;//ab绝缘电阻值；
    IR_ag: String;//ag绝缘电阻值；
    IR_bg: String;//bg绝缘电阻值；
    SR_ab: String;//ab绝缘电阻值；
    SR_ag: String;//ag绝缘电阻值；
    SR_bg: String;//bg绝缘电阻值；
    C_ab: String;//ab线路电容值；
    C_ag: String;//ag线路电容值；
    C_bg: String;//bg线路电容值；
    Uact : String ;//U口激活状态
    BERTS : String ;//发送比特数
    BERTE : String ;//错误比特数
    WML   :String;
    TestResult: String;//测试结果
  end;

  SIFRequest = Record
	   IProtocol: Integer;  //消息编号         1001
	   TestSN: string[30];  //测试任务序列号，由发起方生成，格式建议为：YYYYMMDDHHMMSSNNN
     CSCName: String[100];//基站控制器编号   0101
     CSCUNCP:string [100];//基站控制器UNCP   1.38.1
     CSCIPAddr: String[15];//基站控制器IP地址      10.180.11.1
     CSCClass:string [20]; //基站控制器主从状态    ' '
     CsName:string [100];  //基站名称              010101
     CSNumber: String[100];//基站编号              ' '
     PortNumber: String[1];//测试端口号，即基站上的线对端口，如1,2,3,4
     PortID: String[30];   //测试端口编号，即线对编号，如    1-2-6
     PortStatus: String[20];//测试端口状态
     ComNo:Integer;       //串口号，未使用
     Force : Boolean;     // 强制抓线，缺省为False;
     AutoFlag : Boolean;  //是否强制抓线，缺省为False;
     TestType : Integer;  //测试命令类型，分为0：点名测试、1：例行测试、2：告警测试
     ACTT : Integer;      //U口激活时长，以秒为单位
     BERTT : Integer;     //误码率测试时长，以秒为单位
  end;
  
  SIFResult = record
		Iprotocol:Integer;//消息编号
	  TestSN: String[30];//测试任务序列号
    Uac_ab: String[5];//ab交流电压；
    Uac_ag: String[5];//ag交流电压；
    Uac_bg: String[5];//bg交流电压；
    Udc_ab: String[5];//ab直流电压；
    Udc_ag: String[5];//ag直流电压；
    Udc_bg: String[5];//bg直流电压；
    IR_ab: String[5];//ab绝缘电阻值；
    IR_ag: String[5];//ag绝缘电阻值；
    IR_bg: String[5];//bg绝缘电阻值；
    SR_ab: String[5];//ab绝缘电阻值；
    SR_ag: String[5];//ag绝缘电阻值；
    SR_bg: String[5];//bg绝缘电阻值；
    C_ab: String[5];//ab线路电容值；
    C_ag: String[5];//ag线路电容值；
    C_bg: String[5];//bg线路电容值；
    Uact : String[1];//U口激活状态
    BERTS : String[8];//发送比特数
    BERTE : String[8];//错误比特数
    ACTC : String[2];//未使用
    ACTE : String[2];// 未使用
    ACTL : String[8];// 未使用
    SYCE : String[2];// 未使用
    BO : String[2]; //未使用
    BE: String[1];// 未使用
    IB: String[1];// 未使用
    TWIST: String[5];//绞线
    BREAK: String[5];//断线
    LR: String[1];// 未使用
    COM: String[1];//端口号，未使用；
    Result: String[1];//定性结论；
    Other: String[10];//测试备注
    OccurTime: TDateTime;
    LineCode: String[2];//线对测试结果
    Distance: String[5];//线路长度
    Ustatus: String[2];//U口测试结果
    ResultCode: String[2];//总体测试结果
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

//根据基站端口号及线序计算出理想端口
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
//根据基站端口号及 计算出理想槽号
function GetLXSlot(port :integer) :integer;
begin
  result :=trunc((Port-1)/2)+2;
end;

//判断某地市是否允许告警测试
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
//判断某地市的某个基站是否允许告警测试
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
          IProtocol   := 1101;  //消息编号
	        TestSN      :=IntToStr(R.TestSn);
          CSCName     :=FieldByName('GW').AsString+FieldByName('CSC').AsString;//基站控制器编号   GW-CSC
          CSCUNCP     :=FieldByName('UNCP').AsString;//基站控制器UNCP
          CSCIPAddr   :=FieldByName('CSCIP').AsString;//基站控制器IP地址
          CSCClass    :=''; //基站控制器主从状态
          CsName      :=FieldByName('GW').AsString+FieldByName('CSC').AsString+FieldByName('cs_index').AsString;//基站名称 GW-CSC-CS
          CSNumber    := '';//基站编号
          PortNumber  := R.TestCode;//测试端口号，即基站上的线对端口，如1,2,3,4
          PortID      :=GetPortID(FieldByName('cs_index').AsInteger,StrToInt(R.TestCode));   //测试端口编号，即线对编号，如
          PortStatus  := '' ;//测试端口状态
          ComNo       :=1;    //串口号，未使用
          Force       :=false;// 强制抓线，缺省为False;
          AutoFlag    :=false;  //是否强制抓线，缺省为False;
          TestType    :=0;  //测试命令类型，分为0：点名测试、1：例行测试、2：告警测试
          ACTT        :=65;     //U口激活时长，以秒为单位
          BERTT       :=30;    //误码率测试时长，以秒为单位
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
// 获取测试结果
function LineTestResult(R:SIFResult):String;
var
  vUactive,vResult,vResultAll :String;
begin
  result :='';
  if R.Other <> '' then    //测试失败获取失败描述
  begin
    if R.Other='-1;' then Result := '测试失败: 未定义错误！'
    else if R.Other='-2;' then Result := '测试失败: 线路忙线中！'
    else if R.Other='-3;' then Result := '测试失败: 非法流水号！'
    else if R.Other='-4;' then Result := '测试失败: 重复抓线！'
    else if R.Other='-5;' then Result := '测试失败: 端口不存在！'
    else if R.Other='-6;' then Result := '测试失败: 主线对操作失败！'
    else if R.Other='-7;' then Result := '测试失败: 重复抓线！'
    else if R.Other='-8;' then Result := '测试失败: 重复放线！'
    else if R.Other='-9;' then Result := '测试失败: 放线失败！'
    else if R.Other='-10;' then Result := '测试失败: 抓放线的线对不匹配！'
    else if R.Other='-101;' then Result := '测试失败: 不识别的测试命令！'
    else if R.Other='-104;' then Result := '测试失败: 测试时间超时！'
    else if R.Other='-106;' then Result := '测试失败: LTP中未配置该CSC！'
    else if R.Other='-107;' then Result := '测试失败: 有另一测试客户端在对同一测试头发起测试！' 
    else  Result :='测试失败: 未知错误';
  end
  else //测试成功获取测试结果描述
  begin
    if R.Ustatus = '01' then vUActive := '不能激活，无回应';
    if R.Ustatus = '02' then vUActive := '通道状况较差，不能稳定连接';
    if R.Ustatus = '03' then vUActive := '成功激活，通道状况不良';
    if R.Ustatus = '04' then vUActive := '成功激活，有误码';
    if R.Ustatus = '05' then vUActive := '成功激活，无误码';

    if R.LineCode = '01' then vResult := '线路串电';
    if R.LineCode = '02' then vResult := '线路内断';
    if R.LineCode = '03' then vResult := '线路外断 ' + R.Distance + ' 千米';
    if R.LineCode = '04' then vResult := '线路内绞';
    if R.LineCode = '05' then vResult := '线路外绞 ' + R.Distance + ' 千米';
    if R.LineCode = '06' then vResult := '绝缘不良';
    if R.LineCode = '07' then vResult := '鸳鸯线';
    if R.LineCode = '08' then vResult := '线路正常';

    if R.ResultCode = '01' then vResultAll := '测试通过';
    if R.ResultCode = '02' then vResultAll := '测试未通过';
    if R.ResultCode = '03' then vResultAll := '基站可能停电';

    if R.LineCode = '06' then
    begin
        if (Pos('<',R.C_ag) >= 0) or (Pos('=', R.C_ag) >=0) then vResult := 'A线地气';
        if (Pos('<',R.C_bg) >= 0) or (Pos('=', R.C_bg) >=0) then vResult := 'B线地气';
    end;
    if  R.BERTS ='0' then
      result := vUactive + ' ' + vResult + ' ' + vResultAll+' 误码率：>10%'
    else
      result := vUactive + ' ' + vResult + ' ' + vResultAll+' 误码率：'+FloatToStr((StrToInt(R.BERTE)/StrToInt(R.BERTS))*100)+'%';
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

//将测试结果更新到业务表中，并从测试表中删除      TestSN -> 存放在alarm_test_result 表中 作为唯一测试序列
function TestResultProcess(R :SIFResult;vResult:String):Boolean;
var
  batchid,iCount :Integer;
  TR :TTestResult;
begin
  result := true;
  try
    //通过测试序列号找基站及告警信息
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
    //保存测试结果
    SaveAlarmTestResult(TR);
    //更新用户的测试请求列表已经测试完成，可以查看
    with Dm_Collect_Local.Ado_Dynamic do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update alarm_usertest_asklist set istest =1 where cityid=:cityid and deviceid=:deviceid');
      Parameters.ParamByName('cityid').Value := TR.cityid;
      Parameters.ParamByName('deviceid').Value := TR.deviceid;
      ExecSQL;
    end;

    if batchid=-1 then   //说明是告警采集表
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
    else   // batchid <> -1 说明用户测试
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
      Fm_RunLog.WriteMessageLog('更新成都四方告警测试结果失败:'+E.Message);
  end;
end;


//根据城市编号获取告警测试服务器IP及端口
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
 