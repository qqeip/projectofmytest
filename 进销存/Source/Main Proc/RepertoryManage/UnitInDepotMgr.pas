unit UnitInDepotMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls, CxGridUnit, ADODB,
  ppCtrls, ppPrnabl, ppClass, ppDB, ppDBPipe, ppBands, ppCache, ppComm,
  ppRelatv, ppProd, ppReport, ppVar, cxContainer, cxTextEdit, cxMaskEdit,
  cxDropDownEdit;

type
  TFormInDepotMgr = class(TForm)
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    cxGridInDepot: TcxGrid;
    cxGridInDepotDBTableView1: TcxGridDBTableView;
    cxGridInDepotLevel1: TcxGridLevel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Btn_Print: TSpeedButton;
    Btn_Calc: TSpeedButton;
    Label2: TLabel;
    EdtNum: TEdit;
    DataSourceInDeopt: TDataSource;
    ppDBPipeline1: TppDBPipeline;
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
    ppGroup4: TppGroup;
    ppGroupHeaderBand4: TppGroupHeaderBand;
    ppGroupFooterBand4: TppGroupFooterBand;
    ppDBCalc4: TppDBCalc;
    ppDBCalc5: TppDBCalc;
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
    ppDBText10: TppDBText;
    Label5: TLabel;
    CbbGoodsType: TcxComboBox;
    CbbGoods: TcxComboBox;
    CbbDepot: TcxComboBox;
    CbbInDepotType: TcxComboBox;
    ppDBCalc6: TppDBCalc;
    ppDBText11: TppDBText;
    ppDBText12: TppDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
    procedure Btn_CalcClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure EdtNumKeyPress(Sender: TObject; var Key: Char);
    procedure cxGridInDepotDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure CbbGoodsPropertiesChange(Sender: TObject);
    procedure CbbGoodsTypePropertiesCloseUp(Sender: TObject);
  private
    { Private declarations }
    AdoQuery, AdoEdit: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;
    FSalePrice: Double; //商品销售价格

    procedure AddcxGridViewField;
    procedure LoadInDepotInfo;
    //一种商品只能存在一个仓库中 返回库存编号来判断是否商品又存入其他仓库 返回-1表示无库存
    function ISExitOtherRepertory(aGoodsID: Integer): Integer;
    procedure GetSalePrice(aGoodsID: Integer);
    //是否允许修改 如果此商品入库后有此商品的出库记录了 则不允许在进行修改删除操作了
    function IsAllowModify(aGoodsID: Integer; aDateTime: TDateTime): Boolean;
  public
    { Public declarations }
  end;

var
  FormInDepotMgr: TFormInDepotMgr;

implementation

uses UnitMain, UnitPublic, UnitDataModule, UnitPublicResourceManager;

{$R *.dfm}

procedure TFormInDepotMgr.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  AdoEdit:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridInDepot,true,false,true);
  SetItemCode('Depot', 'DepotID', 'DepotName', '', CbbDepot.Properties.Items);
  SetItemCode('GoodsType', 'GoodsTypeID', 'GoodsTypeName', '', CbbGoodsType.Properties.Items);
  SetItemCode('Goods', 'GoodsID', 'GoodsName', '', CbbGoods.Properties.Items);
  SetItemCode('InDepotType', 'InDepotTypeID', 'InDepotTypeName', ' where InDepotTypeID<>1004', CbbInDepotType.Properties.Items);
end;

procedure TFormInDepotMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadInDepotInfo;
end;

procedure TFormInDepotMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormInDepotMgr);
//  Action:= caFree;
//  ClearTStrings(CbbDepot.Properties.Items);
//  ClearTStrings(CbbGoodsType.Properties.Items);
//  ClearTStrings(CbbGoods.Properties.Items);
//  ClearTStrings(CbbInDepotType.Properties.Items);
end;

procedure TFormInDepotMgr.FormDestroy(Sender: TObject);
begin
  FormInDepotMgr:= nil;
end;

procedure TFormInDepotMgr.Btn_AddClick(Sender: TObject);
var
  lGoodsID, lRepertoty_DepotID: Integer;
  lTotalNum: Integer;
  lTotalMoney: Double;
  procedure QueryRepertory(aGoodsID: Integer);
  begin
    lTotalNum:= 0;
    lTotalMoney:= 0;
    with TADOQuery.Create(nil) do
    begin
      try
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'select * from Repertory where GoodsID=' +
                   IntToStr(aGoodsID) ;
        Active:= True;
        if not IsEmpty then
        begin
          lTotalNum:= FieldByName('GoodsNUM').AsInteger;
          lTotalMoney:= FieldByName('GoodsAmount').AsFloat;
        end;
      finally
        Free;
      end;
    end;
  end;
begin
  if CbbDepot.ItemIndex=-1 then
  begin
    Application.MessageBox('请先选择入库仓库！','提示',MB_OK+64);
    Exit;
  end;
  if CbbGoodsType.ItemIndex=-1 then
  begin
    Application.MessageBox('请先选择商品类型！','提示',MB_OK+64);
    Exit;
  end;
  if CbbGoods.ItemIndex=-1 then
  begin
    Application.MessageBox('请先选择商品！','提示',MB_OK+64);
    Exit;
  end;
  if CbbInDepotType.ItemIndex=-1 then
  begin
    Application.MessageBox('请先选择入库类型！','提示',MB_OK+64);
    Exit;
  end;
  lGoodsID:= GetItemCode(CbbGoods.Text, CbbGoods.Properties.Items);
  lRepertoty_DepotID:= ISExitOtherRepertory(lGoodsID);
  if (lRepertoty_DepotID<>-1) and
     (lRepertoty_DepotID<>GetItemCode(CbbDepot.Text, CbbDepot.Properties.Items)) then
  begin
    Application.MessageBox(PChar('一种商品只能存入一个仓库中，此商品在仓库' +
                           IntToStr(lRepertoty_DepotID) +
                           '中已存在，请存入同一个仓库！'),'提示',MB_OK+64);
    Exit;
  end;

  GetSalePrice(lGoodsID); //查询出商品销售价格
  if DM.ADOConnection.InTransaction then  DM.ADOConnection.CommitTrans;
  try
    IsRecordChanged:= True;
    DM.ADOConnection.BeginTrans;
    with AdoEdit do
    begin
      //插入入库记录表
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into InDepot(' +
                 'DepotID,GoodsID, UserID, InDepotTypeID, InDepotNum, CreateTime) ' +
                 'values(' +
                 IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Properties.Items)) + ',' +
                 IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Properties.Items)) + ',' +
                 IntToStr(CurUser.UserID) + ',' +
                 IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Properties.Items)) + ',' +
                 EdtNum.Text + ',' +
                 'cdate(''' + DateTimeToStr(Now) + ''')' +
                 ')';
      ExecSQL;
      //修改库存表数量
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      if lRepertoty_DepotID=-1 then //如果此商品存在库存 则update
        SQL.Text:= 'insert into Repertory(' +
                   'DepotID,GoodsID, GoodsNUM, GoodsAmount) ' +
                   'values(' +
                   IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Properties.Items)) + ',' +
                   IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Properties.Items)) + ',' +
                   EdtNum.Text + ',' +
                   FloatToStr(StrToInt(EdtNum.Text)*FSalePrice) +
                   ')'
      else // 不存在库存 则insert
      begin
        QueryRepertory(GetItemCode(CbbGoods.Text, CbbGoods.Properties.Items));
        lTotalNum:= lTotalNum + StrToInt(EdtNum.Text);
        lTotalMoney:= lTotalMoney + StrToInt(EdtNum.Text)*FSalePrice;
        SQL.Text:= 'update Repertory set ' +
                   ' GoodsNUM=' + IntToStr(lTotalNum) + ',' +
                   ' GoodsAmount=' + FloatToStr(lTotalMoney);
      end;
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadInDepotInfo;
    DM.ADOConnection.CommitTrans;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormInDepotMgr.Btn_ModifyClick(Sender: TObject);
var
  lDiffNum: Integer;
begin
  if CbbDepot.ItemIndex=-1 then
  begin
    Application.MessageBox('请先选择入库仓库！','提示',MB_OK+64);
    Exit;
  end;
  if CbbGoodsType.ItemIndex=-1 then
  begin
    Application.MessageBox('请先选择商品类型！','提示',MB_OK+64);
    Exit;
  end;
  if CbbInDepotType.ItemIndex=-1 then
  begin
    Application.MessageBox('请先选择入库类型！','提示',MB_OK+64);
    Exit;
  end;
  if not IsAllowModify(AdoQuery.FieldByName('GoodsID').AsInteger,AdoQuery.FieldByName('CreateTime').AsDateTime) then
  begin
    Application.MessageBox('此商品已有出库记录，不再允许修改删除操作！','提示',MB_OK+64);
    Exit;
  end;
  GetSalePrice(AdoQuery.FieldByName('GoodsID').AsInteger);
  if DM.ADOConnection.InTransaction then  DM.ADOConnection.CommitTrans;
  try
    IsRecordChanged:= True;
    DM.ADOConnection.BeginTrans;
    with AdoEdit do
    begin
      //修改前往历史表插记录
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into InDepotHistory(' +
                 'Old_DepotID, Old_GoodsID, Old_UserID, Old_InDepotTypeID, Old_InDepotNum,'+
                 'New_DepotID, New_GoodsID, New_UserID, New_InDepotTypeID, New_InDepotNum,' +
                 'OperateType, CreateTime) ' +
                 'values(' +
                 AdoQuery.FieldByName('DepotID').AsString + ',' +
                 AdoQuery.FieldByName('GoodsID').AsString + ',' +
                 AdoQuery.FieldByName('UserID').AsString + ',' +
                 AdoQuery.FieldByName('InDepotTypeID').AsString + ',' +
                 AdoQuery.FieldByName('InDepotNum').AsString + ',' +
                 IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Properties.Items)) + ',' +
                 IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Properties.Items)) + ',' +
                 IntToStr(CurUser.UserID) + ',' +
                 IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Properties.Items)) + ',' +
                 EdtNum.Text + ',' +
                 '1,' +
                 'cdate(''' + DateTimeToStr(Now) + '''))';
      ExecSQL;
      //保留历史后再修改
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'update InDepot set ' +
                 'DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Properties.Items)) + ',' +
                 'GoodsID=' + IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Properties.Items)) + ',' +
                 'UserID=' + IntToStr(CurUser.UserID) + ',' +
                 'InDepotTypeID=' + IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Properties.Items)) + ',' +
                 'InDepotNum=' + EdtNum.Text + ',' +
                 'ModifyTime=cdate(''' + DateTimeToStr(Now) + ''')' +
                 ' where ID=' + AdoQuery.FieldByName('ID').AsString;
      ExecSQL;
      //修改入库记录后 在修改库存数量
      lDiffNum:= AdoQuery.FieldByName('InDepotNum').AsInteger-StrToInt(EdtNum.Text);
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'update Repertory set ' +
                 'GoodsNUM=GoodsNUM-' + IntToStr(lDiffNum) + ',' +
                 'GoodsAmount= GoodsAmount-' + FloatToStr(lDiffNum * FSalePrice) +
                 ' where GoodsID=' + IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Properties.Items));
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadInDepotInfo;
    DM.ADOConnection.CommitTrans;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    DM.ADOConnection.RollbackTrans;
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormInDepotMgr.Btn_DeleteClick(Sender: TObject);
var
  lSqlStr: string;
  lNum: Integer;
begin
  if not IsAllowModify(AdoQuery.FieldByName('GoodsID').AsInteger,AdoQuery.FieldByName('CreateTime').AsDateTime) then
  begin
    Application.MessageBox('此商品已有出库记录，不再允许修改删除操作！','提示',MB_OK+64);
    Exit;
  end;
  GetSalePrice(AdoQuery.FieldByName('GoodsID').AsInteger);
  if DM.ADOConnection.InTransaction then  DM.ADOConnection.CommitTrans;
  try
    DM.ADOConnection.BeginTrans;
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      //删除前往历史表插记录
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into InDepotHistory(' +
                 'Old_DepotID, Old_GoodsID, Old_UserID, Old_InDepotTypeID, Old_InDepotNum,'+
                 'New_DepotID, New_GoodsID, New_UserID, New_InDepotTypeID, New_InDepotNum,' +
                 'OperateType, CreateTime) ' +
                 'values(' +
                 AdoQuery.FieldByName('DepotID').AsString + ',' +
                 AdoQuery.FieldByName('GoodsID').AsString + ',' +
                 AdoQuery.FieldByName('UserID').AsString + ',' +
                 AdoQuery.FieldByName('InDepotTypeID').AsString + ',' +
                 AdoQuery.FieldByName('InDepotNum').AsString + ',' +
                 '-1,-1,' +IntToStr(CurUser.UserID) + ',-1,0,2,' +
                 'cdate(''' + DateTimeToStr(Now) + '''))';
      ExecSQL;
      //保留历史后再删除
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lSqlStr:= 'delete from InDepot where ID=' + AdoQuery.FieldByName('ID').AsString;
      SQL.Add(lSqlStr);
      ExecSQL;
      //删除后更新库存数量
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lNum:= AdoQuery.FieldByName('InDepotNum').AsInteger;
      lSqlStr:= 'update Repertory set ' +
                 'GoodsNUM=GoodsNUM-' + IntToStr(lNum) + ',' +
                 'GoodsAmount= GoodsAmount-' + FloatToStr(lNum * FSalePrice) +
                 ' where GoodsID=' + AdoQuery.FieldByName('GoodsID').AsString;
      SQL.Add(lSqlStr);
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadInDepotInfo;
    DM.ADOConnection.CommitTrans;
    Application.MessageBox('删除成功！','提示',MB_OK+64);
  except
    DM.ADOConnection.RollbackTrans;
    Application.MessageBox('删除失败！','提示',MB_OK+64);
  end;
end;

procedure TFormInDepotMgr.Btn_PrintClick(Sender: TObject);
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
    SQL.Text:= 'SELECT * FROM (SELECT InDepot.*, Depot.DepotName, Goods1.GoodsTypeName, Goods1.GoodsName,' +
               ' InDepotType.InDepotTypeName, User.UserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*InDepot.InDepotNum) AS Cost, (Goods.SalePrice*InDepot.InDepotNum) AS Sale,' +
               ' Depot.DepotName&Goods1.GoodsName&InDepotType.InDepotTypeName AS Merger' +
               ' FROM (((InDepot LEFT JOIN Depot ON InDepot.DepotID = Depot.DepotID) ' +
               ' LEFT JOIN (SELECT Goods.*,GoodsType.GoodsTypeID,GoodsType.GoodsTypeName FROM Goods ' +
               '              LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID) AS Goods1 ' +
               '                ON InDepot.GoodsID = Goods1.GoodsID) ' +
               ' LEFT JOIN User ON InDepot.UserID = User.UserID) ' +
               ' LEFT JOIN InDepotType ON InDepot.InDepotTypeID = InDepotType.InDepotTypeID)' +
               ' Order by Merger';
    Active:= True;
    DSPrint.DataSet:= lAdoQuery;
  end;
  ppDBPipeline1.DataSource:= DSPrint;
  ppReport.Print;
end;

procedure TFormInDepotMgr.Btn_CalcClick(Sender: TObject);
begin
  winexec('calc.exe',sw_normal);
end;

procedure TFormInDepotMgr.Btn_CloseClick(Sender: TObject);
begin
  FormMain.RemoveForm(FormInDepotMgr);
end;

procedure TFormInDepotMgr.AddcxGridViewField;
begin
  AddViewField(cxGridInDepotDBTableView1,'DepotName','仓库名称',100);
  AddViewField(cxGridInDepotDBTableView1,'GoodsTypeName','商品类型');
  AddViewField(cxGridInDepotDBTableView1,'GoodsName','商品名称',200);
  AddViewField(cxGridInDepotDBTableView1,'InDepotTypeName','入库类型');
  AddViewField(cxGridInDepotDBTableView1,'InDepotNum','入库数量');
  AddViewField(cxGridInDepotDBTableView1,'CostPrice','成本单价');
  AddViewField(cxGridInDepotDBTableView1,'SalePrice','销售单价');
  AddViewField(cxGridInDepotDBTableView1,'Cost','成本价');
  AddViewField(cxGridInDepotDBTableView1,'Sale','销售价');
  AddViewField(cxGridInDepotDBTableView1,'CreateTime','入库时间',100);
  AddViewField(cxGridInDepotDBTableView1,'ModifyTime','修改时间',100);
end;

procedure TFormInDepotMgr.LoadInDepotInfo;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT * FROM (SELECT InDepot.*, Depot.DepotName, Goods1.GoodsTypeName, Goods1.GoodsName,' +
               ' InDepotType.InDepotTypeName, User.UserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*InDepot.InDepotNum) AS Cost, (Goods.SalePrice*InDepot.InDepotNum) AS Sale,' +
               ' Depot.DepotName&Goods1.GoodsName&InDepotType.InDepotTypeName AS Merger' +
               ' FROM (((InDepot LEFT JOIN Depot ON InDepot.DepotID = Depot.DepotID) ' +
               ' LEFT JOIN (SELECT Goods.*,GoodsType.GoodsTypeID,GoodsType.GoodsTypeName FROM Goods ' +
               '              LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID) AS Goods1 ' +
               '                ON InDepot.GoodsID = Goods1.GoodsID) ' +
               ' LEFT JOIN User ON InDepot.UserID = User.UserID) ' +
               ' LEFT JOIN InDepotType ON InDepot.InDepotTypeID = InDepotType.InDepotTypeID)' +
               ' Order by CreateTime';
    Active:= True;
    DataSourceInDeopt.DataSet:= AdoQuery;
  end;
end;

procedure TFormInDepotMgr.EdtNumKeyPress(Sender: TObject; var Key: Char);
begin
  InPutChar(Key);
end;

procedure TFormInDepotMgr.cxGridInDepotDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  SetItemCode('Goods', 'GoodsID', 'GoodsName', ' ', CbbGoods.Properties.Items);
  with AdoQuery do
  begin
    CbbDepot.ItemIndex:= CbbDepot.Properties.Items.IndexOf(FieldByName('DepotName').AsString);
    CbbGoodsType.ItemIndex:= CbbGoodsType.Properties.Items.IndexOf(FieldByName('GoodsTypeName').AsString);
    CbbGoods.ItemIndex:= CbbGoods.Properties.Items.IndexOf(FieldByName('GoodsName').AsString);
    CbbInDepotType.ItemIndex:= CbbInDepotType.Properties.Items.IndexOf(FieldByName('InDepotTypeName').AsString);
    EdtNum.Text:= FieldByName('InDepotNum').AsString;
  end;
end;

procedure TFormInDepotMgr.CbbGoodsPropertiesChange(Sender: TObject);
//var
//  lGoodsID: Integer;
//  lAdoQuery: TADOQuery;
begin
//  lGoodsID:= GetItemCode(CbbGoods.Text, CbbGoods.Properties.Items);
//  if lGoodsID>-1 then
//  begin
//    lAdoQuery:= TADOQuery.Create(nil);
//    with lAdoQuery do
//    begin
//      try
//        Active:= False;
//        Connection:= DM.ADOConnection;
//        SQL.Clear;
//        SQL.Text:= 'SELECT Goods.*,GoodsType.GoodsTypeID,GoodsType.GoodsTypeName FROM Goods ' +
//                   ' LEFT JOIN GoodsType ON Goods.GoodsTypeID = GoodsType.GoodsTypeID ' +
//                   ' WHERE Goods.GoodsID=' + IntToStr(lGoodsID);
//        Active:= True;
//        if RecordCount=1 then
//          CbbGoodsType.ItemIndex:= CbbGoodsType.Properties.Items.IndexOf(FieldByName('GoodsTypeName').AsString)
//        else
//          Exit;
//      finally
//        Free;
//      end;
//    end;
//  end;
end;

procedure TFormInDepotMgr.CbbGoodsTypePropertiesCloseUp(Sender: TObject);
var
  lGoodsTypeID: Integer;
  lWhereStr: string;
begin
  lGoodsTypeID:= GetItemCode(CbbGoodsType.Text, CbbGoodsType.Properties.Items);
  ClearTStrings(CbbGoods.Properties.Items);
  if lGoodsTypeID>-1 then
  begin
    lWhereStr:= ' where GoodsTypeID=' + IntToStr(lGoodsTypeID);
    SetItemCode('Goods', 'GoodsID', 'GoodsName', lWhereStr, CbbGoods.Properties.Items);
  end
  else
    SetItemCode('Goods', 'GoodsID', 'GoodsName', ' ', CbbGoods.Properties.Items);
end;

function TFormInDepotMgr.ISExitOtherRepertory(aGoodsID: Integer): Integer;
begin
  Result:= -1;
  with TAdoQuery.Create(nil) do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'select * from Repertory where GoodsID=' +
                 IntToStr(aGoodsID) ;
      Active:= True;
      if IsEmpty then
        Result:= -1
      else
        Result:= FieldByName('DepotID').AsInteger;
    finally
      Free;
    end;
  end;
end;

procedure TFormInDepotMgr.GetSalePrice(aGoodsID: Integer);
begin
  FSalePrice:= 0;
  with TADOQuery.Create(nil) do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'select * from Goods where GoodsID=' +
                 IntToStr(aGoodsID) ;
      Active:= True;
      if not IsEmpty then
        FSalePrice:= FieldByName('SalePrice').AsFloat;
    finally
      Free;
    end;
  end;
end;

function TFormInDepotMgr.IsAllowModify(aGoodsID: Integer;
  aDateTime: TDateTime): Boolean;
begin
  Result:= False;
  with TADOQuery.Create(nil) do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'select * from OutDepotDetails where GoodsID=' +
                 IntToStr(aGoodsID) +
                 ' and CreateTime>=' +
                 'cdate(''' + DateTimeToStr(aDateTime) + ''')';
      Active:= True;
      if IsEmpty then
        Result:= True
      else
        Result:= False;
    finally
      Free;
    end;
  end;

end;

end.
