{ֱ��վ���Խ�������߳�}
unit UnitDRS_ResultReviceThread;

interface
uses
  Classes,ADODB,DB,SysUtils,IdGlobal,Ut_BaseThread, UntSMSClass;

const
  WD_THREADFUNCTION_NAME = 'ֱ��վ���Ž����߳�';
type
  TDRS_ResultReviceThread = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn :TAdoConnection;
    FQuery :TAdoQuery;
    FQueryFree :TAdoQuery;
    FSMSClass: TSMSClass;            //������
  protected
    procedure DoExecute; override;
  public
    constructor Create(ConStr:String);
    destructor Destroy; override;
  end;

implementation

uses UnitThreadCommon, Ut_Global;

{ TDRS_ResultReviceThread }

constructor TDRS_ResultReviceThread.Create(ConStr: String);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := true;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection :=FConn;
  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection :=FConn;

  //���Žӿ�
  FSMSClass:= TSMSClass.Create(FLog);
end;

destructor TDRS_ResultReviceThread.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;
  //�ͷŶ��Žӿ�
  FSMSClass.FreeSMS;
  FSMSClass.Free;
  inherited;
end;

procedure TDRS_ResultReviceThread.DoExecute;
var
  lCount: integer;
  lSqlstr: string;
  lDeliverResp: TDeliverResp;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write(WD_THREADFUNCTION_NAME+' �޷��������ݿ�!',1);
    Exit;
  end;
  if not FSMSClass.GetActiveSMC then
  begin
    FLog.Write('������Žӿڽ�����ʧ�ܣ�',2);
    exit;
  end;
  lCount:= 0;
  try
    try
      while True do
      begin
        FCounterDatetime:= GetSysDateTime(FQueryFree);
        try
          if not FSMSClass.GetActiveSMC then
            raise exception.Create('������Žӿ���ʧ�ܣ�');
          if FSMSClass.GetDeliverSM(lDeliverResp) then
          begin
            FLog.Write(lDeliverResp.UserData,3);

            inc(lCount);
            lSqlstr:= 'insert into drs_testresult_base'+
                      ' (baseid, testvalue, isprocess, receivedate, enddate, taskid, threadflag) values'+
                      ' (mtu_baseid.nextval, '''+lDeliverResp.UserData+''', '+
                      inttostr(WD_TABLESTATUS_NORMAL)+', sysdate, null, null, null)';
            ExecMySQL(FQueryFree,lSqlstr);
          end;
        except
          on e: Exception do
          begin
            FLog.Write(WD_THREADFUNCTION_NAME+'ִ��ʧ��'+#13+
                       ' ������ʾ��'+E.Message+#13+
                       ' '+lSqlstr,2);
          end;
        end;

        //�ȴ�
        Sleep(3000);

        if lCount=100 then
        begin
          FCurrentDateTime:= GetSysDateTime(FQueryFree);
          FLog.Write('����'+inttostr(lCount)+'�����Ż���'+FormatDatetime('HH:MM:SS��',FCurrentDateTime-FCounterDatetime),3);
          lCount:= 0;
        end;
        //�ֶ��˳�
        if self.IsStop then
          break;
      end;
    except
      on e: Exception do
      begin
        FLog.Write(e.Message,2);
        FLog.Write(WD_THREADFUNCTION_NAME+'   ִ��ʧ��',2);
      end;
    end;
  finally
    FConn.Connected := false;
  end;
end;

end.
