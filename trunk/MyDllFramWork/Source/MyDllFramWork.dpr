program MyDllFramWork;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitDllMgr in 'Common\UnitDllMgr.pas',
  UnitLogIn in 'Login\UnitLogIn.pas' {FormLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.Run;
end.
