unit UntAlarmTestModel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, dxtree, dxdbtree, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, Spin,
  cxLabel, cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCheckListBox,
  DBClient, cxDBCheckListBox, Menus, cxDBEdit, dxStatusBar, cxSpinEdit,
  cxTimeEdit, cxCalendar, cxListBox, CheckLst, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxSplitter, Grids, DBGrids, ImgList, CxGridUnit;

type
  TFrmAlarmTestModel = class(TForm)
    pMain: TPanel;
    pLeft: TPanel;
    gbLeft: TGroupBox;
    tTaskModelTree: TdxDBTreeView;
    pRight: TPanel;
    pgSetting: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    pTop2: TPanel;
    pTop: TPanel;
    pBottom: TPanel;
    pBottom2: TPanel;
    Panel9: TPanel;
    Panel7: TPanel;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    cxGrid2: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    GroupBox6: TGroupBox;
    cxgMTUInfo: TcxGrid;
    cxgtvMTUInfo: TcxGridDBTableView;
    cxGridLevel3: TcxGridLevel;
    Panel2: TPanel;
    Button5: TButton;
    CDSMTUList: TClientDataSet;
    DSMTUList: TDataSource;
    CDSModelComParam: TClientDataSet;
    DSModelComParam: TDataSource;
    CDSModel: TClientDataSet;
    DSModel: TDataSource;
    DSModelCom: TDataSource;
    CDSModelCom: TClientDataSet;
    cxGrid3: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    GroupBox3: TGroupBox;
    cxGrid4: TcxGrid;
    cxGridDBTableView4: TcxGridDBTableView;
    cxGridLevel4: TcxGridLevel;
    DSTaskListTime: TDataSource;
    CDSTaskListTimeDetail: TClientDataSet;
    DSTaskListTimeDetail: TDataSource;
    CDSTaskListTime: TClientDataSet;
    Splitter1: TSplitter;
    pBRight: TPanel;
    gbParams: TGroupBox;
    Panel1: TPanel;
    Label5: TLabel;
    Label2: TLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxDBSpinEdit1: TcxDBSpinEdit;
    cxDBSpinEdit2: TcxDBSpinEdit;
    Panel3: TPanel;
    Label4: TLabel;
    cxLabel4: TcxLabel;
    SendT2: TDateTimePicker;
    SendT1: TDateTimePicker;
    Panel4: TPanel;
    btAddTime: TButton;
    btRemoveCom: TButton;
    btAddCom: TButton;
    btRemoveTime: TButton;
    clbModelCom: TCheckListBox;
    pBLeft: TPanel;
    Panel8: TPanel;
    pModelEdit: TPanel;
    pModelChange: TPanel;
    cxLabel1: TcxLabel;
    lModelType: TcxLabel;
    pDBSave: TPanel;
    btNew: TButton;
    btSave: TButton;
    btAdd: TButton;
    gbTaskList: TGroupBox;
    cxgTaskListTime: TcxGrid;
    cxgtvTaskListTime: TcxGridDBTableView;
    cxgtvTaskListTimeColumnbegintime: TcxGridDBColumn;
    cxgtvTaskListTimeColumnendtime: TcxGridDBColumn;
    cxgtvTaskListTimeDetail: TcxGridDBTableView;
    cxgtvTaskListTimeDetailColumnComName: TcxGridDBColumn;
    cxgtvTaskListTimeDetailColumn2: TcxGridDBColumn;
    cxgtvTaskListTimeDetailColumn3: TcxGridDBColumn;
    cxglTaskListTime: TcxGridLevel;
    cxglTaskListTimeDetail: TcxGridLevel;
    pWeek: TPanel;
    gbWeek: TGroupBox;
    cbWeek1: TCheckBox;
    cbWeek2: TCheckBox;
    cbWeek3: TCheckBox;
    cbWeek4: TCheckBox;
    cbWeek5: TCheckBox;
    cbWeek6: TCheckBox;
    cbWeek7: TCheckBox;
    cxgtvTaskListTimeDetailColumnCURR_CYCCOUNT: TcxGridDBColumn;
    btNewType: TButton;
    btAddModel: TButton;
    btDelete: TButton;
    CDSModelType: TClientDataSet;
    DSModelType: TDataSource;
    spMain: TSplitter;
    btJHControl: TButton;
    btJHDelete: TButton;
    cbModelType: TcxLookupComboBox;
    eModelName: TcxTextEdit;
    btChangeType: TButton;
    ImageList1: TImageList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btNewClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure tTaskModelTreeChange(Sender: TObject; Node: TTreeNode);
    procedure cxGridDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxGridDBTableView4FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure btAddTimeClick(Sender: TObject);
    procedure btRemoveTimeClick(Sender: TObject);
    procedure btAddComClick(Sender: TObject);
    procedure btRemoveComClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btNewTypeClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure btAddModelClick(Sender: TObject);
    procedure cxgtvMTUInfoFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure btJHControlClick(Sender: TObject);
    procedure btJHDeleteClick(Sender: TObject);
    procedure btChangeTypeClick(Sender: TObject);
    procedure tTaskModelTreeGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure cxgtvMTUInfoCustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo;
      var ADone: Boolean);
  private
    { Private declarations }
    FCxGridHelper : TCxGridSet;

    CurrentModelID: Integer;

    function  CheckModelSaveValid: boolean;
    function  GetWeekChoose: string;
    procedure SetWeekChoose(PLANDATE: string = '');
    procedure RefreshModelTree(ModelID: Integer);
    procedure GetTimeData;
    procedure GetTimeDetailData;
    procedure ExpandAllDetail;
    procedure ChangeJHControl(ISPAUSE: boolean);
  public
    { Public declarations }
    iFlag: Integer; // 窗体整体风格配置
  end;

var
  FrmAlarmTestModel, FrmAlarmTestModelM: TFrmAlarmTestModel;
  FrmAlarmTestModeliFlag: Integer;// 窗体整体风格配置

implementation

uses Ut_MainForm, Ut_DataModule, UntDBFunc, Ut_Common;

{$R *.dfm}

procedure TFrmAlarmTestModel.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxgTaskListTime,true,false,true);

  FCxGridHelper.SetGridStyle(cxgMTUInfo,true,false,true);

  iFlag := FrmAlarmTestModeliFlag;

  CurrentModelID := 0;

  DSModel.DataSet := nil;
  with CDSModel do
  begin
    Close;
    ProviderName:='dsp_General_data6';
    if iFlag=0 then        
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,3]),6)
    else
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,51]),6);
  end;
  DSModel.DataSet := CDSModel;

  DSModelType.DataSet := nil;
  CDSModelType.Data := CDSModel.Data;
  DSModelType.DataSet := CDSModelType;
                                 
  //初始化测试命令
  InitItems(VarArrayOf([1,2,4]), clbModelCom.Items);


  if iFlag = 1 then
  begin
    DSMTUList.DataSet := nil;
    with CDSMTUList do
    begin
      Close;
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,50]),3)
    end;
    AddGridFields(cxgtvMTUInfo, CDSMTUList, 'ModelID,MTU编号,是否暂停');
    AddGridFields(cxGridDBTableView1, CDSMTUList, 'ModelID,MTU编号,是否暂停');
    cxGridDBTableView1.GetColumnByFieldName('ModelID').Visible:=false;
    cxgtvMTUInfo.GetColumnByFieldName('ModelID').Visible:=false;
    //cxGridDBTableView1.GetColumnByFieldName('ISPAUSE').Visible:=false;
    //cxgtvMTUInfo.GetColumnByFieldName('ISPAUSE').Visible:=false;
    DSMTUList.DataSet := CDSMTUList;
    cxgtvMTUInfo.ApplyBestFit();
    cxGridDBTableView1.ApplyBestFit();
  end;


  {//模板MTU命令集
  DSModelCom.DataSet := nil;
  with CDSModelCom do
  begin
    Close;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,7,0,-1]),0);
  end;
  AddGridFields(cxGridDBTableView4, CDSModelCom, '任务ID, 命令名, 命令开始执行时间');
  DSModelCom.DataSet := CDSModelCom;
  cxGridDBTableView4.ApplyBestFit();
  //命令参数集
  DSModelComParam.DataSet := nil;
  with CDSModelComParam do
  begin
    Close;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,6,-1]),0);
  end;
  AddGridFields(cxGridDBTableView2, CDSModelComParam, '参数ID, 参数名, 参数值');
  DSModelComParam.DataSet := CDSModelComParam;
  cxGridDBTableView2.ApplyBestFit(); }

  pgSetting.TabIndex := 0;

  CurrentModelID := CDSModel.FieldByName('ModelID').AsInteger;


  if iFlag = 1 then Caption := '任务计划监控';
  

end;

procedure TFrmAlarmTestModel.FormShow(Sender: TObject);
begin
  case iFlag of
    0:  //任务模板配置
    begin
      pTop.Visible := false;

      pgSetting.Pages[0].Caption := '任务模板配置';
      pgSetting.Pages[1].TabVisible := false;

      cxgtvTaskListTimeDetailColumnCURR_CYCCOUNT.Visible := false;
      spMain.Visible := false;
      btJHControl.Visible := false;
      btJHDelete.Visible := false;
    end;
    1:  //任务模板监控
    begin
      pBRight.Visible := false;
      gbWeek.Enabled := false;
      pModelEdit.Visible := false;
      cxgtvTaskListTimeDetail.OptionsData.Editing := false;   
      pgSetting.Pages[0].Caption := '任务计划监控';
      pgSetting.Pages[1].TabVisible := false;
      TabSheet2.Visible := false;  

      cxgtvTaskListTimeDetailColumnComName.Width := 299;
      cxgtvTaskListTimeColumnbegintime.Width := 300;
      cxgtvTaskListTimeColumnendtime.Width := 300;
    end;
  end;
end;

procedure TFrmAlarmTestModel.ExpandAllDetail;
Var
  index, I: integer;
begin  
  if not CDSTaskListTime.IsEmpty then
  begin
    CDSTaskListTime.First;
    for I := 0 to CDSTaskListTime.RecordCount - 1 do
    begin
      index := cxgtvTaskListTime.DataController.GetFocusedRecordIndex;
      cxgtvTaskListTime.DataController.ChangeDetailExpanding(index,true);
      CDSTaskListTime.Next;
    end;
  end; 
end;

procedure TFrmAlarmTestModel.btAddTimeClick(Sender: TObject);
var
  begintime,endtime: string;
begin
  Dm_MTS.cds_common.Data := CDSTaskListTime.Data;
  if Dm_MTS.cds_common.Locate('begintime;endtime', VarArrayOf([SendT1.Time,SendT2.Time]), []) then
  begin
    Application.MessageBox('该时间段已存在！','提示',MB_OK	);
    exit;
  end;

  CDSTaskListTime.Append;
  begintime := FormatDateTime('HHMM', SendT1.Time);
  endtime := FormatDateTime('HHMM', SendT2.Time);
  CDSTaskListTime.FieldByName('ID').AsString := begintime+endtime;
  CDSTaskListTime.FieldByName('ModelID').AsInteger := CDSModel.FieldByName('ModelID').AsInteger;
  CDSTaskListTime.FieldByName('begintime').AsDateTime := SendT1.Time;
  CDSTaskListTime.FieldByName('endtime').AsDateTime := SendT2.Time;
  CDSTaskListTime.CheckBrowseMode;

  ExpandAllDetail;
end;   

procedure TFrmAlarmTestModel.btDeleteClick(Sender: TObject);
var
  DelModelID: Integer;
begin
  if not CDSModel.IsEmpty then
  begin
    DelModelID := CDSModel.FieldByName('ModelID').AsInteger;
    CurrentModelID := CDSModel.FieldByName('ParentModelID').AsInteger;

    if CDSModel.FieldByName('ParentModelID').AsInteger = 1 then
    begin
      if Application.MessageBox('删除任务计划类型将同时删除该类型下所有任务计划，确定删除吗?', '提示', MB_YESNO) = IDYES then
      begin
        with Dm_MTS.cds_common do
        begin
          Close;
          ProviderName:='dsp_General_data1';
          Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,46,DelModelID]),1);
        end;

        if Dm_MTS.cds_common.RecordCount > 0 then
        begin
          Application.MessageBox('任务计划已被MTU关联，不可删除！','提示',MB_OK	);
          Exit;
        end;

        try
          Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,34,DelModelID]),VarArrayOf([1,2,35,DelModelID]),VarArrayOf([1,2,36,DelModelID])]));
          Application.MessageBox('成功删除，已保存至数据库！','提示',MB_OK	);

          RefreshModelTree(CurrentModelID);
          tTaskModelTree.DBSelected.Expand(false);
        except
          Application.MessageBox('删除任务失败,请检查后重试！', '提示', mb_ok);
        end;
      end;
    end
    else
    begin
      if Application.MessageBox(PAnsiChar('将删除任务计划：'+CDSModel.FieldByName('ModelName').AsString+'，确定吗?'), '提示', MB_YESNO) = IDYES then
      begin
        with Dm_MTS.cds_common do
        begin
          Close;
          ProviderName:='dsp_General_data1';
          Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,45,DelModelID]),1);
        end;

        if Dm_MTS.cds_common.RecordCount > 0 then
        begin
          Application.MessageBox('任务计划已被MTU关联，不可删除！','提示',MB_OK	);
          Exit;
        end;   

        try
          Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,31,DelModelID]),VarArrayOf([1,2,32,DelModelID]), VarArrayOf([1,2,33,DelModelID])]));
          Application.MessageBox('成功删除，已保存至数据库！','提示',MB_OK	);

          RefreshModelTree(CurrentModelID);
          tTaskModelTree.DBSelected.Expand(false);
        except
          Application.MessageBox('删除任务失败,请检查后重试！', '提示', mb_ok);
        end;
      end;
    end ;
  end;
end;

procedure TFrmAlarmTestModel.btJHControlClick(Sender: TObject);
var
  MTUID, MTUIDIndex, ModelIDIndex, RecordIndex, I: Integer;
  SelectMTUID, SelectModelID, WhereCond: string;
begin 
  WhereCond := '';
  MTUIDIndex:=cxgtvMTUInfo.GetColumnByFieldName('MTUID').Index;
  ModelIDIndex:=cxgtvMTUInfo.GetColumnByFieldName('ModelID').Index;
  for I := 0 to cxgtvMTUInfo.DataController.GetSelectedCount -1 do
  begin
    RecordIndex :=  cxgtvMTUInfo.DataController.GetSelectedRowIndex(I);
    RecordIndex :=  cxgtvMTUInfo.DataController.FilteredRecordIndex[RecordIndex];
    SelectMTUID := cxgtvMTUInfo.DataController.GetValue(RecordIndex, MTUIDIndex);
    SelectModelID := cxgtvMTUInfo.DataController.GetValue(RecordIndex, ModelIDIndex);  
    WhereCond := WhereCond + ' or (ModelID='+SelectModelID+' and MTUID='+SelectMTUID+')';
  end; 
  if WhereCond = '' then
  begin  
    Application.MessageBox('请选择MTU(可多选)','提示',MB_OK	);
    exit;
  end;

  if (CDSMTUList.FieldByName('ISPAUSE').AsString='否') then
  begin
    if Application.MessageBox(PAnsiChar('将暂停选中MTU的执行计划，确定吗?'), '提示', MB_YESNO) = IDYES then
    begin
      Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,39,WhereCond]),VarArrayOf([1,2,40,WhereCond])]));
      Application.MessageBox('已成功暂停执行计划！','提示',MB_OK	);
    end
    else
      exit;
  end
  else
  begin
    if Application.MessageBox(PAnsiChar('将恢复选中MTU的执行计划，确定吗?'), '提示', MB_YESNO) = IDYES then
    begin
      Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,41,WhereCond]),VarArrayOf([1,2,42,WhereCond])]));
      Application.MessageBox('已成功恢复执行计划！','提示',MB_OK	);   
    end
    else
      exit;
  end;


  {MTUID := CDSMTUList.FieldByName('MTUID').AsInteger;
  if (CDSMTUList.FieldByName('ISPAUSE').AsInteger=0) then
  begin
    if Application.MessageBox(PAnsiChar('将暂停MTU:'+CDSMTUList.FieldByName('MTU名称').AsString+' 执行计划，确定吗?'), '提示', MB_YESNO) = IDYES then
    begin
      Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,39,CurrentModelID,MTUID]),VarArrayOf([1,2,40,CurrentModelID,MTUID])]));
      Application.MessageBox('已成功暂停执行计划！','提示',MB_OK	);
    end
    else
      exit;
  end
  else
  begin
    if Application.MessageBox(PAnsiChar('将恢复MTU:'+CDSMTUList.FieldByName('MTU名称').AsString+' 执行计划，确定吗?'), '提示', MB_YESNO) = IDYES then
    begin
      Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,41,CurrentModelID,MTUID]),VarArrayOf([1,2,42,CurrentModelID,MTUID])]));
      Application.MessageBox('已成功恢复执行计划！','提示',MB_OK	);   
    end
    else
      exit;
  end; }

  RefreshModelTree(CurrentModelID);

  {DSMTUList.DataSet := nil;
  with CDSMTUList do
  begin
    Close;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,1,CurrentModelID]),3);
  end;  
  CDSMTUList.Locate('MTUID', MTUID,[]);
  DSMTUList.DataSet := CDSMTUList; } 
end;

procedure TFrmAlarmTestModel.btJHDeleteClick(Sender: TObject);
var
  MTUID, MTUIDIndex, ModelIDIndex, RecordIndex, I: Integer;
  SelectMTUID, SelectModelID, WhereCond: string;
begin 
  WhereCond := '';
  MTUIDIndex:=cxgtvMTUInfo.GetColumnByFieldName('MTUID').Index;
  ModelIDIndex:=cxgtvMTUInfo.GetColumnByFieldName('ModelID').Index;
  for I := 0 to cxgtvMTUInfo.DataController.GetSelectedCount -1 do
  begin
    RecordIndex :=  cxgtvMTUInfo.DataController.GetSelectedRowIndex(I);
    RecordIndex :=  cxgtvMTUInfo.DataController.FilteredRecordIndex[RecordIndex];
    SelectMTUID := cxgtvMTUInfo.DataController.GetValue(RecordIndex, MTUIDIndex);
    SelectModelID := cxgtvMTUInfo.DataController.GetValue(RecordIndex, ModelIDIndex);  
    WhereCond := WhereCond + ' or (ModelID='+SelectModelID+' and MTUID='+SelectMTUID+')';
  end; 
  if WhereCond = '' then
  begin  
    Application.MessageBox('请选择MTU(可多选)','提示',MB_OK	);
    exit;
  end;   

  MTUID := CDSMTUList.FieldByName('MTUID').AsInteger;
  if Application.MessageBox(PAnsiChar('将删除选中MTU的执行计划，确定吗?'), '提示', MB_YESNO) = IDYES then
  begin
    Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,43,WhereCond]),VarArrayOf([1,2,44,WhereCond])]));
    Application.MessageBox('已成功删除执行计划！','提示',MB_OK	);  
  end
  else
    exit;

  RefreshModelTree(CurrentModelID);
  {DSMTUList.DataSet := nil;
  with CDSMTUList do
  begin
    Close;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,1,CurrentModelID]),3);
  end;  
  CDSMTUList.Locate('MTUID', MTUID,[]);
  DSMTUList.DataSet := CDSMTUList;}
end;

procedure TFrmAlarmTestModel.btRemoveTimeClick(Sender: TObject);
begin
  if not CDSTaskListTime.IsEmpty then
  begin
    DSTaskListTimeDetail.DataSet := nil;
    while True do
    begin
     if CDSTaskListTimeDetail.Locate('ParentID', CDSTaskListTime.FieldByName('ID').AsString, []) then
       CDSTaskListTimeDetail.Delete
     else
       break;
    end;  
    CDSTaskListTime.Delete;
    DSTaskListTimeDetail.DataSet := CDSTaskListTimeDetail;
  end;

  ExpandAllDetail;
end;

procedure TFrmAlarmTestModel.btAddComClick(Sender: TObject);
Var
  I: integer;
begin
  if CDSTaskListTime.IsEmpty then exit;
  
  DSTaskListTimeDetail.DataSet := nil;
  if not CDSTaskListTimeDetail.IsEmpty then
  begin  
    while True do
    begin
     if CDSTaskListTimeDetail.Locate('ParentID', CDSTaskListTime.FieldByName('ID').AsString, []) then
       CDSTaskListTimeDetail.Delete
     else
       break;
    end;
  end;
  for I := 0 to clbModelCom.Items.Count - 1 do
  begin
    if clbModelCom.Checked[I] then
    begin
      CDSTaskListTimeDetail.Append;
      CDSTaskListTimeDetail.FieldByName('ID').AsInteger := -1*(CDSTaskListTimeDetail.RecordCount+1);
      CDSTaskListTimeDetail.FieldByName('ParentID').AsString := CDSTaskListTime.FieldByName('ID').AsString;
      CDSTaskListTimeDetail.FieldByName('ModelID').AsInteger := CDSModel.FieldByName('ModelID').AsInteger;
      CDSTaskListTimeDetail.FieldByName('comid').AsInteger := TCommonObj(clbModelCom.Items.Objects[I]).ID;
      CDSTaskListTimeDetail.FieldByName('comname').AsString := TCommonObj(clbModelCom.Items.Objects[I]).Name;
      CDSTaskListTimeDetail.FieldByName('cyccount').AsInteger := CDSModel.FieldByName('cyccount').AsInteger;
      CDSTaskListTimeDetail.FieldByName('timeinterval').AsInteger := CDSModel.FieldByName('timeinterval').AsInteger;
      CDSTaskListTimeDetail.FieldByName('begintime').AsDateTime := CDSTaskListTime.FieldByName('begintime').AsDateTime;
      CDSTaskListTimeDetail.FieldByName('endtime').AsDateTime := CDSTaskListTime.FieldByName('endtime').AsDateTime;
    end;
  end;

  CDSTaskListTimeDetail.CheckBrowseMode;
  DSTaskListTimeDetail.DataSet := CDSTaskListTimeDetail;
end;

procedure TFrmAlarmTestModel.btAddModelClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
  I,J, NewModelID: Integer;
begin
  if trim(eModelName.EditValue) = '' then
  begin
    Application.MessageBox('测试计划名称不能为空，请输入名称！','提示',MB_OK	);
    exit;
  end;
    try
      with Dm_MTS.cds_common do
      begin
        Close;
        ProviderName:='dsp_General_data1';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,30, trim(eModelName.EditValue)]),1);
      end;
      if Dm_MTS.cds_common.RecordCount > 0 then
      begin
        Application.MessageBox('测试计划名称不可重复！','提示',MB_OK	);
        Exit;
      end;

      with Dm_MTS.cds_common do
      begin
        Close;
        ProviderName:='dsp_General_data1';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,3]),1);
      end; 
      NewModelID := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');
      Dm_MTS.cds_common.Append;
      Dm_MTS.cds_common.FieldByName('ParentModelID').Value := CDSModel.FieldByName('ModelID').Value;
      Dm_MTS.cds_common.FieldByName('ModelID').Value := NewModelID;
      Dm_MTS.cds_common.FieldByName('ModelName').Value := trim(eModelName.EditValue);
      Dm_MTS.cds_common.FieldByName('PLANDATE').AsString := GetWeekChoose;

      with Dm_MTS.cds_Master do
      begin
        Close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,28]),0);
      end;
      if not CDSTaskListTimeDetail.IsEmpty then
      begin
        Dm_MTS.cds_common1.Data := CDSTaskListTimeDetail.Data;
        Dm_MTS.cds_common1.First;
        for I := 0 to Dm_MTS.cds_common1.RecordCount - 1 do
        begin
          Dm_MTS.cds_Master.Append;
          for J := 0 to Dm_MTS.cds_Master.FieldCount - 1 do
            Dm_MTS.cds_Master.Fields[J].Value := Dm_MTS.cds_common1.Fields[J].Value;
          Dm_MTS.cds_Master.FieldByName('ID').Value := Dm_Mts.TempInterface.GetTheSequenceId('MTU_AUTOTEST_TASKID');;
          Dm_MTS.cds_Master.FieldByName('ModelID').Value := NewModelID;
          Dm_MTS.cds_common1.Next;
        end;
      end;

      vCDSArray[0]:=Dm_MTS.cds_common;
      vCDSArray[1]:=Dm_MTS.cds_Master;

      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
        Application.MessageBox('成功生成新测试计划！','提示',MB_OK	);

      RefreshModelTree(NewModelID);
    except
       application.MessageBox('生成新测试计划失败,请检查后重试！', '提示', mb_ok);
    end;  
end;

procedure TFrmAlarmTestModel.btRemoveComClick(Sender: TObject);
begin
 if not CDSTaskListTimeDetail.IsEmpty then
 begin
   if CDSTaskListTimeDetail.FieldByName('ParentID').AsString = CDSTaskListTime.FieldByName('ID').AsString then
     CDSTaskListTimeDetail.Delete;
 end;
end;

procedure TFrmAlarmTestModel.GetTimeData;
begin
  with CDSTaskListTime do
  begin
    Close;
    ProviderName:='dsp_General_data';
    if iFlag = 0 then
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,24,currentModelID]),0)
    else
    begin
      if CDSMTUList.IsEmpty then
      begin
        if not IsEmpty then EmptyDataSet;
      end
      else
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,24,CDSMTUList.FieldByName('ModelID').AsInteger]),0);
    end;
  end;
end;

procedure TFrmAlarmTestModel.GetTimeDetailData;
var
  begintime,endtime: string;
begin
  with CDSTaskListTimeDetail do
  begin
    Close;
    ProviderName:='dsp_General_data';

    case iFlag of
      0:
      begin
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,25,currentModelID]),0);
      end;
      1:
      begin
        if CDSMTUList.IsEmpty then
        begin
         if not IsEmpty then EmptyDataSet;
        end
        else
        begin  
          Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,37,CDSMTUList.FieldByName('ModelID').AsInteger, CDSMTUList.FieldByName('MTUID').AsString]),0);
        end;
      end;
    end;
  end;
end;

function TFrmAlarmTestModel.GetWeekChoose: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to gbWeek.ControlCount - 1 do
  begin
    if TCheckBox(gbWeek.Controls[I]).Checked then
    begin
      if Result <> '' then Result := Result + ',';         
      Result := Result + IntToStr(I+1);
    end;
  end;
    
end;  

procedure TFrmAlarmTestModel.RefreshModelTree(ModelID: Integer);
begin 
  DSModel.DataSet := nil;
  with CDSModel do
  begin
    Close;
    ProviderName:='dsp_General_data6';

    if iFlag=0 then        
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,3]),6)
    else
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,51]),6);    

  end;
  CDSModel.Locate('ModelID', ModelID, [loCaseInsensitive]);
  DSModel.DataSet := CDSModel;    
  tTaskModelTree.SetFocus;

  DSModelType.DataSet := nil;
  CDSModelType.Data := CDSModel.Data;
  DSModelType.DataSet := CDSModelType;

  {DSModelOnly.DataSet := nil;
  CDSModelOnly.Data := CDSModel.Data;  
  CDSModelOnly.Insert;
  CDSModelOnly.Fields[0].Value := 2;
  CDSModelOnly.Fields[1].Value := 0;
  CDSModelOnly.Fields[2].Value := '默认模板';
  CDSModelOnly.Post;
  DSModelOnly.DataSet := CDSModelOnly;}
end;

procedure TFrmAlarmTestModel.SetWeekChoose(PLANDATE: string = '');
var
  I: Integer;
  sWeek: String;
begin
  sWeek := PLANDATE;
  if sWeek='' then
    sWeek := CDSModel.FieldByName('PLANDATE').AsString;       

  for I := 0 to gbWeek.ControlCount - 1 do
    TCheckBox(gbWeek.Controls[I]).Checked := pos(IntToStr(I+1), sWeek) > 0;
end; 

procedure TFrmAlarmTestModel.btNewClick(Sender: TObject);
var
  ModelID, ParengID: String;
begin
  if CDSModel.IsEmpty then
  begin
    CDSModel.Append;
    CDSModel.FieldByName('ParentModelID').AsString := '0';
    CDSModel.FieldByName('ModelID').AsString := '1';
    CDSModel.FieldByName('ModelName').AsString := '测试模板'; 
    //CDSModel.FieldByName('ModelName').AsString := '1';
  end
  else if CDSModel.FieldByName('ParentModelID').AsString = '0' then
  begin
    ParengID := '1';
    ModelID := IntToStr(Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL'));
    CDSModel.Append;
    CDSModel.FieldByName('ParentModelID').AsString := ParengID;
    CDSModel.FieldByName('ModelID').AsString := ModelID;
    CDSModel.FieldByName('ModelName').AsString := '测试模板类型';
  end
  else if CDSModel.FieldByName('ParentModelID').AsString <> '1' then
  begin
    ParengID := CDSModel.FieldByName('ParentModelID').AsString;
  end;
  begin
    ParengID := CDSModel.FieldByName('ModelID').AsString;
    ModelID := IntToStr(Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL'));
    CDSModel.Append;
    CDSModel.FieldByName('ParentModelID').AsString := ParengID;
    CDSModel.FieldByName('ModelID').AsString := ModelID;
    CDSModel.FieldByName('ModelName').AsString := '测试模板';

    CDSModel.FieldByName('CYCCOUNT').AsString := '0';
    CDSModel.FieldByName('BEGINTIME').AsDateTime := StrToTime('00:00');
    CDSModel.FieldByName('ENDTIME').AsDateTime := StrToTime('23:59');
    CDSModel.FieldByName('PlanStartDate').AsDateTime := now;

  end;
  CDSModel.Post;
end;

procedure TFrmAlarmTestModel.btNewTypeClick(Sender: TObject);
var
  ModelType: String;
  vCDSArray: array[0..0] of TClientDataset;
  vDeltaArray, vProviderArray: OleVariant;
begin
  ModelType := InputBox('测试计划类型名称', '请输入新建测试计划类型名称', '');

  if trim(ModelType) <> '' then
  begin
    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,30, ModelType]),1);
    end;

    if Dm_MTS.cds_common.RecordCount > 0 then
    begin
      Application.MessageBox('测试计划类型名称不可重复！','提示',MB_OK	);
      Exit;
    end;

    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,3]),1);
    end;

    CurrentModelID := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');
    Dm_MTS.cds_common.Append;
    Dm_MTS.cds_common.FieldByName('ParentModelID').Value := 1;
    Dm_MTS.cds_common.FieldByName('ModelID').Value := CurrentModelID;
    Dm_MTS.cds_common.FieldByName('ModelName').Value := ModelType;

    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      Application.MessageBox('成功生成测试计划类型！','提示',MB_OK	);

      RefreshModelTree(CurrentModelID);
    except
       application.MessageBox('生成测试计划类型失败, 请检查后重试！', '提示', mb_ok);
    end;

  end;
end;

procedure TFrmAlarmTestModel.btChangeTypeClick(Sender: TObject);
var
  ModelType: String;
  vCDSArray: array[0..0] of TClientDataset;
  vDeltaArray, vProviderArray: OleVariant;
begin
  ModelType := InputBox('测试计划类型名称', '请输入新的测试计划类型名称', '');

  if trim(ModelType) <> '' then
  begin
    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,30, ModelType]),1);
    end;

    if Dm_MTS.cds_common.RecordCount > 0 then
    begin
      if Dm_MTS.cds_common.FieldByName('ModelID').AsInteger <> CDSModel.FieldByName('ModelID').AsInteger then
      begin
        Application.MessageBox('名称已经存在，请重新修改名称！','提示',MB_OK	);
        Exit;
      end;
    end;

    CDSModel.Edit;  
    CDSModel.FieldByName('ModelName').Value := ModelType;

    try
      vCDSArray[0]:=CDSModel;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      Application.MessageBox('成功生成测试计划类型！','提示',MB_OK	);

      RefreshModelTree(CurrentModelID);
    except
       application.MessageBox('生成测试计划类型失败, 请检查后重试！', '提示', mb_ok);
    end;

  end;
end;

procedure TFrmAlarmTestModel.btSaveClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;  
  I,J: Integer;
begin
  if CheckModelSaveValid then
  begin
    Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,26,CurrentModelID])]));

    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,28]),0);
    end;

    if not CDSTaskListTimeDetail.IsEmpty then
    begin 
      Dm_MTS.cds_common1.Data := CDSTaskListTimeDetail.Data;  
      Dm_MTS.cds_common1.First;
      for I := 0 to Dm_MTS.cds_common1.RecordCount - 1 do
      begin
        Dm_MTS.cds_common.Append;
        for J := 0 to Dm_MTS.cds_common.FieldCount - 1 do
          Dm_MTS.cds_common.Fields[J].Value := Dm_MTS.cds_common1.Fields[J].Value;
        Dm_MTS.cds_common.FieldByName('ID').Value := Dm_Mts.TempInterface.GetTheSequenceId('MTU_AUTOTEST_TASKID');;
        Dm_MTS.cds_common1.Next;
      end;
    end;

    CDSModel.Edit;
    CDSModel.FieldByName('PLANDATE').AsString := GetWeekChoose;

    try
      vCDSArray[0]:=CDSModel;
      vCDSArray[1]:=Dm_MTS.cds_common;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
        Application.MessageBox('成功生成任务计划！','提示',MB_OK	);

      RefreshModelTree(CurrentModelID);
    except
       application.MessageBox('生成任务计划失败,请检查后重试！', '提示', mb_ok);
    end;
  end;
end;

procedure TFrmAlarmTestModel.ChangeJHControl(ISPAUSE: boolean);
begin
  if ISPAUSE then
    btJHControl.Caption := '恢复计划'
  else
    btJHControl.Caption := '暂停计划';  
end;

function TFrmAlarmTestModel.CheckModelSaveValid: boolean;
begin
  Result := false;

  if trim(eModelName.EditValue) = '' then
  begin
    Application.MessageBox('名称不能为空，请输入名称！','提示',MB_OK	);
    exit;
  end;  

  {if GetWeekChoose = '' then
  begin
    Application.MessageBox('在每周测试天数请至少选择一天！','提示',MB_OK	);
    exit;
  end;}

  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data1';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,30, trim(eModelName.EditValue)]),1);
  end;

  if Dm_MTS.cds_common.RecordCount > 0 then
  begin
    if Dm_MTS.cds_common.FieldByName('ModelID').AsInteger <> CDSModel.FieldByName('ModelID').AsInteger then
    begin
      Application.MessageBox('名称已经存在，请重新修改名称！','提示',MB_OK	);
      Exit;
    end;   
  end;

  CDSModel.Edit;
  CDSModel.FieldByName('ModelName').Value := trim(eModelName.EditValue);
  CDSModel.FieldByName('ParentModelID').Value := cbModelType.EditValue;

  Result := true;
end;

procedure TFrmAlarmTestModel.btAddClick(Sender: TObject);
var
  lTestGroupid:integer;
  I, J:integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
  try
    Dm_MTS.cds_common.close;
    Dm_MTS.cds_common.ProviderName:='dsp_General_data';
    Dm_MTS.cds_common.Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,63,0]),0);

    Dm_MTS.cds_common1.close;
    Dm_MTS.cds_common1.ProviderName:='dsp_General_data1';
    Dm_MTS.cds_common1.Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,64,0]),1);

    Dm_MTS.cds_HMaster.close;
    Dm_MTS.cds_HMaster.Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,8,CurrentModelID]),2);
    Dm_MTS.cds_Master.close;
    Dm_MTS.cds_Master.Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,9,CurrentModelID]),3);

    for I := 0 to Dm_MTS.cds_HMaster.RecordCount - 1 do
    begin
      Dm_MTS.cds_common.append;
      lTestGroupid:=Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');

      Dm_MTS.cds_common.FieldByName('testgroupid').Value := lTestGroupid;
      Dm_MTS.cds_common.FieldByName('MTUID').Value := Dm_MTS.cds_HMaster.FieldByName('MTUID').Value;
      Dm_MTS.cds_common.FieldByName('comid').Value :=Dm_MTS.cds_HMaster.FieldByName('comid').Value;
      Dm_MTS.cds_common.FieldByName('asktime').Value := Now;
      Dm_MTS.cds_common.FieldByName('time_interval').Value := Dm_MTS.cds_HMaster.FieldByName('timeinterval').Value;
      Dm_MTS.cds_common.FieldByName('curr_cyccount').Value := 0;
      Dm_MTS.cds_common.FieldByName('cyccounts').Value := Dm_MTS.cds_HMaster.FieldByName('cyccount').Value;
      Dm_MTS.cds_common.FieldByName('plandate').Value := Dm_MTS.cds_HMaster.FieldByName('plandate').Value;
      Dm_MTS.cds_common.FieldByName('begintime').Value := Dm_MTS.cds_HMaster.FieldByName('begintime').Value;
      Dm_MTS.cds_common.FieldByName('endtime').Value := Dm_MTS.cds_HMaster.FieldByName('endtime').Value;
      Dm_MTS.cds_common.FieldByName('modelid').Value := currentmodelid;
      Dm_MTS.cds_common.FieldByName('OPERSTATUS').Value := 0;
      Dm_MTS.cds_common.post;

      Dm_MTS.cds_Master.Filter := 'mtuid='+Dm_MTS.cds_HMaster.FieldByName('mtuid').AsString;
      Dm_MTS.cds_Master.Filtered := true;

      for J := 0 to Dm_MTS.cds_Master.RecordCount - 1 do
      begin
        Dm_MTS.cds_common1.Append;
        Dm_MTS.cds_common1.FieldByName('testgroupid').Value := lTestGroupid;
        Dm_MTS.cds_common1.FieldByName('comid').Value := Dm_MTS.cds_Master.FieldByName('comid').Value;
        Dm_MTS.cds_common1.FieldByName('paramid').Value:= Dm_MTS.cds_Master.FieldByName('paramid').Value;
        Dm_MTS.cds_common1.FieldByName('paramvalue').Value:=Dm_MTS.cds_Master.FieldByName('paramvalue').Value;
        Dm_MTS.cds_common1.Post;

        Dm_MTS.cds_Master.Next;
      end;  

      Dm_MTS.cds_HMaster.Next;
    end;

    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vCDSArray[1]:=Dm_MTS.cds_common1;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      Application.MessageBox('操作成功！','提示',MB_OK	);
    except
      application.MessageBox('操作失败！','提示',MB_OK );
    end;
  except
    application.MessageBox('添加异常！','提示',MB_OK );
  end;
end;


procedure TFrmAlarmTestModel.tTaskModelTreeChange(Sender: TObject;
  Node: TTreeNode);
begin   
  CurrentModelID := CDSModel.FieldByName('ModelID').AsInteger;
  if Node.Level=1 then
    SetWeekChoose('1,2,3,4,5,6,7')
  else
    SetWeekChoose;

  if iFlag = 1 then
  begin       
    DSMTUList.DataSet := nil;
    with CDSMTUList do
    begin
      Close;
      if CDSModel.FieldByName('ParentModelID').AsInteger = 0 then
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,50]),3)
      else if CDSModel.FieldByName('ParentModelID').AsInteger = 1 then
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,49,CurrentModelID]),3)
      else
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,1,CurrentModelID]),3);
    end;
    DSMTUList.DataSet := CDSMTUList;
  end;

  if (iFlag = 0) or  ((iFlag = 1) and CDSMTUList.IsEmpty) then
  begin
    GetTimeData;
    ExpandAllDetail;
    GetTimeDetailData;
  end;

  if CDSModel.FieldByName('ParentModelID').AsInteger in [0,1] then
  begin
    eModelName.EditValue := '';
    cbModelType.EditValue := CDSModel.FieldByName('ModelID').AsInteger;
    cbModelType.Enabled := false;
    btSave.Enabled := false;
    btAddTime.Enabled := false;
    btRemoveTime.Enabled := false;
    btAddCom.Enabled := false;
    btRemoveCom.Enabled := false;
  end
  else
  begin
    eModelName.EditValue := CDSModel.FieldByName('ModelName').AsString;
    cbModelType.EditValue := CDSModel.FieldByName('ParentModelID').AsInteger;
    cbModelType.Enabled := true;
    btSave.Enabled := true;
    btAddTime.Enabled := true;
    btRemoveTime.Enabled := true;
    btAddCom.Enabled := true;
    btRemoveCom.Enabled := true;
  end;  
  if CDSModel.FieldByName('ParentModelID').AsInteger <> 0 then
  begin
    btAddTime.Enabled := true;
    btRemoveTime.Enabled := true;
    btAddCom.Enabled := true;
    btRemoveCom.Enabled := true;
  end
  else
  begin
    btAddTime.Enabled := false;
    btRemoveTime.Enabled := false;
    btAddCom.Enabled := false;
    btRemoveCom.Enabled := false;
  end;
  btAddModel.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger = 1;
  eModelName.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger <> 0;
  btDelete.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger <> 0;
  btChangeType.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger = 1;  
end;

procedure TFrmAlarmTestModel.tTaskModelTreeGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
Node.SelectedIndex:= Node.Level;
  Node.ImageIndex:= Node.SelectedIndex;
end;

procedure TFrmAlarmTestModel.cxGridDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
//var
   //CurrentMUTID: String;
begin  
  //模板MTU命令集
 { DSModelCom.DataSet := nil;
  with CDSModelCom do
  begin
    Close;
    if CDSMTUList.IsEmpty then
      CurrentMUTID := '-1'
    else
      CurrentMUTID := CDSMTUList.FieldByName('MTUID').AsString;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,7,CurrentModelID, CurrentMUTID]),2);
  end;
  DSModelCom.DataSet := CDSModelCom;
  //cxGridDBTableView4.ApplyBestFit();     }
end;

procedure TFrmAlarmTestModel.cxgtvMTUInfoCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  lReaded_Index: integer;
begin
  try
    lReaded_Index:=cxgtvMTUInfo.GetColumnByFieldName('ISPAUSE').Index;
  except
    exit;
  end;
  if AViewInfo.GridRecord.Values[lReaded_Index]='是' then
    ACanvas.Brush.Color := $004080FF;
end;

procedure TFrmAlarmTestModel.cxgtvMTUInfoFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
  vPLANDATE: Variant;
begin
  if iFlag = 1 then
  begin
    GetTimeData;
    ExpandAllDetail;
    GetTimeDetailData;

    btJHControl.Enabled := not CDSTaskListTimeDetail.IsEmpty;
    btJHDelete.Enabled := not CDSTaskListTimeDetail.IsEmpty;
    ChangeJHControl(CDSMTUList.FieldByName('ISPAUSE').AsString<>'否'); 

    if (DSMTUList.DataSet <> nil) and not CDSMTUList.IsEmpty then
    begin
      vPLANDATE := CDSModel.Lookup('ModelID', CDSMTUList.FieldByName('ModelID').AsInteger, 'PLANDATE');
      if vPLANDATE <> null then  SetWeekChoose();
    end;
  end;
end;

procedure TFrmAlarmTestModel.cxGridDBTableView4FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
  CurrentTaskID: String;
begin
  //命令参数集
  DSModelComParam.DataSet := nil;
  with CDSModelComParam do
  begin
    Close;
    if CDSModelCom.IsEmpty then
      CurrentTaskID := '-1'
    else
      CurrentTaskID := CDSModelCom.FieldByName('TaskID').AsString;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,6,CurrentTaskID]),1);
  end;
  DSModelComParam.DataSet := CDSModelComParam;
  //cxGridDBTableView2.ApplyBestFit();
end;


procedure TFrmAlarmTestModel.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  iFlag := -1;
end;  






end.
