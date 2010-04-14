unit Ut_MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, Tabs, ComCtrls, Menus, XPStyleActnCtrls,IdGlobal,
  ActnList, ActnMan, ToolWin, ActnCtrls, ActnMenus, ImgList, ActnColorMaps,
  WinSkinData, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, ExtCtrls, cxControls, cxSplitter, DBThreeStateTree, Ut_MTSTreeHelper,
  cxGraphics, cxLookAndFeelPainters, cxButtons, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, StringUtils, DBClient, LayerSvrUnit, dxStatusBar,
  cxProgressBar, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel,
  dxSkinCoffee, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinSilver, dxSkinStardust,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinXmas2008Blue,
  dxSkinsdxStatusBarPainter, UnitRingPopupWindows;

//公用参数结构体
type
  TPublicParameter = record
    userid :integer;      //用户编号
    userno :string;       //用户帐号
    cityid :integer;      //用户所属地市编号
    areaid :integer;      //用户归属郊县
    ServerIP :String;     //服务器IP地址
    MsgPort :integer;     //控制信道端口
    DBPort :integer;      //数据信道端口
    AlarmShowDay :integer;//告警监控界面默认历史告警天数
    PriveAreaidStrs: string;
  end;
    {业务处理消息数据类型}
  Rcmd = record
    command: integer;
  end;
  {用户信息类型}
  Ruserdata = record
    userid :integer;
    userno :String[50];
    cityid :integer;
    AreaId :integer;
  end;
  {------------------------------通讯客户端消息程-------------------------}
  // 1 : 派障  2：排障 
  TClientMessageThread = class(TThread)
    private
      cmd: Rcmd;
      procedure HandleMessage;
    protected
      constructor Create();
      procedure Execute; override;
  end;
type
  TFm_MainForm = class(TForm)
    TabSet: TTabSet;
    ActionManager1: TActionManager;
    A3_Logout: TAction;
    A3_ModifyPassWord: TAction;
    A3_CLose: TAction;
    PopupMenu1: TPopupMenu;
    NRestore: TMenuItem;
    NMax: TMenuItem;
    NMin: TMenuItem;
    NClose: TMenuItem;
    SkinData1: TSkinData;
    MainMenu1: TMainMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    ToolBar1: TToolBar;
    ToolBtnSetup: TToolButton;
    ToolButton7: TToolButton;
    ToolButton1: TToolButton;
    ToolBtnMJ: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ImageList2: TImageList;
    ToolButton2: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    N17: TMenuItem;
    IdClient: TIdTCPClient;
    A4_BuildInfo: TAction;
    A4_SwitchInfo: TAction;
    A4_ApInfo: TAction;
    A4_linkerInfo: TAction;
    A4_MtuInfo: TAction;
    A4_CsInfo: TAction;
    A1_AlarmMonitor: TAction;
    A1_AlarmSearch: TAction;
    A2_CityInfo: TAction;
    A2_UserInfo: TAction;
    A2_DicInfo: TAction;
    A2_AlarmContent: TAction;
    A1_AlarmTest: TAction;
    A2_TestParamSet: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    MTU1: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    BarImageList: TImageList;
    ToolButton9: TToolButton;
    ToolButton17: TToolButton;
    ToolButton8: TToolButton;
    N22: TMenuItem;
    A1_AlarmTestModel: TAction;
    Panel1: TPanel;
    cxSplitter1: TcxSplitter;
    PanelLinktree: TPanel;
    Splitter1: TSplitter;
    GroupBoxTrees: TGroupBox;
    TreeViewSub: TTreeView;
    TreeViewAll: TTreeView;
    PopupMenu2: TPopupMenu;
    N23: TMenuItem;
    Panel2: TPanel;
    cxComboBoxSearch: TcxComboBox;
    cxButtonSearch: TcxButton;
    ActionCDMA: TAction;
    NCDMA: TMenuItem;
    Splitter2: TSplitter;
    PanelStatTree: TPanel;
    N24: TMenuItem;
    N_LinkTree: TMenuItem;
    N_StatTree: TMenuItem;
    ActionLinkTree: TAction;
    ActionStatTree: TAction;
    ActionMtuPlanSet: TAction;
    MTU2: TMenuItem;
    A1_AlarmTestModeMonitorl: TAction;
    N25: TMenuItem;
    N26: TMenuItem;
    ToolButton16: TToolButton;
    ImageList1: TImageList;
    StatusBar1: TdxStatusBar;
    cxProgressBar1: TcxProgressBar;
    A1_AlarmWait: TAction;
    N27: TMenuItem;
    Nwireless: TMenuItem;
    NTestParticular: TMenuItem;
    NBuildingParticular: TMenuItem;
    NMtuParticular: TMenuItem;
    ImageListStatusTree: TImageList;
    NDRSInfo: TMenuItem;
    NGISPosition: TMenuItem;
    NDRSConfig: TMenuItem;
    RBBuilding: TRadioButton;
    RBDRS: TRadioButton;
    ActionDRS: TAction;
    N28: TMenuItem;
    N29: TMenuItem;
    A2_DRS_Alarm_mgr: TAction;
    ActionDRSInfo: TAction;
    N30: TMenuItem;
    TreeViewDRS: TTreeView;
    PanelDRS: TPanel;
    Splitter3: TSplitter;
    DRS_AlarmQuery: TAction;
    N31: TMenuItem;
    ActionRoundSearch: TAction;
    N32: TMenuItem;
    TimerRing: TTimer;
    ActionUserCustomSet: TAction;
    N33: TMenuItem;
    ActionRingSet: TAction;
    N34: TMenuItem;

    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure NCloseClick(Sender: TObject);
    procedure NMinClick(Sender: TObject);
    procedure NMaxClick(Sender: TObject);
    procedure NRestoreClick(Sender: TObject);
    procedure A3_CLoseExecute(Sender: TObject);
    procedure A3_ModifyPassWordExecute(Sender: TObject);
    procedure A3_LogoutExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure A1_AlarmMonitorExecute(Sender: TObject);
    procedure A2_CityInfoExecute(Sender: TObject);
    procedure A2_UserInfoExecute(Sender: TObject);
    procedure A4_BuildInfoExecute(Sender: TObject);
    procedure A2_AlarmContentExecute(Sender: TObject);
    procedure A4_SwitchInfoExecute(Sender: TObject);
    procedure A4_ApInfoExecute(Sender: TObject);
    procedure A4_MtuInfoExecute(Sender: TObject);
    procedure A4_linkerInfoExecute(Sender: TObject);
    procedure A2_DicInfoExecute(Sender: TObject);
    procedure A1_AlarmTestExecute(Sender: TObject);
    procedure A4_CsInfoExecute(Sender: TObject);
    procedure A2_TestParamSetExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure A1_AlarmSearchExecute(Sender: TObject);
    procedure A1_AlarmTestModelExecute(Sender: TObject);
    procedure TreeViewAllMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeViewSubMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeViewAllCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure N23Click(Sender: TObject);
    procedure cxButtonSearchClick(Sender: TObject);
    procedure cxComboBoxSearchPropertiesChange(Sender: TObject);
    procedure ActionCDMAExecute(Sender: TObject);
    procedure ActionLinkTreeExecute(Sender: TObject);
    procedure ActionStatTreeExecute(Sender: TObject);
    procedure ActionMtuPlanSetExecute(Sender: TObject);
    procedure A1_AlarmTestModeMonitorlExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StatusBar1Panels3DrawPanel(Sender: TdxStatusBarPanel;
      ACanvas: TcxCanvas; const ARect: TRect; var ADone: Boolean);
    procedure A1_AlarmWaitExecute(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure NwirelessClick(Sender: TObject);
    procedure NTestParticularClick(Sender: TObject);
    procedure NBuildingParticularClick(Sender: TObject);
    procedure NMtuParticularClick(Sender: TObject);
    procedure NDRSInfoClick(Sender: TObject);
    procedure NDRSConfigClick(Sender: TObject);
    procedure ActionDRSExecute(Sender: TObject);
    procedure A2_DRS_Alarm_mgrExecute(Sender: TObject);
    procedure ActionDRSInfoExecute(Sender: TObject);
    procedure DRS_AlarmQueryExecute(Sender: TObject);
    procedure ActionRoundSearchExecute(Sender: TObject);
    procedure NGISPositionClick(Sender: TObject);
    procedure TimerRingTimer(Sender: TObject);
    procedure ActionUserCustomSetExecute(Sender: TObject);
    procedure ActionRingSetExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FRingFileName: WideString;  //响铃文件名
    FormRingPopupWindowsSend, FormRingPopupWindowsResend: TFormRingPopupWindows;
    LinkTree :TDBThreeStateTree;
    StatTree :TDBThreeStateTree;
    DRSStatTree: TDBThreeStateTree;
    FPathListIN, FPathListOUT: TStringList;
    procedure LinkTreeMouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Integer);
    procedure StatTreeMouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Integer);
    procedure MarkByAPAndCS(Buildingid,apid,csid,cdmaid:integer);
    procedure CancelDraw;
    function ConnectAppServer:boolean;
    procedure InitPublicParam(lUserNo:String);
    procedure InitPriv;
    procedure InitUserInfo(lUserNo: string); //通过actionmanager控制权限
    procedure SendMessageToServer(ComID: integer);
    { Private declarations }
    procedure AutoVisiableTree;
    function LocateBuilding(aBuildingName :String; aTree:TTreeView):boolean;
    procedure GetNodeList(aNodeType: TNodeType;aNodeList :TStringList; aTree:TTreeView);
    procedure ShowAlarmCounts;
    //加载用户设置显示树图
    procedure LoadUserTreeSet;
    procedure SaveUserTreeSet;
    procedure ThreadOnEvent(Sender:TObject;EventLevel:Integer;EventMsg:string);
    procedure ThreadOnProgress(Sender:TObject;Position,Max:integer);
    function GetLoacalRingWave(aFileName: string): string;
    procedure GetPathListIN(aDataSet: TClientDataSet; aPathList: TStringList);
    procedure GetPathListOUT(aDataSet: TClientDataSet; aPathList: TStringList);
  public
    FLayerSvr:TLayerSvrThread;
    FThreadFlag:boolean;
    PublicParam :TPublicParameter;
    procedure AddToTab(Form: TForm);
    procedure SetTabIndex(Form: TForm);
    procedure DeleteTab(Form: TForm);
    function assginTab(Form: TForm):Boolean;
    procedure HandleMessage1;
    procedure HandleMessage2;
    procedure HandleMessage3;

    procedure CreateCustomLayer(aLayerSet:TLayerTypeSet);
    procedure DrawAlarmRecordCounts(aCaption, aValue: string);
    { Public declarations }
  end;

var
  Fm_MainForm: TFm_MainForm;
  ClientThread: TClientMessageThread;

implementation

uses FrmLogin, Ut_DataModule, FrmChangePwd,Ut_ServerSet,Ut_CityInfoManage,
     Ut_UserInfoMag,Ut_AlarmContent, Frm_building_info, UnitSwitchInfo,UnitCSInfoMag,
     Unitlinkmachineinfo,Ut_DataDicMag, Ut_AlarmTest,
     Ut_TestParamSet,Ut_AlarmQuery,Ut_Common, UntAlarmTestModel,  
     UnitMtuPlanSet, UnitAlarmMonitor, UnitAlarmWait, UnitTestParticular,
     UnitCDMASource, UnitMTUINFO, UnitAPInfo, UnitBuildingParticular,
     UnitWirelessParticular, UntDRSConfig, UnitDRS_Alarm_mgr, UnitDRSInfoMgr,
     Unit_DRS_AlarmQuery, UnitDRSRoundSearch, UnitGlobal, UnitDRSParticular,
  UnitUserCustomSet, UnitRingMgr, UntDRSComQuery, UnitDRSSearch;

{$R *.dfm}

{ TFormMainSMA }

procedure TFm_MainForm.AddToTab(Form: TForm);
begin
  TabSet.Tabs.AddObject(Form.Caption,Form);
  TabSet.TabIndex:=TabSet.Tabs.IndexOf(Form.Caption);
end;
function TFm_MainForm.assginTab(Form: TForm): Boolean;
var
  i : Integer;
begin
  Result := False;
  for i:=0 to TabSet.Tabs.Count-1 do
  begin
    if TabSet.Tabs.Objects[i]= Form then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TFm_MainForm.AutoVisiableTree;
begin
  if (TabSet.Tabs.Count=0) or (ActiveMDIChild=nil)
    or (ActiveMDIChild = FormAlarmMonitor) then
  begin
    TreeViewAll.Visible := true;
    TreeViewSub.Visible := false;
    TreeViewDRS.Visible := False;
    PanelStatTree.Visible := ActionStatTree.Checked;
    Splitter2.Visible := ActionStatTree.Checked;
    PanelLinktree.Visible := ActionLinkTree.Checked;
    Splitter1.Visible := ActionLinkTree.Visible;
    PanelDRS.Visible  := False;
    Splitter3.Visible := False;

    ActionLinkTree.Enabled:= true;
    ActionStatTree.Enabled:= true;
  end else
  begin
    if (ActiveMDIChild = FrmDRSConfig) or (ActiveMDIChild = FormDRSInfoMgr) then
    begin
      TreeViewAll.Visible := false;
      TreeViewSub.Visible := False;
      TreeViewDRS.Visible := True;
      Splitter1.Visible := false;
      PanelLinktree.Visible := false;
      Splitter2.Visible := false;
      PanelStatTree.Visible := false;
      PanelDRS.Visible  := True;
      Splitter3.Visible := True;

      ActionLinkTree.Enabled:= false;
      ActionStatTree.Enabled:= false;
    end
    else
    begin
      TreeViewAll.Visible := false;
      TreeViewSub.Visible := true;
      TreeViewDRS.Visible := False;
      Splitter1.Visible := false;
      PanelLinktree.Visible := false;
      Splitter2.Visible := false;
      PanelStatTree.Visible := false;
      PanelDRS.Visible  := False;
      Splitter3.Visible := False;

      ActionLinkTree.Enabled:= false;
      ActionStatTree.Enabled:= false;
    end;
  end;
end;

procedure TFm_MainForm.SaveUserTreeSet;
var
  lFlag: integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if ActionStatTree.Checked then
    lFlag:= 1
  else
    lFlag:= 0;
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,64]),0);
    edit;
    Fieldbyname('setvalue').Value:= lFlag;
    post;
  end;
  try
    vCDSArray[0]:=Dm_MTS.cds_common;
    vDeltaArray:=RetrieveDeltas(vCDSArray);
    vProviderArray:=RetrieveProviders(vCDSArray);
    if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
      SysUtils.Abort;
  except
  end;
end;

procedure TFm_MainForm.SendMessageToServer(ComID: integer);
var
  userdata: Ruserdata;
  cmd: Rcmd;
  Buf :TIdBytes;
begin
  try
    if not IdClient.Connected then
       IdClient.Connect();
    if IdClient.Connected then
    begin
      cmd.command := ComID;
      userdata.userid := PublicParam.userid ;
      userdata.userno := PublicParam.userno;
      userdata.areaid :=PublicParam.areaid;
      userdata.cityid := PublicParam.cityid;
      Buf := RawToBytes(cmd,SizeOf(Rcmd));
      IdClient.IOHandler.Write(Buf);
      sleep(100);
      Buf := RawToBytes(userdata,SizeOf(Ruserdata));
      IdClient.IOHandler.Write(Buf);
    end;
  except
    Application.MessageBox('发送实时消息失败,' + #13 + '请检查应用服务器的实时消息服务是否启动!', '警告', MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TFm_MainForm.SetTabIndex(Form: TForm);
begin
  TabSet.TabIndex := TabSet.Tabs.IndexOf(Form.Caption);
end;

procedure TFm_MainForm.ShowAlarmCounts;
var
  Node:TTreeNode;
  lAreaCondition : String;
  lPriveCondition : String;
begin
  TreeViewAll.Selected:= TreeViewAll.Items[0];
  Node :=TreeViewAll.Selected;
  //连接器树
  if PanelLinktree.Visible then
  begin
    LinkTree.ClearAllItem;
    with Dm_Mts.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      case TNodeParam(node.Data).nodeType of
        BUILDING,WLANTYPE,PHSTYPE,CDMATYPE,MTUTYPE :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,9,TNodeParam(node.Data).BuildingId,
                                                                      TNodeParam(node.Data).BuildingId]),0);
                             end;
        SWITCH            :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,13,TNodeParam(node.Data).SwitchID,
                                                                      TNodeParam(node.Data).SwitchID]),0);
                             end;
        AP                :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,10,TNodeParam(node.Data).APID,
                                                                      TNodeParam(node.Data).APID]),0);
                             end;
        CS                :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,11,TNodeParam(node.Data).CSID,
                                                                      TNodeParam(node.Data).CSID]),0);
                             end;
        CDMASOURCE        :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,15,TNodeParam(node.Data).CDMAID,
                                                                      TNodeParam(node.Data).CDMAID]),0);
                             end;
      end;
      LinkTree.DBProperties.DataSet :=Dm_Mts.cds_common;
      LinkTree.DBProperties.ThreeState := false;
      LinkTree.FillTree(nil,-1,0);
      LinkTree.DBProperties.DataSet := nil;
      Close;
    end;
  end;
  //条件判断
  with PublicParam do
  begin
    if (cityid=0) and (areaid=0) then          //省级用户
    begin
      lPriveCondition := '';
    end
    else if (cityid<>0) and (areaid=0) then
    begin
      lPriveCondition := ' and cityid='+inttostr(PublicParam.cityid);
    end
    else if (cityid<>0) and (areaid<>0) then
    begin
      lPriveCondition := ' and areaid='+inttostr(PublicParam.areaid);
    end;
  end;
  case TNodeParam(node.Data).nodeType of  //室分点以下的，只显示其室分点的内容
    PROVINCE :  begin
                  lAreaCondition := '';
                end;
    CITY     :  begin
                  lAreaCondition := ' and cityid='+
                    inttostr(TNodeParam(node.Data).Cityid);
                end;
    AREA     :  begin
                  lAreaCondition := ' and areaid='+
                    inttostr(TNodeParam(node.Data).AreaId);
                end;
    SUBURB   :  begin
                  lAreaCondition := ' and suburbid='+
                    inttostr(TNodeParam(node.Data).Suburbid);
                end;
    BUILDING,WLANTYPE,PHSTYPE,CDMATYPE,MTUTYPE,DRSTYPE :
                begin
                  lAreaCondition := ' and buildingid='+
                    inttostr(TNodeParam(node.Data).BuildingId);
                end;
    SWITCH   :  begin
                  lAreaCondition := ' and buildingid='+
                    '(select buildingid from switch_info where switchid='+
                    inttostr(TNodeParam(node.Data).SwitchID)+')';
                end;
    AP       :  begin
                  lAreaCondition := ' and buildingid='+
                    '(select buildingid from switch_info'+
                    ' inner join ap_info on switch_info.switchid=ap_info.switchid'+
                    ' where ap_info.apid='+
                    inttostr(TNodeParam(node.Data).APID)+')';
                end;
    CS       :  begin
                  lAreaCondition := ' and buildingid='+
                    '(select buildingid from cs_info where csid='+
                    inttostr(TNodeParam(node.Data).CSID)+')';
                end;
    CDMASOURCE:  begin
                  lAreaCondition := ' and buildingid='+
                    '(select buildingid from cdma_info where cdmaid='+
                    inttostr(TNodeParam(node.Data).CDMAID)+')';
                end;
  end; 
  //统计树
  if PanelStatTree.Visible then
  begin
    StatTree.ClearAllItem;
    with Dm_Mts.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,23,lPriveCondition+lAreaCondition,lPriveCondition+lAreaCondition]),0);
      StatTree.DBProperties.DataSet :=Dm_Mts.cds_common;
      StatTree.DBProperties.ThreeState := false;
      StatTree.FillTree(nil,0,-1);
      StatTree.DBProperties.DataSet := nil;
      Close;
    end;
    if StatTree.Items.Count>0 then
    begin
      StatTree.Items[0].Collapse(true);
      StatTree.Items[0].Expand(false);
    end;
  end;
  //直放站状态统计树
  if True then
  begin
    DRSStatTree.ClearAllItem;
    with Dm_Mts.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,79,lPriveCondition+lAreaCondition]),0);
      DRSStatTree.DBProperties.DataSet :=Dm_Mts.cds_common;
      DRSStatTree.DBProperties.ThreeState := false;
      DRSStatTree.FillTree(nil,0,-1);
      DRSStatTree.DBProperties.DataSet := nil;
      Close;
    end;
    if DRSStatTree.Items.Count>0 then
    begin
      DRSStatTree.Items[0].Collapse(true);
      DRSStatTree.Items[0].Expand(false);
    end;
  end;
end;

procedure TFm_MainForm.StatTreeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  lNode:TTreeNode;
  lNodeText, lParentNodeText: string;
begin
  if (Button = mbRight) then Exit;
  if not (htOnItem	in TTreeView(Sender).GetHitTestInfoAt(x,y))  then
    Exit;
  lNode :=TTreeView(Sender).Selected;
  if lNode=nil then exit;
  //通过告警类型过滤告警监视界面
  lNodeText := lNode.Text;
  lNodeText := copy(lNodeText,1,Pos('(',lNodeText)-1);
  if lNode.Parent<>nil then
  begin
    lParentNodeText:= lNode.Parent.Text;
    lParentNodeText := copy(lParentNodeText,1,Pos('(',lParentNodeText)-1);
  end;
  if  (FormAlarmMonitor<>nil) and (ActiveMDIChild = FormAlarmMonitor) then
  begin
    if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel1 then
    begin
      if lNode.Level=0 then
        FormAlarmMonitor.gAlarmKindCondition := ''
      else if lNode.Level=1 then
        FormAlarmMonitor.gAlarmKindCondition := ' and alarmlevelname='''+lNodeText+''''
      else if lNode.Level=2 then
        FormAlarmMonitor.gAlarmKindCondition := ' and alarmlevelname='''+lParentNodeText+''' and alarmkindname='''+lNodeText+'''';
      FormAlarmMonitor.ShowAlarm_Online;
    end
    else if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel2 then
    begin
      if lNode.Level=0 then
        FormAlarmMonitor.gAlarmKindCondition := ''
      else if lNode.Level=1 then
        FormAlarmMonitor.gAlarmKindCondition := ' and alarmlevelname='''+lNodeText+''''
      else if lNode.Level=2 then
        FormAlarmMonitor.gAlarmKindCondition := ' and alarmlevelname='''+lParentNodeText+''' and alarmkindname='''+lNodeText+'''';
      FormAlarmMonitor.ShowAlarm_History;
    end
    else if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel5 then
    begin
      if lNode.Level=0 then
        FormAlarmMonitor.gAlarmKindCondition := ''
      else if lNode.Level=1 then
        FormAlarmMonitor.gAlarmKindCondition := ' and alarmlevelname='''+lNodeText+''''
      else if lNode.Level=2 then
        FormAlarmMonitor.gAlarmKindCondition := ' and alarmlevelname='''+lParentNodeText+''' and alarmkindname='''+lNodeText+'''';
      FormAlarmMonitor.ShowAlarm_Repeater;
    end;
  end;
end;

procedure TFm_MainForm.StatusBar1Panels3DrawPanel(Sender: TdxStatusBarPanel;
  ACanvas: TcxCanvas; const ARect: TRect; var ADone: Boolean);
begin
  cxProgressBar1.Parent:=StatusBar1;
  cxProgressBar1.Left:=ARect.Left;
  cxProgressBar1.Top:=ARect.Top;
  cxProgressBar1.Width:=ARect.Right-ARect.Left;
  cxProgressBar1.Height:=ARect.Bottom-ARect.Top-3;
end;

procedure TFm_MainForm.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  (TabSet.Tabs.Objects[NewTab] as TForm).Show;
  AutoVisiableTree;
end;

procedure TFm_MainForm.ThreadOnEvent(Sender: TObject; EventLevel: Integer;
  EventMsg: string);
begin
  StatusBar1.Panels[2].Text:=EventMsg ;
  if EventLevel=1 then
    FThreadFlag:=false;
end;

procedure TFm_MainForm.ThreadOnProgress(Sender: TObject; Position,
  Max: integer);
begin
  cxProgressBar1.Position:=Position;
  cxProgressBar1.Properties.Max:=Max;
end;

procedure TFm_MainForm.TreeViewAllCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (Node.Data <> nil) and TNodeParam(Node.Data).IsDraw  then   //根据结点的内容进行判断
  begin
    DefaultDraw:=True   ;
    Sender.Canvas.Font.Color:=clRed;
    Sender.Canvas.Textout(Node.DisplayRect(True).Left+2,Node.DisplayRect(True).Top+2,Node.Text);
  end;
end;

procedure TFm_MainForm.TreeViewAllMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Node:TTreeNode;
  lAreaCondition : String;
  lPriveCondition : String;
  lDRSCondition : string;
  lDRSStatCondition: string;
begin
  if (Button = mbRight) then Exit;
  if not (htOnItem	in TTreeView(Sender).GetHitTestInfoAt(x,y))  then
    Exit;
  Node :=TTreeView(Sender).Selected;
  //连接器树
  if PanelLinktree.Visible then
  begin
    LinkTree.ClearAllItem;
    with Dm_Mts.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      case TNodeParam(node.Data).nodeType of
        BUILDING,WLANTYPE,PHSTYPE,CDMATYPE,MTUTYPE :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,9,TNodeParam(node.Data).BuildingId,
                                                                      TNodeParam(node.Data).BuildingId]),0);
                             end;
        SWITCH            :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,13,TNodeParam(node.Data).SwitchID,
                                                                      TNodeParam(node.Data).SwitchID]),0);
                             end;
        AP                :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,10,TNodeParam(node.Data).APID,
                                                                      TNodeParam(node.Data).APID]),0);
                             end;
        CS                :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,11,TNodeParam(node.Data).CSID,
                                                                      TNodeParam(node.Data).CSID]),0);
                             end;
        CDMASOURCE        :  begin
                               Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,15,TNodeParam(node.Data).CDMAID,
                                                                      TNodeParam(node.Data).CDMAID]),0);
                             end;
      end;
      LinkTree.DBProperties.DataSet :=Dm_Mts.cds_common;
      LinkTree.DBProperties.ThreeState := false;
      LinkTree.FillTree(nil,-1,0);
      LinkTree.DBProperties.DataSet := nil;
      Close;
    end;
  end;
  //条件判断
  with PublicParam do
  begin
    if (cityid=0) and (areaid=0) then          //省级用户
    begin
      lPriveCondition := '';
    end
    else if (cityid<>0) and (areaid=0) then
    begin
      lPriveCondition := ' and cityid='+inttostr(PublicParam.cityid);
    end
    else if (cityid<>0) and (areaid<>0) then
    begin
      lPriveCondition := ' and areaid='+inttostr(PublicParam.areaid);
    end;
  end;
  case TNodeParam(node.Data).nodeType of  //室分点以下的，只显示其室分点的内容
    PROVINCE :  begin
                  lAreaCondition := '';
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    CITY     :  begin
                  lAreaCondition := ' and cityid='+
                    inttostr(TNodeParam(node.Data).Cityid);
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    AREA     :  begin
                  lAreaCondition := ' and areaid='+
                    inttostr(TNodeParam(node.Data).AreaId);
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    SUBURB   :  begin
                  lAreaCondition := ' and suburbid='+
                    inttostr(TNodeParam(node.Data).Suburbid);
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    INBUILDING: begin
                  lAreaCondition := ' and buildingid <> -1 and suburbid='+
                    inttostr(TNodeParam(node.Data).Suburbid);
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    OUTBUILDING: begin
                  lAreaCondition := ' and buildingid = -1 and suburbid='+
                    inttostr(TNodeParam(node.Data).Suburbid);
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    BUILDING,WLANTYPE,PHSTYPE,CDMATYPE,MTUTYPE,DRSTYPE :
                begin
                  lAreaCondition := ' and buildingid='+
                    inttostr(TNodeParam(node.Data).BuildingId);
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    SWITCH   :  begin
                  lAreaCondition := ' and buildingid='+
                    '(select buildingid from switch_info where switchid='+
                    inttostr(TNodeParam(node.Data).SwitchID)+')';
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    AP       :  begin
                  lAreaCondition := ' and buildingid='+
                    '(select buildingid from switch_info'+
                    ' inner join ap_info on switch_info.switchid=ap_info.switchid'+
                    ' where ap_info.apid='+
                    inttostr(TNodeParam(node.Data).APID)+')';
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    CS       :  begin
                  lAreaCondition := ' and buildingid='+
                    '(select buildingid from cs_info where csid='+
                    inttostr(TNodeParam(node.Data).CSID)+')';
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    CDMASOURCE:  begin
                  lAreaCondition := ' and buildingid='+
                    '(select buildingid from cdma_info where cdmaid='+
                    inttostr(TNodeParam(node.Data).CDMAID)+')';
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    MTU, MAINLOOKCDMA       : begin
                  lAreaCondition:= ' and buildingid='+
                   '(select buildingid from mtu_info where mtuid='+
                   inttostr(TNodeParam(node.Data).MTUID)+')';
                  lDRSCondition:= ' and 1=2';
                  lDRSStatCondition:= lDRSCondition;
                end;
    MTUTYPEOUT, DRSTYPEOUT  :begin
                  lAreaCondition := ' and buildingid = -1 and suburbid='+
                    inttostr(TNodeParam(node.Data).Suburbid);
                  lDRSCondition:= lAreaCondition;
                  lDRSStatCondition:= lDRSCondition;
                end;
    DRS:        begin
                  lAreaCondition:= ' and 1=2';
                  lDRSCondition:= ' and buildingid='+
                   '(select buildingid from drs_info where drsid='+
                   inttostr(TNodeParam(node.Data).DRSID)+')';
                  lDRSStatCondition:= ' and drsid=' + inttostr(TNodeParam(node.Data).DRSID);
    end;
  end; 
  //统计树
  if PanelStatTree.Visible then
  begin
    StatTree.ClearAllItem;
    with Dm_Mts.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,23,lPriveCondition+lAreaCondition,lPriveCondition+lDRSCondition]),0);
      StatTree.DBProperties.DataSet :=Dm_Mts.cds_common;
      StatTree.DBProperties.ThreeState := false;
      StatTree.FillTree(nil,0,-1);
      StatTree.DBProperties.DataSet := nil;
      Close;
    end;
    if StatTree.Items.Count>0 then
    begin
      StatTree.Items[0].Collapse(true);
      StatTree.Items[0].Expand(false);
    end;
  end;
  //直放站状态树  mj
  if PanelDRS.Visible then
  begin
    DRSStatTree.ClearAllItem;
    with Dm_Mts.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,79,lPriveCondition+lDRSStatCondition]),0);
      DRSStatTree.DBProperties.DataSet :=Dm_Mts.cds_common;
      DRSStatTree.DBProperties.ThreeState := false;
      DRSStatTree.FillTree(nil,0,-1);
      DRSStatTree.DBProperties.DataSet := nil;
      Close;
    end;
    if DRSStatTree.Items.Count>0 then
    begin
      DRSStatTree.Items[0].Collapse(true);
      DRSStatTree.Items[0].Expand(false);
    end;
  end;
  //显示告警监控
  if  (FormAlarmMonitor<>nil) and (ActiveMDIChild = FormAlarmMonitor) then
  begin
    if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel1 then
    begin
      FormAlarmMonitor.gAlarmKindCondition := '';
      FormAlarmMonitor.gCondition := lPriveCondition+ lAreaCondition;
      FormAlarmMonitor.ShowAlarm_Online;
    end else
    if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel2 then
    begin
      FormAlarmMonitor.gAlarmKindCondition := '';
      FormAlarmMonitor.gCondition := lPriveCondition+ lAreaCondition;
      FormAlarmMonitor.ShowAlarm_History;
    end else
    if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel5 then
    begin
      FormAlarmMonitor.gAlarmKindCondition := '';
      FormAlarmMonitor.gCondition := lPriveCondition+ lAreaCondition;
      FormAlarmMonitor.ShowAlarm_Repeater;
    end;
    if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel7 then
    begin
      FormAlarmMonitor.gAlarmKindCondition := '';
      FormAlarmMonitor.gCondition := lPriveCondition+ lDRSStatCondition;
      FormAlarmMonitor.ShowAlarm_DRS;
    end;
  end;

  if (FrmDRSConfig<>nil) AND (ActiveMDIChild=FrmDRSConfig) then  //DRS树图筛选直放站列表
  begin
    case TNodeParam(node.Data).nodeType of
      PROVINCE:
        FrmDRSConfig.gWhereCond:=' DRSStatus=1';
      CITY:
        FrmDRSConfig.gWhereCond:=' DRSStatus=1 and cityid=' + IntToStr(TNodeParam(Node.Data).Cityid);
      AREA:
        FrmDRSConfig.gWhereCond:=' DRSStatus=1 and areaid='+IntToStr(TNodeParam(Node.Data).AreaId);
      SUBURB:
        FrmDRSConfig.gWhereCond:=' DRSStatus=1 and suburbid=' + IntToStr(TNodeParam(Node.Data).Suburbid);
      INBUILDING:
        FrmDRSConfig.gWhereCond:=' DRSStatus=1 and ISPROGRAM=1 and suburbid='+inttostr(TNodeParam(node.Data).Suburbid)+
                                 '';
      OUTBUILDING:
        FrmDRSConfig.gWhereCond:=' DRSStatus=1 and ISPROGRAM=0 and suburbid='+inttostr(TNodeParam(node.Data).Suburbid)+
                                 ' and buildingid=-1';
      BUILDING:
        FrmDRSConfig.gWhereCond:=' DRSStatus=1 and ISPROGRAM=1 and buildingid=' + IntToStr(TNodeParam(Node.Data).BuildingId);
      DRS:
        FrmDRSConfig.gWhereCond:=' DRSStatus=1 and drsid=' + IntToStr(TNodeParam(node.Data).DRSID);
      else Exit;
    end;
    FrmDRSConfig.ShowDRSListData();
  end;
end;

procedure TFm_MainForm.TreeViewSubMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Node:TTreeNode;
  lAreaCondition : String;
  lPriveCondition : String;
  lWdInteger:TWdInteger;
begin
  if (Button = mbRight) then Exit;
  if not (htOnItem	in TTreeView(Sender).GetHitTestInfoAt(x,y))  then
    Exit;
  Node :=TTreeView(Sender).Selected;
  //权限判断
  lPriveCondition := GetPriveArea(PublicParam.cityid,PublicParam.areaid);
  lPriveCondition := ' and t.areaid in ('+lPriveCondition+')';
  case TNodeParam(node.Data).nodeType of
    PROVINCE :  begin
                  lAreaCondition := '';
                end;
    CITY     :  begin
                  lAreaCondition := ' and cityid='+
                    inttostr(TNodeParam(node.Data).Cityid);
                end;
    AREA     :  begin
                  lAreaCondition := ' and areaid='+
                    inttostr(TNodeParam(node.Data).AreaId);
                end;
    SUBURB   :  begin
                  lAreaCondition := ' and suburbid='+
                    inttostr(TNodeParam(node.Data).Suburbid);
                end;
    BUILDING :
                begin
                  lAreaCondition := ' and buildingid='+
                    inttostr(TNodeParam(node.Data).BuildingId);
                end;
    INBUILDING: begin
                  lAreaCondition := ' and suburbid='+
                    inttostr(TNodeParam(node.Data).Suburbid)+
                    ' and buildingid<>-1';
                end;
    OUTBUILDING:begin
                  lAreaCondition := ' and suburbid='+
                    inttostr(TNodeParam(node.Data).Suburbid)+
                    ' and buildingid=-1';
                end
    else exit;
  end;
  
  //室分点
  if  (Fm_building_info<>nil) and (ActiveMDIChild = Fm_building_info) then
  begin
    with Fm_building_info do
    begin
      if (ButtonModify.Tag=1) or (ButtonAdd.Tag=1) then
        if application.MessageBox('正在进行其他操作，是否取消该操作?', '提示', mb_okcancel + mb_defbutton1) = idCancel then
          exit
        else
          UIChangeNormal;
      ClearInfo;
      PicStringlist.Clear;
      ImageLogo.Picture.Bitmap.Assign(nil);
      StrListIndex:=0;
      ShowPicCount(StrListIndex,PicStringlist);

      SetControl(false);
      ToolButtonLoad.Enabled:=false;
      ToolButtonDel.Enabled:=false;
      //刷新
      RefreshBuilding(lPriveCondition+lAreaCondition);
    end;
  end;
  //MTU
  if (FormMTUINFO<>nil) and (ActiveMDIChild = FormMTUINFO) then
  begin
    FormMTUINFO.gCondition:= lAreaCondition;
    FormMTUINFO.ShowDevice_MTU;
  end;
  //交换机
  if (FormSwitchInfo<>nil) and (ActiveMDIChild = FormSwitchInfo) then
  begin
    FormSwitchInfo.gCondition:= lAreaCondition;
    FormSwitchInfo.ShowDevice_LM;
  end;
  //AP
  if (FormAPInfo<>nil) and (ActiveMDIChild = FormAPInfo) then
  begin
    FormAPInfo.gCondition:= lAreaCondition;
    FormAPInfo.ShowDevice_AP;
  end;
  //连接器
  if (FormLinkMachineInfo<>nil) and (ActiveMDIChild = FormLinkMachineInfo) then
  begin
    FormLinkMachineInfo.gCondition:= lAreaCondition;
    FormLinkMachineInfo.ShowDevice_LM;
  end;
  //CS
  if (FormCSInfoMag<>nil) and (ActiveMDIChild = FormCSInfoMag) then
  begin
    FormCSInfoMag.gCondition:= lAreaCondition;
    FormCSInfoMag.ShowDevice_CS;
  end;
  //CDMA
  if (FormCDMASource<>nil) and (ActiveMDIChild = FormCDMASource) then
  begin
    FormCDMASource.gCondition:= lAreaCondition;
    FormCDMASource.ShowDevice_CDMA;
  end;
  //告警拨测
  if  (Fm_AlarmTest<>nil) and (ActiveMDIChild = Fm_AlarmTest) then
  begin
    with Fm_AlarmTest do
    begin
      if Page.ActivePage=TabSheet_mtulist then
      begin
        gCondition:= lPriveCondition+lAreaCondition;
        RefreshMtu;
      end
      else
      if page.ActivePage=TabSheet_task then
      begin
        gCondition:= lPriveCondition+lAreaCondition;
        RefreshTask;
      end;
    end;
  end;
end;

procedure TFm_MainForm.DeleteTab(Form: TForm);
var
  i:integer;
  lb : boolean;
begin
  for i:=0 to TabSet.Tabs.Count-1 do
  begin
    if TabSet.Tabs.Objects[i]= Form then
    begin
      TabSet.Tabs.Delete(i);
      break;
    end;
  end;
  if TabSet.TabIndex>-1 then
    TabSetChange(self,TabSet.TabIndex,lb)
  else
    AutoVisiableTree;
end;

procedure TFm_MainForm.DrawAlarmRecordCounts(aCaption, aValue: string);
begin
  StatusBar1.Panels[1].Text:=aCaption+' '+aValue;
end;

procedure TFm_MainForm.DRS_AlarmQueryExecute(Sender: TObject);
begin
   if not assigned(Form_DRS_AlarmQuery) then
      begin
        Form_DRS_AlarmQuery:=TForm_DRS_AlarmQuery.Create(nil);
        AddToTab(Form_DRS_AlarmQuery);
      end;
  SetTabIndex(Form_DRS_AlarmQuery);
  Form_DRS_AlarmQuery.WindowState:=wsMaximized;
  Form_DRS_AlarmQuery.Show;
end;

procedure TFm_MainForm.InitUserInfo(lUserNo: string);
begin
  InitPublicParam(lUserNo);
  //功能权限
  InitPriv;
end;


procedure TFm_MainForm.LinkTreeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Node:TTreeNode;
  BuildingId,Apid,csid,CDMAID :integer;
begin
   if (Button = mbRight) then Exit;
   if not (htOnItem	in TTreeView(Sender).GetHitTestInfoAt(x,y))  then
     Exit;
   Node :=TTreeView(Sender).Selected;
   //如果是连接器
   if PDBThreeNodeInfo(node.Data).layer = 1 then
      with Dm_Mts.cds_common do
      begin
        Close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,12,PDBThreeNodeInfo(node.Data).ID]),0);
        if RecordCount >0 then
        begin
          BuildingId := FieldByName('BuildingId').AsInteger;
          Apid   := FieldByName('LINKAP').AsInteger;
          csid   := FieldByName('LINKCS').AsInteger;
          CDMAID := FieldByName('LINKCDMA').AsInteger;
          MarkByAPAndCS(BuildingId,apid,csid,CDMAID);
          TreeViewAll.Refresh;
        end;
        Close;
      end;
end;

procedure TFm_MainForm.LoadUserTreeSet;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,64]),0);
    if Fieldbyname('setvalue').AsInteger=1 then
      ActionStatTree.Checked:= true
    else
      ActionStatTree.Checked:= false
  end;
end;

function TFm_MainForm.LocateBuilding(aBuildingName: String; aTree:TTreeView):boolean;
var
  lCurrNode_City, lCurrNode_Area, lCurrNode_Suburb,
  lCurrNode_BuildStatus, lCurrNode_Build: TTreeNode;
begin
  result:= false;
  if aTree.Items.Count=0 then exit;
  lCurrNode_City:= aTree.Items[0];
  lCurrNode_City:= lCurrNode_City.getFirstChild;
  while (lCurrNode_City<>nil) and (lCurrNode_City.Data<>nil) do//地市
  begin
    if not TNodeParam(lCurrNode_City.Data).HaveExpanded then
      lCurrNode_City.Expand(false);
    lCurrNode_Area:= lCurrNode_City.getFirstChild;
    while (lCurrNode_Area<>nil) and (lCurrNode_Area.Data<>nil) do//行政区
    begin
      if not TNodeParam(lCurrNode_Area.Data).HaveExpanded then
        lCurrNode_Area.Expand(false);
      lCurrNode_Suburb:= lCurrNode_Area.getFirstChild;
      while (lCurrNode_Suburb<>nil) and (lCurrNode_Suburb.Data<>nil) do//郊县
      begin
        if not TNodeParam(lCurrNode_Suburb.Data).HaveExpanded then
        lCurrNode_Suburb.Expand(false);
        lCurrNode_BuildStatus:= lCurrNode_Suburb.getFirstChild;
        while (lCurrNode_BuildStatus<>nil) and (lCurrNode_BuildStatus.Data<>nil) do //室分状态
        begin
          if not TNodeParam(lCurrNode_BuildStatus.Data).HaveExpanded then
          lCurrNode_BuildStatus.Expand(false);
          lCurrNode_Build:= lCurrNode_BuildStatus.getFirstChild;
          while (lCurrNode_Build<>nil) and (lCurrNode_Build.Data<>nil) do//室分
          begin
            if uppercase(lCurrNode_Build.Text)=uppercase(aBuildingName) then
            begin
              aTree.Selected := lCurrNode_Build;
              result := true;
              if result then
                exit;;
            end;
            lCurrNode_Build:= lCurrNode_Build.getNextSibling;
          end;
          lCurrNode_BuildStatus:= lCurrNode_BuildStatus.getNextSibling;
        end;
        lCurrNode_Suburb:= lCurrNode_Suburb.getNextSibling;
      end;
      lCurrNode_Area:= lCurrNode_Area.getNextSibling;
    end;
    lCurrNode_City:= lCurrNode_City.getNextSibling;
  end;
end;

procedure TFm_MainForm.MarkByAPAndCS(Buildingid, apid, csid, cdmaid: integer);
var
  N,tmp,Node :TTreeNode;
  IsAp,IsCs,IsCDMA :boolean;
  i,j,k : integer;
begin
  Node := nil;
  IsAp := false;
  IsCs := false;
  IsCDMA := false;
  CancelDraw;
  //找到室分点将所有子节点全部展开
  with TreeViewAll do
  begin
    for I := 0 to TreeViewAll.Items.Count - 1 do
    begin
      if TreeViewAll.Items[i].Data<>nil then
      begin
        if (TNodeParam(Items[i].Data).nodeType=BUILDING) and
           (TNodeParam(Items[i].Data).BuildingId=Buildingid) then
        begin
          Node :=Items[i];
          Node.Expand(true);
          break;
        end;
      end;
    end;
  end;
  //清除重画标识 
  with TreeViewAll do
  begin
    for I := 0 to Items.Count - 1 do
    begin
      if (Items[i].Data<>nil) and(TNodeParam(Items[i].Data).IsDraw) then
          TNodeParam(Items[i].Data).IsDraw := false;
    end;
  end;

  if (Node <> nil) and (Node.Data <> nil) then
  begin
    for i := 0 to Node.Count - 1 do
    begin
      if TNodeParam(Node.Item[i].Data).nodeType = WLANTYPE  then
      begin
        tmp :=Node.Item[i];
        if Tmp.HasChildren then
          for j := 0 to tmp.Count - 1 do
          begin
            N := Tmp.Item[j];
            if N.HasChildren then
              for k := 0 to N.Count - 1 do
              if (TNodeParam(N.Item[k].Data).nodeType=AP) and
               (TNodeParam(N.Item[k].Data).APID=APID) then
              begin
                TNodeParam(N.Item[k].Data).IsDraw := true;
                IsAp := true;
                break;
              end;
          end;
      end
      else if TNodeParam(Node.Item[i].Data).nodeType = PHSTYPE then//PHS
      begin
        tmp :=Node.Item[i];
        if tmp.HasChildren then
          for j := 0 to tmp.Count - 1 do
          begin
            if (TNodeParam(tmp.Item[i].Data).nodeType=CS) and
             (TNodeParam(tmp.Item[i].Data).csid=csid) then
            begin
              TNodeParam(tmp.Item[i].Data).IsDraw := true;
              IsCs := true;
              break;
            end;
          end;
      end
      else if TNodeParam(Node.Item[i].Data).nodeType = CDMATYPE then
      begin
        tmp :=Node.Item[i];
        if tmp.HasChildren then
          for j := 0 to tmp.Count - 1 do
          begin
            if (TNodeParam(tmp.Item[i].Data).nodeType=CDMASOURCE) and
             (TNodeParam(tmp.Item[i].Data).CDMAID=CDMAID) then
            begin
              TNodeParam(tmp.Item[i].Data).IsDraw := true;
              IsCDMA := true;
              break;
            end;
          end;
      end;
    end;
  end;

  with TreeViewAll do
  begin
    for I := 0 to TreeViewAll.Items.Count - 1 do
    begin
      if TreeViewAll.Items[i].Data<>nil then
      begin
        if (TNodeParam(Items[i].Data).nodeType=AP) and
           (TNodeParam(Items[i].Data).APID=apid) then
        begin
          TNodeParam(Items[i].Data).IsDraw := true;
          IsAp :=true;
        end
        else if (TNodeParam(Items[i].Data).nodeType=CS) and
           (TNodeParam(Items[i].Data).csid=csid) then
        begin
          TNodeParam(Items[i].Data).IsDraw := true;
          IsCS :=true;
        end
        else if (TNodeParam(Items[i].Data).nodeType=CDMASOURCE) and
           (TNodeParam(Items[i].Data).CDMAID=CDMAID) then
        begin
          TNodeParam(Items[i].Data).IsDraw := true;
          IsCDMA :=true;
        end;     
        if IsAp and IsCS and IsCDMA then
          break;
      end;
    end;
  end;
end;

procedure TFm_MainForm.A1_AlarmMonitorExecute(Sender: TObject);
begin
  if not assigned(FormAlarmMonitor) then
  begin
    FormAlarmMonitor:=TFormAlarmMonitor.Create(nil);
    AddToTab(FormAlarmMonitor);
  end;
  SetTabIndex(FormAlarmMonitor);
  FormAlarmMonitor.WindowState:=wsMaximized;
  FormAlarmMonitor.Show;
end;

procedure TFm_MainForm.A1_AlarmSearchExecute(Sender: TObject);
begin
  if not assigned(Fm_AlarmQuery) then
  begin
    Fm_AlarmQuery:=TFm_AlarmQuery.Create(nil);
    AddToTab(Fm_AlarmQuery);
  end;
  SetTabIndex(Fm_AlarmQuery);
  Fm_AlarmQuery.WindowState:=wsMaximized;
  Fm_AlarmQuery.Show;
end;

procedure TFm_MainForm.A1_AlarmTestExecute(Sender: TObject);
begin
  if (not assigned(Fm_AlarmTest)) or (Assigned(Fm_AlarmTest) and (not assginTab(Fm_AlarmTest))) then
  begin
    Fm_AlarmTest:=TFm_AlarmTest.Create(nil);
    AddToTab(Fm_AlarmTest);
  end;
  SetTabIndex(Fm_AlarmTest);
  Fm_AlarmTest.WindowState:=wsMaximized;
  Fm_AlarmTest.Show;
end;

procedure TFm_MainForm.A2_AlarmContentExecute(Sender: TObject);
begin
  if not assigned(Fm_AlarmContent) then
  begin
    Fm_AlarmContent:=TFm_AlarmContent.Create(nil);
    AddToTab(Fm_AlarmContent);
  end;
  SetTabIndex(Fm_AlarmContent);
  Fm_AlarmContent.WindowState:=wsMaximized;
  Fm_AlarmContent.Show;
end;

procedure TFm_MainForm.A2_CityInfoExecute(Sender: TObject);
begin
  Fm_CityManager:=TFm_CityManager.Create(self);
  try
    Fm_CityManager.ShowModal;
  finally
    Fm_CityManager.Free;
  end;
end;

procedure TFm_MainForm.A2_DicInfoExecute(Sender: TObject);
begin
  Fm_DataDicMag:=TFm_DataDicMag.Create(self);
  try
    Fm_DataDicMag.ShowModal;
  finally
    Fm_DataDicMag.Free;
  end;
end;

procedure TFm_MainForm.A2_TestParamSetExecute(Sender: TObject);
begin
  Fm_TestParamSet:=TFm_TestParamSet.Create(self);
  try
    Fm_TestParamSet.ShowModal;
  finally
    Fm_TestParamSet.Free;
  end;
end;

procedure TFm_MainForm.A2_UserInfoExecute(Sender: TObject);
begin
  if not assigned(Fm_UserInfoMag) then
  begin
    Fm_UserInfoMag:=TFm_UserInfoMag.Create(nil);
    AddToTab(Fm_UserInfoMag);
  end;
  SetTabIndex(Fm_UserInfoMag);
  Fm_UserInfoMag.WindowState:=wsMaximized;
  Fm_UserInfoMag.Show;
end;

procedure TFm_MainForm.A3_CLoseExecute(Sender: TObject);
begin
  Close;
end;

procedure TFm_MainForm.A3_LogoutExecute(Sender: TObject);
var
  //lRetryCount:integer;
  lUserNo,lPassword:string;
  lResult:integer;
  lUserName :OleVariant;
begin
// 登录
  FormLogin:= TFormLogin.Create(self);
  FormLogin.LoadUser;
  try
    repeat
      FormLogin.EditPassword.Clear;
      if FormLogin.ShowModal=mrOK then
      begin
        //密码校验
        lResult:=3;
        lUserNo:=Trim(FormLogin.EditUserName.Text);
        lPassword:=FormLogin.EditPassword.Text;
        lResult:=Dm_MTS.SocketConnection1.AppServer.login(lUserNo,lPassword,lUserName);
        if lResult =1 then  //成功
        begin
          FormLogin.SaveUser(lUserNo);
          self.StatusBar1.Panels[0].Text:='当前用户：'+lUserNo;
          break;
        end 
        else
        begin
          Application.MessageBox('用户名或口令有误！','登录',MB_OK	);
        end;
      end else
      begin
        FormLogin.Hide;
        Exit;
      end;
    until false;
    InitUserInfo(lUserNo);
  finally
    FormLogin.Free;
  end;
end;

procedure TFm_MainForm.A3_ModifyPassWordExecute(Sender: TObject);
var
  lResult:integer;
begin
//
  FormChangePwd:=TFormChangePwd.Create(self);
  try
    if FormChangePwd.ShowModal=mrOK then
    begin
      lResult:=Dm_MTS.TempInterface.ChangePassword(FormChangePwd.OldPasswordEdit.Text,
        FormChangePwd.NewPasswordEdit.Text,PublicParam.userno);
      if lResult=0 then
      begin
        Application.MessageBox('密码修改成功！','登录',MB_OK	);
      end else
      begin
        Application.MessageBox('密码修改失败！','登录',MB_OK	);
      end;

    end;
  finally
    FormChangePwd.Free;
  end;
end;


procedure TFm_MainForm.A4_ApInfoExecute(Sender: TObject);
begin
  if not assigned(FormAPInfo) then
  begin
    FormAPInfo:=TFormAPInfo.Create(nil);
    AddToTab(FormAPInfo);
  end;
  SetTabIndex(FormAPInfo);
  FormAPInfo.WindowState:=wsMaximized;
  FormAPInfo.Show;
end;

procedure TFm_MainForm.A4_BuildInfoExecute(Sender: TObject);
begin
  if not assigned(fm_building_info) then
  begin
    fm_building_info:=Tfm_building_info.Create(nil);
    AddToTab(fm_building_info);
  end;
  SetTabIndex(fm_building_info);
  fm_building_info.WindowState:=wsMaximized;
  fm_building_info.Show;
end;

procedure TFm_MainForm.A4_CsInfoExecute(Sender: TObject);
begin
  if not assigned(FormCSInfoMag) then
  begin
    FormCSInfoMag:=TFormCSInfoMag.Create(nil);
    AddToTab(FormCSInfoMag);
  end;
  SetTabIndex(FormCSInfoMag);
  FormCSInfoMag.WindowState:=wsMaximized;
  FormCSInfoMag.Show;
end;

procedure TFm_MainForm.A4_linkerInfoExecute(Sender: TObject);
begin
  if not assigned(Formlinkmachineinfo) then
  begin
    Formlinkmachineinfo:=TFormlinkmachineinfo.Create(nil);
    AddToTab(Formlinkmachineinfo);
  end;
  SetTabIndex(Formlinkmachineinfo);
  Formlinkmachineinfo.WindowState:=wsMaximized;
  Formlinkmachineinfo.Show;
end;

procedure TFm_MainForm.A4_MtuInfoExecute(Sender: TObject);
begin
//  if not assigned(Fm_mtu_info) then
//  begin
//    Fm_mtu_info:=TFm_mtu_info.Create(nil);
//    AddToTab(Fm_mtu_info);
//  end;
//  SetTabIndex(Fm_mtu_info);
//  Fm_mtu_info.WindowState:=wsMaximized;
//  Fm_mtu_info.Show;
  if not assigned(FormMTUINFO) then
  begin
    FormMTUINFO:=TFormMTUINFO.Create(nil);
    AddToTab(FormMTUINFO);
  end;
  SetTabIndex(FormMTUINFO);
  FormMTUINFO.WindowState:=wsMaximized;
  FormMTUINFO.Show;
end;

procedure TFm_MainForm.A4_SwitchInfoExecute(Sender: TObject);
begin
  if not assigned(FormSwitchInfo) then
  begin
    FormSwitchInfo:=TFormSwitchInfo.Create(nil);
    AddToTab(FormSwitchInfo);
  end;
  SetTabIndex(FormSwitchInfo);
  FormSwitchInfo.WindowState:=wsMaximized;
  FormSwitchInfo.Show;
end;

procedure TFm_MainForm.A2_DRS_Alarm_mgrExecute(Sender: TObject);
begin
   if not assigned(FormDRS_ALARM_Mgr) then
      begin
        FormDRS_ALARM_Mgr:=TFormDRS_ALARM_Mgr.Create(nil);
        AddToTab(FormDRS_ALARM_Mgr);
      end;
      SetTabIndex(FormDRS_ALARM_Mgr);
      FormDRS_ALARM_Mgr.WindowState:=wsMaximized;
      FormDRS_ALARM_Mgr.Show;
end;

procedure TFm_MainForm.ActionRingSetExecute(Sender: TObject);
begin
  FormRingMgr:=TFormRingMgr.Create(self);
  try
    FormRingMgr.ShowModal;
  finally
    FormRingMgr.Free;
  end;
end;

procedure TFm_MainForm.ActionRoundSearchExecute(Sender: TObject);
begin
  if not assigned(FormDRSRoundSearch) then
  begin
    FormDRSRoundSearch:=TFormDRSRoundSearch.Create(nil);
    AddToTab(FormDRSRoundSearch);
  end;
  SetTabIndex(FormDRSRoundSearch);
  FormDRSRoundSearch.WindowState:=wsMaximized;
  FormDRSRoundSearch.Show;
end;

procedure TFm_MainForm.ActionUserCustomSetExecute(Sender: TObject);
begin
  FormUserCustomSet:=TFormUserCustomSet.Create(self);
  try
    FormUserCustomSet.ShowModal;
  finally
    FormUserCustomSet.Free;
  end;
end;

procedure TFm_MainForm.ActionCDMAExecute(Sender: TObject);
begin
//  if not assigned(FormSignSource) then
//  begin
//    FormSignSource:=TFormSignSource.Create(nil);
//    AddToTab(FormSignSource);
//  end;
//  SetTabIndex(FormSignSource);
//  FormSignSource.WindowState:=wsMaximized;
//  FormSignSource.Show;
  if not assigned(FormCDMASource) then
  begin
    FormCDMASource:=TFormCDMASource.Create(nil);
    AddToTab(FormCDMASource);
  end;
  SetTabIndex(FormCDMASource);
  FormCDMASource.WindowState:=wsMaximized;
  FormCDMASource.Show;
end;

procedure TFm_MainForm.ActionDRSExecute(Sender: TObject);
begin
  if not assigned(FrmDRSConfig) then
  begin
    FrmDRSConfig:=TFrmDRSConfig.Create(nil);
    AddToTab(FrmDRSConfig);
  end;
  SetTabIndex(FrmDRSConfig);
  FrmDRSConfig.WindowState:=wsMaximized;
  FrmDRSConfig.Show;
end;

procedure TFm_MainForm.ActionDRSInfoExecute(Sender: TObject);
begin
   if not assigned(FrmDRSComQuery) then
      begin
        FrmDRSComQuery:=TFrmDRSComQuery.Create(nil);
        AddToTab(FrmDRSComQuery);
      end;
      SetTabIndex(FrmDRSComQuery);
      FrmDRSComQuery.WindowState:=wsMaximized;
      FrmDRSComQuery.Show;
end;

procedure TFm_MainForm.ActionLinkTreeExecute(Sender: TObject);
begin
  self.PanelLinktree.Visible := self.ActionLinkTree.Checked;
  self.Splitter1.Visible := self.ActionLinkTree.Checked;
end;

procedure TFm_MainForm.ActionMtuPlanSetExecute(Sender: TObject);
begin
  if not assigned(FormMtuPlanSet) then
  begin
    FormMtuPlanSet:=TFormMtuPlanSet.Create(nil);
    AddToTab(FormMtuPlanSet);
  end;
  SetTabIndex(FormMtuPlanSet);
  FormMtuPlanSet.WindowState:=wsMaximized;
  FormMtuPlanSet.Show;
end;

procedure TFm_MainForm.ActionStatTreeExecute(Sender: TObject);
begin
  //先置灰
  self.PanelLinktree.Visible := false;
  self.Splitter1.Visible := false;
  self.PanelStatTree.Visible := self.ActionStatTree.Checked;
  self.Splitter2.Visible := self.ActionStatTree.Checked;
  //再显示
  self.PanelLinktree.Visible := self.ActionLinkTree.Checked;
  self.Splitter1.Visible := self.ActionLinkTree.Checked;
  //保存设置
  SaveUserTreeSet;
end;

procedure TFm_MainForm.A1_AlarmTestModelExecute(Sender: TObject);
begin
  if not assigned(FrmAlarmTestModel) or (FrmAlarmTestModel.iFlag <> 0) then
  begin
    FrmAlarmTestModeliFlag := 0;
    FrmAlarmTestModel:=TFrmAlarmTestModel.Create(nil);
    AddToTab(FrmAlarmTestModel);
  end;
  SetTabIndex(FrmAlarmTestModel);
  FrmAlarmTestModel.WindowState:=wsMaximized;
  FrmAlarmTestModel.Show;
end;

procedure TFm_MainForm.A1_AlarmTestModeMonitorlExecute(Sender: TObject);
begin
  if not assigned(FrmAlarmTestModelM)  or (FrmAlarmTestModelM.iFlag <> 1) then
  begin
    FrmAlarmTestModeliFlag := 1;
    FrmAlarmTestModelM:=TFrmAlarmTestModel.Create(nil);
    AddToTab(FrmAlarmTestModelM);
  end;
  SetTabIndex(FrmAlarmTestModelM);
  FrmAlarmTestModelM.WindowState:=wsMaximized;
  FrmAlarmTestModelM.Show;
end;

procedure TFm_MainForm.A1_AlarmWaitExecute(Sender: TObject);
begin
  if not assigned(FormAlarmWait) then
  begin
    FormAlarmWait:=TFormAlarmWait.Create(nil);
    AddToTab(FormAlarmWait);
  end;
  SetTabIndex(FormAlarmWait);
  FormAlarmWait.WindowState:=wsMaximized;
  FormAlarmWait.Show;
end;

procedure TFm_MainForm.CancelDraw;
var
  i : integer;
begin
  for I := 0 to TreeViewAll.Items.Count - 1 do
  begin
    if TreeViewAll.Items[i].Data <> nil then
      if TNodeParam(TreeViewAll.Items[i].Data).IsDraw  then
        TNodeParam(TreeViewAll.Items[i].Data).IsDraw := false;
  end;
end;

function TFm_MainForm.ConnectAppServer: boolean;
var
  lNetIni:TIniFile;
  temForm: TFm_ServerSet;
  lFile:string;
begin
  result:=false;
  lNetIni := nil;
  lFile:=ExtractFilePath(Application.ExeName)+'MTS_Client.ini';
  if not FileExists(lFile) then
  begin

    temForm:= TFm_ServerSet.Create(nil);
    try
      if temForm.ShowModal = mrOk then
      begin
        PublicParam.ServerIP := Trim(temForm.IP1.Text) + '.' + Trim(temForm.IP2.Text) + '.' + Trim(temForm.IP3.Text) + '.' + Trim(temForm.IP4.Text);
        PublicParam.MsgPort := StrToInt(Trim(temForm.edtPort.Text));
        PublicParam.DBPort := StrToInt(Trim(temForm.DBPort.Text));
        lNetIni:=TIniFile.Create(lFile);
        try
          lNetIni.WriteString('POPAppSvr','IpAddress',PublicParam.ServerIP);
          lNetIni.WriteInteger('POPAppSvr','DBPORT',PublicParam.DBPort);
          lNetIni.WriteInteger('POPAppSvr','MSGPORT',PublicParam.MsgPort);
        finally
          lNetIni.Free;
        end;
      end
      else
        Exit;
    finally
      temForm.Free;
    end;
  end
  else
  begin
    try
      lNetIni:=TIniFile.Create(lFile);
      PublicParam.ServerIP:= lNetIni.ReadString('POPAppSvr','IpAddress','127.0.0.1');
      PublicParam.DBPort :=  lNetIni.ReadInteger('POPAppSvr','DBPORT',990);
      PublicParam.MsgPort := lNetIni.ReadInteger('POPAppSvr','MSGPORT',991);
    finally
      lNetIni.Free;
    end;
  end;

  Dm_MTS.SocketConnection1.Address:=PublicParam.ServerIP;
  Dm_MTS.SocketConnection1.Port:=PublicParam.DBPort;
  IdClient.Host := PublicParam.ServerIP;
  IdClient.Port := PublicParam.MsgPort;
  try
    Dm_MTS.SocketConnection1.Open;
    if Dm_MTS.SocketConnection1.Connected then
      result:=true
  except
    result:=false;
  end;

end;

procedure TFm_MainForm.CreateCustomLayer(aLayerSet: TLayerTypeSet);
begin
  FLayerSvr:=TLayerSvrThread.Create;
  FLayerSvr.IpAddress:=Dm_MTS.SocketConnection1.Address;
  FLayerSvr.ServerName:=Dm_MTS.SocketConnection1.ServerName;
  FLayerSvr.Port:=Dm_MTS.SocketConnection1.Port;
  FLayerSvr.ProviderName:='DSP_GIS';
  FLayerSvr.CityID:=PublicParam.cityid;
  FLayerSvr.UserID:=PublicParam.userid;
//  FLayerSvr.BranchStr:=PublicParam.BranchStr;
  FLayerSvr.LayerTypeSet:=aLayerSet;
  FLayerSvr.OnEvent:=ThreadOnEvent;
  FLayerSvr.OnProgress:=ThreadOnProgress;
  FLayerSvr.Resume;
  FThreadFlag:=true;
end;

procedure TFm_MainForm.cxButtonSearchClick(Sender: TObject);
var
  lNode: TTreeNode;
  lClientDataSet: TClientDataSet;
begin
  Self.N23Click(Self);
  lNode:= nil;
  if RBBuilding.Checked then
  begin
    if TreeViewAll.Visible then
      if not LocateBuilding(cxComboBoxSearch.Text,TreeViewAll) then
        Application.MessageBox('未找到室分点！','提示',MB_OK	);
    if TreeViewSub.Visible then
      if not LocateBuilding(cxComboBoxSearch.Text,TreeViewSub) then
        Application.MessageBox('未找到室分点！','提示',MB_OK	);
    if TreeViewDRS.Visible then
      if not LocateBuilding(cxComboBoxSearch.Text,TreeViewDRS) then
        Application.MessageBox('未找到室分点！','提示',MB_OK	);
  end;
  lClientDataSet:= TClientDataSet.Create(nil);
  if RBDRS.Checked then
  begin
    if trim(cxComboBoxSearch.Text)='' then
    begin
      Application.MessageBox('先输入查询条件', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    with DM_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:= Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,50,cxComboBoxSearch.Text]),1);
      if recordcount=0 then
      begin
        Application.MessageBox(pchar('未模糊匹配到该设备['+cxComboBoxSearch.Text+']'), '提示', MB_OK + MB_ICONINFORMATION);
        exit;
      end
      else
      if recordcount=1 then
      begin
        if FieldByName('isprogram').AsInteger=1 then //1是室内
        begin
          GetPathListIN(DM_MTS.cds_common,FPathListIN);
          if TreeViewAll.Visible then          
            lNode:= GetLocateNode(TreeViewAll,FPathListIN);
          if TreeViewDRS.Visible then
            lNode:= GetLocateNode(TreeViewDRS,FPathListIN);
        end
        else
        begin
          GetPathListOUT(DM_MTS.cds_common,FPathListOUT);
          if TreeViewAll.Visible then
            lNode:= GetLocateNode(TreeViewAll,FPathListOUT);
          if TreeViewDRS.Visible then
            lNode:= GetLocateNode(TreeViewDRS,FPathListOUT);
        end;
      end
      else
      begin
        if recordcount>1 then
        begin
          with TFormDRSSearch.Create(nil) do
          begin
            try
              DataSource1.DataSet:= DM_MTS.cds_common;
              cxGridDRSSearchDBTableView1.ApplyBestFit();
              if ShowModal=mrOK then
              begin
                if IsBuilding then
                begin
                  with lClientDataSet do
                  begin
                    close;
                    ProviderName:= 'dsp_General_data';
                    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,48,DRSID]),1);
                  end;
                  GetPathListIN(lClientDataSet,FPathListIN);
                  if TreeViewAll.Visible then
                    lNode:= GetLocateNode(TreeViewAll,FPathListIN);
                  if TreeViewDRS.Visible then
                    lNode:= GetLocateNode(TreeViewDRS,FPathListIN);
                end
                else
                begin
                  lClientDataSet.close;
                  lClientDataSet.ProviderName:= 'dsp_General_data';
                  lClientDataSet.Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,49,DRSID]),0);
                  GetPathListOUT(lClientDataSet,FPathListOUT);
                  if TreeViewAll.Visible then                  
                    lNode:= GetLocateNode(TreeViewAll,FPathListOUT);
                  if TreeViewDRS.Visible then
                    lNode:= GetLocateNode(TreeViewDRS,FPathListOUT);
                end;
              end;
              if lNode<>nil then
              begin
                lNode.ImageIndex:= 16; 
                lNode.SelectedIndex:= 38;
                lNode.Selected:= True;
                TreeViewAll.Selected:= lNode;
              end;
            finally
              Close;
              Free;
              lClientDataSet.Free;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TFm_MainForm.GetPathListIN(aDataSet: TClientDataSet;
  aPathList: TStringList);
begin
  aPathList.Clear;
  if aDataSet.Active and (aDataSet.RecordCount>0) then
  begin
    aPathList.Add(aDataSet.FieldByName('provicename').AsString);
    aPathList.Add(aDataSet.FieldByName('cityname').AsString);
    aPathList.Add(aDataSet.FieldByName('areaname').AsString);
    aPathList.Add(aDataSet.FieldByName('suburbname').AsString);
    aPathList.Add(aDataSet.FieldByName('isprogramname').AsString);
    //由于界面上的树节点是显示bts_name 所以末个字段用bts_name
    aPathList.Add(aDataSet.FieldByName('buildingname').AsString);
    aPathList.Add(aDataSet.FieldByName('DRS').AsString);
    aPathList.Add(aDataSet.FieldByName('DRSNAME').AsString);
  end;
end;

procedure TFm_MainForm.GetPathListOUT(aDataSet: TClientDataSet;
  aPathList: TStringList);
begin
  aPathList.Add(aDataSet.FieldByName('provicename').AsString);
    aPathList.Add(aDataSet.FieldByName('cityname').AsString);
    aPathList.Add(aDataSet.FieldByName('areaname').AsString);
    aPathList.Add(aDataSet.FieldByName('suburbname').AsString);
    aPathList.Add(aDataSet.FieldByName('isprogramname').AsString);
    //由于界面上的树节点是显示bts_name 所以末个字段用bts_name
    aPathList.Add(aDataSet.FieldByName('DRS').AsString);
    aPathList.Add(aDataSet.FieldByName('DRSNAME').AsString);
end;

procedure TFm_MainForm.cxComboBoxSearchPropertiesChange(Sender: TObject);
begin
  DarkMatch_BUILDING(PublicParam.cityid,PublicParam.areaid,'buildingname',cxComboBoxSearch.Text,cxComboBoxSearch.Properties.Items);
end;

procedure TFm_MainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:integer;
begin
  TimerRing.Enabled:= False;
  
  if assigned(FormBuildingParticular) then
    FormBuildingParticular.Close;
  if assigned(FormTestParticular) then
    FormTestParticular.Close;
  if assigned(FormWirelessParticular) then
    FormWirelessParticular.Close;
    


  for i:=TabSet.Tabs.Count-1 downto 0 do
  begin
    TForm(TabSet.Tabs.Objects[i]).Close;
  end;
end;

procedure TFm_MainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FThreadFlag then
  begin
    if Application.MessageBox('正在创建图层，关闭程序将导致异常，确定强制关闭？','提示',MB_OKCANCEL+MB_ICONSTOP)=IDOK then
      CanClose:=true 
    else CanClose:=false;
  end else
  begin
    if Application.MessageBox('程序将关闭，相关信息是否已保存？','提示',MB_OKCANCEL+MB_ICONSTOP)=IDOK then
      CanClose:=true
    else CanClose:=false;
  end;
end;

procedure TFm_MainForm.FormCreate(Sender: TObject);
begin
  FPathListIN:= TStringList.Create;
  FPathListOUT:= TStringList.Create;
end;

procedure TFm_MainForm.FormDestroy(Sender: TObject);
begin
  if IdClient.Connected then
    IdClient.Disconnect;
  if ClientThread <> nil then
    ClientThread.Free;
  FPathListIN.Free;
  FPathListOUT.Free;
end;

procedure TFm_MainForm.FormShow(Sender: TObject);
var
  lRetryCount:integer;
  lUserNo,lPassword:string;
  lResult:integer;
  lUserName :OleVariant;
begin
  // 登录
  if not ConnectAppServer then
  begin
    Application.MessageBox('应用服务连接失败，请检查网络及配置文件！','登录',MB_OK	);
    Application.Terminate;
    exit;
  end;

  FormLogin:= TFormLogin.Create(self);
  FormLogin.LabelTitle.Caption:=self.Caption;
  FormLogin.LabelVer.Caption:='版本:2.5';

  FormLogin.LoadUser;
  lRetryCount:=0;
  try
    repeat
      FormLogin.EditPassword.Clear;
      if FormLogin.ShowModal=mrOK then
      begin
        //密码校验
        lUserNo:=Trim(FormLogin.EditUserName.Text);
        lPassword:=FormLogin.EditPassword.Text;
        lResult:=3;
        try
          lResult:=Dm_MTS.SocketConnection1.AppServer.login(lUserNo,lPassword,lUserName);
        except

        end;
        if lResult =1 then  //成功
        begin
          FormLogin.SaveUser(lUserNo);
          self.StatusBar1.Panels[0].Text:='当前用户：'+String(lUserNo);
          break;
        end
        else
        begin
          Application.MessageBox('用户名或口令有误！','登录',MB_OK	);
        end;
      end
      else
      begin
        Application.Terminate;
        exit;
      end;
      lRetryCount:=lRetryCount+1;
    until lRetryCount=3;
  finally
    FormLogin.Free;
  end;
  if lRetryCount>=3 then
  begin
    Application.MessageBox('禁止非法登录！','登录',MB_OK	);
    Application.Terminate;
    exit;
  end;
  InitUserInfo(lUserNo);
  if not IdClient.Connected then
  begin
    try
      IdClient.Connect;
      SendMessageToServer(100);
      ClientThread := TClientMessageThread.Create();
      ClientThread.FreeOnTerminate := false;
      ClientThread.Resume;
    except
      on E: Exception do
      begin
          Application.MessageBox('连接实时消息服务器错误,无法获取通知信息!', '警告', MB_OK + MB_ICONINFORMATION);
      end;
    end;
  end;
  //显示全局树图
  TreeViewAll.Images :=BarImageList;
  TreeViewSub.Images :=BarImageList;
  TreeViewDRS.Images :=BarImageList;
  InitTree(TreeViewAll,Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid);
  //显示室分点树图
  InitTree(TreeViewSub,Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,4);
  //显示直放站树图
  InitTree(TreeViewDRS,Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,10,True);
  //显示连接器树图
  LinkTree :=TDBThreeStateTree.Create(Application);
  with LinkTree,LinkTree.DBProperties do
  begin
    Align := alClient;
    Parent := PanelLinktree;
    Images := Fm_MainForm.BarImageList;
    TopFieldName :='top_id';
    IDFieldName :='id';
    ShowFieldName :='Name';
    readonly := true;
  end;
  LinkTree.OnMouseDown := LinkTreeMouseDown;
  //显示统计树
  StatTree :=TDBThreeStateTree.Create(Application);
  with StatTree,StatTree.DBProperties do
  begin
    Align := alClient;
    Parent := PanelStatTree;
    Images := Fm_MainForm.ImageListStatusTree;
    TopFieldName :='top_id';
    IDFieldName :='id';
    ShowFieldName :='Name';
    readonly := true;
  end;
  StatTree.OnMouseDown := StatTreeMouseDown;
  //直放站状态树
  DRSStatTree := TDBThreeStateTree.Create(Application);
  with DRSStatTree,DRSStatTree.DBProperties do
  begin
    Align := alClient;
    Parent := PanelDRS;
    Images := Fm_MainForm.ImageListStatusTree;
    TopFieldName :='top_id';
    IDFieldName :='id';
    ShowFieldName :='Name';
    readonly := true;
  end;
  LoadUserTreeSet;
  //隐藏连接树
  AutoVisiableTree;
  //显示告警树信息
  ShowAlarmCounts;

  TimerRing.Enabled:= True;
end;

procedure TFm_MainForm.GetNodeList(aNodeType: TNodeType;
aNodeList: TStringList;
  aTree: TTreeView);
var
  I: Integer;
begin
//  ClearTStrings(aNodeList);
  with aTree do
  begin
    for I := 0 to aTree.Items.Count - 1 do
    begin
      if Items[i].Data<>nil then
      begin
        if (TNodeParam(aTree.Items[i].Data).nodeType=aNodeType)
          and (not TNodeParam(aTree.Items[i].Data).HaveExpanded) then
        begin
          aNodeList.AddObject(inttostr(i),TTreeNode(Items[i]));
        end;
      end;
    end;
  end;
end;

//派障
procedure TFm_MainForm.HandleMessage1;
begin
  if assigned(FormAlarmMonitor) then
   FormAlarmMonitor.ShowAlarm_Online;
end;

//排障
procedure TFm_MainForm.HandleMessage2;
begin
  if assigned(FormAlarmMonitor) then
  begin
   FormAlarmMonitor.ShowAlarm_Online;
   FormAlarmMonitor.ShowAlarm_History;
  end;
end;

//手动测试结果反馈
procedure TFm_MainForm.HandleMessage3;
begin
  if assigned(Fm_AlarmTest) then
   Fm_AlarmTest.RefreshTask;
end;

//初始化登陆用户基本信息
procedure TFm_MainForm.InitPriv;
var
  i:integer;
  lPrivText :string;
  lPrivList:TStringList;
   lAction:TAction;
  function isEnable(aTag:integer):boolean;
  begin
    result:=false;
    if lPrivList.IndexOf(IntToStr(aTag))>-1 then
        result:=true;
    if aTag=0 then
      result:=true;
  end;
begin
  lPrivList:=TStringList.Create;
  lPrivText:=Dm_MTS.TempInterface.GetPriv(PublicParam.userid);
  lPrivList.Delimiter:=';';
  lPrivList.DelimitedText:=  lPrivText;
  for i := 0 to  ActionManager1.ActionCount- 1 do
  begin
    lAction:=ActionManager1.Actions[i] as TAction;
    if lAction.Visible then
      lAction.Visible:=isEnable(lAction.Tag);
  end;
end;
//
procedure TFm_MainForm.InitPublicParam(lUserNo:String);
begin
  With Dm_MTS.cds_common Do
  begin
     Close;
     ProviderName:='dsp_General_data';
     Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,5,lUserNo]),0);   //
     if RecordCount > 0 then
     begin
       with PublicParam do
       begin   
         PublicParam.userid := FieldByName('userid').AsInteger;
         PublicParam.userno := FieldByName('userno').AsString;
         PublicParam.cityid := FieldByName('cityid').AsInteger;
         PublicParam.areaid := FieldByName('areaid').AsInteger;
       end;
     end;
     Close;
  end;
  PublicParam.AlarmShowDay := StrToInt(GetSysParamSet(1,1));
  PublicParam.PriveAreaidStrs:= GetPriveArea(PublicParam.cityid,PublicParam.areaid);
end;

procedure TFm_MainForm.N23Click(Sender: TObject);
begin
  if TreeViewAll.Visible then
    InitTree(TreeViewAll,Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid)
  else if TreeViewSub.Visible then       
    InitTree(TreeViewSub,Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,4)
  else if TreeViewDRS.Visible then
    InitTree(TreeViewDRS,Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,10,True);
end;



procedure TFm_MainForm.NBuildingParticularClick(Sender: TObject);
var
  lNode: TTreeNode;
  lbuildingid: integer;
begin
  if TreeViewAll.Visible then
    lNode:= TreeViewAll.Selected
  else
    lNode:= TreeViewSub.Selected;
  if (lNode=nil) or (lNode.Data=nil) then exit;
  lbuildingid:= TNodeParam(lNode.Data).BuildingId;
  if lbuildingid>0 then
  begin
    if not assigned(FormBuildingParticular) then
      FormBuildingParticular:=TFormBuildingParticular.Create(nil);
    FormBuildingParticular.Analysistype:= 1;
    FormBuildingParticular.BUILDINGID:= lBuildingid;
    FormBuildingParticular.MTUID:= 0;
    FormBuildingParticular.Show;
    FormBuildingParticular.LoadBuildingInfo;
  end;
end;

procedure TFm_MainForm.NCloseClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to Fm_MainForm.MDIChildCount-1 do
    if Fm_MainForm.MDIChildren[i].Caption = tabSet.Tabs.Strings[TabSet.TabIndex] then
      begin
        Fm_MainForm.MDIChildren[i].Close;
        Break;
      end;
end;

procedure TFm_MainForm.NDRSConfigClick(Sender: TObject);
var
  i, lDRSID, lDRS_Index: Integer;
  lNode: TTreeNode;
begin
  if TreeViewAll.Visible then
    lNode:= TreeViewAll.Selected
  else if TreeViewDRS.Visible then
    lNode:= TreeViewDRS.Selected;
  if (lNode=nil) or (lNode.Data=nil) then exit;
  lDRSID:= TNodeParam(lNode.Data).DRSID;
  if not assigned(FrmDRSConfig) then
  begin
    FrmDRSConfig:=TFrmDRSConfig.Create(Self);
    AddToTab(FrmDRSConfig);
  end;
  SetTabIndex(FrmDRSConfig);
  FrmDRSConfig.WindowState:=wsMaximized;
  FrmDRSConfig.Show;
  FrmDRSConfig.tsDRSConfigInfo.Show;

  FrmDRSConfig.CDSDRS.Locate('DRSID',lDRSID,[]);
  FrmDRSConfig.cxGridDBTVDRSList.DataController.ClearSelection;
  lDRS_Index:= FrmDRSConfig.cxGridDBTVDRSList.GetColumnByFieldName('DRSID').Index;
  for i:=FrmDRSConfig.cxGridDBTVDRSList.DataController.RowCount-1 downto 0 do
  begin
    if lDRSID=FrmDRSConfig.cxGridDBTVDRSList.DataController.GetValue(i,lDRS_Index) then
    begin
      FrmDRSConfig.cxGridDBTVDRSList.DataController.SelectRows(i,i);
      FrmDRSConfig.cxGridDBTVDRSListMouseUp(Self,mbLeft,[ssLeft],1,1); 
      FrmDRSConfig.cxGridDBTVDRSList.Focused:= True;
      Exit;
    end;
  end; 
end;

procedure TFm_MainForm.NDRSInfoClick(Sender: TObject);
var
  lNode: TTreeNode;
  lSuburbid, lbuildingid: integer;
  lDRSid: integer;
begin
  if TreeViewAll.Visible then
    lNode:= TreeViewAll.Selected
  else if  TreeViewSub.Visible then
    lNode:= TreeViewSub.Selected
  else if TreeViewDRS.Visible then
    lNode:= TreeViewDRS.Selected;   
  if (lNode=nil) or (lNode.Data=nil) then exit;
  lSuburbid:= TNodeParam(lNode.Data).Suburbid;
  lbuildingid:= TNodeParam(lNode.Data).BuildingId;
  lDRSid:= TNodeParam(lNode.Data).DRSID;
  if lDRSid>0 then
  begin
//    if not assigned(FormBuildingParticular) then
//      FormBuildingParticular:=TFormBuildingParticular.Create(nil);
//    if lbuildingid=0 then //室外
//      FormBuildingParticular.Analysistype:= 3
//    else
//      FormBuildingParticular.Analysistype:= 1;
//    FormBuildingParticular.Suburbid:= lSuburbid;
//    FormBuildingParticular.BUILDINGID:= lBuildingid;
//    FormBuildingParticular.MTUID:= lDRSid;
//    FormBuildingParticular.Show;
//    FormBuildingParticular.LoadBuildingInfo;
    if not assigned(FormDRSParticular) then
      FormDRSParticular:=TFormDRSParticular.Create(nil);
    FormDRSParticular.DRSID:= lDRSid;
    FormDRSParticular.Show;
  end;
end;

procedure TFm_MainForm.NGISPositionClick(Sender: TObject);
var
  lDRSID, lBuildingID: Integer;
  lNode: TTreeNode;
begin
  if Assigned(FormAlarmMonitor) then
  begin
    SetTabIndex(FormAlarmMonitor);
    FormAlarmMonitor.Show;
    if TreeViewAll.Visible then
      lNode:= TreeViewAll.Selected
    else if  TreeViewSub.Visible then
      lNode:= TreeViewSub.Selected
    else if TreeViewDRS.Visible then
      lNode:= TreeViewDRS.Selected;   
    if (lNode=nil) or (lNode.Data=nil) then exit;

    Screen.Cursor := crHourGlass;
    try
      lDRSid:= TNodeParam(lNode.Data).DRSID;
      lBuildingID:= TNodeParam(lNode.Data).BuildingId;
      if lBuildingID<>0 then
        FormAlarmMonitor.Location(UD_LAYER_BUILDING,inttostr(lBuildingID))
      else
        FormAlarmMonitor.Location(UD_LAYER_DRS,inttostr(lDRSID));
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFm_MainForm.NMaxClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to Fm_MainForm.MDIChildCount-1 do
    if Fm_MainForm.MDIChildren[i].Caption=tabset.tabs.Strings[tabset.TabIndex] then
    begin
       Fm_MainForm.MDIChildren[i].WindowState:=wsMaximized;
       break;
    end;
end;

procedure TFm_MainForm.NMinClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to Fm_MainForm.MDIChildCount-1 do
    if Fm_MainForm.MDIChildren[i].Caption=tabset.tabs.Strings[tabset.TabIndex] then
      begin
       Fm_MainForm.MDIChildren[i].WindowState:=wsMinimized;
       break;
      end;
end;

procedure TFm_MainForm.NMtuParticularClick(Sender: TObject);
var
  lNode: TTreeNode;
  lbuildingid: integer;
  lMtuid: integer;
begin
  if TreeViewAll.Visible then
    lNode:= TreeViewAll.Selected
  else
    lNode:= TreeViewSub.Selected;
  if (lNode=nil) or (lNode.Data=nil) then exit;
  lbuildingid:= TNodeParam(lNode.Data).BuildingId;
  lMtuid:= TNodeParam(lNode.Data).MTUID;
  if lMtuid>0 then
  begin
    if not assigned(FormBuildingParticular) then
      FormBuildingParticular:=TFormBuildingParticular.Create(nil);
    if lbuildingid=0 then //室外
      FormBuildingParticular.Analysistype:= 2
    else
      FormBuildingParticular.Analysistype:= 1;
    FormBuildingParticular.BUILDINGID:= lBuildingid;
    FormBuildingParticular.MTUID:= lMtuid;
    FormBuildingParticular.Show;
    FormBuildingParticular.LoadBuildingInfo;
  end;
end;

procedure TFm_MainForm.NRestoreClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to Fm_MainForm.MDIChildCount-1 do
  if Fm_MainForm.MDIChildren[i].Caption=tabset.tabs.Strings[tabset.TabIndex] then
  begin
    Fm_MainForm.MDIChildren[i].WindowState:=wsnormal;
    break;
  end;
end;

procedure TFm_MainForm.NTestParticularClick(Sender: TObject);
var
  lNode: TTreeNode;
  lmtuid: integer;
begin
  lNode:= TreeViewAll.Selected;
  if (lNode=nil) or (lNode.Data=nil) then exit;
  lmtuid:= TNodeParam(lNode.Data).MTUID;
  if lmtuid>0 then
  begin
    if not assigned(FormTestParticular) then
      FormTestParticular:=TFormTestParticular.Create(nil);
    FormTestParticular.MTUID:= lmtuid;
    FormTestParticular.Show;
  end;
end;

procedure TFm_MainForm.NwirelessClick(Sender: TObject);
var
  lNode: TTreeNode;
  lmtuid: integer;
begin
  if TreeViewAll.Visible then
    lNode:= TreeViewAll.Selected
  else
    lNode:= TreeViewSub.Selected;
  if (lNode=nil) or (lNode.Data=nil) then exit;
  lmtuid:= TNodeParam(lNode.Data).MTUID;
  if lmtuid>0 then
  begin
    if not assigned(FormWirelessParticular) then
      FormWirelessParticular:=TFormWirelessParticular.Create(nil);
    FormWirelessParticular.MTUID:= lmtuid;
    FormWirelessParticular.Show;
    FormWirelessParticular.ShowWirelessParticular;
  end;
end;

procedure TFm_MainForm.PopupMenu2Popup(Sender: TObject);
var
  lNode: TTreeNode;
begin
  Nwireless.Visible:= false;
  NTestParticular.Visible:= false;
  NBuildingParticular.Visible:= false;
  NMtuParticular.Visible:= false;
  NGISPosition.Visible:= False;
  NDRSInfo.Visible:= False;
  NDRSConfig.Visible:= False;
  lNode:= TTreeView(TPopupMenu(sender).PopupComponent).Selected;
  if (lNode=nil) or (lNode.Data=nil) then exit;
  if TNodeParam(lNode.Data).nodeType=MTU then
  begin
    Nwireless.Visible:= true;
    NTestParticular.Visible:= true;
    NMtuParticular.Visible:= true;
  end;
  if TNodeParam(lNode.Data).nodeType=BUILDING then
  begin
    NBuildingParticular.Visible:= true;
  end;
  if TNodeParam(lNode.Data).nodeType=DRS then
  begin
    NGISPosition.Visible:= True;
    NDRSInfo.Visible:= True;
    if TreeViewDRS.Visible then
      NDRSConfig.Visible:= False;
    if TreeViewAll.Visible then
      NDRSConfig.Visible:= True;        
  end;
end;

{ TClientMessageThread }

constructor TClientMessageThread.Create;
begin
   inherited Create(true);
end;

procedure TClientMessageThread.Execute;
var
  Buf: TIdBytes;
begin
  inherited;
  while (not Terminated)and(Fm_MainForm.IdClient.Connected) do
  begin
    try
      SetLength(Buf,0);  
      Fm_MainForm.IdClient.IOHandler.ReadBytes(Buf,SizeOf(Rcmd));
      BytesToRaw(Buf,cmd,SizeOf(Rcmd));
      //按照命令来处理
      case cmd.command of
      1,2,3 : //派障、排障
        begin
          Synchronize(HandleMessage);
        end;
      end;
    except
      Terminate;
    end;
  end;
end;
procedure TClientMessageThread.HandleMessage;
begin
  case cmd.command of
    1: Fm_MainForm.HandleMessage1;
    2: Fm_MainForm.HandleMessage2;
    3: Fm_MainForm.HandleMessage3;
  end;
end;

procedure TFm_MainForm.TimerRingTimer(Sender: TObject);
var
  lNewRingFileName, lNewRingFileNameResend: WideString;
  lIsRing, lIsRingResend: Integer;
begin
  Dm_MTS.TempInterface.GetRingRemind(PublicParam.CityID,PublicParam.userid,1,lIsRing,lNewRingFileName);
  if lIsRing=1 then
  begin
    if Assigned(FormRingPopupWindowsResend) then
    begin
      Dm_MTS.TempInterface.GetRingRemind(PublicParam.CityID,PublicParam.userid,2,lIsRingResend,lNewRingFileNameResend);
      if lIsRingResend=1 then
        Exit
      else
      begin
        FormRingPopupWindowsResend.Close;
        FreeAndNil(FormRingPopupWindowsResend);
      end;
    end;
    lNewRingFileName:= GetLoacalRingWave(lNewRingFileName);
    if not Assigned(FormRingPopupWindowsSend) then
      FormRingPopupWindowsSend:= TFormRingPopupWindows.Create(Application,True,lNewRingFileName,1)
    else
      if lNewRingFileName<>FRingFileName then
      begin
        FormRingPopupWindowsSend.Close;
        FreeAndNil(FormRingPopupWindowsSend);
        FormRingPopupWindowsSend:= TFormRingPopupWindows.Create(Application,True,lNewRingFileName,1);
      end;
    FormRingPopupWindowsSend.FormStyle:= fsStayOnTop;
    FormRingPopupWindowsSend.Show;
  end
  else
  begin
    if Assigned(FormRingPopupWindowsSend) then
    begin
      FormRingPopupWindowsSend.Close;
      FreeAndNil(FormRingPopupWindowsSend);
    end;

    Dm_MTS.TempInterface.GetRingRemind(PublicParam.CityID,PublicParam.userid,2,lIsRing,lNewRingFileName);
    if lIsRing=1 then
    begin
      lNewRingFileName:= GetLoacalRingWave(lNewRingFileName);
      if not Assigned(FormRingPopupWindowsResend) then
        FormRingPopupWindowsResend:= TFormRingPopupWindows.Create(Application,True,lNewRingFileName,2)
      else
      if lNewRingFileName<>FRingFileName then
      begin
        FormRingPopupWindowsResend.Close;
        FreeAndNil(FormRingPopupWindowsResend);
        FormRingPopupWindowsResend:= TFormRingPopupWindows.Create(Application,True,lNewRingFileName,2);
      end;
      FormRingPopupWindowsResend.FormStyle:= fsStayOnTop;
      FormRingPopupWindowsResend.Show;
    end
    else
    begin
      if Assigned(FormRingPopupWindowsResend) then
      begin
        FormRingPopupWindowsResend.Close;
        FreeAndNil(FormRingPopupWindowsResend);
      end;
    end;
  end;
  FRingFileName:=lNewRingFileName;
end;

function TFm_MainForm.GetLoacalRingWave(aFileName: string): string;
begin
  if trim(aFileName)='' then result:= ''
  else
  result:= ExtractFilePath(Application.ExeName)+'Ringwave\'+aFileName;
end;

end.
