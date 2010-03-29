unit RM_Common;

interface

{$I RM.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Forms, ExtCtrls, TypInfo,
  RM_Parser
{$IFDEF USE_INTERNAL_JVCL}
  , rm_JvInterpreter, rm_JvInterpreterParser, rm_JvInterpreterFm
{$ELSE}
  , JvInterpreter, JvInterpreterParser, JvInterpreterFm
{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

type
{    <Table>
    Value               Meaning
    ---------------------------
    rmutInches            Display in inches.
    rmutMillimeters       Display in millimeters.
    rmutScreenPixels      Display in screen pixels.
    rmutPrinterPixels     Display in printer pixels.
    rmutMMThousandths     Display in thousandths of millimeters.
    </Table>}
  TRMResolutionType = (rmrtHorizontal, rmrtVertical);
  TRMUnitType = (rmutScreenPixels, rmutInches, rmutMillimeters, rmutMMThousandths);
  TRMPrinterOrientation = (rmpoPortrait, rmpoLandscape);
  TRMPreviewZoom = (pzDefault, pzPageWidth, pzOnePage, pzTwoPages);
  TRMPreviewButton = (pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbPageSetup, pbExit, pbDesign,
    pbSaveToXLS);
  TRMPreviewButtons = set of TRMPreviewButton;
  TRMScaleMode = (mdNone, mdPageWidth, mdOnePage, mdTwoPages, mdPrinterZoom);

  TRMDataType = (rmdtBoolean, rmdtDate, rmdtTime, rmdtDateTime, rmdtInteger, rmdtSingle,
    rmdtDouble, rmdtExtended, rmdtCurrency, rmdtChar, rmdtString, rmdtVariant,
    rmdtLongint, rmdtBLOB, rmdtMemo, rmdtGraphic, rmdtNotKnown, rmdtLargeInt);
  TRMSearchOperatorType = (rmsoEqual, rmsoNotEqual,
    rmsoLessThan, rmsoLessThanOrEqualTo,
    rmsoGreaterThan, rmsoGreaterThanOrEqualTo,
    rmsoLike, rmsoNotLike,
    rmsoBetween, soNotBetween,
    rmsoInList, rmsoNotInList,
    rmsoBlank, rmsoNotBlank);

  TRMPageInfo = record // print info about page size, margins e.t.c
    PrinterPageWidth, PrinterPageHeight, PageWidth, PageHeight: Integer; // page width/height (printer/screen)
    PrinterOffsetX, PrinterOffsetY {, OffsetX, OffsetY}: Integer; // offset x/y
  end;

  TRMReportInfo = packed record
    Title: string;
    Author: string;
    Company: string;
    CopyRight: string;
    Comment: string;
  end;

  TRMClass = class of TRMCustomView;
  TRMCustomReport = class;

  TRMParamRec = record
    IsVar: Boolean;
    IsConst: Boolean;
    IsArray: Boolean;
    Name: string;
    ClassType: string;
  end;

  PRMParamRecArray = ^TRMParamRecArray;
  TRMParamRecArray = array[0..32] of TRMParamRec;

  { TRMPersistent }
  TRMPersistent = class(TPersistent)
  private
    function GetPropVars: TRMVariables;
  protected
    FPropVars: TRMVariables;
    FName: string;

    procedure LoadEventInfo(aStream: TStream);
    procedure SaveEventInfo(aStream: TStream);

    procedure SetObjectEvent(aEventList: TList; aEngine: TJvInterpreterFm);
    procedure SetName(const Value: string); virtual;
    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
      Args: array of Variant): Boolean; virtual;
    function SetPropValue(aObject: TObject; aPropName: string;
      aValue: Variant): Boolean; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    property PropVars: TRMVariables read GetPropVars;
    property Name: string read FName write SetName;
  published
  end;

 { TRMComponent }
  TRMComponent = class(TComponent)
  private
  protected
    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
      Args: array of Variant): Boolean; virtual;
    function SetPropValue(aObject: TObject; aPropName: string;
      aValue: Variant): Boolean; virtual;
  public
  end;

	{ TRMCustomView }
  TRMCustomView = class(TRMPersistent)
  public
    class function CanPlaceOnGridView: Boolean; virtual;
    class procedure DefaultSize(var aKx, aKy: Integer); virtual;
  end;

  TRMPreviewOptions = class(TPersistent)
  private
    FRulerUnit: TRMUnitType;
    FRulerVisible: Boolean;
    FDrawBorder: Boolean;
    FBorderPen: TPen;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    property RulerUnit: TRMUnitType read FRulerUnit write FRulerUnit;
    property RulerVisible: Boolean read FRulerVisible write FRulerVisible;
    property DrawBorder: Boolean read FDrawBorder write FDrawBorder;
    property BorderPen: TPen read FBorderPen write FBorderPen;
  end;

  { TRMCustomPreview}
  TRMCustomPreview = class(TPanel)
  private
    FOptions: TRMPreviewOptions;

    procedure SetOptions(Value: TRMPreviewOptions);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ShowReport(aReport: TObject); virtual; abstract;
    procedure Connect(aReport: TObject); virtual; abstract;
    procedure Print; virtual; abstract;
  published
    property Options: TRMPreviewOptions read FOptions write SetOptions;
  end;

  { TRMBandMsg }
  TRMBandMsg = class(TPersistent)
  private
    FFont: TFont;
    FLeftMemo, FCenterMemo, FRightMemo: TStringList;
    procedure SetFont(Value: TFont);
    procedure SetLeftMemo(Value: TStringList);
    procedure SetCenterMemo(Value: TStringList);
    procedure SetRightMemo(Value: TStringList);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Font: TFont read FFont write SetFont;
    property LeftMemo: TStringList read FLeftMemo write SetLeftMemo;
    property CenterMemo: TStringList read FCenterMemo write SetCenterMemo;
    property RightMemo: TStringList read FRightMemo write SetRightMemo;
  end;

  { TRMPageCaptionMsg }
  TRMPageCaptionMsg = class(TPersistent)
  private
    FTitleFont: TFont;
    FCaptionMsg: TRMBandMsg;
    FTitleMemo: TStringList;

    procedure SetTitleFont(Value: TFont);
    procedure SetTitleMemo(Value: TStringList);
    procedure SetCaptionMsg(Value: TRMBandMsg);
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property CaptionMsg: TRMBandMsg read FCaptionMsg write SetCaptionMsg;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property TitleMemo: TStringList read FTitleMemo write SetTitleMemo;
  end;

 { TRMCustomReport }
  TRMCustomReport = class(TRMComponent)
  private
    FTerminated: Boolean;
  protected
  public
    property Terminated: Boolean read FTerminated write FTerminated;
  end;

  TRMCustomExportFilter = class(TComponent)
  end;

  PRMFunctionDesc = ^TRMFunctionDesc;
  TRMFunctionDesc = packed record
    FuncName: string;
    Category: string;
    Description: string;
    FuncPara: string;
  end;

  { TRMFunctionLibrary }
  TRMCustomFunctionLibrary = class(TObject)
  private
    FFunctionList: TList;
    FList: TStringList;
    procedure Clear;
  protected
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function OnFunction(aParser: TRMParser; const aFunctionName: string;
    	aParams: array of Variant; var aValue: Variant): Boolean; virtual;
    procedure DoFunction(aParser: TRMParser; aFuncNo: Integer; aParams: array of Variant;
      var aValue: Variant); virtual; abstract;
    procedure AddFunctionDesc(const aFuncName, aCategory, aDescription, aFuncPara: string);

    property FunctionList: TList read FFunctionList;
    property List: TStringList read FList;
  end;

 { TRMAddInObjectInfo }
  TRMAddInObjectInfo = class
  private
    FIsPage: Boolean;
    FPage: string;
    FClassRef: TRMClass;
    FEditorFormClass: TFormClass;
    FButtonBmpRes: string;
    FButtonHint: string;
    FIsControl: Boolean;
  public
    constructor Create(AClassRef: TClass; AEditorFormClass: TFormClass;
      const AButtonBmpRes: string; const AButtonHint: string; AIsControl: Boolean);
    property ClassRef: TRMClass read FClassRef write FClassRef;
    property EditorFormClass: TFormClass read FEditorFormClass write FEditorFormClass;
    property ButtonBmpRes: string read FButtonBmpRes write FButtonBmpRes;
    property ButtonHint: string read FButtonHint write FButtonHint;
    property IsControl: Boolean read FIsControl write FIsControl;
    property Page: string read FPage write FPage;
    property IsPage: Boolean read FIsPage write FIsPage;
  end;

  { TRMExportFilterInfo }
  TRMExportFilterInfo = class
  private
    FFilter: TRMCustomExportFilter;
    FFilterDesc: string;
    FFilterExt: string;
  public
    constructor Create(AClassRef: TRMCustomExportFilter; const AFilterDesc: string; const AFilterExt: string);
    property Filter: TRMCustomExportFilter read FFilter write FFilter;
    property FilterDesc: string read FFilterDesc write FFilterDesc;
    property FilterExt: string read FFilterExt write FFilterExt;
  end;

  { TRMToolsInfo }
  TRMToolsInfo = class
  private
    FCaption: string;
    FButtonBmpRes: string;
    FOnClick: TNotifyEvent;
  public
    constructor Create(const ACaption: string; const AButtonBmpRes: string; AOnClick: TNotifyEvent);
    property Caption: string read FCaption write FCaption;
    property ButtonBmpRes: string read FButtonBmpRes write FButtonBmpRes;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  { TRMTempFileStream }
  TRMTempFileStream = class(TFileStream)
  private
    FFileName: string;
  public
    constructor Create;
    destructor Destroy; override;
    property FileName: string read FFileName;
  end;

function RMGetPropValue_1(aObject: TObject; aPropName: string; var aValue: Variant): Boolean;
function RMSetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean;

procedure RMRegisterObjectByRes(ClassRef: TClass; const ButtonBmpRes: string;
  const ButtonHint: string; EditorFormClass: TFormClass);
procedure RMRegisterControl(ClassRef: TClass; const ButtonBmpRes, ButtonHint: string); overload;
procedure RMRegisterControl(const aPage, aPageButtonBmpRes: string; aIsControl: Boolean;
  aClassRef: TClass;  aButtonBmpRes, aButtonHint: string); overload;
procedure RMRegisterControls(const aPage, aPageButtonBmpRes: string; aIsControl: Boolean;
  AryClassRef: array of TClass;
  AryButtonBmpRes: array of string;
  AryButtonHint: array of string);

procedure RMRegisterExportFilter(Filter: TRMCustomExportFilter; const FilterDesc, FilterExt: string);
procedure RMUnRegisterExportFilter(Filter: TRMCustomExportFilter);
procedure RMRegisterTool(const MenuCaption: string; const ButtonBmpRes: string; OnClick: TNotifyEvent);
procedure RMUnRegisterTool(const MenuCaption: string);
procedure RMRegisterFunctionLibrary(ClassRef: TClass);
procedure RMUnRegisterFunctionLibrary(ClassRef: TClass);

function RMAddIns(index: Integer): TRMAddInObjectInfo;
function RMAddInsCount: Integer;
function RMFilters(index: Integer): TRMExportFilterInfo;
function RMFiltersCount: Integer;
function RMTools(index: Integer): TRMToolsInfo;
function RMToolsCount: Integer;
function RMAddInFunctions(Index: Integer): TRMCustomFunctionLibrary;
function RMAddInFunctionCount: Integer;

var
  RMRegRootKey: string;

implementation

uses RM_Const, RM_Const1, RM_Utils;

function RMGetPropValue_1(aObject: TObject; aPropName: string; var aValue: Variant): Boolean;
var
  lPropInfo: PPropInfo;
begin
  lPropInfo := TypInfo.GetPropInfo(aObject.ClassInfo, aPropName);
  if lPropInfo = nil then
  begin
    Result := False;
    Exit;
  end;

  Result := True;
  case lPropInfo.PropType^^.Kind of
    tkInteger, tkChar, tkWChar, tkClass:
      aValue := TypInfo.GetOrdProp(aObject, lPropInfo);
    tkEnumeration:
      aValue := TypInfo.GetOrdProp(aObject, lPropInfo);
    tkSet:
      aValue := TypInfo.GetOrdProp(aObject, lPropInfo);
    tkFloat:
      aValue := TypInfo.GetFloatProp(aObject, lPropInfo);
    tkMethod:
      aValue := lPropInfo^.PropType^.Name;
    tkString, tkLString:
      aValue := TypInfo.GetStrProp(aObject, lPropInfo);
    tkWString:
      {$IFDEF Delphi6}
      aValue := TypInfo.GetWideStrProp(aObject, lPropInfo);
      {$ELSE}
      aValue := TypInfo.GetStrProp(aObject, lPropInfo);
      {$ENDIF}
    tkVariant:
      aValue := TypInfo.GetVariantProp(aObject, lPropInfo);
    tkInt64:
      {$IFDEF Delphi6}
      aValue := TypInfo.GetInt64Prop(aObject, lPropInfo);
      {$ELSE}
      aValue := TypInfo.GetInt64Prop(aObject, lPropInfo) + 0.0;
      {$ENDIF}
    tkDynArray:
  		DynArrayToVariant(aValue, Pointer(GetOrdProp(aObject, lPropInfo)), lPropInfo^.PropType^);
  else
    Result := False;
  end;
end;

function RMSetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean;

  function _RangedValue(const AMin, AMax: Int64): Int64;
  begin
    Result := Trunc(aValue);
    if (Result < AMin) or (Result > AMax) then
    begin
      //raise ERangeError.CreateRes(@SRangeError);
    end;
  end;

var
  lPropInfo: PPropInfo;
  lTypeData: PTypeData;
  lDynArray: Pointer;
begin
  Result := False;
  lPropInfo := GetPropInfo(aObject, aPropName);
  if lPropInfo = nil then Exit;

  Result := True;
  lTypeData := GetTypeData(lPropInfo^.PropType^);
  case lPropInfo.PropType^^.Kind of
    tkInteger, tkChar, tkWChar:
      if lTypeData^.MinValue < lTypeData^.MaxValue then
        TypInfo.SetOrdProp(aObject, lPropInfo, _RangedValue(lTypeData^.MinValue,
          lTypeData^.MaxValue))
      else
        TypInfo.SetOrdProp(aObject, lPropInfo,
          _RangedValue(LongWord(lTypeData^.MinValue),
          LongWord(lTypeData^.MaxValue)));
    tkEnumeration:
      if VarType(aValue) = varString then
        TypInfo.SetEnumProp(aObject, lPropInfo, VarToStr(aValue))
      else if VarType(aValue) = varBoolean then
        TypInfo.SetOrdProp(aObject, lPropInfo, Abs(Trunc(aValue)))
      else
        TypInfo.SetOrdProp(aObject, lPropInfo, _RangedValue(lTypeData^.MinValue,
          lTypeData^.MaxValue));
    tkSet:
      if VarType(aValue) = varInteger then
        TypInfo.SetOrdProp(aObject, lPropInfo, aValue)
      else
        TypInfo.SetSetProp(aObject, lPropInfo, VarToStr(aValue));
    tkFloat:
      TypInfo.SetFloatProp(aObject, lPropInfo, aValue);
    tkString, tkLString:
      TypInfo.SetStrProp(aObject, lPropInfo, VarToStr(aValue));
    tkWString:
      {$IFDEF Delphi6}
      TypInfo.SetWideStrProp(aObject, lPropInfo, VarToWideStr(aValue));
      {$ELSE}
      TypInfo.SetStrProp(aObject, lPropInfo, VarToStr(aValue));
      {$ENDIF}
    tkVariant:
      TypInfo.SetVariantProp(aObject, lPropInfo, aValue);
    tkInt64:
      TypInfo.SetInt64Prop(aObject, lPropInfo, _RangedValue(lTypeData^.MinInt64Value,
        lTypeData^.MaxInt64Value));
    tkDynArray:
      begin
        DynArrayFromVariant(lDynArray, aValue, lPropInfo^.PropType^);
        TypInfo.SetOrdProp(aObject, lPropInfo, Integer(lDynArray));
      end;
  else
    Result := False;
  end;
end;

procedure E_GetComponent(var aObject: TObject; var aPropName: string);
// PropName='Font.Color'
var
  lPropInfo: PPropInfo;
  lPos: integer;
begin
  while Pos('.', aPropName) > 0 do
  begin
    lPos := Pos('.', aPropName);
    lPropInfo := GetPropInfo(aObject.ClassInfo, Copy(aPropName, 1, lPos - 1));
    aObject := TObject(GetOrdProp(aObject, lPropInfo));
    Delete(aPropName, 1, lPos);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPersistent }

constructor TRMPersistent.Create;
begin
  inherited Create;

  FPropVars := nil;
end;

destructor TRMPersistent.Destroy;
begin
  FreeAndNil(FPropVars);
  inherited Destroy;
end;

function TRMPersistent.GetPropVars: TRMVariables;
begin
  if FPropVars = nil then
  begin
    FPropVars := TRMVariables.Create;
  end;

  Result := FPropVars;
end;

procedure TRMPersistent.LoadEventInfo(aStream: TStream);
var
  i, lCount: Integer;
  lStr: string;
begin
  lCount := RMReadWord(aStream);
  for i := 0 to lCount - 1 do
  begin
    lStr := RMReadString(aStream);
    PropVars[lStr] := RMReadString(aStream);
  end;
end;

procedure TRMPersistent.SaveEventInfo(aStream: TStream);
var
  i: Integer;
begin
  if FPropVars = nil then
    RMWriteWord(aStream, 0)
  else
  begin
    RMWriteWord(aStream, FPropVars.Count);
    for i := 0 to FPropVars.Count - 1 do
    begin
      RMWriteString(aStream, FPropVars.Name[i]);
      RMWriteString(aStream, FPropVars.Value[i]);
    end;
  end;
end;

function TRMPersistent.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
begin
  E_GetComponent(aObject, aPropName);
  Result := RMGetPropValue_1(aObject, aPropName, aValue);
end;

function TRMPersistent.SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean;
begin
  Result := False;
end;

procedure TRMPersistent.SetName(const Value: string);
begin
  FName := Value;
end;

type
  THackEngine = class(TJvInterpreterFm);
  THackRMCustomComponent = class(TRMPersistent);

procedure TRMPersistent.SetObjectEvent(aEventList: TList; aEngine: TJvInterpreterFm);
var
  i: Integer;
  lMethod: TMethod;
  lPropInfo: PPropInfo;
  lPropName: string;
  lPropValue: string;
begin
  if FPropVars = nil then Exit;

  for i := 0 to PropVars.Count - 1 do
  begin
    lPropName := PropVars.Name[i];
    lPropValue := PropVars.Value[i];
    if (lPropValue <> '') and
      aEngine.FunctionExists('Report', lPropValue) then
    begin
      lPropInfo := TypInfo.GetPropInfo(Self, lPropName);
      try
        lMethod := TMethod(THackEngine(aEngine).NewEvent(
          'Report',
          lPropValue,
          lPropInfo^.PropType^.Name,
          Self));
        TypInfo.SetMethodProp(Self, lPropInfo, lMethod);
        aEventList.Add(lMethod.Data);
      except
      end;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCustomView }

class function TRMCustomView.CanPlaceOnGridView: Boolean;
begin
  Result := True;
end;

class procedure TRMCustomView.DefaultSize(var aKx, aKy: Integer);
begin
  aKx := 96;
  aKy := 18;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPreviewOptions }

constructor TRMPreviewOptions.Create;
begin
  inherited;

  FRulerUnit := rmutScreenPixels;
  FRulerVisible := False;

  FDrawBorder := False;
  FBorderPen := TPen.Create;
  FBorderPen.Color := clBlue;
  FBorderPen.Style := psDash;
  FBorderPen.Width := 1;
end;

destructor TRMPreviewOptions.Destroy;
begin
  FreeAndNil(FBorderPen);

  inherited;
end;

procedure TRMPreviewOptions.Assign(Source: TPersistent);
begin
  FRulerUnit := TRMPreviewOptions(Source).RulerUnit;
  FRulerVisible := TRMPreviewOptions(Source).RulerVisible;

  FDrawBorder := TRMPreviewOptions(Source).DrawBorder;
  FBorderPen.Assign(TRMPreviewOptions(Source).BorderPen);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCustomPreview }

constructor TRMCustomPreview.Create(AOwner: TComponent);
begin
  inherited;

  FOptions := TRMPreviewOptions.Create;
end;

destructor TRMCustomPreview.Destroy;
begin
  FreeAndNil(FOptions);

  inherited;
end;

procedure TRMCustomPreview.SetOptions(Value: TRMPreviewOptions);
begin
  FOptions.Assign(Value);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandMsg }

constructor TRMBandMsg.Create;
begin
  inherited;

  FFont := TFont.Create;
  if RMIsChineseGB then
    FFont.Name := '宋体'
  else
    FFont.Name := 'Arial';
  FFont.Size := 10;
  FFont.Charset := StrToInt(RMLoadStr(SCharset)); //RMCharset;

  FLeftMemo := TStringList.Create;
  FCenterMemo := TStringList.Create;
  FRightMemo := TStringList.Create;
end;

destructor TRMBandMsg.Destroy;
begin
  FreeAndNil(FFont);
  FreeAndNil(FLeftMemo);
  FreeAndNil(FCenterMemo);
  FreeAndNil(FRightMemo);

  inherited;
end;

procedure TRMBandMsg.Assign(Source: TPersistent);
begin
  if Source is TRMBandMsg then
  begin
    FFont.Assign(TRMBandMsg(Source).Font);
    FLeftMemo.Assign(TRMBandMSg(Source).LeftMemo);
    FCenterMemo.Assign(TRMBandMSg(Source).CenterMemo);
    FRightMemo.Assign(TRMBandMSg(Source).RightMemo);
  end;
end;

procedure TRMBandMsg.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TRMBandMsg.SetLeftMemo(Value: TStringList);
begin
  FLeftMemo.Assign(Value);
end;

procedure TRMBandMsg.SetCenterMemo(Value: TStringList);
begin
  FCenterMemo.Assign(Value);
end;

procedure TRMBandMsg.SetRightMemo(Value: TStringList);
begin
  FRightMemo.Assign(Value);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPageCaptionMsg }

constructor TRMPageCaptionMsg.Create;
begin
  inherited;

  FTitleFont := TFont.Create;
  FTitleMemo := TStringList.Create;
  FCaptionMsg := TRMBandMsg.Create;

  if RMIsChineseGB then
    FTitleFont.Name := '宋体'
  else
    FTitleFont.Name := 'Arial';
  FTitleFont.Size := 10;
  FTitleFont.Charset := StrToInt(RMLoadStr(SCharset)); //RMCharset;
end;

destructor TRMPageCaptionMsg.Destroy;
begin
  FreeAndNil(FTitleFont);
  FreeAndNil(FTitleMemo);
  FreeAndNil(FCaptionMsg);

  inherited;
end;

procedure TRMPageCaptionMsg.Assign(Source: TPersistent);
begin
  if Source is TRMPageCaptionMsg then
  begin
    TitleFont := TRMPageCaptionMsg(Source).TitleFont;
    TitleMemo := TRMPageCaptionMsg(Source).TitleMemo;
    CaptionMsg := TRMPageCaptionMsg(Source).CaptionMsg;
  end;
end;

procedure TRMPageCaptionMsg.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
end;

procedure TRMPageCaptionMsg.SetTitleMemo(Value: TStringList);
begin
  FTitleMemo.Assign(Value);
end;

procedure TRMPageCaptionMsg.SetCaptionMsg(Value: TRMBandMsg);
begin
  FCaptionMsg.Assign(Value);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMComponent }

function TRMComponent.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
begin
  Result := False;
end;

function TRMComponent.SetPropValue(aObject: TObject; aPropName: string;
  aValue: Variant): Boolean;
begin
  Result := False;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMTempFileStream }

const
  sDefPrefix = 'dfs';

function GetTempFile(const prefix: string): string;
var
  path, pref3: string;
  ppref: PChar;
begin
  SetLength(path, 1024);
  SetLength(path, GetTempPath(1024, @path[1]));
  SetLength(Result, 1024);
  Result[1] := #0;
  case length(prefix) of
    0: ppref := PChar(sDefPrefix);
    1, 2:
      begin
        pref3 := prefix;
        while length(pref3) < 3 do
          pref3 := pref3 + '_';

        ppref := PChar(pref3);
      end;
    3: ppref := PChar(prefix);
  else
    pref3 := Copy(prefix, 1, 3);
    ppref := PChar(pref3);
  end;

  GetTempFileName(PChar(path), ppref, 0, PChar(Result));
  SetLength(Result, StrLen(PChar(Result)));
end;

constructor TRMTempFileStream.Create;
begin
  FFileName := GetTempFile(''); // Windows.GetTempFileName creates the file...
  inherited Create(FFileName, fmOpenReadWrite or fmShareDenyWrite);
end;

destructor TRMTempFileStream.Destroy;
begin
  DeleteFile(PChar(FFileName));
  inherited;
end;


{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
var
  FRMAddInObjectList: TStringList = nil;
  FRMExportFilterList: TStringList = nil;
  FRMToolsList: TStringList = nil;
  FRMFunctionList: TList = nil;

function RMAddInObjectList: TStringList;
begin
  if FRMAddInObjectList = nil then
    FRMAddInObjectList := TStringList.Create;
  Result := FRMAddInObjectList;
end;

function RMExportFilterList: TStringList;
begin
  if FRMExportFilterList = nil then
    FRMExportFilterList := TStringList.Create;
  Result := FRMExportFilterList;
end;

function RMToolsList: TStringList;
begin
  if FRMToolsList = nil then
    FRMToolsList := TStringList.Create;
  Result := FRMToolsList;
end;

function RMAddIns(index: Integer): TRMAddInObjectInfo;
begin
  Result := TRMAddInObjectInfo(FRMAddInObjectList.Objects[index]);
end;

function RMAddInsCount: Integer;
begin
  if FRMAddInObjectList = nil then
    Result := -1
  else
    Result := FRMAddinObjectList.Count;
end;

function RMFilters(index: Integer): TRMExportFilterInfo;
begin
  Result := TRMExportFilterInfo(FRMExportFilterList.Objects[index]);
end;

function RMFiltersCount: Integer;
begin
  if FRMExportFilterList = nil then
    Result := -1
  else
    Result := FRMExportFilterList.Count;
end;

function RMTools(index: Integer): TRMToolsInfo;
begin
  Result := TRMToolsInfo(FRMToolsList.Objects[index]);
end;

function RMToolsCount: Integer;
begin
  if FRMToolsList = nil then
    Result := -1
  else
    Result := FRMToolsList.Count;
end;

function RMFunctionList: TList;
begin
  if FRMFunctionList = nil then
    FRMFunctionList := TList.Create;
  Result := FRMFunctionList;
end;

function RMAddInFunctionCount: Integer;
begin
  if FRMFunctionList <> nil then
    Result := FRMFunctionList.Count
  else
    Result := 0;
end;

function RMAddInFunctions(Index: Integer): TRMCustomFunctionLibrary;
begin
  if (Index >= 0) and (Index < RMFunctionList.Count) then
    Result := TRMCustomFunctionLibrary(FRMFunctionList[Index])
  else
    Result := nil;
end;


{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMAddInObjectInfo}

constructor TRMAddInObjectInfo.Create(AClassRef: TClass;
  AEditorFormClass: TFormClass; const AButtonBmpRes: string;
  const AButtonHint: string; AIsControl: Boolean);
begin
  inherited Create;
  FClassRef := TRMClass(AClassRef);
  FEditorFormClass := AEditorFormClass;
  FButtonBmpRes := AButtonBmpRes;
  FButtonHint := AButtonHint;
  FIsControl := AIsControl;
  FPage := '';
  FIsPage := True;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMExportFilterInfo}

constructor TRMExportFilterInfo.Create(AClassRef: TRMCustomExportFilter;
  const AFilterDesc: string; const AFilterExt: string);
begin
  inherited Create;
  FFilter := AClassRef;
  FFilterDesc := AFilterDesc;
  FFilterExt := AFilterExt;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMToolsInfo}

constructor TRMToolsInfo.Create(const ACaption: string;
  const AButtonBmpRes: string; AOnClick: TNotifyEvent);
begin
  inherited Create;
  FCaption := ACaption;
  FButtonBmpRes := AButtonBmpRes;
  FOnClick := AOnClick;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{登记注册一个Add-in Object}

procedure RMRegisterObjectByRes(ClassRef: TClass; const ButtonBmpRes: string;
  const ButtonHint: string; EditorFormClass: TFormClass);
var
  tmp: TRMAddinObjectInfo;
begin
  tmp := TRMAddinObjectInfo.Create(ClassRef, EditorFormClass, ButtonBmpRes, ButtonHint,
    False);
  RMAddinObjectList.AddObject('', tmp);
end;

procedure RMRegisterControl(ClassRef: TClass; const ButtonBmpRes, ButtonHint: string);
var
  tmp: TRMAddinObjectInfo;
begin
  tmp := TRMAddinObjectInfo.Create(ClassRef, nil, ButtonBmpRes, ButtonHint, TRUE);
  RMAddinObjectList.AddObject('', tmp);
end;

function _FindRegisteredControl(aPage: string): Boolean;
var
  i: Integer;
  lInfo: TRMAddInObjectInfo;
begin
  Result := False;
  for i := 0 to RMAddinsCount - 1 do
  begin
    lInfo := RMAddins(i);
    if lInfo.IsPage and RMCmp(lInfo.Page, aPage) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure RMRegisterControl(const aPage, aPageButtonBmpRes: string; aIsControl: Boolean;
  aClassRef: TClass;  aButtonBmpRes, aButtonHint: string);
var
  tmp: TRMAddinObjectInfo;
begin
  if not _FindRegisteredControl(aPage) then
  begin
    tmp := TRMAddinObjectInfo.Create(nil, nil, aPageButtonBmpRes,
      '', aIsControl);
    tmp.Page := aPage;
    tmp.IsPage := True;
    RMAddinObjectList.AddObject('', tmp);
  end;

  tmp := TRMAddinObjectInfo.Create(aClassRef, nil, aButtonBmpRes,
      aButtonHint, aIsControl);
  tmp.Page := aPage;
  tmp.IsPage := False;
  RMAddinObjectList.AddObject('', tmp);
end;

procedure RMRegisterControls(const aPage, aPageButtonBmpRes: string;
  aIsControl: Boolean;
  AryClassRef: array of TClass;
  AryButtonBmpRes: array of string;
  AryButtonHint: array of string);
var
  tmp: TRMAddinObjectInfo;
  i: Integer;
begin
  if not _FindRegisteredControl(aPage) then
  begin
    tmp := TRMAddinObjectInfo.Create(nil, nil, aPageButtonBmpRes,
      '', aIsControl);
    tmp.Page := aPage;
    tmp.IsPage := True;
    RMAddinObjectList.AddObject('', tmp);
  end;

  for i := Low(AryClassRef) to High(AryClassRef) do
  begin
    tmp := TRMAddinObjectInfo.Create(AryClassRef[i], nil, AryButtonBmpRes[i],
      AryButtonHint[i], aIsControl);
    tmp.Page := aPage;
    tmp.IsPage := False;
    RMAddinObjectList.AddObject('', tmp);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{登记注册一个Export}

procedure RMRegisterExportFilter(Filter: TRMCustomExportFilter; const FilterDesc, FilterExt: string);
var
  i: Integer;
  tmp: TRMExportFilterInfo;
begin
  for i := 0 to RMFiltersCount - 1 do
  begin
    if RMFilters(i).Filter.ClassName = Filter.ClassName then Exit;
  end;
  tmp := TRMExportFilterInfo.Create(Filter, FilterDesc, FilterExt);
  RMExportFilterList.AddObject('', tmp);
end;

procedure RMUnRegisterExportFilter(Filter: TRMCustomExportFilter);
var
  i: Integer;
begin
  if FRMExportFilterList = nil then Exit;

  for i := 0 to RMFiltersCount - 1 do
  begin
    if RMFilters(i).Filter.ClassName = Filter.ClassName then
    begin
      TRMExportFilterInfo(RMExportFilterList.Objects[i]).Free;
      RMExportFilterList.Delete(i);
      Break;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{登记注册一个Design Tools}

procedure RMRegisterTool(const MenuCaption: string; const ButtonBmpRes: string; OnClick: TNotifyEvent);
var
  tmp: TRMToolsInfo;
begin
  tmp := TRMToolsInfo.Create(MenuCaption, ButtonBmpRes, OnClick);
  RMToolsList.AddObject('', tmp);
end;

procedure RMUnRegisterTool(const MenuCaption: string);
var
  i: Integer;
begin
  if FRMToolsList = nil then Exit;

  for i := 0 to RMToolsList.Count - 1 do
  begin
    if TRMToolsInfo(RMToolsList.Objects[i]).Caption = MenuCaption then
    begin
      TRMToolsInfo(RMToolsList.Objects[i]).Free;
      RMToolsList.Delete(i);
      Break;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure RMRegisterFunctionLibrary(ClassRef: TClass);
var
  i: Integer;
  tmp: TRMCustomFunctionLibrary;
begin
  for i := 0 to RMFunctionList.Count - 1 do
  begin
    if TRMCustomFunctionLibrary(RMFunctionList[i]).ClassName = ClassRef.ClassName then
      Exit;
  end;
  tmp := TRMCustomFunctionLibrary(ClassRef.NewInstance);
  tmp.Create;
  RMFunctionList.Add(tmp);
end;

procedure RMUnRegisterFunctionLibrary(ClassRef: TClass);
var
  i: Integer;
begin
  if FRMFunctionList = nil then Exit;

  for i := 0 to RMFunctionList.Count - 1 do
  begin
    if TRMCustomFunctionLibrary(RMFunctionList[i]).ClassName = ClassRef.ClassName then
    begin
      TRMCustomFunctionLibrary(RMFunctionList[i]).Free;
      RMFunctionList.Delete(i);
      Break;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMCustomFunctionLibrary}

constructor TRMCustomFunctionLibrary.Create;
begin
  inherited Create;
  
  FList := TStringList.Create;
  FFunctionList := TList.Create;
end;

destructor TRMCustomFunctionLibrary.Destroy;
begin
  Clear;
  FFunctionList.Free;
  FList.Free;
  
  inherited Destroy;
end;

procedure TRMCustomFunctionLibrary.Clear;
begin
  while FFunctionList.Count > 0 do
  begin
    Dispose(PRMFunctionDesc(FFunctionList[0]));
    FFunctionList.Delete(0);
  end;
end;

function TRMCustomFunctionLibrary.OnFunction(aParser: TRMParser; const aFunctionName: string;
  aParams: array of Variant; var aValue: Variant): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := FList.IndexOf(aFunctionName);
  if i >= 0 then
  begin
    DoFunction(aParser, i, aParams, aValue);
    Result := True;
  end;
end;

procedure TRMCustomFunctionLibrary.AddFunctionDesc(const aFuncName, aCategory,
	aDescription, aFuncPara: string);
var
  pfunc: PRMFunctionDesc;
begin
  New(pfunc);
  pfunc^.FuncName := aFuncName;
  pfunc^.Category := aCategory;
  pfunc^.Description := aDescription;
  pfunc^.FuncPara := aFuncPara;
  
  FFunctionList.Add(pfunc);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure FreeAddInObjectList;
var
  i: Integer;
begin
  if FRMAddInObjectList = nil then Exit;
  for i := 0 to FRMAddInObjectList.Count - 1 do
    FRMAddInObjectList.Objects[i].Free;

  FreeAndNil(FRMAddInObjectList);
end;

procedure FreeExportFilterList;
var
  i: Integer;
begin
  if FRMExportFilterList = nil then Exit;
  for i := 0 to FRMExportFilterList.Count - 1 do
    FRMExportFilterList.Objects[i].Free;

  FreeAndNil(FRMExportFilterList);
end;

procedure FreeToolsList;
var
  i: Integer;
begin
  if FRMToolsList = nil then Exit;
  for i := 0 to FRMToolsList.Count - 1 do
    FRMToolsList.Objects[i].Free;

  FreeAndNil(FRMToolsList);
end;

procedure FreeFunctionList;
var
  i: Integer;
begin
  if FRMFunctionList = nil then Exit;
  for i := 0 to FRMFunctionList.Count - 1 do
    TRMCustomFunctionLibrary(FRMFunctionList[i]).Free;

  FreeAndNil(FRMFunctionList);
end;

initialization
  RMRegRootKey := 'Software\WHF SoftWare\Report Machine';

finalization
  FreeAddInObjectList;
  FreeExportFilterList;
  FreeToolsList;
  FreeFunctionList;

end.

