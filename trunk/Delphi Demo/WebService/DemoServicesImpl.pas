{ Invokable implementation File for TDemoServices which implements IDemoServices }

unit DemoServicesImpl;

interface

uses InvokeRegistry, Types, XSBuiltIns, DemoServicesIntf;

type

  { TDemoServices }
  TDemoServices = class(TInvokableClass, IDemoServices)
  public
    function GetStr(lStr: String):String;stdcall;
    function GetUser(lStr: string):TUser; stdcall;
  end;

implementation

{ TDemoServices }

function TDemoServices.GetStr(lStr: String): String;
begin
  Result := 'Test ' + lStr;
end;

function TDemoServices.GetUser(lStr: string): TUser;
begin       
  Result := TUser.Create;
  Result.ID := 106576326;
  Result.Name := '≤‚ ‘QQ' + lStr;
  Result.Age := 75;
end;

initialization
  { Invokable classes must be registered }
  InvRegistry.RegisterInvokableClass(TDemoServices);
end.
 