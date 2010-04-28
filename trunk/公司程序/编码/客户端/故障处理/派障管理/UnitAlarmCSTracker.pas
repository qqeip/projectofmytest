unit UnitAlarmCSTracker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ComCtrls, dxBar, dxBarExtItems,
  cxClasses, dxDockControl, cxContainer, cxTreeView, dxDockPanel, StdCtrls,
  ImgList, cxGridLevel, cxControls, cxGridCustomView, UDevExpressToChinese,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ExtCtrls, jpeg, ActnList, XPStyleActnCtrls, ActnMan, DBClient,
  CxGridUnit, Menus, StringUtils, Buttons, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxColorComboBox, IniFiles;

type
  TDirection = (aLeft, aRight);

  TFormAlarmCSTracker = class(TForm)
    ActionManager1: TActionManager;
    ActionRefresh: TAction;
    ActionAutofresh: TAction;
    PanelTitle: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    cxGridFlow: TcxGrid;
    cxGridFlowDBTableView1: TcxGridDBTableView;
    cxGridFlowLevel1: TcxGridLevel;
    GroupBox2: TGroupBox;
    cxGridCompany: TcxGrid;
    cxGridCompanyDBTableView1: TcxGridDBTableView;
    cxGridCompanyDBTableView2: TcxGridDBTableView;
    cxGridCompanyLevel1: TcxGridLevel;
    cxGridCompanyLevel2: TcxGridLevel;
    ImageTree: TImageList;
    EditFilter: TEdit;
    dxDockSite1: TdxDockSite;
    dxLayoutDockSite1: TdxLayoutDockSite;
    dxLayoutDockSite2: TdxLayoutDockSite;
    dxDockPanel2: TdxDockPanel;
    cxGridAlarmMaster: TcxGrid;
    cxGridAlarmMasterDBTableView1: TcxGridDBTableView;
    cxGridAlarmMasterLevel1: TcxGridLevel;
    dxDockPanel1: TdxDockPanel;
    cxTreeView1: TcxTreeView;
    dxDockingManager1: TdxDockingManager;
    dxBarManager1: TdxBarManager;
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
    dxBarButton30: TdxBarButton;
    Timer1: TTimer;
    TimerAutofresh: TTimer;
    CDS_AlarmMaster: TClientDataSet;
    DS_AlarmMaster: TDataSource;
    CDS_Flow: TClientDataSet;
    DS_Flow: TDataSource;
    CDS_CompanyDetail: TClientDataSet;
    DS_CompanyDetail: TDataSource;
    CDS_Company: TClientDataSet;
    DS_Company: TDataSource;
    Splitter2: TSplitter;
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
    Panel7: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cxColorComboBoxNoReceived: TcxColorComboBox;
    cxColorComboBoxReceived: TcxColorComboBox;
    cxColorComboBoxRevert: TcxColorComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dxBarManager1Docking(Sender: TdxBar;
      Style: TdxBarDockingStyle; DockControl: TdxDockControl;
      var CanDocking: Boolean);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerAutofreshTimer(Sender: TObject);
    procedure ActionRefreshExecute(Sender: TObject);
    procedure PanelTitleDblClick(Sender: TObject);
    procedure cxTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure dxBarButton27Click(Sender: TObject);
    procedure dxBarComboCompanyChange(Sender: TObject);
    procedure EditFilterKeyPress(Sender: TObject; var Key: Char);
    procedure dxDockPanel1AutoHideChanged(Sender: TdxCustomDockControl);
    procedure dxDockPanel1AutoHideChanging(Sender: TdxCustomDockControl);
    procedure ActionAutofreshExecute(Sender: TObject);
    procedure cxGridAlarmMasterDBTableView1CellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridCompanyDBTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure Panel7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel7MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure cxColorComboBoxNoReceivedPropertiesChange(Sender: TObject);
    procedure cxColorComboBoxReceivedPropertiesChange(Sender: TObject);
    procedure cxColorComboBoxRevertPropertiesChange(Sender: TObject);
  private
    gAlarmStatusWhere: string;
    gGlobalWhere: string;
    gFilterWhere: string;
    FControlChanging: boolean;
    gFlowColorList: TStringList;
    gClick_Cityid, gClick_Batchid: integer;
    gDetailExpanded: boolean;//�ж����б��Ƿ�չ��
    gIsMustClickEffect: boolean;//�ж��Ƿ�����Ҫ����ά����λ�����̻����б�

    FCxGridHelperMaster,  FCxGridHelperCompany, FCxGridHelperFlow: TCxGridSet;
    FMenuClear, FMenuDel, FMenuRemark, FMenuFeedTake, FMenuDifficulty, FMenuChangeSend,
    FMenuCommit, FMenuComfirmOK, FMenuRefresh: TMenuItem;
    { Private declarations }
    FIsMoving: Boolean;
    FCurPoint, FCurScreenPoint: TPoint;
    LeftGWidth,MiddlePLeft,RightGWidth:Integer;

    gColorNoReceived, gColorReceived, gColorRevert: TColor;
    
    procedure DoMessage(var Msg: TMsg; var Handled: Boolean);
    function CheckMouseInRect(ControlHandle: THandle): Boolean;

    procedure ResizeFilter;
    procedure IniFormParams;

    procedure cxGridDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure cxGridFlowDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);

    //�˵�
    procedure ActionFaultRemoveExecute(Sender: TObject);
    procedure ActionFaultDeleteExecute(Sender: TObject);
    procedure ActionRemarkExecute(Sender: TObject);
    procedure ActionRevertBackExecute(Sender: TObject);
    procedure ActionFaultStayExecute(Sender: TObject);
    procedure ActionFaultReturnExecute(Sender: TObject);
    procedure ActionFaultSubmitExecute(Sender: TObject);
    procedure ActionFaultClearExecute(Sender: TObject);

    procedure OnUserPopup(Sender: TObject);
    procedure AddFlowField(aView: TcxGridDBTableView);
    procedure AddColorStatusField(aView: TcxGridDBTableView);
    procedure NewSetTreeNodeDisplayName;
    procedure RefreshMLVIEWALARMCS;//��̨ˢ�¸澯��վ
    procedure RefreshChangedData;//���в���������ˢ��ά����λ�б�������б�
    procedure LoadTreeStatus;
    function  DeviceCheck(aDevID, aCoDevID, aCityID: Integer;
                    var aDevCaption, aDevAddr, aGatherName: string):Integer;
    procedure GetGridColor;//�豸У��  00-���ϲ����ڣ��豸δ�滮 10-���ϴ��ڣ��豸δ�滮 01���ϲ����ڣ��豸�ѹ滮 11-У��ɹ�
  public
    { Public declarations }
    procedure ShowMasterAlarmOnline;     //���߸澯��վ
    procedure ShowMasterAlarmOnline_NearTime; //����ʱ
    procedure ShowMasterAlarmOnline_OutTime;  //�ѳ�ʱ
    procedure ShowFlowRecOnline(aBatchid, aCityid: integer);         //������ת�澯
    procedure ShowMasterAlarmOfCompany(aBatchid, aCityid: integer);  //��������ά����λ���ϸ澯
    procedure ShowDetailAlarmOfCompany(aBatchid, aCityid: integer);  //��������ά����λ���ϸ澯
  end;

var
  FormAlarmCSTracker: TFormAlarmCSTracker;

implementation

uses UnitDllCommon, UnitUserSign, UnitFaultStaySet, UnitAlarmChange,
  UnitSubmitInfo;

{$R *.dfm}

procedure TFormAlarmCSTracker.Timer1Timer(Sender: TObject);
begin
  sleep(1);
  ResizeFilter;
  Timer1.Enabled:= false;
end;

procedure TFormAlarmCSTracker.TimerAutofreshTimer(Sender: TObject);
var
  lNodeText: string;
begin
  lNodeText:= TNodeParam(cxTreeView1.Selected.Data).DisplayName;
  LoadTreeStatus;
  //ѡ���ض��ڵ�
  SelectNode(cxTreeView1,lNodeText);
  //�ڵ��߸�����
  NewSetTreeNodeDisplayName;
end;

procedure TFormAlarmCSTracker.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //�ص�����DLLMGRȥ�ͷŴ���
  Application.OnMessage :=nil;
  gDllMsgCall(FormAlarmCSTracker,1,'','');
end;

procedure TFormAlarmCSTracker.FormCreate(Sender: TObject);
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
  Application.OnMessage:= DoMessage;
  LeftGWidth:=GroupBox2.Width;
  MiddlePLeft:=Panel7.Left;
  RightGWidth:=GroupBox1.Width;

  gFlowColorList:= TStringList.Create;
  FCxGridHelperMaster:=TCxGridSet.Create;
  FCxGridHelperCompany:=TCxGridSet.Create;
  FCxGridHelperFlow:=TCxGridSet.Create;

  FCxGridHelperMaster.OnUserDrawCell:= cxGridDBTableView1CustomDrawCell;
  FCxGridHelperMaster.NewSetGridStyle(cxGridAlarmMaster,false,true,true);

  FCxGridHelperCompany.NewSetGridStyle(cxGridCompany,true,true,true);
  
  FCxGridHelperFlow.OnUserDrawCell:= cxGridFlowDBTableView1CustomDrawCell;
  FCxGridHelperFlow.NewSetGridStyle(cxGridFlow,false,true,true);


  //�˵�
  lIsVisable:= true;
  //FCxGridHelperMaster
  FCxGridHelperMaster.AppendShowMenuItem('-',nil,lIsVisable);
  FMenuRefresh:= FCxGridHelperMaster.AppendShowMenuItem('ˢ��',ActionRefreshExecute,lIsVisable);
  //FCxGridHelperCompany
  FCxGridHelperCompany.AppendShowMenuItem('-',nil,lIsVisable);
  FMenuClear:= FCxGridHelperCompany.AppendShowMenuItem('�ų��澯',ActionFaultRemoveExecute,lIsVisable);
  FMenuDel:= FCxGridHelperCompany.AppendShowMenuItem('ɾ���澯',ActionFaultDeleteExecute,lIsVisable);
  FMenuRemark:= FCxGridHelperCompany.AppendShowMenuItem('��д�澯������Ϣ',ActionRemarkExecute,lIsVisable);
  FMenuFeedTake:= FCxGridHelperCompany.AppendShowMenuItem('����ԭ��λ',ActionRevertBackExecute,lIsVisable);
  FMenuDifficulty:= FCxGridHelperCompany.AppendShowMenuItem('תΪ����',ActionFaultStayExecute,lIsVisable);
  FMenuChangeSend:= FCxGridHelperCompany.AppendShowMenuItem('�澯ת��',ActionFaultReturnExecute,lIsVisable);
  FMenuCommit:= FCxGridHelperCompany.AppendShowMenuItem('�ύ',ActionFaultSubmitExecute,lIsVisable);
  FMenuComfirmOK:= FCxGridHelperCompany.AppendShowMenuItem('ȷ������',ActionFaultClearExecute,lIsVisable);
  
  TPopupMenu(cxGridCompany.PopupMenu).OnPopup:= OnUserPopup;

  //���ֶ�
  LoadFields(cxGridAlarmMasterDBTableView1,gPublicParam.cityid,gPublicParam.userid,27);
  AddColorStatusField(cxGridAlarmMasterDBTableView1);
  LoadFields(cxGridCompanyDBTableView1,gPublicParam.cityid,gPublicParam.userid,28);
  LoadFields(cxGridCompanyDBTableView2,gPublicParam.cityid,gPublicParam.userid,29);
  LoadFields(cxGridFlowDBTableView1,gPublicParam.cityid,gPublicParam.userid,34);
  AddHindFlowField(cxGridFlowDBTableView1);

  gGlobalWhere:= ' and cityid='+inttostr(gPublicParam.Cityid);

  //������������
  self.IniFormParams;
end;

procedure TFormAlarmCSTracker.FormDestroy(Sender: TObject);
begin
  //�˵��ͷ�
  FCxGridHelperMaster.Free;
  FCxGridHelperCompany.Free;
  FCxGridHelperFlow.Free;
  ClearTStrings(gFlowColorList);
end;

procedure TFormAlarmCSTracker.FormShow(Sender: TObject);
begin
  //����
  LoadTreeStatus;
  //ѡ���ض��ڵ�
  SelectNode(cxTreeView1,'������');
  //�ڵ��߸�����
  NewSetTreeNodeDisplayName;
  //��ά����λ
  LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,dxBarComboCompany.Items);
end;

procedure TFormAlarmCSTracker.IniFormParams;
begin
  //�����Զ�ˢ��
  TimerAutofresh.Enabled:= ActionAutofresh.Caption='����ˢ��';

  gClick_Cityid:= 0;
  gClick_Batchid:= 0;
  gDetailExpanded:= false;
  gIsMustClickEffect:= false;
end;

procedure TFormAlarmCSTracker.ResizeFilter;
begin
  EditFilter.Left:= dxBarManager1Bar7.DockedLeft+10;
  if self.PanelTitle.Visible then
    EditFilter.Top:= dxBarManager1Bar7.DockedTop+62
  else
    EditFilter.Top:= dxBarManager1Bar7.DockedTop+62-PanelTitle.Height;
  EditFilter.Width:= dxBarEditFilters.Width;
  EditFilter.BringToFront;
end;

procedure TFormAlarmCSTracker.cxGridDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  Index_STATUS_ISWAIT_A, Index_STATUS_ISWAIT_B, Index_STATUS_ISWAIT_C: integer;
  STATUS_ISWAIT_A, STATUS_ISWAIT_B, STATUS_ISWAIT_C: integer;
begin
  try
    Index_STATUS_ISWAIT_A:=TcxGridDBTableView(Sender).GetColumnByFieldName('STATUS_ISWAIT_A').Index;
    Index_STATUS_ISWAIT_B:= TcxGridDBTableView(Sender).GetColumnByFieldName('STATUS_ISWAIT_B').Index;
    Index_STATUS_ISWAIT_C:= TcxGridDBTableView(Sender).GetColumnByFieldName('STATUS_ISWAIT_C').Index;
  except
    exit;
  end;
  if varisnull(AViewInfo.GridRecord.Values[Index_STATUS_ISWAIT_A]) then
    STATUS_ISWAIT_A:= 0
  else
    STATUS_ISWAIT_A:= AViewInfo.GridRecord.Values[Index_STATUS_ISWAIT_A];
  if varisnull(AViewInfo.GridRecord.Values[Index_STATUS_ISWAIT_B]) then
    STATUS_ISWAIT_B:= 0
  else
    STATUS_ISWAIT_B:= AViewInfo.GridRecord.Values[Index_STATUS_ISWAIT_B];
  if varisnull(AViewInfo.GridRecord.Values[Index_STATUS_ISWAIT_C]) then
    STATUS_ISWAIT_C:= 0
  else
    STATUS_ISWAIT_C:= AViewInfo.GridRecord.Values[Index_STATUS_ISWAIT_C];
  if STATUS_ISWAIT_B=1 then
    ACanvas.Brush.Color:= gColorReceived;
  if STATUS_ISWAIT_A=1 then
    ACanvas.Brush.Color:= gColorNoReceived;
  if STATUS_ISWAIT_C=1 then
    ACanvas.Brush.Color:= gColorRevert;
end;

procedure TFormAlarmCSTracker.ActionFaultClearExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  I: integer;
  lRecordIndex: integer;
  lMessageInfo: string;
begin
  lActiveView:= cxGridCompanyDBTableView1;
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

    iError := gTempInterface.ClearFault(lCityid, lCompanyid, lBatchid, gPublicParam.userid);
    case iError of
      0: if i = 0 then
         begin
           RefreshChangedData;
           lMessageInfo:= 'ȷ�����ϳɹ����澯��վ��Ϣ���¸�������������';
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

procedure TFormAlarmCSTracker.ActionFaultDeleteExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  I: integer;
  lRecordIndex: integer;
  lFormUserSign: TFormUserSign;
  lDeleteCause: string;
  lMessageInfo: string;
begin
  lActiveView:= cxGridCompanyDBTableView1;
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
               RefreshChangedData;
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

procedure TFormAlarmCSTracker.ActionFaultRemoveExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lBatchid,lCompanyid,lCityid,
  lContentCode,lDevID, lCoDevID,
  lBatchid_Index,lCompanyid_Index,lCityid_Index,
  lContentCode_index,lDev_Index,
  lCoDev_Index, lRecordIndex, I, iError,
  lDeviceCheck: Integer;
  lDevCaption, lDevAddr, lGatherName: string;
  lMessageInfo: string;
begin
  lActiveView:= cxGridCompanyDBTableView1;
  if not CheckRecordSelected(lActiveView) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
    Application.MessageBox('δ��ùؼ��ֶ�BATCHID,COMPANYID,CITYID,ALARMCONTENTCODE,DEVICEID,CODEVICEID,BTS_NAME,station_addr��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
      lContentCode:= lActiveView.DataController.GetValue(lRecordIndex,lContentCode_index);
      lDevID:= lActiveView.DataController.GetValue(lRecordIndex,lDev_Index);
      
      if varisnull(lActiveView.DataController.GetValue(lRecordIndex,lCoDev_Index)) then
        lCoDevID:= 0
      else
        lCoDevID:= lActiveView.DataController.GetValue(lRecordIndex,lCoDev_Index);

      if lContentCode=800000001 then
      begin
        lDeviceCheck:= DeviceCheck(lDevID, lCoDevID, gPublicParam.cityid,lDevCaption,lDevAddr,lGatherName);
        case lDeviceCheck of
        -1:
        begin
          Application.MessageBox('���ϲ�ȫ�澯У��ʧ��','��ʾ',MB_OK+64);
          Exit;
        end;
        0, 1:
        begin
          Application.MessageBox('δ�ҵ���Ӧ��վ��Ϣ','��ʾ',MB_OK+64);
          Exit;
        end;
        16:
        begin
          Application.MessageBox('���豸δ�滮','��ʾ',MB_OK+64);
          Exit;
        end;
        17:
        begin
          iError:= gTempInterface.DeviceLostResend(gPublicParam.cityid, IntToStr(lDevID));
          if iError<>0 then
            Application.MessageBox('����У���쳣','��ʾ',MB_OK+64)
          else
            Application.MessageBox(pchar('����У��ɹ�'+#13+#13+
                                   'BTSID='+inttostr(lDevID)+ #13+
                                   'CELLID='+inttostr(lCoDevID)+ #13+
                                   '��վ��������' + lDevCaption + #13+
                                   '��վ��ַ��'+ lDevAddr+#13+
                                   '�豸�����ƣ�'+lGatherName)
                                  ,'��ʾ',MB_OK+64);
        end;
        end;
      end;

      iError := gTempInterface.RemoveFault(lCityid, lCompanyid, lBatchid, gPublicParam.userid, '');
      case iError of
        0: if i = 0 then
           begin
             RefreshChangedData;
             lMessageInfo:= '�ų��澯�ɹ�!';
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
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormAlarmCSTracker.ActionFaultReturnExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lBatchid_Index,lCompanyid_Index,lCityid_Index, lCompanyname_Index: integer;
  lFormAlarmChange: TFormAlarmChange;
  lRecordIndex: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lWherestr: string;
  i: integer;
  lVariant: variant;
  lSqlstr: string;
  lrevertconfirminfo: string;
begin
  lActiveView:= cxGridCompanyDBTableView1;
  if not CheckRecordSelected(lActiveView) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  try
    lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
    lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
    lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    lCompanyname_Index:= lActiveView.GetColumnByFieldName('COMPANYNAME').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�BATCHID,COMPANYID,CITYID,COMPANYNAME��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
    {if lFormAlarmChange.ShowModal=mrOk then
    begin
      RefreshChangedData;
    end;}
    if lFormAlarmChange.ShowModal=mrOk then
      begin
        //�Զ��ص�����
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
        RefreshChangedData;
      end;
  finally
    lFormAlarmChange.free;
  end;
end;

procedure TFormAlarmCSTracker.ActionFaultStayExecute(Sender: TObject);
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
  lActiveView:= cxGridCompanyDBTableView1;
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
               RefreshChangedData;
               lMessageInfo:= 'תΪ���ѳɹ�!';
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
    lFormFaultStaySet.Free;
  end;
end;

procedure TFormAlarmCSTracker.ActionFaultSubmitExecute(Sender: TObject);
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
  lActiveView:= cxGridCompanyDBTableView1;
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
               RefreshChangedData;
               lMessageInfo:= '�ύ�ɹ�!';
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
    lFormSubmitInfo.Free;
  end;
end;

procedure TFormAlarmCSTracker.ActionRemarkExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: integer;
  lBatchid,lCompanyid,lCityid: integer;
  lBatchid_Index,lCompanyid_Index,lCityid_Index: integer;
  lRemark_Index: integer;
  lRemark: string;
  lRecordIndex: integer;
  lWherestr: string;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
  lFormUserSign: TFormUserSign;
  lupdatetime_Index: Integer;
begin
  lActiveView:= cxGridCompanyDBTableView1;
  if not CheckRecordSelected(lActiveView) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;

  try
    lBatchid_Index:=lActiveView.GetColumnByFieldName('BATCHID').Index;
    lCompanyid_Index:=lActiveView.GetColumnByFieldName('COMPANYID').Index;
    lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
    lRemark_Index:=lActiveView.GetColumnByFieldName('REMARK').Index;
    lupdatetime_Index:=lActiveView.GetColumnByFieldName('UPDATETIME').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�BATCHID,COMPANYID,CITYID,REMARK,UPDATETIME��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
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
        MessageBox(handle,'����ʧ��!','ϵͳ��ʾ',MB_ICONWARNING)
      else
      begin
        //���½���
        RefreshChangedData;
        MessageBox(handle,'���³ɹ�!','ϵͳ��ʾ',MB_ICONINFORMATION) ;
      end;
    end;
  finally
    lFormUserSign.Free;
  end;
end;

procedure TFormAlarmCSTracker.ActionRevertBackExecute(Sender: TObject);
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
  lActiveView:= cxGridCompanyDBTableView1;
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
                  't.revertconfirminfo='''+lrevertconfirminfo+''',t.ISREVERTBACK=1,t.Isrevert=0,t.Billstatus=0, ISREADEDBACK=0 where '+lWherestr;
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
        MessageBox(handle,'����ԭ��λʧ��!','ϵͳ��ʾ',MB_ICONWARNING)
      else
      begin
        RefreshChangedData;
        MessageBox(handle,'����ԭ��λ�ɹ�!','ϵͳ��ʾ',MB_ICONINFORMATION) ;
      end;
    end;
  finally
    lFormUserSign.Free;
  end;
end;

procedure TFormAlarmCSTracker.dxBarManager1Docking(Sender: TdxBar;
  Style: TdxBarDockingStyle; DockControl: TdxDockControl;
  var CanDocking: Boolean);
begin
  Timer1.Enabled:= true;
end;

procedure TFormAlarmCSTracker.FormResize(Sender: TObject);
begin
  ResizeFilter;
end;

procedure TFormAlarmCSTracker.ActionRefreshExecute(Sender: TObject);
var
  lNodeText: string;
begin
  Screen.Cursor := crHourGlass;
  try
      //��ִ̨��
    RefreshMLVIEWALARMCS;

    lNodeText:= TNodeParam(cxTreeView1.Selected.Data).DisplayName;
    LoadTreeStatus;
    //ѡ���ض��ڵ�
    SelectNode(cxTreeView1,lNodeText);
    //�ڵ��߸�����
    NewSetTreeNodeDisplayName;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormAlarmCSTracker.ShowFlowRecOnline(aBatchid,
  aCityid: integer);
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

  if not GetFlowColorSet(CDS_Flow, gFlowColorList) then
    raise exception.Create('��ȡ������־��ɫ����ʧ��');
end;

procedure TFormAlarmCSTracker.ShowMasterAlarmOfCompany(aBatchid,
  aCityid: integer);
begin
  DS_Company.DataSet:= nil;
  try
    with CDS_Company do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,1,' and batchid='+inttostr(aBatchid)+' and cityid='+inttostr(aCityid)]),0);
    end;
  finally

  end;
  DS_Company.DataSet:= CDS_Company;
  cxGridCompanyDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmCSTracker.ShowMasterAlarmOnline;
var
  Index_Batchid, Index_Cityid: integer;
  I: integer;
begin
  //��վ���ݱ����ά����λ�б���Ҫ����ˢ��
  gIsMustClickEffect:= true;
  DS_AlarmMaster.DataSet:= nil;
  try
    with CDS_AlarmMaster do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([27,1,gAlarmStatusWhere+gGlobalWhere+gFilterWhere]),0);
    end;
  finally

  end;
  DS_AlarmMaster.DataSet:= CDS_AlarmMaster;
  cxGridAlarmMasterDBTableView1.ApplyBestFit();

  //�Զ�ѡ��һ��
  cxGridAlarmMasterDBTableView1.DataController.ClearSelection;
  try
    Index_Batchid:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('batchid').Index;  //�澯���
    Index_Cityid:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('cityid').Index;
  except
    Exit;
  end;
  DS_AlarmMaster.DataSet.Locate('cityid;batchid',VarArrayOf([gClick_Cityid,gClick_Batchid]),[loCaseInsensitive]);
  for i:= cxGridAlarmMasterDBTableView1.DataController.RowCount-1 downto 0 do
  begin
    if (gClick_Batchid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,Index_Batchid))
       and (gClick_Cityid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,Index_Cityid)) then
    begin
      cxGridAlarmMasterDBTableView1.DataController.SelectRows(i,i);
      cxGridAlarmMasterDBTableView1.Focused:=True;
      Break;
    end;
  end;
end;

procedure TFormAlarmCSTracker.OnUserPopup(Sender: TObject);
var
  Index_Flowtache, Index_IsRevert: integer;
  lFlowtacheName, lIsRevertName: string;
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
begin
  FMenuClear.Enabled:= false;
  FMenuDel.Enabled:= false;
  FMenuRemark.Enabled:= false;
  FMenuFeedTake.Enabled:= false;
  FMenuDifficulty.Enabled:= false;
  FMenuChangeSend.Enabled:= false;
  FMenuCommit.Enabled:= false;
  FMenuComfirmOK.Enabled:= false;

  if cxGridCompanyDBTableView1.Focused and (cxGridCompanyDBTableView1.DataController.GetSelectedCount=1) then
  begin
    lActiveView:= cxGridCompanyDBTableView1;
    {if not CheckRecordSelected(lActiveView) then
    begin
      Exit;
    end;}
    try
      Index_Flowtache:= lActiveView.GetColumnByFieldName('flowtachename').Index;
      Index_IsRevert:= lActiveView.GetColumnByFieldName('isrevertname').Index;
    except
      exit;
    end;

    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
    if varisnull(lActiveView.DataController.GetValue(lRecordIndex,Index_Flowtache)) then
      lFlowtacheName:= ''
    else
      lFlowtacheName:= lActiveView.DataController.GetValue(lRecordIndex,Index_Flowtache);
    if varisnull(lActiveView.DataController.GetValue(lRecordIndex,Index_IsRevert)) then
      lIsRevertName:= ''
    else
      lIsRevertName:= lActiveView.DataController.GetValue(lRecordIndex,Index_IsRevert);

    if lFlowtacheName='������' then
    begin
      FMenuClear.Enabled:= true;
      FMenuDel.Enabled:= true;
      FMenuRemark.Enabled:= true;
      FMenuChangeSend.Enabled:= true;
    end;
    if (lFlowtacheName='������') and (lIsRevertName='�ѻص�') then
    begin
      FMenuFeedTake.Enabled:= true;
      FMenuDifficulty.Enabled:= true;
    end;
    if lFlowtacheName='������' then
    begin
      FMenuCommit.Enabled:= true;
    end;
    if lFlowtacheName='���ύ' then
    begin
      FMenuComfirmOK.Enabled:= true;
    end;
  end;
end;

procedure TFormAlarmCSTracker.AddFlowField(aView: TcxGridDBTableView);
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

procedure TFormAlarmCSTracker.PanelTitleDblClick(Sender: TObject);
begin
  PanelTitle.Visible:= false;
  self.Timer1.Enabled:= true;
end;

procedure TFormAlarmCSTracker.cxTreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
  //����DOCKPANEL���ص�ʱ��ᴥ���¼�������Ҫ���ε�
  if FControlChanging then exit;
  Screen.Cursor := crHourGlass;
  try
    case TNodeParam(Node.Data).NodeCode of
      0: begin
        gAlarmStatusWhere:= '';
        ShowMasterAlarmOnline;
      end;
      1,2,3: begin
        gAlarmStatusWhere:= ' '+TNodeParam(Node.Data).SetValue;
        ShowMasterAlarmOnline;
      end;
      4: begin
        ShowMasterAlarmOnline_NearTime;
      end;
      5: begin
        ShowMasterAlarmOnline_OutTime;
      end;
    end;
    if TNodeParam(Node.Data).NodeType=37 then
      Node.Text:= TNodeParam(Node.Data).DisplayName + '(' + IntToStr(CDS_AlarmMaster.recordcount) + ')';
    //ActionUseable(TNodeParam(Node.Data).NodeCode);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormAlarmCSTracker.dxBarButton27Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    if trim(EditFilter.Text) = '' then
    begin
      gFilterWhere:='';
    end
    else
    begin
      gFilterWhere:= ' bts_name LIKE '+''''+'%'+Trim(EditFilter.Text)+'%'+'''';
      gFilterWhere:= gFilterWhere+ ' or deviceid LIKE '+''''+'%'+Trim(EditFilter.Text)+'%'+'''';
      gFilterWhere:= gFilterWhere+ ' or station_addr LIKE '+''''+'%'+Trim(EditFilter.Text)+'%'+'''';
      //gFilterWhere:= gFilterWhere+ ' or cell_no LIKE '+''''+'%'+Trim(EditFilter.Text)+'%'+'''';
      gFilterWhere:= ' and ('+gFilterWhere+')';
    end;
    gAlarmStatusWhere:=' ';
    ShowMasterAlarmOnline;
    gFilterWhere:= '';
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormAlarmCSTracker.ShowMasterAlarmOnline_NearTime;
var
  Index_Batchid, Index_Cityid: integer;
  I: integer;
begin
  //��վ���ݱ����ά����λ�б���Ҫ����ˢ��
  gIsMustClickEffect:= true;
  DS_AlarmMaster.DataSet:= nil;
  try
    with CDS_AlarmMaster do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([27,2,gGlobalWhere+gFilterWhere]),0);
    end;
  finally

  end;
  DS_AlarmMaster.DataSet:= CDS_AlarmMaster;
  cxGridAlarmMasterDBTableView1.ApplyBestFit();

  //�Զ�ѡ��һ��
  cxGridAlarmMasterDBTableView1.DataController.ClearSelection;
  try
    Index_Batchid:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('batchid').Index;  //�澯���
    Index_Cityid:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('cityid').Index;
  except
    Exit;
  end;
  DS_AlarmMaster.DataSet.Locate('cityid;batchid',VarArrayOf([gClick_Cityid,gClick_Batchid]),[loCaseInsensitive]);
  for i:= cxGridAlarmMasterDBTableView1.DataController.RowCount-1 downto 0 do
  begin
    if (gClick_Batchid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,Index_Batchid))
       and (gClick_Cityid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,Index_Cityid)) then
    begin
      cxGridAlarmMasterDBTableView1.DataController.SelectRows(i,i);
      cxGridAlarmMasterDBTableView1.Focused:=True;
      Break;
    end;
  end;
end;

procedure TFormAlarmCSTracker.ShowMasterAlarmOnline_OutTime;
var
  Index_Batchid, Index_Cityid: integer;
  I: integer;
begin
  //��վ���ݱ����ά����λ�б���Ҫ����ˢ��
  gIsMustClickEffect:= true;
  DS_AlarmMaster.DataSet:= nil;
  try
    with CDS_AlarmMaster do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([27,3,gGlobalWhere+gFilterWhere]),0);
    end;
  finally

  end;
  DS_AlarmMaster.DataSet:= CDS_AlarmMaster;
  cxGridAlarmMasterDBTableView1.ApplyBestFit();

    //�Զ�ѡ��һ��
  cxGridAlarmMasterDBTableView1.DataController.ClearSelection;
  try
    Index_Batchid:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('batchid').Index;  //�澯���
    Index_Cityid:=cxGridAlarmMasterDBTableView1.GetColumnByFieldName('cityid').Index;
  except
    Exit;
  end;
  DS_AlarmMaster.DataSet.Locate('cityid;batchid',VarArrayOf([gClick_Cityid,gClick_Batchid]),[loCaseInsensitive]);
  for i:= cxGridAlarmMasterDBTableView1.DataController.RowCount-1 downto 0 do
  begin
    if (gClick_Batchid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,Index_Batchid))
       and (gClick_Cityid=cxGridAlarmMasterDBTableView1.DataController.GetValue(i,Index_Cityid)) then
    begin
      cxGridAlarmMasterDBTableView1.DataController.SelectRows(i,i);
      cxGridAlarmMasterDBTableView1.Focused:=True;
      Break;
    end;
  end;
end;

procedure TFormAlarmCSTracker.dxBarComboCompanyChange(Sender: TObject);
var
  lWdInteger: TWdInteger;
begin
  if trim(dxBarComboCompany.Text) = '' then
  begin
    gFilterWhere:='';
  end
  else
  begin
    lWdInteger:=  TWdInteger(dxBarComboCompany.Items.Objects[dxBarComboCompany.ItemIndex]);
    gFilterWhere:= ' and instr('',''||belongcompany||'','',   '',''||'+lWdInteger.ToString+'||'','')>0';
  end;
  ShowMasterAlarmOnline;
  gFilterWhere:= '';
end;

procedure TFormAlarmCSTracker.EditFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    dxBarButton27Click(self);
end;

procedure TFormAlarmCSTracker.dxDockPanel1AutoHideChanged(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= false;
end;

procedure TFormAlarmCSTracker.dxDockPanel1AutoHideChanging(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= true;
end;

procedure TFormAlarmCSTracker.ActionAutofreshExecute(Sender: TObject);
begin
  if ActionAutofresh.Caption='�Զ�ˢ��' then
  begin
    ActionAutofresh.Caption:= '����ˢ��';
    ActionAutofresh.Hint:= '����ˢ��';
  end
  else
  if ActionAutofresh.Caption='����ˢ��' then
  begin
    ActionAutofresh.Caption:= '�Զ�ˢ��';
    ActionAutofresh.Hint:= '�Զ�ˢ��(Ƶ��100��)';
  end;

  if ActionAutofresh.Caption= '����ˢ��' then
    TimerAutofresh.Enabled:= true
  else
    TimerAutofresh.Enabled:= false;
  //��Ϊ������bschecked������ʧȥ����
  Timer1.Enabled:= true;
end;

procedure TFormAlarmCSTracker.NewSetTreeNodeDisplayName;
var
  i: integer;
begin
  for i:= 0 to cxTreeView1.Items.Count -1 do
  begin
    cxTreeView1.Items[i].Text:= TNodeParam(cxTreeView1.Items[i].Data).DisplayName+
                                '('+TNodeParam(cxTreeView1.Items[i].Data).Remark+')';
  end;
end;

procedure TFormAlarmCSTracker.RefreshMLVIEWALARMCS;
var
  lsqlstr: string;
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    try
      with lClientDataSet do
      begin
        close;
        ProviderName:='dsp_General_data';
        lSqlstr := '{call WD_MLVIEW_ALARMCS(:iError)}';
        Params.CreateParam(ftInteger,'iError',ptOutput);
        try
          gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
        except
        end;
      end;
    except
      raise exception.Create('���Ϲ���ҳ������Ԥ����ʧ��');
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmCSTracker.AddColorStatusField(
  aView: TcxGridDBTableView);
begin
  AddViewFieldVisiable(aView,'STATUS_ISSUB','',false);
  AddViewFieldVisiable(aView,'STATUS_ISWAIT_A','',false);
  AddViewFieldVisiable(aView,'STATUS_ISWAIT_B','',false);
  AddViewFieldVisiable(aView,'STATUS_ISWAIT_C','',false);
  AddViewFieldVisiable(aView,'STATUS_ISOTHER','',false);
end;

procedure TFormAlarmCSTracker.cxGridAlarmMasterDBTableView1CellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  lCityid, lBatchid: integer;
begin
  try
    try
      lCityid:= CDS_AlarmMaster.FieldByName('cityid').AsInteger;
      lBatchid:= CDS_AlarmMaster.FieldByName('batchid').AsInteger;
    except
      Application.MessageBox('δ��ùؼ��ֶ�CITYID,BATCHID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    //���һ��Ҫˢ�� ���� ���м�¼����
    if gIsMustClickEffect or ((gClick_Cityid<>lCityid) or (gClick_Batchid<>lBatchid)) then
    begin
      gClick_Cityid:= lCityid;
      gClick_Batchid:= lBatchid;
      ShowMasterAlarmOfCompany(self.gClick_Batchid,self.gClick_Cityid);
      ShowFlowRecOnline(self.gClick_Batchid,self.gClick_Cityid);
      
      gDetailExpanded:= false;
      gIsMustClickEffect:= false;
    end;
  finally
  
  end;
end;

procedure TFormAlarmCSTracker.cxGridCompanyDBTableView1DataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
begin
  if not gDetailExpanded then
  begin
    ShowDetailAlarmOfCompany(self.gClick_Batchid,self.gClick_Cityid);
    gDetailExpanded:= true;
  end;
end;

procedure TFormAlarmCSTracker.cxGridFlowDBTableView1CustomDrawCell(
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

function TFormAlarmCSTracker.DeviceCheck(aDevID, aCoDevID,
  aCityID: Integer; var aDevCaption, aDevAddr,
  aGatherName: string): Integer;
var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
  lResult: Byte;
begin
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
    Result:= lResult;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmCSTracker.ShowDetailAlarmOfCompany(aBatchid,
  aCityid: integer);
begin
  DS_CompanyDetail.DataSet:= nil;
  try
    with CDS_CompanyDetail do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,2,' and cityid='+inttostr(aCityid)+' and batchid='+inttostr(aBatchid)]),0);
    end;
  finally
  end;
  DS_CompanyDetail.DataSet:= CDS_CompanyDetail;
  //����Ӧ���
end;

procedure TFormAlarmCSTracker.RefreshChangedData;
begin
  ShowMasterAlarmOfCompany(gClick_Batchid,gClick_Cityid);
  ShowFlowRecOnline(self.gClick_Batchid,self.gClick_Cityid);
end;

procedure TFormAlarmCSTracker.LoadTreeStatus;
var
  i: integer;
begin
  cxTreeView1.Items.BeginUpdate;
  try
    for i:= cxTreeView1.Items.Count -1 downto 0 do
    begin
      Dispose(cxTreeView1.Items[i].Data);
    end;
    cxTreeView1.Items.Clear;

    DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,37);
  finally
    cxTreeView1.Items.EndUpdate;
  end;
end;

function TFormAlarmCSTracker.CheckMouseInRect(ControlHandle: THandle): Boolean;
var
  r: TRect;
  p: TPoint;
begin
  GetWindowRect(ControlHandle,r);
  GetCursorPos(p);
  Result := PtInRect(r,p);
end;

procedure TFormAlarmCSTracker.DoMessage(var Msg: TMsg;var Handled: Boolean);
begin
  if (msg.message=WM_LBUTTONDOWN) and CheckMouseInRect(Panel7.Handle) then
  begin
    FIsMoving:= True;
    Panel7.Cursor :=crHSplit;
  end;
  if (msg.message=WM_LBUTTONUP) and CheckMouseInRect(Panel7.Handle) then
  begin
    FIsMoving:= False;
    Panel7.Cursor :=crDefault;
  end;
  if not CheckMouseInRect(Panel1.Handle) then
    FIsMoving:= False;
end;

procedure TFormAlarmCSTracker.Panel7MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FCurPoint.X:= X;
  FCurPoint.Y:= Y;
  FCurScreenPoint:= ClientToScreen(FCurPoint);
end;

procedure TFormAlarmCSTracker.Panel7MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  lPoint, TempPoint: TPoint;
  lMoveDistance: Integer;
  lDirection: TDirection ;
begin
  if FIsMoving then
  begin
    lMoveDistance:= X - FCurPoint.X;
    if lMoveDistance>0 then
      lDirection:= aRight
    else
      lDirection:= aLeft;
      
    lMoveDistance:= Abs(lMoveDistance);
    case lDirection of
      aLeft:
        begin
          if GroupBox2.Width=0 then
            Exit;
          GroupBox2.Width:= GroupBox2.Width - lMoveDistance;
          Panel7.Left:= Panel7.Left - lMoveDistance;
          GroupBox1.Width:= GroupBox1.Width + lMoveDistance;
        end;
      aRight:
        begin
          if GroupBox1.Width=0 then
            Exit;
          GroupBox2.Width:= GroupBox2.Width + lMoveDistance;
          Panel7.Left:= Panel7.Left + lMoveDistance;
          GroupBox1.Width:= GroupBox1.Width - lMoveDistance;
        end;
    end;
  end;
end;

procedure TFormAlarmCSTracker.BitBtn1Click(Sender: TObject); //��
begin
  if Panel7.Left=MiddlePLeft then
  begin
    GroupBox2.Width :=0;
    Panel7.Left :=0;
    GroupBox1.Width :=Panel1.Width -Panel7.Width;
  end
  else
  if Panel7.Left>MiddlePLeft then
  begin
    GroupBox2.Width :=LeftGWidth;
    Panel7.Left :=MiddlePLeft;
    GroupBox1.Width :=Panel1.Width -GroupBox2.Width-panel7.Width;
  end
  else
  if Panel7.Left<MiddlePLeft then
  begin
    GroupBox2.Width :=0;
    Panel7.Left :=0;
    GroupBox1.Width :=Panel1.Width -Panel7.Width;
  end;
end;

procedure TFormAlarmCSTracker.BitBtn2Click(Sender: TObject);
begin
  if Panel7.Left=MiddlePLeft then
  begin
    GroupBox2.Width :=Panel1.Width -Panel7.Width;
    Panel7.Left :=Panel1.Width -Panel7.Width;
    GroupBox1.Width :=0;
  end
  else
  if Panel7.Left>MiddlePLeft then
  begin
    GroupBox2.Width :=Panel1.Width -Panel7.Width;
    Panel7.Left :=Panel1.Width -Panel7.Width;
    GroupBox1.Width :=0;
  end
  else
  if Panel7.Left<MiddlePLeft then
  begin
    GroupBox2.Width :=LeftGWidth;
    Panel7.Left :=MiddlePLeft;
    GroupBox1.Width :=Panel1.Width -GroupBox2.Width-panel7.Width;
  end;
end;

procedure TFormAlarmCSTracker.GetGridColor;
var
  lIniPath: string;
  ini: TIniFile;
begin
  lIniPath:= ExtractFilePath(Application.ExeName)+'ProjectCFMS_Client.ini';
  if FileExists(lIniPath) then
  begin
    ini:= TIniFile.Create(lIniPath);
    try
      gColorNoReceived:= StringToColor(ini.ReadString('AlarmCSColor','NoReceivedColor','$004080FF'));
      gColorReceived:= StringToColor(ini.ReadString('AlarmCSColor','ReceivedColor','$00FF80FF'));
      gColorRevert:= StringToColor(ini.ReadString('AlarmCSColor','RevertColor','clMoneyGreen'));
      cxColorComboBoxNoReceived.ColorValue:= gColorNoReceived;
      cxColorComboBoxReceived.ColorValue:= gColorReceived;
      cxColorComboBoxRevert.ColorValue:= gColorRevert;
    finally
      ini.Free;
    end;
  end;
end;

procedure TFormAlarmCSTracker.cxColorComboBoxNoReceivedPropertiesChange(
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

procedure TFormAlarmCSTracker.cxColorComboBoxReceivedPropertiesChange(
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
procedure TFormAlarmCSTracker.cxColorComboBoxRevertPropertiesChange(
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
