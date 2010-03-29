unit WareEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EditBase, DB, ADODB, Buttons, StdCtrls, ExtCtrls, jpeg, Mask,
  DBCtrls, ExtDlgs;

type
  TFrmWareEdit = class(TFrmEditBase)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit14: TDBEdit;
    DBMemo1: TDBMemo;
    ADOEditDSDesigner: TAutoIncField;
    ADOEditDSDesigner2: TStringField;
    ADOEditDSDesigner3: TStringField;
    ADOEditDSDesigner4: TStringField;
    ADOEditDSDesigner5: TBCDField;
    ADOEditDSDesigner6: TBCDField;
    ADOEditDSDesigner7: TFloatField;
    ADOEditDSDesigner8: TFloatField;
    ADOEditDSDesigner9: TStringField;
    ADOEditDSDesigner10: TStringField;
    ADOEditDSDesigner11: TStringField;
    ADOEditflg: TBooleanField;
    ADOEditDSDesigner12: TStringField;
    procedure Btn_PostClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure DBEdit1Change(Sender: TObject);
  private

  protected

  public

  end;

var
  FrmWareEdit: TFrmWareEdit;

implementation

uses DataModu, MessageBox, Spell;


{$R *.dfm}


procedure TFrmWareEdit.Btn_PostClick(Sender: TObject);
begin
  inherited;
  if DBEdit1.Text = '' then
  begin
    ShowMessageBox('��Ʒ���Ʋ���Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  if DBEdit9.Text = '' then
  begin
    ShowMessageBox('ƴ�����벻��Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  if DBEdit3.Text = '' then
  begin
    ShowMessageBox('��λ����Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  if DBEdit10.Text = '' then
  begin
    ShowMessageBox('����ͺŲ���Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  if DBEdit5.Text = '' then
  begin
    ShowMessageBox('Ԥ����۲���Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  if DBEdit4.Text = '' then
  begin
    ShowMessageBox('Ԥ���ۼ۲���Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  if DBEdit6.Text = '' then
  begin
    ShowMessageBox('������޲���Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  if DBEdit14.Text = '' then
  begin
    ShowMessageBox('������޲���Ϊ�գ�','ϵͳ��ʾ');
    Exit;
  end;
  ModalResult := mrOk;
end;

procedure TFrmWareEdit.Btn_CancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TFrmWareEdit.DBEdit1Change(Sender: TObject);
begin
  inherited;
  if ADOEdit.State in [dsEdit, dsInsert] then
  ADOEdit.FieldByName('ƴ������').AsString := GetSpellCode(PChar(DBEdit1.Text),0,Length(DBEdit1.Text));
end;

end.
