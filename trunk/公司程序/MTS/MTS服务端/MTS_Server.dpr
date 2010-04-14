program MTS_Server;

uses
  Forms,
  windows,
  sysutils,
  Ut_MTS_Main in 'Ut_MTS_Main.pas' {Fm_MTS_Server},
  pooler in 'pooler.pas',
  Ut_ComponentFactory in 'Ut_ComponentFactory.pas',
  untExecutesql in 'untExecutesql.pas',
  untOpenSql in 'untOpenSql.pas',
  Ut_SqlDeclare_Define in 'Ut_SqlDeclare_Define.pas',
  Ut_LDM_MTS in 'Ut_LDM_MTS.pas' {LDM_MTS: TDataModule},
  MTS_Server_TLB in 'MTS_Server_TLB.pas',
  Ut_RDM_MTS in 'Ut_RDM_MTS.pas' {RDM_MTS: TRemoteDataModule} {RDM_MTS: CoClass},
  Ut_ServerSet in 'Ut_ServerSet.pas' {Fm_ServerSet},
  md5 in 'md5.pas',
  Ut_Global in 'Ut_Global.pas';

{$R *.TLB}

{$R *.res}
var
  hMutex:HWND;
  Ret:Integer;
begin
  Application.Initialize;
  Application.Title := '���ڷֲ��Զ���ز���Ӧ��';
  hMutex:=CreateMutex(nil,False,'���ڷֲ��Զ���ز���Ӧ��');
  Ret:=GetLastError;
  Application.UpdateFormatSettings := False;
  DateSeparator   := '-';                    //ϵͳԭȱʡΪ'-'
  ShortDateFormat := 'yyyy-mm-dd';           //�����ڸ�ʽ
  ShortTimeFormat := 'hh:nn:ss';             //�����ڸ�ʽ
  if Ret=ERROR_ALREADY_EXISTS then
  begin
    application.Terminate;
    ReleaseMutex(hMutex);
    EXIT;
  END;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLDM_MTS, LDM_MTS);
  Application.CreateForm(TFm_MTS_Server, Fm_MTS_Server);
  if LDM_MTS.Action_FirstLoginInit then
  begin
    Application.CreateForm(TFm_MTS_Server, Fm_MTS_Server);
    Application.Run;
  end
  else
    Application.Terminate;
end.
