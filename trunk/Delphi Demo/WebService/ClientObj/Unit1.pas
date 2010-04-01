unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses IDemoServices1;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Server : IDemoServices;
  fUser  : TUser;
begin
  Server := GetIDemoServices(True,'',nil);
  fUser  := Server.GetUser('Hello World');
  Edit1.Text := IntToStr(fUser.ID);
  Edit2.Text := fUser.Name;
  Edit3.Text := IntToStr(fUser.Age);

  Edit4.Text := Server.GetStr('Hello World');
end;

end.
