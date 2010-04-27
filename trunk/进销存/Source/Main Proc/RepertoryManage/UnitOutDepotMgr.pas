unit UnitOutDepotMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls, ADODB, Grids, CxGridUnit,
  DBGrids;

type
  TFormOutDepotMgr = class(TForm)
    GroupBox1: TGroupBox;
    cxGridDetails: TcxGrid;
    cxGridDetailsDBTableView1: TcxGridDBTableView;
    cxGridDetailsLevel1: TcxGridLevel;
    Panel2: TPanel;
    GroupBoxOutDepot: TGroupBox;
    LabelBarCode: TLabel;
    LabelCustomerName: TLabel;
    LabelIntegral: TLabel;
    LabelAssociatorType: TLabel;
    EdtCustomerName: TEdit;
    EdtBarCode: TEdit;
    EdtIntegral: TEdit;
    GroupBoxGoodsInfo: TGroupBox;
    LabelGoodsID1: TLabel;
    EdtGoodsID: TEdit;
    LabelGoodsName1: TLabel;
    EdtGoodsName: TEdit;
    LabelDepotName: TLabel;
    EdtDepotName: TEdit;
    LabelProvider: TLabel;
    EdtProvider: TEdit;
    LabelConst: TLabel;
    EdtCostPrice: TEdit;
    LabelGoodsType: TLabel;
    EdtGoodsType: TEdit;
    BtnGoodsSearch: TSpeedButton;
    BtnCustomerSearch: TSpeedButton;
    BtnSubmit: TSpeedButton;
    BtnCancel: TSpeedButton;
    Btn1: TSpeedButton;
    LabelDiscount: TLabel;
    EdtDiscount: TEdit;
    DSDetail: TDataSource;
    LabelCustomerID: TLabel;
    EdtCustomerID: TEdit;
    EdtAssociatorType: TEdit;
    LabelOutDepotType: TLabel;
    CbbOutDepotType: TComboBox;
    LabelOutDepotNum: TLabel;
    EdtOutDepotNum: TEdit;
    grp1: TGroupBox;
    spl1: TSplitter;
    DSHistory: TDataSource;
    DSHistoryDetail: TDataSource;
    cxGridHistory: TcxGrid;
    cxGridHistoryTableView1: TcxGridDBTableView;
    cxGridHistoryDetailTableView1: TcxGridDBTableView;
    cxGridHistoryLevel1: TcxGridLevel;
    cxGridHistoryLevel2: TcxGridLevel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure EdtBarCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnGoodsSearchClick(Sender: TObject);
    procedure BtnCustomerSearchClick(Sender: TObject);
    procedure EdtDiscountKeyPress(Sender: TObject; var Key: Char);
    procedure EdtCustomerIDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdtOutDepotNumKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnSubmitClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure Btn1Click(Sender: TObject);
    procedure EdtOutDepotNumKeyPress(Sender: TObject; var Key: Char);
    procedure cxGridHistoryTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
  private
    { Private declarations }
    FCxGridHelper : TCxGridSet;
    FAdoQueryDetail, FAdoQueryHistory, FAdoQueryHistoryDetail, FAdoEdit: TAdoquery;
    FOrderID: string;     //订单号 或 出库流水号
    ISExsitCustomer: Boolean; //是否存在客户
    FDepotID, FGoodsID, FCustomerID : Integer;
    FPercent, FSalePrice, FDiscount: Double; //营业员提成比例 , 销售单价 , 会员享受折扣
    FGoodsTotalNum: Integer; //商品的库存总数量

    procedure GetCustomerOutDepotSummary;
    procedure GetOutDepotDetails(aAdoQuery: TADOQuery; Ds: TDataSource; aOrderBH: string);
    procedure AddcxGridViewField;
  public
    { Public declarations }
  end;

var
  FormOutDepotMgr: TFormOutDepotMgr;

implementation

uses UnitMain, UnitDataModule, UnitGoodsSearch, UnitPublic,
  UnitPublicResourceManager, UnitCustomerSearch;

{$R *.dfm}

procedure TFormOutDepotMgr.FormCreate(Sender: TObject);
begin
  FOrderID:= GetID('OrderBH', 'OutDepotSummary');
  FAdoQueryDetail:= TADOQuery.Create(Self);
  FAdoQueryHistory:= TADOQuery.Create(Self);
  FAdoQueryHistoryDetail:= TADOQuery.Create(Self);
  FAdoEdit:= TADOQuery.Create(Self);
  SetItemCode('OutDepotType', 'OutDepotTypeID', 'OutDepotTypeNAME', '', CbbOutDepotType.Items);

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDetails,true,false,true);
  FCxGridHelper.SetGridStyle(cxGridHistory,true,false,true);
  AddcxGridViewField;
end;

procedure TFormOutDepotMgr.FormShow(Sender: TObject);
begin
  EdtBarCode.SetFocus;
  CbbOutDepotType.ItemIndex:= CbbOutDepotType.Items.IndexOf('零售出库');
end;

procedure TFormOutDepotMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormOutDepotMgr);
//  Action:= caFree;
end;

procedure TFormOutDepotMgr.FormDestroy(Sender: TObject);
begin
  FAdoQueryDetail.Free;
  FAdoQueryHistory.Free;
  FAdoQueryHistoryDetail.Free;
  FAdoEdit.Free;
  FormOutDepotMgr:= nil;
end;

procedure TFormOutDepotMgr.AddcxGridViewField;
begin
  //Details
  AddViewField(cxGridDetailsDBTableView1,'ID','内部编号');
  AddViewField(cxGridDetailsDBTableView1,'OrderBH','流水号');
  AddViewField(cxGridDetailsDBTableView1,'GoodsID','商品编号');
  AddViewField(cxGridDetailsDBTableView1,'BarCode','条形编码');
  AddViewField(cxGridDetailsDBTableView1,'GoodsName','商品名称');
  AddViewField(cxGridDetailsDBTableView1,'GOODSTYPENAME','商品类别');
  AddViewField(cxGridDetailsDBTableView1,'OutDepotTypeName','出库类型');
  AddViewField(cxGridDetailsDBTableView1,'DEPOTNAME','所属仓库');
  AddViewField(cxGridDetailsDBTableView1,'ProviderName','供货商');
  AddViewField(cxGridDetailsDBTableView1,'UserName','操作员');
  AddViewField(cxGridDetailsDBTableView1,'CostPrice','成本价格');
  AddViewField(cxGridDetailsDBTableView1,'SalePrice','销售价格');
  AddViewField(cxGridDetailsDBTableView1,'Num','数量');
  AddViewField(cxGridDetailsDBTableView1,'SaleMoney','金额');
  AddViewField(cxGridDetailsDBTableView1,'CreateTime','时间',120);
  //History
  AddViewField(cxGridHistoryTableView1,'ID','内部编号');
  AddViewField(cxGridHistoryTableView1,'OrderBH','流水号');
  AddViewField(cxGridHistoryTableView1,'CustomerName','会员名称');
  AddViewField(cxGridHistoryTableView1,'USERNAME','操作员');
  AddViewField(cxGridHistoryTableView1,'AssociatorTypeName','会员类型');
  AddViewField(cxGridHistoryTableView1,'CustomerIntegral','积分');
  AddViewField(cxGridHistoryTableView1,'Discount','享受折扣');
  AddViewField(cxGridHistoryTableView1,'TotalNum','数量');
  AddViewField(cxGridHistoryTableView1,'TotalMoney','金额');
  AddViewField(cxGridHistoryTableView1,'CreateTime','时间');
  //HistoryDetails
  AddViewField(cxGridHistoryDetailTableView1,'ID','内部编号');
  AddViewField(cxGridHistoryDetailTableView1,'OrderBH','流水号');
  AddViewField(cxGridHistoryDetailTableView1,'GoodsID','商品编号');
  AddViewField(cxGridHistoryDetailTableView1,'BarCode','条形编码');
  AddViewField(cxGridHistoryDetailTableView1,'GoodsName','商品名称');
  AddViewField(cxGridHistoryDetailTableView1,'GOODSTYPENAME','商品类别');
  AddViewField(cxGridHistoryDetailTableView1,'OutDepotTypeName','出库类型');
  AddViewField(cxGridHistoryDetailTableView1,'DEPOTNAME','所属仓库');
  AddViewField(cxGridHistoryDetailTableView1,'ProviderName','供货商');
  AddViewField(cxGridHistoryDetailTableView1,'UserName','操作员');
  AddViewField(cxGridHistoryDetailTableView1,'CostPrice','成本价格');
  AddViewField(cxGridHistoryDetailTableView1,'SalePrice','销售价格');
  AddViewField(cxGridHistoryDetailTableView1,'Num','数量');
  AddViewField(cxGridHistoryDetailTableView1,'SaleMoney','金额');
  AddViewField(cxGridHistoryDetailTableView1,'CreateTime','时间',120);
end;

procedure TFormOutDepotMgr.BtnSubmitClick(Sender: TObject);
var
  lTotalNum: Integer;
  lTotalmoney: Double;
  lSqlStr: string;
  function GetTotalNum(aOrderBH: string): Boolean;
  begin
    Result:= False;
    with TADOQuery.Create(nil) do
    begin
      try
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT GetNum.* FROM (SELECT OrderBH, sum(Num) AS TotalNum, sum(SaleMoney) AS TotalSaleMoney ' +
                   ' FROM OutDepotDetails' +
                   ' WHERE OrderBH=''' + FOrderID +
                   ''' GROUP BY OrderBH) AS GetNum';
        Active:= True;
        if not IsEmpty then
        begin
          lTotalNum:= FieldByName('TotalNum').AsInteger;
          if ISExsitCustomer then
            lTotalmoney:= FieldByName('TotalSaleMoney').AsFloat / 100 * FDiscount
          else
            lTotalmoney:= FieldByName('TotalSaleMoney').AsFloat;
          Result:= True;
        end
        else
          Result:= False;
      finally
        Free;
      end;
    end;
  end;
begin
  if not GetTotalNum(FOrderID) then
  begin
    Application.MessageBox('无要结算数据！','提示',MB_OK+64);
    Exit;
  end;

  with FAdoEdit do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      if ISExsitCustomer then
        lSqlStr:= 'insert into OutDepotSummary(' +
                   'OrderBH,' +
                   'UserID,' +
                   'CustomerID,' +
                   'OutDepotTypeID,' +
                   'TotalNum,' +
                   'TotalMoney,' +
                   'CreateTime) ' +
                   'Values(''' +
                   FOrderID + ''',' +
                   IntToStr(CurUser.UserID) + ',' +
                   IntToStr(FCustomerID) + ',' +
                   IntToStr(GetItemCode(CbbOutDepotType.Text, CbbOutDepotType.Items)) + ',' +
                   IntToStr(lTotalNum) + ',' +
                   FloatToStr(lTotalmoney) + ',' +
                   'cdate(''' + DateTimeToStr(Now) + ''')' +
                   ')'
      else
        lSqlStr:= 'insert into OutDepotSummary(' +
                   'OrderBH,' +
                   'UserID,' +
                   'OutDepotTypeID,' +
                   'TotalNum,' +
                   'TotalMoney,' +
                   'CreateTime) ' +
                   'Values(''' +
                   FOrderID + ''',' +
                   IntToStr(CurUser.UserID) + ',' +
                   IntToStr(GetItemCode(CbbOutDepotType.Text, CbbOutDepotType.Items)) + ',' +
                   IntToStr(lTotalNum) + ',' +
                   FloatToStr(lTotalmoney) + ',' +
                   'cdate(''' + DateTimeToStr(Now) + ''')' +
                   ')';
      SQL.Text:= lSqlStr;
      ExecSQL;
      FOrderID:= GetID('OrderBH', 'OutDepotSummary');
      //计算积分

      Application.MessageBox('结算完成！','提示',MB_OK+64);
    finally
    end;
  end;
end;

procedure TFormOutDepotMgr.BtnCancelClick(Sender: TObject);
var
  i: Integer;
begin
  ISExsitCustomer:= False;
  for i:=0 to GroupBoxGoodsInfo.ControlCount-1 do
  begin
    if GroupBoxGoodsInfo.Controls[i] is TEdit then
      TEdit(GroupBoxGoodsInfo.Controls[i]).Text:= '';
  end;
  for i:=0 to GroupBoxOutDepot.ControlCount-1 do
  begin
    if GroupBoxOutDepot.Controls[i] is TEdit then
      TEdit(GroupBoxOutDepot.Controls[i]).Text:= '';
  end;

  EdtOutDepotNum.Text:= '1';
  with FAdoEdit do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'DELETE FROM OutDepotDetails WHERE ORDERBH=''' + FOrderID + '''';
      ExecSQL;
      GetOutDepotDetails(FAdoQueryDetail, DSDetail, FOrderID);
    finally
    end;
  end;
end;

procedure TFormOutDepotMgr.Btn1Click(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.EdtBarCodeKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lAdoQuery: TADOQuery;
begin
  if Key = 13 then
  begin
    if EdtBarCode.Text = '' then
    begin
      Application.MessageBox('条形码为空！','提示',MB_OK+64);
      Exit;
    end;
    lAdoQuery:= TADOQuery.Create(nil);
    with lAdoQuery do
    begin
      try
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT Repertory.*, DEPOT.DEPOTNAME, Goods1.GoodsTypeName, Goods.GoodsName, Goods1.ProviderName, ' +
                   ' Goods1.CostPrice, Goods1.SalePrice, Goods1.Percent ' +
                   ' FROM (Repertory ' +
                   ' LEFT JOIN DEPOT ON DEPOT.DEPOTID=Repertory.DEPOTID)' +
                   ' LEFT JOIN (SELECT Goods.*, GoodsType.Percent, GoodsType.GoodsTypeName, Provider.ProviderName' +
                   '              FROM (Goods ' +
                   '              LEFT JOIN GoodsType ON GoodsType.GoodsTypeID=Goods.GoodsTypeID)' +
                   '              LEFT JOIN Provider ON Provider.ProviderID=Goods.ProviderID ' +
                   '           ) AS Goods1 ON Goods1.GoodsID=Repertory.GoodsID' +
                   ' where Goods1.BarCode=''' + Trim(EdtBarCode.Text) + '''';
        Active:= True;
        if RecordCount=1 then
        begin
          FDepotID:= FieldByName('DepotID').AsInteger;
          FGoodsID:= FieldByName('GoodsID').AsInteger;
          FGoodsTotalNum:= FieldByName('GoodsNum').AsInteger; //商品库存总数量，用于判断出库数量是否小于库存
          FSalePrice:= FieldByName('SalePrice').AsFloat; //商品销售单价
          FPercent:= FieldByName('Percent').AsFloat;     //营业员提成比例
          EdtGoodsID.Text:= FieldByName('GoodsID').AsString;
          EdtGoodsType.Text:= FieldByName('GoodsTypeName').AsString;
          EdtGoodsName.Text:= FieldByName('GoodsName').AsString;
          EdtDepotName.Text:= FieldByName('DepotName').AsString;
          EdtProvider.Text:= FieldByName('ProviderName').AsString;
          EdtCostPrice.Text:= FloatToStr(FSalePrice);
          EdtOutDepotNum.SetFocus;
        end
        else if RecordCount=0 then
        begin
          Application.MessageBox('此条形码的商品不存在或已无库存，请重新输入！','提示',MB_OK+64);
          EdtBarCode.Clear;
          EdtBarCode.SetFocus;
        end
        else if RecordCount>1 then
        begin
          Application.MessageBox('此条形码的商品存于多个仓库，请把同类商品入库到一个库存！','提示',MB_OK+64);
          EdtBarCode.Clear;
          EdtBarCode.SetFocus;
        end;;

      finally
        lAdoQuery.Free;
      end;
    end;
  end;
end;

procedure TFormOutDepotMgr.BtnGoodsSearchClick(Sender: TObject);
begin  
  with TFormGoodsSearch.Create(nil) do
  begin
    try
      if ShowModal = mrOK then
      begin
        EdtBarCode.Text:= BarCode;
        EdtBarCode.SelectAll;
//        EdtBarCode.OnKeyDown(nil,13,[]);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TFormOutDepotMgr.BtnCustomerSearchClick(Sender: TObject);
begin
  with TFormCustomerSearch.Create(nil) do
  begin
    try
      if ShowModal = mrOK then
      begin
        EdtCustomerID.Text:= CustomerID;
        EdtCustomerID.SelectAll;
//        EdtBarCode.OnKeyDown(nil,13,[]);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TFormOutDepotMgr.EdtDiscountKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13,#46]) then
  begin
    Key := #0;
  end;
end;

procedure TFormOutDepotMgr.EdtCustomerIDKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lAdoQuery: TADOQuery;
begin
  if Key = 13 then
  begin
    if EdtCustomerID.Text = '' then
    begin
      Application.MessageBox('客户编号为空！','提示',MB_OK+64);
      Exit;
    end;
    lAdoQuery:= TADOQuery.Create(nil);
    with lAdoQuery do
    begin
      try
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'SELECT Customer.*, AssociatorType.AssociatorTypeName, AssociatorType.Discount ' +
                   ' FROM Customer ' +
                   ' LEFT JOIN AssociatorType ' +
                   ' ON AssociatorType.AssociatorTypeID=Customer.CustomerAssociatorTypeID' +
                   ' WHERE Customer.CustomerID=' + Trim(EdtCustomerID.Text);
        Active:= True;
        if RecordCount=1 then
        begin
          ISExsitCustomer:= True;
          FCustomerID:= FieldByName('CustomerID').AsInteger;
          FDiscount:= FieldByName('Discount').AsFloat;
          EdtCustomerName.Text:= FieldByName('CustomerName').AsString;
          EdtAssociatorType.Text:= FieldByName('AssociatorTypeName').AsString;
          EdtDiscount.Text:= FloatToStr(FDiscount);
          EdtIntegral.Text:= FieldByName('CustomerIntegral').AsString;
          GetCustomerOutDepotSummary;
          EdtBarCode.Clear;
          EdtBarCode.SetFocus;
        end
        else
        begin
          ISExsitCustomer:= False;
          EdtCustomerID.Clear;
          EdtCustomerID.SetFocus;
        end;

      finally
        lAdoQuery.Free;
      end;
    end;
  end;
end;

procedure TFormOutDepotMgr.EdtOutDepotNumKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  lNum: Integer;
  lSaleMoney: Double;
begin
  if Key=13 then
  begin
    if EdtOutDepotNum.Text='' then
    begin
      Application.MessageBox(PChar('出库数量不能为空！'),'提示',MB_OK+64);
      Exit;
    end;
    if StrToInt(EdtOutDepotNum.Text)<=0 then
    begin
      Application.MessageBox(PChar('出库数量不正确！'),'提示',MB_OK+64);
      Exit;
    end;
    if StrToInt(EdtOutDepotNum.Text)>FGoodsTotalNum then
    begin
      Application.MessageBox(PChar('现库存有此商品'+inttostr(FGoodsTotalNum)+'，不够要求出库数量！'),'提示',MB_OK+64);
      Exit;
    end;
    //lOrderID:= GetID('OrderBH', 'OutDepotSummary');
    EdtBarCode.Clear;
    EdtBarCode.SetFocus;
//    if GetItemCode(CbbOutDepotType.Text, CbbOutDepotType.Items)=1001 then //如果是零售出库
    with FAdoEdit do
    begin
      try
        lNum:= StrToInt(EdtOutDepotNum.Text);
        lSaleMoney:= lNum*FSalePrice;
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'insert into OutDepotDetails(' +
                   'OrderBH,' +
                   'DepotID,' +
                   'GoodsID,' +
                   'UserID,' +
                   'OutDepotTypeID,' +
                   'Num,' +
                   'SaleMoney,' +
                   'CreateTime) ' +
                   'Values(''' +
                   FOrderID + ''',' +
                   IntToStr(FDepotID) + ',' +
                   IntToStr(FGoodsID) + ',' +
                   IntToStr(CurUser.UserID) + ',' +
                   IntToStr(GetItemCode(CbbOutDepotType.Text, CbbOutDepotType.Items)) + ',' +
                   EdtOutDepotNum.Text + ',' +
                   FloatToStr(lSaleMoney) + ',' +
                   'cdate(''' + DateTimeToStr(Now) + ''')' +
                   ')';
//          SQL.Text:= 'insert into OutDepotDetails(OrderBH,DepotID,GoodsID,UserID,OutDepotTypeID,Num,SaleMoney,CreateTime) ' +
//                     'Values(:BH,:DepotID,:GoodsID,:UserID,:OutDepotTypeID,:Num,:SaleMoney,:CreateTime)';
//          Parameters.ParamByName('BH').DataType:= ftString;
//          Parameters.ParamByName('BH').Direction:=pdInput;
//          Parameters.ParamByName('DepotID').DataType:= ftInteger;
//          Parameters.ParamByName('DepotID').Direction:=pdInput;
//          Parameters.ParamByName('GoodsID').DataType:=ftInteger;
//          Parameters.ParamByName('UserID').DataType:=ftInteger;
//          Parameters.ParamByName('OutDepotTypeID').DataType:= ftInteger;
//          Parameters.ParamByName('Num').DataType:= ftInteger;
//          Parameters.ParamByName('SaleMoney').DataType:= ftFloat;
//          Parameters.ParamByName('CreateTime').DataType:= ftDateTime;
//
//          Parameters.ParamByName('BH').Value:= FOrderID;
//          Parameters.ParamByName('DepotID').Value:= FDepotID;
//          Parameters.ParamByName('GoodsID').Value:= FGoodsID;
//          Parameters.ParamByName('UserID').Value:= CurUser.UserID;
//          Parameters.ParamByName('OutDepotTypeID').Value:= GetItemCode(CbbOutDepotType.Text, CbbOutDepotType.Items);
//          Parameters.ParamByName('Num').Value:= lNum;
//          Parameters.ParamByName('SaleMoney').Value:= lSaleMoney;
//          Parameters.ParamByName('CreateTime').Value:= Now; //'cdate(''' + DateTimeToStr(Now) + ''')'
        ExecSQL;
        GetOutDepotDetails(FAdoQueryDetail, DSDetail, FOrderID);
      finally
      end;
    end;
    BtnSubmit.Enabled:= True;
  end;
end;

procedure TFormOutDepotMgr.EdtOutDepotNumKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13]) then
  begin
    Key := #0;
  end;
end;

procedure TFormOutDepotMgr.GetOutDepotDetails(aAdoQuery: TADOQuery; Ds: TDataSource; aOrderBH: string);
begin
  with aAdoQuery do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'SELECT OutDepotDetails.*, DEPOT.DEPOTNAME,' +
                 '        Goods1.BarCode, Goods1.GoodsTypeName, Goods.GoodsName, Goods1.ProviderName,' +
                 '        Goods1.CostPrice, Goods1.SalePrice, Goods1.Percent,' +
                 '        User.UserName, OutDepotType.OutDepotTypeName' +
                 ' FROM (((OutDepotDetails  LEFT JOIN DEPOT ON DEPOT.DEPOTID=OutDepotDetails.DEPOTID)' +
                 ' LEFT JOIN OutDepotType ON OutDepotType.OutDepotTypeID=OutDepotDetails.OutDepotTypeID)' +
                 ' LEFT JOIN User ON User.UserID=OutDepotDetails.UserID)' +
                 ' LEFT JOIN (SELECT Goods.*, GoodsType.Percent, GoodsType.GoodsTypeName, Provider.ProviderName' +
                 '              FROM (Goods' +
                 '              LEFT JOIN GoodsType ON GoodsType.GoodsTypeID=Goods.GoodsTypeID)' +
                 '              LEFT JOIN Provider ON Provider.ProviderID=Goods.ProviderID' +
                 '             ) AS Goods1 ON Goods1.GoodsID=OutDepotDetails.GoodsID' +
                 ' where OutDepotDetails.OrderBH=''' + aOrderBH + '''' +
                 ' Order by OutDepotDetails.CreateTime';
      Active:= True;
      Ds.DataSet:= aAdoQuery;
    finally
    end;
  end;
end;

procedure TFormOutDepotMgr.GetCustomerOutDepotSummary;
begin
  with FAdoQueryHistory do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'SELECT OutDepotSummary.*, USER.USERNAME, CUSTOMER1.CustomerName,CUSTOMER1.CustomerIntegral, CUSTOMER1.AssociatorTypeName, CUSTOMER1.Discount' +
                 ' FROM (OutDepotSummary' +
                 ' LEFT JOIN USER ON USER.USERID = OutDepotSummary.USERID)' +
                 ' LEFT JOIN (SELECT Customer.*, AssociatorType.AssociatorTypeName, AssociatorType.Discount' +
                 '              FROM Customer' +
                 '             LEFT JOIN AssociatorType ON AssociatorType.AssociatorTypeID=Customer.CustomerAssociatorTypeID' +
                 '            ) AS Customer1' +
                 '      ON CUSTOMER1.CustomerID = OutDepotSummary.CustomerID' +
                 ' WHERE OutDepotSummary.CustomerID=' + IntToStr(FCustomerID) + 
                 ' Order by OutDepotSummary.OrderBH, OutDepotSummary.CreateTime';
      Active:= True;
      DSHistory.DataSet:= FAdoQueryHistory;
    finally
    end;
  end;
end;

procedure TFormOutDepotMgr.cxGridHistoryTableView1DataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  lOrderBh_Index: Integer;
  lOrderBH: string;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  try
    lOrderBh_Index:=cxGridHistoryTableView1.GetColumnByFieldName('OrderBH').Index;
    lOrderBH:= cxGridHistoryTableView1.DataController.GetValue(ARecordIndex,lOrderBh_Index);
  except
    Application.MessageBox('未获得"流水号"关键字！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  GetOutDepotDetails(FAdoQueryHistoryDetail, DSHistoryDetail, lOrderBH);
end;

end.
