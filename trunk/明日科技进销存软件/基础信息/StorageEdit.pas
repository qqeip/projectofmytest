unit StorageEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EditBase, DB, ADODB, Buttons, StdCtrls, ExtCtrls, jpeg, DBCtrls,
  Mask,DBClient;

type
  TFrmStorageEdit = class(TFrmEditBase)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBMemo1: TDBMemo;
    DBEdit2: TDBEdit;
    procedure Btn_PostClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
  private
    { Private declarations }
  protected
  public
  end;

var
  FrmStorageEdit: TFrmStorageEdit;

implementation

uses DataModu, MessageBox;

{$R *.dfm}


procedure TFrmStorageEdit.Btn_PostClick(Sender: TObject);
begin
  inherited;
  if DBEdit1.Text = '' then
  begin
    ShowMessageBox('仓库名称不能为空！','系统提示');
    Exit;
  end;
  if DBEdit2.Text = '' then
  begin
    ShowMessageBox('负责人不能为空！','系统提示');
    Exit;
  end;
  ModalResult := mrOk;
end;

procedure TFrmStorageEdit.Btn_CancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
