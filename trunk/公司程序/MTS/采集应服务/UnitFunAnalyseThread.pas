unit UnitFunAnalyseThread;

interface
uses Classes,ADODB,DB,SysUtils,Ut_BaseThread, IdGlobal;

const WD_ThreadName = '性能分析线程';
type
  TFunAnalyseThread = class(TMyThread)
  private
    FConn :TAdoConnection;
    FQuery :TAdoQuery;
    FQuery_Dym: TAdoQuery;
  protected
    procedure DoExecute; override;
    function FunAnalyse_Pilot: integer;
    function SaveToResultBase(aComid: integer): boolean;
    function GetResult(aTaskid: integer): string;
  public
    constructor Create(ConStr:String);
    destructor Destroy; override;
  end;

implementation

uses Ut_Global, Ut_MtuInfo;

{ TMosParseThread }

constructor TFunAnalyseThread.Create(ConStr: String);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := false;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection :=FConn;
  FQuery_Dym:= TAdoQuery.Create(nil);
  FQuery_Dym.Connection :=FConn;
end;

destructor TFunAnalyseThread.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQuery_Dym.Close;
  FQuery_Dym.Free;

  FConn.Close;
  FConn.Free;
  inherited;
end;

procedure TFunAnalyseThread.DoExecute;
var
  lFlag: integer;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write(WD_ThreadName+'异常: 无法连接数据库',1);
    Exit;
  end;

  try
    lFlag:= FunAnalyse_Pilot;
    if lFlag=1 then
      FLog.Write(WD_ThreadName+'异常: 导频污染分析失败',1);

  finally
    FConn.Connected:= false;
  end;
end;

function TFunAnalyseThread.FunAnalyse_Pilot: integer;
begin
  try
    with FQuery do
    begin
      close;
      sql.Text:= '{call funanalyse_pilot(:isucceed)}';
      Parameters.ParamByName('isucceed').DataType:= ftInteger;
      Parameters.ParamByName('isucceed').Direction:=pdOutput;
      ExecSQL;
      result:= Parameters.ParamByName('isucceed').Value;
    end;
  except
    on E:Exception do
    begin
      FLog.Write(WD_ThreadName+'异常: 导频污染调用存储过程时失败',1);
      FLog.Write(WD_ThreadName+'异常: '+e.Message,1);
    end;
  end;
end;

function TFunAnalyseThread.GetResult(aTaskid: integer): string;
var
  lMtuLocalAnalyse: TMtuLocalAnalyse;
  lEnCode: TIdBytes;
  s: string;
  j: integer;
begin
  s:= '';
  lMtuLocalAnalyse:= TMtuLocalAnalyse.create(true);
  lMtuLocalAnalyse.TaskId:= aTaskid;
  lMtuLocalAnalyse.GetTestEnCode(lEnCode);
  for j := Low(lEnCode) to High(lEnCode) do
    s :=s+' '+Format('%-.2x',[lEnCode[j]]);
  result:= s;
  lMtuLocalAnalyse.Free;
end;

function TFunAnalyseThread.SaveToResultBase(aComid: integer): boolean;
begin
  with FQuery do
  begin
    close;
    Sql.Text:= 'select taskid,cityid from mtu_testresult_online'+
               ' where comid='+inttostr(aComid)+' and isprocess=-1'+
               ' group by taskid,cityid';
    open;
    first;
    while not eof do
    begin
      FQuery_Dym.Close;
      FQuery_Dym.SQL.Text:= 'insert into mtu_testresult_base'+
                            ' (baseid, testvalue, isprocess, cityid, taskid, status, receivedate, enddate)'+
                            ' values'+
                            ' (mtu_baseid.nextval, '''+GetResult(FieldbyName('taskid').AsInteger)+''', 0, '+FieldByName('cityid').AsString+', null, 0, sysdate, null)';
      FQuery_Dym.ExecSQL;
      FQuery_Dym.Close;
      FQuery_Dym.SQL.Text:= 'update mtu_testresult_online set isprocess=0'+
                            ' where taskid='+inttostr(FieldbyName('taskid').AsInteger)+
                            ' and cityid='+inttostr(FieldbyName('cityid').AsInteger);
      FQuery_Dym.ExecSQL;
      next;
    end;
  end;
end;

end.
