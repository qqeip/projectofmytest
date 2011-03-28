unit UnitServerMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Sockets, ExtCtrls, StdCtrls, Buttons, IdBaseComponent,
  IdComponent, IdTCPServer;

type
  TCmd = record
    command: integer;
  end;

  TFormServerMain = class(TForm)
    Panel4: TPanel;
    Label2: TLabel;
    Lb_ClientCount: TLabel;
    Panel2: TPanel;
    Panel_Broad: TPanel;
    Btn_BroadCast: TSpeedButton;
    MsgInfo: TMemo;
    Panel3: TPanel;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Status: TStatusBar;
    ListView: TListView;
    IdTCPServer: TIdTCPServer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure IdTCPServerConnect(AThread: TIdPeerThread);
    procedure IdTCPServerDisconnect(AThread: TIdPeerThread);
    procedure IdTCPServerExecute(AThread: TIdPeerThread);
  private
    FCr :Trtlcriticalsection;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormServerMain: TFormServerMain;

implementation

uses UnitCommon;


{$R *.dfm}

procedure TFormServerMain.FormCreate(Sender: TObject);
begin
  InitializeCriticalSection(FCr);
  IdTCPServer.Bindings.Add.IP:= '10.0.0.205';
  IdTCPServer.Bindings.Add.Port:= 991;
  IdTCPServer.Active:= True;
  if not IdTCPServer.Active then
  begin
    if Application.MessageBox(pchar('实时消息服务启动失败,消息通知将无法发送给客户端,是否退出程序？'), '警告', mb_okcancel + mb_defbutton1) = IDOK then
       Application.Terminate;
  end;
end;

procedure TFormServerMain.FormShow(Sender: TObject);
begin
//
end;

procedure TFormServerMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormServerMain.FormDestroy(Sender: TObject);
begin
  DeleteCriticalSection(FCr);
end;

procedure TFormServerMain.IdTCPServerConnect(AThread: TIdPeerThread);
begin
//
end;

procedure TFormServerMain.IdTCPServerDisconnect(AThread: TIdPeerThread);
begin
//
end;

procedure TFormServerMain.IdTCPServerExecute(AThread: TIdPeerThread);
var
  FCmd: TCmd;
  FUserData: TUserData;
  FListItem: TListItem;
begin
  if ((not AThread.Terminated) and (AThread.Connection.Connected)) then
  begin
    AThread.Connection.ReadBuffer(FCmd, SizeOf(TCmd));
    case FCmd.command of
     90: begin
           AThread.Connection.ReadBuffer(FUserData, SizeOf(TUserData));
           EnterCriticalSection(FCr); //加入临界区,避免多线程操作VCL控件
           try
             FListItem:= ListView.Items.Add;
             FListItem.Caption:= AThread.Connection.Socket.Binding.PeerIP;//'10.0.0.205';//FNewUserData.IP;
             FListItem.SubItems.Add(IntToStr(FUserData.UserID));
             FListItem.SubItems.Add(FUserData.UserNo);
             FListItem.SubItems.Add(DateTimeToStr(FUserData.ConnectTime));
           finally
            LeaveCriticalSection(FCr);
           end;
         end;
    end;
  end;
end;

end.
