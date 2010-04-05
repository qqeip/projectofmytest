unit UnitLockSystem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormLockSystem = class(TForm)
    grp1: TGroupBox;
    lblCaption: TLabel;
    grp2: TGroupBox;
    lbl1: TLabel;
    EdtUserPWD: TEdit;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLockSystem: TFormLockSystem;

implementation

{$R *.dfm}

procedure TFormLockSystem.btnOKClick(Sender: TObject);
begin
  ModalResult:= mrOk;
end;

end.
