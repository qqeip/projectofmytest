unit UserEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons;

type
  TFrmUserEdit = class(TFrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUserEdit: TFrmUserEdit;

implementation

{$R *.dfm}

procedure TFrmUserEdit.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TFrmUserEdit.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
