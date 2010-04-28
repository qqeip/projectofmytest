unit UnitColGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormcolGroup = class(TForm)
    Label1: TLabel;
    EdGroupName: TEdit;
    Button: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure EdGroupNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormcolGroup: TFormcolGroup;

implementation

{$R *.dfm}

procedure TFormcolGroup.ButtonClick(Sender: TObject);
begin
  if trim(EdGroupName.Text)='' then
  begin
    MessageDlg('«Î ‰»Î◊È√˚≥∆£°',mtWarning,[mbok],0);
    EdGroupName.SetFocus;
    Exit;
  end;
  self.ModalResult:=mrOk;
end;

procedure TFormcolGroup.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormcolGroup.EdGroupNameKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  ButtonClick(Button);
end;

procedure TFormcolGroup.FormShow(Sender: TObject);
begin
  EdGroupName.SetFocus;
end;

end.
