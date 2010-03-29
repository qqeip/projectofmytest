{
    登录和退出系统时的用户信息核对窗体。
}
unit UnitLogIn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    EditPwd: TEdit;
    BtnOK: TButton;
    BtnCancel: TButton;
    Image1: TImage;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditPwdKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  published
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.dfm}

procedure TFormLogin.FormCreate(Sender: TObject);
begin
//  Font.Name :=sDispFontName;
//  Font.Size :=sDispFontSize;
//  Font.Charset :=sDispCharset;
end;

procedure TFormLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := cafree;
end;

procedure TFormLogin.BtnOKClick(Sender: TObject);
begin
  if EditName.Text= '' then begin
    Application.MessageBox('用户名不能为空！','提示',MB_OK+64);
    Exit;
  end;
  ModalResult:= mrOk;
end;

procedure TFormLogin.BtnCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TFormLogin.EditNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key= #13 then
    EditPwd.SetFocus;
end;

procedure TFormLogin.EditPwdKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    BtnOKClick(nil);
end;

end.
