unit UnitResultParas;

interface
  uses Windows, Classes, Log, Ut_BaseThread, ADODB, IdGlobal, SysUtils;

const
  WD_THREADFUNCTION_NAME = 'MTUC结果解析线程';
type
  TResultParas = class(TMyThread)

  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn: TAdoConnection;
    FQuery, FQueryFree: TAdoQuery;
    FMTUList :TStringList;
    FSQLList :TStringList;
    FSQLList_Index: integer;

    procedure ExecSQLList(FMyQuery :TAdoQuery;sqllist:TStringList);
    function ParseBaseData(cityid:integer;MsgData:TIdBytes;var aTaskid:integer):integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(ConnStr :String);
    destructor Destroy; override;
  end;



implementation

uses Ut_Global, UnitThreadCommon, Ut_MtuInfo;

{ TResultParas }

procedure TResultParas.ExecSQLList(FMyQuery :TAdoQuery;sqllist:TStringList);
var
  i: integer;
begin
  for i:= 0 to sqllist.Count - 1 do
  with FMyQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqllist.Strings[i]);
    //当前SQL列表的索引
    FSQLList_Index:= i;
    ExecSQL;
    Close;
  end;
end;

constructor TResultParas.Create(ConnStr: String);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConnStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := false;
  
  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FConn;
  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection := FConn;

  FMTUList:= TStringList.Create;
  FSQLList:= TStringList.Create;
end;
destructor TResultParas.Destroy;
begin
  FMTUList.Free;
  FSQLList.Free;
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;
  inherited destroy;
end;

procedure TResultParas.DoExecute;
var
  lSqlstr: string;
  MsgData :TIdBytes;
  lTaskid: integer;
  lParaseBaseDataStatus: integer;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write(WD_THREADFUNCTION_NAME+'无法连接数据库!',1);
    Exit;
  end;
  try
    while True do //无限循环
    begin
      //更新前N条记录，等待执行
      FCounterDatetime:= GetSysDateTime(FQueryFree);
      lSqlstr:= 'update mtu_testresult_base a set a.isprocess=1 where a.isprocess=0'+
                ' and rownum<=200';
      ExecMySQL(FQueryFree,lSqlstr);
      //加载现有MTU列表
      with FQueryFree do
      begin
        close;
        sql.Text:='select upper(t.mtuno) mtuno from mtu_info t';
        open;
        FMTULIst.Clear;
        while not Eof do
        begin
          FMTULIst.Add(Fieldbyname('mtuno').AsString);
          Next;
        end;
      end;

      with FQuery do
      begin
        close;
        lSqlstr:= 'select * from mtu_testresult_base where isprocess=1';
        sql.Text := lSqlstr;
        open;
        first;
        while not eof do
        begin
          try
            MsgData := StrToIdBytes(FieldByName('testvalue').AsString);
            ParseBaseData(FieldByname('cityid').AsInteger,MsgData,lTaskID);
          except
            on e: Exception do
            begin
              edit;
              Fieldbyname('ISPROCESS').AsInteger := 3;
              post;
              FLog.Write(WD_THREADFUNCTION_NAME+'错误提示：'+E.Message,1);
              FLog.Write(WD_THREADFUNCTION_NAME+'BASEID< '+FieldByname('baseid').AsString+' >执行失败',1);
              if FSQLList.Count> FSQLList_Index then
                FLog.Write(FSQLList.Strings[FSQLList_Index],1);
            end;  
          end;
          next;
        end;
        //更新采集时间  保证一个循环周期的采集时间一致
        lSqlstr:= 'update mtu_testresult_online set collecttime=sysdate where isprocess=-2';
        ExecMySQL(FQueryFree,lSqlstr);
        //已经处理的测试结果更新测试任务值STATUS=4
        lSqlstr:= 'update mtu_testtask_online a set a.status=4,RECTIME=sysdate'+
                  ' where exists (select 1 from mtu_testresult_online b '+
                                'where a.cityid=b.cityid and a.taskid=b.taskid and b.isprocess=-2)';
        ExecMySQL(FQueryFree,lSqlstr);
        //已经处理手动测试结果进手动测试表
        lSqlstr:= 'insert into mtu_usertestresult'+
                  ' select * from mtu_testresult_online a'+
                  ' where a.isprocess=-2'+
                  ' and exists (select 1 from mtu_testtask_online b where a.cityid=b.cityid and a.taskid=b.taskid and b.userid<>-1)';
        ExecMySQL(FQueryFree,lSqlstr);
        //删除已经处理的自动测试任务进历史表
        lSqlstr:= 'insert into MTU_TESTTASK_HISTROY'+
                  ' select a.* from MTU_TESTTASK_ONLINE a'+
                  ' where a.STATUS>=4 and a.userid=-1'; // in (4,5,6,7,8,9)
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from mtu_testtaskparam_online a where exists'+
                  ' (select 1 from mtu_testtask_online b where a.taskid=b.taskid and b.userid=-1'+
                  ' and b.STATUS>=4)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from mtu_testtask_online a where a.STATUS>=4 and a.userid=-1';
        ExecMySQL(FQueryFree,lSqlstr);


        //已经处理的测试结果的最大记录更新mtu_status_list信息
        lSqlstr:= 'merge into mtu_status_list x'+
                  ' using (select a.mtuid,max(case when (comid=136 or comid=68) and paramid=35 then a.testresult end) as mtustatus,'+
                        ' max(case when comid=65 and paramid=3 then a.testresult end) as powerstatus,'+
                        ' max(case when comid=69 and paramid=42 then a.testresult end) as wlanstatus'+
                        ' from mtu_testresult_online a'+
                        ' where isprocess=-2'+
//                        ' inner join (select max(taskid) taskid from mtu_testresult_online'+
//                        ' where ((comid=136 or comid=68)  and paramid=35) or (comid=65 and paramid=3)'+
//                        ' or (comid=69 and paramid=42) and isprocess=2'+
//                        ' group by comid,paramid,mtuid) b'+
//                        ' on a.taskid=b.taskid'+
                        ' group by a.mtuid) y'+
                  ' on (x.mtuid=y.mtuid)'+
                  ' when matched then'+
                  ' update set x.status=decode(y.mtustatus,null,x.status,y.mtustatus),'+
                             ' x.status_power=decode(y.powerstatus,null,x.status_power,y.powerstatus),'+
                             ' x.status_wlan=decode(y.wlanstatus,null,x.status_wlan,y.wlanstatus),'+
                             ' x.updatetime=sysdate'+
                  ' when not matched then'+
                  ' insert (mtuid, status, updatetime, status_power, status_wlan)'+
                  ' values (y.mtuid,y.mtustatus,sysdate,y.powerstatus,y.wlanstatus)';
        ExecMySQL(FQueryFree,lSqlstr);
        //<<保存到最新表
        lSqlstr:= 'delete from mtu_testresult_recent a'+
                  ' where exists (select 1 from mtu_testresult_online b'+
                  ' where a.mtuid=b.mtuid and a.comid=b.comid and b.isprocess=-2)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into mtu_testresult_recent'+
                  ' select a.* from mtu_testresult_online a'+
                  ' left join  (select max(b.taskid) taskid from mtu_testresult_online b'+
                  ' where b.isprocess=-2 group by b.cityid,b.comid,b.mtuid) b'+
                  ' on a.taskid=b.taskid'+
                  ' where b.taskid is not null';
        ExecMySQL(FQueryFree,lSqlstr);
        //保存到最新表>>
        //解析结果预处理完毕，更新isprocess=0给告警采集用
        lSqlstr:= 'update mtu_testresult_online set isprocess=0 where isprocess=-2';
        ExecMySQL(FQueryFree,lSqlstr);

        //删除已经处理的结果原始表进历史表
        lSqlstr:= 'insert into MTU_TESTRESULT_BASE_HISTORY'+
                  ' select * from mtu_testresult_base a where a.isprocess=1';
        ExecMySQL(FQueryFree,lSqlstr);
        //解析完后删除
        lSqlstr:= 'delete from mtu_testresult_base where isprocess=1';
        ExecMySQL(FQueryFree,lSqlstr);
        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('解析'+inttostr(FQuery.RecordCount)+'条结果花费'+FormatDatetime('HH:MM:SS秒',FCurrentDateTime-FCounterDatetime),3);
        //如果没有记录就退出循环
        if recordcount=0 then break;
      end;
      //手动退出
      if self.IsStop then
        break;
    end; //无限循环结束
  finally
    FConn.Connected := false;
  end;
end;

function TResultParas.ParseBaseData(cityid: integer; MsgData: TIdBytes;
  var aTaskid: integer): integer;
var
  Mtu :TMtuBase;
begin
  result := 0;
  FSQLList.Clear;
  try
    //第四字节为消息编号
    case MsgData[4] of
      MTU_REPORT_SELF              :begin
                                      Mtu := TMtuSelf.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_REPORT_CCH               :begin
                                      Mtu := TMtuCch.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_TEST_CALL_RESULT         : Mtu := TMtuCall.create;
      MTU_TEST_TCH_RESULT          : Mtu := TMtuTch.create;
      MTU_TEST_HANDOVER_RESULT     : Mtu := TMtuHandOver.create;
      MTU_TEST_MOS_RESULT          : Mtu := TMtuMos.create;
      MTU_TEST_VOICE_RESULT        : Mtu := TMtuVoice.create;
      MTU_TEST_CALLEE_DELAY_RESULT : Mtu := TMtuCallEEDelay.create;
      MTU_REPORT_WLAN              :begin
                                      Mtu := TMtuWLan.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_TEST_WLAN_SPEED_RESULT   : Mtu := TMtuWLanSpeed.create;
      MTU_TEST_WLAN_DELAY_RESULT   : Mtu := TMtuWLanDelay.create;
      MTU_REPORT_STATUS            :begin
                                      Mtu := TMtuStatus.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_GET_STATUS_RESULT        :begin//特殊
                                      Mtu := TMtuGetStatus.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_REPORT_WLAN_ERROR        : begin
                                       Mtu := TMtuWLanError.create;
                                       Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                     end;
      MTU_REPORT_WLAN_OK           : Mtu := TMtuWLanOK.create;
      MTU_GET_CALLEE_RESULT        :begin//特殊
                                      Mtu := TMtuGetCallEE.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_COMMAND_ACK              : Mtu := TMtuCmdAck.create;
      MTU_NOWLAN_REPORT            :begin
                                      Mtu := TMtuNoLan.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_NOCCH_REPORT             :begin
                                      Mtu := TMtuNoCCH.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_MOS_VIRTUAL              :begin
                                      Mtu := TMtuMOSDone.create
                                    end;
      //20090612
      MTU_PPP_TEST_RESULT          :begin
                                      Mtu  := TMtuPPPTest.create;
                                    end;
      MTU_REPORT_SIGNALSTREAM_OFF  :begin
                                      Mtu  := TMtuCDMAREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_REPORT_SIGNALSTREAM_ON   :begin
                                      Mtu  := TMtuCDMAREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_REPORT_NEIGHBOR_OFF      :begin
                                      Mtu  := TMtuNEIGHBORREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_NEIGHBOR_ON       :begin
                                      Mtu  := TMtuNEIGHBORREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_SWITCH_OFF        :begin
                                      Mtu  := TMtuSWITCHREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_SWITCH_ON         :begin
                                      Mtu  := TMtuSWITCHREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_FINGER_OFF        :begin
                                      Mtu  := TMtuFINGERREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_FINGER_ON         :begin
                                      Mtu  := TMtuFINGERREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_ACTIVE_OFF        :begin
                                      Mtu  := TMtuACTIVEREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_ACTIVE_ON         :begin
                                      Mtu  := TMtuACTIVEREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_SECOND_OFF        :begin
                                      Mtu  := TMtuSECONDREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_SECOND_ON         :begin
                                      Mtu  := TMtuSECONDREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_TEST_CALL_CENTER_RESULT  :begin
                                      Mtu  := TMtuCallCenter.create;
                                    end;
      MTU_LOCALANALYSE             :begin
                                      Mtu  := TMtuLocalAnalyse.create;
                                    end
      else exit;
    end;
    try
      Mtu.Cityid := cityid;
      Mtu.MtuList:= FMTULIst;
      if Mtu.DecodeMsgSQL(MsgData,FSQLList) then
      begin
        aTaskid := Mtu.TaskId;
        if FSQLList.Count >0 then
        begin
          ExecSQLList(FQueryFree,FSQLList);
          if MsgData[4]=MTU_COMMAND_ACK then //命令响应
            result := 2
          else
            result := 1;                     //其他命令
        end
        else
          result := 3;                       //本地命令
      end;
    finally
      if Mtu <> nil then
        Mtu.Free;
    end;
  finally
  end;
end;

end.

