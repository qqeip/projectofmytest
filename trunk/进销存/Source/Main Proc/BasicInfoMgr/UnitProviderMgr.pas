unit UnitProviderMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Buttons, ExtCtrls, StdCtrls, CxGridUnit, ADODB;

type
  TFormProviderMgr = class(TForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EdtProviderID: TEdit;
    EdtProviderComment: TEdit;
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox1: TGroupBox;
    cxGridProvider: TcxGrid;
    cxGridProviderDBTableView1: TcxGridDBTableView;
    cxGridProviderLevel1: TcxGridLevel;
    DataSourceProvider: TDataSource;
    Label3: TLabel;
    EdtProviderName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure cxGridProviderDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    AdoDepotQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;

    procedure AddcxGridViewField;
    procedure LoadProviderInfo;
  public
    { Public declarations }
  end;

var
  FormProviderMgr: TFormProviderMgr;

implementation

uses UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormProviderMgr.FormCreate(Sender: TObject);
begin
  AdoDepotQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridProvider,true,false,true);
end;

procedure TFormProviderMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadProviderInfo;
end;

procedure TFormProviderMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormProviderMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormProviderMgr.AddcxGridViewField;
begin
  AddViewField(cxGridProviderDBTableView1,'ProviderID','供货商编号',85);
  AddViewField(cxGridProviderDBTableView1,'ProviderName','供货商名称', 85);
  AddViewField(cxGridProviderDBTableView1,'COMMENT','供货商说明', 338);
end;

procedure TFormProviderMgr.LoadProviderInfo;
begin
  with AdoDepotQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select * from Provider order by ProviderID';
    Active:= True;
    DataSourceProvider.DataSet:= AdoDepotQuery;
  end;
end;

procedure TFormProviderMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtProviderID.Text='' then
  begin
    Application.MessageBox('供货商编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtProviderName.Text='' then
  begin
    Application.MessageBox('供货商名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('ProviderID', 'Provider', EdtProviderID.Text) then
  begin
    Application.MessageBox('供货商编号已存在！','提示',MB_OK+64);
    Exit;
  end;
  try
    IsRecordChanged:= True;
    AdoDepotQuery.Append;
    AdoDepotQuery.FieldByName('ProviderID').AsString:= EdtProviderID.Text;
    AdoDepotQuery.FieldByName('ProviderName').AsString:= EdtProviderName.Text;
    AdoDepotQuery.FieldByName('COMMENT').AsString:= EdtProviderComment.Text;
    AdoDepotQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormProviderMgr.Btn_ModifyClick(Sender: TObject);
begin
  if EdtProviderID.Text='' then
  begin
    Application.MessageBox('供货商编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtProviderName.Text='' then
  begin
    Application.MessageBox('供货商名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtProviderID.Text<> AdoDepotQuery.fieldbyname('ProviderID').AsString then
    if IsExistID('ProviderID', 'Provider', EdtProviderID.Text) then
    begin
      Application.MessageBox('供货商编号已存在！','提示',MB_OK+64);
      Exit;
    end;

  try
    IsRecordChanged:= True;
    AdoDepotQuery.Edit;
    AdoDepotQuery.FieldByName('ProviderID').AsString:= EdtProviderID.Text;
    AdoDepotQuery.FieldByName('ProviderName').AsString:= EdtProviderName.Text;
    AdoDepotQuery.FieldByName('COMMENT').AsString:= EdtProviderComment.Text;
    AdoDepotQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormProviderMgr.Btn_DeleteClick(Sender: TObject);
begin
  try
    IsRecordChanged:= True;
    AdoDepotQuery.Delete;
    IsRecordChanged:= False;
    Application.MessageBox('删除成功！','提示',MB_OK+64);
  except
    Application.MessageBox('删除失败！','提示',MB_OK+64);
  end;
end;

procedure TFormProviderMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormProviderMgr.cxGridProviderDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  EdtProviderID.Text:= AdoDepotQuery.fieldbyname('ProviderID').AsString;
  EdtProviderName.Text:= AdoDepotQuery.fieldbyname('ProviderName').AsString;
  EdtProviderComment.Text:= AdoDepotQuery.fieldbyname('COMMENT').AsString;
end;

end.
