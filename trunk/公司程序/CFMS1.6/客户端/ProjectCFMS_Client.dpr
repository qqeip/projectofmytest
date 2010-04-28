program ProjectCFMS_Client;

uses
  Forms,
  windows,
  sysutils,
  controls,
  UnitMainClient in 'UnitMainClient.pas' {FormMainClient},
  UnitDataModuleLocal in '框架文件\UnitDataModuleLocal.pas' {DataModuleLocal: TDataModule},
  UnitDllMgr in '框架文件\UnitDllMgr.pas',
  UnitLogin in '框架文件\UnitLogin.pas' {FormLogin},
  UnitServerSet in '框架文件\UnitServerSet.pas' {FormServerSet},
  ProjectCFMS_Server_TLB in '..\服务端\ProjectCFMS_Server_TLB.pas',
  UnitFormCommon in '框架文件\UnitFormCommon.pas',
  UnitVFMSGlobal in '框架文件\UnitVFMSGlobal.pas',
  UnitDllCommon in '框架文件\UnitDllCommon.pas',
  PasswordFrmUnit in '框架文件\PasswordFrmUnit.pas' {PasswordFrm},
  UnitJumpButton in '框架文件\UnitJumpButton.pas',
  UnitSuspendWnd in '框架文件\UnitSuspendWnd.pas' {FormSuspendWnd},
  UnitRingPopupWindows in '框架文件\UnitRingPopupWindows.pas' {FormRingPopupWindows};

{$R *.res}

var
  hMutex:HWND;
  Ret:Integer;
begin
  Application.Initialize;
  Application.Title := 'CDMA派障排障管理系统';
  hMutex:=CreateMutex(nil,False,'CDMA派障排障管理系统');
  Ret:=GetLastError;
  Application.UpdateFormatSettings := False;
  DateSeparator   := '-';                    // 系统原缺省为'-'
  ShortDateFormat := 'yyyy-mm-dd';           //短日期格式
  ShortTimeFormat := 'hh:mm:ss';             //短日期格式
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
