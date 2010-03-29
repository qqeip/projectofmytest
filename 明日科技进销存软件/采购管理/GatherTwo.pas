unit GatherTwo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, Grids, DBGrids,
  ComCtrls, DB, ADODB, Menus;

type
  TFrmGatherTwo = class(TFrmBase)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label4: TLabel;
    SpeedButton7: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    ADOSellOut: TADODataSet;
    ADOStockIn: TADODataSet;
    ADOStockOut: TADODataSet;
    ADOSellIn: TADODataSet;
    DSMaster: TDataSource;
    Label5: TLabel;
    Edit4: TEdit;
    SpeedButton8: TSpeedButton;
    ADOStockInDSDesigner: TStringField;
    ADOStockInDSDesigner2: TIntegerField;
    ADOStockInDSDesigner3: TStringField;
    ADOStockInDSDesigner4: TStringField;
    ADOStockInDSDesigner6: TIntegerField;
    ADOStockInDSDesigner7: TBCDField;
    ADOStockOutDSDesigner: TStringField;
    ADOStockOutDSDesigner2: TIntegerField;
    ADOStockOutDSDesigner3: TStringField;
    ADOStockOutDSDesigner4: TStringField;
    ADOStockOutDSDesigner6: TIntegerField;
    ADOStockOutDSDesigner7: TBCDField;
    ADOSellOutDSDesigner: TStringField;
    ADOSellOutDSDesigner2: TIntegerField;
    ADOSellOutDSDesigner3: TStringField;
    ADOSellOutDSDesigner4: TStringField;
    ADOSellOutDSDesigner6: TIntegerField;
    ADOSellOutDSDesigner7: TBCDField;
    ADOSellInDSDesigner: TStringField;
    ADOSellInDSDesigner2: TIntegerField;
    ADOSellInDSDesigner3: TStringField;
    ADOSellInDSDesigner4: TStringField;
    ADOSellInDSDesigner6: TIntegerField;
    ADOSellInDSDesigner7: TBCDField;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure SpeedButton8Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
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
    FWareID:string;
    FStartDate:TDate;
    FEndDate:TDate;

    procedure SetDate(Sender:TObject);
    procedure InitDate;
    procedure ActiveDataSet;
    procedure ShowWareDetail;
  public
    class procedure ShowStockInWare;
    class procedure ShowStockOutWare;
    class procedure ShowSellOutWare;
    class procedure ShowSellInWare;
  end;

var
  FrmGatherTwo: TFrmGatherTwo;

implementation

uses DataModu, SelectData, PubConst, FindDate, GatherThree,
  ReportToolManage;
var
  BillType:TBillType;

{$R *.dfm}

procedure TFrmGatherTwo.SpeedButton8Click(Sender: TObject);
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
    Edit4.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherTwo.FormShow(Sender: TObject);
begin
  inherited;
  Label1.Caption := Caption;

  FComeUnitID := '-1';
  Edit4.Text := '(全部)';

  FStorageID := '-1';
  Edit3.Text := '(全部)';

  FWareID := '-1';
  Edit1.Text := '(全部)';

  FStartDate := Now;
  FEndDate := Now;
  InitDate;

  ActiveDataSet;
end;

procedure TFrmGatherTwo.ActiveDataSet;
var
  SQL:string;
  SQLWare:string;
  SQLStorage:string;
  SQLComeUnit:string;

begin

  if FWareID = '-1' then
    SQLWare := ''
  else
    SQLWare := ' and c.商品编码 = '+ FWareID;

  if FStorageID = '-1' then
    SQLStorage := ''
  else
    SQLStorage := ' and a.仓库编号 = '+ FStorageID;

  if FComeUnitID = '-1' then
    SQLComeUnit := ''
  else
    SQLComeUnit := ' and a.单位 = '+ FComeUnitID;



  case BillType of
    StockInStorage:
    begin
    
      SQL := 'Select c.商品名称,c.商品编码,c.规格型号,c.单位,'+
	              ' ISNULL(SUM(b.数量),0) 本期采购商品数量 ,'+
	              ' ISNULL(SUM(b.数量 * 单价),0) 本期采购商品金额'+
                ' From 业务单据主表 a '+
                ' LEFT JOIN 业务单据明细表 b ON a.单号 = b.定单编号'+
                ' LEFT JOIN 商品档案表 c ON c.商品编码 = b.商品编号'+
                ' Where a.flg = 1 and b.flg = 1 and c.flg = 1 and a.定单类型 = '+
                    IntToStr(Integer(StockInStorage))+
                ' and a.发生日期 BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59') + SQLComeUnit + SQLStorage + SQLWare +
                ' GROUP BY c.商品编码,c.商品名称,c.规格型号,c.单位';

      SQL := SQL + ' Union ALL '+ 'Select ''合计'',Null'+
                  ',Null,Null,isNull(Sum(本期采购商品数量),0)'+
                  ',isNull(SUM(本期采购商品金额),0) From ('+ SQL +') a';

      ADOStockIn.Active := False;
      ADOStockIn.CommandText := SQL;
      ADOStockIn.Active := True;
    end;
    StockOutStorage:
    begin
      SQL := 'Select c.商品名称,c.商品编码,c.规格型号,c.单位,'+
	              ' ISNULL(SUM(b.数量),0) 本期采购商品数量 ,'+
	              ' ISNULL(SUM(b.数量 * 单价),0) 本期采购商品金额'+
                ' From 业务单据主表 a '+
                ' LEFT JOIN 业务单据明细表 b ON a.单号 = b.定单编号'+
                ' LEFT JOIN 商品档案表 c ON c.商品编码 = b.商品编号'+
                ' Where a.flg = 1 and b.flg = 1 and c.flg = 1 and a.定单类型 = '+
                    IntToStr(Integer(StockOutStorage))+
                ' and a.发生日期 BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQLComeUnit + SQLStorage + SQLWare +
                ' GROUP BY c.商品编码,c.商品名称,c.规格型号,c.单位';

      SQL := SQL + ' Union ALL '+ 'Select ''合计'',Null'+
                  ',Null,Null,isNull(Sum(本期采购商品数量),0)'+
                  ',isNull(SUM(本期采购商品金额),0) From ('+ SQL +') a';

      ADOStockOut.Active := False;
      ADOStockOut.CommandText := SQL;
      ADOStockOut.Active := True;
    end;
    SellOutStorage:
    begin
      SQL := 'Select c.商品名称,c.商品编码,c.规格型号,c.单位,'+
	              ' ISNULL(SUM(b.数量),0) 本期销售商品数量 ,'+
	              ' ISNULL(SUM(b.数量 * 单价),0) 本期销售商品金额'+
                ' From 业务单据主表 a '+
                ' LEFT JOIN 业务单据明细表 b ON a.单号 = b.定单编号'+
                ' LEFT JOIN 商品档案表 c ON c.商品编码 = b.商品编号'+
                ' Where a.flg = 1 and b.flg = 1 and c.flg = 1 and a.定单类型 = '+
                    IntToStr(Integer(SellOutStorage))+
                ' and a.发生日期 BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQLComeUnit + SQLStorage + SQLWare +
                ' GROUP BY c.商品编码,c.商品名称,c.规格型号,c.单位';

      SQL := SQL + ' Union ALL '+ 'Select ''合计'',Null'+
                  ',Null,Null,isNull(Sum(本期销售商品数量),0)'+
                  ',isNull(SUM(本期销售商品金额),0) From ('+ SQL +') a';
                
      ADOSellOut.Active := False;
      ADOSellOut.CommandText := SQL;
      ADOSellOut.Active := True;
    end;
    SellInStorage:
    begin
      SQL := 'Select c.商品名称,c.商品编码,c.规格型号,c.单位,'+
	              ' ISNULL(SUM(b.数量),0) 本期销售退货商品数量 ,'+
	              ' ISNULL(SUM(b.数量 * 单价),0) 本期销售退货商品金额'+
                ' From 业务单据主表 a '+
                ' LEFT JOIN 业务单据明细表 b ON a.单号 = b.定单编号'+
                ' LEFT JOIN 商品档案表 c ON c.商品编码 = b.商品编号'+
                ' Where a.flg = 1 and b.flg = 1 and c.flg = 1 and a.定单类型 = '+
                    IntToStr(Integer(SellInStorage))+
                ' and a.发生日期 BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQLComeUnit + SQLStorage + SQLWare +
                ' GROUP BY c.商品编码,c.商品名称,c.规格型号,c.单位';

      SQL := SQL + ' Union ALL '+ 'Select ''合计'',Null'+
                  ',Null,Null,isNull(Sum(本期销售退货商品数量),0)'+
                  ',isNull(SUM(本期销售退货商品金额),0) From ('+ SQL +') a';

      ADOSellIn.Active := False;
      ADOSellIn.CommandText := SQL;
      ADOSellIn.Active := True;
    end;
  end;
end;

class procedure TFrmGatherTwo.ShowStockInWare;
begin
  FrmGatherTwo := TFrmGatherTwo.Create(Application);
  BillType := StockInStorage;
  FrmGatherTwo.Caption := '采购进货商品汇总表';
  FrmGatherTwo.DSMaster.DataSet := FrmGatherTwo.ADOStockIn;
  FrmGatherTwo.ShowModal;
  FrmGatherTwo.Free;
end;

procedure TFrmGatherTwo.InitDate;
begin
  Edit2.Text := DateToStr(FStartDate)+ '至' +
        DateToStr(FEndDate);
end;

procedure TFrmGatherTwo.SetDate(Sender: TObject);
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

procedure TFrmGatherTwo.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  SetDate(Sender);
end;

procedure TFrmGatherTwo.SpeedButton7Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectAllStorage = mrOk then
  begin
    FStorageID := FindID;
    Edit3.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherTwo.SpeedButton5Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectWare(BillType) = mrOk then
  begin
    FWareID := FindID;
    Edit1.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherTwo.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  Close;
end;

class procedure TFrmGatherTwo.ShowStockOutWare;
begin
  FrmGatherTwo := TFrmGatherTwo.Create(Application);
  BillType := StockOutStorage;
  FrmGatherTwo.Caption := '采购退货商品汇总表';
  FrmGatherTwo.DSMaster.DataSet := FrmGatherTwo.ADOStockOut;
  FrmGatherTwo.ShowModal;
  FrmGatherTwo.Free;
end;

class procedure TFrmGatherTwo.ShowSellOutWare;
begin
  FrmGatherTwo := TFrmGatherTwo.Create(Application);
  BillType := SellOutStorage;
  FrmGatherTwo.Caption := '销售商品汇总表';
  FrmGatherTwo.DSMaster.DataSet := FrmGatherTwo.ADOSellOut;
  FrmGatherTwo.ShowModal;
  FrmGatherTwo.Free;
end;

class procedure TFrmGatherTwo.ShowSellInWare;
begin
  FrmGatherTwo := TFrmGatherTwo.Create(Application);
  BillType := SellInStorage;
  FrmGatherTwo.Caption := '销售退货商品汇总表';
  FrmGatherTwo.DSMaster.DataSet := FrmGatherTwo.ADOSellIn;
  FrmGatherTwo.ShowModal;
  FrmGatherTwo.Free;
end;

procedure TFrmGatherTwo.ShowWareDetail;
begin
  if DBGrid1.DataSource.DataSet.IsEmpty then
    Exit;
  if DBGrid1.DataSource.DataSet.FieldByName('商品编码').AsInteger < 1 then
    Exit;  
  FrmGatherThree := TFrmGatherThree.Create(Application);
  FrmGatherThree.BillType := BillType;
  FrmGatherThree.Edit1.Text := DBGrid1.DataSource.DataSet.FieldByName('商品名称').AsString;
  FrmGatherThree.Edit3.Text := Edit3.Text;
  FrmGatherThree.Edit4.Text := Edit4.Text;
  FrmGatherThree.WareID := DBGrid1.DataSource.DataSet.FieldByName('商品编码').AsString;
  FrmGatherThree.StorageID := FStorageID;
  FrmGatherThree.ComeUnitID := FComeUnitID;
  FrmGatherThree.StartDate := FStartDate;
  FrmGatherThree.EndDate:= FEndDate;
  FrmGatherThree.InitDate;
  FrmGatherThree.ActiveDataSet;
  FrmGatherThree.ShowModal;
  FrmGatherThree.Free;
end;

procedure TFrmGatherTwo.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  ShowWareDetail;
end;

procedure TFrmGatherTwo.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmGatherTwo.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 200 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomWareName);
  ReportTool.SetVarible(CustomWareName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit3.Text));

  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(Edit4.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmGatherTwo.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 200 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomWareName);
  ReportTool.SetVarible(CustomWareName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit3.Text));

  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(Edit4.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.Preview;
  ReportTool.Free;
end;

procedure TFrmGatherTwo.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 200 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomWareName);
  ReportTool.SetVarible(CustomWareName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit3.Text));

  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(Edit4.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.Print;
  ReportTool.Free;
end;

procedure TFrmGatherTwo.SpeedButton2Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

end.
