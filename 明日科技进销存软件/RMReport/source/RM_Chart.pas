
{*****************************************}
{                                         }
{         Report Machine v2.0             }
{           Chart Add-In Object           }
{                                         }
{*****************************************}

unit RM_Chart;

interface

{$I RM.inc}

{$IFDEF TeeChart}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Menus, Buttons, RM_Common, RM_Class, RM_Ctrls,
  TeeProcs, TeEngine, Chart, Series
{$IFDEF USE_INTERNAL_JVCL}, rm_JvInterpreter{$ELSE}, JvInterpreter{$ENDIF}
{$IFDEF Delphi6}
  , Variants, ImgList
{$ENDIF};

type

  TRMChartObject = class(TComponent) // fake component
  end;

  TRMChartSeries = class
  private
    FLegendView, FValueView, FLabelView, FTop10Label: string;
    FTitle: string;
    FColor: TColor;
    FChartType: Byte;
    FShowMarks, FColored: Boolean;
    FMarksStyle: Byte;
    FTop10Num: Integer;
  protected
  public
    constructor Create;
  published
    property LegendView: string read FLegendView write FLegendView;
    property ValueView: string read FValueView write FValueView;
    property LabelView: string read FLabelView write FLabelView;
    property Top10Label: string read FTop10Label write FTop10Label;
    property Title: string read FTitle write FTitle;
    property Color: TColor read FColor write FColor;
    property ChartType: Byte read FChartType write FChartType;
    property ShowMarks: Boolean read FShowMarks write FShowMarks;
    property Colored: Boolean read FColored write FColored;
    property MarksStyle: Byte read FMarksStyle write FMarksStyle;
    property Top10Num: Integer read FTop10Num write FTop10Num;
  end;

  {TRMChartView}
  TRMChartView = class(TRMReportView)
  private
    FPrintType: TRMPrintMethodType;
    FChart: TChart;
    FPicture: TMetafile;
    FList: TList;
    FChartDim3D, FChartShowLegend, FChartShowAxis: Boolean;
    FSaveMemo: string;

    function GetUseChartSetting: Boolean;
    procedure SetUseChartSetting(Value: Boolean);
    procedure ShowChart;
    function GetSeries(Index: Integer): TRMChartSeries;
    function GetDirectDraw: Boolean;
    procedure SetDirectDraw(Value: Boolean);
  protected
    procedure Prepare; override;
    procedure PlaceOnEndPage(aStream: TStream); override;
    function GetViewCommon: string; override;
    procedure ClearContents; override;
    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
      Args: array of Variant): Boolean; override;
    procedure OnHook(aView: TRmView); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    function SeriesCount: Integer;
    function AddSeries: TRMChartSeries;
    procedure DeleteSeries(Index: Integer);

    procedure Draw(aCanvas: TCanvas); override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure DefinePopupMenu(Popup: TRMCustomMenuItem); override;
    procedure ShowEditor; override;
    procedure AssignChart(AChart: TCustomChart);
    property Series[Index: Integer]: TRMChartSeries read GetSeries;
    property Chart: TChart read FChart;
  published
    property PrintType: TRMPrintMethodType read FPrintType write FPrintType;
    property UseChartSetting: Boolean read GetUseChartSetting write SetUseChartSetting;
    property UseDoublePass;
    property Memo;
    property ChartDim3D: Boolean read FChartDim3D write FChartDim3D;
    property ChartShowLegend: Boolean read FChartShowLegend write FChartShowLegend;
    property ChartShowAxis: Boolean read FChartShowAxis write FChartShowAxis;
    property ReprintOnOverFlow;
    property ShiftWith;
    property BandAlign;
    property LeftFrame;
    property RightFrame;
    property TopFrame;
    property BottomFrame;
    property FillColor;
    property DirectDraw: Boolean read GetDirectDraw write SetDirectDraw;
    property PrintFrame;
    property Printable;
  end;

  { TRMChartForm }
  TRMChartForm = class(TForm)
    Page1: TPageControl;
    Tab1: TTabSheet;
    gpbSeriesType: TGroupBox;
    Tab2: TTabSheet;
    btnOk: TButton;
    btnCancel: TButton;
    gpbSeriesOptions: TGroupBox;
    chkSeriesMultiColor: TCheckBox;
    chkSeriesShowMarks: TCheckBox;
    Tab3: TTabSheet;
    gpbMarks: TGroupBox;
    rdbStyle1: TRadioButton;
    rdbStyle2: TRadioButton;
    rdbStyle3: TRadioButton;
    rdbStyle4: TRadioButton;
    rdbStyle5: TRadioButton;
    TabSheet1: TTabSheet;
    ListBox1: TListBox;
    gpbChartOptions: TGroupBox;
    chkChartShowLegend: TCheckBox;
    chkChartShowAxis: TCheckBox;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    chkChartDim3D: TCheckBox;
    EditTitle1: TMenuItem;
    N1: TMenuItem;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    gpbTopGroup: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    editTop10Num: TEdit;
    edtTop10Label: TEdit;
    gpbObjects: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label6: TLabel;
    ImageList1: TImageList;
    cmbSeriesType: TComboBox;
    cmbLegend: TComboBox;
    cmbValue: TComboBox;
    cmbLabel: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure MoveUp1Click(Sender: TObject);
    procedure MoveDown1Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure EditTitle1Click(Sender: TObject);
    procedure chkSeriesMultiColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbSeriesTypeDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    FChartView: TRMChartView;
    FSeries: TRMChartSeries;
    FBtnColor: TRMColorPickerButton;

    procedure Localize;
    procedure LoadSeriesOptions;
    procedure SaveSeriesOptions;
  public
    { Public declarations }
  end;

  TRMCustomTeeChartUIClass = class of TRMCustomTeeChartUI;

  TRMCustomTeeChartUI = class
  public
    class procedure Edit(aTeeChart: TCustomChart); virtual;
  end;

  {TRMTeeChartUIPlugIn }
  TRMTeeChartUIPlugIn = class
  private
    class function GetChartUIClass(aTeeChart: TCustomChart): TRMCustomTeeChartUIClass;
  public
    class procedure Register(aChartUIClass: TRMCustomTeeChartUIClass);
    class procedure UnRegister(aChartUIClass: TRMCustomTeeChartUIClass);
    class procedure Edit(aTeeChart: TCustomChart);
  end; {class, TRMTeeChartUIPlugIn}
{$ENDIF}

implementation

{$IFDEF TeeChart}
uses Math, RM_Utils, RM_Const, RM_Const1, RMInterpreter_Chart;

{$R *.DFM}

const
  flChartUseChartSetting = $2;
  flChartDirectDraw = $4;

type
  THackPage = class(TRMCustomPage)
  end;

  THackView = class(TRMView)
  end;

  TSeriesClass = class of TChartSeries;

const
  ChartTypes: array[0..5] of TSeriesClass =
  (TLineSeries, TAreaSeries, TPointSeries, TBarSeries, THorizBarSeries, TPieSeries);

var
  uChartUIClassList: TList;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMChartSeries }

constructor TRMChartSeries.Create;
begin
  inherited Create;

  FColored := True;
  FValueView := '';
  FLegendView := '';
  FTop10Label := '';
  FTop10Num := 0;
  FTitle := '';
  FColor := clTeeColor;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMChartView }

constructor TRMChartView.Create;
begin
  inherited Create;
  BaseName := 'Chart';
  WantHook := True;
  UseChartSetting := False;

  FChart := TChart.Create(RMDialogForm);
  with FChart do
  begin
    Parent := RMDialogForm;
    Visible := False;
    BevelInner := bvNone;
    BevelOuter := bvNone;
  end;

  FChartDim3D := True;
  FChartShowLegend := True;
  FPrintType := rmptMetafile;

  FPicture := TMetafile.Create;
  FList := TList.Create;
end;

destructor TRMChartView.Destroy;
begin
  Clear;
  if RMDialogForm <> nil then
  begin
    FreeAndNil(FChart);
  end;
  FPicture.Free;
  FList.Free;
  inherited Destroy;
end;

procedure TRMChartView.Clear;
begin
  while FList.Count > 0 do
  begin
    TRMChartSeries(FList[0]).Free;
    FList.Delete(0);
  end;
end;

function TRMChartView.SeriesCount: Integer;
begin
  Result := FList.Count;
end;

function TRMChartView.AddSeries: TRMChartSeries;
var
  lSeries: TRMChartSeries;

  procedure _SetSeriesTitle;
  var
    i, j: Integer;
    listr: string;
    liFlag: Boolean;
  begin
    for i := 1 to 9999 do
    begin
      listr := 'Series' + IntToStr(i);
      liFlag := True;
      for j := 0 to FList.Count - 1 do
      begin
        if AnsiCompareText(Series[j].Title, listr) = 0 then
        begin
          liFlag := False;
          Break;
        end;
      end;

      if liFlag then
      begin
        lSeries.Title := listr;
        Break;
      end;
    end;
  end;

begin
  lSeries := TRMChartSeries.Create;
  _SetSeriesTitle;
  FList.Add(lSeries);
  Result := lSeries;
end;

procedure TRMChartView.DeleteSeries(Index: Integer);
begin
  if (Index >= 0) and (Index < FList.Count) then
  begin
    TRMChartSeries(FList[Index]).Free;
    FList.Delete(Index);
  end;
end;

function TRMChartView.GetSeries(Index: Integer): TRMChartSeries;
begin
  Result := nil;
  if (Index >= 0) and (Index < FList.Count) then
    Result := TRMChartSeries(FList[Index]);
end;

procedure TRMChartView.AssignChart(AChart: TCustomChart);
var
  lSeries: TChartSeries;
  liSeriesClass: TChartSeriesClass;
  i: Integer;
begin
  Clear;
  FChart.RemoveAllSeries;
  FChart.Assign(AChart);
  for i := 0 to AChart.SeriesCount - 1 do
  begin
    liSeriesClass := TChartSeriesClass(AChart.Series[i].ClassType);
    lSeries := liSeriesClass.Create(FChart);
    lSeries.Assign(aChart.Series[i]);
    FChart.AddSeries(lSeries);
  end;

  FChart.Name := '';
  for i := 0 to FChart.SeriesList.Count - 1 do
    FChart.SeriesList[i].Name := '';
  Memo.Clear;
  FPicture.Clear;
end;

procedure TRMChartView.ShowChart;
var
  i: Integer;
  lMetafile: TMetafile;
  lBitmap: TBitmap;
  liChartSeries: TRMChartSeries;
  liFlag: Boolean;
  liLegends, liValues, liLabels: TStringList;

  function _ExtractStr(const aStr: string; var aPos: Integer): string;
  var
    i: Integer;
  begin
    i := aPos;
    while (i <= Length(aStr)) and (aStr[i] <> ';') do
      Inc(i);

    Result := Copy(aStr, aPos, i - aPos);
    if (i <= Length(aStr)) and (aStr[i] = ';') then
      Inc(i);

    aPos := i;
  end;

  procedure _SetChartProp;
  begin
    FChart.View3D := ChartDim3D;
    FChart.Legend.Visible := ChartShowLegend;
    FChart.AxisVisible := ChartShowAxis;
    if not UseChartSetting then
    begin
      FChart.RemoveAllSeries;
      FChart.Frame.Visible := False;
      FChart.LeftWall.Brush.Style := bsClear;
      FChart.BottomWall.Brush.Style := bsClear;

      FChart.Legend.Font.Charset := rmCharset;
      FChart.BottomAxis.LabelsFont.Charset := rmCharset;
      FChart.LeftAxis.LabelsFont.Charset := rmCharset;
      FChart.TopAxis.LabelsFont.Charset := rmCharset;
      FChart.BottomAxis.LabelsFont.Charset := rmCharset;
{$IFDEF Delphi4}
      FChart.BackWall.Brush.Style := bsClear;
      FChart.View3DOptions.Elevation := 315;
      FChart.View3DOptions.Rotation := 360;
{$ENDIF}
    end;
  end;

  procedure _PaintChart;
  var
    SaveDx, SaveDy: Integer;
  begin
    if FillColor = clNone then
      Chart.Color := clWhite
    else
      Chart.Color := FillColor;

    SaveDX := RMToScreenPixels(mmSaveWidth, rmutMMThousandths);
    SaveDY := RMToScreenPixels(mmSaveHeight, rmutMMThousandths);
    case FPrintType of
      rmptMetafile:
        begin
          lMetafile := Chart.TeeCreateMetafile(True {False}, Rect(0, 0, SaveDX, SaveDY));
          try
            RMPrintGraphic(Canvas, RealRect, lMetafile, IsPrinting, DirectDraw, False);
          finally
            lMetafile.Free;
          end;
        end;
      rmptBitmap:
        begin
          lBitmap := TBitmap.Create;
          try
            lBitmap.Width := SaveDX;
            lBitmap.Height := SaveDY;
            Chart.Draw(lBitmap.Canvas, Rect(0, 0, SaveDX, SaveDY));
            RMPrintGraphic(Canvas, RealRect, lBitmap, IsPrinting, DirectDraw, False);
          finally
            lBitmap.Free;
          end;
        end;
    end;
  end;

  function _StrToFloat(s: string): Double;
  begin
    s := RMDeleteNoNumberChar(s);
    Result := 0;
    try
      Result := StrToFloat(s);
    except
    end;
  end;

  procedure _AddSeries(aIndex: Integer; aHaveLabel: Boolean);
  var
    i: Integer;
    lSeries: TChartSeries;

    procedure _SetSeriesType;
    begin
      if UseChartSetting and (aIndex < Chart.SeriesCount) then
        lSeries := Chart.SeriesList[aIndex]
      else
        lSeries := ChartTypes[liChartSeries.ChartType].Create(Chart);

      lSeries := ChartTypes[liChartSeries.ChartType].Create(Chart);
      lSeries.Title := liChartSeries.Title;
      lSeries.ColorEachPoint := liChartSeries.Colored;
      lSeries.Marks.Visible := liChartSeries.ShowMarks;
      lSeries.Marks.Style := TSeriesMarksStyle(liChartSeries.MarksStyle);
      Chart.View3DWalls := liChartSeries.ChartType <> 5;
      lSeries.Marks.Font.Charset := rmCharset;
  {$IFDEF Delphi4}
      Chart.View3DOptions.Orthogonal := liChartSeries.ChartType <> 5;
  {$ENDIF}

      if not UseChartSetting then
      begin
        Chart.AddSeries(lSeries);
      end
      else
      begin
        lSeries.Clear;
      end;
    end;

    procedure _SortValues;
    var
      i: Integer;
      d: Double;
    begin
      d := 0;
      for i := liChartSeries.Top10Num to liValues.Count - 1 do
        d := d + StrToFloat(liValues[i]);

      while liLegends.Count > liChartSeries.Top10Num do
      begin
        liLegends.Delete(liChartSeries.Top10Num);
        liValues.Delete(liChartSeries.Top10Num);
        if liLabels.Count > 0 then
          liLabels.Delete(liChartSeries.Top10Num);
      end;

//      if liChartSeries.Top10Label <> '' then
//      begin
      liLegends.Add(liChartSeries.Top10Label);
      liValues.Add(FloatToStr(d));
      if liLabels.Count > 0 then
        liLabels.Add(liChartSeries.Top10Label);
//      end;
    end;

  begin
    if liLegends.Count <> liValues.Count then Exit;
    if (liLabels.Count > 0) and (liLabels.Count <> liLegends.Count) then Exit;

    _SetSeriesType;
    if (liChartSeries.Top10Num > 0) and (liLegends.Count > liChartSeries.Top10Num) then
      _SortValues;

    for i := 0 to liLegends.Count - 1 do
    begin
      if aHaveLabel then
      begin
        if lSeries.ColorEachPoint then
          lSeries.AddXY(StrToFloat(liLegends[i]), StrToFloat(liValues[i]), liLabels[i], clTeeColor)
        else
          lSeries.AddXY(_StrToFloat(liLegends[i]), StrToFloat(liValues[i]), liLabels[i], liChartSeries.Color);
      end
      else
      begin
        if lSeries.ColorEachPoint then
          lSeries.Add(StrToFloat(liValues[i]), liLegends[i], clTeeColor)
        else
          lSeries.Add(StrToFloat(liValues[i]), liLegends[i], liChartSeries.Color);
      end;
    end;
  end;

  procedure _BuildSeries;
  var
    i, liPos: Integer;
    liLegendStr, liValueStr, liLabelStr: string;
    liHaveLabel: Boolean;
    lFlag_NumberString: Boolean;
    str: string;
  begin
    try
      if (FList.Count * 2 = Memo.Count) or (FList.Count * 3 = Memo.Count) then
      begin
        liHaveLabel := FList.Count * 3 = Memo.Count;
        for i := 0 to FList.Count - 1 do
        begin
          if liHaveLabel then
          begin
            liLegendStr := Memo[i * 3];
            liValueStr := Memo[i * 3 + 1];
            liLabelStr := Memo[i * 3 + 2];
          end
          else
          begin
            liLegendStr := Memo[i * 2];
            liValueStr := Memo[i * 2 + 1];
            liLabelStr := '';
          end;

          if (liLegendStr <> '') and (liLegendStr[Length(liLegendStr)] <> ';') then
            liLegendStr := liLegendStr + ';';
          if (liValueStr <> '') and (liValueStr[Length(liValueStr)] <> ';') then
            liValueStr := liValueStr + ';';
          if (liLabelStr <> '') and (liLabelStr[Length(liLabelStr)] <> ';') then
            liLabelStr := liLabelStr + ';';

          liLegends.Clear; liValues.Clear; liLabels.Clear;
          lFlag_NumberString := True;
          for liPos := 1 to Length(liLegendStr) do
          begin
            if not (liLegendStr[liPos] in ['-', ' ', ';', '.', '0'..'9']) then
            begin
              lFlag_NumberString := False;
              Break;
            end;
          end;

          liPos := 1;
          while liPos <= Length(liLegendStr) do
            liLegends.Add(_ExtractStr(liLegendStr, liPos));

          liPos := 1;
          while liPos <= Length(liValueStr) do
          begin
            str := _ExtractStr(liValueStr, liPos);
            if RMisNumeric(str) then
              liValues.Add(SysUtils.Format('%12.3f', [_StrToFloat(str)]))
            else
              liValues.Add('0');
          end;

          if liHaveLabel then
          begin
            liPos := 1;
            while liPos <= Length(liLabelStr) do
              liLabels.Add(_ExtractStr(liLabelStr, liPos));
          end;

          liChartSeries := Series[i];
          _AddSeries(i, lFlag_NumberString and liHaveLabel);
        end;
      end;
    finally
    end;
  end;

begin
  liFlag := True;
  for i := 0 to FList.Count - 1 do
  begin
    liChartSeries := Series[i];
    if (liChartSeries.LegendView <> '') or (liChartSeries.ValueView <> '') then
    begin
      liFlag := False;
      Break;
    end;
  end;

  if liFlag and (Memo.Count = 0) then
  begin
    if FPicture.Width = 0 then
      _PaintChart
    else
      Canvas.StretchDraw(RealRect, FPicture);
    Exit;
  end;

  if FList.Count < 1 then Exit;

  liLegends := TStringList.Create;
  liValues := TStringList.Create;
  liLabels := TStringList.Create;
  try
    _SetChartProp;
    _BuildSeries;
    _PaintChart;
  finally
    liLegends.Free;
    liValues.Free;
    liLabels.Free;
  end;
end;

procedure TRMChartView.Draw(aCanvas: TCanvas);
begin
  BeginDraw(aCanvas);
  Memo1.Assign(Memo);
  CalcGaps;
  ShowBackground;
  ShowChart;
  ShowFrame;
  RestoreCoord;
end;

procedure TRMChartView.PlaceOnEndPage(aStream: TStream);
begin
	if UseDoublePass and (ParentReport.MasterReport.DoublePass and ParentReport.MasterReport.FinalPass) then
  	Memo.Text := FSaveMemo;

  inherited PlaceOnEndPage(aStream);
  Memo.Text := '';
end;

procedure TRMChartView.LoadFromStream(aStream: TStream);
var
  b: Byte;
  liStream: TMemoryStream;
  i, liCount: Integer;
  lSeries: TRMChartSeries;
begin
  inherited LoadFromStream(aStream);
  RMReadWord(aStream);

  Clear;
  FPicture.Clear;
  ChartDim3D := RMReadBoolean(aStream);
  ChartShowLegend := RMReadBoolean(aStream);
  ChartShowAxis := RMReadBoolean(aStream);
  FPrintType := TRMPrintMethodType(RMReadByte(aStream));
  liCount := RMReadWord(aStream);
  for i := 1 to liCount do
  begin
    lSeries := AddSeries;
    lSeries.LegendView := RMReadString(aStream);
    lSeries.ValueView := RMReadString(aStream);
    lSeries.LabelView := RMReadString(aStream);
    lSeries.Top10Label := RMReadString(aStream);
    lSeries.Title := RMReadString(aStream);
    lSeries.Color := RMReadInt32(aStream);
    lSeries.ChartType := RMReadByte(aStream);
    lSeries.ShowMarks := RMReadBoolean(aStream);
    lSeries.Colored := RMReadBoolean(aStream);
    lSeries.MarksStyle := RMReadByte(aStream);
    lSeries.Top10Num := RMReadInt32(aStream);
  end;

  b := RMReadByte(aStream);
  if b = 1 then
  begin
    liStream := TMemoryStream.Create;
    try
      liStream.CopyFrom(aStream, RMReadInt32(aStream));
      liStream.Position := 0;
      FPicture.LoadFromStream(liStream);
    finally
      liStream.Free;
    end;
  end;

  b := RMReadByte(aStream);
  if b = 1 then
  begin
    FreeAndNil(FChart);
    FChart := TChart.Create(RMDialogForm);
    with FChart do
    begin
      Parent := RMDialogForm;
      Visible := False;
      BevelInner := bvNone;
      BevelOuter := bvNone;
    end;

    liStream := TMemoryStream.Create;
    try
      liStream.CopyFrom(aStream, RMReadInt32(aStream));
      liStream.Position := 0;
      liStream.ReadComponent(FChart);
      FChart.Name := '';
      for i := 0 to FChart.SeriesList.Count - 1 do
        FChart.SeriesList[i].Name := '';
    finally
      liStream.Free;
    end;
  end;
end;

procedure TRMChartView.SaveToStream(aStream: TStream);
var
  liStream: TMemoryStream;
  liEMF: TMetafile;
  i: Integer;
  liFlag: Boolean;
  lSeries: TRMChartSeries;
  liSavePos, liSavePos1, liPos: Integer;
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 0);

  liFlag := True;
  for i := 0 to FList.Count - 1 do
  begin
    lSeries := Series[i];
    if (lSeries.LegendView <> '') or (lSeries.ValueView <> '') then
    begin
      liFlag := False;
      Break;
    end;
  end;

  RMWriteBoolean(aStream, ChartDim3D);
  RMWriteBoolean(aStream, ChartShowLegend);
  RMWriteBoolean(aStream, ChartShowAxis);
  RMWriteByte(aStream, Byte(FPrintType));
  RMWriteWord(aStream, FList.Count);
  for i := 0 to FList.Count - 1 do
  begin
    RMWriteString(aStream, Series[i].LegendView);
    RMWriteString(aStream, Series[i].ValueView);
    RMWriteString(aStream, Series[i].LabelView);
    RMWriteString(aStream, Series[i].Top10Label);
    RMWriteString(aStream, Series[i].Title);
    RMWriteInt32(aStream, Series[i].Color);
    RMWriteByte(aStream, Series[i].ChartType);
    RMWriteBoolean(aStream, Series[i].ShowMarks);
    RMWriteBoolean(aStream, Series[i].Colored);
    RMWriteByte(aStream, Series[i].MarksStyle);
    RMWriteInt32(aStream, Series[i].Top10Num);
  end;

  if liFlag and (Memo.Count = 0) then
  begin
    RMWriteByte(aStream, 1);
    liStream := TMemoryStream.Create;
    liEMF := nil;
    try
      liEMF := FChart.TeeCreateMetafile(FALSE, Rect(0, 0, spWidth, spHeight));
      liEMF.SaveToStream(liStream);

      liStream.Position := 0;
      RMWriteInt32(aStream, liStream.Size);
      aStream.CopyFrom(liStream, 0);
    finally
      liStream.Free;
      if liEMF <> nil then liEMF.Free;
    end;
  end
  else
    RMWriteByte(aStream, 0);

  if UseChartSetting then
  begin
    FChart.Name := '';
    for i := 0 to FChart.SeriesList.Count - 1 do
      FChart.SeriesList[i].Name := '';
      
    RMWriteByte(aStream, 1);
    liSavePos := aStream.Position;
    RMWriteInt32(aStream, liSavePos);
    liSavePos1 := aStream.Position;
    aStream.WriteComponent(FChart);
    liPos := aStream.Position;
    aStream.Position := liSavePos;
    RMWriteInt32(aStream, liPos - liSavePos1);
    aStream.Position := liPos;
  end
  else
    RMWriteByte(aStream, 0);
end;

procedure TRMChartView.DefinePopupMenu(Popup: TRMCustomMenuItem);
begin
  inherited DefinePopupMenu(Popup);
end;

procedure TRMChartView.Prepare;
var
  liIndex: Integer;
begin
  if not ParentReport.MasterReport.FinalPass then
	  FSaveMemo := '';

  Memo.Clear;
  for liIndex := 0 to FList.Count - 1 do
  begin
    Memo.Add('');
    Memo.Add('');
    Memo.Add('');
  end;
end;

procedure TRMChartView.OnHook(aView: TRMView);
var
  lSeries: TRMChartSeries;
  liIndex: Integer;

  procedure _GetValue(const aObjName: string; aIndex: Integer);
  var
    s: string;
  begin
    if AnsiCompareText(aView.Name, aObjName) = 0 then
    begin
      if THackView(aView).Memo1.Count > 0 then
      begin
        s := THackView(aView).Memo1[0];
        if s <> '' then
          Memo[aIndex] := Memo[aIndex] + s + ';'
        else
        begin
          if aIndex = liIndex * 3 + 1 then
            Memo[aIndex] := Memo[aIndex] + '0;'
          else
            Memo[aIndex] := Memo[aIndex] + ';';
        end
      end
      else
      begin
        if aIndex = liIndex * 3 + 1 then
          Memo[aIndex] := Memo[aIndex] + '0;'
        else
          Memo[aIndex] := Memo[aIndex] + ';';
      end
    end;
  end;

begin
  for liIndex := 0 to FList.Count - 1 do
  begin
    lSeries := Series[liIndex];
    _GetValue(lSeries.LegendView, liIndex * 3 + 0);
    _GetValue(lSeries.ValueView, liIndex * 3 + 1);
    _GetValue(lSeries.LabelView, liIndex * 3 + 2);
  end;

  if UseDoublePass and
  	(ParentReport.MasterReport.DoublePass and (not ParentReport.MasterReport.FinalPass)) then
  begin
  	FSaveMemo := Memo.Text;
  end;
end;

procedure TRMChartView.ShowEditor;
var
  tmpForm: TRMChartForm;
  liStream: TMemoryStream;
begin
  liStream := TMemoryStream.Create;
  tmpForm := TRMChartForm.Create(Application);
  try
    SaveToStream(liStream);
    liStream.Position := 0;
//    RMVersion := RMCurrentVersion;
    tmpForm.FChartView.LoadFromStream(liStream);
    if tmpForm.ShowModal = mrOK then
    begin
      RMDesigner.BeforeChange;
      liStream.Clear;
      tmpForm.FChartView.SaveToStream(liStream);
      liStream.Position := 0;
//      RMVersion := RMCurrentVersion;
      LoadFromStream(liStream);
      RMDesigner.AfterChange;
    end;
  finally
    liStream.Free;
    tmpForm.Free;
  end;
end;

function TRMChartView.GetUseChartSetting: Boolean;
begin
  Result := FFlags and flChartUseChartSetting = flChartUseChartSetting;
end;

procedure TRMChartView.SetUseChartSetting(Value: Boolean);
begin
  FFlags := FFlags and (not flChartUseChartSetting);
//{$IFDEF TeeChartPro}
  if Value then
    FFlags := FFlags + flChartUseChartSetting;
//{$ENDIF}
end;

function TRMChartView.GetDirectDraw: Boolean;
begin
  Result := (FFlags and flChartDirectDraw) = flChartDirectDraw;
end;

procedure TRMChartView.SetDirectDraw(Value: Boolean);
begin
  FFlags := (FFlags and not flChartDirectDraw);
  if Value then
    FFlags := FFlags + flChartDirectDraw;
end;

function TRMChartView.GetViewCommon: string;
begin
  Result := '[Chart]';
end;

procedure TRMChartView.ClearContents;
begin
  Clear;
  inherited;
end;

function TRMChartView.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
begin
  Result := True;
  if aPropName = 'CHART' then
  begin
    aValue := O2V(FChart);
  end
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCustomTeeChartUI }

class procedure TRMCustomTeeChartUI.Edit(aTeeChart: TCustomChart);
begin
end;

{******************************************************************************
 *
 ** C H A R T   U I   P L U G I N
 *
{******************************************************************************}
{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMTeeChartUIPlugIn}

class procedure TRMTeeChartUIPlugIn.Register(aChartUIClass: TRMCustomTeeChartUIClass);
begin
//  uChartUIPlugInLock.Acquire;
  try
    uChartUIClassList.Add(aChartUIClass);
  finally
//    uChartUIPlugInLock.Release;
  end;
end;

class procedure TRMTeeChartUIPlugIn.UnRegister(aChartUIClass: TRMCustomTeeChartUIClass);
begin
//  uChartUIPlugInLock.Acquire;
  try
    uChartUIClassList.Remove(aChartUIClass);
  finally
//    uChartUIPlugInLock.Release;
  end;
end;

class function TRMTeeChartUIPlugIn.GetChartUIClass(aTeeChart: TCustomChart): TRMCustomTeeChartUIClass;
begin
//  uChartUIPlugInLock.Acquire;
  try
    if uChartUIClassList.Count > 0 then
      Result := TRMCustomTeeChartUIClass(uChartUIClassList[0])
    else
      Result := nil;
  finally
//    uChartUIPlugInLock.Release;
  end;
end;

class procedure TRMTeeChartUIPlugIn.Edit(aTeeChart: TCustomChart);
var
  lChartUIClass: TRMCustomTeeChartUIClass;
begin
  lChartUIClass := GetChartUIClass(aTeeChart);
  if (lChartUIClass <> nil) then
    lChartUIClass.Edit(aTeeChart);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMChartForm }

procedure SetControlsEnabled(aControl: TWinControl; aEnabled: Boolean);
var
  i: Integer;
begin
  for i := 0 to aControl.ControlCount - 1 do
  begin
    aControl.Controls[i].Enabled := aEnabled;
  end;
end;

procedure TRMChartForm.FormCreate(Sender: TObject);
var
  i, j: Integer;
  t: TRMView;
  liPage: TRMCustomPage;
begin
  Page1.ActivePage := TabSheet1;
  FBtnColor := TRMColorPickerButton.Create(Self);
  FBtnColor.Parent := gpbSeriesOptions;
  FBtnColor.SetBounds(120, 34, 115, 25);

  for i := 0 to RMDesigner.Report.Pages.Count - 1 do
  begin
    liPage := RMDesigner.Report.Pages[i];
    if liPage is TRMReportPage then
    begin
      for j := 0 to THackPage(liPage).Objects.Count - 1 do
      begin
        t := THackPage(liPage).Objects[j];
        if t is TRMCustomMemoView then
          cmbLegend.Items.Add(t.Name);
      end;
    end;
  end;

  cmbValue.Items.Assign(cmbLegend.Items);
  cmbLabel.Items.Assign(cmbLegend.Items);
  FChartView := TRMChartView(RMCreateObject(rmgtAddin, 'TRMChartView'));
  Localize;
end;

procedure TRMChartForm.FormDestroy(Sender: TObject);
begin
  FChartView.Free;
end;

procedure TRMChartForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  RMSetStrProp(Self, 'Caption', rmRes + 590);
  RMSetStrProp(Tab1, 'Caption', rmRes + 591);
  RMSetStrProp(Tab2, 'Caption', rmRes + 592);
  RMSetStrProp(Tab3, 'Caption', rmRes + 604);
  RMSetStrProp(TabSheet1, 'Caption', rmRes + 597);
  RMSetStrProp(gpbSeriesType, 'Caption', rmRes + 593);
  RMSetStrProp(gpbObjects, 'Caption', rmRes + 594);
  RMSetStrProp(gpbSeriesOptions, 'Caption', rmRes + 595);
  RMSetStrProp(gpbMarks, 'Caption', rmRes + 605);
  RMSetStrProp(gpbTopGroup, 'Caption', rmRes + 611);
  RMSetStrProp(gpbChartOptions, 'Caption', rmRes + 595);

  RMSetStrProp(chkChartDim3D, 'Caption', rmRes + 596);
  RMSetStrProp(chkChartShowLegend, 'Caption', rmRes + 598);
  RMSetStrProp(chkChartShowAxis, 'Caption', rmRes + 599);

  RMSetStrProp(chkSeriesShowMarks, 'Caption', rmRes + 600);
  RMSetStrProp(chkSeriesMultiColor, 'Caption', rmRes + 601);

  RMSetStrProp(rdbStyle1, 'Caption', rmRes + 606);
  RMSetStrProp(rdbStyle2, 'Caption', rmRes + 607);
  RMSetStrProp(rdbStyle3, 'Caption', rmRes + 608);
  RMSetStrProp(rdbStyle4, 'Caption', rmRes + 609);
  RMSetStrProp(rdbStyle5, 'Caption', rmRes + 610);

  RMSetStrProp(Label1, 'Caption', rmRes + 602);
  RMSetStrProp(Label2, 'Caption', rmRes + 603);
  RMSetStrProp(Label3, 'Caption', rmRes + 612);
  RMSetStrProp(Label4, 'Caption', rmRes + 613);
  RMSetStrProp(Label5, 'Caption', rmRes + 614);
  RMSetStrProp(Label6, 'Caption', rmRes + 622);

  RMSetStrProp(Add1, 'Caption', rmRes + 616);
  RMSetStrProp(Delete1, 'Caption', rmRes + 617);
  RMSetStrProp(EditTitle1, 'Caption', rmRes + 618);
  RMSetStrProp(MoveUp1, 'Caption', rmRes + 619);
  RMSetStrProp(MoveDown1, 'Caption', rmRes + 620);

  cmbSeriesType.Items.Clear;
  cmbSeriesType.Items.Add(RMLoadStr(rmRes + 624));
  cmbSeriesType.Items.Add(RMLoadStr(rmRes + 625));
  cmbSeriesType.Items.Add(RMLoadStr(rmRes + 626));
  cmbSeriesType.Items.Add(RMLoadStr(rmRes + 627));
  cmbSeriesType.Items.Add(RMLoadStr(rmRes + 628));
  cmbSeriesType.Items.Add(RMLoadStr(rmRes + 629));

  RMSetStrProp(Button1, 'Caption', rmRes + 623);
  btnOk.Caption := RMLoadStr(SOk);
  btnCancel.Caption := RMLoadStr(SCancel);
end;

procedure TRMChartForm.LoadSeriesOptions;

  procedure _SetRButton(b: array of TRadioButton; n: Integer);
  begin
    if (n >= Low(b)) and (n <= High(b)) then
      b[n].Checked := True;
  end;

begin
  SetControlsEnabled(gpbChartOptions, FSeries <> nil);
  SetControlsEnabled(gpbSeriesType, FSeries <> nil);
  SetControlsEnabled(gpbSeriesOptions, FSeries <> nil);
  SetControlsEnabled(gpbObjects, FSeries <> nil);
  SetControlsEnabled(gpbTopGroup, FSeries <> nil);
  SetControlsEnabled(gpbSeriesType, FSeries <> nil);

  chkChartShowLegend.Checked := FChartView.ChartShowLegend;
  chkChartShowAxis.Checked := FChartView.ChartShowAxis;
  chkChartDim3D.Checked := FChartView.ChartDim3D;

  if FSeries = nil then Exit;

  cmbSeriesType.ItemIndex := FSeries.ChartType;
  _SetRButton([rdbStyle1, rdbStyle2, rdbStyle3, rdbStyle4, rdbStyle5], FSeries.MarksStyle);
  chkSeriesShowMarks.Checked := FSeries.ShowMarks;
  chkSeriesMultiColor.Checked := FSeries.Colored;
  cmbLegend.Text := FSeries.LegendView;
  cmbValue.Text := FSeries.ValueView;
  cmbLabel.Text := FSeries.LabelView;
  editTop10Num.Text := IntToStr(FSeries.Top10Num);
  edtTop10Label.Text := FSeries.Top10Label;
  FBtnColor.CurrentColor := Fseries.Color;
  FBtnColor.Enabled := not chkSeriesMultiColor.Checked;
end;

procedure TRMChartForm.SaveSeriesOptions;

  function _GetRButton(b: array of TRadioButton): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to High(b) do
    begin
      if b[i].Checked then
        Result := i;
    end;
  end;

begin
  FChartView.ChartShowLegend := chkChartShowLegend.Checked;
  FChartView.ChartShowAxis := chkChartShowAxis.Checked;
  FChartView.ChartDim3D := chkChartDim3D.Checked;

  if FSeries = nil then Exit;

  if cmbSeriesType.ItemIndex >= 0 then
    FSeries.ChartType := cmbSeriesType.ItemIndex;
  FSeries.MarksStyle := _GetRButton([rdbStyle1, rdbStyle2, rdbStyle3, rdbStyle4, rdbStyle5]);
  FSeries.ShowMarks := chkSeriesShowMarks.Checked;
  FSeries.Colored := chkSeriesMultiColor.Checked;

  FSeries.LegendView := cmbLegend.Text;
  FSeries.ValueView := cmbValue.Text;
  FSeries.LabelView := cmbLabel.Text;
  FSeries.Top10Num := StrToInt(editTop10Num.Text);
  FSeries.Top10Label := edtTop10Label.Text;
  Fseries.Color := FBtnColor.CurrentColor;
end;

procedure TRMChartForm.Add1Click(Sender: TObject);
begin
  SaveSeriesOptions;
  FSeries := FChartView.AddSeries;
  ListBox1.Items.Add(FSeries.Title);
  ListBox1.ItemIndex := ListBox1.Items.Count - 1;
  LoadSeriesOptions;
end;

procedure TRMChartForm.Delete1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    FChartView.DeleteSeries(ListBox1.ItemIndex);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    ListBox1.ItemIndex := 0;
    if ListBox1.ItemIndex >= 0 then
      FSeries := FChartView.Series[ListBox1.ItemIndex]
    else
      FSeries := nil;
    LoadSeriesOptions;
  end;
end;

procedure TRMChartForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  Button1.Visible := FChartView.UseChartSetting;
  Tab1.TabVisible := not Button1.Visible;
  Tab3.TabVisible := not Button1.Visible;

  ListBox1.Clear;
  for i := 0 to FChartView.SeriesCount - 1 do
  begin
    ListBox1.Items.Add(FChartView.Series[i].Title);
  end;
  ListBox1.ItemIndex := 0;
  if ListBox1.ItemIndex >= 0 then
    FSeries := FChartView.Series[0]
  else
    FSeries := nil;
  LoadSeriesOptions;
end;

procedure TRMChartForm.ListBox1Click(Sender: TObject);
begin
  SaveSeriesOptions;
  if ListBox1.ItemIndex >= 0 then
    FSeries := FChartView.Series[ListBox1.ItemIndex]
  else
    FSeries := nil;
  LoadSeriesOptions;
end;

procedure TRMChartForm.PopupMenu1Popup(Sender: TObject);
begin
  Add1.Enabled := (not Button1.Visible);
  Delete1.Enabled := (FSeries <> nil) and (not Button1.Visible);
  EditTitle1.Enabled := (FSeries <> nil) and (not Button1.Visible);
  MoveUp1.Enabled := (FSeries <> nil) and (not Button1.Visible);
  MoveDown1.Enabled := (FSeries <> nil) and (not Button1.Visible);
end;

procedure TRMChartForm.MoveUp1Click(Sender: TObject);
var
  liIndex: Integer;
begin
  liIndex := ListBox1.ItemIndex;
  if liIndex > 0 then
  begin
    ListBox1.Items.Exchange(liIndex, liIndex - 1);
    FChartView.FList.Exchange(liIndex, liIndex - 1);
  end;
end;

procedure TRMChartForm.MoveDown1Click(Sender: TObject);
var
  liIndex: Integer;
begin
  liIndex := ListBox1.ItemIndex;
  if liIndex < ListBox1.Items.Count - 1 then
  begin
    ListBox1.Items.Exchange(liIndex, liIndex + 1);
    FChartView.FList.Exchange(liIndex, liIndex + 1);
  end;
end;

procedure TRMChartForm.btnOkClick(Sender: TObject);
begin
  SaveSeriesOptions;
end;

procedure TRMChartForm.EditTitle1Click(Sender: TObject);
begin
  if FSeries = nil then Exit;
  FSeries.Title := InputBox('', '', FSeries.Title);
  ListBox1.Items[ListBox1.ItemIndex] := FSeries.Title;
end;

procedure TRMChartForm.chkSeriesMultiColorClick(Sender: TObject);
begin
  FBtnColor.Enabled := not chkSeriesMultiColor.Checked;
end;

procedure TRMChartForm.Button1Click(Sender: TObject);
var
  i, lCount: Integer;
begin
  SaveSeriesOptions;

  FChartView.Chart.View3D := FChartView.ChartDim3D;
  FChartView.Chart.Legend.Visible := FChartView.ChartShowLegend;
  FChartView.Chart.AxisVisible := FChartView.ChartShowAxis;

  TRMTeeChartUIPlugIn.Edit(FChartView.Chart);

  FChartView.ChartDim3D := FChartView.Chart.View3D;
  FChartView.ChartShowLegend := FChartView.Chart.Legend.Visible;
  FChartView.ChartShowAxis := FChartView.Chart.AxisVisible;

  lCount := FChartView.SeriesCount - FChartView.Chart.SeriesCount - 1;
  for i := 0 to lCount do
  begin
    FChartView.DeleteSeries(FChartView.SeriesCount - 1);
  end;

  lCount := FChartView.Chart.SeriesCount - FChartView.SeriesCount - 1;
  for i := 0 to lCount do
  begin
    FChartView.AddSeries;
  end;

  ListBox1.Items.Clear;
  for i := 0 to FChartView.SeriesCount - 1 do
  begin
    ListBox1.Items.Add(FChartView.Series[i].Title);
  end;
  ListBox1.ItemIndex := 0;
  if ListBox1.ItemIndex >= 0 then
    FSeries := FChartView.Series[0]
  else
    FSeries := nil;
  LoadSeriesOptions;
end;

procedure TRMChartForm.cmbSeriesTypeDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  s: string;
  liBitmap: TBitmap;
begin
  s := cmbSeriesType.Items[Index];
  liBitmap := TBitmap.Create;
  try
    ImageList1.GetBitmap(Index, liBitmap);
    cmbSeriesType.Canvas.FillRect(Rect);
    cmbSeriesType.Canvas.BrushCopy(
      Bounds(Rect.Left + 4, Rect.Top, liBitmap.Width, liBitmap.Height),
      liBitmap,
      Bounds(0, 0, liBitmap.Width, liBitmap.Height),
      liBitmap.TransparentColor);
    cmbSeriesType.Canvas.TextOut(Rect.Left + 10 + liBitmap.Width, Rect.Top + (Rect.Bottom - Rect.Top - cmbSeriesType.Canvas.TextHeight(s)) div 2, s);
  finally
    liBitmap.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure TRMChartView_AssignChart(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMChartView(Args.Obj).AssignChart(TChart(V2O(Args.Values[0])));
end;

procedure RM_RegisterRAI2Adapter(RAI2Adapter: TJvInterpreterAdapter);
begin
  with RAI2Adapter do
  begin
    AddClass('ReportMachine', TChart, 'TChart');
    AddClass('ReportMachine', TRMChartView, 'TRMChartView');

    AddGet(TRMChartView, 'AssignChart', TRMChartView_AssignChart, 1, [0], varEmpty)
  end;
end;

initialization
  uChartUIClassList := TList.Create;
  RMRegisterObjectByRes(TRMChartView, 'RM_CHAROBJECT', RMLoadStr(SInsChart), TRMChartForm);

  RMInterpreter_Chart.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  RM_RegisterRAI2Adapter(GlobalJvInterpreterAdapter);

finalization
  uChartUIClassList.Free;
  uChartUIClassList := nil;
{$ENDIF}
end.

