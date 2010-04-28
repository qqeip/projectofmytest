unit Ut_StatTarget_Thread;

interface

uses
  Windows,Classes,ADODB,SysUtils,IdTCPServer,Messages,Forms,DB,Variants,
  Ut_common,Ut_AlarmTestDefine,IdTCPConnection, IdTCPClient, IdBaseComponent, IdComponent;

type
  TStatTargetThread = class(TThread)
  private
    { Private declarations }
    AdoC : TADOConnection;
    AdoQ: TADOQuery;
    Ado_temp : TADOQuery;
    Sp_StayTo_ReSend: TADOStoredProc;
    Sp_Alarm_FlowNumber: TADOStoredProc;
    DeptStat : Array of Array of integer;
    //待统计辖区列表
    FDistrictList :TStringList;
    CR:   Trtlcriticalsection;
    MessageContent : String;
    ButtonIsEnable:Boolean;
    // 上海测试
    IdClient :TIdTCPClient;
    IsInfo :Boolean;  //是否有使用上海理想测试的，而且理想测试IP及端口是否正确.
    procedure ItemCompute_IsEnable();
    procedure AlarmResend_IsEnable();
    procedure Suspend_IsEnable();
  protected

    procedure AppendRunLog();  //添加消息到运行日志
    
    procedure Execute; override;
    //再派
    procedure ReSendAlarm;
    //删除实时告警屏蔽表中的到期记录
    procedure DeleteShieldRecord;
    //统计指标值
    procedure StatWork;
    //function UpdateTestResult(deviceid:String;cityid,contentcode:integer):Boolean;

    procedure StatItemValue(DeptID,cityid : Integer);
    function PerformSQL(strSQL : String) : Boolean;
    function StatValue(strSQL : String) : Integer;
    function IfHaveRecord(DeptID,cityid : Integer) : Boolean;

    //获取辖区ID字符串
    function GetDeptList(districtid,cityid:integer) : String;
    function GetDeptList_(districtid:integer) : String;
    Function StayToReSend(CityID,Batchid,SFlowTache,TFlowTache:integer;Operator:string):integer;//疑难故障再派障
    //告警测试
    procedure AskForAlarmTest;
    procedure AskForAlarmTest_SF;
    //上海理想
    procedure InitSHLXInfo;
    procedure AskForAlarmTest_LX;
    function ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer;
    Function ReConnDBLink():Boolean;
    function SaveAlarmTestResult_(R:TTestResult):Boolean;
  public
    IsAlarmTest :Boolean;
    function PullStatDistrict : integer;
    procedure PushStatDistrict(DistrictID : integer);
    constructor Create(DBConn:string);
    destructor Destroy;override;
  end;

implementation
uses Ut_Data_Local,Ut_RunLog,Ut_Flowtache_Monitor;
{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TStatTargetThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TStatTargetThread }

constructor TStatTargetThread.Create(DBConn: String);
begin
  inherited Create(true);
  AdoC := TADOConnection.Create(nil);
  AdoC.LoginPrompt:=false;
  AdoC.ConnectionString:=DBConn;
  AdoC.Connected:=true;

  AdoQ := TADOQuery.Create(nil);
  AdoQ.CommandTimeout := 200;
  AdoQ.Connection := AdoC;

  Ado_temp := TADOQuery.Create(nil);
  Ado_temp.CommandTimeout := 200;
  Ado_temp.Connection := AdoC;

  Sp_StayTo_ReSend:= TADOStoredProc.Create(nil);
  with Sp_StayTo_ReSend do
  begin
    Close;
    Connection := AdoC;
    ProcedureName:='ALARM_STAYTO_RESEND';
    Parameters.Clear;
    Parameters.CreateParameter('VCityid',ftInteger,pdInput,0,null);
    Parameters.CreateParameter('VBATCHID',ftInteger,pdInputOutput	,0,null);
    Parameters.CreateParameter('SFLOWTACHE',ftInteger,pdInput,0,null);
    Parameters.CreateParameter('TFLOWTACHE',ftInteger,pdInput,0,null);
    Parameters.CreateParameter('VOPERATOR',ftString,pdInput,0,null);
    Prepared;
  end;
  Sp_Alarm_FlowNumber:= TADOStoredProc.Create(nil);
  with Sp_Alarm_FlowNumber do
  begin
     Close;
     Connection := AdoC;
     ProcedureName:='ALARM_GET_FLOWNUMBER';
     Parameters.Clear;
     Parameters.CreateParameter('I_FLOWNAME',ftString,pdInput,100,null);
     Parameters.CreateParameter('I_SERIESNUM',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('O_FLOWVALUE',ftInteger,pdOutput,0,null);
     Prepared;
  end;
  AdoC.Connected:=false;
  InitializeCriticalSection(CR);
  FDistrictList :=TStringList.Create;
  IdClient :=TIdTCPClient.Create(nil);
  IdClient.ReadTimeout :=2*60000;
  //初始化IP及端口
  InitSHLXInfo;
end;

destructor TStatTargetThread.Destroy;
begin
  IdClient.Disconnect;
  IdClient.Free;
  FDistrictList.Clear;
  FDistrictList.Free;
  DeleteCriticalSection(CR);
  Sp_Alarm_FlowNumber.Close;
  Sp_Alarm_FlowNumber.Free;
  Sp_StayTo_ReSend.Close;
  Sp_StayTo_ReSend.Free;
  Ado_temp.Close;
  Ado_temp.Free;
  AdoQ.Close;
  AdoQ.Free;

  inherited;
end;

//设置“按钮”是否可用
procedure TStatTargetThread.ItemCompute_IsEnable();
begin
   Fm_FlowMonitor.Bt_ItemCompute.Enabled:=ButtonIsEnable;
end;

procedure TStatTargetThread.AlarmResend_IsEnable();
begin
   Fm_FlowMonitor.Bt_AlarmResend.Enabled:=ButtonIsEnable;
end;

procedure TStatTargetThread.Suspend_IsEnable();
begin
   Fm_FlowMonitor.Bt_Suspend.Enabled:=ButtonIsEnable;
end;

procedure TStatTargetThread.Execute;
begin
  { Place thread code here }
   {while (not terminated) do
   begin
     try
       if ReConnDBLink then //如果数据库连接正常，则执行，否则释放DB连接并挂起线程
       begin
         StatWork;
         ReSendAlarm;
         DeleteShieldRecord;
         AskForAlarmTest; //成都四方
         if IsInfo then
          AskForAlarmTest_LX; //上海理想
       end;
     finally
       AdoC.Connected:=false;
       Suspend;
     end;
   end;}

end;

Function TStatTargetThread.ReConnDBLink():Boolean;
begin
  Result:=true;
  try
    if AdoC.Connected then
      AdoC.Connected:=false;
    AdoC.Connected:=true;
  except
    MessageContent:=datetimetostr(now)+'  < 业务运转支撑线程 >事务执行中，本地连接失败,请联系系统管理员! ';
    Synchronize(AppendRunLog);
    Result:=false;
  end;
end;

//再派障
procedure TStatTargetThread.ReSendAlarm;
var
   sqlstr:string;
begin
  ButtonIsEnable:=false;
  Synchronize(AlarmResend_IsEnable);
   try
     //一、再派障
     sqlstr:='select a.batchid,a.flowtache,b.stayoperator,a.cityid from fault_master_online a ';
     sqlstr:=sqlstr+' inner join alarm_stay_online b on a.batchid=b.batchid and a.occurid=b.occurid '; //新增条件 and a.occurid=b.occurid
     sqlstr:=sqlstr+' where a.flowtache in (2,3) and b.stayenddate<=sysdate ';
     with AdoQ do
     begin
        close;
        sql.Clear;
        sql.Add(sqlstr);
        open;
        first;
        while not eof do
        begin
           StayToReSend(fieldbyname('cityid').AsInteger,fieldbyname('batchid').AsInteger,fieldbyname('flowtache').AsInteger,5,fieldbyname('stayoperator').AsString); //疑难故障再派障
           next;
        end;
        close;
     end;
   except
    on E:Exception  do
      begin
        MessageContent:=datetimetostr(now)+'  < 到期暂不派(疑难)故障再派 >失败,请联系系统管理员! － '+E.Message;
        Synchronize(AppendRunLog);
      end;
   end;
   ButtonIsEnable:=true;
   Synchronize(AlarmResend_IsEnable);
end;

procedure TStatTargetThread.DeleteShieldRecord;
begin
   ButtonIsEnable:=false;
   Synchronize(Suspend_IsEnable);
   try
      //删除实时告警屏蔽表中到期 记录
      with AdoQ do
      begin
         close;
         sql.Clear;
         sql.Add('delete from Alarm_realtime_shield where (shielddate +shieldday)<=sysdate');
         ExecSQL;
      end;
   except
    on E:Exception  do
      begin
        MessageContent:=datetimetostr(now)+'  < 删除实时告警屏蔽表中到期记录> 失败,请联系系统管理员! － '+E.Message;
        Synchronize(AppendRunLog);
      end;
   end;
   ButtonIsEnable:=true;
   Synchronize(Suspend_IsEnable);
end;
// 调用接口获取待统计辖区 
procedure TStatTargetThread.StatWork;
var
  i : Integer;
  DeptID,cityid : integer;
  strSQL : String;
  Adata :PThreadData;
begin
  cityid := 0;
  DeptID :=PullStatDistrict;
  //-2 表示待统计辖区表中无辖区
  if DeptID= -2 then
  begin
    New(AData);
    Adata.command := 100;
    AData.districtid := 0;
    Adata.Msg :='索取统计辖区';
    PostMessage(Application.MainForm.Handle, WM_THREADSTATE_MSG, 0, Longint(Adata));
    Exit;
  end;
  ButtonIsEnable:=false;
  Synchronize(ItemCompute_IsEnable);
  try
    //统计指标并发消息
    try
      StatItemValue(DeptID,cityid);
      strSQL := 'select t.districtid,t.type from Districtinfo t where t.parent = '+IntToStr(DeptID);
      with AdoQ do
      begin
          close;
          SQL.Clear;
          SQL.Add(strSQL);
          try
            Open;
            if RecordCount > 0 then
                SetLength(DeptStat,RecordCount,2);
            first;
            i := 0;
            while not eof do
            begin
                DeptStat[i,0] := FieldByName('districtid').AsInteger;
                DeptStat[i,1] := FieldByName('type').AsInteger;
                Inc(i);
                Next;
            end;
            Close;
          except
              Exit;
          end;
      end;
      for i := Low(DeptStat) to high(DeptStat) do
          StatItemValue(DeptStat[i,0],DeptStat[i,1]);
      setLength(DeptStat,0,0);
    except
      on E:Exception  do
      begin
        MessageContent:=datetimetostr(now)+'  统计实时指标失败,请联系系统管理员! － '+E.Message;
        Synchronize(AppendRunLog);
      end;
    end;
  finally
    ButtonIsEnable:=true;
    Synchronize(ItemCompute_IsEnable);
  end;
end;

procedure TStatTargetThread.StatItemValue(DeptID, cityid: Integer);
var
    strSQL,updateSQL : String;
    SendNum,ClearNum,OTNum,OTModifyNum,StayNum,StaticNum : Integer;
    SubmitNum,StayOTNum,StaticOTNum : Integer;
    WaitSend_M,WaitSend_A : Integer;
    WaitWreck_M,WaitWreck_H,WaitWreck_A : Integer;
    //嵌套辖区ID
    citystr,districtstr,districtlist : String;
    AData :PThreadData;
begin
    districtstr := '';
    citystr := '';
    {   //不加 CityID 判断太复杂
    if cityid <> 0 then
    begin
      citystr := ' and a.cityid ='+IntToStr(cityid);
      districtlist := GetDeptList(DeptID,cityid);
      districtstr := ' and a.eservicecocode in('+districtlist+')' ;
    end;
    }
    //不加 CityID 判断太复杂
    districtlist := GetDeptList_(DeptID);
    districtstr := ' and a.eservicecocode in('+districtlist+')' ;
    //超时未修复故障
    strSQL := ' Select Count(*) from alarm_listmaster_view a'+
              ' where a.flowtache in(5,6,7)'+
              ' and to_char(a.LimitTime,''YYYY-MM-DD HH24:MI:SS'') < '''+FormatDateTime('YYYY-MM-DD hh:mm:ss',now)+''' '+
              citystr +districtstr ;
    OTNum :=StatValue(strSQL);
    //超时修复故障
    strSQL := ' Select Count(*) from alarm_historymaster_view a'+
              ' where a.flowtache = 9 '+
              ' and to_char(a.cleartime,''YYYY-MM-DD HH24:MI:SS'') > '''+FormatDateTime('YYYY-MM-DD hh:mm:ss',now)+''' '+
              ' and to_char(a.LimitTime,''YYYY-MM-DD HH24:MI:SS'') < '''+FormatDateTime('YYYY-MM-DD hh:mm:ss',now)+''' '+
               citystr +districtstr ;
    OTModifyNum :=StatValue(strSQL);

    //派单数
    strSQL := ' select Max(rownum) from('+
              ' select a.batchid from fault_master_online a '+
              ' where to_char(a.SendTime,''YYYY-MM-DD'') <= '''+DateToStr(Date)+''' '+
              ' and a.flowtache in(5,6,8)'+
               citystr +districtstr+
              ' union'+
              ' select a.batchid from fault_master_history a'+
              ' where to_char(a.SendTime,''YYYY-MM-DD'') = '''+DateToStr(Date)+''' '+
              ' and a.flowtache = 9'+
               citystr +districtstr+
              ' )';
     SendNum :=StatValue(strSQL);
     //提交
     strSQL := ' select count(*) from('+
              ' select a.batchid from fault_master_online a'+
              ' where a.flowtache = 7'+
              ' and to_char(a.submittime,''YYYY-MM-DD'') = '''+DateToStr(Date)+''' '+
               citystr +districtstr +
              ' union'+
              ' select a.batchid from fault_master_history a'+
              ' where a.flowtache = 9'+
              ' and to_char(a.submittime,''YYYY-MM-DD'') = '''+DateToStr(Date)+''' '+
               citystr +districtstr+
              ')';
    SubmitNum := StatValue(strSQL);

    //消障数
    strSQL := ' select count(*) from fault_master_history a'+
              ' where to_char(a.ClearTime,''YYYY-MM-DD'') = '''+DateToStr(Date)+''' '+
              ' and a.flowtache = 9 '+ citystr +districtstr ;
    ClearNum :=StatValue(strSQL);
    //暂不派数
    strSQL := ' select count(*) from fault_master_online a'+
              ' where a.flowtache = 3 '+ citystr +districtstr ;
    StayNum :=StatValue(strSQL);
    //暂不派到期数
    strSQL := ' select count(*) from fault_master_online a,Alarm_Stay_online b'+
              ' where a.batchid = b.batchid and a.cityid = b.cityid and (b.stayenddate-b.stayremind) <= sysdate'+
              ' and a.flowtache = 3 '+ citystr +districtstr ;
    StayOTNum :=StatValue(strSQL);
    //疑难数
    strSQL := ' select count(*) from fault_master_online a'+
              ' where a.flowtache = 2 '+ citystr +districtstr ;
    StaticNum :=StatValue(strSQL);
    //疑难到期数
    if cityid = 0 then
      strSQL := ' select count(*) from fault_master_online a,Alarm_Stay_online b'+
                ' where a.batchid = b.batchid and a.cityid = b.cityid and (b.stayenddate-b.stayremind) <= sysdate'+
                ' and a.flowtache = 2 '
    else
      strSQL := ' select count(*) from fault_master_online a,Alarm_Stay_online b'+
                ' where a.batchid = b.batchid and a.cityid = b.cityid and (b.stayenddate-b.stayremind) <= sysdate'+
                ' and a.flowtache = 2 and a.cityid ='+IntToStr(cityid)+' and eservicecocode in('+districtlist+')';
    StaticOTNum :=StatValue(strSQL);

    //待派单情况——待人工
    if cityid = 0 then
      strsql := ' select count(deviceid) from alarm_listmanual_view '
    else
      strsql := ' select count(deviceid) from alarm_listmanual_view a'+
                ' where exists (select 1 from Districtprivinfo b where b.branchid=a.substationid and b.cityid ='+IntToStr(cityid)+
                ' and b.districtid in('+districtlist+')) and a.cityid ='+IntToStr(cityid);
    WaitSend_M :=StatValue(strSQL);

    //待派单情况——待自动
    if cityid = 0 then
      strsql :=' select count(deviceid) from alarm_autosend_view '
    else
      strsql :=' select count(a.deviceid) from alarm_autosend_view a'+
               ' where exists (select 1 from Districtprivinfo b where b.branchid=a.substationid and b.cityid ='+IntToStr(cityid)+
               ' and b.districtid in('+districtlist+')) and a.cityid ='+IntToStr(cityid);
    WaitSend_A :=StatValue(strSQL);

    //来源为自动的待消障
    strSQL:=' select count(a.batchid) from Alarm_DayReport_view a '+
            ' inner join alarm_content_rule b on a.alarmcontentcode=b.alarmcontentcode and a.cityid= b.cityid'+
            ' where a.flowtache=7 and b.sendtype=1 '+ citystr +districtstr ;
    WaitWreck_A :=StatValue(strSQL);
    //人工干预的待消障
    strSQL:=' select count(a.batchid) from Alarm_DayReport_view a '+
            ' inner join alarm_content_rule b on a.alarmcontentcode=b.alarmcontentcode and a.cityid= b.cityid'+
            ' where a.flowtache=7 and b.sendtype=2 '+ citystr +districtstr ;
    WaitWreck_M :=StatValue(strSQL);

    //全人工的待消障
    strSQL:=' select count(a.batchid) from Alarm_DayReport_view a '+
            ' inner join alarm_content_rule b on a.alarmcontentcode=b.alarmcontentcode and a.cityid= b.cityid'+
            ' where a.flowtache=7 and b.sendtype=3 '+ citystr +districtstr ;
    WaitWreck_H :=StatValue(strSQL);
    if IfHaveRecord(DeptID,cityid) then
        updateSQL := ' update ALARM_STATITEM set sendnum = '+IntToStr(sendnum)+
                     ' ,clearnum = '+IntToStr(clearnum)+ ',otnum= '+IntToStr(otnum)+
                     ' ,OTModifyNum= '+IntToStr(OTModifyNum)+
                     ' ,staynum= '+IntToStr(staynum)+ ',staticnum= '+IntToStr(staticnum)+
                     ' ,StayOTNum= '+IntToStr(StayOTNum)+ ',StaticOTNum= '+IntToStr(StaticOTNum)+
                     ' ,waitsend_m= '+IntToStr(waitsend_m)+ ',waitsend_a= '+IntToStr(waitsend_a)+
                     ' ,waitwreck_m= '+IntToStr(waitwreck_m)+ ',waitwreck_h= '+IntToStr(waitwreck_h)+
                     ' ,waitwreck_a= '+IntToStr(WaitWreck_A)+ ',submitnum= '+IntToStr(submitnum)+
                     ' where Deptid ='+IntToStr(Deptid)+' and cityid ='+IntToStr(cityid)
    else
        updateSQL := ' insert into ALARM_STATITEM(deptid,sendnum,clearnum, otnum,OTModifyNum,'+
                     ' staynum,StayOTNum,staticnum,StaticOTNum,waitsend_m,waitsend_a,waitwreck_m,'+
                     ' waitwreck_h,waitwreck_a,submitnum,cityid)Values('+
                     IntToStr(Deptid)+','+ IntToStr(sendnum)+','+
                     IntToStr(clearnum)+','+IntToStr(otnum)+','+
                     IntToStr(OTModifyNum)+','+
                     IntToStr(staynum)+','+IntToStr(StayOTNum)+','+
                     IntToStr(staticnum)+','+IntToStr(StaticOTNum)+','+
                     IntToStr(waitsend_m)+','+IntToStr(waitsend_a)+','+
                     IntToStr(waitwreck_m)+','+IntToStr(waitwreck_h)+','+
                     IntToStr(waitwreck_a)+','+IntToStr(submitnum)+ ','+
                     IntToStr(cityid)+')';
    if PerformSQL(updateSQL) then
    begin
      New(Adata);
      Adata.command :=91;
      Adata.districtid := Deptid;
      Adata.Msg :='实时统计';
      PostMessage(Application.MainForm.Handle, WM_THREAD_MSG, 0, Longint(Adata));
    end;
end;

function TStatTargetThread.PerformSQL(strSQL: String): Boolean;
begin
    result := false;
    with ADOQ do
    begin
      Close;
      SQL.Clear;
      SQL.Add(strSQL);
      try
        ExecSQL;
        result := true;
      except
      end;
    end;
end;

function TStatTargetThread.StatValue(strSQL: String): Integer;
begin
  result := 0;
  with AdoQ do
  begin
    Close;
    SQL.Clear;
    SQL.Add(strSQL);
    Open;
    result := Fields[0].AsInteger;
  end;
end;

function TStatTargetThread.IfHaveRecord(DeptID,cityid: Integer): Boolean;
begin
  result := false;
  with AdoQ do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from ALARM_STATITEM where Deptid =:deptid and cityid = :cityid');
    Parameters.ParamByName('Deptid').Value :=Deptid;
    Parameters.ParamByName('cityid').Value :=cityid;
    Open;
    if RecordCount > 0 then
        result := true;
  end;
end;

function TStatTargetThread.GetDeptList(districtid,cityid:integer): String;
var
  sqlStr: String;
begin
    result := IntToStr(districtid);
    //取子节点
    sqlStr := ' select districtid,cityid from (select districtid,parent,cityid from districtinfo)'+
              ' start with parent = :districtid connect by prior districtid = parent and cityid =cityid and cityid =:cityid';
    with AdoQ do
    begin
        Close;
        SQL.Clear;
        SQL.Add(sqlStr);
        Parameters.ParamByName('districtid').Value := districtid;
        Parameters.ParamByName('cityid').Value := cityid;
        Open;
        if RecordCount > 0 then
        begin
            While not Eof do
            begin
                result := result +','+FieldByName('districtid').AsString;
                Next;
            end;
        end;
    end;
end;

procedure TStatTargetThread.AppendRunLog;
begin
    Fm_RunLog.Re_RunLog.Lines.Add(MessageContent);
end;

function TStatTargetThread.StayToReSend(CityID, Batchid, SFlowTache,
  TFlowTache: integer; Operator: string): integer;
begin
   with Sp_StayTo_ReSend do
   begin
      close;
      Parameters.parambyname('VCityID').Value:=CityID;
      Parameters.parambyname('VBatchid').Value:=Batchid;
      Parameters.parambyname('SFlowTache').Value:=SFlowTache;
      Parameters.parambyname('TFlowTache').Value:=TFlowTache;
      Parameters.parambyname('VOperator').Value:=Operator;
      execproc;
      Result:=Parameters.parambyname('VBatchid').Value;
      close;
   end;
end;
//先发送手动测试告警,再发送自动测试告警
procedure TStatTargetThread.AskForAlarmTest;
var
  sqlStr: String;
  RT :RTestPack;
begin
  ButtonIsEnable:=false;
  Synchronize(ItemCompute_IsEnable);
  try
    //取未曾发送测试告警的分局的告警 (手动)
    sqlstr :='( select a.*,b.substationid from alarm_test_asklist a'+
             ' left join fms_device_info b  on a.cityid=b.cityid and a.deviceid=b.deviceid'+
             ' where (b.cityid,b.substationid) not in('+
             ' select distinct b.cityid,b.substationid from alarm_test_asklist a'+
             ' left join fms_device_info b  on a.cityid=b.cityid and a.deviceid=b.deviceid'+
             ' where  a.testtime is not null) and a.factory =1 and a.testtype=2 )';
    //按分局分组后取其中一条
    sqlstr :='select * from '+sqlstr+' where rowid in (select min(rowid) from '+sqlstr+' group by substationid)';
    with Ado_temp do
    begin
        Close;
        SQL.Clear;
        SQL.Add(sqlStr);
        Open;
        if RecordCount > 0 then
        begin
          first;
          while not Eof do
          begin
            //获取测试 IP及端口
            if GetAlarmTestInfo(RT,FieldByName('Cityid').AsInteger) then
            begin
              RT.deviceid := FieldByName('deviceid').AsString;
              RT.ContentCode := FieldByName('ContentCode').AsInteger;
              RT.Cityid := FieldByName('Cityid').AsInteger;
              RT.TestCode :=FieldByName('TestCode').AsString;
              RT.TESTSN:=ProduceFlowNumID('TESTSN',1);
              if SendTestAlarm(RT) then
              begin
                sqlstr := 'update alarm_test_asklist set TestSN='+IntToStr(RT.TESTSN)+',testtime=sysdate where deviceid='''+FieldByName('deviceid').AsString+
                          ''' and contentcode='+FieldByName('ContentCode').AsString+' and cityid='+FieldByName('cityid').AsString;
                if not PerformSQL(sqlstr) then //更新发送测试时间
                begin
                  MessageContent:=datetimetostr(now)+'发送 城市编号='+IntToStr(RT.Cityid)+' 节点地址='+RT.deviceid+' 告警内容编码='+IntToStr(RT.ContentCode)+' 的测试告警时出错！';
                  Synchronize(AppendRunLog);
                end;
              end;
            end;
            sleep(1000);
            Next;
          end;
        end;
        Close;
    end;
    //*****************************自动测试部分********************************
    sqlstr :='( select a.*,b.substationid from alarm_test_asklist a'+
             ' left join fms_device_info b  on a.cityid=b.cityid and a.deviceid=b.deviceid'+
             ' where (b.cityid,b.substationid) not in('+
             ' select distinct b.cityid,b.substationid from alarm_test_asklist a'+
             ' left join fms_device_info b  on a.cityid=b.cityid and a.deviceid=b.deviceid'+
             ' where  a.testtime is not null) and a.factory =1 )';//and a.testtype=1 )';
    //按分局分组后取其中一条
    sqlstr :='select * from '+sqlstr+' where rowid in (select min(rowid) from '+sqlstr+' group by substationid)';

    with Ado_temp do
    begin
        Close;
        SQL.Clear;
        SQL.Add(sqlStr);
        Open;
        if RecordCount > 0 then
        begin
          first;
          while not Eof do
          begin
            //获取测试 IP及端口
            if GetAlarmTestInfo(RT,FieldByName('Cityid').AsInteger) then
            begin
              RT.deviceid := FieldByName('deviceid').AsString;
              RT.ContentCode := FieldByName('ContentCode').AsInteger;
              RT.Cityid := FieldByName('Cityid').AsInteger;
              RT.TestCode :=FieldByName('TestCode').AsString;
              RT.TESTSN:=ProduceFlowNumID('TESTSN',1);
              if SendTestAlarm(RT) then
              begin
                sqlstr := 'update alarm_test_asklist set TestSN='+IntToStr(RT.TESTSN)+',testtime=sysdate where deviceid='''+FieldByName('deviceid').AsString+
                          ''' and contentcode='+FieldByName('ContentCode').AsString+' and cityid='+FieldByName('cityid').AsString;
                if not PerformSQL(sqlstr) then //更新发送测试时间
                begin
                  MessageContent:=datetimetostr(now)+'发送 城市编号='+IntToStr(RT.Cityid)+' 节点地址='+RT.deviceid+' 告警内容编码='+IntToStr(RT.ContentCode)+' 的测试告警时出错！';
                  Synchronize(AppendRunLog);
                end;
              end;
            end;
            sleep(1000);
            Next;
          end;
        end;
        Close;
    end;
    //************************************************************************
    //更新长时间(5 min)未接收到测试结果的testtime = null ,以便下次可以重新发送测试告警
    sqlstr :='update alarm_test_asklist set testsn=null,testtime = null where factory =1 and (testtime + 5/60/24) < sysdate ';
    if not PerformSQL(sqlstr) then
    begin
      MessageContent:=datetimetostr(now)+'处理长时间未收到告警测试结果的记录时出错！';
      Synchronize(AppendRunLog);
    end;
  except
    on E:Exception  do
      begin
        MessageContent:=datetimetostr(now)+'  告警测试过程中出现错误,请联系系统管理员! － '+E.Message;
        Synchronize(AppendRunLog);
      end;
  end;
  ButtonIsEnable:=true;
  Synchronize(ItemCompute_IsEnable);
end;

function TStatTargetThread.ProduceFlowNumID(I_FLOWNAME: string;
  I_SERIESNUM: integer): Integer;
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
// -1 表示 全部辖区统计 ，-2 表示无辖区
function TStatTargetThread.PullStatDistrict: integer;
begin
  result := -2;
  if (FDistrictList = nil) or (FDistrictList.Count=0) then Exit;
  EnterCriticalSection(CR);
  try
    try
      result := StrToInt(FDistrictList.Strings[0]);
      FDistrictList.Delete(0);
    except
    end;
  finally
    LeaveCriticalSection(CR);
  end;
end;

procedure TStatTargetThread.PushStatDistrict(DistrictID: integer);
begin
  if FDistrictList = nil  then Exit;
  EnterCriticalSection(CR);
  try
    FDistrictList.Add(IntToStr(DistrictID));
  finally
    LeaveCriticalSection(CR);
  end;
end;

function TStatTargetThread.GetDeptList_(districtid: integer): String;
var
  sqlStr: String;
begin
  result := IntToStr(districtid);
  //取子节点
  sqlStr := ' select districtid,cityid from (select districtid,parent,cityid from districtinfo)'+
            ' start with parent = :districtid connect by prior districtid = parent';
  with AdoQ do
  begin
      Close;
      SQL.Clear;
      SQL.Add(sqlStr);
      Parameters.ParamByName('districtid').Value := districtid;
      Open;
      if RecordCount > 0 then
      begin
          While not Eof do
          begin
              result := result +','+FieldByName('districtid').AsString;
              Next;
          end;
      end;
  end;
end;
//取数据、发测试、收测试
procedure TStatTargetThread.AskForAlarmTest_LX;
var
  sqlStr,AscStr,sTemp,readstr: String;
  Ask :TLXTEST;
  i,Value : integer;
  cscip,uncp :String;
  ch :char;
  TestResult :TTestResult;
begin
  
  //连接服务器
  if not IdClient.Connected then
  try
    idClient.Connect(100);
  except
    MessageContent:=datetimetostr(now)+'连接上海理想告警测试服务器失败! IP:'+IdClient.Host+' 端口:'+IntToStr(IdClient.Port);
    Synchronize(AppendRunLog);
    Exit;
  end;
  //连接服务器成功
  if IdClient.Connected then
  begin
    ButtonIsEnable:=false;
    Synchronize(ItemCompute_IsEnable);
    try
      //取未曾发送测试告警,手动测试优先,最早申请的最早测试
      sqlstr :='select * from alarm_test_asklist where factory=2 order by TESTTYPE desc ,asktime asc ';
      with AdoQ  do
      begin
        Close;
        SQL.Clear;
        SQL.Add(sqlStr);
        Open;
        if RecordCount > 0 then
        begin
          first;
          while not Eof do
          begin
            //构造测试包
            FillDefaultValue(Ask);
            with Ask do
            begin
              //理想槽号即 基站端口号 cs_index 根据规则转
              Value :=GetLXSlot(FieldByName('CS_INDEX').AsInteger);
              AscStr :='';
              sTemp := IntToStr(Value);
              //槽号转Ascii－转16进制
              for i:=1 to Length(sTemp) do
              begin
                ch := sTemp[i];
                csc_slot[i-1]:= ord(ch);
              end;
              //理想端口号 即 线序  第一对线  1  根据规则转
              Value :=GetLXPort(FieldByName('CS_INDEX').AsInteger,FieldByName('TESTCODE').AsInteger);
              AscStr :='';
              sTemp := IntToStr(Value);
              //端口号转Ascii－转16进制
              for i :=1 to Length(sTemp) do
              begin
                ch := sTemp[i];
                csC_Port[i-1]:= ord(ch) ;
              end;
              //CSIP
              cscip :=FieldByName('CSCIP').AsString;
              for i :=0 to Length(cscip)-1 do
                csc_ip[i] := cscip[i+1];
              //UNCP
              uncp :=FieldByName('uncp').AsString;
              for i :=0 to Length(uncp)-1 do
              begin
                csc_uncp[i] := uncp[i+1];
              end;
            end;
            //测试结果基本资料
            TestResult.cityid := FieldByName('cityid').AsInteger;
            TestResult.deviceid := FieldByName('deviceid').AsString;
            TestResult.ALARMCONTENTCODE := FieldByName('CONTENTCODE').AsInteger;
            //发
            if not IdClient.Connected then
              idClient.Connect(100);
            Ask.Ver := $EE;
            IdClient.WriteBuffer(Ask,sizeof(TLXTEST));
            //收
            readstr := IdClient.ReadLn();
            // 测试失败
            if Pos('测试失败',readstr) > 0 then
            begin
              //测试结论
              TestResult.TestResult := readstr;
              while Pos('结束',readstr) = 0 do
              begin
                 readstr := IdClient.ReadLn();
                 TestResult.TestResult := TestResult.TestResult+readstr;
              end;
              readstr := IdClient.ReadLn();  //收到"结束"后，对方还发了个空串
            end
            //else if sTemp='线路测试结果：线路正常' then
            else if Pos('线路测试结果',sTemp)>0 then
            begin
              //测试结论
              TestResult.TestResult := readstr;
              readstr := IdClient.ReadLn();
              TestResult.TestResult :=TestResult.TestResult+ readstr;
              while Pos('结束',readstr) = 0 do
              begin
                readstr := IdClient.ReadLn();
                if Pos('交流AB',readstr) > 0 then
                  TestResult.Uac_ab := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('交流AG',readstr) > 0 then
                  TestResult.Uac_ag := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('交流BG',readstr) > 0 then  // 交流BG   = 0.63 V
                  TestResult.Uac_bg := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('直流AB',readstr) > 0 then//直流AB   = 0.014 V
                  TestResult.Udc_ab := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('直流AG',readstr) > 0 then //直流AG   = 0 V
                  TestResult.Udc_ag := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('直流BG',readstr) > 0 then //直流BG   = 0.014 V
                  TestResult.Udc_bg := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('交流阻抗',readstr) > 0 then//交流阻抗  = 144 Ω
                  TestResult.IR_ab := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('直流阻抗',readstr) > 0 then//直流阻抗  = 2.88 KΩ
                  TestResult.Udc_bg := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('电阻AB',readstr) > 0 then  //电阻AB   = 18.14 KΩ
                  TestResult.SR_AB := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('电阻AG',readstr) > 0 then  //电阻AG   = >20 MΩ
                  TestResult.SR_AG := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('电阻BG',readstr) > 0 then //电阻BG   = >20 MΩ
                  TestResult.SR_BG := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('电容AB',readstr) > 0 then //电容AB   = >300 nF
                  TestResult.C_AB := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('电容AG',readstr) > 0 then//电容AG   = 0.1 nF
                  TestResult.C_AG := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('电容BG',readstr) > 0 then //电容BG   = 0.1 nF
                  TestResult.C_BG := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('误码数',readstr) > 0 then //误码数   = 0
                  TestResult.BERTE := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
                if Pos('误码率',readstr) > 0 then   //误码率   = 0.0000%
                  TestResult.WML := Copy(readstr,Pos('=',readstr)+1,Length(readstr)- Pos('=',readstr)-1);
              end;
            end
            else  //接口未提到的东西
            begin
              TestResult.TestResult := readstr;
              while Pos('结束',readstr) <> 0 do
              begin
                readstr := IdClient.ReadLn();
              end;
            end;
            if IdClient.Connected then
              IdClient.Disconnect;
              
            MessageContent:=datetimetostr(now)+'理想测试结果：'+TestResult.TestResult;
            Synchronize(AppendRunLog);

            //保存测试结果
            SaveAlarmTestResult_(TestResult);
            //更新测试结论到采集表或在线表中
            with Ado_temp do
            begin
              Close;
              SQL.Clear;
              SQL.Add('update alarm_data_collect set ERRORCONTENT =:ERRORCONTENT where cityid=:cityid and deviceid=:deviceid and contentcode=:contentcode');
              Parameters.ParamByName('cityid').Value := TestResult.cityid;
              Parameters.ParamByName('deviceid').Value := TestResult.deviceid;
              Parameters.ParamByName('ERRORCONTENT').Value := TestResult.TestResult;
              Parameters.ParamByName('contentcode').Value := TestResult.ALARMCONTENTCODE;
              if ExecSQL = 0 then
              begin
                Close;
                SQL.Clear;
                SQL.Add('update fault_detail_online set ERRORCONTENT =:ERRORCONTENT where cityid=:cityid and deviceid=:deviceid and alarmcontentcode=:alarmcontentcode');
                Parameters.ParamByName('cityid').Value := TestResult.cityid;
                Parameters.ParamByName('deviceid').Value := TestResult.deviceid;
                Parameters.ParamByName('ERRORCONTENT').Value := TestResult.TestResult;
                Parameters.ParamByName('alarmcontentcode').Value := TestResult.ALARMCONTENTCODE;
                ExecSQL;
              end;
              Close;
            end;
            //更新用户的测试请求列表已经测试完成，可以查看
            with Ado_temp do
            begin
              Close;
              SQL.Clear;
              SQL.Add('update alarm_usertest_asklist set istest =1 where cityid=:cityid and deviceid=:deviceid');
              Parameters.ParamByName('cityid').Value := TestResult.cityid;
              Parameters.ParamByName('deviceid').Value := TestResult.deviceid;
              ExecSQL;
              Close;
            end;
            Edit;
            FieldByName('receivetime').Value := now;
            Post;
            //下一条
            Next;
            sleep(500);
          end;
        end;
        Close;
        with Ado_temp do
        begin
          Close;
          SQL.Clear;
          SQL.Add('delete from alarm_test_asklist where factory=2 and receivetime is not null');
          ExecSQL;
          Close;
        end;
      end;
    except
      on E:Exception  do
        begin
          MessageContent:=datetimetostr(now)+' 上海理想告警测试过程中出现错误,请联系系统管理员! － '+E.Message;
          Synchronize(AppendRunLog);
        end;
    end;
    ButtonIsEnable:=true;
    Synchronize(ItemCompute_IsEnable);
  end;
end;

procedure TStatTargetThread.InitSHLXInfo;
begin
  IsInfo := false;
  with Ado_temp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from alarm_sys_function_set where kind =22 and setvalue=''2'' and content=''1''');
    Open;
    if RecordCount > 0 then
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from alarm_dic_code_info where dictype=25 and diccode =2');
      Open;
      if RecordCount > 0 then
      begin
        IdClient.Host := FieldByName('setvalue').AsString;
        IdClient.Port := FieldByName('parentid').AsInteger;
        IsInfo := true;
      end;
      Close;
    end;
  end;
end;

procedure TStatTargetThread.AskForAlarmTest_SF;
var
  sqlStr: String;
  RT :RTestPack;
begin
  ButtonIsEnable:=false;
  Synchronize(ItemCompute_IsEnable);
  try
    //取未曾发送测试告警的分局的告警
    sqlstr :='( select a.*,b.substationid from alarm_test_asklist a'+
             ' left join fms_device_info b  on a.cityid=b.cityid and a.deviceid=b.deviceid'+
             ' where (b.cityid,b.substationid) not in('+
             ' select distinct b.cityid,b.substationid from alarm_test_asklist a'+
             ' left join fms_device_info b  on a.cityid=b.cityid and a.deviceid=b.deviceid'+
             ' where  a.testtime is not null) and a.factory =1 )';
    //按分局分组后取其中一条
    sqlstr :='select * from '+sqlstr+' where rowid in (select min(rowid) from '+sqlstr+' group by substationid)';
    with Ado_temp do
    begin
        Close;
        SQL.Clear;
        SQL.Add(sqlStr);
        Open;
        if RecordCount > 0 then
        begin
          first;
          while not Eof do
          begin
            //获取测试 IP及端口
            if GetAlarmTestInfo(RT,FieldByName('Cityid').AsInteger) then
            begin
              RT.deviceid := FieldByName('deviceid').AsString;
              RT.ContentCode := FieldByName('ContentCode').AsInteger;
              RT.Cityid := FieldByName('Cityid').AsInteger;
              RT.TestCode :=FieldByName('TestCode').AsString;
              RT.TESTSN:=ProduceFlowNumID('TESTSN',1);
              if SendTestAlarm(RT) then
              begin
                sqlstr := 'update alarm_test_asklist set TestSN='+IntToStr(RT.TESTSN)+',testtime=sysdate where deviceid='''+FieldByName('deviceid').AsString+
                          ''' and contentcode='+FieldByName('ContentCode').AsString+' and cityid='+FieldByName('cityid').AsString;
                if not PerformSQL(sqlstr) then //更新发送测试时间
                begin
                  MessageContent:=datetimetostr(now)+'发送 城市编号='+IntToStr(RT.Cityid)+' 节点地址='+RT.deviceid+' 告警内容编码='+IntToStr(RT.ContentCode)+' 的测试告警时出错！';
                  Synchronize(AppendRunLog);
                end;
              end;
            end;
            sleep(1000);
            Next;
          end;
        end;
        Close;
    end;
    
    //更新长时间(5 min)未接收到测试结果的testtime = null ,以便下次可以重新发送测试告警
    sqlstr :='update alarm_test_asklist set testsn=null,testtime = null where factory =1 and (testtime + 5/60/24) < sysdate ';
    if not PerformSQL(sqlstr) then
    begin
      MessageContent:=datetimetostr(now)+'处理长时间未收到告警测试结果的记录时出错！';
      Synchronize(AppendRunLog);
    end;
  except
    on E:Exception  do
      begin
        MessageContent:=datetimetostr(now)+'  告警测试过程中出现错误,请联系系统管理员! － '+E.Message;
        Synchronize(AppendRunLog);
      end;
  end;
  ButtonIsEnable:=true;
  Synchronize(ItemCompute_IsEnable);
end;

function TStatTargetThread.SaveAlarmTestResult_(R: TTestResult): Boolean;
var
  sqlstr :String;
begin
  result := true;
  try
    sqlstr :=' insert into alarm_test_feedback (cityid, updatetime, alarmcontentcode, deviceid, uac_ab, uac_ag, uac_bg, udc_ab, udc_ag, udc_bg, ir_ab, ir_ag, ir_bg, sr_ab, sr_ag, sr_bg, c_ab, c_ag, c_bg, uact, berts, berte, testresult,WML)'+
             ' values (:cityid, sysdate, :alarmcontentcode, :deviceid, :uac_ab, :uac_ag, :uac_bg, :udc_ab, :udc_ag, :udc_bg, :ir_ab, :ir_ag, :ir_bg, :sr_ab, :sr_ag, :sr_bg, :c_ab, :c_ag, :c_bg, :uact, :berts, :berte, :testresult,:WML)';
    with  Ado_temp,R do
    begin
      Close;
      SQL.Clear;
      SQL.Add('delete from ALARM_TEST_FEEDBACK where cityid=:cityid and deviceid=:deviceid and alarmcontentcode=:alarmcontentcode');
      Parameters.ParamByName('deviceid').Value := deviceid;
      Parameters.ParamByName('cityid').Value := cityid;
      Parameters.ParamByName('alarmcontentcode').Value := alarmcontentcode;
      ExecSql;
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      Parameters.ParamByName('deviceid').Value := deviceid;
      Parameters.ParamByName('cityid').Value := cityid;
      Parameters.ParamByName('alarmcontentcode').Value := alarmcontentcode;
      Parameters.ParamByName('UAC_AB').Value := UAC_AB;
      Parameters.ParamByName('UAC_AG').Value := UAC_AG;
      Parameters.ParamByName('UAC_BG').Value := UAC_BG;
      Parameters.ParamByName('UDC_AB').Value := UDC_AB;
      Parameters.ParamByName('UDC_AG').Value := UDC_AG;
      Parameters.ParamByName('UDC_BG').Value := UDC_BG;
      Parameters.ParamByName('IR_AB').Value := IR_AB;
      Parameters.ParamByName('IR_AG').Value := IR_AG;
      Parameters.ParamByName('IR_BG').Value := IR_BG;
      Parameters.ParamByName('SR_AB').Value := SR_AB;
      Parameters.ParamByName('SR_AG').Value := SR_AG;
      Parameters.ParamByName('SR_BG').Value := SR_BG;
      Parameters.ParamByName('C_AB').Value := C_AB;
      Parameters.ParamByName('C_AG').Value := C_AG;
      Parameters.ParamByName('C_BG').Value := C_BG;
      Parameters.ParamByName('UACT').Value := UACT;
      Parameters.ParamByName('BERTS').Value := BERTS;
      Parameters.ParamByName('BERTE').Value := BERTE;
      Parameters.ParamByName('TESTRESULT').Value := TESTRESULT;
      Parameters.ParamByName('WML').Value := WML;
      ExecSql;
    end;
  except
    result := false;
  end;
end;

end.
