unit UnitServerSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormServerSet = class(TForm)
    Label2: TLabel;
    Ed_ServiceName: TEdit;
    Label3: TLabel;
    Ed_UserName: TEdit;
    Label4: TLabel;
    Ed_Password: TEdit;
    Label1: TLabel;
    Ed_ComPort: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Ed_ComPortKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormServerSet: TFormServerSet;

implementation

{$R *.dfm}

procedure TFormServerSet.Ed_ComPortKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9','.',#8]) then
  begin
    Key:=#0;
  end
end;

procedure TFormServerSet.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormServerSet.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormServerSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action:=cafree
end;

procedure TFormServerSet.FormShow(Sender: TObject);
begin
  Ed_ServiceName.SetFocus;
end;

end.
