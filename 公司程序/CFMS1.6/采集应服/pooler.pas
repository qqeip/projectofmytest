{*******************************************************}
{                                                       }
{        Midas RemoteDataModule Pooler Demo             }
{                                                       }
{*******************************************************}

unit pooler;

interface

uses
  ComObj, ActiveX, Prj_Collect_Service_TLB, Classes, SyncObjs, Windows;

type
{
  This is the pooler class.  It is responsible for managing the pooled RDMs.
  It implements the same interface as the RDM does, and each call will get an
  unused RDM and use it for the call.
}
  TPooler = class(TAutoObject, ICollectServer)
  private
    function LockRDM: ICollectServer;
    procedure UnlockRDM(Value: ICollectServer);
  protected
    { IAppServer }
    function  AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant;
                              MaxErrors: Integer; out ErrorCount: Integer; var OwnerData: OleVariant): OleVariant; safecall;
    function  AS_GetRecords(const ProviderName: WideString; Count: Integer; out RecsOut: Integer;
                            Options: Integer; const CommandText: WideString;
                            var Params: OleVariant; var OwnerData: OleVariant): OleVariant; safecall;
    function  AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant; safecall;
    function  AS_GetProviderNames: OleVariant; safecall;
    function  AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant; safecall;
    function  AS_RowRequest(const ProviderName: WideString; Row: OleVariant; RequestType: Integer;
                            var OwnerData: OleVariant): OleVariant; safecall;
    procedure AS_Execute(const ProviderName: WideString; const CommandText: WideString;
                         var Params: OleVariant; var OwnerData: OleVariant); safecall;

    procedure GetAppSrvIP(var ComputerName, IPAddr: WideString); safecall;
    procedure GetFuncs(aZh: OleVariant; var vFuncs: OleVariant); safecall;
    procedure AddUser(Host, IP, UserAlias, ConnTime: OleVariant); safecall;
    procedure DelUser(Host, IP, UserAlias, ConnTime: OleVariant); safecall;
    function GetSysDateTime: TDateTime; safecall;
    function Logined(bAliasName, aPassword: OleVariant; out UserID, UserName,
      AdminNo,CityID: OleVariant): OleVariant; safecall;
    function UpdatePassword(const bAliasName,
      aPassword: WideString): OleVariant; safecall;
    function ProduceFlowNumID(const I_FLOWNAME: WideString; I_SERIESNUM: Integer): Integer; safecall;
    function Get_EndSend: WideString; safecall;
    function Get_Cs_Status: WideString; safecall;
    procedure Set_Cs_Status(const Value: WideString); safecall;
    procedure Set_EndSend(const Value: WideString); safecall;
    function Get_IsAutoWrecker: Integer; safecall;
    procedure Set_IsAutoWrecker(Value: Integer); safecall;
    function SaveWrecker(SourceFlowtache, TargerFlowtache, BatchID: Integer;
      const NodeAddress, VOperator: WideString;cityid:integer): Integer; safecall;
    function TransferDataToPutIn(const BID, OperatorID, DelayDay, RemindDay,
      Reason, Code, phone: WideString;cityid:integer): OleVariant; safecall;
    function SetAlarmDealWithFlag(const BID, Flag,
      sFieldName: WideString;cityid:integer): OleVariant; safecall;
    function TransferDataToOnLine(const BID, OperatorID,
      Reason: WideString;cityid:integer): OleVariant; safecall;
    function TransferDataToStay(const BID, OperatorID, DelayDay, RemindDay,
      Reason: WideString; Flowtache,cityid: Integer): OleVariant; safecall;
    function AttachAlarm(BatchID, SFlowTach, TFlowTach: Integer;
      const VOperator: WideString;cityid: Integer): OleVariant; safecall;
    function RemoveAlarm(BatchID: Integer; const NodeAddress, VOperator,
      Reason: WideString;cityid:integer): OleVariant; safecall;
    function GetDeptIdAndAreaID(out DeptID, AreaID: OleVariant;
      var UserID: OleVariant; out ParentID: OleVariant;cityid:integer;out iLevel: OleVariant): OleVariant;
      safecall;
    function ManualSendAlarm(const NodeAddress, UserNo,
      Phone: WideString;cityid:integer;ifStaySend:integer): Integer; safecall;
    function RemoveManualAlarm(const NodeAddress: WideString;cityid:integer): OleVariant; safecall;
    function Get_StartSend: WideString; safecall;
    procedure Set_StartSend(const Value: WideString); safecall;
    function Get_Cs_Area: WideString; safecall;
    function Get_Cs_Power: WideString; safecall;
    procedure Set_Cs_Area(const Value: WideString); safecall;
    procedure Set_Cs_Power(const Value: WideString); safecall;
    function SaveSolveMethod(const BID, Code, Content: WideString;cityid:integer): OleVariant;
      safecall;

    function AlarmManpower(const NodeAddress: WideString; ContentCode: Integer;
      const AlarmNote, Provider, Contactphone, Remark: WideString;
      CSID: Integer; const VOperator: WideString;cityid:integer): Integer; safecall;
    function StayAlarmReSend(const BID, Operator: WideString;
      Flowtache,cityid: Integer): OleVariant; safecall;
    function Get_CityID: Integer; safecall;
    procedure Set_CityID(Value: Integer); safecall;
    function PutInAndWrecker(BID, OperatorID: Integer;
      const NodeAddress: WideString;cityid:integer): OleVariant; safecall;
    function OperateUserInfo(Flag: Integer; var AUser,
      FunList: OleVariant): OleVariant; safecall;
    function DeleteUserInfo(Userid: Integer): OleVariant; safecall;
    function OperateDistrictInfo(Flag: Integer; var districtid: Integer;
      const dname: WideString; parentid: Integer; const Remark: WideString;
      CurUserID: Integer; var AreaList: OleVariant;var cityid: Integer;districtlevel: Integer): OleVariant; safecall;
    function DeleteDistrictInfo(DistrictID: Integer;cityid:integer): OleVariant; safecall;
    procedure SendRuleSet(kind: Integer; rulevalue: OleVariant;
      cityid: Integer); safecall;
    function DeleteDeferSendRule(cityid, rulecode: Integer): OleVariant;
      safecall;
    function OperatorDeferSendRule(rulecode: Integer; const rulename, rulecontent,
      remark: WideString; rulekind, rulelevel, issend, ruleinterval,
      cityid,ifineffect: Integer; const colorid: WideString;flag: Integer): OleVariant; safecall;
    function AlarmSendToOneStation(cityid, batchid: Integer): OleVariant;
      safecall;
    function OperatorModifyUser(UserID: Integer; const UserNo, UserName,
      Phone: WideString; Sex, districtid, Flag, cityid, creator: Integer;
      const email: WideString;ZONEID: Integer): OleVariant; safecall;
    procedure ControlAppSvr(ControlIdx: Integer); safecall;
    function GetShortMessageData(var MsgData: OleVariant): OleVariant;
      safecall;
    function GetSMPhone(districtid, cityid: Integer;
      var PhoneData: OleVariant): OleVariant; safecall;
    procedure SetShortMessageFlag(batchid, cityid: Integer); safecall;
    function AlarmTest_CS(const NodeAddress: WideString; cityid, contentcode,
      testtype: Integer): OleVariant; safecall;
  end;

{
  The pool manager is responsible for keeping a list of RDMs that are being
  pooled and for giving out unused RDMs.
}
  TPoolManager = class(TObject)
  private
    FRDMList: TList;
    FMaxCount: Integer;
    FTimeout: Integer;
    FCriticalSection: TCriticalSection;
    FSemaphore: THandle;

    function GetLock(Index: Integer): Boolean;
    procedure ReleaseLock(Index: Integer; var Value: ICollectServer);
    function CreateNewInstance: ICollectServer;
  public
    constructor Create;
    destructor Destroy; override;
    function LockRDM: ICollectServer;
    procedure UnlockRDM(var Value: ICollectServer);

    property Timeout: Integer read FTimeout;
    property MaxCount: Integer read FMaxCount;
  end;

  PRDM = ^TRDM;
  TRDM = record
    Intf: ICollectServer;
    InUse: Boolean;
  end;

var
  PoolManager: TPoolManager;

implementation

uses ComServ,Ut_Data_Remote,SysUtils;

constructor TPoolManager.Create;
begin
  FRDMList := TList.Create;
  FCriticalSection := TCriticalSection.Create;
  FTimeout := 5000;
  FMaxCount := 30;
  FSemaphore := CreateSemaphore(nil, FMaxCount, FMaxCount, nil);
end;

destructor TPoolManager.Destroy;
var
  i: Integer;
begin
  FCriticalSection.Free;
  for i := 0 to FRDMList.Count - 1 do
  begin
    PRDM(FRDMList[i]).Intf := nil;
    FreeMem(PRDM(FRDMList[i]));
  end;
  FRDMList.Free;
  CloseHandle(FSemaphore);
  inherited Destroy;
end;

function TPoolManager.GetLock(Index: Integer): Boolean;
begin
  FCriticalSection.Enter;
  try
    Result := not PRDM(FRDMList[Index]).InUse;
    if Result then
      PRDM(FRDMList[Index]).InUse := True;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TPoolManager.ReleaseLock(Index: Integer; var Value: ICollectServer);
begin
  FCriticalSection.Enter;
  try
    PRDM(FRDMList[Index]).InUse := False;
    Value := nil;
    ReleaseSemaphore(FSemaphore, 1, nil);
  finally
    FCriticalSection.Leave;
  end;
end;

function TPoolManager.CreateNewInstance: ICollectServer;
var
  p: PRDM;
begin
  FCriticalSection.Enter;
  try
    New(p);
    p.Intf := RDMFactory.CreateComObject(nil) as ICollectServer;
    p.InUse := True;
    FRDMList.Add(p);
    Result := p.Intf;
  finally
    FCriticalSection.Leave;
  end;
end;

function TPoolManager.LockRDM: ICollectServer;
var
  i: Integer;
begin
  Result := nil;
  if WaitForSingleObject(FSemaphore, Timeout) = WAIT_FAILED then
    raise Exception.Create('Server too busy');
  for i := 0 to FRDMList.Count - 1 do
  begin
    if GetLock(i) then
    begin
      Result := PRDM(FRDMList[i]).Intf;
      Exit;
    end;
  end;
  if FRDMList.Count < MaxCount then
    Result := CreateNewInstance;
  if Result = nil then { This shouldn't happen because of the sempahore locks }
    raise Exception.Create('Unable to lock RDM');
end;

procedure TPoolManager.UnlockRDM(var Value: ICollectServer);
var
  i: Integer;
begin
  for i := 0 to FRDMList.Count - 1 do
  begin
    if Value = PRDM(FRDMList[i]).Intf then
    begin
      ReleaseLock(i, Value);
      break;
    end;
  end;
end;

{
  Each call for the server is wrapped in a call to retrieve the RDM, and then
  when it is finished it releases the RDM.
}

function TPooler.LockRDM: ICollectServer;
begin
  Result := PoolManager.LockRDM;
end;

procedure TPooler.UnlockRDM(Value: ICollectServer);
begin
  PoolManager.UnlockRDM(Value);
end;

function TPooler.AS_ApplyUpdates(const ProviderName: WideString;
  Delta: OleVariant; MaxErrors: Integer; out ErrorCount: Integer;
  var OwnerData: OleVariant): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.AS_ApplyUpdates(ProviderName, Delta, MaxErrors, ErrorCount, OwnerData);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.AS_DataRequest(const ProviderName: WideString;
  Data: OleVariant): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.AS_DataRequest(ProviderName, Data);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.AS_Execute(const ProviderName, CommandText: WideString;
  var Params, OwnerData: OleVariant);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.AS_Execute(ProviderName, CommandText, Params, OwnerData);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.AS_GetParams(const ProviderName: WideString;
  var OwnerData: OleVariant): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.AS_GetParams(ProviderName, OwnerData);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.AS_GetProviderNames: OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.AS_GetProviderNames;
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.AS_GetRecords(const ProviderName: WideString;
  Count: Integer; out RecsOut: Integer; Options: Integer;
  const CommandText: WideString; var Params,
  OwnerData: OleVariant): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.AS_GetRecords(ProviderName, Count, RecsOut, Options,
      CommandText, Params, OwnerData);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.AS_RowRequest(const ProviderName: WideString;
  Row: OleVariant; RequestType: Integer;
  var OwnerData: OleVariant): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.AS_RowRequest(ProviderName, Row, RequestType, OwnerData);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.GetAppSrvIP(var ComputerName, IPAddr: WideString);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.GetAppSrvIP(ComputerName, IPAddr);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.GetFuncs(aZh: OleVariant; var vFuncs: OleVariant);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.GetFuncs(aZh, vFuncs);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.AddUser(Host, IP, UserAlias, ConnTime: OleVariant);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.AddUser(Host, IP, UserAlias, ConnTime);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.DelUser(Host, IP, UserAlias, ConnTime: OleVariant);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.DelUser(Host, IP, UserAlias, ConnTime);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.GetSysDateTime: TDateTime;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.GetSysDateTime;
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.Logined(bAliasName, aPassword: OleVariant; out UserID, UserName, AdminNo,CityID: OleVariant): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.Logined(bAliasName, aPassword, UserID, UserName, AdminNo,CityID);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.UpdatePassword(const bAliasName, aPassword: WideString): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.UpdatePassword(bAliasName, aPassword);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.ProduceFlowNumID(const I_FLOWNAME: WideString; I_SERIESNUM: Integer): Integer;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.ProduceFlowNumID(I_FLOWNAME, I_SERIESNUM);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.Get_EndSend: WideString;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.Get_EndSend;
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.Get_Cs_Status: WideString;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.Get_Cs_Status;
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.Set_Cs_Status(const Value: WideString);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.Set_Cs_Status(Value);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.Set_EndSend(const Value: WideString);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.Set_EndSend(Value);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.Get_IsAutoWrecker: Integer;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.Get_IsAutoWrecker;
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.Set_IsAutoWrecker(Value: Integer);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.Set_IsAutoWrecker(Value);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.SaveWrecker(SourceFlowtache, TargerFlowtache, BatchID: Integer; const NodeAddress, VOperator: WideString;cityid:integer): Integer;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.SaveWrecker(SourceFlowtache, TargerFlowtache, BatchID, NodeAddress, VOperator,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.TransferDataToPutIn(const BID, OperatorID, DelayDay, RemindDay,
  Reason, Code, phone: WideString;cityid:integer): OleVariant;
  var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.TransferDataToPutIn(BID, OperatorID, DelayDay, RemindDay, Reason, Code, phone,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.SetAlarmDealWithFlag(const BID, Flag, sFieldName: WideString;cityid:integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.SetAlarmDealWithFlag(BID, Flag, sFieldName,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.TransferDataToOnLine(const BID, OperatorID, Reason: WideString;cityid:integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.TransferDataToOnLine(BID, OperatorID, Reason,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.TransferDataToStay(const BID, OperatorID, DelayDay, RemindDay,
  Reason: WideString; Flowtache,cityid: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.TransferDataToStay(BID, OperatorID, DelayDay, RemindDay, Reason, Flowtache,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.AttachAlarm(BatchID, SFlowTach, TFlowTach: Integer; const VOperator: WideString;cityid: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.AttachAlarm(BatchID, SFlowTach, TFlowTach, VOperator,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.RemoveAlarm(BatchID: Integer; const NodeAddress, VOperator, Reason: WideString;cityid:integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.RemoveAlarm(BatchID, NodeAddress, VOperator, Reason,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.GetDeptIdAndAreaID(out DeptID, AreaID: OleVariant;
  var UserID: OleVariant; out ParentID: OleVariant;cityid:integer;out iLevel: OleVariant): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.GetDeptIdAndAreaID(DeptID, AreaID, UserID, ParentID,cityid,iLevel);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.ManualSendAlarm(const NodeAddress, UserNo, Phone: WideString;cityid:integer;ifStaySend:integer): Integer;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.ManualSendAlarm(NodeAddress, UserNo, Phone,cityid,ifStaySend);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.RemoveManualAlarm(const NodeAddress: WideString;cityid:integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.RemoveManualAlarm(NodeAddress,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.Get_StartSend: WideString;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.Get_StartSend;
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.Set_StartSend(const Value: WideString);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.Set_StartSend(Value);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.Get_Cs_Area: WideString;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.Get_Cs_Area;
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.Get_Cs_Power: WideString;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.Get_Cs_Power;
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.Set_Cs_Area(const Value: WideString);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.Set_Cs_Area(Value);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.Set_Cs_Power(const Value: WideString);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.Set_Cs_Power(Value);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.SaveSolveMethod(const BID, Code, Content: WideString;cityid:integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.SaveSolveMethod(BID, Code, Content,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;


function TPooler.AlarmManpower(const NodeAddress: WideString; ContentCode: Integer;
  const AlarmNote, Provider, Contactphone, Remark: WideString;
  CSID: Integer; const VOperator: WideString;cityid:integer): Integer;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.AlarmManpower(NodeAddress, ContentCode, AlarmNote, Provider, Contactphone, Remark, CSID, VOperator,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.StayAlarmReSend(const BID, Operator: WideString; Flowtache,cityid: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.StayAlarmReSend(BID, Operator, Flowtache,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.Get_CityID: Integer;
begin
end;

procedure TPooler.Set_CityID(Value: Integer);
begin

end;

function TPooler.PutInAndWrecker(BID, OperatorID: Integer; const NodeAddress: WideString;cityid:integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.PutInAndWrecker(BID, OperatorID, NodeAddress,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.OperateUserInfo(Flag: Integer; var AUser, FunList: OleVariant): OleVariant;
  var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.OperateUserInfo(Flag, AUser, FunList);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.DeleteUserInfo(Userid: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.DeleteUserInfo(Userid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.OperateDistrictInfo(Flag: Integer; var districtid: Integer;
  const dname: WideString; parentid: Integer; const Remark: WideString;
  CurUserID: Integer; var AreaList: OleVariant;var cityid: Integer;districtlevel: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.OperateDistrictInfo(Flag, districtid, dname, parentid, Remark, CurUserID, AreaList,cityid,districtlevel);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.DeleteDistrictInfo(DistrictID: Integer;cityid:integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    Result := RDM.DeleteDistrictInfo(DistrictID,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.SendRuleSet(kind: Integer;  rulevalue: OleVariant;
  cityid: Integer);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.SendRuleSet(kind,rulevalue,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.DeleteDeferSendRule(cityid,
  rulecode: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.DeleteDeferSendRule(cityid,rulecode);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.OperatorDeferSendRule(rulecode: Integer; const rulename,
  rulecontent, remark: WideString; rulekind, rulelevel, issend,
  ruleinterval, cityid,ifineffect: Integer; const colorid: WideString;flag: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.OperatorDeferSendRule(rulecode,rulename,rulecontent, remark,rulekind, rulelevel, issend,ruleinterval,cityid,ifineffect,colorid,flag);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.AlarmSendToOneStation(cityid,
  batchid: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.AlarmSendToOneStation(cityid,batchid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.OperatorModifyUser(UserID: Integer; const UserNo,
  UserName, Phone: WideString; Sex, districtid, Flag, cityid,
  creator: Integer; const email: WideString;ZONEID: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.OperatorModifyUser(UserID,UserNo,UserName, Phone,Sex,districtid,Flag,cityid,creator,email,ZONEID);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.ControlAppSvr(ControlIdx: Integer);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
    RDM.ControlAppSvr(ControlIdx);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.GetShortMessageData(var MsgData: OleVariant): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
     result :=RDM.GetShortMessageData(MsgData);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.GetSMPhone(districtid, cityid: Integer;
  var PhoneData: OleVariant):OleVariant; safecall;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
     result :=RDM.GetSMPhone(districtid, cityid,PhoneData);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.SetShortMessageFlag(batchid, cityid: Integer);
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
     RDM.SetShortMessageFlag(batchid,cityid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.AlarmTest_CS(const NodeAddress: WideString; cityid,
  contentcode, testtype: Integer): OleVariant;
var
  RDM: ICollectServer;
begin
  RDM := LockRDM;
  try
     result := RDM.AlarmTest_CS(NodeAddress,cityid,contentcode,testtype)
  finally
    UnlockRDM(RDM);
  end;
end;

initialization
  PoolManager := TPoolManager.Create;
  TAutoObjectFactory.Create(ComServer, TPooler, Class_Pooler, ciMultiInstance, tmFree);
finalization
  PoolManager.Free;
end.
