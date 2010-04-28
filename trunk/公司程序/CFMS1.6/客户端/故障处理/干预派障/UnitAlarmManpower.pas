unit UnitAlarmManpower;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ComCtrls, StdCtrls, cxContainer,
  cxTreeView, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  dxDockPanel, dxDockControl, dxBar, dxBarExtItems, XPStyleActnCtrls,
  ActnList, ActnMan, jpeg, ExtCtrls, DBClient, Menus, CxGridUnit, StringUtils,
  UDevExpressToChinese, ImgList;

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
  TFormAlarmManpower = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    ActionManager1: TActionManager;
    dxDockingManager1: TdxDockingManager;
    dxBarManager1: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarManager1Bar7: TdxBar;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarSubItem3: TdxBarSubItem;
    dxBarSubItem4: TdxBarSubItem;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
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
    dxBarButton15: TdxBarButton;
    dxBarButton16: TdxBarButton;
    dxBarButton17: TdxBarButton;
    dxBarButton18: TdxBarButton;
    dxBarButton19: TdxBarButton;
    dxBarButton20: TdxBarButton;
    dxBarButton21: TdxBarButton;
    dxBarButton22: TdxBarButton;
    dxBarButton23: TdxBarButton;
    dxBarButton24: TdxBarButton;
    dxBarButton25: TdxBarButton;
    dxBarButton26: TdxBarButton;
    dxBarEditFilter: TdxBarEdit;
    dxBarButton27: TdxBarButton;
    dxBarComboCompany: TdxBarCombo;
    dxBarButton28: TdxBarButton;
    CustomdxBarComboFilter: TCustomdxBarCombo;
    dxBarComboFilter: TdxBarCombo;
    dxBarButton29: TdxBarButton;
    dxBarButton30: TdxBarButton;
    dxDockSite1: TdxDockSite;
    dxLayoutDockSite7: TdxLayoutDockSite;
    dxLayoutDockSite6: TdxLayoutDockSite;
    dxLayoutDockSite5: TdxLayoutDockSite;
    dxLayoutDockSite1: TdxLayoutDockSite;
    dxLayoutDockSite4: TdxLayoutDockSite;
    dxLayoutDockSite2: TdxLayoutDockSite;
    dxDockPanel2: TdxDockPanel;
    cxGridAlarmMaster: TcxGrid;
    cxGridAlarmMasterDBTableView1: TcxGridDBTableView;
    cxGridAlarmMasterLevel1: TcxGridLevel;
    dxDockPanel3: TdxDockPanel;
    dxDockPanel1: TdxDockPanel;
    cxTreeView1: TcxTreeView;
    dxDockPanel4: TdxDockPanel;
    cxGridAlarmDetail: TcxGrid;
    cxGridAlarmDetailDBTableView1: TcxGridDBTableView;
    cxGridAlarmDetailLevel1: TcxGridLevel;
    dxDockPanel5: TdxDockPanel;
    cxGridCompany: TcxGrid;
    cxGridCompanyDBTableView1: TcxGridDBTableView;
    cxGridCompanyDBTableView2: TcxGridDBTableView;
    cxGridCompanyLevel1: TcxGridLevel;
    cxGridCompanyLevel2: TcxGridLevel;
    dxDockPanel6: TdxDockPanel;
    cxGridFlow: TcxGrid;
    cxGridFlowDBTableView1: TcxGridDBTableView;
    cxGridFlowLevel1: TcxGridLevel;
    dxBarButton31: TdxBarButton;
    DS_AlarmMaster: TDataSource;
    CDS_AlarmMaster: TClientDataSet;
    CDS_Detail: TClientDataSet;
    DS_Detail: TDataSource;
    DS_Flow: TDataSource;
    CDS_Flow: TClientDataSet;
    CDS_Company: TClientDataSet;
    DS_Company: TDataSource;
    DS_CompanyDetail: TDataSource;
    CDS_CompanyDetail: TClientDataSet;
    ActionRead: TAction;
    ActionDel: TAction;
    ActionSend: TAction;
    ActionRemark: TAction;
    imBarIcons: TImageList;
    ImageTree: TImageList;
    dxBarEditFilters: TdxBarEdit;
    Timer1: TTimer;
    EditFilter: TEdit;
    dxBarButton32: TdxBarButton;
    ActionRefresh: TAction;
    dxBarButton33: TdxBarButton;
    ActionAutofresh: TAction;
    TimerAutofresh: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure cxGridAlarmMasterDBTableView1CellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure ActionReadExecute(Sender: TObject);
    procedure ActionDelExecute(Sender: TObject);
    procedure ActionSendExecute(Sender: TObject);
    procedure ActionRemarkExecute(Sender: TObject);
    procedure cxGridAlarmMasterEnter(Sender: TObject);
    procedure cxGridAlarmMasterExit(Sender: TObject);
    procedure cxGridAlarmDetailExit(Sender: TObject);
    procedure cxGridAlarmDetailEnter(Sender: TObject);
    procedure cxGridCompanyEnter(Sender: TObject);
    procedure cxGridCompanyExit(Sender: TObject);
    procedure cxGridFlowEnter(Sender: TObject);
    procedure cxGridFlowExit(Sender: TObject);
    procedure dxDockPanel1AutoHideChanged(Sender: TdxCustomDockControl);
    procedure dxDockPanel1AutoHideChanging(Sender: TdxCustomDockControl);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure dxBarManager1Docking(Sender: TdxBar;
      Style: TdxBarDockingStyle; DockControl: TdxDockControl;
      var CanDocking: Boolean);
    procedure FormResize(Sender: TObject);
    procedure dxBarButton27Click(Sender: TObject);
    procedure EditFilterKeyPress(Sender: TObject; var Key: Char);
    procedure ActionRefreshExecute(Sender: TObject);
    procedure cxGridCompanyDBTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure ActionAutofreshExecute(Sender: TObject);
    procedure TimerAutofreshTimer(Sender: TObject);
    procedure cxGridFlowDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
  private
    //条件
    gAlarmStatusWhere: string;
    gGlobalWhere: string;
    gFilterWhere: string;
    gActiveGridView: TActiveGridView;
    FControlChanging: boolean;
    //FTCPClient: TTCPClient;
    //gCurrNodeCode: integer;
    gClick_Cityid, gClick_Companyid, gClick_Batchid, gClick_Devid: integer;
    gClick_RecordChanged: boolean;
    gActiveDockPanel: TActiveDockPanel;
    gChangedDockPanel: TChangedDockPanel;
    
    FMenuReaded, FMenuDelete, FMenuSend, FMenuRemark, FMenuRefresh: TMenuItem;

    FCxGridHelper : TCxGridSet;
    gFlowColorList: TStringList;

    procedure AddFlowField(aView: TcxGridDBTableView);
    procedure OnUserPopup(Sender: TObject);
    procedure cxGridAlarmMasterDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure ActionUseable(aCurrNodeCode: integer);//根据树的状态更新ACTIONLIST
    procedure ResizeFilter;
    procedure dxDockPanelVisibleChanged(Sender: TdxCustomDockControl);
  public
    procedure ShowMasterAlarmOnline;
    procedure ShowFlowRecOnline(aDeviceid, aCompanyid, aCityid: integer);
    procedure ShowDetailAlarmOfCompany(aBatchid, aCompanyid, aCityid: integer);
    procedure ShowDetailAlarmOnline(aCompanyid, aCityid,aDeviceid: integer);
    procedure ShowMasterAlarmOfCompany(aDeviceid, aCompanyid, aCityid: integer);
    {发送消息}
    procedure SendMessageToServer(aComid: integer);
  end;

var
  FormAlarmManpower: TFormAlarmManpower;

implementation

uses UnitVFMSGlobal, UnitDllCommon, UnitUserSign, UnitAlarmChange;

{$R *.dfm}

procedure TFormAlarmManpower.FormCreate(Sender: TObject);
begin
  gFlowColorList:= TStringList.Create;
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.OnUserDrawCell:= cxGridAlarmMasterDBTableView1CustomDrawCell;
  FCxGridHelper.NewSetGridStyle(cxGridAlarmMaster,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridAlarmDetail,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridFlow,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridCompany,true,true,true);
  TPopupMenu(cxGridAlarmMaster.PopupMenu).OnPopup:= OnUserPopup;

  FCxGridHelper.AppendMenuItem('-',nil);
  FMenuReaded:= FCxGridHelper.AppendMenuItem('查看',ActionReadExecute);
  FMenuDelete:= FCxGridHelper.AppendMenuItem('删除',ActionDelExecute);
  FMenuSend:= FCxGridHelper.AppendMenuItem('派发',ActionSendExecute);
  FMenuRemark:= FCxGridHelper.AppendMenuItem('备注',ActionRemarkExecute);
  FMenuRefresh:= FCxGridHelper.AppendShowMenuItem('刷新',ActionRefreshExecute,true);

  LoadFields(cxGridAlarmMasterDBTableView1,gPublicParam.cityid,gPublicParam.userid,11);
  LoadFields(cxGridAlarmDetailDBTableView1,gPublicParam.cityid,gPublicParam.userid,12);
  LoadFields(cxGridCompanyDBTableView1,gPublicParam.cityid,gPublicParam.userid,13);
  LoadFields(cxGridCompanyDBTableView2,gPublicParam.cityid,gPublicParam.userid,14);
  LoadFields(cxGridFlowDBTableView1,gPublicParam.cityid,gPublicParam.userid,32);
  AddHindFlowField(cxGridFlowDBTableView1);

  //设置自动刷新
  TimerAutofresh.Enabled:= ActionAutofresh.Caption='锁定刷新';
  dxDockPanel4.OnVisibleChanged:=dxDockPanelVisibleChanged;
  dxDockPanel5.OnVisibleChanged:=dxDockPanelVisibleChanged;
  dxDockPanel6.OnVisibleChanged:=dxDockPanelVisibleChanged;
end;

procedure TFormAlarmManpower.FormShow(Sender: TObject);
begin
  //画树
  cxTreeView1.Items.Clear;
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,34);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,3);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,2);
  SelectNode(cxTreeView1,'未查看');

  //LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,ComboBoxCompany.Items);
end;

procedure TFormAlarmManpower.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormAlarmManpower,1,'','');
end;

procedure TFormAlarmManpower.FormDestroy(Sender: TObject);
begin
  //菜单释放
  FCxGridHelper.Free;
  ClearTStrings(gFlowColorList);
end;

procedure TFormAlarmManpower.cxTreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
  //由于DOCKPANEL隐藏的时候会触发事件，所以要屏蔽掉
  if FControlChanging then exit;
  if (Node=nil) or (Node.Data=nil) then exit;
  case TNodeParam(Node.Data).Parentid of
    -1: begin
          gAlarmStatusWhere:= '';
    end
    //以下做过滤
    else case TNodeParam(Node.Data).NodeType of
           34:  begin//告警流程树
                  gAlarmStatusWhere:= ' '+TNodeParam(Node.Data).SetValue;
           end;
           2:   begin//告警类型
                  gAlarmStatusWhere:= ' and alarmtype='+inttostr(TNodeParam(Node.Data).id);
           end;
           3:   begin//告警级别
                  gAlarmStatusWhere:= ' and alarmlevel='+inttostr(TNodeParam(Node.Data).id);
           end;
         end;
  end;
  ShowMasterAlarmOnline;
  ActionUseable(TNodeParam(Node.Data).NodeCode);
end;

procedure TFormAlarmManpower.ShowMasterAlarmOnline;
begin
  //if not cxGridAlarmMaster.CanFocus then exit;

  DS_AlarmMaster.DataSet:= nil;
  try
    with CDS_AlarmMaster do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([25,1,gAlarmStatusWhere+gGlobalWhere+gFilterWhere]),0);
    end;
  finally

  end;
  DS_AlarmMaster.DataSet:= CDS_AlarmMaster;
  cxGridAlarmMasterDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmManpower.AddFlowField(aView: TcxGridDBTableView);
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


procedure TFormAlarmManpower.cxGridAlarmMasterDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  lReaded_Index: integer;
begin
  try
    lReaded_Index:=TcxGridDBTableView(Sender).GetColumnByFieldName('ISREADEDNAME').Index;
  except
    exit;
  end;
  if AViewInfo.GridRecord.Values[lReaded_Index]='未查看' then
    ACanvas.Brush.Color := $004080FF;
end;

procedure TFormAlarmManpower.cxGridAlarmMasterDBTableView1CellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  lCityid, lDeviceid,lCompanyid,lBatchid: integer;
begin
  try
    lCityid:= CDS_AlarmMaster.FieldByName('cityid').AsInteger;
    lDeviceid:= CDS_AlarmMaster.FieldByName('deviceid').AsInteger;
  except
    Application.MessageBox('未获得关键字段CITYID,DEVICEID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
    gClick_RecordChanged:= (gClick_Cityid<>lCityid) or (gClick_Companyid<>lCompanyid)
                          or (gClick_Batchid<>lBatchid) or (gClick_Devid<>lDeviceid);
  //if gClick_RecordChanged then
  begin
    gClick_Cityid:= lCityid;
    gClick_Companyid:= lCompanyid;
    gClick_Batchid:= lBatchid;
    gClick_Devid:= lDeviceid;

    gChangedDockPanel:= [];
    dxDockPanelVisibleChanged(dxDockPanel4);
    dxDockPanelVisibleChanged(dxDockPanel5);
    dxDockPanelVisibleChanged(dxDockPanel6);
  end;
  {ShowDetailAlarmOnline(lDeviceid,lCityid);
  ShowMasterAlarmOfCompany(lDeviceid,lCityid);
  ShowFlowRecOnline(lDeviceid,lCityid);}
end;

procedure TFormAlarmManpower.ShowDetailAlarmOnline( aCompanyid, aCityid,aDeviceid: integer);
begin
  //if not cxGridAlarmDetail.CanFocus then exit;

  DS_Detail.DataSet:= nil;
  try
    with CDS_Detail do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([25,1,' and cityid='+inttostr(aCityid)+' and deviceid='+inttostr(aDeviceid)]),0);
    end;
  finally

  end;
  DS_Detail.DataSet:= CDS_Detail;
  cxGridAlarmDetailDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmManpower.ShowFlowRecOnline(aDeviceid, aCompanyid, aCityid: integer);
var
  lCompanyid: integer;
  lCompanyidStr: string;
  lIndex: integer;
begin
  DS_Flow.DataSet:= nil;
  try
    with CDS_Flow do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,3,' and cityid='+inttostr(aCityid)+' and deviceid='+inttostr(aDeviceid)]),0);
    end;
  finally

  end;
  DS_Flow.DataSet:= CDS_Flow;
  //cxGridFlowDBTableView1.ApplyBestFit();
  if not GetFlowColorSet(CDS_Flow, gFlowColorList) then
    raise exception.Create('获取流程日志颜色设置失败');
end;

procedure TFormAlarmManpower.ShowDetailAlarmOfCompany(aBatchid, aCompanyid, aCityid: integer);
begin
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

procedure TFormAlarmManpower.ShowMasterAlarmOfCompany(aDeviceid, aCompanyid, aCityid: integer);
begin
 // if not cxGridCompany.CanFocus then exit;

  DS_Company.DataSet:= nil;
  try
    with CDS_Company do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,1,' and deviceid='+inttostr(aDeviceid)+' and cityid='+inttostr(aCityid)]),0);
    end;
  finally

  end;
  DS_Company.DataSet:= CDS_Company;
  cxGridCompanyDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmManpower.ActionReadExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lDeviceid,lContentcode,lCityid: integer;
  lDeviceid_Index,lContentcode_Index,lCityid_Index: integer;
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
      lDeviceid_Index:=lActiveView.GetColumnByFieldName('DEVICEID').Index;
      lContentcode_Index:=lActiveView.GetColumnByFieldName('ALARMCONTENTCODE').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段DEVICEID,ALARMCONTENTCODE,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];

        lDeviceid:= lActiveView.DataController.GetValue(lRecordIndex,lDeviceid_Index);
        lContentcode:= lActiveView.DataController.GetValue(lRecordIndex,lContentcode_Index);
        lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
        lWherestr:= lWherestr+' (deviceid='+inttostr(lDeviceid)+' and contentcode='+inttostr(lContentcode)+' and cityid='+inttostr(lCityid)+') or';
      end;
      lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update alarm_data_collect t set t.isreaded=1 where '+lWherestr;
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
        MessageBox(handle,'操作失败!','系统提示',MB_ICONWARNING)
      else
      begin
        lActiveView.DataController.DeleteSelection;
        MessageBox(handle,'操作成功!','系统提示',MB_ICONINFORMATION) ;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmManpower.ActionDelExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lDeviceid,lContentcode,lCityid: integer;
  lDeviceid_Index,lContentcode_Index,lCityid_Index: integer;
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
      lDeviceid_Index:=lActiveView.GetColumnByFieldName('DEVICEID').Index;
      lContentcode_Index:=lActiveView.GetColumnByFieldName('ALARMCONTENTCODE').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段DEVICEID,ALARMCONTENTCODE,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];

        lDeviceid:= lActiveView.DataController.GetValue(lRecordIndex,lDeviceid_Index);
        lContentcode:= lActiveView.DataController.GetValue(lRecordIndex,lContentcode_Index);
        lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
        lWherestr:= lWherestr+' (deviceid='+inttostr(lDeviceid)+' and contentcode='+inttostr(lContentcode)+' and cityid='+inttostr(lCityid)+') or';
      end;
      lWherestr:= copy(lWherestr,1,length(lWherestr)-3);

      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'delete from alarm_data_collect t where '+lWherestr;
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
        MessageBox(handle,'操作失败!','系统提示',MB_ICONWARNING)
      else
      begin
        //更新界面
        lActiveView.DataController.DeleteSelection;
        MessageBox(handle,'操作成功!','系统提示',MB_ICONINFORMATION) ;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmManpower.ActionSendExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lCoDeviceid_Index,lDeviceid_Index,lContentcode_Index,lCityid_Index: integer;
  lFormAlarmChange: TFormAlarmChange;
  lRecordIndex: integer;
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
      lDeviceid_Index:=lActiveView.GetColumnByFieldName('DEVICEID').Index;
      lCoDeviceid_Index:=lActiveView.GetColumnByFieldName('CODEVICEID').Index;
      lContentcode_Index:=lActiveView.GetColumnByFieldName('ALARMCONTENTCODE').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('未获得关键字段DEVICEID,ALARMCONTENTCODE,CITYID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lFormAlarmChange:= TFormAlarmChange.Create(nil);
    try
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lFormAlarmChange.gDeviceid:= lActiveView.DataController.GetValue(lRecordIndex,lDeviceid_Index);
      lFormAlarmChange.gCoDeviceid:= lActiveView.DataController.GetValue(lRecordIndex,lCoDeviceid_Index);
      lFormAlarmChange.gContentcode:= lActiveView.DataController.GetValue(lRecordIndex,lContentcode_Index);
      lFormAlarmChange.gCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
      if lFormAlarmChange.ShowModal=mrOk then
      begin
        //
      end;
    finally
      lFormAlarmChange.free;
    end;
  end;
end;

procedure TFormAlarmManpower.ActionRemarkExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lDeviceid,lContentcode,lCityid: integer;
  lDeviceid_Index,lContentcode_Index,lCityid_Index: integer;
  lRemark_Index: integer;
  lRemark: string;
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
      lDeviceid_Index:=lActiveView.GetColumnByFieldName('DEVICEID').Index;
      lContentcode_Index:=lActiveView.GetColumnByFieldName('ALARMCONTENTCODE').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lRemark_Index:= lActiveView.GetColumnByFieldName('REMARK').Index;
    except
      Application.MessageBox('未获得关键字段DEVICEID,ALARMCONTENTCODE,CITYID,REMARK！','提示',MB_OK	+MB_ICONINFORMATION);
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

          lDeviceid:= lActiveView.DataController.GetValue(lRecordIndex,lDeviceid_Index);
          lContentcode:= lActiveView.DataController.GetValue(lRecordIndex,lContentcode_Index);
          lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
          lWherestr:= lWherestr+' (deviceid='+inttostr(lDeviceid)+' and contentcode='+inttostr(lContentcode)+' and cityid='+inttostr(lCityid)+') or';
        end;
        lWherestr:= copy(lWherestr,1,length(lWherestr)-3);
        lVariant:= VarArrayCreate([0,0],varVariant);
        lSqlstr:= 'update alarm_data_collect t set t.remark='''+lRemark+''' where '+lWherestr;
        lVariant[0]:= VarArrayOf([lSqlstr]);
        lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
        if not lsuccess then
          MessageBox(handle,'操作失败!','系统提示',MB_ICONWARNING)
        else
        begin
          //更新界面
          for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
            lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
            lActiveView.DataController.SetValue(lRecordIndex,lRemark_Index,lRemark);
          end;
          MessageBox(handle,'操作成功!','系统提示',MB_ICONINFORMATION) ;
        end;
      end;
    finally
      lFormUserSign.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmManpower.cxGridAlarmMasterEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmMaster];
end;

procedure TFormAlarmManpower.cxGridAlarmMasterExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmMaster];
end;

procedure TFormAlarmManpower.cxGridAlarmDetailExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmDetail];
end;

procedure TFormAlarmManpower.cxGridAlarmDetailEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmDetail];
end;

procedure TFormAlarmManpower.cxGridCompanyEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmCompanyMaster];
end;

procedure TFormAlarmManpower.cxGridCompanyExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmCompanyMaster];
end;

procedure TFormAlarmManpower.cxGridFlowEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmFlow];
end;

procedure TFormAlarmManpower.cxGridFlowExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmFlow];
end;

procedure TFormAlarmManpower.ActionUseable(aCurrNodeCode: integer);
begin
  ActionRead.Enabled:= false;
  ActionDel.Enabled:= false;
  ActionSend.Enabled:= false;
  ActionRemark.Enabled:= false;
  ActionRefresh.Enabled:= false;

  case aCurrNodeCode of
    1: begin
         if FMenuReaded.Visible then
           ActionRead.Enabled:= true;
         if FMenuDelete.Visible then
           ActionDel.Enabled:= true;
         if FMenuSend.Visible then
           ActionSend.Enabled:= true;
         if FMenuRemark.Visible then
           ActionRemark.Enabled:= true;
         if FMenuRefresh.Visible then
            ActionRefresh.Enabled:= true;
    end;
    2: begin
         if FMenuDelete.Visible then
           ActionDel.Enabled:= true;
         if FMenuSend.Visible then
           ActionSend.Enabled:= true;
         if FMenuRemark.Visible then
           ActionRemark.Enabled:= true;
         if FMenuRefresh.Visible then
            ActionRefresh.Enabled:= true;
    end;
    3: begin
         if FMenuDelete.Visible then
           ActionDel.Enabled:= true;
         if FMenuSend.Visible then
           ActionSend.Enabled:= true;
         if FMenuRemark.Visible then
           ActionRemark.Enabled:= true;
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

procedure TFormAlarmManpower.OnUserPopup(Sender: TObject);
begin
  FMenuReaded.Enabled:= ActionRead.Enabled;
  FMenuDelete.Enabled:= ActionDel.Enabled;
  FMenuSend.Enabled:= ActionSend.Enabled;
  FMenuRemark.Enabled:= ActionRemark.Enabled;
  FMenuRefresh.Enabled:= ActionRefresh.Enabled;
end;

procedure TFormAlarmManpower.dxDockPanel1AutoHideChanged(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= false;
end;

procedure TFormAlarmManpower.dxDockPanel1AutoHideChanging(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= true;
end;

procedure TFormAlarmManpower.ResizeFilter;
begin
  EditFilter.Left:= dxBarManager1Bar7.DockedLeft+10;
  EditFilter.Top:= dxBarManager1Bar7.DockedTop+62;
  EditFilter.Width:= dxBarEditFilters.Width;
  EditFilter.BringToFront;
end;

procedure TFormAlarmManpower.Timer1Timer(Sender: TObject);
begin
  sleep(1);
  ResizeFilter;
  Timer1.Enabled:= false;
end;

procedure TFormAlarmManpower.dxBarManager1Docking(Sender: TdxBar;
  Style: TdxBarDockingStyle; DockControl: TdxDockControl;
  var CanDocking: Boolean);
begin
  Timer1.Enabled:= true;
end;

procedure TFormAlarmManpower.FormResize(Sender: TObject);
begin
  ResizeFilter;
end;

procedure TFormAlarmManpower.dxBarButton27Click(Sender: TObject);
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
  ShowMasterAlarmOnline;
  gFilterWhere:= '';
end;

procedure TFormAlarmManpower.EditFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    dxBarButton27Click(self);
end;

procedure TFormAlarmManpower.SendMessageToServer(aComid: integer);
begin

end;

procedure TFormAlarmManpower.ActionRefreshExecute(Sender: TObject);
begin
  cxTreeView1Change(self,cxTreeView1.Selected);
end;

procedure TFormAlarmManpower.cxGridCompanyDBTableView1DataControllerDetailExpanding(
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

procedure TFormAlarmManpower.ActionAutofreshExecute(Sender: TObject);
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
  self.Timer1Timer(self);
end;
procedure TFormAlarmManpower.dxDockPanelVisibleChanged(
  Sender: TdxCustomDockControl);
begin
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

  if (gClick_Batchid=0) and (gClick_Companyid=0) and (gClick_Cityid=0) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  if (wd_Active_ParaDetail in gActiveDockPanel) and not (wd_Changed_ParaDetail in gChangedDockPanel) then
  begin
    //showmessage('wd_Active_ParaDetail');
    ShowDetailAlarmOnline(self.gClick_Companyid,self.gClick_Cityid,self.gClick_Devid);
    gChangedDockPanel:= gChangedDockPanel+ [wd_Changed_ParaDetail];
  end;
  if (wd_Active_ParaCompany in gActiveDockPanel) and not (wd_Changed_ParaCompany in gChangedDockPanel) then
  begin
    //showmessage('wd_Active_ParaCompany');
    ShowMasterAlarmOfCompany(self.gClick_Devid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:= gChangedDockPanel+ [wd_Changed_ParaCompany];
  end;
  if (wd_Active_ParaFlow in gActiveDockPanel) and not (wd_Changed_ParaFlow in gChangedDockPanel) then
  begin
    //showmessage('wd_Active_ParaFlow');
    ShowFlowRecOnline(self.gClick_Devid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:= gChangedDockPanel+ [wd_Changed_ParaFlow];
  end;
end;

procedure TFormAlarmManpower.TimerAutofreshTimer(Sender: TObject);
begin
  ActionRefreshExecute(self);
end;
procedure TFormAlarmManpower.cxGridFlowDBTableView1CustomDrawCell(
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

end.
