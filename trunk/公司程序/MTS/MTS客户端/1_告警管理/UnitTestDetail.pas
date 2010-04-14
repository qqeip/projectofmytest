unit UnitTestDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, TeeProcs,
  TeEngine, Chart,  cxClasses, cxControls,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView,  IniFiles,
  Grids, BaseGrid, AdvGrid, AdvGridUnit,ChartProUnit,ChartTemplateUnit, Series,
  TeeSeriesBandTool, TeeURL, TeeSeriesTextEd, TeeTools, TeePageNumTool, TeeScroB,
  Menus,ComObj;

type
  TMYNodeType = (StateInspect,  //0  状态监控
               PHSTest,      //1  PHS测试
               PHSCallTest,  //2  PHS呼叫测试
               PHSMOSTest,    //3 PHS MOS测试
               PHSSoundTest,  //4 PHS语音单通测试命令
               PHSCalledTest, //5 PHS被叫时延测试命令
               CCHFieldTest,  //6 CCH场强检测通知
               WLANTest,      //7 WLAN测试
               WLANSpeedTest, //8 WLAN速率测试命令
               WLANTenseTest, //9 WLAN时延丢包误码测试命令
               WLANFieldTest,  //10 WLAN场强检测通知
               WLANBreakTest,  //11 WLAN掉线通知
               MTSTest,        //12 MTS测试
               MTSDeviceTest,  //13  MTS设备自身检测通知
               MTUStateQuery   //14  MTU状态查询命令
               );
  TMYNodeParam = class
  public
    aNodeType : TMYNodeType;  //节点类型
    aDisplayName :string;   //显示名称
  end;
  TFormTestDetail = class(TForm)
    Panel1: TPanel;
    PanelTestType: TPanel;
    GroupBox1: TGroupBox;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditMTUNo: TEdit;
    Label3: TLabel;
    EditAlarmCount: TEdit;
    RadioGroup1: TRadioGroup;
    EditRecentCount1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    DateTimePickerStartDate: TDateTimePicker;
    DateTimePickerEndDate: TDateTimePicker;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    EditMTUState: TEdit;
    EditWLANState: TEdit;
    EditPowerState: TEdit;
    Label9: TLabel;
    EditRecentCount2: TEdit;
    BitBtnClose: TBitBtn;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Splitter3: TSplitter;
    TreeView1: TTreeView;
    EditMTUName: TEdit;
    Label11: TLabel;
    EditADDR: TEdit;
    Label10: TLabel;
    EditCover: TEdit;
    EditCalled: TEdit;
    EditPHSNo: TEdit;
    EditLinkNo: TEdit;
    EditBuildingName: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    BitBtnOK: TBitBtn;
    BitBtnOK2: TBitBtn;
    AdvStringGrid1: TAdvStringGrid;
    ChartScrollBar1: TChartScrollBar;
    Chart2: TChart;
    Series1: TBarSeries;
    ChartTool3: TPageNumTool;
    Series2: TBarSeries;
    DateTimePickerStartTime: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure EditRecentCount1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnOK2Click(Sender: TObject);
    procedure Chart2ClickLegend(Sender: TCustomChart; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
  private
    FNodeType : TMYNodeType;
    FAdvGridSet:TAdvGridSet;
    FQueryFlag,FCSScrollMax,FAPScrollMax : Integer;
    FStateCount,FTestCount : string;
    FStartDate,FEndDate : TDate;
    FStartTime,FEndTime : TTime;
    procedure InitiaTree;
    procedure SetControl(IsEdit:Boolean);
    procedure createChart;   //aFlag  0:基站场强  1:AP场强
    procedure ShowCountGrid(aType:TMYNodeType); //aSelectType:1 时间段  0 最近次数
    procedure ShowState;
    procedure ShowNowState;
    procedure ShowNowAlarmCount;
    procedure ShowPHSCall(atablename:string;aCondition:string);
    procedure ShowCCHField(atablename:string;aCondition:string);
    procedure ShowWLANField(atablename:string;aCondition:string);
    procedure GetMTUinfo(aMTUID:Integer);
    procedure GetCount; //1:状态监控次数  2：测试次数
    procedure SaveCount(aTypeFlag:Integer);  //0: 状态监控次数 1: 测试次数
    function ExistTable(atablename:string):Boolean;
    procedure SetGridHead(aHeadName:String);
    function StringGridToExcel(dgrSource: TAdvStringGrid): Integer;
  public
    { Public declarations }
  end;

var
  FormTestDetail: TFormTestDetail;
  lTopNodeinfo : array[0..14] of TMYNodeParam;

implementation
uses Ut_Common, Ut_MainForm, Ut_DataModule, Ut_AlarmTest;
{$R *.dfm}
const
  MAX_SHEET_ROWS = 65536-1;  //Excel每Sheet最大行数
  MAX_VAR_ONCE   = 1000;     //一次导出的条数

procedure TFormTestDetail.BitBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormTestDetail.BitBtnOK2Click(Sender: TObject);
begin
  if EditRecentCount2.Text='' then
  begin
    Application.MessageBox('请输入“最近次数”！','提示',MB_OK);
    Exit;
  end;
  //将最近次数保存
  SaveCount(0);
  FStateCount := EditRecentCount2.Text;
  ShowCountGrid(StateInspect);
  createChart;
end;

procedure TFormTestDetail.BitBtnOKClick(Sender: TObject);
begin
  if RadioGroup1.ItemIndex=0 then   //最近次数
  begin
    if EditRecentCount1.Text='' then
    begin
      Application.MessageBox('请输入"最近次数"！','提示',MB_OK);
      Exit;
    end;
    //将最近次数保存
    SaveCount(1);
    FTestCount := EditRecentCount1.Text;
    FQueryFlag := 0;
    ShowCountGrid(FNodeType);
  end
  else
  begin
    if DateTimePickerStartDate.Date>DateTimePickerEndDate.Date then
    begin
      Application.MessageBox('"开始时间"不能大于"截止时间"，请重输！','提示',MB_OK);
      Exit;
    end;
    if (DateTimePickerEndDate.Date-DateTimePickerStartDate.Date)>10 then
    begin
      Application.MessageBox('"开始时间"与"截止时间"的间隔不能超过10天，请重输！','提示',MB_OK);
      Exit;
    end;
    FQueryFlag := 1;
    FStartDate := DateTimePickerStartDate.Date;
    FEndDate := DateTimePickerEndDate.Date;
    FStartTime := DateTimePickerStartTime.Time;
    FEndTime := DateTimePickerEndTime.Time;
    ShowCountGrid(FNodeType);
  end;
end;

procedure TFormTestDetail.Chart2ClickLegend(Sender: TCustomChart;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Series1.Visible then
  begin
    if FCSScrollMax>5 then    //分页
    begin
      Chart2.MaxPointsPerPage := 5;
      ChartScrollBar1.Visible := True;
      ChartScrollBar1.Min := 1;
      ChartScrollBar1.Max := FCSScrollMax div 5;
      if (FCSScrollMax mod 5)>0 then
         ChartScrollBar1.Max := ChartScrollBar1.Max+1;
      ChartScrollBar1.PageSize := 1;
    end
    else
    begin
      ChartScrollBar1.Visible := false;
      Chart2.MaxPointsPerPage := 0;
    end;
  end;
  if Series2.Visible then
  begin
    if FAPScrollMax>5 then    //分页
      begin
        Chart2.MaxPointsPerPage := 5;
        ChartScrollBar1.Visible := True;
        ChartScrollBar1.Min := 1;
        ChartScrollBar1.Max := FAPScrollMax div 5;
        if (FAPScrollMax mod 5)>0 then
           ChartScrollBar1.Max := ChartScrollBar1.Max+1;
        ChartScrollBar1.PageSize := 1;
      end
      else
      begin
        ChartScrollBar1.Visible := false;
        Chart2.MaxPointsPerPage := 0;
      end;
  end;
end;

procedure TFormTestDetail.createChart;
var
  ltablename : string;
  YValue : Real;
  XValue : String;
  i : Integer;
begin
  //绘制柱状图
  ltablename := 'select * from mtu_testresult_online union all select * from mtu_testresult_history';
  if ExistTable('mtu_testresult_online'+DateToStr(date-2)) then
     ltablename := ltablename+' union all select * from mtu_testresult_online'+DateToStr(date-2);
  if ExistTable('mtu_testresult_online'+DateToStr(date-1)) then
     ltablename := ltablename+' union all select * from mtu_testresult_online'+DateToStr(date-1);
  ltablename := '('+ltablename+')';
  Series1.Clear;
  Series2.Clear;
  //基站最大场强
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,49,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FStateCount]),0);
    if Recordcount>0 then
    begin
      First;
      for I := 0 to Recordcount-1 do
      begin
        YValue := fieldByName('最大场强值').AsFloat;
        XValue := fieldByName('检测时间').asString;
        Next;
        Series1.Add(YValue,XValue);
      end;
      FCSScrollMax := RecordCount;
    end;
    Close;
    //AP最大场强
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,50,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FStateCount]),0);
    if Recordcount>0 then
    begin
      First;
      for I := 0 to Recordcount-1 do
      begin
        YValue := fieldByName('最大场强值').AsFloat;
        XValue := fieldByName('检测时间').asString;
        Next;
        Series2.Add(YValue,XValue);
      end;
      FAPScrollMax := RecordCount;
    end;
    Close;
  end;
end;

procedure TFormTestDetail.EditRecentCount1KeyPress(Sender: TObject;
  var Key: Char);
begin
  InPutNum(Key);
end;

function TFormTestDetail.ExistTable(atablename: string): Boolean;
begin
  Result := False;
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,48,QuotedStr(atablename)]),0);
    if Recordcount>0 then
       Result := True;
    Close;
  end;
end;

procedure TFormTestDetail.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i : Integer;
begin
  for I := 0 to 14 do
     lTopNodeinfo[i].Free;
  FAdvGridSet.Destroy;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormTestDetail:=nil;
  if Assigned(Fm_AlarmTest) and (not Fm_MainForm.assginTab(Fm_AlarmTest)) then
  begin
    Fm_AlarmTest:=nil;
  end;
end;

procedure TFormTestDetail.FormCreate(Sender: TObject);
begin
  FQueryFlag := 0;
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(AdvStringGrid1);
//  FAdvGridSet.SetGridStyle;
  DateTimePickerStartDate.Date := date;
  DateTimePickerEndDate.Date := date;
  DateTimePickerStartTime.Time := Time;
  DateTimePickerEndTime.Time := Time;
  SetControl(False);
end;

procedure TFormTestDetail.FormShow(Sender: TObject);
begin
  InitiaTree;
  //默认告警监控 获取MTU信息
  GetMTUinfo(Fm_AlarmTest.FMTUIDX);
  //获取最近次数
  GetCount;
  //显示当前该MTU状态
  ShowNowState;
  //显示当前告警数
  ShowNowAlarmCount;
  //显示N次数据
  ShowCountGrid(StateInspect);
  //显示柱状图
  createChart;
  if FCSScrollMax>5 then    //分页
  begin
    Chart2.MaxPointsPerPage := 5;
    ChartScrollBar1.Visible := True;
    ChartScrollBar1.Min := 1;
    ChartScrollBar1.Max := FCSScrollMax div 5;
    if (FCSScrollMax mod 5)>0 then
       ChartScrollBar1.Max := ChartScrollBar1.Max+1;
    ChartScrollBar1.PageSize := 1;
  end
  else
  begin
    ChartScrollBar1.Visible := false;
    Chart2.MaxPointsPerPage := 0;
  end;
end;

procedure TFormTestDetail.GetMTUinfo(aMTUID: Integer);
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,36,aMTUID]),0);
    if RecordCount>0 then
    begin
      EditMTUName.Text := FieldByName('mtuname').AsString;
      EditMTUNo.Text := FieldByName('mtuno').AsString;
      EditPHSNo.Text := FieldByName('call').AsString;
      EditCalled.Text := FieldByName('called').AsString;
      EditCover.Text := FieldByName('overlay').AsString;
      EditADDR.Text := FieldByName('mtuaddr').AsString;
//      EditMTUState.Text := FieldByName('mtustatus').AsString;
//      EditPowerState.Text := FieldByName('power_chin').AsString;
//      EditWLANState.Text := FieldByName('wlan_chin').AsString;
      EditLinkNo.Text := FieldByName('linkno').AsString;
      EditBuildingName.Text := FieldByName('buildingname').AsString;
    end;
    close;
  end;

end;

procedure TFormTestDetail.InitiaTree;
var
  i : Integer;
  lStateNode,lPHSNode,lWLANNode,lMTSNode : TTreeNode;
begin
  TreeView1.Items.Clear;
  for I := 0 to 14 do
     lTopNodeinfo[i] := TMYNodeParam.Create;
  lTopNodeinfo[0].aNodeType := StateInspect;
  lTopNodeinfo[0].aDisplayName := '状态监控';
  lTopNodeinfo[1].aNodeType := PHSTest;
//  lTopNodeinfo[1].aDisplayName := 'PHS/CDMA测试';
  lTopNodeinfo[1].aDisplayName := 'CDMA测试';
  lTopNodeinfo[2].aNodeType := PHSCallTest;
//  lTopNodeinfo[2].aDisplayName := 'PHS呼叫测试';
  lTopNodeinfo[2].aDisplayName := '呼叫测试';
  lTopNodeinfo[3].aNodeType := PHSMOSTest;
//  lTopNodeinfo[3].aDisplayName := 'PHS MOS测试';
  lTopNodeinfo[3].aDisplayName := 'MOS测试';
  lTopNodeinfo[4].aNodeType := PHSSoundTest;
//  lTopNodeinfo[4].aDisplayName := 'PHS语音单通测试命令';
  lTopNodeinfo[4].aDisplayName := '语音单通测试命令';
  lTopNodeinfo[5].aNodeType := PHSCalledTest;
//  lTopNodeinfo[5].aDisplayName := 'PHS被叫时延测试命令';
  lTopNodeinfo[5].aDisplayName := '被叫时延测试命令';
  lTopNodeinfo[6].aNodeType := CCHFieldTest;
//  lTopNodeinfo[6].aDisplayName := 'CCH场强检测通知';
  lTopNodeinfo[6].aDisplayName := '场强检测通知';
  lTopNodeinfo[7].aNodeType := WLANTest;
  lTopNodeinfo[7].aDisplayName := 'WLAN测试';
  lTopNodeinfo[8].aNodeType := WLANSpeedTest;
  lTopNodeinfo[8].aDisplayName := 'WLAN速率测试命令';
  lTopNodeinfo[9].aNodeType := WLANTenseTest;
  lTopNodeinfo[9].aDisplayName := 'WLAN时延丢包误码测试命令';
  lTopNodeinfo[10].aNodeType := WLANFieldTest;
  lTopNodeinfo[10].aDisplayName := 'WLAN场强检测通知';
  lTopNodeinfo[11].aNodeType := WLANBreakTest;
  lTopNodeinfo[11].aDisplayName := 'WLAN掉线通知';
  lTopNodeinfo[12].aNodeType := MTSTest;
  lTopNodeinfo[12].aDisplayName := 'MTS测试';
  lTopNodeinfo[13].aNodeType := MTSDeviceTest;
  lTopNodeinfo[13].aDisplayName := 'MTS设备自身检测通知';
  lTopNodeinfo[14].aNodeType := MTUStateQuery;
  lTopNodeinfo[14].aDisplayName := 'MTU状态查询命令';
  lStateNode := TreeView1.Items.AddObject(nil,lTopNodeinfo[0].aDisplayName,lTopNodeinfo[0]);
  lStateNode.SelectedIndex := 0;
  lPHSNode := TreeView1.Items.AddObject(nil,lTopNodeinfo[1].aDisplayName,lTopNodeinfo[1]);
  TreeView1.Items.AddChildObject(lPHSNode,lTopNodeinfo[2].aDisplayName,lTopNodeinfo[2]);
  TreeView1.Items.AddChildObject(lPHSNode,lTopNodeinfo[3].aDisplayName,lTopNodeinfo[3]);
  TreeView1.Items.AddChildObject(lPHSNode,lTopNodeinfo[4].aDisplayName,lTopNodeinfo[4]);
  TreeView1.Items.AddChildObject(lPHSNode,lTopNodeinfo[5].aDisplayName,lTopNodeinfo[5]);
  TreeView1.Items.AddChildObject(lPHSNode,lTopNodeinfo[6].aDisplayName,lTopNodeinfo[6]);
  //lPHSNode.SelectedIndex:=1;
  lWLANNode := TreeView1.Items.AddObject(nil,lTopNodeinfo[7].aDisplayName,lTopNodeinfo[7]);
  TreeView1.Items.AddChildObject(lWLANNode,lTopNodeinfo[8].aDisplayName,lTopNodeinfo[8]);
  TreeView1.Items.AddChildObject(lWLANNode,lTopNodeinfo[9].aDisplayName,lTopNodeinfo[9]);
  TreeView1.Items.AddChildObject(lWLANNode,lTopNodeinfo[10].aDisplayName,lTopNodeinfo[10]);
  TreeView1.Items.AddChildObject(lWLANNode,lTopNodeinfo[11].aDisplayName,lTopNodeinfo[11]);
  //lWLANNode.SelectedIndex:=1;
  lMTSNode := TreeView1.Items.AddObject(nil,lTopNodeinfo[12].aDisplayName,lTopNodeinfo[12]);
  TreeView1.Items.AddChildObject(lMTSNode,lTopNodeinfo[13].aDisplayName,lTopNodeinfo[13]);
  TreeView1.Items.AddChildObject(lMTSNode,lTopNodeinfo[14].aDisplayName,lTopNodeinfo[14]);
  //lMTSNode.SelectedIndex:=1;
  TreeView1.Items[0].Expanded := True;
  TreeView1.Items[1].Expanded := True;
  TreeView1.Items[7].Expanded := True;
  TreeView1.Items[12].Expanded := True;
end;

procedure TFormTestDetail.N1Click(Sender: TObject);
var
  lExcelApp : Variant;
  lFilename : string;
  i,j : Integer;
begin
//  if SaveDialog1.Execute then
//    advstringgrid1.SaveToXLS(saveDialog1.FileName);
  try
    if SaveDialog1.Execute then
       lFilename := SaveDialog1.FileName
    else
       Exit;
    lExcelApp := CreateOleObject('Excel.Application');
    lExcelApp.Visible:= False;
  except
    Application.MessageBox('初始化失败，可能原因：电脑未安装Excel！','提示',MB_OK);
    Exit;
  end;
  Screen.Cursor := crHourGlass;
  lExcelApp.WorkBooks.add;
  for i := 0 to AdvStringGrid1.RowCount - 1 do
  begin
    for j := 1 to AdvStringGrid1.ColCount - 1 do
    begin
      if AdvStringGrid1.ColWidths[j]=0 then
      begin
        Continue;
      end;
      lExcelApp.WorkSheets['Sheet1'].Cells[i+1,j].Value := AdvStringGrid1.Rows[i].Strings[j];
    end;
  end;
  for j := 1 to AdvStringGrid1.ColCount - 1 do
    lExcelApp.WorkSheets['Sheet1'].Columns[j].ColumnWidth := //调整excel中列宽
        Integer(Round(AdvStringGrid1.ColWidths[j] * 2 / abs(AdvStringGrid1.Font.Height)));
  lExcelApp.activeworkbook.Saveas(lFilename+'.xls');
  lExcelApp.ActiveWorkBook.close;
  lExcelApp.Quit;
  lExcelApp := Unassigned;
  Application.MessageBox('保存成功！','提示',MB_OK);
  Screen.Cursor := crDefault;
end;

procedure TFormTestDetail.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex=0 then
  begin
    EditRecentCount1.Enabled := True;
    DateTimePickerStartDate.Enabled := False;
    DateTimePickerEndDate.Enabled := False;
    DateTimePickerStartTime.Enabled := False;
    DateTimePickerEndTime.Enabled := False;
  end
  else
  begin
    EditRecentCount1.Enabled := False;
    DateTimePickerStartDate.Enabled := True;
    DateTimePickerEndDate.Enabled := True;
    DateTimePickerStartTime.Enabled := True;
    DateTimePickerEndTime.Enabled := True;
  end;
end;

procedure TFormTestDetail.GetCount;
var
  linifile : Tinifile ;
  lFileName:string;
  lStringList:TStringList;
begin
  lFileName :=ExtractFileDir(application.ExeName)+'\'+ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');
  linifile := Tinifile.Create(lFileName);
  lStringList := TStringList.Create;
  linifile.ReadSectionValues('RecentCount',lStringList);
  if lStringList.Count<=0 then
  begin
     linifile.WriteString('RecentCount','TestCount','10');
     linifile.WriteString('RecentCount','StatusCount','10');
     EditRecentCount1.Text := '10';
     EditRecentCount2.Text := '10';
  end
  else
  if lStringList.Values['TestCount']='' then
  begin
    linifile.WriteString('RecentCount','TestCount','10');
    EditRecentCount1.Text := '10';
    EditRecentCount2.Text := lStringList.Values['StatusCount'];
  end
  else
  if lStringList.Values['StatusCount']='' then
  begin
    linifile.WriteString('RecentCount','StatusCount','10');
    EditRecentCount2.Text := '10';
    EditRecentCount1.Text := lStringList.Values['TestCount'];
  end
  else
  begin
    EditRecentCount2.Text := lStringList.Values['StatusCount'];
    EditRecentCount1.Text := lStringList.Values['TestCount'];
  end;
  FStateCount := EditRecentCount2.Text;
  FTestCount := EditRecentCount1.Text;
  linifile.Free;
  lStringList.Free;
end;

procedure TFormTestDetail.SaveCount(aTypeFlag: Integer);
var
  linifile : Tinifile ;
  lFileName:string;
begin
  lFileName :=ExtractFileDir(application.ExeName)+'\'+ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');
  linifile := Tinifile.Create(lFileName);
  if aTypeFlag=0 then
     linifile.WriteString('RecentCount','StatusCount',EditRecentCount2.Text);
  if aTypeFlag=1 then
     linifile.WriteString('RecentCount','TestCount',EditRecentCount1.Text);
  linifile.Free;
end;

procedure TFormTestDetail.SetControl(IsEdit: Boolean);
var
  i : integer;
begin
  RadioGroup1.Enabled := IsEdit;
  if RadioGroup1.Enabled=True then
  begin
    if RadioGroup1.ItemIndex=0 then
    begin
      EditRecentCount1.Enabled := True;
      DateTimePickerStartDate.Enabled := False;
      DateTimePickerEndDate.Enabled := False;
      DateTimePickerStartTime.Enabled := False;
      DateTimePickerEndTime.Enabled := False;
    end
    else
    begin
      EditRecentCount1.Enabled := False;
      DateTimePickerStartDate.Enabled := True;
      DateTimePickerEndDate.Enabled := True;
      DateTimePickerStartTime.Enabled := True;
      DateTimePickerEndTime.Enabled := True;
    end;
  end
  else
  begin
    DateTimePickerStartDate.Enabled := False;
    DateTimePickerEndDate.Enabled := False;
    DateTimePickerStartTime.Enabled := False;
    DateTimePickerEndTime.Enabled := False;
  end;
  BitBtnOK.Enabled := IsEdit;
end;

procedure TFormTestDetail.SetGridHead(aHeadName: String);
var
  lHeadList : TStringList;
  i : Integer;
begin
  lHeadList := TStringList.Create;
  lHeadList.CommaText := aHeadName;
  AdvStringGrid1.ColCount := lHeadList.Count+1;
  AdvStringGrid1.RowCount := 1;
  for I := 0 to lHeadList.Count - 1 do
  begin
    AdvStringGrid1.Rows[0].Strings[i+1] := lHeadList.Strings[i];
  end;
  lHeadList.Free;
end;

procedure TFormTestDetail.ShowCCHField(atablename:string;aCondition:string);
var
  i,lrow : Integer;
  ltaskid,ltablename : string;
begin
  AdvStringGrid1.Rows[0].Strings[0] := '';
  AdvStringGrid1.ColCount := 6;
  AdvStringGrid1.RowCount := 1;
  AdvStringGrid1.Rows[0].Strings[1] := '任务编号';
  AdvStringGrid1.Rows[0].Strings[2] := 'MTU编号 ';
  AdvStringGrid1.Rows[0].Strings[3] := '检测类型';
  AdvStringGrid1.Rows[0].Strings[4] := '检测时间';
  AdvStringGrid1.Rows[0].Strings[5] := '检测结果';
  ltaskid := '';
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if FQueryFlag=0 then
       Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,37,atablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0)
    else
       Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,10,atablename,IntToStr(Fm_AlarmTest.FMTUIDX),aCondition]),0);
    if RecordCount>0 then
    begin
      First;
      while not Eof do
      begin
        if ltaskid<>FieldByName('taskid').AsString then
        begin
          AdvStringGrid1.RowCount := AdvStringGrid1.RowCount+1;
          lrow := AdvStringGrid1.RowCount-1;
          ltaskid := FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[0]:=inttostr(lRow);
          AdvStringGrid1.Rows[lRow].Strings[1]:=FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[2]:=FieldByName('mtuno').AsString;
          AdvStringGrid1.Rows[lRow].Strings[3]:=FieldByName('comname').AsString;
          AdvStringGrid1.Rows[lRow].Strings[4]:=FieldByName('collecttime').AsString;
          AdvStringGrid1.Rows[lRow].Strings[5]:=FieldByName('csid').AsString+':'+FieldByName('cchfield').AsString;
        end
        else
        begin
          AdvStringGrid1.Rows[lRow].Strings[5]:=AdvStringGrid1.Rows[lRow].Strings[5]+';'+FieldByName('csid').AsString+':'+FieldByName('cchfield').AsString;
        end;
        Next;
      end;
    end;
    close;
    for I := 1 to AdvStringGrid1.ColCount - 1 do
    begin
      AdvStringGrid1.AutoSizeCol(i);
    end;
  end;
end;

procedure TFormTestDetail.ShowCountGrid(aType: TMYNodeType);
var
  lrow,j : Integer;
  ltablename,lCondition : string;
  i : TDate;
begin
  lCondition := '';
  if FQueryFlag=0 then
  begin
    ltablename := 'select * from mtu_testresult_history union all select * from mtu_testresult_online';
    if ExistTable('mtu_testresult_online'+DateToStr(date-2)) then
       ltablename := ltablename+' union all select * from mtu_testresult_online'+DateToStr(date-2);
    if ExistTable('mtu_testresult_online'+DateToStr(date-1)) then
       ltablename := ltablename+' union all select * from mtu_testresult_online'+DateToStr(date-1);
    ltablename := '('+ltablename+')';
  end;
  if FQueryFlag=1 then
  begin
    if FEndDate>=Date then
      ltablename := 'select * from mtu_testresult_history union all select * from mtu_testresult_online'
    else
      ltablename := 'select * from mtu_testresult_online';
    i := FStartDate;
    while i<=FEndDate do
    begin
      if ExistTable('mtu_testresult_online'+DateToStr(i)) then
         ltablename := ltablename+' union all select * from mtu_testresult_online'+DateToStr(i);
      i := i+1;
    end;
    ltablename := '('+ltablename+')';
    lCondition := ' between to_date('''+FormatDateTime('yyyy-MM-dd',FStartDate)+' '+FormatDateTime('HH:mm',FStartTime)+
                  ''',''yyyy-MM-dd HH24:MI'')'+' and to_date('''+ FormatDateTime('yyyy-MM-dd',FEndDate)+' '+FormatDateTime('HH:mm',FEndTime)+''',''yyyy-MM-dd HH24:MI'')';
  end;
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    case aType of
    PHSMOSTest:
    begin
      if FQueryFlag=0 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,40,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0);
      if FQueryFlag=1 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,1,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),lCondition]),0);
    //  if RecordCount>0 then
         FAdvGridSet.DrawGrid(Dm_MTS.cds_common,Self.AdvStringGrid1);
      if RecordCount=0 then
         SetGridHead('任务编号,MTU编号,测试命令,主叫号码,被叫号码,测试开始时间,测试结束时间,采集时间,通话时长,播放的语音文件,录音产生的语音文件名,测试结果');
    end;
    PHSSoundTest:
    begin
      if FQueryFlag=0 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,41,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0);
      if FQueryFlag=1 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,2,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),lCondition]),0);
    //  if RecordCount>0 then
         FAdvGridSet.DrawGrid(Dm_MTS.cds_common,Self.AdvStringGrid1);
      if RecordCount=0 then
         SetGridHead('任务编号,MTU编号,测试命令,主叫号码,被叫号码,测试开始时间,测试结束时间,采集时间,接入时延,通话时延,通话时长,呼叫结果,语音结果');
    end;
    PHSCalledTest:
    begin
      if FQueryFlag=0 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,42,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0);
      if FQueryFlag=1 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,3,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),lCondition]),0);
    //  if RecordCount>0 then
         FAdvGridSet.DrawGrid(Dm_MTS.cds_common,Self.AdvStringGrid1);
      if RecordCount=0 then
         SetGridHead('任务编号,MTU编号,测试命令,主叫号码,被叫号码,测试开始时间,测试结束时间,接入时延');
    end;
    WLANSpeedTest:
    begin
      if FQueryFlag=0 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,43,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0);
      if FQueryFlag=1 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,4,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),lCondition]),0);
    //  if RecordCount>0 then
         FAdvGridSet.DrawGrid(Dm_MTS.cds_common,Self.AdvStringGrid1);
      if RecordCount=0 then
         SetGridHead('任务编号,MTU编号,测试命令,测试开始时间,测试结束时间,采集时间,测试时长,上传速率,下载速率,测试结果');
    end;
    WLANTenseTest:
    begin
      if FQueryFlag=0 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,44,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0);
      if FQueryFlag=1 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,5,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),lCondition]),0);
    //  if RecordCount>0 then
         FAdvGridSet.DrawGrid(Dm_MTS.cds_common,Self.AdvStringGrid1);
      if RecordCount=0 then
         SetGridHead('任务编号,MTU编号,测试命令,Ping目标地址,测试开始时间,采集时间,测试时长,发送的数据包数,接收到的数据包数,最大时延,最小时延,平均时延,误码率');
    end;
    WLANBreakTest:
    begin
      if FQueryFlag=0 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,45,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0);
      if FQueryFlag=1 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,6,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),lCondition]),0);
    //  if RecordCount>0 then
         FAdvGridSet.DrawGrid(Dm_MTS.cds_common,Self.AdvStringGrid1);
      if RecordCount=0 then
         SetGridHead('任务编号,MTU编号,测试命令,通知时间,采集时间,通知内容');
    end;
    MTSDeviceTest:
    begin
      if FQueryFlag=0 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,46,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0);
      if FQueryFlag=1 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,7,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),lCondition]),0);
 //     if RecordCount>0 then
         FAdvGridSet.DrawGrid(Dm_MTS.cds_common,Self.AdvStringGrid1);
      if RecordCount=0 then
         SetGridHead('任务编号,MTU编号,测试命令,检测时间,采集时间,电源状态');
      //AdvStringGrid1.ColWidths[1] := 0;
    end;
    MTUStateQuery:
    begin
      if FQueryFlag=0 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,47,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0);
      if FQueryFlag=1 then
         Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,8,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),lCondition]),0);
    //  if RecordCount>0 then
         FAdvGridSet.DrawGrid(Dm_MTS.cds_common,Self.AdvStringGrid1);
      if RecordCount=0 then
         SetGridHead('任务编号,MTU编号,测试命令,采集时间,MTU状态');
    end;
    end;
    Close;
  end;
  case aType of
    PHSCallTest:
        ShowPHSCall(ltablename,lCondition);
    CCHFieldTest:
        ShowCCHField(ltablename,lCondition);
    WLANFieldTest:
        ShowWLANField(ltablename,lCondition);
    StateInspect:
        ShowState;
  end;
  AdvStringGrid1.Rows[0].Strings[0] := '';
  for j := 1 to AdvStringGrid1.RowCount - 1 do
  begin
    AdvStringGrid1.Rows[j].Strings[0] := IntToStr(j);
  end;  
 // AdvStringGrid1.ColWidths[1]:=0;
end;

procedure TFormTestDetail.ShowNowAlarmCount;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,22,IntToStr(Fm_AlarmTest.FMTUIDX)]),0);
    if RecordCount>0 then
      EditAlarmCount.Text := FieldByName('alarmcount').AsString
    else
      EditAlarmCount.Text := '0';
    Close;
  end;
end;

procedure TFormTestDetail.ShowNowState;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,21,IntToStr(Fm_AlarmTest.FMTUIDX)]),0);
    if RecordCount>0 then
    begin
      EditMTUState.Text := FieldByName('now_status').AsString;
      EditPowerState.Text := FieldByName('power_status').AsString;
      EditWLANState.Text := FieldByName('wlan_status').AsString;
    end
    else
    begin
      EditMTUState.Text:='未知';
      EditPowerState.Text:='未知';
      EditWLANState.Text:='未知';
    end;
    if EditMTUState.Text='' then
       EditMTUState.Text:='未知';
    if EditPowerState.Text='' then
       EditPowerState.Text:='未知';
    if EditWLANState.Text='' then
       EditWLANState.Text:='未知';
    Close;
  end;
end;

procedure TFormTestDetail.ShowPHSCall(atablename:string;aCondition:string);
var
  i,lrow : Integer;
  ltaskid,ltablename : string;
begin
  AdvStringGrid1.Rows[0].Strings[0] := '';
  AdvStringGrid1.RowCount := 1;
  AdvStringGrid1.ColCount := 17;
  AdvStringGrid1.Rows[0].Strings[1] := '任务编号';
  AdvStringGrid1.Rows[0].Strings[2] := 'MTU编号';
  AdvStringGrid1.Rows[0].Strings[3] := '测试命令';
  AdvStringGrid1.Rows[0].Strings[4] := '主叫号码';
  AdvStringGrid1.Rows[0].Strings[5] := '被叫号码';
  AdvStringGrid1.Rows[0].Strings[6] := '测试开始时间';
  AdvStringGrid1.Rows[0].Strings[7] := '测试结束时间';
  AdvStringGrid1.Rows[0].Strings[8] := '接入时延';
  AdvStringGrid1.Rows[0].Strings[9] := '通话时延';
  AdvStringGrid1.Rows[0].Strings[10] := '通话时长';
  AdvStringGrid1.Rows[0].Strings[11] := '所在基站编号';
  AdvStringGrid1.Rows[0].Strings[12] := '呼叫尝试';
  AdvStringGrid1.Rows[0].Strings[13] := '呼叫结果';
  AdvStringGrid1.Rows[0].Strings[14] := '站间切换次数';
  AdvStringGrid1.Rows[0].Strings[15] := 'TCH切换次数';
  AdvStringGrid1.Rows[0].Strings[16] := '场强和误码率';
  ltaskid := '';
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if FQueryFlag=0 then
       Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,39,atablename,IntToStr(Fm_AlarmTest.FMTUIDX),EditRecentCount1.Text]),0)
    else
       Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,9,atablename,IntToStr(Fm_AlarmTest.FMTUIDX),aCondition]),0);
    if RecordCount>0 then
    begin
      First;
      while not Eof do
      begin
        if ltaskid<>FieldByName('taskid').AsString then
        begin
          AdvStringGrid1.RowCount := AdvStringGrid1.RowCount+1;
          lrow := AdvStringGrid1.RowCount-1;
          ltaskid := FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[0]:=inttostr(lRow);
          AdvStringGrid1.Rows[lrow].Strings[1] := FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lrow].Strings[2] := FieldByName('mtuno').AsString;
          AdvStringGrid1.Rows[lrow].Strings[3] := FieldByName('comname').AsString;
          AdvStringGrid1.Rows[lrow].Strings[4] := FieldByName('call').AsString;
          AdvStringGrid1.Rows[lrow].Strings[5] := FieldByName('called').AsString;
          AdvStringGrid1.Rows[lrow].Strings[6] := FieldByName('starttime').AsString;
          AdvStringGrid1.Rows[lrow].Strings[7] := FieldByName('endtime').AsString;
          AdvStringGrid1.Rows[lrow].Strings[8] := FieldByName('intime').AsString;
          AdvStringGrid1.Rows[lrow].Strings[9] := FieldByName('calltime').AsString;
          AdvStringGrid1.Rows[lrow].Strings[10] := FieldByName('calllong').AsString;
          AdvStringGrid1.Rows[lrow].Strings[11] := FieldByName('lastcsid').AsString;
          AdvStringGrid1.Rows[lrow].Strings[12] := FieldByName('calltest').AsString;
          AdvStringGrid1.Rows[lrow].Strings[13] := FieldByName('callresult').AsString;
          AdvStringGrid1.Rows[lrow].Strings[14] := FieldByName('csswitchcount').AsString;
          AdvStringGrid1.Rows[lrow].Strings[15] := FieldByName('tchswitchcount').AsString;
          AdvStringGrid1.Rows[lrow].Strings[16] := FieldByName('csid').AsString+':'+FieldByName('tchfield').AsString+','+FieldByName('wrongper').AsString;
        end
        else
        begin
          AdvStringGrid1.Rows[lRow].Strings[16]:=AdvStringGrid1.Rows[lRow].Strings[16]+';'+FieldByName('csid').AsString+':'+FieldByName('tchfield').AsString+','+FieldByName('wrongper').AsString;
        end;
        Next;
      end;
    end;
    close;
    for I := 1 to AdvStringGrid1.ColCount - 1 do
    begin
      AdvStringGrid1.AutoSizeCol(i);
    end;
  end;
end;

procedure TFormTestDetail.ShowState;
var
  i,lrow : Integer;
  ltaskid,ltablename : string;
begin
  AdvStringGrid1.Rows[0].Strings[0] := '';
  ltablename := 'select * from mtu_testresult_history union all select * from mtu_testresult_online';
  if ExistTable('mtu_testresult_online'+DateToStr(date-2)) then
     ltablename := ltablename+' union all select * from mtu_testresult_online'+DateToStr(date-2);
  if ExistTable('mtu_testresult_online'+DateToStr(date-1)) then
     ltablename := ltablename+' union all select * from mtu_testresult_online'+DateToStr(date-1);
  ltablename := '('+ltablename+')';
  AdvStringGrid1.ColCount := 6;
  AdvStringGrid1.RowCount := 1;
  AdvStringGrid1.Rows[0].Strings[1] := '任务编号 ';
  AdvStringGrid1.Rows[0].Strings[2] := 'MTU编号 ';
  AdvStringGrid1.Rows[0].Strings[3] := '检测类型';
  AdvStringGrid1.Rows[0].Strings[4] := '检测时间';
  AdvStringGrid1.Rows[0].Strings[5] := '检测结果';
  ltaskid := '';
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,37,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FStateCount]),0);
    if RecordCount>0 then
    begin
      First;
      while not Eof do
      begin
        if ltaskid<>FieldByName('taskid').AsString then
        begin
          AdvStringGrid1.RowCount := AdvStringGrid1.RowCount+1;
          lrow := AdvStringGrid1.RowCount-1;
          ltaskid := FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[0]:=inttostr(lRow);
          AdvStringGrid1.Rows[lRow].Strings[1]:=FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[2]:=FieldByName('mtuno').AsString;
          AdvStringGrid1.Rows[lRow].Strings[3]:=FieldByName('comname').AsString;
          AdvStringGrid1.Rows[lRow].Strings[4]:=FieldByName('collecttime').AsString;
          AdvStringGrid1.Rows[lRow].Strings[5]:=FieldByName('csid').AsString+':'+FieldByName('cchfield').AsString;
        end
        else
        begin
          AdvStringGrid1.Rows[lRow].Strings[5]:=AdvStringGrid1.Rows[lRow].Strings[5]+';'+FieldByName('csid').AsString+':'+FieldByName('cchfield').AsString;
        end;
        Next;
      end;
    end;
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,38,ltablename,IntToStr(Fm_AlarmTest.FMTUIDX),FStateCount]),0);
    if RecordCount>0 then
    begin
      First;
      while not Eof do
      begin
        if ltaskid<>FieldByName('taskid').AsString then
        begin
          AdvStringGrid1.RowCount := AdvStringGrid1.RowCount+1;
          lrow := AdvStringGrid1.RowCount-1;
          ltaskid := FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[0]:=inttostr(lRow);
          AdvStringGrid1.Rows[lRow].Strings[1]:=FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[2]:=FieldByName('mtuno').AsString;
          AdvStringGrid1.Rows[lRow].Strings[3]:=FieldByName('comname').AsString;
          AdvStringGrid1.Rows[lRow].Strings[4]:=FieldByName('collecttime').AsString;
          AdvStringGrid1.Rows[lRow].Strings[5]:=FieldByName('apid').AsString+':'+FieldByName('wlanfield').AsString+','+FieldByName('signid').AsString;
        end
        else
        begin
          AdvStringGrid1.Rows[lRow].Strings[5]:=AdvStringGrid1.Rows[lRow].Strings[5]+';'+FieldByName('apid').AsString+':'+FieldByName('wlanfield').AsString+','+FieldByName('signid').AsString;
        end;
        Next;
      end;
    end;
    Close;
    for I := 1 to AdvStringGrid1.ColCount - 1 do
    begin
      AdvStringGrid1.AutoSizeCol(i);
    end;
  end;
end;

procedure TFormTestDetail.ShowWLANField(atablename:string;aCondition:string);
var
  i,lrow : Integer;
  ltaskid,ltablename : string;
begin
  AdvStringGrid1.Rows[0].Strings[0] := '';
  AdvStringGrid1.ColCount := 6;
  AdvStringGrid1.RowCount := 1;
  AdvStringGrid1.Rows[0].Strings[1] := '任务编号 ';
  AdvStringGrid1.Rows[0].Strings[2] := 'MTU编号 ';
  AdvStringGrid1.Rows[0].Strings[3] := '检测类型';
  AdvStringGrid1.Rows[0].Strings[4] := '检测时间';
  AdvStringGrid1.Rows[0].Strings[5] := '检测结果';
  ltaskid := '';
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if FQueryFlag=0 then
       Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,38,atablename,IntToStr(Fm_AlarmTest.FMTUIDX),FTestCount]),0)
    else
       Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,3,11,atablename,IntToStr(Fm_AlarmTest.FMTUIDX),aCondition]),0);
    if RecordCount>0 then
    begin
      First;
      while not Eof do
      begin
        if ltaskid<>FieldByName('taskid').AsString then
        begin
          AdvStringGrid1.RowCount := AdvStringGrid1.RowCount+1;
          lrow := AdvStringGrid1.RowCount-1;
          ltaskid := FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[0]:=inttostr(lRow);
          AdvStringGrid1.Rows[lRow].Strings[1]:=FieldByName('taskid').AsString;
          AdvStringGrid1.Rows[lRow].Strings[2]:=FieldByName('mtuno').AsString;
          AdvStringGrid1.Rows[lRow].Strings[3]:=FieldByName('comname').AsString;
          AdvStringGrid1.Rows[lRow].Strings[4]:=FieldByName('collecttime').AsString;
          AdvStringGrid1.Rows[lRow].Strings[5]:=FieldByName('apid').AsString+':'+FieldByName('wlanfield').AsString+','+FieldByName('signid').AsString;
        end
        else
        begin
          AdvStringGrid1.Rows[lRow].Strings[5]:=AdvStringGrid1.Rows[lRow].Strings[5]+';'+FieldByName('apid').AsString+':'+FieldByName('wlanfield').AsString+','+FieldByName('signid').AsString;
        end;
        Next;
      end;
    end;
    Close;
    for I := 1 to AdvStringGrid1.ColCount - 1 do
    begin
      AdvStringGrid1.AutoSizeCol(i);
    end;
  end;
end;

function TFormTestDetail.StringGridToExcel(dgrSource: TAdvStringGrid): Integer;
var          //从DBGrid导出到Excel(2005.8.23改进至可以导入几乎无限的数据)
  MyExcel, varCells: Variant;
  MySheet, MyCells, Cell1, Cell2, Range: OleVariant;
  iRow, iCol, iRealCol, iSheetIdx, iVarCount, iCurRow, iFieldCount: integer;
  CurPos: TBookmark;
  DataSet: TDataSet;
  sFieldName: string;
begin
//  DataSet := dgrSource.DataSource.DataSet;
//
//  DataSet.DisableControls;
//  CurPos  := DataSet.GetBookmark;
//  DataSet.First;
//  MyExcel := CreateOleObject('Excel.Application');
//  MyExcel.WorkBooks.Add;
//  MyExcel.Visible := False;
//  if dgrSource.RowCount<= MAX_VAR_ONCE then
//     iVarCount := dgrSource.RowCount
//  else
//     dgrSource.RowCount;
////  if DataSet.RecordCount <= MAX_VAR_ONCE then
////    iVarCount := DataSet.RecordCount
////  else
////    iVarCount := MAX_VAR_ONCE;
//  iFieldCount := dgrSource.ColCount;
////  iFieldCount := dgrSource.Columns.Count;        //对DBGrid，只导出显示的列
//  for iCol:=0 to dgrSource.ColCount-1 do
//    if not dgrSource.ColWidths[iCol]=0 then  //可能有不显示的列 2005.9.10
//      Dec(iFieldCount);
////  for iCol:=0 to dgrSource.Columns.Count-1 do
////    if not dgrSource.Columns[iCol].Visible then  //可能有不显示的列 2005.9.10
////      Dec(iFieldCount);
//  varCells  := VarArrayCreate([1,iVarCount,1,iFieldCount], varVariant);
//  iSheetIdx := 1;
//  iRow      := 0;
//  Result    := 0;
//  while not DataSet.Eof do
//  begin
//    if (iRow = 0) or (iRow > MAX_SHEET_ROWS + 1) then
//    begin          //新增一个Sheet
//      if iSheetIdx <= MyExcel.WorkBooks[1].WorkSheets.Count then
//        MySheet := MyExcel.WorkBooks[1].WorkSheets[iSheetIdx]
//      else
//        MySheet := MyExcel.WorkBooks[1].WorkSheets.Add(NULL, MySheet);//加在后面
//      MyCells := MySheet.Cells;
//      Inc(iSheetIdx);
//      iRow := 1;
//      iRealCol := 0;
//      for iCol := 1 to iFieldCount do
//      begin
//        MySheet.Cells[1, iCol].Font.Bold := True;
//        {MySheet.Select;
//        MySheet.Cells[iRow,iCol].Select;
//        MyExcel.Selection.Font.Bold := true;}//这种方法也可(Sheet.Select不可少)
//        while not dgrSource.ColWidths[iCol]=0 do
//         Inc(iRealCol);          //跳过不可见的列 2005.9.10
//        MySheet.Cells[1, iCol] := dgrSource.Rows[0].Strings[iRealCol];
//        MySheet.Columns[iCol].ColumnWidth := //2005.9.9 以下方法似乎算得还行
//        Integer(Round(dgrSource.ColWidths[iRealCol] * 2
//         / abs(dgrSource.Font.Height)));
//        sFieldName := dgrSource.Columns[iRealCol].FieldName;
//        if (DataSet.FieldByName(sFieldName).DataType = ftString)
//          or (DataSet.FieldByName(sFieldName).DataType = ftWideString) then
//        begin          //对于“字符串”型数据则设Excel单元格为“文本”型
//          MySheet.Columns[iCol].NumberFormatLocal := '@';
//        end;
//        Inc(iRealCol);
//      end;
//      Inc(iRow);
//    end;
//    iCurRow := 1;
//    while not DataSet.Eof do
//    begin
//      iRealCol := 0;
//      for iCol := 1 to iFieldCount do
//      begin
//        while not dgrSource.Columns[iRealCol].Visible do
//          Inc(iRealCol);          //跳过不可见的列 2005.9.10
//        sFieldName := dgrSource.Columns[iRealCol].FieldName;
//        varCells[iCurRow, iCol] := DataSet.FieldByName(sFieldName).AsString;
//        Inc(iRealCol);
//      end;
//      Inc(iRow);
//      Inc(iCurRow);
//      Inc(Result);
//      DataSet.Next;
//      if (iCurRow > iVarCount) or (iRow > MAX_SHEET_ROWS + 1) then
//      begin
//        if Assigned(UpAniInfo) then
//          UpAniInfo(Format('(已导出%d条)', [Result])); //显示已导出条数
//        Application.ProcessMessages;
//        Break;
//      end;
//    end;
//    Cell1 := MyCells.Item[iRow - iCurRow + 1, 1];
//    Cell2 := MyCells.Item[iRow - 1,
//          iFieldCount];
//    Range := MySheet.Range[Cell1 ,Cell2];
//    Range.Value := varCells;
//    if (iRow > MAX_SHEET_ROWS + 1) then     //一个Sheet导出结束
//    begin
//      MySheet.Select;
//      MySheet.Cells[1, 1].Select;    //使得每一Sheet均定位在第一格
//    end;
//    Cell1    := Unassigned;
//    Cell2    := Unassigned;
//    Range    := Unassigned;
//  end;
//  MyCells  := Unassigned;
//  varCells := Unassigned;
//  MyExcel.WorkBooks[1].WorkSheets[1].Select;   //必须先选Sheet  2005.8.23
//  MyExcel.WorkBooks[1].WorkSheets[1].Cells[1,1].Select;
//  MyExcel.Visible := True;
//  MyExcel.WorkBooks[1].Saved := True;
//  MyExcel  := Unassigned;
//  if CurPos <> nil then
//  begin
//    DataSet.GotoBookmark(CurPos);
//    DataSet.FreeBookmark(CurPos);
//  end;
//  DataSet.EnableControls;
end;

procedure TFormTestDetail.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  case TMYNodeParam(node.Data).anodeType of
    StateInspect :
      begin
        SetControl(False);
        Panel7.Visible := True;
        Splitter3.Visible := True;
        Panel5.Visible := True;
        ShowNowState;
        self.AdvStringGrid1.ClearNormalCells;
        AdvStringGrid1.RowCount := 1;
        ShowCountGrid(StateInspect);
      end
    else
    begin
      SetControl(True);
      Panel7.Visible := False;
      Splitter3.Visible := False;
      Panel5.Visible := False;
      self.AdvStringGrid1.ClearNormalCells;
      AdvStringGrid1.RowCount := 1;
      FNodeType := TMYNodeParam(node.Data).anodeType;
      ShowCountGrid(TMYNodeParam(node.Data).anodeType);
    end;
  end;
end;

end.
