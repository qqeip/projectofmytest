unit UnitBaseShowModal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormBaseShowModal = class(TForm)
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    BtnCancel: TButton;
    BtnOK: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBaseShowModal: TFormBaseShowModal;

implementation

{$R *.dfm}

procedure TFormBaseShowModal.BtnOKClick(Sender: TObject);
begin
  self.ModalResult:= mrOk;
end;

procedure TFormBaseShowModal.BtnCancelClick(Sender: TObject);
begin
  self.ModalResult:= mrCancel;;
end;

procedure TFormBaseShowModal.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:= false;
end;

end.
