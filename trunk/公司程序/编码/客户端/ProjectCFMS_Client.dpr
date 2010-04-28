program ProjectCFMS_Client;

uses
  Forms,
  windows,
  sysutils,
  controls,
  UnitMainClient in 'UnitMainClient.pas' {FormMainClient},
  UnitDataModuleLocal in '����ļ�\UnitDataModuleLocal.pas' {DataModuleLocal: TDataModule},
  UnitDllMgr in '����ļ�\UnitDllMgr.pas',
  UnitLogin in '����ļ�\UnitLogin.pas' {FormLogin},
  UnitServerSet in '����ļ�\UnitServerSet.pas' {FormServerSet},
  ProjectCFMS_Server_TLB in '..\�����\ProjectCFMS_Server_TLB.pas',
  UnitFormCommon in '����ļ�\UnitFormCommon.pas',
  UnitVFMSGlobal in '����ļ�\UnitVFMSGlobal.pas',
  UnitDllCommon in '����ļ�\UnitDllCommon.pas',
  PasswordFrmUnit in '����ļ�\PasswordFrmUnit.pas' {PasswordFrm},
  UnitJumpButton in '����ļ�\UnitJumpButton.pas',
  UnitSuspendWnd in '����ļ�\UnitSuspendWnd.pas' {FormSuspendWnd},
  UnitRingPopupWindows in '����ļ�\UnitRingPopupWindows.pas' {FormRingPopupWindows};

{$R *.res}

var
  hMutex:HWND;
  Ret:Integer;
begin
  Application.Initialize;
  Application.Title := 'CDMA�������Ϲ���ϵͳ';
  hMutex:=CreateMutex(nil,False,'CDMA�������Ϲ���ϵͳ');
  Ret:=GetLastError;
  Application.UpdateFormatSettings := False;
  DateSeparator   := '-';                    // ϵͳԭȱʡΪ'-'
  ShortDateFormat := 'yyyy-mm-dd';           //�����ڸ�ʽ
  ShortTimeFormat := 'hh:mm:ss';             //�����ڸ�ʽ
  {if Ret=ERROR_ALREADY_EXISTS then
  begin
    application.Terminate;
    ReleaseMutex(hMutex);
    exit;
  end;}
  Application.CreateForm(TDataModuleLocal, DataModuleLocal);
  Application.CreateForm(TFormMainClient, FormMainClient);
  Application.Run;
end.
