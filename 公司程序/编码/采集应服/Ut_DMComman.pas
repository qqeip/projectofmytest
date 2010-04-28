unit Ut_DMComman;

interface

uses
  SysUtils, Classes, AdoDB, Comobj, Strutils, uConnectionPool, uADOConnectionPool,
  DB, Untexecutesql, Untopensql, Variants;

type
  Tdm_comman = class(TDataModule)
  private
    AOpenSQL:TOpenSQL;
    AExecSQL:TExecSQL;
    function GetnewCName:String;
    function f_Replace(Input,s1,s2:string): string;
    function vartosql(value: Variant): String;
    { Private declarations }
  public
    function ExecSql(CurrConn: TAdoConnection; CmdStr: WideString): WordBool;
    function GetNewAdoquery(TheAdoConn:TADOConnection):Tadoquery;
    procedure FreeExistAdoquery(Q:Tadoquery);

    { Public declarations }
  end;

var
  dm_comman: Tdm_comman;

implementation

uses Ut_Main_Build;

{$R *.dfm}
function Tdm_comman.GetnewCName:String;
var
  AGuid:TGuid;
  NewValue:String;
begin
  OleCheck(CreateGuid(AGuid));
  NewValue:=GuidToString(Aguid);
  NewValue:=f_Replace(NewValue,'-','_');
  Result:='C'+Copy(NewValue,2,Length(NewValue)-2);
end;

function Tdm_comman.f_Replace(Input,s1,s2:string): string;
Begin
   Result:='';
   while Pos(s1,Input) > 0 do
   begin
      Result:= Result+LeftStr(Input,pos(s1,Input)-1)+s2;
      Input:=RightStr(Input,length(Input)-Pos(s1,Input)-length(s1)+1);
   end;
   Result:=Result+Input;
end;

function Tdm_comman.GetNewAdoquery(TheAdoConn:TADOConnection):Tadoquery;
var
  Q:Tadoquery;
begin
   Q:=Tadoquery.Create(nil);
   Q.Name:=GetnewCName;
   Q.Connection:=TheAdoConn;
   Q.CacheSize:=1000;
   Q.CursorType:=ctStatic;
   Q.LockType:=ltBatchOptimistic;
   Result:=Q;
end;

procedure Tdm_comman.FreeExistAdoquery(Q:Tadoquery);
begin
  Q.Close;
  Q.SQL.Clear;
  Q.Free;
end;

function Tdm_comman.vartosql(value: Variant): String;
begin
  if varisnull(Value) then
    Result:='NULL'
    else
    case Vartype(value) of
      varDate:
        Result:=Quotedstr(Datetimetostr(VartoDatetime(Value)));
      varString,varOlestr:
        Result:=Quotedstr(Trim(Vartostr(Value)));
      varboolean:
        begin
          if Value then
            Result:='1'
            else
            Result:='0';
        end;
      else
        Result:=Quotedstr(Trim(Vartostr(Value)));
      end;
end;

function Tdm_comman.ExecSql(CurrConn: TAdoConnection; CmdStr: WideString): WordBool;
var
  AdoQ:Tadoquery;
begin
  try
    AdoQ:=GetNewAdoquery(CurrConn);
    try
      AExecSQL:=TExecSQL.Create(AdoQ,CmdStr);
      AExecSQL.Execute;
      Result:=True;
    except
      Result:=False;
    end;
  finally
    FreeExistAdoquery(AdoQ);
    AExecSQL.Free;
  end;
end;

end.
