{*******************************************************}
{  单元名: 用户组件中更新密码的窗体单元                 }
{  描述: 提供更改密码操作界面                           }
{  作者:                                         }
{  最后修改日期: 20050710                             }
{  版本:                                            }
{*******************************************************}
unit FrmChangePwd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFormChangePwd = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    OldPasswordEdit: TEdit;
    NewPasswordEdit: TEdit;
    ConfirmPasswordEdit: TEdit;
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    procedure BitBtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    UserNo:string;
    OldPassword:string;
  end;
  
var
   FormChangePwd:TFormChangePwd;

implementation

uses MD5;

{$R *.DFM}

procedure TFormChangePwd.BitBtnOKClick(Sender: TObject);
var
  lPwd:string;
begin
  //lPwd:=Format('%s', [MD5Print(MD5String(UserNo+OldPasswordEdit.Text))]);

  if NewPasswordEdit.Text<>ConfirmPasswordEdit.Text then
    begin
      MessageDlg('新密码与确认新密码不一致，请重新输入！',mtWarning,[mbOK],0);
      NewPasswordEdit.Clear;
      ConfirmPasswordEdit.Clear;
      NewPasswordEdit.SetFocus;
      exit;
    end;
  ModalResult:=mrOK;
end;

end.
