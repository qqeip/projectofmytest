unit DWareMoveBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Mask, DBCtrls, ComCtrls,
  Buttons, Grids, DBGrids, DB, ADODB,PubConst, Menus;

type
  TFrmWareMove = class(TFrmBase)
    StatusBar1: TStatusBar;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel3: TPanel;
    Btn_AddRow: TSpeedButton;
    Btn_DeleteRow: TSpeedButton;
    Btn_Post: TSpeedButton;
    Btn_Close: TSpeedButton;
    Btn_DeleteBill: TSpeedButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton15: TSpeedButton;
    D_OperationDate: TDateTimePicker;
    E_MoveOutStorage: TEdit;
    E_PersonOperation: TEdit;
    E_MoveInStorage: TEdit;
    ADOWareDataSet: TADODataSet;
    ADOWareDataSetWareID: TIntegerField;
    ADOWareDataSetWareName: TStringField;
    ADOWareDataSetWareSpec: TStringField;
    ADOWareDataSetWareUnit: TStringField;
    ADOWareDataSetWareCount: TIntegerField;
    DataSource1: TDataSource;
    E_BillCode: TEdit;
    E_Memo: TEdit;
    ADOWareDataSetWareMemo: TStringField;
    DBGrid1: TDBGrid;
    Label7: TLabel;
    ADOWareDataSetWareSpell: TStringField;
    ADOPost: TADODataSet;
    Panel2: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ADOTemp: TADODataSet;
    SpeedButton4: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure DBGrid1EditButtonClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure Btn_PostClick(Sender: TObject);
    procedure Btn_AddRowClick(Sender: TObject);
    procedure Btn_DeleteRowClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure N3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure Btn_DeleteBillClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    FBillType:TBillType;
    FMoveOutStorageID:string;
    FMoveInStorageID:string;

    procedure SetBillType(Value:TBillType);
    procedure DataSetCalcSum;

    procedure AddRow;
    procedure DeleteRow;

    procedure Save(Sender:TObject);
    procedure SaveMaster;
    procedure SaveDetail;
    procedure ClearBill;

    procedure SetBillCode(vBillCode:string;PostEnable:Boolean = False);
    procedure NextBill;
    procedure UpBill;
  protected
    property BillType:TBillType read FBillType write SetBillType;
  public
    class procedure ShowWareMove;
    class procedure ShowBillDetail(vBillCode:string);   //���ݵ�����ʾ������ϸ
  end;

var
  FrmWareMove: TFrmWareMove;

implementation

uses DataModu, SelectData, MessageBox, ReportToolManage, BillQuery;

{$R *.dfm}

procedure TFrmWareMove.FormCreate(Sender: TObject);
begin
  inherited;
  ADOWareDataSet.CreateDataSet;
end;

procedure TFrmWareMove.SetBillType(Value: TBillType);
begin
  FBillType := Value;
  E_BillCode.Text := ToolManage.GetBillCode(FBillType);
  D_OperationDate.DateTime := Now;
  E_PersonOperation.Text := LoginName;
end;

class procedure TFrmWareMove.ShowWareMove;
begin
  FrmWareMove := TFrmWareMove.Create(Application);
//  FrmWareMove.Caption := '�ֿ������';
  FrmWareMove.BillType := StorageMove;
  FrmWareMove.ShowModal;
  FrmWareMove.Free;
end;

procedure TFrmWareMove.FormShow(Sender: TObject);
begin
  inherited;
  Label7.Caption := Caption;
end;

procedure TFrmWareMove.SpeedButton9Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectStorage = mrOk then
  begin
    E_MoveOutStorage.Text := FindName;
    FMoveOutStorageID := FindID;
  end;
end;

procedure TFrmWareMove.SpeedButton15Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectStorage = mrOk then
  begin
    E_MoveInStorage.Text := FindName;
    FMoveInStorageID := FindID;
  end;
end;

procedure TFrmWareMove.DBGrid1EditButtonClick(Sender: TObject);
begin
  inherited;
  TFrmSelectData.SelectWare(ADOWareDataSet,FBillType);
  DataSetCalcSum;
end;

procedure TFrmWareMove.DataSetCalcSum;
var
  RecNo:Integer;
  I:Integer;
  CountSum:Integer;
begin
  CountSum := 0;
  if not ADOWareDataSet.IsEmpty then
  begin
    if DBGrid1.EditorMode then
    begin
      ADOWareDataSet.Edit;
      ADOWareDataSet.Post;
    end;
    RecNo := ADOWareDataSet.RecNo;
    ADOWareDataSet.DisableControls;
    for i:=1 to ADOWareDataSet.RecordCount do
    begin
      ADOWareDataSet.RecNo := i;
      CountSum := CountSum + ADOWareDataSet.FieldByName('WareCount').AsInteger;
    end;
    ADOWareDataSet.RecNo := RecNo;
    ADOWareDataSet.EnableControls;
  end;
  Panel6.Caption := '��Ʒ�����ϼƣ�'+ IntToStr(CountSum);
end;

procedure TFrmWareMove.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    DataSetCalcSum;
end;

procedure TFrmWareMove.AddRow;
begin
  ADOWareDataSet.Append;
end;

procedure TFrmWareMove.DeleteRow;
begin
  if not ADOWareDataSet.IsEmpty then
  if ShowMessageBox('�Ƿ�ɾ����ǰ�У�','ϵͳ��ʾ') = mrOk then
  begin

    ADOWareDataSet.Delete;
  end;
end;

procedure TFrmWareMove.Save(Sender: TObject);
begin
  if ADOWareDataSet.IsEmpty then
  begin
    ShowMessage('�õ�����û����Ʒ�����ܱ��棡');
    Exit;
  end;
  FrmDataModu.ADOCon.BeginTrans;
  try
    ClearBill;
    SaveMaster;
    SaveDetail;
  except
    FrmDataModu.ADOCon.RollbackTrans;
    Application.MessageBox('�õ��ݱ���ʧ�ܣ�', 'ϵͳ��ʾ', MB_OK + MB_ICONWARNING);
    Exit;
  end;
  FrmDataModu.ADOCon.CommitTrans;
  Application.MessageBox('�õ��ݱ���ɹ���', 'ϵͳ��ʾ', MB_OK + MB_ICONWARNING);
  Close;
end;

procedure TFrmWareMove.SaveDetail;
var
  i:Integer;
begin
  ADOPost.Active := False;
  ADOPost.CommandText := 'Select * From ��Ʒ������ϸ�� Where flg  = 1';
  ADOPost.Active := True;
  
  for i := 1 to ADOWareDataSet.RecordCount do
  begin
    ADOWareDataSet.RecNo := i;
    ADOPost.Append;
    ADOPost.FieldByName('����').AsString := E_BillCode.Text;
    ADOPost.FieldByName('��Ʒ���').AsString :=
        ADOWareDataSet.FieldByName('WareID').AsString;
    ADOPost.FieldByName('����').AsString :=
        ADOWareDataSet.FieldByName('WareCount').AsString;
    ADOPost.FieldByName('��ע').AsString :=
        ADOWareDataSet.FieldByName('WareMemo').AsString;
    ADOPost.Post;
  end;
end;

procedure TFrmWareMove.SaveMaster;
begin
  ADOPost.Active := False;
  ADOPost.CommandText := 'Select * From ��Ʒ�������� Where Flg = 1';
  ADOPost.Active := True;
  
  ADOPost.Append;
  ADOPost.FieldByName('����').AsString := E_BillCode.Text;
  ADOPost.FieldByName('����ֿ�').AsString := FMoveInStorageID;
  ADOPost.FieldByName('������').AsString := E_PersonOperation.Text;
  ADOPost.FieldByName('��ע').AsString := E_Memo.Text;
  ADOPost.FieldByName('�����ֿ�').AsString := FMoveOutStorageID;
  ADOPost.FieldByName('��������').AsDateTime := D_OperationDate.DateTime;
  ADOPost.FieldByName('ϵͳ����').AsDateTime := Now;
  ADOPost.FieldByName('��������').AsInteger := FBillType;
  ADOPost.Post;
end;

procedure TFrmWareMove.Btn_PostClick(Sender: TObject);
begin
  inherited;
  Save(Sender);
end;

procedure TFrmWareMove.Btn_AddRowClick(Sender: TObject);
begin
  inherited;
  AddRow;
end;

procedure TFrmWareMove.Btn_DeleteRowClick(Sender: TObject);
begin
  inherited;
  DeleteRow;
end;

procedure TFrmWareMove.Btn_CloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

class procedure TFrmWareMove.ShowBillDetail(vBillCode: string);
begin
  FrmWareMove := TFrmWareMove.Create(Application);
  FrmWareMove.SetBillCode(vBillCode);
  FrmWareMove.ShowModal;
  FrmWareMove.Free;
end;

procedure TFrmWareMove.SetBillCode(vBillCode: string; PostEnable: Boolean);
  procedure SetMasterBill;
  begin
    ADOPost.Active := False;
    ADOPost.CommandText := 'Select m.*,b.�ֿ����� �����ֿ�����,c.�ֿ����� ����ֿ�����'+
                  ' From ��Ʒ�������� m '+
                  ' Left Join �ֿ⵵���� b On m.�����ֿ� = b.���'+
                  ' Left Join �ֿ⵵���� c On m.����ֿ� = c.���'+
                  ' Where m.flg = 1 and m.���� = ' + QuotedStr(vBillCode);
    ADOPost.Active := True;
    if ADOPost.IsEmpty then
      Exit;
      

    E_BillCode.Text := vBillCode;
    D_OperationDate.DateTime := ADOPost.FieldByName('��������').AsDateTime;

    E_MoveOutStorage.Text := ADOPost.FieldByName('�����ֿ�����').AsString;
    FMoveOutStorageID := ADOPost.FieldByName('�����ֿ�').AsString;

    E_MoveInStorage.Text := ADOPost.FieldByName('����ֿ�����').AsString;
    FMoveInStorageID := ADOPost.FieldByName('����ֿ�').AsString;

    E_PersonOperation.Text := ADOPost.FieldByName('������').AsString;
    E_Memo.Text := ADOPost.FieldByName('��ע').AsString;
    
  end;

  procedure SetDetailBill;
  var
    i:Integer;
  begin
    ADOPost.Active := False;
    ADOPost.CommandText := 'Select d.*,s.��Ʒ����,s.ƴ������,s.����ͺ�'+
              ' ,s.��λ From ��Ʒ������ϸ�� d '+
              ' Left Join ��Ʒ������ s On s.��Ʒ���� = d.��Ʒ���'+
              ' where d.flg = 1 and d.���� = '+ QuotedStr(vBillCode);
    ADOPost.Active := True;

    if ADOPost.IsEmpty then
      Exit;

    ADOWareDataSet.Close;
    ADOWareDataSet.CreateDataSet;

    for i:=0 to ADOPost.RecordCount -1 do
    begin
      ADOWareDataSet.Append;
      ADOWareDataSet.FieldByName('WareID').AsString :=
          ADOPost.FieldByName('��Ʒ���').AsString;
      ADOWareDataSet.FieldByName('WareName').AsString :=
          ADOPost.FieldByName('��Ʒ����').AsString;
      ADOWareDataSet.FieldByName('WareSpell').AsString :=
          ADOPost.FieldByName('ƴ������').AsString;
      ADOWareDataSet.FieldByName('WareSpec').AsString :=
          ADOPost.FieldByName('����ͺ�').AsString;
      ADOWareDataSet.FieldByName('WareUnit').AsString :=
          ADOPost.FieldByName('��λ').AsString;
      ADOWareDataSet.FieldByName('WareCount').AsString :=
          ADOPost.FieldByName('����').AsString;
      ADOWareDataSet.FieldByName('WareMemo').AsString :=
          ADOPost.FieldByName('��ע').AsString;
      ADOWareDataSet.Post;
      ADOPost.Next;
    end;
  end;
begin
  Btn_Post.Visible := PostEnable;
  Btn_AddRow.Visible := PostEnable;
  Btn_DeleteRow.Visible := PostEnable;
  Btn_DeleteBill.Visible := PostEnable;
  SpeedButton7.Visible := PostEnable;
  SpeedButton6.Visible := PostEnable;
  SpeedButton5.Visible := PostEnable;

  SetMasterBill;
  SetDetailBill;
  DataSetCalcSum;
end;

procedure TFrmWareMove.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmWareMove.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 500 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);

  ReportTool.AddVariable(CustomVarible,CustomInStorage);
  ReportTool.SetVarible(CustomInStorage,QuotedStr(E_MoveInStorage.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(DateToStr(D_OperationDate.Date)));

  ReportTool.AddVariable(CustomVarible,CustomOutStorage);
  ReportTool.SetVarible(CustomOutStorage,QuotedStr(E_MoveOutStorage.Text));

  ReportTool.AddVariable(CustomVarible,CustomPerson);
  ReportTool.SetVarible(CustomPerson,QuotedStr(E_PersonOperation.Text));

  ReportTool.AddVariable(CustomVarible,CustomMemo);
  ReportTool.SetVarible(CustomMemo,QuotedStr(E_Memo.Text));

  ReportTool.AddVariable(CustomVarible,CustomBillCode);
  ReportTool.SetVarible(CustomBillCode,QuotedStr(E_BillCode.Text));

  ReportTool.AddDataSet(TADODataSet(ADOWareDataSet));
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmWareMove.SpeedButton5Click(Sender: TObject);
var
  BillCode:string;
begin
  inherited;
  BillCode := TFrmBillQuery.BillQuery(BillType);
  if BillCode <> '' then
  begin
    SetBillCode(BillCode,True);  
  end;
end;

procedure TFrmWareMove.NextBill;
var
  SQL:string;
begin
  SQL := 'Select top 1 ���� From ��Ʒ��������'+
          ' Where �������� = '+ IntToStr(BillType) +' and ��� > (Select ��� From ��Ʒ��������'+
          ' Where ���� = ' + QuotedStr(E_BillCode.Text) + ')';
  ADOTemp.Active := False;
  ADOTemp.CommandText := SQL;
  ADOTemp.Active := True;
  if not ADOTemp.IsEmpty then
    SetBillCode(ADOTemp.FieldByName('����').AsString,True);
end;

procedure TFrmWareMove.UpBill;
var
  SQL:string;
begin
  SQL := 'Select top 1 ���� From ��Ʒ��������'+
          ' Where �������� = '+ IntToStr(BillType) +' and ��� < (Select ��� From ��Ʒ��������'+
          ' Where ���� = ' + QuotedStr(E_BillCode.Text) + ')'+
          ' Order By ��� DESC';
  ADOTemp.Active := False;
  ADOTemp.CommandText := SQL;
  ADOTemp.Active := True;
  if not ADOTemp.IsEmpty then
    SetBillCode(ADOTemp.FieldByName('����').AsString,True);
end;

procedure TFrmWareMove.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  NextBill;
end;

procedure TFrmWareMove.SpeedButton7Click(Sender: TObject);
begin
  inherited;
  UpBill;
end;

procedure TFrmWareMove.ClearBill;
var
  SQL:string;
begin
  SQL := 'Delete From ��Ʒ�������� Where ���� = '+ QuotedStr(E_BillCode.Text) +
         ' Delete From ��Ʒ������ϸ�� Where ���� = '+ QuotedStr(E_BillCode.Text);
  FrmDataModu.ADOQuery1.Close;
  FrmDataModu.ADOQuery1.SQL.Text := SQL;
  FrmDataModu.ADOQuery1.ExecSQL;
end;

procedure TFrmWareMove.Btn_DeleteBillClick(Sender: TObject);
begin
  inherited;
  if ADOWareDataSet.IsEmpty then
    Exit;
  if ShowMessageBox('�Ƿ�Ҫɾ���˵��ݣ�','ϵͳ��ʾ') = mrOk then
  begin
    ClearBill;
    BillType := FBillType;

    E_MoveOutStorage.Text := '';
    FMoveOutStorageID := '-1';

    E_MoveInStorage.Text := '';
    FMoveInStorageID := '-1';

    E_Memo.Text := '';
    ADOWareDataSet.Close;
    ADOWareDataSet.CreateDataSet;
  end;
end;

procedure TFrmWareMove.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 500 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);

  ReportTool.AddVariable(CustomVarible,CustomInStorage);
  ReportTool.SetVarible(CustomInStorage,QuotedStr(E_MoveInStorage.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(DateToStr(D_OperationDate.Date)));

  ReportTool.AddVariable(CustomVarible,CustomOutStorage);
  ReportTool.SetVarible(CustomOutStorage,QuotedStr(E_MoveOutStorage.Text));

  ReportTool.AddVariable(CustomVarible,CustomPerson);
  ReportTool.SetVarible(CustomPerson,QuotedStr(E_PersonOperation.Text));

  ReportTool.AddVariable(CustomVarible,CustomMemo);
  ReportTool.SetVarible(CustomMemo,QuotedStr(E_Memo.Text));

  ReportTool.AddVariable(CustomVarible,CustomBillCode);
  ReportTool.SetVarible(CustomBillCode,QuotedStr(E_BillCode.Text));

  ReportTool.AddDataSet(TADODataSet(ADOWareDataSet));
  ReportTool.Preview;
  ReportTool.Free;
end;

procedure TFrmWareMove.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 500 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);

  ReportTool.AddVariable(CustomVarible,CustomInStorage);
  ReportTool.SetVarible(CustomInStorage,QuotedStr(E_MoveInStorage.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(DateToStr(D_OperationDate.Date)));

  ReportTool.AddVariable(CustomVarible,CustomOutStorage);
  ReportTool.SetVarible(CustomOutStorage,QuotedStr(E_MoveOutStorage.Text));

  ReportTool.AddVariable(CustomVarible,CustomPerson);
  ReportTool.SetVarible(CustomPerson,QuotedStr(E_PersonOperation.Text));

  ReportTool.AddVariable(CustomVarible,CustomMemo);
  ReportTool.SetVarible(CustomMemo,QuotedStr(E_Memo.Text));

  ReportTool.AddVariable(CustomVarible,CustomBillCode);
  ReportTool.SetVarible(CustomBillCode,QuotedStr(E_BillCode.Text));

  ReportTool.AddDataSet(TADODataSet(ADOWareDataSet));
  ReportTool.Print;
  ReportTool.Free;
end;

procedure TFrmWareMove.SpeedButton3Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

procedure TFrmWareMove.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  winexec('calc.exe',sw_normal);
end;

procedure TFrmWareMove.SpeedButton4Click(Sender: TObject);
begin
  inherited;
  Close;
end;

end.

