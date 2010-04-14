{  自动测试生成线程
   实现对自动测试列表的循环
}
unit UnitAutoTestListThread;

interface

uses
  Classes,Ut_BaseThread, Log, SysUtils, ADODB;

type
  AutoTestListThread = class(TMyThread)
  private
    FAdoCon : TAdoConnection;
    FQuery,FQueryFree: TAdoQuery;
    FCurrDate : TDateTime;

    procedure DoExecute; override;

    function AddAutoTestCMD(aTestid,aFlowTaskid:integer):boolean;
    procedure AddAutoTestParam(aTestid,aFlowTaskid:integer);

    procedure InitParam;
    function GetSysDateTime():TDateTime;//得到数据库服务器时间
  public
    constructor Create(ConnStr :String);
    destructor destroy; override;
  end;

implementation

uses UnitThreadCommon;

function AutoTestListThread.AddAutoTestCMD(aTestid,aFlowTaskid:integer):boolean;
begin
  result:=false;
  with FQueryFree do
  begin
    close;
    sql.Text:='insert into mtu_testtask_online'+
                 ' (taskid, cityid, mtuid, comid, status,asktime,userid,TASKLEVEL,MODELID)'+
                 ' select '+inttostr(aFlowTaskid)+',b.cityid,a.mtuid,a.comid,1,sysdate,-1,3,MODELID'+
                 ' from mtu_autotest_cmd a'+
                 ' inner join mtu_info_view b on a.mtuid=b.mtuid'+
                 ' where a.testgroupid='+inttostr(aTestid);
    if ExecSQL>0 then
      result:=true;
  end;
end;

procedure AutoTestListThread.AddAutoTestParam(aTestid,aFlowTaskid:integer);
begin
  with FQueryFree do
  begin
    close;
    sql.Text:='insert into mtu_testtaskparam_online'+
                 ' select '+inttostr(aFlowTaskid)+',paramid,paramvalue from mtu_autotest_param where testgroupid='+inttostr(aTestid)+'';
    ExecSQL;
  end;
end;

constructor AutoTestListThread.Create(ConnStr: String);
begin
  inherited create;

  FAdoCon := TAdoConnection.Create(nil);
  with FAdoCon do
  begin
    ConnectionString :=ConnStr;
    LoginPrompt := false;
//    KeepConnection := true;
  end;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FAdoCon;

  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection := FAdoCon;

  InitParam;
end;

destructor AutoTestListThread.destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FAdoCon.Close;
  FAdoCon.Free;
  inherited destroy;
end;

procedure AutoTestListThread.DoExecute;
const
  lMainSql='select * from mtu_autotest_cmd where operstatus=1';
  lBeginUpdateStatus = 'update mtu_autotest_cmd set operstatus=1'+
                       //间隔到了
                       ' where sysdate-asktime>nvl(time_interval,0)/24/60'+
                       //次数未到
                       ' and (cyccounts>curr_cyccount or cyccounts=0)'+
                       //不暂停
                       ' and nvl(IFPAUSE,0)=0'+
                       ' and ((BEGINTIME is null and ENDTIME is null and PLANDATE is null)'+
                              ' or exists (select 1 from dual'+
                                          //时间段
                                          ' where   to_date(to_char(sysdate,''hh24:mi:ss''),''hh24:mi:ss'')'+
                                          ' between to_date(to_char(BEGINTIME,''hh24:mi:ss''),''hh24:mi:ss'')'+
                                          ' and     to_date(to_char(ENDTIME,''hh24:mi:ss''),''hh24:mi:ss'')'+
                                          //周日期
                                          ' and (select instr(PLANDATE,(select to_char(sysdate-1,''d'') from dual),1,1) from dual)>0'+
                              '))';
  lEndUpdateStatus =   'update mtu_autotest_cmd set operstatus=0 where operstatus=1';
var
  lTestGroupid:integer;
  lFlowTaskId:integer;
  lSqlstr: string;
begin
  if not FAdoCon.Connected then
  try
    FAdoCon.Connected := true;
  except
    Log.Write('自动测试列表执行错误：连接数据库失败！',1);
    Exit;
  end;
  FCurrDate:=GetSysDateTime;
  //清除无MTU信息的先前配置的测试
  lSqlstr:= 'delete from mtu_autotest_cmd a'+
             ' where not exists (select 1 from mtu_info b where a.mtuid=b.mtuid)';
  ExecMySQL(FQueryFree,lSqlstr);
  lSqlstr:= 'delete from mtu_autotest_param a'+
            ' where not exists (select 1 from mtu_autotest_cmd b where a.testgroupid=b.testgroupid)';
  ExecMySQL(FQueryFree,lSqlstr);
  //更新将要发送的测试计划
  ExecMySQL(FQueryFree,lBeginUpdateStatus);
  With FQuery do
  begin
    try
      //启动事务
      FAdoCon.BeginTrans;
      try
        close;
        sql.Text:=lMainSql;
        open;
        First;
        while not eof do
        begin
          lTestGroupid:=Fieldbyname('TestGroupid').AsInteger;
          lFlowTaskId:=GetSequence(FQueryFree,'mtu_taskid');
          if lFlowTaskId>0 then
          begin
            if AddAutoTestCMD(lTestGroupid,lFlowTaskId) then
              AddAutoTestParam(lTestGroupid,lFlowTaskId)
            else
              Log.Write('自动测试列表执行失败,自动测试编号为'+inttostr(lTestGroupid)+'未插入数据',1);
          end;
          Next;
        end;
        //更新被操作数据的操作时间和操作次数
        lSqlstr:= 'update mtu_autotest_cmd set asktime='+
                  ' to_date('''+FormatDateTime('yyyy-mm-dd hh:mm:ss',FCurrDate)+''',''yyyy-mm-dd hh24:mi:ss''),'+
                  ' curr_cyccount=curr_cyccount+1'+
                  ' where operstatus=1';
        ExecMySQL(FQueryFree,lSqlstr);
        FAdoCon.CommitTrans;
      except
        on e :Exception do
        begin
          FAdoCon.RollbackTrans;
          Log.Write('自动测试列表执行失败,自动测试编号为'+inttostr(lTestGroupid),1);
          Log.Write(E.Message,1);
        end;
      end;
    finally
      //还原状态
      ExecMySQL(FQueryFree,lEndUpdateStatus);
    end;
  end;
  FAdoCon.Connected := false;
end;

function AutoTestListThread.GetSysDateTime: TDateTime;
begin
  with FQueryFree do
  begin
    close;
    SQL.Clear;
    SQL.Add('select sysdate from dual');
    open;
    result:=fieldbyname('sysdate').asdatetime;
    close;
  end;
end;

procedure AutoTestListThread.InitParam;
begin
  with FQueryFree do
  begin
    Close;
    sql.Text:='update mtu_autotest_cmd set curr_cyccount=0';
    ExecSql;
  end;
end;

end.
