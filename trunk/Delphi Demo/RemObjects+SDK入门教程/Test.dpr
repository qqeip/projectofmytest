program Test;

{#ROGEN:TestLibrary.rodl} // RemObjects: Careful, do not remove!

uses
  uROComInit,
  Forms,
  fServerForm in 'fServerForm.pas' {ServerForm},
  TestLibrary_Intf in 'TestLibrary_Intf.pas',
  TestLibrary_Invk in 'TestLibrary_Invk.pas',
  TestService_Impl in 'TestService_Impl.pas' {TestService: TRORemoteDataModule};

{$R *.res}
{$R RODLFile.res}

begin
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
