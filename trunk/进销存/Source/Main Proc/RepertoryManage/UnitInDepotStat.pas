unit UnitInDepotStat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, ppDB,
  ppDBPipe, ppComm, ppRelatv, ppProd, ppClass, ppReport, CxGridUnit, ADODB,
  ppBands, ppCache;

type
  TFormInDepotStat = class(TForm)
    pnl1: TPanel;
    spl1: TSplitter;
    pnl2: TPanel;
    grp1: TGroupBox;
    Btn_Print: TSpeedButton;
    Btn_Query: TSpeedButton;
    grp2: TGroupBox;
    ChkDepot: TCheckBox;
    CbbDepot: TComboBox;
    ChkGoodsType: TCheckBox;
    CbbGoodsType: TComboBox;
    CbbInDepotType: TComboBox;
    ChkInDepotType: TCheckBox;
    ChkCreateDate: TCheckBox;
    DtpBeginDateTime: TDateTimePicker;
    DtpEndDateTime: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    cxGridInDepotStatDBTableView1: TcxGridDBTableView;
    cxGridInDepotStatLevel1: TcxGridLevel;
    cxGridInDepotStat: TcxGrid;
    ppReport: TppReport;
    ppDBPipeline: TppDBPipeline;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    DataSourceDSInDepotStat: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
    procedure ChkDepotClick(Sender: TObject);
    procedure ChkGoodsTypeClick(Sender: TObject);
    procedure ChkInDepotTypeClick(Sender: TObject);
  private
    { Private declarations }
    AdoQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;

    procedure AddcxGridViewField;
    procedure LoadStatInfo;
  public
    { Public declarations }
  end;

var
  FormInDepotStat: TFormInDepotStat;

implementation

uses UnitPublic, UnitMain, UnitDataModule;

{$R *.dfm}

procedure TFormInDepotStat.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridInDepotStat,true,false,true);
end;

procedure TFormInDepotStat.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
end;

procedure TFormInDepotStat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormInDepotStat);
end;

procedure TFormInDepotStat.FormDestroy(Sender: TObject);
begin
  FormInDepotStat:= nil;
end;

procedure TFormInDepotStat.Btn_QueryClick(Sender: TObject);
begin
  LoadStatInfo;
end;

procedure TFormInDepotStat.Btn_PrintClick(Sender: TObject);
begin
  if not AdoQuery.Active then
  begin
    Application.MessageBox('����ѡ���ѯ�������в�ѯ��','��ʾ',MB_OK+64);
    Exit;
  end;
  ppReport.Print;
end;

procedure TFormInDepotStat.AddcxGridViewField;
begin
  AddViewField(cxGridInDepotStatDBTableView1,'DepotName','�ֿ�����',100);
  AddViewField(cxGridInDepotStatDBTableView1,'GoodsName','��Ʒ����',200);
  AddViewField(cxGridInDepotStatDBTableView1,'InDepotTypeName','�������');
  AddViewField(cxGridInDepotStatDBTableView1,'InDepotNum','�������');
  AddViewField(cxGridInDepotStatDBTableView1,'CostPrice','�ɱ�����');
  AddViewField(cxGridInDepotStatDBTableView1,'SalePrice','���۵���');
  AddViewField(cxGridInDepotStatDBTableView1,'Cost','�ɱ���');
  AddViewField(cxGridInDepotStatDBTableView1,'Sale','���ۼ�');
  AddViewField(cxGridInDepotStatDBTableView1,'CreateTime','���ʱ��',100);
  AddViewField(cxGridInDepotStatDBTableView1,'ModifyTime','�޸�ʱ��',100);
end;

procedure TFormInDepotStat.LoadStatInfo;
  function GetWhere: string;
  var
    lStr: string;
  begin
    Result:= '';
    lStr:= '';
    if ChkDepot.Checked then
      lStr:= lStr + ' and InDepot.DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items));
    if ChkGoodsType.Checked then
      lStr:= lStr + ' and InDepot.GoodsID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items));
    if ChkInDepotType.Checked then
      lStr:= lStr + ' and InDepot.InDepotTypeID=' + IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items));
    if ChkCreateDate.Checked then
    begin
      DtpBeginDateTime.Date:= Now;
      DtpEndDateTime.Date:= Now;
      lStr:= lStr + ' and InDepot.CreateTime between cdate(''' + DateToStr(DtpBeginDateTime.Date) + ' 00:00:00'
                  + ''') and cdate(''' + DateToStr(DtpBeginDateTime.Date) + ' 59:59:59' + ''')';
    end;
      
    Result:= lStr;
  end;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT InDepot.*, Depot.DepotName, Goods.GoodsName, InDepotType.InDepotTypeName, User.UserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*InDepot.InDepotNum) AS Cost, (Goods.SalePrice*InDepot.InDepotNum) AS Sale ' +
               ' FROM (((InDepot LEFT JOIN Depot ON InDepot.DepotID=Depot.DepotID) ' +
               ' LEFT JOIN Goods ON InDepot.GoodsID=Goods.GoodsID) ' +
               ' INNER JOIN [User] ON InDepot.UserID=User.UserID) ' +
               ' INNER JOIN InDepotType ON InDepot.InDepotTypeID=InDepotType.InDepotTypeID' +
               ' Where 1=1 ' + GetWhere +
               ' Order by InDepot.DepotID,InDepot.GoodsID,InDepot.InDepotTypeID';
    Active:= True;
    DataSourceDSInDepotStat.DataSet:= AdoQuery;
  end;
end;

procedure TFormInDepotStat.ChkDepotClick(Sender: TObject);
begin
  if ChkDepot.Checked then
    SetItemCode('Depot', 'DepotID', 'DepotName', '', CbbDepot.Items)
  else
    ClearTStrings(CbbDepot.Items);
end;

procedure TFormInDepotStat.ChkGoodsTypeClick(Sender: TObject);
begin
  if ChkGoodsType.Checked then
    SetItemCode('Goods', 'GoodsID', 'GoodsName', '', CbbGoodsType.Items)
  else
    ClearTStrings(CbbGoodsType.Items);
end;

procedure TFormInDepotStat.ChkInDepotTypeClick(Sender: TObject);
begin
  if ChkInDepotType.Checked then
    SetItemCode('InDepotType', 'InDepotTypeID', 'InDepotTypeName', ' where InDepotTypeID<>1004', CbbInDepotType.Items)
  else
    ClearTStrings(CbbInDepotType.Items);
end;

end.
