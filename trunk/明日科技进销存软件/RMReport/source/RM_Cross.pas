unit RM_Cross;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls, DB, Buttons, RM_Common, RM_Class, RM_DataSet
{$IFDEF Delphi6}
  , Variants
{$ENDIF};

const
  flCrossShowRowTotal = $2;
  flCrossShowColTotal = $4;
  flCrossShowIndicator = $8;
  flCrossSortColHeader = $10;
  flCrossSortRowHeader = $20;
  flCrossMergeRowHeader = $40;
  flCrossShowRowNo = $80;

type
  TRMCrossObject = class(TComponent)
  end;

  TIntArrayCell = array[0..0] of Integer;
  PIntArrayCell = ^TIntArrayCell;

  { TRMQuickIntarray }
  TRMQuickIntArray = class
  private
    arr: PIntArrayCell;
    len: Integer;
    function GetCell(Index: Integer): Integer;
    procedure SetCell(Index: Integer; const Value: Integer);
  public
    constructor Create(Length: Integer);
    destructor Destroy; override;
    property Cell[Index: Integer]: Integer read GetCell write SetCell; default;
  end;

  { TRMArray }
  TRMArray = class(TObject)
  private
    FFlag_Insert: Boolean;
    FInsertPos: Integer;
    FSortColHeader, FSortRowHeader: Boolean;
    FRows: TStringList;
    FColumns: TStringList;
    FCellItemsCount: Integer;
    FReport: TRMReport;

    function GetCell(const Row, Col: string; Index3: Integer): Variant;
    procedure SetCell(const Row, Col: string; Index3: Integer; Value: Variant);
    function GetCellByIndex(Row, Col, Index3: Integer): Variant;
    function GetCellArray(Row, Col: Integer): Variant;
    procedure SetCellArray(Row, Col: Integer; Value: Variant);
    procedure SetSortColHeader(Value: Boolean);
    procedure SetSortRowHeader(Value: Boolean);
  public
    constructor Create(CellItemsCount: Integer; aReport: TRMReport);
    destructor Destroy; override;
    procedure Clear;
    property Columns: TStringList read FColumns;
    property Rows: TStringList read FRows;
    property CellItemsCount: Integer read FCellItemsCount;
    property Cell[const Row, Col: string; Index3: Integer]: Variant read GetCell write SetCell;
    property CellByIndex[Row, Col, Index3: Integer]: Variant read GetCellByIndex;
    property CellArray[Row, Col: Integer]: Variant read GetCellArray write SetCellArray;
    property SortColHeader: Boolean read FSortColHeader write SetSortColHeader;
    property SortRowHeader: Boolean read FSortRowHeader write SetSortRowHeader;
  end;

  { TRMCross }
  TRMCross = class(TRMArray)
  private
    FDataSet: TDataSet;
    FRowFields, FColFields, FCellFields: TStringList;
    FRowTypes, FColTypes: array[0..31] of Variant;
    FTopLeftSize: TSize;
    FHeaderString: string;
    FRowTotalString: string;
    FRowGrandTotalString: string;
    FColumnTotalString: string;
    FColumnGrandTotalString: string;
    FAddColumnsHeader: TStrings;

    function GetIsTotalRow(Index: Integer): Boolean;
    function GetIsTotalColumn(Index: Integer): Boolean;
  public
    DoDataCol: Boolean;
    ShowRowNo: Boolean;
    DataStr: string;

    constructor Create(aReport: TRMReport; DS: TDataSet; RowFields, ColFields, CellFields: string);
    destructor Destroy; override;
    procedure Build;
    property HeaderString: string read FHeaderString write FHeaderString;
    property RowTotalString: string read FRowTotalString write FRowTotalString;
    property RowGrandTotalString: string read FRowGrandTotalString write FRowGrandTotalString;
    property ColumnTotalString: string read FColumnTotalString write FColumnTotalString;
    property ColumnGrandTotalString: string read FColumnGrandTotalString write FColumnGrandTotalString;
    property TopLeftSize: TSize read FTopLeftSize;
    property IsTotalRow[Index: Integer]: Boolean read GetIsTotalRow;
    property IsTotalColumn[Index: Integer]: Boolean read GetIsTotalColumn;
  end;

  { TRMCrossView }
  TRMCrossView = class(TRMReportView)
  private
    FDataHeight, FDataWidth: Integer;
    FHeaderHeight, FHeaderWidth: string;
    FCross: TRMCross;
    FColumnWidths: TRMQuickIntArray;
    FColumnHeights: TRMQuickIntArray;
    FLastTotalCol: TRMQuickIntArray;
    FFlag: Boolean;
    FSkip: Boolean;
    FRowDS: TRMUserDataset;
    FColumnDS: TRMUserDataset;
    FRepeatCaptions: Boolean;
    FInternalFrame: Boolean;
    FShowHeader: Boolean;
    FDefDY: Integer;
    FLastX: Integer;
    FMaxGTHeight, FMaxCellHeight: Integer;
    FMaxString: string;
    FDictionary: TStrings;
    FAddColumnsHeader: TStrings;
    FRowNoHeader: string;

    FSavedOnBeforePrint: TRMOnBeforePrintEvent;
    FSavedOnPrintColumn: TRMPrintColumnEvent;

    function OneObject(aPage: TRMReportPage; Name1, Name2: string): TRMMemoView;
    function ParentPage: TRMReportPage;
    procedure CreateObjects;
    procedure CalcWidths;
    procedure MakeBands;
    procedure ReportPrintColumn(ColNo: Integer; var Width: Integer);
    procedure ReportBeforePrint(aMemo: TStrings; aView: TRMReportView);

    function GetShowRowTotal: Boolean;
    procedure SetShowRowTotal(Value: Boolean);
    function GetShowColTotal: Boolean;
    procedure SetShowColTotal(Value: Boolean);
    function GetShowIndicator: Boolean;
    procedure SetShowIndicator(Value: Boolean);
    function GetSortColHeader: Boolean;
    procedure SetSortColHeader(Value: Boolean);
    function GetSortRowHeader: Boolean;
    procedure SetSortRowHeader(Value: Boolean);
    function GetMergeRowHeader: Boolean;
    procedure SetMergeRowHeader(Value: Boolean);
    function GetShowRowNo: Boolean;
    procedure SetShowRowNo(Value: Boolean);

    function GetInternalFrame: Boolean;
    procedure SetInternalFrame(Value: Boolean);
    function GetRepeatCaptions: Boolean;
    procedure SetRepeatCaptions(Value: Boolean);
    function GetDataWidth: Integer;
    procedure SetDataWidth(Value: Integer);
    function GetDataHeight: Integer;
    procedure SetDataHeight(Value: Integer);
    function GetHeaderWidth: string;
    procedure SetHeaderWidth(Value: string);
    function GetHeaderHeight: string;
    procedure SetHeaderHeight(Value: string);
    function GetRowNoHeader: string;
    procedure SetRowNoHeader(Value: string);

    function GetDictName(s: string): string;
    function GetDataCellText: string;

    function GetHeaderHeightByIndex(aIndex: Integer): Integer;
    function GetHeaderWidthByIndex(aIndex: Integer): Integer;

    procedure OnColumnDSFirst(Sender: TObject);
  protected
    procedure Prepare; override;
    procedure UnPrepare; override;
    function IsCrossView: Boolean; override;
  public
    class function CanPlaceOnGridView: Boolean; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure Draw(aCanvas: TCanvas); override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure ShowEditor; override;

    property RowDS: TRMUserDataset read FRowDS;
    property ColumnDS: TRMUserDataset read FColumnDS;
  published
    property InternalFrame: Boolean read GetInternalFrame write SetInternalFrame;
    property RepeatCaptions: Boolean read GetRepeatCaptions write SetRepeatCaptions;
    property DataWidth: Integer read GetDataWidth write SetDataWidth;
    property DataHeight: Integer read GetDataHeight write SetDataHeight;
    property HeaderWidth: string read GetHeaderWidth write SetHeaderWidth;
    property HeaderHeight: string read GetHeaderHeight write SetHeaderHeight;
    property RowNoHeader: string read GetRowNoHeader write SetRowNoHeader;
    property ShowRowTotal: Boolean read GetShowRowTotal write SetShowRowTotal;
    property ShowColumnTotal: Boolean read GetShowColTotal write SetShowColTotal;
    property ShowIndicator: Boolean read GetShowIndicator write SetShowIndicator;
    property SortColHeader: Boolean read GetSortColHeader write SetSortColHeader;
    property SortRowHeader: Boolean read GetSortRowHeader write SetSortRowHeader;
    property MergeRowHeader: Boolean read GetMergeRowHeader write SetMergeRowHeader;
    property ShowRowNo: Boolean read GetShowRowNo write SetShowRowNo;

    property Dictionary: TStrings read FDictionary write FDictionary;
    property AddColumnHeader: TStrings read FAddColumnsHeader write FAddColumnsHeader;
  end;

  { TRMCrossForm }
  TRMCrossForm = class(TForm)
    GroupBox1: TGroupBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Shape1: TShape;
    Shape2: TShape;
    GroupBox2: TGroupBox;
    DatasetsLB: TComboBox;
    FieldsLB: TListBox;
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    ComboBox2: TComboBox;
    CheckBox1: TCheckBox;
    btnExchange: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure DatasetsLBClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ListBox3Enter(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure ComboBox2Click(Sender: TObject);
    procedure ListBox4DrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure FieldsLBDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FieldsLBDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox3DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExchangeClick(Sender: TObject);
    procedure ListBox3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FListBox: TListBox;
    FBusy: Boolean;
    DrawPanel: TPanel;
    procedure FillDatasetsLB;
    procedure Localize;
    procedure ClearSelection(Sender: TObject);
  public
    { Public declarations }
    Cross: TRMCrossView;
  end;

implementation

{$R *.DFM}

uses RM_Const, RM_Utils, RM_Insp, RM_PropInsp, RM_EditorStrings;

type
  PRMArrayCell = ^TRMArrayCell;
  TRMArrayCell = record
    Items: Variant;
  end;

  { TRMCrossGroupItem }
  TRMCrossGroupItem = class(TObject)
  private
    Parent: TRMCross;
    FArray: Variant;
    FCellItemsCount: Integer;
    FGroupName: TStringList;
    FIndex: Integer;
    FCount: TRMQuickIntArray;
    FStartFrom: Integer;
    procedure Reset(NewGroupName: string; StartFrom: Integer);
    procedure AddValue(Value: Variant);
    function IsBreak(GroupName: string): Boolean;
    procedure CheckAvg;
    property Value: Variant read FArray;
  public
    constructor Create(AParent: TRMCross; GroupName: string; Index, CellItemsCount: Integer);
    destructor Destroy; override;
  end;

  { TRMCrossList }
  TRMCrossList = class
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(v: TRMCrossView);
    procedure Delete(v: TRMCrossView);
  end;

  TDrawPanel = class(TPanel)
  private
    FColumnFields: TStrings;
    FRowFields: TStrings;
    FCellFields: TStrings;
    LastX, LastY, DefDx, DefDy: Integer;
    procedure Draw(x, y, dx, dy: Integer; s: string);
    procedure DrawColumnCells;
    procedure DrawRowCells;
    procedure DrawCellField;
    procedure DrawBorderLines(pos: byte);
  public
    procedure Paint; override;
  end;

var
  FCrossList: TRMCrossList;

function RMCrossList: TRMCrossList;
begin
  if FCrossList = nil then
  begin
    FCrossList := TRMCrossList.Create;
  end;
  Result := FCrossList;
end;

function HasTotal(s: string): Boolean;
begin
  Result := Pos('+', s) <> 0;
end;

function FuncName(s: string): string;
begin
  if HasTotal(s) then
  begin
    Result := LowerCase(Copy(s, Pos('+', s) + 1, 255));
    if Result = '' then
      Result := 'sum';
  end
  else
    Result := '';
end;

function _PureName(s: string): string;
begin
  if HasTotal(s) then
    Result := Copy(s, 1, Pos('+', s) - 1)
  else
    Result := s;
end;

function CharCount(ch: Char; s: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(s) do
  begin
    if s[i] = ch then
      Inc(Result);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCrossGroupItem }

constructor TRMCrossGroupItem.Create(AParent: TRMCross; GroupName: string;
  Index, CellItemsCount: Integer);
begin
  inherited Create;
  Parent := AParent;
  FCellItemsCount := CellItemsCount;
  FArray := VarArrayCreate([0, CellItemsCount - 1], varVariant);
  FCount := TRMQuickIntArray.Create(CellItemsCount);
  FGroupName := TStringList.Create;
  FIndex := Index;
  Reset(GroupName, 0);
end;

destructor TRMCrossGroupItem.Destroy;
begin
  FGroupName.Free;
  VarClear(FArray);
  FCount.Free;
  inherited Destroy;
end;

procedure TRMCrossGroupItem.Reset(NewGroupName: string; StartFrom: Integer);
var
  i: Integer;
  s: string;
begin
  FStartFrom := StartFrom;
  RMSetCommaText(NewGroupName, FGroupName);
  for i := 0 to FCellItemsCount - 1 do
  begin
    FCount[i] := 0;
    s := FuncName(Parent.FCellFields[i]);
    if (s = 'max') or (s = 'min') then
      FArray[i] := Null
    else
      FArray[i] := 0;
  end;
end;

function TRMCrossGroupItem.IsBreak(GroupName: string): Boolean;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  RMSetCommaText(GroupName, sl);
  Result := (FIndex < sl.Count) and (FIndex < FGroupName.Count) and
    (sl[FIndex] <> FGroupName[FIndex]);
  sl.Free;
end;

procedure TRMCrossGroupItem.AddValue(Value: Variant);
var
  i: Integer;
  s: string;
begin
  if TVarData(Value).VType >= varArray then
  begin
    for i := 0 to FCellItemsCount - 1 do
    begin
      if (Value[i] <> Null) and HasTotal(Parent.FCellFields[i]) then
      begin
        s := FuncName(Parent.FCellFields[i]);
        if (s = 'sum') or (s = 'count') then
          FArray[i] := FArray[i] + Value[i]
        else if s = 'min' then
        begin
          if (FArray[i] = Null) or (FArray[i] > Value[i]) then
            FArray[i] := Value[i];
        end
        else if s = 'max' then
        begin
          if FArray[i] < Value[i] then
            FArray[i] := Value[i];
        end
        else if s = 'avg' then
        begin
          FArray[i] := FArray[i] + Value[i];
          FCount[i] := FCount[i] + 1;
        end;
      end;
    end;
  end;
end;

procedure TRMCrossGroupItem.CheckAvg;
var
  i: Integer;
  s: string;
begin
  for i := 0 to FCellItemsCount - 1 do
  begin
    s := FuncName(Parent.FCellFields[i]);
    if s = 'avg' then
    begin
      if FCount[i] <> 0 then
        FArray[i] := FArray[i] / FCount[i]
      else
        FArray[i] := Null;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMArray }

constructor TRMArray.Create(CellItemsCount: Integer; aReport: TRMReport);
begin
  inherited Create;
  FReport := aReport;
  FCellItemsCount := CellItemsCount;
  FRows := TStringList.Create;
  FRows.Sorted := True;
  FColumns := TStringList.Create;
  FColumns.Sorted := True;
end;

destructor TRMArray.Destroy;
begin
  Clear;
  FRows.Free;
  FColumns.Free;
  inherited Destroy;
end;

procedure TRMArray.Clear;
var
  i, j: Integer;
  sl: TList;
  p: PRMArrayCell;
begin
  for i := 0 to FRows.Count - 1 do
  begin
    sl := Pointer(FRows.Objects[i]);
    if sl <> nil then
    begin
      for j := 0 to sl.Count - 1 do
      begin
        p := sl[j];
        if p <> nil then
        begin
          VarClear(p.Items);
          Dispose(p);
        end;
      end;
    end;
    sl.Free;
  end;

  FRows.Clear;
end;

function TRMArray.GetCell(const Row, Col: string; Index3: Integer): Variant;
var
  i1, i2: Integer;
  sl: TList;
  p: PRMArrayCell;
begin
  Result := Null;
  i1 := FRows.IndexOf(Row);
  i2 := FColumns.IndexOf(Col);
  if (i1 = -1) or (i2 = -1) or (Index3 >= FCellItemsCount) then
    Exit;
  i2 := Integer(FColumns.Objects[i2]);

  if i1 < FRows.Count then
    sl := Pointer(FRows.Objects[i1])
  else
    sl := nil;
  if sl <> nil then
  begin
    if i2 < sl.Count then
      p := sl[i2]
    else
      p := nil;
    if p <> nil then
      Result := p^.Items[Index3];
  end;
end;

procedure TRMArray.SetCell(const Row, Col: string; Index3: Integer; Value: Variant);
var
  i, j, i1, i2: Integer;
  sl: TList;
  p: PRMArrayCell;
begin
  i1 := FRows.IndexOf(Row);
  i2 := FColumns.IndexOf(Col);
  if i2 <> -1 then
    i2 := Integer(FColumns.Objects[i2]);

  if i1 = -1 then // row does'nt exists, so create it
  begin
    sl := TList.Create;
    if FFlag_Insert and (not FRows.Sorted) and (FInsertPos < FRows.Count) then
      FRows.InsertObject(FInsertPos, Row, sl)
    else
      FRows.AddObject(Row, sl);
    i1 := FRows.IndexOf(Row);
  end;

  if i2 = -1 then // column does'nt exists, so create it
  begin
    if FFlag_Insert and (not FColumns.Sorted) then
      FColumns.InsertObject(FInsertPos, Col, TObject(FColumns.Count))
    else
      FColumns.AddObject(Col, TObject(FColumns.Count));
    i2 := FColumns.Count - 1;
  end;

  sl := Pointer(FRows.Objects[i1]);
  p := nil;
  if i2 < sl.Count then
    p := sl[i2]
  else
  begin
    i2 := i2 - sl.Count;
    for i := 0 to i2 do
    begin
      New(p);
      p^.Items := VarArrayCreate([-1, FCellItemsCount - 1], varVariant);
      for j := -1 to FCellItemsCount - 1 do
        p^.Items[j] := Null;
      sl.Add(p);
    end;
  end;
  p^.Items[Index3] := Value;
end;

function TRMArray.GetCellByIndex(Row, Col, Index3: Integer): Variant;
var
  sl: TList;
  p: PRMArrayCell;
begin
  Result := Null;
  if (Row = -1) or (Col = -1) or (Index3 >= FCellItemsCount) then
    Exit;
  if Col < FColumns.Count then
    Col := Integer(FColumns.Objects[Col]);

  if Row < FRows.Count then
    sl := Pointer(FRows.Objects[Row])
  else
    sl := nil;
  if sl <> nil then
  begin
    if Col < sl.Count then
      p := sl[Col]
    else
      p := nil;
    if p <> nil then
      Result := p^.Items[Index3];
  end;
end;

function TRMArray.GetCellArray(Row, Col: Integer): Variant;
var
  sl: TList;
  p: PRMArrayCell;
begin
  Result := Null;
  if (Row = -1) or (Col = -1) then
    Exit;
  if Col < FColumns.Count then
    Col := Integer(FColumns.Objects[Col]);

  if Row < FRows.Count then
    sl := Pointer(FRows.Objects[Row])
  else
    sl := nil;
  if sl <> nil then
  begin
    if Col < sl.Count then
      p := sl[Col]
    else
      p := nil;
    if p <> nil then
      Result := p^.Items;
  end;
end;

procedure TRMArray.SetCellArray(Row, Col: Integer; Value: Variant);
var
  i: Integer;
  lList: TList;
  p: PRMArrayCell;
begin
  if (Row = -1) or (Col = -1) then
    Exit;
  Cell[FRows[Row], Columns[Col], 0] := 0;

  if Col < FColumns.Count then
    Col := Integer(FColumns.Objects[Col]);

  if Row < FRows.Count then
    lList := Pointer(FRows.Objects[Row])
  else
    lList := nil;
  if lList <> nil then
  begin
    if Col < lList.Count then
      p := lList[Col]
    else
      p := nil;
    if p <> nil then
    begin
      for i := 0 to FCellItemsCount - 1 do
        p^.Items[i] := Value[i];
    end;
  end;
end;

procedure TRMArray.SetSortColHeader(Value: Boolean);
begin
  FSortColHeader := Value;
  FColumns.Sorted := FSortColHeader;
end;

procedure TRMArray.SetSortRowHeader(Value: Boolean);
begin
  FSortRowHeader := Value;
  FRows.Sorted := FSortRowHeader;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCross }

procedure _Sort(aStringList: TStringList);
var
  n, i: Integer;

  function _SubStrCount(aSubStr, aStr: string): Integer;
  var //取子串在子串中出现多少次
    i, l: Integer;
  begin
    Result := 0;
    l := Length(aSubStr);
    for i := 1 to Length(aStr) - l do
    begin
      if Copy(aStr, i, l) = aSubStr then
        inc(Result);
    end;
  end;

  procedure _Sort1(aStringList: TStringList; n: Integer);
  var
    i, j: Integer;
    lString1, lString2: string;
    lStrList: TStringList;

    function _PreNSubString(aString: string; n: Integer): string;
    var
      i, j, k: Integer;
    begin //取第N个';'前的子串
      j := 0;
      k := 0;
      for i := 1 to Length(aString) do
      begin
        k := i;
        if aString[i - 1] = ';' then
          inc(j);
        if j = n then
          break;
      end;
      Result := Copy(aString, 1, k - 1);
    end;

  begin
    lStrList := TStringList.Create;
    try
      for i := 0 to aStringList.Count - 1 do
      begin
        if aStringList.Strings[i] <> '' then //没有被选过的才参加选择
        begin
          lString1 := _PreNSubString(aStringList.Strings[i], n);
          lStrList.AddObject(aStringList[i], aStringList.Objects[i]);
          aStringList.Strings[i] := ''; //已经被选过的清空
          for j := (i + 1) to (aStringList.Count - 1) do //扫描剩下没有选过的串
          begin
            if aStringList.Strings[j] <> '' then
            begin
              lString2 := _PreNSubString(aStringList.Strings[j], n);
              if lString2 = lString1 then
              begin
                lStrList.AddObject(aStringList[j], aStringList.Objects[j]);
                aStringList.Strings[j] := '';
              end;
            end;
          end;
        end;
      end;
      aStringList.Clear;
      aStringList.Assign(lStrList);
    finally
      lStrList.Free;
    end;
  end;

begin //需要进行N次排序
  n := _SubStrCount(';', aStringList.Strings[0]);
  for i := 1 to n do
  begin
    _Sort1(aStringList, i);
  end;
end;

constructor TRMCross.Create(aReport: TRMReport; DS: TDataSet; RowFields, ColFields, CellFields: string);
begin
  FDataSet := DS;
  FRowFields := TStringList.Create;
  FColFields := TStringList.Create;
  FCellFields := TStringList.Create;

  while RowFields[Length(RowFields)] in ['+', ';'] do
    RowFields := Copy(RowFields, 1, Length(RowFields) - 1);
  while ColFields[Length(ColFields)] in ['+', ';'] do
    ColFields := Copy(ColFields, 1, Length(ColFields) - 1);

  RMSetCommaText(RowFields, FRowFields);
  RMSetCommaText(ColFields, FColFields);
  RMSetCommaText(CellFields, FCellFields);

  inherited Create(FCellFields.Count, aReport);

  FSortColHeader := True;
  FSortRowHeader := True;
  FAddColumnsHeader := TStringList.Create;
end;

destructor TRMCross.Destroy;
begin
  FreeAndNil(FRowFields);
  FreeAndNil(FColFields);
  FreeAndNil(FCellFields);
  FreeAndNil(FAddColumnsHeader);
  inherited Destroy;
end;

const
  RMftNone = 0;
  RMftRight = 1;
  RMftBottom = 2;
  RMftLeft = 4;
  RMftTop = 8;

procedure TRMCross.Build;
var
  i: Integer;
  lField: TField;
  v: Variant;
  s1, s2: string;

  function GetFieldValues(sl: TStringList): string;
  var
    i, j, n: Integer;
    s: string;
    lField: TField;
    v: Variant;
    d: Double;
  begin
    Result := '';
    for i := 0 to sl.Count - 1 do
    begin
      s := _PureName(sl[i]);
      lField := TField(FDataSet.FindField(FReport.Dictionary.RealFieldName[s]));
      v := lField.Value;
      if (TVarData(v).VType = varOleStr) or (TVarData(v).VType = varString) then
        Result := Result + lField.AsString + ';'
      else
      begin
        if v = Null then
          d := 0
        else
        begin
          d := v;
          if sl = FRowFields then
            FRowTypes[i] := v
          else if sl = FColFields then
            FColTypes[i] := v;
        end;

        s := Format('%2.6f', [d]);
        n := 32 - Length(s);
        for j := 1 to n do
          s := ' ' + s;

        Result := Result + s + ';';
      end;
    end;
    if Result <> '' then
      Result := Copy(Result, 1, Length(Result) - 1);
  end;

  procedure FormGroup(NewGroup, OldGroup: string; Direction: Boolean; aIndex: Integer);
  var
    i, j: Integer;
    sl1, sl2: TStringList;

    procedure FormGroup1(Index: Integer);
    var
      i: Integer;
      s: string;
    begin
      s := '';
      for i := 0 to Index - 1 do
        s := s + sl1[i] + ';';
      s := s + sl1[Index] + '+;+';
      if Direction then
      begin
        if HasTotal(FColFields[Index]) then
          Cell[Rows[0], s, 0] := 0
      end
      else if HasTotal(FRowFields[Index]) then
        Cell[s, Columns[0], 0] := 0;
    end;

  begin
    sl1 := TStringList.Create;
    sl2 := TStringList.Create;
    RMSetCommaText(OldGroup, sl1);
    RMSetCommaText(NewGroup, sl2);
    FFlag_Insert := (Direction and (not SortColHeader)) or (not Direction and (not SortRowHeader));
    try
      for i := 0 to sl1.Count - 1 do
      begin
        if (NewGroup = '') or (sl1[i] <> sl2[i]) then
        begin
          for j := sl1.Count - 1 downto i do
          begin
            FormGroup1(j);
            Inc(FInsertPos);
          end;
          Break;
        end;
      end;
    finally
      FFlag_Insert := False;
      FreeAndNil(sl1);
      FreeAndNil(sl2);
    end;
  end;

  procedure MakeTotals(sl: TStringList; Direction: Boolean); // Direction=True sl=Columns else sl=Rows
  var
    i: Integer;
    s, Old: string;
  begin
    Old := sl[0];
    i := 0;
    FInsertPos := 0;
    while i < sl.Count do
    begin
      s := sl[i];
      if (s <> Old) and (Pos('+', s) = 0) then
      begin
        FormGroup(s, Old, Direction, i - 1);
        Old := s;
      end;
      Inc(i);
    end;
    FormGroup('', sl[sl.Count - 1], Direction, sl.Count);
  end;

  procedure CalcTotals(FieldsSl, RowsSl, ColumnsSl: TStringList);
  var
    i, j, k, i1: Integer;
    lList: TList;
    cg: TRMCrossGroupItem;
  begin
    lList := TList.Create;
    lList.Add(TRMCrossGroupItem.Create(Self, '', FieldsSl.Count, FCellItemsCount)); // grand total
    for i := 0 to FieldsSl.Count - 1 do
      lList.Add(TRMCrossGroupItem.Create(Self, ColumnsSl[0], i, FCellItemsCount));

    for i := 0 to RowsSl.Count - 1 do
    begin
      for k := 0 to FieldsSl.Count do
        TRMCrossGroupItem(lList[k]).Reset(ColumnsSl[0], 0);
      for j := 0 to ColumnsSl.Count - 1 do
      begin
        for k := 0 to FieldsSl.Count do
        begin
          cg := TRMCrossGroupItem(lList[k]);
          if cg.IsBreak(ColumnsSl[j]) or ((k = 0) and (j = ColumnsSl.Count - 1)) then
          begin
            if (k = 0) or HasTotal(FieldsSl[k - 1]) then
            begin
              cg.CheckAvg;
              if RowsSl = Rows then
              begin
                CellArray[i, j] := cg.Value;
                Cell[Rows[0], Columns[j], -1] := cg.FStartFrom;
              end
              else
              begin
                CellArray[j, i] := cg.Value;
                Cell[Rows[j], Columns[0], -1] := cg.FStartFrom;
              end;
            end;

            i1 := j;
            while i1 < ColumnsSl.Count do
            begin
              if Pos('+;+', ColumnsSl[i1]) = 0 then
                break;
              Inc(i1);
            end;
            if i1 < ColumnsSl.Count then
              cg.Reset(ColumnsSl[i1], j);
            break;
          end
          else if Pos('+;+', ColumnsSl[j]) = 0 then
          begin
            if RowsSl = Rows then
              cg.AddValue(CellArray[i, j])
            else
              cg.AddValue(CellArray[j, i]);
          end;
        end;
      end;
    end;

    for i := 0 to FieldsSl.Count do
      TRMCrossGroupItem(lList[i]).Free;

    FreeAndNil(lList);
  end;

  procedure CheckAvg;
  var
    i, j: Integer;
    v: Variant;
    n: TRMQuickIntArray;
    Check: Boolean;

    procedure CalcAvg(i1, j1: Integer);
    var
      i, j, k: Integer;
      v1: Variant;
    begin
      for i := 0 to FCellFields.Count - 1 do
      begin
        v[i] := 0;
        n[i] := 0;
      end;

      for i := CellByIndex[i1, 0, -1] to i1 - 1 do
      begin
        for j := CellByIndex[0, j1, -1] to j1 - 1 do
        begin
          if (not IsTotalRow[i]) and (not IsTotalColumn[j]) then
          begin
            for k := 0 to FCellFields.Count - 1 do
            begin
              if FuncName(FCellFields[k]) = 'avg' then
              begin
                v1 := CellByIndex[i, j, k];
                if v1 <> Null then
                begin
                  n[k] := n[k] + 1;
                  v[k] := v[k] + v1;
                end;
              end;
            end;
          end;
        end;
      end;

      for i := 0 to FCellFields.Count - 1 do
      begin
        if FuncName(FCellFields[i]) = 'avg' then
        begin
          if n[i] <> 0 then
            Cell[Rows[i1], Columns[j1], i] := v[i] / n[i]
          else
            Cell[Rows[i1], Columns[j1], i] := Null;
        end;
      end;
    end;

  begin
    v := VarArrayCreate([0, FCellFields.Count - 1], varVariant);
    n := TRMQuickIntArray.Create(FCellFields.Count);

    Check := False;
    for i := 0 to FCellFields.Count - 1 do
    begin
      if FuncName(FCellFields[i]) = 'avg' then
      begin
        Check := True;
        break;
      end;
    end;

    if Check then
    begin
      for i := 0 to Rows.Count - 1 do
      begin
        if IsTotalRow[i] or (i = Rows.Count - 1) then
        begin
          for j := 0 to Columns.Count - 1 do
          begin
            if IsTotalColumn[j] or (j = Columns.Count - 1) then
              CalcAvg(i, j);
          end;
        end;
      end;
    end;

    for i := 0 to Rows.Count - 1 do
      Cell[Rows[i], Columns[0], -1] := Null;
    for i := 0 to Columns.Count - 1 do
      Cell[Rows[0], Columns[i], -1] := Null;

    VarClear(v);
    n.Free;
  end;

  procedure MakeColumnHeader;
  var
    i, j, n, cn: Integer;
    s: string;
    sl, sl1: TStringList;
    Flag: Boolean;
    d: Double;
    v: Variant;

    function CompareSl(Index: Integer): Boolean;
    begin
      Result := (sl.Count > Index) and (sl1.Count > Index) and (sl[Index] = sl1[Index]);
    end;

  begin
    sl := TStringList.Create;
    sl1 := TStringList.Create;
    cn := CharCount(';', Columns[0]) + 1; // height of header
    FTopLeftSize.cy := cn;

    FFlag_Insert := True;
    for i := 0 to cn do
    begin
      FInsertPos := i;
      Cell[Chr(i), Columns[0], 0] := '';
    end;
    FFlag_Insert := False;

    for i := 0 to Columns.Count - 1 do
      Cell[#0, Columns[i], -1] := rmftTop or rmftBottom;

    Cell[#0, Columns[0], 0] := FHeaderString;
    Cell[#0, Columns[0], -1] := rmftLeft or rmftTop or rmftBottom;
    Cell[#0, Columns[Columns.Count - 1], -1] := rmftTop or rmftRight;
    for i := 1 to FAddColumnsHeader.Count do
      Cell[#0, Columns[Columns.Count - 1 - i], -1] := rmftTop or rmftRight;

    for i := 1 to cn do
    begin
      Cell[Chr(i), Columns[Columns.Count - 1], -1] := rmftLeft or rmftRight;
      for j := 1 to FAddColumnsHeader.Count do
        Cell[Chr(i), Columns[Columns.Count - 1 - j], -1] := rmftLeft or rmftRight;
    end;

    Cell[#1, Columns[Columns.Count - 1 - FAddColumnsHeader.Count], 0] := FColumnGrandTotalString;
    Cell[#1, Columns[Columns.Count - 1 - FAddColumnsHeader.Count], -1] := rmftLeft or rmftTop or rmftRight;
    for i := 0 to FAddColumnsHeader.Count - 1 do
    begin
      Cell[#1, Columns[Columns.Count - 1 - i], 0] := FAddColumnsHeader[FAddColumnsHeader.Count - 1 - i];
      Cell[#1, Columns[Columns.Count - 1 - i], -1] := rmftLeft or rmftTop or rmftRight;
    end;

    for i := 0 to Columns.Count - 2 - FAddColumnsHeader.Count do
    begin
      s := Columns[i];
      RMSetCommaText(s, sl);
      if Pos('+;+', s) <> 0 then
      begin
        n := CharCount(';', s);
        for j := 1 to n - 1 do
          Cell[Chr(j), s, -1] := rmftTop;

        for j := n to cn do
        begin
          if j = n then
          begin
            Cell[Chr(j), s, 0] := FColumnTotalString;
            Cell[Chr(j), s, -1] := rmftRight or rmftLeft or rmftTop;
          end
          else
            Cell[Chr(j), s, -1] := rmftRight or rmftLeft;
        end;
      end
      else
      begin
        Flag := False;
        for j := 0 to cn - 1 do
        begin
          if (not Flag) and CompareSl(j) then
            Cell[Chr(j + 1), s, -1] := rmftTop
          else
          begin
            if TVarData(FColTypes[j]).VType = varDate then
            begin
              d := StrToFloat(Trim(sl[j]));
              TVarData(FColTypes[j]).VDate := d;
              v := FColTypes[j];
            end
            else if (TVarData(FColTypes[j]).VType = varString) or
              (TVarData(FColTypes[j]).VType = varOleStr) or
              (TVarData(FColTypes[j]).VType = varEmpty) or
              (TVarData(FColTypes[j]).VType = varNull) then
              v := Trim(sl[j])
            else
            begin
              d := StrToFloat(Trim(sl[j]));
              v := FloatToStr(d);
            end;
            Cell[Chr(j + 1), s, 0] := v;
            Cell[Chr(j + 1), s, -1] := rmftTop or rmftLeft or rmftRight;
            Flag := True;
          end;
        end;
      end;
      sl1.Assign(sl);
    end;

    FreeAndNil(sl);
    FreeAndNil(sl1);
  end;

  procedure MakeRowHeader;
  var
    i, j, n, cn: Integer;
    s: string;
    sl, sl1: TStringList;
    Flag: Boolean;
    d: Double;
    v: Variant;
    lNowRowNo: Integer;

    function CompareSl(Index: Integer): Boolean;
    begin
      Result := (sl.Count > Index) and (sl1.Count > Index) and (sl[Index] = sl1[Index]);
    end;

    procedure CellOr(Index1, Index2: string; Value: Integer);
    var
      v: Variant;
    begin
      v := Cell[Index1, Index2, -1];
      if v = Null then
        v := 0;
      v := v or Value;
      Cell[Index1, Index2, -1] := v;
    end;

  begin
    sl := TStringList.Create;
    sl1 := TStringList.Create;
    cn := CharCount(';', Rows[FTopLeftSize.cy + 1]) + 1 + Ord(DoDataCol) + Ord(ShowRowNo); // width of header
    FTopLeftSize.cx := cn;

    FFlag_Insert := True;
    for i := 0 to cn - 1 do
    begin
      FInsertPos := i;
      Cell[Rows[0], Chr(i), 0] := '';
    end;
    FFlag_Insert := False;

    Cell[Rows[Rows.Count - 1], #0, 0] := FRowGrandTotalString;
    Cell[Rows[Rows.Count - 1], #0, -1] := rmftTop or rmftBottom or rmftLeft;

    for i := 1 to cn - 1 do
      Cell[Rows[Rows.Count - 1], Chr(i), -1] := rmftTop or rmftBottom;

    if DoDataCol then
    begin
      for i := FTopLeftSize.cy + 1 to Rows.Count - 1 do
      begin
        Cell[Rows[i], Chr(cn - 1), 0] := DataStr;
        Cell[Rows[i], Chr(cn - 1), -1] := 15;
      end;
    end;

    for i := 0 to FTopLeftSize.cy do
    begin
      for j := 0 to cn - 1 do
        Cell[Chr(i), Chr(j), -1] := 0;
    end;

    lNowRowNo := 1;
    for i := FTopLeftSize.cy + 1 to Rows.Count - 2 do
    begin
      s := Rows[i];
      RMSetCommaText(s, sl);
      if Pos('+;+', s) <> 0 then
      begin
        n := CharCount(';', s);
        for j := 1 to n - 1 + Ord(ShowRowNo) do
          Cell[s, Chr(j - 1), -1] := rmftLeft;

        for j := n + Ord(ShowRowNo) to cn - Ord(DoDataCol) do
        begin
          if (j = n + Ord(ShowRowNo)) then
          begin
            Cell[s, Chr(j - 1), 0] := FRowTotalString;
            Cell[s, Chr(j - 1), -1] := rmftLeft or rmftTop;
          end
          else
          begin
            Cell[s, Chr(j - 1), -1] := rmftTop or rmftBottom;
          end;
        end;
      end
      else
      begin
        Flag := False;
        for j := Ord(ShowRowNo) to cn - 1 - Ord(DoDataCol) do
        begin
          if (not Flag) and CompareSl(j - Ord(ShowRowNo)) then
          begin
            Cell[s, Chr(j), -1] := rmftLeft;
            if ShowRowNo and (j = 1) then
              Cell[s, Chr(0), -1] := rmftLeft;
          end
          else
          begin
            if TVarData(FRowTypes[j - Ord(ShowRowNo)]).VType = varDate then
            begin
              d := StrToFloat(Trim(sl[j - Ord(ShowRowNo)]));
              TVarData(FRowTypes[j]).VDate := d;
              v := FRowTypes[j];
            end
            else if (TVarData(FRowTypes[j - Ord(ShowRowNo)]).VType = varString) or
            (TVarData(FRowTypes[j - Ord(ShowRowNo)]).VType = varOleStr) or
            (TVarData(FRowTypes[j - Ord(ShowRowNo)]).VType = varEmpty) or
            (TVarData(FRowTypes[j - Ord(ShowRowNo)]).VType = varNull) then
              v := Trim(sl[j - Ord(ShowRowNo)])
            else
            begin
              d := StrToFloat(Trim(sl[j - Ord(ShowRowNo)]));
              v := FloatToStr(d);
            end;
            Cell[s, Chr(j), 0] := v;
            Cell[s, Chr(j), -1] := rmftTop or rmftLeft;
            if ShowRowNo and (j = 1) then
            begin
              Cell[s, Chr(0), 0] := lNowRowNo;
              Cell[s, Chr(0), -1] := rmftTop or rmftLeft;
              Inc(lNowRowNo);
            end;
            Flag := True;
          end;
        end;
      end;
      sl1.Assign(sl);
    end;

    FreeAndNil(sl);
    FreeAndNil(sl1);

    for i := cn to Columns.Count - 1 do
      CellOr(Rows[Rows.Count - 1], Columns[i], 15);
    for i := cn to Columns.Count - 1 do
      CellOr(Rows[FTopLeftSize.cy], Columns[i], rmftBottom);
    for i := 0 to cn - 1 - ord(DoDataCol) do
      CellOr(Rows[Rows.Count - 2], Columns[i], rmftBottom);
  end;

begin
  FDataSet.Open;
  FDataSet.First;
  while not FDataSet.EOF do
  begin
    Application.ProcessMessages;
    for i := 0 to FCellFields.Count - 1 do
    begin
      lField := FDataSet.FindField(FReport.Dictionary.RealFieldName[_PureName(FCellFields[i])]);
      if FuncName(FCellFields[i]) = 'count' then
      begin
        v := 0;
        if lField.Value <> Null then
          v := 1;
      end
      else
        v := lField.Value;

      s1 := GetFieldValues(FRowFields);
      s2 := GetFieldValues(FColFields);
      if Cell[s1, s2, i] = Null then
        Cell[s1, s2, i] := v
      else
        Cell[s1, s2, i] := Cell[s1, s2, i] + v;
    end;
    FDataSet.Next;
  end;

  if Columns.Count = 0 then
    Exit;

  if (not SortColHeader) and (CharCount(';', Columns[0]) > 0) then
    _Sort(FColumns);
  if (not SortRowHeader) and (CharCount(';', Rows[0]) > 0) then
    _Sort(FRows);

  MakeTotals(Columns, True);
  Cell[Rows[0], Columns[Columns.Count - 1] + '+', 0] := 0;
  MakeTotals(Rows, False);
  Cell[Rows[Rows.Count - 1] + '+', Columns[0], 0] := 0;

  CalcTotals(FColFields, Rows, Columns);
  CalcTotals(FRowFields, Columns, Rows);
  CheckAvg;

  for i := 0 to FAddColumnsHeader.Count - 1 do
  begin
    Cell[Rows[0], Columns[Columns.Count - 1] + '+', 0] := 0;
  end;

  MakeColumnHeader;
  MakeRowHeader;
end;

function TRMCross.GetIsTotalRow(Index: Integer): Boolean;
begin
  Result := Pos('+;+', Rows[Index]) <> 0;
end;

function TRMCross.GetIsTotalColumn(Index: Integer): Boolean;
begin
  Result := Pos('+;+', Columns[Index]) <> 0;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMQuickArray }

constructor TRMQuickIntArray.Create(Length: Integer);
begin
  inherited Create;

  Len := Length;
  GetMem(arr, Len * SizeOf(TIntArrayCell));
  for Length := 0 to Len - 1 do
    arr[Length] := 0;
end;

destructor TRMQuickIntArray.Destroy;
begin
  FreeMem(arr, Len * SizeOf(TIntArrayCell));

  inherited;
end;

function TRMQuickIntArray.GetCell(Index: Integer): Integer;
begin
  Result := arr[Index];
end;

procedure TRMQuickIntArray.SetCell(Index: Integer; const Value: Integer);
begin
  arr[Index] := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCrossList }

function PureName1(s: string): string;
begin
  if Pos('+', s) <> 0 then
    Result := Copy(s, 1, Pos('+', s) - 1)
  else
    Result := s;
end;

constructor TRMCrossList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TRMCrossList.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TRMCrossList.Add(v: TRMCrossView);
begin
  FList.Add(v);
  v.FSavedOnBeforePrint := v.ParentReport.OnBeforePrint;
  v.ParentReport.OnBeforePrint := v.ReportBeforePrint;
  v.FSavedOnPrintColumn := v.ParentReport.OnPrintColumn;
  v.ParentReport.OnPrintColumn := v.ReportPrintColumn;
end;

procedure TRMCrossList.Delete(v: TRMCrossView);
var
  i: Integer;
  v1: TRMCrossView;
begin
  v.ParentReport.OnBeforePrint := v.FSavedOnBeforePrint;
  v.ParentReport.OnPrintColumn := v.FSavedOnPrintColumn;

  i := FList.IndexOf(v);
  FList.Delete(i);

  if (i = 0) and (FList.Count > 0) then
  begin
    v := TRMCrossView(FList[0]);
    v.FSavedOnBeforePrint := v.ParentReport.OnBeforePrint;
    v.FSavedOnPrintColumn := v.ParentReport.OnPrintColumn;
  end;

  for i := 1 to FList.Count - 1 do
  begin
    v := TRMCrossView(FList[i]);
    v1 := TRMCrossView(FList[i - 1]);
    v.FSavedOnBeforePrint := v1.ReportBeforePrint;
    v.FSavedOnPrintColumn := v1.ReportPrintColumn;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMCrossView}

class function TRMCrossView.CanPlaceOnGridView: Boolean;
begin
  Result := False;
end;

function TRMCrossView.IsCrossView: Boolean;
begin
  Result := True;
end;

constructor TRMCrossView.Create;
begin
  inherited Create;
  FCross := nil;
  BaseName := 'Cross';

  DontUndo := True;
  OnePerPage := True;
  Restrictions := [rmrtDontSize, rmrtDontEditMemo];
  spWidth := 348;
  spHeight := 94;
  Visible := False;
  LeftFrame.Visible := True;
  TopFrame.Visible := True;
  RightFrame.Visible := True;
  BottomFrame.Visible := True;

  ParentReport := RMCurReport;
  RMCrossList.Add(Self);

  ShowRowTotal := False;
  ShowColumnTotal := False;
  ShowIndicator := True;
  SortColHeader := True;
  SortRowHeader := True;
  FInternalFrame := True;
  FDataWidth := 0; FDataHeight := 0;
  FHeaderWidth := '0';
  FHeaderHeight := '0';
  FDefDY := 18;

  FDictionary := TStringList.Create;
  FAddColumnsHeader := TStringList.Create;
end;

destructor TRMCrossView.Destroy;
var
  i: Integer;
  lPage: TRMReportPage;

  procedure _Del(s: string);
  var
    t: TRMView;
  begin
    if lPage <> nil then
    begin
      t := lPage.FindObject(s);
      if t <> nil then
        lPage.Delete(lPage.Objects.IndexOf(t));
    end;
  end;

begin
  lPage := nil;
  for i := 0 to ParentReport.Pages.Count - 1 do
  begin
    if ParentReport.Pages[i].FindObject(Self.Name) <> nil then
    begin
      lPage := TRMReportPage(ParentReport.Pages[i]);
      Break;
    end;
  end;

  _Del('ColumnHeaderMemo' + Name);
  _Del('ColumnTotalMemo' + Name);
  _Del('GrandColumnTotalMemo' + Name);
  _Del('RowHeaderMemo' + Name);
  _Del('CellMemo' + Name);
  _Del('RowTotalMemo' + Name);
  _Del('GrandRowTotalMemo' + Name);
  _Del('ColHeaderMemo' + Name);
  _Del('CrossHeaderMemo' + Name);

  RMCrossList.Delete(Self);

  FreeAndNil(FDictionary);
  FreeAndNil(FAddColumnsHeader);

  inherited Destroy;
end;

type
  THackReport = class(TRMReport)
  end;

  THackReportPage = class(TRMReportPage)
  end;

  THackMemoView = class(TRMMemoView)
  end;

  THackUserDataset = class(TRMUserDataset)
  end;

function TRMCrossView.OneObject(aPage: TRMReportPage; Name1, Name2: string): TRMMemoView;
begin
  Result := TRMMemoView(RMCreateObject(rmgtMemo, ''));
  Result.ParentPage := aPage;
  Result.Name := Name1 + Name;
  Result.Memo.Add(Name2);
  Result.Font.Style := [fsBold];
  Result.spWidth := 80;
  Result.spHeight := FDefDY;
  Result.HAlign := rmHCenter;
  Result.VAlign := rmVCenter;
  Result.LeftFrame.Visible := True;
  Result.RightFrame.Visible := True;
  Result.TopFrame.Visible := True;
  Result.BottomFrame.Visible := True;
  Result.Restrictions := [rmrtDontSize, rmrtDontMove, rmrtDontDelete];
  THackMemoView(Result).IsChildView := True;
  Result.Visible := False;
end;

function TRMCrossView.ParentPage: TRMReportPage;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to ParentReport.Pages.Count - 1 do
  begin
    if ParentReport.Pages[i].FindObject(Self.Name) <> nil then
    begin
      Result := TRMReportPage(ParentReport.Pages[i]);
      Break;
    end;
  end;
end;

procedure TRMCrossView.CreateObjects;
var
  v: TRMMemoView;
  p: TRMReportPage;
begin
  p := ParentPage;

  OneObject(p, 'ColumnHeaderMemo', RMLoadStr(rmRes + 755)); //'Header'

  v := OneObject(p, 'ColumnTotalMemo', RMLoadStr(rmRes + 756)); //'Total'
  v.FillColor := $F5F5F5;

  v := OneObject(p, 'GrandColumnTotalMemo', RMLoadStr(rmRes + 757)); //'Grand total'
  v.FillColor := clSilver;

  OneObject(p, 'RowHeaderMemo', RMLoadStr(rmRes + 755)); //'Header'

  v := OneObject(p, 'CellMemo', RMLoadStr(rmRes + 758)); //'Cell'
  v.Font.Style := [];

  v := OneObject(p, 'RowTotalMemo', RMLoadStr(rmRes + 756)); //'Total'
  v.FillColor := $F5F5F5;

  v := OneObject(p, 'GrandRowTotalMemo', RMLoadStr(rmRes + 757)); //'Grand total'
  v.FillColor := clSilver;

  OneObject(p, 'CrossHeaderMemo', '');
end;

procedure TRMCrossView.ShowEditor;
var
  tmp: TRMCrossForm;
begin
  tmp := TRMCrossForm.Create(Application);
  try
    tmp.Cross := Self;
    tmp.ShowModal;
  finally
    tmp.Free;
  end;
end;

procedure TRMCrossView.Draw(aCanvas: TCanvas);
var
  v: TRMView;
  bmp: TBitmap;
  p: TRMReportPage;
begin
  if ParentReport.FindObject('ColumnHeaderMemo' + Name) = nil then
    CreateObjects;
  BeginDraw(aCanvas);
  CalcGaps;
  ShowBackground;
  ShowFrame;

  v := ParentReport.FindObject('ColumnHeaderMemo' + Name);
  v.SetspBounds(spLeft + 92, spTop + 8, v.spWidth, v.spHeight);
  v.Draw(aCanvas);

  v := ParentReport.FindObject('ColumnTotalMemo' + Name);
  v.SetspBounds(spLeft + 176, spTop + 8, v.spWidth, v.spHeight);
  v.Draw(aCanvas);

  v := ParentReport.FindObject('GrandColumnTotalMemo' + Name);
  v.SetspBounds(spLeft + 260, spTOp + 8, v.spWidth, v.spHeight);
  v.Draw(aCanvas);

  v := ParentReport.FindObject('RowHeaderMemo' + Name);
  v.SetspBounds(spLeft + 8, spTop + 28, v.spWidth, v.spHeight);
  v.Draw(aCanvas);

  v := ParentReport.FindObject('CellMemo' + Name);
  v.SetspBounds(spLeft + 92, spTop + 28, v.spWidth, v.spHeight);
  v.Draw(aCanvas);

  v := ParentReport.FindObject('RowTotalMemo' + Name);
  v.SetspBounds(spLeft + 8, spTop + 48, v.spWidth, v.spHeight);
  v.Draw(aCanvas);

  v := ParentReport.FindObject('GrandRowTotalMemo' + Name);
  v.SetspBounds(spLeft + 8, spTop + 68, v.spWidth, v.spHeight);
  v.Draw(aCanvas);

  v := ParentReport.FindObject('CrossHeaderMemo' + Name);
  if v = nil then
  begin
    p := ParentPage;
    v := OneObject(p, 'CrossHeaderMemo', '');
  end;
  v.SetspBounds(spLeft + 8, spTop + 8, v.spWidth, v.spHeight);
  v.Draw(aCanvas);

  bmp := TBitmap.Create;
  try
    bmp.Handle := LoadBitmap(hInstance, 'RM_CrossObject');
    aCanvas.Draw(spLeft + spWidth - 20, spTop + spHeight - 20, bmp);
  finally
    bmp.Free;
  end;
  RestoreCoord;
end;

procedure TRMCrossView.LoadFromStream(aStream: TStream);
begin
  inherited LoadFromStream(aStream);
  RMReadWord(aStream);
  FInternalFrame := RMReadBoolean(aStream);
  FRepeatCaptions := RMReadBoolean(aStream);
  FShowHeader := RMReadBoolean(aStream);
  FDataWidth := RMReadInt32(aStream);
  FDataHeight := RMReadInt32(aStream);
  FHeaderWidth := RMReadString(aStream);
  FHeaderHeight := RMReadString(aStream);
  FDictionary.Text := RMReadString(aStream);
  FRowNoHeader := RMReadString(aStream);
  RMReadMemo(aStream, FAddColumnsHeader);
  OnePerPage := True;
end;

procedure TRMCrossView.SaveToStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 0);
  RMWriteBoolean(aStream, FInternalFrame);
  RMWriteBoolean(aStream, FRepeatCaptions);
  RMWriteBoolean(aStream, FShowHeader);
  RMWriteInt32(aStream, FDataWidth);
  RMWriteInt32(aStream, FDataHeight);
  RMWriteString(aStream, FHeaderWidth);
  RMWriteString(aStream, FHeaderHeight);
  RMWriteString(aStream, FDictionary.Text);
  RMWriteString(aStream, FRowNoHeader);
  RMWriteMemo(aStream, FAddColumnsHeader);
end;

procedure TRMCrossView.CalcWidths;
var
  i, w, maxw, h, maxh, k: Integer;
  v: TRMView;
  b: TBitmap;
  m: TStringList;
begin
  ParentReport.CurrentPage := ParentPage;

  FFlag := True;
  if FDataWidth <= 0 then
    FColumnWidths := TRMQuickIntArray.Create(FCross.Columns.Count + 1)
  else if (FHeaderWidth = '') or (FHeaderWidth = '0') then
    FColumnWidths := TRMQuickIntArray.Create(FCross.TopLeftSize.cx + 1);

  FColumnHeights := TRMQuickIntArray.Create(FCross.TopLeftSize.cy + 2);
  FLastTotalCol := TRMQuickIntArray.Create(FCross.TopLeftSize.cy + 1);

  if FDataHeight > 0 then
    FMaxCellHeight := FDataHeight
  else
    FMaxCellHeight := 0;
  FMaxGTHeight := 0;

  if not ShowRowTotal then
    FRowDS.RangeEndCount := FRowDS.RangeEndCount - 1;
  if not ShowColumnTotal then
    FColumnDS.RangeEndCount := FColumnDS.RangeEndCount - 1;

  for k := 0 to FCRoss.CellItemsCount - 1 do
  begin
    v := ParentReport.FindObject('CrossMemo@' + IntToStr(k) + Name);
    m := TStringList.Create;
    b := TBitmap.Create;
    THackMemoView(v).Canvas := b.Canvas;

    if (FHeaderWidth = '') or (FHeaderWidth = '0') then
    begin
      FColumnDS.First;
      while FColumnDS.RecordNo < FCross.TopLeftSize.cx do
      begin
        maxw := 0;

        FRowDS.First;
        FRowDS.Next;
        while not FRowDS.EOF do
        begin
          ReportBeforePrint(nil, TRMReportView(v));
          m.Assign(v.Memo);
          if m.Count = 0 then
            m.Add(' ');
          w := THackMemoView(v).CalcWidth(m) + 5;
          if w > maxw then
            maxw := w;
          FRowDS.Next;
        end;
        if FColumnWidths.Cell[FColumnDS.RecordNo] < maxw then
          FColumnWidths.Cell[FColumnDS.RecordNo] := maxw;
        FColumnDS.Next;
      end;
    end;

    if FDataWidth <= 0 then
    begin
      THackUserDataset(FColumnDS).FRecordNo := FCross.TopLeftSize.cx;
      while not FColumnDS.EOF do
      begin
        maxw := 0;

        FRowDS.First;
        FRowDS.Next;
        while not FRowDS.EOF do
        begin
          ReportBeforePrint(nil, TRMReportView(v));
          m.Assign(v.Memo);
          if m.Count = 0 then
            m.Add(' ');
          w := THackMemoView(v).CalcWidth(m) + 5;
          if w > maxw then
            maxw := w;
          FRowDS.Next;
        end;
        if FColumnWidths.Cell[FColumnDS.RecordNo] < maxw then
          FColumnWidths.Cell[FColumnDS.RecordNo] := maxw;
        FColumnDS.Next;
      end;
      FColumnWidths.Cell[FCross.Columns.Count] := 0;
    end;

    FRowDS.First;
    for i := 0 to FCross.TopLeftSize.cy do
    begin
      maxh := 0;

      FColumnDS.First;
      while not FColumnDS.EOF do
      begin
        w := v.spWidth;
        v.spWidth := 1000;
        h := RMToScreenPixels(THackMemoView(v).CalcHeight, rmutMMThousandths);
        v.spWidth := w;
        if h > maxh then
          maxh := h;
        FColumnDS.Next;
      end;

      if (FHeaderHeight <> '') and (FHeaderHeight <> '0') then // WHF Modify
      begin
        FColumnHeights.Cell[i] := GetHeaderHeightByIndex(i);
      end
      else
      begin
        if maxh > v.spHeight then
          FColumnHeights.Cell[i] := maxh
        else
          FColumnHeights.Cell[i] := v.spHeight;
      end;
      FRowDS.Next;
    end;

    FColumnDS.First;
    while not FColumnDS.EOF do
    begin
      w := v.spWidth;
      v.spWidth := 1000;
      h := RMToScreenPixels(THackMemoView(v).CalcHeight, rmutMMThousandths);
      v.spWidth := w;
      if h > FMaxCellHeight then
        FMaxCellHeight := h;
      FColumnDS.Next;
    end;

    if ShowRowTotal or ShowColumnTotal then
    begin
      THackUserDataset(FRowDS).FRecordNo := FRowDS.RangeEndCount - 1;
      FColumnDS.First;
      while not FColumnDS.EOF do
      begin
        w := v.spWidth;
        v.spWidth := 1000;
        h := RMToScreenPixels(THackMemoView(v).CalcHeight, rmutMMThousandths);
        v.spWidth := w;
        if h > FMaxGTHeight then
          FMaxGTHeight := h;
        FColumnDS.Next;
      end;
    end;

    THackMemoView(v).DrawMode := rmdmAll;
    FreeAndNil(m);
    FreeAndNil(b);
  end;

  if FMaxCellHeight < FDefDy then
    FMaxCellHeight := FDefDY;
  if FMaxGTHeight < FDefDy then
    FMaxGTHeight := FDefDY;
  FFlag := False;
  FLastX := 0;
end;

procedure TRMCrossView.MakeBands;
var
  i, d, d1, dx, dh: Integer;
  lBandMasterHeader: TRMBandHeader;
  lBandMasterData: TRMBandMasterData;
  lBandCrossHeader: TRMBandCrossHeader;
  lBandCrossData: TRMBandCrossData;
  v, v1: TRMMemoView;
  lPage: TRMReportPage;
begin
  lPage := ParentPage;

  lBandMasterHeader := TRMBandHeader.Create; // master header
  lBandMasterHeader.ParentPage := lPage;
  lBandMasterHeader.Name := 'CrossHeader1' + Name;
  lBandMasterHeader.CrossDataSetName := 'ColumnDS' + Name;
  lBandMasterHeader.SetspBounds(0, 400, 0, FDefDY);
  lBandMasterHeader.ReprintOnNewPage := FRepeatCaptions;

  lBandMasterData := TRMBandMasterData.Create; // master data
  lBandMasterData.ParentPage := lPage;
  lBandMasterData.Name := 'CrossData1' + Name;
  lBandMasterData.SetspBounds(0, 500, 0, FDefDY);
  lBandMasterData.DataSetName := 'RowDS' + Name;
  lBandMasterData.CrossDataSetName := 'ColumnDS' + Name;
  lBandMasterData.Stretched := True;

  lBandCrossHeader := TRMBandCrossHeader.Create; // cross header
  lBandCrossHeader.ParentPage := lPage;
  lBandCrossHeader.Name := 'CrossHeader2' + Name;
  lBandCrossHeader.SetspBounds(lPage.spMarginLeft, 0, 60, FDefDY);
  lBandCrossHeader.ReprintOnNewPage := True;

  lBandCrossData := TRMBandCrossData.Create; // cross data
  lBandCrossData.ParentPage := lPage;
  lBandCrossData.Name := 'CrossData2' + Name;
  lBandCrossData.SetspBounds(500, 0, 60, FDefDY);

  d := lBandMasterData.spTop;
  dh := lBandMasterData.spHeight;
  for i := 0 to FCross.CellItemsCount - 1 do
  begin
    v := TRMMemoView.Create;
    v.ParentPage := lPage;
    v.Name := 'CrossMemo@' + IntToStr(i) + Name;
    v.SetspBounds(lBandCrossData.spLeft, d, lBandCrossData.spWidth, dh);
    inc(d, dh);
    lBandMasterData.spHeight := lBandMasterData.spHeight + dh;
  end;

  ParentReport.CurrentPage := nil;
  CalcWidths;

  lBandMasterHeader.spHeight := 0;
  d := lBandMasterHeader.spTop;
  for i := 0 to FCross.TopLeftSize.cy - 1 + ord(FShowHeader) do // 交叉表数据栏 + 主项标头栏
  begin
    v := TRMMemoView.Create;
    v.ParentPage := lPage;
    dh := FColumnHeights.Cell[i + Ord(not FShowHeader)];
    v.SetspBounds(lBandCrossData.spLeft, d, lBandCrossData.spWidth, dh);
    v.Name := 'CrossMemo_' + IntToStr(i) + Name;
    lBandMasterHeader.spHeight := lBandMasterHeader.spHeight + dh;
    Inc(d, dh);
  end;

  lBandMasterData.spTop := lBandMasterHeader.spTop + lBandMasterHeader.spHeight + 30;
  lBandMasterData.spHeight := FMaxCellHeight * FCross.CellItemsCount;
  dh := FMaxCellHeight;
  d := lBandMasterData.spTop;
  for i := 0 to FCross.CellItemsCount - 1 do // 交叉表数据栏 + 主项数据栏
  begin
    v := TRMMemoView(ParentReport.FindObject('CrossMemo@' + IntToStr(i) + Name));
    v.ParentPage := lPage;
    v.spTop := d;
    v.spHeight := dh;
    inc(d, dh);
  end;

  lBandCrossHeader.spWidth := 0;
  d := lBandCrossHeader.spLeft;
  for i := 0 to FCross.TopLeftSize.cx - 1 do // 交叉表标头栏 + 主项数据栏
  begin
    v := TRMMemoView.Create;
    v.ParentPage := lPage;
    if (FHeaderWidth = '') or (FHeaderWidth = '0') then
      dx := FColumnWidths.Cell[i]
    else
      dx := GetHeaderWidthByIndex(i);
    v.SetspBounds(d, lBandMasterData.spTop, dx, lBandMasterData.spHeight);
    v.Name := 'CrossMemo' + IntToStr(i) + Name;
    lBandCrossHeader.spWidth := lBandCrossHeader.spWidth + dx;
    Inc(d, dx);
  end;

  if ShowIndicator or FShowHeader then
  begin
    v1 := TRMMemoView(lPage.FindObject('CrossHeaderMemo' + Name));
    if v1 <> nil then
    begin
      d := 0;
      for i := 0 to FCross.TopLeftSize.cy - 1 do
      begin
        d := d + FColumnHeights.Cell[i + Ord(not FShowHeader)];
      end;

      v := TRMMemoView.Create;
      v.ParentPage := lPage;
      v.Name := 'IndicatorMemo0' + Name;
      v.SetspBounds(lBandCrossHeader.spLeft, lBandMasterHeader.spTop, 0, lBandMasterHeader.spHeight);
      v.LeftFrame.Visible := True;
      v.RightFrame.Visible := True;
      v.TopFrame.Visible := True;
      v.BottomFrame.Visible := True;

      v.spHeight := d;
      v.spWidth := 0;
      for i := 0 to FCross.TopLeftSize.cx - 1 do
      begin
        if (FHeaderWidth = '') or (FHeaderWidth = '0') then
          v.spWidth := v.spWidth + FColumnWidths[i]
        else
          v.spWidth := v.spWidth + GetHeaderWidthByIndex(i);
      end;

      THackMemoView(v).FFlags := THackMemoView(v1).FFlags;
      THackMemoView(v).IsChildView := False;
      v.RotationType := TRMMemoView(v1).RotationType;
      v.LeftFrame.Assign(v1.LeftFrame);
      v.RightFrame.Assign(v1.RightFrame);
      v.TopFrame.Assign(v1.TopFrame);
      v.BottomFrame.Assign(v1.BottomFrame);
      v.FillColor := v1.FillColor;
      THackMemoView(v).FDisplayFormat := THackMemoView(v1).FDisplayFormat;
      THackMemoView(v).FormatFlag := THackMemoView(v1).FormatFlag;
      v.spGapLeft := TRMMemoView(v1).spGapLeft;
      v.spGapTop := TRMMemoView(v1).spGapTop;
      v.Highlight.Assign(TRMMemoView(v1).Highlight);
      v.LineSpacing := TRMMemoView(v1).LineSpacing;
      v.CharacterSpacing := TRMMemoView(v1).CharacterSpacing;
      v.Font.Assign(TRMMemoView(v1).Font);
      v.Memo.Assign(v1.Memo);
      v.HAlign := TRMMemoView(v1).HAlign;
      v.VAlign := TRMMemoView(v1).VAlign;
    end;
  end;

  if FShowHeader then
  begin
    d := lBandMasterHeader.spTop;
    for i := 0 to FCross.TopLeftSize.cy - 1 do
      d := d + FColumnHeights.Cell[i];

    d1 := lBandCrossHeader.spLeft;
    dh := FColumnHeights.Cell[FCross.TopLeftSize.cy];
    for i := 0 to FCross.TopLeftSize.cx - 1 do
    begin
      v := TRMMemoView.Create;
      v.ParentPage := lPage;
      if (FHeaderWidth = '') or (FHeaderWidth = '0') then
        dx := FColumnWidths.Cell[i]
      else
        dx := GetHeaderWidthByIndex(i);
      v.SetspBounds(d1, d, dx, dh);
      v.Name := 'CrossMemo~' + IntToStr(FCross.TopLeftSize.cy) + '~' + IntToStr(i) + Name;
      Inc(d1, dx);
    end;
  end;
end;

procedure TRMCrossView.ReportPrintColumn(ColNo: Integer; var Width: Integer);
var
  i: Integer;
  lCurView: TRMView;
begin
  lCurView := ParentReport.CurrentView;
  if not FSkip and (Pos(Name, lCurView.Name) <> 0) then
  begin
    if FDataWidth <= 0 then
      Width := FColumnWidths.Cell[ColNo - 1 + FCross.TopLeftSize.cx]
    else
      Width := FDataWidth;

    for i := 0 to FCRoss.CellItemsCount - 1 do
      ParentReport.FindObject('CrossMemo@' + IntToStr(i) + Name).spWidth := Width;

    if FRowDS.RecordNo < FCross.TopLeftSize.cy then
    begin
      for i := 0 to FCross.TopLeftSize.cy - 1 do
        ParentReport.FindObject('CrossMemo_' + IntToStr(i) + Name).spWidth := Width;
    end;
  end;

  if Assigned(FSavedOnPrintColumn) then
    FSavedOnPrintColumn(ColNo, Width);
end;

function _GetString(S: string; N: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    if S[i] = ';' then
      Dec(N)
    else if N = 1 then
      Result := Result + s[i]
    else if N = 0 then
      break;
  end;
end;

function _GetPureString(S: string; N: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    if S[i] = ';' then
      Dec(N)
    else if N = 1 then
      Result := Result + s[i]
    else if N = 0 then
      break;
  end;
  Result := PureName1(Result);
end;

procedure TRMCrossView.ReportBeforePrint(aMemo: TStrings; aView: TRMReportView);
var
  v: Variant;
  s, s1: string;
  i, j, row, col, ColCount: Integer;
  hd: Boolean;
  lHAlign: TRMHAlign;
  lVAlign: TRMVAlign;
  v1: TRMMemoView;
  ft: Word;
  lCurPage: THackReportPage;
  lCurBand: TRMBand;

  procedure Assign(m1, m2: TRMMemoView);
  begin
    m1.RotationType := m2.RotationType;
    m1.FillColor := m2.FillColor;
    THackMemoView(m1).FDisplayFormat := THackMemoView(m2).FDisplayFormat;
    THackMemoView(m1).FormatFlag := THackMemoView(m2).FormatFlag;
    m1.spGapLeft := m2.spGapLeft;
    m1.spGapTop := m2.spGapTop;
    m1.Highlight.Assign(m2.Highlight);
    m1.LineSpacing := m2.LineSpacing;
    m1.CharacterSpacing := m2.CharacterSpacing;
    m1.Font := m2.Font;
    m1.HAlign := TRMMemoView(m2).HAlign;
    m1.VAlign := TRMMemoView(m2).VAlign;
  end;

begin
  lCurPage := THackReportPage(ParentReport.CurrentPage);
  lCurBand := ParentReport.CurrentBand;

  if (not FSkip) and (Pos('CrossMemo', aView.Name) = 1) and (Pos(Name, aView.Name) <> 0) then
  begin
    i := 0;
    row := FRowDS.RecordNo;
    col := FColumnDS.RecordNo;
    if not FFlag then
    begin
      while FRowDS.RecordNo <= FCross.TopLeftSize.cy do
        FRowDS.Next;
      while FColumnDS.RecordNo < FCross.TopLeftSize.cx do
        FColumnDS.Next;
      row := FRowDS.RecordNo;
      col := FColumnDS.RecordNo;
      if aView.Name <> 'CrossMemo@0' + Name then
      begin
        s := Copy(aView.Name, 1, Pos(Name, aView.Name) - 1);
        if s[10] in ['_', '@', '~'] then
        begin
          if s[10] = '@' then
            i := StrToInt(Copy(s, 11, 255))
          else if s[10] = '~' then
          begin
            Delete(s, 1, 10);
            row := StrToInt(Copy(s, 1, Pos('~', s) - 1));
            Delete(s, 1, Pos('~', s));
            col := StrToInt(s);
          end
          else
          begin
            row := StrToInt(Copy(s, 11, 255));
            if not FShowHeader then
              Inc(row);
          end;
        end
        else
          col := StrToInt(Copy(s, 10, 255));
      end;
    end
    else if aView.Name <> 'CrossMemo' + Name then
    begin
      s := Copy(aView.Name, 1, Pos(Name, aView.Name) - 1);
      if s[10] = '@' then
        i := StrToInt(Copy(s, 11, 255));
    end;

    if not FShowHeader and (Row = 0) then
      Inc(Row);
    if not FFlag then
    begin
      if row <= FCross.TopLeftSize.cy then
        aView.spHeight := FColumnHeights.Cell[Row];
      aView.Visible := True;
      if Col < FCross.TopLeftSize.cx then
      begin
        if (FHeaderWidth = '') or (FHeaderWidth = '0') then
          aView.spWidth := FColumnWidths.Cell[Col]
        else
          aView.spWidth := GetHeaderWidthByIndex(Col);
      end
      else if FDataWidth <= 0 then
        aView.spWidth := FColumnWidths.Cell[Col]
      else
        aView.spWidth := FDataWidth;
    end;

    Assign(TRMMemoView(aView), TRMMemoView(ParentReport.FindObject('CellMemo' + Name)));
    lHAlign := TRMMemoView(aView).HAlign;
    lVAlign := TRMMemoView(aView).VAlign;
    if FInternalFrame then
    begin
      aView.LeftFrame.Visible := True;
      aView.TopFrame.Visible := True;
      aView.RightFrame.Visible := True;
      aView.BottomFrame.Visible := True;
    end
    else
    begin
      aView.LeftFrame.Visible := True;
      aView.RightFrame.Visible := True;
      aView.TopFrame.Visible := False;
      aView.BottomFrame.Visible := False;
    end;

    if (row = FCross.TopLeftSize.cy + 1) and (col >= FCross.TopLeftSize.cx) then
    begin
      if (not aView.TopFrame.Visible) and (not aView.BottomFrame.Visible) and
        (aView.LeftFrame.Visible or aView.RightFrame.Visible) then
        aView.TopFrame.Visible := True;
    end;

    v := FCross.CellByIndex[row, col, -1];
    if v <> Null then
    begin
      aView.LeftFrame.Visible := (v and rmftLeft) = rmftLeft;
      aView.RightFrame.Visible := (v and rmftRight) = rmftRight;
      aView.TopFrame.Visible := (v and rmftTop) = rmftTop;
      aView.BottomFrame.Visible := (v and rmftBottom) = rmftBottom;
    end;

    if row = FCross.Rows.Count - 2 then
      aView.BottomFrame.Visible := True;

    if not ShowColumnTotal and (FAddColumnsHeader.Count > 0) and (Col >= FCross.Columns.Count - 1 - FAddColumnsHeader.Count) then
      v := FCross.CellByIndex[row, col + 1, 0]
    else
      v := FCross.CellByIndex[row, col, 0];
    if v = Null then
      s := ''
    else
      s := v;

    hd := False;
    if row <= FCross.TopLeftSize.cy then // header
    begin
      Assign(TRMMemoView(aView), TRMMemoView(ParentReport.FindObject('ColumnHeaderMemo' + Name)));
      if lCurPage.Flag_ColumnNewPage and (Pos('CrossMemo_', aView.Name) = 1) then
        aView.LeftFrame.Visible := True;
      hd := True;
      if not FFlag then
      begin
        if col >= FCross.TopLeftSize.cx then
        begin
          if row > 0 then
          begin
            aView.Visible := (v <> Null) or (col - FLastTotalCol.Cell[row - 1] = 1);
            if (aView.Visible and (col < FCross.Columns.Count - 1)) and
              (FCross.CellByIndex[row, col + 1, 0] = Null) then
            begin
              for i := Col + 1 to FCross.Columns.Count - 1 do
              begin
                ft := FCross.CellByIndex[row, i, -1];
                if FDataWidth <= 0 then
                  j := aView.spWidth + FColumnWidths.Cell[i]
                else
                  j := aView.spWidth + FDataWidth;

                if not ((ft <> rmftTop) and (ft and rmftLeft <> 0)) then
                begin
                  if aView.spLeft + j <= lCurPage.PrinterInfo.PageWidth - lCurPage.spMarginRight then
                    aView.spWidth := j
                  else
                  begin
                    FLastTotalCol.Cell[row - 1] := i - 1;
                    Break;
                  end;
                end
                else
                  Break;
              end;
            end;
          end
          else
          begin
            aView.Visible := (v <> Null) or (col - FLastX = 1);
            aView.TopFrame.Visible := True;
            aView.BottomFrame.Visible := True;
            aView.RightFrame.Visible := True;

            if TRMMemoView(aView).HAlign = rmHCenter then
              TRMMemoView(aView).HAlign := rmHLeft;
            if aView.Visible and (col < FCross.Columns.Count - 1) then
            begin
              ColCount := FCross.Columns.Count - 1;
              if not ShowColumnTotal then
                Dec(ColCount);
              for i := Col + 1 to ColCount do
              begin
                if FDataWidth <= 0 then
                  j := aView.spWidth + FColumnWidths.Cell[i]
                else
                  j := aView.spWidth + FDataWidth;
                if aView.spLeft + j <= lCurPage.PrinterInfo.PageWidth - lCurPage.spMarginRight then
                  aView.spWidth := j
                else
                begin
                  FLastX := i - 1;
                  Break;
                end;
              end;
            end;
          end;
        end
        else
        begin // Row Header
          if row = FCross.TopLeftSize.cy then
          begin
            aView.LeftFrame.Visible := True;
            aView.TopFrame.Visible := True;
            aView.RightFrame.Visible := True;
            aView.BottomFrame.Visible := True;
          end
          else
          begin
            v := '';
            if col = FCross.TopLeftSize.cx - 1 then
            begin
              aView.LeftFrame.Visible := False;
              aView.TopFrame.Visible := False;
              aView.RightFrame.Visible := True;
              aView.BottomFrame.Visible := False;
            end
            else
            begin
              aView.LeftFrame.Visible := False;
              aView.TopFrame.Visible := False;
              aView.RightFrame.Visible := False;
              aView.BottomFrame.Visible := False;
            end;
            if (Col = 0) then
              aView.LeftFrame.Visible := True;
            if row = 0 then
            begin
              aView.TopFrame.Visible := True;
              if not FCross.DoDataCol then
                aView.BottomFrame.Visible := True;
              if (col = 0) then
              begin
                if not FCross.DoDataCol then
                begin
                  for j := 1 to FCross.CellItemsCount do
                    v := v + '';
                end;
              end;
            end;
          end;
        end;
      end;

      if (col < FCross.TopLeftSize.cx) and (row = FCross.TopLeftSize.cy) then
      begin
        if ShowRowNo then // 显示序号
        begin
          if Col = 0 then
            v := RowNoHeader
          else
          begin
            if (col = FCross.TopLeftSize.cx - 1 - 1) and FCross.DoDataCol then
              v := RMLoadStr(rmRes + 760)
            else
              v := GetDictName(_GetPureString(Self.Memo.Strings[1], Col + 1 - 1));
          end;
        end
        else
        begin
          if (col = FCross.TopLeftSize.cx - 1) and FCross.DoDataCol then
            v := RMLoadStr(rmRes + 760)
          else
            v := GetDictName(_GetPureString(Self.Memo.Strings[1], Col + 1));
        end;
      end;
    end
    else if (col < FCross.TopLeftSize.cx) and (row > FCross.TopLeftSize.cy) then // row header
    begin
      Assign(TRMMemoView(aView), TRMMemoView(ParentReport.FindObject('RowHeaderMemo' + Name)));
      if FFlag and (col = FCross.TopLeftSize.cx - 1) and FCross.DoDataCol then
        v := FMaxString;
      hd := True;
    end;

    if (Col >= FCross.Columns.Count - 1 - FAddColumnsHeader.Count) and
      (Col <= FCross.Columns.Count - 1) and (row > 0) then // grand total column
    begin
      if ShowColumnTotal and (Col = FCross.Columns.Count - 1 - FAddColumnsHeader.Count) then
        Assign(TRMMemoView(aView), TRMMemoView(ParentReport.FindObject('GrandColumnTotalMemo' + Name)))
      else if row = FCross.Rows.Count - 1 then
        Assign(TRMMemoView(aView), TRMMemoView(ParentReport.FindObject('GrandRowTotalMemo' + Name)));
      if (not FFlag) and (row <= FCross.TopLeftSize.cy) then
      begin
        if (FLastTotalCol.Cell[row - 1] < col) or (not ShowColumnTotal) then
        begin
          for j := row - 1 to FCross.TopLeftSize.cy do
            FLastTotalCol.Cell[j] := Col;
          aView.spHeight := 0;
          for j := row to FCross.TopLeftSize.cy do
            aView.spHeight := aView.spHeight + FColumnHeights.Cell[j];
        end
        else
          aView.Visible := False;
      end;
    end
    else if row = FCross.Rows.Count - 1 then // grand total row
    begin
      Assign(TRMMemoView(aView), TRMMemoView(ParentReport.FindObject('GrandRowTotalMemo' + Name)));
      if not FFlag then
      begin
        lCurBand.spHeight := FMaxGTHeight * FCross.CellItemsCount;
        if (Col = FCross.TopLeftSize.cx) and (aView.spHeight = FMaxCellHeight) then
        begin
          aView.spTop := aView.spTop - i * (FMaxCellHeight - FMaxGTHeight);
          aView.spHeight := FMaxGTHeight;
        end
        else if Col < FCross.TopLeftSize.cx then
          aView.spHeight := lCurBand.spHeight
        else
          aView.spHeight := FMaxGTHeight;
      end;
    end
    else if FCross.IsTotalColumn[col] and (row > 0) then // "total" column
    begin
      if aView.LeftFrame.Visible then
      begin
        Assign(TRMMemoView(aView), TRMMemoView(ParentReport.FindObject('ColumnTotalMemo' + Name)));
        if (not FFlag) and (row <= FCross.TopLeftSize.cy) then
        begin
          if (FLastTotalCol.Cell[row - 1] < col) or lCurPage.Flag_NewPage then
          begin
            for j := row - 1 to FCross.TopLeftSize.cy do
              FLastTotalCol.Cell[j] := Col;
            aView.spHeight := 0;
            for j := row to FCross.TopLeftSize.cy do
              aView.spHeight := aView.spHeight + FColumnHeights.Cell[j];
          end
          else
            aView.Visible := False;
        end;
      end;
    end
    else if FCross.IsTotalRow[Row] then // "total" row
    begin
      if (col >= FCross.TopLeftSize.cx) or aView.TopFrame.Visible then
      begin
        Assign(TRMMemoView(aView), TRMMemoView(ParentReport.FindObject('RowTotalMemo' + Name)));
      end;
    end;

    if not hd then
    begin
      TRMMemoView(aView).HAlign := lHAlign;
      TRMMemoView(aView).VAlign := lVAlign;
      v1 := TRMMemoView(ParentReport.FindObject('CellMemo' + Name));
      THackMemoView(aView).FDisplayFormat := THackMemoView(v1).FDisplayFormat;
      THackMemoView(aView).FormatFlag := THackMemoView(v1).FormatFlag;
    end;

    if (col >= FCross.TopLeftSize.cx) and (row > FCross.TopLeftSize.cy) then // cross body
    begin
      s := '';
      if not ShowColumnTotal and (FAddColumnsHeader.Count > 0) and (Col >= FCross.Columns.Count - 1 - FAddColumnsHeader.Count) then
        v := FCross.CellByIndex[row, col + 1, i]
      else
        v := FCross.CellByIndex[row, col, i];
      RMVariables['RMCrossVariable'] := v;
      ParentReport.CurrentView := aView;
      THackReport(ParentReport).InternalOnGetValue(aView, 'RMCrossVariable', s1, False);
      s := s1;
      if i < FCross.CellItemsCount - 1 then
        aView.BottomFrame.Visible := not aView.BottomFrame.Visible;
      if i > 0 then
        aView.TopFrame.Visible := not aView.TopFrame.Visible;
    end
    else
    begin
      if v = Null then
        s := ''
      else
      begin
        RMVariables['RMCrossVariable'] := v;
        ParentReport.CurrentView := aView;
        THackReport(ParentReport).InternalOnGetValue(aView, 'RMCrossVariable', s, False);
      end;
    end;

    if Pos('CrossMemo', aView.Name) = 1 then
    begin
      s1 := Copy(aView.Name, 1, Pos(Name, aView.Name) - 1);
      if not (s1[10] in ['_', '@', '~']) then
      begin
        if lCurPage.Flag_NewPage then
          aView.TopFrame.Visible := True
        else if lCurPage.mmCurrentY + TRMReportView(lCurPage.FindObject('CrossData1' + Name)).mmHeight * 2 > lCurPage.mmCurrentBottomY then
          aView.BottomFrame.Visible := True;

        if MergeRowHeader then // 合并Row Header
        begin
          if aView.Visible then
          begin
            TRMMemoView(aView).RepeatedOptions.SuppressRepeated := True;
            TRMMemoView(aView).RepeatedOptions.MergeRepeated := True;
            THackMemoView(aView).FMergeEmpty := True;
            aView.TopFrame.Visible := True;
          end;
          if s <> '' then // 初始化
          begin
            hd := False;
            for i := 0 to FCross.TopLeftSize.cx - 1 do
            begin
              if aView.Name = 'CrossMemo' + IntToStr(i) + Name then
              begin
                hd := True;
                Break;
              end;
            end;
            if hd then
            begin
              for i := 0 to FCross.TopLeftSize.cx - 1 do
                THackMemoView(ParentReport.FindObject('CrossMemo' + IntToStr(i) + Name)).LastValue := '';
            end;
          end; // end if s <> ''
        end; // end if MergeRowHeader
      end;
    end;

    TRMMemoView(aView).AutoWidth := False;
    TRMMemoView(aView).WordWrap := True;
    aView.Memo.Text := s;
  end;

  if Assigned(FSavedOnBeforePrint) then
    FSavedOnBeforePrint(Memo, aView);
end;

type
  THackRMDataset = class(TRMDataset);

procedure TRMCrossView.OnColumnDSFirst(Sender: TObject);
begin
  while FColumnDS.RecordNo < FCross.TopLeftSize.cx do
    FColumnDS.Next;
  while FRowDS.RecordNo <= FCross.TopLeftSize.cy do
    FRowDS.Next;
end;

function TRMCrossView.GetShowRowTotal: Boolean;
begin
  Result := (FFlags and flCrossShowRowTotal) <> 0;
end;

procedure TRMCrossView.SetShowRowTotal(Value: Boolean);
begin
  FFlags := (FFlags and not flCrossShowRowTotal);
  if value then
    FFlags := FFlags + flCrossShowRowTotal;
end;

function TRMCrossView.GetShowColTotal: Boolean;
begin
  Result := (FFlags and flCrossShowColTotal) <> 0;
end;

procedure TRMCrossView.SetShowColTotal(Value: Boolean);
begin
  FFlags := (FFlags and not flCrossShowColTotal);
  if value then
    FFlags := FFlags + flCrossShowColTotal;
end;

function TRMCrossView.GetShowIndicator: Boolean;
begin
  Result := (FFlags and flCrossShowIndicator) <> 0;
end;

procedure TRMCrossView.SetShowIndicator(Value: Boolean);
begin
  FFlags := (FFlags and not flCrossShowIndicator);
  if Value then
    FFlags := FFlags + flCrossShowIndicator;
end;

function TRMCrossView.GetSortColHeader: Boolean;
begin
  Result := (FFlags and flCrossSortColHeader) <> 0;
end;

procedure TRMCrossView.SetSortColHeader(Value: Boolean);
begin
  FFlags := (FFlags and not flCrossSortColHeader);
  if Value then
    FFlags := FFlags + flCrossSortColHeader;
end;

function TRMCrossView.GetSortRowHeader: Boolean;
begin
  Result := (FFlags and flCrossSortRowHeader) <> 0;
end;

procedure TRMCrossView.SetSortRowHeader(Value: Boolean);
begin
  FFlags := (FFlags and not flCrossSortRowHeader);
  if Value then
    FFlags := FFlags + flCrossSortRowHeader;
end;

function TRMCrossView.GetMergeRowHeader: Boolean;
begin
  Result := (FFlags and flCrossMergeRowHeader) <> 0;
end;

procedure TRMCrossView.SetMergeRowHeader(Value: Boolean);
begin
  FFlags := FFlags and not flCrossMergeRowHeader;
  if Value then
    FFlags := FFlags + flCrossMergeRowHeader;
end;

function TRMCrossView.GetShowRowNo: Boolean;
begin
  Result := (FFlags and flCrossShowRowNo) <> 0;
end;

procedure TRMCrossView.SetShowRowNo(Value: Boolean);
begin
  FFlags := FFlags and not flCrossShowRowNo;
  if Value then
    FFlags := FFlags + flCrossShowRowNo;
end;

function TRMCrossView.GetInternalFrame: Boolean;
begin
  Result := FInternalFrame;
end;

procedure TRMCrossView.SetInternalFrame(Value: Boolean);
begin
  FInternalFrame := Value;
end;

function TRMCrossView.GetRepeatCaptions: Boolean;
begin
  Result := FRepeatCaptions;
end;

procedure TRMCrossView.SetRepeatCaptions(Value: Boolean);
begin
  FRepeatCaptions := Value;
end;

function TRMCrossView.GetDataWidth: Integer;
begin
  Result := FDataWidth;
end;

procedure TRMCrossView.SetDataWidth(Value: Integer);
begin
  FDataWidth := Value;
end;

function TRMCrossView.GetDataHeight: Integer;
begin
  Result := FDataHeight;
end;

procedure TRMCrossView.SetDataHeight(Value: Integer);
begin
  FDataHeight := Value;
end;

function TRMCrossView.GetHeaderWidth: string;
begin
  Result := FHeaderWidth;
end;

procedure TRMCrossView.SetHeaderWidth(Value: string);
begin
  FHeaderWidth := Value;
end;

function TRMCrossView.GetHeaderHeight: string;
begin
  Result := FHeaderHeight;
end;

procedure TRMCrossView.SetHeaderHeight(Value: string);
begin
  FHeaderHeight := Value;
end;

function TRMCrossView.GetRowNoHeader: string;
begin
  Result := FRowNoHeader;
end;

procedure TRMCrossView.SetRowNoHeader(Value: string);
begin
  FRowNoHeader := Value;
end;

function TRMCrossView.GetDictName(s: string): string;
begin
  Result := s;
  if FDictionary.Values[s] <> EmptyStr then
    Result := FDictionary.Values[s];
end;

function TRMCrossView.GetDataCellText: string;
var
  lList: TStringList;
  i: Integer;
  ss: string;

  function _GoodString: string;
  var
    lList: TStringList;
    i: Integer;
    s, ss: string;
  begin
    s := Memo[3];
    lList := TStringList.Create;
    for i := 0 to CharCount(';', s) - 1 do
    begin
      ss := Copy(s, 1, Pos(';', s) - 1);
      Delete(s, 1, Pos(';', s));
      lList.Add(ss);
    end;

    Result := lList.Text;
    FreeAndNil(lList);
  end;

begin
  lList := TStringList.Create;
  lList.Text := _GoodString;
  FMaxString := '';
  for i := 0 to lList.Count - 1 do
  begin
    ss := lList[i];
    ss := GetDictName(ss);
    if Length(ss) > Length(FMaxString) then
      FMaxString := ss;
    lList[i] := ss;
  end;

  Result := lList.Text;
  lList.Free;
end;

function TRMCrossView.GetHeaderHeightByIndex(aIndex: Integer): Integer;
var
  lPos: Integer;
  lStr: string;
begin
  lstr := FHeaderHeight;
  lPos := Pos(';', lstr);
  while (aIndex > 0) and (lPos > 0) do
  begin
    Dec(aIndex);
    Delete(lstr, 1, lPos);
    lPos := Pos(';', lstr);
  end;

  if (aIndex > 0) or (lstr = '') then
    lstr := FHeaderHeight;
  lPos := Pos(';', lstr);
  if lPos > 0 then
    lstr := Copy(lstr, 1, lPos - 1);
  Result := StrToInt(lstr);
end;

function TRMCrossView.GetHeaderWidthByIndex(aIndex: Integer): Integer;
var
  lPos: Integer;
  lStr: string;
begin
  if not ShowRowNo then Inc(aIndex);
  lstr := FHeaderWidth;
  lPos := Pos(';', lstr);
  while (aIndex > 0) and (lPos > 0) do
  begin
    Dec(aIndex);
    Delete(lstr, 1, lPos);
    lPos := Pos(';', lstr);
  end;

  if (aIndex > 0) or (lstr = '') then
    lstr := FHeaderWidth;
  lPos := Pos(';', lstr);
  if lPos > 0 then
    lstr := Copy(lstr, 1, lPos - 1);
  Result := StrToInt(lstr);
end;

procedure TRMCrossView.Prepare;
var
  i: Integer;
  v: TRMView;
  lRMDBDataSet: TRMDBDataSet;
  lDataSet: TDataSet;
begin
	if THackReport(ParentReport).IsSecondTime then Exit;

  Visible := False;
  FSkip := False;
  if (Memo.Count < 4) or (Trim(Memo[0]) = '') or (Trim(Memo[1]) = '') or
    (Trim(Memo[2]) = '') or (Trim(Memo[3]) = '') then
  begin
    FSkip := True;
    Exit;
  end;

  if ParentReport.FindObject('ColumnHeaderMemo' + Name) = nil then
    CreateObjects;

  lDataSet := nil;
  lRMDBDataSet := TRMDBDataSet(RMFindComponent(ParentReport.Owner, ParentReport.Dictionary.RealDatasetName[Memo[0]]));
  if lRMDBDataSet <> nil then lDataSet := lRMDBDataSet.DataSet;
  FCross := TRMCross.Create(ParentReport, lDataSet, Memo[1], Memo[2], Memo[3]);
  FCross.SortColHeader := SortColHeader;
  FCross.SortRowHeader := SortRowHeader;

  if FCross.FDataSet = nil then
  begin
    FCross.Free;
    FSkip := True;
    Exit;
  end;

  v := ParentReport.FindObject('ColumnTotalMemo' + Name);
  if (v <> nil) and (v.Memo.Count > 0) then
    FCross.ColumnTotalString := v.Memo[0];

  if ShowColumnTotal then
  begin
    v := ParentReport.FindObject('GrandColumnTotalMemo' + Name);
    if (v <> nil) and (v.Memo.Count > 0) then
      FCross.ColumnGrandTotalString := v.Memo[0];
  end;

  v := ParentReport.FindObject('RowTotalMemo' + Name);
  if (v <> nil) and (v.Memo.Count > 0) then
    FCross.RowTotalString := v.Memo[0];

  if ShowRowTotal then
  begin
    v := ParentReport.FindObject('GrandRowTotalMemo' + Name);
    if (v <> nil) and (v.Memo.Count > 0) then
      FCross.RowGrandTotalString := v.Memo[0];
  end;

  FCross.HeaderString := ' ';
  for i := 1 to CharCount(';', Memo.Strings[2]) do
  begin
    if i > 1 then
      FCross.HeaderString := FCross.HeaderString + '    ';
    FCross.HeaderString := FCross.HeaderString + GetDictName(_GetPureString(Memo.Strings[2], i));
  end;

  FCross.DoDataCol := (CharCount(';', Memo[3]) > 1) and FShowHeader;
  FCross.DataStr := GetDataCellText;
  FCross.ShowRowNo := ShowRowNo;
  FCross.FAddColumnsHeader.Assign(FAddColumnsHeader);

  FCross.Build;
  if FCross.Columns.Count = 0 then
  begin
    FCross.Free;
    FSkip := True;
    Exit;
  end;

  FRowDS := TRMUserDataset.Create(ParentReport.Owner);
  FRowDS.Name := 'RowDS' + Name;
  FRowDS.RangeEnd := rmreCount;
  FRowDS.RangeEndCount := FCross.Rows.Count;

  FColumnDS := TRMUserDataset.Create(ParentReport.Owner);
  FColumnDS.Name := 'ColumnDS' + Name;
  FColumnDS.RangeEnd := rmreCount;
  FColumnDS.RangeEndCount := FCross.Columns.Count;
  THackRMDataset(FColumnDS).FOnAfterFirst := OnColumnDSFirst;

  MakeBands;

//  ParentReport.SaveToFile('e:\ls');
	inherited;
end;

procedure TRMCrossView.UnPrepare;
begin
  if not FSkip then
  begin
    FreeAndNil(FCross);
    FreeAndNil(FRowDS);
    FreeAndNil(FColumnDS);
    FreeAndNil(FColumnWidths);
    FreeAndNil(FColumnHeights);
    FreeAndNil(FLastTotalCol);
  end;

	inherited;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMCrossForm}

procedure TRMCrossForm.FillDatasetsLB;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  DatasetsLB.Items.BeginUpdate;
  RMDesigner.Report.Dictionary.GetDataSets(DatasetsLB.Items);
  DatasetsLB.Items.EndUpdate;
  sl.Free;
end;

procedure TRMCrossForm.DatasetsLBClick(Sender: TObject);
var
  i: Integer;
  sl: TStringList;
begin
  if Integer(DatasetsLB.Items.Objects[DatasetsLB.ItemIndex]) = 1 then
  begin
    sl := TStringList.Create;
    RMDesigner.Report.Dictionary.GetVariablesList(DatasetsLB.Items[DatasetsLB.ItemIndex], sl);
    FieldsLB.Items.Clear;
    for i := 0 to sl.Count - 1 do
      FieldsLB.Items.AddObject(sl[i], TObject(1));
    sl.Free;
  end
  else
    RMDesigner.Report.Dictionary.GetDataSetFields(DatasetsLB.Items[DatasetsLB.ItemIndex],
      FieldsLB.Items)
end;

procedure TRMCrossForm.ListBox3Enter(Sender: TObject);
begin
  FListBox := TListBox(Sender);
end;

procedure TRMCrossForm.ClearSelection(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to GroupBox1.ControlCount - 1 do
  begin
    if (GroupBox1.Controls[i] <> Sender) and (GroupBox1.Controls[i] is TListBox) then
      (GroupBox1.Controls[i] as TListBox).ItemIndex := -1;
  end;
  CheckBox1.Enabled := Sender <> ListBox4;
  ComboBox2.Enabled := Sender = ListBox4;
end;

procedure TRMCrossForm.ListBox3Click(Sender: TObject);
var
  s: string;
begin
  if (FListBox <> nil) and (FListBox.ItemIndex <> -1) then
  begin
    s := FListBox.Items[FListBox.ItemIndex];
    FBusy := True;
    CheckBox1.Checked := Pos('+', s) <> 0;
    FBusy := False;
  end;
  ClearSelection(Sender);
end;

procedure TRMCrossForm.CheckBox1Click(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  if FBusy then
    Exit;
  if (FListBox <> nil) and (FListBox.ItemIndex <> -1) then
  begin
    i := FListBox.ItemIndex;
    s := FListBox.Items[i];
    if Pos('+', s) <> 0 then
      s := Copy(s, 1, Length(s) - 1)
    else
      s := s + '+';
    FListBox.Items[i] := s;
    FListBox.ItemIndex := i;
  end;
  TDrawPanel(DrawPanel).Paint;
end;

procedure TRMCrossForm.ListBox4Click(Sender: TObject);
var
  s: string;
begin
  FBusy := True;
  if ListBox4.ItemIndex <> -1 then
  begin
    ComboBox2.Enabled := True;
    s := ListBox4.Items[ListBox4.ItemIndex];
    if Pos('+', s) = 0 then
      ComboBox2.ItemIndex := 0
    else
    begin
      s := AnsiLowerCase(Copy(s, Pos('+', s) + 1, 255));
      if (s = '') or (s = 'sum') then
        ComboBox2.ItemIndex := 1
      else if s = 'min' then
        ComboBox2.ItemIndex := 2
      else if s = 'max' then
        ComboBox2.ItemIndex := 3
      else if s = 'avg' then
        ComboBox2.ItemIndex := 4
      else if s = 'count' then
        ComboBox2.ItemIndex := 5
    end;
  end;
  FBusy := False;
  ClearSelection(Sender);
end;

procedure TRMCrossForm.ComboBox2Click(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  if FBusy then
    Exit;
  if ListBox4.ItemIndex <> -1 then
  begin
    i := ListBox4.ItemIndex;
    s := PureName1(ListBox4.Items[i]);
    case ComboBox2.ItemIndex of
      0: ;
      1: s := s + '+';
      2: s := s + '+min';
      3: s := s + '+max';
      4: s := s + '+avg';
      5: s := s + '+count';
    end;
    ListBox4.Items[i] := s;
    ListBox4.ItemIndex := i;
  end;
end;

procedure TRMCrossForm.ListBox3DblClick(Sender: TObject);
begin
  CheckBox1.Checked := not CheckBox1.Checked;
end;

procedure TRMCrossForm.ListBox4DrawItem(Control: TWinControl;
  Index: Integer; ARect: TRect; State: TOwnerDrawState);
var
  s: string;
begin
  with TListBox(Control).Canvas do
  begin
    s := TListBox(Control).Items[Index];
    FillRect(ARect);
    if Pos('+', s) <> 0 then
    begin
      TextOut(ARect.Left + 1, ARect.Top, Copy(s, 1, Pos('+', s) - 1));
      s := Copy(s, Pos('+', s) + 1, 255);
      if s = '' then
      begin
        if Control = ListBox4 then
          s := 'sum'
        else
          s := 'total';
      end;
      TextOut(ARect.Right - TextWidth(s) - 2, ARect.Top, s);
    end
    else
      TextOut(ARect.Left + 1, ARect.Top, s);
  end;
end;

procedure TRMCrossForm.FieldsLBDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := TListBox(Source).Items.Count > 0;
end;

function GetLBIndex(LB: TListBox; s: string): Integer;
var i: Integer;
begin
  Result := -1;
  for i := 0 to LB.Items.Count - 1 do
  begin
    if PureName1(Lb.Items[i]) = s then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

procedure TRMCrossForm.FieldsLBDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  s: string;
  i: Integer;
  L4Exist: Boolean;
begin
  if (Source = Sender) and (Source <> FieldsLB) then
  begin
    i := TListBox(Source).ItemAtPos(Point(x, y), True);
    if i = -1 then
      i := TListBox(Source).Items.Count - 1;
    TListBox(Source).Items.Exchange(TListBox(Source).ItemIndex, i);
  end
  else if Source <> Sender then
  begin
    if TListBox(Source).ItemIndex = -1 then
      Exit;
    s := PureName1(TListBox(Source).Items[TListBox(Source).ItemIndex]);
    L4Exist := GetLBIndex(ListBox4, s) >= 0;
    if Source = FieldsLB then
      s := s + '+';
    if (not ((Source = ListBox4) and (Sender = FieldsLB))) and
      (not ((Source = FieldsLB) and (Sender <> ListBox4) and L4Exist)) then
      TListBox(Sender).Items.Add(s);
    i := GetLBIndex(FieldsLB, PureName1(s));
    if (Source = ListBox4) and (Sender <> FieldsLB) and (i <> -1) then
    begin
      FieldsLB.Items.Delete(i);
      repeat
        i := GetLBIndex(ListBox4, PureName1(s));
        if i <> -1 then
          ListBox4.Items.Delete(i);
      until i = -1;
    end;
    if (Source <> FieldsLB) and (Sender = ListBox4) then
      FieldsLB.Items.Add(s);
    if (not ((Source = FieldsLB) and (Sender = ListBox4))) and (not ((Source = FieldsLB) and L4Exist)) then
    begin
      i := TListBox(Source).ItemIndex;
      if (i <> -1) and (Pos(PureName1(s), TListBox(Source).Items[i]) = 1) then
        TListBox(Source).Items.Delete(i);
    end;
  end;
  TDrawPanel(DrawPanel).Paint;
end;

procedure TRMCrossForm.FormShow(Sender: TObject);
var
  i: Integer;
  sl: TStringList;
  s: string;
begin
  sl := TStringList.Create;
  FillDatasetsLB;
  if DatasetsLB.Items.Count = 0 then
    Exit;

  if Cross.Memo.Count >= 4 then
  begin
    i := DatasetsLB.Items.IndexOf(Cross.Memo[0]);
    if i <> -1 then
    begin
      DatasetsLB.ItemIndex := i;
      DatasetsLBClick(nil);

      RMSetCommaText(Cross.Memo[1], sl);
      for i := 0 to sl.Count - 1 do
      begin
        s := PureName1(sl[i]);
        if FieldsLB.Items.IndexOf(s) <> -1 then
          FieldsLB.Items.Delete(FieldsLB.Items.IndexOf(s));
      end;
      ListBox2.Items.Assign(sl);

      RMSetCommaText(Cross.Memo[2], sl);
      for i := 0 to sl.Count - 1 do
      begin
        s := PureName1(sl[i]);
        if FieldsLB.Items.IndexOf(s) <> -1 then
          FieldsLB.Items.Delete(FieldsLB.Items.IndexOf(s));
      end;
      ListBox3.Items.Assign(sl);

      RMSetCommaText(Cross.Memo[3], sl);
      ListBox4.Items.Assign(sl);
    end;
  end
  else
  begin
    if DatasetsLB.Items.Count > 0 then
      DatasetsLB.ItemIndex := 0;
    DatasetsLBClick(nil);
    ListBox2.Clear;
    ListBox3.Clear;
    ListBox4.Clear;
  end;

  sl.Free;
end;

procedure TRMCrossForm.FormHide(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  if ModalResult = mrOk then
  begin
    RMDesigner.BeforeChange;
    Cross.Memo.Clear;
    Cross.Memo.Add(DatasetsLB.Items[DatasetsLB.ItemIndex]);

    s := '';
    for i := 0 to ListBox2.Items.Count - 1 do
      s := s + ListBox2.Items[i] + ';';
    Cross.Memo.Add(s);

    s := '';
    for i := 0 to ListBox3.Items.Count - 1 do
      s := s + ListBox3.Items[i] + ';';
    Cross.Memo.Add(s);

    s := '';
    for i := 0 to ListBox4.Items.Count - 1 do
      s := s + ListBox4.Items[i] + ';';
    Cross.Memo.Add(s);
  end;
end;

procedure TRMCrossForm.FormCreate(Sender: TObject);
begin
  Localize;
  DrawPanel := TDrawPanel.Create(Self);
  DrawPanel.Parent := Self;
  DrawPanel.Align := alBottom;
  DrawPanel.Height := ClientHeight - 244;
  DrawPanel.BevelOuter := bvNone;
  DrawPanel.BorderStyle := bsSingle;
end;

procedure TRMCrossForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  RMSetStrProp(GroupBox1, 'Caption', rmRes + 750);
  RMSetStrProp(GroupBox2, 'Caption', rmRes + 751);
  RMSetStrProp(CheckBox1, 'Caption', rmRes + 752);
  RMSetStrProp(Label1, 'Caption', rmRes + 753);
  RMSetStrProp(Self, 'Caption', rmRes + 754);

  btnOK.Caption := RMLoadStr(SOK);
  btnCancel.Caption := RMLoadStr(SCancel);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TDrawPanel }

procedure TDrawPanel.Draw(x, y, dx, dy: Integer; s: string);
begin
  with Canvas do
  begin
    Pen.Color := clBlack;
    Rectangle(x, y, x + dx + 1, y + dy + 1);
    TextRect(Rect(x + 1, y + 1, x + dx - 1, y + dy - 1), x + 3, y + 3, s);
  end;
end;

procedure TDrawPanel.DrawColumnCells;
var
  i, StartX, CurX, CurY, CurDX, CurDY: Integer;
  s: string;
begin
  CurX := 10 + FRowFields.Count * DefDX;
  CurY := 10 + (FColumnFields.Count - 1) * DefDY;
  CurDX := DefDX; CurDY := DefDY;
  StartX := CurX;

  i := FColumnFields.Count - 1;

// create cell
  Canvas.Brush.Color := clWhite;
  Draw(CurX, CurY, CurDX, CurDY, PureName1(FColumnFields[i]));
  Dec(CurY, DefDY);
  Inc(CurDY, DefDY);
  Inc(CurX, DefDX);

  Dec(i);
  while i >= -1 do
  begin
// Header cell
    Canvas.Brush.Color := clWhite;
    if i <> -1 then
      Draw(StartX, CurY, CurDX, DefDY, PureName1(FColumnFields[i]));

// Total cell
    if (i = -1) or (Pos('+', FColumnFields[i]) <> 0) then
    begin
      Canvas.Brush.Color := $F5F5F5;
      if i <> -1 then
        s := RMLoadStr(rmRes + 759) {'Total of '} + PureName1(FColumnFields[i])
      else
      begin
        Inc(CurY, DefDY);
        Dec(CurDY, DefDY);
        Canvas.Brush.Color := clSilver;
        s := RMLoadStr(rmRes + 757); //'Grand total';
      end;
      LastX := CurX + DefDX;
      Draw(CurX, CurY, DefDX, CurDY, s);
      Inc(CurDX, DefDX);
      Inc(CurX, DefDX);
    end;
    Dec(CurY, DefDY);
    Inc(CurDY, DefDY);

    Dec(i);
  end;
end;

procedure TDrawPanel.DrawRowCells;
var
  i, StartY, CurX, CurY, CurDX, CurDY, DefDY: Integer;
begin
  DefDY := Self.DefDY;
  CurX := 10 + (FRowFields.Count - 1) * DefDX;
  CurY := 10 + FColumnFields.Count * DefDY;
  StartY := CurY;
  DefDY := 18 * FCellFields.Count;
  CurDX := DefDX; CurDY := DefDY;

  i := FRowFields.Count - 1;

// create cell
  Canvas.Brush.Color := clWhite;
  Draw(CurX, CurY, CurDX, CurDY, PureName1(FRowFields[i]));
  Dec(CurX, DefDX);
  Inc(CurY, DefDY);
  Inc(CurDX, DefDX);

  Dec(i);
  while i >= 0 do
  begin
// Header cell
    Canvas.Brush.Color := clWhite;
    Draw(CurX, StartY, DefDX, CurDY, PureName1(FRowFields[i]));

// Total cell
    if Pos('+', FRowFields[i]) <> 0 then
    begin
      Canvas.Brush.Color := $F5F5F5;
      Draw(CurX, CurY, CurDX, DefDY, RMLoadStr(rmRes + 759) {'Total of '} + PureName1(FRowFields[i]));
      Inc(CurY, DefDY);
      Inc(CurDY, DefDY);
    end;

    Dec(CurX, DefDX);
    Inc(CurDX, DefDX);
    Dec(i);
  end;

// Grand total cell
  Canvas.Brush.Color := clSilver;
  LastY := CurY + DefDY;
  Draw(CurX + DefDX, CurY, CurDX - DefDX, DefDY, RMLoadStr(rmRes + 757) {'Grand total'});
end;

procedure TDrawPanel.DrawCellField;
var
  i, CurX, CurY: Integer;
begin
  CurX := 10 + FRowFields.Count * DefDX;
  CurY := 10 + FColumnFields.Count * DefDY;
  Canvas.Brush.Color := clWhite;

  for i := 0 to FCellFields.Count - 1 do
  begin
    Draw(CurX, CurY, DefDX, DefDY, PureName1(FCellFields[i]));
    Inc(CurY, DefDY);
  end;
end;

procedure TDrawPanel.DrawBorderLines(pos: byte);
begin
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Style := psDashDot;
  if Pos = 0 then
    Draw(10, 10, FRowFields.Count * DefDX, FColumnFields.Count * DefDY, '')
  else
  begin
    Canvas.MoveTo(10 + FRowFields.Count * DefDX, LastY);
    Canvas.LineTo(LastX, LastY);
    Canvas.MoveTo(LastX, 10 + FColumnFields.Count * DefDY);
    Canvas.LineTo(LastX, LastY);
  end;
  Canvas.Pen.Style := psSolid;
end;

procedure TDrawPanel.Paint;
begin
  Color := clWhite;
  inherited;
  FColumnFields := TRMCrossForm(Parent).ListBox3.Items;
  FRowFields := TRMCrossForm(Parent).ListBox2.Items;
  FCellFields := TRMCrossForm(Parent).ListBox4.Items;
  if (FColumnFields.Count < 1) or
    (FRowFields.Count < 1) or
    (FCellFields.Count < 1) then
    Exit;

  DefDx := 72; DefDy := 18;
  DrawBorderLines(0);
  DrawRowCells;
  DrawColumnCells;
  DrawCellField;
  DrawBorderLines(1);
end;

procedure TRMCrossForm.btnExchangeClick(Sender: TObject);
var
  s: string;
begin
  s := ListBox2.Items.Text;
  ListBox2.Items.Text := ListBox3.Items.Text;
  ListBox3.Items.Text := s;
  DrawPanel.Invalidate;
end;

procedure TRMCrossForm.ListBox3KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  s: string;
  i: Integer;
begin
  if Key = VK_DELETE then
  begin
    if TListBox(Sender).ItemIndex = -1 then
      Exit;
    s := PureName1(TListBox(Sender).Items[TListBox(Sender).ItemIndex]);
    FieldsLB.Items.Add(s);
    i := TListBox(Sender).ItemIndex;
    if (i <> -1) and (Pos(PureName1(s), TListBox(Sender).Items[i]) = 1) then
      TListBox(Sender).Items.Delete(i);

    TDrawPanel(DrawPanel).Paint;
  end;
end;


{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
type
  TAddColumnsHeaderEditor = class(TELStringPropEditor)
  protected
    function GetValue: string; override;
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TDictionaryEditor = class(TELStringPropEditor)
  protected
    function GetValue: string; override;
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

function TAddColumnsHeaderEditor.GetValue: string;
begin
  Result := '(TStrings)';
end;

function TAddColumnsHeaderEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praDialog, praReadOnly];
end;

procedure TAddColumnsHeaderEditor.Edit;
var
  tmp: TELStringsEditorDlg;
  t: TRMCrossView;
begin
  t := TRMCrossView(GetInstance(0));
  tmp := TELStringsEditorDlg.Create(nil);
  try
    tmp.Lines.Assign(t.FAddColumnsHeader);
    if tmp.ShowModal = mrOK then
      t.FAddColumnsHeader.Assign(tmp.Lines);
  finally
    tmp.Free;
  end;
end;

function TDictionaryEditor.GetValue: string;
begin
  Result := '(TStrings)';
end;

function TDictionaryEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praDialog, praReadOnly];
end;

procedure TDictionaryEditor.Edit;
var
  i: Integer;
  tmp: TELStringsEditorDlg;
  t: TRMCrossView;
begin
  t := TRMCrossView(GetInstance(0));
  if t.Memo.Count < 4 then Exit;

  if (t.FDictionary.Count = 0) then
  begin
    for i := 1 to CharCount(';', t.Memo[1]) do
      t.FDictionary.Add(_GetPureString(t.Memo[1], i) + '=');
    for i := 1 to CharCount(';', t.Memo[2]) do
      t.FDictionary.Add(_GetPureString(t.Memo[2], i) + '=');
    for i := 1 to CharCount(';', t.Memo[3]) do
      t.FDictionary.Add(_GetString(t.Memo[3], i) + '=');
  end;

  tmp := TELStringsEditorDlg.Create(nil);
  try
    tmp.Lines.Assign(t.FDictionary);
    if tmp.ShowModal = mrOK then
      t.FDictionary.Assign(tmp.Lines);
  finally
    tmp.Free;
  end;
end;

initialization
  RMRegisterObjectByRes(TRMCrossView, 'RM_CrossObject', RMLoadStr(SInsertCrosstab), TRMCrossForm);

  RMRegisterPropEditor(TypeInfo(TStrings), TRMCrossView, 'Dictionary', TDictionaryEditor);
  RMRegisterPropEditor(TypeInfo(TStrings), TRMCrossView, 'AddColumnHeader', TAddColumnsHeaderEditor);

finalization
  FCrossList.Free;
  FCrossList := nil;

end.

