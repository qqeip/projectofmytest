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
  atAll             =       1;       //ȫ�� - ���вֿ⣬Ԥ�����
  atAverageStock    =       2;       //ƽ������
  atAverageSell     =       3;       //ƽ���ۼ�
  atSellPrice       =       4;       //Ԥ���ۼ�
  atLastInPrice     =       5;       //���һ�ν���
  atLastSellPrice   =       6;       //���һ���ۼ�

  
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
          ' Select *,�۸� * ����� ����ܶ� From ' +
          '  (Select c.�ֿ�����,' +
          ' case when 0=0 then'+
          ' 	isnull((Select Ԥ����� From ��Ʒ������ Where ��Ʒ���� = ' + WareID +'),0)'+
          ' end �۸�,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' + (isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.����ֿ� = c.���),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.�����ֿ� = c.���),0)) '+
          ' end �����'+

          ' From �ֿ⵵���� c) a';

      SQLSum := ' Select '+'''�ϼ�'''+',NULL'+',Sum(�����),Sum(����ܶ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';
      
    end;
    atAverageStock:
    begin
      SQL :=
          ' Select *,�۸� * ����� ����ܶ� From ' +
          '  (Select c.�ֿ�����,' +
          ' case when 0=0 then'+
          ' 	isnull((Select  Sum(d.����)/Count(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = '+ IntToStr( StockInStorage ) +' and d.��Ʒ��� =' + WareID +'),0)'+
          ' end �۸�,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.����ֿ� = c.���),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.�����ֿ� = c.���),0)) '+
          ' end �����'+

          ' From �ֿ⵵���� c) a';

      SQLSum := ' Select '+'''�ϼ�'''+',NULL'+',Sum(�����),Sum(����ܶ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
    atAverageSell:
    begin
      SQL :=
          ' Select *,�۸� * ����� ����ܶ� From ' +
          '  (Select c.�ֿ�����,' +
          ' case when 0=0 then'+
          ' 	isnull((Select  Sum(d.����)/Count(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = '+ IntToStr( SellOutStorage ) +' and d.��Ʒ��� =' + WareID +'),0)'+
          ' end �۸�,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.����ֿ� = c.���),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.�����ֿ� = c.���),0)) '+
          ' end �����'+

          ' From �ֿ⵵���� c) a';

      SQLSum := ' Select '+'''�ϼ�'''+',NULL'+',Sum(�����),Sum(����ܶ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
    atSellPrice:
    begin
      SQL :=
          ' Select *,�۸� * ����� ����ܶ� From ' +
          '  (Select c.�ֿ�����,' +
          ' case when 0=0 then'+
          ' 	isnull((Select Ԥ���ۼ� From ��Ʒ������ Where ��Ʒ���� = ' + WareID +'),0)'+
          ' end �۸�,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.����ֿ� = c.���),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.�����ֿ� = c.���),0)) '+
          ' end �����'+

          ' From �ֿ⵵���� c) a';

      SQLSum := ' Select '+'''�ϼ�'''+',NULL'+',Sum(�����),Sum(����ܶ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
    atLastInPrice:
    begin

      SQL :=
          ' Select *,�۸� * ����� ����ܶ� From ' +
          '  (Select c.�ֿ�����,' +
          ' case when 0=0 then'+
          ' 	isnull((Select top 1 d.���� From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockInStorage) + ' and d.��Ʒ��� = ' + WareID +' order by d.��� desc),0)'+
          ' end �۸�,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.����ֿ� = c.���),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.�����ֿ� = c.���),0)) '+
          ' end �����'+

          ' From �ֿ⵵���� c) a';

      SQLSum := ' Select '+'''�ϼ�'''+',NULL'+',Sum(�����),Sum(����ܶ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union all '+ SQLSum +') n ';

    end;
    atLastSellPrice:
    begin
      SQL :=
          ' Select *,�۸� * ����� ����ܶ� From ' +
          '  (Select c.�ֿ�����,' +
          ' case when 0=0 then'+
          ' 	isnull((Select top 1 d.���� From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellOutStorage) + ' and d.��Ʒ��� = ' + WareID +' order by d.��� desc),0)'+
          ' end �۸�,'+
          ' case when 0=0 then'+
          ' 	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +	isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( StockOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellOutStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' - isnull((Select Sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d Where m.�ֿ��� = c.��� and m.���� = d.������� and m.�������� = ' + IntToStr( SellInStorage) + ' and d.��Ʒ��� = ' + WareID +'),0)'+
          ' +(isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.����ֿ� = c.���),0) '+
          ' - '+
          ' isnull( '+
          ' (Select SUM(sd.����) From ��Ʒ�������� sm '+
          ' left join ��Ʒ������ϸ�� sd on sm.���� = sd.���� and sd.��Ʒ��� = ' + WareID +
          ' Where sm.�����ֿ� = c.���),0)) '+
          ' end �����'+

          ' From �ֿ⵵���� c) a';

      SQLSum := ' Select '+'''�ϼ�'''+',NULL'+',Sum(�����),Sum(����ܶ�) '+
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
