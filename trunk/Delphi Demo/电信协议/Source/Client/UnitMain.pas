unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ComCtrls, Tabs, ImgList, ToolWin, UnitDllMgr,
  WinSkinData, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  WinSkinStore;

const
  WM_MSGCLOSE = WM_User + 100; //定义消息常量,关闭dll子窗体;

type
  TFormMain = class(TForm)
    TabSet: TTabSet;
    StatusBar: TStatusBar;
    Panel1: TPanel;
    PopupMenuTab: TPopupMenu;
    NRestore: TMenuItem;
    NMax: TMenuItem;
    NMin: TMenuItem;
    NClose: TMenuItem;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolBtnParamConfig: TToolButton;
    ToolButtonDllDemo: TToolButton;
    ToolButton3: TToolButton;
    ToolButtonCloseNow: TToolButton;
    ToolButtonCloseAll: TToolButton;
    ToolButtonExit: TToolButton;
    ToolButton7: TToolButton;
    SkinData1: TSkinData;
    ToolButton1: TToolButton;
    IdTCPClient: TIdTCPClient;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    MenuItem2: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    Skin1: TMenuItem;
    SkinMSNStyle1: TMenuItem;
    SkinOfficeStyle1: TMenuItem;
    SkinWindowsStyle1: TMenuItem;
    MenuItem3: TMenuItem;
    Help2: TMenuItem;
    SkinStore1: TSkinStore;
    ToolBtnFtp: TToolButton;
    ToolButton2: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolBtnParamConfigClick(Sender: TObject);
    procedure ToolButtonDllDemoClick(Sender: TObject);
    procedure ToolButtonExitClick(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure ToolButtonCloseNowClick(Sender: TObject);
    procedure NRestoreClick(Sender: TObject);
    procedure NMaxClick(Sender: TObject);
    procedure NMinClick(Sender: TObject);
    procedure NCloseClick(Sender: TObject);
    procedure ToolButtonCloseAllClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure SkinMSNStyle1Click(Sender: TObject);
    procedure SkinOfficeStyle1Click(Sender: TObject);
    procedure SkinWindowsStyle1Click(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure ToolBtnFtpClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
  private
    { Private declarations }
    FDllMgr: TPluginMgr;
    procedure AddToTab(aForm: TForm);
    procedure DelTab(aForm: TForm);
    procedure DllClose(aForm: TForm);
    function  ConnectServer: Boolean;
    procedure SendMessageToServer(ComID: string);
  public
    { Public declarations }
  protected
    procedure WNDProc(var msg: TMessage);override;
  end;

var
  FormMain: TFormMain;
  procedure DllCloseRecall(aForm: TForm);stdcall;
  
implementation

uses UnitLogIn, UnitDataModuleLocal, UnitCommon;


{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FDllMgr:= TPluginMgr.Create;

  SkinData1.LoadFromCollection(skinstore1,0);
  if not SkinData1.active then SkinData1.active:=true;
end;

procedure TFormMain.FormShow(Sender: TObject);
var fUserName,fUserPwd: string;
begin
  if not ConnectServer then
  begin
    Application.MessageBox('应用服务连接失败，请检查网络及配置文件！','登录',MB_OK	);
    Application.Terminate;
    exit;
  end;

  FormLogin:= TFormLogin.Create(Application);
  try
    if FormLogin.ShowModal=mrOK then
    begin
      fUserName:= Trim(FormLogin.UserName);
      fUserPwd := Trim(FormLogin.PassWord);
      //验证身份
      StatusBar.Panels[1].Text:='当前用户：'+String(fUserName);
    end
    else
    begin
      Application.Terminate;
      Exit;
    end;
  finally
    FormLogin.Free;
  end;
  FDllCloseRecall:= @DllCloseRecall;

  IdTCPClient.Host:= '10.0.0.205';
  IdTCPClient.Port:= 991;
  IdTCPClient.Connect;
  if not IdTCPClient.Connected then
    Application.MessageBox('连接实时消息服务器错误,无法自动刷新数据!', '警告', MB_OK + MB_ICONINFORMATION);
  SendMessageToServer('90');
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
//
end;

function TFormMain.ConnectServer: Boolean;
begin
  Result:= False;
  DMLocal.SocketConnection.Address:='10.0.0.205';
  DMLocal.SocketConnection.Port:=990;
  try
    DMLocal.SocketConnection.Open;
    if DMLocal.SocketConnection.Connected then
      result:=true
  except
    result:=false;
  end;
end;

procedure TFormMain.AddToTab(aForm: TForm);
begin
  if TabSet.Tabs.IndexOf(aForm.Caption)<>-1 then
  begin
    TabSet.TabIndex := TabSet.Tabs.IndexOf(aForm.Caption);
    Exit;
  end;
  TabSet.Tabs.AddObject(aForm.Caption,aForm);
  TabSet.TabIndex:=TabSet.Tabs.IndexOf(aForm.Caption);
end;

procedure TFormMain.DelTab(aForm: TForm);
var
  i:integer;
begin
  for i:=TabSet.Tabs.Count-1 downto 0 do
  begin
    if TabSet.Tabs.Objects[i]= aForm then
    begin
//      TabSet.Tabs.Objects[i].Free;
      TabSet.Tabs.Delete(i);
      break;
    end;
  end;
end;

procedure TFormMain.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  TForm(TabSet.Tabs.Objects[NewTab]).Show;
end;

procedure TFormMain.NRestoreClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to Self.MDIChildCount-1 do
    if Self.MDIChildren[i].Caption=TabSet.tabs.Strings[TabSet.TabIndex] then
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
    if Self.MDIChildren[i].Caption=TabSet.tabs.Strings[TabSet.TabIndex] then
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
    if Self.MDIChildren[i].Caption=TabSet.tabs.Strings[TabSet.TabIndex] then
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
  if Self.MDIChildren[i].Caption = TabSet.Tabs.Strings[TabSet.TabIndex] then
  begin
    DelTab(Self.MDIChildren[i]);
    FDllMgr.FreePlugin(Self.MDIChildren[i]);
    Break;
  end;
end;

procedure DllCloseRecall(aForm: TForm);
begin
  FormMain.DllClose(aForm);
end;

procedure TFormMain.DllClose(aForm: TForm);
begin
  DelTab(aForm);
  FDllMgr.FreePlugin(aForm);
  if TabSet.TabIndex>-1 then
    TForm(TabSet.Tabs.Objects[TabSet.TabIndex]).Show;
end;

procedure TFormMain.WNDProc(var msg: TMessage);
var
  FDllHandle: THandle;
  FPluginName: string;
  CloseForm: TCloseForm;
begin
  inherited;
  if msg.Msg = WM_MSGCLOSE then begin
    FPluginName:= 'Dll\CeShi.dll';
    FDllHandle := LoadLibrary(PChar(extractfilepath(application.ExeName) + FPluginName));
    if FDllHandle = 0 then begin
      raise EDLLLoadError.Create('不能载入 [' + extractfilepath(application.ExeName) + FPluginName + ']模块文件!');
      exit;
    end;
    @CloseForm := GetProcAddress(FDllHandle, 'CloseForm');
    if @CloseForm = nil then exit;
    CloseForm;
  end;
end;

procedure TFormMain.SendMessageToServer(ComID: string);
var
  FUserData: TUserData;
  FCmd: Tcmd;
begin
  try
    if not IdTCPClient.Connected then
       IdTCPClient.Connect();
    if IdTCPClient.Connected then
    begin
      FCmd.Command := StrToInt(ComID);
      FUserData.UserID := 123;
      FUserData.UserNo := 'Test';

      IdTCPClient.WriteBuffer(FCmd,sizeof(TCmd));
      IdTCPClient.WriteBuffer(FUserData,sizeof(TUserData));
    end;
  except
    Application.MessageBox('发送实时消息失败,' + #13 + '请检查应用服务器的实时消息服务是否启动!', '警告', MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TFormMain.SkinMSNStyle1Click(Sender: TObject);
var i: Integer;
begin
  SkinOfficeStyle1.Checked:= False;
  SkinMSNStyle1.Checked:= True;
  SkinWindowsStyle1.Checked:= False;
  i:= TComponent(Sender).Tag;
  SkinData1.LoadFromCollection(SkinStore1,i);
end;

procedure TFormMain.SkinOfficeStyle1Click(Sender: TObject);
var i: Integer;
begin
  SkinOfficeStyle1.Checked:= True;
  SkinMSNStyle1.Checked:= False;
  SkinWindowsStyle1.Checked:= False;
  i:= TComponent(Sender).Tag;
  SkinData1.LoadFromCollection(SkinStore1,i);
end;

procedure TFormMain.SkinWindowsStyle1Click(Sender: TObject);
var i: Integer;
begin
  SkinOfficeStyle1.Checked:= False;
  SkinMSNStyle1.Checked:= False;
  SkinWindowsStyle1.Checked:= True;
  i:= TComponent(Sender).Tag;
  SkinData1.LoadFromCollection(SkinStore1,i);
end;

procedure TFormMain.StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var FRect: TRect; 
begin
  if Panel= StatusBar.Panels[2] then begin
    Panel.Style:= psOwnerDraw;
    StatusBar.Canvas.Brush.Color:=clBlack;
    StatusBar.Canvas.Font.Color:= clGreen;
    StatusBar.Canvas.FillRect(Rect);
    StatusBar.Canvas.TextRect(Rect, Rect.Left, Rect.Top, Panel.Text);

    FRect.Left:= Rect.Left + StatusBar.Canvas.TextWidth('连接服务:');
    FRect.Top:= Rect.Top;
    FRect.Right:= Rect.Right;
    FRect.Bottom:= Rect.Bottom;
    StatusBar.Canvas.Brush.Color:=clRed;
    StatusBar.Canvas.FillRect(FRect);
    StatusBar.Canvas.Font.Color:= clBlack;
    StatusBar.Canvas.TextRect(FRect, FRect.Left, FRect.Top, '10.0.0.205');
  end;
end;

procedure TFormMain.ToolBtnParamConfigClick(Sender: TObject);
var
  FTempForm: TForm;
begin
  try
    FTempForm:= FDllMgr.LoadPlugin('Dll\ParamConfig.dll');
    FTempForm.Show;
    AddToTab(FTempForm);
  except
    FTempForm.Free;
  end;
end;

procedure TFormMain.ToolBtnFtpClick(Sender: TObject);
var
  FTempForm: TForm;
begin
  try
    FTempForm:= FDllMgr.LoadPlugin('Dll\FtpLoad.dll');
    FTempForm.Show;
    AddToTab(FTempForm);
  except
    FTempForm.Free;
  end;
end;

procedure TFormMain.ToolButton2Click(Sender: TObject);
var
  FTempForm: TForm;
begin
  try
    FTempForm:= FDllMgr.LoadPlugin('Dll\GetPingResult.dll');
    FTempForm.Show;
    AddToTab(FTempForm);
  except
    FTempForm.Free;
  end;
end;

procedure TFormMain.ToolButtonDllDemoClick(Sender: TObject);
var
  FTempForm: TForm;
begin
  try
    FTempForm:= FDllMgr.LoadPlugin('Dll\DllDemo.dll');
    FTempForm.Show;
    AddToTab(FTempForm);
  except
    FTempForm.Free;
  end;
end;

procedure TFormMain.ToolButton1Click(Sender: TObject);
var
  FTempForm: TForm;
begin
  try
    FTempForm:= FDllMgr.LoadPlugin('Dll\DllCeShi.dll');
    FTempForm.Show;
    AddToTab(FTempForm);
  except
    FTempForm.Free;
  end;
end;

procedure TFormMain.ToolButtonCloseNowClick(Sender: TObject);
begin
  DelTab(Self.MDIChildren[0]);
  FDllMgr.FreePlugin(Self.MDIChildren[0]);
  if TabSet.TabIndex>-1 then
    TForm(TabSet.Tabs.Objects[TabSet.TabIndex]).Show;
  //用消息的方式关闭dll子窗体
  //PostMessage(self.ActiveMDIChild.Handle, WM_MSGCLOSE, 1, 0);
end;
{var
  i : integer;
begin
  for i := 0 to Self.MDIChildCount-1 do
    if Self.MDIChildren[i].Caption = TabSet.Tabs.Strings[TabSet.TabIndex] then
    begin
      DelTab(Self.MDIChildren[i]);
      FDllMgr.FreePlugin(Self.MDIChildren[i]);
      Break;
    end;
  if TabSet.TabIndex>-1 then
  TForm(TabSet.Tabs.Objects[TabSet.TabIndex]).Show;
end;}

procedure TFormMain.ToolButtonCloseAllClick(Sender: TObject);
var
  i : integer;
begin
  for i := Self.MDIChildCount-1 downto 0 do
  begin
    DelTab(Self.MDIChildren[i]);
    FDllMgr.FreePlugin(Self.MDIChildren[i]);
  end;
end;

procedure TFormMain.ToolButtonExitClick(Sender: TObject);
begin
  close;
end;

end.
