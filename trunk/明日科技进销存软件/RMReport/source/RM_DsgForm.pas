unit RM_DsgForm;

interface

{$I RM.INC}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Printers, Menus, ComCtrls, ExtCtrls, Clipbrd, Commctrl,
  RM_Class, RM_Preview, RM_Common, RM_DsgCtrls, RM_Ctrls, RM_Insp,
  RM_EditorInsField
  {$IFDEF USE_INTERNAL_JVCL}
  , rm_JvInterpreter, rm_JvInterpreterParser, rm_JvInterpreterConst, rm_JvUtils
  {$ELSE}
  , JvInterpreter, JvInterpreterParser, JvInterpreterConst, rm_JvUtils
  {$ENDIF}

  {$IFDEF USE_SYNEDIT}
  , SynEdit, SynHighlighterPas, SynEditRegexSearch, SynEditSearch, SynEditTypes
  {$ELSE}
  {$IFDEF USE_INTERNAL_JVCL}
  , rm_JvEditor, rm_JvHLEditor {, rm_JvEditorCommon}
  {$ELSE}
  , JvEditor, JvHLEditor, JvEditorCommon
  {$ENDIF}
  {$ENDIF}

  {$IFDEF Delphi4}, ImgList{$ENDIF}
  {$IFDEF Delphi6}, Variants{$ENDIF};

type

  TRMUndoAction = (acInsert, acDelete, acEdit, acZOrder,
    acChangeCellSize, acChangeCellCount, acChangePage);
  TRMHighLighter = (rmhlNone, rmhlPascal, rmhlCBuilder, rmhlSql, rmhlPython, rmhlJava, rmhlVB,
    rmhlHtml, rmhlPerl, rmhlIni, rmhlCocoR, rmhlPhp, rmhlNQC);

  TRMSplitInfo = record
    SplRect: TRect;
    SplX: Integer;
    View1, View2: TRMView;
  end;

  {$IFDEF USE_SYNEDIT}
  TRMSynEditor = class(TSynEdit)
    {$ELSE}
  TRMSynEditor = class(TJvHLEditor)
    {$ENDIF}
  public
    procedure SetHighLighter(aHighLighter: TRMHighLighter);
    procedure SetGutterWidth(aWidth: Integer);
    procedure SetGroupUndo(aValue: Boolean);
    procedure SetUndoAfterSave(aValue: Boolean);
    procedure SetReservedForeColor(aValue: TColor);
    procedure SetCommentForeColor(aValue: TColor);

    function RMCanCut: Boolean;
    function RMCanCopy: Boolean;
    function RMCanPaste: Boolean;
    function RMCanUndo: Boolean;
    function RMCanRedo: Boolean;

    procedure RMClearUndoBuffer;
    procedure RMClipBoardCut;
    procedure RMClipBoardCopy;
    procedure RMClipBoardPaste;
    procedure RMDeleteSelected;
    procedure RMUndo;
    procedure RmRedo;
  end;

  TRMDesignerDrawMode = (dmAll, dmSelection, dmShape);
  TRMCursorType = (ctNone, ct1, ct2, ct3, ct4, ct5, ct6, ct7, ct8);
  TRMShapeMode = (smFrame, smAll);
  TRMDesignerEditMode = (mdInsert, mdSelect);

  { TRMVirtualReportDesigner }
  TRMVirtualReportDesigner = class(TRMReportDesigner)
  private
    procedure SetCurPos(Value: Integer);
    function GetCurPos: Integer;
    procedure Back;
    function ParseDataType: IJvInterpreterDataType;
    procedure ParseToken;
    procedure NextToken;
    function Function1(aParams: PRMParamRecArray; var aParamCount: Integer): string;
    procedure SkipIdentifier1;
    procedure SkipToUntil1;
    procedure SkipStatement1;
    procedure SkipToEnd1;
    procedure FindToken1(TTyp1: TTokenTyp);
    procedure ErrorExpected(Exp: string);
    procedure FindOneFunc(aParams: PRMParamRecArray;
      var aIsEnd: Boolean; var aFuncName: string; var aParamCount: Integer);

    function PosBeg: Integer;
    function PosRow: Integer;
  protected
    {$IFDEF USE_SYNEDIT}
    FSearchBackwards: boolean;
    FSearchCaseSensitive: boolean;
    FSearchFromCaret: boolean;
    FSearchFromCaret1: Boolean;
    FSearchSelectionOnly: boolean;
    FSearchTextAtCaret: boolean;
    FSearchWholeWords: boolean;
    FSearchRegex: boolean;

    FSearchText: string;
    FSearchTextHistory: string;
    FReplaceText: string;
    FReplaceTextHistory: string;

    SynPasSyn1: TSynPasSyn;
    FSynEditSearch: TSynEditSearch;
    FSynEditRegexSearch: TSynEditRegexSearch;
    {$ELSE}
    FScriptCanReplace: Boolean;
    FFindDialog: TFindDialog;
    FReplaceDialog: TReplaceDialog;
    {$ENDIF}
    FCodeMemo: TRMSynEditor;
    Tab1: TRMTabControl;

    FSaveFuncPos, FSaveFuncRow: Integer;
    FSaveFuncBeginPos: Integer;
    FUnitSection: TUnitSection;
    FParsed: Boolean;
    FBacked: Boolean;
    TTyp: TTokenTyp;
    TokenStr1: string;
    PrevTTyp: TTokenTyp;
    Token: Variant;
    property TokenStr: string read TokenStr1;
    property CurPos: Integer read GetCurPos write SetCurPos;

    procedure ShowPosition; virtual; abstract;
    procedure EnableControls; virtual; abstract;
    procedure OnCodeMemoChangeEvent(Sender: TObject); virtual;
    procedure OnCodeMemoPaintGutterEvent(Sender: TObject; aCanvas: TCanvas); virtual;
    procedure DoSearchReplaceText(aReplace: Boolean; aBackwards: Boolean);
    procedure ShowSearchReplaceDialog(aReplace: Boolean);
    {$IFDEF USE_SYNEDIT}
    procedure OnCodeMemoReplaceText(Sender: TObject; const aSearch,
      aReplace: string; aLine, aColumn: Integer; var Action: TSynReplaceAction);
    procedure OnCodeMemoStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    {$ELSE}
    procedure OnCodeMemoSelectionChangeEvent(Sender: TObject); virtual;

    procedure FindDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure ReplaceDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Show(Sender: TObject);
    procedure FindNext;
    procedure Replace_FindNext;
    {$ENDIF}

    {$IFDEF Raize}
    procedure Tab1Changing(Sender: TObject; NewIndex: Integer; var AllowChange: Boolean);
    {$ELSE}
    procedure Tab1Changing(Sender: TObject; var AllowChange: Boolean);
    {$ENDIF}
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    //  Event Editor
    procedure GetEventFunctions(aValues: TStrings; aParams: PRMParamRecArray;
      aParamCount: Integer); override;
    procedure EditMethod(aFuncName: string; aParams: PRMParamRecArray;
      aParamCount: Integer); override;
    procedure ClearEmptyEvent; override;
  end;

  TRMCustomDesignerForm = class;
  TRMWorkSpace = class;

  { TRMToolbarComponent }
  TRMToolbarComponent = class(TPanel)
  private
    FControlIndex: Integer;
    FDesignerForm: TRMCustomDesignerForm;
    FBandsMenu, FPopupMenuComponent: TPopupMenu;
    FBtnNoSelect, FBtnMemoView: TSpeedButton;
    FBtnUp, FBtnDown: {$IFDEF USE_TB2K}TSpeedButton{$ELSE}TRMToolbarButton{$ENDIF};
    FOldPageType: Integer;
    FBusy: Boolean;
    FObjectBand: TSpeedButton;
    FSelectedObjIndex: Integer;
    FImageList: TImageList;

    procedure OnBandMenuPopup(Sender: TObject);
    procedure OnAddBandEvent(Sender: TObject);
    procedure OnOB1ClickEvent(Sender: TObject);
    procedure OnButtonBandClickEvent(Sender: TObject);
    procedure OnOB2MouseDownEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnOB2ClickEvent(Sender: TObject);
    procedure OnOB2ClickEvent_1(Sender: TObject);
    procedure OnAddInObectMenuItemClick(Sender: TObject);

    procedure RefreshControls;
    procedure OnResizeEvent(Sender: TObject);
    procedure OnBtnUpClickEvent(Sender: TObject);
    procedure OnBtnDownClickEvent(Sender: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure CreateObjects;

    property btnNoSelect: TSpeedButton read FBtnNoSelect;
    property ObjectBand: TSpeedButton read FObjectBand;
    property SelectedObjIndex: Integer read FSelectedObjIndex;
  end;

  { TRMDesignerDialog }
  TRMCustomDesignerForm = class(TRMVirtualReportDesigner)
  private
    FObjRepeat: Boolean; // was pressed Shift + Insert Object
    FObjectPopupMenu: TPopupMenu;

    FAutoOpenLastFile: Boolean;
    FAutoChangeBandPos: Boolean;
    FWorkSpaceColor: TColor;
    FInspFormColor: TColor;
    FEditorForm: TForm;

    FToolbarComponent: TRMToolbarComponent;

    procedure SetGridShow(Value: Boolean);
    procedure SetGridAlign(Value: Boolean);
    procedure SetGridSize(Value: Integer);
  protected
    ObjID: Integer;
    FirstSelected: TRMView;
    SelNum: Integer; // number of objects currently selected
    FShowSizes: Boolean;
    FBusy: Boolean; // busy flag. need!
    FShapeMode: TRMShapeMode; // show selection: frame or bar
    FSplitInfo: TRMSplitInfo;
    FGridBitmap: TBitmap;
    FGridSize: Integer;
    FShowGrid, FGridAlign: Boolean;
    FUnlimitedHeight: Boolean;
    FCurPage: Integer;

    FWorkSpace: TRMWorkSpace;
    FFieldForm: TRMInsFieldsForm;

    procedure SetCurPage(Value: Integer); virtual; abstract; //
    procedure RefreshData; virtual; abstract;
    procedure DoFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual; abstract;
    function PageSetup: Boolean; virtual;
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer); override;
    destructor Destroy; override;
    function EditorForm: TForm; override;
    procedure UnselectAll; virtual; abstract; //
    procedure SelectionChanged(aRefreshInspProp: Boolean); virtual; abstract; //
    procedure SetPageTabs; virtual; abstract; //
    procedure ResetSelection; virtual; abstract; //
    procedure ShowContent; virtual; abstract; //
    procedure AddUndoAction(aAction: TRMUndoAction); virtual; abstract; //

    procedure GetDefaultSize(var aWidth, aHeight: Integer);
    function IsBandsSelect(var Band: TRMView): Boolean;
    procedure SendBandsToDown;
    function IsSubreport(PageN: Integer): TRMView;
    function RMCheckBand(b: TRMBandType): Boolean;
    procedure GetRegion;
    procedure RedrawPage;
    procedure SetObjectID(t: TRMView);
    procedure ShowObjMsg; virtual;
    procedure ShowEditor; virtual;
    procedure SetRulerOffset; virtual;
    function TopSelected: Integer; virtual;

    property ToolbarComponent: TRMToolbarComponent read FToolbarComponent;
    property ObjectPopupMenu: TPopupMenu read FObjectPopupMenu write FObjectPopupMenu;
    property CurPage: Integer read FCurPage write SetCurPage;
    property ObjRepeat: Boolean read FObjRepeat write FObjRepeat;

    property GridAlign: Boolean read FGridAlign write SetGridAlign;
    property GridSize: Integer read FGridSize write SetGridSize;
    property ShowGrid: Boolean read FShowGrid write SetGridShow;
    property AutoOpenLastFile: Boolean read FAutoOpenLastFile write FAutoOpenLastFile;
    property AutoChangeBandPos: Boolean read FAutoChangeBandPos write FAutoChangeBandPos;
    property WorkSpaceColor: TColor read FWorkSpaceColor write FWorkSpaceColor;
    property InspFormColor: TColor read FInspFormColor write FInspFormColor;
  end;

  { TRMCustomFormWorkSpace }
  TRMDialogForm = class(TForm)
  private
    FDesignerForm: TRMCustomDesignerForm;
    procedure WMMove(var Message: TMessage); message WM_MOVE;
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetPageFormProp;

    procedure OnFormResizeEvent(Sender: TObject);
    procedure OnFormKeyDownEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnFormCloseQueryEvent(Sender: TObject; var CanClose: Boolean);
  end;

  { TRMWorkSpace }
  TRMWorkSpace = class(TPanel)
  private
    FBandMoved: Boolean;
    FDesignerForm: TRMCustomDesignerForm;
    FDisableDraw: Boolean;
    FMode: TRMDesignerEditMode; // current mode
    FMouseButtonDown: Boolean; // mouse button was pressed
    FDragFlag: Boolean;
    FCursorType: TRMCursorType; // current mouse cursor (sizing arrows)
    FDoubleClickFlag: Boolean; // was double click
    FObjectsSelecting: Boolean; // selecting objects by framing
    FLeftTop: TPoint;
    FRightBottom: Integer;
    FMoved: Boolean; // mouse was FMoved (with pressed btn)
    FLastX, FLastY: Integer; // here stored last mouse coords

    procedure RoundCoord(var x, y: Integer);
    procedure NormalizeCoord(t: TRMView);
    procedure NormalizeRect(var r: TRect);

    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure OnDoubleClickEvent(Sender: TObject);

    procedure DrawFocusRect(aRect: TRect);
    procedure DrawHSplitter(aRect: TRect);
    procedure DrawSelection(t: TRMView);
    procedure DrawShape(t: TRMView);
    procedure DoDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure DoDragDrop(Sender, Source: TObject; X, Y: Integer);
  protected
    procedure Paint; override;
  public
    PageForm: TRMDialogForm;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init;
    procedure SetPage;
    procedure GetMultipleSelected;
    procedure DrawPage(aDrawMode: TRMDesignerDrawMode);
    procedure Draw(N: Integer; aClipRgn: HRGN);
    procedure RedrawPage;

    procedure OnMouseMoveEvent(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure OnMouseDownEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OnMouseUpEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure CopyToClipboard;
    procedure DeleteObjects(aAddUndoAction: Boolean);
    procedure PasteFromClipboard;
    procedure SelectAll;

    property DesignerForm: TRMCustomDesignerForm read FDesignerForm write FDesignerForm;
    property DisableDraw: Boolean read FDisableDraw write FDisableDraw;
    property EditMode: TRMDesignerEditMode read FMode write FMode; // current mode
    property MouseButtonDown: Boolean read FMouseButtonDown write FMouseButtonDown; // mouse button was pressed
  end;

var
  CF_REPORTMACHINE: Word;
  RM_LastFontName: string;
  RM_LastFontSize: Integer;
  RM_LastFontCharset: Word;
  RM_LastFontStyle: Word;
  RM_LastFontColor: TColor;
  RM_LastHAlign: TRMHAlign;
  RM_LastVAlign: TRMVAlign;
  RM_LastFillColor: TColor;
  RM_LastFrameWidth: Integer;
  RM_LastFrameColor: TColor;
  RM_LastLeftFrameVisible: Boolean;
  RM_LastTopFrameVIsible: Boolean;
  RM_LastRightFrameVisible: Boolean;
  RM_LastBottomFrameVisible: Boolean;
  RM_ClipRgn: HRGN;
  RM_OldRect, RM_OldRect1: TRect; // object rect after mouse was clicked
  RM_SelectedManyObject: Boolean; // several objects was selected
  RM_FirstChange, RM_FirstBandMove: Boolean;

  RM_Dsg_LastDataSet: string;
  RMTemplateDir: string = '';

implementation

uses
  RM_Const, RM_Const1, RM_Utils, RM_EditorBandType, RM_EditorMemo,
  RM_PageSetup
  {$IFDEF USE_SYNEDIT}
  , RM_EditorSearchText, RM_EditorReplaceText, RM_EditorConfirmReplace
  {$ENDIF};

type
  THackView = class(TRMView)
  end;

  THackDialogControl = class(TRMDialogControl)
  end;

  THackReport = class(TRMReport)
  end;

  THackPage = class(TRMCustomPage)
  end;

  THackReportPage = class(TRMReportPage)
  end;

  {------------------------------------------------------------------------------}
  {------------------------------------------------------------------------------}
  { TRMSynEdit }

procedure TRMSynEditor.SetHighLighter(aHighLighter: TRMHighLighter);
begin
  {$IFDEF USE_SYNEDIT}
  {$ELSE}
  HighLighter := THighLighter(aHighLighter);
  {$ENDIF}
end;

procedure TRMSynEditor.SetGutterWidth(aWidth: Integer);
begin
  {$IFDEF USE_SYNEDIT}
  Gutter.Width := aWidth;
  {$ELSE}
  GutterWidth := aWidth;
  {$ENDIF}
end;

procedure TRMSynEditor.SetGroupUndo(aValue: Boolean);
begin
  {$IFDEF USE_SYNEDIT}
  if aValue then
    Options := Options + [eoGroupUndo]
  else
    Options := Options - [eoGroupUndo];
  {$ELSE}
  GroupUndo := aValue;
  {$ENDIF}
end;

procedure TRMSynEditor.SetUndoAfterSave(aValue: Boolean);
begin
  {$IFDEF USE_SYNEDIT}
  {$ELSE}
  UndoAfterSave := aValue;
  {$ENDIF}
end;

procedure TRMSynEditor.SetReservedForeColor(aValue: TColor);
begin
  {$IFDEF USE_SYNEDIT}
  if Self.Highlighter <> nil then
    Self.Highlighter.KeywordAttribute.Foreground := aValue;
  {$ELSE}
  Colors.Reserved.ForeColor := aValue;
  {$ENDIF}
end;

procedure TRMSynEditor.SetCommentForeColor(aValue: TColor);
begin
  {$IFDEF USE_SYNEDIT}
  if Self.Highlighter <> nil then
    Self.Highlighter.CommentAttribute.Foreground := aValue;
  {$ELSE}
  Colors.Comment.ForeColor := aValue;
  {$ENDIF}
end;

procedure TRMSynEditor.RMClearUndoBuffer;
begin
  {$IFDEF USE_SYNEDIT}
  Self.ClearUndo;
  {$ELSE}
  UndoBuffer.Clear;
  {$ENDIF}
end;

function TRMSynEditor.RMCanCut: Boolean;
begin
  {$IFDEF USE_SYNEDIT}
  Result := Self.SelAvail;
  {$ELSE}
  Result := CanCut;
  {$ENDIF}
end;

function TRMSynEditor.RMCanCopy: Boolean;
begin
  {$IFDEF USE_SYNEDIT}
  Result := Self.SelAvail;
  {$ELSE}
  Result := CanCopy;
  {$ENDIF}
end;

function TRMSynEditor.RMCanPaste: Boolean;
begin
  {$IFDEF USE_SYNEDIT}
  Result := Self.CanPaste;
  {$ELSE}
  Result := CanPaste;
  {$ENDIF}
end;

function TRMSynEditor.RMCanUndo: Boolean;
begin
  {$IFDEF USE_SYNEDIT}
  Result := Self.CanUndo;
  {$ELSE}
  Result := UndoBuffer.CanUndo;
  {$ENDIF}
end;

function TRMSynEditor.RMCanRedo: Boolean;
begin
  {$IFDEF USE_SYNEDIT}
  Result := Self.CanRedo;
  {$ELSE}
  Result := UndoBuffer.CanUndo;
  {$ENDIF}
end;

procedure TRMSynEditor.RMClipBoardCut;
begin
  {$IFDEF USE_SYNEDIT}
  Self.CutToClipboard;
  {$ELSE}
  ClipBoardCut;
  {$ENDIF}
end;

procedure TRMSynEditor.RMClipBoardCopy;
begin
  {$IFDEF USE_SYNEDIT}
  Self.CopyToClipboard;
  {$ELSE}
  ClipBoardCopy;
  {$ENDIF}
end;

procedure TRMSynEditor.RMClipBoardPaste;
begin
  {$IFDEF USE_SYNEDIT}
  Self.PasteFromClipboard;
  {$ELSE}
  ClipBoardPaste;
  {$ENDIF}
end;

procedure TRMSynEditor.RMDeleteSelected;
begin
  {$IFDEF USE_SYNEDIT}
  {$ELSE}
  DeleteSelected;
  {$ENDIF}
end;

procedure TRMSynEditor.RMUndo;
begin
  {$IFDEF USE_SYNEDIT}
  Self.Undo;
  {$ELSE}
  UndoBuffer.Undo;
  {$ENDIF}
end;

procedure TRMSynEditor.RMRedo;
begin
  {$IFDEF USE_SYNEDIT}
  Self.Redo;
  {$ELSE}
  UndoBuffer.Undo;
  {$ENDIF}
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarComponent }

const
  ButtonWidth = 28;

constructor TRMToolbarComponent.Create(AOwner: TComponent);

  procedure _CreateBandsMenu;
  var
    bt: TRMBandType;
    item: TMenuItem;
  begin
    FBandsMenu := TPopupMenu.Create(AOwner);
    FBandsMenu.AutoHotkeys := maManual;
    FBandsMenu.OnPopup := OnBandMenuPopup;

    for bt := rmbtReportTitle to rmbtCrossFooter do
    begin
      item := TMenuItem.Create(FBandsMenu);
      item.Caption := RMBandNames[TRMBandType(bt)];
      item.Tag := Ord(bt);
      item.OnClick := OnAddBandEvent;
      FBandsMenu.Items.Add(item);
    end;
  end;

begin
  inherited Create(AOwner);
  FDesignerForm := TRMCustomDesignerForm(AOwner);
  FOldPageType := -1;
  Parent := FDesignerForm;
  BevelInner := bvLowered; //bvNone;
  BevelOuter := bvNone;
  Align := alLeft;
  ClientWidth := ButtonWidth + 2;
  FControlIndex := 3;

  FImageList := TImageList.Create(Self);
  FImageList.Width := 24;
  FImageList.Height := 24;
  FPopupMenuComponent := TPopupMenu.Create(Self);
  FPopupMenuComponent.AutoHotkeys := maManual;
  FPopupMenuComponent.Images := FImageList;

  FBtnNoSelect := TSpeedButton.Create(Self);
  with FBtnNoSelect do
  begin
    Parent := Self;
    Flat := True;
    Glyph.LoadFromResourceName(hInstance, 'RM_ComponentNoSelect');
    SetBounds(1, 1, ButtonWidth, ButtonWidth);
    AllowAllUp := True;
    GroupIndex := 1;
    OnClick := OnOB1ClickEvent;
    Tag := -1;
    ShowHint := True;
    RMSetStrProp(FBtnNoSelect, 'Hint', rmRes + 132);
  end;

  {$IFDEF USE_TB2K}
  FBtnUp := TSpeedButton.Create(Self);
  {$ELSE}
  FBtnUp := TRMToolbarButton.Create(Self);
  {$ENDIF}
  with FBtnUp do
  begin
    Parent := Self;
    Flat := True;
    Glyph.LoadFromResourceName(hInstance, 'RM_MYSPINUP');
    SetBounds(1, FBtnNoSelect.Top + FBtnNoSelect.Height, ButtonWidth, 16);
    Tag := -1;
    {$IFNDEF USE_TB2K}
    Repeating := True;
    {$ENDIF}
    OnClick := OnBtnUpClickEvent;
  end;

  {$IFDEF USE_TB2K}
  FBtnDown := TSpeedButton.Create(Self);
  {$ELSE}
  FBtnDown := TRMToolbarButton.Create(Self);
  {$ENDIF}
  with FBtnDown do
  begin
    Parent := Self;
    Flat := True;
    Glyph.LoadFromResourceName(hInstance, 'RM_MYSPINDOWN');
    SetBounds(1, Self.Height - 16, ButtonWidth, 16);
    Tag := -1;
    {$IFNDEF USE_TB2K}
    Repeating := True;
    {$ENDIF}
    OnClick := OnBtnDownClickEvent;
  end;

  _CreateBandsMenu;
  OnResize := OnResizeEvent;
end;

destructor TRMToolbarComponent.Destroy;
begin
  inherited;
end;

const
  DefaultControlBmps: array[0..4] of string = ('RM_ComponentMemo', 'RM_ComponentCalcMemo',
    'RM_ComponentPicture', 'RM_ComponentShape', 'RM_ComponentSubReport');
  DefaultControlTyps: array[0..4] of byte = (rmgtMemo, rmgtCalcMemo, rmgtPicture, rmgtShape,
    rmgtSubReport);
  DefaultControlHints: array[0..4] of Integer = (rmRes + 133, rmRes + 137, rmRes + 135,
    SInsShape, rmRes + 136);

procedure TRMToolbarComponent.CreateObjects;
var
  liNeedCreate: Boolean;
  i: Integer;
  liNowTop: Integer;
  lAddInObjectInfo: TRMAddinObjectInfo;
  lButton: TSpeedButton;

  procedure _CreateBandObject;
  var
    i: Integer;
    liButton: TSpeedButton;
  begin
    FObjectBand := TSpeedButton.Create(Self);
    with FObjectBand do
    begin
      Parent := Self;
      Flat := True;
      SetBounds(1, liNowTop, ButtonWidth, ButtonWidth);
      Glyph.LoadFromResourceName(hInstance, 'RM_ComponentBand');
      Tag := rmgtBand;
      AllowAllUp := True;
      GroupIndex := 1;
      OnClick := OnButtonBandClickEvent;
      OnMouseDown := OnOB2MouseDownEvent;
      ShowHint := True;
      RMSetStrProp(FObjectBand, 'Hint', rmRes + 134);
      Inc(liNowTop, ButtonWidth);
    end;

    for i := Low(DefaultControlBmps) to High(DefaultControlBmps) do
    begin
      liButton := TSpeedButton.Create(Self);
      with liButton do
      begin
        Parent := Self;
        Flat := True;
        SetBounds(1, liNowTop, ButtonWidth, ButtonWidth);
        Glyph.LoadFromResourceName(hInstance, DefaultControlBmps[i]);
        Tag := DefaultControlTyps[i];
        AllowAllUp := True;
        GroupIndex := 1;
        OnClick := OnOB2ClickEvent;
        OnMouseDown := OnOB2MouseDownEvent;
        ShowHint := True;
        RMSetStrProp(liButton, 'Hint', DefaultControlHints[i]);
        if i = 0 then
          FBtnMemoView := liButton;
      end;
      Inc(liNowTop, ButtonWidth);
    end;
  end;

begin
  if FDesignerForm.Page is TRMDialogPage then
    liNeedCreate := FOldPageType <> 1
  else
    liNeedCreate := FOldPageType <> 2;

  if not liNeedCreate then Exit;

  FSelectedObjIndex := -1;
  while ControlCount > 3 do
    Controls[3].Free;

  FControlIndex := 3;
  liNowTop := FBtnUp.Top + FBtnUp.Height;
  if FDesignerForm.Page is TRMDialogPage then FOldPageType := 1 else FOldPageType := 2;

  FObjectBand := nil;
  if FOldPageType = 2 then
    _CreateBandObject;

  for i := 0 to RMAddInsCount - 1 do
  begin
    lAddInObjectInfo := RMAddIns(i);
    if lAddInObjectInfo.IsPage and
      (((FOldPageType = 1) and (lAddInObjectInfo.IsControl)) or
      ((FOldPageType = 2) and (not lAddInObjectInfo.IsControl))) then
    begin
      lButton := TSpeedButton.Create(Self);
      with lButton do
      begin
        Parent := Self;
        Flat := True;
        SetBounds(1, liNowTop, ButtonWidth, ButtonWidth);
        AllowAllUp := True;
        OnClick := OnOB2ClickEvent;

        if lAddInObjectInfo.Page <> '' then
        begin
          GroupIndex := 0;
          OnClick := OnOB2ClickEvent_1;
        end
        else
        begin
          OnClick := OnOB2ClickEvent;
          OnMouseDown := OnOB2MouseDownEvent;
          GroupIndex := 1;
        end;

        ShowHint := True;
        Glyph.LoadFromResourceName(Hinstance, lAddInObjectInfo.ButtonBmpRes);
        Tag := rmgtAddIn + i;
        Hint := lAddInObjectInfo.ButtonHint;
      end;
    end;
    Inc(liNowTop, ButtonWidth);
  end;

  RefreshControls;
end;

procedure TRMToolbarComponent.OnButtonBandClickEvent(Sender: TObject);
var
  lPoint: TPoint;
begin
  if FDesignerForm.AutoChangeBandPos then
  begin
    lPoint := Point(TSpeedButton(Sender).Left, TSpeedButton(Sender).Top + TSpeedButton(Sender).Height);
    lPoint := ClientToScreen(lPoint);
    FBandsMenu.Popup(lPoint.X, lPoint.Y);
  end
  else
  begin
  end;
end;

procedure TRMToolbarComponent.OnOB2ClickEvent(Sender: TObject);
begin
  FBtnNoSelect.Down := not TSpeedButton(Sender).Down;
end;

procedure TRMToolbarComponent.OnOB2MouseDownEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDesignerForm.ObjRepeat := ssShift in Shift;
  FDesignerForm.FWorkSpace.Cursor := crDefault;
  FSelectedObjIndex := TSpeedButton(Sender).Tag;
end;

procedure TRMToolbarComponent.OnAddInObectMenuItemClick(Sender: TObject);
begin
  FBtnNoSelect.Down := False;
  FDesignerForm.ObjRepeat := False;
  FDesignerForm.FWorkSpace.Cursor := crDefault;
  FSelectedObjIndex := TMenuItem(Sender).Tag;
end;

procedure TRMToolbarComponent.OnOB2ClickEvent_1(Sender: TObject);
var
  i, j: Integer;
  lPage: string;
  lMenuItem: TMenuItem;
  lPoint: TPoint;
  lBmp: TBitmap;
begin
  lPage := RMAddIns(TSpeedButton(Sender).Tag - rmgtAddIn).Page;
  FPopupMenuComponent.Items.Clear;
  FImageList.Clear;

  lBmp := TBitmap.Create;
  try
    j := 0;
    for i := 0 to RMAddInsCount - 1 do
    begin
      if (not RMAddIns(i).IsPage) and (RMAddIns(i).Page = lPage) then
      begin
        lBmp.LoadFromResourceName(Hinstance, RMAddIns(i).ButtonBmpRes);
        //        FImageList.Add(lBmp, nil);
        FImageList.AddMasked(lBmp, lBmp.TransparentColor);

        lMenuItem := TMenuItem.Create(Self);
        lMenuItem.Caption := RMAddIns(i).ButtonHint;
        if (lMenuItem.Caption = '') and (RMAddIns(i).ClassRef <> nil) then
          lMenuItem.Caption := RMAddIns(i).ClassRef.ClassName;
        lMenuItem.Tag := rmgtAddIn + i;
        lMenuItem.OnClick := OnAddInObectMenuItemClick;
        lMenuItem.ImageIndex := j;
        FPopupMenuComponent.Items.Add(lMenuItem);
        Inc(j);
      end;
    end;
  finally
    FreeAndNil(lBmp);
  end;

  lPoint := Point(TSpeedButton(Sender).Left + TSpeedButton(Sender).Height,
    TSpeedButton(Sender).Top);
  lPoint := ClientToScreen(lPoint);
  FPopupMenuComponent.Popup(lPoint.X, lPoint.Y);
end;

procedure TRMToolbarComponent.OnBandMenuPopup(Sender: TObject);
var
  i: Integer;
  lItem: TMenuItem;
  t: TRMView;
  lIsSubreport: Boolean;
begin
  FBtnNoSelect.Down := True;
  t := FDesignerForm.IsSubreport(FDesignerForm.CurPage);
  if (t <> nil) and (TRMSubReportView(t).SubReportType = rmstChild) then
    lIsSubreport := True
  else
    lIsSubreport := False;

  for i := 0 to FBandsMenu.Items.Count - 1 do
  begin
    lItem := FBandsMenu.Items[i];
    lItem.Enabled := (TRMBandType(lItem.Tag) in [rmbtHeader, rmbtFooter, rmbtGroupHeader,
      rmbtGroupFooter, rmbtMasterData, rmbtDetailData]) or
      (not FDesignerForm.RMCheckBand(TRMBandType(lItem.Tag)));

    if lIsSubreport and (TRMBandType(lItem.Tag) in
      [rmbtReportTitle, rmbtReportSummary, rmbtPageHeader, rmbtPageFooter,
      rmbtGroupHeader, rmbtGroupFooter, rmbtColumnHeader, rmbtColumnFooter]) then
      lItem.Enabled := False;
  end;
end;

procedure TRMToolbarComponent.OnAddBandEvent(Sender: TObject);
var
  t, t1: TRMView;
  liTop, dx, dy: Integer;

  function _GetMaxTop: Integer;
  var
    i: Integer;
    t: TRMView;
  begin
    Result := 0;
    for i := 0 to FDesignerForm.PageObjects.Count - 1 do
    begin
      t := FDesignerForm.PageObjects[i];
      if t.IsBand and (not (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter])) and
        (t.spBottom_Designer > Result) then
        Result := t.spBottom_Designer;
    end;
    if RM_Class.RMShowBandTitles then
      Result := Result + 18;
  end;

begin
  if FDesignerForm.SelNum = 1 then
    t1 := FDesignerForm.PageObjects[FDesignerForm.TopSelected]
  else
    t1 := nil;

  FDesignerForm.UnselectAll;
  FDesignerForm.FWorkSpace.DrawPage(dmSelection);

  t := RMCreateBand(TRMBandType(TComponent(Sender).Tag));
  t.ParentPage := FDesignerForm.Page;
  FDesignerForm.SetObjectID(t);
  if TRMBandType(TComponent(Sender).Tag) in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter,
    rmbtOverlay] then
  begin
    t.Selected := True;
    dx := 36;
    dy := 36;
    FDesignerForm.GetDefaultSize(dx, dy);
    FDesignerForm.SelNum := 1;
    if TRMBandType(TComponent(Sender).Tag) = rmbtOverlay then
    begin
      t.spTop_Designer := _GetMaxTop;
      t.spHeight_Designer := dy;
    end
    else
    begin
      t.spLeft_Designer := 0;
      t.spTop_Designer := 0;
      t.spWidth_Designer := dx;
      t.spHeight_Designer := dy;
    end;
    FDesignerForm.SendBandsToDown;
  end
  else
  begin
    liTop := FDesignerForm.FWorkSpace.Height;
    if (t1 <> nil) and t1.IsBand and (TRMCustomBandView(t1).BandType in [rmbtMasterData, rmbtDetailData]) then
    begin
      case TRMCustomBandView(t).BandType of
        rmbtGroupHeader, rmbtHeader: liTop := t1.spTop_Designer - 1;
        rmbtGroupFooter, rmbtFooter: liTop := t1.spTop_Designer + t1.spBottom_Designer;
      end;
    end;
    t.spTop_Designer := liTop;
    t.spHeight_Designer := 18;
    FDesignerForm.SendBandsToDown;
    FDesignerForm.Page.UpdateBandsPageRect;
    FDesignerForm.RedrawPage;
    t.Selected := True;
    FDesignerForm.SelNum := 1;
  end;

  FDesignerForm.Modified := True;
  FDesignerForm.SendBandsToDown;
  FDesignerForm.FWorkSpace.Draw(FDesignerForm.TopSelected, RM_ClipRgn);
  FDesignerForm.SelectionChanged(True);
  FDesignerForm.ShowPosition;
  FDesignerForm.AddUndoAction(acInsert);
end;

procedure TRMToolbarComponent.OnOB1ClickEvent(Sender: TObject);
begin
  FBtnNoSelect.Down := True;
  FDesignerForm.ObjRepeat := False;
end;

procedure TRMToolbarComponent.RefreshControls;
var
  i: Integer;
  liControl: TControl;
  liNowTop: Integer;
begin
  FBusy := True;
  liNowTop := FBtnUp.Top + FBtnUp.Height;
  for i := 3 to ControlCount - 1 do
  begin
    liControl := Controls[i];
    if i < FControlIndex then
      liControl.Visible := False
    else if liNowTop + ButtonWidth < FBtnDown.Top then
    begin
      liControl.Visible := True;
      liControl.Top := liNowTop;
      Inc(liNowTop, ButtonWidth);
    end
    else
      liControl.Visible := False;
  end;

  FBtnUp.Enabled := FControlIndex > 3;
  FBtnDown.Enabled := not Controls[ControlCount - 1].Visible;
  FBusy := False;
end;

procedure TRMToolbarComponent.OnResizeEvent(Sender: TObject);
begin
  FBtnDown.Top := Self.Height - FBtnDown.Height;
  if not FBusy then
    RefreshControls;
end;

procedure TRMToolbarComponent.OnBtnUpClickEvent(Sender: TObject);
begin
  if FControlIndex > 3 then
  begin
    Dec(FControlIndex);
    if not FBusy then
      RefreshControls;
  end;
end;

procedure TRMToolbarComponent.OnBtnDownClickEvent(Sender: TObject);
begin
  if FControlIndex < ControlCount then
  begin
    Inc(FControlIndex);
    if not FBusy then
      RefreshControls;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMWorkSpace }

constructor TRMWorkSpace.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := AOwner as TWinControl;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  Color := clWhite;
  BorderStyle := bsNone;

  PageForm := nil;

  OnMouseDown := OnMouseDownEvent;
  OnMouseUp := OnMouseUpEvent;
  OnMouseMove := OnMouseMoveEvent;
  OnDblClick := OnDoubleClickEvent;
  OnDragOver := DoDragOver;
  OnDragDrop := DoDragDrop;
end;

destructor TRMWorkSpace.Destroy;
begin
  inherited;
end;

procedure TRMWorkSpace.Init;
begin
  FDragFlag := False;
  FMouseButtonDown := False;
  FDoubleClickFlag := False;
  FObjectsSelecting := False;
  Cursor := crDefault;
  FCursorType := ctNone;
end;

procedure TRMWorkSpace.SetPage;
var
  lWidth, lHeight: Integer;
  x1, y1, x2, y2: Integer;
begin
  if (FDesignerForm = nil) or (FDesignerForm.Page = nil) then Exit;

  if FDesignerForm.Page is TRMDialogPage then
  begin
    Align := alClient;
  end
  else
  begin
    lWidth := Round(TRMReportPage(FDesignerForm.Page).PrinterInfo.PageWidth * FDesignerForm.Factor / 100);
    lHeight := Round(TRMReportPage(FDesignerForm.Page).PrinterInfo.PageHeight * FDesignerForm.Factor / 100);
		if FDesignerForm.FUnlimitedHeight then
    	lHeight := lHeight * 3;

    Align := alNone;

    x1 := Round(TRMReportPage(FDesignerForm.Page).spMarginLeft * FDesignerForm.Factor / 100);
    y1 := Round(TRMReportPage(FDesignerForm.Page).spMarginTop * FDesignerForm.Factor / 100);
    x2 := lWidth - x1 - Round(TRMReportPage(FDesignerForm.Page).spMarginRight * FDesignerForm.Factor / 100);
    y2 := lHeight - y1 - Round(TRMReportPage(FDesignerForm.Page).spMarginBottom * FDesignerForm.Factor / 100);
    //Color := FDesignerForm.WorkSpaceColor;
    SetBounds(x1, y1, x2, y2);
  end;
end;

procedure TRMWorkSpace.Paint;
begin
  FDesignerForm.SetRulerOffset;
  FDesignerForm.RedrawPage;
end;

procedure TRMWorkSpace.RoundCoord(var x, y: Integer);
begin
  with FDesignerForm do
  begin
    if GridAlign then
    begin
      x := x div GridSize * GridSize;
      y := y div GridSize * GridSize;
    end;
  end;
end;

procedure TRMWorkSpace.NormalizeRect(var r: TRect);
var
  i: Integer;
begin
  with r do
  begin
    if Left > Right then begin i := Left;
      Left := Right;
      Right := i
    end;
    if Top > Bottom then begin i := Top;
      Top := Bottom;
      Bottom := i
    end;
  end;
end;

procedure TRMWorkSpace.NormalizeCoord(t: TRMView);
begin
  if t.spWidth_Designer < 0 then
  begin
    t.spWidth_Designer := -t.spWidth_Designer;
    t.spLeft_Designer := t.spLeft_Designer - t.spWidth_Designer;
  end;
  if t.spHeight_Designer < 0 then
  begin
    t.spHeight_Designer := -t.spHeight_Designer;
    t.spTop_Designer := t.spTop_Designer - t.spHeight_Designer;
  end;
end;

procedure TRMWorkSpace.GetMultipleSelected;
var
  i, j, k: Integer;
  t: TRMView;
begin
  j := 0;
  k := 0;
  FLeftTop := Point(10000, 10000);
  FRightBottom := -1;
  RM_SelectedManyObject := False;
  if FDesignerForm.SelNum > 1 then {find right-bottom element}
  begin
    for i := 0 to FDesignerForm.PageObjects.Count - 1 do
    begin
      t := FDesignerForm.PageObjects[i];
      if t.Selected then
      begin
        THackView(t).OriginalRect := Rect(t.spLeft_Designer, t.spTop_Designer, t.spWidth_Designer, t.spHeight_Designer);
        if (t.spLeft_Designer + t.spWidth_Designer > j) or ((t.spLeft_Designer + t.spWidth_Designer = j) and (t.spTop_Designer + t.spHeight_Designer > k)) then
        begin
          j := t.spLeft_Designer + t.spWidth_Designer;
          k := t.spTop_Designer + t.spHeight_Designer;
          FRightBottom := i;
        end;
        if t.spLeft_Designer < FLeftTop.x then FLeftTop.x := t.spLeft_Designer;
        if t.spTop_Designer < FLeftTop.y then FLeftTop.y := t.spTop_Designer;
      end;
    end;

    if FRightBottom >= 0 then
    begin
      t := FDesignerForm.PageObjects[FRightBottom];
      RM_OldRect := Rect(FLeftTop.x, FLeftTop.y, t.spLeft_Designer + t.spWidth_Designer, t.spTop_Designer + t.spHeight_Designer);
      RM_OldRect1 := RM_OldRect;
    end;
    RM_SelectedManyObject := True;
  end;
end;

procedure TRMWorkSpace.OnMouseDownEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  f, DontChange, v: Boolean;
  t: TRMView;
  Rgn: HRGN;
  p: TPoint;
begin
  FBandMoved := False;
  if FDoubleClickFlag then
  begin
    FDoubleClickFlag := False;
    Exit;
  end;
  DrawPage(dmSelection);
  FMouseButtonDown := True;
  DontChange := False;
  if Button = mbLeft then
  begin
    if (ssCtrl in Shift) or (Cursor = crCross) then
    begin
      FObjectsSelecting := True;
      if Cursor = crCross then
      begin
//        if FDesignerForm.Page is TRMReportPage then
          DrawFocusRect(RM_OldRect);
        RoundCoord(x, y);
        RM_OldRect1 := RM_OldRect;
      end;
      RM_OldRect := Rect(x, y, x, y);
      FDesignerForm.UnselectAll;
      FDesignerForm.SelNum := 0;
      FRightBottom := -1;
      RM_SelectedManyObject := False;
      FDesignerForm.FirstSelected := nil;
      Exit;
    end;
  end;

  if Cursor = crDefault then
  begin
    f := False;
    for i := FDesignerForm.PageObjects.Count - 1 downto 0 do
    begin
      t := FDesignerForm.PageObjects[i];
      Rgn := t.GetClipRgn(rmrtNormal);
      v := PtInRegion(Rgn, X, Y);
      DeleteObject(Rgn);
      if v then
      begin
        if ssShift in Shift then
        begin
          t.Selected := not t.Selected;
          if t.Selected then Inc(FDesignerForm.SelNum) else Dec(FDesignerForm.SelNum);
        end
        else
        begin
          if not t.Selected then
          begin
            FDesignerForm.UnselectAll;
            FDesignerForm.SelNum := 1;
            t.Selected := True;
          end
          else DontChange := True;
        end;
        if FDesignerForm.SelNum = 0 then FDesignerForm.FirstSelected := nil
        else if FDesignerForm.SelNum = 1 then FDesignerForm.FirstSelected := t
        else if FDesignerForm.FirstSelected <> nil then
          if not FDesignerForm.FirstSelected.Selected then FDesignerForm.FirstSelected := nil;
        f := True;
        break;
      end;
    end;
    if not f then
    begin
      FDesignerForm.UnselectAll;
      FDesignerForm.SelNum := 0;
      FDesignerForm.FirstSelected := nil;
      if Button = mbLeft then
      begin
        FObjectsSelecting := True;
        RM_OldRect := Rect(x, y, x, y);
        Exit;
      end;
    end;
    GetMultipleSelected;
    if not DontChange then FDesignerForm.SelectionChanged(True);
  end;

  if FDesignerForm.SelNum = 0 then
  begin // reset multiple selection
    FRightBottom := -1;
    RM_SelectedManyObject := False;
  end;
  FLastX := x;
  FLastY := y;
  FMoved := False;
  RM_FirstChange := True;
  RM_FirstBandMove := True;
  if Button = mbRight then
  begin
    DrawPage(dmSelection);
    FMouseButtonDown := False;
    GetCursorPos(p);
    FDesignerForm.SelectionChanged(True);
    FDesignerForm.ObjectPopupMenu.Popup(p.X, p.Y);
  end
  else
    DrawPage(dmShape);
end;

procedure TRMWorkSpace.OnMouseUpEvent(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, dx, dy: Integer;
  nx, ny, x1, x2, y1, y2: Double;
  t: TRMView;
  liNeedReDraw: Boolean;
  lObjectInserted: Boolean;

  function _GetUnusedBand: TRMBandType;
  var
    b: TRMBandType;
  begin
    Result := rmbtNone;
    for b := rmbtReportTitle to rmbtNone do
    begin
      if not FDesignerForm.RMCheckBand(b) then
      begin
        Result := b;
        Break;
      end;
    end;
    if Result = rmbtNone then
      Result := rmbtMasterData;
  end;

  procedure _AddObject(aType: Byte; aClassName: string);
  begin
    t := RMCreateObject(aType, aClassName);
    t.ParentPage := FDesignerForm.Page;
  end;

  procedure _SetControlParent;
  var
    i: Integer;
    lView: TRMView;
  begin
    if t is TRMDialogControl then
    begin
      for i := FDesignerForm.Page.Objects.Count - 2 downto 0 do
      begin
        lView := FDesignerForm.Page.Objects[i];
        if THackView(lView).IsContainer and
          (t.spLeft >= lView.spLeft) and (t.spTop >= lView.spTop) and
          (t.spLeft <= lView.spBottom) and (t.spTop <= lView.spBottom) then
        begin
          THackDialogControl(t).ParentControl := lView.Name;
          THackView(t).IsChildView := True;
          Break;
        end;
      end;
    end;
  end;

  procedure _CreateSection;
  var
    tmp: TRMBandTypesForm;
    lSubReportView: TRMView;
  begin
    tmp := TRMBandTypesForm.Create(nil);
    try
      lSubReportView := FDesignerForm.IsSubreport(FDesignerForm.CurPage);
      if (lSubReportView <> nil) and (TRMSubReportView(lSubReportView).SubReportType = rmstChild) then
        tmp.IsSubreport := True
      else
        tmp.IsSubreport := False;

      lObjectInserted := tmp.ShowModal = mrOk;
      if lObjectInserted then
      begin
        t := RMCreateBand(tmp.SelectedTyp);
        t.ParentPage := FDesignerForm.Page;
        FDesignerForm.SendBandsToDown;
      end;
    finally
      tmp.Free;
    end;
  end;

  procedure _CreateSubReport;
  var
    liPage: TRMReportPage;
  begin
    t := RMCreateObject(rmgtSubReport, '');
    t.ParentPage := FDesignerForm.Page;
    TRMSubReportView(t).SubPage := FDesignerForm.Report.Pages.Count;
    with FDesignerForm, TRMReportPage(FDesignerForm.Page) do
    begin
      liPage := TRMReportPage(Report.Pages.AddReportPage);
      liPage.ChangePaper(PageSize, PrinterInfo.PageWidth, PrinterInfo.PageHeight, PageBin, PageOrientation);
      liPage.mmMarginLeft := mmMarginLeft;
      liPage.mmMarginTop := mmMarginTop;
      liPage.mmMarginRight := mmMarginRight;
      liPage.mmMarginBottom := mmMarginBottom;
      liPage.CreateName;
    end;
    FDesignerForm.SetPageTabs;
    FDesignerForm.CurPage := FDesignerForm.CurPage;
  end;

  procedure _SetDefaultProp;
  var
    lWidth, lHeight: Integer;
    lSaveDesignerRestrictions: TRMDesignerRestrictions;
  begin
    FDesignerForm.Modified := True;
    lSaveDesignerRestrictions := FDesignerForm.DesignerRestrictions;
    FDesignerForm.DesignerRestrictions := [];
    try
      with RM_OldRect do
      begin
        if (Left = Right) or (Top = Bottom) then
        begin
          lWidth := 36;          lHeight := 36;
          if t is TRMCustomMemoView then
            FDesignerForm.GetDefaultSize(lWidth, lHeight)
          else if FDesignerForm.Page is TRMDialogPage then
            t.DefaultSize(lWidth, lHeight);

          RM_OldRect := Rect(Left, Top, Left + lWidth, Top + lHeight);
        end;
      end;

      FDesignerForm.UnselectAll;
      t.Selected := True;
      t.spLeft_Designer := RM_OldRect.Left;
      t.spTop_Designer := RM_OldRect.Top;
      if (t.spWidth_Designer = 0) and (t.spHeight_Designer = 0) then
      begin
        t.spWidth_Designer := RM_OldRect.Right - RM_OldRect.Left;
        t.spHeight_Designer := RM_OldRect.Bottom - RM_OldRect.Top;
      end;
      if t.IsBand and t.IsCrossBand then
      begin
        t.spWidth_Designer := 40;
      end;

      if t is TRMCustomMemoView then
      begin
        t.LeftFrame.Visible := RM_LastLeftFrameVisible;
        t.TopFrame.Visible := RM_LastTopFrameVisible;
        t.RightFrame.Visible := RM_LastRightFrameVisible;
        t.BottomFrame.Visible := RM_LastBottomFrameVisible;
        t.LeftFrame.mmWidth := RM_LastFrameWidth;
        t.TopFrame.mmWidth := RM_LastFrameWidth;
        t.RightFrame.mmWidth := RM_LastFrameWidth;
        t.BottomFrame.mmWidth := RM_LastFrameWidth;
        t.LeftFrame.Color := RM_LastFrameColor;
        t.TopFrame.Color := RM_LastFrameColor;
        t.RightFrame.Color := RM_LastFrameColor;
        t.BottomFrame.Color := RM_LastFrameColor;
        t.FillColor := RM_LastFillColor;
        with TRMCustomMemoView(t) do
        begin
          Font.Name := RM_LastFontName;
          Font.Size := RM_LastFontSize;
          Font.Style := RMSetFontStyle(RM_LastFontStyle);
          Font.Color := RM_LastFontColor;
          Font.Charset := RM_LastFontCharset;
          HAlign := RM_LastHAlign;
          VAlign := RM_LastVAlign;
        end;
      end;

      if t is TRMDialogControl then
      begin
        THackDialogControl(t).Font := t.ParentPage.Font;
      end;

      FDesignerForm.SelNum := 1;
      if t.IsBand then
        Draw(10000, t.GetClipRgn(rmrtExtended))
      else
      begin
        t.Draw(Canvas);
        DrawSelection(t);
      end;

      FDesignerForm.SelectionChanged(True);
    finally
      FDesignerForm.DesignerRestrictions := lSaveDesignerRestrictions;
    end;
  end;

  procedure _InsertControl;
  begin
    t := nil;
    if FDesignerForm.DesignerRestrictions * [rmdrDontCreateObj] = [] then
    begin
      if FDesignerForm.ToolbarComponent.SelectedObjIndex >= 0 then
      begin
        case FDesignerForm.ToolbarComponent.SelectedObjIndex of
          rmgtBand:
            begin
              if _GetUnusedBand <> rmbtNone then
                _CreateSection;
            end;
          rmgtSubReport:
            _CreateSubReport;
        else
          if FDesignerForm.ToolbarComponent.SelectedObjIndex >= rmgtAddIn then
            _AddObject(rmgtAddIn, RMAddIns(FDesignerForm.ToolbarComponent.SelectedObjIndex - rmgtAddIn).ClassRef.ClassName)
          else
            _AddObject(FDesignerForm.ToolbarComponent.SelectedObjIndex, '');
        end;
      end;
    end;

    if t <> nil then
    begin
      _SetDefaultProp;
      FDesignerForm.SetObjectID(t);
      FDesignerForm.AddUndoAction(acInsert);
      _SetControlParent;
    end
    else
    begin
      FMoved := False;
      FCursorType := ctNone;
      FDesignerForm.ToolbarComponent.btnNoSelect.Down := TRUE;
    end;
    if not FDesignerForm.FObjRepeat then
      FDesignerForm.ToolbarComponent.btnNoSelect.Down := True
    else
      DrawFocusRect(RM_OldRect);
  end;

begin
  if Button <> mbLeft then Exit;
  FMouseButtonDown := False;
  DrawPage(dmShape);

  //inserting a new object
  if Cursor = crCross then
  begin
    FMode := mdSelect;
//    if FDesignerForm.Page is TRMReportPage then
    begin
      DrawFocusRect(RM_OldRect);
      if (RM_OldRect.Left = RM_OldRect.Right) and
        (RM_OldRect.Top = RM_OldRect.Bottom) then
        RM_OldRect := RM_OldRect1;
    end;
    NormalizeRect(RM_OldRect);
    FObjectsSelecting := False;

    FObjectsSelecting := False;
    _InsertControl;
    Exit;
  end;

  //calculating which objects contains in frame (if user select it with mouse+Ctrl key)
  if FObjectsSelecting then
  begin
    DrawFocusRect(RM_OldRect);
    FObjectsSelecting := False;
    NormalizeRect(RM_OldRect);
    for i := 0 to FDesignerForm.PageObjects.Count - 1 do
    begin
      t := FDesignerForm.PageObjects[i];
      if t.IsBand then Continue;
      with RM_OldRect do
      begin
        if not ((t.spLeft_Designer > Right) or (t.spLeft_Designer + t.spWidth_Designer < Left) or
          (t.spTop_Designer > Bottom) or (t.spTop_Designer + t.spHeight_Designer < Top)) then
        begin
          t.Selected := True;
          Inc(FDesignerForm.SelNum);
        end;
      end;
    end;
    GetMultipleSelected;
    FDesignerForm.SelectionChanged(True);
    DrawPage(dmSelection);
    Exit;
  end;

  // splitting
  if FMoved and RM_SelectedManyObject and (Cursor = crHSplit) then //同时改变
  begin
    with FDesignerForm.FSplitInfo do
    begin
      dx := SplRect.Left - SplX;
      if (View1.spWidth_Designer + dx > 0) and (View2.spWidth_Designer - dx > 0) then
      begin
        View1.spWidth_Designer := View1.spWidth_Designer + dx;
        View2.spLeft_Designer := View2.spLeft_Designer + dx;
        View2.spWidth_Designer := View2.spWidth_Designer - dx;
        FDesignerForm.Modified := True;
      end;
    end;
    GetMultipleSelected;
    Draw(FDesignerForm.TopSelected, RM_ClipRgn);
    Exit;
  end;

  // resizing several objects
  if FMoved and RM_SelectedManyObject and (Cursor <> crDefault) then
  begin
    DrawFocusRect(RM_OldRect);
    nx := (RM_OldRect.Right - RM_OldRect.Left) / (RM_OldRect1.Right - RM_OldRect1.Left);
    ny := (RM_OldRect.Bottom - RM_OldRect.Top) / (RM_OldRect1.Bottom - RM_OldRect1.Top);
    for i := 0 to FDesignerForm.PageObjects.Count - 1 do
    begin
      t := FDesignerForm.PageObjects[i];
      if t.Selected then
      begin
        x1 := (THackView(t).OriginalRect.Left - FLeftTop.x) * nx;
        x2 := THackView(t).OriginalRect.Right * nx;
        dx := Round(x1 + x2) - (Round(x1) + Round(x2));
        t.spLeft_Designer := FLeftTop.x + Round(x1);
        t.spWidth_Designer := Round(x2) + dx;

        y1 := (THackView(t).OriginalRect.Top - FLeftTop.y) * ny;
        y2 := THackView(t).OriginalRect.Bottom * ny;
        dy := Round(y1 + y2) - (Round(y1) + Round(y2));
        t.spTop_Designer := FLeftTop.y + Round(y1);
        t.spHeight_Designer := Round(y2) + dy;
        FDesignerForm.Modified := True;
      end;
    end;
    Draw(FDesignerForm.TopSelected, RM_ClipRgn);
    Exit;
  end;

  // redrawing all FMoved or resized objects
  if not FMoved then
  begin
    FDesignerForm.SelectionChanged(True);
    DrawPage(dmSelection);
  end;
  if (FDesignerForm.SelNum >= 1) and FMoved then
  begin
    liNeedReDraw := True;
    if ((Cursor = crSizeNS) or FBandMoved) and FDesignerForm.IsBandsSelect(t) then
    begin
      if FDesignerForm.AutoChangeBandPos and FDesignerForm.Page.UpdateBandsPageRect then
      begin
        FDesignerForm.RedrawPage;
        FDesignerForm.Modified := True;
        liNeedRedraw := False;
      end;
    end;

    if FDesignerForm.SelNum > 1 then
    begin
      if liNeedRedraw then
      begin
        Draw(FDesignerForm.TopSelected, RM_ClipRgn);
        GetMultipleSelected;
        FDesignerForm.SelectionChanged(True);
      end;
    end
    else
    begin
      t := FDesignerForm.PageObjects[FDesignerForm.TopSelected];
      NormalizeCoord(t);
      if liNeedRedraw then
        Draw(FDesignerForm.TopSelected, RM_ClipRgn);
      FDesignerForm.SelectionChanged(True);
      //      FDesignerForm.ShowPosition;
    end;
  end;
  FMoved := False;
  FCursorType := ctNone;
end;

procedure TRMWorkSpace.OnMouseMoveEvent(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i, kx, ky, w: Integer;
  t, t1, Bnd: TRMView;
  liBand: TRMView;

  function Cont(px, py, x, y: Integer): Boolean;
  begin
    Result := (x >= px - w) and (x <= px + w + 1) and (y >= py - w) and (y <= py + w + 1);
  end;

  function GridCheck: Boolean;
  begin
    with FDesignerForm do
    begin
      Result := (kx >= GridSize) or (kx <= -GridSize) or
        (ky >= GridSize) or (ky <= -GridSize);
      if Result then
      begin
        kx := kx - kx mod GridSize;
        ky := ky - ky mod GridSize;
      end;
    end;
  end;

  procedure _CheckWidthHeight(t: TRMView; aCursor1, aCursor2: TRMCursorType);
  begin
    if (t.spWidth_Designer < 0) or (t.spHeight_Designer < 0) then
    begin
      NormalizeCoord(t);
      FCursorType := aCursor1;
    end
    else
      FCursorType := aCursor2;
  end;

  function _isSplitting: Boolean;
    { 检查是不是两个选择了两个水平相连的对象，是的话，可以同时改变两个对象的width }
  var
    i, j: Integer;
  begin
    Result := False;
    if not FMouseButtonDown and (FDesignerForm.SelNum > 1) and (FMode = mdSelect) then
    begin
      for i := 0 to FDesignerForm.PageObjects.Count - 1 do
      begin
        t := FDesignerForm.PageObjects[i];
        if (not t.IsBand) and t.Selected then
        begin
          if (x >= t.spLeft_Designer) and (x <= t.spRight_Designer) and (y >= t.spTop_Designer) and (y <= t.spBottom_Designer) then
          begin
            for j := 0 to FDesignerForm.PageObjects.Count - 1 do
            begin
              t1 := FDesignerForm.PageObjects[j];
              if t1.IsBand or (t1 = t) or (not t1.Selected) then Continue;
              if (t.spLeft_Designer = t1.spRight_Designer) and (x >= t.spLeft_Designer) and (x <= t.spLeft_Designer + 2) then // 水平相邻，可以同时改变width
              begin
                Cursor := crHSplit;
                with FDesignerForm.FSplitInfo do
                begin
                  SplRect := Rect(x, t.spTop_Designer, x, t.spTop_Designer + t.spHeight_Designer);
                  if t.spLeft_Designer = t1.spLeft_Designer + t1.spWidth_Designer then
                  begin
                    SplX := t.spLeft_Designer;
                    View1 := t1;
                    View2 := t;
                  end
                  else
                  begin
                    SplX := t1.spLeft_Designer;
                    View1 := t;
                    View2 := t1;
                  end;
                  SplRect.Left := SplX;
                  SplRect.Right := SplX;
                end;
              end;
            end;
          end;
        end;
      end;
    end;

    // splitting
    if (Cursor = crHSplit) and FMouseButtonDown and RM_SelectedManyObject and (FMode = mdSelect) then
    begin
      Result := True;
      kx := x - FLastX;
      ky := 0;
      if (not FDesignerForm.GridAlign) or GridCheck then
      begin
        with FDesignerForm.FSplitInfo do
        begin
          DrawHSplitter(SplRect);
          SplRect := Rect(SplRect.Left + kx, SplRect.Top, SplRect.Right + kx, SplRect.Bottom);
          DrawHSplitter(SplRect);
        end;
        FLastX := x - ((x - FLastX) - kx);
      end;
    end;
  end;

  procedure _SetMaxResizeHeight(aBand: TRMView; var ky: Integer);
  var
    i, lidx: Integer;
    t: TRMView;
  begin
    if ky >= 0 then Exit;
    for i := 0 to FDesignerForm.PageObjects.Count - 1 do
    begin
      t := FDesignerForm.PageObjects[i];
      if (not t.IsBand) and (t.spTop_Designer >= aBand.spTop_Designer) and (t.spBottom_Designer <= aBand.spBottom_Designer) then
      begin
        lidx := aBand.spBottom_Designer - t.spBottom_Designer;
        if lidx < -ky then
          ky := -lidx;
      end;
    end;
    if - ky > aBand.spHeight_Designer then ky := -aBand.spHeight_Designer;
  end;

  procedure _GetDefaultSize(var aKx, aKy: Integer);
  var
    lIndex: Integer;
  begin
    if FDesignerForm.Page is TRMDialogPage then
    begin
      lIndex := FDesignerForm.ToolbarComponent.SelectedObjIndex;
      if lIndex >= rmgtAddIn then
        RMAddIns(lIndex - rmgtAddIn).ClassRef.DefaultSize(aKx, aKy);
    end
    else
      FDesignerForm.GetDefaultSize(kx, ky);
  end;
  
begin
  FMoved := True;
  w := 2;
  if RM_FirstChange and FMouseButtonDown and not FObjectsSelecting then
  begin
    kx := x - FLastX;
    ky := y - FLastY;
    if not FDesignerForm.GridAlign or GridCheck then
    begin
      FDesignerForm.GetRegion;
      if (kx <> 0) or (ky <> 0) then
        FDesignerForm.AddUndoAction(acEdit);
    end;
  end;

  if not FMouseButtonDown then
  begin
    if FDesignerForm.ToolbarComponent.btnNoSelect.Down then
    begin
      FMode := mdSelect;
      Cursor := crDefault;
      if FDesignerForm.SelNum = 0 then
      begin
        FDesignerForm.FShowSizes := False;
        RM_OldRect := Rect(x, y, x, y);
        FDesignerForm.ShowObjMsg;
      end;
    end
    else
    begin
      FMode := mdInsert; // 选择了控件，准备增加
      if Cursor <> crCross then
      begin
        RoundCoord(x, y);
        _GetDefaultSize(kx, ky);
        //FDesignerForm.GetDefaultSize(kx, ky);
        RM_OldRect := Rect(x, y, x + kx, y + ky);
        //if FDesignerForm.Page is TRMReportPage then
          DrawFocusRect(RM_OldRect);
      end;
      Cursor := crCross;
    end;
  end;

  if (FMode = mdInsert) and (not FMouseButtonDown) then
  begin
    //if FDesignerForm.Page is TRMReportPage then
      DrawFocusRect(RM_OldRect);
    RoundCoord(x, y);
    OffsetRect(RM_OldRect, x - RM_OldRect.Left, y - RM_OldRect.Top);
    //if FDesignerForm.Page is TRMReportPage then
      DrawFocusRect(RM_OldRect);
    FDesignerForm.FShowSizes := True;
    FDesignerForm.ShowObjMsg;
    FDesignerForm.FShowSizes := False;
    Exit;
  end;

  // cursor shapes
  if not FMouseButtonDown and (FDesignerForm.SelNum = 1) and (FMode = mdSelect) then
  begin
    t := FDesignerForm.PageObjects[FDesignerForm.TopSelected];
    if Cont(t.spLeft_Designer, t.spTop_Designer, x, y) or Cont(t.spLeft_Designer + t.spWidth_Designer, t.spTop_Designer + t.spHeight_Designer, x, y) then
      Cursor := crSizeNWSE // 改变一个对象大小
    else if Cont(t.spLeft_Designer + t.spWidth_Designer, t.spTop_Designer, x, y) or Cont(t.spLeft_Designer, t.spTop_Designer + t.spHeight_Designer, x, y) then
      Cursor := crSizeNESW
    else if Cont(t.spLeft_Designer + t.spWidth_Designer div 2, t.spTop_Designer, x, y) or Cont(t.spLeft_Designer + t.spWidth_Designer div 2, t.spTop_Designer + t.spHeight_Designer, x, y) then
      Cursor := crSizeNS
    else if Cont(t.spLeft_Designer, t.spTop_Designer + t.spHeight_Designer div 2, x, y) or Cont(t.spLeft_Designer + t.spWidth_Designer, t.spTop_Designer + t.spHeight_Designer div 2, x, y) then
      Cursor := crSizeWE
    else
      Cursor := crDefault;
  end;

  // selecting a lot of objects
  if FMouseButtonDown and FObjectsSelecting then
  begin
    DrawFocusRect(RM_OldRect);
    if Cursor = crCross then
      RoundCoord(x, y);
    RM_OldRect := Rect(RM_OldRect.Left, RM_OldRect.Top, x, y);
    DrawFocusRect(RM_OldRect);
    FDesignerForm.FShowSizes := True;
    if Cursor = crCross then
      FDesignerForm.ShowObjMsg;
    FDesignerForm.FShowSizes := False;
    Exit;
  end;

  // selecting a lot of objects
  if FObjectsSelecting then // 选择Objects
  begin
    DrawFocusRect(RM_OldRect);
    RM_OldRect := Rect(RM_OldRect.Left, RM_OldRect.Top, x, y);
    DrawFocusRect(RM_OldRect);
    Exit;
  end;

  // check for multiple selected objects - right-bottom corner
  if not FMouseButtonDown and (FDesignerForm.SelNum > 1) and (FMode = mdSelect) then
  begin
    t := FDesignerForm.PageObjects[FRightBottom];
    if Cont(t.spLeft_Designer + t.spWidth_Designer, t.spTop_Designer + t.spHeight_Designer, x, y) then
      Cursor := crSizeNWSE // 可以同时改变多个对象的大小
  end;

  if _IsSplitting then
  begin
    Exit;
  end;

  // sizing several objects
  if FMouseButtonDown and RM_SelectedManyObject and (FMode = mdSelect) and (Cursor <> crDefault) then
  begin
    kx := x - FLastX;
    ky := y - FLastY;
    if FDesignerForm.GridAlign and not GridCheck then Exit;
    DrawFocusRect(RM_OldRect);
    RM_OldRect := Rect(RM_OldRect.Left, RM_OldRect.Top, RM_OldRect.Right + kx, RM_OldRect.Bottom + ky);
    DrawFocusRect(RM_OldRect);
    FLastX := x - ((x - FLastX) - kx);
    FLastY := y - ((y - FLastY) - ky);
    FDesignerForm.ShowObjMsg;
    Exit;
  end;

  // moving
  if FMouseButtonDown and (FMode = mdSelect) and (FDesignerForm.SelNum >= 1) and (Cursor = crDefault) then
  begin
    kx := x - FLastX;
    ky := y - FLastY;
    if FDesignerForm.GridAlign and not GridCheck then Exit;
    if RM_FirstBandMove and (FDesignerForm.SelNum = 1) and ((kx <> 0) or (ky <> 0)) and not (ssAlt in Shift) then
    begin
      if TRMView(FDesignerForm.PageObjects[FDesignerForm.TopSelected]).isBand then
      begin
        Bnd := FDesignerForm.PageObjects[FDesignerForm.TopSelected];
        for i := 0 to FDesignerForm.PageObjects.Count - 1 do
        begin
          t := FDesignerForm.PageObjects[i];
          if not t.IsBand then
            if (t.spLeft_Designer >= Bnd.spLeft_Designer) and (t.spLeft_Designer + t.spWidth_Designer <= Bnd.spLeft_Designer + Bnd.spWidth_Designer) and
              (t.spTop_Designer >= Bnd.spTop_Designer) and (t.spTop_Designer + t.spHeight_Designer <= Bnd.spTop_Designer + Bnd.spHeight_Designer) then
            begin
              t.Selected := True;
              Inc(FDesignerForm.SelNum);
            end;
        end;
        GetMultipleSelected;
      end;
    end;

    if (kx <> 0) or (ky <> 0) then
    begin
      RM_FirstBandMove := False;
    end;
    DrawPage(dmShape);

    for i := 0 to FDesignerForm.PageObjects.Count - 1 do
    begin
      t := FDesignerForm.PageObjects[i];
      if not t.Selected then Continue;

      if t.IsCrossBand then
      begin
        t.spLeft_Designer := t.spLeft_Designer + kx;
        if kx <> 0 then FDesignerForm.Modified := True;
      end
      else if not FDesignerForm.IsBandsSelect(liBand) then //对Band,控制其不能左右移动！
      begin
        t.spLeft_Designer := t.spLeft_Designer + kx;
        if kx <> 0 then
        begin
          FDesignerForm.Modified := True;
          FBandMoved := True;
        end;
      end;
      t.spTop_Designer := t.spTop_Designer + ky;
      if ky <> 0 then
      begin
        FDesignerForm.Modified := True;
        FBandMoved := True;
      end;
    end;
    DrawPage(dmShape);
    Inc(FLastX, kx);
    Inc(FLastY, ky);
    FDesignerForm.ShowObjMsg;
  end;

  // resizing
  if FMouseButtonDown and (FMode = mdSelect) and (FDesignerForm.SelNum = 1) and (Cursor <> crDefault) then
  begin
    kx := x - FLastX;
    ky := y - FLastY;
    if FDesignerForm.GridAlign and not GridCheck then Exit;
    DrawPage(dmShape);
    t := FDesignerForm.PageObjects[FDesignerForm.TopSelected];
    if t.IsBand then
    begin
      if TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter] then
        ky := 0
      else
      begin
        kx := 0;
        _SetMaxResizeHeight(t, ky);
      end;
    end;
    FDesignerForm.Modified := True;
    w := 3;
    if Cursor = crSizeNWSE then // 右下角,左上角
    begin
      if ((FCursorType = ct1) or Cont(t.spLeft_Designer, t.spTop_Designer, FLastX, FLastY)) and
        (FCursorType <> ct2) then
      begin
        t.spLeft_Designer := t.spLeft_Designer + kx;
        t.spWidth_Designer := t.spWidth_Designer - kx;
        t.spTop_Designer := t.spTop_Designer + ky;
        t.spHeight_Designer := t.spHeight_Designer - ky;
        _CheckWidthHeight(t, ct2, ct1);
      end
      else
      begin
        t.spWidth_Designer := t.spWidth_Designer + kx;
        t.spHeight_Designer := t.spHeight_Designer + ky;
        _CheckWidthHeight(t, ct1, ct2);
      end;
      if (ky <> 0) and t.IsBand and (not t.IsCrossBand) then
        FBandMoved := True;
    end;

    if Cursor = crSizeNESW then // 右上角,左下角
    begin
      if ((FCursorType = ct3) or Cont(t.spLeft_Designer + t.spWidth_Designer, t.spTop_Designer, FLastX, FLastY)) and
        (FCursorType <> ct4) then
      begin
        t.spTop_Designer := t.spTop_Designer + ky;
        t.spWidth_Designer := t.spWidth_Designer + kx;
        t.spHeight_Designer := t.spHeight_Designer - ky;
        _CheckWidthHeight(t, ct4, ct3);
      end
      else
      begin
        t.spLeft_Designer := t.spLeft_Designer + kx;
        t.spWidth_Designer := t.spWidth_Designer - kx;
        t.spHeight_Designer := t.spHeight_Designer + ky;
        _CheckWidthHeight(t, ct3, ct4);
      end;
      if (ky <> 0) and t.IsBand and (not t.IsCrossBand) then
        FBandMoved := True;
    end;

    if Cursor = crSizeWE then // 改变width
    begin
      if ((FCursorType = ct5) or Cont(t.spLeft_Designer, t.spTop_Designer + t.spHeight_Designer div 2, FLastX, FLastY)) and
        (FCursorType <> ct6) then
      begin
        t.spLeft_Designer := t.spLeft_Designer + kx;
        t.spWidth_Designer := t.spWidth_Designer - kx;
        _CheckWidthHeight(t, ct6, ct5);
      end
      else
      begin
        t.spWidth_Designer := t.spWidth_Designer + kx;
        _CheckWidthHeight(t, ct5, ct6);
      end;
    end;

    if Cursor = crSizeNS then // 改变Height
    begin
      if ((FCursorType = ct7) or Cont(t.spLeft_Designer + t.spWidth_Designer div 2, t.spTop_Designer, FLastX, FLastY)) and
        (FCursorType <> ct8) then
      begin
        t.spTop_Designer := t.spTop_Designer + ky;
        t.spHeight_Designer := t.spHeight_Designer - ky;
        _CheckWidthHeight(t, ct8, ct7);
      end
      else
      begin
        t.spHeight_Designer := t.spHeight_Designer + ky;
        _CheckWidthHeight(t, ct7, ct8);
      end;
    end;

    DrawPage(dmShape);
    FLastX := x - ((x - FLastX) - kx);
    FLastY := y - ((y - FLastY) - ky);
    FDesignerForm.ShowObjMsg;
  end;
end;

procedure TRMWorkSpace.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if ((FMode = mdInsert) and not FMouseButtonDown) or FDragFlag then
  begin
    //if FDesignerForm.Page is TRMReportPage then
      DrawFocusRect(RM_OldRect);
    OffsetRect(RM_OldRect, -10000, -10000);
    Exit;
  end;
end;

procedure TRMWorkSpace.OnDoubleClickEvent(Sender: TObject);
begin
  FMouseButtonDown := False;
  if FDesignerForm.SelNum = 0 then
  begin
    if FDesignerForm.Page is TRMReportPage then
    begin
      //FDesignerForm.ToolbarStandard.btnPageSetup.Click;
      FDoubleClickFlag := True;
    end
    else
    begin
    end
  end
  else if FDesignerForm.SelNum = 1 then
  begin
    FDesignerForm.ShowEditor;
    FDoubleClickFlag := True;
  end;
end;

procedure TRMWorkSpace.DrawHSplitter(aRect: TRect);
begin
  with Canvas do
  begin
    Pen.Mode := pmXor;
    Pen.Color := clSilver;
    Pen.Width := 1;
    MoveTo(aRect.Left, aRect.Top);
    LineTo(aRect.Right, aRect.Bottom);
    Pen.Mode := pmCopy;
  end;
end;

procedure TRMWorkSpace.DrawFocusRect(aRect: TRect);
begin
  with Canvas do
  begin
    Pen.Mode := pmXor;
    Pen.Color := clSilver;
    Pen.Width := 1;
    Pen.Style := psSolid;
    Brush.Style := bsClear;
    Rectangle(aRect.Left, aRect.Top, aRect.Right, aRect.Bottom);
    Pen.Mode := pmCopy;
    Brush.Style := bsSolid;
  end;
end;

procedure TRMWorkSpace.DrawSelection(t: TRMView);
var
  px, py: Word;

  procedure _DrawPoint(x, y: Word);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x, y);
  end;

begin
  if not t.Selected then Exit;
  with t do
  begin
    Canvas.Pen.Width := 5;
    Canvas.Pen.Mode := pmXor;
    Canvas.Pen.Color := clWhite;
    px := spLeft_Designer + spWidth_Designer div 2;
    py := spTop_Designer + spHeight_Designer div 2;
    _DrawPoint(spLeft_Designer, spTop_Designer);
    _DrawPoint(spLeft_Designer + spWidth_Designer, spTop_Designer);
    _DrawPoint(spLeft_Designer, spTop_Designer + spHeight_Designer);
    if FDesignerForm.PageObjects.IndexOf(t) = FRightBottom then
      Canvas.Pen.Color := clTeal;
    _DrawPoint(spLeft_Designer + spWidth_Designer, spTop_Designer + spHeight_Designer);
    Canvas.Pen.Color := clWhite;
    if FDesignerForm.SelNum = 1 then
    begin
      _DrawPoint(px, spTop_Designer);
      _DrawPoint(px, spTop_Designer + spHeight_Designer);
      _DrawPoint(spLeft_Designer, py);
      _DrawPoint(spLeft_Designer + spWidth_Designer, py);
    end;
    Canvas.Pen.Mode := pmCopy;
  end;
end;

procedure TRMWorkSpace.DrawShape(t: TRMView);
begin
  if t.Selected then
  begin
    with t do
    begin
      if FDesignerForm.FShapeMode = smFrame then
        DrawFocusRect(Rect(spLeft_Designer, spTop_Designer, spLeft_Designer + spWidth_Designer + 1, spTop_Designer + spHeight_Designer + 1))
      else
      begin
        with Canvas do
        begin
          Pen.Width := 1;
          Pen.Mode := pmNot;
          Brush.Style := bsSolid;
          Rectangle(spLeft_Designer, spTop_Designer, spLeft_Designer + spWidth_Designer + 1, spTop_Designer + spHeight_Designer + 1);
          Pen.Mode := pmCopy;
        end;
      end;
    end;
  end;
end;

procedure TRMWorkSpace.Draw(N: Integer; aClipRgn: HRGN);
var
  i: Integer;
  t: TRMView;
  R, R1: HRGN;
  Objects: TList;
  liHavePic: Boolean;

  procedure _DrawBackground;
  var
    i, j: Integer;
    lDefaultColor: TColor;
  begin
    lDefaultColor := clBlack;
    with Canvas do
    begin
      Brush.Bitmap := nil;
      if FDesignerForm.ShowGrid and (FDesignerForm.GridSize <> 18) then
      begin
        with FDesignerForm.FGridBitmap.Canvas do
        begin
          if FDesignerForm.Page is TRMDialogPage then
            Brush.Color := TRMDialogPage(FDesignerForm.Page).Color
          else
            Brush.Color := FDesignerForm.WorkSpaceColor;
          FillRect(Rect(0, 0, 8, 8));
          Pixels[0, 0] := lDefaultColor;
          if FDesignerForm.GridSize = 4 then
          begin
            Pixels[4, 0] := lDefaultColor;
            Pixels[0, 4] := lDefaultColor;
            Pixels[4, 4] := lDefaultColor;
          end;
        end;
        Brush.Bitmap := FDesignerForm.FGridBitmap;
      end
      else
      begin
        if FDesignerForm.Page is TRMDialogPage then
          Brush.Color := TRMDialogPage(FDesignerForm.Page).Color
        else
          Brush.Color := FDesignerForm.WorkSpaceColor;
        Brush.Style := bsSolid;
      end;

      FillRgn(Handle, R, Brush.Handle);
      if FDesignerForm.ShowGrid and (FDesignerForm.GridSize = 18) then
      begin
        i := 0;
        while i < Width do
        begin
          j := 0;
          while j < Height do
          begin
            if RectVisible(Handle, Rect(i, j, i + 1, j + 1)) then
              SetPixel(Handle, i, j, lDefaultColor);
            Inc(j, FDesignerForm.GridSize);
          end;
          Inc(i, FDesignerForm.GridSize);
        end;
      end;
    end;
  end;

  procedure _DrawbkGroundPic; // 背景图片
  var
    liRect: TRect;
    lPicWidth, lPicHeight: Integer;
  begin
    if liHavePic then
    begin
      with THackReportPage(FDesignerForm.Page).FbkPicture do
      begin
        lPicWidth := Round(TRMReportPage(FDesignerForm.Page).bkPictureWidth * FDesignerForm.Factor / 100);
        lPicHeight := Round(TRMReportPage(FDesignerForm.Page).bkPictureHeight * FDesignerForm.Factor / 100);
        liRect := Rect(0, 0, lPicWidth, lPicHeight);
        OffsetRect(liRect, -Round(TRMReportPage(FDesignerForm.Page).spMarginLeft * FDesignerForm.Factor / 100),
          -Round(TRMReportPage(FDesignerForm.Page).spMarginTop * FDesignerForm.Factor / 100));
        OffsetRect(liRect, Round(TRMReportPage(FDesignerForm.Page).spBackGroundLeft * FDesignerForm.Factor / 100),
          Round(TRMReportPage(FDesignerForm.Page).spBackGroundTop * FDesignerForm.Factor / 100));
        RMPrintGraphic(Canvas, liRect, Graphic, False, True, False);
      end;
    end;
  end;

  function _IsVisible(t: TRMView): Boolean;
  var
    R: HRGN;
  begin
    R := t.GetClipRgn(rmrtNormal);
    Result := CombineRgn(R, R, aClipRgn, RGN_AND) <> NULLREGION;
    DeleteObject(R);
  end;

  procedure _DrawObject(t: TRMView; aCanvas: TCanvas);
  begin
    t.Draw(aCanvas);
  end;

  procedure _DrawMargins;
  var
    i, j, lColumnWidth: Integer;
  begin
    with Canvas do
    begin
      Brush.Style := bsClear;
      Pen.Width := 1;
      Pen.Color := clGray;
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;
      if FDesignerForm.Page is TRMReportPage then
      begin
        Rectangle(0, 0, Width, Height);
        with TRMReportPage(FDesignerForm.Page) do
        begin
          if ColumnCount > 1 then
          begin
            lColumnWidth := (Width - ((ColumnCount - 1) * spColumnGap)) div ColumnCount;
            Pen.Style := psDot;
            j := 0;
            for i := 1 to ColumnCount do
            begin
              Rectangle(j, 0, j + lColumnWidth + 1, Height);
              j := j + lColumnWidth + spCOlumnGap;
            end;
            Pen.Style := psSolid;
          end;
        end;
      end;
    end;
  end;

begin
  if (FDesignerForm.Page = nil) or FDisableDraw then Exit;

  FDesignerForm.Report.DocMode := rmdmDesigning;
  Objects := THackPage(FDesignerForm.Page).Objects;
  if aClipRgn = 0 then
  begin
    with Canvas.ClipRect do
      aClipRgn := CreateRectRgn(Left, Top, Right, Bottom);
  end;

  liHavePic := (FDesignerForm.Page is TRMReportPage) and (THackReportPage(FDesignerForm.Page).FbkPicture <> nil) and
    (THackReportPage(FDesignerForm.Page).FbkPicture.Graphic <> nil);
  SetTextCharacterExtra(Canvas.Handle, 0);
  R := CreateRectRgn(0, 0, Width, Height);
  for i := Objects.Count - 1 downto 0 do
  begin
    t := Objects[i];
    if liHavePic and t.IsBand then
      Continue;
    if THackView(t).IsChildView then
      Continue;

    if i <= N then
    begin
      if t.Selected then
        _DrawObject(t, Canvas)
      else if _IsVisible(t) then
      begin
        R1 := CreateRectRgn(0, 0, 1, 1);
        CombineRgn(R1, aClipRgn, R, RGN_AND);
        SelectClipRgn(Canvas.Handle, R1);
        DeleteObject(R1);
        _DrawObject(t, Canvas);
      end;
    end;

    SetTextCharacterExtra(Canvas.Handle, 0);
    R1 := t.GetClipRgn(rmrtNormal);
    CombineRgn(R, R, R1, RGN_DIFF);
    DeleteObject(R1);
    SelectClipRgn(Canvas.Handle, R);
  end;

  CombineRgn(R, R, aClipRgn, RGN_AND);
  _DrawBackground;
  _DrawbkGroundPic;

  if liHavePic then
  begin
    for i := Objects.Count - 1 downto 0 do
    begin
      t := Objects[i];
      //      if not t.IsBand then
      _DrawObject(t, Canvas);
    end;
  end;

  DeleteObject(R);
  DeleteObject(aClipRgn);
  SelectClipRgn(Canvas.Handle, 0);
  _DrawMargins;
  if not FMouseButtonDown then
    DrawPage(dmSelection);
end;

procedure TRMWorkSpace.DrawPage(aDrawMode: TRMDesignerDrawMode);
var
  i: Integer;
  t: TRMView;
begin
  if FDesignerForm.Report.DocMode <> rmdmDesigning then Exit;
  for i := 0 to FDesignerForm.PageObjects.Count - 1 do
  begin
    t := FDesignerForm.PageObjects[i];
    case aDrawMode of
      dmAll: t.Draw(Canvas);
      dmSelection: DrawSelection(t);
      dmShape: DrawShape(t);
    end;
  end;
end;

procedure TRMWorkSpace.RedrawPage;
begin
  Draw(10000, 0);
end;

procedure TRMWorkSpace.DoDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  kx, ky: Integer;
begin
  Accept := (Source = FDesignerForm.FFieldForm.lstFields) and
    (FDesignerForm.DesignerRestrictions * [rmdrDontCreateObj] = []) and
    (FDesignerForm.Page is TRMReportPage);
  if not Accept then Exit;

  if not FDragFlag then
  begin
    FDragFlag := True;
    FDesignerForm.GetDefaultSize(kx, ky);
    RM_OldRect := Rect(x - 4, y - 4, x + kx - 4, y + ky - 4);
  end
  else
    DrawFocusRect(RM_OldRect);

  RoundCoord(x, y);
  OffsetRect(RM_OldRect, x - RM_OldRect.Left - 4, y - RM_OldRect.Top - 4);
  DrawFocusRect(RM_OldRect);
end;

procedure TRMWorkSpace.DoDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  t: TRMView;
begin
  FDragFlag := False;
  DrawPage(dmSelection);
  FDesignerForm.UnselectAll;
  FDesignerForm.ToolbarComponent.FSelectedObjIndex := rmgtMemo;
  FDesignerForm.ToolbarComponent.FBtnMemoView.Down := True;
  Cursor := crCross;
  OnMouseUpEvent(nil, mbLeft, [], 0, 0);
  t := FDesignerForm.PageObjects[FDesignerForm.TopSelected];
  t.Memo.Text := '[' + FDesignerForm.FFieldForm.DBField + ']';
  DrawSelection(t);
  t.Draw(Canvas);
  DrawSelection(t);
end;

procedure TRMWorkSpace.CopyToClipboard;
var
  hMem: THandle;
  pMem: pointer;
  lStream: TMemoryStream;

  procedure _SelectionToMemStream(aStream: TMemoryStream);
  var
    i, liNum: Integer;
    t: TRMView;
  begin
    aStream.Clear;
    RMWriteInt32(aStream, 0);
    liNum := 0;
    for i := 0 to FDesignerForm.Page.PageObjects.Count - 1 do
    begin
      t := FDesignerForm.Page.PageObjects[i];
      if t.Selected then
      begin
        RMWriteByte(aStream, t.ObjectType);
        RMWriteString(aStream, t.ClassName);
        THackView(t).StreamMode := rmsmDesigning;
        t.SaveToStream(aStream);
        Inc(liNum);
      end;
    end;

    aStream.Position := 0;
    RMWriteInt32(aStream, liNum);
    aStream.Seek(0, soFromEnd);
  end;

begin
  lStream := TMemoryStream.Create;
  try
    _SelectionToMemStream(lStream);
    ClipBoard.Open;
    try
      lStream.Position := 0;
      hMem := GlobalAlloc(GMEM_MOVEABLE + GMEM_SHARE + GMEM_ZEROINIT, lStream.Size);
      if hMem <> 0 then
      begin
        pMem := GlobalLock(hMem);
        if pMem <> nil then
        begin                        
          CopyMemory(pMem, lStream.Memory, lStream.Size);
          GlobalUnLock(hMem);
          ClipBoard.SetAsHandle(CF_REPORTMACHINE, hMem);
        end;
      end;
    finally
//      GlobalFree(hMem);
      ClipBoard.Close;
    end;
  finally
    lStream.Free;
  end;
end;

procedure TRMWorkSpace.DeleteObjects(aAddUndoAction: Boolean);
var
  i: Integer;
  t: TRMView;
  liHaveBand: Boolean;
begin
  if FDesignerForm.DesignerRestrictions * [rmdrDontDeleteObj] <> [] then Exit;

  if aAddUndoAction then
  begin
    FDesignerForm.AddUndoAction(acDelete);
  end;

  liHaveBand := False;
  FDesignerForm.GetRegion;
  DrawPage(dmSelection);
  for i := FDesignerForm.Page.Objects.Count - 1 downto 0 do
  begin
    t := FDesignerForm.Page.Objects[i];
    if t.IsBand then liHaveBand := True;
    if t.Selected and (t.Restrictions * [rmrtDontDelete] = []) then
    begin
      FDesignerForm.Page.Delete(i);
      FDesignerForm.Modified := True;
    end;
  end;
  FDesignerForm.ResetSelection;
  FDesignerForm.FirstSelected := nil;
  if FDesignerForm.AutoChangeBandPos and liHaveBand then
  begin
    FDesignerForm.Page.UpdateBandsPageRect;
    FDesignerForm.RedrawPage;
  end
  else
    Draw(10000, RM_ClipRgn);
end;

procedure TRMWorkSpace.PasteFromClipboard;
var
  minx, miny: Integer;
  t: TRMView;
  b: Byte;
  lPoint: TPoint;
  hMem: THandle;
  pMem: pointer;
  hSize: DWORD;
  liStream: TMemoryStream;
  liHaveBand: Boolean;
  i, liCount: Integer;

  procedure _CreateName(t: TRMView);
  begin
    if FDesignerForm.Report.FindObject(t.Name) <> nil then
    begin
      t.CreateName(FDesignerForm.Report);
      t.Name := t.Name;
    end;
  end;

  procedure _GetMinXY;
  var
    i, liCount: Integer;
  begin
    liStream.Seek(soFromBeginning, 0);
    liCount := RMReadInt32(liStream);
    for i := 0 to liCount - 1 do
    begin
      b := RMReadByte(liStream);
      t := RMCreateObject(b, RMReadString(liStream));
      try
        THackView(t).StreamMode := rmsmDesigning;
        t.LoadFromStream(liStream);
        if Round(t.spLeft / FDesignerForm.Factor * 100) < minx then
          minx := Round(t.spLeft / FDesignerForm.Factor * 100);
        if Round(t.spTop / FDesignerForm.Factor * 100) < miny then
          miny := Round(t.spTop / FDesignerForm.Factor * 100);
      finally
        t.Free;
      end;
    end;

    if (lPoint.X >= 0) and (lPoint.X < Self.Width) and (lPoint.Y >= 0) and
      (lPoint.Y < Self.Height) then
    begin
      minx := lPoint.X - minx;
      miny := lPoint.Y - miny;
    end
    else
    begin
      minx := -minx + (-Self.Left) div FDesignerForm.GridSize * FDesignerForm.GridSize;
      miny := -miny + (-Self.Left) div FDesignerForm.GridSize * FDesignerForm.GridSize;
    end;
  end;

begin
  if FDesignerForm.Tab1.TabIndex = 0 then
  begin
    if FDesignerForm.FCodeMemo.RMCanPaste then
    begin
      FDesignerForm.FCodeMemo.RMClipBoardPaste;
      FDesignerForm.ShowPosition;
    end;
    Exit;
  end;

  //	IsBandsSelect(lParentBand);
  //  if lParentBand <> nil then
  //  	lParentBand.Selected := False;
  GetCursorPos(lPoint);
  lPoint := Self.ScreenToClient(lPoint);

  FDesignerForm.UnSelectAll;
  FDesignerForm.SelNum := 0;
  minx := 32767;
  miny := 32767;

  liStream := nil;
  Clipboard.Open;
  try
    hMem := Clipboard.GetAsHandle(CF_REPORTMACHINE);
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      hSize := GlobalSize(hMem);
      liStream := TMemoryStream.Create;
      try
        liStream.Write(pMem^, hSize);
      finally
        GlobalUnlock(hMem);
      end;
    end;
  finally
    Clipboard.Close;
  end;

  if liStream = nil then Exit;

  try
    _GetMinXY;
    liStream.Seek(soFromBeginning, 0);
    liCount := RMReadInt32(liStream);
    liHaveBand := False;
    for i := 0 to liCount - 1 do
    begin
      b := RMReadByte(liStream);
      t := RMCreateObject(b, RMReadString(liStream));
      t.NeedCreateName := False;
      try
        THackView(t).StreamMode := rmsmDesigning;
        t.LoadFromStream(liStream);
        if (t is TRMSubReportView) or
          ((FDesignerForm.Page is TRMReportPage) and (t is TRMDialogComponent)) or
          (FDesignerForm.Page is TRMDialogPage) and (t is TRMReportView) then
        begin
          t.Free;
          Continue;
        end;

        if t.IsBand then
        begin
          if not (TRMCustomBandView(t).BandType in [rmbtMasterData, rmbtDetailData, rmbtHeader, rmbtFooter,
            rmbtGroupHeader, rmbtGroupFooter]) and FDesignerForm.RMCheckBand(TRMCustomBandView(t).BandType) then
          begin
            t.Free;
            Continue;
          end;
        end;

        t.Selected := True;
        Inc(FDesignerForm.SelNum);
        t.ParentPage := FDesignerForm.Page;
        _CreateName(t);

        begin
          t.spLeft_Designer := t.spLeft_Designer + minx;
          t.spTop_Designer := t.spTop_Designer + miny;
        end;

        FDesignerForm.SetObjectID(t);
        if t.IsBand then liHaveBand := True;
      finally
      end;
    end;

    if FDesignerForm.AutoChangeBandPos and liHaveBand then
      FDesignerForm.Page.UpdateBandsPageRect;
  finally
    liStream.Free;
    FDesignerForm.SelectionChanged(True);
    FDesignerForm.SendBandsToDown;
    Self.GetMultipleSelected;
    FDesignerForm.RedrawPage;
    FDesignerForm.Modified := True;
    FDesignerForm.AddUndoAction(acInsert);
  end;
end;

procedure TRMWorkSpace.SelectAll;
var
  i: Integer;
begin
  FDesignerForm.SelNum := 0;
  for i := 0 to FDesignerForm.Page.Objects.Count - 1 do
  begin
    TRMView(FDesignerForm.Page.Objects[i]).Selected := True;
    Inc(FDesignerForm.SelNum);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDialogForm }

constructor TRMDialogForm.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(AOwner, Dummy);
  FDesignerForm := TRMCustomDesignerForm(RMDesigner);
end;

procedure TRMDialogForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := FDesignerForm.Handle;
end;

procedure TRMDialogForm.WMMove(var Message: TMessage);
begin
  inherited;
  if Assigned(OnResize) then
    OnResize(nil);
end;

procedure TRMDialogForm.SetPageFormProp;
begin
  with TRMDialogPage(FDesignerForm.page) do
  begin
    Self.OnResize := nil;
    Self.SetBounds(Left, Top, Width, Height);
    Self.Caption := Caption;
    Self.Color := Color;
    //  FPageForm.BorderStyle := BorderStyle;
    Self.Font := Font;

    Self.OnResize := Self.OnFormResizeEvent;
    Self.OnCloseQuery := OnFormCloseQueryEvent;
    Self.OnKeyDown := OnFormKeyDownEvent;
  end;
end;

procedure TRMDialogForm.OnFormResizeEvent(Sender: TObject);
begin
  if FDesignerForm.Page is TRMDialogPage then
  begin
    FDesignerForm.Modified := FDesignerForm.Modified or
      (TRMDialogPage(FDesignerForm.Page).Left <> Left) or
      (TRMDialogPage(FDesignerForm.Page).Top <> Top) or
      (TRMDialogPage(FDesignerForm.Page).Width <> Width) or
      (TRMDialogPage(FDesignerForm.Page).Height <> Height);

    TRMDialogPage(FDesignerForm.Page).Left := Left;
    TRMDialogPage(FDesignerForm.Page).Top := Top;
    TRMDialogPage(FDesignerForm.Page).Width := Width;
    TRMDialogPage(FDesignerForm.Page).Height := Height;
    if FDesignerForm.SelNum = 0 then
      FDesignerForm.ShowPosition;
  end;
end;

procedure TRMDialogForm.OnFormCloseQueryEvent(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure TRMDialogForm.OnFormKeyDownEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
{  if (Chr(Key) = 'C') and (ssCtrl in Shift) then
    Key := vk_Insert;
  if (Chr(Key) = 'X') and (ssCtrl in Shift) then
  begin
    Key := vk_Delete;
    Shift := [ssShift];
  end;
  if (Chr(Key) = 'V') and (ssCtrl in Shift) then
  begin
    Key := vk_Insert;
    Shift := [ssShift];
  end;
  if (Chr(Key) = 'A') and (ssCtrl in Shift) then
      FDesignerForm.btnSelectAllClick(nil);}
  FDesignerForm.DoFormKeyDown(Sender, Key, Shift);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMVirtualReportDesigner }
type
  //  TJvInterpreterArrayValues = array[0..10 - 1] of Integer;
  THackInterpreterFunDesc = class(TJvInterpreterFunDesc);

constructor TRMVirtualReportDesigner.Create(aOwner: TComponent);
{$IFNDEF USE_SYNEDIT}
var
  i: Integer;
  {$ENDIF}
begin
  inherited;

  {$IFDEF USE_SYNEDIT}
  SynPasSyn1 := TSynPasSyn.Create(Self);
  FSynEditSearch := TSynEditSearch.Create(Self);
  FSynEditRegexSearch := TSynEditRegexSearch.Create(Self);
  {$ELSE}
  FFindDialog := TFindDialog.Create(Self);
  FFindDialog.OnFind := FindDialog1Find;

  FReplaceDialog := TReplaceDialog.Create(Self);
  FReplaceDialog.OnFind := ReplaceDialog1Find;
  FReplaceDialog.OnReplace := ReplaceDialog1Replace;
  FReplaceDialog.OnShow := ReplaceDialog1Show;
  {$ENDIF}

  FCodeMemo := TRMSynEditor.Create(Self);
  with FCodeMemo do
  begin
    Parent := Tab1;
    Visible := False;
    {$IFDEF USE_SYNEDIT}
    Highlighter := SynPasSyn1;
    WantTabs := True;
    Gutter.ShowLineNumbers := True;
    {$ENDIF}
    Align := alClient;
    SetHighLighter(rmhlPascal);
    Font.Name := 'Courier New';
    Font.Size := 10;
    SetGutterWidth(48);
    SetGroupUndo(True);
    SetUndoAfterSave(False);
    SetReservedForeColor(clBlue);
    SetCommentForeColor(clGreen);

    {$IFNDEF USE_SYNEDIT}
    Completion.DropDownCount := 8;
    Completion.Enabled := True;
    Completion.ItemHeight := 13;
    Completion.Interval := 800;
    Completion.ListBoxStyle := lbStandard;
    Completion.CaretChar := '|';
    Completion.CRLF := '/n';
    Completion.Separator := '*';
    Completion.Templates.Clear;
    for i := Low(RMCompletionStr) to High(RMCompletionStr) do
      Completion.Templates.Add(RMCompletionStr[i]);
    {$ENDIF}

    OnChange := OnCodeMemoChangeEvent;
    {$IFDEF USE_SYNEDIT}
    OnReplaceText := OnCodeMemoReplaceText;
    OnStatusChange := OnCodeMemoStatusChange;
    {$ELSE}
    OnChangeStatus := OnCodeMemoSelectionChangeEvent;
    OnPaintGutter := OnCodeMemoPaintGutterEvent;
    {$ENDIF}
  end;
end;

destructor TRMVirtualReportDesigner.Destroy;
begin
  inherited;
end;

{$IFDEF Raize}

procedure TRMVirtualReportDesigner.Tab1Changing(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
{$ELSE}

procedure TRMVirtualReportDesigner.Tab1Changing(Sender: TObject; var AllowChange: Boolean);
{$ENDIF}
var
  lErrorMsg: string;
begin
  if Tab1.TabIndex = 0 then
  begin
    AllowChange := False;
    try
      THackReport(Report).FScriptEngine.Pas.Assign(FCodeMemo.Lines);
      THackReport(Report).FScriptEngine.Compile;
      AllowChange := True;
    except
      on E: EJvInterpreterError do
      begin
        lErrorMsg := 'Script Error:' + #13#10 + IntToStr(E.ErrCode) + ': ' + E.Message;
        if E.ErrPos > -1 then
        begin
          lErrorMsg := lErrorMsg + #13#10 + 'at Postion:' + IntToStr(E.ErrPos);
        end;

        Application.MessageBox(PChar(lErrorMsg), PChar(RMLoadStr(SError)), mb_Ok + mb_IconError);
      end;
    end;
  end;
end;

// Event Editor

function LoadStr2(const ResID: Integer): string;
var
  i: Integer;
begin
  for i := Low(JvInterpreterErrors) to High(JvInterpreterErrors) do
    if JvInterpreterErrors[i].ID = ResID then
    begin
      Result := JvInterpreterErrors[i].Description;
      Break;
    end;
end;

function TRMVirtualReportDesigner.PosBeg: Integer;
begin
  Result := CurPos - Length(TokenStr);
end;

function TRMVirtualReportDesigner.PosRow: Integer;
begin
  Result := GetLineByPos(ScriptParser.Source, PosBeg) + 0 {BaseErrLine} + 1;
end;

procedure TRMVirtualReportDesigner.ErrorExpected(Exp: string);
var
  lErrPos: Integer;
  lErrMsg: string;

  procedure _NONAME1;
  var
    lErrLine: Integer;
  begin
    if lErrPos = -1 then
      lErrPos := CurPos;

    lErrLine := PosRow;
    lErrMsg := Format(LoadStr2(ieErrorPos), ['Report', lErrLine, lErrMsg]);
  end;

begin
  lErrPos := PosBeg;
  if TokenStr <> '' then
    lErrMsg := Format(LoadStr2(ieExpected), [Exp, '''' + TokenStr + ''''])
  else
    lErrMsg := Format(LoadStr2(ieExpected), [Exp, LoadStr2(irEndOfFile)]);

  _NONAME1;
  FErrorFlag := True;
  lErrMsg := 'Script Error:' + #13#10 + IntToStr(ieExpected) + ': ' + lErrMsg;
  if lErrPos > -1 then
  begin
    lErrMsg := lErrMsg + #13#10 + 'at Postion:' + IntToStr(lErrPos);
  end;

  Application.MessageBox(PChar(lErrMsg), PChar(RMLoadStr(SError)), mb_Ok + mb_IconError);
end;

procedure TRMVirtualReportDesigner.SetCurPos(Value: Integer);
begin
  ScriptParser.Pos := Value;
  FBacked := False;
end;

function TRMVirtualReportDesigner.GetCurPos: Integer;
begin
  Result := ScriptParser.Pos;
end;

function TRMVirtualReportDesigner.ParseDataType: IJvInterpreterDataType;
var
  TypName: string;
  ArrayBegin, ArrayEnd: TJvInterpreterArrayValues;
  TempBegin, TempEnd: Integer;
  ArrayType: Integer;
  Dimension: Integer;
  Minus1, Minus2: Boolean;
  //
  ArrayDT: IJvInterpreterDataType;
begin
  TypName := Token;
  Dimension := 0;
  if TTyp = ttIdentifier then
  begin
    {    Typ := TypeName2VarTyp(TypName);
        JvInterpreterRecord := TJvInterpreterRecord(GetRec(TypName));
        if JvInterpreterRecord = nil then
          JvInterpreterRecord := TJvInterpreterRecord(GlobalJvInterpreterAdapter.GetRec(TypName));
        if JvInterpreterRecord <> nil then
          Result := TJvInterpreterRecordDataType.Create(JvInterpreterRecord)
        else
          Result := TJvInterpreterSimpleDataType.Create(Typ);}
  end
  else if TTyp = ttArray then
  begin
    {Get Array variables params}
    {This is code is not very clear}
//    Typ := varArray;
    NextToken;
    if (TTyp <> ttLs) and (TTyp <> ttOf) then
      ErrorExpected('''[''' + ' or ' + '''Of''');
    {Parse Array Range}
    if TTyp = ttLs then
    begin
      Dimension := 0;
      repeat
        NextToken;
        Minus1 := False;
        if (Trim(TokenStr1) = '-') then
        begin
          Minus1 := True;
          NextToken;
        end;
        TempBegin := StrToInt(TokenStr1);
        try
          ArrayBegin[Dimension] := TempBegin;
          if Minus1 then
            ArrayBegin[Dimension] := ArrayBegin[Dimension] * (-1);
        except
          ErrorExpected('''Integer Value''');
        end;
        NextToken;
        if TTyp <> ttDoublePoint then
          ErrorExpected('''..''');
        NextToken;
        Minus2 := False;
        if (Trim(TokenStr1) = '-') then
        begin
          Minus2 := True;
          NextToken;
        end;
        TempEnd := StrToInt(TokenStr1);
        try
          ArrayEnd[Dimension] := TempEnd;
        except
          if Minus2 then
            ArrayEnd[Dimension] := ArrayEnd[Dimension] * (-1);
          ErrorExpected('''Integer Value''');
        end;
        if (Dimension < 0) or (Dimension > cJvInterpreterMaxArgs) then
          JvInterpreterError(ieArrayBadDimension, CurPos);
        if not (ArrayBegin[Dimension] <= ArrayEnd[Dimension]) then
          JvInterpreterError(ieArrayBadRange, CurPos);
        {End Array Range}
        NextToken;
        Inc(Dimension);
      until TTyp <> ttCol; { , }
      if TTyp <> ttRs then
        ErrorExpected(''']''');
      NextToken;
      if TTyp <> ttOf then
        ErrorExpected('''' + kwOF + '''');
    end
    else if TTyp = ttOf then
    begin
      Dimension := 1;
      ArrayBegin[0] := 0;
      ArrayEnd[0] := -1;
    end;
    NextToken;
    ArrayType := TypeName2VarTyp(Token);
    //recursion for arrays
    ArrayDT := ParseDataType;
    Result := TJvInterpreterArrayDataType.Create(ArrayBegin, ArrayEnd, Dimension, ArrayType, ArrayDT);
    {end: var A:array [1..200] of Integer, parsing}
  end
  else
    ErrorExpected(LoadStr2(irIdentifier));
end;

procedure TRMVirtualReportDesigner.ParseToken;
var
  lOldDecimalSeparator: Char;
  lDob: Extended;
  lInt: Integer;
  lStub: Integer;
begin
  TokenStr1 := ScriptParser.Token;
  TTyp := TokenTyp(TokenStr1);
  case TTyp of
    ttInteger:
      begin
        Val(TokenStr1, lInt, lStub);
        Token := lInt;
      end;
    ttDouble:
      begin
        lOldDecimalSeparator := DecimalSeparator;
        DecimalSeparator := '.';
        if not TextToFloat(PChar(TokenStr1), lDob, fvExtended) then
        begin
          DecimalSeparator := lOldDecimalSeparator;
          JvInterpreterError(ieInternal, -1);
        end
        else
          DecimalSeparator := lOldDecimalSeparator;
        Token := lDob;
      end;
    ttString:
      Token := Copy(TokenStr, 2, Length(TokenStr1) - 2);
    ttFalse:
      Token := False;
    ttTrue:
      Token := True;
    ttIdentifier:
      Token := TokenStr1;
    ttArray:
      Token := TokenStr1;
  end;
end;

procedure TRMVirtualReportDesigner.NextToken;
begin
  if FBacked then
    FBacked := False
  else
  begin
    PrevTTyp := TTyp;
    ParseToken;
  end;
end;

procedure TRMVirtualReportDesigner.Back;
begin
  //  JvInterpreterError(ieInternal, -2);
  if FBacked then
    JvInterpreterError(ieInternal, -1);
  FBacked := True;
end;

procedure TRMVirtualReportDesigner.FindToken1(TTyp1: TTokenTyp);
begin
  while not (TTyp in [TTyp1, ttEmpty]) do
    NextToken;
  if TTyp = ttEmpty then
    ErrorExpected('''' + kwEND + '''');
end;

procedure TRMVirtualReportDesigner.SkipIdentifier1;
begin
  while True do
    case TTyp of
      ttEmpty:
        ErrorExpected('''' + kwEND + '''');
      ttIdentifier..ttBoolean, ttLB, ttRB, ttCol, ttPoint, ttLS, ttRS,
        ttNot..ttEquLess, ttTrue, ttFalse:
        NextToken;
      ttSemicolon, ttEnd, ttElse, ttUntil, ttFinally, ttExcept, ttDo, ttOf:
        Break;
      ttColon:
        { 'case' or assignment }
        begin
          NextToken;
          if TTyp <> ttEqu then
          begin
            Back;
            Break;
          end;
        end;
    else
      ErrorExpected(LoadStr2(irExpression))
    end;
end;

procedure TRMVirtualReportDesigner.SkipToUntil1;
begin
  while True do
  begin
    NextToken;
    if TTyp = ttUntil then
    begin
      NextToken;
      Break;
    end
    else if TTyp = ttEmpty then
      ErrorExpected('''' + kwUNTIL + '''')
    else
      SkipStatement1;
    if TTyp = ttUntil then
    begin
      NextToken;
      Break;
    end;
  end;
end;

procedure TRMVirtualReportDesigner.SkipStatement1;
begin
  case TTyp of
    ttEmpty:
      ErrorExpected('''' + kwEND + '''');
    ttIdentifier:
      SkipIdentifier1;
    ttSemicolon:
      NextToken;
    ttEnd:
      NextToken;
    ttIf:
      begin
        FindToken1(ttThen);
        NextToken;
        SkipStatement1;
        if TTyp = ttElse then
        begin
          NextToken;
          SkipStatement1;
        end;
        Exit;
      end;
    ttElse:
      Exit;
    ttWhile, ttFor:
      begin
        FindToken1(ttDo);
        NextToken;
        SkipStatement1;
        Exit;
      end;
    ttRepeat:
      begin
        SkipToUntil1;
        SkipIdentifier1;
        Exit;
      end;
    ttBreak, ttContinue:
      NextToken;
    ttBegin:
      begin
        SkipToEnd1;
        Exit;
      end;
    ttTry:
      begin
        SkipToEnd1;
        Exit;
      end;
    ttFunction, ttProcedure:
      ErrorExpected('''' + kwEND + '''');
    ttRaise:
      begin
        NextToken;
        SkipIdentifier1;
      end;
    ttExit:
      NextToken;
    ttCase:
      begin
        SkipToEnd1;
        Exit;
      end;
  end;
end;

procedure TRMVirtualReportDesigner.SkipToEnd1;
begin
  while True do
  begin
    NextToken;
    if TTyp = ttEnd then
    begin
      NextToken;
      Break;
    end
    else if TTyp in [ttBegin, ttTry, ttCase] then
      SkipToEnd1
    else if TTyp = ttEmpty then
      ErrorExpected('''' + kwEND + '''')
    else
      SkipStatement1;
    if TTyp = ttEnd then
    begin
      NextToken;
      Break;
    end;
  end;
end;

function TRMVirtualReportDesigner.Function1(aParams: PRMParamRecArray; var aParamCount: Integer): string;

  procedure _ReadFunHeader(aFunDesc: TJvInterpreterFunDesc);
  var
    lTypName: string;
    lFun: Boolean;

    procedure _ReadParams;
    var
      lVarParam: Boolean;
      lParamType: string;
      liBeg: Integer;
    begin
      while True do
      begin
        lVarParam := False;
        NextToken;
        THackInterpreterFunDesc(aFunDesc).FParamNames[aFunDesc.ParamCount] := Token;
        if TTyp = ttRB then
          Break;

        if TTyp = ttVar then
        begin
          lVarParam := True;
          NextToken;
        end;

        liBeg := aFunDesc.ParamCount;
        while True do
        begin
          case TTyp of
            ttIdentifier:
              THackInterpreterFunDesc(aFunDesc).FParamNames[aFunDesc.ParamCount] := Token;
            ttSemicolon: Break;
            ttRB: Exit;
            ttColon:
              begin
                NextToken;
                if TTyp <> ttIdentifier then
                begin
                  ErrorExpected(LoadStr2(irIdentifier));
                end;

                lParamType := Token;
                while True do
                begin
                  if TTyp = ttRB then
                    Back;
                  if TTyp in [ttRB, ttSemicolon] then
                    Break;
                  NextToken;
                end;
                Inc(THackInterpreterFunDesc(aFunDesc).FParamCount);
                while liBeg < THackInterpreterFunDesc(aFunDesc).FParamCount do
                begin
                  aParams[liBeg].IsVar := lVarParam;
                  aParams[liBeg].IsConst := False;
                  aParams[liBeg].IsArray := False;
                  aParams[liBeg].ClassType := lParamType;

                  THackInterpreterFunDesc(aFunDesc).FParamTypes[liBeg] := TypeName2VarTyp(lParamType);
                  if lVarParam then
                    THackInterpreterFunDesc(aFunDesc).FParamTypes[liBeg] := THackInterpreterFunDesc(aFunDesc).FParamTypes[liBeg] or
                      varByRef;
                  Inc(liBeg);
                end;
                Break;
              end;
            ttCol:
              Inc(THackInterpreterFunDesc(aFunDesc).FParamCount);
          end;

          NextToken;
        end;
      end;
    end;

  begin
    lFun := TTyp = ttFunction;
    NextToken;
    if TTyp <> ttIdentifier then
    begin
      ErrorExpected(LoadStr2(irIdentifier));
      Exit;
    end;

    THackInterpreterFunDesc(aFunDesc).FIdentifier := Token;
    NextToken;
    if TTyp = ttPoint then
    begin
      THackInterpreterFunDesc(aFunDesc).FClassIdentifier := THackInterpreterFunDesc(aFunDesc).FIdentifier;
      NextToken;
      if TTyp <> ttIdentifier then
      begin
        ErrorExpected(LoadStr2(irIdentifier));
      end;

      THackInterpreterFunDesc(aFunDesc).FIdentifier := Token;
      NextToken;
    end;

    THackInterpreterFunDesc(aFunDesc).FResTyp := varEmpty;
    THackInterpreterFunDesc(aFunDesc).FParamCount := 0;
    if TTyp = ttLB then
    begin
      _ReadParams;
      NextToken;
    end;

    if lFun then
    begin
      if (TTyp = ttColon) then
      begin
        NextToken;
        if TTyp <> ttIdentifier then
        begin
          ErrorExpected(LoadStr2(irIdentifier));
        end;

        lTypName := Token;
        THackInterpreterFunDesc(aFunDesc).FResDataType := ParseDataType;
        //THackInterpreterFunDesc(aFunDesc).FResTyp := THackInterpreterFunDesc(aFunDesc).FResDataType.GetTyp;
        if THackInterpreterFunDesc(aFunDesc).FResTyp = 0 then
          THackInterpreterFunDesc(aFunDesc).FResTyp := varVariant;
        NextToken;
      end
      else
        ErrorExpected(''':''');
    end;

    if TTyp <> ttSemicolon then
      ErrorExpected(''';''');
  end;

var
  lFunDesc: TJvInterpreterFunDesc;
  lLastTTyp: TTokenTyp;
begin
  lFunDesc := TJvInterpreterFunDesc.Create;
  try
    _ReadFunHeader(lFunDesc);
    THackInterpreterFunDesc(lFunDesc).FPosBeg := CurPos;
    lLastTTyp := TTyp;
    NextToken;
    if TTyp = ttExternal then
    begin
      {      NextToken;
            if TTyp = ttString then
              DllName := Token
            else if TTyp = ttIdentifier then
            begin
              Args.Clear;
              if not GetValue(Token, FVResult, Args) then
                JvInterpreterErrorN(ieUnknownIdentifier, PosBeg, Token);
              DllName := vResult;
            end
            else
              ErrorExpected('''string constant''');
            NextToken;
            if TTyp <> ttIdentifier then
              ErrorExpected('''name'' or ''index''');
            FunIndex := -1;
            FunName := '';
            if Cmp(Token, 'name') then
            begin
              NextToken;
              if TTyp = ttString then
                FunName := Token
              else
                ErrorExpected('''string constant''');
            end
            else if Cmp(Token, 'index') then
            begin
              NextToken;
              if TTyp = ttInteger then
                FunIndex := Token
              else
                ErrorExpected('''integer constant''');
            end
            else
              ErrorExpected('''name'' or ''index''');
            with FunDesc do
              FAdapter.AddExtFun(FCurUnitName, FIdentifier, noInstance, DllName,
                FunName, FunIndex, FParamCount, FParamTypes, FResTyp);
            NextToken;}
    end
    else if FUnitSection = usInterface then
    begin
      CurPos := THackInterpreterFunDesc(lFunDesc).FPosBeg;
      TTyp := lLastTTyp;
    end
    else
    begin
      FindToken1(ttBegin);
      FSaveFuncBeginPos := PosBeg + 6;
      SkipToEnd1;
    end;

    Result := lFunDesc.Identifier;
    aParamCount := lFunDesc.ParamCount;
  finally
    lFunDesc.Free;
  end;
end;

procedure TRMVirtualReportDesigner.FindOneFunc(aParams: PRMParamRecArray;
  var aIsEnd: Boolean; var aFuncName: string; var aParamCount: Integer);
var
  lIsProcedure: Boolean;
begin
  aIsEnd := False;
  aFuncName := '';
  while not FErrorFlag do
  begin
    case TTyp of
      ttEmpty:
        begin
          aIsEnd := True;
          Break;
        end;
      ttEnd:
        begin
          aIsEnd := True;
          Break;
        end;
      ttImplementation:
        begin
          FUnitSection := usImplementation;
          Break;
        end;
      ttFunction, ttProcedure:
        begin
          FSaveFuncPos := PosBeg;
          FSaveFuncRow := PosRow - 1;
          lIsProcedure := TTyp = ttProcedure;
          aFuncName := Function1(aParams, aParamCount);
          if (not FErrorFlag) and (TTyp = ttSemicolon) then
          begin
            if lIsProcedure then
            begin
              Break;
            end;
          end
          else
          begin
            FErrorFlag := True;
          end;
        end;
      ttUses:
        begin
          //Uses1(UsesList);
        end;
      ttVar:
        begin
          //Var1(FAdapter.AddSrcVar);
        end;
      ttConst:
        begin
          //Const1(FAdapter.AddSrcVar);
        end;
      ttInterface:
        begin
          FUnitSection := usInterface;
          Break;
        end;
      ttType:
        begin
          //Type1;
        end;
    end;

    NextToken;
  end;
end;

procedure TRMVirtualReportDesigner.GetEventFunctions(aValues: TStrings;
  aParams: PRMParamRecArray; aParamCount: Integer);
var
  lFuncName: string;
  lParams: TRMParamRecArray;
  lParamCount: Integer;
  lIsEnd: Boolean;

  function _IsEuqal: Boolean;
  var
    i: Integer;
  begin
    Result := True;
    for i := 0 to lParamCount - 1 do
    begin
      if (aParams[i].IsVar <> lParams[i].IsVar) or
        (aParams[i].IsConst <> lParams[i].IsConst) or
        (aParams[i].IsArray <> lParams[i].IsArray) or
        (not RMCmp(aParams[i].ClassType, lParams[i].ClassType)) then
      begin
        Result := False;
        Break;
      end;
    end;
  end;

begin
  FBacked := False;
  ScriptParser.Source := FCodeMemo.Lines.Text;
  ScriptParser.Init;

  FErrorFlag := False;
  FUnitSection := usUnknown;
  NextToken;
  while True do
  begin
    FindOneFunc(@lParams, lIsEnd, lFuncName, lParamCount);
    if lIsEnd or FErrorFlag then
      Break;

    if lFuncName <> '' then
    begin
      if (FUnitSection = usInterface) and (aParamCount = lParamCount) then
      begin
        if _IsEuqal then
          aValues.Add(lFuncName);
      end;
    end
    else if TTyp = ttImplementation then
      Break;

    NextToken;
  end; {while}
end;

procedure TRMVirtualReportDesigner.EditMethod(aFuncName: string;
  aParams: PRMParamRecArray; aParamCount: Integer);
var
  lFuncName: string;
  lParams: TRMParamRecArray;
  lParamCount: Integer;
  lIsEnd: Boolean;
  lFoundFuncDefine: Boolean;
  lFoundFunc: Boolean;
  lMainFuncPos, lMainFuncRow: Integer;
  lInterfacePos, lInterfaceRow: Integer;
  lFuncDefine: string;

  function _GetFuncDefine: string;
  var
    i: Integer;
  begin
    Result := 'procedure ' + aFuncName + '(';
    for i := 0 to aParamCount - 1 do
    begin
      if i > 0 then
        Result := Result + '; ';

      if aParams[i].IsVar then
        Result := Result + 'var ';
      if aParams[i].IsConst then
        Result := Result + 'const ';
      if aParams[i].IsArray then
        Result := Result + 'array of ';

      Result := Result + aParams[i].Name + ': ';
      Result := Result + aParams[i].ClassType;
    end;

    Result := Result + ');';
  end;

  function _IsEuqal: Boolean;
  var
    i: Integer;
  begin
    Result := True;
    for i := 0 to lParamCount - 1 do
    begin
      if (aParams[i].IsVar <> lParams[i].IsVar) or
        (aParams[i].IsConst <> lParams[i].IsConst) or
        (aParams[i].IsArray <> lParams[i].IsArray) or
        (not RMCmp(aParams[i].ClassType, lParams[i].ClassType)) then
      begin
        Result := False;
        Break;
      end;
    end;
  end;

begin
  if Tab1.TabIndex <> 0 then
  begin
    Tab1.TabIndex := 0;
    Tab1.OnChange(Tab1);
  end;

  FCodeMemo.BeginUpdate;
  FCodeMemo.SetFocus;
  FCodeMemo.SelLength := 0;
  try
    lFuncDefine := _GetFuncDefine;
    FBacked := False;
    ScriptParser.Source := FCodeMemo.Lines.Text;

    lMainFuncRow := 0;
    lInterfaceRow := 0;
    lMainFuncPos := 0;
    lInterfacePos := 0;
    lFoundFuncDefine := False;
    lFoundFunc := False;
    FErrorFlag := False;
    FUnitSection := usUnknown;
    NextToken;

    while True do
    begin
      FindOneFunc(@lParams, lIsEnd, lFuncName, lParamCount);
      if lIsEnd or FErrorFlag then
        Break;

      if lFuncName <> '' then
      begin
        if (FUnitSection = usInterface) and (aParamCount = lParamCount) and
          RMCmp(lFuncName, aFuncName) and _IsEuqal then // 声明
        begin
          lFoundFuncDefine := True;
        end
        else if (FUnitSection = usImplementation) and (aParamCount = lParamCount) and
          RMCmp(lFuncName, aFuncName) and _IsEuqal then // 定义
        begin
          lFoundFunc := True;
          FCodeMemo.SelStart := FSaveFuncBeginPos;
          Break;
        end
        else if (FUnitSection = usImplementation) and (lParamCount = 0) and
          RMCmp(lFuncName, 'main') then
        begin
          lMainFuncPos := FSaveFuncPos;
          lMainFuncRow := FSaveFuncRow;
        end;
      end
      else
      begin
        case TTyp of
          ttImplementation:
            begin
              lInterfacePos := PosBeg;
              lInterfaceRow := PosRow - 1;
            end;
          ttInterface:
            begin
            end;
        end;
      end;

      NextToken;
    end; {while}

    if lInterfacePos = 0 then // 旧版，没有interface,增加
    begin
      FCodeMemo.Lines.Insert(1, '');
      FCodeMemo.Lines.Insert(2, 'interface');
      FCodeMemo.Lines.Insert(3, '');
      FCodeMemo.Lines.Insert(4, 'implementation');
      lInterfacePos := 17 + 11;
      lInterfaceRow := 4;
      lMainFuncPos := {lInterfacePos + 19}lInterfacePos + 3;
      lMainFuncRow := 6;
    end;

    if not lFoundFuncDefine then // 没有找到事件函数定义部分，增加
    begin
//      FCodeMemo.SelStart := lInterfacePos;
      FCodeMemo.Lines.Insert(lInterfaceRow, lFuncDefine);
      FCodeMemo.SelStart := lInterfacePos + Length(lFuncDefine) + 1;
      if lMainFuncPos >= lInterfacePos then
      begin
        Inc(lMainFuncPos, Length(lFuncDefine) + 1);
      end;
    end;

    if not lFoundFunc then // 没有找到时间函数实现部分，增加
    begin
      //FCodeMemo.SelStart := lMainFuncPos;
      FCodeMemo.Lines.Insert(lMainFuncRow, '');
      FCodeMemo.Lines.Insert(lMainFuncRow + 1, lFuncDefine);
      FCodeMemo.Lines.Insert(lMainFuncRow + 2, 'begin');
      FCodeMemo.Lines.Insert(lMainFuncRow + 3, '');
      FCodeMemo.Lines.Insert(lMainFuncRow + 4, 'end;');

      FCodeMemo.SelStart := lMainFuncPos + Length(lFuncDefine) + 9;
    end;

    {$IFDEF USE_SYNEDIT}
    FCodeMemo.SelStart := FCodeMemo.SelStart + 1;
    {$ENDIF}
  finally
    FCodeMemo.EndUpdate;
  end;
end;

procedure TRMVirtualReportDesigner.ClearEmptyEvent;  // 清理空的事件代码
begin
end;

procedure TRMVirtualReportDesigner.OnCodeMemoChangeEvent(Sender: TObject);
begin
  Modified := True;
  EnableControls;
end;

procedure TRMVirtualReportDesigner.OnCodeMemoPaintGutterEvent(Sender: TObject; aCanvas: TCanvas);
{$IFDEF USE_SYNEDIT}
begin
end;
{$ELSE}
var
  i, Y: integer;
  str: string;
begin
  Y := 0;
  for i := FCodeMemo.TopRow to FCodeMemo.TopRow + FCodeMemo.LastVisibleRow do
  begin
    str := IntToStr(i + 1);
    aCanvas.TextOut(FCodeMemo.GutterWidth - aCanvas.TextWidth(str) - 4, Y, str);
    Inc(Y, FCodeMemo.CellRect.Height);
  end;
end;
{$ENDIF}

{$IFDEF USE_SYNEDIT}

procedure TRMVirtualReportDesigner.DoSearchReplaceText(aReplace: Boolean;
  aBackwards: Boolean);
var
  lOptions: TSynSearchOptions;
begin
  if aReplace then
    lOptions := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    lOptions := [];

  if aBackwards then
    Include(lOptions, ssoBackwards);
  if FSearchCaseSensitive then
    Include(lOptions, ssoMatchCase);
  if not FSearchFromCaret1 then
    Include(lOptions, ssoEntireScope);
  if FSearchSelectionOnly then
    Include(lOptions, ssoSelectedOnly);
  if FSearchWholeWords then
    Include(lOptions, ssoWholeWord);
  if FSearchRegex then
    FCodeMemo.SearchEngine := FSynEditRegexSearch
  else
    FCodeMemo.SearchEngine := FSynEditSearch;

  if FCodeMemo.SearchReplace(FSearchText, FReplaceText, lOptions) = 0 then
  begin
    MessageBeep(MB_ICONASTERISK);
    //Statusbar.SimpleText := STextNotFound;
    if ssoBackwards in lOptions then
      FCodeMemo.BlockEnd := FCodeMemo.BlockBegin
    else
      FCodeMemo.BlockBegin := FCodeMemo.BlockEnd;
    FCodeMemo.CaretXY := FCodeMemo.BlockBegin;
  end;

  if RMConfirmReplaceDialog <> nil then
    FreeAndNil(RMConfirmReplaceDialog);
end;

procedure TRMVirtualReportDesigner.ShowSearchReplaceDialog(aReplace: Boolean);
var
  lDlg: TForm;
begin
  if aReplace then
    lDlg := TRMTextReplaceDialog.Create(Self)
  else
    lDlg := TRMTextSearchDialog.Create(Self);

  with TRMTextSearchDialog(lDlg) do
  begin
    try
      SearchBackwards := FSearchBackwards;
      SearchCaseSensitive := FSearchCaseSensitive;
      SearchFromCursor := FSearchFromCaret1;
      SearchInSelectionOnly := FSearchSelectionOnly;
      SearchText := FSearchText;
      if FSearchTextAtCaret then
      begin
        if FCodeMemo.SelAvail and (FCodeMemo.BlockBegin.Line = FCodeMemo.BlockEnd.Line) then
          SearchText := FCodeMemo.SelText
        else
          SearchText := FCodeMemo.GetWordAtRowCol(FCodeMemo.CaretXY);
      end;
      SearchTextHistory := FSearchTextHistory;
      if aReplace then
      begin
        with lDlg as TRMTextReplaceDialog do
        begin
          ReplaceText := FReplaceText;
          ReplaceTextHistory := FReplaceTextHistory;
        end;
      end;
      SearchWholeWords := FSearchWholeWords;
      if ShowModal = mrOK then
      begin
        FSearchBackwards := SearchBackwards;
        FSearchCaseSensitive := SearchCaseSensitive;
        FSearchFromCaret1 := SearchFromCursor;
        FSearchSelectionOnly := SearchInSelectionOnly;
        FSearchWholeWords := SearchWholeWords;
        FSearchRegex := SearchRegularExpression;
        FSearchText := SearchText;
        FSearchTextHistory := SearchTextHistory;
        if aReplace then
        begin
          with lDlg as TRMTextReplaceDialog do
          begin
            FReplaceText := ReplaceText;
            FReplaceTextHistory := ReplaceTextHistory;
          end;
        end;
        FSearchFromCaret1 := FSearchFromCaret1;
        if FSearchText <> '' then
        begin
          DoSearchReplaceText(aReplace, FSearchBackwards);
          FSearchFromCaret1 := True;
        end;
      end;
    finally
      lDlg.Free;
    end;
  end;
end;

procedure TRMVirtualReportDesigner.OnCodeMemoReplaceText(Sender: TObject; const aSearch,
  aReplace: string; aLine, aColumn: Integer; var Action: TSynReplaceAction);
var
  lPos: TPoint;
  lEditRect: TRect;
begin
  if ASearch = AReplace then
    Action := raSkip
  else
  begin
    lPos := FCodeMemo.ClientToScreen(
      FCodeMemo.RowColumnToPixels(
      FCodeMemo.BufferToDisplayPos(
      BufferCoord(aColumn, aLine))));
    lEditRect := ClientRect;
    lEditRect.TopLeft := ClientToScreen(lEditRect.TopLeft);
    lEditRect.BottomRight := ClientToScreen(lEditRect.BottomRight);

    if RMConfirmReplaceDialog = nil then
      RMConfirmReplaceDialog := TRMConfirmReplaceDialog.Create(Application);
    RMConfirmReplaceDialog.PrepareShow(lEditRect, lPos.X, lPos.Y,
      lPos.Y + FCodeMemo.LineHeight, aSearch);
    case RMConfirmReplaceDialog.ShowModal of
      mrYes: Action := raReplace;
      mrYesToAll: Action := raReplaceAll;
      mrNo: Action := raSkip;
    else
      Action := raCancel;
    end;
  end;
end;

procedure TRMVirtualReportDesigner.OnCodeMemoStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  if scModified in Changes then
  begin
    Modified := True;
  end;

  if scSelection in Changes then
  begin
    ShowPosition;
  end;

  EnableControls;
end;

{$ELSE}

procedure TRMVirtualReportDesigner.DoSearchReplaceText(aReplace: Boolean;
  ABackwards: Boolean);
begin
  FindNext;
end;

procedure TRMVirtualReportDesigner.ShowSearchReplaceDialog(aReplace: Boolean);
begin
  if aReplace then
  begin
    FReplaceDialog.Execute;
  end
  else
  begin
    FFindDialog.FindText := FCodeMemo.GetWordOnCaret;
    FFindDialog.Execute;
  end;
end;

procedure TRMVirtualReportDesigner.OnCodeMemoSelectionChangeEvent(Sender: TObject);
begin
  ShowPosition;
  EnableControls;
end;

procedure TRMVirtualReportDesigner.FindDialog1Find(Sender: TObject);
begin
  FFindDialog.CloseDialog;
  FindNext;
end;

procedure TRMVirtualReportDesigner.ReplaceDialog1Find(Sender: TObject);
begin
  Replace_FindNext;
end;

procedure TRMVirtualReportDesigner.ReplaceDialog1Show(Sender: TObject);
begin
  FScriptCanReplace := False;
end;

procedure TRMVirtualReportDesigner.ReplaceDialog1Replace(Sender: TObject);
begin
  if frReplaceAll in FReplaceDialog.Options then
  begin
    if not FScriptCanReplace then
      Replace_FindNext;

    while FScriptCanReplace do
    begin
      FCodeMemo.SelText := FReplaceDialog.ReplaceText;
      Replace_FindNext;
    end;
  end
  else
  begin
    if not FScriptCanReplace then
      Replace_FindNext;

    if FScriptCanReplace then
    begin
      FCodeMemo.SelText := FReplaceDialog.ReplaceText;
      Replace_FindNext;
    end;
  end;
end;

procedure TRMVirtualReportDesigner.FindNext;
var
  lStr, lStr1: string;
  lPStr: PChar;
begin
  lStr := FCodeMemo.Lines.Text;
  lStr1 := FFindDialog.FindText;
  if not (frMatchCase in FFindDialog.Options) then
  begin
    lStr := ANSIUpperCase(lStr);
    lStr1 := ANSIUpperCase(lStr1);
  end;

  lPStr := StrPos(PChar(lStr) + FCodeMemo.SelStart, PChar(lStr1));
  if lPStr <> nil then
  begin
    FCodeMemo.SelStart := lPStr - PChar(lStr);
    FCodeMemo.SelLength := Length(lStr1);
  end;
end;

procedure TRMVirtualReportDesigner.Replace_FindNext;
var
  lStr, lStr1: string;
  lPStr: PChar;
begin
  FScriptCanReplace := False;
  lStr := FCodeMemo.Lines.Text;
  lStr1 := FReplaceDialog.FindText;
  if not (frMatchCase in FReplaceDialog.Options) then
  begin
    lStr := ANSIUpperCase(lStr);
    lStr1 := ANSIUpperCase(lStr1);
  end;

  lPStr := StrPos(PChar(lStr) + FCodeMemo.SelStart, PChar(lStr1));
  if lPStr <> nil then
  begin
    FCodeMemo.SelStart := lPStr - PChar(lStr);
    FCodeMemo.SelLength := Length(lStr1);
    FScriptCanReplace := True;
  end
  else
    FReplaceDialog.CloseDialog;
end;
{$ENDIF}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMCustomDesignerForm }

constructor TRMCustomDesignerForm.CreateNew(AOwner: TComponent; Dummy: Integer);
begin
  inherited CreateNew(nil, Dummy);
  //  FDesignerForm := TRMCustomDesignerForm(RMDesigner);

  FEditorForm := nil;

  FGridBitmap := TBitmap.Create;
  with FGridBitmap do
  begin
    Width := 8;
    Height := 8;
  end;

  FToolbarComponent := TRMToolbarComponent.Create(Self);
  FToolbarComponent.Parent := Self;
  FToolbarComponent.Align := alLeft;
end;

destructor TRMCustomDesignerForm.Destroy;
begin
  FreeAndNil(FEditorForm);
  FreeAndNil(FGridBitmap);
  inherited Destroy;
end;

function TRMCustomDesignerForm.EditorForm: TForm;
begin
  if FEditorForm = nil then
    FEditorForm := TRMEditorForm.Create(Application);
  Result := FEditorForm;
end;

procedure TRMCustomDesignerForm.SetRulerOffset;
begin
end;

procedure TRMCustomDesignerForm.RedrawPage;
begin
  if (Tab1 <> nil) and (Tab1.TabIndex <> 0) then
    FWorkSpace.Draw(10000, 0);
end;

procedure TRMCustomDesignerForm.ShowObjMsg;
begin
end;

procedure TRMCustomDesignerForm.GetRegion;
var
  i: Integer;
  t: TRMView;
  R: HRGN;
begin
  RM_ClipRgn := CreateRectRgn(0, 0, 0, 0);
  for i := 0 to THackPage(Page).Objects.Count - 1 do
  begin
    t := THackPage(Page).Objects[i];
    if t.Selected then
    begin
      R := t.GetClipRgn(rmrtExtended);
      CombineRgn(RM_ClipRgn, RM_ClipRgn, R, RGN_OR);
      DeleteObject(R);
    end;
  end;
  RM_FirstChange := False;
end;

function TRMCustomDesignerForm.RMCheckBand(b: TRMBandType): Boolean;
var
  i: Integer;
  t: TRMView;
begin
  Result := False;
  for i := 0 to THackPage(Page).Objects.Count - 1 do
  begin
    t := THackPage(Page).Objects[i];
    if t.IsBand then
    begin
      if b = TRMCustomBandView(t).BandType then
      begin
        Result := True;
        break;
      end;
    end;
  end;
end;

function TRMCustomDesignerForm.IsSubreport(PageN: Integer): TRMView;
var
  i, j: Integer;
  t: TRMView;
  liPage: THackPage;
begin
  Result := nil;
  with Report do
  begin
    for i := 0 to Pages.Count - 1 do
    begin
      liPage := THackPage(Pages[i]);
      for j := 0 to liPage.Objects.Count - 1 do
      begin
        t := liPage.Objects[j];
        if t.ObjectType = rmgtSubReport then
        begin
          if TRMSubReportView(t).SubPage = PageN then
          begin
            Result := t;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

procedure TRMCustomDesignerForm.GetDefaultSize(var aWidth, aHeight: Integer);
begin
  if GridSize = 18 then
    aWidth := 18 * 6
  else
    aWidth := 96;

  aHeight := 18;
  if (ToolbarComponent.ObjectBand <> nil) and ToolbarComponent.ObjectBand.Down then
    aWidth := FWorkSpace.Width;
end;

procedure TRMCustomDesignerForm.SendBandsToDown;
var
  i, j, n, k: Integer;
  t: TRMView;
begin
  n := THackPage(Page).Objects.Count;
  j := 0;
  i := n - 1;
  k := 0;
  while j < n do
  begin
    t := THackPage(Page).Objects[i];
    if t.IsBand then
    begin
      THackPage(Page).Objects.Delete(i);
      THackPage(Page).Objects.Insert(0, t);
      Inc(k);
    end
    else
      Dec(i);

    Inc(j);
  end;

  for i := 0 to n - 1 do // sends btOverlay to back
  begin
    t := THackPage(Page).Objects[i];
    if t.IsBand and (TRMCustomBandView(t).BandType = rmbtOverlay) then
    begin
      THackPage(Page).Objects.Delete(i);
      THackPage(Page).Objects.Insert(0, t);
      break;
    end;
  end;

  i := 0;
  j := 0;
  while j < n do // sends btColumnXXX to front
  begin
    t := THackPage(Page).Objects[i];
    if t.IsBand and (TRMCustomBandView(t).BandType in [rmbtCrossHeader..rmbtCrossFooter]) then
    begin
      THackPage(Page).Objects.Delete(i);
      THackPage(Page).Objects.Insert(k - 1, t);
    end
    else
      Inc(i);
    Inc(j);
  end;
end;

function TRMCustomDesignerForm.IsBandsSelect(var Band: TRMView): Boolean;
var
  i: Integer;
  t: TRMView;
begin
  Result := False;
  Band := nil;
  with THackPage(Page) do
  begin
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected and t.IsBand then
      begin
        Band := t;
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure TRMCustomDesignerForm.SetObjectID(t: TRMView);
begin
  THackView(t).ObjectID := ObjID;
  Inc(ObjID);
end;

function TRMCustomDesignerForm.TopSelected: Integer;
var
  i: Integer;
  lList: TList;
begin
  lList := PageObjects;
  Result := 0;
  for i := lList.Count - 1 downto 0 do
  begin
    if TRMView(lList[i]).Selected then
    begin
      Result := i;
      Exit;
    end;
  end;
end;

procedure TRMCustomDesignerForm.ShowEditor;
var
  t: TRMView;
begin
  t := PageObjects[TopSelected];

  if ((t.Restrictions * [rmrtDontModify]) <> []) or
    (DesignerRestrictions * [rmdrDontEditObj] <> []) then Exit;

  FWorkSpace.DrawPage(dmSelection);
  t.ShowEditor;
  FWorkSpace.Draw(TopSelected, t.GetClipRgn(rmrtExtended));

  ShowPosition;
  ShowContent;
end;

procedure TRMCustomDesignerForm.SetGridShow(Value: Boolean);
begin
  //  ToolbarStandard.GB1.Down := Value;
  if FShowGrid = Value then Exit;
  FShowGrid := Value;
  RedrawPage;
end;

procedure TRMCustomDesignerForm.SetGridAlign(Value: Boolean);
begin
  //  ToolbarStandard.GB2.Down := Value;
  if FGridAlign = Value then Exit;
  FGridAlign := Value;
end;

procedure TRMCustomDesignerForm.SetGridSize(Value: Integer);
begin
  if FGridSize = Value then Exit;
  FGridSize := Value;
  RedrawPage;
end;

function TRMCustomDesignerForm.PageSetup: Boolean;
var
  tmpForm: TRMPageSetupForm;
  lOldIndex: Integer;

  procedure _ChangeSubReportPaper;
  var
    i: Integer;
    t: TRMView;
    lPage: TRMReportPage;
  begin
    for i := 0 to THackPage(Page).Objects.Count - 1 do
    begin
      t := THackPage(Page).Objects[i];
      if t.ObjectType = rmgtSubReport then
      begin
        lPage := TRMReportPage(Report.Pages[TRMSubReportView(t).SubPage]);
        with TRMReportPage(Page) do
        begin
          lPage.ChangePaper(PageSize, PrinterInfo.PageWidth, PrinterInfo.PageHeight, PageBin, PageOrientation);
          lPage.mmMarginLeft := mmMarginLeft;
          lPage.mmMarginTop := mmMarginTop;
          lPage.mmMarginRight := mmMarginRight;
          lPage.mmMarginBottom := mmMarginBottom;
        end;
      end;
    end;
  end;

begin
  Result := False;
  if (not (Page is TRMReportPage)) or (IsSubReport(CurPage) <> nil) then
    Exit;

  ToolbarComponent.btnNoSelect.Click;
  lOldIndex := Report.ReportPrinter.PrinterIndex;
  tmpForm := TRMPageSetupForm.Create(nil);
  try
    with TRMReportPage(Page) do
    begin
      tmpForm.PageSetting.PrinterName := Report.PrinterName;
      tmpForm.PageSetting.Title := Report.ReportInfo.Title;
      tmpForm.PageSetting.DoublePass := Report.DoublePass;
      tmpForm.PageSetting.PrintbackgroundPicture := Report.PrintbackgroundPicture;
      tmpForm.PageSetting.ColorPrint := Report.ColorPrint;
      tmpForm.PageSetting.NewPageAfterPrint := Report.AutoSetPageLength;
      tmpForm.PageSetting.PrintToPrevPage := PrintToPrevPage;
      tmpForm.PageSetting.UnlimitedHeight := FUnlimitedHeight;
      tmpForm.PageSetting.MarginLeft := mmMarginLeft / 1000;
      tmpForm.PageSetting.MarginTop := mmMarginTop / 1000;
      tmpForm.PageSetting.MarginRight := mmMarginRight / 1000;
      tmpForm.PageSetting.MarginBottom := mmMarginBottom / 1000;
      tmpForm.PageSetting.PageOr := PageOrientation;
      tmpForm.PageSetting.PageWidth := PageWidth;
      tmpForm.PageSetting.PageHeight := PageHeight;
      tmpForm.PageSetting.PageBin := PageBin;
      tmpForm.PageSetting.PageSize := PageSize;
      tmpForm.PageSetting.ColGap := mmColumnGap / 1000;
      tmpForm.PageSetting.ColCount := ColumnCount;
      tmpForm.PageSetting.ConvertNulls := Report.ConvertNulls;
      if tmpForm.Execute then
      begin
        if lOldIndex <> tmpForm.cmbPrinterNames.ItemIndex then
        begin
          Report.ChangePrinter(Report.ReportPrinter.PrinterIndex, tmpForm.cmbPrinterNames.ItemIndex);
        end;

        mmColumnGap := Round(tmpForm.PageSetting.ColGap * 1000);
        ColumnCount := tmpForm.PageSetting.ColCount;
        mmMarginLeft := Round(tmpForm.PageSetting.MarginLeft * 1000);
        mmMarginTop := Round(tmpForm.PageSetting.MarginTop * 1000);
        mmMarginRight := Round(tmpForm.PageSetting.MarginRight * 1000);
        mmMarginBottom := Round(tmpForm.PageSetting.MarginBottom * 1000);

        Report.ReportInfo.Title := tmpForm.PageSetting.Title;
        Report.DoublePass := tmpForm.PageSetting.DoublePass;
        Report.PrintbackgroundPicture := tmpForm.PageSetting.PrintbackgroundPicture;
        Report.ColorPrint := tmpForm.PageSetting.ColorPrint;
        Report.AutoSetPageLength := tmpForm.PageSetting.NewPageAfterPrint;
        PrintToPrevPage := tmpForm.PageSetting.PrintToPrevPage;
        FUnlimitedHeight := tmpForm.PageSetting.UnlimitedHeight;
	      Report.ConvertNulls := tmpForm.PageSetting.ConvertNulls;

        ChangePaper(tmpForm.PageSetting.PageSize, tmpForm.PageSetting.PageWidth,
          tmpForm.PageSetting.PageHeight, tmpForm.PageSetting.PageBin, tmpForm.PageSetting.PageOr);
        CurPage := CurPage; // for repaint and other

        _ChangeSubReportPaper;
        Modified := True;
        Result := True;
      end;
    end;
  finally
    tmpForm.Free;
  end;
end;

initialization
  CF_REPORTMACHINE := RegisterClipboardFormat('WHF_ReportMachine');

end.

