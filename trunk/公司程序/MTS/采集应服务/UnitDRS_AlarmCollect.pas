unit UnitDRS_AlarmCollect;

interface

uses
  Classes,ADODB,DB,Ut_BaseThread, SysUtils;

const
  WD_THREADFUNCTION_NAME = 'ֱ��վ�澯�ɼ��߳�';

type
  TDRS_AlarmCollectThread = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn: TAdoConnection;
    FQuery: TAdoQuery;
    FQueryFree: TAdoQuery;

    function JudgeIsAlarm(ParamValue,AlarmValue,RemoveValue:String):integer;

  protected
    procedure DoExecute; override;
  public
    constructor Create(ConStr:String);
    destructor Destroy; override;
  end;

implementation

uses Ut_Global, UnitThreadCommon;

{ TDRS_AlarmCollectThread }

constructor TDRS_AlarmCollectThread.Create(ConStr: String);
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

destructor TDRS_AlarmCollectThread.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;
  inherited destroy;
end;

procedure TDRS_AlarmCollectThread.DoExecute;
var
  lRecordcount: integer;
  lSqlstr: string;
  lCollectingFlag: integer;
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
        //ɾ������ֱ��վ��ϵ������Ҫ���շ��ؽ��
        //ֱ��վɾ����ֱ��վ����/ֱ��վδ�����������ʱ
        lSqlstr:= 'delete from drs_testresult_online a'+
                  ' where not exists (select 1 from drs_testtask_online b where a.taskid=b.taskid)'+
                  ' and (exists (select 1 from drs_statuslist c where a.drsid=c.drsid and (c.drsstatus=5 or c.drsstatus=1))'+
                        ' or exists (select 1 from drs_testtask_online d where a.taskid=d.taskid and d.status=4)'+
                        ')';
        ExecMySQL(FQueryFree,lSqlstr);
        //����ֱ��վ����״̬Ϊ������
        lSqlstr:= 'update drs_statuslist a'+
                  ' set a.drsstatus=2,updatetime1=sysdate'+
                  ' where exists (select 1 from drs_testresult_online b'+
                  '               where a.drsid=b.drsid)'+// and b.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+'
                  '        and not exists (select 1 from drs_alarm_online c'+
                  '               where a.drsid=c.drsid and c.flowtache=2)'+
                  '        and a.drsstatus=4';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'update drs_statuslist a'+
                  ' set a.drsstatus=3,updatetime1=sysdate'+
                  ' where exists (select 1 from drs_testresult_online b'+
                  '               where a.drsid=b.drsid)'+// and b.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+'
                  '        and exists (select 1 from drs_alarm_online c'+
                  '               where a.drsid=c.drsid and c.flowtache=2)'+
                  '        and a.drsstatus=4';
        ExecMySQL(FQueryFree,lSqlstr);
        //--------->һ������
        //���ݲ��Խ�����¡����ڴ�����������״̬���Ѵ���
        lSqlstr:= 'update drs_testtask_online a set status=2,rectime=sysdate,'+
                  ' isprocess='+inttostr(WD_TABLESTATUS_HASTREATED)+
                  ' where exists (select 1 from drs_testresult_online b'+
                                ' where a.cityid=b.cityid and a.taskid=b.taskid)'+
                  ' and a.isprocess='+inttostr(WD_TABLESTATUS_TREATING);
        ExecMySQL(FQueryFree,lSqlstr);
        //�в��Խ���Ĺ������߸澯��CLEAR�澯(2��ִ�гɹ� 3��ִ��ʧ��
        //֮���Լӡ�ִ��ʧ�ܡ�����������Ϊϵͳ����ʧ�ܻ��������������ʧ�ܣ�ϵ
        //ͳ����ʧ��û�в��Խ��������Ҫģ��CLEAR�澯)
        lSqlstr:= 'insert into drs_testresult_online'+
                  ' (taskid, cityid, drsid, comid, paramid, valueindex, testresult, collecttime, execid, isprocess)'+
                  ' select a.taskid,a.cityid,a.drsid,a.comid,1001,0,''0'',sysdate,0,'+inttostr(WD_TABLESTATUS_NORMAL)+
                  ' from drs_testtask_online a'+
                  ' where a.status=2 or (a.status=3'+
                                   ' and exists (select 1 from drs_testresult_online b'+
                                   ' where a.cityid=b.cityid and a.taskid=b.taskid))';
        ExecMySQL(FQueryFree,lSqlstr);
        //��������ʧ�ܵĴ���δ�յ����Խ��������ʱ��������N����ģ�����߸澯
        lSqlstr:= 'insert into drs_testresult_online'+
                  ' (taskid, cityid, drsid, comid, paramid, valueindex, testresult, collecttime, execid, isprocess)'+
                  ' select a.taskid,a.cityid,a.drsid,a.comid,1001,0,''1'',sysdate,0,'+inttostr(WD_TABLESTATUS_NORMAL)+
                  ' from drs_testtask_online a'+
                  ' where a.status=4';
        ExecMySQL(FQueryFree,lSqlstr);
        //���״̬��ȡʱ��(�����Ƿ񷵻ر����Ƿ���ȷ)
        lSqlstr:= 'update drs_statuslist a set a.updatetime2='+
                  ' (select max(b.collecttime) from drs_testresult_online b'+
                  ' where a.drsid=b.drsid group by b.drsid)'+
                  ' where exists (select 1 from drs_testresult_online c'+
                  ' where a.drsid=c.drsid)';
        ExecMySQL(FQueryFree,lSqlstr);
        //�������ʱ��(һ�������óɹ�)
        lSqlstr:= 'update drs_statuslist a set a.updatetime3='+
                  ' (select max(rectime) from drs_testtask_online b'+
                  ' where a.drsid=b.drsid and b.comid in (48,49,50,51,52,53,54,55) and b.status=2'+
                  ' group by b.drsid),'+
                  ' a.updatetime4= (select max(rectime) from drs_testtask_online b'+
                  ' where a.drsid=b.drsid and b.comid in (48,49,50,51,52,53,54,55) and b.status=2'+
                  ' group by b.drsid)'+
                  ' where exists (select 1 from drs_testtask_online c'+
                  ' where a.drsid=c.drsid and c.comid in (48,49,50,51,52,53,54,55) and c.status=2)';
        ExecMySQL(FQueryFree,lSqlstr);
        //���������Ÿ���drs_prepparam_set���ֶ�issuccess�Ƿ�ɹ�
        lSqlstr:= 'update drs_prepparam_set a set issuccess=1'+
                  ' where exists (select 1 from drs_testtask_online b'+
                                ' where a.taskid=b.taskid and b.status=2)'+
                  ' and a.issuccess=0';
        ExecMySQL(FQueryFree,lSqlstr);
        //��ѯ�ɹ�����
        lSqlstr:= 'update drs_autotest_cmd a'+
                  ' set a.succ_cyccount=nvl(a.succ_cyccount,0)+1'+
                  ' where exists (select 1 from drs_testtask_online b'+
                  '              where a.id=b.modelid and b.status=2)';
        ExecMySQL(FQueryFree,lSqlstr);
        //����ɹ�
        lSqlstr:= 'update drs_statuslist a set drsstatus=2,updatetime1=sysdate'+
                  ' where exists (select 1 from drs_testtask_online b'+
                                ' where a.drsid=b.drsid and b.status=2 and b.comid=32)';
        ExecMySQL(FQueryFree,lSqlstr);
        //���Ѵ����ֶ���������Ľ�����ֶ����Խ�����ṩ���ֶ���������鿴
        lSqlstr:= 'insert into drs_testresult_user'+
                  ' select * from drs_testresult_online a'+
                  ' where exists (select 1 from drs_testtask_online b'+
                              ' where a.cityid=b.cityid and a.taskid=b.taskid'+
                              ' and b.isprocess='+inttostr(WD_TABLESTATUS_HASTREATED)+' and b.userid<>-1)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into drs_testparam_user'+
                  '  select a.taskid,a.paramid,a.paramvalue'+
                  '  from drs_testparam_online a'+
                  '  where exists (select 1 from drs_testtask_online b'+
                  '                where a.taskid=b.taskid and b.isprocess='+inttostr(WD_TABLESTATUS_HASTREATED)+
                                   ' and b.userid<>-1)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into drs_testtask_user'+
                  ' select * from drs_testtask_online a'+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_HASTREATED)+' and a.userid<>-1';
        ExecMySQL(FQueryFree,lSqlstr);
        //ɾ�����Ѵ����Ĳ�������
        lSqlstr:= 'insert into drs_testparam_history'+
                  ' select * from drs_testparam_online a'+
                  ' where exists (select 1 from drs_testtask_online b'+
                  '                where a.taskid=b.taskid and b.isprocess='+inttostr(WD_TABLESTATUS_HASTREATED)+')';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from drs_testparam_online a'+
                  ' where exists (select 1 from drs_testtask_online b'+
                  '                where a.taskid=b.taskid and b.isprocess='+inttostr(WD_TABLESTATUS_HASTREATED)+')';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into drs_testtask_history'+
                  ' select * from drs_testtask_online a'+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_HASTREATED);
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from drs_testtask_online a'+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_HASTREATED);
        ExecMySQL(FQueryFree,lSqlstr);
        //<<���浽����ֱ��վ���Խ����
        lSqlstr:= 'delete from drs_testresult_recent a'+
                  ' where exists (select 1 from drs_testresult_online b'+
                  ' where a.drsid=b.drsid and a.comid=b.comid)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into drs_testresult_recent'+
                  ' select * from drs_testresult_online a'+
                  ' where rowid=(select max(b.rowid) from drs_testresult_online b'+
                  '              where a.cityid=b.cityid and a.drsid=b.drsid'+
                  '              and a.comid=b.comid and a.paramid=b.paramid)';
        ExecMySQL(FQueryFree,lSqlstr);
        //���浽����ֱ��վ���Խ����>>
        //���������Ҫ���淵�ؽ��ֵ����ǰ���ñ�
        lSqlstr:= 'delete from drs_paramsetup_local a'+
                  ' where exists (select 1 from drs_testresult_online b'+
                                ' where a.drsid=b.drsid and a.comid=b.comid'+
                                ' and a.comid=132)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into drs_paramsetup_local'+
                  ' (id, drsid, comid, paramid, paramvalue, updatetime)'+
                  ' select mts_normal.nextval,a.drsid,a.comid,a.paramid,a.testresult,sysdate'+
                  ' from drs_testresult_online a'+
                  ' where not exists (select 1 from drs_paramsetup_local b'+
                                 ' where a.drsid=b.drsid and a.comid=b.comid)'+
                         ' and a.comid=132';
        ExecMySQL(FQueryFree,lSqlstr);
        //ȡ���µ�ֱ��վ������0X31��0X32��0X33��0X34��0X35��0X36�� ��ʱ����������������
        lSqlstr:= 'delete from drs_paramsetup_local a'+
                  ' where exists (select 1 from drs_prepparam_set b'+
                                ' where a.drsid=b.drsid and a.comid=b.comid and b.issuccess=1'+
                                ' and a.updatetime<b.createtime)'; // and b.comid in (49,50,51,52,53,54)
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into drs_paramsetup_local'+
                  ' (id, drsid, comid, paramid, paramvalue, updatetime)'+
                  ' select mts_normal.nextval,a.drsid,a.comid,a.paramid,a.paramvalue,sysdate'+
                  ' from drs_prepparam_set a'+
                  ' where not exists (select 1 from drs_paramsetup_local b'+
                  '                   where a.drsid=b.drsid and a.comid=b.comid)'+
                  ' and a.issuccess=1';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from drs_paramsetup_remote a'+
                  ' where exists (select 1 from drs_prepparam_set b'+
                                ' where a.drsid=b.drsid and a.comid=b.comid and b.issuccess=1'+
                                ' and a.updatetime<b.createtime)'; // and b.comid in (49,50,51,52,53,54)
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into drs_paramsetup_remote'+
                  ' (id, drsid, comid, paramid, paramvalue, updatetime)'+
                  ' select mts_normal.nextval,a.drsid,a.comid,a.paramid,a.paramvalue,sysdate'+
                  ' from drs_prepparam_set a'+
                  ' where not exists (select 1 from drs_paramsetup_local b'+
                  '                   where a.drsid=b.drsid and a.comid=b.comid)'+
                  ' and a.issuccess=1';
        ExecMySQL(FQueryFree,lSqlstr);
        //<---------
        //����ǰN����¼���ȴ�ִ��
        lSqlstr:= 'update drs_testresult_online a set a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+
                  ' and a.taskid<=(select min(taskid)+500 from drs_testresult_online)';
        ExecMySQL(FQueryFree,lSqlstr);

        with FQuery do
        begin
          close;
          lSqlstr:= 'select a.cityid,a.taskid,a.drsid,a.comid,a.paramid,a.testresult,'+
                    'a.valueindex,a.isprocess,a.collecttime,a.execid,'+
                    ' b.alarmcontentcode,b.alarmcondition,b.removecondition,b.alarmcount,b.removecount'+
                    ' from drs_testresult_online a'+
                    ' inner join drs_alarm_content b'+
                    ' on (a.comid=b.comid or a.paramid=1001) and a.paramid=b.paramid and b.ifineffect=1'+
                    ' where a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR);
          sql.Text := lSqlstr;
          open;
          //��ǰ��¼��
          lRecordcount:= recordcount;
          first;
          while not eof do
          begin
            try
              if (Trim(FieldByName('ALARMCONDITION').AsString)='') or (Trim(FieldByName('REMOVECONDITION').AsString)='') then
                lCollectingFlag:= 0
              else
                lCollectingFlag:= JudgeIsAlarm(FieldByName('testresult').AsString,
                                   FieldByName('ALARMCONDITION').AsString,FieldByName('REMOVECONDITION').AsString);
              //��collect��
              lSqlstr:= 'insert into drs_data_collect'+
                        ' (collectid, alarmcontentcode, cityid, taskid, execid,'+
                        ' drsid, comid, paramid, isalarm, collecttime, isprocess) values'+
                        ' (mtu_collectid.nextval,'+FieldByName('ALARMCONTENTCODE').AsString+','+
                        FieldByName('CITYID').AsString+','+FieldByName('TASKID').AsString+',0,'+
                        FieldByName('DRSID').AsString+','+FieldByName('COMID').AsString+','+
                        FieldByName('PARAMID').AsString+','+inttostr(lCollectingFlag)+',sysdate,0 )';
              ExecMySQL(FQueryFree,lSqlstr);
                        //>>>>>>>>>>>>>>>>>
                        //(ʵ�ֹ��ܣ������澯��������β��Խ��)
                        if lCollectingFlag=1 then
                        begin
                          lSqlstr:= 'insert into drs_alarmresult'+
                                    ' (id, alarmid, taskid, drsid, cityid, comid, paramid, valueindex, testresult, collecttime, execid, isprocess, alarmcontentcode)'+
                                    ' values'+
                                    ' (mts_normal.nextval, null, '+FieldByName('TASKID').AsString+', '+
                                    FieldByName('DRSID').AsString+', '+FieldByName('CITYID').AsString+', '+
                                    FieldByName('COMID').AsString+', '+FieldByName('PARAMID').AsString+','+FieldByName('VALUEINDEX').AsString+', '''+
                                    FieldByName('TESTRESULT').AsString+''', to_date('''+FieldByName('COLLECTTIME').AsString+''',''yyyy-mm-dd hh24:mi:ss'') , '+
                                    FieldByName('EXECID').AsString+', 3, '+FieldByName('ALARMCONTENTCODE').AsString+')';
                          ExecMySQL(FQueryFree,lSqlstr);
                        end;
                        //<<<<<<<<<<<<<<<<<<<<
            except
              on e: Exception do
              begin
                //����ʧ�ܱ�ʶ
                ExecMySQL(FQueryFree,'update drs_testresult_online t'+
                                     ' set t.isprocess='+inttostr(WD_TABLESTATUS_EXCEPTION)+
                                     ' where t.taskid='+FieldByName('TASKID').AsString);
                FLog.Write(WD_THREADFUNCTION_NAME+'ִ��ʧ��'+#13+
                           ' ������ʾ��'+E.Message+#13+
                           ' TASKID=<'+FieldByname('TASKID').AsString+'>'+#13+
                           ' COMID=<'+FieldByname('COMID').AsString+'>'+#13+
                           ' PARAMID=<'+FieldByname('PARAMID').AsString+'>',2);
              end;
            end;
            //Sleep(30);   //������֤������Ҫ30mS
            next;
          end;
        end;
        //����ʷ��
        lSqlstr:= 'insert into drs_testresult_history'+
                  ' select * from drs_testresult_online a'+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' or a.isprocess='+inttostr(WD_TABLESTATUS_EXCEPTION);
        ExecMySQL(FQueryFree,lSqlstr);
        //ɾ�����߱�
        lSqlstr:= 'delete from drs_testresult_online a'+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' or a.isprocess='+inttostr(WD_TABLESTATUS_EXCEPTION);
        ExecMySQL(FQueryFree,lSqlstr);
        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('�澯�ɼ��ж�'+inttostr(lRecordcount)+'���������'+FormatDatetime('HH:MM:SS��',FCurrentDateTime-FCounterDatetime),3);
        if lRecordcount=0 then break;
        //�ֶ��˳�
        if self.IsStop then
          break;
      end;
    except
//      FLog.Write(WD_THREADFUNCTION_NAME+'   ִ��ʧ��',2);
//      FLog.Write(WD_THREADFUNCTION_NAME+'   ִ��ʧ��'+lSqlstr,2);
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

function TDRS_AlarmCollectThread.JudgeIsAlarm(ParamValue, AlarmValue,
  RemoveValue: String): integer;
var
  lSqlstr :string;
begin
  try
    result :=0;
    lSqlstr :='select 1 from dual where ';
    AlarmValue :=StringReplace(AlarmValue, '@Value',ParamValue, [rfReplaceAll, rfIgnoreCase]);
    RemoveValue :=StringReplace(RemoveValue, '@Value',ParamValue, [rfReplaceAll, rfIgnoreCase]);
    with FQueryFree do
    begin
      Close;
      SQL.Clear;
      SQL.Add(lSqlstr+AlarmValue);
      Open;
      if IsEmpty then
      begin
        Close;
        SQL.Clear;
        SQL.Add(lSqlstr+RemoveValue);
        Open;
        if not IsEmpty then
          result :=0;
      end
      else
        result :=1;
      Close;
    end;
  except
    on e: exception do
    begin
      FLog.Write(lSqlstr+AlarmValue,1);
      FLog.Write(lSqlstr+RemoveValue,1);
    end;
  end;
end;

end.
