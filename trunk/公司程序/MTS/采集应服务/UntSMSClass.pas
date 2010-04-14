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

    procedure AppendLog(strMsg: string; blAlways: boolean=false; iLevel: Integer=1);    //�ڲ�����
    function InitSMSParams: boolean;
    procedure SetDestCall(const Value: string);
    procedure SetFeeCall(const Value: string);
    procedure SetIsActive(const Value: boolean);   //�ڲ�����
  public
    constructor Create(aLog: TLog);             //  ������        �ⲿ���ú���  ��������
    destructor Destroy; override;   //  �ͷ���

    function InitSMS: boolean;      //��ʼ����        �ⲿ���ú���  �����������øú�����ʼ������
    function SubmitSM(sMessage: string): boolean;     //���Ͷ���        �ⲿ���ú���
    function GetDeliverSM(var drDeliverResp: TDeliverResp): boolean;                   //���ܶ���        �ⲿ���ú���
    function FreeSMS: boolean;     //�ƺ���         �ⲿ���ú���  ����������ͷ�����
    function GetActiveSMC: boolean;
  published
    property FeeCall: string read FFeeCall write SetFeeCall;        //���Ѻ���
    property DestCall: string read FDestCall write SetDestCall;     //Ŀ�ĺ���
    property IsActive: boolean read FIsActive write SetIsActive;
  end;

                           // reRunLog: TRichEdit
  {
    RPublicSM = record
    nMsgType:integer;       //����Ϣ�����ͣ�0��ȡ�����ģ�1�����Ļ�㲥����2�������·�������������
    nNeedReport:integer;    //�Ƿ񷵻�״̬ȷ�ϱ��棨0����Ҫ��1:Ҫ��
		nMsgLevel :integer;     //��Ϣ����0:������ȼ� 1:���� 2:���� 3:ʮ�ֽ�����
    sServiceID:Array[0..20] of char;       //ҵ������, ����ҵ����룬����TQYB��
    nMsgFormat:integer;     //��Ϣ��ʽ(һ���� 1).
		sFeeType :Array[0..2] of char;        //�ʷ����
    nFeeUserType :integer;  //�Ʒ��û����ͣ�0����Ŀ���ն˼Ʒѣ�'1����Դ�ն˼Ʒѣ�2����SP�Ʒѣ�3�����ռƷ��û�����Ʒѣ�����������
    sFeeCode:Array[0..6] of char;   //�ʷѴ��루�Է�Ϊ��λ��,�����ʷ����Ϊ�����շ�(FEE_BY_ITEM),��ʾ��������Ϣ�ļ۸�
		sValidTime :Array[0..17] of char; // �����Чʱ��
    sAtTime :Array[0..17] of char;     // ��ʱ����ʱ��
		sSrcTermID :Array[0..21] of char;    //�����û�����
    sChargeTermID :Array[0..21] of char; //�ƷѺ���(һ����Ŀ�ĺ���sDestTermID,����Ϊ�գ������޷����û��Ʒ�)
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
    mDebugLog.Write('��ʼ��SMS����ʧ�ܣ����������ļ���',2);
    exit;
  end
  else
    mDebugLog.Write('��ʼ��SMS�����ɹ�...',3);

  Result := SMGP_IFInitInterface(11, 1, gIp+' '+gPort+' '+gWaittime);
  if not Result then
  begin
    mDebugLog.Write('��ʼ��(InitInterface)ʧ�ܣ�',2);
    exit;
  end
  else
    mDebugLog.Write('��ʼ��(InitInterface)�ɹ�...',3);

  Result :=  SMGP_Login_R(gUserName, gPsw, 1);
  if not Result then
  begin
    mDebugLog.Write('��¼(Login_R)ʧ�ܣ�',2);
    exit;
  end
  else
    mDebugLog.Write('��¼(Login_R)�ɹ�...',3);
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
      mDebugLog.Write('���ŷ��ͽӿڴ���'+e.Message,2);
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
    mDebugLog.Write('���ŷ���ʧ�ܣ��������ݣ�'+sMessageContent,2);
    mDebugLog.Write('���ش�����룺'+IntToStr(iResult)+' MsgID��'+IntToStr(iSmgpMsgID)+' FCS: '+IntToStr(iFCS),2);
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
      self.FreeSMS;           //�˳�
      result:= self.InitSMS;  //��¼

    until (result) or (lRetryCounts=3);
    self.FIsActive:= result;
  end;
end;

function TSMSClass.GetDeliverSM(var drDeliverResp: TDeliverResp): boolean;
var
  iResult: Integer;   //0 �ɹ� -73 �޶���
begin
  try
    iResult := SMGP30_GetDeliverSM(StrToInt(gWaittime), drDeliverResp);
  except
    on e: Exception do
    begin
      mDebugLog.Write('���Ž��սӿڴ���'+e.Message,2);
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
    mDebugLog.Write('���Ž���ʧ�ܣ����ش�����룺'+IntToStr(iResult),2);
  end;
end;

function TSMSClass.FreeSMS: boolean;
begin
  Result := SMGP_Logout;
  Result := Result and SMGP_IFExitInterface;
  if Result then
    mDebugLog.Write('�ͷ�SMC���ӳɹ���',3)
  else
    mDebugLog.Write('�ͷ�SMC����ʧ�ܣ�',2)
end;


end.
