// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://localhost/project1.exe/wsdl/IDemoServices
// Encoding : utf-8
// Version  : 1.0
// (2009-10-29 10:57:05 - 1.33.2.5)
// ************************************************************************ //

unit IDemoServices1;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:int             - "http://www.w3.org/2001/XMLSchema"
  // !:string          - "http://www.w3.org/2001/XMLSchema"

  TUser                = class;                 { "urn:DemoServicesIntf" }



  // ************************************************************************ //
  // Namespace : urn:DemoServicesIntf
  // ************************************************************************ //
  TUser = class(TRemotable)
  private
    FID: Integer;
    FName: WideString;
    FAge: Integer;
  published
    property ID: Integer read FID write FID;
    property Name: WideString read FName write FName;
    property Age: Integer read FAge write FAge;
  end;


  // ************************************************************************ //
  // Namespace : urn:DemoServicesIntf-IDemoServices
  // soapAction: urn:DemoServicesIntf-IDemoServices#%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : rpc
  // binding   : IDemoServicesbinding
  // service   : IDemoServicesservice
  // port      : IDemoServicesPort
  // URL       : http://localhost/project1.exe/soap/IDemoServices
  // ************************************************************************ //
  IDemoServices = interface(IInvokable)
  ['{B6738F47-B59C-5463-70AB-8B9D24D65318}']
    function  GetStr(const lStr: WideString): WideString; stdcall;
    function  GetUser(const lStr: WideString): TUser; stdcall;
  end;

function GetIDemoServices(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): IDemoServices;


implementation

function GetIDemoServices(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): IDemoServices;
const
  defWSDL = 'http://localhost/project1.exe/wsdl/IDemoServices';
  defURL  = 'http://localhost/project1.exe/soap/IDemoServices';
  defSvc  = 'IDemoServicesservice';
  defPrt  = 'IDemoServicesPort';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as IDemoServices);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  InvRegistry.RegisterInterface(TypeInfo(IDemoServices), 'urn:DemoServicesIntf-IDemoServices', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(IDemoServices), 'urn:DemoServicesIntf-IDemoServices#%operationName%');
  RemClassRegistry.RegisterXSClass(TUser, 'urn:DemoServicesIntf', 'TUser');

end. 