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
    Btn_Query: TSpeedButton;
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
    ppReport: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppLabel1: TppLabel;
    ppLine2: TppLine;
    ppLabel3: TppLabel;
    ppSystemVariable2: TppSystemVariable;
    ppLabel4: TppLabel;
    ppLabel5: TppLabel;
    ppSystemVariable3: TppSystemVariable;
    ppLabel6: TppLabel;
    ppLine13: TppLine;
    ppLine14: TppLine;
    ppLine15: TppLine;
    ppLine16: TppLine;
    ppLine17: TppLine;
    ppLine18: TppLine;
    ppLine19: TppLine;
    ppLine20: TppLine;
    ppLine21: TppLine;
    ppLine22: TppLine;
    ppLine23: TppLine;
    ppLabel7: TppLabel;
    ppLabel8: TppLabel;
    ppLabel9: TppLabel;
    ppLabel10: TppLabel;
    ppLabel11: TppLabel;
    ppLabel12: TppLabel;
    ppLabel13: TppLabel;
    ppLabel14: TppLabel;
    ppLabel15: TppLabel;
    ppDetailBand1: TppDetailBand;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppDBText9: TppDBText;
    ppLine1: TppLine;
    ppLine3: TppLine;
    ppLine4: TppLine;
    ppLine5: TppLine;
    ppLine6: TppLine;
    ppLine7: TppLine;
    ppLine8: TppLine;
    ppLine9: TppLine;
    ppLine10: TppLine;
    ppLine11: TppLine;
    ppLine12: TppLine;
    ppFooterBand1: TppFooterBand;
    ppLabel2: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppLabel18: TppLabel;
    ppSummaryBand1: TppSummaryBand;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppDBCalc3: TppDBCalc;
    ppLine35: TppLine;
    ppLine36: TppLine;
    ppLine39: TppLine;
    ppLine40: TppLine;
    ppLine41: TppLine;
    ppLine42: TppLine;
    ppLine43: TppLine;
    ppLine44: TppLine;
    ppLine45: TppLine;
    ppLabel17: TppLabel;
    ppDBText13: TppDBText;
    ppDBText14: TppDBText;
    ppGroup4: TppGroup;
    ppGroupHeaderBand4: TppGroupHeaderBand;
    ppGroupFooterBand4: TppGroupFooterBand;
    ppDBCalc4: TppDBCalc;
    ppDBCalc5: TppDBCalc;
    ppDBCalc6: TppDBCalc;
    ppLine24: TppLine;
    ppLine25: TppLine;
    ppLine28: TppLine;
    ppLine29: TppLine;
    ppLine30: TppLine;
    ppLine31: TppLine;
    ppLine32: TppLine;
    ppLine33: TppLine;
    ppLine34: TppLine;
    ppLabel16: TppLabel;
    ppDBText11: TppDBText;
    ppDBText12: TppDBText;
    ppDBText10: TppDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
    procedure ChkDepotClick(Sender: TObject);
    procedure ChkGoodsTypeClick(Sender: TObject);
    procedure ChkInDepotTypeClick(Sender: TObject);
  private
    { Private declarations }
    AdoQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;

    procedure AddcxGridViewField;
    procedure LoadStatInfo;
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
begin
  if not AdoQuery.Active then
  begin
    Application.MessageBox('请先选择查询条件进行查询！','提示',MB_OK+64);
    Exit;
  end;
  ppReport.Print;
end;

procedure TFormInDepotStat.AddcxGridViewField;
begin
  AddViewField(cxGridInDepotChangeStatDBTableView1,'DepotName','仓库名称',100);
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

procedure TFormInDepotStat.LoadStatInfo;
  function GetWhere: string;
  var
    lStr: string;
    lBeginDateTime, lEndDateTime: string;
  begin
    Result:= '';
    lStr:= '';
    if ChkDepot.Checked then
      lStr:= lStr + ' and InDepot.DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items));
    if ChkGoodsType.Checked then
      lStr:= lStr + ' and InDepot.GoodsID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items));
    if ChkInDepotType.Checked then
      lStr:= lStr + ' and InDepot.InDepotTypeID=' + IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items));
    if ChkCreateDate.Checked then
    begin
      lBeginDateTime:= DateTimeToStr(cxDateEditBegin.EditingValue);
      lEndDateTime:= DateTimeToStr(cxDateEditEnd.EditingValue);
      lStr:= lStr + ' and InDepot.CreateTime between cdate(''' + lBeginDateTime
                  + ''') and cdate(''' + lEndDateTime
                  + ''')';
    end;

    Result:= lStr;
  end;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT * FROM (SELECT InDepot.*, Depot.DepotName, Goods.GoodsName, InDepotType.InDepotTypeName, User.UserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*InDepot.InDepotNum) AS Cost, (Goods.SalePrice*InDepot.InDepotNum) AS Sale, ' +
               ' Depot.DepotName&Goods.GoodsName&InDepotType.InDepotTypeName AS Merger' +
               ' FROM (((InDepot LEFT JOIN Depot ON InDepot.DepotID=Depot.DepotID) ' +
               ' LEFT JOIN Goods ON InDepot.GoodsID=Goods.GoodsID) ' +
               ' INNER JOIN [User] ON InDepot.UserID=User.UserID) ' +
               ' INNER JOIN InDepotType ON InDepot.InDepotTypeID=InDepotType.InDepotTypeID' +
               ' Where 1=1 ' + GetWhere +
               ' )Order by Merger';
    Active:= True;
    DataSourceDSInDepotStat.DataSet:= AdoQuery;
  end;
end;

procedure TFormInDepotStat.ChkDepotClick(Sender: TObject);
begin
  if ChkDepot.Checked then
    SetItemCode('Depot', 'DepotID', 'DepotName', '', CbbDepot.Items)
  else
    ClearTStrings(CbbDepot.Items);
end;

procedure TFormInDepotStat.ChkGoodsTypeClick(Sender: TObject);
begin
  if ChkGoodsType.Checked then
    SetItemCode('Goods', 'GoodsID', 'GoodsName', '', CbbGoodsType.Items)
  else
    ClearTStrings(CbbGoodsType.Items);
end;

procedure TFormInDepotStat.ChkInDepotTypeClick(Sender: TObject);
begin
  if ChkInDepotType.Checked then
    SetItemCode('InDepotType', 'InDepotTypeID', 'InDepotTypeName', ' where InDepotTypeID<>1004', CbbInDepotType.Items)
  else
    ClearTStrings(CbbInDepotType.Items);
end;

end.
