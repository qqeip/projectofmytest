unit UnitDRS_AlarmSend;

interface

uses
  Classes,ADODB,DB,Ut_BaseThread, SysUtils;

const
  WD_THREADFUNCTION_NAME = 'ֱ��վ�澯�����߳�';

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
    FLog.Write(WD_THREADFUNCTION_NAME+' �޷��������ݿ�!',1);
    Exit;
  end;
  try
    try
      while True do
      begin
        FCounterDatetime:= GetSysDateTime(FQueryFree);
        //ɾ��ֱ��վ״̬���ǡ��ɷ����澯�����ߡ��ĸ澯��CLEAR�澯��Ϣ
        lSqlstr:= 'delete from drs_data_collect a'+
                  ' where not exists (select 1 from drs_statuslist b'+
                  '                 where a.drsid=b.drsid and b.drsstatus in (2,3,4))';
        ExecMySQL(FQueryFree,lSqlstr);
        //����ǰN����¼���ȴ�ִ��
        lSqlstr:= 'update drs_data_collect a set a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+
                  ' and rownum<=500';
//        lSqlstr:= 'update drs_data_collect a set a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
//                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+
//                  ' and a.collectid<=(select min(collectid)+500 from drs_data_collect)';
        ExecMySQL(FQueryFree,lSqlstr);
        //����DRSID��CONTENTCODE��ɾ���ظ���¼
        lSqlstr:= 'delete from drs_data_collect a'+
                  ' where rowid!=(select max(b.rowid) from drs_data_collect b'+
                  '     where a.drsid=b.drsid and a.alarmcontentcode=b.alarmcontentcode'+
                  '     and b.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+')';
        ExecMySQL(FQueryFree,lSqlstr);
        //��������
        FConn.BeginTrans;
        try
          with FQuery do
          begin
            close;
            lSqlstr:= 'select 1 from drs_data_collect a'+
                      ' where a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR);
            sql.Text := lSqlstr;
            open;
            //��ǰ��¼��
            lRecordcount:= recordcount;
          end;
          //������Ϣ  (�������ϴ������澯��������)
          lSqlstr:= 'update drs_alarm_online a'+
                    ' set a.removecount=a.removecount+1,a.alarmcount=0'+
                    ' where exists (select 1 from drs_data_collect b,drs_alarm_content c'+
                    '     where a.cityid=b.cityid and a.drsid=b.drsid and a.alarmcontentcode=b.alarmcontentcode'+
                    '       and a.alarmcontentcode=c.alarmcontentcode'+
//                    '       and a.removecount<c.removecount'+
                    '       and b.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                    '       and b.isalarm=0)';
          ExecMySQL(FQueryFree,lSqlstr);
          //�澯��Ϣ(�ѽ�drs_alarm_online��)    ���ڡ�����Ǹ澯�����ȡ���¸��»�ȡ�澯ʱ�䡱
          lSqlstr:= 'update drs_alarm_online a'+
                    '  set a.alarmcount=a.alarmcount+1,a.removecount=0,updatetime=sysdate'+
                    '  where exists (select 1 from drs_data_collect b,drs_alarm_content c'+
                    '       where a.cityid=b.cityid and a.drsid=b.drsid and a.alarmcontentcode=b.alarmcontentcode'+
                    '         and a.alarmcontentcode=c.alarmcontentcode'+
//                    '         and a.alarmcount<c.alarmcount'+
                    '         and b.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                    '         and b.isalarm=1)';
          ExecMySQL(FQueryFree,lSqlstr);
          //�澯��Ϣ(δ��alarm_master_online��)
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
                    //(ʵ�ֹ��ܣ������澯��������β��Խ��)
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
          //����澯����
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
          //���ɵ���
          lSqlstr:= 'update drs_alarm_online a'+
                    ' set a.flowtache=2,a.sendtime=sysdate'+
                    ' where exists (select 1 from drs_alarm_content b'+
                    '             where a.alarmcontentcode=b.alarmcontentcode'+
                    '             and a.alarmcount=b.alarmcount'+
                    '       and a.flowtache=1)';
          ExecMySQL(FQueryFree,lSqlstr);
          //�������
          lSqlstr:= 'update drs_alarm_online a'+
                    ' set a.flowtache=3,a.removetime=sysdate'+
                    ' where exists (select 1 from drs_alarm_content b'+
                    '             where a.alarmcontentcode=b.alarmcontentcode'+
                    '             and a.removecount=b.removecount'+
                    '       and a.flowtache=2)';
          ExecMySQL(FQueryFree,lSqlstr);
          //δ�ɵĸ澯ֱ��ɾ��
          lSqlstr:= 'delete drs_alarm_online a'+
                    ' where exists (select 1 from drs_alarm_content b'+
                    '             where a.alarmcontentcode=b.alarmcontentcode'+
                    '             and a.removecount=b.removecount'+
                    '       and a.flowtache=1)';
          ExecMySQL(FQueryFree,lSqlstr);
          //����ʷ
          lSqlstr:= 'insert into drs_alarm_history'+
                    ' select * from drs_alarm_online a'+
                    ' where a.flowtache=3';
          ExecMySQL(FQueryFree,lSqlstr);
          //ɾ������
          lSqlstr:= 'delete from drs_alarm_online a'+
                    ' where a.flowtache=3';
          ExecMySQL(FQueryFree,lSqlstr);
          //����MTU���ܱ�ɾ�����߸�MTU�����Ÿı��ˣ�ԭ�����ɵĸ澯��Ҫɾ��
          lSqlstr:= 'delete from drs_alarm_online a'+
                    ' where not exists (select 1 from (select d.id cityid,a.drsid from drs_info a'+
                                                      ' inner join area_info b on a.suburb=b.id and b.layer=3'+
                                                      ' inner join area_info c on b.top_id=c.id and c.layer=2'+
                                                      ' inner join area_info d on c.top_id=d.id and d.layer=1) b'+
                                       ' where a.cityid=b.cityid and a.drsid=b.drsid)';
          lMtuCauseRemoveAlarm:= ExecLocalSQL(FQueryFree,lSqlstr);
          if lMtuCauseRemoveAlarm>0 then
            FLog.Write('����DRS��ɾ������DRS�����Ÿı�,ͬ���Ƴ��澯��<'+inttostr(lMtuCauseRemoveAlarm)+'>',3);
          //����ֱ��վ�澯���ֶ�
          lSqlstr:= 'update drs_statuslist a set a.alarmcounts='+
                    '  (select count(1) from drs_alarm_online b'+
                    '  where a.drsid=b.drsid and b.flowtache=2)';
          ExecMySQL(FQueryFree,lSqlstr);
          //����ֱ��վ״̬"����"
          lSqlstr:= 'update drs_statuslist a set a.drsstatus=4,updatetime1=sysdate'+
                    ' where exists (select 1 from drs_alarm_online b where a.drsid=b.drsid and b.flowtache=2 and b.alarmcontentcode=18)';
          ExecMySQL(FQueryFree,lSqlstr);

          FConn.CommitTrans;
        except
          on e: Exception do
          begin
            FConn.RollbackTrans;
            FLog.Write(WD_THREADFUNCTION_NAME+'ִ��ʧ��'+#13+
                           ' ������ʾ��'+E.Message+#13+
                           ' ����SQL���=<'+lSqlstr+'>',2);
          end;
        end;
        //�澯�ɼ����ɾ��
        lSqlstr:= 'delete from drs_data_collect where isprocess='+inttostr(WD_TABLESTATUS_WAITFOR);
        ExecMySQL(FQueryFree,lSqlstr);
        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('����һ�λ���'+FormatDatetime('HH:MM:SS��',FCurrentDateTime-FCounterDatetime),3);
        if lRecordcount=0 then break;
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
