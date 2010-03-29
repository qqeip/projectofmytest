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
  Edit4.Text := '(ȫ��)';

  FStorageID := '-1';
  Edit3.Text := '(ȫ��)';

  FWareID := '-1';
  Edit1.Text := '(ȫ��)';

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
    SQLWare := ' and c.��Ʒ���� = '+ FWareID;

  if FStorageID = '-1' then
    SQLStorage := ''
  else
    SQLStorage := ' and a.�ֿ��� = '+ FStorageID;

  if FComeUnitID = '-1' then
    SQLComeUnit := ''
  else
    SQLComeUnit := ' and a.��λ = '+ FComeUnitID;



  case BillType of
    StockInStorage:
    begin
    
      SQL := 'Select c.��Ʒ����,c.��Ʒ����,c.����ͺ�,c.��λ,'+
	              ' ISNULL(SUM(b.����),0) ���ڲɹ���Ʒ���� ,'+
	              ' ISNULL(SUM(b.���� * ����),0) ���ڲɹ���Ʒ���'+
                ' From ҵ�񵥾����� a '+
                ' LEFT JOIN ҵ�񵥾���ϸ�� b ON a.���� = b.�������'+
                ' LEFT JOIN ��Ʒ������ c ON c.��Ʒ���� = b.��Ʒ���'+
                ' Where a.flg = 1 and b.flg = 1 and c.flg = 1 and a.�������� = '+
                    IntToStr(Integer(StockInStorage))+
                ' and a.�������� BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59') + SQLComeUnit + SQLStorage + SQLWare +
                ' GROUP BY c.��Ʒ����,c.��Ʒ����,c.����ͺ�,c.��λ';

      SQL := SQL + ' Union ALL '+ 'Select ''�ϼ�'',Null'+
                  ',Null,Null,isNull(Sum(���ڲɹ���Ʒ����),0)'+
                  ',isNull(SUM(���ڲɹ���Ʒ���),0) From ('+ SQL +') a';

      ADOStockIn.Active := False;
      ADOStockIn.CommandText := SQL;
      ADOStockIn.Active := True;
    end;
    StockOutStorage:
    begin
      SQL := 'Select c.��Ʒ����,c.��Ʒ����,c.����ͺ�,c.��λ,'+
	              ' ISNULL(SUM(b.����),0) ���ڲɹ���Ʒ���� ,'+
	              ' ISNULL(SUM(b.���� * ����),0) ���ڲɹ���Ʒ���'+
                ' From ҵ�񵥾����� a '+
                ' LEFT JOIN ҵ�񵥾���ϸ�� b ON a.���� = b.�������'+
                ' LEFT JOIN ��Ʒ������ c ON c.��Ʒ���� = b.��Ʒ���'+
                ' Where a.flg = 1 and b.flg = 1 and c.flg = 1 and a.�������� = '+
                    IntToStr(Integer(StockOutStorage))+
                ' and a.�������� BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQLComeUnit + SQLStorage + SQLWare +
                ' GROUP BY c.��Ʒ����,c.��Ʒ����,c.����ͺ�,c.��λ';

      SQL := SQL + ' Union ALL '+ 'Select ''�ϼ�'',Null'+
                  ',Null,Null,isNull(Sum(���ڲɹ���Ʒ����),0)'+
                  ',isNull(SUM(���ڲɹ���Ʒ���),0) From ('+ SQL +') a';

      ADOStockOut.Active := False;
      ADOStockOut.CommandText := SQL;
      ADOStockOut.Active := True;
    end;
    SellOutStorage:
    begin
      SQL := 'Select c.��Ʒ����,c.��Ʒ����,c.����ͺ�,c.��λ,'+
	              ' ISNULL(SUM(b.����),0) ����������Ʒ���� ,'+
	              ' ISNULL(SUM(b.���� * ����),0) ����������Ʒ���'+
                ' From ҵ�񵥾����� a '+
                ' LEFT JOIN ҵ�񵥾���ϸ�� b ON a.���� = b.�������'+
                ' LEFT JOIN ��Ʒ������ c ON c.��Ʒ���� = b.��Ʒ���'+
                ' Where a.flg = 1 and b.flg = 1 and c.flg = 1 and a.�������� = '+
                    IntToStr(Integer(SellOutStorage))+
                ' and a.�������� BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQLComeUnit + SQLStorage + SQLWare +
                ' GROUP BY c.��Ʒ����,c.��Ʒ����,c.����ͺ�,c.��λ';

      SQL := SQL + ' Union ALL '+ 'Select ''�ϼ�'',Null'+
                  ',Null,Null,isNull(Sum(����������Ʒ����),0)'+
                  ',isNull(SUM(����������Ʒ���),0) From ('+ SQL +') a';
                
      ADOSellOut.Active := False;
      ADOSellOut.CommandText := SQL;
      ADOSellOut.Active := True;
    end;
    SellInStorage:
    begin
      SQL := 'Select c.��Ʒ����,c.��Ʒ����,c.����ͺ�,c.��λ,'+
	              ' ISNULL(SUM(b.����),0) ���������˻���Ʒ���� ,'+
	              ' ISNULL(SUM(b.���� * ����),0) ���������˻���Ʒ���'+
                ' From ҵ�񵥾����� a '+
                ' LEFT JOIN ҵ�񵥾���ϸ�� b ON a.���� = b.�������'+
                ' LEFT JOIN ��Ʒ������ c ON c.��Ʒ���� = b.��Ʒ���'+
                ' Where a.flg = 1 and b.flg = 1 and c.flg = 1 and a.�������� = '+
                    IntToStr(Integer(SellInStorage))+
                ' and a.�������� BETWEEN '+ QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59')+ SQLComeUnit + SQLStorage + SQLWare +
                ' GROUP BY c.��Ʒ����,c.��Ʒ����,c.����ͺ�,c.��λ';

      SQL := SQL + ' Union ALL '+ 'Select ''�ϼ�'',Null'+
                  ',Null,Null,isNull(Sum(���������˻���Ʒ����),0)'+
                  ',isNull(SUM(���������˻���Ʒ���),0) From ('+ SQL +') a';

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
  FrmGatherTwo.Caption := '�ɹ�������Ʒ���ܱ�';
  FrmGatherTwo.DSMaster.DataSet := FrmGatherTwo.ADOStockIn;
  FrmGatherTwo.ShowModal;
  FrmGatherTwo.Free;
end;

procedure TFrmGatherTwo.InitDate;
begin
  Edit2.Text := DateToStr(FStartDate)+ '��' +
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
  FrmGatherTwo.Caption := '�ɹ��˻���Ʒ���ܱ�';
  FrmGatherTwo.DSMaster.DataSet := FrmGatherTwo.ADOStockOut;
  FrmGatherTwo.ShowModal;
  FrmGatherTwo.Free;
end;

class procedure TFrmGatherTwo.ShowSellOutWare;
begin
  FrmGatherTwo := TFrmGatherTwo.Create(Application);
  BillType := SellOutStorage;
  FrmGatherTwo.Caption := '������Ʒ���ܱ�';
  FrmGatherTwo.DSMaster.DataSet := FrmGatherTwo.ADOSellOut;
  FrmGatherTwo.ShowModal;
  FrmGatherTwo.Free;
end;

class procedure TFrmGatherTwo.ShowSellInWare;
begin
  FrmGatherTwo := TFrmGatherTwo.Create(Application);
  BillType := SellInStorage;
  FrmGatherTwo.Caption := '�����˻���Ʒ���ܱ�';
  FrmGatherTwo.DSMaster.DataSet := FrmGatherTwo.ADOSellIn;
  FrmGatherTwo.ShowModal;
  FrmGatherTwo.Free;
end;

procedure TFrmGatherTwo.ShowWareDetail;
begin
  if DBGrid1.DataSource.DataSet.IsEmpty then
    Exit;
  if DBGrid1.DataSource.DataSet.FieldByName('��Ʒ����').AsInteger < 1 then
    Exit;  
  FrmGatherThree := TFrmGatherThree.Create(Application);
  FrmGatherThree.BillType := BillType;
  FrmGatherThree.Edit1.Text := DBGrid1.DataSource.DataSet.FieldByName('��Ʒ����').AsString;
  FrmGatherThree.Edit3.Text := Edit3.Text;
  FrmGatherThree.Edit4.Text := Edit4.Text;
  FrmGatherThree.WareID := DBGrid1.DataSource.DataSet.FieldByName('��Ʒ����').AsString;
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
