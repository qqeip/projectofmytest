unit UnitComponentFactory;

interface

uses
  SysUtils, Classes, AdoDB, Comobj, Strutils, uConnectionPool, uADOConnectionPool,
  DB, Variants;

  function GetnewCName:String;
  function f_Replace(Input,s1,s2:string): string;

  function GetNewAdoquery(TheAdoConn:TADOConnection):Tadoquery;
  procedure FreeExistAdoquery(Q:Tadoquery);

  function GetNewAdoProc(TheAdoConn:TADOConnection):TADOStoredProc;
  procedure FreeExistAdoProc(Q:TADOStoredProc);
  
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

function GetNewAdoProc(TheAdoConn:TADOConnection):TADOStoredProc;
var
  Q:TADOStoredProc;
begin
  Q:=TADOStoredProc.Create(nil);
  Q.Name:=GetnewCName;
  Q.Connection:=TheAdoConn;
  Result:=Q;
end;

procedure FreeExistAdoquery(Q:Tadoquery);
begin
  Q.Close;
  Q.SQL.Clear;
  Q.Free;
end;

procedure FreeExistAdoProc(Q:TADOStoredProc);
begin
  Q.Close;
  Q.Free;
end;

end.
