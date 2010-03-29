
{*****************************************}
{                                         }
{           Report Machine v2.0           }
{            Various routines             }
{                                         }
{*****************************************}

unit RM_utils;

interface

{$I RM.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls,
  Menus, RM_Class, RM_Dataset
  {$IFDEF Delphi4}, SysConst{$ENDIF}
  {$IFDEF Delphi6}, Variants{$ENDIF};

const
  RMBreakChars: set of Char = [' ', #13, '-'];
  RMChineseBreakChars: array[0..41] of string = (
    '。', '，', '、', '；', '：', '？', '！', '…', '—', '·', 'ˉ', '‘', '’',
    '“', '”', '～', '∶', '＂', '＇', '｀', '｜', '〔', '〕', '〈', '〉', '《',
    '》', '「', '」', '『', '』', '．', '〖', '〗', '【', '】', '（', '）', '［',
    '］', '｛', '｝');

  {$IFNDEF DELPHI4}
type
  TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase);

function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;
function Min(A, B: Single): Single;
function Max(A, B: Double): Double;
{$ENDIF}

{$IFNDEF Delphi6}
type
  UTF8String = type string;
  PUTF8String = ^UTF8String;
  {$ENDIF}

type
  TRMDeviceCompatibleCanvas = class(TCanvas)
  private
    FReferenceDC: HDC;
    FCompatibleDC: HDC;
    FCompatibleBitmap: HBitmap;
    FOldBitmap: HBitmap;
    FWidth: Integer;
    FHeight: Integer;
    FSavePalette: HPalette;
    FRestorePalette: Boolean;
  protected
    procedure CreateHandle; override;
    procedure Changing; override;
    procedure UpdateFont;
  public
    constructor Create(aReferenceDC: HDC; aWidth, aHeight: Integer; aPalette: HPalette);
    destructor Destroy; override;

    procedure RenderToDevice(aDestRect: TRect; aPalette: HPalette; aCopyMode: TCopyMode);
    property Height: Integer read FHeight;
    property Width: Integer read FWidth;
  end;

procedure RMReadMemo(aStream: TStream; aStrings: TStrings);
procedure RMWriteMemo(aStream: TStream; aStrings: TStrings);
function RMReadString(aStream: TStream): string;
procedure RMWriteString(aStream: TStream; const s: string);
function RMReadBoolean(aStream: TStream): Boolean;
procedure RMWriteBoolean(aStream: TStream; Value: Boolean);
function RMReadByte(aStream: TStream): Byte;
procedure RMWriteByte(aStream: TStream; Value: Byte);
function RMReadWord(aStream: TStream): Word;
procedure RMWriteWord(aStream: TStream; Value: Word);
function RMReadInt32(aStream: TStream): Integer;
procedure RMWriteInt32(aStream: TStream; Value: Integer);
function RMReadLongWord(aStream: TStream): LongWord;
procedure RMWriteLongWord(aStream: TStream; Value: LongWord);
function RMReadFloat(aStream: TStream): Single;
procedure RMWriteFloat(aStream: TStream; Value: Single);
procedure RMReadFont(aStream: TStream; Font: TFont);
procedure RMWriteFont(aStream: TStream; Font: TFont);

function RMFindComponent(aOwner: TComponent; const aComponentName: string): TComponent;
procedure RMGetComponents(aOwner: TComponent; aClassRef: TClass; aList: TStrings; aSkip: TComponent);
procedure RMEnableControls(c: array of TControl; e: Boolean);
function RMGetFontStyle(Style: TFontStyles): Integer;
function RMSetFontStyle(Style: Integer): TFontStyles;
function RMStrToFloat(s: string): Double;
function RMRemoveQuotes(const s: string): string;
procedure RMSetCommaText(Text: string; sl: TStringList);

function RMCanvasWidth(const aStr: string; aFont: TFont): integer;
function RMCanvasHeight(const aStr: string; aFont: TFont): integer;
function RMGetBrackedVariable(const aStr: string; var aBeginPos, aEndPos: Integer): string;
function RMWrapStrings(const SrcLines: TStrings; DstLines: TStrings; aCanvas: TCanvas;
  aWidth: integer; const aOneLineHeight: integer; aWordBreak, aMangeTag, aWidthFlag: Boolean): integer;

function RMNumToBig(Value: Integer): string;
function RMCurrToBIGNum(Value: Currency): string;
function RMChineseNumber(const jnum: string): string;
function RMSmallToBig(curs: string): string;
procedure RMSetFontSize(aComboBox: TComboBox; aFontHeight, aFontSize: integer);
procedure RMSetFontSize1(aListBox: TListBox; aFontSize: integer);
function RMGetFontSize(aComboBox: TComboBox): integer;
function RMGetFontSize1(aIndex: Integer; aText: string): integer;
function RMCreateBitmap(const ResName: string): TBitmap;
function RMLoadStr(aResID: Integer): string;
procedure RMSetStrProp(aObject: TObject; const aPropName: string; ID: Integer);
function RMGetPropValue(aReport: TRMReport; const aObjectName, aPropName: string): Variant;
function RMRound(x: Extended; dicNum: Integer): Extended; //四舍五入

function RMMakeFileName(AFileName, AFileExtension: string; ANumber: Integer): string;
function RMAppendTrailingBackslash(const S: string): string;
function RMColorBGRToRGB(AColor: TColor): string;
function RMMakeImgFileName(AFileName, AFileExtension: string; ANumber: Integer): string;
procedure RMSetControlsEnable(AControl: TWinControl; AState: Boolean);
procedure RMSaveFormPosition(aParentKey: string; aForm: TForm);
procedure RMRestoreFormPosition(aParentKey: string; aForm: TForm);
procedure RMGetBitmapPixels(aGraphic: TGraphic; var x, y: Integer);
function RMGetWindowsVersion: string;

function RMMonth_EnglishShort(aMonth: Integer): string;
function RMMonth_EnglishLong(aMonth: Integer): string;
function RMSinglNumToBig(Value: Extended; Digit: Integer): string;

function RMStream2TXT(aStream: TStream): AnsiString;
function RMTXT2Stream(inStr: AnsiString; OutStream: TStream): Boolean;

function RMisNumeric(St: string): Boolean;
function RMStrGetToken(s: string; delimeter: string; var APos: integer): string;
function RMCmp(const S1, S2: string): Boolean;
function RMExtractField(const aStr: string; aFieldNo: Integer): string;
procedure RMSetNullValue(var aValue1, aValue2: Variant);

procedure RMPrintGraphic(aCanvas: TCanvas; aDestRect: TRect; aGraphic: TGraphic;
  aIsPrinting: Boolean; aDirectDraw: Boolean; aTransparent: Boolean);
function RMDeleteNoNumberChar(s: string): string;

implementation

uses
  TypInfo, Registry, RM_Common, RM_Const, RM_Const1;

type
  THackReport = class(TRMReport)
  end;

  {$IFNDEF DELPHI4}

function Min(A, B: Single): Single;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function Max(A, B: Double): Double;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := AnsiPos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;
{$ENDIF}

function RMSetFontStyle(Style: Integer): TFontStyles;
begin
  Result := [];
  if (Style and $1) <> 0 then
    Result := Result + [fsItalic];
  if (Style and $2) <> 0 then
    Result := Result + [fsBold];
  if (Style and $4) <> 0 then
    Result := Result + [fsUnderLine];
  if (Style and $8) <> 0 then
    Result := Result + [fsStrikeOut];
end;

function RMGetFontStyle(Style: TFontStyles): Integer;
begin
  Result := 0;
  if fsItalic in Style then
    Result := Result or $1;
  if fsBold in Style then
    Result := Result or $2;
  if fsUnderline in Style then
    Result := Result or $4;
  if fsStrikeOut in Style then
    Result := Result or $8;
end;

procedure RMReadMemo40(aStream: TStream; aStrings: TStrings);
var
  lStr: string;
  i, lCount: Integer;
begin
  aStrings.Clear;
  aStream.Read(lCount, 4);
  for i := 0 to lCount - 1 do
  begin
    aStream.Read(lCount, 4);
    SetLength(lStr, lCount);
    if lCount > 0 then
    begin
      aStream.Read(lStr[1], lCount);
      aStrings.Add(lStr);
    end;
  end;
end;

procedure RMWriteMemo40(aStream: TStream; aStrings: TStrings);
var
  lStr: string;
  i: Integer;
  lCount: Integer;
begin
  lCount := aStrings.Count;
  aStream.Write(lCount, 4);
  for i := 0 to aStrings.Count - 1 do
  begin
    lStr := aStrings[i];
    lCount := Length(lStr);
    aStream.Write(lCount, 4);
    if lCount > 0 then
      aStream.Write(lStr[1], lCount);
  end;
end;

procedure RMReadMemo(aStream: TStream; aStrings: TStrings);
var
  lStr: string;
  lStrLen: Integer;
begin
  aStrings.Clear;
  lStrLen := RMReadInt32(aStream);
  if lStrLen > 0 then
  begin
    SetString(lStr, PChar(nil), lStrLen);
    aStream.Read(Pointer(lStr)^, lStrLen);
    aStrings.Text := lStr;
  end;
end;

procedure RMWriteMemo(aStream: TStream; aStrings: TStrings);
var
  lStr: string;
  lStrLen: Integer;
begin
  lStr := aStrings.Text;
  lStrLen := Length(lStr);
  RMWriteInt32(aStream, lStrLen);
  if lStrLen > 0 then
    aStream.WriteBuffer(Pointer(lStr)^, lStrLen);
end;

function RMReadString(aStream: TStream): string;
var
  s: string;
  n: Word;
begin
  aStream.Read(n, 2);
  SetLength(s, n);
  aStream.Read(s[1], n);
  Result := s;
end;

procedure RMWriteString(aStream: TStream; const s: string);
var
  n: Word;
begin
  n := Length(s);
  aStream.Write(n, 2);
  aStream.Write(s[1], n);
end;

function RMReadBoolean(aStream: TStream): Boolean;
begin
  aStream.Read(Result, 1);
end;

procedure RMWriteBoolean(aStream: TStream; Value: Boolean);
begin
  aStream.Write(Value, 1);
end;

function RMReadByte(aStream: TStream): Byte;
begin
  aStream.Read(Result, 1);
end;

procedure RMWriteByte(aStream: TStream; Value: Byte);
begin
  aStream.Write(Value, 1);
end;

function RMReadWord(aStream: TStream): Word;
begin
  aStream.Read(Result, 2);
end;

procedure RMWriteWord(aStream: TStream; Value: Word);
begin
  aStream.Write(Value, 2);
end;

function RMReadInt32(aStream: TStream): Integer;
begin
  aStream.Read(Result, 4);
end;

procedure RMWriteInt32(aStream: TStream; Value: Integer);
begin
  aStream.Write(Value, 4);
end;

function RMReadLongWord(aStream: TStream): LongWord;
begin
  aStream.Read(Result, 4);
end;

procedure RMWriteLongWord(aStream: TStream; Value: LongWord);
begin
  aStream.Write(Value, 4);
end;

function RMReadFloat(aStream: TStream): Single;
begin
  aStream.Read(Result, SizeOf(Result));
end;

procedure RMWriteFloat(aStream: TStream; Value: Single);
begin
  aStream.Write(Value, SizeOf(Value));
end;

{$HINTS OFF}

procedure RMReadFont(aStream: TStream; Font: TFont);
var
  lSize: Integer;

  function _SetFontStyle(Style: Integer): TFontStyles;
  begin
    Result := [];
    if (Style and $1) <> 0 then
      Result := Result + [fsItalic];
    if (Style and $2) <> 0 then
      Result := Result + [fsBold];
    if (Style and $4) <> 0 then
      Result := Result + [fsUnderLine];
    if (Style and $8) <> 0 then
      Result := Result + [fsStrikeOut];
  end;

begin
  Font.Name := RMReadString(aStream);
  lSize := RMReadInt32(aStream);
  if lSize >= 0 then
    Font.Size := lSize
  else
    Font.Height := lSize;

  Font.Style := _SetFontStyle(RMReadWord(aStream));
  Font.Color := RMReadInt32(aStream);
  Font.Charset := RMReadWord(aStream);
end;

procedure RMWriteFont(aStream: TStream; Font: TFont);

  function _GetFontStyle(Style: TFontStyles): Integer;
  begin
    Result := 0;
    if fsItalic in Style then
      Result := Result or $1;
    if fsBold in Style then
      Result := Result or $2;
    if fsUnderline in Style then
      Result := Result or $4;
    if fsStrikeOut in Style then
      Result := Result or $8;
  end;

begin
  RMWriteString(aStream, Font.Name);
  RMWriteInt32(aStream, Font.Height {Size});
  RMWriteWord(aStream, _GetFontStyle(Font.Style));
  RMWriteInt32(aStream, Font.Color);
  RMWriteWord(aStream, Font.Charset);
end;
{$HINTS ON}

function RMLoadStr(aResID: Integer): string;
begin
  Result := RMResourceManager.LoadStr(aResID);
end;

type
  THackWinControl = class(TWinControl)
  end;

procedure RMEnableControls(c: array of TControl; e: Boolean);
const
  Clr1: array[Boolean] of TColor = (clGrayText, clWindowText);
  Clr2: array[Boolean] of TColor = (clBtnFace, clWindow);
var
  i: Integer;
begin
  for i := Low(c) to High(c) do
  begin
    if c[i] is TLabel then
    begin
      with TLabel(c[i]) do
      begin
        Font.Color := Clr1[e];
        Enabled := e;
      end;
    end
    else if c[i] is TWinControl then
    begin
      with THackWinControl(c[i]) do
      begin
        Color := Clr2[e];
        Enabled := e;
      end;
    end
    else
      c[i].Enabled := e;
  end;
end;

function RMFindComponent(aOwner: TComponent; const aComponentName: string): TComponent;
var
  n: Integer;
  s1, s2: string;
begin
  Result := nil;
  if aComponentName = '' then Exit;

  n := Pos('.', aComponentName);
  try
    if n = 0 then
    begin
      if aOwner <> nil then
        Result := aOwner.FindComponent(aComponentName);
    end
    else
    begin
      s1 := Copy(aComponentName, 1, n - 1); // module name
      s2 := Copy(aComponentName, n + 1, 99999); // component name
      Result := RMFindComponent(FindGlobalComponent(s1), s2);
    end;
  except
    on Exception do
      raise EClassNotFound.Create('Missing ' + aComponentName);
  end;
end;

// --> Leon, 2004-10-10, 增加

function RMClassIsOk(aComponent: TComponent; aClassRef: TClass): boolean;
var
  lClass: TClass;
begin
  Result := aComponent is aClassRef;
  if not Result then
  begin
    lClass := aComponent.ClassType;
    while lClass <> nil do
    begin
      if lClass.ClassName = aClassRef.ClassName then
      begin
        Result := True;
        Break;
      end;

      lClass := lClass.ClassParent;
    end;
  end;
end;

{$HINTS OFF}

procedure RMGetComponents(aOwner: TComponent; aClassRef: TClass; aList: TStrings;
  aSkip: TComponent);
var
  i: Integer;
  {$IFDEF Delphi6}
  j: Integer;
  {$ENDIF}

  procedure _EnumComponents(aComponent: TComponent);
  var
    i: Integer;
    lComponent: TComponent;
  begin
    {$IFDEF Delphi5}
    if aComponent is TForm then
    begin
      for i := 0 to TForm(aComponent).ControlCount - 1 do
      begin
        lComponent := TForm(aComponent).Controls[i];
        if lComponent is TFrame then
          _EnumComponents(lComponent);
      end;
    end;
    {$ENDIF}

    for i := 0 to aComponent.ComponentCount - 1 do
    begin
      lComponent := aComponent.Components[i];
      if (lComponent.Name <> '') and (lComponent <> aSkip) and
        RMClassIsOk(lComponent, aClassRef) {(lComponent is aClassRef)} then
      begin
        if aComponent = aOwner then
          aList.Add(lComponent.Name)
        else if ((aComponent is TForm) or (aComponent is TDataModule)) then
          aList.Add(aComponent.Name + '.' + lComponent.Name)
        else
          aList.Add(TControl(aComponent).Parent.Name + '.' + aComponent.Name + '.' + lComponent.Name)
      end;
    end;
  end;

begin
  aList.Clear;
  for i := 0 to Screen.CustomFormCount - 1 do
  begin
    if (Screen.CustomForms[i].Name <> 'RMDesignerForm') and
      (Screen.CustomForms[i].Name <> 'RMGridReportDesignerForm') then
      _EnumComponents(Screen.CustomForms[i]);
  end;
  for i := 0 to Screen.DataModuleCount - 1 do
    _EnumComponents(Screen.DataModules[i]);

  {$IFDEF Delphi6}
  with Screen do
  begin
    for i := 0 to CustomFormCount - 1 do
    begin
      with CustomForms[i] do
      begin
        if (ClassName = 'TDataModuleForm') then
        begin
          for j := 0 to ComponentCount - 1 do
          begin
            if (Components[j] is TDataModule) then
              _EnumComponents(Components[j]);
          end;
        end;
      end;
    end;
  end;
  {$ENDIF}
end;
{$HINTS ON}

function RMStrToFloat(s: string): Double;
var
  i: Integer;
begin
  for i := 1 to Length(s) do
  begin
    if s[i] in [',', '.'] then
      s[i] := DecimalSeparator;
  end;
  Result := StrToFloat(Trim(s));
end;

function RMRemoveQuotes(const s: string): string;
begin
  if (Length(s) > 2) and (s[1] = '"') and (s[Length(s)] = '"') then
    Result := Copy(s, 2, Length(s) - 2)
  else
    Result := s;
end;

procedure RMSetCommaText(Text: string; sl: TStringList);
var
  i: Integer;

  function ExtractCommaName(s: string; var Pos: Integer): string;
  var
    i: Integer;
  begin
    i := Pos;
    while (i <= Length(s)) and (s[i] <> ';') do
      Inc(i);
    Result := Copy(s, Pos, i - Pos);
    if (i <= Length(s)) and (s[i] = ';') then
      Inc(i);
    Pos := i;
  end;

begin
  i := 1;
  sl.Clear;
  while i <= Length(Text) do
    sl.Add(ExtractCommaName(Text, i));
end;

function RMCanvasWidth(const aStr: string; aFont: TFont): integer;
begin
  with TCanvas.Create do
  begin
    Handle := GetDC(0);
    Font.Assign(aFont);
    Result := TextWidth(aStr);
    ReleaseDC(0, Handle);
    Free;
  end;
end;

function RMCanvasHeight(const aStr: string; aFont: TFont): integer;
begin
  with TCanvas.Create do
  begin
    Handle := GetDC(0);
    Font.Assign(aFont);
    Result := TextHeight(aStr);
    ReleaseDC(0, Handle);
    Free;
  end;
end;

function RMWrapStrings(const SrcLines: TStrings; DstLines: TStrings; aCanvas: TCanvas;
  aWidth: Integer; const aOneLineHeight: Integer; aWordBreak, aMangeTag, aWidthFlag: Boolean): integer;
var
  i: Integer;
  liNewLine: string;
  NowHeight: Integer;
  LineFinished: Boolean;

  function TW(const s: string): integer;
  var
    fs, fs1, i, j, k: Integer;
  begin
    fs := aCanvas.Font.size;
    fs1 := fs div 2;
    if fs1 < 6 then
      fs1 := 6;
    j := 0;
    i := 1;
    while i <= length(s) do
    begin
      if aMangeTag and (s[i] = '_') then
      begin
        aCanvas.Font.size := fs1;
        Inc(i);
      end;
      if aMangeTag and (s[i] = '~') then
      begin
        aCanvas.Font.size := fs1;
        Inc(i);
      end;
      if aMangeTag and (s[i] = '|') then
      begin
        aCanvas.Font.size := fs;
        Inc(i);
      end;
      if Windows.isDBCSLeadByte(Byte(s[i])) then
      begin
        k := aCanvas.TextHeight(Copy(s, i, 2));
        Inc(i);
      end
      else
      begin
        k := aCanvas.TextHeight(Copy(s, i, 2))
      end;

      j := j + k;
      Inc(i);
    end;

    Result := j;
    aCanvas.Font.size := fs;
  end;

  function LineWidth(const Line: string): integer;
  begin
    if aWidthFlag then
      Result := aCanvas.TextWidth(Line)
    else
      Result := tw(Line);
  end;

  procedure FlushLine;
  begin
    DstLines.Add(liNewLine);
    Inc(NowHeight, aOneLineHeight);
    liNewLine := '';
    LineFinished := True;
  end;

  procedure AddWord(aWord: string);
  var
    s: string;
  begin
    if LineWidth(liNewLine + aWord) > aWidth then
    begin
      if liNewLine = '' then
      begin
        while True do
        begin
          if (Length(aWord) > 1) and (aWord[1] in LeadBytes) then
            S := copy(aWord, 1, 2)
          else
            S := copy(aWord, 1, 1);

          if LineWidth(liNewLine + S) < aWidth then
          begin
            liNewLine := liNewLine + S;
            Delete(aWord, 1, Length(s));
          end
          else
          begin
            if liNewLine = '' then
            begin
              liNewLine := liNewLine + S;
              Delete(aWord, 1, Length(s));
            end;
            Break;
          end;
        end; {while}
      end; {if}

      FlushLine;
      if Length(aWord) > 0 then
        AddWord(aWord);
    end
    else
    begin
      liNewLine := liNewLine + aWord;
      if Length(aWord) > 0 then
        LineFinished := False;
    end;
  end;

  procedure AddOneLine(aStr: string);
  var
    i, liPos: Integer;
    liSingleFlag: Boolean;
    liNextWord: string;
  begin
    while Pos(#10, aStr) > 0 do
      Delete(aStr, Pos(#10, aStr), 1);

    liPos := Pos(#13, aStr);
    if liPos > 0 then
    begin
      repeat
        AddOneLine(Copy(aStr, 1, liPos - 1));
        Delete(aStr, 1, liPos);
        liPos := Pos(#13, aStr);
      until liPos = 0;
      AddOneLine(aStr);
      Exit;
    end;

    if aMangeTag then
    begin
      liPos := Pos('`', aStr);
      if liPos > 0 then
      begin
        repeat
          AddOneLine(Copy(aStr, 1, liPos - 1));
          Delete(aStr, 1, liPos);
          liPos := Pos('`', aStr);
        until liPos = 0;
        AddOneLine(aStr);
        Exit;
      end;
    end;

    liPos := 0;
    liNewLine := '';
    LineFinished := False;
    liSingleFlag := False;
    while (liPos < Length(aStr)) and (Length(aStr) > 0) do
    begin
      repeat
        Inc(liPos);
        if aStr[liPos] in LeadBytes then
        begin
          if liSingleFlag then
          begin
            Dec(liPos);
          end
          else
            Inc(liPos);
          liSingleFlag := False;
          Break;
        end
        else
        begin
          liSingleFlag := True;
        end;
      until (aStr[liPos] in RMBreakChars) or (liPos >= Length(aStr));

      if aWordBreak then
      begin
        if (Length(aStr) - liPos > 1) and (aStr[liPos + 1] in LeadBytes) then
        begin
          liNextWord := Copy(aStr, liPos + 1, 2);
          if (Length(liNewLine) > 0) and (LineWidth(liNewLine + Copy(aStr, 1, liPos) + liNextWord) > aWidth) then
          begin
            for i := Low(RMChineseBreakChars) to High(RMChineseBreakChars) do
            begin
              if liNextWord = RMChineseBreakChars[i] then
              begin
                FlushLine;
                Break;
              end;
            end;
          end;
        end;
      end;

      AddWord(Copy(aStr, 1, liPos));
      Delete(aStr, 1, liPos);
      liPos := 0;
    end;

    if not LineFinished then
      FlushLine;
  end;

begin
  NowHeight := 0;
  DstLines.BeginUpdate;
  LineFinished := False;
  for i := 0 to SrcLines.Count - 1 do
    AddOneLine(SrcLines[i]);
  DstLines.EndUpdate;
  Result := NowHeight;
end;

function RMGetBrackedVariable(const aStr: string; var aBeginPos, aEndPos: Integer): string;
var
  c: Integer;
  lFlag1, lFlag2: Boolean;
  lStrLen: Integer;
begin
  aEndPos := aBeginPos;
  lFlag1 := True;
  lFlag2 := True;
  c := 0;
  Result := '';
  lStrLen := Length(aStr);
  if (aStr = '') or (aBeginPos >= lStrLen) or (aEndPos > lStrLen) then
    Exit;

  Dec(aEndPos);
  repeat
    Inc(aEndPos);
    if aStr[aEndPos] in LeadBytes then
    begin
      aEndPos := aEndPos + 1;
    end
    else
    begin
      if lFlag1 and lFlag2 then
      begin
        if aStr[aEndPos] = '[' then
        begin
          if c = 0 then
            aBeginPos := aEndPos;
          Inc(c);
        end
        else if aStr[aEndPos] = ']' then
          Dec(c);
      end;

      if lFlag1 then
      begin
        if aStr[aEndPos] = '"' then
          lFlag2 := not lFlag2;
      end;

      if lFlag2 then
      begin
        if aStr[aEndPos] = '''' then
          lFlag1 := not lFlag1;
      end;
    end;
  until (c = 0) or (aEndPos >= lStrLen);

  Result := Copy(aStr, aBeginPos + 1, aEndPos - aBeginPos - 1);
end;

(* -------------------------------------------------- *)
(* RMCurrToBIGNum  将阿拉伯数字转成中文数字字串
(* 使用示例:
(*   RMCurrToBIGNum(10002.34) ==> 一万零二圆三角四分
(* -------------------------------------------------- *)
const
  _ChineseNumeric: array[0..22] of string = (
    '零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖', '拾', '佰', '仟',
    '万', '亿', '兆', '元', '角', '分', '厘', '点', '负', '整');

function RMCurrToBIGNum(Value: Currency): string;
var
  sArabic, sIntArabic: string;
  sSectionArabic, sSection: string;
  i, iDigit, iSection, iPosOfDecimalPoint: integer;
  bInZero, bMinus: boolean;
  lNeedAddZero: Boolean;

  function ConvertStr(const str: string): string; //将字串反向, 例如: 传入 '1234', 传回 '4321'
  var
    i: integer;
  begin
    Result := '';
    for i := Length(str) downto 1 do
      Result := Result + str[i];
  end;

begin
  Result := '';
  bInZero := True;
  sArabic := FloatToStr(Value); //将数字转成阿拉伯数字字串
  if sArabic[1] = '-' then
  begin
    bMinus := True;
    sArabic := Copy(sArabic, 2, 9999);
  end
  else
    bMinus := False;

  lNeedAddZero := False;
  iPosOfDecimalPoint := Pos('.', sArabic); //取得小数点的位置
  //先处理整数的部分
  if iPosOfDecimalPoint = 0 then
    sIntArabic := ConvertStr(sArabic)
  else
    sIntArabic := ConvertStr(Copy(sArabic, 1, iPosOfDecimalPoint - 1));

  //从个位数起以每四位数为一小节
  for iSection := 0 to ((Length(sIntArabic) - 1) div 4) do
  begin
    sSectionArabic := Copy(sIntArabic, iSection * 4 + 1, 4);
    sSection := '';
    for i := 1 to Length(sSectionArabic) do //以下的 i 控制: 个十百千位四个位数
    begin
      iDigit := Ord(sSectionArabic[i]) - 48;
      if iDigit = 0 then
      begin
        if (iSection = 0) and (i = 1) then
          lNeedAddZero := True;

        if (not bInZero) and (i <> 1) then
          sSection := _ChineseNumeric[0] + sSection;
        bInZero := True;
      end
      else
      begin
        case i of
          2: sSection := _ChineseNumeric[10] + sSection;
          3: sSection := _ChineseNumeric[11] + sSection;
          4: sSection := _ChineseNumeric[12] + sSection;
        end;
        sSection := _ChineseNumeric[iDigit] + sSection;
        bInZero := False;
      end;
    end;

    //加上该小节的位数
    if Length(sSection) = 0 then
    begin
      if (Length(Result) > 0) and (Copy(Result, 1, 2) <> _ChineseNumeric[0]) then
        Result := _ChineseNumeric[0] + Result;
    end
    else
    begin
      case iSection of
        0: Result := sSection + Result;
        1: Result := sSection + _ChineseNumeric[13] + Result;
        2: Result := sSection + _ChineseNumeric[14] + Result;
        3: Result := sSection + _ChineseNumeric[15] + Result;
      end;
    end;
  end;

  if Length(Result) > 0 then
    Result := Result + _ChineseNumeric[16];
  if iPosOfDecimalPoint > 0 then //处理小数部分
  begin
    if lNeedAddZero then // 需要加"零", 107000.53:壹拾万柒仟元零伍角叁分
      Result := Result + _ChineseNumeric[0];

    for i := iPosOfDecimalPoint + 1 to Length(sArabic) do
    begin
      iDigit := Ord(sArabic[i]) - 48;
      Result := Result + _ChineseNumeric[iDigit];
      case i - (iPosOfDecimalPoint + 1) of
        0:
          begin
            if iDigit > 0 then
              Result := Result + _ChineseNumeric[17];
          end;
        1: Result := Result + _ChineseNumeric[18];
        2: Result := Result + _ChineseNumeric[19];
      end;
    end;
  end;

  //其他例外状况的处理
  if Length(Result) = 0 then
    Result := _ChineseNumeric[0];
  //  if Copy(Result, 1, 4) = _ChineseNumeric[1] + _ChineseNumeric[10] then
  //    Result := Copy(Result, 3, 254);
  if Copy(Result, 1, 2) = _ChineseNumeric[20] then
    Result := _ChineseNumeric[0] + Result;

  if bMinus then
    Result := _ChineseNumeric[21] + Result;
  if ((Round(Value * 100)) div 1) mod 10 = 0 then
    Result := Result + _ChineseNumeric[22];
end;

function RMChineseNumber(const jnum: string): string;
var
  hjnum: real;
  Vstr, zzz, cc, cc1, Presult: string;
  xxbb: array[1..12] of string;
  uppna: array[0..9] of string;
  iCount, iZero {,vpoint}: integer;
begin
  hjnum := strtofloat(jnum);
  result := '';
  presult := '';
  if hjnum < 0 then
  begin
    hjnum := -hjnum;
    Result := '负';
  end;

  xxbb[1] := '亿';
  xxbb[2] := '千';
  xxbb[3] := '百';
  xxbb[4] := '十';
  xxbb[5] := '万';
  xxbb[6] := '千';
  xxbb[7] := '百';
  xxbb[8] := '十';
  xxbb[9] := '一';
  xxbb[10] := '.';
  xxbb[11] := '';
  xxbb[12] := '';

  uppna[0] := '零';
  uppna[1] := '一';
  uppna[2] := '二';
  uppna[3] := '三';
  uppna[4] := '四';
  uppna[5] := '五';
  uppna[6] := '六';
  uppna[7] := '七';
  uppna[8] := '八';
  uppna[9] := '九';

  Str(hjnum: 12: 2, Vstr);
  cc := '';
  cc1 := '';
  zzz := '';

  iZero := 0;
  //  vPoint:=0;
  for iCount := 1 to 10 do
  begin
    cc := Vstr[iCount];
    if cc <> ' ' then
    begin
      zzz := xxbb[iCount];
      if cc = '0' then
      begin
        if iZero < 1 then //*对“零”进行判断*//
          cc := '零'
        else
          cc := '';
        if iCount = 5 then //*对万位“零”的处理*//
          if copy(result, length(result) - 1, 2) = '零' then
            result := copy(result, 1, length(result) - 2) + xxbb[iCount] + '零'
          else
            result := result + xxbb[iCount];
        cc1 := cc;
        zzz := '';
        iZero := iZero + 1;
      end
      else
      begin
        if cc = '.' then
        begin
          cc := '';
          if (cc1 = '') or (cc1 = '零') then
          begin
            Presult := copy(result, 1, Length(result) - 2);
            result := Presult;
            iZero := 15;
          end;
          zzz := '';
        end
        else
        begin
          iZero := 0;
          cc := uppna[StrToInt(cc)];
        end
      end;
      result := result + (cc + zzz)
    end;
  end;

  if Vstr[11] = '0' then //*对小数点后两位进行处理*//
  begin
    if Vstr[12] <> '0' then
    begin
      cc := '点';
      result := result + cc;
      cc := uppna[StrToInt(Vstr[12])];
      result := result + (uppna[0] + cc + xxbb[12]);
    end
  end
  else
  begin
    if iZero = 15 then
    begin
      cc := '点';
      result := result + cc;
    end;
    cc := uppna[StrToInt(Vstr[11])];
    Result := Result + (cc + xxbb[11]);
    if Vstr[12] <> '0' then
    begin
      cc := uppna[StrToInt(Vstr[12])];
      Result := Result + (cc + xxbb[12]);
    end;
  end;

  if Copy(Result, 1, 4) = '一十' then
    Delete(Result, 1, 2);
end;

function RMSmallToBig(curs: string): string;
var
  Small, Big: string;
  wei: string[2];
  i: integer;
begin
  small := trim(curs);
  Big := '';
  for i := 1 to length(Small) do
  begin
    case strtoint(small[i]) of {位置上的数转换成大写}
      1: wei := '壹';
      2: wei := '贰';
      3: wei := '叁';
      4: wei := '肆';
      5: wei := '伍';
      6: wei := '陆';
      7: wei := '柒';
      8: wei := '捌';
      9: wei := '玖';
      0: wei := '零';
    end;

    Big := Big + wei; {组合成大写}
  end;

  Result := Big;
end;

procedure RMSetFontSize(aComboBox: TComboBox; aFontHeight, aFontSize: integer);
var
  i: integer;
begin
  for i := Low(RMDefaultFontSize) to High(RMDefaultFontSize) do
  begin
    if RMDefaultFontSize[i] = aFontHeight then
    begin
      if RMIsChineseGB then
        aComboBox.Text := RMDefaultFontSizeStr[i]
      else
        aComboBox.Text := RMDefaultFontSizeStr[i + 13];

      Exit;
    end;
  end;

  aComboBox.Text := IntToStr(aFontSize);
end;

procedure RMSetFontSize1(aListBox: TListBox; aFontSize: integer);
var
  i: integer;
begin
  for i := Low(RMDefaultFontSize) to High(RMDefaultFontSize) do
  begin
    if RMDefaultFontSize[i] = aFontSize then
    begin
      if RMIsChineseGB then
        aListBox.ItemIndex := i
      else
        aListBox.ItemIndex := i + 13;

      Break;
    end;
  end;
end;

function RMGetFontSize(aComboBox: TComboBox): integer;
begin
  if aComboBox.ItemIndex >= 0 then
  begin
    if aComboBox.ItemIndex <= High(RMDefaultFontSize) then
      Result := RMDefaultFontSize[aComboBox.ItemIndex]
    else
      Result := StrToInt(aComboBox.Text);
  end
  else
  begin
    try
      Result := StrToInt(aComboBox.Text);
    except
      Result := 0;
    end;
  end;
end;

function RMGetFontSize1(aIndex: Integer; aText: string): integer;
begin
  if aIndex >= 0 then
  begin
    if aIndex <= High(RMDefaultFontSize) then
      Result := RMDefaultFontSize[aIndex]
    else
      Result := StrToInt(aText);
  end
  else
  begin
    try
      Result := StrToInt(aText);
    except
      Result := 0;
    end;
  end;
end;

function RMCreateBitmap(const ResName: string): TBitmap;
begin
  Result := TBitmap.Create;
  Result.Handle := LoadBitmap(HInstance, PChar(ResName));
end;

procedure RMSetStrProp(aObject: TObject; const aPropName: string; ID: Integer);
var
  str: string;
  pi: PPropInfo;
begin
  str := RMLoadStr(ID);
  if str <> '' then
  begin
    pi := GetPropInfo(aObject.ClassInfo, aPropName);
    if pi <> nil then
      SetStrProp(aObject, pi, str);
  end;
end;

function RMGetPropValue(aReport: TRMReport; const aObjectName, aPropName: string): Variant;
var
  pi: PPropInfo;
  lObject: TObject;
begin
  Result := varEmpty;
  if aReport <> nil then
    lObject := RMFindComponent(aReport.Owner, aObjectName)
  else
    lObject := RMFindComponent(nil, aObjectName);

  if lObject <> nil then
  begin
    pi := GetPropInfo(lObject.ClassInfo, aPropName);
    if pi <> nil then
    begin
      case pi.PropType^.Kind of
        tkString, tkLString, tkWString:
          Result := GetStrProp(lObject, pi);
        tkInteger, tkEnumeration:
          Result := GetOrdProp(lObject, pi);
        tkFloat:
          Result := GetFloatProp(lObject, pi);
      end;
    end;
  end;
end;

function RMRound(x: Extended; dicNum: Integer): Extended; //四舍五入
var
  tmp: string;
  i: Integer;
begin
  if dicNum = 0 then
  begin
    Result := Round(x);
    Exit;
  end;

  tmp := '#.';
  for i := 1 to dicNum do
    tmp := tmp + '0';
  Result := StrToFloat(FormatFloat(tmp, x));
end;

function RMMakeFileName(AFileName, AFileExtension: string; ANumber: Integer): string;
var
  FileName: string;
begin
  FileName := ChangeFileExt(ExtractFileName(AFileName), '');
  Result := Format('%s%.4d.%s', [FileName, ANumber, AFileExtension]);
end;

function RMAppendTrailingBackslash(const S: string): string;
begin
  Result := S;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + '\';
end;

function RMColorBGRToRGB(AColor: TColor): string;
begin
  Result := IntToHex(ColorToRGB(AColor), 6);
  Result := Copy(Result, 5, 2) + Copy(Result, 3, 2) + Copy(Result, 1, 2);
end;

function RMMakeImgFileName(AFileName, AFileExtension: string; ANumber: Integer): string;
var
  FileName: string;
begin
  FileName := ChangeFileExt(ExtractFileName(AFileName), '');
  Result := Format('%s_I%.4d.%s', [FileName, ANumber, AFileExtension]);
end;

procedure RMSetControlsEnable(AControl: TWinControl; AState: Boolean);
const
  StateColor: array[Boolean] of TColor = (clInactiveBorder, clWindow);
var
  I: Integer;
begin
  with AControl do
    for I := 0 to ControlCount - 1 do
    begin
      if ((Controls[I] is TWinControl) and
        (TWinControl(Controls[I]).ControlCount > 0)) then
        RMSetControlsEnable(TWinControl(Controls[I]), AState);
      if (Controls[I] is TCustomEdit) then
        THackWinControl(Controls[I]).Color := StateColor[AState]
      else if (Controls[I] is TCustomComboBox) then
        THackWinControl(Controls[I]).Color := StateColor[AState];
      Controls[I].Enabled := AState;
    end;
end;

procedure RMSaveFormPosition(aParentKey: string; aForm: TForm);
var
  Ini: TRegIniFile;
  Name: string;
begin
  Ini := TRegIniFile.Create(RMRegRootKey + aParentKey);
  Name := rsForm + aForm.ClassName;
  Ini.WriteInteger(Name, rsX, aForm.Left);
  Ini.WriteInteger(Name, rsY, aForm.Top);
  Ini.WriteInteger(Name, rsWidth, aForm.Width);
  Ini.WriteInteger(Name, rsHeight, aForm.Height);
  Ini.WriteBool(Name, rsMaximized, aForm.WindowState = wsMaximized);
  Ini.Free;
end;

procedure RMRestoreFormPosition(aParentKey: string; aForm: TForm);
var
  lIni: TRegIniFile;
  lName: string;
  lMaximized: Boolean;
begin
  lIni := TRegIniFile.Create(RMRegRootKey + aParentKey);
  try
    lName := rsForm + aForm.ClassName;
    lMaximized := lIni.ReadBool(lName, rsMaximized, True);
    if not lMaximized then
      aForm.WindowState := wsNormal;

    aForm.SetBounds(lIni.ReadInteger(lName, rsX, aForm.Left),
      lIni.ReadInteger(lName, rsY, aForm.Top),
      lIni.ReadInteger(lName, rsWidth, aForm.Width),
      lIni.ReadInteger(lName, rsHeight, aForm.Height));
  finally
    lIni.Free;
  end;
end;

{ 获取JPEG的宽度、高度等信息 }
{ Copyright Kingron 2002 }

const
  JPEG_FLAG_BEGIN = $D8FF;
  JPEG_FLAG_END = $D9FF;
  JPEG_FRAME = $C0FF;

type
  TSegHeader = packed record
    Flag: WORD;
    LenHi, LenLo: Byte;
  end;

function GetJPEGSize(FileName: string; var Width, Height: WORD): Boolean;
var
  FS: TFileStream;
  Flag1, Flag2: WORD;
  B: Byte;

  procedure SeekForFrame;
  var
    Seg: TSegHeader;
  begin
    with Seg, FS do
    begin
      repeat
        Read(Seg, SizeOf(Seg));
        if Flag <> JPEG_FRAME then
          Position := Position + MakeWord(LenLo, LenHi) - 2;
      until (Position >= Fs.Size) or (Seg.Flag = JPEG_FRAME);
    end;
  end;

begin
  FS := TFileStream.Create(FileName, fmOpenRead);
  try
    { JPEG 文件开头必须为 FF D8,文件尾必须为 FF D9 }
    FS.Read(Flag1, SizeOf(Flag1));
    FS.Position := FS.Size - 2;
    FS.Read(Flag2, SizeOf(Flag2));
    Result := (Flag1 = JPEG_FLAG_BEGIN) and (Flag2 = JPEG_FLAG_END);
    if not Result then exit; { 不是合法的JPEG文件则退出 }

    FS.Position := 2;
    SeekForFrame; { 寻找JPEG的Frame段，即图像数据区 }
    FS.Read(B, SizeOf(B)); { Frame段段头后第一个Byte为数据精度 }

    FS.Read(B, SizeOf(B)); { 高度高字节 }
    WordRec(Height).Hi := B;
    FS.Read(B, SizeOf(B)); { 高度低字节 }
    WordRec(Height).Lo := B;

    FS.Read(B, SizeOf(B)); { 宽度高字节 }
    WordRec(Width).Hi := B;
    FS.Read(B, SizeOf(B)); { 宽度低字节 }
    WordRec(Width).Lo := B;
  finally
    FS.Free;
  end;
end;

procedure RMGetBitmapPixels(aGraphic: TGraphic; var x, y: Integer);
var
  mem: TMemoryStream;
  FileBMPHeader: TBitMapFileHeader;

  procedure _GetBitmapHeader;
  var
    bmHeadInfo: PBITMAPINFOHEADER;
  begin
    try
      GetMem(bmHeadInfo, Sizeof(TBITMAPINFOHEADER));
      mem.ReadBuffer(bmHeadInfo^, Sizeof(TBITMAPINFOHEADER));
      x := Round(bmHeadInfo.biXPelsPerMeter / 39);
      y := Round(bmHeadInfo.biYPelsPerMeter / 39);
      FreeMem(bmHeadInfo, Sizeof(TBITMAPINFOHEADER));
    finally
      if x < 1 then
        x := 96;
      if y < 1 then
        y := 96;
    end;
  end;

begin
  x := 96;
  y := 96;
  mem := TMemoryStream.Create;
  try
    aGraphic.SaveToStream(mem);
    mem.Position := 0;

    if (mem.Read(FileBMPHeader, Sizeof(TBITMAPFILEHEADER)) = Sizeof(TBITMAPFILEHEADER)) and
      (FileBMPHeader.bfType = $4D42) then
    begin
      _GetBitmapHeader;
    end;
  finally
    mem.Free;
  end;
end;

function RMGetWindowsVersion: string;
var
  Ver: TOsVersionInfo;
begin
  Ver.dwOSVersionInfoSize := SizeOf(Ver);
  GetVersionEx(Ver);
  with Ver do
  begin
    case dwPlatformId of
      VER_PLATFORM_WIN32s: Result := '32s';
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          dwBuildNumber := dwBuildNumber and $0000FFFF;
          if (dwMajorVersion > 4) or ((dwMajorVersion = 4) and
            (dwMinorVersion >= 10)) then
            Result := '98'
          else
            Result := '95';
        end;
      VER_PLATFORM_WIN32_NT: Result := 'NT';
    end;
  end;
end;

function RMMonth_EnglishShort(aMonth: Integer): string;
begin
  Result := '';
  if (aMonth < 1) or (aMonth > 12) then
    Exit;
  case aMonth of
    1: Result := SShortMonthNameJan;
    2: Result := SShortMonthNameFeb;
    3: Result := SShortMonthNameMar;
    4: Result := SShortMonthNameApr;
    5: Result := SShortMonthNameMay;
    6: Result := SShortMonthNameJun;
    7: Result := SShortMonthNameJul;
    8: Result := SShortMonthNameAug;
    9: Result := SShortMonthNameSep;
    10: Result := SShortMonthNameOct;
    11: Result := SShortMonthNameNov;
    12: Result := SShortMonthNameDec;
  end;
end;

function RMMonth_EnglishLong(aMonth: Integer): string;
begin
  Result := '';
  if (aMonth < 1) or (aMonth > 12) then
    Exit;
  case aMonth of
    1: Result := SLongMonthNameJan;
    2: Result := SLongMonthNameFeb;
    3: Result := SLongMonthNameMar;
    4: Result := SLongMonthNameApr;
    5: Result := SLongMonthNameMay;
    6: Result := SLongMonthNameJun;
    7: Result := SLongMonthNameJul;
    8: Result := SLongMonthNameAug;
    9: Result := SLongMonthNameSep;
    10: Result := SLongMonthNameOct;
    11: Result := SLongMonthNameNov;
    12: Result := SLongMonthNameDec;
  end;
end;

function RMNumToBig(Value: Integer): string;
var
  i: Integer;
  lBigNums, lstr: string;
begin
  Result := '';
  if Value = 0 then
  begin
    Result := '０';
    Exit
  end;

  lBigNums := '０一二三四五六七八九十';
  lstr := IntTostr(Value);
  for i := 1 to Length(lStr) do
    Result := Result + Copy(lBigNums, StrToInt(lstr[i]) * 2 + 1, 2);
end;

function RMSinglNumToBig(Value: Extended; Digit: Integer): string;
var
  lBigNums, lstr: string;
  lPos: Integer;
begin
  Result := '';
  if Digit = 0 then
    Exit;
  lBigNums := '零壹贰叁肆伍陆柒捌玖';
  lstr := FloatTostr(Value);
  lPos := Pos('.', lstr) - Digit;

  if (lPos > 0) and (lPos < Length(lstr)) then
    Result := copy(lBigNums, StrToInt(lstr[lPos]) * 2 + 1, 2);
end;

{***************************函数头部说明******************************
// 单元名称 : Unit1
// 函数名称 :HexByte
// 函数实现目标：
// 参    数 :b: Byte
// 返回值   :string
// 作    者 :  ＳＩＮＭＡＸ           　　　　　  　　　　　
// 　　　　 "._`-.　　　　 (\-.　          Http://SinMax.yeah.net
// 　　　　　　'-.`;.--.___/ _`>　      　 Email:SinMax@163.net
// 　　　　　　　 `"( )　　, ) 　      　　　　
// 　　　　　　　　　\\----\-\　       　　　==== 郎  正 ====  　
// 　　　 ~~ ~~~~~~ "" ~~ """ ~~~~~~~~~　　
// 创建日期 :  2002-07-26
// 工作路径 :  C:\Documents and Settings\Administrator\桌面\File2Str\
// 修改记录 :
// 备   注 :
********************************************************************}

function HexByte(b: Byte): string;
const
  HexDigs: array[0..15] of char = '0123456789ABCDEF';
var
  bz: Byte;
begin
  bz := b and $F;
  b := b shr 4;
  HexByte := HexDigs[b] + HexDigs[bz];
end;

{***************************函数头部说明******************************
// 单元名称 : Unit1
// 函数名称 :File2TXT
// 函数实现目标：文件转为流
// 参    数 :Filename:String
// 返回值   :AnsiString
// 作    者 :  ＳＩＮＭＡＸ           　　　　　  　　　　　
// 　　　　 "._`-.　　　　 (\-.　          Http://SinMax.yeah.net ;
// 　　　　　　'-.`;.--.___/ _`>　      　 Email:SinMax@163.net
// 　　　　　　　 `"( )　　, ) 　      　　　　
// 　　　　　　　　　\\----\-\　       　　　==== 郎  正 ====  　
// 　　　 ~~ ~~~~~~ "" ~~ """ ~~~~~~~~~　　
// 创建日期 :  2002-07-26
// 工作路径 :  D:\报表客户端\计算\
// 修改记录 :
// 备   注 :
********************************************************************}
//load

function RMStream2TXT(aStream: TStream): AnsiString;
var
  lStr: AnsiString;
  Arec: char;
  i: integer;
begin
  lStr := '';
  aStream.Position := 0;
  for i := 0 to aStream.Size - 1 do
  begin
    aStream.Read(arec, 1);
    lStr := lStr + HexByte(Ord(Arec));
  end;
  lStr := lStr + '#';
  Result := lStr;
end;

{***************************函数头部说明******************************
// 单元名称 : Unit1
// 函数名称 :TForm1.TXT2File
// 函数实现目标：流转为文件
// 参    数 :inStr:AnsiString;Filename:String
// 返回值   :Boolean
// 作    者 :  ＳＩＮＭＡＸ           　　　　　  　　　　　
// 　　　　 "._`-.　　　　 (\-.　          Http://SinMax.yeah.net ;
// 　　　　　　'-.`;.--.___/ _`>　      　 Email:SinMax@163.net
// 　　　　　　　 `"( )　　, ) 　      　　　　
// 　　　　　　　　　\\----\-\　       　　　==== 郎  正 ====  　
// 　　　 ~~ ~~~~~~ "" ~~ """ ~~~~~~~~~　　
// 创建日期 :  2002-07-26
// 工作路径 :  D:\报表客户端\计算\
// 修改记录 :
// 备   注 :
********************************************************************}

function RMTXT2Stream(inStr: AnsiString; OutStream: TStream): Boolean;
var
  i, DEC: integer;
  lChar: Char;
begin
  Result := False;
  if inStr = '' then
  begin
    Result := True;
    Exit;
  end;

  i := 1;
  try
    while not (inStr[i] = '#') do
    begin
      DEC := StrtoInt(('$' + inStr[i])) * 16 + StrtoInt('$' + inStr[i + 1]);
      lChar := Chr(dec);
      OutStream.Write(lChar, 1);
      i := i + 2;
    end;
    Result := True;
  except
  end
end;

{$HINTS OFF}

function RMisNumeric(St: string): Boolean;
var
  R: Double;
  E: Integer;
begin
  Val(St, R, E);
  Result := (E = 0);
end;
{$HINTS ON}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDeviceCompatibleCanvas }

constructor TRMDeviceCompatibleCanvas.Create(aReferenceDC: HDC; aWidth, aHeight: Integer; aPalette: HPalette);
begin
  inherited Create;

  FReferenceDC := aReferenceDC;
  FWidth := aWidth;
  FHeight := aHeight;

  FSavePalette := 0;
  FRestorePalette := False;

  FCompatibleDC := CreateCompatibleDC(FReferenceDC);

  FCompatibleBitmap := CreateCompatibleBitmap(FReferenceDC, aWidth, aHeight);
  FOldBitMap := SelectObject(FCompatibleDC, FCompatibleBitmap);

  if aPalette <> 0 then
  begin
    FSavePalette := SelectPalette(FCompatibleDC, aPalette, False);
    RealizePalette(FCompatibleDC);
    FRestorePalette := True;
  end
  else
  begin
    FSavePalette := SelectPalette(FCompatibleDC, SystemPalette16, False);
    RealizePalette(FCompatibleDC);
    FRestorePalette := True;
  end;

  PatBlt(FCompatibleDC, 0, 0, aWidth, aHeight, WHITENESS);
  SetMapMode(FCompatibleDC, MM_TEXT);
end;

destructor TRMDeviceCompatibleCanvas.Destroy;
begin
  if FRestorePalette then
    SelectPalette(FReferenceDC, FSavePalette, False);

  FReferenceDC := 0;
  Handle := 0;
  if FCompatibleDC <> 0 then
  begin
    SelectObject(FCompatibleDC, FOldBitMap);
    DeleteObject(FCompatibleBitmap);
    DeleteDC(FCompatibleDC);
  end;

  inherited Destroy;
end;

procedure TRMDeviceCompatibleCanvas.CreateHandle;
begin
  UpdateFont;
  Handle := FCompatibleDC;
end;

procedure TRMDeviceCompatibleCanvas.Changing;
begin
  inherited Changing;
  UpdateFont;
end;

procedure TRMDeviceCompatibleCanvas.UpdateFont;
var
  lFontSize: Integer;
  liDevicePixelsPerInch: Integer;
begin
  liDevicePixelsPerInch := GetDeviceCaps(FReferenceDC, LOGPIXELSY);
  if (liDevicePixelsPerInch <> Font.PixelsPerInch) then
  begin
    lFontSize := Font.Size;
    Font.PixelsPerInch := liDevicePixelsPerInch;
    Font.Size := lFontSize;
  end;
end;

procedure TRMDeviceCompatibleCanvas.RenderToDevice(aDestRect: TRect; aPalette: HPalette; aCopyMode: TCopyMode);
var
  lSavePalette: HPalette;
  lbRestorePalette: Boolean;
begin
  lSavePalette := 0;
  lbRestorePalette := False;
  if aPalette <> 0 then
  begin
    lSavePalette := SelectPalette(FReferenceDC, aPalette, False);
    RealizePalette(FReferenceDC);
    lbRestorePalette := True;
  end;

  BitBlt(FReferenceDC,
    aDestRect.Left, aDestRect.Top, aDestRect.Right - aDestRect.Left, aDestRect.Bottom - aDestRect.Top,
    FCompatibleDC, 0, 0, aCopyMode);

  if lbRestorePalette then
    SelectPalette(FReferenceDC, lSavePalette, False);
end;

// Draw Bitmap

procedure _DrawDIBitmap(aCanvas: TCanvas; const aDestRect: TRect; aBitmap: TBitmap;
  aCopyMode: TCopyMode);
var
  BitmapHeader: pBitmapInfo;
  BitmapImage: Pointer;
  HeaderSize: DWORD;
  ImageSize: DWORD;
begin
  GetDIBSizes(aBitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage, ImageSize);
  try
    SetStretchBltMode(aCanvas.Handle, STRETCH_DELETESCANS);
    GetDIB(aBitmap.Handle, aBitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(aCanvas.Handle, aDestRect.Left, aDestRect.Top,
      aDestRect.Right - aDestRect.Left, aDestRect.Bottom - aDestRect.Top,
      0, 0, aBitmap.Width, aBitmap.Height, BitmapImage, TBitmapInfo(BitmapHeader^),
      DIB_RGB_COLORS, aCopyMode);
  finally
    FreeMem(BitmapImage);
    FreeMem(BitmapHeader);
  end;
end;

procedure _DrawTransparentDIBitmap(aCanvas: TCanvas; const aDestRect: TRect; aBitmap: TBitmap;
  aCopyMode: TCopyMode);
var
  liRasterCaps: Integer;
  lbStretchBlt: Boolean;

  function ppTransparentStretchBlt(aDstDC: HDC; aDstX, aDstY, aDstW, aDstH: Integer;
    aSrcDC: HDC; aSrcX, aSrcY, aSrcW, aSrcH: Integer; aMaskDC: HDC; aMaskX, aMaskY: Integer): Boolean;

  var
    lMemDC: HDC;
    lMemBmp: HBITMAP;
    lSaveBmp: HBITMAP;
    lSavePal: HPALETTE;
    lSaveTextColor, lSaveBkColor: TColorRef;

  begin

    Result := True;

    lSavePal := 0;

    {create compatible device context}
    lMemDC := CreateCompatibleDC(aSrcDC);

    try

      {create compatible bitmap and select into compatible DC}
      lMemBmp := CreateCompatibleBitmap(aSrcDC, aSrcW, aSrcH);
      lSaveBmp := SelectObject(lMemDC, lMemBmp);

      {get the current palette}
      lSavePal := SelectPalette(aSrcDC, SystemPalette16, False);

      SelectPalette(aSrcDC, lSavePal, False);

      {initialize memDC with appropriate palette}
      if lSavePal <> 0 then
        lSavePal := SelectPalette(lMemDC, lSavePal, True)
      else
        lSavePal := SelectPalette(lMemDC, SystemPalette16, True);

      RealizePalette(lMemDC);

      {copy the mask to the memDC and then copy the source using SrcErase }
      StretchBlt(lMemDC, 0, 0, aSrcW, aSrcH, aMaskDC, aMaskX, aMaskY, aSrcW, aSrcH, SrcCopy);
      StretchBlt(lMemDC, 0, 0, aSrcW, aSrcH, aSrcDC, aSrcX, aSrcY, aSrcW, aSrcH, SrcErase);

      {set text and background color for destination DC}
      lSaveTextColor := SetTextColor(aDstDC, $0);
      lSaveBkColor := SetBkColor(aDstDC, $FFFFFF);

      {copy mask to destDC and then copy the MemDC using SrcInvert}
      StretchBlt(aDstDC, aDstX, aDstY, aDstW, aDstH, aMaskDC, aMaskX, aMaskY, aSrcW, aSrcH, SrcAnd);
      StretchBlt(aDstDC, aDstX, aDstY, aDstW, aDstH, lMemDC, 0, 0, aSrcW, aSrcH, SrcInvert);

      {restore the text and background colors}
      SetTextColor(aDstDC, lSaveTextColor);
      SetBkColor(aDstDC, lSaveBkColor);

      {restore the mem bmp}
      if lSaveBmp <> 0 then
        SelectObject(lMemDC, lSaveBmp);

      {delete the memDbmp}
      DeleteObject(lMemBmp);

    finally

      {restore the palette and delete the memDC}
      if lSavePal <> 0 then
        SelectPalette(lMemDC, lSavePal, False);
      DeleteDC(lMemDC);

    end;

  end;

  procedure ppDrawTransparentDIBitmapUsingStretchBlt(aCanvas: TCanvas; const aRect: TRect; aBitmap: TBitmap; aCopyMode: TCopyMode);
  var
    liDrawWidth: Integer;
    liDrawHeight: Integer;
    liBitmapWidth: Integer;
    liBitmapHeight: Integer;
    lMaskBmp: TBitmap;
    lMaskCanvas: TRMDeviceCompatibleCanvas;
    lMemCanvas: TRMDeviceCompatibleCanvas;
    liDeviceBPP: Integer;
  begin

    liDrawWidth := aRect.Right - aRect.Left;
    liDrawHeight := aRect.Bottom - aRect.Top;

    {get device bitmap bits per pixel}
    liDeviceBPP := GetDeviceCaps(aCanvas.Handle, BITSPIXEL) * GetDeviceCaps(aCanvas.Handle, PLANES);

    {if device is monochrome, size bitmap based on printer pixels,
                              otherwise use screen pixels (to minimize memory}
    if (liDeviceBPP = 1) then
    begin
      liBitmapWidth := aRect.Right - aRect.Left;
      liBitmapHeight := aRect.Bottom - aRect.Top;
    end
    else
    begin
      liBitmapWidth := aBitmap.Width;
      liBitmapHeight := aBitmap.Height;

    end;

    {create a device compatible canvas in memory - with the required dimensions}
    lMemCanvas := TRMDeviceCompatibleCanvas.Create(aCanvas.Handle, liBitmapWidth, liBitmapHeight,
      aBitmap.Palette);

    {draw the bmp to the mem canvas}
    _DrawDIBitmap(lMemCanvas, Rect(0, 0, liBitmapWidth, liBitmapHeight), aBitmap, cmSrcCopy);

    {create a mask bmp}
    lMaskBmp := TBitmap.Create;
    lMaskBmp.Assign(aBitmap);
    lMaskBmp.Mask(clWhite);
    lMaskCanvas := TRMDeviceCompatibleCanvas.Create(aCanvas.Handle, liBitmapWidth,
      liBitmapHeight,
      aBitmap.Palette);

    {draw the mask bmp to the mask mem canvas}
    _DrawDIBitmap(lMaskCanvas, Rect(0, 0, liBitmapWidth, liBitmapHeight), lMaskBmp, cmSrcCopy);

    aCanvas.Brush.Style := bsClear;

    {use mem canvas and mask canvas to draw to the device canvas}
    ppTransparentStretchBlt(aCanvas.Handle, aRect.Left, aRect.Top,
      liDrawWidth, liDrawHeight,
      lMemCanvas.Handle, 0, 0, liBitmapWidth, liBitmapHeight,
      lMaskCanvas.Handle, 0, 0);

    lMaskBmp.Free;
    lMaskCanvas.Free;
    lMemCanvas.Free;
  end;

begin
  liRasterCaps := GetDeviceCaps(aCanvas.Handle, RASTERCAPS);
  lbStretchBlt := (liRasterCaps and RC_STRETCHBLT) > 0;
  if lbStretchBlt then
    ppDrawTransparentDIBitmapUsingStretchBlt(aCanvas, aDestRect, aBitmap, aCopyMode)
  else
    _DrawDIBitmap(aCanvas, aDestRect, aBitmap, aCopyMode);
end;

procedure RMPrintGraphic(aCanvas: TCanvas; aDestRect: TRect; aGraphic: TGraphic;
  aIsPrinting: Boolean; aDirectDraw: Boolean; aTransparent: Boolean);
var
  lBmp: TBitmap;
  liFreeBitmap: Boolean;

  procedure _GetAsBitmap;
  begin
    liFreeBitmap := True;
    lBmp := TBitmap.Create;
    try
      lBmp.Width := aGraphic.Width;
      lBmp.Height := aGraphic.Height;
      lBmp.Palette := aGraphic.Palette;
      lBmp.HandleType := bmDIB;
      lBmp.Canvas.Draw(0, 0, aGraphic);
    except
      try
        lBmp.Width := Trunc(aGraphic.Width * 0.25);
        lBmp.Height := Trunc(aGraphic.Height * 0.25);
        lBmp.Palette := aGraphic.Palette;
        lBmp.HandleType := bmDIB;
        lBmp.Canvas.StretchDraw(Rect(0, 0, lBmp.Width, lBmp.Height), aGraphic);
      except
        lBmp.Free;
        lBmp := nil;
        liFreeBitmap := False;
      end;
    end;
  end;

  procedure _DirectDrawImage(aGraphic: TGraphic);
  begin
    aCanvas.StretchDraw(aDestRect, aGraphic);
  end;

  procedure _DrawGraphic(aGraphic: TGraphic);
  var
    lMemCanvas: TRMDeviceCompatibleCanvas;
    lCopyMode: TCopyMode;
  begin
    lMemCanvas := TRMDeviceCompatibleCanvas.Create(aCanvas.Handle, aDestRect.Right - aDestRect.Left, aDestRect.Bottom - aDestRect.Top, aGraphic.Palette);
    if aGraphic is TBitmap then
      _DrawDIBitmap(lMemCanvas, aDestRect, TBitmap(aGraphic), cmSrcCopy)
    else
      lMemCanvas.StretchDraw(aDestRect, aGraphic);

    if aTransparent then
      lCopyMode := cmSrcAnd
    else
      lCopyMode := cmSrcCopy;

    lMemCanvas.RenderToDevice(aDestRect, aGraphic.Palette, lCopyMode);
    lMemCanvas.Free;
  end;

  procedure _DrawBmp(const aBitmap: TBitmap);
  begin
    if aTransparent then
      _DrawTransparentDIBitmap(aCanvas, aDestRect, aBitmap, cmSrcCopy)
    else
      _DrawDIBitmap(aCanvas, aDestRect, aBitmap, cmSrcCopy);
  end;

begin
  //  Application.ProcessMessages;
  if (not aIsPrinting) or (aGraphic is TMetaFile) or (aGraphic is TIcon) then
  begin
    aCanvas.StretchDraw(aDestRect, aGraphic);
    Exit;
  end;

  lBmp := nil;
  liFreeBitmap := False;
  try
    if aGraphic is TBitmap then
      lBmp := TBitmap(aGraphic)
    else
      _GetAsBitmap;

    if aGraphic is TBitmap then
    begin
      if lBmp.Monochrome and aDirectDraw then
        _DirectDrawImage(aGraphic)
      else
        _DrawBMP(lBmp);
    end
    else if aDirectDraw then
      _DirectDrawImage(aGraphic)
    else if lBmp <> nil then
      _DrawBMP(lBmp)
    else
      _DrawGraphic(aGraphic);
  finally
    if liFreeBitmap then
      lBmp.Free;
  end;
end;

function RMStrGetToken(s: string; delimeter: string; var APos: integer): string;
var
  tempStr: string;
  endStringPos: integer;
begin
  result := '';
  if APos <= 0 then exit;
  if APos > length(s) then
  begin
    APos := -1;
    exit;
  end;

  tempStr := copy(s, APos, length(s) + 1 - APos);
  if (length(delimeter) = 1) then
    {$IFNDEF Delphi3}
    endStringPos := pos(delimeter, tempStr)
      {$ELSE}
    endStringPos := AnsiPos(delimeter, tempStr)
      {$ENDIF}
  else
  begin
    delimeter := ' ' + delimeter + ' ';
    {$IFNDEF Delphi3}
    endStringPos := pos(UpperCase(delimeter), UpperCase(tempStr));
    {$ELSE}
    endStringPos := AnsiPos(UpperCase(delimeter), UpperCase(tempStr));
    {$ENDIF}
  end;

  if endStringPos <= 0 then
  begin
    result := tempStr;
    APos := -1;
  end
  else
  begin
    result := copy(tempStr, 1, endStringPos - 1);
    APos := APos + endStringPos + length(delimeter) - 1;
  end
end;

function RMCmp(const S1, S2: string): Boolean;
begin
  Result := (Length(S1) = Length(S2)) and
    (CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, PChar(S1),
    -1, PChar(S2), -1) = 2);
end;

function RMExtractField(const aStr: string; aFieldNo: Integer): string;
var
  i, j, k: Integer;
begin
  Result := '';
  j := 1;
  k := 0;
  for i := 1 to Length(aStr) do
  begin
    if aStr[i] = #1 then
    begin
      Inc(k);
      if k = aFieldNo then
      begin
        Result := Copy(aStr, j, i - j);
        Break;
      end
      else
        j := i + 1;
    end;
  end;
end;

procedure RMSetNullValue(var aValue1, aValue2: Variant);

  procedure _SetValue(var aValue1: Variant; const aValue2: Variant);
  begin
    if (TVarData(aValue2).VType = varString) or (TVarData(aValue2).VType = varOleStr) then
      aValue1 := ''
    else if TVarData(aValue2).VType = varBoolean then
      aValue1 := False
    else
      aValue1 := 0;
  end;

begin
  if (aValue1 = Null) or (aValue2 = Null) then
  begin
    if aValue1 = Null then
    begin
      _SetValue(aValue1, aValue2);
    end
    else if aValue2 = Null then
    begin
      _SetValue(aValue2, aValue1);
    end;
  end;
end;

function RMDeleteNoNumberChar(s: string): string;
begin
  s := Trim(s);
  while (Length(s) > 0) and not (s[1] in ['-', '0'..'9']) do
    s := Copy(s, 2, 255); // trim all non-digit chars at the begin
  while (Length(s) > 0) and not (s[Length(s)] in ['0'..'9']) do
    s := Copy(s, 1, Length(s) - 1); // trim all non-digit chars at the end
  while Pos(ThousandSeparator, s) <> 0 do
    Delete(s, Pos(ThousandSeparator, s), 1);

  Result := s;
end;

end.

