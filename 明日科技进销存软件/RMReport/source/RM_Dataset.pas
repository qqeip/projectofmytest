
{*****************************************}
{                                         }
{            Report Machine               }
{             Report dataset              }
{                                         }
{*****************************************}

unit RM_Dataset;

interface

{$I RM.INC}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Stdctrls, DB, RM_Common
  {$IFDEF Delphi6}, Variants{$ENDIF};

type
  TRMRangeBegin = (rmrbFirst, rmrbCurrent, rmrbDefault);
  TRMRangeEnd = (rmreLast, rmreCurrent, rmreCount, rmreDefault);
  TRMCheckEOFEvent = procedure(Sender: TObject; var EOF: Boolean) of object;

  { TRMDataset }
  TRMDataset = class(TRMComponent)
  private
  protected
    FDictionaryKey: string;
    FRangeBegin: TRMRangeBegin;
    FRangeEnd: TRMRangeEnd;
    FRangeEndCount: Integer;
    FOnInit, FOnFirst, FOnNext, FOnLast, FOnPrior: TNotifyEvent;
    FOnCheckEOF: TRMCheckEOFEvent;
    FRecordNo: Integer;
    FOnAfterFirst: TNotifyEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Open; virtual;
    procedure Init; virtual;
    procedure Exit; virtual;
    procedure First; virtual;
    procedure Last; virtual;
    procedure Next; virtual;
    procedure Prior; virtual;
    function EOF: Boolean; virtual;
    function Active: boolean; virtual; abstract;
    function GetFieldValue(const aFieldName: string; aConvertNulls: Boolean): Variant; virtual; abstract;
    function FieldIsNull(const aFieldName: string): Boolean; virtual;
    function FieldWidth(const aFieldName: string): Integer; virtual;
    procedure GetFieldsList(aFieldList: TStringList); virtual; abstract;
    function IsBlobField(const aFieldName: string): Boolean; virtual;
    procedure AssignBlobFieldTo(const aFieldName: string; aDest: TObject); virtual;

    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
      Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string;
      aValue: Variant): Boolean; override;

    property RecordNo: Integer read FRecordNo;
    property OnCheckEOF: TRMCheckEOFEvent read FOnCheckEOF write FOnCheckEOF;
    property OnInit: TNotifyEvent read FOnInit write FOnInit;
    property OnFirst: TNotifyEvent read FOnFirst write FOnFirst;
    property OnNext: TNotifyEvent read FOnNext write FOnNext;
    property OnPrior: TNotifyEvent read FOnPrior write FOnPrior;
  published
    property DictionaryKey: string read FDictionaryKey write FDictionaryKey;
    property RangeBegin: TRMRangeBegin read FRangeBegin write FRangeBegin default rmrbFirst;
    property RangeEnd: TRMRangeEnd read FRangeEnd write FRangeEnd default rmreLast;
    property RangeEndCount: Integer read FRangeEndCount write FRangeEndCount default 0;
  end;

  { TRMUserDataset }
  TRMUserDatasetOnGetFieldValue = procedure(Dataset: TRMDataset; const FieldName: string; var FieldValue: Variant) of object;
  TRMUserDatasetOnGetFieldsList = procedure(Dataset: TRMDataset; FieldNames: TStrings) of object;

  TRMUserDataset = class(TRMDataset)
  private
    FOnGetFieldValue: TRMUserDatasetOnGetFieldValue;
    FOnGetFieldsList: TRMUserDatasetOnGetFieldsList;
  public
    function GetFieldValue(const aFieldName: string; aConvertNulls: Boolean): Variant; override;
    procedure GetFieldsList(aFieldList: TStringList); override;
    function Active: boolean; override;
  published
    property OnCheckEOF;
    property OnInit;
    property OnFirst;
    property OnNext;
    property OnPrior;
    property OnGetFieldValue: TRMUserDatasetOnGetFieldValue read FOnGetFieldValue write FOnGetFieldValue;
    property OnGetFieldsList: TRMUserDatasetOnGetFieldsList read FOnGetFieldsList write FOnGetFieldsList;
  end;

  { TRMStringsDataset}
  TprStringSourceType = (rmssNone, rmssListBox, rmssComboBox, rmssMemo);

  TRMStringsDataset = class(TRMUserDataset)
  private
    FCurIndex: integer;
    FStrings: TStrings;
    FStringsSource: TComponent;
    FStringsSourceType: TprStringSourceType;

    procedure SetStringsSource(Value: TComponent);
    function GetStrings: TStrings;
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;

    function Active: boolean; override;
    function Eof: boolean; override;
    function GetFieldValue(const aFieldName: string; aConvertNulls: Boolean): Variant; override;

    procedure Init; override;
    procedure First; override;
    procedure Last; override;
    procedure Next; override;
    procedure Prior; override;
    procedure GetFieldsList(aFieldList: TStringList); override;

    property Strings: TStrings read GetStrings write FStrings;
  published
    property StringsSource: TComponent read FStringsSource write SetStringsSource;
  end;

  { TRMDBDataSet }
  TRMDBDataSet = class(TRMDataset)
  private
    FDataSet: TDataSet;
    FOpenDataSet, FCloseDataSet: Boolean;
    FOnOpen, FOnClose: TNotifyEvent;
    FBookmark: TBookmark;
    FEof: Boolean;
    procedure SetDataSet(Value: TDataSet);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Active: boolean; override;
    procedure Init; override;
    procedure Exit; override;
    procedure First; override;
    procedure Last; override;
    procedure Next; override;
    procedure Prior; override;
    procedure MoveBy(Distance: Integer);
    procedure Open; override;
    procedure Close;
    function EOF: Boolean; override;
    function GetDataSet: TDataSet;
    function FieldWidth(const aFieldName: string): Integer; override;
    function FieldIsNull(const aFieldName: string): Boolean; override;
    function GetFieldValue(const aFieldName: string; aConvertNulls: Boolean): Variant; override;
    procedure GetFieldsList(aFieldList: TStringList); override;
    function IsBlobField(const aFieldName: string): Boolean; override;
    procedure AssignBlobFieldTo(const aFieldName: string; aDest: TObject); override;
  published
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property CloseDataSet: Boolean read FCloseDataSet write FCloseDataSet default False;
    property OpenDataSet: Boolean read FOpenDataSet write FOpenDataSet default True;
    property OnCheckEOF;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnFirst;
    property OnNext;
    property OnPrior;
    property OnInit;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
  end;

function RMIsBlob(aField: TField): Boolean;
procedure RMAssignBlobTo(aBlobField: TField; aObj: TObject);
procedure RMDisableDBControls(aDataSet: TDataSet);
procedure RMEnableDBControls(aDataSet: TDataSet);

implementation

uses
  RM_Class, RM_Utils;

type
  EDSError = class(Exception);

  TRMGraphicHeader = record
    Count: Word; // Fixed at 1
    HType: Word; // Fixed at $0100
    Size: Longint; // Size not including header
  end;

  {$IFDEF Delphi6}

procedure _AssignBlobToPicture(aBlobField: TBlobField; aObj: TPersistent);

  function _SupportsStreamPersist(const aPersistent: TPersistent;
    var aStreamPersist: IStreamPersist): Boolean;
  begin
    Result := (aPersistent is TInterfacedPersistent) and
      (TInterfacedPersistent(aPersistent).QueryInterface(IStreamPersist, aStreamPersist) = S_OK);
  end;

  procedure _SaveToStreamPersist(aStreamPersist: IStreamPersist);
  var
    lBlobStream: TStream;
    lSize: Longint;
    lHeader: TRMGraphicHeader;
  begin
    lBlobStream := aBlobField.DataSet.CreateBlobStream(aBlobField, bmRead);
    try
      lSize := lBlobStream.Size;
      if lSize >= SizeOf(TRMGraphicHeader) then
      begin
        lBlobStream.Read(lHeader, SizeOf(lHeader));
        if (lHeader.Count <> 1) or (lHeader.HType <> $0100) or
          (lHeader.Size <> lSize - SizeOf(lHeader)) then
          lBlobStream.Position := 0;
      end;

      aStreamPersist.LoadFromStream(lBlobStream);
    finally
      lBlobStream.Free;
    end;
  end;

var
  lStreamPersist: IStreamPersist;
begin
  if _SupportsStreamPersist(aObj, lStreamPersist) then
    _SaveToStreamPersist(lStreamPersist);
end;
{$ENDIF}

function RMIsBlob(aField: TField): Boolean;
begin
  Result := (aField <> nil) and (aField.DataType in [ftBlob..ftTypedBinary]);
end;

procedure RMAssignBlobTo(aBlobField: TField; aObj: TObject);
begin
  if aObj is TPersistent then
  begin
    try
      TPersistent(aObj).Assign(aBlobField)
    except
      on e: EConvertError do
      begin
        {$IFDEF Delphi6}
        _AssignBlobToPicture(TBlobField(aBlobField), TPersistent(aObj));
        {$ENDIF}
      end;
    end;
  end
  else if aObj is TStream then
  begin
    TBlobField(aBlobField).SaveToStream(TStream(aObj));
    TStream(aObj).Position := 0;
  end;
end;

procedure RMDisableDBControls(aDataSet: TDataSet);
begin
  if aDataSet <> nil then
    aDataSet.DisableControls;
end;

procedure RMEnableDBControls(aDataSet: TDataSet);
begin
  if aDataSet <> nil then
    aDataSet.EnableControls;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDataSet }

constructor TRMDataset.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FOnAfterFirst := nil;
  RangeBegin := rmrbFirst;
  RangeEnd := rmreLast;
end;

destructor TRMDataset.Destroy;
begin
  inherited Destroy;
end;

function TRMDataset.IsBlobField(const aFieldName: string): Boolean;
begin
  Result := False;
end;

function TRMDataSet.FieldIsNull(const aFieldName: string): Boolean;
begin
  Result := True;
end;

function TRMDataSet.FieldWidth(const aFieldName: string): Integer;
begin
  Result := 0;
end;

procedure TRMDataSet.AssignBlobFieldTo(const aFieldName: string; aDest: TObject);
begin
  //
end;

procedure TRMDataset.Open;
begin
end;

procedure TRMDataset.Init;
begin
  if Assigned(FOnInit) then FOnInit(Self);
end;

procedure TRMDataset.Exit;
begin
  //
end;

procedure TRMDataset.First;
begin
  FRecordNo := 0;
  if Assigned(FOnFirst) then FOnFirst(Self);
end;

procedure TRMDataset.Last;
begin
  //
end;

procedure TRMDataset.Next;
begin
  Inc(FRecordNo);
  if not ((FRangeEnd = rmreCount) and (FRecordNo >= FRangeEndCount)) then
  begin
    if Assigned(FOnNext) then FOnNext(Self);
  end;
end;

procedure TRMDataSet.Prior;
begin
  Dec(FRecordNo);
  if Assigned(FOnPrior) then FOnPrior(Self);
end;

function TRMDataset.EOF: Boolean;
begin
  Result := False;
  if (FRangeEnd = rmreCount) and (FRecordNo >= FRangeEndCount) then Result := True;
  if Assigned(FOnCheckEOF) then FOnCheckEOF(Self, Result);
end;

function TRMDataSet.GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
  Args: array of Variant): Boolean;
begin
  //	Result := True;
  //  if aPropName = 'NEXT' then
  //  	Next
  //  else
  Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

function TRMDataSet.SetPropValue(aObject: TObject; aPropName: string;
  aValue: Variant): Boolean;
begin
  //	Result := True;
  Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMUserDataSet }

function TRMUserDataSet.GetFieldValue(const aFieldName: string;
  aConvertNulls: Boolean): Variant;
begin
  Result := UnAssigned;
  if Assigned(FOnGetFieldValue) then
    FOnGetFieldValue(Self, aFieldName, Result);
end;

procedure TRMUserDataSet.GetFieldsList(aFieldList: TStringList);
begin
  if Assigned(FOnGetFieldsList) then
    FOnGetFieldsList(Self, aFieldList);
end;

function TRMUserDataSet.Active: boolean;
begin
  Result := True;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMStringsDataset }

constructor TRMStringsDataset.Create;
begin
  inherited;
  FStringsSourceType := rmssNone;
end;

procedure TRMStringsDataset.Notification;
begin
  inherited;
  if (AOperation = opRemove) and (AComponent = FStringsSource) then
    FStringsSource := nil;
end;

procedure TRMStringsDataset.SetStringsSource;
begin
  if (Value = nil) or (Value is TComboBox) or (Value is TListBox) or (Value is TMemo) then
  begin
    FStringsSource := Value;
    if FStringsSource is TComboBox then
      FStringsSourceType := rmssComboBox
    else if FStringsSource is TListBox then
      FStringsSourceType := rmssListBox
    else if FStringsSource is TMemo then
      FStringsSourceType := rmssMemo
    else
      FStringsSourceType := rmssNone;
  end;
end;

function TRMStringsDataset.GetStrings;
begin
  Result := nil;
  if FStringsSourceType <> rmssNone then
  begin
    case FStringsSourceType of
      rmssComboBox: Result := TComboBox(FStringsSource).Items;
      rmssListBox: Result := TListBox(FStringsSource).Items;
      rmssMemo: Result := TMemo(FStringsSource).Lines;
    end;
  end
  else
  begin
    if Strings <> nil then
      Result := Strings;
  end;
end;

function TRMStringsDataset.Active;
begin
  Result := True;
end;

function TRMStringsDataset.Eof;
begin
  Result := FCurIndex >= Strings.Count;
end;

function TRMStringsDataset.GetFieldValue(const aFieldName: string;
  aConvertNulls: Boolean): Variant;
begin
  if AnsiCompareText('NAME', aFieldName) = 0 then
    Result := Strings[FCurIndex]
  else if AnsiCompareText('ID', aFieldName) = 0 then
    Result := integer(Strings.Objects[FCurIndex]);
end;

procedure TRMStringsDataset.Init;
begin
  FRecordNo := 0;
  inherited Init;
end;

procedure TRMStringsDataset.First;
begin
  FRecordNo := 0;
  inherited First;
end;

procedure TRMStringsDataset.Last;
begin
  //
end;

procedure TRMStringsDataset.Next;
begin
  if FRecordNo <= Strings.Count then
    Inc(FRecordNo);
  inherited Next;
end;

procedure TRMStringsDataset.Prior;
begin
  if FRecordNo > 0 then
    Dec(FRecordNo);
  inherited Prior;
end;

procedure TRMStringsDataset.GetFieldsList(aFieldList: TStringList);
begin
  aFieldList.Add('NAME');
  aFieldList.Add('ID');
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDBDataSet }

constructor TRMDBDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOpenDataSet := True;
  FBookMark := nil;
end;

destructor TRMDBDataSet.Destroy;
begin
  inherited Destroy;
end;

function TRMDBDataset.IsBlobField(const aFieldName: string): Boolean;
begin
  Result := False;
  if FDataSet <> nil then
    Result := RMIsBlob(FDataset.FindField(aFieldName));
end;

procedure TRMDBDataSet.AssignBlobFieldTo(const aFieldName: string; aDest: TObject);
begin
  RMAssignBlobTo(FDataSet.FindField(aFieldName), aDest);
end;

procedure TRMDBDataSet.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FDataSet then
      FDataSet := nil;
  end;
end;

procedure TRMDBDataSet.SetDataSet(Value: TDataSet);
begin
  FDataSet := Value;
end;

function TRMDBDataSet.GetDataSet: TDataSet;
begin
  if FDataSet <> nil then
    Result := FDataSet
  else
  begin
    raise EDSError.Create('Unable to open dataset ' + Name);
    Result := nil;
  end;
end;

function TRMDBDataSet.Active: boolean;
begin
  Result := False;
  if FDataSet <> nil then
    Result := FDataSet.Active;
end;

procedure TRMDBDataSet.Init;
begin
  Open;
  if FBookMark <> nil then
    GetDataSet.FreeBookMark(FBookMark);

  FBookmark := DataSet.GetBookmark;
  //	if CurPage.CanDisableControls then
  //	  RMDisableDBControls(TDataSet(GetDataSet));
  FEof := False;
end;

procedure TRMDBDataSet.Exit;
begin
  try
    if FBookMark <> nil then
    begin
      if (FRangeBegin = rmrbCurrent) or (FRangeEnd = rmreCurrent) then
        GetDataSet.GotoBookmark(FBookMark);
      GetDataSet.FreeBookMark(FBookmark);
    end;
  finally
    FBookMark := nil;
    Close;
  end;
end;

procedure TRMDBDataSet.First;
begin
  if FRangeBegin = rmrbFirst then
    GetDataSet.First
  else if FRangeBegin = rmrbCurrent then
    GetDataSet.GotoBookMark(FBookMark);

  FEof := False;
  inherited First;
end;

procedure TRMDBDataSet.Last;
begin
  if FRangeEnd = rmreLast then
    GetDataSet.Last
  else if FRangeEnd = rmreCurrent then
    GetDataSet.GotoBookMark(FBookMark);

  FEof := True;
  inherited Last;
end;

procedure TRMDBDataSet.Next;
var
  liBookMark: TBookmark;
begin
  FEof := False;
  if FRangeEnd = rmreCurrent then
  begin
    liBookMark := GetDataSet.GetBookMark;
    if GetDataSet.CompareBookMarks(liBookMark, FBookMark) = 0 then
      FEof := True;
    GetDataSet.FreeBookMark(liBookMark);
    if not FEof then
    begin
      GetDataSet.Next;
      inherited Next;
    end;
    System.Exit;
  end;
  GetDataSet.Next;
  inherited Next;
end;

procedure TRMDBDataSet.MoveBy(Distance: Integer);
begin
  GetDataSet.MoveBy(Distance);
end;

procedure TRMDBDataSet.Prior;
begin
  GetDataSet.Prior;
  inherited Prior;
end;

function TRMDBDataSet.EOF: Boolean;
begin
  Result := inherited EOF or FEof or GetDataSet.EOF;
end;

procedure TRMDBDataSet.Open;
begin
  if FOpenDataSet then GetDataSet.Open;
  if Assigned(FOnOpen) then FOnOpen(Self);
end;

procedure TRMDBDataSet.Close;
begin
  if Assigned(FOnClose) then FOnClose(Self);
  if FCloseDataSet then GetDataSet.Close;
end;

function TRMDBDataSet.FieldIsNull(const aFieldName: string): Boolean;
var
  lField: TField;
begin
  lField := FDataSet.FindField(aFieldName);
  Result := (lField <> nil) and lField.IsNull;
end;

function TRMDBDataSet.FieldWidth(const aFieldName: string): Integer;
var
  lField: TField;
begin
  Result := 0;
  lField := FDataSet.FindField(aFieldName);
  if lField <> nil then
    Result := lField.DisplayWidth;
end;

function TRMDBDataSet.GetFieldValue(const aFieldName: string;
  aConvertNulls: Boolean): Variant;
var
  lField: TField;
begin
  lField := FDataSet.FindField(aFieldName);
  if lField = nil then Exit;

  if Assigned(lField.OnGetText) then
    Result := lField.DisplayText
  else
  begin
    {$IFDEF Delphi4}
    if lField.DataType in [ftLargeint] then
      Result := lField.DisplayText
    else
      {$ENDIF}
      Result := lField.AsVariant;
    //    if F.DataType in [ftCurrency{$IFDEF Delphi4}, ftLargeint{$ENDIF}] then
    //      Result := F.DisplayText
    //    else
    //      Result := F.AsVariant;
  end;

  if (Result = Null) and aConvertNulls {(not RMUseNull)} then
  begin
    if lField.DataType in [ftString{$IFDEF Delphi4}, ftWideString{$ENDIF}] then
      Result := ''
    else if lField.DataType = ftBoolean then
      Result := False
    else
      Result := 0;
  end;
end;

{$HINTS OFF}

procedure TRMDBDataSet.GetFieldsList(aFieldList: TStringList);
var
  i: Integer;
begin
  aFieldList.Clear;
  if FDataSet = nil then Exit;

  try
//    FDataSet.GetFieldNames(aFieldList);
		  aFieldList.Clear;
      if FDataSet.FieldList.Count > 0 then
      begin
        for i := 0 to FDataSet.FieldList.Count - 1 do
          aFieldList.Add(FDataSet.FieldList[i].FieldName);
      end
      else
      begin
        FDataSet.FieldDefs.Update;
        for i := 0 to FDataSet.FieldDefList.Count - 1 do
          aFieldList.Add(FDataSet.FieldDefList[i].Name);
      end;
  except
//    on e: EConvertError do
//    begin
//		  aFieldList.Clear;
//      if FDataSet.FieldList.Count > 0 then
//      begin
//        for i := 0 to FDataSet.FieldList.Count - 1 do
//          aFieldList.Add(FDataSet.FieldList[i].FieldName);
//      end
//      else
//      begin
//        FDataSet.FieldDefs.Update;
//        for i := 0 to FDataSet.FieldDefList.Count - 1 do
//          aFieldList.Add(FDataSet.FieldDefList[i].Name);
//      end;
//    end;
  end;
end;
{$HINTS ON}

end.

