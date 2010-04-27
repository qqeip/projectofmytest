unit UnitGoodsSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Buttons, ADODB, CxGridUnit;

type
  TFormGoodsSearch = class(TForm)
    grp1: TGroupBox;
    grp2: TGroupBox;
    cxGridGoodsDBTableView1: TcxGridDBTableView;
    cxGridGoodsLevel1: TcxGridLevel;
    cxGridGoods: TcxGrid;
    EdtName: TEdit;
    ChkName: TCheckBox;
    ChkGoodsType: TCheckBox;
    CbbGoodsType: TComboBox;
    Label1: TLabel;
    BtnCancel: TSpeedButton;
    BtnOK: TSpeedButton;
    DSGoods: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure cxGridGoodsDBTableView1DblClick(Sender: TObject);
  private
    { Private declarations }

    AdoQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;
    FBarCode: string;
    procedure AddcxGridViewField;
  public
    { Public declarations }
  property BarCode: string read FBarCode write FBarCode;
  end;

var
  FormGoodsSearch: TFormGoodsSearch;

implementation

uses UnitPublic, UnitDataModule;

{$R *.dfm}

procedure TFormGoodsSearch.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridGoods,true,false,true);
  SetItemCode('GoodsType', 'GoodsTypeID', 'GoodsTypeName', '', CbbGoodsType.Items);
end;

procedure TFormGoodsSearch.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
end;

procedure TFormGoodsSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormGoodsSearch.FormDestroy(Sender: TObject);
begin
  AdoQuery.Free;
  FCxGridHelper.Free;
end;

procedure TFormGoodsSearch.AddcxGridViewField;
begin
  AddViewField(cxGridGoodsDBTableView1,'GoodsID','��Ʒ���');
  AddViewField(cxGridGoodsDBTableView1,'BarCode','���α���');
  AddViewField(cxGridGoodsDBTableView1,'GoodsName','��Ʒ����');
  AddViewField(cxGridGoodsDBTableView1,'GOODSTYPENAME','��Ʒ���');
  AddViewField(cxGridGoodsDBTableView1,'MeasureUnit','������λ');
  AddViewField(cxGridGoodsDBTableView1,'GoodsSize','����ͺ�');
  AddViewField(cxGridGoodsDBTableView1,'CostPrice','�ɱ��۸�');
  AddViewField(cxGridGoodsDBTableView1,'SalePrice','���ۼ۸�');
  AddViewField(cxGridGoodsDBTableView1,'ProducingArea','��    ��');
  AddViewField(cxGridGoodsDBTableView1,'ProviderName','������');
end;

procedure TFormGoodsSearch.BtnOKClick(Sender: TObject);
var
  lWhereStr: string;
begin
  if ChkName.Checked then
  begin
    lWhereStr:= lWhereStr +
                ' and (BarCode like ''%' + EdtName.Text + '%''' +
                ' or GoodsName like ''%' + EdtName.Text + '%''' +
                ' or ProviderName like ''%' + EdtName.Text + '%''' + ')';
  end;
  if ChkGoodsType.Checked then
  begin
    lWhereStr:= lWhereStr + ' and Goods.GOODSTYPEID=' +
                IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items));
  end;

  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT Goods.*, Provider.ProviderName, GOODSTYPE.GOODSTYPENAME FROM ' +
               '(Goods LEFT JOIN Provider ON Provider.ProviderID=Goods.ProviderID)' +
               ' LEFT JOIN GOODSTYPE ON GOODSTYPE.GOODSTYPEID=Goods.GoodsTypeID' +
               ' where 1=1 ' + lWhereStr +
               ' order by GoodsID';
    Active:= True;
    DSGoods.DataSet:= AdoQuery;
  end;
end;

procedure TFormGoodsSearch.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormGoodsSearch.cxGridGoodsDBTableView1DblClick(
  Sender: TObject);
var
  lBarCode_Index, lRecordIndex: Integer;
begin
  try
    lBarCode_Index:=cxGridGoodsDBTableView1.GetColumnByFieldName('BarCode').Index;
  except
    Application.MessageBox('δ���"������"�ؼ��֣�','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if cxGridGoodsDBTableView1.DataController.GetSelectedCount=0 then
  begin
    Application.MessageBox('��ѡ��һ����¼����','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  if cxGridGoodsDBTableView1.DataController.GetSelectedCount>1 then
  begin
    Application.MessageBox('ֻ��ѡ��һ����¼����','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  if cxGridGoodsDBTableView1.DataController.GetSelectedCount=1 then
  begin
    lRecordIndex := cxGridGoodsDBTableView1.Controller.SelectedRows[0].RecordIndex;
    FBarCode:= cxGridGoodsDBTableView1.DataController.GetValue(lRecordIndex,lBarCode_Index);;
    ModalResult:= mrOk;
  end;
end;

end.
