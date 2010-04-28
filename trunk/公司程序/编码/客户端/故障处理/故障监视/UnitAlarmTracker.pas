unit UnitAlarmTracker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, cxControls, cxContainer, cxTreeView, ExtCtrls,
  cxLookAndFeelPainters, cxEdit, cxGroupBox, cxSplitter, Menus, StdCtrls,
  cxButtons, cxTextEdit, cxLabel, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, DB, cxDBData, cxPC, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, CxGridUnit, cxImage, dxGDIPlusClasses,
  DBClient, dxDockPanel, dxDockControl, dxBar, dxBarExtItems, jpeg,
  UDevExpressToChinese, StringUtils, ActnList, XPStyleActnCtrls, ActnMan,
  ImgList, IdBaseComponent, IdComponent, IdTCPConnection, UnitIDTCPClient,
  UnitVFMSGlobal, cxMaskEdit, cxDropDownEdit, cxColorComboBox, IniFiles;

type
  TActiveGridView = set of (wd_Active_AlarmMaster,
                            wd_Active_AlarmDetail,
                            wd_Active_AlarmCompanyMaster,
                            wd_Active_AlarmCompanyDetail,
                            wd_Active_AlarmFlow);
  TActiveDockPanel = set of (wd_Active_ParaDetail,
                             wd_Active_ParaCompany,
                             wd_Active_ParaFlow);
  TChangedDockPanel = set of (wd_Changed_ParaDetail,
                             wd_Changed_ParaCompany,
                             wd_Changed_ParaFlow);

  TFormAlarmTracker = class(TForm)
    PanelTitle: TPanel;
    Image1: TImage;
    dxBarManager1: TdxBarManager;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxDockSite1: TdxDockSite;
    dxLayoutDockSite7: TdxLayoutDockSite;
    dxLayoutDockSite6: TdxLayoutDockSite;
    dxLayoutDockSite5: TdxLayoutDockSite;
    dxLayoutDockSite1: TdxLayoutDockSite;
    dxLayoutDockSite4: TdxLayoutDockSite;
    dxLayoutDockSite2: TdxLayoutDockSite;
    dxDockPanel2: TdxDockPanel;
    dxDockPanel3: TdxDockPanel;
    dxDockPanel1: TdxDockPanel;
    dxDockPanel4: TdxDockPanel;
    dxDockPanel5: TdxDockPanel;
    dxDockPanel6: TdxDockPanel;
    dxDockingManager1: TdxDockingManager;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarSubItem4: TdxBarSubItem;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarManager1Bar1: TdxBar;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    dxBarButton14: TdxBarButton;
    dxBarManager1Bar2: TdxBar;
    dxBarButton15: TdxBarButton;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    dxBarButton18: TdxBarButton;
    dxBarManager1Bar4: TdxBar;
    dxBarButton19: TdxBarButton;
    dxBarButton20: TdxBarButton;
    dxBarButton21: TdxBarButton;
    dxBarButton22: TdxBarButton;
    dxBarManager1Bar5: TdxBar;
    dxBarButton23: TdxBarButton;
    dxBarButton24: TdxBarButton;
    dxBarButton25: TdxBarButton;
    dxBarManager1Bar6: TdxBar;
    dxBarButton26: TdxBarButton;
    dxBarManager1Bar7: TdxBar;
    dxBarButton27: TdxBarButton;
    cxGridAlarmMaster: TcxGrid;
    cxGridAlarmMasterDBTableView1: TcxGridDBTableView;
    cxGridAlarmMasterLevel1: TcxGridLevel;
    CDS_AlarmMaster: TClientDataSet;
    DS_AlarmMaster: TDataSource;
    cxGridAlarmDetail: TcxGrid;
    cxGridAlarmDetailDBTableView1: TcxGridDBTableView;
    cxGridAlarmDetailLevel1: TcxGridLevel;
    cxGridCompanyDBTableView1: TcxGridDBTableView;
    cxGridCompanyLevel1: TcxGridLevel;
    cxGridCompany: TcxGrid;
    cxGridFlowDBTableView1: TcxGridDBTableView;
    cxGridFlowLevel1: TcxGridLevel;
    cxGridFlow: TcxGrid;
    cxTreeView1: TcxTreeView;
    dxBarManager1Bar8: TdxBar;
    dxBarComboCompany: TdxBarCombo;
    dxBarButton28: TdxBarButton;
    CDS_Detail: TClientDataSet;
    DS_Detail: TDataSource;
    DS_Company: TDataSource;
    CDS_Company: TClientDataSet;
    cxGridCompanyLevel2: TcxGridLevel;
    cxGridCompanyDBTableView2: TcxGridDBTableView;
    CDS_CompanyDetail: TClientDataSet;
    DS_CompanyDetail: TDataSource;
    DS_Flow: TDataSource;
    CDS_Flow: TClientDataSet;
    ActionManager1: TActionManager;
    Image2: TImage;
    Label2: TLabel;
    ActionTake: TAction;
    ActionDeal: TAction;
    ActionCancelDeal: TAction;
    ActionRevert: TAction;
    ActionCancelClear: TAction;
    ActionFaultRemove: TAction;
    ActionFaultDelete: TAction;
    ActionFaultSubmit: TAction;
    ActionFaultClear: TAction;
    ActionFaultReturn: TAction;
    ActionFaultStay: TAction;
    ActionRemark: TAction;
    ActionRevertBack: TAction;
    imBarIcons: TImageList;
    ActionPrint: TAction;
    ImageTree: TImageList;
    EditFilter: TEdit;
    Timer1: TTimer;
    dxBarEditFilters: TdxBarEdit;
    ActionRefresh: TAction;
    dxBarButton29: TdxBarButton;
    dxBarButton30: TdxBarButton;
    ActionAutofresh: TAction;
    TimerAutofresh: TTimer;
    PanelStatusBar: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Panel5: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Panel6: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    cxColorComboBoxNoReceived: TcxColorComboBox;
    cxColorComboBoxReceived: TcxColorComboBox;
    cxColorComboBoxRevert: TcxColorComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure cxGridAlarmMasterDBTableView1CellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridCompanyDBTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);

    procedure cxGridAlarmMasterEnter(Sender: TObject);
    procedure cxGridAlarmMasterExit(Sender: TObject);
    procedure cxGridAlarmDetailEnter(Sender: TObject);
    procedure cxGridAlarmDetailExit(Sender: TObject);
    procedure cxGridCompanyEnter(Sender: TObject);
    procedure cxGridCompanyExit(Sender: TObject);
    procedure cxGridFlowEnter(Sender: TObject);
    procedure cxGridFlowExit(Sender: TObject);

    procedure ActionTakeExecute(Sender: TObject);       //主
    procedure ActionDealExecute(Sender: TObject);       //主
    procedure ActionCancelDealExecute(Sender: TObject); //主
    procedure ActionRevertExecute(Sender: TObject);
    procedure ActionCancelClearExecute(Sender: TObject);
    procedure ActionFaultRemoveExecute(Sender: TObject);
    procedure ActionFaultDeleteExecute(Sender: TObject);
    procedure ActionFaultSubmitExecute(Sender: TObject);
    procedure ActionFaultClearExecute(Sender: TObject);
    procedure ActionFaultReturnExecute(Sender: TObject);
    procedure ActionFaultStayExecute(Sender: TObject);
    procedure ActionRemarkExecute(Sender: TObject);
    procedure ActionRevertBackExecute(Sender: TObject);
    procedure dxBarComboCompanyChange(Sender: TObject);
    procedure dxBarButton27Click(Sender: TObject);
    procedure dxDockPanel1AutoHideChanged(Sender: TdxCustomDockControl);
    procedure dxDockPanel1AutoHideChanging(Sender: TdxCustomDockControl);
    procedure ActionPrintExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure dxBarManager1Docking(Sender: TdxBar;
      Style: TdxBarDockingStyle; DockControl: TdxDockControl;
      var CanDocking: Boolean);
    procedure EditFilterKeyPress(Sender: TObject; var Key: Char);
    //procedure ComboBoxCompanyChange(Sender: TObject);
    procedure ActionRefreshExecute(Sender: TObject);
    procedure ActionAutofreshExecute(Sender: TObject);
    procedure TimerAutofreshTimer(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure cxGridAlarmMasterDBTableView1DblClick(Sender: TObject);
    procedure cxGridFlowDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure cxColorComboBoxNoReceivedPropertiesChange(Sender: TObject);
    procedure cxColorComboBox2PropertiesChange(Sender: TObject);
    procedure cxColorComboBox3PropertiesChange(Sender: TObject);

  private
    //条件
    gAlarmStatusWhere: string;
    gGlobalWhere: string;
    gFilterWhere: string;
    gActiveGridView: TActiveGridView;
    gClick_Cityid, gClick_Companyid, gClick_Batchid: integer;
    gClick_RecordChanged: boolean;
    gActiveDockPanel: TActiveDockPanel;
    gChangedDockPanel: TChangedDockPanel;
    FControlChanging: boolean;
    FTCPClient: TTCPClient;
    gCurrNodeCode: integer;

    //右键菜单
    FMenuTake, FMenuDeal, FMenuCancelDeal, FMenuClear, FMenuDel,
    FMenuInputCause, FMenuInputRepair, FMenuRevert, FMenuFeedTake,
    FMenuDifficulty, FMenuChangeSend, FMenuRemark, FMenuPrint,
    FMenuCommit, FMenuComfirmOK, FMenuRejectOK, FMenuRefresh: TMenuItem;

    FCxGridHelper : TCxGridSet;
    gFlowColorList: TStringList;

    gColorNoReceived, gColorReceived, gColorRevert: TColor;

    procedure DoMenuAction_7(Sender: TObject);   //主
    procedure DoMenuAction_6(Sender: TObject);   //主
    procedure AddFlowField(aView: TcxGridDBTableView);
    procedure OnUserPopup(Sender: TObject);
    procedure cxGridAlarmMasterDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure ActionUseable(aCurrNodeCode: integer);//根据树的状态更新ACTIONLIST
    procedure ResizeFilter;
    procedure RefreshUnreceiveTreeNode(aTreeNode: TTreeNode);
    procedure NewSetTreeNodeDisplayName;
    procedure IniFormParams;
    procedure dxDockPanelVisibleChanged(Sender: TdxCustomDockControl);
    function  DeviceCheck(aDevID, aCoDevID, aCityID: Integer;
                    var aDevCaption, aDevAddr, aGatherName: string):Integer;
    //设备校验  00-资料不存在，设备未规划 10-资料存在，设备未规划 01资料不存在，设备已规划 11-校验成功
    procedure GetGridColor;
  public
    procedure ShowMasterAlarmOnline;     //在线主障告警
    procedure ShowDetailAlarmOnline(aBatchid, aCompanyid, aCityid: integer);     //在线从障告警
    procedure ShowFlowRecOnline(aBatchid, aCompanyid, aCityid: integer);         //在线流转告警
    procedure ShowMasterAlarmOfCompany(aBatchid, aCompanyid, aCityid: integer);  //在线其他维护单位主障告警
    procedure ShowDetailAlarmOfCompany(aBatchid, aCompanyid, aCityid: integer);  //在线其他维护单位从障告警
    {发送消息}
    procedure SendMessageToServer(aComid: integer);
  end;

var
  FormAlarmTracker: TFormAlarmTracker;
  //change:string;
implementation

uses UnitDllCommon, UnitAlarmRevert, UnitUserSign, UnitAlarmChange,
  UnitFaultStaySet, UnitSubmitInfo;

{$R *.dfm}

procedure TFormAlarmTracker.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //回调，用DLLMGR去释放窗体
  gDllMsgCall(FormAlarmTracker,1,'','');
end;

procedure TFormAlarmTracker.FormDestroy(Sender: TObject);
begin
  FTCPClient.Destroy;
  //菜单释放
  FCxGridHelper.Free;
  ClearTStrings(gFlowColorList);
end;

procedure TFormAlarmTracker.FormCreate(Sender: TObject);
const
  WD_ADMINISTRATOR= 0;
  WD_FIX= 1;
var
  lIsVisable: boolean;
  function ifVisable(aTag: integer): boolean;
  begin
    if gPublicParam.ManagerPrive = aTag then
      result:= true
    else
      result:= false;
  end;
begin
  GetGridColor;
  gFlowColorList:= TStringList.Create;
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.OnUserDrawCell:= cxGridAlarmMasterDBTableView1CustomDrawCell;
  FCxGridHelper.NewSetGridStyle(cxGridAlarmMaster,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridAlarmDetail,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridFlow,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridCompany,true,true,true);

  if gPublicParam.userid = 1 then//超级管理员
  begin
    lIsVisable:= true;
    FCxGridHelper.AppendShowMenuItem('-',nil,lIsVisable);
    FMenuTake:= FCxGridHelper.AppendShowMenuItem('接单',ActionTakeExecute,lIsVisable);
    FMenuDeal:= FCxGridHelper.AppendShowMenuItem('处理',ActionDealExecute,lIsVisable);
    FMenuCancelDeal:= FCxGridHelper.AppendShowMenuItem('取消处理',ActionCancelDealExecute,lIsVisable);

    FCxGridHelper.AppendShowMenuItem('-',nil,lIsVisable);
    FMenuClear:= FCxGridHelper.AppendShowMenuItem('排除告警',ActionFaultRemoveExecute,lIsVisable);
    FMenuDel:= FCxGridHelper.AppendShowMenuItem('删除告警',ActionFaultDeleteExecute,lIsVisable);

    FMenuInputCause:= TMenuItem.Create(nil);
    FMenuInputCause.Caption:='录入故障原因';
    FMenuInputCause.Add(GetMenuItem(7,DoMenuAction_7,0));
    FCxGridHelper.AppendFatherMenuItem(FMenuInputCause);
    FMenuInputRepair:= TMenuItem.Create(nil);
    FMenuInputRepair.Caption:='录入排障方法';
    FMenuInputRepair.Add(GetMenuItem(6,DoMenuAction_6,0));
    FCxGridHelper.AppendFatherMenuItem(FMenuInputRepair);

    FCxGridHelper.AppendShowMenuItem('-',nil,lIsVisable);
    FMenuRevert:= FCxGridHelper.AppendShowMenuItem('回单',ActionRevertExecute,lIsVisable);
    FMenuFeedTake:= FCxGridHelper.AppendShowMenuItem('回退原单位',ActionRevertBackExecute,lIsVisable);
    FMenuDifficulty:= FCxGridHelper.AppendShowMenuItem('转为疑难',ActionFaultStayExecute,lIsVisable);
    FMenuChangeSend:= FCxGridHelper.AppendShowMenuItem('告警转派',ActionFaultReturnExecute,lIsVisable);

    FCxGridHelper.AppendShowMenuItem('-',nil,lIsVisable);
    FMenuCommit:= FCxGridHelper.AppendShowMenuItem('提交',ActionFaultSubmitExecute,lIsVisable);
    FMenuComfirmOK:= FCxGridHelper.AppendShowMenuItem('确认消障',ActionFaultClearExecute,lIsVisable);
    FMenuRejectOK:= FCxGridHelper.AppendShowMenuItem('驳回消障',ActionCancelClearExecute,lIsVisable);

    FCxGridHelper.AppendShowMenuItem('-',nil,lIsVisable);
    FMenuRemark:= FCxGridHelper.AppendShowMenuItem('填写告警附加信息',ActionRemarkExecute,lIsVisable);
    FMenuPrint:= FCxGridHelper.AppendShowMenuItem('预览/打印派修单',nil,lIsVisable);
    FMenuRefresh:= FCxGridHelper.AppendShowMenuItem('刷新',ActionRefreshExecute,lIsVisable);
  end else
  begin//根据用户设置
    FCxGridHelper.AppendShowMenuItem('-',nil,true);
    FMenuTake:= FCxGridHelper.AppendShowMenuItem('接单',ActionTakeExecute,true);
    FMenuDeal:= FCxGridHelper.AppendShowMenuItem('处理',ActionDealExecute,true);
    FMenuCancelDeal:= FCxGridHelper.AppendShowMenuItem('取消处理',ActionCancelDealExecute,true);

    FCxGridHelper.AppendShowMenuItem('-',nil,ifVisable(WD_ADMINISTRATOR));
    FMenuClear:= FCxGridHelper.AppendShowMenuItem('排除告警',ActionFaultRemoveExecute,ifVisable(WD_ADMINISTRATOR));
    FMenuDel:= FCxGridHelper.AppendShowMenuItem('删除告警',ActionFaultDeleteExecute,ifVisable(WD_ADMINISTRATOR));

    FMenuInputCause:= TMenuItem.Create(nil);
    FMenuInputCause.Caption:='录入故障原因';
    FMenuInputCause.Add(GetMenuItem(7,DoMenuAction_7,0));
    FCxGridHelper.AppendFatherMenuItem(FMenuInputCause);
    FMenuInputRepair:= TMenuItem.Create(nil);
    FMenuInputRepair.Caption:='录入排障方法';
    FMenuInputRepair.Add(GetMenuItem(6,DoMenuAction_6,0));
    FCxGridHelper.AppendFatherMenuItem(FMenuInputRepair);

    FCxGridHelper.AppendShowMenuItem('-',nil,true);
    FMenuRevert:= FCxGridHelper.AppendShowMenuItem('回单',ActionRevertExecute,ifVisable(WD_FIX));
    FMenuFeedTake:= FCxGridHelper.AppendShowMenuItem('回退原单位',ActionRevertBackExecute,ifVisable(WD_ADMINISTRATOR));
    FMenuDifficulty:= FCxGridHelper.AppendShowMenuItem('转为疑难',ActionFaultStayExecute,ifVisable(WD_ADMINISTRATOR));
    FMenuChangeSend:= FCxGridHelper.AppendShowMenuItem('告警转派',ActionFaultReturnExecute,ifVisable(WD_ADMINISTRATOR));

    FCxGridHelper.AppendShowMenuItem('-',nil,true);
    FMenuCommit:= FCxGridHelper.AppendShowMenuItem('提交',ActionFaultSubmitExecute,true);
    FMenuComfirmOK:= FCxGridHelper.AppendShowMenuItem('确认消障',ActionFaultClearExecute,ifVisable(WD_ADMINISTRATOR));
    FMenuRejectOK:= FCxGridHelper.AppendShowMenuItem('驳回消障',ActionCancelClearExecute,ifVisable(WD_ADMINISTRATOR));

    FCxGridHelper.AppendShowMenuItem('-',nil,true);
    FMenuRemark:= FCxGridHelper.AppendShowMenuItem('填写告警附加信息',ActionRemarkExecute,true);
    FMenuPrint:= FCxGridHelper.AppendShowMenuItem('预览/打印派修单',nil,true);
    FMenuRefresh:= FCxGridHelper.AppendShowMenuItem('刷新',ActionRefreshExecute,true);
  end;
  TPopupMenu(cxGridAlarmMaster.PopupMenu).OnPopup:= OnUserPopup;

  //加字段
  LoadFields(cxGridAlarmMasterDBTableView1,gPublicParam.cityid,gPublicParam.userid,1);
  LoadFields(cxGridAlarmDetailDBTableView1,gPublicParam.cityid,gPublicParam.userid,2);
  LoadFields(cxGridCompanyDBTableView1,gPublicParam.cityid,gPublicParam.userid,3);
  LoadFields(cxGridFlowDBTableView1,gPublicParam.cityid,gPublicParam.userid,30);
  AddHindFlowField(cxGridFlowDBTableView1);

  gGlobalWhere:= ' and flowtache in (5,6,7)';
  gGlobalWhere:= gGlobalWhere+ ' and cityid='+inttostr(gPublicParam.Cityid)+' and companyid in ('+gPublicParam.RuleCompanyidStr+')';

  FTCPClient:=TTCPClient.Create(gPublicParam.ServerIP,gPublicParam.MsgPort);
  if FTCPClient.Connect<>1 then
    Application.MessageBox(pchar('连接实时消息服务器错误,无法自动刷新数据！地址：'+gPublicParam.ServerIP+' 端口：'+inttostr(gPublicParam.MsgPort)), '系统提示', MB_OK + MB_ICONINFORMATION);
  //特殊属性设置
  self.IniFormParams;
end;

procedure TFormAlarmTracker.FormShow(Sender: TObject);
begin
  //画树
  cxTreeView1.Items.Clear;
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,31);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,3);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,2);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,32);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,33);
  //选中特定节点
  SelectNode(cxTreeView1,'未接单');
  //节点后边跟数量
  NewSetTreeNodeDisplayName;
  //加维护单位
  LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,dxBarComboCompany.Items);
  //LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,ComboBoxCompany.Items);
end;

procedure TFormAlarmTracker.ShowMasterAlarmOfCompany(aBatchid, aCompanyid, aCityid: integer);
begin
  if not cxGridCompany.CanFocus then exit;

  DS_Company.DataSet:= nil;
  try
    with CDS_Company do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,1,' and batchid='+inttostr(aBatchid)+' and cityid='+inttostr(aCityid)+' and companyid<>'+inttostr(aCompanyid)]),0);
    end;
  finally

  end;
  DS_Company.DataSet:= CDS_Company;
  cxGridCompanyDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmTracker.ShowDetailAlarmOnline(aBatchid, aCompanyid, aCityid: integer);
begin
  //if not cxGridAlarmDetail.CanFocus then exit;

  DS_Detail.DataSet:= nil;
  try
    with CDS_Detail do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,2,' and cityid='+inttostr(aCityid)+' and companyid='+inttostr(aCompanyid)+' and batchid='+inttostr(aBatchid)]),0);
    end;
  finally

  end;
  DS_Detail.DataSet:= CDS_Detail;
  cxGridAlarmDetailDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmTracker.ShowFlowRecOnline(aBatchid, aCompanyid, aCityid: integer);
begin
  DS_Flow.DataSet:= nil;
  try
    with CDS_Flow do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,3,' and cityid='+inttostr(aCityid)+' and batchid='+inttostr(aBatchid)]),0);
    end;
  finally
  end;
  DS_Flow.DataSet:= CDS_Flow;
  //cxGridFlowDBTableView1.ApplyBestFit();
  if not GetFlowColorSet(CDS_Flow, gFlowColorList) then
    raise exception.Create('获取流程日志颜色设置失败');
end;

procedure TFormAlarmTracker.ShowMasterAlarmOnline;
var
  AlarmNo,CityNO,CompanyNo,i:Integer;
begin
 // if not cxGridAlarmMaster.CanFocus then exit;

  DS_AlarmMaster.DataSet:= nil;
  try
    with CDS_AlarmMaster do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,1,gAlarmStatusWhere+gGlobalWhere+gFilterWhere]),0);
    end;
  finally

  end;
  DS_AlarmMaster.DataSet:= CDS_AlarmMaster;
  cxGridAlarmMasterDBTableView1.ApplyBestFit();

  cxGridAlarmMasterDBTableView1.DataController.ClearSelection;
  try
    AlarmNo:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('batchid').Index;  //告警编号
    CityNO:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('cityid').Index;
    CompanyNo:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('companyid').Index;
  except
    Exit;
  end;

  DS_AlarmMaster.DataSet.Locate('cityid;companyid;batchid',VarArrayOf([gClick_Cityid,gClick_Companyid,gClick_Batchid]),[loCaseInsensitive]);
  for i:=cxGridAlarmMasterDBTableView1.DataController.RowCount-1 downto 0 do
  begin
    if (gClick_Batchid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,AlarmNo)) and
       (gClick_Cityid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,CityNO)) and
       (gClick_Companyid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,CompanyNo)) then
    begin
      cxGridAlarmMasterDBTableView1.DataController.SelectRows(i,i);
      cxGridAlarmMasterDBTableView1.Focused:=True;
      Break;
    end;
  end;
end;

procedure TFormAlarmTracker.cxTreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
  //由于DOCKPANEL隐藏的时候会触发事件，所以要屏蔽掉
  if FControlChanging then exit;
  if (Node=nil) or (Node.Data=nil) then exit;
  gCurrNodeCode:= TNodeParam(Node.Data).NodeCode;
  case TNodeParam(Node.Data).NodeType of
    31:  begin//告警流程树
           gAlarmStatusWhere:= ' '+TNodeParam(Node.Data).SetValue;
    end;
    32:  begin//告警疑难树
           //if cxTreeView1.Selected<>nil then
             //gDllMsgCall(nil,4,'FormAlarmStay',cxTreeView1.Selected.Text);
             gDllMsgCall(nil,4,'FormAlarmStay',TNodeParam(Node.Data).DisplayName);
           exit;
    end;
    33:  begin//派障综合查询
           //if cxTreeView1.Selected<>nil then
             //gDllMsgCall(nil,2,'FormAlarmSearch',cxTreeView1.Selected.Text);
             gDllMsgCall(nil,2,'FormAlarmSearch',TNodeParam(Node.Data).DisplayName);
           exit;
    end;
    2:   begin//告警类型
           if TNodeParam(Node.Data).Parentid=-1 then
             gAlarmStatusWhere:= ''
           else
             gAlarmStatusWhere:= ' and alarmtype='+inttostr(TNodeParam(Node.Data).id);
    end;
    3:   begin//告警级别
           if TNodeParam(Node.Data).Parentid=-1 then
             gAlarmStatusWhere:= ''
           else
             gAlarmStatusWhere:= ' and alarmlevel='+inttostr(TNodeParam(Node.Data).id);
    end;
  end;
  //change:='check';
  ShowMasterAlarmOnline;
  if TNodeParam(Node.Data).NodeType=31 then
    Node.Text:= TNodeParam(Node.Data).DisplayName + '(' + IntToStr(CDS_AlarmMaster.recordcount) + ')';
  ActionUseable(TNodeParam(Node.Data).NodeCode);

//  gClick_Cityid:= 0;
//  gClick_Companyid:= 0;
//  gClick_Batchid:= 0;
end;

procedure TFormAlarmTracker.cxGridAlarmMasterDBTableView1CellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  lCityid, lCompanyid, lBatchid: integer;
begin
  try
    lCityid:= CDS_AlarmMaster.FieldByName('cityid').AsInteger;
    lCompanyid:= CDS_AlarmMaster.FieldByName('companyid').AsInteger;
    lBatchid:= CDS_AlarmMaster.FieldByName('batchid').AsInteger;
  except
    Application.MessageBox('未获得关键字段CITYID,COMPANYID,BATCHID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  gClick_RecordChanged:= (gClick_Cityid<>lCityid) or (gClick_Companyid<>lCompanyid)
                          or (gClick_Batchid<>lBatchid);
  //if gClick_RecordChanged then
  begin
    gClick_Cityid:= lCityid;
    gClick_Companyid:= lCompanyid;
    gClick_Batchid:= lBatchid;

    gChangedDockPanel:= [];
    dxDockPanelVisibleChanged(dxDockPanel4);
    dxDockPanelVisibleChanged(dxDockPanel5);
    dxDockPanelVisibleChanged(dxDockPanel6);
  end;
end;

procedure TFormAlarmTracker.cxGridCompanyDBTableView1DataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  lCityid,lCompanyid,lBatchid: integer;
  lCityid_Index,lCompanyid_Index,lBatchid_Index: integer;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  try
    lCityid_Index:= cxGridCompanyDBTableView1.GetColumnByFieldName('CITYID').Index;
    lCompanyid_Index:= cxGridCompanyDBTableView1.GetColumnByFieldName('COMPANYID').Index;
    lBatchid_Index:= cxGridCompanyDBTableView1.GetColumnByFieldName('BATCHID').Index;
  except
    Application.MessageBox('未获得关键字段CITYID,COMPANYID,BATCHID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lCityid:= integer(ADataController.GetValue(ARecordIndex,lCityid_Index));
  lCompanyid:= integer(ADataController.GetValue(ARecordIndex,lCompanyid_Index));
  lBatchid:= integer(ADataController.GetValue(ARecordIndex,lBatchid_Index));
  ShowDetailAlarmOfCompany(lBatchid,lCompanyid,lCityid);
end;

procedure TFormAlarmTracker.ShowDetailAlarmOfCompany(aBatchid, aCompanyid,
  aCityid: integer);
begin
  //if not cxGridCompany.CanFocus then exit;

  DS_CompanyDetail.DataSet:= nil;
  try
    with CDS_CompanyDetail do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,2,' and cityid='+inttostr(aCityid)+' and companyid='+inttostr(aCompanyid)+' and batchid='+inttostr(aBatchid)]),0);
    end;
  finally

  end;
  DS_CompanyDetail.DataSet:= CDS_CompanyDetail;
  cxGridCompanyDBTableView2.ApplyBestFit();
end;

procedure TFormAlarmTracker.ActionTakeExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lRecordIndex: integer;
  lWherestr: string;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];

        lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
        lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
        lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
        gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,20,'',gPublicParam.userid);
        lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
      end;
      lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate, t.isreaded=1,t.readedtime=sysdate,t.BILLSTATUS=1 where '+lWherestr;
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
        MessageBox(handle,'接单失败!','系统提示',MB_ICONWARNING)
      else
      begin
        lActiveView.DataController.DeleteSelection;
        MessageBox(handle,'接单成功!','系统提示',MB_ICONINFORMATION);
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmTracker.cxGridAlarmMasterEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmMaster];
end;

procedure TFormAlarmTracker.cxGridAlarmMasterExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmMaster];
end;

procedure TFormAlarmTracker.cxGridAlarmDetailEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmDetail];
end;

procedure TFormAlarmTracker.cxGridAlarmDetailExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmDetail];
end;

procedure TFormAlarmTracker.cxGridCompanyEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmCompanyMaster];
end;

procedure TFormAlarmTracker.cxGridCompanyExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmCompanyMaster];
end;

procedure TFormAlarmTracker.cxGridFlowEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmFlow];
end;

procedure TFormAlarmTracker.cxGridFlowExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmFlow];
end;

procedure TFormAlarmTracker.cxGridAlarmMasterDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  lBillStatusName_Index, lIsRevertBack_Index, lIsReadedBack_Index: integer;
  lBillStatusName: string;
  lIsRevertBack: integer;
  lIsReadedBack: integer;
begin
  try
    lBillStatusName_Index:=TcxGridDBTableView(Sender).GetColumnByFieldName('BILLSTATUSNAME').Index;
    lIsRevertBack_Index:= TcxGridDBTableView(Sender).GetColumnByFieldName('ISREVERTBACK').Index;
    lIsReadedBack_Index:= TcxGridDBTableView(Sender).GetColumnByFieldName('ISREADEDBACK').Index;
  except
    exit;
  end;
  if varisnull(AViewInfo.GridRecord.Values[lBillStatusName_Index]) then
    lBillStatusName:= ''
  else
    lBillStatusName:= AViewInfo.GridRecord.Values[lBillStatusName_Index];
  if varisnull(AViewInfo.GridRecord.Values[lIsRevertBack_Index]) then
    lIsRevertBack:= -1
  else
    lIsRevertBack:= AViewInfo.GridRecord.Values[lIsRevertBack_Index];
  if varisnull(AViewInfo.GridRecord.Values[lIsReadedBack_Index]) then
    lIsReadedBack:= -1
  else
    lIsReadedBack:= AViewInfo.GridRecord.Values[lIsReadedBack_Index];

  if lBillStatusName='未接单' then
    ACanvas.Brush.Color := gColorNoReceived;

  if lIsReadedBack= 1 then
    ACanvas.Font.Style:= [fsBold];
  if lIsRevertBack= 1 then
    ACanvas.Font.Style:= [fsBold, fsItalic];

  if lBillStatusName='已处理' then
    ACanvas.Brush.Color := gColorReceived;
  if lBillStatusName='已回单' then
    ACanvas.Brush.Color := gColorRevert;
end;

procedure TFormAlarmTracker.ActionDealExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lRecordIndex: integer;
  lWherestr: string;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];

        lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
        lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
        lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
        gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,21,'',gPublicParam.userid);
        lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
      end;
      lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate, t.isperform=1,t.isreaded=1,t.readedtime=decode(nvl(t.isreaded,0),0,sysdate),t.BILLSTATUS=2 where '+lWherestr;
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
        MessageBox(handle,'处理失败!','系统提示',MB_ICONWARNING)
      else
      begin
        lActiveView.DataController.DeleteSelection;
        MessageBox(handle,'处理成功!','系统提示',MB_ICONINFORMATION) ;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionCancelDealExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lRecordIndex: integer;
  lWherestr: string;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];

        lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
        lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
        lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
        gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,22,'',gPublicParam.userid);
        lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
      end;
      lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate,t.isperform=0,t.BILLSTATUS=1 where '+lWherestr;
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
        MessageBox(handle,'取消处理失败!','系统提示',MB_ICONWARNING)
      else
      begin
        lActiveView.DataController.DeleteSelection;
        MessageBox(handle,'取消处理成功!','系统提示',MB_ICONINFORMATION) ;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmTracker.DoMenuAction_7(Sender: TObject);
var
  MenuItem:TMenuItem;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lcausecodename_Index: integer;
  lRecordIndex: integer;
  lActiveView: TcxGridDBTableView;
  lWherestr: string;
  lupdatetime_Index: integer;
  I: integer;

  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  MenuItem:=TMenuItem(Sender);
  if MenuItem.Count > 0 then Exit;
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
    except
      lBatchid_Index:=-1;
    end;
    try
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
    except
      lCompanyid_Index:=-1;
    end;
    try
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      lCityid_Index:=-1;
    end;
    try
      lcausecodename_Index:=lActiveView.GetColumnByFieldName('CAUSECODENAME').Index;
    except
      lcausecodename_Index:=-1;
    end;
    try
      lupdatetime_Index:=lActiveView.GetColumnByFieldName('UPDATETIME').Index;
    except
      lupdatetime_Index:=-1;
    end;
    if (lBatchid_Index= -1) or (lCompanyid_Index= -1) or (lCityid_Index= -1)
    or (lcausecodename_Index=-1) or (lupdatetime_Index=-1) then
    begin
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID,CAUSECODENAME,UPDATETIME！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
    lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    if not Varisnull(lActiveView.DataController.GetValue(lRecordIndex,lcausecodename_Index)) then
    begin
      if application.MessageBox('"故障原因"已经存在，是否覆盖？','提示',MB_OKCANCEL + MB_ICONINFORMATION)=IDCANCEL then
        exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
        lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
        lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
        lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
        lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
      end;
      lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate,causecode ='+inttostr(MenuItem.Tag)+','+
                'troubleoccurcause ='+QuotedStr(MenuItem.Caption)+' where '+lWherestr;
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

      if not lsuccess then
        MessageBox(handle,'录入失败!','系统提示',MB_ICONWARNING)
      else
      begin
        //更新界面
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lActiveView.DataController.SetValue(lRecordIndex,lupdatetime_Index,gTempInterface.GetSystemDateTime);
          lActiveView.DataController.SetValue(lRecordIndex,lcausecodename_Index,MenuItem.Caption);

          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,25,'',gPublicParam.userid);
        end;
        MessageBox(handle,'录入成功!','系统提示',MB_ICONINFORMATION) ;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmTracker.DoMenuAction_6(Sender: TObject);
var
  MenuItem:TMenuItem;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lResolventname_Index: integer;
  lRecordIndex: integer;
  lActiveView: TcxGridDBTableView;
  lWherestr: string;
  lupdatetime_Index: integer;
  I: integer;

  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  MenuItem:=TMenuItem(Sender);
  if MenuItem.Count > 0 then Exit;
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
    except
      lBatchid_Index:=-1;
    end;
    try
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
    except
      lCompanyid_Index:=-1;
    end;
    try
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      lCityid_Index:=-1;
    end;
    try
      lResolventname_Index:=lActiveView.GetColumnByFieldName('RESOLVENTCODENAME').Index;
    except
      lResolventname_Index:=-1;
    end;
    try
      lupdatetime_Index:=lActiveView.GetColumnByFieldName('UPDATETIME').Index;
    except
      lupdatetime_Index:=-1;
    end;
    if (lBatchid_Index= -1) or (lCompanyid_Index= -1) or (lCityid_Index= -1)
    or (lResolventname_Index=-1) or (lupdatetime_Index=-1) then
    begin
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID,RESOLVENTCODENAME,UPDATETIME！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
    lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    if not Varisnull(lActiveView.DataController.GetValue(lRecordIndex,lResolventname_Index)) then
    begin
      if application.MessageBox('"排障方法"已经存在，是否覆盖？','提示',MB_OKCANCEL + MB_ICONINFORMATION)=IDCANCEL then
        exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
        lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
        lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
        lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
        lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
      end;
      lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate,resolventcode ='+inttostr(MenuItem.Tag)+' where '+lWherestr;
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
        MessageBox(handle,'录入失败!','系统提示',MB_ICONWARNING)
      else
      begin
        //更新界面
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lActiveView.DataController.SetValue(lRecordIndex,lupdatetime_Index,gTempInterface.GetSystemDateTime);
          lActiveView.DataController.SetValue(lRecordIndex,lResolventname_Index,MenuItem.Caption);

          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,26,'',gPublicParam.userid);
        end;
        MessageBox(handle,'录入成功!','系统提示',MB_ICONINFORMATION) ;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionRevertExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lRecordIndex: integer;
  lcontentcodename_Index, lCausecodename_Index, lCausecode_Index: integer;
  lContentcodeName, lCausecodeName, lRevertCause: string;
  lCausecode: integer;
  lWherestr: string;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
  lFormAlarmRevert: TFormAlarmRevert;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lcontentcodename_Index:=lActiveView.GetColumnByFieldName('CONTENTCODENAME').Index;
      lCausecodename_Index:=lActiveView.GetColumnByFieldName('CAUSECODENAME').Index;
      lCausecode_Index:= lActiveView.GetColumnByFieldName('CAUSECODE').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID,CONTENTCODENAME,CAUSECODENAME,CAUSECODE！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
    lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    if varisnull(lActiveView.DataController.GetValue(lRecordIndex,lcontentcodename_Index)) then
      lContentcodeName:=''
    else
      lContentcodeName:= lActiveView.DataController.GetValue(lRecordIndex,lcontentcodename_Index);
    if varisnull(lActiveView.DataController.GetValue(lRecordIndex,lCausecodename_Index)) then
      lCausecodeName:=''
    else
      lCausecodeName:= lActiveView.DataController.GetValue(lRecordIndex,lCausecodename_Index);
    if varisnull(lActiveView.DataController.GetValue(lRecordIndex,lCausecode_Index)) then
      lCausecode:=-1
    else
      lCausecode:= lActiveView.DataController.GetValue(lRecordIndex,lCausecode_Index);

    lFormAlarmRevert:= TFormAlarmRevert.Create(nil);
    try
      lFormAlarmRevert.Label7.Caption:= lContentcodeName;
      lFormAlarmRevert.Ed_Reason.Text:= lCausecodeName;
      lFormAlarmRevert.Ed_Reason.Tag:= lCausecode;
      if lFormAlarmRevert.ShowModal=mrOk then
      begin
        lRevertCause:= lFormAlarmRevert.EditRevertReason.Text;
        lCausecodeName:= lFormAlarmRevert.Ed_Reason.Text;
        lCausecode:= lFormAlarmRevert.Ed_Reason.Tag;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
        end;
        lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

        lVariant:= VarArrayCreate([0,0],varVariant);
        lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate,t.isperform=1,t.isreaded=1,t.readedtime=decode(nvl(t.isreaded,0),0,sysdate),t.isrevert=1,t.reverttime=sysdate,'+
                  't.revertoperator='+inttostr(gPublicParam.userid)+',t.revertcause='+quotedstr(lRevertCause)+
                  ',t.causecode='+inttostr(lCausecode)+',t.TROUBLEOCCURCAUSE='+quotedstr(lCausecodeName)+
                  ',t.BILLSTATUS=3'+
                  ' where '+lWherestr;
        lVariant[0]:= VarArrayOf([lSqlstr]);
        lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,23,'',gPublicParam.userid);
        end;
        if not lsuccess then
          MessageBox(handle,'回单失败!','系统提示',MB_ICONWARNING)
        else
        begin
          SendMessageToServer(101);
          MessageBox(handle,'回单成功!','系统提示',MB_ICONINFORMATION) ;
        end;
      end;
    finally
      lFormAlarmRevert.Free;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionCancelClearExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lCancelClearCause: string;
  lFormUserSign: TFormUserSign;
  I: integer;
  lRecordIndex: integer;
  lMessageInfo: string;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;

    lFormUserSign:= TFormUserSign.Create(nil);
    try
      if lFormUserSign.ShowModal=mrOk then
      begin
        lCancelClearCause:= lFormUserSign.Memo1.Lines.Text;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);

          iError := gTempInterface.CancelClearFault(lCityid, lCompanyid, lBatchid, gPublicParam.userid, lCancelClearCause);
          case iError of
            0: if i = 0 then
               begin
                 SendMessageToServer(101);
                 lMessageInfo:= '驳回消障成功!';
                 Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
               end;
            -1: begin
                  lMessageInfo:= '存储过程内部执行异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            -2: begin
                  lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            -3: begin
                  lMessageInfo:= '接口异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            else if iError < -3 then
                begin
                  lMessageInfo:= '接口未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end
            else if iError > 0 then
                begin
                  lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
          end;
        end;
      end;
    finally
      lFormUserSign.Free;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionFaultRemoveExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lAlarmid,lBatchid,lCompanyid,lCityid,
  lContentCode,lDevID, lCoDevID,
  lBatchid_Index,lCompanyid_Index,lCityid_Index,
  lAlarmid_Index, lContentCode_index,lDev_Index,
  lCoDev_Index, lRecordIndex, I, iError,
  lDeviceCheck: Integer;
  lAlarmidStr, lDevCaption, lDevAddr, lGatherName: string;
  lMessageInfo: string;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) and (cxGridAlarmMaster.CanFocus) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lContentCode_index:= lActiveView.GetColumnByFieldName('ALARMCONTENTCODE').Index;
      lDev_Index:= lActiveView.GetColumnByFieldName('DEVICEID').Index;
      lCoDev_Index:= lActiveView.GetColumnByFieldName('CODEVICEID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID,ALARMCONTENTCODE,DEVICEID,CODEVICEID,BTS_NAME,station_addr！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
      lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
      lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
      lContentCode:= lActiveView.DataController.GetValue(lRecordIndex,lContentCode_index);
      lDevID:= lActiveView.DataController.GetValue(lRecordIndex,lDev_Index);
      
      IF lActiveView.DataController.GetValue(lRecordIndex,lCoDev_Index)=null then
        lCoDevID:= 0
      else
        lCoDevID:= lActiveView.DataController.GetValue(lRecordIndex,lCoDev_Index);

      if lContentCode=800000001 then
      begin
        lDeviceCheck:= DeviceCheck(lDevID, lCoDevID, gPublicParam.cityid,lDevCaption,lDevAddr,lGatherName);
        case lDeviceCheck of
        -1:
        begin
          Application.MessageBox('资料不全告警校验失败','提示',MB_OK+64);
          Exit;
        end;
        0, 1:
        begin
          Application.MessageBox('未找到相应基站信息','提示',MB_OK+64);
          Exit;
        end;
        16:
        begin
          Application.MessageBox('该设备未规划','提示',MB_OK+64);
          Exit;
        end;
        17:
        begin
          iError:= gTempInterface.DeviceLostResend(gPublicParam.cityid, IntToStr(lDevID));
          if iError<>0 then
            Application.MessageBox('资料校验异常','提示',MB_OK+64)
          else
            Application.MessageBox(pchar('资料校验成功'+#13+#13+
                                   'BTSID='+inttostr(lDevID)+ #13+
                                   'CELLID='+inttostr(lCoDevID)+ #13+
                                   '基站中文名：' + lDevCaption + #13+
                                   '基站地址：'+ lDevAddr+#13+
                                   '设备集名称：'+lGatherName)
                                  ,'提示',MB_OK+64);
        end;
        end;
      end;

      iError := gTempInterface.RemoveFault(lCityid, lCompanyid, lBatchid, gPublicParam.userid, '');
      case iError of
        0: if i = 0 then
           begin
             SendMessageToServer(101);
             lMessageInfo:= '排除告警成功!';
             Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
           end;
        -1: begin
              lMessageInfo:= '存储过程内部执行异常错误!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end;
        -2: begin
              lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end;
        -3: begin
              lMessageInfo:= '接口异常错误!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end;
        else if iError < -3 then
            begin
              lMessageInfo:= '接口未成功执行的编码原因!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end
        else if iError > 0 then
            begin
              lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end;
      end;
    end;
  end;
  //从障
  if (wd_Active_AlarmDetail in gActiveGridView) and (cxGridAlarmDetail.CanFocus) then
  begin
    lActiveView:= cxGridAlarmDetailDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lAlarmid_Index:= lActiveView.GetColumnByFieldName('ALARMID').Index;
    except
      Application.MessageBox('未获得关键字段COMPANYID,CITYID,ALARMID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;

    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
      lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
      lAlarmid:= lActiveView.DataController.GetValue(lRecordIndex,lAlarmid_Index);
      lAlarmidStr:= lAlarmidStr+ inttostr(lAlarmid)+',';
    end;
    lAlarmidStr:= copy(lAlarmidStr,1,length(lAlarmidStr)-1);
    if length(lAlarmidStr) >0 then
    begin
      iError := gTempInterface.RemoveFault(lCityid, lCompanyid, 0, gPublicParam.userid, lAlarmidStr);
      case iError of
        0:  begin
             lActiveView.DataController.DeleteSelection;
             lMessageInfo:= '排除告警成功!';
             Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
            end;
        -1: begin
              lMessageInfo:= '存储过程内部执行异常错误!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            end;
        -2: begin
              lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            end;
        -3: begin
              lMessageInfo:= '接口异常错误!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            end;
        else if iError < -3 then
            begin
              lMessageInfo:= '接口未成功执行的编码原因!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            end
        else if iError > 0 then
            begin
              lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            end;
      end;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionFaultDeleteExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lAlarmid_Index: integer;
  lAlarmid: integer;
  lAlarmidStr: string;
  I: integer;
  lRecordIndex: integer;
  lFormUserSign: TFormUserSign;
  lDeleteCause: string;
  lMessageInfo: string;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) and (cxGridAlarmMaster.CanFocus) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lFormUserSign:= TFormUserSign.Create(nil);
    try
      if lFormUserSign.ShowModal=mrOk then
      begin
        lDeleteCause:= lFormUserSign.Memo1.Lines.Text;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);

          iError := gTempInterface.DeleteFault(lCityid, lCompanyid, lBatchid, gPublicParam.userid, '', lDeleteCause);
          case iError of
            0: if i = 0 then
               begin
                 SendMessageToServer(101);
                 lMessageInfo:= '删除告警成功!';
                 Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
               end;
            -1: begin
                  lMessageInfo:= '存储过程内部执行异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            -2: begin
                  lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            -3: begin
                  lMessageInfo:= '接口异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            else if iError < -3 then
                begin
                  lMessageInfo:= '接口未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end
            else if iError > 0 then
                begin
                  lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
          end;
        end;
      end;
    finally
      lFormUserSign.free;
    end;
  end;
  //从障
  if (wd_Active_AlarmDetail in gActiveGridView) and (cxGridAlarmDetail.CanFocus) then
  begin
    lActiveView:= cxGridAlarmDetailDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lAlarmid_Index:= lActiveView.GetColumnByFieldName('ALARMID').Index;
    except
      Application.MessageBox('未获得关键字段COMPANYID,CITYID,ALARMID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lFormUserSign:= TFormUserSign.Create(nil);
    try
      if lFormUserSign.ShowModal=mrOk then
      begin
        lDeleteCause:= lFormUserSign.Memo1.Lines.Text;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          lAlarmid:= lActiveView.DataController.GetValue(lRecordIndex,lAlarmid_Index);
          lAlarmidStr:= lAlarmidStr+ inttostr(lAlarmid)+',';
        end;
        lAlarmidStr:= copy(lAlarmidStr,1,length(lAlarmidStr)-1);
        if length(lAlarmidStr) >0 then
        begin
          iError := gTempInterface.DeleteFault(lCityid, lCompanyid, 0, gPublicParam.userid, lAlarmidStr, lDeleteCause);
          case iError of
            0:  begin
                  lActiveView.DataController.DeleteSelection;
                  SendMessageToServer(101);
                  lMessageInfo:= '删除告警成功!';
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
                end;
            -1: begin
                  lMessageInfo:= '存储过程内部执行异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                end;
            -2: begin
                  lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                end;
            -3: begin
                  lMessageInfo:= '接口异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                end;
            else if iError < -3 then
                begin
                  lMessageInfo:= '接口未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                end
            else if iError > 0 then
                begin
                  lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                end;
          end;
        end;
      end;
    finally
      lFormUserSign.Free;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionFaultSubmitExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  I: integer;
  lRecordIndex: integer;
  lMessageInfo: string;

  lCausecodeName, lRevertCause, lResolvecodeName: string;
  lCausecode, lResolvecode: integer;
  lFormSubmitInfo: TFormSubmitInfo;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lFormSubmitInfo:= TFormSubmitInfo.Create(nil);
    try
      lFormSubmitInfo.Label7.Caption:= lActiveView.DataController.DataSource.DataSet.FieldByName('CONTENTCODENAME').AsString;
      lFormSubmitInfo.EditReason.Text:= lActiveView.DataController.DataSource.DataSet.FieldByName('CAUSECODENAME').AsString;
      lFormSubmitInfo.EditReason.Tag:= lActiveView.DataController.DataSource.DataSet.FieldByName('CAUSECODE').AsInteger;
      lFormSubmitInfo.EditResolve.Text:= lActiveView.DataController.DataSource.DataSet.FieldByName('RESOLVENTCODENAME').AsString;
      lFormSubmitInfo.EditResolve.Tag:= lActiveView.DataController.DataSource.DataSet.FieldByName('RESOLVENTCODE').AsInteger;
      lFormSubmitInfo.EditRevertReason.Text:= lActiveView.DataController.DataSource.DataSet.FieldByName('REVERTCAUSE').AsString;
      if lFormSubmitInfo.ShowModal=mrOk then
      begin
        lCausecodeName:= lFormSubmitInfo.EditReason.Text;
        if trim(lCausecodeName)='' then
          lCausecode:= -1
        else
          lCausecode:= lFormSubmitInfo.EditReason.Tag;
        lResolvecodeName:= lFormSubmitInfo.EditResolve.Text;
        if trim(lResolvecodeName)='' then
          lResolvecode:= -1
        else
          lResolvecode:= lFormSubmitInfo.EditResolve.Tag;
        lRevertCause:= lFormSubmitInfo.EditRevertReason.Text;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);

          iError := gTempInterface.SubmitFault(lCityid, lCompanyid, lBatchid, gPublicParam.userid,lCausecode,lResolvecode,lRevertCause);
          case iError of
            0: if i = 0 then
               begin
                 SendMessageToServer(101);
                 lMessageInfo:= '提交成功!';
                 Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
               end;
            -1: begin
                  lMessageInfo:= '存储过程内部执行异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            -2: begin
                  lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            -3: begin
                  lMessageInfo:= '接口异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            else if iError < -3 then
                begin
                  lMessageInfo:= '接口未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end
            else if iError > 0 then
                begin
                  lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
          end;
        end;
      end;
    finally
      lFormSubmitInfo.Free;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionFaultClearExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  I: integer;
  lRecordIndex: integer;
  lMessageInfo: string;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
      lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
      lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);

      iError := gTempInterface.ClearFault(lCityid, lCompanyid, lBatchid, gPublicParam.userid);
      case iError of
        0: if i = 0 then
           begin
             SendMessageToServer(101);
             lMessageInfo:= '确认消障成功!';
             Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
           end;
        -1: begin
              lMessageInfo:= '存储过程内部执行异常错误!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end;
        -2: begin
              lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end;
        -3: begin
              lMessageInfo:= '接口异常错误!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end;
        else if iError < -3 then
            begin
              lMessageInfo:= '接口未成功执行的编码原因!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end
        else if iError > 0 then
            begin
              lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              break;
            end;
      end;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionFaultReturnExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lBatchid_Index,lCompanyid_Index,lCityid_Index,lCompanyname_Index: integer;
  lFormAlarmChange: TFormAlarmChange;
  lRecordIndex: integer;
  lrevertconfirminfo: string;
  lBatchid,lCompanyid,lCityid: integer;
  lWherestr: string;
  i: integer;
  lVariant: variant;
  lSqlstr: string;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) and (cxGridAlarmMaster.CanFocus) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lCompanyname_Index:= lActiveView.GetColumnByFieldName('COMPANYNAME').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID,COMPANYNAME！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lFormAlarmChange:= TFormAlarmChange.Create(nil);
    try
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lFormAlarmChange.gCompanystr:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyname_Index);
      lFormAlarmChange.gCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
      lFormAlarmChange.gCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
      lFormAlarmChange.gBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
      if lFormAlarmChange.ShowModal=mrOk then
      begin
        //自动回单反馈
        if not lFormAlarmChange.CheckBox1.Checked then
        begin
          lrevertconfirminfo:= lFormAlarmChange.Memo1.Lines.Text;
          for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
            lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];

            lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
            lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
            lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
            lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
          end;
          lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

          lVariant:= VarArrayCreate([0,0],varVariant);
          lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate,t.isperform=1,t.isreaded=0,'+
                    't.revertconfirminfo='''+lrevertconfirminfo+''',t.ISREVERTBACK=1,t.Isrevert=0,t.Billstatus=0,t.ISREADEDBACK=0 where '+lWherestr;
          lVariant[0]:= VarArrayOf([lSqlstr]);
          gTempInterface.ExecBatchSQL(lVariant);
          for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
            lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
            lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
            lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
            lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
            gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,24,'',gPublicParam.userid);
          end;
        end;
        SendMessageToServer(101);
      end;
    finally
      lFormAlarmChange.free;
    end;
  end;
  if (wd_Active_AlarmDetail in gActiveGridView) and (cxGridAlarmDetail.CanFocus) then
  begin
    Application.MessageBox('请在主障中设置转派！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
end;

procedure TFormAlarmTracker.ActionFaultStayExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  I: integer;
  lRecordIndex: integer;
  lFormFaultStaySet: TFormFaultStaySet;
  lRemark: string;
  lStayinteger, lRemininteger: integer;
  lMessageInfo: string;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lFormFaultStaySet:= TFormFaultStaySet.Create(nil);
    try
      if lFormFaultStaySet.ShowModal=mrOk then
      begin
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          lRemark:= lFormFaultStaySet.EditRemark.Text;
          lStayinteger:= lFormFaultStaySet.SpinEditStay.Value;
          lRemininteger:= lFormFaultStaySet.SpinEditRemin.Value;
          iError := gTempInterface.StayFault(lCityid, lCompanyid, lBatchid, lRemark, lStayinteger, lRemininteger, gPublicParam.userid);
          case iError of
            0: if i = 0 then
               begin
                 SendMessageToServer(101);
                 lMessageInfo:= '转为疑难成功!';
                 Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
               end;
            -1: begin
                  lMessageInfo:= '存储过程内部执行异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            -2: begin
                  lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            -3: begin
                  lMessageInfo:= '接口异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
            else if iError < -3 then
                begin
                  lMessageInfo:= '接口未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end
            else if iError > 0 then
                begin
                  lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  break;
                end;
          end;
        end;
      end;
    finally
      lFormFaultStaySet.Free;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionRemarkExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lRemark_Index: integer;
  lRemark: string;
  lAlarmid_Index: integer;
  lAlarmid: integer;
  lRecordIndex: integer;
  lWherestr: string;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
  lFormUserSign: TFormUserSign;
  lupdatetime_Index: Integer;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) and (cxGridAlarmMaster.CanFocus) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lupdatetime_Index:=lActiveView.GetColumnByFieldName('UPDATETIME').Index;
    except
      lupdatetime_Index:=-1;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lRemark_Index:=lActiveView.GetColumnByFieldName('REMARK').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID,REMARK！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    lFormUserSign:= TFormUserSign.Create(nil);
    try
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      if varisnull(lActiveView.DataController.GetValue(lRecordIndex,lRemark_Index)) then
        lRemark:=''
      else
        lRemark:= lActiveView.DataController.GetValue(lRecordIndex,lRemark_Index);
      lFormUserSign.Memo1.Text:= lRemark;
      if lFormUserSign.ShowModal=mrOk then
      begin
        lRemark:= lFormUserSign.Memo1.Text;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
        end;
        lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

        lVariant:= VarArrayCreate([0,0],varVariant);
        lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate,t.remark='''+lRemark+''' where '+lWherestr;
        lVariant[0]:= VarArrayOf([lSqlstr]);
        lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,27,'',gPublicParam.userid);
        end;
        if not lsuccess then
          MessageBox(handle,'更新失败!','系统提示',MB_ICONWARNING)
        else
        begin
          //更新界面
          for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
            lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
            lActiveView.DataController.SetValue(lRecordIndex,lRemark_Index,lRemark);
            lActiveView.DataController.SetValue(lRecordIndex,lupdatetime_Index,gTempInterface.GetSystemDateTime);
          end;
          MessageBox(handle,'更新成功!','系统提示',MB_ICONINFORMATION) ;
        end;
      end;
    finally
      lFormUserSign.Free;
      Screen.Cursor := crDefault;
    end;
  end;

  if (wd_Active_AlarmDetail in gActiveGridView) and (cxGridAlarmDetail.CanFocus) then
  begin
    lActiveView:= cxGridAlarmDetailDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lupdatetime_Index:=lActiveView.GetColumnByFieldName('UPDATETIME').Index;
    except
      lupdatetime_Index:=-1;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lRemark_Index:=lActiveView.GetColumnByFieldName('REMARK').Index;
      lAlarmid_Index:= lActiveView.GetColumnByFieldName('ALARMID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID,REMARK,ALARMID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    lFormUserSign:= TFormUserSign.Create(nil);
    try
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];

      if varisnull(lActiveView.DataController.GetValue(lRecordIndex,lRemark_Index)) then
        lRemark:=''
      else
        lRemark:= lActiveView.DataController.GetValue(lRecordIndex,lRemark_Index);
      lFormUserSign.Memo1.Text:= lRemark;
      if lFormUserSign.ShowModal=mrOk then
      begin
        lRemark:= lFormUserSign.Memo1.Text;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          lAlarmid:= lActiveView.DataController.GetValue(lRecordIndex,lAlarmid_Index);
          lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+' and alarmid='+inttostr(lAlarmid)+') or';
        end;
        lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

        lVariant:= VarArrayCreate([0,0],varVariant);
        lSqlstr:= 'update fault_detail_online t set t.remark='''+lRemark+''' where '+lWherestr;
        lVariant[0]:= VarArrayOf([lSqlstr]);
        lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
        gTempInterface.AlarmProc(lCityid,lCompanyid,0,27,IntToStr(lAlarmid),gPublicParam.userid);
        if not lsuccess then
          MessageBox(handle,'更新失败!','系统提示',MB_ICONWARNING)
        else
        begin
          //更新界面
          for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
            lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
            lActiveView.DataController.SetValue(lRecordIndex,lRemark_Index,lRemark);
            lActiveView.DataController.SetValue(lRecordIndex,lupdatetime_Index,gTempInterface.GetSystemDateTime);
          end;
          MessageBox(handle,'更新成功!','系统提示',MB_ICONINFORMATION) ;
        end;
      end;
    finally
      lFormUserSign.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionRevertBackExecute(
  Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lrevertconfirminfo: string;
  lRecordIndex: integer;
  lWherestr: string;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
  lFormUserSign: TFormUserSign;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段BATCHID,COMPANYID,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    lFormUserSign:= TFormUserSign.Create(nil);
    try
      if lFormUserSign.ShowModal=mrOk then
      begin
        lrevertconfirminfo:= lFormUserSign.Memo1.Lines.Text;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];

          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          lWherestr:= lWherestr+' (batchid='+inttostr(lBatchid)+' and companyid='+inttostr(lCompanyid)+' and cityid='+inttostr(lCityid)+') or';
        end;
        lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

        lVariant:= VarArrayCreate([0,0],varVariant);
        lSqlstr:= 'update fault_master_online t set t.updatetime=sysdate,t.isperform=1,t.isreaded=0,'+
                  't.revertconfirminfo='''+lrevertconfirminfo+''',t.ISREVERTBACK=1,t.Isrevert=0,t.Billstatus=0,t.ISREADEDBACK=0 where '+lWherestr;
        lVariant[0]:= VarArrayOf([lSqlstr]);
        lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
          lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          gTempInterface.AlarmProc(lCityid,lCompanyid,lBatchid,24,'',gPublicParam.userid);
        end;
        if not lsuccess then
          MessageBox(handle,'回退原单位失败!','系统提示',MB_ICONWARNING)
        else
        begin
          SendMessageToServer(101);
          MessageBox(handle,'回退原单位成功!','系统提示',MB_ICONINFORMATION) ;
        end;
      end;
    finally
      lFormUserSign.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmTracker.dxBarComboCompanyChange(Sender: TObject);
begin
  if trim(dxBarComboCompany.Text) = '' then
  begin
    gFilterWhere:='';
  end
  else
  begin
    gFilterWhere:= ' and companyname LIKE '+''''+'%'+Trim(dxBarComboCompany.Text)+'%'+'''';
  end;
  ShowMasterAlarmOnline;
  gFilterWhere:= '';
end;

procedure TFormAlarmTracker.dxBarButton27Click(Sender: TObject);
begin
  if trim(EditFilter.Text) = '' then
  begin
    gFilterWhere:='';
  end
  else
  begin
    gFilterWhere:= ' bts_name LIKE '+''''+'%'+Trim(EditFilter.Text)+'%'+'''';
    gFilterWhere:= gFilterWhere+ ' or deviceid LIKE '+''''+'%'+Trim(EditFilter.Text)+'%'+'''';
    gFilterWhere:= gFilterWhere+ ' or station_addr LIKE '+''''+'%'+Trim(EditFilter.Text)+'%'+'''';
    gFilterWhere:= gFilterWhere+ ' or cell_no LIKE '+''''+'%'+Trim(EditFilter.Text)+'%'+'''';
    gFilterWhere:= ' and ('+gFilterWhere+')';
  end;
  //change:='';
  gAlarmStatusWhere:=' ';
  ShowMasterAlarmOnline;
  gFilterWhere:= '';
  {CDS_AlarmMaster.Filtered:= false;
  CDS_AlarmMaster.Filter:= ' bts_name LIKE '+''''+'%杭州省医药工业公司%'+'''';
  CDS_AlarmMaster.Filtered:= true;
  showmessage(inttostr(CDS_AlarmMaster.RecordCount));}
end;

procedure TFormAlarmTracker.AddFlowField(aView: TcxGridDBTableView);
begin
  AddViewField(aView,'operatename','流程环节',120);
  AddViewField(aView,'stationname','岗位名称',65);
  AddViewField(aView,'operatorname','操作人');
  AddViewField(aView,'mobilephone','联系电话',120);
  AddViewFieldMemo(aView,'flowinformation','处理说明',5,300);
  AddViewField(aView,'operatetime','操作时间',120);
  AddViewField(aView,'companyname','维护单位',65);
  AddViewField(aView,'trackid','操作流水号',65);
  AddViewField(aView,'cityid','地市编号',65);
  AddViewField(aView,'batchid','主障编号',65);
  AddViewField(aView,'alarmid','从障编号',65);
end;

procedure TFormAlarmTracker.dxDockPanel1AutoHideChanged(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= false;
end;

procedure TFormAlarmTracker.dxDockPanel1AutoHideChanging(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= true;
end;

procedure TFormAlarmTracker.OnUserPopup(Sender: TObject);
begin
   FMenuTake.Enabled:= ActionTake.Enabled;
   FMenuDeal.Enabled:= ActionDeal.Enabled;
   FMenuCancelDeal.Enabled:= ActionCancelDeal.Enabled;
   FMenuClear.Enabled:= ActionFaultRemove.Enabled;
   FMenuDel.Enabled:= ActionFaultDelete.Enabled;
   FMenuRevert.Enabled:= ActionRevert.Enabled;
   FMenuFeedTake.Enabled:= ActionRevertBack.Enabled;
   FMenuDifficulty.Enabled:= ActionFaultStay.Enabled;
   FMenuChangeSend.Enabled:= ActionFaultReturn.Enabled;
   FMenuRemark.Enabled:= ActionRemark.Enabled;
   FMenuPrint.Enabled:= ActionPrint.Enabled;
   FMenuCommit.Enabled:= ActionFaultSubmit.Enabled;
   FMenuComfirmOK.Enabled:= ActionFaultClear.Enabled;
   FMenuRejectOK.Enabled:= ActionCancelClear.Enabled;
   FMenuRefresh.Enabled:= ActionRefresh.Enabled;
end;

procedure TFormAlarmTracker.ActionUseable(aCurrNodeCode: integer);
begin
  ActionTake.Enabled:= false;
  ActionDeal.Enabled:= false;
  ActionCancelDeal.Enabled:= false;
  ActionRevert.Enabled:= false;
  ActionCancelClear.Enabled:= false;
  ActionFaultRemove.Enabled:= false;
  ActionFaultDelete.Enabled:= false;
  ActionFaultSubmit.Enabled:= false;
  ActionFaultClear.Enabled:= false;
  ActionFaultReturn.Enabled:= false;
  ActionFaultStay.Enabled:= false;
  ActionRemark.Enabled:= false;
  ActionRevertBack.Enabled:= false;
  ActionPrint.Enabled:= false;
  ActionRefresh.Enabled:= false;

  FMenuInputCause.Enabled:= false;
  FMenuInputRepair.Enabled:= false;

  case aCurrNodeCode of
    1: begin
         if FMenuTake.Visible then
           ActionTake.Enabled:= true;
         if FMenuDeal.Visible then
           ActionDeal.Enabled:= true;
         if FMenuRevert.Visible then
           ActionRevert.Enabled:= true;
         if FMenuClear.Visible then
           ActionFaultRemove.Enabled:= true;

         FMenuInputCause.Enabled:= true;
         FMenuInputRepair.Enabled:= true;

         if FMenuDel.Visible then
           ActionFaultDelete.Enabled:= true;
         if FMenuRemark.Visible then
           ActionRemark.Enabled:= true;
         if FMenuPrint.Visible then
           ActionPrint.Enabled:= true;
         if FMenuChangeSend.Visible then
           ActionFaultReturn.Enabled:= true;
         if FMenuRefresh.Visible then
           ActionRefresh.Enabled:= true;
    end;
    2, 9: begin
         if FMenuDeal.Visible then
           ActionDeal.Enabled:= true;
         if FMenuRevert.Visible then
           ActionRevert.Enabled:= true;
         if FMenuClear.Visible then
           ActionFaultRemove.Enabled:= true;

         FMenuInputCause.Enabled:= true;
         FMenuInputRepair.Enabled:= true;

         if FMenuDel.Visible then
           ActionFaultDelete.Enabled:= true;
         if FMenuRemark.Visible then
           ActionRemark.Enabled:= true;
         if FMenuPrint.Visible then
           ActionPrint.Enabled:= true;
         if FMenuChangeSend.Visible then
           ActionFaultReturn.Enabled:= true;
         if FMenuRefresh.Visible then
           ActionRefresh.Enabled:= true;
    end;
    3: begin
         if FMenuCancelDeal.Visible then
           ActionCancelDeal.Enabled:= true;
         if FMenuRevert.Visible then
           ActionRevert.Enabled:= true;
         if FMenuClear.Visible then
           ActionFaultRemove.Enabled:= true;

        // FMenuInputCause.Enabled:= true;
         //FMenuInputRepair.Enabled:= true;

         if FMenuDel.Visible then
           ActionFaultDelete.Enabled:= true;
         if FMenuRemark.Visible then
           ActionRemark.Enabled:= true;
         if FMenuPrint.Visible then
           ActionPrint.Enabled:= true;
         if FMenuChangeSend.Visible then
           ActionFaultReturn.Enabled:= true;
         if FMenuRefresh.Visible then
           ActionRefresh.Enabled:= true;
    end;
    4: begin
         if FMenuClear.Visible then
           ActionFaultRemove.Enabled:= true;

         FMenuInputCause.Enabled:= true;
         FMenuInputRepair.Enabled:= true;

         if FMenuDel.Visible then
           ActionFaultDelete.Enabled:= true;
         if FMenuRemark.Visible then
           ActionRemark.Enabled:= true;
         if FMenuPrint.Visible then
           ActionPrint.Enabled:= true;
         if FMenuChangeSend.Visible then
           ActionFaultReturn.Enabled:= true;
         if FMenuFeedTake.Visible then
           ActionRevertBack.Enabled:= true;
         if FMenuDifficulty.Visible then
           ActionFaultStay.Enabled:= true;
         if FMenuRefresh.Visible then
           ActionRefresh.Enabled:= true;
    end;
    5: begin
         if FMenuCommit.Visible then
           ActionFaultSubmit.Enabled:= true;
         if FMenuRefresh.Visible then
           ActionRefresh.Enabled:= true;
    end;
    6: begin
         if FMenuComfirmOK.Visible then
           ActionFaultClear.Enabled:= true;
         if FMenuRejectOK.Visible then
           ActionCancelClear.Enabled:= true;
         if FMenuRefresh.Visible then
           ActionRefresh.Enabled:= true;
    end
    else
    begin
      if FMenuRefresh.Visible then
        ActionRefresh.Enabled:= true;
    end;
  end;
end;

procedure TFormAlarmTracker.ActionPrintExecute(Sender: TObject);
begin
  showmessage('未有派修单样式');
end;


{发送消息}
procedure TFormAlarmTracker.SendMessageToServer(aComid: integer);
var
  userdata: RUserData;
  cmd: RCmd;
begin
  try
    if not FTCPClient.FConeected then
       FTCPClient.Connect;
    if FTCPClient.FConeected then
    begin
      cmd.command := aComid;
      cmd.NodeCode := gCurrNodeCode;  //当前告警状态节点编码
      FTCPClient.FTCPClient.WriteBuffer(cmd,sizeof(Rcmd));
    end;
  except
    Application.MessageBox('发送实时消息失败,' + #13 + '请检查应用服务器的实时消息服务是否启动!', '警告', MB_OK + MB_ICONINFORMATION);
  end;
end;


procedure TFormAlarmTracker.FormResize(Sender: TObject);
begin
  ResizeFilter;
end;

procedure TFormAlarmTracker.ResizeFilter;
begin
  EditFilter.Left:= dxBarManager1Bar7.DockedLeft+10;
  if self.PanelTitle.Visible then
    EditFilter.Top:= dxBarManager1Bar7.DockedTop+62
  else
    EditFilter.Top:= dxBarManager1Bar7.DockedTop+62-PanelTitle.Height;
  EditFilter.Width:= dxBarEditFilters.Width;
  EditFilter.BringToFront;
end;

procedure TFormAlarmTracker.Timer1Timer(Sender: TObject);
begin
  sleep(1);
  ResizeFilter;
  Timer1.Enabled:= false;
end;

procedure TFormAlarmTracker.dxBarManager1Docking(Sender: TdxBar;
  Style: TdxBarDockingStyle; DockControl: TdxDockControl;
  var CanDocking: Boolean);
begin
  Timer1.Enabled:= true;
end;

procedure TFormAlarmTracker.EditFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    dxBarButton27Click(self);
end;

{procedure TFormAlarmTracker.ComboBoxCompanyChange(Sender: TObject);
var
  lFilterStr : string;
begin
  if trim(ComboBoxCompany.Text)='' then
  begin
    lFilterStr:= '';
  end
  else
  begin
    lFilterStr:= ' companyname='''+ComboBoxCompany.Text+'''';
  end;
  CDS_Flow.Filtered:= false;
  CDS_Flow.Filter:= lFilterStr;
  CDS_Flow.Filtered:= true;
end;}

procedure TFormAlarmTracker.ActionRefreshExecute(Sender: TObject);
begin
  cxTreeView1Change(self,cxTreeView1.Selected);
  NewSetTreeNodeDisplayName;
end;

procedure TFormAlarmTracker.ActionAutofreshExecute(Sender: TObject);
begin
  if ActionAutofresh.Caption='自动刷新' then
  begin
    ActionAutofresh.Caption:= '锁定刷新';
    ActionAutofresh.Hint:= '锁定刷新';
  end
  else
  if ActionAutofresh.Caption='锁定刷新' then
  begin
    ActionAutofresh.Caption:= '自动刷新';
    ActionAutofresh.Hint:= '自动刷新';
  end;

  if ActionAutofresh.Caption= '锁定刷新' then
    TimerAutofresh.Enabled:= true
  else
    TimerAutofresh.Enabled:= false;
  //因为类型是bschecked，所以失去焦点
  self.Timer1.Enabled:= true;
end;

procedure TFormAlarmTracker.TimerAutofreshTimer(Sender: TObject);
begin
  //回调，判断是否活动窗体
  //gDllMsgCall(FormAlarmTracker,5,'','');
  //if gPublicParam.IsFormOnTop then
  //begin
    ActionRefreshExecute(self);
  //end;
end;

procedure TFormAlarmTracker.RefreshUnreceiveTreeNode(aTreeNode: TTreeNode);
var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
  lRecordCount: Integer;
begin
  if (aTreeNode<>nil) and (aTreeNode.Data<>nil)
      and (TNodeParam(aTreeNode.Data).NodeType=31) and (TNodeParam(aTreeNode.Data).NodeCode<>0) then
  begin
    lSqlStr:= ' select count(*) as RecordCount from fault_master_online_view a where 1=1' +
              TNodeParam(aTreeNode.Data).SetValue + gGlobalWhere  ;
    lClientDataSet:= TClientDataSet.Create(nil);
    try
      with lClientDataSet do
      begin
        Close;
        ProviderName:='DataSetProvider';
        Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
        lRecordCount:= FieldByName('RecordCount').AsInteger;
      end;

      aTreeNode.text:= TNodeParam(aTreeNode.Data).DisplayName +'('+inttostr(lRecordCount)+')'
    finally
      lClientDataSet.Free;
    end;
  end;
end;

procedure TFormAlarmTracker.NewSetTreeNodeDisplayName;
var
  i: Integer;
begin
  for i:=0 to cxTreeView1.Items.Count-1 do
  begin
    RefreshUnreceiveTreeNode(cxTreeView1.items[i]);
  end;
end;

procedure TFormAlarmTracker.Image1DblClick(Sender: TObject);
begin
  PanelTitle.Visible:= false;
  self.Timer1.Enabled:= true;
end;

procedure TFormAlarmTracker.IniFormParams;
begin
  //设置自动刷新
  TimerAutofresh.Enabled:= ActionAutofresh.Caption='锁定刷新';


  gActiveGridView:=[];
  gActiveDockPanel:= [] ;
  gChangedDockPanel:= [];
  gClick_RecordChanged:= false;
  gClick_Cityid:= 0;
  gClick_Companyid:= 0;
  gClick_Batchid:= 0;
  dxDockPanel4.OnVisibleChanged:= dxDockPanelVisibleChanged;
  dxDockPanel5.OnVisibleChanged:= dxDockPanelVisibleChanged;
  dxDockPanel6.OnVisibleChanged:= dxDockPanelVisibleChanged;
end;

procedure TFormAlarmTracker.dxDockPanelVisibleChanged(
  Sender: TdxCustomDockControl);
begin
  if (gClick_Batchid=0) and (gClick_Companyid=0) and (gClick_Cityid=0) then
  begin
    //Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  if TdxDockPanel(Sender) = dxDockPanel4 then
    if TdxDockPanel(Sender).Visible then
      gActiveDockPanel:= gActiveDockPanel+ [wd_Active_ParaDetail]
    else
      gActiveDockPanel:= gActiveDockPanel- [wd_Active_ParaDetail]
  else
  if TdxDockPanel(Sender) = dxDockPanel5 then
    if TdxDockPanel(Sender).Visible then
      gActiveDockPanel:= gActiveDockPanel+ [wd_Active_ParaCompany]
    else
      gActiveDockPanel:= gActiveDockPanel- [wd_Active_ParaCompany]
  else
  if TdxDockPanel(Sender) = dxDockPanel6 then
    if TdxDockPanel(Sender).Visible then
      gActiveDockPanel:= gActiveDockPanel+ [wd_Active_ParaFlow]
    else
      gActiveDockPanel:= gActiveDockPanel- [wd_Active_ParaFlow];

  if (wd_Active_ParaDetail in gActiveDockPanel) and not (wd_Changed_ParaDetail in gChangedDockPanel) then
  begin
    //showmessage('wd_Active_ParaDetail');
    ShowDetailAlarmOnline(gClick_Batchid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:= gChangedDockPanel+ [wd_Changed_ParaDetail];
  end;
  if (wd_Active_ParaCompany in gActiveDockPanel) and not (wd_Changed_ParaCompany in gChangedDockPanel) then
  begin
    //showmessage('wd_Active_ParaCompany');
    ShowMasterAlarmOfCompany(gClick_Batchid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:= gChangedDockPanel+ [wd_Changed_ParaCompany];
  end;
  if (wd_Active_ParaFlow in gActiveDockPanel) and not (wd_Changed_ParaFlow in gChangedDockPanel) then
  begin
    //showmessage('wd_Active_ParaFlow');
    ShowFlowRecOnline(gClick_Batchid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:= gChangedDockPanel+ [wd_Changed_ParaFlow];
  end;
end;

procedure TFormAlarmTracker.cxGridAlarmMasterDBTableView1DblClick(
  Sender: TObject);
var
  lisrevertback, lisreadedback,
  lCityid, lCompanyid, lBatchid: integer;
  lSqlstr: string;
  lVariant: variant;
  lisrevertback_Index, lisreadedback_Index,
  lCityid_Index, lCompanyid_Index, lBatchid_Index: integer;
  lRecordIndex: integer;
begin
  /////////////////////

  Screen.Cursor := crHourGlass;
  cxGridAlarmMasterDBTableView1.DataController.BeginFullUpdate;
  try
    if not CheckRecordSelected(cxGridAlarmMasterDBTableView1) then
      Exit;
    try
      lisrevertback_Index:= cxGridAlarmMasterDBTableView1.GetColumnByFieldName('isrevertback').Index;
      lisreadedback_Index:= cxGridAlarmMasterDBTableView1.GetColumnByFieldName('isreadedback').Index;
      lCityid_Index:= cxGridAlarmMasterDBTableView1.GetColumnByFieldName('cityid').Index;
      lCompanyid_Index:= cxGridAlarmMasterDBTableView1.GetColumnByFieldName('companyid').Index;
      lBatchid_Index:= cxGridAlarmMasterDBTableView1.GetColumnByFieldName('batchid').Index;
      
      lRecordIndex:= cxGridAlarmMasterDBTableView1.DataController.GetSelectedRowIndex(0);
      lRecordIndex:= cxGridAlarmMasterDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
    except
      exit;
    end;
    lisrevertback:= cxGridAlarmMasterDBTableView1.DataController.GetValue(lRecordIndex,lisrevertback_Index);
    lisreadedback:= cxGridAlarmMasterDBTableView1.DataController.GetValue(lRecordIndex,lisreadedback_Index);

    if lisrevertback=1 then
    begin
      lCityid:= cxGridAlarmMasterDBTableView1.DataController.GetValue(lRecordIndex,lCityid_Index);
      lCompanyid:= cxGridAlarmMasterDBTableView1.DataController.GetValue(lRecordIndex,lCompanyid_Index);
      lBatchid:= cxGridAlarmMasterDBTableView1.DataController.GetValue(lRecordIndex,lBatchid_Index);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fault_master_online t set t.isrevertback=0'+
                ' where t.cityid='+inttostr(lCityid)+' and t.companyid='+inttostr(lCompanyid)+
                ' and t.batchid='+inttostr(lBatchid);
      lVariant[0]:= VarArrayOf([lSqlstr]);
      gTempInterface.ExecBatchSQL(lVariant);
      cxGridAlarmMasterDBTableView1.DataController.setvalue(lRecordIndex, lisrevertback_Index,'0');
    end;
    if lisreadedback=1 then
    begin
      lCityid:= cxGridAlarmMasterDBTableView1.DataController.GetValue(lRecordIndex,lCityid_Index);
      lCompanyid:= cxGridAlarmMasterDBTableView1.DataController.GetValue(lRecordIndex,lCompanyid_Index);
      lBatchid:= cxGridAlarmMasterDBTableView1.DataController.GetValue(lRecordIndex,lBatchid_Index);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fault_master_online t set t.isreadedback=0'+
                ' where t.cityid='+inttostr(lCityid)+' and t.companyid='+inttostr(lCompanyid)+
                ' and t.batchid='+inttostr(lBatchid);
      lVariant[0]:= VarArrayOf([lSqlstr]);
      gTempInterface.ExecBatchSQL(lVariant);
      cxGridAlarmMasterDBTableView1.DataController.setvalue(lRecordIndex, lisreadedback_Index,'0');
    end;
  finally
    cxGridAlarmMasterDBTableView1.DataController.EndFullUpdate;
    Screen.Cursor := crDefault;
  end;
end;

function TFormAlarmTracker.DeviceCheck(aDevID, aCoDevID, aCityID: Integer;
              var aDevCaption, aDevAddr, aGatherName: string): Integer;
var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
  lResult: Byte;
begin
  Result:= -1;
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lSqlStr:= 'select * from'      +
                '(select t1.cityid,t1.deviceid,t2.fan_id,t1.bts_name,t1.station_addr' +
                '   from fms_device_info t1' +
                '  inner join fms_cell_device_info t2 on t1.cityid=t2.cityid and t1.deviceid=t2.bts_label' +
                ' union all' +
                ' select t3.cityid,t3.deviceid,nvl(t4.fan_id,0) as fan_id,t3.bts_name,t3.station_addr' +
                '   from fms_device_info t3' +
                '   left join fms_cell_device_info t4 on 1=2' +
                ' )' +
                ' where deviceid=' + IntToStr(aDevID) +
                ' and fan_id=' + IntToStr(aCoDevID) +
                ' and cityid=' + IntToStr(aCityID);
      ProviderName:= 'dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then
        lResult:= $00
      else
      begin
        lResult:= $10;
        aDevCaption:= FieldByName('bts_name').AsString;
        aDevAddr:= FieldByName('station_addr').AsString;
      end;
        

      Close;
      lSqlStr:= 'select * from' +
                '(select m.cityid,deviceid,m.devicegatherid,m.devicegathername' +
                '   from fms_devicegather_info m' +
                '  inner join FMS_DEVICEGATHER_DETAIL n on m.cityid=n.cityid and m.devicegatherid=n.devicegatherid' +
                ' )' +
                ' where deviceid=' + IntToStr(aDevID) +
                ' and cityid=' + IntToStr(aCityID);
      ProviderName:= 'dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then
        lResult:= lResult+$00
      else
      begin
        lResult:= lResult+$01;
        aGatherName:= FieldByName('devicegathername').AsString;
      end;

    end;
  finally
    Result:= lResult;
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmTracker.cxGridFlowDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  lCityid_Index, lTrackid_Index: integer;
  lCityid, lTrackid: string;
begin
  try
    lCityid_Index:=TcxGridDBTableView(Sender).GetColumnByFieldName('CITYID').Index;
    lTrackid_Index:= TcxGridDBTableView(Sender).GetColumnByFieldName('TRACKID').Index;
  except
    exit;
  end;
  if varisnull(AViewInfo.GridRecord.Values[lCityid_Index]) then
    lCityid:= ''
  else
    lCityid:= AViewInfo.GridRecord.Values[lCityid_Index];
  if varisnull(AViewInfo.GridRecord.Values[lTrackid_Index]) then
    lTrackid:= ''
  else
    lTrackid:= AViewInfo.GridRecord.Values[lTrackid_Index];
  if gFlowColorList.IndexOf(lCityid+'&'+lTrackid)> -1 then
    ACanvas.Brush.Color:= $0081A0FE;
end;

procedure TFormAlarmTracker.GetGridColor;
var
  lIniPath: string;
  ini: TIniFile;
begin
  lIniPath:= ExtractFilePath(Application.ExeName)+'ProjectCFMS_Client.ini';
  if FileExists(lIniPath) then
  begin
    ini:= TIniFile.Create(lIniPath);
    try
      gColorNoReceived:= StringToColor(ini.ReadString('AlarmTrackerColor','NoReceivedColor','$004080FF'));
      gColorReceived:= StringToColor(ini.ReadString('AlarmTrackerColor','ReceivedColor','$00FF80FF'));
      gColorRevert:= StringToColor(ini.ReadString('AlarmTrackerColor','RevertColor','clMoneyGreen'));
      cxColorComboBoxNoReceived.ColorValue:= gColorNoReceived;
      cxColorComboBoxReceived.ColorValue:= gColorReceived;
      cxColorComboBoxRevert.ColorValue:= gColorRevert;
    finally
      ini.Free;
    end;
  end;
end;


procedure TFormAlarmTracker.cxColorComboBoxNoReceivedPropertiesChange(
  Sender: TObject);
var
  lIniPath: string;
  ini: TIniFile;
begin
  lIniPath:= ExtractFilePath(Application.ExeName)+'ProjectCFMS_Client.ini';
  ini:= TIniFile.Create(lIniPath);
  try
    ini.WriteString('AlarmTrackerColor','NoReceivedColor',ColorToString(cxColorComboBoxNoReceived.ColorValue));
    gColorNoReceived:= cxColorComboBoxNoReceived.ColorValue;
    cxGridAlarmMasterDBTableView1.DataController.Refresh;
  finally
    ini.Free;
  end;
end;

procedure TFormAlarmTracker.cxColorComboBox2PropertiesChange(
  Sender: TObject);
var
  lIniPath: string;
  ini: TIniFile;
begin
  lIniPath:= ExtractFilePath(Application.ExeName)+'ProjectCFMS_Client.ini';
  ini:= TIniFile.Create(lIniPath);
  try
    ini.WriteString('AlarmTrackerColor','ReceivedColor',ColorToString(cxColorComboBoxReceived.ColorValue));
    gColorReceived:= cxColorComboBoxReceived.ColorValue;
    cxGridAlarmMasterDBTableView1.DataController.Refresh;
  finally
    ini.Free;
  end;
end;

procedure TFormAlarmTracker.cxColorComboBox3PropertiesChange(
  Sender: TObject);
var
  lIniPath: string;
  ini: TIniFile;
begin
  lIniPath:= ExtractFilePath(Application.ExeName)+'ProjectCFMS_Client.ini';
  ini:= TIniFile.Create(lIniPath);
  try
    ini.WriteString('AlarmTrackerColor','RevertColor',ColorToString(cxColorComboBoxRevert.ColorValue));
    gColorRevert:= cxColorComboBoxRevert.ColorValue;
    cxGridAlarmMasterDBTableView1.DataController.Refresh;
  finally
    ini.Free;
  end;
end;

end.
