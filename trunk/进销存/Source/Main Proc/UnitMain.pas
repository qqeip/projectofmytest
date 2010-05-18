unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, WinSkinData, cxGraphics, ImgList, ComCtrls, ToolWin,
  cxControls, dxStatusBar, ExtCtrls, ShellAPI, Tabs, FileCtrl, UnitPublic;

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
    NGoodsMgr: TMenuItem;
    NInDepotTypeMgr: TMenuItem;
    NOutDepotTypeMgr: TMenuItem;
    SystemStatusBar: TdxStatusBar;
    ToolBar1: TToolBar;
    ToolBtnInDepot: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    ToolBtnOutDepot: TToolButton;
    ToolBtnExit: TToolButton;
    MenuDataAnalyse: TMenuItem;
    NCustomAnalyse: TMenuItem;
    NBalanceAnalyse: TMenuItem;
    NRepertoryAnalyse: TMenuItem;
    SkinData: TSkinData;
    FormTab: TTabSet;
    PopupMenuTab: TPopupMenu;
    NRestore: TMenuItem;
    NMax: TMenuItem;
    NMin: TMenuItem;
    NClose: TMenuItem;
    NInDepotChangeStat: TMenuItem;
    NGoodsTypeMgr: TMenuItem;
    BtnBackup: TToolButton;
    btn2: TToolButton;
    BtnRepertoryQuery: TToolButton;
    NSalaryMgr: TMenuItem;
    NAttendanceMgr: TMenuItem;
    SaveDialog: TSaveDialog;
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
    procedure NGoodsMgrClick(Sender: TObject);
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
    procedure ToolBtnInDepotClick(Sender: TObject);
    procedure ToolBtnOutDepotClick(Sender: TObject);
    procedure NRestoreClick(Sender: TObject);
    procedure NMaxClick(Sender: TObject);
    procedure NMinClick(Sender: TObject);
    procedure NCloseClick(Sender: TObject);
    procedure FormTabChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure NInDepotChangeStatClick(Sender: TObject);
    procedure NGoodsTypeMgrClick(Sender: TObject);
    procedure BtnBackupClick(Sender: TObject);
    procedure BtnRepertoryQueryClick(Sender: TObject);
    procedure NSalaryMgrClick(Sender: TObject);
    procedure NAttendanceMgrClick(Sender: TObject);
  private
    IniOptions : TIniOptions;
    procedure CheckUserRights(aRights: string);
    procedure AddToTab(aForm: TForm);
    procedure SetTabIndex(Form: TForm);
    function BackupDB: Boolean;
//    procedure LockSystem(aEnabled: Boolean);
    { Private declarations }
  public
    { Public declarations }
    procedure CreateODBC;
    procedure RemoveForm(aForm: TForm);
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
  UnitAssociatorTypeMgr, UnitProviderMgr, UnitCustomerMgr,
  UnitGoodsMgr, UnitInDepotTypeMgr, UnitOutDepotTypeMgr, UnitUserManage,
  UnitChangePWD, UnitLockSystem, UnitInDepotMgr, UnitOutDepotMgr,
  UnitInDepotStat, UnitInDepotChangeStat, UnitGoodsTypeMgr,
  UnitOutDepotStat, UnitRepertoryStat, UnitSalaryMgr, UnitAttendanceMgr,
  UnitBalanceAnalyse;

{$R *.dfm}

procedure TFormMain.CreateODBC;
  var str :string;
begin
  str:='DSN=' + sDataBaseName + ';DBQ='+ExtractFilePath(Application.ExeName) + 'Data\'+sDataBaseName+
       '.mdb;DefaultDir=' + ExtractFilePath(Application.ExeName)+
       ';FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;Description=' + sDataBaseName;
  SQLConfigDataSource(0, ODBC_ADD_SYS_DSN, 'Microsoft Access Driver (*.mdb)', str);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Font.Name :=sDispFontName;
  Font.Size :=sDispFontSize;
  Font.Charset :=sDispCharset;

  CurUser.LonInType:= 1;
  IniOptions.LoadFromFile(ExtractFilePath(Application.ExeName)+sIniFileName);
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
            CheckUserRights(CurUser.UserRights);
            CurUser.LonInType:= 1;
            SystemStatusBar.Panels.Items[0].Text:= sStatusVersionStr + sVersion;
            SystemStatusBar.Panels.Items[1].Text:= sStatusUserStr + CurUser.UserName;
            NOutDepotMgrClick(Sender);
            OnWorkRegister;
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
  //先提示用户是否备份数据库
  if Application.MessageBox(PChar(sExitSystemBackupDB), PChar(Application.Title), MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2) = IDYES then
  begin
    if BackupDB then
      Application.MessageBox('数据备份成功！','提示',MB_OK)
    else
      Application.MessageBox('数据备份失败！','提示',MB_OK);
  end;

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
        if DM.GetUserType(EditName.Text,EditPwd.Text) then
          CheckUser:= True;
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
    OffWorkRegister;
  end;
    Exit;
  end
  else
  begin
    CanClose:= False;
    Exit;
  end;
end;

procedure TFormMain.CheckUserRights(aRights: string);
var
  iIndex: Integer;
begin
  NDepotInfoMgr.Visible := False;
  NAssociatorTypeInfoMgr.Visible := False;
  NProviderInfoMgr.Visible := False;
  NCustomerInfoMgr.Visible := False;
  NGoodsTypeMgr.Visible := False;
  NGoodsMgr.Visible := False;
  NInDepotTypeMgr.Visible := False;
  NOutDepotTypeMgr.Visible := False;

  NRepertoryQuery.Visible := False;
  BtnRepertoryQuery.Visible:= False;//库存查询按钮
  NRepertoryStat.Visible := False;

  NInDepotMgr.Visible := False;
  ToolBtnInDepot.Visible:= False;//入库按钮
  NInDepotStat.Visible := False;
  NInDepotChangeStat.Visible := False;

  NOutDepotMgr.Visible := False;
  ToolBtnOutDepot.Visible:= False; //出库按钮
  NOutDepotStat.Visible := False;

  NCustomAnalyse.Visible := False;
  NBalanceAnalyse.Visible := False;
  NRepertoryAnalyse.Visible := False;

  NUserMgr.Visible := False;
  NUserChangePass.Visible := False;
  NSystemLock.Visible := False;
  NLogOut.Visible := False;
  NSalaryMgr.Visible := False;
  NAttendanceMgr.Visible := False;

  for iIndex :=1 to Length(aRights) do
  begin
    if UpperCase(Copy(aRights,iIndex,1)) = 'A' then
      NDepotInfoMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'B' then
      NAssociatorTypeInfoMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'C' then
      NProviderInfoMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'D' then
      NCustomerInfoMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'E' then
      NGoodsTypeMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'F' then
      NGoodsMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'G' then
      NInDepotTypeMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'H' then
      NOutDepotTypeMgr.Visible := True

    else if UpperCase(Copy(aRights,iIndex,1)) = 'I' then
    begin
      NRepertoryQuery.Visible := True;
      BtnRepertoryQuery.Visible := True;
    end
    else if UpperCase(Copy(aRights,iIndex,1)) = 'J' then
      NRepertoryStat.Visible := True

    else if UpperCase(Copy(aRights,iIndex,1)) = 'K' then
    begin
      NInDepotMgr.Visible := True;
      ToolBtnInDepot.Visible := True;
    end
    else if UpperCase(Copy(aRights,iIndex,1)) = 'L' then
      NInDepotStat.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'M' then
      NInDepotChangeStat.Visible := True

    else if UpperCase(Copy(aRights,iIndex,1)) = 'N' then
    begin
      NOutDepotMgr.Visible := True;
      ToolBtnOutDepot.Visible := True;
    end
    else if UpperCase(Copy(aRights,iIndex,1)) = 'O' then
      NOutDepotStat.Visible := True

    else if UpperCase(Copy(aRights,iIndex,1)) = 'P' then
      NCustomAnalyse.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'Q' then
      NBalanceAnalyse.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'R' then
      NRepertoryAnalyse.Visible := True

    else if UpperCase(Copy(aRights,iIndex,1)) = 'S' then
      NUserMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'T' then
      NUserChangePass.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'U' then
      NSystemLock.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'V' then
      NLogOut.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'W' then
      NSalaryMgr.Visible := True
    else if UpperCase(Copy(aRights,iIndex,1)) = 'X' then
      NAttendanceMgr.Visible := True;
  end;

  if (not NDepotInfoMgr.Visible) and (not NAssociatorTypeInfoMgr.Visible) and
     (not NProviderInfoMgr.Visible) and (not NCustomerInfoMgr.Visible) and
     (not NGoodsTypeMgr.Visible) and (not NGoodsMgr.Visible) and
     (not NInDepotTypeMgr.Visible) and (not NOutDepotTypeMgr.Visible) then
    MenuInformationMgr.Visible:= False;

  if (not NRepertoryQuery.Visible) and (not NRepertoryStat.Visible) then
    MenuRepertoryMgr.Visible:= False;

  if (not NInDepotMgr.Visible) and (not NInDepotStat.Visible) and (not NInDepotChangeStat.Visible) then
    MenuInDepotMgr.Visible:= False;

  if (not NOutDepotMgr.Visible) and (not NOutDepotStat.Visible) then
    MenuOutDepotMgr.Visible:= False;

  if (not NCustomAnalyse.Visible) and (not NBalanceAnalyse.Visible) and (not NRepertoryAnalyse.Visible) then
    MenuDataAnalyse.Visible:= False;

  if (not NUserMgr.Visible) and (not NUserChangePass.Visible) and
     (not NSystemLock.Visible) and (not NLogOut.Visible) and
     (not NSalaryMgr.Visible) and (not NAttendanceMgr.Visible) then
    MenuUserMgr.Visible:= False;
end;

procedure TFormMain.ToolBtnExitClick(Sender: TObject);
begin
  CurUser.LonInType:= 2;
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

procedure TFormMain.NGoodsTypeMgrClick(Sender: TObject);
begin
  with TFormGoodsTypeMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NGoodsMgrClick(Sender: TObject);
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
  if not assigned(FormRepertoryStat) then
  begin
    FormRepertoryStat:=TFormRepertoryStat.Create(self);
    AddToTab(FormRepertoryStat);
  end
  else
    SetTabIndex(FormRepertoryStat);
  FormRepertoryStat.WindowState:=wsMaximized;
  FormRepertoryStat.Show;
end;

procedure TFormMain.NRepertoryStatClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NInDepotMgrClick(Sender: TObject);
begin
  if not assigned(FormInDepotMgr) then
  begin
    FormInDepotMgr:=TFormInDepotMgr.Create(self);
    AddToTab(FormInDepotMgr);
  end
  else
    SetTabIndex(FormInDepotMgr);
  FormInDepotMgr.WindowState:=wsMaximized;
  FormInDepotMgr.Show;
end;

procedure TFormMain.NInDepotStatClick(Sender: TObject);
begin
  if not assigned(FormInDepotStat) then
  begin
    FormInDepotStat:=TFormInDepotStat.Create(self);
    AddToTab(FormInDepotStat);
  end
  else
    SetTabIndex(FormInDepotStat);
  FormInDepotStat.WindowState:=wsMaximized;
  FormInDepotStat.Show;
end;

procedure TFormMain.NOutDepotMgrClick(Sender: TObject);
begin
  if not assigned(FormOutDepotMgr) then
  begin
    FormOutDepotMgr:=TFormOutDepotMgr.Create(self);
    AddToTab(FormOutDepotMgr);
  end
  else
    SetTabIndex(FormOutDepotMgr);
  FormOutDepotMgr.WindowState:=wsMaximized;
  FormOutDepotMgr.Show;
end;

procedure TFormMain.NOutDepotStatClick(Sender: TObject);
begin
  if not assigned(FormOutDepotStat) then
  begin
    FormOutDepotStat:=TFormOutDepotStat.Create(self);
    AddToTab(FormOutDepotStat);
  end
  else
    SetTabIndex(FormOutDepotStat);
  FormOutDepotStat.WindowState:=wsMaximized;
  FormOutDepotStat.Show;
end;

procedure TFormMain.NCustomAnalyseClick(Sender: TObject);
begin
//
end;

procedure TFormMain.NBalanceAnalyseClick(Sender: TObject);
begin
  with TFormBalanceAnalyse.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
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
  with TFormChangePWD.Create(nil) do
  begin
    try
     if ShowModal=mrok then
       if DM.ChangePWD(EdtNewPWD.Text) then
         Application.MessageBox('密码修改成功！','提示',MB_OK+64)
       else
         Application.MessageBox('密码修改失败！','提示',MB_OK+64);
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NSystemLockClick(Sender: TObject);
begin
//  if not NSystemLock.Checked then
//    LockSystem(False)
//  else
//    LockSystem(True);
  with TFormLockSystem.Create(nil) do
  begin
    try
      while ShowModal=mrok do
      begin
        if UpperCase(EdtUserPWD.Text)=UpperCase(CurUser.PassWord) then
          Exit
        else
        begin
          Application.MessageBox('密码错误，请重新输入！','系统提示',MB_OK+64);
          EdtUserPWD.Clear;
        end;
      end;
    finally
      Free;
    end;
  end;
end;

//procedure TFormMain.LockSystem(aEnabled: Boolean);
//var
//  TmpControl: TComponent;
//  ControlName: array of string;
//  i: integer;
//begin
//  SetLength(ControlName, 19);
//  ControlName[0] := 'NSystemLock';
//  ControlName[1] := 'NDepotInfoMgr';
//  ControlName[2] := 'NAssociatorTypeInfoMgr';
//  ControlName[3] := 'NProviderInfoMgr';
//  ControlName[4] := 'NCustomerInfoMgr';
//  ControlName[5] := 'NGoodsTypeInfoMgr';
//  ControlName[6] := 'NInDepotTypeMgr';
//  ControlName[7] := 'NOutDepotTypeMgr';
//
//  ControlName[8] := 'NRepertoryQuery';
//  ControlName[9] := 'NRepertoryStat';
//
//  ControlName[10] := 'NInDepotMgr';
//  ControlName[11] := 'NInDepotStat';
//
//  ControlName[12] := 'NOutDepotMgr';
//  ControlName[13] := 'NOutDepotStat';
//
//  ControlName[14] := 'NCustomAnalyse';
//  ControlName[15] := 'NBalanceAnalyse';
//  ControlName[16] := 'NRepertoryAnalyse';
//
//  ControlName[17] := 'NUserMgr';
//  ControlName[18] := 'NUserChangePass';
//  ControlName[19] := 'NLogOut';
//
//  try
//    NSystemLock.Checked:= aEnabled;
//    for i := 0 to Length(ControlName) do
//    begin
//      TmpControl := Self.FindComponent(ControlName[i]);
//      if TmpControl <> nil then
//        TMenuItem(TmpControl).Enabled := aEnabled;
////        TControl(TmpControl).Enabled := aEnabled;
//    end;
//    if aEnabled then
//      self.BorderStyle:= bsSizeable
//    else
//      Self.BorderStyle:= bsNone;
//  finally
//    SetLength(ControlName, 0);
//  end;
//end;

procedure TFormMain.NLogOutClick(Sender: TObject);
begin
//  CurUser.LonInType:= 3;
//  Self.Hide;
//  Self.Show;

end;

procedure TFormMain.NSalaryMgrClick(Sender: TObject);
begin
  with TFormSalaryMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.NAttendanceMgrClick(Sender: TObject);
begin
  with TFormAttendanceMgr.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
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

procedure TFormMain.AddToTab(aForm: TForm);
begin
  if FormTab.Tabs.IndexOf(aForm.Caption)<>-1 then
  begin
    FormTab.TabIndex := FormTab.Tabs.IndexOf(aForm.Caption);
    Exit;
  end;
  FormTab.Tabs.AddObject(aForm.Caption,aForm);
  FormTab.TabIndex:=FormTab.Tabs.IndexOf(aForm.Caption);
end;

procedure TFormMain.SetTabIndex(Form: TForm);
begin
  FormTab.TabIndex := FormTab.Tabs.IndexOf(Form.Caption);
end;

procedure TFormMain.RemoveForm(aForm: TForm);
var
  i:integer;
begin
  for i:=0 to FormTab.Tabs.Count-1 do
  begin
    if FormTab.Tabs.Objects[i]= aForm then
    begin
      FormTab.Tabs.Objects[i].Free;
      FormTab.Tabs.Delete(i);
      break;
    end;
  end;
end;

procedure TFormMain.ToolBtnInDepotClick(Sender: TObject);
begin
  NInDepotMgrClick(Self);
end;

procedure TFormMain.ToolBtnOutDepotClick(Sender: TObject);
begin
  NOutDepotMgrClick(Self);
end;

procedure TFormMain.BtnRepertoryQueryClick(Sender: TObject);
begin
  NRepertoryQueryClick(Self);
end;

procedure TFormMain.NRestoreClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to Self.MDIChildCount-1 do
  if Self.MDIChildren[i].Caption=FormTab.tabs.Strings[FormTab.TabIndex] then
  begin
    Self.MDIChildren[i].WindowState:=wsnormal;
    break;
  end;
end;

procedure TFormMain.NMaxClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to Self.MDIChildCount-1 do
    if Self.MDIChildren[i].Caption=FormTab.tabs.Strings[FormTab.TabIndex] then
    begin
       Self.MDIChildren[i].WindowState:=wsMaximized;
       break;
    end;
end;

procedure TFormMain.NMinClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to Self.MDIChildCount-1 do
    if Self.MDIChildren[i].Caption=FormTab.tabs.Strings[FormTab.TabIndex] then
    begin
     Self.MDIChildren[i].WindowState:=wsMinimized;
     break;
    end;
end;

procedure TFormMain.NCloseClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to Self.MDIChildCount-1 do
    if Self.MDIChildren[i].Caption = FormTab.Tabs.Strings[FormTab.TabIndex] then
    begin
      RemoveForm(Self.MDIChildren[i]);
      Break;
    end;

  if FormTab.TabIndex>-1 then
  TForm(FormTab.Tabs.Objects[FormTab.TabIndex]).Show;
end;

procedure TFormMain.FormTabChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  TForm(FormTab.Tabs.Objects[NewTab]).Show;
end;

procedure TFormMain.NInDepotChangeStatClick(Sender: TObject);
begin
  if not assigned(FormInDepotChangeStat) then
  begin
    FormInDepotChangeStat:=TFormInDepotChangeStat.Create(self);
    AddToTab(FormInDepotChangeStat);
  end
  else
    SetTabIndex(FormInDepotChangeStat);
  FormInDepotChangeStat.WindowState:=wsMaximized;
  FormInDepotChangeStat.Show;
end;

procedure TFormMain.BtnBackupClick(Sender: TObject);
begin
  if BackupDB then
    Application.MessageBox('数据备份成功！','提示',MB_OK)
  else
    Application.MessageBox('数据备份失败！','提示',MB_OK);
end;

function TFormMain.BackupDB: Boolean;
var
  lOldFile: string;
begin
  Result:= False;
  try
    SaveDialog.FileName:= CurBackUPDir + 'Backup ' + DateToStr(Now) + '.mdb';
    if SaveDialog.Execute then
    begin
      CurBackUPDir:= ExtractFilePath(SaveDialog.FileName);
      IniOptions.SaveToFile(ExtractFilePath(Application.ExeName)+sIniFileName);
      lOldFile:= ExtractFilePath(ParamStr(0)) + 'Data\Stockpile System.mdb';
      if CopyFile(PChar(lOldFile),PChar(SaveDialog.FileName), False) then
        Result:= True
      else
        Result:= False;
    end;
  except
    Result:= False;
  end;
end;

end.
