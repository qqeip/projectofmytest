program OracleExpPlan;

uses
  Forms,
  UnitOracleExpPlan in 'UnitOracleExpPlan.pas' {FormMain},
  UnitConfigDB in 'UnitConfigDB.pas' {FormConfigDB},
  USetPlan in 'USetPlan.pas' {FormSetPlan},
  UnitPublic in 'UnitPublic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormConfigDB, FormConfigDB);
  Application.CreateForm(TFormSetPlan, FormSetPlan);
  Application.Run;
end.
