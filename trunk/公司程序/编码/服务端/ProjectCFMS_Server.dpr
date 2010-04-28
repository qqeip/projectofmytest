program ProjectCFMS_Server;

uses
  Forms,
  windows,
  sysutils,
  controls,
  UnitServerMain in 'UnitServerMain.pas' {FormServerMain},
  UnitTCPServer in 'UnitTCPServer.pas',
  UnitCommon in 'UnitCommon.pas',
  UnitDataModuleLocal in 'UnitDataModuleLocal.pas' {DataModuleLocal: TDataModule},
  UnitPatrolAppSrv in 'UnitPatrolAppSrv.pas',
  UnitServerSet in 'UnitServerSet.pas' {FormServerSet},
  UnitComponentFactory in 'UnitComponentFactory.pas',
  ProjectCFMS_Server_TLB in 'ProjectCFMS_Server_TLB.pas',
  UnitDataModuleRemote in 'UnitDataModuleRemote.pas' {DataModuleRemote: TRemoteDataModule} {DataModuleRemote: CoClass};

{$R *.TLB}

{$R *.res}

var
  hMutex:HWND;
  Ret:Integer;
begin
  Application.Initialize;
  Application.Title := '�Զ�����ϵͳӦ��';
  hMutex:=CreateMutex(nil,true,'ProjectCFMS_Server');
  Ret:=GetLastError;
  Application.UpdateFormatSettings := False;
  DateSeparator   := '-';                    //ϵͳԭȱʡΪ'-'
  ShortDateFormat := 'yyyy-mm-dd';           //�����ڸ�ʽ
  ShortTimeFormat := 'hh:nn:ss';             //�����ڸ�ʽ
  if Ret=ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(hMutex);
    Halt;
  end;
  Application.CreateForm(TDataModuleLocal, DataModuleLocal);
  if DataModuleLocal.FirstLoginInit then
  begin
    Application.CreateForm(TFormServerMain, FormServerMain);
    Application.Run;
  end
  else
  begin
    DataModuleLocal.Free;
    Application.Terminate;
  end;
end.
