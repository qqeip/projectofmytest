unit StorageCount;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, ComCtrls, Grids, DBGrids,
  DB, ADODB, Buttons,PubConst, Menus;

type
  TFrmStorageCount = class(TFrmBase)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    ADOStorage: TADODataSet;
    DSStorage: TDataSource;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Label2: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    ADOStorageDSDesigner: TIntegerField;
    ADOStorageDSDesigner2: TStringField;
    ADOStorageDSDesigner3: TStringField;
    ADOStorageDSDesigner4: TStringField;
    ADOStorageDSDesigner5: TStringField;
    ADOStorageDSDesigner6: TBCDField;
    ADOStorageDSDesigner7: TFloatField;
    ADOStorageDSDesigner8: TFloatField;
    ADOStorageDSDesigner10: TBCDField;
    ADOStorageDSDesigner9: TIntegerField;
    SpeedButton5: TSpeedButton;
    Panel4: TPanel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure DBGrid1DrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    FStorageID:string;

    procedure ActiveADOStorgae(vType:Integer);
    procedure ShowWareDetail;
  public
    class procedure ShowStorageCount;
  end;

var
  FrmStorageCount: TFrmStorageCount;

implementation

uses DataModu, SelectData, WareEdit, WareBranch, ReportToolManage;

var
  PriceType:Integer;
  CallPolice:Integer;

const
  atAll             =       1;       //全部 - 所有仓库，预设进价
  atAverageStock    =       2;       //平均进价
  atAverageSell     =       3;       //平均售价
  atSellPrice       =       4;       //预设售价
  atLastInPrice     =       5;       //最后一次进价
  atLastSellPrice   =       6;       //最后一次售价

  cpUp      =     1;    //上限报警
  cpDown    =     2;    //下限报警
  cpNone    =     3;    //不报警  


{$R *.dfm}

{ TFrmStorageCount }

procedure TFrmStorageCount.ActiveADOStorgae(vType: Integer);
var
  SQL:string;
  SQLSum:string;
  StorageWhere:string;
begin
  PriceType := vType;
  if FStorageID = '-1' then
    StorageWhere := ''
  else
    StorageWhere := 'and m.仓库编号 = ' + FStorageID;

  case vType of
    atAll :
    begin
      SQL := ' Select *,预设进价*当前库存 库存总价 From '+
          ' (Select a.商品编码,a.商品名称,a.拼音编码,a.规格型号,a.单位'+
          ' ,a.预设进价,a.库存上限,a.库存下限,'+
          ' case when 0=0 then'+
          ' isnull((Select (        '+

          '           (isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
          '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockInStorage) +'),0)  '+
          ' +     '+
          '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d '+
          '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockOutStorage) +'),0))'+
          ' -     '+
          '           ( isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
          '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellOutStorage) +'),0)   '+
          ' +     '+
          '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
          '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellInStorage) +'),0)) '+
          ' )),0)    '+
          ' end  当前库存'+
          ' From 商品档案表 a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''合计'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(当前库存),Sum(库存总价) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by 商品编码 desc';
      
      ADOStorage.FieldByName('预设进价').DisplayLabel := '预设进价';
    end;
    atAverageStock:
    begin
      SQL := 'Select *,预设进价*当前库存 库存总价 From (Select a.商品编码,a.商品名称,a.拼音编码,a.规格型号,'+
              '	a.单位,' +
              'case when 0=0 then '  +
              '	isnull((Select sum(mm.单价) / Count(mm.单价) From ' +
              '	(Select m.仓库编号,d.* From 业务单据主表 m,业务单据明细表 d ' +
              ' Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockInStorage) +' ) mm),0)'+
              ' end 预设进价 ' +
              ' ,a.库存上限,a.库存下限,' +
              ' case when 0=0 then ' +
              ' isnull((Select (        '+

              '           (isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockInStorage) +'),0)  '+
              ' +     '+
              '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockOutStorage) +'),0))'+
              ' -     '+
              '           ( isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellOutStorage) +'),0)   '+
              ' +     '+
              '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellInStorage) +'),0)) '+
              ' )),0)    '+
              ' end  当前库存'+
              ' From 商品档案表 a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''合计'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(当前库存),Sum(库存总价) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by 商品编码 desc';

      ADOStorage.FieldByName('预设进价').DisplayLabel := '平均进价'; 
    end;
    atAverageSell:
    begin
      SQL := 'Select *,预设进价*当前库存 库存总价 From (Select a.商品编码,a.商品名称,a.拼音编码,a.规格型号,'+
              '	a.单位,' +
              'case when 0=0 then '  +
              '	isnull((Select sum(mm.单价) / Count(mm.单价) From ' +
              '	(Select m.仓库编号,d.* From 业务单据主表 m,业务单据明细表 d ' +
              ' Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellOutStorage) +' ) mm),0)'+
              ' end 预设进价 ' +
              ' ,a.库存上限,a.库存下限,' +
              ' case when 0=0 then ' +
              ' isnull((Select (        '+

              '           (isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockInStorage) +'),0)  '+
              ' +     '+
              '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockOutStorage) +'),0))'+
              ' -     '+
              '           ( isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellOutStorage) +'),0)   '+
              ' +     '+
              '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellInStorage) +'),0)) '+
              ' )),0)    '+
              ' end  当前库存'+
              ' From 商品档案表 a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''合计'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(当前库存),Sum(库存总价) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by 商品编码 desc';

      ADOStorage.FieldByName('预设进价').DisplayLabel := '平均售价';
    end;
    atSellPrice:
    begin
      SQL := ' Select *,预设进价*当前库存 库存总价 From '+
          ' (Select a.商品编码,a.商品名称,a.拼音编码,a.规格型号,a.单位'+
          ' ,a.预设售价 预设进价,a.库存上限,a.库存下限,'+
          ' case when 0=0 then'+
          ' isnull((Select (        '+

          '           (isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
          '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockInStorage) +'),0)  '+
          ' +     '+
          '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d '+
          '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockOutStorage) +'),0))'+
          ' -     '+
          '           ( isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
          '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellOutStorage) +'),0)   '+
          ' +     '+
          '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
          '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellInStorage) +'),0)) '+
          ' )),0)    '+
          ' end  当前库存'+
          ' From 商品档案表 a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''合计'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(当前库存),Sum(库存总价) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by 商品编码 desc';

      ADOStorage.FieldByName('预设进价').DisplayLabel := '预设售价';
    end;
    atLastInPrice:
    begin
      SQL := 'Select *,预设进价*当前库存 库存总价 '+
              ' From (Select a.商品编码,a.商品名称,a.拼音编码,a.规格型号,' +
              '	a.单位, ' +
              ' case when 0=0 then  ' +
              '	isnull((Select  mm.单价 From '  +
              '	(Select top 1 m.仓库编号,d.* From 业务单据主表 m,业务单据明细表 d' +
              ' Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockInStorage) +' ' +
              ' order by d.编号 desc ) mm),0) ' +
              ' end 预设进价 '  +
              ' ,a.库存上限,a.库存下限, ' +
              ' case when 0=0 then ' +
              ' isnull((Select (        '+

              '           (isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockInStorage) +'),0)  '+
              ' +     '+
              '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockOutStorage) +'),0))'+
              ' -     '+
              '           ( isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellOutStorage) +'),0)   '+
              ' +     '+
              '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellInStorage) +'),0)) '+
              ' )),0)    '+
              ' end  当前库存'+

              ' From 商品档案表 a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''合计'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(当前库存),Sum(库存总价) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by 商品编码 desc';

      ADOStorage.FieldByName('预设进价').DisplayLabel := '最后一次进价';
    end;
    atLastSellPrice:
    begin
      SQL := 'Select *,预设进价*当前库存 库存总价 '+
              ' From (Select a.商品编码,a.商品名称,a.拼音编码,a.规格型号,' +
              '	a.单位, ' +
              ' case when 0=0 then  ' +
              '	isnull((Select  mm.单价 From '  +
              '	(Select top 1 m.仓库编号,d.* From 业务单据主表 m,业务单据明细表 d' +
              ' Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellOutStorage) +' ' +
              ' order by d.编号 desc ) mm),0) ' +
              ' end 预设进价 '  +
              ' ,a.库存上限,a.库存下限, ' +
              ' case when 0=0 then ' +
              ' isnull((Select (        '+

              '           (isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockInStorage) +'),0)  '+
              ' +     '+
              '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(StockOutStorage) +'),0))'+
              ' -     '+
              '           ( isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellOutStorage) +'),0)   '+
              ' +     '+
              '           isnull((Select sum(d.数量) From 业务单据主表 m,业务单据明细表 d  '+
              '            Where m.单号 = d.定单编号 and d.商品编号 = a.商品编码 '+ StorageWhere +' and m.定单类型 = '+ IntToStr(SellInStorage) +'),0)) '+
              ' )),0)    '+
              ' end  当前库存'+

              ' From 商品档案表 a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''合计'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(当前库存),Sum(库存总价) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by 商品编码 desc';

      
      ADOStorage.FieldByName('预设进价').DisplayLabel := '最后一次售价';
    end;
  end;
  ADOStorage.Active := False;
  ADOStorage.CommandText := SQL;
  ADOStorage.Active := True;

end;

procedure TFrmStorageCount.FormShow(Sender: TObject);
begin
  inherited;
  FStorageID := '-1';
  Edit1.Text := '(全部)';
  ActiveADOStorgae(atAverageStock);
end;

class procedure TFrmStorageCount.ShowStorageCount;
begin
  FrmStorageCount := TFrmStorageCount.Create(Application);
  CallPolice := cpNone;
  FrmStorageCount.ShowModal;
  FrmStorageCount.Free;
end;

procedure TFrmStorageCount.ShowWareDetail;
begin
  if (ADOStorage.IsEmpty) or (ADOStorage.FieldByName('商品编码').IsNull) then
    Exit;
  
  FrmWareEdit := TFrmWareEdit.Create(Self);
  FrmWareEdit.ADOEdit.Active := False;
  FrmWareEdit.ADOEdit.CommandText := 'Select * From 商品档案表 Where flg = 1 and 商品编码 = '+
    ADOStorage.FieldByName('商品编码').AsString;
  FrmWareEdit.ADOEdit.Active := True;
  FrmWareEdit.Btn_Post.Visible := False;
  FrmWareEdit.Panel2.Enabled := False;
  FrmWareEdit.ShowModal;
  FrmWareEdit.Free;
end;

procedure TFrmStorageCount.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  if TFrmSelectData.SelectAllStorage = mrOk then
  begin
    Edit1.Text := FindName;
    FStorageID := FindID;
    ActiveADOStorgae(atAll);
  end;
end;

procedure TFrmStorageCount.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  ShowWareDetail;
end;

procedure TFrmStorageCount.ComboBox1Change(Sender: TObject);
begin
  inherited;
  case ComboBox1.ItemIndex of
    0:ActiveADOStorgae(atAverageStock);
    1:ActiveADOStorgae(atAverageSell);
    2:ActiveADOStorgae(atAll);
    3:ActiveADOStorgae(atSellPrice);
    4:ActiveADOStorgae(atLastInPrice);
    5:ActiveADOStorgae(atLastSellPrice);
  end;
end;

procedure TFrmStorageCount.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  if ADOStorage.IsEmpty then
    Exit;
  if ADOStorage.FieldByName('商品编码').AsString = '' then
    Exit;
  TFrmWareBranch.ShowWareBranch(ADOStorage.FieldByName('商品编码').AsString,
      ADOStorage.FieldByName('商品名称').AsString,
      ADOStorage.FieldByName('规格型号').AsString,
      ADOStorage.FieldByName('单位').AsString,
      PriceType);
end;

procedure TFrmStorageCount.DBGrid1DrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  inherited;
  with DBGrid1.Canvas.Font do
  case CallPolice of
    cpNone :
    begin
      if Field.DataSet.FieldByName('当前库存').AsInteger <= 0 then
        Color := clRed
      else
        Color := clWindowText;
    end;
    cpUp:
    begin
      if (Field.DataSet.FieldByName('当前库存').AsInteger >
           Field.DataSet.FieldByName('库存上限').AsInteger)
           and not Field.DataSet.FieldByName('库存上限').IsNull then
        Color := clRed
      else
        Color := clWindowText;
    end;
    cpDown:
    begin
      if (Field.DataSet.FieldByName('当前库存').AsInteger <
           Field.DataSet.FieldByName('库存下限').AsInteger)
           and not Field.DataSet.FieldByName('库存下限').IsNull then
        Color := clRed
      else
        Color := clWindowText;
    end;
  end;
  DBGrid1.DefaultDrawDataCell(Rect,Field,State);
end;

procedure TFrmStorageCount.N1Click(Sender: TObject);
begin
  inherited;
  CallPolice := cpUp;
  DBGrid1.Refresh;
end;

procedure TFrmStorageCount.N2Click(Sender: TObject);
begin
  inherited;
  CallPolice := cpDown;
  DBGrid1.Refresh;
end;

procedure TFrmStorageCount.N3Click(Sender: TObject);
begin
  inherited;
  CallPolice := cpNone;
  DBGrid1.Refresh;
end;

procedure TFrmStorageCount.SpeedButton5Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmStorageCount.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

procedure TFrmStorageCount.MenuItem3Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + StorageQuery;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomPriceType);
  ReportTool.SetVarible(CustomPriceType,QuotedStr(ComboBox1.Text));

  ReportTool.AddDataSet(ADOStorage);
  ReportTool.OpenDesgin;
  ReportTool.Free;
end;

procedure TFrmStorageCount.MenuItem2Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + StorageQuery;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomPriceType);
  ReportTool.SetVarible(CustomPriceType,QuotedStr(ComboBox1.Text));

  ReportTool.AddDataSet(ADOStorage);
  ReportTool.Preview;
  ReportTool.Free;
end;

procedure TFrmStorageCount.MenuItem1Click(Sender: TObject);
var
  ReportTool:TAbsReportTool;
begin
  inherited;
  ReportTool := GetReportTool;
  ReportTool.ReportType := 100 + StorageQuery;
  ToolManage.DesginReport(ReportTool);
  ReportTool.AddDirectory(CustomVarible);
  
  ReportTool.AddVariable(CustomVarible,CustomStorageName);
  ReportTool.SetVarible(CustomStorageName,QuotedStr(Edit1.Text));

  ReportTool.AddVariable(CustomVarible,CustomPriceType);
  ReportTool.SetVarible(CustomPriceType,QuotedStr(ComboBox1.Text));

  ReportTool.AddDataSet(ADOStorage);
  ReportTool.Print;
  ReportTool.Free;
end;

procedure TFrmStorageCount.SpeedButton8Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu2.Popup(CurPoint.X,CurPoint.Y);
end;

procedure TFrmStorageCount.SpeedButton7Click(Sender: TObject);
begin
  inherited;
  winexec('calc.exe',sw_normal);
end;

procedure TFrmStorageCount.SpeedButton4Click(Sender: TObject);
var
  CurPoint:TPoint;
begin
  inherited;
  GetCursorPos(CurPoint);
  ScreenToClient(CurPoint);
  PopupMenu1.Popup(CurPoint.X,CurPoint.Y);
end;

end.
