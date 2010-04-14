unit UnitInDepotChangeStat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ppDB, ppDBPipe, ppBands, ppClass,
  ppCtrls, ppVar, ppPrnabl, ppCache, ppComm, ppRelatv, ppProd, ppReport,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ExtCtrls, cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, StdCtrls, Buttons, CxGridUnit, ADODB;

type
  TFormInDepotChangeStat = class(TForm)
    pnl1: TPanel;
    grp1: TGroupBox;
    Btn_Print: TSpeedButton;
    Btn_Query: TSpeedButton;
    grp2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ChkDepot: TCheckBox;
    CbbDepot: TComboBox;
    ChkGoodsType: TCheckBox;
    CbbGoodsType: TComboBox;
    CbbInDepotType: TComboBox;
    ChkInDepotType: TCheckBox;
    ChkCreateDate: TCheckBox;
    cxDateEditBegin: TcxDateEdit;
    cxDateEditEnd: TcxDateEdit;
    spl1: TSplitter;
    pnl2: TPanel;
    cxGridInDepotChangeStat: TcxGrid;
    cxGridInDepotChangeStatDBTableView1: TcxGridDBTableView;
    cxGridInDepotChangeStatLevel1: TcxGridLevel;
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
    ppDBPipeline: TppDBPipeline;
    DSInDepotChangeStat: TDataSource;
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
  FormInDepotChangeStat: TFormInDepotChangeStat;

implementation

uses UnitMain, UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormInDepotChangeStat.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridInDepotChangeStat,true,false,true);
end;

procedure TFormInDepotChangeStat.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  cxDateEditBegin.EditValue:= Now;
  cxDateEditEnd.EditValue:= Now;
end;

procedure TFormInDepotChangeStat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormInDepotChangeStat);
end;

procedure TFormInDepotChangeStat.FormDestroy(Sender: TObject);
begin
  FormInDepotChangeStat:= nil;
end;

procedure TFormInDepotChangeStat.AddcxGridViewField;
begin
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OperateTypeName','操作类型');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldDepotName','原仓库名称',100);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldGoodsName','原商品名称',200);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldInDepotTypeName','原入库类型');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'Old_InDepotNum','原入库数量');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldUserName','入库操作员');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewDepotName','新仓库名称',100);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewGoodsName','新商品名称',200);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewInDepotTypeName','新入库类型');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'New_InDepotNum','新入库数量');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewUserName','修改操作员');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'CreateTime','修改时间',100);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'CostPrice','成本单价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'SalePrice','销售单价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldCost','原成本价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldSale','原销售价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewCost','新成本价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewSale','新销售价');
end;

procedure TFormInDepotChangeStat.LoadStatInfo;
  function GetWhere: string;
  var
    lStr: string;
    lBeginDateTime, lEndDateTime: string;
  begin
    Result:= '';
    lStr:= '';
    if ChkDepot.Checked then
      lStr:= lStr + ' and InDepotHistory.Old_DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items));
    if ChkGoodsType.Checked then
      lStr:= lStr + ' and InDepotHistory.Old_GoodsID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items));
    if ChkInDepotType.Checked then
      lStr:= lStr + ' and InDepotHistory.Old_InDepotTypeID=' + IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items));
    if ChkCreateDate.Checked then
    begin
      lBeginDateTime:= DateTimeToStr(cxDateEditBegin.EditingValue);
      lEndDateTime:= DateTimeToStr(cxDateEditEnd.EditingValue);
      lStr:= lStr + ' and InDepotHistory.CreateTime between cdate(''' + lBeginDateTime
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
    SQL.Text:= 'SELECT InDepotHistory.*, ' +
               ' IIf(OperateType=1,''修改'',iif(OperateType=2,''删除'')) AS OperateTypeName, ' +
               ' Depot.DepotName AS OldDepotName, NewDepot.DepotName AS NewDepotName, ' +
               ' Goods.GoodsName AS OldGoodsName, NewGoods.GoodsName AS NewGoodsName, ' +
               ' InDepotType.InDepotTypeName AS OldInDepotTypeName, NewInDepotType.InDepotTypeName AS NewInDepotTypeName,' +
               ' User.UserName AS OldUserName, NewUser.UserName AS NewUserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*InDepotHistory.Old_InDepotNum) AS OldCost,' +
               ' (Goods.SalePrice*InDepotHistory.Old_InDepotNum) AS OldSale,' +
               ' (Goods.CostPrice*InDepotHistory.New_InDepotNum) AS NewCost, (Goods.SalePrice*InDepotHistory.New_InDepotNum) AS NewSale' +
               //' Depot.DepotName&Goods.GoodsName&InDepotType.InDepotTypeName AS Merger' +
               ' FROM (((((((InDepotHistory LEFT JOIN Depot ON InDepotHistory.Old_DepotID=Depot.DepotID)' +
               ' LEFT JOIN Goods ON InDepotHistory.Old_GoodsID=Goods.GoodsID)' +
               ' LEFT JOIN InDepotType ON InDepotHistory.Old_InDepotTypeID=InDepotType.InDepotTypeID)' +
               ' LEFT JOIN User ON InDepotHistory.Old_UserID=User.UserID)' +
               ' LEFT JOIN Depot AS NewDepot ON InDepotHistory.New_DepotID=NewDepot.DepotID)' +
               ' LEFT JOIN Goods AS NewGoods ON InDepotHistory.New_GoodsID=NewGoods.GoodsID)' +
               ' LEFT JOIN InDepotType AS NewInDepotType ON InDepotHistory.New_InDepotTypeID=NewInDepotType.InDepotTypeID)' +
               ' LEFT JOIN User AS NewUser ON InDepotHistory.New_UserID=NewUser.UserID' +
               ' Where 1=1' + GetWhere +
              // ') Order by Merger';CreateTime
               ' Order by CreateTime';
    Active:= True;
    DSInDepotChangeStat.DataSet:= AdoQuery;
  end;
end;

procedure TFormInDepotChangeStat.Btn_QueryClick(Sender: TObject);
begin
  LoadStatInfo;
end;

procedure TFormInDepotChangeStat.Btn_PrintClick(Sender: TObject);
begin
  if not AdoQuery.Active then
  begin
    Application.MessageBox('请先选择查询条件进行查询！','提示',MB_OK+64);
    Exit;
  end;
  ppReport.Print;
end;

procedure TFormInDepotChangeStat.ChkDepotClick(Sender: TObject);
begin
  if ChkDepot.Checked then
    SetItemCode('Depot', 'DepotID', 'DepotName', '', CbbDepot.Items)
  else
    ClearTStrings(CbbDepot.Items);
end;

procedure TFormInDepotChangeStat.ChkGoodsTypeClick(Sender: TObject);
begin
  if ChkGoodsType.Checked then
    SetItemCode('Goods', 'GoodsID', 'GoodsName', '', CbbGoodsType.Items)
  else
    ClearTStrings(CbbGoodsType.Items);
end;

procedure TFormInDepotChangeStat.ChkInDepotTypeClick(Sender: TObject);
begin
  if ChkInDepotType.Checked then
    SetItemCode('InDepotType', 'InDepotTypeID', 'InDepotTypeName', ' where InDepotTypeID<>1004', CbbInDepotType.Items)
  else
    ClearTStrings(CbbInDepotType.Items);
end;

end.
