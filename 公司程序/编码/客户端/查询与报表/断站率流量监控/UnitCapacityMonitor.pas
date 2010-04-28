unit UnitCapacityMonitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeeProcs, TeEngine, Chart, ComCtrls, cxControls, cxSplitter,
  StdCtrls, Buttons, CheckLst, ExtCtrls, Series,
  DBClient, Menus, Spin, ImgList,ExtDlgs,Math, DB;
type
  PAreaInfo = ^TAreaInfo;
  TAreaInfo = record
    id : integer;
    Name : String;
    TopId : integer;
    layer : Integer;
  end;
type
  TFormCapacityMonitor = class(TForm)
    Panel1: TPanel;
    Rg_DataType: TRadioGroup;
    gb_area: TGroupBox;
    chb_area: TCheckListBox;
    Panel8: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    GroupBox3: TGroupBox;
    dtp_RandomDate: TDateTimePicker;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    Sbt_Lock: TSpeedButton;
    Btn_ToDay: TBitBtn;
    Btn_Compare: TBitBtn;
    Btn_Clear: TBitBtn;
    cxSplitter1: TcxSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel2: TPanel;
    GroupBox4: TGroupBox;
    Panel4: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    Btn_DelSerise: TBitBtn;
    cobo_Series: TComboBox;
    Btn_Save: TBitBtn;
    cobo_avg: TComboBox;
    Btn_Mark: TBitBtn;
    cobo_LineWidth: TComboBox;
    Timer_refresh: TTimer;
    SaveDialog: TSaveDialog;
    Chart_Sm: TChart;
    Label_Move: TLabel;
    DTP_EndTime: TDateTimePicker;
    Label_begin: TLabel;
    Label_End: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_ToDayClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Btn_ClearClick(Sender: TObject);
    procedure cobo_SeriesChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure Btn_DelSeriseClick(Sender: TObject);
    procedure Btn_SaveClick(Sender: TObject);
    procedure Btn_MarkClick(Sender: TObject);
    procedure Timer_refreshTimer(Sender: TObject);
    procedure Btn_CompareClick(Sender: TObject);
    procedure cxSplitter1Moved(Sender: TObject);
    procedure Rg_DataTypeClick(Sender: TObject);
  private
    MaxY : double;
    procedure RefreshTodaySMFlow(iDate: TDateTime; iscompare: boolean; CurTimescale: Integer=0);
    procedure DrawSMFlowLine(aStatDate :TDateTime;aSerie: TChartSeries; aCityID: Integer; aAreaID: string; aStatKind, aCurTimescale: Integer);
    procedure InitArea(aCityID: Integer);
    function GetOraDate(aDate: TDateTime): string;
    procedure HorizScroll(const Percent: Double);
    procedure ScrollAxis(Axis: TChartAxis; const Percent: Double);
    procedure VertScroll(const Percent: Double);
    procedure SetMarkVisable(flag: Boolean; Achart: TChart);
    function GetAreaNodeID(aCityID: Integer): string;
    procedure SetVisible(aBool: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCapacityMonitor: TFormCapacityMonitor;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure SetChartStyle(AChart :TChart);
begin
  //------set Bevel
  AChart.BevelInner := bvLowered;
  AChart.BevelOuter := bvRaised;
  AChart.BevelWidth := 1;
  //------Set BackWall

  AChart.BackWall.Color := $00BCDCF1;
  AChart.BackWall.Dark3D := True;
  AChart.BackWall.Size := 5;
  AChart.Gradient.EndColor := clYellow;
  Achart.Gradient.StartColor := clWhite;
  AChart.Gradient.Visible := False;

  //-----Set Bottom Wall
  AChart.BottomWall.Color := $00FF8000;
  AChart.BottomWall.Dark3D := False;
  AChart.BottomWall.Pen.Visible := False;
  //-----Set Left Wall
  AChart.LeftWall.Color := $00FFA74F;
  AChart.LeftWall.Dark3D := True;
  AChart.LeftWall.Size := 5;
  //-----Set Gradient
  Achart.Gradient.EndColor := clWhite;
  AChart.Gradient.StartColor := $00A50320;
  Achart.Gradient.Visible := True;
  //-----Set Frame
  AChart.Frame.Color := $006F8AAC;
  //AChart.Frame.EndStyle := esRound;
  AChart.Frame.Width := 1;
  AChart.Frame.Visible := True;
  //-----Set Bottom Axis
  Achart.BottomAxis.Grid.Color := clGray;
  Achart.BottomAxis.Grid.Style := psDot;
  AChart.BottomAxis.Grid.SmallDots := True;
  Achart.BottomAxis.LabelsFont.Color := clNavy;
  Achart.BottomAxis.LabelsFont.Style := [fsBold];
  Achart.BottomAxis.LabelsFont.Name := 'Tahoma';

  Achart.BottomAxis.Minimum := 0;
  Achart.BottomAxis.Maximum := 24;
  Achart.BottomAxis.Automatic := true;
  //-----set Left Axis
  Achart.LeftAxis.Grid.Color := clGray;
  Achart.LeftAxis.Grid.Style := psDot;
  AChart.LeftAxis.Grid.Visible := False;
  Achart.LeftAxis.LabelsFont.Color := clNavy;
  Achart.LeftAxis.LabelsFont.Style := [fsBold];
  Achart.LeftAxis.LabelsFont.Name := 'Tahoma';
  AChart.LeftAxis.AxisValuesFormat := '#######0.####';
  Achart.LeftAxis.Title.Font.Style :=[fsBold];
  Achart.LeftAxis.Title.Font.Name := 'Tahoma';
  Achart.LeftAxis.Title.Font.Color := clNavy;
  //-----Set Right Axis
  Achart.RightAxis.Grid.Color := clGray;
  Achart.RightAxis.Grid.Style := psDot;
  AChart.RightAxis.Grid.Visible := False;
  Achart.RightAxis.LabelsFont.Color := clNavy;
  Achart.RightAxis.LabelsFont.Style := [fsBold];
  Achart.RightAxis.LabelsFont.Name := 'Tahoma';
//  AChart.RightAxis.AxisValuesFormat := '#,##0.####';
  AChart.RightAxis.AxisValuesFormat := '#####.##';
  Achart.RightAxis.Title.Font.Style :=[fsBold];
  Achart.RightAxis.Title.Font.Name := 'Tahoma';
  Achart.RightAxis.Title.Font.Color := clNavy;
  //-----set Chart Name Style
  AChart.Title.Text.Clear;
  AChart.Title.Font.Style := [fsBold];
  AChart.Title.Font.Name := 'Tahoma';
  AChart.Title.Font.Color := clNavy;
  //-----set Legend
  AChart.Legend.Alignment := laTop;
  //-----Set 3D
  AChart.View3D := False;
  AChart.View3DOptions.Perspective := 5;
end;

procedure TFormCapacityMonitor.FormCreate(Sender: TObject);
begin
  SetChartStyle(Chart_Sm);
  with Chart_Sm do
  begin
    //X 坐标
    BottomAxis.Automatic :=false;
    BottomAxis.Minimum :=0;
    LeftAxis.Increment := 0.1;
    BottomAxis.Maximum :=24;
    BottomAxis.Title.Caption:='时刻';
    //Y 坐标
    LeftAxis.Automatic := false;
    LeftAxis.Minimum :=0;
    LeftAxis.Increment := 1;
    LeftAxis.Title.Caption:='断站数量';
    SeriesList.Clear;
    Legend.LegendStyle := lsSeries;
  end;

  SaveDialog.Filter :='Bitmp files (*.bmp)|*.BMP|Jpeg files (*.jpg)|*.JPG';
  SaveDialog.DefaultExt := 'bmp';
end;

procedure TFormCapacityMonitor.FormShow(Sender: TObject);
begin
  dtp_RandomDate.DateTime := now;
  DTP_EndTime.DateTime    := Now;
  Timer_refresh.Interval := 30*60*1000;
  Timer_refresh.Enabled := true;
  InitArea(gPublicParam.cityid);
  if chb_area.Count>0 then
    chb_area.Checked[0] := true;
  Btn_ToDayClick(Btn_ToDay);
  PageControl1.ActivePageIndex:=0;
end;

procedure TFormCapacityMonitor.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i : Integer;
begin
  gDllMsgCall(FormCapacityMonitor,1,'','');
end;

procedure TFormCapacityMonitor.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormCapacityMonitor.InitArea(aCityID : Integer);
var
  lClientDataSet : TClientDataSet;
  lSqlStr : string;
  lArea : PAreaInfo;
begin
  try
    lClientDataSet := TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      ProviderName := 'DataSetProvider';
      lSqlStr := ' select * from pop_area where layer in (1,2) and cityid=' +
                 IntToStr(aCityID) +
                 ' order by cityid,layer ';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      First;
      while not Eof do
      begin
        New(lArea);
        lArea.id := FieldByName('id').AsInteger;
        lArea.Name := FieldByName('name').AsString;
        lArea.TopId := FieldByName('Top_ID').AsInteger;
        lArea.layer := FieldByName('Layer').AsInteger;
        chb_area.Items.AddObject(lArea.Name,TObject(lArea));
        Next;
      end;
    end;
  except
    lClientDataSet.Free;
  end;
end;

procedure TFormCapacityMonitor.Btn_ToDayClick(Sender: TObject);
var
  temDate :TDateTime;
  Hour,Min,Sec,MSec :Word;
begin
  temDate := GetServerSysDate;
  DecodeTime(temDate,Hour,Min,Sec,MSec);
  RefreshTodaySMFlow(temDate,false,Hour*6+ (Min div ((cobo_avg.ItemIndex+1)*10)));
end;

procedure TFormCapacityMonitor.RefreshTodaySMFlow(iDate :TDateTime;iscompare:boolean;CurTimescale:Integer);
var
  i,j, lCityID : integer;
  ltitle, lAreaID :String;
  index :integer;
  Area : PAreaInfo;
  series:TLineSeries;
  lConditionValue:String;
  lTimeStr:string;
begin
  //如果是刷新当天数据时要保留比对曲线
  if not iscompare then
  begin
    for I := Chart_Sm.SeriesList.Count - 1 downto 0 do
    begin
      // Tag = 1 当日曲线
      if TLineSeries(Chart_Sm.SeriesList.Items[i]).Tag = 1 then
      begin
        index := cobo_Series.Items.IndexOf(TLineSeries(Chart_Sm.SeriesList.Items[i]).Title);
        if index<>-1 then
          cobo_Series.Items.Delete(index);
        Chart_Sm.SeriesList.Delete(i);
      end;
    end;
    Chart_Sm.Refresh;
    lTimeStr:=FormatDatetime('yyyy年mm月dd日',now);
  end
  else
    lTimeStr:=FormatDatetime('yyyy年mm月dd日',dtp_RandomDate.DateTime);
  for I := 0 to chb_area.Count - 1 do
  begin
    if chb_area.Checked[i] then
    begin
      Area := PAreaInfo(chb_area.Items.Objects[i]);
      if Area.layer=1 then
      begin
        lCityID := Area.id;
        lAreaID := GetAreaNodeID(lCityID);
      end
      else
      begin
        lCityID := Area.TopId;
        lAreaID := IntToStr(Area.id);
      end;
      ltitle := lTimeStr+' '+Area.Name;
      lConditionValue:='';
      lConditionValue:=lConditionValue+inttostr(Area.id)+'-';
      lConditionValue:=lConditionValue+inttostr(Rg_DataType.ItemIndex+1)+'-';
      lConditionValue:='['+copy(lConditionValue,1,length(lConditionValue)-1)+']';
      index := cobo_Series.Items.IndexOf(ltitle+lConditionValue);
      //如果已经有曲线，先删除再加载
      if index <> -1 then
      begin
        cobo_Series.ItemIndex := index;
        Chart_Sm.SeriesList.Remove(cobo_Series.Items.Objects[cobo_Series.ItemIndex]);
        cobo_Series.DeleteSelected;
        cobo_Series.ItemIndex :=-1;
        cobo_Series.Text :='';
      end;
      series:=TLineSeries.Create(self);
      series.ParentChart:= Chart_Sm;
      series.Title := ltitle+lConditionValue;           //title变了
      series.Marks.Visible := (Btn_Mark.Tag=1);
      series.LinePen.Width:=cobo_LineWidth.ItemIndex+1;
      if not iscompare then
        series.Tag := 1;  // 当日曲线标识
      DrawSMFlowLine(iDate,series,lCityID, lAreaID, Rg_DataType.ItemIndex+1, CurTimescale);
      series.Marks.Style:= smsValue;
      Chart_Sm.AddSeries(series);
      //series 加入 可删除列表中
      cobo_Series.Items.AddObject(series.Title,series);
    end;
  end;
end;

procedure TFormCapacityMonitor.DrawSMFlowLine(aStatDate :TDateTime;aSerie: TChartSeries; aCityID: Integer; aAreaID: string; aStatKind, aCurTimescale: Integer);
var
  lsqlstr :String;
  lClientDataSet:TClientDataSet;
begin
  try
  lClientDataSet:=TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      close;
      ProviderName:='DataSetProvider';
      if Rg_DataType.ItemIndex=0 then
      begin
        lsqlstr:= '{call WD_ALARM_MONITOR_BREAKSITE('+
                  GetOraDate(aStatDate)+','+
                  inttostr(aStatKind)+','+
                  inttostr(aCityid)+','+
                  aAreaID + ',' +
                  inttostr(cobo_avg.ItemIndex+1)+','+
                  inttostr(aCurTimescale)+
                  ',null,null' +
                  ')}';
      end
      else
        lsqlstr := '{call WD_ALARM_MONITOR_BREAKSITE('+
                  'null,'+
                  inttostr(aStatKind)+','+
                  inttostr(aCityid)+','+
                  aAreaID + ',' +
                  inttostr(cobo_avg.ItemIndex+1)+','+
                  inttostr(aCurTimescale)+','+
                  GetOraDate(aStatDate)+',' +
                  GetOraDate(DTP_EndTime.DateTime) +
                  ')}';

      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),1);
      first;
      while not Eof do
      begin
        if MaxY < FieldByName('Y').AsInteger then
          MaxY := FieldByName('Y').AsInteger;
        aSerie.AddXY(RoundTo(FieldByName('X').AsFloat,-1),FieldByName('Y').AsInteger);
        Next;
      end;
    end;
    // Y轴 增长＝100
    //iDiv := ceil(MaxY/Chart_Sm.LeftAxis.Increment);
    Chart_Sm.LeftAxis.Automatic := true;
    Chart_Sm.LeftAxis.Maximum :=MaxY;//iDiv*Chart_Sm.LeftAxis.Increment;
    Chart_Sm.BottomAxis.Increment:= 1;
  except
    Application.MessageBox('统计失败！','提示',MB_OK);
  end;
  finally
  lClientDataSet.Free;
  end;
end;

function TFormCapacityMonitor.GetAreaNodeID(aCityID: Integer): string;
var
  lClientDataSet : TClientDataSet;
  lSqlStr, lArea : string;
begin
  try
    lClientDataSet := TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      ProviderName := 'DataSetProvider';
      lSqlStr := 'select ID from pop_area where layer=2 and cityid=' + IntToStr(aCityID);
      Data := gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      First;
      while not Eof do
      begin
        lArea := lArea + FieldByName('ID').AsString + ',';
        Next;
      end;
    end;
    Result := #39 + Copy(lArea,1,Length(lArea)-1) + #39;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCapacityMonitor.HorizScroll(const Percent: Double);
begin
  ScrollAxis(Chart_Sm.TopAxis,Percent);
  ScrollAxis(Chart_Sm.BottomAxis,Percent);
end;

procedure TFormCapacityMonitor.VertScroll(const Percent: Double);
begin
  ScrollAxis(Chart_Sm.LeftAxis,Percent);
  ScrollAxis(Chart_Sm.RightAxis,Percent);
end;

procedure TFormCapacityMonitor.ScrollAxis(Axis: TChartAxis;
  const Percent: Double);
var
  Amount:Double;
begin
  With Axis do
  begin
    Amount:=-((Maximum-Minimum)/(100.0/Percent));
    SetMinMax(Minimum-Amount,Maximum-Amount);
  end;
end;

function TFormCapacityMonitor.GetOraDate(aDate:TDateTime):string;
begin
  Result:='to_date('''+FormatDateTime('yyyy-mm-dd',aDate)+
        ''',''yyyy-mm-dd'')';
end;

procedure TFormCapacityMonitor.SpeedButton2Click(Sender: TObject);
var
  i :integer;
begin
  for i := 0 to chb_area.Count-1 do
    chb_area.Checked[i] := true;
end;

procedure TFormCapacityMonitor.SpeedButton3Click(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to chb_area.Count -1 do
    chb_area.Checked[i] := not chb_area.Checked[i];
end;

procedure TFormCapacityMonitor.Btn_ClearClick(Sender: TObject);
var
  i :integer;
begin
  Chart_Sm.SeriesList.Clear;
  for i := cobo_Series.Items.Count-1 downto 0 do
      cobo_Series.Items.Delete(i);
  Chart_Sm.Refresh;
end;

procedure TFormCapacityMonitor.cobo_SeriesChange(Sender: TObject);
begin
  Timer_refresh.Enabled := false;
  Timer_refresh.Interval := (TComboBox(Sender).ItemIndex+1)*600*1000;
  Timer_refresh.Enabled := true;
end;

procedure TFormCapacityMonitor.BitBtn1Click(Sender: TObject);
begin
  Chart_Sm.ZoomPercent(120);
end;

procedure TFormCapacityMonitor.BitBtn3Click(Sender: TObject);
begin
  Chart_Sm.ZoomPercent(80);
end;

procedure TFormCapacityMonitor.BitBtn4Click(Sender: TObject);
begin
  Chart_Sm.UndoZoom;
end;

procedure TFormCapacityMonitor.BitBtn5Click(Sender: TObject);
begin
  HorizScroll(-10);
end;

procedure TFormCapacityMonitor.BitBtn7Click(Sender: TObject);
begin
  HorizScroll(+10);
end;

procedure TFormCapacityMonitor.BitBtn8Click(Sender: TObject);
begin
  VertScroll(-10);
end;

procedure TFormCapacityMonitor.BitBtn6Click(Sender: TObject);
begin
  VertScroll(10);
end;

procedure TFormCapacityMonitor.Btn_DelSeriseClick(Sender: TObject);
begin
  if cobo_Series.ItemIndex = -1  then
  begin
    Application.MessageBox('请选择一项！','提示',MB_OK	);
    Exit;
  end;
  if application.MessageBox('确定要删除吗?', '提示', mb_okcancel) = idok then
  begin
    Chart_Sm.SeriesList.Remove(cobo_Series.Items.Objects[cobo_Series.ItemIndex]);
    cobo_Series.DeleteSelected;
    cobo_Series.ItemIndex :=-1;
    cobo_Series.Text :='';
    Chart_Sm.Refresh;
  end;
end;

procedure TFormCapacityMonitor.Btn_SaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    Chart_Sm.SaveToBitmapFile(SaveDialog.FileName);
end;

procedure TFormCapacityMonitor.Btn_MarkClick(Sender: TObject);
begin
  with TButton(Sender) do
  begin
    if Tag=1 then
    begin
      Tag :=2;
      Hint :='显示标注';
      SetMarkVisable(false,Chart_Sm);
    end
    else
    begin
      Tag :=1;
      Hint :='隐藏标注';
      SetMarkVisable(true,Chart_Sm);
    end;
  end;
end;

procedure TFormCapacityMonitor.SetMarkVisable(flag :Boolean;Achart :TChart);
var
  i :integer;
begin
  for i := 0 to Achart.SeriesList.Count- 1 do
    TLineSeries(Achart.SeriesList.Items[i]).Marks.Visible := flag;
end;

procedure TFormCapacityMonitor.Timer_refreshTimer(Sender: TObject);
var
  temDate :TDateTime;
  Hour,Min,Sec,MSec :Word;
begin
  if not Sbt_Lock.Down then
  begin
    temDate := GetServerSysDate;
    DecodeTime(temDate,Hour,Min,Sec,MSec);
    RefreshTodaySMFlow(temDate,false,Hour*6+ (Min div ((cobo_avg.ItemIndex+1)*10)));
  end;
end;

procedure TFormCapacityMonitor.Btn_CompareClick(Sender: TObject);
var
  iDate, lEndDate :TDateTime;
  MinDate, MaxDate : Integer;
begin
  if Rg_DataType.ItemIndex =1 then
     with Chart_Sm do
     begin
//       Chart_Sm.SeriesList.Clear;
       BottomAxis.Automatic :=false;
       MinDate := StrToInt(FormatDateTime('yyyymmdd',dtp_RandomDate.Date));
       MaxDate := StrToInt(FormatDateTime('yyyymmdd',DTP_EndTime.Date));
       BottomAxis.Maximum := MaxDate;
       BottomAxis.Minimum := MinDate;
       LeftAxis.Increment := 1;

     end;
  iDate := dtp_RandomDate.Date;
  RefreshTodaySMFlow(iDate,true);
end;

procedure TFormCapacityMonitor.cxSplitter1Moved(Sender: TObject);
begin
  if panel1.Width < 185 then
    Panel1.Width := 185;
end;

procedure TFormCapacityMonitor.SetVisible(aBool: Boolean);
begin
  Label_begin.Visible := aBool;
  Label_End.Visible   := aBool;
  DTP_EndTime.Visible := aBool;
  Btn_ToDay.Enabled   := (not aBool);
end;

procedure TFormCapacityMonitor.Rg_DataTypeClick(Sender: TObject);
begin
  if Rg_DataType.ItemIndex=0 then
  begin
    SetVisible(False);
    Btn_Compare.Caption := '某日对比';
    Chart_Sm.SeriesList.Clear;
    SetChartStyle(Chart_Sm);
    with Chart_Sm do
    begin
      //X 坐标
      BottomAxis.Automatic :=false;
      BottomAxis.Maximum :=24;
      BottomAxis.Minimum :=0;
      LeftAxis.Increment := 0.1;
      BottomAxis.Title.Caption:='时刻';
      //Y 坐标
      LeftAxis.Automatic := false;
      LeftAxis.Minimum :=0;
      LeftAxis.Increment := 1;
      LeftAxis.Title.Caption:='断站数量';
      Legend.LegendStyle := lsSeries;
    end;
  end
  else
  begin
    SetVisible(True);
    Btn_Compare.Caption := '累计对比';
    Chart_Sm.SeriesList.Clear;
    SetChartStyle(Chart_Sm);
    with Chart_Sm do
    begin
      //X 坐标
      BottomAxis.Automatic :=false;
//      BottomAxis.Minimum :=0;
//      LeftAxis.Increment := 1;
////      BottomAxis.Maximum :=24;
      BottomAxis.Title.Caption:='日期';
      //Y 坐标
      LeftAxis.Automatic := false;
      LeftAxis.Minimum :=0;
      LeftAxis.Increment := 1;
      LeftAxis.Title.Caption:='断站数量';
      Legend.LegendStyle := lsSeries;
    end;

  end;
end;

end.
