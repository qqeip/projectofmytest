unit fClientForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uROClient, uROClientIntf, uRORemoteService, uROBinMessage, uROIndyTCPChannel,
  Grids, DBGrids, DB,adodb;

type
  TClientForm = class(TForm)
    ROMessage: TROBinMessage;
    ROChannel: TROIndyTCPChannel;
    RORemoteService: TRORemoteService;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Memo1: TMemo;
    ADODataSet1: TADODataSet;
    GroupBox1: TGroupBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;

implementation

{
  The unit OracleAccessLib_Intf.pas will be generated by the RemObjects preprocessor the first time you
  compile your server application. Make sure to do that before trying to compile the client.

  To invoke your server simply typecast your server to the name of the service interface like this:

      (RORemoteService as IOracleAccessService).Sum(1,2)
}

uses OracleAccessLib_Intf,OracleAccessService_Impl,uVCLADOLib; 

{$R *.dfm}

procedure TClientForm.Button1Click(Sender: TObject);
var
  Xml:String;
begin
  try
    Xml:=(RORemoteService as IOracleAccessService).openQuery(Memo1.text);
    XMLToVCLRecordset(Xml,ADODataSet1);
    DataSource1.DataSet:=ADODataSet1;
  except
    on e:Exception do
      raise exception.Create(e.Message);
  end;
end;

procedure TClientForm.Button2Click(Sender: TObject);
var
  BoolResult:Boolean;
begin
  BoolResult:=False;
  try
    BoolResult:=(RORemoteService as IOracleAccessService).ExecSQL(Memo1.text);
    if BoolResult then
     showmessage('ִ�гɹ�');
  except
    on e:Exception do
      raise exception.Create(e.Message);
  end;
end;

end.
