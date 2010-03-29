unit DWareInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, ComCtrls, Grids,
  DBGrids, DB, ADODB, Menus;

type
  TFrmWareInfo = class(TFrmBase)
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    Btn_Append: TSpeedButton;
    Btn_Edit: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Select: TSpeedButton;
    DBGrid1: TDBGrid;
    ADOMaster: TADODataSet;
    DSMaster: TDataSource;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    NExpand: TMenuItem;
    NCollapse: TMenuItem;
    ADOMasterDSDesigner: TAutoIncField;
    ADOMasterDSDesigner2: TStringField;
    ADOMasterDSDesigner3: TStringField;
    ADOMasterDSDesigner4: TStringField;
    ADOMasterDSDesigner5: TBCDField;
    ADOMasterDSDesigner6: TBCDField;
    ADOMasterDSDesigner7: TFloatField;
    ADOMasterDSDesigner8: TFloatField;
    ADOMasterDSDesigner9: TStringField;
    ADOMasterDSDesigner10: TStringField;
    ADOMasterDSDesigner11: TStringField;
    ADOMasterflg: TBooleanField;
    ADOMasterDSDesigner12: TStringField;
    Panel1: TPanel;
    Btn_Query: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    PopupMenu2: TPopupMenu;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure Btn_AppendClick(Sender: TObject);
    procedure Btn_EditClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Btn_QueryClick(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Btn_SelectClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    procedure AppendRecord;
    procedure EditRecord;
    procedure DeleteRecord;
  public
    class procedure Show;
  end;

var
  FrmWareInfo: TFrmWareInfo;

implementation

uses DataModu, WareEdit, MessageBox, PubConst, QueryData, ReportToolManage;

var
  OldSQL:string;
  
{$R *.dfm}

{ TFrmWareInfo }

procedure TFrmWareInfo.AppendRecord;
begin
  FrmWareEdit := TFrmWareEdit.Create(Self);
  FrmWareEdit.ADOEdit.Active := False;
  FrmWareEdit.ADOEdit.CommandText := 'Select top 10 * From 商品档案表 Where flg = 1';
  FrmWareEdit.ADOEdit.Active := True;
  FrmWareEdit.ADOEdit.Append;
  if FrmWareEdit.ShowModal = mrOk then
  begin
    FrmWareEdit.ADOEdit.UpdateBatch();
    ADOMaster.Active := False;
    ADOMaster.Active := True;
  end
  else
  begin
    FrmWareEdit.ADOEdit.CancelBatch();
  end;
  FrmWareEdit.Free;
end;

procedure TFrmWareInfo.DeleteRecord;
begin
  if ADOMaster.IsEmpty then
    Exit;
  if ShowMessageBox('是否删除此记录！','系统提示') <> mrOk then
    Exit;
  ADOMaster.Edit;
  ADOMaster.FieldByName('flg').AsBoolean := False;
  ADOMaster.Post;
  ADOMaster.Active := False;
  ADOMaster.Active := True;
end;

procedure TFrmWareInfo.EditRecord;
begin
  if ADOMaster.IsEmpty then
    Exit;
  FrmWareEdit := TFrmWareEdit.Create(Self);
  FrmWareEdit.ADOEdit.Active := False;
  FrmWareEdit.ADOEdit.CommandText := 'Select * From 商品档案表 Where flg = 1 and 商品编码 = '+
    ADOMaster.FieldByName('商品编码').AsString;
  FrmWareEdit.ADOEdit.Active := True;
  FrmWareEdit.ADOEdit.Edit;
  if FrmWareEdit.ShowModal = mrOk then
  begin
    FrmWareEdit.ADOEdit.UpdateBatch();
    ADOMaster.Active := False;
    ADOMaster.Active := True;
  end
  else
  begin
    FrmWareEdit.ADOEdit.CancelBatch();
  end;
  FrmWareEdit.Free;
end;

procedure TFrmWareInfo.Btn_AppendClick(Sender: TObject);
begin
  inherited;
  AppendRecord;
end;

class procedure TFrmWareInfo.Show;
begin
  FrmWareInfo := TFrmWareInfo.Create(Application);
  FrmWareInfo.ADOMaster.Active := True;
  FrmWareInfo.ShowModal;
  FrmWareInfo.Free;
end;

procedure TFrmWareInfo.Btn_EditClick(Sender: TObject);
begin
  inherited;
  EditRecord;
end;

procedure TFrmWareInfo.Btn_DeleteClick(Sender: TObject);
begin
  inherited;
  DeleteRecord;
end;

procedure TFrmWareInfo.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmWareInfo.Btn_QueryClick(Sender: TObject);
var
  SQL:string;
begin
  inherited;
  if Btn_Query.Tag = 0 then
  begin
    OldSQL := ADOMaster.CommandText;
    Btn_Query.Tag := 1;
  end;
    
  if TFrmQueryData.ShowQueryData(OldSQL,ADOMaster,SQL) = mrOk then
  begin
    ADOMaster.Active := False;
    ADOMaster.CommandText := SQL;
    ADOMaster.Active := True;
  end;
end;

procedure TFrmWareInfo.N8Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := rpWareInfo;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDataSet(ADOMaster);
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmWareInfo.N9Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := rpWareInfo;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDataSet(ADOMaster);
  ReportTool.Preview;
  ReportTool.Free;
end;

procedure TFrmWareInfo.N7Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := rpWareInfo;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDataSet(ADOMaster);
  ReportTool.Print;
  ReportTool.Free;
end;

procedure TFrmWareInfo.Btn_SelectClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmWareInfo.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if ADOMaster.RecordCount > 0 then
    Btn_Edit.Click;
end;

procedure TFrmWareInfo.SpeedButton2Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu2.Popup(CurPoint.X,CurPoint.Y);
end;

procedure TFrmWareInfo.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  winexec('calc.exe',sw_normal);
end;

end.
