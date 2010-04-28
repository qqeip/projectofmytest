unit UnitServerSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormServerSet = class(TForm)
    IP2: TEdit;
    IP3: TEdit;
    IP4: TEdit;
    Label1: TLabel;
    IP1: TEdit;
    DBPort: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtPort: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure IP1KeyPress(Sender: TObject; var Key: Char);
  private
    procedure InPutNum(var key: Char);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormServerSet: TFormServerSet;

implementation

{$R *.dfm}

procedure TFormServerSet.IP1KeyPress(Sender: TObject; var Key: Char);
begin
  InPutNum(key);
end;

procedure TFormServerSet.InPutNum(var key: Char);
begin
  if not (key  in ['0'..'9',#8]) then
  begin
    Key:=#0;
  end
end;

end.
