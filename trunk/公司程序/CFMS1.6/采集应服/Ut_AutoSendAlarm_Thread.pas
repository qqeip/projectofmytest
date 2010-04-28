unit Ut_AutoSendAlarm_Thread;

interface

uses
  Classes {$IFDEF MSWINDOWS} , Windows {$ENDIF}, ADODB, SysUtils, ComCtrls,Forms,
  Variants, DB, Controls, StrUtils,Messages,Ut_common,Ut_Data_Local,Ut_PubObj_Define ;


type
  TRuleSendKind = class(TObject)
    deviceid : String;
    flowtache : integer;
    IsSend : Integer;
  end;

  TChangeRowLog = record
    AppendRow: integer;
    EditRow: integer;
    DelRow: integer;
    error: boolean;
  end;

  TTableMasterList = record
    CityID : integer;
    companyid: integer;
    batchid : integer;
    AlarmIDS: String;
    ALARMCONTENTCODE : integer;
    csid : integer;
    flowtache : integer;
    createtime : Variant;
    collecttime : Variant;
    sendtime : Variant;
    cleartime : Variant;
    cancelsign : integer;
    cancelnote : string;
    removetime : Variant;
    LimitedHour : Integer;
    ISALARM : string;
    ESERVICECOCODE : integer;
    deviceid : string;
    codeviceid : string;
    RuleDept : integer;
    SendOperator : integer;
    RemoveOperator : integer;
    CollectOperator : integer;
    ClearOperator : integer;
    updatetime : Variant;
    occurid : integer;
    eserviceentitycode : integer;
    notenum : integer;
    calleffect : integer;
    alarmtype: integer;
    RESENDTIME : Variant;
    ErrorContent : string;
    NewCollectTime : Variant;
    startsend : string;
    endsend : string;
    RepIsStat : Variant;
    causecode : integer;
    resolventcode : integer;
  end;

  TTable_FlowRec_List = record
    ALARMID : integer;
    sflowtache : integer;
    updatenote : string;
    collecttime : Variant;
    collectoperator : string;
    batchid : integer;
    flowtrackid :integer;
    tflowtache : integer;
    occurid : integer;
    deviceid : string;
    codeviceid: string;
    csid : integer;
    cityid :integer;
  end;

  TTable_oprec_List = record
    trackid: integer;
    cityid: integer;
    companyid: integer;
    batchid: integer;
    alarmid: integer;
    sflowtache: integer;
    tflowtache: integer;
    operate: integer;
    deviceid: integer;
    codeviceid: integer;
    operatetime: Variant;
    operator: integer;
    csid: integer;
    remark: string; 
  end;

type
  AutoSendAlarm = class(TThread)
  private
    Ado_DBConn: TADOConnection;  
    Ado_Free: TADOQuery;
    Ado_Company: TADOQuery;
    Ado_Dynamic: TADOQuery;
    Ado_Data_Collect: TADOQuery;
    Ado_Alarm_OnLine: TADOQuery;
    Sp_Alarm_FlowNumber: TADOStoredProc;
    Sp_ALARM_Device_Company: TADOStoredProc;
    Sp_ALARM_SubmitAndWreck: TADOStoredProc;
    Sp_Alarm_StayTo_Resend : TADOStoredProc;
    Sp_alarm_after_send: TADOStoredProc;
    Sp_alarm_delete_invalid: TADOStoredProc;
    Sp_alarm_remove: TADOStoredProc;
    Sp_upgrade_master_fault: TADOStoredProc;
    ButtonIsEnable:Boolean;
    MessageContent : String;
    IsTrans: boolean;
    IsDebug: boolean;

    procedure SetName;

    procedure ErrorProcess(MainAlarm : TTableMasterList);

    function GetTimeLimitFromCsLevel(CsLevel:integer):integer; //���ݻ�վ�ȼ��õ�ʡ�ֹ��ϻ�վ�޸�ʱ��

    function GetSysDateTime():TDateTime;  //�õ����ݿ������ʱ��

    function ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer; //�õ�ָ�����͵���ˮ��

    //�ж�pop_cs���е�IfSendAlarm�Ƿ�Ϊָ����״̬(State)�������(���)�򷵻��棬���򷵻ؼ�
    Function Judge_IfSendAlarm(FlowTache:integer; var MainAlarm : TTableMasterList):integer;

    //�ԡ����̻��ڱ䶯���ٱ�fault_company_flowrec_online���м�¼����Ĺ��̣�ÿһ�����ڵı䶯����Ҫ���ñ����һ��
    procedure Insert_alarm_oprec_online(oprec_List: TTable_oprec_List);

     //�Ա�fault_master_online�����ģ�UpdateOrInsert��true��ʾ���£�����Ϊ����
    function Update_oprec(OperateDim, VSFlowtache: integer): boolean;

    //���¸澯�豸���߱���Ϣ(��վ)
    procedure Update_alarm_device_info(MainAlarm : TTableMasterList);

    //�Ա�fault_master_online�����ģ�UpdateOrInsert��true��ʾ���£�����Ϊ����
    function Update_fault_master_online(UpdateOrInsert:boolean; MainAlarm : TTableMasterList):boolean;

    function AllDetailAlarmIsRemove(CityID,OccurID,COMPANYID:integer):boolean;  //�Զ����Ϲ���

    procedure AppendRunLog();  //�����Ϣ��������־

    procedure ClearAfterAlarmSend;

    procedure ShowCollectMessage(appendrow,editrow,delrow:integer;Kind:boolean);//�����־����

    //�޸�fault_detail_online���removetime��flowtache�ֶ�
    procedure Modify_Cs_OnLine(Cityid,AlarmID:integer);

    //�жϴ��ϸ澯����������ϼ���������ϣ���������Ϊ���ϵĹ���
    procedure Upgrade_master_fault(MainAlarm : TTableMasterList);

    procedure ExecTheSQL(TheADOQuery: TADOQuery; TheSQL:string);

    function OpenTheAutoDataSet(TheADOQuery: TADOQuery; TheSQL:string):integer;

    //���á���ť���Ƿ����
    procedure SetButton_IsEnable();

    //����<�־ֱ���>�õ�<��ά��˾����>��OppositeKind��2����<�������ı���>��OppositeKind��1��
    function Get_Opposite_RuleDept(CityID, BranchID : integer;deviceid:String):integer;

    //�жϸù����Ƿ����ѹ��ϣ���Ϊ���ѷ���true�����򷵻�false
    function Judge_IfStayAlarm(CityID,OccurID:integer):boolean;

    function GetAllowedCsLevel(CitySN:integer):string;  //�õ��������ϵĻ�վ�����б�

    Procedure RestorationSendAlarm(CitySN:integer);  //��λ��վ�������Ϲ��̣������������Ϊ���������ϣ�

    //����ǰ��׼����������
    procedure PrepareBeforeSend(CityID:integer; AutoSendSQL:String; IsSendPoint:Boolean=false);

    Function ExecSingleCitySendAlarm(CitySN:integer; AutoSendSQL:String; CurrTime:TDateTime; var IsSend_51,IsSend_61,IsSend_6:boolean;IsSendPoint :Boolean=false):boolean;
    Function SendCompanyAlarm(MainAlarm : TTableMasterList; CitySN:integer; var IsError, IsSend_51,IsSend_61,IsSend_6:boolean;IsSendPoint :Boolean): TChangeRowLog;

    function GetLevelList(CurTime:TTime; Param :TTheAreaAlarmParam):String;
    function GetTime(level:integer; Param :TTheAreaAlarmParam;IsStrat:Boolean= true):String;

    function  OpenAdoQuery(TheADOQuery: TADOQuery; TheSQL:string): boolean;

    function GetNewCompSeqID(SeqName: string; MainAlarm: TTableMasterList): Integer;

    procedure AlarmAfterSend(MainAlarm : TTableMasterList);    //�澯���Ϻ��ƺ���
    procedure Alarm_Remove(MainAlarm : TTableMasterList);  //����
    procedure AlarmDeleteInvalid(MainAlarm : TTableMasterList);    //ɾ����Ч�澯(������Ч�澯)

    procedure ShowDubuginfo(sMessage: string);

  protected
    procedure Execute; override;
  public
    //һ����������ʼʱ������Ͻ���ʱ��
    constructor Create(DBConn:string);
    destructor Destroy;override;

    //�Զ�����������ȹ���
    procedure AlarmSendOverall();
  end;

implementation

uses Ut_Collection_Data, Ut_RunLog;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure InteAttempCollect.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;
{$ENDIF}

{ InteAttempCollect }

procedure AutoSendAlarm.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'InteAttempCollect';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;

constructor AutoSendAlarm.Create(DBConn:string);
var
  sqlstr:string;
begin
 { Place thread code here }
  inherited Create(true);

  Ado_DBConn := TADOConnection.Create(nil);
  Ado_DBConn.LoginPrompt:=false;
  Ado_DBConn.KeepConnection:=false;
  Ado_DBConn.ConnectionString:=DBConn;
  Ado_DBConn.Connected:=true;

  Ado_Free := TAdoQuery.Create(nil);
  Ado_Free.Connection := Ado_DBConn;

  Ado_Dynamic := TAdoQuery.Create(nil);
  Ado_Dynamic.Connection := Ado_DBConn;

  Sp_Alarm_FlowNumber:= TADOStoredProc.Create(nil);
  with Sp_Alarm_FlowNumber do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='ALARM_GET_FLOWNUMBER';
     Parameters.Clear;
     Parameters.CreateParameter('I_FLOWNAME',ftString,pdInput,100,null);
     Parameters.CreateParameter('I_SERIESNUM',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('O_FLOWVALUE',ftInteger,pdOutput,0,null);
     Prepared;
  end;

  Ado_Data_Collect := TAdoQuery.Create(nil);
  Ado_Data_Collect.Connection := Ado_DBConn;

  Ado_Company := TAdoQuery.Create(nil);
  Ado_Company.Connection := Ado_DBConn;
  Ado_Company.Close;
  Ado_Company.SQL.Clear;
  {Ado_Company.SQL.Add('select c.companyid from fms_company_alarm_relat c ' +
                       'where c.alarmcontentcode=:alarmcontentcode and c.companyid in '+
                       '(select d.companyid from fms_company_device_View d where d.deviceid=:deviceid) '); }
  Ado_Company.SQL.Add('select distinct c.companyid from fms_company_alarm_relat c ' +
                       'where c.alarmcontentcode=:alarmcontentcode and (c.alarmcontentcode=800000001 or c.companyid in '+
                       '(select d.companyid from fms_company_device_View d where d.deviceid=:deviceid) )');

  Ado_Alarm_OnLine := TAdoQuery.Create(nil);
  //���ϼ�����ʱ�ֶε� by cyx 
  sqlstr:=' select CityID, companyid, csid, alarmid, BATCHID, IFPRESIDER, alarmtype, alarmcontentcode, ISALARM, createtime, ';
  sqlstr:=sqlstr + ' flowtache, SendTime, removetime,collecttime, deviceid, codeviceid, SendOperator, RemoveOperator, ';
  sqlstr:=sqlstr + ' CollectOperator, updatetime, OccurID, ErrorContent, CollectionKind, CollectionCode, ';
  sqlstr:=sqlstr + ' STARTSEND,ENDSEND ,LIMITEDHOUR,RESENDTIME, alarmlocation from fault_detail_online ';
  sqlstr:=sqlstr + ' where cityid=:cityid ';
  with Ado_Alarm_OnLine do
  begin
     Connection := Ado_DBConn;
     Close;
     SQL.Clear;
     SQL.Add(sqlstr);
  end;

  //ά����λ����
  Sp_ALARM_Device_Company:= TADOStoredProc.Create(nil);
  with Sp_ALARM_Device_Company do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='alarm_device_company';
     Parameters.Clear;
     Parameters.CreateParameter('Pcityid',ftString,pdInput,100,null);
     Parameters.CreateParameter('Pdeviceid',ftString,pdInput,100,null);
     Parameters.CreateParameter('Pcontentcodein',ftString,pdInput,100,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);
     Prepared;
  end;

  //�Զ��ύ������
  Sp_ALARM_SubmitAndWreck:= TADOStoredProc.Create(nil);
  with Sp_ALARM_SubmitAndWreck do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='alarm_wrecker';
     Parameters.Clear;
     Parameters.CreateParameter('VCityid',ftString,pdInput,100,null);
     Parameters.CreateParameter('Vcompanyid',ftString,pdInput,100,null);
     Parameters.CreateParameter('VBATCHID',ftString,pdInput,100,null);
     Parameters.CreateParameter('VOPERATOR',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('handlekind',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('RECCOUNT',ftInteger,pdOutput,0,null);
     Parameters.CreateParameter('SubCount',ftInteger,pdOutput,0,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);

     Prepared;
  end;


  //�澯�����ƺ���
  Sp_alarm_after_send:= TADOStoredProc.Create(nil);
  with Sp_alarm_after_send do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='alarm_after_send';
     Parameters.Clear;
     Parameters.CreateParameter('VCityid',ftString,pdInput,100,null);
     Parameters.CreateParameter('VOPERATOR',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);

     Prepared;
  end;

  //��Ч�澯�Զ�ɾ��
  Sp_alarm_delete_invalid:= TADOStoredProc.Create(nil);
  with Sp_alarm_delete_invalid do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='alarm_delete_invalid';
     Parameters.Clear;
     Parameters.CreateParameter('VCityid',ftString,pdInput,100,null);
     Parameters.CreateParameter('VOPERATOR',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);

     Prepared;
  end;


  //����
  Sp_alarm_remove:= TADOStoredProc.Create(nil);
  with Sp_alarm_remove do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='alarm_remove';
     Parameters.Clear;
     Parameters.CreateParameter('VCityid',ftString,pdInput,100,null);
     Parameters.CreateParameter('Vcompanyid',ftString,pdInput,100,null);
     Parameters.CreateParameter('PBATCHID',ftString,pdInput,100,null);
     Parameters.CreateParameter('VAlarmIDS',ftString,pdInput,100,null);
     Parameters.CreateParameter('VOPERATOR',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);

     Prepared;
  end;

  //����������
  Sp_upgrade_master_fault:= TADOStoredProc.Create(nil);
  with Sp_upgrade_master_fault do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='upgrade_master_fault';
     Parameters.Clear;
     Parameters.CreateParameter('VCityid',ftString,pdInput,100,null);
     Parameters.CreateParameter('Vcompanyid',ftString,pdInput,100,null);
     Parameters.CreateParameter('VBATCHID',ftString,pdInput,100,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);

     Prepared;
  end;

  //������
  Sp_Alarm_StayTo_Resend:= TADOStoredProc.Create(nil);
  with Sp_Alarm_StayTo_Resend do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='ALARM_STAYTO_RESEND';
     Parameters.Clear;
     Parameters.CreateParameter('VCityid',ftString,pdInput,100,null);
     Parameters.CreateParameter('VBatchid',ftInteger,pdInputOutput,0,null);
     Parameters.CreateParameter('Vcompanyid',ftString,pdInput,100,null);
     Parameters.CreateParameter('SFlowTache',ftInteger,pdInput,100,null);
     Parameters.CreateParameter('TFlowTache',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('VOperator',ftString,pdInput,0,null);
     Prepared;
  end;
  Ado_DBConn.Connected:=false;
  IsTrans := true;
  IsDebug := true;
end;

destructor AutoSendAlarm.Destroy;
begin
  Ado_Free.Close;
  Ado_Free.Free;
  Ado_Company.Close;
  Ado_Company.Free;
  Ado_Dynamic.Close;
  Ado_Dynamic.Free;
  Sp_Alarm_FlowNumber.Close;
  Sp_Alarm_FlowNumber.Free;
  Sp_ALARM_Device_Company.Close;
  Sp_ALARM_Device_Company.Free;
  Sp_ALARM_SubmitAndWreck.Close;
  Sp_ALARM_SubmitAndWreck.Free;
  Sp_alarm_after_send.Close;
  Sp_alarm_after_send.Free;
  Sp_alarm_delete_invalid.Close;
  Sp_alarm_delete_invalid.Free;
  Sp_alarm_remove.Close;
  Sp_alarm_remove.Free;
  Sp_upgrade_master_fault.Close;
  Sp_upgrade_master_fault.Free;
  Sp_Alarm_StayTo_Resend.Close;
  Sp_Alarm_StayTo_Resend.Free;
  Ado_Data_Collect.Close;
  Ado_Data_Collect.Free;
  Ado_Alarm_OnLine.Close;
  Ado_Alarm_OnLine.Free;
  Ado_DBConn.Close;
  Ado_DBConn.Free;
  inherited;
end;

procedure AutoSendAlarm.Execute;
begin
  SetName;
  while (not terminated) do
  begin
     try
        try
           AlarmSendOverall;
        except
           MessageContent:=datetimetostr(now)+'   ���ԡ��Զ������̡߳�����Ϣ�����߳�ִ�д�����֪ͨϵͳ����Ա����';
           Synchronize(AppendRunLog);
        end;
     finally
        Suspend;
     end;
  end;
  { Place thread code here }
end;

procedure AutoSendAlarm.ExecTheSQL(TheADOQuery: TADOQuery; TheSQL:string);
begin
  with TheADOQuery do
  begin
    close;
    sql.Clear;
    sql.Add(TheSQL);
    ExecSQL;
  end;
end;

function AutoSendAlarm.OpenTheAutoDataSet(TheADOQuery: TADOQuery; TheSQL:string):integer;
begin
  with TheADOQuery do
  begin
    close;
    sql.Clear;
    sql.Add(thesql);
    open;
    Result:=RecordCount;
  end;
end;

//����<�־ֱ���>�õ�<��ά��˾����>��OppositeKind��2����<�������ı���>��OppositeKind��1��
//�ȼ������ָ��Ͻ�������Ƿ���ڴ˻�վ
function AutoSendAlarm.Get_Opposite_RuleDept(CityID, BranchID : integer;deviceid:String):integer;
var
  sqlstr:string;
begin
  Result:=0;  //------------------------������
  exit;
  //  kind = 1��ʶ ����
  sqlstr:=' select districtid from alarm_appoint_district where kind=1 and (cityid,code) in('+
          ' select cityid,material_id from fms_device_info where deviceid='''+deviceid+''' and cityid='+IntToStr(cityid)+')';
  if OpenTheAutoDataSet(Ado_Dynamic,sqlstr)>0 then
    Result:=Ado_Dynamic.fieldbyname('districtid').AsInteger
  else //�������������ָ���Ͱ�����������
  begin
    sqlstr:=' select districtid from alarm_districtandbranch_list where CityID='+inttostr(CityID)+' and branchid='+inttostr(BranchID);
    if OpenTheAutoDataSet(Ado_Dynamic,sqlstr)>0 then
      Result:=Ado_Dynamic.fieldbyname('districtid').AsInteger
    else
      Result:=0;
  end;
end;

function AutoSendAlarm.GetSysDateTime():TDateTime;
begin
   with Ado_Free do
   begin
      close;
      sql.Clear;
      sql.Add('select sysdate from dual');
      open;
      result:=fieldbyname('sysdate').asdatetime;
      close;
   end;
end;

function AutoSendAlarm.ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer;
begin
   with Sp_Alarm_FlowNumber do
   begin
      close;
      Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //��ˮ������
      Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //�����������ˮ�Ÿ���
      execproc;
      result:=Parameters.parambyname('O_FLOWVALUE').Value; //����ֵΪ���ͣ�����ֻ�������еĵ�һ��ֵ�����´η���ֵΪ��result+I_SERIESNUM
      close;
   end;
end;

//�ж�pop_cs���е�IfSendAlarm�Ƿ�Ϊָ����״̬(State)�������(���)�򷵻��棬���򷵻ؼ�
Function AutoSendAlarm.Judge_IfSendAlarm(FlowTache:integer; var MainAlarm : TTableMasterList):integer;
begin
   with Ado_Dynamic do
   begin
      close;
      sql.Clear;
      sql.Add('select flowtache, batchid, occurid, Csid, collecttime from alarm_device_info '+
             'where CityID=:CityID and companyid=:companyid and deviceid=:deviceid');
      Parameters.ParamByName('CityID').Value:= MainAlarm.CityID;
      Parameters.ParamByName('companyid').Value:= MainAlarm.companyid;
      Parameters.ParamByName('deviceid').Value:= MainAlarm.deviceid;
      open;
      if IsEmpty then
      begin
        result:=2;
        exit;
      end;
      MainAlarm.BatchID:=fieldbyname('BatchID').AsInteger;
      MainAlarm.occurid:=fieldbyname('occurid').AsInteger;
      MainAlarm.csid:=fieldbyname('Csid').AsInteger;
      MainAlarm.collecttime:=fieldbyname('collecttime').AsDateTime;
      MainAlarm.NewCollectTime:=fieldbyname('collecttime').AsDateTime;
      if fieldbyname('flowtache').AsInteger=FlowTache then
         Result:=1
      else
      begin
         MainAlarm.flowtache:=fieldbyname('flowtache').AsInteger;
         Result:=0;
      end;
      close;
   end;
end;

procedure AutoSendAlarm.Update_alarm_device_info(MainAlarm : TTableMasterList);
var
  sqlstr : String;
begin
  sqlstr:='update alarm_device_info set flowtache=:flowtache, batchid=:batchid, occurid=:occurid,';
  sqlstr:=sqlstr+' UpdateTime=sysdate where cityid=:cityid and deviceid=:deviceid and companyid=:companyid';
   with Ado_Dynamic do
   begin
      close;
      SQL.Clear;
      SQL.Add(sqlstr);
      Parameters.ParamByName('FlowTache').Value:= MainAlarm.flowtache;
      Parameters.ParamByName('BatchID').Value:= MainAlarm.BatchID;
      Parameters.ParamByName('occurid').Value:= MainAlarm.occurid;
      Parameters.ParamByName('cityid').Value:= MainAlarm.cityid;
      Parameters.ParamByName('deviceid').Value:= MainAlarm.deviceid;
      Parameters.ParamByName('companyid').Value:=mainalarm.companyid;
      execsql;
      close;
   end;
end;

function AutoSendAlarm.GetTimeLimitFromCsLevel(CsLevel:integer):integer;
var i:integer;
begin
  Result:=8;
  with Dm_Collect_Local.PublicParam do
  for i:=low(CSExamTimeLimit) to high(CSExamTimeLimit) do
  if CsLevel=CSExamTimeLimit[i].CsLevel then
  begin
    Result:=CSExamTimeLimit[i].LimitedHour;
    break;
  end;
end;

procedure AutoSendAlarm.ErrorProcess(MainAlarm : TTableMasterList);
var
  DelSQL: string;
begin
  {DelSQL:='delete from alarm_device_info where cityid='+inttostr(MainAlarm.CityID)+' and deviceid='+QuotedStr(MainAlarm.deviceid)+
           ' and companyid='+inttostr(MainAlarm.companyid);
  ExecTheSQL(Ado_Dynamic,DelSQL);
  DelSQL:='delete from fault_master_online where cityid='+inttostr(MainAlarm.CityID)+' and deviceid='+QuotedStr(MainAlarm.deviceid)+
          ' and companyid='+inttostr(MainAlarm.companyid);
  ExecTheSQL(Ado_Dynamic,DelSQL);
  DelSQL:='delete from fault_detail_online where cityid='+inttostr(MainAlarm.CityID)+' and deviceid='+QuotedStr(MainAlarm.deviceid)+
          ' and companyid='+inttostr(MainAlarm.companyid);
  ExecTheSQL(Ado_Dynamic,DelSQL); }
  //�Ѿ��ڽ���ʱ������У��
end;

//�Ա�fault_master_online�����ģ�UpdateOrInsert��true��ʾ���£�����Ϊ����
function AutoSendAlarm.Update_fault_master_online(UpdateOrInsert: boolean; MainAlarm: TTableMasterList): boolean;
var
  sqlstr,UpdSQL:string;
  FlowRec_List :TTable_FlowRec_List;
  CurrTime :TdateTime;
  cslevel,cstype,datacollectid,lBatchid :integer;
begin
   result:=true;
   CurrTime:=GetSysDateTime;
   with FlowRec_List do
   begin
      BatchID:= MainAlarm.BatchID;
      TFlowTache:= MainAlarm.flowtache;
      COLLECTTIME:=CurrTime;
      COLLECTOPERATOR:= 'SYS';
      occurid:= MainAlarm.occurid;
      deviceid:= MainAlarm.deviceid;
      codeviceid:= MainAlarm.codeviceid;
      csid:= MainAlarm.csid;
      CityID:= MainAlarm.CityID;
      FlowTrackID:=0;
   end;

   if UpdateOrInsert then  //trueΪ���²���
   begin
      sqlstr:=' select a.CollectTime,a.flowtache,a.NewCollectTime,a.eservicecocode,b.BTS_TYPE cstypeid,b.BTS_LEVEL levelflagcode,b.datacollectid,b.RepIsStat, a.causecode, a.resolventcode,a.alarmcontentcode ';
      sqlstr:=sqlstr+' from fault_master_online a';
      sqlstr:=sqlstr+' inner join alarm_device_info b on a.occurid=b.occurid and a.cityid=b.cityid and a.companyid=b.companyid';
      sqlstr:=sqlstr+' where a.OccurID = :OccurID and a.CityID=:CityID and a.companyid=:companyid';
      with Ado_Dynamic do
      begin
        close;
        sql.Clear;
        sql.Add(sqlstr);
        Parameters.ParamByName('OccurID').Value:= MainAlarm.OccurID ;
        Parameters.ParamByName('CityID').Value:= MainAlarm.CityID ;
        Parameters.ParamByName('companyid').Value:= mainalarm.companyid;
        open;
        if IsEmpty then
        begin
          ErrorProcess(MainAlarm);
          result:=false;
          exit;
        end;
        if fieldbyname('levelflagcode').IsNull then
           CsLevel:=-1
        else
           CsLevel:=fieldbyname('levelflagcode').AsInteger;
        if fieldbyname('cstypeid').IsNull then
           CsType:=0
        else
           CsType:=fieldbyname('cstypeid').AsInteger;
        datacollectid:=fieldbyname('datacollectid').AsInteger;

        FlowRec_List.SFlowtache:=fieldbyname('flowtache').AsInteger;
        MainAlarm.NewCollectTime:=fieldbyname('NewCollectTime').AsDateTime;
        MainAlarm.collecttime:=fieldbyname('CollectTime').AsDateTime;
        MainAlarm.ESERVICECOCODE:=fieldbyname('eservicecocode').AsInteger;
        MainAlarm.RepIsStat:=FieldByName('RepIsStat').AsVariant;
        MainAlarm.causecode:=fieldbyname('causecode').AsInteger;
        MainAlarm.resolventcode:=fieldbyname('resolventcode').AsInteger;
        MainAlarm.alarmcontentcode :=fieldbyname('alarmcontentcode').AsInteger;
      end;
      if FlowRec_List.tflowtache=FlowRec_List.SFlowtache then
         exit; //������״̬�ޱ����������˳�

      if (FlowRec_List.SFlowtache=2) or (FlowRec_List.SFlowtache=3) or (FlowRec_List.SFlowtache=8) then
      begin
        //���������Ϲ��̣�֮���������Ԫ�����Զ��ύ-���Ϲ���
        with Sp_Alarm_StayTo_Resend do
        begin
          close;
          Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//���б��
          Parameters.parambyname('VBatchid').Value:=MainAlarm.BatchID;//����
          Parameters.parambyname('Vcompanyid').Value:=MainAlarm.companyid;//
          Parameters.parambyname('SFlowTache').Value:=FlowRec_List.sflowtache;
          Parameters.parambyname('TFlowTache').Value:=FlowRec_List.tflowtache;
          Parameters.parambyname('VOperator').Value:=FlowRec_List.collectoperator;
          execproc;
          MainAlarm.batchid := Parameters.parambyname('VBatchid').Value;
          close;
        end;
        //���»�ȡ Occruid
        sqlstr :='select occurid from fault_master_online where batchid=:batchid and cityid =:cityid and companyid=:companyid';
        with Ado_Dynamic do
        begin
          close;
          sql.Clear;
          sql.Add(sqlstr);
          Parameters.ParamByName('batchid').Value := MainAlarm.BatchID;
          Parameters.ParamByName('cityid').Value := MainAlarm.cityid;
          Parameters.ParamByName('companyid').Value := mainalarm.companyid;
          Open;
          MainAlarm.occurid := FieldByName('occurid').AsInteger;
          Close;
        end;
      end;

      if MainAlarm.BatchID=-1 then
        raise exception.Create('����Alarm_StayTo_Resend�洢���̳���');

      if MainAlarm.flowtache=5 then //��Ϊ���˲���
      case FlowRec_List.SFlowtache of
       6 : FlowRec_List.UpdateNote:= '[����    ]->[����    ]';
       7 : FlowRec_List.UpdateNote:= '[�ύ    ]->[����    ]';
      end;
      MainAlarm.NewCollectTime:=CurrTime;//��Ϊ���˲���������Ҫ���newCollecttimeΪ��ǰϵͳʱ��
      if MainAlarm.flowtache=5 then
      begin
        UpdSQL:=' update fault_master_online set flowtache=:flowtache,RemoveTime=:RemoveTime,NewCollectTime=:NewCollectTime, ISALARM=1, ';
        UpdSQL:=UpdSQL+' RemoveOperator=:RemoveOperator where OccurID=:OccurID and CityID=:CityID and companyid=:companyid';
      end
      else
      begin
        UpdSQL:=' update fault_master_online set flowtache=:flowtache,RemoveTime=:RemoveTime,NewCollectTime=:NewCollectTime, ';
        UpdSQL:=UpdSQL+' RemoveOperator=:RemoveOperator where OccurID=:OccurID and CityID=:CityID and companyid=:companyid';
      end;
      //���±�alarm_device_info
      Update_alarm_device_info(MainAlarm);
   end else //����Ļ�����Ϊ�������
   begin
      FlowRec_List.SFlowtache:=4;
      FlowRec_List.UpdateNote:= '[����    ]->[����    ]';

      UpdSQL:='insert into fault_master_online( ';
      UpdSQL:=UpdSQL+' CITYID, companyid, deviceid, codeviceid, CSID, BATCHID, OCCURID, ALARMCONTENTCODE, ISALARM, errorcontent,';
      UpdSQL:=UpdSQL+' FLOWTACHE, CREATETIME, COLLECTTIME, SENDTIME, RESENDTIME, NewCollectTime, UPDATETIME,';
      UpdSQL:=UpdSQL+' STARTSEND, ENDSEND, LIMITEDHOUR, ESERVICECOCODE, RULEDEPT, SENDOPERATOR, COLLECTOPERATOR,LIMITTIME,alarmtype )';
      UpdSQL:=UpdSQL+' values( ';
      UpdSQL:=UpdSQL+' :CITYID, :companyid, :deviceid, :codeviceid, :CSID, :BATCHID, :OCCURID, :ALARMCONTENTCODE, :ISALARM, :errorcontent,';
      UpdSQL:=UpdSQL+' :FLOWTACHE, :CREATETIME, :COLLECTTIME, :SENDTIME, :RESENDTIME, :NewCollectTime, :UPDATETIME,';
      UpdSQL:=UpdSQL+' :STARTSEND, :ENDSEND, :LIMITEDHOUR, :ESERVICECOCODE, :RULEDEPT, :SENDOPERATOR, :COLLECTOPERATOR,getendtime(:SendTime1,:StartSend1,:EndSend1,:LIMITEDHOUR1), :alarmtype )';
   end;
   with Ado_Dynamic do
   begin
      close;
      sql.Clear;
      sql.Add(UpdSQL);
      if UpdateOrInsert then
      begin
         Parameters.ParamByName('removetime').Value:= MainAlarm.removetime;
         Parameters.ParamByName('RemoveOperator').Value:= MainAlarm.RemoveOperator;
      end else //���Ϊ���룬���踳ֵ23����������Ϊ���£���ֻ�踳5������
      begin       
         Parameters.ParamByName('deviceid').Value:= MainAlarm.deviceid;
         Parameters.ParamByName('codeviceid').Value:= MainAlarm.codeviceid;
         Parameters.ParamByName('CSID').Value:= MainAlarm.csid;
         Parameters.ParamByName('batchid').Value:= MainAlarm.batchid;
         Parameters.ParamByName('ALARMCONTENTCODE').Value:= MainAlarm.ALARMCONTENTCODE;
         Parameters.ParamByName('CREATETIME').Value:= MainAlarm.CREATETIME;
         Parameters.ParamByName('COLLECTTIME').Value:= MainAlarm.COLLECTTIME;
         Parameters.ParamByName('SENDTIME').Value:= MainAlarm.SENDTIME;
         Parameters.ParamByName('RESENDTIME').Value:= MainAlarm.RESENDTIME;
         Parameters.ParamByName('UPDATETIME').Value:= MainAlarm.UPDATETIME;
         Parameters.ParamByName('STARTSEND').Value:= MainAlarm.STARTSEND;
         Parameters.ParamByName('ENDSEND').Value:= MainAlarm.ENDSEND;
         Parameters.ParamByName('LIMITEDHOUR').Value:= MainAlarm.LIMITEDHOUR;
         Parameters.ParamByName('ESERVICECOCODE').Value:= MainAlarm.ESERVICECOCODE;
         Parameters.ParamByName('RULEDEPT').Value:= MainAlarm.RULEDEPT;
         Parameters.ParamByName('SENDOPERATOR').Value:= MainAlarm.SENDOPERATOR;
         Parameters.ParamByName('COLLECTOPERATOR').Value:= MainAlarm.COLLECTOPERATOR;
         Parameters.ParamByName('errorcontent').Value:= MainAlarm.ErrorContent;
         Parameters.ParamByName('alarmtype').Value:= MainAlarm.alarmtype;
         //���㵽��ʱ��
         Parameters.ParamByName('SENDTIME1').Value:= MainAlarm.SENDTIME;
         Parameters.ParamByName('STARTSEND1').Value:= MainAlarm.STARTSEND;
         Parameters.ParamByName('ENDSEND1').Value:= MainAlarm.ENDSEND;
         Parameters.ParamByName('LIMITEDHOUR1').Value:= MainAlarm.LIMITEDHOUR;
         Parameters.ParamByName('ISALARM').Value:= MainAlarm.ISALARM;
      end;
      Parameters.ParamByName('NewCollectTime').Value:= MainAlarm.NewCollectTime;
      Parameters.ParamByName('flowtache').Value:= MainAlarm.flowtache;
      Parameters.ParamByName('OCCURID').Value:= MainAlarm.occurid;
      Parameters.ParamByName('CityID').Value:= MainAlarm.CityID;
      Parameters.ParamByName('companyid').Value:= MainAlarm.companyid;  
      execsql;
      close;
   end;  
end;

function AutoSendAlarm.AllDetailAlarmIsRemove(CityID,OccurID, COMPANYID:integer):boolean;  //�Զ����Ϲ���
var SltSQL:string;
    RecCount:integer;
begin
   //��վ�ϵ�Ĺ��ϣ�AlarmContentCode��26�������ж�
   //Դ�ԣ�����������϶����ˣ��򲻹ܡ���վ�ϵ硱�Ƿ��Ѻã������ύ
   //�����ڴ˹��ˡ���վ�ϵ硱������������Ϊ������
   SltSQL:='Select CityID,AlarmID,AlarmContentCode from fault_detail_online where CityID='+inttostr(CityID);
   SltSQL:=SltSQL+' and OccurID='+inttostr(OccurID)+' and COMPANYID='+inttostr(COMPANYID)+' and ISALARM=1 order by AlarmID';
   RecCount:=OpenTheAutoDataSet(Ado_Dynamic,SltSQL);
   with Ado_Dynamic do
   begin
     //�����һ���澯��û���ų�����������
      if RecCount=0 then
         Result:=true
      else if (RecCount=1) and (FieldbyName('AlarmContentCode').AsInteger=26) then
      begin
         Result:=true;
         Modify_Cs_OnLine(CityID,FieldbyName('AlarmID').AsInteger);
      end else
         Result:=false;
      close;
   end;
end;

procedure AutoSendAlarm.AppendRunLog();  //�����Ϣ��������־
begin
   Fm_RunLog.Re_RunLog.Lines.Add(MessageContent);
end;

//�Ա�Alarm_Data_Collect���м�¼ɾ���Ĺ��̣���ʵ�ִ��ƶ����ݵ�fault_detail_online��Ŀ��
procedure AutoSendAlarm.ClearAfterAlarmSend();
var
   DelSQL :string;
begin
   DelSQL:=' delete from Alarm_Data_Collect where alarmissending=1';
   ExecTheSQL(Ado_Dynamic,DelSQL);   

   //sqlstr:=' delete from fault_master_online where (cityid, deviceid) not in ';
  //sqlstr:=DelSQL+' (select cityid, deviceid from alarm_device_info)';

  {
  DelSQL:=' delete from fault_master_online t where not exists  ';
  DelSQL:=DelSQL+'(select 1 from alarm_device_info a where a.cityid=t.cityid and a.deviceid=t.deviceid and t.companyid=a.companyid)';
  ExecTheSQL(Ado_Dynamic, DelSQL);

  //DelSQL:=' delete from fault_detail_online where (cityid, deviceid) not in ';
  //DelSQL:=DelSQL+' (select cityid, deviceid from fault_master_online)';
  DelSQL:=' delete from fault_detail_online t where not exists ';
  DelSQL:=DelSQL+'(select 1 from fault_master_online a where a.cityid=t.cityid and a.deviceid=t.deviceid and t.companyid=a.companyid)';
  ExecTheSQL(Ado_Dynamic, DelSQL);
  }
end;

procedure AutoSendAlarm.ShowCollectMessage(appendrow,editrow,delrow:integer;Kind:boolean);//�����־����
var collectstr:string;
begin
   if kind then
      collectstr:='�ɼ�:    '
   else
      collectstr:='����:    ';
   collectstr:=collectstr+datetimetostr(now)+'   ����׷�ӣ�'+inttostr(appendrow)+'   �޸ģ�'+inttostr(editrow)+'   ɾ����'+inttostr(delrow);
   MessageContent:=collectstr;
   Synchronize(AppendRunLog);
end;


//�޸�fault_detail_online���removetime��flowtache�ֶ�
procedure AutoSendAlarm.Modify_Cs_OnLine(CityID,AlarmID:integer);
var UpdSQL:string;
begin
  UpdSQL:= 'Update fault_detail_online Set ISALARM = 0, RemoveTime = SysDate';
  UpdSQL:=UpdSQL+' where CityID='+IntToStr(CityID)+' and AlarmID = '+IntToStr(AlarmID);
  ExecTheSQL(Ado_Dynamic,UpdSQL);
end;

//���á���ť���Ƿ����
procedure AutoSendAlarm.SetButton_IsEnable();
begin
   Fm_Collection_Data.Bt_AutoSend.Enabled:=ButtonIsEnable;
end;

//�жϸù����Ƿ����ѹ��ϣ���Ϊ���ѷ���true�����򷵻�false
Function AutoSendAlarm.Judge_IfStayAlarm(CityID,OccurID:integer):boolean;
var slt:string;
begin
  slt:='select flowtache,batchid from fault_master_online where CityID='+inttostr(CityID);
  slt:=slt+' and OccurID='+inttostr(OccurID)+' and flowtache in (2,3,8)';
  Result:=(OpenTheAutoDataSet(Ado_Dynamic,slt)>0);
end;

//����ǰ��׼����������
procedure AutoSendAlarm.PrepareBeforeSend(CityID:integer; AutoSendSQL:String; IsSendPoint:Boolean);
var
   sqlstr:string;
begin
  //ɾ���Ѵ��ڵļ�¼��alarm_data_collect �� fault_detail_online ����csid,alarmcontentcode,alarmstatus��ȫ��ͬ��
  {sqlstr:=' delete from alarm_data_collect where (CityID,deviceid,contentcode,ISALARM)';
  sqlstr:=sqlstr+' in (select CityID,deviceid,alarmcontentcode,ISALARM from fault_detail_online)';
  execthesql(Ado_Dynamic,sqlstr);}       // ----------------------------------- ������

  //��ֻ�С���վ�ϵ硱�Ļ�վ���Ϲ��˵���ɾ��������Ҫ���ϣ������ж��Ƿ�Զ����վ(11-11 12:10�޸�)
  //1��<�澯���߱�>����δ�и澯
  //2��ֻ�С���վ�ϵ硱�澯
  {sqlstr:= 'delete from alarm_data_collect ';
  sqlstr:=sqlstr+' where (cityid,deviceid) not in ';
  sqlstr:=sqlstr+' (select cityid,deviceid from fault_master_online) '; //1���ж�<�澯���߱�>���Ƿ�����иû�վ�ĸ澯
  sqlstr:=sqlstr+' and (cityid,deviceid) in ';
  sqlstr:=sqlstr+' (select cityid,deviceid ';  //2��ɸѡֻ��һ���ϵ�澯(��ΪClear�澯�����)�Ļ�վ
  sqlstr:=sqlstr+' from alarm_data_collect ';
  sqlstr:=sqlstr+' where contentcode=26 and ISALARM=1 and (cityid,deviceid) in ';
  sqlstr:=sqlstr+' ( ';
  sqlstr:=sqlstr+' select a.cityid,a.deviceid from alarm_data_collect a ';   //ֻ��һ���澯�Ļ�վ
  sqlstr:=sqlstr+' left join alarm_content_rule b on a.contentcode=b.alarmcontentcode and a.cityid=b.cityid';
  sqlstr:=sqlstr+' where b.sendtype=1';
  sqlstr:=sqlstr+' group by a.cityid,a.deviceid having count(contentcode)=1 ';
  sqlstr:=sqlstr+' ) ' ;
  sqlstr:=sqlstr+' ) ' ;
  execthesql(Ado_Dynamic,sqlstr);}
  //-----------------------------��ʱ������

  //���ϱ�־λ
  sqlstr:= ' update alarm_data_collect set alarmissending=1 where ';
  if not IsSendPoint then
    sqlstr:=sqlstr+' ISALARM = 0 and ';
  sqlstr:=sqlstr+' ( CityID,deviceid,codeviceid,contentcode ) in ';
  sqlstr:=sqlstr+ '(select CityID,deviceid,codeviceid,contentcode from ('+AutoSendSQL+'))';


 // sqlstr:=sqlstr+' (select CityID,deviceid,codeviceidcontentcode from alarm_autosend_view where cityid='+inttostr(cityid)+')';
  ExecTheSQL(Ado_Dynamic, sqlstr);

end;



{*****************************�Զ�����������ȹ���******************************
********************************************************************************
***  ���̹��ܣ�1���ӱ�alarm_data_collect�������ݵ���fault_detail_online      ***
***            2�����»�����fault_master_online                            ***
***            3�����±������alarm_device_info                            ***
***            4�����롶���̻��ڱ䶯���ٱ�Alarm_FlowRec_OnLine             ***
***            5���Ա�Alarm_Data_Collect���м�¼ɾ������ʵ�ִ��ƶ�����       ***
***               ��fault_detail_online��Ŀ��                                ***
***            6���㲥һ��ʵʱ��Ϣ���ͻ��ˣ��Ա�ͻ��˼�ʱȥˢ����ʾ����ѯ�� ***
***                                                       J.F. Qiu           ***
***                                                       2009-07-17         ***     
*******************************************************************************}
Procedure AutoSendAlarm.AlarmSendOverall();
var
    k:integer;
    CurrTime:TDateTime;
    starttime,endtime:TTime;
    // IsSend_51=true ����ʾ�����ϻ������Ϣ���跢ָ�51��֪ͨ�ͻ���ˢ����ؽ���
    // IsSend_61=true ����ʾ�и澯������Ϣ���跢ָ�61��֪ͨ�ͻ���ˢ����ؽ���
    // IsSend_6 =true ����ʾ�л�վ������Ϣ���跢ָ�6��֪ͨ�ͻ���ˢ����ؽ���
    IsSend_51,IsSend_61,IsSend_6:boolean;  //�Ƿ��͸���澯ˢ����Ϣ��
    IsSendPoint :Boolean;
    AutoSendSQL, CsLevelListStr : string;
    AData :PThreadData;
begin
  starttime:=now;
  IsSend_51:=false;
  IsSend_61:=false;
  IsSend_6:=false;
  IsSendPoint:= false;
  ButtonIsEnable:=false;
  Synchronize(SetButton_IsEnable);
  try
    try  //���Ա�������
      if Ado_DBConn.Connected then
        Ado_DBConn.Connected:=false;
      Ado_DBConn.Connected:=true;
    except
      MessageContent:=datetimetostr(now)+'   ���ԡ��Զ������̡߳�����Ϣ�������ظ澯���ݿ�����ʧ�ܣ���֪ͨϵͳ����Ա����';
      Synchronize(AppendRunLog);
      exit;
    end;
    try
      with Dm_Collect_Local do
      for k:=Low(AlarmParam) to High(AlarmParam) do
      begin
        CurrTime:=strtotime(timetostr(GetSysDateTime()));
        if AlarmParam[k].CityParam.IsAutoSend then  //�ж����Զ����ϻ��Ƕ�������
        begin
          if Dm_Collect_Local.AlarmParam[K].TodayIsSend then
          begin
            ShowDubuginfo('��ǰ���Ϸ�ʽ���Զ����ϣ���������ϣ�����ȫ�����ɸ澯��');
            AutoSendSQL := 'select * from alarm_autosend_view a where a.cityid='+inttostr(AlarmParam[k].CityID)+
                           ' and (a.ISALARM=0 or (a.alarmlevel, a.levelflagcode) in (select b.alarmlevel, b.devicelevel from alarm_send_level_view b) '+
                           ' or (a.cityid,a.DEVICEID) in (select c.cityid,c.DEVICEID from fault_detail_online c) '+
                           ' ) order by ISALARM,ALARMLEVEL,createtime ';
            //����û�վ�������߸澯   ���ɷ��澯 �ƹ�����ʱ���趨
            
            IsSendPoint:= true;
          end
          else
          begin
            ShowDubuginfo('��ǰ���Ϸ�ʽ���Զ����ϣ����첻�����ϣ���ֻ��Clear�澯!');
            AutoSendSQL:=' select * from alarm_autosend_view where ISALARM=0 and cityid='+inttostr(AlarmParam[k].CityID)+' order by ISALARM,ALARMLEVEL,createtime'
          end; 
        end
        else
        begin
          //���û�е������첻�������ϣ���ֻ�ɷ�Clear�澯
          CsLevelListStr:=GetAllowedCsLevel(K);
          if (CsLevelListStr<>'') and (Dm_Collect_Local.AlarmParam[K].TodayIsSend) then
          begin
            ShowDubuginfo('��ǰ���Ϸ�ʽ���������ϣ���������ϣ�����ȫ�����ɸ澯��');
            AutoSendSQL:=' select * from alarm_autosend_view where ((ISALARM=0) or (levelflagcode is null) ';
            AutoSendSQL:=AutoSendSQL+' or (ISALARM=1 and levelflagcode in ('+CsLevelListStr+'))) and cityid='+inttostr(AlarmParam[k].CityID);
            AutoSendSQL:=AutoSendSQL+' order by ALARMLEVEL,createtime ';
            IsSendPoint:= true;
          end
          else
          begin
            ShowDubuginfo('��ǰ���Ϸ�ʽ���������ϣ����첻�����ϣ���ֻ��Clear�澯!');
            AutoSendSQL:=' select * from alarm_autosend_view where ISALARM=0 and cityid='+inttostr(AlarmParam[k].CityID)+' order by ALARMLEVEL,createtime';
          end;
        end;
        if not ExecSingleCitySendAlarm(K,AutoSendSQL,CurrTime,IsSend_51,IsSend_61,IsSend_6,IsSendPoint) then
          exit;
      end; //for k:=Low(AlarmParam) to High(AlarmParam) do
      //������Ϣ
      endtime:=now;
      MessageContent:=datetimetostr(now)+'   �ѳɹ�ִ���Զ�����!  ����ִ�й�����ʱ�䣺'+timetostr(endtime-starttime);
      Synchronize(AppendRunLog);
      if IsSend_51 then
      begin
        New(AData);
        AData.command := 5;
        AData.districtid := 0;
        AData.Msg := '����';
        PostMessage(Application.MainForm.Handle, WM_THREAD_MSG, 0, Longint(AData));  
      end;
      if IsSend_61 or IsSend_6 then
      begin
         New(AData);
        AData.command := 6;
        AData.districtid := 0;
        AData.Msg := '����';
        PostMessage(Application.MainForm.Handle, WM_THREAD_MSG, 0, Longint(AData));
      end;
    except
      MessageContent:=datetimetostr(now)+'   ���ԡ��Զ������̡߳�����Ϣ�����ڽ������²���ʱ��������<ɾ������>��<�����ݼ�>��<д��־>��<��ʵʱ��Ϣ>ʱ��������';
      Synchronize(AppendRunLog);
    end;
  finally
    ButtonIsEnable:=true;
    Synchronize(SetButton_IsEnable);
    Ado_DBConn.Connected:=false;
  end;
end;

function AutoSendAlarm.GetAllowedCsLevel(CitySN:integer):string;  //�õ��������ϵĻ�վ�����б�
var i:integer;
begin
  Result:='';
  with Dm_Collect_Local.AlarmParam[CitySN].CityParam do
  for i:=Low(sendtimeList) to High(sendtimeList) do
  begin
    if (sendtimeList[i].AllowSend) then
      Result:=Result+inttostr(sendtimeList[i].CsLevelCode)+',';
  end;
  i:=length(Result);
  if i>0 then
    delete(Result,i,1);
end;

procedure AutoSendAlarm.RestorationSendAlarm(CitySN:integer);
var i:integer;
begin
  with Dm_Collect_Local.AlarmParam[CitySN].CityParam do
  for i:=Low(sendtimeList) to High(sendtimeList) do
  begin
    if (sendtimeList[i].AllowSend) then
      sendtimeList[i].AllowSend:=false;
  end;
end;

function AutoSendAlarm.GetLevelList(CurTime: TTime;
  Param: TTheAreaAlarmParam): String;
var
  i :integer;
begin
  result :='';
  for i:=Low(Param.sendtimeList) to High(Param.sendtimeList) do
  begin
    with Param.sendtimeList[i] do
    if ((Trim(SA_StartTime)<>'') or (Trim(SA_EndTime)<>'') ) and (CurTime >= StrToTime(SA_StartTime)) and (CurTime+3/60/24 <= StrToTime(SA_EndTime)) then      //  CurTime+3/60/24Ϊ�˱�������ʱ����ͳ��ʱ���ͻ��Jx��ʱ�޸�
       result := result +IntToStr(CsLevelCode)+',';
  end;
  if Trim(Result)<> '' then
    result := LeftStr(result,Length(result)-1);

end;

function AutoSendAlarm.GetTime(level: integer; Param: TTheAreaAlarmParam;
  IsStrat: Boolean): String;
var
  i :integer;
begin
  if IsStrat then
    result :='08:00'
  else
    result :='18:00:00';
  for i:=Low(Param.sendtimeList) to High(Param.sendtimeList) do
  begin
    with Param.sendtimeList[i] do
      if CsLevelCode=level then
      begin
        if IsStrat then
          result :=SA_StartTime
        else
          result :=SA_EndTime;
        break;
      end;
  end;
end;

function AutoSendAlarm.OpenAdoQuery(TheADOQuery: TADOQuery; TheSQL:string): boolean;
begin
  TheADOQuery.Close;
  TheADOQuery.SQL.Clear;
  TheADOQuery.SQL.Add(TheSQL);
  TheADOQuery.Open;
  Result := not TheADOQuery.IsEmpty;
end;

procedure AutoSendAlarm.Insert_alarm_oprec_online(oprec_List: TTable_oprec_List);
var
  strSQL: string; 
begin
  if oprec_List.remark='' then
  begin
    strSQL := 'select remark from alarm_dic_code_info t where t.dictype=25 and diccode = ''' + inttostr(oprec_List.operate)+'''';
    if OpenAdoQuery(Ado_Dynamic,strSQL) then
      oprec_List.remark := Ado_Dynamic.fieldbyname('remark').AsString
    else
    begin
      MessageContent := datetimetostr(now)+' ����״̬��'+IntToStr(oprec_List.operate)+' δ���ֵ���ж��壡';
      Synchronize(AppendRunLog);
    end;
  end;

  if oprec_List.trackid = 0 then oprec_List.trackid := ProduceFlowNumID('FlowTrackID',1);

   strSQL := 'insert into alarm_oprec_online(trackid, cityid, companyid, batchid, alarmid, ';
   strSQL := strSQL+ 'sflowtache, tflowtache, operate, deviceid, codeviceid, operatetime, operator, csid, remark) ';
   strSQL := strSQL+  'values(:trackid, :cityid, :companyid, :batchid, :alarmid, ';
   strSQL:= strSQL+ ':sflowtache, :tflowtache, :operate, :deviceid, :codeviceid, :operatetime, :operator, :csid, :remark)';
   with Ado_Dynamic do
   begin
      close;
      sql.Clear;
      sql.Add(strSQL);

      Parameters.ParamByName('trackid').Value:= oprec_List.trackid;
      Parameters.ParamByName('cityid').Value:=oprec_List.cityid;
      Parameters.ParamByName('companyid').Value:= oprec_List.companyid;
      Parameters.ParamByName('batchid').Value:= oprec_List.batchid;
      Parameters.ParamByName('alarmid').Value:= oprec_List.alarmid;
      Parameters.ParamByName('SFlowTache').Value:= oprec_List.SFlowTache;
      Parameters.ParamByName('TFlowTache').Value:= oprec_List.TFlowTache;
      Parameters.ParamByName('operate').Value:= oprec_List.operate;
      Parameters.ParamByName('deviceid').Value:= oprec_List.deviceid;
      Parameters.ParamByName('codeviceid').Value:= oprec_List.codeviceid;
      Parameters.ParamByName('operatetime').Value:= oprec_List.operatetime;
      Parameters.ParamByName('operator').Value:= oprec_List.operator;
      Parameters.ParamByName('csid').Value:= oprec_List.csid;
      Parameters.ParamByName('remark').Value:= oprec_List.remark;
      
      execsql;
      close;
   end;
end;

function AutoSendAlarm.Update_oprec(OperateDim, VSFlowtache: integer): boolean;
var
  strSQL: string;
  oprec_List :TTable_oprec_List;
  CurrTime :TdateTime;  
begin
  result := true;
  CurrTime := GetSysDateTime;

  with oprec_List do
  begin
    trackid := 0;
    cityid := Ado_Alarm_OnLine.fieldbyname('CityID').AsInteger;
    companyid := Ado_Alarm_OnLine.fieldbyname('companyid').AsInteger;
    batchid := Ado_Alarm_OnLine.fieldbyname('BatchID').AsInteger;
    alarmid := Ado_Alarm_OnLine.fieldbyname('alarmid').AsInteger;
    sflowtache := VSFlowtache;
    tflowtache := Ado_Alarm_OnLine.fieldbyname('flowtache').AsInteger;
    operate := OperateDim;
    deviceid := Ado_Alarm_OnLine.fieldbyname('deviceid').AsInteger;
    codeviceid := Ado_Alarm_OnLine.fieldbyname('codeviceid').AsInteger;
    operatetime := CurrTime;
    operator := 0;
    csid := Ado_Alarm_OnLine.fieldbyname('csid').AsInteger;
    remark := '';
  end;

  if OperateDim = 1 then oprec_List.TFlowtache := 4;
     
  Insert_alarm_oprec_online(oprec_List);
end;

Function AutoSendAlarm.ExecSingleCitySendAlarm(CitySN:integer; AutoSendSQL:String; CurrTime:TDateTime; var IsSend_51,IsSend_61,IsSend_6:boolean;IsSendPoint :Boolean):boolean;
var
  IsError : Boolean;
  MainAlarm : TTableMasterList;  //���Ͻṹ
  TotalChangeRowLog, ChangeRowLog: TChangeRowLog;
  i: integer;
begin
  IsError:=false;
  mainalarm.CityID:=Dm_Collect_Local.alarmparam[CitySN].CityID;
  try
    if IsTrans then Ado_DBConn.BeginTrans;

    //����ǰ��׼����������
    PrepareBeforeSend(mainalarm.CityID,AutoSendSQL, IsSendPoint);

    AlarmDeleteInvalid(MainAlarm); //��Ч�澯�Զ�ɾ��

    with Ado_Alarm_OnLine do
    begin
      close;
      Parameters.parambyname('CityID').Value:= mainalarm.CityID;
      open;
    end;

    with Ado_Data_Collect do
    begin
      close;
      SQL.Clear;
      SQL.Add(AutoSendSQL);
      open;

      if IsDebug then
      begin 
        ShowDubuginfo('��alarm_autosend_view�澯����������ʱ�������ĸ澯��¼��Ϊ��'+IntToStr(Ado_Data_Collect.RecordCount));
      end;

      TotalChangeRowLog.AppendRow := 0;
      TotalChangeRowLog.EditRow := 0;
      TotalChangeRowLog.DelRow := 0;

      first;
      while not eof do
      begin
        MainAlarm.deviceid := fieldbyname('deviceid').asstring;
        MainAlarm.ALARMCONTENTCODE := fieldbyname('contentcode').asinteger;

        //ά����λ����
        with Sp_ALARM_Device_Company do
        begin
          close;
          Parameters.parambyname('Pcityid').Value:=mainalarm.CityID;
          Parameters.parambyname('Pdeviceid').Value:=MainAlarm.deviceid;
          Parameters.parambyname('Pcontentcodein').Value:=MainAlarm.ALARMCONTENTCODE;
          execproc;
          i:=Parameters.parambyname('iError').Value; //����ֵΪ���ͣ�
          close;
        end;
        if i=-1 then
          raise exception.Create('���� ALARM_Device_Company�洢���̳��� batchid:'+IntToStr(MainAlarm.BatchID)+' deviceid:'+MainAlarm.deviceid);

        with Ado_Company do
        begin
          close;
          Parameters.parambyname('alarmcontentcode').Value := mainalarm.ALARMCONTENTCODE;
          Parameters.parambyname('deviceid').Value := mainalarm.deviceid;
          open;
        end;
        Ado_Company.first;

        while not Ado_Company.EOF do
        begin
          mainalarm.companyid := Ado_Company.FieldByName('companyid').AsInteger;
          ChangeRowLog := SendCompanyAlarm(mainalarm, CitySN, IsError, IsSend_51,IsSend_61,IsSend_6,IsSendPoint);

          if ChangeRowLog.error  then break;

          TotalChangeRowLog.AppendRow := TotalChangeRowLog.AppendRow + ChangeRowLog.AppendRow;
          TotalChangeRowLog.EditRow := TotalChangeRowLog.EditRow + ChangeRowLog.EditRow;
          TotalChangeRowLog.DelRow := TotalChangeRowLog.DelRow + ChangeRowLog.DelRow;


          Ado_Company.Next;
        end;
        
        if ChangeRowLog.error  then break;

        next;
      end;  //while not eof do
    end;    //with Ado_Data_Collect do


    ClearAfterAlarmSend; //�˴�����ɾ����¼����


    if iserror then
    begin
       MessageContent:=datetimetostr(now)+'   companyid:-'+inttostr(MainAlarm.companyid)+' deviceid:-'+MainAlarm.deviceid +' �Ļ�վ���ϵ�����Ϣ���û�վ�澯��Ϣ�ѱ������';
       Synchronize(AppendRunLog);
    end;
    if IsTrans then Ado_DBConn.CommitTrans;
    if TotalChangeRowLog.AppendRow+TotalChangeRowLog.EditRow>0 then
       ShowCollectMessage(TotalChangeRowLog.AppendRow,TotalChangeRowLog.EditRow,0,false);

   AlarmAfterSend(MainAlarm); //���Ϻ���
   // if IsSendPoint then
     // RestorationSendAlarm(CitySN);  //��λ��վ�������Ϲ��̣������������Ϊ���������ϣ�
  except
    on E: exception do
    begin
      if IsTrans then Ado_DBConn.RollbackTrans;
      MessageContent:=datetimetostr(now)+'   CityID:-'+inttostr(MainAlarm.CityID)+'���Զ����ϡ������У�������ʧ��:'+e.Message;
      Synchronize(AppendRunLog);
      ButtonIsEnable:=true;
      Synchronize(SetButton_IsEnable);
      Result:=false;
      exit;
    end;
  end;
  Result:=true;
end;

function AutoSendAlarm.SendCompanyAlarm(MainAlarm : TTableMasterList; CitySN:integer; var IsError, IsSend_51,IsSend_61,IsSend_6:boolean;IsSendPoint :Boolean): TChangeRowLog;
var
  i, appendrow, editrow:integer;
  IsUpdate_CsIndex:Integer;
  ChangeRowLog: TChangeRowLog;
  CurrTime:TDateTime;
  VSflowtache: integer;
  blFirstAlarm: boolean;

  //IsUpdate_CsIndex=0-�¸澯-�������룩��
  //IsUpdate_CsIndex=1-�¸澯-�ӣ����룩
  //IsUpdate_CsIndex=2-������Ϣ�����£������ж��Ƿ���ȫ���ϣ���
  //IsUpdate_CsIndex=3-״̬���ˣ�����ϸ��flowtache������Ϊ5��
  //IsUpdate_CsIndex=4- ������ͬ״̬
begin
  ChangeRowLog.error := false;
  blFirstAlarm := false;

  IsUpdate_CsIndex:=0;
  CurrTime:=GetSysDateTime;

  MainAlarm.codeviceid := Ado_Data_Collect.fieldbyname('codeviceid').asstring;

  //�Ѿ��д˸澯����       // Ҫע�� -------------��� compid ���øĶ��� Ҫ��ȥ�澯��¼
  if Ado_Alarm_OnLine.Locate('companyid; deviceid; alarmcontentcode; codeviceid',
     VarArrayOf([mainalarm.companyid, mainalarm.deviceid, mainalarm.ALARMCONTENTCODE, mainalarm.codeviceid]),[loCaseInsensitive]) then
  begin
    MainAlarm.BatchID := Ado_Alarm_OnLine.fieldbyname('BatchID').AsInteger;
    MainAlarm.csid := Ado_Data_Collect.fieldbyname('csid').AsInteger;
    MainAlarm.occurid := Ado_Alarm_OnLine.fieldbyname('occurid').AsInteger;

    if Ado_Alarm_OnLine.fieldbyname('ISALARM').AsInteger <> Ado_Data_Collect.fieldbyname('ISALARM').AsInteger then
    begin   //����Ҫ��flowtache������������ϣ�Ҫ��Ӵ���
      //Ado_Alarm_OnLine.edit;
      //Ado_Alarm_OnLine.fieldbyname('ISALARM').AsInteger := Ado_Data_Collect.fieldbyname('ISALARM').AsInteger;
      //Ado_Alarm_OnLine.fieldbyname('errorcontent').AsString := Ado_Data_Collect.fieldbyname('errorcontent').AsString;
      //Ado_Alarm_OnLine.fieldbyname('updatetime').AsDateTime := CurrTime;

      VSflowtache := Ado_Alarm_OnLine.fieldbyname('flowtache').AsInteger;
      //ISALARM��0��ʾ��������Ϣ
      if Ado_Data_Collect.fieldbyname('ISALARM').AsInteger=0 then
      begin   
        MainAlarm.AlarmIDS := Ado_Alarm_OnLine.fieldbyname('AlarmID').AsString;
        Alarm_Remove(MainAlarm);
        
        {
        Ado_Alarm_OnLine.fieldbyname('ISALARM').AsInteger := Ado_Data_Collect.fieldbyname('ISALARM').AsInteger;
        Ado_Alarm_OnLine.fieldbyname('errorcontent').AsString := Ado_Data_Collect.fieldbyname('errorcontent').AsString;
        Ado_Alarm_OnLine.fieldbyname('updatetime').AsDateTime := CurrTime;

        Ado_Alarm_OnLine.fieldbyname('flowtache').AsInteger:= 6;
        Ado_Alarm_OnLine.fieldbyname('removetime').AsDateTime:=CurrTime;
        Ado_Alarm_OnLine.fieldbyname('RemoveOperator').AsInteger:=-1;  }
        IsUpdate_CsIndex:=2;   //Ҫ�жϣ�ȷ���Ƿ������fault_master_online��������
        IsSend_61:=true;

        //Update_oprec(6, VSflowtache);
      end else  //ISALARM<>0��ʾ�Ǹ澯��Ϣ����flowtache״̬��ԭΪ5-����
      begin
        Ado_Alarm_OnLine.edit;
        Ado_Alarm_OnLine.fieldbyname('ISALARM').AsInteger := Ado_Data_Collect.fieldbyname('ISALARM').AsInteger;
        Ado_Alarm_OnLine.fieldbyname('errorcontent').AsString := Ado_Data_Collect.fieldbyname('errorcontent').AsString;
        Ado_Alarm_OnLine.fieldbyname('updatetime').AsDateTime := CurrTime;

         Ado_Alarm_OnLine.fieldbyname('flowtache').AsInteger:= 5;
         Ado_Alarm_OnLine.fieldbyname('removetime').AsVariant:=null;
         Ado_Alarm_OnLine.fieldbyname('RemoveOperator').AsVariant:=null;
         IsUpdate_CsIndex:=3;   //Ҫ������fault_master_online��alarm_device_info����л���
         IsSend_51:=true;

         Update_oprec(5, VSflowtache);
      end;      //�����Ƿ��Ǹ澯�ж�
    //Ado_Alarm_OnLine.post;
    Ado_Alarm_OnLine.CheckBrowseMode;
    inc(editrow);

    end else   //�澯��ͬ
    begin
      IsUpdate_CsIndex:=4;   //������ �������� ���� ת��״̬ ��ֻ���¸澯�� NEWCOLLECTTIME
    end;    //�澯�Ѿ����ڽ���
  end else     //1������Ч 5���������� 6���������ϣ��˸澯����δ���ɳ�
  begin        //����Ҫ���Ƿ�ͬһ��occurid(��BatchID)���Լ������澯��IfPresider��1�����ǴӸ澯��IfPresider��0��[���Ӹ澯Ϊ��һ�����]
    //�Ǹ澯״ֱ̬������
    if Ado_Data_Collect.fieldbyname('ISALARM').AsInteger=0 then exit;
      
    //�µ�ȡ����ʱ��λ��,������Ҫ  by cyx
    MainAlarm.startsend:=GetTime(Ado_Data_Collect.FieldByName('levelflagcode').AsInteger,Dm_Collect_Local.AlarmParam[CitySN].CityParam);
    MainAlarm.endsend:=GetTime(Ado_Data_Collect.FieldByName('levelflagcode').AsInteger,Dm_Collect_Local.AlarmParam[CitySN].CityParam,false);
    MainAlarm.LimitedHour:=Ado_Data_Collect.fieldbyname('LimitHour').AsInteger;

    Ado_Alarm_OnLine.append;
    case Judge_IfSendAlarm(4,MainAlarm) of //���Ϊ4�����ʾ�û�վ�Ѳɼ���δ���ϣ����ø澯Ӧ��Ϊ���澯���澯������������һ��
      1:
      begin
        IsUpdate_CsIndex:=0;
        MainAlarm.ESERVICECOCODE:= Get_Opposite_RuleDept(MainAlarm.CityID, Ado_Data_Collect.fieldbyname('substationID').AsInteger,MainAlarm.deviceid); //���ϸ��ļҴ�ά��˾
        MainAlarm.RuleDept:=0; //�ø澯���ĸ������������ϡ�����
        MainAlarm.flowtache:=5;
        MainAlarm.ALARMCONTENTCODE:=Ado_Data_Collect.fieldbyname('contentcode').AsInteger;
        MainAlarm.csid:=Ado_Data_Collect.fieldbyname('csid').AsInteger;
        MainAlarm.createtime:=Ado_Data_Collect.fieldbyname('createtime').AsDateTime; //�澯����ʱ��
        MainAlarm.sendtime:=CurrTime; //����ʱ��
        MainAlarm.cleartime:='';//����ȷ��ʱ�䣺������ȷ��ʱ�����븲�ǣ����︳ֵֻΪ��������ʱ������
        //MainAlarm.collecttime:=fieldbyname('Collecttime').AsDateTime; //��Judge_IfSendAlarm�ж�ʱ�Ѹ�ֵ
        MainAlarm.cancelsign:=0;
        MainAlarm.cancelnote:='�ݲ���';
        MainAlarm.removetime:='';
        MainAlarm.LimitedHour:=Ado_Data_Collect.fieldbyname('LimitHour').AsInteger;
        MainAlarm.alarmtype:=Ado_Data_Collect.fieldbyname('alarmtype').AsInteger;
        MainAlarm.ISALARM:= Ado_Data_Collect.fieldbyname('ISALARM').AsString; //�澯״̬���
        MainAlarm.ErrorContent:=Ado_Data_Collect.fieldbyname('errorcontent').AsString;
        MainAlarm.SendOperator :=0;
        MainAlarm.RemoveOperator :=0;
        MainAlarm.CollectOperator :=0;
        MainAlarm.ClearOperator :=0;
        MainAlarm.updatetime :=CurrTime;  //������ʱ��
        MainAlarm.RESENDTIME :=CurrTime;  //����ʱ��
        MainAlarm.eserviceentitycode:=1;  //ά��ʵ�壬����Ϊ1
        MainAlarm.notenum:=1; //�澯���ŷ��ʹ���Ϊ1
        MainAlarm.calleffect:=1;  //�澯ͨ������Ӱ��Ԥ��ֵΪ1(�и澯��Ӱ��δ֪)
        //MainAlarm.NewCollectTime:=fieldbyname('Collecttime').AsDateTime;//��Judge_IfSendAlarm�ж�ʱ�Ѹ�ֵ

        MainAlarm.BatchID:=GetNewCompSeqID('BatchID', MainAlarm); //�����µĸ澯����
        MainAlarm.occurid:=GetNewCompSeqID('OccurID', MainAlarm); //�����µĸ澯�����

        //�ɵ�ȡ����ʱ��λ��
        //MainAlarm.startsend:=Dm_Collect_Local.AlarmParam[CitySN].CityParam.SA_StartTime;
        //MainAlarm.endsend:=Dm_Collect_Local.AlarmParam[CitySN].CityParam.SA_EndTime;

        Ado_Alarm_OnLine.fieldbyname('BATCHID').AsInteger:=MainAlarm.BatchID;
        Ado_Alarm_OnLine.fieldbyname('IfPresider').AsInteger:=1; //��Ϊ���澯IfPresider��1

        blFirstAlarm := true;
      end;
      0:
      begin //��������ϱ�־Ϊ1�����ʾ�û�վ�����ϣ��ø澯Ӧ��Ϊ�Ӹ澯���澯���Ŵ�alarm_device_info���е�BatchID�ֶ��ж�ȡ
        IsUpdate_CsIndex:=1;
        //����Ŵ�alarm_device_info���е�BatchID�ֶ��л�ȡ,��Judge_IfSendAlarm�������Ѷ�ȡBatchID
        Ado_Alarm_OnLine.fieldbyname('BATCHID').AsInteger:=MainAlarm.BatchID;
        //��������
        Ado_Alarm_OnLine.fieldbyname('IfPresider').AsInteger:=0;  //��Ϊ�Ӹ澯IfPresider��0
      end;
      2:
      begin
        ErrorProcess(MainAlarm);
        IsError:=true;
        ChangeRowLog.error := true;
        exit;
      end;
    end;  //����case�ж�

    Ado_Alarm_OnLine.fieldbyname('companyid').AsInteger:=mainalarm.companyid;//
    Ado_Alarm_OnLine.fieldbyname('csid').AsInteger:=Ado_Data_Collect.fieldbyname('csid').AsInteger;//��վ���

    Ado_Alarm_OnLine.fieldbyname('alarmid').AsInteger := GetNewCompSeqID('AlarmID', MainAlarm); //�澯��ţ�Ϊ��������ˮ��  

    Ado_Alarm_OnLine.fieldbyname('alarmtype').AsInteger:=Ado_Data_Collect.fieldbyname('alarmtype').AsInteger; //�澯���ͣ�ʵʱ�澯[0]��15����[1/2]��1Сʱ[3]��
    Ado_Alarm_OnLine.fieldbyname('alarmcontentcode').AsInteger:=Ado_Data_Collect.fieldbyname('contentcode').AsInteger;//�澯���ݱ���
    Ado_Alarm_OnLine.fieldbyname('ISALARM').AsString:= Ado_Data_Collect.fieldbyname('ISALARM').AsString; //�澯״̬���
    Ado_Alarm_OnLine.fieldbyname('createtime').AsDateTime:= Ado_Data_Collect.fieldbyname('createtime').AsDateTime; //�澯����ʱ��
    Ado_Alarm_OnLine.fieldbyname('CollectTime').AsDateTime:=Ado_Data_Collect.fieldbyname('CollectTime').AsDateTime;
    Ado_Alarm_OnLine.fieldbyname('flowtache').AsInteger:=5; //�������̻��ڣ�flowtache��5��ʾ������
    Ado_Alarm_OnLine.fieldbyname('SendTime').AsDateTime:=CurrTime;  //����ʱ��
    Ado_Alarm_OnLine.fieldbyname('CityID').AsInteger:=Ado_Data_Collect.fieldbyname('CityID').AsInteger;
    Ado_Alarm_OnLine.fieldbyname('deviceid').AsInteger:= Ado_Data_Collect.fieldbyname('deviceid').AsInteger; //��վ�ڵ�ȫ��
    Ado_Alarm_OnLine.fieldbyname('codeviceid').AsInteger:= Ado_Data_Collect.fieldbyname('codeviceid').AsInteger; //��վ�ڵ�ȫ��
    Ado_Alarm_OnLine.fieldbyname('updatetime').AsDateTime:=CurrTime;
    Ado_Alarm_OnLine.fieldbyname('collecttime').AsDateTime:=Ado_Data_Collect.fieldbyname('collecttime').AsDateTime; //�ɼ�ʱ��
    Ado_Alarm_OnLine.fieldbyname('OccurID').AsInteger:=MainAlarm.OccurID;
    Ado_Alarm_OnLine.fieldbyname('errorcontent').AsString:= Ado_Data_Collect.fieldbyname('errorcontent').AsString;
    Ado_Alarm_OnLine.fieldbyname('alarmlocation').AsString:= Ado_Data_Collect.fieldbyname('alarmlocation').AsString;       
    Ado_Alarm_OnLine.fieldbyname('collectionkind').AsInteger:= Ado_Data_Collect.fieldbyname('collectionkind').AsInteger;
    Ado_Alarm_OnLine.fieldbyname('collectioncode').AsInteger:= Ado_Data_Collect.fieldbyname('collectioncode').AsInteger;

    //������ʱ by cyx
    Ado_Alarm_OnLine.fieldbyname('STARTSEND').AsString:= MainAlarm.startsend;
    Ado_Alarm_OnLine.fieldbyname('ENDSEND').AsString:= MainAlarm.endsend;
    Ado_Alarm_OnLine.fieldbyname('LIMITEDHOUR').AsInteger:=MainAlarm.LimitedHour;
    Ado_Alarm_OnLine.fieldbyname('RESENDTIME').AsDateTime:= CurrTime;

    Update_oprec(1, 10);

    IsSend_51:=true;
    Ado_Alarm_OnLine.post;
    Ado_Alarm_OnLine.CheckBrowseMode;
    inc(appendrow);

    Update_oprec(2, 4);

    if blFirstAlarm then  Update_oprec(34, 4);

  end;      //������λ����


  //IsUpdate_CsIndex=0-�¸澯-�������룩��
  //IsUpdate_CsIndex=1-�¸澯-�ӣ����룩
  //IsUpdate_CsIndex=2-������Ϣ�����£������ж��Ƿ���ȫ���ϣ���
  //IsUpdate_CsIndex=3-״̬���ˣ�����ϸ��flowtache������Ϊ5��
  //IsUpdate_CsIndex=4-������ͬ״̬

  case IsUpdate_CsIndex of
    0 :
    begin  
      //���±�alarm_device_info
      Update_alarm_device_info(MainAlarm);
      if not Update_fault_master_online(false, MainAlarm) then //�����fault_master_online ,falseΪ���룬trueΪ����
        raise Exception.Create('error0');

      //�жϴ��ϸ澯����������ϼ���������ϣ���������Ϊ���ϵĹ���
      upgrade_master_fault(MainAlarm);
      //------------------���¸���
    end;
    1 :
    begin
      //�жϴ��ϸ澯����������ϼ���������ϣ���������Ϊ���ϵĹ���
      upgrade_master_fault(MainAlarm);

      if not Judge_IfStayAlarm(MainAlarm.CityID, MainAlarm.occurid) then   //����Ϊfalse�����ʾ�û�վΪ�����ѻ�վ
      begin
        if MainAlarm.flowtache <> 5 then Update_oprec(33, MainAlarm.flowtache);

        MainAlarm.ISALARM :='1';
        MainAlarm.flowtache:=5;
        MainAlarm.RemoveOperator:=0;
        MainAlarm.removetime:='';
        MainAlarm.updatetime:=CurrTime;
        if not Update_fault_master_online(true, MainAlarm) then //���±�fault_master_online ,falseΪ���룬trueΪ����
        begin
          IsError:=true;
          ChangeRowLog.error := true;
          exit;
        end;
      end;
    end;
    2 :
    begin
      //�����fault_detail_online�У�������š�BatchID�����и澯��¼��flowtache��Ϊ6��flowtache=6��
      //������û�վ�����й��Ͼ����ų����ɽ������ϲ���
      {if AllDetailAlarmIsRemove(MainAlarm.CityID,MainAlarm.occurid, MainAlarm.companyid) then     //����Ϊtrue�����ʾ�û�վ�����и澯�����ų�
      begin
        IsSend_6:=true;
        MainAlarm.flowtache:=6;
        MainAlarm.ISALARM :='0';
        MainAlarm.RemoveOperator:=0;
        MainAlarm.RemoveTime:=CurrTime;
        MainAlarm.updatetime:=CurrTime;
        if not Update_fault_master_online(true,MainAlarm) then //���±�fault_master_online ,falseΪ���룬trueΪ����
        begin
          IsError:=true;
          ChangeRowLog.error := true;
          exit;
        end;
        //�����Զ��ύ-���Ϲ���
        with Sp_ALARM_SubmitAndWreck do
        begin
          close;
          Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//���б��
          Parameters.parambyname('Vcompanyid').Value:=MainAlarm.companyid;//
          Parameters.parambyname('VBatchid').Value:=MainAlarm.BatchID;//����   
          Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
          Parameters.parambyname('handlekind').Value:=5; // �ύ�����ϱ�־
          execproc;
          i:=Parameters.parambyname('iError').Value; //����ֵΪ���ͣ�
          close;
        end;
        if i=-1 then
          raise exception.Create('���� alarm_wrecker�洢���̳��� batchid:'+IntToStr(MainAlarm.BatchID)+' deviceid:'+MainAlarm.deviceid);
      end; }
    end;
    3 :
    begin
      if (not AllDetailAlarmIsRemove(MainAlarm.CityID,MainAlarm.occurid,MainAlarm.companyid))    //����Ϊfalse�����ʾ�û�վ���и澯δ�ų�
      and (not Judge_IfStayAlarm(MainAlarm.CityID,MainAlarm.occurid)) then   //����Ϊfalse�����ʾ�û�վΪ�����ѻ�վ
      begin
        with Ado_Dynamic do
        begin
          close;
          sql.Clear;
          sql.Add('select flowtache from fault_master_online '+
                 'where CityID=:CityID and companyid=:companyid and deviceid=:deviceid');
          Parameters.ParamByName('CityID').Value:= MainAlarm.CityID;
          Parameters.ParamByName('companyid').Value:= MainAlarm.companyid;
          Parameters.ParamByName('deviceid').Value:= MainAlarm.deviceid;
          open;
          if not IsEmpty then
          begin
            MainAlarm.flowtache:=fieldbyname('flowtache').AsInteger;
            if MainAlarm.flowtache <> 5 then Update_oprec(33, MainAlarm.flowtache);
          end;
          close;
        end;

        MainAlarm.flowtache:=5;
        MainAlarm.ISALARM :='1';
        MainAlarm.RemoveOperator:=0;
        MainAlarm.RemoveTime:='';
        MainAlarm.updatetime:=CurrTime;
        if not Update_fault_master_online(true,MainAlarm) then //���±�fault_master_online ,falseΪ���룬trueΪ����
        begin
          IsError:=true;
          ChangeRowLog.error := true;
          exit;
        end;
      end;
    end;
    4:
    begin
      // ��ͬ�ĸ澯  ���²ɼ�ʱ��

    end;
    else     //case�ж��� �������
    begin
      MessageContent:='����ͬ��վ��ͬ�澯���ݲ��Ҹ澯״̬��ͬ�ļ�¼,�ü�¼��������';
      Synchronize(AppendRunLog);
    end;
  end;   //case �ж�����

  ChangeRowLog.AppendRow  := appendrow;
  ChangeRowLog.EditRow  := editrow;    
end;  

function AutoSendAlarm.GetNewCompSeqID(SeqName: string; MainAlarm: TTableMasterList): Integer;
var
  strSQL: string;
begin
  if SeqName='AlarmID'then
  begin
    strSQL := 'select '+SeqName+' from fault_detail_online where CityID=:CityID and deviceid=:deviceid ';
    strSQL := strSQL + 'and alarmcontentcode=:alarmcontentcode and codeviceid=:codeviceid';
  end
  else
    strSQL := 'select '+SeqName+' from fault_master_online where CityID=:CityID and deviceid=:deviceid and '+SeqName+'<>0';

  with Ado_Dynamic do
  begin
    close;
    SQL.Clear;
    SQL.Add(strSQL);

    Parameters.parambyname('CityID').Value:= MainAlarm.cityid;
    Parameters.parambyname('deviceid').Value:= MainAlarm.deviceid;

    if SeqName='AlarmID' then
    begin
      Parameters.parambyname('alarmcontentcode').Value:= MainAlarm.ALARMCONTENTCODE;
      Parameters.parambyname('codeviceid').Value:= MainAlarm.codeviceid;
    end;

    open;
  end;

  if Ado_Dynamic.IsEmpty then
    Result := ProduceFlowNumID(SeqName, 1)
  else
    Result := Ado_Dynamic.fieldbyname(SeqName).AsInteger;

end;

procedure AutoSendAlarm.AlarmAfterSend(MainAlarm : TTableMasterList);
var
  i: integer;
begin
  with Sp_alarm_after_send do
  begin
    close;
    Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//���б��
    Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
    execproc;
    i:=Parameters.parambyname('iError').Value; //����ֵΪ���ͣ�
    close;
  end;

  if i=-1 then
    raise exception.Create('���� alarm_after_send �洢���̳��� batchid:'+IntToStr(MainAlarm.BatchID)+' deviceid:'+MainAlarm.deviceid);
end;


//�жϴ��ϸ澯����������ϼ���������ϣ���������Ϊ���ϵĹ���
procedure AutoSendAlarm.Upgrade_master_fault(MainAlarm : TTableMasterList);
var
   i : integer;
begin
  with Sp_upgrade_master_fault do
  begin
    close;
    Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//���б��
    Parameters.parambyname('Vcompanyid').Value:=MainAlarm.companyid;//���б��
    Parameters.parambyname('VBATCHID').Value:=MainAlarm.BATCHID;//���б��
    execproc;
    i:=Parameters.parambyname('iError').Value; //����ֵΪ���ͣ�
    close;
  end;

  if i<>0 then
    raise exception.Create('���� upgrade_master_fault �洢���̳��� batchid:'+IntToStr(MainAlarm.BatchID)+
       ' companyid:'+inttostr(MainAlarm.companyid)+' �����ţ�'+inttostr(i));
end;

procedure AutoSendAlarm.Alarm_Remove(MainAlarm: TTableMasterList);
var
  i: integer;
begin
  with Sp_alarm_remove do
  begin
    close;
    Parameters.parambyname('VCityID').Value := MainAlarm.CityID;
    Parameters.parambyname('Vcompanyid').Value := MainAlarm.companyid;
    Parameters.parambyname('PBATCHID').Value := 0; //MainAlarm.batchid;
    Parameters.parambyname('VAlarmIDS').Value := MainAlarm.AlarmIDS;
    Parameters.parambyname('VOperator').Value :='0';  // 0 -- SYS
    execproc;
    i:=Parameters.parambyname('iError').Value; //����ֵΪ���ͣ�
    close;
  end;
    
  if i=-1 then
  begin
    raise exception.Create('���� alarm_remove �洢���̳��� AlarmIDS:'+MainAlarm.AlarmIDS+' companyid:'+inttostr(MainAlarm.companyid));
  end;
end;

procedure AutoSendAlarm.AlarmDeleteInvalid(MainAlarm: TTableMasterList);
var
  i: integer;
begin
  with Sp_alarm_delete_invalid do
  begin
    close;
    Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//���б��
    Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
    execproc;
    i:=Parameters.parambyname('iError').Value; //����ֵΪ���ͣ�
    close;
  end;

  if i=-1 then
    raise exception.Create('���� alarm_delete_invalid �洢���̳��� batchid:'+IntToStr(MainAlarm.BatchID)+' deviceid:'+MainAlarm.deviceid);
end;

procedure AutoSendAlarm.ShowDubuginfo(sMessage: string);
begin
  if not IsDebug then exit;
  MessageContent:=datetimetostr(now)+':  '+sMessage;
  Synchronize(AppendRunLog);
end;



end.
