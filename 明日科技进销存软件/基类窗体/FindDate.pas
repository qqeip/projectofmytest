unit FindDate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, ComCtrls;

type
  TFrmFindDate = class(TFrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    D_StartDate: TDateTimePicker;
    D_EndDate: TDateTimePicker;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmFindDate: TFrmFindDate;

implementation

{$R *.dfm}

procedure TFrmFindDate.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TFrmFindDate.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
