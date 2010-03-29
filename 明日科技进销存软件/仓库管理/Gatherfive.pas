unit Gatherfive;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, Grids, DBGrids,
  ComCtrls, DB, ADODB, Menus;

type
  TFrmGatherfive = class(TFrmBase)
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
    Label2: TLabel;
    SpeedButton5: TSpeedButton;
    Edit1: TEdit;
    ADOMaster: TADODataSet;
    DSMaster: TDataSource;
    ADOMasterDSDesigner: TStringField;
    ADOMasterDSDesigner2: TStringField;
    ADOMasterDSDesigner3: TStringField;
    ADOMasterDSDesigner4: TIntegerField;
    ADOMasterDSDesigner5: TIntegerField;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ADOMasterDSDesigner6: TStringField;
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    FWareID:string;
    FStartDate:TDate;
    FEndDate:TDate;

    procedure SetDate(Sender:TObject);
    procedure InitDate;
    procedure ActiveDataSet;

    procedure ShowWareDetail;
  public
    class procedure ShowStorageMoveDetailGather;
  end;

var
  FrmGatherfive: TFrmGatherfive;

implementation

uses FindDate, SelectData, DataModu, Gathersix, ReportToolManage, PubConst;

{$R *.dfm}

procedure TFrmGatherfive.ActiveDataSet;
var
  SQL:string;
  SQLWare:string;
begin

  if FWareID = '-1' then
    SQLWare := ''
  else
    SQLWare := ' and d.商品编号 = ' + FWareID;

  SQL := 'Select s.商品编码,s.商品名称,CONVERT(char(10),m.发生日期,120) 发生日期,s.规格型号,s.单位,Sum(d.数量) 调拨数量合计'+
          ' From 商品调拨主表 m,商品调拨明细表 d'+
          ' Left Join 商品档案表 s On d.商品编号 = s.商品编码'+
          ' Where m.单号 = d.单号 and m.flg = 1 and d.flg = 1'+
          ' and m.发生日期 BETWEEN '+
          QuotedStr(DateToStr(FStartDate)+' 00:00:00') +
          ' and '+QuotedStr(DateToStr(FEndDate)+' 23:59:59') +  SQLWare +
          ' Group by s.商品编码,s.商品名称,s.规格型号,s.单位,CONVERT(char(10),m.发生日期,120)';

  SQL := SQL + ' Union ALL ' + 'Select NULL,''合计'',NULL,NULL,NULL,ISNULL(SUM(调拨数量合计),0) From ('+ SQL +') a';

  ADOMaster.Active := False;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;
end;

procedure TFrmGatherfive.InitDate;
begin
  Edit2.Text := DateToStr(FStartDate)+ '至' +
        DateToStr(FEndDate);
end;

procedure TFrmGatherfive.SetDate(Sender: TObject);
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

class procedure TFrmGatherfive.ShowStorageMoveDetailGather;
begin
  FrmGatherfive := TFrmGatherfive.Create(Application);
  FrmGatherfive.ShowModal;
  FrmGatherfive.Free;
end;

procedure TFrmGatherfive.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmGatherfive.SpeedButton5Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectWare(0) = mrOk then
  begin
    FWareID := FindID;
    Edit1.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGatherfive.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  SetDate(Sender);
end;

procedure TFrmGatherfive.FormShow(Sender: TObject);
begin
  inherited;
  FWareID := '-1';
  Edit1.Text := '(全部)';

  FStartDate := Now;
  FEndDate := Now;
  InitDate;

  ActiveDataSet;
end;

procedure TFrmGatherfive.ShowWareDetail;
begin
  if (ADOMaster.IsEmpty) or (ADOMaster.FieldByName('商品编码').AsInteger <=0 ) then
    Exit;
  FrmGathersix := TFrmGathersix.Create(Self);
  FrmGathersix.WareID := ADOMaster.FieldByName('商品编码').AsString;
  FrmGathersix.Edit1.Text := ADOMaster.FieldByName('商品名称').AsString;
  FrmGathersix.StartDate := FStartDate;
  FrmGathersix.EndDate := FEndDate;
  FrmGathersix.Edit2.Text := Edit2.Text;
  FrmGathersix.ActiveDataSet;
  FrmGathersix.ShowModal;
  FrmGathersix.Free;
end;

procedure TFrmGatherfive.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  ShowWareDetail;
end;

procedure TFrmGatherfive.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 200 + StorageMove;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomWareName);
  ReportTool.SetVarible(CustomWareName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmGatherfive.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 200 + StorageMove;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomWareName);
  ReportTool.SetVarible(CustomWareName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.Preview;
  ReportTool.Free;
end;

procedure TFrmGatherfive.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 200 + StorageMove;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomWareName);
  ReportTool.SetVarible(CustomWareName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(Edit2.Text));

  ReportTool.AddDataSet(TADODataSet(DSMaster.DataSet));
  ReportTool.Print;
  ReportTool.Free;
end;

procedure TFrmGatherfive.SpeedButton2Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

end.
