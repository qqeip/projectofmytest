unit UntBreakSiteThread;

interface

uses
  Classes, UntBaseDBThread, ADODB, ComCtrls, StdCtrls, DB, Variants, SysUtils;

type
  TBreakSiteThread = class(TBaseDBThread)
  private
    Sp_ALARM_REP_BREAKSITE: TADOStoredProc;

    procedure CallBreakSiteProc;    //��վ��ͳ��
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
  self.AppendRunLog('��ʼִ�� WD_ALARM_REP_BREAKSITE �洢���̡�����');
  StartTime := Now;

  if not ConnectDB then exit;

  CallBreakSiteProc;

  EndTime := Now;
  self.AppendRunLog('WD_ALARM_REP_BREAKSITE �洢���� ִ����ɡ�����ִ�й�����ʱ�䣺'+ GetBetweenTime(StartTime, EndTime));  
end;

procedure TBreakSiteThread.CallBreakSiteProc;
var
  i: integer;
begin  
  with Sp_ALARM_REP_BREAKSITE do
  begin
    close;
    //Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//���б��
    //Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
    try
      execproc;
      i:=Parameters.parambyname('iError').Value; //����ֵΪ���ͣ�
      if i<>0 then
        self.AppendRunLog('WD_ALARM_REP_BREAKSITE �洢����ִ�г��� �����ţ�'+IntToStr(i), true);   
      close;
    except
      self.AppendRunLog('���� WD_ALARM_REP_BREAKSITE �洢���̳��������ǲ�����һ��!', true); 
    end;
  end; 

end;

end.
