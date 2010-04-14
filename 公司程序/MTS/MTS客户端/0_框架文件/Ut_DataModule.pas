unit Ut_DataModule;

interface

uses
  SysUtils,Windows, Classes, DB, DBClient, MConnect, SConnect,MTS_Server_TLB;
  
type
  PTPatternPlate = ^TPatternPlate;
  TPatternPlate = record
    Id : integer;
    Name :String;
    UserID :integer;
    Area : String;
    Area_ : String;  //»ÒÉ«
    AREAGRANULAR :integer;
    TIMEGRANULAR : integer;
    FLOW : String;
    FLOWSUM : integer;
    PAYTYPE : integer;
    XAXIS : integer;
    CHARTTYPE : integer;
    GROUPVALUE : integer;
    CHECKPAY : integer;
    DRAWCHART :integer;
  end;
  
type
  TDm_MTS = class(TDataModule)
    cds_common: TClientDataSet;
    SocketConnection1: TSocketConnection;
    cds_common1: TClientDataSet;
    cds_Master: TClientDataSet;
    cds_Detail: TClientDataSet;
    cds_Map: TClientDataSet;
    cds_EyeMap: TClientDataSet;
    cds_HMaster: TClientDataSet;
    cds_HDetail: TClientDataSet;
    cds_common2: TClientDataSet;
    procedure SocketConnection1AfterConnect(Sender: TObject);
  private
    { Private declarations }

  public
    TempInterface: IRDM_MTSDisp;
    MtsServer : Variant;
    { Public declarations }
  end;

var
  Dm_MTS: TDm_MTS;

implementation

{$R *.dfm}
procedure TDm_MTS.SocketConnection1AfterConnect(Sender: TObject);
begin
  TempInterface := IRDM_MTSDisp(IDispatch(SocketConnection1.AppServer));
  MtsServer :=  SocketConnection1.AppServer;
end;

end.
