unit Gathersix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, Grids, DBGrids,
  ComCtrls, DB, ADODB, Menus;

type
  TFrmGathersix = class(TFrmBase)
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
    Label2: TLabel;
    SpeedButton5: TSpeedButton;
    Edit2: TEdit;
    Edit1: TEdit;
    ADOMaster: TADODataSet;
    DSMaster: TDataSource;
    ADOMasterDSDesigner: TIntegerField;
    ADOMasterDSDesigner2: TStringField;
    ADOMasterDSDesigner3: TStringField;
    ADOMasterDSDesigner4: TStringField;
    ADOMasterDSDesigner5: TStringField;
    ADOMasterDSDesigner6: TIntegerField;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ADOMasterDSDesigner7: TStringField;
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private


    procedure SetDate(Sender:TObject);
    procedure InitDate;

  public
    WareID:string;
    StartDate:TDate;
    EndDate:TDate;
    
    procedure ActiveDataSet;
  end;

var
  FrmGathersix: TFrmGathersix;

implementation

uses DataModu, FindDate, SelectData, DWareMoveBill, PubConst,
  ReportToolManage;

{$R *.dfm}

{ TFrmGathersix }

procedure TFrmGathersix.ActiveDataSet;
var
  SQL:string;
  SQLWare:string;
begin

  if WareID = '-1' then
    SQLWare := ''
  else
    SQLWare := ' and d.��Ʒ��� = ' + WareID;

    
  SQL := 'Select s.��Ʒ����,s.��Ʒ����,CONVERT(char(10),m.��������,120) ��������,s.����ͺ�,s.��λ,d.����,Sum(d.����) ���������ϼ�'+
          ' From ��Ʒ�������� m,��Ʒ������ϸ�� d'+
          ' Left Join ��Ʒ������ s On d.��Ʒ��� = s.��Ʒ����'+
          ' Where m.���� = d.���� and m.flg = 1 and d.flg = 1'+
          ' and m.�������� BETWEEN '+
          QuotedStr(DateToStr(StartDate)+' 00:00:00') +
          ' and '+QuotedStr(DateToStr(EndDate)+' 23:59:59') + SQLWare +
          ' Group by s.��Ʒ����,s.��Ʒ����,s.����ͺ�,s.��λ,d.����,CONVERT(char(10),m.��������,120)';

  SQL := SQL + ' Union ALL ' + 'Select NULL,''�ϼ�'',NULL,NULL,NULL,NULL,ISNULL(SUM(���������ϼ�),0) From ('
  + SQL +') a';

  ADOMaster.Active := False;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;
end;

procedure TFrmGathersix.InitDate;
begin
  Edit2.Text := DateToStr(StartDate)+ '��' +
        DateToStr(EndDate);
end;

procedure TFrmGathersix.SetDate(Sender: TObject);
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

procedure TFrmGathersix.SpeedButton5Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectWare(0) = mrOk then
  begin
    WareID := FindID;
    Edit1.Text := FindName;
    ActiveDataSet;
  end;
end;

procedure TFrmGathersix.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  SetDate(Sender);
end;

procedure TFrmGathersix.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmGathersix.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  if (ADOMaster.IsEmpty) or (ADOMaster.FieldByName('����').AsString = '') then
    Exit;
  TFrmWareMove.ShowBillDetail(ADOMaster.FieldByName('����').AsString);
end;

procedure TFrmGathersix.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmGathersix.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 300 + StorageMove;
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

procedure TFrmGathersix.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 300 + StorageMove;
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

procedure TFrmGathersix.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 300 + StorageMove;
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

procedure TFrmGathersix.SpeedButton2Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

end.
