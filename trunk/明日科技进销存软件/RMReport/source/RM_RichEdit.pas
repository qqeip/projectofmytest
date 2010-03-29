
{*****************************************}
{                                         }
{         Report Machine v2.0             }
{           Rich Add-In Object            }
{                                         }
{*****************************************}

unit RM_RichEdit;

interface

{$I RM.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Menus,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ClipBrd,
  DB, RM_Class, RM_Ctrls, RM_DsgCtrls, RichEdit, ToolWin
{$IFDEF USE_INTERNAL_JVCL}, rm_JvInterpreter{$ELSE}, JvInterpreter{$ENDIF}
{$IFDEF TntUnicode}, TntComCtrls, TntSysUtils{$ENDIF}
{$IFDEF Delphi4}, ImgList{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

type
  TRMRichObject = class(TComponent) // fake component
  end;

  TRMRichEditVersion = 1..3;
  TRMSubscriptStyle = (rmssNone, rmssSubscript, rmssSuperscript);

{$IFNDEF Delphi3}
  TCharFormat2A = record
    cbSize: UINT;
    dwMask: DWORD;
    dwEffects: DWORD;
    yHeight: Longint;
    yOffset: Longint;
    crTextColor: TColorRef;
    bCharSet: Byte;
    bPitchAndFamily: Byte;
    szFaceName: array[0..LF_FACESIZE - 1] of AnsiChar;
    { new fields in version 2.0 }
    wWeight: Word; { Font weight (LOGFONT value)             }
    sSpacing: Smallint; { Amount to space between letters         }
    crBackColor: TColorRef; { Background color                        }
    lid: LCID; { Locale ID                               }
    dwReserved: DWORD; { Reserved. Must be 0                     }
    sStyle: Smallint; { Style handle                            }
    wKerning: Word; { Twip size above which to kern char pair }
    bUnderlineType: Byte; { Underline type                          }
    bAnimation: Byte; { Animated text like marching ants        }
    bRevAuthor: Byte; { Revision author index                   }
    bReserved1: Byte;
  end;
  TCharFormat2 = TCharFormat2A;
{$ENDIF}

  TRMRichEdit = {$IFDEF TntUnicode}TTntRichEdit{$ELSE}TRichEdit{$ENDIF};

  { TRMRichView }
  TRMRichView = class(TRMStretcheableView)
  private
    FStartCharPos, FEndCharPos, FSaveCharPos: Integer;
    FRichEdit, FSRichEdit: TRMRichEdit;
    FPixelsPerInch: TPoint;
    FUseSRichEdit: Boolean;

    function SRichEdit: TRMRichEdit;
    procedure GetRichData(aSource: TRMRichEdit);
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
    procedure LoadFromRichEdit(aRichEdit: TRMRichEdit);
    function CalcHeight: Integer; override;
    function RemainHeight: Integer; override;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;
    procedure ShowEditor; override;
  published
    property RichEdit: TRMRichEdit read FRichEdit;
    property GapLeft;
    property GapTop;
    property ShiftWith;
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

  { TRMRichForm }
  TRMRichForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    FontDialog1: TFontDialog;
    ToolBar: TToolBar;
    btnFileOpen: TToolButton;
    btnFileSave: TToolButton;
    btnFilePrint: TToolButton;
    ToolButton5: TToolButton;
    btnUndo: TToolButton;
    btnCut: TToolButton;
    btnCopy: TToolButton;
    btnPaste: TToolButton;
    ToolButton10: TToolButton;
    ToolbarImages: TImageList;
    btnInsertField: TToolButton;
    btnCancel: TToolButton;
    btnOK: TToolButton;
    StatusBar: TStatusBar;
    PrintDialog: TPrintDialog;
    btnFont: TToolButton;
    ToolButton2: TToolButton;
    ToolBar1: TToolBar;
    ToolButton4: TToolButton;
    ToolButton8: TToolButton;
    btnAlignLeft: TToolButton;
    btnAlignCenter: TToolButton;
    btnAlignRight: TToolButton;
    ToolButton13: TToolButton;
    btnBullets: TToolButton;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    ToolButton7: TToolButton;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    EditMenu: TMenuItem;
    EditUndoItem: TMenuItem;
    N2: TMenuItem;
    EditCutItem: TMenuItem;
    EditCopyItem: TMenuItem;
    EditPasteItem: TMenuItem;
    N5: TMenuItem;
    EditFontItem: TMenuItem;
    N3: TMenuItem;
    EditInsertFieldItem: TMenuItem;
    btnFontBold: TToolButton;
    btnFontItalic: TToolButton;
    btnFontUnderline: TToolButton;
    ToolButton1: TToolButton;
    btnSuperscript: TToolButton;
    btnSubscript: TToolButton;

    procedure SelectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);
    procedure EditUndo(Sender: TObject);
    procedure SelectFont(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnInsertFieldClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure FileNewItemClick(Sender: TObject);
    procedure btnFilePrintClick(Sender: TObject);
    procedure EditorChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnBulletsClick(Sender: TObject);
    procedure btnAlignLeftClick(Sender: TObject);
    procedure btnFontBoldClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSuperscriptClick(Sender: TObject);
  private
    FStatusString: string;
    FUpdating: Boolean;
    FFileName: string;
    FcmbFont: TRMFontComboBox;
    FcmbFontSize: TComboBox;
    FRuler: TRMRuler;
    FBtnFontColor: TRMColorPickerButton;

    function CurrText: TTextAttributes;
    procedure SetFileName(const FileName: string);
    procedure SetModified(Value: Boolean);
    procedure SetEditRect;
    procedure UpdateCaretPos;
    procedure OnCmbFontChange(Sender: TObject);
    procedure OnCmbFontSizeChange(Sender: TObject);
    procedure OnColorChangeEvent(Sender: TObject);
    procedure Localize;
  public
    Editor: TRMRichEdit;
  end;

procedure RMInitFormat(var Format: TCharFormat2);
function RMGetSubscriptStyle(ARichEdit: TCustomRichEdit): TRMSubscriptStyle;
procedure RMSetSubscriptStyle(ARichEdit: TCustomRichEdit; AStyle: TRMSubscriptStyle);
procedure RMAssignRich(Rich1, Rich2: TRMRichEdit);

var
  RichEditVersion: TRMRichEditVersion;

implementation

uses RM_Parser, RM_Utils, RM_Const, RM_Const1, RM_Printer, RM_Common;

const
  RulerAdj = 4 / 3;
  GutterWid = 6;

{$R *.DFM}

procedure RMInitFormat(var Format: TCharFormat2);
begin
  FillChar(Format, SizeOf(Format), 0);
  if RichEditVersion >= 2 then
    Format.cbSize := SizeOf(Format)
  else
    Format.cbSize := SizeOf(TCharFormat);
end;

function RMGetSubscriptStyle(ARichEdit: TCustomRichEdit): TRMSubscriptStyle;
var
  Format: TCharFormat2;

  procedure _GetAttributes;
  begin
    RMInitFormat(Format);
    if ARichEdit.HandleAllocated then
      SendMessage(ARichEdit.Handle, EM_GETCHARFORMAT, SCF_SELECTION, LPARAM(@Format));
  end;

begin
  Result := rmssNone;
  if RichEditVersion < 2 then
    Exit;
  _GetAttributes;
  with Format do
  begin
    if (dwEffects and CFE_SUBSCRIPT) <> 0 then
      Result := rmssSubscript
    else if (dwEffects and CFE_SUPERSCRIPT) <> 0 then
      Result := rmssSuperscript;
  end;
end;

procedure RMSetSubscriptStyle(ARichEdit: TCustomRichEdit; AStyle: TRMSubscriptStyle);
var
  Format: TCharFormat2;
begin
  if RichEditVersion < 2 then
    Exit;
  RMInitFormat(Format);
  with Format do
  begin
    dwMask := DWORD(CFM_SUBSCRIPT);
    case AStyle of
      rmssSubscript: dwEffects := CFE_SUBSCRIPT;
      rmssSuperscript: dwEffects := CFE_SUPERSCRIPT;
    end;
  end;

  if ARichEdit.HandleAllocated then
    SendMessage(ARichEdit.Handle, EM_SETCHARFORMAT, SCF_SELECTION, LPARAM(@Format));
end;

procedure RMAssignRich(Rich1, Rich2: TRMRichEdit);
var
  st: TMemoryStream;
begin
  st := TMemoryStream.Create;
  try
    with Rich2 do
    begin
      SelStart := 0;
      SelLength := Length(Text);
      SelAttributes.Protected := FALSE;
      Lines.SaveToStream(st);
    end;
    st.Position := 0;
    Rich1.Lines.LoadFromStream(st);
  finally
    st.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMRichView}

constructor TRMRichView.Create;
begin
  inherited Create;
  BaseName := 'Rich';

  FRichEdit := TRMRichEdit.Create(RMDialogForm);
  with FRichEdit do
  begin
    Parent := RMDialogForm;
    Visible := False;
    Font.Charset := StrToInt(RMLoadStr(SCharset));
    Font.Name := RMLoadStr(SRMDefaultFontName);
    Font.Size := 11;
  end;
  FSRichEdit := nil;
  FUseSRichEdit := False;
end;

destructor TRMRichView.Destroy;
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

function TRMRichView.SRichEdit: TRMRichEdit;
begin
  if FSRichEdit = nil then
  begin
    FSRichEdit := TRMRichEdit.Create(RMDialogForm);
    with FSRichEdit do
    begin
      Parent := RMDialogForm;
      Visible := False;
    end;
  end;
  Result := FSRichEdit;
end;

procedure TRMRichView.GetRichData(aSource: TRMRichEdit);
{$IFDEF TntUnicode}
var
  lParName, S: string;
  i, j: Integer;

  function _GetBrackedVariable(const s: WideString; var i, j: Integer): string;
  var
    c: Integer;
    fl1, fl2: Boolean;
  begin
    j := i; fl1 := True; fl2 := True; c := 0;
    Result := '';
    if (s = '') or (j > Length(s)) then
      Exit;

    Dec(j);
    repeat
      Inc(j);
      if fl1 and fl2 then
      begin
        if s[j] = '[' then
        begin
          if c = 0 then
            i := j;
          Inc(c);
        end
        else if s[j] = ']' then
          Dec(c);
      end;

      if fl1 then
      begin
        if s[j] = '"' then
          fl2 := not fl2;
      end;

      if fl2 then
      begin
        if s[j] = '''' then
          fl1 := not fl1;
      end;
    until (c = 0) or (j >= Length(s));

    Result := Copy(s, i + 1, j - i - 1);
  end;

begin
  if ParentReport.Flag_TableEmpty then
  begin
    aSource.Lines.Text := '';
    Exit;
  end;

  with aSource do
  begin
    try
      Lines.BeginUpdate;
      i := FindText('[', 0, Length(Text), []) + 1;
      while i > 0 do
      begin
        SelStart := i - 1;
        if Win32PlatformIsUnicode then
          lParName := _GetBrackedVariable(Text, i, j)
        else
          lParName := RMGetBrackedVariable(Text, i, j);

        InternalOnGetValue(Self, lParName, S, True);
        SelLength := j - i + 1;
        SelText := UTF8Decode(S);
        Inc(i, Length(S) - 1);
        i := FindText('[', i, Length(Text) - i, []) + 1;
      end;
    finally
      Lines.EndUpdate;
    end;
  end;
end;
{$ELSE}
var
  lParName, S: string;
  i, j: Integer;
begin
  if ParentReport.Flag_TableEmpty then
  begin
    aSource.Lines.Text := '';
    Exit;
  end;

  with aSource do
  begin
    try
      Lines.BeginUpdate;
      i := FindText('[', 0, Length(Text), []) + 1;
      while i > 0 do
      begin
        SelStart := i - 1;
        lParName := RMGetBrackedVariable(Text, i, j);
        InternalOnGetValue(Self, lParName, S, False);
        SelLength := j - i + 1;
        SelText := S;
        Inc(i, Length(S) - 1);
        i := FindText('[', i, Length(Text) - i, []) + 1;
      end;
    finally
      Lines.EndUpdate;
    end;
  end;
end;
{$ENDIF}

function TRMRichView.DoCalcHeight: Integer;
var
  liFormatRange: TFormatRange;
  liLastChar, liMaxLen: Integer;
{$IFNDEF TntUnicode}
  liNewDY, liLowDy, liHighDy: Integer;
  liFit: Boolean;
{$ENDIF}
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

{$IFDEF TntUnicode}
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
{$ELSE}
    liLowDy := 0;
    liHighDY := 1000000;
    while liHighDy - liLowDy > liTolerance do
    begin
      liNewDY := liLowDy + (liHighDy - liLowDy) div 2;
      liFormatRange.rc := Rect(0, 0, liPrinterWidth, Round(liNewDY * 1440.0 / liPixelsPerInchY));
      liFormatRange.rcPage := liFormatRange.rc;
      liLastChar := FStartCharPos;
      liMaxLen := SRichEdit.GetTextLen;
      liFormatRange.chrg.cpMax := -1;
      repeat
        liFormatRange.chrg.cpMin := liLastChar;
        liLastChar := SRichEdit.Perform(EM_FORMATRANGE, 0, Integer(@liFormatRange));
        liFit := (liLastChar >= liMaxLen) or (liLastChar = -1) or (liLastChar = 0);
      until ((liLastChar < liMaxLen) and (liLastChar <> -1)) or liFit;

      if liFit then
        liHighDy := liNewDY
      else
        liLowDy := liNewDY;
    end;

    SRichEdit.Perform(EM_FORMATRANGE, 0, 0);
    liHighDy := liHighDy + lTextMetric.tmDescent;
    if liHighDy < liTolerance then
      liHighDy := liTolerance;

    Result := Round(RMToMMThousandths_Printer(liHighDy, rmrtVertical, liPrinter) + 0.5);
{$ENDIF}
  finally
    if (liPrinter = nil) or (liPrinter.DC = 0) then
      ReleaseDC(liDC, 0);
  end;
end;

{$WARNINGS OFF}

function TRMRichView.FormatRange(aDC: HDC; aFormatDC: HDC; const aRect: TRect;
  aCharRange: TCharRange; aRender: Boolean): Integer;
var
  liFormatRange: TFormatRange;
  liSaveMapMode: Integer;
  liPixelsPerInchX: Integer;
  liPixelsPerInchY: Integer;
  liRender: Integer;
  liRichEdit: TRMRichEdit;
begin
  if aRender then liRichEdit := FRichEdit else liRichEdit := SRichEdit;

  FillChar(liFormatRange, SizeOf(TFormatRange), 0);
  liFormatRange.hdc := aDC;
  liFormatRange.hdcTarget := aFormatDC;

  liPixelsPerInchX := GetDeviceCaps(aDC, LOGPIXELSX);
  liPixelsPerInchY := GetDeviceCaps(aDC, LOGPIXELSY);

  liFormatRange.rc.left := Round(aRect.Left * 1440.0 / liPixelsPerInchX) + 45;
  liFormatRange.rc.right := Round(aRect.Right * 1440.0 / liPixelsPerInchX);
  liFormatRange.rc.top := Round(aRect.Top * 1440.0 / liPixelsPerInchY);
  liFormatRange.rc.bottom := Round(aRect.Bottom * 1440.0 / liPixelsPerInchY);
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

procedure TRMRichView.ShowRichText(aRender: Boolean);
var
  lCharRange: TCharRange;

  procedure _ShowRichOnPrinter;
  begin
    FormatRange(Canvas.Handle, Canvas.Handle, RealRect, lCharRange, True);
  end;

  procedure _ShowRichOnScreen;
  var
    lMetaFile: TMetaFile;
    lMetaFileCanvas: TMetaFileCanvas;
    lDC: HDC;
    lPrinter: TRMPrinter;
    lBitmap: TBitmap;
    lCanvasRect: TRect;
    lWidth, lHeight: Integer;
  begin
    lPrinter := GetPrinter;
    if lPrinter.DC <> 0 then
    begin
      lDC := lPrinter.DC;
      FPixelsPerInch := lPrinter.PixelsPerInch;
    end
    else
    begin
      lDC := GetDC(0);
      FPixelsPerInch.X := 96;
      FPixelsPerInch.Y := 96;
    end;

    lMetaFile := TMetaFile.Create;
    try
      if aRender then
      begin
        lWidth := mmSaveWidth - mmSaveGapX * 2 - _CalcHFrameWidth(mmSaveFWLeft, mmSaveFWRight);
        lHeight := mmSaveHeight - mmSaveGapY * 2 - _CalcVFrameWidth(mmSaveFWTop, mmSaveFWBottom);
      end
      else
      begin
        lWidth := mmWidth - mmGapLeft * 2 - _CalcHFrameWidth(LeftFrame.mmWidth, RightFrame.mmWidth);
        lHeight := mmHeight - mmGapTop * 2 - _CalcVFrameWidth(TopFrame.mmWidth, BottomFrame.mmWidth);
      end;

      lCanvasRect := Rect(0, 0,
        Round(RMFromMMThousandths_Printer(lWidth, rmrtHorizontal, lPrinter)) + 1,
        Round(RMFromMMThousandths_Printer(lHeight, rmrtVertical, lPrinter)));
      lMetaFile.Width := lCanvasRect.Right - lCanvasRect.Left;
      lMetaFile.Height := lCanvasRect.Bottom - lCanvasRect.Top;

      lMetaFileCanvas := TMetaFileCanvas.Create(lMetaFile, lDC);
      lMetaFileCanvas.Brush.Style := bsClear;

      FEndCharPos := FormatRange(lMetaFileCanvas.Handle, lDC, lCanvasRect, lCharRange, aRender);

      lMetaFileCanvas.Free;
      if lPrinter.DC = 0 then
        ReleaseDC(0, lDC);

      if aRender then
      begin
        if DocMode = rmdmDesigning then
        begin
          lBitmap := TBitmap.Create;
          lBitmap.Width := RealRect.Right - RealRect.Left + 1;
          lBitmap.Height := RealRect.Bottom - RealRect.Top + 1;
          lBitmap.Canvas.StretchDraw(Rect(0, 0, lBitmap.Width, lBitmap.Height), lMetaFile);
          Canvas.Draw(RealRect.Left, RealRect.Top, lBitmap);
          lBitmap.Free;
        end
        else
          Canvas.StretchDraw(RealRect, lMetaFile);
      end;
    finally
      lMetaFile.Free;
    end;
  end;

begin
  FEndCharPos := FStartCharPos;
  lCharRange.cpMax := -1;
  lCharRange.cpMin := FEndCharPos;
  if (DocMode = rmdmPrinting) and (GetPrinter.PixelsPerInch.X = FPixelsPerInch.X) and
     (GetPrinter.PixelsPerInch.Y = FPixelsPerInch.Y) then
    _ShowRichOnPrinter
  else
    _ShowRichOnScreen;
end;

{$WARNINGS ON}

procedure TRMRichView.Draw(aCanvas: TCanvas);
begin
  BeginDraw(aCanvas);
  CalcGaps;
  with aCanvas do
  begin
    ShowBackground;
    InflateRect(RealRect, -RMToScreenPixels(mmGapLeft, rmutMMThousandths),
      -RMToScreenPixels(mmGapTop, rmutMMThousandths));
    if (spWidth > 0) and (spHeight > 0) then
      ShowRichText(True);
    ShowFrame;
  end;
  RestoreCoord;
end;

procedure TRMRichView.Prepare;
begin
  inherited Prepare;
  FStartCharPos := 0;
end;

procedure TRMRichView.GetMemoVariables;
begin
  if DrawMode = rmdmAll then
  begin
    Memo1.Assign(Memo);
    if Assigned(OnBeforePrint) then
      OnBeforePrint(Self);
    InternalOnBeforePrint(Memo1, Self);
    RMAssignRich(SRichEdit, FRichEdit);
    if not TextOnly then
      GetRichData(SRichEdit);
  end;
end;

procedure TRMRichView.PlaceOnEndPage(aStream: TStream);
var
  liTextLen: Integer;
begin
  BeginDraw(Canvas);
  if not Visible then Exit;

  GetMemoVariables;
  if DrawMode = rmdmPart then
  begin
    FStartCharPos := FEndCharPos;
    ShowRichText(False);
    liTextLen := SRichEdit.GetTextLen - FEndCharPos + 1;
    if liTextLen > 0 then
    begin
      SRichEdit.SelStart := FEndCharPos;
      SRichEdit.SelLength := liTextLen;
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

function TRMRichView.CalcHeight: Integer;
begin
  FEndCharPos := 0;
  FSaveCharPos := 0;
  CalculatedHeight := 0; Result := 0;
  if not Visible then Exit;

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

function TRMRichView.RemainHeight: Integer;
begin
  DrawMode := rmdmAll;
  GetMemoVariables;
//  DrawMode := rmdmAfterCalcHeight;

  FStartCharPos := FEndCharPos;
  ActualHeight := RMToMMThousandths(spGapTop * 2 + _CalcVFrameWidth(TopFrame.spWidth, BottomFrame.spWidth), rmutScreenPixels) +
    DoCalcHeight;
  Result := ActualHeight;
end;

procedure TRMRichView.LoadFromStream(aStream: TStream);
var
  b: Byte;
  liSavePos: Integer;
  lVersion: Integer;
begin
  inherited LoadFromStream(aStream);
  lVersion := RMReadWord(aStream);
  b := RMReadByte(aStream);
  liSavePos := RMReadInt32(aStream);
  if b > 0 then
    FRichEdit.Lines.LoadFromStream(aStream);
  aStream.Seek(liSavePos, soFromBeginning);
  if lVersion >= 1 then
  begin
    FPixelsPerInch.X := RMReadInt32(aStream);
    FPixelsPerInch.Y := RMReadInt32(aStream);
  end;
end;

procedure TRMRichView.SaveToStream(aStream: TStream);
var
  b: Byte;
  lSavePos, lPos: Integer;
  lRichEdit: TRMRichEdit;
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 1);
  if FUseSRichEdit then
    lRichEdit := SRichEdit
  else
    lRichEdit := FRichEdit;

  if lRichEdit.Lines.Count <> 0 then b := 1 else b := 0;
  RMWriteByte(aStream, b);

  lSavePos := aStream.Position;
  RMWriteInt32(aStream, lSavePos);
  if b > 0 then
    lRichEdit.Lines.SaveToStream(aStream);

  lPos := aStream.Position;
  aStream.Seek(lSavePos, soFromBeginning);
  RMWriteInt32(aStream, lPos);
  aStream.Seek(lPos, soFromBeginning);

  RMWriteInt32(aStream, FPixelsPerInch.X);
  RMWriteInt32(aStream, FPixelsPerInch.Y);
end;

procedure TRMRichView.GetBlob;
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

procedure TRMRichView.ShowEditor;
var
  tmpForm: TRMRichForm;
begin
  tmpForm := TRMRichForm.Create(Application);
  try
    RMAssignRich(tmpForm.Editor, FRichEdit);
    if tmpForm.ShowModal = mrOK then
    begin
      RMDesigner.BeforeChange;
      RMAssignRich(FRichEdit, tmpForm.Editor);
      RMDesigner.AfterChange;
    end;
  finally
    tmpForm.Free;
  end;
end;

procedure TRMRichView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
begin
  inherited DefinePopupMenu(aPopup);
end;

procedure TRMRichView.LoadFromRichEdit(aRichEdit: TRMRichEdit);
begin
  RMAssignRich(FRichEdit, aRichEdit);
end;

function TRMRichView.GetViewCommon: string;
begin
  Result := '[Rich]';
end;

procedure TRMRichView.ClearContents;
begin
  FRichEdit.Clear;
  inherited;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMRichForm}

procedure TRMRichForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

//  Caption := RMLoadStr(rmRes + 560);
  RMSetStrProp(btnFileOpen, 'Hint', rmRes + 561);
  RMSetStrProp(btnFileSave, 'Hint', rmRes + 562);
  RMSetStrProp(btnFilePrint, 'Hint', rmRes + 159);
  RMSetStrProp(btnUndo, 'Hint', rmRes + 563);
  RMSetStrProp(btnCut, 'Hint', rmRes + 91);
  RMSetStrProp(btnCopy, 'Hint', rmRes + 92);
  RMSetStrProp(btnPaste, 'Hint', rmRes + 93);
  RMSetStrProp(btnFontBold, 'Hint', rmRes + 564);
  RMSetStrProp(btnFontItalic, 'Hint', rmRes + 565);
  RMSetStrProp(btnFontUnderline, 'Hint', rmRes + 569);
  RMSetStrProp(btnAlignLeft, 'Hint', rmRes + 566);
  RMSetStrProp(btnAlignCenter, 'Hint', rmRes + 567);
  RMSetStrProp(btnAlignRight, 'Hint', rmRes + 568);
  RMSetStrProp(btnBullets, 'Hint', rmRes + 570);
  RMSetStrProp(btnFont, 'Hint', rmRes + 571);
  RMSetStrProp(btnInsertField, 'Hint', rmRes + 575);

  RMSetStrProp(FileMenu, 'Caption', rmRes + 154);
  RMSetStrProp(FileNewItem, 'Caption', rmRes + 155);
  RMSetStrProp(FileOpenItem, 'Caption', rmRes + 156);
  RMSetStrProp(FileSaveAsItem, 'Caption', rmRes + 188);
  RMSetStrProp(FileExitItem, 'Caption', rmRes + 162);
  RMSetStrProp(EditMenu, 'Caption', rmRes + 163);
  RMSetStrProp(EditUndoItem, 'Caption', rmRes + 164);
  RMSetStrProp(EditCutItem, 'Caption', rmRes + 166);
  RMSetStrProp(EditCopyItem, 'Caption', rmRes + 167);
  RMSetStrProp(EditPasteItem, 'Caption', rmRes + 168);
  RMSetStrProp(EditInsertFieldItem, 'Caption', rmRes + 575);
  RMSetStrProp(EditFontItem, 'Caption', rmRes + 576);
  RMSetStrProp(btnSuperscript, 'Hint', rmRes + 580);
  RMSetStrProp(btnSubscript, 'Hint', rmRes + 581);

  btnOK.Hint := RMLoadStr(rmRes + 573);
  btnCancel.Hint := RMLoadStr(rmRes + 574);
end;

procedure TRMRichForm.SelectionChange(Sender: TObject);
var
  lFont: TFont;
  lFontHeight: Integer;
begin
  with Editor.Paragraph do
  begin
    try
      FUpdating := True;
      FRuler.UpdateInd;
      btnFontBold.Down := fsBold in Editor.SelAttributes.Style;
      btnFontItalic.Down := fsItalic in Editor.SelAttributes.Style;
      btnFontUnderline.Down := fsUnderline in Editor.SelAttributes.Style;
      btnBullets.Down := Boolean(Numbering);
      BtnSuperscript.Down := RMGetSubscriptStyle(Editor) = rmssSuperscript;
      BtnSubscript.Down := RMGetSubscriptStyle(Editor) = rmssSubscript;

      lFont := TFont.Create;
      lFont.Size := Editor.SelAttributes.Size;
      lFontHeight := lFont.Height;
      lFont.Free;
      RMSetFontSize(TComboBox(FcmbFontSize), lFontHeight, Editor.SelAttributes.Size);

      FCmbFont.FontName := Editor.SelAttributes.Name;
      case Ord(Alignment) of
        0: btnAlignLeft.Down := True;
        1: btnAlignRight.Down := True;
        2: btnAlignCenter.Down := True;
      end;
      UpdateCaretPos;
    finally
      FUpdating := False;
    end;
  end;
end;

procedure TRMRichForm.UpdateCaretPos;
var
  CharPos: TPoint;
begin
  CharPos.Y := SendMessage(Editor.Handle, EM_EXLINEFROMCHAR, 0,
    Editor.SelStart);
  CharPos.X := (Editor.SelStart -
    SendMessage(Editor.Handle, EM_LINEINDEX, CharPos.Y, 0));
  Inc(CharPos.Y);
  Inc(CharPos.X);
  StatusBar.Panels[0].Text := Format(FStatusString, [CharPos.Y, CharPos.X]);

  btnCopy.Enabled := Editor.SelLength > 0;
  btnCut.Enabled := btnCopy.Enabled;
  EditCutItem.Enabled := btnCut.Enabled;
  EditCopyItem.Enabled := btnCopy.Enabled;
end;

function TRMRichForm.CurrText: TTextAttributes;
begin
  if Editor.SelLength > 0 then
    Result := Editor.SelAttributes
  else
    Result := Editor.DefAttributes;
end;

procedure TRMRichForm.SetEditRect;
var
  R: TRect;
begin
  with Editor do
  begin
    R := Rect(GutterWid, 0, ClientWidth - GutterWid, ClientHeight);
    SendMessage(Handle, EM_SETRECT, 0, Longint(@R));
  end;
end;

procedure TRMRichForm.SetFileName(const FileName: string);
begin
  FFileName := FileName;
end;

procedure TRMRichForm.SetModified(Value: Boolean);
begin
  if Value then
    StatusBar.Panels[1].Text := 'Modified'
  else
    StatusBar.Panels[1].Text := '';
end;

procedure TRMRichForm.FormResize(Sender: TObject);
begin
  SetEditRect;
  SelectionChange(Sender);
end;

procedure TRMRichForm.FormPaint(Sender: TObject);
begin
  SetEditRect;
end;

procedure TRMRichForm.FileOpen(Sender: TObject);
begin
  OpenDialog.Filter := RMLoadStr(SRTFFile) + '(*.rtf)|*.rtf' + '|' +
    RMLoadStr(STextFile) + '(*.txt)|*.txt';
  if OpenDialog.Execute then
  begin
    Editor.Lines.LoadFromFile(OpenDialog.FileName);
    Editor.SetFocus;
    SelectionChange(Self);
  end;
end;

procedure TRMRichForm.FileSaveAs(Sender: TObject);
begin
  SaveDialog.Filter := RMLoadStr(SRTFFile) + ' (*.rtf)|*.rtf|' +
    RMLoadStr(STextFile) + ' (*.txt)|*.txt';
  if SaveDialog.Execute then
    Editor.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TRMRichForm.EditUndo(Sender: TObject);
begin
  with Editor do
    if HandleAllocated then
      SendMessage(Handle, EM_UNDO, 0, 0);
end;

procedure TRMRichForm.SelectFont(Sender: TObject);
begin
  FontDialog1.Font.Assign(Editor.SelAttributes);
  if FontDialog1.Execute then
    CurrText.Assign(FontDialog1.Font);
  Editor.SetFocus;
end;

procedure TRMRichForm.btnOKClick(Sender: TObject);
begin
  OnResize := nil;
  ModalResult := mrOk;
end;

procedure TRMRichForm.btnCancelClick(Sender: TObject);
begin
  OnResize := nil;
  ModalResult := mrCancel;
end;

procedure TRMRichForm.FormActivate(Sender: TObject);
begin
  FUpdating := True;
  Editor.SetFocus;
  FUpdating := False;
end;

procedure TRMRichForm.FormCreate(Sender: TObject);
var
  i, liOffset: Integer;
begin
  Editor := TRMRichEdit.Create(Self);
  with Editor do
  begin
    Parent := Self;
    Align := alClient;
    ScrollBars := ssBoth;
    OnChange := EditorChange;
    OnSelectionChange := SelectionChange;
  end;

  Localize;
  FcmbFont := TRMFontComboBox.Create(ToolBar1);
  with FcmbFont do
  begin
    Parent := ToolBar1;
    Left := 0;
    Top := 0;
    Height := 21;
    Width := 150;
    Tag := 7;
//    Device := rmfdPrinter;
    OnChange := OnCmbFontChange;
  end;
  FcmbFontSize := TComboBox.Create(ToolBar1);
  with FcmbFontSize do
  begin
    Parent := ToolBar1;
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
  FBtnFontColor := TRMColorPickerButton.Create(ToolBar1);
  with FBtnFontColor do
  begin
    Parent := ToolBar1;
    Left := ToolButton4.Left + ToolButton4.Width;
    Top := 0;
    ColorType := rmptFont;
    OnColorChange := OnColorChangeEvent;
  end;

  FRuler := TRMRuler.Create(Self);
  with FRuler do
  begin
    Top := ToolBar1.Top + ToolBar1.Height;
    RichEdit := TCustomRichEdit(Editor);
    Align := alTop;
    Height := 26;
    OnIndChanged := SelectionChange;
  end;

  FStatusString := RMLoadStr(rmRes + 578) + ': %3d   ' + RMLoadStr(rmRes + 579) + ': %3d';
  OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
  SaveDialog.InitialDir := OpenDialog.InitialDir;
  SelectionChange(Self);
end;

procedure TRMRichForm.btnInsertFieldClick(Sender: TObject);
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

procedure TRMRichForm.btnCutClick(Sender: TObject);
begin
  Editor.CutToClipboard;
end;

procedure TRMRichForm.btnCopyClick(Sender: TObject);
begin
  Editor.CopyToClipboard;
end;

procedure TRMRichForm.btnPasteClick(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TRMRichForm.FileNewItemClick(Sender: TObject);
begin
  SetFileName('Untitled');
  Editor.Modified := True;
  SetModified(True);
end;

procedure TRMRichForm.btnFilePrintClick(Sender: TObject);
begin
  if PrintDialog.Execute then
    Editor.Print(FFileName);
end;

procedure TRMRichForm.EditorChange(Sender: TObject);
begin
  SetModified(Editor.Modified);
  btnUndo.Enabled := SendMessage(Editor.Handle, EM_CANUNDO, 0, 0) <> 0;
end;

procedure TRMRichForm.FormShow(Sender: TObject);
begin
  SelectionChange(Self);
  EditorChange(Self);
  SetModified(FALSE);
  Editor.SetFocus;
end;

procedure TRMRichForm.btnFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(Editor.SelAttributes);
  if FontDialog1.Execute then
    CurrText.Assign(FontDialog1.Font);
  Editor.SetFocus;
end;

procedure TRMRichForm.btnBulletsClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  Editor.Paragraph.Numbering := TNumberingStyle(btnBullets.Down);
end;

procedure TRMRichForm.btnAlignLeftClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  case TControl(Sender).Tag of
    312: Editor.Paragraph.Alignment := taLeftJustify;
    313: Editor.Paragraph.Alignment := taCenter;
    314: Editor.Paragraph.Alignment := taRightJustify;
  end;
end;

procedure TRMRichForm.btnFontBoldClick(Sender: TObject);
var
  s: TFontStyles;
begin
  if FUpdating then
    Exit;
  s := [];
  if btnFontBold.Down then
    s := s + [fsBold];
  if btnFontItalic.Down then
    s := s + [fsItalic];
  if btnFontUnderline.Down then
    s := s + [fsUnderline];
  CurrText.Style := s;
end;

procedure TRMRichForm.OnCmbFontChange(Sender: TObject);
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

procedure TRMRichForm.OnCmbFontSizeChange(Sender: TObject);
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

procedure TRMRichForm.OnColorChangeEvent(Sender: TObject);
begin
  CurrText.Color := FBtnFontColor.CurrentColor;
end;

procedure TRMRichForm.FormDestroy(Sender: TObject);
begin
  FRuler.Free;
end;

procedure TRMRichForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OnResize := nil;
end;

procedure TRMRichForm.btnSuperscriptClick(Sender: TObject);
begin
  if FUpdating then
    Exit;
  if btnSuperscript.Down then
    RMSetSubscriptStyle(Editor, rmssSuperscript)
  else if btnSubscript.Down then
    RMSetSubscriptStyle(Editor, rmssSubscript)
  else
    RMSetSubscriptStyle(Editor, rmssNone);
end;


{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure TRMRichView_LoadFromRichEdit(var Value: Variant; Args: TJvInterpreterArgs);
begin
  TRMRichView(Args.Obj).LoadFromRichEdit(TRMRichEdit(V2O(Args.Values[0])));
end;

const
	cRM = 'RM_RichEdit';

procedure RM_RegisterRAI2Adapter(RAI2Adapter: TJvInterpreterAdapter);
begin
  with RAI2Adapter do
  begin
    AddClass(cRM, TRMRichView, 'TRMRichView');
    AddClass(cRM, TRMRichEdit, 'TRMRichEdit');

    AddGet(TRMRichView, 'LoadFromRichEdit', TRMRichView_LoadFromRichEdit, 1, [0], varEmpty);
  end;
end;

{$IFDEF USE_RICHEDIT_VER_20}
var
  OldError: Longint;
  FLibHandle: THandle;
  Ver: TOsVersionInfo;
{$ENDIF}

initialization
  RMRegisterObjectByRes(TRMRichView, 'RM_RichObject', RMLoadStr(SInsRichObject), TRMRichForm);
//  RMRegisterControl('ReportPage Additional', 'RM_OtherComponent', False,
//    TRMRichView, 'RM_RichObject', RMLoadStr(SInsRichObject));
  RM_RegisterRAI2Adapter(GlobalJvInterpreterAdapter);

  RichEditVersion := 1;
{$IFDEF USE_RICHEDIT_VER_20}
  OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
  try
    FLibHandle := LoadLibrary('RICHED20.DLL');
    if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then
      FLibHandle := 0;
    if FLibHandle = 0 then
    begin
      FLibHandle := LoadLibrary('RICHED32.DLL');
      if (FLibHandle > 0) and (FLibHandle < HINSTANCE_ERROR) then
        FLibHandle := 0;
    end
    else
    begin
      RichEditVersion := 2;
      Ver.dwOSVersionInfoSize := SizeOf(Ver);
      GetVersionEx(Ver);
      with Ver do
      begin
        if (dwPlatformId = VER_PLATFORM_WIN32_NT) and
          (dwMajorVersion >= 5) then
          RichEditVersion := 3;
      end;
    end;
  finally
    SetErrorMode(OldError);
  end;
{$ENDIF}

finalization
{$IFDEF USE_RICHEDIT_VER_20}
  if FLibHandle <> 0 then
    FreeLibrary(FLibHandle);
{$ENDIF}

end.

