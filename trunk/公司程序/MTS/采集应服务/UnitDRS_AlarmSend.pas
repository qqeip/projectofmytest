unit UnitDRS_AlarmSend;

interface

uses
  Classes,ADODB,DB,Ut_BaseThread, SysUtils;

const
  WD_THREADFUNCTION_NAME = '直放站告警派障线程';

type
  TDRS_AlarmSendThread = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn: TAdoConnection;
    FQuery: TAdoQuery;
    FQueryFree: TAdoQuery;

    function ExecLocalSQL(FMyQuery :TAdoQuery;sqlstr:String):integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(ConStr:String);
    destructor Destroy; override;
  end;

implementation

uses Ut_Global, UnitThreadCommon;

{ TDRS_AlarmSendThread }

constructor TDRS_AlarmSendThread.Create(ConStr: String);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := true;
  
  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FConn;
  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection := FConn;
end;

destructor TDRS_AlarmSendThread.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;
  inherited destroy;
end;

procedure TDRS_AlarmSendThread.DoExecute;
var
  lSqlstr: string;
  lMtuCauseRemoveAlarm: integer;
  lRecordcount: integer;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write(WD_THREADFUNCTION_NAME+' 无法连接数据库!',1);
    Exit;
  end;
  try
    try
      while True do
      begin
        FCounterDatetime:= GetSysDateTime(FQueryFree);
        //删除直放站状态不是“可服务或告警或离线”的告警或CLEAR告警信息
        lSqlstr:= 'delete from drs_data_collect a'+
                  ' where not exists (select 1 from drs_statuslist b'+
                  '                 where a.drsid=b.drsid and b.drsstatus in (2,3,4))';
        ExecMySQL(FQueryFree,lSqlstr);
        //更新前N条记录，等待执行
        lSqlstr:= 'update drs_data_collect a set a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+
                  ' and rownum<=500';
//        lSqlstr:= 'update drs_data_collect a set a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
//                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+
//                  ' and a.collectid<=(select min(collectid)+500 from drs_data_collect)';
        ExecMySQL(FQueryFree,lSqlstr);
        //根据DRSID，CONTENTCODE来删除重复记录
        lSqlstr:= 'delete from drs_data_collect a'+
                  ' where rowid!=(select max(b.rowid) from drs_data_collect b'+
                  '     where a.drsid=b.drsid and a.alarmcontentcode=b.alarmcontentcode'+
                  '     and b.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+')';
        ExecMySQL(FQueryFree,lSqlstr);
        //启动事务
        FConn.BeginTrans;
        try
          with FQuery do
          begin
            close;
            lSqlstr:= 'select 1 from drs_data_collect a'+
                      ' where a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR);
            sql.Text := lSqlstr;
            open;
            //当前记录数
            lRecordcount:= recordcount;
          end;
          //排障消息  (增加排障次数，告警次数清零)
          lSqlstr:= 'update drs_alarm_online a'+
                    ' set a.removecount=a.removecount+1,a.alarmcount=0'+
                    ' where exists (select 1 from drs_data_collect b,drs_alarm_content c'+
                    '     where a.cityid=b.cityid and a.drsid=b.drsid and a.alarmcontentcode=b.alarmcontentcode'+
                    '       and a.alarmcontentcode=c.alarmcontentcode'+
//                    '       and a.removecount<c.removecount'+
                    '       and b.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                    '       and b.isalarm=0)';
          ExecMySQL(FQueryFree,lSqlstr);
          //告警消息(已进drs_alarm_online表)    由于“如果是告警，需获取最新更新获取告警时间”
          lSqlstr:= 'update drs_alarm_online a'+
                    '  set a.alarmcount=a.alarmcount+1,a.removecount=0,updatetime=sysdate'+
                    '  where exists (select 1 from drs_data_collect b,drs_alarm_content c'+
                    '       where a.cityid=b.cityid and a.drsid=b.drsid and a.alarmcontentcode=b.alarmcontentcode'+
                    '         and a.alarmcontentcode=c.alarmcontentcode'+
//                    '         and a.alarmcount<c.alarmcount'+
                    '         and b.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                    '         and b.isalarm=1)';
          ExecMySQL(FQueryFree,lSqlstr);
          //告警消息(未进alarm_master_online表)
          lSqlstr:= 'insert into drs_alarm_online'+
                    ' (alarmid, cityid, drsid, alarmcontentcode, flowtache,'+
                    ' sendtime, removetime, collecttime, alarmcount, removecount, readed, remark, updatetime)'+
                    ' select mtu_alarmid.nextval,a.cityid,a.drsid,a.alarmcontentcode,1,'+
                    ' null,null,sysdate,1,0,-1,null,sysdate'+
                    ' from drs_data_collect a'+
                    ' where not exists (select 1 from drs_alarm_online b'+
                    '         where a.drsid=b.drsid and a.alarmcontentcode=b.alarmcontentcode)'+
                    '       and a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                    '       and a.isalarm=1';
          ExecMySQL(FQueryFree,lSqlstr);
                    //>>>>>>>>>>>>>>>>>
                    //(实现功能：产生告警的最近几次测试结果)
                    lSqlstr:= ' update drs_alarmresult a set a.alarmid='+
                              ' (select alarmid from drs_alarm_online b'+
                              '        where a.cityid=b.cityid and a.DRSID=b.DRSID and a.alarmcontentcode=b.alarmcontentcode)'+
                              ' where exists (select 1 from drs_alarm_online b where a.cityid=b.cityid and a.DRSID=b.DRSID and a.alarmcontentcode=b.alarmcontentcode)';
                    ExecMySQL(FQueryFree,lSqlstr);
                    lSqlstr:= 'delete from drs_alarmresult a'+
                              ' where exists (select 1 from (select t.*,row_number() over (partition by t.cityid,t.drsid,t.alarmcontentcode order by id desc) rn from drs_alarmresult t) b,drs_alarm_content c'+
                              ' where a.id=b.id and b.alarmcontentcode=c.alarmcontentcode and b.rn>c.alarmcount)';
                    ExecMySQL(FQueryFree,lSqlstr);
                    lSqlstr:= 'delete from drs_alarmresult a where not exists (select 1 from drs_alarm_online b'+
                                                              '                where a.cityid=b.cityid and a.alarmid=b.alarmid)'+
                                                              ' and a.alarmid is not null';
                    ExecMySQL(FQueryFree,lSqlstr);
                    //<<<<<<<<<<<<<<<<<<<<
          //构造告警响铃
          lSqlstr:= 'delete from alarm_ringremind_info a'+
                    '  where exists (select 1 from drs_alarm_online b,drs_alarm_content c'+
                    '               where b.alarmcontentcode=c.alarmcontentcode and b.alarmcount=c.alarmcount'+
                    '               and a.cityid=b.cityid and b.flowtache=1)'+
                    '        and a.remindtype=2';
          ExecMySQL(FQueryFree,lSqlstr);
          lSqlstr:= 'insert into alarm_ringremind_info'+
                    '    (cityid, companyid, alarmlevel, isremind, remark, updatetime, remindtype)'+
                    '  select b.cityid,1,1,1,null,sysdate,2'+
                    '  from drs_alarm_online b,drs_alarm_content c'+
                    '  where b.alarmcontentcode=c.alarmcontentcode and b.alarmcount=c.alarmcount'+
                    '        and b.flowtache=1';
          ExecMySQL(FQueryFree,lSqlstr);
          //该派的派
          lSqlstr:= 'update drs_alarm_online a'+
                    ' set a.flowtache=2,a.sendtime=sysdate'+
                    ' where exists (select 1 from drs_alarm_content b'+
                    '             where a.alarmcontentcode=b.alarmcontentcode'+
                    '             and a.alarmcount=b.alarmcount'+
                    '       and a.flowtache=1)';
          ExecMySQL(FQueryFree,lSqlstr);
          //该清的清
          lSqlstr:= 'update drs_alarm_online a'+
                    ' set a.flowtache=3,a.removetime=sysdate'+
                    ' where exists (select 1 from drs_alarm_content b'+
                    '             where a.alarmcontentcode=b.alarmcontentcode'+
                    '             and a.removecount=b.removecount'+
                    '       and a.flowtache=2)';
          ExecMySQL(FQueryFree,lSqlstr);
          //未派的告警直接删除
          lSqlstr:= 'delete drs_alarm_online a'+
                    ' where exists (select 1 from drs_alarm_content b'+
                    '             where a.alarmcontentcode=b.alarmcontentcode'+
                    '             and a.removecount=b.removecount'+
                    '       and a.flowtache=1)';
          ExecMySQL(FQueryFree,lSqlstr);
          //进历史
          lSqlstr:= 'insert into drs_alarm_history'+
                    ' select * from drs_alarm_online a'+
                    ' where a.flowtache=3';
          ExecMySQL(FQueryFree,lSqlstr);
          //删除在线
          lSqlstr:= 'delete from drs_alarm_online a'+
                    ' where a.flowtache=3';
          ExecMySQL(FQueryFree,lSqlstr);
          //由于MTU可能被删除或者该MTU区域编号改变了，原先生成的告警需要删除
          lSqlstr:= 'delete from drs_alarm_online a'+
                    ' where not exists (select 1 from (select d.id cityid,a.drsid from drs_info a'+
                                                      ' inner join area_info b on a.suburb=b.id and b.layer=3'+
                                                      ' inner join area_info c on b.top_id=c.id and c.layer=2'+
                                                      ' inner join area_info d on c.top_id=d.id and d.layer=1) b'+
                                       ' where a.cityid=b.cityid and a.drsid=b.drsid)';
          lMtuCauseRemoveAlarm:= ExecLocalSQL(FQueryFree,lSqlstr);
          if lMtuCauseRemoveAlarm>0 then
            FLog.Write('由于DRS被删除或者DRS区域编号改变,同步移除告警数<'+inttostr(lMtuCauseRemoveAlarm)+'>',3);
          //更新直放站告警数字段
          lSqlstr:= 'update drs_statuslist a set a.alarmcounts='+
                    '  (select count(1) from drs_alarm_online b'+
                    '  where a.drsid=b.drsid and b.flowtache=2)';
          ExecMySQL(FQueryFree,lSqlstr);
          //更新直放站状态"离线"
          lSqlstr:= 'update drs_statuslist a set a.drsstatus=4,updatetime1=sysdate'+
                    ' where exists (select 1 from drs_alarm_online b where a.drsid=b.drsid and b.flowtache=2 and b.alarmcontentcode=18)';
          ExecMySQL(FQueryFree,lSqlstr);

          FConn.CommitTrans;
        except
          on e: Exception do
          begin
            FConn.RollbackTrans;
            FLog.Write(WD_THREADFUNCTION_NAME+'执行失败'+#13+
                           ' 错误提示：'+E.Message+#13+
                           ' 错误SQL语句=<'+lSqlstr+'>',2);
          end;
        end;
        //告警采集完后删除
        lSqlstr:= 'delete from drs_data_collect where isprocess='+inttostr(WD_TABLESTATUS_WAITFOR);
        ExecMySQL(FQueryFree,lSqlstr);
        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('派障一次花费'+FormatDatetime('HH:MM:SS秒',FCurrentDateTime-FCounterDatetime),3);
        if lRecordcount=0 then break;
        //手动退出
        if self.IsStop then
          break;
      end;
    except
      on e: Exception do
      begin
        FLog.Write(e.Message,2);
        FLog.Write(WD_THREADFUNCTION_NAME+'   执行失败',2);
      end;
    end;
  finally
    FConn.Connected := false;
  end;
end;

function TDRS_AlarmSendThread.ExecLocalSQL(FMyQuery: TAdoQuery;
  sqlstr: String): integer;
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

end.
