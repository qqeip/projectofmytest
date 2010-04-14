unit UntDRSConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, DBClient, CxGridUnit, cxLookAndFeelPainters,
  cxContainer, cxGroupBox, DBCtrls, cxSplitter;

type
  TActedPage= set of (wd_Infomation,wd_Configure,wd_Command,wd_Alarm);

type
  TFrmDRSConfig = class(TForm)
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Panel3: TPanel;
    btQuery: TButton;
    btManualActive: TButton;
    btAutoActive: TButton;
    btLock: TButton;
    pgDRSConfig: TPageControl;
    tsDRSConfigInfo: TTabSheet;
    tsDRSConfigParam: TTabSheet;
    tsDRSConfigCom: TTabSheet;
    tsDRSConfigAlarm: TTabSheet;
    cxGridDBTVDRSList: TcxGridDBTableView;
    cxGridDRSListLevel1: TcxGridLevel;
    cxGridDRSList: TcxGrid;
    DSDRS: TDataSource;
    CDSDRS: TClientDataSet;
    btClose: TButton;
    Label1: TLabel;
    CbBDRS_TYPE: TComboBox;
    Edt_DRS_Info: TEdit;
    cxSplitter1: TcxSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btManualActiveClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure cxGridDBTVDRSListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btLockClick(Sender: TObject);
    procedure btQueryClick(Sender: TObject);
    procedure cxGridDBTVDRSListFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxGridDBTVDRSListCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
    procedure CbBDRS_TYPEKeyPress(Sender: TObject; var Key: Char);
    procedure pgDRSConfigChange(Sender: TObject);
  private
    FCxGridHelper: TCxGridSet;
    gActedPage:TActedPage;

    procedure AddOtherForm;
    procedure ShowOtherForm;
    procedure FreeOtherForm;

    procedure AddDRSListFields;  

    procedure CheckSelecttion;
    procedure NotifiSelecttionChange;
    procedure SetButonEnable(blHasData: boolean; IsMultSelect: boolean=false);

    function ManualActive: boolean;
    function SetDRSLock: boolean;
  public
    gWhereCond: string;
    
    procedure ShowDRSListData(DRSID: Integer=-1);
  end;

var
  FrmDRSConfig: TFrmDRSConfig;

implementation

uses Ut_Common, Ut_MainForm, Ut_DataModule, UntDRSConfigParamSet,
  UntCommandParam, UnitDRSInfoMgr, UnitDRSSingleAlarmSearch,
  UntDRSConfigComQuery;

{$R *.dfm}

procedure TFrmDRSConfig.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDRSList,false,true,false);
  cxGridDBTVDRSList.OptionsSelection.MultiSelect:= true;
//  gActedPage:=[];

  UntCommandParam.CurrentCityID := -1;
  UntCommandParam.Current_DRSID := -1;
  UntCommandParam.CurrentDRSNO := '';
  UntCommandParam.CurrentR_DeviceID := -1;
  UntCommandParam.CurrentDRSType := -1;
  UntCommandParam.CurrentDRSStatus := -1;

  gWhereCond := ' DRSStatus=1';

  AddOtherForm;

  AddDRSListFields;  
end;

procedure TFrmDRSConfig.FormShow(Sender: TObject);
begin
  ShowOtherForm;
  
  ShowDRSListData;

  GetDic(51,CbBDRS_TYPE.Items);
end;

procedure TFrmDRSConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   DestroyCBObj(CbBDRS_TYPE);

  Action := cafree;

  FreeOtherForm;

  FCxGridHelper.Free;
  
  Fm_MainForm.DeleteTab(self);
  FrmDRSConfig:=nil;
end;

procedure TFrmDRSConfig.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmDRSConfig.cxGridDBTVDRSListCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  DRSStatusIndex, DRSStatus: integer;
begin
  if AViewInfo.GridRecord.Selected then
  begin
    ACanvas.Brush.Color := clBlue;   
  end;

 // try
    DRSStatusIndex := TcxGridDBTableView(Sender).GetColumnByFieldName('DRSStatus').Index;

  //except
   // exit;
  //end;
  if varisnull(AViewInfo.GridRecord.Values[DRSStatusIndex]) then
    DRSStatus:= -1
  else
    DRSStatus:= AViewInfo.GridRecord.Values[DRSStatusIndex];

  if (DRSStatus=3) or (DRSStatus=4) then
    ACanvas.Brush.Color := $004080FF;   
end;

procedure TFrmDRSConfig.cxGridDBTVDRSListFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  //CheckSelecttion;
end;

procedure TFrmDRSConfig.cxGridDBTVDRSListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);  
begin
  CheckSelecttion;
end;

procedure TFrmDRSConfig.AddOtherForm;
begin
  FormDRSInfoMgr := TFormDRSInfoMgr.Create(self);
  FormDRSInfoMgr.Parent := tsDRSConfigInfo;
  FormDRSInfoMgr.ClientDataSet1 := CDSDRS;

  FrmDRSConfigParamSet := TFrmDRSConfigParamSet.Create(self);
  FrmDRSConfigParamSet.Parent := tsDRSConfigParam;

  FrmDRSConfigComQuery := TFrmDRSConfigComQuery.Create(self);
  FrmDRSConfigComQuery.Parent := tsDRSConfigCom;

  FormDRSSingleAlarmSearch := TFormDRSSingleAlarmSearch.Create(self);
  FormDRSSingleAlarmSearch.Parent := tsDRSConfigAlarm;
end;

procedure TFrmDRSConfig.ShowOtherForm;
begin
  FormDRSInfoMgr.Show;
  FrmDRSConfigParamSet.Show;
  FrmDRSConfigComQuery.Show;
  FormDRSSingleAlarmSearch.Show;
end;

procedure TFrmDRSConfig.FreeOtherForm;
begin
  FormDRSInfoMgr.Close;
  FormDRSInfoMgr.Free;
  FrmDRSConfigParamSet.Close;
  FrmDRSConfigParamSet.Free;
  FrmDRSConfigComQuery.Close;
  FrmDRSConfigComQuery.Free;
  FormDRSSingleAlarmSearch.Close;
  FormDRSSingleAlarmSearch.Free;
end;

procedure TFrmDRSConfig.NotifiSelecttionChange;
begin
  //pgDRSConfig.Enabled := UntCommandParam.CurrentDRSID<>-1;
  if (pgDRSConfig.ActivePage =tsDRSConfigInfo) and not (wd_Infomation in gActedPage)  then
  begin
    FormDRSInfoMgr.DRSSelectChange;
    gActedPage:= gActedPage+ [wd_Infomation];
  end;
  if (pgDRSConfig.ActivePage =tsDRSConfigParam) and not (wd_Configure in gActedPage)  then
  begin
    FrmDRSConfigParamSet.DRSSelectChange;
    gActedPage:= gActedPage+ [wd_Configure];
  end;
  if (pgDRSConfig.ActivePage =tsDRSConfigCom) and not (wd_Command in gActedPage)  then
  begin
    FrmDRSConfigComQuery.DRSSelectChange;
    gActedPage:= gActedPage+ [wd_Command];
  end;
  if (pgDRSConfig.ActivePage =tsDRSConfigAlarm) and not (wd_Alarm in gActedPage)  then
  begin
    FormDRSSingleAlarmSearch.DRSSelectChange;
    gActedPage:= gActedPage+ [wd_Alarm];
  end;
end;

procedure TFrmDRSConfig.pgDRSConfigChange(Sender: TObject);
begin
  NotifiSelecttionChange;
end;

procedure TFrmDRSConfig.AddDRSListFields;
begin
  AddViewField(cxGridDBTVDRSList,'drsid','直放站主键');
  AddViewField(cxGridDBTVDRSList,'drsno','直放站编号');
  AddViewField(cxGridDBTVDRSList,'r_deviceid','直放站设备编号');
  AddViewField(cxGridDBTVDRSList,'drsname','直放站名称');
  AddViewField(cxGridDBTVDRSList,'DRSType','直放站类型',65,false);
  AddViewField(cxGridDBTVDRSList,'drstypename','直放站类型名称');
  AddViewField(cxGridDBTVDRSList,'drsmanu','直放站厂家',65,false);
  AddViewField(cxGridDBTVDRSList,'drsmanuname','直放站厂家名称');
  AddViewField(cxGridDBTVDRSList,'suburbID','所属分局',65,false);
  AddViewField(cxGridDBTVDRSList,'suburbname','所属分局名称');
  AddViewField(cxGridDBTVDRSList,'areaid','地区',65,false);
  AddViewField(cxGridDBTVDRSList,'areaname','地区名称');
  AddViewField(cxGridDBTVDRSList,'cityid','地市',65,false);
  AddViewField(cxGridDBTVDRSList,'cityname','地市名称');  
  AddViewField(cxGridDBTVDRSList,'drsstatus','直放站状态',65,false);
  AddViewField(cxGridDBTVDRSList,'drsstatusname','直放站状态');

  AddViewField(cxGridDBTVDRSList,'ISPROGRAMName','是否室分'); 
  AddViewField(cxGridDBTVDRSList,'buildingname','所属室分点');
  AddViewField(cxGridDBTVDRSList,'CS','归属基站');
  AddViewField(cxGridDBTVDRSList,'MSC','归属MSC');
  AddViewField(cxGridDBTVDRSList,'BSC','归属BSC');
  AddViewField(cxGridDBTVDRSList,'CELL','归属扇区');
  AddViewField(cxGridDBTVDRSList,'PN','PN码');
  AddViewField(cxGridDBTVDRSList,'AGENTMANU','代维公司');
  AddViewField(cxGridDBTVDRSList,'LONGITUDE','经度');
  AddViewField(cxGridDBTVDRSList,'LATITUDE','纬度');
  AddViewField(cxGridDBTVDRSList,'DRSADRESS','地址');
  AddViewField(cxGridDBTVDRSList,'DRSPHONE','电话号码');
  AddViewField(cxGridDBTVDRSList,'DRSSTATUSName','当前状态');
  AddViewField(cxGridDBTVDRSList,'UPDATETIME1','最后状态变更时间');
  AddViewField(cxGridDBTVDRSList,'UPDATETIME2','最后状态获取时间');
  AddViewField(cxGridDBTVDRSList,'ALARMCOUNTS','当前告警数');
  AddViewField(cxGridDBTVDRSList,'UPDATETIME3','最后配置时间');
  AddViewField(cxGridDBTVDRSList,'UPDATETIME4','最后配置更新时间');
end;    

procedure TFrmDRSConfig.ShowDRSListData(DRSID: Integer=-1);
begin
  cxGridDBTVDRSList.BeginUpdate;
  //DSDRS.DataSet:= nil;
  with CDSDRS do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,3,1, gWhereCond]),0);
  end;
  //DSDRS.DataSet:= CDSDRS;
  if DRSID<>-1 then CDSDRS.Locate('DRSID',DRSID,[]);
  cxGridDBTVDRSList.EndUpdate;
  cxGridDBTVDRSList.ApplyBestFit();

  CheckSelecttion;
end;

procedure TFrmDRSConfig.CbBDRS_TYPEKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key=#8) then
        key:=#0;
end;

procedure TFrmDRSConfig.CheckSelecttion;
var
  RecordIndex, CityIDIndex, DRSIDIndex,DRS_IDIndex, R_DeviceIDIndex, DRSTypeIndex, DRSStatusIndex: Integer;
begin
  if (cxGridDBTVDRSList.DataController.RecordCount=0) or (cxGridDBTVDRSList.DataController.GetSelectedCount=0) then
  begin
    UntCommandParam.CurrentCityID := -1;
    UntCommandParam.Current_DRSID := -1;
    UntCommandParam.CurrentDRSNO := '';
    UntCommandParam.CurrentR_DeviceID := -1;
    UntCommandParam.CurrentDRSType := -1;
    UntCommandParam.CurrentDRSStatus := -1;

    SetButonEnable(false);
  end
  else if cxGridDBTVDRSList.DataController.GetSelectedCount>1 then
  begin
    UntCommandParam.CurrentCityID := -1;
    UntCommandParam.Current_DRSID := -1;
    UntCommandParam.CurrentDRSNO := '';
    UntCommandParam.CurrentR_DeviceID := -1;
    UntCommandParam.CurrentDRSType := -1;
    UntCommandParam.CurrentDRSStatus := -1;

    SetButonEnable(true, true);
  end
  else if cxGridDBTVDRSList.DataController.GetSelectedCount=1 then
  begin
    RecordIndex :=  cxGridDBTVDRSList.DataController.GetSelectedRowIndex(0);
    RecordIndex :=  cxGridDBTVDRSList.DataController.FilteredRecordIndex[RecordIndex];

    CityIDIndex:=cxGridDBTVDRSList.GetColumnByFieldName('CityID').Index;
    DRSIDIndex:=cxGridDBTVDRSList.GetColumnByFieldName('DRSNO').Index;
    DRS_IDIndex:=cxGridDBTVDRSList.GetColumnByFieldName('DRSID').Index;
    R_DeviceIDIndex:=cxGridDBTVDRSList.GetColumnByFieldName('R_DeviceID').Index;
    DRSTypeIndex:=cxGridDBTVDRSList.GetColumnByFieldName('DRSType').Index;
    DRSStatusIndex:=cxGridDBTVDRSList.GetColumnByFieldName('DRSStatus').Index;

    UntCommandParam.CurrentCityID := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, CityIDIndex);
    UntCommandParam.Current_DRSID := StrToInt(cxGridDBTVDRSList.DataController.GetValue(RecordIndex, DRS_IDIndex));
    UntCommandParam.CurrentDRSNO := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, DRSIDIndex);
    UntCommandParam.CurrentR_DeviceID := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, R_DeviceIDIndex);
    UntCommandParam.CurrentDRSType := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, DRSTypeIndex);
    UntCommandParam.CurrentDRSStatus := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, DRSStatusIndex);

    gActedPage:=gActedPage-[wd_Infomation];
    gActedPage:=gActedPage-[wd_Configure];
    gActedPage:=gActedPage-[wd_Command];
    gActedPage:=gActedPage-[wd_Alarm];

    SetButonEnable(true);
  end;

  NotifiSelecttionChange;
end;

procedure TFrmDRSConfig.SetButonEnable(blHasData: boolean; IsMultSelect: boolean=false);
begin
  if not blHasData then
  begin
    btManualActive.Enabled := false;
    btAutoActive.Enabled := false;
    btLock.Enabled := false;
  end
  else
  begin
    btManualActive.Enabled := (UntCommandParam.CurrentDRSStatus=1) or IsMultSelect;
    btAutoActive.Enabled := (UntCommandParam.CurrentDRSStatus=1) or IsMultSelect;
    if IsMultSelect then
    begin
      btLock.Enabled := false;
    end
    else
    begin
      btLock.Enabled := (UntCommandParam.CurrentDRSStatus<>1) and (UntCommandParam.CurrentDRSStatus<>-1);
      if btLock.Enabled then
      begin
        if UntCommandParam.CurrentDRSStatus=5 then
        begin
          btLock.Caption := '解锁';
        end
        else
        begin
          btLock.Caption := '锁定';
        end;
      end;
    end;
  end; 
end;

procedure TFrmDRSConfig.btManualActiveClick(Sender: TObject);   
begin
  ManualActive;
end;

procedure TFrmDRSConfig.btQueryClick(Sender: TObject);   
begin
   gWhereCond := ' 1=1 and ';
   gWhereCond:=gWhereCond+' upper(a.drstypename) like ''%'+uppercase(CbBDRS_TYPE.Text)+'%'' and ';
   if Edt_DRS_Info.Text<>'' then
     gWhereCond:=gWhereCond+' (upper(a.drsno) like ''%'+uppercase(Edt_DRS_Info.Text)+
             '%'' or upper(a.drsname) like ''%'+uppercase(Edt_DRS_Info.Text)+
             '%'' or upper(a.DRSADRESS) like ''%'+uppercase(Edt_DRS_Info.Text)+
             '%'' or upper(a.drsphone) like ''%'+uppercase(Edt_DRS_Info.Text)+'%'') and ';
   gWhereCond:=Copy(gWhereCond,1,Length(gWhereCond)-4);

   ShowDRSListData;
end;

function TFrmDRSConfig.ManualActive: boolean;
var
  I, RecordIndex, CityIDIndex, DRSIDIndex,DRSNOIndex, R_DeviceIDIndex, DRSTypeIndex, DRSStatusIndex: Integer;
  CityID, DRS_ID,R_DeviceID, DRSType, DRSStatus: Integer;
  DRSID:string;
  TaskID, UserID: Integer;
begin
  Result := false;
  if CDSDRS.IsEmpty then exit;

  CityIDIndex:=cxGridDBTVDRSList.GetColumnByFieldName('CityID').Index;
  DRSIDIndex:=cxGridDBTVDRSList.GetColumnByFieldName('DRSID').Index;
  DRSNOIndex:=cxGridDBTVDRSList.GetColumnByFieldName('DRSNO').Index;
  R_DeviceIDIndex:=cxGridDBTVDRSList.GetColumnByFieldName('R_DeviceID').Index;
  DRSTypeIndex:=cxGridDBTVDRSList.GetColumnByFieldName('DRSType').Index;
  DRSStatusIndex:=cxGridDBTVDRSList.GetColumnByFieldName('DRSStatus').Index;
  for I := 0 to cxGridDBTVDRSList.DataController.GetSelectedCount-1 do
  begin
    RecordIndex :=  cxGridDBTVDRSList.DataController.GetSelectedRowIndex(I);
    RecordIndex :=  cxGridDBTVDRSList.DataController.FilteredRecordIndex[RecordIndex];
    //RecordIndex :=  cxGridDBTVDRSList.Controller.SelectedRows[I].RecordIndex;

    DRSStatus := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, DRSStatusIndex);
    if DRSStatus=1 then
    begin
      CityID := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, CityIDIndex);
      DRSID := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, DRSNOIndex);
      DRS_ID := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, DRSIDIndex);
      R_DeviceID := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, R_DeviceIDIndex);
      DRSType := cxGridDBTVDRSList.DataController.GetValue(RecordIndex, DRSTypeIndex);

      TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');
      UserID := Fm_MainForm.PublicParam.userid;
      Result := SendCommand32(TaskID, CityID, DRS_ID, R_DeviceID, DRSType, UserID,DRSID);
    end;
    {if SendCommand32(111,111,111,111,111) then
      Application.MessageBox('手动激活命令发送成功！', '提示')
    else
      Application.MessageBox('手动激活命令发送失败，该命令正在发送！', '异常'); }
  end;
end;

procedure TFrmDRSConfig.btLockClick(Sender: TObject);
begin
  if SetDRSLock then ShowDRSListData(UntCommandParam.Current_DRSID);
end;

function TFrmDRSConfig.SetDRSLock: boolean;
begin
  Result := false;
  if UntCommandParam.CurrentDRSStatus=5 then
  begin
    Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
      VarArrayOf([1,3,2, UntCommandParam.Current_DRSID, 2])
      ]));
  end
  else if UntCommandParam.CurrentDRSStatus<>1 then
  begin
    Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
      VarArrayOf([1,3,2, UntCommandParam.Current_DRSID, 5])
      //加上删除告警
      ]));
  end;   
end;  


end.
