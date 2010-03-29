unit MessageBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, jpeg,BaseForm;

type
  TFrmMessageBox = class(TFrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMessageBox: TFrmMessageBox;

function ShowMessageBox(Text:string;Title:string=''):TModalResult;

implementation

{$R *.dfm}

function ShowMessageBox(Text:string;Title:string=''):TModalResult;
begin
  FrmMessageBox := TFrmMessageBox.Create(nil);
  FrmMessageBox.Label1.Caption := Text;
  if Title <> '' then
    FrmMessageBox.Caption := Title;
  Result := FrmMessageBox.ShowModal;
  FrmMessageBox.Free;
end;

procedure TFrmMessageBox.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmMessageBox.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmMessageBox.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    SpeedButton1.Click;
end;

end.
