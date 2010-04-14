{MTU�Զ�����}
unit UnitAlarmSend;

interface
  uses Windows, Classes, Log, Ut_BaseThread, ADODB, SysUtils, Variants;

const
  WD_THREADFUNCTION_NAME = '�澯�����߳�';

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
    FLog.Write(WD_THREADFUNCTION_NAME+'�޷��������ݿ�!',1);
    Exit;
  end;


  try
    while True do //����ѭ��
    begin
      FCounterDatetime:= GetSysDateTime(FQueryFree);
      //����ǰN����¼���ȴ�ִ��
//      lSqlstr:= 'update alarm_data_collect a set a.isprocess=1 where a.isprocess=0'+
//                ' and a.collectid<=(select min(collectid)+500 from alarm_data_collect where isprocess=0)';
      lSqlstr:= 'update alarm_data_collect a set a.isprocess=1 where a.isprocess=0'+
                ' and exists (select 1 from (select * from (select * from alarm_data_collect order by collectid) where rownum<=500) b'+
                '           where a.collectid=b.collectid)';
      ExecMySQL(FQueryFree,lSqlstr);
      //����MTUID��CONTENTCODE��ɾ���ظ���¼
      lSqlstr:= 'delete from alarm_data_collect a'+
                ' where rowid!=(select max(b.rowid) from alarm_data_collect b'+
                '     where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode and b.isprocess=1)';
      ExecMySQL(FQueryFree,lSqlstr);
      //ɾ��MTU״̬Ϊ���ߵ�������MTU�澯
      //ɾ��MTU״̬Ϊ��ع����������MTU�澯
      lSqlstr:= 'delete from alarm_data_collect a'+
                ' where a.isprocess=1 and a.alarmcontentcode not in (31,37,1) and a.status=1'+
                ' and (exists (select 1 from mtu_status_list b where a.mtuid=b.mtuid and b.status=0)'+
                '     or exists (select 1 from alarm_master_online c where a.mtuid=c.mtuid and c.alarmcontentcode=1)'+
                '     ) ';
      ExecMySQL(FQueryFree,lSqlstr);

      FConn.BeginTrans;
      try
        //������Ϣ  (�������ϴ������澯��������)
        lSqlstr:= 'update alarm_master_online a'+
                  ' set a.removecount=a.removecount+1,a.alarmcount=0'+
                  ' where exists (select 1 from alarm_data_collect b,mtu_alarmcontent_view c'+
                  '     where a.cityid=b.cityid and a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '       and a.mtuid=c.mtuid and a.alarmcontentcode=c.alarmcontentcode'+
                  '       and a.removecount<c.removecount'+
                  '       and b.isprocess=1'+
                  '       and b.status=0)';
        ExecMySQL(FQueryFree,lSqlstr);
        //�澯��Ϣ(�ѽ�alarm_master_online��)
        lSqlstr:= 'update alarm_master_online a'+
                  '  set a.alarmcount=a.alarmcount+1,a.removecount=0'+
                  '  where exists (select 1 from alarm_data_collect b,mtu_alarmcontent_view c'+
                  '       where a.cityid=b.cityid and a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '         and a.mtuid=c.mtuid and a.alarmcontentcode=c.alarmcontentcode'+
                  '         and a.alarmcount<c.alarmcount'+
                  '         and b.isprocess=1'+
                  '         and b.status=1)';
        ExecMySQL(FQueryFree,lSqlstr);
        //�澯��Ϣ(δ��alarm_master_online��)
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
              //(ʵ�ֹ��ܣ������澯��������β��Խ��)
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
        //�����δ�غ���������Ƶ�澯
        //�ɸ�����ƽ̨���� (����readed=-1���ж���������)
        TaskSendCallCenter;
        lSqlstr:= ' update alarm_master_online set readed=0 where readed=-1';
        ExecMySQL(FQueryFree,lSqlstr);


        //����澯����
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
        //���ɵ���
        lSqlstr:= 'update alarm_master_online a'+
                  ' set a.flowtache=2,a.sendtime=sysdate'+
                  ' where exists (select 1 from mtu_alarmcontent_view b'+
                  '             where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '             and a.alarmcount=b.alarmcount'+
                  '       and a.flowtache=1)';
        ExecMySQL(FQueryFree,lSqlstr);
        //�������
        lSqlstr:= 'update alarm_master_online a'+
                  ' set a.flowtache=3,a.removetime=sysdate'+
                  ' where exists (select 1 from mtu_alarmcontent_view b'+
                  '             where a.mtuid=b.mtuid and a.alarmcontentcode=b.alarmcontentcode'+
                  '             and a.removecount=b.removecount'+
                  '       and a.flowtache=2)';
        ExecMySQL(FQueryFree,lSqlstr);
        //δ�ɵĸ澯ֱ��ɾ��
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
        //����MTU���ܱ�ɾ�����߸�MTU�����Ÿı��ˣ�ԭ�����ɵĸ澯��Ҫɾ��
        lSqlstr:= 'delete from alarm_master_online a'+
                  ' where not exists (select 1 from mtu_info_view b'+
                  '      where a.cityid=b.cityid and a.mtuid=b.mtuid)';
        lMtuCauseRemoveAlarm:= ExecLocalSQL(FQueryFree,lSqlstr);
        if lMtuCauseRemoveAlarm>0 then
          FLog.Write('����MTU��ɾ������MTU�����Ÿı�,ͬ���Ƴ��澯��'+inttostr(lMtuCauseRemoveAlarm),3);
        FConn.CommitTrans;
      except
        on e: Exception do
        begin
          FConn.RollbackTrans;
          FLog.Write(WD_THREADFUNCTION_NAME+'������ʾ��'+E.Message,1);
          FLog.Write(WD_THREADFUNCTION_NAME+'����ʧ��',1);
          FLog.Write(WD_THREADFUNCTION_NAME+lSqlstr,1);
        end;
      end;
      //�澯�ɼ����ɾ��
      lSqlstr:= 'delete from alarm_data_collect where isprocess=1';
      ExecMySQL(FQueryFree,lSqlstr);
      FCurrentDateTime:= GetSysDateTime(FQueryFree);
      FLog.Write('����һ�λ���'+FormatDatetime('HH:MM:SS��',FCurrentDateTime-FCounterDatetime),3);
      //�ֶ��˳�
      if self.IsStop then
        break;
    end; //����ѭ������
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
