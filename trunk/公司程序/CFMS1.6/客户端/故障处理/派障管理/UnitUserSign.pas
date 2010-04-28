unit UnitUserSign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFormUserSign = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Memo1: TMemo;
    Bevel1: TBevel;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormUserSign: TFormUserSign;

implementation

{$R *.dfm}

procedure TFormUserSign.OKBtnClick(Sender: TObject);
begin
  if trim(Memo1.Lines.Text)='' then
  begin
    MessageBox(Handle, '请填写相关说明', '提示', MB_OK + MB_ICONINFORMATION) ;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TFormUserSign.CancelBtnClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
