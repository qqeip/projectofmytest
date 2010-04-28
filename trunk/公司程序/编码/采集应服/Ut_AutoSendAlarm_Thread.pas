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

    function GetTimeLimitFromCsLevel(CsLevel:integer):integer; //根据基站等级得到省局故障基站修复时限

    function GetSysDateTime():TDateTime;  //得到数据库服务器时间

    function ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer; //得到指定类型的流水号

    //判断pop_cs表中的IfSendAlarm是否为指定的状态(State)，如果是(相等)则返回真，否则返回假
    Function Judge_IfSendAlarm(FlowTache:integer; var MainAlarm : TTableMasterList):integer;

    //对《流程环节变动跟踪表》fault_company_flowrec_online进行记录插入的过程，每一个环节的变动都需要往该表插入一行
    procedure Insert_alarm_oprec_online(oprec_List: TTable_oprec_List);

     //对表fault_master_online作更改，UpdateOrInsert＝true表示更新，否则为插入
    function Update_oprec(OperateDim, VSFlowtache: integer): boolean;

    //更新告警设备在线表信息(基站)
    procedure Update_alarm_device_info(MainAlarm : TTableMasterList);

    //对表fault_master_online作更改，UpdateOrInsert＝true表示更新，否则为插入
    function Update_fault_master_online(UpdateOrInsert:boolean; MainAlarm : TTableMasterList):boolean;

    function AllDetailAlarmIsRemove(CityID,OccurID,COMPANYID:integer):boolean;  //自动消障过程

    procedure AppendRunLog();  //添加消息到运行日志

    procedure ClearAfterAlarmSend;

    procedure ShowCollectMessage(appendrow,editrow,delrow:integer;Kind:boolean);//添加日志过程

    //修改fault_detail_online表的removetime、flowtache字段
    procedure Modify_Cs_OnLine(Cityid,AlarmID:integer);

    //判断从障告警级别，如果从障级别高于主障，升级从障为主障的过程
    procedure Upgrade_master_fault(MainAlarm : TTableMasterList);

    procedure ExecTheSQL(TheADOQuery: TADOQuery; TheSQL:string);

    function OpenTheAutoDataSet(TheADOQuery: TADOQuery; TheSQL:string):integer;

    //设置“按钮”是否可用
    procedure SetButton_IsEnable();

    //根据<分局编码>得到<代维公司编码>（OppositeKind＝2）或<网控中心编码>（OppositeKind＝1）
    function Get_Opposite_RuleDept(CityID, BranchID : integer;deviceid:String):integer;

    //判断该故障是否疑难故障，如为疑难返回true，否则返回false
    function Judge_IfStayAlarm(CityID,OccurID:integer):boolean;

    function GetAllowedCsLevel(CitySN:integer):string;  //得到允许派障的基站级别列表

    Procedure RestorationSendAlarm(CitySN:integer);  //复位基站允许派障过程（各个级别均置为不允许派障）

    //派障前的准备工作过程
    procedure PrepareBeforeSend(CityID:integer; AutoSendSQL:String; IsSendPoint:Boolean=false);

    Function ExecSingleCitySendAlarm(CitySN:integer; AutoSendSQL:String; CurrTime:TDateTime; var IsSend_51,IsSend_61,IsSend_6:boolean;IsSendPoint :Boolean=false):boolean;
    Function SendCompanyAlarm(MainAlarm : TTableMasterList; CitySN:integer; var IsError, IsSend_51,IsSend_61,IsSend_6:boolean;IsSendPoint :Boolean): TChangeRowLog;

    function GetLevelList(CurTime:TTime; Param :TTheAreaAlarmParam):String;
    function GetTime(level:integer; Param :TTheAreaAlarmParam;IsStrat:Boolean= true):String;

    function  OpenAdoQuery(TheADOQuery: TADOQuery; TheSQL:string): boolean;

    function GetNewCompSeqID(SeqName: string; MainAlarm: TTableMasterList): Integer;

    procedure AlarmAfterSend(MainAlarm : TTableMasterList);    //告警派障后善后处理
    procedure Alarm_Remove(MainAlarm : TTableMasterList);  //排障
    procedure AlarmDeleteInvalid(MainAlarm : TTableMasterList);    //删除无效告警(超出有效告警)

    procedure ShowDubuginfo(sMessage: string);

  protected
    procedure Execute; override;
  public
    //一天中派障起始时间和派障结束时间
    constructor Create(DBConn:string);
    destructor Destroy;override;

    //自动派障总体调度过程
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
  //从障加入历时字段等 by cyx 
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

  //维护单位多派
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

  //自动提交及消障
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


  //告警派障善后处理
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

  //无效告警自动删除
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


  //排障
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

  //主从障升级
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

  //再派障
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
           MessageContent:=datetimetostr(now)+'   来自《自动派障线程》的消息——线程执行错误，请通知系统管理员处理！';
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

//根据<分局编码>得到<代维公司编码>（OppositeKind＝2）或<网控中心编码>（OppositeKind＝1）
//先检测特殊指定辖区表中是否存在此基站
function AutoSendAlarm.Get_Opposite_RuleDept(CityID, BranchID : integer;deviceid:String):integer;
var
  sqlstr:string;
begin
  Result:=0;  //------------------------待完善
  exit;
  //  kind = 1标识 材料
  sqlstr:=' select districtid from alarm_appoint_district where kind=1 and (cityid,code) in('+
          ' select cityid,material_id from fms_device_info where deviceid='''+deviceid+''' and cityid='+IntToStr(cityid)+')';
  if OpenTheAutoDataSet(Ado_Dynamic,sqlstr)>0 then
    Result:=Ado_Dynamic.fieldbyname('districtid').AsInteger
  else //如果不存在特殊指定就按照正常派障
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
      Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //流水号命名
      Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //申请的连续流水号个数
      execproc;
      result:=Parameters.parambyname('O_FLOWVALUE').Value; //返回值为整型，过程只返回序列的第一个值，但下次返回值为：result+I_SERIESNUM
      close;
   end;
end;

//判断pop_cs表中的IfSendAlarm是否为指定的状态(State)，如果是(相等)则返回真，否则返回假
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
  //已经在结束时处理了校验
end;

//对表fault_master_online作更改，UpdateOrInsert＝true表示更新，否则为插入
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

   if UpdateOrInsert then  //true为更新操作
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
         exit; //如主障状态无变更，则过程退出

      if (FlowRec_List.SFlowtache=2) or (FlowRec_List.SFlowtache=3) or (FlowRec_List.SFlowtache=8) then
      begin
        //调用再派障过程，之后会在主单元调用自动提交-消障过程
        with Sp_Alarm_StayTo_Resend do
        begin
          close;
          Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//城市编号
          Parameters.parambyname('VBatchid').Value:=MainAlarm.BatchID;//批号
          Parameters.parambyname('Vcompanyid').Value:=MainAlarm.companyid;//
          Parameters.parambyname('SFlowTache').Value:=FlowRec_List.sflowtache;
          Parameters.parambyname('TFlowTache').Value:=FlowRec_List.tflowtache;
          Parameters.parambyname('VOperator').Value:=FlowRec_List.collectoperator;
          execproc;
          MainAlarm.batchid := Parameters.parambyname('VBatchid').Value;
          close;
        end;
        //重新获取 Occruid
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
        raise exception.Create('调用Alarm_StayTo_Resend存储过程出错！');

      if MainAlarm.flowtache=5 then //如为回退操作
      case FlowRec_List.SFlowtache of
       6 : FlowRec_List.UpdateNote:= '[排障    ]->[派障    ]';
       7 : FlowRec_List.UpdateNote:= '[提交    ]->[派障    ]';
      end;
      MainAlarm.NewCollectTime:=CurrTime;//如为回退操作，则需要变更newCollecttime为当前系统时间
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
      //更新表alarm_device_info
      Update_alarm_device_info(MainAlarm);
   end else //否则的话，如为插入操作
   begin
      FlowRec_List.SFlowtache:=4;
      FlowRec_List.UpdateNote:= '[待派    ]->[派障    ]';

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
      end else //如果为插入，则需赋值23个参数，如为更新，则只需赋5个参数
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
         //计算到期时间
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

function AutoSendAlarm.AllDetailAlarmIsRemove(CityID,OccurID, COMPANYID:integer):boolean;  //自动消障过程
var SltSQL:string;
    RecCount:integer;
begin
   //基站断电的故障（AlarmContentCode＝26）不作判断
   //源自：如果其它故障都好了，则不管“基站断电”是否已好，均可提交
   //处理：在此过滤“基站断电”条件将主障设为已排障
   SltSQL:='Select CityID,AlarmID,AlarmContentCode from fault_detail_online where CityID='+inttostr(CityID);
   SltSQL:=SltSQL+' and OccurID='+inttostr(OccurID)+' and COMPANYID='+inttostr(COMPANYID)+' and ISALARM=1 order by AlarmID';
   RecCount:=OpenTheAutoDataSet(Ado_Dynamic,SltSQL);
   with Ado_Dynamic do
   begin
     //如果有一条告警还没有排除，则不能消障
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

procedure AutoSendAlarm.AppendRunLog();  //添加消息到运行日志
begin
   Fm_RunLog.Re_RunLog.Lines.Add(MessageContent);
end;

//对表Alarm_Data_Collect进行记录删除的过程，以实现从移动数据到fault_detail_online的目的
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

procedure AutoSendAlarm.ShowCollectMessage(appendrow,editrow,delrow:integer;Kind:boolean);//添加日志过程
var collectstr:string;
begin
   if kind then
      collectstr:='采集:    '
   else
      collectstr:='派障:    ';
   collectstr:=collectstr+datetimetostr(now)+'   其中追加：'+inttostr(appendrow)+'   修改：'+inttostr(editrow)+'   删除：'+inttostr(delrow);
   MessageContent:=collectstr;
   Synchronize(AppendRunLog);
end;


//修改fault_detail_online表的removetime、flowtache字段
procedure AutoSendAlarm.Modify_Cs_OnLine(CityID,AlarmID:integer);
var UpdSQL:string;
begin
  UpdSQL:= 'Update fault_detail_online Set ISALARM = 0, RemoveTime = SysDate';
  UpdSQL:=UpdSQL+' where CityID='+IntToStr(CityID)+' and AlarmID = '+IntToStr(AlarmID);
  ExecTheSQL(Ado_Dynamic,UpdSQL);
end;

//设置“按钮”是否可用
procedure AutoSendAlarm.SetButton_IsEnable();
begin
   Fm_Collection_Data.Bt_AutoSend.Enabled:=ButtonIsEnable;
end;

//判断该故障是否疑难故障，如为疑难返回true，否则返回false
Function AutoSendAlarm.Judge_IfStayAlarm(CityID,OccurID:integer):boolean;
var slt:string;
begin
  slt:='select flowtache,batchid from fault_master_online where CityID='+inttostr(CityID);
  slt:=slt+' and OccurID='+inttostr(OccurID)+' and flowtache in (2,3,8)';
  Result:=(OpenTheAutoDataSet(Ado_Dynamic,slt)>0);
end;

//派障前的准备工作过程
procedure AutoSendAlarm.PrepareBeforeSend(CityID:integer; AutoSendSQL:String; IsSendPoint:Boolean);
var
   sqlstr:string;
begin
  //删除已存在的记录（alarm_data_collect 和 fault_detail_online 表中csid,alarmcontentcode,alarmstatus完全相同）
  {sqlstr:=' delete from alarm_data_collect where (CityID,deviceid,contentcode,ISALARM)';
  sqlstr:=sqlstr+' in (select CityID,deviceid,alarmcontentcode,ISALARM from fault_detail_online)';
  execthesql(Ado_Dynamic,sqlstr);}       // ----------------------------------- 待完善

  //将只有“基站断电”的基站故障过滤掉（删除），不要派障，不用判断是否远供基站(11-11 12:10修改)
  //1、<告警在线表>中尚未有告警
  //2、只有“基站断电”告警
  {sqlstr:= 'delete from alarm_data_collect ';
  sqlstr:=sqlstr+' where (cityid,deviceid) not in ';
  sqlstr:=sqlstr+' (select cityid,deviceid from fault_master_online) '; //1、判断<告警在线表>中是否存在有该基站的告警
  sqlstr:=sqlstr+' and (cityid,deviceid) in ';
  sqlstr:=sqlstr+' (select cityid,deviceid ';  //2、筛选只有一条断电告警(除为Clear告警的情况)的基站
  sqlstr:=sqlstr+' from alarm_data_collect ';
  sqlstr:=sqlstr+' where contentcode=26 and ISALARM=1 and (cityid,deviceid) in ';
  sqlstr:=sqlstr+' ( ';
  sqlstr:=sqlstr+' select a.cityid,a.deviceid from alarm_data_collect a ';   //只有一条告警的基站
  sqlstr:=sqlstr+' left join alarm_content_rule b on a.contentcode=b.alarmcontentcode and a.cityid=b.cityid';
  sqlstr:=sqlstr+' where b.sendtype=1';
  sqlstr:=sqlstr+' group by a.cityid,a.deviceid having count(contentcode)=1 ';
  sqlstr:=sqlstr+' ) ' ;
  sqlstr:=sqlstr+' ) ' ;
  execthesql(Ado_Dynamic,sqlstr);}
  //-----------------------------暂时不考虑

  //派障标志位
  sqlstr:= ' update alarm_data_collect set alarmissending=1 where ';
  if not IsSendPoint then
    sqlstr:=sqlstr+' ISALARM = 0 and ';
  sqlstr:=sqlstr+' ( CityID,deviceid,codeviceid,contentcode ) in ';
  sqlstr:=sqlstr+ '(select CityID,deviceid,codeviceid,contentcode from ('+AutoSendSQL+'))';


 // sqlstr:=sqlstr+' (select CityID,deviceid,codeviceidcontentcode from alarm_autosend_view where cityid='+inttostr(cityid)+')';
  ExecTheSQL(Ado_Dynamic, sqlstr);

end;



{*****************************自动派障总体调度过程******************************
********************************************************************************
***  过程功能：1、从表alarm_data_collect复制数据到表fault_detail_online      ***
***            2、更新或插入表fault_master_online                            ***
***            3、更新表或插入表alarm_device_info                            ***
***            4、插入《流程环节变动跟踪表》Alarm_FlowRec_OnLine             ***
***            5、对表Alarm_Data_Collect进行记录删除，以实现从移动数据       ***
***               到fault_detail_online的目的                                ***
***            6、广播一条实时消息给客户端，以便客户端及时去刷新显示（查询） ***
***                                                       J.F. Qiu           ***
***                                                       2009-07-17         ***     
*******************************************************************************}
Procedure AutoSendAlarm.AlarmSendOverall();
var
    k:integer;
    CurrTime:TDateTime;
    starttime,endtime:TTime;
    // IsSend_51=true ，表示有派障或回退信息，需发指令“51”通知客户端刷新相关界面
    // IsSend_61=true ，表示有告警排障信息，需发指令“61”通知客户端刷新相关界面
    // IsSend_6 =true ，表示有基站排障信息，需发指令“6”通知客户端刷新相关界面
    IsSend_51,IsSend_61,IsSend_6:boolean;  //是否发送该类告警刷新信息，
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
    try  //测试本地连接
      if Ado_DBConn.Connected then
        Ado_DBConn.Connected:=false;
      Ado_DBConn.Connected:=true;
    except
      MessageContent:=datetimetostr(now)+'   来自《自动派障线程》的消息——本地告警数据库连接失败，请通知系统管理员处理！';
      Synchronize(AppendRunLog);
      exit;
    end;
    try
      with Dm_Collect_Local do
      for k:=Low(AlarmParam) to High(AlarmParam) do
      begin
        CurrTime:=strtotime(timetostr(GetSysDateTime()));
        if AlarmParam[k].CityParam.IsAutoSend then  //判断是自动派障还是定点派障
        begin
          if Dm_Collect_Local.AlarmParam[K].TodayIsSend then
          begin
            ShowDubuginfo('当前派障方式：自动派障，今天可派障，将派全部可派告警！');
            AutoSendSQL := 'select * from alarm_autosend_view a where a.cityid='+inttostr(AlarmParam[k].CityID)+
                           ' and (a.ISALARM=0 or (a.alarmlevel, a.levelflagcode) in (select b.alarmlevel, b.devicelevel from alarm_send_level_view b) '+
                           ' or (a.cityid,a.DEVICEID) in (select c.cityid,c.DEVICEID from fault_detail_online c) '+
                           ' ) order by ISALARM,ALARMLEVEL,createtime ';
            //如果该基站已有在线告警   则派发告警 绕过派障时间设定
            
            IsSendPoint:= true;
          end
          else
          begin
            ShowDubuginfo('当前派障方式：自动派障，今天不可派障，将只派Clear告警!');
            AutoSendSQL:=' select * from alarm_autosend_view where ISALARM=0 and cityid='+inttostr(AlarmParam[k].CityID)+' order by ISALARM,ALARMLEVEL,createtime'
          end; 
        end
        else
        begin
          //如果没有到点或该天不允许派障，则只派发Clear告警
          CsLevelListStr:=GetAllowedCsLevel(K);
          if (CsLevelListStr<>'') and (Dm_Collect_Local.AlarmParam[K].TodayIsSend) then
          begin
            ShowDubuginfo('当前派障方式：定点派障，今天可派障，将派全部可派告警！');
            AutoSendSQL:=' select * from alarm_autosend_view where ((ISALARM=0) or (levelflagcode is null) ';
            AutoSendSQL:=AutoSendSQL+' or (ISALARM=1 and levelflagcode in ('+CsLevelListStr+'))) and cityid='+inttostr(AlarmParam[k].CityID);
            AutoSendSQL:=AutoSendSQL+' order by ALARMLEVEL,createtime ';
            IsSendPoint:= true;
          end
          else
          begin
            ShowDubuginfo('当前派障方式：定点派障，今天不可派障，将只派Clear告警!');
            AutoSendSQL:=' select * from alarm_autosend_view where ISALARM=0 and cityid='+inttostr(AlarmParam[k].CityID)+' order by ALARMLEVEL,createtime';
          end;
        end;
        if not ExecSingleCitySendAlarm(K,AutoSendSQL,CurrTime,IsSend_51,IsSend_61,IsSend_6,IsSendPoint) then
          exit;
      end; //for k:=Low(AlarmParam) to High(AlarmParam) do
      //发送消息
      endtime:=now;
      MessageContent:=datetimetostr(now)+'   已成功执行自动派障!  本次执行共花费时间：'+timetostr(endtime-starttime);
      Synchronize(AppendRunLog);
      if IsSend_51 then
      begin
        New(AData);
        AData.command := 5;
        AData.districtid := 0;
        AData.Msg := '派障';
        PostMessage(Application.MainForm.Handle, WM_THREAD_MSG, 0, Longint(AData));  
      end;
      if IsSend_61 or IsSend_6 then
      begin
         New(AData);
        AData.command := 6;
        AData.districtid := 0;
        AData.Msg := '排障';
        PostMessage(Application.MainForm.Handle, WM_THREAD_MSG, 0, Longint(AData));
      end;
    except
      MessageContent:=datetimetostr(now)+'   来自《自动派障线程》的消息——在进行以下操作时发生错误：<删除数据>或<打开数据集>或<写日志>或<发实时消息>时发生错误！';
      Synchronize(AppendRunLog);
    end;
  finally
    ButtonIsEnable:=true;
    Synchronize(SetButton_IsEnable);
    Ado_DBConn.Connected:=false;
  end;
end;

function AutoSendAlarm.GetAllowedCsLevel(CitySN:integer):string;  //得到允许派障的基站级别列表
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
    if ((Trim(SA_StartTime)<>'') or (Trim(SA_EndTime)<>'') ) and (CurTime >= StrToTime(SA_StartTime)) and (CurTime+3/60/24 <= StrToTime(SA_EndTime)) then      //  CurTime+3/60/24为了避免派障时间与统计时间冲突，Jx临时修改
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
      MessageContent := datetimetostr(now)+' 操作状态：'+IntToStr(oprec_List.operate)+' 未在字典表中定义！';
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
  MainAlarm : TTableMasterList;  //主障结构
  TotalChangeRowLog, ChangeRowLog: TChangeRowLog;
  i: integer;
begin
  IsError:=false;
  mainalarm.CityID:=Dm_Collect_Local.alarmparam[CitySN].CityID;
  try
    if IsTrans then Ado_DBConn.BeginTrans;

    //派障前的准备工作过程
    PrepareBeforeSend(mainalarm.CityID,AutoSendSQL, IsSendPoint);

    AlarmDeleteInvalid(MainAlarm); //无效告警自动删除

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
        ShowDubuginfo('在alarm_autosend_view告警中满足派障时间条件的告警记录数为：'+IntToStr(Ado_Data_Collect.RecordCount));
      end;

      TotalChangeRowLog.AppendRow := 0;
      TotalChangeRowLog.EditRow := 0;
      TotalChangeRowLog.DelRow := 0;

      first;
      while not eof do
      begin
        MainAlarm.deviceid := fieldbyname('deviceid').asstring;
        MainAlarm.ALARMCONTENTCODE := fieldbyname('contentcode').asinteger;

        //维护单位多派
        with Sp_ALARM_Device_Company do
        begin
          close;
          Parameters.parambyname('Pcityid').Value:=mainalarm.CityID;
          Parameters.parambyname('Pdeviceid').Value:=MainAlarm.deviceid;
          Parameters.parambyname('Pcontentcodein').Value:=MainAlarm.ALARMCONTENTCODE;
          execproc;
          i:=Parameters.parambyname('iError').Value; //返回值为整型，
          close;
        end;
        if i=-1 then
          raise exception.Create('调用 ALARM_Device_Company存储过程出错！ batchid:'+IntToStr(MainAlarm.BatchID)+' deviceid:'+MainAlarm.deviceid);

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


    ClearAfterAlarmSend; //此处调用删除记录过程


    if iserror then
    begin
       MessageContent:=datetimetostr(now)+'   companyid:-'+inttostr(MainAlarm.companyid)+' deviceid:-'+MainAlarm.deviceid +' 的基站派障调试信息！该基站告警信息已被清除！';
       Synchronize(AppendRunLog);
    end;
    if IsTrans then Ado_DBConn.CommitTrans;
    if TotalChangeRowLog.AppendRow+TotalChangeRowLog.EditRow>0 then
       ShowCollectMessage(TotalChangeRowLog.AppendRow,TotalChangeRowLog.EditRow,0,false);

   AlarmAfterSend(MainAlarm); //派障后处理
   // if IsSendPoint then
     // RestorationSendAlarm(CitySN);  //复位基站允许派障过程（各个级别均置为不允许派障）
  except
    on E: exception do
    begin
      if IsTrans then Ado_DBConn.RollbackTrans;
      MessageContent:=datetimetostr(now)+'   CityID:-'+inttostr(MainAlarm.CityID)+'《自动派障》过程中，事务处理失败:'+e.Message;
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

  //IsUpdate_CsIndex=0-新告警-主（插入），
  //IsUpdate_CsIndex=1-新告警-从（插入）
  //IsUpdate_CsIndex=2-排障信息（更新，并需判断是否已全排障），
  //IsUpdate_CsIndex=3-状态回退（主、细表flowtache均更新为5）
  //IsUpdate_CsIndex=4- 都是相同状态
begin
  ChangeRowLog.error := false;
  blFirstAlarm := false;

  IsUpdate_CsIndex:=0;
  CurrTime:=GetSysDateTime;

  MainAlarm.codeviceid := Ado_Data_Collect.fieldbyname('codeviceid').asstring;

  //已经有此告警内容       // 要注意 -------------如果 compid 配置改动后 要出去告警记录
  if Ado_Alarm_OnLine.Locate('companyid; deviceid; alarmcontentcode; codeviceid',
     VarArrayOf([mainalarm.companyid, mainalarm.deviceid, mainalarm.ALARMCONTENTCODE, mainalarm.codeviceid]),[loCaseInsensitive]) then
  begin
    MainAlarm.BatchID := Ado_Alarm_OnLine.fieldbyname('BatchID').AsInteger;
    MainAlarm.csid := Ado_Data_Collect.fieldbyname('csid').AsInteger;
    MainAlarm.occurid := Ado_Alarm_OnLine.fieldbyname('occurid').AsInteger;

    if Ado_Alarm_OnLine.fieldbyname('ISALARM').AsInteger <> Ado_Data_Collect.fieldbyname('ISALARM').AsInteger then
    begin   //这里要分flowtache，如果是已排障，要添加处理
      //Ado_Alarm_OnLine.edit;
      //Ado_Alarm_OnLine.fieldbyname('ISALARM').AsInteger := Ado_Data_Collect.fieldbyname('ISALARM').AsInteger;
      //Ado_Alarm_OnLine.fieldbyname('errorcontent').AsString := Ado_Data_Collect.fieldbyname('errorcontent').AsString;
      //Ado_Alarm_OnLine.fieldbyname('updatetime').AsDateTime := CurrTime;

      VSflowtache := Ado_Alarm_OnLine.fieldbyname('flowtache').AsInteger;
      //ISALARM＝0表示是排障信息
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
        IsUpdate_CsIndex:=2;   //要判断，确定是否对主表fault_master_online进行排障
        IsSend_61:=true;

        //Update_oprec(6, VSflowtache);
      end else  //ISALARM<>0表示是告警信息，则将flowtache状态还原为5-派障
      begin
        Ado_Alarm_OnLine.edit;
        Ado_Alarm_OnLine.fieldbyname('ISALARM').AsInteger := Ado_Data_Collect.fieldbyname('ISALARM').AsInteger;
        Ado_Alarm_OnLine.fieldbyname('errorcontent').AsString := Ado_Data_Collect.fieldbyname('errorcontent').AsString;
        Ado_Alarm_OnLine.fieldbyname('updatetime').AsDateTime := CurrTime;

         Ado_Alarm_OnLine.fieldbyname('flowtache').AsInteger:= 5;
         Ado_Alarm_OnLine.fieldbyname('removetime').AsVariant:=null;
         Ado_Alarm_OnLine.fieldbyname('RemoveOperator').AsVariant:=null;
         IsUpdate_CsIndex:=3;   //要对主表fault_master_online和alarm_device_info表进行回退
         IsSend_51:=true;

         Update_oprec(5, VSflowtache);
      end;      //结束是否是告警判断
    //Ado_Alarm_OnLine.post;
    Ado_Alarm_OnLine.CheckBrowseMode;
    inc(editrow);

    end else   //告警相同
    begin
      IsUpdate_CsIndex:=4;   //已派障 疑难申请 疑难 转发状态 则只更新告警的 NEWCOLLECTTIME
    end;    //告警已经存在结束
  end else     //1——无效 5——已派障 6——已排障；此告警内容未被派出
  begin        //这里要分是否同一批occurid(旧BatchID)，以及是主告警（IfPresider＝1）还是从告警（IfPresider＝0）[主从告警为：一主多从]
    //非告警状态直接跳过
    if Ado_Data_Collect.fieldbyname('ISALARM').AsInteger=0 then exit;
      
    //新的取派障时间位置,从障需要  by cyx
    MainAlarm.startsend:=GetTime(Ado_Data_Collect.FieldByName('levelflagcode').AsInteger,Dm_Collect_Local.AlarmParam[CitySN].CityParam);
    MainAlarm.endsend:=GetTime(Ado_Data_Collect.FieldByName('levelflagcode').AsInteger,Dm_Collect_Local.AlarmParam[CitySN].CityParam,false);
    MainAlarm.LimitedHour:=Ado_Data_Collect.fieldbyname('LimitHour').AsInteger;

    Ado_Alarm_OnLine.append;
    case Judge_IfSendAlarm(4,MainAlarm) of //如果为4，则表示该基站已采集（未派障），该告警应设为主告警，告警批号需新申请一个
      1:
      begin
        IsUpdate_CsIndex:=0;
        MainAlarm.ESERVICECOCODE:= Get_Opposite_RuleDept(MainAlarm.CityID, Ado_Data_Collect.fieldbyname('substationID').AsInteger,MainAlarm.deviceid); //派障给哪家代维公司
        MainAlarm.RuleDept:=0; //该告警由哪个网控中心派障、消障
        MainAlarm.flowtache:=5;
        MainAlarm.ALARMCONTENTCODE:=Ado_Data_Collect.fieldbyname('contentcode').AsInteger;
        MainAlarm.csid:=Ado_Data_Collect.fieldbyname('csid').AsInteger;
        MainAlarm.createtime:=Ado_Data_Collect.fieldbyname('createtime').AsDateTime; //告警创建时间
        MainAlarm.sendtime:=CurrTime; //派障时间
        MainAlarm.cleartime:='';//消障确认时间：在消障确认时再填入覆盖，这里赋值只为函数调用时不出错
        //MainAlarm.collecttime:=fieldbyname('Collecttime').AsDateTime; //在Judge_IfSendAlarm判断时已付值
        MainAlarm.cancelsign:=0;
        MainAlarm.cancelnote:='暂不用';
        MainAlarm.removetime:='';
        MainAlarm.LimitedHour:=Ado_Data_Collect.fieldbyname('LimitHour').AsInteger;
        MainAlarm.alarmtype:=Ado_Data_Collect.fieldbyname('alarmtype').AsInteger;
        MainAlarm.ISALARM:= Ado_Data_Collect.fieldbyname('ISALARM').AsString; //告警状态编号
        MainAlarm.ErrorContent:=Ado_Data_Collect.fieldbyname('errorcontent').AsString;
        MainAlarm.SendOperator :=0;
        MainAlarm.RemoveOperator :=0;
        MainAlarm.CollectOperator :=0;
        MainAlarm.ClearOperator :=0;
        MainAlarm.updatetime :=CurrTime;  //最后更新时间
        MainAlarm.RESENDTIME :=CurrTime;  //派障时间
        MainAlarm.eserviceentitycode:=1;  //维修实体，暂置为1
        MainAlarm.notenum:=1; //告警短信发送次数为1
        MainAlarm.calleffect:=1;  //告警通话质量影响预符值为1(有告警但影响未知)
        //MainAlarm.NewCollectTime:=fieldbyname('Collecttime').AsDateTime;//在Judge_IfSendAlarm判断时已付值

        MainAlarm.BatchID:=GetNewCompSeqID('BatchID', MainAlarm); //申请新的告警批号
        MainAlarm.occurid:=GetNewCompSeqID('OccurID', MainAlarm); //申请新的告警变更号

        //旧的取派障时间位置
        //MainAlarm.startsend:=Dm_Collect_Local.AlarmParam[CitySN].CityParam.SA_StartTime;
        //MainAlarm.endsend:=Dm_Collect_Local.AlarmParam[CitySN].CityParam.SA_EndTime;

        Ado_Alarm_OnLine.fieldbyname('BATCHID').AsInteger:=MainAlarm.BatchID;
        Ado_Alarm_OnLine.fieldbyname('IfPresider').AsInteger:=1; //设为主告警IfPresider＝1

        blFirstAlarm := true;
      end;
      0:
      begin //如果已派障标志为1，则表示该基站已派障，该告警应设为从告警，告警批号从alarm_device_info表中的BatchID字段中读取
        IsUpdate_CsIndex:=1;
        //批编号从alarm_device_info表中的BatchID字段中获取,在Judge_IfSendAlarm过程中已读取BatchID
        Ado_Alarm_OnLine.fieldbyname('BATCHID').AsInteger:=MainAlarm.BatchID;
        //升级从障
        Ado_Alarm_OnLine.fieldbyname('IfPresider').AsInteger:=0;  //设为从告警IfPresider＝0
      end;
      2:
      begin
        ErrorProcess(MainAlarm);
        IsError:=true;
        ChangeRowLog.error := true;
        exit;
      end;
    end;  //结束case判断

    Ado_Alarm_OnLine.fieldbyname('companyid').AsInteger:=mainalarm.companyid;//
    Ado_Alarm_OnLine.fieldbyname('csid').AsInteger:=Ado_Data_Collect.fieldbyname('csid').AsInteger;//基站编号

    Ado_Alarm_OnLine.fieldbyname('alarmid').AsInteger := GetNewCompSeqID('AlarmID', MainAlarm); //告警编号，为自增长流水号  

    Ado_Alarm_OnLine.fieldbyname('alarmtype').AsInteger:=Ado_Data_Collect.fieldbyname('alarmtype').AsInteger; //告警类型（实时告警[0]、15分钟[1/2]、1小时[3]）
    Ado_Alarm_OnLine.fieldbyname('alarmcontentcode').AsInteger:=Ado_Data_Collect.fieldbyname('contentcode').AsInteger;//告警内容编码
    Ado_Alarm_OnLine.fieldbyname('ISALARM').AsString:= Ado_Data_Collect.fieldbyname('ISALARM').AsString; //告警状态编号
    Ado_Alarm_OnLine.fieldbyname('createtime').AsDateTime:= Ado_Data_Collect.fieldbyname('createtime').AsDateTime; //告警创建时间
    Ado_Alarm_OnLine.fieldbyname('CollectTime').AsDateTime:=Ado_Data_Collect.fieldbyname('CollectTime').AsDateTime;
    Ado_Alarm_OnLine.fieldbyname('flowtache').AsInteger:=5; //所处流程环节，flowtache＝5表示已派障
    Ado_Alarm_OnLine.fieldbyname('SendTime').AsDateTime:=CurrTime;  //派障时间
    Ado_Alarm_OnLine.fieldbyname('CityID').AsInteger:=Ado_Data_Collect.fieldbyname('CityID').AsInteger;
    Ado_Alarm_OnLine.fieldbyname('deviceid').AsInteger:= Ado_Data_Collect.fieldbyname('deviceid').AsInteger; //基站节点全称
    Ado_Alarm_OnLine.fieldbyname('codeviceid').AsInteger:= Ado_Data_Collect.fieldbyname('codeviceid').AsInteger; //基站节点全称
    Ado_Alarm_OnLine.fieldbyname('updatetime').AsDateTime:=CurrTime;
    Ado_Alarm_OnLine.fieldbyname('collecttime').AsDateTime:=Ado_Data_Collect.fieldbyname('collecttime').AsDateTime; //采集时间
    Ado_Alarm_OnLine.fieldbyname('OccurID').AsInteger:=MainAlarm.OccurID;
    Ado_Alarm_OnLine.fieldbyname('errorcontent').AsString:= Ado_Data_Collect.fieldbyname('errorcontent').AsString;
    Ado_Alarm_OnLine.fieldbyname('alarmlocation').AsString:= Ado_Data_Collect.fieldbyname('alarmlocation').AsString;       
    Ado_Alarm_OnLine.fieldbyname('collectionkind').AsInteger:= Ado_Data_Collect.fieldbyname('collectionkind').AsInteger;
    Ado_Alarm_OnLine.fieldbyname('collectioncode').AsInteger:= Ado_Data_Collect.fieldbyname('collectioncode').AsInteger;

    //从障历时 by cyx
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

  end;      //结束定位从障


  //IsUpdate_CsIndex=0-新告警-主（插入），
  //IsUpdate_CsIndex=1-新告警-从（插入）
  //IsUpdate_CsIndex=2-排障信息（更新，并需判断是否已全排障），
  //IsUpdate_CsIndex=3-状态回退（主、细表flowtache均更新为5）
  //IsUpdate_CsIndex=4-都是相同状态

  case IsUpdate_CsIndex of
    0 :
    begin  
      //更新表alarm_device_info
      Update_alarm_device_info(MainAlarm);
      if not Update_fault_master_online(false, MainAlarm) then //插入表fault_master_online ,false为插入，true为更新
        raise Exception.Create('error0');

      //判断从障告警级别，如果从障级别高于主障，升级从障为主障的过程
      upgrade_master_fault(MainAlarm);
      //------------------最新更新
    end;
    1 :
    begin
      //判断从障告警级别，如果从障级别高于主障，升级从障为主障的过程
      upgrade_master_fault(MainAlarm);

      if not Judge_IfStayAlarm(MainAlarm.CityID, MainAlarm.occurid) then   //返回为false，则表示该基站为非疑难基站
      begin
        if MainAlarm.flowtache <> 5 then Update_oprec(33, MainAlarm.flowtache);

        MainAlarm.ISALARM :='1';
        MainAlarm.flowtache:=5;
        MainAlarm.RemoveOperator:=0;
        MainAlarm.removetime:='';
        MainAlarm.updatetime:=CurrTime;
        if not Update_fault_master_online(true, MainAlarm) then //更新表fault_master_online ,false为插入，true为更新
        begin
          IsError:=true;
          ChangeRowLog.error := true;
          exit;
        end;
      end;
    end;
    2 :
    begin
      //如果表fault_detail_online中，“批编号”BatchID的所有告警记录的flowtache都为6：flowtache=6，
      //则表明该基站的所有故障均已排除，可进行消障操作
      {if AllDetailAlarmIsRemove(MainAlarm.CityID,MainAlarm.occurid, MainAlarm.companyid) then     //返回为true，则表示该基站的所有告警均已排除
      begin
        IsSend_6:=true;
        MainAlarm.flowtache:=6;
        MainAlarm.ISALARM :='0';
        MainAlarm.RemoveOperator:=0;
        MainAlarm.RemoveTime:=CurrTime;
        MainAlarm.updatetime:=CurrTime;
        if not Update_fault_master_online(true,MainAlarm) then //更新表fault_master_online ,false为插入，true为更新
        begin
          IsError:=true;
          ChangeRowLog.error := true;
          exit;
        end;
        //调用自动提交-消障过程
        with Sp_ALARM_SubmitAndWreck do
        begin
          close;
          Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//城市编号
          Parameters.parambyname('Vcompanyid').Value:=MainAlarm.companyid;//
          Parameters.parambyname('VBatchid').Value:=MainAlarm.BatchID;//批号   
          Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
          Parameters.parambyname('handlekind').Value:=5; // 提交和消障标志
          execproc;
          i:=Parameters.parambyname('iError').Value; //返回值为整型，
          close;
        end;
        if i=-1 then
          raise exception.Create('调用 alarm_wrecker存储过程出错！ batchid:'+IntToStr(MainAlarm.BatchID)+' deviceid:'+MainAlarm.deviceid);
      end; }
    end;
    3 :
    begin
      if (not AllDetailAlarmIsRemove(MainAlarm.CityID,MainAlarm.occurid,MainAlarm.companyid))    //返回为false，则表示该基站尚有告警未排除
      and (not Judge_IfStayAlarm(MainAlarm.CityID,MainAlarm.occurid)) then   //返回为false，则表示该基站为非疑难基站
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
        if not Update_fault_master_online(true,MainAlarm) then //更新表fault_master_online ,false为插入，true为更新
        begin
          IsError:=true;
          ChangeRowLog.error := true;
          exit;
        end;
      end;
    end;
    4:
    begin
      // 相同的告警  更新采集时间

    end;
    else     //case判定的 例外情况
    begin
      MessageContent:='仍有同基站、同告警内容并且告警状态相同的记录,该记录已跳过！';
      Synchronize(AppendRunLog);
    end;
  end;   //case 判定结束

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
    Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//城市编号
    Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
    execproc;
    i:=Parameters.parambyname('iError').Value; //返回值为整型，
    close;
  end;

  if i=-1 then
    raise exception.Create('调用 alarm_after_send 存储过程出错！ batchid:'+IntToStr(MainAlarm.BatchID)+' deviceid:'+MainAlarm.deviceid);
end;


//判断从障告警级别，如果从障级别高于主障，升级从障为主障的过程
procedure AutoSendAlarm.Upgrade_master_fault(MainAlarm : TTableMasterList);
var
   i : integer;
begin
  with Sp_upgrade_master_fault do
  begin
    close;
    Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//城市编号
    Parameters.parambyname('Vcompanyid').Value:=MainAlarm.companyid;//城市编号
    Parameters.parambyname('VBATCHID').Value:=MainAlarm.BATCHID;//城市编号
    execproc;
    i:=Parameters.parambyname('iError').Value; //返回值为整型，
    close;
  end;

  if i<>0 then
    raise exception.Create('调用 upgrade_master_fault 存储过程出错！ batchid:'+IntToStr(MainAlarm.BatchID)+
       ' companyid:'+inttostr(MainAlarm.companyid)+' 错误编号：'+inttostr(i));
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
    i:=Parameters.parambyname('iError').Value; //返回值为整型，
    close;
  end;
    
  if i=-1 then
  begin
    raise exception.Create('调用 alarm_remove 存储过程出错！ AlarmIDS:'+MainAlarm.AlarmIDS+' companyid:'+inttostr(MainAlarm.companyid));
  end;
end;

procedure AutoSendAlarm.AlarmDeleteInvalid(MainAlarm: TTableMasterList);
var
  i: integer;
begin
  with Sp_alarm_delete_invalid do
  begin
    close;
    Parameters.parambyname('VCityID').Value:=MainAlarm.CityID;//城市编号
    Parameters.parambyname('VOperator').Value:='0';  // 0 -- SYS
    execproc;
    i:=Parameters.parambyname('iError').Value; //返回值为整型，
    close;
  end;

  if i=-1 then
    raise exception.Create('调用 alarm_delete_invalid 存储过程出错！ batchid:'+IntToStr(MainAlarm.BatchID)+' deviceid:'+MainAlarm.deviceid);
end;

procedure AutoSendAlarm.ShowDubuginfo(sMessage: string);
begin
  if not IsDebug then exit;
  MessageContent:=datetimetostr(now)+':  '+sMessage;
  Synchronize(AppendRunLog);
end;



end.
