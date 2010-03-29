
unit RM_Ctrls;

interface

{$I RM.inc}
{$R RM_common.res}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Commctrl, Menus, Mask, Buttons, RM_Common
{$IFDEF USE_TB2K}
  , TB2Item, TB2ExtItems, TB2Dock, TB2Toolbar, TB2ToolWindow, TB2Common
{$ELSE}
{$IFDEF USE_INTERNALTB97}
  , RM_TB97Ctls, RM_TB97Tlbr, RM_TB97, RM_TB97Tlwn
{$ELSE}
  , TB97Ctls, TB97Tlbr, TB97, TB97Tlwn
{$ENDIF}
{$ENDIF}
{$IFDEF DELPHI4}, ImgList{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

const
  MaxColorButtonNumber = 40;

type
  TRMSubMenuItem = class;

  {TRMDock}
{$IFDEF USE_TB2k}
  TRMDock = TTBDock;
{$ELSE}
  TRMDock = class(TDock97);
{$ENDIF}

  {TRMToolbar}
{$IFDEF USE_TB2k}
  TRMToolbar = class(TTBToolbar)
  private
    function GetDockedto: TRMDock;
    procedure SetDockedto(Value: TRMDock);
  public
    property Dockedto: TRMDock read GetDockedto write SetDockedto;
  end;
{$ELSE}
  TRMToolbar = TToolbar97;
{$ENDIF}

  {TRMToolbarSep}
{$IFDEF USE_TB2k}
  TRMToolbarSep = class(TTBSeparatorItem)
{$ELSE}
  TRMToolbarSep = class(TToolbarSep97)
{$ENDIF}
  private
    procedure SetAddTo(Value: TRMToolbar);
  public
    property AddTo: TRMToolbar write SetAddTo;
  end;

  {TRMEdit}
{$IFDEF USE_TB2K}
  TRMEdit = class(TTBEditItem)
{$ELSE}
  TRMEdit = class(TEdit97)
{$ENDIF}
  private
    procedure SetAddTo(Value: TRMToolbar);
  public
    property AddTo: TRMToolbar write SetAddTo;
  end;

  {TRMMenuBar}
{$IFDEF USE_TB2K}
  TRMMenuBar = TRMToolbar;
{$ELSE}
  TRMMenuBar = class(TMainMenu)
  public
    Dockedto: TRMDock;
    MenuBar: Boolean;
  end;
{$ENDIF}

  {TRMPopupMenu}
{$IFDEF USE_TB2k}
  TRMPopupMenu = TTBPopupMenu;
{$ELSE}
  TRMPopupMenu = TPopupMenu;
{$ENDIF}

  {TRMCustomMenuItem}
{$IFDEF USE_TB2K}
  TRMCustomMenuItem = class(TTBItem)
  private
    function GetRadioItem: boolean;
    procedure SetRadioItem(Value: boolean);
    procedure SetAddTo(Value: TRMToolbar);
  public
    property RadioItem: boolean read GetRadioItem write SetRadioItem;
    property AddTo: TRMToolbar write SetAddTo;
{$ELSE}
  TRMCustomMenuItem = class(TMenuItem)
  private
    function GetImages: TCustomImageList;
    procedure SetImages(Value: TCustomImageList);
  public
    property Images: TCustomImageList read GetImages write SetImages;
{$ENDIF}
  public
    procedure AddToMenu(Value: TRMMenuBar); overload;
    procedure AddToMenu(Value: TRMCustomMenuItem); overload;
    procedure AddToMenu(Value: TRMSubMenuItem); overload;
    procedure AddToMenu(Value: TRMPopupMenu); overload;
  end;

  TRMMenuItem = class(TRMCustomMenuItem);

  {TRMSubMenuItem}
{$IFDEF USE_TB2K}
  TRMSubMenuItem = class(TTBSubmenuItem)
  private
    procedure SetAddTo(Value: TRMToolbar);
  public
    procedure AddToMenu(Value: TRMMenuBar); overload;
    procedure AddToMenu(Value: TRMCustomMenuItem); overload;
    procedure AddToMenu(Value: TRMSubMenuItem); overload;
    procedure AddToMenu(Value: TRMPopupMenu); overload;
    property AddTo: TRMToolbar write SetAddTo;
  end;
{$ELSE}
  TRMSubMenuItem = class(TRMMenuItem);
{$ENDIF}

  {TRMSeparatorMenuItem}
{$IFDEF USE_TB2K}
  TRMSeparatorMenuItem = class(TTBSeparatorItem)
  public
    procedure AddToMenu(Value: TRMMenuBar); overload;
    procedure AddToMenu(Value: TRMCustomMenuItem); overload;
    procedure AddToMenu(Value: TRMSubMenuItem); overload;
    procedure AddToMenu(Value: TRMPopupMenu); overload;
  end;
{$ELSE}
  TRMSeparatorMenuItem = class(TRMMenuItem)
  private
  public
    constructor Create(AOwner: TComponent); override;
  end;
{$ENDIF}

{$IFDEF USE_TB2k}
  TRMToolbarButton = class(TTBItem)
  private
    function GetDown: Boolean;
    procedure SetDown(Value: Boolean);
    function GetAllowAllUp: Boolean;
    procedure SetAllowAllUp(Value: Boolean);
    procedure SetAddTo(Value: TRMToolBar);
  public
    property AddTo: TRMToolBar write SetAddTo;
    property AllowAllUp: Boolean read GetAllowAllup write SetAllowAllup;
    property Down: Boolean read GetDown write SetDown;
  end;
{$ELSE}
  TRMToolbarButton = class(TToolbarButton97)
  private
    procedure SetAddTo(Value: TRMToolBar);
  public
    property AddTo: TRMToolBar write SetAddTo;
  end;
{$ENDIF}

  TComboState97 = set of (csButtonPressed, csMouseCaptured);

  TCustomComboBox97 = class(TCustomComboBox)
  private
    FFlat: Boolean;
    FOldColor: TColor;
    FOldParentColor: Boolean;
    FButtonWidth: Integer;
    FEditState: TComboState97;
    FMouseInControl: Boolean;
    procedure SetFlat(const Value: Boolean);
    procedure DrawButtonBorder(DC: HDC);
    procedure DrawControlBorder(DC: HDC);
    procedure DrawBorders;
    function NeedDraw3DBorder: Boolean;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure TrackButtonPressed(X, Y: Integer);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    property Flat: Boolean read FFlat write SetFlat default True;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TRMComboBox97 = class(TCustomComboBox97)
  published
    property Style; // Debe ser siempre la primera
    property Flat;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property Items;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
  end;

  TRMSpinButtonState = (rmsbNotDown, rmsbTopDown, rmsbBottomDown);

  {TRMSpinButton}
  TRMSpinButton = class(TGraphicControl)
  private
    FDown: TRMSpinButtonState;
    FUpBitmap: TBitmap;
    FDownBitmap: TBitmap;
    FDragging: Boolean;
    FInvalidate: Boolean;
    FTopDownBtn: TBitmap;
    FBottomDownBtn: TBitmap;
    FRepeatTimer: TTimer;
    FNotDownBtn: TBitmap;
    FLastDown: TRMSpinButtonState;
    FFocusControl: TWinControl;
    FOnTopClick: TNotifyEvent;
    FOnBottomClick: TNotifyEvent;
    procedure TopClick;
    procedure BottomClick;
    procedure GlyphChanged(Sender: TObject);
    procedure SetDown(Value: TRMSpinButtonState);
    procedure DrawAllBitmap;
    procedure DrawBitmap(ABitmap: TBitmap; ADownState: TRMSpinButtonState);
    procedure TimerExpired(Sender: TObject);
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Down: TRMSpinButtonState read FDown write SetDown default rmsbNotDown;
  published
  end;

  {TRMSpinEdit}

  TRMValueType = (rmvtInteger, rmvtFloat);

  TRMSpinEdit = class(TCustomEdit)
  private
    FAlignment: TAlignment;
    FMinValue: Extended;
    FMaxValue: Extended;
    FIncrement: Extended;
    FDecimal: Byte;
    FChanging: Boolean;
    FEditorEnabled: Boolean;
    FValueType: TRMValueType;
    FButton: TRMSpinButton;
    FBtnWindow: TWinControl;
    FArrowKeys: Boolean;
    FOnTopClick: TNotifyEvent;
    FOnBottomClick: TNotifyEvent;
    FUpDown: TCustomUpDown;
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    function GetMinHeight: Integer;
    procedure GetTextHeight(var SysHeight, Height: Integer);
    function GetValue: Extended;
    function CheckValue(NewValue: Extended): Extended;
    function GetAsInteger: Longint;
    function IsIncrementStored: Boolean;
    function IsValueStored: Boolean;
    procedure SetArrowKeys(Value: Boolean);
    procedure SetAsInteger(NewValue: Longint);
    procedure SetValue(NewValue: Extended);
    procedure SetValueType(NewType: TRMValueType);
    procedure SetDecimal(NewValue: Byte);
    function GetButtonWidth: Integer;
    procedure RecreateButton;
    procedure ResizeButton;
    procedure SetEditRect;
    procedure SetAlignment(Value: TAlignment);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TMessage); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMPaste(var Message: TWMPaste); message WM_PASTE;
    procedure WMCut(var Message: TWMCut); message WM_CUT;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
{$IFDEF Delphi4}
    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
{$ENDIF}
  protected
    procedure Change; override;
    function IsValidChar(Key: Char): Boolean; virtual;
    procedure UpClick(Sender: TObject); virtual;
    procedure DownClick(Sender: TObject); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AsInteger: Longint read GetAsInteger write SetAsInteger default 0;
    property Text;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property ArrowKeys: Boolean read FArrowKeys write SetArrowKeys default True;
    property Decimal: Byte read FDecimal write SetDecimal default 2;
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property Increment: Extended read FIncrement write FIncrement stored IsIncrementStored;
    property MaxValue: Extended read FMaxValue write FMaxValue;
    property MinValue: Extended read FMinValue write FMinValue;
    property ValueType: TRMValueType read FValueType write SetValueType;
    property Value: Extended read GetValue write SetValue stored IsValueStored;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnBottomClick: TNotifyEvent read FOnBottomClick write FOnBottomClick;
    property OnTopClick: TNotifyEvent read FOnTopClick write FOnTopClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  { TRMPopupWindow }
  TRMPopupWindow = class(TForm)
  private
    FSave: HWND;
    FForm: TCustomForm;
    FCaller: TControl;
    FWidth: Integer;
    FOnClose: TNotifyEvent;
    FOnPopup: TNotifyEvent;

    procedure DoClosePopupWindow;
    procedure WMKILLFOCUS(var message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure PopupWindow(ACaller: TControl);
  protected
    procedure DestroyWnd; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    procedure Close(Sender: TObject = nil);
    procedure Popup(ACaller: TControl);

    property Caller: TControl read FCaller;
  published
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
  end;

  { TRMPopupWindowButton }

  TRMPopupWindowButton = {$IFDEF USE_TB2K}class(TSpeedButton){$ELSE}class(TRMToolbarButton){$ENDIF}
  private
    FActive: Boolean;
    FDropDownPanel: TRMPopupWindow;

    procedure SetActive(aValue: Boolean);
    procedure DropdownPanel_OnClose(Sender: TObject);
    procedure ShowDropDownPanel;
  protected
    function GetDropDownPanel: TRMPopupWindow; virtual;
    procedure SetDropdownPanel(Value: TRMPopupWindow);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;

    property Active: Boolean read FActive write SetActive;
  published
    property DropDownPanel: TRMPopupWindow read GetDropDownPanel write SetDropdownPanel;
  end;

  { TRMColorPickerButton }

  TRMColorType = (rmptFont, rmptLine, rmptFill, rmptHighlight, rmptCustom);

  TRMColorSpeedButton = class(TSpeedButton)
  private
    FCurColor: TColor;
  protected
    procedure Paint; override;
  published
    property CurColor: TColor read FCurColor write FCurColor;
  end;

  TRMColorPickerButton = class(TRMPopupWindowButton)
  private
    FPopup: TRMPopupWindow;

    FColorButtons: array[0..MaxColorButtonNumber - 1] of TRMColorSpeedButton;
    FAutoButton: TRMColorSpeedButton;
    FOtherButton: TSpeedButton;
    FColorDialog: TColorDialog;
    FColorType: TRMColorType;
    FCurrentColor: TColor;
    FAutoColor: TColor;
    FAutoCaption: string;

    FHoriMargin: integer;
    FTopMargin: integer;
    FBottomMargin: integer;
    FDragBarHeight: integer;
    FDragBarSpace: integer;
    FButtonHeight: integer;
    FColorSpace: integer;
    FColorSize: integer;
    FColorSpaceTop: integer;
    FColorSpaceBottom: integer;

    FOnColorChange: TNotifyEvent;

    procedure ColorButtonClick(Sender: TObject);
    procedure DrawButtonGlyph(aColor: TColor);

    procedure SetSelectedColor(const Value: TColor);
    procedure SetColorType(const Value: TRMColorType);
    function GetCustomColors: TStrings;
    procedure SetCustomColors(const Value: TStrings);
  protected
    function GetDropDownPanel: TRMPopupWindow; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property TopMargin: integer read FTopMargin write FTopMargin;
    property BottomMargin: integer read FBottomMargin write FBottomMargin;
    property HoriMargin: integer read FHoriMargin write FHoriMargin;
    property DragBarHeight: integer read FDragBarHeight write FDragBarHeight;
    property DragBarSpace: integer read FDragBarSpace write FDragBarSpace;
    property ColorSpace: integer read FColorSpace write FColorSpace;
    property ColorSpaceTop: integer read FColorSpaceTop write FColorSpaceTop;
    property ColorSpaceBottom: integer read FColorSpaceBottom write FColorSpaceBottom;
    property ColorSize: integer read FColorSize write FColorSize;
    property ButtonHeight: integer read FButtonHeight write FButtonHeight;

    property AutoCaption: string read FAutoCaption write FAutoCaption;
    property CurrentColor: TColor read FCurrentColor write SetSelectedColor;
    property ColorType: TRMColorType read FColorType write SetColorType;
    property CustomColors: TStrings read GetCustomColors write SetCustomColors;

    property OnColorChange: TNotifyEvent read FOnColorChange write FOnColorChange;
  end;

  TRMRulerOrientationType = (roHorizontal, roVertical);

  {@TRMDesignerRuler }
  TRMDesignerRuler = class(TPaintBox) //TGraphicControl)
  private
    FDrawRect: TRect;
    FGuide1X: Integer;
    FGuide1Y: Integer;
    FGuide2X: Integer;
    FGuide2Y: Integer;
    FGuideHeight: Integer;
    FGuideWidth: Integer;
    FHalfTicks: Boolean;
    FMargin: Integer;
    FOrientation: TRMRulerOrientationType;
    FPixelIncrement: Double;
    FScrollOffset: Integer;
    FThickness: Integer;
    FTicksPerUnit: Integer;
    FTickFactor: Single;
    FUnits: TRMUnitType;
    FScale: Double;

    procedure DrawGuide(aGuideX, aGuideY: Integer);
    procedure InitGuides;
    procedure PaintRuler;
    procedure SetOrientation(aOrientation: TRMRulerOrientationType);
    procedure SetUnits(aUnit: TRMUnitType);
    procedure SetScrollOffset(Value: Integer);
    function UpdateGuidePosition(aNewPosition: Integer; var aGuideX, aGuideY: Integer): Boolean;
    procedure ChangeUnits(aUnit: TRMUnitType);
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    procedure Scroll(Value: Integer);
    procedure SetGuides(aPosition1, aPosition2: Integer);
    property Orientation: TRMRulerOrientationType read FOrientation write SetOrientation;
    property Units: TRMUnitType read FUnits write SetUnits;
    property ScrollOffset: Integer read FScrollOffset write SetScrollOffset;
    property PixelIncrement: Double read FPixelIncrement;
    property Scale: Double read FScale write FScale;
  end;

  TRMScrollBarKind = (rmsbHorizontal, rmsbVertical);
  TRMScrollEvent = procedure(Sender: TObject; Kind: TRMScrollBarKind) of object;

  TRMScrollBox = class;

  { TRMScrollBar }
  TRMScrollBar = class(TPersistent)
  private
    FControl: TRMScrollBox;
    FKind: TRMScrollBarKind;
    FMin: integer;
    FMax: integer;
    FPage: integer;
    FPosition: integer;
    FTrackPos: integer;
    FLargeChange: integer;
    FSmallChange: integer;
    FThumbValue: integer;
    FVisible: Boolean;
    FScrollInfo: TScrollInfo;

    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetSmallChange(Value: integer);
    procedure SetLargeChange(Value: integer);
    procedure SetPage(Value: integer);
    procedure SetPosition(Value: integer);
    function GetTrackPos: integer;
    procedure SetScrollData(Value: integer; Mask: Cardinal; MinMax: Boolean);
    function GetScrollData(Mask: Cardinal): integer;
    procedure ScrollMessage(var Msg: TWMScroll);
    constructor Create(AControl: TRMScrollBox; AKind: TRMScrollBarKind);
    procedure SetVisible(Value: Boolean);
    function GetBarKind: Word;
  protected
  public
    procedure Assign(Source: TPersistent); override;

    procedure RefreshLargePage(Value: Integer);
    property Kind: TRMScrollBarKind read FKind;
    property TrackPos: integer read GetTrackPos;
  published
    property Min: integer read FMin write SetMin;
    property Max: integer read FMax write SetMax;
    property SmallChange: integer read FSmallChange write SetSmallChange;
    property LargeChange: integer read FLargeChange write SetLargeChange;
    property Position: integer read FPosition write SetPosition;
    property ThumbValue: integer read FThumbValue write FThumbValue;
    property Visible: Boolean read FVisible write SetVisible;
  end;

  { TRMScrollBox }
  TRMScrollBox = class(TWinControl)
  private
    FBorderStyle: TBorderStyle;
    FHorzScrollBar: TRMScrollBar;
    FVertScrollBar: TRMScrollBar;
    FOnResize: TNotifyEvent;
    FOnChange: TRMScrollEvent;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVSCroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMNCHitTest(var Message: TMessage); message WM_NCHITTEST;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure SetHorzScrollBar(Value: TRMScrollBar);
    procedure SetVertScrollBar(Value: TRMScrollBar);
    procedure SetBorderStyle(Value: TBorderStyle);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property HorzScrollBar: TRMScrollBar read FHorzScrollBar write SetHorzScrollBar;
    property VertScrollBar: TRMScrollBar read FVertScrollBar write SetVertScrollBar;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Color;
    property Ctl3D;
    property Font;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    property OnChange: TRMScrollEvent read FOnChange write FOnChange;
  end;

function RMNewLine: TRMSeparatorMenuItem;
function RMNewItem(const ACaption: string; AShortCut: TShortCut;
  AChecked, AEnabled: Boolean; AOnClick: TNotifyEvent; hCtx: THelpContext;
  const AName: string; ATag: integer = 0): TRMMenuItem;

implementation

uses RM_Utils, RM_Const, RM_Const1, RM_Class;

const
  sSpinUpBtn = 'RM_MYSPINUP';
  sSpinDownBtn = 'RM_MYSPINDOWN';
  cDropdownComboWidth = 11;

const
  InitRepeatPause = 400; { pause before repeat timer (ms) }
  RepeatPause = 100;

function RMNewLine: TRMSeparatorMenuItem;
begin
  Result := TRMSeparatorMenuItem.Create(Application);
end;

function RMNewItem(const ACaption: string; AShortCut: TShortCut;
  AChecked, AEnabled: Boolean; AOnClick: TNotifyEvent; hCtx: THelpContext;
  const AName: string; ATag: integer = 0): TRMMenuItem;
begin
  Result := TRMMenuItem.Create(Application);
  with Result do
  begin
    Caption := ACaption;
    ShortCut := AShortCut;
    OnClick := AOnClick;
    HelpContext := hCtx;
    Checked := AChecked;
    Enabled := AEnabled;
    //    Name := AName;
    Tag := ATag;
  end;
end;

{------------------------------------------------------------------------------}
{TRMEdit}

procedure TRMEdit.SetAddTo(Value: TRMToolBar);
begin
{$IFDEF USE_TB2k}
  Value.Items.Add(self);
{$ELSE}
  if Parent <> Value then
    Parent := Value;
{$ENDIF}
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMToolbarSep}

procedure TRMToolbarSep.SetAddTo(Value: TRMToolBar);
begin
{$IFDEF USE_TB2k}
  Value.Items.Add(self);
{$ELSE}
  if Parent <> Value then
    Parent := Value;
{$ENDIF}
end;

{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{$IFDEF USE_TB2k}

function TRMToolbar.GetDockedto: TRMDock;
begin
  Result := CurrentDock;
end;

procedure TRMToolbar.SetDockedto(Value: TRMDock);
begin
  CurrentDock := Value;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMToolbarButton}

procedure TRMToolbarButton.SetAddTo(Value: TRMToolBar);
begin
{$IFDEF USE_TB2k}
  Value.Items.Add(self);
{$ELSE}
  if Parent <> Value then
    Parent := Value;
{$ENDIF}
end;

{$IFDEF USE_TB2k}

function TRMToolbarButton.GetDown: Boolean;
begin
  Result := Checked;
end;

procedure TRMToolbarButton.SetDown(Value: Boolean);
begin
  Checked := Value;
end;

function TRMToolbarButton.GetAllowAllUp: Boolean;
begin
  Result := AutoCheck;
end;

procedure TRMToolbarButton.SetAllowAllUp(Value: Boolean);
begin
  AutoCheck := Value;
end;
{$ENDIF}

//dejoy added begin

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMCustomMenuItem}
{$IFDEF USE_TB2k}

function TRMCustomMenuItem.GetRadioItem: boolean;
begin
  Result := AutoCheck;
end;

procedure TRMCustomMenuItem.SetRadioItem(Value: boolean);
begin
  AutoCheck := Value;
end;

procedure TRMCustomMenuItem.SetAddTo(Value: TRMToolBar);
begin
  Value.Items.Add(self);
end;
{$ELSE}

function TRMCustomMenuItem.GetImages: TCustomImageList;
var
  M: TMenu;
begin
  m := GetParentMenu;
  if m <> nil then
    Result := m.Images
  else
    Result := nil;
end;

procedure TRMCustomMenuItem.SetImages(Value: TCustomImageList);
var
  M: TMenu;
begin
  m := GetParentMenu;
  if m <> nil then
    with m do
    begin
      if Images <> Value then
        Images := Value;
    end;
end;
{$ENDIF}

procedure TRMCustomMenuItem.AddToMenu(Value: TRMMenuBar);
begin
  Value.Items.Add(self);
end;

procedure TRMCustomMenuItem.AddToMenu(Value: TRMCustomMenuItem);
begin
  Value.Add(self);
end;

procedure TRMCustomMenuItem.AddToMenu(Value: TRMSubMenuItem);
begin
  Value.Add(self);
end;

procedure TRMCustomMenuItem.AddToMenu(Value: TRMPopupMenu);
begin
  Value.Items.Add(self);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMSubMenuItem}
{$IFDEF USE_TB2K}

procedure TRMSubMenuItem.SetAddTo(Value: TRMToolBar);
begin
  Value.Items.Add(self);
end;

procedure TRMSubMenuItem.AddToMenu(Value: TRMMenuBar);
begin
  Value.Items.Add(self);
end;

procedure TRMSubMenuItem.AddToMenu(Value: TRMCustomMenuItem);
begin
  Value.Add(self);
end;

procedure TRMSubMenuItem.AddToMenu(Value: TRMSubMenuItem);
begin
  Value.Add(self);
end;

procedure TRMSubMenuItem.AddToMenu(Value: TRMPopupMenu);
begin
  Value.Items.Add(self);
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMSeparatorMenuItem }
{$IFDEF USE_TB2K}

procedure TRMSeparatorMenuItem.AddToMenu(Value: TRMMenuBar);
begin
  Value.Items.Add(self);
end;

procedure TRMSeparatorMenuItem.AddToMenu(Value: TRMCustomMenuItem);
begin
  Value.Add(self);
end;

procedure TRMSeparatorMenuItem.AddToMenu(Value: TRMSubMenuItem);
begin
  Value.Add(self);
end;

procedure TRMSeparatorMenuItem.AddToMenu(Value: TRMPopupMenu);
begin
  Value.Items.Add(self);
end;

{$ELSE}

constructor TRMSeparatorMenuItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := '-';
end;
{$ENDIF}

{ TCustomComboBox97 }

constructor TCustomComboBox97.Create(AOwner: TComponent);
begin
  inherited;

  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL) + 2;
  FOldColor := inherited Color;
  FOldParentColor := inherited ParentColor;
  FFlat := True;
end;

procedure TCustomComboBox97.SetFlat(const Value: Boolean);
begin
  if Value <> FFlat then
  begin
    FFlat := Value;
    Ctl3D := not Value;
    Invalidate;
  end;
end;

// Verifica si el botón todavía deba estar presionado

procedure TCustomComboBox97.CMEnter(var Message: TCMEnter);
begin
  inherited;

  if not (csDesigning in ComponentState) then
    DrawBorders;
end;

procedure TCustomComboBox97.CMExit(var Message: TCMExit);
begin
  inherited;

  if not (csDesigning in ComponentState) then
    DrawBorders;
end;

procedure TCustomComboBox97.CMMouseEnter(var Message: TMessage);
begin
  inherited;

  // Si por primera vez el ratón está sobre el ComboBox se redibuja su borde
  if not FMouseInControl and Enabled then
  begin
    FMouseInControl := True;
    DrawBorders;
  end;
end;

procedure TCustomComboBox97.CMMouseLeave(var Message: TMessage);
begin
  inherited;

  // Si el ratón estaba sobre el ComboBox se redibuja su borde
  if FMouseInControl and Enabled then
  begin
    FMouseInControl := False;
    DrawBorders
  end;
end;

procedure TCustomComboBox97.CMEnabledChanged(var Msg: TMessage);
begin
  inherited;

  // Si se desea plano
  if FFlat then
    // Si se habilita se recupera su color anterior ó
    // si se inhabilita se guarda su color actual y se utiliza el del contenedor,
    // así se dá la apariencia del ComboBox inhabilitado de Office97.
    if Enabled then
    begin
      inherited Color := FOldColor;
      inherited ParentColor := FOldParentColor;
    end
    else
    begin
      FOldParentColor := inherited Parentcolor;
      FOldColor := inherited Color;
      inherited ParentColor := True;
    end;
end;

procedure TCustomComboBox97.WMPaint(var Message: TWMPaint);
var
  DC: HDC;
  PS: TPaintStruct;
  procedure DrawButton;
  var
    ARect: TRect;
  begin
    // Obtiene las coordenadas de los límites del botón
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    Inc(ARect.Left, ClientWidth - FButtonWidth);
    InflateRect(ARect, -1, -1);
    // Dibuja el botón
    DrawFrameControl(DC, ARect, DFC_SCROLL, DFCS_SCROLLCOMBOBOX or DFCS_FLAT);
    // Notifica a Windows que ya no tiene que dibujar el botón
    ExcludeClipRect(DC, ClientWidth - FButtonWidth - 4, 0, ClientWidth, ClientHeight);
  end;
begin
  // Si no es plano sólo se hacer lo de omisión
  if not FFlat then
  begin
    inherited;
    Exit;
  end;

  // Utiliza o crea el dispositivo de contexto
  if Message.DC = 0 then
    DC := BeginPaint(Handle, PS)
  else
    DC := Message.DC;
  try
    // Si el estilo así lo requiere dibuja el botón y una base
    if Style <> csSimple then
    begin
      FillRect(DC, ClientRect, Brush.Handle);
      DrawButton; //(DC);
    end;
    // Dibuja el ComboBox
    PaintWindow(DC);
  finally
    // Elimina el dispositivo de contexto si fué creado aquí
    if Message.DC = 0 then
      EndPaint(Handle, PS);
  end;
  // Dibuja los bordes del ComboBox y del botón incluido
  DrawBorders;
end;

function TCustomComboBox97.NeedDraw3DBorder: Boolean;
begin
  // Se requiere dibujar el borde cuando el ratón esta encima
  // o cuando es el control activo.
  if csDesigning in ComponentState then
    Result := Enabled
  else
    Result := FMouseInControl or (Screen.ActiveControl = Self);
end;

// Dibuja el borde del botón incluido

procedure TCustomComboBox97.DrawButtonBorder(DC: HDC);
const
  Flags: array[Boolean] of Integer = (0, BF_FLAT);
var
  ARect: TRect;
  BtnFaceBrush: HBRUSH;
begin
  // Notifica a Windows que no tiene que dibujar sobre botón
  ExcludeClipRect(DC, ClientWidth - FButtonWidth + 4, 4,
    ClientWidth - 4, ClientHeight - 4);
  // Obtiene las coordenadas de los límites del botón
  GetWindowRect(Handle, ARect);
  OffsetRect(ARect, -ARect.Left, -ARect.Top);
  Inc(ARect.Left, ClientWidth - FButtonWidth - 2);
  InflateRect(ARect, -2, -2);

  // Dibuja un borde 3D o plano según se requiera
  if NeedDraw3DBorder then
    DrawEdge(DC, ARect, EDGE_RAISED, BF_RECT or Flags[csButtonPressed in FEditState])
  else
  begin
    BtnFaceBrush := CreateSolidBrush(GetSysColor(COLOR_BTNFACE));
    try
      InflateRect(ARect, -1, -1);
      FillRect(DC, ARect, BtnFaceBrush);
    finally
      DeleteObject(BtnFaceBrush);
    end;
  end;

  // Notifica a Windows que ya no tiene que dibujar el botón
  ExcludeClipRect(DC, ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
end;

// Dibuja el borde del ComboBox

procedure TCustomComboBox97.DrawControlBorder(DC: HDC);
var
  ARect: TRect;
  BtnFaceBrush, WindowBrush: HBRUSH; // Brochas necesarias para el efecto 3D
begin
  // Crea las brochas necesarias para el efecto 3D
  BtnFaceBrush := CreateSolidBrush(GetSysColor(COLOR_BTNFACE));
  WindowBrush := CreateSolidBrush(GetSysColor(COLOR_WINDOW));
  try
    // Obtiene las coordenadas de los límites del ComboBox
    GetWindowRect(Handle, ARect);
    OffsetRect(ARect, -ARect.Left, -ARect.Top);
    // Dibuja un borde 3D o plano según se requiera
    if NeedDraw3DBorder then
    begin
      DrawEdge(DC, ARect, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, WindowBrush);
    end
    else
    begin
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, BtnFaceBrush);
      InflateRect(ARect, -1, -1);
      FrameRect(DC, ARect, WindowBrush);
    end;
  finally
    // Elimina las brochas
    DeleteObject(WindowBrush);
    DeleteObject(BtnFaceBrush);
  end;
end;

// Dibuja los bordes del ComboBox y del botón incluido

procedure TCustomComboBox97.DrawBorders;
var
  DC: HDC;
begin
  // Sólo se continua si es plano
  if not FFlat then
    Exit;

  // Dibuja el borde de la caja y si se requiere del botón incluido
  DC := GetWindowDC(Handle);
  try
    DrawControlBorder(DC);
    if Style <> csSimple then
      DrawButtonBorder(DC);
  finally
    ReleaseDC(DC, Handle);
  end;
end;

procedure TCustomComboBox97.TrackButtonPressed(X, Y: Integer);
var
  ARect: TRect;
begin
  SetRect(ARect, ClientWidth - FButtonWidth, 0, ClientWidth, ClientHeight);
  if (csButtonPressed in FEditState) and not PtInRect(ARect, Point(X, Y)) then
  begin
    Exclude(FEditState, csButtonPressed);
    DrawBorders;
  end;
end;

procedure TCustomComboBox97.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if DroppedDown then
  begin
    Include(FEditState, csButtonPressed);
    Include(FEditState, csMouseCaptured);
    Invalidate;
  end;

  inherited;
end;

procedure TCustomComboBox97.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if csMouseCaptured in FEditState then
    TrackButtonPressed(X, Y);

  inherited;
end;

procedure TCustomComboBox97.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  TrackButtonPressed(-1, -1);

  inherited;
end;

{ TRMSpinButton }

constructor TRMSpinButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUpBitmap := TBitmap.Create;
  FDownBitmap := TBitmap.Create;
  FUpBitmap.Handle := LoadBitmap(HInstance, sSpinUpBtn);
  FDownBitmap.Handle := LoadBitmap(HInstance, sSpinDownBtn);
  FUpBitmap.OnChange := GlyphChanged;
  FDownBitmap.OnChange := GlyphChanged;
  Height := 20;
  Width := 20;
  FTopDownBtn := TBitmap.Create;
  FBottomDownBtn := TBitmap.Create;
  FNotDownBtn := TBitmap.Create;
  DrawAllBitmap;
  FLastDown := rmsbNotDown;
end;

destructor TRMSpinButton.Destroy;
begin
  FTopDownBtn.Free;
  FBottomDownBtn.Free;
  FNotDownBtn.Free;
  FUpBitmap.Free;
  FDownBitmap.Free;
  FRepeatTimer.Free;
  inherited Destroy;
end;

procedure TRMSpinButton.GlyphChanged(Sender: TObject);
begin
  FInvalidate := True;
  Invalidate;
end;

procedure TRMSpinButton.SetDown(Value: TRMSpinButtonState);
var
  OldState: TRMSpinButtonState;
begin
  OldState := FDown;
  FDown := Value;
  if OldState <> FDown then
    Repaint;
end;

procedure TRMSpinButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TRMSpinButton.Paint;
begin
  if not Enabled and not (csDesigning in ComponentState) then
    FDragging := False;
  if (FNotDownBtn.Height <> Height) or (FNotDownBtn.Width <> Width) or FInvalidate then
    DrawAllBitmap;
  FInvalidate := False;
  with Canvas do
    case FDown of
      rmsbNotDown: Draw(0, 0, FNotDownBtn);
      rmsbTopDown: Draw(0, 0, FTopDownBtn);
      rmsbBottomDown: Draw(0, 0, FBottomDownBtn);
    end;
end;

procedure TRMSpinButton.DrawAllBitmap;
begin
  DrawBitmap(FTopDownBtn, rmsbTopDown);
  DrawBitmap(FBottomDownBtn, rmsbBottomDown);
  DrawBitmap(FNotDownBtn, rmsbNotDown);
end;

procedure TRMSpinButton.DrawBitmap(ABitmap: TBitmap; ADownState: TRMSpinButtonState);
var
  R, RSrc: TRect;
  dRect: Integer;
begin
  ABitmap.Height := Height;
  ABitmap.Width := Width;
  with ABitmap.Canvas do
  begin
    R := Bounds(0, 0, Width, Height);
    Pen.Width := 1;
    Brush.Color := clBtnFace;
    Brush.Style := bsSolid;
    FillRect(R);
    { buttons frame }
    Pen.Color := clWindowFrame;
    Rectangle(0, 0, Width, Height);
    MoveTo(-1, Height);
    LineTo(Width, -1);
    { top button }
    if ADownState = rmsbTopDown then
      Pen.Color := clBtnShadow
    else
      Pen.Color := clBtnHighlight;
    MoveTo(1, Height - 4);
    LineTo(1, 1);
    LineTo(Width - 3, 1);
    if ADownState = rmsbTopDown then
      Pen.Color := clBtnHighlight
    else
      Pen.Color := clBtnShadow;
    if ADownState <> rmsbTopDown then
    begin
      MoveTo(1, Height - 3);
      LineTo(Width - 2, 0);
    end;
    { bottom button }
    if ADownState = rmsbBottomDown then
      Pen.Color := clBtnHighlight
    else
      Pen.Color := clBtnShadow;
    MoveTo(2, Height - 2);
    LineTo(Width - 2, Height - 2);
    LineTo(Width - 2, 1);
    if ADownState = rmsbBottomDown then
      Pen.Color := clBtnShadow
    else
      Pen.Color := clBtnHighlight;
    MoveTo(2, Height - 2);
    LineTo(Width - 1, 1);
    { top glyph }
    dRect := 1;
    if ADownState = rmsbTopDown then
      Inc(dRect);
    R := Bounds(Round((Width / 4) - (FUpBitmap.Width / 2)) + dRect,
      Round((Height / 4) - (FUpBitmap.Height / 2)) + dRect, FUpBitmap.Width,
      FUpBitmap.Height);
    RSrc := Bounds(0, 0, FUpBitmap.Width, FUpBitmap.Height);
    BrushCopy(R, FUpBitmap, RSrc, FUpBitmap.TransparentColor);
    { bottom glyph }
    R := Bounds(Round((3 * Width / 4) - (FDownBitmap.Width / 2)) - 1,
      Round((3 * Height / 4) - (FDownBitmap.Height / 2)) - 1,
      FDownBitmap.Width, FDownBitmap.Height);
    RSrc := Bounds(0, 0, FDownBitmap.Width, FDownBitmap.Height);
    BrushCopy(R, FDownBitmap, RSrc, FDownBitmap.TransparentColor);
    if ADownState = rmsbBottomDown then
    begin
      Pen.Color := clBtnShadow;
      MoveTo(3, Height - 2);
      LineTo(Width - 1, 2);
    end;
  end;
end;

procedure TRMSpinButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  FInvalidate := True;
  Invalidate;
end;

procedure TRMSpinButton.TopClick;
begin
  if Assigned(FOnTopClick) then
  begin
    FOnTopClick(Self);
    if not (csLButtonDown in ControlState) then
      FDown := rmsbNotDown;
  end;
end;

procedure TRMSpinButton.BottomClick;
begin
  if Assigned(FOnBottomClick) then
  begin
    FOnBottomClick(Self);
    if not (csLButtonDown in ControlState) then
      FDown := rmsbNotDown;
  end;
end;

procedure TRMSpinButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then
  begin
    if (FFocusControl <> nil) and FFocusControl.TabStop and
      FFocusControl.CanFocus and (GetFocus <> FFocusControl.Handle) then
      FFocusControl.SetFocus;
    if FDown = rmsbNotDown then
    begin
      FLastDown := FDown;
      if Y > (-(Height / Width) * X + Height) then
      begin
        FDown := rmsbBottomDown;
        BottomClick;
      end
      else
      begin
        FDown := rmsbTopDown;
        TopClick;
      end;
      if FLastDown <> FDown then
      begin
        FLastDown := FDown;
        Repaint;
      end;
      if FRepeatTimer = nil then
        FRepeatTimer := TTimer.Create(Self);
      FRepeatTimer.OnTimer := TimerExpired;
      FRepeatTimer.Interval := InitRepeatPause;
      FRepeatTimer.Enabled := True;
    end;
    FDragging := True;
  end;
end;

procedure TRMSpinButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  NewState: TRMSpinButtonState;
begin
  inherited MouseMove(Shift, X, Y);
  if FDragging then
  begin
    if (X >= 0) and (X <= Width) and (Y >= 0) and (Y <= Height) then
    begin
      NewState := FDown;
      if Y > (-(Width / Height) * X + Height) then
      begin
        if (FDown <> rmsbBottomDown) then
        begin
          if FLastDown = rmsbBottomDown then
            FDown := rmsbBottomDown
          else
            FDown := rmsbNotDown;
          if NewState <> FDown then
            Repaint;
        end;
      end
      else
      begin
        if (FDown <> rmsbTopDown) then
        begin
          if (FLastDown = rmsbTopDown) then
            FDown := rmsbTopDown
          else
            FDown := rmsbNotDown;
          if NewState <> FDown then
            Repaint;
        end;
      end;
    end
    else if FDown <> rmsbNotDown then
    begin
      FDown := rmsbNotDown;
      Repaint;
    end;
  end;
end;

procedure TRMSpinButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if FDragging then
  begin
    FDragging := False;
    if (X >= 0) and (X <= Width) and (Y >= 0) and (Y <= Height) then
    begin
      FDown := rmsbNotDown;
      FLastDown := rmsbNotDown;
      Repaint;
    end;
  end;
end;

procedure TRMSpinButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FDown <> rmsbNotDown) and MouseCapture then
  begin
    try
      if FDown = rmsbBottomDown then
        BottomClick
      else
        TopClick;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

function DefBtnWidth: Integer;
begin
  Result := GetSystemMetrics(SM_CXVSCROLL);
  if Result > 15 then
    Result := 15;
end;

type
  TRxUpDown = class(TCustomUpDown)
  private
    FChanging: Boolean;
    procedure ScrollMessage(var Message: TWMVScroll);
    procedure WMHScroll(var Message: TWMHScroll); message CN_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message CN_VSCROLL;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnClick;
  end;

constructor TRxUpDown.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Orientation := udVertical;
  Min := -1;
  Max := 1;
  Position := 0;
end;

destructor TRxUpDown.Destroy;
begin
  OnClick := nil;
  inherited Destroy;
end;

procedure TRxUpDown.ScrollMessage(var Message: TWMVScroll);
begin
  if Message.ScrollCode = SB_THUMBPOSITION then
  begin
    if not FChanging then
    begin
      FChanging := True;
      try
        if Message.Pos > 0 then
          Click(btNext)
        else if Message.Pos < 0 then
          Click(btPrev);
        if HandleAllocated then
          SendMessage(Handle, UDM_SETPOS, 0, 0);
      finally
        FChanging := False;
      end;
    end;
  end;
end;

procedure TRxUpDown.WMHScroll(var Message: TWMHScroll);
begin
  ScrollMessage(TWMVScroll(Message));
end;

procedure TRxUpDown.WMVScroll(var Message: TWMVScroll);
begin
  ScrollMessage(Message);
end;

procedure TRxUpDown.WMSize(var Message: TWMSize);
begin
  inherited;
  if Width <> DefBtnWidth then
    Width := DefBtnWidth;
end;

{ TRMSpinEdit }

constructor TRMSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Text := '0';
  ControlStyle := ControlStyle - [csSetCaption];
  FIncrement := 1.0;
  FDecimal := 2;
  FMinValue := 0;
  FMaxValue := MaxInt;
  FEditorEnabled := True;
  FArrowKeys := True;
  RecreateButton;
end;

destructor TRMSpinEdit.Destroy;
begin
  Destroying;
  FChanging := True;
  if FButton <> nil then
  begin
    FButton.Free;
    FButton := nil;
    FBtnWindow.Free;
    FBtnWindow := nil;
  end;
  if FUpDown <> nil then
  begin
    FUpDown.Free;
    FUpDown := nil;
  end;
  inherited Destroy;
end;

procedure TRMSpinEdit.RecreateButton;
begin
  if (csDestroying in ComponentState) then
    Exit;
  FButton.Free;
  FButton := nil;
  FBtnWindow.Free;
  FBtnWindow := nil;
  FUpDown.Free;
  FUpDown := nil;
  FUpDown := TRxUpDown.Create(Self);
  with TRxUpDown(FUpDown) do
  begin
    Visible := True;
    SetBounds(0, 0, DefBtnWidth, Self.Height);
{$IFDEF Delphi4}
    if (BiDiMode = bdRightToLeft) then
      Align := alLeft
    else
{$ENDIF}
      Align := alRight;
    Parent := Self;
    OnClick := UpDownClick;
  end;
end;

procedure TRMSpinEdit.SetArrowKeys(Value: Boolean);
begin
  FArrowKeys := Value;
  ResizeButton;
end;

procedure TRMSpinEdit.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  if TabStop and CanFocus then
    SetFocus;
  case Button of
    btNext: UpClick(Sender);
    btPrev: DownClick(Sender);
  end;
end;

function TRMSpinEdit.GetButtonWidth: Integer;
begin
  if FUpDown <> nil then
    Result := FUpDown.Width
  else if FButton <> nil then
    Result := FButton.Width
  else
    Result := DefBtnWidth;
end;

procedure TRMSpinEdit.ResizeButton;
var
  R: TRect;
begin
  if FUpDown <> nil then
  begin
    FUpDown.Width := DefBtnWidth;
{$IFDEF Delphi4}
    if (BiDiMode = bdRightToLeft) then
      FUpDown.Align := alLeft
    else
{$ENDIF}
      FUpDown.Align := alRight;
  end
  else if FButton <> nil then
  begin { bkDiagonal }
    if NewStyleControls and Ctl3D and (BorderStyle = bsSingle) then
      R := Bounds(Width - Height - 1, -1, Height - 3, Height - 3)
    else
      R := Bounds(Width - Height, 0, Height, Height);
{$IFDEF Delphi4}
    if (BiDiMode = bdRightToLeft) then
    begin
      if NewStyleControls and Ctl3D and (BorderStyle = bsSingle) then
      begin
        R.Left := -1;
        R.Right := Height - 4;
      end
      else
      begin
        R.Left := 0;
        R.Right := Height;
      end;
    end;
{$ENDIF}
    with R do
      FBtnWindow.SetBounds(Left, Top, Right - Left, Bottom - Top);
    FButton.SetBounds(0, 0, FBtnWindow.Width, FBtnWindow.Height);
  end;
end;

procedure TRMSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if ArrowKeys and (Key in [VK_UP, VK_DOWN]) then
  begin
    if Key = VK_UP then
      UpClick(Self)
    else if Key = VK_DOWN then
      DownClick(Self);
    Key := 0;
  end;
end;

procedure TRMSpinEdit.Change;
begin
  if not FChanging then
    inherited Change;
end;

procedure TRMSpinEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0)
  end;
  if Key <> #0 then
  begin
    inherited KeyPress(Key);
    if (Key = Char(VK_RETURN)) or (Key = Char(VK_ESCAPE)) then
    begin
      { must catch and remove this, since is actually multi-line }
      GetParentForm(Self).Perform(CM_DIALOGKEY, Byte(Key), 0);
      if Key = Char(VK_RETURN) then
        Key := #0;
    end;
  end;
end;

function TRMSpinEdit.IsValidChar(Key: Char): Boolean;
var
  ValidChars: set of Char;
begin
  ValidChars := ['+', '-', '0'..'9'];
  if ValueType = rmvtFloat then
  begin
    if Pos(DecimalSeparator, Text) = 0 then
      ValidChars := ValidChars + [DecimalSeparator];
    if Pos('E', AnsiUpperCase(Text)) = 0 then
      ValidChars := ValidChars + ['e', 'E'];
  end;
  Result := (Key in ValidChars) or (Key < #32);
  if not FEditorEnabled and Result and ((Key >= #32) or
    (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE))) then
    Result := False;
end;

procedure TRMSpinEdit.CreateParams(var Params: TCreateParams);
const
{$IFDEF Delphi4}
  Alignments: array[Boolean, TAlignment] of DWORD =
  ((ES_LEFT, ES_RIGHT, ES_CENTER), (ES_RIGHT, ES_LEFT, ES_CENTER));
{$ELSE}
  Alignments: array[TAlignment] of Longint = (ES_LEFT, ES_RIGHT, ES_CENTER);
{$ENDIF}
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN or
{$IFDEF Delphi4}
  Alignments[UseRightToLeftAlignment, FAlignment];
{$ELSE}
  Alignments[FAlignment];
{$ENDIF}
end;

procedure TRMSpinEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

procedure TRMSpinEdit.SetEditRect;
var
  Loc: TRect;
begin
{$IFDEF Delphi4}
  if (BiDiMode = bdRightToLeft) then
    SetRect(Loc, GetButtonWidth + 1, 0, ClientWidth - 1,
      ClientHeight + 1)
  else
{$ENDIF}
    SetRect(Loc, 0, 0, ClientWidth - GetButtonWidth - 2, ClientHeight + 1);
  SendMessage(Handle, EM_SETRECTNP, 0, Longint(@Loc));
end;

procedure TRMSpinEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

procedure TRMSpinEdit.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  inherited;
  MinHeight := GetMinHeight;
  { text edit bug: if size to less than minheight, then edit ctrl does
    not display the text }
  if Height < MinHeight then
    Height := MinHeight
  else
  begin
    ResizeButton;
    SetEditRect;
  end;
end;

procedure TRMSpinEdit.GetTextHeight(var SysHeight, Height: Integer);
var
  DC: HDC;
  SaveFont: HFont;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  SysHeight := SysMetrics.tmHeight;
  Height := Metrics.tmHeight;
end;

function TRMSpinEdit.GetMinHeight: Integer;
var
  I, H: Integer;
begin
  GetTextHeight(I, H);
  if I > H then
    I := H;
  Result := H + (GetSystemMetrics(SM_CYBORDER) * 4) + 1;
end;

procedure TRMSpinEdit.UpClick(Sender: TObject);
var
  OldText: string;
begin
  if ReadOnly then
    MessageBeep(0)
  else
  begin
    FChanging := True;
    try
      OldText := inherited Text;
      Value := Value + FIncrement;
    finally
      FChanging := False;
    end;
    if CompareText(inherited Text, OldText) <> 0 then
    begin
      Modified := True;
      Change;
    end;
    if Assigned(FOnTopClick) then
      FOnTopClick(Self);
  end;
end;

procedure TRMSpinEdit.DownClick(Sender: TObject);
var
  OldText: string;
begin
  if ReadOnly then
    MessageBeep(0)
  else
  begin
    FChanging := True;
    try
      OldText := inherited Text;
      Value := Value - FIncrement;
    finally
      FChanging := False;
    end;
    if CompareText(inherited Text, OldText) <> 0 then
    begin
      Modified := True;
      Change;
    end;
    if Assigned(FOnBottomClick) then
      FOnBottomClick(Self);
  end;
end;

{$IFDEF Delphi4}

procedure TRMSpinEdit.CMBiDiModeChanged(var Message: TMessage);
begin
  inherited;
  ResizeButton;
  SetEditRect;
end;
{$ENDIF}

procedure TRMSpinEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  ResizeButton;
  SetEditRect;
end;

procedure TRMSpinEdit.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  ResizeButton;
  SetEditRect;
end;

procedure TRMSpinEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if FUpDown <> nil then
  begin
    FUpDown.Enabled := Enabled;
    ResizeButton;
  end;
  if FButton <> nil then
    FButton.Enabled := Enabled;
end;

procedure TRMSpinEdit.WMPaste(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then
    Exit;
  inherited;
end;

procedure TRMSpinEdit.WMCut(var Message: TWMCut);
begin
  if not FEditorEnabled or ReadOnly then
    Exit;
  inherited;
end;

procedure TRMSpinEdit.CMExit(var Message: TCMExit);
begin
  inherited;
  if CheckValue(Value) <> Value then
    SetValue(Value);
end;

procedure TRMSpinEdit.CMEnter(var Message: TMessage);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;
  inherited;
end;

function TRMSpinEdit.GetValue: Extended;
begin
  try
    if (Text <> '') and (Text <> '-') then
    begin
      if ValueType = rmvtFloat then
        Result := StrToFloat(Text)
      else
        Result := StrToInt(Text);
    end
    else
      Result := 0;
  except
    if ValueType = rmvtFloat then
      Result := FMinValue
    else
      Result := Trunc(FMinValue);
  end;
end;

procedure TRMSpinEdit.SetValue(NewValue: Extended);
begin
  if ValueType = rmvtFloat then
    Text := FloatToStrF(CheckValue(NewValue), ffFixed, 15, FDecimal)
  else
    Text := IntToStr(Round(CheckValue(NewValue)));
end;

function TRMSpinEdit.GetAsInteger: Longint;
begin
  Result := Trunc(GetValue);
end;

procedure TRMSpinEdit.SetAsInteger(NewValue: Longint);
begin
  SetValue(NewValue);
end;

procedure TRMSpinEdit.SetValueType(NewType: TRMValueType);
begin
  if FValueType <> NewType then
  begin
    FValueType := NewType;
    Value := GetValue;
    if FValueType in [rmvtInteger] then
    begin
      FIncrement := Round(FIncrement);
      if FIncrement = 0 then
        FIncrement := 1;
    end;
  end;
end;

function TRMSpinEdit.IsIncrementStored: Boolean;
begin
  Result := FIncrement <> 1.0;
end;

function TRMSpinEdit.IsValueStored: Boolean;
begin
  Result := (GetValue <> 0.0);
end;

procedure TRMSpinEdit.SetDecimal(NewValue: Byte);
begin
  if FDecimal <> NewValue then
  begin
    FDecimal := NewValue;
    Value := GetValue;
  end;
end;

function TRMSpinEdit.CheckValue(NewValue: Extended): Extended;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMColorSpeedButton }

const
  LineColorButtonCount = 8;
  SubColorButtonColors: array[0..MaxColorButtonNumber - 1] of TColor = (
    $000000, $003399, $003333, $003300, $663300, $800000, $993333, $333333,
    $000080, $0066FF, $008080, $008000, $808000, $FF0000, $996666, $808080,
    $0000FF, $0099FF, $00CC99, $669933, $CCCC33, $FF6633, $800080, $999999,
    $FF00FF, $00CCFF, $00FFFF, $00FF00, $FFFF00, $FFCC00, $663399, $C0C0C0,
    $CC99FF, $99CCFF, $99FFFF, $CCFFCC, $FFFFCC, $FFCC99, $FF99CC, $FFFFFF);

procedure TRMColorSpeedButton.Paint;
var
  C, S, X, Y: integer;
  R: TRect;
begin
  inherited Paint;

  R := Rect(0, 0, Width - 1, Height - 1);
  with Canvas do
  begin
    if Glyph.Handle <> 0 then
    begin
      X := ((Width + 1) div 2) - 8 + Integer(FState in [TButtonState(bsDown)]);
      Y := ((Height + 1) div 2) + 4 + Integer(FState in [TButtonState(bsDown)]);
      if Enabled then
      begin
        Pen.Color := CurColor;
        Brush.Color := CurColor;
      end
      else
      begin
        Pen.Color := clInactiveCaption;
        Brush.Color := clInactiveCaption;
      end;
      Rectangle(X, Y, X + 16, Y + 4);
    end
    else if Caption = '' then
    begin
      C := (R.Bottom - R.Top) div 6 + 1;
      if Enabled then
      begin
        Pen.Color := clGray;
        Brush.Color := CurColor;
      end
      else
      begin
        Pen.Color := clInactiveCaption;
        Brush.Color := clBtnFace;
      end;
      Brush.Style := bsSolid;
      Rectangle(R.Left + C, R.Top + C, R.Right - C + 1, R.Bottom - C + 1);
    end
    else
    begin
      C := (R.Bottom - R.Top) div 6 + 3;
      S := (R.Bottom - R.Top) div 7;
      if Enabled then
        Pen.Color := clGray
      else
        Pen.Color := clInactiveCaption;
      Brush.Style := bsClear;
      Polygon([Point(R.Left + S, R.Top + S), Point(R.Right - S, R.Top + S), Point(R.Right - S, R.Bottom - S), Point(R.Left + S, R.Bottom - S)]);
      if Enabled then
      begin
        Pen.Color := clGray;
        Brush.Color := CurColor;
      end
      else
      begin
        Pen.Color := clInactiveCaption;
        Brush.Color := clBtnFace;
      end;
      Brush.Style := bsSolid;

      Rectangle(R.Left + C + 1, R.Top + C, R.Bottom - C + 2 + 1, R.Bottom - C + 2);
    end;
  end;
end;

constructor TRMColorPickerButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPopup := nil;
{$IFNDEF USE_TB2K}
  DropdownCombo := True;
  DropdownAlways := True;
{$ENDIF}
  FCurrentColor := clDefault;
  FColorType := rmptFill;
  FAutoColor := clDefault;
  FAutoCaption := RMLoadStr(STransparent);

  FColorDialog := TColorDialog.Create(Self);
  FColorDialog.Options := [cdFullOpen, cdSolidColor, cdAnyColor];

  FButtonHeight := 22;
  FColorSize := 18;
  FColorSpace := 0;
  FColorSpaceTop := 4;
  FColorSpaceBottom := 4;
  FTopMargin := 2;
  FBottomMargin := 4;
  FHoriMargin := 7;
end;

destructor TRMColorPickerButton.Destroy;
begin
  FreeAndNil(FPopup);
  inherited Destroy;
end;

procedure TRMColorPickerButton.DrawButtonGlyph(aColor: TColor);
begin
  Glyph.Canvas.Brush.Color := aColor;
  Glyph.Canvas.Brush.Style := bsSolid;
  Glyph.Canvas.FillRect(Rect(0, 12, 15, 15));

  Invalidate;
end;

procedure TRMColorPickerButton.ColorButtonClick(Sender: TObject);
begin
  if TRMToolbarButton(Sender).Tag = FOtherButton.Tag then // Other Button
  begin
    FColorDialog.Color := FCurrentColor;
    if FColorDialog.Execute then
    begin
      SetSelectedColor(FColorDialog.Color);
      if Assigned(FOnColorChange) then FOnColorChange(Self);
    end;
  end
  else
  begin
    SetSelectedColor(TRMColorSpeedButton(Sender).CurColor);
    if Assigned(FOnColorChange) then FOnColorChange(Self);
  end;

  FPopup.Close(nil);
end;

function TRMColorPickerButton.GetDropDownPanel: TRMPopupWindow;
var
  i: Integer;

  procedure _SetButtonDown;
  var
    i: Integer;
  begin
    FAutoButton.Down := (FAutoButton.Color = FCurrentColor);
    if not FAutoButton.Down then
    begin
      for i := 0 to MaxColorButtonNumber - 1 do
      begin
        FColorButtons[i].Down := (FColorButtons[i].CurColor = FCurrentColor);
      end;
    end;
  end;

begin
  if FPopup <> nil then
  begin
    Result := FPopup;
    _SetButtonDown;
    Exit;
  end;

  FPopup := TRMPopupWindow.CreateNew(nil);
  FPopup.Font.Assign(Font);
  FPopup.ClientWidth := FHoriMargin * 2 + LineColorButtonCount * (FColorSpace + FColorSize);
  FPopup.ClientHeight := FTopMargin + FBottomMargin + FColorSpaceTop * 2 + FColorSpaceBottom +
    (FButtonHeight + FColorSpaceTop) * (MaxColorButtonNumber div LineColorButtonCount);

  FAutoButton := TRMColorSpeedButton.Create(FPopup);
  with FAutoButton do
  begin
    Parent := FPopup;
    Flat := True;
    GroupIndex := 1;
    Tag := MaxColorButtonNumber + 1;
    Down := true;
    AllowAllUp := true;
    CurColor := Self.FAutoColor;
    Caption := 'Automatic';
    OnClick := ColorButtonClick;

    SetBounds(FHoriMargin, FTopMargin + FDragBarHeight + FDragBarSpace + FDragBarHeight,
      FPopup.ClientWidth - FHoriMargin * 2, FButtonHeight);
    Caption := FAutoCaption;
  end;

  for i := 0 to MaxColorButtonNumber - 1 do
  begin
    FColorButtons[i] := TRMColorSpeedButton.Create(FPopup);
    with FColorButtons[i] do
    begin
      Parent := FPopup;
      Flat := True;
      GroupIndex := 1;
      AllowAllUp := true;
      CurColor := SubColorButtonColors[I];
      Tag := I;
      OnClick := ColorButtonClick;

      SetBounds(FAutoButton.Left + (I mod LineColorButtonCount) * (FColorSpace + FColorSize),
        FAutoButton.Top + FAutoButton.Height + FColorSpaceTop + (I div LineColorButtonCount) * (FColorSpace + FColorSize),
        FColorSize, FColorSize);
    end;
  end;

  FOtherButton := TSpeedButton.Create(FPopup);
  with FOtherButton do
  begin
    Parent := FPopup;
    Flat := True;
    Tag := MaxColorButtonNumber + 2;
    Caption := RMLoadStr(SOther);
    SetBounds(FAutoButton.Left,
      FColorButtons[MaxColorButtonNumber - 1].Top + FColorSize + FColorSpaceBottom,
      FAutoButton.Width, FButtonHeight);

    OnClick := ColorButtonClick;
  end;

  DropdownPanel := FPopup;
  Result := FPopup;
  _SetButtonDown;
end;

function TRMColorPickerButton.GetCustomColors: TStrings;
begin
  Result := FColorDialog.CustomColors;
end;

procedure TRMColorPickerButton.SetCustomColors(const Value: TStrings);
begin
  FColorDialog.CustomColors.Assign(Value);
end;

procedure TRMColorPickerButton.SetColorType(const Value: TRMColorType);
begin
  case Value of
    rmptFill:
      begin
        Glyph.Handle := LoadBitmap(hInstance, 'RM_BACKGROUDCOLOR');
        FAutoColor := clNone;
        FAutoCaption := RMLoadStr(STransparent);
      end;
    rmptLine:
      begin
        Glyph.Handle := LoadBitmap(hInstance, 'RM_LINECOLOR');
        FAutoColor := clBlack; //clWindow;
        FAutoCaption := RMLoadStr(rmRes + 878);
      end;
    rmptFont:
      begin
        Glyph.Handle := LoadBitmap(hInstance, 'RM_FONTCOLOR');
        FAutoColor := clWindowText;
        FAutoCaption := RMLoadStr(rmRes + 878);
      end;
    rmptHighlight:
      begin
        Glyph.Handle := LoadBitmap(hInstance, 'RM_HIGHLIGHTCOLOR');
        FAutoColor := clWindow;
        FAutoCaption := RMLoadStr(rmRes + 878);
      end;
  end;

  DrawButtonGlyph(FCurrentColor);
end;

procedure TRMColorPickerButton.SetSelectedColor(const Value: TColor);
begin
  if FCurrentColor <> Value then
  begin
    FCurrentColor := Value;
  end;

  DrawButtonGlyph(FCurrentColor);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

function PixelsPerCentimeter: Double;
begin
  Result := Screen.PixelsPerInch / 2.54;
end;

{ TRMDesignerRuler.Create }

constructor TRMDesignerRuler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FScale := 1;
  Color := clBtnFace;
  Font.Color := clBtnText;
  FGuide1X := -1;
  FGuide1Y := -1;
  FGuide2X := -1;
  FGuide2Y := -1;
  FGuideHeight := 0;
  FGuideWidth := 0;
  FHalfTicks := True;
  FMargin := 0;
  FPixelIncrement := Round(Screen.PixelsPerInch / 8);
  FOrientation := roHorizontal;
  FScrollOffset := 0;
  FThickness := 1;
  FTicksPerUnit := 8;
  FTickFactor := 0.125;
  FUnits := rmutMillimeters;
  ChangeUnits(rmutScreenPixels);
end;

destructor TRMDesignerRuler.Destroy;
begin
  inherited Destroy;
end;

procedure TRMDesignerRuler.Paint;
begin
  if Visible and Enabled then
  begin
    PaintRuler;
  end;
end;

procedure TRMDesignerRuler.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FOrientation = roHorizontal then
    SetGuides(X, 0)
  else
    SetGuides(Y, 0);

  inherited MouseMove(Shift, X, Y);
end;

procedure TRMDesignerRuler.SetUnits(aUnit: TRMUnitType);
begin
  if FUnits = aUnit then Exit;

  ChangeUnits(aUnit);
end;

procedure TRMDesignerRuler.SetOrientation(aOrientation: TRMRulerOrientationType);
begin
  if FOrientation = aOrientation then
    Exit;
  FOrientation := aOrientation;
  Invalidate;
end;

procedure TRMDesignerRuler.PaintRuler;
var
  liTickLength: Integer;
  liFullTickLength: Integer;
  liTick: Integer;
  liPosition: Integer;
  liMaxLength: Integer;
  liTextHeight: Integer;
  liTextWidth: Integer;
  liDrawPosition: Integer;
  ldPosition: Double;

  procedure DrawTick;
  begin
    if FOrientation = roHorizontal then
    begin
      Canvas.MoveTo(liDrawPosition, FMargin);
      Canvas.LineTo(liDrawPosition, FMargin + liTickLength);
    end
    else
    begin
      Canvas.MoveTo(FMargin, liDrawPosition);
      Canvas.LineTo(FMargin + liTickLength, liDrawPosition);
    end;
  end;

  procedure DrawLabel;
  var
    liSpacing: Integer;
    liChar: Integer;
    liLeft: Integer;
    liTop: Integer;
    lRect: TRect;
    lsText: string[10];
  begin
    if (liTick * FTickFactor) >= 10000 then
      lsText := IntToStr(Round((liTick * FTickFactor) / 1000)) + 'k'
    else
      lsText := IntToStr(Round(liTick * FTickFactor));

    if FOrientation = roHorizontal then
    begin
      liTop := FMargin + (FDrawRect.Bottom - FDrawRect.Top) - liTextHeight;
      Canvas.TextOut(liDrawPosition + 2, liTop, lsText);
    end
    else
    begin
      liSpacing := liDrawPosition + 2;
      for liChar := 1 to Length(lsText) do
      begin
        liLeft := FMargin + (FDrawRect.Right - FDrawRect.Left) - liTextWidth - 2;
        lRect.Left := liLeft;
        lRect.Top := liSpacing;
        lRect.Right := liLeft + liTextWidth;
        lRect.Bottom := liSpacing + liTextHeight;
        Canvas.TextRect(lRect, liLeft, liSpacing, lsText[liChar]);
        liSpacing := liSpacing + liTextHeight - 2;
      end;
    end;
  end;

begin
  liPosition := 0;
  liMaxLength := 0;

  InitGuides;
  FDrawRect.Top := 0;
  FDrawRect.Left := 0;
  FDrawRect.Bottom := Self.Height;
  FDrawRect.Right := Self.Width;

  Canvas.Brush.Color := Color;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(FDrawRect);
  if FOrientation = roHorizontal then
  begin
    FDrawRect.Top := 0;
    FDrawRect.Left := 0;
    FDrawRect.Bottom := Self.Height;
    FDrawRect.Right := Self.Width;
    FDrawRect.Top := FMargin;
    FDrawRect.Bottom := Self.Height - FMargin;
    liMaxLength := FDrawRect.Right;
    liPosition := FDrawRect.Left;
  end
  else if FOrientation = roVertical then
  begin
    FDrawRect.Top := 0;
    FDrawRect.Left := 0;
    FDrawRect.Bottom := Self.Height;
    FDrawRect.Right := Self.Width;
    FDrawRect.Left := FMargin;
    FDrawRect.Right := Self.Width - FMargin;
    liMaxLength := FDrawRect.Bottom;
    liPosition := FDrawRect.Top;
  end;

  Canvas.Brush.Color := clWindow;
  Canvas.Brush.Style := bsSolid;
  Canvas.FillRect(FDrawRect);
  Canvas.Font.Name := 'Small Fonts';
  Canvas.Font.Style := [];
  Canvas.Font.Size := 6;
  Canvas.Font.Color := Self.Font.Color;
  liTextHeight := Canvas.TextHeight('0');
  liTextWidth := Canvas.TextWidth('0');

  if FOrientation = roHorizontal then
    liFullTickLength := FDrawRect.Bottom - FDrawRect.Top
  else
    liFullTickLength := FDrawRect.Right - FDrawRect.Left;

  Canvas.Pen.Color := Font.Color;
  Canvas.Pen.Width := 1;
  liTick := 0;
  ldPosition := 0;
  while liPosition < liMaxLength + FScrollOffset do
  begin
    if ((liTick mod FTicksPerUnit) = 0) or (liTick = 0) then
      liTickLength := liFullTickLength
    else if ((liTick mod (FTicksPerUnit div 2)) = 0) and FHalfTicks then
      liTickLength := liFullTickLength div 2
    else
      liTickLength := liFullTickLength div 4;

    liDrawPosition := liPosition - FScrollOffset;
    if liTickLength = liFullTickLength then
      DrawLabel;

    if (liDrawPosition >= 0) and (liTick > 0) then
      DrawTick;

    ldPosition := ldPosition + FPixelIncrement * FScale;
    liPosition := Round(ldPosition);
    Inc(liTick);
  end;
end;

procedure TRMDesignerRuler.SetGuides(aPosition1, aPosition2: Integer);
begin
  if not (Visible and Enabled) then
    Exit;

  DrawGuide(FGuide1X, FGuide1Y);
  UpdateGuidePosition(aPosition1, FGuide1X, FGuide1Y);
  DrawGuide(FGuide1X, FGuide1Y);
end;

procedure TRMDesignerRuler.InitGuides;
begin
  if FOrientation = roHorizontal then
  begin
    FMargin := (Height - Round(0.1354 * Screen.PixelsPerInch)) div 2;
    FGuideWidth := 1;
    FGuideHeight := Round(0.1354 * Screen.PixelsPerInch);
  end
  else
  begin
    FMargin := (Width - Round(0.1354 * Screen.PixelsPerInch)) div 2;
    FGuideWidth := Round(0.1458 * Screen.PixelsPerInch);
    FGuideHeight := 1;
  end;

  FGuide1X := -1;
  FGuide1Y := -1;
  FGuide2X := -1;
  FGuide2Y := -1;
end;

function TRMDesignerRuler.UpdateGuidePosition(aNewPosition: Integer; var aGuideX, aGuideY: Integer): Boolean;
var
  liNewPosition: Integer;
begin
  Result := False;

  if ((FOrientation = roHorizontal) and (aNewPosition = aGuideX)) or
    ((FOrientation = roVertical) and (aNewPosition = aGuideY)) then
    Exit;

  if (FOrientation = roHorizontal) and (aNewPosition < FDrawRect.Left) then
    liNewPosition := FDrawRect.Left
  else if (FOrientation = roVertical) and (aNewPosition > FDrawRect.Bottom) then
    liNewPosition := FDrawRect.Bottom
  else
    liNewPosition := aNewPosition;

  if FOrientation = roHorizontal then
    aGuideX := liNewPosition
  else
    aGuideY := liNewPosition;

  Result := True;
end;

procedure TRMDesignerRuler.DrawGuide(aGuideX, aGuideY: Integer);
begin
  if FOrientation = roHorizontal then
  begin
    if aGuideX = -1 then Exit;
    Canvas.Pen.Mode := pmNot;
    Canvas.MoveTo(aGuideX, FMargin);
    Canvas.LineTo(aGuideX, FGuideHeight + FMargin);
  end
  else
  begin
    if aGuideY = -1 then Exit;
    Canvas.Pen.Mode := pmNot;
    Canvas.MoveTo(FMargin, aGuideY);
    Canvas.LineTo(FGuideWidth + FMargin, aGuideY);
  end;
end;

procedure TRMDesignerRuler.ChangeUnits(aUnit: TRMUnitType);
var
  liUnitLabel: Integer;
  ldScreenPixelsPerUnit: Double;
begin
  if FUnits <> aUnit then
  begin
    FUnits := aUnit;
    case FUnits of
      rmutScreenPixels:
        begin
          liUnitLabel := Screen.PixelsPerInch;
          ldScreenPixelsPerUnit := Screen.PixelsPerInch;
          FTicksPerUnit := Round(Screen.PixelsPerInch / 10);
          FPixelIncrement := ldScreenPixelsPerUnit / FTicksPerUnit;
          FTickFactor := liUnitLabel / FTicksPerUnit;
          FHalfTicks := True;
        end;
      rmutInches:
        begin
          liUnitLabel := 1;
          ldScreenPixelsPerUnit := Screen.PixelsPerInch;
          FTicksPerUnit := 8;
          FPixelIncrement := ldScreenPixelsPerUnit / FTicksPerUnit;
          FTickFactor := liUnitLabel / FTicksPerUnit;
          FHalfTicks := True;
        end;
      rmutMillimeters:
        begin
          liUnitLabel := 10;
          ldScreenPixelsPerUnit := PixelsPerCentimeter;
          FTicksPerUnit := 5;
          FPixelIncrement := ldScreenPixelsPerUnit / FTicksPerUnit;
          FTickFactor := liUnitLabel / FTicksPerUnit;
          FHalfTicks := False;
        end;
      rmutMMThousandths:
        begin
          liUnitLabel := 10000;
          ldScreenPixelsPerUnit := PixelsPerCentimeter;
          FTicksPerUnit := 5;
          FPixelIncrement := ldScreenPixelsPerUnit / FTicksPerUnit;
          FTickFactor := liUnitLabel / FTicksPerUnit;
          FHalfTicks := False;
        end;
    end;

    Invalidate;
  end;
end;

procedure TRMDesignerRuler.Scroll(Value: Integer);
var
  liOldOffset: Integer;
begin
  liOldOffset := FScrollOffset;
  FScrollOffset := FScrollOffset + Value;
  if FScrollOffset < 0 then
    FScrollOffset := 0;
  if FScrollOffset <> liOldOffset then
    Invalidate;
end;

procedure TRMDesignerRuler.SetScrollOffset(Value: Integer);
begin
  if FScrollOffset <> Value then
  begin
    if Value < 0 then
      FScrollOffset := 0
    else
      FScrollOffset := Value;
    Invalidate;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPopupWindow }

constructor TRMPopupWindow.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited;

  BorderIcons := [];
  BorderStyle := bsNone;
  Visible := False;
end;

procedure TRMPopupWindow.DestroyWnd;
begin
  Close(Self);
  inherited;
end;

procedure TRMPopupWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := WS_POPUP + WS_DLGFRAME;
end;

procedure TRMPopupWindow.WMKILLFOCUS(var message: TWMKILLFOCUS);
begin
  DoClosePopupWindow;
end;

procedure TRMPopupWindow.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  InflateRect(Rect, -FWidth, -FWidth);
end;

procedure TRMPopupWindow.AlignControls(AControl: TControl;
  var Rect: TRect);
begin
  AdjustClientRect(Rect);
  inherited;
end;

procedure TRMPopupWindow.DoClosePopupWindow;
begin
  Visible := False;
  try
    if Visible then
    begin
      //    if FForm <> nil then FForm.EnableAutoRange;
      //    if Application.Active and (FSave > 0) then Windows.SetFocus(FSave);

      SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE);
      Parent := nil;
    end;
  finally
    Visible := False;
    FCaller := nil;
  end;
end;

procedure TRMPopupWindow.PopupWindow(ACaller: TControl);
var
  CallerBounds: TRect;
  X, Y, W, H: Integer;
begin
  inherited;
  FCaller := ACaller;
  if Caller is TWinControl then
    GetWindowRect(TWinControl(Caller).Handle, CallerBounds)
  else
  begin
    with Caller.Parent do
    begin
      CallerBounds := Caller.BoundsRect;
      CallerBounds.TopLeft := ClientToScreen(CallerBounds.TopLeft);
      CallerBounds.BottomRight := ClientToScreen(CallerBounds.BottomRight);
    end;
  end;

  W := Self.Width;
  H := Self.Height;
  Windows.SetFocus(Self.Handle);
  Y := CallerBounds.Bottom;
  X := CallerBounds.Left;
  if X + W > Screen.Width then X := CallerBounds.Right - W;
  if Y + H > Screen.Height then Y := CallerBounds.Top - H;
  if X < 0 then X := 0;
  if Y < 0 then Y := 0;

  Self.Left := W;
  Self.Top := H;
  SetWindowPos(Handle, HWND_TOP, X, Y, W, H, SWP_NOACTIVATE or SWP_SHOWWINDOW);
  Visible := True;
end;

procedure TRMPopupWindow.Close(Sender: TObject);
begin
  DoClosePopupWindow;
end;

procedure TRMPopupWindow.Popup(ACaller: TControl);
begin
  FForm := nil;
  FSave := 0;
  if not Active then
  begin
    FCaller := ACaller;
    FForm := GetParentForm(Self);
    FSave := GetFocus;
    if FForm <> nil then FForm.DisableAutoRange;
    if Assigned(FOnPopup) then FOnPopup(Self);

    PopupWindow(ACaller);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPopupWindowButton }

constructor TRMPopupWindowButton.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  Flat := True;
  FActive := False;
  FDropDownPanel := nil;

end;

{$IFDEF USE_TB2K}

procedure TRMPopupWindowButton.SetActive(aValue: Boolean);
begin
  if GetDropDownPanel = nil then Exit;

  FActive := aValue;
  if FActive then
  begin
    ShowDropDownPanel;
  end
  else
  begin
    if FDropDownPanel <> nil then
      FDropDownPanel.Visible := False;
  end;
end;

{$ELSE}

procedure TRMPopupWindowButton.SetActive(aValue: Boolean);
begin
  if GetDropDownPanel = nil then Exit;

  FActive := aValue;
  if FActive then
  begin
    if DropDownCombo then
    begin
      Down := False;
      FState := bsDown;
      ShowDropDownPanel;
      Invalidate;
    end
    else
    begin
      Down := True;
      ShowDropDownPanel;
    end;
  end
  else
  begin
    if FDropDownPanel <> nil then
      FDropDownPanel.Visible := False;

    Down := False;
    FState := bsUp;
    Invalidate;
  end;
end;

{$ENDIF}

function TRMPopupWindowButton.GetDropDownPanel: TRMPopupWindow;
begin
  Result := FDropDownPanel;
end;

procedure TRMPopupWindowButton.SetDropdownPanel(Value: TRMPopupWindow);
begin
  if (FDropdownPanel = Value) then Exit;

  FDropdownPanel := Value;
  if (FDropdownPanel <> nil) then
  begin
    FDropdownPanel.OnClose := DropdownPanel_OnClose;
  end;
end;

procedure TRMPopupWindowButton.DropdownPanel_OnClose(Sender: TObject);
begin
  Active := False;
end;

procedure TRMPopupWindowButton.ShowDropDownPanel;
begin
  if csDesigning in ComponentState then Exit;

  FDropDownPanel.Popup(Self);
end;

procedure TRMPopupWindowButton.Click;
var
  lbTogglePanel: Boolean;
begin
  if Active then
    lbTogglePanel := True
  else
    lbTogglePanel := (GetDropDownPanel <> nil);

  if lbTogglePanel then
    Active := True
  else
    inherited Click;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMScrollBar }

constructor TRMScrollBar.Create(AControl: TRMScrollBox; AKind: TRMScrollBarKind);
begin
  inherited Create;

  FControl := AControl;
  FKind := AKind;
  FVisible := True;

  FSmallChange := 1;
  FLargeChange := 10;

  FMin := 0;
  FMax := 100;
  FPage := 1;
  FPosition := 0;
  FTrackPos := 0;
  FThumbValue := 1;

  FScrollInfo.cbSize := sizeof(TScrollInfo);
  FScrollInfo.nMin := FMin;
  FScrollInfo.nMax := FMax;
  FScrollInfo.nPage := FPage;
  FScrollInfo.nPos := FPosition;
  FScrollInfo.nTrackPos := FTrackPos;
end;

procedure TRMScrollBar.SetScrollData(Value: integer; Mask: Cardinal; MinMax: Boolean);
begin
  FScrollInfo.fMask := Mask;

  if (Mask = SIF_RANGE) and MinMax then
    FScrollInfo.nMin := Value
  else if (Mask = SIF_RANGE) and (not MinMax) then
    FScrollInfo.nMax := Value
  else if Mask = SIF_PAGE then
    FScrollInfo.nPage := Value
  else if Mask = SIF_POS then
    FScrollInfo.nPos := Value;

  SetScrollInfo(FControl.Handle, GetBarKind, FScrollInfo, True);
end;

function TRMScrollBar.GetScrollData(Mask: Cardinal): integer;
begin
  FScrollInfo.fMask := Mask;

  GetScrollInfo(FControl.Handle, GetBarKind, FScrollInfo);
  Result := FScrollInfo.nTrackPos;
end;

procedure TRMScrollBar.SetMin(Value: integer);
begin
  if FMin <> Value then
  begin
    FMin := Value;
    SetScrollData(Value, SIF_RANGE, True);
  end;
end;

procedure TRMScrollBar.SetMax(Value: integer);
begin
  if FMax <> Value then
  begin
    FMax := Value;
    SetScrollData(Value, SIF_RANGE, False);
  end;
end;

procedure TRMScrollBar.SetPage(Value: integer);
begin
  if FPage <> Value then
  begin
    FPage := Value;
    SetScrollData(Value, SIF_PAGE, True);
  end;
end;

procedure TRMScrollBar.SetPosition(Value: integer);
begin
  if Value >= FMax - FLargeChange then
    Value := FMax - FLargeChange;

  if Value <= FMin then
    Value := FMin;

  if FPosition <> Value then
  begin
    FPosition := Value;
    SetScrollData(Value, SIF_POS, True);

    if Assigned(FControl.FOnChange) then
      FControl.FOnChange(Self, FKind);
  end;
end;

function TRMScrollBar.GetTrackPos: integer;
begin
  FTrackPos := GetScrollData(SIF_ALL);
  Result := FTrackPos;
end;

procedure TRMScrollBar.SetSmallChange(Value: integer);
begin
  if Value <> FSmallChange then
    FSmallChange := Value;
end;

procedure TRMScrollBar.SetLargeChange(Value: integer);
begin
  if Value <> FLargeChange then
  begin
    FLargeChange := Value;

    //Page value of scrollbar is the same as LargeChage
    //update the page value of scrollbar here
    SetPage(Value);
  end;
end;

procedure TRMScrollBar.RefreshLargePage(Value: Integer);
begin
	FLargeChange := Value;
  FPage := -1;
	SetPage(Value);
end;

procedure TRMScrollBar.Assign(Source: TPersistent);
begin
  if Source is TRMScrollBar then
  begin
    Visible := TRMScrollBar(Source).Visible;
    Min := TRMScrollBar(Source).Min;
    Max := TRMScrollBar(Source).Max;
    SmallChange := TRMScrollBar(Source).SmallChange;
    LargeChange := TRMScrollBar(Source).LargeChange;
    Position := TRMScrollBar(Source).Position;
    ThumbValue := TRMScrollBar(Source).ThumbValue;
  end
  else
    inherited Assign(Source);
end;

procedure TRMScrollBar.ScrollMessage(var Msg: TWMScroll);
var
  lValue: Integer;
begin
  lValue := 0;
  with Msg do
  begin
    case ScrollCode of
      SB_LINELEFT: lValue := FPosition - FSmallChange;
      SB_LINERIGHT: lValue := FPosition + FSmallChange;
      SB_PAGELEFT: lValue := FPosition - FLargeChange;
      SB_PAGERIGHT: lValue := FPosition + FLargeChange;
      SB_THUMBPOSITION: lValue := TrackPos - TrackPos mod ThumbValue;
      SB_THUMBTRACK: lValue := TrackPos - TrackPos mod ThumbValue;
      SB_TOP: lValue := FMin;
      SB_BOTTOM: lValue := FMax;
      SB_ENDSCROLL:
        begin
          Exit;
        end;
    end;

  end;

  if lValue <= FMin then
    lValue := FMin;

  if lValue >= FMax then
    lValue := FMax;

  SetPosition(lValue);
  if Assigned(FControl.FOnChange) then
    FControl.FOnChange(Self, FKind);
end;

procedure TRMScrollBar.SetVisible(Value: Boolean);
var
  lScrollInfo: TScrollInfo;
begin
  if FVisible <> Value then
  begin
    FVisible := Value;

    lScrollInfo.fMask := SIF_ALL;
    lScrollInfo.cbSize := sizeof(TScrollInfo);
    lScrollInfo.nMin := 0;
    if FVisible = true then
      lScrollInfo.nMax := FMax
    else
      lSCrollInfo.nMax := 0;

    lScrollInfo.nPage := FPage;
    lScrollInfo.nPos := FPosition;
    lScrollInfo.nTrackPos := FTrackPos;

    SetScrollInfo(FControl.Handle, GetBarKind, lScrollInfo, True);
  end;
end;

function TRMScrollBar.GetBarKind: Word;
begin
  Result := SB_HORZ;
  if Kind = rmSBVertical then
    Result := SB_VERT;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMScrollBox }

constructor TRMScrollBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FHorzScrollBar := TRMScrollBar.Create(Self, rmsbHorizontal);
  FVertScrollBar := TRMScrollBar.Create(Self, rmsbVertical);

  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
    csSetCaption, csDoubleClicks];

  Width := 185;
  Height := 41;
  FBorderStyle := bsSingle;
end;

destructor TRMScrollBox.Destroy;
begin
  FHorzScrollBar.Free;
  FVertScrollBar.Free;

  inherited Destroy;
end;

const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);

procedure TRMScrollBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then
    begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

procedure TRMScrollBox.CreateWnd;
begin
  inherited CreateWnd;

  if FHorzScrollBar.Visible then
    ShowScrollBar(Handle, SB_HORZ, True);

  if FVertScrollBar.Visible then
    ShowScrollBar(Handle, SB_VERT, True);
end;

procedure TRMScrollBox.WMHScroll(var Message: TWMHScroll);
begin
  if (Message.ScrollBar = 0) and FHorzScrollBar.Visible then
    FHorzScrollBar.ScrollMessage(Message)
  else
    inherited;
end;

procedure TRMScrollBox.WMVSCroll(var Message: TWMVScroll);
begin
  if (Message.ScrollBar = 0) and FVertScrollBar.Visible then
    FVertScrollBar.ScrollMessage(Message)
  else
    inherited;
end;

procedure TRMScrollBox.SetHorzScrollBar(Value: TRMScrollBar);
begin
  FHorzScrollBar.Assign(Value);
end;

procedure TRMScrollBox.SetVertScrollBar(Value: TRMScrollBar);
begin
  FVertScrollBar.Assign(Value);
end;

procedure TRMScrollBox.SetBorderStyle(Value: TBorderStyle);
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TRMScrollBox.Resize;
begin
  if Assigned(FOnResize) then FOnResize(Self);
end;

procedure TRMScrollBox.WMSize(var Message: TWMSize);
begin
  inherited;
  if not (csLoading in ComponentState) then Resize;
end;

procedure TRMScrollBox.WMNCHitTest(var Message: TMessage);
begin
  DefaultHandler(Message);
end;

procedure TRMScrollBox.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;

  inherited;
end;

end.

