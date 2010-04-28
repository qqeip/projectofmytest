unit Ut_InteAttempCollect_Thread;

interface

uses
  Classes {$IFDEF MSWINDOWS} , Windows {$ENDIF}, ADODB, SysUtils, ComCtrls,
  Variants, DB, Controls, StrUtils,Ut_AlarmTestDefine;

type
  TTable_Cs_Index = record
    batchid : integer;
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
    LimitHour : Integer;
    ALARMSTATUS : string;
    ESERVICECOCODE : integer;
    deviceid : String;
  end;
type
  TAskTest = record
    deviceid :String;
    Cityid :integer;
    ContentCode :integer;
    TESTCODE :String;
    TESTSN :integer;
    UNCP :String;
    CSCIP :String;
    CS_INDEX :integer;
    Batchid :Integer;
    Factory :integer;
  end;
type
  TAlarm_Key_Data_Collect = record
    deviceid : String;
    AlarmType:integer;
    ContentCode:integer;
  end;
  TRuleType = record
    cityid :integer;
    //存放派单规则ID
    RuleList : TStringList;
    //话务影响规则
    CallList : TStringList;
  end;

type
  InteAttempCollect = class(TThread)
  private
    Ado_DBConn: TADOConnection;
    Sp_Alarm_FlowNumber: TADOStoredProc;
    Sp_update_alarm_codevice_info: TADOStoredProc;
    Ado_Free: TADOQuery;
    Ado_Dynamic: TADOQuery;
    Ado_Rule_Kind :TADOQuery;
    Ado_Collect_Main: TADOQuery;
    Ado_Data_Collect: TADOQuery;
    Ado_CollectGather: TADOQuery;
    Ado_AlarmTest: TADOQuery;
    ButtonIsEnable:Boolean;
    MessageContent:String;
    IsTrans: boolean;

    //存放所有本地网的派单规则和话务规则数组
    RuleArray :Array of TRuleType;

    procedure InitRuleArray;

    function GetRuleParamID(cityid,Kind :integer):TStringList;
    function GetRuleSQL(deviceid,cityid,RuleID : String;var bResult:Boolean) :String;
    //派单规则
    procedure Modify_RuleKind();
    function JudgeRuleKind(deviceid,cityid:string):integer; //根据deviceid确定属于哪个派障规则,并修改某字段
    function UpdateAlarmRuleID(deviceid,cityid,RuleID,sSQL : String):Integer;

    //话务规则
    procedure Modify_CallEfect();
    function JudgeCallEffect(deviceid,cityid:string):integer;
    function UpdateCallEffect(deviceid,cityid,RuleID,sSQL : String):Integer;
    function ProcessLinecircuit(ContentCode:integer):boolean;

    procedure UpdateAlarmCoDeviceinfo(CityID, DeviceID: integer);

    procedure SetName;

    //设置“按钮”是否可用
    procedure SetButton_IsEnable();

    //添加消息到运行日志
    procedure AppendRunLog();

    function GetSysDateTime():TDateTime;

    //判断是否已采集
    Function Judge_IsCollect(cityid:integer; deviceid:string):boolean;

    //采集前的准备工作
    procedure PrepareBeforeCollect();

    //采集后的清除工作
    procedure ClearAfterCollect();

    procedure ShowCollectMessage(appendrow,editrow,delrow:integer;Kind:boolean);//添加日志过程

    //填补新插入的alarm_device_info的数据
    procedure FillValueto_AlarmCsInfo();

    //重新生成Alarm_Data_Collect表中人工干预部份的主障
    procedure ARRANGE_For_ManualSend();

    //根据deviceid编辑、添加、删除表alarm_device_info的数据
    procedure Modify_alarm_device_info(CityID,HandleID:integer; deviceid,FormatStr:string);

    procedure ExecTheSQL(TheADOQuery: TADOQuery; TheSQL:string);

    function OpenTheDataSet(TheADOQuery: TADOQuery; TheSQL:string):integer;   

    function GetTimeLimitFromCsLevel(CsLevel:integer):integer;

    procedure IstRecordToSubMaster(CityID:integer; deviceid:string);

    function ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer;

    Function GetCitySN(CityID:integer):integer;

    //根据<分局编码>得到<代维公司编码>（OppositeKind＝2）或<网控中心编码>（OppositeKind＝1）
    function Get_Opposite_RuleDept(CityID, BranchID : integer):integer;

    function JudgeIsPutUpExamine(CityID :integer; deviceid :String):boolean;
    //将告警内容加入待测试表
    function AppendTestAlarm(deviceid:String;contentcode,cityid :integer):Boolean;
    function GetAlarmTestCode(contentcode,cityid :integer):String;
    function GetAlarmTest_(cityid,contentcode:integer;deviceid:String;var Ask :TAskTest):Boolean;  

    //告警测试
    //procedure AskForAlarmTest;
  protected
    procedure Execute; override;
  public
    constructor Create(DBConn:string);
    destructor Destroy;override;

    //告警采集总调度过程
    procedure Data_Collect();
  end;

implementation

uses Ut_Collection_Data, Ut_RunLog, Ut_Data_Local, Ut_common;

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

procedure InteAttempCollect.SetName;
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

Function InteAttempCollect.GetCitySN(CityID:integer):integer;
var
  i:integer;
  tempstr:string;
begin
  Result:=-1;
  with Dm_Collect_Local do
  for i:=low(AlarmParam) to high(AlarmParam) do
  if AlarmParam[i].CityID=CityID then
  begin
    Result:=i;
    break;
  end;
  if Result=-1 then
  begin
    tempstr:='表alarm_collection_cyc_list中的CITYID与alarm_sys_function_set表中的CITYID不一致错误，可按以下步骤操作：'+char(13);
    tempstr:=tempstr+'1、停止所有数据采集操作。'+char(13);
    tempstr:=tempstr+'2、检查2表，并重新配置网管数据并对相应的采集规则作配置。'+char(13);
    tempstr:=tempstr+'3、退出派障应用服务程序。'+char(13);
    tempstr:=tempstr+'4、清除alarm_data_gather及以其上游表单的数据。'+char(13);
    tempstr:=tempstr+'5、重启应用服务。'+char(13);
    tempstr:=tempstr+'6、如仍无法解决问题，请联系系统管理员或软件厂商解决!'+char(13);
    raise Exception.Create(tempstr);
  end;
end;

function InteAttempCollect.ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer;
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

constructor InteAttempCollect.Create(DBConn:string);
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

  Sp_update_alarm_codevice_info:= TADOStoredProc.Create(nil);
  with Sp_update_alarm_codevice_info do
  begin
     Close;
     Connection := Ado_DBConn;
     ProcedureName:='update_alarm_codevice_info';
     Parameters.Clear;
     Parameters.CreateParameter('Vcityid',ftString,pdInput,100,null);
     Parameters.CreateParameter('VDeviceid',ftString,pdInput,100,null);
     Parameters.CreateParameter('iError',ftInteger,pdOutput,0,null);  
     Prepared;
  end;

  Ado_Free := TAdoQuery.Create(nil);
  Ado_Free.Connection := Ado_DBConn;

  Ado_Dynamic := TAdoQuery.Create(nil);
  Ado_Dynamic.Connection := Ado_DBConn;

  Ado_Rule_Kind :=TADOQuery.Create(nil);
  Ado_Rule_Kind.Connection := Ado_DBConn;
  //告警测试
  Ado_AlarmTest :=TADOQuery.Create(nil);
  with  Ado_AlarmTest do
  begin
    Connection := Ado_DBConn;
    SQL.Clear;
    SQL.Add('select * from ALARM_TEST_ASKLIST');
    Prepared := true;
  end;
  
  Ado_Data_Collect := TAdoQuery.Create(nil);
  sqlstr:=' select cityid, csid, alarmtype, contentcode, ISALARM, createtime, IfPresider,';
  sqlstr:=sqlstr+' deviceid, codeviceid, collecttime, errorcontent, isnewappend, collectionkind, collectioncode, ALARMCOUNT, alarmlocation';
  sqlstr:=sqlstr+' from alarm_data_collect';
  sqlstr:=sqlstr+' where cityid = :cityid and deviceid = :deviceid';
  sqlstr:=sqlstr+' order by contentcode,ISALARM';
  with Ado_Data_Collect do
  begin
     Connection := Ado_DBConn;
     Close;
     SQL.Clear;
     SQL.Add(SQLSTR);
  end;

  Ado_CollectGather := TAdoQuery.Create(nil);
  //sqlstr := 'select * from Alarm_Data_Gather t where t.isprocess=1 '+
            //'and cityid = :cityid and deviceid=:deviceid order by contentcode,ISALARM';
  sqlstr:=' select * from Alarm_CollectGather_view';
  sqlstr:=sqlstr+' where cityid = :cityid and deviceid = :deviceid and isprocess=1';
  sqlstr:=sqlstr+' order by contentcode,ISALARM';
  with Ado_CollectGather do
  begin
     Connection := Ado_DBConn;
     Close;
     SQL.Clear;
     SQL.Add(SQLSTR);
  end;

  Ado_Collect_Main := TAdoQuery.Create(nil);
  sqlstr := 'select cityid,deviceid from (select cityid,deviceid from Alarm_Data_Gather a where a.isprocess=1) t '+
            'group by cityid,deviceid order by cityid,deviceid';
  //sqlstr := ' select cityid,deviceid from Alarm_CollectGather_view where isprocess=1 ';
  //sqlstr := sqlstr + ' group by cityid,deviceid order by cityid,deviceid';
  with Ado_Collect_Main do
  begin
     Connection := Ado_DBConn;
     Close;
     SQL.Clear;
     SQL.Add(sqlstr);
     Prepared;
  end;
  //初始化派单规则和话务规则
  InitRuleArray;
  Ado_DBConn.Connected:=false;

  IsTrans := true;
end;

destructor InteAttempCollect.Destroy;
begin

  Ado_Free.Close;
  Ado_Free.Free;
  Ado_Dynamic.Close;
  Ado_Dynamic.Free;
  Ado_Rule_Kind.Close;
  Ado_Rule_Kind.Free;
  Ado_AlarmTest.Close;
  Ado_AlarmTest.Free;
  Ado_Data_Collect.Close;
  Ado_Data_Collect.Free;
  Ado_CollectGather.Close;
  Ado_CollectGather.Free;
  Ado_Collect_Main.Close;
  Ado_Collect_Main.Free;
  Sp_Alarm_FlowNumber.Close;
  Sp_Alarm_FlowNumber.Free;
  Sp_update_alarm_codevice_info.Close;
  Sp_update_alarm_codevice_info.Free;      
  Ado_DBConn.Close;
  Ado_DBConn.Free;
  inherited;
end;

procedure InteAttempCollect.ExecTheSQL(TheADOQuery: TADOQuery; TheSQL:string);
begin
  with TheADOQuery do
  begin
    close;
    sql.Clear;
    sql.Add(TheSQL);
    ExecSQL;
  end;
end;

function InteAttempCollect.OpenTheDataSet(TheADOQuery: TADOQuery; TheSQL:string):integer;
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

procedure InteAttempCollect.Execute;
begin
  //SetName;
  while (not terminated) do
  begin
    try
      try
         Data_Collect;
      except
         MessageContent:=datetimetostr(now)+'   来自《数据采集线程》的消息——线程执行错误，请通知系统管理员处理！';
         Synchronize(AppendRunLog);
      end;
    finally
      Suspend;
    end;
  end;
  { Place thread code here }
end;

//设置“按钮”是否可用
procedure InteAttempCollect.SetButton_IsEnable();
begin
   Fm_Collection_Data.Bt_DataCollect.Enabled:=ButtonIsEnable;
end;

procedure InteAttempCollect.AppendRunLog();  //添加消息到运行日志
begin
   Fm_RunLog.Re_RunLog.Lines.Add(MessageContent); 
end;

//判断是否已采集
Function InteAttempCollect.Judge_IsCollect(cityid:integer; deviceid:string):boolean;
var
  sqlstr:string;
begin
  sqlstr:=' select cityid, deviceid from alarm_device_info where cityid='+inttostr(cityid);
  sqlstr:=sqlstr+' and deviceid='+QuotedStr(deviceid);
  if OpenTheDataSet(Ado_Dynamic,sqlstr)=0 then
     Result:=false
  else
     Result:=true;
end;

//采集前的准备工作过程
procedure InteAttempCollect.PrepareBeforeCollect();
var
   sqlstr:string;
begin
  //将alarm_data_gather表中当前所有行的isprocess字段值为1
  sqlstr:='update Alarm_Data_Gather set isprocess=1';
  ExecTheSQL(Ado_Dynamic, sqlstr);

  //删除重复记录，使复制到alarm_data_collect表中主键相同的记录只剩一条
  sqlstr:=' delete from Alarm_Data_Gather a where to_number(to_char(collectid)||ltrim(to_char(alarmautoid,''000'')))'+
          ' not in (select max(to_number(to_char(collectid)||ltrim(to_char(alarmautoid,''000''))))'+
          ' from Alarm_Data_Gather b where a.cityid=b.cityid and a.deviceid = b.deviceid '+
          ' and a.codeviceid = b.codeviceid and a.contentcode = b.contentcode )';
  ExecTheSQL(Ado_Dynamic, sqlstr);   

  //RRU告警更新设备编号
  //sqlstr:='update alarm_data_gather d set d.deviceid=d.codeviceid||lpad(d.deviceid,8,0), codeviceid=0 ';
  sqlstr:='update alarm_data_gather d set d.deviceid=d.codeviceid||lpad(d.deviceid,8,0) '+
          'where d.rowid in ( select t.rowid from alarm_data_gather t '+
          'inner join (select distinct a.cityid, a.bts_label from fms_device_info a where a.devicetype=3) b '+
          'on b.cityid=t.cityid and b.bts_label=t.deviceid where t.codeviceid<>0 ) ';
  ExecTheSQL(Ado_Dynamic, sqlstr); 

  //删除告警中的基站状态正常且不在alarm_device_info表中（deviceid not in ）的信息
  sqlstr:=' delete from Alarm_Data_Gather where ISALARM=0 and (cityid, deviceid) ';
  sqlstr:=sqlstr+' not in (select cityid, deviceid from alarm_device_info) ';
  ExecTheSQL(Ado_Dynamic, sqlstr);   

  //从Alarm_Data_Gather表中删除Alarm_Data_Collect表中已存在的记录{deviceid=deviceid,contentcode=contentcode}
  sqlstr:=' delete from Alarm_Data_Gather a where a.ISALARM=1 and (a.cityid,a.deviceid,a.codeviceid,a.contentcode) '+
         ' in (select t.cityid,t.deviceid,t.codeviceid,t.contentcode from alarm_Data_Collect t where t.ISALARM=1)';
  ExecTheSQL(Ado_Dynamic, sqlstr);         
  sqlstr:=' delete from Alarm_Data_Gather a where a.ISALARM=1 and (a.cityid,a.deviceid,a.codeviceid,a.contentcode) '+
         ' in (select t.cityid,t.deviceid,t.codeviceid,t.alarmcontentcode from fault_detail_online t where t.ISALARM=1)';
  ExecTheSQL(Ado_Dynamic, sqlstr);
  //------------------------------暂时没有告警产生门限 故需要删除。。。   20091216

  //将alarm_data_Collect表中IsNewAppend字段值置为空
  sqlstr:='update Alarm_Data_Collect set IsNewAppend=null';
  ExecTheSQL(Ado_Dynamic, sqlstr);     
end;

procedure InteAttempCollect.ClearAfterCollect();
var
  sqlstr:string;
begin
  sqlstr:=' Delete from Alarm_Data_Gather where isprocess=1';
  ExecTheSQL(Ado_Dynamic, sqlstr);

  sqlstr:=' Update alarm_device_info Set IsNewAppend=null where IsNewAppend is not null';
  ExecTheSQL(Ado_Dynamic, sqlstr);

  //--以下为保证数据完整性所做的数据修正   新修改
  sqlstr:=' delete from alarm_data_collect where (cityid, deviceid, codeviceid,contentcode, ISALARM)';
  sqlstr:=sqlstr+' in (select cityid, deviceid, codeviceid,alarmcontentcode, ISALARM from fault_detail_online)';
  ExecTheSQL(Ado_Dynamic, sqlstr);

  sqlstr:=' delete from fault_detail_online where flowtache=5 and ISALARM=0 ';
  ExecTheSQL(Ado_Dynamic, sqlstr);

  //sqlstr:=' delete from alarm_device_info where (cityid, deviceid) not in ';
  //sqlstr:=sqlstr+' (select cityid, deviceid from alarm_online_detail_view)';
  sqlstr:=' delete from alarm_device_info t where not exists ';
  sqlstr:=sqlstr+'(select 1 from alarm_data_collect a where a.cityid=t.cityid and a.deviceid=t.deviceid) ';
  sqlstr:=sqlstr+'and not exists (select 1 from fault_detail_online ';
  sqlstr:=sqlstr+'a where a.cityid=t.cityid and a.deviceid=t.deviceid) ';  
  ExecTheSQL(Ado_Dynamic, sqlstr);   

  //sqlstr:=' delete from alarm_data_collect where (cityid, deviceid) not in ';
  //sqlstr:=sqlstr+' (select cityid, deviceid from alarm_device_info)';
  sqlstr:=' delete from alarm_data_collect t where not exists  ';
  sqlstr:=sqlstr+'(select 1 from alarm_device_info a where a.cityid=t.cityid and a.deviceid=t.deviceid)';
  ExecTheSQL(Ado_Dynamic, sqlstr);   

  sqlstr:=' delete from alarm_manpower_online where batchid not in ';
  sqlstr:=sqlstr+' (select batchid from fault_master_online)';
  ExecTheSQL(Ado_Dynamic, sqlstr);


  //删除无效资料缺失告警            
  sqlstr := 'delete Alarm_Data_Collect t where t.contentcode=800000001 and exists '+
            '(select 1 from fms_device_info a where a.DEVICEID=t.DEVICEID and a.cityid=t.cityid and a.csid is not null)';
  ExecTheSQL(Ado_Dynamic, sqlstr);
  //模拟资料缺失告警
  sqlstr := ' insert into Alarm_Data_Collect '+
    '(alarmtype, deviceid, codeviceid, contentcode, isalarm, ifpresider, createtime, csid,  '+
    'collecttime, errorcontent, cityid, isnewappend, alarmissending, datacollectid, collectionkind, '+
    'collectioncode, isreaded, remark, alarmcount, alarmlocation)       '+
    'select a.alarmtype alarmtype, t.deviceid, 0 codeviceid, 800000001 contentcode,        '+
     ' 1 isalarm, 0 ifpresider, sysdate createtime, 0 csid,        '+
    '  sysdate collecttime, null errorcontent, t.cityid, 1 isnewappend, 0 alarmissending, 0 datacollectid, 1 collectionkind,   '+
    '  1 collectioncode, 0 isreaded, null remark, 1 alarmcount, null alarmlocation      '+
   ' from   (  select distinct a.cityid, a.deviceid from alarm_data_collect a      '+
   'left join fms_device_info b on a.DEVICEID=b.DEVICEID and a.cityid = b.cityid      '+
   ' where b.csid is null   ) t   left join  alarm_content_info a       '+
  '  on a.cityid =t.cityid and a.ALARMCONTENTCODE=800000001        '+
   ' left join Alarm_Data_Collect b        '+
  '  on b.cityid=t.cityid and b.deviceid=t.deviceid and b.codeviceid=0 and b.contentcode=800000001  '+
   ' where b.deviceid is null  and not exists '+
   '(select 1 from fault_detail_online c where c.cityid=t.cityid and c.deviceid=t.deviceid '+
   'and c.codeviceid=0 and c.alarmcontentcode=800000001 and c.isalarm=1)';
   ExecTheSQL(Ado_Dynamic, sqlstr);  
end;

//添加日志过程
procedure InteAttempCollect.ShowCollectMessage(appendrow,editrow,delrow:integer;Kind:boolean);
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

//填补新插入的alarm_device_info的数据
procedure InteAttempCollect.FillValueto_AlarmCsInfo();
var
  SQLSTR, FieldList:string;
begin
  FieldList:= ' areaid, branch, branchname, csid, bts_name, bts_level, '+
              ' bts_state, bts_label, bts_type, bts_kind, msc, bsc, lac, '+
              ' station_addr, bts_netstate, commonality_type, agent_manu, source_mode, iron_tower_kind,devicetype ';

  SQLSTR:=' update alarm_device_info a set ('+FieldList+')=( select '+FieldList;
  SQLSTR:=SQLSTR+' from fms_device_info b where a.cityid=b.cityid and a.deviceid=b.deviceid )';
  SQLSTR:=SQLSTR+' where a.isnewappend like '+QuotedStr('%newist');

  ExecTheSQL(Ado_Dynamic, sqlstr);    
end;

//重新生成Alarm_Data_Collect表中人工干预部份的主障
procedure InteAttempCollect.ARRANGE_For_ManualSend();
var
  SQLSTR, deviceid, CityID, contentcode :string;
begin
  //--首先批量更新所有的告警均为从告警
  //SQLSTR:=' update alarm_data_collect set ifpresider=0 where (cityid,deviceid) in ( ';
  //SQLSTR:=SQLSTR+' select cityid,deviceid from alarm_data_collect ) and ifpresider=1';
  //ExecTheSQL(Ado_Dynamic, sqlstr);

  //--批量更新<单从障>的告警为主告警
  SQLSTR:=' update alarm_data_collect set ifpresider=1 where (cityid,deviceid) in ( ';
  SQLSTR:=SQLSTR+' select cityid,deviceid from alarm_data_collect ';
  SQLSTR:=SQLSTR+' group by cityid,deviceid having count(cityid)=1 and count(deviceid)=1) and ifpresider=0';
  ExecTheSQL(Ado_Dynamic, sqlstr);

  //--定义<多从障>的告警为游标,按告警级别排序（排在最前为高警级别最高）
  SQLSTR:=' select a.CityID,a.deviceid,a.ContentCode,a.IfPresider';
  SQLSTR:=SQLSTR+' From alarm_data_collect a ';
  SQLSTR:=SQLSTR+' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode ';
  SQLSTR:=SQLSTR+' where (a.CityID,a.deviceid) in ';
  SQLSTR:=SQLSTR+' (select CityID,deviceid from alarm_data_collect group by CityID,deviceid';
  SQLSTR:=SQLSTR+' having count(cityid)>1 and count(deviceid)>1';
  SQLSTR:=SQLSTR+' ) ';
  SQLSTR:=SQLSTR+' order by a.CityID,a.deviceid,b.ALARMLEVEL,a.collecttime ';
  OpenTheDataSet(Ado_Dynamic, sqlstr);

  deviceid:='';  CityID:='-1';
  with Ado_Dynamic do
  begin
    first;
    while not eof do
    begin
      //--每换一个基站，将游标中的第一条设为主障
      contentcode:= fieldbyname('contentcode').AsString;
      if (CityID=fieldbyname('CityID').AsString) and (deviceid=fieldbyname('deviceid').asstring) then
      begin
        if fieldbyname('ifpresider').AsInteger=1 then
        begin
          SQLSTR:=' update alarm_data_collect set ifpresider=0 where CityID='+CityID;
          SQLSTR:=SQLSTR+' and deviceid='+QuotedStr(deviceid)+' and contentcode='+contentcode;
          ExecTheSQL(Ado_Free, SQLSTR);
        end;
      end
      else
      begin
        CityID:= fieldbyname('CityID').AsString;
        deviceid:= fieldbyname('deviceid').AsString;
        if fieldbyname('ifpresider').AsInteger=0 then
        begin
          SQLSTR:=' update alarm_data_collect set ifpresider=1 where CityID='+CityID;
          SQLSTR:=SQLSTR+' and deviceid='+QuotedStr(deviceid)+' and contentcode='+contentcode;
          ExecTheSQL(Ado_Free, SQLSTR);
        end;
      end;
      next;
    end;
  end;            

  //--处理基站资料补全基站
  SQLSTR:=' delete from alarm_data_collect where (cityid,deviceid) in ';
  SQLSTR:=SQLSTR+' (select cityid,deviceid from alarm_device_info ';
  SQLSTR:=SQLSTR+' where flowtache=4 and (csid=0 or csid is null)';
  SQLSTR:=SQLSTR+' and (cityid,deviceid) in (select cityid,deviceid from fms_device_info)';
  SQLSTR:=SQLSTR+' )';
  ExecTheSQL(Ado_Free, SQLSTR);
  SQLSTR:=' delete from alarm_device_info ';
  SQLSTR:=SQLSTR+' where flowtache=4 and (csid=0 or csid is null) ';
  SQLSTR:=SQLSTR+' and (cityid,deviceid) in (select cityid,deviceid from fms_device_info) ';
  ExecTheSQL(Ado_Free, SQLSTR);
end;

function InteAttempCollect.GetTimeLimitFromCsLevel(CsLevel:integer):integer;
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

//根据<分局编码>得到<代维公司编码>（OppositeKind＝2）或<网控中心编码>（OppositeKind＝1）
function InteAttempCollect.Get_Opposite_RuleDept(CityID, BranchID : integer):integer;
var sqlstr:string;
begin
  sqlstr:=' select districtid from alarm_districtandbranch_list where CityID='+inttostr(CityID)+' and branchid='+inttostr(BranchID);
  if OpenTheDataSet(Ado_Dynamic,sqlstr)>0 then
    Result:=Ado_Dynamic.fieldbyname('districtid').AsInteger
  else
    Result:=0;
end;

procedure InteAttempCollect.IstRecordToSubMaster(CityID:integer; deviceid:string);
var SltSQL,UpdSQL:string;
    FlowTrackID,limitedhour,districtid:integer;
begin
  SltSQL:=' select a.collecttime,a.LevelFlagCode,a.batchid,a.occurid,sysdate as removetime,a.substationID,';
  SltSQL:=SltSQL+' a.cstypeid,a.DataCollectID,a.repisstat,b.causecode,b.resolventcode,b.alarmcontentcode from alarm_device_info a';
  SltSQL:=SltSQL+' left join fault_master_online b on a.cityid=b.cityid and a.occurid=b.occurid';
  SltSQL:=SltSQL+' where a.cityid='+inttostr(CityID)+' and a.deviceid='+QuotedStr(deviceid);
  OpenTheDataSet(Ado_Free,SltSQL);
  FlowTrackID:=ProduceFlowNumID('FlowTrackID',1);
  if Ado_Free.fieldbyname('LevelFlagCode').IsNull then
    limitedhour:=GetTimeLimitFromCsLevel(-1) //省局的考核时限
  else
    limitedhour:=GetTimeLimitFromCsLevel(Ado_Free.fieldbyname('LevelFlagCode').AsInteger);
  if Ado_Free.fieldbyname('substationID').IsNull then
    districtid:=0
  else
    districtid:=Get_Opposite_RuleDept(CityID,Ado_Free.fieldbyname('substationID').AsInteger);

  UpdSQL:=' insert into alarm_submaster_online';
  UpdSQL:=UpdSQL+' (CityID, flowtrackid, batchid, occurid, collecttime, removetime, startsend, endsend, limitedhour, diachronic, districtid, cstypeid, cslevelid, DataCollectID, deviceid, RepIsStat, causecode, resolventcode,alarmcontentcode )';
  UpdSQL:=UpdSQL+' values(:CityID, :flowtrackid, :batchid, :occurid, :collecttime, :removetime, :startsend, :endsend, :limitedhour, ';
  UpdSQL:=UpdSQL+' alarm_getperiodtime_province(:collecttime1, :startsend1, :endsend1, :removetime1), :districtid, :cstypeid, :cslevelid, :DataCollectID, :deviceid, :RepIsStat, :causecode, :resolventcode,:alarmcontentcode )';
  with Ado_Dynamic do
  begin
    close;
    sql.Clear;
    sql.Add(UpdSQL);
    Parameters.ParamByName('CityID').Value:= CityID;
    Parameters.ParamByName('flowtrackid').Value:=FlowTrackID;
    Parameters.ParamByName('batchid').Value:= Ado_Free.fieldbyname('batchid').AsInteger;
    Parameters.ParamByName('OCCURID').Value:= Ado_Free.fieldbyname('OCCURID').AsInteger;
    Parameters.ParamByName('collecttime').Value:= Ado_Free.fieldbyname('collecttime').AsDateTime;
    Parameters.ParamByName('removetime').Value:= Ado_Free.fieldbyname('removetime').AsDateTime;
    Parameters.ParamByName('startsend').Value:= Dm_Collect_Local.PublicParam.SA_StartTime;//省局的考核起始时间
    Parameters.ParamByName('endsend').Value:= Dm_Collect_Local.PublicParam.SA_EndTime; //省局的考核结束时间
    Parameters.ParamByName('limitedhour').Value:=limitedhour;
    Parameters.ParamByName('collecttime1').Value:= Ado_Free.fieldbyname('collecttime').AsDateTime;
    Parameters.ParamByName('startsend1').Value:= Dm_Collect_Local.PublicParam.SA_StartTime;
    Parameters.ParamByName('endsend1').Value:= Dm_Collect_Local.PublicParam.SA_EndTime;
    Parameters.ParamByName('removetime1').Value:= Ado_Free.fieldbyname('removetime').AsDateTime;
    Parameters.ParamByName('districtid').Value:=districtid;
    Parameters.ParamByName('cstypeid').Value:= Ado_Free.fieldbyname('cstypeid').AsInteger;
    Parameters.ParamByName('cslevelid').Value:= Ado_Free.fieldbyname('LevelFlagCode').asinteger;
    Parameters.ParamByName('DataCollectID').Value:= Ado_Free.fieldbyname('DataCollectID').asinteger;
    Parameters.ParamByName('deviceid').Value:= deviceid;
    if Ado_Free.fieldbyname('RepIsStat').IsNull then
    begin
      Parameters.ParamByName('RepIsStat').DataType:= ftVariant;
      Parameters.ParamByName('RepIsStat').Value:= Null;
    end else
      Parameters.ParamByName('RepIsStat').Value:= Ado_Free.fieldbyname('RepIsStat').AsDateTime;
    Parameters.ParamByName('causecode').Value:= Ado_Free.fieldbyname('causecode').asinteger;
    Parameters.ParamByName('resolventcode').Value:= Ado_Free.fieldbyname('resolventcode').asinteger;
    Parameters.ParamByName('alarmcontentcode').Value:= Ado_Free.fieldbyname('alarmcontentcode').asinteger;
    execsql;
    close;
  end;
end;

//判断是否在省局考核时间范围内（是则记录本次客观基站故障记录），在范围内返回true，否则为false
function InteAttempCollect.JudgeIsPutUpExamine(CityID :integer; deviceid :String):boolean;
var
  SQLSTR : string;
  CollectTime:TDateTime;
begin
  {SQLSTR:='select flowtache, collecttime from alarm_device_info where cityid='+inttostr(cityid)+'and deviceid='+QuotedStr(deviceid);
  OpenTheDataSet(Ado_Dynamic, SQLSTR);
  if Ado_Dynamic.FieldByName('flowtache').AsInteger=4 then
    CollectTime:=Ado_Dynamic.FieldByName('CollectTime').AsDateTime
  else begin
    SQLSTR:='select newcollecttime from fault_master_online where cityid='+inttostr(cityid)+'and deviceid='+QuotedStr(deviceid);
    OpenTheDataSet(Ado_Dynamic, SQLSTR);
    CollectTime:=Ado_Dynamic.FieldByName('NewCollectTime').AsDateTime
  end;
  CollectTime:=strtotime(timetostr(CollectTime));
  //如果在派障时间段范围内并且该天允许派障，则派障,否则只派发Clear告警
  if (CollectTime>=strtotime(Dm_Collect_Local.PublicParam.SA_StartTime)) and
     (CollectTime<=strtotime(Dm_Collect_Local.PublicParam.SA_EndTime)) then
    Result:=true
  else
    Result:=false; }

    Result:=false;//----------------------暂时不考虑
end;

//根据cityid,deviceid添加、修改表alarm_device_info的数据
//0 : 该基站的告警本次采集有增删改操作
//1 : 第一次采到该基站的告警，应对alarm_device_info进行插入记录操作
//2 : 只有删除告警操作，应该检查alarm_online_detail_view，如果为空，则需操作alarm_submaster_online表
procedure InteAttempCollect.Modify_alarm_device_info(CityID,HandleID:integer; deviceid,FormatStr:string);
var
  SQLSTR : string;
  DataCollectID : Integer;
begin
  case HandleID of
  0 : begin
        SQLSTR:=' update alarm_device_info set isnewappend='+QuotedStr(FormatStr)+' where cityid='+inttostr(cityid)+'and deviceid='+QuotedStr(deviceid);
      end;
  1 : begin
       { DataCollectID:=ProduceFlowNumID('DataCollectID',1);
        SQLSTR:=' insert into alarm_device_info ( cityid, COMPANYID, deviceid, flowtache, batchid, collecttime, occurid, IsNewAppend, UpdateTime, manuallimit, DataCollectID ) ';
        SQLSTR:=SQLSTR+' values( '+inttostr(cityid)+', -1,'+QuotedStr(deviceid)+', 4 , 0 , sysdate, 0,'+QuotedStr(FormatStr);
        SQLSTR:=SQLSTR+' , sysdate,'+Dm_Collect_Local.AlarmParam[GetCitySN(CityID)].CityParam.ManualLimit+','+inttostr(DataCollectID)+' )';
        }    //--------------------------------待完善
         DataCollectID:=ProduceFlowNumID('DataCollectID',1);
        SQLSTR:=' insert into alarm_device_info ( cityid, COMPANYID, deviceid, flowtache, batchid, collecttime, occurid, IsNewAppend, UpdateTime, DataCollectID ) ';
        SQLSTR:=SQLSTR+' values( '+inttostr(cityid)+', -1,'+QuotedStr(deviceid)+', 4 , 0 , sysdate, 0,'+QuotedStr(FormatStr);
        SQLSTR:=SQLSTR+' , sysdate,'+inttostr(DataCollectID)+' )';
      end;
  2 : begin
        //在alarm_online_detail_view表中查找city,deviceid对应值的基站有没有告警数据
        //如果没有数据，那么删除alarm_device_info表中的基站数据
        //否则的话更新alarm_device_info表中isnewappend=2
        SQLSTR:=' select cityid,deviceid from alarm_online_detail_view';
        SQLSTR:=SQLSTR+' where cityid='+inttostr(cityid)+'and deviceid='+QuotedStr(deviceid);
        if OpenTheDataSet(Ado_Dynamic, SQLSTR)=0 then
        begin
          if JudgeIsPutUpExamine(CityID,deviceid) then //判断是否在省局考核时间范围内，是则记录本次客观基站故障记录
            IstRecordToSubMaster(CityID,deviceid);

          SQLSTR:=' delete from alarm_device_info where cityid='+inttostr(cityid)+'and deviceid='+QuotedStr(deviceid);
        end
        else
          SQLSTR:=' update alarm_device_info set isnewappend='+QuotedStr(FormatStr)+' where cityid='+inttostr(cityid)+'and deviceid='+QuotedStr(deviceid);
      end;
  end;
  ExecTheSQL(Ado_Dynamic, SQLSTR);
end;

function InteAttempCollect.GetSysDateTime():TDateTime;
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

//如果已有相应的<线对故障>，则不再追加<业务信道故障 >
//返回为true表示追加指定<业务信道故障>，为false表示不追加
function InteAttempCollect.ProcessLinecircuit(ContentCode:integer):boolean;
begin
  Result:=true;
  if Ado_CollectGather.fieldbyname('contentcode').asinteger in [50,57,58,59] then  //处理四个“业务信道故障”
  with Ado_Data_Collect do   //不用判断是否已排障
  begin
    //if Locate('contentcode,ISALARM',VarArrayOf([45,1]),[loCaseInsensitive])
    //or Locate('contentcode,ISALARM',VarArrayOf([44,1]),[loCaseInsensitive]) then
    //如为<基站停电>或<标准基站停电>，则不派任何<业务信道故障>
    if Locate('contentcode',45,[loCaseInsensitive]) or Locate('contentcode',44,[loCaseInsensitive]) then
    begin
      Result:=false;
      exit;
    end;
    case ContentCode of
     50 : if Locate('contentcode',20,[loCaseInsensitive]) then Result:=false;
     57 : if Locate('contentcode',21,[loCaseInsensitive]) then Result:=false;
     58 : if Locate('contentcode',22,[loCaseInsensitive]) then Result:=false;
     59 : if Locate('contentcode',23,[loCaseInsensitive]) then Result:=false;
    end;
  end;
end;

{*************************综合分析线程****************************
********************************************************************************
***  过程功能：1、从alarm_collection_cyc_list得到增量采集标识行              ***
***            2、过滤重复告警等，从Alarm_Data_Gather表中得到有效告警信息    ***
***            3、将上述告警按规则插入Alarm_Data_Collect表                   ***
***            4、删除此次扫描过的所有记录——删除Alarm_Data_Gather          ***
***               中AlarmAutoID小于表alarm_collection_cyc_list中字段         ***
***               （collect_row）当前值的所有记录                            ***
***            5、更新alarm_collection_cyc_list表的collect_row字段           ***
***            6、调用《自动派障总体调度过程》AlarmSendOverall               ***
***                                                       J.F. Qiu           ***
***                                                       2009-07-17         ***
*******************************************************************************}

procedure InteAttempCollect.Data_Collect();
var
  appendrow,editrow,delrow:integer;
  Currappendrow, Curreditrow, Currdelrow:integer;
  IsFillValue:boolean;  
  starttime,endtime,CurrTime:TDateTime;
  cityid:integer;
  deviceid,tempstr:string;
  strSQL: string;
begin
  IsFillValue:=false;
  ButtonIsEnable:=false;
  Synchronize(SetButton_IsEnable);
  starttime:=now;
  appendrow:=0; editrow:=0; delrow:=0;
  try
    try  
      Ado_DBConn.Connected:=false;
      Ado_DBConn.Connected:=true;
    except
      MessageContent:=datetimetostr(now)+'   来自《数据采集线程》的消息——本地告警数据库连接失败，请通知系统管理员处理！';
      Synchronize(AppendRunLog);
      exit;
    end;

    if IsTrans then Ado_DBConn.BeginTrans;
    try
      CurrTime:=GetSysDateTime();

      PrepareBeforeCollect();  //采集前的处理工作

      with Ado_collect_main do
      begin 
        close;
        open;
        first;
        while not eof do
        begin
          cityid:=fieldbyname('cityid').AsInteger;
          deviceid:=fieldbyname('deviceid').asstring;
          with Ado_Data_Collect do  //得到数据集，以便将经过过滤的告警信息放进“告警信息待派库”——表alarm_data_collect
          begin
            close;
            Parameters.parambyname('cityid').Value:=cityid;
            Parameters.parambyname('deviceid').Value:=deviceid;
            open;
          end;

          with Ado_CollectGather do
          begin
            close;
            Parameters.parambyname('cityid').Value:=cityid;
            Parameters.parambyname('deviceid').Value:=deviceid;
            open;
            first;
            Currappendrow:=0;
            Curreditrow:=0;
            Currdelrow:=0;
            while not eof do
            begin
               if Ado_Data_Collect.Locate('codeviceid; contentcode',VarArrayOf([fieldbyname('codeviceid').asinteger, fieldbyname('contentcode').asinteger]),[loCaseInsensitive]) then
               begin
                  if Ado_Data_Collect.fieldbyname('ISALARM').AsInteger <> fieldbyname('ISALARM').AsInteger then
                  begin
                     if fieldbyname('ISALARM').AsInteger=1 then
                     begin
                        Ado_Data_Collect.edit; //如果是从好->坏，或者是告警状态不能确定的记录则保留
                        Ado_Data_Collect.fieldbyname('ISALARM').AsInteger:= fieldbyname('ISALARM').AsInteger;
                        Ado_Data_Collect.fieldbyname('errorcontent').AsString:= fieldbyname('errorcontent').AsString;
                        Ado_Data_Collect.fieldbyname('isnewappend').AsInteger:= 0;
                        Ado_Data_Collect.fieldbyname('collecttime').AsDateTime:= CurrTime;
                        Ado_Data_Collect.post;
                        inc(Curreditrow);
                        //放入更新列表
                     end else  //如果是坏->好，说明派障以前就排障了，无需再派出去，直接删除
                     begin
                        Ado_Data_Collect.Delete;       //-----------------------可能会影响到派障线程操作
                        inc(Currdelrow);
                     end;
                  end else
                  begin
                    Ado_Data_Collect.edit;
                    Ado_Data_Collect.fieldbyname('ALARMCOUNT').AsInteger:= Ado_Data_Collect.fieldbyname('ALARMCOUNT').AsInteger+1;
                    Ado_Data_Collect.post;

                     {MessageContent:='采集过虑不完整，请检查:城市编号,节点地址,告警内容编号,告警状态——'
                                      +inttostr(cityid)+','+deviceid+','
                                      +fieldbyname('contentcode').AsString+','+fieldbyname('ISALARM').AsString;
                     Synchronize(AppendRunLog);}
                     //----------------------------------用于告警门限 排障门限
                  end;
               end else  //待发库中不存在 往待发库中添加
               begin   
                  Ado_Data_Collect.append;
                  Ado_Data_Collect.fieldbyname('alarmtype').AsInteger:=fieldbyname('alarmtype').AsInteger;
                  Ado_Data_Collect.fieldbyname('cityid').AsInteger:=fieldbyname('cityid').AsInteger;
                  Ado_Data_Collect.fieldbyname('csid').AsInteger:=fieldbyname('csid').AsInteger;
                  Ado_Data_Collect.fieldbyname('deviceid').AsString:= fieldbyname('deviceid').AsString;
                  Ado_Data_Collect.fieldbyname('codeviceid').AsInteger:= fieldbyname('codeviceid').AsInteger;
                  Ado_Data_Collect.fieldbyname('contentcode').AsInteger:=fieldbyname('ContentCode').AsInteger;
                  Ado_Data_Collect.fieldbyname('ISALARM').AsInteger:= fieldbyname('ISALARM').AsInteger;
                  Ado_Data_Collect.fieldbyname('createtime').AsDateTime:= fieldbyname('createtime').AsDateTime;
                  Ado_Data_Collect.fieldbyname('collecttime').AsDateTime:= CurrTime;
                  Ado_Data_Collect.fieldbyname('isnewappend').AsInteger:= 1;
                  Ado_Data_Collect.fieldbyname('IfPresider').AsInteger:=0;
                  Ado_Data_Collect.fieldbyname('collectionkind').AsInteger:=fieldbyname('collectionkind').AsInteger;
                  Ado_Data_Collect.fieldbyname('collectioncode').AsInteger:= fieldbyname('collectioncode').AsInteger;
                  Ado_Data_Collect.fieldbyname('ALARMCOUNT').AsInteger:=1;
                  Ado_Data_Collect.fieldbyname('alarmlocation').Value:=fieldbyname('alarmlocation').Value;
                  Ado_Data_Collect.fieldbyname('errorcontent').AsString:= fieldbyname('errorcontent').AsString;
                  Ado_Data_Collect.post;
                  inc(Currappendrow);    
               end;
               next;
            end;  //while not eof do
          end;  //with Ado_CollectGather do

          //如果在alarm_device_info中没有找到基站数据
          appendrow:=appendrow+Currappendrow;
          editrow:=editrow+Curreditrow;
          delrow:=delrow+Currdelrow;
          tempstr:=format('%0.2d',[Currappendrow])+'-'+format('%0.2d',[Curreditrow])+'-'+format('%0.2d',[Currdelrow]);
          if (Currappendrow>0) and (not Judge_IsCollect(cityid,deviceid)) then
          begin
             IsFillValue:=true;
             Modify_alarm_device_info(cityid,1,deviceid,tempstr+'-'+'newist');  //插入基站信息到alarm_device_info
          end else
          if (Currdelrow>0) and (Currappendrow+Curreditrow=0) then
            Modify_alarm_device_info(cityid,2,deviceid,tempstr)
          else
            Modify_alarm_device_info(cityid,0,deviceid,tempstr);

          UpdateAlarmCoDeviceinfo(fieldbyname('cityid').AsInteger, fieldbyname('deviceid').AsInteger);  
                 
          next;
        end;//  while not eof do
      end; //with Ado_collect_main do
      if IsFillValue then FillValueto_AlarmCsInfo();
      //更新派单规则
      Modify_RuleKind();
      //更新话务规则
      Modify_CallEfect;

      ClearAfterCollect();  //数据采集后的清理工作
      ARRANGE_For_ManualSend();  //进行顺序重排

      if IsTrans then Ado_DBConn.CommitTrans;
    except
      on E: exception do
      begin    
        MessageContent:=datetimetostr(now)+'   《告警采集》过程中，事务处理失败，请通知系统管理员处理！'+e.Message;
        Synchronize(AppendRunLog);
        if IsTrans then Ado_DBConn.RollbackTrans;
        exit;
      end;
    end;
    endtime:=now;
    if (appendrow+editrow+delrow<>0) then
    begin
      ShowCollectMessage(appendrow,editrow,delrow,true);
    end;
    MessageContent:=datetimetostr(now)+'   已成功执行数据采集!  本次执行共花费时间：'+GetBetweenTime(starttime, endtime);
    Synchronize(AppendRunLog);
  finally
    ButtonIsEnable:=true;
    Synchronize(SetButton_IsEnable);
    Ado_DBConn.Connected:=false;
  end;

end;

function InteAttempCollect.GetRuleParamID(cityid,Kind :integer):TStringList;
var
  sqlstr : String;
  list :TStringList;
begin
   result := nil;
   sqlstr := 'select * from Alarm_Rule_Param where IFINEFFECT=1  and rulecode <> 1 and  rulekind =:rulekind and cityid =:cityid order by rulelevel desc ';
   with Ado_Dynamic do
   begin
      Close;
      sql.Clear;
      sql.Add(sqlstr);
      Parameters.ParamByName('rulekind').Value :=  kind;
      Parameters.ParamByName('cityid').Value :=cityid;
      Open;
      if RecordCount = 0 then Exit;
      list := TStringList.Create;
      first;
      while not Eof do
      begin
          list.Add(FieldByName('rulecode').AsString);
          Next;
      end;
   end;
   result := list;
end;

//注意deviceid和cityid
function InteAttempCollect.GetRuleSQL(deviceid,cityid,RuleID: String;var bResult:Boolean): String;
var
  sqlstr : String;
  tostr : String;
begin
    result := '';

    sqlstr := ' select a.sqlstay from Alarm_Rule_Master a'+
              ' where a.rulecode ='+ RuleId +' and a.cityid='+cityid+' order by termcode';
    try
      with Ado_Dynamic do
      begin
         Close;
         sql.Clear;
         sql.Add(sqlstr);
         Open;
         if RecordCount <= 0 then Exit;
         first;
         while not Eof do
         begin
            tostr := ''''+deviceid+'''';
            result := result + AnsiReplaceText(FieldByName('sqlstay').AsString,'@deviceid',tostr)+' and';
            result := AnsiReplaceText(result,'@cityid',cityid);
            Next;
         end;
         result := leftstr(result, length(result) - 3);
      end;
      bResult := true;
    except
      bResult := false;
    end;
end;
//返回值：-1: 获取派单规则SQL失败；
//        -3: 执行派单规则失败；
function InteAttempCollect.JudgeRuleKind(deviceid,cityid: string):integer;
var
  i,flag : Integer;
  sqlstr : string;
  issuccess :Boolean;
  RuleList :TStrings;
begin
    result := 1;
    RuleList := nil;
    //根据cityid查找是否有派单规则
    for i:=low(RuleArray) to high(RuleArray) do
    begin
      if RuleArray[i].cityid = StrToInt(cityid) then
        RuleList := RuleArray[i].RuleList;
    end;
    if RuleList = nil then Exit;
    //派单规则
    for i := 0 to RuleList.Count -1 do
    begin
      sqlstr := GetRuleSQL(deviceid,cityid,RuleList.Strings[i],issuccess);
      if not issuccess then
      begin
        result := -1;
        Exit;
      end;
      flag := UpdateAlarmRuleID(deviceid,cityid,RuleList.Strings[i],sqlstr);
      if flag = 1 then
          break
      else if flag = -1 then
      begin
        result := -3;
        Exit;
      end;
    end;
end;
//根据规则更新主表字段alarmstyle 或者 CALLEFFECT
//如果某基站告警满足其中一条规则就将 (alarmstyle或CALLEFFECT) = 规则编号
// 返回值： 0：不满足规则且无异常；1： 满足规则且更新成功 ；-1：有异常
function InteAttempCollect.UpdateAlarmRuleID(deviceid,cityid,RuleID,
  sSQL: String): Integer;
var
  sqlstr :String;
  INTERVAL,flag : Integer;
  idate : TDateTime;
begin
    result := 0;
    if Trim(sSQL)='' then Exit;
    try
    with Ado_Dynamic do
    begin
       sqlstr := 'update alarm_device_info set endtime = null, alarmstyle = null where deviceid=:deviceid and cityid =:cityid' ;
       sql.Clear;
       sql.Add(sqlstr);
       Parameters.ParamByName('deviceid').Value :=deviceid;
       Parameters.ParamByName('cityid').Value :=cityid;
       ExecSQL;
       sqlstr := 'select issend,ruleinterval from Alarm_Rule_Param where RULEKIND = 1 and RULECODE =:RULECODE and cityid =:cityid';
       Close;
       sql.Clear;
       sql.Add(sqlstr);
       Parameters.ParamByName('RULECODE').Value :=RuleID;
       Parameters.ParamByName('cityid').Value :=cityid;
       Open;
       if FieldByName('RULEINTERVAL').IsNull then
          INTERVAL := 0
       else
          INTERVAL := FieldByName('RULEINTERVAL').AsInteger;
       idate := GetSysDateTime + (INTERVAL/24);
       sqlstr:=' update alarm_device_info set endtime = :pendtime, alarmstyle =:palarmstyle '+
               ' where deviceid = :pdeviceid and cityid=:cityid and ('+sSQL+' )';

       Close;
       sql.Clear;
       sql.Add(sqlstr);
       Parameters.ParamByName('palarmstyle').Value := RuleID;
       Parameters.ParamByName('pendtime').Value := idate;
       Parameters.ParamByName('pdeviceid').Value := deviceid;
       Parameters.ParamByName('cityid').Value :=cityid;
       flag := ExecSQL;
       if flag > 0 then
          result := 1;
    end;
    except
      result := -1;
    end;
end;
// 返回值： 0：不满足规则且无异常；1： 满足规则且更新成功 ；-1：有异常
function InteAttempCollect.UpdateCallEffect(deviceid,cityid, RuleID,
  sSQL: String): integer;
var
  sqlstr :String;
  flag : Integer;
begin
    result := 0;
    if Trim(sSQL) = '' then Exit;
    sqlstr:=' update alarm_device_info set CALLEFFECT =:CALLEFFECT '+
            ' where deviceid = :deviceid and cityid =:cityid and ( '+sSQL+' )';
    try
        with Ado_Dynamic do
        begin
           Close;
           sql.Clear;
           sql.Add(sqlstr);
           Parameters.ParamByName('deviceid').Value := deviceid;
           Parameters.ParamByName('cityid').Value :=cityid;
           Parameters.ParamByName('CALLEFFECT').Value :=RuleID;
           flag := ExecSQL;
        end;
        if flag > 0 then result := 1;
    except
        result := -1;
    end;
end;
//判断派单规则
procedure InteAttempCollect.Modify_RuleKind;
var
  sqlstr :String;
  iResult :integer;
begin
  sqlstr := ' select deviceid,cityid from alarm_device_info where flowtache = 4 and isnewappend is not null';
  with Ado_Rule_Kind do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    Open;
    if RecordCount = 0 then Exit;
    first;
    while not Eof do
    begin
      iResult :=JudgeRuleKind(FieldByName('deviceid').AsString,FieldByName('cityid').AsString);
      case iResult  of
       -1: MessageContent :=datetimetostr(now)+ '  获取派单规则SQL失败!';
       -3: MessageContent :=datetimetostr(now)+ '  执行派单规则失败!';
      end;
      if iResult < 0 then
      begin
          Synchronize(AppendRunLog);
          Raise Exception.Create(MessageContent);
      end;
      Next;
    end;
  end;
end;

procedure InteAttempCollect.Modify_CallEfect;
var
  sqlstr :String;
  iResult :integer;
begin
  sqlstr := ' select deviceid,cityid from alarm_device_info where isnewappend is not null';
  with Ado_Rule_Kind do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    Open;
    if RecordCount = 0 then Exit;
    first;
    while not Eof do
    begin
      iResult :=JudgeCallEffect(FieldByName('deviceid').AsString,FieldByName('cityid').AsString);
      case iResult  of
       -2: MessageContent :=datetimetostr(now)+ '  获取话务质量影响规则SQL失败!';
       -4: MessageContent :=datetimetostr(now)+ '  执行话务质量影响规则失败!';
      end;
      if iResult < 0 then
      begin
          Raise Exception.Create(MessageContent);
      end;
      Next;
    end;
  end;
end;
//返回值： -2：获取话务规则SQL失败
//         -4： 执行话务规则失败
function InteAttempCollect.JudgeCallEffect(deviceid,
  cityid: string): integer;
var
  i,flag : integer;
  sqlstr :String;
  issuccess : boolean;
  CallList :TStringList;
begin
    result := 1;
    CallList := nil;
    //根据cityid查找是否有派单规则
    for i:=low(RuleArray) to high(RuleArray) do
    begin
      if RuleArray[i].cityid = StrToInt(cityid) then
        CallList := RuleArray[i].CallList;
    end;
    if (CallList = nil) or (CallList.Count = 0) then Exit;

    //话务规则
    for i := 0 to CallList.Count -1 do
    begin
        sqlstr := GetRuleSQL(deviceid,cityid,CallList.Strings[i],issuccess);
        if not issuccess then
        begin
          result := -2;
          Exit;
        end;
        flag := UpdateCallEffect(deviceid,cityid,CallList.Strings[i],sqlstr);
        if flag = 1 then
            break
        else if flag = -1 then
        begin
          result := -4;
          Exit;
        end;
    end;
end;

procedure InteAttempCollect.InitRuleArray;
var
  sqlstr:String;
  i : integer;
begin
   sqlstr := 'select ID from pop_area where layer=1 ';
   with Ado_Free do
   begin
     Close;
     sql.Clear;
     SQL.Add(sqlstr);
     Open;
     if RecordCount = 0 then Exit;
     SetLength(RuleArray,RecordCount);
     first; i:=0;
     while Not Eof do
     begin
       RuleArray[i].cityid := FieldByName('ID').AsInteger;
       RuleArray[i].RuleList:=GetRuleParamID(RuleArray[i].cityid,1);
       RuleArray[i].CallList:=GetRuleParamID(RuleArray[i].cityid,2);
       Next;
       Inc(i);
     end;
   end;
end;

//将新增告警内容(已过滤)加到告警测试表中
function InteAttempCollect.AppendTestAlarm(deviceid: String;
  contentcode, cityid: integer):Boolean;
var
  TestCode :String;
  Ask :TAskTest;
begin
  result := false;
  TestCode :=GetAlarmTestCode(contentcode, cityid);
  if  GetAlarmTest_(cityid,contentcode,deviceid,Ask) then
  with Ado_AlarmTest,Ask do
  begin
    if Not Active then Open;
    if not Locate('deviceid;contentcode;cityid',VarArrayOf([deviceid,IntToStr(contentcode),IntToStr(cityid)]),[loCaseInsensitive]) then
    begin
      Append;
      fieldbyname('deviceid').AsString:= deviceid;
      fieldbyname('contentcode').AsInteger :=contentcode;
      fieldbyname('cityid').AsInteger:= cityid;
      FieldByName('TestCode').Value :=TestCode;
      FieldByName('Batchid').AsInteger :=-1;
      FieldByName('UNCP').AsString :=UNCP;
      FieldByName('CSCIP').AsString :=CSCIP;
      FieldByName('CS_INDEX').AsInteger :=CS_INDEX;
      FieldByName('FACTORY').AsInteger :=FACTORY;   // 手动测试
      FieldByName('ASKTIME').AsDateTime :=now;
      FieldByName('TESTTYPE').AsInteger :=1;        //自动测试
      Post;
    end;
    result := true;
  end;
end;

function InteAttempCollect.GetAlarmTestCode(contentcode,
  cityid: integer): String;
var
  sqlstr:String;
begin
  result :='';
  sqlstr := 'select referid from alarm_content_reference where ISCheck=1 and cityid = :cityid and alarmcontentcode=:alarmcontentcode';
  with Ado_Free do
  begin
    Close;
    sql.Clear;
    SQL.Add(sqlstr);
    Parameters.ParamByName('cityid').Value :=cityid;
    Parameters.ParamByName('alarmcontentcode').Value :=contentcode;
    Open;
    if RecordCount > 0 then
      result :=FieldByName('referid').AsString;
    Close;
  end;
end;

function InteAttempCollect.GetAlarmTest_(cityid, contentcode: integer;
  deviceid: String; var Ask: TAskTest): Boolean;
var
  sqlstr:String;
begin
  result :=false;
  try
    Ask.deviceid := deviceid;
    Ask.Cityid := cityid;
    Ask.ContentCode :=contentcode;
    Ask.UNCP:= Copy(deviceid,1,Pos('@',deviceid)-1);
    Ask.CSCIP :=Copy(deviceid,Pos('@',deviceid)+1,Pos('_',deviceid)-Pos('@',deviceid)-1 );
    sqlstr := 'select referid from alarm_content_reference where ISCheck=1 and cityid = :cityid and alarmcontentcode=:alarmcontentcode';
    with Ado_Free,Ask do
    begin
      Close;
      //告警对应测试编码  四方和上海 对应  20－1 21－2
      sql.Clear;
      SQL.Add(sqlstr);
      Parameters.ParamByName('cityid').Value :=cityid;
      Parameters.ParamByName('alarmcontentcode').Value :=contentcode;
      Open;
      if RecordCount > 0 then
      begin
        TESTCODE :=FieldByName('referid').AsString;
        Close;
        //基站序号
        SQL.Clear;
        SQL.Add('select Cs_Index from fms_device_info where deviceid=:deviceid and cityid=:cityid');
        Parameters.ParamByName('cityid').Value :=cityid;
        Parameters.ParamByName('deviceid').Value :=deviceid;
        Open;
        if RecordCount > 0 then
          CS_INDEX :=FieldByName('Cs_Index').AsInteger;
        Close;
        //厂商编码
        sql.Clear;
        SQL.Add('select setvalue from alarm_sys_function_set where kind =22 and code =1 and cityid=:cityid');
        Parameters.ParamByName('cityid').Value :=cityid;
        Open;
        if RecordCount > 0 then
          Ask.Factory := FieldByName('setvalue').AsInteger;
        Close;
        result := true;
      end;
    end;
  except
    result := false;
  end;
end;   



procedure InteAttempCollect.UpdateAlarmCoDeviceinfo(CityID, DeviceID: integer);
var
  I: integer;
begin
  //更新告警小区在线信息
  with Sp_update_alarm_codevice_info do
  begin
    close;
    Parameters.parambyname('Vcityid').value := CityID;
    Parameters.parambyname('Vdeviceid').Value := DeviceID;
    execproc;
    i:=Parameters.parambyname('iError').Value; //返回值为整型，
    close;
  end;
  if I=-1 then
    raise exception.Create('调用 update_alarm_codevice_info存储过程出错！  deviceid:'+IntToStr(DeviceID));
  //------------最新更新
end;

end.
