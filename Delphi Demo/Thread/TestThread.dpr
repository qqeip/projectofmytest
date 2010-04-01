program TestThread;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  uThread in 'uThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
