{*******************************************************}
{  ��Ԫ��: �û�����и�������Ĵ��嵥Ԫ                 }
{  ����: �ṩ���������������                           }
{  ����:                                         }
{  ����޸�����: 20050710                             }
{  �汾:                                            }
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
      MessageDlg('��������ȷ�������벻һ�£����������룡',mtWarning,[mbOK],0);
      NewPasswordEdit.Clear;
      ConfirmPasswordEdit.Clear;
      NewPasswordEdit.SetFocus;
      exit;
    end;
  ModalResult:=mrOK;
end;

end.
