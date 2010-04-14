unit UserPwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormUserPWD = class(TForm)
    EditNewPwd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditConfirmPWD: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormUserPWD: TFormUserPWD;

implementation

{$R *.dfm}

procedure TFormUserPWD.Button1Click(Sender: TObject);
begin
  if EditNewPwd.Text<>EditConfirmPWD.Text then
    begin
      Application.MessageBox('��������ȷ�����벻һ�£����������룡��','��Ϣ',MB_ICONINFORMATION+MB_OK) ;
      EditNewPwd.Clear;
      EditConfirmPWD.Clear;
      EditNewPwd.SetFocus;
      exit;
    end;
  ModalResult:=mrOK;
end;

end.
