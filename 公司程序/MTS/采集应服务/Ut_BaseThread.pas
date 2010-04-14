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
    FLog: TLog;
    FCaption: String;
    FRollInterval: Cardinal;
    FProgress: string;
    FOnProgress: TOnProgress;
    FIsStop: boolean;   //退出用事件handle
    procedure DoProgress;
    procedure SetIsStop(const Value: boolean);
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
    property Log:TLog read FLog write FLog;
    {
    property ServerName:string read FServerName write FServerName ;
    property UserName:string read FUserName write FUserName ;
    property UserPwd:string read FUserPwd write FUserPwd ;
    }
    property RollInterval:Cardinal read FRollInterval write FRollInterval;
    property OnProgress: TOnProgress read FOnProgress write FOnProgress;
    property IsStop: boolean read FIsStop write SetIsStop;
  end;

implementation

constructor TMyThread.Create;
begin
  inherited create(true);
  FStop := CreateEvent(nil, False, False, nil); // 创建退出用事件
  FRollInterval:=5*60;
  FIsStop:= false;
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
  Log.Write(FCaption+'启动...',3);
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
          Log.Write(FCaption+'异常'+e.Message,1);
      end;
    end
    else
    if lResult= WAIT_OBJECT_0  then
    begin
      Log.Write(FCaption+'退出信号...',3);
      break;
    end;
    lEndTick:= GetTickCount ;
    FProgress:='空闲等待';
    Synchronize(self.DoProgress);

    if abs(lEndTick-lStartTick)>(FRollInterval*1000) then
      lWaitTick:=5*1000
    else
      lWaitTick:=FRollInterval*1000-abs(lEndTick-lStartTick) ;
    Log.Write(FCaption+'等待...'+IntToStr(lWaitTick),3);
    lResult := WaitForSingleObject(FStop, lWaitTick) ;   // 等待退出事件置位或 lWaitTick 毫秒后超时退出
  until terminated;
  CloseHandle(FStop);
  FIsStop:= false;
  Log.Write(FCaption+'关闭...',3);
end;

procedure TMyThread.SetIsStop(const Value: boolean);
begin
  FIsStop := Value;
end;

procedure TMyThread.SetStop;
begin
  Log.Write(FCaption+'释放开始...',3);
  SetEvent(self.FStop);
  FIsStop:= true;
end;

end.
