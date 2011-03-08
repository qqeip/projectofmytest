unit fServerForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uROClient, uROPoweredByRemObjectsButton, uROClientIntf, uROServer,
  uROBinMessage, uROBPDXTCPServer, Menus,unHook, ComCtrls,adodb, unTrayIcon;

type
  TServerForm = class(TForm)
    ROMessage: TROBinMessage;
    ROServer: TROBPDXTCPServer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    mitmAutoRun: TMenuItem;
    N8: TMenuItem;
    Memo1: TMemo;
    sttbMain: TStatusBar;
    CoolTrayIcon1: TCoolTrayIcon;
    PopupMenu: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N10: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure mitmAutoRunClick(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    FConnectionString:String;
    HookList:TWinHookList;
    procedure AutoStartServer;
    function GetConnectionString: string;
    procedure RefreshStatusBar(Online: Integer);
    procedure SetStatusBar(stabTemp: TStatusBar; intPanel: integer;
      strText: string);
    procedure StartServer;
    function StopService: boolean;
    procedure IniUserInterFace;
    procedure OnMemRecMessage(Sender: TObject; Handle: HWnd;
      var Msg: TMessage; var Handled: Boolean);
    procedure ResetMemo(HWindow: HWnd; LParam: LongWord);
    procedure SetAppAutoRun(boolAutoRun: boolean);
  public
     property ConnectionString : string read GetConnectionString;
  end;

var
  ServerForm: TServerForm;

implementation


{$R *.dfm}
 uses
   Ado_ConnectionPool,gunFunSys;
function TServerForm.GetConnectionString: string;
begin
  result :=FConnectionString;
end;
procedure TServerForm.AutoStartServer;
var
  strPort:string;
begin
  GetRegStr(gcstrRegKey+'port','Port',strPort,False);
  with ROServer do
  begin
	 if Active=false then
    begin
     Port:=StrtoIntDef(strPort,4325);
     try
		   Active:=True;
     except
       on e:exception do
       begin
         showmessage(e.Message);
         exit;
       end;
     end;
		 RefreshStatusBar(ROServer.BPDXServer.ActiveNumberOfConnections);
    end;
  end;
end;
procedure TServerForm.SetStatusBar(stabTemp: TStatusBar; intPanel: integer;
  strText: string);  // 设置任务栏
begin
  while intPanel >= stabTemp.Panels.Count  do
    stabTemp.Panels.Add;
  stabTemp.Panels.Items[intPanel].Text:=strText;
end;
procedure TServerForm.StartServer;
var
  strPort:string;
begin
  with ROServer do
  begin
	 if Active=false then
    begin
      strPort:='4325';
      if not InputQuery('服务端口','请录入要开放的端口数值',strPort) then Exit;
      try
		  Port:=strtoint(strPort);
      except
		  Application.MessageBox('非法的端口数值！','提示信息',MB_ICONWARNING);
        exit;
      end;
	    Active:=True;
       SetRegStr(gcstrRegKey+'Port','Port',strPort);
	    RefreshStatusBar(0);
    end
    else
    begin
      Application.MessageBox('服务已启动,必须先停止服务后再启动！', '系统提示', MB_ICONWARNING +  mb_OK);
      exit;
    end;
  end;
end;

function TServerForm.StopService: boolean;
var
  ClientsOnline:integer;
begin
  result:=false;
  ClientsOnline:=ROServer.BPDXServer.ActiveNumberOfConnections;
  if (ClientsOnline > 0) and (ROServer.Active) then
  begin
     if MessageDlg(pchar('还有'+inttostr(ClientsOnline)
     +'个用户在线,你是否真的要停止服务?'), mtConfirmation, [mbYes, mbNo], 0) <> idYes then
      Exit;
  end;
  ROServer.Active:=False;
  Result:=True;
  RefreshStatusBar(0);
end;
procedure TServerForm.RefreshStatusBar(Online:Integer);
begin
  try
   with ROServer do
   begin
     if Active then
       SetStatusBar(sttbMain,0,'  <<服务启动>>')
     else
       SetStatusBar(sttbMain,0,'  <<服务关闭>>');
     if (Port=0) or (not Active) then
       SetStatusBar(sttbMain,1,'  监听端口：')
     else
       SetStatusBar(sttbMain,1,'  监听端口：'+inttostr(Port));

     if (Port=0) or (not Active) then
       SetStatusBar(sttbMain,2,'  主机名：')
     else
       SetStatusBar(sttbMain,2,'  主机名：'+'');
     SetStatusBar(sttbMain,3,'  在线用户数：'+inttostr(Online));
     SetStatusBar(sttbMain,4,'系统参数初始化完毕。');
   end;
  except
  end;
end;
procedure TServerForm.FormCreate(Sender: TObject);
var
   hook1:TWinHook;
begin
  try
    IniUserInterFace;
    ConnectionPools.ConnectionString:=ConnectionString;
    RefreshStatusBar(0);
    HookList:=TWinHookList.Create(self);
    HookList.BeforeMessage:=OnMemRecMessage;
    hook1:=TWinHook.Create(HookList);
    hook1.WinControl:=Memo1;
    HookList.Add(hook1);
    HookList.Active:=true;
  except
    
  end;
end;

procedure TServerForm.N5Click(Sender: TObject);
var
 tmpStr:string;
begin
   tmpStr:=FConnectionString;
   FConnectionString := PromptDataSource(Handle,
                        FConnectionString);
   SetRegDbConnstr(FConnectionString);
   ConnectionPools.ConnectionString:=ConnectionString;
   if tmpStr<> FConnectionString then
   begin
     Application.MessageBox('连接参数已改变请重新启动程序！','提示信息',MB_ICONWARNING);
     Application.Terminate;
     Exit;
   end;
end;

procedure TServerForm.N3Click(Sender: TObject);
begin
   StartServer;
end;

procedure TServerForm.N4Click(Sender: TObject);
begin
   StopService;
end;

procedure TServerForm.mitmAutoRunClick(Sender: TObject);
begin
  mitmAutoRun.Checked:=not mitmAutoRun.Checked;
  MenuItem1.Checked := mitmAutoRun.Checked;
  SetAppAutoRun(mitmAutoRun.Checked);
end;
procedure TServerForm.SetAppAutoRun(boolAutoRun:boolean);
begin
  if boolAutoRun then
     SetRegStr('SOFTWARE\Microsoft\Windows\CurrentVersion\Run','UnitServer',Application.Exename)
  else
     DelRegStr('SOFTWARE\Microsoft\Windows\CurrentVersion\Run','UnitServer');
end;
procedure TServerForm.IniUserInterFace;
var
  strTmp:string;
begin
  strTmp:='';
  SetFilePara;
  GetRegStr('SOFTWARE\Microsoft\Windows\CurrentVersion\Run\','UnitServer',strTmp,False);
  GetRegConnstr(FConnectionString);
  mitmAutoRun.Checked:=(trim(strTmp)<>'');
  MenuItem1.Checked:=mitmAutoRun.Checked;
  if mitmAutoRun.Checked then
    AutoStartServer
end;

procedure TServerForm.OnMemRecMessage(Sender: TObject; Handle: HWnd;
  var Msg: TMessage; var Handled: Boolean);
begin
  if (((msg.Msg=EM_REPLACESEL) and (not((msg.WParam=0) and (strpas(pchar(msg.LParam))=''))))) then
    ResetMemo(Handle,Msg.LParam);
end;
procedure TServerForm.ResetMemo(HWindow: HWnd;LParam:LongWord);
  procedure Clear;
  begin
    SetWindowText(HWindow, '');
  end;
  procedure DeleteLine(Index: Integer);
  const
    Empty: PChar = '';
  var
    SelStart, SelEnd: Integer;
  begin
    SelStart := SendMessage(HWindow, EM_LINEINDEX, Index, 0);
    if SelStart >= 0 then
    begin
      SelEnd := SendMessage(HWindow, EM_LINEINDEX, Index + 1, 0);
      if SelEnd < 0 then SelEnd := SelStart +
        SendMessage(HWindow, EM_LINELENGTH, SelStart, 0);
      SendMessage(HWindow, EM_SETSEL, SelStart, SelEnd);
      SendMessage(HWindow, EM_REPLACESEL, 0, Longint(Empty));
    end;
  end;
  Function GetMemoText:string;
  var
    Len: Integer;
  begin
    Len := GetWindowTextLength(HWindow);
    SetString(Result, PChar(nil), Len);
    if Len <> 0 then
    GetWindowText(HWindow,Pointer(Result), Len + 1)
  end;
  function GetLine(Index: Integer): string;
  var
  Text: array[0..4095] of Char;
  begin
    Word((@Text)^) := SizeOf(Text);
    SetString(Result, Text, SendMessage(HWindow, EM_GETLINE, Index,
    Longint(@Text)));
  end;
  function GetLineCount: Integer;
  begin
    Result := 0;
    Result := SendMessage(HWindow, EM_GETLINECOUNT, 0, 0);
    if SendMessage(HWindow, EM_LINELENGTH, SendMessage(HWindow,
      EM_LINEINDEX, Result - 1, 0), 0) = 0 then Dec(Result);
  end;
var
  strData:string;
begin
  strData:=strpas(pchar(LParam));
  //删除Memo中最后的两个字符：#13+#10
  //因为Lparam是有API传过来的，而BORLAND为MICRSOFT API的后面加了#13+#10
  if copy(strData,length(strData)-1,2)=#13+#10 then
    delete(strData,length(strData)-1,2);
  if Memo1.Handle=HWindow then
    SaveTransInfoToFile(0,strData);
  while GetMemoLineCount(HWindow)>=strtoint(gdtInfo.strMemoMaxLine) do
  begin
    if gdtInfo.strMemoMaxLineProcMode='0' then clear;
    if gdtInfo.strMemoMaxLineProcMode='1' then  DeleteLine(0);
  end;
end;
procedure TServerForm.MenuItem3Click(Sender: TObject);
begin
  CoolTrayIcon1.ShowMainForm;
  self.WindowState:=wsNormal;
end;

procedure TServerForm.N8Click(Sender: TObject);
begin
  if  StopService then
  PostMessage(self.Handle, WM_QUIT, 0, 0);
  Exit;
end;

procedure TServerForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   CoolTrayIcon1.HideMainForm;
  Action:=caNone;
end;

procedure TServerForm.FormDestroy(Sender: TObject);
begin
  if assigned(HookList) then FreeAndNil(HookList);
end;

end.
