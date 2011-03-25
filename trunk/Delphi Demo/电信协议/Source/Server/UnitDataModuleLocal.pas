unit UnitDataModuleLocal;

interface

uses
  SysUtils, Classes, uConnectionPool, uADOConnectionPool;

type
  TDataModuleLocal = class(TDataModule)
    ADOConnPool: TADOConnectionPool;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleLocal: TDataModuleLocal;

implementation

{$R *.dfm}

end.
