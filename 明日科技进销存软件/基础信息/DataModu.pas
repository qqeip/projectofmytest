unit DataModu;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TFrmDataModu = class(TDataModule)
    ADOCon: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOReport: TADODataSet;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDataModu: TFrmDataModu;

implementation

{$R *.dfm}

procedure TFrmDataModu.DataModuleCreate(Sender: TObject);
begin
  ADOCon.ConnectionString := 'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initial Catalog=JXCData;Data Source=.';
  ADOCon.Connected := True;
end;

end.
