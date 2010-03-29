unit AccountUnitEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EditBase, DB, DBClient, Buttons, StdCtrls, ExtCtrls, jpeg,SQLConst,
  Mask, DBCtrls,ADODB;

type
  TFrmAccountUnitEdit = class(TFrmEditBase)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBMemo1: TDBMemo;
    procedure Btn_PostClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure DBEdit1Change(Sender: TObject);
  private

  public

  end;

var
  FrmAccountUnitEdit: TFrmAccountUnitEdit;



implementation

uses DataModu, MessageBox, Spell;


{$R *.dfm}


procedure TFrmAccountUnitEdit.Btn_PostClick(Sender: TObject);
begin
  inherited;
  if (DBEdit1.Text = '') or (DBEdit2.Text = '') then
  begin
    ShowMessageBox('��λ���ƻ�ƴ�����벻��Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  ModalResult := mrOk;
end;

procedure TFrmAccountUnitEdit.Btn_CancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TFrmAccountUnitEdit.DBEdit1Change(Sender: TObject);
begin
  inherited;
  if ADOEdit.State in [dsEdit, dsInsert] then
  ADOEdit.FieldByName('ƴ������').AsString := GetSpellCode(PChar(DBEdit1.Text),0,Length(DBEdit1.Text));
end;

end.
