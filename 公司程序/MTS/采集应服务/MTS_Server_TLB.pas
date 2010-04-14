unit MTS_Server_TLB;

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

// $Rev: 8291 $
// File generated on 2008-3-21 14:23:06 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Project\MTS\03_±àÂë\MTS1.0\MTS·þÎñ¶Ë\MTS_Server.tlb (1)
// LIBID: {6FD32256-0AE2-4CDE-A113-89CFBCD961EC}
// LCID: 0
// Helpfile: 
// HelpString: MTS_Server Library
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
  MTS_ServerMajorVersion = 1;
  MTS_ServerMinorVersion = 0;

  LIBID_MTS_Server: TGUID = '{6FD32256-0AE2-4CDE-A113-89CFBCD961EC}';

  IID_IRDM_MTS: TGUID = '{B67D3F7E-C347-49E5-B285-ED80CAE18C2D}';
  CLASS_RDM_MTS: TGUID = '{80D76DB8-03D2-4B73-993C-C3685201EFDC}';
  CLASS_pool: TGUID = '{35087797-B3F9-480B-B876-084901E91420}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRDM_MTS = interface;
  IRDM_MTSDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RDM_MTS = IRDM_MTS;
  pool = IRDM_MTS;


// *********************************************************************//
// Interface: IRDM_MTS
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B67D3F7E-C347-49E5-B285-ED80CAE18C2D}
// *********************************************************************//
  IRDM_MTS = interface(IAppServer)
    ['{B67D3F7E-C347-49E5-B285-ED80CAE18C2D}']
    function GetPriv(userid: Integer): OleVariant; safecall;
    function CDSApplyUpdates(var vDetailArray: OleVariant; vProviderArray: OleVariant; 
                             OwnerData: OleVariant): OleVariant; safecall;
    function GetCDSData(OwnerData: OleVariant; DspId: Integer): OleVariant; safecall;
    function LogIn(const UserNo: WideString; const password: WideString; out userid: OleVariant): OleVariant; safecall;
    function ExecBatchSQL(OwnerData: OleVariant): OleVariant; safecall;
    function ProduceFlowNumID(const l_FLowName: WideString; l_SeriesNum: Integer): Integer; safecall;
    function CollectServerMsg(EventId: Integer; Cityid: Integer; const Msg: WideString): OleVariant; safecall;
  end;

// *********************************************************************//
// DispIntf:  IRDM_MTSDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B67D3F7E-C347-49E5-B285-ED80CAE18C2D}
// *********************************************************************//
  IRDM_MTSDisp = dispinterface
    ['{B67D3F7E-C347-49E5-B285-ED80CAE18C2D}']
    function GetPriv(userid: Integer): OleVariant; dispid 301;
    function CDSApplyUpdates(var vDetailArray: OleVariant; vProviderArray: OleVariant; 
                             OwnerData: OleVariant): OleVariant; dispid 302;
    function GetCDSData(OwnerData: OleVariant; DspId: Integer): OleVariant; dispid 303;
    function LogIn(const UserNo: WideString; const password: WideString; out userid: OleVariant): OleVariant; dispid 304;
    function ExecBatchSQL(OwnerData: OleVariant): OleVariant; dispid 305;
    function ProduceFlowNumID(const l_FLowName: WideString; l_SeriesNum: Integer): Integer; dispid 306;
    function CollectServerMsg(EventId: Integer; Cityid: Integer; const Msg: WideString): OleVariant; dispid 307;
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
// The Class CoRDM_MTS provides a Create and CreateRemote method to          
// create instances of the default interface IRDM_MTS exposed by              
// the CoClass RDM_MTS. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRDM_MTS = class
    class function Create: IRDM_MTS;
    class function CreateRemote(const MachineName: string): IRDM_MTS;
  end;

// *********************************************************************//
// The Class Copool provides a Create and CreateRemote method to          
// create instances of the default interface IRDM_MTS exposed by              
// the CoClass pool. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  Copool = class
    class function Create: IRDM_MTS;
    class function CreateRemote(const MachineName: string): IRDM_MTS;
  end;

implementation

uses ComObj;

class function CoRDM_MTS.Create: IRDM_MTS;
begin
  Result := CreateComObject(CLASS_RDM_MTS) as IRDM_MTS;
end;

class function CoRDM_MTS.CreateRemote(const MachineName: string): IRDM_MTS;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RDM_MTS) as IRDM_MTS;
end;

class function Copool.Create: IRDM_MTS;
begin
  Result := CreateComObject(CLASS_pool) as IRDM_MTS;
end;

class function Copool.CreateRemote(const MachineName: string): IRDM_MTS;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_pool) as IRDM_MTS;
end;

end.
