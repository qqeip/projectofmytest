unit UnitGoodsTypeMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, StdCtrls, Buttons, ExtCtrls,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, CxGridUnit, ADODB;

type
  TFormGoodsTypeMgr = class(TForm)
    grp1: TGroupBox;
    cxGridGoodsType: TcxGrid;
    cxGridGoodsTypeDBTableView1: TcxGridDBTableView;
    cxGridGoodsTypeLevel1: TcxGridLevel;
    pnl1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    grp2: TGroupBox;
    LabelDepotID: TLabel;
    Label2: TLabel;
    LabelDepotName: TLabel;
    EdtGoodsTypeName: TEdit;
    EdtGoodsTypeComment: TEdit;
    EdtGoodsTypeID: TEdit;
    DSGoodsType: TDataSource;
    Label1: TLabel;
    EdtPercent: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    EdtProvideDiscount: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure cxGridGoodsTypeDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure EdtPercentKeyPress(Sender: TObject; var Key: Char);
    procedure EdtGoodsTypeIDKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    AdoDepotQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;
    
    procedure AddcxGridViewField;
    procedure LoadGoodsTypeInfo;
  public
    { Public declarations }
  end;

var
  FormGoodsTypeMgr: TFormGoodsTypeMgr;

implementation

uses UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormGoodsTypeMgr.FormCreate(Sender: TObject);
begin
  AdoDepotQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridGoodsType,true,false,true);
end;

procedure TFormGoodsTypeMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadGoodsTypeInfo;
end;

procedure TFormGoodsTypeMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormGoodsTypeMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormGoodsTypeMgr.AddcxGridViewField;
begin
  AddViewField(cxGridGoodsTypeDBTableView1,'GOODSTYPEID','商品类别编号',85);
  AddViewField(cxGridGoodsTypeDBTableView1,'GOODSTYPENAME','商品类别名称',85);
  AddViewField(cxGridGoodsTypeDBTableView1,'PERCENT','员工提成');
  AddViewField(cxGridGoodsTypeDBTableView1,'ProvideDiscount','供货折扣');
  AddViewField(cxGridGoodsTypeDBTableView1,'GOODSTYPECOMMENT','商品类别说明', 255);
end;

procedure TFormGoodsTypeMgr.LoadGoodsTypeInfo;
begin
  with AdoDepotQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select * from GoodsType order by GoodsTypeID';
    Active:= True;
    DSGoodsType.DataSet:= AdoDepotQuery;
  end;
end;

procedure TFormGoodsTypeMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtGoodsTypeID.Text='' then
  begin
    Application.MessageBox('商品类别编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtGoodsTypeName.Text='' then
  begin
    Application.MessageBox('商品类别名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('GOODSTYPEID', 'GOODSTYPE', EdtGoodsTypeID.Text) then
  begin
    Application.MessageBox('商品类别编号已存在！','提示',MB_OK+64);
    Exit;
  end;
  try
    IsRecordChanged:= True;
    AdoDepotQuery.Append;
    AdoDepotQuery.FieldByName('GOODSTYPEID').AsInteger:= StrToInt(EdtGoodsTypeID.Text);
    AdoDepotQuery.FieldByName('GOODSTYPENAME').AsString:= EdtGoodsTypeName.Text;
    AdoDepotQuery.FieldByName('PERCENT').AsString:= EdtPercent.Text;
    AdoDepotQuery.FieldByName('ProvideDiscount').AsString:= EdtProvideDiscount.Text;
    AdoDepotQuery.FieldByName('GOODSTYPECOMMENT').AsString:= EdtGoodsTypeComment.Text;
    AdoDepotQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormGoodsTypeMgr.Btn_ModifyClick(Sender: TObject);
begin
  if EdtGoodsTypeID.Text='' then
  begin
    Application.MessageBox('商品类别编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtGoodsTypeName.Text='' then
  begin
    Application.MessageBox('商品类别名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtGoodsTypeID.Text<> AdoDepotQuery.fieldbyname('GOODSTYPEID').AsString then
    if IsExistID('GOODSTYPEID', 'GOODSTYPE', EdtGoodsTypeID.Text) then
    begin
      Application.MessageBox('商品类别编号已存在！','提示',MB_OK+64);
      Exit;
    end;

  try
    IsRecordChanged:= True;
    AdoDepotQuery.Edit;
    AdoDepotQuery.FieldByName('GOODSTYPEID').AsInteger:= StrToInt(EdtGoodsTypeID.Text);
    AdoDepotQuery.FieldByName('GOODSTYPENAME').AsString:= EdtGoodsTypeName.Text;
    AdoDepotQuery.FieldByName('PERCENT').AsString:= EdtPercent.Text;
    AdoDepotQuery.FieldByName('ProvideDiscount').AsString:= EdtProvideDiscount.Text;
    AdoDepotQuery.FieldByName('GOODSTYPECOMMENT').AsString:= EdtGoodsTypeComment.Text;
    AdoDepotQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormGoodsTypeMgr.Btn_DeleteClick(Sender: TObject);
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

procedure TFormGoodsTypeMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormGoodsTypeMgr.cxGridGoodsTypeDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  EdtGoodsTypeID.Text:= AdoDepotQuery.FieldByName('GOODSTYPEID').AsString;
  EdtGoodsTypeName.Text:= AdoDepotQuery.FieldByName('GOODSTYPENAME').AsString;
  EdtPercent.Text:= AdoDepotQuery.FieldByName('PERCENT').AsString;
  EdtProvideDiscount.Text:= AdoDepotQuery.FieldByName('ProvideDiscount').AsString;
  EdtGoodsTypeComment.Text:= AdoDepotQuery.FieldByName('GOODSTYPECOMMENT').AsString;
end;

procedure TFormGoodsTypeMgr.EdtPercentKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13,#46]) then
  begin
    Key := #0;
  end;
end;

procedure TFormGoodsTypeMgr.EdtGoodsTypeIDKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13]) then
  begin
    Key := #0;
  end;
end;

end.
