unit UnitBalanceAnalyse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ExtCtrls, StdCtrls, Buttons,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ADODB, cxGridUnit;

type
  TFormBalanceAnalyse = class(TForm)
    pnl2: TPanel;
    cxGridBalanceAnalyse: TcxGrid;
    cxGridBalanceAnalyseDBTableView1: TcxGridDBTableView;
    cxGridBalanceAnalyseLevel1: TcxGridLevel;
    pnl1: TPanel;
    GroupBoxgrp1: TGroupBox;
    Btn_Print: TSpeedButton;
    Btn_Query: TSpeedButton;
    GroupBoxgrp2: TGroupBox;
    ChkGoods: TCheckBox;
    CbbGoods: TComboBox;
    spl1: TSplitter;
    DSBalanceAnalyse: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
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
  FormBalanceAnalyse: TFormBalanceAnalyse;

implementation

uses UnitPublic, UnitDataModule;

{$R *.dfm}

procedure TFormBalanceAnalyse.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridBalanceAnalyse,true,false,true);

  SetItemCode('Goods', 'GoodsID', 'GoodsName', ' ', CbbGoods.Items);
end;

procedure TFormBalanceAnalyse.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
end;

procedure TFormBalanceAnalyse.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormBalanceAnalyse.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormBalanceAnalyse.AddcxGridViewField;
begin
  AddViewField(cxGridBalanceAnalyseDBTableView1,'GoodsName','商品名称',100);
  AddViewField(cxGridBalanceAnalyseDBTableView1,'InNumTotal','入库数量');
  AddViewField(cxGridBalanceAnalyseDBTableView1,'OutNumTotal','出库数量');
  AddViewField(cxGridBalanceAnalyseDBTableView1,'LeaveNUMTotal','库存数量');
  AddViewField(cxGridBalanceAnalyseDBTableView1,'BalanceAnalyse','是否平衡');  
end;

procedure TFormBalanceAnalyse.LoadStatInfo;
var
  lSqlStr: string;
  function GetWhere: string;
  var
    lStr: string;
  begin
    Result:= '';
    lStr:= '';
    if ChkGoods.Checked then
      lStr:= lStr + ' and GoodsID=' + IntToStr(GetItemCode(CbbGoods.Text, CbbGoods.Items));
    Result:= lStr;
  end;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    lSqlStr:= 'SELECT * FROM (' +
              'SELECT GoodsID, GoodsName, Sum(InNum) AS InNumTotal, Sum(OutNum) AS OutNumTotal, Sum(LeaveNUM) AS LeaveNUMTotal,' +
              ' iif(Sum(InNum)=Sum(OutNum)+Sum(LeaveNUM),''平衡'',iif(Sum(InNum)<>Sum(OutNum)+Sum(LeaveNUM),''不平衡'')) AS BalanceAnalyse' +
              ' from' +
              ' ( ' +
              'SELECT GOODS.GoodsID, GOODS.GoodsName, InDepot.InDepotNum AS InNum, 0 AS OutNum, 0 AS LeaveNUM' +
              '  FROM GOODS' +
              '  LEFT JOIN InDepot ON GOODS.GoodsID = InDepot.GoodsID' +
              ' UNION ' +
              'SELECT GOODS.GoodsID, GOODS.GoodsName, 0 AS InNum, OutDepotDetails.Num AS OutNum, 0 AS LeaveNUM' +
              '  FROM GOODS' +
              '  LEFT JOIN OutDepotDetails ON GOODS.GoodsID = OutDepotDetails.GoodsID' +
              ' UNION ' +
              'SELECT GOODS.GoodsID, GOODS.GoodsName, 0 AS InNum, 0 AS OutNum, Repertory.GoodsNUM  AS LeaveNUM' +
              '  FROM GOODS' +
              '  LEFT JOIN Repertory ON GOODS.GoodsID = Repertory.GoodsID' +
              ' ) ' +
              'GROUP BY GoodsID, GoodsName)' +
              ' WHERE 1=1 ' + GetWhere;
    SQL.Text:= lSqlStr;
    Active:= True;
    DSBalanceAnalyse.DataSet:= AdoQuery;
  end;
end;

procedure TFormBalanceAnalyse.Btn_QueryClick(Sender: TObject);
begin
  LoadStatInfo;
end;

procedure TFormBalanceAnalyse.Btn_PrintClick(Sender: TObject);
begin
//
end;


end.
