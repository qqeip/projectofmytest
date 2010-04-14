{MTU告警采集线程}
unit UnitAlarmCollect;

interface
  uses Windows, Classes, Log, Ut_BaseThread, ADODB, SysUtils, Variants;

const
  WD_THREADFUNCTION_NAME = '告警采集线程';

type

  TAlarmCollect = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn: TAdoConnection;
    FQuery, FQueryFree: TAdoQuery;
    FIfResend: boolean;

    function JudgeIsAlarm(ParamValue,AlarmValue,RemoveValue:String):integer;
  protected
    procedure DoExecute; override;
  public
    constructor Create(ConnStr :String);
    destructor Destroy; override;
  end;
implementation

uses Ut_Global, UnitThreadCommon;
{ TAlarmCollect }

constructor TAlarmCollect.Create(ConnStr: String);
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
end;

destructor TAlarmCollect.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;
  inherited destroy;
end;

procedure TAlarmCollect.DoExecute;
var
  lSqlstr: string;
  lCollectingFlag: integer;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write(WD_THREADFUNCTION_NAME+'无法连接数据库!',1);
    Exit;
  end;
//  //加载告警内容  (不采用告警内容进驻内存)
//  FLog.Write(WD_THREADFUNCTION_NAME+'加载告警内容...',3);
//  with FQueryAlarmContent do
//  begin
//    close;
//    sql.Text:='select * from mtu_alarmcontent_view where ifineffect=1';
//    open;
//  end;
  //是否再派
  with FQueryFree do
  begin
    close;
    sql.Text:='select t.setvalue ifresend from sys_param_config t where t.itemkind=2 and t.itemcode=1';
    open;
    if Fieldbyname('ifresend').AsInteger=1 then
      FIfResend:= true
    else
      FIfResend:= false;
  end;
  try
    while True do //无限循环
    begin
      //更新前N条记录，等待执行
      FCounterDatetime:= GetSysDateTime(FQueryFree);
      lSqlstr:= 'update mtu_testresult_online a set a.isprocess=1 where a.isprocess=0'+
                ' and a.taskid<=(select min(taskid)+500 from mtu_testresult_online where isprocess=0)';
      ExecMySQL(FQueryFree,lSqlstr);

      with FQuery do
      begin
        close;
        lSqlstr:= 'select a.*,b.alarmcontentcode,b.alarmcondition, b.removecondition, b.alarmcount, removecount'+
                  ' from MTU_TESTRESULT_ONLINE a'+
                  ' left join mtu_alarmcontent_view b'+
                  ' on a.mtuid=b.mtuid and a.comid=b.comid and a.paramid=b.paramid'+
                  ' where a.isprocess=1 and b.ifineffect=1';
        sql.Text := lSqlstr;
        open;
        first;
        while not eof do
        begin
          try
            if (Trim(FieldByName('ALARMCONDITION').AsString)='') or (Trim(FieldByName('REMOVECONDITION').AsString)='') then
              lCollectingFlag :=0
            else
              lCollectingFlag := JudgeIsAlarm(FieldByName('testresult').AsString,
                                 FieldByName('ALARMCONDITION').AsString,FieldByName('REMOVECONDITION').AsString);
            //进collect表
            lSqlstr:= 'insert into alarm_data_collect'+
                      ' (cityid, taskid, execid, mtuid, alarmcontentcode, status, collecttime, collectid, isprocess, comid, paramid)'+
                      ' values'+
                      '  ('+FieldByName('CITYID').AsString+','+
                      FieldByName('TASKID').AsString+', 0, '+
                      FieldByName('MTUID').AsString+','+
                      FieldByName('ALARMCONTENTCODE').AsString+', '+
                      inttostr(lCollectingFlag)+','+
                      ' sysdate, mtu_collectid.nextval, 0,'+
                      FieldByName('COMID').AsString+','+
                      FieldByName('PARAMID').AsString+')';
            ExecMySQL(FQueryFree,lSqlstr);
            //(实现功能：产生告警的最近几次测试结果)
            if lCollectingFlag=1 then
            begin
              lSqlstr:= 'insert into mtu_alarmresult'+
                        ' (id, alarmid, taskid, cityid, comid, paramid, valueindex, testresult, collecttime, execid, isprocess, mtuid, alarmcontentcode)'+
                        ' values'+
                        ' (mts_normal.nextval, null, '+FieldByName('TASKID').AsString+', '+
                        FieldByName('CITYID').AsString+', '+FieldByName('COMID').AsString+', '+
                        FieldByName('PARAMID').AsString+', '+FieldByName('VALUEINDEX').AsString+', '''+
                        FieldByName('TESTRESULT').AsString+''', to_date('''+FieldByName('COLLECTTIME').AsString+''',''yyyy-mm-dd hh24:mi:ss'') , '+
                        FieldByName('EXECID').AsString+', 0, '+FieldByName('MTUID').AsString+', '+FieldByName('ALARMCONTENTCODE').AsString+')';
              ExecMySQL(FQueryFree,lSqlstr);
            end;
          except
            on e: Exception do
            begin
              edit;
              Fieldbyname('ISPROCESS').AsInteger := 3;
              post;
              FLog.Write(WD_THREADFUNCTION_NAME+'错误提示：'+E.Message,1);
              FLog.Write(WD_THREADFUNCTION_NAME+'TASKID< '+FieldByname('TASKID').AsString+' >执行失败',1);
            end;  
          end;
          next;
        end;
        //进历史表
        lSqlstr:= 'insert into mtu_testresult_history'+
                  ' select * from mtu_testresult_online a where a.isprocess=1 or a.isprocess=3';
        ExecMySQL(FQueryFree,lSqlstr);
        //告警采集完后删除
        lSqlstr:= 'delete from mtu_testresult_online where isprocess=1 or isprocess=3';
        ExecMySQL(FQueryFree,lSqlstr);

        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('告警采集'+inttostr(FQuery.RecordCount)+'条花费'+FormatDatetime('HH:MM:SS秒',FCurrentDateTime-FCounterDatetime),3);
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

function TAlarmCollect.JudgeIsAlarm(ParamValue, AlarmValue,
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
