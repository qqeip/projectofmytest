unit Gatherfour;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, Grids, DBGrids,
  ComCtrls, DB, ADODB, Menus;

type
  TFrmGatherfour = class(TFrmBase)
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
    Label3: TLabel;
    SpeedButton6: TSpeedButton;
    Edit2: TEdit;
    ADOMaster: TADODataSet;
    DSMaster: TDataSource;
    ADOMasterDSDesigner: TStringField;
    ADOMasterDSDesigner2: TStringField;
    ADOMasterDSDesigner3: TIntegerField;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FStartDate:TDate;
    FEndDate:TDate;

    procedure SetDate(Sender:TObject);
    procedure InitDate;
    procedure ActiveDataSet;
  public
    class procedure ShowStorageMoveGather;
  end;

var
  FrmGatherfour: TFrmGatherfour;

implementation

uses FindDate, DataModu, DWareMoveBill, PubConst, ReportToolManage;

{$R *.dfm}

{ TFrmGatherfour }

procedure TFrmGatherfour.ActiveDataSet;
var
  SQL:string;
begin

  SQL := 'Select CONVERT(char(10),m.发生日期,120) 发生日期,m.单号 调拨单号,Sum(d.数量) 数量合计'+
          ' From 商品调拨主表 m,商品调拨明细表 d  '+
          ' Where m.flg = 1 and d.flg = 1 and m.单号 = d.单号 and m.发生日期 BETWEEN '+
          QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
          ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59') +
          ' Group by CONVERT(char(10),m.发生日期,120),m.单号';

  SQL := SQL + ' Union ALL ' + 'Select ''合计'',NULL,ISNULL(SUM(数量合计),0) From ('+ SQL +') a';

  ADOMaster.Active := False;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;

end;

procedure TFrmGatherfour.InitDate;
begin
  Edit2.Text := DateToStr(FStartDate)+ '至' +
        DateToStr(FEndDate);
end;

procedure TFrmGatherfour.SetDate(Sender: TObject);
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

procedure TFrmGatherfour.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  SetDate(Sender);
end;

procedure TFrmGatherfour.FormShow(Sender: TObject);
begin
  inherited;
  FStartDate := Now;
  FEndDate := Now;
  InitDate;

  ActiveDataSet;
end;

class procedure TFrmGatherfour.ShowStorageMoveGather;
begin
  FrmGatherfour := TFrmGatherfour.Create(Application);
  FrmGatherfour.ShowModal;
  FrmGatherfour.Free;
end;

procedure TFrmGatherfour.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  if (ADOMaster.IsEmpty) or (ADOMaster.FieldByName('调拨单号').AsString = '') then
    Exit;
  TFrmWareMove.ShowBillDetail(ADOMaster.FieldByName('调拨单号').AsString);
end;

procedure TFrmGatherfour.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmGatherfour.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + StorageMove;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmGatherfour.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + StorageMove;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.Preview;
  ReportTool.Free;
end;

procedure TFrmGatherfour.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + StorageMove;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.Print;
  ReportTool.Free;
end;

procedure TFrmGatherfour.SpeedButton2Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

end.
