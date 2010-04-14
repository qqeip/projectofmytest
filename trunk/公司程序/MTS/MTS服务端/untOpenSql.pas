unit untOpenSql;

interface

uses
  sysUtils, ADODB, Windows;

type
  TopensqlEvent=procedure(sender:Tobject;qry:Tadoquery) of object;
type
  Topensql = class
  private
    Fadoquery:Tadoquery;
    Fsql:String;
    FopensqlException:Exception;
    FopensqlEvent:TopensqlEvent;
  protected
    procedure opensqlError;
  public
    procedure Execute;
    constructor create(Fadoq:Tadoquery;
                        tmpSql:string);virtual;
    Destructor destroy();override;
    property opensqlEvent:TopensqlEvent read FopensqlEvent write FopensqlEvent;
end;

implementation

{ Topensql }

constructor Topensql.create(Fadoq: Tadoquery;tmpSql: string);
begin
  Fadoquery:=Fadoq;
  Fsql:=Tmpsql;
end;

destructor Topensql.destroy;
begin
  {do nothing};
  inherited;
end;

procedure Topensql.Execute;
var
  CL:TRTLCriticalSection;
begin
try
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    Fadoquery.Close;
    Fadoquery.SQL.Clear;
    Fadoquery.SQL.Add(fsql);
    fadoquery.Open;

    if assigned(FopensqlEvent) then
      begin
        FopensqlEvent(self,Fadoquery);
      end;
  Except
    FopensqlException:=Exceptobject as Exception;
    opensqlError;
  end;
finally
LeaveCriticalSection(CL);
end;
end;

procedure Topensql.opensqlError;
begin
  Abort;
end;

end.
