unit RM_DsgGridReport;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Menus, Commctrl, Clipbrd, Buttons,
  RM_Class, RM_Preview, RM_Common, RM_DsgCtrls, RM_Ctrls, RM_Insp, RM_EditorInsField,
  RM_GridReport, RM_Grid, RM_DsgForm, rm_ZlibEx
  {$IFDEF USE_TB2K}
  , TB2Item, TB2Dock, TB2Toolbar
  {$ELSE}
  {$IFDEF USE_INTERNALTB97}
  , RM_TB97Ctls, RM_TB97Tlbr, RM_TB97
  {$ELSE}
  , TB97Ctls, TB97Tlbr, TB97
  {$ENDIF}
  {$ENDIF}
  {$IFDEF Delphi4}, ImgList{$ENDIF}
  {$IFDEF Delphi6}, Variants{$ENDIF};

const
  MaxUndoBuffer = 100;

type

  TRMGridReportLoadReportEvent = procedure(Report: TRMReport; var ReportName: string; var Opened: Boolean) of object;
  TRMGridReportSaveReportEvent = procedure(Report: TRMReport; var ReportName: string; SaveAs: Boolean; var Saved: Boolean) of object;
  TRMGridReportNewReportEvent = procedure(Report: TRMReport; var ReportName: string) of object;

  TRMUndoObject = record
    ObjID: Integer;
  end;

  TRMUndoObject1 = record
    Row, Col: Integer;
  end;

  TRMUndoRec = record
    Action: TRMUndoAction;
    Page: Integer;
    Stream: TMemoryStream;
    Objects: array of TRMUndoObject;
    Objects1: array of TRMUndoObject1;
  end;
  PRMUndoRec = ^TRMUndoRec;

  TRMUndoBuffer = array[0..MaxUndoBuffer - 1] of TRMUndoRec;
  PRMUndoBuffer = ^TRMUndoBuffer;

  TRMSelectionType = (rmssMemo, rmssOther, rmssMultiple);
  TRMSelectionStatus = set of TRMSelectionType;

  { TRMGridReportDesigner }
  TRMGridReportDesigner = class(TRMCustomDesigner) // fake component
  private
    FOpenFileCount: Integer;
    FTemplDir, FOpenDir, FSaveDir: string;
    FDesignerRestrictions: TRMDesignerRestrictions;
    FDefaultDictionaryFile: string;
    FUseUndoRedo: Boolean;

    procedure SetOpenFileCount(Value: Integer);
    procedure SetDesignerRestrictions(Value: TRMDesignerRestrictions);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OpenFileCount: Integer read FOpenFileCount write SetOpenFileCount default 4;
    property OpenDir: string read FOpenDir write FOpenDir;
    property SaveDir: string read FSaveDir write FSaveDir;
    property TemplateDir: string read FTemplDir write FTemplDir;
    property DesignerRestrictions: TRMDesignerRestrictions read FDesignerRestrictions write SetDesignerRestrictions;
    property DefaultDictionaryFile: string read FDefaultDictionaryFile write FDefaultDictionaryFile;
    property UseUndoRedo: Boolean read FUseUndoRedo write FUseUndoRedo default True;
  end;

  TRMGridReportDesignerForm = class;

  { TRMToolbarStandard }
  TRMToolbarStandard = class(TRMToolbar)
  private
    FDesignerForm: TRMGridReportDesignerForm;
    BtnFileNew: TRMToolbarButton;
    btnFileSave: TRMToolbarButton;
    {$IFDEF USE_TB2K}
    btnFileOpen: TRMSubmenuItem;
    {$ELSE}
    btnFileOpen: TRMToolbarButton;
    {$ENDIF}
    ToolbarSep971: TRMToolbarSep;

    btnPreview1: TRMToolbarButton;
    btnPreview: TRMToolbarButton;
    btnPrint: TRMToolbarButton;
    ToolbarSep972: TRMToolbarSep;

    btnCut: TRMToolbarButton;
    btnCopy: TRMToolbarButton;
    btnPaste: TRMToolbarButton;
    ToolbarSep974: TRMToolbarSep;

    btnRedo: TRMToolbarButton;
    btnUndo: TRMToolbarButton;
    ToolbarSep2: TRMToolbarSep;

    btnAddPage: TRMToolbarButton;
    btnAddForm: TRMToolbarButton;
    btnDeletePage: TRMToolbarButton;
    btnPageSetup: TRMToolbarButton;
    ToolbarSep973: TRMToolbarSep;

    btnExit: TRMToolbarButton;

    procedure Localize;
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMToolbarEdit }
  TRMToolbarEdit = class(TRMToolbar)
  private
    FDesignerForm: TRMGridReportDesignerForm;
    FcmbFont: TRMFontComboBox;
    FcmbFontSize: TRMComboBox97;
    ToolbarSep971: TRMToolbarSep;

    btnFontBold: TRMToolbarButton;
    btnFontItalic: TRMToolbarButton;
    btnFontUnderline: TRMToolbarButton;
    ToolbarSep972: TRMToolbarSep;

    FBtnFontColor: TRMColorPickerButton;
    FBtnBackColor: TRMColorPickerButton;
    FBtnFrameColor: TRMColorPickerButton;
    FCmbFrameWidth: TRMComboBox97;
    ToolbarSep973: TRMToolbarSep;

    btnHLeft: TRMToolbarButton;
    btnHCenter: TRMToolbarButton;
    btnHRight: TRMToolbarButton;
    btnHSpaceEqual: TRMToolbarButton;
    ToolbarSep974: TRMToolbarSep;

    btnVTop: TRMToolbarButton;
    btnVCenter: TRMToolbarButton;
    btnVBottom: TRMToolbarButton;
    ToolbarSep975: TRMToolbarSep;

    procedure Localize;
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMToolbarBorder }
  TRMToolbarBorder = class(TRMToolbar)
  private
    FDesignerForm: TRMGridReportDesignerForm;
    btnFrameTop: TRMToolbarButton;
    btnFrameLeft: TRMToolbarButton;
    btnFrameBottom: TRMToolbarButton;
    btnFrameRight: TRMToolbarButton;
    ToolbarSep971: TRMToolbarSep;

    btnNoBorder: TRMToolbarButton;
    btnSetBorder: TRMToolbarButton;
    btnTopBorder: TRMToolbarButton;
    btnBottomBorder: TRMToolbarButton;
    ToolbarSep972: TRMToolbarSep;

    btnBias1Border: TRMToolbarButton;
    btnBias2Border: TRMToolbarButton;
    ToolbarSep973: TRMToolbarSep;

    btnDecWidth: TRMToolbarButton;
    btnIncWidth: TRMToolbarButton;
    btnDecHeight: TRMToolbarButton;
    btnIncHeight: TRMToolbarButton;
    ToolbarSep974: TRMToolbarSep;

    btnColumnMin: TRMToolbarButton;
    btnColumnMax: TRMToolbarButton;
    btnRowMin: TRMToolbarButton;
    btnRowMax: TRMToolbarButton;
    ToolbarSep975: TRMToolbarSep;

    cmbBands: TRMComboBox97;
    {$IFDEF USE_TB2K}
    btnAddBand: TRMSubmenuItem;
    {$ELSE}
    btnAddBand: TRMToolbarButton;
    {$ENDIF}
    btnDeleteBand: TRMToolbarButton;

    procedure Localize;
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMToolbarGrid }
  TRMToolbarGrid = class(TRMToolbar)
  private
    FDesignerForm: TRMGridReportDesignerForm;
    btnInsertColumn: TRMToolbarButton;
    btnInsertRow: TRMToolbarButton;
    btnAddColumn: TRMToolbarButton;
    btnAddRow: TRMToolbarButton;
    ToolbarSep1: TRMToolbarSep;

    btnDeleteColumn: TRMToolbarButton;
    btnDeleteRow: TRMToolbarButton;
    btnSetRowsAndColumns: TRMToolbarButton;
    ToolbarSep2: TRMToolbarSep;

    btnMerge: TRMToolbarButton;
    btnSplit: TRMToolbarButton;
    btnMergeRow: TRMToolbarButton;
    btnMergeColumn: TRMToolbarButton;

    procedure Localize;
    procedure OnAddColumnClick(Sender: TObject);
    procedure OnAddRowClick(Sender: TObject);
    procedure OnMergeColumnClick(Sender: TObject);
    procedure OnMergeRowClick(Sender: TObject);
    procedure OnBtnSetRowsAndColumnsClick(Sender: TObject);
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMToolbarCellEdit }
  TRMToolbarCellEdit = class(TRMToolbar)
  private
    FDesignerForm: TRMGridReportDesignerForm;

    FlblCell: TRMToolbarButton;
    FToolbarSep1: TRMToolbarSep;

    FBtnDBField: TRMToolbarButton;
    FBtnExpression: TRMToolbarButton;
    FEdtMemo: TEdit;

    procedure Localize;
    procedure CellEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMGridViewForm }
  TRMGridReportDesignerForm = class(TRMCustomDesignerForm)
    ImageListFont: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ImageListFrame: TImageList;
    StatusBar1: TStatusBar;
    ImageListGrid: TImageList;
    ImageListStand: TImageList;
    ImageListSize: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnMergeClick(Sender: TObject);
    procedure btnSplitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure itmMemoViewClick(Sender: TObject);
    procedure itmDeleteColumnClick(Sender: TObject);
    procedure itmDeleteRowClick(Sender: TObject);
    procedure itmInsertLeftColumnClick(Sender: TObject);
    procedure itmInsertRightColumnClick(Sender: TObject);
    procedure itmInsertTopRowClick(Sender: TObject);
    procedure itmInsertBottomRowClick(Sender: TObject);
    procedure itmEditClick(Sender: TObject);
    procedure itmFrameTypeClick(Sender: TObject);
    procedure MenuFileSaveasClick(Sender: TObject);
    procedure MenuFileOpenClick(Sender: TObject);
    procedure MenuFileSaveClick(Sender: TObject);
    procedure Tab1Change(Sender: TObject);
    procedure MenuFileDictClick(Sender: TObject);
    procedure MenuFileImportDictClick(Sender: TObject);
    procedure MenuFileMergeDictClick(Sender: TObject);
    procedure MenuFileExportDictClick(Sender: TObject);
    procedure MenuFilePageSetupClick(Sender: TObject);
    procedure MenuFileHeaderFooterClick(Sender: TObject);
    procedure MenuFilePreviewClick(Sender: TObject);
    procedure MenuFilePreview1Click(Sender: TObject);
    procedure MenuFilePrintClick(Sender: TObject);
    procedure MenuFilePropClick(Sender: TObject);
    procedure MenuFileNewClick(Sender: TObject);
    procedure btnFileNewClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnAddPageClick(Sender: TObject);
    procedure btnDeletePageClick(Sender: TObject);
    procedure Tab1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Tab1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Tab1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Tab1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Tab1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cmbBandsDropDown(Sender: TObject);
    procedure cmbBandsClick(Sender: TObject);
    procedure btnDeleteBandClick(Sender: TObject);
    procedure PopupMenuBandsPopup(Sender: TObject);
    procedure MenuFileExitClick(Sender: TObject);
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MenuEditToolbarClick(Sender: TObject);
    procedure itmToolbarStandardClick(Sender: TObject);
    procedure MenuEditAddFormClick(Sender: TObject);
    procedure MenuEditCutClick(Sender: TObject);
    procedure MenuEditCopyClick(Sender: TObject);
    procedure MenuEditPasteClick(Sender: TObject);
    procedure MenuEditDeleteClick(Sender: TObject);
    procedure MenuEditSelectAllClick(Sender: TObject);
    procedure padpopEditClick(Sender: TObject);
    procedure padpopClearContentsClick(Sender: TObject);
    procedure MenuCellPropertyClick(Sender: TObject);
    procedure MenuCellTableSizeClick(Sender: TObject);
    procedure itmAverageRowHeightClick(Sender: TObject);
    procedure itmAverageColumnWidthClick(Sender: TObject);
    procedure itmRowHeightClick(Sender: TObject);
    procedure itmColumnHeightClick(Sender: TObject);
    procedure MenuEditUndoClick(Sender: TObject);
    procedure MenuEditRedoClick(Sender: TObject);
    procedure MenuFileFile9Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MenuEditCopyPageClick(Sender: TObject);
    procedure MenuEditPastePageClick(Sender: TObject);
    procedure MenuEditOptionsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FList: TList;
    FFileName: string;
    FGrid: TRMGridEx;
    FAddinObjects: TStringList;
    FBusy, FInspBusy: Boolean;
    FCurDocName, FCaption: string;
    FMouseDown: Boolean;
    FInspForm: TRMInspForm;
    FAutoOpenLastFile: Boolean;
    FOpenFiles: TStringList;
    FPageStream: TMemoryStream;

    Dock971: TRMDock;
    Dock972: TRMDock;
    Dock973: TRMDock;
    Dock974: TRMDock;

    //dejoy add begin
    Panel2: TRMPanel;

    MenuBar: TRMMenuBar;
    MenuFile: TRMSubmenuItem;
    MenuFileNew: TRMmenuItem;
    MenuFileOpen: TRMmenuItem;
    MenuFileSave: TRMmenuItem;
    MenuFileSaveas: TRMmenuItem;
    N2: TRMSeparatorMenuItem;
    MenuFileDict: TRMmenuItem;
    MenuFileImportDict: TRMmenuItem;
    MenuFileMergeDict: TRMmenuItem;
    MenuFileExportDict: TRMmenuItem;
    N1: TRMSeparatorMenuItem;
    MenuFilePageSetup: TRMmenuItem;
    MenuFileHeaderFooter: TRMMenuItem;
    MenuFilePreview: TRMmenuItem;
    MenuFilePreview1: TRMMenuItem;
    MenuFilePrint: TRMmenuItem;
    N7: TRMSeparatorMenuItem;
    MenuFileProp: TRMmenuItem;
    N13: TRMSeparatorMenuItem;
    MenuFileFile1: TRMmenuItem;
    MenuFileFile2: TRMmenuItem;
    MenuFileFile3: TRMmenuItem;
    MenuFileFile4: TRMmenuItem;
    MenuFileFile5: TRMmenuItem;
    MenuFileFile6: TRMmenuItem;
    MenuFileFile7: TRMmenuItem;
    MenuFileFile8: TRMmenuItem;
    MenuFileFile9: TRMmenuItem;
    N5: TRMSeparatorMenuItem;
    MenuFileExit: TRMmenuItem;
    MenuEdit: TRMSubmenuItem;
    MenuEditUndo: TRMmenuItem;
    MenuEditRedo: TRMmenuItem;
    N12: TRMSeparatorMenuItem;
    MenuEditCut: TRMmenuItem;
    MenuEditCopy: TRMmenuItem;
    MenuEditPaste: TRMmenuItem;
    MenuEditDelete: TRMmenuItem;
    MenuEditSelectAll: TRMmenuItem;
    N11: TRMSeparatorMenuItem;
    MenuEditCopyPage: TRMmenuItem;
    MenuEditPastePage: TRMmenuItem;
    N14: TRMSeparatorMenuItem;
    MenuEditAddPage: TRMmenuItem;
    MenuEditAddForm: TRMmenuItem;
    MenuEditDeletePage: TRMmenuItem;
    N9: TRMSeparatorMenuItem;

    MenuEditToolbar: TRMSubmenuItem;
    itmToolbarStandard: TRMmenuItem;
    itmToolbarText: TRMmenuItem;
    itmToolbarBorder: TRMmenuItem;
    itmToolbarGrid: TRMmenuItem;
    itmToolbarInspector: TRMmenuItem;
    itmToolbarInsField: TRMmenuItem;
    itmToolbarCellEdit: TRMMenuItem;

    MenuEditOptions: TRMmenuItem;
    MenuCell: TRMSubmenuItem;
    MenuCellProperty: TRMmenuItem;
    MenuCellTableSize: TRMmenuItem;
    MenuCellRow: TRMSubmenuItem;
    itmRowHeight: TRMmenuItem;
    itmAverageRowHeight: TRMmenuItem;
    MenuCellColumn: TRMSubmenuItem;
    itmColumnHeight: TRMmenuItem;
    itmAverageColumnWidth: TRMmenuItem;
    N8: TRMSeparatorMenuItem;
    MenuCellInsertCell: TRMSubmenuItem;
    itmInsertCellLeft: TRMmenuItem;
    itmInsertCellTop: TRMmenuItem;
    MenuCellInsertColumn: TRMmenuItem;
    MenuCellInsertRow: TRMmenuItem;
    MenuCellDeleteColumn: TRMmenuItem;
    MenuCellDeleteRow: TRMmenuItem;
    N18: TRMSeparatorMenuItem;
    MenuEditMerge: TRMmenuItem;
    MenuEditReverse: TRMmenuItem;
    MenuHelp: TRMSubmenuItem;
    MenuHelpContents: TRMmenuItem;
    N1111: TRMSeparatorMenuItem;
    MenuHelpAbout: TRMmenuItem;

    barSearch: TRMSubmenuItem;
    padSearchFind: TRMMenuItem;
    padSearchReplace: TRMMenuItem;
    padSearchFindAgain: TRMMenuItem;

    // PopMenu
    SelectionMenu: TRMPopupMenu;
    PopupMenu1: TRMPopupMenu;
    PopupMenuBands: TRMPopupMenu;

    itmGridMenuBandProp: TRMMenuItem;
    itmCellProp: TRMMenuItem;
//    itmSplit1: TRMSeparatorMenuItem;
    itmMergeCells: TRMMenuItem;
    itmSplitCells: TRMMenuItem;
    N3: TRMSeparatorMenuItem;
    itmInsert: TRMSubmenuItem;
    itmInsertLeftColumn: TRMMenuItem;
    itmInsertRightColumn: TRMMenuItem;
    N10: TRMSeparatorMenuItem;
    itmInsertTopRow: TRMMenuItem;
    itmInsertBottomRow: TRMMenuItem;
    itmSep1: TRMSeparatorMenuItem;
    itmInsertLeftCell: TRMMenuItem;
    itmInsertTopCell: TRMMenuItem;
    itmDelete: TRMSubmenuItem;
    itmDeleteColumn: TRMMenuItem;
    itmDeleteRow: TRMMenuItem;
    itmDeleteSep1: TRMSeparatorMenuItem;
    itmDeleteLeftCell: TRMMenuItem;
    itmDeleteTopCell: TRMMenuItem;
    N6: TRMSeparatorMenuItem;
    itmCellType: TRMSubmenuItem;
    itmMemoView: TRMMenuItem;
    itmCalcMemoView: TRMMenuItem;
    itmPictureView: TRMMenuItem;
    itmSubReportView: TRMMenuItem;
    itmInsertBand: TRMSubmenuItem;
    itmSelectBand: TRMSubmenuItem;
    N4: TRMSeparatorMenuItem;
    itmFrameType: TRMMenuItem;
    itmEdit: TRMMenuItem;
    padpopClearContents: TRMMenuItem;
    padpopOtherProp: TRMMenuItem;
    N100: TRMSeparatorMenuItem;
    SelectionMenu_popCut: TRMMenuItem;
    SelectionMenu_popCopy: TRMMenuItem;
    SelectionMenu_popPaste: TRMMenuItem;
//    N101: TRMSeparatorMenuItem;
    N102: TRMSeparatorMenuItem;

    Popup1: TRMPopupMenu;
    padpopCut: TRMMenuItem;
    padpopCopy: TRMMenuItem;
    padpopPaste: TRMMenuItem;
    padpopDelete: TRMMenuItem;
    padpopSelectAll: TRMMenuItem;
    MenuItem1: TRMSeparatorMenuItem;
    padpopEdit: TRMMenuItem;

    // ToolbarPopMenu
    ToolbarPopMenu: TRMPopupMenu;

    ToolbarPopStandard: TRMMenuItem;
    ToolbarPopEdit: TRMMenuItem;
    ToolbarPopBorder: TRMMenuItem;
    ToolbarPopInsp: TRMMenuItem;
    ToolbarPopInsDBField: TRMMenuItem;
    ToolbarPopGrid: TRMMenuItem;
    ToolbarPopCellEdit: TRMMenuItem;

    //dejoy add end
    ToolbarStandard: TRMToolbarStandard;
    ToolbarEdit: TRMToolbarEdit;
    ToolbarBorder: TRMToolbarBorder;
    ToolbarGrid: TRMToolbarGrid;
    ToolbarCellEdit: TRMToolbarCellEdit;

    FUndoBusy: Boolean;
    FUndoBuffer, FRedoBuffer: TRMUndoBuffer;
    FUndoBufferLength, FRedoBufferLength: Integer;

    procedure padSearchFindClick(Sender: TObject);
    procedure padSearchReplaceClick(Sender: TObject);
    procedure padSearchFindAgainClick(Sender: TObject);
    //    procedure FindNext;
    //    procedure Replace_FindNext;

    procedure ToolBarPopMenuPopup(Sender: TObject);
    procedure itmInsertLeftCellClick(Sender: TObject);
    procedure itmInsertTopCellClick(Sender: TObject);
    procedure itmDeleteLeftCellClick(Sender: TObject);
    procedure itmDeleteTopCellClick(Sender: TObject);

    procedure SetObjectsID;
    procedure ClearUndoBuffer;
    procedure ClearRedoBuffer;
    procedure ReleaseAction(aActionRec: PRMUndoRec);
    procedure AddAction(aBuffer: PRMUndoBuffer; aAction: TRMUndoAction; aObject: TObject; aRec: PRMUndoRec);
    procedure Undo(aBuffer: PRMUndoBuffer);

    procedure btnColumnMinClick(Sender: TObject);
    procedure btnColumnMaxClick(Sender: TObject);
    procedure btnRowMinClick(Sender: TObject);
    procedure btnRowMaxClick(Sender: TObject);
    procedure btnDBFieldClick(Sender: TObject);
    procedure btnExpressionClick(Sender: TObject);
    procedure DoClick(Sender: TObject);

    function HaveBand(aBandType: TRMBandType): Boolean;
    procedure SetGridProp;
    procedure SetGridNilProp;
    procedure RefreshProp;
    procedure Localize;
    procedure SaveIni;
    procedure LoadIni;
    procedure Pan5Click(Sender: TObject);
    procedure OnDockRequestDockEvent(Sender: TObject; Bar: TRMCustomDockableWindow; var Accept: Boolean);

    procedure SelectObject(aObjName: string);
    procedure OnInspBeforeModify(Sender: TObject; const aPropName: string);
    procedure OnInspAfterModify(Sender: TObject; const aPropName, aPropValue: string);
    procedure InspSelectionChanged(ObjName: string);
    procedure InspGetObjects(aList: TStrings);
    procedure FillInspFields;
    procedure SetGridHeader;
    procedure OnGridDblClickEvent(Sender: TObject);
    procedure OnGridClick(Sender: TObject);
    procedure OnGridChange(Sender: TObject);
    procedure OnGridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure OnGridDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure OnGridRowHeaderClick(Sender: TObject);
    procedure OnGridRowHeaderDblClick(Sender: TObject);
    procedure OnGridBeginSizingCell(Sender: TObject);
    procedure OnGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnGridBeforeChangeCell(aGrid: TRMGridEx; aCell: TRMCellInfo);
    procedure Popup1Popup(Sender: TObject);
    procedure SelectionMenuPopup(Sender: TObject);
    procedure itmGridMenuBandClick(Sender: TObject);
    procedure OnAddBandEvent(Sender: TObject);

    function _GetSelectionStatus: TRMSelectionStatus;
    function _DelEnabled: Boolean;
    function _CutEnabled: Boolean;
    function _CopyEnabled: Boolean;
    function _PasteEnabled: Boolean;
    procedure OpenFile(aFileName: string);
    function FileSave: Boolean;
    function FileSaveAs: Boolean;
    procedure SetOpenFileMenuItems(const aNewFile: string);

    function GetScript: TStrings;
    procedure SetScript(Value: TStrings);
    procedure SetCurDocName(Value: string);
    function GetUnitType: TRMUnitType;
    procedure SetUnitType(aValue: TRMUnitType);
  protected
    procedure EnableControls; override;
    procedure ShowPosition; override;
    procedure DoFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;

    function GetModified: Boolean; override;
    procedure SetModified(Value: Boolean); override;
    procedure SetFactor(Value: Integer); override;
    function GetDesignerRestrictions: TRMDesignerRestrictions; override;
    procedure SetDesignerRestrictions(Value: TRMDesignerRestrictions); override;
    procedure SetCurPage(Value: Integer); override;
    procedure RefreshData; override;
  public
    { Public declarations }
    procedure BeforeChange; override;
    procedure AfterChange; override;
    function InsertDBField: string; override;
    function InsertExpression: string; override;
    procedure MemoViewEditor(t: TRMView); override;
    procedure RMFontEditor(Sender: TObject); override;
    procedure RMDisplayFormatEditor(Sender: TObject); override;
    procedure PictureViewEditor(t: TRMView); override;
    procedure RMCalcMemoEditor(Sender: TObject); override;
    function PageObjects: TList; override;
    procedure AddUndoAction(aAction: TRMUndoAction); override;

    procedure UnSelectAll; override;
    procedure SelectionChanged(aRefreshInspProp: Boolean); override;
    procedure SetPageTabs; override;
    procedure ResetSelection; override;
    procedure ShowContent; override;

    property Script: TStrings read GetScript write SetScript;
    property CurDocName: string read FCurDocName write SetCurDocName;
    property AutoOpenLastFile: Boolean read FAutoOpenLastFile write FAutoOpenLastFile;
    property UnitType: TRMUnitType read GetUnitType write SetUnitType;
  end;

implementation

{$R *.DFM}

uses
  Math, Registry, RM_Const, RM_Const1, RM_Utils, RM_PageSetup, RM_EditorMemo,
  RM_EditorPicture, RM_EditorHilit, RM_EditorFrame, RM_EditorField, RM_EditorExpr,
  RM_EditorReportProp, RM_Printer, RM_About, RM_EditorFormat,
  RM_EditorDictionary, RM_EditorCalc, RM_EditorGroup, RM_EditorCellProp, RM_EditorGridCols,
  RM_EditorCellWidth, RM_EditorBand, RM_DesignerOptions, RM_EditorHF,
  RM_Wizard, RM_WizardNewReport, RM_wzGridStd;

const
  AddInObjectOffset = 4;

  TAG_SetFrameTop = 1;
  TAG_SetFrameLeft = 2;
  TAG_SetFrameBottom = 3;
  TAG_SetFrameRight = 4;
  TAG_BackColor = 5;
  TAG_FrameStyle = 6;

  TAG_SetFontName = 7;
  TAG_SetFontSize = 8;

  TAG_FontBold = 9;
  TAG_FontItalic = 10;
  TAG_FontUnderline = 11;

  TAG_HAlignLeft = 12;
  TAG_HAlignCenter = 13;
  TAG_HAlignRight = 14;
  TAG_HAlignEuqal = 15;

  TAG_FrameSize = 16;
  TAG_FontColor = 17;
  TAG_FrameColor = 19;

  TAG_SetFrame = 20;
  TAG_NoFrame = 21;
  TAG_Frame1 = 22;
  TAG_Frame2 = 23;
  TAG_Frame3 = 24;
  TAG_Frame4 = 25;
  TAG_DecWidth = 26;
  TAG_IncWidth = 27;
  TAG_DecHeight = 28;
  TAG_IncHeight = 29;

  TAG_VAlignTop = 31;
  TAG_VAlignCenter = 32;
  TAG_VAlignBottom = 33;

type
  THackView = class(TRMView)
  end;

  THackReportView = class(TRMReportView)
  end;

  THackPage = class(TRMCustomPage)
  end;

  THackGridEx = class(TRMGridEx)
  end;

var
  FDesignerComp: TRMGridReportDesigner;
  FUnitType: TRMUnitType;

  {------------------------------------------------------------------------------}
  {------------------------------------------------------------------------------}
  { TRMToolbarStandard }

constructor TRMToolbarStandard.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
begin
  inherited Create(AOwner);
  BeginUpdate;
  Dockedto := DockTo;
  FDesignerForm := TRMGridReportDesignerForm(AOwner);
  DockRow := 0;
  DockPos := 0;
  Name := 'GridReport_ToolbarStandard';
  CloseButton := False;

  btnFileNew := TRMToolbarButton.Create(Self);
  with btnFileNew do
  begin
    ShowHint := True;
    ImageIndex := 0;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnFileNewClick;
    AddTo := Self;
  end;
  {$IFDEF USE_TB2K}
  btnFileOpen := TRMSubmenuItem.Create(Self);
  {$ELSE}
  btnFileOpen := TRMToolbarButton.Create(Self);
  {$ENDIF}
  with btnFileOpen do
  begin
    ImageIndex := 1;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuFileOpenClick;
    AddTo := Self;
    DropdownCombo := True;
    {$IFNDEF USE_TB2k}
    DropdownMenu := FDesignerForm.PopupMenu1;
    {$ENDIF}
  end;
  btnFileSave := TRMToolbarButton.Create(Self);
  with btnFileSave do
  begin
    ImageIndex := 2;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuFileSaveClick;
    AddTo := Self;
  end;
  ToolbarSep971 := TRMToolbarSep.Create(Self);
  with ToolbarSep971 do
  begin
    AddTo := Self;
  end;

  btnPrint := TRMToolbarButton.Create(Self);
  with btnPrint do
  begin
    ImageIndex := 3;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuFilePrintClick;
    AddTo := Self;
  end;
  btnPreview := TRMToolbarButton.Create(Self);
  with btnPreview do
  begin
    ImageIndex := 4;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuFilePreviewClick;
    AddTo := Self;
  end;
  btnPreview1 := TRMToolbarButton.Create(Self);
  with btnPreview1 do
  begin
    ImageIndex := 29;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuFilePreview1Click;
    AddTo := Self;
  end;
  ToolbarSep972 := TRMToolbarSep.Create(Self);
  with ToolbarSep972 do
  begin
    AddTo := Self;
  end;

  btnCut := TRMToolbarButton.Create(Self);
  with btnCut do
  begin
    ImageIndex := 5;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuEditCutClick;
    AddTo := Self;
  end;
  btnCopy := TRMToolbarButton.Create(Self);
  with btnCopy do
  begin
    ImageIndex := 6;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuEditCopyClick;
    AddTo := Self;
  end;
  btnPaste := TRMToolbarButton.Create(Self);
  with btnPaste do
  begin
    ImageIndex := 7;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuEditPasteClick;
    AddTo := Self;
  end;
  ToolbarSep974 := TRMToolbarSep.Create(Self);
  with ToolbarSep974 do
  begin
    AddTo := Self;
  end;

  btnRedo := TRMToolbarButton.Create(Self);
  with btnRedo do
  begin
    ImageIndex := 9;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuEditRedoClick;
    AddTo := Self;
  end;
  btnUndo := TRMToolbarButton.Create(Self);
  with btnUndo do
  begin
    ImageIndex := 8;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuEditUndoClick;
    AddTo := Self;
  end;
  ToolbarSep2 := TRMToolbarSep.Create(Self);
  with ToolbarSep2 do
  begin
    AddTo := Self;
  end;

  btnAddPage := TRMToolbarButton.Create(Self);
  with btnAddPage do
  begin
    ImageIndex := 13;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnAddPageClick;
    AddTo := Self;
  end;
  btnAddForm := TRMToolbarButton.Create(Self);
  with btnAddForm do
  begin
    ImageIndex := 14;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuEditAddFormClick;
    AddTo := Self;
  end;
  btnDeletePage := TRMToolbarButton.Create(Self);
  with btnDeletePage do
  begin
    ImageIndex := 15;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnDeletePageClick;
    AddTo := Self;
  end;
  btnPageSetup := TRMToolbarButton.Create(Self);
  with btnPageSetup do
  begin
    ImageIndex := 16;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuFilePageSetupClick;
    AddTo := Self;
  end;
  ToolbarSep973 := TRMToolbarSep.Create(Self);
  with ToolbarSep973 do
  begin
    AddTo := Self;
  end;

  btnExit := TRMToolbarButton.Create(Self);
  with btnExit do
  begin
    ImageIndex := 20;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.MenuFileExitClick;
    AddTo := Self;
  end;
  Self.EndUpdate;

  Localize;
end;

procedure TRMToolbarStandard.Localize;
begin
  RMSetStrProp(Self, 'Caption', rmRes + 081);
  RMSetStrProp(btnFileNew, 'Hint', rmRes + 087);
  RMSetStrProp(btnFileOpen, 'Hint', rmRes + 088);
  RMSetStrProp(btnFileSave, 'Hint', rmRes + 089);
  RMSetStrProp(btnPreview1, 'Hint', rmRes + 877);
  RMSetStrProp(btnPreview, 'Hint', rmRes + 090);
  RMSetStrProp(btnPrint, 'Hint', rmRes + 159);
  RMSetStrProp(btnCut, 'Hint', rmRes + 091);
  RMSetStrProp(btnCopy, 'Hint', rmRes + 092);
  RMSetStrProp(btnPaste, 'Hint', rmRes + 093);
  RMSetStrProp(btnAddPage, 'Hint', rmRes + 099);
  RMSetStrProp(btnAddForm, 'Hint', rmRes + 193);
  RMSetStrProp(btnDeletePage, 'Hint', rmRes + 100);
  RMSetStrProp(btnPageSetup, 'Hint', rmRes + 101);
  RMSetStrProp(btnExit, 'Hint', rmRes + 106);
  RMSetStrProp(btnUndo, 'Hint', rmRes + 094);
  RMSetStrProp(btnRedo, 'Hint', rmRes + 095);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarEdit }

constructor TRMToolbarEdit.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
var
  i, liOffset: Integer;
begin
  inherited Create(AOwner);
  BeginUpdate;
  Dockedto := DockTo;
  FDesignerForm := TRMGridReportDesignerForm(AOwner);
  DockRow := 1;
  DockPos := 0;
  Name := 'GridReport_ToolbarEdit';
  CloseButton := False;

  FcmbFont := TRMFontComboBox.Create(Self);
  with FcmbFont do
  begin
    Parent := Self;
    Height := 21;
    Width := 120;
    //      Device := rmfdBoth;
    TrueTypeOnly := True;
    Tag := TAG_SetFontName;
    OnChange := FDesignerForm.DoClick;
  end;
  FcmbFontSize := TRMComboBox97 {TComboBox}.Create(Self);
  with FcmbFontSize do
  begin
    Parent := Self;
    Height := 21;
    Width := 50;
    DropDownCount := 12;
    if RMIsChineseGB then
      liOffset := 0
    else
      liOffset := 13;
    for i := Low(RMDefaultFontSizeStr) + liOffset to High(RMDefaultFontSizeStr) do
      Items.Add(RMDefaultFontSizeStr[i]);
    Tag := TAG_SetFontSize;
    OnChange := FDesignerForm.DoClick;
  end;
  ToolbarSep971 := TRMToolbarSep.Create(Self);
  with ToolbarSep971 do
  begin
    AddTo := Self;
  end;

  btnFontBold := TRMToolbarButton.Create(Self);
  with btnFontBold do
  begin
    Tag := 0;
    AllowAllUp := True;
    GroupIndex := 1;
    ImageIndex := 0;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_FontBold;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnFontItalic := TRMToolbarButton.Create(Self);
  with btnFontItalic do
  begin
    Tag := 1;
    AllowAllUp := True;
    GroupIndex := 2;
    ImageIndex := 1;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_FontItalic;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnFontUnderline := TRMToolbarButton.Create(Self);
  with btnFontUnderline do
  begin
    Tag := 2;
    AllowAllUp := True;
    GroupIndex := 3;
    ImageIndex := 2;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_FontUnderline;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  ToolbarSep972 := TRMToolbarSep.Create(Self);
  with ToolbarSep972 do
  begin
    AddTo := Self;
  end;

  FBtnFontColor := TRMColorPickerButton.Create(Self);
  with FBtnFontColor do
  begin
    Tag := TAG_FontColor;
    Parent := Self;
    ParentShowHint := True;
    ColorType := rmptFont;
    OnColorChange := FDesignerForm.DoClick;
  end;
  FBtnBackColor := TRMColorPickerButton.Create(FDesignerForm);
  with FBtnBackColor do
  begin
    Parent := Self;
    Tag := TAG_BackColor;
    ParentShowHint := True;
    ColorType := rmptFill;
    OnColorChange := FDesignerForm.DoClick;
  end;
  FBtnFrameColor := TRMColorPickerButton.Create(FDesignerForm);
  with FBtnFrameColor do
  begin
    Parent := Self;
    Tag := TAG_FrameColor;
    ParentShowHint := True;
    ColorType := rmptLine; //rmptHighlight;
    OnColorChange := FDesignerForm.DoClick;
  end;
  FCmbFrameWidth := TRMComboBox97.Create(FDesignerForm);
  with FCmbFrameWidth do
  begin
    Parent := Self;
    Width := 44;
    Tag := TAG_FrameSize;
    DropDownCount := 14;
    Items.Add('0.1');
    Items.Add('0.5');
    Items.Add('1');
    Items.Add('1.5');
    for i := 2 to 10 do
      Items.Add(IntToStr(i));

    OnClick := FDesignerForm.DoClick;
  end;
  ToolbarSep973 := TRMToolbarSep.Create(Self);
  with ToolbarSep973 do
  begin
    AddTo := Self;
  end;

  btnHLeft := TRMToolbarButton.Create(Self);
  with btnHLeft do
  begin
    GroupIndex := 4;
    ImageIndex := 4;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_HAlignLeft;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnHCenter := TRMToolbarButton.Create(Self);
  with btnHCenter do
  begin
    GroupIndex := 4;
    ImageIndex := 5;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_HAlignCenter;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnHRight := TRMToolbarButton.Create(Self);
  with btnHRight do
  begin
    GroupIndex := 4;
    ImageIndex := 6;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_HAlignRight;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnHSpaceEqual := TRMToolbarButton.Create(Self);
  with btnHSpaceEqual do
  begin
    GroupIndex := 4;
    ImageIndex := 7;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_HAlignEuqal;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  ToolbarSep974 := TRMToolbarSep.Create(Self);
  with ToolbarSep974 do
  begin
    AddTo := Self;
  end;

  btnVTop := TRMToolbarButton.Create(Self);
  with btnVTop do
  begin
    GroupIndex := 6;
    ImageIndex := 8;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_VAlignTop;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnVCenter := TRMToolbarButton.Create(Self);
  with btnVCenter do
  begin
    GroupIndex := 6;
    ImageIndex := 9;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_VAlignCenter;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnVBottom := TRMToolbarButton.Create(Self);
  with btnVBottom do
  begin
    GroupIndex := 6;
    ImageIndex := 10;
    Images := FDesignerForm.ImageListFont;
    Tag := TAG_VAlignBottom;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  ToolbarSep975 := TRMToolbarSep.Create(Self);
  with ToolbarSep975 do
  begin
    AddTo := Self;
  end;

  EndUpdate;
  Localize;
end;

procedure TRMToolbarEdit.Localize;
begin
  RMSetStrProp(Self, 'Caption', rmRes + 082);
  RMSetStrProp(btnFontBold, 'Hint', rmRes + 115);
  RMSetStrProp(btnFontItalic, 'Hint', rmRes + 116);
  RMSetStrProp(btnFontUnderline, 'Hint', rmRes + 117);
  RMSetStrProp(btnHLeft, 'Hint', rmRes + 107);
  RMSetStrProp(btnHCenter, 'Hint', rmRes + 109);
  RMSetStrProp(btnHRight, 'Hint', rmRes + 108);
  RMSetStrProp(btnHSpaceEqual, 'Hint', rmRes + 114);
  RMSetStrProp(btnVTop, 'Hint', rmRes + 112);
  RMSetStrProp(btnVCenter, 'Hint', rmRes + 111);
  RMSetStrProp(btnVBottom, 'Hint', rmRes + 113);
  RMSetStrProp(FBtnFontColor, 'Hint', rmRes + 208);
  RMSetStrProp(FBtnFrameColor, 'Hint', rmRes + 210);
  RMSetStrProp(FBtnBackColor, 'Hint', rmRes + 209);
  RMSetStrProp(FCmbFrameWidth, 'Hint', rmRes + 194);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarGrid }

constructor TRMToolbarGrid.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
begin
  inherited Create(AOwner);
  BeginUpdate;
  Dockedto := DockTo;
  FDesignerForm := TRMGridReportDesignerForm(AOwner);
  DockRow := 0;
  DockPos := 100;
  Name := 'GridReport_ToolbarGrid';
  CloseButton := False;

  btnInsertColumn := TRMToolbarButton.Create(Self);
  with btnInsertColumn do
  begin
    ImageIndex := 0;
    Images := FDesignerForm.ImageListGrid;
    OnClick := FDesignerForm.itmInsertLeftColumnClick;
    AddTo := Self;
  end;
  btnInsertRow := TRMToolbarButton.Create(Self);
  with btnInsertRow do
  begin
    ImageIndex := 1;
    Images := FDesignerForm.ImageListGrid;
    OnClick := FDesignerForm.itmInsertTopRowClick;
    AddTo := Self;
  end;
  btnAddColumn := TRMToolbarButton.Create(Self);
  with btnAddColumn do
  begin
    ImageIndex := 2;
    Images := FDesignerForm.ImageListGrid;
    OnClick := OnAddColumnClick;
    AddTo := Self;
  end;
  btnAddRow := TRMToolbarButton.Create(Self);
  with btnAddRow do
  begin
    ImageIndex := 3;
    Images := FDesignerForm.ImageListGrid;
    OnClick := OnAddRowClick;
    AddTo := Self;
  end;
  ToolbarSep1 := TRMToolbarSep.Create(Self);
  with ToolbarSep1 do
  begin
    AddTo := Self;
  end;

  btnDeleteColumn := TRMToolbarButton.Create(Self);
  with btnDeleteColumn do
  begin
    ImageIndex := 4;
    Images := FDesignerForm.ImageListGrid;
    OnClick := FDesignerForm.itmDeleteColumnClick;
    AddTo := Self;
  end;
  btnDeleteRow := TRMToolbarButton.Create(Self);
  with btnDeleteRow do
  begin
    ImageIndex := 5;
    Images := FDesignerForm.ImageListGrid;
    OnClick := FDesignerForm.itmDeleteRowClick;
    AddTo := Self;
  end;
  btnSetRowsAndColumns := TRMToolbarButton.Create(Self);
  with btnSetRowsAndColumns do
  begin
    ImageIndex := 10;
    Images := FDesignerForm.ImageListGrid;
    OnClick := OnBtnSetRowsAndColumnsClick;
    AddTo := Self;
  end;
  ToolbarSep2 := TRMToolbarSep.Create(Self);
  with ToolbarSep2 do
  begin
    AddTo := Self;
  end;

  btnMerge := TRMToolbarButton.Create(Self);
  with btnMerge do
  begin
    ImageIndex := 6;
    Images := FDesignerForm.ImageListGrid;
    OnClick := FDesignerForm.btnMergeClick;
    AddTo := Self;
  end;
  btnSplit := TRMToolbarButton.Create(Self);
  with btnSplit do
  begin
    ImageIndex := 7;
    Images := FDesignerForm.ImageListGrid;
    OnClick := FDesignerForm.btnSplitClick;
    AddTo := Self;
  end;
  btnMergeColumn := TRMToolbarButton.Create(Self);
  with btnMergeColumn do
  begin
    ImageIndex := 8;
    Images := FDesignerForm.ImageListGrid;
    OnClick := OnMergeColumnClick;
    AddTo := Self;
  end;
  btnMergeRow := TRMToolbarButton.Create(Self);
  with btnMergeRow do
  begin
    ImageIndex := 9;
    Images := FDesignerForm.ImageListGrid;
    OnClick := OnMergeRowClick;
    AddTo := Self;
  end;

  EndUpdate;
  Localize;
end;

procedure TRMToolbarGrid.Localize;
begin
  RMSetStrProp(Self, 'Caption', rmRes + 244);
  RMSetStrProp(btnInsertColumn, 'Hint', rmRes + 236);
  RMSetStrProp(btnInsertRow, 'Hint', rmRes + 237);
  RMSetStrProp(btnAddColumn, 'Hint', rmRes + 238);
  RMSetStrProp(btnAddRow, 'Hint', rmRes + 239);
  RMSetStrProp(btnDeleteColumn, 'Hint', rmRes + 240);
  RMSetStrProp(btnDeleteRow, 'Hint', rmRes + 241);
  RMSetStrProp(btnMerge, 'Hint', rmRes + 805);
  RMSetStrProp(btnSplit, 'Hint', rmRes + 806);
  RMSetStrProp(btnMergeColumn, 'Hint', rmRes + 242);
  RMSetStrProp(btnMergeRow, 'Hint', rmRes + 243);
  RMSetStrProp(btnSetRowsAndColumns, 'Hint', rmRes + 693);
end;

procedure TRMToolbarGrid.OnAddColumnClick(Sender: TObject);
begin
  FDesignerForm.AddUndoAction(acChangeCellCount);
  FDesignerForm.Modified := True;
  FDesignerForm.FGrid.ColCount := FDesignerForm.FGrid.ColCount + 1;
end;

procedure TRMToolbarGrid.OnAddRowClick(Sender: TObject);
begin
  FDesignerForm.AddUndoAction(acChangeCellCount);
  FDesignerForm.Modified := True;
  FDesignerForm.FGrid.RowCount := FDesignerForm.FGrid.RowCount + 1;
end;

procedure TRMToolbarGrid.OnMergeColumnClick(Sender: TObject);
var
  i: Integer;
  liRect: TRect;
begin
  FDesignerForm.Modified := True;
  liRect := FDesignerForm.FGrid.Selection;
  for i := liRect.Left to liRect.Right do
  begin
    FDesignerForm.FGrid.MergeCell(i, liRect.Top, i, liRect.Bottom);
  end;
end;

procedure TRMToolbarGrid.OnMergeRowClick(Sender: TObject);
var
  i: Integer;
  liRect: TRect;
begin
  FDesignerForm.Modified := True;
  liRect := FDesignerForm.FGrid.Selection;
  for i := liRect.Top to liRect.Bottom do
  begin
    FDesignerForm.FGrid.MergeCell(liRect.Left, i, liRect.Right, i);
  end;
end;

procedure TRMToolbarGrid.OnBtnSetRowsAndColumnsClick(Sender: TObject);
var
  liRect: TRect;
begin
  FDesignerForm.AddUndoAction(acChangeCellCount);
  liRect := FDesignerForm.FGrid.Selection;
  FDesignerForm.FGrid.RowCount := liRect.Bottom + 1;
  FDesignerForm.FGrid.ColCount := liRect.Right + 1;
  FDesignerForm.Modified := True;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarCellEdit }

constructor TRMToolbarCellEdit.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
begin
  inherited Create(AOwner);
  BeginUpdate;
  Dockedto := DockTo;
  FDesignerForm := TRMGridReportDesignerForm(AOwner);
  DockRow := 4;
  DockPos := 0;
  Name := 'GridReport_ToolbarCellEdit';
  CloseButton := True;

  FLblCell := TRMToolbarButton.Create(Self);
  with FLblCell do
  begin
    Width := 110;
    AddTo := Self;
  end;
  FToolbarSep1 := TRMToolbarSep.Create(Self);
  with FToolbarSep1 do
  begin
    AddTo := Self;
  end;

  FBtnDBField := TRMToolbarButton.Create(Self);
  with FBtnDBField do
  begin
    ImageIndex := 28;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnDBFieldClick;
    AddTo := Self;
  end;
  FBtnExpression := TRMToolbarButton.Create(Self);
  with FBtnExpression do
  begin
    ImageIndex := 21;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnExpressionClick;
    AddTo := Self;
  end;
  FEdtMemo := TEdit.Create(Self);
  with FEdtMemo do
  begin
    Parent := Self;
    OnKeyUp := CellEditKeyUp;
    Width := 400;
    //    AddTo := Self;
  end;

  EndUpdate;
  Localize;
end;

procedure TRMToolbarCellEdit.Localize;
begin
  RMSetStrProp(FBtnExpression, 'Hint', rmRes + 701);
  RMSetStrProp(FBtnDBField, 'Hint', rmRes + 62);

  RMSetStrProp(Self, 'Caption', rmRes + 866);
end;

procedure TRMToolbarCellEdit.CellEditKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  with FDesignerForm do
  begin
    BeforeChange;
    FGrid.Cells[FGrid.Col, FGrid.Row].View.Memo.Text := Self.FEdtMemo.Text;
    AfterChange;
    THackGridEx(FGrid).InvalidateCell(FGrid.Col, FGrid.Row);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarBorder }

constructor TRMToolbarBorder.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
begin
  inherited Create(AOwner);
  BeginUpdate;
  Dockedto := DockTo;
  FDesignerForm := TRMGridReportDesignerForm(AOwner);
  DockRow := 2;
  DockPos := 0;
  Name := 'GridReport_ToolbarBorder';

  btnFrameLeft := TRMToolbarButton.Create(Self);
  with btnFrameLeft do
  begin
    AllowAllUp := True;
    GroupIndex := 2;
    ImageIndex := 4;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_SetFrameLeft;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnFrameRight := TRMToolbarButton.Create(Self);
  with btnFrameRight do
  begin
    AllowAllUp := True;
    GroupIndex := 4;
    ImageIndex := 5;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_SetFrameRight;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnFrameTop := TRMToolbarButton.Create(Self);
  with btnFrameTop do
  begin
    AllowAllUp := True;
    GroupIndex := 1;
    ImageIndex := 6;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_SetFrameTop;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnFrameBottom := TRMToolbarButton.Create(Self);
  with btnFrameBottom do
  begin
    AllowAllUp := True;
    GroupIndex := 3;
    ImageIndex := 7;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_SetFrameBottom;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  ToolbarSep971 := TRMToolbarSep.Create(Self);
  with ToolbarSep971 do
  begin
    AddTo := Self;
  end;

  btnNoBorder := TRMToolbarButton.Create(Self);
  with btnNoBorder do
  begin
    ImageIndex := 0;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_NoFrame;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnSetBorder := TRMToolbarButton.Create(Self);
  with btnSetBorder do
  begin
    ImageIndex := 1;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_SetFrame;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnTopBorder := TRMToolbarButton.Create(Self);
  with btnTopBorder do
  begin
    ImageIndex := 3;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_Frame1;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnBottomBorder := TRMToolbarButton.Create(Self);
  with btnBottomBorder do
  begin
    ImageIndex := 2;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_Frame2;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  ToolbarSep972 := TRMToolbarSep.Create(Self);
  with ToolbarSep972 do
  begin
    AddTo := Self;
  end;

  btnBias1Border := TRMToolbarButton.Create(Self);
  with btnBias1Border do
  begin
    AllowAllUp := True;
    GroupIndex := 40;
    ImageIndex := 8;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_Frame3;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnBias2Border := TRMToolbarButton.Create(Self);
  with btnBias2Border do
  begin
    AllowAllUp := True;
    GroupIndex := 41;
    ImageIndex := 9;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_Frame4;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  ToolbarSep973 := TRMToolbarSep.Create(Self);
  with ToolbarSep973 do
  begin
    AddTo := Self;
  end;

  btnDecWidth := TRMToolbarButton.Create(Self);
  with btnDecWidth do
  begin
    ImageIndex := 14;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_DecWidth;
    OnClick := FDesignerForm.DoClick;
    {$IFNDEF USE_TB2k}
    Repeating := True;
    {$ENDIF}
    AddTo := Self;
  end;
  btnIncWidth := TRMToolbarButton.Create(Self);
  with btnIncWidth do
  begin
    ImageIndex := 12;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_IncWidth;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
    {$IFNDEF USE_TB2k}
    Repeating := True;
    {$ENDIF}
  end;
  btnDecHeight := TRMToolbarButton.Create(Self);
  with btnDecHeight do
  begin
    ImageIndex := 11;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_DecHeight;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
    {$IFNDEF USE_TB2k}
    Repeating := True;
    {$ENDIF}
  end;
  btnIncHeight := TRMToolbarButton.Create(Self);
  with btnIncHeight do
  begin
    ImageIndex := 13;
    Images := FDesignerForm.ImageListFrame;
    Tag := TAG_IncHeight;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
    {$IFNDEF USE_TB2k}
    Repeating := True;
    {$ENDIF}
  end;
  ToolbarSep974 := TRMToolbarSep.Create(Self);
  with ToolbarSep974 do
  begin
    AddTo := Self;
  end;

  btnColumnMin := TRMToolbarButton.Create(Self);
  with btnColumnMin do
  begin
    ImageIndex := 0;
    Images := FDesignerForm.ImageListSize;
    OnClick := FDesignerForm.btnColumnMinClick;
    AddTo := Self;
  end;
  btnColumnMax := TRMToolbarButton.Create(Self);
  with btnColumnMax do
  begin
    ImageIndex := 1;
    Images := FDesignerForm.ImageListSize;
    OnClick := FDesignerForm.btnColumnMaxClick;
    AddTo := Self;
  end;
  btnRowMin := TRMToolbarButton.Create(Self);
  with btnRowMin do
  begin
    ImageIndex := 2;
    Images := FDesignerForm.ImageListSize;
    OnClick := FDesignerForm.btnRowMinClick;
    AddTo := Self;
  end;
  btnRowMax := TRMToolbarButton.Create(Self);
  with btnRowMax do
  begin
    ImageIndex := 3;
    Images := FDesignerForm.ImageListSize;
    OnClick := FDesignerForm.btnRowMaxClick;
    AddTo := Self;
  end;
  ToolbarSep975 := TRMToolbarSep.Create(Self);
  with ToolbarSep975 do
  begin
    AddTo := Self;
  end;

  cmbBands := TRMComboBox97.Create(Self);
  with cmbBands do
  begin
    parent := Self;
    Height := 21;
    Width := 180;
    DropDownCount := 12;
    OnClick := FDesignerForm.cmbBandsClick;
    OnDropDown := FDesignerForm.cmbBandsDropDown;
    Perform(CB_SETDROPPEDWIDTH, 240, 0);
  end;
  {$IFDEF USE_TB2K}
  btnAddBand := TRMSubmenuItem.Create(Self);
  {$ELSE}
  btnAddBand := TRMToolbarButton.Create(Self);
  {$ENDIF}
  with btnAddBand do
  begin
    ImageIndex := 16;
    Images := FDesignerForm.ImageListFrame;
    AddTo := Self;
    DropdownCombo := True;
    {$IFNDEF USE_TB2k}
    DropdownMenu := FDesignerForm.PopupMenuBands;
    {$ENDIF}
  end;
  btnDeleteBand := TRMToolbarButton.Create(Self);
  with btnDeleteBand do
  begin
    ImageIndex := 15;
    Images := FDesignerForm.ImageListFrame;
    OnClick := FDesignerForm.btnDeleteBandClick;
    AddTo := Self;
  end;

  EndUpdate;
  Localize;
end;

procedure TRMToolbarBorder.Localize;
begin
  RMSetStrProp(Self, 'Caption', rmRes + 083);
  RMSetStrProp(btnFrameLeft, 'Hint', rmRes + 123);
  RMSetStrProp(btnFrameRight, 'Hint', rmRes + 125);
  RMSetStrProp(btnFrameTop, 'Hint', rmRes + 122);
  RMSetStrProp(btnFrameBottom, 'Hint', rmRes + 124);
  RMSetStrProp(btnNoBorder, 'Hint', rmRes + 127);
  RMSetStrProp(btnSetBorder, 'Hint', rmRes + 126);

  RMSetStrProp(btnTopBorder, 'Hint', rmRes + 234);
  RMSetStrProp(btnBottomBorder, 'Hint', rmRes + 235);
  RMSetStrProp(btnBias1Border, 'Hint', rmRes + 232);
  RMSetStrProp(btnBias2Border, 'Hint', rmRes + 233);

  RMSetStrProp(btnDecWidth, 'Hint', rmRes + 228);
  RMSetStrProp(btnIncWidth, 'Hint', rmRes + 229);
  RMSetStrProp(btnDecHeight, 'Hint', rmRes + 230);
  RMSetStrProp(btnIncHeight, 'Hint', rmRes + 231);

  RMSetStrProp(btnAddBand, 'Hint', rmRes + 134);
  RMSetStrProp(btnDeleteBand, 'Hint', rmRes + 227);

  RMSetStrProp(btnColumnMin, 'Hint', rmRes + 202);
  RMSetStrProp(btnColumnMax, 'Hint', rmRes + 203);
  RMSetStrProp(btnRowMin, 'Hint', rmRes + 204);
  RMSetStrProp(btnRowMax, 'Hint', rmRes + 205);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMGridReportDesigner}

constructor TRMGridReportDesigner.Create(AOwner: TComponent);
begin
  //  if Assigned(FDesignerComp) then
  //    raise Exception.Create('You already have one TRMGridReportDesigner component');
  inherited Create(AOwner);

  FDesignerComp := Self;
  FOpenFileCount := 4;
  FDefaultDictionaryFile := '';
  FUseUndoRedo := True;
end;

destructor TRMGridReportDesigner.Destroy;
begin
  FDesignerComp := nil;
  inherited Destroy;
end;

procedure TRMGridReportDesigner.SetOpenFileCount(Value: Integer);
begin
  if (Value >= 0) and (Value <= 9) then
    FOpenFileCount := Value;
end;

procedure TRMGridReportDesigner.SetDesignerRestrictions(Value: TRMDesignerRestrictions);
begin
  FDesignerRestrictions := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMGridViewForm }

function TRMGridReportDesignerForm.PageObjects: TList;
var
  i, j: Integer;
  liCell: TRMCellInfo;
begin
  if Page is TRMDialogPage then
  begin
    Result := Page.Objects;
    Exit;
  end;

  if FList = nil then
    FList := TList.Create;

  FList.Clear;
  for i := 0 to Page.Objects.Count - 1 do
    FList.Add(Page.Objects[i]);

  for i := 1 to FGrid.RowCount - 1 do
  begin
    j := 1;
    while j < FGrid.ColCount do
    begin
      liCell := FGrid.Cells[j, i];
      if liCell.StartRow = i then
        FList.Add(liCell.View);
      j := liCell.EndCol + 1;
    end;
  end;

  Result := FList;
end;

procedure TRMGridReportDesignerForm.SetObjectsID;
var
  i, j: Integer;
begin
  ObjID := 0;
  for i := 0 to Report.Pages.Count - 1 do
  begin
    for j := 0 to THackPage(Report.Pages[i]).Objects.Count - 1 do
    begin
      THackView(THackPage(Report.Pages[i]).Objects[j]).ObjectID := ObjID;
      Inc(ObjID);
    end;
  end;
end;

procedure TRMGridReportDesignerForm.ReleaseAction(aActionRec: PRMUndoRec);
begin
  if aActionRec.Stream <> nil then
  begin
    aActionRec.Stream.Free;
    aActionRec.Stream := nil;
  end;
  SetLength(aActionRec.Objects, 0);
  SetLength(aActionRec.Objects1, 0);
end;

procedure TRMGridReportDesignerForm.ClearUndoBuffer;
var
  i: Integer;
begin
  for i := 0 to FUndoBufferLength - 1 do
    ReleaseAction(@FUndoBuffer[i]);
  FUndoBufferLength := 0;

  MenuEditUndo.Enabled := False;
  ToolbarStandard.btnUndo.Enabled := MenuEditUndo.Enabled;
end;

procedure TRMGridReportDesignerForm.ClearRedoBuffer;
var
  i: Integer;
begin
  for i := 0 to FRedoBufferLength - 1 do
    ReleaseAction(@FRedoBuffer[i]);
  FRedoBufferLength := 0;

  MenuEditRedo.Enabled := False;
  ToolbarStandard.btnRedo.Enabled := MenuEditRedo.Enabled;
end;

procedure TRMGridReportDesignerForm.AddAction(aBuffer: PRMUndoBuffer; aAction: TRMUndoAction;
  aObject: TObject; aRec: PRMUndoRec);
var
  i: Integer;
  lBufferLength: Integer;

  function _FindObjectByID(aID: Integer): TRMView;
  var
    i: Integer;
    t: TRMView;
  begin
    Result := nil;
    for i := 0 to THackPage(Page).Objects.Count - 1 do
    begin
      t := THackPage(Page).Objects[i];
      if THackView(t).ObjectID = aID then
      begin
        Result := t;
        Break;
      end;
    end;
  end;

  procedure _SaveOneView(t: TRMView; aStream: TMemoryStream);
  begin
    THackView(t).StreamMode := rmsmDesigning;
    RMWriteByte(aStream, t.ObjectType);
    RMWriteString(aStream, t.ClassName);
    t.SaveToStream(aStream);
  end;

  procedure _SelectionToMemStream(aStream: TMemoryStream);
  var
    i, lRow, lCol, lCount: Integer;
    lCell: TRMCellInfo;
    lSavePos: Integer;
    t: TRMView;
    lStream: TMemoryStream;
  begin
    lStream := TMemoryStream.Create;
    try
      if aObject is TMemoryStream then
      begin
        RMWriteInt32(lStream, Length(aRec.Objects1));
        for i := 0 to Length(aRec.Objects1) - 1 do
        begin
          lCell := FGrid.Cells[aRec.Objects1[i].Col, aRec.Objects1[i].Row];
          RMWriteInt32(lStream, aRec.Objects1[i].Row);
          RMWriteInt32(lStream, aRec.Objects1[i].Col);
          _SaveOneView(lCell.View, lStream);
        end;

        RMWriteInt32(lStream, Length(aRec.Objects));
        for i := 0 to Length(aRec.Objects) - 1 do
        begin
          t := _FindObjectByID(aRec.Objects[i].ObjID);
          if t <> nil then
            _SaveOneView(t, lStream);
        end;
      end
      else
      begin
        lCount := 0;
        RMWriteInt32(lStream, 0);
        for lRow := 1 to FGrid.RowCount - 1 do
        begin
          lCol := 1;
          while lCol < FGrid.ColCount do
          begin
            lCell := FGrid.Cells[lCol, lRow];
            if (lCell.StartRow = lRow) and lCell.View.Selected then
            begin
              RMWriteInt32(lStream, lRow);
              RMWriteInt32(lStream, lCol);
              _SaveOneView(lCell.View, lStream);
              Inc(lCount);
              SetLength(aBuffer[lBufferLength].Objects1, lCount);
              aBuffer[lBufferLength].Objects1[lCount - 1].Row := lRow;
              aBuffer[lBufferLength].Objects1[lCount - 1].Col := lCol;
            end;
            lCol := lCell.EndCol + 1;
          end;
        end;

        lSavePos := lStream.Position;
        lStream.Position := 0;
        RMWriteInt32(lStream, lCount);
        lStream.Position := lSavePos;
        RMWriteInt32(lStream, 0);
        lCount := 0;
        for i := 0 to Page.Objects.Count - 1 do
        begin
          if TRMView(Page.Objects[i]).Selected then
          begin
            _SaveOneView(Page.Objects[i], lStream);
            Inc(lCount);
            SetLength(aBuffer[lBufferLength].Objects, lCount);
            aBuffer[lBufferLength].Objects[lCount - 1].ObjID := THackView(Page.Objects[i]).ObjectID;
          end;
        end;
        lStream.Position := lSavePos;
        RMWriteInt32(lStream, lCount);

        RMCompressStream(lStream, aStream, zcFastest);
      end;
    finally
      lStream.Free;
    end;
  end;

  procedure _SaveCellSize(aStream: TMemoryStream);
  var
    i: Integer;
  begin
    RMWriteInt32(aStream, FGrid.RowCount);
    RMWriteInt32(aStream, FGrid.ColCount);
    for i := 1 to FGrid.RowCount - 1 do
      RMWriteInt32(aStream, FGrid.RowHeights[i]);
    for i := 1 to FGrid.ColCount - 1 do
      RMWriteInt32(aStream, FGrid.ColWidths[i]);
  end;

  procedure _SaveGridProp(aStream: TMemoryStream);
  var
    lStream: TMemoryStream;
  begin
    lStream := TMemoryStream.Create;
    try
      FGrid.SaveToStream(lStream);
      RMCompressStream(lStream, aStream, zcFastest);
    finally
      lStream.Free;
    end;
  end;

  procedure _SavePageProp(aStream: TMemoryStream);
  var
    i: Integer;
    t: TRMView;
    lStream: TMemoryStream;
  begin
    lStream := TMemoryStream.Create;
    try
      RMWriteInt32(lStream, Page.Objects.Count);
      for i := 0 to Page.Objects.Count - 1 do
      begin
        t := Page.Objects[i];
        RMWriteByte(lStream, t.ObjectType);
        RMWriteString(lStream, t.ClassName);
        THackView(t).StreamMode := rmsmDesigning;
        t.SaveToStream(lStream);
      end;
      THackPage(Page).SaveToStream(lStream);
      RMCompressStream(lStream, aStream, zcFastest);
    finally
      lStream.Free;
    end;
  end;

begin
  if FUndoBusy then Exit;

  FUndoBusy := True;
  try
    if aBuffer = @FUndoBuffer then
      lBufferLength := FUndoBufferLength
    else
      lBufferLength := FRedoBufferLength;

    if lBufferLength >= MaxUndoBuffer then
    begin
      ReleaseAction(@aBuffer[0]);
      for i := 0 to MaxUndoBuffer - 2 do
        aBuffer^[i] := aBuffer^[i + 1];

      lBufferLength := MaxUndoBuffer - 1;
      aBuffer[lBufferLength].Stream := nil;
    end;

    aBuffer[lBufferLength].Action := aAction;
    aBuffer[lBufferLength].Page := CurPage;
    if aRec <> nil then
    begin
      SetLength(aBuffer[lBufferLength].Objects, Length(aRec.Objects));
      for i := 0 to Length(aRec.Objects) - 1 do
        aBuffer[lBufferLength].Objects[i].ObjID := aRec.Objects[i].ObjId;

      SetLength(aBuffer[lBufferLength].Objects1, Length(aRec.Objects1));
      for i := 0 to Length(aRec.Objects1) - 1 do
      begin
        aBuffer[lBufferLength].Objects1[i].Row := aRec.Objects1[i].Row;
        aBuffer[lBufferLength].Objects1[i].Col := aRec.Objects1[i].Col;
      end;
    end
    else
    begin
      SetLength(aBuffer[lBufferLength].Objects, 0);
      SetLength(aBuffer[lBufferLength].Objects1, 0);
    end;

    case aAction of
      acChangeCellSize:
        begin
          aBuffer[lBufferLength].Stream := TMemoryStream.Create;
          _SaveCellSize(aBuffer[lBufferLength].Stream);
        end;
      acChangeCellCount:
        begin
          aBuffer[lBufferLength].Stream := TMemoryStream.Create;
          _SaveGridProp(aBuffer[lBufferLength].Stream);
        end;
      acEdit:
        begin
          aBuffer[lBufferLength].Stream := TMemoryStream.Create;
          _SelectionToMemStream(aBuffer[lBufferLength].Stream);
        end;
      acChangePage:
        begin
          aBuffer[lBufferLength].Stream := TMemoryStream.Create;
          _SavePageProp(aBuffer[lBufferLength].Stream);
        end;
    end;

    if aBuffer = @FUndoBuffer then
    begin
      FUndoBufferLength := lBufferLength + 1;
    end
    else
    begin
      FRedoBufferLength := lBufferLength + 1;
    end;
  finally
    Modified := True;
    FUndoBusy := False;
  end;
end;

procedure TRMGridReportDesignerForm.OnGridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
  begin
    if Key = VK_F2 then
      OnGridDblClickEvent(nil);
    if (Key = VK_RETURN) and (not (rmgoEditing in FGrid.Options)) then
      OnGridDblClickEvent(nil);
  end
  else if (Key = VK_UP) and (Shift = [ssAlt]) then
  begin
    ToolbarBorder.btnDecHeight.Click;
  end
  else if (Key = VK_DOWN) and (Shift = [ssAlt]) then
  begin
    ToolbarBorder.btnIncHeight.Click;
  end
  else if (Key = VK_LEFT) and (Shift = [ssAlt]) then
  begin
    ToolbarBorder.btnDecWidth.Click;
  end
  else if (Key = VK_RIGHT) and (Shift = [ssAlt]) then
  begin
    ToolbarBorder.btnIncWidth.Click;
  end;
end;

procedure TRMGridReportDesignerForm.AddUndoAction(aAction: TRMUndoAction);
begin
  if (FDesignerComp <> nil) and (not FDesignerComp.UseUndoRedo) then Exit;
  if not (Page is TRMGridReportPage) then Exit;

  ClearRedoBuffer;
  if aAction in [acChangeCellSize, acChangeCellCount, acChangePage] then
  begin
    AddAction(@FUndoBuffer, aAction, nil, nil);
  end
  else
    AddAction(@FUndoBuffer, aAction, FGrid, nil);

  MenuEditUndo.Enabled := FUndoBufferLength > 0;
  ToolbarStandard.btnUndo.Enabled := MenuEditUndo.Enabled;
  MenuEditRedo.Enabled := FRedoBufferLength > 0;
  ToolbarStandard.btnRedo.Enabled := MenuEditRedo.Enabled;
end;

procedure TRMGridReportDesignerForm.Undo(aBuffer: PRMUndoBuffer);
var
  lBufferLength: Integer;

  function _FindObjectByID(aID: Integer): Integer;
  var
    i: Integer;
    t: TRMView;
  begin
    Result := -1;
    for i := 0 to THackPage(Page).Objects.Count - 1 do
    begin
      t := THackPage(Page).Objects[i];
      if THackView(t).ObjectID = aID then
      begin
        Result := i;
        Break;
      end;
    end;
  end;

  procedure _AssignObjects(aStream: TMemoryStream);
  var
    i, lCount, lRow, lCol: Integer;
    t: TRMView;
    lObjectTyp: Byte;
    lObjectClassName: string;
    lStream: TMemoryStream;

    procedure _LoadOneView;
    var
      lCreateFlag: Boolean;
    begin
      lCreateFlag := False;
      lObjectTyp := RMReadByte(aStream);
      lObjectClassName := RMReadString(aStream);
      t := Page.Objects[_FindObjectByID(aBuffer[lBufferLength - 1].Objects[i].ObjID)];
      if t = nil then
      begin
        lCreateFlag := True;
        t := RMCreateObject(lObjectTyp, lObjectClassName);
      end;
      t.NeedCreateName := False;
      THackView(t).StreamMode := rmsmDesigning;
      t.LoadFromStream(aStream);
      if lCreateFlag then
        t.Free;
    end;

  begin
    lStream := TMemoryStream.Create;
    try
      aStream.Position := 0;
      RMDeCompressStream(aStream, lStream);
      lStream.Position := 0;
      lCount := RMReadInt32(lStream);
      for i := 0 to lCount - 1 do
      begin
        lRow := RMReadInt32(lStream);
        lCol := RMReadInt32(lStream);
        lObjectTyp := RMReadByte(lStream);
        lObjectClassName := RMReadString(lStream);
        FGrid.Cells[lCol, lRow].ReCreateView(lObjectTyp, lObjectClassName);
        t := FGrid.Cells[lCol, lRow].View;
        t.NeedCreateName := False;
        THackView(t).StreamMode := rmsmDesigning;
        t.LoadFromStream(lStream);
      end;

      lCount := RMReadInt32(lStream);
      for i := 0 to lCount - 1 do
      begin
        _LoadOneView;
      end;
    finally
      lStream.Free;
    end;
  end;

  procedure _SetUndo;
  var
    lAction: TRMUndoAction;
    lObject: TObject;
  begin
    lAction := acEdit;
    lObject := nil;
    case aBuffer[lBufferLength - 1].Action of
      acChangeCellSize:
        begin
          lAction := acChangeCellSize;
          lObject := nil;
        end;
      acChangeCellCount:
        begin
          lAction := acChangeCellCount;
          lObject := nil;
        end;
      acEdit:
        begin
          lAction := acEdit;
          lObject := aBuffer[lBufferLength - 1].Stream;
        end;
      acChangePage:
        begin
          lAction := acChangePage;
          lObject := nil;
        end;
    end;

    if aBuffer = @FUndoBuffer then
    begin
      if lAction = acEdit then
        AddAction(@FRedoBuffer, lAction, lObject, @aBuffer[lBufferLength - 1])
      else
        AddAction(@FRedoBuffer, lAction, lObject, nil);
    end
    else
    begin
      if lAction = acEdit then
        AddAction(@FUndoBuffer, lAction, lObject, @aBuffer[lBufferLength - 1])
      else
        AddAction(@FUndoBuffer, lAction, lObject, nil);
    end;
  end;

  procedure _RestoreCellSize(aStream: TMemoryStream);
  var
    i: Integer;
  begin
    aStream.Position := 0;
    FGrid.RowCount := RMReadInt32(aStream);
    FGrid.ColCount := RMReadInt32(aStream);
    for i := 1 to FGrid.RowCount - 1 do
      FGrid.RowHeights[i] := RMReadInt32(aStream);
    for i := 1 to FGrid.ColCount - 1 do
      FGrid.ColWidths[i] := RMReadInt32(aStream);
  end;

  procedure _RestoreGridProp(aStream: TMemoryStream);
  var
    lStream: TMemoryStream;
  begin
    lStream := TMemoryStream.Create;
    try
      aStream.Position := 0;
      RMDeCompressStream(aStream, lStream);
      lStream.Position := 0;
      FGrid.LoadFromStream(lStream);
    finally
      lStream.Free;
    end;
  end;

  procedure _RestorePageProp(aStream: TMemoryStream);
  var
    i, lCount: Integer;
    b: Byte;
    t: TRMView;
    lStream: TMemoryStream;
  begin
    lStream := TMemoryStream.Create;
    try
      aStream.Position := 0;
      RMDeCompressStream(aStream, lStream);
      lStream.Position := 0;
      Page.Clear;
      lCount := RMReadInt32(lStream);
      for i := 0 to lCount - 1 do
      begin
        b := RMReadByte(lStream);
        t := RMCreateObject(b, RMReadString(lStream));
        t.NeedCreateName := False;
        THackView(t).StreamMode := rmsmDesigning;
        t.LoadFromStream(lStream);
        t.ParentPage := Page;
      end;

      THackPage(Page).LoadFromStream(lStream);
      THackPage(Page).Loaded;
      SetGridHeader;
    finally
      lStream.Free;
    end;
  end;

begin
  if (FDesignerComp <> nil) and (not FDesignerComp.UseUndoRedo) then Exit;
  if not (Page is TRMGridReportPage) then Exit;

  if aBuffer = @FUndoBuffer then
    lBufferLength := FUndoBufferLength
  else
    lBufferLength := FRedoBufferLength;

  if aBuffer[lBufferLength - 1].Page <> CurPage then Exit;

  _SetUndo;
  case aBuffer[lBufferLength - 1].Action of
    acChangeCellSize:
      begin
        _RestoreCellSize(aBuffer[lBufferLength - 1].Stream);
      end;
    acChangeCellCount:
      begin
        _RestoreGridProp(aBuffer[lBufferLength - 1].Stream);
      end;
    acEdit:
      begin
        _AssignObjects(aBuffer[lBufferLength - 1].Stream);
      end;
    acChangePage:
      begin
        _RestorePageProp(aBuffer[lBufferLength - 1].Stream);
      end;
  end;

  ReleaseAction(@aBuffer[lBufferLength - 1]);
  if aBuffer = @FUndoBuffer then
    Dec(FUndoBufferLength)
  else
    Dec(FRedoBufferLength);

  EnableControls;
end;

procedure TRMGridReportDesignerForm.SelectionChanged(aRefreshInspProp: Boolean);
var
  t: TRMView;
begin
  if FBusy then Exit;

  FBusy := True;
  EnableControls;
  if Page is TRMReportPage then
  begin
    t := FGrid.Cells[FGrid.Selection.Left, FGrid.Selection.Top].View;
    ToolbarBorder.btnFrameTop.Down := t.TopFrame.Visible;
    ToolbarBorder.btnFrameLeft.Down := t.LeftFrame.Visible;
    ToolbarBorder.btnFrameBottom.Down := t.BottomFrame.Visible;
    ToolbarBorder.btnFrameRight.Down := t.RightFrame.Visible;
    ToolbarBorder.btnBias1Border.Down := t.LeftRightFrame = 4;
    ToolbarBorder.btnBias2Border.Down := t.LeftRightFrame = 1;

    ToolbarEdit.FBtnBackColor.CurrentColor := t.FillColor;
    ToolbarEdit.FBtnFrameColor.CurrentColor := t.TopFrame.Color;
    ToolbarEdit.FCmbFrameWidth.Text := FloatToStrF(RMFromMMThousandths(t.TopFrame.mmWidth, rmutScreenPixels), ffGeneral, 2, 2);
    if t is TRMCustomMemoView then
    begin
      with TRMCustomMemoView(t) do
      begin
        ToolbarEdit.FBtnFontColor.CurrentColor := Font.Color;
        if ToolbarEdit.FcmbFont.ItemIndex <> ToolbarEdit.FcmbFont.Items.IndexOf(Font.Name) then
          ToolbarEdit.FcmbFont.ItemIndex := ToolbarEdit.FcmbFont.Items.IndexOf(Font.Name);
        RMSetFontSize(TComboBox(ToolbarEdit.FCmbFontSize), Font.Height, Font.Size);
        ToolbarEdit.btnFontBold.Down := fsBold in Font.Style;
        ToolbarEdit.btnFontItalic.Down := fsItalic in Font.Style;
        ToolbarEdit.btnFontUnderline.Down := fsUnderline in Font.Style;
        case VAlign of
          rmVTop: ToolbarEdit.btnVTop.Down := True;
          rmVBottom: ToolbarEdit.btnVBottom.Down := True;
        else
          ToolbarEdit.btnVCenter.Down := True;
        end;
        case HAlign of
          rmhLeft: ToolbarEdit.btnHLeft.Down := True;
          rmhCenter: ToolbarEdit.btnHCenter.Down := True;
          rmhRight: ToolbarEdit.btnHRight.Down := True;
        else
          ToolbarEdit.btnHSpaceEqual.Down := True;
        end;
      end;
    end;
  end;

  if aRefreshInspProp then ShowPosition;
  if Page is TRMDialogPage then
  begin
    RedrawPage;
  end;
  ShowContent;
  FBusy := False;
end;

procedure TRMGridReportDesignerForm.OnInspBeforeModify(Sender: TObject; const aPropName: string);
begin
  if DesignerRestrictions * [rmdrDontModifyObj] <> [] then
    Abort;

  if (not (csDesigning in Report.ComponentState)) and
    (FInspForm.Insp.Objects[0] is TRMView) and (System.Pos('rmrtDont', aPropName) <> 1) then
  begin
    if (TRMView(FInspForm.Insp.Objects[0]).Restrictions * [rmrtDontModify]) <> [] then
      Abort;
  end;

  BeforeChange;
end;

procedure TRMGridReportDesignerForm.OnInspAfterModify(Sender: TObject; const aPropName, aPropValue: string);
begin
  if FInspForm.Insp.Objects[0] is TRMDialogPage then
  begin
    FWorkSpace.PageForm.SetPageFormProp;
  end
  else if FInspForm.Insp.Objects[0] is TRMCustomBandView then
  begin
  end
  else if FInspForm.Insp.Objects[0] is TRMGridReportPage then
  begin
    if FGrid <> nil then
      FGrid.AutoCreateName := TRMGridReportPage(FInspForm.Insp.Objects[0]).AutoCreateName;
  end;

  if AnsiCompareText(aPropName, 'Name') = 0 then
  begin
    FInspForm.SetCurrentObject(FInspForm.Insp.Objects[0].ClassName, aPropValue);
  end;

  Modified := True;
  SetPageTabs;
  StatusBar1.Repaint;
  SelectionChanged(False);
  if FFieldForm.Visible then
    FFieldForm.RefreshData;
end;

procedure TRMGridReportDesignerForm.UnselectAll;
var
  i: Integer;
  liList: TList;
begin
  SelNum := 0;
  liList := PageObjects;
  for i := 0 to liList.Count - 1 do
    TRMView(liList[i]).Selected := False;
end;

procedure TRMGridReportDesignerForm.SelectObject(aObjName: string);
var
  i: Integer;
  t: TRMView;
  liList: TList;
begin
  liList := PageObjects;
  t := nil;
  for i := 0 to liList.Count - 1 do
  begin
    if AnsiCompareText(aObjName, TRMView(liList[i]).Name) = 0 then
    begin
      t := liList[i];
      Break;
    end;
  end;
  if t <> nil then
  begin
    UnSelectAll;
    SelNum := 1;
    t.Selected := True;
    SelectionChanged(True);
  end
  else if Pos('Page', aObjName) = 1 then
    CurPage := StrToInt(Copy(aObjName, 5, 9999)) - 1;
end;

procedure TRMGridReportDesignerForm.InspSelectionChanged(ObjName: string);
begin
  SelectObject(ObjName);
  if Tab1.TabIndex = 0 then
    FillInspFields;
end;

procedure TRMGridReportDesignerForm.InspGetObjects(aList: TStrings);
var
  i: Integer;
  liCol, liRow: Integer;
  liCell: TRMCellInfo;
  liSelection: TRect;
begin
  aList.Clear;
  for i := 0 to Page.Objects.Count - 1 do
    aList.Add(TRMView(Page.Objects[i]).Name);
  for i := 0 to Report.Pages.Count - 1 do
    aList.Add('Page' + IntToStr(i + 1));

  // Grid中的View
  if Page is TRMReportPage then
  begin
    liSelection := FGrid.Selection;
    for liCol := liSelection.Left to liSelection.Right do
    begin
      for liRow := liSelection.Top to liSelection.Bottom do
      begin
        liCell := FGrid.Cells[liCol, liRow];
        if (liCell.StartCol = liCol) and (liCell.StartRow = liRow) then
        begin
          liCell.View.Selected := True;
          aList.Add(liCell.View.Name);
        end;
      end;
    end;
  end;
end;

procedure TRMGridReportDesignerForm.FillInspFields;
var
  i: Integer;
  t, t1: TRMView;
  liList: TList;
begin
  if not FInspForm.Visible then Exit;
  if FInspBusy then Exit;

  FInspBusy := True;
  liList := PageObjects;
  if SelNum > 0 then
    t := liList[TopSelected]
  else
    t := nil;
  if (SelNum = 1) and (FInspForm.Insp.ObjectCount = 1) and
    (FInspForm.Insp.IndexOf(t) >= 0) then
  begin
    FInspForm.Insp.UpdateItems;
    //    FInspForm.BeginUpdate;
    //    FInspForm.Insp.State := FInspForm.Insp.State + [ppsChanged];
    //    FInspForm.EndUpdate;
    FInspBusy := False;
    Exit;
  end;

  FInspForm.BeginUpdate;
  FInspForm.ClearObjects;
  FInspForm.Insp.ReadOnly := False;
  if SelNum > 0 then
  begin
    FInspForm.AddObject(t);
    //    if (not (csDesigning in Report.ComponentState)) and
    //      ((DesignerRestrictions * [rmdrDontModifyObj] <> []) or (t.Restrictions * [rmrtDontModify] <> [])) then
    //      FInspForm.Insp.ReadOnly := True;

    if SelNum > 1 then
    begin
      for i := 0 to liList.Count - 1 do
      begin
        t1 := liList[i];
        if TRMView(t1).Selected and (t1 <> t) then
        begin
          FInspForm.AddObject(t1);
          if (DesignerRestrictions * [rmdrDontModifyObj] <> []) or (t1.Restrictions * [rmrtDontModify] <> []) then
            FInspForm.Insp.ReadOnly := True;
        end;
      end;
    end;
    FInspForm.SetCurrentObject(t.ClassName, t.Name);
  end
  else
  begin
    FInspForm.AddObject(Page);
    FInspForm.SetCurrentObject(Page.ClassName, Page.Name);
  end;
  FInspForm.EndUpdate;
  FInspBusy := False;
end;

procedure TRMGridReportDesignerForm.btnDBFieldClick(Sender: TObject);
var
  lStr, lStr1: string;
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.ReadOnly then Exit;
    lStr := RMDesigner.InsertDBField;
    if lStr <> '' then
    begin
      Delete(lStr, 1, 1);
      Delete(lStr, Length(lStr), 1);
      lStr := 'GetFieldValue(''' + lStr + ''')';
      if FCodeMemo.SelLength > 0 then
        FCodeMemo.SelText := lStr
      else
      begin
        lStr1 := FCodeMemo.Lines[FCodeMemo.CaretY];
        while Length(lStr1) <= FCodeMemo.CaretX do
          lStr1 := lStr1 + ' ';
        System.Insert(lStr, lStr1, FCodeMemo.CaretX + 1);
        FCodeMemo.Lines[FCodeMemo.CaretY] := lStr1;
      end;

      Modified := True;
    end;
  end
  else
  begin
    lStr := RMDesigner.InsertDBField;
    if lStr <> '' then
    begin
      BeforeChange;
      FGrid.Cells[FGrid.Col, FGrid.Row].View.Memo.Text := lStr;
      AfterChange;
      THackGridEx(FGrid).InvalidateCell(FGrid.Col, FGrid.Row);
    end;
  end;
end;

procedure TRMGridReportDesignerForm.btnExpressionClick(Sender: TObject);
var
  listr, listr1: string;
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.ReadOnly then Exit;
    if RMGetExpression('', listr, nil, True) then
    begin
      if listr <> '' then
      begin
        if FCodeMemo.SelLength > 0 then
          FCodeMemo.SelText := listr
        else
        begin
          listr1 := FCodeMemo.Lines[FCodeMemo.CaretY];
          while Length(listr1) <= FCodeMemo.CaretX do
            listr1 := listr1 + ' ';
          System.Insert(listr, listr1, FCodeMemo.CaretX + 1);
          FCodeMemo.Lines[FCodeMemo.CaretY] := listr1;
        end;

        Modified := True;
      end;
    end;
  end
  else
  begin
    listr := InsertExpression;
    if listr <> '' then
    begin
      BeforeChange;
      FGrid.Cells[FGrid.Col, FGrid.Row].View.Memo.Text := listr;
      AfterChange;
      THackGridEx(FGrid).InvalidateCell(FGrid.Col, FGrid.Row);
    end;
  end;
end;

procedure TRMGridReportDesignerForm.btnColumnMinClick(Sender: TObject);
var
  i, lMinColumn: Integer;
  lSelection: TRect;
begin
  if FBusy then Exit;

  FBusy := True;
  AddUndoAction(acChangeCellSize);
  lSelection := FGrid.Selection;
  lMinColumn := FGrid.ColWidths[lSelection.Left];
  for i := lSelection.Left to lSelection.Right do
    lMinColumn := Min(lMinColumn, FGrid.ColWidths[i]);
  for i := lSelection.Left to lSelection.Right do
    FGrid.ColWidths[i] := lMinColumn;

  Modified := True;
  FBusy := False;
  RefreshProp;
end;

procedure TRMGridReportDesignerForm.btnColumnMaxClick(Sender: TObject);
var
  i, lMaxColumn: Integer;
  lSelection: TRect;
begin
  if FBusy then Exit;

  FBusy := True;
  AddUndoAction(acChangeCellSize);
  lSelection := FGrid.Selection;
  lMaxColumn := FGrid.ColWidths[lSelection.Left];
  for i := lSelection.Left to lSelection.Right do
    lMaxColumn := Max(lMaxColumn, FGrid.ColWidths[i]);
  for i := lSelection.Left to lSelection.Right do
    FGrid.ColWidths[i] := lMaxColumn;

  Modified := True;
  FBusy := False;
  RefreshProp;
end;

procedure TRMGridReportDesignerForm.btnRowMinClick(Sender: TObject);
var
  i, lMinRowHeight: Integer;
  lSelection: TRect;
begin
  if FBusy then Exit;

  FBusy := True;
  AddUndoAction(acChangeCellSize);
  lSelection := FGrid.Selection;
  lMinRowHeight := FGrid.RowHeights[lSelection.Top];
  for i := lSelection.Top to lSelection.Bottom do
    lMinRowHeight := Min(lMinRowHeight, FGrid.RowHeights[i]);
  for i := lSelection.Top to lSelection.Bottom do
    FGrid.RowHeights[i] := lMinRowHeight;

  Modified := True;
  FBusy := False;
  RefreshProp;
end;

procedure TRMGridReportDesignerForm.btnRowMaxClick(Sender: TObject);
var
  i, lMaxRowHeight: Integer;
  lSelection: TRect;
begin
  if FBusy then Exit;

  FBusy := True;
  AddUndoAction(acChangeCellSize);
  lSelection := FGrid.Selection;
  lMaxRowHeight := FGrid.RowHeights[lSelection.Top];
  for i := lSelection.Top to lSelection.Bottom do
    lMaxRowHeight := Max(lMaxRowHeight, FGrid.RowHeights[i]);
  for i := lSelection.Top to lSelection.Bottom do
    FGrid.RowHeights[i] := lMaxRowHeight;

  Modified := True;
  FBusy := False;
  RefreshProp;
end;

procedure TRMGridReportDesignerForm.DoClick(Sender: TObject);
var
  i, j: Integer;
  liSelection: TRect;
  liCell: TRMCellInfo;
  lFontSize: Integer;

  procedure _SetOneCell;
  begin
    case TControl(Sender).Tag of
      TAG_SetFontName:
        begin
          if ToolbarEdit.FcmbFont.ItemIndex >= 0 then
          begin
            liCell.Font.Name := ToolbarEdit.FcmbFont.Text;
            if RMIsChineseGB then
            begin
              if ByteType(liCell.Font.Name, 1) = mbSingleByte then
                liCell.Font.Charset := ANSI_CHARSET
              else
                liCell.Font.Charset := GB2312_CHARSET;
            end;
          end;
        end;
      TAG_SetFontSize:
        begin
          if ToolbarEdit.FCmbFontSize.ItemIndex >= 0 then
          begin
            lFontSize := RMGetFontSize(TComboBox(ToolbarEdit.FCmbFontSize));
            if lFontSize >= 0 then
              liCell.Font.Size := lFontSize
            else
              liCell.Font.Height := lFontSize;
          end;
        end;
      TAG_FontBold:
        begin
          if ToolbarEdit.btnFontBold.Down then
            liCell.Font.Style := liCell.Font.Style + [fsBold]
          else
            liCell.Font.Style := liCell.Font.Style - [fsBold];
        end;
      TAG_FontItalic:
        begin
          if ToolbarEdit.btnFontItalic.Down then
            liCell.Font.Style := liCell.Font.Style + [fsItalic]
          else
            liCell.Font.Style := liCell.Font.Style - [fsItalic];
        end;
      TAG_FontUnderline:
        begin
          if ToolbarEdit.btnFontUnderline.Down then
            liCell.Font.Style := liCell.Font.Style + [fsUnderline]
          else
            liCell.Font.Style := liCell.Font.Style - [fsUnderline];
        end;
      TAG_HAlignLeft..TAG_HAlignEuqal:
        begin
          liCell.HAlign := TRMHAlign(TControl(Sender).Tag - TAG_HAlignLeft);
          TRMToolbarButton(Sender).Down := True;
        end;
      TAG_FontColor:
        begin
          liCell.Font.Color := ToolbarEdit.FBtnFontColor.CurrentColor;
        end;
      TAG_VAlignTop..TAG_VAlignBottom:
        begin
          liCell.VAlign := TRMVAlign(TControl(Sender).Tag - TAG_VAlignTop);
          TRMToolbarButton(Sender).Down := True;
        end;
      TAG_SetFrameTop: liCell.View.TopFrame.Visible := ToolbarBorder.btnFrameTop.Down;
      TAG_SetFrameLeft: liCell.View.LeftFrame.Visible := ToolbarBorder.btnFrameLeft.Down;
      TAG_SetFrameBottom: liCell.View.BottomFrame.Visible := ToolbarBorder.btnFrameBottom.Down;
      TAG_SetFrameRight: liCell.View.RightFrame.Visible := ToolbarBorder.btnFrameRight.Down;
      TAG_BackColor:
        begin
          liCell.FillColor := ToolbarEdit.FBtnBackColor.CurrentColor;
        end;
      TAG_FrameColor:
        begin
          liCell.View.LeftFrame.Color := ToolbarEdit.FBtnFrameColor.CurrentColor;
          liCell.View.TopFrame.Color := ToolbarEdit.FBtnFrameColor.CurrentColor;
          liCell.View.RightFrame.Color := ToolbarEdit.FBtnFrameColor.CurrentColor;
          liCell.View.BottomFrame.Color := ToolbarEdit.FBtnFrameColor.CurrentColor;
        end;
      TAG_FrameSize:
        begin
          liCell.View.LeftFrame.mmWidth := RMToMMThousandths(StrToFloat(ToolbarEdit.FCmbFrameWidth.Text), rmutScreenPixels);
          liCell.View.TopFrame.mmWidth := liCell.View.LeftFrame.mmWidth;
          liCell.View.RightFrame.mmWidth := liCell.View.LeftFrame.mmWidth;
          liCell.View.BottomFrame.mmWidth := liCell.View.LeftFrame.mmWidth;
        end;
      TAG_SetFrame:
        begin
          liCell.View.LeftFrame.Visible := True;
          liCell.View.RightFrame.Visible := True;
          liCell.View.TopFrame.Visible := True;
          liCell.View.BottomFrame.Visible := True;
        end;
      TAG_NoFrame:
        begin
          liCell.View.LeftFrame.Visible := False;
          liCell.View.RightFrame.Visible := False;
          liCell.View.TopFrame.Visible := False;
          liCell.View.BottomFrame.Visible := False;
        end;
      TAG_Frame1:
        begin
          if liCell.StartRow = FGrid.Selection.Top then
            liCell.View.TopFrame.Visible := True;
          if liCell.StartCol = FGrid.Selection.Left then
            liCell.View.LeftFrame.Visible := True;
          if liCell.EndCol = FGrid.Selection.Right then
            liCell.View.RightFrame.Visible := True;
          if liCell.EndRow = FGrid.Selection.Bottom then
            liCell.View.BottomFrame.Visible := True;
        end;
      TAG_Frame2:
        begin
          if liCell.StartRow <> FGrid.Selection.Top then
            liCell.View.TopFrame.Visible := True;
          if liCell.StartCol <> FGrid.Selection.Left then
            liCell.View.LeftFrame.Visible := True;
          if liCell.EndCol <> FGrid.Selection.Right then
            liCell.View.RightFrame.Visible := True;
          if liCell.EndRow <> FGrid.Selection.Bottom then
            liCell.View.BottomFrame.Visible := True;
        end;
      TAG_Frame3:
        begin
          if ToolbarBorder.btnBias1Border.Down then
            liCell.View.LeftRightFrame := 4
          else
            liCell.View.LeftRightFrame := 0;
        end;
      TAG_Frame4:
        begin
          if ToolbarBorder.btnBias2Border.Down then
            liCell.View.LeftRightFrame := 1
          else
            liCell.View.LeftRightFrame := 0;
        end;
    end; {end Case}
  end;

begin
  if FBusy then Exit;

  FBusy := True;
  liSelection := FGrid.Selection;
  case TControl(Sender).Tag of
    TAG_DecWidth:
      begin
        AddUndoAction(acEdit);
        for i := liSelection.Left to liSelection.Right do
          FGrid.ColWidths[i] := FGrid.ColWidths[i] - 1;
      end;
    TAG_IncWidth:
      begin
        AddUndoAction(acEdit);
        for i := liSelection.Left to liSelection.Right do
          FGrid.ColWidths[i] := FGrid.ColWidths[i] + 1;
      end;
    TAG_DecHeight:
      begin
        AddUndoAction(acEdit);
        for i := liSelection.Top to liSelection.Bottom do
          FGrid.RowHeights[i] := FGrid.RowHeights[i] - 1;
      end;
    TAG_IncHeight:
      begin
        AddUndoAction(acEdit);
        for i := liSelection.Top to liSelection.Bottom do
          FGrid.RowHeights[i] := FGrid.RowHeights[i] + 1;
      end;
  else
    AddUndoAction(acEdit);
    for i := liSelection.Top to liSelection.Bottom do
    begin
      j := liSelection.Left;
      while j <= liSelection.Right do
      begin
        liCell := FGrid.Cells[j, i];
        if liCell.StartRow = i then
          _SetOneCell;
        j := liCell.EndCol + 1;
      end;
    end;
  end;

  Modified := True;
  FBusy := False;
  RefreshProp;
end;

procedure TRMGridReportDesignerForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  RMSetStrProp(MenuFile, 'Caption', rmRes + 154);
  RMSetStrProp(MenuFileNew, 'Caption', rmRes + 155);
  RMSetStrProp(MenuFileOpen, 'Caption', rmRes + 156);
  RMSetStrProp(MenuFileSave, 'Caption', rmRes + 157);
  RMSetStrProp(MenuFileSaveas, 'Caption', rmRes + 188);
  RMSetStrProp(MenuFileDict, 'Caption', rmRes + 158);
  RMSetStrProp(MenuFileImportDict, 'Caption', rmRes + 223);
  RMSetStrProp(MenuFileMergeDict, 'Caption', rmRes + 224);
  RMSetStrProp(MenuFileExportDict, 'Caption', rmRes + 225);
  RMSetStrProp(MenuFilePageSetup, 'Caption', rmRes + 160);
  RMSetStrProp(MenuFileHeaderFooter, 'Caption', rmRes + 874);
  RMSetStrProp(MenuFilePreview, 'Caption', rmRes + 161);
  RMSetStrProp(MenuFilePreview1, 'Caption', rmRes + 877);
  RMSetStrProp(MenuFilePrint, 'Caption', rmRes + 159);
  RMSetStrProp(MenuFileProp, 'Caption', rmRes + 216);
  RMSetStrProp(MenuFileExit, 'Caption', rmRes + 162);

  RMSetStrProp(MenuEdit, 'Caption', rmRes + 163);
  RMSetStrProp(MenuEditMerge, 'Caption', rmRes + 805);
  RMSetStrProp(MenuEditReverse, 'Caption', rmRes + 806);

  RMSetStrProp(MenuEditCopyPage, 'Caption', rmRes + 861);
  RMSetStrProp(MenuEditPastePage, 'Caption', rmRes + 862);

  RMSetStrProp(MenuEditAddPage, 'Caption', rmRes + 172);
  RMSetStrProp(MenuEditAddForm, 'Caption', rmRes + 192);
  RMSetStrProp(MenuEditDeletePage, 'Caption', rmRes + 173);
  RMSetStrProp(MenuEditCut, 'Caption', rmRes + 166);
  RMSetStrProp(MenuEditCopy, 'Caption', rmRes + 167);
  RMSetStrProp(MenuEditPaste, 'Caption', rmRes + 168);
  RMSetStrProp(MenuEditDelete, 'Caption', rmRes + 169);
  RMSetStrProp(MenuEditSelectAll, 'Caption', rmRes + 170);
  RMSetStrProp(MenuEditUndo, 'Caption', rmRes + 164);
  RMSetStrProp(MenuEditRedo, 'Caption', rmRes + 165);

  RMSetStrProp(MenuEditToolbar, 'Caption', rmRes + 177);
  RMSetStrProp(MenuEditOptions, 'Caption', rmRes + 179);
  RMSetStrProp(itmToolbarStandard, 'Caption', rmRes + 181);
  RMSetStrProp(itmToolbarText, 'Caption', rmRes + 182);
  RMSetStrProp(itmToolbarBorder, 'Caption', rmRes + 180);
  RMSetStrProp(itmToolbarInspector, 'Caption', rmRes + 184);
  RMSetStrProp(itmToolbarInsField, 'Caption', rmRes + 110);
  //  RMSetStrProp(itmToolbarGrid, 'Caption', rmRes + 0);
  RMSetStrProp(itmToolbarCellEdit, 'Caption', rmRes + 866);

  RMSetStrProp(MenuCell, 'Caption', rmRes + 807);
  RMSetStrProp(MenuCellProperty, 'Caption', rmRes + 694);
  RMSetStrProp(MenuCellInsertColumn, 'Caption', rmRes + 801);
  RMSetStrProp(MenuCellInsertRow, 'Caption', rmRes + 802);
  RMSetStrProp(MenuCellDeleteColumn, 'Caption', rmRes + 803);
  RMSetStrProp(MenuCellDeleteRow, 'Caption', rmRes + 804);
  RMSetStrProp(MenuCellTableSize, 'Caption', rmRes + 692);
  RMSetStrProp(MenuCellRow, 'Caption', rmRes + 245);
  RMSetStrProp(MenuCellColumn, 'Caption', rmRes + 246);
  RMSetStrProp(itmRowHeight, 'Caption', rmRes + 247);
  RMSetStrProp(itmAverageRowHeight, 'Caption', rmRes + 248);
  RMSetStrProp(itmColumnHeight, 'Caption', rmRes + 249);
  RMSetStrProp(itmAverageColumnWidth, 'Caption', rmRes + 250);
  RMSetStrProp(MenuCellInsertCell, 'Caption', rmRes + 252);
  RMSetStrProp(itmInsertCellLeft, 'Caption', rmRes + 808);
  RMSetStrProp(itmInsertCellTop, 'Caption', rmRes + 810);
  RMSetStrProp(SelectionMenu_popCut, 'Caption', rmRes + 166);
  RMSetStrProp(SelectionMenu_popCopy, 'Caption', rmRes + 167);
  RMSetStrProp(SelectionMenu_popPaste, 'Caption', rmRes + 168);
//  RMSetStrProp(SelectionMenu_popInsert, 'Caption', rmRes + 169);
//  RMSetStrProp(SelectionMenu_popDelete, 'Caption', rmRes + 169);

  RMSetStrProp(MenuHelp, 'Caption', rmRes + 190);
  RMSetStrProp(MenuHelpContents, 'Caption', rmRes + 189);
  RMSetStrProp(MenuHelpAbout, 'Caption', rmRes + 187);

  RMSetStrProp(itmGridMenuBandProp, 'Caption', rmRes + 875);
  RMSetStrProp(itmCellProp, 'Caption', rmRes + 694);
  RMSetStrProp(itmMergeCells, 'Caption', rmRes + 805);
  RMSetStrProp(itmSplitCells, 'Caption', rmRes + 806);
  RMSetStrProp(itmInsert, 'Caption', rmRes + 702);
  RMSetStrProp(itmInsertLeftColumn, 'Caption', rmRes + 808);
  RMSetStrProp(itmInsertRightColumn, 'Caption', rmRes + 809);
  RMSetStrProp(itmInsertTopRow, 'Caption', rmRes + 810);
  RMSetStrProp(itmInsertBottomRow, 'Caption', rmRes + 811);
  RMSetStrProp(itmDelete, 'Caption', rmRes + 350);
  RMSetStrProp(itmDeleteColumn, 'Caption', rmRes + 812);
  RMSetStrProp(itmDeleteRow, 'Caption', rmRes + 813);
  RMSetStrProp(itmCellType, 'Caption', rmRes + 814);
  RMSetStrProp(itmFrameType, 'Caption', rmRes + 214);
  RMSetStrProp(itmEdit, 'Caption', rmRes + 153);
  RMSetStrProp(padpopClearContents, 'Caption', rmRes + 881);
  RMSetStrProp(itmMemoView, 'Caption', rmRes + 133);
  RMSetStrProp(itmCalcMemoView, 'Caption', rmRes + 197);
  RMSetStrProp(itmPictureView, 'Caption', rmRes + 135);
  RMSetStrProp(itmSubReportView, 'Caption', rmRes + 136);
  RMSetStrProp(itmInsertBand, 'Caption', rmRes + 860);
  RMSetStrProp(itmSelectBand, 'Caption', rmRes + 876);
end;

function TRMGridReportDesignerForm.HaveBand(aBandType: TRMBandType): Boolean;
var
  i: Integer;
  t: TRMView;
begin
  Result := False;
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.IsBand then
    begin
      if aBandType = TRMCustomBandView(t).BandType then
      begin
        Result := True;
        break;
      end;
    end;
  end;
end;

function TRMGridReportDesignerForm.GetModified: Boolean;
begin
  Result := Report.Modified;
end;

procedure TRMGridReportDesignerForm.SetModified(Value: Boolean);
begin
  if Report.Modified = Value then Exit;
  Report.Modified := Value;
  if Value and (not IsPreviewDesign) then
    Report.ComponentModified := True;
  ToolbarStandard.btnFileSave.Enabled := (not IsPreviewDesign) and Value;
  MenuFileSave.Enabled := ToolbarStandard.btnFileSave.Enabled;
end;

procedure TRMGridReportDesignerForm.SetFactor(Value: Integer);
begin
  FFactor := 100;
end;

function TRMGridReportDesignerForm.GetDesignerRestrictions: TRMDesignerRestrictions;
begin
  if FDesignerComp <> nil then
    Result := FDesignerComp.DesignerRestrictions
  else
    Result := [];
end;

procedure TRMGridReportDesignerForm.SetDesignerRestrictions(Value: TRMDesignerRestrictions);
begin
  if FDesignerComp <> nil then
    FDesignerComp.DesignerRestrictions := Value;
end;

procedure TRMGridReportDesignerForm.BeforeChange;
begin
  AddUndoAction(acEdit);
  Modified := True;
end;

procedure TRMGridReportDesignerForm.AfterChange;
begin
  if (Page <> nil) and (Page is TRMDialogPage) then
  begin
    FWorkSpace.DrawPage(dmSelection);
    FWorkSpace.Draw(TopSelected, 0);
  end;
  SelectionChanged(True);
end;

function TRMGridReportDesignerForm.InsertDBField: string;
var
  tmp: TRMFieldsForm;
begin
  Result := '';
  tmp := TRMFieldsForm.Create(nil);
  try
    tmp.chkUseTableName.Checked := UseTableName;
    if tmp.ShowModal = mrOk then
    begin
      if tmp.SelectedField <> '' then
        Result := '[' + tmp.SelectedField + ']';
      UseTableName := tmp.chkUseTableName.Checked;
    end;
  finally
    tmp.Free;
  end;
end;

function TRMGridReportDesignerForm.InsertExpression: string;
var
  str: string;
begin
  Result := '';
  if RM_EditorExpr.RMGetExpression('', str, nil, False) then
  begin
    Result := str;
    if Result <> '' then
    begin
      if not ((Result[1] = '[') and (Result[Length(Result)] = ']') and
        (Pos('[', Copy(Result, 2, 999999)) = 0)) then
        Result := '[' + Result + ']';
    end;
  end;
end;

procedure TRMGridReportDesignerForm.SetGridProp;
begin
  FGrid.Parent := Panel2;
  if RMIsChineseGB then
    FGrid.ColWidths[0] := 80
  else
    FGrid.ColWidths[0] := 120;

  if (Page <> nil) and (Page is TRMGridReportPage) then
    FGrid.AutoCreateName := TRMGridReportPage(Page).AutoCreateName
  else
    FGrid.AutoCreateName := True;

  FGrid.Align := alClient;
  FGrid.PopupMenu := SelectionMenu;
  FGrid.OnDblClick := OnGridDblClickEvent;
  FGrid.OnClick := OnGridClick;
  FGrid.OnChange := OnGridChange;
  FGrid.OnDragOver := OnGridDragOver;
  FGrid.OnDragDrop := OnGridDragDrop;
  FGrid.OnRowHeaderClick := OnGridRowHeaderClick;
  FGrid.OnRowHeaderDblClick := OnGridRowHeaderDblClick;
  FGrid.OnBeginSizingCell := OnGridBeginSizingCell;
  FGrid.OnKeyDown := OnGridKeyDown;
  FGrid.OnBeforeChangeCell := OnGridBeforeChangeCell;

  SetGridHeader;
end;

procedure TRMGridReportDesignerForm.SetGridNilProp;
begin
  if FGrid <> nil then
  begin
    FGrid.Parent := nil;
    FGrid.Align := alNone;
    FGrid.PopupMenu := nil;
    FGrid.OnDblClick := nil;
    FGrid.OnClick := nil;
    FGrid.OnSelectCell := nil;
    FGrid.OnChange := nil;
    FGrid.OnDragOver := nil;
    FGrid.OnDragDrop := nil;
    FGrid.OnRowHeaderClick := nil;
    FGrid.OnRowHeaderDblClick := nil;
    FGrid.OnBeginSizingCell := nil;
    FGrid.OnKeyDown := nil;
    FGrid.AutoCreateName := True;
    FGrid.OnBeforeChangeCell := nil;
  end;
  FGrid := nil;
end;

procedure TRMGridReportDesignerForm.RefreshProp;
begin
  FGrid.InvalidateGrid;
  FillInspFields;
  SelectionChanged(True);
end;

procedure TRMGridReportDesignerForm.MemoViewEditor(t: TRMView);
begin
  if TRMEditorForm(EditorForm).ShowEditor(t) = mrOk then
  begin
  end;
end;

procedure TRMGridReportDesignerForm.RMFontEditor(Sender: TObject);
var
  t: TRMView;
  i: Integer;
  liFontDialog: TFontDialog;
  liList: TList;
begin
  t := PageObjects[TopSelected];
  if not (t is TRMCustomMemoView) then Exit;

  liFontDialog := TFontDialog.Create(nil);
  try
    liFontDialog.Font.Assign(TRMCustomMemoView(t).Font);
    if liFontDialog.Execute then
    begin
      BeforeChange;
      liList := PageObjects;
      for i := 0 to liList.Count - 1 do
      begin
        t := liList[i];
        if t.Selected and (t is TRMCustomMemoView) then
          TRMCustomMemoView(t).Font.Assign(liFontDialog.Font);
      end;
      AfterChange;
    end;
  finally
    liFontDialog.Free;
  end;
end;

procedure TRMGridReportDesignerForm.RMDisplayFormatEditor(Sender: TObject);
var
  t: TRMView;
  tmp: TRMDisplayFormatForm;
begin
  t := PageObjects[TopSelected];
  if not (t is TRMCustomMemoView) then Exit;

  tmp := TRMDisplayFormatForm.Create(nil);
  try
    tmp.ShowEditor(t);
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.PictureViewEditor(t: TRMView);
var
  tmp: TRMPictureEditorForm;
begin
  tmp := TRMPictureEditorForm.Create(nil);
  try
    if tmp.ShowEditor(t) = mrOK then
    begin
      BeforeChange;
      AfterChange;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.RMCalcMemoEditor(Sender: TObject);
var
  tmp: TRMCalcMemoEditorForm;
begin
  tmp := TRMCalcMemoEditorForm.Create(nil);
  try
    tmp.ShowEditor(PageObjects[TopSelected]);
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.OnGridChange(Sender: TObject);
begin
  Modified := True;
end;

procedure TRMGridReportDesignerForm.SetGridHeader;
var
  i: Integer;
  t: TRMView;
begin
  if FGrid = nil then Exit;

  for i := 1 to FGrid.RowCount - 1 do
  begin
    t := TRMGridReportPage(Page).RowBandViews[i];
    if t <> nil then
      FGrid.Cells[0, i].Text := RMBandNames[TRMCustomBandView(t).BandType]
    else
      FGrid.Cells[0, i].Text := '';
  end;
end;

procedure TRMGridReportDesignerForm.OnGridBeginSizingCell(Sender: TObject);
begin
  AddUndoAction(acChangeCellSize);
end;

procedure TRMGridReportDesignerForm.OnGridBeforeChangeCell(aGrid: TRMGridEx;
  aCell: TRMCellInfo);
begin
  Modified := True;
  AddUndoAction(acEdit);
  //  AddUndoAction(acChangeCellSize);
end;

procedure TRMGridReportDesignerForm.OnGridDblClickEvent(Sender: TObject);
var
  lCell: TRMCellInfo;
begin
  lCell := FGrid.GetCellInfo(FGrid.Selection.Left, FGrid.Selection.Top);
  if lCell.View is TRMSubReportView then
  begin
    CurPage := TRMSubReportView(lCell.View).SubPage;
  end
  else
    lCell.View.ShowEditor;
end;

procedure TRMGridReportDesignerForm.OnGridClick(Sender: TObject);
var
  lSelection: TRect;
  lCell: TRMCellInfo;
  lCol, lRow: Integer;
  t: TRMView;
begin
  if FBusy or (FGrid = nil) then Exit;
  if (FGrid.Col < 1) or (FGrid.Row < 1) then Exit;

  FBusy := True;
  t := TRMGridReportPage(Page).RowBandViews[FGrid.Row];
  if t <> nil then
    ToolbarBorder.cmbBands.ItemIndex := ToolbarBorder.cmbBands.Items.IndexOf(RMBandNames[TRMCustomBandView(t).BandType] + '(' + t.Name + ')')
  else
    ToolbarBorder.cmbBands.ItemIndex := 0;

  if FGrid.HeaderClick then
  begin
    FBusy := False;
    if t <> nil then
      InspSelectionChanged(t.Name);
    Exit;
  end;

  try
    UnSelectAll;
    lSelection := FGrid.Selection;
    for lCol := lSelection.Left to lSelection.Right do
    begin
      for lRow := lSelection.Top to lSelection.Bottom do
      begin
        lCell := FGrid.Cells[lCol, lRow];
        if (lCell.StartCol = lCol) and (lCell.StartRow = lRow) then
        begin
          Inc(SelNum);
          lCell.View.Selected := True;
        end;
      end;
    end;
  finally
    FBusy := False;
    SelectionChanged(True);
  end;
end;

procedure TRMGridReportDesignerForm.OnGridDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept := (Source = FFieldForm.lstFields) and (DesignerRestrictions * [rmdrDontCreateObj] = []);
end;

procedure TRMGridReportDesignerForm.OnGridDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  liCol, liRow: Integer;
  liCell: TRMCellInfo;
begin
  FGrid.MouseToCell(X, Y, liCol, liRow);
  if (liCol >= 1) and (liRow >= 1) then
  begin
    liCell := FGrid.Cells[liCol, liRow];
    if liCell.View is TRMCustomMemoView then
    begin
      BeforeChange;
      liCell.Text := '[' + FFieldForm.DBField + ']';
      FGrid.InvalidateGrid;
      AfterChange;
    end;
  end;
end;

procedure TRMGridReportDesignerForm.OnGridRowHeaderClick(Sender: TObject);
var
  lBand: TRMView;
begin
  if FBusy then Exit;

  lBand := TRMGridReportPage(Page).RowBandViews[FGrid.Row];
  if lBand <> nil then
  begin
    ToolbarBorder.cmbBands.ItemIndex := ToolbarBorder.cmbBands.Items.IndexOf(RMBandNames[TRMCustomBandView(lBand).BandType] + '(' + lBand.Name + ')');
    UnSelectAll;
    SelNum := 1;
    lBand.Selected := True;
    ShowPosition;
  end
  else
  begin
    ToolbarBorder.cmbBands.ItemIndex := 0;
    FGrid.HeaderClick := False;
  end;
end;

procedure TRMGridReportDesignerForm.OnGridRowHeaderDblClick(Sender: TObject);
var
  t: TRMView;

  procedure _EditDataBand;
  begin
    with TRMBandEditorForm.Create(nil) do
    begin
      ShowEditor(t);
      Free;
    end;
  end;

  procedure _EditGroupHeaderBand;
  begin
    with TRMGroupEditorForm.Create(nil) do
    begin
      ShowEditor(t);
      Free;
    end;
  end;

begin
  t := TRMGridReportPage(Page).RowBandViews[FGrid.Row];
  if t <> nil then
  begin
    InspSelectionChanged(t.Name);
    if (t is TRMBandMasterData) or (t is TRMBandDetailData) then
      _EditDataBand
    else if t is TRMBandGroupHeader then
      _EditGroupHeaderBand;
  end;
end;

procedure TRMGridReportDesignerForm.FormCreate(Sender: TObject);
var
  i: Integer;
  liMenuItem: TRMMenuItem;

  procedure _CreateTabPanel;
  begin
    Tab1 := TRMTabControl.Create(Self);
    with Tab1 do
    begin
      Name := 'Tab1';
      Parent := Self;
      Align := alClient;
      HotTrack := True;
      MultiLine := True;
      TabOrder := 0;
      AddTab('Page1');
      TabIndex := 0;
      TabStop := False;
      OnChange := Tab1Change;
      OnChanging := Tab1Changing;
      OnDragDrop := Tab1DragDrop;
      OnDragOver := Tab1DragOver;
      OnMouseDown := Tab1MouseDown;
      OnMouseMove := Tab1MouseMove;
      OnMouseUp := Tab1MouseUp;
    end;

    Panel2 := TRMPanel.Create(Self);
    with Panel2 do
    begin
      Name := 'Panel2';
      Parent := Tab1;
      Caption := '';
      Align := alClient;
      BevelOuter := bvLowered;
      TabOrder := 0;
    end;
  end;

  procedure _CreateDock;
  begin
    Dock971 := TRMDock.Create(Self);
    with Dock971 do
    begin
      Parent := Self;
      FixAlign := True;
      Position := dpTop;
      Name := 'GridReport_Dock971';
      OnRequestDock := OnDockRequestDockEvent;
    end;
    Dock972 := TRMDock.Create(Self);
    with Dock972 do
    begin
      Parent := Self;
      FixAlign := True;
      Position := dpLeft;
      Name := 'GridReport_Dock972';
    end;
    Dock973 := TRMDock.Create(Self);
    with Dock973 do
    begin
      Parent := Self;
      FixAlign := True;
      Position := dpRight;
      Name := 'GridReport_Dock973';
    end;
    Dock974 := TRMDock.Create(Self);
    with Dock974 do
    begin
      Parent := Self;
      FixAlign := True;
      Position := dpBottom;
      Name := 'GridReport_Dock974';
      OnRequestDock := OnDockRequestDockEvent;
    end;
  end;

  //Create MenuBar
  procedure _CreateMenubar;

    procedure _AddItem(AOwner: TRMMenuItem; AItem: TRMMenuItem); overload;
    begin
      AOwner.Add(AItem);
    end;

    procedure _AddItem(AOwner: TRMCustomMenuItem; AItem: TRMSubMenuItem); overload;
    begin
      AOwner.Add(AItem);
    end;

    procedure _AddItem(AOwner: TRMSubmenuItem; AItem: TRMSubMenuItem); overload;
    begin
      AOwner.Add(AItem);
    end;

    procedure _AddItem(AOwner: TRMSubMenuItem; AItem: TRMMenuItem); overload;
    begin
      AOwner.Add(AItem);
    end;

    procedure _AddItem(AOwner: TRMSubMenuItem; AItem: TRMSeparatorMenuItem); overload;
    begin
      AOwner.Add(AItem);
    end;

    procedure _AddItem(AOwner: TRMCustomMenuItem; AItem: TRMCustomMenuItem); overload;
    begin
      AOwner.Add(AItem);
    end;

  begin
    MenuBar := TRMMenuBar.Create(Self);
    {$IFNDEF USE_TB2K}
    MenuBar.AutoHotkeys := maManual;
    {$ENDIF}

    MenuFile := TRMSubmenuItem.Create(Self);
    MenuFileNew := TRMmenuItem.Create(Self);
    MenuFileOpen := TRMmenuItem.Create(Self);
    MenuFileSave := TRMmenuItem.Create(Self);
    MenuFileSaveas := TRMmenuItem.Create(Self);
    N2 := TRMSeparatorMenuItem.Create(Self);
    MenuFileDict := TRMmenuItem.Create(Self);
    MenuFileImportDict := TRMmenuItem.Create(Self);
    MenuFileMergeDict := TRMmenuItem.Create(Self);
    MenuFileExportDict := TRMmenuItem.Create(Self);
    N1 := TRMSeparatorMenuItem.Create(Self);
    MenuFilePageSetup := TRMmenuItem.Create(Self);
    MenuFileHeaderFooter := TRMMenuItem.Create(Self);
    MenuFilePreview1 := TRMmenuItem.Create(Self);
    MenuFilePreview := TRMmenuItem.Create(Self);
    MenuFilePrint := TRMmenuItem.Create(Self);
    N7 := TRMSeparatorMenuItem.Create(Self);
    MenuFileProp := TRMmenuItem.Create(Self);
    N13 := TRMSeparatorMenuItem.Create(Self);
    MenuFileFile1 := TRMmenuItem.Create(Self);
    MenuFileFile2 := TRMmenuItem.Create(Self);
    MenuFileFile3 := TRMmenuItem.Create(Self);
    MenuFileFile4 := TRMmenuItem.Create(Self);
    MenuFileFile5 := TRMmenuItem.Create(Self);
    MenuFileFile6 := TRMmenuItem.Create(Self);
    MenuFileFile7 := TRMmenuItem.Create(Self);
    MenuFileFile8 := TRMmenuItem.Create(Self);
    MenuFileFile9 := TRMmenuItem.Create(Self);
    N5 := TRMSeparatorMenuItem.Create(Self);
    MenuFileExit := TRMmenuItem.Create(Self);

    MenuEdit := TRMSubmenuItem.Create(Self);
    MenuEditUndo := TRMmenuItem.Create(Self);
    MenuEditRedo := TRMmenuItem.Create(Self);
    N12 := TRMSeparatorMenuItem.Create(Self);
    MenuEditCut := TRMmenuItem.Create(Self);
    MenuEditCopy := TRMmenuItem.Create(Self);
    MenuEditPaste := TRMmenuItem.Create(Self);
    MenuEditDelete := TRMmenuItem.Create(Self);
    MenuEditSelectAll := TRMmenuItem.Create(Self);
    N11 := TRMSeparatorMenuItem.Create(Self);
    MenuEditCopyPage := TRMmenuItem.Create(Self);
    MenuEditPastePage := TRMmenuItem.Create(Self);
    N14 := TRMSeparatorMenuItem.Create(Self);
    MenuEditAddPage := TRMmenuItem.Create(Self);
    MenuEditAddForm := TRMmenuItem.Create(Self);
    MenuEditDeletePage := TRMmenuItem.Create(Self);
    N9 := TRMSeparatorMenuItem.Create(Self);

    MenuEditToolbar := TRMSubmenuItem.Create(Self);
    itmToolbarStandard := TRMmenuItem.Create(Self);
    itmToolbarText := TRMmenuItem.Create(Self);
    itmToolbarBorder := TRMmenuItem.Create(Self);
    itmToolbarGrid := TRMmenuItem.Create(Self);
    itmToolbarInspector := TRMmenuItem.Create(Self);
    itmToolbarInsField := TRMmenuItem.Create(Self);
    itmToolbarCellEdit := TRMMenuItem.Create(Self);

    MenuEditOptions := TRMmenuItem.Create(Self);

    barSearch := TRMSubmenuItem.Create(Self);
    with barSearch do
    begin
      Caption := RMLoadStr(rmRes + 254);
      //      Visible := False;
    end;
    padSearchFind := TRMMenuItem.Create(Self);
    with padSearchFind do
    begin
      Caption := RMLoadStr(rmRes + 255);
      //      ImageIndex := 0;
      //      Images := ImageListStand;
      ShortCut := Menus.ShortCut(Word('F'), [ssCtrl]);
      OnClick := padSearchFindClick;
      AddToMenu(barSearch);
    end;
    padSearchReplace := TRMMenuItem.Create(Self);
    with padSearchReplace do
    begin
      Caption := RMLoadStr(rmRes + 256);
      //      ImageIndex := 0;
      //      Images := ImageListStand;
      ShortCut := Menus.ShortCut(Word('R'), [ssCtrl]);
      OnClick := padSearchReplaceClick;
      AddToMenu(barSearch);
    end;
    padSearchFindAgain := TRMMenuItem.Create(Self);
    with padSearchFindAgain do
    begin
      Caption := RMLoadStr(rmRes + 257);
      //      ImageIndex := 0;
      //      Images := ImageListStand;
      ShortCut := Menus.TextToShortCut('F3');
      OnClick := padSearchFindAgainClick;
      AddToMenu(barSearch);
    end;

    MenuCell := TRMSubmenuItem.Create(Self);
    MenuCellProperty := TRMmenuItem.Create(Self);
    MenuCellTableSize := TRMmenuItem.Create(Self);
    MenuCellRow := TRMSubmenuItem.Create(Self);
    itmRowHeight := TRMmenuItem.Create(Self);
    itmAverageRowHeight := TRMmenuItem.Create(Self);
    MenuCellColumn := TRMSubmenuItem.Create(Self);
    itmColumnHeight := TRMmenuItem.Create(Self);
    itmAverageColumnWidth := TRMmenuItem.Create(Self);
    N8 := TRMSeparatorMenuItem.Create(Self);
    MenuCellInsertCell := TRMSubmenuItem.Create(Self);
    itmInsertCellLeft := TRMmenuItem.Create(Self);
    itmInsertCellTop := TRMmenuItem.Create(Self);
    MenuCellInsertColumn := TRMmenuItem.Create(Self);
    MenuCellInsertRow := TRMmenuItem.Create(Self);
    MenuCellDeleteColumn := TRMmenuItem.Create(Self);
    MenuCellDeleteRow := TRMmenuItem.Create(Self);
    N18 := TRMSeparatorMenuItem.Create(Self);
    MenuEditMerge := TRMmenuItem.Create(Self);
    MenuEditReverse := TRMmenuItem.Create(Self);
    MenuHelp := TRMSubmenuItem.Create(Self);
    MenuHelpContents := TRMmenuItem.Create(Self);
    N1111 := TRMSeparatorMenuItem.Create(Self);
    MenuHelpAbout := TRMmenuItem.Create(Self);

    MenuFile.AddToMenu(MenuBar);
    MenuFileNew.AddToMenu(MenuFile);
    MenuFileOpen.AddToMenu(MenuFile);
    MenuFileSave.AddToMenu(MenuFile);
    MenuFileSaveas.AddToMenu(MenuFile);
    N2.AddToMenu(MenuFile);
    MenuFileDict.AddToMenu(MenuFile);
    MenuFileImportDict.AddToMenu(MenuFile);
    MenuFileMergeDict.AddToMenu(MenuFile);
    MenuFileExportDict.AddToMenu(MenuFile);
    N1.AddToMenu(MenuFile);
    MenuFilePageSetup.AddToMenu(MenuFile);
    MenuFileHeaderFooter.AddToMenu(MenuFile);
    MenuFilePreview1.AddToMenu(MenuFile);
    MenuFilePreview.AddToMenu(MenuFile);
    MenuFilePrint.AddToMenu(MenuFile);
    N7.AddToMenu(MenuFile);
    MenuFileProp.AddToMenu(MenuFile);
    N13.AddToMenu(MenuFile);
    MenuFileFile1.AddToMenu(MenuFile);
    MenuFileFile2.AddToMenu(MenuFile);
    MenuFileFile3.AddToMenu(MenuFile);
    MenuFileFile4.AddToMenu(MenuFile);
    MenuFileFile5.AddToMenu(MenuFile);
    MenuFileFile6.AddToMenu(MenuFile);
    MenuFileFile7.AddToMenu(MenuFile);
    MenuFileFile8.AddToMenu(MenuFile);
    MenuFileFile9.AddToMenu(MenuFile);
    N5.AddToMenu(MenuFile);
    MenuFileExit.AddToMenu(MenuFile);

    MenuEdit.AddToMenu(MenuBar);
    barSearch.AddToMenu(MenuBar);

    MenuEditUndo.AddToMenu(MenuEdit);
    MenuEditRedo.AddToMenu(MenuEdit);
    N12.AddToMenu(MenuEdit);
    MenuEditCut.AddToMenu(MenuEdit);
    MenuEditCopy.AddToMenu(MenuEdit);
    MenuEditPaste.AddToMenu(MenuEdit);
    MenuEditDelete.AddToMenu(MenuEdit);
    MenuEditSelectAll.AddToMenu(MenuEdit);
    N11.AddToMenu(MenuEdit);
    MenuEditCopyPage.AddToMenu(MenuEdit);
    MenuEditPastePage.AddToMenu(MenuEdit);
    N14.AddToMenu(MenuEdit);
    MenuEditAddPage.AddToMenu(MenuEdit);
    MenuEditAddForm.AddToMenu(MenuEdit);
    MenuEditDeletePage.AddToMenu(MenuEdit);
    N9.AddToMenu(MenuEdit);

    MenuEditToolbar.AddToMenu(MenuEdit);
    itmToolbarStandard.AddToMenu(MenuEditToolBar);
    itmToolbarText.AddToMenu(MenuEditToolBar);
    itmToolbarBorder.AddToMenu(MenuEditToolBar);
    itmToolbarCellEdit.AddToMenu(MenuEditToolbar);
    itmToolbarGrid.AddToMenu(MenuEditToolBar);
    itmToolbarInspector.AddToMenu(MenuEditToolBar);
    itmToolbarInsField.AddToMenu(MenuEditToolBar);

    MenuEditOptions.AddToMenu(MenuEdit);
    MenuCell.AddToMenu(MenuBar);
    MenuCellProperty.AddToMenu(MenuCell);
    MenuCellTableSize.AddToMenu(MenuCell);
    MenuCellRow.AddToMenu(MenuCell);
    itmRowHeight.AddToMenu(MenuCellRow);
    itmAverageRowHeight.AddToMenu(MenuCellRow);
    MenuCellColumn.AddToMenu(MenuCell);
    itmColumnHeight.AddToMenu(MenuCellColumn);
    itmAverageColumnWidth.AddToMenu(MenuCellColumn);
    N8.AddToMenu(MenuCell);
    MenuCellInsertCell.AddToMenu(MenuCell);
    itmInsertCellLeft.AddToMenu(MenuCellInsertCell);
    itmInsertCellTop.AddToMenu(MenuCellInsertCell);
    MenuCellInsertColumn.AddToMenu(MenuCell);
    MenuCellInsertRow.AddToMenu(MenuCell);
    MenuCellDeleteColumn.AddToMenu(MenuCell);
    MenuCellDeleteRow.AddToMenu(MenuCell);
    N18.AddToMenu(MenuCell);
    MenuEditMerge.AddToMenu(MenuCell);
    MenuEditReverse.AddToMenu(MenuCell);

    MenuHelp.AddToMenu(MenuBar);
    MenuHelpContents.AddToMenu(MenuHelp);
    N1111.AddToMenu(MenuHelp);
    MenuHelpAbout.AddToMenu(MenuHelp);

    with MenuBar do
    begin
      Parent := self;
      Name := 'MenuBar';
      Caption := RMLoadStr(rmRes + 251);
      MenuBar := true;
      Dockedto := Dock971;
    end;

    with MenuFile do
    begin
      Caption := 'File';
    end;
    with MenuFileNew do
    begin
      ImageIndex := 0;
      Images := ImageListStand;
      Caption := 'New...';
      OnClick := MenuFileNewClick;
    end;
    with MenuFileOpen do
    begin
      ImageIndex := 1;
      Images := ImageListStand;
      Caption := 'Open...';
      OnClick := MenuFileOpenClick;
    end;
    with MenuFileSave do
    begin
      ImageIndex := 2;
      Images := ImageListStand;
      Caption := 'Save';
      OnClick := MenuFileSaveClick;
    end;
    with MenuFileSaveas do
    begin
      Caption := 'Save as...';
      OnClick := MenuFileSaveasClick;
    end;
    with MenuFileDict do
    begin
      Caption := 'Dictionary...';
      OnClick := MenuFileDictClick;
    end;
    with MenuFileImportDict do
    begin
      Caption := 'Import Dictionary...';
      OnClick := MenuFileImportDictClick;
    end;
    with MenuFileMergeDict do
    begin
      Caption := 'Merge Dictionary...';
      OnClick := MenuFileMergeDictClick;
    end;
    with MenuFileExportDict do
    begin
      Caption := 'Export Dictionary...';
      OnClick := MenuFileExportDictClick;
    end;
    with MenuFilePageSetup do
    begin
      ImageIndex := 16;
      Images := ImageListStand;
      Caption := 'Page Options...';
      OnClick := MenuFilePageSetupClick;
    end;
    with MenuFileHeaderFooter do
    begin
      ImageIndex := -1;
      Images := ImageListStand;
      Caption := 'Header/Footer...';
      OnClick := MenuFileHeaderFooterClick;
    end;
    with MenuFilePreview do
    begin
      ImageIndex := 4;
      Images := ImageListStand;
      Caption := 'Preview...';
      OnClick := MenuFilePreviewClick;
    end;
    with MenuFilePreview1 do
    begin
      ImageIndex := 29;
      Images := ImageListStand;
      Caption := 'Preview template';
      OnClick := MenuFilePreview1Click;
    end;
    with MenuFilePrint do
    begin
      ImageIndex := 3;
      Images := ImageListStand;
      Caption := 'Print...';
      OnClick := MenuFilePrintClick;
    end;
    with MenuFileProp do
    begin
      Caption := 'Property...';
      OnClick := MenuFilePropClick;
    end;
    with MenuFileFile1 do
    begin
      Tag := 1;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileFile2 do
    begin
      Tag := 2;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileFile3 do
    begin
      Tag := 3;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileFile4 do
    begin
      Tag := 4;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileFile5 do
    begin
      Tag := 5;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileFile6 do
    begin
      Tag := 6;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileFile7 do
    begin
      Tag := 7;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileFile8 do
    begin
      Tag := 8;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileFile9 do
    begin
      Tag := 9;
      OnClick := MenuFileFile9Click;
    end;
    with MenuFileExit do
    begin
      ImageIndex := 20;
      Images := ImageListStand;
      Caption := 'Exit';
      OnClick := MenuFileExitClick;
    end;
    with MenuEdit do
    begin
      Caption := 'Edit';
    end;
    with MenuEditUndo do
    begin
      ImageIndex := 8;
      Images := ImageListStand;
      Caption := 'Undo';
      ShortCut := Menus.ShortCut(Ord('Z'), [ssCtrl]);
      OnClick := MenuEditUndoClick;
    end;
    with MenuEditRedo do
    begin
      ImageIndex := 9;
      Images := ImageListStand;
      Caption := 'Redo';
      ShortCut := Menus.ShortCut(Ord('Z'), [ssShift, ssCtrl]);
      OnClick := MenuEditRedoClick;
    end;
    with MenuEditCut do
    begin
      ImageIndex := 5;
      Images := ImageListStand;
      Caption := 'Cut';
      ShortCut := 16472;
      OnClick := MenuEditCutClick;
    end;
    with MenuEditCopy do
    begin
      ImageIndex := 6;
      Images := ImageListStand;
      Caption := 'Copy';
      ShortCut := 16451;
      OnClick := MenuEditCopyClick;
    end;
    with MenuEditPaste do
    begin
      ImageIndex := 7;
      Images := ImageListStand;
      Caption := 'Paste';
      ShortCut := 16470;
      OnClick := MenuEditPasteClick;
    end;
    with MenuEditDelete do
    begin
      ImageIndex := 22;
      Images := ImageListStand;
      Caption := 'Delete';
      ShortCut := 16430;
      OnClick := MenuEditDeleteClick;
    end;
    with MenuEditSelectAll do
    begin
      ImageIndex := 12;
      Images := ImageListStand;
      Caption := 'Select All';
      ShortCut := 16449;
      OnClick := MenuEditSelectAllClick;
    end;
    with MenuEditCopyPage do
    begin
      Caption := 'Copy Page';
      OnClick := MenuEditCopyPageClick;
    end;
    with MenuEditPastePage do
    begin
      Caption := 'Paste Page';
      OnClick := MenuEditPastePageClick;
    end;
    with MenuEditAddPage do
    begin
      ImageIndex := 13;
      Images := ImageListStand;
      Caption := 'Add Page';
      OnClick := btnAddPageClick;
    end;
    with MenuEditAddForm do
    begin
      ImageIndex := 14;
      Images := ImageListStand;
      Caption := 'Add Form';
      OnClick := MenuEditAddFormClick;
    end;
    with MenuEditDeletePage do
    begin
      ImageIndex := 15;
      Images := ImageListStand;
      Caption := 'Delete Page';
      OnClick := btnDeletePageClick;
    end;
    with MenuEditToolbar do
    begin
      Caption := 'Tools bar';
      OnClick := MenuEditToolbarClick;
    end;
    with itmToolbarStandard do
    begin
      Caption := 'Standard';
      Tag := 0;
      OnClick := itmToolbarStandardClick;
    end;
    with itmToolbarText do
    begin
      Tag := 1;
      Caption := 'Text';
      OnClick := itmToolbarStandardClick;
    end;
    with itmToolbarBorder do
    begin
      Tag := 2;
      Caption := 'Border';
      OnClick := itmToolbarStandardClick;
    end;
    with itmToolbarInspector do
    begin
      Tag := 3;
      Caption := 'Object Inspector';
      ShortCut := 122;
      OnClick := itmToolbarStandardClick;
    end;
    with itmToolbarInsField do
    begin
      Tag := 4;
      Caption := 'Insert DB fields';
      OnClick := itmToolbarStandardClick;
    end;
    with itmToolbarGrid do
    begin
      Tag := 5;
      Caption := 'Grid';
      OnClick := itmToolbarStandardClick;
    end;
    with itmToolbarCellEdit do
    begin
      Tag := 6;
      Caption := 'Cell Edit';
      OnClick := itmToolbarStandardClick;
    end;
    with MenuEditOptions do
    begin
      Caption := 'Options...';
      OnClick := MenuEditOptionsClick;
    end;
    with MenuCell do
    begin
      Caption := 'Cell';
    end;
    with MenuCellProperty do
    begin
      ImageIndex := 27;
      Images := ImageListStand;
      Caption := 'Prop...';
      OnClick := MenuCellPropertyClick;
    end;
    with MenuCellTableSize do
    begin
      ImageIndex := 10;
      Images := ImageListGrid;
      Caption := 'Column & Row...';
      OnClick := MenuCellTableSizeClick;
    end;
    with MenuCellRow do
    begin
      Caption := 'Row';
    end;
    with itmRowHeight do
    begin
      Caption := 'Row Height...';
      OnClick := itmRowHeightClick;
    end;
    with itmAverageRowHeight do
    begin
      Caption := 'Average Row Height';
      OnClick := itmAverageRowHeightClick;
    end;
    with MenuCellColumn do
    begin
      Caption := 'Column';
    end;
    with itmColumnHeight do
    begin
      Caption := 'Column Width...';
      OnClick := itmColumnHeightClick;
    end;
    with itmAverageColumnWidth do
    begin
      Caption := 'Average Column Width';
      OnClick := itmAverageColumnWidthClick;
    end;
    with MenuCellInsertCell do
    begin
      Caption := 'Insert Cell';
    end;
    with itmInsertCellLeft do
    begin
      Caption := 'Left';
    end;
    with itmInsertCellTop do
    begin
      Caption := 'Top';
    end;
    with MenuCellInsertColumn do
    begin
      ImageIndex := 0;
      Images := ImageListGrid;
      Caption := 'Insert Column';
      OnClick := itmInsertLeftColumnClick;
    end;
    with MenuCellInsertRow do
    begin
      ImageIndex := 1;
      Images := ImageListGrid;
      Caption := 'Insert Row';
      OnClick := itmInsertTopRowClick;
    end;
    with MenuCellDeleteColumn do
    begin
      ImageIndex := 4;
      Images := ImageListGrid;
      Caption := 'Delete Column';
      OnClick := itmDeleteColumnClick;
    end;
    with MenuCellDeleteRow do
    begin
      ImageIndex := 5;
      Images := ImageListGrid;
      Caption := 'Delete Row';
      OnClick := itmDeleteRowClick;
    end;
    with MenuEditMerge do
    begin
      ImageIndex := 6;
      Images := ImageListGrid;
      Caption := 'Merge';
      OnClick := btnMergeClick;
    end;
    with MenuEditReverse do
    begin
      ImageIndex := 7;
      Images := ImageListGrid;
      Caption := 'Reverse';
      OnClick := btnSplitClick;
    end;
    with MenuHelp do
    begin
      Caption := '&Help';
    end;
    with MenuHelpContents do
    begin
      ImageIndex := 26;
      Images := ImageListStand;
      Caption := 'Help contents...';
    end;
    with MenuHelpAbout do
    begin
      Caption := 'About...';
      OnClick := MenuHelpAboutClick;
    end;
  end;

  procedure _CreatePopMenu;
  begin
    SelectionMenu := TRMPopupMenu.Create(Self);
    with SelectionMenu do
    begin
      Name := 'SelectionMenu';
      OnPopup := SelectionMenuPopup;
      AutoHotKeys := maManual;
      Images := ImageListGrid;
    end;
    itmGridMenuBandProp := TRMMenuItem.Create(Self);
    with itmGridMenuBandProp do
    begin
      Caption := 'Band DataSet...';
      OnClick := OnGridRowHeaderDblClick;
      AddToMenu(SelectionMenu);
    end;

    SelectionMenu_popCut := TRMMenuItem.Create(Self);
    with SelectionMenu_popCut do
    begin
      Caption := 'Cut';
      ImageIndex := 12;
      OnClick := MenuEditCutClick;
      AddToMenu(SelectionMenu);
    end;
    SelectionMenu_popCopy := TRMMenuItem.Create(Self);
    with SelectionMenu_popCopy do
    begin
      Caption := 'Copy';
      ImageIndex := 13;
      OnClick := MenuEditCopyClick;
      AddToMenu(SelectionMenu);
    end;
    SelectionMenu_popPaste := TRMMenuItem.Create(Self);
    with SelectionMenu_popPaste do
    begin
      Caption := 'Paste';
      ImageIndex := 14;
      OnClick := MenuEditPasteClick;
      AddToMenu(SelectionMenu);
    end;
    N102 := TRMSeparatorMenuItem.Create(Self);
    N102.AddToMenu(SelectionMenu);

    itmCellProp := TRMMenuItem.Create(Self);
    with itmCellProp do
    begin
      ImageIndex := 11;
      Caption := 'Prop...';
      OnClick := MenuCellPropertyClick;
      AddToMenu(SelectionMenu);
    end;
//    itmSplit1 := TRMSeparatorMenuItem.Create(Self);
//    itmSplit1.AddToMenu(SelectionMenu);
    itmMergeCells := TRMMenuItem.Create(Self);
    with itmMergeCells do
    begin
      ImageIndex := 6;
      Caption := 'Merge Cells';
      OnClick := btnMergeClick;
      AddToMenu(SelectionMenu);
    end;
    itmSplitCells := TRMMenuItem.Create(Self);
    with itmSplitCells do
    begin
      ImageIndex := 7;
      Caption := 'Split Cells';
      OnClick := btnSplitClick;
      AddToMenu(SelectionMenu);
    end;
    N3 := TRMSeparatorMenuItem.Create(Self);
    N3.AddToMenu(SelectionMenu);
    itmInsert := TRMSubmenuItem.Create(Self);
    with itmInsert do
    begin
      Caption := 'Insert';
      AddToMenu(SelectionMenu);
    end;
    itmInsertLeftColumn := TRMMenuItem.Create(Self);
    with itmInsertLeftColumn do
    begin
      Caption := 'Left Column';
      OnClick := itmInsertLeftColumnClick;
      AddToMenu(itmInsert);
    end;
    itmInsertRightColumn := TRMMenuItem.Create(Self);
    with itmInsertRightColumn do
    begin
      Caption := 'Right Column';
      OnClick := itmInsertRightColumnClick;
      AddToMenu(itmInsert);
    end;
    N10 := TRMSeparatorMenuItem.Create(Self);
    N10.AddToMenu(itmInsert);
    itmInsertTopRow := TRMMenuItem.Create(Self);
    with itmInsertTopRow do
    begin
      Caption := 'Top Row';
      OnClick := itmInsertTopRowClick;
      AddToMenu(itmInsert);
    end;
    itmInsertBottomRow := TRMMenuItem.Create(Self);
    with itmInsertBottomRow do
    begin
      Caption := 'Bottom Row';
      OnClick := itmInsertBottomRowClick;
      AddToMenu(itmInsert);
    end;

    itmSep1 := TRMSeparatorMenuItem.Create(Self);
    itmSep1.AddToMenu(itmInsert);
    itmInsertLeftCell := TRMMenuItem.Create(Self);
    with itmInsertLeftCell do
    begin
      Caption := RMLoadStr(rmRes + 258);
      OnClick := itmInsertLeftCellClick;
      AddToMenu(itmInsert);
    end;
    itmInsertTopCell := TRMMenuItem.Create(Self);
    with itmInsertTopCell do
    begin
      Caption := RMLoadStr(rmRes + 259);
      OnClick := itmInsertTopCellClick;
      AddToMenu(itmInsert);
    end;
    itmDelete := TRMSubmenuItem.Create(Self);
    with itmDelete do
    begin
      Caption := 'Delete';
      AddToMenu(SelectionMenu);
    end;
    itmDeleteColumn := TRMMenuItem.Create(Self);
    with itmDeleteColumn do
    begin
      Caption := 'Column';
      OnClick := itmDeleteColumnClick;
      AddToMenu(itmDelete);
    end;
    itmDeleteRow := TRMMenuItem.Create(Self);
    with itmDeleteRow do
    begin
      Caption := 'Row';
      OnClick := itmDeleteRowClick;
      AddToMenu(itmDelete);
    end;
    itmDeleteSep1 := TRMSeparatorMenuItem.Create(Self);
    itmDeleteSep1.AddToMenu(itmDelete);
    itmDeleteLeftCell := TRMMenuItem.Create(Self);
    with itmDeleteLeftCell do
    begin
      Caption := RMLoadStr(rmRes + 268);
      OnClick := itmDeleteLeftCellClick;
      AddToMenu(itmDelete);
    end;
    itmDeleteTopCell := TRMMenuItem.Create(Self);
    with itmDeleteTopCell do
    begin
      Caption := RMLoadStr(rmRes + 269);
      OnClick := itmDeleteTopCellClick;
      AddToMenu(itmDelete);
    end;
    N6 := TRMSeparatorMenuItem.Create(Self);
    N6.AddToMenu(SelectionMenu);

    itmCellType := TRMSubmenuItem.Create(Self);
    with itmCellType do
    begin
      Caption := 'Cell Type';
      AddToMenu(SelectionMenu);
    end;
    itmMemoView := TRMMenuItem.Create(Self);
    with itmMemoView do
    begin
      Caption := 'Memo View';
      Checked := True;
      GroupIndex := 1;
      RadioItem := true;
      OnClick := itmMemoViewClick;
      AddToMenu(itmCellType);
    end;
    itmCalcMemoView := TRMMenuItem.Create(Self);
    with itmCalcMemoView do
    begin
      Tag := rmgtCalcMemo;
      Caption := 'Calc Memo View';
      GroupIndex := 1;
      RadioItem := true;
      OnClick := itmMemoViewClick;
      AddToMenu(itmCellType);
    end;
    itmPictureView := TRMMenuItem.Create(Self);
    with itmPictureView do
    begin
      Tag := rmgtPicture;
      Caption := 'Picture View';
      GroupIndex := 1;
      RadioItem := true;
      OnClick := itmMemoViewClick;
      AddToMenu(itmCellType);
    end;
    itmSubReportView := TRMMenuItem.Create(Self);
    with itmSubReportView do
    begin
      Tag := rmgtSubReport;
      Caption := 'SubReport View';
      GroupIndex := 1;
      RadioItem := true;
      OnClick := itmMemoViewClick;
      AddToMenu(itmCellType);
    end;
    itmInsertBand := TRMSubmenuItem.Create(Self);
    with itmInsertBand do
    begin
      Caption := 'Band';
      AddToMenu(SelectionMenu);
    end;
    itmSelectBand := TRMSubmenuItem.Create(Self);
    itmSelectBand.AddToMenu(SelectionMenu);
    N4 := TRMSeparatorMenuItem.Create(Self);
    N4.AddToMenu(SelectionMenu);
    itmFrameType := TRMMenuItem.Create(Self);
    with itmFrameType do
    begin
      Caption := 'Frame Type...';
      OnClick := itmFrameTypeClick;
      AddToMenu(SelectionMenu);
    end;
    itmEdit := TRMMenuItem.Create(Self);
    with itmEdit do
    begin
      Caption := 'Edit...';
      OnClick := itmEditClick;
      AddToMenu(SelectionMenu);
    end;
    padpopClearContents := TRMMenuItem.Create(Self);
    with padpopClearContents do
    begin
      Caption := 'Clear Contents';
      OnClick := padpopClearContentsClick;
      AddToMenu(SelectionMenu);
    end;

    N100 := TRMSeparatorMenuItem.Create(Self);
    N100.AddToMenu(SelectionMenu);
    padpopOtherProp := TRMMenuItem.Create(Self);
    with padpopOtherProp do
    begin
    	Caption := 'Other Prop';
      AddToMenu(SelectionMenu);
      RMSetStrProp(padpopOtherProp, 'Caption', rmRes + 913);
    end;

    PopupMenu1 := TRMPopupMenu.Create(Self);
    PopupMenuBands := TRMPopupMenu.Create(Self);
    with PopupMenu1 do
    begin
      Name := 'PopupMenu1';
      AutoHotkeys := maManual;
    end;
    with PopupMenuBands do
    begin
      Name := 'PopupMenuBands';
      AutoHotkeys := maManual;
      OnPopup := PopupMenuBandsPopup;
    end;

    Popup1 := TRMPopupMenu.Create(Self);
    with Popup1 do
    begin
      Name := 'Popup1';
      AutoHotkeys := maManual;
      OnPopup := Popup1Popup;
    end;

    padpopCut := TRMMenuItem.Create(Self);
    with padpopCut do
    begin
      AddToMenu(Popup1);
      Caption := 'Cut';
      RMSetStrProp(padpopCut, 'Caption', rmRes + 148);
      ShortCut := 16472;
      OnClick := MenuEditCutClick;
    end;
    padpopCopy := TRMMenuItem.Create(Self);
    with padpopCopy do
    begin
      AddToMenu(Popup1);
      Caption := 'Copy';
      RMSetStrProp(padpopCopy, 'Caption', rmRes + 149);
      ShortCut := 16451;
      OnClick := MenuEditCopyClick;
    end;
    padpopPaste := TRMMenuItem.Create(Self);
    with padpopPaste do
    begin
      AddToMenu(Popup1);
      Caption := 'Paste';
      RMSetStrProp(padpopPaste, 'Caption', rmRes + 150);
      ShortCut := 16470;
      OnClick := MenuEditPasteClick;
    end;
    padpopDelete := TRMMenuItem.Create(Self);
    with padpopDelete do
    begin
      AddToMenu(Popup1);
      Caption := 'Delete';
      RMSetStrProp(padpopDelete, 'Caption', rmRes + 151);
      ShortCut := 16430;
      OnClick := MenuEditDeleteClick;
    end;
    padpopSelectAll := TRMMenuItem.Create(Self);
    with padpopSelectAll do
    begin
      AddToMenu(Popup1);
      Caption := 'Select all';
      RMSetStrProp(padpopSelectAll, 'Caption', rmRes + 152);
      ShortCut := 16449;
      OnClick := MenuEditSelectAllClick;
    end;
    MenuItem1 := TRMSeparatorMenuItem.Create(Self);
    with MenuItem1 do
    begin
      AddToMenu(Popup1);
    end;
    padpopEdit := TRMMenuItem.Create(Self);
    with padpopEdit do
    begin
      AddToMenu(Popup1);
      Caption := 'Edit...';
      RMSetStrProp(padpopEdit, 'Caption', rmRes + 153);
      OnClick := padpopEditClick;
    end;

  end;
begin
  ObjID := 0;
  FFactor := 100;
  SelNum := 0;
  FGrid := nil;
  FWorkSpace := nil;
  FFileName := '';

  FPageStream := TMemoryStream.Create;

  FOpenFiles := TStringList.Create;

  _CreateTabPanel;
  _CreateDock;
  _CreateMenubar;
  _CreatePopMenu;

  ToolbarStandard := TRMToolbarStandard.CreateAndDock(Self, Dock971);
  ToolbarGrid := TRMToolbarGrid.CreateAndDock(Self, Dock971);
  ToolbarEdit := TRMToolbarEdit.CreateAndDock(Self, Dock971);
  ToolbarBorder := TRMToolbarBorder.CreateAndDock(Self, Dock971);
  ToolbarCellEdit := TRMToolbarCellEdit.CreateAndDock(Self, Dock971);

  itmMemoView.Tag := rmgtMemo;
  itmCalcMemoView.Tag := rmgtCalcMemo;
  itmPictureView.Tag := rmgtPicture;
  itmSubReportView.Tag := rmgtSubReport;
  FAddinObjects := TStringList.Create;
  FAddinObjects.Clear;
  for i := 0 to RMAddInsCount - 1 do
  begin
    if not RMAddIns(i).IsControl then
    begin
      if not RMAddIns(i).ClassRef.CanPlaceOnGridView then
        Continue;
      liMenuItem := TRMMenuItem.Create(itmCellType);
      liMenuItem.GroupIndex := itmMemoView.GroupIndex;
      liMenuItem.RadioItem := True;
      liMenuItem.Tag := rmgtAddIn;
      liMenuItem.Caption := RMAddIns(i).ButtonHint;
      liMenuItem.OnClick := itmMemoViewClick;
      FAddinObjects.Add(RMAddIns(i).ClassRef.ClassName);
      itmCellType.Add(liMenuItem);
    end;
  end;

  Localize;
end;

procedure TRMGridReportDesignerForm.FormDestroy(Sender: TObject);
begin
  ClearUndoBuffer;
  ClearRedoBuffer;

  if IsPreviewDesign or IsPreviewDesignReport then
    FGrid := nil;

  FreeAndNil(FPageStream);
  FreeAndNil(FList);
  SetGridNilProp;

  FInspForm.RestorePos;
  SaveIni;

  FreeAndNil(FInspForm);
  FreeAndNil(FFieldForm);
  FreeAndNil(FAddinObjects);
  if FWorkSpace <> nil then
  begin
    FWorkSpace.Parent := nil;
    FreeAndNil(FWorkSpace.PageForm);
  end;
  FreeAndNil(FWorkSpace);
  FreeAndNil(FOpenFiles);
end;

procedure TRMGridReportDesignerForm.btnMergeClick(Sender: TObject);
begin
  AddUndoAction(acChangeCellCount);
  Modified := True;
  FGrid.MergeSelection;
end;

procedure TRMGridReportDesignerForm.btnSplitClick(Sender: TObject);
var
  lRect: TRect;
begin
  AddUndoAction(acChangeCellCount);
  Modified := True;

  lRect := FGrid.Selection;
  FGrid.SplitCell(lRect.Left, lRect.Top, lRect.Right, lRect.Bottom);
end;

const
  rsUnits = 'Units';
  rsAutoOpenLastFile = 'AutoOpenLastFile';
  rsWorkSpaceColor = 'WorkSpaceColor';
  rsInspFormColor = 'InspFormColor';

procedure TRMGridReportDesignerForm.SetOpenFileMenuItems(const aNewFile: string);
var
  i, lCount, liIndex: Integer;
  str: string;
  {$IFDEF USE_TB2k}
  lItem: TTBItem;
  {$ELSE}
  lItem: TRMMenuItem;
  {$ENDIF}
  lDefaultOpenFileIndex: Integer;
begin
  if aNewFile <> '' then
  begin
    liIndex := FOpenFiles.IndexOf(aNewFile);
    if liIndex < 0 then
      FOpenFiles.Insert(0, aNewFile)
    else
    begin
      for i := liIndex - 1 downto 0 do
        FOpenFiles[i + 1] := FOpenFiles[i];
      FOpenFiles[0] := aNewFile;
    end;
    while FOpenFiles.Count > 9 do
      FOpenFiles.Delete(9);
  end;

  lDefaultOpenFileIndex := MenuFile.IndexOf(MenuFileFile1) - 1;
  {$IFDEF USE_TB2K}
  ToolbarStandard.btnFileOpen.Clear;
  {$ELSE}
  while PopupMenu1.Items.Count > 0 do
    PopupMenu1.Items.Delete(0);
  for i := 0 to 9 do
  begin
    if MenuFile.Items[lDefaultOpenFileIndex + 1 + i].Visible then
    begin
    end;
  end;
  {$ENDIF}
  lCount := FOpenFiles.Count;
  if (FDesignerComp <> nil) and (lCount > FDesignerComp.OpenFileCount) then
    lCount := FDesignerComp.OpenFileCount;
  for i := 1 to lCount do
  begin
    str := RMMinimizeName(FOpenFiles[i - 1], Canvas, 400);
    MenuFile.Items[lDefaultOpenFileIndex + i].Caption := '&' + IntToStr(i) + ' ' + str;
    MenuFile.Items[lDefaultOpenFileIndex + i].Visible := True;
    {$IFDEF USE_TB2k}
    lItem := TTBItem.Create(ToolbarStandard.btnFileOpen);
    lItem.Tag := MenuFile.Items[lDefaultOpenFileIndex + i].Tag;
    lItem.Caption := MenuFile.Items[lDefaultOpenFileIndex + i].Caption;
    lItem.OnClick := MenuFileFile9Click;
    ToolbarStandard.btnFileOpen.Add(lItem);
    {$ELSE}
    lItem := TRMMenuItem.Create(PopupMenu1);
    lItem.Tag := MenuFile.Items[lDefaultOpenFileIndex + i].Tag;
    lItem.Caption := MenuFile.Items[lDefaultOpenFileIndex + i].Caption;
    lItem.OnClick := MenuFileFile9Click;
    PopupMenu1.Items.Add(lItem);
    {$ENDIF}
  end;

  ToolbarStandard.btnFileOpen.DropdownCombo := lCount >= 1;
  {$IFNDEF USE_TB2K}
  if lCount >= 1 then
    ToolbarStandard.btnFileOpen.DropdownMenu := PopupMenu1
  else
    ToolbarStandard.btnFileOpen.DropdownMenu := nil;
  {$ENDIF}
  for i := lCount to 9 do
    MenuFile.Items[lDefaultOpenFileIndex + 1 + i].Visible := False;
  N5.Visible := lCount > 0;
end;

procedure TRMGridReportDesignerForm.SaveIni;
var
  Ini: TRegIniFile;
  Nm: string;
  i: Integer;
begin
  Ini := TRegIniFile.Create(RMRegRootKey + '\GridReport');
  try
    Nm := rsForm + Name;
    Ini.WriteBool(Nm, rsAutoOpenLastFile, FAutoOpenLastFile);
    Ini.WriteBool(Nm, rsUseTableName, UseTableName);
    Ini.WriteInteger(Nm, rsUnits, Word(FUnitType));
    Ini.WriteBool(Nm, rsLocalPropNames, RMLocalizedPropertyNames);

    Ini.WriteInteger(rsForm + FInspForm.ClassName, 'SplitPos', FInspForm.SplitterPos);
    Ini.WriteInteger(rsForm + FInspForm.ClassName, 'SplitPos1', FInspForm.SplitterPos1);

    Ini.WriteInteger(rsForm + FFieldForm.ClassName, 'SplitPos', FFieldForm.SplitterPos);
    Ini.EraseSection(rsOpenFiles);
    for i := 1 to FOpenFiles.Count do
      Ini.WriteString(rsOpenFiles, 'File' + IntToStr(i), FOpenFiles[i - 1]);
  finally
    Ini.Free;
  end;

  RMSaveToolWinPosition('\GridReport', FInspForm);
  RMSaveToolWinPosition('\GridReport', FFieldForm);
  RMSaveFormPosition('\GridReport', Self);
  RMSaveToolbars('\GridReport', [ToolbarBorder, ToolbarStandard, ToolbarEdit, ToolbarGrid, ToolbarCellEdit]);
end;

procedure TRMGridReportDesignerForm.LoadIni;
var
  Ini: TRegIniFile;
  Nm: string;
begin
  {$IFNDEF TB2000}
  Dock971.BeginUpdate;
  Dock972.BeginUpdate;
  Dock973.BeginUpdate;
  Dock974.BeginUpdate;
  {$ENDIF}

  Ini := TRegIniFile.Create(RMRegRootKey + '\GridReport');
  try
    Nm := rsForm + Name;
    RMLocalizedPropertyNames := Ini.ReadBool(Nm, rsLocalPropNames, RMLocalizedPropertyNames);
    UseTableName := Ini.ReadBool(Nm, rsUseTableName, True);
    FUnitType := TRMUnitType(Ini.ReadInteger(Nm, rsUnits, 0));

    RMRestoreToolWinPosition('\GridReport', FInspForm);
    FInspForm.SplitterPos := Ini.ReadInteger(rsForm + FInspForm.ClassName, 'SplitPos', 75);
    FInspForm.SplitterPos1 := Ini.ReadInteger(rsForm + FInspForm.ClassName, 'SplitPos1', FInspForm.SplitterPos1);

    RMRestoreToolWinPosition('\GridReport', FFieldForm);
    FFieldForm.SplitterPos := Ini.ReadInteger(rsForm + FFieldForm.ClassName, 'SplitPos', 75);
  finally
    Ini.Free;
  end;

  RMRestoreFormPosition('\GridReport', Self);
  RMRestoreToolbars('\GridReport', [ToolbarBorder, ToolbarStandard, ToolbarEdit, ToolbarGrid, ToolbarCellEdit]);

  {$IFNDEF TB2000}
  Dock971.EndUpdate;
  Dock972.EndUpdate;
  Dock973.EndUpdate;
  Dock974.EndUpdate;
  {$ENDIF}
end;

procedure TRMGridReportDesignerForm.FormShow(Sender: TObject);
var
  liPage: TRMGridReportPage;

  procedure _CreateBandsMenuItems;
  var
    bt: TRMBandType;
    {$IFDEF USE_TB2K}
    lItem: TTBItem;
    {$ELSE}
    litem: TRMMenuItem;
    {$ENDIF}
    lMenuItem: TRMMenuItem;
  begin
    for bt := rmbtReportTitle to rmbtGroupFooter do
    begin
      {$IFDEF USE_TB2k}
      lItem := TTBItem.Create(ToolbarBorder.btnAddBand);
      lItem.Tag := Ord(bt);
      lItem.Caption := RMBandNames[TRMBandType(bt)];
      lItem.OnClick := OnAddBandEvent;
      ToolbarBorder.btnAddBand.Add(lItem);
      {$ELSE}
      litem := TRMMenuItem.Create(PopupMenuBands);
      litem.Caption := RMBandNames[TRMBandType(bt)];
      litem.Tag := Ord(bt);
      litem.OnClick := OnAddBandEvent;
      PopupMenuBands.Items.Add(litem);
      {$ENDIF}

      lMenuItem := TRMMenuItem.Create(itmInsertBand);
      lMenuItem.Caption := RMBandNames[TRMBandType(bt)];
      lMenuItem.Tag := Ord(bt);
      lMenuItem.OnClick := OnAddBandEvent;
      itmInsertBand.Add(lMenuItem);
    end;
  end;

  procedure _RestoreOpenFiles;
  var
    Ini: TRegIniFile;
    i: Integer;
    str: string;
    Nm: string;
  begin
    Ini := TRegIniFile.Create(RMRegRootKey + '\GridReport');
    Nm := rsForm + Name;
    FAutoOpenLastFile := Ini.ReadBool(Nm, rsAutoOpenLastFile, False);
    try
      if not IsPreviewDesign then
      begin
        for i := 1 to 9 do
        begin
          str := Ini.ReadString(rsOpenFiles, 'File' + IntToStr(i), '');
          if str = '' then
            Break;
          FOpenFiles.Add(str);
        end;
      end;
      SetOpenFileMenuItems('');
    finally
      Ini.Free;
    end;
  end;

begin
  ShowGrid := True;
  GridSize := 4;

  Tab1.Tabs.Clear;
  Tab1.AddTab(RMLoadStr(rmRes + 253));

  FInspBusy := True;
  _CreateBandsMenuItems;
  FInspForm := TRMInspForm.Create(Self);
  with FInspForm do
  begin
    SetCurReport(Report);
    {$IFNDEF USE_TB2K}
    Parent := Self;
    {$ENDIF}
    Insp.OnAfterModify := Self.OnInspAfterModify;
    Insp.OnBeforeModify := Self.OnInspBeforeModify;
    OnSelectionChanged := Self.InspSelectionChanged;
    OnGetObjects := Self.InspGetObjects;
  end;

  FFieldForm := TRMInsFieldsForm.Create(Self);
  with FFieldForm do
  begin
    {$IFNDEF USE_TB2K}
    Parent := Self;
    {$ENDIF}
  end;

  ClearUndoBuffer;
  ClearRedoBuffer;
  _RestoreOpenFiles;
  //  if (Report.Pages.Count = 0) and FAutoOpenLastFile and (FOpenFiles.Count > 0) then
  //    Report.LoadFromFile(FOpenFiles[0]);
  if Report.Pages.Count = 0 then
  begin
    liPage := TRMGridReportPage(TRMGridReport(Report).CreatePage('TRMGridReportPage'));
    Report.Pages.PagesList.Add(liPage);
    Report.Pages[0].CreateName;
    if (FDesignerComp <> nil) and (FDesignerComp.DefaultDictionaryFile <> '') and
      FileExists(FDesignerComp.DefaultDictionaryFile) then
      Report.Dictionary.LoadFromFile(FDesignerComp.DefaultDictionaryFile);
  end;

  CurPage := 0; // this cause page sizing
  CurDocName := Report.FileName;
  Script := Report.Script;

  SetGridHeader;
  EnableControls;
  Modified := False;
  FInspBusy := False;
  FBusy := False;
  ShowPosition;

  cmbBandsDropDown(nil);
  OnGridClick(nil);
  LoadIni;
  FInspBusy := False;
  SetObjectsID;

  ToolbarPopMenu := TRMPopupMenu.Create(self);
  with ToolbarPopMenu.Items do
  begin
    {$IFNDEF USE_TB2K}
    AutoHotkeys := maManual;
    {$ENDIF}
    Clear;
    ToolbarPopStandard := RMNewItem(itmToolbarStandard.Caption, itmToolbarStandard.ShortCut, itmToolbarStandard.Checked,
      itmToolbarStandard.Enabled, itmToolbarStandard.OnClick, 0, 'PitmToolbarStandard', itmToolbarStandard.Tag);
    Add(ToolBarPopStandard);
    ToolBarPopEdit := RMNewItem(itmToolbarText.Caption, itmToolbarText.ShortCut, itmToolbarText.Checked,
      itmToolbarText.Enabled, itmToolbarText.OnClick, 0, 'PitmToolbarText', itmToolbarText.Tag);
    Add(ToolBarPopEdit);
    ToolBarPopBorder := RMNewItem(itmToolbarBorder.Caption, itmToolbarBorder.ShortCut, itmToolbarBorder.Checked,
      itmToolbarBorder.Enabled, itmToolbarBorder.OnClick, 0, 'PitmToolbarBorder', itmToolbarBorder.Tag);
    Add(ToolBarPopBorder);
    ToolbarPopCellEdit := RMNewItem(itmToolbarCellEdit.Caption, itmToolbarCellEdit.ShortCut, itmToolbarCellEdit.Checked,
      itmToolbarCellEdit.Enabled, itmToolbarCellEdit.OnClick, 0, 'PitmToolbarBorder', itmToolbarCellEdit.Tag);
    Add(ToolbarPopCellEdit);
    ToolBarPopInsp := RMNewItem(itmToolbarInspector.Caption, itmToolbarInspector.ShortCut, itmToolbarInspector.Checked,
      itmToolbarInspector.Enabled, itmToolbarInspector.OnClick, 0, 'PitmToolbarInspector', itmToolbarInspector.Tag);
    Add(ToolBarPopInsp);
    ToolBarPopInsDBField := RMNewItem(itmToolbarInsField.Caption, itmToolbarInsField.ShortCut, itmToolbarInsField.Checked,
      itmToolbarInsField.Enabled, itmToolbarInsField.OnClick, 0, 'PitmToolbarInsField', itmToolbarInsField.Tag);
    Add(ToolBarPopInsDBField);
    ToolbarPopGrid := RMNewItem(itmToolbarGrid.Caption, itmToolbarGrid.ShortCut, itmToolbarGrid.Checked,
      itmToolbarGrid.Enabled, itmToolbarGrid.OnClick, 0, 'PitmToolbarGrid', itmToolbarGrid.Tag);
    Add(ToolbarPopGrid);

  end;
  ToolbarPopMenu.OnPopup := ToolBarPopMenuPopup;

  ToolbarStandard.PopupMenu := ToolBarPopMenu;
  ToolbarEdit.PopupMenu := ToolBarPopMenu;
  ToolbarBorder.PopupMenu := ToolBarPopMenu;
  FInspForm.PopupMenu := ToolBarPopMenu;
  FFieldForm.PopupMenu := ToolBarPopMenu;
  ToolbarGrid.PopupMenu := ToolBarPopMenu;
  FFieldForm.PopupMenu := ToolbarPopMenu;

  if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnShow) then
    FDesignerComp.OnShow(Self);

  if FFieldForm.Visible then
    FFieldForm.RefreshData;

  //  if ToolbarCellEdit.FEdtMemo.CanFocus then
  //    ToolbarCellEdit.FEdtMemo.SetFocus;
end;

procedure TRMGridReportDesignerForm.itmGridMenuBandClick(Sender: TObject);
begin
  if TRMMenuItem(Sender).Tag = 0 then
    ToolbarBorder.cmbBands.ItemIndex := 0
  else
    ToolbarBorder.cmbBands.ItemIndex := ToolbarBorder.cmbBands.Items.IndexOf(TRMMenuItem(Sender).Caption);

  cmbBandsClick(nil);
end;

const
	DefaultMenuItemNum = 5;
  
procedure TRMGridReportDesignerForm.SelectionMenuPopup(Sender: TObject);
var
  i, j, lPos: Integer;
  lCell: TRMCellInfo;
  lMenuItem: TRMMenuItem;
  lBand: TRMView;

  procedure _CreateBandMenuItem(aMenu: TRMSubmenuItem);
  var
    i: Integer;
    lMenuItem: TRMMenuItem;
    t: TRMView;
  begin
    aMenu.Clear;
    lMenuItem := TRMMenuItem.Create(Self);
    lMenuItem.Caption := '[None]';
    lMenuItem.Tag := 0;
    lMenuItem.OnClick := itmGridMenuBandClick;
    lMenuItem.AddToMenu(aMenu);

    for i := 0 to Page.Objects.Count - 1 do
    begin
      t := Page.Objects[i];
      if t.IsBand then
      begin
        lMenuItem := TRMMenuItem.Create(Self);
        lMenuItem.Caption := RMBandNames[TRMCustomBandView(t).BandType] + '(' + t.Name + ')';
        //        lMenuItem.Checked := FInspForm.Visible;
        lMenuItem.OnClick := itmGridMenuBandClick;
        lMenuItem.Tag := 1;
        lMenuItem.AddToMenu(aMenu);
      end;
    end;
  end;

begin
  if THackGridEx(FGrid).RightClickColHeader then // 列标题上右键事件
  begin
    Abort;
  end;

  //设置Band类型菜单可操作性
  for i := 0 to itmInsertBand.Count - 1 do
  begin
    lMenuItem := TRMMenuItem(itmInsertBand.Items[i]);
    for j := 1 to FGrid.RowCount - 1 do
    begin
      if lMenuItem.Caption = FGrid.Cells[0, j].Text then
      begin
        lMenuItem.Enabled := (TRMBandType(lMenuItem.Tag) in [rmbtHeader, rmbtFooter, rmbtGroupHeader,
          rmbtGroupFooter, rmbtMasterData, rmbtDetailData]);
        Break;
      end;
    end;
  end;

  if THackGridEx(FGrid).RightClickRowHeader then // 行标题上右键事件
  begin
    lBand := TRMGridReportPage(Page).RowBandViews[FGrid.Row]; // 右键选择栏目栏目
    if lBand <> nil then
    begin
      ToolbarBorder.cmbBands.ItemIndex := ToolbarBorder.cmbBands.Items.IndexOf(RMBandNames[TRMCustomBandView(lBand).BandType] + '(' + lBand.Name + ')');
      UnSelectAll;
      SelNum := 1;
      lBand.Selected := True;
      ShowPosition;
    end;

    for i := 0 to SelectionMenu.Items.Count - 1 do
      SelectionMenu.Items[i].Visible := False;

    itmGridMenuBandProp.Visible := True;
    itmInsertBand.Visible := True;
    itmSelectBand.Visible := True;
    _CreateBandMenuItem(itmSelectBand);

    lPos := SelectionMenu.Items.IndexOf(itmFrameType) + DefaultMenuItemNum;
    while SelectionMenu.Items.Count > lPos do
      SelectionMenu.Items.Delete(lPos);

    if TRMGridReportPage(Page).RowBandViews[FGrid.Selection.Top] <> nil then
      TRMGridReportPage(Page).RowBandViews[FGrid.Selection.Top].DefinePopupMenu(TRMCustomMenuItem(SelectionMenu.Items));

    SelectionMenu.Items.Add(RMNewLine());

    lMenuItem := TRMMenuItem.Create(Self);
    lMenuItem.Caption := RMLoadStr(rmRes + 211);
    lMenuItem.Checked := FInspForm.Visible;
    lMenuItem.OnClick := Pan5Click;
    SelectionMenu.Items.Add(lMenuItem);

    Exit;
  end
  else
  begin
    itmGridMenuBandProp.Visible := False;
    for i := 1 to SelectionMenu.Items.Count - 1 do
      SelectionMenu.Items[i].Visible := True;

    itmInsertBand.Visible := True;
    itmSelectBand.Visible := True;
  end;

  lCell := FGrid.GetCellInfo(FGrid.Selection.Left, FGrid.Selection.Top);
  case lCell.View.ObjectType of
    rmgtMemo: itmMemoView.Checked := True;
    rmgtCalcMemo: itmCalcMemoView.Checked := True;
    rmgtPicture: itmPictureView.Checked := True;
    rmgtSubReport: itmSubReportView.Checked := True;
  else
    itmCellType.Items[AddInObjectOffset + FAddinObjects.IndexOf(lCell.View.ClassName)].Checked := True;
  end;

	// 设置单元格中view的属性的右键菜单
	padpopOtherProp.Clear;
  lPos := SelectionMenu.Items.IndexOf(itmFrameType) + DefaultMenuItemNum;
  while SelectionMenu.Items.Count > lPos do
    SelectionMenu.Items.Delete(lPos);

  _CreateBandMenuItem(itmSelectBand);

  lCell.View.Selected := True;
//  lCell.View.DefinePopupMenu(TRMCustomMenuItem(SelectionMenu.Items));
  lCell.View.DefinePopupMenu(padpopOtherProp);

  SelectionMenu.Items.Add(RMNewLine());

  lMenuItem := TRMMenuItem.Create(Self);
  lMenuItem.Caption := RMLoadStr(rmRes + 211);
  lMenuItem.Checked := FInspForm.Visible;
  lMenuItem.OnClick := Pan5Click;
  SelectionMenu.Items.Add(lMenuItem);
end;

procedure TRMGridReportDesignerForm.itmMemoViewClick(Sender: TObject);
var
  lSelection: TRect;
  lCell: TRMCellInfo;
  i, j: Integer;

  procedure _CreateSubReport(aSubReportView: TRMView);
  var
    lPage: TRMReportPage;
  begin
    TRMSubReportView(aSubReportView).SubPage := Report.Pages.Count;
    with TRMGridReportPage(Page) do
    begin
      lPage := TRMGridReport(Report).AddGridReportPage;
      lPage.ChangePaper(PageSize, PrinterInfo.PageWidth, PrinterInfo.PageHeight, PageBin, PageOrientation);
      lPage.mmMarginLeft := mmMarginLeft;
      lPage.mmMarginTop := mmMarginTop;
      lPage.mmMarginRight := mmMarginRight;
      lPage.mmMarginBottom := mmMarginBottom;
      lPage.CreateName;
    end;

    SetPageTabs;
    CurPage := CurPage;
  end;

  procedure _SetOneCell;
  var
    lNewType: Integer;
    lNewClassName: string;
  begin
    lNewClassName := '';
    case TRMMenuItem(Sender).Tag of
      rmgtMemo: lNewType := rmgtMemo;
      rmgtCalcMemo: lNewType := rmgtCalcMemo;
      rmgtPicture: lNewType := rmgtPicture;
      rmgtSubReport: lNewType := rmgtSubReport;
    else
      lNewType := rmgtAddIn;
      lNewClassName := FAddinObjects[itmCellType.IndexOf(TRMMenuItem(Sender)) - AddInObjectOffset];
    end;

    lCell.ReCreateView(lNewType, lNewClassName);
    if lNewType = rmgtSubReport then
      _CreateSubReport(lCell.View);
  end;

begin
  if FBusy then Exit;

  FBusy := True;
  lSelection := FGrid.Selection;
  for i := lSelection.Top to lSelection.Bottom do
  begin
    j := lSelection.Left;
    while j <= lSelection.Right do
    begin
      lCell := FGrid.Cells[j, i];
      if lCell.StartRow = i then
        _SetOneCell;
      j := lCell.EndCol + 1;
    end;
  end;

  FGrid.CreateViewsName;
  Modified := True;
  FBusy := False;
  RefreshProp;
end;

procedure TRMGridReportDesignerForm.itmDeleteColumnClick(Sender: TObject);
var
  i, lBeginCol, lEndCol: Integer;
begin
  FBusy := True;
  AddUndoAction(acChangeCellCount);
  Modified := True;

  lBeginCol := FGrid.Selection.Left;
  lEndCol := FGrid.Selection.Right;
  for i := 0 to lEndCol - lBeginCol do
    FGrid.DeleteColumn(lBeginCol, i = (lEndCol - lBeginCol));

  FBusy := False;
  OnGridClick(nil);
end;

procedure TRMGridReportDesignerForm.itmDeleteRowClick(Sender: TObject);
var
  i, lBeginRow, lEndRow: Integer;
begin
  FBusy := True;
  AddUndoAction(acChangeCellCount);
  Modified := True;

  lBeginRow := FGrid.Selection.Top;
  lEndRow := FGrid.Selection.Bottom;
  for i := 0 to lEndRow - lBeginRow do
    FGrid.DeleteRow(lBeginRow, i = (lEndRow - lBeginRow));

  SetGridHeader;
  FBusy := False;
  OnGridClick(nil);
end;

procedure TRMGridReportDesignerForm.itmInsertLeftColumnClick(Sender: TObject);
var
  tmp: TRMEditCellWidthForm;
  i, lCurCol: Integer;
begin
  tmp := TRMEditCellWidthForm.Create(nil);
  try
    RMSetStrProp(tmp, 'Caption', rmRes + 854);
    RMSetStrProp(tmp.Label2, 'Caption', rmRes + 855);
    tmp.btnCount.MinValue := 1;
    tmp.btnCount.MaxValue := 99;
    tmp.btnCount.Value := 1;
    tmp.btnCount.Left := 120;
    tmp.RB6.Enabled := False;
    tmp.RB7.Enabled := False;
    tmp.RB8.Enabled := False;
    tmp.RB9.Enabled := False;
    if tmp.ShowModal = mrOK then
    begin
      AddUndoAction(acChangeCellCount);
      Modified := True;
      lCurCol := FGrid.Col;
      THackGridEx(FGrid).InLoadSaveMode := True;
      for i := 1 to tmp.btnCount.AsInteger do
      begin
        FGrid.InsertColumn(lCurCol, False);
      end;

      FGrid.CreateViewsName;
      FGrid.InvalidateGrid;
    end;
  finally
    tmp.Free;
    THackGridEx(FGrid).InLoadSaveMode := False;
  end;
end;

procedure TRMGridReportDesignerForm.itmInsertRightColumnClick(Sender: TObject);
var
  tmp: TRMEditCellWidthForm;
  i, lCurCol: Integer;
begin
  tmp := TRMEditCellWidthForm.Create(nil);
  try
    RMSetStrProp(tmp, 'Caption', rmRes + 858);
    RMSetStrProp(tmp.Label2, 'Caption', rmRes + 855);
    tmp.btnCount.MinValue := 1;
    tmp.btnCount.MaxValue := 99;
    tmp.btnCount.Value := 1;
    tmp.btnCount.Left := 120;
    tmp.RB6.Enabled := False;
    tmp.RB7.Enabled := False;
    tmp.RB8.Enabled := False;
    tmp.RB9.Enabled := False;
    if tmp.ShowModal = mrOK then
    begin
      AddUndoAction(acChangeCellCount);
      Modified := True;
      lCurCol := FGrid.Col;
      if lCurCol = FGrid.ColCount - 1 then
        FGrid.ColCount := FGrid.ColCount + tmp.btnCount.AsInteger
      else
      begin
        THackGridEx(FGrid).InLoadSaveMode := True;
        for i := 1 to tmp.btnCount.AsInteger do
        begin
          FGrid.InsertColumn(lCurCol + 1, False);
        end;

        FGrid.CreateViewsName;
        FGrid.InvalidateGrid;
      end;
    end;
  finally
    tmp.Free;
    THackGridEx(FGrid).InLoadSaveMode := False;
  end;
end;

procedure TRMGridReportDesignerForm.itmInsertTopRowClick(Sender: TObject);
var
  tmp: TRMEditCellWidthForm;
  i, lCurRow: Integer;
begin
  tmp := TRMEditCellWidthForm.Create(nil);
  try
    RMSetStrProp(tmp, 'Caption', rmRes + 856);
    RMSetStrProp(tmp.Label2, 'Caption', rmRes + 857);
    tmp.btnCount.MinValue := 1;
    tmp.btnCount.MaxValue := 99;
    tmp.btnCount.Value := 1;
    tmp.btnCount.Left := 120;
    tmp.RB6.Enabled := False;
    tmp.RB7.Enabled := False;
    tmp.RB8.Enabled := False;
    tmp.RB9.Enabled := False;
    if tmp.ShowModal = mrOK then
    begin
      AddUndoAction(acChangeCellCount);
      Modified := True;
      lCurRow := FGrid.Row;
      THackGridEx(FGrid).InLoadSaveMode := True;
      for i := 1 to tmp.btnCount.AsInteger do
      begin
        FGrid.InsertRow(lCurRow, False);
      end;

      FGrid.CreateViewsName;
      SetGridHeader;
      FGrid.InvalidateGrid;
    end;
  finally
    tmp.Free;
    THackGridEx(FGrid).InLoadSaveMode := False;
  end;
end;

procedure TRMGridReportDesignerForm.itmInsertBottomRowClick(Sender: TObject);
var
  tmp: TRMEditCellWidthForm;
  i, lCurRow: Integer;
begin
  tmp := TRMEditCellWidthForm.Create(nil);
  try
    RMSetStrProp(tmp, 'Caption', rmRes + 859);
    RMSetStrProp(tmp.Label2, 'Caption', rmRes + 857);
    tmp.btnCount.MinValue := 1;
    tmp.btnCount.MaxValue := 99;
    tmp.btnCount.Value := 1;
    tmp.btnCount.Left := 120;
    tmp.RB6.Enabled := False;
    tmp.RB7.Enabled := False;
    tmp.RB8.Enabled := False;
    tmp.RB9.Enabled := False;
    if tmp.ShowModal = mrOK then
    begin
      AddUndoAction(acChangeCellCount);
      Modified := True;
      lCurRow := FGrid.Row;
      if FGrid.Row = FGrid.RowCount - 1 then
        FGrid.RowCount := FGrid.RowCount + tmp.btnCount.AsInteger
      else
      begin
        THackGridEx(FGrid).InLoadSaveMode := True;
        for i := 1 to tmp.btnCount.AsInteger do
        begin
          FGrid.InsertRow(lCurRow + 1, False);
        end;

        FGrid.CreateViewsName;
        SetGridHeader;
        FGrid.InvalidateGrid;
      end;
    end;
  finally
    tmp.Free;
    THackGridEx(FGrid).InLoadSaveMode := False;
  end;
end;

procedure TRMGridReportDesignerForm.itmEditClick(Sender: TObject);
var
  t: TRMView;
begin
  t := PageObjects[TopSelected];

  if ((t.Restrictions * [rmrtDontModify]) <> []) or
    (DesignerRestrictions * [rmdrDontEditObj] <> []) then Exit;

  t.ShowEditor;
  ShowPosition;
  ShowContent;
end;

procedure TRMGridReportDesignerForm.itmFrameTypeClick(Sender: TObject);
var
  t: TRMView;
  tmp: TRMFormFrameProp;
begin
  t := PageObjects[TopSelected];
  tmp := TRMFormFrameProp.Create(nil);
  try
    tmp.ShowEditor(t);
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.Pan5Click(Sender: TObject);
begin
  with Sender as TRMMenuItem do
  begin
    FInspForm.Visible := not FInspForm.Visible;
    Checked := FInspForm.Visible;
  end;

  if FInspForm.Visible then
  begin
    FInspForm.BringToFront;
    FillInspFields;
  end;
end;

function TRMGridReportDesignerForm.FileSaveAs: Boolean;
var
  liSaved: Boolean;
  liFileName: string;
begin
  Result := False;
  if not FCodeMemo.ReadOnly then
  begin
    ClearEmptyEvent;
    Report.Script := FCodeMemo.Lines;
  end;

  if (not (csDesigning in Report.ComponentState)) and (FDesignerComp <> nil) and
    Assigned(FDesignerComp.OnSaveReport) then // 自定义保存
  begin
    liFileName := CurDocName;
    liSaved := True;
    FDesignerComp.OnSaveReport(Report, liFileName, True, liSaved);
    if liSaved then
    begin
      Modified := False;
      CurDocName := liFileName;
      Exit;
    end;
  end;

  SaveDialog1.Filter := RMLoadStr(SFormFile) + ' (*.rls)|*.rls|';
  SaveDialog1.FileName := FCurDocName;
  SaveDialog1.FilterIndex := 1;
  if SaveDialog1.Execute then
  begin
    if SaveDialog1.FilterIndex = 1 then
    begin
      liFileName := ChangeFileExt(SaveDialog1.FileName, '.rls');
      Report.SaveToFile(liFileName);
      Result := True;
      CurDocName := liFileName;
      SetOpenFileMenuItems(liFileName);
      ClearUndoBuffer;
      ClearRedoBuffer;
    end
    else
    begin
    end;
  end;

  if Result then
  begin
    Modified := False;
    ClearUndoBuffer;
    ClearRedoBuffer;
  end;
end;

procedure TRMGridReportDesignerForm.MenuFileSaveasClick(Sender: TObject);
begin
  FileSaveAs;
end;

procedure TRMGridReportDesignerForm.OpenFile(aFileName: string);
var
  w: Integer;
  Opened: Boolean;
begin
  if DesignerRestrictions * [rmdrDontLoadReport] <> [] then
    Exit;

  if Modified then
  begin
    w := Application.MessageBox(PChar(RMLoadStr(SSaveChanges) + ' ' + RMLoadStr(STo) + ' ' +
      ExtractFileName(FCurDocName) + '?'), PChar(RMLoadStr(SConfirm)), mb_IconQuestion + mb_YesNoCancel);
    if (w = mrYes) and (not FileSave) then
      Exit;
  end;

  SetGridNilProp;
  FInspBusy := True;
  Opened := False;
  if (not (csDesigning in Report.ComponentState)) and (FDesignerComp <> nil) and
    Assigned(FDesignerComp.OnLoadReport) then // 自定义打开
  begin
    FDesignerComp.OnLoadReport(Report, aFileName, Opened);
  end;

  if not Opened then
  begin
    if aFileName = '' then
    begin
      OpenDialog1.FileName := '';
      OpenDialog1.Filter := RMLoadStr(SFormFile) + ' (*.rls)|*.rls';
      if (FDesignerComp <> nil) and (FDesignerComp.OpenDir <> '') then
        OpenDialog1.InitialDir := FDesignerComp.OpenDir;
      Opened := OpenDialog1.Execute;
      if Opened then
      begin
        aFileName := OpenDialog1.FileName;
        Opened := Report.LoadFromFile(aFileName);
      end;
    end
    else
      Opened := Report.LoadFromFile(aFileName);
  end;

  FInspBusy := False;
  if Opened then
  begin
    CurDocName := aFileName;
    Modified := False;
    Report.ComponentModified := True;
    FCurPage := -1;
    CurPage := 0; // do all
    SetOpenFileMenuItems(aFileName);
    Script := Report.Script;
    cmbBandsDropDown(nil);
    OnGridClick(nil);
    if FFieldForm.Visible then
      FFieldForm.RefreshData;
    SetGridHeader;
    SetObjectsID;
    ClearUndoBuffer;
    ClearRedoBuffer;
  end
  else
  begin
    CurPage := CurPage;
    SetGridHeader;
  end;

  if Page is TRMGridReportPage then
    FGrid.SetFocus;
end;

procedure TRMGridReportDesignerForm.MenuFileOpenClick(Sender: TObject);
begin
  OpenFile('');
end;

function TRMGridReportDesignerForm.FileSave: Boolean;
var
  liSaved: Boolean;
  liFileName: string;
begin
  Result := False;
  if DesignerRestrictions * [rmdrDontSaveReport] <> [] then Exit;

  if not FCodeMemo.ReadOnly then
    Report.Script := FCodeMemo.Lines;
  if (not (csDesigning in Report.ComponentState)) and (FDesignerComp <> nil) and
    Assigned(FDesignerComp.OnSaveReport) then // 自定义保存
  begin
    liFileName := CurDocName;
    liSaved := True;
    FDesignerComp.OnSaveReport(Report, liFileName, False, liSaved);
    if liSaved then
    begin
      Modified := False;
      CurDocName := liFileName;
      Result := True;
    end;
  end
  else if AnsiCompareText(FCurDocName, RMLoadStr(SUntitled)) <> 0 then
  begin
    Report.SaveToFile(FCurDocName);
    Modified := False;
    SetOpenFileMenuItems(FCurDocName);
    Result := True;
  end
  else
    Result := FileSaveAs;

  if Result then
  begin
    ClearUndoBuffer;
    ClearRedoBuffer;
  end;
end;

procedure TRMGridReportDesignerForm.MenuFileSaveClick(Sender: TObject);
begin
  FileSave;
end;

procedure TRMGridReportDesignerForm.Tab1Change(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FWorkSpace <> nil then
    begin
      FWorkSpace.Visible := False;
      FWorkSpace.PageForm.Visible := False;
    end;
    FCodeMemo.Visible := True;
    FCodeMemo.SetFocus;
    KeyPreview := False;
    EnableControls;
    Exit;
  end;
  CurPage := Tab1.TabIndex - 1;
  KeyPreview := True;
end;

function TRMGridReportDesignerForm.GetScript: TStrings;
begin
  Result := FCodeMemo.Lines;
end;

procedure TRMGridReportDesignerForm.SetScript(Value: TStrings);
begin
  FCodeMemo.ReadOnly := False;
  FCodeMemo.RMClearUndoBuffer;
  FCodeMemo.Lines.Assign(Value);
  if FCodeMemo.Lines.Count = 0 then
  begin
    FCodeMemo.Lines.Add('unit Report;');
    FCodeMemo.Lines.Add('');
    FCodeMemo.Lines.Add('interface');
    FCodeMemo.Lines.Add('');
    FCodeMemo.Lines.Add('implementation');
    FCodeMemo.Lines.Add('');
    FCodeMemo.Lines.Add('procedure Main;');
    FCodeMemo.Lines.Add('begin');
    FCodeMemo.Lines.Add('');
    FCodeMemo.Lines.Add('end;');
    FCodeMemo.Lines.Add('');
    FCodeMemo.Lines.Add('end.');
  end;
  FCodeMemo.ReadOnly := (DesignerRestrictions * [rmdtDontEditScript]) = [rmdtDontEditScript];
end;

procedure TRMGridReportDesignerForm.RefreshData;
begin
  if FFieldForm.Visible then
    FFieldForm.RefreshData;
end;

procedure TRMGridReportDesignerForm.SetCurPage(Value: Integer);
var
  lSaveModified: Boolean;
begin
  FCodeMemo.Visible := False;
  FCurPage := Value;
  Page := Report.Pages[CurPage];
  if Page.Name = '' then Page.CreateName;
  Report.CurrentPage := Page;

  SetGridNilProp;
  if Page is TRMDialogPage then
  begin
    ToolbarComponent.CreateObjects;
    Self.ToolbarComponent.Visible := True;
    if FWorkSpace = nil then
    begin
      SetGridNilProp;
      FWorkSpace := TRMWorkSpace.Create(nil);
      FWorkSpace.DesignerForm := Self;
      FWorkSpace.PageForm := TRMDialogForm.CreateNew(Tab1, 0);
      FWorkSpace.Parent := FWorkSpace.PageForm;
      ObjectPopupMenu := Popup1;
      FWorkSpace.Init;
      FWorkSpace.PageForm.SetPageFormProp;
      FWorkSpace.PageForm.Visible := True;
    end
    else
    begin
      lSaveModified := Modified;
      FWorkSpace.PageForm.SetPageFormProp;
      FWorkSpace.PageForm.Show;
      Modified := lSaveModified;
    end;
  end
  else if (Page is TRMReportPage) and (FGrid = nil) then
  begin
    Self.ToolbarComponent.Visible := False;
    if FWorkSpace <> nil then
    begin
      FWorkSpace.Parent := nil;
      FreeAndNil(FWorkSpace.PageForm);
    end;
    FreeAndNil(FWorkSpace);

    FGrid := TRMGridReportPage(Page).Grid;
    SetGridProp;
    FGrid.CreateViewsName;
    OnGridClick(nil);
  end;

  if Page is TRMDialogPage then
    FWorkSpace.SetPage;
  SetPageTabs;
  Tab1.TabIndex := FCurPage + 1;
  ResetSelection;
  if Page is TRMDialogPage then
    FWorkSpace.Repaint;
end;

procedure TRMGridReportDesignerForm.SetCurDocName(Value: string);
var
  str: string;
begin
  FCurDocName := Value;
  FCurDocName := Value;
  if Report.ReportInfo.Title <> '' then
    str := Report.ReportInfo.Title + '(' + ExtractFileName(Value) + ')'
  else
    str := ExtractFileName(Value);

  Caption := FCaption + ' - ' + str;
end;

function TRMGridReportDesignerForm.GetUnitType: TRMUnitType;
begin
  Result := FUnitType;
end;

procedure TRMGridReportDesignerForm.SetUnitType(aValue: TRMUnitType);
begin
  FUnitType := aValue;
end;

procedure TRMGridReportDesignerForm.SetPageTabs;
var
  i: Integer;
begin
  Tab1.Tabs.BeginUpdate;
  if Tab1.Tabs.Count - 1 = Report.Pages.Count then
  begin
    for i := 0 to Report.Pages.Count - 1 do
      Tab1.TabsCaption[i + 1] := Report.Pages[i].Name;
  end
  else
  begin
    Tab1.Tabs.Clear;
    Tab1.AddTab(RMLoadStr(rmRes + 253));
    for i := 0 to Report.Pages.Count - 1 do
    begin
      Tab1.AddTab(Report.Pages[i].Name);
    end;
  end;
  Tab1.Tabs.EndUpdate;
end;

function TRMGridReportDesignerForm._GetSelectionStatus: TRMSelectionStatus;
begin
  Result := [];
  if SelNum = 1 then
    Result := [rmssOther]
  else if SelNum > 1 then
    Result := [rmssMultiple];
end;

function TRMGridReportDesignerForm._DelEnabled: Boolean;
var
  lSelStatus: TRMSelectionStatus;
begin
  lSelStatus := _GetSelectionStatus;
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanCut and (not FCodeMemo.ReadOnly)
  else if Page is TRMGridReportPage then
    Result := False
  else
    Result := [rmssMemo, rmssOther, rmssMultiple] * lSelStatus <> [];
end;

function TRMGridReportDesignerForm._CutEnabled: Boolean;
var
  lSelStatus: TRMSelectionStatus;
begin
  lSelStatus := _GetSelectionStatus;
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanCut and (not FCodeMemo.ReadOnly)
  else if Page is TRMGridReportPage then
    Result := FGrid.CanCut
  else
    Result := [rmssMemo, rmssOther, rmssMultiple] * lSelStatus <> [];
end;

function TRMGridReportDesignerForm._CopyEnabled: Boolean;
var
  lSelStatus: TRMSelectionStatus;
begin
  lSelStatus := _GetSelectionStatus;
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanCopy
  else if Page is TRMGridReportPage then
    Result := FGrid.CanCopy
  else
    Result := [rmssMemo, rmssOther, rmssMultiple] * lSelStatus <> [];
end;

function TRMGridReportDesignerForm._PasteEnabled: Boolean;
var
  lSelStatus: TRMSelectionStatus;
begin
  lSelStatus := _GetSelectionStatus;
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanPaste and (not FCodeMemo.ReadOnly)
  else if Page is TRMGridReportPage then
    Result := FGrid.CanPaste
  else
    Result := Clipboard.HasFormat(CF_REPORTMACHINE);
end;

procedure TRMGridReportDesignerForm.EnableControls;
var
  lSelStatus: TRMSelectionStatus;

  procedure _SetEnabled(const Ar: array of TObject; aEnabled: Boolean);
  var
    i: Integer;
  begin
    for i := Low(Ar) to High(Ar) do
    begin
      if Ar[i] is TRMToolbarButton then
        TRMToolbarButton(Ar[i]).Enabled := aEnabled
      else if Ar[i] is TControl then
        TControl(Ar[i]).Enabled := aEnabled
      else if Ar[i] is TRMMenuItem then
        TRMMenuItem(Ar[i]).Enabled := aEnabled
      else if Ar[i] is TMenuItem then
        TMenuItem(Ar[i]).Enabled := aEnabled;
    end;
  end;

  function _EditEnabled: Boolean;
  begin
    if Tab1.TabIndex = 0 then
      Result := False
    else if Page is TRMGridReportPage then
      Result := False
    else
      Result := [rmssMemo, rmssOther] * lSelStatus <> [];
  end;

  function _RedoEnabled: Boolean;
  begin
    if Tab1.TabIndex = 0 then
      Result := False
    else
    begin
      Result := FRedoBufferLength > 0;
    end;
  end;

  function _UndoEnabled: Boolean;
  begin
    if Tab1.TabIndex = 0 then
      Result := FCodeMemo.RMCanUndo and (not FCodeMemo.ReadOnly)
    else
    begin
      Result := FUndoBufferLength > 0;
    end;
  end;

begin
  //  barSearch.Visible := Tab1.TabIndex = 0;
  _SetEnabled([barSearch, padSearchFind, padSearchReplace, padSearchFindAgain], Tab1.TabIndex = 0);

  lSelStatus := _GetSelectionStatus;
  with ToolbarStandard do
    _SetEnabled([btnAddPage, MenuEditAddPage, btnAddForm, MenuEditAddForm],
      (DesignerRestrictions * [rmdrDontCreatePage] = []));
  _SetEnabled([ToolbarStandard.btnDeletePage, MenuEditDeletePage],
    (Tab1.TabIndex > 0) and (DesignerRestrictions * [rmdrDontDeletePage] = []));
  _SetEnabled([ToolbarStandard.btnPrint, ToolbarStandard.btnPreview1, ToolbarStandard.btnPreview, MenuFilePrint, MenuFilePreview, MenuFilePreview1],
    (not IsPreviewDesignReport) and (DesignerRestrictions * [rmdrDontPreviewReport] = []));
  _SetEnabled([ToolbarStandard.btnFileSave, MenuFileSave],
    Modified and (DesignerRestrictions * [rmdrDontSaveReport] = []));
  _SetEnabled([MenuFileSaveAs], not (DesignerRestrictions * [rmdrDontSaveReport] <> []));
  _SetEnabled([MenuFileDict, MenuFileImportDict, MenuFileMergeDict, MenuFileExportDict],
    (DesignerRestrictions * [rmdrDontEditVariables] = []));
  _SetEnabled([MenuFilePageSetup, ToolbarStandard.btnPageSetup],
    ((Tab1.TabIndex > 0)) and (DesignerRestrictions * [rmdrDontChangeReportOptions] = []));
  _SetEnabled([MenuEditCopyPage, MenuEditPastePage], (Tab1.TabIndex > 0) and (Page is TRMGridReportPage));
  _SetEnabled([MenuFileHeaderFooter], (Tab1.TabIndex > 0) and (Page is TRMGridReportPage) and TRMGridReportPage(Page).UseHeaderFooter);

  with ToolbarBorder do
  begin
    _SetEnabled([btnFrameTop, btnFrameLeft, btnFrameBottom, btnFrameRight, btnSetBorder, btnNoBorder,
      btnTopBorder, btnBottomBorder, btnBias1Border, btnBias2Border,
        btnDecWidth, btnIncWidth, btnDecHeight, btnIncHeight, cmbBands,
        btnAddBand, btnDeleteBand, btnColumnMin, btnColumnMax, btnRowMin, btnRowMax], (Tab1.TabIndex > 0) and (Page is TRMGridReportPage));
  end;
  with ToolbarEdit do
  begin
    _SetEnabled([FBtnFontColor, FcmbFont, FcmbFontSize, btnFontBold, btnFontItalic,
      btnFontUnderline, btnHLeft, btnHRight, btnHCenter, btnHSpaceEqual, btnVTop,
        btnVBottom, btnVCenter, FBtnBackColor, FBtnFrameColor, FCmbFrameWidth], (Tab1.TabIndex > 0) and (Page is TRMGridReportPage));
  end;
  with ToolbarGrid do
  begin
    _SetEnabled([btnInsertColumn, btnInsertRow, btnAddColumn, btnAddRow, btnDeleteColumn,
      btnDeleteRow, btnSetRowsAndColumns, btnMerge, btnSplit, btnMergeColumn, btnMergeRow],
        (Tab1.TabIndex > 0) and (Page is TRMGridReportPage));
  end;

  ToolbarCellEdit.FBtnExpression.Enabled := True; {(Tab1.TabIndex = 0) or ((Page is TRMGridReportPage) and (SelNum = 1));}
  ToolbarCellEdit.FBtnDBField.Enabled := ToolbarCellEdit.FBtnExpression.Enabled; //(Tab1.TabIndex > 0);
  ToolbarCellEdit.FEdtMemo.Enabled := (Tab1.TabIndex > 0) and (Page is TRMGridReportPage);

  _SetEnabled([ToolbarStandard.btnCut, MenuEditCut, padpopCut, SelectionMenu_popCut], _CutEnabled);
  _SetEnabled([ToolbarStandard.btnCopy, MenuEditCopy, padpopCopy, SelectionMenu_popCopy], _CopyEnabled);
  _SetEnabled([ToolbarStandard.btnPaste, MenuEditPaste, padpopPaste, SelectionMenu_popPaste], _PasteEnabled);
  _SetEnabled([MenuEditDelete, padpopDelete], _DelEnabled);
  _SetEnabled([padpopEdit], _EditEnabled);
  //  _SetEnabled([MenuEditSelectAll], (Page is TRMDialogPage));
  _SetEnabled([ToolbarStandard.btnPrint, MenuFilePrint], MenuFilePrint.Enabled and (RMPrinters.Count >= 2));
  _SetEnabled([ToolbarStandard.btnUndo, MenuEditUndo], _UndoEnabled);
  _SetEnabled([ToolbarStandard.btnRedo, MenuEditRedo], _RedoEnabled);

  _SetEnabled([MenuCellTableSize, MenuCellInsertCell, MenuCellInsertColumn,
    MenuCellInsertRow, MenuCellDeleteColumn, MenuCellDeleteRow, MenuCellRow, MenuCellColumn],
      (Tab1.TabIndex > 0) and (Page is TRMGridReportPage));
  _SetEnabled([itmInsert, itmDelete], (Tab1.TabIndex > 0) and (Page is TRMGridReportPage));
  _SetEnabled([MenuEditMerge, MenuEditReverse, itmMergeCells, itmSplitCells, itmCellType],
    (Tab1.TabIndex > 0) and (Page is TRMGridReportPage));
  _SetEnabled([MenuCellProperty], (Tab1.TabIndex > 0) and (Page is TRMGridReportPage));
end;

procedure TRMGridReportDesignerForm.ShowPosition;
begin
  if Tab1.TabIndex = 0 then
  begin
    StatusBar1.Panels[1].Text := RMLoadStr(rmRes + 578) + IntToStr(FCodeMemo.CaretY) +
      '  ' + RMLoadStr(rmRes + 579) + IntToStr(FCodeMemo.CaretX);
  end
  else
  begin
    StatusBar1.Panels[1].Text := '';
    if not FInspBusy then
      FillInspFields;
  end;
end;

procedure TRMGridReportDesignerForm.ShowContent;
var
  t: TRMView;
  s: string;
begin
  s := '';
  if SelNum = 1 then
  begin
    t := PageObjects[TopSelected];
    s := t.Name;
    if t.IsBand then
      s := s + ': ' + RMBandNames[TRMCustomBandView(t).BandType]
    else if t.Memo.Count > 0 then
      s := s + ': ' + t.Memo[0];
  end;
  StatusBar1.Panels[2].Text := s;

  if FGrid <> nil then
  begin
    ToolbarCellEdit.FLblCell.Caption := RMLoadStr(rmRes + 578) + IntToStr(FGrid.Row) +
      ' ' + RMLoadStr(rmRes + 579) + IntToStr(FGrid.Col);
    ToolbarCellEdit.FEdtMemo.Text := FGrid.Cells[FGrid.Col, FGrid.Row].Text;
    //    if ToolbarCellEdit.FEdtMemo.CanFocus then
    //      ToolbarCellEdit.FEdtMemo.SetFocus;
  end;
end;

procedure TRMGridReportDesignerForm.ResetSelection;
begin
  UnselectAll;
  SelNum := 0;
  EnableControls;
  ShowPosition;
end;

procedure TRMGridReportDesignerForm.MenuFileDictClick(Sender: TObject);
var
  tmp: TRMDictionaryForm;
begin
  if DesignerRestrictions * [RMdrDontEditVariables] <> [] then
    Exit;
  tmp := TRMDictionaryForm.Create(nil);
  try
    tmp.Report := Report;
    if tmp.ShowModal = mrOk then
    begin
      Modified := True;
      if FFieldForm.Visible then
        FFieldForm.RefreshData;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.MenuFileImportDictClick(
  Sender: TObject);
begin
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := RMLoadStr(SDictFile) + ' (*.rmd)|*.rmd';
  if (FDesignerComp <> nil) and (FDesignerComp.OpenDir <> '') then
    OpenDialog1.InitialDir := FDesignerComp.OpenDir;
  if OpenDialog1.Execute then
    Report.Dictionary.LoadFromFile(OpenDialog1.FileName);
end;

procedure TRMGridReportDesignerForm.MenuFileMergeDictClick(
  Sender: TObject);
begin
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := RMLoadStr(SDictFile) + ' (*.rmd)|*.rmd';
  if (FDesignerComp <> nil) and (FDesignerComp.OpenDir <> '') then
    OpenDialog1.InitialDir := FDesignerComp.OpenDir;
  if OpenDialog1.Execute then
    Report.Dictionary.MergeFromFile(OpenDialog1.FileName);
end;

procedure TRMGridReportDesignerForm.MenuFileExportDictClick(
  Sender: TObject);
begin
  SaveDialog1.FileName := '';
  SaveDialog1.Filter := RMLoadStr(SDictFile) + ' (*.rmd)|*.rmd';
  if (FDesignerComp <> nil) and (FDesignerComp.SaveDir <> '') then
    SaveDialog1.InitialDir := FDesignerComp.SaveDir;
  SaveDialog1.FileName := CurDocName;
  if SaveDialog1.Execute then
    Report.Dictionary.SaveToFile(ChangeFileExt(SaveDialog1.FileName, '.rmd'));
end;

procedure TRMGridReportDesignerForm.MenuFilePageSetupClick(
  Sender: TObject);
begin
  if DesignerRestrictions * [rmdrDontEditPage] <> [] then
    Exit;

  PageSetup;
end;

procedure TRMGridReportDesignerForm.MenuFilePreview1Click(Sender: TObject);
var
  liSaveModalPreview: Boolean;
  liSaveVisible: Boolean;
  lSaveStream: TMemoryStream;

  procedure _ChangeObjects;
  var
    i, j: Integer;
    lPage: TRMCustomPage;
    t: TRMView;
    lGrid: TRMGridEx;
    lRow, lCol: Integer;
    lCell: TRMCellInfo;
  begin
    for i := 0 to Report.Pages.Count - 1 do
    begin
      lPage := Report.Pages[i];
      if lPage is TRMGridReportPage then
      begin
        lGrid := TRMGridReportPage(lPage).Grid;
        for j := 1 to lGrid.RowCount - 1 do
        begin
          TRMGridReportPage(lPage).RowBandViews[j] := nil;
        end;

        for lRow := 1 to lGrid.RowCount - 1 do
        begin
          lCol := 1;
          while lCol < lGrid.ColCount do
          begin
            lCell := lGrid.Cells[lCol, lRow];
            if lCell.StartRow = lRow then
            begin
              if lCell.View <> nil then
                THackReportView(lCell.View).TextOnly := True;
            end;
            lCol := lCell.EndCol + 1;
          end;
        end;
      end;

      for j := lPage.Objects.Count - 1 downto 0 do
      begin
        t := lPage.Objects[j];
        if t is TRMReportView then
          THackReportView(t).TextOnly := True;
        if t.IsBand then
        begin
          lPage.Delete(j);
        end;
      end;
    end;
  end;

begin
  FGrid := nil;
  liSaveModalPreview := Report.ModalPreview;
  liSaveVisible := FInspForm.Visible;
  Application.ProcessMessages;
  Report.ModalPreview := True;
  FBusy := True;
  FInspBusy := True;
  Page := nil;

  lSaveStream := TMemoryStream.Create;
  try
    Report.SaveToStream(lSaveStream);
    _ChangeObjects;

    Report.Script.Clear;
    FInspForm.Hide;
    Report.Preview := nil;
    Report.ShowReport;
  finally
    lSaveStream.Position := 0;
    Report.LoadFromStream(lSaveStream);
    lSaveStream.Free;

    Report.ModalPreview := liSaveModalPreview;
    FInspBusy := False;
    FBusy := False;
    FInspForm.Visible := liSaveVisible;
    CurPage := CurPage;
    SelectionChanged(True);
    Screen.Cursor := crDefault;

    if Page is TRMGridReportPage then
      FGrid.SetFocus;
  end;
end;

procedure TRMGridReportDesignerForm.MenuFilePreviewClick(Sender: TObject);
var
  liSaveModalPreview: Boolean;
  liSaveVisible: Boolean;
begin
  if DesignerRestrictions * [rmdrDontPreviewReport] <> [] then
    Exit;

  FGrid := nil;
  liSaveModalPreview := Report.ModalPreview;
  liSaveVisible := FInspForm.Visible;
  Application.ProcessMessages;
  Report.ModalPreview := True;
  FBusy := True;
  FInspBusy := True;
  Page := nil;
  try
    if not FCodeMemo.ReadOnly then
      Report.Script.Assign(Script);
    FInspForm.Hide;
    Report.Preview := nil;
    Report.ShowReport;
  finally
    Report.ModalPreview := liSaveModalPreview;
    FInspBusy := False;
    FBusy := False;
    FInspForm.Visible := liSaveVisible;
    CurPage := CurPage;
    SelectionChanged(True);
    Screen.Cursor := crDefault;
    if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnShow) then
      FDesignerComp.OnShow(Self);
    if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnClose) then
      FDesignerComp.OnClose(Self);

    if Page is TRMGridReportPage then
      FGrid.SetFocus;
  end;
end;

procedure TRMGridReportDesignerForm.MenuFilePrintClick(Sender: TObject);
var
  liSaveVisible: Boolean;
begin
  if RMPrinters.Count < 2 then Exit;

  FGrid := nil;
  liSaveVisible := FInspForm.Visible;
  Application.ProcessMessages;
  FBusy := True;
  FInspBusy := True;
  Page := nil;
  try
    if not FCodeMemo.ReadOnly then
      Report.Script.Assign(Script);
    FInspForm.Hide;
    Report.PrintReport;
  finally
    FInspBusy := False;
    FBusy := False;
    FInspForm.Visible := liSaveVisible;
    CurPage := CurPage;
    //    SelectionChanged(True);
    Screen.Cursor := crDefault;
    if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnShow) then
      FDesignerComp.OnShow(Self);

    if Page is TRMGridReportPage then
      FGrid.SetFocus;
  end;
end;

procedure TRMGridReportDesignerForm.MenuFilePropClick(Sender: TObject);
var
  tmp: TRMReportProperty;
begin
  tmp := TRMReportProperty.Create(nil);
  try
    tmp.ReportInfo := Report.ReportInfo;
    if tmp.ShowModal = mrOK then
    begin
      Report.ReportInfo := tmp.ReportInfo;
      Modified := True;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.MenuFileNewClick(Sender: TObject);
var
  tmpWizard: TRMCustomReportWizard;
  tmp: TRMTemplForm;
  lStream: TMemoryStream;
  lNewReportFlag: Boolean;
begin
  if (FDesignerComp <> nil) and (FDesignerComp.DesignerRestrictions * [rmdrDontCreateReport] <> []) then
    Exit;

  if FDesignerComp <> nil then
    RMTemplateDir := FDesignerComp.TemplateDir;

  lNewReportFlag := False;
  SetGridNilProp;

  tmp := TRMTemplForm.Create(nil);
  try
    tmp.CurrentReport := Report;
    tmp.FileExt := '*.rlt';
    tmp.ReportType := 2;
    if tmp.ShowModal = mrOk then
    begin
      if tmp.atype = 1 then
      begin
        if Length(tmp.TemplName) > 0 then
        begin
          Report.LoadTemplate(tmp.TemplName, nil, nil);
          CurDocName := RMLoadStr(SUntitled);
          CurPage := 0;
          SetObjectsID;
          lNewReportFlag := False;
        end
        else
          btnFileNewClick(nil);
      end
      else
      begin
        tmpWizard := tmp.WizardClass.Create;
        lStream := TMemoryStream.Create;
        try
          if tmpWizard.DoCreateReport then
          begin
            tmpWizard.GetReportStream(lStream);

            lStream.Position := 0;
            Report.LoadFromStream(lStream);
            lNewReportFlag := True;
          end;
        finally
          tmpWizard.Free;
          lStream.Free;
        end;
      end;
    end;
  finally
    tmp.Free;
  end;

    FCurPage := -1;
    CurPage := 0;

  if lNewReportFlag then
  begin
    CurDocName := RMLoadStr(SUntitled);
    Modified := False;
    Report.ComponentModified := True;
    Script := Report.Script;
    cmbBandsDropDown(nil);
    OnGridClick(nil);
    if FFieldForm.Visible then
      FFieldForm.RefreshData;

    SetGridHeader;
    SetObjectsID;
    ClearUndoBuffer;
    ClearRedoBuffer;

    if Page is TRMGridReportPage then
      FGrid.SetFocus;
  end;
end;

procedure TRMGridReportDesignerForm.btnFileNewClick(Sender: TObject);
var
  w: Word;
  liPage: TRMGridReportPage;
begin
  if DesignerRestrictions * [rmdrDontCreateReport] <> [] then Exit;

  if Modified then
  begin
    w := Application.MessageBox(PChar(RMLoadStr(SSaveChanges) + ' ' + RMLoadStr(STo) + ' ' +
      ExtractFileName(FCurDocName) + '?'),
      PChar(RMLoadStr(SConfirm)), mb_IconQuestion + mb_YesNoCancel);
    if w = mrCancel then Exit;
    if w = mrYes then
    begin
      if not FileSave then Exit;
    end;
  end;

  SetGridNilProp;
  Report.NewReport;
  if (FDesignerComp <> nil) and (FDesignerComp.DefaultDictionaryFile <> '') and
    FileExists(FDesignerComp.DefaultDictionaryFile) then
    Report.Dictionary.LoadFromFile(FDesignerComp.DefaultDictionaryFile);

  liPage := TRMGridReportPage(TRMGridReport(Report).CreatePage('TRMGridReportPage'));
  Report.Pages.PagesList.Add(liPage);
  Report.Pages[0].CreateName;

  FCurPage := -1;
  CurPage := 0;
  CurDocName := RMLoadStr(SUntitled);
  Modified := False;
  Report.ComponentModified := True;
  Script := Report.Script;
  cmbBandsDropDown(nil);
  OnGridClick(nil);
  if FFieldForm.Visible then
    FFieldForm.RefreshData;
  SetGridHeader;
  SetObjectsID;
  ClearUndoBuffer;
  ClearRedoBuffer;

  if Page is TRMGridReportPage then
    FGrid.SetFocus;
end;

procedure TRMGridReportDesignerForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  w: Integer;
begin
  if ((csDesigning in Report.ComponentState) and Report.StoreInDFM) or
    (not Modified) then
    CanClose := True
  else
  begin
    if not FCodeMemo.ReadOnly then
      Report.Script := FCodeMemo.Lines;
    if (not IsPreviewDesign) and (not IsPreviewDesignReport) then
      w := Application.MessageBox(PChar(RMLoadStr(SSaveChanges) + ' ' + RMLoadStr(STo) + ' ' +
        ExtractFileName(CurDocName) + '?'), PChar(RMLoadStr(SConfirm)), mb_IconQuestion + mb_YesNoCancel)
    else
      w := Application.MessageBox(PChar(RMLoadStr(SSaveChanges) + '?'),
        PChar(RMLoadStr(SConfirm)), mb_IconQuestion + mb_YesNoCancel);

    CanClose := False;
    case w of
      mrYes:
        begin
          if not IsPreviewDesign then
          begin
            if IsPreviewDesignReport then
            begin
              RMDesigner.Modified := False;
              Report.Modified := True;
              CanClose := True;
              ModalResult := mrOK;
            end
            else
            begin
              CanClose := FileSave;
              if CanClose then
              begin
                Modified := True;
                ModalResult := mrOK;
              end;
            end;
          end
          else
          begin
            //            Report.EndPages[EndPageNo].ObjectsToStream(Report);
            //            Report.CanRebuild := False;
            RMDesigner.Modified := False;
            Report.Modified := True;
            CanClose := True;
            ModalResult := mrOK;
          end;
        end;
      mrNo:
        begin
          CanClose := True;
          ModalResult := mrCancel;
        end;
    end;
  end;
end;

procedure TRMGridReportDesignerForm.btnAddPageClick(Sender: TObject);
var
  liPage: TRMGridReportPage;
begin
  if DesignerRestrictions * [rmdrDontCreatePage] <> [] then
    Exit;
  ResetSelection;

  liPage := TRMGridReportPage(TRMGridReport(Report).CreatePage('TRMGridReportPage'));
  Report.Pages.PagesList.Add(liPage);
  Page := liPage;
  Page.CreateName;
  if PageSetup then
  begin
    Modified := True;
    CurPage := Report.Pages.Count - 1;
  end
  else
  begin
    Report.Pages.Delete(Report.Pages.Count - 1);
    CurPage := CurPage;
  end;
end;

procedure TRMGridReportDesignerForm.btnDeletePageClick(Sender: TObject);

  function _IsSubReportPage(aPageNo: Integer): Boolean;
  var
    i, lRow, lCol: Integer;
    lGrid: TRMGridEx;
    lCell: TRMCellInfo;
  begin
    Result := False;
    for i := 0 to Report.Pages.Count - 1 do
    begin
      if not (Report.Pages[i] is TRMGridReportPage) then Continue;

      lGrid := TRMGridReportPage(Report.Pages[i]).Grid;
      for lRow := 1 to lGrid.RowCount - 1 do
      begin
        lCol := 1;
        while lCol < lGrid.ColCount do
        begin
          lCell := lGrid.Cells[lCol, lRow];
          if lCell.StartRow = lRow then
          begin
            if (lCell.View is TRMSubReportView) and (TRMSubReportView(lCell.View).SubPage = aPageNo) then
            begin
              Result := True;
              Exit;
            end;
          end;
          lCol := lCell.EndCol + 1;
        end;
      end;
    end;
  end;

  procedure _AlignmentSubReports(aPageNo: Integer);
  var
    i, lRow, lCol: Integer;
    lGrid: TRMGridEx;
    lCell: TRMCellInfo;
    t: TRMView;
  begin
    for i := 0 to Report.Pages.Count - 1 do
    begin
      if not (Report.Pages[i] is TRMGridReportPage) then Continue;

      lGrid := TRMGridReportPage(Report.Pages[i]).Grid;
      for lRow := 1 to lGrid.RowCount - 1 do
      begin
        lCol := 1;
        while lCol < lGrid.ColCount do
        begin
          lCell := lGrid.Cells[lCol, lRow];
          if lCell.StartRow = lRow then
          begin
            t := lCell.View;
            if (t is TRMSubReportView) and (TRMSubReportView(t).SubPage > aPageNo) then
            begin
              TRMSubReportView(t).SubPage := TRMSubReportView(t).SubPage - 1;
            end;
          end;
          lCol := lCell.EndCol + 1;
        end;
      end;
    end;
  end;

  procedure _RemovePage(aPageNo: Integer);
  begin
    Modified := True;
    if (aPageNo >= 0) and (aPageNo < Report.Pages.Count) then
    begin
      SetGridNilProp;
      Report.Pages.Delete(aPageNo);
      Tab1.Tabs.Delete(aPageNo + 1);
      Tab1.TabIndex := 1;
      _AlignmentSubReports(aPageNo);
      CurPage := 0;
    end;
  end;

begin
  if DesignerRestrictions * [rmdrDontDeletePage] <> [] then Exit;

  if Report.Pages.Count > 1 then
  begin
    if _IsSubReportPage(CurPage) then
    begin
    end
    else
    begin
      if MessageBox(0, PChar(RMLoadStr(SRemovePg)),
        PChar(RMLoadStr(SConfirm)), mb_IconQuestion + mb_YesNo) = mrYes then
      begin
        _RemovePage(CurPage);
        Modified := True;
      end;
    end;
  end;
end;

procedure TRMGridReportDesignerForm.Tab1DragDrop(Sender, Source: TObject;
  X, Y: Integer);
var
  i, lNewIndex: Integer;
  lHitTestInfo: TTCHitTestInfo;

  procedure _ChangeSubReports(aOldSubPage, aNewSubPage: Integer);
  var
    i, lRow, lCol: Integer;
    lGrid: TRMGridEx;
    lCell: TRMCellInfo;
    t: TRMView;
  begin
    for i := 0 to Report.Pages.Count - 1 do
    begin
      if not (Report.Pages[i] is TRMGridReportPage) then Continue;

      lGrid := TRMGridReportPage(Report.Pages[i]).Grid;
      for lRow := 1 to lGrid.RowCount - 1 do
      begin
        lCol := 1;
        while lCol < lGrid.ColCount do
        begin
          lCell := lGrid.Cells[lCol, lRow];
          if lCell.StartRow = lRow then
          begin
            t := lCell.View;
            if (t is TRMSubReportView) and (TRMSubReportView(t).SubPage = aOldSubPage) then
            begin
              TRMSubReportView(t).SubPage := aNewSubPage;
            end;
          end;
          lCol := lCell.EndCol + 1;
        end;
      end;
    end;
  end;

begin
  lHitTestInfo.pt := Point(X, Y);
  lNewIndex := SendMessage(Tab1.Handle, TCM_HITTEST, 0, Longint(@lHitTestInfo));
  if (lNewIndex <= 1) or (lNewIndex = Tab1.TabIndex) then Exit;

  Dec(lNewIndex);
  if CurPage > lNewIndex then
  begin
    _ChangeSubReports(CurPage, -1);
    for i := CurPage - 1 downto lNewIndex do
      _ChangeSubReports(i, i + 1);
    _ChangeSubReports(-1, lNewIndex);
  end
  else
  begin
    _ChangeSubReports(CurPage, -1);
    for i := CurPage + 1 to lNewIndex do
      _ChangeSubReports(i, i - 1);
    _ChangeSubReports(-1, lNewIndex);
  end;

  Tab1.Tabs.Move(CurPage + 1, lNewIndex + 1);
  Report.Pages.Move(CurPage, lNewIndex);
  CurPage := lNewIndex;
  Modified := True;
end;

procedure TRMGridReportDesignerForm.Tab1DragOver(Sender, Source: TObject;
  X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  lHitTestInfo: TTCHitTestInfo;
  lHitIndex: Integer;
begin
  Accept := Source = Tab1;
  if Accept then
  begin
    lHitTestInfo.pt := Point(X, Y);
    lHitIndex := SendMessage(Tab1.Handle, TCM_HITTEST, 0, Longint(@lHitTestInfo));
    Accept := (lHitIndex > 0) and (lHitIndex < Tab1.TabIndex);
  end;
end;

procedure TRMGridReportDesignerForm.Tab1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    FMouseDown := True;
end;

procedure TRMGridReportDesignerForm.Tab1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Tab1.TabIndex > 0) and FMouseDown then
    Tab1.BeginDrag(False);
end;

procedure TRMGridReportDesignerForm.Tab1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMouseDown := False;
end;

procedure TRMGridReportDesignerForm.cmbBandsDropDown(Sender: TObject);
var
  i: Integer;
  t: TRMView;
  liSaveItemIndex: Integer;
begin
  liSaveItemIndex := ToolbarBorder.cmbBands.ItemIndex;
  ToolbarBorder.cmbBands.Items.Clear;
  ToolbarBorder.cmbBands.Items.Add('');
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    if t.IsBand then
      ToolbarBorder.cmbBands.Items.Add(RMBandNames[TRMCustomBandView(t).BandType] + '(' + t.Name + ')');
  end;
  ToolbarBorder.cmbBands.ItemIndex := liSaveItemIndex;
end;

procedure TRMGridReportDesignerForm.cmbBandsClick(Sender: TObject);
var
  str: string;
  i: Integer;
begin
  Modified := True;
  if ToolbarBorder.cmbBands.ItemIndex < 1 then
  begin
    for i := FGrid.Selection.Top to FGrid.Selection.Bottom do
      TRMGridReportPage(Page).RowBandViews[i] := nil;
    UnselectAll;
    SelectionChanged(True);
  end
  else
  begin
    str := ToolbarBorder.cmbBands.Text;
    if str <> '' then
    begin
      SetLength(str, Length(str) - 1);
      str := Copy(str, Pos('(', str) + 1, Length(str));
      for i := FGrid.Selection.Top to FGrid.Selection.Bottom do
        TRMGridReportPage(Page).RowBandViews[i] := Page.FindObject(str);
      InspSelectionChanged(str);
    end;
  end;

  SetGridHeader;
  FGrid.InvalidateGrid;
end;

procedure TRMGridReportDesignerForm.OnAddBandEvent(Sender: TObject);
var
  i: integer;
  t: TRMView;
  str: string;
begin
  AddUndoAction(acChangePage);
  UnselectAll;
  t := RMCreateBand(TRMBandType(TComponent(Sender).Tag));
  t.ParentPage := Page;
  cmbBandsDropDown(nil);
  ToolbarBorder.cmbBands.ItemIndex := ToolbarBorder.cmbBands.Items.IndexOf(RMBandNames[TRMCustomBandView(t).BandType] + '(' + t.Name + ')');

  str := t.Name;
  for i := FGrid.Selection.Top to FGrid.Selection.Bottom do
  begin
    TRMGridReportPage(Page).RowBandViews[i] := Page.FindObject(str);
  end;

  InspSelectionChanged(str);

  SetObjectID(t);
  SetGridHeader;
  FGrid.InvalidateGrid;
  Modified := True;

  OnGridRowHeaderDblClick(nil);
end;

procedure TRMGridReportDesignerForm.PopupMenuBandsPopup(Sender: TObject);
var
  i: Integer;
  lMenuItem: TRMMenuItem;
begin
  for i := 0 to PopupMenuBands.Items.Count - 1 do
  begin
    lMenuItem := TRMMenuItem(PopupMenuBands.Items[i]);
    lMenuItem.Enabled := (TRMBandType(lMenuItem.Tag) in [rmbtHeader, rmbtFooter, rmbtGroupHeader,
      rmbtGroupFooter, rmbtMasterData, rmbtDetailData]) or
      (not HaveBand(TRMBandType((lMenuItem.Tag))));

    if TRMGridReportPage(Page).UseHeaderFooter and (TRMBandType(lMenuItem.Tag) in [rmbtReportTitle, rmbtReportSummary, rmbtPageHeader, rmbtPageFooter]) then
      lMenuItem.Enabled := False;
  end;
end;

procedure TRMGridReportDesignerForm.btnDeleteBandClick(Sender: TObject);
var
  str: string;
begin
  if ToolbarBorder.cmbBands.ItemIndex > 0 then
  begin
    str := ToolbarBorder.cmbBands.Text;
    if str <> '' then
    begin
      AddUndoAction(acChangePage);
      Modified := True;
      SetLength(str, Length(str) - 1);
      str := Copy(str, Pos('(', str) + 1, Length(str));
      TRMGridReportPage(Page).RowBandViews[FGrid.Row] := nil;
      Page.Delete(Page.IndexOf(str));
      ToolbarBorder.cmbBands.ItemIndex := 0;
      cmbBandsDropDown(nil);
      SetGridHeader;

      FGrid.InvalidateGrid;
      if AnsiCompareText(FInspForm.cmbObjects.Text, str) = 0 then
      begin
        UnSelectAll;
        SelNum := 0;
        SelectionChanged(True);
      end;
    end;
  end;
end;

procedure TRMGridReportDesignerForm.OnDockRequestDockEvent(Sender: TObject;
  Bar: TRMCustomDockableWindow; var Accept: Boolean);
begin
  Accept := not ((Bar = FInspForm) or (Bar = FFieldForm));
end;

procedure TRMGridReportDesignerForm.MenuFileExitClick(Sender: TObject);
begin
  if FormStyle = fsNormal then
    ModalResult := mrOk
  else
    Close;
end;

procedure TRMGridReportDesignerForm.MenuHelpAboutClick(Sender: TObject);
begin
  if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnShowAboutForm) then
    FDesignerComp.OnShowAboutForm(nil)
  else
    TRMFormAbout.Create(Application).ShowModal;
end;

procedure TRMGridReportDesignerForm.MenuEditToolbarClick(Sender: TObject);
begin
  itmToolbarStandard.Checked := ToolbarStandard.Visible;
  itmToolbarText.Checked := ToolbarEdit.Visible;
  itmToolbarBorder.Checked := ToolbarBorder.Visible;
  itmToolbarInspector.Checked := FInspForm.Visible;
  itmToolbarInsField.Checked := FFieldForm.Visible;
  itmToolbarGrid.Checked := ToolbarGrid.Visible;
  itmToolbarCellEdit.Checked := ToolbarCellEdit.Visible;
end;

procedure TRMGridReportDesignerForm.itmToolbarStandardClick(Sender: TObject);

  procedure _SetShow(aControls: array of TWinControl; i: Integer; aVisible: Boolean);
  begin
    if aControls[i] is TRMToolbar then
      TRMToolbar(aControls[i]).Visible := aVisible
    else if aControls[i] is TForm then
      TForm(aControls[i]).Visible := aVisible
    else if aControls[i] is TRMToolWin then
    begin
      TRMToolWin(aControls[i]).Visible := aVisible;
      if aVisible then
        TRMToolWin(aControls[i]).BringToFront;
    end;
  end;

begin
  //dejoy changed
  with Sender as TRMMenuItem do
  begin
    Checked := not Checked;
    _SetShow([ToolbarStandard, ToolbarEdit, ToolbarBorder, FInspForm, FFieldForm,
      ToolbarGrid, ToolbarCellEdit], Tag, Checked);
    if FFieldForm.Visible then
      FFieldForm.RefreshData;
  end;
end;

procedure TRMGridReportDesignerForm.MenuEditAddFormClick(Sender: TObject);
begin
  if DesignerRestrictions * [rmdrDontCreatePage] <> [] then
    Exit;

  Page := Report.Pages.AddDialogPage;
  Page.CreateName;
  Modified := True;
  CurPage := Report.Pages.Count - 1;
end;

procedure TRMGridReportDesignerForm.MenuEditCutClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanCut then
    begin
      FCodeMemo.RMClipBoardCut;
      ShowPosition;
    end;
  end
  else if Page is TRMGridReportPage then
  begin
	  AddUndoAction(acChangeCellCount);
  	FGrid.CutCells(FGrid.Selection);
  end
  else if Page is TRMDialogPage then
  begin
    FWorkSpace.CopyToClipboard;
    FWorkSpace.DeleteObjects(True);
    FirstSelected := nil;
    EnableControls;
    ShowPosition;
    RedrawPage;
  end;
end;

procedure TRMGridReportDesignerForm.MenuEditCopyClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanCopy then
    begin
      FCodeMemo.RMClipBoardCopy;
      ShowPosition;
    end;
  end
	else if Page is TRMGridReportPage then
  begin
  	FGrid.CopyCells(FGrid.Selection);
  end
  else if Page is TRMDialogPage then
  begin
    FWorkSpace.CopyToClipboard;
    EnableControls;
  end;
end;

procedure TRMGridReportDesignerForm.MenuEditPasteClick(Sender: TObject);
var
	lStartCell: TPoint;
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanPaste then
    begin
      FCodeMemo.RMClipBoardPaste;
      ShowPosition;
    end;
  end
  else if Page is TRMGridReportPage then
  begin
	  AddUndoAction(acChangeCellCount);
  	lStartCell.X := FGrid.Selection.Left;
    lStartCell.Y := FGrid.Selection.Top;
  	FGrid.PasteCells(lStartCell);
    OnGridClick(nil);
  end
  else if Page is TRMDialogPage then
  begin
    FWorkSpace.PasteFromClipboard;
  end;
end;

procedure TRMGridReportDesignerForm.MenuEditDeleteClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanCut then
    begin
      FCodeMemo.RMDeleteSelected;
      ShowPosition;
    end;
  end
  else if Page is TRMDialogPage then
  begin
    FWorkSpace.DeleteObjects(True);
  end;
end;

procedure TRMGridReportDesignerForm.MenuEditSelectAllClick(
  Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    FCodeMemo.SelectAll;
    //FCodeMemo.Command(ecSelAll);
    ShowPosition;
  end
  else if Page is TRMDialogPage then
  begin
    FWorkSpace.DrawPage(dmSelection);
    FWorkSpace.SelectAll;
    FWorkSpace.GetMultipleSelected;
    FWorkSpace.DrawPage(dmSelection);
    SelectionChanged(True);
  end;
end;

procedure TRMGridReportDesignerForm.padpopEditClick(Sender: TObject);
begin
  ShowEditor;
end;

procedure TRMGridReportDesignerForm.padpopClearContentsClick(Sender: TObject);
var
  i: Integer;
  lList: TList;
  t: TRMView;
begin
  BeforeChange;
  lList := PageObjects;
  for i := 0 to lList.Count - 1 do
  begin
    t := lList[i];
    if t.Selected and (not t.IsBand) then
      THackView(t).ClearContents;
  end;
  AfterChange;
end;

const
  DefaultPopupItemsCount = 7;

procedure TRMGridReportDesignerForm.Popup1Popup(Sender: TObject);
var
  i: Integer;
  t, t1: TRMView;
  fl: Boolean;

  procedure _AddOtherMenuItem;
  var
    lMenuItem: TRMMenuItem;
  begin
    Popup1.Items.Add(RMNewLine());

    lMenuItem := TRMMenuItem.Create(Self);
    lMenuItem.Caption := RMLoadStr(rmRes + 211);
    lMenuItem.RadioItem := TRUE;
    lMenuItem.Checked := FInspForm.Visible;
    lMenuItem.OnClick := Pan5Click;
    Popup1.Items.Add(lMenuItem);
  end;

begin
  EnableControls;
  while Popup1.Items.Count > DefaultPopupItemsCount do
    Popup1.Items.Delete(DefaultPopupItemsCount);

  if SelNum = 1 then
  begin
    TRMView(PageObjects[TopSelected]).DefinePopupMenu(TRMCustomMenuItem(Popup1.Items));
  end
  else if SelNum > 1 then
  begin
    t := PageObjects[TopSelected];
    fl := True;
    for i := 0 to PageObjects.Count - 1 do
    begin
      t1 := PageObjects[i];
      if t1.Selected and (t.ClassName <> t1.ClassName) then
      begin
        fl := False;
        Break;
      end;
    end;

    if fl then
      t.DefinePopupMenu(TRMCustomMenuItem(Popup1.Items));
  end;

  _AddOtherMenuItem;
end;

procedure TRMGridReportDesignerForm.MenuCellPropertyClick(Sender: TObject);
var
  tmp: TRMCellPropForm;
begin
  tmp := TRMCellPropForm.Create(nil);
  try
    tmp.ParentGrid := FGrid;
    if tmp.ShowModal = mrOK then
    begin
      BeforeChange;
      AfterChange;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.MenuCellTableSizeClick(Sender: TObject);
var
  tmp: TRMGetGridColumnsForm;
begin
  tmp := TRMGetGridColumnsForm.Create(nil);
  try
    tmp.RowCountButton.Value := FGrid.RowCount;
    tmp.ColCountButton.Value := FGrid.ColCount;
    if tmp.ShowModal = mrOK then
    begin
      AddUndoAction(acChangeCellCount);
      Modified := True;
      Screen.Cursor := crHourGlass;
      FGrid.ColCount := tmp.ColCountButton.AsInteger;
      FGrid.RowCount := tmp.RowCountButton.AsInteger;
      AddUndoAction(acChangeCellCount);
    end;
  finally
    tmp.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TRMGridReportDesignerForm.itmAverageRowHeightClick(Sender: TObject);
var
  i, lTotalHeight, lCount: Integer;
begin
  lTotalHeight := 0;
  lCount := 0;
  for i := FGrid.Selection.Top to FGrid.Selection.Bottom do
  begin
    lTotalHeight := lTotalHeight + FGrid.RowHeights[i];
    Inc(lCount);
  end;

  if lCount <= 1 then Exit;

  AddUndoAction(acChangeCellSize);
  for i := FGrid.Selection.Top to FGrid.Selection.Bottom do
  begin
    FGrid.RowHeights[i] := lTotalHeight div lCount;
  end;
end;

procedure TRMGridReportDesignerForm.itmAverageColumnWidthClick(Sender: TObject);
var
  i, lTotalWidth, lCount: Integer;
begin
  lTotalWidth := 0;
  lCount := 0;
  for i := FGrid.Selection.Left to FGrid.Selection.Right do
  begin
    lTotalWidth := lTotalWidth + FGrid.ColWidths[i];
    Inc(lCount);
  end;

  if lCount <= 1 then Exit;

  AddUndoAction(acChangeCellSize);
  for i := FGrid.Selection.Left to FGrid.Selection.Right do
  begin
    FGrid.ColWidths[i] := lTotalWidth div lCount;
  end;

  Modified := True;
end;

procedure TRMGridReportDesignerForm.itmRowHeightClick(Sender: TObject);
var
  tmp: TRMEditCellWidthForm;
  i: Integer;
  lRowHeight: Integer;
begin
  tmp := TRMEditCellWidthForm.Create(nil);
  try
    RMSetStrProp(tmp.Label2, 'Caption', rmRes + 695);
    RMSetStrProp(tmp, 'Caption', rmRes + 695);
    tmp.btnCount.ValueType := rmvtFloat;
    tmp.btnCount.MinValue := 0;
    tmp.UnitType := UnitType;
    tmp.btnCount.Value := RMFromScreenPixels(FGrid.RowHeights[FGrid.Row], UnitType);
    tmp.RB6Click(nil);
    if tmp.ShowModal = mrOK then
    begin
      UnitType := tmp.UnitType;
      lRowHeight := RMToScreenPixels(tmp.btnCount.Value, UnitType);
      AddUndoAction(acChangeCellSize);
      Modified := True;
      for i := FGrid.Selection.Top to FGrid.Selection.Bottom do
        FGrid.RowHeights[i] := lRowHeight;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.itmColumnHeightClick(Sender: TObject);
var
  tmp: TRMEditCellWidthForm;
  i: Integer;
  lColumnWidth: Integer;
begin
  tmp := TRMEditCellWidthForm.Create(nil);
  try
    RMSetStrProp(tmp.Label2, 'Caption', rmRes + 696);
    RMSetStrProp(tmp, 'Caption', rmRes + 696);

    tmp.btnCount.ValueType := rmvtFloat;
    tmp.btnCount.MinValue := 0;
    tmp.UnitType := UnitType;
    tmp.btnCount.Value := RMFromScreenPixels(FGrid.ColWidths[FGrid.Col], UnitType);
    tmp.RB6Click(nil);
    if tmp.ShowModal = mrOK then
    begin
      UnitType := tmp.UnitType;
      lColumnWidth := RMToScreenPixels(tmp.btnCount.Value, UnitType);
      AddUndoAction(acChangeCellSize);
      Modified := True;
      for i := FGrid.Selection.Left to FGrid.Selection.Right do
        FGrid.ColWidths[i] := lColumnWidth;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.MenuEditUndoClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanUndo then
    begin
      FCodeMemo.RMUndo;
      ShowPosition;
    end;
  end
  else
  begin
    Undo(@FUndoBuffer);
    RefreshProp;
    AfterChange;
  end;
end;

procedure TRMGridReportDesignerForm.MenuEditRedoClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
  end
  else
  begin
    Undo(@FRedoBuffer);
    RefreshProp;
    AfterChange;
  end;
end;

procedure TRMGridReportDesignerForm.MenuFileFile9Click(Sender: TObject);
begin
  if FileExists(FOpenFiles[TComponent(Sender).Tag - 1]) then
    OpenFile(FOpenFiles[TComponent(Sender).Tag - 1]);
end;

procedure TRMGridReportDesignerForm.DoFormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = vk_F11) and (Shift = []) then
  begin
    //itmToolbarStandardClick(itmToolbarInspector);
    Pan5Click(itmToolbarInspector);
  end
  else if (Key = vk_Escape) and (Page is TRMDialogPage) and (not FWorkSpace.MouseButtonDown) then
  begin
    ToolbarComponent.btnNoSelect.Down := True;
    FWorkSpace.Perform(CM_MOUSELEAVE, 0, 0);
    FWorkSpace.OnMouseMoveEvent(nil, [], 0, 0);
    UnselectAll;
    FWorkSpace.RedrawPage;
    SelectionChanged(True);
  end
  else if Key = vk_F9 then
    ToolbarStandard.btnPreview.Click
  else if (Key = vk_Return) and (ActiveControl = ToolbarEdit.FcmbFontSize) then
  begin
    Key := 0;
    DoClick(ToolbarEdit.FcmbFontSize);
  end
  else if (Key = vk_Delete) and _DelEnabled then
  begin
    if Page is TRMDialogPage then
    begin
      Key := 0;
      MenuEditDelete.Click;
    end;
  end;

  if _CutEnabled then
  begin
    if (Key = vk_Delete) and (ssShift in Shift) then
      ToolbarStandard.btnCut.Click;
  end;
  if _CopyEnabled then
  begin
    if (Key = vk_Insert) and (ssCtrl in Shift) then
      ToolbarStandard.btnCopy.Click;
  end;
  if _PasteEnabled then
  begin
    if (Key = vk_Insert) and (ssShift in Shift) then
      ToolbarStandard.btnPaste.Click;
  end;
end;

procedure TRMGridReportDesignerForm.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DoFormKeyDown(Sender, Key, Shift);
end;

procedure TRMGridReportDesignerForm.MenuEditCopyPageClick(Sender: TObject);
var
  i: Integer;
  t: TRMView;
begin
  FPageStream.Clear;
  RMWriteInt32(FPageStream, Page.Objects.Count);
  for i := 0 to Page.Objects.Count - 1 do
  begin
    t := Page.Objects[i];
    RMWriteByte(FPageStream, t.ObjectType);
    RMWriteString(FPageStream, t.ClassName);
    THackView(t).StreamMode := rmsmDesigning;
    t.SaveToStream(FPageStream);
  end;
  THackPage(Page).SaveToStream(FPageStream);
end;

procedure TRMGridReportDesignerForm.MenuEditPastePageClick(Sender: TObject);
var
  i, lCount: Integer;
  b: Byte;
  t: TRMView;
  lOldName: string;
begin
  lOldName := Page.Name;
  if FPageStream.Size > 0 then
  begin
    AddUndoAction(acChangeCellCount);
    Page.Clear;
    FPageStream.Position := 0;
    lCount := RMReadInt32(FPageStream);
    for i := 0 to lCount - 1 do
    begin
      b := RMReadByte(FPageStream);
      t := RMCreateObject(b, RMReadString(FPageStream));
      t.NeedCreateName := False;
      THackView(t).StreamMode := rmsmDesigning;
      t.LoadFromStream(FPageStream);
      if t is TRMSubReportView then
      begin
        t.Free;
      end
      else
      begin
        t.ParentPage := Page;
      end;
    end;

    THackPage(Page).LoadFromStream(FPageStream);
    Page.Name := lOldName;
    THackPage(Page).Loaded;

    Modified := False;
    cmbBandsDropDown(nil);
    OnGridClick(nil);
    SetObjectsID;
    SetGridHeader;
  end;
end;

procedure TRMGridReportDesignerForm.MenuEditOptionsClick(Sender: TObject);
var
  liSaveShowBandTitles: Boolean;
  lOldPage: Integer;
  tmp: TRMDesOptionsForm;
begin
  liSaveShowBandTitles := RMShowBandTitles;
  lOldPage := FCurPage;
  tmp := TRMDesOptionsForm.Create(nil);
  try
    tmp.CB1.Checked := True;
    tmp.CB2.Checked := True;
    tmp.RB1.Checked := True;
    case FUnitType of
      rmutScreenPixels: tmp.RB6.Checked := True;
      rmutInches: tmp.RB7.Checked := True;
      rmutMillimeters: tmp.RB8.Checked := True;
      rmutMMThousandths: tmp.RB9.Checked := True;
    end;
    tmp.CB5.Checked := RM_Class.RMShowBandTitles;
    tmp.CB7.Checked := RM_Class.RMLocalizedPropertyNames;
    tmp.chkAutoOpenLastFile.Checked := AutoOpenLastFile;
    tmp.WorkSpaceColor := clWhite;
    tmp.InspColor := clWhite;

    if tmp.ShowModal = mrOK then
    begin
      RM_Class.RMLocalizedPropertyNames := tmp.CB7.Checked;
      AutoOpenLastFile := tmp.chkAutoOpenLastFile.Checked;
      if tmp.RB6.Checked then
        FUnitType := rmutScreenPixels
      else if tmp.RB7.Checked then
        FUnitType := rmutInches
      else if tmp.RB8.Checked then
        FUnitType := rmutMillimeters
      else
        FUnitType := rmutMMThousandths;

      if liSaveShowBandTitles <> RMShowBandTitles then
        FCurPage := -1;
      CurPage := lOldPage;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMGridReportDesignerForm.ToolBarPopMenuPopup(Sender: TObject);
begin
  ToolbarPopStandard.Checked := ToolbarStandard.Visible;
  ToolbarPopEdit.Checked := ToolbarEdit.Visible;
  ToolbarPopBorder.Checked := ToolbarBorder.Visible;
  ToolbarPopInsp.Checked := FInspForm.Visible;
  ToolbarPopInsDBField.Checked := FFieldForm.Visible;
  ToolbarPopGrid.Checked := ToolbarGrid.Visible;
end;

procedure TRMGridReportDesignerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnClose) then
    FDesignerComp.OnClose(Self);
end;

procedure TRMGridReportDesignerForm.MenuFileHeaderFooterClick(Sender: TObject);
var
  tmpForm: TRMFormEditorHF;
begin
  tmpForm := TRMFormEditorHF.Create(nil);
  try
    tmpForm.memHeaderLeft.Lines.Assign(TRMGridReportPage(Page).PageHeaderMsg.LeftMemo);
    tmpForm.memHeaderCenter.Lines.Assign(TRMGridReportPage(Page).PageHeaderMsg.CenterMemo);
    tmpForm.memHeaderRight.Lines.Assign(TRMGridReportPage(Page).PageHeaderMsg.RightMemo);
    tmpForm.memHeaderLeft.Font.Assign(TRMGridReportPage(Page).PageHeaderMsg.Font);
    tmpForm.memHeaderCenter.Font.Assign(TRMGridReportPage(Page).PageHeaderMsg.Font);
    tmpForm.memHeaderRight.Font.Assign(TRMGridReportPage(Page).PageHeaderMsg.Font);

    tmpForm.memFooterLeft.Lines.Assign(TRMGridReportPage(Page).PageFooterMsg.LeftMemo);
    tmpForm.memFooterCenter.Lines.Assign(TRMGridReportPage(Page).PageFooterMsg.CenterMemo);
    tmpForm.memFooterRight.Lines.Assign(TRMGridReportPage(Page).PageFooterMsg.RightMemo);
    tmpForm.memFooterLeft.Font.Assign(TRMGridReportPage(Page).PageFooterMsg.Font);
    tmpForm.memFooterCenter.Font.Assign(TRMGridReportPage(Page).PageFooterMsg.Font);
    tmpForm.memFooterRight.Font.Assign(TRMGridReportPage(Page).PageFooterMsg.Font);

    tmpForm.memTitle.Lines.Assign(TRMGridReportPage(Page).PageCaptionMsg.TitleMemo);
    tmpForm.memTitle.Font.Assign(TRMGridReportPage(Page).PageCaptionMsg.TitleFont);

    tmpForm.memCaptionLeft.Lines.Assign(TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.LeftMemo);
    tmpForm.memCaptionCenter.Lines.Assign(TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.CenterMemo);
    tmpForm.memCaptionRight.Lines.Assign(TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.RightMemo);
    tmpForm.memCaptionLeft.Font.Assign(TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.Font);
    tmpForm.memCaptionCenter.Font.Assign(TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.Font);
    tmpForm.memCaptionRight.Font.Assign(TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.Font);

    if tmpForm.ShowModal = mrOK then
    begin
      TRMGridReportPage(Page).PageHeaderMsg.LeftMemo.Assign(tmpForm.memHeaderLeft.Lines);
      TRMGridReportPage(Page).PageHeaderMsg.CenterMemo.Assign(tmpForm.memHeaderCenter.Lines);
      TRMGridReportPage(Page).PageHeaderMsg.RightMemo.Assign(tmpForm.memHeaderRight.Lines);
      TRMGridReportPage(Page).PageHeaderMsg.Font.Assign(tmpForm.memHeaderLeft.Font);

      TRMGridReportPage(Page).PageFooterMsg.LeftMemo.Assign(tmpForm.memFooterLeft.Lines);
      TRMGridReportPage(Page).PageFooterMsg.CenterMemo.Assign(tmpForm.memFooterCenter.Lines);
      TRMGridReportPage(Page).PageFooterMsg.RightMemo.Assign(tmpForm.memFooterRight.Lines);
      TRMGridReportPage(Page).PageFooterMsg.Font.Assign(tmpForm.memFooterLeft.Font);

      TRMGridReportPage(Page).PageCaptionMsg.TitleMemo.Assign(tmpForm.memTitle.Lines);
      TRMGridReportPage(Page).PageCaptionMsg.TitleFont.Assign(tmpForm.memTitle.Font);

      TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.LeftMemo.Assign(tmpForm.memCaptionLeft.Lines);
      TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.CenterMemo.Assign(tmpForm.memCaptionCenter.Lines);
      TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.RightMemo.Assign(tmpForm.memCaptionRight.Lines);
      TRMGridReportPage(Page).PageCaptionMsg.CaptionMsg.Font.Assign(tmpForm.memCaptionLeft.Font);
    end;
  finally
    tmpForm.Free;
  end;
end;

procedure TRMGridReportDesignerForm.padSearchFindClick(Sender: TObject);
begin
  ShowSearchReplaceDialog(False);
end;

procedure TRMGridReportDesignerForm.padSearchReplaceClick(Sender: TObject);
begin
  ShowSearchReplaceDialog(True);
end;

procedure TRMGridReportDesignerForm.padSearchFindAgainClick(Sender: TObject);
begin
  DoSearchReplaceText(False, False);
end;

procedure TRMGridReportDesignerForm.itmInsertLeftCellClick(Sender: TObject);
begin
  FBusy := True;
  AddUndoAction(acChangeCellCount);
  Modified := True;

  FGrid.InsertCellRight(FGrid.Selection);
  FBusy := False;
end;

procedure TRMGridReportDesignerForm.itmInsertTopCellClick(Sender: TObject);
begin
  FBusy := True;
  AddUndoAction(acChangeCellCount);
  Modified := True;

  FGrid.InsertCellDown(FGrid.Selection);
  FBusy := False;
end;

procedure TRMGridReportDesignerForm.itmDeleteLeftCellClick(Sender: TObject);
begin
  FBusy := True;
  AddUndoAction(acChangeCellCount);
  Modified := True;

  FGrid.DeleteCellRight(FGrid.Selection);
  FBusy := False;
end;

procedure TRMGridReportDesignerForm.itmDeleteTopCellClick(Sender: TObject);
begin
  FBusy := True;
  AddUndoAction(acChangeCellCount);
  Modified := True;

  FGrid.DeleteCellDown(FGrid.Selection);
  FBusy := False;
end;

initialization
  FDesignerComp := nil;
  RMGridReportDesignerClass := TRMGridReportDesignerForm;
  FUnitType := rmutScreenPixels;

finalization

end.

