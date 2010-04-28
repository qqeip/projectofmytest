unit UnitFaultStayForword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls;

type
  TFormFaultStayForword = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Panel7: TPanel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Panel1: TPanel;
    DateTimePicker3: TDateTimePicker;
    DateTimePicker4: TDateTimePicker;
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
  FormFaultStayForword: TFormFaultStayForword;

implementation

{$R *.dfm}

procedure TFormFaultStayForword.OKBtnClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TFormFaultStayForword.CancelBtnClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
