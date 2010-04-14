{MTU自动派障}
unit UnitAlarmSend;

interface
  uses Windows, Classes, Log, Ut_BaseThread, ADODB, SysUtils, Variants;

const
  WD_THREADFUNCTION_NAME = '告警派障线程';

type

  TAlarmSend = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn: TAdoConnection;
    FQuery, FQueryFree: TAdoQuery;
    function ExecLocalSQL(FMyQuery :TAdoQuery;sqlstr:String):integer;
  protected
    procedure DoExecute; override;
    procedure TaskSendCallCenter;
  public
    constructor Create(ConnStr :String);
    destructor Destroy; override;
  end;

implementation

uses Ut_Global, UnitThreadCommon;

{ TAlarmSend }

constructor TAlarmSend.Create(ConnStr: String);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConnStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := true;
  
  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FConn;
  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection := FConn;
end;

destructor TAlarmSend.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;
  inherited destroy;
end;

procedure TAlarmSend.DoExecute;
var
  lSqlstr: string;
  lAlarmStatus: integer;
  lCurr_AlarmCount,lCurr_RemoveCount: integer;
  lMtuCauseRemoveAlarm: integer;
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
      FCounterDatetime:= GetSysDateTime(FQueryFree);
      //更新前N条记录，等待执行
//      lSqlstr:= 'update alarm_data_collect a set a.isprocess=1 where a.isprocess=0'+
//                ' and a.collectid<=(select min(collectid)+500 from alarm_data_collect where isprocess=0)';
      lSqlstr:= 'update alarm_data_collect a set a.isprocess=1 where a.isprocess=0'+
                ' and exists (select 1 from (select * from (select * from alarm_data_collect order by collectid) where rownum<=500) b'+
                '           where a.collectid=b.collectid)';
      ExecMySQL(FQueryFree,lSqlstr);
      //根据MTUID，CONTENTCODE来删除重复记录
      lSqlstr:= 'delete from alarm_data_collect a'+
                ' where rowid!=(select max(b.rowid) from alarm_data_collect b'+
                '     where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode and b.isprocess=1)';
      ExecMySQL(FQueryFree,lSqlstr);
      //删除MTU状态为下线的其他该MTU告警
      //删除MTU状态为电池供电的其他该MTU告警
      lSqlstr:= 'delete from alarm_data_collect a'+
                ' where a.isprocess=1 and a.alarmcontentcode not in (31,37,1) and a.status=1'+
                ' and (exists (select 1 from mtu_status_list b where a.mtuid=b.mtuid and b.status=0)'+
                '     or exists (select 1 from alarm_master_online c where a.mtuid=c.mtuid and c.alarmcontentcode=1)'+
                '     ) ';
      ExecMySQL(FQueryFree,lSqlstr);

      FConn.BeginTrans;
      try
        //排障消息  (增加排障次数，告警次数清零)
        lSqlstr:= 'update alarm_master_online a'+
                  ' set a.removecount=a.removecount+1,a.alarmcount=0'+
                  ' where exists (select 1 from alarm_data_collect b,mtu_alarmcontent_view c'+
                  '     where a.cityid=b.cityid and a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '       and a.mtuid=c.mtuid and a.alarmcontentcode=c.alarmcontentcode'+
                  '       and a.removecount<c.removecount'+
                  '       and b.isprocess=1'+
                  '       and b.status=0)';
        ExecMySQL(FQueryFree,lSqlstr);
        //告警消息(已进alarm_master_online表)
        lSqlstr:= 'update alarm_master_online a'+
                  '  set a.alarmcount=a.alarmcount+1,a.removecount=0'+
                  '  where exists (select 1 from alarm_data_collect b,mtu_alarmcontent_view c'+
                  '       where a.cityid=b.cityid and a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '         and a.mtuid=c.mtuid and a.alarmcontentcode=c.alarmcontentcode'+
                  '         and a.alarmcount<c.alarmcount'+
                  '         and b.isprocess=1'+
                  '         and b.status=1)';
        ExecMySQL(FQueryFree,lSqlstr);
        //告警消息(未进alarm_master_online表)
        lSqlstr:= 'insert into alarm_master_online'+
                  ' (alarmid, cityid, mtuid, alarmcontentcode, flowtache,'+
                  ' sendtime, removetime, collecttime, alarmcount, removecount, readed, remark)'+
                  ' select mtu_alarmid.nextval,a.cityid,a.mtuid,a.alarmcontentcode,1,'+
                  ' null,null,sysdate,1,0,-1,null'+
                  ' from alarm_data_collect a'+
                  ' where not exists (select 1 from alarm_master_online b'+
                  '         where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode)'+
                  '       and a.isprocess=1'+
                  '       and a.status=1';
        ExecMySQL(FQueryFree,lSqlstr);
        //>>>>>>>>>>>>>>>>>
              //(实现功能：产生告警的最近几次测试结果)
              lSqlstr:= ' update mtu_alarmresult a set a.alarmid='+
                        ' (select alarmid from alarm_master_online b'+
                        '        where a.cityid=b.cityid and a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode)'+
                        ' where exists (select 1 from alarm_master_online b where a.cityid=b.cityid and a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode)';
              ExecMySQL(FQueryFree,lSqlstr);
              lSqlstr:= 'delete from MTU_ALARMRESULT a'+
                        ' where exists (select 1 from (select t.*,row_number() over (partition by t.cityid,t.mtuid,t.alarmcontentcode order by id desc) rn from MTU_ALARMRESULT t) b,mtu_alarmcontent_view c'+
                        '               where a.id=b.id'+
                                       ' and b.mtuid=c.mtuid and b.alarmcontentcode=c.alarmcontentcode and b.rn>c.alarmcount)';
              ExecMySQL(FQueryFree,lSqlstr);
              lSqlstr:= 'delete from MTU_ALARMRESULT a where not exists (select 1 from alarm_master_online b'+
                                                        '                where a.cityid=b.cityid and a.alarmid=b.alarmid)'+
                                                        ' and a.alarmid is not null';
              ExecMySQL(FQueryFree,lSqlstr);
        //<<<<<<<<<<<<<<<<<<<<
        //如果是未守候在主服务导频告警
        //派个中心平台呼叫 (根据readed=-1来判断是新增的)
        TaskSendCallCenter;
        lSqlstr:= ' update alarm_master_online set readed=0 where readed=-1';
        ExecMySQL(FQueryFree,lSqlstr);


        //构造告警响铃
        lSqlstr:= 'delete from alarm_ringremind_info a'+
                  '  where exists (select 1 from alarm_master_online b,mtu_alarmcontent_view c'+
                  '               where b.mtuid=c.mtuid and b.alarmcontentcode=c.alarmcontentcode and b.alarmcount=c.alarmcount'+
                  '               and a.cityid=b.cityid and b.flowtache=1)'+
                  '        and a.remindtype=1';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into alarm_ringremind_info'+
                  '    (cityid, companyid, alarmlevel, isremind, remark, updatetime, remindtype)'+
                  '  select b.cityid,1,1,1,null,sysdate,1'+
                  '  from alarm_master_online b,mtu_alarmcontent_view c'+
                  '  where b.mtuid=c.mtuid and b.alarmcontentcode=c.alarmcontentcode and b.alarmcount=c.alarmcount'+
                  '        and b.flowtache=1';
        ExecMySQL(FQueryFree,lSqlstr);
        //该派的派
        lSqlstr:= 'update alarm_master_online a'+
                  ' set a.flowtache=2,a.sendtime=sysdate'+
                  ' where exists (select 1 from mtu_alarmcontent_view b'+
                  '             where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '             and a.alarmcount=b.alarmcount'+
                  '       and a.flowtache=1)';
        ExecMySQL(FQueryFree,lSqlstr);
        //该清的清
        lSqlstr:= 'update alarm_master_online a'+
                  ' set a.flowtache=3,a.removetime=sysdate'+
                  ' where exists (select 1 from mtu_alarmcontent_view b'+
                  '             where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '             and a.removecount=b.removecount'+
                  '       and a.flowtache=2)';
        ExecMySQL(FQueryFree,lSqlstr);
        //未派的告警直接删除
        lSqlstr:= 'delete alarm_master_online a'+
                  ' where exists (select 1 from mtu_alarmcontent_view b'+
                  '             where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '             and a.removecount=b.removecount'+
                  '       and a.flowtache=1)';
        ExecMySQL(FQueryFree,lSqlstr);
        {lSqlstr:= 'insert into alarm_master_history'+
                  ' select a.* from alarm_master_online a'+
                  ' left join mtu_alarmcontent_view b'+
                  '     on a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '     and a.removecount=b.removecount'+
                  ' where b.mtuid is not null';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from alarm_master_online a'+
                  ' where exists (select 1 from mtu_alarmcontent_view b'+
                  '             where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '             and a.removecount=b.removecount)';
        ExecMySQL(FQueryFree,lSqlstr);}
        lSqlstr:= 'insert into alarm_master_history'+
                  ' select a.* from alarm_master_online a'+
                  ' where a.flowtache=3';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from alarm_master_online a'+
                  ' where a.flowtache=3';
        ExecMySQL(FQueryFree,lSqlstr);
        //由于MTU可能被删除或者该MTU区域编号改变了，原先生成的告警需要删除
        lSqlstr:= 'delete from alarm_master_online a'+
                  ' where not exists (select 1 from mtu_info_view b'+
                  '      where a.cityid=b.cityid and a.mtuid=b.mtuid)';
        lMtuCauseRemoveAlarm:= ExecLocalSQL(FQueryFree,lSqlstr);
        if lMtuCauseRemoveAlarm>0 then
          FLog.Write('由于MTU被删除或者MTU区域编号改变,同步移除告警数'+inttostr(lMtuCauseRemoveAlarm),3);
        FConn.CommitTrans;
      except
        on e: Exception do
        begin
          FConn.RollbackTrans;
          FLog.Write(WD_THREADFUNCTION_NAME+'错误提示：'+E.Message,1);
          FLog.Write(WD_THREADFUNCTION_NAME+'派障失败',1);
          FLog.Write(WD_THREADFUNCTION_NAME+lSqlstr,1);
        end;
      end;
      //告警采集完后删除
      lSqlstr:= 'delete from alarm_data_collect where isprocess=1';
      ExecMySQL(FQueryFree,lSqlstr);
      FCurrentDateTime:= GetSysDateTime(FQueryFree);
      FLog.Write('派障一次花费'+FormatDatetime('HH:MM:SS秒',FCurrentDateTime-FCounterDatetime),3);
      //手动退出
      if self.IsStop then
        break;
    end; //无限循环结束
  finally
    FConn.Connected := false;
  end;
end;

function TAlarmSend.ExecLocalSQL(FMyQuery: TAdoQuery; sqlstr: String): integer;
begin
  result:= 0;
  with FMyQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    result:= ExecSQL;
    Close;
  end;
end;

procedure TAlarmSend.TaskSendCallCenter;
var
  lSqlstr: string;
  lTaskid: integer;
  lMtuid, lCityid: integer;
begin
  with FQuery do
  begin
    close;
    sql.Text:= 'select a.mtuid,a.cityid from alarm_master_online a'+
               ' where a.readed=-1 and a.alarmcontentcode=46';
    open;
    first;
    while not eof do
    begin
      lMtuid:= FieldByName('MTUID').AsInteger;
      lCityid:= FieldByName('CITYID').AsInteger;
      lTaskid:= GetSequence(FQueryFree,'mtu_taskid');


      lSqlstr:= 'insert into mtu_testtask_online'+
                ' (taskid, cityid, mtuid, comid, status, testresult, asktime, sendtime, rectime, tasklevel, userid, modelid)'+
                ' values'+
                ' ('+inttostr(lTaskid)+', '+inttostr(lCityid)+', '+inttostr(lMtuid)+','+
                ' 12, 0, null, sysdate, null, null, 2, -1, null)';
      ExecMySQL(FQueryFree,lSqlstr);
      lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
                ' ('+inttostr(lTaskid)+', 1, (select decode(mtuno,null,''00000000'',mtuno) from mtu_info  where mtuid='+inttostr(lMtuid)+'))';
      ExecMySQL(FQueryFree,lSqlstr);
      lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
                ' ('+inttostr(lTaskid)+', 7, (select decode(call,null,''00000000'',call) from mtu_info  where mtuid='+inttostr(lMtuid)+'))';
      ExecMySQL(FQueryFree,lSqlstr);
      lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
                ' ('+inttostr(lTaskid)+', 8, 90)';
      ExecMySQL(FQueryFree,lSqlstr);
      lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
                ' ('+inttostr(lTaskid)+', 9, 1)';
      ExecMySQL(FQueryFree,lSqlstr);
      lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
                ' ('+inttostr(lTaskid)+', 10, 1)';
      ExecMySQL(FQueryFree,lSqlstr);

      next;
    end;
  end;
end;

end.
