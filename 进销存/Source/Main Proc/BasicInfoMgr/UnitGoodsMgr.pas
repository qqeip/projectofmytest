unit UnitGoodsMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, 
  cxGridDBTableView, cxGrid, ComCtrls, StdCtrls, Buttons, ExtCtrls, ADODB, CxGridUnit;

type
  TFormGoodsMgr = class(TForm)
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label11: TLabel;
    EdtGoodsName: TEdit;
    CBProvider: TComboBox;
    EdtCostPrice: TEdit;
    EdtSalePrice: TEdit;
    EdtProduceArea: TEdit;
    EdtBarCode: TEdit;
    GroupBox1: TGroupBox;
    cxGridGoods: TcxGrid;
    cxGridGoodsDBTableView1: TcxGridDBTableView;
    cxGridGoodsLevel1: TcxGridLevel;
    EdtMeasureUnit: TEdit;
    EdtSize: TEdit;
    DataSourceGoods: TDataSource;
    Label8: TLabel;
    EdtGoodsID: TEdit;
    Label9: TLabel;
    CbbGoodsType: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure cxGridGoodsDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure EdtSalePriceExit(Sender: TObject);
    procedure EdtSalePriceKeyPress(Sender: TObject; var Key: Char);
    procedure EdtGoodsIDKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    AdoQuery, AdoEdit: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;
    procedure AddcxGridViewField;
    procedure LoadGoodsInfo;
  public
    { Public declarations }
  end;

var
  FormGoodsMgr: TFormGoodsMgr;

implementation

uses UnitPublic, UnitDataModule;

{$R *.dfm}

procedure TFormGoodsMgr.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  AdoEdit:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridGoods,true,false,true);
  SetItemCode('Provider', 'ProviderID', 'ProviderName', '', CBProvider.Items);
  SetItemCode('GoodsType', 'GoodsTypeID', 'GoodsTypeName', '', CbbGoodsType.Items);
end;

procedure TFormGoodsMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadGoodsInfo;
end;

procedure TFormGoodsMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormGoodsMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormGoodsMgr.AddcxGridViewField;
begin
  AddViewField(cxGridGoodsDBTableView1,'GoodsID','商品编号');
  AddViewField(cxGridGoodsDBTableView1,'BarCode','条形编码');
  AddViewField(cxGridGoodsDBTableView1,'GoodsName','商品名称');
  AddViewField(cxGridGoodsDBTableView1,'GOODSTYPENAME','商品类别');
  AddViewField(cxGridGoodsDBTableView1,'MeasureUnit','计量单位');
  AddViewField(cxGridGoodsDBTableView1,'GoodsSize','规格型号');
  AddViewField(cxGridGoodsDBTableView1,'CostPrice','成本价格');
  AddViewField(cxGridGoodsDBTableView1,'SalePrice','销售价格');
  AddViewField(cxGridGoodsDBTableView1,'ProducingArea','产    地');
  AddViewField(cxGridGoodsDBTableView1,'ProviderName','供货商');
end;

procedure TFormGoodsMgr.LoadGoodsInfo;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT Goods.*, Provider.ProviderName, GOODSTYPE.GOODSTYPENAME FROM ' +
               '(Goods LEFT JOIN Provider ON Provider.ProviderID=Goods.ProviderID)' +
               ' LEFT JOIN GOODSTYPE ON GOODSTYPE.GOODSTYPEID=Goods.GoodsTypeID' +
               ' order by GoodsID';
    Active:= True;
    DataSourceGoods.DataSet:= AdoQuery;
  end;
end;

procedure TFormGoodsMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtGoodsID.Text='' then
  begin
    Application.MessageBox('商品编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtGoodsName.Text='' then
  begin
    Application.MessageBox('商品名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('GoodsID', 'Goods', EdtGoodsID.Text) then
  begin
    Application.MessageBox('商品编号已存在！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('BarCode', 'Goods', ''''+EdtBarCode.Text+'''') then
  begin
    Application.MessageBox('此商品条形码已存在！','提示',MB_OK+64);
    Exit;
  end;
  if CBProvider.ItemIndex=-1 then
  begin
    Application.MessageBox('请选择供货商！','提示',MB_OK+64);
  end;
  
  try
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into Goods(' +
                 'GoodsID,BarCode, GoodsName,GoodsTypeID, CostPrice,SalePrice, ProducingArea, ProviderID,MeasureUnit,GoodsSize)' +
                 'values(:ID,:BarCode,:Name,:GoodsTypeID,:CostPrice,:SalePrice,:ProducingArea,:ProviderID,:MeasureUnit,:GoodsSize)';
      Parameters.ParamByName('ID').DataType:= ftInteger;
      Parameters.ParamByName('ID').Direction:=pdInput;
      Parameters.ParamByName('BarCode').DataType:= ftString;
      Parameters.ParamByName('BarCode').Direction:=pdInput;
      Parameters.ParamByName('Name').DataType:=ftString;
      Parameters.ParamByName('GoodsTypeID').DataType:=ftInteger;
      Parameters.ParamByName('CostPrice').DataType:= ftFloat;
      Parameters.ParamByName('SalePrice').DataType:= ftFloat;
      Parameters.ParamByName('ProducingArea').DataType:= ftString;
      Parameters.ParamByName('ProviderID').DataType:= ftInteger;
      Parameters.ParamByName('MeasureUnit').DataType:= ftString;
      Parameters.ParamByName('GoodsSize').DataType:= ftString;

      Parameters.ParamByName('ID').Value:= StrToInt(EdtGoodsID.Text);
      Parameters.ParamByName('BarCode').Value:= EdtBarCode.Text;
      Parameters.ParamByName('Name').Value:=EdtGoodsName.Text;
      Parameters.ParamByName('GoodsTypeID').Value:= GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items);
      Parameters.ParamByName('CostPrice').Value:= StrToFloat(EdtCostPrice.Text);
      Parameters.ParamByName('SalePrice').Value:= StrToFloat(EdtSalePrice.Text);
      Parameters.ParamByName('ProducingArea').Value:= EdtProduceArea.Text;
      Parameters.ParamByName('ProviderID').Value:= GetItemCode(CBProvider.Text, CBProvider.Items);
      Parameters.ParamByName('MeasureUnit').Value:= EdtMeasureUnit.Text;
      Parameters.ParamByName('GoodsSize').Value:= EdtSize.Text;
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadGoodsInfo;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormGoodsMgr.Btn_ModifyClick(Sender: TObject);
var
  lSqlStr: string;
begin
  if EdtGoodsID.Text='' then
  begin
    Application.MessageBox('商品编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtGoodsName.Text='' then
  begin
    Application.MessageBox('商品名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtGoodsID.Text<> AdoQuery.fieldbyname('GoodsID').AsString then
    if IsExistID('GoodsID', 'Goods', EdtGoodsID.Text) then
    begin
      Application.MessageBox('商品编号已存在！','提示',MB_OK+64);
      Exit;
    end;
    
  try
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lSqlStr := 'update Goods Set ' +
                 'GoodsID=' + EdtGoodsID.Text + ',' +
                 'BarCode=''' + EdtBarCode.Text + ''',' +
                 'GoodsName=''' + EdtGoodsName.Text + ''',' +
                 'GoodsTypeID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items)) + ',' +
                 'CostPrice=' + EdtCostPrice.Text + ',' +
                 'SalePrice=' + EdtSalePrice.Text + ',' +
                 'ProducingArea=''' + EdtProduceArea.Text + ''',' +
                 'ProviderID=' + IntToStr(GetItemCode(CBProvider.Text, CBProvider.Items)) + ',' +
                 'MeasureUnit=''' + EdtMeasureUnit.Text + ''',' +
                 'GoodsSize=''' + EdtSize.Text + '''' +
                 ' where GoodsID=' + AdoQuery.FieldByName('GoodsID').AsString;
      SQL.Add(lSqlStr);
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadGoodsInfo;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormGoodsMgr.Btn_DeleteClick(Sender: TObject);
var
  lSqlStr: string;
begin
  try
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lSqlStr:= 'delete from Goods where GoodsID=' + AdoQuery.FieldByName('GoodsID').AsString;
      SQL.Add(lSqlStr);
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadGoodsInfo;
    Application.MessageBox('删除成功！','提示',MB_OK+64);
  except
    Application.MessageBox('删除失败！','提示',MB_OK+64);
  end;
end;

procedure TFormGoodsMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormGoodsMgr.cxGridGoodsDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  with AdoQuery do
  begin
    EdtGoodsID.Text:= FieldByName('GoodsID').AsString;
    EdtBarCode.Text:= FieldByName('BarCode').AsString;
    EdtGoodsName.Text:= FieldByName('GoodsName').AsString;
    CbbGoodsType.ItemIndex:= CbbGoodsType.Items.IndexOf(FieldByName('GoodsTypeName').AsString);
    EdtCostPrice.Text:= FieldByName('CostPrice').AsString;
    EdtSalePrice.Text:= FieldByName('SalePrice').AsString;
    EdtProduceArea.Text:= FieldByName('ProducingArea').AsString;
    CBProvider.ItemIndex:= CBProvider.Items.IndexOf(FieldByName('ProviderName').AsString);
    EdtMeasureUnit.Text:= FieldByName('MeasureUnit').AsString;
    EdtSize.Text:= FieldByName('GoodsSize').AsString;
  end;
end;

procedure TFormGoodsMgr.EdtSalePriceExit(Sender: TObject);
var
  lProvideDiscount: Double;
begin
  if CbbGoodsType.ItemIndex=-1 then
  begin
    Application.MessageBox('请先选择商品类别！','提示',MB_OK+64);
    Exit;
  end;
  with TADOQuery.Create(nil) do
  begin
    Close;
    Connection:= DM.ADOConnection;
    SQL.Clear;
    SQL.Text:= 'select * from GoodsType where GoodsTypeID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items));
    Open;
    if RecordCount=1 then
      lProvideDiscount:= StrToFloat(FieldByName('ProvideDiscount').AsString);
    EdtCostPrice.Text:= FormatFloat('0.00',StrToFloat(EdtSalePrice.Text)*lProvideDiscount/100)
  end;
end;

procedure TFormGoodsMgr.EdtSalePriceKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13,#46]) then
  begin
    Key := #0;
  end;
end;

procedure TFormGoodsMgr.EdtGoodsIDKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13]) then
  begin
    Key := #0;
  end;
end;

end.
