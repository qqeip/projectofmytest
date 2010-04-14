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

    procedure UpdateAskTime(aTestid:integer);
    procedure AddTestCount(aTestid:integer);
    function AddAutoTestCMD(aTestid,aFlowTaskid:integer):boolean;
    procedure AddAutoTestParam(aTestid,aFlowTaskid:integer);

    function GetTaskId:integer;
    function GetSysDateTime():TDateTime;//得到数据库服务器时间
  public
    constructor Create(ConnStr :String);
    destructor destroy; override;
  end;

implementation

function AutoTestListThread.AddAutoTestCMD(aTestid,aFlowTaskid:integer):boolean;
begin
  result:=false;
  with FQueryFree do
  begin
    close;
    sql.Text:='insert into mtu_testtask_online'+
                 ' (taskid, cityid, mtuid, comid, status,asktime,userid)'+
                 ' values (select '+inttostr(aFlowTaskid)+',b.cityid,a.mtuid,a.comid,1,sysdate,-1'+
                 ' from mtu_autotest_cmd a'+
                 ' left join mtu_info_view b on a.mtuid=b.mtuid'+
                 ' where a.testgroupid='+inttostr(aTestid)+')';
    try
      ExecSQL;
    except
    end;
    close;
    sql.Text:='select * from mtu_testtask_online where testgroupid='+inttostr(aTestid)+'';
    open;
    if recordcount>0 then
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

procedure AutoTestListThread.AddTestCount(aTestid: integer);
begin
  with FQueryFree do
  begin
    close;
    sql.Text:='select * from mtu_autotest_cmd where testgroupid='+inttostr(aTestid)+'';
    open;
    if recordcount>0 then
    begin
      Edit;
      Fieldbyname('curr_cyccount').AsInteger:=Fieldbyname('curr_cyccount').AsInteger+1;
      Post;
    end;
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
    KeepConnection := true;
  end;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FAdoCon;

  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection := FAdoCon;
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
  lMainSql='select * from mtu_autotest_cmd a'+
            ' where sysdate-a.asktime>a.time_interval/24/60'+
            ' and (a.cyccounts>a.curr_cyccount or a.cyccounts=0)'+
            ' order by a.testgroupid';
var
  lTestGroupid:integer;
  lFlowTaskId:integer;
begin
  try
    FCurrDate:=GetSysDateTime;
  except
    Exit;
  end;
  With FQuery do
  begin
    close;
    sql.Text:=lMainSql;
    open;
    if recordcount=0 then Exit;
    First;
    while not eof do
    begin
      lTestGroupid:=Fieldbyname('TestGroupid').AsInteger;
      UpdateAskTime(lTestGroupid);
      AddTestCount(lTestGroupid);
      lFlowTaskId:=self.GetTaskId;
      if lFlowTaskId>0 then
      begin
        if AddAutoTestCMD(lTestGroupid,lFlowTaskId) then
          AddAutoTestParam(lTestGroupid,lFlowTaskId);
      end;
      Next;
    end;
  end;
end;

procedure AutoTestListThread.UpdateAskTime(aTestid:integer);
begin
  with FQueryFree do
  begin
    close;
    sql.Text:='update mtu_autotest_cmd set asktime='+
                 ' to_date('''+FormatDateTime('yyyy-mm-dd hh:mm:ss',FCurrDate)+''',''yyyy-mm-dd hh24:mi:ss'')'+
                 ' where testgroupid='+inttostr(aTestid);
    ExecSql;
  end;
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

function AutoTestListThread.GetTaskId: integer;
begin
  result :=0;
  with FQueryFree do
  begin
    Close;
    sql.Text:='select mtu_taskid.nextval as taskid from dual';
    Open;
    result := FieldBYName('taskid').AsInteger;
  end;
end;

end.
