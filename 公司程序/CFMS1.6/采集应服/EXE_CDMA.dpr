program EXE_CDMA;

uses
  Forms, SysUtils,
  Unt_EXE_Main in 'Unt_EXE_Main.pas' {FrmMain},
  UntBaseDBThread in 'UntBaseDBThread.pas',
  Unt_EXE_CDMACollecctThread in 'Unt_EXE_CDMACollecctThread.pas';

var
  strCon, sIsDebug: string;

{$R *.res}  

begin
  strCon := trim(ParamStr(1));

  if strCon<>'' then
  begin
    Application.Initialize;

    sIsDebug := trim(ParamStr(3));
    if sIsDebug='0' then Application.ShowMainForm := false;
    Application.Title := 'CFMS²É¼¯³ÌÐò';
    Application.CreateForm(TFrmMain, FrmMain);
    Application.Run;   
  end;
end.
