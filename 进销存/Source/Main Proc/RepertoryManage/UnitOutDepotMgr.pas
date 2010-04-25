unit UnitOutDepotMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls, ADODB, Grids,
  DBGrids;

type
  TFormOutDepotMgr = class(TForm)
    GroupBox1: TGroupBox;
    cxGridDepot: TcxGrid;
    cxGridDepotDBTableView1: TcxGridDBTableView;
    cxGridDepotLevel1: TcxGridLevel;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    LabelBarCode: TLabel;
    LabelCustomerName: TLabel;
    LabelIntegral: TLabel;
    LabelAssociatorType: TLabel;
    EdtCustomerName: TEdit;
    EdtBarCode: TEdit;
    EdtIntegral: TEdit;
    GroupBox3: TGroupBox;
    LabelGoodsID1: TLabel;
    EdtGoodsID: TEdit;
    LabelGoodsName1: TLabel;
    EdtGoodsName: TEdit;
    LabelDepotName: TLabel;
    EdtDepotName: TEdit;
    LabelProvider: TLabel;
    EdtProvider: TEdit;
    LabelConst: TLabel;
    EdtCostPrice: TEdit;
    LabelGoodsType: TLabel;
    EdtGoodsType: TEdit;
    BtnGoodsSearch: TSpeedButton;
    BtnCustomerSearch: TSpeedButton;
    BtnSubmit: TSpeedButton;
    BtnCancel: TSpeedButton;
    Btn1: TSpeedButton;
    LabelDiscount: TLabel;
    EdtDiscount: TEdit;
    DS1: TDataSource;
    LabelCustomerID: TLabel;
    EdtCustomerID: TEdit;
    EdtAssociatorType: TEdit;
    LabelOutDepotType: TLabel;
    CbbOutDepotType: TComboBox;
    LabelOutDepotNum: TLabel;
    EdtOutDepotNum: TEdit;
    grp1: TGroupBox;
    spl1: TSplitter;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure EdtBarCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnGoodsSearchClick(Sender: TObject);
    procedure BtnCustomerSearchClick(Sender: TObject);
    procedure EdtDiscountKeyPress(Sender: TObject; var Key: Char);
    procedure EdtCustomerIDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdtOutDepotNumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnSubmitClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure Btn1Click(Sender: TObject);
    procedure EdtOutDepotNumKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FAdoEdit: TAdoquery;
    ISExsitCustomer: Boolean; //是否存在客户
    FDepotID, FGoodsID, FCustomerID : Integer;
    FGoodsNum: Integer; //商品的库存数量
  public
    { Public declarations }
  end;

var
  FormOutDepotMgr: TFormOutDepotMgr;

implementation

uses UnitMain, UnitDataModule, UnitGoodsSearch, UnitPublic,
  UnitPublicResourceManager;

{$R *.dfm}

procedure TFormOutDepotMgr.FormCreate(Sender: TObject);
begin
  FAdoEdit:= TADOQuery.Create(Self);
  SetItemCode('OutDepotType', 'OutDepotTypeID', 'OutDepotTypeNAME', '', CbbOutDepotType.Items);
end;

procedure TFormOutDepotMgr.FormShow(Sender: TObject);
begin
  EdtBarCode.SetFocus;
  CbbOutDepotType.ItemIndex:= CbbOutDepotType.Items.IndexOf('零售出库');
end;

procedure TFormOutDepotMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormOutDepotMgr);
//  Action:= caFree;
end;

procedure TFormOutDepotMgr.FormDestroy(Sender: TObject);
begin
  FormOutDepotMgr:= nil;
end;

procedure TFormOutDepotMgr.BtnSubmitClick(Sender: TObject);
begin
  if ISExsitCustomer then
  begin

  end
  else
  begin
  
  end;
end;

procedure TFormOutDepotMgr.BtnCancelClick(Sender: TObject);
begin
  ISExsitCustomer:= False;
end;

procedure TFormOutDepotMgr.Btn1Click(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.EdtBarCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lAdoQuery: TADOQuery;
begin
  if Key = 13 then
  begin
    if EdtBarCode.Text = '' then
    begin
      Application.MessageBox('条形码为空！','提示',MB_OK+64);
      Exit;
    end;
    lAdoQuery:= TADOQuery.Create(nil);
    with lAdoQuery do
    begin
      try
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT Repertory.*, DEPOT.DEPOTNAME, Goods1.GoodsTypeName, Goods.GoodsName, Goods1.ProviderName, Goods1.CostPrice ' +
                   ' FROM (Repertory ' +
                   ' LEFT JOIN DEPOT ON DEPOT.DEPOTID=Repertory.DEPOTID)' +
                   ' LEFT JOIN (SELECT Goods.*, GoodsType.GoodsTypeName, Provider.ProviderName' +
                   '              FROM (Goods ' +
                   '              LEFT JOIN GoodsType ON GoodsType.GoodsTypeID=Goods.GoodsTypeID)' +
                   '              LEFT JOIN Provider ON Provider.ProviderID=Goods.ProviderID ' +
                   '           ) AS Goods1 ON Goods1.GoodsID=Repertory.GoodsID' +
                   ' where Goods1.BarCode=''' + Trim(EdtBarCode.Text) + '''';
        Active:= True;
        DS1.DataSet:= lAdoQuery;
        if RecordCount=1 then
        begin
          FDepotID:= FieldByName('DepotID').AsInteger;
          FGoodsID:= FieldByName('GoodsID').AsInteger;
          FGoodsNum:= FieldByName('GoodsNum').AsInteger;
          EdtGoodsID.Text:= FieldByName('GoodsID').AsString;
          EdtGoodsType.Text:= FieldByName('GoodsTypeName').AsString;
          EdtGoodsName.Text:= FieldByName('GoodsName').AsString;
          EdtDepotName.Text:= FieldByName('DepotName').AsString;
          EdtProvider.Text:= FieldByName('ProviderName').AsString;
          EdtCostPrice.Text:= FieldByName('CostPrice').AsString;
          EdtOutDepotNum.SetFocus;
        end
        else
        begin
          Application.MessageBox('此条形码的商品不存在或已无库存，请重新输入！','提示',MB_OK+64);
          EdtBarCode.Clear;
          EdtBarCode.SetFocus;
        end;

      finally
        lAdoQuery.Free;
      end;
    end;
  end;
end;

procedure TFormOutDepotMgr.BtnGoodsSearchClick(Sender: TObject);
begin  
  with TFormGoodsSearch.Create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormOutDepotMgr.BtnCustomerSearchClick(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.EdtDiscountKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13,#46]) then
  begin
    Key := #0;
  end;
end;

procedure TFormOutDepotMgr.EdtCustomerIDKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lAdoQuery: TADOQuery;
begin
  if Key = 13 then
  begin
    if EdtCustomerID.Text = '' then
    begin
      Application.MessageBox('客户编号为空！','提示',MB_OK+64);
      Exit;
    end;
    lAdoQuery:= TADOQuery.Create(nil);
    with lAdoQuery do
    begin
      try
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT Customer.*, AssociatorType.AssociatorTypeName, AssociatorType.Discount ' +
                   ' FROM Customer ' +
                   ' LEFT JOIN AssociatorType ' +
                   ' ON AssociatorType.AssociatorTypeID=Customer.CustomerAssociatorTypeID' +
                   ' WHERE Customer.CustomerID=' + Trim(EdtCustomerID.Text);
        Active:= True;
        DS1.DataSet:= lAdoQuery;
        if RecordCount=1 then
        begin
          ISExsitCustomer:= True;
          FCustomerID:= FieldByName('CustomerID').AsInteger;
          EdtCustomerName.Text:= FieldByName('CustomerName').AsString;
          EdtAssociatorType.Text:= FieldByName('AssociatorTypeName').AsString;
          EdtDiscount.Text:= FieldByName('Discount').AsString;
          EdtIntegral.Text:= FieldByName('CustomerIntegral').AsString;
          EdtBarCode.Clear;
          EdtBarCode.SetFocus;
        end
        else
        begin
          ISExsitCustomer:= False;
          EdtCustomerID.Clear;
          EdtCustomerID.SetFocus;
        end;

      finally
        lAdoQuery.Free;
      end;
    end;
  end;
end;

procedure TFormOutDepotMgr.EdtOutDepotNumKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lOrderID: string;
begin
  if Key=13 then
  begin
    if StrToInt(EdtOutDepotNum.Text)>FGoodsNum then
    begin
      Application.MessageBox(PChar('现库存有此商品'+inttostr(FGoodsNum)+'，不够要求出库数量！'),'提示',MB_OK+64);
      Exit;
    end;
    lOrderID:= GetID('OrderBH', 'OutDepotSummary');
    EdtBarCode.Clear;
    EdtBarCode.SetFocus;
    if GetItemCode(CbbOutDepotType.Text, CbbOutDepotType.Items)=1001 then //如果是零售出库
    begin
      with FAdoEdit do
      begin
        try
          Active:= False;
          Connection:= DM.ADOConnection;
          SQL.Clear;
          SQL.Text:= 'insert into OutDepotDetails(' +
                     'OrderBH,' +
                     'DepotID,' +
                     'GoodsID,' +
                     'UserID,' +
                     'OutDepotTypeID,' +
                     'OutDepotNum,' +
                     'CreateTime) ' +
                     'Values(''' +
                     lOrderID + ''',' +
                     IntToStr(FDepotID) + ',' +
                     IntToStr(FGoodsID) + ',' +
                     IntToStr(CurUser.UserID) + ',' +
                     IntToStr(GetItemCode(CbbOutDepotType.Text, CbbOutDepotType.Items)) + ',' +
                     EdtOutDepotNum.Text + ',' +
                     'cdate(''' + DateTimeToStr(Now) + ''')' +
                     ')';
          ExecSQL;
        finally

        end;

      end;
    end;
  end;
end;

procedure TFormOutDepotMgr.EdtOutDepotNumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13]) then
  begin
    Key := #0;
  end;
end;

end.
