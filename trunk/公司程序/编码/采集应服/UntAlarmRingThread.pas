unit UntAlarmRingThread;

interface

uses
  Classes, UntBaseDBThread, ADODB, ComCtrls, StdCtrls, DB, Variants, SysUtils;

type
  TAlarmRingThread = class(TBaseDBThread)
  private
    Sp_ALARM_RINGREMIND: TADOStoredProc;

    procedure CallAlarmRing;    //�¸澯����
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
  self.AppendRunLog('ִ�� Alarm_Ring_Remind �洢���̡�');
  CallAlarmRing;
end;

procedure TAlarmRingThread.CallAlarmRing;
var
  i: integer;
begin
  with Sp_ALARM_RINGREMIND do
  begin
    close;
    //Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//���б��
    //Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
    try
      execproc;
      i:=Parameters.parambyname('iError').Value; //����ֵΪ���ͣ�
      if i<>0 then
        self.AppendRunLog('Alarm_Ring_Remind �洢����ִ�г��� �����ţ�'+IntToStr(i), true);
      close;
    except
      self.AppendRunLog('���� Alarm_Ring_Remind �洢���̳��������ǲ�����һ��!', true);
    end;
  end; 

end;

end.
