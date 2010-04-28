unit ProjectCFMS_Server_TLB;

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
// File generated on 2010-1-8 11:15:45 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Shared\·þÎñ¶Ë\ProjectCFMS_Server.tlb (1)
// LIBID: {4147C3D9-0BD5-4D80-B855-88D8CFF13CAA}
// LCID: 0
// Helpfile: 
// HelpString: ProjectCFMS_Server Library
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
  ProjectCFMS_ServerMajorVersion = 1;
  ProjectCFMS_ServerMinorVersion = 0;

  LIBID_ProjectCFMS_Server: TGUID = '{4147C3D9-0BD5-4D80-B855-88D8CFF13CAA}';

  IID_IDataModuleRemote: TGUID = '{97C65F7A-A2C8-4B19-B31C-F616D272DD2F}';
  CLASS_DataModuleRemote: TGUID = '{AF4C6EA0-E6B8-43C4-A5F4-27B656042ECD}';
  IID_Interface1: TGUID = '{1A4C1BEF-2B79-414D-A668-58A0043BA0F8}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDataModuleRemote = interface;
  IDataModuleRemoteDisp = dispinterface;
  Interface1 = interface;
  Interface1Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DataModuleRemote = IDataModuleRemote;


// *********************************************************************//
// Interface: IDataModuleRemote
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {97C65F7A-A2C8-4B19-B31C-F616D272DD2F}
// *********************************************************************//
  IDataModuleRemote = interface(IAppServer)
    ['{97C65F7A-A2C8-4B19-B31C-F616D272DD2F}']
    function GetSequence(const aSeqName: WideString): Integer; safecall;
    function ChangePassword(const aUserNo: WideString; aCityid: Integer; const aOldPSW: WideString; 
                            const aNewPSW: WideString): OleVariant; safecall;
    function GetCDSData(aOwnerData: OleVariant; aDSPID: Integer): OleVariant; safecall;
    function CDSApplyUpdates(var aDetailArray: OleVariant; aProviderArray: OleVariant; 
                             aOwnerData: OleVariant): OleVariant; safecall;
    function ExecBatchSQL(aOwnerData: OleVariant): OleVariant; safecall;
    function Login(const aUserNo: WideString; const aPassword: WideString; out aUserid: Integer; 
                   out aCityid: Integer; out aCompanyid: Integer; out aCompanyidstr: WideString; 
                   out aManagePrive: Integer): Integer; safecall;
    function AddUser(const aUserNo: WideString; const aIP: WideString): Integer; safecall;
    function DelUser(const aUserNo: WideString; const aIP: WideString): Integer; safecall;
    function GetSystemDateTime: TDateTime; safecall;
    function GetMD5(const aUserNo: WideString; const aPSW: WideString): WideString; safecall;
    function CancelClearFault(aCityid: Integer; aCompanyid: Integer; aBatchid: Integer; 
                              aOperator: Integer; const aReason: WideString): Integer; safecall;
    function RemoveFault(VCityID: Integer; VCompanyID: Integer; PBatchID: Integer; 
                         VOperator: Integer; const VAlarmIDS: WideString): Integer; safecall;
    function DeleteFault(VCityID: Integer; VCompanyID: Integer; PBatchID: Integer; 
                         VOperator: Integer; const VAlarmIDS: WideString; const VReason: WideString): Integer; safecall;
    function SubmitFault(VCityID: Integer; VCompanyID: Integer; VBatchid: Integer; 
                         VOperator: Integer; VCauseCode: Integer; VResolventCode: Integer; 
                         const VRevertCause: WideString): Integer; safecall;
    function ClearFault(VCityID: Integer; VCompanyID: Integer; VBatchid: Integer; VOperator: Integer): Integer; safecall;
    function ReturnFault(VCityID: Integer; VCompanyID: Integer; 
                         const VReturnCompanyIDS: WideString; PBatchID: Integer; 
                         const VAlarmIDS: WideString; VIsDel: WordBool; 
                         const VReturnMark: WideString; VOperator: Integer): Integer; safecall;
    function StayFault(VCityID: Integer; VCompanyID: Integer; VBatchid: Integer; 
                       const VStayCause: WideString; VStayIntever: Integer; VStayRemind: Integer; 
                       VOperator: Integer): Integer; safecall;
    function DeviceLostResend(VCityID: Integer; const VDeviceids: WideString): Integer; safecall;
    function DeviceGatherSet(VCityID: Integer; VDevGatherID: Integer; VDeviceid: Integer): Integer; safecall;
    function StayResendFault(VCityID: Integer; VCompanyID: Integer; VBatchid: Integer; 
                             VOperator: Integer): Integer; safecall;
    function ContinueSendFault(VCityID: Integer; const VCompanyIDS: WideString; VDeviceid: Integer; 
                               VCoDeviceID: Integer; VAlarmContentCode: Integer; 
                               const VReason: WideString; VOperator: Integer): Integer; safecall;
    function AlarmProc(aCityid: Integer; aCompanyid: Integer; aBatchid: Integer; 
                       aOperateFlag: Integer; const aAlarmids: WideString; aOperator: Integer): Integer; safecall;
    function AlarmProcs(aCityid: Integer; aCompanyid: Integer; const aBatchids: WideString; 
                        aOperateFlag: Integer; const aAlarmids: WideString; aOperator: Integer): Integer; safecall;
    function MaunalSendFault(VCityID: Integer; VCompanyID: Integer; VDeviceid: Integer; 
                             VCoDeviceID: Integer; VAlarmContentCode: Integer; 
                             const VRemark: WideString; VOperator: Integer; 
                             VIsGotoAlarmManual: Integer; VRepeatCoDevice: Integer; 
                             VRepeatContentCode: Integer): Integer; safecall;
    function GetFlowNum(const aFlowName: WideString; aFlowCount: Integer): OleVariant; safecall;
    function CompanyMgr(VCityID: Integer; VCompanyID: Integer; const VGatherIDStr: WideString; 
                        const vAlarmCodeStr: WideString; VOperator: Integer; vSqlVariant: OleVariant): Integer; safecall;
    function AlarmQueryStatus(VCityID: Integer; VDeviceid: Integer; VCoDeviceID: Integer; 
                              VAlarmContentCode: Integer; VOperator: Integer): Integer; safecall;
    function GetRingRemind(aCityid: Integer; aUserid: Integer; aRemindtype: Integer; 
                           out vIsRing: Integer; out vWavName: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDataModuleRemoteDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {97C65F7A-A2C8-4B19-B31C-F616D272DD2F}
// *********************************************************************//
  IDataModuleRemoteDisp = dispinterface
    ['{97C65F7A-A2C8-4B19-B31C-F616D272DD2F}']
    function GetSequence(const aSeqName: WideString): Integer; dispid 301;
    function ChangePassword(const aUserNo: WideString; aCityid: Integer; const aOldPSW: WideString; 
                            const aNewPSW: WideString): OleVariant; dispid 302;
    function GetCDSData(aOwnerData: OleVariant; aDSPID: Integer): OleVariant; dispid 303;
    function CDSApplyUpdates(var aDetailArray: OleVariant; aProviderArray: OleVariant; 
                             aOwnerData: OleVariant): OleVariant; dispid 304;
    function ExecBatchSQL(aOwnerData: OleVariant): OleVariant; dispid 305;
    function Login(const aUserNo: WideString; const aPassword: WideString; out aUserid: Integer; 
                   out aCityid: Integer; out aCompanyid: Integer; out aCompanyidstr: WideString; 
                   out aManagePrive: Integer): Integer; dispid 306;
    function AddUser(const aUserNo: WideString; const aIP: WideString): Integer; dispid 307;
    function DelUser(const aUserNo: WideString; const aIP: WideString): Integer; dispid 308;
    function GetSystemDateTime: TDateTime; dispid 309;
    function GetMD5(const aUserNo: WideString; const aPSW: WideString): WideString; dispid 310;
    function CancelClearFault(aCityid: Integer; aCompanyid: Integer; aBatchid: Integer; 
                              aOperator: Integer; const aReason: WideString): Integer; dispid 311;
    function RemoveFault(VCityID: Integer; VCompanyID: Integer; PBatchID: Integer; 
                         VOperator: Integer; const VAlarmIDS: WideString): Integer; dispid 312;
    function DeleteFault(VCityID: Integer; VCompanyID: Integer; PBatchID: Integer; 
                         VOperator: Integer; const VAlarmIDS: WideString; const VReason: WideString): Integer; dispid 313;
    function SubmitFault(VCityID: Integer; VCompanyID: Integer; VBatchid: Integer; 
                         VOperator: Integer; VCauseCode: Integer; VResolventCode: Integer; 
                         const VRevertCause: WideString): Integer; dispid 314;
    function ClearFault(VCityID: Integer; VCompanyID: Integer; VBatchid: Integer; VOperator: Integer): Integer; dispid 315;
    function ReturnFault(VCityID: Integer; VCompanyID: Integer; 
                         const VReturnCompanyIDS: WideString; PBatchID: Integer; 
                         const VAlarmIDS: WideString; VIsDel: WordBool; 
                         const VReturnMark: WideString; VOperator: Integer): Integer; dispid 316;
    function StayFault(VCityID: Integer; VCompanyID: Integer; VBatchid: Integer; 
                       const VStayCause: WideString; VStayIntever: Integer; VStayRemind: Integer; 
                       VOperator: Integer): Integer; dispid 317;
    function DeviceLostResend(VCityID: Integer; const VDeviceids: WideString): Integer; dispid 318;
    function DeviceGatherSet(VCityID: Integer; VDevGatherID: Integer; VDeviceid: Integer): Integer; dispid 319;
    function StayResendFault(VCityID: Integer; VCompanyID: Integer; VBatchid: Integer; 
                             VOperator: Integer): Integer; dispid 320;
    function ContinueSendFault(VCityID: Integer; const VCompanyIDS: WideString; VDeviceid: Integer; 
                               VCoDeviceID: Integer; VAlarmContentCode: Integer; 
                               const VReason: WideString; VOperator: Integer): Integer; dispid 321;
    function AlarmProc(aCityid: Integer; aCompanyid: Integer; aBatchid: Integer; 
                       aOperateFlag: Integer; const aAlarmids: WideString; aOperator: Integer): Integer; dispid 322;
    function AlarmProcs(aCityid: Integer; aCompanyid: Integer; const aBatchids: WideString; 
                        aOperateFlag: Integer; const aAlarmids: WideString; aOperator: Integer): Integer; dispid 323;
    function MaunalSendFault(VCityID: Integer; VCompanyID: Integer; VDeviceid: Integer; 
                             VCoDeviceID: Integer; VAlarmContentCode: Integer; 
                             const VRemark: WideString; VOperator: Integer; 
                             VIsGotoAlarmManual: Integer; VRepeatCoDevice: Integer; 
                             VRepeatContentCode: Integer): Integer; dispid 324;
    function GetFlowNum(const aFlowName: WideString; aFlowCount: Integer): OleVariant; dispid 325;
    function CompanyMgr(VCityID: Integer; VCompanyID: Integer; const VGatherIDStr: WideString; 
                        const vAlarmCodeStr: WideString; VOperator: Integer; vSqlVariant: OleVariant): Integer; dispid 326;
    function AlarmQueryStatus(VCityID: Integer; VDeviceid: Integer; VCoDeviceID: Integer; 
                              VAlarmContentCode: Integer; VOperator: Integer): Integer; dispid 327;
    function GetRingRemind(aCityid: Integer; aUserid: Integer; aRemindtype: Integer; 
                           out vIsRing: Integer; out vWavName: WideString): Integer; dispid 328;
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
// Interface: Interface1
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1A4C1BEF-2B79-414D-A668-58A0043BA0F8}
// *********************************************************************//
  Interface1 = interface(IDispatch)
    ['{1A4C1BEF-2B79-414D-A668-58A0043BA0F8}']
  end;

// *********************************************************************//
// DispIntf:  Interface1Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1A4C1BEF-2B79-414D-A668-58A0043BA0F8}
// *********************************************************************//
  Interface1Disp = dispinterface
    ['{1A4C1BEF-2B79-414D-A668-58A0043BA0F8}']
  end;

// *********************************************************************//
// The Class CoDataModuleRemote provides a Create and CreateRemote method to          
// create instances of the default interface IDataModuleRemote exposed by              
// the CoClass DataModuleRemote. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDataModuleRemote = class
    class function Create: IDataModuleRemote;
    class function CreateRemote(const MachineName: string): IDataModuleRemote;
  end;

implementation

uses ComObj;

class function CoDataModuleRemote.Create: IDataModuleRemote;
begin
  Result := CreateComObject(CLASS_DataModuleRemote) as IDataModuleRemote;
end;

class function CoDataModuleRemote.CreateRemote(const MachineName: string): IDataModuleRemote;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DataModuleRemote) as IDataModuleRemote;
end;

end.
