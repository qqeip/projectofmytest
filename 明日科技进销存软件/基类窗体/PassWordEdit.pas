unit PassWordEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, DB, ADODB;

type
  TFrmPassWordEdit = class(TFrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    ADOMaster: TADODataSet;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    function Check:Boolean;
  public
    class procedure ShowEditPassWord;
  end;

var
  FrmPassWordEdit: TFrmPassWordEdit;

implementation

uses DataModu, PubConst, md5;

{$R *.dfm}

{ TFrmPassWordEdit }

function TFrmPassWordEdit.Check: Boolean;
begin
  Result := False;
  if ADOMaster.FieldByName('PassWord').AsString <>
      MD5Print(MD5String(Edit1.Text)) then
  begin
    Application.MessageBox('旧密码不正确！', '系统提示', MB_OKCANCEL + MB_ICONINFORMATION);
    Exit;
  end;
  if Edit2.Text <> Edit3.Text then
  begin
    Application.MessageBox('新密码不正确！', '系统提示', MB_OKCANCEL + MB_ICONINFORMATION);
    Exit;
  end;
  ADOMaster.Edit;
  ADOMaster.FieldByName('PassWord').AsString := MD5Print(MD5String(Edit2.Text));
  ADOMaster.Post;
  Result := True;
end;

procedure TFrmPassWordEdit.FormShow(Sender: TObject);
var
  SQL:string;
begin
  inherited;
  SQL := 'Select * From 用户表 Where ID = '+ LoginID;
  ADOMaster.Active := False;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;
  
end;

class procedure TFrmPassWordEdit.ShowEditPassWord;
begin
  FrmPassWordEdit := TFrmPassWordEdit.Create(Application);
  FrmPassWordEdit.ShowModal;
  FrmPassWordEdit.Free;
end;

procedure TFrmPassWordEdit.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  if Check then
    ModalResult := mrOk;
end;

procedure TFrmPassWordEdit.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
