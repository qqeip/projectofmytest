unit UnitIDTCPClient;
{  00 �㲥
  90 �ͻ��˵�¼
  98 �ͻ����˳� ������ת
  99 Ӧ�÷�����Ҫ�˳�
  1  ɾ���澯
  2  ����ȷ��
  3  ת��
  5  ����
  51 �Զ�����
  52 ��Ϊ��Ԥ����
  53 �ֶ�����
  6  ����
  7  �ύ
  8  ��������
  9  ����}

interface
uses Classes,Controls,SysUtils,StdCtrls,ComCtrls,Windows,WinSock,IdTCPClient,IdSocketHandle, UnitVFMSGlobal, UnitDllCommon;
type
  {�û���Ϣ����}
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
  {------------------------------ͨѶ�ͻ�����Ϣ��-------------------------}
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
    FConeected:Boolean;//�����Ƿ�ɹ�
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
      //��������������
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
 