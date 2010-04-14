{
  金硕MTU类  (cyx)
  MTU类负责解析数据包和构造数据包
}
unit Ut_MtuInfo;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,IdGlobal,Math, Variants;

const
  MTU_TEST_CALL =1;
  MTU_TEST_MOS =2;
  MTU_TEST_CALLEE_DELAY=3;
  MTU_TEST_WLAN_SPEED =4;
  MTU_TEST_WLAN_DELAY =5;
  MTU_GET_STATUS =6;
  MTU_TEST_VOICE =7;
  MTU_SET_PARAMETER=8;
  MTU_STOP_TASK=9;
  MTU_GET_CALLEE=10;
  MTU_REPORT_SELF = 65;
  MTU_REPORT_CCH =66;
  MTU_REPORT_WLAN=67;
  MTU_REPORT_STATUS =68;
  MTU_REPORT_WLAN_ERROR=69;
  MTU_REPORT_WLAN_OK =70;  // 等金硕修改
  MTU_TEST_CALL_RESULT =129;
  MTU_TEST_TCH_RESULT =130;
  MTU_TEST_HANDOVER_RESULT =131;
  MTU_TEST_MOS_RESULT =132;
  MTU_TEST_CALLEE_DELAY_RESULT = 133;
  MTU_TEST_WLAN_SPEED_RESULT=134;
  MTU_TEST_WLAN_DELAY_RESULT=135;
  MTU_GET_STATUS_RESULT=136;
  MTU_TEST_VOICE_RESULT =137;
  MTU_GET_CALLEE_RESULT=138;
  MTU_COMMAND_ACK =160;
  //20090612
  MTU_PPP_TEST = 11;               //PPP拨号上网测试命令
  MTU_PPP_TEST_RESULT = 139;
  MTU_REPORT_SIGNALSTREAM_OFF = 73;//CDMA信息检测通知
  MTU_REPORT_SIGNALSTREAM_ON = 89;
  MTU_REPORT_NEIGHBOR_OFF = 78;    //邻区信息检测通知
  MTU_REPORT_NEIGHBOR_ON = 94;
  MTU_REPORT_SWITCH_OFF = 74;      //CDMA 切换相关参数检测
  MTU_REPORT_SWITCH_ON = 90;
  MTU_REPORT_FINGER_OFF = 75;      //FINGER信息检测
  MTU_REPORT_FINGER_ON = 91;
  MTU_REPORT_ACTIVE_OFF = 76;      //激活集信息检测
  MTU_REPORT_ACTIVE_ON = 92;
  MTU_REPORT_SECOND_OFF = 77;      //候选集信息检测
  MTU_REPORT_SECOND_ON = 93;
  //20090724
  MTU_TEST_CALL_CENTER= 12;        //心平台呼叫MTU测试命令
  MTU_TEST_CALL_CENTER_RESULT= 140;//心平台呼叫MTU测试结果
  MTU_LOCALANALYSE = 255;

  //模拟MOS
  MTU_MOS_VIRTUAL = 199;
  WDPARAM_MOS_PARASEVALUE = 99;

  MTU_NOWLAN_REPORT =71;
  MTU_NOCCH_REPORT =72;
  //Paramter
  MTUPARAM_DEVICEID =1;
  MTUPARAM_STARTTIME =2;
  MTUPARAM_POWER_STATUS =3;
  MTUPARAM_CCH=4;
  MTUPARAM_TASKID =5;
  MTUPARAM_CALLER = 6;
  MTUPARAM_CALLEE = 7;
  MTUPARAM_TALK_DURATION = 8;
  MTUPARAM_TIMES = 9;
  MTUPARAM_INTERVAL = 10;
  MTUPARAM_EXECID =11;
  MTUPARAM_ENDTIME =12;
  MTUPARAM_ALERTING_DELAY =13;
  MTUPARAM_CONNECT_DELAY =14;
  MTUPARAM_CSID= 15;
  MTUPARAM_TRY_RESULT =16;
  MTUPARAM_CALL_RESULT=17;
  MTUPARAM_TCH=18;
  MTUPARAM_HANDOVER_TIMES =19;
  MTUPARAM_TCH_HANDOVER_TIMES =20;
  MTUPARAM_PLAY_VOCFILE =21;
  MTUPARAM_RECORD_VOCFILE =22;
  MTUPARAM_RESULT =23;
  MTUPARAM_WLAN =24;
  MTUPARAM_SPEED_UPLINK=25;
  MTUPARAM_SPEED_DOWNLINK=26;
  MTUPARAM_FREQUENCY =27;
  MTUPARAM_TEST_DURATION =28;
  MTUPARAM_SEND_PACKETS=29;
  MTUPARAM_RECEIVED_PACKETS=30;
  MTUPARAM_DELAY_MAX =31;
  MTUPARAM_DELAY_MIN =32;
  MTUPARAM_DELAY_AVG=33;
  MTUPARAM_ERROR_PERCENT =34;
  MTUPARAM_MTU_STATUS =35;
  MTUPARAM_SEARCH_FLAG =36;
  MTUPARAM_NUMBER =37;
  MTUPARAM_MTU_STATUS_LIST=38;
  MTUPARAM_CALLER_DEVICEID = 39;
  MTUPARAM_CALLEE_DEVICEID =40;
  MTUPARAM_PING_DEST =41;
  MTUPARAM_WLAN_ERROR_REASON =42;
  MTUPARAM_COMMAND =43;
  MTUPARAM_VOICE_RESULT=44;
  MTUPARAM_MTU_DURATION=45;
  MTUPARAM_CCH_DURATION=46;
  MTUPARAM_WLAN_DURATION=47;
  MTUPARAM_MTU_CALLEE_LIST=48;

  //自定义
  WDPARAM_NCS = 1001;     //场强基站数
  WDPARAM_WML = 1002;     //场强误码率
  WDPARAM_APSID = 1003;   //APID
  WDPARAM_XD =1004;       // 信道
  WDPARAM_MAXCH =1005;    //CCH最大场强
  WDPARAM_MAXTCH =1006;   // TCH 最大场强
  WDPARAM_TCHQHSC =1007;  // TCH切换次数/通话时长  改  通话时长/TCH切换次数
  WDPARAM_HQHSC =1008;    //站间切换时长
  WDPARAM_MAXWLANCQ = 1009; // WLAN 最大场强
  WDPARAM_LOSEPERCENT =1010;//WLAN 丢包率
  WDPARAM_MOS = 1011;       //MOS值
  WDPARAM_APCQ = 1012;      //AP场强
  {JS公司20081222决定废弃该WDPARAM_NOCCH_CDMA指标 改成 WDPARAM_Rx和WDPARAM_Ec}
  //WDPARAM_NOCCH_CDMA = 1013;//连续无CDMA场强
  WDPARAM_NO_Rx = 1016;       //连续无Rx强度
  WDPARAM_NO_Ec = 1017;       //连续无Ec/Io强度
  //WDPARAM_MAXTCH_CDMA = 1014;//连续x次CDMA最大平均场强下降?dB
  WDPARAM_Tx = 1018;          //Tx强度
  {JS公司20081224决定废弃该WDPARAM_MAXCDMA指标 改成 WDPARAM_Rx和WDPARAM_Ec}
  //WDPARAM_MAXCDMA = 1015;   //CDMA最大场强
  WDPARAM_Rx = 1019;          //Rx强度
  WDPARAM_Ec = 1020;          //Ec/Io强度

  //20090612
  MTUPARAM_BAND_CLASS = 50;
  MTUPARAM_CHAN = 51;
  MTUPARAM_SID = 52;
  MTUPARAM_NID = 53;
  MTUPARAM_PN  = 54;
  MTUPARAM_SCI = 55;
  MTUPARAM_TX_ADJ = 56;
  MTUPARAM_FER = 57;
  MTUPARAM_PN_ECIO = 58;
  MTUPARAM_PN_NEIGHBOR = 1021;//邻区pn
  MTUPARAM_TX = 59;
  MTUPARAM_T_ADD = 60;
  MTUPARAM_T_DROP = 61;
  MTUPARAM_T_COMP = 62;
  MTUPARAM_T_TDROP = 63;
  MTUPARAM_PN_OUT = 1022; //不在主服务区
  MTUPARAM_PN_OUT_ACTIVE = 1025; //激活集信息检测通知  不在主服务区
  MTUPARAM_RX_VERSION = 1023;//RX协议号

  cScaleChar   =   '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

//数据结构
//CNGP   TLV   Record
type
  TParamTLV = Record
    ParamTag :Byte;
    ParamLen :Byte;
    ParamValue :TIdBytes;
  end;
  //包头
  TPackHead = record
    HeadA :Byte;
    HeadB :Byte;
    Protocol :Byte;
    Verson :Byte;
  end;

  PParamValue = ^TParamValue;
  TParamValue = record
    ParamId :Integer;
    ValueIndex :integer;
    ParamValue :String;
  end;
type
  TMtuBase = class (TObject)
  private
    FHead: Integer;        //协议头
    FProtocol: Integer;    //协议号
    FVersion: Integer;     //协议版本号
    CurTime :TDateTime;
    PackHead :TPackHead;   //协议包头
  protected
    FCityid : integer;
    FMsgData: TIdBytes;     //消息数据
    FDataLength: Integer;   //数据长度
    FMsgName: string;       //消息名称
    FMsgID: integer;        //消息编号
    FMtuNo: string;         //MTU设备编号
    FDecodeResult :String;  //解析结果
    FTaskId :integer;       //测试任务编号
    FExecID :integer;       //执行编号
    FTestTimes  :integer;   //测试次数
    FTestInterval :integer; //2次测试间隔
    FMtuList :TStringlist;  //MTU列表      by cdj
  public
    constructor create;
    Destructor Destroy ; override;
    //数据解码返回入库SQL
    function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;virtual;
    function GetVersionInfo:String;
    function GetParamValue(var ValueList:TStringList):Boolean;
    //获取测试编码数据
    function GetTestEnCode(var EnCode :TIdBytes):Boolean;virtual;abstract;
    class function GetTestData(MsgID:integer):TIdBytes;
    property MtuNo: string read FMtuNo write FMtuNo;
    property MsgName: string read FMsgName write FMsgName;
    //解析结果
    property Cityid: integer read FCityid write FCityid;
    property DecodeResult: string read FDecodeResult write FDecodeResult;
    property TaskId: integer read FTaskId write FTaskId;
    property TestTimes: integer read FTestTimes write FTestTimes;
    property TestInterval: integer read FTestInterval write FTestInterval;
    property MtuList: Tstringlist read FMtuList write  FMtuList;


  end;
  
  //MTU设备自身检测通知
  TMtuSelf  = class(TMtuBase)
    protected
      FCheckTime :TDateTime;  //检测时间
      FPowerStatus :Integer;  //电源状态 0 外接电源供电 1 电池供电 2 低压告警
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

  //CCH场强检测通知
  TMtuCch = class(TMtuBase)
    protected
      StartTime :TDateTime;  //检测时间
      nCs       :integer;    //CS个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

  //呼叫测试
  TMtuCall = class(TMtuBase)
    protected
      FCaller :String; //主叫号码
      FCallee :String; //被叫号码
      FStartTime :TDateTime;    //测试开始时间
      FEndTime :TDateTime;      //测试结束时间
      FTalkDuration :integer;   //通话时长
      FAlertingDelay :integer;  //接入时延
      FConnectDelay : integer;  //通话时延
      FCsid :String;            //本次通话所在基站编号
      TryResult :integer;       //呼叫尝试
      CallResult :integer;      //呼叫结果
    public
      constructor create(IsTest :boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      //
      property TalkDuration: integer read FTalkDuration write FTalkDuration;
      property Caller: String read FCaller write FCaller;
      property Callee: String read FCallee write FCallee;

  end;

  //TCH信道检测结果
  TMtuTch = class(TMtuBase)
    protected
      StartTime :TDateTime;  //检测时间
      nCs       :integer;    //CS个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

  //呼叫切换检测结果
  TMtuHandOver = class(TMtuBase)
    protected
      StartTime :TDateTime;         //检测时间
      HANDOVERTIMES   :integer;    //站间切换次数
      TCHHANDOVERTIMES :integer;   //TCH切换次数
      TALKDURATION :integer;      //通话时长
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

  //MOS 测试
  TMtuMos = class(TMtuBase)
    protected
      FCaller :String; //主叫号码
      FCallee :String; //被叫号码
      FPlayVoice :String; // 播放的语音文件名
      FStartTime :TDateTime;    //测试开始时间
      FEndTime :TDateTime;      //测试结束时间
      RecordVoice:String; //录音文件
      TestResult :integer;
      TALKDURATION : integer;
    public
      //constructor create;
      constructor create(IsTest :boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property PlayVoice: String read FPlayVoice write FPlayVoice;
      property Caller: String read FCaller write FCaller;
      property Callee: String read FCallee write FCallee;
  end;
  //语音单通测试命令
  TMtuVoice = class(TMtuBase)
    protected
      FMtuEr :String;  //主叫MTU
      FMtuEE :String;  //被叫MTU
      FCaller :String; //主叫号码
      FCallee :String; //被叫号码
      FTalkDuration :integer;   //通话时长
      CALLTYPE      :integer;   //0-MTU为主叫，1-MTU为被叫
      StartTime :TDateTime;    //测试开始时间
      EndTime :TDateTime;      //测试结束时间
      AlertingDelay :integer;  //接入时延
      ConnectDelay : integer;  //通话时延
      CallResult : integer;
      VoiceResult :integer;
    public
      constructor create(IsTest:Boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property Caller: String read FCaller write FCaller;
      property Callee: String read FCallee write FCallee;
      property MtuEr: String read FMtuEr write FMtuEr;
      property MtuEE: String read FMtuEE write FMtuEE;
      property TalkDuration: integer read FTalkDuration write FTalkDuration;
  end;

  //被叫时延测试命令
  TMtuCallEEDelay = class(TMtuBase)
    protected
      FCaller :String; //主叫号码
      FCallee :String; //被叫号码
      StartTime :TDateTime;    //测试开始时间
      EndTime :TDateTime;      //测试结束时间
      AlertingDelay :integer;  //接入时延
    public
      constructor create(IsTest:Boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property Caller: String read FCaller write FCaller;
      property Callee: String read FCallee write FCallee;
  end;

  //WLAN场强检测通知
  TMtuWLan = class(TMtuBase)
    protected
      StartTime :TDateTime;    //测试开始时间
      nAp       :integer; //AP 个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

  //WLAN速率测试
  TMtuWLanSpeed = class(TMtuBase)
    protected
      StartTime :TDateTime;    //测试开始时间
      EndTime :TDateTime;      //测试结束时间
      FTestDuration :integer;   //通话时长
      UpLink   :integer;       //上传速率
      DownLink :integer;       //下传速率
      TestResult : integer;    // 测试结果
    public
      constructor create(IsTest:Boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property TestDuration: integer read FTestDuration write FTestDuration;
  end;
  //WLAN时延、丢包、误码率测试
  TMtuWLanDelay = class(TMtuBase)
    protected
      FPingDest  :String;       // 目标IP
      FREQUENCY :integer;      //每秒发送的数据包
      FTestDuration :integer;   //测试时长
      SENDPACKETS  :integer;
      RECEIVEDPACKETS :integer; // 收到的数据包
      StartTime :TDateTime;     //测试开始时间
      DelayMax  :integer;       //最大时延
      DelayMin  :integer;       //最小时延
      DelayAvg  :Integer;       //平均时延
      ErrorPercent : double;  //误码率
    public
      constructor create(IsTest:Boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property REQUENCY: integer read FREQUENCY write FREQUENCY;
      property PingDest: string read FPingDest write FPingDest;
      property TestDuration: integer read FTestDuration write FTestDuration;

  end;
  //MTU上线、下线通知
  TMtuStatus = class(TMtuBase)
    protected
      MtuStatus  :integer; //MUT状态
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //MTU状态查询
  TMtuGetStatus = class(TMtuBase)
    protected
      FSearchFlag : integer; //查询标志  0  - all  1 - 指定
      nNumber    : integer; //MTU
    public
      constructor create(IsTest:Boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property SearchFlag: integer read FSearchFlag write FSearchFlag;
  end;
  //WLAN掉线通知
  TMtuWLanError = class(TMtuBase)
    protected
      STARTTIME  :TDateTime;   //告警时间
      ErrorReason  :integer;   //掉线原因
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

  //WLAN上线通知
  TMtuWLanOK = class(TMtuBase)
    protected
      STARTTIME  :TDateTime;   //告警时间
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

  //MTU参数配置命令
  TMtuSetParam = class(TMtuBase)
    protected
      FMTUDURATION  :integer;   //MTU自检周期
      FCCHDURATION  :integer;   //CCH场强检测周期
      FWLanDURATION  :integer;   //WLAN场强检测周期
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property MTUDURATION: integer read FMTUDURATION write FMTUDURATION;
      property CCHDURATION: integer read FCCHDURATION write FCCHDURATION;
      property WLanDURATION: integer read FWLanDURATION write FWLanDURATION;
  end;

  //MTU号码查询
  TMtuGetCallEE = class(TMtuBase)
    protected
      FSearchFlag : integer; //查询标志  0  - all  1 - 指定
      nNumber    : integer; //MTU
    public
      constructor create(IsTest:Boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property SearchFlag: integer read FSearchFlag write FSearchFlag;
  end;
  
  TMtuCmdAck = class(TMtuBase)
    protected
      command  :integer;   //MTU自检周期
      ackresult :integer;  //结果
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

  TMtuStopTask = class(TMtuBase)
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //续无WLAN场强上报
  TMtuNoLan = class(TMtuBase)
    protected
      Command  : integer;
      StatusResult : integer;
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //连续无CCH场强上报
  TMtuNoCCH = class(TMtuBase)
    protected
      Command  : integer;
      StatusResult : integer;
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //模拟MOS值
  TMtuMOSDone = class(TMtuBase)
  private
    FParaseMosValue: string;
  public
    constructor create(IsTest:Boolean=false);
    function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
    function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
    property ParaseMosValue: string read FParaseMosValue write FParaseMosValue;
  end;
  //PPP拨号测试
  TMtuPPPTest = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      TestResult :integer;      //测试结果
    public
      constructor create(IsTest:Boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //CDMA信息检测通知(待机)
  TMtuCDMAREPORT_OFF  = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FBCBand : integer;
      FCHAN : integer;
      FSID : integer;
      FNID : integer;
      FPN : integer;
      FCSI : integer;
      FTX_ADJ : integer;
      FFER : integer;
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //CDMA信息检测通知(通话)
  TMtuCDMAREPORT_ON  = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FBCBand : integer;
      FCHAN : integer;
      FSID : integer;
      FNID : integer;
      FPN : integer;
      FCSI : integer;
      FTX_ADJ : integer;
      FFER : integer;
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //邻区信息检测(待机)
  TMtuNEIGHBORREPORT_OFF = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FPNCounts  :integer;      //邻区个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //邻区信息检测(通话)
  TMtuNEIGHBORREPORT_ON = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FPNCounts  :integer;      //邻区个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //切换相关参数检测通知(待机)
  TMtuSWITCHREPORT_OFF = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FTX: integer;
      FT_ADD : integer;
      FT_DROP : integer;
      FT_COMP : integer;
      FT_TDROP : integer;
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //切换相关参数检测通知(通话)
  TMtuSWITCHREPORT_ON = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FTX: integer;
      FT_ADD : integer;
      FT_DROP : integer;
      FT_COMP : integer;
      FT_TDROP : integer;
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //Finger信息检测通知(待机)
  TMtuFINGERREPORT_OFF = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FPNCounts  :integer;      //邻区个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //Finger信息检测通知(通话)
  TMtuFINGERREPORT_ON = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FPNCounts  :integer;      //邻区个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //激活集信息检测通知(待机)
  TMtuACTIVEREPORT_OFF = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FPNCounts  :integer;      //邻区个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //激活集信息检测通知(通话)
  TMtuACTIVEREPORT_ON = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FPNCounts  :integer;      //邻区个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //候选集信息检测通知(待机)
  TMtuSECONDREPORT_OFF = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FPNCounts  :integer;      //邻区个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //候选集信息检测通知(通话)
  TMtuSECONDREPORT_ON = class(TMtuBase)
    protected
      FStartTime :TDateTime;    //测试开始时间
      FPNCounts  :integer;      //邻区个数
    public
      constructor create;
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;
  //中心平台呼叫MTU测试
  TMtuCallCenter = class(TMtuBase)
    protected
      FCallee :String;          //被叫号码
      FStartTime :TDateTime;    //测试开始时间
      FEndTime :TDateTime;      //测试结束时间
      FTalkDuration :integer;   //通话时长
      FAlertingDelay :integer;  //接入时延
      FConnectDelay : integer;  //通话时延
      FCallResult :integer;     //呼叫结果
      FVoiceResult: integer;    //语音结果
    public
      constructor create(IsTest :boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      //数据解码返回入库SQL
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
      property Callee: String read FCallee write FCallee;
      property TalkDuration: integer read FTalkDuration write FTalkDuration;
  end;
  //导频污染性能分析
  TMtuLocalAnalyse = class(TMtuBase)
    public
      constructor create(IsTest :boolean=false);
      function GetTestEnCode(var EnCode :TIdBytes):Boolean;override;
      function DecodeMsgSQL(Msg:TIdBytes;var SQLList :TStringList ):boolean;override;
  end;

//接收到的数据全部入库
const //INSERTSQL =' insert into mtu_testresult_online (taskid,execid,cityid, mtuno, comid, paramid, valueindex, testresult,COLLECTTIME)'+
      //          ' values (%d,%d,%d, ''%s'', %d, %d, %d, ''%s'',sysdate)';
      //根据MTUNO
      INSERTSQL =' insert into mtu_testresult_online (taskid,execid,cityid, mtuid, comid, paramid, valueindex, testresult,COLLECTTIME, ISPROCESS)'+
                 ' select %d,%d,%d,(select mtuid from mtu_info where mtuno=''%s''),%d, %d, %d, ''%s'',sysdate,-2 from dual';
      //根据TASKID
      INSERTSQL2=' insert into mtu_testresult_online (taskid,execid,cityid, mtuid, comid, paramid, valueindex, testresult,COLLECTTIME, ISPROCESS)'+
                 ' select %d,%d,%d,nvl((select mtuid from mtu_testtask_online where taskid=%d),0),%d, %d, %d, ''%s'',sysdate,-2 from dual';
      UPDATESQL =' update mtu_testresult_online a set a.mtuno= (select b.mtuno from mtu_testtask_online a'+
                 ' left join mtu_info b on a.mtuid=b.mtuid where taskid=%d ) where a.taskid=%d';
      DELTASKSQL=' delete from mtu_testtask_online where taskid=%d';
      DELTASKPARAMSQL =' delete from mtu_testtaskparam_online where taskid=%d';
      RECVSQL =' update mtu_testtask_online set STATUS =4 where STATUS =3 and taskid=%d';  //STATUS =4 成功
      //MTU状态,MTU配置,MTU电话号码 根据以下来更新完成标志
      RECVSQL2=' update mtu_testtask_online set STATUS =4 where STATUS =2 and comid=%d and mtuid=(select a.mtuid from mtu_info a where upper(a.mtuno)=upper(''%s''))';
      //更新呼叫测试命令 等返回三个结果后再进行更新
  //16 进制Ascii码转为字符串
  function HexAsciiToStr(FBytes:TIdBytes):String;
  function BCDTimeToStr(FBytes:TIdBytes):String;
  procedure FreeParamValueList(var FList:TStringList);
implementation

uses Ut_Global;

//邻区返回值更改
function ChangeN(aStr: string):string;
begin
  if pos('N',uppercase(aStr))>0 then
    result:= '0'
  else
    result:= aStr;
end;
//10进制转 2进制 
function IntToBinStr(Value: LongInt; Size: Integer): String;
var
  i: Integer;
begin
  Result:='';
  for i:=Size-1 downto 0 do
  begin
    if Value and (1 shl i)<>0 then
      Result:=Result+'1'
    else
      Result:=Result+'0';
  end;
end;

//二进制字符转十进制
function BinToDecStr(Value :string) : string;//integer;
VAR
 str : String;
 Int : Integer;
 i : integer;
BEGIN
 Str := UpperCase(Value);
 Int := 0;
 FOR i := 1 TO Length(str) DO
  Int := Int * 2+ ORD(str[i]) - 48;
 Result := IntToStr(Int);
end;

function BintoInt(aStr: string): string;
var
  I: Integer;
  lValue: integer;
  lIndex: integer;
  lValueStr: string;
begin
  //符号位  负的取反 正为本身
  lValueStr:= aStr;
  if copy(lValueStr,1,1)='1' then
  begin
    //先二进制到十进制
    lValue:= 0;
    lIndex:= 0;
    for I := length(lValueStr) downto 2 do
    begin
      if lValueStr[i]='1' then
      begin
        lValue:= lValue + 1*strtoint(vartostr(power(2,lIndex)));
      end;
      inc(lIndex);
    end;
    //减1
    lValue := strtoint(inttostr(lValue-1));
    //十进制转二进制
    lValueStr:= '1'+copy(IntToBinStr(lValue,8),2,maxint);
    //取反  保留第一位不动
    for I := length(lValueStr) downto 2 do
    begin                                                      
      if lValueStr[i]='1' then
        lValueStr[i]:= '0'
      else
        lValueStr[i]:= '1'
    end;
  end;
  //二进制到十进制
  lValue:= 0;
  lIndex:= 0;
  for I := length(lValueStr) downto 2 do
  begin
    if lValueStr[i]='1' then
    begin
      lValue:= lValue + 1*strtoint(vartostr(power(2,lIndex)));
    end;
    inc(lIndex);
  end;
  //符号位
  if copy(lValueStr,1,1)='1' then
    result:= '-'+inttostr(lValue)
  else
    result:= inttostr(lValue);
end;

//JS的RX EC编码问题
function GetRxEcValue(aStr: string): string;
var
  lValue: integer;
begin
  try
    lValue:= strtoint(aStr);
    lValue:= lValue-256;
    result:= inttostr(lValue);
  except
    result:= '0'
  end;
end;
//截取字符前边是0的位
function CutPrioZero(aStr: string): String;
var
  lIndex: integer;
  I: Integer;
  lStr: string;
begin
  lIndex:= 1;//COPY开始位
  for I := 0 to length(aStr) - 1 do
  begin
    lStr:= copy(aStr,i+1,1);
    if (lStr='0') and (I<length(aStr) - 1) then
      lIndex:= i+2
    else
      break;
  end;
  result:= copy(aStr,lIndex,MaxInt);
end;

procedure FreeParamValueList(var FList:TStringList);
var
  i : integer;
begin
  for I := FList.Count - 1 downto 0  do
  begin
    Dispose(PParamValue(FList.Objects[i]));
    FList.Delete(i);
  end;
  FList.Free;
end;

function  BCDHexToBin(Hexadecimal:   string):   string;
const
    BCD:   array   [0..15]   of   string   =
('0000',   '0001',   '0010',   '0011',   '0100',   '0101',   '0110',   '0111',

'1000',   '1001',   '1010',   '1011',   '1100',   '1101',   '1110',   '1111');
var
    i:   integer;
begin
  Result:= '';
  for   i   :=   Length(Hexadecimal)   downto   1   do
    Result   :=   BCD[StrToInt('$'   +   Hexadecimal[i])]   +   Result;
end;

function HexAsciiToStr(FBytes:TIdBytes):String;
var
  i,l : integer;
  s :string;
begin

  for i :=0 to High(FBytes) do
  begin
    l := FBytes[i];
    //l :=StrToInt('$'+IntToStr(l));
    s := s+chr(l);
  end;
  result :=s;
end;
//字符串转为AscII吗
function StrToAscII(FValue:String):TIdBytes;
var
  i : integer;
begin
  result := nil;
  SetLength(result,Length(FValue));
  for i :=1 to Length(FValue) do
    result[i-1] := Ord(FValue[i]);
end;

function   DigitToInt(mDigit:   string;   mScale:   Byte):   Integer;
var
  I:   Byte;
  L:   Integer;
begin
  Result   :=   0;
  L   :=   Length(mDigit);
  for   I   :=   1   to   L   do
      Result   :=   Result   +   (Pos(mDigit[L   -   I   +   1],   cScaleChar)   -   1)   *
          Trunc(IntPower(mScale,   I   -   1));
end;   {   DigitToInt   }

//BCD码时间转字符串
function BCDTimeToStr(FBytes:TIdBytes):String;
var
  i,l :integer;
  S,TmpStr,TagStr :String;
begin
  //'02801012315422'
  result :='';
  for i :=0 to High(FBytes) do
  begin
    l := FBytes[i];
    s := s+Format('%-.2x',[l]);//Format('%s',[l]);// IntToStr(l);
  end;
  //转2进制
  s :=BCDHexToBin(s);

  if Length(s) <> 56 then
    Exit;
  for i := 1 to 7 do
  begin
    TmpStr :=Copy(s,(i-1)*8+1,8);
    TagStr :='';
    case i of
      2,3  :TagStr :='-'    ;
      4 :  TagStr :=' '    ;
      5,6 :  TagStr :=':'    ;
    end;
    result :=result+IntToStr(DigitToInt(Copy(TmpStr,1,4),2))+IntToStr(DigitToInt(Copy(TmpStr,5,4),2))+TagStr;
  end;
end;

function GetCSID(FBytes:TIdBytes):String;
var
  s,TmpStr :String;
  i,l :integer;
begin
  result :='';
  for i :=0 to High(FBytes) do
  begin
    l := FBytes[i];
    TmpStr :=IntToBinStr(l,8);
    s := s+TmpStr;
  end;
  for i := 1 to 6 do
  begin
    TmpStr :=Copy(s,(i-1)*8+1,8);
    result :=result+uppercase(format('%x',[strtoint(bintodecstr(Copy(TmpStr,1,4)))]))
      +uppercase(format('%x',[strtoint(bintodecstr(Copy(TmpStr,5,4)))]));
  end;
  //剔除掉最后一位
  result := Copy(result,1,Length(result)-2)+Copy(result,Length(result),1);
end;

//获取 电话号码
function GetCall(FBytes:TIdBytes):String;
begin
  result :=HexAsciiToStr(FBytes);
end;

//从字节数组中获取ID
function GetIdFromByte(FBytes:TIdBytes):String;
var
  lBytes :TIdBytes;
begin
  SetLength(lBytes,4);
  FillBytes(lBytes,4,0);
  Move(FBytes[0],lBytes[0],Length(FBytes));
  result :=IntToStr(BytesToInteger(lBytes));
  //result := IntToStr(ID);
end;

//WLAN  误码率 2字节的十六进制数，高位字节为整数，低位字节为小数
function GetWlanWML(FBytes:TIdBytes):String;
begin
  result :=IntToStr(FBytes[0]) +'.'+IntToStr(FBytes[1]);
end;

{
*********************************** TMtuBase ***********************************
}
//初始化协议头、版本号、协议名称等固有信息
constructor TMtuBase.create;
begin
  FHead :=$135D;
  FProtocol :=$01;
  FVersion :=$10;
  CurTime :=now;
  
  with PackHead do
  begin
    HeadA := $5d;
    HeadB := $13;
    Protocol :=FProtocol;
    Verson:= FVersion;
  end;

end;
//解析 协议头、协议名称、版本号、协议名称、协议数据段,子类再针对协议数据段做对应解析
function TMtuBase.DecodeMsgSQL(Msg: TIdBytes; var SQLList :TStringList): boolean;
begin
  result := false;
  SetLength(FMsgData,Length(Msg)-7);
  FMsgData :=Copy(Msg,7,Length(Msg)-7);
  //Move(Msg[7], FMsgData[0], SizeOf(Msg));
  SQLList.Clear;
end;

destructor TMtuBase.Destroy;
begin
  FMsgData :=nil;
  inherited;
end;

function TMtuBase.GetParamValue(var ValueList: TStringList): Boolean;
var
  i,nCs,tmp:integer;
  lParmaid :integer;
  lParmaLen :integer;
  lValue,TemValue :TIdBytes;
  P :PParamValue;
begin
  result := false;
  if FMsgData = nil then
    Exit;
  try
    while Length(FMsgData)>0 do
    begin
      lParmaid := FMsgData[0];//获取参数编号
      lParmaLen :=FMsgData[1];// Copy(FMsgData,1,1);//取数值长度
      lValue := Copy(FMsgData,2,lParmaLen);
      case lParmaid of
        MTUPARAM_STARTTIME,MTUPARAM_ENDTIME : //MTU编号   8位 AscII码
          begin
            New(P);
            P^.ParamId := lParmaid;
            P^.ValueIndex := 1;
            P^.ParamValue :=BCDTimeToStr(lValue);
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
          end;
        MTUPARAM_POWER_STATUS,MTUPARAM_TRY_RESULT,MTUPARAM_CALL_RESULT,MTUPARAM_VOICE_RESULT,
        MTUPARAM_HANDOVER_TIMES,MTUPARAM_TCH_HANDOVER_TIMES,MTUPARAM_RESULT,
        MTUPARAM_MTU_STATUS,MTUPARAM_NUMBER,MTUPARAM_WLAN_ERROR_REASON,
        MTUPARAM_COMMAND :
          begin
            New(P);
            P^.ParamId := lParmaid;
            P^.ValueIndex := 1;
            //16进制转10进制
            P^.ParamValue :=IntToStr(lValue[0]);
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
          end;
        MTUPARAM_CCH :
          begin
            //场强个数
            New(P);
            P^.ParamId := WDPARAM_NCS;
            P^.ValueIndex := 1;
            //16进制转10进制
            nCs := lValue[0] ;
            P^.ParamValue :=IntToStr(nCs);
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
            //剔除场强个数
            lValue := Copy(lValue,1,lParmaLen-1);
            //解析出场强
            for I := 0 to nCs-1 do
            begin
              TemValue := Copy(lValue,7*i,7);
              //CSID
              New(P);
              P^.ParamId :=MTUPARAM_CSID;
              P^.ValueIndex := i+1;
              P^.ParamValue :=GetCsid(Copy(TemValue,0,6));
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));

              //场强信息
              New(P);
              P^.ParamId :=lParmaid;
              P^.ValueIndex := i+1;
              P^.ParamValue := BintoInt(BCDHexToBin(IntToHex(TemValue[6],2)));  //IntToStr(TemValue[6]);
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
            end;
          end;
        MTUPARAM_TCH :
          begin
            //场强个数
            New(P);
            P^.ParamId := WDPARAM_NCS;
            P^.ValueIndex := 1;
            //16进制转10进制
            nCs := lValue[0] ;
            P^.ParamValue :=IntToStr(nCs);
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
            //剔除场强个数
            lValue := Copy(lValue,1,lParmaLen-1);
            //解析出场强
            for I := 0 to nCs-1 do
            begin
              TemValue := Copy(lValue,8*i,8);
              //CSID
              New(P);
              P^.ParamId :=MTUPARAM_CSID;
              P^.ValueIndex := i+1;
              P^.ParamValue :=GetCsid(Copy(TemValue,0,6));
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));

              //场强信息
              New(P);
              P^.ParamId :=lParmaid;
              P^.ValueIndex := i+1;
              P^.ParamValue :=IntToStr(TemValue[6]);
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));

              //无码率
              New(P);
              P^.ParamId :=WDPARAM_WML;
              P^.ValueIndex := i+1;
              P^.ParamValue :=IntToStr(TemValue[7]);
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
            end;
          end;
        MTUPARAM_WLAN :
          begin
            //AP个数
            New(P);
            P^.ParamId := WDPARAM_NCS;
            P^.ValueIndex := 1;
            //16进制转10进制
            nCs := lValue[0] ;
            P^.ParamValue :=IntToStr(nCs);
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
            //剔除场强个数
            lValue := Copy(lValue,1,lParmaLen-1);
            i :=0;
            while I< nCs do
            begin
              tmp :=lValue[0];// HexToInt(lValue[0]); // APSID  长度
              New(P);
              P^.ParamId :=WDPARAM_APSID;
              P^.ValueIndex :=1;
              P^.ParamValue := HexAsciiToStr(Copy(lValue,1,tmp));
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
              //CCH
              New(P);
              P^.ParamId :=WDPARAM_APCQ;
              P^.ValueIndex :=1;
              P^.ParamValue :=  BintoInt(BCDHexToBin(IntToHex(lValue[tmp+1],2)));//IntToStr(lValue[tmp+1]);//IntToStr(HexToInt(lValue[tmp+1]));
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
              //XD
              New(P);
              P^.ParamId :=WDPARAM_XD;
              P^.ValueIndex :=1;
              P^.ParamValue :=IntToStr(lValue[tmp+1+1]);//IntToStr(HexToInt(lValue[tmp+1+1]));
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
              //剔除解析过的信息
              lValue := Copy(lValue,tmp+1+1+1,Length(lValue)-(tmp+1+1+1));
              Inc(i);
            end;
          end;
        MTUPARAM_PN_ECIO:
          begin
            //邻区个数
            New(P);
            P^.ParamId := WDPARAM_NCS;
            P^.ValueIndex := 1;
            //16进制转10进制
            nCs := Strtoint(HexAsciiToStr(copy(lValue,0,1)));
            P^.ParamValue :=inttostr(nCs);
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
            //剔除邻区个数
            lValue := Copy(lValue,1,lParmaLen-1);
            //解析出ecio
            for I := 0 to nCs-1 do
            begin
              TemValue := Copy(lValue,9*i,9);
              //邻区pn
              New(P);
              P^.ParamId :=MTUPARAM_PN_NEIGHBOR;
              P^.ValueIndex := i+1;
              P^.ParamValue :=HexAsciiToStr(copy(TemValue,0,4));
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));

              //邻区ecio
              New(P);
              P^.ParamId :=lParmaid;
              P^.ValueIndex := i+1;
              P^.ParamValue :=CutPrioZero(HexAsciiToStr(copy(TemValue,4,5)));
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
            end;
          end;
        MTUPARAM_TASKID,MTUPARAM_EXECID,MTUPARAM_CONNECT_DELAY,MTUPARAM_TEST_DURATION,
        MTUPARAM_ALERTING_DELAY,MTUPARAM_TALK_DURATION,
        MTUPARAM_SPEED_UPLINK,MTUPARAM_SPEED_DOWNLINK,MTUPARAM_SEND_PACKETS,MTUPARAM_RECEIVED_PACKETS,
        MTUPARAM_DELAY_MAX,MTUPARAM_DELAY_MIN,MTUPARAM_DELAY_AVG:
          begin
            New(P);
            P^.ParamId := lParmaid;
            P^.ValueIndex := 1;
            //16进制转10进制
            P^.ParamValue :=GetIdFromByte(lValue);//未实现
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
          end;
        MTUPARAM_CALLER,MTUPARAM_CALLEE,MTUPARAM_DEVICEID,MTUPARAM_PING_DEST,
        //20090612
        MTUPARAM_BAND_CLASS,MTUPARAM_CHAN,MTUPARAM_SID,MTUPARAM_NID,MTUPARAM_PN,
        MTUPARAM_SCI,MTUPARAM_TX_ADJ,MTUPARAM_FER,
        MTUPARAM_TX,MTUPARAM_T_ADD,MTUPARAM_T_DROP,MTUPARAM_T_COMP,MTUPARAM_T_TDROP:
          begin
            New(P);
            P^.ParamId := lParmaid;
            P^.ValueIndex := 1;
            //16进制转10进制
            P^.ParamValue :=HexAsciiToStr(lValue);//未实现
            if lParmaid=MTUPARAM_DEVICEID then
              if not FMtuList.IndexOf(P^.ParamValue)>-1 then //如果MTU匹配不上 就删除
              begin
                lValue :=nil;
                TemValue :=nil;
                FLog.Write(P^.ParamValue+'不在MTU列表内('+self.MsgName+')',1);
                Exit;
              end;
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
          end;
        MTUPARAM_CSID :
          begin
            New(P);
            P^.ParamId := lParmaid;
            P^.ValueIndex := 1;
            //16进制转10进制
            P^.ParamValue :=GetCsid(lValue);//未实现
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
          end;
        MTUPARAM_PLAY_VOCFILE,MTUPARAM_RECORD_VOCFILE :
          begin
            New(P);
            P^.ParamId := lParmaid;
            P^.ValueIndex := 1;
            //16进制转10进制
            P^.ParamValue := HexAsciiToStr(lValue);
            //P^.ParamValue :=GetCsid(lValue);//未实现  ??
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
          end;
        MTUPARAM_ERROR_PERCENT :
          begin
            New(P);
            P^.ParamId := lParmaid;
            P^.ValueIndex := 1;
            //16进制转10进制
            P^.ParamValue :=GetWlanWML(lValue);//未实现  ??
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
          end;
        MTUPARAM_MTU_STATUS_LIST :
          begin
            //解析出场强
            nCs := (High(lValue)+1) div 9;
            for I := 0 to nCs-1 do
            begin
              TemValue := Copy(lValue,9*i,9);
              //MTU
              New(P);
              P^.ParamId :=MTUPARAM_DEVICEID;
              P^.ValueIndex := i+1;
              P^.ParamValue :=HexAsciiToStr(Copy(TemValue,0,8));
              if not FMtuList.IndexOf(P^.ParamValue)>-1 then //如果MTU匹配不上 就删除
              begin
                FLog.Write(P^.ParamValue+'不在MTU列表内(MTU状态查询结果)',1);
                Continue;
              end;
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
              //状态
              New(P);
              P^.ParamId :=lParmaid;
              P^.ValueIndex := i+1;
              P^.ParamValue :=IntToStr(TemValue[8]);
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
            end;
          end;
        MTUPARAM_MTU_CALLEE_LIST :
          begin
            i :=0;
            while Length(lValue)>= 9 do
            begin
              Move(lValue[8],tmp,1);
              //MTU
              New(P);
              P^.ParamId :=MTUPARAM_DEVICEID;
              P^.ValueIndex := i+1;
              P^.ParamValue :=HexAsciiToStr(Copy(lValue,0,8));
              if not FMtuList.IndexOf(P^.ParamValue)>-1 then //如果MTU匹配不上 就删除
              begin
                FLog.Write(P^.ParamValue+'不在MTU列表内(MTU电话号码查询结果)',1);
                TemValue := Copy(lValue,9,tmp);
                lValue := Copy(lValue,9+tmp,Length(lValue)-(9+tmp));
                Inc(i);
                Continue;
              end;
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
              //Call
              New(P);
              P^.ParamId :=lParmaid;
              P^.ValueIndex := i+1;
              TemValue := Copy(lValue,9,tmp);
              P^.ParamValue :=HexAsciiToStr(TemValue);
              ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
              lValue := Copy(lValue,9+tmp,Length(lValue)-(9+tmp));
              Inc(i);
            end;
          end;
        WDPARAM_MOS_PARASEVALUE:
          begin
            New(P);
            P^.ParamId := lParmaid;
            P^.ValueIndex := 1;
            //16进制转10进制
            P^.ParamValue := HexAsciiToStr(lValue);
            //P^.ParamValue :=GetCsid(lValue);//未实现  ??
            ValueList.AddObject(IntToStr(P^.ParamId),Tobject(P));
          end;
      end;
      // 剔除已经解析的 TLV格式 包
      FMsgData := Copy(FMsgData,lParmaLen+1+1,Length(FMsgData)-(lParmaLen+1+1));

    end;
    result := true;
  except
    FLog.Write('解析TLV格式参数值失败!',1);
  end;
  lValue :=nil;
  TemValue :=nil;
end;

class function TMtuBase.GetTestData(MsgID:integer): TIdBytes;
const
  MTUSELF ='5d 13 01 10 41 16 00 01 08 30 38 30 31 41 31 36 38 02 07 02 80 10 12 31 54 22 03 01 00';
  MTUCCH ='5d 13 01 10 42 2b 00 01 08 30 38 30 31 41 31 36 38 02 07 02 80 10 12 41 14 65 04 16 03 e9 20 11 e0 12 f4 33 e9 20 11 e0 22 f4 57 e9 20 11 e0 32 f4 49';
var
  i : integer;
  Msg :String;
begin
  case MsgID of
    1 : Msg := StringReplace(MTUSELF,' ','',[rfReplaceAll]);
    2 : Msg := StringReplace(MTUCCH,' ','',[rfReplaceAll]);
  end;
  if Msg<>'' then
  begin
    SetLength(Result,Length(Msg) div 2);
    for I := 0 to Length(Msg) div 2-1 do
      Result[i] :=StrToInt('$'+Copy(Msg,i*2+1,2));
  end;
end;

function TMtuBase.GetVersionInfo: String;
begin
  result := '版本号:'+format('%x', [FVersion])+' 协议名称:'+format('%x', [FProtocol]);
end;

{ TMtuSelf }

constructor TMtuSelf.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_SELF;
  FMsgName :='MTU自身检测';
end;
//协议头共7位,从第8位开始为数据内容
function TMtuSelf.DecodeMsgSQL(Msg: TIdBytes; var SQLList :TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FCheckTime :=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_POWER_STATUS : FPowerStatus :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      //解析结果
//      DecodeResult := 'MTU编号<'+MtuNo+'> 自检结果: 检测时间-'+DateTimeToStr(FCheckTime);
//      case FPowerStatus of
//        0: DecodeResult := DecodeResult+ ' 电源状态-外接电源供电';
//        1: DecodeResult := DecodeResult+ ' 电源状态-电池供电';
//        2: DecodeResult := DecodeResult+ ' 电源状态-低压告警';
//      end;

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FCheckTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_POWER_STATUS,0,IntToStr(FPowerStatus)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuSelf.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuCch }

constructor TMtuCch.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_CCH;
  FMsgName :='CCH场强检测';
end;

function TMtuCch.DecodeMsgSQL(Msg: TIdBytes; var SQLList :TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  MaxCch :String;
  Cs :Array of String;
  Cch :Array of String;
  lMtuKeyWord : String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: StartTime :=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS : nCs :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CSID :
            begin
              SetLength(Cs,Length(Cs)+1);
              Cs[Length(cs)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_CCH :
            begin
              SetLength(Cch,Length(Cch)+1);
              Cch[Length(Cch)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;

//      DecodeResult :='MTU编号<'+MtuNo+'> CCH场强检测通知: 场强检测时间 -'+DateTimeToStr(StartTime)+'场强个数-'+IntToStr(nCs);
//      for I := 0 to High(Cs) do
//      begin
//        DecodeResult := DecodeResult+'基站['+Cs[i]+'] 场强 - '+cch[i];
//      end;

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(StartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(nCs)]);
      SQLList.Add(sqlstr);
      MaxCCH :='0';
      //判断MTU类型
      lMtuKeyWord := copy(MtuNo,5,1);
      //其他场强
      if (Uppercase(lMtuKeyWord)='A') or (Uppercase(lMtuKeyWord)='F') then
      begin
        for I := 0 to High(Cs) do
        begin
          sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_CSID,i,Cs[i]]);
          SQLList.Add(sqlstr);
        end;
        for I := 0 to High(Cch) do
        begin
          if CCH[i]>MaxCCH then
            MaxCCH := CCH[i];
          sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_CCH,i,Cch[i]]);
          SQLList.Add(sqlstr);
        end;
      end;
      //最大场强
      if (Uppercase(lMtuKeyWord)='A') or (Uppercase(lMtuKeyWord)='F') then
      begin
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_MAXCH,0,MaxCCH]);
        SQLList.Add(sqlstr);
      end
      else
      if (Uppercase(lMtuKeyWord)='B') or (Uppercase(lMtuKeyWord)='C') then
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_CSID,0,Cs[0]]);
        SQLList.Add(sqlstr);
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_RX_VERSION,1,Cs[1]]);
        SQLList.Add(sqlstr);
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_Rx,0,CCH[0]]);
        SQLList.Add(sqlstr);
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_Ec,1,CCH[1]]);
        SQLList.Add(sqlstr);
      end
      else
      begin
        DecodeResult := '最大场强：MTU['+MtuNo+']未找到匹配类型,他的第5个字母为['+lMtuKeyWord+']';
        FLog.Write(DecodeResult,1);
      end;

      SetLength(Cs,0);
      SetLength(Cch,0);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuCch.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuCall }


constructor TMtuCall.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_TEST_CALL;
    FMsgName :='呼叫测试命令';
  end
  else
  begin
    FMsgID :=MTU_TEST_CALL_RESULT;
    FMsgName :='呼叫测试结果';
  end;
end;

function TMtuCall.DecodeMsgSQL(Msg: TIdBytes; var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID : self.MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CALLER : self.Caller := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_CALLEE : self.Callee :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ENDTIME: FEndTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ALERTING_DELAY : FAlertingDelay:=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CONNECT_DELAY  : FConnectDelay:=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TALK_DURATION : self.FTalkDuration := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CSID : self.FCsid := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_TRY_RESULT : self.TryResult := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CALL_RESULT : self.CallResult :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult:= '任务编号<'+IntToStr(TaskId)+'> 呼叫测试: 执行序号 -'+IntToStr(FExecID);
//      DecodeResult:=DecodeResult+'主叫号码 -'+CallEr+' 被叫号码 -'+CallEE+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      DecodeResult:=DecodeResult+'测试结束时间 -'+DateTimeToStr(FEndTime)+' 接入时延 -'+IntToStr(self.FAlertingDelay);

      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLER,0,Caller]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLEE,0,CallEE]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ENDTIME,0,DateTimeToStr(FEndTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ALERTING_DELAY,0,IntToStr(FAlertingDelay)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CONNECT_DELAY,0,IntToStr(FConnectDelay)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TALK_DURATION,0,IntToStr(FTalkDuration)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CSID,0,FCsid]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TRY_RESULT,0,IntToStr(TryResult)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALL_RESULT,0,IntToStr(CallResult)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuCall.GetTestEnCode(var EnCode :TIdBytes):Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //MTU 号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;

    //主叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLER;
    Param.ParamLen := Length(self.FCaller);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCaller);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //被叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLEE;
    Param.ParamLen := Length(self.FCallee);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCallee);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //通话时长
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TALK_DURATION;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.FTalkDuration,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;

    //1	测试次数
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_TIMES;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := self.TestTimes;

    //2次测试间隔
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_INTERVAL;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestInterval,Param.ParamValue[0],2);

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);

  except
    result := false;
  end;
end;

{ TMtuTch }

constructor TMtuTch.create;
begin
  inherited create;
  FMsgID :=MTU_TEST_TCH_RESULT;
  FMsgName :='TCH信道检测结果';
end;

function TMtuTch.DecodeMsgSQL(Msg: TIdBytes; var SQLList: TStringList): boolean;
var
  SqlStr,MaxTCH:String;
  ValueList :TStringList;
  i :  integer;
  Cs :Array of String;
  Cch :Array of String;
  WML :Array of String;
  lMtuKeyWord : String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_STARTTIME: StartTime :=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS : nCs :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CSID :
            begin
              SetLength(Cs,Length(Cs)+1);
              Cs[Length(cs)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_TCH :
            begin
              SetLength(Cch,Length(Cch)+1);
              Cch[Length(Cch)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          WDPARAM_WML :
            begin
              SetLength(WML,Length(WML)+1);
              WML[Length(WML)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;

//      DecodeResult:='任务编号<'+IntToStr(TaskId)+'> TCH信道检测结果: 执行序号 -'+IntToStr(FExecID);
//      DecodeResult:=DecodeResult+' 测试开始时间 -'+DateTimeToStr(StartTime)+' 基站个数 -'+IntToStr(nCs);
      MaxTCH :='0';
      for I := 0 to High(Cs) do
      begin
        if cch[i]> MaxTCH then
          MaxTCH := cch[i];
//        DecodeResult:=DecodeResult+ '基站['+Cs[i]+']  场强 - '+cch[i]+' 误码率 -'+WML[i];
      end;

      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(StartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_NCS,0,IntToStr(nCs)]);
      SQLList.Add(sqlstr);
      for I := 0 to High(Cs) do
      begin
        sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CSID,i,Cs[i]]);
        SQLList.Add(sqlstr);
      end;
      for I := 0 to High(Cch) do
      begin
        sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TCH,i,cch[i]]);
        SQLList.Add(sqlstr);
      end;
      for I := 0 to High(WML) do
      begin
        sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_WML,i,WML[i]]);
        SQLList.Add(sqlstr);
      end;
      //最大TCH
      lMtuKeyWord := copy(MtuNo,5,1);
      if (Uppercase(lMtuKeyWord)='A') or (Uppercase(lMtuKeyWord)='F') then
      begin
//        DecodeResult := 'A类:MTU['+MtuNo+'] 最大TCH ['+MaxTCH+']';
        sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_MAXTCH,0,MaxTCH]);
      end
      else
      if (Uppercase(lMtuKeyWord)='B') or (Uppercase(lMtuKeyWord)='C') then
      begin
//        DecodeResult := 'B类:MTU['+MtuNo+'] 最大TCH ['+MaxTCH+']';
        sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_Tx,0,MaxTCH]);
      end
      else
        DecodeResult := '最大TCH：MTU['+MtuNo+']未找到匹配类型,他的第5个字母为['+lMtuKeyWord+']';
      FLog.Write(DecodeResult,1);
      SQLList.Add(sqlstr);

      SetLength(Cs,0);
      SetLength(Cch,0);
      SetLength(WML,0);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;
function TMtuTch.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuHandOver }

constructor TMtuHandOver.create;
begin
  inherited create;
  FMsgID :=MTU_TEST_HANDOVER_RESULT;
  FMsgName :='呼叫切换检测结果';
end;

function TMtuHandOver.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_STARTTIME: StartTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);

          MTUPARAM_HANDOVER_TIMES : self.HANDOVERTIMES:=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TCH_HANDOVER_TIMES  : self.TCHHANDOVERTIMES :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TALK_DURATION : self.TalkDuration := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult:= '任务编号<'+IntToStr(TaskId)+'> 呼叫切换检测结果: 执行序号 -'+IntToStr(FExecID);
//      DecodeResult:=DecodeResult+' 测试开始时间 -'+DateTimeToStr(StartTime);
//      DecodeResult:=DecodeResult+' 站间切换次数 -'+IntToStr(HANDOVERTIMES);
//      DecodeResult:=DecodeResult+' TCH 切换次数 -'+IntToStr(TCHHANDOVERTIMES);
//      DecodeResult:=DecodeResult+' 通话时长 -'+IntToStr(TALKDURATION);

      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(StartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ALERTING_DELAY,0,IntToStr(HANDOVERTIMES)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CONNECT_DELAY,0,IntToStr(TCHHANDOVERTIMES)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TALK_DURATION,0,IntToStr(TalkDuration)]);
      SQLList.Add(sqlstr);
      // TCH切换次数/通话时长
//      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_TCHQHSC,0,FloatToStr(TCHHANDOVERTIMES/TALKDURATION)]);
      // 通话时长/TCH切换次数
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_TCHQHSC,0,FloatToStr(TALKDURATION/TCHHANDOVERTIMES)]);
      SQLList.Add(sqlstr);
      //站间切换时长
//      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_HQHSC,0,FloatToStr(HANDOVERTIMES/TALKDURATION)]);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_HQHSC,0,FloatToStr(TALKDURATION/HANDOVERTIMES)]);
      SQLList.Add(sqlstr);
//      //更新测试完成标识
//      sqlstr := Format(RECVSQL,[TaskId]);
//      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuHandOver.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuMos }

constructor TMtuMos.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_TEST_MOS;
    FMsgName :='MOS值测试命令';
  end
  else
  begin
    FMsgID :=MTU_TEST_MOS_RESULT;
    FMsgName :='MOS值测试结果';
  end;
end;

function TMtuMos.DecodeMsgSQL(Msg: TIdBytes; var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CALLER : FCaller := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_CALLEE : FCallee :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ENDTIME: FEndTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TALK_DURATION : self.TalkDuration := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PLAY_VOCFILE : self.PlayVoice := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_RECORD_VOCFILE : self.RecordVoice :=  PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_RESULT : self.TestResult :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult:= '任务编号<'+IntToStr(TaskId)+'> MOS值测试结果: 执行序号 -'+IntToStr(FExecID);
//      DecodeResult:=DecodeResult+' 主叫号码 -'+CallEr;
//      DecodeResult:=DecodeResult+' 被叫号码 -'+CallEE;
//      DecodeResult:=DecodeResult+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      DecodeResult:=DecodeResult+' 测试结束时间 -'+DateTimeToStr(FEndTime);
//      DecodeResult:=DecodeResult+' 通话时长 -'+IntToStr(TALKDURATION);
//      DecodeResult:=DecodeResult+' 播放文件 -'+self.PlayVoice ;
//      DecodeResult:=DecodeResult+' 录音文件 -'+ self.RecordVoice ;
//      DecodeResult:=DecodeResult+' 测试结果 -'+IntToStr(self.TestResult);
      //MOS值待定
      
      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLER,0,FCaller]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLEE,0,FCallEE]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ENDTIME,0,DateTimeToStr(FEndTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TALK_DURATION,0,IntToStr(TalkDuration)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_PLAY_VOCFILE,0,PlayVoice]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_RECORD_VOCFILE,0,RecordVoice]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_RESULT,0,IntToStr(TestResult)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuMos.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //MTU编号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    
    //主叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLER;
    Param.ParamLen := Length(self.FCaller);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCaller);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //被叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLEE;
    Param.ParamLen := Length(self.FCallee);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCallee);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //播放的语音文件  是否提供

    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_PLAY_VOCFILE;
    Param.ParamLen := Length(self.FPlayVoice);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FPlayVoice);

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;

    //1	测试次数
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_TIMES;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := self.TestTimes;
    //2次测试间隔
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_INTERVAL;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestInterval,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
  
end;

{ TMtuVoice }

constructor TMtuVoice.create(IsTest: Boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_TEST_VOICE;
    FMsgName :='语音单通测试命令';
  end
  else
  begin
    FMsgID :=MTU_TEST_VOICE_RESULT;
    FMsgName :='语音单通测试结果';
  end;
end;
function TMtuVoice.DecodeMsgSQL(Msg: TIdBytes; var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_CALLER : FCaller := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_CALLEE : FCallee :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: StartTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ENDTIME: EndTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TALK_DURATION : self.TalkDuration := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ALERTING_DELAY : self.AlertingDelay := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CONNECT_DELAY : self.ConnectDelay :=  StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CALL_RESULT : self.CallResult :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_VOICE_RESULT : self.VoiceResult :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult:= '任务编号<'+IntToStr(TaskId)+'> 语音单通测试结果: MTU编号 -'+MtuNo;
//      DecodeResult:=DecodeResult+' 主叫号码 -'+CallEr;
//      DecodeResult:=DecodeResult+' 被叫号码 -'+CallEE;
//      DecodeResult:=DecodeResult+' 测试开始时间 -'+DateTimeToStr(StartTime);
//      DecodeResult:=DecodeResult+' 测试结束时间 -'+DateTimeToStr(EndTime);
//      DecodeResult:=DecodeResult+' 接入时延 -'+IntToStr(self.AlertingDelay);
//      DecodeResult:=DecodeResult+' 通话时延 -'+IntToStr(self.ConnectDelay);
//      DecodeResult:=DecodeResult+' 呼叫结果 -'+IntToStr(self.CallResult);
//      DecodeResult:=DecodeResult+' 通话时长 -'+IntToStr(TALKDURATION);
//      DecodeResult:=DecodeResult+' 呼叫结果 -'+IntToStr(self.CallResult);
//      DecodeResult:=DecodeResult+' 语音结果 -'+IntToStr(self.VoiceResult);

      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLER,0,FCaller]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLEE,0,FCallEE]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(StartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ENDTIME,0,DateTimeToStr(EndTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TALK_DURATION,0,IntToStr(TalkDuration)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ALERTING_DELAY,0,IntToStr(AlertingDelay)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CONNECT_DELAY,0,IntToStr(ConnectDelay)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALL_RESULT,0,IntToStr(CallResult)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_VOICE_RESULT,0,IntToStr(VoiceResult)]);
      SQLList.Add(sqlstr);
//      //更新测试完成标识
//      sqlstr := Format(RECVSQL,[TaskId]);
//      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuVoice.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //主叫MTU编号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLER_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(FMtuER);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //被叫MTU编号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLEE_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(FMtuEE);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    
    //主叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLER;
    Param.ParamLen := Length(self.FCaller);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCaller);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //被叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLEE;
    Param.ParamLen := Length(self.FCallee);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCallee);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //呼叫时长
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TALK_DURATION;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TalkDuration,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //1	测试次数
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_TIMES;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := self.TestTimes;
    //2次测试间隔
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_INTERVAL;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestInterval,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);


  except
    result := false;
  end;
end;

{ TMtuCallEEDelay }

constructor TMtuCallEEDelay.create(IsTest: Boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_TEST_CALLEE_DELAY;
    FMsgName :='被叫时延测试命令';
  end
  else
  begin
    FMsgID :=MTU_TEST_CALLEE_DELAY_RESULT;
    FMsgName :='被叫时延测试结果';
  end;
end;

function TMtuCallEEDelay.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_CALLER : FCaller := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_CALLEE : FCallee :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: StartTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ENDTIME: EndTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ALERTING_DELAY : self.AlertingDelay := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult:='任务编号<'+IntToStr(TaskId)+'> 被叫时延测试结果: 执行序号 -'+IntToStr(self.FExecID);
//      DecodeResult:=DecodeResult+' 主叫号码 -'+CallER;
//      DecodeResult:=DecodeResult+' 被叫号码 -'+CallEE;
//      DecodeResult:=DecodeResult+' 测试开始时间 -'+DateTimeToStr(StartTime);
//      DecodeResult:=DecodeResult+' 测试结束时间 -'+DateTimeToStr(EndTime);
//      DecodeResult:=DecodeResult+' 接入时延 -'+IntToStr(self.AlertingDelay);

      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLER,0,FCaller]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLEE,0,FCallEE]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(StartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ENDTIME,0,DateTimeToStr(EndTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ALERTING_DELAY,0,IntToStr(AlertingDelay)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuCallEEDelay.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //主叫MTU编号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    
    //主叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLER;
    Param.ParamLen := Length(self.FCaller);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCaller);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //被叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLEE;
    Param.ParamLen := Length(self.FCallee);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCallee);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //1	测试次数
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_TIMES;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := self.TestTimes;
    //2次测试间隔
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_INTERVAL;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestInterval,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuWLan }

constructor TMtuWLan.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_WLAN;
  FMsgName :='WLAN 场强通知';
end;

function TMtuWLan.DecodeMsgSQL(Msg: TIdBytes; var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  Cs :Array of String;
  Cch :Array of String;
  XD :Array of String;
  MaxCch :String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: StartTime :=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS : nAp :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_APSID :
            begin
              SetLength(Cs,Length(Cs)+1);
              Cs[Length(cs)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          WDPARAM_APCQ :
            begin
              SetLength(Cch,Length(Cch)+1);
              Cch[Length(Cch)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          WDPARAM_XD :
            begin
              SetLength(XD,Length(XD)+1);
              XD[Length(XD)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult := 'MTU编号<'+MtuNo+'> WLAN场强检测通知: 测试开始时间 -'+DateTimeToStr(StartTime);
//      DecodeResult :=DecodeResult+ 'AP个数 -'+IntToStr(self.nAp);
//
//      for I := 0 to nAP-1 do
//      begin
//        DecodeResult :=DecodeResult + 'AP['+Cs[i]+']  场强 - '+cch[i]+' 信道 -'+XD[i];
//      end;

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(StartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(nAp)]);
      SQLList.Add(sqlstr);
      for I := 0 to High(Cs) do
      begin
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_APSID,i,Cs[i]]);
        SQLList.Add(sqlstr);
      end;
      MaxCch :='-127';
      for I := 0 to High(Cch) do
      begin
        if strtoint(MaxCch)<strtoint(cch[i]) then
          MaxCch :=cch[i];
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_WLAN,i,Cch[i]]);
        SQLList.Add(sqlstr);
      end;
      for I := 0 to High(XD) do
      begin
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_XD,i,XD[i]]);
        SQLList.Add(sqlstr);
      end;
      //最大场强
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_MAXWLANCQ,0,MaxCch]);
      SQLList.Add(sqlstr);


      SetLength(Cs,0);
      SetLength(Cch,0);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuWLan.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuWLanSpeed }

constructor TMtuWLanSpeed.create(IsTest: Boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_TEST_WLAN_SPEED;
    FMsgName :='WLAN速率测试命令';
  end
  else
  begin
    FMsgID :=MTU_TEST_WLAN_SPEED_RESULT;
    FMsgName :='WLAN速率测试结果';
  end;
end;

function TMtuWLanSpeed.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_STARTTIME: StartTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ENDTIME: EndTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TEST_DURATION : self.TestDuration := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_SPEED_UPLINK : self.UpLink := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_SPEED_DOWNLINK : self.DownLink :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_RESULT : self.TestResult :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult := '任务编号<'+IntToStr(TaskId)+'> WLAN速率测试结果: ';
//      DecodeResult :=DecodeResult+ ' 执行序号 -'+IntToStr(self.FExecID);
//      DecodeResult :=DecodeResult+ ' 测试开始时间 -'+DateTimeToStr(StartTime);
//      DecodeResult :=DecodeResult+ ' 测试结束时间 -'+DateTimeToStr(EndTime);
//      DecodeResult :=DecodeResult+ ' 测试时长 -'+IntToStr(self.TestDuration);
//      DecodeResult :=DecodeResult+ ' 上传速率 -'+IntToStr(self.UpLink);
//      DecodeResult :=DecodeResult+ ' 下载速率 -'+IntToStr(self.DownLink);
//      DecodeResult :=DecodeResult+ ' 测试结果 -'+IntToStr(self.TestResult);


      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(StartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ENDTIME,0,DateTimeToStr(EndTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TEST_DURATION,0,IntToStr(TestDuration)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_SPEED_UPLINK,0,IntToStr(UpLink)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_SPEED_DOWNLINK,0,IntToStr(DownLink)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_RESULT,0,IntToStr(TestResult)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuWLanSpeed.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //MTU编号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //1	测试次数
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_TIMES;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := self.TestTimes;
    
    //呼叫时长
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TEST_DURATION;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestDuration,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;

    //2次测试间隔
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_INTERVAL;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestInterval,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuWLanDelay }

constructor TMtuWLanDelay.create(IsTest: Boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_TEST_WLAN_DELAY;
    FMsgName :='WLAN时延丢包误码测试命令';
  end
  else
  begin
    FMsgID :=MTU_TEST_WLAN_DELAY_RESULT;
    FMsgName :='WLAN时延丢包误码测试结果';
  end;
end;


function TMtuWLanDelay.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_STARTTIME: StartTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PING_DEST: self.FPingDest:= PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_TEST_DURATION : self.TestDuration := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_SEND_PACKETS : self.SENDPACKETS := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_RECEIVED_PACKETS : self.RECEIVEDPACKETS :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DELAY_MAX : self.DelayMax := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DELAY_MIN : self.DelayMin := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DELAY_AVG : self.DelayAvg :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ERROR_PERCENT : self.ErrorPercent :=StrToFloat(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult:= '任务编号<'+IntToStr(TaskId)+'> WLAN时延、丢包、误码率测试结果: ';
//      DecodeResult :=DecodeResult+' 执行序号 -'+IntToStr(self.FExecID);
//      DecodeResult :=DecodeResult+' 目标地址 -'+self.FPingDest;
//      DecodeResult :=DecodeResult+' 测试开始时间 -'+DateTimeToStr(StartTime);
//      DecodeResult :=DecodeResult+' 测试时长 -'+IntToStr(self.TestDuration);
//      DecodeResult :=DecodeResult+' 发送数据包数 -'+IntToStr(self.SENDPACKETS);
//      DecodeResult :=DecodeResult+' 接收数据包数 -'+IntToStr(self.RECEIVEDPACKETS);
//      DecodeResult :=DecodeResult+' 最大时延 -'+IntToStr(self.DelayMax);
//      DecodeResult :=DecodeResult+' 最小时延 -'+IntToStr(self.DelayMin);
//      DecodeResult :=DecodeResult+' 平均时延 -'+IntToStr(self.DelayAvg);
//      DecodeResult :=DecodeResult+' 误码率 -'+FloatToStr(self.ErrorPercent);

      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(StartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_PING_DEST,0,self.FPingDest]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TEST_DURATION,0,IntToStr(TestDuration)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_SEND_PACKETS,0,IntToStr(self.SENDPACKETS)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_RECEIVED_PACKETS,0,IntToStr(self.RECEIVEDPACKETS)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_DELAY_MAX,0,IntToStr(self.DelayMax)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_DELAY_MIN,0,IntToStr(self.DelayMin)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_DELAY_AVG,0,IntToStr(self.DelayAvg)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ERROR_PERCENT,0,FloatToStr(self.ErrorPercent)]);
      SQLList.Add(sqlstr);
      //WLAN 丢包率
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,WDPARAM_LOSEPERCENT,0,FloatToStr((self.SENDPACKETS-self.RECEIVEDPACKETS)/self.SENDPACKETS)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuWLanDelay.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //MTU编号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 目标地址
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_PING_DEST;
    Param.ParamLen := Length(FPingDest);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(FPingDest);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //测试频率
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_FREQUENCY;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.FREQUENCY,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;

    //呼叫时长
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TEST_DURATION;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestDuration,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //1	测试次数
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_TIMES;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := self.TestTimes;
    //2次测试间隔
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_INTERVAL;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestInterval,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;
{ TMtuStatus }

constructor TMtuStatus.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_STATUS;
  FMsgName :='MTU离线、上线通知';
end;

function TMtuStatus.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_MTU_STATUS: self.MtuStatus :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> MTU离线、上线通知:  状态 -'+IntToStr(self.MtuStatus);
      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_MTU_STATUS,0,IntToStr(self.MtuStatus)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuStatus.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuGetStatus }

constructor TMtuGetStatus.create(IsTest: Boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_GET_STATUS;
    FMsgName :='MTU状态查询命令';
  end
  else
  begin
    FMsgID :=MTU_GET_STATUS_RESULT;
    FMsgName :='MTU状态查询结果';
  end;
end;

function TMtuGetStatus.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  Cs :Array of String;
  Status :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_NUMBER : self.nNumber := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_MTU_STATUS_LIST :
            begin
              SetLength(Status,Length(Status)+1);
              Status[Length(Status)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_DEVICEID :
            begin
              SetLength(Cs,Length(Cs)+1);
              Cs[Length(Cs)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;

//      DecodeResult := '  MTU状态查询结果: ';
//      DecodeResult :=DecodeResult+ ' 结果数 -'+IntToStr(self.nNumber);
//      for I := 0 to nNumber-1 do
//        DecodeResult :=DecodeResult+' MTU['+Cs[i]+']的状态-'+Status[i];

       //状态列表
      for I := 0 to High(Cs) do
      begin
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,Cs[i],FMsgID,MTUPARAM_MTU_STATUS,0,Status[i]]);
        SQLList.Add(sqlstr);
        sqlstr := 'update mtu_testtaskparam_online set taskid='+inttostr(TaskId)+
                  ' where taskid=(select min(taskid) from mtu_testtask_online a where a.comid=6 and a.status=2'+
                  ' and exists (select 1 from mtu_info b where a.mtuid=b.mtuid and b.mtuno='''+Cs[i]+'''))';
        SQLList.Add(sqlstr);
        sqlstr := 'update mtu_testtask_online a set taskid='+inttostr(TaskId)+
                  ' where taskid=(select min(taskid) from mtu_testtask_online a where a.comid=6 and a.status=2'+
                  ' and exists (select 1 from mtu_info b where a.mtuid=b.mtuid and b.mtuno='''+Cs[i]+'''))';
        SQLList.Add(sqlstr);
      end;
      SetLength(Cs,0);
      SetLength(Status,0);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuGetStatus.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6
    //查询标志
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_SEARCH_FLAG;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := FSearchFlag;
    if FSearchFlag= 1then
    begin
      //MTU编号
      CurIndex := Length(EnCode)-1;
      Param.ParamTag :=MTUPARAM_DEVICEID;
      Param.ParamLen := 8;
      SetLength(Param.ParamValue,0);
      Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

      SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
      EnCode[CurIndex+1] := Param.ParamTag;
      EnCode[CurIndex+2] := Param.ParamLen;
      j :=0;
      for I := CurIndex+3 to Length(EnCode)-1 do
      begin
        EnCode[i] := Param.ParamValue[j];
        Inc(j);
      end;
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuWLanError }

constructor TMtuWLanError.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_WLAN_ERROR;
  FMsgName :='WLAN上线/掉线通知';
end;

function TMtuWLanError.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : self.MtuNo :=  PParamValue(ValueList.Objects[i]).ParamValue ;
          MTUPARAM_STARTTIME: self.STARTTIME :=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_WLAN_ERROR_REASON : self.ErrorReason := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
//      DecodeResult := 'MTU编号<'+MtuNo+'> WLAN掉线通知: ';
//      DecodeResult:=DecodeResult+' 告警时间 -'+DateTimeToStr(self.STARTTIME);
//      DecodeResult:=DecodeResult+' 掉线原因 -'+IntToStr(self.ErrorReason);
      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(self.STARTTIME)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_WLAN_ERROR_REASON,0,IntToStr(self.ErrorReason)]);
      SQLList.Add(sqlstr);

    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuWLanError.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuSetParam }

constructor TMtuSetParam.create;
begin
  inherited create;
  FMsgID :=MTU_SET_PARAMETER;
  FMsgName :='MTU配置测试参数';
end;

function TMtuSetParam.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := false;
end;

function TMtuSetParam.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //MTU编号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;

    //MTU自检周期
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_MTU_DURATION;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.FMTUDURATION,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;

    //CCH场强检测周期
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CCH_DURATION;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(CCHDURATION,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //WLAN场强检测周期
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_WLAN_DURATION;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(WLanDURATION,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuCmdAck }

constructor TMtuCmdAck.create;
begin
  inherited create;
  FMsgID :=MTU_COMMAND_ACK;
  FMsgName :='所有命令响应';
end;

function TMtuCmdAck.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_COMMAND : self.command :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_RESULT  : self.ackresult :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
//      DecodeResult:='任务编号<'+IntToStr(TaskID)+'> 命令响应: ';
//      DecodeResult:=DecodeResult+' 命令 -'+IntToStr(self.command);
//      DecodeResult:=DecodeResult+' MTU编号 -'+MtuNo;
//      DecodeResult:=DecodeResult+' 结果 -'+IntToStr(self.ackresult);
      //命令响应
//      if self.command=1 then
      begin
        //更新手动测试
        if ackresult=1 then
        begin
          sqlstr:= 'update mtu_testtask_online set STATUS=5 where STATUS=2'+
                   ' and TASKLEVEL=1 and taskid='+inttostr(TaskId);
          SQLList.Add(sqlstr);
        end
        else if ackresult=0 then
        begin
          sqlstr:= 'update mtu_testtask_online set STATUS=3 where STATUS=2'+
                   ' and TASKLEVEL=1 and taskid='+inttostr(TaskId);
          SQLList.Add(sqlstr);
        end;
      end;
      //删除测试任务
      if self.command=9 then
      begin
        sqlstr := Format(DELTASKSQL,[TaskId]);
        SQLList.Add(sqlstr);
        sqlstr := Format(DELTASKPARAMSQL,[TaskId ]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuCmdAck.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuWLanOK }

constructor TMtuWLanOK.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_WLAN_OK;
  FMsgName :='WLAN上线通知';
end;

function TMtuWLanOK.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: self.STARTTIME :=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult := 'MTU编号<'+MtuNo+'> WLAN 上线通知: ';
//      DecodeResult :=DecodeResult+' 时间 -'+DateTimeToStr(STARTTIME);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(self.STARTTIME)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuWLanOK.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuStopTask }

constructor TMtuStopTask.create;
begin
  inherited create;
  FMsgID :=MTU_STOP_TASK;
  FMsgName :='停止任务命令';
end;

function TMtuStopTask.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := false;
end;

function TMtuStopTask.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //MTU编号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,4);
    Move(self.TaskId,Param.ParamValue[0],4);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuGetCallEE }

constructor TMtuGetCallEE.create(IsTest: Boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_GET_CALLEE;
    FMsgName :='MTU号码查询命令';
  end
  else
  begin
    FMsgID :=MTU_GET_CALLEE_RESULT;
    FMsgName :='MTU号码查询结果';
  end;
end;

function TMtuGetCallEE.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  Mtu :Array of String;
  Call :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          //MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_NUMBER : self.nNumber := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_MTU_CALLEE_LIST :
            begin
              SetLength(Call,Length(Call)+1);
              Call[Length(Call)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_DEVICEID :
            begin
              SetLength(Mtu,Length(Mtu)+1);
              Mtu[Length(Mtu)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult := '  MTU电话号码的查询结果: ';
//      DecodeResult :=DecodeResult+ ' 结果数 -'+IntToStr(self.nNumber);
//      for I := 0 to nNumber-1 do
//        DecodeResult :=DecodeResult+' MTU['+Mtu[i]+']的号码-'+Call[i];

      for I := 0 to High(Mtu) do
      begin
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,MTU[i],FMsgID,MTUPARAM_DEVICEID,i,MTU[i]]);
        SQLList.Add(sqlstr);
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,MTU[i],FMsgID,MTUPARAM_MTU_CALLEE_LIST,i,Call[i]]);
        SQLList.Add(sqlstr);

        sqlstr := 'update mtu_testtaskparam_online set taskid='+inttostr(TaskId)+
                  ' where taskid=(select taskid from mtu_testtask_online a where a.comid=6 and a.status=2'+
                  ' and exists (select 1 from mtu_info b where a.mtuid=b.mtuid and b.mtuno='''+MTU[i]+'''))';
        SQLList.Add(sqlstr);
        sqlstr := 'update mtu_testtask_online a set taskid='+inttostr(TaskId)+
                  ' where a.comid=6 and a.status=2'+
                  ' and exists (select 1 from mtu_info b where a.mtuid=b.mtuid and b.mtuno='''+MTU[i]+''')';
        SQLList.Add(sqlstr);
      end;
      SetLength(Mtu,0);
      SetLength(Call,0);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuGetCallEE.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6
    //查询标志
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_SEARCH_FLAG;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := FSearchFlag;
    if FSearchFlag= 1then
    begin
      //MTU编号
      CurIndex := Length(EnCode)-1;
      Param.ParamTag :=MTUPARAM_DEVICEID;
      Param.ParamLen := 8;
      SetLength(Param.ParamValue,0);
      Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

      SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
      EnCode[CurIndex+1] := Param.ParamTag;
      EnCode[CurIndex+2] := Param.ParamLen;
      j :=0;
      for I := CurIndex+3 to Length(EnCode)-1 do
      begin
        EnCode[i] := Param.ParamValue[j];
        Inc(j);
      end;
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuNoLan }

constructor TMtuNoLan.create;
begin
  inherited create;
  FMsgID :=MTU_NOWLAN_REPORT;
  FMsgName :='连续无WLAN场强上报';
end;

function TMtuNoLan.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  ValueList :TStringList;
  I :integer;
  SqlStr :String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_COMMAND: Command := Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: self.MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_RESULT:   self.StatusResult := Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

//      DecodeResult := 'MTU['+MtuNo+'] WLAM场强告警状态 ['+inttostr(StatusResult)+']';
//      FLog.Write(DecodeResult,1);

      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,self.MtuNo,FMsgID,MTUPARAM_RESULT,0,Inttostr(self.StatusResult)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuNoLan.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuNoCCH }

constructor TMtuNoCCH.create;
begin
  inherited create;
  FMsgID :=MTU_NOCCH_REPORT;
  FMsgName :='连续无CCH场强上报';
end;

function TMtuNoCCH.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  ValueList :TStringList;
  I :integer;
  SqlStr :String;
  lMtuKeyWord : String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_COMMAND: Command := Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID: self.MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_RESULT:   self.StatusResult := Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
      lMtuKeyWord := copy(MtuNo,5,1);
      if (Uppercase(lMtuKeyWord)='A') or (Uppercase(lMtuKeyWord)='F') then
      begin
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,self.MtuNo,FMsgID,MTUPARAM_RESULT,0,Inttostr(self.StatusResult)]);
        SQLList.Add(sqlstr);
      end
      else
      if (Uppercase(lMtuKeyWord)='B') or (Uppercase(lMtuKeyWord)='C') then
      begin
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,self.MtuNo,FMsgID,WDPARAM_NO_Rx,0,Inttostr(self.StatusResult)]);
        SQLList.Add(sqlstr);
        sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,self.MtuNo,FMsgID,WDPARAM_NO_Ec,0,Inttostr(self.StatusResult)]);
        SQLList.Add(sqlstr);
      end
      else
        DecodeResult := 'CCH连续无场强：MTU['+MtuNo+']未找到匹配类型,他的第5个字母为['+lMtuKeyWord+']';
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuNoCCH.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuMOSDone }

constructor TMtuMOSDone.create(IsTest: Boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_MOS_VIRTUAL;
    FMsgName :='模拟MOS值';
  end
  else
  begin
    FMsgID :=MTU_MOS_VIRTUAL;
    FMsgName :='解析模拟的MOS值';
  end;
end;

function TMtuMOSDone.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID    : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_MOS_PARASEVALUE: ParaseMosValue :=PParamValue(ValueList.Objects[i]).ParamValue;
        end;
      end;

      DecodeResult:= '任务编号<'+IntToStr(TaskId)+'> MOS值: '+ ParaseMosValue;
      FLog.Write(DecodeResult,1);
      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,0,FCityid,TaskId,FMsgID,WDPARAM_MOS_PARASEVALUE,0,ParaseMosValue]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuMOSDone.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //解吸MOS值
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=WDPARAM_MOS_PARASEVALUE;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(ParaseMosValue);

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuPPPTest }

constructor TMtuPPPTest.create(IsTest: Boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_PPP_TEST;
    FMsgName :='PPP拨号测试命令';
  end
  else
  begin
    FMsgID :=MTU_PPP_TEST_RESULT;
    FMsgName :='PPP拨号测试结果';
  end;
end;

function TMtuPPPTest.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_RESULT : TestResult :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;

      DecodeResult:= '任务编号<'+IntToStr(TaskId)+'> PPP拨号测试结果: 执行序号 -'+IntToStr(FExecID);
      DecodeResult:=DecodeResult+' 测试开始时间 -'+DateTimeToStr(FStartTime)+' 测试结果 -'+inttostr(TestResult);
      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_RESULT,0,IntToStr(TestResult)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuPPPTest.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i ,j,CurIndex : integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //MTU 号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);//RawToBytes(MtuNo,sizeof(TPackHead));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //1	测试次数
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_TIMES;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := self.TestTimes;

    //2次测试间隔
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_INTERVAL;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestInterval,Param.ParamValue[0],2);

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuCDMAREPORT_OFF }

constructor TMtuCDMAREPORT_OFF.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_SIGNALSTREAM_OFF;
  FMsgName :='CDMA信息检测通知(待机)';
end;

function TMtuCDMAREPORT_OFF.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME:  FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_BAND_CLASS: FBCBand:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CHAN :  FCHAN:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_SID : FSID:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_NID : FNID:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN  : FPN:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_SCI : FCSI:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TX_ADJ : FTX_ADJ:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_FER : FFER:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> CDMA信息检测通知(待机): 检测时间-'+DateTimeToStr(FStartTime);
//      DecodeResult:= DecodeResult+ '    BC频段-'+inttostr(FBCBand);
//      DecodeResult:= DecodeResult+ '    信道号-'+inttostr(FCHAN);
//      DecodeResult:= DecodeResult+ '    系统标识-'+inttostr(FSID);
//      DecodeResult:= DecodeResult+ '    网络标识-'+inttostr(FNID);
//      DecodeResult:= DecodeResult+ '    导频偏置-'+inttostr(FPN);
//      DecodeResult:= DecodeResult+ '    Slot cycle-'+inttostr(FCSI);
//      DecodeResult:= DecodeResult+ '    发送功率控制-'+inttostr(FTX_ADJ);
//      DecodeResult:= DecodeResult+ '    误码率-'+inttostr(FFER);
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_BAND_CLASS,0,IntToStr(FBCBand)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_CHAN,0,IntToStr(FCHAN)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_SID,0,IntToStr(FSID)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_NID,0,IntToStr(FNID)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN,0,IntToStr(FPN)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_SCI,0,IntToStr(FCSI)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_TX_ADJ,0,IntToStr(FTX_ADJ)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_FER,0,IntToStr(FFER)]);
      SQLList.Add(sqlstr);
      //模拟告警 不在主服务区
      sqlstr:= 'insert into mtu_testresult_online'+
               ' select a.taskid,a.cityid,a.comid,'+inttostr(MTUPARAM_PN_OUT)+',a.valueindex,'+
               ' case when upper(a.testresult)=upper(c.pncode) or upper(a.testresult)=upper(b.reserve_pncode) then to_char(0) else a.testresult end testresult,'+
               ' a.collecttime,a.execid,a.isprocess,a.mtuid'+
               ' from mtu_testresult_online a'+
               ' left join mtu_info b on a.mtuid=b.mtuid'+
               ' left join cdma_info c on b.mainlook_cnet=c.cdmaid'+
               ' where a.taskid='+inttostr(TaskId)+' and a.comid=73 and a.paramid=54';
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuCDMAREPORT_OFF.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuCDMAREPORT_ON }

constructor TMtuCDMAREPORT_ON.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_SIGNALSTREAM_ON;
  FMsgName :='CDMA信息检测通知(通话)';
end;

function TMtuCDMAREPORT_ON.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME:  FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_BAND_CLASS: FBCBand:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CHAN :  FCHAN:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_SID : FSID:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_NID : FNID:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN  : FPN:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_SCI : FCSI:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TX_ADJ : FTX_ADJ:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_FER : FFER:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> CDMA信息检测通知(通话): 检测时间-'+DateTimeToStr(FStartTime);
//      DecodeResult:= DecodeResult+ '    BC频段-'+inttostr(FBCBand);
//      DecodeResult:= DecodeResult+ '    信道号-'+inttostr(FCHAN);
//      DecodeResult:= DecodeResult+ '    系统标识-'+inttostr(FSID);
//      DecodeResult:= DecodeResult+ '    网络标识-'+inttostr(FNID);
//      DecodeResult:= DecodeResult+ '    导频偏置-'+inttostr(FPN);
//      DecodeResult:= DecodeResult+ '    Slot cycle-'+inttostr(FCSI);
//      DecodeResult:= DecodeResult+ '    发送功率控制-'+inttostr(FTX_ADJ);
//      DecodeResult:= DecodeResult+ '    误码率-'+inttostr(FFER);
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_BAND_CLASS,0,IntToStr(FBCBand)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_CHAN,0,IntToStr(FCHAN)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_SID,0,IntToStr(FSID)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_NID,0,IntToStr(FNID)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN,0,IntToStr(FPN)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_SCI,0,IntToStr(FCSI)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_TX_ADJ,0,IntToStr(FTX_ADJ)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_FER,0,IntToStr(FFER)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuCDMAREPORT_ON.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuNEIGHBORREPORT_OFF }

constructor TMtuNEIGHBORREPORT_OFF.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_NEIGHBOR_OFF;
  FMsgName :='邻区信息检测(待机)';
end;

function TMtuNEIGHBORREPORT_OFF.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  PN_NEIGHBOR :Array of String;
  ECIO :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS: FPNCounts:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN_NEIGHBOR:
            begin
              SetLength(PN_NEIGHBOR,Length(PN_NEIGHBOR)+1);
              PN_NEIGHBOR[Length(PN_NEIGHBOR)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_PN_ECIO:
            begin
              SetLength(ECIO,Length(ECIO)+1);
              ECIO[Length(ECIO)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> 邻区信息检测(待机):邻区个数-'+inttostr(FPNCounts)+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      for I := 0 to FPNCounts - 1 do
//      begin
//        DecodeResult:= DecodeResult+ '  邻区pn-'+PN_NEIGHBOR[i]+ '  邻区ecio-'+ECIO[i];
//      end;
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(FPNCounts)]);
      SQLList.Add(sqlstr);
      //邻区pn
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_NEIGHBOR,i,ChangeN(PN_NEIGHBOR[i])]);
        SQLList.Add(sqlstr);
      end;
      //邻区ecio
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_ECIO,i,ChangeN(ECIO[i])]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuNEIGHBORREPORT_OFF.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuNEIGHBORREPORT_ON }

constructor TMtuNEIGHBORREPORT_ON.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_NEIGHBOR_ON;
  FMsgName :='邻区信息检测(通话)';
end;

function TMtuNEIGHBORREPORT_ON.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  PN_NEIGHBOR :Array of String;
  ECIO :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS: FPNCounts:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN_NEIGHBOR:
            begin
              SetLength(PN_NEIGHBOR,Length(PN_NEIGHBOR)+1);
              PN_NEIGHBOR[Length(PN_NEIGHBOR)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_PN_ECIO:
            begin
              SetLength(ECIO,Length(ECIO)+1);
              ECIO[Length(ECIO)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> 邻区信息检测(通话):邻区个数-'+inttostr(FPNCounts)+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      for I := 0 to FPNCounts - 1 do
//      begin
//        DecodeResult:= DecodeResult+ ' 邻区pn-'+PN_NEIGHBOR[i]+ '  邻区ecio-'+ECIO[i];
//      end;
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(FPNCounts)]);
      SQLList.Add(sqlstr);
      //邻区pn
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_NEIGHBOR,i,ChangeN(PN_NEIGHBOR[i])]);
        SQLList.Add(sqlstr);
      end;
      //邻区ecio
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_ECIO,i,ChangeN(ECIO[i])]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuNEIGHBORREPORT_ON.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuSWITCHREPORT_OFF }

constructor TMtuSWITCHREPORT_OFF.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_SWITCH_OFF;
  FMsgName :='切换相关参数检测通知(待机)';
end;

function TMtuSWITCHREPORT_OFF.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME:  FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TX: self.FTX:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_T_ADD: self.FT_ADD:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_T_DROP: self.FT_DROP:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_T_COMP: self.FT_COMP:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_T_TDROP: self.FT_TDROP:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> 切换相关参数检测通知(待机): 检测时间-'+DateTimeToStr(FStartTime);
//      DecodeResult:= DecodeResult+ 'TX-'+inttostr(FTX);
//      DecodeResult:= DecodeResult+ 'T_ADD-'+inttostr(FT_ADD);
//      DecodeResult:= DecodeResult+ 'T_DROP-'+inttostr(FT_DROP);
//      DecodeResult:= DecodeResult+ 'T_COMP-'+inttostr(FT_COMP);
//      DecodeResult:= DecodeResult+ 'T_TDROP-'+inttostr(FT_TDROP);
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_TX,0,IntToStr(FTX)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_T_ADD,0,IntToStr(FT_ADD)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_T_DROP,0,IntToStr(FT_DROP)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_T_COMP,0,IntToStr(FT_COMP)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_T_TDROP,0,IntToStr(FT_TDROP)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuSWITCHREPORT_OFF.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuSWITCHREPORT_ON }

constructor TMtuSWITCHREPORT_ON.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_SWITCH_ON;
  FMsgName :='切换相关参数检测通知(通话)';
end;

function TMtuSWITCHREPORT_ON.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID: MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME:  FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TX: self.FTX:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_T_ADD: self.FT_ADD:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_T_DROP: self.FT_DROP:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_T_COMP: self.FT_COMP:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_T_TDROP: self.FT_TDROP:= Strtoint(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> 切换相关参数检测通知(通话): 检测时间-'+DateTimeToStr(FStartTime);
//      DecodeResult:= DecodeResult+ 'TX-'+inttostr(FTX);
//      DecodeResult:= DecodeResult+ 'T_ADD-'+inttostr(FT_ADD);
//      DecodeResult:= DecodeResult+ 'T_DROP-'+inttostr(FT_DROP);
//      DecodeResult:= DecodeResult+ 'T_COMP-'+inttostr(FT_COMP);
//      DecodeResult:= DecodeResult+ 'T_TDROP-'+inttostr(FT_TDROP);
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_TX,0,IntToStr(FTX)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_T_ADD,0,IntToStr(FT_ADD)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_T_DROP,0,IntToStr(FT_DROP)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_T_COMP,0,IntToStr(FT_COMP)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskId,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_T_TDROP,0,IntToStr(FT_TDROP)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuSWITCHREPORT_ON.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuFINGERREPORT_OFF }

constructor TMtuFINGERREPORT_OFF.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_FINGER_OFF;
  FMsgName :='Finger信息检测通知(待机)';
end;

function TMtuFINGERREPORT_OFF.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  PN_NEIGHBOR :Array of String;
  ECIO :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS: FPNCounts:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN_NEIGHBOR:
            begin
              SetLength(PN_NEIGHBOR,Length(PN_NEIGHBOR)+1);
              PN_NEIGHBOR[Length(PN_NEIGHBOR)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_PN_ECIO:
            begin
              SetLength(ECIO,Length(ECIO)+1);
              ECIO[Length(ECIO)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> Finger信息检测通知(待机):邻区个数-'+inttostr(FPNCounts)+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      for I := 0 to FPNCounts - 1 do
//      begin
//        DecodeResult:= DecodeResult+ ' 邻区pn-'+PN_NEIGHBOR[i]+ '  邻区ecio-'+ECIO[i];
//      end;
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(FPNCounts)]);
      SQLList.Add(sqlstr);
      //邻区pn
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_NEIGHBOR,i,ChangeN(PN_NEIGHBOR[i])]);
        SQLList.Add(sqlstr);
      end;
      //邻区ecio
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_ECIO,i,ChangeN(ECIO[i])]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuFINGERREPORT_OFF.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuFINGERREPORT_ON }

constructor TMtuFINGERREPORT_ON.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_FINGER_ON;
  FMsgName :='Finger信息检测通知(通话)';
end;

function TMtuFINGERREPORT_ON.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  PN_NEIGHBOR :Array of String;
  ECIO :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS: FPNCounts:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN_NEIGHBOR:
            begin
              SetLength(PN_NEIGHBOR,Length(PN_NEIGHBOR)+1);
              PN_NEIGHBOR[Length(PN_NEIGHBOR)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_PN_ECIO:
            begin
              SetLength(ECIO,Length(ECIO)+1);
              ECIO[Length(ECIO)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> Finger信息检测通知(通话):邻区个数-'+inttostr(FPNCounts)+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      for I := 0 to FPNCounts - 1 do
//      begin
//        DecodeResult:= DecodeResult+ ' 邻区pn-'+PN_NEIGHBOR[i]+ '  邻区ecio-'+ECIO[i];
//      end;
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(FPNCounts)]);
      SQLList.Add(sqlstr);
      //邻区pn
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_NEIGHBOR,i,ChangeN(PN_NEIGHBOR[i])]);
        SQLList.Add(sqlstr);
      end;
      //邻区ecio
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_ECIO,i,ChangeN(ECIO[i])]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuFINGERREPORT_ON.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result := false;
end;

{ TMtuACTIVEREPORT_OFF }

constructor TMtuACTIVEREPORT_OFF.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_ACTIVE_OFF;
  FMsgName :='激活集信息检测通知(待机)';
end;

function TMtuACTIVEREPORT_OFF.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  PN_NEIGHBOR :Array of String;
  ECIO :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS: FPNCounts:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN_NEIGHBOR:
            begin
              SetLength(PN_NEIGHBOR,Length(PN_NEIGHBOR)+1);
              PN_NEIGHBOR[Length(PN_NEIGHBOR)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_PN_ECIO:
            begin
              SetLength(ECIO,Length(ECIO)+1);
              ECIO[Length(ECIO)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> 激活集信息检测通知(待机):邻区个数-'+inttostr(FPNCounts)+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      for I := 0 to FPNCounts - 1 do
//      begin
//        DecodeResult:= DecodeResult+ ' 邻区pn-'+PN_NEIGHBOR[i]+ '  邻区ecio-'+ECIO[i];
//      end;
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(FPNCounts)]);
      SQLList.Add(sqlstr);
      //邻区pn
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_NEIGHBOR,i,ChangeN(PN_NEIGHBOR[i])]);
        SQLList.Add(sqlstr);
      end;
      //邻区ecio
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_ECIO,i,ChangeN(ECIO[i])]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuACTIVEREPORT_OFF.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuACTIVEREPORT_ON }

constructor TMtuACTIVEREPORT_ON.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_ACTIVE_ON;
  FMsgName :='激活集信息检测通知(通话)';
end;

function TMtuACTIVEREPORT_ON.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  PN_NEIGHBOR :Array of String;
  ECIO :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS: FPNCounts:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN_NEIGHBOR:
            begin
              SetLength(PN_NEIGHBOR,Length(PN_NEIGHBOR)+1);
              PN_NEIGHBOR[Length(PN_NEIGHBOR)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_PN_ECIO:
            begin
              SetLength(ECIO,Length(ECIO)+1);
              ECIO[Length(ECIO)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> 激活集信息检测通知(通话):邻区个数-'+inttostr(FPNCounts)+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      for I := 0 to FPNCounts - 1 do
//      begin
//        DecodeResult:= DecodeResult+ ' 邻区pn-'+PN_NEIGHBOR[i]+ '  邻区ecio-'+ECIO[i];
//      end;
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(FPNCounts)]);
      SQLList.Add(sqlstr);
      //邻区pn
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_NEIGHBOR,i,ChangeN(PN_NEIGHBOR[i])]);
        SQLList.Add(sqlstr);
      end;
      //邻区ecio
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_ECIO,i,ChangeN(ECIO[i])]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;

    //模拟告警 不在主服务区
    sqlstr:= 'insert into mtu_testresult_online'+
             ' select a.taskid,a.cityid,a.comid,'+inttostr(MTUPARAM_PN_OUT_ACTIVE)+', 0,'+
             ' case when (instr(upper(a.testresult),upper(c.pncode),1,1)>0) or (instr(upper(a.testresult),upper(b.reserve_pncode),1,1)>0) then to_char(0) else a.testresult end testresult,'+
             ' sysdate, a.execid, 0, a.mtuid'+
             ' from (select taskid, cityid, comid, paramid, execid,'+
                      ' ltrim(max(sys_connect_by_path(testresult,'','')),'','') as testresult, mtuid'+
                      ' from (select a.*,'+
                      '       taskid+cityid+row_number() over (order by cityid,taskid) rn,'+
                      '       row_number() over (partition by cityid,taskid order by valueindex) rn1'+
                      '       from mtu_testresult_online a'+
                      '       where taskid='+inttostr(TaskId)+' and comid=92 and paramid=1021)'+
                      ' group by taskid, cityid, comid, paramid, execid, mtuid'+
                      ' start with rn1=1'+
                      ' connect by rn-1=prior rn) a'+
             ' left join mtu_info b on a.mtuid=b.mtuid'+
             ' left join cdma_info c on b.mainlook_cnet=c.cdmaid';
    SQLList.Add(sqlstr);
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuACTIVEREPORT_ON.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuSECONDREPORT_OFF }

constructor TMtuSECONDREPORT_OFF.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_SECOND_OFF;
  FMsgName :='候选集信息检测通知(待机)';
end;

function TMtuSECONDREPORT_OFF.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  PN_NEIGHBOR :Array of String;
  ECIO :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS: FPNCounts:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN_NEIGHBOR:
            begin
              SetLength(PN_NEIGHBOR,Length(PN_NEIGHBOR)+1);
              PN_NEIGHBOR[Length(PN_NEIGHBOR)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_PN_ECIO:
            begin
              SetLength(ECIO,Length(ECIO)+1);
              ECIO[Length(ECIO)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> 候选集信息检测通知(待机):邻区个数-'+inttostr(FPNCounts)+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      for I := 0 to FPNCounts - 1 do
//      begin
//        DecodeResult:= DecodeResult+ ' 邻区pn-'+PN_NEIGHBOR[i]+ '  邻区ecio-'+ECIO[i];
//      end;
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(FPNCounts)]);
      SQLList.Add(sqlstr);
      //邻区pn
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_NEIGHBOR,i,ChangeN(PN_NEIGHBOR[i])]);
        SQLList.Add(sqlstr);
      end;
      //邻区ecio
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_ECIO,i,ChangeN(ECIO[i])]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuSECONDREPORT_OFF.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuSECONDREPORT_ON }

constructor TMtuSECONDREPORT_ON.create;
begin
  inherited create;
  FMsgID :=MTU_REPORT_SECOND_ON;
  FMsgName :='候选集信息检测通知(通话)';
end;

function TMtuSECONDREPORT_ON.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
  PN_NEIGHBOR :Array of String;
  ECIO :Array of String;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_DEVICEID : MtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:= StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          WDPARAM_NCS: FPNCounts:= StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_PN_NEIGHBOR:
            begin
              SetLength(PN_NEIGHBOR,Length(PN_NEIGHBOR)+1);
              PN_NEIGHBOR[Length(PN_NEIGHBOR)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
          MTUPARAM_PN_ECIO:
            begin
              SetLength(ECIO,Length(ECIO)+1);
              ECIO[Length(ECIO)-1] := PParamValue(ValueList.Objects[i]).ParamValue;
            end;
        end;
      end;
//      DecodeResult:= 'MTU编号<'+MtuNo+'> 候选集信息检测通知(通话):邻区个数-'+inttostr(FPNCounts)+' 测试开始时间 -'+DateTimeToStr(FStartTime);
//      for I := 0 to FPNCounts - 1 do
//      begin
//        DecodeResult:= DecodeResult+ ' 邻区pn-'+PN_NEIGHBOR[i]+ '  邻区ecio-'+ECIO[i];
//      end;
//      FLog.Write(DecodeResult,1);

      //构造入库语句
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,WDPARAM_NCS,0,IntToStr(FPNCounts)]);
      SQLList.Add(sqlstr);
      //邻区pn
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_NEIGHBOR,i,ChangeN(PN_NEIGHBOR[i])]);
        SQLList.Add(sqlstr);
      end;
      //邻区ecio
      for I := 0 to High(PN_NEIGHBOR) do
      begin
        sqlstr := Format(INSERTSQL,[TaskID,FExecID,FCityid,FMtuNo,FMsgID,MTUPARAM_PN_ECIO,i,ChangeN(ECIO[i])]);
        SQLList.Add(sqlstr);
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuSECONDREPORT_ON.GetTestEnCode(var EnCode: TIdBytes): Boolean;
begin
  result:= false;
end;

{ TMtuCallCenter }

constructor TMtuCallCenter.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_TEST_CALL_CENTER;
    FMsgName :='中心平台呼叫MTU测试命令';
  end
  else
  begin
    FMsgID :=MTU_TEST_CALL_CENTER_RESULT;
    FMsgName :='中心平台呼叫MTU测试结果';
  end;
end;

function TMtuCallCenter.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  SqlStr :String;
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_DEVICEID : FMtuNo := PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_EXECID : FExecID :=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CALLEE : FCallee :=PParamValue(ValueList.Objects[i]).ParamValue;
          MTUPARAM_STARTTIME: FStartTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ENDTIME: FEndTime:=StrToDateTime(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_ALERTING_DELAY : FAlertingDelay:=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CONNECT_DELAY  : FConnectDelay:=StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_TALK_DURATION : FTalkDuration := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_CALL_RESULT : FCallResult := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
          MTUPARAM_VOICE_RESULT: FVoiceResult := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
      //构造入库语句
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALLEE,0,CallEE]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_STARTTIME,0,DateTimeToStr(FStartTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ENDTIME,0,DateTimeToStr(FEndTime)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_ALERTING_DELAY,0,IntToStr(FAlertingDelay)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CONNECT_DELAY,0,IntToStr(FConnectDelay)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_TALK_DURATION,0,IntToStr(FTalkDuration)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_CALL_RESULT,0,IntToStr(FCallResult)]);
      SQLList.Add(sqlstr);
      sqlstr := Format(INSERTSQL2,[TaskId,FExecID,FCityid,TaskId,FMsgID,MTUPARAM_VOICE_RESULT,0,IntToStr(FVoiceResult)]);
      SQLList.Add(sqlstr);
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuCallCenter.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i, j, CurIndex: integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //MTU 号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_DEVICEID;
    Param.ParamLen := 8;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(MtuNo);

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //被叫号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_CALLEE;
    Param.ParamLen := Length(self.FCallee);
    SetLength(Param.ParamValue,0);
    Param.ParamValue := StrToAscII(self.FCallee);

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //通话时长
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TALK_DURATION;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.FTalkDuration,Param.ParamValue[0],2);
    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    //测试次数
    CurIndex := Length(EnCode)-1;
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[CurIndex+1] := MTUPARAM_TIMES;
    EnCode[CurIndex+2] := 1;
    EnCode[CurIndex+3] := self.TestTimes;
    //2次测试间隔
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_INTERVAL;
    Param.ParamLen := 2;
    SetLength(Param.ParamValue,2);
    Move(self.TestInterval,Param.ParamValue[0],2);

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

{ TMtuLocalAnalyse }

constructor TMtuLocalAnalyse.create(IsTest: boolean);
begin
  inherited create;
  if IsTest then
  begin
    FMsgID :=MTU_LOCALANALYSE;
    FMsgName :='本地';
  end
  else
  begin
    FMsgID :=MTU_LOCALANALYSE;
    FMsgName :='本地';
  end;
end;

function TMtuLocalAnalyse.DecodeMsgSQL(Msg: TIdBytes;
  var SQLList: TStringList): boolean;
var
  ValueList :TStringList;
  i :  integer;
begin
  inherited DecodeMsgSQL(Msg,SQLList);
  result := true;
  ValueList :=TStringList.Create;
  try
    //解析TLV格式数据
    if GetParamValue(ValueList) then
    try
      for i := 0 to ValueList.Count - 1 do
      begin
        case PParamValue(ValueList.Objects[i]).ParamId of
          MTUPARAM_TASKID : TaskId := StrToInt(PParamValue(ValueList.Objects[i]).ParamValue);
        end;
      end;
    except
      result := false;
      FLog.Write(FMsgName+'解析失败<'+HexAsciiToStr(Msg)+'>',3);
    end;
  finally
    if ValueList <> nil then
      FreeParamValueList(ValueList);
  end;
end;

function TMtuLocalAnalyse.GetTestEnCode(var EnCode: TIdBytes): Boolean;
var
  Param :TParamTLV;
  i, j, CurIndex: integer;
begin
  result := true;
  try
    EnCode := RawToBytes(PackHead,sizeof(TPackHead));
    //消息名称及数据长度
    SetLength(EnCode,Length(EnCode)+3);
    EnCode[4] := self.FMsgID;
    EnCode[5] := 0; // 数据长度需最后附值  5/6
    EnCode[6] := 0; // 数据长度需最后附值  5/6

    //任务号
    CurIndex := Length(EnCode)-1;
    Param.ParamTag :=MTUPARAM_TASKID;
    Param.ParamLen := 4;
    SetLength(Param.ParamValue,0);
    Param.ParamValue := RawToBytes(self.TaskId,sizeof(Integer));

    SetLength(EnCode,Length(EnCode)+2+Length(Param.ParamValue));
    EnCode[CurIndex+1] := Param.ParamTag;
    EnCode[CurIndex+2] := Param.ParamLen;
    j :=0;
    for I := CurIndex+3 to Length(EnCode)-1 do
    begin
      EnCode[i] := Param.ParamValue[j];
      Inc(j);
    end;
    // 数据长度需最后附值  5/6
    i := Length(EnCode)-7;
    Move(i,EnCode[5],2);
  except
    result := false;
  end;
end;

end.
