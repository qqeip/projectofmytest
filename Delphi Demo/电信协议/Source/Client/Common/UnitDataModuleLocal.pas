unit UnitDataModuleLocal;

interface

uses
  SysUtils, Classes, DB, DBClient, MConnect, SConnect, MyServer_TLB;

type
  TDMLocal = class(TDataModule)
    SocketConnection: TSocketConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TempInterface: IDataModuleRemoteDisp;
  end;

var
  DMLocal: TDMLocal;

implementation


{$R *.dfm}

procedure TDMLocal.DataModuleCreate(Sender: TObject);
begin
  TempInterface := IDataModuleRemoteDisp(IDispatch(SocketConnection.AppServer));
end;

end.
