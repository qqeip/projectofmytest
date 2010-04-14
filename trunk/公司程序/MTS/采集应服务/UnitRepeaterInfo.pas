{
  ֱ��վ�ฺ��������ݰ��͹������ݰ�
}
unit UnitRepeaterInfo;

interface

uses
  SysUtils, Classes;

const
  WD_REP_NORMAL = 0;
  WD_REP_PARAMQUERY_ASK = 32;              //���ϵͳ������ѯ
  WD_REP_PARAMQUERY_ANSWER = 132;
  WD_REP_PARAMDRSQUERY_ASK = 33;           //ֱ��վ������ѯ
  WD_REP_PARAMDRSQUERY_ANSWER = 133;
  WD_REP_PARAMWDPQUERY_ASK= 34;            //α��Ƶ�����������ѯ
  WD_REP_PARAMWDPQUERY_ANSWER= 134;

  WD_REP_PARAMDRSNOSET_ASK= 48;            //����ֱ��վϵͳ���
  WD_REP_PARAMDRSNOSET_ANSWER= 148;
  WD_REP_PARAMRCOMSET_ASK= 49;             //����Զ��ͨ�Ų���
  WD_REP_PARAMRCOMSET_ANSWER= 149;
  WD_REP_PARAMRAUTOALARMSET_ASK= 50;       //����ֱ��վ�����澯ʹ�ܱ�־
  WD_REP_PARAMRAUTOALARMSET_ANSWER= 150;
  WD_REP_PARAMRESHOLDSET_ASK= 51;          //��������ֵ
  WD_REP_PARAMRESHOLDSET_ANSWER= 151;
  WD_REP_PARAMSWITCHSET_ASK= 52;           //���ù��ſ�����
  WD_REP_PARAMSWITCHSET_ANSWER= 152;
  WD_REP_PARAMDAMPSET_ASK= 53;             //����˥����
  WD_REP_PARAMDAMPSET_ANSWER= 153;
  WD_REP_PARAMCHANNELSET_ASK= 54;          //�����ŵ���
  WD_REP_PARAMCHANNELSET_ANSWER= 154;
  WD_REP_PARAMWDPFSJSET_ASK= 55;           //�����ŵ���
  WD_REP_PARAMWDPFSJSET_ANSWER= 155;

  WD_REP_PARAMAUTOALARMQUERY_ASK= 16;
  WD_REP_PARAMAUTOALARMQUERY_ANSWER= 116;

type
  //�������ͷ
  TComCtrlHead = record
    Verson: string;              //Э��汾��
    PackageCounts: string;       //�ܰ���
    PackageIndex: string;        //�����
    DeviceType: string;          //�豸����
    MsgID: string;               //������
    //Repeaterid: Byte;          //ֱ��վ���
    DRSNO: string;             //ֱ��վ���
    Deviceid: string;            //�豸���
    AskTag: string;              //Ӧ���־
    DataLength: string;          //�����峤��
  end;

type
  TRepBase = class (TObject)
  private
    FStartTag, FEndTag: string;
    FComCtrlHead: TComCtrlHead;
    FCityid: integer;
    FDRSID: integer;
    FTaskid: integer;
    FCollectTime: TDatetime;
    FDRSNO: string;
    FReturnFlag: string;
    FSubmmitCode: string;
    FDeviceType: string;
    FR_Deviceid: string;
    FAskTag: string;
    FDataLength: string;
    FCreateTime: TDateTime;
    FDestCall: string;
    FMsgID: integer;
    procedure SetCityid(const Value: integer);
    procedure SetDRSID(const Value: integer);
    procedure SetTaskid(const Value: integer);
    procedure SetCollectTime(const Value: TDatetime);
    procedure SetDRSNO(const Value: string);
    procedure SetReturnFlag(const Value: string);
    procedure SetSubmmitCode(const Value: string);
    procedure SetAskTag(const Value: string);
    procedure SetDataLength(const Value: string);
    procedure SetDeviceType(const Value: string);
    procedure SetR_Deviceid(const Value: string);
    procedure SetCreateTime(const Value: TDateTime);
    procedure SetDestCall(const Value: string);
    procedure SetMsgID(const Value: integer);
  protected
    FMsgName: string;
    FMsgData: string;           //������
    procedure PutCommandUnit(var EnCode :string);
    function GetCommandUnit(EnCode :string): boolean;
    function GetCommandRecord: boolean;
    //Ӧ��
    procedure RequestDevice(var aSQLList :TStringList; aCityid, aTaskid, aMsgid, aDrsid: integer;
                            aDrsNo, aR_Deviceid, aDevicetype, aAskFlag: string);
  public
    constructor create;
    Destructor Destroy ; override;
    function GetTestEnCode(var EnCode :string):Boolean;virtual;abstract;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;virtual;

    property Taskid: integer read FTaskid write SetTaskid;
    property Cityid: integer read FCityid write SetCityid;
    property DeviceType: string read FDeviceType write SetDeviceType;
    property DRSID: integer read FDRSID write SetDRSID;
    property DRSNO: string read FDRSNO write SetDRSNO;
    property R_Deviceid: string read FR_Deviceid write SetR_Deviceid;
    property AskTag: string read FAskTag write SetAskTag;
    property DataLength: string read FDataLength write SetDataLength;
    property CollectTime: TDatetime read FCollectTime write SetCollectTime;
    property MsgID: integer read FMsgID write SetMsgID;
    //������ʶ ����ReturnFlag��ȡ�ĸ������͵Ľ��
    property ReturnFlag: string read FReturnFlag write SetReturnFlag;
    property DestCall: string read FDestCall write SetDestCall;
    //���͸����ص�����
    property SubmmitCode: string read FSubmmitCode write SetSubmmitCode;
    property CreateTime: TDateTime read FCreateTime write SetCreateTime;
  end;

  TRepParamQuery = class(TRepBase)
  public
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepDRSParamQuery = class(TRepBase)
  public
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepWDPParamQuery = class(TRepBase)
  public
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepDRSNOParamSet = class(TRepBase)
  public
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepRCOMParamSet = class(TRepBase)
  private
    FParamQueryCall: string;
    FParamAlarmCall: string;
    FParamComtype: string;
    procedure SetParamQueryCall(const Value: string);
    procedure SetParamAlarmCall(const Value: string);
    procedure SetParamComtype(const Value: string);
  published
  public
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;

    property ParamQueryCall: string read FParamQueryCall write SetParamQueryCall;
    property ParamAlarmCall: string read FParamAlarmCall write SetParamAlarmCall;
    property ParamComtype: string read FParamComtype write SetParamComtype;
  end;

  TRepAUTOALARMParamSet = class(TRepBase)
  public
    Param_17: string;
    Param_16: string;
    Param_15: string;
    Param_14: string;
    Param_13: string;
    Param_12: string;
    Param_11: string;
    Param_10: string;

    Param_27: string;
    Param_26: string;
    Param_25: string;
    Param_24: string;
    Param_23: string;
    Param_22: string;
    Param_21: string;
    Param_20: string;

    Param_37: string;
    Param_36: string;
    Param_35: string;
    Param_34: string;
    Param_33: string;
    Param_32: string;
    Param_31: string;
    Param_30: string;
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepESHOLDParamSet = class(TRepBase)
  public
    Param1: string;
    Param2: string;
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepSWITCHParamSet = class(TRepBase)
  public
    Param1: string;
    Param2: string;
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepDAMPParamSet = class(TRepBase)
  public
    Param1: string;
    Param2: string;
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepCHANNELParamSet = class(TRepBase)
  public
    Param1: string;
    Param2: string;
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepWDPFSJParamSet = class(TRepBase)
  public
    Param1: string;
    Param2: string;
    Param3: string;
    Param4: string;
    Param6: string;
    Param8: string;
    Param9: string;
    Param10: string;
    Param11: string;
    Param12: string;
    Param13: string;
    Param14: string;
    Param15: string;
    Param16: string;
    Param17: string;
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

  TRepAUTOALARMParamQuery = class(TRepBase)
  public
    constructor create(IsTest :boolean=false);
    function GetTestEnCode(var EnCode :string):Boolean;override;
    function DecodeMsgSQL(var Msg:string; var SQLList :TStringList):boolean;override;
  end;

const
  INSERTSQL= 'insert into drs_testresult_online'+
             ' (taskid, cityid, drsid, comid, paramid, valueindex, testresult, collecttime, execid, isprocess)'+
             ' select %d,%d,%d,%d,%d,%d,''%s'',to_date(''%s'',''yyyy-mm-dd hh24:mi:ss''),%d,%d from dual';
  UPDATESQL='update drs_testtask_online set rec1 = ''%s'', rec2 = ''%s'', rec3 = ''%s'', rec4 = ''%s'''+
            ' where taskid = %d and cityid=%d';
  RESCTASKSQL= 'insert into drs_testtask_online'+
             ' (taskid, cityid, drsid, comid, status, testresult, asktime,'+
             ' sendtime, rectime, tasklevel, userid, modelid, isprocess)'+
             ' select %d,%d,%d,%d,0,null,sysdate,'+
             ' null,null,4,-1,null,0 from dual';
  RESCPARAMSQL= 'insert into drs_testparam_online'+
             ' (taskid, paramid, paramvalue)'+
             ' select %d,%d,''%s'' from dual';


implementation

uses UnitThreadCommon, UnitDRS_Math;

{ TRepBase }

constructor TRepBase.create;
begin
  FStartTag:= 'X';
  FEndTag:= 'X';

  FComCtrlHead.Verson:= '02';
  FComCtrlHead.PackageCounts:= '01';
  FComCtrlHead.PackageIndex:= '01';
end;

function TRepBase.DecodeMsgSQL(var Msg: string; var SQLList :TStringList): boolean;
var
  lasc,ldrsno, ldeviceid, ldevicetype: string;
begin
  result := false;
  if not CheckCrcCode('',GetSubStr(Msg,length(Msg)-4,length(Msg)-1)) then
    raise exception.Create('CRCУ��ʧ��');
  //�豸����
  FDeviceType:= GetSubStr(Msg,8,9);
  //ֱ��վ���
  FDRSNO:= GetSubStr(Msg,12,19);
  //�豸���
  FR_Deviceid:= GetSubStr(Msg,20,21);
  //Ӧ���ʶ
  FAskTag:= GetSubStr(Msg,22,23);
  //ȥ����ʼ��־��Ԫ���������ͷ��У�鵥Ԫ��������־��Ԫ
  Msg:= GetSubStr(Msg,26,length(Msg)-5);
  //SQL�б����
  SQLList.Clear;
  //���²�������
  lasc:= inttostr(HexToInt(FAskTag));
  ldrsno:= OffGetDrsNo(FDRSNO);
  ldeviceid:= inttostr(HexToInt(FR_Deviceid));
  ldevicetype:= inttostr(HexToInt(FDeviceType));
  SQLList.Add(Format(UPDATESQL,[lasc,ldrsno,ldeviceid,ldevicetype,FTaskid,FCityid]));
  if FAskTag='00' then
    result:= true;
end;

destructor TRepBase.Destroy;
begin
  inherited;
end;

function TRepBase.GetCommandRecord: boolean;
begin
  FComCtrlHead.MsgID:= InttoHex(FMsgID,2);
  FComCtrlHead.DeviceType:= InttoHex(strtoint(FDeviceType),2);
  FComCtrlHead.DRSNO:= OffGetDrsNo(self.FDRSNO);
  FComCtrlHead.Deviceid:= InttoHex(strtoint(FR_Deviceid),2);
  FComCtrlHead.AskTag:= InttoHex(strtoint(FAskTag),2);
  FComCtrlHead.DataLength:= InttoHex(strtoint(FDataLength),2);
  result:= true;
end;

function TRepBase.GetCommandUnit(EnCode: string): boolean;
begin
//  //���Ԫ============>>>
//  FComCtrlHead.Verson:= EnCode[1];
//  FComCtrlHead.PackageCounts:= EnCode[2];
//  FComCtrlHead.PackageIndex:= EnCode[3];
//  FComCtrlHead.DeviceType:= EnCode[4];
//  FComCtrlHead.MsgID:= EnCode[5];
//  {lByteValue:= RawToBytes(FComCtrlHead.Repeaterid,sizeof(Integer));
//  //����
//  EnCode[6]:= lByteValue[0];
//  EnCode[7]:= lByteValue[1];
//  EnCode[8]:= lByteValue[2];
//  EnCode[9]:= lByteValue[3];}
//  FComCtrlHead.Deviceid:= EnCode[10];
//  FComCtrlHead.AskTag:= EnCode[11];
//  FComCtrlHead.DataLength:= EnCode[12];
//  //<<=============���Ԫ
  result:= true;
end;

procedure TRepBase.PutCommandUnit(var EnCode: string);
begin
  //���Ԫ============>>>
  EnCode:= EnCode+ FComCtrlHead.Verson;
  EnCode:= EnCode+ FComCtrlHead.PackageCounts;
  EnCode:= EnCode+ FComCtrlHead.PackageIndex;
  EnCode:= EnCode+ FComCtrlHead.DeviceType;
  EnCode:= EnCode+ FComCtrlHead.MsgID;
  EnCode:= EnCode+ FComCtrlHead.DRSNO;
  EnCode:= EnCode+ FComCtrlHead.Deviceid;
  EnCode:= EnCode+ FComCtrlHead.AskTag;
  EnCode:= EnCode+ FComCtrlHead.DataLength;
  //<<=============���Ԫ
  //�ڴ�У����
  self.FReturnFlag:= GetSubStr(EnCode,1,11);
end;

procedure TRepBase.RequestDevice(var aSQLList: TStringList; aCityid, aTaskid,
  aMsgid, aDrsid: integer; aDrsNo, aR_Deviceid, aDevicetype, aAskFlag: string);
var
  lSqlstr: string;
begin
  lSqlstr:= Format(RESCTASKSQL,[aTaskid,aCityid,aDrsid,aMsgid]);
  aSQLList.Add(lSqlstr);
  lSqlstr:= Format(RESCPARAMSQL,[aTaskid,1,aDevicetype]);
  aSQLList.Add(lSqlstr);
  lSqlstr:= Format(RESCPARAMSQL,[aTaskid,2,aAskFlag]);
  aSQLList.Add(lSqlstr);
  lSqlstr:= Format(RESCPARAMSQL,[aTaskid,24,aDrsNo]);
  aSQLList.Add(lSqlstr);
  lSqlstr:= Format(RESCPARAMSQL,[aTaskid,25,aR_Deviceid]);
  aSQLList.Add(lSqlstr);
end;

procedure TRepBase.SetAskTag(const Value: string);
begin
  FAskTag := Value;
end;

procedure TRepBase.SetCityid(const Value: integer);
begin
  FCityid := Value;
end;

procedure TRepBase.SetCollectTime(const Value: TDatetime);
begin
  FCollectTime := Value;
end;

procedure TRepBase.SetCreateTime(const Value: TDateTime);
begin
  FCreateTime := Value;
end;

procedure TRepBase.SetDataLength(const Value: string);
begin
  FDataLength := Value;
end;

procedure TRepBase.SetDestCall(const Value: string);
begin
  FDestCall := Value;
end;

procedure TRepBase.SetDeviceType(const Value: string);
begin
  FDeviceType := Value;
end;

procedure TRepBase.SetDRSID(const Value: integer);
begin
  FDRSID := Value;
end;

procedure TRepBase.SetDRSNO(const Value: string);
begin
  FDRSNO := Value;
end;

procedure TRepBase.SetMsgID(const Value: integer);
begin
  FMsgID := Value;
end;

procedure TRepBase.SetReturnFlag(const Value: string);
begin
  FReturnFlag := Value;
end;

procedure TRepBase.SetR_Deviceid(const Value: string);
begin
  FR_Deviceid := Value;
end;

procedure TRepBase.SetSubmmitCode(const Value: string);
begin
  FSubmmitCode := Value;
end;

procedure TRepBase.SetTaskid(const Value: integer);
begin
  FTaskid := Value;
end;

{ TRepParamQuery }

constructor TRepParamQuery.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMQUERY_ASK;
    FMsgName:= '���ϵͳ������ѯ����';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMQUERY_ANSWER;
    FMsgName:= '���ϵͳ������ѯ���';
  end;
end;

function TRepParamQuery.DecodeMsgSQL(var Msg: string; var SQLList :TStringList): boolean;
var
  lSqlstr: string;
  lParamASCIIStr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
  lParamBINStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin

        //��ѯ�绰
        lParamASCIIStr:= GetSubStr(Msg,1,15);
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,4,0,lParamASCIIStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�澯�绰
        lParamASCIIStr:= GetSubStr(Msg,16,30);
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,5,0,lParamASCIIStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //ֱ��վԶ��ͨ�ŷ�ʽ
        lParamHEXStr:= GetSubStr(Msg,31,32);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,6,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //ֱ��վ�����澯ʹ�ܱ�־1
        lParamHEXStr:= GetSubStr(Msg,33,34);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //�ŵ�1����ʧ��
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,7,0,lParamBINStr[1],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�ŵ�2����ʧ��
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,8,0,lParamBINStr[2],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�Լ��澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,9,0,lParamBINStr[3],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�Ž��澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,10,0,lParamBINStr[4],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Դ����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,11,0,lParamBINStr[5],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���е���Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,12,0,lParamBINStr[6],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���е���Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,13,0,lParamBINStr[7],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���շ�ģ�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,14,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //ֱ��վ�����澯ʹ�ܱ�־2
        lParamHEXStr:= GetSubStr(Msg,35,36);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //��Դģ�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,15,0,lParamBINStr[1],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,16,0,lParamBINStr[2],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,17,0,lParamBINStr[3],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,18,0,lParamBINStr[4],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,19,0,lParamBINStr[5],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й���פ�����޸澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,20,0,lParamBINStr[6],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й���פ�����޸澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,21,0,lParamBINStr[7],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�շ��źŸ澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,22,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //ֱ��վ�����澯ʹ�ܱ�־3
        lParamHEXStr:= GetSubStr(Msg,37,38);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //���й���Ƿ����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,23,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepParamQuery.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);
      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepDRSParamQuery }

constructor TRepDRSParamQuery.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMDRSQUERY_ASK;
    FMsgName:= 'ֱ��վ������ѯ����';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMDRSQUERY_ANSWER;
    FMsgName:= 'ֱ��վ������ѯ���';
  end;
end;

function TRepDRSParamQuery.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
  lParamBINStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin
        //���ұ�ʶ
        lParamHEXStr:= GetSubStr(Msg,1,2);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,26,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�豸����
        lParamHEXStr:= GetSubStr(Msg,5,6);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,80,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�汾��
        lParamHEXStr:= GetSubStr(Msg,7,8);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,28,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����������ʸ澯������
        lParamHEXStr:= GetSubStr(Msg,11,12);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,29,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����������ʸ澯������
        lParamHEXStr:= GetSubStr(Msg,13,14);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,30,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��ſ���
        lParamHEXStr:= GetSubStr(Msg,15,16);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,56,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��ſ���
        lParamHEXStr:= GetSubStr(Msg,17,18);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,55,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����˥��ֵ
        lParamHEXStr:= GetSubStr(Msg,19,20);
  //      lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lParamINTStr:= BintoIntSign(BCDHexToBin(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,54,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����˥��ֵ
        lParamHEXStr:= GetSubStr(Msg,21,22);
  //      lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lParamINTStr:= BintoIntSign(BCDHexToBin(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,53,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�����ŵ���
        lParamHEXStr:= GetSubStr(Msg,23,24);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,52,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Ƶ�ŵ���
        lParamHEXStr:= GetSubStr(Msg,25,26);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,31,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����������ʵ�ƽ
        lParamHEXStr:= GetSubStr(Msg,27,28);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,32,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����������ʵ�ƽ
        lParamHEXStr:= GetSubStr(Msg,29,30);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,33,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�����������
        lParamHEXStr:= GetSubStr(Msg,31,32);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,34,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�����������
        lParamHEXStr:= GetSubStr(Msg,33,34);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,35,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�澯��
        lParamHEXStr:= GetSubStr(Msg,35,36);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //�ŵ�1�������ŵ�������ʧ��
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,36,0,lParamBINStr[1],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�ŵ�2������ŵ�������ʧ��
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,37,0,lParamBINStr[2],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�Լ��澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,38,0,lParamBINStr[3],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�Ž��澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,39,0,lParamBINStr[4],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Դ����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,40,0,lParamBINStr[5],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���е���Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,41,0,lParamBINStr[6],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���е���Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,42,0,lParamBINStr[7],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���շ�ģ�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,43,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�澯��
        lParamHEXStr:= GetSubStr(Msg,37,38);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //��Դģ�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,44,0,lParamBINStr[1],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,45,0,lParamBINStr[2],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,46,0,lParamBINStr[3],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,47,0,lParamBINStr[4],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,48,0,lParamBINStr[5],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й���פ�����޸澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,49,0,lParamBINStr[6],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й���פ�����޸澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,50,0,lParamBINStr[7],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�շ��źŸ澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,51,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�澯��
        lParamHEXStr:= GetSubStr(Msg,39,40);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //���й���Ƿ����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,57,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����
        lParamHEXStr:= GetSubStr(Msg,41,42);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
      end;

      //���¸ò��������״̬��������
      //�ж�ֱ��վ�Ƿ����
      //�ж��Ƿ��ֶ�����
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepDRSParamQuery.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);
      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepWDPParamQuery }

constructor TRepWDPParamQuery.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMWDPQUERY_ASK;
    FMsgName:= 'α��Ƶ�����������ѯ����';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMWDPQUERY_ANSWER;
    FMsgName:= 'α��Ƶ�����������ѯ���';
  end;
end;

function TRepWDPParamQuery.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin
        //����Ƶ��Ƶ��
        lParamHEXStr:= GetSubStr(Msg,1,2);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,58,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Ƶפ��ʱ��
        lParamHEXStr:= GetSubStr(Msg,3,4);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,59,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�豸����ģʽ
        lParamHEXStr:= GetSubStr(Msg,5,6);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,60,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�����ź�PN��
        lParamHEXStr:= GetSubStr(Msg,7,10);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,61,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����ź�PN��
        lParamHEXStr:= GetSubStr(Msg,11,14);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,62,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����ź���Ƭ�ӳ�      //�и�ֵ��error��
        lParamHEXStr:= GetSubStr(Msg,15,16);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,63,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��׼ʱ����Դ
        lParamHEXStr:= GetSubStr(Msg,17,18);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,64,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�����ŵ���
        lParamHEXStr:= GetSubStr(Msg,19,20);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,65,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Ƶ����ŵ���1
        lParamHEXStr:= GetSubStr(Msg,21,22);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,66,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Ƶ����ŵ���2
        lParamHEXStr:= GetSubStr(Msg,23,24);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,67,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Ƶ����ŵ���3
        lParamHEXStr:= GetSubStr(Msg,25,26);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,68,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Ƶ����ŵ���4
        lParamHEXStr:= GetSubStr(Msg,27,28);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,69,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Ƶ����ŵ���5
        lParamHEXStr:= GetSubStr(Msg,29,30);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,70,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Ƶ����ŵ���6
        lParamHEXStr:= GetSubStr(Msg,31,32);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,71,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�������빦�ʵ�ƽ
        lParamHEXStr:= GetSubStr(Msg,33,34);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,72,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //����������ʸ澯������
        lParamHEXStr:= GetSubStr(Msg,35,36);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,79,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepWDPParamQuery.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);
      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepDRSNOParamSet }

constructor TRepDRSNOParamSet.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMDRSNOSET_ASK;
    FMsgName:= '����ֱ��վϵͳ�������';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMDRSNOSET_ANSWER;
    FMsgName:= '����ֱ��վϵͳ��Ž��';
  end;
end;

function TRepDRSNOParamSet.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin
        //Ӧ���ʶ
        lParamHEXStr:= self.AskTag;
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,83,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepDRSNOParamSet.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);

          //������
          EnCode:= EnCode+ OffGetDrsNo(FComCtrlHead.DRSNO);
          EnCode:= EnCode+ InttoHex(strtoint(FComCtrlHead.Deviceid),2);

      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25+Strtoint(FComCtrlHead.DataLength)*2);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepRCOMParamSet }

constructor TRepRCOMParamSet.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMRCOMSET_ASK;
    FMsgName:= '����Զ��ͨ�Ų�������';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMRCOMSET_ANSWER;
    FMsgName:= '����Զ��ͨ�Ų������';
  end;
end;

function TRepRCOMParamSet.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin
        //Ӧ���ʶ
        lParamHEXStr:= self.AskTag;
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,83,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepRCOMParamSet.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);

          //������
          EnCode:= EnCode+ RightPad(FParamQueryCall,15,' ');
          EnCode:= EnCode+ RightPad(FParamAlarmCall,15,' ');
          EnCode:= EnCode+ inttohex(strtoint(FParamComtype),2);

      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25+Strtoint(FComCtrlHead.DataLength)*2);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

procedure TRepRCOMParamSet.SetParamAlarmCall(const Value: string);
begin
  FParamAlarmCall := Value;
end;

procedure TRepRCOMParamSet.SetParamComtype(const Value: string);
begin
  FParamComtype := Value;
end;

procedure TRepRCOMParamSet.SetParamQueryCall(const Value: string);
begin
  FParamQueryCall := Value;
end;

{ TRepAUTOALARMParamSet }

constructor TRepAUTOALARMParamSet.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMRAUTOALARMSET_ASK;
    FMsgName:= '����ֱ��վ�����澯ʹ�ܱ�־����';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMRAUTOALARMSET_ANSWER;
    FMsgName:= '������ֱ��վ�����澯ʹ�ܱ�־���';
  end;
end;

function TRepAUTOALARMParamSet.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin

        //Ӧ���ʶ
        lParamHEXStr:= self.AskTag;
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,83,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepAUTOALARMParamSet.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
  lBinStr: string;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);

          //������
          lBinStr:= '';
          lBinStr:= lBinStr+ Param_17;
          lBinStr:= lBinStr+ Param_16;
          lBinStr:= lBinStr+ Param_15;
          lBinStr:= lBinStr+ Param_14;
          lBinStr:= lBinStr+ Param_13;
          lBinStr:= lBinStr+ Param_12;
          lBinStr:= lBinStr+ Param_11;
          lBinStr:= lBinStr+ Param_10;
          EnCode:= EnCode+ BinToHex(lBinStr);

          lBinStr:= '';
          lBinStr:= lBinStr+ Param_27;
          lBinStr:= lBinStr+ Param_26;
          lBinStr:= lBinStr+ Param_25;
          lBinStr:= lBinStr+ Param_24;
          lBinStr:= lBinStr+ Param_23;
          lBinStr:= lBinStr+ Param_22;
          lBinStr:= lBinStr+ Param_21;
          lBinStr:= lBinStr+ Param_20;
          EnCode:= EnCode+ BinToHex(lBinStr);

          lBinStr:= '';
          lBinStr:= lBinStr+ Param_37;
          lBinStr:= lBinStr+ Param_36;
          lBinStr:= lBinStr+ Param_35;
          lBinStr:= lBinStr+ Param_34;
          lBinStr:= lBinStr+ Param_33;
          lBinStr:= lBinStr+ Param_32;
          lBinStr:= lBinStr+ Param_31;
          lBinStr:= lBinStr+ Param_30;
          EnCode:= EnCode+ BinToHex(lBinStr);

          EnCode:= EnCode+ '00';

      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25+Strtoint(FComCtrlHead.DataLength)*2);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepESHOLDParamSet }

constructor TRepESHOLDParamSet.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMRESHOLDSET_ASK;
    FMsgName:= '��������ֵ����';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMRESHOLDSET_ANSWER;
    FMsgName:= '��������ֵ���';
  end;
end;

function TRepESHOLDParamSet.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin
        //Ӧ���ʶ
        lParamHEXStr:= self.AskTag;
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,83,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepESHOLDParamSet.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);

          //������
          EnCode:= EnCode+ InttoHex(strtoint(Param1),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param2),2);

      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25+Strtoint(FComCtrlHead.DataLength)*2);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepSWITCHParamSet }

constructor TRepSWITCHParamSet.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMSWITCHSET_ASK;
    FMsgName:= '���ù��ſ���������';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMSWITCHSET_ANSWER;
    FMsgName:= '���ù��ſ��������';
  end;
end;

function TRepSWITCHParamSet.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin

        //Ӧ���ʶ
        lParamHEXStr:= self.AskTag;
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,83,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepSWITCHParamSet.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);

          //������
          EnCode:= EnCode+ InttoHex(strtoint(Param1),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param2),2);

      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25+Strtoint(FComCtrlHead.DataLength)*2);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepDAMPParamSet }

constructor TRepDAMPParamSet.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMDAMPSET_ASK;
    FMsgName:= '����˥��������';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMDAMPSET_ANSWER;
    FMsgName:= '����˥�������';
  end;
end;

function TRepDAMPParamSet.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin

        //Ӧ���ʶ
        lParamHEXStr:= self.AskTag;
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,83,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepDAMPParamSet.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);

          //������
          EnCode:= EnCode+ InttoHex(strtoint(Param1),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param2),2);

      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25+Strtoint(FComCtrlHead.DataLength)*2);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepCHANNELParamSet }

constructor TRepCHANNELParamSet.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMCHANNELSET_ASK;
    FMsgName:= '�����ŵ�������';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMCHANNELSET_ANSWER;
    FMsgName:= '�����ŵ��Ž��';
  end;
end;

function TRepCHANNELParamSet.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin

        //Ӧ���ʶ
        lParamHEXStr:= self.AskTag;
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,83,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepCHANNELParamSet.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);

          //������
          EnCode:= EnCode+ InttoHex(strtoint(Param1),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param2),2);

      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25+Strtoint(FComCtrlHead.DataLength)*2);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepWDPFSJParamSet }

constructor TRepWDPFSJParamSet.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMWDPFSJSET_ASK;
    FMsgName:= 'α��Ƶ�����������������';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMWDPFSJSET_ANSWER;
    FMsgName:= 'α��Ƶ������������ý��';
  end;
end;

function TRepWDPFSJParamSet.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin

        //Ӧ���ʶ
        lParamHEXStr:= self.AskTag;
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,83,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepWDPFSJParamSet.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);

          //������
          EnCode:= EnCode+ InttoHex(strtoint(Param1),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param2),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param3),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param4),4);
          EnCode:= EnCode+ InttoHex(strtoint(Param6),4);
          EnCode:= EnCode+ InttoHex(strtoint(Param8),2); //��error��
          EnCode:= EnCode+ InttoHex(strtoint(Param9),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param10),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param11),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param12),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param13),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param14),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param15),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param16),2);
          EnCode:= EnCode+ InttoHex(strtoint(Param17),2);

      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25+Strtoint(FComCtrlHead.DataLength)*2);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

{ TRepAUTOALARMParamQuery }

constructor TRepAUTOALARMParamQuery.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID:= WD_REP_PARAMAUTOALARMQUERY_ASK;
    FMsgName:= 'ֱ��վ�澯����';
  end
  else
  begin
    FMsgID:= WD_REP_PARAMAUTOALARMQUERY_ANSWER;
    FMsgName:= 'ֱ��վ�澯���';
  end;
end;

function TRepAUTOALARMParamQuery.DecodeMsgSQL(var Msg: string;
  var SQLList: TStringList): boolean;
var
  lSqlstr: string;
  lParamASCIIStr: string;
  lParamHEXStr: string;
  lParamINTStr: string;
  lParamBINStr: string;
begin
  result:= false;
  try
    try
      if inherited DecodeMsgSQL(Msg,SQLList) then
      begin
        //��ѯ�绰
        lParamASCIIStr:= GetSubStr(Msg,1,15);
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,4,0,lParamASCIIStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�澯�绰
        lParamASCIIStr:= GetSubStr(Msg,16,30);
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,5,0,lParamASCIIStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //ֱ��վԶ��ͨ�ŷ�ʽ
        lParamHEXStr:= GetSubStr(Msg,31,32);
        lParamINTStr:= inttostr(HexToInt(lParamHEXStr));
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,6,0,lParamINTStr,DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //ֱ��վ�����澯ʹ�ܱ�־1
        lParamHEXStr:= GetSubStr(Msg,33,34);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //�ŵ�1����ʧ��
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,7,0,lParamBINStr[1],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�ŵ�2����ʧ��
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,8,0,lParamBINStr[2],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�Լ��澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,9,0,lParamBINStr[3],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�Ž��澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,10,0,lParamBINStr[4],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //��Դ����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,11,0,lParamBINStr[5],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���е���Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,12,0,lParamBINStr[6],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���е���Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,13,0,lParamBINStr[7],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���շ�ģ�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,14,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //ֱ��վ�����澯ʹ�ܱ�־2
        lParamHEXStr:= GetSubStr(Msg,35,36);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //��Դģ�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,15,0,lParamBINStr[1],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,16,0,lParamBINStr[2],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź�����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,17,0,lParamBINStr[3],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,18,0,lParamBINStr[4],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й��Ź���
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,19,0,lParamBINStr[5],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й���פ�����޸澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,20,0,lParamBINStr[6],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //���й���פ�����޸澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,21,0,lParamBINStr[7],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //�շ��źŸ澯
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,22,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);
        //ֱ��վ�����澯ʹ�ܱ�־3
        lParamHEXStr:= GetSubStr(Msg,37,38);
        lParamBINStr:= BCDHexToBin(lParamHEXStr);
        //���й���Ƿ����
        lSqlstr:= Format(INSERTSQL,[FTaskid,FCityid,FDRSID,
                         FMsgID,23,0,lParamBINStr[8],DatetimeTostr(CollectTime),0,WD_TABLESTATUS_NORMAL]);
        SQLList.Add(lSqlstr);

        //Ӧ��
        self.RequestDevice(SQLList,FCityid,FTaskid,16,FDRSID,FDRSNO,FR_Deviceid,FDeviceType,'0');
      end;
    except
      exit;
    end;
    result:= true;
  finally

  end;
end;

function TRepAUTOALARMParamQuery.GetTestEnCode(var EnCode: string): Boolean;
var
  lCrcSource: string;
  lH, lL: integer;
begin
  result:= false;
  EnCode:= '';
  try
    try
      //��ʼ��־��Ԫ
      EnCode:= EnCode+ FStartTag;
      //���Ԫ
      GetCommandRecord;
      PutCommandUnit(EnCode);
      //У�鵥Ԫ
      lCrcSource:= GetSubStr(EnCode,2,25);
      EnCode:= EnCode+ GetCrcCode(lCrcSource, lL, lH);
      //������־��Ԫ
      EnCode:= EnCode+ FEndTag;

      FSubmmitCode:= EnCode;
      FReturnFlag:= copy(FSubmmitCode,1,21);
    except
      exit;
    end;
    result:= true;
  finally
  end;
end;

end.
