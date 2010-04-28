{ *************************************************************************** }
{                                                                             }
{                                  登录窗体                                   }
{                                                                             }
{ *************************************************************************** }
unit Ut_LoginWin;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables, ExtCtrls, Buttons, Variants;

type
  TFm_LoginWin = class(TForm)
    Panel1: TPanel;
    PanelLogin: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Image1: TImage;
    LabelTitle: TLabel;
    Bt_Cancel: TBitBtn;
    Bt_OK: TBitBtn;
    EdtPassword: TEdit;
    edtUserName: TEdit;
    procedure Bt_CancelClick(Sender: TObject);
    procedure Bt_OKClick(Sender: TObject);
    procedure EdtPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edtUserNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    Flag : Boolean;  //是否验证合法  
  end;

var
  Fm_LoginWin: TFm_LoginWin;

implementation

uses Ut_Data_Local;


{$R *.DFM}

procedure TFm_LoginWin.Bt_CancelClick(Sender: TObject);
begin
   Flag := false;
   ModalResult := mrCancel;
end;

procedure TFm_LoginWin.Bt_OKClick(Sender: TObject);
begin
  if Trim(edtUserName.Text)='' then
  begin
      Application.MessageBox('请输入工号!', '提示', MB_OK + MB_ICONINFORMATION);
      Exit;
  End;
  //Self.Hide;
  try
    if Dm_Collect_Local.LogIn(Trim(edtUserName.Text),Trim(EdtPassword.Text)) then
    begin
          Flag := true;
          ModalResult := mrOK;
    end
    else
    begin
        Application.MessageBox('用户帐号或口令有误!', '警告', MB_OK + MB_ICONINFORMATION);
        exit;
    end;
  finally
      Self.Show;
  end;
  close;
end;

procedure TFm_LoginWin.EdtPasswordKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = Chr(13) then Bt_OKClick(nil);
end;

procedure TFm_LoginWin.FormCreate(Sender: TObject);
begin
    Flag := false;
end;

procedure TFm_LoginWin.edtUserNameKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = Chr(13) then Bt_OKClick(nil);
end;

procedure TFm_LoginWin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_F4) and (Shift = [ssAlt]) then
    Key := 0;
end;

procedure TFm_LoginWin.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   action:=cafree;
end;

end.
