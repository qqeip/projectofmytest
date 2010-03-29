unit BillQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg,PubConst, ComCtrls, Buttons,
  Grids, DBGrids, DB, ADODB;

type
  TFrmBillQuery = class(TFrmBase)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Edit2: TEdit;
    SpeedButton2: TSpeedButton;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    DBGrid1: TDBGrid;
    ADOMaster: TADODataSet;
    DSMaster: TDataSource;
    Panel3: TPanel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    ADOMasterDSDesigner: TStringField;
    ADOMasterDSDesigner2: TDateTimeField;
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    FBillType:TBillType;
    FStartDate:TDate;
    FEndDate:TDate;

    procedure SetDate(Sender:TObject);
    procedure InitDate;
    procedure ActiveDataSet;
  public
    class function BillQuery(vBillType:TBillType):string;
  end;

var
  FrmBillQuery: TFrmBillQuery;

implementation

uses DataModu, FindDate;

{$R *.dfm}

procedure TFrmBillQuery.ActiveDataSet;
var
  SQL:string;
  SQLDate:string;
  SQLBillCode:string;
begin
  SQL := 'Select top 0 * From 业务单据主表';
  if PageControl1.ActivePageIndex = 0 then
  begin
    SQLDate := ' and 发生日期 BETWEEN ' + QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
                ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59');
  end
  else if PageControl1.ActivePageIndex = 1 then
  begin
    SQLBillCode := ' and 单号 Like '+ QuotedStr('%'+Edit2.Text+'%');
  end;


  case FBillType of
    StorageMove:
    begin
      SQL := 'Select * From 商品调拨主表 Where 单据类型 = '+ IntToStr(FBillType) +
          SQLDate + SQLBillCode;
    end;
    else
    begin
      SQL := 'Select * From 业务单据主表 Where 定单类型 = '+ IntToStr(FBillType) +
          SQLDate + SQLBillCode;
    end;
  end;

  ADOMaster.Active := False;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;
end;

class function TFrmBillQuery.BillQuery(vBillType: TBillType): string;
begin
  Result := '';
  FrmBillQuery := TFrmBillQuery.Create(Application);
  FrmBillQuery.FBillType := vBillType;
  if FrmBillQuery.ShowModal = mrOk then
  begin
    Result := FrmBillQuery.ADOMaster.FieldByName('单号').AsString;
  end;
  FrmBillQuery.Free;
end;

procedure TFrmBillQuery.ComboBox1Change(Sender: TObject);
begin
  inherited;
  case ComboBox1.ItemIndex of
  0:
  begin
    PageControl1.Enabled := True;
    SpeedButton3.Enabled := True;
    PageControl1.ActivePageIndex := 0;
  end;
  1:
  begin
    PageControl1.Enabled := True;
    SpeedButton3.Enabled := True;
    PageControl1.ActivePageIndex := 1;    
  end;
  else
  begin
    PageControl1.Enabled := False;
    SpeedButton3.Enabled := False;
  end;
  end;
end;

procedure TFrmBillQuery.InitDate;
begin
  Edit1.Text := DateToStr(FStartDate)+ '至' +
        DateToStr(FEndDate);
end;

procedure TFrmBillQuery.SetDate(Sender: TObject);
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

procedure TFrmBillQuery.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  if ADOMaster.IsEmpty then
    Exit;
  ModalResult := mrOk;
end;

procedure TFrmBillQuery.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TFrmBillQuery.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  SetDate(Sender);
end;

procedure TFrmBillQuery.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  Key := #0;
end;

procedure TFrmBillQuery.FormShow(Sender: TObject);
begin
  inherited;
  FStartDate := Now;
  FEndDate := Now;
end;

procedure TFrmBillQuery.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  if Edit2.Text <> '' then
    ActiveDataSet;
end;

procedure TFrmBillQuery.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmBillQuery.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  SpeedButton3Click(Sender);
end;

end.
