unit UnitAlarmStay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ComCtrls, StdCtrls, ExtCtrls,
  ImgList, dxBar, dxBarExtItems, cxClasses, ActnList, XPStyleActnCtrls,
  ActnMan, dxDockControl, cxContainer, cxTreeView, cxGridLevel, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, UDevExpressToChinese,
  cxGridDBTableView, cxGrid, dxDockPanel, jpeg, Menus, CxGridUnit, DBClient,
  StringUtils;

type
  TActiveGridView = set of (wd_Active_AlarmMaster);
  TActiveDockPanel = set of (wd_Active_ParaDetail,
                             wd_Active_ParaCompany,
                             wd_Active_ParaFlow);
  TChangedDockPanel = set of (wd_Changed_ParaDetail,
                             wd_Changed_ParaCompany,
                             wd_Changed_ParaFlow);
  TFormAlarmStay = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    dxDockingManager1: TdxDockingManager;
    ActionManager1: TActionManager;
    ActionRefresh: TAction;
    dxBarManager1: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarManager1Bar6: TdxBar;
    dxBarManager1Bar7: TdxBar;
    dxBarManager1Bar8: TdxBar;
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
    dxBarEditFilters: TdxBarEdit;
    dxBarButton29: TdxBarButton;
    imBarIcons: TImageList;
    ImageTree: TImageList;
    Timer1: TTimer;
    EditFilter: TEdit;
    ActionFowordLong: TAction;
    ActionResend: TAction;
    ActionDelete: TAction;
    CDS_AlarmMaster: TClientDataSet;
    DS_AlarmMaster: TDataSource;
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
    CDS_Detail: TClientDataSet;
    DS_Detail: TDataSource;
    CDS_Flow: TClientDataSet;
    DS_Flow: TDataSource;
    CDS_Company: TClientDataSet;
    DS_Company: TDataSource;
    DS_CompanyDetail: TDataSource;
    CDS_CompanyDetail: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure dxBarManager1Docking(Sender: TdxBar;
      Style: TdxBarDockingStyle; DockControl: TdxDockControl;
      var CanDocking: Boolean);
    procedure EditFilterKeyPress(Sender: TObject; var Key: Char);
    procedure dxBarComboCompanyChange(Sender: TObject);
    procedure dxDockPanel1AutoHideChanged(Sender: TdxCustomDockControl);
    procedure dxDockPanel1AutoHideChanging(Sender: TdxCustomDockControl);
    procedure ActionFowordLongExecute(Sender: TObject);
    procedure ActionResendExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ActionRefreshExecute(Sender: TObject);
    procedure dxBarButton27Click(Sender: TObject);
    procedure cxTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure cxGridAlarmMasterDBTableView1CellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure FormDestroy(Sender: TObject);
    //procedure ComboBoxCompanyChange(Sender: TObject);
    procedure cxGridAlarmMasterEnter(Sender: TObject);
    procedure cxGridAlarmMasterExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxGridCompanyDBTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure cxGridFlowDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
  private
    //����
    gAlarmStatusWhere: string;
    gGlobalWhere: string;
    gFilterWhere: string;
    gActiveGridView: TActiveGridView;
    FControlChanging: boolean;
    gCurrNodeCode: integer;
    gClick_Cityid, gClick_Companyid, gClick_Batchid: integer;
    gClick_RecordChanged: boolean;
    gActiveDockPanel: TActiveDockPanel;
    gChangedDockPanel: TChangedDockPanel;
    //�Ҽ��˵�
    FMenuForwordLong, FMenuResend, FMenuDelete, FMenuRefresh: TMenuItem;

    FCxGridHelper : TCxGridSet;
    gFlowColorList: TStringList;
    procedure dxDockPanelVisibleChanged(Sender: TdxCustomDockControl);
    procedure AddFlowField(aView: TcxGridDBTableView);
    procedure OnUserPopup(Sender: TObject);
    procedure ActionUseable(aCurrNodeCode: integer);//��������״̬����ACTIONLIST
    procedure ResizeFilter;
  public
    procedure ShowMasterAlarmOnline;     //�������ϸ澯
    procedure ShowDetailAlarmOnline(aBatchid, aCompanyid, aCityid: integer);     //���ߴ��ϸ澯
    procedure ShowFlowRecOnline(aBatchid, aCompanyid, aCityid: integer);         //������ת�澯
    procedure ShowMasterAlarmOfCompany(aBatchid, aCompanyid, aCityid: integer);  //��������ά����λ���ϸ澯
    procedure ShowDetailAlarmOfCompany(aBatchid, aCompanyid, aCityid: integer);  //��������ά����λ���ϸ澯
  end;

var
  FormAlarmStay: TFormAlarmStay;

implementation

uses  UnitVFMSGlobal, UnitDllCommon, UnitUserSign, UnitFaultStayForword;

{$R *.dfm}

procedure TFormAlarmStay.FormCreate(Sender: TObject);
const
  WD_ADMINISTRATOR= 0;
  WD_FIX= 1;
var
  lVisable: boolean;
  lIsVisable: boolean;
  function ifVisable(aTag: integer): boolean;
  begin
    if gPublicParam.ManagerPrive = aTag then
      result:= true
    else
      result:= false;
  end;
begin
  gFlowColorList:= TStringList.Create;
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.NewSetGridStyle(cxGridAlarmMaster,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridAlarmDetail,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridFlow,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridCompany,true,true,true);

  if gPublicParam.userid = 1 then//��������Ա
  begin
    lIsVisable:= true;
    FCxGridHelper.AppendShowMenuItem('-',nil,lIsVisable);
    FMenuForwordLong:= FCxGridHelper.AppendShowMenuItem('����',ActionFowordLongExecute,lIsVisable);
    FMenuResend:= FCxGridHelper.AppendShowMenuItem('����',ActionResendExecute,lIsVisable);
    FMenuDelete:= FCxGridHelper.AppendShowMenuItem('ɾ��',ActionDeleteExecute,lIsVisable);
    FMenuRefresh:= FCxGridHelper.AppendShowMenuItem('ˢ��',ActionRefreshExecute,lIsVisable);
  end else
  begin
    FCxGridHelper.AppendShowMenuItem('-',nil,true);
    FMenuForwordLong:= FCxGridHelper.AppendShowMenuItem('����',ActionFowordLongExecute,ifVisable(WD_ADMINISTRATOR));
    FMenuResend:= FCxGridHelper.AppendShowMenuItem('����',ActionResendExecute,ifVisable(WD_ADMINISTRATOR));
    FMenuDelete:= FCxGridHelper.AppendShowMenuItem('ɾ��',ActionDeleteExecute,ifVisable(WD_ADMINISTRATOR));
    FMenuRefresh:= FCxGridHelper.AppendShowMenuItem('ˢ��',ActionRefreshExecute,true);
  end;
  TPopupMenu(cxGridAlarmMaster.PopupMenu).OnPopup:= OnUserPopup;

  //���ֶ�
  LoadFields(cxGridAlarmMasterDBTableView1,gPublicParam.cityid,gPublicParam.userid,17);
  LoadFields(cxGridAlarmDetailDBTableView1,gPublicParam.cityid,gPublicParam.userid,18);
  LoadFields(cxGridCompanyDBTableView1,gPublicParam.cityid,gPublicParam.userid,19);
  LoadFields(cxGridCompanyDBTableView2,gPublicParam.cityid,gPublicParam.userid,20);
  LoadFields(cxGridFlowDBTableView1,gPublicParam.cityid,gPublicParam.userid,33);
  AddHindFlowField(cxGridFlowDBTableView1);

  gGlobalWhere:= ' and flowtache=3';
  gGlobalWhere:= gGlobalWhere+ ' and cityid='+inttostr(gPublicParam.Cityid)+' and companyid in ('+gPublicParam.RuleCompanyidStr+')';
  dxDockPanel4.OnVisibleChanged:=dxDockPanelVisibleChanged;
  dxDockPanel5.OnVisibleChanged:=dxDockPanelVisibleChanged;
  dxDockPanel6.OnVisibleChanged:=dxDockPanelVisibleChanged;
end;

procedure TFormAlarmStay.FormResize(Sender: TObject);
begin
  ResizeFilter;
end;

procedure TFormAlarmStay.FormShow(Sender: TObject);
begin
  //����
  cxTreeView1.Items.Clear;
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,31);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,3);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,2);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,32);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,33);
  SelectNode(cxTreeView1,'���Ѹ澯');
  //��ά����λ
  LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,dxBarComboCompany.Items);
  //LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,ComboBoxCompany.Items);
end;

procedure TFormAlarmStay.ActionUseable(aCurrNodeCode: integer);
begin
  ActionFowordLong.Enabled:= false;
  ActionResend.Enabled:= false;
  ActionDelete.Enabled:= false;
  ActionRefresh.Enabled:= false;

  case aCurrNodeCode of
    1: begin
         if FMenuForwordLong.Visible then
           ActionFowordLong.Enabled:= true;
         if FMenuResend.Visible then
           ActionResend.Enabled:= true;
         if FMenuDelete.Visible then
           ActionDelete.Enabled:= true;
         if FMenuRefresh.Visible then
           ActionRefresh.Enabled:= true;
       end;
    2: begin
         if FMenuForwordLong.Visible then
           ActionFowordLong.Enabled:= true;
         if FMenuResend.Visible then
           ActionResend.Enabled:= true;
         if FMenuDelete.Visible then
           ActionDelete.Enabled:= true;
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

procedure TFormAlarmStay.OnUserPopup(Sender: TObject);
begin
  FMenuForwordLong.Enabled:= ActionFowordLong.Enabled;
  FMenuResend.Enabled:= ActionResend.Enabled;
  FMenuDelete.Enabled:= ActionDelete.Enabled;
  FMenuRefresh.Enabled:= ActionRefresh.Enabled;
end;

procedure TFormAlarmStay.ResizeFilter;
begin
  EditFilter.Left:= dxBarManager1Bar7.DockedLeft+10;
  EditFilter.Top:= dxBarManager1Bar7.DockedTop+62;
  EditFilter.Width:= dxBarEditFilters.Width;
  EditFilter.BringToFront;
end;

procedure TFormAlarmStay.ShowMasterAlarmOnline;
begin
  if not cxGridAlarmMaster.CanFocus then exit;

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
end;

procedure TFormAlarmStay.Timer1Timer(Sender: TObject);
begin
  sleep(1);
  ResizeFilter;
  Timer1.Enabled:= false;
end;

procedure TFormAlarmStay.dxBarManager1Docking(Sender: TdxBar;
  Style: TdxBarDockingStyle; DockControl: TdxDockControl;
  var CanDocking: Boolean);
begin
  Timer1.Enabled:= true;
end;

procedure TFormAlarmStay.EditFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    dxBarButton27Click(self);
end;

procedure TFormAlarmStay.dxBarComboCompanyChange(Sender: TObject);
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

procedure TFormAlarmStay.dxDockPanel1AutoHideChanged(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= false;
end;

procedure TFormAlarmStay.dxDockPanel1AutoHideChanging(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= true;
end;

procedure TFormAlarmStay.ActionFowordLongExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  I: integer;
  lRecordIndex: integer;
  lWherestr: string;
  lVariant: variant;
  lSuccess :Boolean;
  lSqlstr: string;
  lFormFaultStayForword: TFormFaultStayForword;
  lStatEndDate_Index: integer;
  lStayEndDate: TDateTime;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) and (cxGridAlarmMaster.CanFocus) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
      lStatEndDate_Index:= lActiveView.GetColumnByFieldName('STAYENDDATE').Index;
    except
      Application.MessageBox('δ��ùؼ��ֶ�BATCHID,COMPANYID,CITYID,STAYENDDATE��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lFormFaultStayForword:= TFormFaultStayForword.Create(nil);
    try
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lStayEndDate:= StrtoDatetime(lActiveView.DataController.GetValue(lRecordIndex,lStatEndDate_Index));
      lFormFaultStayForword.DateTimePicker1.Date:= trunc(lStayEndDate);
      lFormFaultStayForword.DateTimePicker2.Time:= lStayEndDate-trunc(lStayEndDate);
      lFormFaultStayForword.DateTimePicker3.Date:= trunc(lStayEndDate);
      lFormFaultStayForword.DateTimePicker4.Time:= lStayEndDate-trunc(lStayEndDate);

      if lFormFaultStayForword.ShowModal=mrOk then
      begin
        lStayEndDate:= trunc(lFormFaultStayForword.DateTimePicker3.Date)+
                       lFormFaultStayForword.DateTimePicker4.DateTime-trunc(lFormFaultStayForword.DateTimePicker4.DateTime);
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
        lSqlstr:= 'update fault_stay_online t set t.stayenddate=to_date('''+Formatdatetime('yyyy-mm-dd hh:mm:ss',lStayEndDate)+''',''yyyy-mm-dd hh24:mi:ss'') where'+lWherestr;
        lVariant[0]:= VarArrayOf([lSqlstr]);
        lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
        if not lsuccess then
          MessageBox(handle,'����ʧ��!','ϵͳ��ʾ',MB_ICONWARNING)
        else
        begin
          ActionRefreshExecute(self);
          MessageBox(handle,'�����ɹ�!','ϵͳ��ʾ',MB_ICONINFORMATION) ;
        end;
      end;
    finally
      lFormFaultStayForword.Free;
    end;
  end;
end;

procedure TFormAlarmStay.ActionResendExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  I: integer;
  lRecordIndex: integer;
  lMessageInfo: string;
begin
  if (wd_Active_AlarmMaster in gActiveGridView) and (cxGridAlarmMaster.CanFocus) then
  begin
    lActiveView:= cxGridAlarmMasterDBTableView1;
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('δ��ùؼ��ֶ�BATCHID,COMPANYID,CITYID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lBatchid:= lActiveView.DataController.GetValue(lRecordIndex,lBatchid_Index);
      lCompanyid:= lActiveView.DataController.GetValue(lRecordIndex,lCompanyid_Index);
      lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);

      iError := gTempInterface.StayResendFault(lCityid, lCompanyid, lBatchid, gPublicParam.userid);
      case iError of
        0: if i = 0 then
           begin
             lActiveView.DataController.DeleteSelection;
             lMessageInfo:= '�������ɳɹ�!';
             Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONINFORMATION);
           end;
        -1: begin
              lMessageInfo:= '�洢�����ڲ�ִ���쳣����!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              break;
            end;
        -2: begin
              lMessageInfo:= '���ô洢����ʧ�ܣ������Ǵ洢����ʧЧ�����±���洢����!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              break;
            end;
        -3: begin
              lMessageInfo:= '�ӿ��쳣����!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              break;
            end;
        else if iError < -3 then
            begin
              lMessageInfo:= '�ӿ�δ�ɹ�ִ�еı���ԭ��!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              break;
            end
        else if iError > 0 then
            begin
              lMessageInfo:= 'Ϊ�洢����ִ�з��ص�δ�ɹ�ִ�еı���ԭ��!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              break;
            end;
      end;
    end;
  end;
end;

procedure TFormAlarmStay.ActionDeleteExecute(Sender: TObject);
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
      Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;
    try
      lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
      lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
      lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    except
      Application.MessageBox('δ��ùؼ��ֶ�BATCHID,COMPANYID,CITYID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
                 lActiveView.DataController.DeleteSelection;
                 lMessageInfo:= 'ɾ���澯�ɹ�!';
                 Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONINFORMATION);
               end;
            -1: begin
                  lMessageInfo:= '�洢�����ڲ�ִ���쳣����!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  break;
                end;
            -2: begin
                  lMessageInfo:= '���ô洢����ʧ�ܣ������Ǵ洢����ʧЧ�����±���洢����!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  break;
                end;
            -3: begin
                  lMessageInfo:= '�ӿ��쳣����!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  break;
                end;
            else if iError < -3 then
                begin
                  lMessageInfo:= '�ӿ�δ�ɹ�ִ�еı���ԭ��!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  break;
                end
            else if iError > 0 then
                begin
                  lMessageInfo:= 'Ϊ�洢����ִ�з��ص�δ�ɹ�ִ�еı���ԭ��!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  break;
                end;
          end;
        end;
      end;
    finally
      lFormUserSign.free;
    end;
  end;
end;

procedure TFormAlarmStay.ActionRefreshExecute(Sender: TObject);
begin
  cxTreeView1Change(self,cxTreeView1.Selected);
end;

procedure TFormAlarmStay.dxBarButton27Click(Sender: TObject);
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

procedure TFormAlarmStay.cxTreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
  //����DOCKPANEL���ص�ʱ��ᴥ���¼�������Ҫ���ε�
  if FControlChanging then exit;
  if (Node=nil) or (Node.Data=nil) then exit;
  gCurrNodeCode:= TNodeParam(Node.Data).NodeCode;

  //����������
  case TNodeParam(Node.Data).NodeType of
    31,2,3:  begin
           //if cxTreeView1.Selected<>nil then
             //gDllMsgCall(nil,3,'FormAlarmTracker',cxTreeView1.Selected.Text);
             gDllMsgCall(nil,3,'FormAlarmTracker',TNodeParam(Node.Data).DisplayName);
           exit;
         end;
    32:  begin//�澯������
           gAlarmStatusWhere:= ' '+TNodeParam(Node.Data).SetValue;
         end;
    33:  begin
           //if cxTreeView1.Selected<>nil then
             //gDllMsgCall(nil,2,'FormAlarmSearch',cxTreeView1.Selected.Text);
             gDllMsgCall(nil,2,'FormAlarmSearch',TNodeParam(Node.Data).DisplayName);
           exit;
         end;
  end;
  ShowMasterAlarmOnline;
  ActionUseable(TNodeParam(Node.Data).NodeCode);
end;

procedure TFormAlarmStay.cxGridAlarmMasterDBTableView1CellClick(
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
    Application.MessageBox('δ��ùؼ��ֶ�CITYID,COMPANYID,BATCHID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  gClick_RecordChanged:=(gClick_Cityid<>lCityid) or (gClick_Companyid<>lCompanyid) or
                        (gClick_Batchid<>lBatchid);
  if gClick_RecordChanged then
  begin
    gClick_Cityid:=lCityid;
    gClick_Companyid:=lCompanyid;
    gClick_Batchid:=lBatchid;

    gChangedDockPanel:=[];
    dxDockPanelVisibleChanged(dxDockPanel4);
    dxDockPanelVisibleChanged(dxDockPanel5);
    dxDockPanelVisibleChanged(dxDockPanel6);
  end;  

  {ShowDetailAlarmOnline(lBatchid,lCompanyid,lCityid);
  ShowMasterAlarmOfCompany(lBatchid,lCompanyid,lCityid);
  ShowFlowRecOnline(lBatchid,lCompanyid,lCityid);}
end;

procedure TFormAlarmStay.ShowDetailAlarmOfCompany(aBatchid, aCompanyid,
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

procedure TFormAlarmStay.ShowDetailAlarmOnline(aBatchid, aCompanyid,
  aCityid: integer);
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

procedure TFormAlarmStay.ShowFlowRecOnline(aBatchid, aCompanyid,
  aCityid: integer);
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
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,3,' and cityid='+inttostr(aCityid)+' and batchid='+inttostr(aBatchid)]),0);
    end;
  finally

  end;
  DS_Flow.DataSet:= CDS_Flow;
  //cxGridFlowDBTableView1.ApplyBestFit();
  if not GetFlowColorSet(CDS_Flow, gFlowColorList) then
    raise exception.Create('��ȡ������־��ɫ����ʧ��');
end;

procedure TFormAlarmStay.ShowMasterAlarmOfCompany(aBatchid, aCompanyid,
  aCityid: integer);
begin
  //if not cxGridCompany.CanFocus then exit;

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

procedure TFormAlarmStay.AddFlowField(aView: TcxGridDBTableView);
begin
  AddViewField(aView,'operatename','���̻���',120);
  AddViewField(aView,'stationname','��λ����',65);
  AddViewField(aView,'operatorname','������');
  AddViewField(aView,'mobilephone','��ϵ�绰',120);
  AddViewFieldMemo(aView,'flowinformation','����˵��',5,300);
  AddViewField(aView,'operatetime','����ʱ��',120);
  AddViewField(aView,'companyname','ά����λ',65);
  AddViewField(aView,'trackid','������ˮ��',65);
  AddViewField(aView,'cityid','���б��',65);
  AddViewField(aView,'batchid','���ϱ��',65);
  AddViewField(aView,'alarmid','���ϱ��',65);
end;

procedure TFormAlarmStay.FormDestroy(Sender: TObject);
begin
  //�˵��ͷ�
  FCxGridHelper.Free;
  ClearTStrings(gFlowColorList);
end;

{procedure TFormAlarmStay.ComboBoxCompanyChange(Sender: TObject);
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

procedure TFormAlarmStay.cxGridAlarmMasterEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmMaster];
end;

procedure TFormAlarmStay.cxGridAlarmMasterExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmMaster];
end;

procedure TFormAlarmStay.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //�ص�����DLLMGRȥ�ͷŴ���
  gDllMsgCall(FormAlarmStay,1,'','');
end;

procedure TFormAlarmStay.cxGridCompanyDBTableView1DataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  lCityid,lCompanyid,lBatchid: integer;
  lCityid_Index,lCompanyid_Index,lBatchid_Index: integer;
begin
  //�������дӱ�
  ADataController.CollapseDetails;
  try
    lCityid_Index:= cxGridCompanyDBTableView1.GetColumnByFieldName('CITYID').Index;
    lCompanyid_Index:= cxGridCompanyDBTableView1.GetColumnByFieldName('COMPANYID').Index;
    lBatchid_Index:= cxGridCompanyDBTableView1.GetColumnByFieldName('BATCHID').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�CITYID,COMPANYID,BATCHID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lCityid:= integer(ADataController.GetValue(ARecordIndex,lCityid_Index));
  lCompanyid:= integer(ADataController.GetValue(ARecordIndex,lCompanyid_Index));
  lBatchid:= integer(ADataController.GetValue(ARecordIndex,lBatchid_Index));
  ShowDetailAlarmOfCompany(lBatchid,lCompanyid,lCityid);
end;

procedure TFormAlarmStay.dxDockPanelVisibleChanged(Sender: TdxCustomDockControl);
begin
  if TdxDockPanel(Sender)=dxDockPanel4 then
    if TdxDockPanel(Sender).Visible then
    gActiveDockPanel:=gActiveDockPanel+[wd_Active_ParaDetail]
    else
    gActiveDockPanel:=gActiveDockPanel-[wd_Active_ParaDetail]
  else
  if TdxDockPanel(Sender)=dxDockPanel5 then
    if TdxDockPanel(Sender).Visible then
    gActiveDockPanel:=gActiveDockPanel+[wd_Active_ParaCompany]
    else
    gActiveDockPanel:=gActiveDockPanel-[wd_Active_ParaCompany]
  else
  if TdxDockPanel(Sender) = dxDockPanel6 then
    if TdxDockPanel(Sender).Visible then
      gActiveDockPanel:= gActiveDockPanel+ [wd_Active_ParaFlow]
    else
      gActiveDockPanel:= gActiveDockPanel- [wd_Active_ParaFlow];
  if (gClick_Cityid=0) and (gClick_Companyid=0) and (gClick_Batchid=0) then
  begin
     Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
     Exit;
  end;
  if(wd_Active_ParaDetail in gActiveDockPanel) and not (wd_Changed_ParaDetail in gChangedDockPanel) then
  begin
    ShowDetailAlarmOnline(gClick_Batchid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:=gChangedDockPanel+[wd_Changed_ParaDetail];
  end;
  if (wd_Active_ParaCompany in gActiveDockPanel) and not (wd_Changed_ParaCompany in gChangedDockPanel) then
  begin
    ShowMasterAlarmOfCompany(gClick_Batchid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:=gChangedDockPanel+[wd_Changed_ParaCompany];
  end;
  if (wd_Active_ParaFlow in gActiveDockPanel) and not (wd_Changed_ParaFlow in gChangedDockPanel) then
  begin
     ShowFlowRecOnline(gClick_Batchid,gClick_Companyid,gClick_Cityid);
     gChangedDockPanel:=gChangedDockPanel+[wd_Changed_ParaFlow] ;
  end;
end;

procedure TFormAlarmStay.cxGridFlowDBTableView1CustomDrawCell(
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
