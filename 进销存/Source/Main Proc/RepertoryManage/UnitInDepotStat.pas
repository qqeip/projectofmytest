unit UnitInDepotStat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, ppDB,
  ppDBPipe, ppComm, ppRelatv, ppProd, ppClass, ppReport, CxGridUnit, ADODB,
  ppBands, ppCache, cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, ppPrnabl, ppCtrls, ppVar;

type
  TFormInDepotStat = class(TForm)
    pnl1: TPanel;
    spl1: TSplitter;
    pnl2: TPanel;
    grp1: TGroupBox;
    Btn_Print: TSpeedButton;
    grp2: TGroupBox;
    ChkDepot: TCheckBox;
    CbbDepot: TComboBox;
    ChkGoodsType: TCheckBox;
    CbbGoodsType: TComboBox;
    CbbInDepotType: TComboBox;
    ChkInDepotType: TCheckBox;
    ChkCreateDate: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    cxGridInDepotChangeStatDBTableView1: TcxGridDBTableView;
    cxGridInDepotChangeStatLevel1: TcxGridLevel;
    cxGridInDepotChangeStat: TcxGrid;
    ppDBPipeline: TppDBPipeline;
    DataSourceDSInDepotStat: TDataSource;
    cxDateEditBegin: TcxDateEdit;
    cxDateEditEnd: TcxDateEdit;
    ChkGoods: TCheckBox;
    CbbGoods: TComboBox;
    RBOrderByTime: TRadioButton;
    RBOrderByName: TRadioButton;
    Btn_Query: TSpeedButton;
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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
    procedure ChkDepotClick(Sender: TObject);
    procedure ChkGoodsTypeClick(Sender: TObject);
    procedure ChkInDepotTypeClick(Sender: TObject);
    procedure CbbGoodsTypeChange(Sender: TObject);
    procedure ChkGoodsClick(Sender: TObject);
    procedure ChkCreateDateClick(Sender: TObject);
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
  FormInDepotStat: TFormInDepotStat;

implementation

uses UnitPublic, UnitMain, UnitDataModule;

{$R *.dfm}

procedure TFormInDepotStat.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridInDepotChangeStat,true,false,true);
end;

procedure TFormInDepotStat.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  cxDateEditBegin.EditValue:= Now;
  cxDateEditEnd.EditValue:= Now;
end;

procedure TFormInDepotStat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormInDepotStat);
end;

procedure TFormInDepotStat.FormDestroy(Sender: TObject);
begin
  FormInDepotStat:= nil;
end;

procedure TFormInDepotStat.Btn_QueryClick(Sender: TObject);
begin
  LoadStatInfo;
end;

procedure TFormInDepotStat.Btn_PrintClick(Sender: TObject);
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
    SQL.Text:= 'SELECT * FROM (SELECT InDepot.*, Depot.DepotName, ' +
               ' Goods1.GoodsTypeID, Goods1.GoodsTypeName, Goods1.GoodsName,' +
               ' InDepotType.InDepotTypeName, User.UserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*InDepot.InDepotNum) AS Cost, (Goods.SalePrice*InDepot.InDepotNum) AS Sale,' +
               ' Depot.DepotName&Goods1.GoodsName&InDepotType.InDepotTypeName AS Merger' +
               ' FROM (((InDepot LEFT JOIN Depot ON InDepot.DepotID = Depot.DepotID) ' +
               ' LEFT JOIN (SELECT Goods.*,GoodsType.GoodsTypeName FROM Goods ' +
               '              LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID) AS Goods1 ' +
               '                ON InDepot.GoodsID = Goods1.GoodsID) ' +
               ' LEFT JOIN User ON InDepot.UserID = User.UserID) ' +
               ' LEFT JOIN InDepotType ON InDepot.InDepotTypeID = InDepotType.InDepotTypeID)' +
               ' WHERE 1=1 ' + GetWhere +
               ' Order by Merger';
    Active:= True;
    DSPrint.DataSet:= lAdoQuery;
  end;
  ppDBPipeline.DataSource:= DSPrint;
  ppReport.Print;
end;

procedure TFormInDepotStat.AddcxGridViewField;
begin
  AddViewField(cxGridInDepotChangeStatDBTableView1,'DepotName','仓库名称',100);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'GoodsTypeName','商品类型');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'GoodsName','商品名称',200);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'InDepotTypeName','入库类型');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'InDepotNum','入库数量');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'CostPrice','成本单价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'SalePrice','销售单价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'Cost','成本价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'Sale','销售价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'CreateTime','入库时间',100);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'ModifyTime','修改时间',100);
end;

function TFormInDepotStat.GetWhere: string;
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
  if ChkInDepotType.Checked then
    lStr:= lStr + ' and InDepotTypeID=' + IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items));
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

procedure TFormInDepotStat.LoadStatInfo;
var
  lSqlStr: string;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    lSqlStr:= 'SELECT * FROM (SELECT InDepot.*, Depot.DepotName, ' +
              ' Goods1.GoodsTypeID, Goods1.GoodsTypeName, Goods1.GoodsName,' +
              ' InDepotType.InDepotTypeName, User.UserName,' +
              ' Goods.CostPrice, Goods.SalePrice,' +
              ' (Goods.CostPrice*InDepot.InDepotNum) AS Cost, (Goods.SalePrice*InDepot.InDepotNum) AS Sale,' +
              ' Depot.DepotName&Goods1.GoodsName&InDepotType.InDepotTypeName AS Merger' +
              ' FROM (((InDepot LEFT JOIN Depot ON InDepot.DepotID = Depot.DepotID) ' +
              ' LEFT JOIN (SELECT Goods.*,GoodsType.GoodsTypeName FROM Goods ' +
              '              LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID) AS Goods1 ' +
              '                ON InDepot.GoodsID = Goods1.GoodsID) ' +
              ' LEFT JOIN User ON InDepot.UserID = User.UserID) ' +
              ' LEFT JOIN InDepotType ON InDepot.InDepotTypeID = InDepotType.InDepotTypeID)' +
              ' WHERE 1=1 ' + GetWhere;
    if RBOrderByTime.Checked then
      lSqlStr:= lSqlStr + ' Order by CreateTime';
    if RBOrderByName.Checked then
      lSqlStr:= lSqlStr + ' Order by Merger';
    SQL.Text:= lSqlStr;
    Active:= True;
    DataSourceDSInDepotStat.DataSet:= AdoQuery;
  end;
end;

procedure TFormInDepotStat.ChkDepotClick(Sender: TObject);
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

procedure TFormInDepotStat.ChkGoodsTypeClick(Sender: TObject);
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

procedure TFormInDepotStat.ChkGoodsClick(Sender: TObject);
begin
//  if ChkGoods.Checked then
//    CbbGoods.Enabled:= True
//  else
//    CbbGoods.Enabled:= False;
end;

procedure TFormInDepotStat.ChkInDepotTypeClick(Sender: TObject);
begin
  if ChkInDepotType.Checked then begin
    CbbInDepotType.Enabled:= True;
    SetItemCode('InDepotType', 'InDepotTypeID', 'InDepotTypeName', ' where InDepotTypeID<>1004', CbbInDepotType.Items);
  end
  else begin
    ClearTStrings(CbbInDepotType.Items);
    CbbInDepotType.Enabled:= False;
  end;
end;

procedure TFormInDepotStat.ChkCreateDateClick(Sender: TObject);
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

procedure TFormInDepotStat.CbbGoodsTypeChange(Sender: TObject);
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
