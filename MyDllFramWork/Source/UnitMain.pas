unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, ComCtrls, Tabs, ImgList, ToolWin, UnitDllMgr,
  WinSkinData;

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
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    DllTest11: TMenuItem;
    DllDemo1: TMenuItem;
    Help1: TMenuItem;
    Exit1: TMenuItem;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButtonDllTest: TToolButton;
    ToolButtonDllDemo: TToolButton;
    ToolButton3: TToolButton;
    ToolButtonCloseNow: TToolButton;
    ToolButtonCloseAll: TToolButton;
    ToolButtonExit: TToolButton;
    ToolButton7: TToolButton;
    SkinData1: TSkinData;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButtonDllTestClick(Sender: TObject);
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
  private
    FDllMgr: TPluginMgr;
    procedure AddToTab(aForm: TForm);
    procedure DelTab(aForm: TForm);
    procedure DllClose(aForm: TForm);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  procedure DllCloseRecall(aForm: TForm);stdcall;
implementation

uses UnitLogIn;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FDllMgr:= TPluginMgr.Create;
end;

procedure TFormMain.FormShow(Sender: TObject);
var fUserName,fUserPwd: string;
begin
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
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
//
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

procedure TFormMain.ToolButtonDllTestClick(Sender: TObject);
var
  FTempForm: TForm;
begin
  try
    FTempForm:= FDllMgr.LoadPlugin('Dll\DllTest.dll');
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

procedure TFormMain.ToolButtonExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormMain.ToolButtonCloseNowClick(Sender: TObject);
begin
  DelTab(Self.MDIChildren[0]);
  FDllMgr.FreePlugin(Self.MDIChildren[0]);
  if TabSet.TabIndex>-1 then
    TForm(TabSet.Tabs.Objects[TabSet.TabIndex]).Show;
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

end.
