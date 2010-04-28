unit UntBaseDBThread;

interface

uses
  Classes, ADODB, ComCtrls, StdCtrls, SysUtils;

type
  TBaseDBThread = class(TThread)
  private
    RunLogMessage: String;
    reRunLogMessage: TRichEdit;
    btRunThreadState: TButton;
    procedure SyncAppendRunLog;
    procedure SuspendThread;                 //执行完成，暂停线程
    procedure SyncSuspendThread;
    procedure SyncResumeThread;
  protected
    blDebug: boolean;

    Ado_DBConn: TADOConnection;
    Ado_ExecSQL: TADOQuery;
    Ado_Query: TADOQuery;
    
    procedure Execute; override;
    procedure DoExecute; virtual; abstract; //线程执行    内部实现函数
    function  ConnectDB: boolean;   //连接数据库          内部调用函数
    procedure AppendRunLog(RunLog: String; blAlways: boolean=false);   //添加日志  内部调用函数
    procedure ExecSQL(strSQL: string);    //执行SQL       内部调用函数
    procedure OpenQuery(strSQL: string);    //查询数据     内部调用函数
    function  GetBetweenTime(StartTime,EndTime: TDateTime): string; //时间间隔     内部调用函数
    function  GetBetweenSeconds(StartTime,EndTime: TDateTime): Int64; //时间间隔     内部调用函数
  public
    constructor Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);  //数据库连接 日志 恢复线程执行按钮
    destructor Destroy; override;

    procedure ResumeThread;             //恢复线程执行    外部调用函数
  end;

implementation      

constructor TBaseDBThread.Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
begin
  inherited Create(true);

  blDebug := true;

  self.FreeOnTerminate := false;

  reRunLogMessage := reRunLog;
  btRunThreadState := btRunThread;
  
  Ado_DBConn := TADOConnection.Create(nil);
  Ado_DBConn.LoginPrompt:=false;
  //Ado_DBConn.KeepConnection:=false;
  Ado_DBConn.ConnectionString:=DBConn;

  Ado_ExecSQL := TAdoQuery.Create(nil);
  Ado_ExecSQL.Connection := Ado_DBConn;
  Ado_Query := TAdoQuery.Create(nil);
  Ado_Query.Connection := Ado_DBConn;
  Ado_Query.LockType := ltBatchOptimistic;
end;

destructor TBaseDBThread.Destroy;
begin
  Ado_ExecSQL.Close;
  Ado_ExecSQL.Free;
  Ado_Query.Close;
  Ado_Query.Free;

  Ado_DBConn.Close;
  Ado_DBConn.Free;

  inherited;
end;

procedure TBaseDBThread.Execute;
begin
  repeat
    try
      try
        self.DoExecute;
      except
        on E: Exception do
        begin
          self.Terminate;
          AppendRunLog(self.ClassName+'线程执行异常，请通知系统管理员处理！'+E.Message, true);
        end;
      end;
    finally
      if not self.Terminated then SuspendThread;
    end;
  until self.Terminated;

  btRunThreadState.Enabled := true;

  self.FreeOnTerminate := true;
end;

function TBaseDBThread.ConnectDB: boolean;
begin
  try
    Ado_DBConn.Connected:=false;
    Ado_DBConn.Connected:=true;
    Result := true;
  except
    on E: Exception do
    begin
      Result := false;
      AppendRunLog(self.ClassName+'线程打开数据库连接异常！'+E.Message, true);
    end;
  end;
end;

procedure TBaseDBThread.AppendRunLog(RunLog: String; blAlways: boolean=false);
begin
  if blAlways or blDebug then
  begin
    RunLogMessage := RunLog;
    Synchronize(SyncAppendRunLog);
  end;
end;

procedure TBaseDBThread.SyncAppendRunLog;
begin
  reRunLogMessage.Lines.Add(DateTimeToStr(Now)+': '+RunLogMessage);
end;

procedure TBaseDBThread.SuspendThread;
begin
  Synchronize(SyncSuspendThread);
end;

procedure TBaseDBThread.SyncSuspendThread;
begin
  btRunThreadState.Enabled := true;
  self.Suspend;
end;

procedure TBaseDBThread.ResumeThread;
begin
  Synchronize(SyncResumeThread);
end;

procedure TBaseDBThread.SyncResumeThread;
begin
  if btRunThreadState.Enabled then
  begin 
    btRunThreadState.Enabled := false;
    self.Resume;
  end;
end;     

procedure TBaseDBThread.ExecSQL(strSQL: string);
begin
  Ado_ExecSQL.Close;
  Ado_ExecSQL.SQL.Clear;
  Ado_ExecSQL.SQL.Add(strSQL);
  Ado_ExecSQL.ExecSQL;
  Ado_ExecSQL.Close;
end;

procedure TBaseDBThread.OpenQuery(strSQL: string);
begin
  Ado_Query.Close;
  Ado_Query.SQL.Clear;
  Ado_Query.SQL.Add(strSQL);
  Ado_Query.Open;
end;

function TBaseDBThread.GetBetweenTime(StartTime, EndTime: TDateTime): string;
var
  Days,Hours,Minutes,Seconds: Int64;
  sResult: string;
begin
  if EndTime>StartTime then
    Seconds := Trunc(60*60*24*(EndTime-StartTime))
  else
    Seconds := Trunc(60*60*24*(StartTime-EndTime));

  Days := Seconds div (60*60*24);
  Seconds := Seconds - Days*60*60*24;
  Hours := Seconds div (60*60);
  Seconds := Seconds - Hours*60*60;
  Hours := Seconds div (60*60);
  Seconds := Seconds - Hours*60*60; 
  Minutes := Seconds div 60;
  Seconds := Seconds - Minutes*60;

  sResult := '';
  if Days>0 then
    sResult := sResult+IntToStr(Days)+'天';
  if (Days+Hours)>0 then
    sResult := sResult+IntToStr(Hours)+'小时';
  if (Days+Hours+Minutes)>0 then
    sResult := sResult+IntToStr(Minutes)+'分';  
  sResult := sResult+IntToStr(Seconds)+'秒。';

  Result := sResult;

end;

function TBaseDBThread.GetBetweenSeconds(StartTime, EndTime: TDateTime): Int64;
begin
  if EndTime>StartTime then
    Result := Trunc(60*60*24*(EndTime-StartTime))
  else
    Result := Trunc(60*60*24*(StartTime-EndTime));
end;

end.
