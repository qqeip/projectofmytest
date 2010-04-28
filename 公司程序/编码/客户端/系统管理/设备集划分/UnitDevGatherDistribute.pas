{设备集规划用到得表：
 1、设备集设备对应明细表（FMS_DEVICEGATHER_DETAIL） 存放已规划设备集和设备对应的对应关系。
 2、设备表（基站）（FMS_DEVICE_INFO） CDMA中设备只分为基站、小区 本模块只用基站设备。
 功能要求：
 已规划设备树、未规划设备树，存在于表 FMS_DEVICEGATHER_DETAIL中的未已规划设备树。
 不存在于此表中的设备为未规划设备树。
 可以对已规划和未规划的设备进行查询设备明细。
 设备集挂在城市下，设备集下挂地区，叶子节点放设备。
 界面有模糊查询的条件。

 }
unit UnitDevGatherDistribute;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, ComCtrls, cxTreeView, ExtCtrls,
  cxControls, cxContainer, cxEdit, cxGroupBox, DBClient, cxPC, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, DB, cxDBData,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, CxGridUnit,
  cxGridTableView, cxGridDBTableView, cxGrid, Menus, cxCheckBox, StdCtrls,
  cxButtons, cxTextEdit, cxMaskEdit, cxDropDownEdit, jpeg, StringUtils,
  UDevExpressToChinese, ImgList;

type
  TNodeType = (PROVINCE,  //0  省
               CITY,      //1  地市
               TOWN,      //2  行政区 杭州市区
               SUBURB,    //3  分局   西湖分局
               BRANCH,    //4  支局   翠苑支局
               Gather,     //5 设备集
               Device     //6  设备
               );

  TNodeParam = class(Tobject)
  public
    nodeType   :TNodeType;
    cityid     :integer;  //城市编号
    GatherID   :integer;  //设备集编号
    townid     :integer;  //行政区编号
    SUBURBid   :integer;  //分局编号
    Branchid   :integer;  //支局编号
    Deviceid      :integer;  //设备编号
    Parentid   :integer;
    HaveExpanded :boolean;//是否已经展开
    DisplayName :string;   //显示名称 ，如 全网
  end;

type
  TFormDevGatherDistribute = class(TForm)
    Panel1: TPanel;
    cxGroupBox1: TcxGroupBox;
    Splitter1: TSplitter;
    cxGroupBox2: TcxGroupBox;
    Panel2: TPanel;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    PopupMenu1: TPopupMenu;
    NAdd: TMenuItem;
    NModify: TMenuItem;
    NDel: TMenuItem;
    N4: TMenuItem;
    NShow: TMenuItem;
    Splitter2: TSplitter;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet2: TClientDataSet;
    cxTreeViewPlanDev: TTreeView;
    cxTreeViewNoPlanDev: TTreeView;
    PopupMenu2: TPopupMenu;
    N_ShowUnplan: TMenuItem;
    cxGroupBox3: TcxGroupBox;
    cxCheckBoxDevCaption: TcxCheckBox;
    cxCheckBoxBTSID: TcxCheckBox;
    cxCheckBoxAgent: TcxCheckBox;
    cxCheckBoxArea: TcxCheckBox;
    cxBtnQuery: TcxButton;
    cxComboBoxNetState: TcxComboBox;
    cxCheckBoxNetState: TcxCheckBox;
    cxTextEditDevCaption: TcxTextEdit;
    cxTextEditBtsID: TcxTextEdit;
    Panel3: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxGrid2Level1: TcxGridLevel;
    cxGrid2: TcxGrid;
    cxComboBoxArea: TcxComboBox;
    cxComboBoxAgent: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure NShowClick(Sender: TObject);
    procedure cxTreeViewPlanDevDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxTreeViewPlanDevDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure cxTreeViewPlanDevMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxTreeViewNoPlanDevDragOver(Sender, Source: TObject; X,
      Y: Integer; State: TDragState; var Accept: Boolean);
    procedure cxTreeViewNoPlanDevDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure N_ShowUnplanClick(Sender: TObject);
    procedure cxGrid2DBTableView1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxBtnQueryClick(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    procedure AddAreaNode(aTreeView: TTreeView);overload;
    procedure AddAreaNode(aTreeView: TTreeView; aLevel: Integer); overload;
    procedure AddTreeViewNode(aTreeView: TTreeView; aID, aTOP_ID, aLAYER: Integer; aNAME: string); overload;
    procedure AddTreeViewNode(aTreeView: TTreeView; aNodeType: TNodeType; aID, aTOP_ID, aLAYER: Integer; aNAME: string); overload;
    procedure LoadPlanDevTree(aTreeView: TTreeView);
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure GetGatherInfo(aNode: TTreeNode);
    procedure GetTownInfo(aNode: TTreeNode);
    procedure GetSuburbInfo(aNode: TTreeNode);
    procedure GetBranchInfo(aNode: TTreeNode);
    procedure GetDeviceInfo(aNode: TTreeNode);
    procedure SetTitle;
    function GetAreaChildLeaf(aAreaid: integer): string;
    function GetWhereStr: string;
    procedure LoadCSStatus(abox:TcxComboBox; aCity: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDevGatherDistribute: TFormDevGatherDistribute;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormDevGatherDistribute.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);
  FCxGridHelper.SetGridStyle(cxGrid2,true,false,true);
  cxTreeViewPlanDev.OnExpanding := TreeViewExpanding;
end;

procedure TFormDevGatherDistribute.FormShow(Sender: TObject);
begin
  SetTitle;
  LoadPlanDevTree(cxTreeViewPlanDev);
  cxTreeViewNoPlanDev.Items.Clear;
  AddAreaNode(cxTreeViewNoPlanDev);  //添加未规划树
  LoadCSStatus(cxComboBoxNetState,gPublicParam.cityid);//基站在网状体下拉框添加内容
  GetDicItem(gPublicParam.cityid,1005,cxComboBoxArea.Properties.Items);//代维区域下拉框加内容
  GetDicItem(gPublicParam.cityid,1003,cxComboBoxAgent.Properties.Items);//代维区域下拉框加内容
end;

procedure TFormDevGatherDistribute.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormDevGatherDistribute,1,'','');
end;

procedure TFormDevGatherDistribute.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormDevGatherDistribute.SetTitle;
begin
  AddViewField(cxGrid1DBTableView1,'DEVICEID','设备编号');
  AddViewField(cxGrid1DBTableView1,'CSID','内部编号');
  AddViewField(cxGrid1DBTableView1,'bts_name','设备名称');
  AddViewField(cxGrid1DBTableView1,'btsstatename','在网状态');
  AddViewField(cxGrid1DBTableView1,'agent_manu','代维公司');
  AddViewField(cxGrid1DBTableView1,'iron_tower_kind','代维区域');

  AddViewField(cxGrid2DBTableView1,'BTSID','设备编号');
  AddViewField(cxGrid2DBTableView1,'CSID','内部编号');
  AddViewField(cxGrid2DBTableView1,'bts_name','设备名称');
  AddViewField(cxGrid2DBTableView1,'btsstatename','在网状态');
  AddViewField(cxGrid2DBTableView1,'agent_manu','代维公司');
  AddViewField(cxGrid2DBTableView1,'iron_tower_kind','代维区域');
end;

procedure TFormDevGatherDistribute.LoadPlanDevTree(aTreeView: TTreeView);
begin
  AddAreaNode(aTreeView,0);  // 0：添加省份;
  AddAreaNode(aTreeView,1);  // 1：添加添加城市;
end;
//添加区域树节点
procedure TFormDevGatherDistribute.AddAreaNode(aTreeView: TTreeView;aLevel: Integer);
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
        AddTreeViewNode(cxTreeViewPlanDev,
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

procedure TFormDevGatherDistribute.AddTreeViewNode(aTreeView: TTreeView; aNodeType: TNodeType;
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
          lTempNode.ImageIndex:=7;
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
  if aNodeType= CITY then
    begin
        lNewNode.ImageIndex:=1;
        aTreeView.Items.AddChild(lNewNode,'temp');
    end;
    
end;

procedure TFormDevGatherDistribute.TreeViewExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
var
  i : integer;
  ChildNode : TTreeNode;
  limageIndex: Integer;
begin
  if node.Level=0 then exit;
  Screen.Cursor := crHourGlass ;
  case TNodeParam(Node.Data).nodeType of
    CITY:    //  1 代表市
      If TNodeParam(node.Data).HaveExpanded=false then
      begin
        Node.DeleteChildren;
        GetGatherInfo(Node);   //添加设备集
      end;
    Gather:      //12 设备集
      If TNodeParam(node.Data).HaveExpanded=false then
      begin
        Node.DeleteChildren;
        GetTownInfo(Node);    // 添加行政区
      end;
    TOWN:      //2  行政区 杭州市区
      If TNodeParam(node.Data).HaveExpanded=false then
      begin
        Node.DeleteChildren;
        GetSuburbInfo(Node);
      end;
//    SUBURB:    //3  分局   西湖分局
//      If TNodeParam(node.Data).HaveExpanded=false then
//      Begin
//        Node.DeleteChildren;
//        GetBranchInfo(Node);
//      end;
//    BRANCH:    //4  支局   翠苑支局
//      If TNodeParam(node.Data).HaveExpanded=false then
//      Begin
//        Node.DeleteChildren;
//        GetDeviceInfo(Node);
//      end;
//    Device:   //7  设备
//      If TNodeParam(node.Data).HaveExpanded=false then
//      begin
//        Node.DeleteChildren;
//      end;
  end;
  Screen.Cursor := crDefault;
end;

procedure TFormDevGatherDistribute.GetGatherInfo(aNode:TTreeNode);
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
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,11,TNodeParam(aNode.Data).cityid,gPublicParam.RuleCompanyidStr]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        GatherNodeParam := TNodeParam.Create;
        GatherNodeParam.nodeType := Gather;
        GatherNodeParam.HaveExpanded :=false;
        GatherNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        GatherNodeParam.GatherID :=fieldbyname('DEVICEGATHERID').AsInteger ;
        GatherNodeParam.DisplayName :=trim(fieldbyname('DEVICEGATHERNAME').AsString);
        GatherNodeParam.Parentid := TNodeParam(aNode.Data).cityid;
        lTempNode:= cxTreeViewPlanDev.Items.AddChildObject(aNode,GatherNodeParam.DisplayName,GatherNodeParam);
        lTempNode.ImageIndex:=2;
        cxTreeViewPlanDev.Items.AddChild(lTempNode,'temp');
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormDevGatherDistribute.GetTownInfo(aNode:TTreeNode);
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
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,17,TNodeParam(aNode.Data).cityid,TNodeParam(aNode.Data).GatherID]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        TownNodeParam := TNodeParam.Create;
        TownNodeParam.nodeType := TOWN;
        TownNodeParam.HaveExpanded :=false;
        TownNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        TownNodeParam.GatherID:=TNodeParam(aNode.Data).GatherID;
        TownNodeParam.townid :=fieldbyname('Townid').AsInteger ;
        TownNodeParam.DisplayName :=trim(fieldbyname('TownName').AsString);
        TownNodeParam.Parentid := TNodeParam(aNode.Data).GatherID;
        lTempNode:= cxTreeViewPlanDev.Items.AddChildObject(aNode,TownNodeParam.DisplayName,TownNodeParam);
        lTempNode.ImageIndex:=3;
        cxTreeViewPlanDev.Items.AddChild(lTempNode,'temp');
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

//GetSuburbInfo
procedure TFormDevGatherDistribute.GetSuburbInfo(aNode:TTreeNode);
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
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,18,TNodeParam(aNode.Data).cityid,TNodeParam(aNode.Data).GatherID,TNodeParam(aNode.Data).townid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        SuburbNodeParam := TNodeParam.Create;
        SuburbNodeParam.nodeType := SUBURB;
        SuburbNodeParam.HaveExpanded :=false;
        SuburbNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        SuburbNodeParam.GatherID:=TNodeParam(aNode.Data).GatherID;
        SuburbNodeParam.townid := TNodeParam(aNode.Data).townid;
        SuburbNodeParam.SUBURBid:= fieldbyname('SUBURBid').AsInteger;
        SuburbNodeParam.DisplayName :=trim(fieldbyname('SUBURBName').AsString);
        SuburbNodeParam.Parentid := TNodeParam(aNode.Data).townid;
        lTempNode:= cxTreeViewPlanDev.Items.AddChildObject(aNode,SuburbNodeParam.DisplayName,SuburbNodeParam);
//        cxTreeViewPlanDev.Items.AddChild(lTempNode,'temp');
        lTempNode.ImageIndex:=4;
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormDevGatherDistribute.GetBranchInfo(aNode:TTreeNode);
var
  lClientDataSet: TClientDataSet;
  BranchNodeParam : TNodeParam;
  lTempNode: TTreeNode;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,19,TNodeParam(aNode.Data).cityid,TNodeParam(aNode.Data).GatherID,TNodeParam(aNode.Data).townid,TNodeParam(aNode.Data).SUBURBid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        BranchNodeParam := TNodeParam.Create;
        BranchNodeParam.nodeType := BRANCH;
        BranchNodeParam.HaveExpanded :=false;
        BranchNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        BranchNodeParam.GatherID:=TNodeParam(aNode.Data).GatherID;
        BranchNodeParam.townid := TNodeParam(aNode.Data).townid;
        BranchNodeParam.SUBURBid:= TNodeParam(aNode.Data).SUBURBid;
        BranchNodeParam.Branchid:= fieldbyname('branch').AsInteger;
        BranchNodeParam.DisplayName :=trim(fieldbyname('branchName').AsString);
        BranchNodeParam.Parentid := TNodeParam(aNode.Data).townid;
        lTempNode:= cxTreeViewPlanDev.Items.AddChildObject(aNode,BranchNodeParam.DisplayName,BranchNodeParam);
//        cxTreeViewPlanDev.Items.AddChild(lTempNode,'temp');
        lTempNode.ImageIndex:=5;
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

//GetDeviceInfo
procedure TFormDevGatherDistribute.GetDeviceInfo(aNode:TTreeNode);
var
  lClientDataSet: TClientDataSet;
  DeviceNodeParam : TNodeParam;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,20,TNodeParam(aNode.Data).cityid,TNodeParam(aNode.Data).GatherID,TNodeParam(aNode.Data).townid,TNodeParam(aNode.Data).SUBURBid,TNodeParam(aNode.Data).Branchid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        DeviceNodeParam := TNodeParam.Create;
        DeviceNodeParam.nodeType := Device;
        DeviceNodeParam.HaveExpanded :=false;
        DeviceNodeParam.cityid :=TNodeParam(aNode.Data).cityid;
        DeviceNodeParam.GatherID:=TNodeParam(aNode.Data).GatherID;
        DeviceNodeParam.townid := TNodeParam(aNode.Data).townid;
        DeviceNodeParam.SUBURBid:= TNodeParam(aNode.Data).SUBURBid;
        DeviceNodeParam.Branchid:= TNodeParam(aNode.Data).Branchid;
        DeviceNodeParam.Deviceid:=fieldbyname('csid').AsInteger;
        DeviceNodeParam.DisplayName :=trim(fieldbyname('bts_name').AsString);
        DeviceNodeParam.Parentid := TNodeParam(aNode.Data).townid;
        cxTreeViewPlanDev.Items.AddChildObject(aNode,DeviceNodeParam.DisplayName,DeviceNodeParam);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormDevGatherDistribute.AddAreaNode(aTreeView: TTreeView);
var
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,214,gPublicParam.cityid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        AddTreeViewNode(aTreeView,
                        FieldByName('ID').AsInteger,
                        FieldByName('TOP_ID').AsInteger,
                        FieldByName('LAYER').AsInteger,
                        FieldByName('NAME').AsString
                        );
        Next;
      end;
    end;
    aTreeView.FullExpand;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormDevGatherDistribute.AddTreeViewNode(aTreeView: TTreeView; aID,aTOP_ID,aLAYER:Integer;aNAME:string);
var
  lAreaObject: TNodeParam;
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
          lTempNode.ImageIndex:=1;
          Break;
        end;
        lTempNode:=lTempNode.getNext;
      end;
    end;
  end;
begin
  lAreaObject:= TNodeParam.Create;
  lAreaObject.cityid:= aID;
  lAreaObject.Parentid:= aTOP_ID;
  lAreaObject.DisplayName:= aNAME;
  lParentNode:= GetParentNode(aLAYER,aTOP_ID);
  lNewNode:= aTreeView.Items.AddChildObject(lParentNode,lAreaObject.DisplayName,lAreaObject);
  lNewNode.ImageIndex:=4;
end;

procedure TFormDevGatherDistribute.NShowClick(Sender: TObject);
var
  lNode : TTreeNode;
  lGather_SqlStr, lArea_SqlStr : String;
begin
  lNode := cxTreeViewPlanDev.Selected;
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
       ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,215,TNodeParam(lNode.Data).cityid]),0);
    end;
    CITY:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,216,'cityid='+inttostr(TNodeParam(lNode.Data).cityid)]),0);
    end;
    Gather:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,216,'cityid='+inttostr(TNodeParam(lNode.Data).cityid)+' and devicegatherid='+inttostr(TNodeParam(lNode.Data).GatherID)]),0);
    end;
    TOWN:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,216,'townid='+inttostr(TNodeParam(lNode.Data).townid)+' and devicegatherid='+inttostr(TNodeParam(lNode.Data).GatherID)]),0)
    end;
    SUBURB:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,216,'SUBURBid='+inttostr(TNodeParam(lNode.Data).SUBURBid)+' and devicegatherid='+inttostr(TNodeParam(lNode.Data).GatherID)]),0)
    end;
    BRANCH:
    begin
      ClientDataSet1.Data:= gTempInterface.GetCDSData(VarArrayOf([1,216,'Branch='+inttostr(TNodeParam(lNode.Data).Branchid)+' and devicegatherid='+inttostr(TNodeParam(lNode.Data).GatherID)]),0)
    end;
  end;
  cxPageControl1.ActivePageIndex:=0;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormDevGatherDistribute.cxTreeViewPlanDevDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
   //Accept:= true
   //(Source = cxTreeViewNoPlanDev) or
  if (cxPageControl1.ActivePage=self.cxTabSheet2)
    and (Source is TcxDragControlObject) then
    //if (Source=cxGrid2DBTableView1) then
    Accept:= true
  else
    Accept:= false;  
end;

procedure TFormDevGatherDistribute.cxTreeViewPlanDevDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  i, lGatherID, lDevid_Index, lRecordIndex, lCount : Integer;
  lTargetNode, lSourceNode : TTreeNode;
  lAreaChildLeafStr: string;
  lClientDataSet: TClientDataSet;
  lVariant: variant;
  lSqlstr, lDevid: string;
  lsuccess: boolean;
  lActiveView: TcxGridDBTableView;
  lvariant1: Variant;
begin
  if (cxTreeViewPlanDev.DropTarget=nil) or (cxTreeViewPlanDev.DropTarget.Data=nil) then exit;
  screen.Cursor:=crHourGlass;
  try
    lGatherID:= TNodeParam(cxTreeViewPlanDev.DropTarget.Data).GatherID;
    if TNodeParam(cxTreeViewPlanDev.DropTarget.Data).NodeType = Gather then
    begin
      lTargetNode := cxTreeViewPlanDev.DropTarget;
      lTargetNode.Expanded:=false;
      if Source=cxTreeViewNoPlanDev then
      begin
        lSourceNode:= cxTreeViewNoPlanDev.Selected;
        if (lSourceNode=nil) or (lSourceNode.Data=nil) then exit;
        lAreaChildLeafStr:= GetAreaChildLeaf(TNodeParam(lSourceNode.Data).cityid);
        lClientDataSet:= TClientDataSet.create(nil);
        with lClientDataSet do
        begin
          Close;
          ProviderName:='dsp_General_data';
          Data:=gTempInterface.GetCDSData(VarArrayOf([1,218,lAreaChildLeafStr]),0);
          if RecordCount=0 then Exit;
          first;
          lVariant:= VarArrayCreate([0,lClientDataSet.RecordCount-1],varVariant);
          for i:=0 to RecordCount-1 do
          begin
            lSqlstr:= 'insert into FMS_DEVICEGATHER_DETAIL(CITYID,DEVICEGATHERID,DEVICEID) values(' +
                      IntToStr(gPublicParam.cityid) + ',' +
                      IntToStr(TNodeParam(lTargetNode.Data).GatherID) + ',' +
                      IntToStr(fieldbyname('deviceid').AsInteger) + ')';
            lVariant[i]:= VarArrayOf([lSqlstr]);
            next;
          end;
          lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
          if  lsuccess then
          begin
            application.MessageBox('规划成功！','提示',MB_OK + MB_ICONINFORMATION);
            lTargetNode.DeleteChildren;
            cxTreeViewPlanDev.Items.AddChild(lTargetNode,'TMP');
            TNodeParam(cxTreeViewPlanDev.DropTarget.Data).HaveExpanded:=false;
          end
          else
            application.MessageBox('规划失败！','提示',MB_OK + MB_ICONINFORMATION);
        end;
      end
       else
      //if Source= cxGrid2DBTableView1 then
      if Self.cxGrid2.CanFocus then
      begin
        lActiveView:=cxGrid2DBTableView1;
        if not CheckRecordSelected(lActiveView) then
        begin
          Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
          Exit;
        end;
        try
          lDevid_Index:=lActiveView.GetColumnByFieldName('BTSID').Index;
        except
          Application.MessageBox('未获得关键字段DeviceID！','提示',MB_OK	+MB_ICONINFORMATION);
          exit;
        end;
        Screen.Cursor := crHourGlass;
        lVariant:= VarArrayCreate([0,lActiveView.DataController.GetSelectedCount-1],varVariant);
        lCount:= 0;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lvariant1:= lActiveView.DataController.GetValue(lRecordIndex,lDevid_Index);
          lDevid:= VarAsType(lvariant1,varString);
          lSqlstr:= 'insert into FMS_DEVICEGATHER_DETAIL(CITYID,DEVICEGATHERID,DEVICEID) values(' +
                    IntToStr(gPublicParam.cityid) + ',' +
                    IntToStr(TNodeParam(lTargetNode.Data).GatherID) + ',' +
                    lDevid + ')';
          lVariant[lCount]:= VarArrayOf([lSqlstr]);
          Inc(lCount);
        end;
        lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
        if lsuccess then
        begin
          application.MessageBox('规划成功！','提示',MB_OK + MB_ICONINFORMATION);
          lActiveView.DataController.DeleteSelection;
          lTargetNode.Expanded:= False;
        end
        else
          application.MessageBox('规划失败，可能该设备重复规划！','提示',MB_OK + MB_ICONINFORMATION);
      end;
    end else
        application.MessageBox('请选择规划到设备集！','提示',MB_OK + MB_ICONINFORMATION);
  finally
    screen.Cursor:=crDefault;
    lClientDataSet.Free;
  end;
end;

procedure TFormDevGatherDistribute.cxTreeViewPlanDevMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if ( Button = mbLeft ) and ( htOnItem in cxTreeViewPlanDev.GetHitTestInfoAt( X, Y ) ) then
  begin
    cxTreeViewPlanDev.BeginDrag( False );
  end;
end;

function TFormDevGatherDistribute.GetAreaChildLeaf(aAreaid : integer):string;
var
  lClientDataSet: TClientDataSet;
  lAreaidStr: string;
begin
  lClientDataSet:= TClientDataSet.create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([1,217,aAreaid]),0);
      first;
      while not eof do
      begin
        lAreaidStr:= lAreaidStr+ FieldByName('id').AsString+ ',';
        next;
      end;
    end;
    result:= copy(lAreaidStr,1,length(lAreaidStr)-1);
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormDevGatherDistribute.cxTreeViewNoPlanDevDragOver(Sender,
  Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
//  if (Source = cxTreeViewPlanDev) then
    Accept:= true
//  else
//    Accept:= false;
end;

procedure TFormDevGatherDistribute.cxTreeViewNoPlanDevDragDrop(Sender,
  Source: TObject; X, Y: Integer);
var
  i, lDevid_Index, lRecordIndex, lGatherID, lCount: Integer;
  lSourceNode: TTreeNode;
  lClientDataSet: TClientDataSet;
  lVariant: variant;
  lSqlstr, lDevid: string;
  lsuccess, lIsDeviceNode: boolean;
  lActiveView: TcxGridDBTableView;
  lvariant1: Variant;
begin
  screen.Cursor:=crHourGlass;
  try
    if Source=cxTreeViewPlanDev then
    begin
      lSourceNode := cxTreeViewPlanDev.Selected;
      lIsDeviceNode:=false;
      if (lSourceNode=nil) or (lSourceNode.Data=nil) then Exit;
      lClientDataSet:= TClientDataSet.Create(nil);
      with lClientDataSet do
      begin
        Close;
        ProviderName:= 'DataSetProvider';
        case  TNodeParam(lSourceNode.Data).nodeType of
          PROVINCE:
          begin
             Data:= gTempInterface.GetCDSData(VarArrayOf([1,219,TNodeParam(lSourceNode.Data).cityid]),0);
          end;
          CITY:
          begin
            Data:= gTempInterface.GetCDSData(VarArrayOf([1,220,'cityid='+inttostr(TNodeParam(lSourceNode.Data).cityid)]),0);
          end;
          Gather:
          begin
            Data:= gTempInterface.GetCDSData(VarArrayOf([1,220,'cityid='+inttostr(TNodeParam(lSourceNode.Data).cityid)+' and devicegatherid='+inttostr(TNodeParam(lSourceNode.Data).GatherID)]),0);
          end;
          TOWN:
          begin
            Data:= gTempInterface.GetCDSData(VarArrayOf([1,220,'townid='+inttostr(TNodeParam(lSourceNode.Data).townid)+' and devicegatherid='+inttostr(TNodeParam(lSourceNode.Data).GatherID)]),0)
          end;
          SUBURB:
          begin
            Data:= gTempInterface.GetCDSData(VarArrayOf([1,220,'SUBURBid='+inttostr(TNodeParam(lSourceNode.Data).SUBURBid)+' and devicegatherid='+inttostr(TNodeParam(lSourceNode.Data).GatherID)]),0)
          end;
          BRANCH:
          begin
            Data:= gTempInterface.GetCDSData(VarArrayOf([1,220,'Branch='+inttostr(TNodeParam(lSourceNode.Data).Branchid)+' and devicegatherid='+inttostr(TNodeParam(lSourceNode.Data).GatherID)]),0)
          end;
          Device:
          begin
            Data:= gTempInterface.GetCDSData(VarArrayOf([1,220,'deviceid='+inttostr(TNodeParam(lSourceNode.Data).Deviceid)+' and devicegatherid='+inttostr(TNodeParam(lSourceNode.Data).GatherID)]),0);
            lIsDeviceNode:=True;
          end;
        end;
        if RecordCount=0 then Exit;
        First;
        lVariant:= VarArrayCreate([0,lClientDataSet.RecordCount-1],varVariant);
        for i:=0 to recordcount-1 do
        begin
          lSqlstr:= 'delete from FMS_DEVICEGATHER_DETAIL where CITYID=' +
                    IntToStr(gPublicParam.cityid) +
                    ' and DEVICEID=' +
                    IntToStr(fieldbyname('deviceid').AsInteger)+
                    ' and DEVICEGATHERID=' +
                    IntToStr(fieldbyname('devicegatherid').AsInteger);
          lVariant[i]:= VarArrayOf([lSqlstr]);
          next;
        end;
        lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
        if lsuccess then
        begin
          application.MessageBox('规划成功！','提示',MB_OK + MB_ICONINFORMATION);
          lSourceNode.Expanded:=false;
          //如果是设备节点，就删除该节点
          if lIsDeviceNode then
          begin
            lSourceNode.DeleteChildren;
            lSourceNode.Delete;
          end;
        end
        else
          application.MessageBox('规划失败，可能该设备重复规划！','提示',MB_OK + MB_ICONINFORMATION);
      end;
    end
    else
    //if Source= cxGrid1DBTableView1 then
    if Self.cxGrid1.CanFocus then
    begin
      lActiveView:=cxGrid1DBTableView1;
      if not CheckRecordSelected(lActiveView) then
      begin
        Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
        Exit;
      end;
      try
        lDevid_Index:=lActiveView.GetColumnByFieldName('DEVICEID').Index;
      except
        Application.MessageBox('未获得关键字段DeviceID！','提示',MB_OK	+MB_ICONINFORMATION);
        exit;
      end;
      Screen.Cursor := crHourGlass;
      lVariant:= VarArrayCreate([0,lActiveView.DataController.GetSelectedCount-1],varVariant);
      lCount:=0;
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
        lvariant1:= lActiveView.DataController.GetValue(lRecordIndex,lDevid_Index);
        lDevid:= VarAsType(lvariant1,varString);
        lSqlstr:=  'delete from FMS_DEVICEGATHER_DETAIL where CITYID=' +
                      IntToStr(gPublicParam.cityid) +
                      ' and DEVICEID=' +
                      lDevid;
        lVariant[lCount]:= VarArrayOf([lSqlstr]);
        Inc(lCount);
      end;
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if lsuccess then
      begin
        application.MessageBox('规划成功！','提示',MB_OK + MB_ICONINFORMATION);
        lActiveView.DataController.DeleteSelection;
  //      lTargetNode.Expanded:= False;
      end
      else
        application.MessageBox('规划失败，可能该设备重复规划！','提示',MB_OK + MB_ICONINFORMATION);
    end;
  finally
    screen.Cursor:=crDefault;
    lClientDataSet.Free;
  end;
end;

procedure TFormDevGatherDistribute.N_ShowUnplanClick(Sender: TObject);
var
  lNode : TTreeNode;
  lAreaChildLeafStr, lWhereStr : string;
begin
  lNode := cxTreeViewNoPlanDev.Selected;
  if (lNode=nil) or (lNode.Data=nil) then
  begin
    application.MessageBox('获取树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  DataSource2.DataSet:= nil;
  ClientDataSet2:= TClientDataSet.Create(nil);
  with ClientDataSet2 do
  begin
    Close;
    ProviderName:= 'DataSetProvider';
    lAreaChildLeafStr := GetAreaChildLeaf(TNodeparam(lNode.Data).cityid);
    lWhereStr:= ' and branch in (' + lAreaChildLeafStr + ')' + GetWhereStr;
    Data:= gTempInterface.GetCDSData(VarArrayOf([1,218,lWhereStr]),0)
  end;
  cxPageControl1.ActivePageIndex:=1;
  DataSource2.DataSet:= ClientDataSet2;
  cxGrid2DBTableView1.ApplyBestFit();
end;

procedure TFormDevGatherDistribute.cxGrid2DBTableView1MouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  if Button = mbLeft then
    cxGrid2.BeginDrag(True);
end;

function TFormDevGatherDistribute.GetWhereStr: string;
var
  lWhereStr: string;
begin
  if cxCheckBoxNetState.Checked then
  begin
    lWhereStr:= lWhereStr + ' and btsstatecode like ' + '''%' +IntToStr(GetDicCode(cxComboBoxNetState.Text,cxComboBoxNetState.Properties.Items)) + '%''';
  end;
  if cxCheckBoxDevCaption.Checked then
  begin
    lWhereStr:= lWhereStr + ' and bts_name like ' + '''%' + cxTextEditDevCaption.Text + '%''';
  end;
  if cxCheckBoxBTSID.Checked then
  begin
    lWhereStr:= lWhereStr + ' and btsid like ' + '''%' + cxTextEditBtsID.Text + '%''';
  end;
  if cxCheckBoxAgent.Checked then
  begin
    lWhereStr:= lWhereStr + ' and agent_manu like ' + '''%' + cxComboBoxAgent.Text + '%''';
  end;
  if cxCheckBoxArea.Checked then
  begin
    lWhereStr:= lWhereStr + ' and iron_tower_kind like ' + '''%' + cxComboBoxArea.Text + '%''';
  end;
  Result:= lWhereStr;
end;

procedure TFormDevGatherDistribute.cxBtnQueryClick(Sender: TObject);
begin
  DataSource2.DataSet:= nil;
  ClientDataSet2:= TClientDataSet.Create(nil);
  with ClientDataSet2 do
  begin
    Close;
    ProviderName:= 'DataSetProvider';
    //ShowMessage(GetWhereStr);
    Data:= gTempInterface.GetCDSData(VarArrayOf([1,218,GetWhereStr]),0)
  end;
  cxPageControl1.ActivePageIndex:=1;
  DataSource2.DataSet:= ClientDataSet2;
  cxGrid2DBTableView1.ApplyBestFit();
end;

procedure TFormDevGatherDistribute.LoadCSStatus(abox:TcxComboBox; aCity: Integer);
var
  lClientDataSet: TClientDataSet;
  lWdInteger :  TWdInteger;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
     with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,230,aCity]),0);
      while not eof do
      begin
        lWdInteger:=TWdInteger.Create(Fieldbyname('id').AsInteger);
        abox.Properties.Items.AddObject(Fieldbyname('CS_STATUS').AsString,lWdInteger);
        next;
      end;
      Close;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

end.
