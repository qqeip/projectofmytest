{
    自动测试任务计划生成线程
    1、遍历任务循环列表 mtu_autotestcyc_config 查找 标记为0的执行此序最小的命令。
    2、将全部MTU的此命令生成入库。
    3、更新标识为 1
}
unit Ut_AutoTaskThread;

interface

uses
  Windows, Classes, Log, SysUtils,DateUtils, IniFiles,
  Forms,Ut_BaseThread,ADODB,DB,Variants;

type
  TAutoTaskThread = class(TMyThread)
  private
    { Private declarations }
    FAdoCon : TAdoConnection;
    FQuery,FQueryFree: TAdoQuery;
    Sp_Alarm_FlowNumber: TADOStoredProc;
  protected
    procedure DoExecute; override;
    function ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer;
    procedure ExecMySQL(TheQuery :TADOQUERY;sqlstr :String);
    function GetSysDateTime():TDateTime;  //得到数据库服务器时间
    function GetTaskId:integer;
  public
    constructor Create(ConnStr :String);
    destructor destroy; override;
  end;

implementation

constructor TAutoTaskThread.Create(ConnStr :String);
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

  Sp_Alarm_FlowNumber:= TADOStoredProc.Create(nil);
  with Sp_Alarm_FlowNumber do
  begin
     Close;
     Connection := FAdoCon;
     ProcedureName:='MTS_GET_FLOWNUMBER';
     Parameters.Clear;
     Parameters.CreateParameter('I_FLOWNAME',ftString,pdInput,100,null);
     Parameters.CreateParameter('I_SERIESNUM',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('O_FLOWVALUE',ftInteger,pdOutput,0,null);
     Prepared;
  end;
end;

destructor TAutoTaskThread.destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  Sp_Alarm_FlowNumber.Close;
  Sp_Alarm_FlowNumber.Free;
  FAdoCon.Close;
  FAdoCon.Free;
  inherited destroy;
end;

procedure TAutoTaskThread.DoExecute;
const
  UPDATESTR ='update mtu_autotestcyc_config set markid =0';
  SQLCOM ='select * from mtu_autotestcyc_config where markid = 0 order by orderid';
  SQLMTU ='select * from mtu_info_view';
  SQLTask ='insert into mtu_testtask_online (taskid, cityid, mtuid, comid, status,asktime,userid) values (%d, %d, %d, %d, 1, sysdate, -1)';
  SQLParam ='insert into mtu_testtaskparam_online select %d,paramid,paramvalue from mtu_autotestparam_config where comid=%d';
  SQLUPDATE ='update mtu_autotestcyc_config set markid =1 where comid= %d';
  //主叫号码
  SQLCALL =' update mtu_testtaskparam_online set paramvalue=''%s'' where taskid =%d and paramid=6 ';
  SQLCALLED=' update mtu_testtaskparam_online set paramvalue=''%s'' where taskid =%d and paramid=7 ';
  SQLMTUZJ =' update mtu_testtaskparam_online set paramvalue=''%s'' where taskid =%d and paramid=39';
var
  sqlstr :String;
  CurComId,TaskId :integer;
begin
  if not FAdoCon.Connected then
  try
    FAdoCon.Connected := true;
  Except
    self.Log.Write('Ut_AutoTaskThread-自动测试任务线程错误：连接数据库失败！',1);
    Exit;
  end;
  
  with FQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLCOM);
    Open;
    if IsEmpty then
    begin
      ExecMySQL(FQueryFree,UPDATESTR);
      Close;
      Exit;
    end
    else
    begin
      CurComId :=FieldByName('comid').AsInteger;
      Close;
    end;
  end;
  //FAdoCon.BeginTrans;
  try
    with FQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(SQLMTU);
      Open;
      First;
      while not Eof do
      begin
        TaskId := GetTaskId;
        if TaskId <> 0 then
        begin
          sqlstr :=Format(SQLTask,[TaskId,FieldByName('cityid').AsInteger,FieldByName('mtuid').AsInteger,CurComId]);
          ExecMySQL(FQueryFree,sqlstr);
          sqlstr :=Format(SQLParam,[TaskId,CurComId]);
          ExecMySQL(FQueryFree,sqlstr);
          case CurComId of
            1,2,3,7,129,132,133,137:
              begin
                //更新主叫号码
                sqlstr :=Format(SQLCALL,[FieldByName('call').AsString,TaskId]);
                ExecMySQL(FQueryFree,sqlstr);
                //更新被叫号码
                if not FieldByName('called').IsNull then
                begin
                  sqlstr :=Format(SQLCALLED,[FieldByName('called').AsString,TaskId]);
                  ExecMySQL(FQueryFree,sqlstr);
                end;
              end;
            37:  //主叫MTU
              begin
                sqlstr :=Format(SQLMTUZJ,[FieldByName('mtuno').AsString,TaskId]);
                ExecMySQL(FQueryFree,sqlstr);
              end;
          end;
        end;
        Next;
      end;
      Close;
    end;
    //写任务生成标识
    sqlstr := Format(SQLUPDATE,[CurComId]);
    ExecMySQL(FQueryFree,sqlstr);
    //FAdoCon.CommitTrans;
    self.Log.Write('Ut_AutoTaskThread-消息编号['+IntToStr(CurComId)+']的测试任务生成成功！',3);
  except
    On E:Exception do
    begin
      //FAdoCon.RollbackTrans;
      self.Log.Write('Ut_AutoTaskThread-自动测试任务生成失败：'+E.Message+sqlstr,1);
    end;
  end;
  FAdoCon.Connected := false;
end;

procedure TAutoTaskThread.ExecMySQL(TheQuery: TADOQUERY; sqlstr: String);
begin
  with TheQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add(sqlstr);
    ExecSQL;
    close;
  end;
end;

function TAutoTaskThread.GetSysDateTime: TDateTime;
begin
  with FQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add('select sysdate from dual');
    open;
    result:=fieldbyname('sysdate').asdatetime;
    close;
  end;
end;

function TAutoTaskThread.GetTaskId: integer;
begin
  result :=0;
  try
  with FQueryFree do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select mtu_taskid.nextval as taskid from dual ');
    Open;
    result := FieldBYName('taskid').AsInteger;
    Close;
  end;
  except
    Log.Write('获取任务号失败!',1);
  end;
end;

function TAutoTaskThread.ProduceFlowNumID(I_FLOWNAME: string;
  I_SERIESNUM: integer): Integer;
begin
  with Sp_Alarm_FlowNumber do
  begin
    close;
    Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //流水号命名
    Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //申请的连续流水号个数
    execproc;
    result:=Parameters.parambyname('O_FLOWVALUE').Value; //返回值为整型，过程只返回序列的第一个值，但下次返回值为：result+I_SERIESNUM
    close;
  end;
end;

end.
