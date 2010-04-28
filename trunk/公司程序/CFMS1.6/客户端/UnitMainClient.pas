unit UnitMainClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxBar, dxBarExtItems, cxClasses, dxRibbon, cxControls, IniFiles,
  cxSplitter, ExtCtrls, ComCtrls, Tabs, UnitDllMgr, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, UnitVFMSGlobal, StdCtrls,
  Menus, WinSkinData, ActnList, XPStyleActnCtrls, ActnMan, ImgList,
  cxGraphics, UnitJumpButton, UnitRingPopupWindows;

type
  TFormMainClient = class(TForm)
    dxBarManager1: TdxBarManager;
    dxRibbon1: TdxRibbon;
    dxRibbon1Tab2: TdxRibbonTab;
    dxRibbon1Tab3: TdxRibbonTab;
    dxRibbon1Tab4: TdxRibbonTab;
    dxBarManager1Bar1: TdxBar;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    FormTab: TTabSet;
    StatusBar: TStatusBar;
    dxRibbon1Tab5: TdxRibbonTab;
    dxBarManager1Bar2: TdxBar;
    dxBarBtnRoleMgr: TdxBarLargeButton;
    dxBarBtnUserMgr: TdxBarLargeButton;
    dxBarLargeButtonGroupManager: TdxBarLargeButton;
    PopupMenuTab: TPopupMenu;
    NRestore: TMenuItem;
    NMax: TMenuItem;
    NMin: TMenuItem;
    NClose: TMenuItem;
    dxBarLargeButtonUserFieldSet: TdxBarLargeButton;
    dxBarManager1Bar3: TdxBar;
    dxBarLargeButtonAlarmTracker: TdxBarLargeButton;
    dxRibbon1Tab6: TdxRibbonTab;
    dxBarManager1Bar4: TdxBar;
    dxBarLargeButtonClose: TdxBarLargeButton;
    SkinData1: TSkinData;
    dxBarLargeButtonDictMgr: TdxBarLargeButton;
    dxBarLargeButtonAreaMgr: TdxBarLargeButton;
    dxBarLargeButtonCompanyMgr: TdxBarLargeButton;
    dxBarLargeButtonDevGatherDistribute: TdxBarLargeButton;
    dxBarLargeButtonAlarmExcept: TdxBarLargeButton;
    dxBarManager1Bar5: TdxBar;
    dxBarLargeButtonAlarmSearch: TdxBarLargeButton;
    dxBarManager1Bar6: TdxBar;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarLargeButton7: TdxBarLargeButton;
    dxBarLargeButton8: TdxBarLargeButton;
    dxBarLargeButton9: TdxBarLargeButton;
    dxBarLargeButton10: TdxBarLargeButton;
    dxBarLargeButton11: TdxBarLargeButton;
    dxBarLargeButton12: TdxBarLargeButton;
    dxBarLargeButton13: TdxBarLargeButton;
    dxBarLargeButton14: TdxBarLargeButton;
    dxBarLargeButton15: TdxBarLargeButton;
    dxBarLargeButton16: TdxBarLargeButton;
    cxImageList1: TcxImageList;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    Action12: TAction;
    Action13: TAction;
    Action14: TAction;
    Action15: TAction;
    Action16: TAction;
    Action17: TAction;
    Action18: TAction;
    Action19: TAction;
    dxBarLargeButtonFaultStay: TdxBarLargeButton;
    dxBarLargeButtonAlarmManual: TdxBarLargeButton;
    Action20: TAction;
    dxBarLargeButton3: TdxBarLargeButton;
    TimerRing: TTimer;
    ActionBreakSiteStat: TAction;
    dxBarLargeButton17: TdxBarLargeButton;
    ActCapacityMonitor: TAction;
    dxBarLargeButton18: TdxBarLargeButton;
    ActionSysConfig: TAction;
    dxBarLargeButton19: TdxBarLargeButton;
    Action21: TAction;
    Action22: TAction;
    dxBarLargeButton20: TdxBarLargeButton;
    Action23: TAction;
    dxBarLargeButton21: TdxBarLargeButton;
    Action24: TAction;
    BtnUserCustomSet: TdxBarLargeButton;
    ActionUserCustomSet: TAction;
    ActCompanyCheck: TAction;
    dxBarLargeButton22: TdxBarLargeButton;
    dxBarLargeButton23: TdxBarLargeButton;
    Action25: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dxBarLargeButtonGroupManagerClick(Sender: TObject);
    procedure FormTabChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure dxBarRoleMgrClick(Sender: TObject);
    procedure dxBarUserMgrClick(Sender: TObject);
    procedure NRestoreClick(Sender: TObject);
    procedure NMaxClick(Sender: TObject);
    procedure NMinClick(Sender: TObject);
    procedure NCloseClick(Sender: TObject);
    procedure dxBarLargeButtonUserFieldSetClick(Sender: TObject);
    procedure dxBarLargeButtonAlarmTrackerClick(Sender: TObject);
    procedure dxBarLargeButtonCloseClick(Sender: TObject);
    procedure dxBarLargeButtonDictMgrClick(Sender: TObject);
    procedure dxBarLargeButtonAreaMgrClick(Sender: TObject);
    procedure dxBarLargeButtonCompanyMgrClick(Sender: TObject);
    procedure dxBarLargeButtonDevGatherDistributeClick(Sender: TObject);
    procedure dxBarLargeButtonAlarmExceptClick(Sender: TObject);
    procedure dxBarLargeButtonAlarmSearchClick(Sender: TObject);
    procedure dxBarLargeButton4Click(Sender: TObject);
    procedure dxBarLargeButton5Click(Sender: TObject);
    procedure dxBarLargeButton6Click(Sender: TObject);
    procedure dxBarLargeButton7Click(Sender: TObject);
    procedure dxBarLargeButton8Click(Sender: TObject);
    procedure dxBarLargeButton9Click(Sender: TObject);
    procedure dxBarLargeButton15Click(Sender: TObject);
    procedure dxBarLargeButton16Click(Sender: TObject);
    procedure dxBarLargeButtonFaultStayClick(Sender: TObject);
    procedure dxBarLargeButtonAlarmManualClick(Sender: TObject);
    procedure Action20Execute(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure TimerRingTimer(Sender: TObject);
    procedure ActionBreakSiteStatExecute(Sender: TObject);
    procedure ActCapacityMonitorExecute(Sender: TObject);
    procedure ActionSysConfigExecute(Sender: TObject);
    procedure Action21Execute(Sender: TObject);
    procedure Action22Execute(Sender: TObject);
    procedure Action23Execute(Sender: TObject);
    procedure dxBarLargeButton21Click(Sender: TObject);
    procedure Action24Execute(Sender: TObject);
    procedure ActionUserCustomSetExecute(Sender: TObject);
    procedure ActCompanyCheckExecute(Sender: TObject);
    procedure Action25Execute(Sender: TObject);
  private
    FDllMgr: TPluginMgr;
    FRingFileName: WideString;
    FormRingPopupWindowsSend, FormRingPopupWindowsOverTime: TFormRingPopupWindows;
    FIsAlarmSendRing, FIsAlarmWillOverTimeRing: Integer;
//    JumpButtom_New: TBtnJump;
    //FTCPClient:TTCPClient;
    function ConnectAppServer:boolean;

    procedure InitSubmitLimit;
    procedure OnUserSoundClick(Sender: TObject);
    //初始化用户权限
    procedure InitFuncs;
    function GetLoacalRingWave(aFileName: string): string;
    function GetSysTab(aKind, aCode: Integer; aContent: string): Integer;
  public
    procedure DllMessageCall(aForm: TForm; aMsg: integer; alParamMsg, arParamMsg: string);
    procedure AddToTab(aForm: TForm);
    procedure DelTab(aForm: TForm);
  end;

var
  FormMainClient: TFormMainClient;
  procedure DllMessage(aForm: TForm; aMsg: integer; alParamMsg, arParamMsg: string);stdcall;

implementation

uses UnitDataModuleLocal, UnitServerSet, UnitLogin, UnitFormCommon,
  PasswordFrmUnit, UnitSuspendWnd;

{$R *.dfm}

procedure TFormMainClient.FormCreate(Sender: TObject);
begin
  FDllMgr:=TPluginMgr.create;
  //新告警提示按钮
//  JumpButtom_New :=TBtnJump.Create(application);
//  with JumpButtom_New do
//  begin
//    Parent:=StatusBar;
//    Visible:=true;
//    Flat := true;
//    Caption :='响铃提示';
//    Hint :='响铃提示';
//    OnClick:= OnUserSoundClick;//双击停止响铃
//  end;
end;

procedure TFormMainClient.FormShow(Sender: TObject);
var
  lRetryCount:integer;
  lUserNo,lPassword:string;
  lUserid: integer;
  lCityid: integer;
  lResult:integer;
  lCompanyid: integer;
  lCompanyidStr: WideString;
  lManagePrive: integer;
begin
  if not ConnectAppServer then
  begin
    Application.MessageBox('应用服务连接失败，请检查网络及配置文件！','登录',MB_OK	);
    Application.Terminate;
    exit;
  end;
  gPublicParam.MainHandle:= Handle;
  FormLogin:= TFormLogin.Create(nil);
  FormLogin.LabelTitle.Caption:=self.Caption;
  FormLogin.LabelVer.Caption:='版本:1.66';
  StatusBar.Panels[0].Text := StatusBar.Panels[0].Text +' Bulid:'+GetFileTimeInfor(Application.ExeName,2);

  FormLogin.LoadUser;
  lRetryCount:=0;
  try
    repeat
      FormLogin.EditPassword.Clear;
      if FormLogin.ShowModal=mrOK then
      begin
        //密码校验
        lUserNo:=Trim(FormLogin.EditUserNo.Text);
        lPassword:=FormLogin.EditPassword.Text;
        lResult:= DataModuleLocal.TempInterface.login(lUserNo,lPassword,lUserid,lCityid,lCompanyid,lCompanyidStr,lManagePrive);
        if lResult=-1 then
        begin
          Application.MessageBox('连接数据库失败！','登录',MB_ICONWARNING	);
        end else
        if lResult= 1 then  //成功
        begin
          FormLogin.SaveUser(lUserNo);
          StatusBar.Panels[1].Text:='当前用户：'+String(lUserNo);
          StatusBar.Panels[2].Text:='服务器地址: '+gPublicParam.ServerIP;

          gPublicParam.cityid:= lCityid;
          gPublicParam.userid:= lUserid;
          gPublicParam.userno:= lUserNo;
          gPublicParam.Companyid:= lCompanyid;
          gPublicParam.RuleCompanyidStr:= lCompanyidStr;
          gPublicParam.ManagerPrive:= lManagePrive;
          gPublicParam.CanConnSrv:= true;
          InitSubmitLimit;
          break;
        end
        else if lResult= 2 then  //维护单位没有设置
        begin
          Application.MessageBox('该用户的维护单位权限有误！','登录',MB_ICONWARNING	);
        end
        else
        begin
          Application.MessageBox('用户名或口令有误！','登录',MB_ICONWARNING	);
        end;
      end
      else
      begin
        Application.Terminate;
        exit;
      end;
      lRetryCount:=lRetryCount+1;
    until lRetryCount=3;
  finally
    FormLogin.Free;
  end;

  if lRetryCount>=3 then
  begin
    Application.MessageBox('禁止非法登录！','登录',MB_ICONWARNING	);
    Application.Terminate;
    exit;
  end;
  //InitUserInfo(lUserNo);
  InitFuncs;
  self.dxRibbon1.ActiveTab:= self.dxRibbon1Tab2;
  gDllMessage:= @DllMessage;
  //启动告警闪烁
  TimerRing.Enabled:= true;

  if GetSysTab(36,gPublicParam.userid,'')=1 then
  begin
    if not Assigned(FormSuspendWnd) then
    begin
      FormSuspendWnd := TFormSuspendWnd.Create(nil);
      FormSuspendWnd.FormStyle:=fsStayOnTop;
    end;
    FormSuspendWnd.Show;
  end;
end;

procedure TFormMainClient.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(FormSuspendWnd) then
    FormSuspendWnd.Free;
  FreeAndNil(FDllMgr);
end;

function TFormMainClient.ConnectAppServer: boolean;
var
  lNetIni:TIniFile;
  temForm: TFormServerSet;
  lFile:string;
begin
  result:=false;
  lNetIni := nil;
  lFile:=ExtractFilePath(Application.ExeName)+'ProjectCFMS_Client.ini';
  if not FileExists(lFile) then
  begin
    temForm:= TFormServerSet.Create(nil);
    try
      if temForm.ShowModal = mrOk then
      begin
        gPublicParam.ServerIP := Trim(temForm.IP1.Text) + '.' + Trim(temForm.IP2.Text) + '.' + Trim(temForm.IP3.Text) + '.' + Trim(temForm.IP4.Text);
        gPublicParam.MsgPort := StrToInt(Trim(temForm.edtPort.Text));
        gPublicParam.DBPort := StrToInt(Trim(temForm.DBPort.Text));
        lNetIni:=TIniFile.Create(lFile);
        try
          lNetIni.WriteString('AppSvr','ServerIP',gPublicParam.ServerIP);
          lNetIni.WriteInteger('AppSvr','DBPORT',gPublicParam.DBPort);
          lNetIni.WriteInteger('AppSvr','MSGPORT',gPublicParam.MsgPort);
        finally
          lNetIni.Free;
        end;
      end
      else
        Exit;
    finally
      temForm.Free;
    end;
  end
  else
  begin
    try
      lNetIni:=TIniFile.Create(lFile);
      gPublicParam.ServerIP:= lNetIni.ReadString('AppSvr','ServerIP','127.0.0.1');
      gPublicParam.DBPort :=  lNetIni.ReadInteger('AppSvr','DBPORT',990);
      gPublicParam.MsgPort := lNetIni.ReadInteger('AppSvr','MSGPORT',991);
    finally
      lNetIni.Free;
    end;
  end;

  DataModuleLocal.SocketConnection.Address:=gPublicParam.ServerIP;
  DataModuleLocal.SocketConnection.Port:=gPublicParam.DBPort;
  try
    DataModuleLocal.SocketConnection.Open;
    if DataModuleLocal.SocketConnection.Connected then
      result:=true
  except
    result:=false;
  end;

end;

procedure TFormMainClient.FormTabChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  TForm(FormTab.Tabs.Objects[NewTab]).Show;
end;

procedure TFormMainClient.AddToTab(aForm: TForm);
begin
  if FormTab.Tabs.IndexOf(aForm.Caption)<>-1 then
  begin
    FormTab.TabIndex := FormTab.Tabs.IndexOf(aForm.Caption);
    Exit;
  end;
  FormTab.Tabs.AddObject(aForm.Caption,aForm);
  FormTab.TabIndex:=FormTab.Tabs.IndexOf(aForm.Caption);
end;

procedure TFormMainClient.DelTab(aForm: TForm);
var
  i:integer;
begin
  for i:=FormTab.Tabs.Count-1 downto 0 do
  begin
    if FormTab.Tabs.Objects[i]= aForm then
    begin
//      FormTab.Tabs.Objects[i].Free;
      FormTab.Tabs.Delete(i);
      break;
    end;
  end;
end;

procedure TFormMainClient.dxBarRoleMgrClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\RoleMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except

  end;
end;

procedure TFormMainClient.dxBarUserMgrClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\UserMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except

  end;
end;

procedure TFormMainClient.dxBarLargeButtonGroupManagerClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\FieldGroupMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except

  end;
end;

procedure TFormMainClient.NRestoreClick(Sender: TObject);
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

procedure TFormMainClient.NMaxClick(Sender: TObject);
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

procedure TFormMainClient.NMinClick(Sender: TObject);
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

procedure TFormMainClient.NCloseClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to Self.MDIChildCount-1 do
    if Self.MDIChildren[i].Caption = FormTab.Tabs.Strings[FormTab.TabIndex] then
    begin
      DelTab(Self.MDIChildren[i]);
      FDllMgr.FreePlugin(Self.MDIChildren[i]);
      Break;
    end;

  if FormTab.TabIndex>-1 then
  TForm(FormTab.Tabs.Objects[FormTab.TabIndex]).Show;
end;

procedure TFormMainClient.dxBarLargeButtonUserFieldSetClick(
  Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\UserFieldSetMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except

  end;
end;

procedure TFormMainClient.dxBarLargeButtonAlarmTrackerClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmTrackerMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except

  end;
end;

procedure TFormMainClient.dxBarLargeButtonCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFormMainClient.dxBarLargeButtonDictMgrClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\DictMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButtonAreaMgrClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AreaMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButtonCompanyMgrClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\CompanyMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButtonDevGatherDistributeClick(
  Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\DevGatherDistribute.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.InitSubmitLimit;
var
  lSqlstr: string;
begin
  with DataModuleLocal.ClientDataSetDym do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select * from alarm_sys_function_set where kind=23';
    Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    gPublicParam.CauseLevel:= FieldByName('setvalue').AsInteger;
    close;
  end;
  with DataModuleLocal.ClientDataSetDym do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select nvl(setvalue,0) setvalue from alarm_sys_function_set where kind=24 and code=2';
    Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    gPublicParam.CauseCodeFlag:= FieldByName('setvalue').AsInteger;
    close;
  end;
  with DataModuleLocal.ClientDataSetDym do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select nvl(setvalue,0) setvalue from alarm_sys_function_set where kind=24 and code=1';
    Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    gPublicParam.ResolveCodeFlag:= FieldByName('setvalue').AsInteger;
    close;
  end;
end;

procedure TFormMainClient.dxBarLargeButtonAlarmExceptClick(
  Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmExceptMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButtonAlarmSearchClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmSearchMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButton4Click(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmAndSolutionMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButton5Click(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\ShieldMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButton6Click(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\TotalShieldMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButton7Click(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\ShieldLook.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButton8Click(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmContentMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButton9Click(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\SendRuleSet.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButton15Click(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmManpower.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.dxBarLargeButton16Click(Sender: TObject);
var
  lResult:integer;
  PasswordFrm: TPasswordFrm;
begin
  PasswordFrm:= TPasswordFrm.Create(self);
  try
    PasswordFrm.UserName.Text:=gPublicParam.userno;
    if PasswordFrm.ShowModal=MROK then
    begin
      if PasswordFrm.NewPSW1.Text<>PasswordFrm.NewPSW2.Text then
      begin
        Application.MessageBox('校验密码不一致！','登录',MB_OK	);
        exit;
      end;
      lResult:=DataModuleLocal.TempInterface.ChangePassword(gPublicParam.userno, gPublicParam.cityid,PasswordFrm.OldPSW.Text,PasswordFrm.NewPSW1.Text);
      if lResult=1 then
      begin
        Application.MessageBox('密码修改成功！','登录',MB_OK	);
      end else
      begin
        Application.MessageBox('密码修改失败！','登录',MB_OK	);
      end;
    end;
  finally
    PasswordFrm.free;
  end;
end;

procedure TFormMainClient.dxBarLargeButtonFaultStayClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmStayMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure DllMessage(aForm: TForm; aMsg: integer;
  alParamMsg, arParamMsg: string);
begin
  FormMainClient.DllMessageCall(aForm,aMsg,alParamMsg,arParamMsg);
end;

procedure TFormMainClient.DllMessageCall(aForm: TForm; aMsg: integer;
  alParamMsg, arParamMsg: string);
var
  lFormIndex: integer;
begin
  Screen.Cursor:= crHourGlass;
  try
    case aMsg of
      1: begin
           DelTab(aForm);
           FDllMgr.FreePlugin(aForm);
           if FormTab.TabIndex>-1 then
           begin
             TForm(FormTab.Tabs.Objects[FormTab.TabIndex]).Show;
           end;
      end;
      //跳转：告警查询
      2: begin
           lFormIndex:= FormTab.Tabs.IndexOf(alParamMsg);
           if lFormIndex<>-1 then
           begin
             FormTab.TabIndex:= lFormIndex;
           end
           else
           begin
             dxBarLargeButtonAlarmSearchClick(self);
           end;
           FDllMgr.GetPlugin(alParamMsg).LocateTreeNode(arParamMsg);
      end;
      //跳转：故障监视
      3: begin
           lFormIndex:= FormTab.Tabs.IndexOf(alParamMsg);
           if lFormIndex<>-1 then
           begin
             FormTab.TabIndex:= lFormIndex;
           end
           else
           begin
             dxBarLargeButtonAlarmTrackerClick(self);
           end;
           FDllMgr.GetPlugin(alParamMsg).LocateTreeNode(arParamMsg);
      end;
      //跳转：疑难告警管理
      4: begin
           lFormIndex:= FormTab.Tabs.IndexOf(alParamMsg);
           if lFormIndex<>-1 then
           begin
             FormTab.TabIndex:= lFormIndex;
           end
           else
           begin
             dxBarLargeButtonFaultStayClick(self);
           end;
           FDllMgr.GetPlugin(alParamMsg).LocateTreeNode(arParamMsg);
      end;
      5: begin
           if (FormTab.Tabs.IndexOf(aForm.Caption)>-1)
               and (FormTab.TabIndex=FormTab.Tabs.IndexOf(aForm.Caption)) then
           begin
             gPublicParam.IsFormOnTop:= true;
           end
           else
             gPublicParam.IsFormOnTop:= false;
      end;
      //跳转人工派障
      6: begin
           lFormIndex:= FormTab.Tabs.IndexOf(alParamMsg);
           if lFormIndex<>-1 then
           begin
             FormTab.TabIndex:= lFormIndex;
           end
           else
           begin
             dxBarLargeButtonAlarmManualClick(self);
           end;
           FDllMgr.GetPlugin(alParamMsg).LocateTreeNode(arParamMsg);
      end;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormMainClient.dxBarLargeButtonAlarmManualClick(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmManualMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.Action20Execute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\RingMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  //新告警
//  if Panel = StatusBar.Panels[3] then
//  with JumpButtom_New do begin
//    Top := Rect.Top;
//    Left := Rect.Left;
//    Width := Rect.Right - Rect.Left;
//    Height := Rect.Bottom - Rect.Top;
//  end;
end;

procedure TFormMainClient.TimerRingTimer(Sender: TObject);
var
  lNewRingFileName, lNewRingFileNameOverTime: WideString;
  lIsRing, lIsRingOverTime: Integer;
begin
  try
    DataModuleLocal.TempInterface.GetRingRemind(gPublicParam.cityid,gPublicParam.userid,1,lIsRing,lNewRingFileName);
    if lIsRing=1 then
    begin
      if Assigned(FormRingPopupWindowsOverTime) then
      begin
        DataModuleLocal.TempInterface.GetRingRemind(gPublicParam.cityid,gPublicParam.userid,2,lIsRingOverTime,lNewRingFileNameOverTime);
        if lIsRingOverTime=1 then
          Exit
        else
        begin
          FormRingPopupWindowsOverTime.Close;
          FreeAndNil(FormRingPopupWindowsOverTime);
        end;
      end;
      lNewRingFileName:= GetLoacalRingWave(lNewRingFileName);
      if not Assigned(FormRingPopupWindowsSend) then
        FormRingPopupWindowsSend:= TFormRingPopupWindows.Create(Application,True,lNewRingFileName,1)
      else
        if lNewRingFileName<>FRingFileName then
        begin
          FormRingPopupWindowsSend.Close;
          FreeAndNil(FormRingPopupWindowsSend);
          FormRingPopupWindowsSend:= TFormRingPopupWindows.Create(Application,True,lNewRingFileName,1);
        end;
      FormRingPopupWindowsSend.FormStyle:= fsStayOnTop;
      FormRingPopupWindowsSend.Show;
    end
    else
    begin
      if Assigned(FormRingPopupWindowsSend) then
      begin
        FormRingPopupWindowsSend.Close;
        FreeAndNil(FormRingPopupWindowsSend);
      end;

      DataModuleLocal.TempInterface.GetRingRemind(gPublicParam.cityid,gPublicParam.userid,2,lIsRing,lNewRingFileName);
      if lIsRing=1 then
      begin
        lNewRingFileName:= GetLoacalRingWave(lNewRingFileName);
        if not Assigned(FormRingPopupWindowsOverTime) then
          FormRingPopupWindowsOverTime:= TFormRingPopupWindows.Create(Application,True,lNewRingFileName,2)
        else
        if lNewRingFileName<>FRingFileName then
        begin
          FormRingPopupWindowsOverTime.Close;
          FreeAndNil(FormRingPopupWindowsOverTime);
          FormRingPopupWindowsOverTime:= TFormRingPopupWindows.Create(Application,True,lNewRingFileName,2);
        end;
        FormRingPopupWindowsOverTime.FormStyle:= fsStayOnTop;
        FormRingPopupWindowsOverTime.Show;
      end
      else
      begin
        if Assigned(FormRingPopupWindowsOverTime) then
        begin
          FormRingPopupWindowsOverTime.Close;
          FreeAndNil(FormRingPopupWindowsOverTime);
        end;
      end;
    end;
    FRingFileName:=lNewRingFileName;

//    with DataModuleLocal.ClientDataSetWav do
//    begin
//      Close;
//      ProviderName:='DataSetProviderWav';
//      //注意这里的规则判断
//      lSqlstr:= 'select a.alarmlevel,c.setvalue Wav from alarm_ringremind_info a'+
//                ' inner join alarm_sys_function_set b'+
//                ' on a.cityid=b.cityid and a.companyid=b.code and b.setvalue=''1'' and b.kind=31'+
//                ' left join alarm_sys_function_set c'+
//                ' on a.cityid=c.cityid and a.alarmlevel=c.code and c.kind=30'+
//                ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.companyid='+inttostr(gPublicParam.Companyid)+' and a.isremind=1'+
//                ' order by a.alarmlevel desc';
//      Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),6);
//      if Recordcount=0 then  //如果没有相应提示了，就停止提示
//      begin
//        JumpButtom_New.CancelShine;
//        JumpButtom_New.CancelPlay;
//      end
//      else
//      begin
//        JumpButtom_New.WavChanged:= uppercase(JumpButtom_New.WavName)<>uppercase(GetLoacalRingWave(FieldByName('Wav').AsString));
//        JumpButtom_New.WavName:= GetLoacalRingWave(FieldByName('Wav').AsString);
//        JumpButtom_New.DisShine;
//        JumpButtom_New.DisPlay;
//      end;
//    end;
  except
    //判断是否客户端失去连接
    gPublicParam.CanConnSrv:= false;
    TimerRing.Enabled:= false;
    Application.MessageBox('与服务端失去连接，请检查网络！','系统提示',MB_ICONWARNING);
    self.Close;
  end;
end;

procedure TFormMainClient.OnUserSoundClick(Sender: TObject);
var
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
//  lVariant:= VarArrayCreate([0,0],varVariant);
//  lSqlstr:= 'update alarm_ringremind_info t set t.isremind=0 where t.companyid='+inttostr(gPublicParam.Companyid);
//  lVariant[0]:= VarArrayOf([lSqlstr]);
//  lsuccess:= DataModuleLocal.TempInterface.ExecBatchSQL(lVariant);
//  //立即停止响铃
//  JumpButtom_New.CancelShine;
//  JumpButtom_New.CancelPlay;
//  JumpButtom_New.WavName:= '';
end;

procedure TFormMainClient.ActionBreakSiteStatExecute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\BreakSiteStat.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.ActCapacityMonitorExecute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\CapacityMonitor.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;

  if not Assigned(FormSuspendWnd) then
  begin
    //FormSuspendWnd := TFormSuspendWnd.CreateParented(GetDesktopWindow);
    //FormSuspendWnd.FormStyle:=fsStayOnTop;
    FormSuspendWnd := TFormSuspendWnd.Create(nil);
    FormSuspendWnd.FormStyle:=fsStayOnTop;
  end;
  FormSuspendWnd.Show;
end;

procedure TFormMainClient.ActionSysConfigExecute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\SysConfigMgr.dll');
    if lTempForm<> nil then
    begin
//      lTempForm.Visible := False;
      lTempForm.FormStyle:=fsStayOnTop;
      lTempForm.Show;
//      AddToTab(lTempForm);
    end;
  except
  
  end;
end;

procedure TFormMainClient.InitFuncs;
var
  i:integer;
  lAction:TAction;
  lPriveStr:string;
  lList: TStringList;
  lSqlstr: string;
begin
  lPriveStr:= '';
  with DataModuleLocal.ClientDataSetDym do
  begin
    Close;
    ProviderName:='dsp_General_data';
    if gPublicParam.userid=1 then
      lSqlstr:= 'select t.moduleid from fms_module_info t where cityid='+inttostr(gPublicParam.cityid)
    else
      lSqlstr:= 'select a.moduleid from fms_role_power_relat a'+
                ' inner join fms_role_info b on a.cityid=b.cityid and a.roleid=b.roleid'+
                ' inner join fms_role_user_relat c on b.cityid=c.cityid and b.roleid=c.roleid'+
                ' and c.userid='+inttostr(gPublicParam.userid)+' and c.cityid='+inttostr(gPublicParam.cityid);
    Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    while not eof do
    begin
      lPriveStr:= lPriveStr+FieldbyName('moduleid').AsString+',';
      next;
    end;
    if length(lPriveStr)>0 then
      lPriveStr:= copy(lPriveStr,1,length(lPriveStr)-1)
    else
      lPriveStr:= '';
    lList:= TStringList.Create;
    lList.Delimiter:= ',';
    lList.DelimitedText:= lPriveStr;
    close;
  end;

  for i := 0 to ActionManager1.ActionCount- 1 do
  begin
    lAction:=ActionManager1.Actions[i] as TAction;
    lAction.Visible:=lList.IndexOf(inttostr(lAction.Tag))>-1;
  end;
  lList.Free;
end;

procedure TFormMainClient.Action21Execute(Sender: TObject);
begin
  dxBarLargeButtonFaultStayClick(self);
end;

procedure TFormMainClient.Action22Execute(Sender: TObject);
begin
  dxBarLargeButtonAlarmManualClick(self);
end;

function TFormMainClient.GetLoacalRingWave(aFileName: string): string;
begin
  if trim(aFileName)='' then result:= ''
  else
  result:= ExtractFilePath(Application.ExeName)+'Ring\'+aFileName;
end;

procedure TFormMainClient.Action23Execute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\RepeatAlarmMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except

  end;
end;

procedure TFormMainClient.dxBarLargeButton21Click(Sender: TObject);
   var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmStateLookMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;
procedure TFormMainClient.Action24Execute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmStateLookMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.ActionUserCustomSetExecute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\UserCustomSet.dll');
    if lTempForm<> nil then
    begin
      lTempForm.FormStyle:= fsStayOnTop;
      lTempForm.Show;
    end;
  except
    lTempForm.Free;
  end;
end;

function TFormMainClient.GetSysTab(aKind, aCode: Integer; aContent: string): Integer;
var      
  lSqlStr: string;
begin
  Result:= -1;
  with DataModuleLocal.ClientDataSetDym do
  begin
    Close;
    ProviderName:= 'dsp_General_data';
    lSqlStr:= 'select SetValue from alarm_sys_function_set where kind=' +
              IntToStr(aKind) +
              ' and code=' +
              IntToStr(aCode) + aContent;
    Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    if RecordCount=1 then
      Result:= FieldByName('SetValue').AsInteger;
  end;
end;

procedure TFormMainClient.ActCompanyCheckExecute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\CompanyCheck.dll');
    if lTempForm<> nil then
    begin
      lTempForm.FormStyle:= fsStayOnTop;
      lTempForm.Show;
    end;
  except
    lTempForm.Free;
  end;
end;

procedure TFormMainClient.Action25Execute(Sender: TObject);
var
  lTempForm: TForm;
begin
  try
    lTempForm:= FDllMgr.LoadPlugin('Dll\AlarmCSTrackerMgr.dll');
    if lTempForm<> nil then
    begin
      IniFormStyle(lTempForm);
      lTempForm.Show;
      AddToTab(lTempForm);
    end;
  except
    lTempForm.Free;
  end;
end;

end.


