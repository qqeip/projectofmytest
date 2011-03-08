unit fServerForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  uROClient, uROPoweredByRemObjectsButton, uROClientIntf, uROServer,
  uROBinMessage, uROIndyHTTPServer, uROIndyTCPServer;

type
  TServerForm = class(TForm)
    RoPoweredByRemObjectsButton1: TRoPoweredByRemObjectsButton;
    ROMessage: TROBinMessage;
    ROServer: TROIndyHTTPServer;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerForm: TServerForm;

implementation


{$R *.dfm}

procedure TServerForm.FormCreate(Sender: TObject);
begin
  ROServer.Active := true;
end;

end.
