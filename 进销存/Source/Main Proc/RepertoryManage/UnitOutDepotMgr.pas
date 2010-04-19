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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOutDepotMgr: TFormOutDepotMgr;

implementation

uses UnitMain, UnitDataModule, UnitGoodsSearch, UnitPublic;

{$R *.dfm}

procedure TFormOutDepotMgr.FormCreate(Sender: TObject);
begin
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
//
end;

procedure TFormOutDepotMgr.BtnCancelClick(Sender: TObject);
begin
//
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
          EdtGoodsID.Text:= FieldByName('GoodsID').AsString;
          EdtGoodsType.Text:= FieldByName('GoodsTypeName').AsString;
          EdtGoodsName.Text:= FieldByName('GoodsName').AsString;
          EdtDepotName.Text:= FieldByName('DepotName').AsString;
          EdtProvider.Text:= FieldByName('ProviderName').AsString;
          EdtCostPrice.Text:= FieldByName('CostPrice').AsString;
        end;
        EdtOutDepotNum.SetFocus;
      finally
//        Free;
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
          EdtCustomerName.Text:= FieldByName('CustomerName').AsString;
          EdtAssociatorType.Text:= FieldByName('AssociatorTypeName').AsString;
          EdtDiscount.Text:= FieldByName('Discount').AsString;
          EdtIntegral.Text:= FieldByName('CustomerIntegral').AsString;
        end;
        EdtBarCode.Clear;
        EdtBarCode.SetFocus;
      finally
//        Free;
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
    lOrderID:= GetID('OrderBH', 'OutDepotSummary');
    ShowMessage(lOrderID);
    EdtBarCode.Clear;
    EdtBarCode.SetFocus;
  end;
end;

end.
