unit UntSMSClass;

interface

uses IniFiles, SysUtils, Forms, StdCtrls, Log;

type
  TDeliverResp = Record
    Msg_ID: byte;
    DCS : byte;
    StatusReport :byte;
    UserData1 : array[0..17]   of   Char;
    sOrgAddr: array[0..21]   of   Char;    //ooo
    StatusReport1 :array[0..2]   of   Char;
    UserData:  array[0..252]   of   Char;   //oo
    sDestAddr: array[0..21]   of   Char;    //oo
    TimeStamp:  array[0..10]   of   Char;       //oo
    UserData2:      array[0..254]   of   Char;
    UDLen: byte;
  end;

  TSMSClass = Class
  private
    gIp, gPort, gWaittime, gUserName, gPsw, gSPid, gFeeAdr, gDestAddrs: string;
    mDebugLog: TLog;
    FFeeCall: string;
    FDestCall: string;
    FIsActive: boolean;

    procedure AppendLog(strMsg: string; blAlways: boolean=false; iLevel: Integer=1);    //内部调用
    function InitSMSParams: boolean;
    procedure SetDestCall(const Value: string);
    procedure SetFeeCall(const Value: string);
    procedure SetIsActive(const Value: boolean);   //内部调用
  public
    constructor Create(aLog: TLog);             //  创建类        外部调用函数  创建该类
    destructor Destroy; override;   //  释放类

    function InitSMS: boolean;      //初始化类        外部调用函数  创建该类后调用该函数初始化参数
    function SubmitSM(sMessage: string): boolean;     //发送短信        外部调用函数
    function GetDeliverSM(var drDeliverResp: TDeliverResp): boolean;                   //接受短信        外部调用函数
    function FreeSMS: boolean;     //善后类         外部调用函数  程序结束后释放连接
    function GetActiveSMC: boolean;
  published
    property FeeCall: string read FFeeCall write SetFeeCall;        //付费号码
    property DestCall: string read FDestCall write SetDestCall;     //目的号码
    property IsActive: boolean read FIsActive write SetIsActive;
  end;

                           // reRunLog: TRichEdit
  {
    RPublicSM = record
    nMsgType:integer;       //短消息子类型（0：取消订阅，1：订阅或点播请求，2：订阅下发，其他保留）
    nNeedReport:integer;    //是否返回状态确认报告（0：不要求；1:要求）
		nMsgLevel :integer;     //信息级别（0:最低优先级 1:正常 2:紧急 3:十分紧急）
    sServiceID:Array[0..20] of char;       //业务类型, 就是业务代码，比如TQYB等
    nMsgFormat:integer;     //信息格式(一般填 1).
		sFeeType :Array[0..2] of char;        //资费类别
    nFeeUserType :integer;  //计费用户类型（0：对目的终端计费，'1：对源终端计费，2：对SP计费，3：按照计费用户号码计费，其他保留）
    sFeeCode:Array[0..6] of char;   //资费代码（以分为单位）,对于资费类别为按条收费(FEE_BY_ITEM),表示该条短消息的价格
		sValidTime :Array[0..17] of char; // 存活有效时间
    sAtTime :Array[0..17] of char;     // 定时发送时间
		sSrcTermID :Array[0..21] of char;    //发送用户号码
    sChargeTermID :Array[0..21] of char; //计费号码(一般填目的号码sDestTermID,不能为空，否则无法对用户计费)
    nMsgLen :integer;
  end;
  }

function SMGP_IFInitInterface(dwCodeProtocol, dwDriverProtocol: integer; pDriverParam: string): boolean; stdcall;
function SMGP_IFExitInterface: boolean; stdcall;
function SMGP_Login_R(SystemID: string; Password: string;
                              LoginMode: integer): boolean; stdcall;
function SMGP_Logout: boolean; stdcall;
function SMGP30_SubmitSM(byMsgType: byte;
                         SRR: byte;
                         PRI: byte;
                         ServiceSubType: PChar;
                         sFeeType: PChar;
                         sFeeCode: PChar;
                         sFixedFee: PChar;
                         DCS: byte;
                         Expire: PChar;
                         Schedule: PChar;
                         OrgAddr: PChar;
                         sFeeAddr: PChar;
                         byUserNum: byte;
                         sDestAddrs: PChar;
                         UDLen: byte;
                         UserData: PChar;
                         ulTLVlen: LongWord;
                         sTLVBlock: PChar;
                         sReserved: PChar;
                         var bySmgpMsgID: integer;
                         FCS: integer): integer; stdcall;
function SMGP30_GetDeliverSM(Ntimeout: integer;  var DeliverResp: TDeliverResp): integer; stdcall;

implementation

{ TSMSClass }

function SMGP_IFInitInterface(dwCodeProtocol, dwDriverProtocol: integer;
                              pDriverParam: string): boolean; stdcall; external 'SMEIDll.dll';

function SMGP_IFExitInterface: boolean; stdcall; external 'SMEIDll.dll';

function SMGP_Login_R(SystemID: string; Password: string;
                              LoginMode: integer): boolean; stdcall; external 'SMEIDll.dll';

function SMGP_Logout: boolean; stdcall; external 'SMEIDll.dll';

function HasDeliverMessage(dwTimeOut: string): integer; stdcall; external 'SMEIDll.dll';

function SMGP30_SubmitSM(byMsgType: byte;
                         SRR: byte;
                         PRI: byte;
                         ServiceSubType: PChar;
                         sFeeType: PChar;
                         sFeeCode: PChar;
                         sFixedFee: PChar;
                         DCS: byte;
                         Expire: PChar;
                         Schedule: PChar;
                         OrgAddr: PChar;
                         sFeeAddr: PChar;
                         byUserNum: byte;
                         sDestAddrs: PChar;
                         UDLen: byte;
                         UserData: PChar;
                         ulTLVlen: LongWord;
                         sTLVBlock: PChar;
                         sReserved: PChar;
                         var bySmgpMsgID: integer;
                         FCS: integer): integer; stdcall; external 'SMEIDll.dll';

function SMGP30_SubmitSMEx(byMsgType,SRR,PRI,ServiceSubType,sFeeType,sFeeCode,sFixedFee,DCS,Expire,Schedule,
                        OrgAddr,sFeeAddr,byUserNum,sDestAddrs,UDLen,UserData,sReserved,nTLVMask,
                        nTP_Pid,nTP_udhi,sLinkID,sMsgSrc,nChargeUserType,nChargeTermType,
                        sChargeTermPseudo,nDestTermType,sDestTermPseudo,nPkTotal,nPkNumber,nSubmitMsgType,
                        nSPDealResult,sMServiceID: string; var bySmgpMsgID,FCS: integer): integer; stdcall; external 'SMEIDll.dll';

function SMGP30_GetDeliverSM(Ntimeout: integer; var DeliverResp: TDeliverResp): integer; stdcall; external 'SMEIDll.dll';

//------------------------------------------------------------------------------

constructor TSMSClass.Create(aLog: TLog);
begin
  self.mDebugLog := aLog;
end;

destructor TSMSClass.Destroy;
begin

  inherited;
end;

procedure TSMSClass.AppendLog(strMsg: string; blAlways: boolean=false; iLevel: Integer=1);
begin
  if blAlways then   
    mDebugLog.Write(strMsg, iLevel);
end;

function TSMSClass.InitSMSParams: boolean;
var
  lFile: string;
  lNetIni: TIniFile;
begin
  Result := false;
  lFile:=ExtractFilePath(Application.ExeName)+'SMEIDLL.ini';
  if FileExists(lFile) then
  begin
    lNetIni:=TIniFile.Create(lFile);
    try
      gIp:= lNetIni.ReadString('SMEIDLL','IP','');
      gPort:= lNetIni.ReadString('SMEIDLL','PORT','');
      gWaittime:= lNetIni.ReadString('SMEIDLL','WAITTIME','');
      gUserName:= lNetIni.ReadString('SMEIDLL','USERNAME','');
      gPsw:= lNetIni.ReadString('SMEIDLL','PSW','');
      gSPid:= lNetIni.ReadString('SMEIDLL','SPID','');
      gFeeAdr:= lNetIni.ReadString('SENDPARAM','FeeAddr','');
      gDestAddrs:= lNetIni.ReadString('SENDPARAM','DestAddrs','');
      Result := true;
    finally
      lNetIni.Free;
    end;
  end;
end;

//------------------------------------------------------------------------------     

function TSMSClass.InitSMS: boolean;
begin
  Result := InitSMSParams;
  if not Result then
  begin
    mDebugLog.Write('初始化SMS参数失败，请检查配置文件！',2);
    exit;
  end
  else
    mDebugLog.Write('初始化SMS参数成功...',3);

  Result := SMGP_IFInitInterface(11, 1, gIp+' '+gPort+' '+gWaittime);
  if not Result then
  begin
    mDebugLog.Write('初始化(InitInterface)失败！',2);
    exit;
  end
  else
    mDebugLog.Write('初始化(InitInterface)成功...',3);

  Result :=  SMGP_Login_R(gUserName, gPsw, 1);
  if not Result then
  begin
    mDebugLog.Write('登录(Login_R)失败！',2);
    exit;
  end
  else
    mDebugLog.Write('登录(Login_R)成功...',3);
end;

procedure TSMSClass.SetDestCall(const Value: string);
begin
  FDestCall := Value;
end;

procedure TSMSClass.SetFeeCall(const Value: string);
begin
  FFeeCall := Value;
end;

procedure TSMSClass.SetIsActive(const Value: boolean);
begin
  FIsActive := Value;
end;

function TSMSClass.SubmitSM(sMessage: string): boolean;
var
  iResult, iSmgpMsgID, iFCS: Integer;
  sMessageContent: string;
begin
  iSmgpMsgID := 0;
  iFCS := 0;
  sMessageContent := sMessage;
  try
    {iResult:= SMGP30_SubmitSM(6,0,1,'','00','000000','000000',15,'','', PAnsiChar(gSPid),
                              PAnsiChar(gFeeAdr), 1, PAnsiChar(gDestAddrs),
                              Length(sMessageContent), PAnsiChar(sMessageContent),
                              0,'','', iSmgpMsgID,iFCS);  }
    {iResult:= SMGP30_SubmitSM(6,0,1,'','00','000000','000000',0,'','', PAnsiChar(gSPid),
                              PAnsiChar(gFeeAdr), 1, PAnsiChar(gDestAddrs),
                              Length(sMessageContent), PAnsiChar(sMessageContent),
                              0,'','', iSmgpMsgID,iFCS);}
    iResult:= SMGP30_SubmitSM(6,0,1,'','00','000000','000000',0,'','', PAnsiChar(gSPid),
                              PAnsiChar(self.FFeeCall), 1, PAnsiChar(self.FDestCall),
                              Length(sMessageContent), PAnsiChar(sMessageContent),
                              0,'','', iSmgpMsgID,iFCS);
  except
    on e: Exception do
    begin
      mDebugLog.Write('短信发送接口错误'+e.Message,2);
      self.FIsActive:= false;
      exit;
    end;
  end;
  if iResult=0 then
  begin
    Result := true;
  end
  else
  begin
    Result := false;
    mDebugLog.Write('短信发送失败！短信内容：'+sMessageContent,2);
    mDebugLog.Write('返回错误编码：'+IntToStr(iResult)+' MsgID：'+IntToStr(iSmgpMsgID)+' FCS: '+IntToStr(iFCS),2);
  end;
end;

function TSMSClass.GetActiveSMC: boolean;
var
  lRetryCounts: integer;
begin
  result:= FIsActive;
  if not FIsActive then
  begin
    lRetryCounts:= 0;
    repeat
      inc(lRetryCounts);
//      if self.FreeSMS then
      self.FreeSMS;           //退出
      result:= self.InitSMS;  //登录

    until (result) or (lRetryCounts=3);
    self.FIsActive:= result;
  end;
end;

function TSMSClass.GetDeliverSM(var drDeliverResp: TDeliverResp): boolean;
var
  iResult: Integer;   //0 成功 -73 无短信
begin
  try
    iResult := SMGP30_GetDeliverSM(StrToInt(gWaittime), drDeliverResp);
  except
    on e: Exception do
    begin
      mDebugLog.Write('短信接收接口错误'+e.Message,2);
      self.FIsActive:= false;
      exit;
    end;
  end;
  if iResult=0 then
  begin
    Result := true;
  end
  else
  begin
    Result := false;
    mDebugLog.Write('短信接受失败！返回错误编码：'+IntToStr(iResult),2);
  end;
end;

function TSMSClass.FreeSMS: boolean;
begin
  Result := SMGP_Logout;
  Result := Result and SMGP_IFExitInterface;
  if Result then
    mDebugLog.Write('释放SMC链接成功！',3)
  else
    mDebugLog.Write('释放SMC链接失败！',2)
end;


end.
