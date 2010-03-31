unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, WinSkinData, cxGraphics, ImgList, ComCtrls, ToolWin,
  cxControls, dxStatusBar, ExtCtrls, ShellAPI;

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuRepertoryMgr: TMenuItem;
    MenuInDepotMgr: TMenuItem;
    MenuOutDepotMgr: TMenuItem;
    NRepertoryQuery: TMenuItem;
    NRepertoryStat: TMenuItem;
    NInDepotMgr: TMenuItem;
    NInDepotStat: TMenuItem;
    NOutDepotMgr: TMenuItem;
    MenuUserMgr: TMenuItem;
    MenuHelp: TMenuItem;
    NHelp: TMenuItem;
    NAbout: TMenuItem;
    NOutDepotStat: TMenuItem;
    NUserMgr: TMenuItem;
    NUserChangePass: TMenuItem;
    NSystemLock: TMenuItem;
    NLogOut: TMenuItem;
    MenuInformationMgr: TMenuItem;
    NDepotInfoMgr: TMenuItem;
    NAssociatorTypeInfoMgr: TMenuItem;
    NProviderInfoMgr: TMenuItem;
    NCustomerInfoMgr: TMenuItem;
    NGoodsTypeInfoMgr: TMenuItem;
    NInDepotTypeMgr: TMenuItem;
    NOutDepotTypeMgr: TMenuItem;
    SystemStatusBar: TdxStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    Panel1: TPanel;
    ToolButton3: TToolButton;
    ToolBtnExit: TToolButton;
    MenuDataAnalyse: TMenuItem;
    NCustomAnalyse: TMenuItem;
    NBalanceAnalyse: TMenuItem;
    NRepertoryAnalyse: TMenuItem;
    SkinData: TSkinData;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ToolBtnExitClick(Sender: TObject);
    procedure NAboutClick(Sender: TObject);
    procedure NHelpClick(Sender: TObject);
    procedure NDepotInfoMgrClick(Sender: TObject);
    procedure NAssociatorTypeInfoMgrClick(Sender: TObject);
    procedure NProviderInfoMgrClick(Sender: TObject);
    procedure NCustomerInfoMgrClick(Sender: TObject);
    procedure NGoodsTypeInfoMgrClick(Sender: TObject);
    procedure NInDepotTypeMgrClick(Sender: TObject);
    procedure NOutDepotTypeMgrClick(Sender: TObject);
    procedure NRepertoryQueryClick(Sender: TObject);
    procedure NRepertoryStatClick(Sender: TObject);
    procedure NInDepotMgrClick(Sender: TObject);
    procedure NInDepotStatClick(Sender: TObject);
    procedure NOutDepotMgrClick(Sender: TObject);
    procedure NOutDepotStatClick(Sender: TObject);
    procedure NCustomAnalyseClick(Sender: TObject);
    procedure NBalanceAnalyseClick(Sender: TObject);
    procedure NRepertoryAnalyseClick(Sender: TObject);
    procedure NUserMgrClick(Sender: TObject);
    procedure NUserChangePassClick(Sender: TObject);
    procedure NSystemLockClick(Sender: TObject);
    procedure NLogOutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CreateODBC;
  end;

var
  FormMain: TFormMain;
  function SQLConfigDataSource(
             hwndParent: Integer;
             fRequest: LongInt;
             lpszDriverString: string;
             lpszAttributes: string
           ): LongBool; stdcall; external 'ODBCCP32.DLL';
const
  ODBC_ADD_DSN        = 1;
  ODBC_CONFIG_DSN     = 2;
  ODBC_REMOVE_DSN     = 3;
  ODBC_ADD_SYS_DSN    = 4;
  ODBC_CONFIG_SYS_DSN = 5;
  ODBC_REMOVE_SYS_DSN = 6;

implementation

uses UnitLogIn, UnitPublicResourceManager, UnitResource,
     UnitUserManager, UnitAbout, UnitDataModule, UnitDepotInfoMgr,
  UnitPublic, UnitAssociatorTypeMgr, UnitProviderMgr, UnitCustomerMgr,
  UnitGoodsMgr, UnitInDepotTypeMgr, UnitOutDepotTypeMgr, UnitUserManage;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Font.Name :=sDispFontName;
  Font.Size :=sDispFontSize;
  Font.Charset :=sDispCharset;
end;

procedure TFormMain.FormShow(Sender: TObject);
var
  lLogCount: Integer;
begin
  lLogCount:= 0;
  
  with TFormLogIn.Create(nil) do
  begin
    try
      repeat
        EditPwd.Clear;
        if ShowModal=mrok then
        begin
          if DM.LocateUser(Trim(EditName.Text), Trim(EditPwd.Text)) then
          begin
            CurUser.LonInType:= 1;
            SystemStatusBar.Panels.Items[0].Text:= SystemStatusBar.Panels.Items[0].Text + sVersion;
            SystemStatusBar.Panels.Items[1].Text:= SystemStatusBar.Panels.Items[1].Text + CurUser.UserName;
            Break;
          end
          else
          begin
            Application.MessageBox('用户名或密码错误！','提示信息',MB_OK+64);
//            Exit;
          end;
        end
        else
        begin
          Application.Terminate;
          Exit;
        end;
        Inc(lLogCount);
      until lLogCount>3;
    finally
      Free;
    end;
  end;
  if lLogCount>=3 then
  begin
    Application.MessageBox('禁止非法登录！','登录信息',MB_ICONWARNING	);
    Application.Terminate;
    exit;
  end;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  CheckUser: Boolean;
//  TempUser: TUser;   //应在包中建立一个存取用户信息的类  所以此处没初始化 退出时会因为对象不存在而报错
begin
  CheckUser:= False;
  if Application.MessageBox(PChar(sExitSystemQuery), PChar(Application.Title), MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) <> IDYES then
  begin
    CanClose := False;
    Exit;
  end;
  with TFormLogIn.Create(nil) do
  begin
    try
      if ShowModal=mrok then
      begin
        if UpperCase(CurUser.UserName) = UpperCase(EditName.Text) then
          if UpperCase(CurUser.PassWord) = UpperCase(EditPwd.Text) then
            CheckUser:= True;
      end
      else
        CheckUser:= False;
    finally
      Free;
    end;
  end;
  if CheckUser then begin  //True 是弹出操作员输入用户名密码窗体，核对信息，如果正确可退出程序，否则不允许退出程序。
  begin
    CanClose:= True;
    CurUser.LonInType:= 2;
  end;
    Exit;
  end
  else
  begin
    CanClose:= False;
    Exit;
  end;
end;

procedure TFormMain.CreateODBC;
  var str :string;
begin
  str:='DSN=' + sDataBaseName + ';DBQ='+ExtractFilePath(Application.ExeName) + 'Data\'+sDataBaseName+
       '.mdb;DefaultDir=' + ExtractFilePath(Application.ExeName)+
       ';FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;Description=' + sDataBaseName;
  SQLConfigDataSource(0, ODBC_ADD_SYS_DSN, 'Microsoft Access Driver (*.mdb)', str);
end;

procedure TFormMain.ToolBtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.NDepotInfoMgrClick(Sender: TObject);
begin
  with TFormDepotInfoMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NAssociatorTypeInfoMgrClick(Sender: TObject);
begin
  with TFormAssociatorTypeMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NProviderInfoMgrClick(Sender: TObject);
begin
  with TFormProviderMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NCustomerInfoMgrClick(Sender: TObject);
begin
  with TFormCustomerMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NGoodsTypeInfoMgrClick(Sender: TObject);
begin
  with TFormGoodsMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NInDepotTypeMgrClick(Sender: TObject);
begin
  with TFormInDepotTypeMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NOutDepotTypeMgrClick(Sender: TObject);
begin
  with TFormOutDepotTypeMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NRepertoryQueryClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NRepertoryStatClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NInDepotMgrClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NInDepotStatClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NOutDepotMgrClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NOutDepotStatClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NCustomAnalyseClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NBalanceAnalyseClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NRepertoryAnalyseClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NUserMgrClick(Sender: TObject);
begin
  with TFormUserManage.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NUserChangePassClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NSystemLockClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NLogOutClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NHelpClick(Sender: TObject);
var
  lHelpPath: string;
begin
  lHelpPath:= ExtractFilePath(Application.ExeName) + sHelpFileName;
  ShellExecute(Self.Handle,nil,PChar(lHelpPath),nil,nil,SW_SHOWNORMAL);
end;

procedure TFormMain.NAboutClick(Sender: TObject);
begin
  with TFormAbout.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

end.
