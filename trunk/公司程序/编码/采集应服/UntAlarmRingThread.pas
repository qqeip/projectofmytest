unit UntAlarmRingThread;

interface

uses
  Classes, UntBaseDBThread, ADODB, ComCtrls, StdCtrls, DB, Variants, SysUtils;

type
  TAlarmRingThread = class(TBaseDBThread)
  private
    Sp_ALARM_RINGREMIND: TADOStoredProc;

    procedure CallAlarmRing;    //新告警提醒
  protected
    procedure DoExecute; override;
  public
    constructor Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
    destructor Destroy; override;
  end;

implementation

constructor TAlarmRingThread.Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
begin
  inherited Create(DBConn, reRunLog, btRunThread);

  blDebug := false;

  Sp_ALARM_RINGREMIND:= TADOStoredProc.Create(nil);
  with Sp_ALARM_RINGREMIND do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='Alarm_Ring_Remind';
     Parameters.Clear;
     //Parameters.CreateParameter('VCityid',ftString,pdInput,100,null);
     //Parameters.CreateParameter('VOPERATOR',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);

     Prepared;
  end;
end;

destructor TAlarmRingThread.Destroy;
begin
  Sp_ALARM_RINGREMIND.Close;
  Sp_ALARM_RINGREMIND.Free;

  inherited;
end;

procedure TAlarmRingThread.DoExecute;
begin  
  self.AppendRunLog('执行 Alarm_Ring_Remind 存储过程。');
  CallAlarmRing;
end;

procedure TAlarmRingThread.CallAlarmRing;
var
  i: integer;
begin
  with Sp_ALARM_RINGREMIND do
  begin
    close;
    //Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//城市编号
    //Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
    try
      execproc;
      i:=Parameters.parambyname('iError').Value; //返回值为整型，
      if i<>0 then
        self.AppendRunLog('Alarm_Ring_Remind 存储过程执行出错！ 错误编号：'+IntToStr(i), true);
      close;
    except
      self.AppendRunLog('调用 Alarm_Ring_Remind 存储过程出错！可能是参数不一致!', true);
    end;
  end; 

end;

end.
