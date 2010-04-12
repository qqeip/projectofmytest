unit UnitInDepotMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls, CxGridUnit, ADODB,
  ppCtrls, ppPrnabl, ppClass, ppDB, ppDBPipe, ppBands, ppCache, ppComm,
  ppRelatv, ppProd, ppReport, ppVar;

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
    CbbDepot: TComboBox;
    Label3: TLabel;
    CbbGoodsType: TComboBox;
    Label4: TLabel;
    CbbInDepotType: TComboBox;
    Btn_Print: TSpeedButton;
    Btn_Calc: TSpeedButton;
    Label2: TLabel;
    EdtNum: TEdit;
    DataSourceInDeopt: TDataSource;
    ppReport: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppDBPipeline1: TppDBPipeline;
    ppLabel1: TppLabel;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppDBText4: TppDBText;
    ppDBText5: TppDBText;
    ppDBText6: TppDBText;
    ppLabel2: TppLabel;
    ppDBText7: TppDBText;
    ppDBText8: TppDBText;
    ppDBText9: TppDBText;
    ppLine1: TppLine;
    ppLine2: TppLine;
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
    ppSummaryBand1: TppSummaryBand;
    ppDBCalc1: TppDBCalc;
    ppDBCalc2: TppDBCalc;
    ppDBCalc3: TppDBCalc;
    ppGroup1: TppGroup;
    ppGroupHeaderBand1: TppGroupHeaderBand;
    ppGroupFooterBand1: TppGroupFooterBand;
    ppDBCalc4: TppDBCalc;
    ppDBCalc5: TppDBCalc;
    ppDBCalc6: TppDBCalc;
    ppSystemVariable1: TppSystemVariable;
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
    ppLine24: TppLine;
    ppLine25: TppLine;
    ppLine28: TppLine;
    ppLine29: TppLine;
    ppLine30: TppLine;
    ppLine31: TppLine;
    ppLine32: TppLine;
    ppLine33: TppLine;
    ppLine34: TppLine;
    ppLine35: TppLine;
    ppLine36: TppLine;
    ppLine39: TppLine;
    ppLine40: TppLine;
    ppLine41: TppLine;
    ppLine42: TppLine;
    ppLine43: TppLine;
    ppLine44: TppLine;
    ppLine45: TppLine;
    ppLabel16: TppLabel;
    ppLabel17: TppLabel;
    ppDBText11: TppDBText;
    ppDBText12: TppDBText;
    ppDBText13: TppDBText;
    ppDBText14: TppDBText;
    ppLabel18: TppLabel;
    ppGroup2: TppGroup;
    ppGroupHeaderBand2: TppGroupHeaderBand;
    ppGroupFooterBand2: TppGroupFooterBand;
    ppGroup3: TppGroup;
    ppGroupHeaderBand3: TppGroupHeaderBand;
    ppGroupFooterBand3: TppGroupFooterBand;
    ppDBText10: TppDBText;
    ppDBText15: TppDBText;
    ppDBText16: TppDBText;
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
  private
    { Private declarations }
    AdoQuery, AdoEdit: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;

    procedure AddcxGridViewField;
    procedure LoadInDepotInfo;
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
  SetItemCode('Depot', 'DepotID', 'DepotName', '', CbbDepot.Items);
  SetItemCode('Goods', 'GoodsID', 'GoodsName', '', CbbGoodsType.Items);
  SetItemCode('InDepotType', 'InDepotTypeID', 'InDepotTypeName', ' where InDepotTypeID<>1004', CbbInDepotType.Items);
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
end;

procedure TFormInDepotMgr.FormDestroy(Sender: TObject);
begin
  FormInDepotMgr:= nil;
end;

procedure TFormInDepotMgr.Btn_AddClick(Sender: TObject);
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
  try
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into InDepot(' +
                 'DepotID,GoodsID, UserID, InDepotTypeID, InDepotNum, CreateTime) ' +
                 'values(' +
                 IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items)) + ',' +
                 IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items)) + ',' +
                 IntToStr(CurUser.UserID) + ',' +
                 IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items)) + ',' +
                 EdtNum.Text + ',' +
                 'cdate(''' + DateTimeToStr(Now) + ''')' +
                 ')';

      {SQL.Text:= 'insert into InDepot(' +
                 'DepotID,GoodsID, UserID, InDepotTypeID, InDepotNum, CreateTime) ' +
                 'values(:DepotID,:GoodsID,:UserID,:InDepotTypeID,:InDepotNum,:CreateTime)';
      Parameters.ParamByName('DepotID').DataType:= ftInteger;
      Parameters.ParamByName('DepotID').Direction:=pdInput;
      Parameters.ParamByName('GoodsID').DataType:= ftInteger;
      Parameters.ParamByName('UserID').DataType:= ftInteger;
      Parameters.ParamByName('InDepotTypeID').DataType:= ftInteger;
      Parameters.ParamByName('InDepotNum').DataType:= ftString;
      Parameters.ParamByName('CreateTime').DataType:= ftDateTime;

      Parameters.ParamByName('DepotID').Value:= GetItemCode(CbbDepot.Text, CbbDepot.Items);
      Parameters.ParamByName('GoodsID').Value:= GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items);
      Parameters.ParamByName('UserID').Value:= CurUser.UserID;
      Parameters.ParamByName('InDepotTypeID').Value:= GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items);
      Parameters.ParamByName('InDepotNum').Value:= StrToInt(EdtNum.Text);
      Parameters.ParamByName('CreateTime').Value:= Now; }
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadInDepotInfo;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormInDepotMgr.Btn_ModifyClick(Sender: TObject);
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
                 IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items)) + ',' +
                 IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items)) + ',' +
                 IntToStr(CurUser.UserID) + ',' +
                 IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items)) + ',' +
                 EdtNum.Text + ',' +
                 '1,' +
                 'cdate(''' + DateTimeToStr(Now) + '''))';
      ExecSQL;
      //保留历史后再修改
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'update InDepot set ' +
                 'DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items)) + ',' +
                 'GoodsID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items)) + ',' +
                 'UserID=' + IntToStr(CurUser.UserID) + ',' +
                 'InDepotTypeID=' + IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items)) + ',' +
                 'InDepotNum=' + EdtNum.Text + ',' +
                 'ModifyTime=cdate(''' + DateTimeToStr(Now) + ''')' +
                 ' where ID=' + AdoQuery.FieldByName('ID').AsString;
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
begin
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
                 '-1,-1,' +IntToStr(CurUser.UserID) + ',-1,-1,2,' +
                 'cdate(''' + DateTimeToStr(Now) + '''))';
      ExecSQL;
      //保留历史后再删除
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lSqlStr:= 'delete from InDepot where ID=' + AdoQuery.FieldByName('ID').AsString;
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
begin
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
//    SQL.Text:= 'SELECT InDepot.*, Depot.DepotName, Goods.GoodsName, InDepotType.InDepotTypeName,User.UserName ' +
//               ' FROM (((InDepot LEFT JOIN Depot ON Depot.DepotID=InDepot.DepotID) ' +
//               ' LEFT JOIN Goods ON Goods.GoodsID=InDepot.GoodsID) ' +
//               ' LEFT JOIN InDepotType ON InDepotType.InDepotTypeID=InDepot.InDepotTypeID) ' +
//               ' LEFT JOIN User ON Depot.UserID=User.UserID';
    SQL.Text:= 'SELECT InDepot.*, Depot.DepotName, Goods.GoodsName, InDepotType.InDepotTypeName, User.UserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*InDepot.InDepotNum) AS Cost, (Goods.SalePrice*InDepot.InDepotNum) AS Sale ' +
               ' FROM (((InDepot LEFT JOIN Depot ON InDepot.DepotID=Depot.DepotID) ' +
               ' LEFT JOIN Goods ON InDepot.GoodsID=Goods.GoodsID) ' +
               ' INNER JOIN [User] ON InDepot.UserID=User.UserID) ' +
               ' INNER JOIN InDepotType ON InDepot.InDepotTypeID=InDepotType.InDepotTypeID' +
               ' Order by InDepot.DepotID,InDepot.GoodsID,InDepot.InDepotTypeID';
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
  with AdoQuery do
  begin
    CbbDepot.ItemIndex:= CbbDepot.Items.IndexOf(FieldByName('DepotName').AsString);
    CbbGoodsType.ItemIndex:= CbbGoodsType.Items.IndexOf(FieldByName('GoodsName').AsString);
    CbbInDepotType.ItemIndex:= CbbInDepotType.Items.IndexOf(FieldByName('InDepotTypeName').AsString);
    EdtNum.Text:= FieldByName('InDepotNum').AsString;
  end;
end;

end.
