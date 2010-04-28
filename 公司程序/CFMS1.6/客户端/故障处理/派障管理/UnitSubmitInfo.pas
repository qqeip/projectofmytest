unit UnitSubmitInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons;

type
  TFormSubmitInfo = class(TForm)
    Label4: TLabel;
    Lb_Cbb_FACTESERVICE: TLabel;
    Lb_Reason: TLabel;
    SpeedButton1: TSpeedButton;
    Label7: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    EditReason: TEdit;
    EditRevertReason: TEdit;
    PopupMenu1: TPopupMenu;
    MenuItemCause: TMenuItem;
    EditResolve: TEdit;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    PopupMenu2: TPopupMenu;
    MenuItemResolve: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    procedure DoMenuAction_7(Sender: TObject);
    procedure DoMenuAction_6(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FormSubmitInfo: TFormSubmitInfo;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormSubmitInfo.DoMenuAction_6(Sender: TObject);
var
  MenuItem :TMenuItem;
begin
  MenuItem := TMenuItem(Sender);
  //如果不是最下层菜单项就退出
  if MenuItem.Count > 0 then Exit;
  EditResolve.Text := MenuItem.Caption;
  EditResolve.Tag := MenuItem.Tag;
end;

procedure TFormSubmitInfo.DoMenuAction_7(Sender: TObject);
var
  MenuItem :TMenuItem;
begin
  MenuItem := TMenuItem(Sender);
  //如果不是最下层菜单项就退出
  if MenuItem.Count > 0 then Exit;
  EditReason.Text := MenuItem.Caption;
  EditReason.Tag := MenuItem.Tag;
end;

procedure TFormSubmitInfo.FormCreate(Sender: TObject);
begin
  if gPublicParam.CauseCodeFlag>0 then
    MenuItemCause.Add(GetMenuItem(7,DoMenuAction_7));
  if gPublicParam.ResolveCodeFlag>0 then
    MenuItemResolve.Add(GetMenuItem(6,DoMenuAction_6));
end;

procedure TFormSubmitInfo.SpeedButton1Click(Sender: TObject);
begin
  PopupMenu1.Popup(TSpeedButton(Sender).ClientOrigin.X,TSpeedButton(Sender).ClientOrigin.Y);
end;

procedure TFormSubmitInfo.SpeedButton2Click(Sender: TObject);
begin
  PopupMenu2.Popup(TSpeedButton(Sender).ClientOrigin.X,TSpeedButton(Sender).ClientOrigin.Y);
end;

procedure TFormSubmitInfo.OKBtnClick(Sender: TObject);
begin
  //判断是否强制
  if gPublicParam.CauseCodeFlag=2 then
  begin
    if EditReason.Tag= -1 then
    begin
      MessageBox(Handle, '请填写故障原因', '提示', MB_OK + MB_ICONINFORMATION) ;
      exit;
    end;
  end;
  if gPublicParam.ResolveCodeFlag=2 then
  begin
    if EditResolve.Tag= -1 then
    begin
      MessageBox(Handle, '请填写排障方法', '提示', MB_OK + MB_ICONINFORMATION) ;
      exit;
    end;
  end;
  ModalResult:=mrOk;
end;

procedure TFormSubmitInfo.CancelBtnClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
