unit ComeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, ComCtrls, Buttons, Grids,
  DBGrids, DB, ADODB,PubConst, Menus;

type
  TFrmComeUnit = class(TFrmBase)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    ADOMaster: TADODataSet;
    ADODetail: TADODataSet;
    DSMaster: TDataSource;
    DSDetail: TDataSource;
    ADOMasterDSDesigner: TAutoIncField;
    ADOMasterDSDesigner2: TStringField;
    ADOMasterDSDesigner3: TStringField;
    ADOMasterDSDesigner4: TStringField;
    ADOMasterDSDesigner5: TStringField;
    ADOMasterDSDesigner6: TIntegerField;
    ADOMasterflg: TBooleanField;
    ADODetailDSDesigner: TAutoIncField;
    ADODetailDSDesigner2: TIntegerField;
    ADODetailDSDesigner3: TStringField;
    ADODetailDSDesigner4: TStringField;
    ADODetailDSDesigner5: TStringField;
    ADODetailflg: TBooleanField;
    ADODetailDSDesigner6: TStringField;
    ADOMasterDSDesigner7: TStringField;
    Splitter1: TSplitter;
    Panel7: TPanel;
    Btn_Query: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure SpeedButton7Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ADOMasterAfterScroll(DataSet: TDataSet);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid3DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Btn_QueryClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
  private
    FUnitType:TUnitType;    //单位类型

    //单位类型
    procedure SetUnitType(value:TUnitType);
    //按单位类型激活数据集
    procedure ActiveADOForUnitType(uType:TUnitType);
    //激活联系人数据集
    procedure ActiveDetail;
    //删除记录
    procedure DeleteRecord(vType:Integer);
    //编辑记录
    procedure EditRecord(vType:Integer);
    //添加记录
    procedure AppendRecord(vType:Integer);
  protected
    property UnitType:TUnitType read FUnitType write SetUnitType;
  public
    class procedure Show;
  end;

var
  FrmComeUnit: TFrmComeUnit;

implementation

uses DataModu, MessageBox, AccountUnitEdit, LinkPersonEdit, QueryData,
  ReportToolManage;

{$R *.dfm}

procedure TFrmComeUnit.ActiveADOForUnitType(uType: TUnitType);
var
  SQL:string;
begin
  ADOMaster.Active := False;
  case uType of
    utClient:
    begin
      SQL := 'select * from 客户档案 Where flg = 1 and 单位性质 = ' + IntToStr(utClient);
    end;
    utProvide:
    begin
      SQL := 'select * from 客户档案 Where flg = 1 and 单位性质 = ' + IntToStr(utProvide);
    end;
  end;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;
end;

procedure TFrmComeUnit.SetUnitType(value: TUnitType);
begin
  FUnitType := value;
  ActiveADOForUnitType(FUnitType);
end;

class procedure TFrmComeUnit.Show;
begin
  FrmComeUnit := TFrmComeUnit.Create(Application);
  FrmComeUnit.UnitType := utProvide;
  FrmComeUnit.PageControl1.ActivePageIndex := 0;
  FrmComeUnit.ShowModal;
  FrmComeUnit.Free;
end;

procedure TFrmComeUnit.SpeedButton7Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmComeUnit.PageControl1Change(Sender: TObject);
begin
  inherited;
  if PageControl1.ActivePageIndex = 0 then
    UnitType := utProvide
  else
    UnitType := utClient;
end;

procedure TFrmComeUnit.ActiveDetail;
begin
  if ADOMaster.IsEmpty then
    Exit;
  ADODetail.Active := False;
  ADODetail.CommandText := 'Select * From 联系人表 Where flg = 1 and 单位编号 = '+
        ADOMaster.FieldByName('编号').AsString;
  ADODetail.Active := True;
end;

procedure TFrmComeUnit.ADOMasterAfterScroll(DataSet: TDataSet);
begin
  inherited;
  ActiveDetail;
end;

procedure TFrmComeUnit.DeleteRecord(vType: Integer);
begin
  if ShowMessageBox('是否删除此记录！','系统提示') <> mrOk then
    Exit;

  case vType of
    utClient,utProvide:
    begin
      ADOMaster.Edit;
      ADOMaster.FieldByName('flg').AsBoolean := False;
      ADOMaster.Post;
      ADOMaster.Active := False;
      ADOMaster.Active := True;
    end;
    PLink:
    begin
      ADODetail.Edit;
      ADODetail.FieldByName('flg').AsBoolean := False;
      ADODetail.Post;
      ADODetail.Active := False;
      ADODetail.Active := True;
    end;
  end;
end;

procedure TFrmComeUnit.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  DeleteRecord(PLink);
end;

procedure TFrmComeUnit.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  DeleteRecord(UnitType);
end;

procedure TFrmComeUnit.EditRecord(vType: Integer);
begin
  case vType of
    utProvide,utClient:
    begin
      if ADOMaster.IsEmpty then
        Exit;
      FrmAccountUnitEdit := TFrmAccountUnitEdit.Create(Self);
      FrmAccountUnitEdit.ADOEdit.Active := False;
      FrmAccountUnitEdit.ADOEdit.CommandText := 'Select * From 客户档案 Where flg = 1 and 编号 = '+
            ADOMaster.FieldByName('编号').AsString;
      FrmAccountUnitEdit.ADOEdit.Active := True;
      FrmAccountUnitEdit.ADOEdit.Edit;
      if FrmAccountUnitEdit.ShowModal = mrOk then
      begin
        FrmAccountUnitEdit.ADOEdit.UpdateBatch();
        ADOMaster.Active := False;
        ADOMaster.Active := True;
      end
      else
      begin
        FrmAccountUnitEdit.ADOEdit.CancelBatch();
      end;
      FrmAccountUnitEdit.Free;
    end;
    PLink:
    begin
      if ADODetail.IsEmpty then
        Exit;
      FrmLinkPersonEdit := TFrmLinkPersonEdit.Create(Self);
      FrmLinkPersonEdit.ADOEdit.Active := False;
      FrmLinkPersonEdit.ADOEdit.CommandText := 'Select * From 联系人表 Where flg = 1 and 编号 = '+
        ADODetail.FieldByName('编号').AsString;
      FrmLinkPersonEdit.ADOEdit.Active := True;
      FrmLinkPersonEdit.ADOEdit.Edit;
      if FrmLinkPersonEdit.ShowModal = mrOk then
      begin
        FrmLinkPersonEdit.ADOEdit.UpdateBatch();
        ADODetail.Active := False;
        ADODetail.Active := True;
      end
      else
      begin
        FrmLinkPersonEdit.ADOEdit.CancelBatch();
      end;
      FrmLinkPersonEdit.Free;
    end;
  end;
end;

procedure TFrmComeUnit.SpeedButton5Click(Sender: TObject);
begin
  inherited;
  EditRecord(PLink);
end;

procedure TFrmComeUnit.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  EditRecord(UnitType);
end;

procedure TFrmComeUnit.AppendRecord(vType: Integer);
begin
  case vType of
    utProvide,utClient:
    begin
      FrmAccountUnitEdit := TFrmAccountUnitEdit.Create(Self);
      FrmAccountUnitEdit.ADOEdit.Active := False;
      FrmAccountUnitEdit.ADOEdit.CommandText := 'Select top 10 * From 客户档案 Where flg = 1';
      FrmAccountUnitEdit.ADOEdit.Active := True;
      FrmAccountUnitEdit.ADOEdit.Append;
      if FrmAccountUnitEdit.ShowModal = mrOk then
      begin
        FrmAccountUnitEdit.ADOEdit.FieldByName('单位性质').AsInteger := vType;
        FrmAccountUnitEdit.ADOEdit.UpdateBatch();
        ADOMaster.Active := False;
        ADOMaster.Active := True;
      end
      else
      begin
        FrmAccountUnitEdit.ADOEdit.CancelBatch();
      end;
      FrmAccountUnitEdit.Free;
    end;
    PLink:
    begin
      if ADOMaster.IsEmpty then
        Exit;
      FrmLinkPersonEdit := TFrmLinkPersonEdit.Create(Self);
      FrmLinkPersonEdit.ADOEdit.Active := False;
      FrmLinkPersonEdit.ADOEdit.CommandText := 'Select Top 10 * From 联系人表 Where flg = 1';
      FrmLinkPersonEdit.ADOEdit.Active := True;
      FrmLinkPersonEdit.ADOEdit.Append;
      if FrmLinkPersonEdit.ShowModal = mrOk then
      begin
        FrmLinkPersonEdit.ADOEdit.FieldByName('单位编号').AsString :=
          ADOMaster.FieldByName('编号').AsString;
        FrmLinkPersonEdit.ADOEdit.UpdateBatch();
        ADODetail.Active := False;
        ADODetail.Active := True;
      end
      else
      begin
        FrmLinkPersonEdit.ADOEdit.CancelBatch();
      end;
      FrmLinkPersonEdit.Free;
    end;
  end;
end;

procedure TFrmComeUnit.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  AppendRecord(PLink);
end;

procedure TFrmComeUnit.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  AppendRecord(UnitType);
end;

procedure TFrmComeUnit.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmComeUnit.DBGrid3DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmComeUnit.Btn_QueryClick(Sender: TObject);
var
  SQL:string;
  OldSQL:string;
begin
  inherited;
  
  case UnitType of
    utClient:
    begin
      OldSQL := 'select * from 客户档案 Where flg = 1 and 单位性质 = ' + IntToStr(utClient);
    end;
    utProvide:
    begin
      OldSQL := 'select * from 客户档案 Where flg = 1 and 单位性质 = ' + IntToStr(utProvide);
    end;
  end;
  
  if TFrmQueryData.ShowQueryData(OldSQL,ADOMaster,SQL) = mrOk then
  begin
    ADOMaster.Active := False;
    ADOMaster.CommandText := SQL;
    ADOMaster.Active := True;
  end;
end;

procedure TFrmComeUnit.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := rpComeUnit;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDataSet(ADOMaster);
  ReportTool.AddDataSet(ADODetail);
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmComeUnit.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  if ADOMaster.RecordCount > 0 then
    SpeedButton2.Click;
end;

procedure TFrmComeUnit.DBGrid3DblClick(Sender: TObject);
begin
  inherited;
  if ADODetail.RecordCount > 0 then
    SpeedButton5.Click;
end;

procedure TFrmComeUnit.SpeedButton10Click(Sender: TObject);
begin
  inherited;
  winexec('calc.exe',sw_normal);
end;

end.
