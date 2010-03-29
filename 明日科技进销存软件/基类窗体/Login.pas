unit Login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, DB, ADODB;

type
  TFrmLogin = class(TFrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ADOMaster: TADODataSet;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    FisLogin:Boolean;

    procedure InitLookup;
    procedure GoToExec;
  public
    class function isLogin:Boolean;
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses DataModu, md5, PubConst;

{$R *.dfm}

{ TFrmLogin }

class function TFrmLogin.isLogin: Boolean;
begin
  FrmLogin := TFrmLogin.Create(Application);
  FrmLogin.ShowModal;
  Result := FrmLogin.FisLogin;
  FrmLogin.Free;

end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
  inherited;
  FisLogin := False;
  InitLookup;
end;

procedure TFrmLogin.InitLookup;
var
  i:Integer;
begin
  ADOMaster.Active := False;
  ADOMaster.CommandText := 'Select * From 用户表 Where Flg = 1';
  ADOMaster.Active := True;
  if ADOMaster.IsEmpty then
    Exit;
  for i:=0 to ADOMaster.RecordCount -1 do
  begin
    ComboBox1.Items.Add(ADOMaster.FieldByName('UserName').AsString);
    ADOMaster.Next;
  end;
end;

procedure TFrmLogin.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  GoToExec;
  if FisLogin then
    ModalResult := mrOk;
end;

procedure TFrmLogin.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TFrmLogin.GoToExec;
var
  SQL:string;
begin
  SQL := 'Select * From 用户表 Where UserName = '+ QuotedStr(ComboBox1.Text)+
        ' and PassWord = '+ QuotedStr(MD5Print(MD5String(Edit1.Text)));
  ADOMaster.Active := False;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;
  if not ADOMaster.IsEmpty then
  begin
    FisLogin := True;
    LoginName := ADOMaster.FieldByName('UserName').AsString;
    LoginID := ADOMaster.FieldByName('ID').AsString;
  end;
end;

procedure TFrmLogin.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    Edit1.SetFocus;
end;

procedure TFrmLogin.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    SpeedButton1.Click;
end;

end.
