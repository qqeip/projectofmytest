unit UnitAlarmSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, ComCtrls,
  cxContainer, cxTreeView, cxGridLevel, cxClasses, cxControls, StringUtils,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, CxGridUnit,
  DBClient, dxDockControl, cxGridDBTableView, cxGrid, dxDockPanel, UDevExpressToChinese,
  dxBar, dxBarExtItems, ImgList, Buttons, cxLookAndFeelPainters, cxGroupBox, IniFiles;

const
  PageRecordcounts = 100;
type
  TNodeInfo = class
    diccode : integer;
    dicname : String;
    dicorder : integer;
    remark : string;
    parentid : integer;
    Level : integer;
    cityid : integer;
    dictype: Integer;
  end;
type
  TActiveGridView = set of (wd_Active_AlarmMaster,
                            wd_Active_AlarmDetail,
                            wd_Active_AlarmCompanyMaster,
                            wd_Active_AlarmCompanyDetail,
                            wd_Active_AlarmFlow);
  TActiveDockPanel = set of (wd_Active_ParaDetail,
                             wd_Active_ParaFlow);
  TChangedDockPanel = set of (wd_Changed_ParaDetail,
                             wd_Changed_ParaFlow);
  TFormAlarmSearch = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    dxDockSite1: TdxDockSite;
    dxLayoutDockSite7: TdxLayoutDockSite;
    dxLayoutDockSite5: TdxLayoutDockSite;
    dxLayoutDockSite1: TdxLayoutDockSite;
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
    dxDockPanel6: TdxDockPanel;
    cxGridFlow: TcxGrid;
    cxGridFlowDBTableView1: TcxGridDBTableView;
    cxGridFlowLevel1: TcxGridLevel;
    dxLayoutDockSite3: TdxLayoutDockSite;
    dxDockingManager1: TdxDockingManager;
    CDS_Detail: TClientDataSet;
    DS_Detail: TDataSource;
    DS_Flow: TDataSource;
    CDS_Flow: TClientDataSet;
    CDS_AlarmMaster: TClientDataSet;
    DS_AlarmMaster: TDataSource;
    Panel2: TPanel;
    CheckBoxTimeSend: TCheckBox;
    CheckBoxTimeClear: TCheckBox;
    Panel4: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    SendD1: TDateTimePicker;
    SendT1: TDateTimePicker;
    SendD2: TDateTimePicker;
    SendT2: TDateTimePicker;
    Panel5: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    WreckD1: TDateTimePicker;
    WreckT1: TDateTimePicker;
    WreckD2: TDateTimePicker;
    WreckT2: TDateTimePicker;
    CheckBoxBTSID: TCheckBox;
    EditBTSID: TEdit;
    CheckBoxADRESS: TCheckBox;
    EditADDRESS: TEdit;
    CheckBoxCELLNO: TCheckBox;
    EditBTSNAME: TEdit;
    CheckBoxBTSNAME: TCheckBox;
    CheckBoxFlowTache: TCheckBox;
    ComboBoxFlowTache: TComboBox;
    CheckBoxContent: TCheckBox;
    ComboBoxContent: TComboBox;
    CheckBoxDiachronic: TCheckBox;
    ComboBoxDiachronic: TComboBox;
    EditDiachronic: TEdit;
    EditCELLNO: TEdit;
    CheckBoxOVER: TCheckBox;
    Panel3: TPanel;
    Label6: TLabel;
    OVERD1: TDateTimePicker;
    OVERT1: TDateTimePicker;
    dxBarManager1: TdxBarManager;
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
    Timer1: TTimer;
    EditFilter: TEdit;
    CheckBox1: TCheckBox;
    Panel7: TPanel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    ImageTree: TImageList;
    CheckBoxOutTime: TCheckBox;
    ComboBoxOutTime: TComboBox;
    CheckBoxAlarmCause: TCheckBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    BitBtn1: TBitBtn;
    ImageListAlarmCause: TImageList;
    cxGroupBox1: TcxGroupBox;
    cxTreeViewAlarmCause: TcxTreeView;
    Edit1: TEdit;
    BitBtn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Btn_SearchClick(Sender: TObject);
    procedure cxGridAlarmMasterDBTableView1CellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure FormDestroy(Sender: TObject);
    //procedure ComboBoxCompanyChange(Sender: TObject);
    procedure dxBarManager1Docking(Sender: TdxBar;
      Style: TdxBarDockingStyle; DockControl: TdxDockControl;
      var CanDocking: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure EditFilterKeyPress(Sender: TObject; var Key: Char);
    procedure dxBarButton27Click(Sender: TObject);
    procedure dxBarComboCompanyChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cxTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure dxDockPanel1AutoHideChanged(Sender: TdxCustomDockControl);
    procedure dxDockPanel1AutoHideChanging(Sender: TdxCustomDockControl);
    procedure CheckBoxAlarmCauseClick(Sender: TObject);
    procedure cxTreeViewAlarmCauseMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckBoxOutTimeClick(Sender: TObject);
    procedure cxGridAlarmDetailEnter(Sender: TObject);
    procedure cxGridAlarmDetailExit(Sender: TObject);
    procedure cxGridFlowEnter(Sender: TObject);
    procedure cxGridFlowExit(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CheckBoxContentClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure cxGridFlowDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);

  private
    FControlChanging: boolean;
    FCxGridHelper : TCxGridSet;
    gFlowColorList: TStringList;
    gFilterWhere: string;
    FMaxReasionTreeLevel: integer;     //最大故障原因级别

    gClick_Cityid, gClick_Companyid, gClick_Batchid: integer;
    gClick_RecordChanged: boolean;
    gActiveDockPanel: TActiveDockPanel;
    gChangedDockPanel: TChangedDockPanel;
    gActiveGridView: TActiveGridView;
    procedure SetToDate;
    function CheckDate: boolean;
    procedure IniCondition;
    function CombineDate(aDate,aTime :TDateTimePicker):String;
    procedure LoadTreeAlarmCause(aCityid: integer);
    //获得where的条件
    function GetCondition:String;
    procedure AddFlowField(aView: TcxGridDBTableView);
    procedure ResizeFilter;
    procedure CreateTree(aTreeView: TcxTreeView; aDicType: Integer);
    procedure AddTreeViewNode(aTreeView: TcxTreeView; aCODE, aORDER,
      aPARENTID, aCITYID, aDicType: Integer;aSETVALUE, aNAME, aREMARK: string);
    function GetMaxReasonTreeLevel: Integer;
    procedure dxDockPanelVisibleChanged(Sender: TdxCustomDockControl);
  public
    gSelectCode: string;
    gHashedAlarmListLocal:THashedStringList;
    procedure ShowMasterAlarmOnline;     //在线主障告警
    procedure ShowDetailAlarmOnline(aBatchid, aCompanyid, aCityid: integer);     //在线从障告警
    procedure ShowFlowRecOnline(aBatchid, aCompanyid, aCityid: integer);         //在线流转告警
  end;

var
  FormAlarmSearch: TFormAlarmSearch;

implementation

uses UnitVFMSGlobal, UnitDllCommon, UnitAlarmContentModule;

{$R *.dfm}

procedure TFormAlarmSearch.FormCreate(Sender: TObject);
begin
  gFlowColorList:= TStringList.Create;
  FMaxReasionTreeLevel:= self.GetMaxReasonTreeLevel;
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.NewSetGridStyle(cxGridAlarmMaster,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridAlarmDetail,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridFlow,false,true,true);

  //加字段
  LoadFields(cxGridAlarmMasterDBTableView1,gPublicParam.cityid,gPublicParam.userid,9);
  LoadFields(cxGridAlarmDetailDBTableView1,gPublicParam.cityid,gPublicParam.userid,10);
  LoadFields(cxGridFlowDBTableView1,gPublicParam.cityid,gPublicParam.userid,31);
  AddHindFlowField(cxGridFlowDBTableView1);

  //画树
  cxTreeView1.Items.Clear;
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,31);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,3);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,2);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,32);
  DrawAlarmStatusTree(cxTreeView1,gPublicParam.cityid,33);

  dxDockPanel4.OnVisibleChanged:= dxDockPanelVisibleChanged;
  dxDockPanel6.OnVisibleChanged:= dxDockPanelVisibleChanged;
  gHashedAlarmListLocal:=THashedStringList.Create();
end;

procedure TFormAlarmSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //回调，用DLLMGR去释放窗体
  gDllMsgCall(FormAlarmSearch,1,'','');
end;

procedure TFormAlarmSearch.FormDestroy(Sender: TObject);
begin
//菜单释放
  FCxGridHelper.Free;
  ClearTStrings(gFlowColorList);
end;

procedure TFormAlarmSearch.FormShow(Sender: TObject);
begin
  IniCondition;
  SelectNode(cxTreeView1,'派障综合查询');
end;

procedure TFormAlarmSearch.ShowDetailAlarmOnline(aBatchid, aCompanyid,
  aCityid: integer);
var
  lSqlstr: string;
begin
  //if not cxGridAlarmDetail.CanFocus then exit;
  lSqlstr := 'select * from (select * from fault_detail_online_view'+
                            ' union all select * from fault_detail_history_view) a'+
             ' where cityid='+inttostr(aCityid)+' and companyid='+inttostr(aCompanyid)+
             ' and batchid='+inttostr(aBatchid)+' order by alarmid desc,companyid';
  DS_Detail.DataSet:= nil;
  try
    with CDS_Detail do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    end;
  finally

  end;
  DS_Detail.DataSet:= CDS_Detail;
  cxGridAlarmDetailDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmSearch.ShowFlowRecOnline(aBatchid, aCompanyid,
  aCityid: integer);
var
  lCompanyid: integer;
  lCompanyidStr: string;
  lIndex: integer;
  lSqlstr: string;
begin
  lSqlstr := 'select * from (select * from alarm_oprec_online_view'+
                            ' union all select * from alarm_oprec_history_view) a'+
             ' where cityid='+inttostr(aCityid)+' and batchid='+inttostr(aBatchid)+
             ' order by companyid,trackid';
  DS_Flow.DataSet:= nil;
  try
    with CDS_Flow do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    end;
  finally
  end;
  DS_Flow.DataSet:= CDS_Flow;
  //cxGridFlowDBTableView1.ApplyBestFit();
  if not GetFlowColorSet(CDS_Flow, gFlowColorList) then
    raise exception.Create('获取流程日志颜色设置失败');
end;

procedure TFormAlarmSearch.ShowMasterAlarmOnline;
var
  lSqlstr: string;
begin
  if not cxGridAlarmMaster.CanFocus then exit;

  lSqlstr := 'select * from (select t1.*,decode(flowtache,1,t1.diachronic,9,t1.diachronic,round((sysdate-t1.sendtime)*24,4)) as alarmdiachronic  from fault_master_online_view t1 union all'+
             ' select t2.*,decode(flowtache,1,t2.diachronic,9,t2.diachronic,round((sysdate-t2.sendtime)*24,4)) as alarmdiachronic  from fault_master_histroy_view t2) a '+
             ' where a.cityid='+inttostr(gPublicParam.cityid)+
             ' and a.companyid in ('+gPublicParam.RuleCompanyidStr+')'+GetCondition+gFilterWhere;

  DS_AlarmMaster.DataSet:= nil;
  try
    with CDS_AlarmMaster do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    end;
  finally

  end;
  DS_AlarmMaster.DataSet:= CDS_AlarmMaster;
  cxGridAlarmMasterDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmSearch.SetToDate;
begin
  SendD1.Date  := date-1;
  WreckD1.Date := date-1;
  OVERD1.Date:= date-1;
  SendT1.Time  := time;
  WreckT1.Time := time;
  OVERT1.Time:= time;

  SendD2.Date  := date;
  WreckD2.Date := date;
  SendT2.Time  := time;
  WreckT2.Time := time;

  self.DateTimePicker1.Date:= date;
  self.DateTimePicker2.Time:= time;
end;

procedure TFormAlarmSearch.IniCondition;
begin
  //设置时间
  SetToDate;
  GetFlowtache(gPublicParam.cityid,4,ComboBoxFlowTache.Items);
  GetContentCode(gPublicParam.cityid,gPublicParam.Companyid,ComboBoxContent.Items);   
  //加维护单位
  LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,dxBarComboCompany.Items);
  //LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,ComboBoxCompany.Items);
  //加载故障原因树
  CreateTree(cxTreeViewAlarmCause,7);
end;

function TFormAlarmSearch.GetCondition: String;
var
  lTmp:string;
  lWhereStr:string;
  i: integer;
  lCauseCode: string;
  function getCondition(aFieldName:string;aComboBox:TComboBox):string;
  begin
    if aComboBox.ItemIndex>-1 then
      result:=' and '+aFieldName+'='+TWdInteger(aComboBox.Items.Objects[aComboBox.ItemIndex]).ToString
    else result:=' and '+aFieldName+' is null';
  end;
  function GetLikeCondition(aFieldName:string;aEdit:TEdit):string;
  begin
    lTmp:=UpperCase(Trim(aEdit.Text));
    if lTmp<>'' then
      result:=' and upper('+aFieldName+') like ''%'+lTmp+'%'''
    else result:=' and '+aFieldName+' is null';
  end;
  function GetBatchidStrs(aFieldName:string;aComboBox:TComboBox):string;
  var
    lClientDataSet: TClientDataSet;
    lSqlstr: string;
    lBatchidStrs: string;
    lResult: string;
  begin
    lBatchidStrs:= '';
    lClientDataSet:= TClientDataSet.Create(nil);
    try
      with lClientDataSet do
      begin
        ProviderName:= 'DataSetProvider';
        lSqlstr:= 'select t.batchid from fault_detail_history t';
        if aComboBox.ItemIndex>-1 then
          lSqlstr:=lSqlstr+' where t.cityid='+inttostr(gPublicParam.cityid)+
                           ' and t.alarmcontentcode='+
                           inttostr(TWdInteger(aComboBox.Items.Objects[aComboBox.ItemIndex]).Value)
        else
          lSqlstr:=lSqlstr+' where t.cityid='+inttostr(gPublicParam.cityid)+
                           ' and t.alarmcontentcode is null';
        lSqlstr:= lSqlstr+' union select t.batchid from fault_detail_online t';
        if aComboBox.ItemIndex>-1 then
          lSqlstr:=lSqlstr+' where t.cityid='+inttostr(gPublicParam.cityid)+
                           ' and t.alarmcontentcode='+
                           inttostr(TWdInteger(aComboBox.Items.Objects[aComboBox.ItemIndex]).Value)
        else
          lSqlstr:=lSqlstr+' where t.cityid='+inttostr(gPublicParam.cityid)+
                           ' and t.alarmcontentcode is null';
        Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);

        while not eof do
        begin
          lBatchidStrs:= lBatchidStrs+FieldByName('batchid').AsString+',';
          next;
        end;
      end;
      if aComboBox.ItemIndex>-1 then
        lResult:=aFieldName+'='+TWdInteger(aComboBox.Items.Objects[aComboBox.ItemIndex]).ToString
      else lResult:=aFieldName+' is null';

      if length(lBatchidStrs)>0 then
      begin
        lBatchidStrs:= copy(lBatchidStrs,1,length(lBatchidStrs)-1);
        lResult:= ' and (('+lResult+') or (batchid in ('+lBatchidStrs+')))';
      end
      else
        lResult:= ' and '+lResult;
      result:= lResult;
    finally
      lClientDataSet.Free;
    end;
  end;
  function GetBatchidStrs2(aFieldName:string):string;
  var
    lClientDataSet: TClientDataSet;
    lSqlstr: string;
    lBatchidStrs: string;
    lResult: string;
    lcompanyid:string;
    lcompany_batch:string;
  begin
    lcompanyid:='';
    lcompany_batch:='';
    lBatchidStrs:= '';
    lClientDataSet:= TClientDataSet.Create(nil);
    try
      with lClientDataSet do
      begin
        ProviderName:= 'DataSetProvider';
        lSqlstr:= 'select t.batchid , t.companyid from fault_detail_history t';
        if gSelectCode<>'' then
          lSqlstr:=lSqlstr+' where t.cityid='+inttostr(gPublicParam.cityid)+
                             ' and t.alarmcontentcode in ('+self.gSelectCode+')'
        else
          lSqlstr:=lSqlstr+' where t.cityid='+inttostr(gPublicParam.cityid)+
                             ' and t.alarmcontentcode is null';
        lSqlstr:= lSqlstr+' union select t.batchid,t.companyid from fault_detail_online t';
        if gSelectCode<>'' then
          lSqlstr:=lSqlstr+' where t.cityid='+inttostr(gPublicParam.cityid)+
                             ' and t.alarmcontentcode in ('+self.gSelectCode+')'
        else
          lSqlstr:=lSqlstr+' where t.cityid='+inttostr(gPublicParam.cityid)+
                             ' and t.alarmcontentcode is null';
        Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
        First;
        while not eof do
        begin

          lBatchidStrs:=FieldByName('batchid').AsString;
          lcompanyid := FieldByName('companyid').AsString;
          lcompany_batch:= lcompany_batch+ '(batchid='+lBatchidStrs+' and '+ 'companyid='+lcompanyid+') or ' ;
          next;
        end;
      end;
      if gSelectCode<>'' then
        lResult:=aFieldName+' in ('+gSelectCode+')'
      else lResult:=aFieldName+' is null';

      if length(lBatchidStrs)>0 then
      begin
        lcompany_batch:= copy(lcompany_batch,1,length(lcompany_batch)-3);
        //lResult:= ' and (('+lResult+') or (batchid in ('+lBatchidStrs+')))';
        lResult:= ' and (('+lResult+') or '+ lcompany_batch+' )';

      end
      else
        lResult:= ' and '+lResult;
      result:= lResult;
    finally
      lClientDataSet.Free;
    end;
  end;
begin
  if CheckBoxTimeSend.Checked then
  begin
    lWhereStr :=lWhereStr+' and a.SENDTIME between to_date('''+CombineDate(SendD1,SendT1)+''',''YYYY-MM-DD HH24:MI'')'+
               ' and to_date('''+CombineDate(SendD2,SendT2)+''',''YYYY-MM-DD HH24:MI'')';
  end;
  if CheckBoxTimeClear.Checked then
  begin
    lWhereStr :=lWhereStr+' and a.CLEARTIME between to_date('''+CombineDate(WreckD1,WreckT1)+''',''YYYY-MM-DD HH24:MI'')'+
               ' and to_date('''+CombineDate(WreckD2,WreckT2)+''',''YYYY-MM-DD HH24:MI'')';
  end;
  if CheckBoxOVER.Checked then
  begin
    lWhereStr :=lWhereStr+' and a.LIMITTIME <= to_date('''+CombineDate(OVERD1,OVERT1)+''',''YYYY-MM-DD HH24:MI'')';
  end;
  if CheckBoxFlowTache.Checked then
  begin
    lWhereStr :=lWhereStr+getCondition('a.FLOWTACHE',ComboBoxFlowTache);
  end;
  if CheckBoxContent.Checked then
  begin
    lWhereStr :=lWhereStr+GetBatchidStrs2('a.ALARMCONTENTCODE');

    //lWhereStr :=lWhereStr+' and a.ALARMCONTENTCODE in ('+gSelectCode+') ';
  end;
  if CheckBoxBTSID.Checked then
  begin
    lWhereStr :=lWhereStr+GetLikeCondition('a.BTSID',EditBTSID);
  end;
  if CheckBoxBTSNAME.Checked then
  begin
    lWhereStr :=lWhereStr+GetLikeCondition('a.bts_name',EditBTSNAME);
  end;
  if CheckBoxADRESS.Checked then
  begin
    lWhereStr :=lWhereStr+GetLikeCondition('a.station_addr',EditADDRESS);
  end;
  if CheckBoxCELLNO.Checked then
  begin
    lWhereStr :=lWhereStr+GetLikeCondition('a.cell_no',EditCELLNO);
  end;
  if CheckBoxDiachronic.Checked then
  begin
    if Trim(EditDiachronic.Text)='' then
      EditDiachronic.Text:='0';
    lWhereStr :=lWhereStr+' and a.alarmdiachronic'+ComboBoxDiachronic.Text+EditDiachronic.Text;
  end;
  if self.CheckBox1.Checked then
  begin
    lWhereStr :=lWhereStr+' and ((a.sendtime<= to_date('''+CombineDate(DateTimePicker1,DateTimePicker2)+''',''YYYY-MM-DD HH24:MI'')'+
                                      ' and a.cleartime>= to_date('''+CombineDate(DateTimePicker1,DateTimePicker2)+''',''YYYY-MM-DD HH24:MI''))'+
                                ' or (a.flowtache=5 and a.sendtime<=to_date('''+CombineDate(DateTimePicker1,DateTimePicker2)+''',''YYYY-MM-DD HH24:MI'')))';
  end;
  if CheckBoxAlarmCause.Checked then
  begin
    lCauseCode:= '';
    for i:= 0 to cxTreeViewAlarmCause.Items.Count -1 do
    begin
      if (cxTreeViewAlarmCause.Items[i].Level= FMaxReasionTreeLevel-1)
        and (cxTreeViewAlarmCause.Items[i].ImageIndex=1)
          and (cxTreeViewAlarmCause.Items[i].SelectedIndex=1) then
      begin
        lCauseCode:= lCauseCode+inttostr(TNodeInfo(cxTreeViewAlarmCause.Items[i].Data).diccode)+',';
      end;
    end;
    lCauseCode:= copy(lCauseCode,1,length(lCauseCode)-1);
    lWhereStr:= lWhereStr+' and a.causecode in ('+lCauseCode+')';
  end;
  if CheckBoxOutTime.Checked then
  begin
    if ComboBoxOutTime.ItemIndex=0 then   //否
    begin
      lWhereStr:= lWhereStr+ ' and ((to_date(to_char(a.limittime,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'') >=to_date(to_char(sysdate,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'') and a.flowtache<>9 and a.flowtache<>1)'+
                                    ' or (to_date(to_char(a.limittime,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'') >=to_date(to_char(a.cleartime,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'') and a.flowtache=9))';
    end
    else
    if ComboBoxOutTime.ItemIndex=1 then
    begin                                       //未消障并超时  不包括删除的
      lWhereStr:= lWhereStr+ ' and ((to_date(to_char(a.limittime,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'') <to_date(to_char(sysdate,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'') and a.flowtache<>9 and a.flowtache<>1)'+
                                                //已消障超时
                                    ' or (to_date(to_char(a.limittime,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'') <to_date(to_char(a.cleartime,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'') and a.flowtache=9))';
    end;
  end;
  result:= lWhereStr;
end;

procedure TFormAlarmSearch.Btn_SearchClick(Sender: TObject);
var
  i: integer;
  lIsSelected: boolean;
begin
  if not CheckDate then
  begin
    MessageBox(Handle, '起始时间不能大于截止时间!', '信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  if CheckBoxAlarmCause.Checked then
  begin
    lIsSelected:= false;
    for I:= 0 to cxTreeViewAlarmCause.Items.Count - 1 do
    begin
      if (cxTreeViewAlarmCause.Items[i].Level= FMaxReasionTreeLevel-1)
        and (cxTreeViewAlarmCause.Items[i].ImageIndex=1)
          and (cxTreeViewAlarmCause.Items[i].SelectedIndex=1) then
      begin
        lIsSelected:= true;
        break;
      end;
    end;
    if not lIsSelected then
    begin
      MessageBox(Handle, '未选择故障原因!', '信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
  end;
  ShowMasterAlarmOnline;
end;

function TFormAlarmSearch.CheckDate: boolean;
begin
  Result := True;
  if CheckBoxTimeSend.Checked then
    if SendD1.Date+SendT1.Date > SendD2.Date+SendT2.Date then
    begin
      Result := False;
      Exit;
    end;
  if CheckBoxTimeClear.Checked then
    if WreckD1.Date+WreckT1.Date > WreckD2.Date+WreckT2.Date then
    begin
      Result := False;
      Exit;
    end
end;

procedure TFormAlarmSearch.cxGridAlarmMasterDBTableView1CellClick(
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
  if gClick_RecordChanged then
  begin
    gClick_Cityid:= lCityid;
    gClick_Companyid:= lCompanyid;
    gClick_Batchid:= lBatchid;

    gActiveDockPanel:= [];
    dxDockPanelVisibleChanged(dxDockPanel4);
    dxDockPanelVisibleChanged(dxDockPanel6);
  end;
  {ShowDetailAlarmOnline(lBatchid,lCompanyid,lCityid);
  ShowFlowRecOnline(lBatchid,lCompanyid,lCityid); }
end;

function TFormAlarmSearch.CombineDate(aDate,
  aTime: TDateTimePicker): String;
begin
  Result := DateToStr(aDate.Date)+' '+FormatDateTime('HH:mm',aTime.Time);
end;

procedure TFormAlarmSearch.AddFlowField(aView: TcxGridDBTableView);
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

{procedure TFormAlarmSearch.ComboBoxCompanyChange(Sender: TObject);
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


procedure TFormAlarmSearch.dxBarManager1Docking(Sender: TdxBar;
  Style: TdxBarDockingStyle; DockControl: TdxDockControl;
  var CanDocking: Boolean);
begin
  Timer1.Enabled:= true;
end;

procedure TFormAlarmSearch.Timer1Timer(Sender: TObject);
begin
  sleep(1);
  ResizeFilter;
  Timer1.Enabled:= false;
end;

procedure TFormAlarmSearch.EditFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    dxBarButton27Click(self);
end;

procedure TFormAlarmSearch.dxBarButton27Click(Sender: TObject);
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

procedure TFormAlarmSearch.ResizeFilter;
begin
  EditFilter.Left:= dxBarManager1Bar7.DockedLeft+10;
  EditFilter.Top:= dxBarManager1Bar7.DockedTop+62;
  EditFilter.Width:= dxBarEditFilters.Width;
  EditFilter.BringToFront;
end;

procedure TFormAlarmSearch.dxBarComboCompanyChange(Sender: TObject);
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

procedure TFormAlarmSearch.FormResize(Sender: TObject);
begin
  ResizeFilter;
end;

procedure TFormAlarmSearch.cxTreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
  //由于DOCKPANEL隐藏的时候会触发事件，所以要屏蔽掉
  if FControlChanging then exit;
  if (Node=nil) or (Node.Data=nil) then exit;
  case TNodeParam(Node.Data).NodeType of
    31,2,3:  begin//告警流程树
               //if cxTreeView1.Selected<>nil then
                 //gDllMsgCall(nil,3,'FormAlarmTracker',cxTreeView1.Selected.Text);
                 gDllMsgCall(nil,3,'FormAlarmTracker',TNodeParam(Node.Data).DisplayName);
               exit;
             end;
    32:  begin//告警疑难树
           //if cxTreeView1.Selected<>nil then
             //gDllMsgCall(nil,4,'FormAlarmStay',cxTreeView1.Selected.Text);
             gDllMsgCall(nil,4,'FormAlarmStay',TNodeParam(Node.Data).DisplayName);
           exit;
         end;
    33:  begin//派障综合查询
           //这里打开查询
    end;
  end;
end;

procedure TFormAlarmSearch.dxDockPanel1AutoHideChanged(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= false;
end;

procedure TFormAlarmSearch.dxDockPanel1AutoHideChanging(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= true;
end;

procedure TFormAlarmSearch.CheckBoxAlarmCauseClick(Sender: TObject);
begin
  cxGroupBox1.Visible:= CheckBoxAlarmCause.Checked;
end;

procedure TFormAlarmSearch.LoadTreeAlarmCause(aCityid: integer);
begin
  //
end;

procedure TFormAlarmSearch.CreateTree(aTreeView: TcxTreeView;
  aDicType: Integer);
var
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,200,aDicType]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        AddTreeViewNode(aTreeView,
                        FieldByName('DICCODE').AsInteger,
                        FieldByName('DICORDER').AsInteger,
                        FieldByName('PARENTID').AsInteger,
                        FieldByName('CITYID').AsInteger,
                        adictype,
                        FieldByName('SETVALUE').asString,
                        FieldByName('DICNAME').AsString,
                        FieldByName('REMARK').AsString
                        );
        Next;
      end;
    end;
    aTreeView.FullExpand;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmSearch.AddTreeViewNode(aTreeView: TcxTreeView; aCODE,
  aORDER, aPARENTID, aCITYID, aDicType: Integer; aSETVALUE, aNAME,
  aREMARK: string);
var
  lNodeInfo:TNodeInfo;
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
        if TNodeInfo(lTempNode.Data).diccode=aParent then
        begin
          result:=lTempNode;
          Break;
        end;
        lTempNode:=lTempNode.getNext;
      end;
    end;
  end;
begin
  lNodeInfo:= TNodeInfo.Create;
  lNodeInfo.diccode  := aCODE;
  lNodeInfo.dicorder := aORDER;
  lNodeInfo.parentid := aPARENTID;
  lNodeInfo.Level    := StrToInt(aSETVALUE);
  lNodeInfo.cityid := gPublicParam.cityid;
  lNodeInfo.dictype:= aDicType;
  lNodeInfo.dicname := aNAME;
  lNodeInfo.remark := aREMARK;
  lParentNode:= GetParentNode(StrToInt(aSETVALUE),aPARENTID);
  lNewNode:= aTreeView.Items.AddChildObject(lParentNode,lNodeInfo.dicname,lNodeInfo);
  //lNewNode.ImageIndex:=StrToInt(aSETVALUE);
end;

procedure TFormAlarmSearch.cxTreeViewAlarmCauseMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cxTreeViewMouseDown(cxTreeViewAlarmCause,x,y);
end;

function TFormAlarmSearch.GetMaxReasonTreeLevel: Integer;
var
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,201,gPublicParam.cityid]),0);
      if IsEmpty then
        result:= 0
      else
        Result:= fieldbyname('setvalue').AsInteger;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmSearch.CheckBoxOutTimeClick(Sender: TObject);
begin
  if CheckBoxOutTime.Checked then
    ComboBoxOutTime.ItemIndex:= 0;
end;
procedure TFormAlarmSearch.dxDockPanelVisibleChanged(
  Sender: TdxCustomDockControl);
begin
  if TdxDockPanel(Sender) = dxDockPanel4 then
    if TdxDockPanel(Sender).Visible then
      gActiveDockPanel:= gActiveDockPanel+ [wd_Active_ParaDetail]
    else
      gActiveDockPanel:= gActiveDockPanel- [wd_Active_ParaDetail]
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
  if (wd_Active_ParaDetail in gActiveDockPanel) then
  begin
    //showmessage('wd_Active_ParaDetail');
    ShowDetailAlarmOnline(gClick_Batchid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:= gChangedDockPanel+ [wd_Changed_ParaDetail];
  end;
  if (wd_Active_ParaFlow in gActiveDockPanel)  then
  begin
    //showmessage('wd_Active_ParaFlow');
    ShowFlowRecOnline(gClick_Batchid,gClick_Companyid,gClick_Cityid);
    gChangedDockPanel:= gChangedDockPanel+ [wd_Changed_ParaFlow];
  end;
end;

procedure TFormAlarmSearch.cxGridAlarmDetailEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmDetail];
end;

procedure TFormAlarmSearch.cxGridAlarmDetailExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView - [wd_Active_AlarmDetail];
end;

procedure TFormAlarmSearch.cxGridFlowEnter(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView + [wd_Active_AlarmFlow];
end;

procedure TFormAlarmSearch.cxGridFlowExit(Sender: TObject);
begin
  gActiveGridView:= gActiveGridView -[wd_Active_AlarmFlow];
end;

procedure TFormAlarmSearch.BitBtn2Click(Sender: TObject);
var
  i, j, lAlarmCode: Integer;
  lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lHashedAlarmList: THashedStringList;
  lsqlstr:string;
  lClientDataSet:TClientDataSet;
  lFormAlarmContentModule: TFormAlarmContentModule;
  lContentcodeStr,lContentNameStr: string;

begin
  lClientDataSet:= TClientDataSet.Create(nil);
  lHashedAlarmList:= THashedStringList.Create;
  lHashedAlarmList:=gHashedAlarmListLocal;
  lFormAlarmContentModule:= TFormAlarmContentModule.create(nil,lHashedAlarmList);
  try
    repeat
      lFormAlarmContentModule.ShowModal;
      if lFormAlarmContentModule.ModalResult <> mrOk then
        break;
      if gHashedAlarmListLocal.Count=0 then
         Application.MessageBox(pchar('选择一个告警内容'), '系统提示', MB_ICONWARNING);
      if gHashedAlarmListLocal.Count>5 then
         Application.MessageBox(pchar('该功能告警内容最多只能选择五个'), '系统提示', MB_ICONWARNING);
    until (lFormAlarmContentModule.gHashedAlarmList.Count>0) and  (lFormAlarmContentModule.gHashedAlarmList.Count<6)
          and (lFormAlarmContentModule.ModalResult = mrOk);
    if lFormAlarmContentModule.ModalResult = mrOk then
    begin
      gSelectCode:='';
      Edit1.Text:='';
      Edit1.hint:='';
      Edit1.ShowHint:=false;
      for j:= 0 to lFormAlarmContentModule.gHashedAlarmList.Count -1 do
      begin
        lContentNameStr:= lContentNameStr+ lFormAlarmContentModule.gHashedAlarmList.Strings[j]+',';
        lContentcodeStr:= lContentcodeStr+ TWdInteger(lFormAlarmContentModule.gHashedAlarmList.Objects[j]).ToString+',';
      end;
      if length(lContentNameStr)>0 then
        lContentNameStr:= copy(lContentNameStr,1,length(lContentNameStr)-1)
      else
        lContentNameStr:= '';
      if length(lContentcodeStr)>0 then
        lContentcodeStr:= copy(lContentcodeStr,1,length(lContentcodeStr)-1)
      else
        lContentcodeStr:= '-1';
        
      Edit1.Text:= lContentNameStr;
      gSelectCode:= lContentcodeStr;
      Edit1.Hint:=Edit1.Text;
      Edit1.ShowHint:=True;
    end;
  finally
     lFormAlarmContentModule.gHashedAlarmList.Clear;
     lClientDataSet.Free;
     lFormAlarmContentModule.Free;
  end;
end;

procedure TFormAlarmSearch.CheckBoxContentClick(Sender: TObject);
begin
     if CheckBoxContent.Checked then
       begin
          Edit1.Enabled:=True;
          BitBtn2.Enabled:=True;
       end
     else
        begin
          Edit1.Enabled:=False;
          BitBtn2.Enabled:=False;
        end;

        

end;

procedure TFormAlarmSearch.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
   Key:=#0;
end;

procedure TFormAlarmSearch.cxGridFlowDBTableView1CustomDrawCell(
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
