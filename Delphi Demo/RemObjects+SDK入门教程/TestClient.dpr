program TestClient;

uses
  uROComInit,
  Forms,
  fClientForm in 'fClientForm.pas' {ClientForm},
  TestLibrary_Intf in 'TestLibrary_Intf.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
