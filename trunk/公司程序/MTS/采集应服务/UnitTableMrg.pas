unit UnitTableMrg;

interface

uses ADODB, SysUtils;

const
  WD_TABLESTATUS_BEYOND = -1;
  WD_TABLESTATUS_NORMAL = 0;
  WD_TABLESTATUS_WAITFOR = 1;
  WD_TABLESTATUS_TREATING = 2;
  WD_TABLESTATUS_HASTREATED = 3;
  WD_TABLESTATUS_EXCEPTION = -99;
type
  TTableMgr = class (TObject)
  private
    FExcuteQuery: TAdoQuery;
    FStatusFieldName: string;
    FTableName: string;
    procedure SetExcuteQuery(const Value: TAdoQuery);
    procedure SetStatusFieldName(const Value: string);
    procedure SetTableName(const Value: string);

  public
    procedure SetBarrier(aStatusFlag: integer);
    property ExcuteQuery: TAdoQuery read FExcuteQuery write SetExcuteQuery;
    property TableName: string read FTableName write SetTableName;
    property StatusFieldName: string read FStatusFieldName write SetStatusFieldName;
  end;

implementation

{ TTableMgr }

procedure TTableMgr.SetBarrier(aStatusFlag: integer);
begin
  if FExcuteQuery=nil then
  begin
    raise Exception.Create('栅栏操作类未初始化参数？');
    exit;
  end;
  with FExcuteQuery do
  begin
    close;
    SQL.Text:= 'update '+TableName+' set '+StatusFieldName+'='+inttostr(aStatusFlag);
    ExecSQL;
  end;
end;

procedure TTableMgr.SetExcuteQuery(const Value: TAdoQuery);
begin
  FExcuteQuery := Value;
end;

procedure TTableMgr.SetStatusFieldName(const Value: string);
begin
  FStatusFieldName := Value;
end;

procedure TTableMgr.SetTableName(const Value: string);
begin
  FTableName := Value;
end;

end.
