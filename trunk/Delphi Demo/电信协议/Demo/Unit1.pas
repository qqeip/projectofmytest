unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient;

type
  TCmd = record
    command: Integer;
  end;
  TForm1 = class(TForm)
    IdTCPClient1: TIdTCPClient;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var FCmd: TCmd;
begin
  FCmd.command:= 90;
  IdTCPClient1.Host:= '10.0.0.205';
  IdTCPClient1.Port:= 991;
  if not IdTCPClient1.Connected then
    IdTCPClient1.Connect();
  IdTCPClient1.WriteBuffer(FCmd,SizeOf(TCmd));
end;

end.
