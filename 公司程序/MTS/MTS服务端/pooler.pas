{*******************************************************}
{                                                       }
{        Midas RemoteDataModule Pooler Demo             }
{                                                       }
{*******************************************************}

unit pooler;

interface

uses
  ComObj, ActiveX, MTS_Server_TLB, Classes, SyncObjs, Windows;

type
{
  This is the pooler class.  It is responsible for managing the pooled RDMs.
  It implements the same interface as the RDM does, and each call will get an
  unused RDM and use it for the call.
}
  TPooler = class(TAutoObject, IRDM_MTS)
  private
    function LockRDM: IRDM_MTS;
    procedure UnlockRDM(Value: IRDM_MTS);

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
    function GetPriv(userid: Integer): OleVariant; safecall;
    function CDSApplyUpdates(var vDetailArray: OleVariant; vProviderArray,
      OwnerData: OleVariant): OleVariant; safecall;
    function GetCDSData(OwnerData: OleVariant; DspId: Integer): OleVariant;
      safecall;
    function LogIn(const UserNo, password: WideString;
      out userid: OleVariant): OleVariant; safecall;
    function ExecBatchSQL(OwnerData: OleVariant): OleVariant; safecall;
    function ProduceFlowNumID(const l_FLowName: WideString;
      l_SeriesNum: Integer): Integer; safecall;
    function CollectServerMsg(EventId, cityid: Integer;
      const Msg: WideString): OleVariant; safecall;
    function ChangePassword(const OldPassword, NewPassword,UserNo: WideString): Smallint;
      safecall;
    function GetTheSequenceId(const Seqname: WideString): Integer; safecall;
    function GetRingRemind(aCityID, aUserID, aRemindType: Integer;
      out aIsRing: Integer; out vWavName: WideString): Integer; safecall;
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
    procedure ReleaseLock(Index: Integer; var Value: IRDM_MTS);
    function CreateNewInstance: IRDM_MTS;
  public
    constructor Create;
    destructor Destroy; override;
    function LockRDM: IRDM_MTS;
    procedure UnlockRDM(var Value: IRDM_MTS);

    property Timeout: Integer read FTimeout;
    property MaxCount: Integer read FMaxCount;
  end;

  PRDM = ^TRDM;
  TRDM = record
    Intf: IRDM_MTS;
    InUse: Boolean;
  end;

var
  PoolManager: TPoolManager;

implementation

uses ComServ,Ut_RDM_MTS,SysUtils;

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

procedure TPoolManager.ReleaseLock(Index: Integer; var Value: IRDM_MTS);
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

function TPoolManager.CreateNewInstance: IRDM_MTS;
var
  p: PRDM;
begin
  FCriticalSection.Enter;
  try
    New(p);
    p.Intf := RDMFactory.CreateComObject(nil) as IRDM_MTS;
    p.InUse := True;
    FRDMList.Add(p);
    Result := p.Intf;
  finally
    FCriticalSection.Leave;
  end;
end;

function TPoolManager.LockRDM: IRDM_MTS;
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

procedure TPoolManager.UnlockRDM(var Value: IRDM_MTS);
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

function TPooler.LockRDM: IRDM_MTS;
begin
  Result := PoolManager.LockRDM;
end;

function TPooler.LogIn(const UserNo, password: WideString;
  out userid: OleVariant): OleVariant;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.LogIn(UserNo, password, userid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.ProduceFlowNumID(const l_FLowName: WideString;
  l_SeriesNum: Integer): Integer;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.ProduceFlowNumID(l_FLowName, l_SeriesNum);
  finally
    UnlockRDM(RDM);
  end;
end;

procedure TPooler.UnlockRDM(Value: IRDM_MTS);
begin
  PoolManager.UnlockRDM(Value);
end;

function TPooler.AS_ApplyUpdates(const ProviderName: WideString;
  Delta: OleVariant; MaxErrors: Integer; out ErrorCount: Integer;
  var OwnerData: OleVariant): OleVariant;
var
  RDM: IRDM_MTS;
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
  RDM: IRDM_MTS;
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
  RDM: IRDM_MTS;
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
  RDM: IRDM_MTS;
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
  RDM: IRDM_MTS;
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
  RDM: IRDM_MTS;
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
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.AS_RowRequest(ProviderName, Row, RequestType, OwnerData);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.CDSApplyUpdates(var vDetailArray: OleVariant; vProviderArray,
  OwnerData: OleVariant): OleVariant;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.CDSApplyUpdates(vDetailArray,vProviderArray,OwnerData);
  finally
    UnlockRDM(RDM);
  end;
end;


function TPooler.ChangePassword(const OldPassword, NewPassword,
  UserNo: WideString): Smallint;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.ChangePassword(OldPassword, NewPassword,UserNo);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.CollectServerMsg(EventId, cityid: Integer;
  const Msg: WideString): OleVariant;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.CollectServerMsg(EventId, cityid,Msg);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.ExecBatchSQL(OwnerData: OleVariant): OleVariant;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.ExecBatchSQL(OwnerData);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.GetCDSData(OwnerData: OleVariant; DspId: Integer): OleVariant;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.GetCDSData(OwnerData,DspId);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.GetPriv(userid: Integer): OleVariant;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.GetPriv(userid);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.GetTheSequenceId(const Seqname: WideString): Integer;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.GetTheSequenceId(Seqname);
  finally
    UnlockRDM(RDM);
  end;
end;

function TPooler.GetRingRemind(aCityID, aUserID, aRemindType: Integer;
  out aIsRing: Integer; out vWavName: WideString): Integer;
var
  RDM: IRDM_MTS;
begin
  RDM := LockRDM;
  try
    Result := RDM.GetRingRemind(aCityID, aUserID, aRemindType, aIsRing, vWavName);
  finally
    UnlockRDM(RDM);
  end;
end;

initialization
  PoolManager := TPoolManager.Create;
  TAutoObjectFactory.Create(ComServer, TPooler, CLASS_pool, ciMultiInstance, tmFree);
finalization
  PoolManager.Free;
end.
