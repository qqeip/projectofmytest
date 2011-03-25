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
  private
    FUserName: string;
    FPassWord: string;
    { Private declarations }
  public
    { Public declarations }
  published
    property UserName: string read FUserName write FUserName;
    property PassWord: string read FPassWord write FPassWord;
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.dfm}

procedure TFormLogin.BtnOKClick(Sender: TObject);
begin
  if EditName.Text= '' then begin
    Application.MessageBox('用户名不能为空！','提示',MB_OK+64);
    Exit;
  end;
  UserName:= EditName.Text;
  PassWord:= EditPwd.Text; 
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
