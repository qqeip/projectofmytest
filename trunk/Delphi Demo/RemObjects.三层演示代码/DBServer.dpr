program DBServer;

{#ROGEN:OracleAccessLib.rodl} // RemObjects: Careful, do not remove!

uses
  uROComInit,
  Forms,
  fServerForm in 'fServerForm.pas' {ServerForm},
  OracleAccessLib_Intf in 'OracleAccessLib_Intf.pas',
  OracleAccessLib_Invk in 'OracleAccessLib_Invk.pas',
  OracleAccessService_Impl in 'OracleAccessService_Impl.pas' {OracleAccessService: TRORemoteDataModule},
  ADODB_TLB in 'ADODB_TLB.pas',
  Ado_ConnectionPool in 'Ado_ConnectionPool.pas',
  uADOLib in '..\·þÎñ¶Ë\uADOLib.pas',
  unHook in 'unHook.pas',
  gunFunSys in 'gunFunSys.pas';

{$R *.res}
{$R RODLFile.res}

begin
  Application.Initialize;
  Application.CreateForm(TServerForm, ServerForm);
  Application.Run;
end.
