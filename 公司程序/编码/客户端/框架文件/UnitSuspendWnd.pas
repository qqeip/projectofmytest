unit UnitSuspendWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TeeProcs, TeEngine, Chart, DBClient, Series,
  Buttons;

type
  TFormSuspendWnd = class(TForm)
    Chart_Sm: TChart;
    Label_Move: TLabel;
    Timer_refresh: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer_refreshTimer(Sender: TObject);
  private
    { Private declarations }
    MaxY: double;
    lLeft,lTop, X1,Y1, X2,Y2 : Integer;
    gPoint : TPoint;
    lBool : Boolean;
    procedure DrawFlowLine(aCityID: Integer);
    function GetServerSysDate: TDateTime;
    function GetAreaNodeID(aCityID: Integer): string;
    function GetOraDate(aDate: TDateTime): string;


  public
    { Public declarations }
  end;

var
  FormSuspendWnd: TFormSuspendWnd;

implementation

uses UnitDataModuleLocal, UnitVFMSGlobal;

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
  Achart.BottomAxis.Maximum := 24;
  Achart.BottomAxis.Minimum := 0;
  Achart.BottomAxis.Automatic := true;
  //-----set Left Axis
  Achart.LeftAxis.Grid.Color := clGray;
  Achart.LeftAxis.Grid.Style := psDot;
  AChart.LeftAxis.Grid.Visible := False;
  Achart.LeftAxis.LabelsFont.Color := clNavy;
  Achart.LeftAxis.LabelsFont.Style := [fsBold];
  Achart.LeftAxis.LabelsFont.Name := 'Tahoma';
  AChart.LeftAxis.AxisValuesFormat := '#,##0.####';
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
  AChart.RightAxis.AxisValuesFormat := '#,##0.####';
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

procedure TFormSuspendWnd.FormCreate(Sender: TObject);
var
  a: TPoint;
begin
  ClientToScreen(a);
  a.X := Screen.DesktopWidth - 450;
  a.Y := 50;
  ScreenToClient(a);
  Self.Top := a.Y;
  Self.Left:= a.X;

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
end;

procedure TFormSuspendWnd.FormShow(Sender: TObject);
begin
  Timer_refresh.Interval := 10*60*1000;
  Timer_refresh.Enabled := true;
  //画用户所属city的当天断站率流量图
  DrawFlowLine(gPublicParam.cityid);
end;

procedure TFormSuspendWnd.DrawFlowLine(aCityID: Integer);
var
  ltempDate : TDateTime;
  Hour,Min,Sec,MSec :Word;
  series:TLineSeries;
  lSqlStr, lAreas : string;
  lCurTimescale, I : Integer;
  lClientDataSet : TClientDataSet;
begin
  for I := Chart_Sm.SeriesList.Count - 1 downto 0 do
  begin
    // Tag = 1 当日曲线
    if TLineSeries(Chart_Sm.SeriesList.Items[i]).Tag = 1 then
      Chart_Sm.SeriesList.Delete(i);
  end;

  ltempDate := GetServerSysDate;
  DecodeTime(ltempDate,Hour,Min,Sec,MSec);
  lCurTimescale := Hour*6+ (Min * 10);
  lAreas := GetAreaNodeID(aCityID);
  series := TLineSeries.Create(self);
  series.ParentChart := Chart_Sm;
  series.Title := '断站数量曲线图';           //title变了
  series.Marks.Visible := False;
  series.LinePen.Width := 1;
  series.Tag := 1;

  lClientDataSet:=TClientDataSet.Create(nil);
  with lClientDataSet do
  begin
    close;
    ProviderName:='DataSetProvider';
    lsqlstr:= '{call WD_ALARM_MONITOR_BREAKSITE('+
              GetOraDate(ltempDate)+',1,'+
              inttostr(aCityid)+','+
              lAreas + ',1,' +
              inttostr(lCurTimescale)+
              ',null,null' +
              ')}';
    Data:= DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),1);
    first;
    while not Eof do
    begin
        if MaxY < FieldByName('Y').AsInteger then
          MaxY := FieldByName('Y').AsInteger;
      series.AddXY(FieldByName('X').AsFloat,FieldByName('Y').AsInteger);
      Next;
    end;
  end;

  Chart_Sm.LeftAxis.Automatic := true;
  Chart_Sm.LeftAxis.Maximum :=MaxY;//iDiv*Chart_Sm.LeftAxis.Increment;
  Chart_Sm.BottomAxis.Increment:= 1;
  lClientDataSet.Close;
  lClientDataSet.Free;

  Chart_Sm.AddSeries(series);
end;

function TFormSuspendWnd.GetServerSysDate: TDateTime;
var
  lClientDataSet : TClientDataSet;
begin
  Result := -1;
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,'select sysdate from dual']),0);
      if eof and (RecordCount<>1) then
        Exit
      else
        result:= FieldByName('Sysdate').AsDateTime;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

function TFormSuspendWnd.GetAreaNodeID(aCityID: Integer): string;
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
      Data := DataModuleLocal.TempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      First;
      while not Eof do
      begin
        lArea := lArea + FieldByName('ID').AsString + ',';
        Next;
      end;
    end;
    Result := #39 + Copy(lArea,1,Length(lArea)-1) + #39;
  except
    lClientDataSet.Free;
  end;
end;

function TFormSuspendWnd.GetOraDate(aDate:TDateTime):string;
begin
  Result:='to_date('''+FormatDateTime('yyyy-mm-dd',aDate)+
        ''',''yyyy-mm-dd'')';
end;


procedure TFormSuspendWnd.SpeedButton1Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormSuspendWnd.Timer_refreshTimer(Sender: TObject);
begin
  if not gPublicParam.CanConnSrv then
  begin
    Timer_refresh.Enabled:= false;
    exit;
  end;
  try
    DrawFlowLine(gPublicParam.cityid);
  except
  end;
end;

end.
