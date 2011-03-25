unit MyServer_TLB;

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
// File generated on 2011-03-25 17:27:36 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Documents and Settings\1\桌面\Delphi demo\电信协议\Source\Server\MyServer.tlb (1)
// LIBID: {C0A87A26-57A7-40BE-BC3A-F6BBCA67CD62}
// LCID: 0
// Helpfile: 
// HelpString: MyServer Library
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
  MyServerMajorVersion = 1;
  MyServerMinorVersion = 0;

  LIBID_MyServer: TGUID = '{C0A87A26-57A7-40BE-BC3A-F6BBCA67CD62}';

  IID_IDataModuleRemote: TGUID = '{AD2D3C28-6D5A-4144-A125-75F9CDAFE3FB}';
  CLASS_DataModuleRemote: TGUID = '{574DD770-5701-43A1-BB39-DE9A1DB24635}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDataModuleRemote = interface;
  IDataModuleRemoteDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DataModuleRemote = IDataModuleRemote;


// *********************************************************************//
// Interface: IDataModuleRemote
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AD2D3C28-6D5A-4144-A125-75F9CDAFE3FB}
// *********************************************************************//
  IDataModuleRemote = interface(IAppServer)
    ['{AD2D3C28-6D5A-4144-A125-75F9CDAFE3FB}']
    function GetCDSData(aVariant: OleVariant): OleVariant; safecall;
  end;

// *********************************************************************//
// DispIntf:  IDataModuleRemoteDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AD2D3C28-6D5A-4144-A125-75F9CDAFE3FB}
// *********************************************************************//
  IDataModuleRemoteDisp = dispinterface
    ['{AD2D3C28-6D5A-4144-A125-75F9CDAFE3FB}']
    function GetCDSData(aVariant: OleVariant): OleVariant; dispid 301;
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
