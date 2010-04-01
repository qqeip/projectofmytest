{ Invokable interface IDemoServices }

unit DemoServicesIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type
  TUser = class(TRemotable)
  public
    FID : Integer;
    FName : string;
    FAge : Integer;
    constructor Create; override;
    destructor Destroy; override;
  published
    property ID : Integer read FID write FID;
    property Name : string read FName write FName;
    property Age : Integer read FAge write FAge;
  end;
  { Invokable interfaces must derive from IInvokable }
  IDemoServices = interface(IInvokable)
  ['{C05A386A-22DD-43D8-ACD0-932F8D55EFEF}']

    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
    function GetStr(lStr : String):String;stdcall;
    function GetUser(lStr: string):TUser; stdcall;
  end;

implementation

{ TUser }

constructor TUser.Create;
begin
  inherited;

end;

destructor TUser.Destroy;
begin

  inherited;
end;

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IDemoServices));
end.
