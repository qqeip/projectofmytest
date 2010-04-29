unit UnitRepertoryStat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ppDB, ppDBPipe, ppBands, ppClass,
  ppCtrls, ppVar, ppPrnabl, ppCache, ppComm, ppRelatv, ppProd, ppReport,
  ExtCtrls, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  StdCtrls, Buttons, ADODB, CxGridUnit;

type
  TFormRepertoryStat = class(TForm)
    pnl1: TPanel;
    GroupBoxgrp1: TGroupBox;
    Btn_Print: TSpeedButton;
    Btn_Query: TSpeedButton;
    GroupBoxgrp2: TGroupBox;
    ChkDepot: TCheckBox;
    CbbDepot: TComboBox;
    ChkGoodsType: TCheckBox;
    CbbGoodsType: TComboBox;
    ChkGoods: TCheckBox;
    CbbGoods: TComboBox;
    pnl2: TPanel;
    cxGridRepertoryStat: TcxGrid;
    cxGridRepertoryStatDBTableView1: TcxGridDBTableView;
    cxGridRepertoryStatLevel1: TcxGridLevel;
    spl1: TSplitter;
    ppReport: TppReport;
    ppHeaderBand2: TppHeaderBand;
    ppLabel19: TppLabel;
    ppLine26: TppLine;
    ppLabel20: TppLabel;
    ppSystemVariable4: TppSystemVariable;
    ppLabel21: TppLabel;
    ppLabel22: TppLabel;
    ppSystemVariable5: TppSystemVariable;
    ppLabel23: TppLabel;
    ppLine27: TppLine;
    ppLine37: TppLine;
    ppLine38: TppLine;
    ppLine46: TppLine;
    ppLine48: TppLine;
    ppLine49: TppLine;
    ppLine50: TppLine;
    ppLine51: TppLine;
    ppLine52: TppLine;
    ppLine53: TppLine;
    ppLabel24: TppLabel;
    ppLabel25: TppLabel;
    ppLabel26: TppLabel;
    ppLabel27: TppLabel;
    ppLabel28: TppLabel;
    ppLabel29: TppLabel;
    ppLabel30: TppLabel;
    ppLabel31: TppLabel;
    ppDetailBand2: TppDetailBand;
    ppDBText15: TppDBText;
    ppDBText16: TppDBText;
    ppDBText17: TppDBText;
    ppDBText18: TppDBText;
    ppDBText19: TppDBText;
    ppDBText20: TppDBText;
    ppDBText21: TppDBText;
    ppDBText22: TppDBText;
    ppLine54: TppLine;
    ppLine55: TppLine;
    ppLine56: TppLine;
    ppLine57: TppLine;
    ppLine59: TppLine;
    ppLine60: TppLine;
    ppLine61: TppLine;
    ppLine62: TppLine;
    ppLine63: TppLine;
    ppLine64: TppLine;
    ppFooterBand2: TppFooterBand;
    ppLabel33: TppLabel;
    ppSystemVariable6: TppSystemVariable;
    ppLabel34: TppLabel;
    ppSummaryBand2: TppSummaryBand;
    ppDBCalc7: TppDBCalc;
    ppDBCalc8: TppDBCalc;
    ppDBCalc9: TppDBCalc;
    ppLine65: TppLine;
    ppLine66: TppLine;
    ppLine68: TppLine;
    ppLine69: TppLine;
    ppLine70: TppLine;
    ppLine71: TppLine;
    ppLine72: TppLine;
    ppLine73: TppLine;
    ppLabel35: TppLabel;
    ppDBPipeline: TppDBPipeline;
    DSRepertoryStat: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
    procedure ChkDepotClick(Sender: TObject);
    procedure ChkGoodsTypeClick(Sender: TObject);
    procedure CbbGoodsTypeChange(Sender: TObject);
  private
    { Private declarations }
    AdoQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;

    procedure AddcxGridViewField;
    procedure LoadStatInfo;
    function GetWhere: string;
  public
    { Public declarations }
  end;

var
  FormRepertoryStat: TFormRepertoryStat;

implementation

uses UnitMain, UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormRepertoryStat.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridRepertoryStat,true,false,true);
end;

procedure TFormRepertoryStat.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
end;

procedure TFormRepertoryStat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormRepertoryStat);
end;

procedure TFormRepertoryStat.FormDestroy(Sender: TObject);
begin
  FormRepertoryStat:= nil;
end;

procedure TFormRepertoryStat.AddcxGridViewField;
begin
  AddViewField(cxGridRepertoryStatDBTableView1,'DEPOTNAME','仓库名称',100);
  AddViewField(cxGridRepertoryStatDBTableView1,'GoodsTypeName','商品类型');
  AddViewField(cxGridRepertoryStatDBTableView1,'GoodsName','商品名称',200);
  AddViewField(cxGridRepertoryStatDBTableView1,'ProviderName','供货商');
  AddViewField(cxGridRepertoryStatDBTableView1,'GoodsNum','数量');
  AddViewField(cxGridRepertoryStatDBTableView1,'CostPrice','成本单价');
  AddViewField(cxGridRepertoryStatDBTableView1,'SalePrice','销售单价');
  AddViewField(cxGridRepertoryStatDBTableView1,'Cost','总成本');
  AddViewField(cxGridRepertoryStatDBTableView1,'Sale','总销售');
end;

function TFormRepertoryStat.GetWhere: string;
var
  lStr: string;
begin
  Result:= '';
  lStr:= '';
  if ChkDepot.Checked then
    lStr:= lStr + ' and Repertory.DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items));
  if ChkGoodsType.Checked then
    lStr:= lStr + ' and Goods1.GoodsTypeID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items));
  if ChkGoods.Checked then
    lStr:= lStr + ' and Repertory.GoodsID=' + IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Items));
  Result:= lStr;
end;

procedure TFormRepertoryStat.LoadStatInfo;
var
  lSqlStr: string;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    lSqlStr:= 'SELECT Repertory.*, DEPOT.DEPOTNAME, Goods1.GoodsTypeName, Goods.GoodsName, Goods1.ProviderName, ' +
               ' Goods1.CostPrice, Goods1.SalePrice, Goods1.Percent, ' +
               ' (Goods1.CostPrice*Repertory.GoodsNum) AS Cost, (Goods1.SalePrice*Repertory.GoodsNum) AS Sale' +
               ' FROM (Repertory ' +
               ' LEFT JOIN DEPOT ON DEPOT.DEPOTID=Repertory.DEPOTID)' +
               ' LEFT JOIN (SELECT Goods.*, GoodsType.Percent, GoodsType.GoodsTypeName, Provider.ProviderName' +
               '              FROM (Goods ' +
               '              LEFT JOIN GoodsType ON GoodsType.GoodsTypeID=Goods.GoodsTypeID)' +
               '              LEFT JOIN Provider ON Provider.ProviderID=Goods.ProviderID ' +
               '           ) AS Goods1 ON Goods1.GoodsID=Repertory.GoodsID' +
              ' WHERE 1=1 ' + GetWhere +
              ' Order by Repertory.ID';

    SQL.Text:= lSqlStr;
    Active:= True;
    DSRepertoryStat.DataSet:= AdoQuery;
  end;
end;

procedure TFormRepertoryStat.Btn_QueryClick(Sender: TObject);
begin
  LoadStatInfo;
end;

procedure TFormRepertoryStat.Btn_PrintClick(Sender: TObject);
VAR
  lAdoquery: TADOQuery;
  DSPrint: TDataSource;
begin
  lAdoquery:= TADOQuery.Create(Self);
  DSPrint:= TDataSource.Create(Self);
  with lAdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT Repertory.*, DEPOT.DEPOTNAME, Goods1.GoodsTypeName, Goods.GoodsName, Goods1.ProviderName, ' +
               ' Goods1.CostPrice, Goods1.SalePrice, Goods1.Percent, ' +
               ' (Goods1.CostPrice*Repertory.GoodsNum) AS Cost, (Goods1.SalePrice*Repertory.GoodsNum) AS Sale' +
               ' FROM (Repertory ' +
               ' LEFT JOIN DEPOT ON DEPOT.DEPOTID=Repertory.DEPOTID)' +
               ' LEFT JOIN (SELECT Goods.*, GoodsType.Percent, GoodsType.GoodsTypeName, Provider.ProviderName' +
               '              FROM (Goods ' +
               '              LEFT JOIN GoodsType ON GoodsType.GoodsTypeID=Goods.GoodsTypeID)' +
               '              LEFT JOIN Provider ON Provider.ProviderID=Goods.ProviderID ' +
               '           ) AS Goods1 ON Goods1.GoodsID=Repertory.GoodsID' +
               ' WHERE 1=1 ' + GetWhere +
               ' Order by Repertory.ID';
    Active:= True;
    DSPrint.DataSet:= lAdoQuery;
  end;
  ppDBPipeline.DataSource:= DSPrint;
  ppReport.Print;
end;

procedure TFormRepertoryStat.ChkDepotClick(Sender: TObject);
begin
  if ChkDepot.Checked then begin
    CbbDepot.Enabled:= True;
    SetItemCode('Depot', 'DepotID', 'DepotName', '', CbbDepot.Items);
  end
  else begin
    ClearTStrings(CbbDepot.Items);
    CbbDepot.Enabled:= False;
  end;
end;

procedure TFormRepertoryStat.ChkGoodsTypeClick(Sender: TObject);
begin
  if ChkGoodsType.Checked then begin
    CbbGoodsType.Enabled:= True;
    CbbGoods.Enabled:= True;
    SetItemCode('GoodsType', 'GoodsTypeID', 'GoodsTypeName', '', CbbGoodsType.Items);
  end
  else begin
    ClearTStrings(CbbGoodsType.Items);
    CbbGoodsType.Enabled:= False;
    CbbGoods.Enabled:= False;
  end;
end;

procedure TFormRepertoryStat.CbbGoodsTypeChange(Sender: TObject);
var
  lGoodsTypeID: Integer;
  lWhereStr: string;
begin
  if ChkGoods.Checked then
  begin
    lGoodsTypeID:= GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items);
    ClearTStrings(CbbGoods.Items);
    if lGoodsTypeID>-1 then
    begin
      lWhereStr:= ' where GoodsTypeID=' + IntToStr(lGoodsTypeID);
      SetItemCode('Goods', 'GoodsID', 'GoodsName', lWhereStr, CbbGoods.Items);
    end
    else
      SetItemCode('Goods', 'GoodsID', 'GoodsName', ' ', CbbGoods.Items);
  end;
end;

end.
