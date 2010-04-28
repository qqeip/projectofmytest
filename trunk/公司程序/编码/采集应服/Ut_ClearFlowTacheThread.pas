unit Ut_ClearFlowTacheThread;

interface

uses
  Windows,Classes,ADODB, SysUtils, ComCtrls,DB, Controls, StrUtils,Forms, Variants,Messages,Ut_common;
const
  WM_THREAD_MSG  = WM_USER + 100;

type
  TDoWhat = class
    ifRepStat,
    ifClearLog ,
    ifDayReport : Boolean;
  end;

type
  TClearFlowTacheThread = class(TThread)
  private
    { Private declarations }
    AdoC : TADOConnection;
    AdoQ: TADOQuery;
    Sp_RepItemStat: TADOStoredProc;
    Sp_DayReportStat: TADOStoredProc;
    MessageContent:String;
    ButtonIsEnable:Boolean;
    //�����Ϣ��������־
    procedure AppendRunLog();
    procedure RepItemStat(StatDate:TDateTime); //ͳ�����ϱ���
    function IfStated(kind : integer;idate :TDate) :Boolean;
    procedure RepStat_IsEnable();
    procedure FlowLog_IsEnable();
    function GetSysDateTime():TDateTime;  //�õ����ݿ������ʱ��
  protected
    procedure Execute; override;
  public
    DoWhat :TDoWhat;
    constructor Create(DBConn:string);
    destructor Destroy;override;

    //�����־
    procedure ClearFlowTacheLog;
    function GetDay(Kind : Integer) : Integer;
  end;

implementation               
uses Ut_Data_Local,Ut_RunLog,Ut_Flowtache_Monitor;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TClearFlowTacheThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TClearFlowTacheThread }

//���á���ť���Ƿ����
procedure TClearFlowTacheThread.RepStat_IsEnable();
begin
   Fm_FlowMonitor.Bt_RepStat.Enabled:=ButtonIsEnable;
end;


procedure TClearFlowTacheThread.FlowLog_IsEnable();
begin
   Fm_FlowMonitor.Bt_FlowLog.Enabled:=ButtonIsEnable;
end;

procedure TClearFlowTacheThread.RepItemStat(StatDate:TDateTime); //ͳ�����ϱ���
var
  starttime,endtime:TTime;
  AData :PThreadData;
begin
  try
    ButtonIsEnable:=false;
    Synchronize(RepStat_IsEnable);
    startTime:=now;
    with Sp_RepItemStat do
    begin
      close;
      Parameters.parambyname('In_Date').Value:=StatDate;   //ͳ������
      execproc;
      endtime:=now;
      case Parameters.ParamByName('isucceed').Value of
       1 : begin
             DoWhat.ifRepStat := false;
             MessageContent:=datetimetostr(now)+'   ���ԡ����ϱ���ͳ���̡߳�����Ϣ�����ѳɹ�ͳ�ơ���<'+datetostr(StatDate)+'>���ϱ�������ִ�й�����ʱ�䣺'+timetostr(endtime-starttime);
             New(AData);
             //Event �� 6 ͳ�Ƴɹ�
             Adata.command := 96;
             AData.districtid := 0;
             Adata.Msg :='�ձ�ͳ�Ƴɹ�';
             PostMessage(Application.MainForm.Handle, WM_THREAD_MSG, 0, Longint(Adata));
           end;
       3 : begin
             DoWhat.ifRepStat := false;
             MessageContent:=datetimetostr(now)+'   ���ԡ����ϱ���ͳ���̡߳�����Ϣ����<'+datetostr(StatDate)+'>���ϱ���ͳ�ƽ���Ѵ��ڣ�ͳ�Ʋ����Զ�ȡ����';
           end;
       else
           begin     //ʧ�ܺ��ظ�ͳ��,����Ϣ
             DoWhat.ifRepStat:=false;
             MessageContent:=datetimetostr(now)+'   ���ԡ����ϱ���ͳ���̡߳�����Ϣ����ͳ��<'+datetostr(StatDate)+'>���ϱ�������г�����֪ͨϵͳ����Ա����';
             New(AData);
             Adata.command := 97;
             AData.districtid := 0;
             Adata.Msg :='�ձ�ͳ��ʧ��';
             PostMessage(Application.MainForm.Handle, WM_THREAD_MSG, 0, Longint(Adata));
           end;
      end;
      close;
      Synchronize(AppendRunLog);
    end;
  except
    MessageContent:=datetimetostr(now)+'   ���ԡ����ϱ���ͳ���̡߳�����Ϣ����ͳ��<'+datetostr(StatDate)+'>������Ŀʱ��������Ԥ���Դ���ͳ��ʧ�ܣ���֪ͨϵͳ����Ա����';
    Synchronize(AppendRunLog);
  end;
  ButtonIsEnable:=true;
  Synchronize(RepStat_IsEnable);
end;

procedure TClearFlowTacheThread.ClearFlowTacheLog;
var
  strSQL : String;
  day : Integer;
begin
  ButtonIsEnable:=false;
  Synchronize(FlowLog_IsEnable);
  day := GetDay(9);
  strSQL := ' to_char(collecttime,''YYYY-MM-DD'')<= '''+DateToStr(Now-day)+''' ';
  AdoC.BeginTrans;
  with AdoQ do
  begin
      Close;
      SQL.Clear;
      SQL.Add('insert into Alarm_Flowrec_History select * from Alarm_Flowrec_OnLine where '+strSQL);
      try
        ExecSQL;
        Close;
        SQL.Clear;
        SQL.Add('delete from Alarm_Flowrec_OnLine where '+strSQL);
        ExecSQL;
        AdoC.CommitTrans;
      except
         AdoC.RollbackTrans;
      end;
  end;
  ButtonIsEnable:=true;
  Synchronize(FlowLog_IsEnable);
end;

constructor TClearFlowTacheThread.Create(DBConn: String);
begin
  inherited Create(true);

  AdoC := TADOConnection.Create(nil);
  AdoC.LoginPrompt:=false;
  AdoC.ConnectionString:=DBConn;
  AdoC.Connected:=true;

  AdoQ := TADOQuery.Create(nil);
  AdoQ.CommandTimeout := 500;
  AdoQ.Connection := AdoC;

  Sp_RepItemStat:= TADOStoredProc.Create(nil);
  with Sp_RepItemStat do
  begin
     Close;
     Connection := AdoC;
     ProcedureName:='ALARM_REPITEM_STAT';
     Parameters.Clear;
     Parameters.CreateParameter('In_Date',ftDateTime,pdInput,0,null);
     Parameters.CreateParameter('isucceed',ftInteger,pdOutput,0,null);
     Prepared;
  end;
  //
  Sp_DayReportStat:= TADOStoredProc.Create(nil);
  with Sp_DayReportStat do
  begin
     Close;
     Connection := AdoC;
     ProcedureName:='Alarm_Stat_DayReport';
     Parameters.Clear;
     Parameters.CreateParameter('sqlstr',ftString,pdInput,0,null);
     Parameters.CreateParameter('iCount',ftFloat	,pdOutput,0,null);
     Prepared;
  end;

  DoWhat := TDoWhat.Create;
  //DeptList := TList.Create;
  if not IfStated(1,date) then
    DoWhat.ifRepStat := true;
  if not IfStated(2,date-GetDay(10)) then
    DoWhat.ifDayReport := true; 
end;

destructor TClearFlowTacheThread.Destroy;
begin
  FreeAndNil(DoWhat);
  AdoQ.Close;
  AdoQ.Free;
  Sp_RepItemStat.Close;
  Sp_RepItemStat.Free;
  Sp_DayReportStat.Close;
  Sp_DayReportStat.Free;
  Adoc.Close;
  adoc.Free;

  inherited;
end;

procedure TClearFlowTacheThread.Execute;
var dbdate:tdatetime;
begin
  { Place thread code here }
  while (not terminated) do
  with DoWhat do
  begin
    try
      if ifRepStat then   //ͳ�����ϱ���
      begin
          try  //���Ա�������
            if AdoC.Connected then
              AdoC.Connected:=false;
            AdoC.Connected:=true;
            dbdate:=GetSysDateTime;
            MessageContent:=datetimetostr(now)+'   ���ԡ����ϱ���ͳ���̡߳�����Ϣ����<'+datetimetostr(now)+'/'+datetimetostr(dbdate)+'>��ִ�б���ͳ���̣߳�';
            Synchronize(AppendRunLog);
            RepItemStat(dbdate) ;
            AdoC.Connected := false;
            Suspend;
          except
            MessageContent:=datetimetostr(now)+'   ���ԡ����ϱ���ͳ���̡߳�����Ϣ�������ظ澯���ݿ�����ʧ�ܣ���֪ͨϵͳ����Ա����';
            Synchronize(AppendRunLog);
            Exit;
          end;
      end;
    except
      on E:Exception do
      begin
        MessageContent:=datetimetostr(now)+'   ���ԡ�����ִ���̡߳�����Ϣ�����߳�ִ�д�����֪ͨϵͳ����Ա����'+E.Message;
        Synchronize(AppendRunLog);
      end;
    end;
  end;
end;

function TClearFlowTacheThread.GetDay(Kind : Integer): Integer;
begin
    with AdoQ do
    begin
        Close;
        SQL.Clear;
        SQL.Add('select setvalue from alarm_sys_function_set where kind = '+IntToStr(Kind)+' and code = 2');
        Open;
        result := FieldByName('setvalue').AsInteger;
        Close;
    end;
end;

procedure TClearFlowTacheThread.AppendRunLog;
begin
    Fm_RunLog.Re_RunLog.Lines.Add(MessageContent);
end;

function TClearFlowTacheThread.IfStated(kind: integer;
  idate: TDate): Boolean;
var
  sqlstr : String;
begin
    result := false;

    sqlstr := 'select * from  Alarm_stated_Record where Statkind ='+IntToStr(kind)+' and to_char(Stateddate,''YYYY-MM-DD'') ='''+FormatDateTime('YYYY-MM-DD',idate)+'''';
    with AdoQ do
    begin
        Close;
        SQL.Clear;
        SQL.add(sqlstr);
        Open;
        if RecordCount > 0 then
          Result := true;
        Close;
    end;
end;


function TClearFlowTacheThread.GetSysDateTime: TDateTime;
begin
  with self.AdoQ do
  begin
    close;
    Connection := self.AdoC;
    SQL.Clear;
    SQL.Add('select sysdate from dual');
    open;
    result:=fieldbyname('sysdate').asdatetime;
    close;
  end;
end;

end.
