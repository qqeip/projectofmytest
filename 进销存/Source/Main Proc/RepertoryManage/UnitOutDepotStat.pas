unit UnitOutDepotStat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ExtCtrls, ppDB, ppDBPipe, ppBands,
  ppClass, ppCtrls, ppVar, ppPrnabl, ppCache, ppComm, ppRelatv, ppProd,
  ppReport, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  StdCtrls, cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Buttons, ADODB, CxGridUnit;

type
  TFormOutDepotStat = class(TForm)
    pnl1: TPanel;
    GroupBoxgrp1: TGroupBox;
    Btn_Print: TSpeedButton;
    Btn_Query: TSpeedButton;
    GroupBoxgrp2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ChkDepot: TCheckBox;
    CbbDepot: TComboBox;
    ChkGoodsType: TCheckBox;
    CbbGoodsType: TComboBox;
    CbbOutDepotType: TComboBox;
    ChkOutDepotType: TCheckBox;
    ChkCreateDate: TCheckBox;
    cxDateEditBegin: TcxDateEdit;
    cxDateEditEnd: TcxDateEdit;
    ChkGoods: TCheckBox;
    CbbGoods: TComboBox;
    RBOrderByTime: TRadioButton;
    RBOrderByName: TRadioButton;
    pnl2: TPanel;
    cxGridOutDepotStat: TcxGrid;
    cxGridOutDepotStatDBTableView1: TcxGridDBTableView;
    cxGridOutDepotStatLevel1: TcxGridLevel;
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
    ppLine47: TppLine;
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
    ppLabel32: TppLabel;
    ppDetailBand2: TppDetailBand;
    ppDBText15: TppDBText;
    ppDBText16: TppDBText;
    ppDBText17: TppDBText;
    ppDBText18: TppDBText;
    ppDBText19: TppDBText;
    ppDBText20: TppDBText;
    ppDBText21: TppDBText;
    ppDBText22: TppDBText;
    ppDBText23: TppDBText;
    ppLine54: TppLine;
    ppLine55: TppLine;
    ppLine56: TppLine;
    ppLine57: TppLine;
    ppLine58: TppLine;
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
    ppLine67: TppLine;
    ppLine68: TppLine;
    ppLine69: TppLine;
    ppLine70: TppLine;
    ppLine71: TppLine;
    ppLine72: TppLine;
    ppLine73: TppLine;
    ppLabel35: TppLabel;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppDBCalc10: TppDBCalc;
    ppDBCalc11: TppDBCalc;
    ppLine74: TppLine;
    ppLine75: TppLine;
    ppLine76: TppLine;
    ppLine77: TppLine;
    ppLine78: TppLine;
    ppLine79: TppLine;
    ppLine80: TppLine;
    ppLine81: TppLine;
    ppLine82: TppLine;
    ppLabel36: TppLabel;
    ppDBText24: TppDBText;
    ppDBCalc12: TppDBCalc;
    ppDBText25: TppDBText;
    ppDBText26: TppDBText;
    ppDBPipeline: TppDBPipeline;
    DSOutDepotStat: TDataSource;
    spl1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
    procedure ChkDepotClick(Sender: TObject);
    procedure ChkGoodsTypeClick(Sender: TObject);
    procedure ChkOutDepotTypeClick(Sender: TObject);
    procedure ChkCreateDateClick(Sender: TObject);
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
  FormOutDepotStat: TFormOutDepotStat;

implementation

uses UnitMain, UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormOutDepotStat.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridOutDepotStat,true,false,true);
end;

procedure TFormOutDepotStat.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  cxDateEditBegin.EditValue:= Now;
  cxDateEditEnd.EditValue:= Now;
end;

procedure TFormOutDepotStat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormOutDepotStat);
end;

procedure TFormOutDepotStat.FormDestroy(Sender: TObject);
begin
  FormOutDepotStat:= nil;
end;

procedure TFormOutDepotStat.Btn_QueryClick(Sender: TObject);
begin
  LoadStatInfo;
end;

procedure TFormOutDepotStat.Btn_PrintClick(Sender: TObject);
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
    SQL.Text:= 'SELECT * FROM (SELECT OutDepotDetails.*, Depot.DepotName, ' +
               ' Goods1.GoodsTypeID, Goods1.GoodsTypeName, Goods1.GoodsName,' +
               ' OutDepotType.OutDepotTypeName, User.UserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*OutDepotDetails.Num) AS Cost, (Goods.SalePrice*OutDepotDetails.Num) AS Sale,' +
               ' Depot.DepotName&Goods1.GoodsName&OutDepotType.OutDepotTypeName AS Merger' +
               ' FROM (((OutDepotDetails LEFT JOIN Depot ON OutDepotDetails.DepotID = Depot.DepotID) ' +
               ' LEFT JOIN (SELECT Goods.*,GoodsType.GoodsTypeName FROM Goods ' +
               '              LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID) AS Goods1 ' +
               '                ON OutDepotDetails.GoodsID = Goods1.GoodsID) ' +
               ' LEFT JOIN User ON OutDepotDetails.UserID = User.UserID) ' +
               ' LEFT JOIN OutDepotType ON OutDepotDetails.OutDepotTypeID = OutDepotType.OutDepotTypeID)' +
               ' WHERE 1=1 ' + GetWhere +
               ' Order by Merger';
    Active:= True;
    DSPrint.DataSet:= lAdoQuery;
  end;
  ppDBPipeline.DataSource:= DSPrint;
  ppReport.Print;
end;

procedure TFormOutDepotStat.AddcxGridViewField;
begin
  AddViewField(cxGridOutDepotStatDBTableView1,'DepotName','仓库名称',100);
  AddViewField(cxGridOutDepotStatDBTableView1,'GoodsTypeName','商品类型');
  AddViewField(cxGridOutDepotStatDBTableView1,'GoodsName','商品名称',200);
  AddViewField(cxGridOutDepotStatDBTableView1,'OutDepotTypeName','出库类型');
  AddViewField(cxGridOutDepotStatDBTableView1,'Num','出库数量');
  AddViewField(cxGridOutDepotStatDBTableView1,'CostPrice','成本单价');
  AddViewField(cxGridOutDepotStatDBTableView1,'SalePrice','销售单价');
  AddViewField(cxGridOutDepotStatDBTableView1,'Cost','成本价');
  AddViewField(cxGridOutDepotStatDBTableView1,'Sale','销售价');
  AddViewField(cxGridOutDepotStatDBTableView1,'CreateTime','出库时间',100);
//  AddViewField(cxGridOutDepotStatDBTableView1,'ModifyTime','修改时间',100);
end;

function TFormOutDepotStat.GetWhere: string;
var
  lStr: string;
  lBeginDateTime, lEndDateTime: string;
begin
  Result:= '';
  lStr:= '';
  if ChkDepot.Checked then
    lStr:= lStr + ' and DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items));
  if ChkGoodsType.Checked then
    lStr:= lStr + ' and GoodsTypeID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items));
  if ChkGoods.Checked then
    lStr:= lStr + ' and GoodsID=' + IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Items));
  if ChkOutDepotType.Checked then
    lStr:= lStr + ' and OutDepotTypeID=' + IntToStr(GetItemCode(CbbOutDepotType.Text, CbbOutDepotType.Items));
  if ChkCreateDate.Checked then
  begin
    lBeginDateTime:= DateTimeToStr(cxDateEditBegin.EditingValue);
    lEndDateTime:= DateTimeToStr(cxDateEditEnd.EditingValue);
    lStr:= lStr + ' and CreateTime between cdate(''' + lBeginDateTime
                + ''') and cdate(''' + lEndDateTime
                + ''')';
  end; 
  Result:= lStr;
end;

procedure TFormOutDepotStat.LoadStatInfo;
var
  lSqlStr: string;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    lSqlStr:= 'SELECT * FROM (SELECT OutDepotDetails.*, Depot.DepotName, ' +
              ' Goods1.GoodsTypeID, Goods1.GoodsTypeName, Goods1.GoodsName,' +
              ' OutDepotType.OutDepotTypeName, User.UserName,' +
              ' Goods.CostPrice, Goods.SalePrice,' +
              ' (Goods.CostPrice*OutDepotDetails.Num) AS Cost, (Goods.SalePrice*OutDepotDetails.Num) AS Sale,' +
              ' Depot.DepotName&Goods1.GoodsName&OutDepotType.OutDepotTypeName AS Merger' +
              ' FROM (((OutDepotDetails LEFT JOIN Depot ON OutDepotDetails.DepotID = Depot.DepotID) ' +
              ' LEFT JOIN (SELECT Goods.*,GoodsType.GoodsTypeName FROM Goods ' +
              '              LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID) AS Goods1 ' +
              '                ON OutDepotDetails.GoodsID = Goods1.GoodsID) ' +
              ' LEFT JOIN User ON OutDepotDetails.UserID = User.UserID) ' +
              ' LEFT JOIN OutDepotType ON OutDepotDetails.OutDepotTypeID = OutDepotType.OutDepotTypeID)' +
              ' WHERE 1=1 ' + GetWhere;
    if RBOrderByTime.Checked then
      lSqlStr:= lSqlStr + ' Order by CreateTime';
    if RBOrderByName.Checked then
      lSqlStr:= lSqlStr + ' Order by Merger';
    SQL.Text:= lSqlStr;
    Active:= True;
    DSOutDepotStat.DataSet:= AdoQuery;
  end;
end;

procedure TFormOutDepotStat.ChkDepotClick(Sender: TObject);
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


procedure TFormOutDepotStat.ChkGoodsTypeClick(Sender: TObject);
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

procedure TFormOutDepotStat.ChkOutDepotTypeClick(Sender: TObject);
begin
  if ChkOutDepotType.Checked then begin
    CbbOutDepotType.Enabled:= True;
    SetItemCode('OutDepotType', 'OutDepotTypeID', 'OutDepotTypeName', ' where OutDepotTypeID<>1004', CbbOutDepotType.Items);
  end
  else begin
    ClearTStrings(CbbOutDepotType.Items);
    CbbOutDepotType.Enabled:= False;
  end;
end;

procedure TFormOutDepotStat.ChkCreateDateClick(Sender: TObject);
begin
  if ChkCreateDate.Checked then begin
    cxDateEditBegin.Enabled:= True;
    cxDateEditEnd.Enabled:= True;
  end
  else begin
    cxDateEditBegin.Enabled:= False;
    cxDateEditEnd.Enabled:= False;
  end;
end;

procedure TFormOutDepotStat.CbbGoodsTypeChange(Sender: TObject);
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
