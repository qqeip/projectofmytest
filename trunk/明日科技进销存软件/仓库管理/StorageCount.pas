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
  atAll             =       1;       //ȫ�� - ���вֿ⣬Ԥ�����
  atAverageStock    =       2;       //ƽ������
  atAverageSell     =       3;       //ƽ���ۼ�
  atSellPrice       =       4;       //Ԥ���ۼ�
  atLastInPrice     =       5;       //���һ�ν���
  atLastSellPrice   =       6;       //���һ���ۼ�

  cpUp      =     1;    //���ޱ���
  cpDown    =     2;    //���ޱ���
  cpNone    =     3;    //������  


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
    StorageWhere := 'and m.�ֿ��� = ' + FStorageID;

  case vType of
    atAll :
    begin
      SQL := ' Select *,Ԥ�����*��ǰ��� ����ܼ� From '+
          ' (Select a.��Ʒ����,a.��Ʒ����,a.ƴ������,a.����ͺ�,a.��λ'+
          ' ,a.Ԥ�����,a.�������,a.�������,'+
          ' case when 0=0 then'+
          ' isnull((Select (        '+

          '           (isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
          '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockInStorage) +'),0)  '+
          ' +     '+
          '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d '+
          '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockOutStorage) +'),0))'+
          ' -     '+
          '           ( isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
          '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellOutStorage) +'),0)   '+
          ' +     '+
          '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
          '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellInStorage) +'),0)) '+
          ' )),0)    '+
          ' end  ��ǰ���'+
          ' From ��Ʒ������ a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''�ϼ�'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(��ǰ���),Sum(����ܼ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by ��Ʒ���� desc';
      
      ADOStorage.FieldByName('Ԥ�����').DisplayLabel := 'Ԥ�����';
    end;
    atAverageStock:
    begin
      SQL := 'Select *,Ԥ�����*��ǰ��� ����ܼ� From (Select a.��Ʒ����,a.��Ʒ����,a.ƴ������,a.����ͺ�,'+
              '	a.��λ,' +
              'case when 0=0 then '  +
              '	isnull((Select sum(mm.����) / Count(mm.����) From ' +
              '	(Select m.�ֿ���,d.* From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d ' +
              ' Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockInStorage) +' ) mm),0)'+
              ' end Ԥ����� ' +
              ' ,a.�������,a.�������,' +
              ' case when 0=0 then ' +
              ' isnull((Select (        '+

              '           (isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockInStorage) +'),0)  '+
              ' +     '+
              '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockOutStorage) +'),0))'+
              ' -     '+
              '           ( isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellOutStorage) +'),0)   '+
              ' +     '+
              '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellInStorage) +'),0)) '+
              ' )),0)    '+
              ' end  ��ǰ���'+
              ' From ��Ʒ������ a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''�ϼ�'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(��ǰ���),Sum(����ܼ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by ��Ʒ���� desc';

      ADOStorage.FieldByName('Ԥ�����').DisplayLabel := 'ƽ������'; 
    end;
    atAverageSell:
    begin
      SQL := 'Select *,Ԥ�����*��ǰ��� ����ܼ� From (Select a.��Ʒ����,a.��Ʒ����,a.ƴ������,a.����ͺ�,'+
              '	a.��λ,' +
              'case when 0=0 then '  +
              '	isnull((Select sum(mm.����) / Count(mm.����) From ' +
              '	(Select m.�ֿ���,d.* From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d ' +
              ' Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellOutStorage) +' ) mm),0)'+
              ' end Ԥ����� ' +
              ' ,a.�������,a.�������,' +
              ' case when 0=0 then ' +
              ' isnull((Select (        '+

              '           (isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockInStorage) +'),0)  '+
              ' +     '+
              '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockOutStorage) +'),0))'+
              ' -     '+
              '           ( isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellOutStorage) +'),0)   '+
              ' +     '+
              '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellInStorage) +'),0)) '+
              ' )),0)    '+
              ' end  ��ǰ���'+
              ' From ��Ʒ������ a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''�ϼ�'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(��ǰ���),Sum(����ܼ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by ��Ʒ���� desc';

      ADOStorage.FieldByName('Ԥ�����').DisplayLabel := 'ƽ���ۼ�';
    end;
    atSellPrice:
    begin
      SQL := ' Select *,Ԥ�����*��ǰ��� ����ܼ� From '+
          ' (Select a.��Ʒ����,a.��Ʒ����,a.ƴ������,a.����ͺ�,a.��λ'+
          ' ,a.Ԥ���ۼ� Ԥ�����,a.�������,a.�������,'+
          ' case when 0=0 then'+
          ' isnull((Select (        '+

          '           (isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
          '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockInStorage) +'),0)  '+
          ' +     '+
          '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d '+
          '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockOutStorage) +'),0))'+
          ' -     '+
          '           ( isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
          '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellOutStorage) +'),0)   '+
          ' +     '+
          '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
          '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellInStorage) +'),0)) '+
          ' )),0)    '+
          ' end  ��ǰ���'+
          ' From ��Ʒ������ a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''�ϼ�'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(��ǰ���),Sum(����ܼ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by ��Ʒ���� desc';

      ADOStorage.FieldByName('Ԥ�����').DisplayLabel := 'Ԥ���ۼ�';
    end;
    atLastInPrice:
    begin
      SQL := 'Select *,Ԥ�����*��ǰ��� ����ܼ� '+
              ' From (Select a.��Ʒ����,a.��Ʒ����,a.ƴ������,a.����ͺ�,' +
              '	a.��λ, ' +
              ' case when 0=0 then  ' +
              '	isnull((Select  mm.���� From '  +
              '	(Select top 1 m.�ֿ���,d.* From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d' +
              ' Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockInStorage) +' ' +
              ' order by d.��� desc ) mm),0) ' +
              ' end Ԥ����� '  +
              ' ,a.�������,a.�������, ' +
              ' case when 0=0 then ' +
              ' isnull((Select (        '+

              '           (isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockInStorage) +'),0)  '+
              ' +     '+
              '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockOutStorage) +'),0))'+
              ' -     '+
              '           ( isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellOutStorage) +'),0)   '+
              ' +     '+
              '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellInStorage) +'),0)) '+
              ' )),0)    '+
              ' end  ��ǰ���'+

              ' From ��Ʒ������ a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''�ϼ�'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(��ǰ���),Sum(����ܼ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by ��Ʒ���� desc';

      ADOStorage.FieldByName('Ԥ�����').DisplayLabel := '���һ�ν���';
    end;
    atLastSellPrice:
    begin
      SQL := 'Select *,Ԥ�����*��ǰ��� ����ܼ� '+
              ' From (Select a.��Ʒ����,a.��Ʒ����,a.ƴ������,a.����ͺ�,' +
              '	a.��λ, ' +
              ' case when 0=0 then  ' +
              '	isnull((Select  mm.���� From '  +
              '	(Select top 1 m.�ֿ���,d.* From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d' +
              ' Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellOutStorage) +' ' +
              ' order by d.��� desc ) mm),0) ' +
              ' end Ԥ����� '  +
              ' ,a.�������,a.�������, ' +
              ' case when 0=0 then ' +
              ' isnull((Select (        '+

              '           (isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockInStorage) +'),0)  '+
              ' +     '+
              '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(StockOutStorage) +'),0))'+
              ' -     '+
              '           ( isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellOutStorage) +'),0)   '+
              ' +     '+
              '           isnull((Select sum(d.����) From ҵ�񵥾����� m,ҵ�񵥾���ϸ�� d  '+
              '            Where m.���� = d.������� and d.��Ʒ��� = a.��Ʒ���� '+ StorageWhere +' and m.�������� = '+ IntToStr(SellInStorage) +'),0)) '+
              ' )),0)    '+
              ' end  ��ǰ���'+

              ' From ��Ʒ������ a Where flg = 1) zz ';

      SQLSum := ' Select '+'NULL'+',''�ϼ�'''+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',NULL'+',Sum(��ǰ���),Sum(����ܼ�) '+
                ' From ('+ SQL +') h';
      SQL := 'Select * From (' + sql + ' union '+ SQLSum +') n Order by ��Ʒ���� desc';

      
      ADOStorage.FieldByName('Ԥ�����').DisplayLabel := '���һ���ۼ�';
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
  Edit1.Text := '(ȫ��)';
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
  if (ADOStorage.IsEmpty) or (ADOStorage.FieldByName('��Ʒ����').IsNull) then
    Exit;
  
  FrmWareEdit := TFrmWareEdit.Create(Self);
  FrmWareEdit.ADOEdit.Active := False;
  FrmWareEdit.ADOEdit.CommandText := 'Select * From ��Ʒ������ Where flg = 1 and ��Ʒ���� = '+
    ADOStorage.FieldByName('��Ʒ����').AsString;
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
  if ADOStorage.FieldByName('��Ʒ����').AsString = '' then
    Exit;
  TFrmWareBranch.ShowWareBranch(ADOStorage.FieldByName('��Ʒ����').AsString,
      ADOStorage.FieldByName('��Ʒ����').AsString,
      ADOStorage.FieldByName('����ͺ�').AsString,
      ADOStorage.FieldByName('��λ').AsString,
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
      if Field.DataSet.FieldByName('��ǰ���').AsInteger <= 0 then
        Color := clRed
      else
        Color := clWindowText;
    end;
    cpUp:
    begin
      if (Field.DataSet.FieldByName('��ǰ���').AsInteger >
           Field.DataSet.FieldByName('�������').AsInteger)
           and not Field.DataSet.FieldByName('�������').IsNull then
        Color := clRed
      else
        Color := clWindowText;
    end;
    cpDown:
    begin
      if (Field.DataSet.FieldByName('��ǰ���').AsInteger <
           Field.DataSet.FieldByName('�������').AsInteger)
           and not Field.DataSet.FieldByName('�������').IsNull then
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
