unit Ut_AlarmMonitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls,DBThreeStateTree, StdCtrls, Grids, BaseGrid,
  AdvGrid, Buttons, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxDBLookupComboBox, cxLabel, ImgList, ToolWin, MapXLib_TLB, Ut_Map,
  IniFiles,Ut_FloatInfo, Menus,StrUtils,cxGridExportLink, cxCheckBox, cxSplitter,
  DBClient, cxDropDownEdit, cxDBEdit, cxTextEdit, cxMaskEdit, cxSpinEdit,
  cxContainer, CheckLst, dxtree, dxdbtree;

type
  TFm_AlarmMonitor = class(TForm)
    Panel4: TPanel;
    p_gis: TPanel;
    Tv_MAlarm: TcxGridDBTableView;
    Lv_MAlarm: TcxGridLevel;
    cxGrid: TcxGrid;
    DS_Master: TDataSource;
    DS_Detail: TDataSource;
    v_MAlarmColumn1: TcxGridDBColumn;
    v_MAlarmColumn2: TcxGridDBColumn;
    v_MAlarmColumn3: TcxGridDBColumn;
    v_MAlarmColumn4: TcxGridDBColumn;
    v_MAlarmColumn5: TcxGridDBColumn;
    v_MAlarmColumn6: TcxGridDBColumn;
    v_MAlarmColumn7: TcxGridDBColumn;
    Lv_DAlarm: TcxGridLevel;
    Tv_DAlarm: TcxGridDBTableView;
    v_MAlarmColumn8: TcxGridDBColumn;
    MapBarImageList: TImageList;
    ToolBar1: TToolBar;
    TB_zoomout: TToolButton;
    TB_zoomin: TToolButton;
    TB_pan: TToolButton;
    TB_showinfo: TToolButton;
    TB_locate: TToolButton;
    ToolButton2: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    TB_refresh: TToolButton;
    ToolButton1: TToolButton;
    tb_csShow: TToolButton;
    ToolButton5: TToolButton;
    ToolButton9: TToolButton;
    ToolButton12: TToolButton;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxStyle9: TcxStyle;
    cxStyle10: TcxStyle;
    cxStyle11: TcxStyle;
    cxStyle13: TcxStyle;
    cxGridTableViewStyleSheet1: TcxGridTableViewStyleSheet;
    v_MAlarmColumn9: TcxGridDBColumn;
    v_MAlarmColumn10: TcxGridDBColumn;
    v_MAlarmColumn11: TcxGridDBColumn;
    v_MAlarmColumn12: TcxGridDBColumn;
    v_MAlarmColumn13: TcxGridDBColumn;
    Lv_HMAlarm: TcxGridLevel;
    Tv_HMAlarm: TcxGridDBTableView;
    Lv_HDAlarm: TcxGridLevel;
    Tv_HDAlarm: TcxGridDBTableView;
    v_HMAlarmColumn1: TcxGridDBColumn;
    v_HMAlarmColumn2: TcxGridDBColumn;
    v_HMAlarmColumn3: TcxGridDBColumn;
    v_HMAlarmColumn4: TcxGridDBColumn;
    v_HMAlarmColumn5: TcxGridDBColumn;
    v_HMAlarmColumn6: TcxGridDBColumn;
    v_HMAlarmColumn7: TcxGridDBColumn;
    v_HMAlarmColumn8: TcxGridDBColumn;
    v_HMAlarmColumn9: TcxGridDBColumn;
    v_HMAlarmColumn10: TcxGridDBColumn;
    v_HMAlarmColumn11: TcxGridDBColumn;
    v_HMAlarmColumn12: TcxGridDBColumn;
    v_HMAlarmColumn13: TcxGridDBColumn;
    DS_HMaster: TDataSource;
    DS_HDetail: TDataSource;
    v_MAlarmColumn14: TcxGridDBColumn;
    v_MAlarmColumn15: TcxGridDBColumn;
    v_MAlarmColumn16: TcxGridDBColumn;
    v_HMAlarmColumn14: TcxGridDBColumn;
    v_HMAlarmColumn15: TcxGridDBColumn;
    v_HMAlarmColumn16: TcxGridDBColumn;
    v_HMAlarmColumn17: TcxGridDBColumn;
    v_MAlarmColumn17: TcxGridDBColumn;
    PopupMenu1: TPopupMenu;
    N_Readed: TMenuItem;
    N_Export: TMenuItem;
    PopupMenu2: TPopupMenu;
    N_Exproth: TMenuItem;
    v_MAlarmColumn18: TcxGridDBColumn;
    v_HMAlarmColumn18: TcxGridDBColumn;
    v_MAlarmColumn19: TcxGridDBColumn;
    v_HMAlarmColumn19: TcxGridDBColumn;
    v_MAlarmColumn20: TcxGridDBColumn;
    N1: TMenuItem;
    N_SelectAll: TMenuItem;
    N2: TMenuItem;
    N3_SelectAll: TMenuItem;
    N3_Del: TMenuItem;
    v_HMAlarmColumn20: TcxGridDBColumn;
    N_Shield: TMenuItem;
    N4: TMenuItem;
    N_CancelShield: TMenuItem;
    N3: TMenuItem;
    pShowHisrotyTop: TPanel;
    pShowHistory: TPanel;
    tvHis: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    DSHis: TDataSource;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    btClose: TButton;
    cbShowHistory: TCheckBox;
    seCount: TcxSpinEdit;
    pGrid: TPanel;
    pControl: TPanel;
    Panel5: TPanel;
    cxSplitter2: TcxSplitter;
    Panel6: TPanel;
    cxSplitter1: TcxSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GeoTreeViewCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Tv_MAlarmDataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure TB_zoomoutClick(Sender: TObject);
    procedure TB_zoominClick(Sender: TObject);
    procedure TB_panClick(Sender: TObject);
    procedure TB_showinfoClick(Sender: TObject);
    procedure TB_locateClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure TB_refreshClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure tb_csShowClick(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure MtuMapPolyToolUsed(ASender: TObject; ToolNum: Smallint;
      Flags: Integer; const Points: IDispatch; bShift, bCtrl: WordBool;
      var EnableDefault: WordBool);
    procedure MtuMapToolUsed(ASender: TObject; ToolNum: Smallint; X1, Y1,
      X2, Y2, Distance: Double; Shift, Ctrl: WordBool;
      var EnableDefault: WordBool);
    procedure ToolButton5Click(Sender: TObject);
    //  kind = 0 MTU  ,kind =1 CS
    procedure ShowGisItemInfo(KeyValue:String;Kind :integer=0);
    procedure Tv_HMAlarmDataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure Tv_DAlarmCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure Tv_MAlarmCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure N_ReadedClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N_ExportClick(Sender: TObject);
    procedure Tv_HMAlarmCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure Tv_MAlarmMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Tv_HMAlarmMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N_SelectAllClick(Sender: TObject);
    procedure N3_SelectAllClick(Sender: TObject);
    procedure N3_DelClick(Sender: TObject);
    procedure N_ShieldClick(Sender: TObject);
    procedure N_CancelShieldClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure cbShowHistoryClick(Sender: TObject);
    procedure Tv_MAlarmFocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxSplitter1BeforeClose(Sender: TObject; var AllowClose: Boolean);
    procedure cxSplitter1BeforeOpen(Sender: TObject; var NewSize: Integer;
      var AllowOpen: Boolean);
    procedure cxSplitter2BeforeOpen(Sender: TObject; var NewSize: Integer;
      var AllowOpen: Boolean);
    procedure cxSplitter2BeforeClose(Sender: TObject; var AllowClose: Boolean);
  private
    { Private declarations }
    //浮动窗口信息数组
    FloatField : TFloatArray;
    //Map
    MtuMap: TMap;
    MapObj : TMapObj;
    IsMapSetUp :Boolean;
    LinkTree :TDBThreeStateTree;
    Alarm_ID:Integer;
    Alarm_ID2:Integer;
    MapPath :String;
    ThemeObj : TThemeObj;
    FShieldList : TStringList;
    procedure CreateFeatureLayer(AMap:TMap;FName :String);        
    procedure InitBuildingMap; // 加载室分点地图
    procedure ReloadBuliding(AMap:TMap);
    procedure MapxNotSetUp(bFlag :Boolean=false);
    procedure SearchAndDisplayBulid(BuildNo:String);
    procedure AddToShield(aKeyid :integer;aList :TStringList);
    procedure SetAllSelected(aKeyColIndex :integer;aView : TcxGridDBTableView;aB : Boolean);

    procedure ShowHistoryAlarms;
  public
    { Public declarations }
    LayEyeObj : TMapEye;
    gCondition :String;
    gAlarmKindCondition :String;
    procedure ShowTheMtuAlarm(mtuno:string);
    procedure ShowAlarm_Online;
    procedure ShowAlarm_History;
  end;

var
  Fm_AlarmMonitor: TFm_AlarmMonitor;

implementation
uses Ut_MainForm,Ut_DataModule,Ut_Common,Ut_MTSTreeHelper, UntDBFunc;
{$R *.dfm}

procedure TFm_AlarmMonitor.FormCreate(Sender: TObject);
var
  i : Integer;
begin
  FShieldList := TStringList.Create;

  DS_Master.DataSet:=Dm_Mts.cds_Master;//告警主表
  DS_HMaster.DataSet:=Dm_Mts.cds_HMaster;//历史告警主表

  Fm_FloatInfo := TFm_FloatInfo.Create(Application);  //创建浮动窗体
  with Fm_FloatInfo do
  begin
    Parent := self;
    Visible := false;
  end;

  IsMapSetup:=True ; // 默认已安装MapX
  //动态创建Map对象
  Try
    //MTU Map
    MtuMap :=TMap.Create(Application);
    MtuMap.OnPolyToolUsed:=MtuMapPolyToolUsed;
    MtuMap.OnToolUsed := MtuMapToolUsed;
    MtuMap.Parent:= p_gis ;
    MtuMap.Align :=alClient;
    MtuMap.CreateCustomTool(MTUINFO, miToolTypePoint,miArrowQuestionCursor,EmptyParam, EmptyParam, EmptyParam);
    MtuMap.CreateCustomTool(CSINFO, miToolTypePoint,miArrowQuestionCursor,EmptyParam, EmptyParam, EmptyParam);
    MtuMap.CreateCustomTool(MTUALARM, miToolTypePoint,miArrowQuestionCursor,EmptyParam, EmptyParam, EmptyParam);
    MtuMap.CreateCustomTool(DistInfo, miToolTypeLine,microssCursor,EmptyParam, EmptyParam, EmptyParam);
    MtuMap.CreateCustomTool(CSConnect, miToolTypePoint,miSizeAllCursor,EmptyParam, EmptyParam, EmptyParam);
    MtuMap.CreateCustomTool(AreaInfo, miToolTypePolygon,miRegionSelectCursor,EmptyParam, EmptyParam, EmptyParam);
  Except
    MessageBox(Handle, '未安装MapX无法使用GIS功能!', '信息', MB_OK + MB_ICONINFORMATION);
    IsMapSetup:=false ;
  end;

  with Dm_Mts.cds_Detail do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,21,0]),0);
  end;
  AddGridFields(Tv_DAlarm, Dm_Mts.cds_Detail, '告警ID,任务ID,MTUID,设备编号,命令名称,测试参数,结果序号,测试结果值,采集时间,执行序号,是否已处理,所属地市');
  Tv_DAlarm.GetColumnByFieldName('alarmid').Visible:=false;
  Tv_DAlarm.GetColumnByFieldName('taskid').Visible:=false;
  Tv_DAlarm.GetColumnByFieldName('MTUID').Visible:=false;
  Tv_DAlarm.GetColumnByFieldName('comid').Visible:=false;
  Tv_DAlarm.GetColumnByFieldName('paramid').Visible:=false;
  Tv_DAlarm.GetColumnByFieldName('cityid').Visible:=false;
  DS_Detail.DataSet:=Dm_Mts.cds_Detail;//告警从表
//  for I := 0 to Tv_DAlarm.ColumnCount-1 do
//     Tv_DAlarm.Columns[i].Width := Tv_DAlarm.Columns[i].BestFitMaxWidth;
  Tv_DAlarm.ApplyBestFit();


  with Dm_Mts.cds_HDetail do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,22,0]),0);
  end;
  AddGridFields(Tv_HDAlarm, Dm_Mts.cds_HDetail, '告警ID,任务ID,MTUID,设备编号,命令名称,测试参数,结果序号,测试结果值,采集时间,执行序号,是否已处理,所属地市');
  Tv_HDAlarm.GetColumnByFieldName('alarmid').Visible:=false;
  Tv_HDAlarm.GetColumnByFieldName('taskid').Visible:=false;
  Tv_HDAlarm.GetColumnByFieldName('MTUID').Visible:=false;
  Tv_HDAlarm.GetColumnByFieldName('comid').Visible:=false;
  Tv_HDAlarm.GetColumnByFieldName('paramid').Visible:=false;
  Tv_HDAlarm.GetColumnByFieldName('cityid').Visible:=false;
  DS_HDetail.DataSet:=Dm_Mts.cds_HDetail;//历史告警从表
  Tv_HDAlarm.ApplyBestFit();

  with Dm_Mts.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,23,0,1]),0);
  end;
  AddGridFields(tvHis, Dm_Mts.cds_common, 'MTUID,告警内容,告警类型,告警等级,派障时间,排障时间,MTU名称,MTU设备编号');
  tvHis.GetColumnByFieldName('MTUID').Visible:=false;
  DSHis.DataSet:=Dm_Mts.cds_common;//历史告警从表
  tvHis.ApplyBestFit();
  cbShowHistoryClick(self);
end;


procedure TFm_AlarmMonitor.AddToShield(aKeyid: integer; aList: TStringList);
begin
  aList.Add(inttostr(aKeyid));
end;

procedure TFm_AlarmMonitor.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFm_AlarmMonitor.cbShowHistoryClick(Sender: TObject);
begin
  pShowHistory.Visible := cbShowHistory.Checked;
  if pShowHistory.Visible then
  begin
    pShowHisrotyTop.Height := 146;
    ShowHistoryAlarms;
  end
  else
  begin
    pShowHisrotyTop.Height := 35;
  end;
end;

procedure TFm_AlarmMonitor.CreateFeatureLayer(AMap: TMap; FName: String);
var
  i:integer;
  Layer: CMapXLayer;
  temstr :String;
begin
  //首先Remove 基站图层 刷新时用到
  For i := AMap.Layers.Count downto 1  do
  begin
    temstr :=  AMap.Layers.Item[i].Name;
    if temstr = FName then
     AMap.Layers.Remove(i);
  end;
  Layer :=AMap.Layers.CreateLayer(FName,'',2,EmptyParam,EmptyParam);
end;    

procedure TFm_AlarmMonitor.cxSplitter1BeforeClose(Sender: TObject;
  var AllowClose: Boolean);
begin
  pControl.Align := alTop;
  pControl.Parent := pGrid;
  p_Gis.Align := alTop;
  pGrid.Align := alClient; 
  cxSplitter2.Visible := false;
end;

procedure TFm_AlarmMonitor.cxSplitter1BeforeOpen(Sender: TObject;
  var NewSize: Integer; var AllowOpen: Boolean);
begin
  {pControl.Align := alTop;
  pControl.Parent := pGrid;
  pGrid.Align := alClient;
  p_Gis.Align := alTop; }
  cxSplitter2.Visible := true;
end;

procedure TFm_AlarmMonitor.cxSplitter2BeforeClose(Sender: TObject;
  var AllowClose: Boolean);
begin
  pControl.Align := alBottom;
  pControl.Parent := p_Gis;
  pGrid.Align := alBottom;
  p_Gis.Align := alClient; 
  cxSplitter1.Visible := false;
end;

procedure TFm_AlarmMonitor.cxSplitter2BeforeOpen(Sender: TObject;
  var NewSize: Integer; var AllowOpen: Boolean);
begin
  cxSplitter1.Visible := true;
end;

procedure TFm_AlarmMonitor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FShieldList.Free;
  Freeandnil(MtuMap);
  Freeandnil(LinkTree);
  Dm_Mts.cds_Master.Close;
  Dm_Mts.cds_Detail.Close;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Fm_AlarmMonitor:=nil;  
end;

procedure TFm_AlarmMonitor.FormShow(Sender: TObject);
begin
  //是否安装了MapX 
  if IsMapSetUp then
  begin
    InitBuildingMap;
  end
  else
  begin
    MapxNotSetUp;
  end;
  self.ShowAlarm_Online;
  self.ShowAlarm_History;

end;

procedure TFm_AlarmMonitor.GeoTreeViewCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (Node.Data <> nil) and TNodeParam(Node.Data).IsDraw  then   //根据结点的内容进行判断
  begin
    DefaultDraw:=True   ;
    Sender.Canvas.Font.Color:=clRed;
    Sender.Canvas.Textout(Node.DisplayRect(True).Left+2,Node.DisplayRect(True).Top+2,Node.Text);
  end;
end;

procedure TFm_AlarmMonitor.InitBuildingMap;
var
  sqlstr :String;
begin
  MtuMap.Title.Visible := false;
  //路径
  MapPath := ExtractFileDir(Application.ExeName)+'\GIS';
  if not DirectoryExists(MapPath) then
    MKdir(MapPath);
  //初始化地图
  MapObj := TMapObj.Create(MtuMap);
  ThemeObj := TThemeObj.Create(MtuMap);
  MtuMap.Datasets.RemoveAll;
  //加载告警室分点图层
  ReloadBuliding(MtuMap);
  //测距图层
  CreateFeatureLayer(MtuMap,'Line');
  MapObj.ImportDefaultMap;
end;

procedure TFm_AlarmMonitor.MapxNotSetUp(bFlag: Boolean);
begin
  //sp_gis.Visible := bFlag;
  p_gis.Visible  := bFlag;
end;

procedure TFm_AlarmMonitor.MtuMapPolyToolUsed(ASender: TObject;
  ToolNum: Smallint; Flags: Integer; const Points: IDispatch; bShift,
  bCtrl: WordBool; var EnableDefault: WordBool);
var
  Lyr : CMapXLayer;
  ft : CMapXFeature;
  fts : CMapXFeatures;
  Area : Real;
begin
  case ToolNum of
  AreaInfo :
    begin
      case Flags of
        miPolyToolEnd :
          begin
            lyr := MtuMap.Layers.Item['csinfo'];
            lyr.Selection.ClearSelection;
            ft := MtuMap.FeatureFactory.CreateRegion(Points,EmptyParam);
            ft.Style.RegionBorderColor := clBlue;
            ft.Style.RegionPattern := 0;
            MtuMap.Layers.Item['line'].AddFeature(ft,EmptyParam);
            area := ft.Area;
            fts := lyr.SearchWithinFeature(ft,miSearchTypeCentroidWithin);
            SetLength(FloatField,3);
            FloatField[0].Field :='面积';
            FloatField[0].Value :=Format('%.6s',[FloatToStr(area)])+'平方公里';
            FloatField[1].Field :='室分点数目';
            FloatField[1].Value := IntToStr(fts.Count);
            FloatField[2].Field :='室分点密度';
            FloatField[2].Value :=Format('%.2f',[fts.Count/area])+'个/每平方公里';
            Fm_FloatInfo.SetFloatInfo(FloatField);
          end;
      end;
    end;
  end;
end;

procedure TFm_AlarmMonitor.MtuMapToolUsed(ASender: TObject; ToolNum: Smallint;
  X1, Y1, X2, Y2, Distance: Double; Shift, Ctrl: WordBool;
  var EnableDefault: WordBool);
var
  LineStyle : CMapXStyle;
  lyr : CMapXLayer;
  pt,lpt : CMapXPoint;
  pts : CMapXPoints;
  fts : CMapXFeatures;
  ft : CMapXFeature;
  sqlstr :String;
begin
try
  case ToolNum of
    MTUINFO : //获取MTUINFO
      begin
        Fm_FloatInfo.VL.Strings.Clear;
        pt := CoPoint.Create;
        pt.Set_(X2,Y2);
        Lyr := MtuMap.Layers.Item['csinfo'];
        if Lyr = nil then Exit;
        fts := lyr.SearchAtPoint(pt,1);
        if fts.Count > 0 then
          ShowGisItemInfo(Fts.Item[1].KeyValue);
      end;
    MTUALARM : //获取MTU历史告警
      begin
        Fm_FloatInfo.VL.Strings.Clear;
        pt := CoPoint.Create;
        pt.Set_(X2,Y2);
        Lyr := MtuMap.Layers.Item['csinfo'];
        if Lyr = nil then Exit;
        fts := lyr.SearchAtPoint(pt,1);
        if fts.Count > 0 then
        begin

          ShowTheMtuAlarm(Fts.Item[1].KeyValue);
          //ShowAlarmOnHistory(' and to_char(sendtime,''YYYY-MM-DD'')<=to_char(sysdate,''YYYY-MM-DD'') and to_char(sendtime,''YYYY-MM-DD'')>=to_char(sysdate-'+IntToStr(AlarmShowDay)+',''YYYY-MM-DD'') and mtuno='+Fts.Item(1).KeyValue,true);
          //Fm_Main_Client.Status.Panels[0].Text :='MTU告警数: '+INtToStr(TvHistory.DataController.DataSource.DataSet.recordcount);
        end;
      end;
    {CSINFO : //获取MTUINFO
      begin
        Fm_FloatInfo.VL.Strings.Clear;
        pt := CoPoint.Create;
        pt.Set_(X2,Y2);
        Lyr := MtuMap.Layers.Item('csinfo');
        if Lyr = nil then Exit;
        fts := lyr.SearchAtPoint(pt);
        if fts.Count > 0 then
          ShowGisItemInfo(Fts.Item(1).KeyValue,1);
      end; }
    DistInfo :
      begin
        if (X1<>X2) or (Y1<>Y2) then
          begin
            pts := coPoints.Create;
            Lyr := MtuMap.Layers.Item['Line'];
            pt := coPoint.Create;
            pt.Set_(X1,Y1);
            pts.Add(pt,1);
            pt.Set_(X2,Y2);
            pts.Add(pt,2);
            LineStyle := coStyle.Create;
            LineStyle.LineStyle := 1;
            LineStyle.LineWidth := 1;
            LineStyle.LineColor := clBlue;
            ft := MtuMap.FeatureFactory.CreateLine(pts,LineStyle);
            lyr.AddFeature(ft,EmptyParam);
            SetLength(FloatField,1);
            FloatField[0].Field :='两点距离';
            FloatField[0].Value :=Format('%.4f',[Distance/1000])+'公里';
            Fm_FloatInfo.SetFloatInfo(FloatField);
          end;
      end;
   { CSConnect :
      begin
        //找到MTU
        pt := CoPoint.Create;
        pt.Set_(X2,Y2);
        Lyr := MtuMap.Layers.Item('mtuinfo');
        if Lyr = nil then Exit;
        fts := lyr.SearchAtPoint(pt);
        if fts.Count > 0 then
        begin
          pt :=Fts.Item(1).Point;
          fts := lyr.SearchAtPoint(pt);
          sqlstr :=' select a.rssi,a.icsid, c.nodeaddress, c.longitude,c.latitude from mtu_rssiinfo  a'+
                   ' inner join mtuinfo b on a.mtuid=b.mtuid'+
                   ' inner join alarm_cs_detail_view c on a.icsid=c.icsid'+
                   ' where (c.longitude is not null and c.latitude is not null) and b.mtuno = '+Fts.Item(1).KeyValue ;
          with Dm_NetControl.Cds_Dynamic do
          begin
            Close;
            CommandText := sqlstr;
            Open;
            if RecordCount > 0 then
            begin
              first;
              while not Eof do
              begin
                pts := coPoints.Create;
                lpt := coPoint.Create;
                lpt.Set_(FieldByName('longitude').AsFloat,FieldByName('latitude').AsFloat);
                pts.Add(pt,1);
                pts.Add(lpt,2);
                LineStyle := coStyle.Create;
                LineStyle.LineStyle := 1;
                LineStyle.LineWidth := 1;
                LineStyle.LineColor := GetRssiLineColor(FieldByName('rssi').AsFloat);
                Lyr := MtuMap.Layers.Item('RssiLine');
                ft := MtuMap.FeatureFactory.CreateLine(pts,LineStyle);
                lyr.AddFeature(ft,EmptyParam);
                Next;
              end;
            end
            else
            begin
              Application.MessageBox('没有找到对此MTU发送场强的基站或者基站经纬度缺失!','提示',mb_ok+mb_defbutton1);
            end;
            Close;
          end;
        end;
      end;}
  end;
except
  Application.MessageBox('图层缺失!','提示',mb_ok+mb_defbutton1);
end;
end;

procedure TFm_AlarmMonitor.N_ShieldClick(Sender: TObject);
var
  lFilterStr :String;
  I : integer;
  lKeyid : integer;
  lIsChecked_Index ,lalarmid_Index : integer;
begin
  try
    lIsChecked_Index := Tv_MAlarm.GetColumnByFieldName('isChecked').Index;
    lalarmid_Index := Tv_MAlarm.GetColumnByFieldName('alarmid').Index;
  except
    lIsChecked_Index := -1;
    lalarmid_Index := -1;
  end;
  if (lIsChecked_Index=-1) or (lalarmid_Index=-1) then  Exit;
  for I := 0 to Tv_MAlarm.DataController.RecordCount - 1 do
  begin
    if Tv_MAlarm.DataController.GetValue(I,lIsChecked_Index)='Y' then
    begin
      lKeyid := Integer(Tv_MAlarm.DataController.GetValue(I,lalarmid_Index));
      AddToShield(lKeyid,FShieldList);
    end;
  end;

  FShieldList.Delimiter := ',';
  lFilterStr := FShieldList.DelimitedText;
  if lFilterStr = '' then
    lFilterStr := '-1';
  try
    Tv_MAlarm.DataController.DataSource.DataSet.Filtered := false;
    Tv_MAlarm.DataController.DataSource.DataSet.Filter := 'not alarmid  in ('+lFilterStr+')';
    Tv_MAlarm.DataController.DataSource.DataSet.Filtered := True;
  except

  end;
end;

procedure TFm_AlarmMonitor.N3_DelClick(Sender: TObject);
var
  I : integer;
  iSel :integer;
  AlarmIdStr :String;
  TheSQL: Variant;
  lIsChecked_Index,lalarmid_Index : integer;
begin
  AlarmIdStr := '';
  try
    lIsChecked_Index := Tv_HMAlarm.GetColumnByFieldName('isChecked').Index;
    lalarmid_Index := Tv_MAlarm.GetColumnByFieldName('alarmid').Index;
  except
    lIsChecked_Index := -1;
    lalarmid_Index := -1;
  end;
  if (lIsChecked_Index=-1) or (lalarmid_Index=-1) then  Exit;
  for I := 0 to Tv_HMAlarm.DataController.RecordCount - 1 do
  begin
    if Tv_HMAlarm.DataController.GetValue(I,lIsChecked_Index)='Y' then
      AlarmIdStr := AlarmIdStr+String(Tv_HMAlarm.DataController.GetValue(I,lalarmid_Index))+',';
  end;

  if length(AlarmIdStr)=0 then Exit;
  AlarmIdStr :=leftstr(AlarmIdStr,length(AlarmIdStr)-1);
  TheSQL := VarArrayCreate([0,0], varVariant);
  TheSQL[0]:=VarArrayOf([2,1,69,AlarmIdStr]);
  if not ExecTheSQL(TheSQL) then
  Begin
     application.MessageBox('删除历史告警失败！', '提示', mb_ok + mb_defbutton1);
     Exit;
  end else
    ShowAlarm_History;
end;

procedure TFm_AlarmMonitor.N3_SelectAllClick(Sender: TObject);
var
  I: Integer;
  lKeyindex : integer;
begin
  {with Tv_HMAlarm.DataController.DataSource.DataSet do
  begin
    if not Active then Exit;
    First;
    Tv_HMAlarm.DataController.BeginUpdateFields;
    try
      for I := 0 to RecordCount - 1 do
      begin
        if FieldByName('isChecked').AsString = 'N' then
        begin
          Edit;
          FieldByName('isChecked').AsString := 'Y';
        end;
        Next;
      end;
    finally
      Tv_HMAlarm.DataController.EndUpdateFields;
    end;
  end;}
  try
    lKeyindex := Tv_HMAlarm.GetColumnByFieldName('isChecked').Index;
  except
    lKeyindex := -1;
  end;
  if lKeyindex=-1 then exit;
  self.SetAllSelected(lKeyindex,Tv_HMAlarm,True);
end;

procedure TFm_AlarmMonitor.N_CancelShieldClick(Sender: TObject);
var
  lKeyindex :integer;
begin
  try
    lKeyindex := Tv_MAlarm.GetColumnByFieldName('isChecked').Index;
  except
    lKeyindex := -1;
  end;
  if lKeyindex=-1 then exit;

  try
    Tv_MAlarm.DataController.DataSource.DataSet.Filtered := false;
    self.SetAllSelected(lKeyindex,Tv_MAlarm,false);
    FShieldList.Clear;
  except

  end;
end;

procedure TFm_AlarmMonitor.N_ExportClick(Sender: TObject);
var
  ASaveDialog: TSaveDialog;
  tofileName: string;
begin
  ASaveDialog := TSaveDialog.Create(nil);
  try
    ASaveDialog.Title := '保存文件';
    ASaveDialog.Filter := 'Microsof Excel (*.xls)|*.xls';
    if ASaveDialog.Execute then
    begin
        tofileName := ASaveDialog.FileName;
        if pos(uppercase('.xls'), uppercase(tofileName)) = 0 then
            tofileName := tofileName + '.xls';
        if Fileexists(tofileName) then
        begin
            if application.MessageBox('文件已存在，确认覆盖?', '提示', mb_okcancel + mb_defbutton1) = idok then
            begin
                Deletefile(pchar(tofileName));
                ExportGridToEXCEL(tofileName,cxGrid,true,true); //保存
            end;
        end
        else
        begin
            ExportGridToEXCEL(tofileName,cxGrid,true,true); //保存
        end;
    end;
  finally
    FreeAndNil(ASaveDialog);
  end;
end;
procedure TFm_AlarmMonitor.N_ReadedClick(Sender: TObject);
var
  iSel :integer;
  AlarmIdStr :String;
  TheSQL: Variant;
  I: Integer;
  lIsChecked_Index, lalarmid_Index : integer;
begin
  AlarmIdStr :='';
  AlarmIdStr := '';
  try
    lIsChecked_Index := Tv_MAlarm.GetColumnByFieldName('isChecked').Index;
    lalarmid_Index := Tv_MAlarm.GetColumnByFieldName('alarmid').Index;
  except
    lIsChecked_Index := -1;
    lalarmid_Index := -1;
  end;
  if (lIsChecked_Index=-1) or (lalarmid_Index=-1) then  Exit;
  for I := 0 to Tv_MAlarm.DataController.RecordCount - 1 do
  begin
    if Tv_MAlarm.DataController.GetValue(I,lIsChecked_Index)='Y' then
      AlarmIdStr := AlarmIdStr+String(Tv_MAlarm.DataController.GetValue(I,lalarmid_Index))+',';
  end;

  {Tv_MAlarm.DataController.DataSource.DataSet.First;
  for I := 0 to Tv_MAlarm.DataController.RecordCount - 1 do
  begin
    if Tv_MAlarm.DataController.DataSource.DataSet.FieldByName('isChecked').AsString = 'Y' then
    begin
      AlarmIdStr := AlarmIdStr+Tv_MAlarm.DataController.DataSet.FieldByName('alarmid').AsString+',';
    end;
    Tv_MAlarm.DataController.DataSource.DataSet.Next;
  end;}
  if length(AlarmIdStr)=0 then Exit;
  AlarmIdStr :=leftstr(AlarmIdStr,length(AlarmIdStr)-1);
  TheSQL := VarArrayCreate([0,0], varVariant);
  TheSQL[0]:=VarArrayOf([2,1,52,AlarmIdStr]);
  if not ExecTheSQL(TheSQL) then
  Begin
     application.MessageBox('更新阅读标识失败！', '提示', mb_ok + mb_defbutton1);
     Exit;
  end else
    self.ShowAlarm_Online;
end;

procedure TFm_AlarmMonitor.N_SelectAllClick(Sender: TObject);
var
  I: Integer;
  lKeyindex : integer;
begin
  try
    lKeyindex := Tv_MAlarm.GetColumnByFieldName('isChecked').Index;
  except
    lKeyindex := -1;
  end;
  if lKeyindex=-1 then exit;
  self.SetAllSelected(lKeyindex,Tv_MAlarm,True);
end;

procedure TFm_AlarmMonitor.PopupMenu1Popup(Sender: TObject);
begin
  with Tv_MAlarm.DataController.DataSet do
  begin
    if Active and (FieldByName('readed').AsInteger=0) then
      N_Readed.Enabled := true
    else
      N_Readed.Enabled := false;
  end;

end;

procedure TFm_AlarmMonitor.ReloadBuliding(AMap: TMap);
var
  lIndex,i:integer;
  CSArray: Variant;
  BindLayerObject: CMapXBindLayer;
  ThemesFlds : CMapXFields;
  MainDS : CMapXDataset;
  CSStyle : CMapXStyle;
  Lyr : CMapXLayer;
begin
  //首先Remove 基站图层 刷新时用到
  For i := 1 to AMap.Layers.Count do
     AMap.Layers.Remove(1);
  //添加默认图层
  MapObj.ImportCmmMap(MapPath,1);  //20070111
  //根据数据集来生成基站数组
  With Dm_Mts.cds_Map do
  try
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,42]),0);

    If isEmpty Then Exit;
    lIndex:= RecordCount;
    CSArray :=Null;
    //数据信息存入数组
    CSArray := VarArrayCreate([1,lIndex, 1, 3], varVariant);
    First;
    i:= 1 ;
    while Not Eof Do
    begin
      CSArray[i,1] := fieldByName('buildingname').Value; // 室分点名称
      CSArray[i,2] := fieldByName('Longitude').Value; // 经度
      CSArray[i,3] := fieldByName('Latitude').Value;  // 纬度
      Inc(i);
      next;
    end;
  Except
    MessageBox(Handle, '获取室分点数据失败!', '信息', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  AMap.Datasets.RemoveAll;
  BindLayerObject := CoBindLayer.Create;
  BindLayerObject.LayerName := 'csinfo';
  BindLayerObject.RefColumn1 := 2; //指定经纬度
  BindLayerObject.RefColumn2 := 3;
  
  if FileExists(ExtractFilePath(Application.ExeName)+'GIS\Layers\csinfo.tab') then
    DeleteFile(ExtractFilePath(Application.ExeName)+'GIS\Layers\csinfo.tab');
  BindLayerObject.Filespec := ExtractFilePath(Application.ExeName)+'GIS\Layers\csinfo.tab';
  BindLayerObject.LayerType := miBindLayerTypeXY;
  ThemesFlds := CoFields.Create;
  ThemesFlds.Add(1,'buildingname',miAggregationIndividual,miTypeString); //  Survey_ID
  ThemesFlds.Add(2,'Longitude',miAggregationIndividual,miTypeNumeric);
  ThemesFlds.Add(3,'Latitude',miAggregationIndividual,miTypeNumeric);
  //邦定数据
  MainDS:=AMap.Datasets.Add(miDataSetSafeArray,CSArray,'CSDataSet',1,EmptyParam,BindLayerObject,ThemesFlds,EmptyParam);

  AMap.Bounds :=AMap.Layers.Bounds;

  CSStyle := coStyle.Create;
  CSStyle.SymbolType := 1;
  CSStyle.SymbolBitmapTransparent := True;
  CSStyle.SymbolBitmapName := 'HOUS1-32.bmp';
  CSStyle.SymbolBitmapSize := 14;
  lyr := Amap.Layers.Item[1];
  lyr.OverrideStyle := true;
  lyr.Style :=csstyle.Clone;
end;

procedure TFm_AlarmMonitor.SearchAndDisplayBulid(BuildNo: String);
var
  i:integer;
  Longtitude,Latitude :string;
  Alongtitude,ALatitude : Double;
  pt :CMapXPoint;
begin
  With Dm_Mts.cds_Map do
  begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,43,BuildNo]),0);

    if RecordCount>0 then
      begin
        for i := 0 to RecordCount-1 do
        begin
          longtitude := fieldbyname('longitude').AsString;
          latitude := fieldbyname('latitude').AsString;
          if (longtitude='') or (latitude='')then
            begin
              Application.MessageBox('没有该室分点经纬度!','提示',mb_ok+mb_defbutton1);
              Exit;
            end
          else
            begin
              MtuMap.Layers.Item['csinfo'].Selection.ClearSelection;
              Alongtitude := StrToFloat(Longtitude);
              ALatitude := StrToFloat(Latitude);
              pt := CoPoint.Create;
              pt.Set_(Alongtitude,ALatitude);
              MtuMap.Layers.Item['csinfo'].Selection.SelectByPoint(pt.X,pt.Y,miSelectionAppend,1);
              MtuMap.CenterX :=pt.X;
              MtuMap.CenterY :=pt.Y;
            end;
        end;
      end
    else
      begin
        Application.MessageBox('没有该室分点信息!','提示',mb_ok+mb_defbutton1);
        Exit;
      end;
  end;
end;

procedure TFm_AlarmMonitor.SetAllSelected(aKeyColIndex :integer;aView: TcxGridDBTableView; aB: Boolean);
var
  I: Integer;
begin
  for I := 0 to aView.DataController.RecordCount - 1 do
  begin
    if aB then
    begin
      if aView.DataController.GetValue(I,aKeyColIndex)='N' then
        aView.DataController.SetValue(I,aKeyColIndex,'Y');
    end else
    begin
      if aView.DataController.GetValue(I,aKeyColIndex)='Y' then
        aView.DataController.SetValue(I,aKeyColIndex,'N');
    end;
  end;
end;

procedure TFm_AlarmMonitor.ShowAlarm_Online;
begin
  with Dm_Mts.cds_Master do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,2,1,gCondition+gAlarmKindCondition]),0);
  end;
  Tv_MAlarm.ApplyBestFit();
end;

procedure TFm_AlarmMonitor.ShowAlarm_History;
begin
  with Dm_Mts.cds_HMaster do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,2,2,gCondition+gAlarmKindCondition]),0);
  end;
  Tv_HMAlarm.ApplyBestFit();
end;

procedure TFm_AlarmMonitor.ShowGisItemInfo(KeyValue: String; Kind: integer);
var
  i :integer;
begin
  with Dm_Mts.cds_common1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    case Kind of
       0 : Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,45,KeyValue]),0);
    else
       Exit;
    end;

    if RecordCount > 0 then
    begin
      SetLength(FloatField,FieldDefs.Count);
      for i := 0 to FieldDefs.Count-1 do
      begin
        FloatField[i].Field :=FieldDefs.Items[i].Name;
        FloatField[i].Value := Fields[i].AsString;
      end;
      Fm_FloatInfo.SetFloatInfo(FloatField);
      //Fm_FloatInfo.Visible := true;
    end;
    close;
  end;
end;

procedure TFm_AlarmMonitor.ShowHistoryAlarms;
begin
  if cbShowHistory.Checked then
  begin  
    with Dm_Mts.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,23,Dm_Mts.cds_Master.FieldByName('MTUID').AsInteger, seCount.Value]),0);
    end;
    tvHis.ApplyBestFit();
    end;
end;

procedure TFm_AlarmMonitor.ShowTheMtuAlarm(mtuno: string);
Var
  n:integer;
  lastNday:string; //最近N天
begin
  lastNday:='';
  cxGrid.ActiveLevel:=Lv_MAlarm;      //在线告警
  with Dm_Mts.cds_Master do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,57,mtuno]),0);
  end;
  Tv_MAlarm.ApplyBestFit();

  cxGrid.ActiveLevel:=Lv_HMAlarm;      //历史告警
  n:=Fm_MainForm.PublicParam.AlarmShowDay;
  lastNday:=' and to_char(SendTime+'+inttostr(n)+','+' ''YYYY-MM-DD'')>= '+Quotedstr(FormatDateTime('YYYY-MM-DD',now));
  with Dm_Mts.cds_HMaster do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,46,mtuno,lastNday]),0);
  end;
  Tv_HMAlarm.ApplyBestFit();
end;

procedure TFm_AlarmMonitor.tb_csShowClick(Sender: TObject);
var
  temlyr :CMapxLayer;
begin
  if TButton(Sender).Tag = 0 then
  begin
    try
      temlyr :=mtumap.Layers.Item['csinfo'];
      temlyr.Visible := false;
      TButton(Sender).Tag :=1;
      TButton(Sender).Hint :='显示室分点';
    except
      Application.MessageBox('室分点图层缺失!!','提示',mb_ok+mb_defbutton1);
    end;
  end
  else
  begin
    try
      temlyr :=mtumap.Layers.Item['csinfo'];
      temlyr.Visible := true;
      TButton(Sender).Tag :=0;
      TButton(Sender).Hint :='隐藏室分点';
    except
      Application.MessageBox('室分点图层缺失!!','提示',mb_ok+mb_defbutton1);
    end;
  end;
end;

procedure TFm_AlarmMonitor.TB_locateClick(Sender: TObject);
var
  BuildNo :String;
begin
  if not InPutQuery('查询','请输入室分点名称',BuildNo) then Exit;
  if BuildNo = '' then
  begin
    Application.MessageBox('请输入室分点名称!','提示',mb_ok+mb_defbutton1);
    Exit;
  end;
  SearchAndDisplayBulid(BuildNo);
end;

procedure TFm_AlarmMonitor.TB_panClick(Sender: TObject);
begin
  mtumap.CurrentTool :=mipantool;
end;

procedure TFm_AlarmMonitor.TB_refreshClick(Sender: TObject);
begin
  mtumap.CurrentTool :=AreaInfo;
end;

procedure TFm_AlarmMonitor.TB_showinfoClick(Sender: TObject);
var
  i : integer;
begin
  if TButton(Sender).Tag = 0 then
  begin
    for i := MtuMap.Layers.Count downto 1 do
      MtuMap.Layers.Item[i].AutoLabel := true;
    TButton(Sender).Tag :=1;
    TButton(Sender).Hint :='隐藏信息';
  end
  else
  begin
    for i := MtuMap.Layers.Count downto 1 do
      MtuMap.Layers.Item[i].AutoLabel := false;
    TButton(Sender).Tag :=0;
    TButton(Sender).Hint :='显示信息';
  end;
end;

procedure TFm_AlarmMonitor.TB_zoominClick(Sender: TObject);
begin
  mtumap.CurrentTool :=mizoomouttool;
end;

procedure TFm_AlarmMonitor.TB_zoomoutClick(Sender: TObject);
begin
  mtumap.CurrentTool :=mizoomintool;
end;

procedure TFm_AlarmMonitor.ToolButton11Click(Sender: TObject);
begin
  //ThemeObj.RemoveTheme('MtuAlarm');
end;

procedure TFm_AlarmMonitor.ToolButton12Click(Sender: TObject);
var
  Path : string;
  MapIni : TIniFile;
begin
  //--------------------- 保存的默认值在本地目录下面  ，模板名字为MAP.txt
  Path :=ExtractFilePath(Application.ExeName)+'GIS';
  if not DirectoryExists(path) then
    MkDir(path);
  path :=path+'\MAP.ini ';
  if  FileExists(Path) then //存在先删除
  begin
    DeleteFile(path);
  end;
  MapIni :=TIniFile.Create(path); //---重新创建 Map.ini 文件
  try
    //--最后要把当前的视距保存 地图的中心点和bounds;
    MapIni.WriteFloat('Center','CenterX',MtuMap.CenterX);
    MapIni.WriteFloat('Center','CenterY',MtuMap.CenterY);
    MapIni.WriteFloat('Bounds','XMin',MtuMap.Bounds.XMin);
    MapIni.WriteFloat('Bounds','XMax',MtuMap.Bounds.XMax);
    MapIni.WriteFloat('Bounds','YMin',MtuMap.Bounds.YMin);
    MapIni.WriteFloat('Bounds','YMax',MtuMap.Bounds.YMax);

    MessageDlg('保存完毕!',mtInformation,[mbok],0);
  finally
    MapIni.Free;
  end;
end;

procedure TFm_AlarmMonitor.ToolButton1Click(Sender: TObject);
var
  temlyr :CMapxLayer;
begin
  try
    temlyr :=mtumap.Layers.Item['csinfo'];
    temlyr.OverrideStyle := true;
    temlyr.Style.PickSymbol;
  except
      Application.MessageBox('室分点图层缺失!!','提示',mb_ok+mb_defbutton1);
  end;
end;

procedure TFm_AlarmMonitor.ToolButton2Click(Sender: TObject);
begin
  mtumap.Layers.LayersDlg(emptyParam,EmptyParam);
end;

procedure TFm_AlarmMonitor.ToolButton3Click(Sender: TObject);
var
  temlyr :CMapxLayer;
  i : integer;
begin
  temlyr :=mtumap.Layers.Item['Line'];
  if temlyr <> nil then
  for i := temlyr.AllFeatures.Count downto 1 do
    temlyr.DeleteFeature(temlyr.AllFeatures.Item[i]);
end;

procedure TFm_AlarmMonitor.ToolButton4Click(Sender: TObject);
var
  temlyr :CMapxLayer;
begin
  try
    temlyr :=mtumap.Layers.Item['mtuinfo'];
    temlyr.Style.PickSymbol;
  except
      Application.MessageBox('MTU图层缺失!!','提示',mb_ok+mb_defbutton1);
  end;
end;

procedure TFm_AlarmMonitor.ToolButton5Click(Sender: TObject);
begin
  MtuMap.CurrentTool := MTUINFO;
end;

procedure TFm_AlarmMonitor.ToolButton6Click(Sender: TObject);
begin
  MtuMap.CurrentTool := DistInfo;
end;

procedure TFm_AlarmMonitor.ToolButton9Click(Sender: TObject);
begin
  MtuMap.CurrentTool := MTUALARM;
end;

procedure TFm_AlarmMonitor.Tv_DAlarmCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin

end;
{
var
  index1 :integer;
begin
  index1 := Tv_MAlarm.GetColumnByFieldName('readed').Index;
  Tv_MAlarm.ViewInfo.GridVie
  if index1 >= 0 then
  case Tv_MAlarm.ViewInfo.GridRecord.Values[index1] of
   1 : ACanvas.Font.Color := $004080FF;
  end;
end;
}

procedure TFm_AlarmMonitor.Tv_HMAlarmCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  a,b,c,d :integer;
begin
  a :=-1;
  b :=-1;
  c :=-1;
  a := TcxGridDBTableView(Sender).GetColumnByFieldName('sendtime').Index;
  b := TcxGridDBTableView(Sender).GetColumnByFieldName('removetime').Index;
  c := TcxGridDBTableView(Sender).GetColumnByFieldName('limithour').Index;
  d := TcxGridDBTableView(Sender).GetColumnByFieldName('flowtache').Index;
  if (a>=0) and (b>=0) and (c>=0) then Exit;
  If  (AViewInfo.GridRecord.Values[b]-AViewInfo.GridRecord.Values[a])*24 > AViewInfo.GridRecord.Values[c] Then  //7 凭证被驳回
      ACanvas.Font.Color := clRed
  else
      ACanvas.Font.Color := clWindowText ;
end;

procedure TFm_AlarmMonitor.Tv_HMAlarmDataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
Var
  index:integer;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  index :=Tv_HMAlarm.GetColumnByFieldName('alarmid').Index;
  Alarm_ID2:=ADataController.GetValue(ARecordIndex,index);

  with Dm_Mts.cds_HDetail do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,22,Alarm_ID2]),0);
  end;
  Tv_HDAlarm.ApplyBestFit();
end;

procedure TFm_AlarmMonitor.Tv_HMAlarmMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lCheckValue : String;
  lCol : integer;
  lColumn_Checked : TcxGridDBColumn;
begin
  if (Button <> mbLeft) or (not (Tv_HMAlarm.GetHitTest(X, Y) is TcxGridRecordCellHitTest)) then
  begin
    Exit;
  end;
  lCol := Tv_HMAlarm.Controller.FocusedColumn.Index;
  lColumn_Checked := Tv_HMAlarm.GetColumnByFieldName('isChecked');
  if (lColumn_Checked<>nil) and (lColumn_Checked.Index = lCol)  then
  begin
    lCheckValue := Tv_HMAlarm.DataController.DataSource.DataSet.FieldByName('isChecked').AsString;
    if lCheckValue='Y' then
    begin
      Tv_HMAlarm.DataController.DataSource.DataSet.Edit;
      Tv_HMAlarm.DataController.DataSource.DataSet.FieldByName('isChecked').AsString := 'N';
      Tv_HMAlarm.DataController.DataSource.DataSet.Post;
    end else
    if lCheckValue='N' then
    begin
      Tv_HMAlarm.DataController.DataSource.DataSet.Edit;
      Tv_HMAlarm.DataController.DataSource.DataSet.FieldByName('isChecked').AsString := 'Y';
      Tv_HMAlarm.DataController.DataSource.DataSet.Post;
    end;
  end;
end;

procedure TFm_AlarmMonitor.Tv_MAlarmCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  index1 :integer;
  a,b :integer;
begin
  index1 :=-1;
  index1 := TcxGridDBTableView(Sender).GetColumnByFieldName('readed').Index;
  if index1 >= 0 then
  begin
    If  AViewInfo.GridRecord.Values[index1]= 0 Then  //7 凭证被驳回
      ACanvas.Brush.Color := $004080FF;
  end;
  a :=-1;
  b :=-1;
  a := TcxGridDBTableView(Sender).GetColumnByFieldName('sendtime').Index;
  b := TcxGridDBTableView(Sender).GetColumnByFieldName('limithour').Index;
  if (a>=0) and (b>=0)  then
  begin
    If (now-AViewInfo.GridRecord.Values[a])*24 > AViewInfo.GridRecord.Values[b] Then  //7 凭证被驳回
      if ACanvas.Brush.Color<>$004080FF then
        ACanvas.Font.Color := clRed
    else
      ACanvas.Font.Color := clWindowText;
  end;
  
end;


procedure TFm_AlarmMonitor.Tv_MAlarmDataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
Var
  index:integer;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  index :=Tv_MAlarm.GetColumnByFieldName('alarmid').Index;
  Alarm_ID:=ADataController.GetValue(ARecordIndex,index);
  DS_Detail.DataSet:=nil;
  with Dm_Mts.cds_Detail do
  begin
    Close;
    ProviderName:='dsp_General_data';
    //Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,35,Alarm_ID]),0);
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,21,Alarm_ID]),0);
  end;
  DS_Detail.DataSet:=Dm_Mts.cds_Detail;//告警从表
  Tv_DAlarm.ApplyBestFit();   
end;

procedure TFm_AlarmMonitor.Tv_MAlarmFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
   ShowHistoryAlarms;
end;

procedure TFm_AlarmMonitor.Tv_MAlarmMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lCheckValue : String;
  lCol : integer;
  lColumn_Checked : TcxGridDBColumn;
begin
  if (Button <> mbLeft) or (not (Tv_MAlarm.GetHitTest(X, Y) is TcxGridRecordCellHitTest)) then
  begin
    Exit;
  end;
  lCol := Tv_MAlarm.Controller.FocusedColumn.Index;
  lColumn_Checked := Tv_MAlarm.GetColumnByFieldName('isChecked');
  if (lColumn_Checked<>nil) and (lColumn_Checked.Index = lCol)  then
  begin
    //lCheckValue := Tv_MAlarm.DataController.GetValue(lRow,lCol);
    //lCheckValue := Tv_MAlarm.DataController.GetDisplayText(lRow,lCol);
    lCheckValue := Tv_MAlarm.DataController.DataSource.DataSet.FieldByName('isChecked').AsString;
    if lCheckValue='Y' then
    begin
      Tv_MAlarm.DataController.DataSource.DataSet.Edit;
      Tv_MAlarm.DataController.DataSource.DataSet.FieldByName('isChecked').AsString := 'N';
      Tv_MAlarm.DataController.DataSource.DataSet.Post;
    end else
    if lCheckValue='N' then
    begin
      Tv_MAlarm.DataController.DataSource.DataSet.Edit;
      Tv_MAlarm.DataController.DataSource.DataSet.FieldByName('isChecked').AsString := 'Y';
      Tv_MAlarm.DataController.DataSource.DataSet.Post;
    end;
  end;
end;

end.
