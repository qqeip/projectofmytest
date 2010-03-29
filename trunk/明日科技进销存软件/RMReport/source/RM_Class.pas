{*****************************************}
{                                         }
{              Report Machine             }
{             Report classes              }
{                                         }
{*****************************************}

unit RM_Class;

{$I RM.INC}
{$R RM_LNG1.RES}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, TypInfo,
  Forms, StdCtrls, Dialogs, IniFiles, Registry, DB, RM_Ctrls,
  RM_Const, RM_Const1, RM_Dataset, RM_Progr, RM_Printer, RM_Common,
  RM_AutoSearchField, RM_Parser, rm_ZlibEx
  {$IFDEF USE_INTERNAL_JVCL}
  , rm_JvInterpreter, rm_JvInterpreterParser, rm_JvInterpreterFm
  {$ELSE}
  , JvInterpreter, JvInterpreterParser, JvInterpreterFm
  {$ENDIF}
  {$IFDEF TntUnicode}, TntSysUtils{$ENDIF}
  {$IFDEF Delphi6}, Variants{$ENDIF};

const
  rmgtMemo = 0;
  rmgtPicture = 1;
  rmgtSubReport = 2;
  //  rmgtLine = 3;
  rmgtCalcMemo = 4;
  rmgtBand = 5;
  rmgtShape = 6;
  rmgtOutline = 7;
  rmgtAddIn = 100;

type

  TRMPrintMethodType = (rmptMetafile, rmptBitmap);
  TRMPictureSource = (rmpsPicture, rmpsFileName);
  TRMReportStatus = (rmrsReady, rmrsBusy, rmrsFinished);
  TRMCompressionLevel = (rmzcNone, rmzcFastest, rmzcDefault, rmzcMax);

  TRMDocMode = (rmdmDesigning, rmdmPrinting, rmdmPreviewing, rmdmNone);
  TRMHAlign = (rmhLeft, rmhCenter, rmhRight, rmhEuqal);
  TRMVAlign = (rmvTop, rmvCenter, rmvBottom);
  TRMDrawMode = (rmdmAll, rmdmAfterCalcHeight, rmdmPart);
  TRMPrintPages = (rmppAll, rmppOdd, rmppEven);
  TRMColumnDirectionType = (rmcdTopBottomLeftRight, rmcdLeftRightTopBottom);
  TRMDBCalcType = (rmdcSum, rmdcCount, rmdcAvg, rmdcMax, rmdcMin, rmdcUser);
  TRMRotationType = (rmrtNone, rmrt90, rmrt180, rmrt270, rmrt360);
  TRMScaleFontType = (rmstNone, rmstByWidth, rmstByHeight);
  TRMCompositeMode = (rmReportPerReport, rmPagePerPage);
  TRMReportType = (rmrtSimple, rmrtMultiple);
  TRMStreamMode = (rmsmDesigning, rmsmPrinting);
  TRMDataSetPosition = (rmpsLocal, rmpsGlobal);
  TRMRestriction = (rmrtDontModify, rmrtDontSize, rmrtDontMove, rmrtDontDelete, rmrtDontEditMemo);
  TRMRestrictions = set of TRMRestriction;
  TRMBandAlign = (rmbaNone, rmbaLeft, rmbaRight, rmbaBottom, rmbaTop, rmbaCenter);
  TRMShiftMode = (rmsmAlways, rmsmNever, rmsmWhenOverlapped);
  TRMRgnType = (rmrtNormal, rmrtExtended);
  TRMSubReportType = (rmstFixed, rmstChild);
  TRMShapeType = (rmskRectangle, rmskRoundRectangle, rmskEllipse, rmskTriangle,
    rmskDiagonal1, rmskDiagonal2, rmskSquare, rmskRoundSquare, rmskCircle, rmHorLine,
    rmRightAndLeft, rmTopAndBottom, rmVertLine);

  TRMBandRecType = (rmrtShowBand, rmrtFirst, rmrtNext);
  TRMBandType = (rmbtReportTitle, rmbtReportSummary,
    rmbtPageHeader, rmbtPageFooter,
    rmbtHeader, rmbtFooter,
    rmbtMasterData, rmbtDetailData,
    rmbtOverlay, rmbtColumnHeader, rmbtColumnFooter,
    rmbtGroupHeader, rmbtGroupFooter,
    rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter, rmbtChild, rmbtNone);
  TRMDesignerRestriction =
    (rmdrDontEditObj, rmdrDontModifyObj, rmdrDontSizeObj, rmdrDontMoveObj,
    rmdrDontDeleteObj, rmdrDontCreateObj,
    rmdrDontDeletePage, rmdrDontCreatePage, rmdrDontEditPage,
    rmdrDontCreateReport, rmdrDontLoadReport, rmdrDontSaveReport,
    rmdrDontPreviewReport, rmdrDontEditVariables, rmdrDontChangeReportOptions, rmdtDontEditScript);
  TRMDesignerRestrictions = set of TRMDesignerRestriction;

  TRMView = class;
  TRMReportView = class;
  TRMBand = class;
  TRMCustomPage = class;
  TRMReportPage = class;
  TRMPages = class;
  TRMReport = class;
  TRMReportDesigner = class;
  TRMEndPage = class;
  TRMEndPages = class;

  TRMGetValueEvent = procedure(const ParName: string; var ParValue: Variant) of object;
  TRMLoadSaveReportSettingEvent = procedure(aReport: TRMReport) of object;
  TRMProgressEvent = procedure(n: Integer) of object;
  TRMBeginPageEvent = procedure(PageNo: Integer) of object;
  TRMEndPageEvent = procedure(PageNo: Integer) of object;
  TRMAfterPrintEvent = procedure(const View: TRMReportView) of object;
  TRMOnBeforePrintEvent = procedure(Memo: TStrings; View: TRMReportView) of object;
  TRMBeginBandEvent = procedure(aBand: TRMBand) of object;
  TRMEndBandEvent = procedure(aBand: TRMBand) of object;
  TRMManualBuildEvent = procedure(aPage: TRMReportPage) of object;
  TRMBeginColumnEvent = procedure(aBand: TRMBand) of object;
  TRMPrintColumnEvent = procedure(ColNo: Integer; var Width: Integer) of object;
  TRMBeforePrintBandEvent = procedure(aBand: TRMBand; var PrintBand: Boolean) of object;
  TRMEndPrintPageEvent = procedure(var aPageNo: Integer) of object;
  TRMReadOneEndPageEvent = procedure(const aPageNo, aTotalPages: Integer) of object;

  TRMPreviewClickEvent = procedure(Sender: TRMReportView; Button: TMouseButton;
    Shift: TShiftState; var Modified: Boolean) of object;

  TRMBeforeExportEvent = procedure(var aFileName: string; var aContinue: Boolean) of object;
  TRMAfterExportEvent = procedure(const aFileName: string) of object;

  PRMCacheItem = ^TRMCacheItem;
  TRMCacheItem = record
    DataSet: TRMDataSet;
    DataFieldName: string;
  end;

  { TRMHighlight }
  TRMHighlight = class(TPersistent)
  private
    FColor: TColor;
    FFont: TFont;
    FCondition: string;
    procedure SetFont(Value: TFont);
    procedure SetColor(Value: TColor);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read FColor write SetColor;
    property Condition: string read FCondition write FCondition;
    property Font: TFont read FFont write SetFont;
  end;

  { TRMFrameLine }
  TRMFrameLine = class(TPersistent)
  private
    FVisible: Boolean;
    FStyle: TPenStyle;
    FColor: TColor;
    FmmWidth: Integer;
    FParentView: TRMView;
    FDoubleFrame: Boolean;

    function GetWidth: Double;
    procedure SetWidth(Value: Double);
    function GetspWidth: Integer;
    procedure SetspWidth(Value: Integer);
    procedure SetColor(Value: TColor);
  public
    constructor Create(aParentView: TRMView);
    procedure Assign(Source: TPersistent); override;
    function GetUnits: TRMUnitType;

    property mmWidth: Integer read FmmWidth write FmmWidth;
    property spWidth: Integer read GetspWidth write SetspWidth;
  published
    property Visible: Boolean read FVisible write FVisible;
    property Style: TPenStyle read FStyle write FStyle;
    property Color: TColor read FColor write SetColor;
    property Width: Double read GetWidth write SetWidth;
    property DoubleFrame: Boolean read FDoubleFrame write FDoubleFrame;
  end;

  { TRMView }
  TRMView = class(TRMCustomView)
  private
    FParentFont: Boolean;
    FIsBand, FIsCrossBand: Boolean;
    FParentPage: TRMCustomPage;
    FParentReport: TRMReport;
    FmmLeft, FmmTop, FmmWidth, FmmHeight: Integer;
    FmmGapLeft, FmmGapTop: Integer;
    FVisible: Boolean;
    FMemo, FMemo1: TStrings;
    FRestrictions: TRMRestrictions;
    FIsStringValue: Boolean;
    FLeftFrame: TRMFrameLine;
    FTopFrame: TRMFrameLine;
    FRightFrame: TRMFrameLine;
    FBottomFrame: TRMFrameLine;
    FLeftRightFrame: Word;
    FFillColor: TColor;
    FBrushStyle: TBrushStyle;
    FTag: Integer;
    FTagStr: string;
    FUrl: string;
    FFlowTo: string;
    FStyle: string;
    FCursor: TCursor;
    FExpressionDelimiters: string;

    function GetProp(Index: string): Variant;
    procedure SetProp(Index: string; Value: Variant);
    function GetLeft(Index: Integer): Double;
    procedure SetLeft(Index: Integer; Value: Double);
    function GetspLeft(Index: Integer): Integer;
    procedure SetspLeft(Index: Integer; Value: Integer);
    function GetspLeft_Designer(Index: Integer): Integer;
    procedure SetspLeft_Designer(Index: Integer; Value: Integer);

    procedure SetFillColor(Value: TColor);
    procedure SetMemo(Value: TStrings);
    procedure SetMemo1(Value: TStrings);
    function GetWantHook: Boolean;
    procedure SetWantHook(const value: Boolean);
    function GetStretched: Boolean;
    procedure SetStretched(const value: Boolean);
    function GetStretchedMax: Boolean;
    procedure SetStretchedMax(const value: Boolean);
    function GetTransparent: Boolean;
    procedure SetTransparent(value: Boolean);
    function GetHideZeros: Boolean;
    procedure SetHideZeros(Value: Boolean);
    function GetDontUndo: Boolean;
    procedure SetDontUndo(Value: Boolean);
    function GetOnePerPage: Boolean;
    procedure SetOnePerPage(Value: Boolean);
    function GetIsChildView: Boolean;
    procedure SetIsChildView(Value: Boolean);
    function GetUseDoublePass: Boolean;
    procedure SetUseDoublePass(Value: Boolean);
    procedure SetParentFont(Value: Boolean);
    procedure SetStyle(Value: string);
    procedure SetFlowTo(Value: string);
    procedure SetTagStr(Value: string);
    procedure SetUrl(Value: string);
  protected
    Typ: Byte; // 对象类型
    BaseName: string;
    Canvas: TCanvas;
    StreamMode: TRMStreamMode;
    FFlags: LongWord;
    ParentBand: TRMBand;
    FDataSet: TRMDataset;
    FDataFieldName: string;
    IsBlobField: Boolean;
    FNeedWrapped: Boolean;
    ObjectID: Integer;
    IsPrinting: Boolean;
    FComponent: TComponent;

    mmSaveGapX, mmSaveGapY: Integer;
    mmSaveLeft, mmSaveTop, mmSaveWidth, mmSaveHeight: Integer;
    mmSaveFWLeft, mmSaveFWTop, mmSaveFWRight, mmSaveFWBottom: Integer;
    mmSaveFontWidth: Integer;
    SaveFontWidth: Integer;
    RealRect: TRect;
    OriginalRect: TRect;

    FactorX, FactorY: Double; // used for scaling objects in preview
    OffsetLeft, OffsetTop: Integer; //

    procedure SetPropertyValue(aPropName: string; aValue: Variant);
    procedure ClearContents; virtual;
    procedure SetName(const Value: string); override;
    procedure InternalOnGetValue(aView: TRMReportView; aParName: string; var aParValue: string; aUnicode: Boolean);
    procedure InternalOnBeforePrint(Memo: TStrings; View: TRMReportView);
    function _CalcVFrameWidth(aTopWidth, aBottomWidth: Double): Integer;
    function _CalcHFrameWidth(aLeftWidth, aRightWidth: Double): Integer;
    function _DrawRect: TRect;
    function GetPrinter: TRMPrinter;
    procedure AfterChangeName; virtual;
    function DocMode: TRMDocMode;
    procedure OnHook(View: TRMView); virtual;
    procedure Loaded; virtual;
    procedure CalcGaps; virtual;
    procedure RestoreCoord; virtual;
    procedure ShowBackGround; virtual;
    procedure Prepare; virtual;
    procedure UnPrepare; virtual;
    function GetViewCommon: string; virtual;
    function GetParentBand: TRMBand;
    procedure SetParentPage(Value: TRMCustomPage); virtual;
    function IsCrossView: Boolean; virtual;
    function IsContainer: Boolean; virtual;

    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
      Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean; override;

    property Tag: Integer read FTag write FTag;
    property TagStr: string read FTagStr write SetTagStr;
    property Url: string read FUrl write SetUrl;
    property FlowTo: string read FFlowTo write SetFlowTo;
    property Style: string read FStyle write SetStyle;
    property BrushStyle: TBrushStyle read FBrushStyle write FBrushStyle;
    property ParentFont: Boolean read FParentFont write SetParentFont;
    property ParentReport: TRMReport read FParentReport write FParentReport;
    property WantHook: Boolean read GetWantHook write SetWantHook;
    property Stretched: Boolean read GetStretched write SetStretched;
    property StretchedMax: Boolean read GetStretchedMax write SetStretchedMax;
    property Transparent: Boolean read GetTransparent write SetTransparent;
    property HideZeros: Boolean read GetHideZeros write SetHideZeros;
    property Visible: Boolean read FVisible write FVisible;
    property Left: Double index 0 read GetLeft write SetLeft;
    property Top: Double index 1 read GetLeft write SetLeft;
    property Width: Double index 2 read GetLeft write SetLeft;
    property Height: Double index 3 read GetLeft write SetLeft;
    property Cursor: TCursor read FCursor write FCursor;
    property ExpressionDelimiters: string read FExpressionDelimiters write FExpressionDelimiters;

    property mmGapLeft: Integer read FmmGapLeft;
    property mmGapTop: integer read FmmGapTop;
    property mmLeft: Integer read FmmLeft;
    property mmTop: Integer read FmmTop;
    property mmWidth: Integer read FmmWidth;
    property mmHeight: Integer read FmmHeight;
    property DontUndo: Boolean read GetDontUndo write SetDontUndo;
    property OnePerPage: Boolean read GetOnePerPage write SetOnePerPage;
    property IsChildView: Boolean read GetIsChildView write SetIsChildView;
    property UseDoublePass: Boolean read GetUseDoublePass write SetUseDoublePass;
  public
    Selected: Boolean; // used in designer
    NeedCreateName: Boolean;

    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(aSource: TPersistent); override;
    procedure ShowEditor; virtual;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); virtual;

    function GetClipRgn(rt: TRMRgnType): HRGN; virtual;
    function GetUnits: TRMUnitType;
    procedure CreateName(aReport: TRMReport);
    procedure SetBounds(aLeft, aTop, aWidth, aHeight: Double);
    procedure SetspBounds(aLeft, aTop, aWidth, aHeight: Integer);
    procedure LoadFromStream(aStream: TStream); virtual; abstract;
    procedure SaveToStream(aStream: TStream); virtual; abstract;
    procedure Draw(aCanvas: TCanvas); virtual; abstract;
    procedure SetFrameVisible(aVisible: Boolean);

    property Prop[Index: string]: Variant read GetProp write SetProp; default;
    property IsBand: Boolean read FIsBand;
    property IsCrossBand: Boolean read FIsCrossBand;
    property ParentPage: TRMCustomPage read FParentPage write SetParentPage;

    property spLeft_Designer: Integer index 0 read GetspLeft_Designer write SetspLeft_Designer;
    property spTop_Designer: Integer index 1 read GetspLeft_Designer write SetspLeft_Designer;
    property spWidth_Designer: Integer index 2 read GetspLeft_Designer write SetspLeft_Designer;
    property spHeight_Designer: Integer index 3 read GetspLeft_Designer write SetspLeft_Designer;
    property spRight_Designer: Integer index 4 read GetspLeft_Designer;
    property spBottom_Designer: Integer index 5 read GetspLeft_Designer;

    property spLeft: Integer index 0 read GetspLeft write SetspLeft;
    property spTop: Integer index 1 read GetspLeft write SetspLeft;
    property spWidth: Integer index 2 read GetspLeft write SetspLeft;
    property spHeight: Integer index 3 read GetspLeft write SetspLeft;
    property spRight: Integer index 4 read GetspLeft;
    property spBottom: Integer index 5 read GetspLeft;

    property Memo1: TStrings read FMemo1 write SetMemo1;
    property ObjectType: Byte read Typ;
    property LeftFrame: TRMFrameLine read FLeftFrame write FLeftFrame;
    property TopFrame: TRMFrameLine read FTopFrame write FTopFrame;
    property RightFrame: TRMFrameLine read FRightFrame write FRightFrame;
    property BottomFrame: TRMFrameLine read FBottomFrame write FBottomFrame;
    property LeftRightFrame: Word read FLeftRightFrame write FLeftRightFrame;
    property FillColor: TColor read FFillColor write SetFillColor;
    property Memo: TStrings read FMemo write SetMemo;
  published
    property Restrictions: TRMRestrictions read FRestrictions write FRestrictions;
    property Name;
  end;

  { TRMDialogComponent }
  TRMDialogComponent = class(TRMView)
  private
    FTabOrder: Integer;
    FParentControl: string;

    procedure SetParentControl(Value: string);
  protected
    FBmpRes: string;
    procedure BeginDraw(aCanvas: TCanvas);
    procedure PaintDesignControl;
    property ParentControl: string read FParentControl write SetParentControl;
    property TabOrder: Integer read FTabOrder write FTabOrder;
  public
    class procedure DefaultSize(var aKx, aKy: Integer); override;
    constructor Create; override;
    destructor Destroy; override;
    procedure Draw(aCanvas: TCanvas); override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
  published
  end;

  { TRMDialogControl }
  TRMDialogControl = class(TRMDialogComponent)
  private
  protected
    FControl: TControl;

    function GetFont: TFont; virtual;
    procedure SetFont(Value: TFont); virtual;

    procedure FreeChildViews;
    procedure PaintDesignControl;

    property Font: TFont read GetFont write SetFont;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Draw(aCanvas: TCanvas); override;

    property Control: TControl read FControl;
  published
  end;

  TRMFormat = packed record
    FormatIndex1, FormatIndex2: Byte;
    FormatPercent: Byte;
    FormatdelimiterChar: Char;
  end;

  { TRMReportView }
  TRMReportView = class(TRMView)
  private
    FNeedPrint: Boolean;
    FmmOldTop, FmmOldHeight: Integer;
    FBandAlign: TRMBandAlign;
    FShiftWith: string;
    FStretchWith: string;
    FOnBeforePrint: TNotifyEvent;
    FOnBeforeCalc: TNotifyEvent;
    FOnAfterCalc: TNotifyEvent;
    FOnPreviewClick: TRMPreviewClickEvent;
    FStretchWithView, FShiftWithView: TRMReportView;

    procedure OnStretchedClick(Sender: TObject);
    procedure OnStretchedMaxClick(Sender: TObject);
    procedure OnVisibleClick(Sender: TObject);
    procedure OnPrintableClick(Sender: TObject);

    function GetGapX(Index: Integer): Double;
    procedure SetGapX(Index: Integer; Value: Double);
    function GetspGapX(Index: Integer): Integer;
    procedure SetspGapX(Index: Integer; Value: Integer);
    function GetPrintFrame: Boolean;
    procedure SetPrintFrame(Value: Boolean);
    function GetPrintable: Boolean;
    procedure SetPrintable(Value: Boolean);
    function GetTextOnly: Boolean;
    procedure SetTextOnly(Value: Boolean);
    function GetReprintOnOverFlow: Boolean;
    procedure SetReprintOnOverFlow(Value: Boolean);
    procedure SetShiftWith(Value: string);
    procedure SetStretchWith(Value: string);
    function GetDataField: string;
    procedure SetDataField(Value: string);
    procedure SetDisplayFormat(Value: string);
    function GetParentWidth: Boolean;
    procedure SetParentWidth(Value: Boolean);
    function GetParentHeight: Boolean;
    procedure SetParentHeight(Value: Boolean);
  protected
    FDisplayFormat: string;
    FormatFlag: TRMFormat;

    procedure BeginDraw(aCanvas: TCanvas);
    procedure Prepare; override;
    procedure ShowFrame; virtual;
    procedure ExpandVariables(var aStr: string);
    procedure PlaceOnEndPage(aStream: TStream); virtual;
    procedure GetBlob; virtual;
    procedure SetFactorFont(aCanvas: TCanvas);
    function GetFactorSize(aValue: Integer): Integer;
    procedure ExportData; virtual;

    property PrintFrame: Boolean read GetPrintFrame write SetPrintFrame;
    property Printable: Boolean read GetPrintable write SetPrintable;
    property BandAlign: TRMBandAlign read FBandAlign write FBandAlign;
    property TextOnly: Boolean read GetTextOnly write SetTextOnly;
    property GapLeft: Double index 0 read GetGapX write SetGapX;
    property GapTop: Double index 1 read GetGapX write SetGapX;
    property DisplayFormat: string read FDisplayFormat write SetDisplayFormat;
    property ReprintOnOverFlow: Boolean read GetReprintOnOverFlow write SetReprintOnOverFlow;
    property ShiftWith: string read FShiftWith write SetShiftWith;
    property StretchWith: string read FStretchWith write SetStretchWith;
    property DataField: string read GetDataField write SetDataField;
    property ParentHeight: Boolean read GetParentHeight write SetParentHeight;
    property ParentWidth: Boolean read GetParentWidth write SetParentWidth;
    property OnBeforeCalc: TNotifyEvent read FOnBeforeCalc write FOnBeforeCalc;
    property OnAfterCalc: TNotifyEvent read FOnAfterCalc write FOnAfterCalc;
    property OnPreviewClick: TRMPreviewClickEvent read FOnPreviewClick write FOnPreviewClick;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;
    function GetClipRgn(rt: TRMRgnType): HRGN; override;

    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;

    property spGapLeft: Integer index 0 read GetspGapX write SetspGapX;
    property spGapTop: Integer index 1 read GetspGapX write SetspGapX;
    property mmLeft;
    property mmTop;
    property mmWidth;
    property mmHeight;
  published
    property Visible;
    property Left;
    property Top;
    property Width;
    property Height;
    property OnBeforePrint: TNotifyEvent read FOnBeforePrint write FOnBeforePrint;
  end;

  { TRMStretcheableView }
  TRMStretcheableView = class(TRMReportView)
  private
    FUseBandHeight: Boolean;
  protected
    DrawMode: TRMDrawMode;
    CalculatedHeight: Integer;
    ActualHeight: Integer;

    function CalcHeight: Integer; virtual; abstract;
    function RemainHeight: Integer; virtual; abstract;
    procedure GetMemoVariables; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
    property Stretched;
    property StretchedMax;
  end;

  TRMRepeatedOptions = class(TPersistent)
  private
    FMasterMemoView: string;
    FSuppressRepeated: Boolean;
    FMergeRepeated: Boolean;
    FMergeStretchedHeight: Boolean;
  protected
  public
  published
    property MasterMemoView: string read FMasterMemoView write FMasterMemoView;
    property SuppressRepeated: Boolean read FSuppressRepeated write FSuppressRepeated;
    property MergeRepeated: Boolean read FMergeRepeated write FMergeRepeated;
    property MergeStretchedHeight: Boolean read FMergeStretchedHeight write FMergeStretchedHeight;
  end;

  { TRMCustomMemoView }
  TRMCustomMemoView = class(TRMStretcheableView)
  private
    FDisplayBeginLine, FDisplayEndLine: Integer;
    FMasterView: TRMView;
    FSMemo: TStrings;
    FFont: TFont;
    FHighlight: TRMHighlight;
    FLineSpacing, FCharacterSpacing: Integer;
    FRotationType: TRMRotationType;
    FScaleFontType: TRMScaleFontType;
    FRepeatedOptions: TRMRepeatedOptions;
    FHAlign: TRMHAlign;
    FVAlign: TRMVAlign;
    FFontScaleWidth: Integer;
    FLastValue, FLastValue1: string;
    FLastValuePage: Integer;
    FLastValueChanged: Boolean;
    //    FTextWidths: array of integer;

    FVHeight: Integer; // used for height calculation of TRMCustomMemoView
    FLastStreamPosition: Integer;
    FmmLastTop: Integer;

    procedure OnWordWrapClick(Sender: TObject);
    procedure OnAutoWidthClick(Sender: TObject);
    procedure OnHideZerosClick(Sender: TObject);
    //    procedure OnUnderlinesClick(Sender: TObject);
    procedure OnTextOnlyClick(Sender: TObject);

    procedure CalcGeneratedData(DC: THandle);
    procedure SetFont(Value: TFont);
    function GetWordwrap: Boolean;
    procedure SetWordwrap(Value: Boolean);
    function GetWordBreak: Boolean;
    procedure SetWordBreak(Value: Boolean);
    function GetAutoWidth: Boolean;
    procedure SetAutoWidth(Value: Boolean);
    function GetMangeTag: Boolean;
    procedure SetMangeTag(Value: Boolean);
    function GetPrintAtAppendBlank: Boolean;
    procedure SetPrintAtAppendBlank(Value: Boolean);
    procedure SetRepeatedOptions(Value: TRMRepeatedOptions);
    function GetExportAsNumber: Boolean;
    procedure SetExportAsNumber(Value: Boolean);
    function GetDBFieldOnly: Boolean;
    procedure SetDBFieldOnly(Value: Boolean);
    function GetUnderlines: Boolean;
    procedure SetUnderlines(value: Boolean);
    function GetIsCurrency: Boolean;
    procedure SetIsCurrency(value: Boolean);
  protected
    FMergeEmpty: Boolean;
    CurStrNo: Integer;
    MergeEmpty: Boolean;
    LineHeight: Integer;
    FFlagPlaceOnEndPage: Boolean;
    Exporting: Boolean;

    function GetPropValue(aObject: TObject; aPropName: string;
      var aValue: Variant; Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string;
      aValue: Variant): Boolean; override;

    function CanMergeCell: Boolean;
    procedure AssignFont(aCanvas: TCanvas);
    procedure GetBlob; override;
    procedure Prepare; override;
    procedure ExpandMemoVariables; virtual;
    procedure WrapMemo;
    procedure ShowMemo;
    function CalcHeight: Integer; override;
    function RemainHeight: Integer; override;
    procedure GetMemoVariables; override;
    procedure PlaceOnEndPage(aStream: TStream); override;
    procedure ExportData; override;
    function CalcWidth(aMemo: TStringList): Integer;
    procedure Set_AutoWidth(const aCanvas: TCanvas);
    procedure ShowUnderLines;

    property WantHook;
    property RotationType: TRMRotationType read FRotationType write FRotationType;
    property ScaleFontType: TRMScaleFontType read FScaleFontType write FScaleFontType;
    property FontScaleWidth: Integer read FFontScaleWidth write FFontScaleWidth;
    property WordWrap: Boolean read GetWordwrap write SetWordwrap;
    property WordBreak: Boolean read GetWordBreak write SetWordBreak;
    property AutoWidth: Boolean read GetAutoWidth write SetAutoWidth;
    property RepeatedOptions: TRMRepeatedOptions read FRepeatedOptions write SetRepeatedOptions;
    property PrintAtAppendBlank: Boolean read GetPrintAtAppendBlank write SetPrintAtAppendBlank;
    property ExportAsNumber: Boolean read GetExportAsNumber write SetExportAsNumber;
    property LastValue: string read FLastValue write FLastValue;
    property IsCurrency: Boolean read GetIsCurrency write SetIsCurrency;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;
    procedure ShowEditor; override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;

    procedure Draw(aCanvas: TCanvas); override;
  published
    property Highlight: TRMHighlight read FHighlight write FHighlight;
    property PrintFrame;
    property Printable;
    property BandAlign;
    property Font: TFont read FFont write SetFont;
    property GapLeft;
    property GapTop;
    property LineSpacing: Integer read FLineSpacing write FLineSpacing;
    property CharacterSpacing: Integer read FCharacterSpacing write FCharacterSpacing;
    property HideZeros;
    property LeftFrame;
    property TopFrame;
    property RightFrame;
    property BottomFrame;
    property Memo;
    property ShiftWith;
    property StretchWith;
    property HAlign: TRMHAlign read FHAlign write FHAlign;
    property VAlign: TRMVAlign read FVAlign write FVAlign;
    property MangeTag: Boolean read GetMangeTag write SetMangeTag;
    property DisplayFormat;
    property TextOnly;
    property FillColor;
    property ParentHeight;
    property ParentWidth;
    property DBFieldOnly: Boolean read GetDBFieldOnly write SetDBFieldOnly;
    property Underlines: Boolean read GetUnderlines write SetUnderlines;
    property DisplayBeginLine: Integer read FDisplayBeginLine write FDisplayBeginLine;
    property DisplayEndLine: Integer read FDisplayEndLine write FDisplayEndLine;
    property BrushStyle;
    property Cursor;
    property ExpressionDelimiters;
    property Url;

    property OnBeforePrint;
    property OnBeforeCalc;
    property OnAfterCalc;
    property OnPreviewClick;
  end;

  { TRMMemoView }
  TRMMemoView = class(TRMCustomMemoView)
  published
    property RotationType;
    property ScaleFontType;
    property FontScaleWidth;
    property WordWrap;
    property WordBreak;
    property AutoWidth;
    property RepeatedOptions;
    property PrintAtAppendBlank;
    property ExportAsNumber;
    property DataField;
  end;

  { TRMCalcOptions }
  TRMCalcOptions = class(TPersistent)
  private
    FParentView: TRMView;
    FCalcType: TRMDBCalcType;
    FAggrBandName: string;
    FResetAfterPrint: Boolean;
    FFilter: string;
    FIntalizeValue: string;
    FAggregateValue: string;
    FResetGroupName: string;

    function GetTotalCalc: Boolean;
    procedure SetTotalCalc(Value: Boolean);
    function GetCalcNoVisible: Boolean;
    procedure SetCalcNoVisible(Value: Boolean);
    function GetMemo: TStrings;
    procedure SetMemo(Value: TStrings);
  public
    constructor Create(aView: TRMView);
  published
    property CalcType: TRMDBCalcType read FCalcType write FCalcType;
    property Filter: string read FFilter write FFilter;
    property ResetAfterPrint: Boolean read FResetAfterPrint write FResetAfterPrint;
    property ResetGroupName: string read FResetGroupName write FResetGroupName;
    property AggrBandName: string read FAggrBandName write FAggrBandName;
    property TotalCalc: Boolean read GetTotalCalc write SetTotalCalc;
    property CalcNoVisible: Boolean read GetCalcNoVisible write SetCalcNoVisible;
    property IntalizeValue: string read FIntalizeValue write FIntalizeValue;
    property AggregateValue: string read FAggregateValue write FAggregateValue;
    property Memo: TStrings read GetMemo write SetMemo;
  end;

  { TRMCalcMemoView }
  TRMCalcMemoView = class(TRMCustomMemoView)
  private
    FValueIndex: Integer;
    FValues: TStringList;
    FOPZFilter: string;
    FResAssigned: Boolean;
    FValue: Double;
    FCurrencyValue: Currency;
    FSum: Double;
    FCount: Integer;
    FExpression: string;
    FCalcOptions: TRMCalcOptions;
    FResultExpression: string;
    FResetGroupBand: TRMView;
    //dejoy added begin
    FLastMasterViewValue: Variant; //masterview的最后一个值
    FLastAggValue: Double; //合计文本框的最后一个值
    //dejoy added end

    function GetValue: Double;
    procedure AfterPrint(aIsHeaderBand: Boolean);
    procedure ResetValues;
    procedure OnResetAfterPrintClick(Sender: TObject);

    procedure SetResultExpression(Value: string);
    function GetOutBigNum: Boolean;
    procedure SetOutBigNum(Value: Boolean);
  protected
    function GetPropValue(aObject: TObject; aPropName: string;
      var aValue: Variant; Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string;
      aValue: Variant): Boolean; override;

    procedure Prepare; override;
    procedure ExpandMemoVariables; override;
    procedure PlaceOnEndPage(aStream: TStream); override;
    procedure Reset;
    procedure DoAggregate;

    property Expression: string read FExpression write FExpression;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;
  published
    property CalcOptions: TRMCalcOptions read FCalcOptions write FCalcOptions;

    property IsCurrency;
    property RotationType;
    property ScaleFontType;
    property FontScaleWidth;
    property WordWrap;
    property WordBreak;
    property AutoWidth;
    property RepeatedOptions;
    property PrintAtAppendBlank;
    property ExportAsNumber;
    property OutBigNum: Boolean read GetOutBigNum write SetOutBigNum;
    property ResultExpression: string read FResultExpression write SetResultExpression;
  end;

  TRMBlobType = (rmbtBitmap, rmbtMetafile, rmbtIcon, rmbtJPEG, rmbtGIF, rmbtAuto);
  TRMPictureFormat = (rmpfBorland, rmpfMicrosoft, rmpfAuto);

  { TRMPictureView }
  TRMPictureView = class(TRMReportView)
  private
    FPicture: TPicture;
    FPictureSource: TRMPictureSource;
    FBlobType: TRMBlobType;
    FPictureFormat: TRMPictureFormat;

    procedure OnPictureStretchedClick(Sender: TObject);
    procedure OnPictureCenterClick(Sender: TObject);
    procedure OnKeepAspectRatioClick(Sender: TObject);

    function GetPictureCenter: Boolean;
    procedure SetPictureCenter(const value: Boolean);
    function GetPictureRatio: Boolean;
    procedure SetPictureRatio(value: Boolean);
    function GetPictureStretched: Boolean;
    procedure SetPictureStretched(value: Boolean);
    function GetDirectDraw: Boolean;
    procedure SetDirectDraw(Value: Boolean);
  protected
    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
      Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean; override;

    procedure ClearContents; override;
    procedure PlaceOnEndPage(aStream: TStream); override;
    procedure GetBlob; override;
    function GetViewCommon: string; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure Draw(aCanvas: TCanvas); override;
    procedure ShowEditor; override;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;
  published
    property BlobType: TRMBlobType read FBlobType write FBlobType;
    property PictureFormat: TRMPictureFormat read FPictureFormat write FPictureFormat;
    property DataField;
    property Picture: TPicture read FPicture;
    property PictureCenter: Boolean read GetPictureCenter write SetPictureCenter;
    property PictureRatio: Boolean read GetPictureRatio write SetPictureRatio;
    property PictureStretched: Boolean read GetPictureStretched write SetPictureStretched;
    property Transparent;
    property DirectDraw: Boolean read GetDirectDraw write SetDirectDraw;
    property PictureSource: TRMPictureSource read FPictureSource write FPictureSource;
    property ReprintOnOverFlow;
    property ShiftWith;
    property BandAlign;
    property FillColor;
    property LeftFrame;
    property TopFrame;
    property RightFrame;
    property BottomFrame;
    property ExpressionDelimiters;
    property Url;
  end;

  { TRMShapeView }
  TRMShapeView = class(TRMReportView)
  private
    FShape: TRMShapeType;
    FPen: TPen;
    FBrush: TBrush;

    procedure DrawShape;
    procedure SetPen(Value: TPen);
    procedure SetBrush(Value: TBrush);
  protected
    function GetViewCommon: string; override;
  public
    class function CanPlaceOnGridView: Boolean; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure Draw(aCanvas: TCanvas); override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;
  published
    property Shape: TRMShapeType read FShape write FShape;
    property Pen: TPen read FPen write SetPen;
    property Brush: TBrush read FBrush write SetBrush;
    property ReprintOnOverFlow;
    property ShiftWith;
    property StretchWith;
    property FillColor;
    property LeftFrame;
    property TopFrame;
    property RightFrame;
    property BottomFrame;
    property Printable;
    property Url;
  end;

  { TRMOutlineView }
  TRMOutlineView = class(TRMReportView)
  private
    FCaption: string;
    FPageNo: Integer;
    FLevel: Integer;

    function GetOutlineText: string;
  protected
    procedure Prepare; override;
    procedure PlaceOnEndPage(aStream: TStream); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure Draw(aCanvas: TCanvas); override;

    property OutlineText: string read GetOutlineText;
  published
  end;

  { TRMSubReportView }
  TRMSubReportView = class(TRMReportView)
  private
    FSubPage: Integer;
    FSubReportType: TRMSubReportType;
    FCanPrint: Boolean;

    function GetPage: TRMReportPage;
    function GetReprintLastPage: Boolean;
    procedure SetReprintLastPage(Value: Boolean);
  protected
    procedure Prepare; override;
    function GetViewCommon: string; override;
  public
    class function CanPlaceOnGridView: Boolean; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;

    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure Draw(aCanvas: TCanvas); override;
    property SubPage: Integer read FSubPage write FSubPage;
    property Page: TRMReportPage read GetPage;
  published
    property SubReportType: TRMSubReportType read FSubReportType write FSubReportType;
    property ReprintLastPage: Boolean read GetReprintLastPage write SetReprintLastPage;
  end;

  { TRMCustomBandView }
  TRMCustomBandView = class(TRMReportView)
  private
    FFont: TFont;
    FBandType: TRMBandType;
    FIsVirtualDataSet: Boolean;
    FIsVirtualCrossDataSet: Boolean;
    FDataSetName: string;
    FCrossDataSetName: string;
    FLinesPerPage: Integer;
    FNewPageCondition: string;
    FRangeBegin: TRMRangeBegin;
    FRangeEnd: TRMRangeEnd;
    FRangeEndCount: Integer;
    FmmColumnGap: Integer;
    FColumns: Integer;
    FmmColumnWidth, FmmColumnOffset: Integer;
    FGroupCondition: string;
    FChildBandName: string;
    FOnAfterPrint: TNotifyEvent;
    FFlags1: LongWord;
    FMasterBand: string;
    FDataBandName: string;
    FOutlineText: string;

    procedure OnNewPageAfterClick(Sender: TObject);
    procedure OnPrintIfSubsetEmptyClick(Sender: TObject);
    procedure OnPageBreakedClick(Sender: TObject);
    procedure OnPrintOnFirstPageClick(Sender: TObject);
    procedure OnPrintOnLastPageClick(Sender: TObject);
    procedure OnReprintOnNewPageClick(Sender: TObject);
    procedure OnAutoAppendBlankClick(Sender: TObject);
    procedure OnStretchedClick(Sender: TObject);
    procedure OnKeepFooterClick(Sender: TObject);
    procedure OnKeepTogetherClick(Sender: TObject);
    procedure OnKeepChildClick(Sender: TObject);

    procedure SetCrossDataSetName(Value: string);
    procedure SetFont(Value: TFont);
    function GetPrintOnFirstPage: Boolean;
    procedure SetPrintOnFirstPage(Value: Boolean);
    function GetPrintOnLastPage: Boolean;
    procedure SetPrintOnLastPage(Value: Boolean);
    function GetPrintIfSubsetEmpty: Boolean;
    procedure SetPrintIfSubsetEmpty(Value: Boolean);
    function GetAutoAppendBlank: Boolean;
    procedure SetAutoAppendBlank(Value: Boolean);
    function GetNewPageAfter: Boolean;
    procedure SetNewPageAfter(Value: Boolean);
    function GetNewPageBefore: Boolean;
    procedure SetNewPageBefore(Value: Boolean);
    function GetPageBreaked: Boolean;
    procedure SetPageBreaked(Value: Boolean);
    function GetHideIfEmpty: Boolean;
    procedure SetHideIfEmpty(Value: Boolean);
    function GetReprintOnNewPage: Boolean;
    procedure SetReprintOnNewPage(Value: Boolean);
    function GetReprintOnNewColumn: Boolean;
    procedure SetReprintOnNewColumn(Value: Boolean);
    function GetKeepFooter: Boolean;
    procedure SetKeepFooter(Value: Boolean);
    function GetKeepTogether: Boolean;
    procedure SetKeepTogether(Value: Boolean);
    function GetKeepChild: Boolean;
    procedure SetKeepChild(Value: Boolean);
    function GetPrintatDesignPos: Boolean;
    procedure SetPrintatDesignPos(Value: Boolean);
    function GetspColumnGap(index: Integer): Integer;
    procedure SetspColumnGap(index: Integer; Value: Integer);
    function GetColumnGap(index: Integer): Double;
    procedure SetColumnGap(index: Integer; Value: Double);
    function GetPrintColumnFirst: Boolean;
    procedure SetPrintColumnFirst(Value: Boolean);
    function GetPrintBeforeSummaryBand: Boolean;
    procedure SetPrintBeforeSummaryBand(Value: Boolean);
    function GetPrintChildIfInvisible: Boolean;
    procedure SetPrintChildIfInvisible(Value: Boolean);
    procedure SetChildBandName(Value: string);
    function GetAdjustColumns: Boolean;
    procedure SetAdjustColumns(Value: Boolean);

    procedure SetGroupHeaderBandName(Value: string);
    procedure SetDataSetName(Value: string);
    procedure SetMasterBand(Value: string);
    procedure SetDataBandName(Value: string);
    procedure SetGroupCondition(Value: string);
    procedure SetOutlineText(Value: string);
    function GetAlignToBottom: Boolean;
    procedure SetAlignToBottom(Value: Boolean);
    function GetPrintIfEmpty: Boolean;
    procedure SetPrintIfEmpty(Value: Boolean);
    procedure SetNewPageCondition(Value: string);
    procedure SetRangeEndCount(Value: Integer);
  protected
    property AlignToBottom: Boolean read GetAlignToBottom write SetAlignToBottom;
    property PrintOnFirstPage: Boolean read GetPrintOnFirstPage write SetPrintOnFirstPage;
    property PrintOnLastPage: Boolean read GetPrintOnLastPage write SetPrintOnLastPage;
    property PrintIfSubsetEmpty: Boolean read GetPrintIfSubsetEmpty write SetPrintIfSubsetEmpty;
    property AutoAppendBlank: Boolean read GetAutoAppendBlank write SetAutoAppendBlank;
    property LinesPerPage: Integer read FLinesPerPage write FLinesPerPage;
    property NewPageCondition: string read FNewPageCondition write SetNewPageCondition;
    property NewPageAfter: Boolean read GetNewPageAfter write SetNewPageAfter;
    property NewPageBefore: Boolean read GetNewPageBefore write SetNewPageBefore;
    property PageBreaked: Boolean read GetPageBreaked write SetPageBreaked;
    property GroupHeaderBandName: string read FMasterBand write SetGroupHeaderBandName;
    property MasterBandName: string read FMasterBand write SetMasterBand; // GroupHeader Band 有的
    property DataBandName: string read FDataBandName write SetDataBandName;
    property HideIfEmpty: Boolean read GetHideIfEmpty write SetHideIfEmpty;
    property ReprintOnNewPage: Boolean read GetReprintOnNewPage write SetReprintOnNewPage;
    property ReprintOnEveryPage: Boolean read GetReprintOnNewPage write SetReprintOnNewPage;
    property ReprintOnNewColumn: Boolean read GetReprintOnNewColumn write SetReprintOnNewColumn;
    property KeepFooter: Boolean read GetKeepFooter write SetKeepFooter;
    property KeepTogether: Boolean read GetKeepTogether write SetKeepTogether;
    property KeepChild: Boolean read GetKeepChild write SetKeepChild;
    property PrintColumnFirst: Boolean read GetPrintColumnFirst write SetPrintColumnFirst;
    property Columns: Integer read FColumns write FColumns;
    property mmColumnGap: Integer read FmmColumnGap write FmmColumnGap;
    property mmColumnWidth: Integer read FmmColumnWidth write FmmColumnWidth;
    property mmColumnOffset: Integer read FmmColumnOffset write FmmColumnOffset;
    property spColumnGap: Integer index 0 read GetspColumnGap write SetspColumnGap;
    property spColumnWidth: Integer index 1 read GetspColumnGap write SetspColumnGap;
    property spColumnOffset: Integer index 2 read GetspColumnGap write SetspColumnGap;
    property ColumnGap: Double index 0 read GetColumnGap write SetColumnGap;
    property ColumnWidth: Double index 1 read GetColumnGap write SetColumnGap;
    property ColumnOffset: Double index 2 read GetColumnGap write SetColumnGap;
    property GroupCondition: string read FGroupCondition write SetGroupCondition;
    property PrintCondition: string read FGroupCondition write SetGroupCondition;
    property OutlineText: string read FOutlineText write SetOutlineText;
    property PrintAtDesignPos: Boolean read GetPrintatDesignPos write SetPrintatDesignPos;
    property DataSetName: string read FDataSetName write SetDataSetName;
    property RangeBegin: TRMRangeBegin read FRangeBegin write FRangeBegin;
    property RangeEnd: TRMRangeEnd read FRangeEnd write FRangeEnd;
    property RangeEndCount: integer read FRangeEndCount write SetRangeEndCount;
    property PrintBeforeSummaryBand: Boolean read GetPrintBeforeSummaryBand write SetPrintBeforeSummaryBand;
    property ChildBand: string read FChildBandName write SetChildBandName;
    property PrintChildIfInvisible: Boolean read GetPrintChildIfInvisible write SetPrintChildIfInvisible;
    property PrintIfEmpty: Boolean read GetPrintIfEmpty write SetPrintIfEmpty;
    property AdjustColumns: Boolean read GetAdjustColumns write SetAdjustColumns;
  public
    class function CanPlaceOnGridView: Boolean; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;

    function GetClipRgn(rt: TRMRgnType): HRGN; override;
    procedure Draw(aCanvas: TCanvas); override;
    property IsVirtualDataSet: Boolean read FIsVirtualDataSet;
    property BandType: TRMBandType read FBandType;
    property CrossDataSetName: string read FCrossDataSetName write SetCrossDataSetName;
  published
    property Font: TFont read FFont write SetFont;
    //    property ParentFont;
    property OnAfterPrint: TNotifyEvent read FOnAfterPrint write FOnAfterPrint;
  end;

  { TRMBand }
  TRMBand = class(TRMCustomBandView) // 打印时用的
  private
    FPositions: array[TRMDatasetPosition] of Integer;
    FLastGroupValue: Variant;
    FVirtualCrossDataSet: TRMDataSet;
    FSaveRangeBegin: TRMRangeBegin;
    FSaveRangeEnd: TRMRangeEnd;
    FSaveRangeEndCount: Integer;
    FCurrentColumn: Integer;
    FNowLine: LongInt;
    FLevel: Integer;
    FFirstPage: Boolean;
    FPageBreakFlag: Boolean;
    FLastPageNo: Integer;

    FAggrCount: Integer;
    FAggrValues: TRMVariables;

    FNowGroupBand: TRMBand;
    FAggrBand: TRMBand;
    FDisableBandScript: Boolean;
    FBandChild: TRMBand;
    FNextGroup, FPrevGroup: TRMBand;
    FFirstGroup, FLastGroup: TRMBand;
    FHeaderBand, FFooterBand, FDataBand, FLastBand: TRMBand;
    FMasterDataBand: TRMBand;
    FCalculatedHeight: Integer;
    FNeedChangeHeight, FNeedUnStretchObjects: Boolean;
    FmmColumnXAdjust: Integer;
    FSaveXAdjust, FSaveLastY, FSaveTop, FSaveMaxY: Integer;
    FMaxColumns: Integer;
    FMaxY: Integer;
    FObjects: TList;
    FSubReports: TList;
    FKeepPage_FirstTime: Boolean;
    FNeedDecKeepPageCount: Boolean;
    //    FCallNewPage, FCallNewColumn: Integer;

    procedure MakeOutlineText;
    procedure DrawRepeatHeader(aNewColumn: Boolean);
    procedure DoAggregate;
    procedure InitValues;
    procedure StretchObjects;
    procedure UnStretchObjects;
    function CalcBandHeight: Integer;
    function CalcChildBandHeight: Integer;
    function CheckSpace(aTop, aHeight: Integer; aAddColumn: Boolean): Boolean;
    procedure MakeSpace;
    procedure MakeColumns;
    procedure PrintObject(t: TRMReportView);
    function PrintObjects(aDrawPageBreaked: Boolean): Boolean;
    function PrintSubReports: Boolean;
    procedure PrintCrossCell(aParentBand: TRMBand; aCurrentX: Integer);
    procedure PrintCross;
    function HasCross: Boolean;

    procedure PrintPageBreak(aNeedNewPage: Boolean);
    procedure DoPrint;
    function Print: Boolean;
    procedure AddAggregateValue(const aStr: string; aValue: Variant);
    function GetAggregateValue(const aStr: string): Variant;
  protected
    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant; Args: array of Variant): Boolean; override;

    procedure Prepare; override;
    procedure UnPrepare; override;
    property DataSet: TRMDataSet read FDataSet;
  public
    constructor Create; override;
    destructor Destroy; override;

    property Objects: TList read FObjects;
    property AggrValues: TRMVariables read FAggrValues;
  end;

  TRMBandReportTitle = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property HideIfEmpty;
    //    property NewPageAfter;
    property Stretched;
    property PageBreaked;
    property ChildBand;
    property KeepChild;
    property PrintChildIfInvisible;
    property OutlineText;
  end;

  TRMBandReportSummary = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property HideIfEmpty;
    //    property NewPageAfter;
    property Stretched;
    //property PageBreaked;
    property ChildBand;
    property KeepChild;
    property PrintChildIfInvisible;
    property AlignToBottom;
    property OutlineText;
  end;

  TRMBandPageHeader = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property HideIfEmpty;
    //    property NewPageAfter;
    property Stretched;
    property PageBreaked;
    property PrintOnFirstPage;
    property PrintOnLastPage;
    //property ChildBand;
    property PrintChildIfInvisible;
    property OutlineText;
  end;

  TRMBandPageFooter = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property HideIfEmpty;
    property PrintOnFirstPage;
    property PrintOnLastPage;
    property PrintChildIfInvisible;
    property OutlineText;
  end;

  TRMBandColumnHeader = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property HideIfEmpty;
    //    property NewPageAfter;
    property Stretched;
    property PageBreaked;
    property ReprintOnNewColumn;
    //property ChildBand;
    property PrintChildIfInvisible;
    property OutlineText;
  end;

  TRMBandColumnFooter = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property HideIfEmpty;
    property PrintBeforeSummaryBand;
    //property ChildBand;
    property PrintChildIfInvisible;
    property OutlineText;
  end;

  TRMBandHeader = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property HideIfEmpty;
    //		property NewPageBefore;
    property NewPageAfter;
    property Stretched;
    property PageBreaked;
    property ReprintOnNewPage;
    property ReprintOnNewColumn;
    property ChildBand;
    property KeepChild;
    property PrintChildIfInvisible;
    property DataBandName;
    property OutlineText;
  end;

  TRMBandFooter = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property HideIfEmpty;
    //		property NewPageBefore;
    property NewPageAfter;
    property Stretched;
    property PageBreaked;
    //    property ReprintOnEveryPage;
    property ChildBand;
    property KeepChild;
    property PrintChildIfInvisible;
    property DataBandName;
    property OutlineText;
  end;

  TRMBandMasterData = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property PrintCondition;
    property HideIfEmpty;
    //		property NewPageBefore;
    property NewPageAfter;
    property Stretched;
    property PageBreaked;
    property ColumnGap;
    property Columns;
    property ColumnWidth;
    property ColumnOffset;
    property DataSetName;
    property PrintIfSubsetEmpty;
    property PrintColumnFirst;
//    property PrintAtDesignPos;
    property LinesPerPage;
    property AutoAppendBlank;
    property RangeBegin;
    property RangeEnd;
    property RangeEndCount;
    property PrintChildIfInvisible;
    property PrintIfEmpty;
    property NewPageCondition;
    property OutlineText;
    property AdjustColumns;

    property ChildBand;
    property KeepChild;
    property KeepFooter;
    property KeepTogether;
  end;

  TRMBandDetailData = class(TRMBandMasterData)
  private
  protected
  public
    constructor Create; override;
  published
    property MasterBandName;
  end;

  {@TRMBandGroupHeader.BreakNo

    This property indicates the number of times a group break has occurred.  If
    the group never breaks during the course of report generation, the BreakNo
    will be 0.

  @TRMBandGroupHeader.ResetPageNo

    Use ResetPageNo to enable subset page numbering.

    ResetPageNo is only available when a report group has the NewPage property
    set to True.

  @TRMBandGroupHeader.HeaderForOrphanedFooter

    Defaults to True. When the group footer is orphaned (prints alone at the top
    of a page with no preceding detail bands) then this property determines
    whether the group header will be printed.

  @TRMBandGroupHeader.KeepTogether

    Defaults to True. This property indicates whether groups can break across
    pages. If the group cannot fit on the remaining space of a page, the group
    will advance to the next page and print there.  If the group advances to the
    next page and still will not fit, then the group will break across pages
    starting at the new page.}

  TRMBandGroupHeader = class(TRMBand)
  private
  protected
  public
    constructor Create; override;

    //property BreakNo: Integer;
  published
    property HideIfEmpty;
    //		property NewPageBefore;
    property NewPageAfter;
    property Stretched;
    property PageBreaked;
    property GroupCondition;
    property ReprintOnNewPage;
    property ReprintOnNewColumn;
    property MasterBandName;
    property PrintChildIfInvisible;

    property OutlineText;
    property ChildBand;
    property KeepChild;
    property KeepTogether;
    property KeepFooter;
    //    property ResetPageNo;
  end;

  TRMBandGroupFooter = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    //		property NewPageBefore;
    property NewPageAfter;
    property HideIfEmpty;
    property Stretched;
    property PageBreaked;
    //    property ReprintOnEveryPage;
    property PrintChildIfInvisible;
    property GroupHeaderBandName;

    property ChildBand;
    property KeepChild;
    property OutlineText;
  end;

  TRMBandCrossHeader = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property ReprintOnNewPage;
    property Stretched;
    property PrintAtDesignPos;
  end;

  TRMBandCrossData = class(TRMBand)
  private
    FDataSource: string;
  protected
  public
    constructor Create; override;
  published
    property DataSource: string read FDataSource write FDataSource;
    property PrintAtDesignPos;
    property AutoAppendBlank;
    property ColumnGap;
    property Columns;
  end;

  TRMBandCrossFooter = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    property PrintAtDesignPos;
  end;

  TRMBandOverlay = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    //property ChildBand;
    //property KeepChild;
    property PrintChildIfInvisible;
  end;

  TRMBandChild = class(TRMBand)
  private
  protected
  public
    constructor Create; override;
  published
    //		property NewPageBefore;
    property NewPageAfter;
    property PrintChildIfInvisible;

    property ChildBand;
    property KeepChild;
    property OutlineText;
  end;

  { TRMCustomPage }
  TRMCustomPage = class(TRMPersistent)
  private
    FPrintToPrevPage: Boolean;
    FParentReport: TRMReport;
    FVisible: Boolean;
    FObjects: TList;
    FFont: TFont;
    FOutlineText: string;
    FOnActivate: TNotifyEvent;
    FOnBeginPage: TRMBeginPageEvent;
    FOnEndPage: TRMEndPageEvent;

    // 生成报表时需要的参数
    FEventList: TList;
    FAggrList: TList;
    FParentPage: TRMReportPage;
    FPageNumber: Integer;
    FIsSubReportPage: Boolean;
    FPrintChildTypeSubReportPage: Boolean;
    FSubReportView: TRMSubReportView;
    FSubReport_MMLeft, FSubReport_MMTop: Integer;
    FColumnPos, FCurrentPos: Integer;
    FmmCurrentX, FmmCurrentY, FmmCurrentX1: Integer;
    FmmCurrentBottomY, FmmLastStaticColumnY: Integer;
    FmmOffsetX, FmmOffsetY: Integer; // 打印时用到的,就是边距信息
    FLastPrintBand: TRMBand;
    FDrawRepeatHeader, FDisableRepeatHeader: Boolean;
    FCurPageColumn: Integer;
    FStartPageNo: Integer;

    procedure AfterPrint;

    function GetItems(Index: string): TRMView;
    procedure SetFont(Value: TFont);
    procedure SetOutlineText(Value: string);
  protected
    FChildPageNo: Integer;
    FChildPageBegin: Integer;
    FChildEndPages: TRMEndPages;
    FCurrentEndPages: TRMEndPages;

    function DocMode: TRMDocMode;
    procedure SetName(const Value: string); override;
    procedure SetObjectsEvent;
    procedure AddChildView(aStringList: TStringList; aDontAddBlankNameObject: Boolean); virtual;
    procedure BuildTmpObjects; virtual;
    procedure PreparePage; virtual; abstract;
    procedure UnPreparePage; virtual; abstract;
    procedure LoadFromStream(aStream: TStream); virtual; abstract;
    procedure SaveToStream(aStream: TStream); virtual; abstract;
    function GetPrinter: TRMPrinter;
    procedure Loaded; virtual;
    procedure BeforeDeleteObject(aObject: TRMView); virtual;

    property PrintToPrevPage: Boolean read FPrintToPrevPage write FPrintToPrevPage;
    property IsSubReportPage: Boolean read FIsSubReportPage;
    property mmCurrentY: Integer read FmmCurrentY;
    property mmCurrentBottomY: Integer read FmmCurrentBottomY;
    property OutlineText: string read FOutlineText write SetOutlineText;
    property OnBeginPage: TRMBeginPageEvent read FOnBeginPage write FOnBeginPage;
    property OnEndPage: TRMEndPageEvent read FOnEndPage write FOnEndPage;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    procedure CreateName;
    procedure Delete(Index: Integer);
    function IndexOf(aObjectName: string): Integer;
    function FindObject(aObjectName: string): TRMView; virtual;
    function UpdateBandsPageRect: Boolean; virtual; abstract;
    function PageObjects: TList; virtual;
    function EventList: TList;
    function Count: Integer;

    property Items[Index: string]: TRMView read GetItems; default;
    property Objects: TList read FObjects;
    property ParentReport: TRMReport read FParentReport;
  published
    property Visible: Boolean read FVisible write FVisible;
    property Font: TFont read FFont write SetFont;
    property Name;
  end;

  { TRMDialogPage }
  TRMDialogPage = class(TRMCustomPage)
  private
    FBorderStyle: TFormBorderStyle;
    FCaption: string;
    FColor: TColor;
    FLeft, FTop, FWidth, FHeight: Integer;
    FPosition: TPosition;
    FForm: TForm;
  protected
    procedure PreparePage; override;
    procedure UnPreparePage; override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;

    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant; Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean; override;
  public
    constructor CreatePage(aParentReport: TRMReport);
    destructor Destroy; override;
    function UpdateBandsPageRect: Boolean; override;

    property Form: TForm read FForm;
  published
    property BorderStyle: TFormBorderStyle read FBorderStyle write FBorderStyle;
    property Caption: string read FCaption write FCaption;
    property Color: TColor read FColor write FColor;
    property Left: Integer read FLeft write FLeft;
    property Top: Integer read FTop write FTop;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Position: TPosition read FPosition write FPosition;

    property OnActivate;
  end;

  { TRMReportPage }
  TRMReportPage = class(TRMCustomPage)
  private
    FPageWidth, FPageHeight: Longint;
    FPageSize: Integer;
    FPageOrientation: TRMPrinterOrientation;
    FPageBin: Integer;
    FDuplex: TRMDuplex;
    FResetPageNo: Boolean;
    FNewPrintJob: Boolean;
    FmmbkPictureLeft, FmmbkPictureTop: Integer;
    FmmMarginLeft, FmmMarginTop, FmmMarginRight, FmmMarginBottom: Integer;
    FAutoHCenter, FAutoVCenter: Boolean;
    FFlags: Word;
    FColumnCount: Integer;
    FmmColumnGap: Integer;

    // 保持在同一页用到的信息
    FKeepPage_Count: Integer;
    //    FKeepPage_EndPage: TRMEndPage;
    FKeepPage_SaveStream: TMemoryStream;
    FKeepPage_Stream: TMemoryStream;
    FKeepPage_SavePos: Int64;
    FKeepPage_OffsetLeft: Integer;
    FKeepPage_OffsetTop: Integer;
    FKeepPage_OutLines: TStringList;

    // 打印是用到的临时变量
    FSubReports: TList;
    FParentPages: TList;
    FBands: array[TRMBandType] of TList;
    FShowBackPicture: Boolean;
    FMaxLevel: Integer;
    FFlag_NewPage, FFlag_ColumnNewPage: Boolean;
    FSavePageNo: Integer;
    FInDrawPageHeader: Boolean; // 正在打印PageHeader
    FmmColumnWidth: Integer;
    FBaseOutlineLevel, FNowOutlineLevel: Integer;

    procedure SetmmMarginLeft(aValue: Integer);
    procedure SetmmMarginTop(aValue: Integer);
    function GetspMarginLeft(index: Integer): Integer;
    procedure SetspMarginLeft(index: Integer; value: Integer);
    function GetpgMargins: TRect;
    procedure SetpgMargins(aValue: TRect);
    procedure SetColumnCount(Value: Integer);
    function GetColumnGap: Double;
    procedure SetColumnGap(Value: Double);

    function GetCurrentRightX: Integer;
    function GetCurrentBottomY: Integer;
    function BandByType(aType: TRMBandType): TRMBand;
    procedure ShowBand(aBand: TRMBand);

    procedure ResetPosition(aBand: TRMBand; aResetTo: Integer);
    procedure PlaceObjects;
    procedure PrepareObjects;
    procedure PrepareAggrObjects; //计算字段

    // SubReport相关
    procedure CreateChildReport;
    procedure FreeChildReport;
    procedure PrintChildTypeSubReports;
    function HaveChildEndPage(aPageIndex: Integer): Boolean;
    procedure TransferChildTypeSubReportViews(aPageIndex: Integer; aEndPage: TRMEndPage;
      aEndPages: TRMEndPages);

    procedure DoPrintPage(aMasterBand: TRMBand; aBandType: TRMBandType;
      aNowLevel: Integer; var aBndStackTop: Integer; var aBndStack: array of TRMBand);
    procedure PrintPage;

    procedure InitKeepPageInfo;
    procedure FreeKeepPageInfo;
    procedure AddKeepPageBand(aEndBand: TRMBand);
    procedure DeleteKeepPageBand(aEndBand: TRMBand);
    procedure TransferToCachePage;
    procedure TransferFromCachePage(aNewPage: Boolean);

    procedure DrawColumnFooter(aLastPageFlag: Boolean);
    procedure DrawPageFooters(aLastPageFlag: Boolean);
    procedure DoDetailHeaderAggrs(aBand: TRMBand);
    procedure DoGroupHeaderAggrs(aGroupHeader: TRMBand);
    procedure AutoCenterObjects(aPageNo: Integer);

    function GetbkGroundLeft(index: Integer): Double;
    procedure SetbkGroundLeft(index: Integer; Value: Double);
    procedure SetbkPicture(aPicture: TPicture);
  protected
    FbkPicture: TPicture;

    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
      Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string;
      aValue: Variant): Boolean; override;

    procedure PreparePage; override;
    procedure UnPreparePage; override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
  public
    PrinterInfo: TRMPageInfo;
    bkPictureWidth, bkPictureHeight: Integer;

    constructor CreatePage(aParentReport: TRMReport; aSize, aWidth, aHeight, aBin: Integer; aOr: TRMPrinterOrientation); virtual;
    destructor Destroy; override;

    function UpdateBandsPageRect: Boolean; override;
    procedure NewColumn(aBand: TRMBand);
    procedure NewPage;
    procedure ShowBandByName(const aBandName: string);
    procedure ShowBandByType(aBandType: TRMBandType);
    procedure ChangePaper(ASize, AWidth, AHeight, ABin: Integer; AOr: TRMPrinterOrientation);

    property PageWidth: Longint read FPageWidth;
    property PageHeight: Longint read FPageHeight;
    property PageSize: Integer read FPageSize;
    property PageOrientation: TRMPrinterOrientation read FPageOrientation;
    property PageBin: Integer read FPageBin;
    property PageMargins: TRect read GetpgMargins write SetpgMargins;
    property Flag_NewPage: Boolean read FFlag_NewPage;
    property Flag_ColumnNewPage: Boolean read FFlag_ColumnNewPage;

    property mmMarginLeft: Integer read FmmMarginLeft write SetmmMarginLeft;
    property mmMarginTop: Integer read FmmMarginTop write SetmmMarginTop;
    property mmMarginRight: Integer read FmmMarginRight write FmmMarginRight;
    property mmMarginBottom: Integer read FmmMarginBottom write FmmMarginBottom;
    property spMarginLeft: Integer index 0 read GetspMarginLeft write SetspMarginLeft;
    property spMarginTop: Integer index 1 read GetspMarginLeft write SetspMarginLeft;
    property spMarginRight: Integer index 2 read GetspMarginLeft write SetspMarginLeft;
    property spMarginBottom: Integer index 3 read GetspMarginLeft write SetspMarginLeft;
    property spBackGroundLeft: Integer index 4 read GetspMarginLeft write SetspMarginLeft;
    property spBackGroundTop: Integer index 5 read GetspMarginLeft write SetspMarginLeft;

    property spColumnGap: Integer index 6 read GetspMarginLeft write SetspMarginLeft;
    property mmColumnGap: Integer read FmmColumnGap write FmmColumnGap;
  published
    property Duplex: TRMDuplex read FDuplex write FDuplex;
    property PrintToPrevPage;
    property ShowBackPicture: Boolean read FShowBackPicture write FShowBackPicture;
    property ResetPageNo: Boolean read FResetPageNo write FResetPageNo;
    property NewPrintJob: Boolean read FNewPrintJob write FNewPrintJob;

    property BackPictureLeft: Double index 0 read GetbkGroundLeft write SetbkGroundLeft;
    property BackPictureTop: Double index 1 read GetbkGroundLeft write SetbkGroundLeft;
    property BackPicture: TPicture read FbkPicture write SetbkPicture;

    property AutoHCenter: Boolean read FAutoHCenter write FAutoHCenter;
    property AutoVCenter: Boolean read FAutoVCenter write FAutoVCenter;
    property ColumnCount: Integer read FColumnCount write SetColumnCount;
    property ColumnGap: Double read GetColumnGap write SetColumnGap;
    property OutlineText;

    property OnActivate;
    property OnBeginPage;
    property OnEndPage;
  end;

  { TRMPages }
  TRMPages = class(TObject)
  private
    FParentReport: TRMReport;
    function GetCount: Integer;
    function GetPages(Index: Integer): TRMCustomPage;
  protected
    FPages: TList;
  public
    constructor Create(aParentReport: TRMReport);
    destructor Destroy; override;
    procedure Clear;
    function AddReportPage: TRMReportPage;
    function AddDialogPage: TRMDialogPage;
    procedure Delete(Index: Integer);
    procedure Move(OldIndex, NewIndex: Integer);
    procedure LoadFromStream(aVersion: Integer; aStream: TStream);
    procedure SaveToStream(aStream: TStream);

    property PagesList: TList read FPages;
    property Pages[Index: Integer]: TRMCustomPage read GetPages; default;
    property Count: Integer read GetCount;
  end;

  { TRMBkPicture }
  TRMBkPicture = class(TObject)
  private
    FLeft, FTop: Integer;
    FWidth, FHeight: Integer;
    FPicture: TPicture;
  public
    constructor Create(aLeft, aTop, aWidth, aHeight: Integer; aPic: TPicture);
    destructor Destroy; override;

    property Left: Integer read FLeft;
    property Top: Integer read FTop;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property Picture: TPicture read FPicture;
  end;

  { TRMSaveReportOptions }
  TRMSaveReportOptions = class(TPersistent)
  private
    FAutoLoadSaveSetting: Boolean;
    FUseRegistry: Boolean;
    FIniFileName: string;
    FRegistryPath: string;
    FParentReport: TRMReport;
  protected
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure LoadReportSetting(aReport: TRMReport; aReportName: string);
    procedure SaveReportSetting(aReport: TRMReport; aReportName: string);
  published
    property AutoLoadSaveSetting: Boolean read FAutoLoadSaveSetting write FAutoLoadSaveSetting default False;
    property UseRegistry: Boolean read FUseRegistry write FUseRegistry default True;
    property IniFileName: string read FIniFileName write FIniFileName;
    property RegistryPath: string read FRegistryPath write FRegistryPath;
  end;

  TRMFieldFieldNames = class(TPersistent)
  private
    FTableName: string;
    FFieldName: string;
    FFieldAlias: string;
    FDataSet: TDataSet;
  protected
  public
    constructor Create;
  published
    property TableName: string read FTableName write FTableName;
    property FieldName: string read FFieldName write FFieldName;
    property FieldAlias: string read FFieldAlias write FFieldAlias;
    property DataSet: TDataSet read FDataSet write FDataSet;
  end;

  { TRMDataDictionary }
  TRMDataDictionary = class(TComponent)
  private
    FFieldFieldNames: TRMFieldFieldNames;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetRealFieldName(const aKey, aFieldName: string; var RealName: string): Boolean;
    procedure GetVirtualFieldsName(const aKey: string; aList: TStrings);
  published
    property FieldFieldNames: TRMFieldFieldNames read FFieldFieldNames write FFieldFieldNames;
  end;

  { TRMDictionary }
  TRMDictionary = class(TObject)
  private
    FCache: TStringList;
    FExprCache: TStringList;
    FParentReport: TRMReport;
    FVariables: TRMVariables;
    FFieldAliases: TRMVariables;
    FDisabledDatasets: TStringList;

    procedure ExtractFieldName(const aComplexName: string; var aDataSetName, aFieldName: string);
    procedure LoadFromStream_1(aStream: TStream);

    procedure ClearCache;
    procedure AddCacheItem(const Index: string; aDataSet: TRMDataSet; const aDataField: string);
    procedure AddExprCacheItem(const Index: string; const aExpr: string);

    function FieldIsNull(const aVariableName: string): Boolean;
    function GetValue(const aVariableName: string): Variant;
    function GetRealDataSetName(const aDataSet: string): string;
    function GetRealFieldName(const aFieldName: string): string;
  protected
    function DatasetEnabled(const aDatasetName: string): Boolean;
    function OPZExpr(const aVariableName: string): Variant;
    procedure Pack1(var aFieldAlias: TRMVariables);
  public
    constructor Create(aParentReport: TRMReport);
    destructor Destroy; override;
    procedure Clear;
    procedure Pack;

    function IsVariable(const aVariableName: string): Boolean;
    function IsExpr(const aVariableName: string): Boolean;

    procedure GetCategoryList(List: TStrings);
    procedure GetVariablesList(const Category: string; List: TStrings);
    procedure GetDataSets(aList: TStrings); overload;
    procedure GetDataSets(aList: TStrings; aFieldAlias: TRMVariables); overload;
    procedure GetDataSetFields(aDataSet: string; aList: TStrings); overload;
    procedure GetDataSetFields(aDataSet: string; aList: TStrings;
      aFieldAlias: TRMVariables); overload;

    procedure SaveToBlobField(aBlobField: TBlobField);
    procedure LoadFromBlobField(aBlobField: TBlobField);
    procedure LoadFromStream(aStream: TStream);
    procedure SaveToStream(aStream: TStream);
    procedure LoadFromFile(aFileName: string);
    procedure SaveToFile(aFileName: string);
    procedure MergeFromFile(aFileName: string);
    procedure MergeFromStream(aStream: TStream);
    procedure AddDataSet(aDataSet: TDataSet; aDisplayName: string);
    procedure AddField(aField: TField; aDisplayName: string);

    property Variables: TRMVariables read FVariables;
    property FieldAliases: TRMVariables read FFieldAliases;
    property Value[const Index: string]: Variant read GetValue;
    property RealDataSetName[const Index: string]: string read GetRealDataSetName;
    property RealFieldName[const Index: string]: string read GetRealFieldName;
    property DisabledDatasets: TStringList read FDisabledDatasets;
  end;

  { TRMEndPage }
  TRMEndPage = class(TObject)
  private
    FPageWidth, FPageHeight: Integer;
    FPageRect: TRect;
    FPageSize: Word;
    FPageOrientation: TRMPrinterOrientation; //纸：横放，竖放
    FPageBin: integer;
    FVisible: Boolean;
    FEndPageStream: TMemoryStream;
    FDuplex: TRMDuplex;
    FbkPictureIndex: Byte;
    FNewPrintJob: Boolean;
    FPageNumber: Byte;
    FmmMarginLeft, FmmMarginTop, FmmMarginRight, FmmMarginBottom: Integer;
    FCompressThread: TThread;
    FThreadDone: Boolean;
    FCompressOutStream: TMemoryStream;
    FStreamCompressed: Boolean;

    FParentEndPages: TRMEndPages;

    procedure AssignFromReportPage(aPage: TRMReportPage; aPictureCount: Integer);
    procedure AssignFromEndPage(aPage: TRMEndPage; aPictureCount: Integer);
    procedure ExportPage(aReport: TRMReport);
    function GetspMarginLeft(aIndex: Integer): Integer;
    procedure SetspMarginLeft(aIndex: Integer; Value: Integer);

    procedure AfterEndPage;
    procedure ThreadTerminate(Sender: TObject);
  protected
    FPage: TRMReportPage;
  public
    PrinterInfo: TRMPageInfo;

    constructor Create(aParentEndPages: TRMEndPages);
    destructor Destroy; override;

    procedure StreamToObjects(aParentReport: TRMReport; aIsPreview: Boolean);
    procedure ObjectsToStream(aParentReport: TRMReport);
    procedure RemoveCachePage;
    procedure Draw(aReport: TRMReport; aCanvas: TCanvas; aDrawRect: TRect);

    property PageRect: TRect read FPageRect write FPageRect;
    property PageSize: Word read FPageSize;
    property PageOrientation: TRMPrinterOrientation read FPageOrientation write FPageOrientation;
    property PageBin: integer read FPageBin write FPageBin;
    property Visible: Boolean read FVisible write FVisible;
    property Duplex: TRMDuplex read FDuplex write FDuplex;
    property EndPageStream: TMemoryStream read FEndPageStream;
    property Page: TRMReportPage read FPage;
    property bkPictureIndex: Byte read FbkPictureIndex;
    property PageNumber: Byte read FPageNumber;
    property mmMarginLeft: Integer read FmmMarginLeft write FmmMarginLeft;
    property mmMarginTop: Integer read FmmMarginTop write FmmMarginTop;
    property mmMarginRight: Integer read FmmMarginRight write FmmMarginRight;
    property mmMarginBottom: Integer read FmmMarginBottom write FmmMarginBottom;
    property spMarginLeft: Integer index 0 read GetspMarginLeft write SetspMarginLeft;
    property spMarginTop: Integer index 1 read GetspMarginLeft write SetspMarginLeft;
    property spMarginRight: Integer index 2 read GetspMarginLeft write SetspMarginLeft;
    property spMarginBottom: Integer index 3 read GetspMarginLeft write SetspMarginLeft;
    property PageWidth: Integer read FPageWidth;
    property PageHeight: Integer read FPageHeight;
  published
  end;

  { TRMEndPages }
  TRMEndPages = class(TObject)
  private
    FCurPageNo: Integer; //by waw
    FPages: TList;
    FbkPictures: TList;
    FOnClearEvent: TNotifyEvent;
    FParentReport: TRMReport;
    FOutLines: TStringList;

    FStreamCompressed: Boolean; // 流是否是压缩存储的
    FStreamCompressType: Byte; // 压缩方法，目前只支持zlib压缩

    function GetParentReportCompressStream: Boolean;
    function GetParentReportCompressType: Byte;
    function GetPages(Index: Integer): TRMEndPage;
    function GetCount: Integer;
    procedure AddbkPicture(aLeft, aTop, aWidth, aHeight: Integer; aPicture: TPicture);
    function GetbkPicture(Index: Integer): TRMBkPicture;
    procedure _LoadFromStream(aStream: TStream);
  protected
    property OnClearEvent: TNotifyEvent read FOnClearEvent write FOnClearEvent;
    property ParentReportCompressStream: Boolean read GetParentReportCompressStream;
    property ParentReportCompressType: Byte read GetParentReportCompressType;
  public
    constructor Create(aParentReport: TRMReport);
    destructor Destroy; override;

    procedure Clear;
    procedure Insert(aPageIndex: Integer; aPage: TRMReportPage);
    procedure InsertFromEndPage(aPageIndex: Integer; aEndPage: TRMEndPage);
    procedure Add(aPage: TRMReportPage);
    procedure Delete(aPageIndex: Integer);

    procedure AppendFromStream(aStream: TStream);
    procedure LoadFromStream(aStream: TStream);
    procedure SaveToStream(aStream: TStream);

    property Pages[Index: Integer]: TRMEndPage read GetPages; default;
    property Count: Integer read GetCount;
    property CurPageNo: Integer read FCurPageNo write FCurPageNo; //by waw
    property bkPictures[Index: Integer]: TRMbkPicture read GetbkPicture;
    property OutLines: TStringList read FOutLines;
  published
  end;

  { TRMExportFilter }
  TRMExportFilter = class(TRMCustomExportFilter)
  private
    FShowDialog: Boolean;
    FParentReport: TRMReport;
    FPagecount: integer;
    FOnBeforeExport: TRMBeforeExportEvent;
    FOnAfterExport: TRMAfterExportEvent;
  protected
    FIsXLSExport: Boolean;
    FileName: string;
    Stream: TStream;
    CreateFile: Boolean;
  protected
    procedure OnBeginDoc; virtual;
    procedure OnEndDoc; virtual;
    procedure OnBeginPage; virtual;
    procedure OnEndPage; virtual;
    procedure OnExportPage(const aPage: TRMEndPage); virtual;
    procedure OnText(DrawRect: TRect; x, y: Integer; const text: string; View: TRMView); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowModal: Word; virtual;

    property IsXLSExport: Boolean read FIsXLSExport;
    property ParentReport: TRMReport read FParentReport;
    property Pagecount: integer read FPagecount write FPagecount; //szc;
  published
    property ShowDialog: Boolean read FShowDialog write FShowDialog default True;
    property OnBeforeExport: TRMBeforeExportEvent read FOnBeforeExport write FOnBeforeExport;
    property OnAfterExport: TRMAfterExportEvent read FOnAfterExport write FOnAfterExport;
  end;

  { TRMReport }
  TRMReport = class(TRMCustomReport)
  private
    FDFMStream: TMemoryStream;
    FParser: TRMParser;
    FDataDictionary: TRMDataDictionary;
    FDictionary: TRMDictionary;
    FVariables: TRMVariables;
    FPrinter: TRMPrinter;
    FPrinterName: string;
    FCanRebuild: Boolean;
    FDoublePass: Boolean;
    FFinalPass: Boolean;
    FPages: TRMPages;
    FEndPages: TRMEndPages;
    FModifyPrepared: Boolean;
    FInitialZoom: TRMPreviewZoom;
    FPreviewButtons: TRMPreviewButtons;
    FModalPreview: Boolean;
    FMDIPreview: Boolean;
    FFileName: string;
    FPreviewInitialDir: string;
    FDefaultCopies: Integer;
    FDefaultCollate: Boolean;
    FShowPrintDialog: Boolean;
    FPrintbackgroundPicture: Boolean;
    FmmPrintOffsetLeft, FmmPrintOffsetTop: Integer;
    FColorPrint: Boolean;
    FPageCompositeMode: TRMCompositeMode;
    FModified, FComponentModified: Boolean;
    FShowProgress: Boolean;
    FProgressForm: TRMProgressForm;
    FCurrentFilter: TRMExportFilter;
    FPreview: TRMCustomPreview;
    FPreviewOptions: TRMPreviewOptions;
    FDataset: TRMDataset;
    FStoreInDFM: Boolean;
    FReportType: TRMReportType;
    FReportFlags: Word;
    FStatus: TRMReportStatus;
    FBusy: Boolean;
    FConvertNulls: Boolean;

    FCompressType: Byte; // 压缩方法，目前只支持zlib压缩
    FCompressLevel: TRMCompressionLevel;
    FCompressThread: Boolean;

    // 全局变量
    FCurrentDate, FCurrentTime, FCurrentDateTime: TDateTime;
    FFlag_TableEmpty, FFlag_TableEmpty1: Boolean;
    FCompositeMode: Boolean;
    FTotalPages: Integer; // 报表总页数
    FPageNo: Integer; // 当前页毫
    FDontShowReport: Boolean; // 中止报表
    FmmPrevY, FmmPrevBottomY {, FColumnXAdjust}: Integer;
    FAppendFlag, FWasPF: Boolean;
    FScript: TStrings;
    FNeedAddBreakedVariable: Boolean;

    // 私有变量
    FDocMode: TRMDocMode;
    FCurrentPage: TRMCustomPage;
    FCurrentView: TRMView; // currently proceeded view
    FCurrentBand: TRMBand;
    FRMAggrBand: TRMBand; // used for aggregate functions
    FHookList: TList;
    FCurrentVariable: string;
    FCurrentValue: Variant; // used for highlighting
    FTmpBMP: TBitmap;
    FSaveDesignerAutoSave: Boolean;
    FShowErrorMsg: Boolean;
    FMasterReport: TRMReport;
    FPrintAtFirstTime: Boolean;

    FOnReadOneEndPage: TRMReadOneEndPageEvent;
    FOnAfterPreviewPageSetup: TNotifyEvent;
    FSaveReportOptions: TRMSaveReportOptions;
    FOnLoadReportSetting: TRMLoadSaveReportSettingEvent;
    FOnSaveReportSetting: TRMLoadSaveReportSettingEvent;
    FOnBeginPage: TRMBeginPageEvent;
    FOnEndPage: TRMEndPageEvent;
    FOnPrintReportEvent: TNotifyEvent;
    FOnBeginBand: TRMBeginBandEvent;
    FOnEndBand: TRMEndBandEvent;
    FOnManualBuild: TRMManualBuildEvent;
    FOnBeginReport: TNotifyEvent;
    FOnEndReport: TNotifyEvent;
    FOnBeginDoc: TNotifyEvent;
    FOnEndDoc: TNotifyEvent;
    FOnProgress: TRMProgressEvent;
    FOnUserFunction: TRMFunctionEvent;
    FOnGetValue: TRMGetValueEvent;
    FOnBeforePrint: TRMOnBeforePrintEvent;
    FOnAfterPrint: TRMAfterPrintEvent;
    FOnPrintColumn: TRMPrintColumnEvent;
    FOnBeginColumn: TRMBeginColumnEvent;
    FOnBeforePrintBand: TRMBeforePrintBandEvent;
    FOnEndPrintPage: TRMEndPrintPageEvent;
    FOnScriptGetValue: TJvInterpreterGetValue;
    FOnScriptSetValue: TJvInterpreterSetValue;
    FOnObjectClick: TRMPreviewClickEvent;

    function IsGetSystemVariables(const aVariableName: string; var aValue: Variant): Boolean; // 系统变量
    procedure SetScript(Value: TStrings);
    procedure GetIntrpValue(aVariableName: string; var aValue: Variant);
    procedure OnGetFunction(aFunctionName: string; aParams: array of Variant;
      var aValue: Variant; var aFound: Boolean);
    procedure OnGetVariableValue(aVariableName: string; var aValue: Variant);

    function GetItems(Index: string): TRMView;
    function GetPrinter: TRMPrinter;
    function GetDrawCanvas: TCanvas;
    function GetPrintOffsetLeft(Index: Integer): Integer;
    procedure SetPrintOffsetLeft(Index: Integer; Value: Integer);
    procedure SetSaveReportOptions(Value: TRMSaveReportOptions);
    function GetFlags(Index: Integer): Boolean;
    procedure SetFlags(Index: Integer; Value: Boolean);
    procedure SetPreviewOptions(Value: TRMPreviewOptions);

    procedure ScriptEngine_OnGetDfmFileName(Sender: TObject; aUnitName: string;
      var aFileName: string; var aDone: Boolean);
    procedure ScriptEngine_OnGetUnitSource(aUnitName: string; var aSource: string;
      var aDone: Boolean);
    procedure ScriptEngine_OnGetValue(Sender: TObject; Identifier: string;
      var aValue: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
    procedure ScriptEngine_OnSetValue(Sender: TObject; Identifier: string;
      const aValue: Variant; Args: TJvInterpreterArgs; var Done: Boolean);

    procedure InternalOnReadOneEndPage(const aPageNo, aTotalPages: Integer);
  protected
    HaveHookObject: Boolean;
    DesignerClass: TClass;
    CanPreviewDesign: Boolean;
    FReportFileExtend: string;
    FReportFlagStr: string;
    FDesigner: TRMReportDesigner;
    FDesigning: Boolean;
    UseScale: Boolean;
    ScaleFactor: Integer;
    ScalePageSize, ScalePageWidth, ScalePageHeight: Integer;
    Flag_PrintBackGroundPicture: Boolean;
    FDefaultDataSetOwner: TComponent;
    SubValue: string; // used in GetValue event handler
    InitAggregate: Boolean;
    InDictionary: Boolean;
    ErrorFlag: Boolean; // error occured through TRMView drawing
    ErrorMsg: string; // error description
    FScriptEngine: TJvInterpreterFm;

    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
      Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string;
      aValue: Variant): Boolean; override;

    procedure Loaded; override;
    procedure DefineProperties(aFiler: TFiler); override;
    procedure ReadBinaryData(aStream: TStream);
    procedure WriteBinaryData(aStream: TStream);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure SetPrinterName(aPrinterName: string);
    function GetPrinterIndex: Integer;
    procedure SetPrinterIndex(aPrinterIndex: Integer);
    procedure DoError(E: Exception);
    procedure CreateProgressForm;
    procedure FreeProgressForm;
    procedure DoBuildReport(aFirstTime, aFinalPass: Boolean); virtual;
    function CreatePage(const aPageClass: string): TRMCustomPage; virtual;
    function IsSecondTime: Boolean;

    procedure InternalOnProgress(Percent: Integer);
    procedure InternalOnExportText(aDrawRect: TRect; x, y: Integer;
      const text: string; View: TRMView);
    procedure InternalOnGetValue(aView: TRMReportView; aParName: string; var aParValue: string; aUnicode: Boolean);
    procedure InternalOnGetDataFieldValue(aView: TRMReportView; aDataSet: TRMDataSet;
      const aField: string; var aParValue: string; aUnicode: Boolean);
    procedure InternalOnBeforePrint(Memo: TStrings; View: TRMReportView);
    procedure InternalOnAfterPrint(const aView: TRMReportView);
    procedure InternalOnBeginColumn(Band: TRMBand);
    procedure InternalOnPrintColumn(aColNo: Integer; var aColWidth: Integer);
    procedure InternalOnBeforePrintBand(aBand: TRMBand; var aPrintBand: Boolean);

    property OnAfterPreviewPageSetup: TNotifyEvent read FOnAfterPreviewPageSetup write FOnAfterPreviewPageSetup;
    property CurrentFilter: TRMExportFilter read FCurrentFilter;
  public
    ReportInfo: TRMReportInfo;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    function FindObject(aObjectName: string): TRMView;
    function ReportClassType: Byte; virtual;
    function ReportCommon: string; virtual;

    function ChangePrinter(OldIndex, NewIndex: Integer): Boolean;
    function PrepareReport: Boolean; // 生成报表
    function DesignReport: Boolean; virtual; //　设计报表
    procedure ShowReport; // 预览报表
    procedure PrintReport;
    procedure NewReport;
    procedure ExportTo(aFilter: TRMExportFilter; aFileName: string);
    procedure ShowPreparedReport;
    procedure PrintPreparedReportDlg;
    procedure PrintPreparedReport(aPageNumbers: string; aCopies: Integer;
      aCollate: Boolean; aPrintPages: TRMPrintPages);

    procedure LoadPreparedReport(aFileName: string);
    procedure SavePreparedReport(aFileName: string);
    procedure LoadFromAnsiString(const aStr: AnsiString);
    procedure SaveToAnsiString(var aStr: AnsiString);
    procedure LoadFromResourceName(aInstance: THandle; const aResName: string);
    procedure LoadFromResourceID(aInstance: THandle; aResID: Integer);

    procedure LoadPreparedReportFromStream(aStream: TStream);
    procedure AddPreparedReport(aFileName: string);
    function EditPreparedReport(PageIndex: Integer): Boolean;
    function DesignPreviewedReport: Boolean;

    procedure AppendReport(aStream: TStream);
    procedure AppendFromFile(aFileName: string);
    procedure LoadFromStream(aStream: TStream); virtual;
    procedure SaveToStream(aStream: TStream); virtual;
    function LoadFromFile(aFileName: string): Boolean;
    procedure SaveToFile(aFileName: string);
    procedure SaveToBlobField(aBlobField: TBlobField);
    procedure LoadFromBlobField(aBlobField: TBlobField);
    procedure SaveToMemoField(aField: TField);
    procedure LoadFromMemoField(aField: TField);
    procedure LoadTemplate(aFileName: string; aCommon: TStrings; aBitmap: TBitmap);
    procedure SaveTemplate(aFileName: string; const aCommon: TStrings; const aBitmap: TBitmap);

    function CreateAutoSearchField(const aTableName, aFieldName, aFieldAlias: string;
      aDataType: TRMDataType; aOperator: TRMSearchOperatorType;
      const aExpression: string; aMandatory: Boolean): TRMAutoSearchField;
    function CreateAutoSearchCriteria(const aDataPipelineName, aFieldName: string;
      aOperator: TRMSearchOperatorType; const aExpression: string;
      aMandatory: Boolean): TRMAutoSearchField;

    property Items[Index: string]: TRMView read GetItems; default;
    property DrawCanvas: TCanvas read GetDrawCanvas;
    property Parser: TRMParser read FParser;
    property DocMode: TRMDocMode read FDocMode write FDocMode; // 私有变量
    property Pages: TRMPages read FPages;
    property EndPages: TRMEndPages read FEndPages write FEndPages;
    property CanRebuild: Boolean read FCanRebuild write FCanRebuild;
    property DoublePass: Boolean read FDoublePass write FDoublePass;
    property FinalPass: Boolean read FFinalPass;
    property FileName: string read FFileName write FFileName;
    property PrintbackgroundPicture: Boolean read FPrintbackgroundPicture write FPrintbackgroundPicture;
    property ColorPrint: Boolean read FColorPrint write FColorPrint;
    property PrintOffsetLeft: Integer read FmmPrintOffsetLeft write FmmPrintOffsetLeft;
    property PrintOffsetTop: Integer read FmmPrintOffsetTop write FmmPrintOffsetTop;
    property spPrintOffsetLeft: Integer index 0 read GetPrintOffsetLeft write SetPrintOffsetLeft;
    property spPrintOffsetTop: Integer index 1 read GetPrintOffsetLeft write SetPrintOffsetLeft;
    property Modified: Boolean read FModified write FModified;
    property ComponentModified: Boolean read FComponentModified write FComponentModified;
    property PageCompositeMode: TRMCompositeMode read FPageCompositeMode write FPageCompositeMode default rmReportPerReport;
    property PrinterName: string read FPrinterName write SetPrinterName;
    property PrinterIndex: Integer read GetPrinterIndex write SetPrinterIndex;
    property ReportPrinter: TRMPrinter read GetPrinter;
    property Flag_TableEmpty: Boolean read FFlag_TableEmpty;
    property Dictionary: TRMDictionary read FDictionary write FDictionary;
    property PageNo: Integer read FPageNo;
    property CurrentPage: TRMCustomPage read FCurrentPage write FCurrentPage;
    property CurrentBand: TRMBand read FCurrentBand;
    property CurrentView: TRMView read FCurrentView write FCurrentView;
    property Script: TStrings read FScript write SetScript;
    property AutoSetPageLength: Boolean index 0 read GetFlags write SetFlags;
    property ConvertNulls: Boolean read FConvertNulls write FConvertNulls;
    property Status: TRMReportStatus read FStatus;
    property ShowErrorMsg: Boolean read FShowErrorMsg write FShowErrorMsg;
    property OnReadOneEndPage: TRMReadOneEndPageEvent read FOnReadOneEndPage write FOnReadOneEndPage;

    property MasterReport: TRMReport read FMasterReport;
    property TotalPages: Integer read FTotalPages; // 报表总页数
    property PrintAtFirstTime: Boolean read FPrintAtFirstTime write FPrintAtFirstTime;
  published
    property DataDictionary: TRMDataDictionary read FDataDictionary write FDataDictionary;
    property ModifyPrepared: Boolean read FModifyPrepared write FModifyPrepared default False;
    property InitialZoom: TRMPreviewZoom read FInitialZoom write FInitialZoom;
    property PreviewButtons: TRMPreviewButtons read FPreviewButtons write FPreviewButtons;
    property ModalPreview: Boolean read FModalPreview write FModalPreview default True;
    property MDIPreview: Boolean read FMDIPreview write FMDIPreview default False;
    property ShowProgress: Boolean read FShowProgress write FShowProgress default True;
    property PreviewInitialDir: string read FPreviewInitialDir write FPreviewInitialDir;
    property DefaultCopies: Integer read FDefaultCopies write FDefaultCopies default 1;
    property DefaultCollate: Boolean read FDefaultCollate write FDefaultCollate default True;
    property ShowPrintDialog: Boolean read FShowPrintDialog write FShowPrintDialog default True;
    property SaveReportOptions: TRMSaveReportOptions read FSaveReportOptions write SetSaveReportOptions;
    property Preview: TRMCustomPreview read FPreview write FPreview;
    property PreviewOptions: TRMPreviewOptions read FPreviewOptions write SetPreviewOptions;
    property Dataset: TRMDataset read FDataset write FDataset;
    property StoreInDFM: Boolean read FStoreInDFM write FStoreInDFM default False;
    property ReportType: TRMReportType read FReportType write FReportType default rmrtSimple;
    property CompressLevel: TRMCompressionLevel read FCompressLevel write FCompressLevel;
    property CompressThread: Boolean read FCompressThread write FCompressThread;

    property OnBeginPage: TRMBeginPageEvent read FOnBeginPage write FOnBeginPage;
    property OnEndPage: TRMEndPageEvent read FOnEndPage write FOnEndPage;
    property OnBeginDoc: TNotifyEvent read FOnBeginDoc write FOnBeginDoc;
    property OnEndDoc: TNotifyEvent read FOnEndDoc write FOnEndDoc;
    property OnProgress: TRMProgressEvent read FOnProgress write FOnProgress;
    property OnUserFunction: TRMFunctionEvent read FOnUserFunction write FOnUserFunction;
    property OnGetValue: TRMGetValueEvent read FOnGetValue write FOnGetValue;
    property OnLoadReportSetting: TRMLoadSaveReportSettingEvent read FOnLoadReportSetting write FOnLoadReportSetting;
    property OnSaveReportSetting: TRMLoadSaveReportSettingEvent read FOnSaveReportSetting write FOnSaveReportSetting;
    property OnPrintReportEvent: TNotifyEvent read FOnPrintReportEvent write FOnPrintReportEvent;
    property OnEndPrintPage: TRMEndPrintPageEvent read FOnEndPrintPage write FOnEndPrintPage;
    property OnBeforePrint: TRMOnBeforePrintEvent read FOnBeforePrint write FOnBeforePrint;
    property OnAfterPrint: TRMAfterPrintEvent read FOnAfterPrint write FOnAfterPrint;
    property OnBeginBand: TRMBeginBandEvent read FOnBeginBand write FOnBeginBand;
    property OnEndBand: TRMEndBandEvent read FOnEndBand write FOnEndBand;
    property OnManualBuild: TRMManualBuildEvent read FOnManualBuild write FOnManualBuild;
    property OnBeginColumn: TRMBeginColumnEvent read FOnBeginColumn write FOnBeginColumn;
    property OnPrintColumn: TRMPrintColumnEvent read FOnPrintColumn write FOnPrintColumn;
    property OnBeforePrintBand: TRMBeforePrintBandEvent read FOnBeforePrintBand write FOnBeforePrintBand;
    property OnScriptBeginReport: TNotifyEvent read FOnBeginReport write FOnBeginReport;
    property OnScriptEndReport: TNotifyEvent read FOnEndReport write FOnEndReport;
    property OnScriptGetValue: TJvInterpreterGetValue read FOnScriptGetValue write FonScriptGetValue;
    property OnScriptSetValue: TJvInterpreterSetValue read FOnScriptSetValue write FOnScriptSetValue;

    property OnObjectClick: TRMPreviewClickEvent read FOnObjectClick write FOnObjectClick;
  end;

  { TRMCompositeReport }
  TRMCompositeReport = class(TRMReport)
  private
    FReports: TList;
    FMode: TRMCompositeMode;
    FShowPreparedReports: Boolean;
    procedure OnClearEMFPagesEvnet(Sender: TObject);
    procedure _BuildReports;
    procedure SetMode(Value: TRMCompositeMode);
  protected
    procedure DoBuildReport(aFirstTime, aFinalPass: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Reports: TList read FReports;
  published
    property CompositeMode: TRMCompositeMode read FMode write SetMode default rmReportPerReport;
    property ShowPreparedReports: Boolean read FShowPreparedReports write FShowPreparedReports default False;
  end;

  TRMLoadReportEvent = procedure(Report: TRMReport; var ReportName: string; var Opened: Boolean) of object;
  TRMSaveReportEvent = procedure(Report: TRMReport; var ReportName: string; SaveAs: Boolean; var Saved: Boolean) of object;
  TRMNewReportEvent = procedure(Report: TRMReport; var ReportName: string) of object;

  TRMCustomDesigner = class(TComponent)
  private
    FOnLoadReport: TRMLoadReportEvent;
    FOnSaveReport: TRMSaveReportEvent;
    FOnNewReport: TRMNewReportEvent;
    FOnShowAboutForm: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FOnClose: TNotifyEvent;
  protected
  public
  published
    property OnShowAboutForm: TNotifyEvent read FOnShowAboutForm write FOnShowAboutForm;
    property OnLoadReport: TRMLoadReportEvent read FOnLoadReport write FOnLoadReport;
    property OnSaveReport: TRMSaveReportEvent read FOnSaveReport write FOnSaveReport;
    property OnNewReport: TRMNewReportEvent read FOnNewReport write FOnNewReport;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  end;

  { TRMReportDesigner }
  TRMReportDesigner = class(TForm)
  private
    FUseTableName: Boolean;
    FScriptParser: TJvInterpreterParser;

    function GetScriptParser: TJvInterpreterParser;
  protected
    FErrorFlag: Boolean;
    FReport: TRMReport;
    FFactor: Integer;
    IsPreviewDesign, ShowModifyToolbar: Boolean;
    IsPreviewDesignReport: Boolean;
    AutoSave: Boolean;
    EndPageNo: Integer;

    function GetModified: Boolean; virtual; abstract;
    procedure SetModified(Value: Boolean); virtual; abstract;
    procedure SetFactor(Value: Integer); virtual; abstract;
    function GetDesignerRestrictions: TRMDesignerRestrictions; virtual; abstract;
    procedure SetDesignerRestrictions(Value: TRMDesignerRestrictions); virtual; abstract;
  public
    Page: TRMCustomPage;

    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    procedure BeforeChange; virtual; abstract;
    procedure AfterChange; virtual; abstract;
    function InsertDBField: string; virtual; abstract;
    function InsertExpression: string; virtual; abstract;
    procedure MemoViewEditor(t: TRMView); virtual; abstract;
    procedure RMFontEditor(Sender: TObject); virtual; abstract;
    procedure RMDisplayFormatEditor(Sender: TObject); virtual; abstract;
    procedure PictureViewEditor(t: TRMView); virtual; abstract;
    procedure RMCalcMemoEditor(Sender: TObject); virtual; abstract;
    function PageObjects: TList; virtual;
    function EditorForm: TForm; virtual; abstract;

    // Event Editor
    procedure GetEventFunctions(aValues: TStrings; aParams: PRMParamRecArray;
      aParamCount: Integer); virtual;
    procedure EditMethod(aFuncName: string; aParams: PRMParamRecArray;
      aParamCount: Integer); virtual;
    procedure ClearEmptyEvent; virtual;
    //

    property Report: TRMReport read FReport;
    property Modified: Boolean read GetModified write SetModified;
    property Factor: Integer read FFactor write SetFactor;
    property DesignerRestrictions: TRMDesignerRestrictions read GetDesignerRestrictions write SetDesignerRestrictions;
    property UseTableName: Boolean read FUseTableName write FUseTableName;
    property ScriptParser: TJvInterpreterParser read GetScriptParser;
  end;

  { TRMObjEditorForm }
  TRMObjEditorForm = class(TForm)
  public
    function ShowEditor(View: TRMView): TModalResult; virtual; abstract;
  end;

  { TRMFunctionLibrary }
  TRMFunctionLibrary = class(TRMCustomFunctionLibrary)
  end;

  TRMRMOnAfterInit = procedure(aFirstTime: Boolean);

  { TRMResourceManager }
  TRMResourceManager = class(TObject)
  private
    FDllHandle: THandle;
    FLoaded: Boolean;
    FOnAfterInit: TRMRMOnAfterInit;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadResourceModule(const aResFileName: string);
    procedure UnloadResourceModule;
    function LoadStr(aID: Integer): string;
    property OnAfterInit: TRMRMOnAfterInit read FOnAfterInit write FOnAfterInit;
  end;

  { TRMApplication }
  TRMApplication = class(TComponent)
  private
    function GetExtendFormPath: string;
    procedure SetExtendFormPath(Value: string);
    //    function GetRMUseNull: Boolean;
    //    procedure SetRMUseNull(Value: Boolean);
    function GetUnitType: TRMUnitType;
    procedure SetUnitType(Value: TRMUnitType);
    function GetVariables: TRMVariables;
    procedure SetVariables(Value: TRMVariables);
    function GetDialogForm: TForm;
    function GetLocalLizedPropertyNames: Boolean;
    procedure SetLocalLizedPropertyNames(Value: Boolean);
  protected
  public
    property RMDialogForm: TForm read GetDialogForm;
    property RMUnits: TRMUnitType read GetUnitType write SetUnitType;
  published
    property RMExtendFormPath: string read GetExtendFormPath write SetExtendFormPath;
    //    property RMUseNull: Boolean read GetRMUseNull write SetRMuseNull;
    property RMLocalizedPropertyNames: Boolean read GetLocalLizedPropertyNames write SetLocalLizedPropertyNames;
    property RMVariables: TRMVariables read GetVariables write SetVariables;
  end;

function RMCreateObject(aType: Byte; const aClassName: string): TRMView;
function RMCreateBand(aType: TRMBandType): TRMView;
function RMCreatePage(aParentReport: TRMReport; const aClassName: string): TRMCustomPage;
function RMResourceManager: TRMResourceManager;

function RMToMMThousandths(Value: Double; aUnits: TRMUnitType): Longint;
function RMFromMMThousandths(Value: Longint; aUnits: TRMUnitType): Double;
function RMToScreenPixels(aValue: Double; aUnits: TRMUnitType): Integer;
function RMFromScreenPixels(aScreenPixels: Integer; aUnits: TRMUnitType): Double;
function RMToMMThousandths_Printer(Value: Longint; aResolution: TRMResolutionType;
  aPrinter: TObject): Single;
function RMFromMMThousandths_Printer(Value: Longint; aResolution: TRMResolutionType;
  aPrinter: TObject): Integer;

function RMCreateAPIFont(aFont: TFont; aAngle: Integer; aWidth: Integer): HFont;
procedure RMLoadPicture(aStream: TStream; aPicture: TPicture);
procedure RMWritePicture(aStream: TStream; aPicture: TPicture);
procedure RMLoadBitmap(aStream: TStream; aBitmap: TBitmap);
procedure RMSaveBitmap(aStream: TStream; aBitmap: TBitmap);
procedure RMCompressStream(const aInStream, aOutStream: TStream; aCompressLevel: TZCompressionLevel);
procedure RMDeCompressStream(const aInStream, aOutStream: TStream);
procedure RMGetFormatStr_1(var aFormatStr: string; var aFormat: TRMFormat);
procedure RMAddPaperInfo(aPaperName: string; aPaperWidth, aPaperHeight: Integer);

const
  RMPixPerInchX = 96;
  RMPixPerInchY = 96;

var
  RMApplication: TRMApplication;
  RMExtendFormPath: string;
  //  RMUseNull: Boolean;
  RMUnits: TRMUnitType;
  RMCharset: TFontCharset;
  rmfrAggregate, rmftDateTime, rmftString, rmftOther, rmftMath, rmftBoolean, rmftInterpreter: string;
  RMBandNames: array[TRMBandType] of string;
  RMDateFormats: array[0..6] of string;
  RMTimeFormats: array[0..3] of string;
  RMFormatBoolStr: array[0..3] of string;
  RMShowBandTitles: Boolean;
  RMLocalizedPropertyNames: Boolean;
  RMDialogForm: TForm; // dialog form reference
  RMScreen: TScreen;

  RMVariables: TRMVariables; // report variables reference
  RMDesigner: TRMReportDesigner; // designer reference
  RMDesignerClass: TClass;
  RMCurReport: TRMReport;

implementation

uses
  RM_Preview,
  {$IFDEF USE_INTERNAL_JVCL}
  rm_JvInterpreter_Windows, rm_JvInterpreter_System, rm_JvInterpreter_SysUtils,
  rm_JvInterpreter_Classes, rm_JvInterpreter_Graphics, rm_JvInterpreter_StdCtrls,
  rm_JvInterpreter_Controls, rm_JvInterpreter_Dialogs, rm_JvInterpreter_Forms,
  rm_JvInterpreter_Db {, rm_JvInterpreter_JvInterpreter},
  rm_JvInterpreter_Types,
  {$ELSE}
  JvInterpreter_Windows, JvInterpreter_System, JvInterpreter_SysUtils, JvInterpreter_Classes,
  JvInterpreter_Graphics, JvInterpreter_StdCtrls, JvInterpreter_Controls, JvInterpreter_Dialogs,
  JvInterpreter_Forms, JvInterpreter_Db {, JvInterpreter_JvInterpreter},
  rm_JvInterpreter_Types,
  {$ENDIF}
  Math, RM_utils, RM_PrintDlg
  {$IFDEF JPEG}, JPEG{$ENDIF}
  {$IFDEF RXGIF}, JvGIF{$ENDIF}
  {$IFDEF Delphi6}, MaskUtils{$ELSE}, Mask{$ENDIF};

const
  rmgtBandReportTitle = 50;
  rmgtBandReportSummary = 51;
  rmgtBandPageHeader = 52;
  rmgtBandPageFooter = 53;
  rmgtBandColumnHeader = 54;
  rmgtBandColumnFooter = 55;
  rmgtBandHeader = 56;
  rmgtBandFooter = 57;
  rmgtBandGroupHeader = 58;
  rmgtBandGroupFooter = 59;
  rmgtBandMasterData = 60;
  rmgtBandDetailData = 61;
  rmgtBandChild = 62;
  rmgtBandCrossHeader = 63;
  rmgtBandCrossData = 64;
  rmgtBandCrossFooter = 65;
  rmgtBandOverlay = 66;

  flStretched = $80000000;
  flOnePerPage = $40000000;
  flParentHeight = $20000000;
  flPrintFrame = $10000000;
  flPrintVisible = $8000000;
  flDontUndo = $4000000;
  flWantHook = $2000000;
  flPrintAtAppendBlank = $1000000;
  flDataFieldOnly = $800000;
  flTextOnly = $400000;
  flReprintOnOverFlow = $200000;
  flTransparent = $100000;
  flParentWidth = $80000;
  flChildView = $40000;
  flUseDoublePass = $20000;
  flStretchedMax = $10000;

  // MemoView
  flMemoWordWrap = $1;
  flMemoWordBreak = $2;
  flMemoAutoWidth = $4;
  flMemoDataFieldOnly = $8;
  flMemoSuppressRepeated = $10;
  flMemoHideZeros = $20;
  flMemoUnderlines = $40;
  flMemoRTLReading = $80;
  flMemoMergeRepeated = $100;
  flMemoTotalCalc = $200;
  flMemoCalcNoVisible = $400;
  flMemoMangeTag = $800;
  flMemoExportAsNumber = $1000;
  flMemoOutBigNum = $2000;
  flMemoIsCurrency = $4000;

  // BandView
  flBandNewPageAfter = $1;
  flBandPrintifSubsetEmpty = $2;
  flBandPageBreaked = $4;
  flBandOnFirstPage = $8;
  flBandOnLastPage = $10;
  flBandReprintOnNewPage = $20;
  flBandAutoAppendBlank = $80;
  //  flBandAlignToLeft = $100;
  flBandPrintColumnFirst = $200;
  flBandReprintOnNewColumn = $400;
  flBandPrintIfEmpty = $800;
  flBandPrintatDesignPos = $1000;
  flBandHideIfEmpty = $2000;
  flBandPrintBeforeSummaryBand = $20000;
  flBandPrintChildIfInvisible = $40000;
  flBandAlignToBottom = $80000;
  flBandNewPageBefore {flTextOnly} = $400000;

  flBandKeepChild = $1;
  flBandKeepFooter = $2;
  flBandKeepTogether = $4;
  flBandAdjustColumns = $8;

  // PictureView
  flPictCenter = $1;
  flPictRatio = $2;
  flPictStretched = $4;
  flPictDirectDraw = $8;

  // SubReportView;
  flSubReportReprintLastPage = $1;

  // Page
  flPageShowBackPicture = $1;

var
  FSBmp: TBitmap; // small bitmap used by TfrBandView drawing
  FBandBmp: TBitmap;
  FResourceManager: TRMResourceManager;

type
  THackView = class(TRMView)
  end;

procedure RMAddPaperInfo(aPaperName: string; aPaperWidth, aPaperHeight: Integer);
begin
  RM_Printer.RMAddPaperInfo_1(aPaperName, aPaperWidth, aPaperHeight);
end;

function RMFromMMThousandths(Value: Longint; aUnits: TRMUnitType): Double;
begin
  case aUnits of
    rmutScreenPixels: // 微米＝>>屏幕象素
      Result := Round(((Value / 1000) * RMInchPerMM) * RMPixPerInchY * 100) / 100;
    rmutInches: // 微米=>>英寸
      Result := Round((((Value / 1000) * RMInchPerMM) * 10000)) / 10000;
    rmutMillimeters: // 微米=>>毫米
      Result := Value / 1000;
    rmutMMThousandths: // 微米=>>微米
      Result := Value;
  else
    Result := 0;
  end;
end;

function RMToMMThousandths(Value: Double; aUnits: TRMUnitType): Longint;
begin
  case aUnits of
    rmutScreenPixels: //  屏幕象素＝>>微米
      Result := Round(((Value / RMPixPerInchY) / RMInchPerMM) * 1000);
    rmutInches: // 英寸=>>微米
      Result := Round((Value / RMInchPerMM) * 1000);
    rmutMillimeters: // 毫米=>>微米
      Result := Round(Value * 1000);
    rmutMMThousandths: // 微米=>>微米
      Result := Round(Value);
  else
    Result := 0;
  end;
end;

function RMToScreenPixels(aValue: Double; aUnits: TRMUnitType): Integer;
var
  llMMThousandths: Longint;
begin
  llMMThousandths := RMToMMThousandths(aValue, aUnits);
  Result := Round(RMFromMMThousandths(llMMThousandths, rmutScreenPixels));
end;

function RMFromScreenPixels(aScreenPixels: Integer; aUnits: TRMUnitType): Double;
var
  llMMThousandths: Longint;
begin
  llMMThousandths := RMToMMThousandths(aScreenPixels, rmutScreenPixels);
  Result := RMFromMMThousandths(llMMThousandths, aUnits);
end;

function RMFromMMThousandths_Printer(Value: Longint; aResolution: TRMResolutionType;
  aPrinter: TObject): Integer;
var
  liDPI: Integer;
begin
  if (aPrinter <> nil) and (aPrinter is TRMPrinter) then
  begin
    if aResolution = rmrtVertical then
      liDPI := TRMPrinter(aPrinter).PixelsPerInch.Y
    else
      liDPI := TRMPrinter(aPrinter).PixelsPerInch.X;
  end
  else
    liDPI := RMPixPerInchY;

  Result := Round(((Value / 1000) * RMInchPerMM) * liDPI);
end;

function RMToMMThousandths_Printer(Value: Longint; aResolution: TRMResolutionType;
  aPrinter: TObject): Single;
var
  liDPI: Integer;
begin
  if (aPrinter <> nil) and (aPrinter is TRMPrinter) then
  begin
    if aResolution = rmrtVertical then
      liDPI := TRMPrinter(aPrinter).PixelsPerInch.Y
    else
      liDPI := TRMPrinter(aPrinter).PixelsPerInch.X;
  end
  else
    liDPI := RMPixPerInchY;

  Result := Round(((Value / liDPI) / RMInchPerMM) * 1000); // 返回的是微米
end;

function RMResourceManager: TRMResourceManager;
begin
  if FResourceManager = nil then
    FResourceManager := TRMResourceManager.Create;
  Result := FResourceManager;
end;

function RMCreateObjectWidthErrorMsg(aType: Byte; const aClassName: string;
  var aErrorFlag: Boolean; var aErrorStr: string): TRMView;
var
  i: Integer;
  lObjInfo: TRMAddInObjectInfo;
begin
  Result := nil;
  case aType of
    rmgtMemo: Result := TRMMemoView.Create;
    rmgtCalcMemo: Result := TRMCalcMemoView.Create;
    rmgtPicture: Result := TRMPictureView.Create;
    rmgtSubReport: Result := TRMSubReportView.Create;
    rmgtShape: Result := TRMShapeView.Create;
    rmgtOutline: Result := TRMOutlineView.Create;

    rmgtBandReportTitle: Result := TRMBandReportTitle.Create;
    rmgtBandReportSummary: Result := TRMBandReportSummary.Create;
    rmgtBandPageHeader: Result := TRMBandPageHeader.Create;
    rmgtBandPageFooter: Result := TRMBandPageFooter.Create;
    rmgtBandColumnHeader: Result := TRMBandColumnHeader.Create;
    rmgtBandColumnFooter: Result := TRMBandColumnFooter.Create;
    rmgtBandHeader: Result := TRMBandHeader.Create;
    rmgtBandFooter: Result := TRMBandFooter.Create;
    rmgtBandGroupHeader: Result := TRMBandGroupHeader.Create;
    rmgtBandGroupFooter: Result := TRMBandGroupFooter.Create;
    rmgtBandMasterData: Result := TRMBandMasterData.Create;
    rmgtBandDetailData: Result := TRMBandDetailData.Create;
    rmgtBandCrossHeader: Result := TRMBandCrossHeader.Create;
    rmgtBandCrossData: Result := TRMBandCrossData.Create;
    rmgtBandCrossFooter: Result := TRMBandCrossFooter.Create;
    rmgtBandOverlay: Result := TRMBandOverlay.Create;
    rmgtBandChild: Result := TRMBandChild.Create;
    rmgtAddIn:
      begin
        for i := 0 to RMAddInsCount - 1 do
        begin
          lObjInfo := RMAddIns(i);
          if (lObjInfo.ClassRef <> nil) and RMCmp(lObjInfo.ClassRef.ClassName, aClassName) then
          begin
            Result := TRMView(lObjInfo.ClassRef.NewInstance);
            Result.Create;
            Break;
          end;
        end;

        if Result = nil then
        begin
          aErrorFlag := True;
          aErrorStr := aErrorStr + aClassName + #13;
          raise EClassNotFound.Create(aClassName + #13);
        end;
      end;
  end;
end;

function RMCreateObject(aType: Byte; const aClassName: string): TRMView;
var
  i: Integer;
  lObjInfo: TRMAddInObjectInfo;
begin
  Result := nil;
  case aType of
    rmgtMemo: Result := TRMMemoView.Create;
    rmgtCalcMemo: Result := TRMCalcMemoView.Create;
    rmgtPicture: Result := TRMPictureView.Create;
    rmgtSubReport: Result := TRMSubReportView.Create;
    rmgtShape: Result := TRMShapeView.Create;
    rmgtOutline: Result := TRMOutlineView.Create;

    rmgtBandReportTitle: Result := TRMBandReportTitle.Create;
    rmgtBandReportSummary: Result := TRMBandReportSummary.Create;
    rmgtBandPageHeader: Result := TRMBandPageHeader.Create;
    rmgtBandPageFooter: Result := TRMBandPageFooter.Create;
    rmgtBandColumnHeader: Result := TRMBandColumnHeader.Create;
    rmgtBandColumnFooter: Result := TRMBandColumnFooter.Create;
    rmgtBandHeader: Result := TRMBandHeader.Create;
    rmgtBandFooter: Result := TRMBandFooter.Create;
    rmgtBandGroupHeader: Result := TRMBandGroupHeader.Create;
    rmgtBandGroupFooter: Result := TRMBandGroupFooter.Create;
    rmgtBandMasterData: Result := TRMBandMasterData.Create;
    rmgtBandDetailData: Result := TRMBandDetailData.Create;
    rmgtBandCrossHeader: Result := TRMBandCrossHeader.Create;
    rmgtBandCrossData: Result := TRMBandCrossData.Create;
    rmgtBandCrossFooter: Result := TRMBandCrossFooter.Create;
    rmgtBandOverlay: Result := TRMBandOverlay.Create;
    rmgtBandChild: Result := TRMBandChild.Create;
    rmgtAddIn:
      begin
        for i := 0 to RMAddInsCount - 1 do
        begin
          lObjInfo := RMAddIns(i);
          if (lObjInfo.ClassRef <> nil) and RMCmp(lObjInfo.ClassRef.ClassName, aClassName) then
          begin
            Result := TRMView(lObjInfo.ClassRef.NewInstance);
            Result.Create;
            Break;
          end;
        end;

        if Result = nil then
        begin
          //          ErrorFlag := True;
          //          ErrorStr := ErrorStr + ClassName + #13;
          raise EClassNotFound.Create(aClassName + #13);
        end;
      end;
  end;
end;

function RMCreateBand(aType: TRMBandType): TRMView;
begin
  case aType of
    rmbtReportTitle: Result := RMCreateObject(rmgtBandReportTitle, '');
    rmbtReportSummary: Result := RMCreateObject(rmgtBandReportSummary, '');
    rmbtPageHeader: Result := RMCreateObject(rmgtBandPageHeader, '');
    rmbtPageFooter: Result := RMCreateObject(rmgtBandPageFooter, '');
    rmbtColumnHeader: Result := RMCreateObject(rmgtBandColumnHeader, '');
    rmbtColumnFooter: Result := RMCreateObject(rmgtBandColumnFooter, '');
    rmbtHeader: Result := RMCreateObject(rmgtBandHeader, '');
    rmbtFooter: Result := RMCreateObject(rmgtBandFooter, '');
    rmbtGroupHeader: Result := RMCreateObject(rmgtBandGroupHeader, '');
    rmbtGroupFooter: Result := RMCreateObject(rmgtBandGroupFooter, '');
    rmbtMasterData: Result := RMCreateObject(rmgtBandMasterData, '');
    rmbtDetailData: Result := RMCreateObject(rmgtBandDetailData, '');
    rmbtCrossHeader: Result := RMCreateObject(rmgtBandCrossHeader, '');
    rmbtCrossData: Result := RMCreateObject(rmgtBandCrossData, '');
    rmbtCrossFooter: Result := RMCreateObject(rmgtBandCrossFooter, '');
    rmbtOverlay: Result := RMCreateObject(rmgtBandOverlay, '');
    rmbtChild: Result := RMCreateObject(rmgtBandChild, '');
  else
    Result := nil;
  end;
end;

function RMCreatePage(aParentReport: TRMReport; const aClassName: string): TRMCustomPage;
begin
  if RMCmp(aClassName, 'TRMDialogPage') then
    Result := TRMDialogPage.CreatePage(aParentReport)
  else if RMCmp(aClassName, 'TRMReportPage') then
  begin
    with aParentReport.ReportPrinter do
      Result := TRMReportPage.CreatePage(aParentReport, DefaultPaper, DefaultPaperWidth, DefaultPaperHeight, $FFFF, rmpoPortrait);
  end
  else
    Result := aParentReport.CreatePage(aClassName);
end;

procedure RMLoadPicture(aStream: TStream; aPicture: TPicture);
var
  b: byte;
  liPos: Integer;
  liGraphic: TGraphic;
  liStream: TMemoryStream;
begin
  b := RMReadByte(aStream);
  liPos := RMReadInt32(aStream);
  liGraphic := nil;
  try
    if b > 0 then
    begin
      case TRMBlobType(b - 1) of
        rmbtBitmap: liGraphic := TBitmap.Create;
        rmbtMetafile: liGraphic := TMetafile.Create;
        rmbtIcon: liGraphic := TIcon.Create;
        {$IFDEF JPEG}
        rmbtJPEG: liGraphic := TJPEGImage.Create;
        {$ENDIF}
        {$IFDEF RXGIF}
        rmbtGIF: liGraphic := TJvGIFImage.Create;
        {$ENDIF}
      end;
    end;

    aPicture.Graphic := liGraphic;
    if liGraphic <> nil then
    begin
      liGraphic.Free;
      liStream := TMemoryStream.Create;
      try
        liStream.CopyFrom(aStream, liPos - aStream.Position);
        liStream.Position := 0;
        aPicture.Graphic.LoadFromStream(liStream);
      finally
        liStream.Free;
      end;
    end;
  finally
    aStream.Seek(liPos, soFromBeginning);
  end;
end;

procedure RMWritePicture(aStream: TStream; aPicture: TPicture);
var
  b: TRMBlobType;
  liSavePos, liPos: Integer;
begin
  b := rmbtBitmap;
  if aPicture.Graphic <> nil then
  begin
    if aPicture.Graphic is TBitmap then
      b := rmbtBitmap
    else if aPicture.Graphic is TMetafile then
      b := rmbtMetafile
    else if aPicture.Graphic is TIcon then
      b := rmbtIcon
        {$IFDEF JPEG}
    else if aPicture.Graphic is TJPEGImage then
      b := rmbtJPEG
        {$ENDIF}
      {$IFDEF RXGIF}
    else if aPicture.Graphic is TJvGIFImage then
      b := rmbtGIF
        {$ENDIF};
  end;

  if aPicture.Graphic <> nil then
    RMWriteByte(aStream, Byte(b) + 1)
  else
    RMWriteByte(aStream, 0);

  liSavePos := aStream.Position;
  RMWriteInt32(aStream, liSavePos);
  if aPicture.Graphic <> nil then
    aPicture.Graphic.SaveToStream(aStream);
  liPos := aStream.Position;
  aStream.Position := liSavePos;
  RMWriteInt32(aStream, liPos);
  aStream.Seek(0, soFromEnd);
end;

procedure RMLoadBitmap(aStream: TStream; aBitmap: TBitmap);
var
  lPos: Integer;
  lStream: TMemoryStream;
begin
  lPos := RMReadInt32(aStream);
  lStream := TMemoryStream.Create;
  try
    if lPos - aStream.Position > 0 then
    begin
      lStream.CopyFrom(aStream, lPos - aStream.Position);
      lStream.Position := 0;
      aBitmap.LoadFromStream(lStream);
    end;
  finally
    lStream.Free;
    aStream.Seek(lPos, soFromBeginning);
  end;
end;

procedure RMSaveBitmap(aStream: TStream; aBitmap: TBitmap);
var
  lSavePos, lPos: Integer;
begin
  lSavePos := aStream.Position;
  RMWriteInt32(aStream, lSavePos);
  aBitmap.SaveToStream(aStream);
  lPos := aStream.Position;
  aStream.Position := lSavePos;
  RMWriteInt32(aStream, lPos);
  aStream.Seek(0, soFromEnd);
end;

function RMCreateAPIFont(aFont: TFont; aAngle: Integer; aWidth: Integer): HFont;
var
  F: TLogFont;
begin
  GetObject(aFont.Handle, SizeOf(TLogFont), @F);
  F.lfEscapement := aAngle * 10;
  F.lfOrientation := aAngle * 10 {OUT_TT_ONLY_PRECIS};
  if aWidth > 0 then
    F.lfWidth := aWidth;
  Result := CreateFontIndirect(F);
end;

function RMGetDefaultDataSet(aReport: TRMReport): TRMDataSet;
var
  Res: TRMDataset;
  liBand: TRMBand;
begin
  Result := nil;
  Res := nil;
  if (aReport.FCurrentBand <> nil) and (aReport.FCurrentPage <> nil) and (aReport.FCurrentPage is TRMReportPage) then
  begin
    case aReport.FCurrentBand.BandType of
      rmbtReportTitle, rmbtReportSummary,
        rmbtPageHeader, rmbtPageFooter,
        rmbtMasterData,
        rmbtGroupHeader, rmbtGroupFooter,
        rmbtColumnHeader, rmbtColumnFooter:
        begin
          liBand := TRMReportPage(aReport.FCurrentPage).BandByType(rmbtMasterData);
          if liBand <> nil then Res := liBand.DataSet;
        end;
      rmbtDetailData:
        begin
          liBand := TRMReportPage(aReport.FCurrentPage).BandByType(rmbtDetailData);
          if liBand <> nil then Res := liBand.DataSet;
        end;
      rmbtCrossData, rmbtCrossFooter:
        begin
          liBand := TRMReportPage(aReport.FCurrentPage).BandByType(rmbtCrossData);
          if liBand <> nil then Res := liBand.DataSet;
        end;
    else
      Res := aReport.DataSet;
    end;
  end;
  if (Res <> nil) and (Res is TRMDBDataset) then
    Result := TRMDBDataSet(Res);
end;

function RMFormatValue(aValue: Variant; aFormat: TRMFormat; const aFormatStr: string;
  aUnicode: Boolean): string;
var
  lChar: Char;
  lStr: string;

  function _FormatDateTime(const aFormat: string; aDateTime: TDateTime): string;
  var
    SaveDateSeparator: Char;
  begin
    SaveDateSeparator := DateSeparator;
    try
      if Pos('/', aFormat) > 0 then
        DateSeparator := '/';
      Result := FormatDateTime(aFormat, aDateTime);
    finally
      DateSeparator := SaveDateSeparator;
    end;
  end;

begin
  if (TVarData(aValue).VType = varEmpty) or (aValue = Null) then
  begin
    Result := '';
    Exit;
  end;

  if ((TVarData(aValue).VType = varString) and (Trim(aValue) = '')) then
  begin
    Result := aValue;
    Exit;
  end;

  lChar := DecimalSeparator;
  try
    case aFormat.FormatIndex1 of
      0: //字符型
        begin
          if VarType(aValue) in [varSingle, varDouble] then
            Result := FormatFloat('0.########', aValue)
          else
          begin
            if aUnicode then
            begin
              {$IFDEF TntUnicode}
              Result := UTF8Encode(aValue);
              {$ELSE}
              Result := aValue;
              {$ENDIF}
            end
            else
              Result := aValue;
          end;
        end;
      1: //数字型
        begin
          DecimalSeparator := aFormat.FormatdelimiterChar;
          case aFormat.FormatIndex2 of
            0: Result := FormatFloat('##0.' + StringOfChar('#', aFormat.FormatPercent), aValue);
            1: Result := FloatToStrF(aValue, ffFixed, 15, aFormat.FormatPercent);
            2: Result := FormatFloat('#,##0.' + StringOfChar('#', aFormat.FormatPercent), aValue);
            3: Result := FloatToStrF(aValue, ffNumber, 15, aFormat.FormatPercent);
            4: Result := FormatFloat(aFormatStr, aValue);
          end;
        end;
      2: //日期型
        begin
          if aFormat.FormatIndex2 > High(RMDateFormats) then
            Result := _FormatDateTime(aFormatStr, aValue)
          else
            Result := _FormatDateTime(RMDateFormats[aFormat.FormatIndex2], aValue);
        end;
      3: //时间型
        begin
          if aFormat.FormatIndex2 = 4 then
            Result := FormatDateTime(aFormatStr, aValue)
          else
            Result := FormatDateTime(RMTimeFormats[aFormat.FormatIndex2], aValue);
        end;
      4: //逻辑型
        begin
          if aFormat.FormatIndex2 = 4 then
            lStr := aFormatStr
          else
            lStr := RMFormatBoolStr[aFormat.FormatIndex2];

          if Integer(aValue) = 0 then
            Result := Copy(lStr, 1, Pos(';', lStr) - 1)
          else
            Result := Copy(lStr, Pos(';', lStr) + 1, 255);
        end;
    end;
  except
    Result := aValue;
  end;

  DecimalSeparator := lChar;
end;

procedure RMGetFormatStr_1(var aFormatStr: string; var aFormat: TRMFormat);
begin
  if aFormatStr = '' then
  begin
    aFormat.FormatIndex1 := 0;
    aFormat.FormatIndex2 := 0;
    aFormat.FormatdelimiterChar := DecimalSeparator;
  end
  else if aFormatStr[1] in ['0'..'9', 'N', 'n'] then
  begin
    aFormat.FormatIndex1 := 1;
    aFormat.FormatIndex2 := RMFormatNumCount;
    aFormat.FormatdelimiterChar := '.';
    aFormatStr := Copy(aFormatStr, 2, 255);
  end
  else if aFormatStr[1] in ['D', 'd'] then
  begin
    aFormat.FormatIndex1 := 2;
    aFormat.FormatIndex2 := RMFormatDateCount;
    aFormatStr := Copy(aFormatStr, 2, 255);
  end
  else if aFormatStr[1] in ['T', 't'] then
  begin
    aFormat.FormatIndex1 := 3;
    aFormat.FormatIndex2 := RMFormatTimeCount;
    aFormatStr := Copy(aFormatStr, 2, 255);
  end
  else if aFormatStr[1] in ['B', 'b'] then
  begin
    aFormat.FormatIndex1 := 4;
    aFormat.FormatIndex2 := RMFormatBooleanCount;
    aFormatStr := Copy(aFormatStr, 2, 255);
  end;
end;

procedure RMGetFormatStr(aCurView: TRMReportView; var aParName, aFormatStr: string;
  var aFormat: TRMFormat);
var
  i: Integer;
begin
  if aCurView <> nil then
  begin
    aFormat := aCurView.FormatFlag;
    aFormatStr := aCurView.DisplayFormat;
  end
  else
  begin
    aFormat.FormatIndex1 := 0;
    aFormat.FormatIndex2 := 0;
    aFormatStr := '';
  end;

  i := Pos(' #', aParName);
  if i = 0 then
    i := Pos(' :', aParName);
  if i > 0 then
  begin
    aFormatStr := Copy(aParName, i + 2, Length(aParName) - i - 1);
    aParName := Copy(aParName, 1, i - 1);
    RMGetFormatStr_1(aFormatStr, aFormat);
  end;
end;

procedure RMCreateDataSet(aReport: TRMReport; aDataSetName: string;
  aIsVirtualDataSet: Boolean; var aDataSet: TRMDataSet);
var
  lComponent: TComponent;
begin
  if aDataSetName = '' then Exit;
  if aIsVirtualDataSet then // 虚拟数据集
  begin
    aDataSet := TRMUserDataSet.Create(nil);
    aDataSet.RangeEnd := rmreCount;
    aDataSet.RangeEndCount := StrToInt(aDataSetName);
  end
  else
  begin
    lComponent := RMFindComponent(aReport.Owner, aDataSetName);
    if (lComponent <> nil) and (lComponent is TRMDataset) then
      aDataSet := TRMDataset(lComponent);
  end;

  if aDataSet <> nil then
  begin
    try
      aDataSet.Init;
    except
      on E: exception do aReport.DoError(E);
    end;
  end;
end;

procedure RMGetDataSetAndField(aReport: TRMReport; aComplexName: string;
  var aDataSet: TRMDataSet; var aFieldName: string);
var
  i, j, n: Integer;
  f: TComponent;
  sl: TStringList;
  s: string;
  c: Char;
  cn: TControl;
  liDatasetOwner: TComponent;
  liComponent: TComponent;

  function _FindField(aDataSet: TRMDataSet; const aFieldName: string): string;
  var
    sl: TStringList;
    s: string;
  begin
    Result := '';
    if aDataSet <> nil then
    begin
      if (aDataSet.DictionaryKey <> '') and (aReport.DataDictionary <> nil) then
      begin
        if aReport.DataDictionary.GetRealFieldName(aDataSet.DictionaryKey, aFieldName, s) then
        begin
          Result := s;
          Exit;
        end;
      end;

      sl := TStringList.Create;
      try
        aDataSet.GetFieldsList(sl);
        if sl.IndexOf(aFieldName) >= 0 then
          Result := aFieldName;
      finally
        sl.Free;
      end;
    end;
  end;

begin
  sl := TStringList.Create;
  aFieldName := '';
  try
    f := aReport.Owner;
    if aReport <> nil then
      liDatasetOwner := aReport.FDefaultDatasetOwner
    else
      liDatasetOwner := nil;

    n := 0;
    j := 1;
    for i := 1 to Length(aComplexName) do
    begin
      c := aComplexName[i];
      if c = '"' then
      begin
        sl.Add(Copy(aComplexName, i, 255));
        j := i;
        Break;
      end
      else if c = '.' then
      begin
        sl.Add(Copy(aComplexName, j, i - j));
        j := i + 1;
        Inc(n);
      end;
    end;

    if j <> i then
      sl.Add(Copy(aComplexName, j, 255));

    case n of
      0: // field name only
        begin
          s := RMRemoveQuotes(aComplexName);
          aFieldName := _FindField(aDataSet, s);
        end;
      1: // DatasetName.FieldName
        begin
          if sl[0] <> '' then
          begin
            liComponent := RMFindComponent(f, sl[0]);
            if (liComponent <> nil) and (liComponent is TRMDataset) then
              aDataSet := TRMDataset(liComponent);
          end;
          if (aDataSet = nil) and (liDatasetOwner <> nil) then
          begin
            liComponent := RMFindComponent(liDatasetOwner, sl[0]);
            if (liComponent <> nil) and (liComponent is TRMDataset) then
              aDataSet := TRMDataset(liComponent);
          end;
          s := RMRemoveQuotes(sl[1]);
          aFieldName := _FindField(aDataSet, s);
        end;
      2: // FormName.DatasetName.FieldName
        begin
          f := FindGlobalComponent(sl[0]);
          if f = nil then f := liDatasetOwner;
          if f <> nil then
          begin
            liComponent := RMFindComponent(f, sl[1]);
            if (liComponent <> nil) and (liComponent is TRMDataset) then
              aDataSet := TRMDataset(liComponent);
            s := RMRemoveQuotes(sl[2]);
            aFieldName := _FindField(aDataSet, s);
          end;
        end;
      3: // FormName.FrameName.DatasetName.FieldName - Delphi5
        begin
          f := FindGlobalComponent(sl[0]);
          if f = nil then f := liDatasetOwner;
          if f <> nil then
          begin
            cn := TControl(f.FindComponent(sl[1]));
            liComponent := RMFindComponent(cn, sl[2]);
            if (liComponent <> nil) and (liComponent is TRMDataset) then
              aDataSet := TRMDataset(liComponent);
            s := RMRemoveQuotes(sl[3]);
            aFieldName := _FindField(aDataSet, s);
          end;
        end;
    end;
  finally
    sl.Free;
  end;
end;

procedure RMClearList(aList: TList);
var
  i: Integer;
begin
  if not Assigned(aList) then Exit;

  try
    for i := 0 to aList.Count - 1 do
      TObject(aList[i]).Free;
  finally
    aList.Clear;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TAggregateFunctionsSplitter}

const
  atAvg = 10;
  atCount = 11;
  atMax = 12;
  atMin = 13;
  atSum = 14;

type
  TAggregateFunctionsSplitter = class(TRMFunctionSplitter)
  public
    constructor CreateSplitter(aSplitTo: TStrings; aReport: TRMReport);
    destructor Destroy; override;
    procedure SplitMemo(aMemo: TStrings);
  end;

constructor TAggregateFunctionsSplitter.CreateSplitter(aSplitTo: TStrings; aReport: TRMReport);
begin
  FMatchFuncs := TStringList.Create;
  FMatchFuncs.Add('AVG');
  FMatchFuncs.Add('COUNT');
  FMatchFuncs.Add('MAX');
  FMatchFuncs.Add('MIN');
  FMatchFuncs.Add('SUM');
  inherited Create(FMatchFuncs, aSplitTo, aReport.Dictionary.Variables);
end;

destructor TAggregateFunctionsSplitter.Destroy;
begin
  FMatchFuncs.Free;
  inherited Destroy;
end;

procedure TAggregateFunctionsSplitter.SplitMemo(aMemo: TStrings);
var
  i: Integer;

  procedure SplitStr(s: string);
  var
    i, j: Integer;
    s1: string;
  begin
    i := 1;
    repeat
      while (i < Length(s)) and (s[i] <> '[') do
        Inc(i);
      s1 := RMGetBrackedVariable(s, i, j);
      if i <> j then
      begin
        Split('[' + s1 + ']');
        i := j + 1;
      end;
    until i = j;
  end;

begin
  for i := 0 to aMemo.Count - 1 do
    SplitStr(aMemo[i]);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMHighlight }

constructor TRMHighlight.Create;
begin
  inherited Create;
  FFont := TFont.Create;
  FColor := clNone;
end;

destructor TRMHighlight.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TRMHighlight.Assign(Source: TPersistent);
begin
  with TRMHighlight(Source) do
  begin
    Self.FFont.Assign(Font);
    Self.FColor := Color;
  end;
end;

procedure TRMHighlight.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TRMHighlight.SetColor(Value: TColor);
begin
  //  if Value = clNone then
  //    FColor := clWindowText
  //  else
  FColor := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMFrameLine }

constructor TRMFrameLine.Create(aParentView: TRMView);
begin
  inherited Create;
  FParentView := aParentView;
  FVisible := False;
  FColor := clBlack;
  FStyle := psSolid;
  FDoubleFrame := False;
  spWidth := 1;
end;

procedure TRMFrameLine.Assign(Source: TPersistent);
begin
  with TRMFrameLine(Source) do
  begin
    Self.Visible := Visible;
    Self.Style := Style;
    Self.Color := Color;
    Self.Width := Width;
    Self.DoubleFrame := DoubleFrame;
  end;
end;

function TRMFrameLine.GetUnits: TRMUnitType;
begin
  if (FParentView.FParentReport <> nil) and (FParentView.FParentReport.DocMode = rmdmDesigning) then
    Result := RMUnits
  else
    Result := rmutScreenPixels;
end;

function TRMFrameLine.GetWidth: Double;
begin
  Result := RMFromMMThousandths(FmmWidth, GetUnits);
end;

procedure TRMFrameLine.SetWidth(Value: Double);
begin
  FmmWidth := RMToMMThousandths(Value, GetUnits);
end;

function TRMFrameLine.GetspWidth: Integer;
begin
  Result := Round(RMFromMMThousandths(FmmWidth, rmutScreenPixels));
end;

procedure TRMFrameLine.SetspWidth(Value: Integer);
begin
  FmmWidth := RMToMMThousandths(Value, rmutScreenPixels);
end;

procedure TRMFrameLine.SetColor(Value: TColor);
begin
  //  if Value = clNone then
  //    FColor := clWindow
  //  else
  FColor := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMView }

constructor TRMView.Create;
begin
  inherited Create;
  NeedCreateName := True;
  FName := '';
  BaseName := 'View';
  Typ := rmgtAddIn;
  FIsBand := False;
  FIsCrossBand := False;
  FParentReport := nil;
  FParentPage := nil;
  FComponent := nil;

  FBrushStyle := bsSolid;
  FLeftFrame := TRMFrameLine.Create(Self);
  FTopFrame := TRMFrameLine.Create(Self);
  FRightFrame := TRMFrameLine.Create(Self);
  FBottomFrame := TRMFrameLine.Create(Self);
  FLeftRightFrame := 0;

  FFlags := 0;
  FVisible := True;
  FFillColor := clNone;
  FCursor := crDefault;
  FExpressionDelimiters := '[;]';

  FMemo := TStringList.Create;
  FMemo1 := TStringList.Create;
  FParentFont := True;
end;

destructor TRMView.Destroy;
begin
  FLeftFrame.Free;
  FTopFrame.Free;
  FRightFrame.Free;
  FBottomFrame.Free;
  FMemo.Free;
  FMemo1.Free;
  inherited Destroy;
end;

procedure TRMView.Assign(aSource: TPersistent);
var
  liStream: TMemoryStream;
begin
  if aSource is TRMView then
  begin
    Typ := TRMView(aSource).ObjectType;
    liStream := TMemoryStream.Create;
    try
      TRMView(aSource).StreamMode := rmsmDesigning;
      TRMView(aSource).SaveToStream(liStream);
      liStream.Position := 0;
      StreamMode := rmsmDesigning;
      LoadFromStream(liStream);
      Name := TRMView(aSource).Name;
      Selected := TRMView(aSource).Selected;
    finally
      liStream.Free;
    end;
  end;
end;

procedure TRMView.ShowEditor;
begin
  //
end;

function TRMView.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
var
  lStr: string;
  lLen: Integer;

  procedure _GetValue;
  var
    i: Integer;
    lNeedDeleteChar: Boolean;
    lStr: string;
  begin
    lNeedDeleteChar := True;
    if Memo1.Count > 0 then
    begin
      if FIsStringValue then
        lStr := Memo1[0]
      else
      begin
        if Memo1[0] <> '' then
          lStr := Memo1[0]
        else
        begin
          lNeedDeleteChar := False;
          aValue := 0;
        end;
      end;
    end
    else
    begin
      lNeedDeleteChar := False;
      if FIsStringValue then
        aValue := ''
      else
        aValue := 0;
    end;

    if lNeedDeleteChar then
    begin
      i := 1;
      if Pos(#1, lStr) <> 0 then
      begin
        while i < Length(lStr) do
        begin
          if lStr[i] = #1 then
            Delete(lStr, i, 1)
          else
            Inc(i);
        end;
      end;

      aValue := lStr;
    end;
  end;

begin
  Result := True;
  if Self is TRMDialogControl then
  begin
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
  end
  else
  begin
    if aPropName = 'MEMO' then
    begin
      lStr := Memo.Text;
      if lStr <> '' then
        aValue := System.Copy(lStr, 1, Length(lStr) - 2)
      else
        aValue := lStr;
    end
    else if aPropName = 'MEMO1' then
    begin
      lStr := Memo1.Text;
      if lStr <> '' then
        aValue := System.Copy(lStr, 1, Length(lStr) - 2)
      else
        aValue := lStr;
    end
    else if (aPropName = 'ASSTRING') or (aPropName = 'TEXT') then
    begin
      lStr := Memo1.Text;
      lLen := Length(lStr);
      if (lLen >= 2) and (lStr[lLen - 1] = #13) and (lStr[lLen] = #10) then
        SetLength(lStr, lLen - 2);

      aValue := lStr;
    end
    else if (aPropName = 'VALUE') or (aPropName = 'CALCVALUE') then
    begin
      _GetValue;
    end
    else if (aPropName = 'ASFLOAT') or (aPropName = 'ASNUMBER') or (aPropName = 'ASDATE') or
      (aPropName = 'ASTIME') or (aPropName = 'ASDATETIME') then
    begin
      _GetValue;
      aValue := Double(aValue);
    end
    else if aPropName = 'ASINTEGER' then
    begin
      _GetValue;
      aValue := Integer(aValue);
    end
    else if aPropName = 'ASBOOLEAN' then
    begin
      _GetValue;
      aValue := Boolean(aValue);
    end
    else if aPropName = 'PARENTPAGE' then
      aValue := O2V(ParentPage)
    else if aPropName = 'SETSPBOUNDS' then
      SetSpBounds(Args[0], Args[1], Args[2], Args[3])
    else if aPropName = 'SETFRAMEVISIBLE' then
      SetFrameVisible(Args[0])
    else
      Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
  end;
end;

function TRMView.SetPropValue(aObject: TObject; aPropName: string;
  aValue: Variant): Boolean;
begin
  Result := True;
  if aPropName = 'MEMO' then
    FMemo.Text := aValue
  else if aPropName = 'MEMO1' then
    FMemo1.Text := aValue
  else if (aPropName = 'ASSTRING') or (aPropName = 'TEXT') then
    Memo.Text := aValue
  else if (aPropName = 'ASFLOAT') or (aPropName = 'ASNUMBER') or (aPropName = 'ASDATE') or
    (aPropName = 'ASTIME') or (aPropName = 'ASDATETIME') then
  begin
    Memo.Text := aValue;
  end
  else if aPropName = 'ASINTEGER' then
  begin
    Memo.Text := aValue;
  end
  else if aPropName = 'ASBOOLEAN' then
  begin
    Memo.Text := aValue;
  end
  else if aPropName = 'PARENTPAGE' then
    ParentPage := TRMCustomPage(V2O(aValue))
  else
    Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

procedure TRMView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
begin
end;

function TRMView.GetClipRgn(rt: TRMRgnType): HRGN;
begin
  if rt = rmrtNormal then
    Result := CreateRectRgn(spLeft_Designer, spTop_Designer, spRight_Designer + 1, spBottom_Designer + 1)
  else
    Result := CreateRectRgn(spLeft_Designer - 10, spTop_Designer - 10, spRight_Designer + 11, spBottom_Designer + 11);
end;

procedure TRMView.SetFrameVisible(aVisible: Boolean);
begin
  LeftFrame.Visible := aVisible;
  RightFrame.Visible := aVisible;
  TopFrame.Visible := aVisible;
  BottomFrame.Visible := aVisible;
end;

function TRMView.GetUnits: TRMUnitType;
begin
  if (FParentReport <> nil) and (FParentReport.DocMode = rmdmDesigning) then
    Result := RMUnits
  else
    Result := rmutScreenPixels;
end;

function TRMView.DocMode: TRMDocMode;
begin
  if FParentReport <> nil then
    Result := FParentReport.DocMode
  else
    Result := rmdmDesigning;
end;

procedure TRMView.OnHook(View: TRMView);
begin
end;

procedure TRMView.Loaded;
begin
end;

procedure TRMView.Prepare;
begin
end;

procedure TRMView.UnPrepare;
begin
end;

function TRMView.GetProp(Index: string): Variant;
var
  lParams: array[0..0] of Variant;
  lValue: Variant;
begin
  if GetPropValue(Self, UpperCase(Index), lValue, lParams) then
    Result := lValue
  else
    Result := null;
end;

procedure TRMView.SetProp(Index: string; Value: Variant);
begin
  SetPropValue(Self, UpperCase(Index), Value);
end;

function TRMView.GetLeft(index: Integer): Double;
begin
  case index of
    0: Result := RMFromMMThousandths(FmmLeft, GetUnits);
    1: Result := RMFromMMThousandths(FmmTop, GetUnits);
    2: Result := RMFromMMThousandths(FmmWidth, GetUnits);
    3: Result := RMFromMMThousandths(FmmHeight, GetUnits);
  else
    Result := 0;
  end;
end;

procedure TRMView.SetLeft(Index: Integer; Value: Double);
begin
  case Index of
    0:
      begin
        if (FParentReport <> nil) and FParentReport.FDesigning then
        begin
          if (Restrictions * [rmrtDontModify, rmrtDontMove] <> []) or
            (RMDesigner.DesignerRestrictions * [rmdrDontModifyObj, rmdrDontMoveObj] <> []) then
            Exit;
        end;
        FmmLeft := RMToMMThousandths(Value, GetUnits);
      end;
    1:
      begin
        if (FParentReport <> nil) and FParentReport.FDesigning then
        begin
          if (Restrictions * [rmrtDontModify, rmrtDontMove] <> []) or
            (RMDesigner.DesignerRestrictions * [rmdrDontModifyObj, rmdrDontMoveObj] <> []) then
            Exit;
        end;
        FmmTop := RMToMMThousandths(Value, GetUnits);
      end;
    2:
      begin
        if (FParentReport <> nil) and FParentReport.FDesigning then
        begin
          if (Restrictions * [rmrtDontModify, rmrtDontSize] <> []) or
            (RMDesigner.DesignerRestrictions * [rmdrDontModifyObj, rmdrDontSizeObj] <> []) then
            Exit;
        end;
        FmmWidth := RMToMMThousandths(Value, GetUnits);
      end;
    3:
      begin
        if (FParentReport <> nil) and FParentReport.FDesigning then
        begin
          if (Restrictions * [rmrtDontModify, rmrtDontSize] <> []) or
            (RMDesigner.DesignerRestrictions * [rmdrDontModifyObj, rmdrDontSizeObj] <> []) then
            Exit;
        end;
        FmmHeight := RMToMMThousandths(Value, GetUnits);
      end;
  end;
end;

procedure TRMView.SetParentPage(Value: TRMCustomPage);
var
  lIndex: Integer;
begin
  if FParentPage <> Value then
  begin
    if FParentPage <> nil then
    begin
      lIndex := FParentPage.FObjects.IndexOf(Self);
      if lIndex >= 0 then
        FParentPage.Delete(lIndex);
    end;

    FParentPage := Value;
    if Value <> nil then
    begin
      Value.FObjects.Add(Self);
      if NeedCreateName and (StreamMode = rmsmDesigning) then
        CreateName(Value.FParentReport);
      FParentReport := Value.FParentReport;
    end;
  end;
end;

procedure TRMView.SetFillColor(Value: TColor);
begin
  FFillColor := Value;
end;

procedure TRMView.ClearContents;
begin
  FMemo.Clear;
end;

procedure TRMView.SetPropertyValue(aPropName: string; aValue: Variant);
var
  i: Integer;
  t: TRMView;
begin
  RMDesigner.BeforeChange;
  for i := 0 to RMDesigner.PageObjects.Count - 1 do
  begin
    t := RMDesigner.PageObjects[i];
    if t.Selected then
      RMSetPropValue(t, aPropName, aValue);
  end;
  RMDesigner.AfterChange;
end;

procedure TRMView.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    if Value <> '' then
    begin
      if (FParentReport <> nil) and FParentReport.FDesigning and
        (FParentReport.FindObject(Value) <> nil) then
        Exit;
    end;
    FName := Value;
  end;

  AfterChangeName;
  if FComponent <> nil then
    FComponent.Name := Value;
end;

procedure TRMView.CreateName(aReport: TRMReport);
var
  i: Integer;

  function _CheckUnique(aName: string): Boolean;
  begin
    Result := aReport.FindObject(aName) = nil;
    if Result then
    begin
      if not (Self is TRMDialogComponent) or (RMDialogForm.FindComponent(aName) = nil) then
        Result := True
      else
        Result := False;
    end;
  end;

begin
  FName := '';
  i := 1;
  while True do
  begin
    if _CheckUnique(UpperCase(BaseName + IntToStr(i))) then
    begin
      FName := BaseName + IntToStr(i);
      Name := FName;
      AfterChangeName;
      Break;
    end;
    Inc(i);
  end;
end;

procedure TRMView.CalcGaps;
var
  bx0, by0, bx1, by1: Integer;
  wx0, wy0, wx1, wy1: Integer;
begin
  mmSaveGapx := FmmGapLeft;
  mmSaveGapy := FmmGapTop;
  mmSaveLeft := FmmLeft;
  mmSaveTop := FmmTop;
  mmSaveWidth := FmmWidth;
  mmSaveHeight := FmmHeight;
  mmSaveFWLeft := FLeftFrame.FmmWidth;
  mmSaveFWTop := FTopFrame.FmmWidth;
  mmSaveFWRight := FRightFrame.FmmWidth;
  mmSaveFWBottom := FBottomFrame.FmmWidth;
  if DocMode = rmdmDesigning then
  begin
    OffsetLeft := 0;
    OffsetTop := 0;
    if FParentReport.FDesigning then
    begin
      FactorX := FParentReport.FDesigner.Factor / 100;
      FactorY := FParentReport.FDesigner.Factor / 100;
    end
    else
    begin
      FactorX := 1;
      FactorY := 1;
    end;
  end;

  FmmLeft := Round(FmmLeft * FactorX) + RMToMMThousandths(OffsetLeft, rmutScreenPixels);
  FmmTop := Round(FmmTop * FactorY) + RMToMMThousandths(OffsetTop, rmutScreenPixels);
  FmmWidth := Round(FmmWidth * FactorX);
  FmmHeight := Round(FmmHeight * FactorY);

  if Self is TRMCustomMemoView then
  begin
    SaveFontWidth := TRMCustomMemoView(Self).FFontScaleWidth;
    TRMCustomMemoView(Self).FFontScaleWidth := Round(FactorX * SaveFontWidth);
  end;

  FmmGapLeft := Round(FmmGapLeft * FactorX);
  FmmGapTop := Round(FmmGapTop * FactorY);

  if not FLeftFrame.Visible then
    FLeftFrame.FmmWidth := 0;
  if not FTopFrame.Visible then
    FTopFrame.FmmWidth := 0;
  if not FRightFrame.Visible then
    FRightFrame.FmmWidth := 0;
  if not FBottomFrame.Visible then
    FBottomFrame.FmmWidth := 0;

  wx0 := Round(RMFromMMThousandths(Round(FLeftFrame.FmmWidth * FactorX), rmutScreenPixels) / 2);
  wx1 := Round((RMFromMMThousandths(Round(FRightFrame.FmmWidth * FactorX), rmutScreenPixels) - 1) / 2);
  wy0 := Round(RMFromMMThousandths(Round(FTopFrame.FmmWidth * FactorX), rmutScreenPixels) / 2);
  wy1 := Round((RMFromMMThousandths(Round(FBottomFrame.FmmWidth * FactorX), rmutScreenPixels) - 1) / 2);

  FLeftFrame.FmmWidth := Round(FLeftFrame.FmmWidth * FactorX);
  FTopFrame.FmmWidth := Round(FTopFrame.FmmWidth * FactorX);
  FRightFrame.FmmWidth := Round(FRightFrame.FmmWidth * FactorX);
  FBottomFrame.FmmWidth := Round(FBottomFrame.FmmWidth * FactorX);

  bx0 := Round(RMFromMMThousandths(FmmLeft, rmutScreenPixels));
  by0 := Round(RMFromMMThousandths(FmmTop, rmutScreenPixels));
  bx1 := Round(RMFromMMThousandths(FmmLeft + FmmWidth, rmutScreenPixels));
  by1 := Round(RMFromMMThousandths(FmmTop + FmmHeight, rmutScreenPixels));

  Inc(bx0, wx0);
  Dec(bx1, wx1);
  Inc(by0, wy0);
  Dec(by1, wy1);
  RealRect := Rect(bx0, by0, bx1 + 1, by1 + 1);

  if LeftFrame.DoubleFrame then
    RealRect.Left := RealRect.Left + Round(RMFromMMThousandths(FLeftFrame.FmmWidth, rmutScreenPixels) * 2);
  if RightFrame.DoubleFrame then
    RealRect.Right := RealRect.Right - Round(RMFromMMThousandths(FRightFrame.FmmWidth, rmutScreenPixels) * 2);
  if TopFrame.DoubleFrame then
    RealRect.Top := RealRect.Top + Round(RMFromMMThousandths(FTopFrame.FmmWidth, rmutScreenPixels) * 2);
  if BottomFrame.DoubleFrame then
    RealRect.Bottom := RealRect.Bottom - Round(RMFromMMThousandths(FBottomFrame.FmmWidth, rmutScreenPixels) * 2);
end;

procedure TRMView.RestoreCoord;
begin
  FmmLeft := mmSaveLeft;
  FmmTop := mmSaveTop;
  FmmWidth := mmSaveWidth;
  FmmHeight := mmSaveHeight;
  FmmGapLeft := mmSaveGapX;
  FmmGapTop := mmSaveGapY;
  FLeftFrame.FmmWidth := mmSaveFWLeft;
  FTopFrame.FmmWidth := mmSaveFWTop;
  FRightFrame.FmmWidth := mmSaveFWRight;
  FBottomFrame.FmmWidth := mmSaveFWBottom;
  if Self is TRMCustomMemoView then
  begin
    TRMCustomMemoView(Self).FFontScaleWidth := SaveFontWidth;
  end;
end;

const
  aryBrushStyle: array[TBrushStyle] of Integer = (HS_BDIAGONAL, HS_BDIAGONAL, HS_HORIZONTAL,
    HS_VERTICAL, HS_FDIAGONAL, HS_DIAGCROSS, HS_CROSS, HS_BDIAGONAL);

procedure TRMView.ShowBackground;
var
  lFillColor: TColor;
  wx0, wy0, wx1, wy1: Integer;

  procedure _DrawBrushStyle;
  var
    lBrush: HBRUSH;
  begin
    begin
      lBrush := CreateHatchBrush(aryBrushStyle[FBrushStyle], ColorToRGB(FTopFrame.Color));
      try
        if DocMode = rmdmDesigning then
          Windows.FillRect(Canvas.Handle, RealRect, lBrush)
        else
          Windows.FillRect(Canvas.Handle, Rect(spLeft, spTop, spRight, spBottom), lBrush)
      finally
        Deleteobject(lBrush);
      end;
    end;
  end;

begin
  if (DocMode <> rmdmDesigning) and (FillColor = clNone) then
  begin
    if FBrushStyle <> bsSolid then
      _DrawBrushStyle;

    Exit;
  end;

  if DocMode = rmdmDesigning then //WHF Add,清除背景
  begin
    wx1 := Round(RightFrame.spWidth / 2);
    wx0 := Round((LeftFrame.spWidth - 1) / 2);
    wy1 := Round(BottomFrame.spWidth / 2);
    wy0 := Round((TopFrame.spWidth - 1) / 2);
    SetBkMode(Canvas.Handle, Opaque);
    Canvas.Brush.Color := clWhite;
    Canvas.FillRect(Rect(spLeft - wx0, spTop - wy0, spRight + wx1 + 1, spBottom + wy1 + 1));
  end;

  if (DocMode = rmdmDesigning) and (FillColor = clNone) then
    lFillColor := clWhite
  else
    lFillColor := FillColor;

  SetBkMode(Canvas.Handle, Opaque);
  Canvas.Brush.Color := lFillColor;
  if FBrushStyle = bsSolid then
  begin
    if DocMode = rmdmDesigning then
      Canvas.FillRect(RealRect)
    else
      Canvas.FillRect(Rect(spLeft, spTop, spRight, spBottom));
  end
  else
    _DrawBrushStyle;
end;

procedure TRMView.SetBounds(aLeft, aTop, aWidth, aHeight: Double);
begin
  FmmLeft := RMToMMThousandths(aLeft, rmutScreenPixels);
  FmmTop := RMToMMThousandths(aTop, rmutScreenPixels);
  FmmWidth := RMToMMThousandths(aWidth, rmutScreenPixels);
  FmmHeight := RMToMMThousandths(aHeight, rmutScreenPixels);
end;

procedure TRMView.SetspBounds(aLeft, aTop, aWidth, aHeight: Integer);
begin
  spLeft := aLeft;
  spTop := aTop;
  spWidth := aWidth;
  spHeight := aHeight;
end;

procedure TRMView.AfterChangeName;
begin
end;

procedure TRMView.InternalOnGetValue(aView: TRMReportView; aParName: string;
  var aParValue: string; aUnicode: Boolean);
begin
  FParentReport.InternalOnGetValue(aView, aParName, aParValue, aUnicode);
end;

procedure TRMView.InternalOnBeforePrint(Memo: TStrings; View: TRMReportView);
begin
  FParentReport.InternalOnBeforePrint(Memo, View);
end;

function TRMView._CalcVFrameWidth(aTopWidth, aBottomWidth: Double): Integer;
begin
  Result := 0;
  if TopFrame.Visible then
  begin
    Result := Result + Round(aTopWidth / 2);
    if TopFrame.DoubleFrame then
      Result := Result + Round(aTopWidth * 2);
  end;
  if BottomFrame.Visible then
  begin
    Result := Result + Round(aBottomWidth / 2);
    if BottomFrame.DoubleFrame then
      Result := Result + Round(aBottomWidth * 2);
  end;
end;

function TRMView._CalcHFrameWidth(aLeftWidth, aRightWidth: Double): Integer;
begin
  Result := 0;
  if LeftFrame.Visible then
  begin
    Result := Result + Round(aLeftWidth / 2);
    if LeftFrame.DoubleFrame then
      Result := Result + Round(aLeftWidth * 2);
  end;
  if RightFrame.Visible then
  begin
    Result := Result + Round(aRightWidth / 2);
    if RightFrame.DoubleFrame then
      Result := Result + Round(aRightWidth * 2);
  end;
end;

function TRMView._DrawRect: TRect;
begin
  Result.Left := spLeft - LeftFrame.spWidth;
  Result.Top := spTop - TopFrame.spWidth;
  Result.Right := spRight + RightFrame.spWidth div 2 + 1;
  Result.Bottom := spBottom + BottomFrame.spWidth div 2 + 1;
end;

function TRMView.GetPrinter: TRMPrinter;
begin
  if FParentReport <> nil then
    Result := FParentReport.MasterReport.ReportPrinter
  else
    Result := nil;

  if Result = nil then
    Result := RMPrinter;
end;

function TRMView.GetspLeft(Index: Integer): Integer;
begin
  case Index of
    0: Result := Round(RMFromMMThousandths(FmmLeft, rmutScreenPixels));
    1: Result := Round(RMFromMMThousandths(FmmTop, rmutScreenPixels));
    2: Result := Round(RMFromMMThousandths(FmmWidth, rmutScreenPixels));
    3: Result := Round(RMFromMMThousandths(FmmHeight, rmutScreenPixels));
    4: Result := Round(RMFromMMThousandths(FmmLeft + FmmWidth, rmutScreenPixels));
    5: Result := Round(RMFromMMThousandths(FmmTop + FmmHeight, rmutScreenPixels));
  else
    Result := 0;
  end;
end;

procedure TRMView.SetspLeft(Index: Integer; Value: Integer);
begin
  case Index of
    0: FmmLeft := RMToMMThousandths(Value, rmutScreenPixels);
    1: FmmTop := RMToMMThousandths(Value, rmutScreenPixels);
    2:
      begin
        FmmWidth := RMToMMThousandths(Value, rmutScreenPixels);
        if (Self is TRMDialogControl) and (TRMDialogControl(Self).FControl <> nil) then
        begin
          TRMDialogControl(Self).FControl.Width := Value;
        end;
      end;
    3:
      begin
        FmmHeight := RMToMMThousandths(Value, rmutScreenPixels);
        if (Self is TRMDialogControl) and (TRMDialogControl(Self).FControl <> nil) then
        begin
          TRMDialogControl(Self).FControl.Height := Value;
        end;
      end;
  end;
end;

function TRMView.GetspLeft_Designer(Index: Integer): Integer;
begin
  case Index of
    0: Result := RMToScreenPixels(FmmLeft * FParentReport.FDesigner.Factor / 100, rmutMMThousandths);
    1: Result := RMToScreenPixels(FmmTop * FParentReport.FDesigner.Factor / 100, rmutMMThousandths);
    2: Result := RMToScreenPixels(FmmWidth * FParentReport.FDesigner.Factor / 100, rmutMMThousandths);
    3: Result := RMToScreenPixels(FmmHeight * FParentReport.FDesigner.Factor / 100, rmutMMThousandths);
    4: Result := RMToScreenPixels((FmmLeft + FmmWidth) * FParentReport.FDesigner.Factor / 100, rmutMMThousandths);
    5: Result := RMToScreenPixels((FmmTop + FmmHeight) * FParentReport.FDesigner.Factor / 100, rmutMMThousandths);
  else
    Result := 0;
  end;
end;

procedure TRMView.SetspLeft_Designer(Index: Integer; Value: Integer);
var
  lOldLeft, lOldTop: Integer;

  procedure _SetChildPos;
  var
    i: Integer;
    t: TRMView;
  begin
    if Self.IsContainer then
    begin
      for i := 0 to ParentPage.Objects.Count - 1 do
      begin
        t := ParentPage.Objects[i];
        if (t is TRMDialogControl) and RMCmp(TRMDialogControl(t).FParentControl, Name) then
        begin
          t.spLeft := t.spLeft + (spLeft - lOldLeft);
          t.spTop := t.spTop + (spTop - lOldTop);
        end;
      end;
    end;
  end;

begin
  lOldLeft := spLeft;
  lOldTop := spTop;
  case Index of
    0:
      begin
        if (Restrictions * [rmrtDontModify, rmrtDontMove] = []) and
          (RMDesigner.DesignerRestrictions * [rmdrDontModifyObj, rmdrDontMoveObj] = []) then
        begin
          FmmLeft := RMToMMThousandths(Value * 100 / FParentReport.FDesigner.Factor, rmutScreenPixels);
          _SetChildPos;
        end;
      end;
    1:
      begin
        if (Restrictions * [rmrtDontModify, rmrtDontMove] = []) and
          (RMDesigner.DesignerRestrictions * [rmdrDontModifyObj, rmdrDontMoveObj] = []) then
        begin
          FmmTop := RMToMMThousandths(Value * 100 / FParentReport.FDesigner.Factor, rmutScreenPixels);
          _SetChildPos;
        end;
      end;
    2:
      begin
        if (Restrictions * [rmrtDontModify, rmrtDontSize] = []) and
          (RMDesigner.DesignerRestrictions * [rmdrDontModifyObj, rmdrDontSizeObj] = []) then
        begin
          FmmWidth := RMToMMThousandths(Value * 100 / FParentReport.FDesigner.Factor, rmutScreenPixels);
        end;
      end;
    3:
      begin
        if (Restrictions * [rmrtDontModify, rmrtDontSize] = []) and
          (RMDesigner.DesignerRestrictions * [rmdrDontModifyObj, rmdrDontSizeObj] = []) then
        begin
          FmmHeight := RMToMMThousandths(Value * 100 / FParentReport.FDesigner.Factor, rmutScreenPixels);
        end;
      end;
  end;
end;

procedure TRMView.SetMemo(Value: TStrings);
begin
  FMemo.Assign(Value);
end;

procedure TRMView.SetMemo1(Value: TStrings);
begin
  FMemo1.Assign(Value);
end;

function TRMView.GetWantHook: Boolean;
begin
  Result := (FFlags and flWantHook) = flWantHook;
end;

procedure TRMView.SetWantHook(const value: Boolean);
begin
  FFlags := (FFlags and not flWantHook);
  if Value then
    FFlags := FFlags + flWantHook;
end;

function TRMView.GetStretched: Boolean;
begin
  Result := (FFlags and flStretched) = flStretched;
end;

procedure TRMView.SetStretched(const value: Boolean);
begin
  FFlags := (FFlags and not flStretched);
  if Value then
    FFlags := FFlags + flStretched;
end;

function TRMView.GetStretchedMax: Boolean;
begin
  Result := (FFlags and flStretchedMax) = flStretchedMax;
end;

procedure TRMView.SetStretchedMax(const value: Boolean);
begin
  FFlags := (FFlags and not flStretchedMax);
  if Value then
    FFlags := FFlags + flStretchedMax;
end;

function TRMView.GetTransparent: Boolean;
begin
  Result := (FFlags and flTransparent) = flTransparent;
end;

procedure TRMView.SetTransparent(value: Boolean);
begin
  FFlags := (FFlags and not flTransparent);
  if Value then
    FFlags := FFlags + flTransparent;
end;

function TRMView.GetHideZeros: Boolean;
begin
  Result := (FFlags and flMemoHideZeros) = flMemoHideZeros;
end;

procedure TRMView.SetHideZeros(Value: Boolean);
begin
  FFlags := (FFlags and not flMemoHideZeros);
  if Value then
    FFlags := FFlags + flMemoHideZeros;
end;

function TRMView.GetDontUndo: Boolean;
begin
  Result := (FFlags and flDontUndo) = flDontUndo;
end;

procedure TRMView.SetDontUndo(Value: Boolean);
begin
  FFlags := (FFlags and not flDontUndo);
  if Value then
    FFlags := FFlags + flDontUndo;
end;

function TRMView.GetOnePerPage: Boolean;
begin
  Result := (FFlags and flOnePerPage) = flDontUndo;
end;

procedure TRMView.SetOnePerPage(Value: Boolean);
begin
  FFlags := (FFlags and not flOnePerPage);
  if Value then
    FFlags := FFlags + flOnePerPage;
end;

function TRMView.GetIsChildView: Boolean;
begin
  Result := (FFlags and flChildView) = flChildView;
end;

procedure TRMView.SetIsChildView(Value: Boolean);
begin
  FFlags := (FFlags and not flChildView);
  if Value then
    FFlags := FFlags + flChildView;
end;

function TRMView.GetUseDoublePass: Boolean;
begin
  Result := (FFlags and flUseDoublePass) = flUseDoublePass;
end;

procedure TRMView.SetUseDoublePass(Value: Boolean);
begin
  FFlags := (FFlags and not flUseDoublePass);
  if Value then
    FFlags := FFlags + flUseDoublePass;
end;

procedure TRMView.SetParentFont(Value: Boolean);
begin
  FParentFont := Value;
end;

procedure TRMView.SetStyle(Value: string);
begin
  FStyle := Value;
end;

procedure TRMView.SetFlowTo(Value: string);
begin
  FFlowTo := Value;
end;

procedure TRMView.SetTagStr(Value: string);
begin
  FTagStr := Value;
end;

procedure TRMView.SetUrl(Value: string);
begin
  FUrl := Value;
end;

function TRMView.GetViewCommon: string;
begin
  Result := '';
end;

function TRMView.GetParentBand: TRMBand;
var
  i: Integer;
  t: TRMView;
begin
  Result := nil;
  for i := 0 to RMDesigner.Page.Objects.Count - 1 do
  begin
    t := RMDesigner.Page.Objects[i];
    if t.isBand and (spLeft >= t.spLeft) and (spLeft <= t.spRight) and
      (spTop >= t.spTop) and (spTop <= t.spBottom) then
      Result := TRMBand(t);
  end;
end;

function TRMView.IsCrossView: Boolean;
begin
  Result := False;
end;

function TRMView.IsContainer: Boolean;
begin
  Result := False;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDialogComponent }

class procedure TRMDialogComponent.DefaultSize(var aKx, aKy: Integer);
begin
  aKx := 28;
  aKy := 28;
end;

constructor TRMDialogComponent.Create;
begin
  inherited Create;
  FBmpRes := 'RM_DialogComponent';
  spWidth := 28;
  spHeight := 28;

  FTabOrder := -1;
  FParentControl := '';
end;

destructor TRMDialogComponent.Destroy;
begin
  inherited Destroy;
end;

procedure TRMDialogComponent.BeginDraw(aCanvas: TCanvas);
begin
  Canvas := ACanvas;
  FParentReport.FCurrentView := Self;
end;

procedure TRMDialogComponent.PaintDesignControl;
var
  lBmp: TBitmap;
  //  lImageList: TImageList;
begin
  DrawEdge(Canvas.Handle, RealRect, EDGE_RAISED, BF_RECT);

  //  lImageList := TImageList.Create(nil);
  lBmp := TBitmap.Create;
  try
    lBmp.LoadFromResourceName(hInstance, FBmpRes);
    Canvas.Draw(RealRect.Left + 2, RealRect.Top + 2, lBmp);

    {    lImageList.Height := 24;
        lImageList.Width := 24;
        lImageList.AddMasked(lBmp, clOlive);
        ImageList_DrawEx(lImageList.Handle, 0, Canvas.Handle, RealRect.Left + 2, RealRect.Top + 2, 0, 0,
          clNone, clNone, ILD_Transparent);
  }finally
    lBmp.Free;
    //    lImageList.Free;
  end;
end;

procedure TRMDialogComponent.Draw(aCanvas: TCanvas);
begin
  spWidth := 28;
  spHeight := 28;
  BeginDraw(aCanvas);
  CalcGaps;
  FillColor := clBtnFace;
  ShowBackground;
  PaintDesignControl;
  RestoreCoord;
end;

procedure TRMDialogComponent.LoadFromStream(aStream: TStream);
var
  lVersion: Integer;
begin
  lVersion := RMReadWord(aStream); //版本号
  ObjectId := RMReadWord(aStream);
  FmmLeft := RMReadInt32(aStream);
  FmmTop := RMReadInt32(aStream);
  FmmWidth := RMReadInt32(aStream);
  FmmHeight := RMReadInt32(aStream);
  FFlags := RMReadLongWord(aStream);
  FRestrictions := TRMRestrictions(RMReadByte(aStream));
  FName := RMReadString(aStream);
  FVisible := RMReadBoolean(aStream);
  if StreamMode = rmsmDesigning then
  begin
    if lVersion >= 1 then
      LoadEventInfo(aStream);
    if lVersion >= 2 then
      FParentFont := RMReadBoolean(aStream);
  end;
  if lVersion >= 2 then
  begin
    FParentControl := RMReadString(aStream);
  end;
end;

procedure TRMDialogComponent.SaveToStream(aStream: TStream);
begin
  RMWriteWord(aStream, 2); //版本号
  RMWriteWord(aStream, ObjectID);
  RMWriteInt32(aStream, FmmLeft);
  RMWriteInt32(aStream, FmmTop);
  RMWriteInt32(aStream, FmmWidth);
  RMWriteInt32(aStream, FmmHeight);
  RMWriteLongWord(aStream, FFlags);
  RMWriteByte(aStream, Byte(FRestrictions));
  RMWriteString(aStream, Name);
  RMWriteBoolean(aStream, FVisible);
  if StreamMode = rmsmDesigning then
  begin
    SaveEventInfo(aStream);
    RMWriteBoolean(aStream, FParentFont);
  end;

  RMWriteString(aStream, FParentControl);
end;

procedure TRMDialogComponent.SetParentControl(Value: string);
begin
  FParentControl := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDialogControl }

constructor TRMDialogControl.Create;
begin
  inherited Create;

  spWidth := 0;
  spHeight := 0;
end;

destructor TRMDialogControl.Destroy;
begin
  inherited Destroy;
end;

procedure TRMDialogControl.FreeChildViews;
begin
  while TWinControl(FControl).ControlCount > 0 do
    TWinControl(FControl).Controls[0].Parent := FControl.Parent;
end;

procedure TRMDialogControl.PaintDesignControl;
var
  lBmp: TBitmap;
  lDC: HDC;
  lSaveH: HGDIOBJ;
  x, y, dx, dy: Integer;
begin
  x := spLeft;
  y := spTop;
  dx := spWidth;
  dy := spHeight;
  lBmp := TBitmap.Create;
  lBmp.Width := dx + 1;
  lBmp.Height := dy + 1;
  lBmp.Canvas.Brush.Color := clBtnFace;
  lBmp.Canvas.FillRect(Rect(0, 0, dx + 1, dy + 1));

  FControl.Left := 0;
  FControl.Top := 0;
  lDC := CreateCompatibleDC(0);
  lSaveH := SelectObject(lDC, lBmp.Handle);
  try
    if not RMDialogForm.Visible then
      RMDialogForm.Show;

    if FControl is TWinControl then
      FControl.Perform(WM_PRINT, lDC, PRF_CLIENT + PRF_ERASEBKGND + PRF_NONCLIENT)
    else
    begin
      FControl.Perform(WM_ERASEBKGND, lDC, lDC);
      FControl.Perform(WM_PAINT, lDC, lDC);
    end;
  finally
    SelectObject(lDC, lSaveH);
    DeleteDC(lDC);
    Canvas.Draw(x, y, lBmp);
    lBmp.Free;
  end;
end;

procedure TRMDialogControl.Draw(aCanvas: TCanvas);
var
  i: Integer;
  t: TRMView;
begin
  BeginDraw(aCanvas);
  Control.Width := spWidth;
  Control.Height := spHeight;
  CalcGaps;
  PaintDesignControl;

  if Self.IsContainer then
  begin
    for i := 0 to ParentPage.Objects.Count - 1 do
    begin
      t := ParentPage.Objects[i];
      if (t is TRMDialogControl) and RMCmp(TRMDialogControl(t).FParentControl, Name) then
        t.Draw(aCanvas);
    end;
  end;

  RestoreCoord;
end;

function TRMDialogControl.GetFont: TFont;
begin
  Result := nil;
end;

procedure TRMDialogControl.SetFont(Value: TFont);
begin
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMReportView }

constructor TRMReportView.Create;
begin
  inherited Create;
  FDataSet := nil;

  FBandAlign := rmbaNone;
  FFillColor := clNone;
  spGapLeft := 2;
  spGapTop := 2;
  FactorX := 1;
  FactorY := 1;
  StreamMode := rmsmDesigning;

  PrintFrame := True;
  Printable := True;
  FormatFlag.FormatIndex1 := 0;
  FormatFlag.FormatIndex2 := 0;
  FormatFlag.FormatdelimiterChar := DecimalSeparator;
  FormatFlag.FormatPercent := 2;
end;

destructor TRMReportView.Destroy;
begin
  inherited Destroy;
end;

procedure TRMReportView.OnStretchedClick(Sender: TObject);
begin
  SetPropertyValue('Stretched', not TRMMenuItem(Sender).Checked);
end;

procedure TRMReportView.OnStretchedMaxClick(Sender: TObject);
begin
  SetPropertyValue('StretchedMax', not TRMMenuItem(Sender).Checked);
end;

procedure TRMReportView.OnVisibleClick(Sender: TObject);
begin
  SetPropertyValue('Visible', not TRMMenuItem(Sender).Checked);
end;

procedure TRMReportView.OnPrintableClick(Sender: TObject);
begin
  SetPropertyValue('Printable', not TRMMenuItem(Sender).Checked);
end;

procedure TRMReportView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
var
  m: TRMMenuItem;
begin
  aPopup.Add(RMNewLine());

  if Self is TRMStretcheableView then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SStretched);
    m.OnClick := OnStretchedClick;
    m.Checked := Stretched;
    aPopup.Add(m);

    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(rmRes + 882);
    m.OnClick := OnStretchedMaxClick;
    m.Checked := StretchedMax;
    aPopup.Add(m);
  end;

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(rmRes + 879);
  m.OnClick := OnVisibleClick;
  m.Checked := Visible;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(rmRes + 880);
  m.OnClick := OnPrintableClick;
  m.Checked := Printable;
  aPopup.Add(m);
end;

procedure TRMReportView.ExportData;
begin
end;

procedure TRMReportView.BeginDraw(aCanvas: TCanvas);
var
  lPage: TRMReportPage;
  lBand: TRMBand;
begin
  Canvas := ACanvas;
  FParentReport.FCurrentView := Self;

  if (Self is TRMCustomMemoView) and (TRMCustomMemoView(Self).Font.Height > 0) then
    TRMCustomMemoView(Self).Font.Height := -TRMCustomMemoView(Self).Font.Height;

  if DocMode = rmdmDesigning then
    lPage := TRMReportPage(RMDesigner.Page)
  else
    lPage := TRMReportPage(FParentReport.CurrentPage);

  lBand := nil;
  if (BandAlign <> rmbaNone) or ParentWidth or ParentHeight then
  begin
    if DocMode = rmdmDesigning then
      lBand := GetParentBand
    else
      lBand := FParentReport.CurrentBand;
  end;

  if lBand = nil then Exit;

  case BandAlign of
    rmbaLeft:
      begin
        if lBand.BandType in [rmbtCrossHeader..rmbtCrossFooter] then
          FmmLeft := lBand.FmmLeft
        else
          FmmLeft := 0;
      end;
    rmbaRight:
      begin
        if lBand.BandType in [rmbtCrossHeader..rmbtCrossFooter] then
          FmmLeft := lBand.FmmLeft + lBand.FmmWidth - FmmWidth
        else
          spLeft := lPage.PrinterInfo.PageWidth - lPage.spMarginLeft - lPage.spMarginRight - spWidth;
      end;
    rmbaBottom:
      begin
        if lBand.BandType in [rmbtCrossHeader..rmbtCrossFooter] then
        begin
        end
        else
          FmmTop := lBand.FmmTop + lBand.FmmHeight - FmmHeight;
      end;
    rmbaTop:
      begin
        if lBand.BandType in [rmbtCrossHeader..rmbtCrossFooter] then
        begin
        end
        else
          FmmTop := lBand.FmmTop;
      end;
    rmbaCenter:
      begin
        if lBand.BandType in [rmbtCrossHeader..rmbtCrossFooter] then
        begin
          spLeft := lBand.spLeft + (lBand.spWidth - spWidth) div 2;
        end
        else
        begin
          spLeft := (lPage.PrinterInfo.PageWidth - lPage.spMarginLeft - lPage.spMarginRight - spWidth) div 2;
        end;
      end;
  end;

  if ParentWidth then
  begin
    if lBand.BandType in [rmbtCrossHeader..rmbtCrossFooter] then
    begin
      FmmWidth := lBand.FmmWidth;
    end
    else
    begin
      FmmLeft := 0;
      spWidth := lPage.PrinterInfo.PageWidth - lPage.spMarginLeft - lPage.spMarginRight;
    end;
  end;

  if ParentHeight then
  begin
    if lBand.BandType in [rmbtCrossHeader..rmbtCrossFooter] then
    begin
    end
    else
    begin
      FmmTop := lBand.FmmTop;
      FmmHeight := lBand.FmmHeight;
    end;
  end;
end;

procedure TRMReportView.SetFactorFont(aCanvas: TCanvas);
begin
  with aCanvas do
  begin
    if FactorY = 1 then
    begin
      Font.Height := -Round(Font.Size * 96 / 72);
    end
    else
      Font.Height := -Trunc(Font.Size * 96 / 72 * FactorY);
  end;
end;

function TRMReportView.GetFactorSize(aValue: Integer): Integer;
begin
  Result := Round(aValue * FParentReport.FDesigner.Factor / 100);
end;

function TRMReportView.GetClipRgn(rt: TRMRgnType): HRGN;
var
  bx, by, bx1, by1: Integer;
  wx, wx1, wy, wy1: Integer;
begin
  wx := Round(LeftFrame.spWidth / 2 * FParentReport.FDesigner.Factor / 100);
  wx1 := Round((RightFrame.spWidth - 1) / 2 * FParentReport.FDesigner.Factor / 100);
  wy := Round(TopFrame.spWidth / 2 * FParentReport.FDesigner.Factor / 100);
  wy1 := Round((BottomFrame.spWidth - 1) / 2 * FParentReport.FDesigner.Factor / 100);

  bx := spLeft_Designer;
  by := spTop_Designer;
  bx1 := spRight_Designer + 1;
  by1 := spBottom_Designer + 1;

  if LeftFrame.Visible then
    Dec(bx, wx);
  if RightFrame.Visible then
    Inc(bx1, wx1);
  if TopFrame.Visible then
    Dec(by, wy);
  if BottomFrame.Visible then
    Inc(by1, wy1);

  if rt = rmrtNormal then
    Result := CreateRectRgn(bx, by, bx1, by1)
  else
    Result := CreateRectRgn(bx - 10, by - 10, bx1 + 10, by1 + 10);
end;

//function TRMReportView.GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant): Boolean;
//begin
//end;
//function TRMReportView.SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean;
//begin
//end;

procedure TRMReportView.LoadFromStream(aStream: TStream);
var
  lVersion: Integer;
  lStr: string;

  procedure _ReadOneFrame(var aFrameLine: TRMFrameLine);
  var
    lStyle: Integer;
  begin
    aFrameLine.Visible := RMReadBoolean(aStream);
    lStyle := RMReadByte(aStream);
    aFrameLine.Color := RMReadInt32(aStream);
    aFrameLine.FmmWidth := RMReadInt32(aStream);
    if lVersion >= 1 then
    begin
      aFrameLine.DoubleFrame := RMReadBoolean(aStream);
      aFrameLine.Style := TPenStyle(lStyle);
    end
    else
    begin
      if lStyle > 6 then
      begin
        aFrameLine.DoubleFrame := True;
        aFrameLine.Style := psSolid;
      end
      else
      begin
        aFrameLine.DoubleFrame := False;
        aFrameLine.Style := TPenStyle(lStyle);
      end;
    end;
  end;

begin
  lVersion := RMReadWord(aStream); //版本号
  FName := RMReadString(aStream);
  Name := FName;
  FmmLeft := RMReadInt32(aStream);
  FmmTop := RMReadInt32(aStream);
  FmmWidth := RMReadInt32(aStream);
  FmmHeight := RMReadInt32(aStream);
  FmmGapLeft := RMReadInt32(aStream);
  FmmGapTop := RMReadInt32(aStream);
  FFlags := RMReadLongWord(aStream);
  FFillColor := RMReadInt32(aStream);
  FBandAlign := TRMBandAlign(RMReadByte(aStream));
  FRestrictions := TRMRestrictions(RMReadByte(aStream));

  _ReadOneFrame(FLeftFrame);
  _ReadOneFrame(FTopFrame);
  _ReadOneFrame(FRightFrame);
  _ReadOneFrame(FBottomFrame);
  FLeftRightFrame := RMReadWord(aStream);
  FVisible := RMReadBoolean(aStream);

  if StreamMode = rmsmDesigning then
  begin
    ObjectID := RMReadWord(aStream);
    FDisplayFormat := RMReadString(aStream);
    RMReadMemo(aStream, FMemo);
    FShiftWith := RMReadString(aStream);
    FStretchWith := RMReadString(aStream);
    aStream.ReadBuffer(FormatFlag, SizeOf(FormatFlag));
    if lVersion >= 2 then
      LoadEventInfo(aStream);
    if lVersion >= 3 then
      FParentFont := RMReadBoolean(aStream);
    if lVersion >= 5 then
    begin
      FBrushStyle := TBrushStyle(RMReadByte(aStream));
      FTag := RMReadInt32(aStream);
      FTagStr := RMReadString(aStream);
      FUrl := RMReadString(aStream);
      FFlowTo := RMReadString(aStream);
      FStyle := RMReadString(aStream);
    end;
    if lVersion >= 6 then
    begin
      FCursor := RMReadInt32(aStream);
      FExpressionDelimiters := RMReadString(aStream);
    end;
  end
  else
  begin
    RMReadMemo(aStream, FMemo);
    if lVersion >= 5 then
    begin
      FBrushStyle := TBrushStyle(RMReadByte(aStream));
    end;
    if lVersion >= 6 then
    begin
      FCursor := RMReadInt32(aStream);
      lStr := RMReadString(aStream);
      if lStr <> '' then
        PropVars['OnPreviewClick'] := lStr;
    end;
    if lVersion >= 7 then
      FUrl := RMReadString(aStream);
  end;

  if lVersion <= 3 then
    StretchedMax := True;
end;

procedure TRMReportView.SavetoStream(aStream: TStream);
var
  lValue: Variant;
  lTmpStr: string;

  procedure _WriteOneFrame(aFrameLine: TRMFrameLine);
  begin
    RMWriteBoolean(aStream, aFrameLine.Visible);
    RMWriteByte(aStream, Byte(aFrameLine.Style));
    RMWriteInt32(aStream, aFrameLine.Color);
    RMWriteInt32(aStream, aFrameLine.FmmWidth);
    RMWriteBoolean(aStream, aFrameLine.DoubleFrame);
  end;

begin
  if StreamMode <> rmsmDesigning then
  begin
    //    FBandAlign := rmbaNone;
    //    ParentHeight := False;
    //    ParentWidth := False;
  end;

  RMWriteWord(aStream, 7); //版本号
  RMWriteString(aStream, Name);
  RMWriteInt32(aStream, FmmLeft);
  RMWriteInt32(aStream, FmmTop);
  RMWriteInt32(aStream, FmmWidth);
  RMWriteInt32(aStream, FmmHeight);
  RMWriteInt32(aStream, FmmGapLeft);
  RMWriteInt32(aStream, FmmGapTop);
  RMWriteLongWord(aStream, FFlags);
  RMWriteInt32(aStream, FFillColor);
  RMWriteByte(aStream, Byte(FBandAlign));
  RMWriteByte(aStream, Byte(FRestrictions));

  _WriteOneFrame(FLeftFrame);
  _WriteOneFrame(FTopFrame);
  _WriteOneFrame(FRightFrame);
  _WriteOneFrame(FBottomFrame);
  RMWriteWord(aStream, FLeftRightFrame);
  RMWriteBoolean(aStream, FVisible);

  if StreamMode = rmsmDesigning then
  begin
    RMWriteWord(aStream, ObjectID);
    RMWriteString(aStream, FDisplayFormat);
    RMWriteMemo(aStream, FMemo);
    RMWriteString(aStream, FShiftWith);
    RMWriteString(aStream, FStretchWith);
    aStream.WriteBuffer(FormatFlag, SizeOf(FormatFlag));
    SaveEventInfo(aStream);
    RMWriteBoolean(aStream, FParentFont);
    RMWriteByte(aStream, Integer(FBrushStyle));
    RMWriteInt32(aStream, FTag);
    RMWriteString(aStream, FTagStr);
    RMWriteString(aStream, FUrl);
    RMWriteString(aStream, FFlowTo);
    RMWriteString(aStream, FStyle);
    RMWriteInt32(aStream, FCursor);
    RMWriteString(aStream, FExpressionDelimiters);
  end
  else
  begin
    RMWriteMemo(aStream, FMemo1);
    RMWriteByte(aStream, Integer(FBrushStyle));
    RMWriteInt32(aStream, FCursor);
    lTmpStr := '';
    if FPropVars <> nil then
    begin
      lValue := PropVars['OnPreviewClick'];
      if lValue <> Null then
        lTmpStr := string(lValue);
    end;

    RMWriteString(aStream, lTmpStr);
    RMWriteString(aStream, FUrl);
  end;
end;

procedure TRMReportView.Prepare;
begin
  if (FParentReport.MasterReport.DoublePass and FParentReport.MasterReport.FinalPass) then Exit;
end;

const
  PenStyles: array[Low(TPenStyle)..High(TPenStyle)] of DWORD =
  (PS_SOLID, PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT, PS_NULL, PS_INSIDEFRAME);

procedure TRMReportView.ShowFrame;
var
  tb, lbr: {$IFDEF Delphi4}tagLOGBRUSH{$ELSE}TLogBrush{$ENDIF};
  NewH, OldH: HGDIOBJ;
  lx0, ly0, x1, y1: Integer;

  procedure _Line(x, y, dx, dy: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x + dx, y + dy);
  end;

  procedure _Line1(x, y, x1, y1: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x1, y1);
  end;

  procedure _SetPS(b: TRMFrameLine; w: integer);
  begin
    tb.lbStyle := BS_SOLID;
    tb.lbColor := b.Color;
    NewH := ExtCreatePen(PS_GEOMETRIC + PS_ENDCAP_SQUARE + PenStyles[b.Style], w, tb, 0, nil);
    OldH := SelectObject(Canvas.Handle, NewH);
  end;

  procedure _DrawFrame(const x, y, x1, y1: Integer; b: TRMFrameLine; aFlag: Byte);
  begin
    if not b.Visible then Exit;
    _SetPS(b, Round(RMFromMMThousandths(b.FmmWidth, rmutScreenPixels)));
    if b.DoubleFrame then
    begin
      if x = x1 then
      begin
        MoveToEx(Canvas.Handle, x, y, nil);
        LineTo(Canvas.Handle, x1, y1);
        if aFlag = 1 then
        begin
          MoveToEx(Canvas.Handle, x + Round(b.Width * 2), y, nil);
          LineTo(Canvas.Handle, x1 + Round(b.Width * 2), y1);
        end
        else
        begin
          MoveToEx(Canvas.Handle, x - Round(b.Width * 2), y, nil);
          LineTo(Canvas.Handle, x1 - Round(b.Width * 2), y1);
        end;
      end
      else
      begin
        MoveToEx(Canvas.Handle, x, y, nil);
        LineTo(Canvas.Handle, x1, y1);
        if aFlag = 2 then
        begin
          MoveToEx(Canvas.Handle, x, y + Round(b.Width * 2), nil);
          LineTo(Canvas.Handle, x1, y1 + Round(b.Width * 2));
        end
        else
        begin
          MoveToEx(Canvas.Handle, x, y - Round(b.Width * 2), nil);
          LineTo(Canvas.Handle, x1, y1 - Round(b.Width * 2));
        end;
      end;
    end
    else
    begin
      MoveToEx(Canvas.Handle, x, y, nil);
      LineTo(Canvas.Handle, x1, y1);
    end;
    SelectObject(Canvas.Handle, OldH);
    DeleteObject(NewH);
  end;

  procedure _DrawRectangle(const x, y, x1, y1: Integer);
  var
    nbr, obr: HBRUSH;
    i, iCount, liOffx: Integer;
  begin
    _SetPS(LeftFrame, Round(RMFromMMThousandths(LeftFrame.FmmWidth, rmutScreenPixels)));
    lbr.lbStyle := BS_NULL;
    nbr := CreateBrushIndirect(lbr);
    obr := SelectObject(Canvas.Handle, nbr);

    if LeftFrame.DoubleFrame then
    begin
      iCount := 0;
      liOffx := 0;
    end
    else
    begin
      iCount := 1;
      liOffx := 0; //-Round(LeftFrame.Width);
    end;
    for i := 0 to iCount do
    begin
      MoveToEx(Canvas.Handle, x + liOffx, y + liOffx, nil); // Left
      LineTo(Canvas.Handle, x + liOffx, y1 - liOffx);

      MoveToEx(Canvas.Handle, x + liOffx, y + liOffx, nil); // Top
      LineTo(Canvas.Handle, x1 - liOffx, y + liOffx);

      MoveToEx(Canvas.Handle, x1 - liOffx, y + liOffx, nil); // Right
      LineTo(Canvas.Handle, x1 - liOffx, y1 - liOffx);

      MoveToEx(Canvas.Handle, x + liOffx, y1 - liOffx, nil); // Bottom
      LineTo(Canvas.Handle, x1 - liOffx, y1 - liOffx);

      Inc(liOffx, Round(LeftFrame.Width * 2));
    end;

    SelectObject(Canvas.Handle, obr);
    DeleteObject(nbr);
    SelectObject(Canvas.Handle, OldH);
    DeleteObject(NewH);
  end;

begin
  if (FParentReport.DocMode <> rmdmDesigning) and (not LeftFrame.Visible) and (not TopFrame.Visible) and
    (not RightFrame.Visible) and (not BottomFrame.Visible) and (LeftRightFrame = 0) then
    Exit;
  if (FParentReport.DocMode <> rmdmDesigning) and (not FParentReport.Flag_PrintBackGroundPicture)
    and (not PrintFrame) then
    Exit;

  lx0 := spLeft;
  ly0 := spTop;
  x1 := Round(RMFromMMThousandths(Round((mmSaveLeft + mmSaveWidth) * FactorX), rmutScreenPixels) + OffsetLeft);
  y1 := Round(RMFromMMThousandths(Round((mmSaveTop + mmSaveHeight) * FactorY), rmutScreenPixels) + OffsetTop);

  with Canvas do
  begin
    Brush.Style := bsSolid;
    Pen.Style := psSolid;
    if (FParentReport.DocMode = rmdmDesigning) and (Width > 0) and (Height > 0) then
    begin
      Pen.Color := clBlack;
      Pen.Width := 1;
      _Line(lx0, ly0 + 3, 0, -3);
      _Line(lx0, ly0, 4, 0);
      _Line(lx0, y1 - 3, 0, 3);
      _Line(lx0, y1, 4, 0);
      _Line(x1 - 3, ly0, 3, 0);
      _Line(x1, ly0, 0, 4);
      _Line(x1 - 3, y1, 3, 0);
      _Line(x1, y1, 0, -4);
    end;
  end;

  if (TopFrame.Visible and LeftFrame.Visible and BottomFrame.Visible and RightFrame.Visible) and
    ((TopFrame.Style = LeftFrame.Style) and (TopFrame.Style = BottomFrame.Style) and (TopFrame.Style = RightFrame.Style)) and
    ((TopFrame.Color = LeftFrame.Color) and (TopFrame.Color = BottomFrame.Color) and (TopFrame.Color = RightFrame.Color)) and
    ((TopFrame.FmmWidth = LeftFrame.FmmWidth) and (TopFrame.Width = BottomFrame.FmmWidth) and (TopFrame.FmmWidth = RightFrame.FmmWidth)) then
    _DrawRectangle(lx0, ly0, x1, y1)
  else
  begin
    _DrawFrame(lx0, ly0, lx0, y1, LeftFrame, 1);
    _DrawFrame(lx0, ly0, x1, ly0, TopFrame, 2);
    _DrawFrame(x1, ly0, x1, y1, RightFrame, 3);
    _DrawFrame(lx0, y1, x1, y1, BottomFrame, 4);
  end;

  if LeftRightFrame > 0 then
  begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Pen.Style := psSolid;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := clBlack;
    case LeftRightFrame of
      1: _Line1(lx0, ly0, x1, y1);
      2:
        begin
          _Line1(lx0, ly0, lx0 + (x1 - lx0) div 2, y1);
          _Line1(lx0, ly0, x1, ly0 + (y1 - ly0) div 2);
        end;
      3:
        begin
          _Line1(lx0, ly0, x1, y1);
          _Line1(lx0, ly0, lx0 + (x1 - lx0) div 2, y1);
          _Line1(lx0, ly0, x1, ly0 + (y1 - ly0) div 2);
        end;
      4: _Line1(lx0, y1, x1, ly0);
      5:
        begin
          _Line1(lx0, ly0 + (y1 - ly0) div 2, x1, ly0);
          _Line1(lx0 + (x1 - lx0) div 2, y1, x1, ly0);
        end;
      6:
        begin
          _Line1(lx0, y1, x1, ly0);
          _Line1(lx0, ly0 + (y1 - ly0) div 2, x1, ly0);
          _Line1(lx0 + (x1 - lx0) div 2, y1, x1, ly0);
        end;
    end;
  end;
end;

procedure TRMReportView.ExpandVariables(var aStr: string);
var
  lStartPos, lEndPos, lStrLen: Integer;
  s1, s2: string;
begin
  lStartPos := 1;
  FParentReport.FNeedAddBreakedVariable := True;
  try
    repeat
      lStrLen := Length(aStr);
      while lStartPos < lStrLen do
      begin
        if aStr[lStartPos] in LeadBytes then
          Inc(lStartPos)
        else if aStr[lStartPos] = '[' then
          Break;

        Inc(lStartPos);
      end;

      s1 := RMGetBrackedVariable(aStr, lStartPos, lEndPos);
      if lStartPos <> lEndPos then
      begin
        Delete(aStr, lStartPos, lEndPos - lStartPos + 1);
        s2 := '';
        FParentReport.InternalOnGetValue(Self, s1, s2, False);
        Insert(s2, aStr, lStartPos);
        Inc(lStartPos, Length(s2));
        lEndPos := 0;
      end;
    until lStartPos = lEndPos;
  finally
    FParentReport.FNeedAddBreakedVariable := False;
  end;
end;

procedure TRMReportView.PlaceOnEndPage(aStream: TStream);

  procedure _ExpandMemoVariables;
  var
    i: Integer;
    s: string;
  begin
    FMemo1.Clear;
    if FParentReport.Flag_TableEmpty then
      Exit;
    for i := 0 to Memo.Count - 1 do
    begin
      s := Memo[i];
      if (s <> '') and (not TextOnly) then
        ExpandVariables(s);
      if s <> '' then
        FMemo1.Text := FMemo1.Text + s
      else
        FMemo1.Add('');
    end;
  end;

begin
  BeginDraw(Canvas);
  FMemo1.Assign(Memo);
  if Assigned(FOnBeforePrint) then
    FOnBeforePrint(Self);
  _ExpandMemoVariables;
  FParentReport.InternalOnBeforePrint(FMemo1, Self);
  if not Visible then Exit;

  RMWriteByte(aStream, Typ);
  if Typ = rmgtAddIn then
    RMWriteString(aStream, ClassName);
  SaveToStream(aStream);
end;

procedure TRMReportView.GetBlob;
begin
end;

function TRMReportView.GetGapX(Index: Integer): Double;
begin
  case Index of
    0: Result := RMFromMMThousandths(FmmGapLeft, GetUnits);
    1: Result := RMFromMMThousandths(FmmGapTop, GetUnits);
  else
    Result := 0;
  end;
end;

procedure TRMReportView.SetGapX(Index: Integer; Value: Double);
begin
  case Index of
    0: FmmGapLeft := RMToMMThousandths(Value, GetUnits);
    1: FmmGapTop := RMToMMThousandths(Value, GetUnits);
  end;
end;

function TRMReportView.GetspGapX(Index: Integer): Integer;
begin
  case Index of
    0: Result := Round(RMFromMMThousandths(FmmGapLeft, rmutScreenPixels));
    1: Result := Round(RMFromMMThousandths(FmmGapTop, rmutScreenPixels));
  else
    Result := 0;
  end;
end;

procedure TRMReportView.SetspGapX(Index: Integer; Value: Integer);
begin
  case Index of
    0: FmmGapLeft := RMToMMThousandths(Value, rmutScreenPixels);
    1: FmmGapTop := RMToMMThousandths(Value, rmutScreenPixels);
  end;
end;

function TRMReportView.GetDataField: string;
begin
  if Memo.Count > 0 then
    Result := Memo[0]
  else
    Result := '';
end;

procedure TRMReportView.SetDataField(Value: string);
begin
  Memo.Text := Value;
end;

procedure TRMReportView.SetDisplayFormat(Value: string);
begin
  FDisplayFormat := Value;
  RMGetFormatStr_1(FDisplayFormat, FormatFlag);
end;

function TRMReportView.GetPrintFrame: Boolean;
begin
  Result := (FFlags and flPrintFrame) = flPrintFrame;
end;

procedure TRMReportView.SetPrintFrame(Value: Boolean);
begin
  FFlags := (FFlags and not flPrintFrame);
  if Value then
    FFlags := FFlags + flPrintFrame;
end;

function TRMReportView.GetPrintable: Boolean;
begin
  Result := (FFlags and flPrintVisible) = flPrintVisible;
end;

procedure TRMReportView.SetPrintable(Value: Boolean);
begin
  FFlags := (FFlags and not flPrintVisible);
  if Value then
    FFlags := FFlags + flPrintVisible;
end;

function TRMReportView.GetTextOnly: Boolean;
begin
  Result := (FFlags and flTextOnly) = flTextOnly;
end;

procedure TRMReportView.SetTextOnly(Value: Boolean);
begin
  FFlags := (FFlags and not flTextOnly);
  if Value then
    FFlags := FFlags + flTextOnly;
end;

function TRMReportView.GetReprintOnOverFlow: Boolean;
begin
  Result := (FFlags and flReprintOnOverFlow) = flReprintOnOverFlow;
end;

procedure TRMReportView.SetReprintOnOverFlow(Value: Boolean);
begin
  FFlags := (FFlags and not flReprintOnOverFlow);
  if Value then
    FFlags := FFlags + flReprintOnOverFlow;
end;

function TRMReportView.GetParentWidth: Boolean;
begin
  Result := (FFlags and flParentWidth) = flParentWidth;
end;

procedure TRMReportView.SetParentWidth(Value: Boolean);
begin
  FFlags := (FFlags and not flParentWidth);
  if Value then
    FFlags := FFlags + flParentWidth;
end;

function TRMReportView.GetParentHeight: Boolean;
begin
  Result := (FFlags and flParentHeight) = flParentHeight;
end;

procedure TRMReportView.SetParentHeight(Value: Boolean);
begin
  FFlags := (FFlags and not flParentHeight);
  if Value then
    FFlags := FFlags + flParentHeight;
end;

procedure TRMReportView.SetShiftWith(Value: string);
begin
  if Value <> '' then
    FStretchWith := '';
  FShiftWith := Value;
end;

procedure TRMReportView.SetStretchWith(Value: string);
begin
  if Value <> '' then
    FShiftWith := '';
  FStretchWith := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TRMStretcheableView.Create;
begin
  inherited Create;

  DrawMode := rmdmAll;
  StretchedMax := True;
end;

destructor TRMStretcheableView.Destroy;
begin
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCustomMemoView }

constructor TRMCustomMemoView.Create;
begin
  inherited Create;
  Typ := rmgtMemo;
  BaseName := 'Memo';

  CurStrNo := 0;
  FSMemo := TStringList.Create;
  FFont := TFont.Create;
  FFont.Name := 'Arial';
  FFont.Size := 10;
  FFont.Color := clBlack;
  FFont.Charset := RMCharset;

  FHighlight := TRMHighlight.Create;
  FHighlight.Font.Color := clBlack;
  FHighlight.Font.Style := [fsBold];

  Stretched := False;
  HideZeros := True;
  WordWrap := False;

  FHAlign := rmHLeft;
  FVAlign := rmVTop;
  FLineSpacing := 2;
  FCharacterSpacing := 0;
  FRotationType := rmrtNone;
  FScaleFontType := rmstNone;
  FontScaleWidth := 0;
  FDisplayBeginLine := -1;
  FDisplayEndLine := -1;

  FRepeatedOptions := TRMRepeatedOptions.Create;
  FLastValuePage := -1;
end;

destructor TRMCustomMemoView.Destroy;
begin
  FSMemo.Free;
  FFont.Free;
  FHighlight.Free;
  FRepeatedOptions.Free;
  inherited Destroy;
end;

procedure TRMCustomMemoView.ShowEditor;
begin
  RMDesigner.MemoViewEditor(Self);
end;

function TRMCustomMemoView.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
var
  lStr: string;
begin
  Result := True;
  if aPropName = 'LASTVALUE' then
  begin
    lStr := FLastValue;
    if lStr <> '' then
      aValue := System.Copy(lStr, 1, Length(lStr) - 2)
    else
      aValue := lStr;
  end
  else if (aPropName = 'VALUECHANGED') or (aPropName = 'LASTVALUECHANGED') then
    aValue := FLastValueChanged
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

function TRMCustomMemoView.SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean;
begin
  Result := True;
  if aPropName = 'LASTVALUE' then
    FLastValue := aValue
  else if (aPropName = 'VALUECHANGED') or (aPropName = 'LASTVALUECHANGED') then
    FLastValueChanged := aValue
  else
    Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

procedure TRMCustomMemoView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
var
  m: TRMMenuItem;
begin
  aPopup.Add(RMNewLine());

  m := TRMMenuItem.Create(aPopup); // 字体
  m.Caption := RMLoadStr(SFont);
  m.OnClick := RMDesigner.RMFontEditor;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup); // 显示格式
  m.Caption := RMLoadStr(SVarFormat);
  m.OnClick := RMDesigner.RMDisplayFormatEditor;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(SWordWrap);
  m.OnClick := OnWordWrapClick;
  m.Checked := WordWrap;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(SAutoSize);
  m.OnClick := OnAutoWidthClick;
  m.Checked := AutoWidth;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(STextOnly);
  m.OnClick := OnTextOnlyClick;
  m.Checked := TextOnly;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(SHideZeros);
  m.OnClick := OnHideZerosClick;
  m.Checked := HideZeros;
  aPopup.Add(m);

  inherited DefinePopupMenu(aPopup);
end;

procedure TRMCustomMemoView.OnWordWrapClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('WordWrap', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomMemoView.OnAutoWidthClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('AutoWidth', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomMemoView.OnTextOnlyClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('TextOnly', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomMemoView.OnHideZerosClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('HideZeros', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomMemoView.LoadFromStream(aStream: TStream);
var
  i, liCount: Integer;
  lVersion: Word;
begin
  inherited LoadFromStream(aStream);
  lVersion := RMReadWord(aStream); //
  RMReadFont(aStream, Font);
  HAlign := TRMHAlign(RMReadByte(aStream));
  VAlign := TRMVAlign(RMReadByte(aStream));
  FLineSpacing := RMReadInt32(aStream);
  FCharacterSpacing := RMReadInt32(aStream);
  FRepeatedOptions.MasterMemoView := RMReadString(aStream);
  FRepeatedOptions.MergeRepeated := (FFlags and flMemoMergeRepeated) = flMemoMergeRepeated;
  FRepeatedOptions.SuppressRepeated := (FFlags and flMemoSuppressRepeated) = flMemoSuppressRepeated;

  RotationType := TRMRotationType(RMReadByte(aStream));
  ScaleFontType := TRMScaleFontType(RMReadByte(aStream));
  FontScaleWidth := RMReadInt32(aStream);

  if StreamMode = rmsmDesigning then
  begin
    Highlight.Color := RMReadInt32(aStream);
    Highlight.Condition := RMReadString(aStream);
    RMReadFont(aStream, Highlight.Font);
    if lVersion >= 3 then
	    RepeatedOptions.MergeStretchedHeight := RMReadBoolean(aStream);
  end
  else
  begin
    if lVersion < 1 then
    begin
      {FVHeight := }RMReadInt32(aStream);
      liCount := RMReadInt32(aStream);
      for i := 0 to liCount - 1 do
      begin
        RMReadInt32(aStream);
      end;
    end;
  end;

  if lVersion >= 2 then
  begin
    FDisplayBeginLine := RMReadInt32(aStream);
    FDisplayEndLine := RMReadInt32(aStream);
  end
  else
  begin
    FDisplayBeginLine := -1;
    FDisplayEndLine := -1;
  end;
end;

procedure TRMCustomMemoView.SavetoStream(aStream: TStream);
begin
  FFlags := (FFlags and not flMemoMergeRepeated);
  if FRepeatedOptions.MergeRepeated then
    FFlags := FFlags + flMemoMergeRepeated;

  FFlags := (FFlags and not flMemoSuppressRepeated);
  if FRepeatedOptions.SuppressRepeated then
    FFlags := FFlags + flMemoSuppressRepeated;

  inherited SavetoStream(aStream);
  RMWriteWord(aStream, 3); //版本号
  RMWriteFont(aStream, Font);
  RMWriteByte(aStream, Byte(HAlign));
  RMWriteByte(aStream, Byte(VAlign));
  RMWriteInt32(aStream, FLineSpacing);
  RMWriteInt32(aStream, FCharacterSpacing);
  RMWriteString(aStream, FRepeatedOptions.FMasterMemoView);
  RMWriteByte(aStream, Byte(RotationType));
  RMWriteByte(aStream, Byte(ScaleFontType));
  RMWriteInt32(aStream, FontScaleWidth);

  if StreamMode = rmsmDesigning then
  begin
    RMWriteInt32(aStream, Highlight.Color);
    RMWriteString(aStream, Highlight.Condition);
    RMWriteFont(aStream, Highlight.Font);
    RMWriteBoolean(aStream, RepeatedOptions.MergeStretchedHeight);
  end
  else
  begin
  end;

  RMWriteInt32(aStream, FDisplayBeginLine);
  RMWriteInt32(aStream, FDisplayEndLine);
end;

procedure TRMCustomMemoView.AssignFont(aCanvas: TCanvas);
begin
  with aCanvas do
  begin
    SetBkMode(Handle, Windows.Transparent);
    Font := Self.Font;
    if DocMode <> rmdmPrinting then
    begin
      if FactorY = 1 then
      begin
        Font.Height := -Round(Font.Size * 96 / 72);
      end
      else
        Font.Height := -Trunc(Font.Size * 96 / 72 * FactorY);
    end;
  end;
end;

const
  RM_DefEmptyLine = 'gM';
  RM_DefEmptyLineLength = 2;

procedure TRMCustomMemoView.CalcGeneratedData(DC: THandle);
var
  i: integer;
  s: string;
begin
  for i := 0 to FMemo1.Count - 1 do
  begin
    if WordWrap and (FMemo1[i] <> '') then
    begin
      s := FMemo1[i];
      while (s <> '') and (s[Length(s)] = ' ') do
        SetLength(s, Length(s) - 1);
      FMemo1[i] := s;
    end;
  end;
end;

procedure TRMCustomMemoView.WrapMemo;
var
  size, size1, maxwidth: Integer;
  WCanvas: TCanvas;

  procedure _OutLine(const str: string);
  begin
    FSMemo.Add(str);
    Inc(size, size1);
  end;

  procedure _OutLine1(str: string);
  var
    lPos: Integer;
  begin
    lPos := Pos('`', str);
    while lPos > 0 do
    begin
      _OutLine(Copy(str, 1, lPos - 1));
      Delete(str, 1, lPos);
      lPos := Pos('`', str);
    end;
    _OutLine(str);
  end;

  procedure _WrapOutMemo;
  var
    h, oldh: HFont;
    i: Integer;
  begin
    h := RMCreateAPIFont(WCanvas.Font, 0, FFontScaleWidth);
    oldh := SelectObject(WCanvas.Handle, h);

    try
      size := 0;
      size1 := -WCanvas.Font.Height + LineSpacing; //每一行高度;
      MaxWidth := spWidth - spGapLeft * 2 - _CalcHFrameWidth(LeftFrame.spWidth, RightFrame.spWidth);

      if (DocMode = rmdmDesigning) and (FMemo1.Count = 1) and
        (WCanvas.TextWidth(FMemo1[0]) > MaxWidth) and
        (FMemo1[0] <> '') and (FMemo1[0][1] = '[') and (not (FMemo1[0][1] in LeadBytes)) then
        _OutLine(FMemo1[0])
      else
      begin
        if not FNeedWrapped then //不需要换行
        begin
          for i := 0 to FMemo1.Count - 1 do
            _OutLine(FMemo1[i]);
        end
        else if WordWrap then //自动换行
        begin
          size := size + RMWrapStrings(FMemo1, FSMemo, WCanvas, MaxWidth, size1,
            WordBreak, MangeTag, True);
          FSMemo.Add(#1);
        end
        else //不自动换行
        begin
          for i := 0 to FMemo1.Count - 1 do
          begin
            if MangeTag then
              _OutLine1(FMemo1[i])
            else
              _OutLine(FMemo1[i]);
          end;
          FSMemo.Add(#1);
        end;
      end;
    finally
      FVHeight := size - LineSpacing;
      LineHeight := size1;
      SelectObject(WCanvas.Handle, oldh);
      DeleteObject(h);
    end;
  end;

  procedure _WrapOutMemo90;
  var
    h, oldh: HFont;
    i: Integer;
  begin
    h := RMCreateAPIFont(WCanvas.Font, 90, FFontScaleWidth);
    oldh := SelectObject(WCanvas.Handle, h);
    try
      size := 0;
      size1 := -WCanvas.Font.Height + LineSpacing;
      maxwidth := spHeight - spGapTop * 2 - _CalcVFrameWidth(TopFrame.spWidth, BottomFrame.spWidth);
      if not FNeedWrapped then
      begin
        for i := 0 to FMemo1.Count - 1 do
          _Outline(FMemo1[i]);
      end
      else if WordWrap then
        size := size + RMWrapStrings(FMemo1, FSMemo, WCanvas, maxwidth, size1,
          WordBreak, MangeTag, True)
      else
      begin
        for i := 0 to FMemo1.Count - 1 do
          _Outline(FMemo1[i]);
      end;
    finally
      FVHeight := size - LineSpacing;
      LineHeight := size1;
      SelectObject(WCanvas.Handle, oldh);
      DeleteObject(h);
    end;
  end;

  procedure _WrapOutMemo180;
  var
    i: Integer;
  begin
    size := 0;
    size1 := -WCanvas.Font.Height + LineSpacing; //每一行高度;
    MaxWidth := spHeight - spGapTop * 2 - _CalcVFrameWidth(TopFrame.spWidth, BottomFrame.spWidth);

    if (DocMode = rmdmDesigning) and (FMemo1.Count = 1) and
      (WCanvas.TextWidth(FMemo1[0]) > MaxWidth) and
      (FMemo1[0] <> '') and (FMemo1[0][1] = '[') and (not (FMemo1[0][1] in LeadBytes)) then
      _OutLine(FMemo1[0])
    else
    begin
      if not FNeedWrapped then //已经换行
      begin
        for i := 0 to FMemo1.Count - 1 do
          _OutLine(FMemo1[i]);
      end
      else if WordWrap then //自动换行
      begin
        size := size + RMWrapStrings(FMemo1, FSMemo, WCanvas, MaxWidth, size1,
          WordBreak, MangeTag, False);
      end
      else //不自动换行
      begin
        for i := 0 to FMemo1.Count - 1 do
        begin
          if MangeTag then
            _OutLine1(FMemo1[i])
          else
            _OutLine(FMemo1[i]);
        end;
      end;
    end;
    FVHeight := size - LineSpacing;
    LineHeight := size1;
  end;

  procedure _ChangeFontSize;
  var
    i: Integer;
    s: string;
    lMaxWidth: Integer;
  begin
    lMaxWidth := spWidth - spGapLeft * 2 - _CalcHFrameWidth(LeftFrame.spWidth, RightFrame.spWidth);
    if lMaxWidth < 10 then
      Exit;
    for i := 0 to FMemo1.Count - 1 do
    begin
      s := FMemo1[i];
      while (WCanvas.TextWidth(s) > lMaxWidth) and (WCanvas.Font.Size > 0) do
        WCanvas.Font.Size := WCanvas.Font.Size - 1;
    end;
    Font.Size := WCanvas.Font.Size;
  end;

begin
  WCanvas := FParentReport.DrawCanvas;
  WCanvas.Font.Assign(Font);
  WCanvas.Font.Height := -Round(Font.Size * 96 / 72);
  SetTextCharacterExtra(WCanvas.Handle, CharacterSpacing);
  try
    case FScaleFontType of
      rmstByWidth:
        begin
          if DocMode <> rmdmDesigning then
            _ChangeFontSize;
        end;
      rmstByHeight:
        begin
        end;
    end;

    FSMemo.Clear;
    case RotationType of
      rmrt90, rmrt270: _WrapOutMemo90;
      rmrt180: _WrapOutMemo180;
    else
      _WrapOutMemo;
    end;
  finally
    SetTextCharacterExtra(WCanvas.Handle, 0);
    FNeedWrapped := False;
  end;
end;

procedure TRMCustomMemoView.ShowUnderLines;
var
  i, lCount: Integer;
  lRowHeight, lOffsetTop: Integer;
  x1, x2, y1: Integer;
begin
  AssignFont(Canvas);
  with Canvas do
  begin
    Pen.Color := TopFrame.Color;
    Pen.Width := Round(1 * FactorY); {TopFrame.spWidth}
    ;
    Pen.Style := psSolid;
  end;

  lRowHeight := -Canvas.Font.Height + Round(LineSpacing * FactorY);
  lOffsetTop := spTop + spGapTop - Canvas.Font.Height + Round(2 * FactorY);
  x1 := spLeft;
  x2 := spLeft + spWidth - 1;
  lCount := spHeight div lRowHeight;
  for i := 0 to lCount - 1 do
  begin
    y1 := lOffsetTop + i * lRowHeight;
    Canvas.MoveTo(x1, y1);
    Canvas.LineTo(x2, y1);
  end;
end;

type
  PRMIntegerArray = ^TRMIntegerArray;
  TRMIntegerArray = array[0..16383] of Integer;

procedure _JustifyArray(a: PRMIntegerArray; aLen, aNeededSize, aRealSize: integer);
var
  i, n, step, lDelta, lDeltaAbs: Integer;
begin
  if aLen = 0 then Exit;

  lDelta := aNeededSize - aRealSize;
  lDeltaAbs := abs(lDelta);
  if lDeltaAbs >= aLen then
  begin
    n := lDelta div aLen;
    for i := 0 to aLen - 1 do
    begin
      Inc(a^[i], n);
      Dec(lDelta, n);
    end;
    lDeltaAbs := abs(lDelta);
  end;

  if lDelta <> 0 then
  begin
    if lDelta > 0 then
      step := 1
    else
      step := -1;
    n := aLen div lDeltaAbs;
    i := 0;
    while (i < aLen) and (lDeltaAbs > 0) do
    begin
      Inc(a^[i], step);
      Inc(i, n);
      Dec(lDeltaAbs);
    end;
    if lDeltaAbs > 0 then
      Inc(a^[aLen div 2], step);
  end;
end;

procedure TRMCustomMemoView.ShowMemo;
var
  lDRect: TRect;
  lx0, ly0: Integer;
  lJustifySize: Integer;

  procedure _DrawText(const aStr: string; acurx, acury: Integer; abVertText: Boolean);
  var
    i: Integer;
    lTextOption, lStrLen: Integer;
    lSize, lSize1: TSize;
    lDx: PRMIntegerArray;
    lFit: Integer;
  begin
    lTextOption := ETO_CLIPPED;
    if (FFlags and flMemoRTLReading) <> 0 then
      lTextOption := lTextOption or ETO_RTLREADING;

    lStrLen := Length(aStr);
    GetTextExtentPoint32(Canvas.Handle, PChar(aStr), lStrLen, lSize);
    if (lJustifySize <= 0) or (lSize.cx = lJustifySize) or (lStrLen < 2) then
    begin
      ExtTextOut(Canvas.Handle, acurx, acury, lTextOption, @lDRect,
        PChar(astr), lStrLen, nil);
    end
    else
    begin
      GetMem(lDx, 4 * (lStrLen + 1));
      try
        if GetTextExtentExPoint(Canvas.Handle, PChar(astr), lStrLen, lSize.cx,
          @lFit, @(lDx^[0]), lSize1) then
        begin
          for i := lStrLen - 1 downto 1 do
            lDx^[i] := lDx^[i] - lDx^[i - 1];
          _JustifyArray(@(lDx^[0]), lStrLen - 1, lJustifySize, lSize.cx);

          SetTextCharacterExtra(Canvas.Handle, 0);
          ExtTextOut(Canvas.Handle, acurx, acury, lTextOption, @lDRect,
            PChar(astr), lStrLen, @(lDx^[0]));
          SetTextCharacterExtra(Canvas.Handle, Round(CharacterSpacing * FactorX));
        end;
      finally
        FreeMem(lDx);
      end;
    end;
  end;

  function _ShowChar(aLeft0, aTop0, c: integer; aStr: string; aCanvas: TCanvas): Integer;
  var
    c1, fs, fs1, i, oldY: integer;
    lstr: string;
    xText, yText: integer; //Add By zyxgd
  begin
    Result := 0;
    lJustifySize := 0;
    i := 1;
    if c < 0 then c := 0;
    oldY := aTop0; //2002.2.8 LBZ
    fs := aCanvas.Font.Size;
    fs1 := fs div 2;
    //    fs1 := (fs * 3) div 5;  // by nihong 修改上、下标比例为60%
    c1 := 0;
    if fs1 < 6 then fs1 := 6;
    while i <= length(aStr) do
    begin
      //2002.2.8 LBZ
      if MangeTag then
      begin
        if aStr[i] = '~' then //上标
        begin
          aCanvas.Font.Size := fs1;
          if c <> 0 then
            c1 := fs - fs1; //两端对齐时
          //          y := y - (fs1 div 2) * (aCanvas.Font.PixelsPerInch div Screen.PixelsPerInch);  // by nihong
          Delete(aStr, i, 1);
        end
        else if aStr[i] = '_' then //下标
        begin
          if c <> 0 then
            c1 := fs - fs1; //两端对齐时
          aCanvas.Font.Size := fs1;
          aTop0 := aTop0 + (fs - (fs1 div 2)) * (aCanvas.Font.PixelsPerInch div Screen.PixelsPerInch); // by nihong
          Delete(aStr, i, 1);
        end
        else if aStr[i] = '|' then //取消上下标
        begin
          c1 := 0;
          aCanvas.Font.Size := fs;
          aTop0 := oldY;
          Delete(aStr, i, 1);
        end;
        //2002.2.8 LBZ
      end; {if MangeTag}

      //Begin Add By zyxgd
      xText := aLeft0;
      yText := aTop0;
      //End Add By zyxgd
      if Windows.isDBCSLeadByte(byte(aStr[i])) then //判断是否为中文 LBZ
      begin
        lstr := Copy(aStr, i, 2);
        i := i + 2;
      end
      else
      begin
        lstr := Copy(aStr, i, 1);
        Inc(i);
      end;

      //Begin Add By zyxgd
      if RotationType = rmrt180 then
      begin
        xText := aLeft0 - aCanvas.TextWidth(lstr);
        Result := Max(Result, aCanvas.TextWidth(lstr) - Round(CharacterSpacing * FactorX) + Round(LineSpacing * FactorX));
      end
      else if RotationType = rmrt360 then
      begin
        yText := aTop0 + aCanvas.TextWidth(lstr);
        Result := Max(Result, aCanvas.TextWidth(lstr));
      end;
      //End Add By zyxgd
      _DrawText(lstr, xText, yText, True); //By zyxgd

      case RotationType of
        rmrtNone: aLeft0 := aLeft0 + c1 + c + aCanvas.TextWidth(lstr);
        rmrt90: aTop0 := aTop0 - c1 - c - aCanvas.TextWidth(lstr);
        rmrt180:
          begin
            aTop0 := aTop0 + c1 + c + aCanvas.TextHeight(lstr) + Round(CharacterSpacing * FactorX);
          end;
        rmrt270: aTop0 := aTop0 + c1 + c + aCanvas.TextWidth(lstr);
        rmrt360: aLeft0 := aLeft0 + c1 + c + aCanvas.TextHeight(lstr) + Round(CharacterSpacing * FactorX);
      end;
    end;
  end;

  function _TW(s: string; aFlagWidth: Boolean): integer;
  var
    fs, fs1, i, j, lCharWidth: Integer;
  begin
    fs := Canvas.Font.size;
    fs1 := fs div 2;
    if fs1 < 6 then
      fs1 := 6;
    j := 0;
    i := 1;
    while i <= length(s) do
    begin
      if MangeTag and (s[i] = '_') then
      begin
        Canvas.Font.size := fs1;
        Inc(i);
      end;
      if MangeTag and (s[i] = '~') then
      begin
        Canvas.Font.size := fs1;
        Inc(i);
      end;
      if MangeTag and (s[i] = '|') then
      begin
        Canvas.Font.size := fs;
        Inc(i);
      end;
      if Windows.isDBCSLeadByte(Byte(s[i])) then
      begin
        if aFlagWidth then
          lCharWidth := Canvas.TextWidth(Copy(s, i, 2))
        else
          lCharWidth := Canvas.TextHeight(Copy(s, i, 2));
        Inc(i);
      end
      else
      begin
        if aFlagWidth then
          lCharWidth := Canvas.TextWidth(Copy(s, i, 1))
        else
          lCharWidth := Canvas.TextHeight(Copy(s, i, 2))
      end;

      j := j + lCharWidth;
      case RotationType of
        rmrtNone: ;
        rmrt90: ;
        //        rmrt180: j := j + Round(CharacterSpacing * FactorX);
        rmrt180: if i < length(s) then j := j + Round(CharacterSpacing * FactorX); //By zyxgd
        rmrt270: ;
        //        rmrt360: j := j + Round(CharacterSpacing * FactorX);
        rmrt360: if i < length(s) then j := j + Round(CharacterSpacing * FactorX); //By zyxgd
      end;
      Inc(i);
    end;

    Result := j;
    Canvas.Font.size := fs;
  end;

  function _Wlength(aStr: string): Integer;
  var
    i, j: integer;
  begin
    j := 0;
    i := 1;
    while i <= length(aStr) do
    begin
      if Windows.isDBCSLeadByte(byte(aStr[i])) then
      begin
        Inc(j); //判断是否为中文 LBZ
        i := i + 2;
      end
      else
      begin
        Inc(i);
        Inc(j);
        if MangeTag and ((aStr[i] = '_') or (aStr[i] = '~') or (aStr[i] = '|')) then
          Dec(j);
      end;
    end;

    Result := j;
  end;

  function _GetJustifySize(const aStr: string): Integer;
  var
    liSize: TSize;
    lNewFont, lOldFont: HFONT;
    lDC: HDC;
  begin
    Result := 0;
    lDC := FParentReport.DrawCanvas.Handle;
    SetTextCharacterExtra(lDC, CharacterSpacing);
    case RotationType of
      rmrtNone:
        begin
          lNewFont := RMCreateAPIFont(Font, 0, Round(FFontScaleWidth / FactorX));
          lOldFont := SelectObject(lDC, lNewFont);
          try
            if MangeTag then
              Result := _tw(aStr, True)
            else
            begin
              GetTextExtentPoint32(lDC, PChar(aStr), Length(aStr), liSize);
              Result := Round(liSize.cx * FactorX / Screen.PixelsPerInch * 96);
            end;
          finally
            SelectObject(lDC, lOldFont);
            DeleteObject(lNewFont);
          end;
        end;
      rmrt90:
        begin
          lNewFont := RMCreateAPIFont(Font, 90, Round(FFontScaleWidth / FactorX));
          lOldFont := SelectObject(lDC, lNewFont);
          try
            GetTextExtentPoint32(lDC, PChar(aStr), Length(aStr), liSize);
            Result := Round(liSize.cx * FactorX / Screen.PixelsPerInch * 96);
          finally
            SelectObject(lDC, lOldFont);
            DeleteObject(lNewFont);
          end;
        end;
      rmrt180:
        begin
          Result := 0;
        end;
      rmrt270:
        begin
          lNewFont := RMCreateAPIFont(Font, -90, Round(FFontScaleWidth / FactorX));
          lOldFont := SelectObject(lDC, lNewFont);
          try
            if MangeTag then
              Result := _tw(aStr, True)
            else
            begin
              GetTextExtentPoint32(lDC, PChar(aStr), Length(aStr), liSize);
              Result := Round(liSize.cx * FactorX / Screen.PixelsPerInch * 96);
            end;
          finally
            SelectObject(lDC, lOldFont);
            DeleteObject(lNewFont);
          end;
        end;
      rmrt360:
        begin
          lNewFont := RMCreateAPIFont(Font, 90, Round(FFontScaleWidth / FactorX));
          lOldFont := SelectObject(lDC, lNewFont);
          try
            if MangeTag then
              Result := _tw(aStr, True)
            else
            begin
              GetTextExtentPoint32(lDC, PChar(aStr), Length(aStr), liSize);
              Result := Round(liSize.cx * FactorX / Screen.PixelsPerInch * 96);
            end;
          finally
            SelectObject(lDC, lOldFont);
            DeleteObject(lNewFont);
          end;
        end;
    end; {Case}

    SetTextCharacterExtra(lDC, 0);
  end;

  function _GetVHeight: Integer;
  var
    i, j: Integer;
    lOneLine, lstr: string;
    lMaxWidth: Integer;
  begin
    Result := 0;
    for j := 0 to FMemo1.Count - 1 do
    begin
      if j > 0 then
      begin
        Result := Result + Round(LineSpacing * FactorX);
      end;

      lOneLine := FMemo1[j];
      lMaxWidth := 0;
      i := 1;
      while i <= Length(lOneLine) do
      begin
        if Windows.isDBCSLeadByte(Byte(lOneLine[i])) then //判断是否为中文 LBZ
        begin
          lstr := Copy(lOneLine, i, 2);
          i := i + 2;
        end
        else
        begin
          lstr := Copy(lOneLine, i, 1);
          Inc(i);
        end;

        lMaxWidth := Max(lMaxWidth, Canvas.TextWidth(lstr) - Round(CharacterSpacing * FactorX));
      end;

      Result := Result + lMaxWidth;
    end;
  end;

  procedure _OutMemo;
  var
    i, lCurTop, lLineHeight, lCharSpacing: Integer;
    lSaveWordWrap: Boolean;
    lNewFont, lOldFont: HFont;
    lBeginLine, lEndLine: Integer;

    function _OutLine(const aStr: string): Boolean;
    var
      lCurLeft: Integer;
      lwLength: Integer;
    begin
      if (not FFlagPlaceOnEndPage) or (lCurTop + lLineHeight <= lDRect.Bottom) then
      begin
        if HAlign = rmhEuqal then // 分散对齐
        begin
          lCurLeft := RealRect.Left + spGapLeft;
          lwLength := _wLength(aStr) - 1;
          if lwLength * FactorX <> 0 then
          begin
            _ShowChar(lCurLeft, lCurTop, Trunc((RealRect.Right - RealRect.Left - Canvas.TextWidth(aStr) - spGapLeft * 2 + Round(CharacterSpacing * FactorX)) / lwLength), aStr, Canvas);
            //            _ShowChar(lCurLeft, liCurTop, Trunc((RealRect.Right - RealRect.Left - Canvas.TextWidth(aStr) - spGapLeft * 2) / lwLength), aStr, Canvas)    //By zyxgd
          end
          else
          begin
            _ShowChar(lCurLeft, lCurTop, 0, aStr, Canvas);
          end;
        end
        else
        begin
          if HAlign = rmhLeft then //左对齐
            lCurLeft := RealRect.Left + spGapLeft
          else if HAlign = rmhRight then //右对齐
          begin
            lCurLeft := RealRect.Right - spGapLeft - lJustifySize + Round(CharacterSpacing * FactorX);
          end
          else // 居中
          begin
            lCurLeft := RealRect.Left + (RealRect.Right - RealRect.Left - lJustifySize) div 2 + Round(CharacterSpacing * FactorX / 2);
          end;

          if MangeTag then
            _ShowChar(lCurLeft, lCurTop, 0, aStr, Canvas) //2002.2.8 LBZ
          else
            _DrawText(aStr, lCurLeft, lCurTop, False);
          //            _ShowChar(lCurLeft, liCurTop,Round(CharacterSpacing * FactorX) , aStr, Canvas)     //By zyxgd
        end;

        if Exporting then
        begin
          FParentReport.InternalOnExportText(RealRect, lCurLeft, lCurTop, aStr, Self);
        end;

        Inc(CurStrNo);
        Result := False;
      end
      else
        Result := True;

      Inc(lCurTop, lLineHeight + lCharSpacing)
    end;

  begin
    lNewFont := RMCreateAPIFont(Canvas.Font, 0, FFontScaleWidth);
    lOldFont := SelectObject(Canvas.Handle, lNewFont);

    lCurTop := ly0;
    lLineHeight := Round((-Font.Height) * FactorY);
    lCharSpacing := Round(LineSpacing * FactorY);
    CurStrNo := 0;
    lSaveWordWrap := WordWrap;
    if (DocMode = rmdmDesigning) and (FMemo1.Count = 1) and
      (Canvas.TextWidth(FMemo1[0]) > lDRect.Right - lDRect.Left) and
      (FMemo1[0][1] = '[') and (not (FMemo1[0][1] in LeadBytes)) then
      WordWrap := FALSE;

    if (FDisplayBeginLine >= 0) and (FDisplayEndLine >= 0) then
    begin
      lBeginLine := FDisplayBeginLine;
      lEndline := Min(FDisplayEndLine, FMemo1.Count - 1);
    end
    else
    begin
      lBeginLine := 0;
      lEndLine := FMemo1.Count - 1;
    end;

    for i := lBeginLine {0} to lEndLine {FMemo1.Count - 1} do
    begin
      lJustifySize := _GetJustifySize(FMemo1[i]);
      if _OutLine(FMemo1[i]) then
        Break;
    end;
    WordWrap := lSaveWordWrap;

    SelectObject(Canvas.Handle, lOldFont);
    DeleteObject(lNewFont);
  end;

  procedure _OutMemo90;
  var
    i, lLineHeight, liCurLeft: Integer;
    lNewFont, lOldFont: HFont;
    lwLength, lstrWidth: Integer;
    lBeginLine, lEndLine: Integer;

    procedure _OutLine(aStr: string);
    var
      liCurTop: Integer;
    begin
      if HAlign = rmHEuqal then // 分散对齐
      begin
        liCurTop := RealRect.Bottom - spGapTop;
        lwLength := _wLength(aStr) - 1;
        if lwLength * FactorX <> 0 then
        begin
          lstrWidth := RealRect.Bottom - RealRect.Top - Canvas.TextWidth(aStr) + Round(CharacterSpacing * FactorX) - spGapTop * 2;
          //          lstrWidth := RealRect.Bottom - RealRect.Top - Canvas.TextWidth(aStr) - spGapTop * 2;     //By zyxgd
          _ShowChar(liCurLeft, liCurTop, Trunc(lstrWidth / lwLength), aStr, Canvas);
        end
        else
        begin
          _ShowChar(liCurLeft, liCurTop, 0, aStr, Canvas);
        end;
      end
      else
      begin
        if HAlign = rmHLeft then // 底对齐
          liCurTop := RealRect.Bottom - spGapTop
        else if HAlign = rmHRight then // 顶对齐
        begin
          if CharacterSpacing = 0 then
          begin
            liCurTop := RealRect.Top + lJustifySize + spGapTop;
          end
          else
          begin
            liCurTop := RealRect.Top + spGapTop + Canvas.TextWidth(aStr) - Round(CharacterSpacing * FactorX);
            //            liCurTop := RealRect.Top + spGapTop + Canvas.TextWidth(aStr) + Round(CharacterSpacing * FactorX *(_WLength(aStr)-1));    //By zyxgd
          end;
        end
        else // 垂直居中
        begin
          if CharacterSpacing = 0 then
          begin
            liCurTop := RealRect.Bottom - (RealRect.Bottom - RealRect.Top - lJustifySize) div 2;
          end
          else
          begin
            liCurTop := RealRect.Bottom - (RealRect.Bottom - RealRect.Top - Canvas.TextWidth(aStr)) div 2;
            //            liCurTop := RealRect.Bottom - (RealRect.Bottom - RealRect.Top - Canvas.TextWidth(aStr) - Round(CharacterSpacing * FactorX)*(_WLength(aStr)-1)) div 2;   //By zyxgd
          end;
        end;

        _DrawText(aStr, liCurLeft, liCurTop, True);
      end;

      Inc(CurStrNo);
      Inc(liCurLeft, lLineHeight);
    end;
  begin
    lNewFont := RMCreateAPIFont(Canvas.Font, 90, FFontScaleWidth);
    lOldFont := SelectObject(Canvas.Handle, lNewFont);
    liCurLeft := lx0;
    lLineHeight := -Canvas.Font.Height + Round(LineSpacing * FactorX);
    CurStrNo := 0;

    if (FDisplayBeginLine >= 0) and (FDisplayEndLine >= 0) then
    begin
      lBeginLine := FDisplayBeginLine;
      lEndline := Min(FDisplayEndLine, FMemo1.Count - 1);
    end
    else
    begin
      lBeginLine := 0;
      lEndLine := FMemo1.Count - 1;
    end;

    for i := lBeginLine {0} to lEndLine {FMemo1.Count - 1} do
    begin
      lJustifySize := _GetJustifySize(FMemo1[i]);
      _OutLine(FMemo1[i]);
    end;

    SelectObject(Canvas.Handle, lOldFont);
    DeleteObject(lNewFont);
  end;

  procedure _OutMemo180;
  var
    i, lLineHeight, liCurLeft: Integer;
    lBeginLine, lEndLine: Integer;

    procedure _OutLine(aStr: string);
    var
      liCurTop: Integer;
      lwLength: Integer;
    begin
      if HAlign = rmHEuqal then // 分散对齐
      begin
        liCurTop := RealRect.Top + spGapTop;
        lwLength := _wLength(aStr) - 1;
      end
      else
      begin
        lwLength := 0;
        if HAlign = rmHLeft then // 顶对齐
          liCurTop := RealRect.Top + spGapTop
        else if HAlign = rmHRight then // 底对齐
          liCurTop := RealRect.Bottom - _tw(aStr, False) - spGapTop
            //          liCurTop := RealRect.Bottom - _tw(aStr, False) - spGapTop    //By zyxgd
        else // 垂直居中
          liCurTop := RealRect.Top + (RealRect.Bottom - RealRect.Top - _tw(aStr, False) - spGapTop * 2) div 2;
        //          liCurTop := RealRect.Top + spGapTop + (RealRect.Bottom - RealRect.Top - _tw(aStr, False)) div 2;            //By zyxgd
      end;

      if lwLength * FactorX <> 0 then
      begin
        lLineHeight := _ShowChar(liCurLeft, liCurTop, Trunc((RealRect.Bottom - RealRect.Top - _tw(aStr, False) - spGapTop * 2) / lwLength), aStr, Canvas);
      end
      else
      begin
        lLineHeight := _ShowChar(liCurLeft, liCurTop, 0, aStr, Canvas);
      end;

      Inc(CurStrNo);
      Dec(liCurLeft, lLineHeight);
    end;

  begin
    liCurLeft := lx0 + Round(CharacterSpacing * FactorX);
    lLineHeight := -Canvas.Font.Height + Round(LineSpacing * FactorX);
    CurStrNo := 0;

    if (FDisplayBeginLine >= 0) and (FDisplayEndLine >= 0) then
    begin
      lBeginLine := FDisplayBeginLine;
      lEndline := Min(FDisplayEndLine, FMemo1.Count - 1);
    end
    else
    begin
      lBeginLine := 0;
      lEndLine := FMemo1.Count - 1;
    end;

    for i := lBeginLine {0} to lEndLine {FMemo1.Count - 1} do
    begin
      lJustifySize := _GetJustifySize(FMemo1[i]);
      _OutLine(FMemo1[i]);
    end;
  end;

  procedure _OutMemo270;
  var
    i, lLineHeight, liCurLeft: Integer;
    lNewFont, lOldFont: HFont;
    lBeginLine, lEndLine: Integer;

    procedure _OutLine(aStr: string);
    var
      liCurTop: Integer;
      lwLength: Integer;
    begin
      if HAlign = rmHEuqal then // 分散对齐
      begin
        liCurTop := RealRect.Top + spGapTop;
        lwLength := _wLength(aStr) - 1;
        if lwLength * FactorX <> 0 then
        begin
          _ShowChar(liCurLeft, liCurTop, Trunc((RealRect.Bottom - RealRect.Top - Canvas.TextWidth(aStr) - spGapTop * 2 + Round(CharacterSpacing * FactorX)) / lwLength), aStr, Canvas);
          //          _ShowChar(liCurLeft, liCurTop, Trunc((RealRect.Bottom - RealRect.Top - Canvas.TextWidth(aStr) - spGapTop * 2) / lwLength), aStr, Canvas);    //By zyxgd
        end
        else
        begin
          _ShowChar(liCurLeft, liCurTop, 0, aStr, Canvas);
        end;
      end
      else
      begin
        if HAlign = rmHLeft then // 顶对齐
          liCurTop := RealRect.Top + spGapTop
        else if HAlign = rmHRight then // 底对齐
        begin
          liCurTop := RealRect.Bottom - Canvas.TextWidth(aStr) - spGapTop + Round(CharacterSpacing * FactorX);
        end
        else // 垂直居中
        begin
          liCurTop := RealRect.Top + (RealRect.Bottom - RealRect.Top - Canvas.TextWidth(aStr) + Round(CharacterSpacing * FactorX)) div 2;
        end;

        _DrawText(aStr, liCurLeft, liCurTop, True);
      end;

      Inc(CurStrNo);
      Dec(liCurLeft, lLineHeight);
    end;

  begin
    lNewFont := RMCreateAPIFont(Canvas.Font, -90, FFontScaleWidth);
    lOldFont := SelectObject(Canvas.Handle, lNewFont);
    liCurLeft := lx0;
    lLineHeight := -Canvas.Font.Height + Round(LineSpacing * FactorX);
    CurStrNo := 0;
    if (FDisplayBeginLine >= 0) and (FDisplayEndLine >= 0) then
    begin
      lBeginLine := FDisplayBeginLine;
      lEndline := Min(FDisplayEndLine, FMemo1.Count - 1);
    end
    else
    begin
      lBeginLine := 0;
      lEndLine := FMemo1.Count - 1;
    end;

    for i := lBeginLine {0} to lEndLine {FMemo1.Count - 1} do
    begin
      lJustifySize := _GetJustifySize(FMemo1[i]);
      _OutLine(FMemo1[i]);
    end;
    SelectObject(Canvas.Handle, lOldFont);
    DeleteObject(lNewFont);
  end;

  procedure _OutMemo360;
  var
    i, lLineHeight, liCurTop: Integer;
    lNewFont, lOldFont: HFont;
    lwLength: Integer;
    lstrWidth: Integer;
    lBeginLine, lEndLine: Integer;

    procedure _OutLine(aStr: string);
    var
      liCurLeft: Integer;
    begin
      if HAlign = rmHEuqal then // 分散对齐
      begin
        liCurLeft := RealRect.Left + spGapLeft;
        lwLength := _wLength(aStr) - 1;
      end
      else
      begin
        lwLength := 0;
        if HAlign = rmHLeft then // 左对齐
          liCurLeft := RealRect.Left + spGapLeft
        else if HAlign = rmHRight then // 右对齐
        begin
          liCurLeft := RealRect.Right - _tw(aStr, False) - spGapLeft;
        end
        else // 水平居中
        begin
          liCurLeft := RealRect.Left + (RealRect.Right - RealRect.Left - _tw(aStr, False)) div 2;
        end;
      end;

      if lwLength * FactorX <> 0 then
      begin
        lstrWidth := RealRect.Right - RealRect.Left - _tw(aStr, False);
        //        lstrWidth := RealRect.Right - RealRect.Left - _tw(aStr, False) - spGapLeft * 2;   //By zyxgd
        _ShowChar(liCurLeft, liCurTop, Trunc(lstrWidth / lwLength), aStr, Canvas);
      end
      else
      begin
        _ShowChar(liCurLeft, liCurTop, 0, aStr, Canvas);
      end;

      Inc(CurStrNo);
      Inc(liCurTop, lLineHeight);
    end;
  begin
    lNewFont := RMCreateAPIFont(Canvas.Font, 90, FFontScaleWidth);
    lOldFont := SelectObject(Canvas.Handle, lNewFont);
    liCurTop := ly0 - Round(CharacterSpacing * FactorX);
    lLineHeight := -Canvas.Font.Height + Round(LineSpacing * FactorX);
    CurStrNo := 0;
    if (FDisplayBeginLine >= 0) and (FDisplayEndLine >= 0) then
    begin
      lBeginLine := FDisplayBeginLine;
      lEndline := Min(FDisplayEndLine, FMemo1.Count - 1);
    end
    else
    begin
      lBeginLine := 0;
      lEndLine := FMemo1.Count - 1;
    end;

    for i := lBeginLine {0} to lEndLine {FMemo1.Count - 1} do
    begin
      lJustifySize := _GetJustifySize(FMemo1[i]);
      _OutLine(FMemo1[i]);
    end;
    SelectObject(Canvas.Handle, lOldFont);
    DeleteObject(lNewFont);
  end;

begin
  lx0 := spLeft;
  ly0 := spTop;
  AssignFont(Canvas);
  SetTextCharacterExtra(Canvas.Handle, Round(CharacterSpacing * FactorX));
  lDRect := Rect(RealRect.Left, RealRect.Top, RealRect.Right, RealRect.Bottom);
  FVHeight := Round(FVHeight * FactorY);
  case RotationType of
    rmrtNone:
      begin
        case VAlign of
          rmvCenter: //垂直居中
            ly0 := RealRect.Top + (RealRect.Bottom - RealRect.Top - FVHeight - 1) div 2;
          rmvBottom: //底对齐
            ly0 := RealRect.Bottom - FVHeight - spGapTop - 1
        else
          ly0 := RealRect.Top + spGapTop;
        end;
        _OutMemo;
      end;
    rmrt90:
      begin
        case VAlign of
          rmvCenter: // 居中
            lx0 := RealRect.Left + (RealRect.Right - RealRect.Left - FVHeight) div 2;
          rmvBottom: // 右对齐
            lx0 := RealRect.Right - FVHeight - spGapLeft;
        else // 左对齐
          lx0 := RealRect.Left + spGapLeft;
        end;
        _OutMemo90;
      end;
    rmrt180:
      begin
        case VAlign of
          rmvCenter: // 水平居中
            begin
              lx0 := RealRect.Left + (RealRect.Right - RealRect.Left + _GetVHeight) div 2;
            end;
          rmvBottom: // 左对齐
            begin
              lx0 := RealRect.Left + spGapLeft + _GetVheight;
            end;
        else // 右对齐
          lx0 := RealRect.Right - spGapLeft;
        end;
        _OutMemo180;
      end;
    rmrt270:
      begin
        case VAlign of
          rmvCenter: //水平居中
            begin
              lx0 := RealRect.Right - (RealRect.Right - RealRect.Left - FVHeight) div 2;
            end;
          rmvBottom: // 左对齐
            begin
              lx0 := RealRect.Left + spGapLeft + FVHeight;
            end;
        else // 右对齐
          lx0 := RealRect.Right - spGapLeft;
        end;
        _OutMemo270;
      end;
    rmrt360:
      begin
        case VAlign of
          rmvCenter: //垂直居中
            ly0 := RealRect.Top + (RealRect.Bottom - RealRect.Top - FVheight) div 2;
          rmvBottom: //底对齐
            ly0 := RealRect.Bottom - spGapTop - FVheight;
        else // 顶对齐
          ly0 := RealRect.Top + spGapTop;
        end;
        _OutMemo360;
      end;
  end;

  SetTextCharacterExtra(Canvas.Handle, 0);
end;

function TRMCustomMemoView.CalcWidth(aMemo: TStringList): Integer;
var
  lCalcRect: TRect;
  s: string;
  i, n: Integer;
begin
  lCalcRect := Rect(0, 0, spWidth, spHeight);
  s := aMemo.Text;
  i := 1;
  if Pos(#1, s) <> 0 then
  begin
    while i < Length(s) do
    begin
      if s[i] = #1 then
        Delete(s, i, 1)
      else
        Inc(i);
    end;
  end;
  n := Length(s);
  if n > 2 then
  begin
    if (s[n - 1] = #13) and (s[n] = #10) then
      SetLength(s, n - 2);
  end;
  AssignFont(Canvas);
  SetTextCharacterExtra(Canvas.Handle, Round(CharacterSpacing * FactorX));
  Result := Round(Canvas.TextWidth(s) / FactorX + spGapLeft * 2 +
    _CalcHFrameWidth(LeftFrame.spWidth, RightFrame.spWidth) - CharacterSpacing * 2);
end;

procedure TRMCustomMemoView.Set_AutoWidth(const aCanvas: TCanvas);
var
  lStr: string;
  lStrLen: Integer;
begin
  lStr := FMemo.Text;
  lStrLen := Length(lStr);
  if lStrLen > 2 then
  begin
    if (lStr[lStrLen - 1] = #13) and (lStr[lStrLen] = #10) then
      SetLength(lStr, lStrLen - 2);
  end;

  Self.Canvas := aCanvas;
  AssignFont(Canvas);
  SetTextCharacterExtra(Canvas.Handle, Round(CharacterSpacing * FactorX));
  spWidth := Round(Canvas.TextWidth(lStr) / FactorX + spGapLeft * 2 +
    _CalcHFrameWidth(LeftFrame.spWidth, RightFrame.spWidth) - CharacterSpacing * 2);
end;

procedure TRMCustomMemoView.Draw(aCanvas: TCanvas);
var
  lSaveScaleX, lSaveScaleY: Double;
begin
  FFlagPlaceOnEndPage := False;
  if AutoWidth and (DocMode <> rmdmDesigning) then Set_AutoWidth(aCanvas);

  BeginDraw(aCanvas);
  FMemo1.Assign(FMemo);
  if FMemo1.Count > 0 then
  begin
    FNeedWrapped := (Memo1[Memo1.Count - 1] <> #1);
    if Memo1[Memo1.Count - 1] = #1 then
      Memo1.Delete(Memo1.Count - 1);

    lSaveScaleX := FactorX;
    lSaveScaleY := FactorY;
    FactorX := 1;
    FactorY := 1;
    CalcGaps;
    while True do
    begin
      WrapMemo;
      if (DocMode in [rmdmPrinting, rmdmPreviewing]) and (FScaleFontType = rmstByHeight) and
        (FVHeight > abs(RealRect.Bottom - RealRect.Top - spGapTop * 2)) and (Font.Size > 4) then
      begin
        Font.Size := Font.Size - 1;
      end
      else
        Break;
    end;

    if (FSMemo.Count > 0) and (FSMemo[FSMemo.Count - 1] = #1) then
      FSMemo.Delete(FSMemo.Count - 1);
    FMemo1.Assign(FSMemo);
    FactorX := lSaveScaleX;
    FactorY := lSaveScaleY;
    RestoreCoord;
  end;

  CalcGaps;
  ShowBackground;
  ShowFrame;
  if Underlines then
    ShowUnderLines;
  if FMemo1.Count > 0 then
    ShowMemo;
  SetTextCharacterExtra(aCanvas.Handle, 0);
  RestoreCoord;
end;

function TRMCustomMemoView.CanMergeCell: Boolean;
begin
  Result := ((not FParentReport.FFlag_TableEmpty) or PrintAtAppendBlank) and
    RepeatedOptions.SuppressRepeated and RepeatedOptions.MergeRepeated and
    (FLastValuePage = FParentReport.MasterReport.FPageNo) and ((FMemo1.Text = FLastValue) or (MergeEmpty and (FMemo1.Text = ''))) and
    ((FMasterView = nil) or (not TRMCustomMemoView(FMasterView).FLastValueChanged));
end;

procedure TRMCustomMemoView.PlaceOnEndPage(aStream: TStream);
var
  lOldFont: TFont;
  lOldFillColor: TColor;
  i: Integer;
  lSuppressRepeatedFlag: Boolean;
  lSaveHeight, lSaveTop, lSavePosition: Integer;
begin
  FFlagPlaceOnEndPage := True;
  BeginDraw(FParentReport.DrawCanvas);

  if Visible or (FParentReport.FHookList.Count > 0) or
    Assigned(FParentReport.OnBeforePrint) or
    Assigned(OnBeforePrint) then
    GetMemoVariables;

  if not Visible then
  begin
    DrawMode := rmdmAll;
    Exit;
  end;

  lOldFont := TFont.Create;
  lOldFont.Assign(Font);
  lOldFillColor := FillColor;
  if (not FParentReport.Flag_TableEmpty) and (Highlight.Condition <> '') then
  begin
    try
      if FParentReport.Parser.CalcOPZ(Highlight.Condition) <> 0 then
      begin
        Font.Assign(Highlight.Font);
        FillColor := Highlight.Color;
      end;
    except
      on E: exception do
        FParentReport.DoError(E);
    end;
  end;

  if DrawMode = rmdmPart then
  begin
    CalcGaps;
    CalcGeneratedData(FParentReport.DrawCanvas.Handle);
    ShowMemo;
    FSMemo.Assign(FMemo1);
    while FMemo1.Count > CurStrNo do
      FMemo1.Delete(CurStrNo);
    RestoreCoord;
  end;

  //  if RepeatedOptions.MergeHeight and (not FParentReport.IsSecondTime) then
  //  begin
  //  	SetLength(RepeatedOptions.FAryHeight, Length(RepeatedOptions.FAryHeight) + 1);
  //    RepeatedOptions.FAryHeight[Length(RepeatedOptions.FAryHeight)] := FmmHeight;
  //  end;

  lSuppressRepeatedFlag := True;
  if RepeatedOptions.SuppressRepeated and (not RepeatedOptions.MergeRepeated) and (FMemo1.Text = FLastValue) then
  begin
    FMemo1.Text := '';
    lSuppressRepeatedFlag := False;
  end;

  if CanMergeCell then
  begin // 合并单元格
    FLastValueChanged := False;
    lSaveHeight := FmmHeight;
    lSaveTop := FmmTop;
    lSavePosition := aStream.Position;
    aStream.Position := FLastStreamPosition;
    FmmHeight := FmmTop + FmmHeight - FmmLastTop;
    FmmTop := FmmLastTop;
    if FMergeEmpty and (FMemo1.Text = '') then // 合并空行
    begin
      FLastValue := #1;
      FLastValueChanged := True;
    end;

    FMemo1.Text := FLastValue1;
    try
      RMWriteByte(aStream, Typ);
      if Typ = rmgtAddIn then
        RMWriteString(aStream, ClassName);
      SaveToStream(aStream);
    finally
      aStream.Position := lSavePosition;
      FmmHeight := lSaveHeight;
      FmmTop := lSaveTop;
    end;
  end
  else
  begin
    FLastValueChanged := True;
    FLastStreamPosition := aStream.Position;
    FmmLastTop := FmmTop;
    RMWriteByte(aStream, Typ);
    if Typ = rmgtAddIn then
      RMWriteString(aStream, ClassName);
    SaveToStream(aStream);
    if RepeatedOptions.SuppressRepeated and lSuppressRepeatedFlag then
    begin
      FLastValue := FMemo1.Text;
      FLastValue1 := FLastValue;
      FLastValuePage := FParentReport.MasterReport.FPageNo;
    end;
  end;

  if DrawMode = rmdmPart then
  begin
    FMemo1.Assign(FSMemo);
    for i := 0 to CurStrNo - 1 do
      FMemo1.Delete(0);
  end;

  FillColor := lOldFillColor;
  Font.Assign(lOldFont);
  lOldFont.Free;
  DrawMode := rmdmAll;
end;

procedure TRMCustomMemoView.GetMemoVariables; // 取得字段的内容
var
  lSaveText: string;
  lCanExpandVariable: Boolean;
begin
  if DrawMode = rmdmAll then
  begin
    lCanExpandVariable := True;
    if Assigned(FOnBeforeCalc) then
    begin
      FOnBeforeCalc(Self);
    end;

    if Assigned(FOnBeforePrint) then
    begin
      lSaveText := FMemo.Text;
      FOnBeforePrint(Self);
      if lSaveText <> FMemo.Text then
      begin
        lCanExpandVariable := False;
        FMemo1.Assign(Memo);
        FMemo.Text := lSaveText;
      end;
    end;

    if Assigned(FParentReport.OnBeforePrint) then
    begin
      FMemo1.Assign(Memo);
      lSaveText := FMemo1.Text;
      FParentReport.InternalOnBeforePrint(FMemo1, Self);
      if lSaveText <> FMemo1.Text then
        lCanExpandVariable := False;
    end;

    if lCanExpandVariable then
      ExpandMemoVariables;

    if Assigned(FOnAfterCalc) then
      FOnAfterCalc(Self);
  end;
end;

function TRMCustomMemoView.CalcHeight: Integer;
var
  lSaveFont: TFont;
begin
  CalculatedHeight := 0;
  Result := 0;
  if not Visible then Exit;

  CalcGaps;
  DrawMode := rmdmAll;
  GetMemoVariables;
  DrawMode := rmdmAfterCalcHeight;

  lSaveFont := TFont.Create;
  lSaveFont.Assign(Font);
  try
    if (not FParentReport.Flag_TableEmpty) and (Length(Highlight.Condition) <> 0) then
    begin
      try
        if FParentReport.Parser.CalcOPZ(Highlight.Condition) <> 0 then
          Font.Assign(Highlight.Font);
      except
        on E: exception do
          FParentReport.DoError(E);
      end;
    end;

    if FMemo1.Count <> 0 then
    begin
      FNeedWrapped := True;
      WrapMemo;
      FMemo1.Assign(FSMemo);
      CalcGeneratedData(FParentReport.DrawCanvas.Handle);
      CalculatedHeight := FVHeight + spGapTop * 2;
      CalculatedHeight := CalculatedHeight + _CalcVFrameWidth(TopFrame.spWidth, BottomFrame.spWidth);
      CalculatedHeight := RMToMMThousandths(CalculatedHeight, rmutScreenPixels);
    end;
  finally
    Font.Assign(lSaveFont);
    lSaveFont.Free;
    RestoreCoord;
		if RepeatedOptions.MergeRepeated then
    begin
    	if (CalculatedHeight > FmmHeight) and CanMergeCell then
      begin
				CalculatedHeight := FmmHeight;
      end;
    end;

    Result := CalculatedHeight;
  end;
end;

function TRMCustomMemoView.RemainHeight: Integer;
begin
  ActualHeight := RMToMMThousandths(Memo1.Count * LineHeight, rmutScreenPixels) + mmSaveGapY * 2;
  ActualHeight := ActualHeight + _CalcVFrameWidth(mmSaveFWTop, mmSaveFWBottom);
  Result := ActualHeight;
end;

procedure TRMCustomMemoView.Prepare;
var
  t: TRMView;
begin
  inherited Prepare;

  FLastValueChanged := False;

  // 不要重复Prepare
  if (FParentReport.MasterReport.DoublePass and FParentReport.MasterReport.FinalPass) then Exit;

  if Font.Height > 0 then
    Font.Height := -Font.Height;

  Highlight.Condition := FParentReport.Parser.Str2OPZ(Highlight.Condition);
  FMasterView := nil;
  if RepeatedOptions.MergeRepeated and (RepeatedOptions.MasterMemoView <> '') then
  begin
    t := FParentReport.FindObject(RepeatedOptions.MasterMemoView);
    if (t <> nil) and (t is TRMCustomMemoView) and (not RMCmp(Name, t.Name)) then
      FMasterView := t;
  end;
end;

procedure TRMCustomMemoView.ExportData;
begin
  Exporting := True;
  Draw(FParentReport.DrawCanvas);
  Exporting := False;
end;

procedure TRMCustomMemoView.GetBlob;
begin
  if not FParentReport.Flag_TableEmpty then
  begin
    FDataSet.AssignBlobFieldTo(FDataFieldName, Memo1);
  end;
end;

procedure TRMCustomMemoView.ExpandMemoVariables;
var
  i: Integer;
  s: string;
  SaveFlag_TableEmpty: Boolean;
begin
  FMemo1.Clear;
  SaveFlag_TableEmpty := FParentReport.Flag_TableEmpty;
  if FParentReport.Flag_TableEmpty and (ParentBand <> nil) and
    (ParentBand.FBandType in [rmbtMasterData, rmbtDetailData]) then
  begin
    if PrintAtAppendBlank then
      FParentReport.FFlag_TableEmpty := False
    else
      Exit;
  end;

  try
    if DBFieldOnly and (FDataSet <> nil) and (FDataFieldName <> '') then
    begin
      FParentReport.InternalOnGetDataFieldValue(Self, FDataSet, FDataFieldName, s, False);
      //      RMCurReport.InternalOnGetDataFieldValue(FDataSet, F, s);
      FMemo1.Text := s;
    end
    else
    begin
      for i := 0 to Memo.Count - 1 do
      begin
        s := Memo[i];
        if (s <> '') and (not TextOnly) then
          ExpandVariables(s);
        if s <> '' then
          FMemo1.Text := FMemo1.Text + s
        else
          FMemo1.Add('');
      end;
    end;

    if FMemo1.Text = #$13#$10 then
      FMemo1.Clear;
  finally
    FParentReport.FFlag_TableEmpty := SaveFlag_TableEmpty;
  end;
end;

procedure TRMCustomMemoView.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

function TRMCustomMemoView.GetWordwrap: Boolean;
begin
  Result := (FFlags and flMemoWordwrap) = flMemoWordwrap;
end;

procedure TRMCustomMemoView.SetWordwrap(Value: Boolean);
begin
  FFlags := (FFlags and not flMemoWordwrap);
  if Value then
    FFlags := FFlags + flMemoWordwrap;
end;

function TRMCustomMemoView.GetWordBreak: Boolean;
begin
  Result := (FFlags and flMemoWordBreak) = flMemoWordBreak;
end;

procedure TRMCustomMemoView.SetWordBreak(Value: Boolean);
begin
  FFlags := (FFlags and not flMemoWordBreak);
  if Value then
    FFlags := FFlags + flMemoWordBreak;
end;

function TRMCustomMemoView.GetAutoWidth: Boolean;
begin
  Result := (FFlags and flMemoAutoWidth) = flMemoAutoWidth;
end;

procedure TRMCustomMemoView.SetAutoWidth(Value: Boolean);
begin
  FFlags := (FFlags and not flMemoAutoWidth);
  if Value then
    FFlags := FFlags + flMemoAutoWidth;
end;

function TRMCustomMemoView.GetMangeTag: Boolean;
begin
  Result := (FFlags and flMemoMangeTag) = flMemoMangeTag;
end;

procedure TRMCustomMemoView.SetMangeTag(Value: Boolean);
begin
  FFlags := (FFlags and not flMemoMangeTag);
  if Value then
    FFlags := FFlags + flMemoMangeTag;
end;

function TRMCustomMemoView.GetPrintAtAppendBlank: Boolean;
begin
  Result := (FFlags and flPrintAtAppendBlank) = flPrintAtAppendBlank;
end;

procedure TRMCustomMemoView.SetPrintAtAppendBlank(Value: Boolean);
begin
  FFlags := (FFlags and not flPrintAtAppendBlank);
  if Value then
    FFlags := FFlags + flPrintAtAppendBlank;
end;

function TRMCustomMemoView.GetExportAsNumber: Boolean;
begin
  Result := (FFlags and flMemoExportAsNumber) = flMemoExportAsNumber;
end;

procedure TRMCustomMemoView.SetExportAsNumber(Value: Boolean);
begin
  FFlags := (FFlags and not flMemoExportAsNumber);
  if Value then
    FFlags := FFlags + flMemoExportAsNumber;
end;

procedure TRMCustomMemoView.SetRepeatedOptions(Value: TRMRepeatedOptions);
begin
  FRepeatedOptions.MasterMemoView := Value.MasterMemoView;
  FRepeatedOptions.SuppressRepeated := Value.SuppressRepeated;
  FRepeatedOptions.MergeRepeated := Value.MergeRepeated;
end;

function TRMCustomMemoView.GetDBFieldOnly: Boolean;
begin
  Result := (FFlags and flMemoDataFieldOnly) = flMemoDataFieldOnly;
end;

procedure TRMCustomMemoView.SetDBFieldOnly(Value: Boolean);
begin
  FFlags := (FFlags and not flMemoDataFieldOnly);
  if Value then
    FFlags := FFlags + flMemoDataFieldOnly;
end;

function TRMCustomMemoView.GetUnderlines: Boolean;
begin
  Result := (FFlags and flMemoUnderlines) = flMemoUnderlines;
end;

procedure TRMCustomMemoView.SetUnderlines(value: Boolean);
begin
  FFlags := (FFlags and not flMemoUnderlines);
  if Value then
    FFlags := FFlags + flMemoUnderlines;
end;

function TRMCustomMemoView.GetIsCurrency: Boolean;
begin
  Result := (FFlags and flMemoIsCurrency) = flMemoIsCurrency;
end;

procedure TRMCustomMemoView.SetIsCurrency(value: Boolean);
begin
  FFlags := (FFlags and not flMemoIsCurrency);
  if Value then
    FFlags := FFlags + flMemoIsCurrency;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCalcOptions }

constructor TRMCalcOptions.Create(aView: TRMView);
begin
  inherited Create;
  FParentView := aView;
  CalcNoVisible := False;
  CalcType := rmdcSum;
  FResetAfterPrint := True;
end;

function TRMCalcOptions.GetMemo: TStrings;
begin
  Result := FParentView.Memo;
end;

procedure TRMCalcOptions.SetMemo(Value: TStrings);
begin
  FParentView.Memo.Assign(Value);
end;

function TRMCalcOptions.GetTotalCalc: Boolean;
begin
  with FParentView do
    Result := (FFlags and flMemoTotalCalc) = flMemoTotalCalc;
end;

procedure TRMCalcOptions.SetTotalCalc(Value: Boolean);
begin
  with FParentView do
  begin
    FFlags := (FFlags and not flMemoTotalCalc);
    if Value then
      FFlags := FFlags + flMemoTotalCalc;
  end;
end;

function TRMCalcOptions.GetCalcNoVisible: Boolean;
begin
  with FParentView do
    Result := (FFlags and flMemoCalcNoVisible) = flMemoCalcNoVisible;
end;

procedure TRMCalcOptions.SetCalcNoVisible(Value: Boolean);
begin
  with FParentView do
  begin
    FFlags := (FFlags and not flMemoCalcNoVisible);
    if Value then
      FFlags := FFlags + flMemoCalcNoVisible;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCalcMemoView }

constructor TRMCalcMemoView.Create;
begin
  inherited Create;
  Typ := rmgtCalcMemo;
  BaseName := 'CalcMemo';

  Stretched := False;
  WordWrap := False;
  FCalcOptions := TRMCalcOptions.Create(Self);
  FValues := TStringList.Create;
  FResultExpression := '';
  Reset;
end;

destructor TRMCalcMemoView.Destroy;
begin
  FCalcOptions.Free;
  FValues.Free;
  inherited Destroy;
end;

procedure TRMCalcMemoView.ResetValues;
begin
  FValues.Clear;
  FValueIndex := 0;
end;

function TRMCalcMemoView.GetValue: Double;
begin
  if FValues.Count > FValueIndex then
    Result := StrToFloat(FValues[FValueIndex])
  else
  begin
    if IsCurrency then
      Result := FCurrencyValue
    else
      Result := FValue;
  end;
end;

procedure TRMCalcMemoView.AfterPrint(aIsHeaderBand: Boolean);
var
  lHeaderBand: Boolean;
begin
  if (not FParentReport.MasterReport.DoublePass) then Exit;
  if not ParentBand.Visible then Exit;

  if FCalcOptions.TotalCalc then // 总计
  begin
    if not FParentReport.MasterReport.FinalPass then
    begin
      if FValueIndex = 0 then
      begin
        if IsCurrency then
          FValues.Add(CurrToStr(FCurrencyValue))
        else
          FValues.Add(FloatToStr(FValue));
        Inc(FValueIndex);
      end
      else
      begin
        if IsCurrency then
          FValues[0] := CurrToStr(FCurrencyValue)
        else
          FValues[0] := FloatToStr(FValue);
      end;
    end;
  end
  else
  begin
    lHeaderBand := (ParentBand.BandType in [rmbtReportTitle, rmbtPageHeader, rmbtGroupHeader, rmbtHeader,
      rmbtColumnHeader, rmbtMasterData, rmbtDetailData]);

    // True: DoGroupHeaderAggrs中触发
    // False: TRMBand.PrintObject中触发, 在 TRMCalcMemoView.PlaceOnEndPage
    if aIsHeaderBand and lHeaderBand then
    begin
      if not FParentReport.MasterReport.FinalPass then
      begin
        if IsCurrency then
          FValues.Add(CurrToStr(FCurrencyValue))
        else
          FValues.Add(FloatToStr(FValue));
      end;

      Inc(FValueIndex);
    end
    else if (not aIsHeaderBand) and lHeaderBand then
      Inc(FValueIndex);
  end;
end;

procedure TRMCalcMemoView.Reset;
begin
  FResAssigned := False;
end;

procedure TRMCalcMemoView.PlaceOnEndPage(aStream: TStream);
begin
  if IsCurrency then
  begin
    FCurrencyValue := GetValue;
    FParentReport.FCurrentValue := FCurrencyValue;
  end
  else
  begin
    FValue := GetValue;
    FParentReport.FCurrentValue := FValue;
  end;

  AfterPrint(False);

  inherited PlaceOnEndPage(aStream);
  if FCalcOptions.FResetAfterPrint then
    Reset;
end;

function TRMCalcMemoView.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
begin
  Result := True;
  if (aPropName = 'VALUE') or (aPropName = 'CALCVALUE') or (aPropName = 'ASFLOAT') then
  begin
    aValue := GetValue; { FValue}
    ;
  end
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

function TRMCalcMemoView.SetPropValue(aObject: TObject; aPropName: string;
  aValue: Variant): Boolean;
begin
  Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

procedure TRMCalcMemoView.LoadFromStream(aStream: TStream);
var
  lVersion: Word;
begin
  inherited LoadFromStream(aStream);
  lVersion := RMReadWord(aStream);
  if StreamMode = rmsmDesigning then
  begin
    FCalcOptions.FResetAfterPrint := RMReadBoolean(aStream);
    FCalcOptions.FCalcType := TRMDBCalcType(RMReadByte(aStream));
    FCalcOptions.FAggrBandName := RMReadString(aStream);
    FCalcOptions.FFilter := RMReadString(aStream);
    FCalcOptions.FIntalizeValue := RMReadString(aStream);
    FCalcOptions.FAggregateValue := RMReadString(aStream);
    if lVersion >= 1 then
      FResultExpression := RMReadString(aStream);
    if lVersion >= 2 then
      FCalcOptions.FResetGroupName := RMReadString(aStream)
    else
      FCalcOptions.FResetGroupName := '';
  end;
end;

procedure TRMCalcMemoView.SaveToStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 2); //　版本号
  if StreamMode = rmsmDesigning then
  begin
    RMWriteBoolean(aStream, FCalcOptions.FResetAfterPrint);
    RMWriteByte(aStream, Byte(FCalcOptions.CalcType));
    RMWriteString(aStream, FCalcOptions.FAggrBandName);
    RMWriteString(aStream, Trim(FCalcOptions.FFilter));
    RMWriteString(aStream, FCalcOptions.FIntalizeValue);
    RMWriteString(aStream, FCalcOptions.FAggregateValue);
    RMWriteString(aStream, FResultExpression);
    RMWriteString(aStream, FCalcOptions.FResetGroupName);
  end;
end;

procedure TRMCalcMemoView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
var
  m: TRMMenuItem;
begin
  inherited DefinePopupMenu(aPopup);
  aPopup.Add(RMNewLine());

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(SRMCalcType);
  m.OnClick := RMDesigner.RMCalcMemoEditor;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(SRMResetAfterPrint);
  m.OnClick := OnResetAfterPrintClick;
  m.Checked := CalcOptions.ResetAfterPrint;
  aPopup.Add(m);
end;

procedure TRMCalcMemoView.OnResetAfterPrintClick(Sender: TObject);
var
  i: integer;
  t: TRMView;
begin
  RMDesigner.BeforeChange;
  with Sender as TRMMenuItem do
  begin
    Checked := not Checked;
    for i := 0 to RMDesigner.PageObjects.Count - 1 do
    begin
      t := RMDesigner.PageObjects[i];
      if t.Selected and (t is TRMCalcMemoView) then
        TRMCalcMemoView(t).CalcOptions.ResetAfterPrint := not TRMCalcMemoView(t).CalcOptions.ResetAfterPrint;
    end;
  end;
  RMDesigner.AfterChange;
end;

procedure TRMCalcMemoView.Prepare;
begin
  inherited Prepare;
  Reset;
  FParentPage.FAggrList.Add(Self);
end;

procedure TRMCalcMemoView.ExpandMemoVariables;
var
  lStr: string;

  procedure _GetData(var aStr: string);
  var
    lStartPos, lEndPos: Integer;
    s1: string;
    lFormat: TRMFormat;
    lFormatStr: string;
    lFlag: Boolean;
    lValue: Variant;
  begin
    if FResultExpression <> '' then
    begin
      lValue := FParentReport.Parser.CalcOPZ(FResultExpression);
      if lValue = Null then
        lValue := '';
    end
    else
    begin
      if IsCurrency then
        lValue := FCurrencyValue
      else
        lValue := FValue;
    end;

    lFlag := True;
    if aStr <> '' then
    begin
      lStartPos := System.Pos('[', aStr);
      while lStartPos > 0 do
      begin
        lFlag := False;
        s1 := RMGetBrackedVariable(aStr, lStartPos, lEndPos);
        Delete(aStr, lStartPos, lEndPos - lStartPos + 1);
        if lStartPos <> lEndPos then
        begin
          RMGetFormatStr(Self, s1, lFormatStr, lFormat);
          if HideZeros then
          begin
            if (TVarData(lValue).VType = varString) or (TVarData(lValue).VType = varOleStr) then
            begin
              if lValue = '0' then
                lValue := '';
            end
            else if lValue = 0 then
            begin
              lValue := '';
            end;
          end;

          s1 := '';
          if lFormat.FormatIndex1 = 0 then
          begin
            if VarType(lValue) in [varDouble, varSingle] then
              s1 := FormatFloat('#.########', lValue)
            else
              s1 := lValue;
          end
          else
            s1 := RMFormatValue(lValue, lFormat, lFormatStr, False);

          if OutBigNum then // 转换成大写
            s1 := RMCurrToBIGNum(StrToFloat(s1));

          Insert(s1, aStr, lStartPos);
          lStartPos := Pos('[', aStr);
        end
        else
          lStartPos := -1;
      end;
    end;

    if lFlag and ((FCalcOptions.FCalcType = rmdcCount) or (FCalcOptions.FCalcType = rmdcUser)) then
    begin
      if (lValue = 0) and HideZeros then
        aStr := ''
      else
      begin
        s1 := '';
        RMGetFormatStr(Self, s1, lFormatStr, lFormat);
        s1 := RMFormatValue(lValue, lFormat, lFormatStr, False);
        aStr := aStr + s1;
      end;
    end;
  end;

begin
  Memo1.Clear;
  if Memo.Count > 0 then
  begin
    lStr := Memo[0];
    _GetData(lStr);
    Memo1.Add(lStr);
  end
  else
  begin
    lStr := '';
    _GetData(lStr);
    Memo1.Add(lStr);
  end;
end;

procedure TRMCalcMemoView.DoAggregate;
var
  vv: Variant;
  d: Double;
  SaveCurView: TRMReportView;
  lAggrBand: TRMBand;
  cmv {dejoy added}: Variant;
begin
  lAggrBand := FParentReport.FRMAggrBand;
  if RMCmp(lAggrBand.Name, FCalcOptions.FAggrBandName) then // and (Length(FExpression) > 0) then
  begin
    if FParentReport.FFlag_TableEmpty then
    begin
      if not FResAssigned then
      begin
        FResAssigned := True;
        FValue := 0;
        FCurrencyValue := 0;
      end;
      Exit;
    end;

    if not FResAssigned then
    begin
      case FCalcOptions.FCalcType of
        rmdcCount:
          begin
            FValue := 0;
            FCurrencyValue := 0;
          end;
        rmdcSum:
          begin
            FValue := 0;
            FCurrencyValue := 0;
          end;
        rmdcMin:
          begin
            FValue := 1E300;
            FCurrencyValue := 922337203685477.5807;
          end;
        rmdcMax:
          begin
            FValue := -1E300;
            FCurrencyValue := -922337203685477.5807;
          end;
        rmdcAvg:
          begin
            FSum := 0;
            FCount := 0;
            FValue := 0;
            FCurrencyValue := 0;
          end;
        rmdcUser:
          begin
            SaveCurView := TRMReportView(FParentReport.FCurrentView);
            FParentReport.FCurrentView := Self;
            FValue := FParentReport.Parser.CalcOpz(FCalcOptions.FIntalizeValue);
            if FValue = Null then FValue := 0;
            FCurrencyValue := FValue;
            FParentReport.FCurrentView := SaveCurView;
          end;
      end;
      FResAssigned := TRUE;
    end;

    if (not lAggrBand.Visible) and (not FCalcOptions.CalcNoVisible) then Exit;

    if FOPZFilter <> '' then
    begin
      if FParentReport.Parser.CalcOPZ(FOPZFilter) = 0 then
        Exit;
    end;
    d := 0;
    if (FCalcOptions.FCalcType <> rmdcCount) or RepeatedOptions.SuppressRepeated then
    begin
      vv := FParentReport.Parser.Calc(FExpression);
      if (VarType(vv) = varNull) or ((VarType(vv) = varString) and (vv = '')) then
        d := 0
      else
        d := vv;
    end;

    //(*dejoy added begin
    {能实现压缩重复值功能，但有一缺陷，只要mergerepeated为false,masterview就会被置为nil,失去作用，
    所以必须把mergerepeated设为true才能使用masterview,由于我对rm了解不是很深入，不能改正，望whf能修正。
    }
    if (FMasterView <> nil) and (FMasterView.Memo.Text <> '') then
    begin
      cmv := FParentReport.Parser.Calc(FMasterView.Memo.Text);
    end;
    if (RepeatedOptions.SuppressRepeated and
      (((FMasterView = nil) and (FLastAggValue = d)) or ((FMasterView <> nil) and (FLastMasterViewValue = cmv)))) then
    begin
      Exit;
    end;
    FLastAggValue := d;
    FLastMasterViewValue := cmv;
    //dejoy added end*)

    case FCalcOptions.FCalcType of
      rmdcCount:
        begin
          FValue := FValue + 1;
          FCurrencyValue := FCurrencyValue + 1;
        end;
      rmdcSum:
        begin
          FValue := FValue + d;
          FCurrencyValue := FCurrencyValue + d;
        end;
      rmdcMin:
        begin
          if d < FValue then
            FValue := d;
          if d < FCurrencyValue then
            FCurrencyValue := d;
        end;
      rmdcMax:
        begin
          if d > FValue then
            FValue := d;
          if d > FCurrencyValue then
            FCurrencyValue := d;
        end;
      rmdcAvg:
        begin
          FSum := FSum + d;
          Inc(FCount);
          if FCount = 0 then
          begin
            FValue := 0;
            FCurrencyValue := 0;
          end
          else
          begin
            FValue := FSum / FCount;
            FCurrencyValue := FSum / FCount;
          end;
        end;
      rmdcUser:
        begin
          SaveCurView := TRMReportView(FParentReport.FCurrentView);
          FParentReport.FCurrentView := Self;
          FValue := FParentReport.Parser.CalcOpz(FCalcOptions.FAggregateValue);
          if FValue = Null then FValue := 0;
          FCurrencyValue := FValue;
          FParentReport.FCurrentView := SaveCurView;
        end;
    end;
    FResAssigned := TRUE;
  end;
end;

procedure TRMCalcMemoView.SetResultExpression(Value: string);
begin
  FResultExpression := Value;
  if DocMode = rmdmPreviewing then
    FResultExpression := FParentReport.Parser.Str2OPZ(Value);
end;

function TRMCalcMemoView.GetOutBigNum: Boolean;
begin
  Result := (FFlags and flMemoOutBigNum) = flMemoOutBigNum;
end;

procedure TRMCalcMemoView.SetOutBigNum(Value: Boolean);
begin
  FFlags := (FFlags and not flMemoOutBigNum);
  if Value then
    FFlags := FFlags + flMemoOutBigNum;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPictureView }

constructor TRMPictureView.Create;
begin
  inherited Create;
  Typ := rmgtPicture;
  BaseName := 'Picture';

  FFlags := 0;
  FPictureSource := rmpsPicture;
  PictureStretched := True;
  PictureRatio := True;
  Transparent := False;
  FPictureFormat := rmpfBorland;
  FBlobType := rmbtAuto {rmbtBitmap};

  FPicture := TPicture.Create;
end;

destructor TRMPictureView.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

function TRMPictureView.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
begin
  Result := True;
  if aPropName = 'Picture' then
    aValue := O2V(FPicture)
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

function TRMPictureView.SetPropValue(aObject: TObject; aPropName: string;
  aValue: Variant): Boolean;
begin
  Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

procedure TRMPictureView.Draw(aCanvas: TCanvas);
var
  liRect: TRect;
  kx, ky: Double;
  liWidth, liHeight, liWidth1, liHeight1: Integer;

  procedure _PrintGraphic;
  var
    lSaveMode: TCopyMode;
  begin
    lSaveMode := aCanvas.CopyMode;
    try
      if Transparent then
        aCanvas.CopyMode := cmSrcAnd
      else
        aCanvas.CopyMode := cmSrcCopy;

      ShowBackground;
      RMPrintGraphic(aCanvas, liRect, FPicture.Graphic, IsPrinting, DirectDraw, Transparent);
    finally
      aCanvas.CopyMode := lSaveMode;
    end;
  end;

  procedure _DrawEmpty;
  var
    liBmp: TBitmap;
  begin
    with aCanvas do
    begin
      Font.Name := RMLoadStr(SRMDefaultFontName);
      Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
      Font.Charset := StrToInt(RMLoadStr(SCharset));
      Font.Style := [];
      Font.Color := clBlack;
      Font.Charset := RMCharset;
      TextRect(RealRect, RealRect.Left + 20, RealRect.Top + 3, RMLoadStr(SPicture));
      liBmp := TBitmap.Create;
      liBmp.Handle := LoadBitmap(hInstance, 'RM_EMPTY');
      Draw(RealRect.Left + 1, RealRect.Top + 2, liBmp);
      liBmp.Free;
    end;
  end;

begin
  BeginDraw(aCanvas);
  CalcGaps;
  liRect := _DrawRect;
  IntersectClipRect(aCanvas.Handle, liRect.Left, liRect.Top, liRect.Right, liRect.Bottom);
  try
    if (RealRect.Right >= RealRect.Left) and (RealRect.Bottom >= RealRect.Top) then
    begin
      if (FPicture.Graphic <> nil) and (not FPicture.Graphic.Empty) then
      begin
        if PictureStretched then // 缩放图片
        begin
          if PictureRatio then
          begin
            liWidth := RealRect.Right - RealRect.Left;
            liHeight := RealRect.Bottom - RealRect.Top;
            kx := liWidth / FPicture.Width;
            ky := liHeight / FPicture.Height;
            if kx < ky then
              liRect := Rect(RealRect.Left, RealRect.Top, RealRect.Right, RealRect.Top + Round(FPicture.Height * kx))
            else
              liRect := Rect(RealRect.Left, RealRect.Top, RealRect.Left + Round(FPicture.Width * ky), RealRect.Bottom);
            liWidth1 := liRect.Right - liRect.Left;
            liHeight1 := liRect.Bottom - liRect.Top;
            if PictureCenter then
              OffsetRect(liRect, (liWidth - liWidth1) div 2, (liHeight - liHeight1) div 2);
          end
          else
            liRect := RealRect;
        end
        else // 原始大小
        begin
          liRect := RealRect;
          liWidth := Round(FactorX * FPicture.Width);
          liHeight := Round(FactorY * FPicture.Height);
          liRect.Right := liRect.Left + liWidth;
          liRect.Bottom := liRect.Top + liHeight;
          if PictureCenter then
            OffsetRect(liRect, (RealRect.Right - RealRect.Left - liWidth) div 2,
              (RealRect.Bottom - RealRect.Top - liHeight) div 2);
        end;

        _PrintGraphic;
      end
      else
      begin
        ShowBackground;
        if DocMode = rmdmDesigning then
          _DrawEmpty;
      end;
    end;

    ShowFrame;
    RestoreCoord;
  finally
    Windows.SelectClipRgn(aCanvas.Handle, 0);
  end;
end;

procedure TRMPictureView.LoadFromStream(aStream: TStream);
var
  lVersion: Word;
begin
  inherited LoadFromStream(aStream);
  lVersion := RMReadWord(aStream);
  FPictureSource := TRMPictureSource(RMReadByte(aStream));
  RMLoadPicture(aStream, FPicture);
  if lVersion >= 1 then
  begin
    FBlobType := TRMBlobType(RMReadByte(aStream));
    FPictureFormat := TRMPictureFormat(RMReadByte(aStream));
  end
  else
  begin
    FBlobType := rmbtAuto;
    FPictureFormat := rmpfBorland;
  end;
end;

procedure TRMPictureView.SaveToStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 1);
  RMWriteByte(aStream, Byte(FPictureSource));
  RMWritePicture(aStream, FPicture);
  RMWriteByte(aStream, Byte(FBlobType));
  RMWriteByte(aStream, Byte(FPictureFormat));
end;

procedure TRMPictureView.PlaceOnEndPage(aStream: TStream);
var
  lFileName: string;
begin
  BeginDraw(Canvas);
  FMemo1.Assign(Memo);
  FParentReport.InternalOnBeforePrint(FMemo1, Self);
  if not Visible then Exit;

  if (FPictureSource = rmpsFileName) and (Memo1.Count > 0) then
  begin
    lFileName := Memo1[0];
    ExpandVariables(lFileName);
    FPicture.Graphic := nil;
    if FileExists(lFileName) then
      FPicture.LoadFromFile(lFileName);
  end;

  RMWriteByte(aStream, Typ);
  if Typ = rmgtAddIn then
    RMWriteString(aStream, ClassName);
  SaveToStream(aStream);
end;

{$HINTS OFF}

const
  JPEG_FLAG_BEGIN = $D8FF;
  JPEG_FLAG_END = $D9FF;
  JPEG_FRAME = $C0FF;

type
  POSR = ^TOSR;
  TOSR = record
    Width: Word;
    Height: Word;
  end;
  PAccessOLEFieldHeader = ^TAccessOLEFieldHeader;
  TAccessOLEFieldHeader = record
    Signature: Word;
    HeaderSize: Word;
    ObjectType: Integer;
    NameLen: Word;
    ClassLen: Word;
    NameOffset: Word;
    ClassOffset: Word;
    ObjectSize: TOSR;
  end;

  TMetafilePict16 = record
    mm: SmallInt; {Integer 16}
    xExt: SmallInt; {Integer 16}
    yExt: SmallInt; {Integer 16}
    hMF: SmallInt; {THandle 16}
  end;

procedure _FillOLEData(var aOleHeader: TAccessOLEFieldHeader;
  var a_OleClass2Str: string; var aStr: string);
var
  lOLECLASS: PChar;
  lOLESZ: Integer;
  l_OLEHeader: string;
  l_OleNameStr: string;
  l_OleClassStr: string;
  l_OleBMPSize: Integer;
begin
  Move(aStr[1], aOleHeader, SizeOf(aOleHeader));
  lOLESZ := aOleHeader.HeaderSize + 12;
  Inc(lOLESZ);
  lOLECLASS := @aStr[lOLESZ];
  Inc(lOLESZ, StrLen(lOLECLASS));
  Inc(lOLESZ, 12);
  l_OLEHeader := Copy(aStr, 1, lOLESZ);
  l_OleNameStr := Copy(aStr, aOleHeader.NameOffset + 1, aOleHeader.NameLen - 1);
  l_OleClassStr := Copy(aStr, aOleHeader.ClassOffset + 1, aOleHeader.ClassLen - 1);
  a_OleClass2Str := StrPas(lOLECLASS);
  l_OleBMPSize := 0;
  lOLECLASS := @l_OleBMPSize;
  lOLECLASS[0] := aStr[lOLESZ - 3];
  lOLECLASS[1] := aStr[lOLESZ - 2];
  lOLECLASS[2] := aStr[lOLESZ - 1];
  lOLECLASS[3] := aStr[lOLESZ];
  Delete(aStr, 1, lOLESZ);
  aStr := Copy(aStr, 1, l_OleBMPSize);
end;

procedure _Get_ImageType(lStream: TMemoryStream);
var
  lOLESIG: string;
  lBDEIMAGE: string;
  lSourceStr: string;
  lPicHeader: string;

  lBFH: TBITMAPFILEHEADER;
  lSTmp: string;
  lPTmp: PChar;

  lEMFPicture: TPicture;
  lWMFPicture: TMetafilePict16;
  lPWMFPicture: Pointer;
  lPict: TMetafilePict;
  lHEMF: HENHMETAFILE;
  lTmpStream: TMemoryStream;
  lDC: HDC;
  lWND: HWND;
  lOleHeader: TAccessOLEFieldHeader;
  l_OleClass2Str: string;
begin
  if lStream.Size < 10 then Exit;

  SetString(lSourceStr, PChar(lStream.Memory), lStream.Size);

  lOLESIG := Chr($15) + Chr($1C);
  lBDEIMAGE := Chr($01) + Chr($00) + Chr($00) + Chr($01);
  lPicHeader := Copy(lSourceStr, 1, 10);
  if (Pos(lOLESIG, lPicHeader) = 1) then
  begin
    _FillOLEData(lOleHeader, l_OleClass2Str, lSourceStr);
    if (lOleHeader.ObjectType = 3) and (l_OleClass2Str = 'DIB') then // DIB With MISSED BITMAPFILEHEADER HEADER
    begin
      lBFH.bfType := $4D42;
      lBFH.bfSize := Length(lSourceStr) + SizeOf(lBFH);
      lBFH.bfReserved1 := 0;
      lBFH.bfReserved2 := 0;
      lBFH.bfOffBits := 0;
      lPTmp := @lBFH;
      SetString(lSTmp, lPTmp, SizeOf(lBFH));
      lSourceStr := lSTmp + lSourceStr;
      lPicHeader := Copy(lSourceStr, 1, 10);
    end
    else if (lOleHeader.ObjectType = 3) and (l_OleClass2Str = 'METAFILEPICT') then // MetaFile
    begin
      lEMFPicture := TPicture.Create;
      lTmpStream := TMemoryStream.Create;
      try
        lPWMFPicture := @lWMFPicture;
        Move(lSourceStr[1], lPWMFPicture^, SizeOf(lWMFPicture));
        Delete(lSourceStr, 1, SizeOf(lWMFPicture));
        lPict.mm := lWMFPicture.mm;
        lPict.xExt := lWMFPicture.xExt;
        lPict.yExt := lWMFPicture.yExt;
        lWND := GetFocus;
        lDC := GetDC(lWND);
        lHEMF := SetWinMetaFileBits(Length(lSourceStr), PChar(lSourceStr), lDC, lPict);
        ReleaseDC(lWND, lDC);
        if lHEMF <> 0 then
        begin
          lEMFPicture.Metafile.Handle := lHEMF;
          lEMFPicture.Metafile.SaveToStream(lTmpStream);
          SetString(lSourceStr, PChar(lTmpStream.Memory), lTmpStream.Size);
          lPicHeader := Copy(lSourceStr, 1, 10);
          lPicHeader[5] := Chr($78);
        end;
      finally
        lEMFPicture.Free;
        lTmpStream.Free;
      end;
    end;
  end;

  if (Pos(lBDEIMAGE, lPicHeader) = 1) and (Pos('BM', lPicHeader) = 9) then
    Delete(lSourceStr, 1, 8);

  lStream.Clear;
  lStream.Write(lSourceStr[1], Length(lSourceStr));
end;

procedure TRMPictureView.GetBlob;
var
  lGraphic: TGraphic;
  lMemoryStream: TMemoryStream;
  lBlobType: TRMBlobType;
  lOffset: Integer;
  lHeader: array[1..10] of char;
  lIsBorlandPicFormat: Boolean;

  procedure _GetBlobType;
  var
    i: Integer;
    lStr10: string;
    lStr2: string;
    lJPEGFlag1, lJPEGFlag2: WORD;
    lJPEGSTR: string;
    lICOSTR: string;
    lWMFSTR: string;
    lEMFSTR: string;
  begin
    if (FPictureFormat = rmpfBorland) and (FBlobType = rmbtBitmap) then Exit;

    lJPEGSTR := Chr($FF) + Chr($D8);
    lICOSTR := Chr($00) + Chr($00) + Chr($01) + Chr($00);
    lWMFSTR := Chr($D7) + Chr($CD) + Chr($C6) + Chr($9A);
    lEMFSTR := Chr($01) + Chr($00) + Chr($00) + Chr($00) + Chr($78) + Chr($00);
    if FBlobType <> rmbtBitmap then
    begin
      if lMemoryStream = nil then
      begin
        lMemoryStream := TMemoryStream.Create;
        FDataSet.AssignBlobFieldTo(FDataFieldName, lMemoryStream);
      end
      else
        lMemoryStream.Position := lOffset;
    end;

    if FBlobType = rmbtAuto then
    begin
      lMemoryStream.Read(lHeader, 10);
      lMemoryStream.Position := lOffset;
      lBlobType := rmbtBitmap;
      lStr10 := '';
      for i := 1 to 10 do
        lStr10 := lStr10 + lHeader[i];
      lStr2 := lHeader[1] + lHeader[2];
      if (lStr2 = 'BM') or (lStr2 = 'BA') or (lStr2 = 'CI') or (lStr2 = 'CP') or
        (lStr2 = 'IC') or (lStr2 = 'PT') then
      begin
        lBlobType := rmbtBitmap;
      end
      else if Pos('GIF', lStr10) = 1 then
      begin
        {$IFDEF RXGIF}
        lBlobType := rmbtGIF;
        {$ENDIF}
      end
      else if Pos(lJPEGSTR, lStr10) = 1 then
      begin
        {$IFDEF JPEG}
        if lMemoryStream.Size - lOffset > 4 then
        begin
          lMemoryStream.Position := lOffset;
          lMemoryStream.Read(lJPEGFlag1, SizeOf(lJPEGFlag1));
          lMemoryStream.Position := lMemoryStream.Size - 2;
          lMemoryStream.Read(lJPEGFlag2, SizeOf(lJPEGFlag2));
          lMemoryStream.Position := lOffset;
          if (lJPEGFlag1 = JPEG_FLAG_BEGIN) and (lJPEGFlag2 = JPEG_FLAG_END) then
            lBlobType := rmbtJPEG;
        end;
        {$ENDIF}
      end
      else if Pos(lICOSTR, lStr10) = 1 then
      begin
        lBlobType := rmbtIcon;
      end
      else if Pos(lWMFSTR, lStr10) = 1 then
      begin
        lBlobType := rmbtMetafile;
      end
      else if Pos(lEMFSTR, lStr10) = 1 then
      begin
        lBlobType := rmbtMetafile;
      end;
    end
    else
      lBlobType := FBlobType;

    case lBlobType of
      rmbtBitmap: lGraphic := TBitmap.Create;
      rmbtMetafile: lGraphic := TMetafile.Create;
      rmbtIcon: lGraphic := TIcon.Create;
      {$IFDEF JPEG}
      rmbtJPEG: lGraphic := TJPEGImage.Create;
      {$ENDIF}
      {$IFDEF RXGIF}
      rmbtGIF: lGraphic := TJvGIFImage.Create;
      {$ENDIF}
    end;
  end;

begin
  if FParentReport.Flag_TableEmpty then
  begin
    FPicture.Graphic := nil;
    Exit;
  end;

  if FDataSet.FieldIsNull(FDataFieldName) then
    FPicture.Assign(nil)
  else
  begin
    lGraphic := nil;
    lMemoryStream := nil;
    lBlobType := rmbtBitmap;
    lOffset := 0;
    try
      lIsBorlandPicFormat := True;
      case FPictureFormat of
        rmpfBorland:
          _GetBlobType;
        rmpfMicrosoft, rmpfAuto:
          begin
            lMemoryStream := TMemoryStream.Create;
            FDataSet.AssignBlobFieldTo(FDataFieldName, lMemoryStream);

            lMemoryStream.Read(lHeader, 10);
            lMemoryStream.Position := 0;
            lOffset := 0;
            if (lHeader[1] = Chr($15)) and (lHeader[2] = Chr($1C)) then
            begin
              lIsBorlandPicFormat := False;
              _Get_ImageType(lMemoryStream);
            end;
            //              lOffset := Word(lBuffer[3]) + 31
            //           else
            //              lOffset := 0;

            _GetBlobType;
          end;
      end;

      try
        FPicture.Graphic := lGraphic;
        if (lBlobType = rmbtBitmap) and lIsBorlandPicFormat {(lOffset = 0)} then
        begin
          FDataSet.AssignBlobFieldTo(FDataFieldName, FPicture);
        end
        else if lMemoryStream <> nil then
        begin
          lMemoryStream.Position := lOffset;
          FPicture.Graphic.LoadFromStream(lMemoryStream);
        end;
      except
        if lBlobType <> rmbtBitmap then
        begin
          FreeAndNil(lGraphic);
          lGraphic := TBitmap.Create;
          FPicture.Graphic := lGraphic;
          lBlobType := rmbtBitmap;
          if (lBlobType = rmbtBitmap) and lIsBorlandPicFormat {(lOffset = 0)} then
            FDataSet.AssignBlobFieldTo(FDataFieldName, FPicture)
          else
          begin
            lMemoryStream.Position := lOffset;
            FPicture.Graphic.LoadFromStream(lMemoryStream);
          end;
        end;
      end;
    finally
      lGraphic.Free;
      lMemoryStream.Free;
    end;
  end;
end;
{$HINTS ON}

procedure TRMPictureView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
var
  m: TRMMenuItem;
begin
  aPopup.Add(RMNewLine());

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(SStretched);
  m.OnClick := OnPictureStretchedClick;
  m.Checked := PictureStretched;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(SPictureCenter);
  m.OnClick := OnPictureCenterClick;
  m.Checked := PictureCenter;
  aPopup.Add(m);

  m := TRMMenuItem.Create(aPopup);
  m.Caption := RMLoadStr(SKeepAspectRatio);
  m.OnClick := OnKeepAspectRatioClick;
  m.Enabled := PictureStretched;
  if m.Enabled then
    m.Checked := PictureRatio;
  aPopup.Add(m);

  inherited DefinePopupMenu(aPopup);
end;

procedure TRMPictureView.OnPictureStretchedClick(Sender: TObject);
begin
  SetPropertyValue('PictureStretched', not TRMMenuItem(Sender).Checked);
end;

procedure TRMPictureView.OnPictureCenterClick(Sender: TObject);
begin
  SetPropertyValue('PictureCenter', not TRMMenuItem(Sender).Checked);
end;

procedure TRMPictureView.OnKeepAspectRatioClick(Sender: TObject);
begin
  SetPropertyValue('PictureRatio', not TRMMenuItem(Sender).Checked);
end;

procedure TRMPictureView.ShowEditor;
begin
  RMDesigner.PictureViewEditor(Self);
end;

function TRMPictureView.GetPictureCenter: Boolean;
begin
  Result := (FFlags and flPictCenter) = flPictCenter;
end;

procedure TRMPictureView.SetPictureCenter(const value: Boolean);
begin
  FFlags := (FFlags and not flPictCenter);
  if Value then
    FFlags := FFlags + flPictCenter;
end;

function TRMPictureView.GetPictureRatio: Boolean;
begin
  Result := (FFlags and flPictRatio) = flPictRatio;
end;

procedure TRMPictureView.SetPictureRatio(value: Boolean);
begin
  FFlags := (FFlags and not flPictRatio);
  if Value then
    FFlags := FFlags + flPictRatio;
end;

function TRMPictureView.GetPictureStretched: Boolean;
begin
  Result := (FFlags and flPictStretched) = flPictStretched;
end;

procedure TRMPictureView.SetPictureStretched(value: Boolean);
begin
  FFlags := (FFlags and not flPictStretched);
  if Value then
    FFlags := FFlags + flPictStretched;
end;

function TRMPictureView.GetDirectDraw: Boolean;
begin
  Result := (FFlags and flPictDirectDraw) = flPictDirectDraw;
end;

procedure TRMPictureView.SetDirectDraw(Value: Boolean);
begin
  FFlags := (FFlags and not flPictDirectDraw);
  if Value then
    FFlags := FFlags + flPictDirectDraw;
end;

function TRMPictureView.GetViewCommon: string;
begin
  Result := RMLoadStr(SPicture);
end;

procedure TRMPictureView.ClearContents;
begin
  FPicture.Graphic := nil;
  inherited;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMShapeView }

class function TRMShapeView.CanPlaceOnGridView: Boolean;
begin
  Result := False;
end;

constructor TRMShapeView.Create;
begin
  inherited Create;
  Typ := rmgtShape;
  BaseName := 'Shape';

  FShape := rmskRectangle;
  FPen := TPen.Create;
  FBrush := TBrush.Create;
end;

destructor TRMShapeView.Destroy;
begin
  FPen.Free;
  FBrush.Free;
  inherited Destroy;
end;

const
  ShapePenStyles: array[TPenStyle] of DWORD =
  (PS_SOLID, PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT, PS_NULL, PS_INSIDEFRAME);

procedure TRMShapeView.DrawShape;
var
  x, y, x1, y1, liMin: Integer;
  tb: {$IFDEF Delphi4}tagLOGBRUSH{$ELSE}TLogBrush{$ENDIF};
  NewH, OldH: HGDIOBJ;
  liSaveBrush: TBrush;
begin
  x := spLeft;
  y := spTop;
  x1 := spRight;
  y1 := spBottom;
  liMin := Min(spHeight, spWidth);

  tb.lbStyle := BS_SOLID;
  tb.lbColor := FPen.Color;
  NewH := ExtCreatePen(PS_GEOMETRIC + PS_ENDCAP_SQUARE + ShapePenStyles[FPen.Style],
    Max(1, Round(Pen.Width * FactorX)), tb, 0, nil);

  OldH := SelectObject(Canvas.Handle, NewH);
  liSaveBrush := TBrush.Create;
  try
    liSaveBrush.Assign(Canvas.Brush);
    Canvas.Brush := FBrush;
    SetBkMode(Canvas.Handle, Opaque);
    case FShape of
      rmskRectangle:
        Canvas.Rectangle(x, y, x1 + 1, y1 + 1);
      rmskRoundRectangle:
        Canvas.RoundRect(x, y, x1 + 1, y1 + 1, liMin div 4, liMin div 4);
      rmskEllipse:
        Canvas.Ellipse(x, y, x1 + 1, y1 + 1);
      rmskTriangle:
        begin
          Canvas.MoveTo(x1, y1);
          Canvas.LineTo(x, y1);
          Canvas.LineTo(x + (x1 - x) div 2, y);
          Canvas.LineTo(x1, y1);
          Canvas.FloodFill(x + (x1 - x) div 2, y + (y1 - y) div 2, clNone, fsSurface);
        end;
      rmskDiagonal1:
        begin
          Canvas.MoveTo(x, y1);
          Canvas.LineTo(x1, y);
        end;
      rmskDiagonal2:
        begin
          Canvas.MoveTo(x, y);
          Canvas.LineTo(x1, y1);
        end;
      rmskSquare:
        begin
          Canvas.Rectangle(x, y, x + liMin, y + liMin);
        end;
      rmskRoundSquare:
        begin
          Canvas.RoundRect(x, y, x + liMin, y + liMin, liMin div 4, liMin div 4);
        end;
      rmskCircle:
        begin
          Canvas.Ellipse(X, Y, X + liMin, Y + liMin);
        end;
      rmHorLine:
        begin
          Canvas.MoveTo(x, y + spHeight div 2);
          Canvas.LineTo(x1, y + spHeight div 2);
        end;
      rmRightAndLeft:
        begin
          Canvas.MoveTo(x, y);
          Canvas.LineTo(x, y1);
          Canvas.MoveTo(x1 - 1, y);
          Canvas.LineTo(x1 - 1, y1);
        end;
      rmTopAndBottom:
        begin
          Canvas.MoveTo(x, y);
          Canvas.LineTo(x1, y);
          Canvas.MoveTo(x, y1 - 1);
          Canvas.LineTo(x1, y1 - 1);
        end;
      rmVertLine:
        begin
          Canvas.MoveTo(x + spWidth div 2, y);
          Canvas.LineTo(x + spWidth div 2, y1);
        end;
    end;
  finally
    SelectObject(Canvas.Handle, OldH);
    DeleteObject(NewH);
    Canvas.Brush.Assign(liSaveBrush);
    liSaveBrush.Free;
  end;
end;

procedure TRMShapeView.Draw(aCanvas: TCanvas);
var
  liSaveFillColor: Integer;
begin
  BeginDraw(aCanvas);
  Memo1.Assign(Memo);
  CalcGaps;
  liSaveFillColor := FillColor;
  FillColor := clNone;
  ShowBackground;
  FillColor := liSaveFillColor;
  DrawShape;
  RestoreCoord;
end;

procedure TRMShapeView.LoadFromStream(aStream: TStream);
begin
  inherited LoadFromStream(aStream);
  RMReadWord(aStream);
  FShape := TRMShapeType(RMReadByte(aStream));
  Pen.Color := RMReadInt32(aStream);
  Pen.Mode := TPenMode(RMReadByte(aStream));
  Pen.Style := TPenStyle(RMReadByte(aStream));
  Pen.Width := RMReadInt32(aStream);
  Brush.Color := RMReadInt32(aStream);
  Brush.Style := TBrushStyle(RMReadByte(aStream));
end;

procedure TRMShapeView.SaveToStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 0);
  RMWriteByte(aStream, Byte(FShape));
  RMWriteInt32(aStream, Pen.Color);
  RMWriteByte(aStream, Byte(Pen.Mode));
  RMWriteByte(aStream, Byte(Pen.Style));
  RMWriteInt32(aStream, Pen.Width);
  RMWriteInt32(aStream, Brush.Color);
  RMWriteByte(aStream, Byte(Brush.Style));
end;

procedure TRMShapeView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
begin
  //
end;

procedure TRMShapeView.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TRMShapeView.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

function TRMShapeView.GetViewCommon: string;
begin
  Result := '[Shape]';
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMOutlineView }

constructor TRMOutlineView.Create;
begin
  inherited Create;
  Typ := rmgtOutline;
  BaseName := 'Outline';
end;

destructor TRMOutlineView.Destroy;
begin
  inherited Destroy;
end;

function TRMOutlineView.GetOutlineText: string;
begin
  Result := FCaption + #1 +
    IntToStr(FPageNo) + #1 + // 所在页
  IntToStr(spTop) + #1 + // 所在行
  IntToStr(FLevel); // 所在级
end;

procedure TRMOutlineView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
begin
  //
end;

procedure TRMOutlineView.LoadFromStream(aStream: TStream);
begin
  RMReadWord(aStream);
  FCaption := RMReadString(aStream);
  FPageNo := RMReadInt32(aStream);
  FLevel := RMReadInt32(aStream);
  FmmTop := RMReadInt32(aStream);
end;

procedure TRMOutlineView.SaveToStream(aStream: TStream);
begin
  RMWriteWord(aStream, 0);
  RMWriteString(aStream, FCaption);
  RMWriteInt32(aStream, FPageNo);
  RMWriteInt32(aStream, FLevel);
  RMWriteInt32(aStream, FmmTop);
end;

procedure TRMOutlineView.Prepare;
begin
  //
end;

procedure TRMOutlineView.Draw(aCanvas: TCanvas);
begin
  //
end;

procedure TRMOutlineView.PlaceOnEndPage(aStream: TStream);
begin
  RMWriteByte(aStream, Typ);
  if Typ = rmgtAddIn then
    RMWriteString(aStream, ClassName);
  SaveToStream(aStream);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMSubReportView }

class function TRMSubReportView.CanPlaceOnGridView: Boolean;
begin
  Result := True;
end;

function TRMSubReportView.GetViewCommon: string;
begin
  Result := '[SubReport]';
end;

constructor TRMSubReportView.Create;
begin
  inherited Create;
  Typ := rmgtSubReport;
  BaseName := 'SubReport';
  FSubReportType := rmstChild;
  FSubPage := -1;
end;

destructor TRMSubReportView.Destroy;
begin
  inherited Destroy;
end;

procedure TRMSubReportView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
begin
end;

procedure TRMSubReportView.LoadFromStream(aStream: TStream);
begin
  inherited LoadFromStream(aStream);
  RMReadWord(aStream);
  SubReportType := TRMSubReportType(RMReadByte(aStream));
  FSubPage := RMReadWord(aStream);
end;

procedure TRMSubReportView.SaveToStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 0);
  RMWriteByte(aStream, Byte(FSubReportType));
  RMWriteWord(aStream, FSubPage);
end;

procedure TRMSubReportView.Prepare;
var
  lParentPage: TRMReportPage;
  lHeight: Integer;

  procedure _GetRealParentPage;
  var
    lPage: TRMReportPage;
  begin
    lParentPage.FParentPages.Clear;
    lPage := TRMReportPage(FParentPage);
    repeat
      lParentPage.FParentPages.Add(lPage);
      lPage := TRMReportPage(lPage.FParentPage);
    until (lPage = nil) or (not lPage.FIsSubReportPage);
  end;

begin
  if (FParentReport.MasterReport.DoublePass and FParentReport.MasterReport.FinalPass) then Exit;

  FCanPrint := False;
  if (SubPage >= 0) and (SubPage < FParentReport.Pages.Count) then
  begin
    lParentPage := TRMReportPage(FParentReport.Pages[SubPage]);
    lParentPage.FIsSubReportPage := True;
    lParentPage.FParentPage := TRMReportPage(FParentPage);
    lParentPage.FSubReportView := Self;
    _GetRealParentPage;

    lParentPage.FmmMarginLeft := FmmLeft;
    if FSubReportType = rmstFixed then
    begin
      lParentPage.FPageNumber := SubPage + 1;
      lParentPage.FmmMarginTop := FmmTop + TRMReportPage(FParentPage).FmmMarginTop;
      lParentPage.FmmMarginRight := 0;
      lParentPage.FmmMarginBottom := 0;
      lParentPage.FmmOffsetX := 0 {liParentPage.FmmMarginLeft};
      lParentPage.FmmOffsetY := 0 {liParentPage.FmmMarginTop};
      lParentPage.FSubReport_MMLeft := FmmLeft;
      lParentPage.FSubReport_MMTop := FmmTop;

      lHeight := FmmHeight + lParentPage.FmmMarginTop;
      lParentPage.PrinterInfo.PageWidth := Round(RMFromMMThousandths(FmmWidth, rmutScreenPixels));
      lParentPage.PrinterInfo.PageHeight := Round(RMFromMMThousandths(lHeight, rmutScreenPixels));
    end
    else
    begin
      lParentPage.FmmMarginLeft := TRMReportPage(lParentPage.FParentPages[lParentPage.FParentPages.Count - 1]).FmmMarginLeft;
      lParentPage.FmmMarginTop := TRMReportPage(lParentPage.FParentPages[lParentPage.FParentPages.Count - 1]).FmmMarginTop;
      lParentPage.FmmMarginRight := TRMReportPage(lParentPage.FParentPages[lParentPage.FParentPages.Count - 1]).FmmMarginRight;
      lParentPage.FmmMarginBottom := TRMReportPage(lParentPage.FParentPages[lParentPage.FParentPages.Count - 1]).FmmMarginBottom;
      lParentPage.FmmOffsetX := 0 {liParentPage.FmmMarginLeft};
      lParentPage.FmmOffsetY := 0 {liParentPage.FmmMarginTop};
    end;

    FCanPrint := True;
  end;
end;

procedure TRMSubReportView.Draw(aCanvas: TCanvas);
begin
  BeginDraw(aCanvas);
  LeftFrame.Visible := False;
  TopFrame.Visible := False;
  RightFrame.Visible := False;
  BottomFrame.Visible := False;
  CalcGaps;
  with aCanvas do
  begin
    Font.Name := RMLoadStr(SRMDefaultFontName);
    Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
    Font.Charset := StrToInt(RMLoadStr(SCharset));
    Font.Style := [];
    Font.Color := clBlack;
    Font.Charset := RMCharset;
    Pen.Width := 1;
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    Brush.Color := clWhite;
    Rectangle(spLeft, spTop, spRight + 1, spBottom + 1);
    Brush.Style := bsClear;
    TextRect(RealRect, spLeft + 2, spTop + 2, Name);
  end;
  RestoreCoord;
end;

function TRMSubReportView.GetPage: TRMReportPage;
begin
  Result := nil;
  if (SubPage >= 0) and (SubPage < FParentReport.Pages.Count) then
  begin
    Result := TRMReportPage(FParentReport.Pages[SubPage]);
  end
end;

function TRMSubReportView.GetReprintLastPage: Boolean;
begin
  Result := (FFlags and flSubReportReprintLastPage) = flSubReportReprintLastPage;
end;

procedure TRMSubReportView.SetReprintLastPage(Value: Boolean);
begin
  FFlags := (FFlags and not flSubReportReprintLastPage);
  if Value then
    FFlags := FFlags + flSubReportReprintLastPage;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCustomBandView }

class function TRMCustomBandView.CanPlaceOnGridView: Boolean;
begin
  Result := False;
end;

constructor TRMCustomBandView.Create;
begin
  inherited Create;
  FIsBand := True;
  Typ := rmgtBandReportTitle;
  BaseName := 'BandView';
  FFont := TFont.Create;

  FFlags1 := 0;
  FIsVirtualDataSet := False;
  FRangeBegin := rmrbDefault;
  FRangeEnd := rmreDefault;
  FLinesPerPage := 0;
  PrintColumnFirst := True;
  FColumns := 1;
  spColumnGap := 20;
  spColumnWidth := 200;

  //  KeepFooter := True;
end;

destructor TRMCustomBandView.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TRMCustomBandView.LoadFromStream(aStream: TStream);
var
  lVersion: Word;
begin
  inherited LoadFromStream(aStream);
  lVersion := RMReadWord(aStream);
  DataSetName := RMReadString(aStream);
  CrossDataSetName := RMReadString(aStream);
  RMReadBoolean(aStream); // unused
  RMReadFont(aStream, FFont);
  FLinesPerPage := RMReadInt32(aStream);
  FNewPageCondition := RMReadString(aStream);
  FMasterBand := RMReadString(aStream);
  FRangeBegin := TRMRangeBegin(RMReadByte(aStream));
  FRangeEnd := TRMRangeEnd(RMReadByte(aStream));
  FRangeEndCount := RMReadInt32(aStream);
  FmmColumnGap := RMReadInt32(aStream);
  FColumns := RMReadInt32(aStream);
  FmmColumnWidth := RMReadInt32(aStream);
  FGroupCondition := RMReadString(aStream);

  FChildBandName := '';
  FFlags1 := 0;
  if lVersion >= 1 then
  begin
    FmmColumnOffset := RMReadInt32(aStream);
    if lVersion >= 2 then
      FChildBandName := RMReadString(aStream);
  end
  else
    FmmColumnOffset := 0;

  if lVersion >= 3 then
  begin
    FFlags1 := RMReadLongWord(aStream);
    FDataBandName := RMReadString(aStream);
  end;

  if lVersion >= 5 then
  begin
    FOutlineText := RMReadString(aStream);
  end;

  if (lVersion < 4) and (BandType in [rmbtMasterData, rmbtDetailData]) then
    FGroupCondition := '';
end;

procedure TRMCustomBandView.SavetoStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 5);
  RMWriteString(aStream, FDataSetName);
  RMWriteString(aStream, FCrossDataSetName);
  RMWriteBoolean(aStream, False); // unused
  RMWriteFont(aStream, FFont);
  RMWriteInt32(aStream, FLinesPerPage);
  RMWriteString(aStream, FNewPageCondition);
  RMWriteString(aStream, FMasterBand);
  RMWriteByte(aStream, Byte(FRangeBegin));
  RMWriteByte(aStream, Byte(FRangeEnd));
  RMWriteInt32(aStream, FRangeEndCount);
  RMWriteInt32(aStream, FmmColumnGap);
  RMWriteInt32(aStream, FColumns);
  RMWriteInt32(aStream, FmmColumnWidth);
  RMWriteString(aStream, FGroupCondition);
  RMWriteInt32(aStream, FmmColumnOffset);
  RMWriteString(aStream, FChildBandName);
  RMWriteLongWord(aStream, FFlags1);
  RMWriteString(aStream, FDataBandName);
  RMWriteString(aStream, FOutlineText);
end;

procedure TRMCustomBandView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
var
  m: TRMMenuItem;
begin
  aPopup.Add(RMNewLine());

  if FBandType in [rmbtReportTitle, rmbtReportSummary, rmbtMasterData, rmbtDetailData,
    rmbtFooter, rmbtGroupHeader] then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SFormNewPage);
    m.OnClick := OnNewPageAfterClick;
    m.Checked := NewPageAfter;
    aPopup.Add(m);
  end;

  if FBandType in [rmbtMasterData, rmbtDetailData] then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SPrintIfSubsetEmpty);
    m.OnClick := OnPrintIfSubsetEmptyClick;
    m.Checked := PrintIfSubsetEmpty;
    aPopup.Add(m);
  end;

  if FBandType in [rmbtReportTitle, rmbtReportSummary, rmbtPageHeader, rmbtCrossHeader,
    rmbtHeader, rmbtMasterData, rmbtDetailData, rmbtFooter, rmbtGroupHeader, rmbtGroupFooter] then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SStretched);
    m.OnClick := OnStretchedClick;
    m.Checked := Stretched;
    aPopup.Add(m);

    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SBreaked);
    m.OnClick := OnPageBreakedClick;
    m.Checked := PageBreaked;
    aPopup.Add(m);
  end;

  if FBandType in [rmbtPageHeader, rmbtPageFooter] then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SOnFirstPage);
    m.OnClick := OnPrintOnFirstPageClick;
    m.Checked := PrintOnFirstPage;
    aPopup.Add(m);
  end;

  if FBandType = rmbtPageFooter then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SOnLastPage);
    m.OnClick := OnPrintOnLastPageClick;
    m.Checked := PrintOnLastPage;
    aPopup.Add(m);
  end;

  if FBandType in [rmbtHeader, rmbtCrossHeader, rmbtGroupHeader] then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SRepeatHeader);
    m.OnClick := OnReprintOnNewPageClick;
    m.Checked := ReprintOnNewPage;
    aPopup.Add(m);
  end;

  if FBandType in [rmbtMasterData, rmbtDetailData] then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(SAutoAppendBlank);
    m.OnClick := OnAutoAppendBlankClick;
    m.Checked := AutoAppendBlank;
    aPopup.Add(m);

    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(rmRes + 883);
    m.OnClick := OnKeepTogetherClick;
    m.Checked := KeepTogether;
    aPopup.Add(m);

    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(rmRes + 884);
    m.OnClick := OnKeepFooterClick;
    m.Checked := KeepFooter;
    aPopup.Add(m);
  end;

  if FBandType in [rmbtGroupHeader] then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(rmRes + 883);
    m.OnClick := OnKeepTogetherClick;
    m.Checked := KeepTogether;
    aPopup.Add(m);

    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(rmRes + 884);
    m.OnClick := OnKeepFooterClick;
    m.Checked := KeepFooter;
    aPopup.Add(m);
  end;

  if FBandType in [rmbtHeader, rmbtFooter, rmbtMasterData, rmbtDetailData, rmbtChild,
    rmbtReportTitle, rmbtReportSummary, rmbtGroupHeader, rmbtGroupFooter] then
  begin
    m := TRMMenuItem.Create(aPopup);
    m.Caption := RMLoadStr(rmRes + 885);
    m.OnClick := OnKeepChildClick;
    m.Checked := KeepChild;
    aPopup.Add(m);
  end;
end;

procedure TRMCustomBandView.OnKeepFooterClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('KeepFooter', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnKeepTogetherClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('KeepTogether', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnKeepChildClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('KeepChild', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnStretchedClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('Stretched', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnNewPageAfterClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('NewPageAfter', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnPrintIfSubsetEmptyClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('PrintIfSubsetEmpty', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnPageBreakedClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('PageBreaked', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnPrintOnFirstPageClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('PrintOnFirstPage', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnPrintOnLastPageClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('PrintOnLastPage', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnReprintOnNewPageClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('ReprintOnNewPage', TRMMenuItem(Sender).Checked);
end;

procedure TRMCustomBandView.OnAutoAppendBlankClick(Sender: TObject);
begin
  TRMMenuItem(Sender).Checked := not TRMMenuItem(Sender).Checked;
  SetPropertyValue('AutoAppendBlank', TRMMenuItem(Sender).Checked);
end;

const
  CONST_COLOR: array[0..1] of TColor = (clWhite, clSilver);

function SBmp: TBitmap;
var
  i, j: Integer;
begin
  if FSBmp = nil then
  begin
    FSBmp := TBitmap.Create;
    FSBmp.Width := 8;
    FSBmp.Height := 8;
    for j := 0 to 7 do
    begin
      for i := 0 to 7 do
        FSBmp.Canvas.Pixels[i, j] := CONST_COLOR[(j + i) mod 2];
    end;
  end;
  Result := FSBmp;
end;

function BandBmp: TBitmap;
begin
  if FBandBmp = nil then
  begin
    FBandBmp := TBitmap.Create;
    FBandBmp.LoadFromResourceName(hInstance, 'RM_BAND');
  end;
  Result := FBandBmp;
end;

procedure TRMCustomBandView.Draw(aCanvas: TCanvas);
var
  h, oldh: HFont;
  i, liX: Integer;
  liSaveMode: TPenMode;
  lBandName: string;
  x, y, dx, dy: Integer;
  liRect: TRect;

  procedure _DrawTitle(x, y: Integer; const s: string);
  begin
    ExtTextOut(aCanvas.Handle,
      x, y, ETO_CLIPPED, @RealRect, PChar(s), Length(s), nil);
  end;

begin
  if BandType in [rmbtCrossHeader..rmbtCrossFooter] then
  begin
    spTop := 0;
    spHeight := TRMReportPage(RMDesigner.Page).PrinterInfo.PageHeight - TRMReportPage(RMDesigner.Page).spMarginTop -
      TRMReportPage(RMDesigner.Page).spMarginBottom;
  end
  else
  begin
    spLeft := 0;
    spWidth := TRMReportPage(RMDesigner.Page).PrinterInfo.PageWidth - TRMReportPage(RMDesigner.Page).spMarginLeft -
      TRMReportPage(RMDesigner.Page).spMarginRight;
  end;

  BeginDraw(aCanvas);
  CalcGaps;
  x := spLeft;
  y := spTop;
  dx := spWidth;
  dy := spHeight;
  with aCanvas do
  begin
    if TRMReportPage(RMDesigner.Page).FbkPicture.Graphic <> nil then
    begin
      liSaveMode := Pen.Mode;
      Pen.Mode := pmMask;
      Brush.Bitmap := SBmp;
      Rectangle(RealRect.Left, RealRect.Top, RealRect.Right, RealRect.Bottom);
      Pen.Mode := liSaveMode;
    end
    else
    begin
      Brush.Bitmap := SBmp;
      FillRect(RealRect);
    end;

    Font.Name := RMLoadStr(SRMDefaultFontName);
    Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
    Font.Charset := StrToInt(RMLoadStr(SCharset));
    Font.Style := [];
    Font.Color := clBlack;
    SetFactorFont(aCanvas);

    Pen.Style := psSolid; //psDot;
    Pen.Width := 1;
    Pen.Color := $FF8080; //clBtnFace;
    Brush.Style := bsClear;
    Rectangle(x, y, x + dx + 1, y + dy + 1);
    if (Columns > 1) and (BandType in [rmbtMasterData, rmbtDetailData]) then
    begin
      Pen.Style := psDot;
      Pen.Color := clBlack;
      for i := 1 to Columns do
        Rectangle(spColumnOffset + (i - 1) * (spColumnWidth + spColumnGap), y,
          spColumnOffset + (i - 1) * (spColumnWidth + spColumnGap) + spColumnWidth, spBottom);
    end;
    Pen.Style := psSolid;
    Pen.Color := clBtnFace;
    Brush.Color := clBtnFace;

    lBandName := RMBandNames[BandType] + ':' + Name;
    if RMShowBandTitles then
    begin
      if BandType in [rmbtCrossHeader..rmbtCrossFooter] then
      begin
        Pen.Color := clBtnShadow;
        FillRect(Rect(x - GetFactorSize(18), y, x, spHeight));
        h := RMCreateAPIFont(Font, 90, 0);
        oldh := SelectObject(Handle, h);
        TextOut(x - GetFactorSize(15), y + TextWidth(lBandName) + GetFactorSize(4), lBandName);
        SelectObject(Handle, oldh);
        DeleteObject(h);
      end
      else
      begin
        Pen.Color := clBtnShadow;
        FillRect(Rect(x, y - GetFactorSize(18), spWidth, y));
        TextOut(x + 4, y - GetFactorSize(18) + (GetFactorSize(18) - TextHeight(lBandName)) div 2, lBandName);
        if BandType in [rmbtMasterData, rmbtDetailData] then
        begin
          liX := spRight - TextWidth(DataSetName) - GetFactorSize(6);
          if FParentReport.FDesigner.Factor = 100 then
            aCanvas.Draw(liX - BandBmp.Width - GetFactorSize(6), y - GetFactorSize(18) + (GetFactorSize(18) - BandBmp.Height) div 2, BandBmp)
          else
          begin
            liRect := Rect(0, 0, GetFactorSize(BandBmp.Width), GetFactorSize(BandBmp.Height));
            OffsetRect(liRect, liX - GetFactorSize(BandBmp.Width) - GetFactorSize(6),
              y - GetFactorSize(18) + (GetFactorSize(18) - GetFactorSize(BandBmp.Height)) div 2);
            aCanvas.StretchDraw(liRect, BandBmp);
          end;
          TextOut(liX, y - GetFactorSize(18) + (GetFactorSize(18) - TextHeight(DataSetName)) div 2, DataSetName);
        end;
      end;
    end
    else
    begin
      Brush.Style := bsClear;
      if BandType in [rmbtCrossHeader..rmbtCrossFooter] then
      begin
        h := RMCreateAPIFont(Font, 90, 0);
        oldh := SelectObject(Handle, h);
        _DrawTitle(x + GetFactorSize(2), y + GetFactorSize(94), lBandName);
        SelectObject(Handle, oldh);
        DeleteObject(h);
      end
      else
      begin
        _DrawTitle(x + GetFactorSize(14), y + GetFactorSize(2), lBandName);
        if BandType in [rmbtMasterData, rmbtDetailData] then
        begin
          liX := spRight - TextWidth(DataSetName) - GetFactorSize(6);
          aCanvas.Draw(liX - BandBmp.Width - GetFactorSize(6), y + GetFactorSize(2), BandBmp);
          TextOut(liX, GetFactorSize(y) + 2, DataSetName);
        end;
      end;
    end;
  end;

  RestoreCoord;
end;

function TRMCustomBandView.GetClipRgn(rt: TRMRgnType): HRGN;
var
  R: HRGN;
  x, y, dx, dy: Integer;
begin
  if not RMShowBandTitles then
  begin
    Result := inherited GetClipRgn(rt);
    Exit;
  end;

  x := spLeft_Designer;
  y := spTop_Designer;
  dx := spWidth_Designer;
  dy := spHeight_Designer;
  if rt = rmrtNormal then
    Result := CreateRectRgn(x, y, x + dx + 1, y + dy + 1)
  else
    Result := CreateRectRgn(x - GetFactorSize(10), y - GetFactorSize(10), x + dx + GetFactorSize(10), y + dy + GetFactorSize(10));
  if BandType in [rmbtCrossHeader..rmbtCrossFooter] then
    R := CreateRectRgn(x - GetFactorSize(18), y, x + dx, y + dy)
  else
    R := CreateRectRgn(x, y - GetFactorSize(18), x + dx, y + dy);
  CombineRgn(Result, Result, R, RGN_OR);
  DeleteObject(R);
end;

function TRMCustomBandView.GetspColumnGap(index: Integer): Integer;
begin
  case index of
    0: Result := Round(RMFromMMThousandths(FmmColumnGap, rmutScreenPixels));
    1: Result := Round(RMFromMMThousandths(FmmColumnWidth, rmutScreenPixels));
    2: Result := Round(RMFromMMThousandths(FmmColumnOffset, rmutScreenPixels));
  else
    Result := 0;
  end;
end;

procedure TRMCustomBandView.SetspColumnGap(index: Integer; Value: Integer);
begin
  case index of
    0: FmmColumnGap := RMToMMThousandths(Value, rmutScreenPixels);
    1: FmmColumnWidth := RMToMMThousandths(Value, rmutScreenPixels);
    2: FmmColumnOffset := RMToMMThousandths(Value, rmutScreenPixels);
  end;
end;

function TRMCustomBandView.GetColumnGap(index: Integer): Double;
begin
  case index of
    0: Result := RMFromMMThousandths(FmmColumnGap, GetUnits);
    1: Result := RMFromMMThousandths(FmmColumnWidth, GetUnits);
    2: Result := RMFromMMThousandths(FmmColumnOffset, GetUnits);
  else
    Result := 0;
  end;
end;

procedure TRMCustomBandView.SetColumnGap(index: Integer; Value: Double);
begin
  case index of
    0: FmmColumnGap := RMToMMThousandths(Value, GetUnits);
    1: FmmColumnWidth := RMToMMThousandths(Value, GetUnits);
    2: FmmColumnOffset := RMToMMThousandths(Value, GetUnits);
  end;
end;

procedure TRMCustomBandView.SetGroupHeaderBandName(Value: string);
begin
  FMasterBand := Value;
end;

procedure TRMCustomBandView.SetDataSetName(Value: string);
var
  V, Code: Integer;
begin
  Value := Trim(Value);
  FIsVirtualDataSet := (Value <> '') and (Value[1] in ['-', '1'..'9']); // 虚拟数据集
  if FIsVirtualDataSet then
  begin
    Val(Value, V, Code);
    if (Code = 0) and (V > 0) then
      FDataSetName := Value;
  end
  else
    FDataSetName := Value;
end;

procedure TRMCustomBandView.SetCrossDataSetName(Value: string);
begin
  FIsVirtualCrossDataSet := (Value <> '') and (Value[1] in ['1'..'9']); // 虚拟数据集
  FCrossDataSetName := Value;
end;

procedure TRMCustomBandView.SetRangeEndCount(Value: Integer);
begin
  if FRangeEndCount = Value then Exit;

  FRangeEndCount := Value;
  if DocMode = rmdmPreviewing then
  begin
    if (FRangeEnd <> rmreDefault) or IsVirtualDataSet then
    begin
      if (FDataSet <> nil) and (FRangeEndCount > 0) then
        FDataSet.RangeEndCount := FRangeEndCount;
    end;
  end;
end;

procedure TRMCustomBandView.SetChildBandName(Value: string);
var
  t: TRMView;
begin
  FChildBandName := Trim(Value);
  TRMBand(Self).FBandChild := nil;
  if (Value <> '') and (DocMode = rmdmPreviewing) then
  begin
    t := ParentPage.FindObject(Value);
    if (t <> nil) and (t is TRMBandChild) then
      TRMBandChild(Self).FBandChild := TRMBand(t);
  end;
end;

procedure TRMCustomBandView.SetNewPageCondition(Value: string);
begin
  FNewPageCondition := Trim(Value);
  if (Value <> '') and (DocMode = rmdmPreviewing) then
  begin
    FNewPageCondition := FParentReport.Parser.Str2OPZ(FNewPageCondition);
  end;
end;

procedure TRMCustomBandView.SetMasterBand(Value: string);
begin
  FMasterBand := Trim(Value);
end;

procedure TRMCustomBandView.SetDataBandName(Value: string);
begin
  FDataBandName := Trim(Value);
end;

procedure TRMCustomBandView.SetGroupCondition(Value: string);
begin
  FGroupCondition := Trim(Value);
  if DocMode = rmdmPreviewing then
  begin
    FGroupCondition := FParentReport.Parser.Str2OPZ(FGroupCondition);
  end;
end;

procedure TRMCustomBandView.SetOutlineText(Value: string);
begin
  FOutlineText := Trim(Value);
  if DocMode = rmdmPreviewing then
  begin
    FOutlineText := FParentReport.Parser.Str2OPZ(FOutlineText);
  end;
end;

procedure TRMCustomBandView.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

function TRMCustomBandView.GetPrintOnFirstPage: Boolean;
begin
  Result := (FFlags and flBandOnFirstPage) = flBandOnFirstPage;
end;

procedure TRMCustomBandView.SetPrintOnFirstPage(Value: Boolean);
begin
  FFlags := (FFlags and not flBandOnFirstPage);
  if Value then
    FFlags := FFlags + flBandOnFirstPage;
end;

function TRMCustomBandView.GetPrintOnLastPage: Boolean;
begin
  Result := (FFlags and flBandOnLastPage) = flBandOnLastPage;
end;

procedure TRMCustomBandView.SetPrintOnLastPage(Value: Boolean);
begin
  FFlags := (FFlags and not flBandOnLastPage);
  if Value then
    FFlags := FFlags + flBandOnLastPage;
end;

function TRMCustomBandView.GetPrintIfSubsetEmpty: Boolean;
begin
  Result := (FFlags and flBandPrintifSubsetEmpty) = flBandPrintifSubsetEmpty;
end;

procedure TRMCustomBandView.SetPrintIfSubsetEmpty(Value: Boolean);
begin
  FFlags := (FFlags and not flBandPrintifSubsetEmpty);
  if Value then
    FFlags := FFlags + flBandPrintifSubsetEmpty;
end;

function TRMCustomBandView.GetAutoAppendBlank: Boolean;
begin
  Result := (FFlags and flBandAutoAppendBlank) = flBandAutoAppendBlank;
end;

procedure TRMCustomBandView.SetAutoAppendBlank(Value: Boolean);
begin
  FFlags := (FFlags and not flBandAutoAppendBlank);
  if Value then
    FFlags := FFlags + flBandAutoAppendBlank;
end;

function TRMCustomBandView.GetNewPageAfter: Boolean;
begin
  Result := (FFlags and flBandNewPageAfter) = flBandNewPageAfter;
end;

procedure TRMCustomBandView.SetNewPageAfter(Value: Boolean);
begin
  FFlags := (FFlags and not flBandNewPageAfter);
  if Value then
    FFlags := FFlags + flBandNewPageAfter;
end;

function TRMCustomBandView.GetNewPageBefore: Boolean;
begin
  Result := (FFlags and flBandNewPageBefore) = flBandNewPageBefore;
end;

procedure TRMCustomBandView.SetNewPageBefore(Value: Boolean);
begin
  FFlags := (FFlags and not flBandNewPageBefore);
  if Value then
    FFlags := FFlags + flBandNewPageBefore;
end;

function TRMCustomBandView.GetPageBreaked: Boolean;
begin
  Result := (FFlags and flBandPageBreaked) = flBandPageBreaked;
end;

procedure TRMCustomBandView.SetPageBreaked(Value: Boolean);
begin
  FFlags := (FFlags and not flBandPageBreaked);
  if Value then
    FFlags := FFlags + flBandPageBreaked;
end;

function TRMCustomBandView.GetHideIfEmpty: Boolean;
begin
  Result := (FFlags and flBandHideIfEmpty) = flBandHideIfEmpty;
end;

procedure TRMCustomBandView.SetHideIfEmpty(Value: Boolean);
begin
  FFlags := (FFlags and not flBandHideIfEmpty);
  if Value then
    FFlags := FFlags + flBandHideIfEmpty;
end;

function TRMCustomBandView.GetReprintOnNewPage: Boolean;
begin
  Result := (FFlags and flBandReprintOnNewPage) = flBandReprintOnNewPage;
end;

procedure TRMCustomBandView.SetReprintOnNewPage(Value: Boolean);
begin
  FFlags := (FFlags and not flBandReprintOnNewPage);
  if Value then
    FFlags := FFlags + flBandReprintOnNewPage;
end;

function TRMCustomBandView.GetReprintOnNewColumn: Boolean;
begin
  Result := (FFlags and flBandReprintOnNewColumn) = flBandReprintOnNewColumn;
end;

procedure TRMCustomBandView.SetReprintOnNewColumn(Value: Boolean);
begin
  FFlags := (FFlags and not flBandReprintOnNewColumn);
  if Value then
    FFlags := FFlags + flBandReprintOnNewColumn;
end;

function TRMCustomBandView.GetKeepFooter: Boolean;
begin
  Result := (FFlags1 and flBandKeepFooter) = flBandKeepFooter;
end;

procedure TRMCustomBandView.SetKeepFooter(Value: Boolean);
begin
  FFlags1 := (FFlags1 and not flBandKeepFooter);
  if Value then
    FFlags1 := FFlags1 + flBandKeepFooter;
end;

function TRMCustomBandView.GetKeepTogether: Boolean;
begin
  Result := (FFlags1 and flBandKeepTogether) = flBandKeepTogether;
end;

procedure TRMCustomBandView.SetKeepTogether(Value: Boolean);
begin
  FFlags1 := (FFlags1 and not flBandKeepTogether);
  if Value then
    FFlags1 := FFlags1 + flBandKeepTogether;
end;

function TRMCustomBandView.GetKeepChild: Boolean;
begin
  Result := (FFlags1 and flBandKeepChild) = flBandKeepChild;
end;

procedure TRMCustomBandView.SetKeepChild(Value: Boolean);
begin
  FFlags1 := (FFlags1 and not flBandKeepChild);
  if Value then
    FFlags1 := FFlags1 + flBandKeepChild;
end;

function TRMCustomBandView.GetPrintatDesignPos: Boolean;
begin
  Result := (FFlags and flBandPrintAtDesignPos) = flBandPrintAtDesignPos;
end;

procedure TRMCustomBandView.SetPrintatDesignPos(Value: Boolean);
begin
  FFlags := (FFlags and not flBandPrintatDesignPos);
  if Value then
    FFlags := FFlags + flBandPrintAtDesignPos;
end;

function TRMCustomBandView.GetPrintBeforeSummaryBand: Boolean;
begin
  Result := (FFlags and flBandPrintBeforeSummaryBand) = flBandPrintBeforeSummaryBand;
end;

procedure TRMCustomBandView.SetPrintBeforeSummaryBand(Value: Boolean);
begin
  FFlags := (FFlags and not flBandPrintBeforeSummaryBand);
  if Value then
    FFlags := FFlags + flBandPrintBeforeSummaryBand;
end;

function TRMCustomBandView.GetAlignToBottom: Boolean;
begin
  Result := (FFlags and flBandAlignToBottom) = flBandAlignToBottom;
end;

procedure TRMCustomBandView.SetAlignToBottom(Value: Boolean);
begin
  FFlags := (FFlags and not flBandAlignToBottom);
  if Value then
    FFlags := FFlags + flBandAlignToBottom;
end;

function TRMCustomBandView.GetPrintChildIfInvisible: Boolean;
begin
  Result := (FFlags and flBandPrintChildIfInvisible) = flBandPrintChildIfInvisible;
end;

function TRMCustomBandView.GetPrintIfEmpty: Boolean;
begin
  Result := (FFlags and flBandPrintIfEmpty) = flBandPrintIfEmpty;
end;

procedure TRMCustomBandView.SetPrintIfEmpty(Value: Boolean);
begin
  FFlags := (FFlags and not flBandPrintIfEmpty);
  if Value then
    FFlags := FFlags + flBandPrintIfEmpty;
end;

procedure TRMCustomBandView.SetPrintChildIfInvisible(Value: Boolean);
begin
  FFlags := (FFlags and not flBandPrintChildIfInvisible);
  if Value then
    FFlags := FFlags + flBandPrintChildIfInvisible;
end;

function TRMCustomBandView.GetPrintColumnFirst: Boolean;
begin
  Result := (FFlags and flBandPrintColumnFirst) = flBandPrintColumnFirst;
end;

procedure TRMCustomBandView.SetPrintColumnFirst(Value: Boolean);
begin
  FFlags := (FFlags and not flBandPrintColumnFirst);
  if Value then
    FFlags := FFlags + flBandPrintColumnFirst;
end;

function TRMCustomBandView.GetAdjustColumns: Boolean;
begin
  Result := (FFlags1 and flBandAdjustColumns) = flBandAdjustColumns;
end;

procedure TRMCustomBandView.SetAdjustColumns(Value: Boolean);
begin
  FFlags1 := (FFlags1 and not flBandAdjustColumns);
  if Value then
    FFlags1 := FFlags1 + flBandAdjustColumns;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandReportTitle }

constructor TRMBandReportTitle.Create;
begin
  inherited Create;
  Typ := rmgtBandReportTitle;
  BaseName := 'ReportTitle';
  FBandType := rmbtReportTitle;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandReportSummary}

constructor TRMBandReportSummary.Create;
begin
  inherited Create;
  Typ := rmgtBandReportSummary;
  BaseName := 'ReportSummary';
  FBandType := rmbtReportSummary;
  PageBreaked := True;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandPageHeader }

constructor TRMBandPageHeader.Create;
begin
  inherited Create;
  Typ := rmgtBandPageHeader;
  BaseName := 'PageHeader';
  FBandType := rmbtPageHeader;
  PrintOnFirstPage := True;
  PrintOnLastPage := True;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandPageFooter }

constructor TRMBandPageFooter.Create;
begin
  inherited Create;
  Typ := rmgtBandPageFooter;
  BaseName := 'PageFooter';
  FBandType := rmbtPageFooter;
  PrintOnFirstPage := True;
  PrintOnLastPage := True;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandColumnHeader }

constructor TRMBandColumnHeader.Create;
begin
  inherited Create;
  Typ := rmgtBandColumnHeader;
  BaseName := 'ColumnHeader';
  FBandType := rmbtColumnHeader;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandColumnFooter }

constructor TRMBandColumnFooter.Create;
begin
  inherited Create;
  Typ := rmgtBandColumnFooter;
  BaseName := 'ColumnFooter';
  FBandType := rmbtColumnFooter;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandHeader }

constructor TRMBandHeader.Create;
begin
  inherited Create;
  Typ := rmgtBandHeader;
  BaseName := 'Header';
  FBandType := rmbtHeader;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandFooter }

constructor TRMBandFooter.Create;
begin
  inherited Create;
  Typ := rmgtBandFooter;
  BaseName := 'Footer';
  FBandType := rmbtFooter;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandMasterData }

constructor TRMBandMasterData.Create;
begin
  inherited Create;
  Typ := rmgtBandMasterData;
  BaseName := 'MasterData';
  FBandType := rmbtMasterData;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandDetailData }

constructor TRMBandDetailData.Create;
begin
  inherited Create;
  Typ := rmgtBandDetailData;
  BaseName := 'DetailData';
  FBandType := rmbtDetailData;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandGroupHeader }

constructor TRMBandGroupHeader.Create;
begin
  inherited Create;
  Typ := rmgtBandGroupHeader;
  BaseName := 'GroupHeader';
  FBandType := rmbtGroupHeader;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandGroupFooter }

constructor TRMBandGroupFooter.Create;
begin
  inherited Create;
  Typ := rmgtBandGroupFooter;
  BaseName := 'GroupFooter';
  FBandType := rmbtGroupFooter;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandOverlay }

constructor TRMBandOverlay.Create;
begin
  inherited Create;
  Typ := rmgtBandOverlay;
  BaseName := 'Overlay';
  FBandType := rmbtOverlay;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandChild }

constructor TRMBandChild.Create;
begin
  inherited Create;
  Typ := rmgtBandChild;
  BaseName := 'Child';
  FBandType := rmbtChild;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandCrossHeader }

constructor TRMBandCrossHeader.Create;
begin
  inherited Create;
  FIsCrossBand := True;
  Typ := rmgtBandCrossHeader;
  BaseName := 'CrossHeader';
  FBandType := rmbtCrossHeader;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandCrossData }

constructor TRMBandCrossData.Create;
begin
  inherited Create;
  FIsCrossBand := True;
  Typ := rmgtBandCrossData;
  BaseName := 'CrossData';
  FBandType := rmbtCrossData;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBandCrossFooter }

constructor TRMBandCrossFooter.Create;
begin
  inherited Create;
  FIsCrossBand := True;
  Typ := rmgtBandCrossFooter;
  BaseName := 'CrossFooter';
  FBandType := rmbtCrossFooter;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBand }
const
  MAXBNDS = 2;
  Bnds: array[1..MAXBNDS] of TRMBandType = (rmbtMasterData, rmbtDetailData);

constructor TRMBand.Create;
begin
  inherited Create;

  FNextGroup := nil;
  FPrevGroup := nil;
  FFirstGroup := nil;
  FLastGroup := nil;
  FHeaderBand := nil;
  FFooterBand := nil;
  FDataBand := nil;
  FLastBand := nil;

  FPositions[rmpsLocal] := 1;
  FPositions[rmpsGlobal] := 1;
  FVisible := True;

  FObjects := TList.Create;
  FSubReports := TList.Create;
  FAggrValues := TRMVariables.Create;
end;

destructor TRMBand.Destroy;
begin
  FreeAndNil(FObjects);
  FreeAndNil(FSubReports);
  FreeAndNil(FAggrValues);
  inherited Destroy;
end;

function TRMBand.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
begin
  Result := True;
  if aPropName = 'ROWNO' then
    aValue := FNowLine
  else if aPropName = 'ROWCOUNT' then
    aValue := FPositions[rmpsLocal]
  else if aPropName = 'CURRENTCOLUMN' then
    aValue := FCurrentColumn
  else if aPropName = 'COLUMNS' then
    aValue := Columns
  else if aPropName = 'DATASET' then
    aValue := O2V(FDataSet)
  else if aPropName = 'OBJECTS' then
    aValue := O2V(Objects)
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

procedure TRMBand.Prepare;

  procedure _InitDataSet;
  begin
    if FBandType = rmbtGroupHeader then
      FGroupCondition := FParentReport.Parser.Str2OPZ(FGroupCondition)
    else
      RMCreateDataSet(FParentReport, DataSetName, IsVirtualDataSet, FDataSet);

    if FParentReport.MasterReport.ErrorFlag then Exit;
    if (FBandType = rmbtMasterData) and (FDataset = nil) then
    begin
      FDataSet := FParentReport.Dataset;
      if FDataSet <> nil then
        FDataSet.Init;
    end;

    if FDataSet <> nil then
    begin
      FSaveRangeBegin := FDataSet.RangeBegin;
      FSaveRangeEnd := FDataSet.RangeEnd;
      FSaveRangeEndCount := FDataSet.RangeEndCount;
      if FRangeBegin <> rmrbDefault then
        FDataSet.RangeBegin := FRangeBegin;
      if FRangeEnd <> rmreDefault then
      begin
        if not IsVirtualDataSet then
          FDataSet.RangeEnd := FRangeEnd;
        if FRangeEndCount > 0 then
          FDataSet.RangeEndCount := FRangeEndCount;
      end;
    end;
  end;

begin
  FNewPageCondition := FParentReport.Parser.Str2OPZ(FNewPageCondition);
  FCurrentColumn := 1;
  FLastPageNo := 0;
  DataSetName := FParentReport.Dictionary.RealDataSetName[DataSetName];
  CrossDataSetName := FParentReport.Dictionary.RealDataSetName[CrossDataSetName];
  _InitDataSet;
end;

procedure TRMBand.UnPrepare;
begin
  if FDataSet <> nil then
  begin
    if (FRangeBegin <> rmrbDefault) or (FRangeEnd <> rmreDefault) then
    begin
      FDataSet.RangeBegin := FSaveRangeBegin;
      FDataSet.RangeEnd := FSaveRangeEnd;
      FDataSet.RangeEndCount := FSaveRangeEndCount;
    end;
  end;

  if FDataSet <> nil then
    FDataSet.Exit;
  if FIsVirtualDataSet and (FDataSet <> nil) then
  begin
    FreeAndNil(FDataSet);
  end;

  if FVirtualCrossDataSet <> nil then
    FVirtualCrossDataSet.Exit;
  if FIsVirtualCrossDataSet and (FVirtualCrossDataSet <> nil) then
  begin
    FreeAndNil(FVirtualCrossDataSet);
  end;
end;

procedure TRMBand.DoAggregate;

  procedure _DoOldAggregate;
  var
    lAggrType: Integer;
    i: Integer;
    s, s1, s2, lLastExpr: string;
    lValue, lCurValue, lLastValue: Variant;
  begin
    if HasCross then
    begin
      i := 0;
      while i < FAggrValues.Count do
      begin
        s := FAggrValues.Name[i];
        s1 := RMExtractField(s, 1);
        s2 := IntToStr(FParentPage.FColumnPos) + Copy(s, 2, 255);
        if s1 = '0' then
          if FAggrValues.IndexOf(s2) = -1 then
          begin
            FAggrValues[s2] := 0;
            i := -1;
          end;
        Inc(i);
      end;
    end;

    lLastExpr := '';
    lLastValue := 0;
    for i := 0 to FAggrValues.Count - 1 do
    begin
      s := FAggrValues.Name[i];
      if HasCross then
      begin
        s1 := RMExtractField(s, 1);
        s2 := IntToStr(FParentPage.FColumnPos) + Copy(s, 2, 255);
        if (s1 = '0') or (StrToInt(s1) <> FParentPage.FColumnPos) then
          continue
        else
          s := Copy(s, Pos(#1, s) + 1, 255);
      end;

      lValue := FAggrValues.Value[i];
      s1 := RMExtractField(s, 2);
      lAggrType := Ord(s1[1]);
      s1 := RMExtractField(s, 3); // expression
      s2 := Trim(RMExtractField(s, 4)); // include invisible bands
      lCurValue := 0;
      if lAggrType <> atCount then
      begin
        if lLastExpr <> s1 then
          lCurValue := FParentReport.Parser.Calc(s1)
        else
          lCurValue := lLastValue;
        lLastExpr := s1;
        lLastValue := lCurValue;
      end;

      if lValue = Null then
        lValue := 0;
      if lCurValue = Null then
        lCurValue := 0;
      if Visible or (s2 = '1') then
      begin
        case lAggrType of
          atSum, atAvg:
            lValue := lValue + lCurValue;
          atMin:
            begin
              if lCurValue < lValue then
                lValue := lCurValue;
            end;
          atMax:
            begin
              if lCurValue > lValue then
                lValue := lCurValue;
            end;
          atCount:
            lValue := lValue + 1;
        end;
      end;

      FAggrValues.Value[i] := lValue;
    end;

    Inc(FAggrCount);
  end;

var
  i: Integer;
begin
  FParentReport.FRMAggrBand := Self;
  if not FParentReport.Flag_TableEmpty then
    _DoOldAggregate;

  with FParentPage.FAggrList do
  begin
    for i := 0 to Count - 1 do
      TRMCalcMemoView(Items[i]).DoAggregate;
  end;
end;

procedure TRMBand.InitValues;
var
  b: TRMBand;
  i: Integer;
  t: TRMCalcMemoView;
  lStr, lStr1: string;
  lValue: Variant;
begin
  if BandType = rmbtGroupHeader then
  begin
    b := Self;
    while b <> nil do
    begin
      b.FLastGroupValue := FParentReport.Parser.CalcOPZ(b.GroupCondition);
      b := b.FNextGroup;
    end;

    // 初始化CalcMemo
    with FParentPage.FAggrList do
    begin
      for i := 0 to Count - 1 do
      begin
        t := Items[i];
        if t.FResetGroupBand = Self then
          t.Reset;
      end;
    end;
  end;

  if (BandType <> rmbtGroupHeader) and (FAggrBand <> nil) then // Old Aggregate
  begin
    for i := 0 to FAggrBand.FAggrValues.Count - 1 do
    begin
      lStr := FAggrBand.FAggrValues.Name[i];
      if (lStr <> '') and (lStr[1] in ['0'..'9']) then
      begin
        lStr1 := RMExtractField(lStr, 3);
        lStr := RMExtractField(lStr, 2)
      end
      else
      begin
        lStr1 := RMExtractField(lStr, 2);
        lStr := RMExtractField(lStr, 1);
      end;

      if Ord(lStr1[1]) <> atMin then // 最小值
        lValue := 0
      else
        lValue := 1E300;
      if AnsiCompareText(lStr, Name) = 0 then
        FAggrBand.FAggrValues.Value[i] := lValue;
    end;

    FAggrBand.FAggrCount := 0;
  end;
end;

function TRMBand.PrintSubReports: Boolean;
var
  i: Integer;
  lPage: TRMReportPage;
  lMaxPageNo, lSavePageNo: Integer;
  lMaxY, lHeight: Integer;
  t: TRMSubReportView;
begin
  Result := False;
  if FSubReports.Count = 0 then Exit;

  Result := True;
  lMaxY := 0;
  lMaxPageNo := FParentReport.MasterReport.FPageNo;
  lSavePageNo := lMaxPageNo;
  for i := 0 to FSubReports.Count - 1 do
  begin
    FParentReport.MasterReport.FPageNo := lSavePageNo;
    t := TRMSubReportView(FSubReports[i]);
    lPage := t.Page;
    lPage.FmmMarginLeft := TRMReportPage(FParentPage).FmmMarginLeft;
    lPage.FmmMarginTop := TRMReportPage(FParentPage).FmmMarginTop;
    lPage.FmmMarginRight := TRMReportPage(FParentPage).FmmMarginRight;
    lPage.FmmMarginBottom := TRMReportPage(FParentPage).FmmMarginBottom;
    lPage.PrinterInfo := TRMReportPage(FParentPage).PrinterInfo;
    lPage.FPageOrientation := TRMReportPage(FParentPage).FPageOrientation;
    lPage.FPageSize := TRMReportPage(FParentPage).FPageSize;
    lPage.FPageWidth := TRMReportPage(FParentPage).FPageWidth;
    lPage.FPageHeight := TRMReportPage(FParentPage).FPageHeight;
    lPage.FPageBin := TRMReportPage(FParentPage).FPageBin;

    lPage.FmmCurrentX := FParentPage.FmmCurrentX + t.FmmLeft;
    lPage.FmmCurrentY := FParentPage.FmmCurrentY + t.FmmTop;
    lPage.FmmCurrentX1 := lPage.FmmCurrentX;

    FParentReport.FCurrentPage := lPage;

    FParentReport.MasterReport.EndPages.AddbkPicture(0, 0, 0, 0, nil);
    lPage.FCurrentEndPages := FParentReport.MasterReport.EndPages;
    lPage.FPrintChildTypeSubReportPage := False;
    lPage.PrintPage;

    if FParentReport.MasterReport.FPageNo > lMaxPageNo then
      lMaxY := lPage.FmmCurrentY - lPage.FmmMarginTop + TRMReportPage(FParentPage).FmmMarginTop
        + (FmmHeight - t.FmmTop - t.FmmHeight)
    else if FParentReport.MasterReport.FPageNo = lMaxPageNo then
    begin
      if Stretched then
        lHeight := Max(FCalculatedHeight, FmmHeight)
      else
        lHeight := FmmHeight;

      if lMaxY < lPage.FmmCurrentY then
        lMaxy := lPage.FmmCurrentY - FParentPage.FmmCurrentY;
      if lMaxy < lHeight then
        lMaxy := lHeight;
    end;
    if lMaxPageNo < FParentReport.MasterReport.FPageNo then
      lMaxPageNo := FParentReport.MasterReport.FPageNo;
  end;

  if lMaxPageNo <> lSavePageNo then
  begin
    FNeedChangeHeight := False;
    FParentReport.MasterReport.FPageNo := lMaxPageNo;
    FParentPage.FmmCurrentY := lMaxY;
  end
  else if lMaxY > 0 then
  begin
    FNeedChangeHeight := False;
    Inc(FParentPage.FmmCurrentY, lMaxY);
  end;
end;

procedure TRMBand.PrintCrossCell(aParentBand: TRMBand; aCurrentX: Integer);
var
  i: Integer;
  liSaveLeft, liSaveTop: Integer;
  t: TRMReportView;
begin
  FParentReport.FCurrentPage := FParentPage;
  FParentReport.FCurrentBand := Self;
  FPositions[rmpsGlobal] := aParentBand.FPositions[rmpsGlobal];
  FPositions[rmpsLocal] := aParentBand.FPositions[rmpsLocal];
  if BandType = rmbtCrossData then
    FAggrBand := aParentBand;

  try
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if aParentBand.Objects.IndexOf(t) >= 0 then
      begin
        if FParentReport.FinalPass then
        begin
          liSaveLeft := t.FmmLeft;
          liSaveTop := t.FmmTop;
          Inc(t.FmmLeft, aCurrentX + FParentPage.FmmOffsetX);
          Inc(t.FmmTop, aParentBand.FmmTop + FParentPage.FmmOffsetY);

          //t.PlaceOnEndPage(FParentReport.MasterReport.EndPages[FParentReport.MasterReport.FPageNo].EndPageStream);
          t.PlaceOnEndPage(FParentPage.FCurrentEndPages[FParentReport.MasterReport.FPageNo].EndPageStream);

          t.FmmLeft := liSaveLeft;
          t.FmmTop := liSaveTop;
          if (t is TRMCustomMemoView) and (TRMCustomMemoView(t).DrawMode in [rmdmAll, rmdmAfterCalcHeight]) then
            FParentPage.AfterPrint;
        end
        else
        begin
          FParentReport.FCurrentView := t;
          if not (t is TRMCustomMemoView) or (TRMCustomMemoView(t).DrawMode = rmdmAll) then
          begin
            if Assigned(t.FOnBeforePrint) then
              t.FOnBeforePrint(t);
          end;
        end;
      end;
    end;
  except
    on E: exception do
      FParentReport.DoError(E);
  end;
end;

type
  THackRMDataset = class(TRMDataset);

procedure TRMBand.PrintCross;
var
  lBand, lDataBand: TRMBand;
  lSavePageNo: Integer;
  lCurX: Integer;
  lDataSet: TRMDataSet;
  lNeedFreeDataSet: Boolean;
  lFirstTime: Boolean;

  procedure _ResetRepeatedValues(aBand: TRMBand);
  var
    i: Integer;
    t: TRMView;
  begin
    if aBand = nil then Exit;
    for i := 0 to aBand.Objects.Count - 1 do
    begin
      t := aBand.Objects[i];
      if (t is TRMCustomMemoView) and TRMCustomMemoView(t).RepeatedOptions.MergeRepeated and TRMCustomMemoView(t).RepeatedOptions.SuppressRepeated then
      begin
        TRMCustomMemoView(t).FLastValue := '';
      end;
    end;
  end;

  function _CheckColumnPageBreak(aColWidth: Integer; aNewPage: Boolean): Boolean;
  var
    lSaveY: Integer;
    lBand: TRMBand;
  begin
    Result := False;
    if lCurX + aColWidth > TRMReportPage(FParentPage).GetCurrentRightX then
    begin
      Result := True;
      if not aNewPage then Exit;

      lDataBand.FCurrentColumn := 1;
      TRMReportPage(ParentPage).FFlag_ColumnNewPage := True;
      Inc(FmmColumnXAdjust, lCurX);
      lCurX := 0;
      Inc(FParentReport.MasterReport.FPageNo);
      //      if FParentReport.MasterReport.FPageNo >= FParentReport.MasterReport.EndPages.Count then
      if FParentReport.MasterReport.FPageNo >= FParentPage.FCurrentEndPages.Count then
      begin
        //        FParentReport.MasterReport.EndPages.Add(TRMReportPage(FParentPage));
        FParentPage.FCurrentEndPages.Add(TRMReportPage(FParentPage));
        _ResetRepeatedValues(TRMReportPage(FParentPage).BandByType(rmbtMasterData));
        _ResetRepeatedValues(TRMReportPage(FParentPage).BandByType(rmbtDetailData));

        lSaveY := TRMReportPage(FParentPage).FmmCurrentY;
        TRMReportPage(FParentPage).ShowBand(TRMReportPage(FParentPage).BandByType(rmbtOverlay));
        TRMReportPage(FParentPage).FmmCurrentY := 0;
        lBand := TRMReportPage(FParentPage).BandByType(rmbtPageHeader);
        if (lBand <> nil) and ((lSavePageNo <> 0) or lBand.PrintOnFirstPage) then
          TRMReportPage(FParentPage).ShowBand(lBand);
        TRMReportPage(FParentPage).FmmCurrentY := lSaveY;
        FParentReport.InternalOnProgress(FParentReport.MasterReport.FPageNo);
      end;

      lBand := TRMReportPage(FParentPage).BandByType(rmbtCrossHeader);
      if (lBand <> nil) and lBand.ReprintOnNewPage then
      begin
        lBand.PrintCrossCell(Self, 0);
        lCurX := lBand.FmmWidth;
      end;
    end;
  end;

  procedure _CrossDrawBlank;
  var
    lBandFooter: TRMBand;
    lColWidth: Integer;
  begin
    FParentReport.FFlag_TableEmpty := True;
    FParentReport.FFlag_TableEmpty1 := True;
    try
      lColWidth := lDataBand.FmmWidth;
      lBandFooter := TRMReportPage(FParentPage).BandByType(rmbtCrossFooter);
      if lBandFooter <> nil then
        Inc(lColWidth, lBandFooter.FmmWidth);

      while not _CheckColumnPageBreak(lColWidth, False) do
      begin
        lDataBand.PrintCrossCell(Self, lCurX);
        Inc(lCurX, lDataBand.FmmWidth);
        Inc(FParentPage.FColumnPos);
      end;
    finally
      FParentReport.FFlag_TableEmpty := False;
      FParentReport.FFlag_TableEmpty1 := False;
    end;
  end;

begin
  TRMReportPage(ParentPage).FFlag_ColumnNewPage := False;
  FmmColumnXAdjust := 0;
  FParentPage.FColumnPos := 1;
  lCurX := 0;
  lSavePageNo := FParentReport.MasterReport.FPageNo;
  if BandType = rmbtPageFooter then Exit;

  FParentReport.InternalOnBeginColumn(Self);

  // 处理标头栏
  lBand := TRMReportPage(FParentPage).BandByType(rmbtCrossHeader);
  if lBand <> nil then
  begin
    if Assigned(lBand.FOnBeforePrint) then
      lBand.FOnBeforePrint(lBand);

    if lBand.PrintAtDesignPos then lCurX := lBand.FmmLeft else lCurX := 0;

    lBand.PrintCrossCell(Self, lCurX);
    lCurX := lCurX + lBand.FmmWidth;
  end;

  // 处理数据栏
  lDataBand := TRMReportPage(FParentPage).BandByType(rmbtCrossData);
  if lDataBand <> nil then
  begin
    lDataBand.FCurrentColumn := 1;
    if lCurX = 0 then
    begin
      if lDataBand.PrintAtDesignPos then
        lCurX := lDataBand.FmmLeft
      else
        lCurX := 0;
    end;

    if lDataBand.DataSet <> nil then
      lDataSet := lDataBand.DataSet
    else
      lDataSet := FVirtualCrossDataSet;

    if lDataSet <> nil then
    begin
      lDataSet.First;
      lNeedFreeDataSet := False;
      if (BandType = rmbtFooter) and lDataSet.Eof then
      begin
        RMCreateDataSet(FParentReport, IntToStr(lDataBand.FMaxColumns), True, lDataSet);
        lNeedFreeDataSet := True;
        lDataSet.First;
      end;

      lFirstTime := True;
      while (not FParentReport.MasterReport.Terminated) and (not lDataSet.Eof) do
      begin
        Application.ProcessMessages;
        FParentReport.FCurrentView := lDataBand;
        FParentReport.InternalOnPrintColumn(FParentPage.FColumnPos, lDataBand.FmmWidth);
        if Assigned(lDataBand.FOnBeforePrint) then
          lDataBand.FOnBeforePrint(lDataBand);

        _CheckColumnPageBreak(lDataBand.FmmWidth, True);
        lDataBand.PrintCrossCell(Self, lCurX);

        if BandType in [rmbtMasterData, rmbtDetailData] then
          DoAggregate;

        if lFirstTime and Assigned(THackRMDataSet(lDataSet).FOnAfterFirst) then
          THackRMDataSet(lDataSet).FOnAfterFirst(lDataSet);

        lFirstTime := False;
        Inc(lCurX, lDataBand.FmmWidth);
        Inc(FParentPage.FColumnPos);
        lDataSet.Next;
        TRMReportPage(ParentPage).FFlag_ColumnNewPage := False;
      end;

      if (not lFirstTime) and lDataBand.AutoAppendBlank then
        _CrossDrawBlank;

      if lDataBand.FMaxColumns < lDataSet.RecordNo then
        lDataBand.FMaxColumns := lDataSet.RecordNo;

      if lNeedFreeDataSet then
        FreeAndNil(lDataSet);
    end;
  end;

  // 处理注脚栏
  lBand := TRMReportPage(FParentPage).BandByType(rmbtCrossFooter);
  if lBand <> nil then
  begin
    if lCurX = 0 then
      lCurX := lBand.FmmLeft;
    if Assigned(lBand.FOnBeforePrint) then
      lBand.FOnBeforePrint(lBand);

    _CheckColumnPageBreak(lBand.FmmWidth, True);
    lBand.PrintCrossCell(Self, lCurX);
    lBand.InitValues;
  end;

  FParentReport.MasterReport.FPageNo := lSavePageNo;
  FmmColumnXAdjust := 0;
end;

function TRMBand.HasCross: Boolean;
var
  i: Integer;
  t: TRMView;
begin
  Result := False;
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    if t.ParentBand <> Self then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TRMBand.DrawRepeatHeader(aNewColumn: Boolean);
var
  lBand: TRMBand;

  procedure _DrawOneBand(const aBand: TRMBand);
  var
    liSaveY: Integer;
  begin
    if aBand = nil then Exit;
    if aBand.ReprintOnNewColumn and (aBand.FCurrentColumn < Columns) and
      ((aBand.FLastPageNo = FParentReport.MasterReport.FPageNo) or
      (aBand.BandType in [rmbtPageHeader, rmbtColumnHeader]) or aBand.ReprintOnNewPage) then
    begin
      liSaveY := FParentPage.FmmCurrentY;
      FParentPage.FmmCurrentY := aBand.FSaveTop;
      FParentPage.FDrawRepeatHeader := True;
      try
        TRMReportPage(FParentPage).ShowBand(aBand);
      finally
        FParentPage.FDrawRepeatHeader := False;
        FParentPage.FmmCurrentY := liSaveY;
        Inc(aBand.FCurrentColumn);
      end;
    end;
  end;

begin
  _DrawOneBand(TRMReportPage(FParentPage).BandByType(rmbtPageHeader));
  _DrawOneBand(TRMReportPage(FParentPage).BandByType(rmbtColumnHeader));
  _DrawOneBand(FHeaderBand);
  lBand := FFirstGroup;
  while lBand <> nil do
  begin
    _DrawOneBand(lBand);
    lBand := lBand.FNextGroup;
  end;
end;

procedure TRMBand.PrintObject(t: TRMReportView);
var
  lSaveLeft, lSaveTop, lHeight: Integer;
  lIsPrinted: Boolean;
begin
  FParentReport.FCurrentPage := FParentPage;
  FParentReport.FCurrentBand := Self;
  if t.ParentBand <> Self then Exit;
  try
    if t.Visible then
    begin
      lHeight := t.FmmTop + t.FmmHeight;
      if not Stretched then
        lHeight := lHeight + (FmmHeight - t.FmmOldTop - t.FmmOldHeight);
      FMaxY := Max(FMaxY, lHeight);
    end;

    lIsPrinted := False;
    if FParentReport.FinalPass or FPageBreakFlag or FParentReport.HaveHookObject then
    begin
      lIsPrinted := True;
      lSaveLeft := t.FmmLeft;
      lSaveTop := t.FmmTop;
      Inc(t.FmmLeft, FParentPage.FmmCurrentX + FParentPage.FmmOffsetX);
      Inc(t.FmmTop, FmmTop + FParentPage.FmmOffsetY);

      //t.PlaceOnEndPage(TRMReportPage(FParentPage).CurrentEndPageStream);
      t.PlaceOnEndPage(FParentPage.FCurrentEndPages[FParentReport.MasterReport.FPageNo].EndPageStream);

      FParentReport.InternalOnAfterPrint(t);
      t.FmmLeft := lSaveLeft;
      t.FmmTop := lSaveTop;
      if (t is TRMCustomMemoView) and (TRMCustomMemoView(t).DrawMode in [rmdmAll, rmdmAfterCalcHeight]) then
        FParentPage.AfterPrint;
    end
    else
    begin
      FParentReport.FCurrentView := t;
      if not (t is TRMCustomMemoView) or (TRMCustomMemoView(t).DrawMode = rmdmAll) then
      begin
        if Assigned(t.FOnBeforePrint) then
          t.FOnBeforePrint(t);
      end;
    end;

    if not lIsPrinted then
    begin
      if t is TRMCalcMemoView then
      begin
        if TRMCalcMemoView(t).CalcOptions.ResetAfterPrint then
          TRMCalcMemoView(t).Reset;
        //        if not (BandType in [rmbtReportTitle, rmbtPageHeader, rmbtGroupHeader, rmbtHeader,
        //          rmbtColumnHeader, rmbtMasterData, rmbtDetailData]) then
        TRMCalcMemoView(t).AfterPrint(False);
      end;
    end;
  except
    on E: exception do
      FParentReport.DoError(E);
  end;
end;

function TRMBand.PrintObjects(aDrawPageBreaked: Boolean): Boolean;
var
  i: Integer;
  t: TRMReportView;
  lSaveTop, lSaveHeight: INteger;

  procedure _SetShiftTopHeight;
  begin
    if Stretched then
    begin
      if (t.FShiftWithView <> nil) and t.FShiftWithView.FNeedPrint then
        t.FmmTop := t.FmmOldTop - t.FShiftWithView.FmmOldTop - t.FShiftWithView.FmmOldHeight +
          t.FShiftWithView.FmmTop + t.FShiftWithView.FmmHeight
      else if t.FStretchWithView <> nil then
      begin
        if not FFirstPage then
        begin
          t.FmmTop := t.FStretchWithView.FmmTop;
          t.FmmHeight := t.FStretchWithView.FmmHeight;
        end
        else if t.FStretchWithView.FShiftWithView <> nil then
        begin
          t.FmmTop := t.FStretchWithView.FmmTop + (t.FmmOldTop - t.FStretchWithView.FmmOldTop);
          t.FmmHeight := t.FStretchWithView.FmmHeight - (t.FmmOldTop - t.FStretchWithView.FmmOldTop);
        end
        else
        begin
          t.FmmTop := t.FStretchWithView.FmmTop + (t.FmmOldTop - t.FStretchWithView.FmmOldTop);
          t.FmmHeight := t.FStretchWithView.FmmHeight - (t.FmmOldTop - t.FStretchWithView.FmmOldTop);
        end;
      end;
    end;
  end;

begin
  Result := False;
  i := 0;
  FMaxY := 0;
  while (i < FObjects.Count) and (not FParentReport.MasterReport.Terminated) do
  begin
    t := FObjects[i];
    if (not aDrawPageBreaked) or t.FNeedPrint then
    begin
      if t.Typ <> rmgtSubReport then
      begin
        lSaveTop := t.FmmTop;
        lSaveHeight := t.FmmHeight;
        _SetShiftTopHeight;
        PrintObject(t);
        t.FmmTop := lSaveTop;
        t.FmmHeight := lSaveHeight;
      end;
    end;
    Inc(i);
  end;
  
  Result := Result or PrintSubReports;
end;

procedure TRMBand.StretchObjects;
var
  i: Integer;
  t: TRMReportView;
begin
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    if t is TRMStretcheableView then //伸展
    begin
      if t.Stretched and (t.FmmHeight > 0) then
      begin
        if TRMStretcheableView(t).FUseBandHeight then
          t.FmmHeight := FCalculatedHeight - t.FmmTop
        else
          t.FmmHeight := TRMStretcheableView(t).CalculatedHeight;
      end;
    end;
  end;
end;

procedure TRMBand.UnStretchObjects;
var
  i: Integer;
  t: TRMReportView;
begin
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    t.FmmTop := t.FmmOldTop;
    t.FmmHeight := t.FmmOldHeight;
  end;
end;

function TRMBand.CalcBandHeight: Integer;

  function _CalcHeight(aCheckAll: Boolean): Integer;
  var
    i, h: Integer;
    t: TRMReportView;
    t1: TRMStretcheableView;
  begin
    FParentReport.FCurrentBand := Self;
    Result := FmmHeight;
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      t.FmmOldTop := t.FmmTop;
      t.FmmOldHeight := t.FmmHeight;
      if (t is TRMStretcheableView) and (aCheckAll or (t.ParentBand = Self)) then
      begin
        if t.Stretched then
        begin
          TRMStretcheableView(t).FUseBandHeight := True;
          h := TRMStretcheableView(t).CalcHeight + t.FmmTop;
          Result := Max(Result, h);
          if aCheckAll then
            TRMStretcheableView(t).DrawMode := rmdmAll;
        end
        else
        begin
          TRMStretcheableView(t).CalcHeight;
          if aCheckAll then
            TRMStretcheableView(t).DrawMode := rmdmAll;
        end;
      end
    end;

    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.FShiftWithView <> nil then
      begin
        t1 := TRMStretcheableView(TRMStretcheableView(t).FShiftWithView);
        if t1.Stretched then
        begin
          TRMStretcheableView(t).FUseBandHeight := False;
          TRMStretcheableView(t1).FUseBandHeight := False;
          t.FmmTop := t1.FmmTop + t1.CalculatedHeight + (t.FmmOldTop - t1.FmmOldTop - t1.FmmOldHeight);
          if t.Stretched and (t is TRMStretcheableView) then
            h := t.FmmTOp + TRMStretcheableView(t).CalculatedHeight
          else
            h := t.FmmTOp + t.FmmHeight;

          Result := Max(Result, h);
        end;
      end;
    end;
  end;

  function _CalcOneBandHeight: Integer;
  var
    liBand: TRMBand;
    lDataSet: TRMDataSet;
    liColumnWidth, liHeight: Integer;
  begin
    if HasCross and (BandType <> rmbtPageFooter) then
    begin
      Result := FmmHeight;
      FParentPage.FColumnPos := 1;
      FParentReport.InternalOnBeginColumn(Self);
      liBand := TRMReportPage(FParentPage).BandByType(rmbtCrossData);
      if liBand <> nil then
      begin
        if liBand.DataSet <> nil then
          lDataSet := liBand.DataSet
        else
          lDataSet := FVirtualCrossDataSet;

        lDataSet.First;
        while not lDataSet.Eof do
        begin
          liColumnWidth := 0;
          FParentReport.InternalOnPrintColumn(FParentPage.FColumnPos, liColumnWidth);
          liHeight := _CalcHeight(True);
          Result := Max(Result, liHeight);
          Inc(FParentPage.FColumnPos);
          lDataSet.Next;
          if FParentReport.MasterReport.Terminated then
            Break;
        end;
      end;
    end
    else
      Result := _CalcHeight(False);
  end;

begin
  if Stretched then
    FCalculatedHeight := _CalcOneBandHeight
  else
    FCalculatedHeight := FmmHeight;

  Result := FCalculatedHeight;
end;

procedure TRMBand.MakeSpace;
begin
  FNowLine := 0;
  TRMReportPage(FParentPage).FInDrawPageHeader := BandType in [rmbtPageHeader, rmbtColumnHeader];
  try
    TRMReportPage(FParentPage).NewColumn(Self);
  finally
    TRMReportPage(FParentPage).FInDrawPageHeader := False;
  end;
end;

procedure TRMBand.MakeOutlineText;
var
  lLevel: Integer;
  lValue: Variant;
  lNodeCaption: string;
  t: TRMOutlineView;
begin
  if FOutlineText = '' then Exit;

  lLevel := TRMReportPage(FParentPage).FNowOutlineLevel;
  if BandType = rmbtGroupHeader then
    Inc(lLevel, FLevel);

  lValue := FParentReport.Parser.CalcOPZ(FOutlineText);
  if lValue = Null then
    lNodeCaption := '[None]'
  else
    lNodeCaption := string(lValue);

  if FParentPage.FPrintChildTypeSubReportPage or
    (TRMReportPage(FParentPage).FKeepPage_Count > 0) then
  begin
    t := TRMOutlineView.Create;
    try
      t.FCaption := lNodeCaption;
      t.FPageNo := FParentReport.MasterReport.FPageNo;
      t.spTop := spTop;
      t.FLevel := lLevel;

      t.PlaceOnEndPage(FParentPage.FCurrentEndPages[FParentReport.MasterReport.FPageNo].EndPageStream);
      if TRMReportPage(FParentPage).FKeepPage_Count > 0 then
      begin
        TRMReportPage(FParentPage).FKeepPage_OutLines.Add(t.OutlineText);
      end;
    finally
      t.Free;
    end;
  end
  else
  begin
    FParentPage.FCurrentEndPages.OutLines.Add(lNodeCaption + #1 + // 标题
      IntToStr(FParentReport.MasterReport.FPageNo) + #1 + // 所在页
      IntToStr(spTop) + #1 + // 所在行
      IntToStr(lLevel)); // 所在级
  end;
end;

procedure TRMBand.PrintPageBreak(aNeedNewPage: Boolean);
var
  i: Integer;
  lPageRemainHeight: Integer;
  t: TRMReportView;

  function _GetPageRemainHeight: Integer;
  var
    lColumnFooterBand: TRMBand;
    lColumnFooterHeight: Integer;
  begin
    lColumnFooterBand := TRMReportPage(FParentPage).BandByType(rmbtColumnFooter);
    if lColumnFooterBand <> nil then
      lColumnFooterHeight := lColumnFooterBand.FmmHeight
    else
      lColumnFooterHeight := 0;

    Result := FParentPage.FmmCurrentBottomY - lColumnFooterHeight - FmmTop;
  end;

  function _CheckFinish: Boolean; // 是否全部打印完成
  var
    i: Integer;
  begin
    Result := True;
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
      begin
        Result := False;
        Break;
      end;
    end;
  end;

  // t.Selected = False: 打印结束
  // t.NeedPrint = True; 本页打印的
  procedure _SetNewHeight; // 换页后，重新设置Objeect的Top,Height
  var
    i: Integer;
    lRemainHeight, lIncHeight: Integer;

    procedure _GetObjectsMaxHeight;
    var
      i, lHeight: Integer;
    begin
      lRemainHeight := 0;
      lIncHeight := 0;
      for i := 0 to Objects.Count - 1 do
      begin
        t := Objects[i];
        if t.FNeedPrint then
        begin
          if t is TRMStretcheableView then
          begin
            lHeight := TRMStretcheableView(t).RemainHeight;
            lRemainHeight := Max(lRemainHeight, lHeight);
            lIncHeight := Max(lIncHeight, lHeight - t.OriginalRect.Right);
            if t.Stretched then
            begin
              if t.FShiftWithView <> nil then
                TRMStretcheableView(t.FShiftWithView).FUseBandHeight := True;
            end;
          end;
        end;
      end;
    end;

  begin
    _GetObjectsMaxHeight;
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
      begin
        if t.FNeedPrint then // 上次打印的，调整Height
        begin
          if t is TRMStretcheableView then
          begin
            t.FmmTop := 0;
            if TRMStretcheableView(t).FUseBandHeight then
              t.FmmHeight := lRemainHeight - t.FmmTop
            else
              t.FmmHeight := TRMStretcheableView(t).ActualHeight;
            if t.FmmHeight > 0 then t.Selected := True;
          end
          else
          begin
            t.FmmHeight := t.OriginalRect.Right;
            t.FmmTop := t.OriginalRect.Left;
            if t is TRMStretcheableView then
              t.FmmHeight := t.FmmHeight + t._CalcVFrameWidth(t.TopFrame.FmmWidth, t.BottomFrame.FmmWidth) + FmmGapTop * 2;
          end;
        end
        else //  在页的下面，还不该打印
        begin
          t.FmmTop := t.OriginalRect.Left + lIncHeight;
          t.FNeedPrint := True;
        end;
      end
      else
      begin
        t.FNeedPrint := False;
        if t.ReprintOnOverFlow then
          t.Selected := True;
      end;
    end;

    for i := 0 to FObjects.Count - 1 do
    begin
      t := Objects[i];
      if t.FShiftWithView <> nil then
      begin
        if t.FShiftWithView.FNeedPrint then
          t.FmmTop := t.FmmOldTop - t.FShiftWithView.FmmOldTop - t.FShiftWithView.FmmOldHeight +
            t.FShiftWithView.FmmTop + t.FShiftWithView.FmmHeight;
      end;
    end;
  end;

begin
  if aNeedNewPage then // 第一次，需要先换页
  begin
    if Stretched then
      lPageRemainHeight := Max(FCalculatedHeight, FmmHeight)
    else
      lPageRemainHeight := FmmHeight;

    MakeSpace;
    FmmTop := FParentPage.FmmCurrentY;
    if not CheckSpace(FmmTop, lPageRemainHeight, False) then // 空间够，打印退出
    begin
      MakeOutlineText;
      PrintObjects(False);
      if HasCross then PrintCross;
      if FNeedChangeHeight then
        Inc(FParentPage.FmmCurrentY, lPageRemainHeight);

      Exit;
    end
  end;

  MakeOutlineText;
  FPageBreakFlag := True;
  //  if Assigned(FOnBeforePrint) then
  //    FOnBeforePrint(Self);

  for i := 0 to FObjects.Count - 1 do
  begin
    t := FObjects[i];
    if Stretched then
    begin
      if (t is TRMStretcheableView) and (not t.Stretched) then //伸展
      begin
        TRMStretcheableView(t).DrawMode := rmdmAll;
        TRMStretcheableView(t).GetMemoVariables;
      end;
    end
    else
    begin
      FNeedUnStretchObjects := True;
      t.FmmOldTop := t.FmmTop;
      t.FmmOldHeight := t.FmmHeight;
      if t is TRMStretcheableView then //伸展
      begin
        TRMStretcheableView(t).DrawMode := rmdmAll;
        TRMStretcheableView(t).GetMemoVariables;
      end;
    end;

    t.Selected := True;
    t.FNeedPrint := True;
    t.OriginalRect := Rect(t.FmmTop, t.FmmTop, t.FmmHeight, t.FmmHeight);
  end;

  while not FParentReport.MasterReport.Terminated do
  begin
    lPageRemainHeight := _GetPageRemainHeight;
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.FmmTop > lPageRemainHeight then // 在页面的下面，此页不需打印
      begin
        t.FNeedPrint := False;
        t.OriginalRect.Left := t.FmmTop - lPageRemainHeight;
      end
      else if t.FmmTop + t.FmmHeight > lPageRemainHeight then // 在本页，但不能完整显示
      begin
        t.FmmHeight := lPageRemainHeight - t.FmmTop;
        t.OriginalRect.Right := t.OriginalRect.Right - t.FmmHeight;
        t.OriginalRect.Left := 0;
        if not (t is TRMStretcheableView) then
          t.Selected := False;
      end
      else // 在本页能够完整显示，打印结束
        t.Selected := False;

      if t is TRMStretcheableView then
        TRMStretcheableView(t).DrawMode := rmdmPart;
    end;

    PrintObjects(True);
    if _CheckFinish then
      Break
    else
    begin
      FFirstPage := False;
      MakeSpace;
      FmmTop := FParentPage.FmmCurrentY;
      _SetNewHeight;
    end;
  end; {while}

  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    t.FmmTop := t.OriginalRect.Top;
    t.FmmHeight := t.OriginalRect.Bottom;
    if t is TRMStretcheableView then
      TRMStretcheableView(t).DrawMode := rmdmAll;
  end;

  FPageBreakFlag := False;
  Inc(FParentPage.FmmCurrentY, FMaxY);
end;

function TRMBand.CheckSpace(aTop, aHeight: Integer; aAddColumn: Boolean): Boolean;
var
  lColumnFooterBand, lBand: TRMBand;
  lColumnFooterHeight: Integer;
  lFlag: Boolean;
  lmmCurrentBottomY: Integer;
begin
  Result := False;
  if FBandType in [rmbtColumnFooter, rmbtPageFooter, rmbtOverlay, rmbtNone] then Exit;

  lFlag := False;
  if LinesPerPage > 0 then
  begin
    if PrintColumnFirst then
      lFlag := (LinesPerPage > 0) and (FNowLine >= LinesPerPage * Columns)
    else
      lFlag := (LinesPerPage > 0) and (FNowLine >= LinesPerPage);
  end;

  lmmCurrentBottomY := FParentPage.FmmCurrentBottomY;
  if TRMReportPage(FParentPage).FDisableRepeatHeader then
  begin
    lBand := TRMReportPage(FParentPage).BandByType(rmbtPageFooter);
    if (lBand <> nil) and (not lBand.PrintOnLastPage) then
      Inc(lmmCurrentBottomY, lBand.FmmHeight);
  end;

  lColumnFooterBand := TRMReportPage(FParentPage).BandByType(rmbtColumnFooter);
  if (FBandType <> rmbtReportSummary) and (lColumnFooterBand <> nil) then
    lColumnFooterHeight := lColumnFooterBand.FmmHeight
  else
    lColumnFooterHeight := 0;

  if lFlag or (aTop + aHeight + lColumnFooterHeight > lmmCurrentBottomY) then
  begin
    if aAddColumn and (FColumns > 1) and (not PrintColumnFirst) then // 先行后列
    begin
      if FCurrentColumn < FColumns then
      begin
        Inc(FCurrentColumn);
        FParentPage.FmmCurrentX := FSaveXAdjust + (FCurrentColumn - 1) * (FmmColumnWidth + FmmColumnGap);
        DrawRepeatHeader(True);
        FParentPage.FmmCurrentY := {FParentPage.FmmLastStaticColumnY} FSaveLastY;
        FNowLine := 0;
        Exit;
      end
      else
      begin
        FParentPage.FmmCurrentX := FSaveXAdjust;
        FCurrentColumn := 1;
      end;
    end;

    Result := True;
  end;
end;

procedure TRMBand.MakeColumns;
begin
  if PrintColumnFirst then // 先列后行
  begin
    Inc(FCurrentColumn);
    if FCurrentColumn > FColumns then
    begin
      FParentPage.FmmCurrentX := FSaveXAdjust;
      FCurrentColumn := 1;
      FSaveLastY := FParentPage.FmmCurrentY;
    end
    else
    begin
      FParentPage.FmmCurrentX := FSaveXAdjust + (FCurrentColumn - 1) * (FmmColumnWidth + FmmColumnGap);
      DrawRepeatHeader(True);
      FParentPage.FmmCurrentY := FSaveLastY;
    end;
  end;
end;

function TRMBand.CalcChildBandHeight: Integer;
var
  lBandChild: TRMBand;
begin
  Result := 0;
  lBandChild := FBandChild;
  while lBandChild <> nil do
  begin
    Inc(Result, lBandChild.FmmHeight);
    lBandChild := lBandChild.FBandChild;
  end;
end;

procedure TRMBand.DoPrint;
var
  lUseTop: Boolean;
  lSaveTop: Integer;
  lBandHeight: Integer;
  lNewSpaceFlag: Boolean;

  function _CheckGroupHeader_KeepFooter(aDataBand, aGroupHeaderBand: TRMBand): Boolean;
  var
    lMaxHeight: Integer;
  begin
    Result := False;
    lMaxHeight := 0;
    if aDataBand <> nil then
      Inc(lMaxHeight, aDataBand.FmmHeight + aDataBand.CalcChildBandHeight);

    while aGroupHeaderBand <> nil do
    begin
      Inc(lMaxHeight, aGroupHeaderBand.FmmHeight + aGroupHeaderBand.CalcChildBandHeight);
      if aGroupHeaderBand.FFooterBand <> nil then
        Inc(lMaxHeight, aGroupHeaderBand.FFooterBand.FmmHeight + aGroupHeaderBand.FFooterBand.CalcChildBandHeight);

      aGroupHeaderBand := aGroupHeaderBand.FNextGroup;
    end;

    if CheckSpace(FmmTop, lMaxHeight, True) then
    begin
      MakeSpace;
      FmmTop := FParentPage.FmmCurrentY;
      Result := True;
    end;
  end;

  function _CheckKeepFooter: Boolean; // 查看有没有KeepFooter情况
  var
    lMaxHeight: Integer;
  begin
    Result := False;
    if (FBandChild <> nil) and FBandChild.Visible and KeepChild then // 保持与子栏在同一页
    begin
      if CheckSpace(FmmTop, lBandHeight + CalcChildBandHeight, True) then
      begin
        MakeSpace;
        FmmTop := FParentPage.FmmCurrentY;
        Result := True;
      end;
    end;

    if (not Result) and (BandType in [rmbtMasterData, rmbtDetailData]) and // KeepFooter
    (FFooterBand <> nil) and FFooterBand.Visible and KeepFooter then
    begin
      lMaxHeight := FmmHeight + CalcChildBandHeight +
        FFooterBand.FmmHeight + FFooterBand.CalcChildBandHeight;
      if CheckSpace(FmmTop, lMaxHeight, True) then
      begin
        MakeSpace;
        FmmTop := FParentPage.FmmCurrentY;
        Result := True;
      end;
    end;

    if (not Result) and (BandType in [rmbtMasterData, rmbtDetailData]) and
      (FNowGroupBand <> nil) and (FNowGroupBand.FFooterBand <> nil) and
      FNowGroupBand.FFooterBand.Visible and FNowGroupBand.KeepFooter then
      Result := _CheckGroupHeader_KeepFooter(Self, FNowGroupBand);

    if (not Result) and (BandType in [rmbtGroupHeader]) and // KeepFooter
    {(FFooterBand <> nil) and FFooterBand.Visible and}KeepFooter then // 保证分组标头栏不单独显示
      Result := _CheckGroupHeader_KeepFooter(FDataBand, Self);
  end;

begin
  FFirstPage := True;
  FNeedChangeHeight := True;
  FPageBreakFlag := False;
  if not FParentPage.FDrawRepeatHeader then
  begin
    // 如果上次打印的band是多栏的话,需要调整位置
    if (Self <> FParentPage.FLastPrintBand) and (FParentPage.FLastPrintBand <> nil)
      and (FParentPage.FLastPrintBand.Columns > 1) and (not FParentPage.FLastPrintBand.PrintColumnFirst) then
    begin
      FParentPage.FmmCurrentY := FParentPage.FLastPrintBand.FSaveMaxY;
    end;

    if FParentPage.FLastPrintBand = nil then
      FSaveTop := FParentPage.FmmCurrentY
    else if FParentPage.FLastPrintBand <> Self then
    begin
      FSaveTop := FParentPage.FmmCurrentY;
    end;
  end;

  if Self <> FParentPage.FLastPrintBand then
  begin
    FCurrentColumn := 1;
    FSaveXAdjust := FParentPage.FmmCurrentX;
    FSaveLastY := FParentPage.FmmCurrentY;
  end;

  if (FColumns > 1) and (Self = FParentPage.FLastPrintBand) then
    MakeColumns;

  lSaveTop := FmmTop;
  lUseTop := not (FBandType in [rmbtPageFooter, rmbtOverlay, rmbtNone]);
//  if lUseTop and PrintAtDesignPos and FFirstTime then
//    FParentPage.FmmCurrentY := FmmTop;

  if lUseTop then
    FmmTop := FParentPage.FmmCurrentY;

  if Stretched then
  begin
    lBandHeight := Max(FCalculatedHeight, FmmHeight)
  end
  else
    lBandHeight := FmmHeight;

  lNewSpaceFlag := _CheckKeepFooter;
  if CheckSpace(FmmTop, lBandHeight, True) then
  begin
    if PageBreaked or (Stretched and (FLastPageNo = FParentReport.MasterReport.FPageNo) and
      (Self <> FParentPage.FLastPrintBand)) then
    begin
      if TRMReportPage(FParentPage).FDisableRepeatHeader then
        PrintPageBreak(True)
      else
        PrintPageBreak(False or lNewSpaceFlag);
    end
    else
      PrintPageBreak(True);
  end
  else
  begin
    //    if Assigned(FOnBeforePrint) then
    //      FOnBeforePrint(Self);
    if lUseTop then
      FmmTop := FParentPage.FmmCurrentY;

    MakeOutlineText;
    PrintObjects(False);
    if HasCross and (FColumns = 1) then
      PrintCross;

    if lUseTop and FNeedChangeHeight then
      Inc(FParentPage.FmmCurrentY, lBandHeight);
  end;

  if (FColumns > 1) and (not PrintColumnFirst) then // 先行后列的多栏打印
  begin
    if FCurrentColumn <= 1 then
      FSaveMaxY := FParentPage.FmmCurrentY
    else
      FSaveMaxY := Max(FSaveMaxY, FParentPage.FmmCurrentY);
  end;

  if not FParentPage.FDrawRepeatHeader then
    FParentPage.FLastPrintBand := Self;

  FmmTop := lSaveTop;
  FLastPageNo := FParentReport.MasterReport.FPageNo;
  if BandType in [rmbtMasterData, rmbtDetailData] then
  begin
    DoAggregate;
    Inc(FNowLine);
  end;
end;

function TRMBand.Print: Boolean;
var
  lSaveDisableBandScript: Boolean;

  procedure _ShowChildband(aShow: Boolean);
  var
    lSaveFlag: Boolean;
  begin
    if (not aShow) or (FBandChild = nil) then Exit;

    lSaveFlag := FParentPage.FDrawRepeatHeader;
    try
      FParentPage.FDrawRepeatHeader := True;
      TRMReportPage(FParentPage).ShowBand(FBandChild);
    finally
      FParentPage.FDrawRepeatHeader := lSaveFlag;
    end;
  end;

begin
  Result := False;
  FParentReport.FCurrentView := Self;
  FParentReport.FCurrentBand := Self;
  FNeedUnStretchObjects := False;

  //  FCallNewPage := 0;  FCallNewColumn := 0;
  if Assigned(FParentReport.FOnBeginBand) then
    FParentReport.FOnBeginBand(Self);

  if (not FParentPage.FDrawRepeatHeader) and (FParentPage.FLastPrintBand <> nil) and
    (FParentPage.FLastPrintBand <> Self) and (FParentPage.FLastPrintBand.FCurrentColumn > 1) then
  begin
    FParentPage.FmmCurrentX := FParentPage.FLastPrintBand.FSaveXAdjust;
    //    Inc(FParentPage.FmmCurrentY, FParentPage.FLastPrintBand.FmmHeight);
  end;

  lSaveDisableBandScript := FDisableBandScript;
  if (not FDisableBandScript) and Assigned(FOnBeforePrint) then
    FOnBeforePrint(Self);

  if FParentReport.Terminated then
  begin
    Exit;
  end;

  FDisableBandScript := False;
  if (FBandType = rmbtReportSummary) and AlignToBottom and FVisible then // 底对齐
  begin
    if FParentPage.FmmCurrentY + FmmHeight > FParentPage.FmmCurrentBottomY then
      TRMReportPage(FParentPage).NewPage;

    FParentPage.FmmCurrentY := FParentPage.FmmCurrentBottomY - FmmHeight;
  end;

  {
    for i := 1 to FCallNewPage do
    begin
      TRMReportPage(FParentPage).CurColumn := Parent.ColCount - 1;
      TRMReportPage(FParentPage).NewColumn(Self);
    end;
    for i := 1 to FCallNewColumn do
      TRMReportPage(FParentPage).NewColumn(Self);
  }

  FNeedDecKeepPageCount := False;
  if BandType = rmbtGroupFooter then
  begin
    if (FHeaderBand <> nil) and FHeaderBand.FNeedDecKeepPageCount then
    begin
      TRMReportPage(FParentPage).DeleteKeepPageBand(FHeaderBand);
    end;
  end
  else if BandType = rmbtGroupHeader then
  begin
    if KeepTogether and (not NewPageAfter) and (not FKeepPage_FirstTime) then
    begin
      TRMReportPage(FParentPage).AddKeepPageBand(Self);
      FNeedDecKeepPageCount := True;
    end;
  end;

  FKeepPage_FirstTime := False;
  if FVisible then // 显示
  begin
    //    if NewPageBefore and (not (FBandType in [rmbtMasterData, rmbtDetailData, rmbtGroupHeader])) then
    //      TRMReportPage(FParentPage).NewPage;

    FCalculatedHeight := FmmHeight;
    if FBandType = rmbtColumnHeader then
      FParentPage.FmmLastStaticColumnY := FParentPage.FmmCurrentY;
    if FBandType = rmbtPageFooter then
      FmmTop := FParentPage.FmmCurrentBottomY;

    if Stretched then
    begin
      FNeedUnStretchObjects := True;
      CalcBandHeight;
      StretchObjects;
      DoPrint;
    end
    else
      DoPrint;

    _ShowChildBand(True);
    if FNeedUnStretchObjects then
      UnStretchObjects;

    if NewPageAfter and FVisible and (not (FBandType in [rmbtMasterData, rmbtDetailData, rmbtGroupHeader])) then
      TRMReportPage(FParentPage).NewPage;
  end
  else // not visible
  begin
    _ShowChildBand(PrintChildIfInvisible);
    if BandType in [rmbtMasterData, rmbtDetailData] then
      DoAggregate;
  end;

  InitValues;
  if (not lSaveDisableBandScript) and Assigned(FOnAfterPrint) then
    FOnAfterPrint(Self);
  if Assigned(FParentReport.FOnEndBand) then
    FParentReport.FOnEndBand(Self);

  //if (FBandChild <> nil) and KeepChild then // 保持与子栏在同一页
  //begin
  //	TRMReportPage(FParentPage).DeleteKeepPageBand(FBandChild);
  //end;
end;

procedure TRMBand.AddAggregateValue(const aStr: string; aValue: Variant);
begin
  FAggrValues[aStr] := aValue;
end;

function TRMBand.GetAggregateValue(const aStr: string): Variant;
begin
  Result := FAggrValues[aStr];
  if RMExtractField(aStr, 2) = Chr(Ord(0)) then
  begin
    if FAggrCount <> 0 then
      Result := Result / FAggrCount
    else
      Result := 0;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCustomPage }

constructor TRMCustomPage.Create;
begin
  inherited Create;
  FParentReport := nil;
  FObjects := TList.Create;
  FFont := TFont.Create;
  FOutlineText := '';

  FVisible := True;
  FEventList := nil;
end;

destructor TRMCustomPage.Destroy;
begin
  Clear;
  FreeAndNil(FObjects);
  FreeAndNil(FFont);
  FreeAndNil(FEventList);
  inherited Destroy;
end;

function TRMCustomPage.EventList: TList;
begin
  if FEventList = nil then
    FEventList := TList.Create;

  Result := FEventList;
end;

function TRMCustomPage.DocMode: TRMDocMode;
begin
  if FParentReport <> nil then
    Result := FParentReport.DocMode
  else
    Result := rmdmDesigning;
end;

procedure TRMCustomPage.SetName(const Value: string);
var
  i: Integer;
begin
  if FName <> Value then
  begin
    if Value <> '' then
    begin
      if (FParentReport <> nil) and FParentReport.FDesigning then
      begin
        for i := 0 to FParentReport.Pages.Count - 1 do
        begin
          if RMCmp(FParentReport.Pages[i].Name, Value) then
          begin
            Exit;
          end;
        end;
      end;
    end;
    FName := Value;
  end;
end;

procedure TRMCustompage.CreateName;
var
  i, j: Integer;
  liFound: Boolean;
  s: string;
begin
  i := 1;
  liFound := True;
  while liFound do
  begin
    liFound := False;
    s := 'Page' + IntToStr(i);
    for j := 0 to FParentReport.Pages.Count - 1 do
    begin
      if RMCmp(FParentReport.Pages[j].Name, s) then
      begin
        liFound := True;
        Break;
      end;
    end;
    Inc(i);
  end;

  FName := s;
end;

procedure TRMCustomPage.Clear;
begin
  RMClearList(FEventList);
  while FObjects.Count > 0 do
    Delete(0);
end;

procedure TRMCustomPage.Delete(Index: Integer);
begin
  if Index >= 0 then
  begin
    BeforeDeleteObject(TRMView(FObjects[Index]));
    TRMView(FObjects[Index]).Free;
    FObjects.Delete(Index);
  end;
end;

procedure TRMCustomPage.BeforeDeleteObject(aObject: TRMView);
begin
end;

procedure TRMCustomPage.Loaded;
begin
end;

function TRMCustomPage.GetPrinter: TRMPrinter;
begin
  if FParentReport <> nil then
    Result := FParentReport.MasterReport.ReportPrinter
  else
    Result := nil;

  if Result = nil then
    Result := RMPrinter;
end;

function TRMCustomPage.IndexOf(aObjectName: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FObjects.Count - 1 do
  begin
    if RMCmp(TRMView(FObjects[i]).Name, aObjectName) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TRMCustomPage.FindObject(aObjectName: string): TRMView;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FObjects.Count - 1 do
  begin
    if RMCmp(TRMView(FObjects[i]).Name, aObjectName) then
    begin
      Result := FObjects[i];
      Break;
    end;
  end;
end;

function TRMCustomPage.PageObjects: TList;
begin
  Result := Objects;
end;

procedure TRMCustomPage.AfterPrint;
var
  i: Integer;
begin
  with FParentReport do
  begin
    for i := 0 to FHookList.Count - 1 do
      TRMView(FHookList[i]).OnHook(FCurrentView);
  end;
end;

function TRMCustomPage.Count: Integer;
begin
  Result := FObjects.Count;
end;

function TRMCustomPage.GetItems(Index: string): TRMView;
begin
  Result := FindObject(Index);
end;

procedure TRMCustomPage.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TRMCustomPage.SetObjectsEvent;
var
  i: Integer;
begin
  RMClearList(FEventList);
  for i := 0 to FObjects.Count - 1 do
    TRMView(FObjects[i]).SetObjectEvent(EventList, FParentReport.MasterReport.FScriptEngine);

  SetObjectEvent(EventList, FParentReport.MasterReport.FScriptEngine);
end;

procedure TRMCustomPage.BuildTmpObjects;
begin
  SetObjectsEvent;
end;

procedure TRMCustomPage.AddChildView(aStringList: TStringList; aDontAddBlankNameObject: Boolean);
var
  i: Integer;
begin
  for i := 0 to FObjects.Count - 1 do
    aStringList.Add(UpperCase(TRMView(FObjects[i]).Name));
  aStringList.Add(UpperCase(FName));
end;

procedure TRMCustomPage.SetOutlineText(Value: string);
begin
  FOutlineText := Trim(Value);
  //  if DocMode = rmdmPreviewing then
  //  begin
  //    FOutlineText := FParentReport.Parser.Str2OPZ(FOutlineText);
  //  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDialogPage }

constructor TRMDialogPage.CreatePage(aParentReport: TRMReport);
begin
  inherited Create;
  FParentReport := aParentReport;
  FLeft := 220;
  FTop := 180;
  FWidth := 380;
  FHeight := 300;
  FCaption := 'Form';
  FColor := clBtnFace;
  FPosition := poScreenCenter;
  FBorderStyle := bsDialog;
  FVisible := True;

  if RMIsChineseGB then
  begin
    Font.Name := '宋体';
    Font.Charset := GB2312_CHARSET;
    Font.Size := 9;
  end;
end;

destructor TRMDialogPage.Destroy;
begin
  inherited Destroy;
end;

function TRMDialogPage.GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant;
  Args: array of Variant): Boolean;
begin
  Result := True;
  if aPropName = 'FORM' then
    aValue := O2V(FForm)
  else if aPropName = 'MODALRESULT' then
    aValue := FForm.ModalResult
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

function TRMDialogPage.SetPropValue(aObject: TObject; aPropName: string;
  aValue: Variant): Boolean;
begin
  //  Result := True;
  Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

function TRMDialogPage.UpdateBandsPageRect: Boolean;
begin
  Result := False;
end;

procedure TRMDialogPage.LoadFromStream(aStream: TStream);
var
  lVersion: Integer;
begin
  lVersion := RMReadWord(aStream);
  FName := RMReadString(aStream);
  Visible := RMReadBoolean(aStream);

  Caption := RMReadString(aStream);
  Left := RMReadInt32(aStream);
  Top := RMReadInt32(aStream);
  Width := RMReadInt32(aStream);
  Height := RMReadInt32(aStream);
  Color := RMReadInt32(aStream);
  BorderStyle := TFormBorderStyle(RMReadInt32(aStream));
  Position := TPosition(RMReadInt32(aStream));

  if lVersion >= 1 then
    LoadEventInfo(aStream);
end;

procedure TRMDialogPage.SaveToStream(aStream: TStream);
begin
  RMWriteWord(aStream, 1); // 版本号
  RMWriteString(aStream, Name);
  RMWriteBoolean(aStream, Visible);

  RMWriteString(aStream, Caption);
  RMWriteInt32(aStream, Left);
  RMWriteInt32(aStream, Top);
  RMWriteInt32(aStream, Width);
  RMWriteInt32(aStream, Height);
  RMWriteInt32(aStream, Color);
  RMWriteInt32(aStream, Integer(BorderStyle));
  RMWriteInt32(aStream, Integer(Position));

  SaveEventInfo(aStream);
end;

procedure TRMDialogPage.PreparePage;
var
  i: Integer;
  t, lParentView: TRMView;
  lHasControls, lSaveVisible: Boolean;

  procedure _SetFormProp;
  begin
    FForm.BorderStyle := BorderStyle;
    FForm.Caption := Caption;
    FForm.Color := Color;
    FForm.SetBounds(Left, Top, Width, Height);
    FForm.Position := Position;
    FForm.OnActivate := OnActivate;
  end;

  procedure _SetTabOrder;
  var
    i, j: Integer;
  begin
    for i := 0 to FForm.ControlCount - 1 do
    begin
      if not (FForm.Controls[i] is TWinControl) then
        Continue;
      for j := 0 to Objects.Count - 1 do
      begin
        t := Objects[j];
        if t is TRMDialogControl then
        begin
          if FForm.Controls[i] = TRMDialogControl(t).FControl then
          begin
            if TRMDialogControl(t).TabOrder >= 0 then
              TWinControl(FForm.Controls[i]).TabOrder := TRMDialogControl(t).TabOrder;
          end;
        end;
      end;
    end;
  end;

begin
  if (FParentReport.MasterReport.DoublePass and FParentReport.MasterReport.FinalPass) then Exit;

  FParentReport.FCurrentPage := Self;
  FForm := TForm.Create(nil);
  lHasControls := False;
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    t.Prepare;
    if t is TRMDialogControl then
    begin
      lHasControls := True;
      lParentView := nil;
      with TRMDialogControl(t) do
      begin
        if FParentControl <> '' then
        begin
          lParentView := Self.FindObject(FParentControl);
          if not lParentView.IsContainer then
            lParentView := nil;
        end;

        if lParentView <> nil then
        begin
          Control.Parent := TWinControl(TRMDialogControl(lParentView).FControl);
          Control.SetBounds(spLeft - lParentView.spLeft, spTop - lParentView.spTop, spWidth, spHeight);
        end
        else
        begin
          Control.Parent := FForm;
          Control.SetBounds(spLeft, spTop, spWidth, spHeight);
        end;
      end;
    end;
  end;

  if lHasControls and Visible then
  begin
    _SetTabOrder;
    lSaveVisible := (FParentReport.MasterReport.FProgressForm <> nil) and FParentReport.MasterReport.FProgressForm.Visible;
    try
      if FParentReport.MasterReport.FProgressForm <> nil then
        FParentReport.MasterReport.FProgressForm.Hide;

      _SetFormProp;
      if FForm.ShowModal <> mrOK then
        FParentReport.FDontShowReport := True;
    finally
      if FParentReport.MasterReport.FProgressForm <> nil then
        FParentReport.MasterReport.FProgressForm.Visible := lSaveVisible;
    end;
  end
  else
  begin
    if Assigned(FOnActivate) then
      FOnActivate(Self);
  end;
end;

procedure TRMDialogPage.UnPreparePage;
begin
  if not (FParentReport.MasterReport.FinalPass or FParentReport.MasterReport.Terminated) then Exit;

  RMClearList(FEventList);
  Clear;
  if FForm <> nil then
  begin
    FreeAndNil(FForm);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPage }

type
  TSortList = class(tList)
  public
    destructor Destroy; override;
    procedure SortInsert(aItem: TRMView);
  end;

destructor TSortList.Destroy;
begin
  inherited Destroy;
end;

procedure TSortList.SortInsert(aItem: TRMView);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if TRMView(Items[i]).FmmTop > aItem.FmmTop then
    begin
      Insert(i, aItem);
      Exit;
    end;
  end;
  Add(aItem);
end;

constructor TRMReportPage.CreatePage(aParentReport: TRMReport; aSize, aWidth, aHeight, aBin: Integer; aOr: TRMPrinterOrientation);
begin
  inherited Create;

  //  FKeepPage_EndPage := nil;
  FKeepPage_Stream := nil;
  FKeepPage_OutLines := nil;
  FChildEndPages := nil;
  FFlags := 0;
  FParentReport := aParentReport;
  FPrintToPrevPage := False;
  FIsSubReportPage := False;
  FNewPrintJob := False;
  FResetPageNo := False;
  FColumnCount := 1;
  FmmColumnGap := 0;

  FAggrList := TList.Create;
  FbkPicture := TPicture.Create;
  FSubReports := TList.Create;
  FParentPages := TList.Create;

  FmmbkPictureLeft := 0;
  FmmbkPictureTop := 0;
  bkPictureWidth := -1;
  bkPictureHeight := -1;
  FShowBackPicture := True;

  ChangePaper(aSize, aWidth, aHeight, aBin, aOr);
  FmmMarginLeft := 15000;
  FmmMarginTop := 15000;
  FmmMarginRight := 15000;
  FmmMarginBottom := 15000;
end;

destructor TRMReportPage.Destroy;
begin
  FreeAndNil(FbkPicture);
  FreeAndNil(FAggrList);
  FreeAndNil(FSubReports);
  FreeAndNil(FParentPages);
  FreeAndNil(FChildEndPages);
  FreeAndNil(FKeepPage_Stream);
  FreeAndNil(FKeepPage_OutLines);
  //	FreeAndNil(FKeepPage_EndPage);

  inherited Destroy;
end;

function TRMReportPage.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
begin
  Result := True;
  if aPropName = 'CURPAGENO' then
    aValue := FParentReport.MasterReport.FPageNo - FStartPageNo + 1
  else if aPropName = 'TOTALPAGES' then
    aValue := FParentReport.MasterReport.FTotalPages - FStartPageNo
  else if aPropName = 'CURRENTCOLUMN' then
    aValue := FCurPageColumn
  else if aPropName = 'PAGEWIDTH' then
    aValue := PageWidth
  else if aPropName = 'PAGEHEIGHT' then
    aValue := PageHeight
  else if aPropName = 'PAGESIZE' then
    aValue := PageSize
  else if aPropName = 'PAGEORIENTATION' then
    aValue := PageOrientation
  else if aPropName = 'PAGEBIN' then
    aValue := PageBin
  else if aPropName = 'SPMARGINLEFT' then
    aValue := spMarginLeft
  else if aPropName = 'SPMARGINTOP' then
    aValue := spMarginTop
  else if aPropName = 'SPMARGINRIGHT' then
    aValue := spMarginRight
  else if aPropName = 'SPMARGINBOTTOM' then
    aValue := spMarginBottom
  else if aPropName = 'SPCOLUMNGAP' then
    aValue := spColumnGap
  else if aPropName = 'SPBACKGROUNDLEFT' then
    aValue := spBackGroundLeft
  else if aPropName = 'SPBACKGROUNDTOP' then
    aValue := spBackGroundTop
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

function TRMReportPage.SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean;
begin
  Result := True;
  //  if aPropName = 'PAGEWIDTH' then
  //    PageWidth := aValue
  //  else if aPropName = 'PAGEHEIGHT' then
  //    PageHeight := aValue
  //  else if aPropName = 'PAGESIZE' then
  //    PageSize := aValue
  //  else if aPropName = 'PAGEORIENTATION' then
  //    PageOrientation := aValue
  //  else if aPropName = 'PAGEBIN' then
  //    PageBin := aValue
  if aPropName = 'SPMARGINLEFT' then
    spMarginLeft := aValue
  else if aPropName = 'SPMARGINTOP' then
    spMarginTop := aValue
  else if aPropName = 'SPMARGINRIGHT' then
    spMarginRight := aValue
  else if aPropName = 'SPMARGINBOTTOM' then
    spMarginBottom := aValue
  else if aPropName = 'SPCOLUMNGAP' then
    spColumnGap := aValue
  else if aPropName = 'SPBACKGROUNDLEFT' then
    spBackGroundLeft := aValue
  else if aPropName = 'SPBACKGROUNDTOP' then
    spBackGroundTop := aValue
  else
    Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

const
  CalcHeaderBands: array[0..2] of TRMBandType = (rmbtReportTitle, rmbtPageHeader, rmbtColumnHeader);
  CalcFooterBands: array[0..2] of TRMBandType = (rmbtColumnFooter, rmbtPageFooter, rmbtReportSummary);

function TRMReportPage.UpdateBandsPageRect: Boolean;
var
  i, j: Integer;
  t, t1: TRMView;
  liNextTop: Integer;
  liList: TSortList;
  liNeedRedraw: Boolean;

  procedure _ChangeBandChildsPos(aBand: TRMView; OffsetY: Integer);
  var
    i: Integer;
    t: TRMView;
  begin
    if OffsetY = 0 then Exit;
    for i := 0 to FObjects.Count - 1 do
    begin
      t := FObjects[i];
      if (not t.IsBand) and (t.ParentBand = aBand) then
      begin
        t.FmmTop := t.FmmTop + OffsetY;
        liNeedRedraw := True;
      end;
    end;
  end;

  procedure _CalcPageRect(t: TRMView; var NextTop: Integer);
  begin
    if t.FmmTop <> NextTop then
    begin
      _ChangeBandChildsPos(t, NextTop - t.FmmTop);
      t.FmmTop := NextTop;
      liNeedRedraw := True;
    end;
    NextTop := NextTop + t.FmmHeight;
    if RMShowBandTitles then
      NextTop := NextTop + Round(RMFromScreenPixels(18, rmutMMThousandths));
  end;

begin
  Result := False;
  Exit;

  liNeedRedraw := False;
  liList := TSortList.Create;
  try
    for i := 0 to FObjects.Count - 1 do
    begin
      t := FObjects[i];
      t.ParentBand := nil;
    end;

    for i := 0 to FObjects.Count - 1 do
    begin
      t := FObjects[i];
      if t.IsBand then
        liList.SortInsert(t);
    end;

    for i := 0 to liList.Count - 1 do
    begin
      t := liList[i];
      for j := 0 to FObjects.Count - 1 do
      begin
        t1 := FObjects[j];
        if (not t1.IsBand) and (t1.spTop >= t.spTop) and (t1.spBottom <= t.spBottom) then
          t1.ParentBand := TRMBand(t);
      end;
    end;

    if RMShowBandTitles then
      liNextTop := Round(RMFromScreenPixels(18, rmutMMThousandths))
    else
      liNextTop := 0;
    for i := Low(CalcHeaderBands) to High(CalcHeaderBands) do
    begin
      for j := 0 to liList.Count - 1 do
      begin
        t := liList[j];
        if TRMCustomBandView(t).BandType = CalcHeaderBands[i] then
          _CalcPageRect(t, liNextTop);
      end;
    end;

    for i := 0 to liList.Count - 1 do
    begin
      t := TRMView(liList[i]);
      if TRMCustomBandView(t).BandType in [rmbtHeader, rmbtFooter, rmbtMasterData,
        rmbtDetailData, rmbtGroupHeader, rmbtGroupFooter] then
        _CalcPageRect(t, liNextTop);
    end;

    for i := Low(CalcFooterBands) to High(CalcFooterBands) do
    begin
      for j := 0 to liList.Count - 1 do
      begin
        t := liList[j];
        if TRMCustomBandView(t).BandType = CalcFooterBands[i] then
          _CalcPageRect(t, liNextTop);
      end;
    end;
  finally
    liList.Free;
    Result := liNeedRedraw;
  end;
end;

procedure TRMReportPage.NewColumn(aBand: TRMBand);

  procedure _DrawRepeatHeader;
  var
    i: Integer;
    lBand: TRMBand;
    lParentPage: TRMReportPage;
    lBandList: TList;
  begin
    lParentPage := TRMReportPage(aBand.FParentPage);
    for i := 0 to lParentPage.FBands[rmbtGroupHeader].Count - 1 do
    begin
      lBand := lParentPage.FBands[rmbtGroupHeader][i];
      if lBand <> aBand then
      begin
        lBand.FNowLine := 0;
        if lBand.ReprintOnNewPage then
        begin
          if not lParentPage.FDisableRepeatHeader then
          begin
            try
              lBand.FDisableBandScript := True;
              lBand.FCurrentColumn := 1;
              lParentPage.ShowBand(lBand);
            finally
              lBand.FDisableBandScript := False;
            end;
          end;
        end;
        // whf 删除，可能有问题，当RePrintOnNewColumn=True,RePrintOnNewPage=False时测试需要删除此行
        //        else if (lBand.BandType = rmbtGroupHeader) and (lBand.FCurrentColumn > 1) then // WhF Modify,对齐
        //          Inc(lParentPage.FmmCurrentY, lBand.FCalculatedHeight);
      end;
    end;

    if (aBand <> nil) and (aBand.BandType in [rmbtMasterData, rmbtDetailData]) then
    begin
      lBandList := TList.Create;
      try
        lBand := aBand;
        while True do
        begin
          if (lBand.FHeaderBand <> nil) and lBand.FHeaderBand.ReprintOnNewPage then
            lBandList.Add(lBand);

          lBand := lBand.FMasterDataBand;
          if lBand = nil then
            Break;
        end;

        for i := lBandList.Count - 1 downto 0 do
        begin
          lBand := lBandList[i];
          try
            lBand.FHeaderBand.FDisableBandScript := True;
            lBand.FHeaderBand.FCurrentColumn := 1;
            lParentPage.ShowBand(lBand.FHeaderBand);
          finally
            lBand.FHeaderBand.FDisableBandScript := False;
          end;
        end;
      finally
        lBandList.Free;
      end;
    end;
  end;

begin
  FFlag_NewPage := True;
  if FCurPageColumn < ColumnCount - 1 then
  begin
    TransferToCachePage;
    DrawColumnFooter(False);

    Inc(FCurPageColumn);
    Inc(FmmCurrentX, FmmColumnWidth + FmmColumnGap);
    FmmCurrentY := FmmLastStaticColumnY;
    ShowBand(BandByType(rmbtColumnHeader));
  end
  else
    NewPage;

  _DrawRepeatHeader;
  aBand.FSaveLastY := aBand.FParentPage.FmmCurrentY;

  FFlag_NewPage := False;
  TransferFromCachePage(True);
end;

procedure TRMReportPage.NewPage;
var
  i: Integer;
  lBand: TRMBand;

  procedure _ResetRepeatedValues(aBandType: TRMBandType);
  var
    i, j: Integer;
    t: TRMView;
  begin
    for i := 0 to FBands[aBandType].Count - 1 do
    begin
      lBand := FBands[aBandType][i];
      for j := 0 to lBand.Objects.Count - 1 do
      begin
        t := lBand.Objects[j];
        if (t is TRMCustomMemoView) and TRMCustomMemoView(t).RepeatedOptions.MergeRepeated and TRMCustomMemoView(t).RepeatedOptions.SuppressRepeated then
        begin
          TRMCustomMemoView(t).FLastValue := '';
        end;
      end;
    end;
  end;

begin
  FFlag_NewPage := True;
  FParentReport.InternalOnProgress(FParentReport.MasterReport.FPageNo + 1);

  TransferToCachePage;

  if not FDisableRepeatHeader then
    DrawColumnFooter(False);
  DrawPageFooters(False);

  if FParentReport.MasterReport.FPageNo >= 0 then
    TransferChildTypeSubReportViews(FParentReport.MasterReport.FPageNo - FChildPageBegin,
      FParentReport.MasterReport.EndPages[FParentReport.MasterReport.FPageNo],
      FParentReport.MasterReport.EndPages);

  if (AutoHCenter or AutoVCenter) and (FParentReport.MasterReport.FPageNo >= 0) then
    AutoCenterObjects(FParentReport.MasterReport.FPageNo);

  Inc(FParentReport.MasterReport.FPageNo);
  FCurrentEndPages.Add(Self);

  if (FLastPrintBand <> nil) and (FLastPrintBand.FCurrentColumn > 1) then // 多栏打印
    FmmCurrentX := FLastPrintBand.FSaveXAdjust;
  FLastPrintBand := nil; // 也许有问题
  FmmCurrentBottomY := GetCurrentBottomY;
  FParentReport.MasterReport.FAppendFlag := False;
  ShowBand(BandByType(rmbtOverlay));

  FmmCurrentY := 0;
  if not FInDrawPageHeader then
  begin
    ShowBand(BandByType(rmbtPageHeader));
    FmmLastStaticColumnY := FmmCurrentY;
    ShowBand(BandByType(rmbtColumnHeader));
  end;

  for i := 0 to FBands[rmbtGroupHeader].Count - 1 do
  begin
    lBand := FBands[rmbtGroupHeader][i];
    lBand.FNowLine := 0;
  end;

  _ResetRepeatedValues(rmbtMasterData);
  _ResetRepeatedValues(rmbtDetailData);

  FFlag_NewPage := False;
  TransferFromCachePage(True);
end;

procedure TRMReportPage.AutoCenterObjects(aPageNo: Integer);
var
  lEndPage: TRMEndPage;

  procedure _AutoHCenter;
  var
    i, lOffsetX, lMinX, lMaxX: Integer;
    t: TRMView;
  begin
    lMinX := 999999;
    lMaxX := 0;
    for i := 0 to lEndPage.Page.Objects.Count - 1 do
    begin
      t := lEndPage.Page.Objects[i];
      lMinX := Min(t.spLeft, lMinX);
      lMaxX := Max(t.spRight, lMaxX);
    end;

    lOffsetX := (PrinterInfo.PageWidth - spMarginLeft - spMarginRight - (lMaxX - lMinx)) div 2;
    for i := 0 to lEndPage.Page.Objects.Count - 1 do
    begin
      t := lEndPage.Page.Objects[i];
      t.spLeft := t.spLeft - lMinx + lOffsetX;
    end;
  end;

  procedure _AutoVCenter;
  var
    i, lOffsetY, lMinY, lMaxY: Integer;
    t: TRMView;
  begin
    lMinY := 999999;
    lMaxY := 0;
    for i := 0 to lEndPage.Page.Objects.Count - 1 do
    begin
      t := lEndPage.Page.Objects[i];
      lMinY := Min(t.spTop, lMinY);
      lMaxY := Max(t.spBottom, lMaxY);
    end;

    lOffsetY := (PrinterInfo.PageHeight - spMarginTop - spMarginBottom - (lMaxY - lMinY)) div 2;
    for i := 0 to lEndPage.Page.Objects.Count - 1 do
    begin
      t := lEndPage.Page.Objects[i];
      t.spTop := t.spTop - lMinY + lOffsetY;
    end;
  end;

begin
  if (not FParentReport.MasterReport.FinalPass) or (FCurrentEndPages = nil) then Exit;

  //  lEndPage := FParentReport.MasterReport.EndPages[aPageNo];
  lEndPage := FCurrentEndPages[aPageNo];
  lEndPage.StreamToObjects(FParentReport, False);

  if FAutoHCenter then
    _AutoHCenter;
  if FAutoVCenter then
    _AutoVCenter;

  lEndPage.ObjectsToStream(FParentReport);
  lEndPage.RemoveCachePage;
end;

procedure TRMReportPage.ShowBandByName(const aBandName: string);
var
  i: Integer;
  lBandType: TRMBandType;
  lBand: TRMBand;
begin
  for lBandType := rmbtReportTitle to rmbtNone do
  begin
    for i := 0 to FBands[lBandType].Count - 1 do
    begin
      lBand := FBands[lBandType][i];
      if RMCmp(lBand.Name, aBandName) then
      begin
        lBand.Print;
        Exit;
      end;
    end;
  end;
end;

procedure TRMReportPage.ShowBandByType(aBandType: TRMBandType);
var
  lBand: TRMBand;
begin
  lBand := BandByType(aBandType);
  if lBand <> nil then
    lBand.Print;
end;

procedure TRMReportPage.PlaceObjects;
var
  t: TRMView;

  procedure _InitObjects; // 初始化各个View
  var
    i: Integer;
  begin
    if FParentPage <> nil then
    begin
      for i := 0 to FParentPage.FAggrList.Count - 1 do
        FAggrList.Add(FParentPage.FAggrList[i]);
    end;

    for i := 0 to FObjects.Count - 1 do
    begin
      t := FObjects[i];
      t.ParentBand := nil;
      t.StreamMode := rmsmPrinting;
      t.Selected := not t.IsBand;
      if t.IsBand then
      begin
        TRMBand(t).FObjects.Clear;
        TRMBand(t).FSubReports.Clear;
        TRMBand(t).FHeaderBand := nil;
        TRMBand(t).FFooterBand := nil;
        TRMBand(t).FDataBand := nil;
        TRMBand(t).FKeepPage_FirstTime := False;
      end;

      if t.Typ = rmgtSubReport then
      begin
        t.Prepare;
        if TRMSubReportView(t).SubReportType = rmstFixed then
        begin
          FSubReports.Add(t);
          t.Selected := False;
        end;
      end;
    end;
  end;

  procedure _PlaceCrossObjectsFirst; // 放置CrossObjects
  var
    lHaveCrossBand: Boolean;
    i: Integer;
    lBandType: TRMBandType;
    lBand: TRMBand;
  begin
    lHaveCrossBand := False;
    for i := 0 to FObjects.Count - 1 do
    begin
      t := FObjects[i];
      if t.IsBand and (TRMCustomBandView(t).BandType in [rmbtCrossHeader..rmbtCrossFooter]) then
      begin
        lBand := BandByType(TRMCustomBandView(t).BandType);
        if lBand = nil then
        begin
          lBand := TRMBand(t);
          TSortList(FBands[TRMCustomBandView(t).BandType]).SortInsert(lBand);
        end;
        lBand.Prepare;
        lHaveCrossBand := True;
      end;
    end;

    if lHaveCrossBand then
    begin
      for lBandType := rmbtCrossHeader to rmbtCrossFooter do
      begin
        lBand := BandByType(lBandType);
        if lBand <> nil then
        begin
          for i := 0 to FObjects.Count - 1 do
          begin
            t := FObjects[i];
            if t.Selected and (t.spLeft >= lBand.spLeft) and (t.spRight <= lBand.spRight) then
            begin
              if (t.Typ = rmgtSubReport) and (TRMSubReportView(t).SubReportType = rmstFixed) then
                Continue;

              t.spLeft := t.spLeft - lBand.spLeft;
              t.ParentBand := lBand;
              lBand.FObjects.Add(t);
            end;
          end;
        end; {end if}
      end; {end for}
    end;
  end;

  procedure _PlaceOtherObjects; // 放置其它View
  var
    b: TRMBandType;
    i: Integer;
    liBand: TRMBand;

    function _FindBandObject(aBand: TRMBand; const aObjectName: string): TRMReportView;
    var
      i: Integer;
      t: TRMReportView;
    begin
      Result := nil;
      for i := 0 to aBand.FObjects.Count - 1 do
      begin
        t := aBand.FObjects[i];
        if RMCmp(t.Name, aObjectName) then
        begin
          if (t is TRMStretcheableView) and t.Stretched then
            Result := t;
          Break;
        end;
      end;
    end;

    procedure _TossOneBand(b: TRMBandType);
    var
      i, j: Integer;
      liBand: TRMBand;
      t: TRMReportView;
    begin
      for i := 0 to FObjects.Count - 1 do
      begin
        t := FObjects[i];
        if not (t.IsBand and (TRMCustomBandView(t).BandType = b)) then Continue;

        liBand := TRMBand(t);
        TSortList(FBands[b]).SortInsert(liBand);
        liBand.Prepare;
        for j := 0 to FObjects.Count - 1 do
        begin
          t := FObjects[j];
          if (t.ParentBand = nil) and t.Selected and
            (t.spTop >= liBand.spTop) and (t.spBottom <= liBand.spBottom) then
          begin
            if not liBand.Stretched then t.Stretched := False;
            if t.Typ = rmgtSubReport then
            begin
              if (b in [rmbtMasterData, rmbtDetailData]) and
                (TRMSubReportView(t).SubReportType = rmstChild) and TRMSubReportView(t).FCanPrint then
              begin
                t.ParentBand := liBand;
                t.spTop := t.spTop - liBand.spTop;
                t.Selected := False;
                liBand.FObjects.Add(t);
                liBand.FSubReports.Add(t);
              end;
            end
            else
            begin
              t.ParentBand := liBand;
              t.spTop := t.spTop - liBand.spTop;
              t.Selected := False;
              liBand.FObjects.Add(t);
            end;
          end;
        end;

        for j := 0 to FObjects.Count - 1 do // placing ColumnXXX objects over band
        begin
          t := FObjects[j];
          if (t.ParentBand <> nil) and t.Selected and
            (t.spTop >= liBand.spTop) and (t.spBottom <= liBand.spBottom) then
          begin
            if not liBand.Stretched then t.Stretched := False;
            t.spTop := t.spTop - liBand.spTop;
            t.Selected := False;
            liBand.FObjects.Add(t);
          end;
        end;

        if liBand.Stretched then
        begin
          for j := 0 to liBand.FObjects.Count - 1 do
          begin
            t := liBand.FObjects[j];
            if t.ShiftWith <> '' then
              t.FShiftWithView := _FindBandObject(liBand, t.ShiftWith);
            if t.StretchWith <> '' then
              t.FStretchWithView := _FindBandObject(liBand, t.StretchWith);
          end;
        end;
      end; // end for
    end;

  begin
    for b := rmbtReportTitle to rmbtChild do
    begin
      if not (b in [rmbtCrossHeader..rmbtCrossFooter]) then
        _TossOneBand(b); // 处理一个Band
    end;

    for i := 0 to FObjects.Count - 1 do // place other objects on rmbtNone band
    begin
      t := FObjects[i];
      if t.Selected and (t.Typ <> rmgtSubReport) then
      begin
        liBand := BandByType(rmbtNone);
        if liBand = nil then
        begin
          liBand := TRMBand.Create;
          liBand.FBandType := rmbtNone;
          liBand.ParentPage := Self;
          liBand.FmmTop := 0;
          TSortList(FBands[rmbtNone]).SortInsert(liBand);
        end;
        t.ParentBand := liBand;
        liBand.FObjects.Add(t);
      end;
    end;
  end;

  procedure _PlaceChildBand;
  var
    i: Integer;
    bt: TRMBandType;
    lBand: TRMBand;
  begin
    for bt := rmbtReportTitle to rmbtChild do // connecting child bands
    begin
      for i := 0 to FBands[bt].Count - 1 do
      begin
        lBand := FBands[bt][i];
        lBand.ChildBand := lBand.ChildBand;
      end;
    end;
  end;

  procedure _SetHeaderFooterBand; // connect header & footer to each data-band
  var
    i, j: Integer;
    lBand, lDataBand: TRMBand;
    lList: TSortList;
    t: TRMView;
  begin
    lList := TSortList.Create;
    try
      for i := 1 to MAXBNDS do
      begin
        for j := 0 to FBands[Bnds[i]].Count - 1 do
          lList.SortInsert(FBands[Bnds[i]][j]);
      end;

      for j := 0 to FBands[rmbtHeader].Count - 1 do // HeaderBand
      begin
        lBand := FBands[rmbtHeader][j];
        if lBand.FDataBand <> nil then Continue;

        if lBand.DataBandName <> '' then
        begin
          t := FindObject(lBand.DataBandName);
          if (t <> nil) and t.IsBand then
          begin
            TRMBand(t).FHeaderBand := lBand;
            lBand.FDataBand := TRMBand(t);
            Continue;
          end;
        end;

        for i := 0 to lList.Count - 1 do
        begin
          lDataBand := lList[i];
          if (lDataBand.FHeaderBand = nil) and (lDataBand.spTop >= lBand.spBottom) then
          begin
            lDataBand.FHeaderBand := lBand;
            lBand.FDataBand := lDataBand;
            Break;
          end;
        end;
      end;

      for j := 0 to FBands[rmbtFooter].Count - 1 do // FooterBand
      begin
        lBand := FBands[rmbtFooter][j];
        if lBand.FDataBand <> nil then Continue;

        if lBand.DataBandName <> '' then
        begin
          t := FindObject(lBand.DataBandName);
          if (t <> nil) and t.IsBand then
          begin
            TRMBand(t).FFooterBand := lBand;
            lBand.FDataBand := TRMBand(t);
            Continue;
          end;
        end;

        for i := lList.Count - 1 downto 0 do
        begin
          lDataBand := lList[i];
          if (lDataBand.FFooterBand = nil) and (lDataBand.spBottom <= lBand.spTop) then
          begin
            lDataBand.FFooterBand := lBand;
            lBand.FDataBand := lDataBand;
            Break;
          end;
        end;
      end;
    finally
      lList.Free;
    end;
  end;

  procedure _SetGroupBands; // 处理分组
  var
    s: string;
    i, j: Integer;
    lLastBand, lGroupHeader, lDataBand, lBand: TRMBand;
  begin
    i := 0;
    j := FBands[rmbtGroupFooter].Count - 1;
    while (i < FBands[rmbtGroupHeader].Count) and (j >= 0) do
    begin
      t := nil;
      lBand := FBands[rmbtGroupFooter][j];
      if lBand.GroupHeaderBandName <> '' then
        t := FindObject(lBand.GroupHeaderBandName);

      lGroupHeader := TRMBand(FBands[rmbtGroupHeader][i]);
      if (t <> nil) and t.IsBand then
      begin
        lBand.FHeaderBand := TRMBand(t);
        TRMBand(t).FFooterBand := lBand;
        Inc(i);
        Dec(j);
      end
      else if lGroupHeader.FFooterBand = nil then
      begin
        lBand.FHeaderBand := lGroupHeader;
        lGroupHeader.FFooterBand := lBand;
        Inc(i);
        Dec(j);
      end
      else
      begin
        Inc(i);
        //Dec(j);
      end;
    end;

    if BandByType(rmbtMasterData) = nil then Exit; // tossing group headers

    s := BandByType(rmbtMasterData).Name;
    for i := 0 to FBands[rmbtGroupHeader].Count - 1 do
    begin
      lGroupHeader := FBands[rmbtGroupHeader][i];
      lGroupHeader.FLevel := i;
      lGroupHeader.FKeepPage_FirstTime := (i = 0);
      if lGroupHeader.FFooterBand = nil then
      begin
        lBand := TRMBandGroupFooter.Create;
        lBand.NeedCreateName := False;
        lBand.ParentPage := Self;
        lBand.Visible := False;
        lBand.FmmHeight := 0;
        lGroupHeader.FFooterBand := lBand;
        lBand.FHeaderBand := lGroupHeader;
      end;

      if lGroupHeader.MasterBandName = '' then
        t := FindObject(s)
      else
        t := FindObject(lGroupHeader.MasterBandName);

      if (t <> nil) and t.IsBand then
      begin
        lDataBand := TRMBand(t);
        lLastBand := lDataBand.FLastGroup;
        if lLastBand = nil then
        begin
          lDataBand.FFirstGroup := lGroupHeader;
          lDataBand.FLastGroup := lGroupHeader;
          lGroupHeader.FDataBand := lDataBand;
        end
        else
        begin
          lLastBand.FNextGroup := lGroupHeader;
          lGroupHeader.FPrevGroup := lLastBand;
          lDataBand.FLastGroup := lGroupHeader;
          lGroupHeader.FDataBand := lDataBand;
        end;
      end;
    end;
  end;

  procedure _SetMasterDetailBands;
  var
    i: Integer;
    lBand: TRMBand;
    t: TRMView;
  begin
    FMaxLevel := 0;
    for i := 0 to FBands[rmbtMasterData].Count - 1 do
    begin
      lBand := FBands[rmbtMasterData][i];
      lBand.FMasterDataBand := nil;
      lBand.FLevel := 1;
      lBand.FKeepPage_FirstTime := (i = 0);
      Inc(FMaxLevel);
    end;

    for i := 0 to FBands[rmbtDetailData].Count - 1 do
    begin
      lBand := FBands[rmbtDetailData][i];
      lBand.FMasterDataBand := nil;
      if lBand.MasterBandName <> '' then
      begin
        t := FindObject(lBand.MasterBandName);
        if (t <> nil) and t.IsBand and (t <> lBand) then
          lBand.FMasterDataBand := TRMBand(t);
      end;

      if (lBand.FMasterDataBand = nil) and (FBands[rmbtMasterData].Count > 0) then
      begin
        lBand.FMasterDataBand := FBands[rmbtMasterData][0];
      end;

      if lBand.FMasterDataBand = nil then
      begin
        lBand.FLevel := 2;
        if FMaxLevel < 2 then
          FMaxLevel := 2;
      end
      else
      begin
        lBand.FLevel := lBand.FMasterDataBand.FLevel + 1;
        if FMaxLevel < lBand.FLevel then
          FMaxLevel := lBand.FLevel;
      end;
    end;
  end;

  procedure _SetCrossDataSet;
  var
    i: Integer;
    lBand: TRMBand;
    bt: TRMBandType;
  begin
    lBand := BandByType(rmbtCrossData);
    if lBand = nil then Exit;

    for bt := rmbtHeader to rmbtChild do
    begin
      for i := 0 to FBands[bt].Count - 1 do
      begin
        lBand := FBands[bt][i];
        RMCreateDataSet(FParentReport, lBand.CrossDataSetName, lBand.FIsVirtualCrossDataSet,
          lBand.FVirtualCrossDataSet);
      end;
    end;
  end;

begin
  FSubReports.Clear;
  _InitObjects; // 标计是不是BandView
  _PlaceCrossObjectsFirst; // 首先放置CrossView;
  _PlaceOtherObjects; // 在设置其它View
  _PlaceChildBand;
  _SetHeaderFooterBand;
  _SetGroupBands;
  _SetMasterDetailBands;
  _SetCrossDataSet;

  FParentReport.InitAggregate := False;
  FParentReport.InDictionary := False;
end;

procedure TRMReportPage.PrepareObjects;
var
  i: Integer;
  lBandType: TRMBandType;

  procedure _PrepareOneObject(t: TRMReportView);
  var
    lEndPos: Integer;
    s: string;
    lDataSet: TRMDataSet;
    lFieldName: string;
    p: PRMCacheItem;
  begin
    if t.IsBand then Exit;

    t.IsBlobField := False;
    t.FDataSet := nil;
    t.FDataFieldName := '';

    s := t.Memo.Text;
    lEndPos := Length(s);
    if (lEndPos > 2) and (s[1] = '[') and (not (s[1] in LeadBytes)) and (not t.TextOnly) then
    begin
      while lEndPos > 1 do
      begin
        if s[lEndPos] in LeadBytes then
        begin
          Dec(lEndPos, 2);
        end
        else
        begin
          if s[lEndPos] = ']' then
            Break
          else
            Dec(lEndPos);
        end;
      end;

      s := Copy(s, 2, lEndPos - 2);
      FParentReport.FCurrentBand := t.ParentBand;
      if FParentReport.Dictionary.IsVariable(s) then
      begin
        if FParentReport.Dictionary.FCache.Find(s, lEndPos) then
        begin
          p := PRMCacheItem(FParentReport.Dictionary.FCache.Objects[lEndPos]);
          t.FDataSet := p^.DataSet;
          t.FDataFieldName := p^.DataFieldName;
        end;
      end
      else
      begin
        FParentReport.FCurrentBand := t.ParentBand;
        lDataSet := RMGetDefaultDataset(FParentReport);
        RMGetDatasetAndField(FParentReport, s, lDataSet, lFieldName);
        if lFieldName <> '' then
        begin
          t.FDataSet := lDataSet;
          t.FDataFieldName := lFieldName;
        end;
      end;

      if (t.FDataSet <> nil) and (t.FDataFieldName <> '') then
        t.IsBlobField := t.FDataSet.IsBlobField(t.FDataFieldName);
    end;
  end;

  procedure _ExpandVariables(aBand: TRMBand);
  var
    i: Integer;
    t: TRMReportView;
    lList: TStringList;
    tmp: TAggregateFunctionsSplitter;
  begin
    lList := TStringList.Create;
    tmp := TAggregateFunctionsSplitter.CreateSplitter(lList, FParentReport);
    try
      FParentReport.FCurrentBand := aBand;
      for i := 0 to aBand.Objects.Count - 1 do
      begin
        t := aBand.Objects[i];
        FParentReport.FCurrentView := t;
        if t is TRMCustomMemoView then
          tmp.SplitMemo(t.Memo);
      end;

      for i := 0 to lList.Count - 1 do
        FParentReport.Parser.CalcOPZ(lList[i]);
    finally
      lList.Free;
      tmp.Free;
    end;
  end;

  procedure _ExpandBands(lAryBands: array of TRMBandType);
  var
    i, j: Integer;
    lBand: TRMBand;
  begin
    for i := Low(lAryBands) to High(lAryBands) do
    begin
      for j := 0 to FBands[lAryBands[i]].Count - 1 do
      begin
        lBand := FBands[lAryBands[i]][j];
        while lBand <> nil do
        begin
          _ExpandVariables(lBand);
          lBand := lBand.FBandChild;
        end;
      end;
    end;
  end;

begin
  ColumnCount := ColumnCount;

  FmmColumnWidth := Round(RMFromScreenPixels(PrinterInfo.PageWidth, rmutMMThousandths))
    - FmmMarginLeft - FmmMarginRight;
  FmmColumnWidth := (FmmColumnWidth - ((ColumnCount - 1) * FmmColumnGap)) div ColumnCount;

  FParentReport.FCurrentPage := Self;
  for i := 0 to Objects.Count - 1 do
    _PrepareOneObject(Objects[i]);

  FParentReport.InitAggregate := True;
  try
    try
      for lBandType := rmbtMasterData to rmbtDetailData do
      begin
        for i := 0 to FBands[lBandType].Count - 1 do
        begin
          FParentReport.FRMAggrBand := FBands[lBandType][i];
          _ExpandBands([rmbtPageFooter, rmbtColumnFooter, rmbtFooter,
            rmbtGroupFooter, rmbtReportSummary]);
        end;
      end;
    except
      //on E: Exception do
      //  DoError(E);
    end;
  finally
    FParentReport.InitAggregate := False;
  end;
end;

procedure TRMReportPage.PrepareAggrObjects;
var
  i, lStartPos, lEndPos: Integer;
  s, s1: string;
  tmpFormat: TRMFormat;
  tmpFormatStr: string;
  t: TRMCalcMemoView;
begin
  if FParentReport.MasterReport.DoublePass and FParentReport.MasterReport.FinalPass then
  begin
    for i := 0 to FAggrList.Count - 1 do
      TRMCalcMemoView(FAggrList[i]).FValueIndex := 0;
    Exit;
  end;

  FParentReport.FCurrentPage := Self;
  for i := 0 to FAggrList.Count - 1 do
  begin
    t := TRMCalcMemoView(FAggrList[i]);

    // 查询是否有初始化组
    t.Expression := '';
    t.FResetGroupBand := nil;
    if t.CalcOptions.ResetGroupName <> '' then
    begin
      t.FResetGroupBand := FindObject(t.CalcOptions.ResetGroupName);
      if t.FResetGroupBand <> nil then
        t.CalcOptions.ResetAfterPrint := False;
    end;

    t.ResetValues;
    t.FOPZFilter := FParentReport.Parser.Str2OPZ(t.CalcOptions.FFilter);
    t.FResultExpression := FParentReport.Parser.Str2OPZ(t.FResultExpression);
    if t.FCalcOptions.CalcType = rmdcUser then
    begin
      t.CalcOptions.FIntalizeValue := FParentReport.Parser.Str2OPZ(t.CalcOptions.FIntalizeValue);
      t.CalcOptions.FAggregateValue := FParentReport.Parser.Str2OPZ(t.CalcOptions.FAggregateValue);
    end;

    if t.Memo.Count > 0 then
    begin
      FParentReport.FCurrentView := t;
      s := t.Memo[0];
      t.Expression := '';
      lStartPos := Pos('[', s);
      if lStartPos > 0 then
      begin
        s1 := RMGetBrackedVariable(s, lStartPos, lEndPos);
        if lStartPos <> lEndPos then
        begin
          RMGetFormatStr(t, s1, tmpFormatStr, tmpFormat);
          t.Expression := '[' + s1 + ']';
        end;
      end;
    end;
  end;
end;

procedure TRMReportPage.PreparePage;
var
  lBand: TRMBandType;
  t: TRMView;
  i: Integer;
  lSecondTime: Boolean;
begin
  FInDrawPageHeader := False;
  FAggrList.Clear;
  FLastPrintBand := nil;
  FParentReport.HaveHookObject := False;
  if FParentReport.PrintAtFirstTime then
  begin
    FParentReport.HaveHookObject := True;
  end;

  lSecondTime := FParentReport.MasterReport.DoublePass and FParentReport.MasterReport.FinalPass;
  for i := 0 to FObjects.Count - 1 do
  begin
    t := FObjects[i];
    if t.IsBand then
    begin
      TRMBand(t).FLastPageNo := 0;
      if lSecondTime then
      begin
        if TRMBand(t).FDataSet <> nil then // 需要重新初始化
          TRMBand(t).FDataSet.Init;
      end;
    end;

    if not (t.IsBand or (t.Typ = rmgtSubReport)) then
      t.Prepare;

    if (t is TRMCustomMemoView) and TRMCustomMemoView(t).RepeatedOptions.MergeStretchedHeight then
    	FParentReport.HaveHookObject := True;

    if t.WantHook then
    begin
      if t.UseDoublePass then
        FParentReport.HaveHookObject := True;
      FParentReport.FHookList.Add(t);
    end;
  end;

  if lSecondTime then Exit;

  for lBand := rmbtReportTitle to rmbtNone do
    FBands[lBand] := TSortList.Create;

  if FIsSubReportPage and (FSubReportView <> nil) and (FSubReportView.SubReportType = rmstFixed) then
  begin
    FmmOffsetX := 0 {FmmMarginLeft};
    FmmOffsetY := 0 {FmmMarginTop};
  end
  else
  begin
    FmmOffsetX := 0;
    FmmOffsetY := 0 {FmmMarginTop};
  end;

  PlaceObjects;
  FCurrentPos := 1;
  FColumnPos := 1;
  PrepareObjects;
end;

procedure TRMReportPage.UnPreparePage;
var
  t: TRMView;
  bt: TRMBandType;
  i: Integer;
begin
  if not FParentReport.MasterReport.FinalPass then
  begin
    for i := 0 to FObjects.Count - 1 do
    begin
      t := FObjects[i];
      if t.IsBand then
      begin
        if TRMBand(t).FDataSet <> nil then
          TRMBand(t).FDataSet.Exit;
        if TRMBand(t).FVirtualCrossDataSet <> nil then
          TRMBand(t).FVirtualCrossDataSet.Exit;
      end;
    end;

    Exit;
  end;

  for bt := rmbtReportTitle to rmbtNone do
  begin
    if FBands[bt] <> nil then
    begin
      for i := 0 to FBands[bt].Count - 1 do
      begin
        try
          TRMBand(FBands[bt][i]).UnPrepare;
        except
        end;
      end;
      FreeAndNil(FBands[bt]);
    end;
  end;

  for i := 0 to FObjects.Count - 1 do
  begin
    t := FObjects[i];
    if not t.IsBand then
    begin
      t.UnPrepare;
    end;
  end;

  RMClearList(FEventList);
end;

procedure TRMReportPage.ResetPosition(aBand: TRMBand; aResetTo: Integer);
var
  i: Integer;
  t: TRMView;
begin
  aBand.FPositions[rmpsLocal] := aResetTo;
  aBand.FNowLine := 0;

  if aResetTo = 0 then // 组初始化,这个可能有问题
  begin
    for i := 0 to aBand.FObjects.Count - 1 do
    begin
      t := aBand.FObjects[i];
      if t is TRMCustomMemoView then
      begin
        TRMCustomMemoView(t).FLastValue := '';
      end;
    end;
  end;
end;

procedure TRMReportPage.CreateChildReport;
begin
  if FChildEndPages = nil then
  begin
    FChildEndPages := TRMEndPages.Create(ParentReport);
  end;
end;

procedure TRMReportPage.FreeChildReport;
begin
  if FChildEndPages <> nil then
  begin
    FreeAndNil(FChildEndPages);
  end;
end;

function TRMReportPage.HaveChildEndPage(aPageIndex: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to FSubReports.Count - 1 do
  begin
    if TRMSubReportView(FSubReports[i]).Page.FChildEndPages.Count > aPageIndex then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TRMReportPage.TransferChildTypeSubReportViews(aPageIndex: Integer;
  aEndPage: TRMEndPage; aEndPages: TRMEndPages);
var
  i, j: Integer;
  lSourcePage: TRMEndPage;
  t: TRMView;
  lSubReportView: TRMSubReportView;
  lPageIndex: Integer;
begin
  if not HaveChildEndPage(aPageIndex) then Exit;

  aEndPage.StreamToObjects(FParentReport.MasterReport, False);
  try
    for i := 0 to FSubReports.Count - 1 do
    begin
      lPageIndex := -1;
      lSubReportView := TRMSubReportView(FSubReports[i]);
      if lSubReportView.Page.FChildEndPages.Count > aPageIndex then
        lPageIndex := aPageIndex
      else if lSubReportView.ReprintLastPage then
        lPageIndex := lSubReportView.Page.FChildEndPages.Count - 1;

      if lPageIndex >= 0 then
      begin
        lSourcePage := lSubReportView.Page.FChildEndPages[lPageIndex];
        lSourcePage.StreamToObjects(FParentReport.MasterReport, False);
        for j := 0 to lSourcePage.FPage.FObjects.Count - 1 do
        begin
          t := lSourcePage.FPage.Objects[j];
          if t.Typ = rmgtOutline then
          begin
            t.FmmTop := t.FmmTop + lSubReportView.Page.FSubReport_MMTop;
            TRMOutlineView(t).FPageNo := lPageIndex;
            aEndPages.OutLines.Add(TRMOutlineView(t).OutlineText);
            t.Free;
          end
          else
          begin
            t.NeedCreateName := False;
            t.FParentPage := nil;
            t.ParentPage := aEndPage.FPage;
            t.FmmLeft := t.FmmLeft + lSubReportView.Page.FSubReport_MMLeft;
            t.FmmTop := t.FmmTop + lSubReportView.Page.FSubReport_MMTop;
          end;
        end;

        lSourcePage.FPage.FObjects.Clear;
        lSourcePage.RemoveCachePage;
      end;
    end;
  finally
    aEndPage.ObjectsToStream(FParentReport.MasterReport);
    aEndPage.RemoveCachePage;
  end;
end;

procedure TRMReportPage.PrintChildTypeSubReports;
var
  i, lSavePageNo: Integer;
  lPage: TRMReportPage;
begin
  if FSubReports.Count < 1 then Exit;

  lSavePageNo := FParentReport.MasterReport.FPageNo;
  try
    for i := 0 to FSubReports.Count - 1 do
    begin
      FParentReport.MasterReport.FPageNo := 0;
      lPage := TRMSubReportView(FSubReports[i]).Page;
      FParentReport.FCurrentPage := lPage;
      if lPage.Visible then
      begin
        FParentReport.MasterReport.EndPages.AddbkPicture(lPage.spBackGroundLeft,
          lPage.spBackGroundTop, lPage.bkPictureWidth,
          lPage.bkPictureHeight, lPage.FbkPicture);

        lPage.FIsSubReportPage := False;
        lPage.FPrintChildTypeSubReportPage := True;
        try
          lPage.CreateChildReport;
          lPage.FCurrentEndPages := lPage.FChildEndPages;
          lPage.PrintPage;
          lPage.FChildPageNo := 0;
        finally
          lPage.FIsSubReportPage := True;
        end;
      end;
    end;
  finally
    FParentReport.MasterReport.FPageNo := Max(lSavePageNo, FParentReport.MasterReport.EndPages.Count - 1);
  end;
end;

{procedure TRMReportPage.InitKeepPageInfo;
begin
  FUseKeepPage := False;
  FKeepPage_OffsetLeft := 0;
  FKeepPage_OffsetTop := 0;
  FreeAndNil(FKeepPage_EndPage);
end;

procedure TRMReportPage.FreeKeepPageInfo;
begin
  FUseKeepPage := False;
  FreeAndNil(FKeepPage_EndPage);
end;

procedure TRMReportPage.AddKeepPageBand(aEndBand: TRMBand);
begin
  if FKeepPage_EndPage = nil then
  begin
   FKeepPage_EndPage := TRMEndPage.Create(FCurrentEndPages);
  end;

  if not FUseKeepPage then
  begin
  end;

  FUseKeepPage := True;
end;}

procedure TRMReportPage.InitKeepPageInfo;
begin
  FKeepPage_Count := 0;
  FKeepPage_SaveStream := nil;
  FKeepPage_SavePos := -1;
  FKeepPage_OffsetLeft := 0;
  FKeepPage_OffsetTop := 0;
  FreeAndNil(FKeepPage_Stream);
  FreeAndNil(FKeepPage_OutLines);
end;

procedure TRMReportPage.FreeKeepPageInfo;
begin
  FKeepPage_Count := 0;
  FreeAndNil(FKeepPage_Stream);
  FreeAndNil(FKeepPage_OutLines);
end;

procedure TRMReportPage.AddKeepPageBand(aEndBand: TRMBand);
begin
  if FKeepPage_Stream = nil then
    FKeepPage_Stream := TMemoryStream.Create;

  if FKeepPage_OutLines = nil then
    FKeepPage_OutLines := TStringList.Create;

  if FKeepPage_Count <= 0 then
  begin
    FKeepPage_SaveStream := FCurrentEndPages[FParentReport.MasterReport.FPageNo].EndPageStream;
    FKeepPage_SavePos := FKeepPage_SaveStream.Position;
    FKeepPage_OffsetLeft := FmmCurrentX + FmmOffsetX;
    FKeepPage_OffsetTop := FmmCurrentY + FmmOffsetY;
  end;

  Inc(FKeepPage_Count);
end;

procedure TRMReportPage.DeleteKeepPageBand(aEndBand: TRMBand);
var
  i: Integer;
begin
  if FKeepPage_Count > 0 then
  begin
    Dec(FKeepPage_Count);
    for i := 0 to FKeepPage_OutLines.Count - 1 do
    begin
      FCurrentEndPages.OutLines.Add(FKeepPage_OutLines[i]);
    end;
  end;

  if FKeepPage_Stream <> nil then
    FKeepPage_Stream.Clear;

  if FKeepPage_OutLines <> nil then
    FKeepPage_OutLines.Clear;
end;

procedure TRMReportPage.TransferToCachePage;
begin
  if FKeepPage_Count < 1 then Exit;

  if FKeepPage_SavePos >= FKeepPage_SaveStream.Size then
  begin
    FKeepPage_Count := 0;
  end
  else
  begin
    FKeepPage_SaveStream.Position := FKeepPage_SavePos;
    FKeepPage_Stream.CopyFrom(FKeepPage_SaveStream, FKeepPage_SaveStream.Size - FKeepPage_SavePos);
    FKeepPage_SaveStream.SetSize(FKeepPage_SavePos);
  end;
end;

procedure TRMReportPage.TransferFromCachePage(aNewPage: Boolean);
var
  t: TRMView;
  lMaxHeight: Integer;
  lObjectType: Byte;
  lObjectClassName: string;
  lStream: TStream;
begin
  if FKeepPage_Count < 1 then Exit;

  lMaxHeight := 0;
  FKeepPage_Stream.Position := 0;
  try
    while FKeepPage_Stream.Position < FKeepPage_Stream.Size do
    begin
      lObjectType := RMReadByte(FKeepPage_Stream);
      if lObjectType = rmgtAddIn then
        lObjectClassName := RMReadString(FKeepPage_Stream)
      else if lObjectType > rmgtAddIn then // 肯定出问题了
      begin
        Break;
      end;

      // 读出
      t := RMCreateObject(lObjectType, lObjectClassName);
      t.NeedCreateName := False;
      t.StreamMode := rmsmPrinting;
      t.FParentPage := nil;
      t.FParentReport := FParentReport;
      t.LoadFromStream(FKeepPage_Stream);

      // 改写
      t.FmmTop := t.FmmTop - FKeepPage_OffsetTop;
      if aNewPage then
      begin
        Inc(t.FmmTop, FmmCurrentY);
      end;

      // 写回
      if t is TRMOutlineView then
      begin
        TRMOutlineView(t).FPageNo := FParentReport.MasterReport.FPageNo;
        FCurrentEndPages.OutLines.Add(TRMOutlineView(t).OutlineText);
      end
      else
      begin
        lStream := FCurrentEndPages[FParentReport.MasterReport.FPageNo].EndPageStream;
        t.NeedCreateName := False;
        t.StreamMode := rmsmPrinting;
        t.Memo1.Assign(t.Memo);
        if t is TRMCustomMemoView then
          TRMCustomMemoView(t).CalcGeneratedData(FParentReport.MasterReport.DrawCanvas.Handle);

        RMWriteByte(lStream, t.Typ);
        if t.Typ = rmgtAddIn then
          RMWriteString(lStream, t.ClassName);
        t.SaveToStream(lStream);
      end;

      lMaxHeight := Max(lMaxHeight, t.FmmTop + t.FmmHeight);
      FreeAndNil(t);
    end;
  finally
    FKeepPage_Count := 0;
    FKeepPage_OffsetLeft := 0;
    FKeepPage_OffsetTop := 0;
    FKeepPage_SavePos := -1;
    FKeepPage_Stream.Clear;
    FKeepPage_OutLines.Clear;
    if aNewPage then
      FmmCurrentY := lMaxHeight;
  end;
end;

procedure TRMReportPage.DoPrintPage(aMasterBand: TRMBand; aBandType: TRMBandType;
  aNowLevel: Integer; var aBndStackTop: Integer; var aBndStack: array of TRMBand);
var
  lPrintedFlag: Boolean;
  lDataBand, lGroupBand: TRMBand;
  lHaveGroup: Boolean;
  lNowBandIndex: Integer;
  lBandList: TList;
  lHeight: Integer;

  procedure _DrawBlank(aBand: TRMBand; MastDraw: Boolean; aHeight: integer;
    OldFlag, aIsGroup: Boolean); //用空记录填充表格
  var
    lSavePageNo: Integer;

    function _CheckNotEnd: Boolean;
    begin
      if FParentReport.MasterReport.FPageNo <> lSavePageNo then
      begin
        Result := False;
        Exit;
      end;

      Result := True;
      if aBand.LinesPerPage > 0 then
      begin
        if aBand.PrintColumnFirst then
          Result := aBand.FNowLine < aBand.LinesPerPage * aBand.Columns
        else
        begin
          if aBand.FCurrentColumn < aBand.Columns then
            Result := aBand.FNowLine <= aBand.LinesPerPage
          else
            Result := aBand.FNowLine < aBand.LinesPerPage;
        end;
      end;

      if aBand.PrintColumnFirst and (aBand.Columns > 1) then
      begin
        if (aBand.FCurrentColumn = aBand.Columns) and
          ((FmmCurrentBottomY - FmmCurrentY < aHeight) or aBand.AdjustColumns) then
          Result := False;
      end
      else if (not aBand.PrintColumnFirst) and (aBand.FCurrentColumn < aBand.Columns) then
        Result := True
      else
        Result := Result and (FmmCurrentBottomY - FmmCurrentY >= aHeight);
    end;

    procedure _DrawBlank1;
    begin
      lSavePageNo := FParentReport.MasterReport.FPageNo;
      while (not FParentReport.MasterReport.Terminated) and (not FParentReport.MasterReport.ErrorFlag)
        and _CheckNotEnd do
      begin
        if aIsGroup then
        begin
          Inc(aBand.FPositions[rmpsGlobal]);
          Inc(aBand.FPositions[rmpsLocal]);
        end;

        ShowBand(aBand); //aBand.Draw;
        if not aIsGroup then
        begin
          Inc(aBand.FPositions[rmpsGlobal]);
          Inc(aBand.FPositions[rmpsLocal]);
        end;
      end;
    end;

  begin
    if (MastDraw or aBand.DataSet.EOF) and aBand.Visible then
    begin
      try
        FParentReport.FFlag_TableEmpty := True;
        FParentReport.FFlag_TableEmpty1 := True;
        if BandByType(rmbtColumnFooter) <> nil then
          aHeight := aHeight + BandByType(rmbtColumnFooter).FmmHeight;
        aHeight := aHeight + aBand.FmmHeight;

        // 如果不够打印分组注脚时
        // hzw008 要减去当前的行的行高在进行比较
        if aIsGroup and (FmmCurrentBottomY - FmmCurrentY < aHeight - aBand.FmmHeight) then
          //        if aIsGroup and (FmmCurrentBottomY - FmmCurrentY < aHeight) then // 如果不够打印分组注脚时
        begin
          try
            aHeight := aBand.FmmHeight;
            if BandByType(rmbtColumnFooter) <> nil then
              aHeight := aHeight + BandByType(rmbtColumnFooter).FmmHeight;
            _DrawBlank1;

            FParentReport.FFlag_TableEmpty := False;
            FParentReport.FFlag_TableEmpty1 := False;
            if not aBand.Dataset.Eof then
              aBand.DataSet.Prior;

            NewPage;
            //漏的就是这2句--------
            //if BandByType(rmbtGroupHeader) <> nil then
            //  showband(BandByType(rmbtGroupHeader));
             //漏的就是这2句----------
            if not aBand.DataSet.Eof then
              aBand.DataSet.Next;
          finally
            FParentReport.FFlag_TableEmpty := True;
            FParentReport.FFlag_TableEmpty1 := True;
          end;

          // hzw增加
          if BandByType(rmbtGroupFooter) <> nil then
          begin
            while not (FmmCurrentBottomY - FmmCurrentY - BandByType(rmbtGroupFooter).FmmHeight < aHeight) do
              ShowBand(aBand);
          end;
          // hzw
        end
        else // hzw增加
          _DrawBlank1;
      finally
        FParentReport.FFlag_TableEmpty := OldFlag;
        FParentReport.FFlag_TableEmpty1 := OldFlag;
      end;
    end;
  end;

  procedure _AddToStack(aBand: TRMBand);
  begin
    if aBand <> nil then
    begin
      Inc(aBndStackTop);
      aBndStack[aBndStackTop] := aBand;
    end;
  end;

  procedure _ShowStack;
  var
    i: Integer;
  begin
    try
      for i := 1 to aBndStackTop do
      begin
        ShowBand(aBndStack[i]);
      end;
    finally
      aBndStackTop := 0;
    end;
  end;

  procedure _PrintDataHeaderBand(aDataBand: TRMBand);
  begin
    _ShowStack;
    if (aDataBand.FHeaderBand = nil) or (not aDataBand.FHeaderBand.ReprintOnNewPage) then
      Exit;

    try
      aDataBand.FHeaderBand.FDisableBandScript := True;
      aDataBand.FHeaderBand.FCurrentColumn := 1;
      TRMReportPage(aDataBand.FParentPage).ShowBand(aDataBand.FHeaderBand);
    finally
      aDataBand.FHeaderBand.FDisableBandScript := False;
    end;
  end;

  procedure _GetBands;
  var
    i: Integer;
    lBand: TRMBand;
  begin
    lBandList := TList.Create;
    for i := 0 to FBands[aBandType].Count - 1 do
    begin
      lBand := FBands[aBandType][i];
      if lBand.FLevel = aNowLevel then
        lBandList.Add(lBand);
    end;
  end;

  procedure _InitGroups(aGroupBand: TRMBand);
  begin
    lDataBand.FNowGroupBand := aGroupBand;
    while aGroupBand <> nil do
    begin
      Inc(aGroupBand.FPositions[rmpsLocal]);
      Inc(aGroupBand.FPositions[rmpsGlobal]);
      aGroupBand.FCurrentColumn := 1;
      _AddToStack(aGroupBand);
      aGroupBand := aGroupBand.FNextGroup;
    end;
  end;

  procedure _PrintGroups; // 处理分组
  var
    lTmpBand: TRMBand;
  begin
    lGroupBand := lDataBand.FFirstGroup;
    while lGroupBand <> nil do // 分组
    begin
      if lDataBand.Dataset.Eof or VarIsEmpty(lGroupBand.FLastGroupValue) or
        (FParentReport.Parser.CalcOPZ(lGroupBand.FGroupCondition) <> lGroupBand.FLastGroupValue) then
      begin
        lGroupBand.FNowLine := 0;
        lHaveGroup := True;
        if not FParentReport.FinalPass then // WHF Add,计算字段
          DoGroupHeaderAggrs(lGroupBand);

        if lDataBand.AutoAppendBlank then //WHF Add,自动填充空行
        begin
          if lGroupBand.FFooterBand <> nil then
            lHeight := lGroupBand.FFooterBand.FmmHeight
          else
            lHeight := 0;

          if lDataBand.DataSet.Eof then
          begin
            if lDataBand.FFooterBand <> nil then
              lHeight := lHeight + lDataBand.FFooterBand.CalcBandHeight {FmmHeight};
          end;

          lTmpBand := lDataBand.FLastGroup;
          while lTmpBand <> lGroupBand do
          begin
            if lTmpBand.FFooterBand <> nil then
              lHeight := lHeight + lTmpBand.FFooterBand.FmmHeight;
            lTmpBand := lTmpBand.FPrevGroup;
          end;
          _DrawBlank(lDataBand, True, lHeight, FParentReport.Flag_TableEmpty, True);
        end;

        if not lDataBand.Dataset.Eof then
          lDataBand.DataSet.Prior;

        lTmpBand := lDataBand.FLastGroup;
        while lTmpBand <> lGroupBand do
        begin
          _AddToStack(lTmpBand.FFooterBand);
          ResetPosition(lTmpBand, 0);
          if lTmpBand.FFooterBand <> nil then
            ResetPosition(lTmpBand.FFooterBand, 0);
          lTmpBand := lTmpBand.FPrevGroup;
        end;
        _AddToStack(lGroupBand.FFooterBand);
        _ShowStack;

        if not lDataBand.DataSet.Eof then
        begin
          lDataBand.DataSet.Next;
          if lGroupBand.NewPageAfter { and lGroupBand.Visible} then
          begin
            NewPage;
          end;

          _InitGroups(lGroupBand);
          //_PrintDataHeaderBand(lDataBand);  // 不用重新打印数据标头栏啊
          ResetPosition(lDataBand, 0);
          lDataBand.FNowLine := 0;
        end;

        Break;
      end;

      lGroupBand := lGroupBand.FNextGroup; // 下一个分组栏
    end; // 分组
  end;

  procedure _PrintOneDataBand; // 打印一个DataBand
  var
    lHaveDetailBand: Boolean;
    lDataSetEmptyFlag: Boolean;
    lExprResult: Variant;

    function _HaveDetailBand: Boolean;
    var
      i: Integer;
      t: TRMBand;
    begin
      Result := False;
      for i := 0 to FBands[rmbtDetailData].Count - 1 do
      begin
        t := FBands[rmbtDetailData][i];
        if (t.FLevel = aNowLevel + 1) and (t.FMasterDataBand = lDataBand) then
        begin
          Result := True;
          Break;
        end;
      end;
    end;

  begin
    lHaveGroup := False;
    lDataSetEmptyFlag := True;
    _InitGroups(lDataBand.FFirstGroup);
    if lDataBand.FHeaderBand <> nil then
    begin
      lDataBand.FHeaderBand.FCurrentColumn := 1;
      _AddToStack(lDataBand.FHeaderBand);
    end;

    if lDataBand.FFooterBand <> nil then
      lDataBand.FFooterBand.InitValues;

    lHaveDetailBand := _HaveDetailBand;
    while (not lDataBand.DataSet.Eof) and (not FParentReport.MasterReport.Terminated) do
    begin
      Application.ProcessMessages;
      if lDataBand.PrintCondition <> '' then // 只打印符合条件的记录
      begin
        lExprResult := FParentReport.Parser.CalcOPZ(lDataBand.PrintCondition);
        if (lExprResult <> Null) and (not lExprResult) then
        begin
          lDataBand.DataSet.Next;
          Continue;
        end;
      end;

      lDataSetEmptyFlag := False;
      if lDataBand.PrintIfSubsetEmpty and (aNowLevel < FMaxLevel) then
      begin
        _AddToStack(lDataBand);
        _ShowStack;
      end
      else
        _AddToStack(lDataBand);

      lPrintedFlag := True;
      if (aNowLevel < FMaxLevel) and lHaveDetailBand then // 处理子表
      begin
        DoPrintPage(lDataBand, rmbtDetailData, aNowLevel + 1, aBndStackTop, aBndStack);
        DoDetailHeaderAggrs(lDataBand); // 计算MasterData Band
        if aBndStackTop > 0 then
        begin
          if lDataBand.PrintIfSubsetEmpty then
            _ShowStack
          else
          begin
            Dec(aBndStackTop);
            lPrintedFlag := False;
          end;
        end;

        FNowOutlineLevel := FBaseOutlineLevel + aNowLevel - 1;
      end
      else // 没有子表了
      begin
        _ShowStack;
      end;

      lDataBand.DataSet.Next;
      _PrintGroups;
      if not lHaveGroup then // 没有组的话
      begin
        if (lDataBand.FNewPageCondition <> '') then // 换页
        begin
          lExprResult := FParentReport.Parser.CalcOPZ(lDataBand.FNewPageCondition);
          if (lExprResult <> Null) and lExprResult then
          begin
            if lDataBand.AutoAppendBlank then //WHF Add,填充空行
              _DrawBlank(lDataBand, True, 0, FParentReport.Flag_TableEmpty, False);
            _ShowStack;
            lDataBand.FNowLine := 0;
            NewPage;
            _PrintDataHeaderBand(lDataBand);
          end;
        end;
      end;

      if lPrintedFlag then
      begin
        Inc(FCurrentPos);
        Inc(lDataBand.FPositions[rmpsGlobal]);
        Inc(lDataBand.FPositions[rmpsLocal]);
        if not lDataBand.DataSet.Eof and lDataBand.NewPageAfter and lDataBand.Visible then
        begin
          NewPage;
          _PrintDataHeaderBand(lDataBand);
        end;
      end;
    end; // while not lDataBand.DataSet.Eof do

    if (aBndStackTop = 0) or lDataSetEmptyFlag then
    begin
      _ShowStack;
      if (not lHaveGroup) and lDataBand.AutoAppendBlank then // 填充空行
      begin
        lHeight := 0;
        if lDataBand.FFooterBand <> nil then
          lHeight := lDataBand.FFooterBand.CalcBandHeight {FmmHeight};
        if (lNowBandIndex = lBandList.Count - 1) and (BandByType(rmbtReportSummary) <> nil) then
          lHeight := lHeight + BandByType(rmbtReportSummary).FmmHeight;
        _DrawBlank(lDataBand, False, lHeight, FParentReport.Flag_TableEmpty, False)
      end;

      if lDataBand.BandType in [rmbtDetailData] then
        DoDetailHeaderAggrs(lDataBand.FHeaderBand);
      ShowBand(lDataBand.FFooterBand);
    end
    else
      Dec(aBndStackTop);
  end;

begin
  FNowOutlineLevel := FBaseOutlineLevel + aNowLevel - 1;
  _GetBands;
  try
    for lNowBandIndex := 0 to lBandList.Count - 1 do
    begin
      if FParentReport.MasterReport.Terminated or FParentReport.MasterReport.ErrorFlag then
        Break;

      if aMasterBand <> nil then
      begin
        lDataBand := lBandList[lNowBandIndex];
        if lDataBand.FMasterDataBand <> aMasterBand then
          Continue;
      end
      else
        lDataBand := lBandList[lNowBandIndex];

      if lDataBand.Dataset = nil then
        Continue;

      lDataBand.DataSet.First;
      lDataBand.FNowLine := 0;
      ResetPosition(lDataBand, 1);
      lDataBand.FPositions[rmpsGlobal] := 1;

      lGroupBand := lDataBand.FFirstGroup;
      while lGroupBand <> nil do
      begin
        lGroupBand.FNowLine := 0;
        ResetPosition(lGroupBand, 0);
        lGroupBand.FPositions[rmpsGlobal] := 0;
        lGroupBand := lGroupBand.FNextGroup;
      end;

      if (not lDataBand.DataSet.Eof) or lDataBand.PrintIfEmpty then
      begin
        lDataBand.FNeedDecKeepPageCount := False;
        if ((aNowLevel > 1) or (lNowBandIndex > 0)) and
          lDataBand.KeepTogether and (not lDataBand.NewPageAfter) then
        begin
          AddKeepPageBand(lDataBand);
          lDataBand.FNeedDecKeepPageCount := True;
        end;
        _PrintOneDataBand;
        if lDataBand.FNeedDecKeepPageCount then
        begin
          DeleteKeepPageBand(lDataBand);
        end;
      end;
    end;
  finally
    lBandList.Free;
  end;
end;

procedure TRMReportPage.PrintPage;
var
  i: Integer;
  liSavePageNo: Integer;
  lBndStackTop: Integer;
  lBndStack: array[1..20] of TRMBand;
  lBand: TRMBand;

  procedure _WriteOutlineText;
  var
    lValue: Variant;
    lNodeCaption: string;
    t: TRMOutlineView;
  begin
    if FOutlineText = '' then Exit;

    lValue := FParentReport.Parser.Calc(FOutlineText);
    if lValue = Null then
      lNodeCaption := '[None]'
    else
      lNodeCaption := string(lValue);

    if FParentPage.FPrintChildTypeSubReportPage then
    begin
      t := TRMOutlineView.Create;
      try
        t.FCaption := lNodeCaption;
        t.FPageNo := FParentReport.MasterReport.FPageNo;
        t.FmmTop := FmmCurrentY;
        t.FLevel := 0;

        t.PlaceOnEndPage(FCurrentEndPages[FParentReport.MasterReport.FPageNo].EndPageStream);
      finally
        t.Free;
      end;
    end
    else
    begin
      FCurrentEndPages.OutLines.Add(lNodeCaption + #1 + // 标题
        IntToStr(FParentReport.MasterReport.FPageNo) + #1 + // 所在页
        IntToStr(RMToScreenPixels(FmmCurrentY, rmutMMThousandths)) + #1 + // 所在行
        IntToStr(0)); // 所在级
    end;

    FBaseOutlineLevel := 1;
  end;

  procedure _GenSubReports;
  var
    lFlag: Boolean;
    lPageNo: Integer;
  begin
    if FSubReports.Count <= 0 then Exit;

    lPageNo := FParentReport.MasterReport.FPageNo;
    lFlag := HaveChildEndPage(lPageNo - FChildPageBegin);
    while lFlag do
    begin
      if lPageNo >= FParentReport.MasterReport.EndPages.Count then
        NewPage;

      TransferChildTypeSubReportViews(lPageNo - FChildPageBegin,
        FParentReport.MasterReport.EndPages[lPageNo],
        FParentReport.MasterReport.EndPages);

      Inc(lPageNo);
      lFlag := HaveChildEndPage(lPageNo - FChildPageBegin);
    end;
  end;

begin
  try
    for i := 0 to FBands[rmbtMasterData].Count - 1 do
    begin
      lBand := FBands[rmbtMasterData][i];
      if (lBand <> nil) and (lBand.DataSet <> nil) then
      begin
        lBand.DataSet.First;
      end;
    end;
  except
  end;

  FBaseOutlineLevel := 0;
  InitKeepPageInfo;
  FDisableRepeatHeader := False;
  PrintChildTypeSubReports; // 先打印子报表

  FChildPageBegin := FParentReport.MasterReport.FPageNo;
  FCurPageColumn := 0;
  if Assigned(FOnActivate) then
    FOnActivate(Self);
  FSavePageNo := FParentReport.MasterReport.FPageNo;
  FDrawRepeatHeader := False;
  FDisableRepeatHeader := False;
  if not FIsSubReportPage then // 不是子报表
  begin
    if FParentReport.MasterReport.FAppendFlag then
    begin
      if FParentReport.MasterReport.FmmPrevY = FParentReport.MasterReport.FmmPrevBottomY then
      begin
        FParentReport.MasterReport.FAppendFlag := False;
      end;
    end;

    FmmCurrentX := 0;
    if FParentReport.MasterReport.FAppendFlag then
      FmmCurrentBottomY := FParentReport.MasterReport.FmmPrevBottomY
    else
      FmmCurrentBottomY := GetCurrentBottomY;
    if not FParentReport.MasterReport.FAppendFlag then
    begin
      //      FParentReport.MasterReport.EndPages.Add(Self);
      FCurrentEndPages.Add(Self);
      FmmCurrentY := 0;
      _WriteOutlineText;
      ShowBand(BandByType(rmbtOverlay));
      ShowBand(BandByType(rmbtNone));
    end
    else
    begin
      FmmCurrentY := FParentReport.MasterReport.FmmPrevY;
      _WriteOutlineText;
    end;
  end
  else
  begin
    if FSubReportView.SubReportType = rmstFixed then
    begin
      FmmCurrentX := 0;
      FmmCurrentY := 0;
    end;

    FmmCurrentBottomY := GetCurrentBottomY;
    _WriteOutlineText;
    ShowBand(BandByType(rmbtOverlay));
    ShowBand(BandByType(rmbtNone));
  end;

  if not Assigned(FParentReport.FOnManualBuild) then
  begin
    ShowBand(BandByType(rmbtReportTitle));
    if (BandByType(rmbtPageHeader) <> nil) and (BandByType(rmbtPageHeader).PrintOnFirstPage) then
      ShowBand(BandByType(rmbtPageHeader));
    FmmLastStaticColumnY := FmmCurrentY;
    ShowBand(BandByType(rmbtColumnHeader));

    lBndStackTop := 0;
    DoPrintPage(nil, rmbtMasterData, 1, lBndStackTop, lBndStack); // 打印本页
  end
  else
  begin
    FParentReport.OnManualBuild(Self);
  end;

  FDisableRepeatHeader := True;
  FLastPrintBand := nil;
  if not Assigned(FParentReport.FOnManualBuild) then
  begin
    lBand := BandByType(rmbtColumnFooter);
    if (lBand <> nil) and lBand.PrintBeforeSummaryBand then
    begin
      ShowBand(BandByType(rmbtReportSummary));
      DrawColumnFooter(True);
    end
    else
    begin
      DrawColumnFooter(True);
      ShowBand(BandByType(rmbtReportSummary));
    end;
  end;

  FDisableRepeatHeader := False;
  FParentReport.MasterReport.FmmPrevY := FmmCurrentY;
  FParentReport.MasterReport.FmmPrevBottomY := FmmCurrentBottomY;
  FmmCurrentX := 0;
  liSavePageNo := FParentReport.MasterReport.FPageNo;
  FParentReport.MasterReport.FWasPF := False;
  if FCurPageColumn > 0 then
    FParentReport.MasterReport.FmmPrevY := FmmCurrentY {BottomMargin};
  FCurPageColumn := 0;
  if not Assigned(FParentReport.FOnManualBuild) then
    DrawPageFooters(True);

  _GenSubReports;

  if Assigned(FParentReport.FOnEndPage) then
    FParentReport.FOnEndPage(FParentReport.MasterReport.FPageNo);
  if Assigned(FOnEndPage) then
    FOnEndPage(FParentReport.MasterReport.FPageNo);

  if (FParentReport.MasterReport <> FParentReport) and Assigned(FParentReport.MasterReport.FOnEndPage) then
    FParentReport.MasterReport.FOnEndPage(FParentReport.MasterReport.FPageNo);
  if (FParentReport.MasterReport <> FParentReport) and Assigned(FOnEndPage) then
    FOnEndPage(FParentReport.MasterReport.FPageNo);

  if not FIsSubReportPage then
    FParentReport.MasterReport.FPageNo := liSavePageNo + 1;
  FLastPrintBand := nil;

  FreeKeepPageInfo;
  // 释放子报表
  for i := 0 to FSubReports.Count - 1 do
  begin
    TRMSubReportView(FSubReports[i]).Page.FreeChildReport;
  end;
end;

procedure TRMReportPage.DoDetailHeaderAggrs(aBand: TRMBand);
var
  i: Integer;
  t: TRMView;
begin
  if (not FParentReport.MasterReport.DoublePass) or FParentReport.FinalPass or
    (aBand = nil) then Exit;

  for i := 0 to aBand.FObjects.Count - 1 do
  begin
    t := TRMView(aBand.FObjects[i]);
    if t is TRMCalcMemoView then
      TRMCalcMemoView(t).AfterPrint(True);
  end;
end;

procedure TRMReportPage.DoGroupHeaderAggrs(aGroupHeader: TRMBand);
var
  i: Integer;
  t: TRMView;
  lBand: TRMBand;
begin
  if (not FParentReport.MasterReport.DoublePass) or FParentReport.FinalPass then Exit;

  lBand := aGroupHeader;
  repeat
    for i := 0 to lBand.FObjects.Count - 1 do
    begin
      t := TRMView(lBand.FObjects[i]);
      if t is TRMCalcMemoView then
        TRMCalcMemoView(t).AfterPrint(True);
    end;
    lBand := lBand.FNextGroup;
  until lBand = nil;
end;

procedure TRMReportPage.DrawColumnFooter(aLastPageFlag: Boolean);

  procedure _DoColumnHeaderAggrs;
  var
    i: Integer;
    t: TRMView;
    lBand: TRMBand;
  begin
    if (not FParentReport.MasterReport.DoublePass) or FParentReport.FinalPass then Exit;

    lBand := BandByType(rmbtColumnFooter);
    if lBand <> nil then
    begin
      for i := 0 to lBand.Objects.Count - 1 do
      begin
        t := TRMView(lBand.Objects[i]);
        if t is TRMCalcMemoView then
          TRMCalcMemoView(t).AfterPrint(True);
      end;
    end;
  end;

begin
  _DoColumnHeaderAggrs;
  ShowBand(BandByType(rmbtColumnFooter));
end;

procedure TRMReportPage.DrawPageFooters(aLastPageFlag: Boolean);

  procedure _DoPageHeaderAggrs;
  var
    i: Integer;
    t: TRMView;
    lBand: TRMBand;
  begin
    if (not FParentReport.MasterReport.DoublePass) or FParentReport.FinalPass then Exit;

    lBand := BandByType(rmbtPageHeader);
    if lBand <> nil then
    begin
      for i := 0 to lBand.FObjects.Count - 1 do
      begin
        t := TRMView(lBand.FObjects[i]);
        if t is TRMCalcMemoView then
          TRMCalcMemoView(t).AfterPrint(True);
      end;
    end;
  end;

  procedure _PrintBand;
  var
    lBand: TRMBand;
  begin
    lBand := BandByType(rmbtPageFooter);
    if lBand = nil then Exit;
    if (FParentReport.MasterReport.FPageNo = 0) and (not lBand.PrintOnFirstPage) then Exit;
    if aLastPageFlag and (not lBand.PrintOnLastPage) then Exit;

    if not (FParentReport.MasterReport.FAppendFlag and FParentReport.MasterReport.FWasPF) then
    begin
      if Assigned(FParentReport.FOnEndPage) then
        FParentReport.FOnEndPage(FParentReport.MasterReport.FPageNo);
      if Assigned(FOnEndPage) then
        FOnEndPage(FParentReport.MasterReport.FPageNo);

      if (FParentReport.MasterReport <> FParentReport) and Assigned(FParentReport.MasterReport.FOnEndPage) then
        FParentReport.MasterReport.FOnEndPage(FParentReport.MasterReport.FPageNo);
      if (FParentReport.MasterReport <> FParentReport) and Assigned(FOnEndPage) then
        FOnEndPage(FParentReport.MasterReport.FPageNo);

      ShowBand(lBand);
    end;
  end;

begin
  FCurPageColumn := 0;
  if Self.IsSubReportPage then
    FmmCurrentX := FmmCurrentX1
  else
    FmmCurrentX := 0;

  _DoPageHeaderAggrs; // 处理CalcMemo
  _PrintBand;

  //  FParentReport.MasterReport.FPageNo := FParentReport.MasterReport.EndPages.Count - 1;
  FParentReport.MasterReport.FPageNo := FCurrentEndPages.Count - 1;
end;

function TRMReportPage.GetCurrentRightX: Integer;
begin
  Result := Round(RMFromScreenPixels(PrinterInfo.PageWidth, rmutMMThousandths))
    - FmmMarginLeft - FmmMarginRight;
end;

function TRMReportPage.GetCurrentBottomY: Integer;
var
  lBand: TRMBand;
begin
  if FIsSubReportPage and (FSubReportView.SubReportType = rmstChild) then
  begin
    with TRMReportPage(FParentPages[FParentPages.Count - 1]) do
    begin
      Result := Round(RMFromScreenPixels(PrinterInfo.PageHeight, rmutMMThousandths))
        - FmmMarginTop - FmmMarginBottom;
      lBand := BandByType(rmbtPageFooter);
      if lBand <> nil then
        Result := Result - lBand.FmmHeight;
    end;
  end
  else
  begin
    Result := Round(RMFromScreenPixels(PrinterInfo.PageHeight, rmutMMThousandths))
      - FmmMarginTop - FmmMarginBottom;
    lBand := BandByType(rmbtPageFooter);
    if lBand <> nil then
      Result := Result - lBand.FmmHeight;
  end;
end;

procedure TRMReportPage.LoadFromStream(aStream: TStream);
var
  lVersion: Word;
begin
  lVersion := RMReadWord(aStream);
  FName := RMReadString(aStream);
  Visible := RMReadBoolean(aStream);

  FPageSize := RMReadInt32(aStream);
  FPageWidth := RMReadInt32(aStream);
  FPageHeight := RMReadInt32(aStream);
  FmmMarginLeft := RMReadInt32(aStream);
  FmmMarginTop := RMReadInt32(aStream);
  FmmMarginRight := RMReadInt32(aStream);
  FmmMarginBottom := RMReadInt32(aStream);
  FPageOrientation := TRMPrinterOrientation(RMReadByte(aStream));
  PrintToPrevPage := RMReadBoolean(aStream);
  FPageBin := RMReadInt32(aStream);
  FResetPageNo := RMReadBoolean(aStream);
  FNewPrintJob := RMReadBoolean(aStream);

  RMLoadPicture(aStream, FbkPicture);
  FmmbkPictureLeft := RMReadInt32(aStream);
  FmmbkPictureTop := RMReadInt32(aStream);
  bkPictureWidth := RMReadInt32(aStream);
  bkPictureHeight := RMReadInt32(aStream);
  FDuplex := TRMDuplex(RMReadByte(aStream));
  if lVersion >= 1 then
  begin
    FAutoVCenter := RMReadBoolean(aStream);
    FAutoHCenter := RMReadBoolean(aStream);
    FFlags := RMReadWord(aStream);
  end
  else
  begin
    FAutoVCenter := False;
    FAutoHCenter := False;
    FFlags := 0;
  end;

  if lVersion >= 2 then
  begin
    ColumnCount := RMReadInt32(aStream);
    mmColumnGap := RMReadInt32(aStream);
    if lVersion >= 3 then
      LoadEventInfo(aStream);
  end
  else
  begin
    ColumnCount := 1;
    mmColumnGap := 0;
  end;

  if lVersion >= 4 then
    FOutlineText := RMReadString(aStream);

  ChangePaper(FPageSize, PageWidth, PageHeight, FPageBin, FPageOrientation);
end;

procedure TRMReportPage.SaveToStream(aStream: TStream);
begin
  RMWriteWord(aStream, 4); // 版本号
  RMWriteString(aStream, Name);
  RMWriteBoolean(aStream, Visible);

  RMWriteInt32(aStream, PageSize);
  RMWriteInt32(aStream, FPageWidth);
  RMWriteInt32(aStream, FPageHeight);
  RMWriteInt32(aStream, FmmMarginLeft);
  RMWriteInt32(aStream, FmmMarginTop);
  RMWriteInt32(aStream, FmmMarginRight);
  RMWriteInt32(aStream, FmmMarginBottom);
  RMWriteByte(aStream, Byte(PageOrientation));
  RMWriteBoolean(aStream, PrintToPrevPage);
  RMWriteInt32(aStream, PageBin);
  RMWriteBoolean(aStream, FResetPageNo);
  RMWriteBoolean(aStream, FNewPrintJob);

  RMWritePicture(aStream, FbkPicture);
  RMWriteInt32(aStream, FmmbkPictureLeft);
  RMWriteInt32(aStream, FmmbkPictureTop);
  RMWriteInt32(aStream, bkPictureWidth);
  RMWriteInt32(aStream, bkPictureHeight);
  RMWriteByte(aStream, Byte(FDuplex));
  RMWriteBoolean(aStream, FAutoVCenter);
  RMWriteBoolean(aStream, FAutoHCenter);
  RMWriteWord(aStream, FFlags);
  RMWriteInt32(aStream, ColumnCount);
  RMWriteInt32(aStream, mmColumnGap);

  SaveEventInfo(aStream);
  RMWriteString(aStream, FOutlineText);
end;

procedure TRMReportPage.ChangePaper(ASize, AWidth, AHeight, ABin: Integer;
  AOr: TRMPrinterOrientation);
begin
  try
    GetPrinter.SetPrinterInfo(ASize, AWidth, AHeight, ABin, AOr, FALSE);
    GetPrinter.FillPrinterInfo(PrinterInfo);
  except
    on exception do
    begin
      GetPrinter.SetPrinterInfo($100, AWidth, AHeight, -1, AOr, FALSE);
      GetPrinter.FillPrinterInfo(PrinterInfo);
    end;
  end;

  FPageOrientation := GetPrinter.Orientation;
  FPageSize := GetPrinter.PaperSize;
  FPageWidth := GetPrinter.PaperWidth;
  FPageHeight := GetPrinter.PaperHeight;
  if (ABin and $FFFF) <> $FFFF then
    FPageBin := GetPrinter.Bin
  else
    FPageBin := $FFFF;
end;

procedure TRMReportPage.ShowBand(aBand: TRMBand);
var
  PrintBand: Boolean;
begin
  if aBand <> nil then
  begin
    FParentReport.InternalOnBeforePrintBand(aBand, PrintBand);
    if PrintBand then
      aBand.Print;
  end;
end;

function TRMReportPage.BandByType(aType: TRMBandType): TRMBand;
begin
  if FBands[aType].Count > 0 then
    Result := TRMBand(FBands[aType][0])
  else
    Result := nil;
end;

procedure TRMReportPage.SetbkPicture(aPicture: TPicture);
var
  x, Top: Integer;
begin
  FbkPicture.Assign(aPicture);
  if Assigned(aPicture) and Assigned(aPicture.Graphic) then
  begin
    RMGetBitmapPixels(aPicture.Graphic, x, Top);
    bkPictureWidth := Round(aPicture.Graphic.Width * 96 / x);
    bkPictureHeight := Round(aPicture.Graphic.Height * 96 / Top);
  end;
end;

function TRMReportPage.GetpgMargins: TRect;
begin
  Result := Rect(Round(RMFromMMThousandths(FmmMarginLeft, rmutScreenPixels)),
    Round(RMFromMMThousandths(FmmMarginTop, rmutScreenPixels)),
    Round(RMFromMMThousandths(FmmMarginRight, rmutScreenPixels)),
    Round(RMFromMMThousandths(FmmMarginBottom, rmutScreenPixels)));
end;

procedure TRMReportPage.SetpgMargins(aValue: TRect);
var
  t: TRMView;
  i: Integer;
  liMargins: TRect;
begin
  liMargins := PageMargins;
  if (aValue.Left <> liMargins.Left) or (aValue.Top <> liMargins.Top) then
  begin
    for i := 0 to FObjects.Count - 1 do
    begin
      t := TRMView(FObjects[i]);
      if not FIsSubReportPage then
        t.Left := (aValue.Left - liMargins.Left) + t.Left;
      t.Top := (aValue.Top - liMargins.Top) + t.Top;
    end;
  end;

  FmmMarginLeft := RMToMMThousandths(aValue.Left, rmutScreenPixels);
  FmmMarginTop := RMToMMThousandths(aValue.Top, rmutScreenPixels);
  FmmMarginRight := RMToMMThousandths(aValue.Right, rmutScreenPixels);
  FmmMarginBottom := RMToMMThousandths(aValue.Bottom, rmutScreenPixels);
end;

procedure TRMReportPage.SetmmMarginLeft(aValue: Integer);
begin
  if FmmMarginLeft <> aValue then
  begin
    FmmMarginLeft := aValue;
  end;
end;

procedure TRMReportPage.SetmmMarginTop(aValue: Integer);
begin
  if FmmMarginTop <> aValue then
  begin
    FmmMarginTop := aValue;
  end;
end;

function TRMReportPage.GetspMarginLeft(index: Integer): Integer;
begin
  case index of
    0: Result := RMToScreenPixels(FmmMarginLeft, rmutMMThousandths);
    1: Result := RMToScreenPixels(FmmMarginTop, rmutMMThousandths);
    2: Result := RMToScreenPixels(FmmMarginRight, rmutMMThousandths);
    3: Result := RMToScreenPixels(FmmMarginBottom, rmutMMThousandths);
    4: Result := RMToScreenPixels(FmmbkPictureLeft, rmutMMThousandths);
    5: Result := RMToScreenPixels(FmmbkPictureTop, rmutMMThousandths);
    6: Result := RMToScreenPixels(FmmColumnGap, rmutMMThousandths);
  else
    Result := 0;
  end;
end;

procedure TRMReportPage.SetspMarginLeft(index: Integer; value: Integer);
begin
  case index of
    0: mmMarginLeft := RMToMMThousandths(Value, rmutScreenPixels);
    1: mmMarginTop := RMToMMThousandths(Value, rmutScreenPixels);
    2: mmMarginRight := RMToMMThousandths(Value, rmutScreenPixels);
    3: mmMarginBottom := RMToMMThousandths(Value, rmutScreenPixels);
    4: FmmbkPictureLeft := RMToMMThousandths(Value, rmutScreenPixels);
    5: FmmbkPictureTop := RMToMMThousandths(Value, rmutScreenPixels);
    6: FmmColumnGap := RMToMMThousandths(Value, rmutScreenPixels);
  end;
end;

function TRMReportPage.GetbkGroundLeft(index: Integer): Double;
begin
  case index of
    0: Result := RMFromMMThousandths(FmmbkPictureLeft, RMUnits);
    1: Result := RMFromMMThousandths(FmmbkPictureTop, RMUnits);
  else
    Result := 0;
  end;
end;

procedure TRMReportPage.SetbkGroundLeft(index: Integer; Value: Double);
begin
  case index of
    0: FmmbkPictureLeft := RMToMMThousandths(Value, RMUnits);
    1: FmmbkPictureTop := RMToMMThousandths(Value, RMUnits);
  end;
end;

procedure TRMReportPage.SetColumnCount(Value: Integer);
begin
  if Value >= 1 then
    FColumnCount := Value;
end;

function TRMReportPage.GetColumnGap: Double;
begin
  Result := RMFromMMThousandths(FmmColumnGap, RMUnits);
end;

procedure TRMReportPage.SetColumnGap(Value: Double);
begin
  FmmColumnGap := RMToMMThousandths(Value, RMUnits);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPages }

constructor TRMPages.Create(aParentReport: TRMReport);
begin
  inherited Create;
  FParentReport := aParentReport;
  FPages := TList.Create;
end;

destructor TRMPages.Destroy;
begin
  Clear;
  FPages.Free;
  inherited Destroy;
end;

procedure TRMPages.Clear;
begin
  while FPages.Count > 0 do
  begin
    TRMCustomPage(FPages[0]).Free;
    FPages.Delete(0);
  end;
end;

function TRMPages.GetCount: Integer;
begin
  Result := FPages.Count;
end;

function TRMPages.GetPages(Index: Integer): TRMCustomPage;
begin
  if (Index >= 0) and (Index < FPages.Count) then
    Result := FPages[Index]
  else
    Result := nil;
end;

function TRMPages.AddDialogPage: TRMDialogPage;
begin
  Result := TRMDialogPage.CreatePage(FParentReport);
  FPages.Add(Result);
end;

function TRMPages.AddReportPage: TRMReportPage;
begin
  with FParentReport.ReportPrinter do
    Result := TRMReportPage.CreatePage(FParentReport, DefaultPaper, DefaultPaperWidth,
      DefaultPaperHeight, $FFFF, Orientation {rmpoPortrait});
  FPages.Add(Result);
end;

procedure TRMPages.Delete(Index: Integer);
begin
  if (Index >= 0) and (Index < FPages.Count) then
  begin
    Pages[Index].Free;
    FPages.Delete(Index);
  end;
end;

procedure TRMPages.Move(OldIndex, NewIndex: Integer);
begin
  FPages.Move(OldIndex, NewIndex);
end;

procedure TRMPages.LoadFromStream(aVersion: Integer; aStream: TStream);
var
  b: Byte;
  liPos: Integer;
  t: TRMView;
  s: string;
  i, j: Integer;
  liPage: TRMCustomPage;

  procedure _AddObject(aTyp: Byte; const aClassName: string);
  begin
    b := RMReadByte(aStream);
    FParentReport.FCurrentPage := Pages[b];
    t := RMCreateObjectWidthErrorMsg(aTyp, aClassName, FParentReport.ErrorFlag,
      FParentReport.ErrorMsg);
    if t <> nil then
    begin
      t.StreamMode := rmsmDesigning;
      t.NeedCreateName := False;
      t.ParentPage := FParentReport.FCurrentPage;
    end;
  end;

begin
  Clear;
  while aStream.Position < aStream.Size do
  begin
    b := RMReadByte(aStream);
    case b of
      $FF: // page info
        begin
          if aVersion <= 50 then
          begin
            b := RMReadByte(aStream);
            if b = 0 then
              liPage := AddDialogPage
            else
              liPage := AddReportPage;
          end
          else
          begin
            s := RMReadString(aStream);
            liPage := RMCreatePage(FParentReport, s);
            FPages.Add(liPage);
          end;
          liPage.LoadFromStream(aStream);
        end;
      $FE: // 数据字典
        begin
          FParentReport.Dictionary.LoadFromStream(aStream);
        end;
    else // 对象
      if b > Integer(rmgtAddIn) then
      begin
        raise Exception.Create('');
        Break;
      end;
      liPos := 0;
      try
        s := RMReadString(aStream);
        liPos := RMReadInt32(aStream);
        _AddObject(b, s);
        if t <> nil then
        begin
          try
            t.LoadFromStream(aStream);
          finally
            if liPos <> 0 then aStream.Position := liPos;
          end;
        end;
      except
        if liPos <> 0 then // 出错
          aStream.Position := liPos;
      end;
    end;
  end;

  if FParentReport.ErrorFlag then
    raise EClassNotFound.Create(FParentReport.ErrorMsg)
  else
  begin
    for i := 0 to Count - 1 do
    begin
      Pages[i].Loaded;
      for j := 0 to Pages[i].Objects.Count - 1 do
      begin
        t := Pages[i].Objects[j];
        if t.Typ = rmgtSubReport then
        begin
          if TRMSubReportView(t).SubPage < Count then
            Pages[TRMSubReportView(t).SubPage].FIsSubReportPage := True;
        end;
        t.AfterChangeName;
        t.Loaded;
      end;
    end;
  end;
end;

procedure TRMPages.SaveToStream(aStream: TStream);
var
  i, j: Integer;
  t: TRMView;
  liPos, liSavePos: Integer;
  liPage: TRMCustomPage;
begin
  for i := 0 to Count - 1 do // adding pages at first
  begin
    RMWriteByte(aStream, $FF);
    RMWriteString(aStream, Pages[i].ClassName);
    Pages[i].SaveToStream(aStream);
  end;

  for i := 0 to FPages.Count - 1 do
  begin
    liPage := FPages[i];
    for j := 0 to liPage.FObjects.Count - 1 do // then adding objects
    begin
      t := liPage.FObjects[j];
      t.StreamMode := rmsmDesigning;
      RMWriteByte(aStream, t.Typ);
      RMWriteString(aStream, t.ClassName);
      liPos := aStream.Position;
      RMWriteInt32(aStream, i);

      RMWriteByte(aStream, i); // 所在页
      t.SaveToStream(aStream);

      liSavePos := aStream.Position;
      aStream.Position := liPos;
      RMWriteInt32(aStream, liSavePos);
      aStream.Seek(0, soFromEnd);
    end;
  end;

  RMWriteByte(aStream, $FE);
  FParentReport.Dictionary.SaveToStream(aStream);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMbkPicture}

constructor TRMbkPicture.Create(aLeft, aTop, aWidth, aHeight: Integer; aPic: TPicture);
begin
  inherited Create;
  FLeft := aLeft;
  FTop := aTop;
  FWidth := aWidth;
  FHeight := aHeight;
  FPicture := TPicture.Create;
  FPicture.Assign(aPic);
end;

destructor TRMbkPicture.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMSaveReportOptions }

constructor TRMSaveReportOptions.Create;
begin
  inherited Create;
  FAutoLoadSaveSetting := False;
  FUseRegistry := True;
  FRegistryPath := 'ReportMachine\ReportSettings\';
end;

procedure TRMSaveReportOptions.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TRMSaveReportOptions then
  begin
    FAutoLoadSaveSetting := TRMSaveReportOptions(Source).AutoLoadSaveSetting;
    FUseRegistry := TRMSaveReportOptions(Source).UseRegistry;
    FIniFileName := TRMSaveReportOptions(Source).IniFileName;
    FRegistryPath := TRMSaveReportOptions(Source).RegistryPath;
  end;
end;

procedure TRMSaveReportOptions.LoadReportSetting(aReport: TRMReport; aReportName: string);
var
  liIniFile: TIniFile;
  liRegIniFile: TRegIniFile;
  i, liPageCount: Integer;

  {$IFNDEF Delphi4}
  function _SectionExists(const aStr: string): Boolean;
  var
    lstr: TStringList;
  begin
    lstr := TStringList.Create;
    try
      liIniFile.ReadSections(lstr);
      Result := lStr.IndexOf(aStr) >= 0;
    finally
      lstr.Free;
    end;
  end;
  {$ENDIF}

begin
  if Assigned(aReport.FOnLoadReportSetting) then
  begin
    aReport.FOnLoadReportSetting(aReport);
    Exit;
  end;
  if not FAutoLoadSaveSetting then Exit;
  if aReportName = '' then
  begin
    if aReport.ReportInfo.Title <> '' then
      aReportName := aReport.ReportInfo.Title
    else if aReport.FileName <> '' then
      aReportName := ExtractFileName(aReport.FileName);
  end;
  if aReportName = '' then Exit;

  if FuseRegistry then
  begin
    liRegIniFile := TRegIniFile.Create(FRegistryPath);
    try
      if liRegIniFile.KeyExists(aReportName) then
      begin
        aReport.PrintBackGroundPicture := liRegIniFile.ReadBool(aReportName, 'taoda', aReport.PrintBackGroundPicture);
        aReport.PrintOffsetTop := liRegIniFile.ReadInteger(aReportName, 'mmPrintOffsetTop', 0);
        aReport.PrintOffsetLeft := liRegIniFile.ReadInteger(aReportName, 'mmPrintOffsetLeft', 0);
        aReport.ColorPrint := liRegIniFile.ReadBool(aReportName, 'ColorPrint', aReport.ColorPrint);
        aReport.DoublePass := liRegIniFile.ReadBool(aReportName, 'DoublePass', aReport.DoublePass);

        liPageCount := liRegIniFile.ReadInteger(aReportName, 'PageCount', -1);
        if liPageCount > aReport.Pages.Count - 1 then
          liPageCount := aReport.Pages.Count - 1;
        for i := 0 to liPageCount do
        begin
          if aReport.Pages[i] is TRMDialogPage then Continue;
          TRMReportPage(aReport.Pages[i]).mmMarginLeft := liRegIniFile.ReadInteger(aReportName, 'Page_' + IntToStr(i) + '_LeftMargin', 0);
          TRMReportPage(aReport.Pages[i]).mmMarginTop := liRegIniFile.ReadInteger(aReportName, 'Page_' + IntToStr(i) + '_TopMargin', 0);
          TRMReportPage(aReport.Pages[i]).mmMarginRight := liRegIniFile.ReadInteger(aReportName, 'Page_' + IntToStr(i) + '_RightMargin', 0);
          TRMReportPage(aReport.Pages[i]).mmMarginBottom := liRegIniFile.ReadInteger(aReportName, 'Page_' + IntToStr(i) + '_BottomMargin', 0);
        end;
      end;
    finally
      liRegIniFile.Free;
    end;
  end
  else
  begin
    liIniFile := TIniFile.Create(FIniFileName);
    try
      {$IFNDEF Delphi4}
      if _SectionExists(aReportName) then
        {$ELSE}
      if liIniFile.SectionExists(aReportName) then
        {$ENDIF}
      begin
        aReport.PrintBackGroundPicture := liIniFile.ReadBool(aReportName, 'taoda', aReport.PrintBackGroundPicture);
        aReport.PrintOffsetTop := liIniFile.ReadInteger(aReportName, 'mmPrintOffsetTop', 0);
        aReport.PrintOffsetLeft := liIniFile.ReadInteger(aReportName, 'mmPrintOffsetLeft', 0);
        aReport.ColorPrint := liIniFile.ReadBool(aReportName, 'ColorPrint', aReport.ColorPrint);
        aReport.DoublePass := liIniFile.ReadBool(aReportName, 'DoublePass', aReport.DoublePass);

        liPageCount := liIniFile.ReadInteger(aReportName, 'PageCount', -1);
        if liPageCount > aReport.Pages.Count - 1 then
          liPageCount := aReport.Pages.Count - 1;
        for i := 0 to liPageCount do
        begin
          if aReport.Pages[i] is TRMDialogPage then Continue;
          TRMReportPage(aReport.Pages[i]).mmMarginLeft := liIniFile.ReadInteger(aReportName, 'Page_' + IntToStr(i) + '_LeftMargin', 0);
          TRMReportPage(aReport.Pages[i]).mmMarginTop := liIniFile.ReadInteger(aReportName, 'Page_' + IntToStr(i) + '_TopMargin', 0);
          TRMReportPage(aReport.Pages[i]).mmMarginRight := liIniFile.ReadInteger(aReportName, 'Page_' + IntToStr(i) + '_RightMargin', 0);
          TRMReportPage(aReport.Pages[i]).mmMarginBottom := liIniFile.ReadInteger(aReportName, 'Page_' + IntToStr(i) + '_BottomMargin', 0);
        end;
      end;
    finally
      liIniFile.Free;
    end;
  end;
end;

procedure TRMSaveReportOptions.SaveReportSetting(aReport: TRMReport; aReportName: string);
var
  liIniFile: TIniFile;
  liRegIniFile: TRegIniFile;
  i: Integer;
begin
  if Assigned(aReport.FOnSaveReportSetting) then
  begin
    aReport.FOnSaveReportSetting(aReport);
    Exit;
  end;
  if not FAutoLoadSaveSetting then
    Exit;
  if aReportName = '' then
  begin
    if aReport.ReportInfo.Title <> '' then
      aReportName := aReport.ReportInfo.Title
    else if aReport.FileName <> '' then
      aReportName := ExtractFileName(aReport.FileName);
  end;
  if aReportName = '' then
    Exit;

  if FuseRegistry then
  begin
    liRegIniFile := TRegIniFile.Create(FRegistryPath);
    try
      liRegIniFile.WriteBool(aReportName, 'taoda', aReport.PrintBackGroundPicture);
      liRegIniFile.WriteInteger(aReportName, 'mmPrintOffsetTop', aReport.PrintOffsetTop);
      liRegIniFile.WriteInteger(aReportName, 'mmPrintOffsetLeft', aReport.PrintOffsetLeft);
      liRegIniFile.WriteBool(aReportName, 'ColorPrint', aReport.ColorPrint);
      liRegIniFile.WriteBool(aReportName, 'DoublePass', aReport.DoublePass);
      liRegIniFile.WriteBool(aReportName, 'NewFlag', True);

      liRegIniFile.WriteInteger(aReportName, 'PageCount', aReport.Pages.Count);
      for i := 0 to FParentReport.Pages.Count - 1 do
      begin
        if aReport.Pages[i] is TRMDialogPage then Continue;
        liRegIniFile.WriteInteger(aReportName, 'Page_' + IntToStr(i) + '_LeftMargin', TRMReportPage(aReport.Pages[i]).mmMarginLeft);
        liRegIniFile.WriteInteger(aReportName, 'Page_' + IntToStr(i) + '_TopMargin', TRMReportPage(aReport.Pages[i]).mmMarginTop);
        liRegIniFile.WriteInteger(aReportName, 'Page_' + IntToStr(i) + '_RightMargin', TRMReportPage(aReport.Pages[i]).mmMarginRight);
        liRegIniFile.WriteInteger(aReportName, 'Page_' + IntToStr(i) + '_BottomMargin', TRMReportPage(aReport.Pages[i]).mmMarginBottom);
      end;
    finally
      liRegIniFile.Free;
    end;
  end
  else
  begin
    liIniFile := TIniFile.Create(FIniFileName);
    try
      liIniFile.WriteBool(aReportName, 'taoda', aReport.PrintBackGroundPicture);
      liIniFile.WriteInteger(aReportName, 'mmPrintOffsetTop', aReport.PrintOffsetTop);
      liIniFile.WriteInteger(aReportName, 'mmPrintOffsetLeft', aReport.PrintOffsetLeft);
      liIniFile.WriteBool(aReportName, 'ColorPrint', aReport.ColorPrint);
      liIniFile.WriteBool(aReportName, 'DoublePass', aReport.DoublePass);
      liIniFile.WriteBool(aReportName, 'NewFlag', True);

      liIniFile.WriteInteger(aReportName, 'PageCount', aReport.Pages.Count);
      for i := 0 to FParentReport.Pages.Count - 1 do
      begin
        if aReport.Pages[i] is TRMDialogPage then Continue;
        liIniFile.WriteInteger(aReportName, 'Page_' + IntToStr(i) + '_LeftMargin', TRMReportPage(aReport.Pages[i]).mmMarginLeft);
        liIniFile.WriteInteger(aReportName, 'Page_' + IntToStr(i) + '_TopMargin', TRMReportPage(aReport.Pages[i]).mmMarginTop);
        liIniFile.WriteInteger(aReportName, 'Page_' + IntToStr(i) + '_RightMargin', TRMReportPage(aReport.Pages[i]).mmMarginRight);
        liIniFile.WriteInteger(aReportName, 'Page_' + IntToStr(i) + '_BottomMargin', TRMReportPage(aReport.Pages[i]).mmMarginBottom);
      end;
    finally
      liIniFile.Free;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMFieldFieldNames }

constructor TRMFieldFieldNames.Create;
begin
  inherited Create;
  FDataSet := nil;
  FTableName := 'TableName';
  FFieldName := 'FieldName';
  FFieldAlias := 'FieldAlias';
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDataDictionary }

constructor TRMDataDictionary.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFieldFieldNames := TRMFieldFieldNames.Create;
end;

destructor TRMDataDictionary.Destroy;
begin
  FFieldFieldNames.Free;
  inherited Destroy;
end;

procedure TRMDataDictionary.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if aComponent = FFieldFieldNames.FDataSet then
      FFieldFieldNames.FDataSet := nil;
  end;
end;

function TRMDataDictionary.GetRealFieldName(const aKey, aFieldName: string; var RealName: string): Boolean;
begin
  Result := False;
  if Assigned(FieldFieldNames) then
  begin
    with FieldFieldNames do
    begin
      if DataSet <> nil then
      begin
        if DataSet.Locate(Format('%s;%s', [TableName, FieldAlias]),
          VarArrayOf([aKey, aFieldName]), [loCaseInsensitive]) then
        begin
          RealName := DataSet.FieldByName(FieldName).AsString;
          Result := True;
        end;
      end;
    end;
  end;
end;

procedure TRMDataDictionary.GetVirtualFieldsName(const aKey: string; aList: TStrings);
var
  i: Integer;
begin
  with FFieldFieldNames do
  begin
    if DataSet <> nil then
    begin
      if not DataSet.Active then DataSet.Open;

      for i := 0 to aList.Count - 1 do
      begin
        if DataSet.Locate(Format('%s;%s', [TableName, FieldName]),
          VarArrayOf([aKey, aList[i]]), []) then
          aList[i] := DataSet.FieldByName(FieldAlias).AsString;
      end;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMDictory}

constructor TRMDictionary.Create(aParentReport: TRMReport);
begin
  inherited Create;
  FParentReport := aParentReport;

  FVariables := TRMVariables.Create;
  FFieldAliases := TRMVariables.Create;
  FDisabledDatasets := TStringList.Create;

  FCache := TStringList.Create;
  FExprCache := TStringList.Create;
end;

destructor TRMDictionary.Destroy;
begin
  ClearCache;
  FCache.Free;
  FExprCache.Free;

  FVariables.Free;
  FFieldAliases.Free;
  FDisabledDatasets.Free;
  inherited Destroy;
end;

procedure TRMDictionary.Clear;
begin
  FVariables.Clear;
  FFieldAliases.Clear;
  ClearCache;
end;

procedure TRMDictionary.Pack1(var aFieldAlias: TRMVariables);
var
  i, lCount: Integer;
  lStr, lFieldName: string;
  lDataSet: TRMDataSet;

  function _RealFieldName(const aDataSetName, aFieldName: string): string;
  var
    i: Integer;
    liDataSetName: string;
  begin
    Result := aFieldName;
    for i := 0 to FFieldAliases.Count - 1 do
    begin
      if RMCmp(FFieldAliases.Value[i], aFieldName) and
        (Pos(aDataSetName, UpperCase(FFieldAliases.Name[i])) = 1) then // WHF Modify
      begin
        Result := FFieldAliases.Name[i];
        ExtractFieldName(Result, liDataSetName, Result);
        Exit;
      end;
    end;
  end;

begin
  lCount := aFieldAlias.Count;
  for i := lCount - 1 downto 0 do
  begin
    if aFieldAlias.Value[i] = '' then // 数据集
    begin
      lStr := aFieldAlias.Name[i] + '."aa"';
      lDataSet := nil;
      RMGetDatasetAndField(FParentReport, lStr, lDataSet, lFieldName);
      if lDataSet = nil then
      begin
        aFieldAlias.Delete(i);
      end;
    end
    else // 字段
    begin
      lStr := aFieldAlias.Name[i];
      if Pos('.', lStr) <> 0 then
      begin
        lDataSet := nil;
        RMGetDatasetAndField(FParentReport, lStr, lDataSet, lFieldName);
        if (lDataSet = nil) or (lFieldName = '') then
        begin
          aFieldAlias.Delete(i);
        end;
      end;
    end;
  end;
end;

procedure TRMDictionary.Pack;
begin
  Pack1(FFieldAliases);
end;

procedure TRMDictionary.ClearCache;
var
  p: PRMCacheItem;
begin
  while FCache.Count > 0 do
  begin
    p := PRMCacheItem(FCache.Objects[0]);
    Dispose(p);
    FCache.Delete(0);
  end;

  while FExprCache.Count > 0 do
  begin
    p := PRMCacheItem(FExprCache.Objects[0]);
    Dispose(p);
    FExprCache.Delete(0);
  end;
end;

procedure TRMDictionary.AddCacheItem(const Index: string; aDataSet: TRMDataSet;
  const aDataField: string);
var
  p: PRMCacheItem;
begin
  New(p);
  p^.DataSet := aDataSet;
  p^.DataFieldName := aDataField;
  FCache.AddObject(Index, TObject(p));
end;

procedure TRMDictionary.AddExprCacheItem(const Index: string; const aExpr: string);
var
  p: PRMCacheItem;
begin
  New(p);
  p^.DataSet := nil;
  p^.DataFieldName := aExpr;

  FExprCache.AddObject(Index, TObject(p));
  FExprCache.Sort;
end;

const
  DICTIONARYFILEMSE = 'ReportMachine Dictionary File 30' + #26;

procedure TRMDictionary.LoadFromStream_1(aStream: TStream);
var
  lVersion: Integer;

  procedure _LoadRMVariables(aVars: TRMVariables);
  var
    i, lCount: Integer;
    lVarName: string;
    lValue: Variant;
    lVarType: Word;
  begin
    lCount := RMReadInt32(aStream);
    for i := 0 to lCount - 1 do
    begin
      lVarName := RMReadString(aStream);
      if lVersion >= 61 then
      begin
        lVarType := RMReadWord(aStream);
        lValue := RMReadString(aStream);
        case lVarType of
          varDate: lValue := TDateTime(lValue);
          varDouble: lValue := Extended(lValue);
          varSingle: lValue := Single(lValue);
          varCurrency: lValue := Currency(lValue);
        end;
      end
      else
        lValue := RMReadString(aStream);

      aVars[lVarName] := lValue;
    end;
  end;

begin
  lVersion := RMReadWord(aStream); // 版本
  if RMReadString(aStream) <> DICTIONARYFILEMSE then
  begin
    Application.MessageBox(PChar(RMLoadStr(SNotRMDFile)), PChar(RMLoadStr(SError)),
      mb_Ok + mb_IconError);
    Exit;
  end;

  _LoadRMVariables(FVariables);
  _LoadRMVariables(FFieldAliases);
end;

procedure TRMDictionary.LoadFromStream(aStream: TStream);
begin
  Clear;
  LoadFromStream_1(aStream);
end;

procedure TRMDictionary.SaveToStream(aStream: TStream);

  procedure SaveRMVariables(aVars: TRMVariables);
  var
    i, lCount: Integer;
    lVarType: Word;
    lValue: Variant;
  begin
    lCount := aVars.Count;
    RMWriteInt32(aStream, lCount);
    for i := 0 to lCount - 1 do
    begin
      RMWriteString(aStream, aVars.Name[i]);

      lValue := aVars.Value[i];
      lVarType := TVarData(lValue).VType;
      RMWriteWord(aStream, lVarType);
      case lVarType of
        varDate: lValue := Double(lValue);
      end;

      RMWriteString(aStream, lValue);
    end;
  end;

begin
  RMWriteWord(aStream, RMCurrentVersion);
  RMWriteString(aStream, DICTIONARYFILEMSE);
  SaveRMVariables(FVariables);
  SaveRMVariables(FFieldAliases);
end;

procedure TRMDictionary.LoadFromFile(aFileName: string);
var
  liStream: TFileStream;
begin
  if aFileName = '' then Exit;
  if ExtractFileExt(aFileName) = '' then
    aFileName := aFileName + '.rmd';
  if not FileExists(aFileName) then Exit;

  liStream := TFileStream.Create(aFileName, fmOpenRead);
  try
    LoadFromStream(liStream);
  finally
    liStream.Free;
  end;
end;

procedure TRMDictionary.SaveToFile(aFileName: string);
var
  liStream: TFileStream;
begin
  if ExtractFileExt(aFileName) = '' then
    aFileName := aFileName + '.rmd';

  liStream := TFileStream.Create(aFileName, fmCreate);
  try
    SaveToStream(liStream);
  finally
    liStream.Free;
  end;
end;

procedure TRMDictionary.SaveToBlobField(aBlobField: TBlobField);
var
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    SaveToStream(lStream);
    lStream.Position := 0;
    aBlobField.LoadFromStream(lStream);
  finally
    lStream.Free;
  end;
end;

procedure TRMDictionary.LoadFromBlobField(aBlobField: TBlobField);
var
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    aBlobField.SaveToStream(lStream);
    lStream.Position := 0;
    LoadFromStream(lStream);
  finally
    lStream.Free;
  end;
end;

procedure TRMDictionary.MergeFromFile(aFileName: string);
var
  Stream: TFileStream;
begin
  if aFileName = '' then Exit;
  if (not FileExists(aFileName)) and (ExtractFileExt(aFileName) = '') then
    aFileName := aFileName + '.rmd';
  if not FileExists(aFileName) then Exit;

  Stream := TFileStream.Create(aFileName, fmOpenRead);
  try
    MergeFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TRMDictionary.MergeFromStream(aStream: TStream);
begin
  LoadFromStream_1(aStream);
end;

procedure TRMDictionary.ExtractFieldName(const aComplexName: string; var aDataSetName, aFieldName: string);
var
  i: Integer;
  fl: Boolean;
begin
  fl := False;
  for i := Length(aComplexName) downto 1 do
  begin
    if aComplexName[i] = '"' then
      fl := not fl;
    if (aComplexName[i] = '.') and (not fl) then
    begin
      aDataSetName := Copy(aComplexName, 1, i - 1);
      aFieldName := RMRemoveQuotes(Copy(aComplexName, i + 1, 255));
      Break;
    end;
  end;
end;

function TRMDictionary.IsVariable(const aVariableName: string): Boolean;
var
  i, lIndex: Integer;
  s: string;
  lDataSetName, lFieldName: string;
  lDataSet: TRMDataSet;
  lValue: Variant;

  function _RealFieldName(const aDataSetName, aFieldName: string; var aIndex: Integer): string;
  var
    i: Integer;
    lDataSetName: string;
  begin
    Result := aFieldName;
    if aFieldName = '' then Exit;

    for i := 0 to FFieldAliases.Count - 1 do
    begin
      if RMCmp(FFieldAliases.Value[i], aFieldName) and
        (Pos(aDataSetName, UpperCase(FFieldAliases.Name[i])) = 1) then // WHF Modify
      begin
        aIndex := i;
        Result := FFieldAliases.Name[i];
        ExtractFieldName(Result, lDataSetName, Result);
        Exit;
      end;
    end;
  end;

  function _AddCacheItem(aRealFieldName: Boolean): Boolean;
  begin
    lDataSet := RMGetDefaultDataset(FParentReport);
    if (not aRealFieldName) and (lDataSet <> nil) then // 可能是虚拟的字段名称
    begin
      lDataSetName := lDataSet.Name;
      lFieldName := _RealFieldName(UpperCase(lDataSetName), RMRemoveQuotes(lFieldName), lIndex);
      s := lFieldName;
    end;

    RMGetDatasetAndField(FParentReport, s, lDataSet, lFieldName);
    if lFieldName <> '' then
    begin
      AddCacheItem(aVariableName, lDataSet, lFieldName);
      FCache.Sort;
      Result := True;
    end
    else
      Result := False;
  end;

begin
  Result := True;
  if FCache.Find(aVariableName, i) then
    Exit;

  if FVariables.IndexOf(aVariableName) >= 0 then
  begin
    lValue := FVariables[aVariableName];
    if lValue <> Null then
    begin
      s := lValue;
      if Pos('.', s) > 0 then
        _AddCacheItem(True);
    end;

    Exit;
  end;

  if Pos('.', aVariableName) <> 0 then
  begin
    ExtractFieldName(aVariableName, lDataSetName, lFieldName);
    lDataSetName := RealDataSetName[lDataSetName];
    lIndex := -1;
    s := lDataSetName + '."' + _RealFieldName(UpperCase(lDataSetName), lFieldName, lIndex) + '"';
    Result := _AddCacheItem(True);
    if (not Result) and (lIndex >= 0) then // 可能是字段改名了
    begin
      FFieldAliases.Delete(lIndex);
      Result := _AddCacheItem(True);
    end;
  end
  else
  begin
    s := aVariableName;
    lFieldName := s;
    Result := _AddCacheItem(False);
  end;
end;

function TRMDictionary.IsExpr(const aVariableName: string): Boolean;
var
  i: Integer;
begin
  Result := FExprCache.Find(aVariableName, i);
end;

function TRMDictionary.DataSetEnabled(const aDatasetname: string): Boolean;
var
  i: integer;
  lMask: Boolean;
  s: string;
begin
  Result := True;
  for i := 0 to FDisabledDatasets.Count - 1 do
  begin
    s := FDisabledDatasets[i];
    lMask := (s <> '') and (s[Length(s)] = '*');
    if lMask then
      s := Copy(s, 1, Length(s) - 1);
    if (lMask and (Pos(UpperCase(s), UpperCase(aDatasetname)) = 1)) or RMCmp(s, aDatasetname) then
    begin
      Result := False;
      Break;
    end
  end;
end;

function TRMDictionary.OPZExpr(const aVariableName: string): Variant;
var
  i: Integer;
  p: PRMCacheItem;
begin
  if FExprCache.Find(aVariableName, i) then
  begin
    p := PRMCacheItem(FExprCache.Objects[i]);
    Result := p^.DataFieldName;
  end;
end;

function TRMDictionary.FieldIsNull(const aVariableName: string): Boolean;
var
  i: Integer;
  p: PRMCacheItem;
begin
  Result := False;
  if FCache.Find(aVariableName, i) then
  begin
    p := PRMCacheItem(FCache.Objects[i]);
    Result := p^.DataSet.FieldIsNull(p^.DataFieldName);
  end
end;

function TRMDictionary.GetValue(const aVariableName: string): Variant;
var
  i: Integer;
  lCacheItem: PRMCacheItem;
  pItem: PRMVariable;
  lStr: string;
  {$IFDEF Delphi6}
  lVarType: TVarType;
  {$ELSE}
  lVarType: Word;
  {$ENDIF}
  lIsStr: Boolean;
begin
  Result := Null;
  if FCache.Find(aVariableName, i) then
  begin
    lCacheItem := PRMCacheItem(FCache.Objects[i]);
    if not lCacheItem^.DataSet.Active then
      lCacheItem^.DataSet.Open;

    Result := lCacheItem^.DataSet.GetFieldValue(lCacheItem^.DataFieldName,
      FParentReport.ConvertNulls);
  end
  else
  begin
    i := FVariables.IndexOf(aVariableName);
    if i >= 0 then
    begin
      pItem := PRMVariable(FVariables.Items.Objects[i]);
      Result := pItem.Value;
      if pItem.IsExpression and ((TVarData(Result).VType = varString) or (TVarData(Result).VType = varOleStr)) then
      begin
        if Result <> '' then
        begin
          try
            FParentReport.InDictionary := True;
            if IsExpr(Result) then
            begin
              Result := FParentReport.Parser.CalcOPZ(OPZExpr(Result));
            end
            else
            begin
              lIsStr := False;
              lVarType := TVarData(Result).VType;
              if (lVarType = varString) or (lVarType = varOleStr) then
              begin
                lStr := Result;
                if (Length(lStr) >= 2) and (lStr[1] = '''') and
                  (lStr[Length(lStr)] = '''') then
                begin
                  Result := Copy(lStr, 2, Length(lStr) - 2);
                  lIsStr := True;
                end;
              end;

              if not lIsStr then
              begin
                lStr := FParentReport.Parser.Str2OPZ(Result);
                if (lStr <> Result) and (lStr <> Result + ' ') then
                  AddExprCacheItem(Result, lStr);
                try
                  Result := FParentReport.Parser.CalcOPZ(lStr);
                except
                end;
              end;
            end;
          finally
            FParentReport.InDictionary := False;
          end;
        end;
      end;
    end
    else if RMVariables.IndexOf(aVariableName) >= 0 then
      Result := RMVariables[aVariableName]
    else if FParentReport.FVariables.IndexOf(aVariableName) >= 0 then
      Result := FParentReport.FVariables[aVariableName]
  end;
end;

function TRMDictionary.GetRealDataSetName(const aDataSet: string): string;
var
  i: Integer;
begin
  Result := aDataSet;
  if aDataSet = '' then Exit;

  for i := 0 to FFieldAliases.Count - 1 do
  begin
    if RMCmp(FFieldAliases.Value[i], aDataSet) then
    begin
      Result := FFieldAliases.Name[i];
      Exit;
    end;
  end;
end;

function TRMDictionary.GetRealFieldName(const aFieldName: string): string;
var
  i: integer;
begin
  Result := GetRealDataSetName(aFieldName);
  if Pos('.', Result) <> 0 then
  begin
    for i := Length(Result) downto 1 do
    begin
      if Result[i] = '.' then
      begin
        Result := Copy(Result, i + 1, 99999);
        if (Result <> '') and (Result[1] = '"') then
          Result := Copy(Result, 2, Length(Result) - 2);

        Break;
      end;
    end;
  end;
end;

procedure TRMDictionary.GetCategoryList(List: TStrings); //变量类型
var
  i: Integer;
  s: string;
begin
  List.Clear;
  for i := 0 to FVariables.Count - 1 do
  begin
    s := FVariables.Name[i];
    if (s <> '') and (s[1] = ' ') then
      List.Add(Copy(s, 2, 99999));
  end;
end;

procedure TRMDictionary.GetVariablesList(const Category: string; List: TStrings);
var
  i, j: Integer;
  s: string;
begin
  List.Clear;
  for i := 0 to FVariables.Count - 1 do
  begin
    if RMCmp(FVariables.Name[i], ' ' + Category) then
    begin
      j := i + 1;
      while j < FVariables.Count do
      begin
        s := FVariables.Name[j];
        Inc(j);
        if (s <> '') and (s[1] <> ' ') then
          List.Add(s)
        else
          Break;
      end;
      Break;
    end;
  end;
end;

procedure TRMDictionary.GetDataSets(aList: TStrings);
begin
  GetDataSets(aList, FieldAliases);
end;

procedure TRMDictionary.GetDataSets(aList: TStrings; aFieldAlias: TRMVariables);
var
  i, lCount: Integer;
  lDataSetName: string;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    RMGetComponents(FParentReport.Owner, TRMDataset, sl, nil);

    lCount := sl.Count - 1;
    for i := lCount downto 0 do
    begin
      lDataSetName := sl[i];
      if not DataSetEnabled(lDataSetName) then
      begin
        sl.Delete(i);
        Continue;
      end;

      if aFieldAlias.Count > 0 then
      begin
        if aFieldAlias.IndexOf(lDataSetName) >= 0 then
        begin
          lDataSetName := aFieldAlias[lDataSetName];
          if lDataSetName <> '' then
            sl[i] := lDataSetName;
        end
        else
          sl.Delete(i)
      end;
    end;

    sl.Sort;
    aList.Assign(sl);
  finally
    sl.Free;
  end;
end;

procedure TRMDictionary.GetDataSetFields(aDataSet: string; aList: TStrings);
begin
  GetDataSetFields(aDataSet, aList, FFieldAliases);
end;

procedure TRMDictionary.GetDataSetFields(aDataSet: string; aList: TStrings;
  aFieldAlias: TRMVariables);
var
  i: Integer;
  liStr: string;
  sl: TStringList;
  lDataSet: TRMDataSet;
  lComponent: TComponent;
begin
  sl := TStringList.Create;
  try
    aList.Clear;
    lComponent := RMFindComponent(FParentReport.Owner, aDataSet);
    if lComponent = nil then
    begin
      aDataSet := RealDataSetName[aDataSet];
      lComponent := RMFindComponent(FParentReport.Owner, aDataSet);
    end;

    if (lComponent <> nil) and (lComponent is TRMDataset) then
    begin
      lDataSet := TRMDataset(lComponent);
      lDataSet.GetFieldsList(sl);
      if (lDataSet.DictionaryKey <> '') and (FParentReport.DataDictionary <> nil) then
        FParentReport.DataDictionary.GetVirtualFieldsName(lDataSet.DictionaryKey, sl);

      i := 0;
      while i < sl.Count do
      begin
        if aFieldAlias.IndexOf(aDataSet + '."' + sl[i] + '"') <> -1 then
        begin
          liStr := aFieldAlias[aDataSet + '."' + sl[i] + '"'];
          if liStr <> '' then
            sl[i] := liStr
          else
          begin
            sl.Delete(i);
            Dec(i);
          end;
        end;
        Inc(i);
      end;

      sl.Sort;
      aList.Assign(sl);
    end;
  finally
    sl.Free;
  end;
end;

procedure TRMDictionary.AddDataSet(aDataSet: TDataSet; aDisplayName: string);
begin
  FieldAliases[aDataSet.Name] := aDisplayName;
end;

procedure TRMDictionary.AddField(aField: TField; aDisplayName: string);
begin
  FieldAliases[aField.DataSet.Name + '."' + aField.FieldName + '"'] := aDisplayName;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCompressThread }

procedure RMCompressStream(const aInStream, aOutStream: TStream; aCompressLevel: TZCompressionLevel);
var
  lComp: TZCompressionStream;
begin
  aInStream.Position := 0;
  lComp := TZCompressionStream.Create(aOutStream, aCompressLevel);
  try
    lComp.CopyFrom(aInStream, aInStream.Size);
  finally
    lComp.Free;
  end;
end;

procedure RMDeCompressStream(const aInStream, aOutStream: TStream);
var
  lDeComp: TZDecompressionStream;
begin
  aInStream.Position := 0;
  lDecomp := TZDecompressionStream.Create(aInStream);
  try
    aOutStream.CopyFrom(lDecomp, 0);
  finally
    lDecomp.Free;
  end;
end;

type
  TRMCompressThread = class(TThread)
  private
    FInStream, FOutStream: TStream;
    FCompressLevel: TZCompressionLevel;
  protected
    procedure Execute; override;
  public
    constructor Create(const aInStream, aOutStream: TStream; aCompressLevel: TZCompressionLevel);
  end;

constructor TRMCompressThread.Create(const aInStream, aOutStream: TStream; aCompressLevel: TZCompressionLevel);
begin
  FInStream := aInStream;
  FOutStream := aOutStream;
  FCompressLevel := aCompressLevel;

  inherited Create(True);
  FreeOnTerminate := True;
end;

procedure TRMCompressThread.Execute;
begin
  RMCompressStream(FInStream, FOutStream, FCompressLevel);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TRMEndPage.Create(aParentEndPages: TRMEndPages);
begin
  inherited Create;

  FThreadDone := True;
  FStreamCompressed := False;
  FParentEndPages := aParentEndPages;
end;

destructor TRMEndPage.Destroy;
begin
  while (not FThreadDone) and FParentEndPages.FParentReport.CompressThread do
    Application.ProcessMessages;

  FreeAndNil(FPage);
  FreeAndNil(FEndPageStream);
  FreeAndNil(FCompressOutStream);
  inherited Destroy;
end;

procedure TRMEndPage.AssignFromReportPage(aPage: TRMReportPage; aPictureCount: Integer);
begin
  while (not FThreadDone) and FParentEndPages.FParentReport.CompressThread do
    Application.ProcessMessages;

  FEndPageStream := TMemoryStream.Create;
  FPageSize := aPage.PageSize;
  FPageOrientation := aPage.PageOrientation;
  FPageBin := aPage.PageBin;
  PrinterInfo := aPage.PrinterInfo;
  FmmMarginLeft := aPage.FmmMarginLeft;
  FmmMarginTop := aPage.FmmMarginTop;
  FmmMarginRight := aPage.FmmMarginRight;
  FmmMarginBottom := aPage.FmmMarginBottom;
  FPageNumber := aPage.FPageNumber;
  FPageWidth := aPage.PageWidth;
  FPageHeight := aPage.PageHeight;
  FDuplex := aPage.Duplex;
  if aPage.FShowBackPicture then
    FbkPictureIndex := aPictureCount
  else
    FbkPictureIndex := 0;
end;

procedure TRMEndPage.AssignFromEndPage(aPage: TRMEndPage; aPictureCount: Integer);
begin
  while (not FThreadDone) and FParentEndPages.FParentReport.CompressThread do
    Application.ProcessMessages;

  FEndPageStream := TMemoryStream.Create;
  FPageSize := aPage.PageSize;
  FPageOrientation := aPage.PageOrientation;
  FPageBin := aPage.PageBin;
  PrinterInfo := aPage.PrinterInfo;
  FmmMarginLeft := aPage.FmmMarginLeft;
  FmmMarginTop := aPage.FmmMarginTop;
  FmmMarginRight := aPage.FmmMarginRight;
  FmmMarginBottom := aPage.FmmMarginBottom;
  FPageNumber := aPage.FPageNumber;
  FPageWidth := aPage.PageWidth;
  FPageHeight := aPage.PageHeight;
  FDuplex := aPage.Duplex;
  FbkPictureIndex := aPage.FbkPictureIndex;
end;

procedure TRMEndPage.StreamToObjects(aParentReport: TRMReport; aIsPreview: Boolean); // 从流中读出对象
var
  i: Integer;
  lObjectType: Byte;
  t: TRMView;
  s: string;
  lBuffer: TMemoryStream;
  lReadBuffer: TMemoryStream;
begin
  while (not FThreadDone) and FParentEndPages.FParentReport.CompressThread do
    Application.ProcessMessages;

  FreeAndNil(FPage);
  FPage := TRMReportPage.CreatePage(aParentReport, FPageSize, PageWidth, PageHeight, FPageBin, FPageOrientation);
  FPage.FmmMarginLeft := FmmMarginLeft;
  FPage.FmmMarginRight := FmmMarginRight;
  FPage.FmmMarginTop := FmmMarginTop;
  FPage.FmmMarginBottom := FmmMarginBottom;

  lBuffer := nil;
  try
    if FParentEndPages.FStreamCompressed and FStreamCompressed then // 已经压缩，需要解压
    begin
      lBuffer := TMemoryStream.Create;
      RMDeCompressStream(FEndPageStream, lBuffer);
      lReadBuffer := lBuffer;
    end
    else
      lReadBuffer := FEndPageStream;

    lReadBuffer.Position := 0;
    while lReadBuffer.Position < lReadBuffer.Size do
    begin
      lObjectType := RMReadByte(lReadBuffer);
      if lObjectType = rmgtAddIn then
        s := RMReadString(lReadBuffer)
      else if lObjectType > rmgtAddIn then // 肯定出问题了
      begin
        Break;
      end;

      t := RMCreateObject(lObjectType, s);
      t.NeedCreateName := False;
      t.StreamMode := rmsmPrinting;
      t.ParentPage := FPage;
      t.LoadFromStream(lReadBuffer);
      t.StreamMode := rmsmDesigning;
      //      TRMReportView(t).TextOnly := True;
      if (t is TRMCustomMemoView) and TRMCustomMemoView(t).AutoWidth then
        TRMCustomMemoView(t).Set_AutoWidth(t.ParentReport.DrawCanvas);
    end;

    if aIsPreview then
    begin
      for i := 0 to FPage.FObjects.Count - 1 do
      begin
        t := FPage.FObjects[i];
        t.SetObjectEvent(FPage.EventList, aParentReport.FScriptEngine);
      end;
    end;
  finally
    lBuffer.Free;
  end;
end;

procedure TRMEndPage.ObjectsToStream(aParentReport: TRMReport); //对象保存到流中
var
  i: Integer;
  t: TRMView;
begin
  if FPage = nil then Exit;

  while (not FThreadDone) and FParentEndPages.FParentReport.CompressThread do
    Application.ProcessMessages;

  FStreamCompressed := False;
  FEndPageStream.Clear;
  for i := 0 to FPage.Objects.Count - 1 do
  begin
    t := FPage.FObjects[i];
    t.StreamMode := rmsmPrinting;
    RMWriteByte(FEndPageStream, t.Typ);
    if t.Typ = rmgtAddIn then
      RMWriteString(FEndPageStream, t.ClassName);
    t.Memo1.Assign(t.Memo);
    if t is TRMCustomMemoView then
      TRMCustomMemoView(t).CalcGeneratedData(aParentReport.DrawCanvas.Handle);

    t.SaveToStream(FEndPageStream);
  end;
  AfterEndPage;
end;

procedure TRMEndPage.ThreadTerminate(Sender: TObject);
begin
  FCompressThread := nil;
  FEndPageStream.LoadFromStream(FCompressOutStream);
  FreeAndNil(FCompressOutStream);
  FThreadDone := True;
end;

procedure TRMEndPage.AfterEndPage;
var
  lBuffer: TMemoryStream;
begin
  if (not FParentEndPages.FStreamCompressed) or FStreamCompressed then Exit;

  FStreamCompressed := True;
  if FParentEndPages.FParentReport.CompressThread then
  begin
    FThreadDone := False;
    FCompressOutStream := TMemoryStream.Create;
    FCompressThread := TRMCompressThread.Create(FEndPageStream, FCompressOutStream, TZCompressionLevel(FParentEndPages.FParentReport.CompressLevel));
    with FCompressThread do
    begin
      FreeOnTerminate := True;
      Priority := tpHigher;
      OnTerminate := Self.ThreadTerminate;
      Resume;
    end;
  end
  else
  begin
    lBuffer := TMemoryStream.Create;
    try
      RMCompressStream(FEndPageStream, lBuffer, TZCompressionLevel(FParentEndPages.FParentReport.CompressLevel));
      FEndPageStream.LoadFromStream(lBuffer);
    finally
      lBuffer.Free;
    end;
  end;
end;

procedure TRMEndPage.RemoveCachePage;
begin
  while (not FThreadDone) and FParentEndPages.FParentReport.CompressThread do
    Application.ProcessMessages;

  FreeAndNil(FPage);
end;

procedure TRMEndPage.Draw(aReport: TRMReport; aCanvas: TCanvas; aDrawRect: TRect);
var
  t: TRMView;
  i: Integer;
  lFactorX, lFactorY: Double;
  lVisible, lIsPrinting: Boolean;
  lOffsetTop, lOffsetLeft: Integer;
begin
  while (not FThreadDone) and FParentEndPages.FParentReport.CompressThread do
    Application.ProcessMessages;

  lIsPrinting := aReport.ReportPrinter.Printing and
    (aCanvas.Handle = aReport.ReportPrinter.Canvas.Handle);
  if lIsPrinting and (aReport.ScaleFactor = 100) and (aReport.ScalePageSize < 0) then
    aReport.FDocMode := rmdmPrinting
  else
    aReport.FDocMode := rmdmPreviewing;

  if FPage = nil then
  begin
    StreamToObjects(aReport, not lIsPrinting);
  end;

  aReport.FCurrentPage := FPage;
  lFactorX := (aDrawRect.Right - aDrawRect.Left) / PrinterInfo.PageWidth;
  lFactorY := (aDrawRect.Bottom - aDrawRect.Top) / PrinterInfo.PageHeight;
  lOffsetLeft := Round(RMFromMMThousandths(mmMarginLeft, rmutScreenPixels) * lFactorX);
  lOffsetTop := Round(RMFromMMThousandths(mmMarginTop, rmutScreenPixels) * lFactorY);
  for i := 0 to FPage.FObjects.Count - 1 do
  begin
    t := FPage.FObjects[i];
    if lIsPrinting then
      lVisible := True
    else
    begin
      lVisible := RectVisible(aCanvas.Handle, Rect(
        Round(t.spLeft * lFactorX) + aDrawRect.Left - 10 + lOffsetLeft,
        Round(t.spTop * lFactorY) + aDrawRect.Top - 10 + lOffsetTop,
        Round(t.spRight * lFactorX) + aDrawRect.Left + 10 + lOffsetLeft,
        Round(t.spBottom * lFactorY) + aDrawRect.Top + 10 + lOffsetTop));
    end;

    if lVisible then
    begin
      if (not lIsPrinting) or aReport.Flag_PrintBackGroundPicture or
        TRMReportView(t).Printable then
      begin
        t.IsPrinting := lIsPrinting;
        try
          t.FactorX := lFactorX;
          t.FactorY := lFactorY;
          t.OffsetLeft := aDrawRect.Left + lOffsetLeft;
          t.OffsetTop := aDrawRect.Top + lOffsetTop;
          t.Draw(aCanvas);
        finally
          t.IsPrinting := False;
        end;
      end;
    end;
  end;
end;

procedure TRMEndPage.ExportPage(aReport: TRMReport);
begin
  while (not FThreadDone) and FParentEndPages.FParentReport.CompressThread do
    Application.ProcessMessages;

  if FPage <> nil then
    RemoveCachePage;

  StreamToObjects(aReport, False);
  try
    aReport.FCurrentFilter.OnExportPage(Self);
  finally
    RemoveCachePage;
  end;
end;

function TRMEndPage.GetspMarginLeft(aIndex: Integer): Integer;
begin
  case aIndex of
    0: Result := RMToScreenPixels(FmmMarginLeft, rmutMMThousandths);
    1: Result := RMToScreenPixels(FmmMarginTop, rmutMMThousandths);
    2: Result := RMToScreenPixels(FmmMarginRight, rmutMMThousandths);
    3: Result := RMToScreenPixels(FmmMarginBottom, rmutMMThousandths);
  else
    Result := 0;
  end;
end;

procedure TRMEndPage.SetspMarginLeft(aIndex: Integer; Value: Integer);
begin
  case aIndex of
    0: mmMarginLeft := RMToMMThousandths(Value, rmutScreenPixels);
    1: mmMarginTop := RMToMMThousandths(Value, rmutScreenPixels);
    2: mmMarginRight := RMToMMThousandths(Value, rmutScreenPixels);
    3: mmMarginBottom := RMToMMThousandths(Value, rmutScreenPixels);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMEndPages }

constructor TRMEndPages.Create(aParentReport: TRMReport);
begin
  inherited Create;

  FStreamCompressed := False;
  FStreamCompressType := aParentReport.FCompressType;

  FParentReport := aParentReport;
  FPages := TList.Create;
  FBkPictures := TList.Create;
  FOutLines := TStringList.Create;
end;

destructor TRMEndPages.Destroy;
begin
  Clear;
  FreeAndNil(FPages);
  FreeAndNil(FBkPictures);
  FreeAndNil(FOutLines);

  inherited Destroy;
end;

procedure TRMEndPages.Clear;
var
  i, lCount: Integer;
begin
  if Assigned(FOnClearEvent) then
  begin
    FOnClearEvent(Self);
    Exit;
  end;

  lCount := FPages.Count - 1;
  for i := 0 to lCount do
    Delete(0);
  while FBkPictures.Count > 0 do
  begin
    TRMbkPicture(FBkPictures[0]).Free;
    FBkPictures.Delete(0);
  end;

  FOutLines.Clear;
end;

function TRMEndPages.GetParentReportCompressStream: Boolean;
begin
  Result := FParentReport.CompressLevel <> rmzcNone;
end;

function TRMEndPages.GetParentReportCompressType: Byte;
begin
  Result := FParentReport.FCompressType;
end;

procedure TRMEndPages.Delete(aPageIndex: Integer);
begin
  TRMEndPage(FPages[aPageIndex]).Free;
  FPages.Delete(aPageIndex);
end;

procedure TRMEndPages.Insert(aPageIndex: Integer; aPage: TRMReportPage);
var
  lEndPage: TRMEndPage;
begin
  lEndPage := TRMEndPage.Create(Self);
  lEndPage.AssignFromReportPage(aPage, FBkPictures.Count - 1);
  if aPageIndex >= FPages.Count then
    FPages.Add(lEndPage)
  else
    FPages.Insert(aPageIndex, lEndPage);
end;

procedure TRMEndPages.InsertFromEndPage(aPageIndex: Integer; aEndPage: TRMEndPage);
var
  lEndPage: TRMEndPage;
begin
  lEndPage := TRMEndPage.Create(Self);
  lEndPage.AssignFromEndPage(aEndPage, FBkPictures.Count);
  if aPageIndex >= FPages.Count then
    FPages.Add(lEndPage)
  else
    FPages.Insert(aPageIndex, lEndPage);
end;

procedure TRMEndPages.Add(aPage: TRMReportPage);
begin
  if FPages.Count > 0 then
    Pages[FPages.Count - 1].AfterEndPage;

  if (FParentReport <> nil) and Assigned(FParentReport.FOnBeginPage) then
    FParentReport.FOnBeginPage(FParentReport.PageNo);
  if (FParentReport <> nil) and (FParentReport.CurrentPage <> nil) and
    Assigned(FParentReport.CurrentPage.OnBeginPage) then
    FParentReport.CurrentPage.OnBeginPage(FParentReport.PageNo);

  Insert(FPages.Count, APage);
end;

procedure TRMEndPages._LoadFromStream(aStream: TStream);
var
  i, lSavePos, lCount: Integer;
  lEndPage: TRMEndPage;
  lVersion: Integer;
  lTmpBuffer: TMemoryStream;

  procedure _ReadBackGround;
  var
    lPic: TPicture;
    lPicLeft, lPicTop, lPicWidth, lPicHeight: Integer;
    i, lCount: Integer;
  begin
    lCount := RMReadInt32(aStream);
    for i := 0 to lCount - 1 do
    begin
      lPic := TPicture.Create;
      try
        lPicLeft := RMReadInt32(aStream);
        lPicTop := RMReadInt32(aStream);
        lPicWidth := RMReadInt32(aStream);
        lPicHeight := RMReadInt32(aStream);
        RMLoadPicture(aStream, lPic);
        AddbkPicture(lPicLeft, lPicTop, lPicWidth, lPicHeight, lPic);
      finally
        lPic.Free;
      end;
    end;
  end;

begin
  if aStream = nil then Exit;
  if RMReadString(aStream) <> 'ReportMachine Prepared Report File' + #26 then
  begin
    Application.MessageBox(PChar(RMLoadStr(SNotRMPFile)), PChar(RMLoadStr(SError)),
      mb_Ok + mb_IconError);
    Exit;
  end;

  lVersion := RMReadByte(aStream);
  if lVersion >= 54 then
  begin
    FStreamCompressed := RMReadBoolean(aStream); // 是否是压缩存储的
    FStreamCompressType := RMReadByte(aStream); // 压缩方法
  end
  else
  begin
    FStreamCompressed := False;
    FStreamCompressType := ParentReportCompressType;
  end;

  _ReadBackGround;

  FParentReport.PrinterName := RMReadString(aStream);
  if lVersion >= 56 then
  begin
    FParentReport.ReportInfo.Title := RMReadString(aStream);
    FParentReport.ReportInfo.Author := RMReadString(aStream);
    FParentReport.ReportInfo.Company := RMReadString(aStream);
    FParentReport.ReportInfo.CopyRight := RMReadString(aStream);
    FParentReport.ReportInfo.Comment := RMReadString(aStream);
  end;

  if lVersion >= 57 then
  begin
    RMReadInt32(aStream);
    RMReadMemo(aStream, FParentReport.Script);
    RMReadMemo(aStream, FOutLines);

    FParentReport.FScriptEngine.Pas.Assign(FParentReport.Script);
    FParentReport.FScriptEngine.Compile;
  end;

  lCount := RMReadInt32(aStream);
  lTmpBuffer := TMemoryStream.Create;
  try
    for i := 0 to lCount - 1 do
    begin
      FParentReport.InternalOnReadOneEndPage(i + 1, lCount);
      lSavePos := RMReadInt32(aStream);
      lEndPage := TRMEndPage.Create(Self);
      FPages.Add(lEndPage);
      with lEndPage do
      begin
        FPageSize := RMReadWord(aStream);
        FPageWidth := RMReadInt32(aStream);
        FPageHeight := RMReadInt32(aStream);
        PageOrientation := TRMPrinterOrientation(RMReadByte(aStream));
        PageBin := RMReadInt32(aStream);
        mmMarginLeft := RMReadInt32(aStream);
        mmMarginTop := RMReadInt32(aStream);
        mmMarginRight := RMReadInt32(aStream);
        mmMarginBottom := RMReadInt32(aStream);
        Duplex := TRMDuplex(RMReadByte(aStream));
        if lVersion >= 55 then
          FNewPrintJob := RMReadBoolean(aStream)
        else
          FNewPrintJob := False;

        if lVersion >= 62 then
          FbkPictureIndex := RMReadInt32(aStream);

        FEndPageStream := TMemoryStream.Create;
        FEndPageStream.CopyFrom(aStream, lSavePos - aStream.Position);
        FStreamCompressed := Self.FStreamCompressed;
        if Self.FStreamCompressed <> Self.ParentReportCompressStream then // 流的压缩与ParentReport不一样时
        begin
          lTmpBuffer.Clear;
          if Self.FStreamCompressed then // 已经压缩了，解压缩
          begin
            RMDeCompressStream(FEndPageStream, lTmpBuffer);
            FStreamCompressed := False;
          end
          else // 没有压缩，进行压缩存储
          begin
            RMCompressStream(FEndPageStream, lTmpBuffer, TZCompressionLevel(FParentReport.CompressLevel));
            FStreamCompressed := True;
          end;

          FEndPageStream.LoadFromStream(lTmpBuffer);
          lTmpBuffer.Clear;
        end;

        FParentReport.GetPrinter.SetPrinterInfo(PageSize, PageWidth, PageHeight, PageBin, PageOrientation, False);
        FParentReport.GetPrinter.FillPrinterInfo(PrinterInfo);
      end;
      aStream.Seek(lSavePos, soFromBeginning);
    end;
  finally
    lTmpBuffer.Free;
    FStreamCompressed := ParentReportCompressStream; // 已ParentReport压缩设置为准
    FStreamCompressType := ParentReportCompressType;
  end;
end;

procedure TRMEndPages.AppendFromStream(aStream: TStream);
begin
  _LoadFromStream(aStream);
end;

procedure TRMEndPages.LoadFromStream(aStream: TStream);
begin
  Clear;
  _LoadFromStream(aStream);
end;

procedure TRMEndPages.SaveToStream(aStream: TStream);
var
  i, lSavePos, n: Integer;
  lbkPic: TRMbkPicture;
  lSaveCompressThread: Boolean;
begin
  if aStream = nil then Exit;

  RMWriteString(aStream, 'ReportMachine Prepared Report File' + #26);
  RMWriteByte(aStream, RMCurrentVersion);
  RMWriteBoolean(aStream, FStreamCompressed); // 是否已经压缩
  RMWriteByte(aStream, FStreamCompressType); // 压缩方法

  RMWriteInt32(aStream, FbkPictures.Count);
  for i := 0 to FbkPictures.Count - 1 do
  begin
    lbkPic := TRMbkPicture(FbkPictures[i]);
    RMWriteInt32(aStream, lbkPic.Left);
    RMWriteInt32(aStream, lbkPic.Top);
    RMWriteInt32(aStream, lbkPic.Width);
    RMWriteInt32(aStream, lbkPic.Height);
    RMWritePicture(aStream, lbkPic.Picture);
  end;

  RMWriteString(aStream, FParentReport.PrinterName);
  RMWriteString(aStream, FParentReport.ReportInfo.Title);
  RMWriteString(aStream, FParentReport.ReportInfo.Author);
  RMWriteString(aStream, FParentReport.ReportInfo.Company);
  RMWriteString(aStream, FParentReport.ReportInfo.CopyRight);
  RMWriteString(aStream, FParentReport.ReportInfo.Comment);
  RMWriteInt32(aStream, 0); // 预留一个flag位置
  RMWriteMemo(aStream, FParentReport.Script);
  RMWriteMemo(aStream, FOutLines);

  lSaveCompressThread := FParentReport.CompressThread;
  try
    FParentReport.CompressThread := False;
    RMWriteInt32(aStream, Count);
    for i := 0 to Count - 1 do
    begin
      lSavePos := aStream.Position;
      RMWriteInt32(aStream, lSavePos);
      with Pages[i] do
      begin
        RMWriteWord(aStream, PageSize);
        RMWriteInt32(aStream, PageWidth);
        RMWriteInt32(aStream, PageHeight);
        RMWriteByte(aStream, Byte(PageOrientation));
        RMWriteInt32(aStream, PageBin);
        RMWriteInt32(aStream, mmMarginLeft);
        RMWriteInt32(aStream, mmMarginTop);
        RMWriteInt32(aStream, mmMarginRight);
        RMWriteInt32(aStream, mmMarginBottom);
        RMWriteByte(aStream, Byte(Duplex));
        RMWriteBoolean(aStream, FNewPrintJob);
        RMWriteInt32(aStream, bkPictureIndex);

        if not Self.FParentReport.CanRebuild then // 旧的报表格式，转换成新的
        begin
          StreamToObjects(Self.FParentReport, False);
          ObjectsToStream(Self.FParentReport);
        end;
        EndPageStream.Position := 0;
        aStream.CopyFrom(EndPageStream, EndPageStream.Size);
      end;

      n := aStream.Position;
      aStream.Seek(lSavePos, soFromBeginning);
      RMWriteInt32(aStream, n);
      aStream.Seek(0, soFromEnd);
    end;
  finally
    FParentReport.CompressThread := lSaveCompressThread;
  end;
end;

function TRMEndPages.GetPages(Index: Integer): TRMEndPage;
begin
  if (Index >= 0) and (Index < FPages.Count) then
    Result := TRMEndPage(FPages[Index])
  else
    Result := nil;
end;

function TRMEndPages.GetCount: Integer;
begin
  Result := FPages.Count;
end;

procedure TRMEndPages.AddbkPicture(aLeft, aTop, aWidth, aHeight: Integer; aPicture: TPicture);
begin
  FBkPictures.Add(TRMbkPicture.Create(aLeft, aTop, aWidth, aHeight, aPicture));
end;

function TRMEndPages.GetbkPicture(Index: Integer): TRMbkPicture;
begin
  if (Index >= 0) and (Index < FBkPictures.Count) then
    Result := TRMbkPicture(FBkPictures[Index])
  else
    Result := nil;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMReport }

function TRMReport.IsGetSystemVariables(const aVariableName: string; var aValue: Variant): Boolean; // 系统变量
begin
  Result := True;
  if RMCmp(aVariableName, RMSpecFuncs[0]) then // _RM_Page
  begin
    aValue := MasterReport.FPageNo + 1;
    if (FCurrentPage <> nil) and (FCurrentPage is TRMReportPage) and TRMReportPage(FCurrentPage).ResetPageNo then
      aValue := aValue - FCurrentPage.FStartPageNo;
  end
  else if RMCmp(aVariableName, RMSpecFuncs[1]) then // _RM_ApplicationPath
    aValue := ExtractFileDir(ParamStr(0)) + '\'
  else if RMCmp(aVariableName, RMSpecFuncs[2]) then // _RM_Date
    aValue := MasterReport.FCurrentDate
  else if RMCmp(aVariableName, RMSpecFuncs[3]) then // _RM_Time
    aValue := MasterReport.FCurrentTime
  else if RMCmp(aVariableName, RMSpecFuncs[4]) then // _RM_DateTime
    aValue := MasterReport.FCurrentDateTime
  else if RMCmp(aVariableName, RMSpecFuncs[5]) then // _RM_Line
    aValue := FCurrentBand.FPositions[rmpsLocal]
  else if RMCmp(aVariableName, RMSpecFuncs[6]) then // _RM_LineThough
    aValue := FCurrentBand.FPositions[rmpsGlobal]
  else if RMCmp(aVariableName, RMSpecFuncs[7]) then // _RM_Column
    aValue := FCurrentPage.FColumnPos
  else if RMCmp(aVariableName, RMSpecFuncs[8]) then // _RM_Current
    aValue := FCurrentPage.FCurrentPos
  else if RMCmp(aVariableName, RMSpecFuncs[9]) then // _RM_TotalPages
    aValue := MasterReport.FTotalPages
  else if RMCmp(aVariableName, 'Value') then // Value
    aValue := FCurrentValue
  else
    Result := False;
end;

procedure TRMReport.ScriptEngine_OnGetDfmFileName(Sender: TObject; aUnitName: string;
  var aFileName: string; var aDone: Boolean);
begin
  aFileName := RMExtendFormPath + aUnitName + '.dfm';
  aDone := FileExists(aFileName);
end;

procedure TRMReport.ScriptEngine_OnGetUnitSource(aUnitName: string; var aSource: string;
  var aDone: Boolean);
var
  lFileName: TFileName;

  function _LoadTextFile(const FileName: TFileName): string;
  begin
    with TStringList.Create do
    try
      LoadFromFile(FileName);
      Result := Text;
    finally
      Free;
    end;
  end;

begin
  lFileName := RMExtendFormPath + aUnitName + '.pas';
  if FileExists(lFileName) then
  begin
    aSource := _LoadTextFile(lFileName);
  end;
  aDone := True;
end;

type
  THackTRMPersistent = class(TRMPersistent);
  THackTRMComponent = class(TRMComponent);

procedure TRMReport.ScriptEngine_OnGetValue(Sender: TObject; Identifier: string;
  var aValue: Variant; Args: TJvInterpreterArgs; var Done: Boolean);

  function _FindComponent(aOwner: TComponent): Boolean;
  var
    lComponent: TComponent;
  begin
    Result := False;
    lComponent := RMFindComponent(aOwner, Identifier);
    if lComponent <> nil then
    begin
      aValue := O2V(lComponent);
      Result := True;
    end;
  end;

  function _IsReportObject: Boolean;
  var
    i: Integer;
    t: TRMView;
  begin
    Result := False;
    t := FindObject(Identifier);
    if t <> nil then
    begin
      aValue := O2V(t);
      Result := True;
      Exit;
    end;

    for i := 0 to Pages.Count - 1 do
    begin
      if RMCmp(Pages[i].Name, Identifier) then
      begin
        aValue := O2V(Pages[i]);
        Result := True;
        Exit;
      end;
    end;

    if RMCmp('Self', Identifier) or RMCmp('RMCurReport', Identifier) or
      RMCmp('CurReport', Identifier) then
    begin
      aValue := O2V(Self);
      Result := True;
      Exit;
    end;
  end;

  function _FindForm: Boolean;
  var
    i: Integer;
  begin
    for i := 0 to Screen.CustomFormCount - 1 do
    begin
      if RMCmp(Identifier, Screen.CustomForms[i].Name) then
      begin
        aValue := O2V(Screen.CustomForms[i]);
        Result := True;
        Exit;
      end;
    end;

    for i := 0 to Screen.DataModuleCount - 1 do
    begin
      if RMCmp(Identifier, Screen.DataModules[i].Name) then
      begin
        aValue := O2V(Screen.DataModules[i]);
        Result := True;
        Exit;
      end;
    end;

    Result := False;
  end;

  function _IsIntrpFunction: Boolean;
  begin
    Result := True;
    if RMCmp(Identifier, 'Int') then
      aValue := Int(Args.Values[0])
    else if RMCmp(Identifier, 'Frac') then
      aValue := Frac(Args.Values[0])
    else if RMCmp(Identifier, 'Round') then
      aValue := Integer(Args.Values[0])
    else if RMCmp(Identifier, 'Str') then
      aValue := Args.Values[0].AsString
    else if RMCmp(Identifier, 'STOPREPORT') then
    begin
      Self.Terminated := True;
      Self.MasterReport.Terminated := True;
      FDontShowReport := True;
    end
    else if RMCmp(Identifier, 'NEWCOLUMN') then
    begin
      TRMReportPage(CurrentPage).NewColumn(CurrentBand);
      //      Inc(CurrentBand.FCallNewColumn)
    end
    else if RMCmp(Identifier, 'NEWPAGE') then
    begin
      TRMReportPage(CurrentPage).NewPage;
      //      Inc(CurrentBand.FCallNewPage)
    end
    else if RMCmp(Identifier, 'SHOWBAND') then
      TRMReportPage(CurrentPage).ShowBandByName(Args.Values[0])
    else if RMCmp(Identifier, 'CurY') then
      aValue := RMToScreenPixels(TRMReportPage(CurrentPage).FmmCurrentY, rmutMMThousandths)
    else if RMCmp(Identifier, 'FreeSpace') then
      aValue := RMToScreenPixels(TRMReportPage(CurrentPage).FmmCurrentBottomY - TRMReportPage(CurrentPage).FmmCurrentY, rmutMMThousandths)
    else if RMCmp(Identifier, 'FINALPASS') then
      aValue := MasterReport.FinalPass
    else if RMCmp(Identifier, 'PAGEHEIGHT') then
      aValue := RMToScreenPixels(TRMReportPage(CurrentPage).FmmCurrentBottomY, rmutMMThousandths)
    else if RMCmp(Identifier, 'PAGEWIDTH') then
      aValue := RMToScreenPixels(TRMReportPage(CurrentPage).GetCurrentRightX, rmutMMThousandths)
    else if RMCmp(Identifier, 'RMCreateObject') then
    begin
      aValue := O2V(RMCreateObject(Args.Values[0], Args.Values[1]));
    end
    else if RMCmp(Identifier, 'RMCreateBand') then
    begin
      aValue := O2V(RMCreateBand(Args.Values[0]));
    end
    else
      Result := False;
  end;

  function _FindFormComponent: Boolean;
  var
    lComponent: TComponent;
  begin
    Result := False;
    if Args.Obj is TRMView then
    begin
      Result := TRMView(Args.Obj).GetPropValue(Args.Obj, UpperCase(Identifier), aValue, Args.Values);
    end
    else if Args.Obj is TRMReport then
    begin
      Result := _IsIntrpFunction;
      if not Result then
        Result := TRMReport(Args.Obj).GetPropValue(Args.Obj, UpperCase(Identifier), aValue, Args.Values);
    end
    else if Args.Obj is TRMPersistent then
    begin
      Result := THackTRMPersistent(Args.Obj).GetPropValue(Args.Obj, UpperCase(Identifier), aValue, Args.Values);
    end
    else if Args.Obj is TRMComponent then
    begin
      Result := THackTRMComponent(Args.Obj).GetPropValue(Args.Obj, UpperCase(Identifier), aValue, Args.Values);
    end
    else if Args.Obj is TComponent then
    begin
      lComponent := RMFindComponent(TComponent(Args.Obj), Identifier);
      if lComponent <> nil then
      begin
        aValue := O2V(lComponent);
        Result := True;
      end;
    end;
  end;

  function _isFunction: Boolean;
  var
    lVar: Variant;
    lStr: string;
    lOldUseNull: Boolean;
  begin
    if RMCmp('GetFieldValue', Identifier) or RMCmp('Get', Identifier) then
    begin
      lOldUseNull := ConvertNulls {RMUseNull};
      try
        //RMUseNull := False;
        ConvertNulls := True;
        if Dictionary.IsVariable(Args.Values[0]) then
        begin
          aValue := Dictionary.Value[Args.Values[0]];
          if FFlag_TableEmpty then
          begin
            case TVarData(aValue).VType of
              varBoolean: aValue := False;
              varString, varOleStr: aValue := '';
            else
              aValue := 0;
            end;
          end;

          Result := True;
        end;
      finally
        ConvertNulls {RMUseNull} := lOldUseNull;
      end;
    end
    else if RMCmp('FieldIsNull', Identifier) then
    begin
      if Dictionary.IsVariable(Args.Values[0]) then
      begin
        aValue := Dictionary.FieldIsNull(Args.Values[0]);
        Result := True;
      end;
    end
    else if RMCmp(Identifier, 'GetArray') or RMCmp(Identifier, 'GetVariable') then
    begin
      lVar := Args.Values[1];
      if TVarData(lVar).VType = varString then
        lStr := lVar
      else
        lStr := IntToStr(lVar);

      aValue := FDictionary.Variables['Arr_' + Args.Values[0] + '_' + lStr];
      Result := True;
    end
    else if RMCmp(Identifier, 'SetArray') or RMCmp(Identifier, 'SetVariable') then
    begin
      lVar := Args.Values[1];
      if TVarData(lVar).VType = varString then
        lStr := lVar
      else
        lStr := IntToStr(lVar);

      FDictionary.Variables['Arr_' + Args.Values[0] + '_' + lStr] := Args.Values[2];
      Result := True;
    end
    else
    begin
      Parser.InScript := True;
      try
        OnGetFunction(Identifier, Args.Values, aValue, Result);
      finally
        Parser.InScript := False;
      end;
    end;

    if not Result then
    begin
      Result := _IsIntrpFunction;
    end;
  end;

begin
  if TVarData(aValue).VType <> varEmpty then VarClear(aValue);
  TVarData(aValue).VType := varEmpty;
  if Assigned(FOnGetValue) then FOnGetValue(Identifier, aValue);
  if TVarData(aValue).VType <> varEmpty then Exit;

  if Args.Obj <> nil then
  begin
    if Args.ObjTyp = varObject then
    begin
      if _FindFormComponent then
      begin
        Done := True;
        Exit;
      end
      else
      begin
        if Assigned(FOnScriptGetValue) then
          FOnScriptGetValue(Sender, Identifier, aValue, Args, Done);
      end;
    end;

    Exit;
  end;

  if _IsReportObject then
  begin
    Done := True;
    Exit;
  end;

  if IsGetSystemVariables(Identifier, aValue) then
  begin
    Done := True;
    Exit;
  end;

  if FDictionary.Variables.IndexOf(Identifier) >= 0 then
  begin
    Done := True;
    aValue := FDictionary.Variables[Identifier];
    Exit;
  end;

  if RMVariables.IndexOf(Identifier) >= 0 then
  begin
    Done := True;
    aValue := RMVariables[Identifier];
    Exit;
  end;

  if _IsFunction then
  begin
    Done := True;
    Exit;
  end;

  if _FindForm then
  begin
    Done := True;
    Exit;
  end;

  if _FindComponent(Owner) then
  begin
    Done := True;
    Exit;
  end;

  if Assigned(FOnScriptGetValue) then
    FOnScriptGetValue(Sender, Identifier, aValue, Args, Done);
end;

procedure TRMReport.ScriptEngine_OnSetValue(Sender: TObject; Identifier: string;
  const aValue: Variant; Args: TJvInterpreterArgs; var Done: Boolean);
var
  lIndex: Integer;
  pItem: PRMVariable;

  function _IsIntrpFunction: Boolean;
  var
    lVar: Variant;
    lStr: string;
  begin
    Result := True;
    if RMCmp(Identifier, 'MODALRESULT') then
    begin
      if FCurrentPage is TRMDialogPage then
        TRMDialogPage(FCurrentPage).FForm.ModalResult := aValue;
    end
    else if RMCmp(Identifier, 'PROGRESS') then
    begin
      if MasterReport.FProgressForm <> nil then
        MasterReport.FProgressForm.Label2.Caption := aValue;
      Application.ProcessMessages;
    end
    else if RMCmp(Identifier, 'CurY') then
    begin
      TRMReportPage(CurrentPage).FmmCurrentY := RMToMMThousandths(aValue, rmutScreenPixels);
    end
    else if RMCmp(Identifier, 'SetArray') or RMCmp(Identifier, 'SetVariable') then
    begin
      lVar := Args.Values[1];
      if TVarData(lVar).VType = varString then
        lStr := lVar
      else
        lStr := IntToStr(lVar);

      FDictionary.Variables['Arr_' + Args.Values[0] + '_' + lVar] := aValue;
    end
    else
      Result := False;
  end;

  function _FindFormComponent: Boolean;
  begin
    Result := False;
    if Args.Obj is TRMReport then
    begin
      Result := _IsIntrpFunction;
      if not Result then
        Result := TRMReport(Args.Obj).SetPropValue(Args.Obj, UpperCase(Identifier), aValue);
    end
    else if Args.Obj is TRMView then
    begin
      Result := TRMView(Args.Obj).SetPropValue(Args.Obj, UpperCase(Identifier), aValue);
    end
    else if Args.Obj is TRMCustomPage then
    begin
      Result := TRMCustomPage(Args.Obj).SetPropValue(Args.Obj, UpperCase(Identifier), aValue);
    end;
  end;

begin
  if Args.Obj <> nil then
  begin
    if _FindFormComponent then
    begin
      Done := True;
      Exit;
    end
    else
    begin
      if Assigned(FOnScriptSetValue) then
        FOnScriptSetValue(Sender, Identifier, aValue, Args, Done);
    end;
  end;

  lIndex := FDictionary.Variables.IndexOf(Identifier);
  if lIndex >= 0 then
  begin
    //    FDictionary.Variables[Identifier] := aValue;
    pItem := PRMVariable(FDictionary.Variables.Items.Objects[lIndex]);
    pItem.Value := aValue;
    pItem.IsExpression := False;
    Done := True;
    Exit;
  end;

  if _IsIntrpFunction then
  begin
    Done := True;
    Exit;
  end;

  if Assigned(FOnScriptSetValue) then
    FOnScriptSetValue(Sender, Identifier, aValue, Args, Done);
end;

constructor TRMReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FBusy := False;
  FPrintAtFirstTime := False;
  FCompressType := 1;
  FCompressLevel := rmzcFastest;
  FCompressThread := False;
  FNeedAddBreakedVariable := False;
  FDefaultCopies := 1;

  FShowErrorMsg := True;
  FReportFileExtend := '.rmf';
  FReportFlagStr := 'ReportMachine Report File 3.0';

  DesignerClass := RMDesignerClass;
  FDesigning := False;
  CanPreviewDesign := True;

  FMasterReport := Self;
  FParser := TRMParser.Create;
  FParser.ParentReport := Self;
  FParser.OnGetValue := OnGetVariableValue;
  FParser.OnFunction := OnGetFunction;

  FPages := TRMPages.Create(Self);
  FEndPages := TRMEndPages.Create(Self);
  FSaveReportOptions := TRMSaveReportOptions.Create;
  FSaveReportOptions.FParentReport := Self;
  FPrinter := nil;
  FStatus := rmrsReady;

  FScript := TStringList.Create;

  FScriptEngine := TJvInterpreterFm.Create(nil);
  FScriptEngine.OnGetValue := ScriptEngine_OnGetValue;
  FScriptEngine.OnSetValue := ScriptEngine_OnSetValue;
  FScriptEngine.OnGetUnitSource := ScriptEngine_OnGetUnitSource;
  FScriptEngine.OnGetDfmFileName := ScriptEngine_OnGetDfmFileName;

  FColorPrint := True;
  FShowProgress := True;
  FModalPreview := True;
  FModifyPrepared := False;
  FPreviewButtons := [pbZoom, pbLoad, pbSave, pbPrint, pbFind, pbPageSetup, pbExit, pbSaveToXLS];
  FInitialZoom := pzDefault;
  FShowPrintDialog := True;
  FileName := RMLoadStr(SUntitled);
  FReportFlags := 0;
  AutoSetPageLength := False;
  FReportType := rmrtSimple;

  FVariables := TRMVariables.Create;
  FDictionary := TRMDictionary.Create(Self);

  ScalePageSize := -1;
  ScaleFactor := 100;

  FPreviewOptions := TRMPreviewOptions.Create;

  ConvertNulls := False;
end;

type
  THackPreview = class(TRMPreview)
  end;

destructor TRMReport.Destroy;
begin
  if Assigned(Preview) then
  begin
    THackPreview(Preview).Disconnect;
  end;

  Clear;
  FDictionary.Free;
  FVariables.Free;
  FEndPages.Free;
  FPages.Free;
  FSaveReportOptions.Free;
  FreeProgressForm;
  FParser.Free;
  FScriptEngine.Free;
  FScript.Free;
  FreeAndNil(FTmpBMP);
  FreeAndNil(FPrinter);
  FreeAndNil(FPreviewOptions);

  inherited Destroy;
end;

function TRMReport.ReportClassType: Byte;
begin
  Result := 1;
end;

function TRMReport.ReportCommon: string;
begin
  Result := 'Report';
end;

function TRMReport.IsSecondTime: Boolean;
begin
  Result := MasterReport.DoublePass and MasterReport.FinalPass;
end;

function TRMReport.CreatePage(const aPageClass: string): TRMCustomPage;
begin
  Result := nil;
end;

procedure TRMReport.DoError(E: Exception);
var
  i: Integer;
  s: string;
begin
  ErrorFlag := True;
  ErrorMsg := RMLoadStr(SErrorOccured);
  s := '';
  if FCurrentView <> nil then
  begin
    for i := 0 to FCurrentView.Memo.Count - 1 do
      ErrorMsg := ErrorMsg + #13 + FCurrentView.Memo[i];
    s := RMLoadStr(SObject) + ' ' + FCurrentView.Name + #13;
  end;
  ErrorMsg := ErrorMsg + #13#13 + RMLoadStr(SDoc) + ' ' + Name +
    #13 + s + #13 + E.Message;
  MasterReport.Terminated := True;
end;

function TRMReport.GetDrawCanvas: TCanvas;
begin
  if FTmpBMP = nil then
  begin
    FTmpBMP := TBitmap.Create;
    FTmpBMP.Width := 8;
    FTmpBMP.Height := 8;
  end;
  Result := FTmpBMP.Canvas;
end;

procedure TRMReport.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if aComponent = FDataSet then
      FDataSet := nil
    else if aComponent = FPreview then
      FPreview := nil
    else if aComponent = FDataDictionary then
      FDataDictionary := nil
    else if aComponent = RMDialogForm then
      RMDialogForm := nil;
  end;
end;

procedure TRMReport.Loaded;
begin
  inherited Loaded;
  if FStoreInDFM and (FDFMStream <> nil) then
  begin
    FDFMStream.Position := 0;
    LoadFromStream(FDFMStream);
    FreeAndNil(FDFMStream);
  end;
end;

procedure TRMReport.DefineProperties(aFiler: TFiler);
begin
  inherited DefineProperties(aFiler);
  aFiler.DefineBinaryProperty('ReportData', ReadBinaryData, WriteBinaryData, True);
end;

procedure TRMReport.ReadBinaryData(aStream: TStream);
var
  lSize: Integer;
begin
  if FStoreInDFM then
  begin
    lSize := RMReadInt32(aStream);
    if FDFMStream = nil then
      FDFMStream := TMemoryStream.Create
    else
      FDFMStream.Clear;

    FDFMStream.CopyFrom(aStream, lSize);
  end;
end;

procedure TRMReport.WriteBinaryData(aStream: TStream);
var
  lStream: TMemoryStream;
  lSize: Integer;
begin
  if FStoreInDFM then
  begin
    lStream := TMemoryStream.Create;
    try
      SaveToStream(lStream);
      lStream.Position := 0;
      lSize := lStream.Size;
      RMWriteInt32(aStream, lSize);
      aStream.CopyFrom(lStream, lSize);
    finally
      lStream.Free;
    end;
  end;
end;

procedure TRMReport.Clear;
begin
  FPages.Clear;
  FDictionary.Clear;
  FScript.Clear;
  FDoublePass := False;
end;

function TRMReport.FindObject(aObjectName: string): TRMView;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Pages.Count - 1 do
  begin
    Result := Pages[i].FindObject(aObjectName);
    if Result <> nil then
      Break;
  end;
end;

function TRMReport.ChangePrinter(OldIndex, NewIndex: Integer): Boolean;

  procedure _ChangePages;
  var
    i: Integer;
  begin
    for i := 0 to Pages.Count - 1 do
    begin
      if Pages[i] is TRMReportPage then
      begin
        with TRMReportPage(Pages[i]) do
          ChangePaper(PageSize, PageWidth, PageHeight, PageBin, PageOrientation);
      end;
    end;
  end;

begin
  Result := True;
  try
    ReportPrinter.PrinterIndex := NewIndex;
    FPrinterName := RMPrinters.Printers[GetPrinter.PrinterIndex];
    ReportPrinter.PaperSize := -1;
    _ChangePages;
  except
    on Exception do
    begin
      Windows.MessageBox(0, PChar(RMLoadStr(SPrinterError)), PChar(RMLoadStr(SError)), mb_IconError + mb_Ok);
      ReportPrinter.PrinterIndex := OldIndex;
      FPrinterName := RMPrinters.Printers[GetPrinter.PrinterIndex];
      _ChangePages;
      Result := False;
    end;
  end;
end;

procedure TRMReport.SetScript(Value: TStrings);
begin
  FScript.Assign(Value);
end;

function TRMReport.GetPrinterIndex: Integer;
begin
  Result := ReportPrinter.PrinterIndex;
end;

procedure TRMReport.SetPrinterIndex(aPrinterIndex: Integer);
begin
  { 0:  默认打印机
     1:  虚拟打印机
     2,3,4..:  真实的打印机顺序
   }
  if aPrinterIndex < 0 then aPrinterIndex := 0;

  ReportPrinter.PrinterIndex := aPrinterIndex;
  FPrinterName := ReportPrinter.PrinterName;
end;

procedure TRMReport.SetPrinterName(aPrinterName: string);
var
  lIndex: Integer;
begin
  if RMCmp(aPrinterName, RMDEFAULTPRINTER_NAME) or (aPrinterName = '') then
    lIndex := 0
  else if RMCmp(aPrinterName, RMVIRTUALPRINTER_NAME) then
    lIndex := 1
  else
    lIndex := RMPrinters.Printers.IndexOf(aPrinterName);

  if lIndex < 0 then lIndex := 0;

  ReportPrinter.PrinterIndex := lIndex;
  FPrinterName := aPrinterName;
end;

procedure TRMReport.CreateProgressForm;
begin
  if FProgressForm = nil then
  begin
    FProgressForm := TRMProgressForm.Create(nil);
  end;
  FProgressForm.Init(Self);
end;

procedure TRMReport.FreeProgressForm;
begin
  FreeAndNil(FProgressForm);
end;

function TRMReport.GetPropValue(aObject: TObject; aPropName: string;
  var aValue: Variant; Args: array of Variant): Boolean;
begin
  Result := True;
  if aPropName = 'APPENDBLANKING' then
  begin
    aValue := FFlag_TableEmpty1;
  end
  else if aPropName = 'SPPRINTOFFSETLEFT' then
    aValue := spPrintOffsetLeft
  else if aPropName = 'SPPRINTOFFSETTOP' then
    aValue := spPrintOffsetTop
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

function TRMReport.SetPropValue(aObject: TObject; aPropName: string;
  aValue: Variant): Boolean;
begin
  Result := True;
  if aPropName = 'SPPRINTOFFSETLEFT' then
    spPrintOffsetLeft := aValue
  else if aPropName = 'SPPRINTOFFSETTOP' then
    spPrintOffsetTop := aValue
  else
    Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

procedure TRMReport.InternalOnBeforePrint(Memo: TStrings; View: TRMReportView);
begin
  if View.IsBlobField then
    View.GetBlob;
  if Assigned(FOnBeforePrint) then
    FOnBeforePrint(Memo, View);
end;

procedure TRMReport.InternalOnAfterPrint(const aView: TRMReportView);
begin
  if Assigned(FOnAfterPrint) then
    FOnAfterPrint(aView);
end;

procedure TRMReport.InternalOnBeginColumn(Band: TRMBand);
begin
  if Assigned(FOnBeginColumn) then
    FOnBeginColumn(Band);
end;

procedure TRMReport.InternalOnPrintColumn(aColNo: Integer; var aColWidth: Integer);
var
  lspColWidth: Integer;
begin
  lspColWidth := RMToScreenPixels(aColWidth, rmutMMThousandths);
  if Assigned(FOnPrintColumn) then
  begin
    FOnPrintColumn(aColNo, lspColWidth);
    aColWidth := RMToMMThousandths(lspColWidth, rmutScreenPixels);
  end;
end;

procedure TRMReport.InternalOnBeforePrintBand(aBand: TRMBand; var aPrintBand: Boolean);
begin
  aPrintBand := TRUE;
  if Assigned(FOnBeforePrintBand) then
    FOnBeforePrintBand(aBand, aPrintBand);
end;

procedure TRMReport.InternalOnProgress(Percent: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Percent)
  else if FShowProgress then
  begin
    with MasterReport.FProgressForm do
    begin
      if (MasterReport.DoublePass and MasterReport.FinalPass) or (FCurrentFilter <> nil) then
        Label1.Caption := FirstCaption + '  ' + IntToStr(Percent) + ' ' +
          RMLoadStr(SFrom) + ' ' + IntToStr(MasterReport.FTotalPages)
      else
        Label1.Caption := FirstCaption + '  ' + IntToStr(Percent);
    end;
  end;
  Application.ProcessMessages;
end;

procedure TRMReport.InternalOnExportText(aDrawRect: TRect; x, y: Integer; const text: string;
  View: TRMView);
begin
  FCurrentFilter.OnText(aDrawRect, X, Y, Text, View);
end;

procedure TRMReport.InternalOnGetValue(aView: TRMReportView; aParName: string;
  var aParValue: string; aUnicode: Boolean);
var
  liFormat: TRMFormat;
  liFormatStr: string;
begin
  SubValue := '';
  RMGetFormatStr(aView, aParName, liFormatStr, liFormat);

  FCurrentVariable := aParName;
  if FFlag_TableEmpty then
  begin
    if TVarData(FCurrentValue).VType <> varEmpty then
      VarClear(FCurrentValue);
  end
  else
  begin
    aView.FIsStringValue := True;
    FCurrentValue := 0;
    OnGetVariableValue(aParName, FCurrentValue);
    try
      if aView.HideZeros then
      begin
        if (TVarData(FCurrentValue).VType = varString) or (TVarData(FCurrentValue).VType = varOleStr) then
        begin
          if FCurrentValue = '0' then
            FCurrentValue := '';
        end
        else if (FCurrentValue = 0) then
        begin
          FCurrentValue := '';
          aView.FIsStringValue := False;
        end;
      end;
    except
    end;

    try
	    aParValue := RMFormatValue(FCurrentValue, liFormat, liFormatStr, aUnicode);
    except
      MasterReport.ErrorFlag := True;
    end;
  end;
end;

procedure TRMReport.InternalOnGetDataFieldValue(aView: TRMReportView; aDataSet: TRMDataSet;
  const aField: string; var aParValue: string; aUnicode: Boolean);
var
  lFormat: TRMFormat;
  lFormatStr: string;
  lParName: string;
begin
  SubValue := '';
  lParName := '';
  RMGetFormatStr(aView, lParName, lFormatStr, lFormat);

  if FFlag_TableEmpty then
  begin
    if TVarData(FCurrentValue).VType <> varEmpty then
      VarClear(FCurrentValue);
  end
  else
  begin
    aView.FIsStringValue := True;
    FCurrentValue := aDataSet.GetFieldValue(aField, ConvertNulls);
    try
      if aView.HideZeros then
      begin
        if (TVarData(FCurrentValue).VType = varString) or (TVarData(FCurrentValue).VType = varOleStr) then
        begin
          if FCurrentValue = '0' then
            FCurrentValue := '';
        end
        else if (FCurrentValue = 0) then
        begin
          FCurrentValue := '';
          aView.FIsStringValue := False;
        end;
      end;
    except
    end;

    aParValue := RMFormatValue(FCurrentValue, lFormat, lFormatStr, aUnicode);
  end;
end;

procedure TRMReport.GetIntrpValue(aVariableName: string; var aValue: Variant);
var
  lPos: Integer;
  lObjectName: string;
  t: TRMPersistent;
  lParams: array[0..0] of Variant;
  lObj: TObject;

  function _FindComponent(aOwner: TComponent): Boolean;
  var
    lComponent: TComponent;
  begin
    Result := False;
    lComponent := RMFindComponent(aOwner, lObjectName);
    if lComponent <> nil then
    begin
      lObj := lComponent;
      Result := True;
    end;
  end;

  function _IsReportObject: Boolean;
  var
    i: Integer;
    t: TRMView;
  begin
    Result := False;
    t := FindObject(lObjectName);
    if t <> nil then
    begin
      lObj := t;
      Result := True;
      Exit;
    end;

    for i := 0 to Pages.Count - 1 do
    begin
      if RMCmp(Pages[i].Name, lObjectName) then
      begin
        lObj := Pages[i];
        Result := True;
        Exit;
      end;
    end;

    if RMCmp('Self', lObjectName) or RMCmp('RMCurReport', lObjectName) or
      RMCmp('CurReport', lObjectName) then
    begin
      lObj := Self;
      Result := True;
      Exit;
    end;
  end;

  function _FindForm: Boolean;
  var
    i: Integer;
  begin
    for i := 0 to Screen.CustomFormCount - 1 do
    begin
      if RMCmp(lObjectName, Screen.CustomForms[i].Name) then
      begin
        lObj := Screen.CustomForms[i];
        Result := True;
        Exit;
      end;
    end;

    for i := 0 to Screen.DataModuleCount - 1 do
    begin
      if RMCmp(lObjectName, Screen.DataModules[i].Name) then
      begin
        lObj := Screen.DataModules[i];
        Result := True;
        Exit;
      end;
    end;

    Result := False;
  end;

  function _FindFormComponent: Boolean;
  var
    lComponent: TComponent;
  begin
    if lObj is TComponent then
    begin
      lComponent := RMFindComponent(TComponent(lObj), lObjectName);
      if lComponent <> nil then
      begin
        lObj := lComponent;
        Result := True;
        Exit;
      end;
    end;

    Result := False;
  end;

  function _GetPropValue: Boolean;
  begin
    Result := False;
    if lObj is TRMView then
    begin
      Result := TRMView(lObj).GetPropValue(lObj, UpperCase(aVariableName),
        aValue, lParams);
    end
    else if lObj is TRMReport then
    begin
      Result := TRMReport(lObj).GetPropValue(lObj, UpperCase(aVariableName),
        aValue, lParams);
    end
    else if lObj is TRMCustomPage then
    begin
      Result := TRMCustomPage(lObj).GetPropValue(lObj, UpperCase(aVariableName),
        aValue, lParams);
    end
    else if lObj is TComponent then
    begin
      RM_Common.RMGetPropValue_1(lObj, aVariableName, aValue);
    end;
  end;

begin
  t := FCurrentView;
  lObj := nil;
  lPos := Pos('.', aVariableName);
  while lPos > 0 do
  begin
    t := nil;
    lObjectName := Copy(aVariableName, 1, lPos - 1);
    Delete(aVariableName, 1, lPos);
    lPos := Pos('.', aVariableName);

    if lObj <> nil then
    begin
      if not _FindFormComponent then
      begin
        lObj := nil;
        Break;
      end;
    end
    else if _IsReportObject then
    begin
    end
    else if _FindForm then
    begin
    end
    else if _FindComponent(Owner) then
    begin
    end
    else
    begin
      lObj := nil;
      Break;
    end;
  end;

  if lObj <> nil then
    _GetPropValue
  else if t <> nil then
    THackView(t).GetPropValue(t, UpperCase(aVariableName), aValue, lParams);
end;

{procedure TRMReport.GetIntrpValue(aVariableName: string; var aValue: Variant);
var
  t: TRMPersistent;
  lParams: array[0..0] of Variant;

  procedure _ParseObjectName(aReport: TRMReport; var aPropName: string;
    var t: TRMPersistent);
    // aPropName='Font.Color'
  var
    i, lPos: Integer;
    lObjectName: string;
  begin
    t := nil;
    lPos := Pos('.', aPropName);
    if lPos > 0 then
    begin
      lObjectName := Copy(aPropName, 1, lPos - 1);
      Delete(aPropName, 1, lPos);
      for i := 0 to aReport.Pages.Count - 1 do
      begin
        if RMCmp(lObjectName, aReport.Pages[i].Name) then
        begin
          t := aReport.Pages[i];
          Exit;
        end;
      end;

      if RMCmp(lObjectName, 'Self') or RMCmp(lObjectName, 'Report') or
        RMCmp(lObjectName, 'CurReport') or RMCmp(lObjectName, 'RMCurReport') then
      begin
        Self.GetPropValue(t, UpperCase(aVariableName), aValue, lParams);
      end
      else
        t := aReport.FindObject(lObjectName);
    end
    else
      t := aReport.FCurrentView;
  end;

begin
  _ParseObjectName(Self, aVariableName, t);
  if t <> nil then
  begin
    THackView(t).GetPropValue(t, UpperCase(aVariableName), aValue, lParams);
  end;
end;}

procedure TRMReport.OnGetVariableValue(aVariableName: string; var aValue: Variant);
var
  str: string;
  lFound: Boolean;
  lParams: array[0..1] of Variant;
begin
  if aVariableName = '' then Exit;
  if TVarData(aValue).VType <> varEmpty then VarClear(aValue);
  TVarData(aValue).VType := varEmpty;
  if Assigned(FOnGetValue) then FOnGetValue(aVariableName, aValue);

  if TVarData(aValue).VType <> varEmpty then Exit;

  aValue := 0;
  if FDictionary.IsVariable(aVariableName) then
    aValue := FDictionary.Value[aVariableName]
  else if not IsGetSystemVariables(aVariableName, aValue) then
  begin
    if RMVariables.IndexOf(aVariableName) >= 0 then
      aValue := RMVariables[aVariableName]
    else if FVariables.IndexOf(aVariableName) >= 0 then
      aValue := FVariables[aVariableName]
    else
    begin
      if TVarData(aValue).VType <> varEmpty then VarClear(aValue);

      TVarData(aValue).VType := varEmpty;
      GetIntrpValue(aVariableName, aValue);
      if TVarData(aValue).VType = varEmpty then
      begin
        if aVariableName <> SubValue then
        begin
          SubValue := aVariableName;
          if FDictionary.IsExpr(aVariableName) then
          begin
            aValue := Parser.CalcOPZ(FDictionary.OPZExpr(aVariableName));
            SubValue := '';
          end
          else
          begin
            str := Parser.Str2OPZ(aVariableName);
            if (str <> aVariableName) and (str <> aVariableName + ' ') then
            begin
              FDictionary.AddExprCacheItem(aVariableName, str);
            end;

            aValue := Parser.CalcOPZ(str);
            SubValue := '';
          end;
        end
        else if InDictionary then
          aValue := aVariableName
        else
        begin
          OnGetFunction(aVariableName, lParams, aValue, lFound);
          if not lFound then
          begin
            if FNeedAddBreakedVariable then
              aValue := '[' + aVariableName + ']'
            else
              aValue := null;
          end;
          //Modify by lbz
//            raise(EParserError.Create(RMLoadStr(SUndefinedSymbol) + ' "' + SubValue + '"'));
        end;
      end;
    end;
  end;
end;

procedure TRMReport.OnGetFunction(aFunctionName: string; aParams: array of Variant;
  var aValue: Variant; var aFound: Boolean);
var
  i: Integer;
begin
  aFound := False;
  for i := 0 to RMAddInFunctionCount - 1 do
  begin
    if RMAddInFunctions(i).OnFunction(Parser, aFunctionName, aParams, aValue) then
    begin
      aFound := True;
      Exit;
    end;
  end;

  if Assigned(FOnUserFunction) then
  begin
    FOnUserFunction(aFunctionName, aParams, aValue, aFound);
  end;
end;

procedure TRMReport.DoBuildReport(aFirstTime, aFinalPass: Boolean);
var
  i: Integer;

  procedure _ShowProgressForm;
  begin
    if not Assigned(FOnProgress) and FShowProgress then
    begin
      if ReportInfo.Title = '' then
        MasterReport.FProgressForm.Caption := RMLoadStr(SReportPreparing)
      else
        MasterReport.FProgressForm.Caption := RMLoadStr(SReportPreparing) + ' - ' + ReportInfo.Title;
      if FFinalPass then
        MasterReport.FProgressForm.FirstCaption := RMLoadStr(SPagePreparing)
      else
        MasterReport.FProgressForm.FirstCaption := RMLoadStr(SFirstPass);

      MasterReport.FProgressForm.Label1.Caption := MasterReport.FProgressForm.FirstCaption + '  1';
      MasterReport.FProgressForm.Show;
    end;
  end;

  // 判断是否打印到前一页
  procedure _SetAppendFlag(aLastPage: TRMCustomPage; aPageIndex: Integer);
  var
    i: Integer;
    liNextPage: TRMCustomPage;
  begin
    liNextPage := nil;
    for i := aPageIndex to Pages.Count - 1 do
    begin
      if Pages[i] is TRMReportPage then
      begin
        liNextPage := Pages[i];
        Break;
      end;
    end;

    if (MasterReport.FCompositeMode and (FCurrentPage = aLastPage)) or
      ((liNextPage <> nil) and liNextPage.PrintToPrevPage) then
    begin
      Dec(MasterReport.FPageNo);
      MasterReport.FAppendFlag := True;
    end
    else
      MasterReport.FAppendFlag := False;

    if not MasterReport.FAppendFlag then
    begin
      MasterReport.FPageNo := MasterReport.EndPages.Count;
      InternalOnProgress(FPageNo);
    end;
  end;

  procedure _SetAutoPageHeight; // 自动设置页面高度
  var
    lEndPage: TRMEndPage;

    function _GetMaxHeight: Integer;
    var
      i: Integer;
      t: TRMView;
    begin
      Result := 0;
      for i := 0 to lEndPage.Page.Objects.Count - 1 do
      begin
        t := lEndPage.Page.Objects[i];
        if t.spTop + t.spHeight > Result then
          Result := t.spTop + t.spHeight;
      end;
      Result := Result + lEndPage.spMarginTop + 1;
    end;

  begin
    if not AutoSetPageLength then Exit;

    lEndPage := MasterReport.EndPages[MasterReport.EndPages.Count - 1];
    lEndPage.StreamToObjects(Self, False);
    try
      lEndPage.FmmMarginBottom := 0;
      lEndPage.FPageSize := 256;
      lEndPage.PrinterInfo.PageHeight := _GetMaxHeight;
      lEndPage.FPageHeight := RMToMMThousandths(lEndPage.PrinterInfo.PageHeight, rmutScreenPixels) div 100;
    finally
      lEndPage.RemoveCachePage;
    end;
  end;

  procedure _BuildReport;
  var
    i: Integer;
    liLastPage: TRMCustomPage;
    lIsMulitipleReport: Boolean;
  begin
    lIsMulitipleReport := (Dataset <> nil) and (ReportType = rmrtMultiple);
    if lIsMulitipleReport then
    begin
      Dataset.Init;
      Dataset.First;
    end;

    if not FFinalPass then
    begin
      FHookList.Clear;
      FDontShowReport := False;
      for i := 0 to Pages.Count - 1 do
        Pages[i].FIsSubReportPage := False;
    end;

    for i := 0 to Pages.Count - 1 do
      Pages[i].FParentPage := nil;
    for i := 0 to Pages.Count - 1 do
    begin
      if Pages[i] is TRMDialogPage then
        Pages[i].PreparePage;
      if FDontShowReport then
        Break;
    end;

    try
      if not FDontShowReport then
      begin
        for i := 0 to Pages.Count - 1 do
        begin
          if Pages[i] is TRMReportPage then
            Pages[i].PreparePage;
        end;
        if not MasterReport.ErrorFlag then
        begin
          for i := 0 to Pages.Count - 1 do
          begin
            if Pages[i] is TRMReportPage then
              TRMReportPage(Pages[i]).PrepareAggrObjects;
          end;
        end;

        if not MasterReport.ErrorFlag then
        begin
          repeat
            InternalOnProgress(MasterReport.FPageNo + 1);
            liLastPage := nil;
            for i := Pages.Count - 1 downto 0 do
            begin
              if Pages[i] is TRMReportPage then
              begin
                liLastPage := Pages[i];
                Break;
              end;
            end;

            for i := 0 to Pages.Count - 1 do
            begin
              FCurrentPage := Pages[i];
              FCurrentPage.FPageNumber := i + 1;
              TRMReportPage(FCurrentPage).FCurrentEndPages := nil;
              if not FCurrentPage.Visible then
              begin
                if Assigned(FCurrentPage.FOnActivate) then
                  FCurrentPage.FOnActivate(FCurrentPage);
              end;
              if (not FCurrentPage.Visible) or FCurrentPage.FIsSubReportPage or (FCurrentPage is TRMDialogPage) then
                Continue;

              MasterReport.EndPages.AddbkPicture(TRMReportPage(FCurrentPage).spBackGroundLeft,
                TRMReportPage(FCurrentPage).spBackGroundTop,
                TRMReportPage(FCurrentPage).bkPictureWidth,
                TRMReportPage(FCurrentPage).bkPictureHeight,
                TRMReportPage(FCurrentPage).FbkPicture);
              TRMReportPage(FCurrentPage).FCurrentEndPages := MasterReport.EndPages;
              TRMReportPage(FCurrentPage).FStartPageNo := MasterReport.FPageNo;
              TRMReportPage(FCurrentPage).FPrintChildTypeSubReportPage := False;
              TRMReportPage(FCurrentPage).PrintPage;

              _SetAppendFlag(liLastPage, i + 1); // 确定是否打印到前一页
              InternalOnProgress(MasterReport.FPageNo);
            end;

            if lIsMulitipleReport then
              Dataset.Next;
          until MasterReport.Terminated or (not lIsMulitipleReport) or Dataset.Eof;
        end; // if not MasterReport.ErrorFlag

        if MasterReport.EndPages.Count > 0 then
        begin
          if MasterReport = Self then
            MasterReport.EndPages[MasterReport.EndPages.Count - 1].AfterEndPage;
          _SetAutoPageHeight;
          for i := Pages.Count - 1 downto 0 do
          begin
            if Pages[i] is TRMReportPage then
            begin
              liLastPage := Pages[i];
              if (TRMReportPage(liLastPage).AutoHCenter or TRMReportPage(liLastPage).AutoVCenter) and
                (MasterReport.EndPages.Count > 0) then
                TRMReportPage(liLastPage).AutoCenterObjects(MasterReport.EndPages.Count - 1);
              Break;
            end;
          end;
        end;

      end; // if not FDontShowReport
    finally
      for i := 0 to Pages.Count - 1 do
      begin
        if Pages[i] is TRMReportPage then
          Pages[i].UnPreparePage;
      end;
      for i := 0 to Pages.Count - 1 do
      begin
        if Pages[i] is TRMDialogPage then
          Pages[i].UnPreparePage;
      end;

      if lIsMulitipleReport then
        Dataset.Exit;
    end;
  end;

  function _BuildTmpObjectsFirst: Boolean;
  var
    lStr: string;
  begin
    Result := False;
    lStr := UpperCase(FScript.Text);
    if Pos('.ONBEFORECREATEOBJECTS', lStr) > 0 then
      Result := True
    else if Pos('.ONAFTERCREATEOBJECTS', lStr) > 0 then
      Result := True;
  end;

begin
  FFlag_TableEmpty := False;
  FFlag_TableEmpty1 := False;
  RMCurReport := Self;
  FHookList := TList.Create;
  FCurrentBand := nil;
  FCurrentPage := nil;
  FOnBeginReport := nil;
  FOnEndReport := nil;
  FScriptEngine.Pas.Assign(FScript);
  try
    try
      if aFirstTime then
      begin
        if FScriptEngine.Pas.Count > 1 then
          FScriptEngine.Compile;

        if _BuildTmpObjectsFirst then
        begin
          if FScriptEngine.Pas.Count > 1 then
          begin
            FScriptEngine.Run;
          end;

          for i := 0 to Pages.Count - 1 do
          begin
            Pages[i].BuildTmpObjects;
          end;
        end
        else
        begin
          for i := 0 to Pages.Count - 1 do
          begin
            Pages[i].BuildTmpObjects;
          end;

          if FScriptEngine.Pas.Count > 1 then
          begin
            FScriptEngine.Run;
          end;
        end;
      end;

      FDontShowReport := False;
      FCurrentBand := nil;
      FCurrentPage := nil;
      Application.ProcessMessages;
      CanRebuild := True;
      FDocMode := rmdmPreviewing;
      FFinalPass := aFinalPass;
      FEndPages.Clear;
      FPageNo := 0;
      FDictionary.ClearCache;

      if Assigned(FOnBeginReport) then
        FOnBeginReport(Self);

      _ShowProgressForm;

      _BuildReport;

      MasterReport.FTotalPages := FEndPages.Count;

      if Assigned(FOnEndReport) then
      begin
        FOnEndReport(Self);
        FOnEndReport := nil;
      end;
    except
      on E: EJvInterpreterError do
      begin
        ErrorMsg := 'Script Error:' + #13#10 + IntToStr(E.ErrCode) + ': ' + E.Message;
        if E.ErrPos > -1 then
        begin
          ErrorMsg := ErrorMsg + #13#10 + 'at Postion:' + IntToStr(E.ErrPos);
        end;
        Terminated := True;
        ErrorFlag := True;
      end;
    else
      Terminated := True;
      ErrorFlag := True;
      if FScriptEngine.LastError.ErrCode > 0 then
      begin
        ErrorMsg := 'Script Error:' + #13#10 + FScriptEngine.LastError.Message;
      end;
    end;
  finally
    FreeAndNil(FHookList);
    FOnBeginReport := nil;
    FOnEndReport := nil;

    if Assigned(FOnEndReport) then
    begin
      FOnEndReport(Self);
      FOnEndReport := nil;
    end;
  end;
end;

function TRMReport.PrepareReport: Boolean;
var
  lReportList: TList;
  lSaveCompressLevel: TRMCompressionLevel;

  function _HaveCross: Boolean;
  var
    i, j: Integer;
    t: TRMView;
  begin
    Result := False;
    if CompressLevel <> rmzcNone then
    begin
      for i := 0 to Pages.Count - 1 do
      begin
        for j := 0 to Pages[i].Objects.Count - 1 do
        begin
          t := Pages[i].Objects[j];
          if t.IsCrossView or t.IsCrossBand then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;

  procedure _SaveReport;
  var
    i: Integer;
    lStream: TMemoryStream;
    lReport: TRMReport;
  begin
    lReportList := TList.Create;
    if Self is TRMCompositeReport then
    begin
      for i := 0 to TRMCompositeReport(Self).Reports.Count - 1 do
      begin
        lStream := TMemoryStream.Create;
        lReportList.Add(lStream);
        lReport := TRMReport(TRMCompositeReport(Self).Reports[i]);
        lReport.SaveToStream(lStream);
        if Assigned(lReport.FOnBeginDoc) then
          lReport.FOnBeginDoc(lReport);
      end;
    end
    else
    begin
      lStream := TMemoryStream.Create;
      lReportList.Add(lStream);
      SaveToStream(lStream);
    end;
  end;

  procedure _RestoreReport;
  var
    i: Integer;
    lSaveErrorFlag: Boolean;
    lSaveErrorMsg: string;
    lStream: TMemoryStream;
    lReport: TRMReport;
  begin
    lSaveErrorFlag := ErrorFlag;
    lSaveErrorMsg := ErrorMsg;
    try
      if Self is TRMCompositeReport then
      begin
        for i := 0 to TRMCompositeReport(Self).Reports.Count - 1 do
        begin
          lStream := lReportList[i];
          lStream.Position := 0;
          lReport := TRMReport(TRMCompositeReport(Self).Reports[i]);
          if Assigned(lReport.FOnEndDoc) then
            lReport.FOnEndDoc(lReport);
          lReport.LoadFromStream(lStream);
        end;
      end
      else
      begin
        lStream := lReportList[0];
        lStream.Position := 0;
        LoadFromStream(lStream);
      end;
    finally
      for i := 0 to lReportList.Count - 1 do
      begin
        TMemoryStream(lReportList[i]).Free;
      end;
      lReportList.Free;
      lReportList := nil;
      ErrorFlag := lSaveErrorFlag;
      ErrorMsg := lSaveErrorMsg;
    end;
  end;

  procedure _ChangePagesPos;
  var
    i, lIndex: Integer;
    lOldPageNumber, lPageOffset, lNowPageNumber: Integer;
  begin
    lOldPageNumber := 1;
    lPageOffset := 0;
    for i := 0 to FEndPages.Count - 1 do
    begin
      lNowPageNumber := FEndPages[i].PageNumber;
      if lNowPageNumber > 1 then
      begin
        if lOldPageNumber <> lNowPageNumber then
        begin
          lPageOffset := i;
          lOldPageNumber := lNowPageNumber;
        end;
        lIndex := (i - lPageOffset) * FPages.Count + lNowPageNumber - 1;
        if lIndex < FEndPages.FPages.Count then
          FEndPages.FPages.Exchange(i, lIndex);
      end;
    end;
  end;

  procedure _DoBuildReport;
  var
    i, lCount: INteger;
  begin
    if DoublePass then lCount := 2 else lCount := 1; // 两次报表

    MasterReport.FPageNo := 0;
    MasterReport.FAppendFlag := False;
    MasterReport.ErrorFlag := False;
    i := 1;
    while (i <= lCount) and (not MasterReport.Terminated) and (not MasterReport.ErrorFlag) do
    begin
      FEndPages.Clear;
      FFinalPass := i = (lCount);
      DoBuildReport(i = 1, FFinalPass);
      Inc(i);
    end;
  end;

begin
  Result := False;
  if FBusy then Exit;

  FBusy := True;
  lSaveCompressLevel := CompressLevel;
  try
    RMCurReport := Self;
    lReportList := nil;
    FMasterReport := Self;
    FCurrentBand := nil;
    FCurrentPage := nil;
    ErrorFlag := False;
    ErrorMsg := '';
    Terminated := False;
    Flag_PrintBackGroundPicture := True;
    FFlag_TableEmpty := False;
    FFlag_TableEmpty1 := False;
    FParser.InScript := False;
    FCurrentDate := Date;
    FCurrentTime := Time;
    FCurrentDateTime := SysUtils.Now;
    SetPrinterName(FPrinterName);
    MasterReport.FAppendFlag := False;
    FPageNo := 0;
    FEndPages.Clear;

    if not Assigned(FOnProgress) and FShowProgress then
      CreateProgressForm;

    _SaveReport;
    if _HaveCross then
      CompressLevel := rmzcNone;

    FEndPages.FStreamCompressed := CompressLevel <> rmzcNone;
    FEndPages.FStreamCompressType := FCompressType;
    if Assigned(FOnBeginDoc) then FOnBeginDoc(Self);
    _DoBuildReport;
    if Assigned(FOnEndDoc) then FOnEndDoc(Self);
  finally
    FreeProgressForm;
    _RestoreReport;

    FCurrentBand := nil;
    FCurrentPage := nil;
    Result := not ErrorFlag;
    CompressLevel := lSaveCompressLevel;
    if not Result then
    begin
      EndPages.Clear;
      if FShowErrorMsg then
        Application.MessageBox(PChar(ErrorMsg), PChar(RMLoadStr(SError)),
          mb_Ok + mb_IconError);
    end
    else
    begin
      if (FPageCompositeMode = rmPagePerPage) and (EndPages.Count > 0) and (FPages.Count > 1) then
        _ChangePagesPos;
    end;

    FBusy := False;
  end;
end;

procedure TRMReport.NewReport;
begin
  Clear;
  FColorPrint := True;
  PrintbackgroundPicture := False;
  PrintOffsetLeft := 0;
  PrintOffsetTop := 0;
  FileName := RMLoadStr(SUntitled);
  FReportFlags := 0;
  AutoSetPageLength := False;

  ReportInfo.Title := '';
  ConvertNulls := False;
end;

function TRMReport.DesignReport: Boolean;
var
  liSavePreview: TRMCustomPreview;
begin
  RMCurReport := Self;
  Result := False;
  if Self is TRMCompositeReport then Exit;
  FMasterReport := Self;
  SetPrinterName(FPrinterName);

  liSavePreview := FPreview;
  try
    if DesignerClass <> nil then
    begin
      FDesigning := True;
      DocMode := rmdmDesigning;
      RMDesigner := TRMReportDesigner(DesignerClass.NewInstance);
      RMDesigner.Create(nil);
      RMDesigner.FReport := Self;
      RMDesigner.IsPreviewDesign := False;
      RMDesigner.IsPreviewDesignReport := False;
      RMDesigner.ShowModifyToolbar := False;
      FDesigner := RMDesigner;
      Result := (RMDesigner.ShowModal = mrOK);
    end;
  finally
    FDesigner := nil;
    FDesigning := False;
    FPreview := liSavePreview;
    FreeAndNil(RMDesigner);
    RMDialogForm.Visible := False;
  end;
end;

procedure TRMReport.ShowReport;
//var
//  tmp: Longint;
begin
  //  tmp := GetTickCount;

  PrepareReport;

  //  ShowMessage(IntToStr(GetTickCount - tmp));

  ShowPreparedReport;
end;

procedure TRMReport.PrintPreparedReportDlg;
var
  liNeedSave: Boolean;
  liPages: string;
  tmp: TRMPrintDialogForm;
begin
  ScalePageSize := -1;
  ScaleFactor := 100;
  Flag_PrintBackGroundPicture := True;
  if (EndPages = nil) or (RMPrinters.Printers.Count = 2) then Exit;

  if Preview <> nil then
    Preview.Print
  else
  begin
    tmp := TRMPrintDialogForm.Create(nil);
    try
      tmp.CurrentPrinter := ReportPrinter;
      tmp.rbdPrintCurPage.Enabled := False;
      tmp.Copies := FDefaultCopies;
      tmp.chkCollate.Checked := FDefaultCollate;
      tmp.chkTaoda.Checked := PrintbackgroundPicture;
      tmp.chkColorPrint.Checked := ColorPrint;
      tmp.PrintOffsetTop := PrintOffsetTop;
      tmp.PrintOffsetLeft := PrintOffsetLeft;
      if not FShowPrintDialog or (tmp.ShowModal = mrOk) then
      begin
        if not FShowPrintDialog then // Modify by sinmax
        begin
          if tmp.CurrentPrinter.PrinterIndex = 1 then
            tmp.CurrentPrinter.PrinterIndex := 0;
          tmp.ChangeVirtualPrinter;
        end;

        ScaleFactor := tmp.ScaleFactor;
        Flag_PrintBackGroundPicture := not tmp.chkTaoda.Checked;
        ColorPrint := tmp.chkColorPrint.Checked;

        liNeedSave := (PrintOffsetTop <> tmp.PrintOffsetTop) or (PrintOffsetLeft <> tmp.PrintOffsetLeft);
        PrintOffsetTop := tmp.PrintOffsetTop;
        PrintOffsetLeft := tmp.PrintOffsetLeft;
        tmp.GetPageInfo(Self.ScalePageWidth, Self.ScalePageHeight, Self.ScalePageSize);
        if tmp.rdbPrintAll.Checked then
          liPages := ''
        else
          liPages := tmp.edtPages.Text;

        if liNeedSave then
          SaveReportOptions.SaveReportSetting(Self, '');

        PrintPreparedReport(liPages, tmp.Copies, tmp.chkCollate.Checked,
          TRMPrintPages(tmp.cmbPrintAll.ItemIndex));
      end;
    finally
      tmp.Free;
    end;
  end;
end;

procedure TRMReport.PrintPreparedReport(aPageNumbers: string; aCopies: Integer;
  aCollate: Boolean; aPrintPages: TRMPrintPages);
var
  s: string;

  procedure _ParsePageNumbers(apgList: TStrings);
  var
    i, j, n1, n2: Integer;
    s: string;
    liIsRange: Boolean;
  begin
    s := aPageNumbers;
    while Pos(' ', s) <> 0 do
      Delete(s, Pos(' ', s), 1);
    if s = '' then Exit;

    if s[Length(s)] = '-' then
      s := s + IntToStr(EndPages.Count);
    s := s + ',';
    i := 1;
    j := 1;
    n1 := 1;
    liIsRange := False;
    while i <= Length(s) do
    begin
      if s[i] = ',' then
      begin
        n2 := StrToInt(Copy(s, j, i - j));
        j := i + 1;
        if liIsRange then
        begin
          while n1 <= n2 do
          begin
            apgList.Add(IntToStr(n1));
            Inc(n1);
          end;
        end
        else
          apgList.Add(IntToStr(n2));
        liIsRange := False;
      end
      else if s[i] = '-' then
      begin
        liIsRange := True;
        n1 := StrToInt(Copy(s, j, i - j));
        j := i + 1;
      end;
      Inc(i);
    end;
  end;

  procedure _DoPrintReport;
  var
    i, j: Integer;
    lipgList: TStringList;
    lPrinter: TRMPrinter;
    liNeedNewPage: Boolean;
    lFactorX, lFactorY: Double;
    lSavePrintInfo: TRMPageInfo;
    lOldPageNumber: Integer;
    lPageWidth, lPageHeight: Integer;

    function _CanPrint(aPageIndex: Integer): Boolean;
    begin
      Result := False;
      {$IFDEF TrialVersion}
      if aPageIndex >= EndPages.Count then Exit;
      {$ENDIF}
      if (lipgList.Count > 0) and (lipgList.IndexOf(IntToStr(aPageIndex + 1)) < 0) then Exit;
      if ((aPrintPages = rmppOdd) and ((aPageIndex + 1) mod 2 = 1)) or
        ((aPrintPages = rmppEven) and ((aPageIndex + 1) mod 2 = 0)) then Exit;
      Result := True;
    end;

    procedure _PrintOnePage(aPageIndex: Integer);
    var
      liRect: TRect;
      lbkPic: TRMbkPicture;
      lPicWidth, lPicHeight: Integer;
      lPicFactorX, lPicFactorY: Double;
      lPageSize, lPageWidth, lPageHeight: Integer;
    begin
      {$IFDEF TrialVersion}
      MessageDlg('Unregistered evaluation copy of ReportMachine', mtWarning, [mbOK], 0);
      {$ENDIF}
      with EndPages[aPageIndex] do
      begin
        if Self.ScalePageSize >= 0 then
        begin
          lPageSize := Self.ScalePageSize;
          if PageOrientation = rmpoPortrait then
          begin
            lPageWidth := Self.ScalePageWidth;
            lPageHeight := Self.ScalePageHeight;
          end
          else
          begin
            lPageWidth := Self.ScalePageHeight;
            lPageHeight := Self.ScalePageWidth;
          end;
        end
        else
        begin
          lPageSize := PageSize;
          lPageWidth := PageWidth;
          lPageHeight := PageHeight;
        end;

        if (liNeedNewPage and (FPageNumber <> lOldPageNumber) and FNewPrintJob) or
          (not lPrinter.IsEqual(lPageSize, lPageWidth, lPageHeight, PageBin, PageOrientation, Duplex)) then
        begin
          lPrinter.EndDoc;
          lPrinter.ColorPrint := ColorPrint;
          lPrinter.Duplex := Duplex;
          lPrinter.SetPrinterInfo(lPageSize, lPageWidth, lPageHeight, PageBin, PageOrientation, True);
          if Self.ScalePageSize >= 0 then
          begin
            lFactorX := lPageWidth / PageWidth;
            lFactorY := lPageHeight / PageHeight;
          end;
          lPrinter.BeginDoc;
        end
        else if liNeedNewPage then
        begin
          lSavePrintInfo := PrinterInfo;
          lPrinter.EndPage;
        end;

        lPrinter.NewPage;
        lPrinter.FillPrinterInfo(PrinterInfo);

        if Self.ScalePageSize < 0 then
        begin
          lFactorX := 1;
          lFactorY := 1;
        end;

        // 打印背景图片
        lbkPic := EndPages.bkPictures[bkPictureIndex];
        if Flag_PrintBackGroundPicture and (lbkPic <> nil) and (lbkPic.FPicture.Graphic <> nil) then
        begin
          lPicFactorX := PrinterInfo.PrinterPageWidth / PrinterInfo.PageWidth * 100 / ScaleFactor;
          lPicFactorY := PrinterInfo.PrinterPageHeight / PrinterInfo.PageHeight * 100 / ScaleFactor;
          if Self.ScalePageSize >= 0 then
          begin
            lPicFactorX := lPicFactorX * lFactorX;
            lPicFactorY := lPicFactorY * lFactorY;
          end;
          lPicWidth := lbkPic.Width;
          lPicHeight := lbkPic.Height;
          liRect := Rect(0, 0, Round(lPicWidth * lPicFactorX), Round(lPicHeight * lPicFactorY));
          OffsetRect(liRect, Round(lbkPic.FLeft * lPicFactorX), Round(lbkPic.FTop * lPicFactorY));
          OffsetRect(liRect, -PrinterInfo.PrinterOffsetX, -PrinterInfo.PrinterOffsetY);
          RMPrintGraphic(lPrinter.Canvas, liRect, lbkPic.FPicture.Graphic, True, True, False);
        end;

        // 打印内容
        liRect := Rect(0, 0, Round(PrinterInfo.PrinterPageWidth * ScaleFactor / 100 * lFactorX), Round(PrinterInfo.PrinterPageHeight * ScaleFactor / 100 * lFactorY));
        OffsetRect(liRect, -Round(PrinterInfo.PrinterOffsetX * lFactorX), -Round(PrinterInfo.PrinterOffsetY * lFactorY));
        OffsetRect(liRect, Round(spPrintOffsetLeft * lPrinter.FactorX * lFactorX), Round(spPrintOffsetTop * lPrinter.FactorY * lFactorY)); // 设置打印机偏移

        Draw(MasterReport, lPrinter.Canvas, liRect);
        RemoveCachePage;
        PrinterInfo := lSavePrintInfo;
      end;

      InternalOnProgress(aPageIndex + 1);
      Application.ProcessMessages;
      liNeedNewPage := True;
      lOldPageNumber := aPageIndex;
    end;

  begin
    lPrinter := ReportPrinter;
    lipgList := TStringList.Create;
    try
      _ParsePageNumbers(lipgList);
      if ReportInfo.Title <> '' then
        lPrinter.Title := ReportInfo.Title
      else if FileName <> '' then
        lPrinter.Title := ExtractFileName(FileName)
      else
        lPrinter.Title := RMLoadStr(SUntitled);

      if Assigned(FOnPrintReportEvent) then
        FOnPrintReportEvent(Self);

      liNeedNewPage := False;
      lPrinter.Copies := 1; // 设置打印份数

      with FEndPages[0] do
      begin
        lSavePrintInfo := PrinterInfo;
        lPrinter.ColorPrint := ColorPrint;
        lPrinter.Duplex := Duplex;
        if Self.ScalePageSize >= 0 then
        begin
          if PageOrientation = rmpoPortrait then
          begin
            lPageWidth := Self.ScalePageWidth;
            lPageHeight := Self.ScalePageHeight;
          end
          else
          begin
            lPageWidth := Self.ScalePageHeight;
            lPageHeight := Self.ScalePageWidth;
          end;
          lPrinter.SetPrinterInfo(Self.ScalePageSize, lPageWidth, lPageHeight, PageBin, PageOrientation, True);
          lFactorX := lPageWidth / PageWidth;
          lFactorY := lPageHeight / PageHeight;
        end
        else
          lPrinter.SetPrinterInfo(PageSize, PageWidth, PageHeight, PageBin, PageOrientation, True);
        lPrinter.FillPrinterInfo(PrinterInfo);
      end;

      lPrinter.BeginDoc;
      if aCollate then
      begin
        i := 0;
        while (i < aCopies) and (not Terminated) do
        begin
          {$IFDEF TrialVersion}
          if _CanPrint(0) then
          begin
            _PrintOnePage(0);
          end;

          if _CanPrint(1) then
          begin
            _PrintOnePage(1);
          end;
          {$ELSE}
          j := 0;
          while (j < EndPages.Count) and (not Terminated) do
          begin
            if _CanPrint(j) then
            begin
              _PrintOnePage(j);
              if Assigned(FOnEndPrintPage) then
              begin
                lPrinter.EndDoc;
                lPrinter.BeginDoc;
                FOnEndPrintPage(j);
              end;
            end;
            Inc(j);
          end;
          {$ENDIF}
          Inc(i);
        end;
      end
      else
      begin
        {$IFDEF TrialVersion}
        if _CanPrint(0) then
        begin
          j := 0;
          while (j < aCopies) and (not Terminated) do
          begin
            _PrintOnePage(0);
            Inc(j);
          end;
        end;

        if _CanPrint(1) then
        begin
          j := 0;
          while (j < aCopies) and (not Terminated) do
          begin
            _PrintOnePage(1);
            Inc(j);
          end;
        end;
        {$ELSE}
        i := 0;
        while (i < EndPages.Count) and (not Terminated) do
        begin
          if _CanPrint(i) then
          begin
            j := 0;
            while (j < aCopies) and (not Terminated) do
            begin
              _PrintOnePage(i);
              Inc(j);
            end;

            if Assigned(FOnEndPrintPage) then
            begin
              lPrinter.EndDoc;
              lPrinter.BeginDoc;
              FOnEndPrintPage(i);
            end;
          end;
          Inc(i);
        end;
        {$ENDIF}
      end;
    finally
      if Terminated then
        lPrinter.Abort;
      lPrinter.EndDoc;
      lipgList.Free;
    end;
  end;

begin
  RMCurReport := Self;
  if (FStatus <> rmrsReady) or (EndPages = nil) then Exit;

  if EndPages.Count < 1 then
  begin
    ScalePageSize := -1;
    ScaleFactor := 100;
    Exit;
  end;

  FMasterReport := Self;
  s := RMLoadStr(SReportPreparing);
  Terminated := False;
  FStatus := rmrsBusy;
  try
    if not Assigned(FOnProgress) and FShowProgress then
    begin
      CreateProgressForm;
      if ReportInfo.Title = '' then
        MasterReport.FProgressForm.Caption := s
      else
        MasterReport.FProgressForm.Caption := s + ' - ' + ReportInfo.Title;
      MasterReport.FProgressForm.FirstCaption := RMLoadStr(SPagePrinting);
      MasterReport.FProgressForm.Label1.Caption := MasterReport.FProgressForm.FirstCaption;
      MasterReport.FProgressForm.Show;
    end;

    _DoPrintReport;
  finally
    FreeProgressForm;
    Flag_PrintBackGroundPicture := True;
    ScalePageSize := -1;
    ScaleFactor := 100;
    FStatus := rmrsReady;
    DocMode := rmdmNone;
  end;
end;

procedure TRMReport.PrintReport;
var
  lSavePrinterName: string;
  lSavePreview: TRMCustomPreview;
  lNeedSave: Boolean;
  lPages: string;
  lCopies: Integer;
  lCollate: Boolean;
  lPrintPages: TRMPrintPages;

  function _ShowPrintReportDlg: Boolean;
  var
    tmp: TRMPrintDialogForm;
  begin
    Result := False;
    ScalePageSize := -1;
    ScaleFactor := 100;
    Flag_PrintBackGroundPicture := True;
    if RMPrinters.Printers.Count = 2 then Exit;

    tmp := TRMPrintDialogForm.Create(nil);
    try
      tmp.CurrentPrinter := ReportPrinter;
      tmp.rbdPrintCurPage.Enabled := False;
      tmp.Copies := FDefaultCopies;
      tmp.chkCollate.Checked := FDefaultCollate;
      tmp.chkTaoda.Checked := PrintbackgroundPicture;
      tmp.chkColorPrint.Checked := ColorPrint;
      tmp.PrintOffsetTop := PrintOffsetTop;
      tmp.PrintOffsetLeft := PrintOffsetLeft;
      if not FShowPrintDialog or (tmp.ShowModal = mrOk) then
      begin
        if not FShowPrintDialog then // Modify by sinmax
        begin
          if tmp.CurrentPrinter.PrinterIndex = 1 then
            tmp.CurrentPrinter.PrinterIndex := 0;
          tmp.ChangeVirtualPrinter;
        end;

        ScaleFactor := tmp.ScaleFactor;
        Flag_PrintBackGroundPicture := not tmp.chkTaoda.Checked;
        ColorPrint := tmp.chkColorPrint.Checked;

        lNeedSave := (PrintOffsetTop <> tmp.PrintOffsetTop) or (PrintOffsetLeft <> tmp.PrintOffsetLeft);
        PrintOffsetTop := tmp.PrintOffsetTop;
        PrintOffsetLeft := tmp.PrintOffsetLeft;
        tmp.GetPageInfo(Self.ScalePageWidth, Self.ScalePageHeight, Self.ScalePageSize);
        if tmp.rdbPrintAll.Checked then
          lPages := ''
        else
          lPages := tmp.edtPages.Text;

        lCopies := tmp.Copies;
        lCollate := tmp.chkCollate.Checked;
        lPrintPages := TRMPrintPages(tmp.cmbPrintAll.ItemIndex);

        if lNeedSave then
          SaveReportOptions.SaveReportSetting(Self, '');

        Result := True;
      end;
    finally
      tmp.Free;
    end;
  end;

begin
  lSavePrinterName := PrinterName;
  lSavePreview := FPreview;
  try
    Preview := nil;
    Flag_PrintBackGroundPicture := True;
    if _ShowPrintReportDlg then
    begin
      PrinterName := ReportPrinter.PrinterName;
      PrepareReport;
      PrintPreparedReport(lPages, lCopies, lCollate, lPrintPages);
    end;
  finally
    Preview := lSavePreview;
    PrinterName := lSavePrinterName;
  end;
end;

procedure TRMReport.ShowPreparedReport;
var
  s: string;
  lPreviewForm: TRMPreviewForm;
begin
  RMCurReport := Self;
  Flag_PrintBackGroundPicture := True;
  if EndPages.Count = 0 then Exit;

  FCurrentBand := nil;
  FCurrentPage := nil;
  FMasterReport := Self;
  FDocMode := rmdmPreviewing;
  s := RMLoadStr(SPreview);
  if ReportInfo.Title <> '' then
    s := s + ' - ' + ReportInfo.Title
  else if FileName <> '' then
    s := s + ' - ' + ExtractFileName(FileName)
  else
    s := s + ' - ' + RMLoadStr(SUntitled);

  if Assigned(Preview) then
  begin
    Preview.ShowReport(Self);
  end
  else
  begin
    if csDesigning in ComponentState then
      lPreviewForm := TRMPreviewForm.Create(nil)
    else
      lPreviewForm := TRMPreviewForm.Create(Self);

    lPreviewForm.Viewer.Options.Assign(FPreviewOptions);
    THackPreview(lPreviewForm.Viewer).OnAfterPageSetup := OnAfterPreviewPageSetup;
    lPreviewForm.Viewer.InitialDir := FPreviewInitialDir;
    if MDIPreview then
    begin
      lPreviewForm.WindowState := wsNormal;
      lPreviewForm.FormStyle := fsMDIChild;
    end;

    lPreviewForm.Caption := s;
    lPreviewForm.Execute(Self);
    Application.ProcessMessages;
  end;
end;

procedure TRMReport.LoadPreparedReport(aFileName: string);
var
  lStream: TFileStream;
begin
  if not FileExists(aFileName) then Exit;

  lStream := TFileStream.Create(aFileName, fmOpenRead);
  try
    FEndPages.LoadFromStream(lStream);
  finally
    CanRebuild := False;
    lStream.Free;
  end;
end;

procedure TRMReport.SavePreparedReport(aFileName: string);
var
  liStream: TFileStream;
begin
  liStream := TFileStream.Create(aFileName, fmCreate);
  try
    EndPages.SaveToStream(liStream);
  finally
    liStream.Free;
  end;
end;

procedure TRMReport.LoadFromAnsiString(const aStr: AnsiString);
var
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    RMTXT2Stream(aStr, lStream);
    lStream.Position := 0;
    LoadFromStream(lStream);
  finally
    lStream.Free;
  end;
end;

procedure TRMReport.SaveToAnsiString(var aStr: AnsiString);
var
  lStream: TMemoryStream;
begin
  aStr := '';
  lStream := TMemoryStream.Create;
  try
    SaveToStream(lStream);
    lStream.Position := 0;
    aStr := RMStream2TXT(lStream);
  finally
    lStream.Free;
  end;
end;

procedure TRMReport.LoadFromResourceName(aInstance: THandle; const aResName: string);
var
  lStream: TCustomMemoryStream;
begin
  lStream := TResourceStream.Create(aInstance, aResName, RT_RCDATA);
  try
    LoadFromStream(lStream);
  finally
    lStream.Free;
  end;
end;

procedure TRMReport.LoadFromResourceID(aInstance: THandle; aResID: Integer);
var
  lStream: TCustomMemoryStream;
begin
  lStream := TResourceStream.CreateFromID(aInstance, aResID, RT_RCDATA);
  try
    LoadFromStream(lStream);
  finally
    lStream.Free;
  end;
end;

procedure TRMReport.InternalOnReadOneEndPage(const aPageNo, aTotalPages: Integer);
begin
  if Assigned(FOnReadOneEndPage) then FOnReadOneEndPage(aPageNo, aTotalPages);
end;

procedure TRMReport.LoadPreparedReportFromStream(aStream: TStream);
begin
  FEndPages.LoadFromStream(aStream);
  CanRebuild := False;
end;

procedure TRMReport.AddPreparedReport(aFileName: string);
var
  lStream: TFileStream;
begin
  if not FileExists(aFileName) then Exit;

  lStream := TFileStream.Create(aFileName, fmOpenRead);
  try
    FEndPages.AppendFromStream(lStream);
  finally
    lStream.Free;
  end;
end;

type
  THackPages = class(TRMPages)
  end;

function TRMReport.EditPreparedReport(PageIndex: Integer): Boolean;
var
  lStream: TMemoryStream;
  lEndPage: TRMEndPage;
  lPicture: TPicture;
  lbkPic: TRMbkPicture;
  lpicLeft, lpicTop, lPicWidth, lPicHeight: Integer;
  lSaveDesigner, lSaveDesigner1: TRMReportDesigner;
begin
  RMCurReport := Self;
  Result := False;
  if RMDesignerClass = nil then Exit;

  Screen.Cursor := crHourGlass;
  lSaveDesigner1 := RMDesigner;
  if lSaveDesigner1 <> nil then
    lSaveDesigner1.Page := nil;

  RMDesigner := TRMReportDesigner(RMDesignerClass.NewInstance);
  RMDesigner.Create(nil);
  RMDesigner.FReport := Self;
  RMDesigner.IsPreviewDesign := True;
  RMDesigner.IsPreviewDesignReport := False;
  RMDesigner.ShowModifyToolbar := True;
  RMDesigner.AutoSave := FSaveDesignerAutoSave;

  lbkPic := EndPages.bkPictures[EndPages[PageIndex].bkPictureIndex];
  if lbkPic <> nil then
  begin
    lPicture := TPicture.Create;
    lPicture.Assign(lbkPic.FPicture);
    lpicLeft := lbkPic.Left;
    lpicTop := lbkPic.Top;
    lPicWidth := lbkPic.Width;
    lPicHeight := lbkPic.Height;
  end
  else
  begin
    lPicture := nil;
    lpicLeft := 0;
    lpicTop := 0;
    lPicWidth := 0;
    lPicHeight := 0;
  end;

  lSaveDesigner := FDesigner;
  lStream := TMemoryStream.Create;
  SaveToStream(lStream);
  try
    FDesigning := True;
    DocMode := rmdmDesigning;
    Pages.Clear;

    lEndPage := EndPages[PageIndex];
    lEndPage.StreamToObjects(Self, False);
    Pages.FPages.Add(lEndPage.Page);
    if lPicture <> nil then
    begin
      lEndPage.Page.FbkPicture.Assign(lPicture);
      lEndPage.Page.bkPictureWidth := lPicWidth;
      lEndPage.Page.bkPictureHeight := lPicHeight;
    end;
    lEndPage.Page.BackPictureLeft := lpicLeft;
    lEndPage.Page.BackPictureTop := lpicTop;

    Screen.Cursor := crDefault;
    RMDesigner.EndPageNo := PageIndex;
    FDesigner := RMDesigner;
    RMDesigner.ShowModal;
    FSaveDesignerAutoSave := RMDesigner.AutoSave
  finally
    FDesigner := lSaveDesigner;
    FDesigning := False;
    lPicture.Free;
    Pages.FPages.Clear;
    lStream.Position := 0;
    LoadFromStream(lStream);
    lStream.Free;
    RMDesigner.Free;
    RMDesigner := lSaveDesigner1;
    if RMDesigner <> nil then
      RMDesigner.Page := Pages[0];
  end;
end;

function TRMReport.DesignPreviewedReport: Boolean;
var
  lSaveDesigner: TRMReportDesigner;
  lStream: TMemoryStream;
begin
  RMCurReport := Self;
  Result := False;
  if (DesignerClass = nil) or (not CanPreviewDesign) then Exit;

  lSaveDesigner := RMDesigner;
  if lSaveDesigner <> nil then
    lSaveDesigner.Page := nil;

  lStream := TMemoryStream.Create;
  SaveToStream(lStream);
  try
    FDesigning := True;
    DocMode := rmdmDesigning;
    RMDesigner := TRMReportDesigner(DesignerClass.NewInstance);
    RMDesigner.Create(nil);
    RMDesigner.FReport := Self;
    RMDesigner.IsPreviewDesign := False;
    RMDesigner.IsPreviewDesignReport := True;
    RMDesigner.ShowModifyToolbar := False;
    FDesigner := RMDesigner;
    Result := (RMDesigner.ShowModal = mrOK);

    FDesigning := False;
    if Result and RMDesigner.Modified then
    begin
      PrepareReport;
      Result := True;
    end
    else
    begin
      lStream.Position := 0;
      LoadFromStream(lStream);
    end;
  finally
    FDesigner := lSaveDesigner;
    FDesigning := True;
    FreeAndNil(RMDesigner);
    RMDialogForm.Visible := False;

    lStream.Free;
    RMDesigner := lSaveDesigner;
    if RMDesigner <> nil then
      RMDesigner.Page := Pages[0];
  end;
end;

procedure TRMReport.ExportTo(aFilter: TRMExportFilter; aFileName: string);
var
  i: Integer;
  liContinueFlag: Boolean;
begin
  RMCurReport := Self;
  DocMode := rmdmPreviewing;
  FCurrentFilter := aFilter;
  FCurrentFilter.FileName := aFileName;
  FCurrentFilter.FParentReport := Self;

  Terminated := False;
  liContinueFlag := True;
  if Assigned(FCurrentFilter.OnBeforeExport) then
    FCurrentFilter.OnBeforeExport(FCurrentFilter.FileName, liContinueFlag);
  if liContinueFlag and (EndPages.Count > 0) and (FCurrentFilter.ShowModal = mrOk) then
  begin
    FCurrentFilter.Pagecount := EndPages.Count;
    aFileName := FCurrentFilter.FileName;
    try
      MasterReport.FTotalPages := FEndPages.Count;
      if FShowProgress then
      begin
        CreateProgressForm;
        if ReportInfo.Title = '' then
          MasterReport.FProgressForm.Caption := RMLoadStr(SReportPreparing)
        else
          MasterReport.FProgressForm.Caption := RMLoadStr(SReportPreparing) + ' - ' + ReportInfo.Title;
        MasterReport.FProgressForm.FirstCaption := RMLoadStr(SPagePreparing);
        MasterReport.FProgressForm.Label1.Caption := MasterReport.FProgressForm.FirstCaption + '  1';
        MasterReport.FProgressForm.Show;
      end;

      if FCurrentFilter.CreateFile then
        FCurrentFilter.Stream := TFileStream.Create(aFileName, fmCreate);
      FCurrentFilter.OnBeginDoc;
      i := 0;
      while (not Terminated) and (i < EndPages.Count) do
      begin
        FCurrentFilter.OnBeginPage;
        EndPages[i].ExportPage(Self);
        InternalOnProgress(i + 1);
        Application.ProcessMessages;
        FCurrentFilter.OnEndPage;
        Inc(i);
        {$IFDEF TrialVersion}
        if i > 5 then Break;
        {$ENDIF}
      end;
    finally
      FCurrentFilter.OnEndDoc;
      FreeProgressForm;
      if FCurrentFilter.CreateFile then
      begin
        FCurrentFilter.Stream.Free;
        FCurrentFilter.Stream := nil;
      end;
      if Assigned(FCurrentFilter.OnAfterExport) then
        FCurrentFilter.OnAfterExport(FCurrentFilter.FileName);
      FCurrentFilter := nil;
    end;
  end;

  FCurrentFilter := nil;
end;

procedure TRMReport.AppendReport(aStream: TStream);
var
  i, j, lCount: Integer;
  lReport: TRMReport;
  t: TRMView;
begin
  lReport := TRMReport.Create(nil);
  try
    FDocMode := rmdmDesigning;
    aStream.Position := 0;
    lReport.LoadFromStream(aStream);
    lCount := Min(Pages.Count - 1, lReport.Pages.Count - 1);
    for i := 0 to lCount do
    begin
      if lReport.Pages[i].ClassType = Pages[i].ClassType then
      begin
        for j := lReport.Pages[i].Objects.Count - 1 downto 0 do
        begin
          t := lReport.Pages[i].Objects[j];
          t.FParentPage := Pages[i];
          t.FParentReport := Self;
          Pages[i].FObjects.Add(t);
          lReport.Pages[i].FObjects.Delete(j);
        end;
      end;
    end;
  finally
    lReport.Free;
  end;
end;

procedure TRMReport.AppendFromFile(aFileName: string);
var
  liStream: TFileStream;
begin
  if ExtractFileExt(aFileName) = '' then
    aFileName := aFileName + FReportFileExtend;

  if FileExists(aFileName) then
  begin
    liStream := TFileStream.Create(aFileName, fmOpenRead);
    try
      AppendReport(liStream);
    finally
      liStream.Free;
    end;
  end;
end;

procedure TRMReport.LoadFromStream(aStream: TStream);
var
  lVersion: Integer;
  lPos: Integer;
begin
  ConvertNulls := True;
  RMCurReport := Self;
  ErrorFlag := False;
  ErrorMsg := '';
  FDocMode := rmdmDesigning;
  Clear;
  if aStream.Size < 10 then Exit;

  if RMReadString(aStream) <> FReportFlagStr + #26 then
  begin
    ErrorFlag := True;
    ErrorMsg := 'Not ReportMachine Report File!';
    Application.MessageBox(PChar(RMLoadStr(SNotRMFFile)), PChar(RMLoadStr(SError)),
      mb_Ok + mb_IconError);
    Pages.Clear;
    Pages.AddReportPage;
    Exit;
  end;

  lVersion := RMReadWord(aStream);
  if lVersion > 51 then
  begin
    RMReadWord(aStream); // HVersion
    lPos := RMReadInt32(aStream);
  end
  else
    lPos := 0;

  ReportInfo.Title := RMReadString(aStream);
  ReportInfo.Author := RMReadString(aStream);
  ReportInfo.Company := RMReadString(aStream);
  ReportInfo.CopyRight := RMReadString(aStream);
  ReportInfo.Comment := RMReadString(aStream);
  FColorPrint := RMReadBoolean(aStream);
  FmmPrintOffsetTop := RMReadInt32(aStream);
  FmmPrintOffsetLeft := RMReadInt32(aStream);
  FmmPrintOffsetTop := 0;
  FmmPrintOffsetLeft := 0;
  FPageCompositeMode := TRMCompositeMode(RMReadByte(aStream));
  PrintBackGroundPicture := RMReadBoolean(aStream);
  DoublePass := RMReadBoolean(aStream);
  PrinterName := RMReadString(aStream);
  RMReadMemo(aStream, FScript);
  if lVersion > 51 then
  begin
    FReportFlags := RMReadWord(aStream);
    if lVersion >= 57 then
      ConvertNulls := RMReadBoolean(aStream);

    aStream.Position := lPos;
  end
  else
  begin
    FReportFlags := 0;
    AutoSetPageLength := False;
  end;

  try
    Pages.LoadFromStream(lVersion, aStream);
  except
    on E: EClassNotFound do
      Application.MessageBox(PChar('Opened report contains the following non-plugged components:' +
        #13 + E.Message + 'Use appropriate component from RM component palette'), PChar(RMLoadStr(SError)),
        mb_Ok + mb_IconError);
  else
  end;

  FSaveReportOptions.LoadReportSetting(Self, '');
end;

procedure TRMReport.SaveToStream(aStream: TStream);
var
  lPrinterIndex: Integer;
  lSavePos, lPos: Integer;
begin
  RMCurReport := Self;
  FDocMode := rmdmDesigning;

  RMWriteString(aStream, FReportFlagStr + #26);
  RMWriteWord(aStream, RMCurrentVersion); // 版本号
  RMWriteWord(aStream, 0);

  lSavePos := aStream.Position;
  RMWriteInt32(aStream, 0);

  RMWriteString(aStream, ReportInfo.Title);
  RMWriteString(aStream, ReportInfo.Author);
  RMWriteString(aStream, ReportInfo.Company);
  RMWriteString(aStream, ReportInfo.CopyRight);
  RMWriteString(aStream, ReportInfo.Comment);
  RMWriteBoolean(aStream, FColorPrint);
  RMWriteInt32(aStream, FmmPrintOffsetTop);
  RMWriteInt32(aStream, FmmPrintOffsetLeft);
  RMWriteByte(aStream, Byte(FPageCompositeMode));
  RMWriteBoolean(aStream, PrintBackGroundPicture);
  RMWriteBoolean(aStream, DoublePass);

  lPrinterIndex := RMPrinters.Printers.IndexOf(PrinterName);
  if lPrinterIndex <= 0 then
    RMWriteString(aStream, RMDEFAULTPRINTER_NAME)
  else if lPrinterIndex = 1 then
    RMWriteString(aStream, RMVIRTUALPRINTER_NAME)
  else
    RMWriteString(aStream, PrinterName);
  RMWriteMemo(aStream, FScript);
  RMWriteWord(aStream, FReportFlags);
  RMWriteBoolean(aStream, ConvertNulls);

  lPos := aStream.Position;
  aStream.Position := lSavePos;
  RMWriteInt32(aStream, lPos);
  aStream.Seek(0, soFromEnd);

  Pages.SaveToStream(aStream);
end;

function TRMReport.LoadFromFile(aFileName: string): Boolean;
var
  liStream: TFileStream;
begin
  if ExtractFileExt(aFileName) = '' then
    aFileName := aFileName + FReportFileExtend;
  Result := False;
  if FileExists(aFileName) then
  begin
    liStream := TFileStream.Create(aFileName, fmOpenRead);
    try
      LoadFromStream(liStream);
      FileName := aFileName;
      Result := True;
    finally
      liStream.Free;
    end;
  end;
end;

procedure TRMReport.SaveToFile(aFileName: string);
var
  liStream: TFileStream;
begin
  if ExtractFileExt(aFileName) = '' then
    aFileName := aFileName + FReportFileExtend;
  liStream := TFileStream.Create(aFileName, fmCreate);
  try
    SaveToStream(liStream);
  finally
    liStream.Free;
  end;
end;

procedure TRMReport.LoadFromBlobField(aBlobField: TBlobField);
var
  liStream: TMemoryStream;
begin
  liStream := TMemoryStream.Create;
  try
    aBlobField.SaveToStream(liStream);
    liStream.Position := 0;
    LoadFromStream(liStream);
  finally
    liStream.Free;
  end;
end;

procedure TRMReport.SaveToBlobField(aBlobField: TBlobField);
var
  liStream: TMemoryStream;
begin
  liStream := TMemoryStream.Create;
  try
    SaveToStream(liStream);
    liStream.Position := 0;
    aBlobField.LoadFromStream(liStream);
  finally
    liStream.Free;
  end;
end;

procedure TRMReport.LoadFromMemoField(aField: TField);
var
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    RMTXT2Stream(aField.AsString, lStream);
    lStream.Position := 0;
    LoadFromStream(lStream);
  finally
    lStream.Free;
  end;
end;

procedure TRMReport.SaveToMemoField(aField: TField);
var
  lStream: TMemoryStream;
begin
  lStream := TMemoryStream.Create;
  try
    SaveToStream(lStream);
    lStream.Position := 0;
    aField.AsString := RMStream2TXT(lStream);
  finally
    lStream.Free;
  end;
end;

const
  FlagStr_TemplateFile = 'ReportMachine Template File' + #27;

procedure TRMReport.LoadTemplate(aFileName: string; aCommon: TStrings;
  aBitmap: TBitmap);
var
  liStream: TFileStream;
  liHaveBitmap: Boolean;
  lBmp: TBitmap;
  liCommon: TStringList;
  liPos: Integer;
  liVersion: Integer;
begin
  if not FileExists(aFileName) and (ExtractFileExt(aFileName) = '') then
    aFileName := aFileName + '.rmt';
  lBmp := TBitmap.Create;
  liCommon := TStringList.Create;
  liStream := TFileStream.Create(aFileName, fmOpenRead);
  try
    liVersion := RMReadWord(liStream); // Version
    if RMReadString(liStream) <> FlagStr_TemplateFile then
      Application.MessageBox(PChar(RMLoadStr(SNotRMTFile)), PChar(RMLoadStr(SError)),
        mb_Ok + mb_IconError)
    else
    begin
      RMReadMemo(liStream, liCommon);
      liPos := RMReadInt32(liStream);
      liHaveBitmap := RMReadBoolean(liStream);
      if liHaveBitmap then
        lBmp.LoadFromStream(liStream);
      liStream.Position := liPos;
      Pages.LoadFromStream(liVersion, liStream);
    end;
  finally
    if aCommon <> nil then
      aCommon.Assign(liCommon);
    if aBitmap <> nil then
      aBitmap.Assign(lBmp);
    lBmp.Free;
    liCommon.Free;
    liStream.Free;
  end;
end;

procedure TRMReport.SaveTemplate(aFileName: string; const aCommon: TStrings;
  const aBitmap: TBitmap);
var
  liStream: TFileStream;
  liSavePos, liPos: Integer;
begin
  if ExtractFileExt(aFileName) = '' then
    aFileName := aFileName + '.rmt';
  liStream := TFileStream.Create(aFileName, fmCreate);
  try
    RMWriteWord(liStream, RMCurrentVersion);
    RMWriteString(liStream, FlagStr_TemplateFile);
    RMWriteMemo(liStream, aCommon);
    liSavePos := liStream.Position;
    RMWriteInt32(liStream, 0);
    if aBitmap.Empty then
      RMWriteBoolean(liStream, False)
    else
    begin
      RMWriteBoolean(liStream, True);
      aBitmap.SaveToStream(liStream);
    end;

    liPos := liStream.Position;
    liStream.Position := liSavePos;
    RMWriteInt32(liStream, liPos);
    liStream.Position := liPos;
    Pages.SaveToStream(liStream);
  finally
    liStream.Free;
  end;
end;

type
  THackPrinter = class(TRMPrinter)
  end;

function TRMReport.GetItems(Index: string): TRMView;
begin
  Result := FindObject(Index);
end;

function TRMReport.GetPrinter: TRMPrinter;
begin
  if FPrinter <> nil then
    Result := FPrinter
      //  else if FPrinterDevice <> nil then
//    Result := FPrinterDevice.Printer
  else if IsMultiThread and not (csDesigning in ComponentState) then
  begin
    FPrinter := TRMPrinter.Create;
    THackPrinter(FPrinter).GetSettings;
    Result := FPrinter;
  end
  else
    Result := RMPrinter;
end;

function TRMReport.GetPrintOffsetLeft(Index: Integer): Integer;
begin
  case Index of
    0: Result := RMToScreenPixels(FmmPrintOffsetLeft, rmutMMThousandths);
    1: Result := RMToScreenPixels(FmmPrintOffsetTop, rmutMMThousandths);
  else
    Result := 0;
  end;
end;

procedure TRMReport.SetPrintOffsetLeft(Index: Integer; Value: Integer);
begin
  case Index of
    0: FmmPrintOffsetLeft := RMToMMThousandths(Value, rmutScreenPixels);
    1: FmmPrintOffsetTop := RMToMMThousandths(Value, rmutScreenPixels);
  end;
end;

procedure TRMReport.SetSaveReportOptions(Value: TRMSaveReportOptions);
begin
  FSaveReportOptions.Assign(Value);
end;

function TRMReport.GetFlags(Index: Integer): Boolean;
begin
  case Index of
    0: Result := (FReportFlags and $1) = $1;
    1: Result := (FReportFlags and $2) = $2;
  else
    Result := False;
  end;
end;

procedure TRMReport.SetFlags(Index: Integer; Value: Boolean);
begin
  case Index of
    0:
      begin
        FReportFlags := (FReportFlags and not $1);
        if Value then
          FReportFlags := FReportFlags + $1;
      end;
    1:
      begin
        FReportFlags := (FReportFlags and not $2);
        if Value then
          FReportFlags := FReportFlags + $2;
      end;
  end;
end;

procedure TRMReport.SetPreviewOptions(Value: TRMPreviewOptions);
begin
  FPreviewOptions.Assign(Value);
end;

function TRMReport.CreateAutoSearchField(const aTableName, aFieldName, aFieldAlias: string;
  aDataType: TRMDataType; aOperator: TRMSearchOperatorType;
  const aExpression: string; aMandatory: Boolean): TRMAutoSearchField;
begin
  Result := nil;
end;

function TRMReport.CreateAutoSearchCriteria(const aDataPipelineName, aFieldName: string;
  aOperator: TRMSearchOperatorType; const aExpression: string;
  aMandatory: Boolean): TRMAutoSearchField;
begin
  Result := nil;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCompositeReport }

constructor TRMCompositeReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FReports := TList.Create;
  FMode := rmReportPerReport;
  FShowPreparedReports := False;
end;

destructor TRMCompositeReport.Destroy;
begin
  FReports.Free;
  inherited Destroy;
end;

procedure TRMCompositeReport.OnClearEMFPagesEvnet(Sender: TObject);
var
  i: Integer;
begin
  FEndPages.FPages.Clear;
  for i := 0 to FReports.Count - 1 do
  begin
    TRMReport(FReports[i]).EndPages.Clear;
  end;
end;

procedure TRMCompositeReport._BuildReports;
var
  i, j: Integer;
  liReport: TRMReport;
  liFlag: Boolean;
begin
  if not FShowPreparedReports then
  begin
    for i := 0 to FReports.Count - 1 do
    begin
      liReport := TRMReport(FReports[i]);
      FMasterReport := liReport;
      liReport.PrepareReport;
    end;
  end;

  FEndPages.Clear;
  FEndPages.OnClearEvent := OnClearEMFPagesEvnet;
  if FMode = rmPageperPage then
  begin
    liFlag := True;
    j := 0;
    while liFlag do
    begin
      liFlag := False;
      for i := 0 to FReports.Count - 1 do
      begin
        liReport := TRMReport(FReports[i]);
        if liReport.EndPages.Count > j then
        begin
          FEndPages.FPages.Add(liReport.EndPages.FPages[j]);
          liFlag := True;
        end;
      end;
      Inc(j);
    end;
  end
  else
  begin
    for i := 0 to FReports.Count - 1 do
    begin
      liReport := TRMReport(FReports[i]);
      for j := 0 to liReport.FEndPages.Count - 1 do
        FEndPages.FPages.Add(liReport.EndPages.FPages[j]);
    end;
  end;
end;

procedure TRMCompositeReport.DoBuildReport(aFirstTime, aFinalPass: Boolean);
var
  i, j: Integer;
  lReport, lNextReport: TRMReport;
  liPage, liPage1: TRMReportPage;
begin
  FMasterReport := Self;
  EndPages.OnClearEvent := nil;
  if (FMode = rmPageperPage) or FShowPreparedReports then
  begin
    _BuildReports;
    Exit;
  end;

  CanRebuild := True;
  FPageNo := 0;
  for i := 0 to FReports.Count - 1 do
  begin
    lReport := TRMReport(FReports[i]);
    FCompositeMode := False;
    if i <> FReports.Count - 1 then
    begin
      lNextReport := TRMReport(FReports[i + 1]);
      liPage := nil;
      for j := 0 to lNextReport.Pages.Count - 1 do
      begin
        if lNextReport.Pages[j] is TRMReportPage then
        begin
          liPage := TRMReportPage(lNextReport.Pages[j]);
          Break;
        end;
      end;

      if (lNextReport.Pages.Count > 0) and (liPage <> nil) and liPage.PrintToPrevPage then
        FCompositeMode := True;
      if FEndPages.Count > 0 then
      begin
        if (lNextReport.Pages.Count > 0) and (liPage <> nil) and
          ((FEndPages[FEndPages.Count - 1].PageOrientation <> liPage.PageOrientation) or
          (FEndPages[FEndPages.Count - 1].PageSize <> liPage.PageSize)) then
          FCompositeMode := False;
      end
      else
      begin
        liPage1 := nil;
        for j := lReport.Pages.Count - 1 downto 0 do
        begin
          if lReport.Pages[i] is TRMReportPage then
          begin
            liPage1 := TRMReportPage(lReport.Pages[i]);
            Break;
          end;
        end;

        if (liPage1 <> nil) and (liPage <> nil) and
          ((liPage1.PageOrientation <> liPage.PageOrientation) or (liPage1.PageSize <> liPage.PageSize)) then
          FCompositeMode := False;
      end;
    end;

    lReport.FMasterReport := Self;
    lReport.DoBuildReport(aFirstTime, aFinalPass);

    FAppendFlag := FCompositeMode;
    FCompositeMode := False;
    if Terminated then
      Break;
  end;

  if MasterReport.EndPages.Count > 0 then
  begin
    if MasterReport = Self then
      MasterReport.EndPages[MasterReport.EndPages.Count - 1].AfterEndPage;
  end;
end;

procedure TRMCompositeReport.SetMode(Value: TRMCompositeMode);
begin
  FMode := Value;
  if FMode = rmPageperPage then
    ShowProgress := False;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMReportDesigner }

constructor TRMReportDesigner.Create(aOwner: TComponent);
begin
  inherited;

  FScriptParser := nil;
end;

destructor TRMReportDesigner.Destroy;
begin
  FreeAndNil(FScriptParser);

  inherited;
end;

function TRMReportDesigner.PageObjects: TList;
begin
  Result := Page.Objects;
end;

// Script Engine Begin

function TRMReportDesigner.GetScriptParser: TJvInterpreterParser;
begin
  if FScriptParser = nil then
    FScriptParser := TJvInterpreterParser.Create;

  Result := FScriptParser;
end;

procedure TRMReportDesigner.GetEventFunctions(aValues: TStrings;
  aParams: PRMParamRecArray; aParamCount: Integer);
begin
  //
end;

procedure TRMReportDesigner.EditMethod(aFuncName: string;
  aParams: PRMParamRecArray; aParamCount: Integer);
begin
  //
end;

procedure TRMReportDesigner.ClearEmptyEvent;
begin
  //
end;

// Script Engine End

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMExportFilter}

constructor TRMExportFilter.Create(AOwner: TComponent);
begin
  inherited;
  FIsXLSExport := False;
  CreateFile := False;
end;

destructor TRMExportFilter.Destroy;
begin
  inherited;
end;

function TRMExportFilter.ShowModal: Word;
begin
  Result := mrOk;
end;

procedure TRMExportFilter.OnBeginDoc;
begin
  //
end;

procedure TRMExportFilter.OnEndDoc;
begin
  //
end;

procedure TRMExportFilter.OnBeginPage;
begin
  //
end;

procedure TRMExportFilter.OnEndPage;
begin
  //
end;

procedure TRMExportFilter.OnExportPage(const aPage: TRMEndPage);
begin
  //
end;

procedure TRMExportFilter.OnText(DrawRect: TRect; x, y: Integer; const text: string; View: TRMView);
begin
  //
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
type
  TRMStdFunctionLibrary = class(TRMFunctionLibrary)
  public
    constructor Create; override;
    procedure DoFunction(aParser: TRMParser; aFuncNo: Integer; aParams: array of Variant;
      var aValue: Variant); override;
  end;

constructor TRMStdFunctionLibrary.Create;
begin
  inherited Create;
  with List do
  begin
    Add('STRTOFLOAT');
    Add('PARAMSTR');
    Add('EXTRACTFILEPATH');
    Add('STRINGOFCHAR');
    Add('MONTHTOENGLISHSHORT');
    Add('MONTHTOENGLISHLONG');
    Add('SINGNUMTOBIG');
    Add('SMALLTOBIG');
    Add('CURRTOBIGNUM');
    Add('RMROUND');
    Add('STRTOINT');
    Add('ABS');
    Add('GETCONTROLPROPVALUE');
    Add('FORMATDATETIME');
    Add('FORMATFLOAT');
    Add('FORMATTEXT');
    Add('LENGTH');
    Add('LOWERCASE');
    Add('NAMECASE');
    Add('POS');
    Add('TRIM');
    Add('UPPERCASE');
    Add('DIV');
    Add('MAXNUM');
    Add('MINNUM');
    Add('DAY');
    Add('MONTH');
    Add('YEAR');
    Add('INPUT');
    Add('MESSAGEBOX');
    Add('SHOWMESSAGE');
    Add('DATE');
    Add('TIME');
    Add('FIELDISNULL');
    Add('CHINADATE');
    Add('IIF');
    Add('RMFORMAT');
    Add('STRTODATE');
    Add('STRTOTIME');
    Add('CNUMBER');
    Add('COPY');
    Add('IF');

    Add('AVG');
    Add('COUNT');
    Add('MAX');
    Add('MIN');
    Add('SUM');
  end;

  AddFunctionDesc('Avg', rmfrAggregate, RMLoadStr(SDescriptionAVG), 'NSN');
  AddFunctionDesc('Count', rmfrAggregate, RMLoadStr(SDescriptionCOUNT), 'S');
  AddFunctionDesc('Max', rmfrAggregate, RMLoadStr(SDescriptionMAX), 'NSN');
  AddFunctionDesc('Min', rmfrAggregate, RMLoadStr(SDescriptionMIN), 'NSN');
  AddFunctionDesc('Sum', rmfrAggregate, RMLoadStr(SDescriptionSUM), 'NSN');

  AddFunctionDesc('Copy', rmftString, RMLoadStr(SDescriptionCOPY), 'SNN');
  AddFunctionDesc('FormatDateTime', rmftString, RMLoadStr(SDescriptionFORMATDATETIME), 'SE');
  AddFunctionDesc('FormatFloat', rmftString, RMLoadStr(SDescriptionFORMATFLOAT), 'SV');
  AddFunctionDesc('FormatText', rmftString, RMLoadStr(SDescriptionFORMATTEXT), 'SS');
  AddFunctionDesc('Length', rmftString, RMLoadStr(SDescriptionLENGTH), 'S');
  AddFunctionDesc('LowerCase', rmftString, RMLoadStr(SDescriptionLOWERCASE), 'S');
  AddFunctionDesc('NameCase', rmftString, RMLoadStr(SDescriptionNAMECASE), 'S');
  AddFunctionDesc('Pos', rmftString, RMLoadStr(SDescriptionPOS), 'SS');
  AddFunctionDesc('Str', rmftString, RMLoadStr(SDescriptionSTR), 'N');
  AddFunctionDesc('Trim', rmftString, RMLoadStr(SDescriptionTRIM), 'S');
  AddFunctionDesc('UpperCase', rmftString, RMLoadStr(SDescriptionUPPERCASE), 'S');
  AddFunctionDesc('CNumber', rmftString, RMLoadStr(SDescriptionCnNumber), 'N');

  AddFunctionDesc('Dec', rmftMath, RMLoadStr(SDescriptionDEC), 'N');
  AddFunctionDesc('Div', rmftMath, RMLoadStr(SDescriptionDiv), 'NN');
  AddFunctionDesc('Frac', rmftMath, RMLoadStr(SDescriptionFRAC), 'N');
  AddFunctionDesc('Inc', rmftMath, RMLoadStr(SDescriptionINC), 'N');
  AddFunctionDesc('Int', rmftMath, RMLoadStr(SDescriptionINT), 'N');
  AddFunctionDesc('MaxNum', rmftMath, RMLoadStr(SDescriptionMAXNUM), 'NN');
  AddFunctionDesc('MinNum', rmftMath, RMLoadStr(SDescriptionMINNUM), 'NN');
  AddFunctionDesc('Mod', rmftMath, RMLoadStr(SDescriptionMOD), '');
  AddFunctionDesc('Round', rmftMath, RMLoadStr(SDescriptionROUND), '');

  AddFunctionDesc('Date', rmftDateTime, RMLoadStr(SDescriptionDATE), '');
  AddFunctionDesc('Day', rmftDateTime, RMLoadStr(SDescriptionDAY), 'D');
  AddFunctionDesc('Month', rmftDateTime, RMLoadStr(SDescriptionMONTH), 'D');
  AddFunctionDesc('StrtoDate', rmftDateTime, RMLoadStr(SDescriptionSTRTODATE), 'S');
  AddFunctionDesc('StrtoTime', rmftDateTime, RMLoadStr(SDescriptionSTRTOTIME), 'S');
  AddFunctionDesc('Time', rmftDateTime, RMLoadStr(SDescriptionTIME), '');
  AddFunctionDesc('Year', rmftDateTime, RMLoadStr(SDescriptionYEAR), 'D');

  AddFunctionDesc('IF', rmftBoolean, RMLoadStr(SDescriptionIF), 'BVV');
  AddFunctionDesc('IIF', rmftBoolean, RMLoadStr(SDescriptionIF), 'BVV');
  AddFunctionDesc('TRUE', rmftBoolean, RMLoadStr(SDescriptionTRUE), '');
  AddFunctionDesc('FALSE', rmftBoolean, RMLoadStr(SDescriptionFALSE), '');
  AddFunctionDesc('AND', rmftBoolean, RMLoadStr(SDescriptionAND), '');
  AddFunctionDesc('NOT', rmftBoolean, RMLoadStr(SDescriptionNOT), '');
  AddFunctionDesc('OR', rmftBoolean, RMLoadStr(SDescriptionOR), '');

  AddFunctionDesc('Input', rmftOther, RMLoadStr(SDescriptionINPUT), 'SS');
  AddFunctionDesc('MessageBox', rmftOther, RMLoadStr(SDescriptionMESSAGEBOX), 'SSS');
  AddFunctionDesc('_RM_Column', rmftOther, RMLoadStr(SDescriptionCOLUMN), '');
  AddFunctionDesc('_RM_Line', rmftOther, RMLoadStr(SDescriptionLINE), '');
  AddFunctionDesc('_RM_LineThough', rmftOther, RMLoadStr(SDescriptionLINETHROUGH), '');
  AddFunctionDesc('_RM_Page', rmftOther, RMLoadStr(SDescriptionPAGE), '');
  AddFunctionDesc('_RM_TotalPages', rmftOther, RMLoadStr(SDescriptionTOTALPAGES), '');

  AddFunctionDesc('CurY', rmftInterpreter, RMLoadStr(SDescriptionCurY), '');
  AddFunctionDesc('FinalPass', rmftInterpreter, RMLoadStr(SDescriptionFinalPass), '');
  AddFunctionDesc('FreeSpace', rmftInterpreter, RMLoadStr(SDescriptionFreeSpace), '');
  AddFunctionDesc('ModalResult', rmftInterpreter, RMLoadStr(SDescriptionModalResult), '');
  AddFunctionDesc('mrCancel', rmftInterpreter, RMLoadStr(SDescriptionMRCancel), '');
  AddFunctionDesc('mrOK', rmftInterpreter, RMLoadStr(SDescriptionMROK), '');
  AddFunctionDesc('NewColumn', rmftInterpreter, RMLoadStr(SDescriptionNewColumn), '');
  AddFunctionDesc('NewPage', rmftInterpreter, RMLoadStr(SDescriptionNewPage), '');
  AddFunctionDesc('PageHeight', rmftInterpreter, RMLoadStr(SDescriptionPageHeight), '');
  AddFunctionDesc('PageWidth', rmftInterpreter, RMLoadStr(SDescriptionPageWidth), '');
  AddFunctionDesc('Progress', rmftInterpreter, RMLoadStr(SDescriptionProgress), '');
  AddFunctionDesc('ShowBand', rmftInterpreter, RMLoadStr(SDescriptionShowBand), '');
  AddFunctionDesc('StopReport', rmftInterpreter, RMLoadStr(SDescriptionStopReport), '');

  AddFunctionDesc('StrToFloat', rmftMath, '', 'S');
  AddFunctionDesc('ParamStr', rmftString, 'ParamStr|Delphi''s ParamStr', 'S');
  AddFunctionDesc('ExtractFilePath', rmftString, 'ExtractFilePath|Delphi''s ExtractFilePath', 'S');
  AddFunctionDesc('StringOfChar', rmftString, 'StringOfChar|Delphi''s StringOfChar', 'SN');
  AddFunctionDesc('MonthtoEnglishShort', rmftDateTime, 'MonthtoEnglishShort|Return English Short Month Name', 'N');
  AddFunctionDesc('MonthtoEnglishLong', rmftDateTime, 'MonthtoEnglishLong|Return English Long Month Name', 'N');
  AddFunctionDesc('SinglNumToBig', rmftString, 'SinglNumToBig|', 'NN');
  AddFunctionDesc('SmallToBig', rmftString, 'SmallToBig|', 'N');
  AddFunctionDesc('CurrToBigNum', rmftString, RMLoadStr(SDescriptionCurrToBigNum), 'N');
  AddFunctionDesc('RMRound', rmftMath, RMLoadStr(SDescriptionRMRound), 'NN');
  AddFunctionDesc('StrToInt', rmftMath, 'StrToInt|Delphi''s IntToStr', 'S');
  AddFunctionDesc('Abs', rmftMath, 'Abs|Delphi''s Abs', 'N');
  AddFunctionDesc('GetControlPropValue', rmftOther, 'GetControlPropValue|', 'SS');
  AddFunctionDesc('FieldIsNull', rmftBoolean, 'Indicates whether the field has a value assigned to it.|', 'S');
  AddFunctionDesc('ChinaDate', rmftString, 'Change Date To China Format Date.|', 'D');
  AddFunctionDesc('RMFormat', rmftString, 'Format value.|', 'SS');
end;

procedure TRMStdFunctionLibrary.DoFunction(aParser: TRMParser; aFuncNo: Integer;
  aParams: array of Variant; var aValue: Variant);
var
  lValue1, lValue2, lValue3: Variant;

  procedure _GetDayOfDate(flag: integer);
  var
    year, month, day: WORD;
  begin
    aValue := aParser.Calc(aParams[0]);
    if aValue = NULL then aValue := 0;

    DecodeDate(aValue, year, month, day);
    case flag of
      1: aValue := day;
      2: aValue := month;
      3: aValue := year;
    end;
  end;

  function _NameCase(const str: string): string;
  begin
    if str <> '' then
      Result := AnsiUpperCase(str[1]) + Copy(str, 2, Length(str) - 1)
    else
      Result := '';
  end;

  procedure _DoFormatDateTime;
  var
    liv1, liv2: Variant;
  begin
    liv1 := aParser.Calc(aParams[0]);
    liv2 := aParser.Calc(aParams[1]);
    if (liv1 <> NULL) and (liv2 <> NULL) then
      aValue := FormatDateTime(liv1, liv2);
  end;

  function _DoMax(v1, v2: Variant): Variant;
  begin
    Result := v1;
    if v2 > v1 then
      Result := v2;
  end;

  function _DoMin(v1, v2: Variant): Variant;
  begin
    Result := v1;
    if v2 < v1 then
      Result := v2;
  end;

  function _FieldIsNull(const aStr: string): Boolean;
  var
    lDataSet: TRMDataSet;
    lFieldName: string;
  begin
    Result := False;
    RMGetDatasetAndField(TRMReport(aParser.ParentReport), aStr, lDataSet, lFieldName);
    if (lDataSet <> nil) and (lFieldName <> '') then
      Result := lDataSet.FieldIsNull(lFieldName);
  end;

  function _ChinaDate(aDate: TDateTime): string;
  var
    lYear, lMonth, lDay: Word;
    lMonth_str, lDay_str, lDay_str1, lDay_str2: string;
  begin
    DecodeDate(aDate, lYear, lMonth, lDay);
    lDay_str := RMNumToBig(lDay);
    lMonth_str := RMNumToBig(lMonth);
    if lMonth_str = '一0' then lMonth_str := '十';
    if lMonth_str = '一一' then lMonth_str := '十一';
    if lMonth_str = '一二' then lMonth_str := '十二';
    if Length(lDay_str) > 2 then
    begin
      if copy(lDay_str, 1, 2) = '一' then
        lDay_str1 := ''
      else
        lDay_str1 := copy(lDay_str, 1, 2);

      if copy(lDay_str, 3, 2) = '0' then
        lDay_str2 := ''
      else
        lDay_str2 := copy(lDay_str, 3, 2);

      lDay_str := lDay_str1 + '十' + lDay_str2;
    end;

    Result := RMNumToBig(lYear) + '年' + lMonth_str + '月' + lDay_str + '日';
  end;

  function _RMFormat(aValue: Variant; aFormatStr: string): Variant;
  var
    lFormat: TRMFormat;
  begin
    RMGetFormatStr_1(aFormatStr, lFormat);
    Result := RMFormatValue(aValue, lFormat, aFormatStr, False);
  end;

  function _StrToDate(aValue: string): TDateTime;
  begin
    Result := StrToDate(aValue);
  end;

  function _StrToTime(aValue: string): TDateTime;
  begin
    Result := StrToTime(aValue);
  end;

  function _GenExprFunc(aType: Integer): Variant;
  var
    lReport: TRMReport;
    lPage: TRMReportPage;
    lBandName: string;
    lCurBand: TRMBand;
    lValue: Variant;
  begin
    //        Add('AVG');
    //        Add('COUNT');
    //        Add('MAX');
    //        Add('MIN');
    //        Add('SUM');

    lReport := TRMReport(aParser.ParentReport);
    lPage := TRMReportPage(lReport.CurrentPage);

    lBandName := aParams[1];
    if aType = 1 then
    begin
      lBandName := aParams[0];
      aParams[2] := aParams[1];
    end;

    lCurBand := lReport.CurrentBand;
    if lReport.InitAggregate then // 初始化
    begin
      if lBandName = '' then
        lBandName := lReport.FRMAggrBand.Name;

      if RMCmp(lReport.FRMAggrBand.Name, Trim(lBandName)) then
      begin
        lBandName := lCurBand.Name;
        if (lCurBand.BandType <> rmbtCrossFooter) and lCurBand.HasCross then
          lBandName := '0' + #1 + lBandName;
        if aType = 3 then
          lValue := 1E300
        else
          lValue := 0;

        lReport.FRMAggrBand.AddAggregateValue(lBandName + #1 + Chr(aType) + #1 + aParams[0] + #1 + aParams[2] + #1, lValue);
        lCurBand.FAggrBand := lReport.FRMAggrBand;
      end;
    end
    else if lCurBand.FAggrBand <> nil then
    begin
      lBandName := lCurBand.Name;
      if lCurBand.BandType = rmbtCrossData then
      begin
        lCurBand := lCurBand.FAggrBand;
        lBandName := IntToStr(lPage.FColumnPos) + #1 + lCurBand.Name;
      end;

      Result := lCurBand.FAggrBand.GetAggregateValue(lBandName + #1 + Chr(aType) + #1 + aParams[0] + #1 + aParams[2] + #1);
    end;
  end;

begin
  aValue := '0';
  case aFuncNo of
    0: // StrToFloat
      begin
        aValue := aParser.Calc(aParams[0]);
        if (TVarData(aValue).VType <= 1) or
          ((TVarData(aValue).VType = varString) and (TVarData(aValue).VType <> varOleStr) and (aValue = '')) then
          aValue := 0
        else
          aValue := StrToFloat(aValue);
      end;
    1: // Paramstr
      begin
        aValue := ParamStr(aParser.Calc(aParams[0]));
      end;
    2: // ExtractFilePath
      begin
        aValue := ExtractFilePath(aParser.Calc(aParams[0]));
      end;
    3: // StringOfChar
      begin
        aValue := StringOfChar(string(aParser.Calc(aParams[0]))[1], Integer(aParser.Calc(aParams[1])));
      end;
    4: // MonthtoEnglishShort
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := 0;

        aValue := RMMonth_EnglishShort(lValue1);
      end;
    5: // MonthtoEnglishLong
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := 0;

        aValue := RMMonth_EnglishLong(lValue1);
      end;
    6: // SinglNumToBig
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := 0;

        aValue := RMSinglNumToBig(lValue1, aParser.Calc(aParams[1]));
      end;
    7: // SmallToBig
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := RMSmallToBig(lValue1);
      end;
    8: // CurrToBigNum
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if (lValue1 = Null) or ((VarType(lValue1) = varString) and (lValue1 = '')) then
          lValue1 := 0;

        aValue := RMCurrToBIGNum(lValue1);
      end;
    9: // RMRound
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := 0;

        aValue := RMRound(lValue1, aParser.Calc(aParams[1]));
      end;
    10: // StrToInt
      begin
        aValue := aParser.Calc(aParams[0]);
        if (TVarData(aValue).VType <= 1) or
          ((TVarData(aValue).VType = varString) and (TVarData(aValue).VType <> varOleStr) and (aValue = '')) then
          aValue := 0
        else
          aValue := StrToInt(aValue);
      end;
    11: // Abs
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := 0;

        aValue := Abs(lValue1);
      end;
    12: // GetStrPropValue
      begin
        aValue := RMGetPropValue(TRMReport(aParser.ParentReport), aParser.Calc(aParams[0]), aParser.Calc(aParams[1]));
      end;
    13: // FormatDateTime
      _DoFormatDateTime;
    14: // FormatFloat
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        lValue2 := aParser.Calc(aParams[1]);
        if lValue2 = Null then lValue2 := 0;

        aValue := FormatFloat(lValue1, lValue2);
      end;
    15: // FormatText
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        lValue2 := aParser.Calc(aParams[1]);
        if lValue2 = Null then lValue2 := 0;

        aValue := FormatMaskText(lValue1 + ';0; ', lValue2);
      end;
    16: // Length
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := Length(lValue1);
      end;
    17: // LowerCase
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := AnsiLowerCase(lValue1);
      end;
    18: // NameCase
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := _NameCase(lValue1);
      end;
    19: // Pos
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        lValue2 := aParser.Calc(aParams[1]);
        if lValue2 = Null then lValue2 := '';

        aValue := System.Pos(lValue1, lValue2);
      end;
    20: // Trim
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := Trim(lValue1);
      end;
    21: // UpperCase
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := AnsiUpperCase(lValue1);
      end;
    22: // Div
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := 0;

        lValue2 := aParser.Calc(aParams[1]);
        //if lValue2 = Null then lValue1 := 0;

        aValue := lValue1 div lValue2;
      end;
    23: // MaxNum
      begin
        lValue1 := aParser.Calc(aParams[0]);
        //if lValue1 = Null then lValue1 := 0;

        lValue2 := aParser.Calc(aParams[1]);
        //if lValue2 = Null then lValue1 := 0;

        aValue := _DoMax(lValue1, lValue2);
      end;
    24: // MinNum
      begin
        lValue1 := aParser.Calc(aParams[0]);
        //if lValue1 = Null then lValue1 := 0;

        lValue2 := aParser.Calc(aParams[1]);
        //if lValue2 = Null then lValue1 := 0;

        aValue := _DoMin(lValue1, lValue2);
      end;
    25: // Day
      _GetDayOfDate(1);
    26: // Month
      _GetDayOfDate(2);
    27: // Year
      _GetDayOfDate(3);
    28: // Input
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        lValue2 := aParser.Calc(aParams[1]);
        if lValue2 = Null then lValue2 := '';

        aValue := InputBox('', lValue1, lValue2);
      end;
    29: // MessageBox
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        lValue2 := aParser.Calc(aParams[1]);
        if lValue2 = Null then lValue2 := '';

        lValue3 := aParser.Calc(aParams[2]);
        if lValue3 = Null then lValue2 := 0;

        aValue := Application.MessageBox(PChar(string(lValue1)),
          PChar(string(lValue2)), lValue3);
      end;
    30: // ShowMessage
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        ShowMessage(lValue1);
      end;
    31: // Date
      aValue := SysUtils.Date;
    32: // Time
      aValue := SysUtils.Time;
    33: // FieldIsNull
      aValue := _FieldIsNull(aParser.Calc(aParams[0]));
    34: // ChinaDate
      begin
        lValue1 := aParSer.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := 0;

        aValue := _ChinaDate(lValue1);
      end;
    35, 41: // IIF
      begin
        lValue1 := aParSer.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := False;

        if Boolean(lValue1) then
          aValue := aParser.Calc(aParams[1])
        else
          aValue := aParser.Calc(aParams[2]);
      end;
    36: // RMFormat
      begin
        lValue1 := aParSer.Calc(aParams[0]);

        lValue2 := aParSer.Calc(aParams[1]);
        if lValue2 = Null then lValue2 := '';

        aValue := _RMFormat(lValue1, lValue2);
      end;
    37: // StrToDate
      begin
        lValue1 := aParSer.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := _StrToDate(lValue1);
      end;
    38: // StrToTime;
      begin
        lValue1 := aParSer.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := _StrToTime(lValue1);
      end;
    39: // CNUMBER
      begin
        lValue1 := aParSer.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        aValue := RMChineseNumber(lValue1);
      end;
    40: // Copy;
      begin
        lValue1 := aParser.Calc(aParams[0]);
        if lValue1 = Null then lValue1 := '';

        lValue2 := aParser.Calc(aParams[1]);
        if lValue2 = Null then lValue2 := 0;

        lValue3 := aParser.Calc(aParams[2]);
        if lValue3 = Null then lValue3 := 0;

        aValue := Copy(lValue1, Integer(lValue2), Integer(lValue3));
      end;
    42..46:
      aValue := _GenExprFunc(aFuncNo - 42 + atAvg);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMResourceManager}

procedure RMLocalizeGlobals;
var
  i: Integer;
  bt: TRMBandType;
  liClass: TClass;
begin
  RMCharset := StrToInt(RMLoadStr(SCharset));
  rmfrAggregate := RMLoadStr(SAggregateCategory);
  rmftDateTime := RMLoadStr(SDateTimeCategory);
  rmftString := RMLoadStr(SStringCategory);
  rmftOther := RMLoadStr(SOtherCategory);
  rmftMath := RMLoadStr(SMathCategory);
  rmftBoolean := RMLoadStr(SBoolCategory);
  rmftInterpreter := RMLoadStr(SIntrpCategory);
  for bt := rmbtReportTitle to rmbtNone do
    RMBandNames[bt] := RMLoadStr(SBand1 + Integer(bt));
  for i := Low(RMFormatBoolStr) to High(RMFormatBoolStr) do
    RMFormatBoolStr[i] := RMLoadStr(SFormat51 + i);
  for i := Low(RMDateFormats) to High(RMDateFormats) do
    RMDateFormats[i] := RMLoadStr(SDateFormat1 + i);
  for i := Low(RMTimeFormats) to High(RMTimeFormats) do
    RMTimeFormats[i] := RMLoadStr(STimeFormat1 + i);

  for i := 0 to RMAddInFunctionCount - 1 do
  begin
    liClass := TClass(RMAddInFunctions(0).ClassType);
    RMUnRegisterFunctionLibrary(liClass);
    RMRegisterFunctionLibrary(liClass);
  end;
end;

constructor TRMResourceManager.Create;
begin
  inherited Create;
  FLoaded := False;
end;

destructor TRMResourceManager.Destroy;
begin
  inherited Destroy;
end;

function TRMResourceManager.LoadStr(aID: Integer): string;
var
  liBuffer: array[0..1023] of Char;
  liHandle: THandle;
begin
  if FLoaded then
  begin
    if FLoaded then liHandle := FDllHandle else liHandle := HInstance;
    Windows.LoadString(liHandle, aID, liBuffer, SizeOf(liBuffer));
    Result := string(liBuffer);
  end
  else
    Result := SysUtils.LoadStr(aID);
end;

procedure TRMResourceManager.LoadResourceModule(const aResFileName: string);
begin
  UnloadResourceModule;
  FDllHandle := LoadLibraryEx(PChar(aResFileName), 0, LOAD_LIBRARY_AS_DATAFILE);
  FLoaded := FDllHandle <> HINSTANCE_ERROR;
  RMLocalizeGlobals;
  if Assigned(FOnAfterInit) then FOnAfterInit(True);
end;

procedure TRMResourceManager.UnloadResourceModule;
begin
  if FLoaded then
    FreeLibrary(FDllHandle);
  FLoaded := False;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMApplication }

function TRMApplication.GetExtendFormPath: string;
begin
  Result := RM_Class.RMExtendFormPath;
end;

procedure TRMApplication.SetExtendFormPath(Value: string);
begin
  RM_Class.RMExtendFormPath := Value;
end;

{function TRMApplication.GetRMUseNull: Boolean;
begin
  Result := RM_Class.RMUseNull;
end;

procedure TRMApplication.SetRMUseNull(Value: Boolean);
begin
  RM_Class.RMUseNull := Value;
end;}

function TRMApplication.GetUnitType: TRMUnitType;
begin
  Result := RM_Class.RMUnits;
end;

procedure TRMApplication.SetUnitType(Value: TRMUnitType);
begin
  RM_Class.RMUnits := Value;
end;

function TRMApplication.GetVariables: TRMVariables;
begin
  Result := RM_Class.RMVariables;
end;

procedure TRMApplication.SetVariables(Value: TRMVariables);
begin
  RM_Class.RMVariables.Assign(Value);
end;

function TRMApplication.GetDialogForm: TForm;
begin
  Result := RM_Class.RMDialogForm;
end;

function TRMApplication.GetLocalLizedPropertyNames: Boolean;
begin
  Result := RM_Class.RMLocalizedPropertyNames;
end;

procedure TRMApplication.SetLocalLizedPropertyNames(Value: Boolean);
begin
  RM_Class.RMLocalizedPropertyNames := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure TRMView_Read_spLeft(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMView(Args.Obj).spLeft;
end;

procedure TRMView_Read_spTop(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMView(Args.Obj).spTop;
end;

procedure TRMView_Read_spWidth(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMView(Args.Obj).spWidth;
end;

procedure TRMView_Read_spHeight(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMView(Args.Obj).spHeight;
end;

procedure TRMView_Write_spLeft(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMView(Args.Obj).spLeft := Value;
end;

procedure TRMView_Write_spTop(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMView(Args.Obj).spTop := Value;
end;

procedure TRMView_Write_spWidth(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMView(Args.Obj).spWidth := Value;
end;

procedure TRMView_Write_spHeight(const Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMView(Args.Obj).spHeight := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure TRMBand_Next(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMBand(Args.Obj).DataSet.Next;
end;

procedure TRMBand_Prior(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMBand(Args.Obj).DataSet.Prior;
end;

procedure TRMBand_First(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMBand(Args.Obj).DataSet.First;
end;

procedure TRMBand_Read_Objects(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TRMBand(Args.Obj).Objects[Args.Values[0]]);
end;

//procedure TRMBand_MoveBy(var Value: Variant; Args: TJvInterpreterArgs);
//begin
//end;

procedure TRMPictureView_Assign(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMPictureView(Args.Obj).Picture.Assign(TPersistent(V2O(Args.Values[0])));
end;

procedure TRMPictureView_LoadFromFile(var Value: Variant; Args: TJvInterpreterArgs);
var
  liFileName: string;
begin
  liFileName := Args.Values[0];
  if (liFileName <> '') and FileExists(liFileName) then
    TRMPictureView(Args.Obj).Picture.LoadFromFile(liFileName)
  else
    TRMPictureView(Args.Obj).Picture.Bitmap := nil;
end;

procedure TRMCalcMemoView_Reset(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMCalcMemoView(Args.Obj).Reset;
end;

procedure TRMCustomPage_FindObject(var Value: Variant; Args: TJvInterpreterArgs);
var
  t: TRMView;
begin
  t := TRMCustomPage(Args.Obj).FindObject(Args.Values[0]);
  Value := O2V(t);
end;

// TRMDialogPage

procedure TRMDialogPage_Close(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMDialogPage(Args.Obj).FForm.Close;
end;

procedure TRMReportPage_LoadFromFile(var Value: Variant; Args: TJvInterpreterArgs);
var
  liFileName: string;
  x, y: Integer;
begin
  liFileName := Args.Values[0];
  if (liFileName <> '') and FileExists(liFileName) then
  begin
    TRMReportPage(Args.Obj).FbkPicture.LoadFromFile(liFileName);
    if Assigned(TRMReportPage(Args.Obj).FbkPicture.Graphic) then
    begin
      RMGetBitmapPixels(TRMReportPage(Args.Obj).FbkPicture.Graphic, x, y);
      TRMReportPage(Args.Obj).bkPictureWidth := Round(TRMReportPage(Args.Obj).FbkPicture.Graphic.Width * 96 / x);
      TRMReportPage(Args.Obj).bkPictureHeight := Round(TRMReportPage(Args.Obj).FbkPicture.Graphic.Height * 96 / y);
    end;
  end
  else
    TRMReportPage(Args.Obj).FbkPicture.Graphic := nil;
end;

procedure TRMReportPage_ChangePaper(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMReportPage(Args.Obj).ChangePaper(Args.Values[0], Args.Values[1], Args.Values[2],
    Args.Values[3], Args.Values[4]);
end;

procedure TRMDataset_Next(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMDataset(Args.Obj).Next;
end;

procedure TRMDataset_Prior(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMDataset(Args.Obj).Prior;
end;

procedure TRMDataset_First(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMDataset(Args.Obj).First;
end;

procedure TRMDataset_Last(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMDataset(Args.Obj).Last;
end;

procedure TRMDataset_Eof(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMDataset(Args.Obj).Eof;
end;

procedure TRMDataset_Active(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMDataset(Args.Obj).Active;
end;

procedure TRMDataset_RecordNo(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMDataset(Args.Obj).RecordNo;
end;

procedure TRMDataset_FieldValue(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMDataset(Args.Obj).GetFieldValue(Args.Values[0], True);
end;

procedure TRMDataset_IsBlobField(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMDataset(Args.Obj).IsBlobField(Args.Values[0]);
end;

procedure TRMDataset_FieldIsNull(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := TRMDataset(Args.Obj).FieldIsNull(Args.Values[0]);
end;

procedure TRMMemoView_Create(var Value: Variant; Args: TJvInterpreterArgs);
begin
  Value := O2V(TRMMemoView.Create);
end;

type
  TRMReportPageEvent = class(TJvInterpreterEvent)
  private
    procedure OnBeginPageEvent(aPageNo: Integer);
    procedure OnEndPageEvent(aPageNo: Integer);
    procedure OnPreviewClickEvent(Sender: TRMReportView; Button: TMouseButton;
      Shift: TShiftState; var Modified: Boolean);
  end;

procedure TRMReportPageEvent.OnBeginPageEvent(aPageNo: Integer);
begin
  CallFunction(nil, [aPageNo]);
end;

procedure TRMReportPageEvent.OnEndPageEvent(aPageNo: Integer);
begin
  CallFunction(nil, [aPageNo]);
end;

procedure TRMReportPageEvent.OnPreviewClickEvent(Sender: TRMReportView; Button: TMouseButton;
  Shift: TShiftState; var Modified: Boolean);
begin
  CallFunction(nil, [O2V(Sender), Button, S2V(Byte(Shift)), Modified]);
  Modified := Args.Values[3];
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

const
  cReportMachine = 'RM_Class';
  cRM_Common = 'RM_Common';
  cRM_DataSet = 'RM_DataSet';

procedure RM_RegisterRAI2Adapter(RAI2Adapter: TJvInterpreterAdapter);
var
  i: Integer;
begin
  with RAI2Adapter do
  begin
    for i := 0 to 41 do
    begin
      if i <> 16 then
        AddConst(cReportMachine, RMColorNames[i], RMColors[i])
      else
        AddConst(cReportMachine, RMColorNames[i], clNone);
    end;
    AddConst(cReportMachine, 'clNone', clNone);

    AddConst(cReportMachine, 'rmgtMemo', rmgtMemo);
    AddConst(cReportMachine, 'rmgtPicture', rmgtPicture);
    AddConst(cReportMachine, 'rmgtCalcMemo', rmgtCalcMemo);
    AddConst(cReportMachine, 'rmgtBand', rmgtBand);
    AddConst(cReportMachine, 'gtShape', rmgtShape);
    AddConst(cReportMachine, 'rmgtAddIn', rmgtAddIn);

    AddClass(cReportMachine, TRMView, 'TRMView');
    AddGet(TRMView, 'spLeft', TRMView_Read_spLeft, 0, [0], varEmpty);
    AddSet(TRMView, 'spLeft', TRMView_Write_spLeft, 0, [0]);
    AddGet(TRMView, 'spTop', TRMView_Read_spTop, 0, [0], varEmpty);
    AddSet(TRMView, 'spTop', TRMView_Write_spTop, 0, [0]);
    AddGet(TRMView, 'spWidth', TRMView_Read_spWidth, 0, [0], varEmpty);
    AddSet(TRMView, 'spWidth', TRMView_Write_spWidth, 0, [0]);
    AddGet(TRMView, 'spHeight', TRMView_Read_spHeight, 0, [0], varEmpty);
    AddSet(TRMView, 'spHeight', TRMView_Write_spHeight, 0, [0]);

    // TRMMemoView
    AddClass(cReportMachine, TRMMemoView, 'TRMMemoView');
    AddGet(TRMMemoView, 'Create', TRMMemoView_Create, 0, [varEmpty], varEmpty);

    AddClass(cReportMachine, TRMDialogComponent, 'TRMDialogComponent');
    AddClass(cReportMachine, TRMDialogControl, 'TRMDialogControl');
    AddClass(cReportMachine, TRMReportView, 'TRMReportView');
    AddClass(cReportMachine, TRMStretcheableView, 'TRMStretcheableView');
    AddClass(cReportMachine, TRMCalcMemoView, 'TRMCalcMemoView');
    AddClass(cReportMachine, TRMPictureView, 'TRMPictureView');
    AddClass(cReportMachine, TRMShapeView, 'TRMShapeView');
    AddClass(cReportMachine, TRMSubReportView, 'TRMSubReportView');

    AddClass(cReportMachine, TRMCustomBandView, 'TRMCustomBandView');
    AddClass(cReportMachine, TRMBand, 'TRMBand');
    AddClass(cReportMachine, TRMBandReportTitle, 'TRMBandReportTitle');
    AddClass(cReportMachine, TRMBandReportSummary, 'TRMBandReportSummary');
    AddClass(cReportMachine, TRMBandPageHeader, 'TRMBandPageHeader');
    AddClass(cReportMachine, TRMBandPageFooter, 'TRMBandPageFooter');
    AddClass(cReportMachine, TRMBandColumnHeader, 'TRMBandColumnHeader');
    AddClass(cReportMachine, TRMBandColumnFooter, 'TRMBandColumnFooter');
    AddClass(cReportMachine, TRMBandHeader, 'TRMBandHeader');
    AddClass(cReportMachine, TRMBandFooter, 'TRMBandFooter');
    AddClass(cReportMachine, TRMBandMasterData, 'TRMBandMasterData');
    AddClass(cReportMachine, TRMBandDetailData, 'TRMBandDetailData');
    AddClass(cReportMachine, TRMBandGroupHeader, 'TRMBandGroupHeader');
    AddClass(cReportMachine, TRMBandGroupFooter, 'TRMBandGroupFooter');
    AddClass(cReportMachine, TRMBandOverlay, 'TRMBandOverlay');
    AddClass(cReportMachine, TRMBandCrossHeader, 'TRMBandCrossHeader');
    AddClass(cReportMachine, TRMBandCrossData, 'TRMBandCrossData');
    AddClass(cReportMachine, TRMBandCrossFooter, 'TRMBandCrossFooter');
    AddClass(cReportMachine, TRMBandCrossFooter, 'TRMBandCrossFooter');

    AddClass(cReportMachine, TRMCustomPage, 'TRMCustomPage');
    AddClass(cReportMachine, TRMDialogPage, 'TRMDialogPage');
    AddClass(cReportMachine, TRMReportPage, 'TRMReportPage');

    // TRMReport
    AddClass(cReportMachine, TRMReport, 'TRMReport');

    // TRMPrinterOrientation
    AddConst(cReportMachine, 'rmpoPortrait', rmpoPortrait);
    AddConst(cReportMachine, 'rmpoLandscape', rmpoLandscape);

    // TRMVAlign
    AddConst(cReportMachine, 'rmvTop', rmvTop);
    AddConst(cReportMachine, 'rmvBottom', rmvBottom);
    AddConst(cReportMachine, 'rmvCenter', rmvCenter);

    // TRMHAlign
    AddConst(cReportMachine, 'rmhLeft', rmhLeft);
    AddConst(cReportMachine, 'rmhCenter', rmhCenter);
    AddConst(cReportMachine, 'rmhRight', rmhRight);
    AddConst(cReportMachine, 'rmhTop', rmhEuqal);

    // TRMDocMode
    AddConst(cReportMachine, 'rmdmDesigning', rmdmDesigning);
    AddConst(cReportMachine, 'rmdmPrinting', rmdmPrinting);
    AddConst(cReportMachine, 'rmdmPreviewing', rmdmPreviewing);

    // TRMDrawMode
    AddConst(cReportMachine, 'rmdmAll', rmdmAll);
    AddConst(cReportMachine, 'rmdmAfterCalcHeight', rmdmAfterCalcHeight);
    AddConst(cReportMachine, 'rmdmPart', rmdmPart);

    // TRMPrintPages
    AddConst(cReportMachine, 'rmppAll', rmppAll);
    AddConst(cReportMachine, 'rmppOdd', rmppOdd);
    AddConst(cReportMachine, 'rmppEven', rmppEven);

    // TRMColumnDirectionType
    AddConst(cReportMachine, 'rmcdTopBottomLeftRight', rmcdTopBottomLeftRight);
    AddConst(cReportMachine, 'rmcdLeftRightTopBottom', rmcdLeftRightTopBottom);

    // TRMDBCalcType
    AddConst(cReportMachine, 'rmdcSum', rmdcSum);
    AddConst(cReportMachine, 'rmdcCount', rmdcCount);
    AddConst(cReportMachine, 'rmdcAvg', rmdcAvg);
    AddConst(cReportMachine, 'rmdcMax', rmdcMax);
    AddConst(cReportMachine, 'rmdcMin', rmdcMin);
    AddConst(cReportMachine, 'rmdcUser', rmdcUser);

    // TRMRotationType
    AddConst(cReportMachine, 'rmrtNone', rmrtNone);
    AddConst(cReportMachine, 'rmrt90', rmrt90);
    AddConst(cReportMachine, 'rmrt180', rmrt180);
    AddConst(cReportMachine, 'rmrt270', rmrt270);
    AddConst(cReportMachine, 'rmrt360', rmrt360);

    // TRMScaleFontType
    AddConst(cReportMachine, 'rmstNone', rmstNone);
    AddConst(cReportMachine, 'rmstByWidth', rmstByWidth);
    AddConst(cReportMachine, 'rmstByHeight', rmstByHeight);

    // TRMScaleFontType
    AddConst(cReportMachine, 'rmReportPerReport', rmReportPerReport);
    AddConst(cReportMachine, 'rmPagePerPage', rmPagePerPage);

    // TRMBandAlign
    AddConst(cReportMachine, 'rmbaNone', rmbaNone);
    AddConst(cReportMachine, 'rmbaLeft', rmbaLeft);
    AddConst(cReportMachine, 'rmbaRight', rmbaRight);
    AddConst(cReportMachine, 'rmbaBottom', rmbaBottom);
    AddConst(cReportMachine, 'rmbaTop', rmbaTop);
    AddConst(cReportMachine, 'rmbaCenter', rmbaCenter);

    // TRMShiftMode
    AddConst(cReportMachine, 'rmsmAlways', rmsmAlways);
    AddConst(cReportMachine, 'rmsmNever', rmsmNever);
    AddConst(cReportMachine, 'rmsmWhenOverlapped', rmsmWhenOverlapped);

    //  TRMSubReportType
    AddConst(cReportMachine, 'rmstFixed', rmstFixed);
    AddConst(cReportMachine, 'rmstChild', rmstChild);

    //  TRMShapeType
    AddConst(cReportMachine, 'rmskRectangle', rmskRectangle);
    AddConst(cReportMachine, 'rmskRoundRectangle', rmskRoundRectangle);
    AddConst(cReportMachine, 'rmskEllipse', rmskEllipse);
    AddConst(cReportMachine, 'rmskTriangle', rmskTriangle);
    AddConst(cReportMachine, 'rmskDiagonal1', rmskDiagonal1);
    AddConst(cReportMachine, 'rmskDiagonal2', rmskDiagonal2);
    AddConst(cReportMachine, 'rmskSquare', rmskSquare);
    AddConst(cReportMachine, 'rmskRoundSquare', rmskRoundSquare);
    AddConst(cReportMachine, 'rmskCircle', rmskCircle);
    AddConst(cReportMachine, 'rmHorLine', rmHorLine);
    AddConst(cReportMachine, 'rmRightAndLeft', rmRightAndLeft);
    AddConst(cReportMachine, 'rmTopAndBottom', rmTopAndBottom);
    AddConst(cReportMachine, 'rmVertLine', rmVertLine);

    //  TRMUnitType
    AddConst(cRM_Common, 'rmutScreenPixels', rmutScreenPixels);
    AddConst(cRM_Common, 'rmutInches', rmutInches);
    AddConst(cRM_Common, 'rmutMillimeters', rmutMillimeters);
    AddConst(cRM_Common, 'rmutMMThousandths', rmutMMThousandths);

    //  TRMPrintMethodType
    AddConst(cReportMachine, 'rmptMetafile', rmptMetafile);
    AddConst(cReportMachine, 'rmptBitmap', rmptBitmap);

    //  TRMPictureSource
    AddConst(cReportMachine, 'rmpsPicture', rmpsPicture);
    AddConst(cReportMachine, 'rmpsFileName', rmpsFileName);

    // TRMBand
    AddConst(cReportMachine, 'rmbtReportTitle', rmbtReportTitle);
    AddConst(cReportMachine, 'rmbtReportSummary', rmbtReportSummary);
    AddConst(cReportMachine, 'rmbtPageHeader', rmbtPageHeader);
    AddConst(cReportMachine, 'rmbtPageFooter', rmbtPageFooter);
    AddConst(cReportMachine, 'rmbtHeader', rmbtHeader);
    AddConst(cReportMachine, 'rmbtFooter', rmbtFooter);
    AddConst(cReportMachine, 'rmbtMasterData', rmbtMasterData);
    AddConst(cReportMachine, 'rmbtDetailData', rmbtDetailData);
    AddConst(cReportMachine, 'rmbtOverlay', rmbtOverlay);
    AddConst(cReportMachine, 'rmbtColumnHeader', rmbtColumnHeader);
    AddConst(cReportMachine, 'rmbtColumnFooter', rmbtColumnFooter);
    AddConst(cReportMachine, 'rmbtGroupHeader', rmbtGroupHeader);
    AddConst(cReportMachine, 'rmbtGroupFooter', rmbtGroupFooter);
    AddConst(cReportMachine, 'rmbtCrossHeader', rmbtCrossHeader);
    AddConst(cReportMachine, 'rmbtCrossData', rmbtCrossData);
    AddConst(cReportMachine, 'rmbtCrossFooter', rmbtCrossFooter);
    AddConst(cReportMachine, 'rmbtChild', rmbtChild);
    AddConst(cReportMachine, 'rmbtNone', rmbtNone);
    AddGet(TRMBand, 'Next', TRMBand_Next, 0, [0], varEmpty);
    AddGet(TRMBand, 'Prior', TRMBand_Prior, 0, [0], varEmpty);
    AddGet(TRMBand, 'First', TRMBand_First, 0, [0], varEmpty);
    AddIGet(TRMBand, 'Objects', TRMBand_Read_Objects, 1, [0], varEmpty);

    // TRMPictureVIew
    AddGet(TRMPictureView, 'LoadFromFile', TRMPictureView_LoadFromFile, 1, [0], varEmpty);
    AddGet(TRMPictureView, 'Assign', TRMPictureView_Assign, 1, [0], varEmpty);

    // TRMCustomMemoView

    // TRMCalcMemoView
    AddGet(TRMCalcMemoView, 'Reset', TRMCalcMemoView_Reset, 0, [0], varEmpty);

    // TRMCustomPage
    AddGet(TRMCustomPage, 'FindObject', TRMCustomPage_FindObject, 1, [0], varEmpty);

    // TRMReportPage
    AddGet(TRMReportPage, 'LoadFromFile', TRMReportPage_LoadFromFile, 1, [0], varEmpty);
    AddGet(TRMReportPage, 'ChangePaper', TRMReportPage_ChangePaper, 5, [0], varEmpty);

    // TRMDialogPage
    AddGet(TRMDialogPage, 'Close', TRMDialogPage_Close, 0, [0], varEmpty);

    // TRMRageBegin
    AddConst(cRM_DataSet, 'rmrbFirst', rmrbFirst);
    AddConst(cRM_DataSet, 'rmrbCurrent', rmrbCurrent);

    // TRMRangeEnd
    AddConst(cRM_DataSet, 'rmreLast', rmreLast);
    AddConst(cRM_DataSet, 'rmreCurrent', rmreCurrent);
    AddConst(cRM_DataSet, 'rmreCount', rmreCount);

    // TRMDataset
    AddClass(cRM_DataSet, TRMDataset, 'TRMDataset');

    AddGet(TRMDataset, 'Next', TRMDataset_Next, 0, [0], varEmpty);
    AddGet(TRMDataset, 'Prior', TRMDataset_Prior, 0, [0], varEmpty);
    AddGet(TRMDataset, 'First', TRMDataset_First, 0, [0], varEmpty);
    AddGet(TRMDataset, 'Last', TRMDataset_Last, 0, [0], varEmpty);
    AddGet(TRMDataset, 'Eof', TRMDataset_Eof, 0, [0], varEmpty);
    AddGet(TRMDataset, 'Active', TRMDataset_Active, 0, [0], varEmpty);
    AddGet(TRMDataset, 'RecordNo', TRMDataset_RecordNo, 0, [0], varEmpty);
    AddGet(TRMDataset, 'FieldValue', TRMDataset_FieldValue, 1, [0], varEmpty);
    AddGet(TRMDataset, 'IsBlobField', TRMDataset_IsBlobField, 1, [0], varEmpty);
    AddGet(TRMDataset, 'FieldIsNull', TRMDataset_FieldIsNull, 1, [0], varEmpty);

    AddHandler(cReportMachine, 'TRMBeginPageEvent', TRMReportPageEvent, @TRMReportPageEvent.OnBeginPageEvent);
    AddHandler(cReportMachine, 'TRMEndPageEvent', TRMReportPageEvent, @TRMReportPageEvent.OnEndPageEvent);
    AddHandler(cReportMachine, 'TRMPreviewClickEvent', TRMReportPageEvent, @TRMReportPageEvent.OnPreviewClickEvent);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure DoInit;
begin
  RMScreen := Screen;
  RMApplication := TRMApplication.Create(nil);

  RMExtendFormPath := ExtractFileDir(ParamStr(0)) + '\';
  //  RMUseNull := True;
  RMLocalizedPropertyNames := False;
  RMUnits := rmutScreenPixels;

  RMVariables := TRMVariables.Create;

  RMRegisterFunctionLibrary(TRMStdFunctionLibrary);

  RMDialogForm := TForm.Create(nil);
  RMDialogForm.SetBounds(-1000, -1000, 1, 1);
  RMDialogForm.Name := 'RMDialogForm';
  //  RMDialogForm.Show;

  RMLocalizeGlobals;
end;

procedure DoExit;
begin
  FreeAndNil(RMApplication);
  FreeAndNil(RMVariables);

  RMUnRegisterFunctionLibrary(TRMStdFunctionLibrary);
  if FSBmp <> nil then
  begin
    FreeAndNil(FSBmp);
  end;
  if FBandBmp <> nil then
  begin
    FreeAndNil(FBandBmp);
  end;

  FreeAndNil(RMDialogForm);
  FreeAndNil(FResourceManager);
end;

initialization
  {$IFDEF USE_INTERNAL_JVCL}
  rm_JvInterpreter_System.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_SysUtils.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_Classes.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_Windows.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_Graphics.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_Controls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_StdCtrls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_Dialogs.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_Forms.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_Db.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  //  rm_JvInterpreter_JvInterpreter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  //  rm_JvInterpreter_JvUtils.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  rm_JvInterpreter_Types.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  {$ELSE}
  JvInterpreter_System.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_SysUtils.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Classes.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Windows.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Graphics.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Controls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_StdCtrls.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Dialogs.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Forms.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Db.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  //  JvInterpreter_JvInterpreter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  //  JvInterpreter_JvUtils.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  JvInterpreter_Types.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  {$ENDIF}

  RM_RegisterRAI2Adapter(GlobalJvInterpreterAdapter);

  DoInit;

finalization
  DoExit;

end.

