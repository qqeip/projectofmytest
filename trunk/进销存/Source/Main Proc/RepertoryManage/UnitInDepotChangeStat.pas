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
    ChkGoods: TCheckBox;
    CbbGoods: TComboBox;
    RBOrderByTime: TRadioButton;
    RBOrderByName: TRadioButton;
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
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldGoodsTypeName','原商品类别');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldGoodsName','原商品名称',200);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldInDepotTypeName','原入库类型');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'Old_InDepotNum','原入库数量');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldUserName','入库操作员');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewDepotName','新仓库名称',100);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewGoodsTypeName','新商品类别');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewGoodsName','新商品名称',200);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewInDepotTypeName','新入库类型');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'New_InDepotNum','新入库数量');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewUserName','修改操作员');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'CreateTime','修改时间',100);
  AddViewField(cxGridInDepotChangeStatDBTableView1,'CostPrice','成本单价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'SalePrice','销售单价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldCost','原成本总价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'OldSale','原销售总价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewCost','新成本总价');
  AddViewField(cxGridInDepotChangeStatDBTableView1,'NewSale','新销售总价');
end;

function TFormInDepotChangeStat.GetWhere: string;
var
  lStr: string;
  lBeginDateTime, lEndDateTime: string;
begin
  Result:= '';
  lStr:= '';
  if ChkDepot.Checked then
    lStr:= lStr + ' and Old_DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items));
  if ChkGoodsType.Checked then
    lStr:= lStr + ' and OldGoods.GoodsTypeID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items));
  if ChkGoods.Checked then
    lStr:= lStr + ' and Old_GoodsID=' + IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Items));
  if ChkInDepotType.Checked then
    lStr:= lStr + ' and Old_InDepotTypeID=' + IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items));
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

procedure TFormInDepotChangeStat.LoadStatInfo;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT InDepotHistory.*, ' +
               ' IIf(OperateType=1,''修改'',iif(OperateType=2,''删除'')) AS OperateTypeName, ' +
               ' Depot.DepotName AS OldDepotName, NewDepot.DepotName AS NewDepotName, ' +
               ' OldGoods.GoodsTypeName AS OldGoodsTypeName, NewGoods.GoodsTypeName AS NewGoodsTypeName, ' +
               ' OldGoods.GoodsName AS OldGoodsName, NewGoods.GoodsName AS NewGoodsName, ' +
               ' InDepotType.InDepotTypeName AS OldInDepotTypeName, NewInDepotType.InDepotTypeName AS NewInDepotTypeName,' +
               ' User.UserName AS OldUserName, NewUser.UserName AS NewUserName,' +
               ' OldGoods.CostPrice, OldGoods.SalePrice,' +
               ' (OldGoods.CostPrice*InDepotHistory.Old_InDepotNum) AS OldCost,' +
               ' (OldGoods.SalePrice*InDepotHistory.Old_InDepotNum) AS OldSale,' +
               ' (NewGoods.CostPrice*InDepotHistory.New_InDepotNum) AS NewCost,' +
               ' (NewGoods.SalePrice*InDepotHistory.New_InDepotNum) AS NewSale' +
               //' Depot.DepotName&Goods.GoodsName&InDepotType.InDepotTypeName AS Merger' +
               ' FROM (((((((InDepotHistory LEFT JOIN Depot ON InDepotHistory.Old_DepotID=Depot.DepotID)' +
               ' LEFT JOIN (SELECT Goods.*,GoodsType.GoodsTypeName FROM Goods ' +
               '              LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID) AS OldGoods ' +
               '                ON InDepotHistory.Old_GoodsID = OldGoods.GoodsID) ' +
               //' LEFT JOIN Goods ON InDepotHistory.Old_GoodsID=Goods.GoodsID)' +
               ' LEFT JOIN InDepotType ON InDepotHistory.Old_InDepotTypeID=InDepotType.InDepotTypeID)' +
               ' LEFT JOIN User ON InDepotHistory.Old_UserID=User.UserID)' +
               ' LEFT JOIN Depot AS NewDepot ON InDepotHistory.New_DepotID=NewDepot.DepotID)' +
               ' LEFT JOIN (SELECT Goods.*,GoodsType.GoodsTypeName FROM Goods ' +
               '              LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID) AS NewGoods ' +
               '                ON InDepotHistory.New_GoodsID = NewGoods.GoodsID) ' +
               //' LEFT JOIN Goods AS NewGoods ON InDepotHistory.New_GoodsID=NewGoods.GoodsID)' +
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
  if ChkDepot.Checked then begin
    CbbDepot.Enabled:= True;
    SetItemCode('Depot', 'DepotID', 'DepotName', '', CbbDepot.Items);
  end
  else begin
    ClearTStrings(CbbDepot.Items);
    CbbDepot.Enabled:= False;
  end;
end;

procedure TFormInDepotChangeStat.ChkGoodsTypeClick(Sender: TObject);
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

procedure TFormInDepotChangeStat.ChkInDepotTypeClick(Sender: TObject);
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

procedure TFormInDepotChangeStat.CbbGoodsTypeChange(Sender: TObject);
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

procedure TFormInDepotChangeStat.ChkCreateDateClick(Sender: TObject);
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

end.
