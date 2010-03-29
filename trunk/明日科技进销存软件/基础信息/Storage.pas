unit Storage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, ComCtrls, ToolWin, Buttons,
  Grids, DBGrids, DB, ADODB, Menus;

type
  TFrmStorage = class(TFrmBase)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Btn_Append: TSpeedButton;
    Btn_Edit: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Select: TSpeedButton;
    DBGrid1: TDBGrid;
    ADOMaster: TADODataSet;
    DSMaster: TDataSource;
    ADOMasterDSDesigner: TAutoIncField;
    ADOMasterDSDesigner2: TStringField;
    ADOMasterDSDesigner3: TStringField;
    ADOMasterDSDesigner4: TStringField;
    ADOMasterflg: TBooleanField;
    Panel7: TPanel;
    Btn_Query: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    SpeedButton1: TSpeedButton;
    procedure Btn_SelectClick(Sender: TObject);
    procedure Btn_AppendClick(Sender: TObject);
    procedure Btn_EditClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Btn_QueryClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
  private
    procedure AppendRecord;
    procedure EditRecord;
    procedure DeleteRecord;
  public
    class procedure Show;
  end;

var
  FrmStorage: TFrmStorage;

implementation

uses DataModu, StorageEdit, MessageBox, PubConst, QueryData,
  ReportToolManage;

{$R *.dfm}

procedure TFrmStorage.AppendRecord;
begin
  FrmStorageEdit := TFrmStorageEdit.Create(Self);
  FrmStorageEdit.ADOEdit.Active := False;
  FrmStorageEdit.ADOEdit.CommandText := 'Select * From 仓库档案表 Where flg = 1';
  FrmStorageEdit.ADOEdit.Active := True;
  FrmStorageEdit.ADOEdit.Append;
  if FrmStorageEdit.ShowModal = mrOk then
  begin
    FrmStorageEdit.ADOEdit.UpdateBatch();
    ADOMaster.Active := False;
    ADOMaster.Active := True;
  end
  else
  begin
    FrmStorageEdit.ADOEdit.CancelBatch();
  end;
  FrmStorageEdit.Free;
end;

procedure TFrmStorage.Btn_SelectClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmStorage.DeleteRecord;
begin
  if ADOMaster.IsEmpty then
    Exit;
  if ShowMessageBox('是否要删除此记录！','系统提示') <> mrOk then
    Exit;
  ADOMaster.Edit;
  ADOMaster.FieldByName('flg').AsBoolean := False;
  ADOMaster.Post;
  ADOMaster.Active := False;
  ADOMaster.Active := True;
end;

procedure TFrmStorage.EditRecord;
begin
  if ADOMaster.IsEmpty then
    Exit;
  FrmStorageEdit := TFrmStorageEdit.Create(Self);
  FrmStorageEdit.ADOEdit.Active := False;
  FrmStorageEdit.ADOEdit.CommandText := 'Select  * From 仓库档案表 Where flg = 1 and 编号 = '+
    ADOMaster.FieldByName('编号').AsString;
  FrmStorageEdit.ADOEdit.Active := True;
  FrmStorageEdit.ADOEdit.Edit;
  if FrmStorageEdit.ShowModal = mrOk then
  begin
    FrmStorageEdit.ADOEdit.UpdateBatch();
    ADOMaster.Active := False;
    ADOMaster.Active := True;
  end
  else
  begin
    FrmStorageEdit.ADOEdit.CancelBatch();
  end;
  FrmStorageEdit.Free;
end;

class procedure TFrmStorage.Show;
begin
  FrmStorage := TFrmStorage.Create(Application);
  FrmStorage.ADOMaster.Active := True;
  FrmStorage.ShowModal;
  FrmStorage.Free;
end;

procedure TFrmStorage.Btn_AppendClick(Sender: TObject);
begin
  inherited;
  AppendRecord;
end;

procedure TFrmStorage.Btn_EditClick(Sender: TObject);
begin
  inherited;
  EditRecord;
end;

procedure TFrmStorage.Btn_DeleteClick(Sender: TObject);
begin
  inherited;
  DeleteRecord;
end;

procedure TFrmStorage.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmStorage.Btn_QueryClick(Sender: TObject);
var
  SQL:string;
begin
  inherited;
  if TFrmQueryData.ShowQueryData('select * from 仓库档案表 Where flg = 1',ADOMaster,SQL) = mrOk then
  begin
    ADOMaster.Active := False;
    ADOMaster.CommandText := SQL;
    ADOMaster.Active := True;
  end;
end;

procedure TFrmStorage.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := rpStorage;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDataSet(ADOMaster);
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmStorage.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := rpStorage;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDataSet(ADOMaster);
  ReportTool.Preview;
  ReportTool.Free;
end;

procedure TFrmStorage.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := rpStorage;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDataSet(ADOMaster);
  ReportTool.Print;
  ReportTool.Free;
end;

procedure TFrmStorage.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmStorage.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if ADOMaster.RecordCount > 0 then
    Btn_Edit.Click;
end;

procedure TFrmStorage.SpeedButton9Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

procedure TFrmStorage.SpeedButton10Click(Sender: TObject);
begin
  inherited;
  winexec('calc.exe',sw_normal);
end;

end.
