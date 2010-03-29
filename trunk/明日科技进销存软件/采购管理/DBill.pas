unit DBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, ComCtrls, Mask,
  DBCtrls, Grids, DB, ADODB, DBGrids,PubConst, Menus;

type
  TFrmStockBill = class(TFrmBase)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Label1: TLabel;
    D_OperationDate: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    E_Unit: TEdit;
    E_PersonOperation: TEdit;
    SpeedButton9: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Panel3: TPanel;
    Btn_AddRow: TSpeedButton;
    Btn_DeleteRow: TSpeedButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Btn_Post: TSpeedButton;
    Btn_Close: TSpeedButton;
    Btn_DeleteBill: TSpeedButton;
    ADOWareDataSet: TADODataSet;
    DSWare: TDataSource;
    ADOWareDataSetWareName: TStringField;
    ADOWareDataSetWareID: TIntegerField;
    ADOWareDataSetWareSpec: TStringField;
    ADOWareDataSetWareUnit: TStringField;
    ADOWareDataSetWarePrice: TCurrencyField;
    ADOWareDataSetWareCount: TIntegerField;
    ADOWareDataSetWareMemo: TStringField;
    ADOWareDataSetWareSumPrice: TCurrencyField;
    Panel6: TPanel;
    E_Storage: TEdit;
    SpeedButton15: TSpeedButton;
    E_BillCode: TEdit;
    E_Memo: TEdit;
    DBGrid1: TDBGrid;
    Panel8: TPanel;
    Panel9: TPanel;
    ADOWareDataSetWareSpell: TStringField;
    Label7: TLabel;
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
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure DBGrid1EditButtonClick(Sender: TObject);
    procedure ADOWareDataSetCalcFields(DataSet: TDataSet);
    procedure Btn_AddRowClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure Btn_PostClick(Sender: TObject);
    procedure ADOWareDataSetBeforePost(DataSet: TDataSet);
    procedure Btn_CloseClick(Sender: TObject);
    procedure Btn_DeleteRowClick(Sender: TObject);
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
  private
    FBillType:TBillType;
    FComeUnitID:string;
    FStorageID:string;

    procedure SetBillType(Value:TBillType);
    procedure DataSetCalcSum;

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
    class procedure ShowStockInStorage;     //�ɹ����
    class procedure ShowStockOutStorage;    //�ɹ��˻�
    class procedure ShowSellOutStorage;     //���۳���
    class procedure ShowSellInStorage;      //�����˻�
    class procedure ShowBillDetail(vBillCode:string);   //���ݵ�����ʾ������ϸ
  end;

var
  FrmStockBill: TFrmStockBill;

implementation

uses DataModu, SelectData, MessageBox, ReportToolManage, BillQuery;

{$R *.dfm}

procedure TFrmStockBill.FormCreate(Sender: TObject);
begin
  inherited;
  ADOWareDataSet.CreateDataSet;

end;

procedure TFrmStockBill.SetBillType(Value: TBillType);
begin
  FBillType := Value;
  E_BillCode.Text := ToolManage.GetBillCode(FBillType);
  D_OperationDate.DateTime := Now;
  E_PersonOperation.Text := LoginName;
end;

class procedure TFrmStockBill.ShowStockInStorage;
begin
  FrmStockBill := TFrmStockBill.Create(Application);
  FrmStockBill.BillType := StockInStorage;
  FrmStockBill.ShowModal;
  FrmStockBill.Free;
end;

procedure TFrmStockBill.SpeedButton9Click(Sender: TObject);
var
  vType:Integer;
begin
  inherited;
  if not ADOWareDataSet.IsEmpty then
  begin
    if ShowMessageBox('�ı䵥λ����ձ������ݣ�','ϵͳ��ʾ') <> mrOk then
      Exit
    else
    begin
      ADOWareDataSet.Close;
      ADOWareDataSet.CreateDataSet;
    end;
  end;


  if (FBillType = SellOutStorage) or (FBillType = SellInStorage) then
    vType := utClient
  else
    vType := utProvide;
    
  if TFrmSelectData.SelectComeUnit(vType) = mrOk then
  begin
    E_Unit.Text := FindName;
    FComeUnitID := FindID;    
  end;
end;

procedure TFrmStockBill.SpeedButton15Click(Sender: TObject);
begin
  inherited;
  if not ADOWareDataSet.IsEmpty then
  begin
    if ShowMessageBox('�ı�ֿ⽫��ձ������ݣ�','ϵͳ��ʾ') <> mrOk then
      Exit
    else
    begin
      ADOWareDataSet.Close;
      ADOWareDataSet.CreateDataSet;
    end;
  end;
  if TFrmSelectData.SelectStorage = mrOk then
  begin
    E_Storage.Text := FindName;
    FStorageID := FindID;
  end;
end;

procedure TFrmStockBill.DBGrid1EditButtonClick(Sender: TObject);
begin
  inherited;
  TFrmSelectData.SelectWare(ADOWareDataSet,FBillType,FComeUnitID,FStorageID);
  DataSetCalcSum;
end;

procedure TFrmStockBill.ADOWareDataSetCalcFields(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('WareSumPrice').AsCurrency :=
    DataSet.FieldByName('WarePrice').AsCurrency *
        DataSet.FieldByName('WareCount').AsInteger;
  if (FBillType = StockOutStorage) or (FBillType = SellInStorage) then
  begin
    if DataSet.FieldByName('WareSumPrice').AsCurrency > 0 then
      DataSet.FieldByName('WareSumPrice').AsCurrency :=
        - DataSet.FieldByName('WareSumPrice').AsCurrency;
  end;
end;

procedure TFrmStockBill.Btn_AddRowClick(Sender: TObject);
begin
  inherited;
  ADOWareDataSet.Append;
end;

procedure TFrmStockBill.FormShow(Sender: TObject);
begin
  case FBillType of
    StockInStorage:
    begin
      Caption := '�ɹ���ⵥ';
    end;
    StockOutStorage:
    begin
      Caption := '�ɹ��˻���';
    end;
    SellOutStorage:
    begin
      Caption := '���۳��ⵥ';
    end;
    SellInStorage:
    begin
      Caption := '�����˻���';
    end;
  end;

  Label7.Caption := Caption;
  if (FBillType = StockOutStorage) or (FBillType = SellInStorage) then
  begin
    DBGrid1.Font.Color := clRed;
  end;

  if (FBillType = SellOutStorage) or (FBillType = SellInStorage) then
  begin

    Label3.Caption := '������λ��  ';
    Label5.Caption := '�����ֿ⣺  ';
  end;
  inherited;
end;

procedure TFrmStockBill.DataSetCalcSum;
var
  RecNo:Integer;
  I:Integer;
  MoneySum:Currency;
  CountSum:Integer;
begin
  MoneySum := 0;
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
      MoneySum := MoneySum + ADOWareDataSet.FieldByName('WarePrice').AsCurrency *
            ADOWareDataSet.FieldByName('WareCount').AsInteger;
      CountSum := CountSum + ADOWareDataSet.FieldByName('WareCount').AsInteger;
    end;
    ADOWareDataSet.RecNo := RecNo;
    ADOWareDataSet.EnableControls;
  end;
  Panel8.Caption := '�����ϼƣ�'+ IntToStr(CountSum);
  Panel9.Caption := '���ϼƣ���'+ FormatCurr(',#.00',MoneySum);

end;

procedure TFrmStockBill.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key = #13 then
  begin
    if ADOWareDataSet.Fields[0].IsNull then
      DBGrid1EditButtonClick(nil)
    else
      DataSetCalcSum;
  end;
end;

procedure TFrmStockBill.Save(Sender: TObject);
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

procedure TFrmStockBill.SaveDetail;
var
  i:Integer;
begin
  ADOPost.Active := False;
  ADOPost.CommandText := 'Select top 100 * From ҵ�񵥾���ϸ�� Where flg  = 1';
  ADOPost.Active := True;
  for i := 1 to ADOWareDataSet.RecordCount do
  begin
    ADOWareDataSet.RecNo := i;
    ADOPost.Append;
    ADOPost.FieldByName('�������').AsString := E_BillCode.Text;
    ADOPost.FieldByName('��Ʒ���').AsString :=
        ADOWareDataSet.FieldByName('WareID').AsString;
    ADOPost.FieldByName('����').AsString :=
        ADOWareDataSet.FieldByName('WarePrice').AsString;
    ADOPost.FieldByName('����').AsString :=
        ADOWareDataSet.FieldByName('WareCount').AsString;
    ADOPost.FieldByName('��ע').AsString :=
        ADOWareDataSet.FieldByName('WareMemo').AsString;
    ADOPost.Post;
  end;
end;

procedure TFrmStockBill.SaveMaster;
begin
  ADOPost.Active := False;
  ADOPost.CommandText := 'Select top 2 * From ҵ�񵥾����� Where Flg = 1';
  ADOPost.Active := True;
  ADOPost.Append;
  ADOPost.FieldByName('����').AsString := E_BillCode.Text;
  ADOPost.FieldByName('��λ').AsString := FComeUnitID;
  ADOPost.FieldByName('������').AsString := E_PersonOperation.Text;
  ADOPost.FieldByName('��ע').AsString := E_Memo.Text;
  ADOPost.FieldByName('�ֿ���').AsString := FStorageID;
  ADOPost.FieldByName('��������').AsDateTime := D_OperationDate.DateTime;
  ADOPost.FieldByName('ϵͳ����').AsDateTime := Now;
  ADOPost.FieldByName('��������').AsInteger := Integer(FBillType);
  ADOPost.Post;
end;

procedure TFrmStockBill.Btn_PostClick(Sender: TObject);
begin
  inherited;
  Save(Sender);
end;

class procedure TFrmStockBill.ShowStockOutStorage;
begin
  FrmStockBill := TFrmStockBill.Create(Application);
  FrmStockBill.BillType := StockOutStorage;
  FrmStockBill.ShowModal;
  FrmStockBill.Free;
end;

procedure TFrmStockBill.ADOWareDataSetBeforePost(DataSet: TDataSet);
begin
  inherited;
  if (FBillType = StockOutStorage) or (FBillType = SellInStorage) then
  begin
    if ADOWareDataSet.FieldByName('WareCount').AsInteger > 0 then
    begin
      ADOWareDataSet.FieldByName('WareCount').AsInteger :=
        - ADOWareDataSet.FieldByName('WareCount').AsInteger;
    end;
    
  end;
end;

class procedure TFrmStockBill.ShowSellOutStorage;
begin
  FrmStockBill := TFrmStockBill.Create(Application);
  FrmStockBill.BillType := SellOutStorage;
  FrmStockBill.ShowModal;
  FrmStockBill.Free;
end;

class procedure TFrmStockBill.ShowSellInStorage;
begin
  FrmStockBill := TFrmStockBill.Create(Application);
  FrmStockBill.BillType := SellInStorage;
  FrmStockBill.ShowModal;
  FrmStockBill.Free;
end;

procedure TFrmStockBill.Btn_CloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

class procedure TFrmStockBill.ShowBillDetail(vBillCode: string);
begin
  FrmStockBill := TFrmStockBill.Create(Application);
  FrmStockBill.SetBillCode(vBillCode);
  FrmStockBill.ShowModal;
  FrmStockBill.Free;
end;

procedure TFrmStockBill.SetBillCode(vBillCode: string;PostEnable:Boolean = False);
  procedure SetMasterBill;
  begin
    ADOPost.Active := False;
    ADOPost.CommandText := 'Select m.*,k.��λ����,c.�ֿ����� From ҵ�񵥾����� m '+
                  ' Left Join �ͻ����� k On m.��λ = k.���'+
                  ' Left Join �ֿ⵵���� c On m.�ֿ��� = c.���'+
                  ' Where m.flg = 1 and m.���� = ' + QuotedStr(vBillCode);
    ADOPost.Active := True;
    if ADOPost.IsEmpty then
      Exit;
      
    FBillType := ADOPost.FieldByName('��������').AsInteger;
    E_BillCode.Text := vBillCode;
    D_OperationDate.DateTime := ADOPost.FieldByName('��������').AsDateTime;

    E_Unit.Text := ADOPost.FieldByName('��λ����').AsString;
    FComeUnitID := ADOPost.FieldByName('��λ').AsString;

    E_Storage.Text := ADOPost.FieldByName('�ֿ�����').AsString;
    FStorageID := ADOPost.FieldByName('�ֿ���').AsString;

    E_PersonOperation.Text := ADOPost.FieldByName('������').AsString;
    E_Memo.Text := ADOPost.FieldByName('��ע').AsString;
    
  end;
  procedure SetDetailBill;
  var
    i:Integer;
  begin
    ADOPost.Active := False;
    ADOPost.CommandText := 'Select d.*,s.��Ʒ����,s.ƴ������,s.����ͺ�'+
              ' ,s.��λ From ҵ�񵥾���ϸ�� d '+
              ' Left Join ��Ʒ������ s On s.��Ʒ���� = d.��Ʒ���'+
              ' where d.flg = 1 and d.������� = '+ QuotedStr(vBillCode);
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
      ADOWareDataSet.FieldByName('WarePrice').AsString :=
          ADOPost.FieldByName('����').AsString;
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

procedure TFrmStockBill.Btn_DeleteRowClick(Sender: TObject);
begin
  inherited;
  if ADOWareDataSet.IsEmpty then
    Exit;
  if ShowMessageBox('�Ƿ�ɾ����ǰ�У�','ϵͳ��ʾ') = mrOk then
  begin
    ADOWareDataSet.Delete;
  end;
end;

procedure TFrmStockBill.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmStockBill.N3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 500 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(E_Unit.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(DateToStr(D_OperationDate.Date)));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(E_Storage.Text));

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

procedure TFrmStockBill.SpeedButton5Click(Sender: TObject);
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

procedure TFrmStockBill.ClearBill;
var
  SQL:string;
begin
  SQL := 'Delete From ҵ�񵥾����� Where ���� = '+ QuotedStr(E_BillCode.Text) +
         ' Delete From ҵ�񵥾���ϸ�� Where ������� = '+ QuotedStr(E_BillCode.Text);
  FrmDataModu.ADOQuery1.Close;
  FrmDataModu.ADOQuery1.SQL.Text := SQL;
  FrmDataModu.ADOQuery1.ExecSQL;
end;

procedure TFrmStockBill.NextBill;
var
  SQL:string;
begin
  SQL := 'Select top 1 ���� From ҵ�񵥾�����'+
          ' Where �������� = '+ IntToStr(BillType) +' and ��� > (Select ��� From ҵ�񵥾�����'+
          ' Where ���� = ' + QuotedStr(E_BillCode.Text) + ')';
  ADOTemp.Active := False;
  ADOTemp.CommandText := SQL;
  ADOTemp.Active := True;
  if not ADOTemp.IsEmpty then
    SetBillCode(ADOTemp.FieldByName('����').AsString,True);
end;

procedure TFrmStockBill.SpeedButton6Click(Sender: TObject);
begin
  inherited;
  NextBill;
end;

procedure TFrmStockBill.UpBill;
var
  SQL:string;
begin
  SQL := 'Select top 1 ���� From ҵ�񵥾�����'+
          ' Where �������� = '+ IntToStr(BillType) +' and ��� < (Select ��� From ҵ�񵥾�����'+
          ' Where ���� = ' + QuotedStr(E_BillCode.Text) + ')'+
          ' Order By ��� DESC';
  ADOTemp.Active := False;
  ADOTemp.CommandText := SQL;
  ADOTemp.Active := True;
  if not ADOTemp.IsEmpty then
    SetBillCode(ADOTemp.FieldByName('����').AsString,True);
end;

procedure TFrmStockBill.SpeedButton7Click(Sender: TObject);
begin
  inherited;
  UpBill;
end;

procedure TFrmStockBill.Btn_DeleteBillClick(Sender: TObject);
begin
  inherited;
  if ADOWareDataSet.IsEmpty then
    Exit;
  if ShowMessageBox('�Ƿ�Ҫɾ���˵��ݣ�','ϵͳ��ʾ') = mrOk then
  begin

    ClearBill;
    BillType := FBillType;

    E_Unit.Text := '';
    FComeUnitID := '-1';

    E_Storage.Text := '';
    FStorageID := '-1';

    E_Memo.Text := '';
    ADOWareDataSet.Close;
    ADOWareDataSet.CreateDataSet;
  end;
end;

procedure TFrmStockBill.N2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 500 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(E_Unit.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(DateToStr(D_OperationDate.Date)));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(E_Storage.Text));

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

procedure TFrmStockBill.N1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 500 + BillType;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomUnitName);
  ReportTool.SetVarible(CustomUnitName,QuotedStr(E_Unit.Text));

  ReportTool.AddVariable(CustomVarible,CustomDate);
  ReportTool.SetVarible(CustomDate,QuotedStr(DateToStr(D_OperationDate.Date)));

  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(E_Storage.Text));

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

procedure TFrmStockBill.SpeedButton3Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

procedure TFrmStockBill.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  winexec('calc.exe',sw_normal);
end;

end.
