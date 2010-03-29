unit WareBranch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, ComCtrls, Grids, DBGrids,
  DB, ADODB,PubConst;

type
  TFrmWareBranch = class(TFrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    ADOMaster: TADODataSet;
    DSMaster: TDataSource;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    ComboBox1: TComboBox;
    ADOMasterDSDesigner: TStringField;
    ADOMasterDSDesigner3: TIntegerField;
    ADOMasterDSDesigner4: TBCDField;
    ADOMasterField: TCurrencyField;
    procedure ComboBox1Change(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
  
    procedure ActiveADOStorgae(vType:Integer);
  public
    class procedure ShowWareBranch(vWareID:string;WareName:string;
            WareSpce:string;WareUnit:string;vType:Integer);
  end;

var
  FrmWareBranch: TFrmWareBranch;

implementation

uses DataModu;

var
  WareID:string;
  
{$R *.dfm}
const
  atAll             =       1;       //全部 - 所有仓库，预设进价
  atAverageStock    =       2;       //平均进价
  atAverageSell     =       3;       //平均售价
  atSellPrice       =       4;       //预设售价
  atLastInPrice     =       5;       //最后一次进价
  atLastSellPrice   =       6;       //最后一次售价

  
{ TFrmWareBranch }

procedure TFrmWareBranch.ActiveADOStorgae(vType: Integer);
var
  SQL:string;
  SQLSum:string;
begin
  case vType of
    atAll :
    begin
      SQL :=
          ' Select *,价格 * 库存量 库存总额 From ' +
          '  (Select c.仓库名称,' +
          ' case when 0=0 then'+
          ' 	isnull((Select 预设进价 From 商品档案表 Where 商品编码 = ' + WareID +'),0)'+
          ' end 价格,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' + (isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调入仓库 = c.编号),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调出仓库 = c.编号),0)) '+
          ' end 库存量'+

          ' From 仓库档案表 c) a';

      SQLSum := ' Select '+'''合计'''+',NULL'+',Sum(库存量),Sum(库存总额) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';
      
    end;
    atAverageStock:
    begin
      SQL :=
          ' Select *,价格 * 库存量 库存总额 From ' +
          '  (Select c.仓库名称,' +
          ' case when 0=0 then'+
          ' 	isnull((Select  Sum(d.单价)/Count(d.单价) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = '+ IntToStr( StockInStorage ) +' and d.商品编号 =' + WareID +'),0)'+
          ' end 价格,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调入仓库 = c.编号),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调出仓库 = c.编号),0)) '+
          ' end 库存量'+

          ' From 仓库档案表 c) a';

      SQLSum := ' Select '+'''合计'''+',NULL'+',Sum(库存量),Sum(库存总额) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
    atAverageSell:
    begin
      SQL :=
          ' Select *,价格 * 库存量 库存总额 From ' +
          '  (Select c.仓库名称,' +
          ' case when 0=0 then'+
          ' 	isnull((Select  Sum(d.单价)/Count(d.单价) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = '+ IntToStr( SellOutStorage ) +' and d.商品编号 =' + WareID +'),0)'+
          ' end 价格,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调入仓库 = c.编号),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调出仓库 = c.编号),0)) '+
          ' end 库存量'+

          ' From 仓库档案表 c) a';

      SQLSum := ' Select '+'''合计'''+',NULL'+',Sum(库存量),Sum(库存总额) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
    atSellPrice:
    begin
      SQL :=
          ' Select *,价格 * 库存量 库存总额 From ' +
          '  (Select c.仓库名称,' +
          ' case when 0=0 then'+
          ' 	isnull((Select 预设售价 From 商品档案表 Where 商品编码 = ' + WareID +'),0)'+
          ' end 价格,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调入仓库 = c.编号),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调出仓库 = c.编号),0)) '+
          ' end 库存量'+

          ' From 仓库档案表 c) a';

      SQLSum := ' Select '+'''合计'''+',NULL'+',Sum(库存量),Sum(库存总额) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
    atLastInPrice:
    begin

      SQL :=
          ' Select *,价格 * 库存量 库存总额 From ' +
          '  (Select c.仓库名称,' +
          ' case when 0=0 then'+
          ' 	isnull((Select top 1 d.单价 From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockInStorage) + ' and d.商品编号 = ' + WareID +' order by d.编号 desc),0)'+
          ' end 价格,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调入仓库 = c.编号),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调出仓库 = c.编号),0)) '+
          ' end 库存量'+

          ' From 仓库档案表 c) a';

      SQLSum := ' Select '+'''合计'''+',NULL'+',Sum(库存量),Sum(库存总额) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
    atLastSellPrice:
    begin
      SQL :=
          ' Select *,价格 * 库存量 库存总额 From ' +
          '  (Select c.仓库名称,' +
          ' case when 0=0 then'+
          ' 	isnull((Select top 1 d.单价 From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellOutStorage) + ' and d.商品编号 = ' + WareID +' order by d.编号 desc),0)'+
          ' end 价格,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( StockOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellOutStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.数量) From 业务单据主表 m,业务单据明细表 d Where m.仓库编号 = c.编号 and m.单号 = d.定单编号 and m.定单类型 = ' + IntToStr( SellInStorage) + ' and d.商品编号 = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调入仓库 = c.编号),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.数量) From 商品调拨主表 sm '+
          ' left join 商品调拨明细表 sd on sm.单号 = sd.单号 and sd.商品编号 = ' + WareID +
          ' Where sm.调出仓库 = c.编号),0)) '+
          ' end 库存量'+

          ' From 仓库档案表 c) a';

      SQLSum := ' Select '+'''合计'''+',NULL'+',Sum(库存量),Sum(库存总额) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
  end;

  ADOMaster.Active := False;
  ADOMaster.CommandText := SQL;
  ADOMaster.Active := True;

end;

class procedure TFrmWareBranch.ShowWareBranch(vWareID:string;WareName:string;
            WareSpce:string;WareUnit:string;vType:Integer);
begin
  WareID := vWareID;
  FrmWareBranch := TFrmWareBranch.Create(Application);
  FrmWareBranch.ActiveADOStorgae(vType);
  FrmWareBranch.Edit1.Text := WareName;
  FrmWareBranch.Edit2.Text := WareSpce;
  FrmWareBranch.Edit3.Text := WareUnit;

  case vType of
  atAll             : FrmWareBranch.ComboBox1.ItemIndex := 2;
  atAverageStock    : FrmWareBranch.ComboBox1.ItemIndex := 0;
  atAverageSell     : FrmWareBranch.ComboBox1.ItemIndex := 1;
  atSellPrice       : FrmWareBranch.ComboBox1.ItemIndex := 3;
  atLastInPrice     : FrmWareBranch.ComboBox1.ItemIndex := 4;
  atLastSellPrice   : FrmWareBranch.ComboBox1.ItemIndex := 5;
  end;
  
  FrmWareBranch.ShowModal;
  FrmWareBranch.Free;
end;

procedure TFrmWareBranch.ComboBox1Change(Sender: TObject);
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

procedure TFrmWareBranch.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  dbgridDrawColumnCell(Sender,Rect,DataCol,Column,State);
end;

end.
