unit Ut_BaseThread;

interface

uses
  Windows, Classes, Log, SysUtils;

const
  ROLL_INTERVAL=300000;
type
  TOnProgress=procedure(Caption:string; Progress:string) of object;
  TMyThread = class(TThread)
  private
    FStop: THandle;
    FCaption: String;
    FRollInterval: Cardinal;
    FProgress: string;
    FOnProgress: TOnProgress;   //退出用事件handle
    procedure DoProgress;
    { Private declarations }
  protected
    FStartTick:Cardinal;   //轮循开始时间,用于避免过度执行

    procedure Execute; override;
    procedure DoExecute;virtual; abstract;
  public
    constructor Create;
    destructor destroy; override;
    procedure SetStop;
  published
    property Caption:String read FCaption write FCaption;
    property Progress:string read FProgress write FProgress;
    {
    property ServerName:string read FServerName write FServerName ;
    property UserName:string read FUserName write FUserName ;
    property UserPwd:string read FUserPwd write FUserPwd ;
    }
    property RollInterval:Cardinal read FRollInterval write FRollInterval;
    property OnProgress: TOnProgress read FOnProgress write FOnProgress;
  end;

implementation

constructor TMyThread.Create;
begin
  inherited create(true);
  FStop := CreateEvent(nil, False, False, nil); // 创建退出用事件
  FRollInterval:=5*60;
end;

destructor TMyThread.destroy;
begin
  inherited destroy;
end;

procedure TMyThread.DoProgress;
begin
  if assigned(FOnProgress) then
    FOnProgress(FCaption,FProgress);
end;

procedure TMyThread.Execute;
var
  lResult,lStartTick,lEndTick,lWaitTick:Cardinal;
begin
  lResult:= WAIT_TIMEOUT;
  repeat
    FProgress:='处理中';
    Synchronize(self.DoProgress);
    lStartTick:=GetTickCount;
    if  lResult= WAIT_TIMEOUT then
    begin
      try
        self.DoExecute;
      except
        On E:Exception do
        begin
          FProgress:='异常'+e.Message;
          Synchronize(self.DoProgress);
        end;
      end;
    end
    else
    if lResult= WAIT_OBJECT_0  then
    begin
      break;
    end;
    lEndTick:= GetTickCount ;
    FProgress:='空闲等待';
    Synchronize(self.DoProgress);

    if abs(lEndTick-lStartTick)>(FRollInterval*1000) then
      lWaitTick:=5*1000
    else
      lWaitTick:=FRollInterval*1000-abs(lEndTick-lStartTick) ;
    lResult := WaitForSingleObject(FStop, lWaitTick) ;   // 等待退出事件置位或 lWaitTick 毫秒后超时退出
  until terminated;
  CloseHandle(FStop);
  FProgress:='关闭';
  Synchronize(self.DoProgress);
end;

procedure TMyThread.SetStop;
begin
  SetEvent(self.FStop);
end;

end.
