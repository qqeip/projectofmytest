program MyServer;

uses
  Forms,
  UnitServerMain in 'UnitServerMain.pas' {FormServerMain},
  MyServer_TLB in 'MyServer_TLB.pas',
  UnitDataModuleRemote in 'UnitDataModuleRemote.pas' {DataModuleRemote: TRemoteDataModule} {DataModuleRemote: CoClass},
  UnitDataModuleLocal in 'UnitDataModuleLocal.pas' {DataModuleLocal: TDataModule},
  UnitCommon in 'UnitCommon.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDataModuleLocal, DataModuleLocal);
  Application.CreateForm(TFormServerMain, FormServerMain);
  Application.Run;
end.
