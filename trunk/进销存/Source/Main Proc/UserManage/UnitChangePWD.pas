unit UnitChangePWD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormChangePWD = class(TForm)
    BtnOK: TButton;
    BtnClose: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdtOldPWD: TEdit;
    EdtNewPWD: TEdit;
    EdtNewPWDAgain: TEdit;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormChangePWD: TFormChangePWD;

implementation

uses UnitPublicResourceManager;

{$R *.dfm}

procedure TFormChangePWD.BtnOKClick(Sender: TObject);
begin
  if UpperCase(CurUser.PassWord)<>UpperCase(EdtOldPWD.Text) then begin
    Application.MessageBox('ԭ�����������','��ʾ',MB_OK+64);
    Exit;
  end;
  if UpperCase(EdtNewPWD.Text)<>UpperCase(EdtNewPWDAgain.Text) then begin
    Application.MessageBox('�����������벻һ�£�','��ʾ',MB_OK+64);
    Exit;
  end;
  ModalResult:= MB_OK;
end;

procedure TFormChangePWD.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
