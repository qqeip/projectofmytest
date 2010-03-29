unit GatherThree;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, Grids, DBGrids,
  ComCtrls, DB, ADODB,PubConst, Menus;

type
  TFrmGatherThree = class(TFrmBase)
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label4: TLabel;
    SpeedButton7: TSpeedButton;
    Label5: TLabel;
    SpeedButton8: TSpeedButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    ADOMaster: TADODataSet;
    DSMaster: TDataSource;
    ADOMasterDSDesigner: TStringField;
    ADOMasterDSDesigner2: TStringField;
    ADOMasterDSDesigner3: TStringField;
    ADOMasterDSDesigner4: TStringField;
    ADOMasterDSDesigner5: TBCDField;
    ADOMasterDSDesigner6: TIntegerField;
    ADOMasterDSDesigner7: TBCDField;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ADOMasterCalcFields(DataSet: TDataSet);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    procedure SetDate(Sender:TObject);
    procedure ShowDetail;
  public
    ComeUnitID:string;
    StorageID:string;
    WareID:string;
    StartDate:TDate;
    EndDate:TDate;
    BillType:TBillType;

    procedure InitDate;
    procedure ActiveDataSet;
  end;

var
  FrmGatherThree: TFrmGatherThree;

implementation

uses FindDate, SelectData, DataModu, DBill, ReportToolManage;

{$R *.dfm}

{ TFrmGatherThree }

procedure TFrmGatherThree.ActiveDataSet;
var
  SQL:string;
  SQLWare:string;
  SQLStorage:string;
  SQLComeUnit:string;
  
begin

  if WareID = '-1' then
    SQLWare := ''
  else
    SQLWare := ' and d.��Ʒ��� = '+ WareID;

  if StorageID = '-1' then
    SQLStorage := ''
  else
    SQLStorage := ' and m.�ֿ��� = '+ StorageID;

  if ComeUnitID = '-1' then
    SQLComeUnit := ''
  else
    SQLComeUnit := ' and m.��λ = '+ ComeUnitID;


  SQL := 'Select s.��Ʒ����,s.����ͺ�,s.��λ,m.����,d.����,'+
          ' d.����,d.���� * d.���� �ܼ� From ҵ�񵥾���ϸ�� d '+
          ' left join ҵ�񵥾����� m on d.������� = m.���� and m.flg = 1'+
          ' Left join ��Ʒ������ s on d.��Ʒ��� = s.��Ʒ����'+
          ' Where d.flg = 1 and m.�������� = ' + IntToStr(BillType) +
          ' and m.�������� BETWEEN '+ QuotedStr(DateToStr(StartDate)+' 00:00:00') +
            ' and '+QuotedStr(DateToStr(EndDate)+' 23:59:59')+
          SQLWare + SQLStorage + SQLComeUnit;

  SQL := SQL + ' union all ' + 'Select ''�ϼ�'''+
        ',Null,Null,Null,isnull(Sum(����),0),isnull(Sum(����),0)'+
        ',isnull(sum(�ܼ�),0) From ('+ SQL +') a';

  ADOMaster.Active := False;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;
end;

procedure TFrmGatherThree.InitDate;
begin
  Edit2.Text := DateToStr(StartDate)+ '��' +
        DateToStr(EndDate);
end;

procedure TFrmGatherThree.SetDate(Sender: TObject);
var
  FindDate:TFrmFindDate;
begin
  FindDate := TFrmFindDate.Create(Self);
  FindDate.D_StartDate.Date := StartDate;
  FindDate.D_EndDate.Date := EndDate;
  if FindDate.ShowModal = mrOk then
  begin
    StartDate := FindDate.D_StartDate.Date;
    EndDate := FindDate.D_EndDate.Date;
    InitDate;
    ActiveDataSet;
  end;
  FindDate.Free;
end;

procedure TFrmGatherThree.SpeedButton5Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectWare(BillType) = mrOk then
  begin
    WareID := FindID;
    Edit1.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherThree.SpeedButton8Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectALLComeUnit(utProvide) = mrOk then
  begin
    ComeUnitID := FindID;
    Edit4.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherThree.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  SetDate(Sender);
end;

procedure TFrmGatherThree.SpeedButton7Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectAllStorage = mrOk then
  begin
    StorageID := FindID;
    Edit3.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherThree.FormShow(Sender: TObject);
begin
  
  case BillType of
    StockInStorage:
    begin
      Self.Caption := '�ɹ���Ʒ��ϸ��';
      Label1.Caption := Caption;
    end;
    StockOutStorage:
    begin
      Caption := '�ɹ��˻���Ʒ��ϸ��';
      Label1.Caption := Caption;
    end;
    SellOutStorage:
    begin
      Caption := '������Ʒ��ϸ��';
      Label1.Caption := Caption;
    end;
    SellInStorage:
    begin
      Caption := '�����˻���Ʒ��ϸ��';
      Label1.Caption := Caption;
    end;
  end;
  inherited;
end;

procedure TFrmGatherThree.ADOMasterCalcFields(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('WareSum').AsCurrency :=
      DataSet.FieldByName('����').AsCurrency  *
          DataSet.FieldByName('����').AsInteger;
end;

procedure TFrmGatherThree.ShowDetail;
begin
  if ADOMaster.IsEmpty then
    Exit;
  if ADOMaster.FieldByName('����').AsString = '' then
    Exit;
  TFrmStockBill.ShowBillDetail(ADOMaster.FieldByName('����').AsString);
end;

procedure TFrmGatherThree.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  ShowDetail;
end;

procedure TFrmGatherThree.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmGatherThree.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmGatherThree.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 300 + BillType;
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

procedure TFrmGatherThree.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 300 + BillType;
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

procedure TFrmGatherThree.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 300 + BillType;
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

procedure TFrmGatherThree.SpeedButton2Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

end.
