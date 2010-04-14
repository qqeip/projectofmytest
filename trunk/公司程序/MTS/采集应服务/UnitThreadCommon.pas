unit UnitThreadCommon;

interface
uses ADODB, IdGlobal, SysUtils, Classes;

const
  WD_TABLESTATUS_BEYOND = -1;      //数据未准备好（初始化之前）
  WD_TABLESTATUS_NORMAL = 0;       //初始化
  WD_TABLESTATUS_WAITFOR = 1;      //等待处理
  WD_TABLESTATUS_TREATING = 2;     //正处理
  WD_TABLESTATUS_HASTREATED = 3;   //已处理
  WD_TABLESTATUS_EXCEPTION = -99;  //异常

  WD_OUTTIME_SET= 3;               //超时时间(分钟)


  procedure ExecMySQL(FMyQuery :TAdoQuery;sqlstr:String);
  procedure OpenDataSet(aAdoQuery: TAdoQuery; asqlstr: string);
  function GetSequence(FMyQuery :TAdoQuery; aSeqName: string): integer;
  function GetSysDateTime(FMyQuery :TAdoQuery):TDateTime;  //得到数据库服务器时间
  function StrToIdBytes(sValue :String): TIdBytes;
  function GetDRSCall(FMyQuery :TAdoQuery; aDrsid: integer): string;        //获取直放站号码  测试阶段用 以后废弃

implementation

function GetDRSCall(FMyQuery :TAdoQuery; aDrsid: integer): string;
begin
  with FMyQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add('select t.drsphone from drs_info t where t.drsid='+inttostr(aDrsid));
    open;
    result:=fieldbyname('drsphone').AsString;
    close;
  end;
end;

function StrToIdBytes(sValue :String): TIdBytes;
var
  i : integer;
  Msg :String;
begin
  Msg := StringReplace(sValue,' ','',[rfReplaceAll]);
  if Msg<>'' then
  begin
    SetLength(Result,Length(Msg) div 2);
    for I := 0 to Length(Msg) div 2-1 do
      Result[i] :=StrToInt('$'+Copy(Msg,i*2+1,2));
  end;
end;

procedure OpenDataSet(aAdoQuery: TAdoQuery; asqlstr: string);
begin
  with aAdoQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(asqlstr);
    Open;
  end;
end;

function GetSysDateTime(FMyQuery :TAdoQuery):TDateTime;  //得到数据库服务器时间
begin
  with FMyQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add('select sysdate from dual');
    open;
    result:=fieldbyname('sysdate').asdatetime;
    close;
  end;
end;

function GetSequence(FMyQuery :TAdoQuery; aSeqName: string): integer;
begin
  with FMyQuery do
  begin
    close;
    sql.Text:= 'select '+aSeqName+'.nextval as seq from dual';
    open;
    result := Fieldbyname('seq').AsInteger;
  end;
end;

Procedure ExecMySQL(FMyQuery :TAdoQuery;sqlstr:String);
begin
  with FMyQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    ExecSQL;
    Close;
  end;
end;

end.
