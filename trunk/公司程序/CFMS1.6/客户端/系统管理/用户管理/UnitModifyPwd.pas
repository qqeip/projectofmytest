unit UnitModifyPwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrmModifyPwd = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    NewPwd1: TEdit;
    NewPwd2: TEdit;
    OKB: TBitBtn;
    CancleB: TBitBtn;
    procedure OKBClick(Sender: TObject);
    procedure CancleBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmModifyPwd: TFrmModifyPwd;

implementation

{$R *.dfm}

procedure TFrmModifyPwd.OKBClick(Sender: TObject);
begin
  ModalResult:=mrok;
end;

procedure TFrmModifyPwd.CancleBClick(Sender: TObject);
begin
  Close;
end;

end.
