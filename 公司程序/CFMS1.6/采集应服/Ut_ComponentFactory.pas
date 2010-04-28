unit Ut_ComponentFactory;

interface

uses
  SysUtils, Classes, AdoDB, Comobj, Strutils, uConnectionPool, uADOConnectionPool,
  DB, Untexecutesql, Untopensql, Variants;
  
var
  AOpenSQL:TOpenSQL;
  AExecSQL:TExecSQL;

  function GetnewCName:String;
  function f_Replace(Input,s1,s2:string): string;
  function vartosql(value: Variant): String;

  function ExecTheSql(CurrConn: TAdoConnection; CmdStr: WideString): WordBool;
  function GetNewAdoquery(TheAdoConn:TADOConnection):Tadoquery;
  procedure FreeExistAdoquery(Q:Tadoquery);

implementation

function GetnewCName:String;
var
  AGuid:TGuid;
  NewValue:String;
begin
  OleCheck(CreateGuid(AGuid));
  NewValue:=GuidToString(Aguid);
  NewValue:=f_Replace(NewValue,'-','_');
  Result:='C'+Copy(NewValue,2,Length(NewValue)-2);
end;

function f_Replace(Input,s1,s2:string): string;
Begin
   Result:='';
   while Pos(s1,Input) > 0 do
   begin
      Result:= Result+LeftStr(Input,pos(s1,Input)-1)+s2;
      Input:=RightStr(Input,length(Input)-Pos(s1,Input)-length(s1)+1);
   end;
   Result:=Result+Input;
end;

function GetNewAdoquery(TheAdoConn:TADOConnection):Tadoquery;
var
  Q:Tadoquery;
begin
   Q:=Tadoquery.Create(nil);
   Q.Name:=GetnewCName;
   Q.Connection:=TheAdoConn;
   Q.CacheSize:=1;//1000;
   Q.CursorType:=ctStatic;
   Q.LockType:=ltOptimistic;
   Result:=Q;
end;

procedure FreeExistAdoquery(Q:Tadoquery);
begin
  Q.Close;
  Q.SQL.Clear;
  Q.Free;
end;

function vartosql(value: Variant): String;
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

function ExecTheSql(CurrConn: TAdoConnection; CmdStr: WideString): WordBool;
var
  AdoQ:Tadoquery;
begin
  AdoQ:=GetNewAdoquery(CurrConn);
  try
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
