unit UnitIDTCPClient;
{  00 广播
  90 客户端登录
  98 客户端退出 其他中转
  99 应用服务器要退出
  1  删除告警
  2  疑难确认
  3  转发
  5  派障
  51 自动派障
  52 人为干预派障
  53 手动派障
  6  排障
  7  提交
  8  疑难申请
  9  消障}

interface
uses Classes,Controls,SysUtils,StdCtrls,ComCtrls,Windows,WinSock,IdTCPClient,IdSocketHandle, UnitVFMSGlobal, UnitDllCommon;
type
  {用户信息类型}
  Ruserdata = record
    userid :integer;
    userno :String[20];
    CompanyID :integer;
    cityid :integer;
    parentid :integer;
    Filter :String[20];
    ParentList :String[200];
    ChildList :String[200];
  end;
  RBroadData = record
    msg :String[255];
  end;
  {------------------------------通讯客户端消息程-------------------------}
  TClientMsg = record
      UserNo,DeptNo,DeptType,ParentNo,CmdID :String;
  end;
  TClientMessageThread = class(TThread)
  private
    userdata: Ruserdata;
    cmd: Rcmd;
    procedure HandleMessage101;
  protected
    constructor Create();
    procedure Execute; override;
  public
    FTCPClient:TIdTCPClient;
  end;
  {-----------------------------------------------------------------------}
  TTCPClient=Class(TObject)
  Private
    FClientThread :TClientMessageThread ; 
  Public
    FTCPClient:TIdTCPClient;
    FConeected:Boolean;//连接是否成功
    Constructor Create(aHost:String;aPort:Integer);
    Destructor Destroy ; override;
    function Connect:integer;
  end;
var
  ServerMsg:String;
implementation

uses UnitAlarmTracker;

{ TTCPClient }

function TTCPClient.Connect: integer;
begin
  Result:=0;
  try
    FTCPClient.Connect(10000);
    FConeected:=True;
    FClientThread := TClientMessageThread.Create();
    FClientThread.FTCPClient:=FTCPClient;
    FClientThread.FreeOnTerminate := false;
    FClientThread.Resume;
    Result:=1;
  except
    Result:=-1;
  end;
end;

constructor TTCPClient.Create(aHost:String;aPort:Integer);
begin
  FTCPClient:=TIdTCPClient.Create(nil);
  FTCPClient.Host := aHost;//FMsgServerIP;
  FTCPClient.Port := aPort;//FMsgPort;
end;

destructor TTCPClient.Destroy;
begin
  if FConeected then  FTCPClient.Disconnect;
  if Assigned(FClientThread) and (not FClientThread.Terminated) then
  begin
    FClientThread.Terminate;
    if FClientThread.Suspended then
       FClientThread.Resume;
    FClientThread.WaitFor;
    FClientThread.Free;
  end;
  FTCPClient.Free;
  inherited;
end;

{ TClientMessageThread }

constructor TClientMessageThread.Create;
begin
  inherited Create(true);
end;

procedure TClientMessageThread.Execute;
begin
  inherited;
  while (not Terminated) and (FTCPClient.Connected) do
  begin
    try
      FTCPClient.ReadBuffer(cmd,sizeof(Rcmd));
      //按照命令来处理
      case cmd.command of
        101:
          begin
            Synchronize(HandleMessage101);
          end;
      end;
    except
      //Terminate;
    end;
  end;
end;

procedure TClientMessageThread.HandleMessage101;
begin
  if cmd.NodeCode = TNodeParam(FormAlarmTracker.cxTreeView1.Selected.Data).NodeCode then
    FormAlarmTracker.cxTreeView1Change(self,FormAlarmTracker.cxTreeView1.Selected);
end;

end.
 