unit SelectData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, Grids, DBGrids,
  ComCtrls, DB, ADODB,EditBase,PubConst;

type
  TFrmSelectData = class(TFrmBase)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Btn_Append: TSpeedButton;
    DBGrid1: TDBGrid;
    Btn_Edit: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Select: TSpeedButton;
    Btn_Close: TSpeedButton;
    ADOComeUnit: TADODataSet;
    DSSelect: TDataSource;
    Btn_All: TSpeedButton;
    Btn_ShowAll: TSpeedButton;
    ADOComeUnitDSDesigner: TAutoIncField;
    ADOComeUnitDSDesigner2: TStringField;
    ADOComeUnitDSDesigner3: TStringField;
    ADOComeUnitDSDesigner4: TStringField;
    ADOComeUnitDSDesigner5: TStringField;
    ADOComeUnitDSDesigner6: TIntegerField;
    ADOComeUnitDSDesigner7: TStringField;
    ADOComeUnitflg: TBooleanField;
    ADOStorage: TADODataSet;
    ADOWare: TADODataSet;
    ADOStorageDSDesigner: TAutoIncField;
    ADOStorageDSDesigner2: TStringField;
    ADOStorageDSDesigner3: TStringField;
    ADOStorageDSDesigner4: TStringField;
    ADOStorageflg: TBooleanField;
    ADOWareDSDesigner: TAutoIncField;
    ADOWareDSDesigner2: TStringField;
    ADOWareDSDesigner3: TStringField;
    ADOWareDSDesigner4: TStringField;
    ADOWareDSDesigner5: TBCDField;
    ADOWareDSDesigner6: TBCDField;
    ADOWareDSDesigner7: TFloatField;
    ADOWareDSDesigner8: TFloatField;
    ADOWareDSDesigner9: TStringField;
    ADOWareDSDesigner10: TStringField;
    ADOWareDSDesigner11: TStringField;
    ADOWareDSDesigner12: TStringField;
    ADOWareflg: TBooleanField;
    procedure Btn_CloseClick(Sender: TObject);
    procedure Btn_AllClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private

  public
    class function SelectComeUnit(vType:TUnitType):TModalResult;
    class function SelectALLComeUnit(vType:TUnitType):TModalResult;
    class function SelectStorage:TModalResult;
    class function SelectAllStorage:TModalResult;
    class function SelectWare(vBillType:TBillType):TModalResult;overload;
    class procedure SelectWare(vDataSet:TDataSet;vBillType:TBillType);overload;
    class procedure SelectWare(vDataSet:TDataSet;vBillType:TBillType;ProvideID:String;StorageID:string);overload;
  end;

var
  FrmSelectData: TFrmSelectData;
  
  FindID:string;
  FindName:string;
  
implementation

uses DataModu, AccountUnitEdit, LinkPersonEdit, MessageBox, StorageEdit,
  WareEdit;

{$R *.dfm}
var
  UnitType:TUnitType;
  
type
  //往来单位查找
  TFindComeUnit = class
    class procedure AppendRecord(Sender:TObject);
    class procedure EditRecord(Sender:TObject);
    class procedure DeleteRecord(Sender:TObject);
    class procedure SelectRecord(Sender:TObject);
    class procedure ShowAll(Sender:TObject);
    class procedure FindKey(Sender:TObject);
  end;

  //仓库查找
  TFindStorage = class
    class procedure AppendRecord(Sender:TObject);
    class procedure EditRecord(Sender:TObject);
    class procedure DeleteRecord(Sender:TObject);
    class procedure SelectRecord(Sender:TObject);
    class procedure ShowAll(Sender:TObject);
    class procedure FindKey(Sender:TObject);
  end;

  //商品查找
  TFindWare = class
    class procedure AppendRecord(Sender:TObject);
    class procedure EditRecord(Sender:TObject);
    class procedure DeleteRecord(Sender:TObject);
    class procedure SelectRecord(Sender:TObject);
    class procedure ShowAll(Sender:TObject);
    class procedure FindKey(Sender:TObject);
  end;

procedure TFrmSelectData.Btn_CloseClick(Sender: TObject);
begin
  inherited;
  Close;
end;

class function TFrmSelectData.SelectComeUnit(vType:TUnitType): TModalResult;
begin
  UnitType := vType;

  FindID := '-1';
  FindName := '';

  FrmSelectData := TFrmSelectData.Create(Application);
  if vType = PubConst.utProvide then
    FrmSelectData.Caption := '选择供应商'
  else if vType = PubConst.utClient then
    FrmSelectData.Caption := '选择客户';
  FrmSelectData.DSSelect.DataSet := FrmSelectData.ADOComeUnit;
  FrmSelectData.ADOComeUnit.Active := False;
  FrmSelectData.ADOComeUnit.CommandText := 'Select * From 客户档案 Where flg = 1 and 单位性质 = '+
      IntToStr(vType);
  FrmSelectData.ADOComeUnit.Active := True;
  FrmSelectData.Btn_Append.OnClick := TFindComeUnit.AppendRecord;
  FrmSelectData.Btn_Edit.OnClick := TFindComeUnit.EditRecord;
  FrmSelectData.Btn_Delete.OnClick := TFindComeUnit.DeleteRecord;
  FrmSelectData.Btn_Select.OnClick := TFindComeUnit.SelectRecord;
  FrmSelectData.Btn_ShowAll.OnClick := TFindComeUnit.ShowAll;
  FrmSelectData.SpeedButton1.OnClick := TFindComeUnit.FindKey;
  FrmSelectData.Btn_All.Visible := False;
  Result := FrmSelectData.ShowModal;
  FrmSelectData.Free;
end;

{ TFindComeUnit }

class procedure TFindComeUnit.AppendRecord(Sender: TObject);
begin
  case UnitType of
    utProvide,utClient:
    begin
      FrmAccountUnitEdit := TFrmAccountUnitEdit.Create(Application);
      FrmAccountUnitEdit.ADOEdit.Active := False;
      FrmAccountUnitEdit.ADOEdit.CommandText := 'Select top 10 * From 客户档案 Where flg = 1';
      FrmAccountUnitEdit.ADOEdit.Active := True;
      FrmAccountUnitEdit.ADOEdit.Append;
      if FrmAccountUnitEdit.ShowModal = mrOk then
      begin
        FrmAccountUnitEdit.ADOEdit.FieldByName('单位性质').AsInteger := UnitType;
        FrmAccountUnitEdit.ADOEdit.UpdateBatch();
        FrmSelectData.ADOComeUnit.Active := False;
        FrmSelectData.ADOComeUnit.Active := True;
      end
      else
      begin
        FrmAccountUnitEdit.ADOEdit.CancelBatch();
      end;
      FrmAccountUnitEdit.Free;
    end;
  end;
end;

class procedure TFindComeUnit.DeleteRecord(Sender: TObject);
begin
  if ShowMessageBox('是否删除此记录！','系统提示') <> mrOk then
    Exit;

  case UnitType of
    utClient,utProvide:
    begin
      FrmSelectData.ADOComeUnit.Edit;
      FrmSelectData.ADOComeUnit.FieldByName('flg').AsBoolean := False;
      FrmSelectData.ADOComeUnit.Post;
      FrmSelectData.ADOComeUnit.Active := False;
      FrmSelectData.ADOComeUnit.Active := True;
    end;
  end;
end;

class procedure TFindComeUnit.EditRecord(Sender: TObject);
begin
  case UnitType of
    utProvide,utClient:
    begin
      if FrmSelectData.ADOComeUnit.IsEmpty then
        Exit;
      FrmAccountUnitEdit := TFrmAccountUnitEdit.Create(Application);
      FrmAccountUnitEdit.ADOEdit.Active := False;
      FrmAccountUnitEdit.ADOEdit.CommandText := 'Select * From 客户档案 Where flg = 1 and 编号 = '+
            FrmSelectData.ADOComeUnit.FieldByName('编号').AsString;
      FrmAccountUnitEdit.ADOEdit.Active := True;
      FrmAccountUnitEdit.ADOEdit.Edit;
      if FrmAccountUnitEdit.ShowModal = mrOk then
      begin
        FrmAccountUnitEdit.ADOEdit.UpdateBatch();
        FrmSelectData.ADOComeUnit.Active := False;
        FrmSelectData.ADOComeUnit.Active := True;
      end
      else
      begin
        FrmAccountUnitEdit.ADOEdit.CancelBatch();
      end;
      FrmAccountUnitEdit.Free;
    end;
  end;
end;

procedure TFrmSelectData.Btn_AllClick(Sender: TObject);
begin
  inherited;
  FindID := '-1';
  FindName := '(全部)';
  ModalResult := mrOk;
end;

class procedure TFindComeUnit.FindKey(Sender: TObject);
var
  Key:string;
begin
  if FrmSelectData.Edit1.Text = '' then
    Exit;
  Key := QuotedStr('%'+FrmSelectData.Edit1.Text+'%');
  FrmSelectData.ADOComeUnit.Active := False;
  FrmSelectData.ADOComeUnit.CommandText :=
      'Select * From 客户档案 Where flg = 1 and 单位性质 = '+
      IntToStr(UnitType) + ' and ( 单位名称 like '+ Key+
      ' or 单位地址 like '+ Key +
      ' or 拼音简码 like ' + Key +
      ' or 邮编 like ' + Key +
      ' or 备注 like ' + Key + ')';
  FrmSelectData.ADOComeUnit.Active := True;
end;

class procedure TFindComeUnit.SelectRecord(Sender: TObject);
begin
  if FrmSelectData.ADOComeUnit.IsEmpty then
    Exit;
  FindID := FrmSelectData.ADOComeUnit.FieldByName('编号').AsString;
  FindName := FrmSelectData.ADOComeUnit.FieldByName('单位名称').AsString;
  FrmSelectData.ModalResult := mrOk;
end;

class procedure TFindComeUnit.ShowAll(Sender: TObject);
begin
  FrmSelectData.ADOComeUnit.Active := False;
  FrmSelectData.ADOComeUnit.CommandText := 'Select * From 客户档案 Where flg = 1 and 单位性质 = '+
      IntToStr(UnitType);
  FrmSelectData.ADOComeUnit.Active := True;
end;

{ TFindStorage }

class procedure TFindStorage.AppendRecord(Sender: TObject);
begin
  FrmStorageEdit := TFrmStorageEdit.Create(Application);
  FrmStorageEdit.ADOEdit.Active := False;
  FrmStorageEdit.ADOEdit.CommandText := 'Select * From 仓库档案表 Where flg = 1';
  FrmStorageEdit.ADOEdit.Active := True;
  FrmStorageEdit.ADOEdit.Append;
  if FrmStorageEdit.ShowModal = mrOk then
  begin
    FrmStorageEdit.ADOEdit.UpdateBatch();
    FrmSelectData.ADOStorage.Active := False;
    FrmSelectData.ADOStorage.Active := True;
  end
  else
  begin
    FrmStorageEdit.ADOEdit.CancelBatch();
  end;
  FrmStorageEdit.Free;
end;

class procedure TFindStorage.DeleteRecord(Sender: TObject);
begin
  if FrmSelectData.ADOStorage.IsEmpty then
    Exit;
  if ShowMessageBox('是否要删除此记录！','系统提示') <> mrOk then
    Exit;
  FrmSelectData.ADOStorage.Edit;
  FrmSelectData.ADOStorage.FieldByName('flg').AsBoolean := False;
  FrmSelectData.ADOStorage.Post;
  FrmSelectData.ADOStorage.Active := False;
  FrmSelectData.ADOStorage.Active := True;
end;

class procedure TFindStorage.EditRecord(Sender: TObject);
begin
  if FrmSelectData.ADOStorage.IsEmpty then
    Exit;
  FrmStorageEdit := TFrmStorageEdit.Create(Application);
  FrmStorageEdit.ADOEdit.Active := False;
  FrmStorageEdit.ADOEdit.CommandText := 'Select  * From 仓库档案表 Where flg = 1 and 编号 = '+
    FrmSelectData.ADOStorage.FieldByName('编号').AsString;
  FrmStorageEdit.ADOEdit.Active := True;
  FrmStorageEdit.ADOEdit.Edit;
  if FrmStorageEdit.ShowModal = mrOk then
  begin
    FrmStorageEdit.ADOEdit.UpdateBatch();
    FrmSelectData.ADOStorage.Active := False;
    FrmSelectData.ADOStorage.Active := True;
  end
  else
  begin
    FrmStorageEdit.ADOEdit.CancelBatch();
  end;
  FrmStorageEdit.Free;
end;

class procedure TFindStorage.FindKey(Sender: TObject);
var
  Key:string;
begin
  if FrmSelectData.Edit1.Text = '' then
    Exit;
  Key := QuotedStr('%'+FrmSelectData.Edit1.Text+'%');
  FrmSelectData.ADOStorage.Active := False;
  FrmSelectData.ADOStorage.CommandText :=
      'Select * From 仓库档案表 Where flg = 1 and ( 仓库名称 like '+ Key+
      ' or 负责人 like '+ Key +
      ' or 备注 like ' + Key + ')';
  FrmSelectData.ADOStorage.Active := True;
end;

class procedure TFindStorage.SelectRecord(Sender: TObject);
begin
  if FrmSelectData.ADOStorage.IsEmpty then
    Exit;
  FindID := FrmSelectData.ADOStorage.FieldByName('编号').AsString;
  FindName := FrmSelectData.ADOStorage.FieldByName('仓库名称').AsString;
  FrmSelectData.ModalResult := mrOk;
end;

class procedure TFindStorage.ShowAll(Sender: TObject);
begin
  FrmSelectData.ADOStorage.Active := False;
  FrmSelectData.ADOStorage.CommandText := 'Select * From 仓库档案表 Where flg = 1';
  FrmSelectData.ADOStorage.Active := True;
end;

class function TFrmSelectData.SelectStorage: TModalResult;
begin
  FindID := '-1';
  FindName := '';

  FrmSelectData := TFrmSelectData.Create(Application);
  FrmSelectData.Caption := '选择仓库';
  FrmSelectData.DSSelect.DataSet := FrmSelectData.ADOStorage;
  FrmSelectData.ADOStorage.Active := False;
  FrmSelectData.ADOStorage.CommandText := 'Select * From 仓库档案表 Where flg = 1';
  FrmSelectData.ADOStorage.Active := True;
  FrmSelectData.Btn_Append.OnClick := TFindStorage.AppendRecord;
  FrmSelectData.Btn_Edit.OnClick := TFindStorage.EditRecord;
  FrmSelectData.Btn_Delete.OnClick := TFindStorage.DeleteRecord;
  FrmSelectData.Btn_Select.OnClick := TFindStorage.SelectRecord;
  FrmSelectData.Btn_ShowAll.OnClick := TFindStorage.ShowAll;
  FrmSelectData.SpeedButton1.OnClick := TFindStorage.FindKey;
  FrmSelectData.Btn_All.Visible := False;
  Result := FrmSelectData.ShowModal;
  FrmSelectData.Free;
end;

{ TFindWare }

class procedure TFindWare.AppendRecord(Sender: TObject);
begin
  FrmWareEdit := TFrmWareEdit.Create(Application);
  FrmWareEdit.ADOEdit.Active := False;
  FrmWareEdit.ADOEdit.CommandText := 'Select top 10 * From 商品档案表 Where flg = 1';
  FrmWareEdit.ADOEdit.Active := True;
  FrmWareEdit.ADOEdit.Append;
  if FrmWareEdit.ShowModal = mrOk then
  begin
    FrmWareEdit.ADOEdit.UpdateBatch();
    FrmSelectData.ADOWare.Active := False;
    FrmSelectData.ADOWare.Active := True;
  end
  else
  begin
    FrmWareEdit.ADOEdit.CancelBatch();
  end;
  FrmWareEdit.Free;
end;

class procedure TFindWare.DeleteRecord(Sender: TObject);
begin
  if FrmSelectData.ADOWare.IsEmpty then
    Exit;
  if ShowMessageBox('是否删除此记录！','系统提示') <> mrOk then
    Exit;
  FrmSelectData.ADOWare.Edit;
  FrmSelectData.ADOWare.FieldByName('flg').AsBoolean := False;
  FrmSelectData.ADOWare.Post;
  FrmSelectData.ADOWare.Active := False;
  FrmSelectData.ADOWare.Active := True;
end;

class procedure TFindWare.EditRecord(Sender: TObject);
begin
  if FrmSelectData.ADOWare.IsEmpty then
    Exit;
  FrmWareEdit := TFrmWareEdit.Create(Application);
  FrmWareEdit.ADOEdit.Active := False;
  FrmWareEdit.ADOEdit.CommandText := 'Select * From 商品档案表 Where flg = 1 and 商品编码 = '+
    FrmSelectData.ADOWare.FieldByName('商品编码').AsString;
  FrmWareEdit.ADOEdit.Active := True;
  FrmWareEdit.ADOEdit.Edit;
  if FrmWareEdit.ShowModal = mrOk then
  begin
    FrmWareEdit.ADOEdit.UpdateBatch();
    FrmSelectData.ADOWare.Active := False;
    FrmSelectData.ADOWare.Active := True;
  end
  else
  begin
    FrmWareEdit.ADOEdit.CancelBatch();
  end;
  FrmWareEdit.Free;
end;

class procedure TFindWare.FindKey(Sender: TObject);
begin

end;

class procedure TFindWare.SelectRecord(Sender: TObject);
begin
  if FrmSelectData.ADOWare.IsEmpty then
    Exit;
  FindID := FrmSelectData.ADOWare.FieldByName('商品编码').AsString;
  FindName := FrmSelectData.ADOWare.FieldByName('商品名称').AsString;
  FrmSelectData.ModalResult := mrOk;
end;

class procedure TFindWare.ShowAll(Sender: TObject);
begin
  FrmSelectData.ADOWare.Active := False;
  FrmSelectData.ADOWare.CommandText := 'Select * From 商品档案表 Where flg = 1';
  FrmSelectData.ADOWare.Active := True;
end;

class procedure TFrmSelectData.SelectWare(vDataSet: TDataSet;vBillType:TBillType);
begin
  FrmSelectData := TFrmSelectData.Create(Application);
  FrmSelectData.Caption := '选择商品';
  FrmSelectData.DSSelect.DataSet := FrmSelectData.ADOWare;
  FrmSelectData.ADOWare.Active := False;
  FrmSelectData.ADOWare.CommandText := 'Select * From 商品档案表 Where flg = 1';
  FrmSelectData.ADOWare.Active := True;
  FrmSelectData.Btn_Append.OnClick := TFindWare.AppendRecord;
  FrmSelectData.Btn_Edit.OnClick := TFindWare.EditRecord;
  FrmSelectData.Btn_Delete.OnClick := TFindWare.DeleteRecord;
  FrmSelectData.Btn_Select.OnClick := TFindWare.SelectRecord;
  FrmSelectData.Btn_ShowAll.OnClick := TFindWare.ShowAll;
  FrmSelectData.SpeedButton1.OnClick := TFindWare.FindKey;
  FrmSelectData.Btn_All.Visible := False;
  if FrmSelectData.ShowModal = mrOk then
  begin
    vDataSet.Edit;
    vDataSet.FieldByName('WareID').AsString :=
          FrmSelectData.ADOWare.FieldByName('商品编码').AsString;
    vDataSet.FieldByName('WareName').AsString :=
          FrmSelectData.ADOWare.FieldByName('商品名称').AsString;
    vDataSet.FieldByName('WareSpell').AsString :=
          FrmSelectData.ADOWare.FieldByName('拼音编码').AsString;
    vDataSet.FieldByName('WareSpec').AsString :=
          FrmSelectData.ADOWare.FieldByName('规格型号').AsString;
    vDataSet.FieldByName('WareUnit').AsString :=
          FrmSelectData.ADOWare.FieldByName('单位').AsString;
    if vBillType <> StorageMove then
    begin
      if vBillType in [StockInStorage,StockOutStorage] then
      begin
        vDataSet.FieldByName('WarePrice').AsString :=
              FrmSelectData.ADOWare.FieldByName('预设进价').AsString;
      end
      else
      begin
        vDataSet.FieldByName('WarePrice').AsString :=
              FrmSelectData.ADOWare.FieldByName('预设售价').AsString;
      end;
    end;
    if (vBillType = StockOutStorage) or (vBillType = SellInStorage) then
      vDataSet.FieldByName('WareCount').AsInteger := -1
    else
      vDataSet.FieldByName('WareCount').AsInteger := 1;
    vDataSet.Post;
  end;
  FrmSelectData.Free;
end;

procedure TFrmSelectData.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  Btn_Select.Click;
end;

class function TFrmSelectData.SelectAllStorage: TModalResult;
begin
  FindID := '-1';
  FindName := '';

  FrmSelectData := TFrmSelectData.Create(Application);
  FrmSelectData.Caption := '选择仓库';
  FrmSelectData.DSSelect.DataSet := FrmSelectData.ADOStorage;
  FrmSelectData.ADOStorage.Active := False;
  FrmSelectData.ADOStorage.CommandText := 'Select * From 仓库档案表 Where flg = 1';
  FrmSelectData.ADOStorage.Active := True;
  FrmSelectData.Btn_Append.OnClick := TFindStorage.AppendRecord;
  FrmSelectData.Btn_Edit.OnClick := TFindStorage.EditRecord;
  FrmSelectData.Btn_Delete.OnClick := TFindStorage.DeleteRecord;
  FrmSelectData.Btn_Select.OnClick := TFindStorage.SelectRecord;
  FrmSelectData.Btn_ShowAll.OnClick := TFindStorage.ShowAll;
  FrmSelectData.SpeedButton1.OnClick := TFindStorage.FindKey;
  Result := FrmSelectData.ShowModal;
  FrmSelectData.Free;
end;

class function TFrmSelectData.SelectALLComeUnit(
  vType: TUnitType): TModalResult;
begin
  UnitType := vType;

  FindID := '-1';
  FindName := '';

  FrmSelectData := TFrmSelectData.Create(Application);
  if vType = PubConst.utProvide then
    FrmSelectData.Caption := '选择供应商'
  else if vType = PubConst.utClient then
    FrmSelectData.Caption := '选择客户';
  FrmSelectData.DSSelect.DataSet := FrmSelectData.ADOComeUnit;
  FrmSelectData.ADOComeUnit.Active := False;
  FrmSelectData.ADOComeUnit.CommandText := 'Select * From 客户档案 Where flg = 1 and 单位性质 = '+
      IntToStr(vType);
  FrmSelectData.ADOComeUnit.Active := True;
  FrmSelectData.Btn_Append.OnClick := TFindComeUnit.AppendRecord;
  FrmSelectData.Btn_Edit.OnClick := TFindComeUnit.EditRecord;
  FrmSelectData.Btn_Delete.OnClick := TFindComeUnit.DeleteRecord;
  FrmSelectData.Btn_Select.OnClick := TFindComeUnit.SelectRecord;
  FrmSelectData.Btn_ShowAll.OnClick := TFindComeUnit.ShowAll;
  FrmSelectData.SpeedButton1.OnClick := TFindComeUnit.FindKey;
  Result := FrmSelectData.ShowModal;
  FrmSelectData.Free;
end;

class procedure TFrmSelectData.SelectWare(vDataSet: TDataSet;
  vBillType: TBillType; ProvideID, StorageID: string);
begin
  if (ProvideID = '') or (StorageID = '') then
  begin
      ShowMessageBox('请选择单位和仓库！','系统提示');
      Exit;
  end;
  FrmSelectData := TFrmSelectData.Create(Application);
  FrmSelectData.Caption := '选择商品';
  FrmSelectData.DSSelect.DataSet := FrmSelectData.ADOWare;
  FrmSelectData.ADOWare.Active := False;
  case vBillType of
    StockInStorage  :
    begin
      FrmSelectData.ADOWare.CommandText := 'Select * From 商品档案表 Where flg = 1';
    end;
    StockOutStorage :
    begin
      FrmSelectData.ADOWare.CommandText := 'Select * From 商品档案表 Where flg = 1 and 商品编码 in '+
          '(Select d.商品编号 From 业务单据主表 m,业务单据明细表 d Where m.单号 = d.定单编号'+
          ' and m.仓库编号 = '+ StorageID + ' and m.单位 = ' + ProvideID +
          ' and m.定单类型 = '+ IntToStr(StockInStorage) + ')';
          
    end;
    SellOutStorage  :
    begin
      FrmSelectData.ADOWare.CommandText := 'Select * From 商品档案表 Where flg = 1 and 商品编码 in '+
          '(Select d.商品编号 From 业务单据主表 m,业务单据明细表 d Where m.单号 = d.定单编号'+
//          ' and m.仓库编号 = '+ StorageID + ' and m.单位 = ' + ProvideID +
          ' and m.定单类型 = '+ IntToStr(StockInStorage) + ')';
    end;
    SellInStorage   :
    begin
      FrmSelectData.ADOWare.CommandText := 'Select * From 商品档案表 Where flg = 1 and 商品编码 in '+
          '(Select d.商品编号 From 业务单据主表 m,业务单据明细表 d Where m.单号 = d.定单编号'+
          ' and m.仓库编号 = '+ StorageID + ' and m.单位 = ' + ProvideID +
          ' and m.定单类型 = '+ IntToStr(SellOutStorage) + ')';
    end;
  end;
  FrmSelectData.ADOWare.Active := True;
  FrmSelectData.Btn_Append.OnClick := TFindWare.AppendRecord;
  FrmSelectData.Btn_Edit.OnClick := TFindWare.EditRecord;
  FrmSelectData.Btn_Delete.OnClick := TFindWare.DeleteRecord;
  FrmSelectData.Btn_Select.OnClick := TFindWare.SelectRecord;
  FrmSelectData.Btn_ShowAll.OnClick := TFindWare.ShowAll;
  FrmSelectData.SpeedButton1.OnClick := TFindWare.FindKey;
  FrmSelectData.Btn_All.Visible := False;
  if FrmSelectData.ShowModal = mrOk then
  begin
    vDataSet.Edit;
    vDataSet.FieldByName('WareID').AsString :=
          FrmSelectData.ADOWare.FieldByName('商品编码').AsString;
    vDataSet.FieldByName('WareName').AsString :=
          FrmSelectData.ADOWare.FieldByName('商品名称').AsString;
    vDataSet.FieldByName('WareSpell').AsString :=
          FrmSelectData.ADOWare.FieldByName('拼音编码').AsString;
    vDataSet.FieldByName('WareSpec').AsString :=
          FrmSelectData.ADOWare.FieldByName('规格型号').AsString;
    vDataSet.FieldByName('WareUnit').AsString :=
          FrmSelectData.ADOWare.FieldByName('单位').AsString;
    if vBillType <> StorageMove then
    begin
      if vBillType in [StockInStorage,StockOutStorage] then
      begin
        vDataSet.FieldByName('WarePrice').AsString :=
              FrmSelectData.ADOWare.FieldByName('预设进价').AsString;
      end
      else
      begin
        vDataSet.FieldByName('WarePrice').AsString :=
              FrmSelectData.ADOWare.FieldByName('预设售价').AsString;
      end;
    end;
    if (vBillType = StockOutStorage) or (vBillType = SellInStorage) then
      vDataSet.FieldByName('WareCount').AsInteger := -1
    else
      vDataSet.FieldByName('WareCount').AsInteger := 1;
    vDataSet.Post;
  end;
  FrmSelectData.Free;
end;

class function TFrmSelectData.SelectWare(vBillType: TBillType):TModalResult;
begin
  FrmSelectData := TFrmSelectData.Create(Application);
  FrmSelectData.Caption := '选择商品';
  FrmSelectData.DSSelect.DataSet := FrmSelectData.ADOWare;
  FrmSelectData.ADOWare.Active := False;
  FrmSelectData.ADOWare.CommandText := 'Select * From 商品档案表 Where flg = 1';
  FrmSelectData.ADOWare.Active := True;
  FrmSelectData.Btn_Append.OnClick := TFindWare.AppendRecord;
  FrmSelectData.Btn_Edit.OnClick := TFindWare.EditRecord;
  FrmSelectData.Btn_Delete.OnClick := TFindWare.DeleteRecord;
  FrmSelectData.Btn_Select.OnClick := TFindWare.SelectRecord;
  FrmSelectData.Btn_ShowAll.OnClick := TFindWare.ShowAll;
  FrmSelectData.SpeedButton1.OnClick := TFindWare.FindKey;
  Result := FrmSelectData.ShowModal;
  FrmSelectData.Free;
end;

procedure TFrmSelectData.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

end.
