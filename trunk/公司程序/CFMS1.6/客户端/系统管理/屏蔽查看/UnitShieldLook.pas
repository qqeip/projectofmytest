unit UnitShieldLook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, DBClient, CxGridUnit, UDevExpressToChinese,
  StdCtrls, jpeg, ExtCtrls, cxLookAndFeelPainters, ComCtrls, cxTextEdit,
  cxLabel, Buttons, cxTreeView, cxContainer, cxGroupBox, Menus, ImgList,
  cxButtons;

type
  TNodeType = (PROVINCE,  //0  省
               CITY,      //1  地市
               TOWN,      //2  行政区 杭州市区
               SUBURB,    //3  分局   西湖分局
               Company,   //4  维护单位
               Device      //5  设备
               );
  TNodeParam = class(Tobject)
  public
    NodeType     :TNodeType;
    Cityid       :integer;    //城市编号
    CompanyID    :integer;   //维护单位编号
    TownID       :integer;    //行政区编号
    SuburbID     :integer;    //分局编号
    DevID        :Integer;
    AlarmID      :integer; //告警编号
    ParentID     :integer;    // 父节点编号
    HaveExpanded :boolean;  //是否已经展开
    DisplayName  :string;    //显示名称 ，如 全网
  end;

type
  TFormShieldLook = class(TForm)
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet2: TClientDataSet;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    cxGroupBoxTree: TcxGroupBox;
    cxTreeViewRes: TcxTreeView;
    cxGroupBox8: TcxGroupBox;
    SpeedButtonSearch: TSpeedButton;
    SpeedButtonNext: TSpeedButton;
    cxLabel3: TcxLabel;
    cxTextEditSearch: TcxTextEdit;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    Panel2: TPanel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1DBTableView2: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1Level2: TcxGridLevel;
    cxGroupBox1: TcxGroupBox;
    cxButton1: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxGrid1DBTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure N1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButton1Click(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    MenuItem_Synchro : TMenuItem;
    procedure ShowBTSInfo(aCityID,aDevID: Integer);
    procedure ShowDevInfo(aCityID: Integer);
    procedure AddAreaNode(aTreeView: TcxTreeView; aLevel: Integer);
    procedure AddTreeViewNode(aTreeView: TcxTreeView; aNodeType: TNodeType;
      aID, aTOP_ID, aLAYER: Integer; aNAME: string);
    procedure LoadTreeInfo(aTreeView: TcxTreeView);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure GetCompanyInfo(aNode: TTreeNode);
    procedure GetTownInfo(aNode: TTreeNode);
    procedure GetSuburbInfo(aNode: TTreeNode);
    procedure GetDeviceInfo(aNode: TTreeNode);
    procedure SynchroDevStateOnClickEvent(Sender: TObject);
    procedure OnGridPopup(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormShieldLook: TFormShieldLook;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormShieldLook.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);
//  MenuItem_Synchro := FCxGridHelper.AppendMenuItem('基站状态同步',SynchroDevStateOnClickEvent);
  cxTreeViewRes.OnExpanding:= TreeViewExpanding;
  TPopupMenu(cxGrid1.PopupMenu).OnPopup:= OnGridPopup;
end;

procedure TFormShieldLook.FormShow(Sender: TObject);
begin
  AddCategory(cxGrid1DBTableView1,gPublicParam.cityid,gPublicParam.userid,6);
  AddCategory(cxGrid1DBTableView2,gPublicParam.cityid,gPublicParam.userid,7);
  ShowDevInfo(gPublicParam.cityid);
  LoadTreeInfo(cxTreeViewRes); //加载树图
end;

procedure TFormShieldLook.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormShieldLook,1,'','');
end;

procedure TFormShieldLook.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormShieldLook.cxGrid1DBTableView1DataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  lDevID, lBTSID: Integer;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  try
    lBTSID:=cxGrid1DBTableView1.GetColumnByFieldName('btsid').Index; //btsid其实对应内部的deviceid
    lDevID:= cxGrid1DBTableView1.DataController.GetValue(ARecordIndex,lBTSID);
  except
    Application.MessageBox('未获得关键字段CITYID,COMPANYID,BATCHID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  ShowBTSInfo(gPublicParam.cityid,lDevID);
end;

procedure TFormShieldLook.ShowBTSInfo(aCityID,aDevID: Integer);
var
   lstr: string;
begin
  DataSource2.DataSet:= nil;
  try
    with ClientDataSet2 do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,213,aCityID,aDevID]),0);
    end;
  finally

  end;
  DataSource2.DataSet:= ClientDataSet2;
  lstr:= cxGrid1DBTableView2.DataController.DataSource.DataSet.Name;
  cxGrid1DBTableView2.ApplyBestFit();
end;

procedure TFormShieldLook.ShowDevInfo(aCityID: Integer);
begin
  DataSource1.DataSet:= nil;
  try
    with ClientDataSet1 do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,212,aCityID]),0);
    end;
  finally
  
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

  {   增加树图   }

procedure TFormShieldLook.LoadTreeInfo(aTreeView: TcxTreeView);
begin
  AddAreaNode(aTreeView,0);  // 0：添加省份;
  AddAreaNode(aTreeView,1);  // 1：添加添加城市;
end;

procedure TFormShieldLook.AddAreaNode(aTreeView: TcxTreeView;aLevel: Integer);
var
  lClientDataSet: TClientDataSet;
  lNodeType: TNodeType;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,7]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        if aLevel=0 then
          lNodeType:= PROVINCE;
        if aLevel=1 then
          lNodeType:= CITY;
        if FieldByName('LAYER').AsInteger=aLevel then
        AddTreeViewNode(cxTreeViewRes,
                        lNodeType,
                        FieldByName('ID').AsInteger,
                        FieldByName('TOP_ID').AsInteger,
                        FieldByName('LAYER').AsInteger,
                        FieldByName('NAME').AsString
                        );
        Next;
      end;
    end;
    aTreeView.Items[0].Expanded:=True;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormShieldLook.AddTreeViewNode(aTreeView: TcxTreeView; aNodeType: TNodeType;
   aID,aTOP_ID,aLAYER:Integer;aNAME:string);
var
  lNodeParam: TNodeParam;
  lNewNode,lParentNode : TTreeNode;
  function GetParentNode(aLevel,aParent: Integer):TTreeNode;
  var
    lTempNode: TTreeNode;
  begin
    result:=nil;
    if alevel=0 then Exit;
    with aTreeView.Items do
    begin
      lTempNode:= GetFirstNode;
      if lTempNode=nil then exit;
      while lTempNode<>nil do
      begin
        if TNodeParam(lTempNode.Data).cityid=aParent then
        begin
          result:=lTempNode;
          Break;
        end;
        lTempNode:=lTempNode.getNext;
      end;
    end;
  end;
begin
  lNodeParam:= TNodeParam.Create;
  lNodeParam.nodeType:= aNodeType;
  lNodeParam.cityid:= aID;
  lNodeParam.Parentid:= aTOP_ID;
  lNodeParam.CITYID:= aID;
  lNodeParam.DisplayName:= aNAME;
  lParentNode:= GetParentNode(aLAYER,aTOP_ID);
  lNewNode:= aTreeView.Items.AddChildObject(lParentNode,lNodeParam.DisplayName,lNodeParam);
  lNewNode.ImageIndex:=0;
  if aNodeType= CITY then
    aTreeView.Items.AddChild(lNewNode,'temp');
end;

procedure TFormShieldLook.TreeViewExpanding(Sender: TObject; Node: TTreeNode; var AllowExpansion: Boolean);
var
  i : integer;
  limageIndex: Integer;
begin
  if node.Level=0 then exit;
  Screen.Cursor := crHourGlass ;
  case TNodeParam(Node.Data).nodeType of
    CITY:    //  1 代表市
      If TNodeParam(node.Data).HaveExpanded=false then
      begin
        Node.DeleteChildren;
        GetCompanyInfo(Node);   //添加维护单位
      end;
    Company:      //4 维护单位
      If TNodeParam(node.Data).HaveExpanded=false then
      begin
        Node.DeleteChildren;
        GetTownInfo(Node);    // 添加行政区
      end;
    TOWN:      //2  行政区 杭州市区
      If TNodeParam(node.Data).HaveExpanded=false then
      begin
        Node.DeleteChildren;
        GetSuburbInfo(Node);  //添加分局
      end;
    SUBURB:    //3  分局   西湖分局
      If TNodeParam(node.Data).HaveExpanded=false then
      Begin
        Node.DeleteChildren;
        GetDeviceInfo(Node);
      end;
  end;
  Screen.Cursor := crDefault;
end;

//添加维护单位
procedure TFormShieldLook.GetCompanyInfo(aNode:TTreeNode);
var
  lClientDataSet: TClientDataSet;
  GatherNodeParam : TNodeParam;
  lTempNode: TTreeNode;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([101,7,TNodeParam(aNode.Data).cityid,gPublicParam.Companyid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        GatherNodeParam := TNodeParam.Create;
        GatherNodeParam.nodeType := Company;
        GatherNodeParam.HaveExpanded :=false;
        GatherNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        GatherNodeParam.CompanyID :=fieldbyname('COMPANYID').AsInteger ;
        GatherNodeParam.DisplayName :=trim(fieldbyname('COMPANYNAME').AsString);
        GatherNodeParam.Parentid := TNodeParam(aNode.Data).cityid;
        lTempNode:= cxTreeViewRes.Items.AddChildObject(aNode,GatherNodeParam.DisplayName,GatherNodeParam);
        lTempNode.ImageIndex:=1;
        cxTreeViewRes.Items.AddChild(lTempNode,'temp');
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

//添加行政区
procedure TFormShieldLook.GetTownInfo(aNode:TTreeNode);
var
  lClientDataSet: TClientDataSet;
  TownNodeParam : TNodeParam;
  lTempNode: TTreeNode;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,268,TNodeParam(aNode.Data).cityid,TNodeParam(aNode.Data).CompanyID]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        TownNodeParam := TNodeParam.Create;
        TownNodeParam.nodeType := TOWN;
        TownNodeParam.HaveExpanded :=false;
        TownNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        TownNodeParam.CompanyID:=TNodeParam(aNode.Data).CompanyID;
        TownNodeParam.townid :=fieldbyname('Townid').AsInteger ;
        TownNodeParam.DisplayName :=trim(fieldbyname('TownName').AsString);
        TownNodeParam.Parentid := TNodeParam(aNode.Data).CompanyID;
        lTempNode:= cxTreeViewRes.Items.AddChildObject(aNode,TownNodeParam.DisplayName,TownNodeParam);
        lTempNode.ImageIndex:=2;
        cxTreeViewRes.Items.AddChild(lTempNode,'temp');
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

//添加分局
procedure TFormShieldLook.GetSuburbInfo(aNode:TTreeNode);
var
  lClientDataSet: TClientDataSet;
  SuburbNodeParam : TNodeParam;
  lTempNode: TTreeNode;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,269,TNodeParam(aNode.Data).cityid,TNodeParam(aNode.Data).CompanyID,TNodeParam(aNode.Data).townid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        SuburbNodeParam := TNodeParam.Create;
        SuburbNodeParam.nodeType := SUBURB;
        SuburbNodeParam.HaveExpanded :=false;
        SuburbNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        SuburbNodeParam.CompanyID:=TNodeParam(aNode.Data).CompanyID;
        SuburbNodeParam.townid := TNodeParam(aNode.Data).townid;
        SuburbNodeParam.SUBURBid:= fieldbyname('SUBURBid').AsInteger;
        SuburbNodeParam.DisplayName :=trim(fieldbyname('SUBURBName').AsString);
        SuburbNodeParam.Parentid := TNodeParam(aNode.Data).townid;
        lTempNode:= cxTreeViewRes.Items.AddChildObject(aNode,SuburbNodeParam.DisplayName,SuburbNodeParam);
        lTempNode.ImageIndex:=3;
        cxTreeViewRes.Items.AddChild(lTempNode,'temp');
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormShieldLook.GetDeviceInfo(aNode:TTreeNode);
var
  lClientDataSet: TClientDataSet;
  DeviceNodeParam : TNodeParam;
  lTempNode: TTreeNode;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try    
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,270,TNodeParam(aNode.Data).cityid,TNodeParam(aNode.Data).CompanyID,TNodeParam(aNode.Data).townid,TNodeParam(aNode.Data).SUBURBid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        DeviceNodeParam := TNodeParam.Create;
        DeviceNodeParam.nodeType := Device;
        DeviceNodeParam.HaveExpanded :=false;
        DeviceNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        DeviceNodeParam.CompanyID:=TNodeParam(aNode.Data).CompanyID;
        DeviceNodeParam.townid := TNodeParam(aNode.Data).townid;
        DeviceNodeParam.SUBURBid:= TNodeParam(aNode.Data).SUBURBid;
        DeviceNodeParam.Devid:=fieldbyname('BTSID').AsInteger;
        DeviceNodeParam.DisplayName :=trim(fieldbyname('bts_name').AsString);
        DeviceNodeParam.Parentid := TNodeParam(aNode.Data).townid;
        lTempNode:= cxTreeViewRes.Items.AddChildObject(aNode,DeviceNodeParam.DisplayName,DeviceNodeParam);
        lTempNode.ImageIndex:= 4;
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormShieldLook.N1Click(Sender: TObject);
var
  lNode : TTreeNode;
  lGather_SqlStr, lArea_SqlStr : String;
begin
  lNode := cxTreeViewRes.Selected;
  if (lNode=nil) or (lNode.Data=nil) then
  begin
    application.MessageBox('获取树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  DataSource1.DataSet:= nil;
  ClientDataSet1:= TClientDataSet.Create(nil);
  ClientDataSet1.Close;
  ClientDataSet1.ProviderName:= 'DataSetProvider';

  case  TNodeParam(lNode.Data).nodeType of
    PROVINCE:
    begin
       ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,271,'a.cityid in (select id from pop_area where top_id=' + inttostr(TNodeParam(lNode.Data).cityid) + ')']),0);
    end;
    CITY:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,271,'a.cityid='+inttostr(TNodeParam(lNode.Data).cityid)]),0);
    end;
    Company:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,271,'a.cityid='+inttostr(TNodeParam(lNode.Data).cityid)+' and companyid='+inttostr(TNodeParam(lNode.Data).CompanyID)]),0);
    end;
    TOWN:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,271,'townid='+inttostr(TNodeParam(lNode.Data).townid)+' and companyid='+inttostr(TNodeParam(lNode.Data).CompanyID)]),0)
    end;
    SUBURB:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,271,'SUBURBid='+inttostr(TNodeParam(lNode.Data).SUBURBid)+' and companyid='+inttostr(TNodeParam(lNode.Data).CompanyID)]),0)
    end;
    Device:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,271,'btsid='+inttostr(TNodeParam(lNode.Data).DevID)+' and companyid='+inttostr(TNodeParam(lNode.Data).CompanyID)]),0)
    end;
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormShieldLook.OnGridPopup(Sender: TObject);
var
  lIsSynchro: Integer;
begin// 同步字段
//  lIsSynchro:= ClientDataSet2.FieldByName('StatCompare').AsInteger;
//  if lIsSynchro=0 then
//    MenuItem_Synchro.Enabled:= True
//  else
//    MenuItem_Synchro.Enabled:= False;
end;

procedure TFormShieldLook.SynchroDevStateOnClickEvent(Sender: TObject);  //基站状态同步
begin
//
end;

procedure TFormShieldLook.cxButton1Click(Sender: TObject);
var
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  try
    Screen.Cursor:= crHourGlass;
    lVariant:= VarArrayCreate([0,1],varVariant);
    lSqlstr:= 'update alarm_device_info a' +
              ' set a.bts_state=(select b.bts_state from fms_device_info b' +
              ' where a.cityid=b.cityid and a.deviceid=b.deviceid)' +
              ' where exists (select 1 from fault_shield_view c' +
              ' where a.cityid=c.cityid and a.deviceid=c.BTSID)' +
              ' and exists (select 1 from fms_device_info d' +
              ' where a.cityid=d.cityid and a.deviceid=d.deviceid and a.bts_state<>d.bts_state)' +
              ' and a.cityid=' + IntToStr(gPublicParam.cityid);

    lVariant[0]:= VarArrayOf([lSqlstr]);
    lSqlstr:= 'update alarm_cell_device_info a' +
              ' set a.cell_state=(select b.cell_state from fms_cell_device_info b' +
              ' where a.cityid=b.cityid and a.bts_label=b.bts_label and a.fan_id=b.fan_id)' +
              ' where exists (select 1 from fault_shield_view c' + 
              ' where a.cityid=c.cityid and a.bts_label=c.BTSID and a.fan_id=c.codeviceid)' +
              ' and exists (select 1 from alarm_cell_device_info d' +
              ' where a.cityid=d.cityid and a.bts_label=d.bts_label and a.fan_id=d.fan_id and a.cell_state<>d.cell_state)' +
              ' and a.cityid=' + IntToStr(gPublicParam.cityid);
    lVariant[1]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
      Application.MessageBox('同步成功','提示',MB_OK+64)
    else
      Application.MessageBox('同步失败','提示',MB_OK+64);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

end.
