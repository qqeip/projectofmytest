program StockpileSystem;

uses
  Forms,
  Windows,
  UnitSystemServer,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitResource in '..\Common\UnitResource.pas',
  UnitLogIn in '..\Login\UnitLogIn.pas' {FormLogIn},
  UnitPublicResourceManager in '..\Common\UnitPublicResourceManager.pas',
  UnitDataModule in '..\Common\UnitDataModule.pas' {DM: TDataModule},
  UnitAbout in 'View\UnitAbout.pas' {FormAbout},
  UnitUserManager in '..\Common\UnitUserManager.pas',
  UnitDepotInfoMgr in 'BasicInfoMgr\UnitDepotInfoMgr.pas' {FormDepotInfoMgr},
  UnitPublic in '..\Common\UnitPublic.pas',
  UnitAssociatorTypeMgr in 'BasicInfoMgr\UnitAssociatorTypeMgr.pas' {FormAssociatorTypeMgr},
  UnitProviderMgr in 'BasicInfoMgr\UnitProviderMgr.pas' {FormProviderMgr},
  UnitCustomerMgr in 'BasicInfoMgr\UnitCustomerMgr.pas' {FormCustomerMgr},
  UnitGoodsMgr in 'BasicInfoMgr\UnitGoodsMgr.pas' {FormGoodsMgr},
  UnitInDepotTypeMgr in 'BasicInfoMgr\UnitInDepotTypeMgr.pas' {FormInDepotTypeMgr},
  UnitOutDepotTypeMgr in 'BasicInfoMgr\UnitOutDepotTypeMgr.pas' {FormOutDepotTypeMgr};

{$R *.res}
var
  sTitle: string;
  Exist: DWORD;
begin
  Application.Initialize;
  TSystemServer.getInstance.StartUp;
  try
    FormMain.CreateODBC;
    sTitle:= sSystemTitle;
    CreateMuteX(nil,True,PChar(sTitle));
    Exist:=GetLastError;
    If   Exist=ERROR_ALREADY_EXISTS   then   begin
        Application.MessageBox(PChar(sRepeatLogInSystem),'提示信息',MB_OK+MB_ICONINFORMATION);
        Application.Terminate;
    end;
    initAllScreenAndFormResources;
    Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
  finally
    try
      TSystemServer.getInstance.ShutDown;
      freeAllScreenAndFormResources;
    except
    end;
  end;
end.
