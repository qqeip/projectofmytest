program ERPMODEL;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {MainForm},
  UnitRemoteLibary in 'Common\UnitRemoteLibary.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
