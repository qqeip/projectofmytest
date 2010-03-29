unit RM_Designer;

interface

{$I RM.INC}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Printers, Menus, ComCtrls, ExtCtrls, Clipbrd, Commctrl,
  RM_Class, RM_Preview, RM_Common, RM_DsgCtrls, RM_Ctrls, RM_Insp, RM_PropInsp,
  RM_EditorInsField, RM_DsgForm
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
  TSelectionType = (ssBand, ssMemo, ssOther, ssMultiple);
  TSelectionStatus = set of TSelectionType;
  TRMMouseMode = (mmNone, mmSelect, mmRegionDrag, mmRegionResize,
    mmSelectedResize, mmInsertObj);

  TRMUndoObject = record
    ObjID: Integer;
  end;
  TRMUndoRec = record
    Action: TRMUndoAction;
    Page: Integer;
    Stream: TMemoryStream;
    Objects: array of TRMUndoObject;
  end;
  PRMUndoRec = ^TRMUndoRec;

  TRMUndoBuffer = array[0..MaxUndoBuffer - 1] of TRMUndoRec;
  PRMUndoBuffer = ^TRMUndoBuffer;

  TRMDesignerForm = class;

  { TRMDesigner }
  TRMDesigner = class(TRMCustomDesigner) // fake component
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

  { TRMToolbarAlign }
  TRMToolbarAlign = class(TRMToolbar)
  private
    FDesignerForm: TRMDesignerForm;
    btnAlignLeftRight: TRMToolbarButton;
    btnAlignTopBottom: TRMToolbarButton;
    btnAlignVWCenter: TRMToolbarButton;
    btnAlignLeft: TRMToolbarButton;
    btnAlignHWCenter: TRMToolbarButton;
    btnAlignHCenter: TRMToolbarButton;
    btnAlignVSE: TRMToolbarButton;
    btnAlignHSE: TRMToolbarButton;
    btnAlignRight: TRMToolbarButton;
    btnAlignBottom: TRMToolbarButton;
    btnAlignTop: TRMToolbarButton;
    btnAlignVCenter: TRMToolbarButton;
    ToolbarSep9720: TRMToolbarSep;
    ToolbarSep9721: TRMToolbarSep;
    ToolbarSep9710: TRMToolbarSep;

    procedure Localize;
    function GetLeftObject: Integer;
    function GetTopObject: Integer;
    function GetRightObject: Integer;
    function GetBottomObject: Integer;

    procedure btnAlignLeftClick(Sender: TObject);
    procedure btnAlignHCenterClick(Sender: TObject);
    procedure btnAlignRightClick(Sender: TObject);
    procedure btnAlignTopClick(Sender: TObject);
    procedure btnAlignBottomClick(Sender: TObject);
    procedure btnAlignHSEClick(Sender: TObject);
    procedure btnAlignVSEClick(Sender: TObject);
    procedure btnAlignHWCenterClick(Sender: TObject);
    procedure btnAlignVWCenterClick(Sender: TObject);
    procedure btnAlignVCenterClick(Sender: TObject);
    procedure btnAlignLeftRightClick(Sender: TObject);
    procedure btnAlignTopBottomClick(Sender: TObject);
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMToolbarSize }
  TRMToolbarSize = class(TRMToolbar)
  private
    FDesignerForm: TRMDesignerForm;
    btnSetWidthToMin: TRMToolbarButton;
    btnSetWidthToMax: TRMToolbarButton;
    btnSetHeightToMin: TRMToolbarButton;
    btnSetHeightToMax: TRMToolbarButton;
    ToolbarSep979: TRMToolbarSep;

    procedure Localize;
    procedure btnSetWidthToMinClick(Sender: TObject);
    procedure btnSetWidthToMaxClick(Sender: TObject);
    procedure btnSetHeightToMinClick(Sender: TObject);
    procedure btnSetHeightToMaxClick(Sender: TObject);
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMToolbarBorder }
  TRMToolbarBorder = class(TRMToolbar)
  private
    FDesignerForm: TRMDesignerForm;
    btnFrameTop: TRMToolbarButton;
    btnFrameLeft: TRMToolbarButton;
    btnFrameBottom: TRMToolbarButton;
    btnFrameRight: TRMToolbarButton;
    btnNoFrame: TRMToolbarButton;
    btnSetFrame: TRMToolbarButton;
    ToolbarSep9717: TRMToolbarSep;
    ToolbarSep9722: TRMToolbarSep;
    FBtnBackColor: TRMColorPickerButton;
    FBtnFrameColor: TRMColorPickerButton;
    ToolbarSep9719: TRMToolbarSep;
    btnSetFrameStyle: TRMFrameStyleButton {TRMToolbarButton};
    FCmbFrameWidth: TRMComboBox97;

    procedure Localize;
    procedure SetStatus;
    procedure btnSetFrameStyle_OnChange(Sender: TObject);
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMToolbarModifyPrepared }
  TRMToolbarModifyPrepared = class(TRMToolbar)
  private
    FDesignerForm: TRMDesignerForm;
    btnModifyPreviedFirst: TRMToolbarButton;
    btnModifyPreviedPrev: TRMToolbarButton;
    btnModifyPreviedNext: TRMToolbarButton;
    btnModifyPreviedLast: TRMToolbarButton;
    btnAutoSave: TRMToolbarButton;
    Edit1: TRMEdit;

    procedure Localize;
    procedure _EditPreparedReport(aNewPageNo: Integer);
    procedure btnModifyPreviedFirstClick(Sender: TObject);
    procedure btnModifyPreviedPrevClick(Sender: TObject);
    procedure btnModifyPreviedLastClick(Sender: TObject);
    procedure btnModifyPreviedNextClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure btnAutoSaveClick(Sender: TObject);
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMToolbarStandard }
  TRMToolbarStandard = class(TRMToolbar)
  private
    FDesignerForm: TRMDesignerForm;
    BtnFileNew: TRMToolbarButton;
    btnFileSave: TRMToolbarButton;
    {$IFDEF USE_TB2K}
    btnFileOpen: TTBSubmenuItem;
    {$ELSE}
    btnFileOpen: TRMToolbarButton;
    {$ENDIF}
    btnPreview: TRMToolbarButton;
    btnPrint: TRMToolbarButton;
    btnCut: TRMToolbarButton;
    btnCopy: TRMToolbarButton;
    btnPaste: TRMToolbarButton;
    ToolbarSep972: TRMToolbarSep;
    btnRedo: TRMToolbarButton;
    btnUndo: TRMToolbarButton;
    btnAddForm: TRMToolbarButton;
    ToolbarSep973: TRMToolbarSep;
    ToolbarSep9723: TRMToolbarSep;
    btnSendtoBack: TRMToolbarButton;
    btnSelectAll: TRMToolbarButton;
    btnBringtoFront: TRMToolbarButton;
    ToolbarSep974: TRMToolbarSep;
    btnDeletePage: TRMToolbarButton;
    btnPageSetup: TRMToolbarButton;
    btnAddPage: TRMToolbarButton;
    ToolbarSep975: TRMToolbarSep;
    GB2: TRMToolbarButton;
    GB3: TRMToolbarButton;
    GB1: TRMToolbarButton;
    ToolbarSep976: TRMToolbarSep;
    btnExit: TRMToolbarButton;
    ToolbarSep971: TRMToolbarSep;
    ToolbarSepScale: TRMToolbarSep;
    cmbScale: TRMComboBox97 {TComboBox};
    btnExpression: TRMToolbarButton;
    ToolbarSep1: TRMToolbarSep;

    procedure Localize;
    procedure OnCmbScaleChangeEvent(Sender: TObject);
  public
    constructor CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
  end;

  { TRMDesignerForm }
  TRMDesignerForm = class(TRMCustomDesignerForm)
    StatusBar1: TStatusBar;
    Panel7: TPanel;
    PBox1: TPaintBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Popup2: TPopupMenu;
    padpopAddPage: TMenuItem;
    padpopAddForm: TMenuItem;
    padpopDeletePage: TMenuItem;
    N9: TMenuItem;
    padpopPageSetup: TMenuItem;
    ImageListStand: TImageList;
    ImageListFont: TImageList;
    ImageListFrame: TImageList;
    ImageListAlign: TImageList;
    ImageListSize: TImageList;
    ImageListPosition: TImageList;
    ImageListModifyPreview: TImageList;
    ImageListAddinTools: TImageList;
    PopupMenu1: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure DoClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure btnFileNewClick(Sender: TObject);
    procedure padFileSaveAsClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnCutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure padDeleteClick(Sender: TObject);
    procedure btnExpressionClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure padEditClick(Sender: TObject);
    procedure btnAddPageClick(Sender: TObject);
    procedure btnDeletePageClick(Sender: TObject);
    procedure Pan2Click(Sender: TObject);
    procedure PBox1Paint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Tab1Change(Sender: TObject);
    procedure btnPageSetupClick(Sender: TObject);
    procedure btnFileSaveClick(Sender: TObject);
    procedure padPrintClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure Popup1Popup(Sender: TObject);
    procedure Pan5Click(Sender: TObject);
    procedure padpopEditClick(Sender: TObject);
    procedure padpopClearContentsClick(Sender: TObject);
    procedure padpopFrameClick(Sender: TObject);
    procedure barFileClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure padEditReplaceClick(Sender: TObject);
    procedure itmEditLockControlsClick(Sender: TObject);
    procedure btnBringtoFrontClick(Sender: TObject);
    procedure btnSendtoBackClick(Sender: TObject);
    procedure padOptionsClick(Sender: TObject);
    procedure padAboutClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure padFilePropertyClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure padFileNewClick(Sender: TObject);
    procedure Tab1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Tab1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Tab1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Tab1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Tab1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure padSetToolbarClick(Sender: TObject);
    procedure btnAddFormClick(Sender: TObject);
    procedure padVarListClick(Sender: TObject);
    procedure LoadDictionary1Click(Sender: TObject);
    procedure MergeDictionary1Click(Sender: TObject);
    procedure SaveAsDictionary1Click(Sender: TObject);
    procedure itmFileFile9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FInspBusy: Boolean;
    FInspForm: TRMInspForm;
    FMouseDown: Boolean;
    FFindReplaceForm: TForm;
    FUndoBuffer, FRedoBuffer: TRMUndoBuffer;
    FUndoBufferLength, FRedoBufferLength: Integer;
    FSaveDesignerRestrictions: TRMDesignerRestrictions;

    ScrollBox1: TScrollBox;
    Dock971: TRMDock;
    Dock972: TRMDock;
    Dock973: TRMDock;
    Dock974: TRMDock;

    //Tab begin;dejoy add
    Panel2: TRMPanel;
    pnlHorizontalRuler: TRMPanel;
    pnlVerticalRuler: TRMPanel;
    pnlWorkSpace: TRMPanel;

    //Tab end;dejoy add

    //MenuBar begin;dejoy add
    MenuBar: TRMMenuBar;
    barFile: TRMSubmenuItem;
    padFileNew: TRMmenuItem;
    padFileOpen: TRMmenuItem;
    padFileSave: TRMmenuItem;
    padFileSaveAs: TRMmenuItem;
    N40: TRMSeparatorMenuItem;
    padVarList: TRMmenuItem;
    LoadDictionary1: TRMmenuItem;
    MergeDictionary1: TRMmenuItem;
    SaveAsDictionary1: TRMmenuItem;
    N21: TRMSeparatorMenuItem;
    padPageSetup: TRMmenuItem;
    padPreview: TRMmenuItem;
    padPrint: TRMmenuItem;
    N24: TRMSeparatorMenuItem;
    padFileProperty: TRMmenuItem;
    N2: TRMSeparatorMenuItem;
    itmFileFile1: TRMmenuItem;
    itmFileFile2: TRMmenuItem;
    itmFileFile3: TRMmenuItem;
    itmFileFile4: TRMmenuItem;
    itmFileFile5: TRMmenuItem;
    itmFileFile6: TRMmenuItem;
    itmFileFile7: TRMmenuItem;
    itmFileFile8: TRMmenuItem;
    itmFileFile9: TRMmenuItem;
    N1: TRMSeparatorMenuItem;
    padExit: TRMmenuItem;

    barEdit: TRMSubmenuItem;
    padUndo: TRMmenuItem;
    padRedo: TRMmenuItem;
    N47: TRMSeparatorMenuItem;
    padCut: TRMmenuItem;
    padCopy: TRMmenuItem;
    padPaste: TRMmenuItem;
    padDelete: TRMmenuItem;
    padSelectAll: TRMmenuItem;
    padEdit: TRMmenuItem;
    N3: TRMSeparatorMenuItem;
    padEditReplace: TRMmenuItem;
    N26: TRMSeparatorMenuItem;
    padNewPage: TRMmenuItem;
    padNewForm: TRMmenuItem;
    padDeletePage: TRMmenuItem;
    N31: TRMSeparatorMenuItem;
    padBringtoFront: TRMmenuItem;
    padSendtoBack: TRMmenuItem;
    N4: TRMSeparatorMenuItem;
    itmEditLockControls: TRMmenuItem;

    barSearch: TRMSubmenuItem;
    padSearchFind: TRMMenuItem;
    padSearchReplace: TRMMenuItem;
    padSearchFindAgain: TRMMenuItem;

    barTools: TRMSubmenuItem;
    padSetToolbar: TRMSubmenuItem;
    Pan1: TRMmenuItem;
    Pan2: TRMmenuItem;
    Pan3: TRMmenuItem;
    Pan5: TRMmenuItem;
    Pan4: TRMmenuItem;
    Pan6: TRMmenuItem;
    Pan8: TRMmenuItem;
    Pan7: TRMmenuItem;
    Pan9: TRMmenuItem;
    padAddTools: TRMmenuItem;
    padOptions: TRMmenuItem;

    barHelp: TRMSubmenuItem;
    padHelp: TRMmenuItem;
    N18: TRMSeparatorMenuItem;
    padAbout: TRMmenuItem;
    //MenuBar End

   //Pop Menu begin
    Popup1: TRMPopupMenu;
    padpopCut: TRMMenuItem;
    padpopCopy: TRMMenuItem;
    padpopPaste: TRMMenuItem;
    padpopDelete: TRMMenuItem;
    padpopSelectAll: TRMMenuItem;
    N8: TRMSeparatorMenuItem;
    padpopFrame: TRMMenuItem;
    padpopEdit: TRMMenuItem;
    padpopClearContents: TRMMenuItem;

    //Pop Menu begin

    ToolbarStandard: TRMToolbarStandard;
    ToolbarAlign: TRMToolbarAlign;
    ToolbarBorder: TRMToolbarBorder;
    ToolbarSize: TRMToolbarSize;
    ToolbarModifyPrepared: TRMToolbarModifyPrepared;

    ToolbarEdit: TRMToolbar;
    ToolBarAddinTools: TRMToolbar;

    ToolbarPopMenu: TRMPopupMenu;

    ToolbarPopStandard: TRMMenuItem;
    ToolbarPopComponent: TRMMenuItem;
    ToolbarPopAlign: TRMMenuItem;
    ToolbarPopBorder: TRMMenuItem;
    ToolbarPopSize: TRMMenuItem;
    ToolbarPopModifyPrepared: TRMMenuItem;

    ToolbarPopEdit: TRMMenuItem;
    ToolbarPopAddinTools: TRMMenuItem;
    ToolBarPopInsp: TRMMenuItem;
    ToolBarPopInsDBField: TRMMenuItem;

    btnFontUnderline: TRMToolbarButton;
    ToolbarSep9711: TRMToolbarSep;
    btnTextAlignCenter: TRMToolbarButton;
    btnFontBold: TRMToolbarButton;
    btnFontItalic: TRMToolbarButton;
    btnTextAlignVCenter: TRMToolbarButton;
    btnTextAlignLeft: TRMToolbarButton;
    HlB1: TRMToolbarButton;
    btnTextAlignTop: TRMToolbarButton;
    btnTextAlignRight: TRMToolbarButton;
    btnTextAlignH: TRMToolbarButton;
    btnTextAlignBottom: TRMToolbarButton;
    ToolbarSep9713: TRMToolbarSep;
    ToolbarSep9714: TRMToolbarSep;
    ToolbarSep9715: TRMToolbarSep;
    ToolbarSep9716: TRMToolbarSep;
    ToolbarSep9718: TRMToolbarSep;
    btnInsertFields: TRMToolbarButton;

    FOpenFiles: TStringList;
    FHRuler, FVRuler: TRMDesignerRuler;
    FcmbFont: TRMFontComboBox;
    FcmbFontSize: TRMComboBox97 {TComboBox};
    FBtnFontColor: TRMColorPickerButton;

    FCurDocName, FCaption: string;
    FOldFactor: Integer;
    FUndoBusy: Boolean;

    procedure padSearchFindClick(Sender: TObject);
    procedure padSearchReplaceClick(Sender: TObject);
    procedure padSearchFindAgainClick(Sender: TObject);

    procedure ToolBarPopMenuPopup(Sender: TObject);

    procedure InsertFieldsClick(Sender: TObject);
    procedure OnFieldsDialogCloseEvnet(Sender: TObject);
    procedure ShowFieldsDialog(aVisible: Boolean);

    procedure Localize;
    function GetFirstSelected: TRMView;
    procedure SetObjectsID;
    procedure SaveIni;
    procedure LoadIni;
    function GetSelectionStatus: TSelectionStatus;
    function FileSave: Boolean;
    function FileSaveAs: Boolean;
    procedure CreateDefaultPage;
    procedure OnFindReplaceView(Sender: TObject);

    procedure SetCurDocName(Value: string);
    procedure OnpadAutoArrangeClick(Sender: TObject);
    procedure OnInspBeforeModify(Sender: TObject; const aPropName: string);
    procedure OnInspAfterModify(Sender: TObject; const aPropName, aPropValue: string);
    procedure InspSelectionChanged(ObjName: string);
    procedure InspGetObjects(List: TStrings);
    procedure FillInspFields;
    procedure SelectObject(ObjName: string);

    procedure ClearUndoBuffer;
    procedure ClearRedoBuffer;
    procedure ReleaseAction(aActionRec: PRMUndoRec);
    procedure AddAction(aBuffer: PRMUndoBuffer; aAction: TRMUndoAction; aList: TList);
    procedure Undo(aBuffer: PRMUndoBuffer);

    procedure GB1Click(Sender: TObject);
    procedure GB2Click(Sender: TObject);
    procedure GB3Click(Sender: TObject);
    procedure HlB1Click(Sender: TObject);
    function GetScript: TStrings;
    procedure SetScript(Value: TStrings);

    procedure SetOpenFileMenuItems(const aNewFile: string);

    procedure OnDockRequestDockEvent(Sender: TObject; Bar: TRMCustomDockableWindow; var Accept: Boolean);
    procedure ScrollBox1Resize(Sender: TObject);
    {$IFDEF Delphi4}
    procedure OnFormMouseWheelUpEvent(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure OnFormMouseWheelDownEvent(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    {$ENDIF}

    procedure OpenFile(aFileName: string);
    function RectTypEnabled: Boolean;
    function FontTypEnabled: Boolean;
    function ZEnabled: Boolean;
    function CutEnabled: Boolean;
    function CopyEnabled: Boolean;
    function PasteEnabled: Boolean;
    function DelEnabled: Boolean;
    function EditEnabled: Boolean;
    function RedoEnabled: Boolean;
    function UndoEnabled: Boolean;
    procedure MoveObjects(dx, dy: Integer; Resize: Boolean);
  protected
    procedure SelectAll;
    procedure EnableControls; override;
    procedure ShowPosition; override;
    procedure DoFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;

    function GetModified: Boolean; override;
    procedure SetModified(Value: Boolean); override;
    procedure SetFactor(Value: Integer); override;
    function GetDesignerRestrictions: TRMDesignerRestrictions; override;
    procedure SetDesignerRestrictions(Value: TRMDesignerRestrictions); override;
  public
    { Public declarations }
    function Objects: TList;
    procedure BeforeChange; override;
    procedure AfterChange; override;
    function InsertDBField: string; override;
    function InsertExpression: string; override;
    procedure MemoViewEditor(t: TRMView); override;
    procedure PictureViewEditor(t: TRMView); override;
    procedure RMFontEditor(Sender: TObject); override;
    procedure RMDisplayFormatEditor(Sender: TObject); override;
    procedure RMCalcMemoEditor(Sender: TObject); override;

    procedure SetPageTabs; override;
    procedure UnselectAll; override;
    procedure SelectionChanged(aRefreshInspProp: Boolean); override;
    procedure SetCurPage(Value: Integer); override;
    procedure ResetSelection; override;
    procedure ShowContent; override;
    procedure SetRulerOffset; override;
    procedure AddUndoAction(aAction: TRMUndoAction); override;
    procedure ShowObjMsg; override;
    procedure ShowEditor; override;

    procedure ShowMemoEditor(Sender: TObject);

    property CurDocName: string read FCurDocName write SetCurDocName;
    property SelStatus: TSelectionStatus read GetSelectionStatus;
    property Script: TStrings read GetScript write SetScript;
  end;

implementation

{$R *.DFM}

uses
  Registry, RM_Const, RM_Const1, RM_Utils, RM_EditorMemo, RM_EditorBand, RM_EditorGroup,
  RM_EditorCrossBand, RM_EditorPicture, RM_EditorHilit, RM_EditorFrame, RM_EditorField,
  RM_EditorExpr, RM_PageSetup, RM_EditorReportProp, RM_DesignerOptions, RM_Printer, RM_About,
  RM_EditorFormat, RM_EditorDictionary, RM_EditorFindReplace, RM_EditorTemplate,
  RM_EditorCalc, RM_EditorBandType,
  RM_Wizard, RM_WizardNewReport;

type
  THackView = class(TRMView)
  end;

  THackPage = class(TRMCustomPage)
  end;

  THackReportPage = class(TRMReportPage)
  end;

  THackReport = class(TRMReport)
  end;

const
  crPencil = 11;
  DefaultPopupItemsCount = 9;

  TAG_SetFrameTop = 1;
  TAG_SetFrameLeft = 2;
  TAG_SetFrameBottom = 3;
  TAG_SetFrameRight = 4;
  TAG_BackColor = 5;
  //  TAG_FrameStyle = 6;

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

  TAG_FrameStyle1 = 25;
  TAG_FrameStyle2 = 26;
  TAG_FrameStyle3 = 27;
  TAG_FrameStyle4 = 28;
  TAG_FrameStyle5 = 29;
  TAG_FrameStyle6 = 30;

  TAG_VAlignTop = 31;
  TAG_VAlignCenter = 32;
  TAG_VAlignBottom = 33;

var
  FDesignerComp: TRMDesigner;
  FEditAfterInsert: Boolean;

type
  TRMScrollBox = class(TScrollBox)
  private
    FOnkeyDown: TKeyEvent;
    procedure CNKeydown(var Message: TMessage); message CN_KEYDOWN;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnkeyDown: TKeyEvent read FOnkeyDown write FOnkeyDown;
  end;

constructor TRMScrollBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TabStop := True; //使之能获得焦点
end;

procedure TRMScrollBox.CNKeydown(var Message: TMessage);
begin
  case TWMKey(Message).CharCode of
    VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT, VK_TAB:
      begin
        Exit; //如果让他自己处理的话就会失去焦点，必须中断才能把消息传到WM_KeyDown
      end;
  else
    inherited;
  end;
end;

procedure TRMScrollBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnkeyDown) then
  begin
    FOnkeyDown(Self, key, Shift);
  end;
  inherited;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMDesigner}

constructor TRMDesigner.Create(AOwner: TComponent);
begin
  //  if Assigned(FDesignerComp) then
  //    raise Exception.Create('You already have one TRMDesigner component');
  inherited Create(AOwner);

  FDesignerComp := Self;
  FOpenFileCount := 4;
  FDefaultDictionaryFile := '';
  FUseUndoRedo := True;
end;

destructor TRMDesigner.Destroy;
begin
  FDesignerComp := nil;
  inherited Destroy;
end;

procedure TRMDesigner.SetOpenFileCount(Value: Integer);
begin
  if (Value >= 0) and (Value <= 9) then
    FOpenFileCount := Value;
end;

procedure TRMDesigner.SetDesignerRestrictions(Value: TRMDesignerRestrictions);
begin
  FDesignerRestrictions := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarAlign }

constructor TRMToolbarAlign.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
begin
  inherited Create(AOwner);
  Dockedto := DockTo;
  //  Parent := Self;
  FDesignerForm := TRMDesignerForm(AOwner);
  BeginUpdate;
  DockRow := 2;
  DockPos := 10; //ToolbarBorder.DockPos + ToolbarBorder.Width;
  Name := 'ToolbarAlign';

  btnAlignLeft := TRMToolbarButton.Create(Self);
  with btnAlignLeft do
  begin
    ImageIndex := 0;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignLeftClick;
    AddTo := Self;
  end;
  btnAlignHCenter := TRMToolbarButton.Create(Self);
  with btnAlignHCenter do
  begin
    ImageIndex := 1;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignHCenterClick;
    AddTo := Self;
  end;
  btnAlignRight := TRMToolbarButton.Create(Self);
  with btnAlignRight do
  begin
    ImageIndex := 2;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignRightClick;
    AddTo := Self;
  end;
  btnAlignTop := TRMToolbarButton.Create(Self);
  with btnAlignTop do
  begin
    ImageIndex := 3;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignTopClick;
    AddTo := Self;
  end;
  btnAlignVCenter := TRMToolbarButton.Create(Self);
  with btnAlignVCenter do
  begin
    ImageIndex := 4;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignVCenterClick;
    AddTo := Self;
  end;
  btnAlignBottom := TRMToolbarButton.Create(Self);
  with btnAlignBottom do
  begin
    ImageIndex := 5;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignBottomClick;
    AddTo := Self;
  end;
  ToolbarSep9720 := TRMToolbarSep.Create(Self);
  with ToolbarSep9720 do
  begin
    AddTo := Self;
  end;

  btnAlignHSE := TRMToolbarButton.Create(Self);
  with btnAlignHSE do
  begin
    ImageIndex := 6;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignHSEClick;
    AddTo := Self;
  end;
  btnAlignVSE := TRMToolbarButton.Create(Self);
  with btnAlignVSE do
  begin
    ImageIndex := 7;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignVSEClick;
    AddTo := Self;
  end;
  ToolbarSep9721 := TRMToolbarSep.Create(Self);
  with ToolbarSep9721 do
  begin
    AddTo := Self;
  end;

  btnAlignHWCenter := TRMToolbarButton.Create(Self);
  with btnAlignHWCenter do
  begin
    ImageIndex := 8;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignHWCenterClick;
    AddTo := Self;
  end;
  btnAlignVWCenter := TRMToolbarButton.Create(Self);
  with btnAlignVWCenter do
  begin
    ImageIndex := 9;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignVWCenterClick;
    AddTo := Self;
  end;
  ToolbarSep9710 := TRMToolbarSep.Create(Self);
  with ToolbarSep9710 do
  begin
    AddTo := Self;
  end;

  btnAlignLeftRight := TRMToolbarButton.Create(Self);
  with btnAlignLeftRight do
  begin
    ImageIndex := 10;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignLeftRightClick;
    AddTo := Self;
  end;
  btnAlignTopBottom := TRMToolbarButton.Create(Self);
  with btnAlignTopBottom do
  begin
    ImageIndex := 11;
    Images := FDesignerForm.ImageListAlign;
    OnClick := btnAlignTopBottomClick;
    AddTo := Self;
  end;
  EndUpdate;

  Localize;
end;

procedure TRMToolbarAlign.Localize;
begin
  RMSetStrProp(btnAlignLeft, 'Hint', rmRes + 138);
  RMSetStrProp(btnAlignHCenter, 'Hint', rmRes + 139);
  RMSetStrProp(btnAlignHSE, 'Hint', rmRes + 140);
  RMSetStrProp(btnAlignHWCenter, 'Hint', rmRes + 141);
  RMSetStrProp(btnAlignRight, 'Hint', rmRes + 142);
  RMSetStrProp(btnAlignTop, 'Hint', rmRes + 143);
  RMSetStrProp(btnAlignVSE, 'Hint', rmRes + 144);
  RMSetStrProp(btnAlignVWCenter, 'Hint', rmRes + 145);
  RMSetStrProp(btnAlignVCenter, 'Hint', rmRes + 146);
  RMSetStrProp(btnAlignBottom, 'Hint', rmRes + 147);
  RMSetStrProp(btnAlignLeftRight, 'Hint', rmRes + 199);
  RMSetStrProp(btnAlignTopBottom, 'Hint', rmRes + 215);
end;

function TRMToolbarAlign.GetLeftObject: Integer;
var
  i: Integer;
  t: TRMView;
  x: Integer;
begin
  t := FDesignerForm.Objects[FDesignerForm.TopSelected];
  x := t.spLeft_Designer;
  Result := FDesignerForm.TopSelected;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected then
    begin
      if t.spLeft_Designer < x then
      begin
        x := t.spLeft_Designer;
        Result := i;
      end;
    end;
  end;
end;

function TRMToolbarAlign.GetTopObject: Integer;
var
  i: Integer;
  t: TRMView;
  y: Integer;
begin
  Result := FDesignerForm.TopSelected;
  t := FDesignerForm.Objects[Result];
  y := t.spTop_Designer;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected then
    begin
      if t.spTop_Designer < y then
      begin
        y := t.spTop_Designer;
        Result := i;
      end;
    end;
  end;
end;

function TRMToolbarAlign.GetRightObject: Integer;
var
  i: Integer;
  t: TRMView;
  x: Integer;
begin
  Result := FDesignerForm.TopSelected;
  t := FDesignerForm.Objects[Result];
  x := t.spRight_Designer;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected then
    begin
      if t.spRight_Designer > x then
      begin
        x := t.spRight_Designer;
        Result := i;
      end;
    end;
  end;
end;

function TRMToolbarAlign.GetBottomObject: Integer;
var
  i: Integer;
  t: TRMView;
  y: Integer;
begin
  t := FDesignerForm.Objects[FDesignerForm.TopSelected];
  y := t.spBottom_Designer;
  Result := FDesignerForm.TopSelected;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected then
    begin
      if t.spBottom_Designer > y then
      begin
        y := t.spBottom_Designer;
        Result := i;
      end;
    end;
  end;
end;

procedure TRMToolbarAlign.btnAlignLeftClick(Sender: TObject); //左对齐
var
  i: Integer;
  t: TRMView;
  x: Integer;
  liBand: TRMView;
  s: TList;
  y: Integer;
begin
  FDesignerForm.IsBandsSelect(liBand);
  if (liBand <> nil) and (not liBand.IsCrossBand) then
  begin
    FDesignerForm.BeforeChange;
    s := TList.Create;
    try
      t := FDesignerForm.Objects[GetLeftObject];
      x := 0;
      y := t.spTop_Designer;
      for i := 0 to FDesignerForm.Objects.Count - 1 do
      begin
        t := FDesignerForm.Objects[i];
        if (not t.IsBand) and (t.spTop_Designer >= liBand.spTop_Designer) and (t.spRight_Designer <= liBand.spRight_Designer) then
          s.Add(t);
      end;
      for i := 0 to s.Count - 1 do
      begin
        t := s[i];
        t.spLeft_Designer := x;
        t.spTop_Designer := y;
        x := x + t.spWidth_Designer;
      end;
    finally
      s.Free;
    end;
  end
  else
  begin
    if FDesignerForm.SelNum < 2 then Exit;
    FDesignerForm.BeforeChange;
    t := FDesignerForm.GetFirstSelected;
    x := t.spLeft_Designer;
    for i := 0 to FDesignerForm.Objects.Count - 1 do
    begin
      t := FDesignerForm.Objects[i];
      if t.Selected then
        t.spLeft_Designer := x;
    end;
  end;

  FDesignerForm.AfterChange;
end;

procedure TRMToolbarAlign.btnAlignHCenterClick(Sender: TObject); //水平居中
var
  i: Integer;
  t: TRMView;
  x: Integer;
begin
  FDesignerForm.BeforeChange;
  t := FDesignerForm.GetFirstSelected;
  x := t.spLeft_Designer + t.spWidth_Designer div 2;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if (not t.IsBand) and t.Selected then
      t.spLeft_Designer := x - t.spWidth_Designer div 2;
  end;
  FDesignerForm.AfterChange;
end;

procedure TRMToolbarAlign.btnAlignRightClick(Sender: TObject); //右对齐
var
  i: Integer;
  t: TRMView;
  x: Integer;
  liBand: TRMView;
  s: TList;
  y: Integer;
begin
  FDesignerForm.IsBandsSelect(liBand);
  if (liBand <> nil) and (not liBand.IsCrossBand) then
  begin
    FDesignerForm.BeforeChange;
    s := TList.Create;
    try
      t := FDesignerForm.Objects[GetRightObject];
      x := FDesignerForm.FWorkSpace.Width;
      y := t.spTop_Designer;
      for i := 0 to FDesignerForm.Objects.Count - 1 do
      begin
        t := FDesignerForm.Objects[i];
        if (not t.IsBand) and (t.spTop_Designer >= liBand.spTop_Designer) and (t.spBottom_Designer <= liBand.spBottom_Designer) then
          s.Add(t);
      end;
      for i := s.Count - 1 downto 0 do
      begin
        t := s[i];
        t.spLeft_Designer := x - t.spWidth_Designer;
        t.spTop_Designer := y;
        x := x - t.spWidth_Designer;
      end;
    finally
      s.Free;
    end;
  end
  else
  begin
    if FDesignerForm.SelNum < 2 then
      Exit;
    FDesignerForm.BeforeChange;
    t := FDesignerForm.GetFirstSelected;
    x := t.spRight_Designer;
    for i := 0 to FDesignerForm.Objects.Count - 1 do
    begin
      t := FDesignerForm.Objects[i];
      if t.Selected then
        t.spLeft_Designer := x - t.spWidth_Designer;
    end;
  end;

  FDesignerForm.AfterChange;
end;

procedure TRMToolbarAlign.btnAlignTopClick(Sender: TObject); //顶对齐
var
  i: Integer;
  t: TRMView;
  y: Integer;
  lHaveBand: Boolean;
begin
  if FDesignerForm.SelNum < 2 then Exit;
  FDesignerForm.BeforeChange;
  t := FDesignerForm.GetFirstSelected;
  y := t.spTop_Designer;
  lHaveBand := False;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected then
    begin
      t.spTop_Designer := y;
      lHaveBand := lHaveBand or t.IsBand;
    end;
  end;

  if FDesignerForm.AutoChangeBandPos and lHaveBand then
    FDesignerForm.Page.UpdateBandsPageRect;
  FDesignerForm.AfterChange;
end;

procedure TRMToolbarAlign.btnAlignVCenterClick(Sender: TObject); //垂直居中
var
  i: Integer;
  t: TRMView;
  y: Integer;
begin
  if FDesignerForm.SelNum < 2 then Exit;
  FDesignerForm.BeforeChange;
  t := FDesignerForm.GetFirstSelected;
  y := t.spTop_Designer + t.spHeight_Designer div 2;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if (not t.IsBand) and t.Selected then
      t.spTop_Designer := y - t.spHeight_Designer div 2;
  end;
  FDesignerForm.AfterChange;
end;

procedure TRMToolbarAlign.btnAlignBottomClick(Sender: TObject); //底对齐
var
  i: Integer;
  t: TRMView;
  y: Integer;
  lHaveBand: Boolean;
begin
  if FDesignerForm.SelNum < 2 then Exit;
  FDesignerForm.BeforeChange;
  t := FDesignerForm.GetFirstSelected;
  y := t.spBottom_Designer;
  lHaveBand := False;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected then
    begin
      t.spTop_Designer := y - t.spHeight_Designer;
      lHaveBand := lHaveBand or t.IsBand;
    end;
  end;

  if FDesignerForm.AutoChangeBandPos and lHaveBand then
    FDesignerForm.Page.UpdateBandsPageRect;
  FDesignerForm.AfterChange;
end;

procedure TRMToolbarAlign.btnAlignHSEClick(Sender: TObject); //水平平均分布各列
var
  s: TList;
  i, dx: Integer;
  t: TRMView;
begin
  if FDesignerForm.SelNum < 3 then Exit;
  FDesignerForm.BeforeChange;
  s := TList.Create;
  try
    for i := 0 to FDesignerForm.Objects.Count - 1 do
    begin
      t := FDesignerForm.Objects[i];
      if (not t.IsBand) and t.Selected then
        s.Add(t);
    end;
    dx := (TRMView(s[s.Count - 1]).spLeft_Designer - TRMView(s[0]).spLeft_Designer) div (s.Count - 1);
    for i := 1 to s.Count - 2 do
    begin
      t := s[i];
      if (not t.IsBand) and t.Selected then
        t.spLeft_Designer := TRMView(s[i - 1]).spLeft_Designer + dx;
    end;
  finally
    s.Free;
    FDesignerForm.AfterChange;
  end;
end;

procedure TRMToolbarAlign.btnAlignVSEClick(Sender: TObject); //垂直平均分布各列
var
  s: TList;
  i, dy: Integer;
  t: TRMView;
begin
  if FDesignerForm.SelNum < 3 then Exit;
  FDesignerForm.BeforeChange;
  s := TList.Create;
  try
    for i := 0 to FDesignerForm.Objects.Count - 1 do
    begin
      t := FDesignerForm.Objects[i];
      if (not t.IsBand) and t.Selected then
        s.Add(t);
    end;
    dy := (TRMView(s[s.Count - 1]).spTop_Designer - TRMView(s[0]).spTop_Designer) div (s.Count - 1);
    for i := 1 to s.Count - 2 do
    begin
      t := s[i];
      if (not t.IsBand) and t.Selected then
        t.spTop_Designer := TRMView(s[i - 1]).spTop_Designer + dy;
    end;
  finally
    s.Free;
    FDesignerForm.AfterChange;
  end;
end;

procedure TRMToolbarAlign.btnAlignHWCenterClick(Sender: TObject); //窗口水平居中
var
  i: Integer;
  t: TRMView;
  x: Integer;
begin
  if FDesignerForm.SelNum = 0 then Exit;
  FDesignerForm.BeforeChange;
  t := FDesignerForm.Objects[GetLeftObject];
  x := t.spLeft_Designer;
  t := FDesignerForm.Objects[GetRightObject];
  x := x + (t.spRight_Designer - x - FDesignerForm.FWorkSpace.Width) div 2;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if (not t.IsBand) and t.Selected then
      t.spLeft_Designer := t.spLeft_Designer - x;
  end;
  FDesignerForm.AfterChange;
end;

procedure TRMToolbarAlign.btnAlignVWCenterClick(Sender: TObject); //窗口垂直居中
var
  i: Integer;
  t: TRMView;
  y: Integer;
begin
  if FDesignerForm.SelNum = 0 then Exit;
  FDesignerForm.BeforeChange;
  t := FDesignerForm.Objects[GetTopObject];
  y := t.spTop_Designer;
  t := FDesignerForm.Objects[GetBottomObject];
  y := y + (t.spBottom_Designer - y - FDesignerForm.FWorkSpace.Height) div 2;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if (not t.IsBand) and t.Selected then
      t.spTop_Designer := t.spTop_Designer - y;
  end;
  FDesignerForm.AfterChange;
end;

procedure TRMToolbarAlign.btnAlignLeftRightClick(Sender: TObject);
var
  i, j: Integer;
  t: TRMView;
  tmpLeft: Integer;
  s: TList;
begin
  if FDesignerForm.SelNum = 0 then Exit;

  FDesignerForm.BeforeChange;
  s := TList.Create;
  try
    for i := 0 to FDesignerForm.Objects.Count - 1 do
    begin
      t := FDesignerForm.Objects[i];
      if (not t.IsBand) and t.Selected then
        s.Add(t);
    end;
    for i := 0 to s.Count - 1 do
    begin
      for j := i + 1 to s.Count - 1 do
      begin
        if TRMView(s[i]).spLeft_Designer > TRMView(s[j]).spLeft_Designer then
          s.Exchange(i, j);
      end;
    end;

    tmpLeft := TRMView(s[0]).spRight_Designer;
    for i := 1 to s.Count - 1 do
    begin
      t := TRMView(s[i]);
      t.spLeft_Designer := tmpLeft;
      tmpLeft := tmpLeft + t.spWidth_Designer;
    end;
  finally
    s.Free;
    FDesignerForm.AfterChange;
  end;
end;

procedure TRMToolbarAlign.btnAlignTopBottomClick(Sender: TObject);
var
  i, j: Integer;
  t: TRMView;
  tmpTop: Integer;
  s: TList;
begin
  if (FDesignerForm.SelNum = 0) or FDesignerForm.IsBandsSelect(t) then Exit;
  FDesignerForm.BeforeChange;
  s := TList.Create;
  try
    for i := 0 to FDesignerForm.Objects.Count - 1 do
    begin
      t := FDesignerForm.Objects[i];
      if (not t.IsBand) and t.Selected then
        s.Add(t);
    end;
    for i := 0 to s.Count - 1 do
    begin
      for j := i + 1 to s.Count - 1 do
      begin
        if TRMView(s[i]).spTop_Designer > TRMView(s[j]).spTop_Designer then
          s.Exchange(i, j);
      end;
    end;

    tmpTop := TRMView(s[0]).spBottom_Designer;
    for i := 1 to s.Count - 1 do
    begin
      t := TRMView(s[i]);
      t.spTop_Designer := tmpTop;
      tmpTop := tmpTop + t.spHeight_Designer;
    end;
  finally
    s.Free;
    FDesignerForm.AfterChange;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarSize }

constructor TRMToolbarSize.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
begin
  inherited Create(AOwner);
  Dockedto := DockTo;
  //  Parent := Self;
  FDesignerForm := TRMDesignerForm(AOwner);
  DockRow := 2;
  DockPos := 100;
  Name := 'ToolbarSize';

  BeginUpDate;
  btnSetWidthToMin := TRMToolbarButton.Create(Self);
  with btnSetWidthToMin do
  begin
    ImageIndex := 0;
    Images := FDesignerForm.ImageListSize;
    OnClick := btnSetWidthToMinClick;
    AddTo := Self;
  end;
  btnSetWidthToMax := TRMToolbarButton.Create(Self);
  with btnSetWidthToMax do
  begin
    ImageIndex := 1;
    Images := FDesignerForm.ImageListSize;
    OnClick := btnSetWidthToMaxClick;
    AddTo := Self;
  end;
  ToolbarSep979 := TRMToolbarSep.Create(Self);
  with ToolbarSep979 do
  begin
    AddTo := Self;
  end;

  btnSetHeightToMin := TRMToolbarButton.Create(Self);
  with btnSetHeightToMin do
  begin
    ImageIndex := 2;
    Images := FDesignerForm.ImageListSize;
    OnClick := btnSetHeightToMinClick;
    AddTo := Self;
  end;
  btnSetHeightToMax := TRMToolbarButton.Create(Self);
  with btnSetHeightToMax do
  begin
    ImageIndex := 3;
    Images := FDesignerForm.ImageListSize;
    OnClick := btnSetHeightToMaxClick;
    AddTo := Self;
  end;
  EndUpdate;

  Localize;
end;

procedure TRMToolbarSize.Localize;
begin
  RMSetStrProp(btnSetWidthToMin, 'Hint', rmRes + 202);
  RMSetStrProp(btnSetWidthToMax, 'Hint', rmRes + 203);
  RMSetStrProp(btnSetHeightToMin, 'Hint', rmRes + 204);
  RMSetStrProp(btnSetHeightToMax, 'Hint', rmRes + 205);
end;

procedure TRMToolbarSize.btnSetWidthToMinClick(Sender: TObject); //宽度最小
var
  i: Integer;
  t: TRMView;
  tmpWidth: Integer;
begin
  if FDesignerForm.SelNum < 2 then Exit;
  t := FDesignerForm.GetFirstSelected;
  if t.IsBand then Exit;
  FDesignerForm.BeforeChange;
  tmpWidth := t.spWidth_Designer;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected and ((not t.IsBand) or
      (t.IsBand and (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter]))) then
    begin
      if t.spWidth_Designer < tmpWidth then
        tmpWidth := t.spWidth_Designer;
    end;
  end;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected and ((not t.IsBand) or
      (t.IsBand and (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter]))) then
      t.spWidth_Designer := tmpWidth;
  end;
  FDesignerForm.FWorkSpace.GetMultipleSelected;
  FDesignerForm.RedrawPage;
end;

procedure TRMToolbarSize.btnSetWidthToMaxClick(Sender: TObject); //宽度最大
var
  i: Integer;
  t: TRMView;
  tmpWidth: Integer;
begin
  if FDesignerForm.SelNum < 2 then Exit;
  t := FDesignerForm.GetFirstSelected;
  if t.IsBand then Exit;
  FDesignerForm.BeforeChange;
  tmpWidth := t.spWidth_Designer;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected and ((not t.IsBand) or
      (t.IsBand and (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter]))) then
    begin
      if t.spWidth_Designer > tmpWidth then
        tmpWidth := t.spWidth_Designer;
    end;
  end;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected and ((not t.IsBand) or
      (t.IsBand and (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter]))) then
      t.spWidth_Designer := tmpWidth;
  end;
  FDesignerForm.FWorkSpace.GetMultipleSelected;
  FDesignerForm.RedrawPage;
end;

procedure TRMToolbarSize.btnSetHeightToMinClick(Sender: TObject); //高度最小
var
  i: Integer;
  t: TRMView;
  tmpHeight: Integer;
  lHaveBand: Boolean;
begin
  if FDesignerForm.SelNum < 2 then Exit;

  lHaveBand := False;
  t := FDesignerForm.GetFirstSelected;
  FDesignerForm.BeforeChange;
  tmpHeight := t.spHeight_Designer;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected and ((not t.IsBand) or
      (t.IsBand and (not (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter])))) then
    begin
      if t.spHeight_Designer < tmpHeight then
        tmpHeight := t.spHeight_Designer;
    end;
  end;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected and ((not t.IsBand) or
      (t.IsBand and (not (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter])))) then
    begin
      t.spHeight_Designer := tmpHeight;
      if t.IsBand then lHaveBand := True;
    end;
  end;

  if FDesignerForm.AutoChangeBandPos and lHaveBand then
  begin
    //    SendBandsToDown;
    FDesignerForm.Page.UpdateBandsPageRect;
  end;
  FDesignerForm.FWorkSpace.GetMultipleSelected;
  FDesignerForm.RedrawPage;
end;

procedure TRMToolbarSize.btnSetHeightToMaxClick(Sender: TObject); //高度最大
var
  i: Integer;
  t: TRMView;
  tmpHeight: Integer;
  lHaveBand: Boolean;
begin
  if FDesignerForm.SelNum < 2 then Exit;

  lHaveBand := False;
  t := FDesignerForm.GetFirstSelected;
  FDesignerForm.BeforeChange;
  tmpHeight := t.spHeight_Designer;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected and ((not t.IsBand) or
      (t.IsBand and (not (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter])))) then
    begin
      if t.spHeight_Designer > tmpHeight then
        tmpHeight := t.spHeight_Designer;
    end;
  end;
  for i := 0 to FDesignerForm.Objects.Count - 1 do
  begin
    t := FDesignerForm.Objects[i];
    if t.Selected and ((not t.IsBand) or
      (t.IsBand and (not (TRMCustomBandView(t).BandType in [rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter])))) then
    begin
      t.spHeight_Designer := tmpHeight;
      if t.IsBand then lHaveBand := True;
    end;
  end;

  if FDesignerForm.AutoChangeBandPos and lHaveBand then
  begin
    //    SendBandsToDown;
    FDesignerForm.Page.UpdateBandsPageRect;
  end;
  FDesignerForm.FWorkSpace.GetMultipleSelected;
  FDesignerForm.RedrawPage;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarBorder }

constructor TRMToolbarBorder.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
var
  i: Integer;
begin
  inherited Create(AOwner);
  BeginUpdate;
  //  Parent := Self;
  Dockedto := DockTo;
  FDesignerForm := TRMDesignerForm(AOwner);
  DockRow := 2;
  DockPos := 0;
  Name := 'ToolbarBorder';

  btnFrameLeft := TRMToolbarButton.Create(Self);
  with btnFrameLeft do
  begin
    Tag := TAG_SetFrameLeft;
    AllowAllUp := True;
    GroupIndex := 4;
    ImageIndex := 1;
    Images := FDesignerForm.ImageListFrame;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnFrameRight := TRMToolbarButton.Create(Self);
  with btnFrameRight do
  begin
    Tag := TAG_SetFrameRight;
    AllowAllUp := True;
    GroupIndex := 3;
    ImageIndex := 3;
    Images := FDesignerForm.ImageListFrame;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnFrameTop := TRMToolbarButton.Create(Self);
  with btnFrameTop do
  begin
    Tag := TAG_SetFrameTop;
    AllowAllUp := True;
    GroupIndex := 2;
    ImageIndex := 0;
    Images := FDesignerForm.ImageListFrame;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnFrameBottom := TRMToolbarButton.Create(Self);
  with btnFrameBottom do
  begin
    Tag := TAG_SetFrameBottom;
    AllowAllUp := True;
    GroupIndex := 1;
    ImageIndex := 2;
    Images := FDesignerForm.ImageListFrame;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  ToolbarSep9717 := TRMToolbarSep.Create(Self);
  with ToolbarSep9717 do
  begin
    AddTo := Self;
  end;

  btnSetFrame := TRMToolbarButton.Create(Self);
  with btnSetFrame do
  begin
    Tag := TAG_SetFrame;
    ImageIndex := 4;
    Images := FDesignerForm.ImageListFrame;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  btnNoFrame := TRMToolbarButton.Create(Self);
  with btnNoFrame do
  begin
    Tag := TAG_NoFrame;
    ImageIndex := 5;
    Images := FDesignerForm.ImageListFrame;
    OnClick := FDesignerForm.DoClick;
    AddTo := Self;
  end;
  ToolbarSep9722 := TRMToolbarSep.Create(Self);
  with ToolbarSep9722 do
  begin
    AddTo := Self;
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
  ToolbarSep9719 := TRMToolbarSep.Create(Self);
  with ToolbarSep9719 do
  begin
    AddTo := Self;
  end;

  btnSetFrameStyle := TRMFrameStyleButton {TRMToolbarButton}.Create(Self);
  with btnSetFrameStyle do
  begin
    Images := FDesignerForm.ImageListFrame;
    {$IFDEF USE_TB2K}
    Parent := Self;
    FDesignerForm.ImageListFrame.GetBitmap(6, Glyph);
    {$ELSE}
    ImageIndex := 6;
    AddTo := Self;
    {$ENDIF}
    OnStyleChange := btnSetFrameStyle_OnChange;
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

  FBtnBackColor.CurrentColor := 0;
  FBtnFrameColor.CurrentColor := 0;

  EndUpdate;
  Localize;
end;

procedure TRMToolbarBorder.Localize;
begin
  RMSetStrProp(FCmbFrameWidth, 'Hint', rmRes + 194);
  RMSetStrProp(btnSetFrameStyle, 'Hint', rmRes + 191);
  RMSetStrProp(btnSetFrame, 'Hint', rmRes + 126);
  RMSetStrProp(FBtnFrameColor, 'Hint', rmRes + 210);
  RMSetStrProp(FBtnBackColor, 'Hint', rmRes + 209);
  RMSetStrProp(btnNoFrame, 'Hint', rmRes + 127);
  RMSetStrProp(btnSetFrame, 'Hint', rmRes + 126);
  RMSetStrProp(btnFrameRight, 'Hint', rmRes + 125);
  RMSetStrProp(btnFrameBottom, 'Hint', rmRes + 124);
  RMSetStrProp(btnFrameLeft, 'Hint', rmRes + 123);
  RMSetStrProp(btnFrameTop, 'Hint', rmRes + 122);
end;

procedure TRMToolbarBorder.SetStatus;
var
  t: TRMView;
begin
  if FDesignerForm.SelNum = 1 then
  begin
    t := FDesignerForm.Objects[FDesignerForm.TopSelected];
    if not t.IsBand then
    begin
      with t do
      begin
        btnFrameTop.Down := TopFrame.Visible;
        btnFrameLeft.Down := LeftFrame.Visible;
        btnFrameBottom.Down := BottomFrame.Visible;
        btnFrameRight.Down := RightFrame.Visible;
        FBtnBackColor.CurrentColor := FillColor;
        FBtnFrameColor.CurrentColor := t.TopFrame.Color;
        FCmbFrameWidth.Text := FloatToStrF(RMFromMMThousandths(t.TopFrame.mmWidth, rmutScreenPixels), ffGeneral, 2, 2);
      end;
    end;
  end
  else if FDesignerForm.SelNum > 1 then
  begin
    btnFrameTop.Down := False;
    btnFrameLeft.Down := False;
    btnFrameBottom.Down := False;
    btnFrameRight.Down := False;
    FBtnBackColor.CurrentColor := 0;
    FCmbFrameWidth.Text := '1';
  end;
end;

procedure TRMToolbarBorder.btnSetFrameStyle_OnChange(Sender: TObject);
begin
  FDesignerForm.DoClick(Sender);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TRMToolbarModifyPrepared.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
begin
  inherited Create(AOwner);
  BeginUpdate;
  Dockedto := DockTo;
  FDesignerForm := TRMDesignerForm(AOwner);
  DockRow := 4;
  DockPos := 0;
  Name := 'ToolbarModifyPrepared';
  CloseButton := False;

  btnModifyPreviedFirst := TRMToolbarButton.Create(Self);
  with btnModifyPreviedFirst do
  begin
    Width := 60;
    Images := FDesignerForm.ImageListModifyPreview;
    ImageIndex := 0;
    OnClick := btnModifyPreviedFirstClick;
    AddTo := Self;
    {$IFDEF USE_TB2k}
    DisplayMode := nbdmImageAndText;
    {$ELSE}
    DisplayMode := dmBoth;
    {$ENDIF}
  end;
  btnModifyPreviedPrev := TRMToolbarButton.Create(Self);
  with btnModifyPreviedPrev do
  begin
    Width := 60;
    Images := FDesignerForm.ImageListModifyPreview;
    ImageIndex := 1;
    OnClick := btnModifyPreviedPrevClick;
    AddTo := Self;
    {$IFDEF USE_TB2k}
    DisplayMode := nbdmImageAndText;
    {$ELSE}
    DisplayMode := dmBoth;
    {$ENDIF}
  end;
  Edit1 := TRMEdit.Create(Self);
  with Edit1 do
  begin
    Width := 64;
    Text := '1';
    OnKeyPress := Edit1KeyPress;
    AddTo := Self;
  end;
  btnModifyPreviedNext := TRMToolbarButton.Create(Self);
  with btnModifyPreviedNext do
  begin
    Width := 60;
    Images := FDesignerForm.ImageListModifyPreview;
    ImageIndex := 2;
    OnClick := btnModifyPreviedNextClick;
    AddTo := Self;
    {$IFDEF USE_TB2k}
    DisplayMode := nbdmImageAndText;
    {$ELSE}
    DisplayMode := dmBoth;
    {$ENDIF}
  end;
  btnModifyPreviedLast := TRMToolbarButton.Create(Self);
  with btnModifyPreviedLast do
  begin
    Width := 60;
    Images := FDesignerForm.ImageListModifyPreview;
    ImageIndex := 3;
    OnClick := btnModifyPreviedLastClick;
    AddTo := Self;
    {$IFDEF USE_TB2k}
    DisplayMode := nbdmImageAndText;
    {$ELSE}
    DisplayMode := dmBoth;
    {$ENDIF}
  end;
  btnAutoSave := TRMToolbarButton.Create(Self);
  with btnAutoSave do
  begin
    Width := 60;
    AllowAllup := True;
    GroupIndex := 1;
    OnClick := btnAutoSaveClick;
    AddTo := Self;
  end;

  EndUpdate;
  Localize;
end;

procedure TRMToolbarModifyPrepared.Localize;
begin
  RMSetStrProp(btnModifyPreviedFirst, 'Caption', rmRes + 218);
  RMSetStrProp(btnModifyPreviedPrev, 'Caption', rmRes + 219);
  RMSetStrProp(btnModifyPreviedNext, 'Caption', rmRes + 220);
  RMSetStrProp(btnModifyPreviedLast, 'Caption', rmRes + 221);
  RMSetStrProp(btnAutoSave, 'Caption', rmRes + 222);
end;

type
  THackPages = class(TRMPages)
  end;

  THackEndPage = class(TRMEndPage)
  end;

procedure TRMToolbarModifyPrepared._EditPreparedReport(aNewPageNo: Integer);
var
  liEndPage: TRMEndPage;
  liPicture: TPicture;
  libkPic: TRMbkPicture;
  lipicLeft, lipicTop, liPicWidth, liPicHeight: Integer;
  w: Word;
begin
  if FDesignerForm.Modified then
  begin
    if btnAutoSave.Down then
      w := mrYes
    else
      w := Application.MessageBox(PChar(RMLoadStr(SSaveChanges) + '?'),
        PChar(RMLoadStr(SConfirm)), mb_YesNoCancel + mb_IconQuestion);

    if w = mrYes then
    begin
      FDesignerForm.Report.EndPages[FDesignerForm.EndPageNo].ObjectsToStream(FDesignerForm.Report);
      FDesignerForm.Report.CanRebuild := False;
      RMDesigner.Modified := False;
      FDesignerForm.Report.Modified := True;
    end
    else if w = mrCancel then
      Exit;
  end;

  FDesignerForm.Modified := False;
  FDesignerForm.EndPageNo := aNewPageNo;
  libkPic := FDesignerForm.Report.EndPages.bkPictures[FDesignerForm.Report.EndPages[aNewPageNo].bkPictureIndex];
  if libkPic <> nil then
  begin
    liPicture := TPicture.Create;
    liPicture.Assign(libkPic.Picture);
    lipicLeft := libkPic.Left;
    lipicTop := libkPic.Top;
    liPicWidth := libkPic.Width;
    liPicHeight := libkPic.Height;
  end
  else
  begin
    liPicture := nil;
    lipicLeft := 0;
    lipicTop := 0;
    liPicWidth := 0;
    liPicHeight := 0;
  end;

  try
    THackPages(FDesignerForm.Report.Pages).FPages.Clear;
    FDesignerForm.Report.EndPages[FDesignerForm.EndPageNo].StreamToObjects(FDesignerForm.Report, False);

    liEndPage := FDesignerForm.Report.EndPages[FDesignerForm.EndPageNo];
    THackPages(FDesignerForm.Report.Pages).FPages.Add(liEndPage.Page);

    if liPicture <> nil then
    begin
      THackReportPage(liEndPage.Page).FbkPicture.Assign(liPicture);
      liEndPage.Page.bkPictureWidth := liPicWidth;
      liEndPage.Page.bkPictureHeight := liPicHeight;
    end;
    liEndPage.Page.BackPictureLeft := lipicLeft;
    liEndPage.Page.BackPictureTop := lipicTop;
  finally
    liPicture.Free;
    FDesignerForm.CurPage := 0;
    Edit1.Text := IntToStr(FDesignerForm.EndPageNo + 1);
  end;
end;

procedure TRMToolbarModifyPrepared.btnModifyPreviedFirstClick(Sender: TObject);
begin
  if FDesignerForm.EndPageNo <> 0 then
  begin
    _EditPreparedReport(0);
  end;
end;

procedure TRMToolbarModifyPrepared.btnModifyPreviedPrevClick(Sender: TObject);
begin
  if FDesignerForm.EndPageNo > 0 then
  begin
    _EditPreparedReport(FDesignerForm.EndPageNo - 1);
  end;
end;

procedure TRMToolbarModifyPrepared.btnModifyPreviedLastClick(Sender: TObject);
begin
  if FDesignerForm.EndPageNo <> FDesignerForm.Report.EndPages.Count - 1 then
  begin
    _EditPreparedReport(FDesignerForm.Report.EndPages.Count - 1);
  end;
end;

procedure TRMToolbarModifyPrepared.btnModifyPreviedNextClick(Sender: TObject);
begin
  if FDesignerForm.EndPageNo < FDesignerForm.Report.EndPages.Count - 1 then
  begin
    _EditPreparedReport(FDesignerForm.EndPageNo + 1);
  end;
end;

procedure TRMToolbarModifyPrepared.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  liPageNo: Integer;
begin
  if Key = #13 then
  begin
    try
      liPageNo := StrToInt(Edit1.Text);
      if liPageNo < 0 then
        liPageNo := 0;
      if liPageNo > FDesignerForm.Report.EndPages.Count - 1 then
        liPageNo := FDesignerForm.Report.EndPages.Count - 1;
      if FDesignerForm.EndPageNo <> liPageNo then
      begin
        _EditPreparedReport(liPageNo);
      end;
    except;
      Edit1.Text := IntToStr(FDesignerForm.EndPageNo);
    end;
  end;
end;

procedure TRMToolbarModifyPrepared.btnAutoSaveClick(Sender: TObject);
begin
  FDesignerForm.AutoSave := btnAutoSave.Down;
  TRMToolbarButton(Sender).Down := FDesignerForm.AutoSave;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMToolbarStandard }

constructor TRMToolbarStandard.CreateAndDock(AOwner: TComponent; DockTo: TRMDock);
begin
  inherited Create(AOwner);
  BeginUpdate;
  Dockedto := DockTo;
  FDesignerForm := TRMDesignerForm(AOwner);
  DockRow := 0;
  DockPos := 0;
  Name := 'ToolbarStandard';
  CloseButton := False;

  btnFileNew := TRMToolbarButton.Create(Self);
  with btnFileNew do
  begin
    ImageIndex := 0;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnFileNewClick;
    AddTo := Self;
  end;
  {$IFDEF USE_TB2K}
  btnFileOpen := TTBSubmenuItem.Create(Self);
  {$ELSE}
  btnFileOpen := TRMToolbarButton.Create(Self);
  {$ENDIF}
  with btnFileOpen do
  begin
    ImageIndex := 1;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnFileOpenClick;
    DropdownCombo := True;
    {$IFDEF USE_TB2k}
    Self.Items.Add(btnFileOpen);
    {$ELSE}
    AddTo := Self;
    DropdownMenu := FDesignerForm.PopupMenu1;
    {$ENDIF}
  end;
  btnFileSave := TRMToolbarButton.Create(Self);
  with btnFileSave do
  begin
    ImageIndex := 2;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnFileSaveClick;
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
    OnClick := FDesignerForm.padPrintClick;
    AddTo := Self;
  end;
  btnPreview := TRMToolbarButton.Create(Self);
  with btnPreview do
  begin
    ImageIndex := 4;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnPreviewClick;
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
    OnClick := FDesignerForm.btnCutClick;
    AddTo := Self;
  end;
  btnCopy := TRMToolbarButton.Create(Self);
  with btnCopy do
  begin
    ImageIndex := 6;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnCopyClick;
    AddTo := Self;
  end;
  btnPaste := TRMToolbarButton.Create(Self);
  with btnPaste do
  begin
    ImageIndex := 7;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnPasteClick;
    AddTo := Self;
  end;
  ToolbarSep973 := TRMToolbarSep.Create(Self);
  with ToolbarSep973 do
  begin
    AddTo := Self;
  end;

  btnExpression := TRMToolbarButton.Create(Self);
  with btnExpression do
  begin
    ImageIndex := 21;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnExpressionClick;
    AddTo := Self;
  end;
  ToolbarSep1 := TRMToolbarSep.Create(Self);
  with ToolbarSep1 do
  begin
    AddTo := Self;
  end;

  btnRedo := TRMToolbarButton.Create(Self);
  with btnRedo do
  begin
    ImageIndex := 9;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnRedoClick;
    AddTo := Self;
  end;
  btnUndo := TRMToolbarButton.Create(Self);
  with btnUndo do
  begin
    ImageIndex := 8;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnUndoClick;
    AddTo := Self;
  end;
  ToolbarSep974 := TRMToolbarSep.Create(Self);
  with ToolbarSep974 do
  begin
    AddTo := Self;
  end;

  btnBringtoFront := TRMToolbarButton.Create(Self);
  with btnBringtoFront do
  begin
    ImageIndex := 10;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnBringtoFrontClick;
    AddTo := Self;
  end;
  btnSendtoBack := TRMToolbarButton.Create(Self);
  with btnSendtoBack do
  begin
    ImageIndex := 11;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnSendtoBackClick;
    AddTo := Self;
  end;
  btnSelectAll := TRMToolbarButton.Create(Self);
  with btnSelectAll do
  begin
    ImageIndex := 12;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnSelectAllClick;
    AddTo := Self;
  end;
  ToolbarSep975 := TRMToolbarSep.Create(Self);
  with ToolbarSep975 do
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
    OnClick := FDesignerForm.btnAddFormClick;
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
    OnClick := FDesignerForm.btnPageSetupClick;
    AddTo := Self;
  end;
  ToolbarSep976 := TRMToolbarSep.Create(Self);
  with ToolbarSep976 do
  begin
    AddTo := Self;
  end;

  GB1 := TRMToolbarButton.Create(Self);
  with GB1 do
  begin
    Tag := 55;
    AllowAllUp := True;
    GroupIndex := 1;
    ImageIndex := 17;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.GB1Click;
    AddTo := Self;
  end;
  GB2 := TRMToolbarButton.Create(Self);
  with GB2 do
  begin
    Tag := 56;
    AllowAllUp := True;
    GroupIndex := 2;
    ImageIndex := 18;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.GB2Click;
    AddTo := Self;
  end;
  GB3 := TRMToolbarButton.Create(Self);
  with GB3 do
  begin
    Tag := 57;
    ImageIndex := 19;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.GB3Click;
    AddTo := Self;
  end;
  ToolbarSep9723 := TRMToolbarSep.Create(Self);
  with ToolbarSep9723 do
  begin
    AddTo := Self;
  end;

  cmbScale := TRMComboBox97 {TComboBox}.Create(Self);
  with cmbScale do
  begin
    Parent := Self;
    TabStop := False;
    cmbScale.
      Width := 50;
    Items.Add('25%');
    Items.Add('50%');
    Items.Add('75%');
    Items.Add('100%');
    Items.Add('150%');
    Items.Add('200%');
    Items.Add('400%');
    Text := '100%';

    OnChange := OnCmbScaleChangeEvent;
  end;
  ToolbarSepScale := TRMToolbarSep.Create(Self);
  with ToolbarSepScale do
  begin
    AddTo := Self;
  end;

  btnExit := TRMToolbarButton.Create(Self);
  with btnExit do
  begin
    ImageIndex := 20;
    Images := FDesignerForm.ImageListStand;
    OnClick := FDesignerForm.btnExitClick;
    AddTo := Self;
  end;
  Self.EndUpdate;

  Localize;
end;

procedure TRMToolbarStandard.Localize;
begin
  RMSetStrProp(btnFileNew, 'Hint', rmRes + 087);
  RMSetStrProp(btnFileOpen, 'Hint', rmRes + 088);
  RMSetStrProp(btnFileSave, 'Hint', rmRes + 089);
  RMSetStrProp(btnPreview, 'Hint', rmRes + 090);
  RMSetStrProp(btnPrint, 'Hint', rmRes + 159);
  RMSetStrProp(btnCut, 'Hint', rmRes + 091);
  RMSetStrProp(btnCopy, 'Hint', rmRes + 092);
  RMSetStrProp(btnPaste, 'Hint', rmRes + 093);
  RMSetStrProp(btnUndo, 'Hint', rmRes + 094);
  RMSetStrProp(btnRedo, 'Hint', rmRes + 095);
  RMSetStrProp(btnBringtoFront, 'Hint', rmRes + 096);
  RMSetStrProp(btnSendtoBack, 'Hint', rmRes + 097);
  RMSetStrProp(btnSelectAll, 'Hint', rmRes + 098);
  RMSetStrProp(btnAddPage, 'Hint', rmRes + 099);
  RMSetStrProp(btnDeletePage, 'Hint', rmRes + 100);
  RMSetStrProp(btnPageSetup, 'Hint', rmRes + 101);
  RMSetStrProp(btnAddForm, 'Hint', rmRes + 193);
  RMSetStrProp(GB1, 'Hint', rmRes + 102);
  RMSetStrProp(GB2, 'Hint', rmRes + 103);
  RMSetStrProp(GB3, 'Hint', rmRes + 104);
  RMSetStrProp(btnExit, 'Hint', rmRes + 106);
  RMSetStrProp(btnExpression, 'Hint', rmRes + 701);
end;

procedure TRMToolbarStandard.OnCmbScaleChangeEvent(Sender: TObject);
var
  liStr: string;
begin
  FDesignerForm.SetFocus;
  if FDesignerForm.Page is TRMReportPage then
  begin
    liStr := Trim(cmbScale.Text);
    if liStr <> '' then
    begin
      if liStr[Length(liStr)] = '%' then
        SetLength(liStr, Length(liStr) - 1);
      FDesignerForm.Factor := StrToInt(liStr);
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDesignerForm }

function TRMDesignerForm.Objects: TList;
begin
  Result := THackPage(Page).Objects;
end;

function TRMDesignerForm.GetFirstSelected: TRMView;
begin
  if FirstSelected <> nil then
    Result := FirstSelected
  else
    Result := Objects[TopSelected];
end;

procedure TRMDesignerForm.SetObjectsID;
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

procedure TRMDesignerForm.ReleaseAction(aActionRec: PRMUndoRec);
begin
  if aActionRec.Stream <> nil then
  begin
    aActionRec.Stream.Free;
    aActionRec.Stream := nil;
  end;
  SetLength(aActionRec.Objects, 0);
end;

procedure TRMDesignerForm.ClearUndoBuffer;
var
  i: Integer;
begin
  for i := 0 to FUndoBufferLength - 1 do
    ReleaseAction(@FUndoBuffer[i]);
  FUndoBufferLength := 0;

  padUndo.Enabled := False;
  ToolbarStandard.btnUndo.Enabled := padUndo.Enabled;
end;

procedure TRMDesignerForm.ClearRedoBuffer;
var
  i: Integer;
begin
  for i := 0 to FRedoBufferLength - 1 do
    ReleaseAction(@FRedoBuffer[i]);
  FRedoBufferLength := 0;

  padRedo.Enabled := False;
  ToolbarStandard.btnRedo.Enabled := padRedo.Enabled;
end;

procedure TRMDesignerForm.Undo(aBuffer: PRMUndoBuffer);
var
  i: Integer;
  liBufferLength: Integer;

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

  procedure _LoadObjects(aStream: TMemoryStream);
  var
    i, j, liCount: Integer;
    t, t1: TRMView;
    b: Byte;
    liHaveBand: Boolean;
    lList: TList;
  begin
    lList := TList.Create;
    for i := 0 to Page.Objects.Count - 1 do
    begin
      lList.Add(Page.Objects[i]);
    end;

    liHaveBand := False;
    aStream.Position := 0;
    liCount := RMReadInt32(aStream);
    for i := 0 to liCount - 1 do
    begin
      b := RMReadByte(aStream);
      t := RMCreateObject(b, RMReadString(aStream));
      t.NeedCreateName := False;
      THackView(t).StreamMode := rmsmDesigning;
      t.LoadFromStream(aStream);
      t.ParentPage := Page;
      if t.IsBand then
      begin
        liHaveBand := True;
        for j := 0 to lList.Count - 1 do
        begin
          t1 := lList[j];
          if t1.spTop >= t.spTop then
          begin
            t1.spTop := t1.spTop + t.spHeight;
          end;
        end;
      end;
    end;

    lList.Free;
    if AutoChangeBandPos and liHaveBand then
    begin
      SendBandsToDown;
      Page.UpdateBandsPageRect;
    end;
  end;

  procedure _AssignObjects(aStream: TMemoryStream);
  var
    i, liCount: Integer;
    t: TRMView;
    liHaveBand: Boolean;
  begin
    liHaveBand := False;
    aStream.Position := 0;
    liCount := RMReadInt32(aStream);
    for i := 0 to liCount - 1 do
    begin
      RMReadByte(aStream);
      RMReadString(aStream);
      t := Objects[_FindObjectByID(aBuffer[liBufferLength - 1].Objects[i].ObjID)];
      t.NeedCreateName := False;
      THackView(t).StreamMode := rmsmDesigning;
      t.LoadFromStream(aStream);
      if t.IsBand then
        liHaveBand := True;
    end;

    if AutoChangeBandPos and liHaveBand then
      Page.UpdateBandsPageRect;
  end;

  procedure _SetUndo(isDeleteAction: Boolean);
  var
    i: Integer;
    liList: TList;
    liAction: TRMUndoAction;
  begin
    liList := TList.Create;
    try
      liAction := acEdit;
      case aBuffer[liBufferLength - 1].Action of
        acInsert:
          begin
            liAction := acDelete;
            for i := Low(aBuffer[liBufferLength - 1].Objects) to High(aBuffer[liBufferLength - 1].Objects) do
              liList.Add(Objects[_FindObjectByID(aBuffer[liBufferLength - 1].Objects[i].ObjID)]);
          end;
        acDelete:
          begin
            liAction := acInsert;
            if isDeleteAction then
            begin
              for i := Low(aBuffer[liBufferLength - 1].Objects) to High(aBuffer[liBufferLength - 1].Objects) do
                liList.Add(Objects[_FindObjectByID(aBuffer[liBufferLength - 1].Objects[i].ObjID)]);
            end;
          end;
        acEdit:
          begin
            liAction := acEdit;
            for i := Low(aBuffer[liBufferLength - 1].Objects) to High(aBuffer[liBufferLength - 1].Objects) do
              liList.Add(Objects[_FindObjectByID(aBuffer[liBufferLength - 1].Objects[i].ObjID)]);
          end;
        acZOrder:
          begin
            liAction := acZOrder;
            for i := Low(aBuffer[liBufferLength - 1].Objects) to High(aBuffer[liBufferLength - 1].Objects) do
              liList.Add(Objects[_FindObjectByID(aBuffer[liBufferLength - 1].Objects[i].ObjID)]);
          end;
      end;

      if aBuffer = @FUndoBuffer then
        AddAction(@FRedoBuffer, liAction, liList)
      else
        AddAction(@FUndoBuffer, liAction, liList);
    finally
      liList.Free;
    end;

  end;

begin
  if (FDesignerComp <> nil) and (not FDesignerComp.UseUndoRedo) then Exit;
  if aBuffer = @FUndoBuffer then
    liBufferLength := FUndoBufferLength
  else
    liBufferLength := FRedoBufferLength;

  if aBuffer[liBufferLength - 1].Page <> CurPage then Exit;

  if aBuffer[liBufferLength - 1].Action <> acDelete then
    _SetUndo(False);
  case aBuffer[liBufferLength - 1].Action of
    acInsert:
      begin
        for i := Low(aBuffer[liBufferLength - 1].Objects) to High(aBuffer[liBufferLength - 1].Objects) do
        begin
          Page.Delete(_FindObjectByID(aBuffer[liBufferLength - 1].Objects[i].ObjID));
        end;
      end;
    acDelete:
      begin
        _LoadObjects(aBuffer[liBufferLength - 1].Stream);
      end;
    acEdit:
      begin
        _AssignObjects(aBuffer[liBufferLength - 1].Stream);
      end;
    acZOrder:
      begin
        for i := Low(aBuffer[liBufferLength - 1].Objects) to High(aBuffer[liBufferLength - 1].Objects) do
        begin
          Objects[i] := Objects[_FindObjectByID(aBuffer[liBufferLength - 1].Objects[i].ObjID)];
        end;
      end;
  end;

  if aBuffer[liBufferLength - 1].Action = acDelete then
    _SetUndo(True);

  ReleaseAction(@aBuffer[liBufferLength - 1]);
  if aBuffer = @FUndoBuffer then
    Dec(FUndoBufferLength)
  else
    Dec(FRedoBufferLength);

  ResetSelection;
  RedrawPage;
end;

procedure TRMDesignerForm.AddAction(aBuffer: PRMUndoBuffer; aAction: TRMUndoAction;
  aList: TList);
var
  i: Integer;
  liBufferLength: Integer;

  procedure _SelectionToMemStream(aStream: TMemoryStream);
  var
    i: Integer;
    t: TRMView;
  begin
    RMWriteInt32(aStream, aList.Count);
    for i := 0 to aList.Count - 1 do
    begin
      t := aList[i];
      THackView(t).StreamMode := rmsmDesigning;
      RMWriteByte(aStream, t.ObjectType);
      RMWriteString(aStream, t.ClassName);
      t.SaveToStream(aStream);
    end;
  end;

begin
  if FUndoBusy then Exit;

  FUndoBusy := True;
  if aBuffer = @FUndoBuffer then
    liBufferLength := FUndoBufferLength
  else
    liBufferLength := FRedoBufferLength;

  if liBufferLength >= MaxUndoBuffer then
  begin
    ReleaseAction(@aBuffer[0]);
    for i := 0 to MaxUndoBuffer - 2 do
      aBuffer^[i] := aBuffer^[i + 1];
    liBufferLength := MaxUndoBuffer - 1;
    aBuffer[liBufferLength].Stream := nil;
    SetLength(aBuffer[liBufferLength].Objects, 0);
  end;
  aBuffer[liBufferLength].Action := aAction;
  aBuffer[liBufferLength].Page := CurPage;

  SetLength(aBuffer[liBufferLength].Objects, aList.Count);
  for i := 0 to aList.Count - 1 do
    aBuffer[liBufferLength].Objects[i].ObjID := THackView(aList[i]).ObjectID;
  case aAction of
    acInsert:
      begin
      end;
    acDelete, acEdit:
      begin
        aBuffer[liBufferLength].Stream := TMemoryStream.Create;
        _SelectionToMemStream(aBuffer[liBufferLength].Stream);
      end;
    acZOrder:
      begin
      end;
  end;

  if aBuffer = @FUndoBuffer then
  begin
    FUndoBufferLength := liBufferLength + 1;
  end
  else
  begin
    FRedoBufferLength := liBufferLength + 1;
  end;
  Modified := True;
  FUndoBusy := False;
end;

procedure TRMDesignerForm.AddUndoAction(aAction: TRMUndoAction);
var
  i: Integer;
  t: TRMView;
  liList: TList;
begin
  if (FDesignerComp <> nil) and (not FDesignerComp.UseUndoRedo) then Exit;
  ClearRedoBuffer;
  liList := TList.Create;
  try
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if (t.Selected or (aAction = acZOrder)) and (not THackView(t).DontUndo) then
      begin
        if (aAction = acDelete) and (t.Restrictions * [rmrtDontDelete] = []) then
          liList.Add(t)
        else
          liList.Add(t);
      end;
    end;
    if liList.Count > 0 then
      AddAction(@FUndoBuffer, aAction, liList)
  finally
    liList.Free;
  end;
end;

procedure TRMDesignerForm.CreateDefaultPage;
//var
//  liBandPageHeader: TRMBandPageHeader;
//  liBandPageFooter: TRMBandPageFooter;
//  liBandMasterData: TRMBandMasterData;
begin
  Report.Pages.AddReportPage;
  Report.Pages[0].CreateName;

  {  liBandPageHeader := TRMBandPageHeader.Create;
    liBandPageHeader.ParentPage := Report.Pages[0];
    liBandPageHeader.spHeight_Designer := 18 * 3;

    liBandPageFooter := TRMBandPageFooter.Create;
    liBandPageFooter.ParentPage := Report.Pages[0];
    liBandPageFooter.spHeight_Designer := 18 * 2;

    liBandMasterData := TRMBandMasterData.Create;
    liBandMasterData.ParentPage := Report.Pages[0];
    liBandMasterData.spHeight_Designer := 18 * 3;
  }
end;

procedure TRMDesignerForm.SelectionChanged(aRefreshInspProp: Boolean);
var
  t: TRMView;
begin
  if FBusy then Exit;
  FBusy := True;
  EnableControls;
  ToolbarBorder.SetStatus;
  t := nil;
  if SelNum = 1 then
  begin
    t := Objects[TopSelected];
  end
  else if SelNum > 1 then
  begin
    t := Objects[TopSelected];
    FcmbFont.ItemIndex := -1;
    FcmbFontSize.Text := '';
    btnFontBold.Down := False;
    btnFontItalic.Down := False;
    btnFontUnderline.Down := False;
    btnTextAlignLeft.Down := False;
    btnTextAlignVCenter.Down := False;
  end;

  if (t <> nil) and not t.IsBand then
  begin
    if t is TRMCustomMemoView then
    begin
      with t as TRMCustomMemoView do
      begin
        FBtnFontColor.CurrentColor := Font.Color;
        if FcmbFont.ItemIndex <> FcmbFont.Items.IndexOf(Font.Name) then
          FcmbFont.ItemIndex := FcmbFont.Items.IndexOf(Font.Name);
          
        RMSetFontSize(TComboBox(FCmbFontSize), Font.Height, Font.Size);
        btnFontBold.Down := fsBold in Font.Style;
        btnFontItalic.Down := fsItalic in Font.Style;
        btnFontUnderline.Down := fsUnderline in Font.Style;
        case VAlign of
          rmVTop: btnTextAlignTop.Down := True;
          rmVBottom: btnTextAlignBottom.Down := True;
        else
          btnTextAlignVCenter.Down := True;
        end;
        case HAlign of
          rmhLeft: btnTextAlignLeft.Down := True;
          rmhCenter: btnTextAlignCenter.Down := True;
          rmhRight: btnTextAlignRight.Down := True;
        else
          btnTextAlignH.Down := True;
        end;
      end;
    end;
  end;

  if aRefreshInspProp then ShowPosition;
  ShowContent;

  FBusy := False;
end;

procedure TRMDesignerForm.FillInspFields;
var
  i: Integer;
  t, t1: TRMView;
begin
  if not FInspForm.Visible then Exit;
  if FInspBusy then Exit;

  FInspBusy := True;
  if SelNum > 0 then
    t := Objects[TopSelected]
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
      for i := 0 to Objects.Count - 1 do
      begin
        t1 := Objects[i];
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

procedure TRMDesignerForm.OnInspBeforeModify(Sender: TObject; const aPropName: string);
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

procedure TRMDesignerForm.OnInspAfterModify(Sender: TObject; const aPropName, aPropValue: string);
begin
  if FInspForm.Insp.Objects[0] is TRMDialogPage then
  begin
    FWorkSpace.PageForm.SetPageFormProp;
  end
  else if FInspForm.Insp.Objects[0] is TRMCustomBandView then
  begin
    if AutoChangeBandPos and (AnsiCompareText(aPropName, 'Top') = 0) or (AnsiCompareText(aPropName, 'Height') = 0) then
    begin
      Page.UpdateBandsPageRect;
      RedrawPage;
    end;
  end;

  if AnsiCompareText(aPropName, 'Name') = 0 then
  begin
    FInspForm.SetCurrentObject(FInspForm.Insp.Objects[0].ClassName, aPropValue);
  end;

  Modified := True;
  RedrawPage;
  SetPageTabs;
  StatusBar1.Repaint;
  PBox1Paint(nil);
  SelectionChanged(False);
  if FFieldForm.Visible then
    FFieldForm.RefreshData;
end;

procedure TRMDesignerForm.SelectObject(ObjName: string);
var
  t: TRMView;
begin
  t := Page.FindObject(ObjName);
  if t <> nil then
  begin
    UnselectAll;
    SelNum := 1;
    t.Selected := True;
    SelectionChanged(True);
    RedrawPage;
    FWorkSpace.GetMultipleSelected;
  end
  else if Pos('Page', ObjName) = 1 then // it's page name
    CurPage := StrToInt(Copy(ObjName, 5, 9999)) - 1;
end;

procedure TRMDesignerForm.InspSelectionChanged(ObjName: string);
begin
  SelectObject(ObjName);
  if Tab1.TabIndex = 0 then
    FillInspFields;
end;

const
  rsGridShow = 'GridShow';
  rsGridAlign = 'GridAlign';
  rsGridSize = 'GridSize';
  rsUnits = 'Units';
  rsEdit = 'EditAfterInsert';
  rsSelection = 'Selection';
  rsBandTitles = 'BandTitles';
  rsAutoOpenLastFile = 'AutoOpenLastFile';
  rsAutoChangeBandPos = 'AutoChangeBandPos';
  rsWorkSpaceColor = 'WorkSpaceColor';
  rsInspFormColor = 'InspFormColor';
  rsLocalizedPropertyName = 'LocalizedPropertyName';

procedure TRMDesignerForm.SaveIni;
var
  Ini: TRegIniFile;
  Nm: string;
  i: Integer;
begin
  Ini := TRegIniFile.Create(RMRegRootKey + '\RMReport');
  try
    Nm := rsForm + Name;
    Ini.WriteBool(Nm, rsLocalizedPropertyName, RMLocalizedPropertyNames);
    Ini.WriteBool(Nm, rsAutoOpenLastFile, AutoOpenLastFile);
    Ini.WriteBool(Nm, rsAutoChangeBandPos, AutoChangeBandPos);
    Ini.WriteBool(Nm, rsGridShow, ShowGrid);
    Ini.WriteBool(Nm, rsGridAlign, GridAlign);
    Ini.WriteInteger(Nm, rsGridSize, GridSize);
    Ini.WriteInteger(Nm, rsUnits, Word(RMUnits));
    Ini.WriteBool(Nm, rsEdit, FEditAfterInsert);
    Ini.WriteInteger(Nm, rsSelection, Integer(FShapeMode));
    Ini.WriteBool(Nm, rsBandTitles, RM_Class.RMShowBandTitles);
    Ini.WriteInteger(rsForm + FInspForm.ClassName, 'SplitPos', FInspForm.SplitterPos);
    Ini.WriteInteger(rsForm + FInspForm.ClassName, 'SplitPos1', FInspForm.SplitterPos1);
    Ini.WriteBool(Nm, rsUseTableName, UseTableName);
    Ini.WriteInteger(Nm, rsWorkSpaceColor, WorkSpaceColor);
    Ini.WriteInteger(Nm, rsInspFormColor, InspFormColor);
    Ini.WriteBool(Nm, ToolbarComponent.ClassName + '_Visible', ToolbarComponent.Visible);
    if not IsPreviewDesign then
    begin
      Ini.WriteInteger(rsForm + FFieldForm.ClassName, 'SplitPos', FFieldForm.SplitterPos);
      Ini.EraseSection(rsOpenFiles);
      for i := 1 to FOpenFiles.Count do
        Ini.WriteString(rsOpenFiles, 'File' + IntToStr(i), FOpenFiles[i - 1]);
    end;
  finally
    Ini.Free;
  end;

  RMSaveToolbars('\RMReport', [ToolbarBorder, ToolbarStandard, ToolbarEdit, ToolbarAlign, ToolBarAddinTools, ToolbarSize]);
  if IsPreviewDesign then
  begin
    RMSaveToolbars('\RMReport', [ToolbarModifyPrepared]);
  end;
  RMSaveToolWinPosition('\RMReport', FInspForm);
  RMSaveFormPosition('\RMReport', Self);
  if not IsPreviewDesign then
  begin
    RMSaveToolWinPosition('\RMReport', FFieldForm);
  end;
end;

procedure TRMDesignerForm.LoadIni;
var
  Ini: TRegIniFile;
  Nm: string;
begin
  Ini := TRegIniFile.Create(RMRegRootKey + '\RMReport');
  try
    Nm := rsForm + Name;
    RMLocalizedPropertyNames := Ini.ReadBool(Nm, rsLocalizedPropertyName, RMLocalizedPropertyNames);
    FGridSize := Ini.ReadInteger(Nm, rsGridSize, 4);
    if FGridSize = 0 then
      FGridSize := 4;
    FGridAlign := Ini.ReadBool(Nm, rsGridAlign, True);
    FShowGrid := Ini.ReadBool(Nm, rsGridShow, True);
    RMUnits := TRMUnitType(Ini.ReadInteger(Nm, rsUnits, 0));
    FHRuler.Units := RMUnits;
    FVRuler.Units := RMUnits;
    FEditAfterInsert := Ini.ReadBool(Nm, rsEdit, False);
    FShapeMode := TRMShapeMode(Ini.ReadInteger(Nm, rsSelection, 0));
    RM_Class.RMShowBandTitles := Ini.ReadBool(Nm, rsBandTitles, True);
    UseTableName := Ini.ReadBool(Nm, rsUseTableName, True);
    RMRestoreToolWinPosition('\RMReport', FInspForm);
    FInspForm.SplitterPos := Ini.ReadInteger(rsForm + FInspForm.ClassName, 'SplitPos', 75);
    FInspForm.SplitterPos1 := Ini.ReadInteger(rsForm + FInspForm.ClassName, 'SplitPos1', FInspForm.SplitterPos1);
    FInspForm.Visible := Ini.ReadBool(rsForm + FInspForm.ClassName, rsVisible, True);
    WorkSpaceColor := Ini.ReadInteger(Nm, rsWorkSpaceColor, clWhite);
    InspFormColor := Ini.ReadInteger(Nm, rsInspFormColor, clWhite);
    ToolbarComponent.Visible := Ini.ReadBool(Nm, ToolbarComponent.ClassName + '_Visible', True);
    FFieldForm.SplitterPos := Ini.ReadInteger(rsForm + FFieldForm.ClassName, 'SplitPos', 75);
  finally
    Ini.Free;
  end;

  {$IFNDEF USE_TB2K}
  Dock971.BeginUpdate;
  Dock972.BeginUpdate;
  Dock973.BeginUpdate;
  Dock974.BeginUpdate;
  try
    {$ENDIF}
    RMRestoreToolbars('\RMReport', [ToolbarBorder, ToolbarStandard, ToolbarEdit, ToolbarAlign, ToolBarAddinTools, ToolbarSize]);
    RMRestoreToolWinPosition('\RMReport', FFieldForm);
    if IsPreviewDesign then
      FFieldForm.Visible := False;
    if IsPreviewDesign and ShowModifyToolbar then
    begin
      RMRestoreToolbars('\RMReport', [ToolbarModifyPrepared]);
      ToolbarModifyPrepared.Visible := True;
    end;
    if ToolBarAddinTools.Height < 26 then
      ToolBarAddinTools.Height := 26;
    if ToolBarAddinTools.Width < 26 then
      ToolBarAddinTools.Width := 26;
    {$IFDEF USE_TB2k}
    if ToolBarAddinTools.Items.Count < 1 then
      {$ELSE}
    if ToolBarAddinTools.ControlCount < 1 then
      {$ENDIF}
      ToolBarAddinTools.Hide;
    RMRestoreFormPosition('\RMReport', Self);
    {$IFNDEF USE_TB2K}
  finally
    Dock971.EndUpdate;
    Dock972.EndUpdate;
    Dock973.EndUpdate;
    Dock974.EndUpdate;
  end;
  {$ENDIF}
end;

procedure TRMDesignerForm.SetOpenFileMenuItems(const aNewFile: string);
var
  i, lCount, liIndex: Integer;
  str: string;
  {$IFDEF USE_TB2k}
  lItem: TTBItem;
  {$ELSE}
  lItem: TMenuItem;
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

  lDefaultOpenFileIndex := barFile.IndexOf(itmFileFile1) - 1;
  {$IFDEF USE_TB2K}
  ToolbarStandard.btnFileOpen.Clear;
  {$ELSE}
  while PopupMenu1.Items.Count > 0 do
    PopupMenu1.Items.Delete(0);
  for i := 0 to 9 do
  begin
    if barFile.Items[lDefaultOpenFileIndex + 1 + i].Visible then
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
    barFile.Items[lDefaultOpenFileIndex + i].Caption := '&' + IntToStr(i) + ' ' + str;
    barFile.Items[lDefaultOpenFileIndex + i].Visible := True;
    {$IFDEF USE_TB2k}
    lItem := TTBItem.Create(ToolbarStandard.btnFileOpen);
    lItem.Tag := barFile.Items[lDefaultOpenFileIndex + i].Tag;
    lItem.Caption := barFile.Items[lDefaultOpenFileIndex + i].Caption;
    lItem.OnClick := itmFileFile9Click;
    ToolbarStandard.btnFileOpen.Add(lItem);
    {$ELSE}
    lItem := TMenuItem.Create(PopupMenu1);
    lItem.Tag := barFile.Items[lDefaultOpenFileIndex + i].Tag;
    lItem.Caption := barFile.Items[lDefaultOpenFileIndex + i].Caption;
    lItem.OnClick := itmFileFile9Click;
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
    barFile.Items[lDefaultOpenFileIndex + 1 + i].Visible := False;
  N1.Visible := lCount > 0;
end;

procedure TRMDesignerForm.InspGetObjects(List: TStrings);
var
  i: Integer;
begin
  List.Clear;
  for i := 0 to Objects.Count - 1 do
    List.Add(TRMView(Objects[i]).Name);
  for i := 0 to Report.Pages.Count - 1 do
    List.Add('Page' + IntToStr(i + 1));
end;

procedure TRMDesignerForm.SetCurDocName(Value: string);
var
  str: string;
begin
  FCurDocName := Value;
  if Report.ReportInfo.Title <> '' then
    str := Report.ReportInfo.Title + '(' + ExtractFileName(Value) + ')'
  else
    str := ExtractFileName(Value);

  Caption := FCaption + ' - ' + str;
end;

function TRMDesignerForm.GetModified: Boolean;
begin
  Result := Report.Modified;
end;

procedure TRMDesignerForm.SetModified(Value: Boolean);
begin
  if Report.Modified = Value then Exit;
  Report.Modified := Value;
  if Value and (not IsPreviewDesign) then
    Report.ComponentModified := True;
  ToolbarStandard.btnFileSave.Enabled := (not IsPreviewDesign) and Value;
  padFileSave.Enabled := ToolbarStandard.btnFileSave.Enabled;
end;

procedure TRMDesignerForm.ScrollBox1Resize(Sender: TObject);
begin
  FWorkSpace.SetPage;
end;

procedure TRMDesignerForm.OnDockRequestDockEvent(Sender: TObject;
  Bar: TRMCustomDockableWindow; var Accept: Boolean);
begin
  Accept := not ((Bar = FInspForm) or (Bar = FFieldForm));
end;

procedure TRMDesignerForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  FCaption := RMLoadStr(rmRes + 080);
  RMSetStrProp(ToolbarStandard, 'Caption', rmRes + 081);
  RMSetStrProp(ToolbarEdit, 'Caption', rmRes + 082);
  RMSetStrProp(ToolbarBorder, 'Caption', rmRes + 083);
  RMSetStrProp(ToolbarAlign, 'Caption', rmRes + 84);
  RMSetStrProp(ToolbarSize, 'Caption', rmRes + 85);
  RMSetStrProp(ToolbarAddinTools, 'Caption', rmRes + 200);

  RMSetStrProp(btnTextAlignLeft, 'Hint', rmRes + 107);
  RMSetStrProp(btnTextAlignRight, 'Hint', rmRes + 108);
  RMSetStrProp(btnTextAlignCenter, 'Hint', rmRes + 109);
  RMSetStrProp(btnTextAlignVCenter, 'Hint', rmRes + 111);
  RMSetStrProp(btnTextAlignTop, 'Hint', rmRes + 112);
  RMSetStrProp(btnTextAlignBottom, 'Hint', rmRes + 113);
  RMSetStrProp(btnTextAlignH, 'Hint', rmRes + 114);
  RMSetStrProp(HlB1, 'Hint', rmRes + 119);
  RMSetStrProp(padpopCut, 'Caption', rmRes + 148);
  RMSetStrProp(padpopCopy, 'Caption', rmRes + 149);
  RMSetStrProp(padpopPaste, 'Caption', rmRes + 150);
  RMSetStrProp(padpopDelete, 'Caption', rmRes + 151);
  RMSetStrProp(padpopSelectAll, 'Caption', rmRes + 152);
  RMSetStrProp(padpopEdit, 'Caption', rmRes + 153);
  RMSetStrProp(padpopFrame, 'Caption', rmRes + 214);
  RMSetStrProp(padpopClearContents, 'Caption', rmRes + 881);
  RMSetStrProp(barFile, 'Caption', rmRes + 154);
  RMSetStrProp(padFileNew, 'Caption', rmRes + 155);
  RMSetStrProp(padFileOpen, 'Caption', rmRes + 156);
  RMSetStrProp(padFileSave, 'Caption', rmRes + 157);
  RMSetStrProp(padVarList, 'Caption', rmRes + 158);
  RMSetStrProp(padPrint, 'Caption', rmRes + 159);
  RMSetStrProp(padPageSetup, 'Caption', rmRes + 160);
  RMSetStrProp(padPreview, 'Caption', rmRes + 161);
  RMSetStrProp(padExit, 'Caption', rmRes + 162);
  RMSetStrProp(barEdit, 'Caption', rmRes + 163);
  RMSetStrProp(padUndo, 'Caption', rmRes + 164);
  RMSetStrProp(padRedo, 'Caption', rmRes + 165);
  RMSetStrProp(padCut, 'Caption', rmRes + 166);
  RMSetStrProp(padCopy, 'Caption', rmRes + 167);
  RMSetStrProp(padPaste, 'Caption', rmRes + 168);
  RMSetStrProp(padDelete, 'Caption', rmRes + 169);
  RMSetStrProp(padSelectAll, 'Caption', rmRes + 170);
  RMSetStrProp(padEdit, 'Caption', rmRes + 171);
  RMSetStrProp(padNewPage, 'Caption', rmRes + 172);
  RMSetStrProp(padDeletePage, 'Caption', rmRes + 173);
  RMSetStrProp(padBringtoFront, 'Caption', rmRes + 174);
  RMSetStrProp(padSendtoBack, 'Caption', rmRes + 175);
  RMsetStrProp(padEditReplace, 'Caption', rmRes + 217);
  RMSetStrProp(barTools, 'Caption', rmRes + 176);
  RMSetStrProp(padSetToolbar, 'Caption', rmRes + 177);
  RMSetStrProp(padAddTools, 'Caption', rmRes + 178);
  RMSetStrProp(padOptions, 'Caption', rmRes + 179);
  RMSetStrProp(itmEditLockControls, 'Caption', rmRes + 226);

  RMSetStrProp(Pan1, 'Caption', rmRes + 180);
  RMSetStrProp(Pan2, 'Caption', rmRes + 181);
  RMSetStrProp(Pan3, 'Caption', rmRes + 182);
  RMSetStrProp(Pan4, 'Caption', rmRes + 183);
  RMSetStrProp(Pan5, 'Caption', rmRes + 184);
  RMSetStrProp(Pan6, 'Caption', rmRes + 185);
  RMSetStrProp(Pan7, 'Caption', rmRes + 186);
  RMSetStrProp(Pan8, 'Caption', rmRes + 206);
  RMSetStrProp(Pan9, 'Caption', rmRes + 110);

  RMSetStrProp(barHelp, 'Caption', rmRes + 190);
  RMSetStrProp(padAbout, 'Caption', rmRes + 187);
  RMSetStrProp(padFileSaveAs, 'Caption', rmRes + 188);
  RMSetStrProp(padHelp, 'Caption', rmRes + 189);
  RMSetStrProp(padNewForm, 'Caption', rmRes + 192);
  padpopAddPage.Caption := padNewPage.Caption;
  padpopAddForm.Caption := padNewForm.Caption;
  padpopDeletePage.Caption := padDeletePage.Caption;
  padpopPageSetup.Caption := padPageSetup.Caption;
  RMSetStrProp(padFileProperty, 'Caption', rmRes + 216);
  RMSetStrProp(FBtnFontColor, 'Hint', rmRes + 208);
  RMSetStrProp(btnFontUnderLine, 'Hint', rmRes + 117);
  RMSetStrProp(btnFontItalic, 'Hint', rmRes + 116);
  RMSetStrProp(btnFontBold, 'Hint', rmRes + 115);

  RMSetStrProp(LoadDictionary1, 'Caption', rmRes + 223);
  RMSetStrProp(MergeDictionary1, 'Caption', rmRes + 224);
  RMSetStrProp(SaveAsDictionary1, 'Caption', rmRes + 225);
end;

procedure TRMDesignerForm.GB1Click(Sender: TObject);
begin
  ShowGrid := ToolbarStandard.GB1.Down;
end;

procedure TRMDesignerForm.GB2Click(Sender: TObject);
begin
  GridAlign := ToolbarStandard.GB2.Down;
end;

procedure TRMDesignerForm.GB3Click(Sender: TObject);
var
  i: Integer;
  t: TRMView;
begin
  AddUndoAction(acEdit);
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    if t.Selected then
    begin
      t.spLeft_Designer := Round(t.spLeft_Designer / GridSize) * GridSize;
      t.spTop_Designer := Round(t.spTop_Designer / GridSize) * GridSize;
      t.spWidth_Designer := Round(t.spWidth_Designer / GridSize) * GridSize;
      t.spHeight_Designer := Round(t.spHeight_Designer / GridSize) * GridSize;
      if t.spWidth_Designer = 0 then
        t.spWidth_Designer := GridSize;
      if t.spHeight_Designer = 0 then
        t.spHeight_Designer := GridSize;
    end;
  end;

  FWorkSpace.GetMultipleSelected;
  RedrawPage;
  ShowPosition;
end;

procedure TRMDesignerForm.SetFactor(Value: Integer);
begin
  if FFactor <> Value then
  begin
    FFactor := Value;
    FWorkSpace.Init;
    CurPage := CurPage;
  end;
end;

function TRMDesignerForm.GetDesignerRestrictions: TRMDesignerRestrictions;
begin
  if FDesignerComp <> nil then
    Result := FDesignerComp.DesignerRestrictions
  else
    Result := [];
end;

procedure TRMDesignerForm.SetDesignerRestrictions(Value: TRMDesignerRestrictions);
begin
  if FDesignerComp <> nil then
    FDesignerComp.DesignerRestrictions := Value;
end;

procedure TRMDesignerForm.HlB1Click(Sender: TObject);
var
  t: TRMCustomMemoView;
  tmp: TRMHilightForm;
begin
  t := Objects[TopSelected];
  if t = nil then Exit;
  tmp := TRMHilightForm.Create(nil);
  try
    tmp.ShowEditor(t);
  finally
    tmp.Free;
  end;
  RedrawPage;
end;

function TRMDesignerForm.GetScript: TStrings;
begin
  Result := FCodeMemo.Lines;
end;

procedure TRMDesignerForm.SetScript(Value: TStrings);
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

procedure TRMDesignerForm.FormCreate(Sender: TObject);
var
  liOffset: Integer;

  procedure _CreateTabPanel;
  begin
    Tab1 := TRMTabControl.Create(Self);
    Panel2 := TRMPanel.Create(Self);
    pnlHorizontalRuler := TRMPanel.Create(Self);
    pnlVerticalRuler := TRMPanel.Create(Self);
    pnlWorkSpace := TRMPanel.Create(Self);

    with Tab1 do
    begin
      Name := 'Tab1';
      Parent := Self;
      Align := alClient;
      HotTrack := True;
      MultiLine := False;
      TabOrder := 1;
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
    with Panel2 do
    begin
      Name := 'Panel2';
      Parent := Tab1;
      Align := alClient;
      BevelOuter := bvLowered;
      TabOrder := 0;
    end;
    with pnlHorizontalRuler do
    begin
      Name := 'pnlHorizontalRuler';
      Parent := Panel2;
      Height := 29;
      Align := alTop;
      BevelOuter := bvNone;
      TabOrder := 0;
      Caption := '';
    end;
    with pnlVerticalRuler do
    begin
      Name := 'pnlVerticalRuler';
      Parent := Panel2;
      Width := 29;
      Align := alLeft;
      BevelOuter := bvNone;
      TabOrder := 1;
      Caption := '';
    end;
    with ScrollBox1 do
    begin
      Name := 'ScrollBox1';
      Parent := Panel2;
      HorzScrollBar.Tracking := True;
      VertScrollBar.Tracking := True;
      Align := alClient;
      BorderStyle := bsNone;
      Color := clGray;
      ParentColor := False;
      TabOrder := 2;
    end;
    with pnlWorkSpace do
    begin
      Name := 'pnlWorkSpace';
      Parent := ScrollBox1;
      Caption := '';
      BevelOuter := bvNone;
      Color := clHighlightText;
      TabOrder := 1;
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
      Name := 'Dock971';
      OnRequestDock := OnDockRequestDockEvent;
    end;
    Dock972 := TRMDock.Create(Self);
    with Dock972 do
    begin
      Parent := Self;
      FixAlign := True;
      Position := dpLeft;
      Name := 'Dock972';
    end;
    Dock973 := TRMDock.Create(Self);
    with Dock973 do
    begin
      Parent := Self;
      FixAlign := True;
      Position := dpRight;
      Name := 'Dock973';
    end;
    Dock974 := TRMDock.Create(Self);
    with Dock974 do
    begin
      Parent := Self;
      FixAlign := True;
      Position := dpBottom;
      Name := 'Dock974';
      OnRequestDock := OnDockRequestDockEvent;
    end;
  end;

  //Create MenuBar
  procedure _CreateMenubar;
  begin
    MenuBar := TRMMenuBar.Create(Self);
    {$IFNDEF USE_TB2K}
    MenuBar.AutoHotkeys := maManual;
    {$ENDIF}

    barFile := TRMSubmenuItem.Create(Self);
    padFileNew := TRMmenuItem.Create(Self);
    padFileOpen := TRMmenuItem.Create(Self);
    padFileSave := TRMmenuItem.Create(Self);
    padFileSaveAs := TRMmenuItem.Create(Self);
    N40 := TRMSeparatorMenuItem.Create(Self);
    padVarList := TRMmenuItem.Create(Self);
    LoadDictionary1 := TRMmenuItem.Create(Self);
    MergeDictionary1 := TRMmenuItem.Create(Self);
    SaveAsDictionary1 := TRMmenuItem.Create(Self);
    N21 := TRMSeparatorMenuItem.Create(Self);
    padPageSetup := TRMmenuItem.Create(Self);
    padPreview := TRMmenuItem.Create(Self);
    padPrint := TRMmenuItem.Create(Self);
    N24 := TRMSeparatorMenuItem.Create(Self);
    padFileProperty := TRMmenuItem.Create(Self);
    N2 := TRMSeparatorMenuItem.Create(Self);
    itmFileFile1 := TRMmenuItem.Create(Self);
    itmFileFile2 := TRMmenuItem.Create(Self);
    itmFileFile3 := TRMmenuItem.Create(Self);
    itmFileFile4 := TRMmenuItem.Create(Self);
    itmFileFile5 := TRMmenuItem.Create(Self);
    itmFileFile6 := TRMmenuItem.Create(Self);
    itmFileFile7 := TRMmenuItem.Create(Self);
    itmFileFile8 := TRMmenuItem.Create(Self);
    itmFileFile9 := TRMmenuItem.Create(Self);
    N1 := TRMSeparatorMenuItem.Create(Self);
    padExit := TRMmenuItem.Create(Self);
    barEdit := TRMSubmenuItem.Create(Self);
    padUndo := TRMmenuItem.Create(Self);
    padRedo := TRMmenuItem.Create(Self);
    N47 := TRMSeparatorMenuItem.Create(Self);
    padCut := TRMmenuItem.Create(Self);
    padCopy := TRMmenuItem.Create(Self);
    padPaste := TRMmenuItem.Create(Self);
    padDelete := TRMmenuItem.Create(Self);
    padSelectAll := TRMmenuItem.Create(Self);
    padEdit := TRMmenuItem.Create(Self);
    N3 := TRMSeparatorMenuItem.Create(Self);
    padEditReplace := TRMmenuItem.Create(Self);
    N26 := TRMSeparatorMenuItem.Create(Self);
    padNewPage := TRMmenuItem.Create(Self);
    padNewForm := TRMmenuItem.Create(Self);
    padDeletePage := TRMmenuItem.Create(Self);
    N31 := TRMSeparatorMenuItem.Create(Self);
    padBringtoFront := TRMmenuItem.Create(Self);
    padSendtoBack := TRMmenuItem.Create(Self);
    N4 := TRMSeparatorMenuItem.Create(Self);
    itmEditLockControls := TRMmenuItem.Create(Self);

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

    barTools := TRMSubmenuItem.Create(Self);
    padSetToolbar := TRMSubmenuItem.Create(Self);
    Pan2 := TRMmenuItem.Create(Self);
    Pan3 := TRMmenuItem.Create(Self);
    Pan1 := TRMmenuItem.Create(Self);
    Pan4 := TRMmenuItem.Create(Self);
    Pan6 := TRMmenuItem.Create(Self);
    Pan8 := TRMmenuItem.Create(Self);
    Pan7 := TRMmenuItem.Create(Self);
    Pan5 := TRMmenuItem.Create(Self);
    Pan9 := TRMmenuItem.Create(Self);
    padAddTools := TRMmenuItem.Create(Self);
    padOptions := TRMmenuItem.Create(Self);
    barHelp := TRMSubmenuItem.Create(Self);
    padHelp := TRMmenuItem.Create(Self);
    N18 := TRMSeparatorMenuItem.Create(Self);
    padAbout := TRMmenuItem.Create(Self);

    barFile.AddToMenu(MenuBar);
    barEdit.AddToMenu(MenuBar);
    barSearch.AddToMenu(MenuBar);
    barTools.AddToMenu(MenuBar);
    barHelp.AddToMenu(MenuBar);

    padFileNew.AddToMenu(barFile);
    padFileOpen.AddToMenu(barFile);
    padFileSave.AddToMenu(barFile);
    padFileSaveAs.AddToMenu(barFile);
    N40.AddToMenu(barFile);
    padVarList.AddToMenu(barFile);
    LoadDictionary1.AddToMenu(barFile);
    MergeDictionary1.AddToMenu(barFile);
    SaveAsDictionary1.AddToMenu(barFile);
    N21.AddToMenu(barFile);
    padPageSetup.AddToMenu(barFile);
    padPreview.AddToMenu(barFile);
    padPrint.AddToMenu(barFile);
    N24.AddToMenu(barFile);
    padFileProperty.AddToMenu(barFile);
    N2.AddToMenu(barFile);
    itmFileFile1.AddToMenu(barFile);
    itmFileFile2.AddToMenu(barFile);
    itmFileFile3.AddToMenu(barFile);
    itmFileFile4.AddToMenu(barFile);
    itmFileFile5.AddToMenu(barFile);
    itmFileFile6.AddToMenu(barFile);
    itmFileFile7.AddToMenu(barFile);
    itmFileFile8.AddToMenu(barFile);
    itmFileFile9.AddToMenu(barFile);
    N1.AddToMenu(barFile);
    padExit.AddToMenu(barFile);

    padUndo.AddToMenu(barEdit);
    padRedo.AddToMenu(barEdit);
    N47.AddToMenu(barEdit);
    padCut.AddToMenu(barEdit);
    padCopy.AddToMenu(barEdit);
    padPaste.AddToMenu(barEdit);
    padDelete.AddToMenu(barEdit);
    padSelectAll.AddToMenu(barEdit);
    padEdit.AddToMenu(barEdit);
    N3.AddToMenu(barEdit);
    padEditReplace.AddToMenu(barEdit);
    N26.AddToMenu(barEdit);
    padNewPage.AddToMenu(barEdit);
    padNewForm.AddToMenu(barEdit);
    padDeletePage.AddToMenu(barEdit);
    N31.AddToMenu(barEdit);
    padBringtoFront.AddToMenu(barEdit);
    padSendtoBack.AddToMenu(barEdit);
    N4.AddToMenu(barEdit);
    itmEditLockControls.AddToMenu(barEdit);

    padSetToolbar.AddToMenu(barTools);
    Pan2.AddToMenu(padSetToolbar);
    Pan3.AddToMenu(padSetToolbar);
    Pan1.AddToMenu(padSetToolbar);
    Pan4.AddToMenu(padSetToolbar);
    Pan6.AddToMenu(padSetToolbar);
    Pan8.AddToMenu(padSetToolbar);
    Pan7.AddToMenu(padSetToolbar);
    Pan5.AddToMenu(padSetToolbar);
    Pan9.AddToMenu(padSetToolbar);
    padAddTools.AddToMenu(barTools);
    padOptions.AddToMenu(barTools);

    padHelp.AddToMenu(barHelp);
    N18.AddToMenu(barHelp);
    padAbout.AddToMenu(barHelp);

    with MenuBar do
    begin
      Name := 'MenuBar';
      Parent := self;
      Caption := RMLoadStr(rmRes + 251);
      MenuBar := True;
      Dockedto := Dock971;
    end;

    with barFile do
    begin
      Caption := '&File';
    end;
    with padFileNew do
    begin
      ImageIndex := 0;
      Images := ImageListStand;
      Name := 'padFileNew';
      Caption := '&New...';
      ShortCut := 16462;
      OnClick := padFileNewClick;
    end;
    with padFileOpen do
    begin
      ImageIndex := 1;
      Images := ImageListStand;
      Name := 'padFileOpen';
      Caption := '&Open...';
      ShortCut := 16463;
      OnClick := btnFileOpenClick;
    end;
    with padFileSave do
    begin
      ImageIndex := 2;
      Images := ImageListStand;
      Caption := 'Save';
      ShortCut := 16467;
      OnClick := btnFileSaveClick;
    end;
    with padFileSaveAs do
    begin
      Caption := 'Save as...';
      OnClick := padFileSaveAsClick;
    end;
    with padVarList do
    begin
      Caption := 'Dictionary...';
      OnClick := padVarListClick;
    end;
    with LoadDictionary1 do
    begin
      Caption := 'Import Dictionary...';
      OnClick := LoadDictionary1Click;
    end;
    with MergeDictionary1 do
    begin
      Caption := 'Merge Dictionary...';
      OnClick := MergeDictionary1Click;
    end;
    with SaveAsDictionary1 do
    begin
      Caption := 'Export Dictionary...';
      OnClick := SaveAsDictionary1Click;
    end;
    with padPageSetup do
    begin
      ImageIndex := 16;
      Images := ImageListStand;
      Caption := 'Page Options...';
      OnClick := btnPageSetupClick;
    end;
    with padPreview do
    begin
      ImageIndex := 4;
      Images := ImageListStand;
      Caption := 'Print Preview...';
      ShortCut := 16464;
      OnClick := btnPreviewClick;
    end;
    with padPrint do
    begin
      ImageIndex := 3;
      Images := ImageListStand;
      Caption := '&Print';
      OnClick := padPrintClick;
    end;
    with padFileProperty do
    begin
      Caption := 'Property...';
      OnClick := padFilePropertyClick;
    end;
    with itmFileFile1 do
    begin
      Tag := 1;
      OnClick := itmFileFile9Click;
    end;
    with itmFileFile2 do
    begin
      Tag := 2;
      OnClick := itmFileFile9Click;
    end;
    with itmFileFile3 do
    begin
      Tag := 3;
      OnClick := itmFileFile9Click;
    end;
    with itmFileFile4 do
    begin
      Tag := 4;
      OnClick := itmFileFile9Click;
    end;
    with itmFileFile5 do
    begin
      Tag := 5;
      OnClick := itmFileFile9Click;
    end;
    with itmFileFile6 do
    begin
      Tag := 6;
      OnClick := itmFileFile9Click;
    end;
    with itmFileFile7 do
    begin
      Tag := 7;
      OnClick := itmFileFile9Click;
    end;
    with itmFileFile8 do
    begin
      Tag := 8;
      OnClick := itmFileFile9Click;
    end;
    with itmFileFile9 do
    begin
      Tag := 9;
      OnClick := itmFileFile9Click;
    end;
    with padExit do
    begin
      ImageIndex := 20;
      Images := ImageListStand;
      Caption := '&Exit';
      OnClick := btnExitClick;
    end;
    with barEdit do
    begin
      Caption := '&Edit';
      OnClick := barFileClick;
    end;
    with padUndo do
    begin
      ImageIndex := 8;
      Images := ImageListStand;
      Caption := 'Undo';
      ShortCut := Menus.ShortCut(Ord('Z'), [ssCtrl]);
      OnClick := btnUndoClick;
    end;
    with padRedo do
    begin
      ImageIndex := 9;
      Images := ImageListStand;
      Caption := 'Redo';
      ShortCut := Menus.ShortCut(Ord('Z'), [ssShift, ssCtrl]);
      OnClick := btnRedoClick;
    end;
    with padCut do
    begin
      ImageIndex := 5;
      Images := ImageListStand;
      Caption := 'Cut';
      ShortCut := 16472;
      OnClick := btnCutClick;
    end;
    with padCopy do
    begin
      ImageIndex := 6;
      Images := ImageListStand;
      Caption := 'Copy';
      ShortCut := 16451;
      OnClick := btnCopyClick;
    end;
    with padPaste do
    begin
      ImageIndex := 7;
      Images := ImageListStand;
      Caption := 'Paste';
      ShortCut := 16470;
      OnClick := btnPasteClick;
    end;
    with padDelete do
    begin
      ImageIndex := 22;
      Images := ImageListStand;
      Caption := 'Delete';
      ShortCut := 16430;
      OnClick := padDeleteClick;
    end;
    with padSelectAll do
    begin
      ImageIndex := 12;
      Images := ImageListStand;
      Caption := 'Select all';
      ShortCut := 16449;
      OnClick := btnSelectAllClick;
    end;
    with padEdit do
    begin
      ImageIndex := 23;
      Images := ImageListStand;
      Caption := 'Edit...';
      OnClick := padEditClick;
    end;
    with padEditReplace do
    begin
      ImageIndex := 24;
      Images := ImageListStand;
      Caption := 'Find && Replace...';
      OnClick := padEditReplaceClick;
    end;
    with padNewPage do
    begin
      ImageIndex := 13;
      Images := ImageListStand;
      Caption := 'Add Page';
      OnClick := btnAddPageClick;
    end;
    with padNewForm do
    begin
      ImageIndex := 14;
      Images := ImageListStand;
      Caption := 'Add Dialog';
      OnClick := btnAddFormClick;
    end;
    with padDeletePage do
    begin
      ImageIndex := 15;
      Images := ImageListStand;
      Caption := 'Delete Page';
      OnClick := btnDeletePageClick;
    end;
    with padBringtoFront do
    begin
      ImageIndex := 10;
      Images := ImageListStand;
      Caption := 'Bring to Front';
      OnClick := btnBringtoFrontClick;
    end;
    with padSendtoBack do
    begin
      ImageIndex := 11;
      Images := ImageListStand;
      Caption := 'Send to back';
      OnClick := btnSendtoBackClick;
    end;
    with itmEditLockControls do
    begin
      ImageIndex := 25;
      Images := ImageListStand;
      Caption := 'Lock Controls';
      OnClick := itmEditLockControlsClick;
    end;
    with barTools do
    begin
      Caption := '&Tools';
    end;
    with padSetToolbar do
    begin
      Caption := 'Tools bar';
      OnClick := padSetToolbarClick;
    end;
    with Pan2 do
    begin
      Tag := 1;
      Caption := 'Standard';
      OnClick := Pan2Click;
    end;
    with Pan3 do
    begin
      Tag := 2;
      Caption := 'Text';
      OnClick := Pan2Click;
    end;
    with Pan1 do
    begin
      Caption := 'Border';
      OnClick := Pan2Click;
    end;
    with Pan4 do
    begin
      Tag := 3;
      Caption := 'Objects';
      OnClick := Pan2Click;
    end;
    with Pan6 do
    begin
      Tag := 4;
      Caption := 'Alignment palette';
      OnClick := Pan2Click;
    end;
    with Pan8 do
    begin
      Tag := 7;
      Caption := 'Size palette';
      OnClick := Pan2Click;
    end;
    with Pan7 do
    begin
      Tag := 6;
      Caption := 'Extra tools';
      OnClick := Pan2Click;
    end;
    with Pan5 do
    begin
      Tag := 5;
      Caption := 'Object Inspector';
      ShortCut := 122;
      OnClick := Pan5Click;
    end;
    with Pan9 do
    begin
      Tag := 8;
      Caption := 'Insert DB fields';
      OnClick := Pan2Click;
    end;
    with padAddTools do
    begin
      Caption := 'Extra tools';
      Enabled := False;
    end;
    with padOptions do
    begin
      Caption := 'Options...';
      OnClick := padOptionsClick;
    end;
    with barHelp do
    begin
      Caption := '&Help';
    end;
    with padHelp do
    begin
      ImageIndex := 26;
      Images := ImageListStand;
      Caption := 'Help contents...';
      ShortCut := 112;
    end;
    with padAbout do
    begin
      Caption := '&About...';
      OnClick := padAboutClick;
    end;
  end;

  // Pop Menu
  procedure _CreatePopMenu;
  begin
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
      ImageIndex := 5;
      Images := ImageListStand;
      Caption := 'Cut';
      ShortCut := 16472;
      OnClick := btnCutClick;
    end;

    padpopCopy := TRMMenuItem.Create(Self);
    with padpopCopy do
    begin
      AddToMenu(Popup1);
      ImageIndex := 6;
      Images := ImageListStand;
      Caption := 'Copy';
      ShortCut := 16451;
      OnClick := btnCopyClick;
    end;

    padpopPaste := TRMMenuItem.Create(Self);
    with padpopPaste do
    begin
      AddToMenu(Popup1);
      ImageIndex := 7;
      Images := ImageListStand;
      Caption := 'Paste';
      ShortCut := 16470;
      OnClick := btnPasteClick;
    end;

    padpopDelete := TRMMenuItem.Create(Self);
    with padpopDelete do
    begin
      AddToMenu(Popup1);
      ImageIndex := 22;
      Images := ImageListStand;
      Caption := 'Delete';
      ShortCut := 16430;
      OnClick := padDeleteClick;
    end;

    padpopSelectAll := TRMMenuItem.Create(Self);
    with padpopSelectAll do
    begin
      AddToMenu(Popup1);
      ImageIndex := 12;
      Images := ImageListStand;
      Caption := 'Select all';
      ShortCut := 16449;
      OnClick := btnSelectAllClick;
    end;

    N8 := TRMSeparatorMenuItem.Create(Self);
    N8.AddToMenu(Popup1);

    padpopFrame := TRMMenuItem.Create(Self);
    with padpopFrame do
    begin
      AddToMenu(Popup1);
      Caption := 'Frame...';
      OnClick := padpopFrameClick;
    end;

    padpopEdit := TRMMenuItem.Create(Self);
    with padpopEdit do
    begin
      AddToMenu(Popup1);
      Caption := 'Edit...';
      OnClick := padpopEditClick;
    end;

    padpopClearContents := TRMMenuItem.Create(Self);
    with padpopClearContents do
    begin
      Caption := 'Clear Contents';
      OnClick := padpopClearContentsClick;
      AddToMenu(Popup1);
    end;
  end;

  // Edit Toolbar
  procedure _CreateToolbarEdit;
  var
    i: Integer;
  begin
    ToolbarEdit := TRMToolbar.Create(Self);
    ToolbarEdit.BeginUpdate;
    with ToolbarEdit do
    begin
      Parent := Self;
      Dockedto := Dock971;
      DockRow := 1;
      DockPos := 0;
      Name := 'ToolbarEdit';
    end;

    FcmbFont := TRMFontComboBox.Create(Self);
    with FcmbFont do
    begin
      Parent := ToolbarEdit;
      Height := 21;
      Width := 120;
      Tag := TAG_SetFontName;
      //      Device := rmfdBoth;
      TrueTypeOnly := True;
      OnChange := DoClick;
    end;

    FcmbFontSize := TRMComboBox97 {TComboBox}.Create(Self);
    with FcmbFontSize do
    begin
      Parent := ToolbarEdit;
      Height := 21;
      Width := 50;
      Tag := TAG_SetFontSize;
      DropDownCount := 12;
      if RMIsChineseGB then
        liOffset := 0
      else
        liOffset := 13;
      for i := Low(RMDefaultFontSizeStr) + liOffset to High(RMDefaultFontSizeStr) do
        Items.Add(RMDefaultFontSizeStr[i]);
      OnChange := DoClick;
    end;
    ToolbarSep9711 := TRMToolbarSep.Create(Self);
    with ToolbarSep9711 do
    begin
      AddTo := ToolbarEdit;
    end;

    btnFontBold := TRMToolbarButton.Create(Self);
    with btnFontBold do
    begin
      Tag := TAG_FontBold;
      AllowAllUp := True;
      GroupIndex := 1;
      ImageIndex := 0;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    btnFontItalic := TRMToolbarButton.Create(Self);
    with btnFontItalic do
    begin
      Tag := TAG_FontItalic;
      AllowAllUp := True;
      GroupIndex := 2;
      ImageIndex := 1;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    btnFontUnderline := TRMToolbarButton.Create(Self);
    with btnFontUnderline do
    begin
      Tag := TAG_FontUnderline;
      AllowAllUp := True;
      GroupIndex := 3;
      ImageIndex := 2;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    ToolbarSep9713 := TRMToolbarSep.Create(Self);
    with ToolbarSep9713 do
    begin
      AddTo := ToolbarEdit;
    end;

    FBtnFontColor := TRMColorPickerButton.Create(Self);
    with FBtnFontColor do
    begin
      Parent := ToolbarEdit;
      Tag := TAG_FontColor;
      ParentShowHint := True;
      ColorType := rmptFont;
      OnColorChange := DoClick;
    end;
    ToolbarSep9718 := TRMToolbarSep.Create(Self);
    with ToolbarSep9718 do
    begin
      AddTo := ToolbarEdit;
    end;

    HlB1 := TRMToolbarButton.Create(Self);
    with Hlb1 do
    begin
      ImageIndex := 3;
      Images := ImageListFont;
      OnClick := HlB1Click;
      AddTo := ToolbarEdit;
    end;
    ToolbarSep9714 := TRMToolbarSep.Create(Self);
    with ToolbarSep9714 do
    begin
      AddTo := ToolbarEdit;
    end;

    btnTextAlignLeft := TRMToolbarButton.Create(Self);
    with btnTextAlignLeft do
    begin
      Tag := TAG_HAlignLeft;
      GroupIndex := 4;
      ImageIndex := 4;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    btnTextAlignCenter := TRMToolbarButton.Create(Self);
    with btnTextAlignCenter do
    begin
      Tag := TAG_HAlignCenter;
      GroupIndex := 4;
      ImageIndex := 5;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    btnTextAlignRight := TRMToolbarButton.Create(Self);
    with btnTextAlignRight do
    begin
      Tag := TAG_HAlignRight;
      GroupIndex := 4;
      ImageIndex := 6;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    btnTextAlignH := TRMToolbarButton.Create(Self);
    with btnTextAlignH do
    begin
      Tag := TAG_HAlignEuqal;
      GroupIndex := 4;
      ImageIndex := 7;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    ToolbarSep9715 := TRMToolbarSep.Create(Self);
    with ToolbarSep9715 do
    begin
      AddTo := ToolbarEdit;
    end;

    btnTextAlignTop := TRMToolbarButton.Create(Self);
    with btnTextAlignTop do
    begin
      Tag := TAG_VAlignTop;
      GroupIndex := 6;
      ImageIndex := 8;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    btnTextAlignVCenter := TRMToolbarButton.Create(Self);
    with btnTextAlignVCenter do
    begin
      Tag := TAG_VAlignCenter;
      GroupIndex := 6;
      ImageIndex := 9;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    btnTextAlignBottom := TRMToolbarButton.Create(Self);
    with btnTextAlignBottom do
    begin
      Tag := TAG_VAlignBottom;
      GroupIndex := 6;
      ImageIndex := 10;
      Images := ImageListFont;
      OnClick := DoClick;
      AddTo := ToolbarEdit;
    end;
    ToolbarSep9716 := TRMToolbarSep.Create(Self);
    with ToolbarSep9716 do
    begin
      AddTo := ToolbarEdit;
    end;

    ToolbarEdit.EndUpdate;
  end;

  // Addin Tools Toolbar
  procedure _CreateToolbarAddinTools;
  begin
    ToolBarAddinTools := TRMToolbar.Create(Self);
    with ToolbarAddinTools do
    begin
      Parent := Self;
      Dockedto := Dock971;
      DockRow := 1;
      DockPos := 10; //ToolbarEdit.DockPos + ToolbarEdit.Width;
      Name := 'ToolBarAddinTools';
    end;

    btnInsertFields := TRMToolbarButton.Create(Self);
    with btnInsertFields do
    begin
      AllowAllUp := True;
      Hint := RMLoadStr(rmRes + 110);
      GroupIndex := 1;
      ImageIndex := 0;
      Images := ImageListAddinTools;
      OnClick := InsertFieldsClick;
      AddTo := ToolBarAddinTools;
    end;
  end;

begin
  FOldFactor := -1;
  FFactor := 100;
  FCurPage := -1;
  FBusy := True;
  FGridAlign := True;
  FShowGrid := True;
  FGridSize := 4;
  FEditAfterInsert := False;
  FShapeMode := smFrame;
  RM_Class.RMShowBandTitles := True;
  UseTableName := True;
  AutoChangeBandPos := False;

  FOpenFiles := TStringList.Create;

  ScrollBox1 := TRMScrollBox.Create(Self);
  with ScrollBox1 do
  begin
    Parent := Self;
    //    OnKeyDown := Self.OnKeyDown;
  end;

  _CreateTabPanel;
  _CreateDock;
  {$IFNDEF USE_TB2K}
  Dock971.BeginUpdate;
  {$ENDIF}
  _CreateMenubar;
  _CreatePopMenu;
  ToolbarStandard := TRMToolbarStandard.CreateAndDock(Self, Dock971);
  _CreateToolbarEdit;
  _CreateToolBarAddinTools;
  ToolbarBorder := TRMToolbarBorder.CreateAndDock(Self, Dock971);
  //  ToolbarBorder.Parent := self;
  ToolbarAlign := TRMToolbarAlign.CreateAndDock(Self, Dock971);
  ToolbarSize := TRMToolbarSize.CreateAndDock(Self, Dock971);
  ToolbarModifyPrepared := TRMToolbarModifyPrepared.CreateAndDock(Self, Dock971);
  {$IFNDEF USE_TB2K}
  Dock971.EndUpdate;
  {$ENDIF}

  ToolBarModifyPrepared.Visible := IsPreviewDesign and ShowModifyToolbar;

  ObjectPopupMenu := Popup1;
  FWorkSpace := TRMWorkSpace.Create(pnlWorkSpace);
  FWorkSpace.DesignerForm := Self;
  FWorkSpace.PopupMenu := Popup1;
  FWorkSpace.ShowHint := True;

  FHRuler := TRMDesignerRuler.Create(pnlHorizontalRuler);
  FHRuler.Parent := pnlHorizontalRuler;
  FHRuler.Units := RMUnits;
  FHRuler.Orientation := roHorizontal;
  FHRuler.SetBounds(pnlVerticalRuler.Width, 0, pnlHorizontalRuler.Width, pnlHorizontalRuler.Height);

  FVRuler := TRMDesignerRuler.Create(pnlVerticalRuler);
  FVRuler.Parent := pnlVerticalRuler;
  FVRuler.Units := RMUnits;
  FVRuler.Orientation := roVertical;
  FVRuler.SetBounds(0, 0, pnlVerticalRuler.Width, pnlVerticalRuler.Height);

  {$IFDEF Delphi4}
  OnMouseWheelUp := OnFormMouseWheelUpEvent;
  OnMouseWheelDown := OnFormMouseWheelDownEvent;
  {$ENDIF}
  {$IFDEF Delphi5}
  {$IFNDEF USE_TB2K}
  MenuBar.AutoHotkeys := maManual;
  MenuBar.AutoLineReduction := maManual;
  {$ENDIF}
  {$ENDIF}

  Localize;
end;

procedure TRMDesignerForm.FormDestroy(Sender: TObject);
begin
  ClearUndoBuffer;
  ClearRedoBuffer;
  if FFindReplaceForm <> nil then
  begin
    FFindReplaceForm.Free;
    FFindReplaceForm := nil;
  end;

  if FInspForm <> nil then
  begin
    FInspForm.RestorePos;
    SaveIni;
  end;

  FreeAndNil(FInspForm);
  FreeAndNil(FFieldForm);
  if FWorkSpace <> nil then
  begin
    FWorkSpace.Parent := nil;
    FreeAndNil(FWorkSpace.PageForm);
  end;
  FreeAndNil(FWorkSpace);

  FreeAndNil(FOpenFiles);
end;

procedure TRMDesignerForm.FormShow(Sender: TObject);

  procedure _RestoreOpenFiles;
  var
    Ini: TRegIniFile;
    i: Integer;
    str: string;
    Nm: string;
  begin
    Ini := TRegIniFile.Create(RMRegRootKey + '\RMReport');
    Nm := rsForm + Name;
    AutoOpenLastFile := Ini.ReadBool(Nm, rsAutoOpenLastFile, False);
    AutoChangeBandPos := Ini.ReadBool(Nm, rsAutoChangeBandPos, False);
    AutoChangeBandPos := False;
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
  Tab1.Tabs.Clear;
  if not IsPreviewDesign then
    Tab1.AddTab(RMLoadStr(rmRes + 253));

  Screen.Cursors[crPencil] := LoadCursor(hInstance, 'RM_PENCIL');
  Panel7.Hide;

  FInspBusy := True;
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
    OnCloseEvent := OnFieldsDialogCloseEvnet;
  end;

  ClearUndoBuffer;
  ClearRedoBuffer;
  LoadIni;
  Report.DocMode := rmdmDesigning;

  if RMIsChineseGB then
    RM_LastFontName := '宋体'
  else
    RM_LastFontName := 'Arial';
  RM_LastFontSize := 10;

  _RestoreOpenFiles;
  if (Report.Pages.Count = 0) and AutoOpenLastFile and (FOpenFiles.Count > 0) then
    Report.LoadFromFile(FOpenFiles[0]);
  if Report.Pages.Count = 0 then
  begin
    CreateDefaultPage;
    if (FDesignerComp <> nil) and (FDesignerComp.DefaultDictionaryFile <> '') and
      FileExists(FDesignerComp.DefaultDictionaryFile) then
      Report.Dictionary.LoadFromFile(FDesignerComp.DefaultDictionaryFile);
  end;

  CurPage := 0; // this cause page sizing
  CurDocName := Report.FileName;
  Script := Report.Script;

  padSetToolbarClick(nil);
  UnselectAll;
  FWorkSpace.Init;
  EnableControls;
  ToolbarComponent.btnNoSelect.Down := True;
  FBtnFontColor.CurrentColor := 0;
  Modified := False;
  FInspBusy := False;
  FBusy := False;
  ShowPosition;
  FormResize(nil);
  ScrollBox1.OnResize := ScrollBox1Resize;

  padPreview.Enabled := ToolbarStandard.btnPreview.Enabled;
  padPrint.Enabled := ToolbarStandard.btnPreview.Enabled;
  ToolbarStandard.btnPrint.Enabled := ToolbarStandard.btnPreview.Enabled;

  SetObjectsID;
  //  Edit1.Text := IntToStr(EndPageNo + 1);
  //  btnAutoSave.Down := AutoSave;

  ToolbarPopMenu := TRMPopupMenu.Create(self);
  ToolbarPopMenu.AutoHotkeys := maManual;
  with ToolbarPopMenu.Items do
  begin
    Clear;
    ToolbarPopStandard := RMNewItem(Pan2.Caption, Pan2.ShortCut, Pan2.Checked,
      Pan2.Enabled, Pan2.OnClick, 0, 'PPan2', Pan2.Tag);
    Add(ToolBarPopStandard);
    ToolBarPopEdit := RMNewItem(Pan3.Caption, Pan3.ShortCut, Pan3.Checked,
      Pan3.Enabled, Pan3.OnClick, 0, 'PPan3', Pan3.Tag);
    Add(ToolBarPopEdit);
    ToolBarPopBorder := RMNewItem(Pan1.Caption, Pan1.ShortCut, Pan1.Checked,
      Pan1.Enabled, Pan1.OnClick, 0, 'PPan1', Pan1.Tag);
    Add(ToolBarPopBorder);
    ToolBarPopComponent := RMNewItem(Pan4.Caption, Pan4.ShortCut, Pan4.Checked,
      Pan4.Enabled, Pan4.OnClick, 0, 'PPan4', Pan4.Tag);
    Add(ToolBarPopComponent);
    ToolBarPopAlign := RMNewItem(Pan6.Caption, Pan6.ShortCut, Pan6.Checked,
      Pan6.Enabled, Pan6.OnClick, 0, 'PPan6', Pan6.Tag);
    Add(ToolBarPopAlign);
    ToolbarPopSize := RMNewItem(Pan8.Caption, Pan8.ShortCut, Pan8.Checked,
      Pan8.Enabled, Pan8.OnClick, 0, 'PPan8', Pan8.Tag);
    Add(ToolbarPopSize);
    ToolBarPopAddinTools := RMNewItem(Pan7.Caption, Pan7.ShortCut, Pan7.Checked,
      Pan7.Enabled, Pan7.OnClick, 0, 'PPan7', Pan7.Tag);
    Add(ToolBarPopAddinTools);
    ToolBarPopInsp := RMNewItem(Pan5.Caption, Pan5.ShortCut, Pan5.Checked,
      Pan5.Enabled, Pan5.OnClick, 0, 'PPan5', Pan5.Tag);
    Add(ToolBarPopInsp);
    ToolBarPopInsDBField := RMNewItem(Pan9.Caption, Pan9.ShortCut, Pan9.Checked,
      Pan9.Enabled, Pan9.OnClick, 0, 'PPan9', Pan9.Tag);
    Add(ToolBarPopInsDBField);
    ToolbarPopModifyPrepared := RMNewItem('预览导航栏', 0, IsPreviewDesign and ShowModifyToolbar,
      IsPreviewDesign and ShowModifyToolbar, Pan1.OnClick, 0, 'PPan10', 11);
    Add(ToolbarPopModifyPrepared);
  end;
  ToolbarPopMenu.OnPopup := ToolBarPopMenuPopup;
  ToolbarStandard.PopupMenu := ToolbarPopMenu;
  ToolbarEdit.PopupMenu := ToolbarPopMenu;
  ToolbarBorder.PopupMenu := ToolbarPopMenu;
  ToolbarAlign.PopupMenu := ToolbarPopMenu;
  ToolBarAddinTools.PopupMenu := ToolbarPopMenu;
  ToolbarComponent.PopupMenu := ToolbarPopMenu;
  ToolbarSize.PopupMenu := ToolbarPopMenu;
  ToolbarModifyPrepared.PopupMenu := ToolbarPopMenu;
  FInspForm.PopupMenu := ToolbarPopMenu;
  FFieldForm.PopupMenu := ToolbarPopMenu;

  if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnShow) then
    FDesignerComp.OnShow(Self);

  if FFieldForm.Visible then
    FFieldForm.RefreshData;
end;

procedure TRMDesignerForm.FormResize(Sender: TObject);
begin
  if FBusy or (csDestroying in ComponentState) then Exit;
  with ScrollBox1 do
  begin
    HorzScrollBar.Position := 0;
    VertScrollBar.Position := 0;
  end;
  FWorkSpace.SetPage;
  Panel7.Top := StatusBar1.Top + 3;
  Panel7.Show;
end;

procedure TRMDesignerForm.SetCurPage(Value: Integer);
var
  liOldPage: Integer;
  liSaveModified: Boolean;
  t: TRMView;
  lWidth, lHeight: Integer;
begin
  FCodeMemo.Visible := False;
  liOldPage := FCurPage;
  FCurPage := Value;
  Page := Report.Pages[CurPage];
  if Page.Name = '' then Page.CreateName;
  Report.CurrentPage := Page;
  ToolbarComponent.CreateObjects;

  if (Page is TRMDialogPage) and (FWorkSpace.PageForm = nil) then
  begin
    FWorkSpace.PageForm := TRMDialogForm.CreateNew(nil, 0);
    FWorkSpace.PageForm.SetPageFormProp;

    FWorkSpace.Color := clBtnFace;
    FWorkSpace.Parent := FWorkSpace.PageForm;
    FWorkSpace.PageForm.Icon := Icon;
    FOldFactor := Factor;
    Factor := 100;
  end
  else if (Page is TRMReportPage) and (FWorkSpace.PageForm <> nil) then
  begin
    if FOldFactor > 0 then
      Factor := FOldFactor;
    FOldFactor := Factor;
    FWorkSpace.Parent := pnlWorkSpace;
    FWorkSpace.Color := clWhite;

    FreeAndNil(FWorkSpace.PageForm);
  end;

  if Page is TRMReportPage then
  begin
    t := IsSubreport(CurPage);
    if t <> nil then
    begin
      case TRMSubReportView(t).SubReportType of
        rmstFixed:
          begin
            TRMReportPage(Page).spMarginLeft := 0;
            TRMReportPage(Page).spMarginTop := 0;
            TRMReportPage(Page).spMarginRight := 0;
            TRMReportPage(Page).spMarginBottom := 0;
            TRMReportPage(Page).PrinterInfo.PageWidth := t.spWidth;
            TRMReportPage(Page).PrinterInfo.PageHeight := t.spHeight;
          end;
        rmstChild:
          begin
            TRMReportPage(Page).spMarginLeft := TRMReportPage(t.ParentPage).spMarginLeft;
            TRMReportPage(Page).spMarginTop := TRMReportPage(t.ParentPage).spMarginTop;
            TRMReportPage(Page).spMarginRight := TRMReportPage(t.ParentPage).spMarginRight;
            TRMReportPage(Page).spMarginBottom := TRMReportPage(t.ParentPage).spMarginBottom;
            TRMReportPage(Page).PrinterInfo := TRMReportPage(t.ParentPage).PrinterInfo;
          end;
      end;
    end;
  end;

  ToolbarStandard.cmbScale.Enabled := (Page is TRMReportPage);
  pnlHorizontalRuler.Visible := (Page is TRMReportPage);
  pnlVerticalRuler.Visible := pnlHorizontalRuler.Visible;
  if (Page is TRMDialogPage) and (FWorkSpace.PageForm <> nil) then
  begin
    liSaveModified := Modified;
    FWorkSpace.PageForm.SetPageFormProp;
    FWorkSpace.PageForm.Show;
    Modified := liSaveModified;
  end;

  ScrollBox1.VertScrollBar.Position := 0;
  ScrollBox1.HorzScrollBar.Position := 0;
  if Page is TRMDialogPage then
  begin
    pnlWorkSpace.SetBounds(0, 0, 0, 0);
  end
  else
  begin
    ScrollBox1.SetFocus;

    lWidth := Round(TRMReportPage(Page).PrinterInfo.PageWidth * Factor / 100);
    lHeight := Round(TRMReportPage(Page).PrinterInfo.PageHeight * Factor / 100);
    if FUnlimitedHeight then
      lHeight := lHeight * 3;

    pnlWorkSpace.Color := WorkSpaceColor;
    pnlWorkSpace.SetBounds(0, 0, lWidth, lHeight);
    //Color := FDesignerForm.WorkSpaceColor;
    ScrollBox1.VertScrollBar.Range := pnlWorkSpace.Height + 10;
    ScrollBox1.HorzScrollBar.Range := pnlWorkSpace.Width + 10;
    FHRuler.Width := lWidth + Screen.PixelsPerInch + 20;
    FVRuler.Height := lHeight + Screen.PixelsPerInch + 20;
    FHRuler.ScrollOffset := 0;
    FVRuler.ScrollOffset := 0;
  end;

  FWorkSpace.SetPage;
  SetPageTabs;
  Tab1.TabIndex := FCurPage + 1;
  if (liOldPage <> FCurPage) and AutoChangeBandPos and Page.UpdateBandsPageRect then
    Modified := True;
  ResetSelection;
  SendBandsToDown;
  FWorkSpace.Repaint;
end;

procedure TRMDesignerForm.BeforeChange;
begin
  AddUndoAction(acEdit);
  Modified := True;
end;

procedure TRMDesignerForm.AfterChange;
begin
  FWorkSpace.DrawPage(dmSelection);
  FWorkSpace.Draw(TopSelected, 0);
  SelectionChanged(True);
end;

function TRMDesignerForm.InsertDBField: string;
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

function TRMDesignerForm.InsertExpression: string;
var
  expr: string;
begin
  Result := '';
  expr := '';
  if RM_EditorExpr.RMGetExpression('', expr, nil, False) then
  begin
    Result := expr;
    if Result <> '' then
    begin
      if not ((Result[1] = '[') and (Result[Length(Result)] = ']') and
        (Pos('[', Copy(Result, 2, 999999)) = 0)) then
        Result := '[' + Result + ']';
    end;
  end;
end;

procedure TRMDesignerForm.MemoViewEditor(t: TRMView);
begin
  ShowMemoEditor(t);
end;

procedure TRMDesignerForm.PictureViewEditor(t: TRMView);
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

procedure TRMDesignerForm.RMFontEditor(Sender: TObject);
var
  t: TRMView;
  i: Integer;
  liFontDialog: TFontDialog;
begin
  t := TRMMemoView(Objects[TopSelected]);
  if not (t is TRMCustomMemoView) then Exit;
  liFontDialog := TFontDialog.Create(nil);
  try
    liFontDialog.Font.Assign(TRMCustomMemoView(t).Font);
    if liFontDialog.Execute then
    begin
      RMDesigner.BeforeChange;
      for i := 0 to Objects.Count - 1 do
      begin
        t := Objects[i];
        if t.Selected and (t is TRMCustomMemoView) then
          TRMCustomMemoView(t).Font.Assign(liFontDialog.Font);
      end;
      RMDesigner.AfterChange;
    end;
  finally
    liFontDialog.Free;
  end;
end;

procedure TRMDesignerForm.RMDisplayFormatEditor(Sender: TObject);
var
  t: TRMView;
  tmp: TRMDisplayFormatForm;
begin
  t := Objects[TopSelected];
  if not (t is TRMCustomMemoView) then Exit;

  tmp := TRMDisplayFormatForm.Create(nil);
  try
    tmp.ShowEditor(t);
  finally
    tmp.Free;
  end;
end;

procedure TRMDesignerForm.RMCalcMemoEditor(Sender: TObject);
var
  tmp: TRMCalcMemoEditorForm;
begin
  tmp := TRMCalcMemoEditorForm.Create(nil);
  try
    tmp.ShowEditor(Objects[TopSelected]);
  finally
    tmp.Free;
  end;
end;

procedure TRMDesignerForm.SelectAll;
var
  i: Integer;
  t, liBand: TRMView;
begin
  if IsBandsSelect(liBand) then //是否选择当前Band中的所有对象
  begin
    for i := 0 to Objects.Count - 1 do
    begin
      t := TRMView(Objects[i]);
      if (not t.IsBand) and (t.spTop_Designer >= liBand.spTop_Designer) and (t.spHeight_Designer <= liBand.spHeight_Designer) then
      begin
        t.Selected := True;
        Inc(SelNum);
      end;
    end;
  end
  else
  begin
    SelNum := 0;
    for i := 0 to Objects.Count - 1 do
    begin
      TRMView(Objects[i]).Selected := True;
      Inc(SelNum);
    end;
  end;
end;

procedure TRMDesignerForm.UnselectAll;
var
  i: Integer;
begin
  SelNum := 0;
  for i := 0 to Objects.Count - 1 do
    TRMView(Objects[i]).Selected := False;
end;

procedure TRMDesignerForm.ShowPosition;
begin
  if Tab1.TabIndex = 0 then
  begin
    PBox1Paint(nil);
  end
  else
  begin
    if not FInspBusy then
      FillInspFields;
    StatusBar1.Repaint;
    PBox1Paint(nil);
  end;
end;

procedure TRMDesignerForm.ShowContent;
var
  t: TRMView;
  s: string;
begin
  s := '';
  if SelNum = 1 then
  begin
    t := Objects[TopSelected];
    s := t.Name;
    if t.IsBand then
      s := s + ': ' + RMBandNames[TRMCustomBandView(t).BandType]
    else if t.Memo.Count > 0 then
      s := s + ': ' + t.Memo[0];
  end;
  StatusBar1.Panels[2].Text := s;
end;

procedure TRMDesignerForm.ResetSelection;
begin
  UnselectAll;
  SelNum := 0;
  EnableControls;
  ShowPosition;
end;

procedure TRMDesignerForm.MoveObjects(dx, dy: Integer; Resize: Boolean);
var
  i: Integer;
  t: TRMView;
  liHaveBand: Boolean;

  function _CanResize: Boolean;
  var
    i: Integer;
  begin
    Result := True;
    if (dx >= 0) and (dy >= 0) then Exit;
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
      begin
        if (t.spWidth_Designer + dx < 0) or (t.spHeight_Designer + dy < 0) then
        begin
          Result := False;
          Break;
        end;
      end;
    end;
  end;

begin
  if Resize then
  begin
    if not _CanResize then Exit;
  end;

  AddUndoAction(acEdit);
  liHaveBand := False;
  Modified := True;
  GetRegion;
  FWorkSpace.DrawPage(dmSelection);
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    if t.Selected then
    begin
      if Resize then // 改变大小
      begin
        t.spWidth_Designer := t.spWidth_Designer + dx;
        t.spHeight_Designer := t.spHeight_Designer + dy;
        if t.IsBand then liHaveBand := True;
      end
      else // 移动位置
      begin
        if t.IsBand then
        begin
          if TRMCustomBandView(t).BandType in [rmbtOverlay, rmbtCrossHeader, rmbtCrossData, rmbtCrossFooter] then
          begin
            t.spLeft_Designer := t.spLeft_Designer + dx;
            t.spTop_Designer := t.spTop_Designer + dy;
          end;
        end
        else
        begin
          t.spLeft_Designer := t.spLeft_Designer + dx;
          t.spTop_Designer := t.spTop_Designer + dy;
        end;
      end;
    end;
  end;

  ShowPosition;
  FWorkSpace.GetMultipleSelected;
  if AutoChangeBandPos and liHaveBand then
  begin
    Page.UpdateBandsPageRect;
    RedrawPage;
  end
  else
    FWorkSpace.Draw(TopSelected, RM_ClipRgn);
end;

function TRMDesignerForm.GetSelectionStatus: TSelectionStatus;
var
  t: TRMView;
begin
  Result := [];
  if SelNum = 1 then
  begin
    t := Objects[TopSelected];
    if t.IsBand then
      Result := [ssBand]
    else if t is TRMCustomMemoView then
      Result := [ssMemo]
    else
      Result := [ssOther];
  end
  else if SelNum > 1 then
    Result := [ssMultiple];
end;

function TRMDesignerForm.RectTypEnabled: Boolean;
begin
  Result := [ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TRMDesignerForm.FontTypEnabled: Boolean;
begin
  Result := [ssMemo, ssMultiple] * SelStatus <> [];
end;

function TRMDesignerForm.ZEnabled: Boolean;
begin
  Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TRMDesignerForm.CutEnabled: Boolean;
begin
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanCut and (not FCodeMemo.ReadOnly)
  else
    Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TRMDesignerForm.CopyEnabled: Boolean;
begin
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanCopy and (not FCodeMemo.ReadOnly)
  else
    Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TRMDesignerForm.PasteEnabled: Boolean;
begin
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanPaste and (not FCodeMemo.ReadOnly)
  else
    Result := Clipboard.HasFormat(CF_REPORTMACHINE);
end;

function TRMDesignerForm.DelEnabled: Boolean;
begin
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanCut and (not FCodeMemo.ReadOnly)
  else
    Result := [ssBand, ssMemo, ssOther, ssMultiple] * SelStatus <> [];
end;

function TRMDesignerForm.EditEnabled: Boolean;
begin
  if Tab1.TabIndex = 0 then
    Result := False
  else
    Result := [ssBand, ssMemo, ssOther] * SelStatus <> [];
end;

function TRMDesignerForm.RedoEnabled: Boolean;
begin
  if Tab1.TabIndex = 0 then
    Result := False
  else
    Result := FRedoBufferLength > 0;
end;

function TRMDesignerForm.UndoEnabled: Boolean;
begin
  if Tab1.TabIndex = 0 then
    Result := FCodeMemo.RMCanUndo and (not FCodeMemo.ReadOnly)
  else
    Result := FUndoBufferLength > 0;
end;

procedure TRMDesignerForm.EnableControls;

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

begin
  ToolbarComponent.Enabled := Tab1.TabIndex > 0;
  //  barSearch.Visible := Tab1.TabIndex = 0;
  _SetEnabled([barSearch, padSearchFind, padSearchReplace, padSearchFindAgain], Tab1.TabIndex = 0);

  with ToolbarStandard do
    _SetEnabled([btnAddPage, padNewPage, btnAddForm, padNewForm, padpopAddPage, padpopAddForm],
      (not IsPreviewDesign) and (DesignerRestrictions * [rmdrDontCreatePage] = []));
  _SetEnabled([ToolbarStandard.btnDeletePage, padDeletePage, padpopDeletePage],
    (not IsPreviewDesign) and (Tab1.TabIndex > 0) and (DesignerRestrictions * [rmdrDontDeletePage] = []));
  _SetEnabled([padFileOpen, ToolbarStandard.btnFileOpen], not IsPreviewDesign);
  _SetEnabled([ToolbarStandard.btnFileNew, padFileNew], not IsPreviewDesign);
  _SetEnabled([ToolbarStandard.btnPrint, ToolbarStandard.btnPreview, padPrint, padPreview],
    ((not IsPreviewDesign) and (not IsPreviewDesignReport)) and (DesignerRestrictions * [rmdrDontPreviewReport] = []));
  _SetEnabled([ToolbarStandard.btnFileSave, padFileSave],
    ((not IsPreviewDesign) and Modified) and (DesignerRestrictions * [rmdrDontSaveReport] = []));
  _SetEnabled([padFileSaveAs], (not IsPreviewDesign) and (DesignerRestrictions * [rmdrDontSaveReport] = []));
  _SetEnabled([padVarList, LoadDictionary1, MergeDictionary1, SaveAsDictionary1],
    (not IsPreviewDesign) and (DesignerRestrictions * [rmdrDontEditVariables] = []));
  _SetEnabled([padPageSetup, ToolbarStandard.btnPageSetup, padpopPageSetup],
    ((not IsPreviewDesign) and (Tab1.TabIndex > 0)) and (DesignerRestrictions * [rmdrDontChangeReportOptions] = []));
  _SetEnabled([ToolbarStandard.btnUndo, padUndo], UndoEnabled);
  _SetEnabled([ToolbarStandard.btnRedo, padRedo], RedoEnabled);

  with ToolbarBorder do
  begin
    _SetEnabled([btnFrameTop, btnFrameLeft, btnFrameBottom, btnFrameRight, btnSetFrame, btnNoFrame, FBtnBackColor, FBtnFrameColor, FCmbFrameWidth, btnSetFrameStyle],
      RectTypEnabled and (Page is TRMReportPage));
  end;
  _SetEnabled([FBtnFontColor, FcmbFont, FcmbFontSize, btnFontBold, btnFontItalic, btnFontUnderline, btnTextAlignLeft, btnTextAlignRight, btnTextAlignCenter, btnTextAlignVCenter, btnTextAlignTop, btnTextAlignBottom, btnTextAlignH, HlB1],
    FontTypEnabled);
  ToolbarStandard.btnExpression.Enabled := (Tab1.TabIndex = 0) or ((Page is TRMReportPage) and (SelNum = 1));
  with ToolbarStandard do
    _SetEnabled([btnBringtoFront, btnSendtoBack, padBringtoFront, padSendtoBack, GB3], ZEnabled);
  _SetEnabled([ToolbarStandard.btnCut, padCut, padpopCut], CutEnabled);
  _SetEnabled([ToolbarStandard.btnCopy, padCopy, padpopCopy], CopyEnabled);
  _SetEnabled([ToolbarStandard.btnPaste, padPaste, padpopPaste], PasteEnabled);
  _SetEnabled([padDelete, padpopDelete], DelEnabled);
  _SetEnabled([padEdit, padpopEdit, padpopClearContents, padpopFrame], EditEnabled);
  _SetEnabled([padEditReplace], Tab1.TabIndex > 0);
  with ToolbarAlign do
  begin
    _SetEnabled([btnAlignLeft, btnAlignHCenter, btnAlignRight, btnAlignTop, btnAlignVCenter, btnAlignBottom], SelNum > 1);
    _SetEnabled([btnAlignHSE, btnAlignVSE, { btnAlignHWCenter, btnAlignVWCenter,} btnAlignLeftRight, btnAlignTopBottom], SelNum > 1);
  end;
  with ToolbarSize do
    _SetEnabled([btnSetWidthToMin, btnSetWidthToMax, btnSetHeightToMin, btnSetHeightToMax], SelNum > 1);

  _SetEnabled([ToolbarStandard.btnPrint, padPrint], padPrint.Enabled and (RMPrinters.Count >= 2));

  StatusBar1.Repaint;
  PBox1Paint(nil);
end;

procedure SetBit(var w: Word; e: Boolean; m: Integer);
begin
  if e then
    w := w or m
  else
    w := w and not m;
end;

procedure TRMDesignerForm.DoClick(Sender: TObject);
var
  i, b: Integer;
  t: TRMView;
begin
  if FBusy then Exit;

  FBusy := True;
  AddUndoAction(acEdit);
  FWorkSpace.DrawPage(dmSelection);
  GetRegion;
  b := TControl(Sender).Tag;
  for i := 0 to Objects.Count - 1 do
  begin
    t := Objects[i];
    if (not t.Selected) or t.IsBand then Continue;

    with t do
    begin
      if t is TRMCustomMemoView then
      begin
        with TRMCustomMemoView(t) do
        begin
          case b of
            TAG_SetFontName:
              begin
                if FcmbFont.ItemIndex >= 0 then
                begin
                  RM_LastFontName := FcmbFont.Text;
                  if RMIsChineseGB then
                  begin
                    if ByteType(RM_LastFontName, 1) = mbSingleByte then
                      RM_LastFontCharset := ANSI_CHARSET
                    else
                      RM_LastFontCharset := GB2312_CHARSET;
                  end;
                  Font.Name := RM_LastFontName;
                  Font.Charset := RM_LastFontCharset;
                end;
              end;
            TAG_SetFontSize:
              begin
                if FCmbFontSize.ItemIndex >= 0 then
                begin
                  RM_LastFontSize := RMGetFontSize(TComboBox(FCmbFontSize));
                  if RM_LastFontSize >= 0 then
                    Font.Size := RM_LastFontSize
                  else
                    Font.Height := RM_LastFontSize;
                end;
              end;
            TAG_FontBold:
              begin
                RM_LastFontStyle := RMGetFontStyle(Font.Style);
                SetBit(RM_LastFontStyle, btnFontBold.Down, 2);
                Font.Style := RMSetFontStyle(RM_LastFontStyle);
              end;
            TAG_FontItalic:
              begin
                RM_LastFontStyle := RMGetFontStyle(Font.Style);
                SetBit(RM_LastFontStyle, btnFontItalic.Down, 1);
                Font.Style := RMSetFontStyle(RM_LastFontStyle);
              end;
            TAG_FontUnderline:
              begin
                RM_LastFontStyle := RMGetFontStyle(Font.Style);
                SetBit(RM_LastFontStyle, btnFontUnderline.Down, 4);
                Font.Style := RMSetFontStyle(RM_LastFontStyle);
              end;
            TAG_HAlignLeft..TAG_HAlignEuqal:
              begin
                RM_LastHAlign := TRMHAlign(b - TAG_HAlignLeft);
                HAlign := RM_LastHAlign;
                TRMToolbarButton(Sender).Down := True;
              end;
            TAG_FontColor:
              begin
                Font.Color := FBtnFontColor.CurrentColor;
                RM_LastFontColor := Font.Color;
              end;
            TAG_VAlignTop..TAG_VAlignBottom:
              begin
                RM_LastVAlign := TRMVAlign(b - TAG_VAlignTop);
                VAlign := RM_LastVAlign;
                TRMToolbarButton(Sender).Down := True;
              end;
          end;
        end;
      end;

      case b of
        TAG_SetFrameTop: TopFrame.Visible := ToolbarBorder.btnFrameTop.Down;
        TAG_SetFrameLeft: LeftFrame.Visible := ToolbarBorder.btnFrameLeft.Down;
        TAG_SetFrameBottom: BottomFrame.Visible := ToolbarBorder.btnFrameBottom.Down;
        TAG_SetFrameRight: RightFrame.Visible := ToolbarBorder.btnFrameRight.Down;
        TAG_BackColor:
          begin
            FillColor := ToolbarBorder.FBtnBackColor.CurrentColor;
            RM_LastFillColor := FillColor;
          end;
        TAG_FrameSize:
          begin
            LeftFrame.mmWidth := RMToMMThousandths(StrToFloat(ToolbarBorder.FCmbFrameWidth.Text), rmutScreenPixels);
            TopFrame.mmWidth := LeftFrame.mmWidth;
            RightFrame.mmWidth := LeftFrame.mmWidth;
            BottomFrame.mmWidth := LeftFrame.mmWidth;
            RM_LastFrameWidth := TopFrame.mmWidth;
          end;
        TAG_FrameColor:
          begin
            LeftFrame.Color := ToolbarBorder.FBtnFrameColor.CurrentColor;
            TopFrame.Color := LeftFrame.Color;
            RightFrame.Color := LeftFrame.Color;
            BottomFrame.Color := LeftFrame.Color;
            RM_LastFrameColor := LeftFrame.Color;
          end;
        TAG_SetFrame:
          begin
            LeftFrame.Visible := True;
            RightFrame.Visible := True;
            TopFrame.Visible := True;
            BottomFrame.Visible := True;
            RM_LastLeftFrameVisible := True;
            RM_LastTopFrameVisible := True;
            RM_LastRightFrameVisible := True;
            RM_LastBottomFrameVisible := True;
          end;
        TAG_NoFrame:
          begin
            LeftFrame.Visible := False;
            RightFrame.Visible := False;
            TopFrame.Visible := False;
            BottomFrame.Visible := False;
            RM_LastLeftFrameVisible := False;
            RM_LastTopFrameVisible := False;
            RM_LastRightFrameVisible := False;
            RM_LastBottomFrameVisible := False;
          end;
        TAG_FrameStyle1..TAG_FrameStyle5:
          begin
            LeftFrame.Style := TPenStyle(b - TAG_FrameStyle1);
            TopFrame.Style := LeftFrame.Style;
            RightFrame.Style := LeftFrame.Style;
            BottomFrame.Style := LeftFrame.Style;
          end;
        TAG_FrameStyle6:
          begin
            LeftFrame.DoubleFrame := not LeftFrame.DoubleFrame;
            TopFrame.DoubleFrame := LeftFrame.DoubleFrame;
            RightFrame.DoubleFrame := LeftFrame.DoubleFrame;
            BottomFrame.DoubleFrame := LeftFrame.DoubleFrame;
          end;
      end; {end Case}
    end; {end for }
  end;

  Modified := True;
  FBusy := False;
  FWorkSpace.Draw(TopSelected, RM_ClipRgn);
  FillInspFields;
  SelectionChanged(True);
end;

procedure TRMDesignerForm.ShowMemoEditor(Sender: TObject);
var
  t: TRMView;
begin
  if Sender = nil then
    t := Objects[TopSelected]
  else
    t := TRMView(Sender);

  if TRMEditorForm(EditorForm).ShowEditor(t) = mrOk then
  begin
    FWorkSpace.DrawPage(dmSelection);
    FWorkSpace.Draw(TopSelected, t.GetClipRgn(rmrtExtended));
  end;
end;

procedure TRMDesignerForm.ShowEditor;
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

  procedure _EditCrossDataBand;
  begin
    with TRMVBandEditorForm.Create(nil) do
    begin
      ShowEditor(t);
      Free;
    end;
  end;

begin
  t := Objects[TopSelected];

  if ((t.Restrictions * [rmrtDontModify]) <> []) or
    (DesignerRestrictions * [rmdrDontEditObj] <> []) then Exit;

  if t.ObjectType = rmgtSubReport then
    CurPage := (t as TRMSubReportView).SubPage
  else
  begin
    FWorkSpace.DrawPage(dmSelection);
    if not t.IsBand then
    begin
      t.ShowEditor;
    end
    else
    begin
      if (t is TRMBandMasterData) or (t is TRMBandDetailData) then
        _EditDataBand
      else if t is TRMBandGroupHeader then
        _EditGroupHeaderBand
      else if t is TRMBandCrossData then
        _EditCrossDataBand
    end;
    FWorkSpace.Draw(TopSelected, t.GetClipRgn(rmrtExtended));
  end;

  ShowPosition;
  ShowContent;
end;

procedure TRMDesignerForm.OpenFile(aFileName: string);
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

  FWorkSpace.DisableDraw := True;
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
      OpenDialog1.Filter := RMLoadStr(SFormFile) + ' (*.rmf)|*.rmf';
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
  FWorkSpace.DisableDraw := False;
  if Opened then
  begin
    ToolbarComponent.btnNoSelect.Click;
    CurDocName := aFileName;
    Modified := False;
    Report.ComponentModified := True;
    FCurPage := -1;
    CurPage := 0; // do all
    SetOpenFileMenuItems(aFileName);
    SetObjectsID;
    Script := Report.Script;
    ClearUndoBuffer;
    ClearRedoBuffer;
    if FFieldForm.VIsible then
      FFieldForm.RefreshData;
  end;
end;

procedure TRMDesignerForm.itmFileFile9Click(Sender: TObject);
begin
  if FileExists(FOpenFiles[TComponent(Sender).Tag - 1]) then
    OpenFile(FOpenFiles[TComponent(Sender).Tag - 1]);
end;

procedure TRMDesignerForm.btnFileOpenClick(Sender: TObject);
begin
  OpenFile('');
end;

procedure TRMDesignerForm.BtnFileNewClick(Sender: TObject);
var
  w: Word;
begin
  if DesignerRestrictions * [rmdrDontCreateReport] <> [] then
    Exit;

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

  ToolbarComponent.btnNoSelect.Click;
  Report.NewReport;
  if (FDesignerComp <> nil) and (FDesignerComp.DefaultDictionaryFile <> '') and
    FileExists(FDesignerComp.DefaultDictionaryFile) then
    Report.Dictionary.LoadFromFile(FDesignerComp.DefaultDictionaryFile);
  CreateDefaultPage;
  FCurPage := -1;
  CurPage := 0;
  CurDocName := RMLoadStr(SUntitled);
  FWorkSpace.Init;
  Modified := False;
  Report.ComponentModified := True;
  Script := Report.Script;
  SetObjectsID;
  ClearUndoBuffer;
  ClearRedoBuffer;
  if FFieldForm.VIsible then
    FFieldForm.RefreshData;
end;

function TRMDesignerForm.FileSaveAs: Boolean;
var
  lSaved: Boolean;
  lFileName: string;
  tmp: TRMTemplNewForm;
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
    lFileName := CurDocName;
    lSaved := True;
    FDesignerComp.OnSaveReport(Report, lFileName, True, lSaved);
    if lSaved then
    begin
      Modified := False;
      CurDocName := lFileName;
      ClearUndoBuffer;
      ClearRedoBuffer;
      Exit;
    end;
  end;

  SaveDialog1.Filter := RMLoadStr(SFormFile) + ' (*.rmf)|*.rmf|' +
    RMLoadStr(STemplFile) + ' (*.rmt)|*.rmt';
  SaveDialog1.FileName := FCurDocName;
  SaveDialog1.FilterIndex := 1;
  if SaveDialog1.Execute then
  begin
    if SaveDialog1.FilterIndex = 1 then
    begin
      lFileName := ChangeFileExt(SaveDialog1.FileName, '.rmf');
      Report.SaveToFile(lFileName);
      Result := True;
      CurDocName := lFileName;
      SetOpenFileMenuItems(lFileName);
    end
    else
    begin
      lFileName := ChangeFileExt(SaveDialog1.FileName, '.rmt');
      if FDesignerComp <> nil then
        RMTemplateDir := FDesignerComp.TemplateDir;
      if RMTemplateDir <> '' then
        lFileName := RMTemplateDir + '\' + ExtractFileName(lFileName);

      tmp := TRMTemplNewForm.Create(nil);
      try
        if tmp.ShowModal = mrOK then
        begin
          Report.SaveTemplate(lFileName, tmp.Memo1.Lines, tmp.Image1.Picture.Bitmap);
          Result := True;
        end;
      finally
        tmp.Free;
      end;
    end;
  end;

  if Result then
  begin
    Modified := False;
    ClearUndoBuffer;
    ClearRedoBuffer;
  end;
end;

procedure TRMDesignerForm.padFileSaveAsClick(Sender: TObject);
begin
  FileSaveAs;
end;

procedure TRMDesignerForm.btnPreviewClick(Sender: TObject);
var
  liSaveModalPreview: Boolean;
  liSaveVisible: Boolean;
begin
  if DesignerRestrictions * [rmdrDontPreviewReport] <> [] then
    Exit;

  ToolbarComponent.btnNoSelect.Click;
  liSaveModalPreview := Report.ModalPreview;
  liSaveVisible := FInspForm.Visible;
  Application.ProcessMessages;
  Report.ModalPreview := True;
  UnselectAll;
  RedrawPage;
  Page := nil;
  FBusy := True;
  FInspBusy := True;
  try
    if not FCodeMemo.ReadOnly then
      Report.Script.Assign(Script);
    FInspForm.Hide;
    Report.Preview := nil;
    Report.ShowReport;
  finally
    THackReport(Report).Flag_PrintBackGroundPicture := False;
    Report.ModalPreview := liSaveModalPreview;
    FInspBusy := False;
    FBusy := False;
    FInspForm.Visible := liSaveVisible;
    FWorkSpace.Init;
    CurPage := CurPage;
    SelectionChanged(True);
    Screen.Cursor := crDefault;
    if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnShow) then
      FDesignerComp.OnShow(Self);
    if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnClose) then
      FDesignerComp.OnClose(Self);
  end;
end;

procedure TRMDesignerForm.padPrintClick(Sender: TObject);
var
  liSaveVisible: Boolean;
begin
  if RMPrinters.Count < 2 then Exit;

  ToolbarComponent.btnNoSelect.Click;
  liSaveVisible := FInspForm.Visible;
  Application.ProcessMessages;
  UnselectAll;
  RedrawPage;
  Page := nil;
  FBusy := True;
  FInspBusy := True;
  try
    if not FCodeMemo.ReadOnly then
      Report.Script.Assign(Script);
    FInspForm.Hide;
    Report.PrintReport;
  finally
    THackReport(Report).Flag_PrintBackGroundPicture := False;
    FInspBusy := False;
    FBusy := False;
    FInspForm.Visible := liSaveVisible;
    CurPage := CurPage;
    SelectionChanged(True);
    Screen.Cursor := crDefault;
    if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnShow) then
      FDesignerComp.OnShow(Self);
  end;
end;

procedure TRMDesignerForm.btnCutClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanCut then
    begin
      FCodeMemo.RMClipBoardCut;
      ShowPosition;
    end;
  end
  else
  begin
    FWorkSpace.CopyToClipboard;
    FWorkSpace.DeleteObjects(True);
    FirstSelected := nil;
    EnableControls;
    ShowPosition;
    RedrawPage;
  end;
end;

procedure TRMDesignerForm.btnCopyClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanCopy then
    begin
      FCodeMemo.RMClipBoardCopy;
      ShowPosition;
    end;
  end
  else
  begin
    FWorkSpace.CopyToClipboard;
    EnableControls;
  end;
end;

procedure TRMDesignerForm.btnPasteClick(Sender: TObject);
var
  minx, miny: Integer;
  t: TRMView;
  b: Byte;
  lPoint: TPoint;
  hMem: THandle;
  pMem: pointer;
  hSize: DWORD;
  lStream: TMemoryStream;
  lHaveBand: Boolean;
  i, lCount: Integer;

  procedure _CreateName(t: TRMView);
  begin
    if Report.FindObject(t.Name) <> nil then
    begin
      t.CreateName(Report);
      t.Name := t.Name;
    end;
  end;

  procedure _GetMinXY;
  var
    i, lCount: Integer;
  begin
    lStream.Seek(soFromBeginning, 0);
    lCount := RMReadInt32(lStream);
    for i := 0 to lCount - 1 do
    begin
      b := RMReadByte(lStream);
      t := RMCreateObject(b, RMReadString(lStream));
      try
        THackView(t).StreamMode := rmsmDesigning;
        t.LoadFromStream(lStream);
        if Round(t.spLeft / Factor * 100) < minx then
          minx := Round(t.spLeft / Factor * 100);
        if Round(t.spTop / Factor * 100) < miny then
          miny := Round(t.spTop / Factor * 100);
      finally
        t.Free;
      end;
    end;

    if (lPoint.X >= 0) and (lPoint.X < FWorkSpace.Width) and (lPoint.Y >= 0) and
      (lPoint.Y < FWorkSpace.Height) then
    begin
      minx := lPoint.X - minx;
      miny := lPoint.Y - miny;
    end
    else
    begin
      minx := -minx + (-FWorkSpace.Left) div GridSize * GridSize;
      miny := -miny + (-FWorkSpace.Left) div GridSize * GridSize;
    end;
  end;

begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanPaste then
    begin
      FCodeMemo.RMClipBoardPaste;
      ShowPosition;
    end;
    Exit;
  end;

  //	IsBandsSelect(lParentBand);
  //  if lParentBand <> nil then
  //  	lParentBand.Selected := False;
  GetCursorPos(lPoint);
  lPoint := FWorkSpace.ScreenToClient(lPoint);

  UnSelectAll;
  SelNum := 0;
  minx := 32767;
  miny := 32767;

  lStream := nil;
  Clipboard.Open;
  try
    hMem := Clipboard.GetAsHandle(CF_REPORTMACHINE);
    pMem := GlobalLock(hMem);
    if pMem <> nil then
    begin
      hSize := GlobalSize(hMem);
      lStream := TMemoryStream.Create;
      try
        lStream.Write(pMem^, hSize);
      finally
        GlobalUnlock(hMem);
      end;
    end;
  finally
    Clipboard.Close;
  end;

  if lStream = nil then Exit;

  try
    _GetMinXY;
    lStream.Seek(soFromBeginning, 0);
    lCount := RMReadInt32(lStream);
    lHaveBand := False;
    for i := 0 to lCount - 1 do
    begin
      b := RMReadByte(lStream);
      t := RMCreateObject(b, RMReadString(lStream));
      t.NeedCreateName := False;
      try
        THackView(t).StreamMode := rmsmDesigning;
        t.LoadFromStream(lStream);
        if (t is TRMSubReportView) or
          ((Page is TRMReportPage) and (t is TRMDialogComponent)) or
          (Page is TRMDialogPage) and (t is TRMReportView) then
        begin
          t.Free;
          Continue;
        end;

        if t.IsBand then
        begin
          if not (TRMCustomBandView(t).BandType in [rmbtMasterData, rmbtDetailData, rmbtHeader, rmbtFooter,
            rmbtGroupHeader, rmbtGroupFooter]) and RMCheckBand(TRMCustomBandView(t).BandType) then
          begin
            t.Free;
            Continue;
          end;
        end;

        t.Selected := True;
        Inc(SelNum);
        t.ParentPage := Page;
        _CreateName(t);

        begin
          t.spLeft_Designer := t.spLeft_Designer + minx;
          t.spTop_Designer := t.spTop_Designer + miny;
        end;

        SetObjectID(t);
        if t.IsBand then lHaveBand := True;
      finally
      end;
    end;

    if AutoChangeBandPos and lHaveBand then
      Page.UpdateBandsPageRect;
  finally
    lStream.Free;
    SelectionChanged(True);
    SendBandsToDown;
    FWorkSpace.GetMultipleSelected;
    RedrawPage;
    Modified := True;
    AddUndoAction(acInsert);
  end;
end;

procedure TRMDesignerForm.padDeleteClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FCodeMemo.RMCanCut then
    begin
      FCodeMemo.RMDeleteSelected;
      ShowPosition;
    end;
  end
  else
    FWorkSpace.DeleteObjects(True);
end;

procedure TRMDesignerForm.btnExpressionClick(Sender: TObject);
var
  i: Integer;
  listr, listr1: string;
  t: TRMView;
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
      end;
    end;
  end
  else
  begin
    listr := InsertExpression;
    if listr <> '' then
    begin
      for i := 0 to Objects.Count - 1 do
      begin
        t := Objects[i];
        if t.Selected and (t is TRMReportView) and (not TRMReportView(t).IsBand) then
          t.Memo.Text := liStr;
      end;
      AfterChange;
    end;
  end;
end;

procedure TRMDesignerForm.btnSelectAllClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    FCodeMemo.SelectAll;
    //FCodeMemo.Command(ecSelAll);
    ShowPosition;
  end
  else
  begin
    FWorkSpace.DrawPage(dmSelection);
    SelectAll;
    FWorkSpace.GetMultipleSelected;
    FWorkSpace.DrawPage(dmSelection);
    SelectionChanged(True);
  end;
end;

procedure TRMDesignerForm.padEditClick(Sender: TObject);
begin
  ShowEditor;
end;

procedure TRMDesignerForm.btnAddPageClick(Sender: TObject);
begin
  if DesignerRestrictions * [rmdrDontCreatePage] <> [] then
    Exit;
  ResetSelection;

  Report.Pages.AddReportPage;
  Page := Report.Pages[Report.Pages.Count - 1];
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

procedure TRMDesignerForm.btnAddFormClick(Sender: TObject);
begin
  if DesignerRestrictions * [rmdrDontCreatePage] <> [] then
    Exit;

  Page := Report.Pages.AddDialogPage;
  Page.CreateName;
  Modified := True;
  CurPage := Report.Pages.Count - 1;
end;

procedure TRMDesignerForm.btnDeletePageClick(Sender: TObject);

  procedure _AlignmentSubReports(aPageNo: Integer);
  var
    i, j: Integer;
    t: TRMView;
  begin
    with Report do
    begin
      for i := 0 to Pages.Count - 1 do
      begin
        j := 0;
        while j < THackPage(Pages[i]).Objects.Count do
        begin
          t := THackPage(Pages[i]).Objects[j];
          if t.ObjectType = rmgtSubReport then
          begin
            if TRMSubReportView(t).SubPage = aPageNo then
            begin
              Pages[i].Delete(j);
              Dec(j);
            end
            else if TRMSubReportView(t).SubPage > aPageNo then
              TRMSubReportView(t).SubPage := TRMSubReportView(t).SubPage - 1;
          end;
          Inc(j);
        end;
      end;
    end;
  end;

  procedure _RemovePage(aPageNo: Integer);
  begin
    Modified := True;
    with Report do
    begin
      if (aPageNo >= 0) and (aPageNo < Pages.Count) then
      begin
        if Pages.Count = 1 then
          Pages[aPageNo].Clear
        else
        begin
          Report.Pages.Delete(aPageNo);
          Tab1.Tabs.Delete(aPageNo + 1);
          Tab1.TabIndex := 1;
          _AlignmentSubReports(aPageNo);
          CurPage := 0;
        end;
      end;
    end;
  end;

begin
  if DesignerRestrictions * [rmdrDontDeletePage] <> [] then
    Exit;

  if Report.Pages.Count > 1 then
  begin
    if MessageBox(0, PChar(RMLoadStr(SRemovePg)),
      PChar(RMLoadStr(SConfirm)), mb_IconQuestion + mb_YesNo) = mrYes then
    begin
      _RemovePage(CurPage);
      Modified := True;
    end;
  end;
end;

procedure TRMDesignerForm.InsertFieldsClick(Sender: TObject);
begin
  Pan9.Click;
end;

procedure TRMDesignerForm.OnFieldsDialogCloseEvnet(Sender: TObject);
begin
  btnInsertFields.Down := False;
  Pan9.Checked := False;
end;

procedure TRMDesignerForm.ShowFieldsDialog(aVisible: Boolean);
begin
  btnInsertFields.Down := aVisible;
  if aVisible then
  begin
    FFieldForm.Visible := True;
    FFieldForm.RefreshData;
    FFieldForm.SetFocus;
  end
  else
  begin
    FFieldForm.Visible := False;
  end;
end;

procedure TRMDesignerForm.Pan2Click(Sender: TObject);

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
    end
    else
      aControls[i].VIsible := aVisible;
  end;

begin
  with TRMMenuItem(Sender) do
  begin
    Checked := not Checked;
    if Tag = 8 then // insert fields
    begin
      if not IsPreviewDesign then
        ShowFieldsDialog(Checked);
    end
    else if Tag = 11 then
      _SetShow([ToolbarModifyPrepared], 0, Checked)
    else
      _SetShow([ToolbarBorder, ToolbarStandard, ToolbarEdit, ToolbarComponent,
        ToolbarAlign, FInspForm, ToolBarAddinTools, ToolBarSize], Tag, Checked);
  end;
end;

procedure TRMDesignerForm.ShowObjMsg;
begin
  PBox1.Invalidate;
end;

procedure TRMDesignerForm.PBox1Paint(Sender: TObject);
var
  t: TRMView;
  p: TPoint;
  s: string;
  nx, ny: Double;
  x, y, dx, dy: Integer;

  function TopLeft: TPoint;
  var
    i: Integer;
    t: TRMView;
  begin
    Result.x := 10000;
    Result.y := 10000;
    for i := 0 to Objects.Count - 1 do
    begin
      t := Objects[i];
      if t.Selected then
      begin
        if t.spLeft_Designer < Result.x then
          Result.x := t.spLeft_Designer;
        if t.spTop_Designer < Result.y then
          Result.y := t.spTop_Designer;
      end;
    end;
  end;

begin
  if FWorkSpace.DisableDraw then Exit;

  if Tab1.TabIndex = 0 then
  begin
    PBox1.Canvas.FillRect(Rect(0, 0, PBox1.Width, PBox1.Height));
    PBox1.Canvas.TextOut(0, 0, RMLoadStr(rmRes + 578) + IntToStr(FCodeMemo.CaretY) +
      '  ' + RMLoadStr(rmRes + 579) + IntToStr(FCodeMemo.CaretX));
    Exit;
  end;

  nx := RM_OldRect.Left;
  ny := RM_OldRect.Top;
  with PBox1.Canvas do
  begin
    FillRect(Rect(0, 0, PBox1.Width, PBox1.Height));
    ImageListPosition.Draw(PBox1.Canvas, 2, 0, 0);
    if not ((SelNum = 0) and (FWorkSpace.EditMode = mdSelect)) then
      ImageListPosition.Draw(PBox1.Canvas, 92, 0, 1);
    if (SelNum = 1) or FShowSizes then
    begin
      t := nil;
      if FShowSizes then
      begin
        x := RM_OldRect.Left;
        y := RM_OldRect.Top;
        dx := RM_OldRect.Right - x;
        dy := RM_OldRect.Bottom - y;
      end
      else
      begin
        t := Objects[TopSelected];
        x := t.spLeft_Designer;
        y := t.spTop_Designer;
        dx := t.spWidth_Designer;
        dy := t.spHeight_Designer;
      end;

      nx := x;
      ny := y;
      if RMUnits = rmutScreenPixels then
        s := IntToStr(x) + ';' + IntToStr(y)
      else
      begin
        s := FloatToStrF(RMFromScreenPixels(x, RMUnits), ffFixed, 4, 2) + ';' +
          FloatToStrF(RMFromScreenPixels(y, RMUnits), ffFixed, 4, 2);
      end;
      TextOut(20, 1, s);

      if RMUnits = rmutScreenPixels then
        s := IntToStr(dx) + ';' + IntToStr(dy)
      else
      begin
        s := FloatToStrF(RMFromScreenPixels(dx, RMUnits), ffFixed, 4, 2) + ';' +
          FloatToStrF(RMFromScreenPixels(dy, RMUnits), ffFixed, 4, 2);
      end;
      TextOut(110, 1, s);

      if not FShowSizes and (t.ObjectType = rmgtPicture) then
      begin
        with t as TRMPictureView do
        begin
          if (Picture.Graphic <> nil) and (not Picture.Graphic.Empty) then
          begin
            if RMUnits = rmutScreenPixels then
              s := IntToStr(dx * 100 div Picture.Width) + ',' + IntToStr(dy * 100 div Picture.Height)
            else
            begin
              s := FloatToStrF(RMFromScreenPixels(dx * 100 div Picture.Width, RMUnits), ffFixed, 4, 2) + ',' +
                FloatToStrF(RMFromScreenPixels(dy * 100 div Picture.Height, RMUnits), ffFixed, 4, 2);
            end;
            TextOut(170, 1, '% ' + s);
          end;
        end;
      end;
    end
    else if (SelNum > 0) and RM_SelectedManyObject then
    begin
      p := TopLeft;
      if RMUnits = rmutScreenPixels then
        s := IntToStr(p.x) + ';' + IntToStr(p.y)
      else
      begin
        s := FloatToStrF(RMFromScreenPixels(p.x, RMUnits), ffFixed, 4, 2) + ';' +
          FloatToStrF(RMFromScreenPixels(p.y, RMUnits), ffFixed, 4, 2);
      end;
      TextOut(20, 1, s);

      nx := 0;
      ny := 0;
      if RM_OldRect1.Right - RM_OldRect1.Left <> 0 then
        nx := (RM_OldRect.Right - RM_OldRect.Left) / (RM_OldRect1.Right - RM_OldRect1.Left);
      if RM_OldRect1.Bottom - RM_OldRect1.Top <> 0 then
        ny := (RM_OldRect.Bottom - RM_OldRect.Top) / (RM_OldRect1.Bottom - RM_OldRect1.Top);

      if RMUnits = rmutScreenPixels then
        s := IntToStr(Round(nx * 100)) + ',' + IntToStr(Round(ny * 100))
      else
      begin
        s := FloatToStrF(RMFromScreenPixels(Round(nx * 100), RMUnits), ffFixed, 4, 2) + ',' +
          FloatToStrF(RMFromScreenPixels(Round(ny * 100), RMUnits), ffFixed, 4, 2);
      end;
      TextOut(170, 1, '% ' + s);

      nx := p.x;
      ny := p.y;
    end
    else if (SelNum = 0) and (FWorkSpace.EditMode = mdSelect) then
    begin
      x := RM_OldRect.Left;
      y := RM_OldRect.Top;
      nx := x;
      ny := y;
      if RMUnits = rmutScreenPixels then
        s := IntToStr(x) + ';' + IntToStr(y)
      else
      begin
        s := FloatToStrF(RMFromScreenPixels(x, RMUnits), ffFixed, 4, 2) + ';' +
          FloatToStrF(RMFromScreenPixels(y, RMUnits), ffFixed, 4, 2);
      end;
      TextOut(20, 1, s);
    end
  end;

  if Page is TRMReportPage then
  begin
    SetRulerOffset;
    x := Round(TRMReportPage(Page).spMarginLeft * Factor / 100);
    y := Round(TRMReportPage(Page).spMarginTop * Factor / 100);
    FHRuler.SetGuides(Trunc(x + nx - FHRuler.ScrollOffset), 0);
    FVRuler.SetGuides(Trunc(y + ny - FVRuler.ScrollOffset), 0);
  end;
end;

procedure TRMDesignerForm.SetRulerOffset;
begin
  if pnlWorkSpace.Left <= 0 then
  begin
    FHRuler.ScrollOffset := -pnlWorkSpace.Left;
  end;
  if pnlWorkSpace.Top <= 0 then
  begin
    FVRuler.ScrollOffset := -pnlWorkSpace.Top;
  end;
end;

procedure TRMDesignerForm.SetPageTabs;
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

procedure TRMDesignerForm.Tab1Change(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    if FWorkSpace.PageForm <> nil then
      FWorkSpace.PageForm.Visible := False;
    FCodeMemo.Visible := True;
    FCodeMemo.SetFocus;
    //    OnKeyDown := nil;
    KeyPreview := False;
    EnableControls;
    Exit;
  end;
  CurPage := Tab1.TabIndex - 1;
  //  OnKeyDown := FormKeyDown;
  KeyPreview := True;
end;

procedure TRMDesignerForm.btnPageSetupClick(Sender: TObject);
begin
  if DesignerRestrictions * [rmdrDontEditPage] <> [] then Exit;

  PageSetup;
end;

function TRMDesignerForm.FileSave: Boolean;
var
  liSaved: Boolean;
  liFileName: string;
begin
  Result := False;
  if DesignerRestrictions * [rmdrDontSaveReport] <> [] then
    Exit;

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

procedure TRMDesignerForm.btnFileSaveClick(Sender: TObject);
begin
  FileSave;
end;

procedure TRMDesignerForm.btnExitClick(Sender: TObject);
begin
  if FormStyle = fsNormal then
    ModalResult := mrOk
  else
    Close;
end;

procedure TRMDesignerForm.OnpadAutoArrangeClick(Sender: TObject);
var
  i: Integer;
  t: TRMView;
  s, liBandList: TList;
  liWidths: TStringList;
  liLeft: Integer;

  procedure ArrangeOneBand(aFirstTime: Boolean; aBand: TRMView);
  var
    i, j: Integer;
    t: TRMView;
    lix, liy, lidy: Integer;
  begin
    s.Clear;
    for i := 0 to Objects.Count - 1 do
    begin
      t := TRMView(Objects[i]);
      if (not t.IsBand) and (t.spTop_Designer >= aBand.spTop_Designer) and (t.spBottom_Designer <= aBand.spBottom_Designer) then
        s.Add(t);
    end;

    for i := 0 to s.Count - 1 do
    begin
      for j := i + 1 to s.Count - 1 do
      begin
        if TRMView(s[i]).spLeft_Designer > TRMView(s[j]).spLeft_Designer then
          s.Exchange(i, j);
      end;
    end;

    if s.Count > 0 then
    begin
      if aFirstTime then
      begin
        liLeft := TRMView(s[0]).spLeft_Designer;
        liWidths.Add(IntToStr(TRMView(s[0]).spWidth_Designer));
      end
      else
      begin
        TRMView(s[0]).spLeft_Designer := liLeft;
        if liWidths.Count > 0 then
          TRMView(s[0]).spWidth_Designer := StrToInt(liWidths[0]);
      end;

      lix := TRMView(s[0]).spRight_Designer;
      liy := TRMView(s[0]).spTop_Designer;
      lidy := TRMView(s[0]).spHeight_Designer;
      for i := 1 to s.Count - 1 do
      begin
        t := TRMView(s[i]);
        t.spLeft_Designer := lix;
        t.spTop_Designer := liy;
        t.spHeight_Designer := lidy;

        if aFirstTime then
          liWidths.Add(IntToStr(t.spWidth_Designer))
        else
        begin
          if i < liWidths.Count then
            t.spWidth_Designer := StrToInt(liWidths[i]);
        end;
        Inc(lix, t.spWidth_Designer);
      end;
    end;
  end;

begin
  if TRMView(Objects[TopSelected]).IsBand then
  begin
    BeforeChange;
    s := TList.Create;
    liBandList := TList.Create;
    liWidths := TStringList.Create;
    try
      if SelNum = 1 then
        liBandList.Add(Objects[TopSelected])
      else
      begin
        for i := 0 to Objects.Count - 1 do
        begin
          t := TRMView(Objects[i]);
          if t.Selected and t.IsBand then
            liBandList.Add(t);
        end;
      end;

      liLeft := 0;
      for i := 0 to liBandList.Count - 1 do
      begin
        ArrangeOneBand(i = 0, liBandList[i]);
      end;
    finally
      s.Free;
      liBandList.Free;
      liWidths.Free;
    end;
    FWorkSpace.GetMultipleSelected;
    RedrawPage;
  end;
end;

procedure TRMDesignerForm.Popup1Popup(Sender: TObject);
var
  i: Integer;
  t, t1: TRMView;
  fl: Boolean;

  procedure _AddAutoArrangeMenuItem;
  var
    MenuItem: TRMMenuItem;
  begin
    MenuItem := TRMMenuItem.Create(Self);
    MenuItem.Caption := RMLoadStr(rmRes + 212);
    MenuItem.OnClick := OnpadAutoArrangeClick;
    Popup1.Items.Add(MenuItem);
  end;

  procedure _AddOtherMenuItem;
  var
    MenuItem: TRMMenuItem;
  begin
    Popup1.Items.Add(RMNewLine());

    MenuItem := TRMMenuItem.Create(Self);
    MenuItem.Caption := RMLoadStr(rmRes + 211);
    MenuItem.Checked := FInspForm.Visible;
    MenuItem.OnClick := Pan5Click;
    Popup1.Items.Add(MenuItem);

    padpopFrame.Enabled := ToolbarBorder.btnFrameTop.Enabled;
  end;

begin
  EnableControls;
  while Popup1.Items.Count > DefaultPopupItemsCount do
    Popup1.Items.Delete(DefaultPopupItemsCount);

  if SelNum = 1 then
  begin
    if TRMView(Objects[TopSelected]).IsBand then
      _AddAutoArrangeMenuItem;
    TRMView(Objects[TopSelected]).DefinePopupMenu(TRMCustomMenuItem(Popup1.Items));
  end
  else if SelNum > 1 then
  begin
    t := Objects[TopSelected];
    fl := True;
    for i := 0 to Objects.Count - 1 do
    begin
      t1 := Objects[i];
      if t1.Selected and (t.ClassName <> t1.ClassName) then
      begin
        fl := False;
        Break;
      end;
    end;

    if fl then
      t.DefinePopupMenu(TRMCustomMenuItem(Popup1.Items));

    if fl and t.IsBand then
    begin
      fl := True;
      for i := 0 to Objects.Count - 1 do
      begin
        t1 := Objects[i];
        if t1.Selected and (not t1.IsBand) then
        begin
          fl := False;
          Break;
        end;
      end;

      if fl then _AddAutoArrangeMenuItem;
    end;
  end;

  _AddOtherMenuItem;
end;

procedure TRMDesignerForm.Pan5Click(Sender: TObject);
begin
  //dejoy changed
  if Sender is TRMMenuItem then
  begin
    with Sender as TRMMenuItem do
    begin
      FInspForm.Visible := not FInspForm.Visible;
      Checked := FInspForm.Visible;
      Pan5.Checked := Checked;
    end;
  end
  else
  begin
    with Sender as TMenuItem do
    begin
      FInspForm.Visible := not FInspForm.Visible;
      Checked := FInspForm.Visible;
      Pan5.Checked := Checked;
    end;
  end;

  if FInspForm.Visible then
  begin
    FInspForm.BringToFront;
    FillInspFields;
  end;
end;

procedure TRMDesignerForm.padpopEditClick(Sender: TObject);
begin
  ShowEditor;
end;

procedure TRMDesignerForm.padpopFrameClick(Sender: TObject);
var
  t: TRMView;
  tmp: TRMFormFrameProp;
begin
  t := Objects[TopSelected];
  tmp := TRMFormFrameProp.Create(nil);
  try
    tmp.ShowEditor(t);
  finally
    tmp.Free;
  end;
end;

procedure TRMDesignerForm.padpopClearContentsClick(Sender: TObject);
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

procedure TRMDesignerForm.barFileClick(Sender: TObject);
begin
  EnableControls;
  itmEditLockControls.Checked := (DesignerRestrictions * [rmdrDontSizeObj, rmdrDontMoveObj]) <> [];
end;

procedure TRMDesignerForm.btnUndoClick(Sender: TObject);
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
    Undo(@FUndoBuffer);
end;

procedure TRMDesignerForm.btnRedoClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
    //
  end
  else
    Undo(@FRedoBuffer);
end;

procedure TRMDesignerForm.OnFindReplaceView(Sender: TObject);
begin
  FWorkSpace.DrawPage(dmSelection);
  UnselectAll;
  TRMView(Sender).Selected := True;
  SelNum := 1;
  SelectionChanged(True);
  FWorkSpace.DrawPage(dmSelection);
end;

procedure TRMDesignerForm.padEditReplaceClick(Sender: TObject);
begin
  if Tab1.TabIndex = 0 then
  begin
  end
  else
  begin
    if FFindReplaceForm = nil then
    begin
      FFindReplaceForm := TRMFindReplaceForm.Create(Self);
      TRMFindReplaceForm(FFindReplaceForm).OnModifyView := OnFindReplaceView;
    end;
    FFindReplaceForm.Show;
  end;
end;

procedure TRMDesignerForm.itmEditLockControlsClick(Sender: TObject);
begin
  if FDesignerComp = nil then Exit;
  if itmEditLockControls.Checked then
  begin
    if FSaveDesignerRestrictions * [rmdrDontSizeObj, rmdrDontMoveObj] = [] then
      DesignerRestrictions := DesignerRestrictions - [rmdrDontSizeObj, rmdrDontMoveObj];
  end
  else
  begin
    if FSaveDesignerRestrictions * [rmdrDontSizeObj, rmdrDontMoveObj] = [] then
      DesignerRestrictions := FSaveDesignerRestrictions + [rmdrDontSizeObj, rmdrDontMoveObj];
  end;
end;

procedure TRMDesignerForm.btnBringtoFrontClick(Sender: TObject);
var
  i, j, n: Integer;
  t: TRMView;
begin
  AddUndoAction(acZOrder);
  n := Objects.Count - 1;
  i := 0;
  for j := 0 to n do
  begin
    t := Objects[i];
    if t.Selected then
    begin
      Objects.Delete(i);
      Objects.Add(t);
    end
    else
      Inc(i);
  end;

  Modified := True;
  SendBandsToDown;
  RedrawPage;
end;

procedure TRMDesignerForm.btnSendtoBackClick(Sender: TObject);
var
  t: TRMView;
  i, j, n: Integer;
begin
  AddUndoAction(acZOrder);
  n := Objects.Count;
  j := 0;
  i := n - 1;
  while j < n do
  begin
    t := Objects[i];
    if t.Selected then
    begin
      Objects.Delete(i);
      Objects.Insert(0, t);
    end
    else
      Dec(i);
    Inc(j);
  end;

  Modified := True;
  SendBandsToDown;
  RedrawPage;
end;

procedure TRMDesignerForm.padOptionsClick(Sender: TObject);
var
  liSaveShowBandTitles: Boolean;
  liOldPage: Integer;
  tmp: TRMDesOptionsForm;
begin
  liSaveShowBandTitles := RMShowBandTitles;
  liOldPage := FCurPage;
  tmp := TRMDesOptionsForm.Create(nil);
  try
    tmp.CB1.Checked := ShowGrid;
    tmp.CB2.Checked := GridAlign;
    case GridSize of
      4: tmp.RB1.Checked := True;
      8: tmp.RB2.Checked := True;
      18: tmp.RB3.Checked := True;
    end;
    case RMUnits of
      rmutScreenPixels: tmp.RB6.Checked := True;
      rmutInches: tmp.RB7.Checked := True;
      rmutMillimeters: tmp.RB8.Checked := True;
      rmutMMThousandths: tmp.RB9.Checked := True;
    end;
    tmp.CB5.Checked := RM_Class.RMShowBandTitles;
    tmp.CB7.Checked := RM_Class.RMLocalizedPropertyNames;
    tmp.chkAutoOpenLastFile.Checked := AutoOpenLastFile;
    tmp.chkAutoChangeBandPos.Checked := AutoChangeBandPos;
    tmp.WorkSpaceColor := WorkSpaceColor;
    tmp.InspColor := InspFormColor;

    if tmp.ShowModal = mrOK then
    begin
      ShowGrid := tmp.CB1.Checked;
      GridAlign := tmp.CB2.Checked;
      if tmp.RB1.Checked then
        GridSize := 4
      else if tmp.RB2.Checked then
        GridSize := 8
      else
        GridSize := 18;

      if tmp.RB6.Checked then
        RMUnits := rmutScreenPixels
      else if tmp.RB7.Checked then
        RMUnits := rmutInches
      else if tmp.RB8.Checked then
        RMUnits := rmutMillimeters
      else
        RMUnits := rmutMMThousandths;
      RM_Class.RMShowBandTitles := tmp.CB5.Checked;
      RM_Class.RMLocalizedPropertyNames := tmp.CB7.Checked;
      AutoOpenLastFile := tmp.chkAutoOpenLastFile.Checked;
      AutoChangeBandPos := False; //tmp.chkAutoChangeBandPos.Checked;
      WorkSpaceColor := tmp.WorkSpaceColor;
      InspFormColor := tmp.InspColor;

      FHRuler.Units := RMUnits;
      FVRuler.Units := RMUnits;
      if liSaveShowBandTitles <> RMShowBandTitles then
        FCurPage := -1;
      CurPage := liOldPage;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMDesignerForm.padAboutClick(Sender: TObject);
begin
  if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnShowAboutForm) then
    FDesignerComp.OnShowAboutForm(nil)
  else
    TRMFormAbout.Create(Application).ShowModal;
end;

procedure TRMDesignerForm.DoFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  lStepX, lStepY: Integer;
  i, tx, ty, tx1, ty1, d, d1: Integer;
  t, t1: TRMView;
begin
  lStepX := 0;
  lStepY := 0;
  if (Key = vk_F11) and (Shift = []) then
  begin
    Pan5Click(Pan5);
  end
  else if (Key = vk_Escape) and (not FWorkSpace.MouseButtonDown) then
  begin
    ToolbarComponent.btnNoSelect.Down := True;
    FWorkSpace.Perform(CM_MOUSELEAVE, 0, 0);
    FWorkSpace.OnMouseMoveEvent(nil, [], 0, 0);
    UnselectAll;
    RedrawPage;
    SelectionChanged(True);
  end
    //  else if Key = vk_F9 then
    //    ToolbarStandard.btnPreview.Click
  else if (Key = vk_Return) and (ActiveControl = FcmbFontSize) then
  begin
    Key := 0;
    DoClick(FcmbFontSize);
  end
  else if (((Key = vk_Return) and (ssCtrl in Shift)) or (Key = vk_F2)) and EditEnabled then
  begin
    if ssCtrl in Shift then
      ShowMemoEditor(nil)
    else
      ShowEditor;
  end
  else if (Key = vk_Delete) and DelEnabled then
  begin
    FWorkSpace.DeleteObjects(True);
    Key := 0;
  end
  else if (Chr(Key) = 'F') and (ssCtrl in Shift) and DelEnabled then
  begin
    ToolbarBorder.btnSetFrame.Click;
    Key := 0;
  end
  else if (Chr(Key) = 'D') and (ssCtrl in Shift) and DelEnabled then
  begin
    ToolbarBorder.btnNoFrame.Click;
    Key := 0;
  end
  else if (Chr(Key) = 'G') and (ssCtrl in Shift) then
  begin
    ShowGrid := not ShowGrid;
    Key := 0;
  end
  else if (ssCtrl in Shift) and EditEnabled then
  begin
    if Chr(Key) = 'B' then
    begin
      btnFontBold.Down := not btnFontBold.Down;
      DoClick(btnFontBold);
    end
    else if Chr(Key) = 'I' then
    begin
      btnFontItalic.Down := not btnFontItalic.Down;
      DoClick(btnFontItalic);
    end
    else if Chr(Key) = 'U' then
    begin
      btnFontUnderline.Down := not btnFontUnderline.Down;
      DoClick(btnFontUnderline);
    end;
  end;

  if CutEnabled then
  begin
    if (Key = vk_Delete) and (ssShift in Shift) then
      ToolbarStandard.btnCut.Click;
  end;
  if CopyEnabled then
  begin
    if (Key = vk_Insert) and (ssCtrl in Shift) then
      ToolbarStandard.btnCopy.Click;
  end;
  if PasteEnabled then
  begin
    if (Key = vk_Insert) and (ssShift in Shift) then
      ToolbarStandard.btnPaste.Click;
  end;
  if Key = vk_Prior then
  begin
    with ScrollBox1.VertScrollBar do
    begin
      Position := Position - 200;
      Key := 0;
    end;
  end
  else if Key = vk_Next then
  begin
    with ScrollBox1.VertScrollBar do
    begin
      Position := Position + 200;
      Key := 0;
    end;
  end;

  if SelNum > 0 then
  begin
    if Key = vk_Up then
      lStepY := -1
    else if Key = vk_Down then
      lStepY := 1
    else if Key = vk_Left then
      lStepX := -1
    else if Key = vk_Right then
      lStepX := 1;
    if (lStepX <> 0) or (lStepY <> 0) then
    begin
      if ssCtrl in Shift then
        MoveObjects(lStepX, lStepY, False)
      else if ssShift in Shift then
        MoveObjects(lStepX, lStepY, True)
      else if SelNum = 1 then
      begin
        t := Objects[TopSelected];
        tx := t.spLeft_Designer;
        ty := t.spTop_Designer;
        tx1 := t.spRight_Designer;
        ty1 := t.spBottom_Designer;
        d := 10000;
        t1 := nil;
        for i := 0 to Objects.Count - 1 do
        begin
          t := Objects[i];
          if not t.Selected and (not t.IsBand) then
          begin
            d1 := 10000;
            if lStepX <> 0 then
            begin
              if t.spBottom_Designer < ty then
                d1 := ty - (t.spBottom_Designer)
              else if t.spTop_Designer > ty1 then
                d1 := t.spTop_Designer - ty1
              else if (t.spTop_Designer <= ty) and (t.spBottom_Designer >= ty1) then
                d1 := 0
              else
                d1 := t.spTop_Designer - ty;
              if ((t.spLeft_Designer <= tx) and (lStepX = 1)) or
                ((t.spRight_Designer >= tx1) and (lStepX = -1)) then
                d1 := 10000;
              if lStepX = 1 then
              begin
                if t.spLeft_Designer >= tx1 then
                  d1 := d1 + t.spLeft_Designer - tx1
                else
                  d1 := d1 + t.spLeft_Designer - tx;
              end
              else if t.spRight_Designer <= tx then
                d1 := d1 + tx - t.spRight_Designer
              else
                d1 := d1 + tx1 - t.spRight_Designer;
            end
            else if lStepY <> 0 then
            begin
              if t.spRight_Designer < tx then
                d1 := tx - t.spRight_Designer
              else if t.spLeft_Designer > tx1 then
                d1 := t.spLeft_Designer - tx1
              else if (t.spLeft_Designer <= tx) and (t.spRight_Designer >= tx1) then
                d1 := 0
              else
                d1 := t.spLeft_Designer - tx;
              if ((t.spTop_Designer <= ty) and (lStepY = 1)) or ((t.spBottom_Designer >= ty1) and (lStepY = -1)) then
                d1 := 10000;
              if lStepY = 1 then
              begin
                if t.spTop_Designer >= ty1 then
                  d1 := d1 + t.spTop_Designer - ty1
                else
                  d1 := d1 + t.spTop_Designer - ty;
              end
              else if t.spBottom_Designer <= ty then
                d1 := d1 + ty - t.spBottom_Designer
              else
                d1 := d1 + ty1 - t.spBottom_Designer;
            end;
            if d1 < d then
            begin
              d := d1;
              t1 := t;
            end;
          end;
        end;
        if t1 <> nil then
        begin
          t := Objects[TopSelected];
          if not (ssAlt in Shift) then
          begin
            FWorkSpace.DrawPage(dmSelection);
            UnselectAll;
            SelNum := 1;
            t1.Selected := True;
            FWorkSpace.DrawPage(dmSelection);
          end
          else
          begin
            if (t1.spLeft_Designer >= t.spRight_Designer) and (Key = vk_Right) then
              t.spLeft_Designer := t1.spLeft_Designer - t.spWidth_Designer
            else if (t1.spTop_Designer > t.spBottom_Designer) and (Key = vk_Down) then
              t.spTop_Designer := t1.spTop_Designer - t.spHeight_Designer
            else if (t1.spRight_Designer <= t.spLeft_Designer) and (Key = vk_Left) then
              t.spLeft_Designer := t1.spRight_Designer
            else if (t1.spBottom_Designer <= t.spTop_Designer) and (Key = vk_Up) then
              t.spTop_Designer := t1.spBottom_Designer;
            RedrawPage;
          end;
          SelectionChanged(True);
        end;
      end;
    end;
  end;
end;

procedure TRMDesignerForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DoFormKeyDown(Sender, Key, Shift);
end;

{$IFDEF Delphi4}

procedure TRMDesignerForm.OnFormMouseWheelUpEvent(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position - 8 * 2;
end;

procedure TRMDesignerForm.OnFormMouseWheelDownEvent(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position + 8 * 2;
end;
{$ENDIF}

procedure TRMDesignerForm.padFilePropertyClick(Sender: TObject);
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

procedure TRMDesignerForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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
    else if ToolbarModifyPrepared.btnAutoSave.Down then
      w := mrYes
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
          else // 预览时编辑
          begin
            Report.EndPages[EndPageNo].ObjectsToStream(Report);
            Report.CanRebuild := False;
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

procedure TRMDesignerForm.SpeedButton1Click(Sender: TObject);
begin
  //  LinePanel.Hide;
  //  DoClick(Sender);
end;

procedure TRMDesignerForm.padFileNewClick(Sender: TObject);
var
  tmpWizard: TRMCustomReportWizard;
  tmp: TRMTemplForm;
begin
  if (FDesignerComp <> nil) and (FDesignerComp.DesignerRestrictions * [rmdrDontCreateReport] <> []) then
    Exit;

  if FDesignerComp <> nil then
    RMTemplateDir := FDesignerComp.TemplateDir;

  tmp := TRMTemplForm.Create(nil);
  try
    tmp.CurrentReport := Report;
    tmp.FileExt := '*.rmt';
    tmp.ReportType := 1;
    if tmp.ShowModal = mrOk then
    begin
      ToolbarComponent.btnNoSelect.Click;
      ClearUndoBuffer;
      ClearRedoBuffer;
      if tmp.atype = 1 then
      begin
        if Length(tmp.TemplName) > 0 then
        begin
          Report.LoadTemplate(tmp.TemplName, nil, nil);
          CurDocName := RMLoadStr(SUntitled);
          CurPage := 0;
          SetObjectsID;
        end
        else
          ToolbarStandard.BtnFileNew.Click;
      end
      else
      begin
        tmpWizard := tmp.WizardClass.Create;
        try
          tmpWizard.DoCreateReport;
          SetObjectsID;
        finally
          tmpWizard.Free;
        end;
      end;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMDesignerForm.Tab1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  HitTestInfo: TTCHitTestInfo;
  HitIndex: Integer;
begin
  Accept := Source = Tab1;
  if Accept then
  begin
    HitTestInfo.pt := Point(X, Y);
    HitIndex := SendMessage(Tab1.Handle, TCM_HITTEST, 0, Longint(@HitTestInfo));
    Accept := (HitIndex > 0);
  end;
end;

procedure TRMDesignerForm.Tab1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  i, HitIndex: Integer;
  HitTestInfo: TTCHitTestInfo;

  procedure _ChangeSubReports(aOldSubPage, aNewSubPage: Integer);
  var
    i, j: Integer;
    t: TRMView;
    liPage: TRMCustomPage;
  begin
    for i := 0 to Report.Pages.Count - 1 do
    begin
      liPage := Report.Pages[i];
      if liPage is TRMReportPage then
      begin
        for j := 0 to THackPage(liPage).Objects.Count - 1 do
        begin
          t := THackPage(liPage).Objects[j];
          if (t is TRMSubReportView) and (TRMSubReportView(t).SubPage = aOldSubPage) then
            TRMSubReportView(t).SubPage := aNewSubPage;
        end;
      end;
    end;
  end;

begin
  HitTestInfo.pt := Point(X, Y);
  HitIndex := SendMessage(Tab1.Handle, TCM_HITTEST, 0, Longint(@HitTestInfo));
  if (HitIndex <= 1) or (HitIndex = Tab1.TabIndex) then Exit;

  Dec(HitIndex);
  if CurPage > HitIndex then
  begin
    _ChangeSubReports(CurPage, -1);
    for i := CurPage - 1 downto HitIndex do
      _ChangeSubReports(i, i + 1);
    _ChangeSubReports(-1, HitIndex);
  end
  else
  begin
    _ChangeSubReports(CurPage, -1);
    for i := CurPage + 1 to HitIndex do
      _ChangeSubReports(i, i - 1);
    _ChangeSubReports(-1, HitIndex);
  end;

  Tab1.Tabs.Move(CurPage + 1, HitIndex + 1);
  Report.Pages.Move(CurPage, HitIndex);
  CurPage := HitIndex;
  Modified := True;
end;

procedure TRMDesignerForm.Tab1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMouseDown := False;
end;

procedure TRMDesignerForm.Tab1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Tab1.TabIndex > 0) and FMouseDown then
    Tab1.BeginDrag(False);
end;

procedure TRMDesignerForm.Tab1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    FMouseDown := True;
end;

procedure TRMDesignerForm.padSetToolbarClick(Sender: TObject);
begin
  Pan1.Checked := ToolbarBorder.Visible;
  Pan2.Checked := ToolbarStandard.Visible;
  Pan3.Checked := ToolbarEdit.Visible;
  Pan4.Checked := ToolbarComponent.Visible;
  Pan5.Checked := FInspForm.Visible;
  Pan6.Checked := ToolbarAlign.Visible;
  Pan7.Checked := ToolBarAddinTools.Visible;
  Pan8.Checked := ToolBarSize.Visible;
  Pan9.Checked := FFieldForm.Visible;
end;

procedure TRMDesignerForm.padVarListClick(Sender: TObject);
var
  tmp: TRMDictionaryForm;
begin
  if (FDesignerComp <> nil) and (FDesignerComp.DesignerRestrictions * [RMdrDontEditVariables] <> []) then
    Exit;
  tmp := TRMDictionaryForm.Create(nil);
  try
    tmp.Report := Report;
    if tmp.ShowModal = mrOk then
    begin
      Modified := True;
      if FFieldForm.VIsible then
        FFieldForm.RefreshData;
    end;
  finally
    tmp.Free;
  end;
end;

procedure TRMDesignerForm.LoadDictionary1Click(Sender: TObject);
begin
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := RMLoadStr(SDictFile) + ' (*.rmd)|*.rmd';
  if (FDesignerComp <> nil) and (FDesignerComp.OpenDir <> '') then
    OpenDialog1.InitialDir := FDesignerComp.OpenDir;
  if OpenDialog1.Execute then
    Report.Dictionary.LoadFromFile(OpenDialog1.FileName);
end;

procedure TRMDesignerForm.MergeDictionary1Click(Sender: TObject);
begin
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := RMLoadStr(SDictFile) + ' (*.rmd)|*.rmd';
  if (FDesignerComp <> nil) and (FDesignerComp.OpenDir <> '') then
    OpenDialog1.InitialDir := FDesignerComp.OpenDir;
  if OpenDialog1.Execute then
    Report.Dictionary.MergeFromFile(OpenDialog1.FileName);
end;

procedure TRMDesignerForm.SaveAsDictionary1Click(Sender: TObject);
begin
  SaveDialog1.FileName := '';
  SaveDialog1.Filter := RMLoadStr(SDictFile) + ' (*.rmd)|*.rmd';
  if (FDesignerComp <> nil) and (FDesignerComp.SaveDir <> '') then
    SaveDialog1.InitialDir := FDesignerComp.SaveDir;
  SaveDialog1.FileName := CurDocName;
  if SaveDialog1.Execute then
    Report.Dictionary.SaveToFile(ChangeFileExt(SaveDialog1.FileName, '.rmd'));
end;

procedure TRMDesignerForm.ToolBarPopMenuPopup(Sender: TObject);
begin
  ToolBarPopStandard.Checked := ToolBarStandard.Visible;
  ToolBarPopEdit.Checked := ToolBarEdit.Visible;
  ToolBarPopBorder.Checked := ToolBarBorder.Visible;
  ToolBarPopAlign.Checked := ToolBarAlign.Visible;
  ToolBarPopAddinTools.Checked := ToolBarAddinTools.Visible;
  ToolBarPopComponent.Checked := ToolBarComponent.Visible;
  ToolBarPopInsp.Checked := FInspForm.Visible;
  ToolbarPopSize.Checked := ToolBarSize.Visible;
  ToolBarPopInsDBField.Checked := Pan9.Checked;
  ToolbarPopModifyPrepared.Checked := ToolbarModifyPrepared.Visible;
end;

procedure TRMDesignerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (FDesignerComp <> nil) and Assigned(FDesignerComp.OnClose) then
    FDesignerComp.OnClose(Self);
end;

procedure TRMDesignerForm.padSearchFindClick(Sender: TObject);
begin
  ShowSearchReplaceDialog(False);

  //  FindDialog1.FindText := FCodeMemo.GetWordOnCaret;
  //  FindDialog1.Execute;
end;

procedure TRMDesignerForm.padSearchReplaceClick(Sender: TObject);
begin
  ShowSearchReplaceDialog(True);
  //ReplaceDialog1.Execute;
end;

procedure TRMDesignerForm.padSearchFindAgainClick(Sender: TObject);
begin
  DoSearchReplaceText(False, False);
end;

initialization
  FDesignerComp := nil;
  RMDesignerClass := TRMDesignerForm;

  RM_LastFrameWidth := RMToMMThousandths(1, rmutScreenPixels);
  RM_LastFillColor := clNone;
  RM_LastFrameColor := clBlack;
  RM_LastFontColor := clBlack;
  RM_LastFontStyle := 0;
  RM_LastFontCharset := StrToInt(RMLoadStr(SCharset)); //RMCharset;
  RM_LastHAlign := rmHLeft;
  RM_LastVAlign := rmVTop;
  RMShowBandTitles := True;

finalization

end.

