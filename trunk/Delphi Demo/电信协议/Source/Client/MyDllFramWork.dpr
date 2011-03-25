program MyDllFramWork;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitDllMgr in 'Common\UnitDllMgr.pas',
  UnitLogIn in 'Login\UnitLogIn.pas' {FormLogin},
  UnitDataModuleLocal in 'Common\UnitDataModuleLocal.pas' {DMLocal: TDataModule},
  MyServer_TLB in '..\Server\MyServer_TLB.pas',
  UnitCommon in 'Common\UnitCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDMLocal, DMLocal);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
