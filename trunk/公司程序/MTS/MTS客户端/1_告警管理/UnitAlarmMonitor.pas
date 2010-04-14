unit UnitAlarmMonitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, ExtCtrls, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, MapTools, MapXLib_TLB, StdCtrls,
  IniFiles, LayerSvrUnit, cxSplitter, DBClient, cxContainer, cxTextEdit,
  cxMaskEdit, cxSpinEdit, CxGridUnit, Menus;

const
  fDefineHeight=250;
type
  TOperateType= (LookParticular, AddDRS, ModifyDRS);
  TFormAlarmMonitor = class(TForm)
    PanelMap: TPanel;
    ToolBar1: TToolBar;
    ToolButtonZoomIn: TToolButton;
    ToolButtonZoomOut: TToolButton;
    ToolButtonPan: TToolButton;
    ToolButtonLabel: TToolButton;
    ToolButton11: TToolButton;
    ToolButtonLayer: TToolButton;
    ToolButtonBounds: TToolButton;
    ToolButtonClear: TToolButton;
    MapBarImageList: TImageList;
    LabelPos: TLabel;
    ToolButtonRefresh: TToolButton;
    cxSplitter1: TcxSplitter;
    PanelAlarm: TPanel;
    cxGridAlarm: TcxGrid;
    cxGridAlarmDBTableViewOnline: TcxGridDBTableView;
    cxGridAlarmDBTableViewOff: TcxGridDBTableView;
    cxGridAlarmDBTableViewOnline_D: TcxGridDBTableView;
    cxGridAlarmDBTableViewOff_D: TcxGridDBTableView;
    cxGridAlarmLevel1: TcxGridLevel;
    cxGridAlarmLevel3: TcxGridLevel;
    cxGridAlarmLevel2: TcxGridLevel;
    cxGridAlarmLevel4: TcxGridLevel;
    ToolButtonFullMap: TToolButton;
    ToolButton2: TToolButton;
    ToolButtonArrow: TToolButton;
    ToolButton1: TToolButton;
    ToolButtonLocatBUILDING: TToolButton;
    ToolButtonShowBuildingParticular: TToolButton;
    ToolButtonTheme: TToolButton;
    ToolButtonThemeSetup: TToolButton;
    ToolButtonDelTheme: TToolButton;
    ToolButton8: TToolButton;
    DataSourceOnLine: TDataSource;
    DataSourceOff: TDataSource;
    DataSourceOnLine_D: TDataSource;
    DataSourceOff_D: TDataSource;
    ClientDataSetOnLine: TClientDataSet;
    ClientDataSetOff: TClientDataSet;
    ClientDataSetOnLine_D: TClientDataSet;
    ClientDataSetOff_D: TClientDataSet;
    PanelAlarmShow: TPanel;
    cxGridAlarmShow: TcxGrid;
    cxGridAlarmShowDBTableView1: TcxGridDBTableView;
    cxGridAlarmShowLevel1: TcxGridLevel;
    DataSourceShowAlarm: TDataSource;
    ClientDataSetShowAlarm: TClientDataSet;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    btClose: TButton;
    cbShowHistory: TCheckBox;
    seCount: TcxSpinEdit;
    cxGridAlarmLevel5: TcxGridLevel;
    cxGridAlarmDBTableViewRepeater: TcxGridDBTableView;
    DataSourceRepeater: TDataSource;
    ClientDataSetRepeater: TClientDataSet;
    LabelMeasure: TLabel;
    ToolButton3: TToolButton;
    ToolButtonAlarmBuilding: TToolButton;
    ToolButtonAlarmMtu: TToolButton;
    cxGridAlarmLevel6: TcxGridLevel;
    cxGridAlarmDBTableViewRepeater_D: TcxGridDBTableView;
    DataSourceRepeater_D: TDataSource;
    ClientDataSetRepeater_D: TClientDataSet;
    BtnAddDRS: TToolButton;
    BtnModifyDRS: TToolButton;
    cxGridAlarmLevel7: TcxGridLevel;
    cxGridAlarmDBTableViewDRS: TcxGridDBTableView;
    cxGridAlarmLevel8: TcxGridLevel;
    cxGridAlarmDBTableViewDRS_D: TcxGridDBTableView;
    DataSourceDRS: TDataSource;
    ClientDataSetDRS: TClientDataSet;
    DataSourceDRS_D: TDataSource;
    ClientDataSetDRS_D: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);

    procedure ToolButtonRefreshClick(Sender: TObject);
    procedure cxSplitter1Moved(Sender: TObject);
    procedure ToolButtonFullMapClick(Sender: TObject);
    procedure ToolButtonLayerClick(Sender: TObject);
    procedure ToolButtonArrowClick(Sender: TObject);
    procedure ToolButtonZoomInClick(Sender: TObject);
    procedure ToolButtonZoomOutClick(Sender: TObject);
    procedure ToolButtonPanClick(Sender: TObject);
    procedure ToolButtonLabelClick(Sender: TObject);
    procedure ToolButtonBoundsClick(Sender: TObject);
    procedure ToolButtonClearClick(Sender: TObject);
    procedure ToolButtonLocatBUILDINGClick(Sender: TObject);
    procedure ToolButtonShowBuildingParticularClick(Sender: TObject);
    procedure ToolButtonThemeClick(Sender: TObject);
    procedure ToolButtonThemeSetupClick(Sender: TObject);
    procedure ToolButtonDelThemeClick(Sender: TObject);
    procedure cxGridAlarmDBTableViewOnlineDataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure cxGridAlarmDBTableViewOffDataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure cbShowHistoryClick(Sender: TObject);
    procedure cxGridAlarmDBTableViewOnlineFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure btCloseClick(Sender: TObject);
    procedure cxGridAlarmDBTableViewOnlineCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure WdMapWrapper1GetPositonEvent(Sender: TObject; MapX, MapY: Double);
    procedure FormResize(Sender: TObject);
    procedure WdMapWrapper1MapMousePoint(Sender: TObject; MapX, MapY: Double);
    procedure WdMapWrapper1MeasureingAreaEvent(Sender: TObject;
      RegionArea: Double);
    procedure WdMapWrapper1MeasureingDistanceEvent(Sender: TObject;
      CurrentDistance, TotalDistance: Double);
    procedure ToolButtonAlarmBuildingClick(Sender: TObject);
    procedure ToolButtonAlarmMtuClick(Sender: TObject);
    procedure cxGridAlarmDBTableViewRepeaterDataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure cxGridAlarmDBTableViewOnlineDataControllerFilterChanged(
      Sender: TObject);
    procedure cxGridAlarmDBTableViewOffDataControllerFilterChanged(
      Sender: TObject);
    procedure cxGridAlarmDBTableViewRepeaterDataControllerFilterChanged(
      Sender: TObject);
    procedure cxGridAlarmActiveTabChanged(Sender: TcxCustomGrid;
      ALevel: TcxGridLevel);
    procedure BtnAddDRSClick(Sender: TObject);
    procedure BtnModifyDRSClick(Sender: TObject);
    procedure cxGridAlarmDBTableViewDRSDataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure cxGridAlarmDBTableViewDRSDataControllerFilterChanged(
      Sender: TObject);
  private
    { Private declarations }
    FCxGridHelper : TCxGridSet;
    FMenuClearAlarm, FMenuReaded, FMenuRefresh,
    FMenuWireless, FMenuTestParticular, FMenuLocateTree,
    FMenuLocateGis, FMenuRemark : TMenuItem;
  {�澯��Ŀ}
    FAlarmOnlineCounts, FAlarmHistoryCounts, FAlarmRepeaterCounts, FAlarmDRSCount: integer;
  {GIS}
    FMapIssetup: boolean;
    FMap: TMap;
    FMapX,FMapY: double;
    WdMapWrapper1: TWdMapWrapper;
    FOperateType: TOperateType;
    procedure LoadCustomLayer;
    //���ص�ͼ�����һ���Ӵ�
    procedure LoadMapView;
    //�����ͼ�ĵ�ǰ�Ӵ�
    procedure SaveMapView;


  {ALARM}
    //���ֶ�
    procedure AddViewField(aView : TcxGridDBTableView;aFieldName, aCaption : String; aWidth: integer=65);overload;
    procedure AddViewField_AlarmOnline;
    procedure AddViewField_AlarmHistory;
    procedure AddViewField_AlarmRepeater;
    procedure AddViewField_AlarmOnline_Detail;
    procedure AddViewField_AlarmHistory_Detail;
    procedure AddViewField_AlarmRepeater_Detail;
    procedure AddViewField_AlarmShow;
    procedure AddViewField_AlarmDRS;
    procedure AddViewField_AlarmDR_D;
    procedure Map1DbClick(Sender: TObject);
    //
    procedure ShowAlarmByCounts;
    procedure ClearAlarmOnClickEvent(Sender: TObject);
    procedure ReadedOnClickEvent(Sender: TObject);
    procedure RefreshAlarmOnClickEvent(Sender: TObject);
    procedure WirelessOnClickEvent(Sender: TObject);
    procedure TestParticularOnClickEvent(Sender: TObject);
    procedure LocateTreeOnClickEvent(Sender: TObject);
    procedure LocateGisOnClickEvent(Sender: TObject);
    procedure RemarkOnClickEvent(Sender: TObject);
    procedure OnMyPopup(Sender: TObject);
    procedure GetPathList(aMtuid: integer; aPathList: TStringList);
    function GetActiveAlarms(aView: TcxGridDBTableView): integer;
    procedure DrawActiveAlarms;


  public
    { Public declarations }
    gCondition :String;
    gAlarmKindCondition :String;
    procedure ShowAlarm_Online;   //����
    procedure ShowAlarm_History;  //���
    procedure ShowAlarm_Repeater; //ֱ��վ
    procedure ShowAlarm_DRS;

    procedure ShowAlarm_Online_D(aAlarmid: integer); //�����굥
    procedure ShowAlarm_History_D(aAlarmid: integer);//����굥
    procedure ShowAlarm_Repeater_D(aAlarmid: integer);
    procedure ShowAlarm_DRS_D(aAlarmid: integer);

    procedure Location(aLayerName: string; aID: string);
  end;

var
  FormAlarmMonitor: TFormAlarmMonitor;

implementation

uses UnitGlobal, FrmSelectLayer, Ut_MainForm, Ut_DataModule, Ut_Common,
  UnitSearchBuilding, UnitBuildingParticular, UnitWirelessParticular,
  UnitTestParticular, UnitAddAlarmInfo, UnitDRSParticular, UntDRSConfig,
  UnitDRSInfoMgr;

{$R *.dfm}

procedure TFormAlarmMonitor.AddViewField(aView: TcxGridDBTableView; aFieldName,
  aCaption: String; aWidth: integer);
begin
  aView.BeginUpdate;
  with aView.CreateColumn as TcxGridColumn do
  begin
    Caption := aCaption;
    DataBinding.FieldName:= aFieldName;
    DataBinding.ValueTypeClass := TcxStringValueType;
    HeaderAlignmentHorz := taCenter;
    Width:=aWidth;
  end;
  aView.EndUpdate;
end;

procedure TFormAlarmMonitor.AddViewField_AlarmDRS;
begin
  AddViewField(cxGridAlarmDBTableViewDRS,'alarmid','�澯���');
  AddViewField(cxGridAlarmDBTableViewDRS,'drsid','ֱ��վ�ڲ����');
  AddViewField(cxGridAlarmDBTableViewDRS,'alarmcontentname','�澯����');
  AddViewField(cxGridAlarmDBTableViewDRS,'alarmkindname','�澯����');
  AddViewField(cxGridAlarmDBTableViewDRS,'alarmlevelname','�澯�ȼ�');
  AddViewField(cxGridAlarmDBTableViewDRS,'drsno','ֱ��վ���');
  AddViewField(cxGridAlarmDBTableViewDRS,'r_deviceid','�����豸���');
  AddViewField(cxGridAlarmDBTableViewDRS,'drsname','ֱ��վ����');
  AddViewField(cxGridAlarmDBTableViewDRS,'drstypename','ֱ��վ����');
  AddViewField(cxGridAlarmDBTableViewDRS,'drsmanuname','ֱ��վ����');
  AddViewField(cxGridAlarmDBTableViewDRS,'isprogramname','����/����');
  AddViewField(cxGridAlarmDBTableViewDRS,'cityname','����');
  AddViewField(cxGridAlarmDBTableViewDRS,'areaname','����');
  AddViewField(cxGridAlarmDBTableViewDRS,'suburbname','�־�');
  AddViewField(cxGridAlarmDBTableViewDRS,'buildingname','�ҷֵ�����');
  AddViewField(cxGridAlarmDBTableViewDRS,'cs','������վ���');
  AddViewField(cxGridAlarmDBTableViewDRS,'msc','����MSC���');
  AddViewField(cxGridAlarmDBTableViewDRS,'bsc','����BSC���');
  AddViewField(cxGridAlarmDBTableViewDRS,'cell','�����������');
  AddViewField(cxGridAlarmDBTableViewDRS,'pn','PN��');
  AddViewField(cxGridAlarmDBTableViewDRS,'agentcompanyname','��ά��˾');
  AddViewField(cxGridAlarmDBTableViewDRS,'Longitude','����');
  AddViewField(cxGridAlarmDBTableViewDRS,'Latitude','γ��');
  AddViewField(cxGridAlarmDBTableViewDRS,'DRSADRESS','��ַ');
end;

procedure TFormAlarmMonitor.AddViewField_AlarmDR_D;
begin
  AddViewField(cxGridAlarmDBTableViewDRS_D,'alarmid','�澯���');
  AddViewField(cxGridAlarmDBTableViewDRS_D,'taskid','������');
  AddViewField(cxGridAlarmDBTableViewDRS_D,'drsid','DRSID');
  AddViewField(cxGridAlarmDBTableViewDRS_D,'drsno','�豸���');
  AddViewField(cxGridAlarmDBTableViewDRS_D,'r_deviceid','�����豸���');
  AddViewField(cxGridAlarmDBTableViewDRS_D,'comname','��������',120);
  AddViewField(cxGridAlarmDBTableViewDRS_D,'paramname','���Բ���',80);
  AddViewField(cxGridAlarmDBTableViewDRS_D,'testresult','���Խ��ֵ');
  AddViewField(cxGridAlarmDBTableViewDRS_D,'collecttime','�ɼ�ʱ��',110);
  AddViewField(cxGridAlarmDBTableViewDRS_D,'isprocess','�Ƿ��Ѵ���');
  AddViewField(cxGridAlarmDBTableViewDRS_D,'cityname','��������',75);
end;

procedure TFormAlarmMonitor.AddViewField_AlarmHistory;
begin
  AddViewField(cxGridAlarmDBTableViewOff,'alarmid','�澯���');
  AddViewField(cxGridAlarmDBTableViewOff,'alarmcontentname','�澯����');
  AddViewField(cxGridAlarmDBTableViewOff,'alarmkindname','�澯����');
  AddViewField(cxGridAlarmDBTableViewOff,'alarmlevelname','�澯�ȼ�');
  AddViewField(cxGridAlarmDBTableViewOff,'sendtime','����ʱ��');
  AddViewField(cxGridAlarmDBTableViewOff,'limithour','����ʱ��');
  AddViewField(cxGridAlarmDBTableViewOff,'removetime','����ʱ��');
  AddViewField(cxGridAlarmDBTableViewOff,'mtuname','MTU����');
  AddViewField(cxGridAlarmDBTableViewOff,'MTUNO','MTU���');
  AddViewField(cxGridAlarmDBTableViewOff,'mtuaddr','MTUλ��');
  AddViewField(cxGridAlarmDBTableViewOff,'call','�绰����');
  AddViewField(cxGridAlarmDBTableViewOff,'alarmcount','�澯�ۼƴ���');
  AddViewField(cxGridAlarmDBTableViewOff,'overlay','���Ƿ�Χ');
  AddViewField(cxGridAlarmDBTableViewOff,'buildingname','�ҷֵ�����');
  AddViewField(cxGridAlarmDBTableViewOff,'agentcompanyname','��ά��˾');
  AddViewField(cxGridAlarmDBTableViewOff,'factoryname','���ɳ���');
  AddViewField(cxGridAlarmDBTableViewOff,'address','�ҷֵ��ַ');
  AddViewField(cxGridAlarmDBTableViewOff,'areaname','����');
  AddViewField(cxGridAlarmDBTableViewOff,'cityname','����');
  AddViewField(cxGridAlarmDBTableViewOff,'readedname','�Ƿ�����');
  AddViewField(cxGridAlarmDBTableViewOff,'flowtachename','�澯״̬');
  AddViewField(cxGridAlarmDBTableViewOff,'assistantContentcode','���ܸ澯����');

  AddViewField(cxGridAlarmDBTableViewOff,'isprogramname','����/����');
  AddViewField(cxGridAlarmDBTableViewOff,'mainlook_apname','�����AP');
  AddViewField(cxGridAlarmDBTableViewOff,'mainlook_phsname','�����PHS');
  AddViewField(cxGridAlarmDBTableViewOff,'mainlook_cnetname','�����C��');
  AddViewField(cxGridAlarmDBTableViewOff,'cdmatypename','C����Դ����');
  AddViewField(cxGridAlarmDBTableViewOff,'cdmaaddress','C����Դ��װλ��');
  AddViewField(cxGridAlarmDBTableViewOff,'pncode','PN��');
  AddViewField(cxGridAlarmDBTableViewOff,'reserve_pncode','�ڶ�������');
  AddViewField(cxGridAlarmDBTableViewOff,'remark','��ע');
  AddViewField(cxGridAlarmDBTableViewOff,'MTUID','MTU�ڲ����');
end;

procedure TFormAlarmMonitor.AddViewField_AlarmHistory_Detail;
begin
  AddViewField(cxGridAlarmDBTableViewOff_D,'alarmid','�澯���');
  AddViewField(cxGridAlarmDBTableViewOff_D,'taskid','������');
  AddViewField(cxGridAlarmDBTableViewOff_D,'MTUID','MTUID');
  AddViewField(cxGridAlarmDBTableViewOff_D,'mtuno','�豸���');
  AddViewField(cxGridAlarmDBTableViewOff_D,'comname','��������',120);
  AddViewField(cxGridAlarmDBTableViewOff_D,'paramname','���Բ���',80);
  AddViewField(cxGridAlarmDBTableViewOff_D,'testresult','���Խ��ֵ');
  AddViewField(cxGridAlarmDBTableViewOff_D,'collecttime','�ɼ�ʱ��',110);
  AddViewField(cxGridAlarmDBTableViewOff_D,'isprocess','�Ƿ��Ѵ���');
  AddViewField(cxGridAlarmDBTableViewOff_D,'cityname','��������',75);
end;

procedure TFormAlarmMonitor.AddViewField_AlarmOnline;
begin
  AddViewField(cxGridAlarmDBTableViewOnline,'alarmid','�澯���');
  AddViewField(cxGridAlarmDBTableViewOnline,'alarmcontentname','�澯����');
  AddViewField(cxGridAlarmDBTableViewOnline,'alarmkindname','�澯����');
  AddViewField(cxGridAlarmDBTableViewOnline,'alarmlevelname','�澯�ȼ�');
  AddViewField(cxGridAlarmDBTableViewOnline,'sendtime','����ʱ��');
  AddViewField(cxGridAlarmDBTableViewOnline,'limithour','����ʱ��');
  AddViewField(cxGridAlarmDBTableViewOnline,'mtuname','MTU����');
  AddViewField(cxGridAlarmDBTableViewOnline,'MTUNO','MTU���');
  AddViewField(cxGridAlarmDBTableViewOnline,'mtuaddr','MTUλ��');
  AddViewField(cxGridAlarmDBTableViewOnline,'call','�绰����');
  AddViewField(cxGridAlarmDBTableViewOnline,'alarmcount','�澯�ۼƴ���');
  AddViewField(cxGridAlarmDBTableViewOnline,'overlay','���Ƿ�Χ');
  AddViewField(cxGridAlarmDBTableViewOnline,'buildingname','�ҷֵ�����');
  AddViewField(cxGridAlarmDBTableViewOnline,'agentcompanyname','��ά��˾');
  AddViewField(cxGridAlarmDBTableViewOnline,'factoryname','���ɳ���');
  AddViewField(cxGridAlarmDBTableViewOnline,'address','�ҷֵ��ַ');
  AddViewField(cxGridAlarmDBTableViewOnline,'areaname','����');
  AddViewField(cxGridAlarmDBTableViewOnline,'cityname','����');
  AddViewField(cxGridAlarmDBTableViewOnline,'readedname','�Ƿ�����');
  AddViewField(cxGridAlarmDBTableViewOnline,'flowtachename','�澯״̬');
  AddViewField(cxGridAlarmDBTableViewOnline,'assistantContentcode','���ܸ澯����');

  AddViewField(cxGridAlarmDBTableViewOnline,'isprogramname','����/����');
  AddViewField(cxGridAlarmDBTableViewOnline,'mainlook_apname','�����AP');
  AddViewField(cxGridAlarmDBTableViewOnline,'mainlook_phsname','�����PHS');
  AddViewField(cxGridAlarmDBTableViewOnline,'mainlook_cnetname','�����C��');
  AddViewField(cxGridAlarmDBTableViewOnline,'cdmatypename','C����Դ����');
  AddViewField(cxGridAlarmDBTableViewOnline,'cdmaaddress','C����Դ��װλ��');
  AddViewField(cxGridAlarmDBTableViewOnline,'pncode','PN��');
  AddViewField(cxGridAlarmDBTableViewOnline,'reserve_pncode','�ڶ�������');
  AddViewField(cxGridAlarmDBTableViewOnline,'remark','��ע');
  AddViewField(cxGridAlarmDBTableViewOnline,'MTUID','MTU�ڲ����');
end;

procedure TFormAlarmMonitor.AddViewField_AlarmOnline_Detail;
begin
  AddViewField(cxGridAlarmDBTableViewOnline_D,'alarmid','�澯���');
  AddViewField(cxGridAlarmDBTableViewOnline_D,'taskid','������');
  AddViewField(cxGridAlarmDBTableViewOnline_D,'MTUID','MTUID');
  AddViewField(cxGridAlarmDBTableViewOnline_D,'mtuno','�豸���');
  AddViewField(cxGridAlarmDBTableViewOnline_D,'comname','��������',120);
  AddViewField(cxGridAlarmDBTableViewOnline_D,'paramname','���Բ���',80);
  AddViewField(cxGridAlarmDBTableViewOnline_D,'testresult','���Խ��ֵ');
  AddViewField(cxGridAlarmDBTableViewOnline_D,'collecttime','�ɼ�ʱ��',110);
  AddViewField(cxGridAlarmDBTableViewOnline_D,'isprocess','�Ƿ��Ѵ���');
  AddViewField(cxGridAlarmDBTableViewOnline_D,'cityname','��������',75);
end;

procedure TFormAlarmMonitor.AddViewField_AlarmRepeater;
begin
  AddViewField(cxGridAlarmDBTableViewRepeater,'alarmid','�澯���');
  AddViewField(cxGridAlarmDBTableViewRepeater,'alarmcontentname','�澯����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'alarmkindname','�澯����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'alarmlevelname','�澯�ȼ�');
  AddViewField(cxGridAlarmDBTableViewRepeater,'sendtime','����ʱ��');
  AddViewField(cxGridAlarmDBTableViewRepeater,'limithour','����ʱ��');
  AddViewField(cxGridAlarmDBTableViewRepeater,'mtuname','MTU����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'MTUNO','MTU���');
  AddViewField(cxGridAlarmDBTableViewRepeater,'mtuaddr','MTUλ��');
  AddViewField(cxGridAlarmDBTableViewRepeater,'call','�绰����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'alarmcount','�澯�ۼƴ���');
  AddViewField(cxGridAlarmDBTableViewRepeater,'overlay','���Ƿ�Χ');
  AddViewField(cxGridAlarmDBTableViewRepeater,'buildingname','�ҷֵ�����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'agentcompanyname','��ά��˾');
  AddViewField(cxGridAlarmDBTableViewRepeater,'factoryname','���ɳ���');
  AddViewField(cxGridAlarmDBTableViewRepeater,'address','�ҷֵ��ַ');
  AddViewField(cxGridAlarmDBTableViewRepeater,'areaname','����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'cityname','����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'readedname','�Ƿ�����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'flowtachename','�澯״̬');
  AddViewField(cxGridAlarmDBTableViewRepeater,'assistantContentcode','���ܸ澯����');

  AddViewField(cxGridAlarmDBTableViewRepeater,'isprogramname','����/����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'mainlook_apname','�����AP');
  AddViewField(cxGridAlarmDBTableViewRepeater,'mainlook_phsname','�����PHS');
  AddViewField(cxGridAlarmDBTableViewRepeater,'mainlook_cnetname','�����C��');
  AddViewField(cxGridAlarmDBTableViewRepeater,'cdmatypename','C����Դ����');
  AddViewField(cxGridAlarmDBTableViewRepeater,'cdmaaddress','C����Դ��װλ��');
  AddViewField(cxGridAlarmDBTableViewRepeater,'pncode','PN��');
  AddViewField(cxGridAlarmDBTableViewRepeater,'reserve_pncode','�ڶ�������');
  AddViewField(cxGridAlarmDBTableViewRepeater,'remark','��ע');
  AddViewField(cxGridAlarmDBTableViewRepeater,'MTUID','MTU�ڲ����');
end;

procedure TFormAlarmMonitor.AddViewField_AlarmRepeater_Detail;
begin
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'alarmid','�澯���');
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'taskid','������');
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'MTUID','MTUID');
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'mtuno','�豸���');
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'comname','��������',120);
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'paramname','���Բ���',80);
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'testresult','���Խ��ֵ');
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'collecttime','�ɼ�ʱ��',110);
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'isprocess','�Ƿ��Ѵ���');
  AddViewField(cxGridAlarmDBTableViewRepeater_D,'cityname','��������',75);
end;

procedure TFormAlarmMonitor.AddViewField_AlarmShow;
begin
  AddViewField(cxGridAlarmShowDBTableView1,'MTUID','MTUID');
  AddViewField(cxGridAlarmShowDBTableView1,'alarmcontentname','�澯����');
  AddViewField(cxGridAlarmShowDBTableView1,'alarmkindname','�澯����');
  AddViewField(cxGridAlarmShowDBTableView1,'alarmlevelname','�澯�ȼ�');
  AddViewField(cxGridAlarmShowDBTableView1,'sendtime','����ʱ��');
  AddViewField(cxGridAlarmShowDBTableView1,'removetime','����ʱ��');
  AddViewField(cxGridAlarmShowDBTableView1,'mtuname','MTU����');
  AddViewField(cxGridAlarmShowDBTableView1,'mtuno','MTU�豸���');
end;

procedure TFormAlarmMonitor.btCloseClick(Sender: TObject);
begin
  close;
end;
//���ֱ��վ
procedure TFormAlarmMonitor.BtnAddDRSClick(Sender: TObject);
begin
  FOperateType:= AddDRS;
  WdMapWrapper1.SetPosition;
end;
//�޸�ֱ��վ
procedure TFormAlarmMonitor.BtnModifyDRSClick(Sender: TObject);
begin
  FOperateType:= ModifyDRS;
  WdMapWrapper1.SetPosition;
end;

procedure TFormAlarmMonitor.cbShowHistoryClick(Sender: TObject);
begin
  PanelAlarmShow.Visible := cbShowHistory.Checked;
  if PanelAlarmShow.Visible then
    ShowAlarmByCounts;
end;

procedure TFormAlarmMonitor.ClearAlarmOnClickEvent(Sender: TObject);
var
  lAlarmid: integer;
  lAlarmidStr: string;
  lAlarmid_index: integer;
  I: integer;
  lRecordIndex  : integer;
  lSuccess :Boolean;
  lSqlstr, lSqlstr1, lSqlstr2: string;
  lVariant: variant;
begin
  if not CheckRecordSelected(cxGridAlarmDBTableViewOnline) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;

  try
    lAlarmid_index:=cxGridAlarmDBTableViewOnline.GetColumnByFieldName('ALARMID').Index;
  except
    lAlarmid_index:=-1;
  end;

  if (lAlarmid_index=-1) then
  begin
    Application.MessageBox('δ��ùؼ��ֶ�ALARMID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  try
    for I := cxGridAlarmDBTableViewOnline.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex := cxGridAlarmDBTableViewOnline.DataController.GetSelectedRowIndex(I);
      lRecordIndex := cxGridAlarmDBTableViewOnline.DataController.FilteredRecordIndex[lRecordIndex];
      lAlarmid := cxGridAlarmDBTableViewOnline.DataController.GetValue(lRecordIndex,lAlarmid_index);
      lAlarmidStr:= lAlarmidStr+ inttostr(lAlarmid)+ ',';
    end;
    lAlarmidStr:= copy(lAlarmidStr,1,length(lAlarmidStr)-1);
    if lAlarmidStr='' then exit;

    lVariant:= VarArrayCreate([0,2],varVariant);
    lSqlstr:= 'update alarm_master_online set flowtache=3,removetime=sysdate where alarmid in ('+lAlarmidStr+')';
    lSqlstr1:= 'insert into alarm_master_history'+
              ' select * from alarm_master_online'+
              ' where alarmid in ('+lAlarmidStr+')';
    lSqlstr2:= 'delete from alarm_master_online where alarmid in ('+lAlarmidStr+')';
    lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
    lVariant[1]:= VarArrayOf([2,4,13,lSqlstr1]);
    lVariant[2]:= VarArrayOf([2,4,13,lSqlstr2]);
    lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      //���½���
      cxGridAlarmDBTableViewOnline.Controller.DeleteSelection;
    end else
      application.MessageBox('����澯ʧ�ܣ�','��ʾ',MB_OK );
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormAlarmMonitor.cxGridAlarmActiveTabChanged(Sender: TcxCustomGrid;
  ALevel: TcxGridLevel);
begin
  if cxGridAlarm.ActiveLevel= self.cxGridAlarmLevel1 then
    ShowAlarm_Online
  else if self.cxGridAlarm.ActiveLevel= self.cxGridAlarmLevel2 then
    ShowAlarm_History
  else if cxGridAlarm.ActiveLevel= self.cxGridAlarmLevel5 then
    ShowAlarm_Repeater
  else if cxGridAlarm.ActiveLevel= self.cxGridAlarmLevel7 then
    ShowAlarm_DRS;
    
  cbShowHistoryClick(self);


    {���澯��,�������ﻭ�Ϳ����ˣ���Ϊ��onshow�������tabchanged�¼�}
  self.DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewDRSDataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  index:integer;
  lAlarmid: integer;
begin
  //�������дӱ�
  ADataController.CollapseDetails;
  index :=cxGridAlarmDBTableViewDRS.GetColumnByFieldName('alarmid').Index;
  lAlarmid:=integer(ADataController.GetValue(ARecordIndex,index));
  ShowAlarm_DRS_D(lAlarmid);
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewDRSDataControllerFilterChanged(
  Sender: TObject);
begin
  FAlarmDRSCount:= GetActiveAlarms(cxGridAlarmDBTableViewDRS);
  DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewOffDataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  index:integer;
  lAlarmid: integer;
begin
  //�������дӱ�
  ADataController.CollapseDetails;
  index :=cxGridAlarmDBTableViewOff.GetColumnByFieldName('alarmid').Index;
  lAlarmid:=integer(ADataController.GetValue(ARecordIndex,index));
  ShowAlarm_History_D(lAlarmid);
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewOffDataControllerFilterChanged(
  Sender: TObject);
begin
  FAlarmHistoryCounts:=  GetActiveAlarms(cxGridAlarmDBTableViewOff);
  DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewRepeaterDataControllerFilterChanged(
  Sender: TObject);
begin
  FAlarmRepeaterCounts:=  GetActiveAlarms(cxGridAlarmDBTableViewRepeater);
  DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewOnlineDataControllerFilterChanged(
  Sender: TObject);
begin
  FAlarmOnlineCounts:=  GetActiveAlarms(cxGridAlarmDBTableViewOnline);
  DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewOnlineCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  lReaded_Index: integer;
begin
  try
    lReaded_Index:=cxGridAlarmDBTableViewOnline.GetColumnByFieldName('READEDNAME').Index;
  except
    exit;
  end;
  if AViewInfo.GridRecord.Values[lReaded_Index]='��' then
    ACanvas.Brush.Color := $004080FF;
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewOnlineDataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  index:integer;
  lAlarmid: integer;
begin
  //�������дӱ�
  ADataController.CollapseDetails;
  index :=cxGridAlarmDBTableViewOnline.GetColumnByFieldName('alarmid').Index;
  lAlarmid:=integer(ADataController.GetValue(ARecordIndex,index));
  ShowAlarm_Online_D(lAlarmid);
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewOnlineFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  ShowAlarmByCounts;
end;

procedure TFormAlarmMonitor.cxGridAlarmDBTableViewRepeaterDataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  index:integer;
  lAlarmid: integer;
begin
  //�������дӱ�
  ADataController.CollapseDetails;
  index :=cxGridAlarmDBTableViewRepeater.GetColumnByFieldName('alarmid').Index;
  lAlarmid:=integer(ADataController.GetValue(ARecordIndex,index));
  ShowAlarm_Repeater_D(lAlarmid);
end;

procedure TFormAlarmMonitor.cxSplitter1Moved(Sender: TObject);
begin
  if PanelMap.Height<=fDefineHeight then
  begin
    PanelMap.Align:= altop;
    cxSplitter1.AlignSplitter:= salTop;
    PanelAlarm.Align:= alclient;

    cxSplitter1.Control:= PanelMap;
  end else
  begin
    PanelAlarm.Align:= albottom;
    cxSplitter1.AlignSplitter:= salbottom;
    PanelMap.Align:= alClient;

    cxSplitter1.Control:= PanelAlarm;
  end;
end;

procedure TFormAlarmMonitor.DrawActiveAlarms;
begin
  if cxGridAlarm.ActiveLevel= cxGridAlarmLevel1 then
    Fm_MainForm.DrawAlarmRecordCounts('���߸澯��ǩҳ��ǰ�澯����',inttostr(FAlarmOnlineCounts))
  else if cxGridAlarm.ActiveLevel= cxGridAlarmLevel2 then
    Fm_MainForm.DrawAlarmRecordCounts('��ʷ�澯��ǩҳ��ǰ�澯����',inttostr(FAlarmHistoryCounts))
  else if cxGridAlarm.ActiveLevel= cxGridAlarmLevel5 then
    Fm_MainForm.DrawAlarmRecordCounts('ֱ��վ�����澯��ǩҳ��ǰ�澯����',inttostr(FAlarmRepeaterCounts))
  else if cxGridAlarm.ActiveLevel= cxGridAlarmLevel7 then
    Fm_MainForm.DrawAlarmRecordCounts('ֱ��վ�澯��ǩҳ��ǰ�澯����',inttostr(FAlarmDRSCount))
end;

procedure TFormAlarmMonitor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if assigned (FormSearchBuilding) then
    FormSearchBuilding.Free;
  FormSearchBuilding:=nil;
  
  FMenuClearAlarm.Free;
  FMenuReaded.Free;
  FMenuRefresh.Free;
  FMenuWireless.Free;
  FMenuTestParticular.Free;
  FMenuLocateTree.Free;
  FMenuLocateGis.Free;
  FMenuRemark.Free;
  FCxGridHelper.Free;


  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormAlarmMonitor:=nil;
end;

procedure TFormAlarmMonitor.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAlarm,true,false,true);
  FCxGridHelper.SetGridStyle(cxGridAlarmShow,true,false,true);
  FMenuClearAlarm:= FCxGridHelper.AppendMenuItem('����澯',ClearAlarmOnClickEvent);
  FMenuReaded:= FCxGridHelper.AppendMenuItem('����',ReadedOnClickEvent);
  FMenuRefresh:= FCxGridHelper.AppendMenuItem('ˢ�¸澯',RefreshAlarmOnClickEvent);
  FCxGridHelper.AppendMenuItem('-',nil);
  FMenuWireless:= FCxGridHelper.AppendMenuItem('���߲�������',WirelessOnClickEvent);
  FMenuTestParticular:= FCxGridHelper.AppendMenuItem('�����굥',TestParticularOnClickEvent);
  FMenuLocateTree:= FCxGridHelper.AppendMenuItem('MTU��ͼ��λ',LocateTreeOnClickEvent);
  FMenuLocateGis:= FCxGridHelper.AppendMenuItem('GIS��λ',LocateGisOnClickEvent);
  FMenuRemark:= FCxGridHelper.AppendMenuItem('��д��ע', RemarkOnClickEvent);
  TPopupMenu(cxGridAlarm.PopupMenu).OnPopup:= OnMyPopup;

  try
    WdMapWrapper1:= TWdMapWrapper.Create(nil);
    WdMapWrapper1.OnMapMousePoint:= WdMapWrapper1MapMousePoint;
    WdMapWrapper1.OnMeasureingAreaEvent:= WdMapWrapper1MeasureingAreaEvent;
    WdMapWrapper1.OnMeasureingDistanceEvent:= WdMapWrapper1MeasureingDistanceEvent;
    WdMapWrapper1.OnGetPositonEvent:= WdMapWrapper1GetPositonEvent;

    FMap:=TMap.Create(self);
    FMap.Align:=alClient;
    FMap.Parent:=PanelMap;
    WdMapWrapper1.MapMain:= FMap;
    WdMapWrapper1.Startup;
//    FMap.OnMouseDown:=Map1MouseDown;
    FMap.OnDblClick:= Map1DbClick;
    PanelMap.Caption:='';
    ToolBar1.Enabled:=true;
    LabelPos.Parent:=FMap;
    LabelMeasure.Parent:=FMap;
    FMapIssetup:= true;
  except
    FMapIssetup:= false;
    Application.MessageBox('��ͼ�ؼ�δ��װ���������GISչ�֣�','��ʾ',MB_OK	+MB_ICONERROR);
//    PanelMap.Caption:='��ͼ�ؼ�δ��װ���������GISչ�֣�';
    FMap:=nil;
    cxSplitter1.CloseSplitter;
    cxSplitter1.Enabled:= false;
  end;

  if FMapIssetup then
  begin
    LoadCustomLayer;
    LoadMapView;
  end;
end;

procedure TFormAlarmMonitor.FormDestroy(Sender: TObject);
begin
  SaveMapView;
  if assigned(WdMapWrapper1) then
    WdMapWrapper1.Free;
  WdMapWrapper1:= nil;
end;

procedure TFormAlarmMonitor.FormResize(Sender: TObject);
begin
  LabelPos.Left:=5;
  LabelPos.Top:=PanelMap.Top+5;
  LabelPos.BringToFront;

  LabelMeasure.Left:=LabelPos.Left+LabelPos.Width+5;
  LabelMeasure.Top:= LabelPos.Top;
  LabelMeasure.BringToFront;
end;

procedure TFormAlarmMonitor.FormShow(Sender: TObject);
begin
  AddViewField_AlarmOnline;
  AddViewField_AlarmHistory;
  AddViewField_AlarmRepeater;
  AddViewField_AlarmOnline_Detail;
  AddViewField_AlarmHistory_Detail;
  AddViewField_AlarmRepeater_Detail;
  AddViewField_AlarmShow;
  AddViewField_AlarmDRS;
  AddViewField_AlarmDR_D;

  if cxGridAlarm.ActiveLevel<> self.cxGridAlarmLevel1 then
    cxGridAlarm.ActiveLevel:= self.cxGridAlarmLevel1
  else
    cxGridAlarmActiveTabChanged(cxGridAlarm,cxGridAlarm.ActiveLevel);
  cbShowHistoryClick(self);
  {ShowAlarm_Online;
  self.cxGridAlarm.ActiveLevel:= self.cxGridAlarmLevel2;//���������VIEW�����Զ�ˢ
  ShowAlarm_History;
  self.cxGridAlarm.ActiveLevel:= self.cxGridAlarmLevel5;
  ShowAlarm_Repeater;
  self.cxGridAlarm.ActiveLevel:= self.cxGridAlarmLevel7;
  ShowAlarm_DRS;
  self.cxGridAlarm.ActiveLevel:= self.cxGridAlarmLevel1;
  
  cbShowHistoryClick(self);}
end;

function TFormAlarmMonitor.GetActiveAlarms(aView: TcxGridDBTableView): integer;
begin
  if (aView.DataController.DataSource.DataSet<>nil)
    and (aView.DataController.DataSource.DataSet.Active)
    and (aView.DataController.DataSource.DataSet.RecordCount>0) then
    result:= aView.DataController.FilteredRecordCount
  else
    result:= 0;
end;

procedure TFormAlarmMonitor.GetPathList(aMtuid: integer;
  aPathList: TStringList);
begin
  aPathList.Clear;
  with DM_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,6,' and a.mtuid='+inttostr(aMtuid)]),0);
    if recordcount>0 then
    begin
      aPathList.Add(Fieldbyname('CITYNAME').AsString);
      aPathList.Add(Fieldbyname('AREANAME').AsString);
      aPathList.Add(Fieldbyname('SUBURBNAME').AsString);
      aPathList.Add(Fieldbyname('ISPROGRAMNAME').AsString);
      if Fieldbyname('BUILDINGNAME').AsString<>'' then
      begin
        aPathList.Add(Fieldbyname('BUILDINGNAME').AsString);
        aPathList.Add(Fieldbyname('MTUSTATUS').AsString);
      end;
      aPathList.Add(Fieldbyname('MTUNO').AsString);
    end;
  end;
end;

procedure TFormAlarmMonitor.LoadCustomLayer;
begin
  WdMapWrapper1.AddLayer(ExtractFilePath(Application.ExeName)+'Layers\'+UD_LAYER_BUILDING+'.tab');
  WdMapWrapper1.SetLayerLabel(UD_LAYER_BUILDING,'buildingname',true);

  WdMapWrapper1.AddLayer(ExtractFilePath(Application.ExeName)+'Layers\'+UD_LAYER_MTU+'.tab');
  WdMapWrapper1.SetLayerLabel(UD_LAYER_MTU,'mtuname',true);

  WdMapWrapper1.AddLayer(ExtractFilePath(Application.ExeName)+'Layers\'+UD_LAYER_CDMA+'.tab');
  WdMapWrapper1.SetLayerLabel(UD_LAYER_CDMA,'CDMANAME',true);

  WdMapWrapper1.AddLayer(ExtractFilePath(Application.ExeName)+'Layers\'+UD_LAYER_DRS+'.tab');
  WdMapWrapper1.SetLayerLabel(UD_LAYER_DRS,'DRSNAME',true);

  WdMapWrapper1.ActiveLayer:= UD_LAYER_BUILDING;

  WdMapWrapper1.AddLayer(ExtractFilePath(Application.ExeName)+'Layers\'+UD_LAYER_RELATION+'.tab');
end;

procedure TFormAlarmMonitor.LoadMapView;
var
  lIniFile:TIniFile;
  lCenterX,lCenterY,lZoom :double;
begin
  if FMap<>nil then
  begin
    WdMapWrapper1.LoadLayerConfig;
    lIniFile:=TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
      lCenterX:=lIniFile.ReadFloat('DefaultGisView','CenterX',0);
      lCenterY:=lIniFile.ReadFloat('DefaultGisView','CenterY',0);
      lZoom:=lIniFile.ReadFloat('DefaultGisView','Zoom',0);
      if not ((lCenterX=0) or (lCenterY=0) or (lZoom=0)) then
      begin
        FMap.CenterX:=lCenterX;
        FMap.CenterY:=lCenterY;
        FMap.Zoom:=lZoom;
      end;
    finally
      lIniFile.Free;
    end;
  end;
end;

procedure TFormAlarmMonitor.LocateGisOnClickEvent(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lMtuid, lbuildingid: integer;
begin
  lActiveView:= TcxGridDBTableView(TcxGrid(TPopupMenu(FMenuLocateTree.Owner).PopupComponent).ActiveView);
  if lActiveView<>nil then
  begin
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;

    Screen.Cursor := crHourGlass;
    try
      lMtuid:= lActiveView.DataController.DataSource.DataSet.FieldByName('mtuid').AsInteger;
      lbuildingid:= lActiveView.DataController.DataSource.DataSet.FieldByName('buildingid').AsInteger;
      if lbuildingid<=0 then
        Location(UD_LAYER_MTU,inttostr(lMtuid))
      else
        Location(UD_LAYER_BUILDING,inttostr(lbuildingid));
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmMonitor.LocateTreeOnClickEvent(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lMtuid: integer;
  lMtuid_index: integer;
  I : integer;
  lRecordIndex: integer;
  lPathList: TStringList;
  lSelectNode: TTreeNode;
begin
  lMtuid:= 0;
  lActiveView:= TcxGridDBTableView(TcxGrid(TPopupMenu(FMenuLocateTree.Owner).PopupComponent).ActiveView);
  if lActiveView<>nil then
  begin
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;

    try
      lMtuid_index:=lActiveView.GetColumnByFieldName('MTUID').Index;
    except
      lMtuid_index:=-1;
    end;
    if (lMtuid_index=-1) then
    begin
      Application.MessageBox('δ��ùؼ��ֶ�MTUID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    lPathList:= TStringList.Create;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
        lMtuid := lActiveView.DataController.GetValue(lRecordIndex,lMtuid_index);
        break;
      end;
      if lMtuid>0 then
      begin
        GetPathList(lMtuid,lPathList);
        if Fm_MainForm.TreeViewSub.Visible then
        begin
          lSelectNode:= GetLocateNode(Fm_MainForm.TreeViewSub,lPathList);
          if lSelectNode<>nil then
            Fm_MainForm.TreeViewSub.Selected:= lSelectNode
          else
            Application.MessageBox('δ�ҵ�MTU��','��ʾ',MB_OK	);
        end;
        if Fm_MainForm.TreeViewAll.Visible then
        begin
          lSelectNode:= GetLocateNode(Fm_MainForm.TreeViewAll,lPathList);
          if lSelectNode<>nil then
            Fm_MainForm.TreeViewAll.Selected:= lSelectNode
          else
            Application.MessageBox('δ�ҵ�MTU��','��ʾ',MB_OK	);
        end;
      end;
    finally
      lPathList.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmMonitor.Location(aLayerName, aID: string);
var
  lLayer : CMapXLayer;
begin
  if self.FMap<>nil then
  begin
    if WdMapWrapper1.GetLayer(aLayerName,lLayer) then
      lLayer.Selection.ClearSelection;
    if not WdMapWrapper1.SelectFeature(aLayerName, aID) then
      Application.MessageBox('�޷���λ�����ܸ���Ϣ����GIS��ͼ�ϣ�','��Ϣ',MB_OK +MB_ICONINFORMATION	);
  end
  else
    Application.MessageBox('��ͼ�ؼ�δ��װ��','��Ϣ',MB_OK +MB_ICONERROR);
end;

procedure TFormAlarmMonitor.Map1DbClick(Sender: TObject);
var
  pt : CMapXPoint;
  lLayer:Layer;
  fts : CMapXFeatures;
  lBuildingid: integer;
  lMtuid, lDRSID: integer;
begin
  //��ȡ�ҷֵ�
  if WdMapWrapper1.GetLayer(UD_LAYER_BUILDING,lLayer) then
  begin
    pt := CoPoint.Create;
    pt.Set_(FMapX,FMapY);
    fts := lLayer.SearchAtPoint(pt,1);
    if fts.Count > 0 then
    begin
      lBuildingid:= strtoint(fts.Item[1].KeyValue);
      gCondition:= ' and buildingid='+inttostr(lBuildingid);
      //�����л������߸澯
      cxGridAlarm.ActiveLevel:= self.cxGridAlarmLevel1;
      ShowAlarm_Online;
    end
    //��ȡMTU
    else
    if WdMapWrapper1.GetLayer(UD_LAYER_MTU,lLayer) then
    begin
      pt := CoPoint.Create;
      pt.Set_(FMapX,FMapY);
      fts := lLayer.SearchAtPoint(pt,1);
      if fts.Count > 0 then
      begin
        lMtuid:= strtoint(fts.Item[1].KeyValue);
        gCondition:= ' and mtuid='+inttostr(lMtuid);
        //�����л������߸澯
        cxGridAlarm.ActiveLevel:= self.cxGridAlarmLevel1;
        ShowAlarm_Online;
      end
      //��ȡ���Ƿ���DRS
      else if WdMapWrapper1.GetLayer(UD_LAYER_DRS,lLayer) then
      begin
        pt := CoPoint.Create;
        pt.Set_(FMapX,FMapY);
        fts := lLayer.SearchAtPoint(pt,1);
        if fts.Count > 0 then
        begin
          lDRSID:= strtoint(fts.Item[1].KeyValue);
          gCondition:= ' and drsid='+inttostr(lDRSID);
          //�����л������߸澯
          cxGridAlarm.ActiveLevel:= self.cxGridAlarmLevel7;
          ShowAlarm_DRS;
        end;
    end;
    end;     
  end;
end;

procedure TFormAlarmMonitor.OnMyPopup(Sender: TObject);
begin
  FMenuClearAlarm.Visible:= false;
  FMenuReaded.Visible:= false;

  FMenuRefresh.Visible:= false;
  FMenuWireless.Visible:= false;
  FMenuTestParticular.Visible:= false;
  FMenuLocateTree.Visible:= false;
  FMenuLocateGis.Visible:= false;
  FMenuRemark.Visible:= false;
  if TcxGrid(TPopupMenu(FMenuClearAlarm.Owner).PopupComponent)=cxGridAlarm then
  begin
    if cxGridAlarmDBTableViewOnline.Focused then
    begin
      FMenuClearAlarm.Visible:= true;
      FMenuReaded.Visible:= true;
    end;

    if (cxGridAlarmDBTableViewOnline.Focused) or (cxGridAlarmDBTableViewOff.Focused)
      or (cxGridAlarmDBTableViewRepeater.Focused) or (cxGridAlarmDBTableViewDRS.Focused) then
    begin
      FMenuRefresh.Visible:= true;
      FMenuWireless.Visible:= true;
      FMenuTestParticular.Visible:= true;
      FMenuLocateTree.Visible:= true;
      FMenuLocateGis.Visible:= true;
      FMenuRemark.Visible:= true;
    end;
  end;
end;

procedure TFormAlarmMonitor.ReadedOnClickEvent(Sender: TObject);
var
  lAlarmid: integer;
  lAlarmidStr: string;
  lAlarmid_index: integer;
  lReaded_Index: integer;
  I: integer;
  lRecordIndex  : integer;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  if not CheckRecordSelected(cxGridAlarmDBTableViewOnline) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;

  try
    lAlarmid_index:=cxGridAlarmDBTableViewOnline.GetColumnByFieldName('ALARMID').Index;
  except
    lAlarmid_index:=-1;
  end;
  try
    lReaded_Index:=cxGridAlarmDBTableViewOnline.GetColumnByFieldName('READEDNAME').Index;
  except
    lReaded_Index:=-1;
  end;

  if (lAlarmid_index=-1) or (lReaded_Index=-1) then
  begin
    Application.MessageBox('δ��ùؼ��ֶ�ALARMID,READED��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  try
    for I := cxGridAlarmDBTableViewOnline.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex := cxGridAlarmDBTableViewOnline.DataController.GetSelectedRowIndex(I);
      lRecordIndex := cxGridAlarmDBTableViewOnline.DataController.FilteredRecordIndex[lRecordIndex];
      lAlarmid := cxGridAlarmDBTableViewOnline.DataController.GetValue(lRecordIndex,lAlarmid_index);
      lAlarmidStr:= lAlarmidStr+ inttostr(lAlarmid)+ ',';
    end;
    lAlarmidStr:= copy(lAlarmidStr,1,length(lAlarmidStr)-1);
    if lAlarmidStr='' then exit;

    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr:= 'update alarm_master_online set readed=1 where alarmid in ('+lAlarmidStr+')';
    lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
    lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      //���½���
      for I := cxGridAlarmDBTableViewOnline.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := cxGridAlarmDBTableViewOnline.DataController.GetSelectedRowIndex(I);
        lRecordIndex := cxGridAlarmDBTableViewOnline.DataController.FilteredRecordIndex[lRecordIndex];
        cxGridAlarmDBTableViewOnline.DataController.SetValue(lRecordIndex,lReaded_Index,'��');
      end;
    end else
      application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK );
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormAlarmMonitor.RefreshAlarmOnClickEvent(Sender: TObject);
begin
  if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel1 then
    ShowAlarm_Online
  else if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel2 then
    ShowAlarm_History
  else if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel5 then
    ShowAlarm_Repeater
  else if FormAlarmMonitor.cxGridAlarm.ActiveLevel = FormAlarmMonitor.cxGridAlarmLevel7 then
    ShowAlarm_DRS;
end;

procedure TFormAlarmMonitor.RemarkOnClickEvent(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I : integer;
  lRecordIndex: integer;
  lTaskid, lTaskid_Index: integer;
  lMtuNoStr: string;
  lMtuNo_Index: integer;
  lAlarmContentStr: string;
  lAlarmContent_Index: integer;
  lRemark: string;
  lRemark_Index: integer;
  lFormAddAlarmInfo: TFormAddAlarmInfo;
  lTaskidStrs: string;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  lTaskid:= 0;
  lActiveView:= TcxGridDBTableView(TcxGrid(TPopupMenu(FMenuTestParticular.Owner).PopupComponent).ActiveView);
  if lActiveView<>nil then
  begin
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;

    try
      lTaskid_Index:=lActiveView.GetColumnByFieldName('ALARMID').Index;
    except
      lTaskid_Index:=-1;
    end;
    try
      lMtuNo_Index:=lActiveView.GetColumnByFieldName('MTUNO').Index;
    except
      lMtuNo_Index:=-1;
    end;
    try
      lAlarmContent_Index:=lActiveView.GetColumnByFieldName('ALARMCONTENTNAME').Index;
    except
      lAlarmContent_Index:=-1;
    end;
    try
      lRemark_Index:=lActiveView.GetColumnByFieldName('REMARK').Index;
    except
      lRemark_Index:=-1;
    end;
    if (lTaskid_Index=-1) or (lMtuNo_Index=-1) or (lAlarmContent_Index=-1) then
    begin
      Application.MessageBox('δ��ùؼ��ֶ�ALARMID,MTUNO,ALARMCONTENTNAME,REMARK��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;

    lFormAddAlarmInfo:=TFormAddAlarmInfo.Create(nil);
    try
      lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(0);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lMtuNoStr:= lActiveView.DataController.GetValue(lRecordIndex,lMtuNo_Index);
      lAlarmContentStr:= lActiveView.DataController.GetValue(lRecordIndex,lAlarmContent_Index);
      lFormAddAlarmInfo.Label1.Caption:= lMtuNoStr;
      lFormAddAlarmInfo.Label7.Caption:= lAlarmContentStr;
      if lFormAddAlarmInfo.ShowModal=mrOk then
      begin
        lRemark:= lFormAddAlarmInfo.Ed_Remark.Text;
        for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
          lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
          lTaskid:= lActiveView.DataController.GetValue(lRecordIndex,lTaskid_Index);
          lTaskidStrs:= lTaskidStrs+inttostr(lTaskid)+',';
        end;
        lTaskidStrs:= copy(lTaskidStrs,1,length(lTaskidStrs)-1);
        if lTaskidStrs='' then exit;
        lVariant:= VarArrayCreate([0,0],varVariant);
        if uppercase(lActiveView.Name)<>'CXGRIDALARMDBTABLEVIEWOFF' then
          lSqlstr:= 'update alarm_master_online set remark='''+lRemark+''' where alarmid in ('+lTaskidStrs+')'
        else
          lSqlstr:= 'update alarm_master_history set remark='''+lRemark+''' where alarmid in ('+lTaskidStrs+')';
        lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
        lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
        if lsuccess then
        begin
          //���½���
          for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
            lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
            lActiveView.DataController.SetValue(lRecordIndex,lRemark_Index,lRemark);
          end;
        end else
          application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK );
      end;
    finally
      lFormAddAlarmInfo.free;
    end;
  end;
end;

procedure TFormAlarmMonitor.SaveMapView;
var
  lIniFile:TIniFile;
begin
  if FMap<>nil then
  begin
    WdMapWrapper1.SaveLayerConfig;
    lIniFile:=TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
      lIniFile.WriteFloat('DefaultGisView','CenterX',FMap.CenterX);
      lIniFile.WriteFloat('DefaultGisView','CenterY',FMap.CenterY);
      lIniFile.WriteFloat('DefaultGisView','Zoom',FMap.Zoom);
    finally
      lIniFile.Free;
    end;
  end;
end;

procedure TFormAlarmMonitor.ShowAlarmByCounts;
begin
  if cbShowHistory.Checked then
  begin
    DataSourceShowAlarm.DataSet:= nil;
    with ClientDataSetShowAlarm do
    begin
      Close;
      ProviderName:='dsp_General_data';
      if cxGridAlarm.ActiveLevel=cxGridAlarmLevel1 then
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,4,ClientDataSetOnLine.FieldByName('MTUID').AsInteger, seCount.Value]),0);
      if cxGridAlarm.ActiveLevel=cxGridAlarmLevel5 then
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,4,ClientDataSetRepeater.FieldByName('MTUID').AsInteger, seCount.Value]),0);
      if cxGridAlarm.ActiveLevel=cxGridAlarmLevel2 then
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,4,self.ClientDataSetOff.FieldByName('MTUID').AsInteger, seCount.Value]),0);
      if cxGridAlarm.ActiveLevel=cxGridAlarmLevel7 then
        showmessage('�ޡ���ʾ���N����ʷ�澯������');
    end;
    DataSourceShowAlarm.DataSet:= ClientDataSetShowAlarm;
    cxGridAlarmShowDBTableView1.ApplyBestFit();
  end;
end;

procedure TFormAlarmMonitor.ShowAlarm_DRS;
var
  lSqlstr: string;
begin
  DataSourceDRS.DataSet:= nil;
  with ClientDataSetDRS do
  begin
    Close;
    lSqlstr:= 'select * from alarm_drs_master_online_view where flowtache=2 and 1=1'+gCondition+gAlarmKindCondition+' order by readed asc,sendtime desc';
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
  end;
  DataSourceDRS.DataSet:= ClientDataSetDRS;
  cxGridAlarmDBTableViewDRS.ApplyBestFit();
  //��ǰ�澯��
  FAlarmDRSCount:= GetActiveAlarms(cxGridAlarmDBTableViewDRS);
  DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.ShowAlarm_DRS_D(aAlarmid: integer);
var
  lSqlstr: string;
begin
  DataSourceDRS_D.DataSet:= nil;
  with ClientDataSetDRS_D do
  begin
    Close;
    lSqlstr:= 'select * from drs_alarmresult_view t where t.alarmid='+inttostr(aAlarmid)+' order by t.taskid desc';
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
  end;
  DataSourceDRS_D.DataSet:= ClientDataSetDRS_D;
  cxGridAlarmDBTableViewDRS_D.ApplyBestFit();
end;

procedure TFormAlarmMonitor.ShowAlarm_History;
begin
  DataSourceOff.DataSet:= nil;
  with ClientDataSetOff do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,2,gCondition+gAlarmKindCondition]),0);
  end;
  DataSourceOff.DataSet:= ClientDataSetOff;
  cxGridAlarmDBTableViewOff.ApplyBestFit();
  //��ǰ�澯��
  FAlarmHistoryCounts:= GetActiveAlarms(cxGridAlarmDBTableViewOff);
  DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.ShowAlarm_History_D(aAlarmid: integer);
begin
  DataSourceOff_D.DataSet:= nil;
  with ClientDataSetOff_D do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,3,aAlarmid]),0);
  end;
  DataSourceOff_D.DataSet:= ClientDataSetOff_D;
  cxGridAlarmDBTableViewOff_D.ApplyBestFit();
end;

procedure TFormAlarmMonitor.ShowAlarm_Online;
begin
  DataSourceOnLine.DataSet:= nil;
  with ClientDataSetOnLine do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,1,gCondition+gAlarmKindCondition]),0);
  end;
  DataSourceOnLine.DataSet:= ClientDataSetOnLine;
  cxGridAlarmDBTableViewOnline.ApplyBestFit();
  //��ǰ�澯��
  FAlarmOnlineCounts:= GetActiveAlarms(cxGridAlarmDBTableViewOnline);
  DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.ShowAlarm_Online_D(aAlarmid: integer);
begin
  DataSourceOnLine_D.DataSet:= nil;
  with ClientDataSetOnLine_D do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,3,aAlarmid]),0);
  end;
  DataSourceOnLine_D.DataSet:= ClientDataSetOnLine_D;
  cxGridAlarmDBTableViewOnline_D.ApplyBestFit();
end;

procedure TFormAlarmMonitor.ShowAlarm_Repeater;
begin
  DataSourceRepeater.DataSet:= nil;
  with ClientDataSetRepeater do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,1,' and cdmatype=1'+gCondition+gAlarmKindCondition]),0);
  end;
  DataSourceRepeater.DataSet:= ClientDataSetRepeater;
  cxGridAlarmDBTableViewRepeater.ApplyBestFit();
  //��ǰ�澯��
  FAlarmRepeaterCounts:= GetActiveAlarms(cxGridAlarmDBTableViewRepeater);
  DrawActiveAlarms;
end;

procedure TFormAlarmMonitor.ShowAlarm_Repeater_D(aAlarmid: integer);
begin
  DataSourceRepeater_D.DataSet:= nil;
  with ClientDataSetRepeater_D do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,3,aAlarmid]),0);
  end;
  DataSourceRepeater_D.DataSet:= ClientDataSetRepeater_D;
  cxGridAlarmDBTableViewRepeater_D.ApplyBestFit();
end;

procedure TFormAlarmMonitor.ToolButtonRefreshClick(Sender: TObject);
var
  i: integer;
  lLayerTypeSet:TLayerTypeSet;
  lFlag:boolean;
begin
  if Fm_MainForm.FThreadFlag then
  begin
    Application.MessageBox('ͼ�����ڴ����У�','��Ϣ',MB_OK +MB_ICONWARNING	);
    exit;
  end;

  FormSelectLayer:= TFormSelectLayer.Create(self);
  try
    FormSelectLayer.CheckListBox1.Items.Add(UD_LAYER_BUILDING);
    FormSelectLayer.CheckListBox1.Items.Add(UD_LAYER_MTU);
    FormSelectLayer.CheckListBox1.Items.Add(UD_LAYER_CDMA);
    FormSelectLayer.CheckListBox1.Items.Add(UD_LAYER_DRS);
    if FormSelectLayer.ShowModal=mrOK then
    begin
      lFlag:=false;
      for i := 0 to FormSelectLayer.CheckListBox1.Count - 1 do
      begin
        if FormSelectLayer.CheckListBox1.Checked[i] then
        begin
          lFlag:=true;
          case i of
            0:lLayerTypeSet:=lLayerTypeSet+[ltBuilding];
            1:lLayerTypeSet:=lLayerTypeSet+[ltMTU];
            2:lLayerTypeSet:=lLayerTypeSet+[ltCDMA];
            3:lLayerTypeSet:=lLayerTypeSet+[ltDRS];
          end;
        end;
      end;
      if lFlag=false then
      begin
        Application.MessageBox('��ѡ��ͼ�㣡','��Ϣ',MB_OK +MB_ICONWARNING	);
        exit;
      end;
      Fm_MainForm.CreateCustomLayer(lLayerTypeSet);
      WdMapWrapper1.MapMain.Refresh;
    end;
  finally
    FormSelectLayer.Free;
  end;
end;

procedure TFormAlarmMonitor.ToolButtonZoomInClick(Sender: TObject);
begin
  WdMapWrapper1.SetZoomInTool;
end;

procedure TFormAlarmMonitor.ToolButtonZoomOutClick(Sender: TObject);
begin
  WdMapWrapper1.SetZoomOutTool;
end;

procedure TFormAlarmMonitor.WdMapWrapper1GetPositonEvent(Sender: TObject; MapX,
  MapY: Double);
var
  pt : CMapXPoint;
  lLayer:Layer;
  fts : CMapXFeatures;
  i, lDRS_Index, lBuildingid, lDRSID: integer;
begin
  case FOperateType of
    LookParticular:
      begin
        if WdMapWrapper1.GetLayer(UD_LAYER_BUILDING,lLayer) then
        begin
          pt := CoPoint.Create;
          pt.Set_(MapX,MapY);
          fts := lLayer.SearchAtPoint(pt,1);
          if fts.Count > 0 then
          begin
            lBuildingid:= strtoint(fts.Item[1].KeyValue);
            if not assigned(FormBuildingParticular) then
              FormBuildingParticular:=TFormBuildingParticular.Create(Self);
            FormBuildingParticular.Analysistype:= 1;
            FormBuildingParticular.BUILDINGID:= lBuildingid;
            FormBuildingParticular.MTUID:= 0;
            FormBuildingParticular.Show;
            FormBuildingParticular.LoadBuildingInfo;
          end;
        end;
        if WdMapWrapper1.GetLayer(UD_LAYER_DRS,lLayer) then
        begin
          pt := CoPoint.Create;
          pt.Set_(MapX,MapY);
          fts := lLayer.SearchAtPoint(pt,1);
          if fts.Count > 0 then
          begin
            lDRSID:= strtoint(fts.Item[1].KeyValue);
            if not assigned(FormDRSParticular) then
              FormDRSParticular:=TFormDRSParticular.Create(Self);
            FormDRSParticular.DRSID:= lDRSID;
            FormDRSParticular.Show;
          end;
        end;
      end;
    AddDRS:
      begin
        pt := CoPoint.Create;
        pt.Set_(MapX,MapY);
        if not assigned(FrmDRSConfig) then
        begin
          FrmDRSConfig:=TFrmDRSConfig.Create(Self);
          Fm_MainForm.AddToTab(FrmDRSConfig);
        end;
        Fm_MainForm.SetTabIndex(FrmDRSConfig);
        FrmDRSConfig.WindowState:=wsMaximized;
        FrmDRSConfig.Show;
        FrmDRSConfig.tsDRSConfigInfo.Show;

        for i := 0 to FormDRSInfoMgr.PanelInfo.ControlCount - 1 do
        begin
          if (FormDRSInfoMgr.PanelInfo.Controls[i] is TEdit) then
            TEdit(FormDRSInfoMgr.PanelInfo.Controls[i]).Text:='';
          if (FormDRSInfoMgr.PanelInfo.Controls[i] is TComboBox) then
            TComboBox(FormDRSInfoMgr.PanelInfo.Controls[i]).Text:='';
        end;

        FormDRSInfoMgr.EdtLONGITUDE.Text:= FloatToStr(MapX);
        FormDRSInfoMgr.EdtLATITUDE.Text:=  FloatToStr(MapY);
        FormDRSInfoMgr.ButtonAddClick(Sender);
      end;
    ModifyDRS:
      begin
        if WdMapWrapper1.GetLayer(UD_LAYER_DRS,lLayer) then
        begin
          pt := CoPoint.Create;
          pt.Set_(MapX,MapY);
          fts := lLayer.SearchAtPoint(pt,1);
          if fts.Count > 0 then
          begin
            lDRSID:= strtoint(fts.Item[1].KeyValue);
            if not assigned(FormDRSParticular) then
              FormDRSParticular:=TFormDRSParticular.Create(Self);
            FormDRSParticular.DRSID:= lDRSID;
            FormDRSParticular.FormStyle:= fsStayOnTop;
            FormDRSParticular.Show;
          end;
        end;
      end;
  end;
end;

procedure TFormAlarmMonitor.WdMapWrapper1MapMousePoint(Sender: TObject; MapX,
  MapY: Double);
begin
  LabelPos.Caption:=Format('E %.4f  N %.4f',[MapX,MapY]);
  FMapX:= MapX;
  FMapY:= MapY;
end;

procedure TFormAlarmMonitor.WdMapWrapper1MeasureingAreaEvent(Sender: TObject;
  RegionArea: Double);
begin
  LabelMeasure.Caption:=Format('�����%.4f ƽ������',[RegionArea]);
end;

procedure TFormAlarmMonitor.WdMapWrapper1MeasureingDistanceEvent(
  Sender: TObject; CurrentDistance, TotalDistance: Double);
begin
  LabelMeasure.Caption:=Format('�ܳ��ȣ�%.2f �� ��ǰ���ȣ�%.2f ��',[TotalDistance,CurrentDistance]);
end;

procedure TFormAlarmMonitor.WirelessOnClickEvent(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lMtuid: integer;
  lMtuid_index: integer;
  I : integer;
  lRecordIndex: integer;
begin
  lMtuid:= 0;
  lActiveView:= TcxGridDBTableView(TcxGrid(TPopupMenu(FMenuWireless.Owner).PopupComponent).ActiveView);
  if lActiveView<>nil then
  begin
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;

    try
      lMtuid_index:=lActiveView.GetColumnByFieldName('MTUID').Index;
    except
      lMtuid_index:=-1;
    end;
    if (lMtuid_index=-1) then
    begin
      Application.MessageBox('δ��ùؼ��ֶ�MTUID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
        lMtuid := lActiveView.DataController.GetValue(lRecordIndex,lMtuid_index);
        break;
      end;
      if lMtuid>0 then
      begin
        if not assigned(FormWirelessParticular) then
          FormWirelessParticular:=TFormWirelessParticular.Create(nil);
        FormWirelessParticular.MTUID:= lmtuid;
        FormWirelessParticular.Show;
        FormWirelessParticular.ShowWirelessParticular;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmMonitor.ToolButtonLocatBUILDINGClick(Sender: TObject);
begin
  if not assigned(FormSearchBuilding) then
    FormSearchBuilding:=TFormSearchBuilding.Create(nil);
  FormSearchBuilding.Show;
end;

procedure TFormAlarmMonitor.ToolButtonShowBuildingParticularClick(Sender: TObject);
begin
  FOperateType:= LookParticular;
  WdMapWrapper1.SetPositionTool;
end;

procedure TFormAlarmMonitor.TestParticularOnClickEvent(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lMtuid: integer;
  lMtuid_index: integer;
  I : integer;
  lRecordIndex: integer;
begin
  lMtuid:= 0;
  lActiveView:= TcxGridDBTableView(TcxGrid(TPopupMenu(FMenuTestParticular.Owner).PopupComponent).ActiveView);
  if lActiveView<>nil then
  begin
    if not CheckRecordSelected(lActiveView) then
    begin
      Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      Exit;
    end;

    try
      lMtuid_index:=lActiveView.GetColumnByFieldName('MTUID').Index;
    except
      lMtuid_index:=-1;
    end;
    if (lMtuid_index=-1) then
    begin
      Application.MessageBox('δ��ùؼ��ֶ�MTUID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    Screen.Cursor := crHourGlass;
    try
      for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := lActiveView.DataController.GetSelectedRowIndex(I);
        lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
        lMtuid := lActiveView.DataController.GetValue(lRecordIndex,lMtuid_index);
        break;
      end;
      if lMtuid>0 then
      begin
        if not assigned(FormTestParticular) then
          FormTestParticular:=TFormTestParticular.Create(nil);
        FormTestParticular.MTUID:= lmtuid;
        FormTestParticular.Show;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TFormAlarmMonitor.ToolButtonThemeClick(Sender: TObject);
var
  lLayerName,lThemeName,lSymbolFileName:string;
begin
  lThemeName:=UD_THEME_BUILDING;
  lLayerName:=UD_LAYER_BUILDING;
  lSymbolFileName:='HOUS1-32.bmp';
  WdMapWrapper1.DrawIndividualTheme(lLayerName,'�澯ר��ͼ(�ҷֵ�)',lThemeName,'ALARMSTATUS',lSymbolFileName);

  lThemeName:=UD_THEME_MTU;
  lLayerName:=UD_LAYER_MTU;
  lSymbolFileName:='PIN5-32.BMP';
  WdMapWrapper1.DrawIndividualTheme(lLayerName,'�澯ר��ͼ(MTU)',lThemeName,'ALARMSTATUS',lSymbolFileName);
end;

procedure TFormAlarmMonitor.ToolButtonThemeSetupClick(Sender: TObject);
var
  lThemeList:TStringList;
  lThemeName: string;
begin
  lThemeList:=TStringList.Create;
  try
    WdMapWrapper1.GetThemeList(lThemeList);
    if lThemeList.Count>0 then
    begin
      lThemeName:= lThemeList.Names[0];
      WdMapWrapper1.SetThemeStyle(lThemeName);
    end
    else
      Application.MessageBox('δ���ֶ���ר��ͼ��','��ʾ',MB_OK	+MB_ICONINFORMATION);
  finally
    lThemeList.Free;
  end;
end;

procedure TFormAlarmMonitor.ToolButtonDelThemeClick(Sender: TObject);
begin
  WdMapWrapper1.RemoveTheme(UD_THEME_BUILDING);
  WdMapWrapper1.RemoveTheme(UD_THEME_MTU);
end;

procedure TFormAlarmMonitor.ToolButtonAlarmBuildingClick(Sender: TObject);
begin
  //
end;

procedure TFormAlarmMonitor.ToolButtonAlarmMtuClick(Sender: TObject);
begin
  //
end;

procedure TFormAlarmMonitor.ToolButtonArrowClick(Sender: TObject);
begin
  WdMapWrapper1.SetArrowTool;
end;

procedure TFormAlarmMonitor.ToolButtonBoundsClick(Sender: TObject);
begin
  WdMapWrapper1.SetAreaInfoTool;
end;

procedure TFormAlarmMonitor.ToolButtonClearClick(Sender: TObject);
begin
  WdMapWrapper1.Erase;
end;

procedure TFormAlarmMonitor.ToolButtonFullMapClick(Sender: TObject);
begin
  WdMapWrapper1.FullMap;
end;

procedure TFormAlarmMonitor.ToolButtonLabelClick(Sender: TObject);
begin
  WdMapWrapper1.SetDistanceTool;
end;

procedure TFormAlarmMonitor.ToolButtonLayerClick(Sender: TObject);
begin
  WdMapWrapper1.ConfigLayer;
end;

procedure TFormAlarmMonitor.ToolButtonPanClick(Sender: TObject);
begin
  WdMapWrapper1.SetPanTool;
end;

end.
