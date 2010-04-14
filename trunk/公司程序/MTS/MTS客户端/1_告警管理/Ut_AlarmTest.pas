unit Ut_AlarmTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBThreeStateTree ,AdvGridUnit, ComCtrls, StdCtrls, ExtCtrls, DBClient,
  Grids, BaseGrid, AdvGrid, DB, StringUtils, Spin, Menus;
type
  TFm_AlarmTest = class(TForm)
    Page: TPageControl;
    TabSheet_mtulist: TTabSheet;
    TabSheet_task: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox6: TGroupBox;
    AdvSG_ParaSet: TAdvStringGrid;
    Splitter1: TSplitter;
    GroupBox4: TGroupBox;
    CombComType: TComboBox;
    ButtonSaveCom: TButton;
    GroupBox3: TGroupBox;
    AdvSG_mtuDetail: TAdvStringGrid;
    GroupBox2: TGroupBox;
    AdvSG_Result: TAdvStringGrid;
    Splitter2: TSplitter;
    GroupBox8: TGroupBox;
    CombSelect: TComboBox;
    BtStop: TButton;
    Bt_deleteCom: TButton;
    Bt_comfirmResult: TButton;
    GroupBox5: TGroupBox;
    AdvSG_TaskDetail: TAdvStringGrid;
    TabSheetAutoTestList: TTabSheet;
    Panel5: TPanel;
    Label1: TLabel;
    CombComType2: TComboBox;
    AdvStringGridAutoTest: TAdvStringGrid;
    Panel6: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpinEditInterval: TSpinEdit;
    SpinEditCounts: TSpinEdit;
    ButtonModifyAutoTest: TButton;
    ButtonDelAutotest: TButton;
    ButtonAddToAutoTest: TButton;
    PopupMenuMTU_Detail: TPopupMenu;
    MTU1: TMenuItem;
    ButtonTestDetail: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtStopClick(Sender: TObject);
    procedure ButtonSaveComClick(Sender: TObject);
    procedure CombComTypeChange(Sender: TObject);
    procedure CombSelectChange(Sender: TObject);
    procedure Bt_deleteComClick(Sender: TObject);
    procedure Bt_comfirmResultClick(Sender: TObject);
    procedure AdvSG_ParaSetCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure AdvSG_mtuDetailClick(Sender: TObject);
    procedure AdvSG_TaskDetailClick(Sender: TObject);
    procedure ButtonModifyAutoTestClick(Sender: TObject);
    procedure ButtonDelAutotestClick(Sender: TObject);
    procedure CombComType2Change(Sender: TObject);
    procedure ButtonAddToAutoTestClick(Sender: TObject);
    procedure AdvStringGridAutoTestClick(Sender: TObject);
    procedure MTU1Click(Sender: TObject);
    procedure ButtonTestDetailClick(Sender: TObject);
  private
    { Private declarations }
    FAdvGridSet:TAdvGridSet;
    function GetIndex(aAdvGrid:TAdvStringGrid;aStr:string):integer;
    function  SetCombItems:boolean;
    function DeleteFromGrid(lGrid:TAdvStringGrid):boolean;
    procedure ShowPara(comb:TComboBox;lsg:TAdvStringGrid);
    procedure IniADv;
    procedure SetRowRed(Grid:TAdvStringGrid);
    procedure ReFreshAutoTestGrid(aComid:integer);
    function IsInMtuList(aMtuNo:string):Integer;
    procedure GetMtuComParam(aMtuid,aComid: integer);
  public
    { Public declarations }
    FMTUIDX : Integer;
    gCondition :String;
    gCommandCondition :string;
    procedure RefreshMtu;
    procedure RefreshTask;
  end;

var
  Fm_AlarmTest: TFm_AlarmTest;

implementation

uses Ut_MainForm, Ut_Common, Ut_DataModule, UnitTestParticular;

{$R *.dfm}


procedure TFm_AlarmTest.AdvSG_mtuDetailClick(Sender: TObject);
var
  I: Integer;
  lComid: integer;
begin
  if AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[1]<>'' then
    FMTUIDX := StrToInt(AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[1])
  else
    FMTUIDX := -1;
  lComid:=TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID;
  if (FMTUIDX<>-1) and (lComid<>0) then
  begin
    GetMtuComParam(FMTUIDX,lComid);
  end;
//  for I := 1 to self.AdvSG_ParaSet.RowCount - 1 do
//  begin
//    if StrToIntDef(AdvSG_ParaSet.Rows[i].Strings[3],-1)=1 then
//      AdvSG_ParaSet.Rows[i].Strings[2]:=AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[3];
//    if StrToIntDef(AdvSG_ParaSet.Rows[i].Strings[3],-1)=6 then
//      AdvSG_ParaSet.Rows[i].Strings[2]:=AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[6];
//    if StrToIntDef(AdvSG_ParaSet.Rows[i].Strings[3],-1)=7 then
//      AdvSG_ParaSet.Rows[i].Strings[2]:=AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[7];
//    if (StrToIntDef(AdvSG_ParaSet.Rows[i].Strings[3],-1)=39) or
//    (StrToIntDef(AdvSG_ParaSet.Rows[i].Strings[3],-1)=40) then
//    AdvSG_ParaSet.Rows[i].Strings[2]:=AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[3];
//  end;
end;

procedure TFm_AlarmTest.AdvSG_ParaSetCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if ACol=2 then
    CanEdit:=true
  else
    CanEdit:=false;
end;

procedure TFm_AlarmTest.AdvSG_TaskDetailClick(Sender: TObject);
var
  lstr:string;
begin
  if pos(AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[3],'1,2')<1 then
    BtStop.Enabled:=false
  else
    BtStop.Enabled:=true;
  lstr:=AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[1];
  if lstr='' then
    exit;
  with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,27,lstr]),0);
      FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvSG_Result);
      if Dm_MTS.cds_common.RecordCount>0 then
      begin
        AdvSG_Result.ColCount:=AdvSG_Result.ColCount-2;
        AdvSG_Result.ColWidths[7]:=0;
      end;
    end;
end;

procedure TFm_AlarmTest.AdvStringGridAutoTestClick(Sender: TObject);
begin
  if AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[1]='' then Exit;
  SpinEditInterval.Text:=AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[3];
  SpinEditCounts.Text:=AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[4];
end;

procedure TFm_AlarmTest.BtStopClick(Sender: TObject);
var
  lid:integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
  lFlowTaskid : integer;
begin
  if not ((Page.ActivePage=TabSheet_task) and  (AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[1]<>'')) then
    exit;
    
  if AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[3]='1' then          //删除
  begin
    lid:=strtoint(AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[1]);
    with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,25,lid]),0);
      while not eof  do
        delete;
    end;

    with Dm_MTS.cds_common1 do
    begin
      close;
      ProviderName:='dsp_General_data1';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,62,lid]),1);
      while not eof  do
        delete;
    end;
    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vCDSArray[1]:=Dm_MTS.cds_common1;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;
         application.MessageBox('操作成功！', '提示', mb_ok);
         RefreshTask;
    except
      application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
    end;
  end
  else  if AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[3]='2' then            //生成停止任务
  begin
    try
      //FTaskID:=Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');
      lFlowTaskid:=strtoint(AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[1]);
      with Dm_MTS.cds_common do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,22,0]),0);
        append;
        FieldByName('taskid').Value:=lFlowTaskid;
        FieldByName('paramid').Value:=1;
        FieldByName('paramvalue').Value:=AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[1];
        post;
        append;
        FieldByName('taskid').Value:=lFlowTaskid;
        FieldByName('paramid').Value:=5;
        FieldByName('paramvalue').Value:=AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[14];
        post;
      end;

      with Dm_MTS.cds_common1 do
      begin
        close;
        ProviderName:='dsp_General_data1';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,20,0]),1);
        append;
        FieldByName('TASKID').Value := lFlowTaskid ;
        FieldByName('cityid').Value := strtoint(AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[13]) ;
        FieldByName('mtuid').Value := strtoint(AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[14]) ;
        FieldByName('comid').Value := strtoint(AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[11]) ;
        FieldByName('status').Value := 1 ;
        FieldByName('testresult').Value := '' ;
        FieldByName('asktime').Value := now ;
        FieldByName('rectime').Value := now ;
        FieldByName('userid').Value := Fm_MainForm.PublicParam.userid ;
        post;
      end;

      try
        vCDSArray[0]:=Dm_MTS.cds_common;
        vCDSArray[1]:=Dm_MTS.cds_common1;
        vDeltaArray:=RetrieveDeltas(vCDSArray);
        vProviderArray:=RetrieveProviders(vCDSArray);
        if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
          SysUtils.Abort;
        application.MessageBox('操作成功！', '提示', mb_ok);
        RefreshTask;
      except
        application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
      end;
    finally

    end;
  end;
end;

procedure TFm_AlarmTest.Bt_comfirmResultClick(Sender: TObject);
var
  lid:integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if AdvSG_TaskDetail.Rows[self.AdvSG_TaskDetail.Row].Strings[1]='' then
    begin
      application.MessageBox('请在任务结果页面选择一条任务！', '提示', mb_ok);
      exit;
    end;
  try
    if DeleteFromGrid(AdvSG_TaskDetail) then
    begin
      lid:=strtoint(AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[1]);
      with Dm_MTS.cds_common do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,60,lid]),0);
        while not eof do
        begin
          delete;
        end;
      end;

      try
        vCDSArray[0]:=Dm_MTS.cds_common;
        vDeltaArray:=RetrieveDeltas(vCDSArray);
        vProviderArray:=RetrieveProviders(vCDSArray);
        if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
           SysUtils.Abort;
           application.MessageBox('操作成功！', '提示', mb_ok);
      except
        application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
      end;
    end;
    RefreshTask;
  finally

  end;
end;

procedure TFm_AlarmTest.Bt_deleteComClick(Sender: TObject);
begin
  if AdvSG_TaskDetail.Rows[AdvSG_TaskDetail.Row].Strings[1]='' then
    begin
      application.MessageBox('请在任务信息页面选择一条任务！', '提示', mb_ok);
      exit;
    end;
  DeleteFromGrid(AdvSG_TaskDetail);
  application.MessageBox('操作成功！', '提示', mb_ok);
  RefreshTask;
end;

procedure TFm_AlarmTest.ButtonModifyAutoTestClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
  lTestgroupid:integer;
begin
  if AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[1]='' then Exit;
  lTestgroupid:=StrtoInt(AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[1]);
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,67,lTestgroupid]),0);
    if IsEmpty then Exit;
    Edit;
    FieldByName('time_interval').AsString:=SpinEditInterval.Text;
    FieldByName('cyccounts').AsString:=SpinEditCounts.Text;
    Post;

    try
       vCDSArray[0]:=Dm_MTS.cds_common;
       vDeltaArray:=RetrieveDeltas(vCDSArray);
       vProviderArray:=RetrieveProviders(vCDSArray);
       if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;
        application.MessageBox('保存成功！', '提示', mb_ok);

       AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[3]:=SpinEditInterval.Text;
       AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[4]:=SpinEditCounts.Text;
    except
        application.MessageBox('保存失败！', '提示', mb_ok);
    end;
  end;
end;

procedure TFm_AlarmTest.ButtonAddToAutoTestClick(Sender: TObject);
var
  lTestGroupid:integer;
  I:integer;
  lMtuid : integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
  if (AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[1]='') or (Page.ActivePage<>TabSheet_mtulist) or (AdvSG_ParaSet.Rows[AdvSG_ParaSet.Row].Strings[3]='') then
  begin
    application.MessageBox('请选择一个MTU信息进行操作！', '提示', mb_ok);
    exit;
  end;
  lMtuid:=-1;
  for I := 0 to AdvSG_ParaSet.RowCount-1 do
  begin
    if AdvSG_ParaSet.Rows[i].Strings[3]='1' then   //MTU编号
    begin
      lMtuid:=IsInMtuList(AdvSG_ParaSet.Rows[i].Strings[2]);
      if lMtuid=-1 then
      begin
        Application.MessageBox(pchar('MTU['+AdvSG_ParaSet.Rows[i].Strings[2]+']不在MTU列表内！'),'提示',MB_OK	);
        Exit;
      end
    end else if AdvSG_ParaSet.Rows[i].Strings[3]='39' then   //主叫MTU
    begin
      lMtuid:=IsInMtuList(AdvSG_ParaSet.Rows[i].Strings[2]);
      if lMtuid=-1 then
      begin
        Application.MessageBox(pchar('主叫MTU['+AdvSG_ParaSet.Rows[i].Strings[2]+']不在MTU列表内！'),'提示',MB_OK	);
        Exit;
      end;
    end else if AdvSG_ParaSet.Rows[i].Strings[3]='40' then
    begin
      if IsInMtuList(AdvSG_ParaSet.Rows[i].Strings[2])=-1 then
      begin
        Application.MessageBox(pchar('被叫MTU['+AdvSG_ParaSet.Rows[i].Strings[2]+']不在MTU列表内！'),'提示',MB_OK	);
        Exit;
      end;
    end;
  end;

  lTestGroupid:=Dm_Mts.TempInterface.GetTheSequenceId('mts_normal');
  try
    with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,63,0]),0);
      append;
        FieldByName('testgroupid').Value := lTestGroupid;
        FieldByName('MTUID').Value := lMtuid;
        FieldByName('comid').Value := TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID;
        FieldByName('asktime').Value := Now;
        FieldByName('time_interval').Value := 1;
        FieldByName('curr_cyccount').Value := 0;
        FieldByName('cyccounts').Value := 1;
        FieldByName('OPERSTATUS').Value := 0;
      post;
    end;

    with Dm_MTS.cds_common1 do
    begin
      close;
      ProviderName:='dsp_General_data1';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,64,0]),1);
      for I := 1 to AdvSG_ParaSet.RowCount-1 do
      begin
        Append;
          FieldByName('testgroupid').Value := lTestGroupid;
          FieldByName('comid').Value := TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID;
          FieldByName('paramid').Value:=strtoint(AdvSG_ParaSet.Rows[i].Strings[3]);
          FieldByName('paramvalue').Value:=AdvSG_ParaSet.Rows[i].Strings[2];
        Post;
      end;
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
  end;
end;

procedure TFm_AlarmTest.ButtonDelAutotestClick(Sender: TObject);
var
  lTestgroupid:integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
  if AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[1]='' then Exit;
  lTestgroupid:=StrtoInt(AdvStringGridAutoTest.Rows[AdvStringGridAutoTest.Row].Strings[1]);
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,67,lTestgroupid]),0);
    while not eof do
    begin
      Delete;
    end;
  end;
  with Dm_MTS.cds_common1 do
  begin
    close;
    ProviderName:='dsp_General_data1';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,68,lTestgroupid]),1);
    while not eof do
    begin
      delete;
    end;
  end;

  try
    vCDSArray[0]:=Dm_MTS.cds_common;
    vCDSArray[1]:=Dm_MTS.cds_common1;
    vDeltaArray:=RetrieveDeltas(vCDSArray);
    vProviderArray:=RetrieveProviders(vCDSArray);
    if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
      SysUtils.Abort;

    if AdvStringGridAutoTest.RowCount>2 then
      AdvStringGridAutoTest.RemoveRows(AdvStringGridAutoTest.Row,1)
    else
      AdvStringGridAutoTest.ClearNormalCells;
    AdvStringGridAutoTest.AutoNumberCol(0);
  except
    application.MessageBox('删除失败！', '提示', mb_ok);
  end;
end;

procedure TFm_AlarmTest.ButtonSaveComClick(Sender: TObject);
var
  I: integer;
  lFlowTaskid : integer;
  lCurrentRow : integer;
  lCityid,lMtuid,lComid,lUserid: integer;
  lSelectedCount: integer;
  lsuccess: boolean;
  lVariant: variant;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
  if (AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[1]='') or (Page.ActivePage<>TabSheet_mtulist) or (AdvSG_ParaSet.Rows[AdvSG_ParaSet.Row].Strings[3]='') then
  begin
    application.MessageBox('请选择一个MTU信息进行操作！', '提示', mb_ok);
    exit;
  end;
  //单条
  lSelectedCount:= AdvSG_mtuDetail.Selection.Bottom - AdvSG_mtuDetail.Selection.Top;
  if lSelectedCount=0 then
  begin
    lFlowTaskid:=Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');
    if lFlowTaskid=0 then exit;
    with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,62,lFlowTaskid]),0);
      for I := 1 to AdvSG_ParaSet.RowCount-1  do
      begin
        append;
        FieldByName('taskid').Value:=lFlowTaskid;
        FieldByName('paramid').Value:=strtoint(AdvSG_ParaSet.Rows[i].Strings[3]);
        FieldByName('paramvalue').Value:=AdvSG_ParaSet.Rows[i].Strings[2];
        post;
      end;
    end;
    with Dm_MTS.cds_common1 do
    begin
      close;
      ProviderName:='dsp_General_data1';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,20,lFlowTaskid]),1);
      append;
      FieldByName('TASKID').Value := lFlowTaskid ;
      FieldByName('cityid').Value :=strtoint(AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[GetIndex(AdvSG_mtuDetail,'cityid')]);
      FieldByName('mtuid').Value := strtoint(AdvSG_mtuDetail.Rows[AdvSG_mtuDetail.Row].Strings[GetIndex(AdvSG_mtuDetail,'mtuid')]) ;
      FieldByName('comid').Value := TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID;
      FieldByName('status').Value := 0 ;
      FieldByName('testresult').Value := null ;
      FieldByName('asktime').Value := now ;
      FieldByName('rectime').Value := null ;
      FieldByName('TASKLEVEL').Value := 1 ;
      FieldByName('userid').Value := Fm_MainForm.PublicParam.userid ;
      post;
    end;
    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vCDSArray[1]:=Dm_MTS.cds_common1;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
        Application.MessageBox('成功生成任务！','提示',MB_OK	);
    except
       application.MessageBox('生成任务失败！', '提示', mb_ok);
    end;
  end else
  //多条
  begin
    lUserid:=  Fm_MainForm.PublicParam.userid;
    lComid:= TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID;
    lVariant:= VarArrayCreate([0,(lSelectedCount)*2+1],varVariant);
    for I := 0 to AdvSG_mtuDetail.Selection.Bottom - AdvSG_mtuDetail.Selection.Top do
    begin
      lFlowTaskid:=Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');
      lCurrentRow := AdvSG_mtuDetail.Selection.Top+i;
      lCityid:= strtoint(AdvSG_mtuDetail.Rows[lCurrentRow].Strings[GetIndex(AdvSG_mtuDetail,'cityid')]);
      lMtuid:= strtoint(AdvSG_mtuDetail.Rows[lCurrentRow].Strings[GetIndex(AdvSG_mtuDetail,'mtuid')]) ;
      //添加任务
      lVariant[I*2]:= VarArrayOf([0,2,73,lFlowTaskid,lCityid,lMtuid,lComid,lUserid]);
      //添加参数
      lVariant[I*2+1]:= VarArrayOf([0,2,74,lFlowTaskid,lMtuid,lComid]);
    end;
    lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
      Application.MessageBox('成功生成任务！','提示',MB_OK	)
    else
      application.MessageBox('生成任务失败！', '提示', mb_ok);
  end;
end;

procedure TFm_AlarmTest.ButtonTestDetailClick(Sender: TObject);
begin
  if FMTUIDX=-1 then exit;

  if not assigned(FormTestParticular) then
    FormTestParticular:=TFormTestParticular.Create(nil);
  FormTestParticular.Mtuid:= FMTUIDX;
  FormTestParticular.show;
end;

procedure TFm_AlarmTest.CombComType2Change(Sender: TObject);
var
  lComid:integer;
begin
  if CombComType2.ItemIndex<0 then Exit;
  lComid:=TCommonObj(CombComType2.Items.Objects[CombComType2.ItemIndex]).ID;
  ReFreshAutoTestGrid(lComid);
end;

procedure TFm_AlarmTest.CombComTypeChange(Sender: TObject);
var
  lComid: integer;
begin
  if (CombComType.ItemIndex>-1) and (page.ActivePage=TabSheet_mtulist) then
  begin
//    ShowPara(CombComType,AdvSG_ParaSet);
//    AdvSG_mtuDetailClick(nil);
    //根据MTU和命令加载参数
    lComid:=TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID;
    if (FMTUIDX<>-1) and (lComid<>0) then
    begin
      GetMtuComParam(FMTUIDX,lComid);
    end;
    if (TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID=6)
      or (TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID=8)
      or (TCommonObj(CombComType.Items.Objects[CombComType.ItemIndex]).ID=10) then
    begin
      ButtonAddToAutoTest.Enabled:=false;
    end
    else
    begin
      ButtonAddToAutoTest.Enabled:=true;
    end;
  end;
end;

procedure TFm_AlarmTest.CombSelectChange(Sender: TObject);
var
  lComID:integer;
  lbuildstr:string;
begin
  if (CombSelect.ItemIndex>-1) and (page.ActivePage=TabSheet_task) then
  begin
    lComid:=TCommonObj(CombSelect.Items.Objects[CombSelect.ItemIndex]).ID;
    gCommandCondition := ' and comid='+inttostr(lComid);
    RefreshTask;
  end;
end;

function TFm_AlarmTest.DeleteFromGrid(lGrid: TAdvStringGrid):boolean;
var
  lid:integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
  lid:=strtoint(lGrid.Rows[lGrid.Row].Strings[1]);
  with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,25,lid]),0);
      first;
      while not eof do
      begin
        delete;
      end;
    end;

  with Dm_MTS.cds_common1 do
    begin
      close;
      ProviderName:='dsp_General_data1';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,26,lid]),1);
      first;
      while not eof do
      begin
        delete;
      end;
    end;

   try
     vCDSArray[0]:=Dm_MTS.cds_common;
     vCDSArray[1]:=Dm_MTS.cds_common1;
     vDeltaArray:=RetrieveDeltas(vCDSArray);
     vProviderArray:=RetrieveProviders(vCDSArray);
     if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
       SysUtils.Abort;
       result:=true;
   except
     application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
   end;
end;

procedure TFm_AlarmTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearTStrings(CombComType.Items);
  FAdvGridSet.Free;

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Fm_AlarmTest:=nil;
end;

procedure TFm_AlarmTest.FormCreate(Sender: TObject);
begin
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(AdvSG_TaskDetail);
  FAdvGridSet.AddGrid(AdvStringGridAutoTest);
  FAdvGridSet.AddGrid(AdvSG_Result);
  FAdvGridSet.AddGrid(AdvSG_mtuDetail);
  FAdvGridSet.SetGridStyle;
  AdvSG_mtuDetail.OnGetCellColor:= nil;
  //设置选中颜色
  AdvSG_TaskDetail.SelectionColor:= clMenuHighlight;
  AdvStringGridAutoTest.SelectionColor:= clMenuHighlight;
  AdvSG_Result.SelectionColor:= clMenuHighlight;
  AdvSG_mtuDetail.SelectionColor:= clMenuHighlight;
  AdvSG_ParaSet.SelectionColor:= clMenuHighlight;
  AdvSG_TaskDetail.Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,
                                goHorzLine,goRangeSelect,goDrawFocusSelected,goRowSelect];
  AdvStringGridAutoTest.Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,
                                goHorzLine,goRangeSelect,goDrawFocusSelected,goRowSelect];
  AdvSG_Result.Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,
                                goHorzLine,goRangeSelect,goDrawFocusSelected,goRowSelect];
  AdvSG_mtuDetail.Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,
                                goHorzLine,goRangeSelect,goDrawFocusSelected,goRowSelect];
//  AdvSG_ParaSet.Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,
//                                goHorzLine,goRangeSelect,goDrawFocusSelected,goRowSelect];
  FMTUIDX := -1;
end;


procedure TFm_AlarmTest.FormShow(Sender: TObject);
begin
  page.ActivePage:=TabSheet_mtulist;
  SetCombItems;
//  ShowPara(CombComType,AdvSG_ParaSet);
  GetMtuComParam(-1,-1);
  //初始化列表不显示内容
  gCondition:= ' and 1=2';
  RefreshMtu;
  RefreshTask;
end;

procedure TFm_AlarmTest.ReFreshAutoTestGrid(aComid: integer);
var
  I: integer;
  IsChanged : boolean;
  lTestId : integer;
  lCurrRow : integer;
  lCurrCol : integer;
  lWhereStr : string;
  IsFirstDraw:boolean;
begin
  lTestId := -1;
  lCurrRow := 0;
  lCurrCol := 6;
  IsFirstDraw:=true;
  begin
    AdvStringGridAutoTest.ClearNormalCells;
    AdvStringGridAutoTest.RowCount:=2;
    AdvStringGridAutoTest.ColCount:=7;
    AdvStringGridAutoTest.Cells[1,0]:='';
    AdvStringGridAutoTest.Cells[2,0]:='';
    AdvStringGridAutoTest.Cells[3,0]:='';
    AdvStringGridAutoTest.Cells[4,0]:='';
    AdvStringGridAutoTest.Cells[5,0]:='';
    AdvStringGridAutoTest.Cells[6,0]:='';
    AdvStringGridAutoTest.Cells[7,0]:='';
  end;
  
  With Dm_Mts.cds_common do
  begin
    close;
    if aComid=-1 then
      lWhereStr:='1=1'
    else
      lWhereStr:='a.comid='+inttostr(aComid);
    lWhereStr:= lWhereStr+ ' and a.modelid is null';
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,66,lWhereStr]),0);
    if not IsEmpty then
    begin
      First;
      for I := 0 to Recordcount - 1 do
      begin
        IsChanged := lTestId <> Fieldbyname('testgroupid').AsInteger;
        if (I<>0) and IsChanged then
          IsFirstDraw:=false;
        if IsChanged then
        begin
          lTestId := Fieldbyname('testgroupid').AsInteger;
          AdvStringGridAutoTest.RowCount:=AdvStringGridAutoTest.RowCount+1;
          Inc(lCurrRow);
          lCurrCol := 6;
          AdvStringGridAutoTest.Rows[lCurrRow].Strings[1] := Fieldbyname('testgroupid').AsString;
          AdvStringGridAutoTest.Rows[lCurrRow].Strings[2] := Fieldbyname('comname').AsString;
          AdvStringGridAutoTest.Rows[lCurrRow].Strings[3] := Fieldbyname('time_interval').AsString;
          AdvStringGridAutoTest.Rows[lCurrRow].Strings[4] := Fieldbyname('cyccounts').AsString;
          AdvStringGridAutoTest.Rows[lCurrRow].Strings[5] := Fieldbyname('curr_cyccount').AsString;
          AdvStringGridAutoTest.Rows[0].Strings[6] := Fieldbyname('paramname').AsString;
          AdvStringGridAutoTest.Rows[lCurrRow].Strings[6] := Fieldbyname('paramvalue').AsString;
        end
        else
        begin
          if IsFirstDraw then
            AdvStringGridAutoTest.ColCount:=AdvStringGridAutoTest.ColCount+1;
          Inc(lCurrCol);
          AdvStringGridAutoTest.Rows[0].Strings[lCurrCol]:=Fieldbyname('paramname').AsString;
          AdvStringGridAutoTest.Rows[lCurrRow].Strings[lCurrCol]:=Fieldbyname('paramvalue').AsString;
        end;
        Next;
      end;
      AdvStringGridAutoTest.Cells[1,0]:='自动测试编号';
      AdvStringGridAutoTest.Cells[2,0]:='命令号';
      AdvStringGridAutoTest.Cells[3,0]:='循环间隔';
      AdvStringGridAutoTest.Cells[4,0]:='总循环次数';
      AdvStringGridAutoTest.Cells[5,0]:='当前循环次数';
      AdvStringGridAutoTest.RowCount:=AdvStringGridAutoTest.RowCount-1;
      AdvStringGridAutoTest.AutoNumberCol(0);
      FAdvGridSet.AdjustSize(AdvStringGridAutoTest);
    end
  end;
end;

procedure TFm_AlarmTest.RefreshMtu;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,24,gCondition]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvSG_mtuDetail);
    if RecordCount>0 then
    begin
      if AdvSG_mtuDetail.ColCount>4 then
      begin
        SetRowRed(AdvSG_mtuDetail);
        AdvSG_mtuDetail.ColWidths[AdvSG_mtuDetail.ColCount-1]:=0;
        AdvSG_mtuDetail.ColWidths[AdvSG_mtuDetail.ColCount-2]:=0;
        AdvSG_mtuDetail.ColWidths[AdvSG_mtuDetail.ColCount-3]:=0;
        AdvSG_mtuDetail.ColWidths[AdvSG_mtuDetail.ColCount-4]:=0;
      end;
    end;
  end;
end;

procedure TFm_AlarmTest.RefreshTask;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,25,gCondition+gCommandCondition]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvSG_TaskDetail);
    if AdvSG_TaskDetail.ColCount=15 then
    begin
      AdvSG_TaskDetail.ColWidths[3]:=0;
      AdvSG_TaskDetail.ColWidths[11]:= 0;
      AdvSG_TaskDetail.ColWidths[12]:= 0;
      AdvSG_TaskDetail.ColWidths[13]:= 0;
      AdvSG_TaskDetail.ColWidths[14]:= 0;
    end;
  end;
end;

function TFm_AlarmTest.GetIndex(aAdvGrid: TAdvStringGrid;
  aStr: string): integer;
var
  I: Integer;
begin
  result:=999;
  for I := 0 to aAdvGrid.ColCount - 1 do
    if uppercase(aAdvGrid.Rows[0].Strings[i])=uppercase(aStr) then
    begin
      result:=i;
      break;
    end;
end;

procedure TFm_AlarmTest.GetMtuComParam(aMtuid, aComid: integer);
var
  I: integer;
begin
  AdvSG_ParaSet.Clear;
  IniADv;
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,55,' and mtuid='+inttostr(aMtuid)+' and comid='+inttostr(aComid),'']),0);
    first;
    for I := 1 to recordcount  do
    begin
      AdvSG_ParaSet.Rows[i].Strings[1]:=FieldByName('paramname').AsString;
      AdvSG_ParaSet.Rows[i].Strings[2]:=FieldByName('paramvalue').AsString;
      AdvSG_ParaSet.Rows[i].Strings[3]:=FieldByName('paramid').AsString;
      next;
    end;
    if recordcount>0 then
      AdvSG_ParaSet.RowCount:=recordcount+1
    else
      AdvSG_ParaSet.RowCount:=2;
    close;
  end;
end;

procedure TFm_AlarmTest.IniADv;
begin
  AdvSG_ParaSet.ColWidths[0]:=0;
  AdvSG_ParaSet.ColWidths[3]:=0;
  AdvSG_ParaSet.ColCount:=4;
  AdvSG_ParaSet.ColWidths[1]:=120;
  AdvSG_ParaSet.ColWidths[2]:=200;
  AdvSG_ParaSet.Rows[0].Strings[1]:='参数名称';
  AdvSG_ParaSet.Rows[0].Strings[2]:='参数值';
  AdvSG_ParaSet.RowCount:=2;
end;

function TFm_AlarmTest.IsInMtuList(aMtuNo: string): Integer;
begin
  result:=-1;
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,65,Quotedstr(aMtuNo)]),0);
    if not IsEmpty then
      result:=Fieldbyname('Mtuid').AsInteger;
  end;
end;

procedure TFm_AlarmTest.MTU1Click(Sender: TObject);
begin
  RefreshMtu;
end;

function TFm_AlarmTest.SetCombItems:boolean;
var
  obj :TCommonObj;
begin
  result:=false;
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,19,0]),0);
    if recordcount=0 then
    begin
      result:=false;
      exit;
    end;
    first;
    while not eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID:=FieldByName('comid').Value;
      obj.Name:=FieldByName('comname').Value;
      CombComType.Items.AddObject(obj.Name,obj);
      if (obj.ID<>6) and (obj.ID<>8) and (obj.ID<>10) then
        CombComType2.Items.AddObject(obj.Name,obj);
      CombSelect.Items.AddObject(obj.Name,obj);
      next;
    end;
  end;
  CombComType.ItemIndex:=0;
  CombComType2.ItemIndex:=0;
  CombSelect.ItemIndex:=0;
  result:=true;
end;

procedure TFm_AlarmTest.SetRowRed(Grid:TAdvStringGrid);
var
  I: Integer;
begin
  for I := 1 to Grid.RowCount-1 do
  begin
//    if Strtointdef(Grid.Rows[i].Strings[GetIndex(Grid,'MTU状态')],-1)=0 then
    if Grid.Rows[i].Strings[GetIndex(Grid,'MTU状态')]='下线' then
    begin
      Grid.RowColor[i]:=clred;
    end
    else
    case (i Mod 2) of
    0 : Grid.RowColor[i]:= clMoneyGreen;
    1 : Grid.RowColor[i]:= ClWhite;
    end;
  end;
end;

procedure TFm_AlarmTest.ShowPara(comb:TComboBox;lsg:TAdvStringGrid);
var
  I: integer;
  lint:integer;
begin
  lsg.Clear;
  IniADv;
  lint:=TCommonObj(comb.Items.Objects[comb.ItemIndex]).ID;
  with Dm_MTS.cds_common do                                //show_Grid
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,21,lint]),0);
    first;
    for I := 1 to recordcount  do
    begin
      lsg.Rows[i].Strings[1]:=FieldByName('paramname').AsString;
      lsg.Rows[i].Strings[2]:=FieldByName('paramvalue').AsString;
      lsg.Rows[i].Strings[3]:=FieldByName('paramid').AsString;
      next;
    end;
    if recordcount>0 then
      lsg.RowCount:=recordcount+1
    else
      lsg.RowCount:=2;
    close;
  end;
end;

end.
