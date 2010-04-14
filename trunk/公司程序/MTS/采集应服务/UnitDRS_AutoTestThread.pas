unit UnitDRS_AutoTestThread;

interface

uses
  Classes,ADODB,DB,Ut_BaseThread, SysUtils;

const
  WD_THREADFUNCTION_NAME = '直放站轮询线程';

type
  TDRS_AutoTestThread = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FCurrDate: TDateTime;
    FConn: TAdoConnection;
    FQuery: TAdoQuery;
    FQueryFree: TAdoQuery;
  protected
    procedure DoExecute; override;
    function AddAutoTestCMD(aTestid,aFlowTaskid:integer):boolean;
    procedure AddAutoTestParam(aTestid,aFlowTaskid:integer);
  public
    constructor Create(ConStr:String);
    destructor Destroy; override;
  end;

implementation

uses Ut_Global, UnitThreadCommon;

{ TDRS_AutoTestThread }

function TDRS_AutoTestThread.AddAutoTestCMD(aTestid,
  aFlowTaskid: integer): boolean;
begin
  result:=false;
  with FQueryFree do
  begin
    close;
    sql.Text:='insert into drs_testtask_online'+
              ' (taskid, cityid, drsid, comid, status, testresult, asktime,'+
              ' sendtime, rectime, tasklevel, userid, modelid, isprocess)'+
              ' select '+inttostr(aFlowTaskid)+',b.cityid,a.drsid,a.comid,0,null,sysdate,'+
              ' null,null,3,-1,'+inttostr(aTestid)+',0'+
              ' from drs_autotest_cmd a'+
              ' inner join drs_info_view b on a.drsid=b.drsid'+
              ' where a.id='+inttostr(aTestid);
    if ExecSQL>0 then
      result:=true;
  end;
end;

procedure TDRS_AutoTestThread.AddAutoTestParam(aTestid, aFlowTaskid: integer);
begin
  with FQueryFree do
  begin
    close;
    sql.Text:= 'insert into drs_testparam_online'+
               ' (taskid, paramid, paramvalue)'+
               ' select '+inttostr(aFlowTaskid)+',paramid,paramvalue'+
               ' from drs_autotest_param a where a.id='+inttostr(aTestid);
    ExecSQL;
  end;
end;

constructor TDRS_AutoTestThread.Create(ConStr: String);
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

destructor TDRS_AutoTestThread.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;
  inherited destroy;
end;

procedure TDRS_AutoTestThread.DoExecute;
var
  lSqlstr: string;
  lRecordcount: integer;
  ltaskid, lTestGroupid: integer;
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
    FConn.BeginTrans;
    try
        FCounterDatetime:= GetSysDateTime(FQueryFree);
        FCurrDate:=FCounterDatetime;
        //直放站删除，删除轮询任务
        lSqlstr:= 'delete from drs_autotest_cmd a'+
                  ' where not exists (select 1 from drs_info b'+
                                     ' where a.drsid=b.drsid)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from drs_autotest_param a'+
                  ' where not exists (select 1 from drs_autotest_cmd b where a.id=b.id)';
        ExecMySQL(FQueryFree,lSqlstr);
        //更新将要发送的测试计划
        lSqlstr:= 'update drs_autotest_cmd a set operstatus=1'+
                       //间隔到了
                       ' where sysdate-asktime>nvl(time_interval,0)/24/60'+
                       //次数未到
                       ' and (cyccounts>curr_cyccount or cyccounts=0)'+
                       //不暂停
                       ' and nvl(IFPAUSE,0)=0'+
                       //已有任务
                       ' and not exists (select 1 from drs_testtask_online b where a.drsid=b.drsid and a.comid=b.comid)'+
                       ' and ((BEGINTIME is null and ENDTIME is null and PLANDATE is null)'+
                              ' or exists (select 1 from dual'+
                                          //时间段
                                          ' where   to_date(to_char(sysdate,''hh24:mi:ss''),''hh24:mi:ss'')'+
                                          ' between to_date(to_char(BEGINTIME,''hh24:mi:ss''),''hh24:mi:ss'')'+
                                          ' and     to_date(to_char(ENDTIME,''hh24:mi:ss''),''hh24:mi:ss'')'+
                                          //周日期
//                                          ' and (select instr(PLANDATE,(select to_char(sysdate-1,''d'') from dual),1,1) from dual)>0'+
                              '))';
        ExecMySQL(FQueryFree,lSqlstr);
        with FQuery do
        begin
          close;
          lSqlstr:= 'select * from drs_autotest_cmd where operstatus=1';
          sql.Text:= lSqlstr;
          open;
          //当前记录数
          lRecordcount:= recordcount;
          first;
          while not eof do
          begin
            lTestGroupid:=Fieldbyname('id').AsInteger;
            ltaskid:=GetSequence(FQueryFree,'mtu_taskid');
            if ltaskid>0 then
            begin
              if AddAutoTestCMD(lTestGroupid,ltaskid) then
                AddAutoTestParam(lTestGroupid,ltaskid)
              else
                raise exception.Create('轮询执行失败,ID<'+INTTOSTR(lTestGroupid)+'>');
            end;
            Next;
          end;
        end;
        //更新被操作数据的操作时间和操作次数
        lSqlstr:= 'update drs_autotest_cmd set asktime='+
                  ' to_date('''+FormatDateTime('yyyy-mm-dd hh:mm:ss',FCurrDate)+''',''yyyy-mm-dd hh24:mi:ss''),'+
                  ' curr_cyccount=curr_cyccount+1'+
                  ' where operstatus=1';
        ExecMySQL(FQueryFree,lSqlstr);

        FConn.CommitTrans;
        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('轮询执行'+INTTOSTR(lRecordcount)+'条任务花费'+FormatDatetime('HH:MM:SS秒',FCurrentDateTime-FCounterDatetime),3);
    except
      on e :Exception do
      begin
        FConn.RollbackTrans;
        FLog.Write(WD_THREADFUNCTION_NAME+'执行失败'+#13+
                           ' 错误提示：'+E.Message+#13+
                           ' 错误SQL语句=<'+lSqlstr+'>',2);
      end;
    end;
  finally
    //还原状态
    lSqlstr:= 'update drs_autotest_cmd set operstatus=0 where operstatus=1';
    ExecMySQL(FQueryFree,lSqlstr);

    FConn.Connected := false;
  end;
end;

end.
