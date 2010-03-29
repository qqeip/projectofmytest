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
  FrmGatherOne.Caption := '�ɹ���ⵥ���ܱ�';
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
  Edit1.Text := '(ȫ��)';
  FStorageID := '-1';
  Edit3.Text := '(ȫ��)';
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
  Edit2.Text := DateToStr(FStartDate)+ '��' +
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
    StockInStorage: //�ɹ���ⵥ���ܱ�
    begin
      if FComeUnitID = '-1' then
        SQL := ''
      else
        SQL := ' and a.��λ = '+ FComeUnitID;
      if FStorageID = '-1' then
        SQL2 := ''
      else
        SQL2 := ' and a.�ֿ��� = '+ FStorageID;

      SQLStr := 'Select c.��λ����,CONVERT(char(10),a.��������,120) ��������,a.����,SUM(b.����) �ɹ������ϼ�,SUM(b.����*b.����) �ܼۺϼ�'+
                ' From ҵ�񵥾����� a'+
                ' LEFT JOIN ҵ�񵥾���ϸ�� b ON a.���� = b.�������'+
                ' LEFT JOIN �ͻ����� c ON a.��λ = c.���'+
                ' Where a.flg = 1 and b.flg = 1 and a.�������� = '+ IntToStr(Integer(StockInStorage))+' and'+
                ' a.�������� BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQL + SQL2 +
                ' Group by c.��λ����,CONVERT(char(10),a.��������,120),a.����';
      SQLStr := SQLStr + ' union all'+
                ' Select ''�ϼ�'',Null,Null,ISNULL(SUM(�ɹ������ϼ�),0),ISNULL(SUM(�ܼۺϼ�),0)'+
                ' From ('+ SQLStr +') z';

      ADOStockIn.Active := False;
      ADOStockIn.CommandText := SQLStr;
      ADOStockIn.Active := True;
    end;
    StockOutStorage:  //�ɹ��˻������ܱ�
    begin
      if FComeUnitID = '-1' then
        SQL := ''
      else
        SQL := ' and a.��λ = '+ FComeUnitID;
      if FStorageID = '-1' then
        SQL2 := ''   
      else
        SQL2 := ' and a.�ֿ��� = '+ FStorageID;

      SQLStr := 'Select c.��λ����,CONVERT(char(10),a.��������,120) ��������,a.����,SUM(b.����) �ɹ������ϼ�,SUM(b.����*b.����) �ܼۺϼ�'+
                ' From ҵ�񵥾����� a'+
                ' LEFT JOIN ҵ�񵥾���ϸ�� b ON a.���� = b.�������'+
                ' LEFT JOIN �ͻ����� c ON a.��λ = c.���'+
                ' Where a.flg = 1 and b.flg = 1 and a.�������� = '+ IntToStr(Integer(StockOutStorage))+' and'+
                ' a.�������� BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQL + SQL2 +
                ' Group by c.��λ����,CONVERT(char(10),a.��������,120),a.����';
      SQLStr := SQLStr + ' union all'+
                ' Select ''�ϼ�'',Null,Null,ISNULL(SUM(�ɹ������ϼ�),0),ISNULL(SUM(�ܼۺϼ�),0)'+
                ' From ('+ SQLStr +') z';
                
      ADOStockOut.Active := False;
      ADOStockOut.CommandText := SQLStr;
      ADOStockOut.Active := True;
    end;
    SellOutStorage:   //���۵����ܱ�
    begin
      if FComeUnitID = '-1' then
        SQL := ''
      else
        SQL := ' and a.��λ = '+ FComeUnitID;
      if FStorageID = '-1' then
        SQL2 := ''
      else
        SQL2 := ' and a.�ֿ��� = '+ FStorageID;

      SQLStr := 'Select c.��λ����,CONVERT(char(10),a.��������,120) ��������,a.����,SUM(b.����) ���������ϼ�,SUM(b.����*b.����) �ܼۺϼ�'+
                ' From ҵ�񵥾����� a'+
                ' LEFT JOIN ҵ�񵥾���ϸ�� b ON a.���� = b.�������'+
                ' LEFT JOIN �ͻ����� c ON a.��λ = c.���'+
                ' Where a.flg = 1 and b.flg = 1 and a.�������� = '+ IntToStr(Integer(SellOutStorage))+' and'+
                ' a.�������� BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQL + SQL2 +
                ' Group by c.��λ����,CONVERT(char(10),a.��������,120),a.����';
      SQLStr := SQLStr + ' union all'+
                ' Select ''�ϼ�'',Null,Null,ISNULL(SUM(���������ϼ�),0),ISNULL(SUM(�ܼۺϼ�),0)'+
                ' From ('+ SQLStr +') z';

      ADOSellOut.Active := False;
      ADOSellOut.CommandText := SQLStr;
      ADOSellOut.Active := True;
    end;
    SellInStorage:    //�����˻������ܱ�
    begin
      if FComeUnitID = '-1' then
        SQL := ''
      else
        SQL := ' and a.��λ = '+ FComeUnitID;
      if FStorageID = '-1' then
        SQL2 := ''
      else
        SQL2 := ' and a.�ֿ��� = '+ FStorageID;

      SQLStr := 'Select c.��λ����,CONVERT(char(10),a.��������,120) ��������,a.����,SUM(b.����) ���������ϼ�,SUM(b.����*b.����) �ܼۺϼ�'+
                ' From ҵ�񵥾����� a'+
                ' LEFT JOIN ҵ�񵥾���ϸ�� b ON a.���� = b.�������'+
                ' LEFT JOIN �ͻ����� c ON a.��λ = c.���'+
                ' Where a.flg = 1 and b.flg = 1 and a.�������� = '+ IntToStr(Integer(SellInStorage))+' and'+
                ' a.�������� BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQL + SQL2 +
                ' Group by c.��λ����,CONVERT(char(10),a.��������,120),a.����';
      SQLStr := SQLStr + ' union all'+
                ' Select ''�ϼ�'',Null,Null,ISNULL(SUM(���������ϼ�),0),ISNULL(SUM(�ܼۺϼ�),0)'+
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
  FrmGatherOne.Caption := '�ɹ��˻������ܱ�';
  FrmGatherOne.ShowModal;
  FrmGatherOne.Free;
end;

class procedure TFrmGatherOne.ShowSellOutStorageQuery;
begin
  FrmGatherOne := TFrmGatherOne.Create(Application);
  BillType := SellOutStorage;
  FrmGatherOne.DSMaster.DataSet := FrmGatherOne.ADOSellOut;
  FrmGatherOne.Caption := '���۵����ܱ�';
  FrmGatherOne.ShowModal;
  FrmGatherOne.Free;
end;

class procedure TFrmGatherOne.ShowSellInStorageQuery;
begin
  FrmGatherOne := TFrmGatherOne.Create(Application);
  BillType := SellInStorage;
  FrmGatherOne.DSMaster.DataSet := FrmGatherOne.ADOSellIn;
  FrmGatherOne.Caption := '�����˻������ܱ�';
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
  if DBGrid1.DataSource.DataSet.FieldByName('����').AsString = '' then
    Exit;
  TFrmStockBill.ShowBillDetail(DBGrid1.DataSource.DataSet.FieldByName('����').AsString);
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
