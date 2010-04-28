unit UnitAlarmRevert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, ExtCtrls, UnitDllCommon;

type
  TFormAlarmRevert = class(TForm)
    Label4: TLabel;
    Lb_Cbb_FACTESERVICE: TLabel;
    Lb_Reason: TLabel;
    SpeedButton1: TSpeedButton;
    Label7: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    Ed_Reason: TEdit;
    EditRevertReason: TEdit;
    PopupMenu1: TPopupMenu;
    NCauseCode: TMenuItem;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    procedure DoMenuAction_7(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FormAlarmRevert: TFormAlarmRevert;

implementation

{$R *.dfm}

procedure TFormAlarmRevert.OKBtnClick(Sender: TObject);
begin
  if trim(EditRevertReason.Text)='' then
  begin
    MessageBox(Handle, '请填写回单原因', '提示', MB_OK + MB_ICONINFORMATION) ;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TFormAlarmRevert.CancelBtnClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TFormAlarmRevert.FormCreate(Sender: TObject);
begin
  NCauseCode.Add(GetMenuItem(7,DoMenuAction_7));
end;

procedure TFormAlarmRevert.DoMenuAction_7(Sender: TObject);
var
  MenuItem :TMenuItem;
begin
  MenuItem := TMenuItem(Sender);
  //如果不是最下层菜单项就退出
  if MenuItem.Count > 0 then Exit;
  Ed_Reason.Text := MenuItem.Caption;
  Ed_Reason.Tag := MenuItem.Tag;
end;

procedure TFormAlarmRevert.SpeedButton1Click(Sender: TObject);
begin
  PopupMenu1.Popup(TSpeedButton(Sender).ClientOrigin.X,TSpeedButton(Sender).ClientOrigin.Y);
end;

end.
