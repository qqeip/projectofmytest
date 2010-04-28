unit UnitDataModuleLocal;

interface

uses
  SysUtils, Classes, DB, DBClient, MConnect, SConnect, ProjectCFMS_Server_TLB;

type
  TDataModuleLocal = class(TDataModule)
    SocketConnection: TSocketConnection;
    ClientDataSetDym: TClientDataSet;
    ClientDataSetWav: TClientDataSet;
    procedure SocketConnectionAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    TempInterface: IDataModuleRemoteDisp;
  end;

var
  DataModuleLocal: TDataModuleLocal;

implementation

{$R *.dfm}

procedure TDataModuleLocal.SocketConnectionAfterConnect(Sender: TObject);
begin
  TempInterface := IDataModuleRemoteDisp(IDispatch(SocketConnection.AppServer));
end;

end.
