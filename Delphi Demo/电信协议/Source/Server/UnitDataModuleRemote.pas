unit UnitDataModuleRemote;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, MyServer_TLB, StdVcl, Provider, DB, ADODB, Variants;

type
  TDataModuleRemote = class(TRemoteDataModule, IDataModuleRemote)
    ADOQuery: TADOQuery;
    DataSetProvider: TDataSetProvider;
  private
    function GetSQLSentence(aVariant: OleVariant): string;
    { Private declarations }
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
    function GetCDSData(aVariant: OleVariant): OleVariant; safecall;
  public
    { Public declarations }
  end;

implementation

uses UnitDataModuleLocal;

{$R *.DFM}

class procedure TDataModuleRemote.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
begin
  if Register then
  begin
    inherited UpdateRegistry(Register, ClassID, ProgID);
    EnableSocketTransport(ClassID);
    EnableWebTransport(ClassID);
  end else
  begin
    DisableSocketTransport(ClassID);
    DisableWebTransport(ClassID);
    inherited UpdateRegistry(Register, ClassID, ProgID);
  end;
end;

function TDataModuleRemote.GetSQLSentence(aVariant: OleVariant): string;
var
  i: Integer;
  lParamName, lSqlSentence: string;
begin
  Result:= '';
  if varArrayHighBound(aVariant, 1)> 1 then
  begin
    for i := varArrayLowBound(aVariant, 1) to varArrayHighBound(aVariant, 1) do
    begin
      lParamName:= '@Param'+inttostr(i-1);
      lSqlSentence:= StringReplace(lSqlSentence, lParamName, aVariant[i], [rfReplaceAll, rfIgnoreCase]);
    end;
  end;
  result:= lSqlSentence;
end;

function TDataModuleRemote.GetCDSData(aVariant: OleVariant): OleVariant;
var
  FConn: TAdoConnection;
begin
  FConn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if FConn.InTransaction then  FConn.CommitTrans;

  with TADOQuery.Create(nil) do
  begin
    Close;
    Connection:= FConn;
    SQL.Text := GetSQLSentence(aVariant);
    Open;
    Result:=DataSetProvider.Data;
  end;
end;

initialization
  TComponentFactory.Create(ComServer, TDataModuleRemote,
    Class_DataModuleRemote, ciMultiInstance, tmApartment);
end.
