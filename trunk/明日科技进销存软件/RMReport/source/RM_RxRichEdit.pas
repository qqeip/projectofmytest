
{*****************************************}
{                                         }
{         Report Machine v2.0             }
{          RxRich Add-In Object           }
{                                         }
{*****************************************}

unit RM_RxRichEdit;

interface

{$I RM.inc}

{$IFDEF RX}
uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Menus, Db,
  Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, ClipBrd, JvClipboardMonitor, ToolWin,
  RM_Class, RM_common, RM_Ctrls, RM_DsgCtrls, JvRichEdit, RichEdit
{$IFDEF USE_INTERNAL_JVCL}, rm_JvInterpreter{$ELSE}, JvInterpreter{$ENDIF}
{$IFDEF Delphi4}, ImgList{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

type
  TRMRxRichObject = class(TComponent) // fake component
  end;

 { TRMRxRichView }
  TRMRxRichView = class(TRMStretcheableView)
  private
    FRichEdit, FSRichEdit: TJvRichEdit;
    FSaveCharPos, FEndCharPos, FStartCharPos: Integer;
    FUseSRichEdit: Boolean;

    function SRichEdit: TJvRichEdit;
    procedure GetRichData(ASource: TCustomMemo);
    function FormatRange(aDC: HDC; aFormatDC: HDC; const aRect: TRect; aCharRange: TCharRange;
      aRender: Boolean): Integer;
    function DoCalcHeight: Integer;
    procedure ShowRichText(aRender: Boolean);
  protected
    procedure Prepare; override;
    procedure GetMemoVariables; override;
    function GetViewCommon: string; override;
    procedure ClearContents; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Draw(aCanvas: TCanvas); override;
    procedure PlaceOnEndPage(aStream: TStream); override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;

    procedure GetBlob; override;
    function CalcHeight: Integer; override;
    function RemainHeight: Integer; override;
    procedure DefinePopupMenu(Popup: TRMCustomMenuItem); override;
    procedure ShowEditor; override;
    procedure LoadFromRichEdit(aRichEdit: TJvRichEdit);
  published
    property RichEdit: TJvRichEdit read FRichEdit;
    property GapLeft;
    property GapTop;
    property ShiftWith;
    property StretchWith;
    property TextOnly;
    property BandAlign;
    property LeftFrame;
    property RightFrame;
    property TopFrame;
    property BottomFrame;
    property FillColor;
    property PrintFrame;
    property Printable;
  end;

  {TRMRxRichForm}
  TRMRxRichForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    FontDialog: TFontDialog;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    EditPopupMenu: TPopupMenu;
    ItmCut: TMenuItem;
    ItmCopy: TMenuItem;
    ItmPaste: TMenuItem;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    ItemFileNew: TMenuItem;
    ItemFileOpen: TMenuItem;
    ItemFileSaveAs: TMenuItem;
    MenuItem5: TMenuItem;
    ItemFilePrint: TMenuItem;
    MenuItem7: TMenuItem;
    ItemFileExit: TMenuItem;
    MenuEdit: TMenuItem;
    ItemEditUndo: TMenuItem;
    MenuItem11: TMenuItem;
    ItemEditCut: TMenuItem;
    ItemEditCopy: TMenuItem;
    ItemEditPaste: TMenuItem;
    ItemFormatFont: TMenuItem;
    MenuItem16: TMenuItem;
    ItemInsertField: TMenuItem;
    MenuInsert: TMenuItem;
    MenuFormat: TMenuItem;
    ItemInserObject: TMenuItem;
    ItemInsertPicture: TMenuItem;
    ItemEditRedo: TMenuItem;
    ItemEditPasteSpecial: TMenuItem;
    ItemEditSelectAll: TMenuItem;
    N20: TMenuItem;
    ItemEditFind: TMenuItem;
    ItemEditFindNext: TMenuItem;
    ItemEditReplace: TMenuItem;
    N23: TMenuItem;
    ItemEditObjProps: TMenuItem;
    PrintDialog: TPrintDialog;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    btnFileNew: TToolButton;
    btnFileOpen: TToolButton;
    btnFileSave: TToolButton;
    ToolButton4: TToolButton;
    btnFind: TToolButton;
    ToolButton6: TToolButton;
    btnCut: TToolButton;
    btnCopy: TToolButton;
    btnPaste: TToolButton;
    ToolButton10: TToolButton;
    btnUndo: TToolButton;
    btnRedo: TToolButton;
    ToolButton13: TToolButton;
    btnInsertField: TToolButton;
    ToolButton15: TToolButton;
    btnOK: TToolButton;
    btnCancel: TToolButton;
    ToolButton18: TToolButton;
    btnFontBold: TToolButton;
    btnFontItalic: TToolButton;
    btnFontUnderline: TToolButton;
    ToolButton22: TToolButton;
    ToolButton25: TToolButton;
    btnAlignLeft: TToolButton;
    btnAlignCenter: TToolButton;
    btnAlignRight: TToolButton;
    ToolButton29: TToolButton;
    btnBullets: TToolButton;
    ToolButton31: TToolButton;
    btnSuperscript: TToolButton;
    btnSubscript: TToolButton;
    ItemFormatParagraph: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RichEditChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditorProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure EditorTextNotFound(Sender: TObject; const FindText: string);
    procedure EditSelectAll(Sender: TObject);
    procedure btnFileNewClick(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure btnFileSaveClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnCutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnUndoApplyAlign(Sender: TObject; Align: TAlign;
      var Apply: Boolean);
    procedure btnRedoClick(Sender: TObject);
    procedure btnFontBoldClick(Sender: TObject);
    procedure btnFontItalicClick(Sender: TObject);
    procedure btnFontUnderlineClick(Sender: TObject);
    procedure btnAlignLeftClick(Sender: TObject);
    procedure btnBulletsClick(Sender: TObject);
    procedure ItemFileSaveAsClick(Sender: TObject);
    procedure ItemFilePrintClick(Sender: TObject);
    procedure ItemFormatFontClick(Sender: TObject);
    procedure ItemInserObjectClick(Sender: TObject);
    procedure ItemInsertPictureClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure ItemEditPasteSpecialClick(Sender: TObject);
    procedure ItemEditFindNextClick(Sender: TObject);
    procedure ItemEditReplaceClick(Sender: TObject);
    procedure ItemEditObjPropsClick(Sender: TObject);
    procedure btnInsertFieldClick(Sender: TObject);
    procedure btnSuperscriptClick(Sender: TObject);
    procedure ItemEditSelectAllClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ItemFormatParagraphClick(Sender: TObject);
  private
    FFileName: string;
    FUpdating: Boolean;
    FProtectChanging: Boolean;
    FClipboardMonitor: TJvClipboardMonitor;
    FOpenPictureDialog: TOpenDialog;
    FcmbFont: TRMFontComboBox;
    FcmbFontSize: TComboBox;
    FRuler: TRMRuler;
    FBtnFontColor: TRMColorPickerButton;
    FBtnBackColor: TRMColorPickerButton;

    function CurrText: TJvTextAttributes;
    procedure SetFileName(const FileName: string);
{$IFDEF OPENPICTUREDLG}
    procedure EditFindDialogClose(Sender: TObject; Dialog: TFindDialog);
{$ENDIF}
    procedure SetEditRect;
    procedure UpdateCursorPos;
    procedure FocusEditor;
    procedure ClipboardChanged(Sender: TObject);
    procedure PerformFileOpen(const AFileName: string);
    procedure SetModified(Value: Boolean);
    procedure OnCmbFontChange(Sender: TObject);
    procedure OnCmbFontSizeChange(Sender: TObject);
    procedure SelectionChange(Sender: TObject);
    procedure OnColorChangeEvent(Sender: TObject);
    procedure Localize;
  public
    Editor: TJvRichEdit;
  end;

{$ENDIF}

implementation

{$IFDEF RX}
uses RM_Parser, RM_Utils, RM_Const, RM_Const1, RM_Printer,
  {JvVclUtils,} RM_RxParaFmt
{$IFDEF OPENPICTUREDLG}, ExtDlgs{$ENDIF}
{$IFDEF JPeg}, JPeg{$ENDIF}
{$IFDEF RXGIF}, JvGIF{$ENDIF};

const
  RulerAdj = 4 / 3;
  GutterWid = 6;
  UndoNames: array[TUndoName] of string =
  ('', 'typing', 'delete', 'drag and drop', 'cut', 'paste');

{$R *.DFM}

function GetSpecial(const s: string; Pos: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
{  for i := 1 to Pos do
  begin
    if s[i] in [#10, #13] then
      Inc(Result);
  end;
}
//WHF Add
  i := 1;
  while i <= Pos do
  begin
    if ByteType(s, i) = mbLeadByte then
    begin
      Result := Result + 2;
      Inc(i);
    end
    else if s[i] in [#10, #13] then
      Inc(Result);
    Inc(i);
  end;
end;

procedure RMRxAssignRich(Rich1, Rich2: TJvRichEdit);
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  Rich2.Lines.SaveToStream(st);
  st.Position := 0;
  Rich1.Lines.LoadFromStream(st);
  st.Free;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMRxRichView }

constructor TRMRxRichView.Create;
begin
  inherited Create;
  BaseName := 'RxRich';

  FUseSRichEdit := False;
  FRichEdit := TJvRichEdit.Create(RMDialogForm);
  with FRichEdit do
  begin
    Parent := RMDialogForm;
    Visible := False;
    Font.Charset := StrToInt(RMLoadStr(SCharset));
    Font.Name := RMLoadStr(SRMDefaultFontName);
    Font.Size := 11;
  end;
end;

destructor TRMRxRichView.Destroy;
begin
  if RMDialogForm <> nil then
  begin
    FRichEdit.Free;
    FRichEdit := nil;
    FSRichEdit.Free;
    FSRichEdit := nil;
  end;
  inherited Destroy;
end;

function TRMRxRichView.SRichEdit: TJvRichEdit;
begin
  if FSRichEdit = nil then
  begin
    FSRichEdit := TJvRichEdit.Create(RMDialogForm);
    with FSRichEdit do
    begin
      Parent := RMDialogForm;
      Visible := False;
    end;
  end;
  Result := FSRichEdit;
end;

procedure TRMRxRichView.GetRichData(ASource: TCustomMemo);
var
  R, S: string;
  i, j: Integer;
begin
  if ParentReport.Flag_TableEmpty then
  begin
    ASource.Lines.Text := '';
    Exit;
  end;

  with ASource do
  begin
    try
      Lines.BeginUpdate;
      i := Pos('[', Text);
      while i > 0 do
      begin
        SelStart := i - 1 - GetSpecial(Text, i) div 2;
        R := RMGetBrackedVariable(Text, i, j);
        InternalOnGetValue(Self, R, S, False);
        SelLength := j - i + 1;
        SelText := S;

        i := Pos('[', Text);
      end;
    finally
      Lines.EndUpdate;
    end;
  end;
end;

function TRMRxRichView.DoCalcHeight: Integer;
var
  liFormatRange: TFormatRange;
  liLastChar, liMaxLen: Integer;
  liPixelsPerInchX: Integer;
  liPixelsPerInchY: Integer;
  lTextMetric: TTextMetric;
  liTolerance: Integer;
  liPrinter: TRMPrinter;
  liDC: HDC;
  liPrinterWidth: Integer;
  liFont: TFont;
begin
  liPrinter := GetPrinter;
  if (liPrinter <> nil) and (liPrinter.DC <> 0) then
    liDC := liPrinter.DC
  else
    liDC := GetDC(0);

  try
    FillChar(liFormatRange, SizeOf(TFormatRange), 0);
    liFormatRange.hdc := liDC;
    liFormatRange.hdcTarget := liFormatRange.hdc;
    liPixelsPerInchX := GetDeviceCaps(liDC, LOGPIXELSX);
    liPixelsPerInchY := GetDeviceCaps(liDC, LOGPIXELSY);

    if (liPrinter <> nil) and (liPrinter.DC <> 0) then
    begin
      liFont := TFont.Create;
      liFont.Assign(SRichEdit.SelAttributes);
      liPrinter.Canvas.Font := liFont;
      GetTextMetrics(liPrinter.Canvas.Handle, lTextMetric);
      liFont.Free;
    end
    else
      lTextMetric.tmDescent := 0;

    liPrinterWidth := Round(RMFromMMThousandths_Printer(
      (mmSaveWidth - mmSaveGapX * 2 - _CalcHFrameWidth(mmSaveFWLeft, mmSaveFWRight)),
      rmrtHorizontal, liPrinter));
    liPrinterWidth := Round(liPrinterWidth * 1440.0 / liPixelsPerInchX);
    liTolerance := Round(Abs(SRichEdit.SelAttributes.Size) * liPixelsPerInchY / 72);

    liFormatRange.rc := Rect(0, 0, liPrinterWidth, Round(10000000 * 1440.0 / liPixelsPerInchY));
    liFormatRange.rcPage := liFormatRange.rc;
    liLastChar := FStartCharPos;
    liMaxLen := SRichEdit.GetTextLen;
    liFormatRange.chrg.cpMin := liLastChar;
    liFormatRange.chrg.cpMax := -1;
    SRichEdit.Perform(EM_FORMATRANGE, 0, Integer(@liFormatRange));
    if liMaxLen = 0 then
      Result := 0
    else if (liFormatRange.rcPage.bottom <> liFormatRange.rc.bottom) then
      Result := Round(liFormatRange.rc.bottom / (1440.0 / liPixelsPerInchY))
    else
      Result := 0;

    SRichEdit.Perform(EM_FORMATRANGE, 0, 0);
    Result := Result + lTextMetric.tmDescent + liTolerance;
    Result := Round(RMToMMThousandths_Printer(Result, rmrtVertical, liPrinter) + 0.5);
  finally
    if (liPrinter = nil) or (liPrinter.DC = 0) then
      ReleaseDC(liDC, 0);
  end;
end;

{$WARNINGS OFF}

function TRMRxRichView.FormatRange(aDC: HDC; aFormatDC: HDC; const aRect: TRect;
  aCharRange: TCharRange; aRender: Boolean): Integer;
var
  liFormatRange: TFormatRange;
  liSaveMapMode: Integer;
  liPixelsPerInchX: Integer;
  liPixelsPerInchY: Integer;
  liRender: Integer;
  liRichEdit: TJvRichEdit;
begin
  if aRender then liRichEdit := FRichEdit else liRichEdit := SRichEdit;

  FillChar(liFormatRange, SizeOf(TFormatRange), 0);
  liFormatRange.hdc := aDC;
  liFormatRange.hdcTarget := aFormatDC;

  liPixelsPerInchX := GetDeviceCaps(aDC, LOGPIXELSX);
  liPixelsPerInchY := GetDeviceCaps(aDC, LOGPIXELSY);

  liFormatRange.rc.left := (aRect.Left * 1440 div liPixelsPerInchX) + 45;
  liFormatRange.rc.right := aRect.Right * 1440 div liPixelsPerInchX;
  liFormatRange.rc.top := aRect.Top * 1440 div liPixelsPerInchY;
  liFormatRange.rc.bottom := aRect.Bottom * 1440 div liPixelsPerInchY;
  liFormatRange.rcPage := liFormatRange.rc;
  liFormatRange.chrg.cpMin := aCharRange.cpMin;
  liFormatRange.chrg.cpMax := aCharRange.cpMax;

  if aRender then
    liRender := 1
  else
    liRender := 0;

  liSaveMapMode := SetMapMode(liFormatRange.hdc, MM_TEXT);
  liRichEdit.Perform(EM_FORMATRANGE, 0, 0); { flush buffer}
  try
    Result := liRichEdit.Perform(EM_FORMATRANGE, liRender, Longint(@liFormatRange));
  finally
    liRichEdit.Perform(EM_FORMATRANGE, 0, 0);
    SetMapMode(liFormatRange.hdc, liSaveMapMode);
  end;
end;

procedure TRMRxRichView.ShowRichText(aRender: Boolean);
var
  liCharRange: TCharRange;

  procedure _ShowRichOnPrinter;
  begin
    FormatRange(Canvas.Handle, Canvas.Handle, RealRect, liCharRange, True);
  end;

  procedure _ShowRichOnScreen;
  var
    liMetaFile: TMetaFile;
    liMetaFileCanvas: TMetaFileCanvas;
    liDC: HDC;
    liPrinter: TRMPrinter;
    liBitmap: TBitmap;
    liCanvasRect: TRect;
    liWidth, liHeight: Integer;
  begin
    liPrinter := RMPrinter;
    if liPrinter.DC <> 0 then
      liDC := liPrinter.DC
    else
      liDC := GetDC(0);

    liMetaFile := TMetaFile.Create;
    try
      if aRender then
      begin
        liWidth := mmSaveWidth - mmSaveGapX * 2 - _CalcHFrameWidth(mmSaveFWLeft, mmSaveFWRight);
        liHeight := mmSaveHeight - mmSaveGapY * 2 - _CalcVFrameWidth(mmSaveFWTop, mmSaveFWBottom);
      end
      else
      begin
        liWidth := mmWidth - mmGapLeft * 2 - _CalcHFrameWidth(LeftFrame.mmWidth, RightFrame.mmWidth);
        liHeight := mmHeight - mmGapTop * 2 - _CalcVFrameWidth(TopFrame.mmWidth, BottomFrame.mmWidth);
      end;

      liCanvasRect := Rect(0, 0,
        Round(RMFromMMThousandths_Printer(liWidth, rmrtHorizontal, liPrinter)) + 1,
        Round(RMFromMMThousandths_Printer(liHeight, rmrtVertical, liPrinter)));
      liMetaFile.Width := liCanvasRect.Right - liCanvasRect.Left;
      liMetaFile.Height := liCanvasRect.Bottom - liCanvasRect.Top;

      liMetaFileCanvas := TMetaFileCanvas.Create(liMetaFile, liDC);
      liMetaFileCanvas.Brush.Style := bsClear;

      FEndCharPos := FormatRange(liMetaFileCanvas.Handle, liDC, liCanvasRect, liCharRange, aRender);

      liMetaFileCanvas.Free;
      if liPrinter.DC = 0 then
        ReleaseDC(0, liDC);

      if aRender then
      begin
        if DocMode = rmdmDesigning then
        begin
          liBitmap := TBitmap.Create;
          liBitmap.Width := RealRect.Right - RealRect.Left + 1;
          liBitmap.Height := RealRect.Bottom - RealRect.Top + 1;
          liBitmap.Canvas.StretchDraw(Rect(0, 0, liBitmap.Width, liBitmap.Height), liMetaFile);
          Canvas.Draw(RealRect.Left, RealRect.Top, liBitmap);
          liBitmap.Free;
        end
        else
          Canvas.StretchDraw(RealRect, liMetaFile);
      end;
    finally
      liMetaFile.Free;
    end;
  end;

begin
  FEndCharPos := FStartCharPos;
  liCharRange.cpMax := -1;
  liCharRange.cpMin := FEndCharPos;
  if DocMode = rmdmPrinting then
    _ShowRichOnPrinter
  else
    _ShowRichOnScreen;
end;
{$WARNINGS ON}

procedure TRMRxRichView.Draw(aCanvas: TCanvas);
begin
  BeginDraw(aCanvas);
  CalcGaps;
  with aCanvas do
  begin
    ShowBackground;
    FStartCharPos := 0;
    InflateRect(RealRect, -RMToScreenPixels(mmGapLeft, rmutMMThousandths),
      -RMToScreenPixels(mmGapTop, rmutMMThousandths));
    if (spWidth > 0) and (spHeight > 0) then
      ShowRichText(True);
    ShowFrame;
  end;
  RestoreCoord;
end;

procedure TRMRxRichView.Prepare;
begin
  inherited Prepare;
  FStartCharPos := 0;
end;

procedure TRMRxRichView.GetMemoVariables;
begin
  if DrawMode = rmdmAll then
  begin
    Memo1.Assign(Memo);
    InternalOnBeforePrint(Memo1, Self);
    RMRxAssignRich(SRichEdit, FRichEdit);
    if not TextOnly then
      GetRichData(SRichEdit);
  end;
end;

procedure TRMRxRichView.PlaceOnEndPage(aStream: TStream);
var
  n: integer;
begin
  BeginDraw(Canvas);
  if not Visible then Exit;

  GetMemoVariables;
  if DrawMode = rmdmPart then
  begin
    FStartCharPos := FEndCharPos;
    ShowRichText(False);
    n := SRichEdit.GetTextLen - FEndCharPos + 1;
    if n > 0 then
    begin
      SRichEdit.SelStart := FEndCharPos;
      SRichEdit.SelLength := n;
      SRichEdit.SelText := '';
    end;

    SRichEdit.SelStart := 0;
    SRichEdit.SelLength := FSaveCharPos;
    SRichEdit.SelText := '';

    FSaveCharPos := FEndCharPos;
  end;

  aStream.Write(Typ, 1);
  RMWriteString(aStream, ClassName);
  FUseSRichEdit := True;
  try
    SaveToStream(aStream);
  finally
    FUseSRichEdit := False;
  end;
end;

function TRMRxRichView.CalcHeight: Integer;
begin
  FEndCharPos := 0;
  FSaveCharPos := 0;
  Result := 0;
  if not Visible then
    Exit;

  CalcGaps;
  DrawMode := rmdmAll;
  GetMemoVariables;
//  DrawMode := rmdmAfterCalcHeight;

  FStartCharPos := 0;
  CalculatedHeight := RMToMMThousandths(spGapTop * 2 + _CalcVFrameWidth(TopFrame.spWidth, BottomFrame.spWidth), rmutScreenPixels) +
    DoCalcHeight;
  RestoreCoord;
  Result := CalculatedHeight;
end;

function TRMRxRichView.RemainHeight: Integer;
begin
  DrawMode := rmdmAll;
  GetMemoVariables;
//  DrawMode := rmdmAfterCalcHeight;

  FStartCharPos := FEndCharPos + 1;
  ActualHeight := RMToMMThousandths(spGapTop * 2 + _CalcVFrameWidth(TopFrame.spWidth, BottomFrame.spWidth), rmutScreenPixels) +
    DoCalcHeight;
  Result := ActualHeight;
end;

procedure TRMRxRichView.LoadFromStream(aStream: TStream);
var
  b: Byte;
  liSavePos: Integer;
begin
  inherited LoadFromStream(aStream);
  RMReadWord(aStream);
  b := RMReadByte(aStream);
  liSavePos := RMReadInt32(aStream);
  if b > 0 then
    FRichEdit.Lines.LoadFromStream(aStream);
  aStream.Seek(liSavePos, soFromBeginning);
end;

procedure TRMRxRichView.SaveToStream(aStream: TStream);
var
  b: Byte;
  liSavePos, liPos: Integer;
  liRichEdit: TJvRichEdit;
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 0);
  if FUseSRichEdit then
    liRichEdit := SRichEdit
  else
    liRichEdit := FRichEdit;

  if liRichEdit.Lines.Count > 0 then b := 1 else b := 0;
  RMWriteByte(aStream, b);

  liSavePos := aStream.Position;
  RMWriteInt32(aStream, liSavePos);
  if b > 0 then
    liRichEdit.Lines.SaveToStream(aStream);

  liPos := aStream.Position;
  aStream.Seek(liSavePos, soFromBeginning);
  RMWriteInt32(aStream, liPos);
  aStream.Seek(liPos, soFromBeginning);
end;

procedure TRMRxRichView.GetBlob;
var
  liStream: TMemoryStream;
begin
  liStream := TMemoryStream.Create;
  try
    if not ParentReport.Flag_TableEmpty then
      FDataSet.AssignBlobFieldTo(FDataFieldName, liStream);
    FRichEdit.Lines.LoadFromStream(liStream);
  finally
    liStream.Free;
  end;
end;

procedure TRMRxRichView.ShowEditor;
var
  tmpForm: TRMRxRichForm;
begin
  tmpForm := TRMRxRichForm.Create(Application);
  try
    RMRxAssignRich(tmpForm.Editor, FRichEdit);
    if tmpForm.ShowModal = mrOK then
    begin
      RMDesigner.BeforeChange;
      RMRxAssignRich(FRichEdit, tmpForm.Editor);
      RMDesigner.AfterChange;
    end;
  finally
    tmpForm.Free;
  end;
end;

procedure TRMRxRichView.DefinePopupMenu(Popup: TRMCustomMenuItem);
begin
  inherited DefinePopupMenu(Popup);
end;

procedure TRMRxRichView.LoadFromRichEdit(aRichEdit: TJvRichEdit);
begin
  RMRxAssignRich(FRichEdit, aRichEdit);
end;

function TRMRxRichView.GetViewCommon: string;
begin
  Result := '[Rx Rich]';
end;

procedure TRMRxRichView.ClearContents;
begin
  FRichEdit.Clear;
  inherited;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMRxRichForm}

procedure TRMRxRichForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

//  Caption := RMLoadStr(rmRes + 560);
  RMSetStrProp(btnFileNew, 'Hint', rmRes + 155);
  RMSetStrProp(btnFileOpen, 'Hint', rmRes + 561);
  RMSetStrProp(btnFileSave, 'Hint', rmRes + 562);
  RMSetStrProp(btnUndo, 'Hint', rmRes + 94);
  RMSetStrProp(btnRedo, 'Hint', rmRes + 95);
  RMSetStrProp(btnFind, 'Hint', rmRes + 582);
  RMSetStrProp(btnFontBold, 'Hint', rmRes + 564);
  RMSetStrProp(btnFontItalic, 'Hint', rmRes + 565);
  RMSetStrProp(btnFontUnderline, 'Hint', rmRes + 569);
  RMSetStrProp(btnAlignLeft, 'Hint', rmRes + 566);
  RMSetStrProp(btnAlignCenter, 'Hint', rmRes + 567);
  RMSetStrProp(btnAlignRight, 'Hint', rmRes + 568);
  RMSetStrProp(btnBullets, 'Hint', rmRes + 570);
  RMSetStrProp(btnInsertField, 'Hint', rmRes + 575);
  RMSetStrProp(btnCut, 'Hint', rmRes + 91);
  RMSetStrProp(btnCopy, 'Hint', rmRes + 92);
  RMSetStrProp(btnPaste, 'Hint', rmRes + 93);
  RMSetStrProp(btnSuperscript, 'Hint', rmRes + 580);
  RMSetStrProp(btnSubscript, 'Hint', rmRes + 581);

  ItmCut.Caption := btnCut.Hint;
  ItmCopy.Caption := btnCopy.Hint;
  ItmPaste.Caption := btnPaste.Hint;
  RMSetStrProp(MenuFile, 'Caption', rmRes + 154);
  RMSetStrProp(ItemFileNew, 'Caption', rmRes + 155);
  RMSetStrProp(ItemFileOpen, 'Caption', rmRes + 156);
  RMSetStrProp(ItemFileSaveAs, 'Caption', rmRes + 188);
  RMSetStrProp(ItemFilePrint, 'Caption', rmRes + 159);
  RMSetStrProp(ItemFileExit, 'Caption', rmRes + 162);
  RMSetStrProp(MenuEdit, 'Caption', rmRes + 163);
  RMSetStrProp(ItemEditUndo, 'Caption', rmRes + 164);
  RMSetStrProp(ItemEditRedo, 'Caption', rmRes + 165);
  RMSetStrProp(ItemEditCut, 'Caption', rmRes + 166);
  RMSetStrProp(ItemEditCopy, 'Caption', rmRes + 167);
  RMSetStrProp(ItemEditPaste, 'Caption', rmRes + 168);
  RMSetStrProp(ItemEditPasteSpecial, 'Caption', rmRes + 572);
  RMSetStrProp(ItemEditSelectAll, 'Caption', rmRes + 170);
  RMSetStrProp(ItemEditFind, 'Caption', rmRes + 582);
  RMSetStrProp(ItemEditFindNext, 'Caption', rmRes + 583);
  RMSetStrProp(ItemEditReplace, 'Caption', rmRes + 584);
  RMSetStrProp(ItemEditObjProps, 'Caption', rmRes + 585);
  RMSetStrProp(MenuInsert, 'Caption', rmRes + 586);
  RMSetStrProp(ItemInserObject, 'Caption', rmRes + 587);
  RMSetStrProp(ItemInsertPicture, 'Caption', rmRes + 588);
  RMSetStrProp(ItemInsertField, 'Caption', rmRes + 575);
  RMSetStrProp(MenuFormat, 'Caption', rmRes + 589);
  RMSetStrProp(ItemFormatFont, 'Caption', rmRes + 576);
  RMSetStrProp(ItemFormatParagraph, 'Caption', rmRes + 852);

  btnOK.Hint := RMLoadStr(rmRes + 573);
  btnCancel.Hint := RMLoadStr(rmRes + 574);
end;

procedure TRMRxRichForm.FocusEditor;
begin
  with Editor do
  begin
    if CanFocus then
      SetFocus;
  end;
end;

procedure TRMRxRichForm.SelectionChange(Sender: TObject);
var
  lFont: TFont;
  lFontHeight: Integer;
begin
  with Editor.Paragraph do
  begin
    try
      FUpdating := True;
      FRuler.UpdateInd;
      BtnFontBold.Down := fsBold in CurrText.Style;
      BtnFontItalic.Down := fsItalic in CurrText.Style;
      BtnFontUnderline.Down := fsUnderline in CurrText.Style;
      BtnBullets.Down := Boolean(Numbering);
      BtnSuperscript.Down := CurrText.SubscriptStyle = ssSuperscript;
      BtnSubscript.Down := CurrText.SubscriptStyle = ssSubscript;

      lFont := TFont.Create;
      lFont.Size := CurrText.Size;
      lFontHeight := lFont.Height;
      lFont.Free;
      RMSetFontSize(TComboBox(FCmbFontSize), lFontHeight, CurrText.Size);

      FCmbFont.FontName := CurrText.Name;
      case Ord(Alignment) of
        0: BtnAlignLeft.Down := True;
        1: BtnAlignRight.Down := True;
        2: BtnAlignCenter.Down := True;
      end;
      UpdateCursorPos;
    finally
      FUpdating := False;
    end;
  end;
end;

function TRMRxRichForm.CurrText: TJvTextAttributes;
begin
  if Editor.SelLength > 0 then
    Result := Editor.SelAttributes
  else
    Result := Editor.WordAttributes;
end;

procedure TRMRxRichForm.SetFileName(const FileName: string);
begin
  FFileName := FileName;
  Editor.Title := ExtractFileName(FileName);
end;

procedure TRMRxRichForm.SetEditRect;
var
  R: TRect;
  Offs: Integer;
begin
  with Editor do
  begin
    if SelectionBar then
      Offs := 3
    else
      Offs := 0;
    R := Rect(GutterWid + Offs, 0, ClientWidth - GutterWid, ClientHeight);
    SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
  end;
end;

{ Event Handlers }

procedure TRMRxRichForm.FormCreate(Sender: TObject);
var
  i, liOffset: Integer;
  s, s1: string;
begin
  Localize;
  Editor := TJvRichEdit.Create(Self);
  with Editor do
  begin
    Parent := Self;
    Align := alClient;
    HideSelection := False;
    Editor.PopupMenu := Self.EditPopupMenu;
    WantTabs := False;
    ScrollBars := ssBoth;

    OnTextNotFound := EditorTextNotFound;
    OnSelectionChange := SelectionChange;
    OnProtectChange := EditorProtectChange;
    OnChange := RichEditChange;
  end;

  FcmbFont := TRMFontComboBox.Create(ToolBar2);
  with FcmbFont do
  begin
    Parent := ToolBar2;
    Left := 0;
    Top := 0;
    Height := 21;
    Width := 150;
    Tag := 7;
//    Device := rmfdPrinter;
    OnChange := OnCmbFontChange;
  end;
  FcmbFontSize := TComboBox.Create(ToolBar2);
  with FcmbFontSize do
  begin
    Parent := ToolBar2;
    Left := 150;
    Top := 0;
    Height := 21;
    Width := 59;
    Tag := 8;
    DropDownCount := 12;
    if RMIsChineseGB then
      liOffset := 0
    else
      liOffset := 13;
    for i := Low(RMDefaultFontSizeStr) + liOffset to High(RMDefaultFontSizeStr) do
      Items.Add(RMDefaultFontSizeStr[i]);
    OnChange := OnCmbFontSizeChange;
  end;
  FBtnFontColor := TRMColorPickerButton.Create(ToolBar2);
  with FBtnFontColor do
  begin
    Parent := ToolBar2;
    Left := ToolButton18.Left + ToolButton18.Width;
    Top := 0;
    ColorType := rmptFont;
    OnColorChange := OnColorChangeEvent;
  end;
  FBtnBackColor := TRMColorPickerButton.Create(ToolBar2);
  with FBtnBackColor do
  begin
    Parent := ToolBar2;
    Left := FBtnFontColor.Left + FBtnFontColor.Width;
    Top := 0;
    ColorType := rmptFill;
    OnColorChange := OnColorChangeEvent;
  end;

  FRuler := TRMRuler.Create(Self);
  with FRuler do
  begin
    Top := ToolBar2.Top + ToolBar2.Height;
    RichEdit := TCustomRichEdit(Editor);
    Align := alTop;
    Height := 26;
    OnIndChanged := SelectionChange;
  end;

  OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
  SaveDialog.InitialDir := OpenDialog.InitialDir;
  SetFileName('Untitled');
  HandleNeeded;
  SelectionChange(Self);
{$IFDEF OPENPICTUREDLG}
  Editor.OnCloseFindDialog := EditFindDialogClose;
  FOpenPictureDialog := TOpenPictureDialog.Create(Self);
{$ELSE}
  FOpenPictureDialog := TOpenDialog.Create(Self);
{$ENDIF}

  s := '*.bmp *.ico *.wmf *.emf';
  s1 := '*.bmp;*.ico;*.wmf;*.emf';
{$IFDEF JPEG}
  s := s + ' *.jpg';
  s1 := s1 + ';*.jpg';
{$ENDIF}
{$IFDEF RXGIF}
  s := s + ' *.gif';
  s1 := s1 + ';*.gif';
{$ENDIF}
  FOpenPictureDialog.Filter := RMLoadStr(SPictFile) + ' (' + s + ')|' + s1 + '|' + RMLoadStr(SAllFiles) + '|*.*';

  FClipboardMonitor := TJvClipboardMonitor.Create(Self);
  FClipboardMonitor.OnChange := ClipboardChanged;
  BtnSuperscript.Enabled := RichEditVersion >= 2;
  BtnSubscript.Enabled := RichEditVersion >= 2;
  FBtnBackColor.Enabled := RichEditVersion >= 2;
end;

procedure TRMRxRichForm.PerformFileOpen(const AFileName: string);
begin
  FProtectChanging := True;
  try
    Editor.Lines.LoadFromFile(AFileName);
  finally
    FProtectChanging := False;
  end;
  SetFileName(AFileName);
  Editor.SetFocus;
  Editor.Modified := False;
  SetModified(False);
end;

procedure TRMRxRichForm.FormResize(Sender: TObject);
begin
  SetEditRect;
  SelectionChange(Sender);
end;

procedure TRMRxRichForm.FormPaint(Sender: TObject);
begin
  SetEditRect;
end;

procedure TRMRxRichForm.UpdateCursorPos;
var
  CharPos: TPoint;
begin
  CharPos := Editor.CaretPos;
  StatusBar.Panels[0].Text := Format('行: %3d  列: %3d', [CharPos.Y + 1, CharPos.X + 1]);
  BtnCopy.Enabled := Editor.SelLength > 0;
  ItemEditCopy.Enabled := BtnCopy.Enabled;
  ItmCopy.Enabled := BtnCopy.Enabled;
  BtnCut.Enabled := ItemEditCopy.Enabled;
  ItmCut.Enabled := btnCut.Enabled;
  ItemEditPasteSpecial.Enabled := btnCopy.Enabled;
  ItemEditCut.Enabled := ItemEditCopy.Enabled;
  ItemEditObjProps.Enabled := Editor.SelectionType = [stObject];
end;

procedure TRMRxRichForm.FormShow(Sender: TObject);
begin
  UpdateCursorPos;
  RichEditChange(nil);
  SetModified(FALSE);
  FocusEditor;
  ClipboardChanged(nil);
end;

procedure TRMRxRichForm.RichEditChange(Sender: TObject);
begin
  SetModified(Editor.Modified);
  { Undo }
  BtnUndo.Enabled := Editor.CanUndo;
  ItemEditUndo.Enabled := btnUndo.Enabled;
  ItemEditUndo.Caption := '取消(&U) ' + UndoNames[Editor.UndoName];
  { Redo }
  ItemEditRedo.Enabled := Editor.CanRedo;
  btnRedo.Enabled := ItemEditRedo.Enabled;
  ItemEditRedo.Caption := '重复(&R) ' + UndoNames[Editor.RedoName];
end;

procedure TRMRxRichForm.SetModified(Value: Boolean);
begin
  if Value then
    StatusBar.Panels[1].Text := '修改'
  else
    StatusBar.Panels[1].Text := '';
end;

procedure TRMRxRichForm.ClipboardChanged(Sender: TObject);
var
  E: Boolean;
begin
  E := Editor.CanPaste;
  btnPaste.Enabled := E;
  ItemEditPaste.Enabled := E;
  ItemEditPasteSpecial.Enabled := E;
  ItmPaste.Enabled := E;
end;

procedure TRMRxRichForm.FormDestroy(Sender: TObject);
begin
  FClipboardMonitor.Free;
  FRuler.Free;
end;

procedure TRMRxRichForm.EditorTextNotFound(Sender: TObject;
  const FindText: string);
begin
  MessageDlg(Format('Text "%s" not found.', [FindText]), mtWarning,
    [mbOk], 0);
end;

{$IFDEF OPENPICTUREDLG}

procedure TRMRxRichForm.EditFindDialogClose(Sender: TObject; Dialog: TFindDialog);
begin
  FocusEditor;
end;
{$ENDIF}

procedure TRMRxRichForm.EditorProtectChange(Sender: TObject; StartPos,
  EndPos: Integer; var AllowChange: Boolean);
begin
  AllowChange := FProtectChanging;
end;

procedure TRMRxRichForm.EditSelectAll(Sender: TObject);
begin
  Editor.SelectAll;
end;

procedure TRMRxRichForm.btnFileNewClick(Sender: TObject);
begin
  SetFileName('Untitled');
  FProtectChanging := True;
  try
    Editor.Lines.Clear;
    Editor.Modified := False;
    Editor.ReadOnly := False;
    SetModified(False);
    with Editor do
    begin
      DefAttributes.Assign(Font);
      SelAttributes.Assign(Font);
    end;
    SelectionChange(nil);
  finally
    FProtectChanging := False;
  end;
end;

procedure TRMRxRichForm.btnFileOpenClick(Sender: TObject);
begin
  OpenDialog.Filter := RMLoadStr(SRTFFile) + '(*.rtf)|*.rtf' + '|' +
    RMLoadStr(STextFile) + '(*.txt)|*.txt';
  if OpenDialog.Execute then
  begin
    PerformFileOpen(OpenDialog.FileName);
    Editor.ReadOnly := ofReadOnly in OpenDialog.Options;
  end;
end;

procedure TRMRxRichForm.btnFileSaveClick(Sender: TObject);
begin
  if FFileName = 'Untitled' then
    ItemFileSaveAs.Click
  else
  begin
    Editor.Lines.SaveToFile(FFileName);
    Editor.Modified := False;
    SetModified(False);
    RichEditChange(nil);
  end;
end;

procedure TRMRxRichForm.btnFindClick(Sender: TObject);
begin
  with Editor do
    FindDialog(SelText);
end;

procedure TRMRxRichForm.btnCutClick(Sender: TObject);
begin
  Editor.CutToClipboard;
end;

procedure TRMRxRichForm.btnCopyClick(Sender: TObject);
begin
  Editor.CopyToClipboard;
end;

procedure TRMRxRichForm.btnPasteClick(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TRMRxRichForm.btnUndoApplyAlign(Sender: TObject; Align: TAlign;
  var Apply: Boolean);
begin
  Editor.Undo;
  RichEditChange(nil);
  SelectionChange(nil);
end;

procedure TRMRxRichForm.btnRedoClick(Sender: TObject);
begin
  Editor.Redo;
  RichEditChange(nil);
  SelectionChange(nil);
end;

procedure TRMRxRichForm.btnFontBoldClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  if btnFontBold.Down then
    CurrText.Style := CurrText.Style + [fsBold]
  else
    CurrText.Style := CurrText.Style - [fsBold];
end;

procedure TRMRxRichForm.btnFontItalicClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  if btnFontItalic.Down then
    CurrText.Style := CurrText.Style + [fsItalic]
  else
    CurrText.Style := CurrText.Style - [fsItalic];
end;

procedure TRMRxRichForm.btnFontUnderlineClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  if btnFontUnderline.Down then
    CurrText.Style := CurrText.Style + [fsUnderline]
  else
    CurrText.Style := CurrText.Style - [fsUnderline];
end;

procedure TRMRxRichForm.btnAlignLeftClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  Editor.Paragraph.Alignment := TParaAlignment(TComponent(Sender).Tag);
end;

procedure TRMRxRichForm.btnBulletsClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  Editor.Paragraph.Numbering := TJvNumbering(btnBullets.Down);
end;

procedure TRMRxRichForm.ItemFileSaveAsClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    Editor.Lines.SaveToFile(SaveDialog.FileName);
    SetFileName(SaveDialog.FileName);
    Editor.Modified := False;
    SetModified(False);
    RichEditChange(nil);
  end;
  FocusEditor;
end;

procedure TRMRxRichForm.ItemFilePrintClick(Sender: TObject);
begin
  if PrintDialog.Execute then
    Editor.Print(FFileName);
end;

procedure TRMRxRichForm.ItemFormatFontClick(Sender: TObject);
begin
  FontDialog.Font.Assign(Editor.SelAttributes);
  if FontDialog.Execute then
    CurrText.Assign(FontDialog.Font);
  FocusEditor;
end;

procedure TRMRxRichForm.ItemInserObjectClick(Sender: TObject);
begin
  Editor.InsertObjectDialog;
end;

procedure TRMRxRichForm.ItemInsertPictureClick(Sender: TObject);
var
  Pict: TPicture;
begin
  with FOpenPictureDialog do
  begin
    if Execute then
    begin
      Pict := TPicture.Create;
      try
        Pict.LoadFromFile(FileName);
        Clipboard.Assign(Pict);
        Editor.PasteFromClipboard;
      finally
        Pict.Free;
      end;
    end;
  end;
end;

procedure TRMRxRichForm.btnUndoClick(Sender: TObject);
begin
  Editor.Undo;
  RichEditChange(nil);
  SelectionChange(nil);
end;

procedure TRMRxRichForm.ItemEditPasteSpecialClick(Sender: TObject);
begin
  try
    Editor.PasteSpecialDialog;
  finally
    FocusEditor;
  end;
end;

procedure TRMRxRichForm.ItemEditFindNextClick(Sender: TObject);
begin
  if not Editor.FindNext then
  begin
    Exit;
//    Beep;
  end;

  FocusEditor;
end;

procedure TRMRxRichForm.ItemEditReplaceClick(Sender: TObject);
begin
  with Editor do
    ReplaceDialog(SelText, '');
end;

procedure TRMRxRichForm.ItemEditObjPropsClick(Sender: TObject);
begin
  Editor.ObjectPropertiesDialog;
end;

procedure TRMRxRichForm.btnInsertFieldClick(Sender: TObject);
var
  s: string;
begin
  if RMDesigner <> nil then
  begin
    s := RMDesigner.InsertExpression;
    if s <> '' then
      Editor.SelText := s;
  end;
end;

procedure TRMRxRichForm.btnSuperscriptClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  if btnSuperscript.Down then
    CurrText.SubscriptStyle := ssSuperscript
  else if btnSubscript.Down then
    CurrText.SubscriptStyle := ssSubscript
  else
    CurrText.SubscriptStyle := ssNone;
end;

procedure TRMRxRichForm.ItemEditSelectAllClick(Sender: TObject);
begin
  Editor.SelectAll;
end;

procedure TRMRxRichForm.OnCmbFontChange(Sender: TObject);
begin
  if FUpdating then
    Exit;
  CurrText.Name := FCmbFont.FontName;
  if RMIsChineseGB then
  begin
    if ByteType(FCmbFont.FontName, 1) = mbSingleByte then
      CurrText.Charset := ANSI_CHARSET
    else
      CurrText.Charset := GB2312_CHARSET;
  end;
end;

procedure TRMRxRichForm.OnCmbFontSizeChange(Sender: TObject);
var
  liFontSize: Integer;
  lFont: TFont;
begin
  if FUpdating then Exit;

  liFontSize := RMGetFontSize(TComboBox(FCmbFontSize));
  if liFontSize > 0 then
    CurrText.Size := liFontSize
  else
  begin
    lFont := TFont.Create;
    lFont.Height := liFontSize;
    liFontSize := lFont.Size;
    CurrText.Size := liFontSize;
    lFont.Free;
  end;
end;

procedure TRMRxRichForm.btnOKClick(Sender: TObject);
begin
  OnResize := nil;
  ModalResult := mrOK;
end;

procedure TRMRxRichForm.btnCancelClick(Sender: TObject);
begin
  OnResize := nil;
  ModalResult := mrCancel;
end;

procedure TRMRxRichForm.OnColorChangeEvent(Sender: TObject);
begin
  if Sender = FBtnFontColor then
    CurrText.Color := FBtnFontColor.CurrentColor
  else
    CurrText.BackColor := FBtnBackColor.CurrentColor;
end;

procedure TRMRxRichForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  OnResize := nil;
end;

procedure TRMRxRichForm.ItemFormatParagraphClick(Sender: TObject);
var
  tmp: TRMParaFormatDlg;
begin
  tmp := TRMParaFormatDlg.Create(nil);
  try
    tmp.SpacingBox.Enabled := (RichEditVersion >= 2);
    tmp.UpDownLeftIndent.Position := Editor.Paragraph.LeftIndent;
    tmp.UpDownRightIndent.Position := Editor.Paragraph.RightIndent;
    tmp.UpDownFirstIndent.Position := Editor.Paragraph.FirstIndent;
    tmp.Alignment.ItemIndex := Ord(Editor.Paragraph.Alignment);
    tmp.UpDownSpaceBefore.Position := Editor.Paragraph.SpaceBefore;
    tmp.UpDownSpaceAfter.Position := Editor.Paragraph.SpaceAfter;
    tmp.UpDownLineSpacing.Position := Editor.Paragraph.LineSpacing;
    if tmp.ShowModal = mrOK then
    begin
      Editor.Paragraph.LeftIndent := tmp.UpDownLeftIndent.Position;
      Editor.Paragraph.RightIndent := tmp.UpDownRightIndent.Position;
      Editor.Paragraph.FirstIndent := tmp.UpDownFirstIndent.Position;
      Editor.Paragraph.Alignment := TParaAlignment(tmp.Alignment.ItemIndex);
      Editor.Paragraph.SpaceBefore := tmp.UpDownSpaceBefore.Position;
      Editor.Paragraph.SpaceAfter := tmp.UpDownSpaceAfter.Position;
      if tmp.UpDownLineSpacing.Position > 0 then
        Editor.Paragraph.LineSpacingRule := lsSpecifiedOrMore
      else
        Editor.Paragraph.LineSpacingRule := lsSingle;
      Editor.Paragraph.LineSpacing := tmp.UpDownLineSpacing.Position;
    end;
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure TRMRxRichView_LoadFromRichEdit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMRxRichView(Args.Obj).LoadFromRichEdit(TJvRichEdit(V2O(Args.Values[0])));
end;


procedure RM_RegisterRAI2Adapter(RAI2Adapter: TJvInterpreterAdapter);
begin
  with RAI2Adapter do
  begin
    AddClass('ReportMachine', TRMRxRichView, 'TRMRxRichView');

    AddGet(TRMRxRichView, 'LoadFromRichEdit', TRMRxRichView_LoadFromRichEdit, 1, [0], varEmpty);
  end;
end;

initialization
  RMRegisterObjectByRes(TRMRxRichView, 'RM_RxRichObject', RMLoadStr(SInsRich2Object), TRMRxRichForm);
  RM_RegisterRAI2Adapter(GlobalJvInterpreterAdapter);

finalization

{$ENDIF}
end.

