unit AlarmServiceApp_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2007-7-9 11:04:07 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Project\POP_AMS\04、编码\2.95版本源码\派障应服\AlarmServiceApp.tlb (1)
// LIBID: {285CA3C2-FC55-449B-B521-AABF7410AE14}
// LCID: 0
// Helpfile: 
// HelpString: AlarmServiceApp Library
// DepndLst: 
//   (1) v1.0 Midas, (C:\WINDOWS\system32\midas.dll)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, Midas, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  AlarmServiceAppMajorVersion = 1;
  AlarmServiceAppMinorVersion = 0;

  LIBID_AlarmServiceApp: TGUID = '{285CA3C2-FC55-449B-B521-AABF7410AE14}';

  IID_ICollectServer: TGUID = '{09AB7282-0FBA-4C16-81DC-B722CA94C7D7}';
  CLASS_CollectServer: TGUID = '{09AB7282-0FBA-4C16-81DC-B722CA94C7D1}';
  CLASS_pooler: TGUID = '{E281BE8C-07A7-4B14-878D-6E2D6BCC6628}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  ICollectServer = interface;
  ICollectServerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CollectServer = ICollectServer;
  pooler = ICollectServer;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}
  PInteger1 = ^Integer; {*}


// *********************************************************************//
// Interface: ICollectServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {09AB7282-0FBA-4C16-81DC-B722CA94C7D7}
// *********************************************************************//
  ICollectServer = interface(IAppServer)
    ['{09AB7282-0FBA-4C16-81DC-B722CA94C7D7}']
    function ProduceFlowNumID(const I_FLOWNAME: WideString; I_SERIESNUM: Integer): Integer; safecall;
    function Get_StartSend: WideString; safecall;
    procedure Set_StartSend(const Value: WideString); safecall;
    function Get_EndSend: WideString; safecall;
    procedure Set_EndSend(const Value: WideString); safecall;
    procedure GetAppSrvIP(var ComputerName: WideString; var IPAddr: WideString); safecall;
    procedure GetFuncs(aZh: OleVariant; var vFuncs: OleVariant); safecall;
    procedure AddUser(Host: OleVariant; IP: OleVariant; UserAlias: OleVariant; ConnTime: OleVariant); safecall;
    procedure DelUser(Host: OleVariant; IP: OleVariant; UserAlias: OleVariant; ConnTime: OleVariant); safecall;
    function GetSysDateTime: TDateTime; safecall;
    function Logined(bAliasName: OleVariant; aPassword: OleVariant; out UserID: OleVariant; 
                     out UserName: OleVariant; out AdminNo: OleVariant; out CityID: OleVariant): OleVariant; safecall;
    function UpdatePassword(const bAliasName: WideString; const aPassword: WideString): OleVariant; safecall;
    function Get_IsAutoWrecker: Integer; safecall;
    procedure Set_IsAutoWrecker(Value: Integer); safecall;
    function SaveWrecker(SourceFlowtache: Integer; TargerFlowtache: Integer; BatchID: Integer; 
                         const deviceid: WideString; const VOperator: WideString; CityID: Integer): Integer; safecall;
    function TransferDataToPutIn(const BID: WideString; const OperatorID: WideString; 
                                 const DelayDay: WideString; const RemindDay: WideString; 
                                 const Reason: WideString; const Code: WideString; 
                                 const phone: WideString; CityID: Integer): OleVariant; safecall;
    function SetAlarmDealWithFlag(const BID: WideString; const Flag: WideString; 
                                  const sFieldName: WideString; CityID: Integer): OleVariant; safecall;
    function TransferDataToStay(const BID: WideString; const OperatorID: WideString; 
                                const DelayDay: WideString; const RemindDay: WideString; 
                                const Reason: WideString; Flowtache: Integer; CityID: Integer): OleVariant; safecall;
    function TransferDataToOnLine(const BID: WideString; const OperatorID: WideString; 
                                  const Reason: WideString; CityID: Integer): OleVariant; safecall;
    function AttachAlarm(BatchID: Integer; SFlowTach: Integer; TFlowTach: Integer; 
                         const VOperator: WideString; CityID: Integer): OleVariant; safecall;
    function RemoveAlarm(BatchID: Integer; const deviceid: WideString; 
                         const VOperator: WideString; const Reason: WideString; CityID: Integer): OleVariant; safecall;
    function GetDeptIdAndAreaID(out DeptID: OleVariant; out AreaID: OleVariant; 
                                var UserID: OleVariant; out ParentID: OleVariant; CityID: Integer; 
                                out iLevel: OleVariant): OleVariant; safecall;
    function ManualSendAlarm(const deviceid: WideString; const UserNo: WideString; 
                             const phone: WideString; CityID: Integer; ifStaySend: Integer): Integer; safecall;
    function RemoveManualAlarm(const deviceid: WideString; CityID: Integer): OleVariant; safecall;
    function Get_Cs_Status: WideString; safecall;
    procedure Set_Cs_Status(const Value: WideString); safecall;
    function Get_Cs_Area: WideString; safecall;
    procedure Set_Cs_Area(const Value: WideString); safecall;
    function Get_Cs_Power: WideString; safecall;
    procedure Set_Cs_Power(const Value: WideString); safecall;
    function SaveSolveMethod(const BID: WideString; const Code: WideString; 
                             const Content: WideString; CityID: Integer): OleVariant; safecall;
    function AlarmManpower(const deviceid: WideString; ContentCode: Integer; 
                           const AlarmNote: WideString; const Provider: WideString; 
                           const Contactphone: WideString; const Remark: WideString; CSID: Integer; 
                           const VOperator: WideString; CityID: Integer): Integer; safecall;
    function StayAlarmReSend(const BID: WideString; const Operator: WideString; Flowtache: Integer; 
                             CityID: Integer): OleVariant; safecall;
    function PutInAndWrecker(BID: Integer; OperatorID: Integer; const deviceid: WideString; 
                             CityID: Integer): OleVariant; safecall;
    function OperateUserInfo(Flag: Integer; var AUser: OleVariant; var FunList: OleVariant): OleVariant; safecall;
    function DeleteUserInfo(UserID: Integer): OleVariant; safecall;
    function OperateDistrictInfo(Flag: Integer; var districtid: Integer; const dname: WideString; 
                                 ParentID: Integer; const Remark: WideString; CurUserID: Integer; 
                                 var AreaList: OleVariant; var CityID: Integer; 
                                 districtlevel: Integer): OleVariant; safecall;
    function DeleteDistrictInfo(districtid: Integer; CityID: Integer): OleVariant; safecall;
    procedure SendRuleSet(kind: Integer; rulevalue: OleVariant; CityID: Integer); safecall;
    function DeleteDeferSendRule(CityID: Integer; rulecode: Integer): OleVariant; safecall;
    function OperatorDeferSendRule(rulecode: Integer; const rulename: WideString; 
                                   const rulecontent: WideString; const Remark: WideString; 
                                   rulekind: Integer; rulelevel: Integer; issend: Integer; 
                                   ruleinterval: Integer; CityID: Integer; ifineffect: Integer; 
                                   const colorid: WideString; Flag: Integer): OleVariant; safecall;
    function AlarmSendToOneStation(CityID: Integer; BatchID: Integer): OleVariant; safecall;
    function OperatorModifyUser(UserID: Integer; const UserNo: WideString; 
                                const UserName: WideString; const phone: WideString; Sex: Integer; 
                                districtid: Integer; Flag: Integer; CityID: Integer; 
                                creator: Integer; const email: WideString; ZONEID: Integer): OleVariant; safecall;
    procedure ControlAppSvr(ControlIdx: Integer); safecall;
    function GetShortMessageData(var MsgData: OleVariant): OleVariant; safecall;
    function GetSMPhone(districtid: Integer; CityID: Integer; var PhoneData: OleVariant): OleVariant; safecall;
    procedure SetShortMessageFlag(BatchID: Integer; CityID: Integer); safecall;
    function AlarmTest_CS(const deviceid: WideString; CityID: Integer; ContentCode: Integer; 
                          testtype: Integer): OleVariant; safecall;
    function CollectServerMsg(EventID: Integer; districtid: Integer; const Msg: WideString): OleVariant; safecall;
    function GetStatDistrict: Integer; safecall;
    property StartSend: WideString read Get_StartSend write Set_StartSend;
    property EndSend: WideString read Get_EndSend write Set_EndSend;
    property IsAutoWrecker: Integer read Get_IsAutoWrecker write Set_IsAutoWrecker;
    property Cs_Status: WideString read Get_Cs_Status write Set_Cs_Status;
    property Cs_Area: WideString read Get_Cs_Area write Set_Cs_Area;
    property Cs_Power: WideString read Get_Cs_Power write Set_Cs_Power;
  end;

// *********************************************************************//
// DispIntf:  ICollectServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {09AB7282-0FBA-4C16-81DC-B722CA94C7D7}
// *********************************************************************//
  ICollectServerDisp = dispinterface
    ['{09AB7282-0FBA-4C16-81DC-B722CA94C7D7}']
    function ProduceFlowNumID(const I_FLOWNAME: WideString; I_SERIESNUM: Integer): Integer; dispid 1;
    property StartSend: WideString dispid 2;
    property EndSend: WideString dispid 3;
    procedure GetAppSrvIP(var ComputerName: WideString; var IPAddr: WideString); dispid 4;
    procedure GetFuncs(aZh: OleVariant; var vFuncs: OleVariant); dispid 6;
    procedure AddUser(Host: OleVariant; IP: OleVariant; UserAlias: OleVariant; ConnTime: OleVariant); dispid 7;
    procedure DelUser(Host: OleVariant; IP: OleVariant; UserAlias: OleVariant; ConnTime: OleVariant); dispid 8;
    function GetSysDateTime: TDateTime; dispid 9;
    function Logined(bAliasName: OleVariant; aPassword: OleVariant; out UserID: OleVariant; 
                     out UserName: OleVariant; out AdminNo: OleVariant; out CityID: OleVariant): OleVariant; dispid 10;
    function UpdatePassword(const bAliasName: WideString; const aPassword: WideString): OleVariant; dispid 11;
    property IsAutoWrecker: Integer dispid 12;
    function SaveWrecker(SourceFlowtache: Integer; TargerFlowtache: Integer; BatchID: Integer; 
                         const deviceid: WideString; const VOperator: WideString; CityID: Integer): Integer; dispid 13;
    function TransferDataToPutIn(const BID: WideString; const OperatorID: WideString; 
                                 const DelayDay: WideString; const RemindDay: WideString; 
                                 const Reason: WideString; const Code: WideString; 
                                 const phone: WideString; CityID: Integer): OleVariant; dispid 14;
    function SetAlarmDealWithFlag(const BID: WideString; const Flag: WideString; 
                                  const sFieldName: WideString; CityID: Integer): OleVariant; dispid 15;
    function TransferDataToStay(const BID: WideString; const OperatorID: WideString; 
                                const DelayDay: WideString; const RemindDay: WideString; 
                                const Reason: WideString; Flowtache: Integer; CityID: Integer): OleVariant; dispid 17;
    function TransferDataToOnLine(const BID: WideString; const OperatorID: WideString; 
                                  const Reason: WideString; CityID: Integer): OleVariant; dispid 18;
    function AttachAlarm(BatchID: Integer; SFlowTach: Integer; TFlowTach: Integer; 
                         const VOperator: WideString; CityID: Integer): OleVariant; dispid 19;
    function RemoveAlarm(BatchID: Integer; const deviceid: WideString; 
                         const VOperator: WideString; const Reason: WideString; CityID: Integer): OleVariant; dispid 20;
    function GetDeptIdAndAreaID(out DeptID: OleVariant; out AreaID: OleVariant; 
                                var UserID: OleVariant; out ParentID: OleVariant; CityID: Integer; 
                                out iLevel: OleVariant): OleVariant; dispid 21;
    function ManualSendAlarm(const deviceid: WideString; const UserNo: WideString; 
                             const phone: WideString; CityID: Integer; ifStaySend: Integer): Integer; dispid 22;
    function RemoveManualAlarm(const deviceid: WideString; CityID: Integer): OleVariant; dispid 23;
    property Cs_Status: WideString dispid 301;
    property Cs_Area: WideString dispid 302;
    property Cs_Power: WideString dispid 303;
    function SaveSolveMethod(const BID: WideString; const Code: WideString; 
                             const Content: WideString; CityID: Integer): OleVariant; dispid 305;
    function AlarmManpower(const deviceid: WideString; ContentCode: Integer; 
                           const AlarmNote: WideString; const Provider: WideString; 
                           const Contactphone: WideString; const Remark: WideString; CSID: Integer; 
                           const VOperator: WideString; CityID: Integer): Integer; dispid 307;
    function StayAlarmReSend(const BID: WideString; const Operator: WideString; Flowtache: Integer; 
                             CityID: Integer): OleVariant; dispid 308;
    function PutInAndWrecker(BID: Integer; OperatorID: Integer; const deviceid: WideString; 
                             CityID: Integer): OleVariant; dispid 24;
    function OperateUserInfo(Flag: Integer; var AUser: OleVariant; var FunList: OleVariant): OleVariant; dispid 26;
    function DeleteUserInfo(UserID: Integer): OleVariant; dispid 27;
    function OperateDistrictInfo(Flag: Integer; var districtid: Integer; const dname: WideString; 
                                 ParentID: Integer; const Remark: WideString; CurUserID: Integer; 
                                 var AreaList: OleVariant; var CityID: Integer; 
                                 districtlevel: Integer): OleVariant; dispid 28;
    function DeleteDistrictInfo(districtid: Integer; CityID: Integer): OleVariant; dispid 29;
    procedure SendRuleSet(kind: Integer; rulevalue: OleVariant; CityID: Integer); dispid 30;
    function DeleteDeferSendRule(CityID: Integer; rulecode: Integer): OleVariant; dispid 31;
    function OperatorDeferSendRule(rulecode: Integer; const rulename: WideString; 
                                   const rulecontent: WideString; const Remark: WideString; 
                                   rulekind: Integer; rulelevel: Integer; issend: Integer; 
                                   ruleinterval: Integer; CityID: Integer; ifineffect: Integer; 
                                   const colorid: WideString; Flag: Integer): OleVariant; dispid 32;
    function AlarmSendToOneStation(CityID: Integer; BatchID: Integer): OleVariant; dispid 33;
    function OperatorModifyUser(UserID: Integer; const UserNo: WideString; 
                                const UserName: WideString; const phone: WideString; Sex: Integer; 
                                districtid: Integer; Flag: Integer; CityID: Integer; 
                                creator: Integer; const email: WideString; ZONEID: Integer): OleVariant; dispid 34;
    procedure ControlAppSvr(ControlIdx: Integer); dispid 304;
    function GetShortMessageData(var MsgData: OleVariant): OleVariant; dispid 40;
    function GetSMPhone(districtid: Integer; CityID: Integer; var PhoneData: OleVariant): OleVariant; dispid 41;
    procedure SetShortMessageFlag(BatchID: Integer; CityID: Integer); dispid 42;
    function AlarmTest_CS(const deviceid: WideString; CityID: Integer; ContentCode: Integer; 
                          testtype: Integer): OleVariant; dispid 43;
    function CollectServerMsg(EventID: Integer; districtid: Integer; const Msg: WideString): OleVariant; dispid 306;
    function GetStatDistrict: Integer; dispid 309;
    function AS_ApplyUpdates(const ProviderName: WideString; Delta: OleVariant; MaxErrors: Integer; 
                             out ErrorCount: Integer; var OwnerData: OleVariant): OleVariant; dispid 20000000;
    function AS_GetRecords(const ProviderName: WideString; Count: Integer; out RecsOut: Integer; 
                           Options: Integer; const CommandText: WideString; var Params: OleVariant; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000001;
    function AS_DataRequest(const ProviderName: WideString; Data: OleVariant): OleVariant; dispid 20000002;
    function AS_GetProviderNames: OleVariant; dispid 20000003;
    function AS_GetParams(const ProviderName: WideString; var OwnerData: OleVariant): OleVariant; dispid 20000004;
    function AS_RowRequest(const ProviderName: WideString; Row: OleVariant; RequestType: Integer; 
                           var OwnerData: OleVariant): OleVariant; dispid 20000005;
    procedure AS_Execute(const ProviderName: WideString; const CommandText: WideString; 
                         var Params: OleVariant; var OwnerData: OleVariant); dispid 20000006;
  end;

// *********************************************************************//
// The Class CoCollectServer provides a Create and CreateRemote method to          
// create instances of the default interface ICollectServer exposed by              
// the CoClass CollectServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCollectServer = class
    class function Create: ICollectServer;
    class function CreateRemote(const MachineName: string): ICollectServer;
  end;

// *********************************************************************//
// The Class Copooler provides a Create and CreateRemote method to          
// create instances of the default interface ICollectServer exposed by              
// the CoClass pooler. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  Copooler = class
    class function Create: ICollectServer;
    class function CreateRemote(const MachineName: string): ICollectServer;
  end;

implementation

uses ComObj;

class function CoCollectServer.Create: ICollectServer;
begin
  Result := CreateComObject(CLASS_CollectServer) as ICollectServer;
end;

class function CoCollectServer.CreateRemote(const MachineName: string): ICollectServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CollectServer) as ICollectServer;
end;

class function Copooler.Create: ICollectServer;
begin
  Result := CreateComObject(CLASS_pooler) as ICollectServer;
end;

class function Copooler.CreateRemote(const MachineName: string): ICollectServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_pooler) as ICollectServer;
end;

end.
