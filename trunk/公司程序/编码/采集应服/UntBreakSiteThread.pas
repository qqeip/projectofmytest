unit UntBreakSiteThread;

interface

uses
  Classes, UntBaseDBThread, ADODB, ComCtrls, StdCtrls, DB, Variants, SysUtils;

type
  TBreakSiteThread = class(TBaseDBThread)
  private
    Sp_ALARM_REP_BREAKSITE: TADOStoredProc;

    procedure CallBreakSiteProc;    //断站率统计
  protected
    procedure DoExecute; override;
  public
    constructor Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
    destructor Destroy; override;
  end;

implementation

{ UntBreakSiteThread }


{ TBreakSiteThread }

constructor TBreakSiteThread.Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
begin
  inherited Create(DBConn, reRunLog, btRunThread);

  blDebug := false;

  Sp_ALARM_REP_BREAKSITE:= TADOStoredProc.Create(nil);
  with Sp_ALARM_REP_BREAKSITE do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='wd_alarm_rep_breaksite';
     Parameters.Clear;
     //Parameters.CreateParameter('VCityid',ftString,pdInput,100,null);
     //Parameters.CreateParameter('VOPERATOR',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);

     Prepared;
  end;
end;

destructor TBreakSiteThread.Destroy;
begin
  Sp_ALARM_REP_BREAKSITE.Close;
  Sp_ALARM_REP_BREAKSITE.Free;

  inherited;
end;

procedure TBreakSiteThread.DoExecute;
var
  StartTime,EndTime: TDateTime;
begin 
  self.AppendRunLog('开始执行 WD_ALARM_REP_BREAKSITE 存储过程。。。');
  StartTime := Now;

  if not ConnectDB then exit;

  CallBreakSiteProc;

  EndTime := Now;
  self.AppendRunLog('WD_ALARM_REP_BREAKSITE 存储过程 执行完成。本次执行共花费时间：'+ GetBetweenTime(StartTime, EndTime));  
end;

procedure TBreakSiteThread.CallBreakSiteProc;
var
  i: integer;
begin  
  with Sp_ALARM_REP_BREAKSITE do
  begin
    close;
    //Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//城市编号
    //Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
    try
      execproc;
      i:=Parameters.parambyname('iError').Value; //返回值为整型，
      if i<>0 then
        self.AppendRunLog('WD_ALARM_REP_BREAKSITE 存储过程执行出错！ 错误编号：'+IntToStr(i), true);   
      close;
    except
      self.AppendRunLog('调用 WD_ALARM_REP_BREAKSITE 存储过程出错！可能是参数不一致!', true); 
    end;
  end; 

end;

end.
