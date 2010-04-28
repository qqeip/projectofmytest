unit untExecutesql;

interface

uses
    sysUtils, ADODB, Windows;

type
  TexecsqlEvent=procedure(sender:Tobject;Qty:Tadoquery) of object;
type
  Texecsql=class
  private
    Fadoquery:Tadoquery;
    Fsql:String;
    FexecsqlException:Exception;
    FexecsqlEvent:TexecsqlEvent;
  protected
    procedure ExecsqlError;
  public
    procedure Execute;
    constructor Create( fadoq:Tadoquery;
                        tmpsql:string);virtual;
    destructor destroy();override;
    property ExecsqlEvent:TexecsqlEvent read FexecsqlEvent write FexecsqlEvent;
  end;

implementation

{ Texecsql }

constructor Texecsql.Create(fadoq: Tadoquery;tmpsql: string);
begin
  Fadoquery:=Fadoq;
  Fsql:=tmpsql;
end;

destructor Texecsql.destroy;
begin
  {do nothing};
  inherited;
end;

procedure Texecsql.ExecsqlError;
begin
  Abort;
end;

procedure Texecsql.Execute;
var
  CL:TRTLCriticalSection;
begin
try
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    fadoquery.Close;
    fadoquery.SQL.Clear;
    fadoquery.SQL.Add(fsql);
    fadoquery.ExecSQL;

    if assigned(FexecsqlEvent) then
      begin
        FexecSqlEvent(self,Fadoquery);
      end;
  except
    FexecsqlException:=Exceptobject as Exception;
    Execsqlerror;
  end;
finally
LeaveCriticalSection(CL);
end;
end;

end.
