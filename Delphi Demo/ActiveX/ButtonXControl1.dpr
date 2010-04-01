library ButtonXControl1;

uses
  ComServ,
  ButtonXControl1_TLB in 'ButtonXControl1_TLB.pas',
  ButtonImpl1 in 'ButtonImpl1.pas' {ButtonX: CoClass},
  About1 in 'About1.pas' {ButtonXAbout};

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
