unit GatherOne;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Grids, DBGrids, ComCtrls,
  DB, ADODB, Buttons, Menus;

type
  TFrmGatherOne = class(TFrmBase)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    ADOStockIn: TADODataSet;
    DSMaster: TDataSource;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    SpeedButton5: TSpeedButton;
    Edit2: TEdit;
    SpeedButton6: TSpeedButton;
    Label4: TLabel;
    Edit3: TEdit;
    SpeedButton7: TSpeedButton;
    ADOStockInDSDesigner: TStringField;
    ADOStockInDSDesigner3: TStringField;
    ADOStockInDSDesigner4: TIntegerField;
    ADOStockInDSDesigner5: TBCDField;
    ADOSellOut: TADODataSet;
    ADOSellOutDSDesigner: TStringField;
    ADOSellOutDSDesigner3: TStringField;
    ADOSellOutDSDesigner4: TIntegerField;
    ADOSellOutDSDesigner5: TBCDField;
    ADOStockOut: TADODataSet;
    ADOStockOutDSDesigner: TStringField;
    ADOStockOutDSDesigner3: TStringField;
    ADOStockOutDSDesigner4: TIntegerField;
    ADOStockOutDSDesigner5: TBCDField;
    ADOSellIn: TADODataSet;
    ADOSellInDSDesigner: TStringField;
    ADOSellInDSDesigner3: TStringField;
    ADOSellInDSDesigner4: TIntegerField;
    ADOSellInDSDesigner5: TBCDField;
    ADOStockInDSDesigner2: TStringField;
    ADOStockOutDSDesigner2: TStringField;
    ADOSellOutDSDesigner2: TStringField;
    ADOSellInDSDesigner2: TStringField;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FComeUnitID:string;
    FStorageID:string;
    FStartDate:TDate;
    FEndDate:TDate;

    procedure SetDate(Sender:TObject);
    procedure InitDate;
    procedure ActiveDataSet;
    procedure ShowDetail;
  public
    class procedure ShowStockInStorageQuery;
    class procedure ShowStockOutStorageQuery;
    class procedure ShowSellOutStorageQuery;
    class procedure ShowSellInStorageQuery;
  end;

var
  FrmGatherOne: TFrmGatherOne;

implementation

uses DataModu, SelectData, PubConst, FindDate, DBill, ReportToolManage;

var
  BillType:TBillType;
  
{$R *.dfm}

class procedure TFrmGatherOne.ShowStockInStorageQuery;
begin
  FrmGatherOne := TFrmGatherOne.Create(Application);
  BillType := StockInStorage;
  FrmGatherOne.DSMaster.DataSet := FrmGatherOne.ADOStockIn;
  FrmGatherOne.Caption := '采购入库单汇总表';
  FrmGatherOne.ShowModal;
  FrmGatherOne.Free;
end;

procedure TFrmGatherOne.SpeedButton5Click(Sender: TObject);
var
  VType:Integer;
begin
  inherited;

  if BillType in [SellOutStorage,SellInStorage] then
  begin
    VType := utClient;
  end
  else
  begin
    VType := utProvide;
  end;

  if TFrmSelectData.SelectALLComeUnit(VType) = mrOk then
  begin
    FComeUnitID := FindID;
    Edit1.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherOne.FormShow(Sender: TObject);
begin
  inherited;
  Label1.Caption := Caption;
  FStartDate := Now;
  FEndDate := Now;
  FComeUnitID := '-1';
  Edit1.Text := '(全部)';
  FStorageID := '-1';
  Edit3.Text := '(全部)';
  InitDate;
  ActiveDataSet;
end;

procedure TFrmGatherOne.SpeedButton7Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectAllStorage = mrOk then
  begin
    FStorageID := FindID;
    Edit3.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherOne.SetDate(Sender: TObject);
var
  FindDate:TFrmFindDate;
begin
  FindDate := TFrmFindDate.Create(Self);
  FindDate.D_StartDate.Date := FStartDate;
  FindDate.D_EndDate.Date := FEndDate;
  if FindDate.ShowModal = mrOk then
  begin
    FStartDate := FindDate.D_StartDate.Date;
    FEndDate := FindDate.D_EndDate.Date;
    InitDate;
    ActiveDataSet;
  end;
  FindDate.Free;
end;

procedure TFrmGatherOne.InitDate;
begin
  Edit2.Text := DateToStr(FStartDate)+ '至' +
        DateToStr(FEndDate);
end;

procedure TFrmGatherOne.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  SetDate(Sender);
end;

procedure TFrmGatherOne.ActiveDataSet;
var
  SQLStr:string;
  SQL:string;
  SQL2:string;
begin

  case BillType of
    StockInStorage: //采购入库单汇总表
    begin
      if FComeUnitID = '-1' then
        SQL := ''
      else
        SQL := ' and a.单位 = '+ FComeUnitID;
      if FStorageID = '-1' then
        SQL2 := ''
      else
        SQL2 := ' and a.仓库编号 = '+ FStorageID;

      SQLStr := 'Select c.单位名称,CONVERT(char(10),a.发生日期,120) 发生日期,a.单号,SUM(b.数量) 采购数量合计,SUM(b.单价*b.数量) 总价合计'+
                ' From 业务单据主表 a'+
                ' LEFT JOIN 业务单据明细表 b ON a.单号 = b.定单编号'+
                ' LEFT JOIN 客户档案 c ON a.单位 = c.编号'+
                ' Where a.flg = 1 and b.flg = 1 and a.定单类型 = '+ IntToStr(Integer(StockInStorage))+' and'+
                ' a.发生日期 BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQL + SQL2 +
                ' Group by c.单位名称,CONVERT(char(10),a.发生日期,120),a.单号';
      SQLStr := SQLStr + ' union all'+
                ' Select ''合计'',Null,Null,ISNULL(SUM(采购数量合计),0),ISNULL(SUM(总价合计),0)'+
                ' From ('+ SQLStr +') z';

      ADOStockIn.Active := False;
      ADOStockIn.CommandText := SQLStr;
      ADOStockIn.Active := True;
    end;
    StockOutStorage:  //采购退货单汇总表
    begin
      if FComeUnitID = '-1' then
        SQL := ''
      else
        SQL := ' and a.单位 = '+ FComeUnitID;
      if FStorageID = '-1' then
        SQL2 := ''   
      else
        SQL2 := ' and a.仓库编号 = '+ FStorageID;

      SQLStr := 'Select c.单位名称,CONVERT(char(10),a.发生日期,120) 发生日期,a.单号,SUM(b.数量) 采购数量合计,SUM(b.单价*b.数量) 总价合计'+
                ' From 业务单据主表 a'+
                ' LEFT JOIN 业务单据明细表 b ON a.单号 = b.定单编号'+
                ' LEFT JOIN 客户档案 c ON a.单位 = c.编号'+
                ' Where a.flg = 1 and b.flg = 1 and a.定单类型 = '+ IntToStr(Integer(StockOutStorage))+' and'+
                ' a.发生日期 BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQL + SQL2 +
                ' Group by c.单位名称,CONVERT(char(10),a.发生日期,120),a.单号';
      SQLStr := SQLStr + ' union all'+
                ' Select ''合计'',Null,Null,ISNULL(SUM(采购数量合计),0),ISNULL(SUM(总价合计),0)'+
                ' From ('+ SQLStr +') z';
                
      ADOStockOut.Active := False;
      ADOStockOut.CommandText := SQLStr;
      ADOStockOut.Active := True;
    end;
    SellOutStorage:   //销售单汇总表
    begin
      if FComeUnitID = '-1' then
        SQL := ''
      else
        SQL := ' and a.单位 = '+ FComeUnitID;
      if FStorageID = '-1' then
        SQL2 := ''
      else
        SQL2 := ' and a.仓库编号 = '+ FStorageID;

      SQLStr := 'Select c.单位名称,CONVERT(char(10),a.发生日期,120) 发生日期,a.单号,SUM(b.数量) 销售数量合计,SUM(b.单价*b.数量) 总价合计'+
                ' From 业务单据主表 a'+
                ' LEFT JOIN 业务单据明细表 b ON a.单号 = b.定单编号'+
                ' LEFT JOIN 客户档案 c ON a.单位 = c.编号'+
                ' Where a.flg = 1 and b.flg = 1 and a.定单类型 = '+ IntToStr(Integer(SellOutStorage))+' and'+
                ' a.发生日期 BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQL + SQL2 +
                ' Group by c.单位名称,CONVERT(char(10),a.发生日期,120),a.单号';
      SQLStr := SQLStr + ' union all'+
                ' Select ''合计'',Null,Null,ISNULL(SUM(销售数量合计),0),ISNULL(SUM(总价合计),0)'+
                ' From ('+ SQLStr +') z';

      ADOSellOut.Active := False;
      ADOSellOut.CommandText := SQLStr;
      ADOSellOut.Active := True;
    end;
    SellInStorage:    //销售退货单汇总表
    begin
      if FComeUnitID = '-1' then
        SQL := ''
      else
        SQL := ' and a.单位 = '+ FComeUnitID;
      if FStorageID = '-1' then
        SQL2 := ''
      else
        SQL2 := ' and a.仓库编号 = '+ FStorageID;

      SQLStr := 'Select c.单位名称,CONVERT(char(10),a.发生日期,120) 发生日期,a.单号,SUM(b.数量) 销售数量合计,SUM(b.单价*b.数量) 总价合计'+
                ' From 业务单据主表 a'+
                ' LEFT JOIN 业务单据明细表 b ON a.单号 = b.定单编号'+
                ' LEFT JOIN 客户档案 c ON a.单位 = c.编号'+
                ' Where a.flg = 1 and b.flg = 1 and a.定单类型 = '+ IntToStr(Integer(SellInStorage))+' and'+
                ' a.发生日期 BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQL + SQL2 +
                ' Group by c.单位名称,CONVERT(char(10),a.发生日期,120),a.单号';
      SQLStr := SQLStr + ' union all'+
                ' Select ''合计'',Null,Null,ISNULL(SUM(销售数量合计),0),ISNULL(SUM(总价合计),0)'+
                ' From ('+ SQLStr +') z';

      ADOSellIn.Active := False;
      ADOSellIn.CommandText := SQLStr; 
      ADOSellIn.Active := True;
    end;
  end;

end;

procedure TFrmGatherOne.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  Close;
end;

class procedure TFrmGatherOne.ShowStockOutStorageQuery;
begin
  FrmGatherOne := TFrmGatherOne.Create(Application);
  BillType := StockOutStorage;
  FrmGatherOne.DSMaster.DataSet := FrmGatherOne.ADOStockOut;
  FrmGatherOne.Caption := '采购退货单汇总表';
  FrmGatherOne.ShowModal;
  FrmGatherOne.Free;
end;

class procedure TFrmGatherOne.ShowSellOutStorageQuery;
begin
  FrmGatherOne := TFrmGatherOne.Create(Application);
  BillType := SellOutStorage;
  FrmGatherOne.DSMaster.DataSet := FrmGatherOne.ADOSellOut;
  FrmGatherOne.Caption := '销售单汇总表';
  FrmGatherOne.ShowModal;
  FrmGatherOne.Free;
end;

class procedure TFrmGatherOne.ShowSellInStorageQuery;
begin
  FrmGatherOne := TFrmGatherOne.Create(Application);
  BillType := SellInStorage;
  FrmGatherOne.DSMaster.DataSet := FrmGatherOne.ADOSellIn;
  FrmGatherOne.Caption := '销售退货单汇总表';
  FrmGatherOne.ShowModal;
  FrmGatherOne.Free;
end;

procedure TFrmGatherOne.DBGrid1DrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  inherited;
  if ((BillType = StockOutStorage) or
      (BillType = SellInStorage)) then
    DBGrid1.Canvas.Font.Color := clRed
  else
    DBGrid1.Canvas.Font.Color := clWindowText;
  DBGrid1.DefaultDrawDataCell(Rect,Field,State);
end;

procedure TFrmGatherOne.ShowDetail;
begin
  if DBGrid1.DataSource.DataSet.IsEmpty then
    Exit;
  if DBGrid1.DataSource.DataSet.FieldByName('单号').AsString = '' then
    Exit;
  TFrmStockBill.ShowBillDetail(DBGrid1.DataSource.DataSet.FieldByName('单号').AsString);
end;

procedure TFrmGatherOne.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  ShowDetail;
end;

procedure TFrmGatherOne.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmGatherOne.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit3.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmGatherOne.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit3.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.Preview;
  ReportTool.Free;
end;

procedure TFrmGatherOne.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit3.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.Print;
  ReportTool.Free;
end;

procedure TFrmGatherOne.SpeedButton2Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

end.
