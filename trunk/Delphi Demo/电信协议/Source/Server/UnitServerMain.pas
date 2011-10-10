unit UnitServerMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Sockets, ExtCtrls, StdCtrls, Buttons, IdBaseComponent,
  IdComponent, IdTCPServer;

type
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
    procedure Btn_BroadCastClick(Sender: TObject);
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
  IdTCPServer.Bindings.Add.IP:= '127.0.0.1';
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
var FUserData: TUserData;
begin
  FUserData.Thread:= AThread;
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
  //Tcp下载用的变量
  RecevFileName:string;
  iFileHandle:integer;
  iFileLen,cnt:integer;
  buf:array[0..4096] of byte;
begin
  if ((not AThread.Terminated) and (AThread.Connection.Connected)) then
  begin
    //FTP下载
    with AThread.Connection do
    begin
      Try
        RecevFileName:=AThread.Connection.ReadLn;//获取文件全路径
        if FileExists(RecevFileName) then
        begin
          Try
            WriteLn(RecevFileName);//发送全路径
            iFileHandle:=FileOpen(RecevFileName,fmOpenRead); //得到此文件大小
            iFileLen:=FileSeek(iFileHandle,0,2);
            FileSeek(iFileHandle,0,0);
            AThread.Connection.WriteInteger(iFileLen,True);////hjh 20071009

            while iFileLen >0 do
            begin
              if IFileLen > 4096 then
              begin
                cnt:=FileRead(iFileHandle,buf,4096);
                AThread.Connection.WriteBuffer(buf,cnt,True);/////hjh20071009
                iFileLen:=iFileLen-cnt;
              end
              else
              begin
                cnt:=FileRead(iFileHandle,buf,iFileLen);
                AThread.Connection.WriteBuffer(buf,cnt,True);/////hjh20071009
                iFileLen:=iFileLen-cnt;
              end;
            end;
          Finally
            FileClose(iFileHandle);
          end;
        end
        else
        begin
          WriteLn('文件不存在');
        end;
      Finally
        Disconnect;//断开连接
      end;
    end;
    //消息通知 登陆信息
    AThread.Connection.ReadBuffer(FCmd, SizeOf(TCmd));
    case FCmd.command of
     90: begin
           AThread.Connection.ReadBuffer(FUserData, SizeOf(TUserData));
           FUserData.IP:= AThread.Connection.Socket.Binding.PeerIP;
           FUserData.ConnectTime:= Now;
           EnterCriticalSection(FCr); //加入临界区,避免多线程操作VCL控件
           try
             FListItem:= ListView.Items.Add;
             FListItem.Caption:= FUserData.IP;//'10.0.0.205';//FNewUserData.IP;
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

procedure TFormServerMain.Btn_BroadCastClick(Sender: TObject);
var
  FCmd: TCmd;
  FUserData: TUserData;
  FBroadMsg: TBroadMsg;
  FThread: TIdPeerThread;
begin
  FCmd.Command:= 100; //100为广播消息
  FBroadMsg.Msg:= MsgInfo.Lines.Text;
  FThread:= FUserData.Thread;
  FThread.Connection.WriteBuffer(FCmd, SizeOf(TCmd));
  FThread.Connection.WriteBuffer(FBroadMsg, SizeOf(TBroadMsg));
end;

end.
