
{*****************************************}
{                                         }
{             Report Machine v2.0         }
{             Report preview Dlg          }
{                                         }
{*****************************************}

unit RM_Preview;

interface

{$I RM.inc}
{$R RMACHINE.RES}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, Buttons, ComCtrls, RM_Common, RM_Ctrls
  {$IFDEF Delphi4}, ImgList{$ENDIF};

type
  TRMPreview = class;
  TRMBeforeShowReport = procedure(aReport: TObject) of object;

  { TRMDrawPanel }
  TRMDrawPanel = class(TPanel)
  private
    FSaveEndPage: TObject;
    FSaveFoundView: TObject;
    FSavePageNo: Integer;

    FPreview: TRMPreview;
    FDown, FDoubleClickFlag: Boolean;
    FLastX, FLastY: Integer;
    FInPainting: Boolean;
    FHRulerOffset, FVRulerOffset: Integer;
    FVisiblePages: array of Integer;
    FBusy: Boolean;

    procedure WMEraseBackground(var Message: TMessage); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DblClick; override;
  end;

  PRMPreviewNodeDataInfo = ^TRMPreviewNodeDataInfo;
  TRMPreviewNodeDataInfo = record
    PageNo: Integer;
    Position: Integer;
  end;

  { TRMPreview }
  TRMPreview = class(TRMCustomPreview)
  private
    FReport: TObject;
    FCurPage: Integer;
    FOffsetLeft, FOffsetTop, FOldVPos, FOldHPos: Integer;
    FScale: Double;
    FZoomMode: TRMScaleMode;
    FPaintAllowed: Boolean;
    FLastScale: Double;
    FSaveReportInfo: TRMReportInfo;

    FScrollBox: TRMScrollBox;
    FStatusBar: TStatusBar;
    FTopPanel1: TPanel;
    FLeftTopPanel: TPanel;
    FLeftPanel: TPanel;
    FTopPanel: TPanel;
    FHRuler, FVRuler: TRMDesignerRuler;
    FDrawPanel: TRMDrawPanel;
    FSplitter: TSplitter;
    FOutlineTreeView: TTreeView;

    FKWheel: Integer;
    FParentForm: TForm;
    FInitialDir: string;

    FOnStatusChange: TNotifyEvent;
    FOnPageChanged: TNotifyEvent;
    FOnAfterPageSetup: TNotifyEvent;
    FOnBeforeShowReport: TRMBeforeShowReport;

    FStrFound: Boolean;
    FStrBounds: TRect;
    FFindStr: string;
    FCaseSensitive: Boolean;
    FWholewords: Boolean;
    FLastFoundPage, FLastFoundObject: Integer;

    procedure DoStatusChange;
    procedure Connect_1(aReport: TObject);
    procedure SetPage(Value: Integer);
    function GetZoom: Double;
    procedure SetZoom(Value: Double);
    function GetTotalPages: Integer;
    function GetHScrollBar: TRMScrollBar;
    function GetVScrollBar: TRMScrollBar;

    procedure ClearOutLine;
    procedure OnOutlineClickEvent(Sender: TObject);

    procedure FindInEMF(lEmf: TMetafile);
    procedure ShowPageNum;
    procedure SetToCurPage;
    procedure OnResizeEvent(Sender: TObject);
    procedure OnScrollBoxScroll(Sender: TObject; Kind: TRMScrollBarKind);

    {$IFDEF Delphi4}
    procedure OnMouseWheelUpEvent(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure OnMouseWheelDownEvent(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    {$ENDIF}
  protected
    procedure Disconnect;
    function GetEndPages: TObject;
    property OnAfterPageSetup: TNotifyEvent read FOnAfterPageSetup write FOnAfterPageSetup;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CanModify: Boolean;
    procedure ShowReport(aReport: TObject); override;
    procedure Connect(aReport: TObject); override;

    procedure RedrawAll(ResetPage: Boolean);
    procedure OnePage;
    procedure TwoPages;
    procedure PageWidth;
    procedure PrinterZoom;
    procedure First;
    procedure Next;
    procedure Prev;
    procedure Last;
    procedure LoadFromFile(aFileName: string);
    procedure LoadFromFiles(aFileNames: TStrings);
    procedure SaveToFile(aFileName: string; aIndex: Integer);
    procedure ExportToFile(aExport: TComponent; aFileName: string);
    procedure ExportToXlsFile;
    procedure Print; override;
    procedure PrintCurrentPage;
    procedure DlgPageSetup;
    procedure InsertPageBefore;
    procedure InsertPageAfter;
    procedure AddPage;
    procedure DeletePage(PageNo: Integer);
    function EditPage(PageNo: Integer): Boolean;
    procedure DesignReport;
    procedure Find;
    procedure FindNext;
    procedure ShowOutline(aVisible: Boolean);

    property ParentForm: TForm read FParentForm write FParentForm;
    property KWheel: Integer read FKWheel write FKWheel;
    property Report: TObject read FReport;
    property TotalPages: Integer read GetTotalPages;
    property Zoom: Double read GetZoom write SetZoom;
    property ZoomMode: TRMScaleMode read FZoomMode write FZoomMode;
    property LastScale: Double read FLastScale write FLastScale;
    property ScrollBox: TRMScrollBox read FScrollBox;
    property HScrollBar: TRMScrollBar read GetHScrollBar;
    property VScrollBar: TRMScrollBar read GetVScrollBar;
    property CurPage: Integer read FCurPage write SetPage;
    //    property OutlineTreeView: TTreeView read FOutlineTreeView;

    property FindStr: string read FFindStr write FFindstr;
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property Wholewords: Boolean read FWholewords write FWholewords;
    property LastFoundPage: Integer read FLastFoundPage write FLastFoundPage;
    property LastFoundObject: Integer read FLastFoundObject write FLastFoundObject;
    property StrFound: Boolean read FStrFound write FStrFound;
    property StrBounds: TRect read FStrBounds write FStrBounds;
  published
    property InitialDir: string read FInitialDir write FInitialDir;
    property OnPageChanged: TNotifyEvent read FOnPageChanged write FOnPageChanged;
    property OnStatusChange: TNotifyEvent read FOnStatusChange write FOnStatusChange;
    property OnBeforeShowReport: TRMBeforeShowReport read FOnBeforeShowReport write FOnBeforeShowReport;
  end;

  { TRMPreviewForm }
  TRMPreviewForm = class(TForm)
    ProcMenu: TPopupMenu;
    itmScale200: TMenuItem;
    itmScale150: TMenuItem;
    itmScale100: TMenuItem;
    itmScaale75: TMenuItem;
    itmScale50: TMenuItem;
    itmScale25: TMenuItem;
    itmScale10: TMenuItem;
    itmPageWidth: TMenuItem;
    itmOnePage: TMenuItem;
    itmDoublePage: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    N1: TMenuItem;
    itmNewPage: TMenuItem;
    itmDeletePage: TMenuItem;
    itmEditPage: TMenuItem;
    N4: TMenuItem;
    itmPrint: TMenuItem;
    itmPrintCurrentPage: TMenuItem;
    InsertBefore1: TMenuItem;
    InsertAfter1: TMenuItem;
    N2: TMenuItem;
    Append1: TMenuItem;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure itmScale10Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure itmDeletePageClick(Sender: TObject);
    procedure itmEditPageClick(Sender: TObject);
    procedure ProcMenuPopup(Sender: TObject);
    procedure itmPrintCurrentPageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure InsertBefore1Click(Sender: TObject);
    procedure InsertAfter1Click(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnTopClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure btn100Click(Sender: TObject);
    procedure btnOnePageClick(Sender: TObject);
    procedure btnPageWidthClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnPageSetupClick(Sender: TObject);
    procedure btnShowOutlineClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure btnDesignClick(Sender: TObject);
    procedure CmbZoomKeyPress(Sender: TObject; var Key: Char);
    procedure CmbZoomClick(Sender: TObject);
    procedure edtPageNoKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveToXLSClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FDoc: Pointer;
    FViewer: TRMPreview;

    Dock971: TRMDock;
    ToolbarStand: TRMToolbar;
    btnOnePage: TRMToolbarButton;
    BtnExit: TRMToolbarButton;
    btn100: TRMToolbarButton;
    ToolbarSep1: TRMToolbarSep;
    btnPageSetup: TRMToolbarButton;
    btnShowOutline: TRMToolbarButton;
    btnPageWidth: TRMToolbarButton;
    ToolbarSep972: TRMToolbarSep;
    btnPrint: TRMToolbarButton;
    ToolbarSep973: TRMToolbarSep;
    btnTop: TRMToolbarButton;
    btnSave: TRMToolbarButton;
    btnPrev: TRMToolbarButton;
    btnOpen: TRMToolbarButton;
    btnNext: TRMToolbarButton;
    btnLast: TRMToolbarButton;
    btnFind: TRMToolbarButton;
    btnSaveToXLS: TRMToolbarButton;
    btnDesign: TRMToolbarButton;
    ToolbarSep974: TRMToolbarSep;
    ToolbarSep975: TRMToolbarSep;
    tbLine: TRMToolbarSep;
    ToolbarSep971: TRMToolbarSep;
    cmbZoom: TRMComboBox97;
    edtPageNo: TRMEdit;

    FBtnShowBorder: TRMToolbarButton;
    FBtnBackColor: TRMColorPickerButton;
    tbSep1: TRMToolbarSep;

    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure OnStatusChange(Sender: TObject);
    procedure OnPageChanged(Sender: TObject);
    procedure Localize;
    procedure btnShowBorderClick(Sender: TObject);
    procedure btnBackColorClick(Sender: TObject);
    procedure SaveIni;
    procedure LoadIni;
  public
    { Public declarations }
    procedure Execute(ADoc: Pointer);
    property Viewer: TRMPreview read FViewer;
    property Report: Pointer read FDoc;
  end;

implementation

{$R *.DFM}

uses
  ShellAPI, Registry, RM_Const, RM_Const1, RM_Class, RM_Printer, RM_PrintDlg,
  RM_Utils, RM_PageSetup, RM_DlgFind;

type
  THackReport = class(TRMReport)
  end;

  THackEndPages = class(TRMEndPages)
  end;

  THackEndPage = class(TRMEndPage)
  end;

  THackReportView = class(TRMReportView)
  end;

var
  //  FcrMagnifier: Integer = 0;
  FCurPreview: TRMPreview;
  FRecordNum: Integer;
  FLastExportIndex: Integer = 1;

  {------------------------------------------------------------------------------}
  {------------------------------------------------------------------------------}
  { TRMDrawPanel }

constructor TRMDrawPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSaveFoundView := nil;
  FBusy := False;
  FInPainting := False;
  FHRulerOffset := 0;
  FVRulerOffset := 0;
  SetLength(FVisiblePages, 0);
end;

procedure TRMDrawPanel.WMEraseBackground(var Message: TMessage);
begin
end;

const
  PenStyles: array[Low(TPenStyle)..High(TPenStyle)] of DWORD =
  (PS_SOLID, PS_DASH, PS_DOT, PS_DASHDOT, PS_DASHDOTDOT, PS_NULL, PS_INSIDEFRAME);

procedure TRMDrawPanel.Paint;
var
  i: Integer;
  lRect, lRect1: TRect;
  lPages: TRMEndPages;
  lPage: TRMEndPage;
  lhRgn: HRGN;
  lScale: Double;
  ltb, lbr: {$IFDEF Delphi4}tagLOGBRUSH{$ELSE}TLogBrush{$ENDIF};
  lNewH, lOldH: HGDIOBJ;
  lnbr, lobr: HBRUSH;
  //  lSavePages: array of Integer;

  procedure _SetPS;
  begin
    ltb.lbStyle := BS_SOLID;
    ltb.lbColor := Canvas.Pen.Color;
    lNewH := ExtCreatePen(PS_GEOMETRIC + PS_ENDCAP_SQUARE + PenStyles[Canvas.Pen.Style], Canvas.Pen.Width, ltb, 0, nil);
    lOldH := SelectObject(Canvas.Handle, lNewH);
  end;

  procedure _SetRuler(aPageNo: Integer);
  var
    lRect: TRect;
  begin
    if not FPreview.Options.RulerVisible then Exit;

    lRect := lPages[aPageNo - 1].PageRect;
    OffsetRect(lRect, FPreview.FOffsetLeft, FPreview.FOffsetTop);

    FPreview.FHRuler.Scale := lScale;
    FPreview.FVRuler.Scale := lScale;
    FPreview.FHRuler.Left := lRect.Left;
    FPreview.FVRuler.Top := lRect.Top;
    FPreview.FHRuler.Width := lRect.Right - lRect.Left;
    FPreview.FVRuler.Height := lRect.Bottom - lRect.Top;

    FPreview.FHRuler.ScrollOffset := 0;
    FPreview.FVRuler.ScrollOffset := 0;
    FHRulerOffset := 10 - lRect.Left;
    FVRulerOffset := 10 - lRect.Top;
  end;

  procedure _DrawMargins;
  begin
    with lPage, lPage.PrinterInfo do
    begin
      lRect1.Left := RMToScreenPixels(mmMarginLeft * lScale, rmutMMThousandths);
      lRect1.Top := RMToScreenPixels(mmMarginTop * lScale, rmutMMThousandths);
      lRect1.Right := Round((PageWidth - RMToScreenPixels(mmMarginRight, rmutMMThousandths)) * lScale);
      lRect1.Bottom := Round((PageHeight - RMToScreenPixels(mmMarginBottom, rmutMMThousandths)) * lScale);

      OffsetRect(lRect1, lRect.Left, lRect.Top);
    end;

    with Canvas do
    begin
      Pen.Width := 1;
      Pen.Color := clGray;
      Pen.Style := psSolid;
      MoveTo(lRect1.Left, lRect1.Top);
      LineTo(lRect1.Left, lRect1.Top - Round(20 * lScale)); //左上
      MoveTo(lRect1.Left, lRect1.Top);
      LineTo(lRect1.Left - Round(20 * lScale), lRect1.Top);
      MoveTo(lRect1.Right, lRect1.Top);
      LineTo(lRect1.Right, lRect1.Top - Round(20 * lScale)); //右上
      MoveTo(lRect1.Right, lRect1.Top);
      LineTo(lRect1.Right + Round(20 * lScale), lRect1.Top);
      MoveTo(lRect1.Left, lRect1.Bottom);
      LineTo(lRect1.Left, lRect1.Bottom + Round(20 * lScale)); //左下
      MoveTo(lRect1.Left, lRect1.Bottom);
      LineTo(lRect1.Left - Round(20 * lScale), lRect1.Bottom);
      MoveTo(lRect1.Right, lRect1.Bottom);
      LineTo(lRect1.Right, lRect1.Bottom + Round(20 * lScale)); //右下
      MoveTo(lRect1.Right, lRect1.Bottom);
      LineTo(lRect1.Right + Round(20 * lScale), lRect1.Bottom);
    end;

    if FPreview.Options.DrawBorder then
    begin
      Canvas.Pen.Width := FPreview.Options.BorderPen.Width;
      Canvas.Pen.Color := FPreview.Options.BorderPen.Color;
      Canvas.Pen.Style := FPreview.Options.BorderPen.Style;
      if Canvas.Pen.Width = 1 then
        Canvas.Rectangle(lRect1.Left, lRect1.Top, lRect1.Right + 1, lRect1.Bottom + 1)
      else
      begin
        lRect1.Left := lRect1.Left - Canvas.Pen.Width div 2;
        lRect1.Right := lRect1.Right + Canvas.Pen.Width div 2;
        lRect1.Top := lRect1.Top - Canvas.Pen.Width div 2;
        lRect1.Bottom := lRect1.Bottom + Canvas.Pen.Width div 2;

        _SetPS;
        lbr.lbStyle := BS_NULL;
        lnbr := CreateBrushIndirect(lbr);
        lobr := SelectObject(Canvas.Handle, lnbr);

        Windows.MoveToEx(Canvas.Handle, lRect1.Left, lRect1.Top, nil); // Left
        Windows.LineTo(Canvas.Handle, lRect1.Left, lRect1.Bottom);

        Windows.MoveToEx(Canvas.Handle, lRect1.Left, lRect1.Top, nil); // Top
        Windows.LineTo(Canvas.Handle, lRect1.Right, lRect1.Top);

        Windows.MoveToEx(Canvas.Handle, lRect1.Right, lRect1.Top, nil); // Right
        Windows.LineTo(Canvas.Handle, lRect1.Right, lRect1.Bottom);

        Windows.MoveToEx(Canvas.Handle, lRect1.Left, lRect1.Bottom, nil); // Bottom
        Windows.LineTo(Canvas.Handle, lRect1.Right, lRect1.Bottom);

        SelectObject(Canvas.Handle, lobr);
        DeleteObject(lnbr);
        SelectObject(Canvas.Handle, lOldH);
        DeleteObject(lNewH);
      end;
    end;
  end;

  procedure _DrawbkPicture;
  var
    lbkPic: TRMbkPicture;
    lPic: TPicture;
    lPicWidth, lPicHeight: Integer;
  begin
    lbkPic := lPages.bkPictures[lPage.bkPictureIndex];
    if lbkPic = nil then Exit;

    lPic := lbkPic.Picture;
    if lPic.Graphic <> nil then
    begin
      lPicWidth := lbkPic.Width;
      lPicHeight := lbkPic.Height;

      lRect1 := Rect(0, 0, Round(lPicWidth * lScale), Round(lPicHeight * lScale));
      OffsetRect(lRect1, Round(lbkPic.Left * lScale), Round(lbkPic.Top * lScale));
      OffsetRect(lRect1, lRect.Left, lRect.Top);
      try
        IntersectClipRect(Canvas.Handle, lRect.Left + 1, lRect.Top + 1,
          lRect.Right - 1, lRect.Bottom - 1);
        RMPrintGraphic(Canvas, lRect1, lPic.Graphic, False, False, False);
      finally
        SelectClipRgn(Canvas.Handle, lhRgn);
      end;
    end;
  end;

begin
  if (not FPreview.FPaintAllowed) or FInPainting then
  begin
    inherited;
    Exit;
  end;

  {  SetLength(lSavePages, Length(FVisiblePages));
    for i := 0 to Length(FVisiblePages) - 1 do
      lSavePages[i] := FVisiblePages[i];}

  SetLength(FVisiblePages, 0);
  if FPreview.GetEndPages = nil then
  begin
    Canvas.Brush.Color := clBtnFace;
    Canvas.FillRect(ClientRect);
    Exit;
  end;

  FInPainting := True;
  lScale := FPreview.FScale;
  lPages := TRMEndPages(FPreview.GetEndPages);
  lhRgn := CreateRectRgn(0, 0, Width, Height); // 创建一个区域
  try
    GetClipRgn(Canvas.Handle, lhRgn);
    for i := 0 to lPages.Count - 1 do
    begin
      lPage := lPages[i];
      lRect := lPage.PageRect;
      OffsetRect(lRect, FPreview.FOffsetLeft, FPreview.FOffsetTop);
      if (lRect.Top > 2000) or (lRect.Bottom < 0) then
        lPage.Visible := False
      else
        lPage.Visible := RectVisible(Canvas.Handle, lRect);

      if lPage.Visible then // 去掉一个矩形区
      begin
        SetLength(FVisiblePages, Length(FVisiblePages) + 1);
        FVisiblePages[Length(FVisiblePages) - 1] := i;
        ExcludeClipRect(Canvas.Handle, lRect.Left + 1, lRect.Top + 1,
          lRect.Right - 1, lRect.Bottom - 1);
      end;
    end;

    if (Length(FVisiblePages) = 0) and
      ((FPreview.CurPage - 1) >= 0) and ((FPreview.CurPage - 1) < lPages.Count) then
    begin
      SetLength(FVisiblePages, 1);
      FVisiblePages[0] := FPreview.CurPage - 1;
    end;

    with Canvas do
    begin
      Brush.Color := clGray;
      FillRect(Rect(0, 0, Width, Height));
      Pen.Color := clBlack;
      Pen.Width := 1;
      Pen.Mode := pmCopy;
      Pen.Style := psSolid;
      Brush.Color := clWhite;
    end;

    SelectClipRgn(Canvas.Handle, lhRgn);
    for i := 0 to Length(FVisiblePages) - 1 do
      //    for i := 0 to lPages.Count - 1 do // drawing page background
    begin
      lPage := lPages[FVisiblePages[i]];
      //      lPage := lPages[i];
      if lPage.Visible then
      begin
        lRect := lPage.PageRect;
        OffsetRect(lRect, FPreview.FOffsetLeft, FPreview.FOffsetTop);
        Canvas.Rectangle(lRect.Left, lRect.Top, lRect.Right, lRect.Bottom);
        Canvas.Polyline([Point(lRect.Left + 1, lRect.Bottom), Point(lRect.Right, lRect.Bottom),
          Point(lRect.Right, lRect.Top + 1)]);

        _DrawMargins;
        _DrawbkPicture;
      end;
    end;

    //    for i := 0 to Length(FVisiblePages) - 1 do
    for i := 0 to lPages.Count - 1 do
    begin
      lPage := lPages[i];
      //lPage := lPages[FVisiblePages[i]];
      if lPage.Visible then
      begin
        lRect := lPage.PageRect;
        OffsetRect(lRect, FPreview.FOffsetLeft, FPreview.FOffsetTop);
        lPage.Draw(TRMReport(FPreview.FReport), Canvas, lRect);
      end
      else
        lPage.RemoveCachePage;
    end;

    {    for i := 0 to Length(lSavePages) - 1 do
        begin
          lPage := lPages[lSavePages[i]];
          if not lPage.Visible then
            lPage.RemoveCachePage;
        end;}

    _SetRuler(FPreview.CurPage);
  finally
    DeleteObject(lhRgn);
    FInPainting := False;
  end;
end;

procedure TRMDrawPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lPageNo: Integer;

  function _GenOnePage: Boolean;
  var
    t: TRMView;
    lReport: TRMReport;
    lModified: Boolean;
    lUrl: string;
  begin
    Result := False;

    lReport := TRMReport(FPreview.Report);
    lModified := False;
    t := TRMView(FSaveFoundView);
    lUrl := THackReportView(t).Url;
    if Length(lUrl) > 0 then
    begin
      if lUrl[1] = '#' then
      begin
      end
      else if lUrl[1] = '@' then // 页码
      begin
        lUrl := RMDeleteNoNumberChar(System.Copy(lUrl, 2, 9999));
        if RMIsNumeric(lUrl) then
        begin
          try
            lPageNo := StrToInt(lUrl);
          except
          end;
        end;
      end
      else // 超级连接
      begin
        ShellExecute(0, nil, PChar(lUrl), nil, nil, SW_RESTORE);
      end;
    end;

    if Assigned(THackReportView(t).OnPreviewClick) then
    begin
      Result := True;
      THackReportView(t).OnPreviewClick(TRMReportView(t), Button, Shift, lModified);
    end;

    if Assigned(lReport.OnObjectClick) then
    begin
      Result := True;
      lReport.OnObjectClick(TRMReportView(t), Button, Shift, lModified);
    end;

    if lModified then // 修改内容了，需要保存
    begin
      TRMEndPage(FSaveEndPage).ObjectsToStream(lReport);
      TRMEndPage(FSaveEndPage).StreamToObjects(lReport, True);
      if FPreview.CurPage = lPageNo then
        FPreview.ReDrawAll(False);
    end;
  end;

begin
  if FBusy or (FPreview.GetEndPages = nil) or (not FPreview.FPaintAllowed) then Exit;

  if FDoubleClickFlag then
  begin
    FDoubleClickFlag := False;
    Exit;
  end;

  FBusy := True;
  try
    if Button = mbLeft then
    begin
      FDown := True;
      lPageNo := FPreview.CurPage;
      if FSaveFoundView <> nil then
      begin
        lPageNo := FSavePageNo;
        if _GenOnePage then
          FDown := False;
      end;

      FLastX := X;
      FLastY := Y;
      FPreview.CurPage := lPageNo;
      FPreview.ShowPageNum;
    end
    else if Button = mbRight then
    begin
    end;
  finally
    FBusy := False;

  end;
end;

procedure TRMDrawPanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  lPoint: TPoint;
  lRect: TRect;
  lEndPages: TRMEndPages;
  lEndPage: TRMEndPage;
  lCursor: TCursor;
  lUrlStr: string;

  function _GenOnePage: Boolean;
  var
    i: Integer;
    t: TRMView;
    lScaleX, lScaleY, lOffsetX, lOffsetY: Double;
  begin
    Result := False;
    if THackEndPage(lEndPage).FPage = nil then Exit;

    lScaleX := 1;
    lScaleY := 1;
    lOffsetX := RMToScreenPixels(lEndPage.mmMarginLeft, rmutMMThousandths);
    lOffsetY := RMToScreenPixels(lEndPage.mmMarginTop, rmutMMThousandths);
    for i := lEndPage.Page.Objects.Count - 1 downto 0 do
    begin
      t := lEndPage.Page.Objects[i];
      if PtInRect(Rect(Round(t.spLeft * lScaleX + lOffsetX), Round(t.spTop * lScaleY + lOffsetY),
        Round(t.spRight * lScaleX + lOffsetX), Round(t.spBottom * lScaleX + lOffsetY)), lPoint) then
      begin
        Result := True;

        FSaveFoundView := t;
        if Length(THackReportView(t).Url) >= 1 then
        begin
          lUrlStr := THackReportView(t).Url;
          lCursor := crHandPoint;
        end
        else
          lCursor := THackReportView(t).Cursor;

        Break;
      end;
    end;
  end;

begin
  if FBusy or (not FPreview.FPaintAllowed) then Exit;

  FBusy := True;
  FSaveFoundView := nil;
  try
    if FDown then
    begin
      FPreview.HScrollBar.Position := FPreview.HScrollBar.Position - (X - FLastX);
      FPreview.VScrollBar.Position := FPreview.VScrollBar.Position - (Y - FLastY);
      FLastX := X;
      FLastY := Y;
    end
    else
    begin
      lCursor := crDefault;
      lUrlStr := '';
      FPreview.FHRuler.SetGuides(x - 10 + FHRulerOffset, 0);
      FPreview.FVRuler.SetGuides(y - 10 + FVRulerOffset, 0);

      lPoint := Point(x - FPreview.FOffsetLeft, y - FPreview.FOffsetTop);
      lEndPages := TRMEndPages(FPreview.GetEndPages);
      for i := 0 to Length(FVisiblePages) - 1 do
      begin
        lEndPage := lEndPages[FVisiblePages[i]];
        lRect := lEndPage.PageRect;
        if PtInRect(lRect, lPoint) then
        begin
          lPoint := Point(Round((lPoint.X - lRect.Left) / FPReview.FScale),
            Round((lPoint.Y - lRect.Top) / FPReview.FScale));
          if _GenOnePage then
          begin
            FSavePageNo := FVisiblePages[i] + 1;
            FSaveEndPage := lEndPage;
            Break;
          end;
        end;
      end;

      Cursor := lCursor;
      FPreview.FStatusBar.Panels[1].Text := lUrlStr;
    end;
  finally
    FBusy := False;
  end;
end;

procedure TRMDrawPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (not FPreview.FPaintAllowed) then Exit;

  FDown := False;
end;

procedure TRMDrawPanel.DblClick;
begin
  FDown := False;
  FDoubleClickFlag := True;
  FPreview.EditPage(FPreview.CurPage - 1);
end;

{----------------------------------------------------------------------------}
{----------------------------------------------------------------------------}
{ TRMPreview }

constructor TRMPreview.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  BevelInner := bvNone;
  BevelOuter := bvLowered;
  Caption := '';
  OnResize := OnResizeEvent;
  FParentForm := nil;
  FOnPageChanged := nil;
  FOnStatusChange := nil;

  FOutlineTreeView := TTreeView.Create(Self);
  with FOutlineTreeView do
  begin
    Parent := Self;
    Align := alLeft;
    Width := 180;
    Visible := False;
    ReadOnly := True;
    OnClick := OnOutlineClickEvent;
  end;

  FSplitter := TSplitter.Create(Self);
  with FSplitter do
  begin
    Parent := Self;
    Align := alLeft;
    Left := 10;
    Visible := False;
  end;

  FScrollBox := TRMScrollBox.Create(Self);
  with FScrollBox do
  begin
    Parent := Self;
    //BorderStyle := bsNone;
    Caption := '';
    Align := alClient;
    {$IFDEF Delphi4}
    OnMouseWheelUp := OnMouseWheelUpEvent;
    OnMouseWheelDown := OnMouseWheelDownEvent;
    {$ENDIF}
    OnChange := Self.OnScrollBoxScroll;
  end;

  FTopPanel := TPanel.Create(Self);
  with FTopPanel do
  begin
    Parent := FScrollBox;
    Caption := '';
    Height := 29;
    Align := alTop;
    BevelOuter := bvNone;
    Visible := False;
  end;
  FLeftTopPanel := TPanel.Create(Self);
  with FLeftTopPanel do
  begin
    Parent := FTopPanel;
    Caption := '';
    Width := 29;
    Align := alLeft;
    BevelOuter := bvNone;
  end;
  FTopPanel1 := TPanel.Create(Self);
  with FTopPanel1 do
  begin
    Parent := FTopPanel;
    Caption := '';
    Height := 29;
    Align := alClient;
    BevelOuter := bvNone;
  end;
  FLeftPanel := TPanel.Create(Self);
  with FLeftPanel do
  begin
    Parent := FScrollBox;
    Caption := '';
    Width := 29;
    Align := alLeft;
    BevelOuter := bvNone;
    Visible := False;
  end;

  FHRuler := TRMDesignerRuler.Create(Self);
  FHRuler.Parent := FTopPanel1;
  FHRuler.Units := RMUnits;
  FHRuler.Orientation := roHorizontal;
  FHRuler.SetBounds(FLeftPanel.Width, 0, FTopPanel1.Width, FTopPanel1.Height);

  FVRuler := TRMDesignerRuler.Create(Self);
  FVRuler.Parent := FLeftPanel;
  FVRuler.Units := RMUnits;
  FVRuler.Orientation := roVertical;
  FVRuler.SetBounds(0, 0, FLeftPanel.Width, FLeftPanel.Height);

  FStatusBar := TStatusBar.Create(Self);
  with FStatusBar do
  begin
    Parent := Self;
    Align := alBottom;
    with Panels.Add do
    begin
      Width := 100;
    end;
    with Panels.Add do
    begin
      Width := 260;
    end;
    with Panels.Add do
    begin
      Width := 100;
    end;
  end;

  FDrawPanel := TRMDrawPanel.Create(FScrollBox);
  with FDrawPanel do
  begin
    Parent := FScrollBox;
    Caption := '';
    Align := alClient;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    Color := clGray;
    FPreview := Self;
  end;

  FLastScale := 1;
  FZoomMode := mdNone;
  FKWheel := 30;
end;

destructor TRMPreview.Destroy;
begin
  if FReport <> nil then
    TRMReport(FReport).ReportInfo := FSaveReportInfo;

  ClearOutLine;

  inherited Destroy;
end;

function TRMPreview.CanModify: Boolean;
begin
  Result := (RMDesignerClass <> nil) and Assigned(FReport) and TRMReport(Report).ModifyPrepared;
end;

procedure TRMPreview.Connect_1(aReport: TObject);
begin
  FReport := aReport;
end;

{$HINTS OFF}

procedure TRMPreview.ShowReport(aReport: TObject);
begin
  if Assigned(FOnBeforeShowReport) then FOnBeforeShowReport(aReport);
  Connect(aReport);
end;

procedure TRMPreview.Disconnect;
begin
  if FReport <> nil then
    TRMReport(FReport).ReportInfo := FSaveReportInfo;

  FReport := nil;
end;

procedure TRMPreview.ClearOutLine;
var
  i: Integer;
  lNode: TTreeNode;
begin
  for i := 0 to FOutLineTreeView.Items.Count - 1 do
  begin
    lNode := FOutLineTreeView.Items[i];
    if lNode.Data <> nil then
    begin
      Dispose(lNode.Data);
      lNode.Data := nil;
    end;
  end;
  FOutLineTreeView.Items.Clear;
end;

procedure TRMPreview.OnOutlineClickEvent(Sender: TObject);
var
  lNode: TTreeNode;
  lPages: TRMEndPages;
  lPageNo, lPagePosition: Integer;
  lPageRectHeight: Integer;
  lPageHeight: Integer;
begin
  lNode := FOutLineTreeView.Selected;
  if (lNode = nil) or (lNode.Data = nil) then Exit;

  lPages := TRMEndPages(GetEndPages);
  lPageNo := PRMPreviewNodeDataInfo(lNode.Data).PageNo;
  if (lPageNo < 0) or (lPageNo >= lPages.Count) then Exit;

  lPagePosition := Round(PRMPreviewNodeDataInfo(lNode.Data).Position * FScale) +
    RMToScreenPixels(lPages[lPageNo].mmMarginTop * FScale, rmutMMThousandths);
  if lPageNo > 0 then
    lPageRectHeight := lPages[lPageNo].PageRect.Bottom - lPages[lPageNo - 1].PageRect.Bottom
  else
    lPageRectHeight := lPages[lPageNo].PageRect.Bottom;

  lPageRectHeight := lPageRectHeight - 10;
  lPageHeight := Round(lPages[lPageNo].PrinterInfo.PageHeight * FScale);

  FCurPage := -1;
  CurPage := lPageNo + 1;
  VScrollBar.Position := VScrollBar.Position +
    Round(lPagePosition * lPageRectHeight / lPageHeight) + 10 - 5;
end;

procedure TRMPreview.Connect(aReport: TObject);
var
  lParentForm: TForm;

  procedure _SetOutLine; // 设置outline
  var
    i, j: Integer;
    lStr: string;
    lInfo: PRMPreviewNodeDataInfo;
    lParentNode, lNode: TTreeNode;
    lCaption: string;
    lPageNo, lPosition, lNodeLevel: Integer;
    lTmpPos, lOldNodeLevel: Integer;
    lEndPages: TRMEndPages;
  begin
    FOutLineTreeView.Items.BeginUpdate;
    try
      lEndPages := TRMEndPages(GetEndPages);
      ClearOutLine;
      //      lNode := FOutLine.Items.AddChild(nil, '目录');
      //      lNode.Data := nil;
      lNode := nil;
      lParentNode := lNode;
      lOldNodeLevel := 0;

      {      lEndPages.OutLines.Add('1' + #1 + '0' + #1 + '100' + #1 + '0');
            lEndPages.OutLines.Add('2' + #1 + '1' + #1 + '100' + #1 + '1');
            lEndPages.OutLines.Add('3' + #1 + '1' + #1 + '100' + #1 + '1');
            lEndPages.OutLines.Add('4' + #1 + '1' + #1 + '100' + #1 + '2');
            lEndPages.OutLines.Add('5' + #1 + '1' + #1 + '100' + #1 + '2');
            lEndPages.OutLines.Add('6' + #1 + '1' + #1 + '100' + #1 + '1');
            lEndPages.OutLines.Add('7' + #1 + '1' + #1 + '100' + #1 + '0');
           }for i := 0 to lEndPages.OutLines.Count - 1 do
      begin
        lStr := lEndPages.OutLines[i];
        lTmpPos := 1;
        lCaption := RMStrGetToken(lStr, #1, lTmpPos);
        lPageNo := StrToInt(RMStrGetToken(lStr, #1, lTmpPos));
        lPosition := StrToInt(RMStrGetToken(lStr, #1, lTmpPos));
        lNodeLevel := StrToInt(RMStrGetToken(lStr, #1, lTmpPos));

        if lNodeLevel > lOldNodeLevel then
        begin
          lParentNode := lNode;
        end
        else if lNodeLevel < lOldNodeLevel then
        begin
          lParentNode := lNode;
          for j := lNodeLevel to lOldNodeLevel do
          begin
            if lParentNode = nil then Break;
            lParentNode := lParentNode.Parent;
          end;
        end;

        lNode := FOutLineTreeView.Items.AddChild(lParentNode, lCaption);

        New(lInfo);
        lInfo.PageNo := lPageNo;
        lInfo.Position := lPosition;
        lNode.Data := lInfo;

        lOldNodeLevel := lNodeLevel;
      end;
    finally
      FOutLineTreeView.FullExpand;
      FOutLineTreeView.Items.EndUpdate;
      ShowOutline(FOutLineTreeView.Items.Count > 0);
    end;
  end;

begin
  FLeftPanel.Visible := Options.RulerVisible;
  FTopPanel.Visible := Options.RulerVisible;
  FHRuler.Units := Options.RulerUnit;
  FVRuler.Units := Options.RulerUnit;

  Connect_1(aReport);
  if aReport = nil then Exit;

  FSaveReportInfo := TRMReport(FReport).ReportInfo;
  case TRMReport(FReport).InitialZoom of
    pzDefault:
      begin
        FScale := 1;
        FZoomMode := mdNone;
      end;
    pzPageWidth: FZoomMode := mdPageWidth;
    pzOnePage: FZoomMode := mdOnePage;
    pzTwoPages: FZoomMode := mdTwoPages;
  end;

  _SetOutLine;

  CurPage := 1;
  RedrawAll(True);

  {$IFDEF Delphi4}
  lParentForm := FParentForm;
  if (lParentForm = nil) and (Parent <> nil) and (Parent is TForm) then
    lParentForm := TForm(Parent);
  if lParentForm <> nil then
  begin
    //    lParentForm.OnMouseWheelUp := OnMouseWheelUpEvent;
    //    lParentForm.OnMouseWheelDown := OnMouseWheelDownEvent;
  end;
  {$ENDIF}
end;
{$HINTS ON}

procedure TRMPreview.DoStatusChange;
begin
  if Assigned(FOnStatusChange) then
    FOnStatusChange(Self);
end;

procedure TRMPreview.SetToCurPage;
begin
  if (GetEndPages = nil) or (FCurPage < 1) then Exit;

  TRMEndPages(GetEndPages).CurPageNo := FCurPage; //by waw
  if FOffsetTop <> TRMEndPages(GetEndPages)[FCurPage - 1].PageRect.Top - 10 then
    VScrollBar.Position := TRMEndPages(GetEndPages)[FCurPage - 1].PageRect.Top - 10;
end;

procedure TRMPreview.ShowPageNum;
begin
  if GetEndPages = nil then
    FStatusBar.Panels[0].Text := ''
      //    FLabel.Caption := ''
  else
  begin
    if Assigned(FOnPageChanged) then
      FOnPageChanged(Self);

    FStatusBar.Panels[0].Text {FLabel.Caption} := RMLoadStr(SPg) + ' ' + IntToStr(FCurPage) + '/' +
    IntToStr(TRMEndPages(GetEndPages).Count);
    TRMEndPages(GetEndPages).CurPageNo := FCurPage;
  end;
end;

procedure TRMPreview.LoadFromFile(aFileName: string);
begin
  if (FReport = nil) or (GetEndPages = nil) then Exit;

  FPaintAllowed := False;
  try
    TRMReport(FReport).LoadPreparedReport(aFileName);
    //    SetLength(FVisiblePages, 0);
  finally
    Connect(FReport);
  end;
end;

procedure TRMPreview.LoadFromFiles(aFileNames: TStrings);
var
  i: Integer;

  procedure _AppendReport(const aFileName: string; aEndPages: TRMEndPages);
  var
    lStream: TFileStream;
  begin
    if not FileExists(aFileName) then Exit;
    lStream := TFileStream.Create(aFileName, fmOpenRead);
    try
      aEndPages.AppendFromStream(lStream);
    finally
      lStream.Free;
    end;
  end;

begin
  if (FReport = nil) or (GetEndPages = nil) then Exit;

  FPaintAllowed := False;
  try
    for i := 0 to aFileNames.Count - 1 do
    begin
      if i = 0 then
        TRMReport(FReport).LoadPreparedReport(aFileNames[i])
      else
        _AppendReport(aFileNames[i], TRMReport(FReport).EndPages);
    end;
  finally
    Connect(FReport);
  end;
end;

procedure TRMPreview.SaveToFile(aFileName: string; aIndex: Integer);
begin
  if (FReport = nil) or (GetEndPages = nil) then Exit;

  FPaintAllowed := False;
  try
    if aIndex < 2 then
    begin
      aFileName := ChangeFileExt(aFileName, '.rmp');
      TRMReport(FReport).SavePreparedReport(aFileName);
    end
    else //export输出
    begin
      TRMReport(Report).ExportTo(TRMExportFilter(RMFilters(aIndex - 2).Filter),
        ChangeFileExt(aFileName, Copy(RMFilters(aIndex - 2).FilterExt, 2, 255)));
    end;
  finally
    Connect_1(FReport);
    RedrawAll(False);
  end;
end;

procedure TRMPreview.ExportToFile(aExport: TComponent; aFileName: string);
begin
  if (FReport = nil) or (GetEndPages = nil) then Exit;

  FPaintAllowed := False;
  try
    TRMReport(Report).ExportTo(TRMExportFilter(aExport), aFileName);
  finally
    RedrawAll(False);
  end;
end;

type
  THackExport = class(TRMExportFilter)
  end;

procedure TRMPreview.ExportToXlsFile;
var
  i: Integer;
  lXLSExport: TRMExportFilter;
  lSaveShowDialog: Boolean;
  lFound: Boolean;
begin
  if (FReport = nil) or (GetEndPages = nil) then Exit;

  lXLSExport := nil;
  lFound := False;
  for i := 0 to RMFiltersCount - 1 do
  begin
    lXLSExport := TRMExportFilter(RMFilters(i).Filter);
    if lXLSExport.IsXLSExport then
    begin
      lFound := True;
      Break;
    end;
  end;

  if lFound then
  begin
    FPaintAllowed := False;
    lSaveShowDialog := lXLSExport.ShowDialog;
    try
      if lXLSExport.ShowModal = mrOK then
      begin
        lXLSExport.ShowDialog := False;
        ExportToFile(lXLSExport, THackExport(lXLSExport).FileName);
      end;
    finally
      lXLSExport.ShowDialog := lSaveShowDialog;
      RedrawAll(False);
    end;
  end;
end;

procedure TRMPreview.OnResizeEvent(Sender: TObject);
var
  i, j, y, d, nx, maxx, maxy, maxdy, curx: Integer;
  lPageWidth, lPageHeight: Integer;
  lPages: TRMEndPages;
begin
  if (GetEndPages = nil) or (TRMEndPages(GetEndPages).Count < 1) then Exit;

  lPages := TRMEndPages(GetEndPages);
  FPaintAllowed := False;

  lPageWidth := lPages[FCurPage - 1].PrinterInfo.PageWidth;
  lPageHeight := lPages[FCurPage - 1].PrinterInfo.PageHeight;
  case FZoomMode of
    mdPageWidth: FScale := (FDrawPanel.Width - 20) / lPageWidth;
    mdOnePage: FScale := (FDrawPanel.Height - 20) / lPageHeight;
    mdTwoPages: FScale := (FDrawPanel.Width - 30) / (2 * lPageWidth);
    mdPrinterZoom: FScale := RMPrinter.FactorY;
  end;

  nx := 0;
  maxx := 10;
  j := 0;
  for i := 0 to lPages.Count - 1 do
  begin
    d := maxx + 10 + Round(lPages[i].PrinterInfo.PageWidth * FScale);
    if d > FDrawPanel.Width then
    begin
      if nx < j then
        nx := j;
      j := 0;
      maxx := 10;
    end
    else
    begin
      maxx := d;
      Inc(j);
      if i = lPages.Count - 1 then
      begin
        if nx < j then
          nx := j;
      end;
    end;
  end;

  if nx = 0 then
    nx := 1;
  if FZoomMode = mdOnePage then
    nx := 1;
  if FZoomMode = mdTwoPages then
    nx := 2;
  y := 10;
  i := 0;
  maxx := 0;
  maxy := 0;
  while i < lPages.Count do
  begin
    j := 0;
    maxdy := 0;
    curx := 10;
    while (j < nx) and (i + j < lPages.Count) do
    begin
      lPageWidth := Round(lPages[i + j].PrinterInfo.PageWidth * FScale);
      lPageHeight := Round(lPages[i + j].PrinterInfo.PageHeight * FScale);
      if (nx = 1) and (lPageWidth < FDrawPanel.Width) then
      begin
        d := (FDrawPanel.Width - lPageWidth) div 2;
        lPages[i + j].PageRect := Rect(d, y, d + lPageWidth, y + lPageHeight);
      end
      else
        lPages[i + j].PageRect := Rect(curx, y, curx + lPageWidth, y + lPageHeight);
      if maxx < lPages[i + j].PageRect.Right then
        maxx := lPages[i + j].PageRect.Right;
      if maxy < lPages[i + j].PageRect.Bottom then
        maxy := lPages[i + j].PageRect.Bottom;
      Inc(j);
      if maxdy < lPageHeight then
        maxdy := lPageHeight;
      Inc(curx, lPageWidth + 10);
    end;
    Inc(y, maxdy + 10);
    Inc(i, nx);
  end;

  HScrollBar.Max := maxx + 10;
  HScrollBar.RefreshLargePage(FScrollBox.ClientWidth);
  if HScrollBar.Position > HScrollBar.Max - HScrollBar.LargeChange then
    HScrollBar.Position := HScrollBar.Max - HScrollBar.LargeChange;

  VScrollBar.Max := maxy + 10;
  VScrollBar.RefreshLargePage(FScrollBox.ClientHeight);
  if VScrollBar.Position > VScrollBar.Max - VScrollBar.LargeChange then
    VScrollBar.Position := VScrollBar.Max - VScrollBar.LargeChange;

  SetToCurPage;
  FPaintAllowed := True;
  DoStatusChange;
end;

procedure TRMPreview.RedrawAll(ResetPage: Boolean);
//var
//  i: Integer;
begin
  FPaintAllowed := True;
  FScale := FLastScale;
  if ResetPage then
  begin
    FCurPage := 1;
    FOffsetLeft := 0;
    FOffsetTop := 0;
    FOldHPos := 0;
    FOldVPos := 0;
    HScrollBar.Position := 0;
    VScrollBar.Position := 0;
  end;
  ShowPageNum;
  OnResizeEvent(nil);
  {  if GetEndPages <> nil then
    begin
      for i := 0 to TRMEndPages(GetEndPages).Count - 1 do
      begin
        TRMEndPages(GetEndPages).Pages[i].RemoveCachePage;
      end;
    end;}
  FDrawPanel.Repaint;
end;

procedure TRMPreview.OnScrollBoxScroll(Sender: TObject; Kind: TRMScrollBarKind);
var
  i, p, pp: Integer;
  lRect: TRect;
  lPages: TRMEndPages;
begin
  if GetEndPages = nil then Exit;

  if Kind = rmsbHorizontal then
  begin
    p := HScrollBar.Position;
    pp := FOldHPos - p;
    FOldHPos := p;
    FOffsetLeft := -p;
    lRect := Rect(0, 0, FDrawPanel.Width, FDrawPanel.Height);
    ScrollWindow(FDrawPanel.Handle, pp, 0, @lRect, @lRect);
  end
  else
  begin
    lPages := TRMEndPages(GetEndPages);
    p := VScrollBar.Position;
    pp := FOldVPos - p;
    FOldVPos := p;
    FOffsetTop := -p;
    lRect := Rect(0, 0, FDrawPanel.Width, FDrawPanel.Height);
    ScrollWindow(FDrawPanel.Handle, 0, pp, @lRect, @lRect);
    for i := 0 to lPages.Count - 1 do
    begin
      if (lPages[i].PageRect.Top < -FOffsetTop + 11) and (lPages[i].PageRect.Bottom > -FOffsetTop + 11) then
      begin
        FCurPage := i + 1;
        ShowPageNum;
        Break;
      end;
    end;
  end;
end;

procedure TRMPreview.SetPage(Value: Integer);
begin
  if FCurPage <> Value then
  begin
    if Value < 1 then
      Value := 1;
    if Value > TotalPages then
      Value := TotalPages;
    FCurPage := Value;
    SetToCurPage;
    if Assigned(FOnPageChanged) then
      FOnPageChanged(Self);
  end;
end;

function TRMPreview.GetZoom: Double;
begin
  Result := FScale * 100;
end;

procedure TRMPreview.SetZoom(Value: Double);
begin
  FScale := Value / 100;
  FZoomMode := mdNone;
  LastScale := FScale;
  OnResizeEvent(nil);
  FDrawPanel.Paint;
  DoStatusChange;
end;

function TRMPreview.GetTotalPages: Integer;
begin
  if GetEndPages <> nil then
    Result := TRMEndPages(GetEndPages).Count
  else
    Result := 0;
end;

procedure TRMPreview.OnePage;
begin
  FZoomMode := mdOnePage;
  OnResizeEvent(nil);
  FDrawPanel.Paint;
  DoStatusChange;
end;

procedure TRMPreview.TwoPages;
begin
  FZoomMode := mdTwoPages;
  OnResizeEvent(nil);
  FDrawPanel.Paint;
  DoStatusChange;
end;

procedure TRMPreview.PageWidth;
begin
  FZoomMode := mdPageWidth;
  OnResizeEvent(nil);
  FDrawPanel.Paint;
  DoStatusChange;
end;

procedure TRMPreview.PrinterZoom;
begin
  if RMPrinter.PrinterInfo.IsValid then
    FZoomMode := mdPrinterZoom
  else
    FZoomMode := mdPageWidth;
  OnResizeEvent(nil);
  FDrawPanel.Paint;
  DoStatusChange;
end;

procedure TRMPreview.First;
begin
  CurPage := 1;
end;

procedure TRMPreview.Next;
begin
  CurPage := CurPage + 1;
end;

procedure TRMPreview.Prev;
begin
  CurPage := CurPage - 1;
end;

procedure TRMPreview.Last;
begin
  CurPage := TotalPages;
end;

procedure TRMPreview.Print;
var
  lSavePrinterIndex: Integer;
  lNeedSave: Boolean;
  lPages: string;
  lForm: TRMPrintDialogForm;
begin
  if (GetEndPages = nil) or (RMPrinters.Count = 2) then Exit;

  lForm := TRMPrintDialogForm.Create(nil);
  try
    with lForm do
    begin
      CurrentPrinter := TRMReport(FReport).ReportPrinter;
      Copies := TRMReport(FReport).DefaultCopies;
      chkCollate.Checked := TRMReport(FReport).DefaultCollate;
      chkTaoda.Checked := TRMReport(FReport).PrintBackGroundPicture;
      chkColorPrint.Checked := TRMReport(FReport).ColorPrint;
      THackReport(FReport).ScalePageSize := -1;
      THackReport(FReport).ScaleFactor := 100;
      PrintOffsetTop := TRMReport(FReport).PrintOffsetTop;
      PrintOffsetLeft := TRMReport(FReport).PrintOffsetLeft;
      if TRMReport(Report).ShowPrintDialog then
        lSavePrinterIndex := TRMReport(FReport).ReportPrinter.PrinterIndex
      else
        lSavePrinterIndex := -1;

      if (not TRMReport(Report).ShowPrintDialog) or (ShowModal = mrOK) then
      begin
        if TRMReport(FReport).CanRebuild and (lForm.NeedRebuild or
          (TRMReport(FReport).ReportPrinter.PrinterIndex <> lSavePrinterIndex)) then // 改变了打印机设置
        begin
          {          if TRMReport(FReport).ChangePrinter(liSavePrinterIndex, TRMReport(FReport).ReportPrinter.PrinterIndex) then
                    begin
                      TRMEndPages(FEndPages).Free;
                      FEndPages := nil;
                      TRMReport(FReport).PrepareReport;
                      Connect(FReport);
                    end
                    else
                    begin
                      Free;
                      Exit;
                    end;
                  }
        end;

        TRMReport(FReport).ColorPrint := chkColorPrint.Checked;
        THackReport(FReport).Flag_PrintBackGroundPicture := not chkTaoda.Checked;
        GetPageInfo(THackReport(FReport).ScalePageWidth, THackReport(FReport).ScalePageHeight, THackReport(FReport).ScalePageSize);
        THackReport(FReport).ScaleFactor := lForm.ScaleFactor;
        lNeedSave := (TRMReport(FReport).PrintOffsetTop <> PrintOffsetTop) or
          (TRMReport(FReport).PrintOffsetLeft <> PrintOffsetLeft);
        TRMReport(FReport).PrintOffsetTop := PrintOffsetTop;
        TRMReport(FReport).PrintOffsetLeft := PrintOffsetLeft;
        if rdbPrintAll.Checked then
          lPages := ''
        else if rbdPrintCurPage.Checked then
          lPages := IntToStr(FCurPage)
        else
          lPages := edtPages.Text;

        if lNeedSave then
          TRMReport(FReport).SaveReportOptions.SaveReportSetting(TRMReport(FReport), '');

        FPaintAllowed := False;
        try
          TRMReport(FReport).PrintPreparedReport(lPages, Copies, chkCollate.Checked,
            TRMPrintPages(cmbPrintAll.ItemIndex));
        finally
          Connect_1(FReport);
          RedrawAll(False);
        end;
      end;
    end;
  finally
    lForm.Free;
  end;
end;

procedure TRMPreview.PrintCurrentPage; //打印当前页
begin
  if (GetEndPages = nil) or (RMPrinters.Count = 2) then Exit;

  FPaintAllowed := False;
  try
    THackReport(FReport).Flag_PrintBackGroundPicture := TRMReport(FReport).PrintbackgroundPicture;
    THackReport(FReport).ScalePageSize := -1;
    THackReport(FReport).ScaleFactor := 100;

    TRMReport(FReport).PrintPreparedReport(IntToStr(CurPage), 1, TRMReport(FReport).DefaultCollate,
      rmppAll);
  finally
    RedrawAll(False);
  end;
end;

procedure TRMPreview.DlgPageSetup;
var
  tmpForm: TRMPageSetupForm;
  liEndPage: TRMEndPage;
  lPage: TRMCustomPage;
  i: Integer;
  w, lhRgn, p: Integer;
  lOldIndex: Integer;
begin
  if GetEndPages = nil then Exit;

  lOldIndex := RMPrinter.PrinterIndex;
  liEndPage := TRMEndPages(GetEndPages)[0];
  tmpForm := TRMPageSetupForm.Create(nil);
  try
    with tmpForm, liEndPage do
    begin
      PageSetting.PrinterName := RMPrinters.Printers[RMPrinter.PrinterIndex];
      PageSetting.Title := TRMReport(Report).ReportInfo.Title;
      PageSetting.DoublePass := TRMReport(Report).DoublePass;
      PageSetting.PrintBackGroundPicture := TRMReport(Report).PrintbackgroundPicture;
      PageSetting.ColorPrint := TRMReport(Report).ColorPrint;
      PageSetting.MarginLeft := RMFromMMThousandths(mmMarginLeft, rmutMillimeters);
      PageSetting.MarginTop := RMFromMMThousandths(mmMarginTop, rmutMillimeters);
      PageSetting.MarginRight := RMFromMMThousandths(mmMarginRight, rmutMillimeters);
      PageSetting.MarginBottom := RMFromMMThousandths(mmMarginBottom, rmutMillimeters);
      PageSetting.PageOr := PageOrientation;
      PageSetting.PageBin := PageBin;
      PageSetting.PageSize := PageSize;
      PageSetting.PageWidth := PageWidth;
      PageSetting.PageHeight := PageHeight;
      if PreviewPageSetup then
      begin
        if lOldIndex <> cmbPrinterNames.ItemIndex then
          TRMReport(Report).ChangePrinter(RMPrinter.PrinterIndex, cmbPrinterNames.ItemIndex);

        TRMReport(Report).ReportInfo.Title := PageSetting.Title;
        TRMReport(Report).DoublePass := PageSetting.DoublePass;
        TRMReport(Report).PrintbackgroundPicture := PageSetting.PrintbackgroundPicture;
        TRMReport(Report).ColorPrint := PageSetting.ColorPrint;

        mmMarginLeft := RMToMMThousandths(PageSetting.MarginLeft, rmutMillimeters);
        mmMarginTop := RMToMMThousandths(PageSetting.MarginTop, rmutMillimeters);
        mmMarginRight := RMToMMThousandths(PageSetting.MarginRight, rmutMillimeters);
        mmMarginBottom := RMToMMThousandths(PageSetting.MarginBottom, rmutMillimeters);

        PageOrientation := PageSetting.PageOr;
        PageBin := PageSetting.PageBin;
        p := PageSetting.PageSize;
        w := PageSetting.PageWidth;
        lhRgn := PageSetting.PageHeight;

        for i := 0 to TRMReport(Report).Pages.Count - 1 do
        begin
          lPage := TRMReport(Report).Pages[i];
          if lPage is TRMReportPage then
          begin
            TRMReportPage(lPage).mmMarginLeft := mmMarginLeft;
            TRMReportPage(lPage).mmMarginTop := mmMarginTop;
            TRMReportPage(lPage).mmMarginRight := mmMarginRight;
            TRMReportPage(lPage).mmMarginBottom := mmMarginBottom;

            TRMReportPage(lPage).ChangePaper(p, w, lhRgn, liEndPage.PageBin, liEndPage.PageOrientation);
          end;
        end;
        TRMReport(Report).SaveReportOptions.SaveReportSetting(TRMReport(Report), '');

        if Assigned(OnAfterPageSetup) then
          OnAfterPageSetup(PageSetting);
        if TRMReport(Report).CanRebuild then
        begin
          FPaintAllowed := False;
          //          SetLength(FVisiblePages, 0);
          TRMReport(Report).PrepareReport;
          Connect_1(Report);
        end;

        RedrawAll(True);
      end;
    end;
  finally
    tmpForm.Free;
  end;
end;

procedure TRMPreview.AddPage;
begin
  if FReport = nil then Exit;

  TRMEndPages(GetEndPages).InsertFromEndPage(TRMEndPages(GetEndPages).Count,
    TRMEndPages(GetEndPages).Pages[TRMEndPages(GetEndPages).Count - 1]);
  RedrawAll(False);
end;

procedure TRMPreview.InsertPageBefore;
var
  liEndPage: TRMEndPage;
  liPageNo: Integer;
begin
  if FReport = nil then Exit;

  if FCurPage > TRMEndPages(GetEndPages).Count then
  begin
    liEndPage := TRMEndPages(GetEndPages).Pages[TRMEndPages(GetEndPages).Count - 1];
    liPageNo := TRMEndPages(GetEndPages).Count - 1;
  end
  else
  begin
    liEndPage := TRMEndPages(GetEndPages).Pages[FCurPage - 1];
    liPageNo := FCurPage - 1;
  end;

  TRMEndPages(GetEndPages).InsertFromEndPage(liPageNo, liEndPage);
  TRMReport(FReport).Modified := True;
  RedrawAll(False);
end;

procedure TRMPreview.InsertPageAfter;
begin
  if FReport = nil then Exit;

  if FCurPage > TRMEndPages(GetEndPages).Count then
    AddPage
  else
  begin
    TRMEndPages(GetEndPages).InsertFromEndPage(FCurPage, TRMEndPages(GetEndPages).Pages[FCurPage - 1]);
    RedrawAll(False);
  end;
  TRMReport(FReport).Modified := True;
end;

procedure TRMPreview.DeletePage(PageNo: Integer);
begin
  if (FReport = nil) or (GetEndPages = nil) then Exit;

  if (PageNo >= 0) and (TRMEndPages(GetEndPages).Count > 1) then
  begin
    if MessageBox(0, PChar(RMLoadStr(SRemovePg)), PChar(RMLoadStr(SConfirm)),
      mb_YesNo + mb_IconQuestion) = mrYes then
    begin
      TRMEndPages(GetEndPages).Delete(PageNo);
      RedrawAll(True);
      TRMReport(FReport).Modified := True;
    end;
  end;
end;

function TRMPreview.EditPage(PageNo: Integer): Boolean;
begin
  Result := False;
  if not CanModify then Exit;
  if (PageNo >= 0) and (PageNo < TRMEndPages(GetEndPages).Count) then
  begin
    FPaintAllowed := False;
    try
      Result := TRMReport(FReport).EditPreparedReport(PageNo);
    finally
      Connect_1(FReport);
      RedrawAll(False);
    end;
  end;
end;

procedure TRMPreview.DesignReport;
begin
  if not ((RMDesignerClass <> nil) and Assigned(FReport)) then Exit;
  if (not TRMReport(FReport).CanRebuild) or (TRMReport(FReport) is TRMCompositeReport) then
    Exit;

  FPaintAllowed := False;
  try
    TRMReport(FReport).DesignPreviewedReport;
  finally
    Connect_1(FReport);
    RedrawAll(False);
  end;
end;

{$IFDEF Delphi4}

procedure TRMPreview.OnMouseWheelUpEvent(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  VScrollBar.Position := VScrollBar.Position - VScrollBar.SmallChange * FKWheel;
end;

procedure TRMPreview.OnMouseWheelDownEvent(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  VScrollBar.Position := VScrollBar.Position + VScrollBar.SmallChange * FKWheel;
end;
{$ENDIF}

function EnumEMFRecordsProc(DC: HDC; HandleTable: PHandleTable;
  EMFRecord: PEnhMetaRecord; nObj: Integer; OptData: Pointer): Bool; stdcall;
var
  Typ: Byte;
  s: string;
  t: TEMRExtTextOut;
  s1: PChar;

  function _FindText(const aStr: string): Boolean;
  var
    liPos, liLen: Integer;
  begin
    Result := False;
    liPos := Pos(aStr, s);
    liLen := Length(aStr);
    while (liPos > 0) and (not Result) do
    begin
      if liPos < Length(s) then
      begin
        if (s[liPos + liLen] in RMBreakChars) or (s[liPos + liLen] in LeadBytes) then
          Result := True;
      end
      else
        Result := True;

      if not Result then
      begin
        System.Delete(s, 1, liPos - 1 + liLen);
        liPos := Pos(aStr, s);
      end;
    end;
  end;

begin
  Result := True;
  Typ := EMFRecord^.iType;
  if Typ in [83, 84] then
  begin
    t := PEMRExtTextOut(EMFRecord)^;
    if RMGetWindowsVersion <> 'NT' then
    begin
      s1 := StrAlloc(t.EMRText.nChars + 1);
      StrLCopy(s1, PChar(PChar(EMFRecord) + t.EMRText.offString), t.EMRText.nChars);
      s := StrPas(s1);
      StrDispose(s1);
    end
    else
      s := WideCharLenToString(PWideChar(PChar(EMFRecord) + t.EMRText.offString),
        t.EMRText.nChars);

    if not FCurPreview.CaseSensitive then
      s := AnsiUpperCase(s);

    if FCurPreview.Wholewords then
    begin
      FCurPreview.StrFound := _FindText(FCurPreview.FindStr);
    end
    else
      FCurPreview.StrFound := Pos(FCurPreview.FindStr, s) <> 0;

    if FCurPreview.StrFound and (FRecordNum >= FCurPreview.LastFoundObject) then
    begin
      FCurPreview.StrBounds := t.rclBounds;
      Result := False;
    end;
  end;
  Inc(FRecordNum);
end;

procedure TRMPreview.FindInEMF(lEmf: TMetafile);
begin
  FCurPreview := Self;
  FRecordNum := 0;
  EnumEnhMetafile(0, lEmf.Handle, @EnumEMFRecordsProc, nil, Rect(0, 0, 0, 0));
end;

procedure TRMPreview.FindNext;
var
  lEmf: TMetafile;
  lEmfCanvas: TMetafileCanvas;
  lEndPage: TRMEndPage;
  i, nx, ny, ndx, ndy: Integer;
begin
  FStrFound := False;
  while FLastFoundPage < TRMEndPages(GetEndPages).Count do
  begin
    lEndPage := TRMEndPages(GetEndPages).Pages[FLastFoundPage];
    lEmf := TMetafile.Create;
    lEmf.Width := lEndPage.PrinterInfo.PageWidth;
    lEmf.Height := lEndPage.PrinterInfo.PageHeight;
    lEmfCanvas := TMetafileCanvas.Create(lEmf, 0);
    lEndPage.Visible := True;
    lEndPage.Draw(TRMReport(FReport), lEmfCanvas, Rect(0, 0, lEndPage.PrinterInfo.PageWidth, lEndPage.PrinterInfo.PageHeight));
    lEmfCanvas.Free;

    FindInEMF(lEmf);
    lEmf.Free;
    if FStrFound then
    begin
      FCurPage := FLastFoundPage + 1;
      ShowPageNum;
      nx := lEndPage.PageRect.Left + Round(StrBounds.Left * FScale);
      ny := Round(StrBounds.Top * FScale) + 10;
      ndx := Round((StrBounds.Right - StrBounds.Left) * FScale);
      ndy := Round((StrBounds.Bottom - StrBounds.Top) * FScale);

      if ny > FDrawPanel.Height - ndy then
      begin
        VScrollBar.Position := lEndPage.PageRect.Top + ny - FDrawPanel.Height - 10 + ndy;
        ny := FDrawPanel.Height - ndy;
      end
      else
        VScrollBar.Position := lEndPage.PageRect.Top - 10;

      if nx > FDrawPanel.Width - ndx then
      begin
        HScrollBar.Position := lEndPage.PageRect.Left + nx - FDrawPanel.Width - 10 + ndx;
        nx := FDrawPanel.Width - ndx;
      end
      else
        HScrollBar.Position := lEndPage.PageRect.Left - 10;

      LastFoundObject := FRecordNum;
      Application.ProcessMessages;

      FPaintAllowed := True;
      FDrawPanel.Paint;
      with FDrawPanel.Canvas do
      begin
        Pen.Width := 1;
        Pen.Mode := pmXor;
        Pen.Color := clWhite;
        for i := 0 to ndy do
        begin
          MoveTo(nx, ny + i);
          LineTo(nx + ndx, ny + i);
        end;
        Pen.Mode := pmCopy;
      end;

      Break;
    end
    else
    begin
      lEndPage.RemoveCachePage;
    end;

    FLastFoundObject := 0;
    Inc(FLastFoundPage);
  end;
end;

procedure TRMPreview.Find;
var
  tmp: TRMPreviewSearchForm;
begin
  if FReport = nil then Exit;

  tmp := TRMPreviewSearchForm.Create(Application);
  try
    tmp.chkCaseSensitive.Checked := FCaseSensitive;
    tmp.chkWholewords.Checked := FWholewords;
    tmp.edtSearchTxt.Text := FFindStr;
    if tmp.ShowModal = mrOk then
    begin
      FFindStr := tmp.edtSearchTxt.Text;
      FCaseSensitive := tmp.chkCaseSensitive.Checked;
      FWholewords := tmp.chkWholewords.Checked;
      if not FCaseSensitive then
        FFindStr := AnsiUpperCase(FFindStr);
      if tmp.rdbFromFirst.Checked then
      begin
        FLastFoundPage := 0;
        FLastFoundObject := 0;
      end
      else if FLastFoundPage <> FCurPage - 1 then
      begin
        FLastFoundPage := FCurPage - 1;
        FLastFoundObject := 0;
      end;

      FreeAndNil(tmp);
      FindNext;
    end;
  finally
    FreeAndNil(tmp);
  end;
end;

procedure TRMPreview.ShowOutline(aVisible: Boolean);
begin
  FOutlineTreeView.Visible := aVisible;
  FSplitter.Visible := FOutlineTreeView.Visible;
  FSplitter.Left := FOutLineTreeView.Left + 10;
end;

function TRMPreview.GetHScrollBar: TRMScrollBar;
begin
  Result := FScrollBox.HorzScrollBar;
end;

function TRMPreview.GetVScrollBar: TRMScrollBar;
begin
  Result := FScrollBox.VertScrollBar;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMPreviewForm }
var
  LastScale: Double = 1;
  LastScaleMode: TRMScaleMode = mdNone;

procedure TRMPreviewForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  RMSetStrProp(itmPageWidth, 'Caption', rmRes + 020);
  RMSetStrProp(itmOnePage, 'Caption', rmRes + 021);
  RMSetStrProp(itmDoublePage, 'Caption', rmRes + 022);
  RMSetStrProp(itmNewPage, 'Caption', rmRes + 030);
  RMSetStrProp(itmDeletePage, 'Caption', rmRes + 031);
  RMSetStrProp(itmEditPage, 'Caption', rmRes + 029);
  RMSetStrProp(itmPrint, 'Caption', rmRes + 1866);
  RMSetStrProp(itmPrintCurrentPage, 'Caption', rmRes + 376);
  RMSetStrProp(InsertBefore1, 'Caption', rmRes + 1867);
  RMSetStrProp(InsertAfter1, 'Caption', rmRes + 1868);
  RMSetStrProp(Append1, 'Caption', rmRes + 1869);

  RMSetStrProp(btnOpen, 'Hint', rmRes + 025);
  RMSetStrProp(btnSave, 'Hint', rmRes + 026);
  RMSetStrProp(btnPrint, 'Hint', rmRes + 027);
  RMSetStrProp(btnFind, 'Hint', rmRes + 028);
  RMSetStrProp(btnOnePage, 'Hint', rmRes + 1858);
  RMSetStrProp(btnPageWidth, 'Hint', rmRes + 1857);
  RMSetStrProp(btnTop, 'Hint', rmRes + 32);
  RMSetStrProp(btnPrev, 'Hint', rmRes + 33);
  RMSetStrProp(btnNext, 'Hint', rmRes + 34);
  RMSetStrProp(btnLast, 'Hint', rmRes + 35);
  RMSetStrProp(btnPageSetup, 'Hint', rmRes + 24);
  RMSetStrProp(btnShowOutline, 'Hint', rmRes + 1871);
  RMSetStrProp(btnExit, 'Hint', rmRes + 23);
  RMSetStrProp(cmbZoom, 'Hint', rmRes + 7);
  //  RMSetStrProp(btnAutoScale, 'Hint', rmRes + 8);
  RMSetStrProp(btnSaveToXLS, 'Hint', rmRes + 9);
  RMSetStrProp(btnDesign, 'Hint', rmRes + 10);
  RMSetStrProp(ToolbarStand, 'Caption', rmRes + 11);
end;

procedure TRMPreviewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveIni;
  if FormStyle <> fsMDIChild then
  begin
    RMSaveFormPosition('', Self);
  end;
  Action := caFree;
end;

procedure TRMPreviewForm.Execute(ADoc: Pointer);
var
  i: Integer;
  lFound: Boolean;
begin
  FDoc := ADoc;
  FViewer.Connect(ADoc);

  OpenDialog.InitialDir := FViewer.InitialDir;
  SaveDialog.InitialDir := FViewer.InitialDir;
  N4.Visible := RMDesignerClass <> nil;
  itmNewPage.Visible := N4.Visible;
  itmDeletePage.Visible := N4.Visible;
  itmEditPage.Visible := N4.Visible;

  if not (csDesigning in TRMReport(ADoc).ComponentState) then
  begin
    cmbZoom.Visible := pbZoom in TRMReport(ADoc).PreviewButtons;
    if not cmbZoom.Visible then tbLine.Free;

    btnShowOutline.Down := FViewer.FOutlineTreeView.Visible;
    btnShowOutline.Visible := (FViewer.FOutLineTreeView.Items.Count > 0);
    btnFind.Visible := pbFind in TRMReport(ADoc).PreviewButtons;
    ToolbarSep972.Visible := btnFind.Visible;

    btnOpen.Visible := pbLoad in TRMReport(ADoc).PreviewButtons;
    btnSave.Visible := pbSave in TRMReport(ADoc).PreviewButtons;
    btnSaveToXLS.Visible := pbSavetoXLS in TRMReport(ADoc).PreviewButtons;
    btnPrint.Visible := pbPrint in TRMReport(ADoc).PreviewButtons;
    btnPageSetup.Visible := pbPageSetup in TRMReport(ADoc).PreviewButtons;
    ToolbarSep975.Visible := btnOpen.Visible or btnSave.Visible or btnPrint.Visible or
      btnPageSetup.Visible or btnSaveToXLS.Visible;

    btnDesign.Visible := pbDesign in TRMReport(FDoc).PreviewButtons;
    ToolbarSep971.Visible := btnDesign.Visible;

    btnExit.Visible := pbExit in TRMReport(ADoc).PreviewButtons;
    ToolbarSep973.Visible := btnExit.Visible;

    itmPrint.Visible := btnPrint.Visible;
    itmPrintCurrentPage.Visible := btnPrint.Visible;
    if btnSaveToXLS.Visible then
    begin
      lFound := False;
      for i := 0 to RMFiltersCount - 1 do
      begin
        if TRMExportFilter(RMFilters(i).Filter).IsXLSExport then
        begin
          lFound := True;
          Break;
        end;
      end;

      if not lFound then
        btnSaveToXLS.Visible := False;
    end;
  end;

  case TRMReport(ADoc).InitialZoom of
    pzPageWidth: btnPageWidth.Down := TRUE;
    pzOnePage: btnOnePage.Down := TRUE;
  else
    FViewer.LastScale := LastScale;
    FViewer.ZoomMode := LastScaleMode;
    //    btn100.Down := TRUE;
  end;

  btnPrint.Enabled := RMPrinters.Count > 2; // Printer.Printers.Count > 0;

  if btnPageWidth.Down then
    cmbZoom.ItemIndex := 7
  else if btnOnePage.Down then
    cmbZoom.ItemIndex := 8
  else if btn100.Down then
    cmbZoom.ItemIndex := 2
  else if FViewer.FZoomMode = mdTwoPages then
    cmbZoom.ItemIndex := 9
  else
  begin
    cmbZoom.ItemIndex := -1;
    cmbZoom.Text := IntToStr(Round(FViewer.Zoom)) + '%';
  end;

  if TRMReport(ADoc).ModalPreview and (not TRMReport(ADoc).MDIPreview) then
    ShowModal
  else
    Show;
end;

procedure TRMPreviewForm.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
begin
  with Msg.MinMaxInfo^ do
  begin
    ptMaxSize.x := Screen.Width;
    ptMaxSize.y := Screen.Height;
    ptMaxPosition.x := 0;
    ptMaxPosition.y := 0;
  end;
end;

procedure TRMPreviewForm.btnTopClick(Sender: TObject);
begin
  FViewer.First;
end;

procedure TRMPreviewForm.btnPrevClick(Sender: TObject);
begin
  FViewer.Prev;
end;

procedure TRMPreviewForm.btnNextClick(Sender: TObject);
begin
  FViewer.Next;
end;

procedure TRMPreviewForm.btnLastClick(Sender: TObject);
begin
  FViewer.Last;
end;

procedure TRMPreviewForm.btn100Click(Sender: TObject);
begin
  FViewer.Zoom := 100;
  LastScale := FViewer.LastScale;
  LastScaleMode := FViewer.ZoomMode;
end;

procedure TRMPreviewForm.btnOnePageClick(Sender: TObject);
begin
  FViewer.OnePage;
  LastScale := FViewer.LastScale;
  LastScaleMode := FViewer.ZoomMode;
end;

procedure TRMPreviewForm.btnPageWidthClick(Sender: TObject);
begin
  FViewer.PageWidth;
  LastScale := FViewer.LastScale;
  LastScaleMode := FViewer.ZoomMode;
end;

procedure TRMPreviewForm.itmScale10Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    case Tag of
      1: FViewer.PageWidth;
      2: FViewer.OnePage;
      3: FViewer.TwoPages;
    else
      FViewer.Zoom := Tag;
    end;
    Checked := True;
  end;

  if btnPageWidth.Down then
    cmbZoom.ItemIndex := 7
  else if btnOnePage.Down then
    cmbZoom.ItemIndex := 8
  else if btn100.Down then
    cmbZoom.ItemIndex := 2
  else if FViewer.FZoomMode = mdTwoPages then
    cmbZoom.ItemIndex := 9
  else
  begin
    cmbZoom.ItemIndex := -1;
    cmbZoom.Text := IntToStr(Round(FViewer.Zoom)) + '%';
  end;

  LastScale := FViewer.LastScale;
  LastScaleMode := FViewer.ZoomMode;
end;

procedure TRMPreviewForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if FViewer.Report = nil then Exit;

  if Key = vk_Up then
    FViewer.VScrollBar.Position := FViewer.VScrollBar.Position -
      FViewer.VScrollBar.SmallChange * FViewer.KWheel
  else if Key = vk_Down then
    FViewer.VScrollBar.Position := FViewer.VScrollBar.Position +
      FViewer.VScrollBar.SmallChange * FViewer.KWheel
  else if Key = vk_Left then
    FViewer.HScrollBar.Position := FViewer.HScrollBar.Position -
      FViewer.HScrollBar.SmallChange * FViewer.KWheel
  else if Key = vk_Right then
    FViewer.HScrollBar.Position := FViewer.HScrollBar.Position +
      FViewer.HScrollBar.SmallChange * FViewer.KWheel
  else if Key = vk_Prior then
  begin
    if ssCtrl in Shift then
      btnPrev.Click
    else
      FViewer.VScrollBar.Position := FViewer.VScrollBar.Position -
        FViewer.VScrollBar.LargeChange;
  end
  else if Key = vk_Next then
  begin
    if ssCtrl in Shift then
      btnNext.Click
    else
      FViewer.VScrollBar.Position := FViewer.VScrollBar.Position +
        FViewer.VScrollBar.LargeChange;
  end
  else if Key = vk_Escape then
    btnExit.Click
  else if Key = vk_Home then
  begin
    if ssCtrl in Shift then
      FViewer.VScrollBar.Position := 0
    else
      Exit;
  end
  else if Key = vk_End then
  begin
    if ssCtrl in Shift then
      btnLast.Click
    else
      Exit;
  end
  else if ssCtrl in Shift then
  begin
    if (ssAlt in Shift) and (Chr(Key) = 'P') and btnPrint.Enabled then
      FViewer.PrintCurrentPage
    else if Chr(Key) = 'O' then btnOpen.Click
    else if Chr(Key) = 'S' then btnSave.Click
    else if (Chr(Key) = 'P') and btnPrint.Enabled then btnPrint.Click
    else if Chr(Key) = 'F' then btnFind.Click
    else if (Chr(Key) = 'E') and itmEditPage.Visible then itmEditPage.Click;
  end
  else if Key = vk_F3 then
  begin
    if FViewer.FindStr <> '' then
    begin
      if FViewer.LastFoundPage <> FViewer.CurPage - 1 then
      begin
        FViewer.LastFoundPage := FViewer.CurPage - 1;
        FViewer.LastFoundObject := 0;
      end;
      FViewer.FindNext;
    end;
  end
  else
    Exit;

  Key := 0;
end;

procedure TRMPreviewForm.btnOpenClick(Sender: TObject);
var
  lStr: string;
begin
  if (FViewer.Report = nil) or (not btnOpen.Visible) then Exit;

  OpenDialog.Filter := RMLoadStr(SRepFile) + ' (*.rmp)|*.rmp';
  if OpenDialog.Execute then
  begin
    FViewer.LoadFromFiles(OpenDialog.Files {FileName});

    lStr := RMLoadStr(SPreview);
    if TRMReport(FViewer.Report).ReportInfo.Title <> '' then
      lStr := lStr + ' - ' + TRMReport(FViewer.Report).ReportInfo.Title
    else if OpenDialog.FileName <> '' then
      lStr := lStr + ' - ' + ExtractFileName(OpenDialog.FileName)
    else
      lStr := lStr + ' - ' + RMLoadStr(SUntitled);

    Caption := lStr; //ExtractFileName(FileName);
  end;

  btnShowOutline.Down := FViewer.FOutlineTreeView.Visible;
  btnShowOutline.Visible := (FViewer.FOutLineTreeView.Items.Count > 0);
end;

procedure TRMPreviewForm.btnSaveClick(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  if (FViewer.Report = nil) or (not btnSave.Visible) then
    Exit;

  s := RMLoadStr(SRepFile) + ' (*.rmp)|*.rmp';
  for i := 0 to RMFiltersCount - 1 do
    s := s + '|' + RMFilters(i).FilterDesc + '|' + RMFilters(i).FilterExt;

  SaveDialog.Filter := s;
  SaveDialog.FilterIndex := FLastExportIndex;
  if SaveDialog.Execute then
  begin
    FLastExportIndex := SaveDialog.FilterIndex;
    FViewer.Update;
    FViewer.SaveToFile(SaveDialog.FileName, SaveDialog.FilterIndex);
  end;
end;

procedure TRMPreviewForm.btnPrintClick(Sender: TObject);
begin
  if (FViewer.Report = nil) or (not btnPrint.Visible) then
    Exit;

  FViewer.Print;
end;

procedure TRMPreviewForm.btnFindClick(Sender: TObject);
begin
  if (FViewer.Report = nil) or (not btnFind.Visible) then
    Exit;

  FViewer.Find;
end;

procedure TRMPreviewForm.itmDeletePageClick(Sender: TObject);
begin
  FViewer.DeletePage(FViewer.CurPage - 1);
end;

procedure TRMPreviewForm.itmEditPageClick(Sender: TObject);
begin
  FViewer.EditPage(FViewer.CurPage - 1);
end;

procedure TRMPreviewForm.btnPageSetupClick(Sender: TObject);
begin
  FViewer.DlgPageSetup;
end;

procedure TRMPreviewForm.btnShowOutlineClick(Sender: TObject);
begin
  FViewer.ShowOutline(btnShowOutline.Down);
end;

procedure TRMPreviewForm.ProcMenuPopup(Sender: TObject);
begin
  if cmbZoom.ItemIndex >= 0 then
    ProcMenu.Items[cmbZoom.ItemIndex].Checked := True
  else
    ProcMenu.Items[2].Checked := True;

  N4.Visible := FViewer.CanModify;
  itmNewPage.Visible := N4.Visible;
  itmDeletePage.Visible := N4.Visible;
  itmEditPage.Visible := N4.Visible;

  itmPrint.Enabled := btnPrint.Enabled;
  itmPrintCurrentPage.Enabled := btnPrint.Enabled;
end;

procedure TRMPreviewForm.BtnExitClick(Sender: TObject);
begin
  if FDoc = nil then
    Close
  else
  begin
    if TRMReport(FDoc).ModalPreview and (not TRMReport(FDoc).MDIPreview) then
      ModalResult := mrOk
    else
      Close;
  end;
end;

procedure TRMPreviewForm.itmPrintCurrentPageClick(Sender: TObject);
begin
  FViewer.PrintCurrentPage;
end;

procedure TRMPreviewForm.FormShow(Sender: TObject);
begin
  LoadIni;
  if FormStyle <> fsMDIChild then
  begin
    RMRestoreFormPosition('', Self);
  end;

  FBtnShowBorder.Down := FViewer.Options.DrawBorder;
  FBtnBackColor.CurrentColor := FViewer.Options.BorderPen.Color;

  ToolbarStand.Visible := True;
end;

procedure TRMPreviewForm.OnStatusChange(Sender: TObject);
begin
  case FViewer.ZoomMode of
    mdPageWidth: btnPageWidth.Down := TRUE;
    mdOnePage: btnOnePage.Down := TRUE;
  else
    if Round(FViewer.Zoom) = 100 then
      btn100.Down := TRUE
    else
    begin
      btn100.Down := FALSE;
      btnPageWidth.Down := FALSE;
      btnOnePage.Down := FALSE;
    end;
  end;

  if btnPageWidth.Down then
    cmbZoom.ItemIndex := 7
  else if btnOnePage.Down then
    cmbZoom.ItemIndex := 8
  else if btn100.Down then
    cmbZoom.ItemIndex := 2
  else if FViewer.ZoomMode = mdPrinterZoom then
    cmbZoom.ItemIndex := 10
  else if FViewer.ZoomMode = mdTwoPages then
    cmbZoom.ItemIndex := 9
  else
    cmbZoom.ItemIndex := cmbZoom.Items.IndexOf(IntToStr(Round(FViewer.Zoom)) + '%');
end;

procedure TRMPreviewForm.OnPageChanged(Sender: TObject);
begin
  edtPageNo.Text := IntToStr(FViewer.CurPage);
end;

procedure TRMPreviewForm.btnDesignClick(Sender: TObject);
begin
  if (FViewer.Report = nil) or (not btnDesign.Visible) then
    Exit;

  FViewer.DesignReport;
end;

procedure TRMPreviewForm.FormCreate(Sender: TObject);

  procedure _CreateDock;
  begin
    Dock971 := TRMDock.Create(Self);
    with Dock971 do
    begin
      Parent := Self;
      FixAlign := True;
      Name := 'Dock971';
    end;
  end;

  procedure _CreateToolbar;
  begin
    ToolbarStand := TRMToolbar.Create(Self);
    ToolbarStand.BeginUpdate;
    with ToolbarStand do
    begin
      DockedTo := Dock971;
      CloseButton := False;
      DockRow := 0;
      DockPos := 0;
      Name := 'ToolbarPreviewStand';
    end;

    cmbZoom := TRMComboBox97.Create(ToolbarStand);
    with cmbZoom do
    begin
      Parent := ToolbarStand;
      Width := 80; //90;
      DropDownCount := 12;
      Items.Add('200%');
      Items.Add('150%');
      Items.Add('100%');
      Items.Add('75%');
      Items.Add('50%');
      Items.Add('25%');
      Items.Add('10%');
      Items.Add(RMLoadStr(rmRes + 1857));
      Items.Add(RMLoadStr(rmRes + 1858));
      Items.Add(RMLoadStr(rmRes + 1859));
      //    Items.Add(RMLoadStr(rmRes + 1870));
      OnClick := CmbZoomClick;
      OnKeyPress := CmbZoomKeyPress;
    end;
    tbLine := TRMToolbarSep.Create(ToolbarStand);
    with tbLine do
    begin
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(tbLine);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;

    btnOnePage := TRMToolbarButton.Create(ToolbarStand);
    with btnOnePage do
    begin
      AllowAllUp := True;
      GroupIndex := 2;
      ImageIndex := 1;
      Images := ImageList1;
      OnClick := btnOnePageClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnOnePage);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btn100 := TRMToolbarButton.Create(ToolbarStand);
    with btn100 do
    begin
      Hint := '100%';
      AllowAllUp := True;
      GroupIndex := 2;
      ImageIndex := 2;
      Images := ImageList1;
      OnClick := btn100Click;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btn100);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btnPageWidth := TRMToolbarButton.Create(ToolbarStand);
    with btnPageWidth do
    begin
      AllowAllUp := True;
      GroupIndex := 2;
      ImageIndex := 3;
      Images := ImageList1;
      OnClick := btnPageWidthClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnPageWidth);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    ToolbarSep974 := TRMToolbarSep.Create(ToolbarStand);
    with ToolbarSep974 do
    begin
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(ToolbarSep974);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;

    btnTop := TRMToolbarButton.Create(ToolbarStand);
    with btnTop do
    begin
      ImageIndex := 4;
      Images := ImageList1;
      OnClick := btnTopClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnTop);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btnPrev := TRMToolbarButton.Create(ToolbarStand);
    with btnPrev do
    begin
      ImageIndex := 5;
      Images := ImageList1;
      OnClick := btnPrevClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnPrev);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    edtPageNo := TRMEdit.Create(ToolbarStand);
    with edtPageNo do
    begin
      Width := 34;
      OnKeyPress := edtPageNoKeyPress;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(edtPageNo);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btnNext := TRMToolbarButton.Create(ToolbarStand);
    with btnNext do
    begin
      ImageIndex := 6;
      Images := ImageList1;
      OnClick := btnNextClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnNext);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btnLast := TRMToolbarButton.Create(ToolbarStand);
    with btnLast do
    begin
      ImageIndex := 7;
      Images := ImageList1;
      OnClick := btnLastClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnLast);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    ToolbarSep972 := TRMToolbarSep.Create(ToolbarStand);
    with ToolbarSep972 do
    begin
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(ToolbarSep972);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;

    btnFind := TRMToolbarButton.Create(ToolbarStand);
    with btnFind do
    begin
      ImageIndex := 8;
      Images := ImageList1;
      OnClick := btnFindClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnFind);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    ToolbarSep975 := TRMToolbarSep.Create(ToolbarStand);
    with ToolbarSep975 do
    begin
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(ToolbarSep975);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;

    btnOpen := TRMToolbarButton.Create(ToolbarStand);
    with btnOpen do
    begin
      ImageIndex := 9;
      Images := ImageList1;
      OnClick := btnOpenClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnOpen);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btnSave := TRMToolbarButton.Create(ToolbarStand);
    with btnSave do
    begin
      ImageIndex := 10;
      Images := ImageList1;
      OnClick := btnSaveClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnSave);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btnSaveToXLS := TRMToolbarButton.Create(ToolbarStand);
    with btnSaveToXLS do
    begin
      ImageIndex := 15;
      Images := ImageList1;
      OnClick := btnSaveToXLSClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnSaveToXLS);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btnPrint := TRMToolbarButton.Create(ToolbarStand);
    with btnPrint do
    begin
      ImageIndex := 11;
      Images := ImageList1;
      OnClick := btnPrintClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnPrint);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    ToolbarSep1 := TRMToolbarSep.Create(ToolbarStand);
    with ToolbarSep1 do
    begin
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(ToolbarSep1);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;

    btnPageSetup := TRMToolbarButton.Create(ToolbarStand);
    with btnPageSetup do
    begin
      ImageIndex := 12;
      Images := ImageList1;
      OnClick := btnPageSetupClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnPageSetup);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    btnShowOutline := TRMToolbarButton.Create(ToolbarStand);
    with btnShowOutline do
    begin
      AllowAllUp := True;
      GroupIndex := 10;
      ImageIndex := 18;
      Images := ImageList1;
      OnClick := btnShowOutlineClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnShowOutline);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    ToolbarSep973 := TRMToolbarSep.Create(ToolbarStand);
    with ToolbarSep973 do
    begin
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(ToolbarSep973);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;

    btnDesign := TRMToolbarButton.Create(ToolbarStand);
    with btnDesign do
    begin
      ImageIndex := 13;
      Images := ImageList1;
      OnClick := btnDesignClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnDesign);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    ToolbarSep971 := TRMToolbarSep.Create(ToolbarStand);
    with ToolbarSep971 do
    begin
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(ToolbarSep971);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;

    FBtnShowBorder := TRMToolbarButton.Create(ToolbarStand);
    with FBtnShowBorder do
    begin
      AllowAllUp := True;
      GroupIndex := 3;
      Images := ImageList1;
      ImageIndex := 16;
      OnClick := btnShowBorderClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(FBtnShowBorder);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    FBtnBackColor := TRMColorPickerButton.Create(ToolbarStand);
    with FBtnBackColor do
    begin
      Parent := ToolbarStand;
      ParentShowHint := True;
      ColorType := rmptLine;
      OnColorChange := btnBackColorClick;
    end;
    tbSep1 := TRMToolbarSep.Create(ToolbarStand);
    with tbSep1 do
    begin
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(tbSep1);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;

    btnExit := TRMToolbarButton.Create(ToolbarStand);
    with btnExit do
    begin
      ImageIndex := 14;
      Images := ImageList1;
      OnClick := BtnExitClick;
      {$IFDEF USE_TB2k}
      ToolbarStand.Items.Add(btnExit);
      {$ELSE}
      Parent := ToolbarStand;
      {$ENDIF}
    end;
    ToolbarStand.EndUpdate;
  end;

begin
  FViewer := TRMPreview.Create(Self);
  with FViewer do
  begin
    Parent := Self;
    Align := alClient;
    PopupMenu := ProcMenu;
    ParentForm := Self;
  end;
  FViewer.OnStatusChange := OnStatusChange;
  FViewer.OnPageChanged := OnPageChanged;

  _CreateDock;
  {$IFNDEF USE_TB2K}
  Dock971.BeginUpdate;
  {$ENDIF}
  _CreateToolbar;
  {$IFNDEF USE_TB2K}
  Dock971.EndUpdate;
  {$ENDIF}

  Localize;
end;

procedure TRMPreviewForm.CmbZoomKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    try
      FViewer.Zoom := StrToIntDef(cmbZoom.Text, 100);
    except
    end;
  end;
end;

procedure TRMPreviewForm.CmbZoomClick(Sender: TObject);
begin
  case cmbZoom.ItemIndex of
    0: FViewer.Zoom := 200;
    1: FViewer.Zoom := 150;
    2: FViewer.Zoom := 100;
    3: FViewer.Zoom := 75;
    4: FViewer.Zoom := 50;
    5: FViewer.Zoom := 25;
    6: FViewer.Zoom := 10;
    7: FViewer.PageWidth;
    8: FViewer.OnePage;
    9: FViewer.TwoPages;
    //    10: FViewer.PrinterZoom;
  end;
end;

procedure TRMPreviewForm.Append1Click(Sender: TObject);
begin
  FViewer.AddPage;
  FViewer.Last;
end;

procedure TRMPreviewForm.InsertBefore1Click(Sender: TObject);
begin
  FViewer.InsertPageBefore;
end;

procedure TRMPreviewForm.InsertAfter1Click(Sender: TObject);
begin
  FViewer.InsertPageAfter;
  FViewer.CurPage := FViewer.CurPage + 1;
end;

procedure TRMPreviewForm.edtPageNoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    try
      FViewer.CurPage := StrToInt(edtPageNo.Text);
    except;
      edtPageNo.Text := IntToStr(FViewer.CurPage);
    end;
  end;
end;

procedure TRMPreviewForm.btnSaveToXLSClick(Sender: TObject); // 保存到xls文件
begin
  if (FViewer.Report = nil) or (not btnSaveToXLS.Visible) then
    Exit;

  FViewer.ExportToXlsFile;
end;

function TRMPreview.GetEndPages: TObject;
begin
  if FReport <> nil then
    Result := TRMReport(FReport).EndPages
  else
    Result := nil;
end;

procedure TRMPreviewForm.SaveIni;
var
  lIni: TRegIniFile;
  Nm: string;
begin
  lIni := TRegIniFile.Create(RMRegRootKey);
  try
    Nm := 'DefaultPreviewForm';
    lIni.WriteBool(Nm, 'DrawBorder', Viewer.Options.DrawBorder);
    lIni.WriteInteger(Nm, 'DrawPenColor', Viewer.Options.BorderPen.Color);
    lIni.WriteInteger(Nm, 'OutlineWidth', Viewer.FOutLineTreeView.Width);
  finally
    lIni.Free;
  end;
end;

procedure TRMPreviewForm.LoadIni;
var
  lIni: TRegIniFile;
  Nm: string;
begin
  lIni := TRegIniFile.Create(RMRegRootKey);
  try
    Nm := 'DefaultPreviewForm';
    Viewer.Options.DrawBorder := lIni.ReadBool(Nm, 'DrawBorder', Viewer.Options.DrawBorder);
    Viewer.Options.BorderPen.Color := lIni.ReadInteger(Nm, 'DrawPenColor', Viewer.Options.BorderPen.Color);
    FViewer.FOutLineTreeView.Width := lIni.ReadInteger(Nm, 'OutlineWidth', 200);
  finally
    lIni.Free;
  end;
end;

procedure TRMPreviewForm.btnShowBorderClick(Sender: TObject);
begin
  FViewer.Options.DrawBorder := not FViewer.Options.DrawBorder;
  FViewer.ReDrawAll(False);
end;

procedure TRMPreviewForm.btnBackColorClick(Sender: TObject);
begin
  FViewer.Options.BorderPen.Color := FBtnBackColor.CurrentColor;
  FViewer.ReDrawAll(False);
end;

procedure TRMPreviewForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FViewer);
end;

end.

