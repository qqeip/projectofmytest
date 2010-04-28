unit UnitFaultStaySet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls;

type
  TFormFaultStaySet = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditRemark: TEdit;
    SpinEditStay: TSpinEdit;
    SpinEditRemin: TSpinEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFaultStaySet: TFormFaultStaySet;

implementation

{$R *.dfm}

procedure TFormFaultStaySet.OKBtnClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TFormFaultStaySet.CancelBtnClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
