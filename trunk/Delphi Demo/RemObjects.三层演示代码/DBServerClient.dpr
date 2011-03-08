program DBServerClient;

uses
  uROComInit,
  Forms,
  fClientForm in 'fClientForm.pas' {ClientForm},
  OracleAccessLib_Async in 'OracleAccessLib_Async.pas',
  OracleAccessLib_Intf in 'OracleAccessLib_Intf.pas',
  OracleAccessLib_Invk in 'OracleAccessLib_Invk.pas',
  OracleAccessService_Impl in 'OracleAccessService_Impl.pas' {OracleAccessService: TRORemoteDataModule},
  uVCLADOLib in 'uVCLADOLib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
