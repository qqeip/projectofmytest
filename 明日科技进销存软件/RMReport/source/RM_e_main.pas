
{******************************************************}
{                                                      }
{          Report Machine v3.0                         }
{           main export filter                         }
{                                                      }
{         write by whf and jim_waw(jim_waw@163.com)    }
{******************************************************}

unit RM_e_main;

interface

{$I RM.INC}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
  Controls, Comctrls, RM_Class
{$IFDEF RXGIF}, JvGif{$ENDIF}
{$IFDEF JPEG}, JPEG{$ENDIF};

type
  TRMEFImageFormat = (ifGIF, ifJPG, ifBMP);
  TRMObjType = (rmotMemo, rmotPicture);

  PRMEFTextRec = ^TRMEFTextRec;
  TRMEFTextRec = packed record
    Left, Top: Integer;
    Text: string;
    TextWidth: Integer;
    TextHeight: Integer;
  end;

  TRMEFDataRec = class
  private
    FTextList: TList;
    function GetTextList: TList;
    procedure ClearTextList;
    function GetTextListCount: Integer;
  public
    Left, Top, Width, Height: Integer;
    Obj: TRMReportView;
    ObjType: TRMObjType;
    Bitmap: TBitmap;
    BmpWidth: Integer;
    BmpHeight: Integer;
    TextWidth: Integer;
    ViewIndex: Integer;
    constructor Create;
    destructor Destroy; override;
    property TextList: TList read GetTextList;
    property TextListCount: Integer read GetTextListCount;
  end;

  TRMMainExportFilter = class;

  TBeforeSaveGraphicEvent = procedure(Sender: TRMMainExportFilter;
    AViewName: string; var UniqueImage: Boolean; var ReuseImageIndex: Integer;
    AAltText: string) of object;

  TAfterSaveGraphicEvent = procedure(Sender: TRMMainExportFilter;
    AViewName: string; ObjectImageIndex: Integer) of object;

 { TRMMainExportFilter }
  TRMMainExportFilter = class(TRMExportFilter)
  private
    FScaleX, FScaleY: Double;
    FExportFrames, FExportImages: Boolean;
{$IFDEF JPEG}
    FJPEGQuality: TJPEGQualityRange;
{$ENDIF}
    FViewNames: TStringList;
    FPixelFormat: TPixelFormat;
    FNowDataRec: TRMEFDataRec;
  protected
    CanMangeRotationText: Boolean;
    FDataList: TList;
    FPageNo: Integer;
    FPageWidth: Integer;
    FPageHeight: Integer;
    FExportImageFormat: TRMEFImageFormat;

    procedure SaveBitmapToPicture(aBmp: TBitmap; aImgFormat: TRMEFImageFormat
{$IFDEF JPEG}; aJPEGQuality: TJPEGQualityRange{$ENDIF}; var aPicture: TPicture);

    procedure OnBeginDoc; override;
    procedure OnEndDoc; override;
    procedure OnBeginPage; override;
    procedure OnEndPage; override;
    procedure OnExportPage(const aPage: TRMEndPage); override;
    procedure InternalOnePage(aPage: TRMEndPage); virtual;
    procedure OnText(aDrawRect: TRect; x, y: Integer; const aText: string; View: TRMView); override;
    procedure ClearDataList;
    property PixelFormat: TPixelFormat read FPixelFormat write FPixelFormat default pf24bit;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ScaleX: Double read FScaleX write FScaleX;
    property ScaleY: Double read FScaleY write FScaleY;
    property ExportImages: Boolean read FExportImages write FExportImages default True;
    property ExportFrames: Boolean read FExportFrames write FExportFrames default True;
    property ExportImageFormat: TRMEFImageFormat read FExportImageFormat write FExportImageFormat;
{$IFDEF JPEG}
    property JPEGQuality: TJPEGQualityRange read FJPEGQuality write FJPEGQuality default High(TJPEGQualityRange);
{$ENDIF}
  end;

const
  ImageFormats: array[TRMEFImageFormat] of string = ('GIF', 'JPG', 'BMP');

function RMReplaceString(const S, OldPattern, NewPattern: string): string;

implementation

uses RM_Common, RM_Utils;

function RMReplaceString(const S, OldPattern, NewPattern: string): string;
var
  I: Integer;
  SearchStr, Str, OldPat: string;
begin
  SearchStr := AnsiUpperCase(S);
  OldPat := AnsiUpperCase(OldPattern);
  Str := S;
  Result := '';
  while SearchStr <> '' do
  begin
    I := AnsiPos(OldPat, SearchStr);
    if I = 0 then
    begin
      Result := Result + Str;
      Break;
    end;
    Result := Result + Copy(Str, 1, I - 1) + NewPattern;
    Str := Copy(Str, I + Length(OldPattern), MaxInt);
    SearchStr := Copy(SearchStr, I + Length(OldPat), MaxInt);
  end;
end;

function RMGetTextSize(AFont: TFont; const Text: string): TSize;
var
  DC: HDC;
  SaveFont: HFont;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, AFont.Handle);
  Result.cX := 0;
  Result.cY := 0;
  GetTextExtentPoint32(DC, PChar(Text), Length(Text), Result);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

constructor TRMEFDataRec.Create;
begin
  inherited;
  FTextList := nil;
end;

destructor TRMEFDataRec.Destroy;
begin
  ClearTextList;
  FTextList.Free; FTextList := nil;
  inherited;
end;

function TRMEFDataRec.GetTextList: TList;
begin
  if FTextList = nil then
    FTextList := TList.Create;
  Result := FTextList;
end;

function TRMEFDataRec.GetTextListCount: Integer;
begin
  if FTextList = nil then
    Result := 0
  else
    Result := FTextList.Count;
end;

procedure TRMEFDataRec.ClearTextList;
var
  i: Integer;
begin
  if FTextList = nil then Exit;
  for i := 0 to FTextList.Count - 1 do
  begin
    Dispose(pRMEFTextRec(FTextList[i]));
  end;
  FTextList.Clear;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMMainExportFilter}

constructor TRMMainExportFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScaleX := 1;
  FScaleY := 1;
  ShowDialog := True;
{$IFDEF JPEG}
  FJPEGQuality := High(TJPEGQualityRange);
  FExportImageFormat := ifJPG;
{$ELSE}
  FExportImageFormat := ifBMP;
{$ENDIF}

  FExportImages := True;
  FExportFrames := True;
  FPixelFormat := pf24bit;
end;

destructor TRMMainExportFilter.Destroy;
begin
  RMUnRegisterExportFilter(Self);
  inherited Destroy;
end;

procedure TRMMainExportFilter.OnBeginDoc;
begin
  FDataList := TList.Create;
  FViewNames := TStringList.Create;

  FPageNo := 0;
  FPageWidth := ParentReport.EndPages[0].PageWidth;
  FPageHeight := ParentReport.EndPages[0].PageHeight;
end;

procedure TRMMainExportFilter.OnEndDoc;
begin
  ClearDataList;
  FDataList.Free;
  FViewNames.Free;
end;

procedure TRMMainExportFilter.OnBeginPage;
begin
  ClearDataList;
end;

procedure TRMMainExportFilter.OnEndPage;
begin
  Inc(FPageNo);
end;

type
  THackRMView = class(TRMReportView)
  end;

  THackMemoView = class(TRMCustomMemoView)
  end;

procedure TRMMainExportFilter.OnText(aDrawRect: TRect; x, y: Integer; const aText: string; View: TRMView);
var
  lTextRec: pRMEFTextRec;
begin
  New(lTextRec);
  lTextRec.Left := x;
  lTextRec.Top := y;
  lTextRec.Text := aText;
  lTextRec.TextWidth := RMGetTextSize(TRMCustomMemoView(FNowDataRec.Obj).Font, aText).cx;
  lTextRec.TextHeight := RMGetTextSize(TRMCustomMemoView(FNowDataRec.Obj).Font, aText).cy;
  FNowDataRec.TextList.Add(lTextRec);
end;

procedure TRMMainExportFilter.InternalOnePage(aPage: TRMEndPage);
begin
end;

procedure TRMMainExportFilter.OnExportPage(const aPage: TRMEndPage);
var
  i, lIndex: Integer;
  t: TRMReportView;
  lDataRec: TRMEFDataRec;
  lSaveOffsetLeft, lSaveOffsetTop: Integer;
  lIsMemoView: Boolean;
begin
  FPageWidth := Round(aPage.PrinterInfo.PageWidth * ScaleX);
  FPageHeight := Round(aPage.PrinterInfo.PageHeight * ScaleY);

  for i := 0 to aPage.Page.Objects.Count - 1 do
  begin
    t := aPage.Page.Objects[i];
    if t.IsBand or (t is TRMSubReportView) then Continue;

    lDataRec := TRMEFDataRec.Create;
    lDataRec.Obj := t;
    lDataRec.Bitmap := nil;
    lDataRec.ObjType := rmotMemo;

    lIndex := FViewNames.IndexOf(t.Name);
    if lIndex < 0 then
      lIndex := FViewNames.Add(t.Name);
    lDataRec.ViewIndex := lIndex;

    lDataRec.Left := Round(t.spLeft * ScaleX);
    lDataRec.Top := Round(t.spTop * ScaleY);
    lDataRec.Width := Round(t.spWidth * ScaleX);
    lDataRec.Height := Round(t.spHeight * ScaleY);

    lIsMemoView := (t.ClassName = TRMMemoView.ClassName) or (t.ClassName = TRMCalcMemoView.ClassName);
    lIsMemoView := lIsMemoView and (CanMangeRotationText or (THackMemoView(lDataRec.Obj).RotationType = rmrtNone));
    if lIsMemoView then
    begin
      lDataRec.Width := lDataRec.Width + 1;
      lDataRec.TextWidth := RMGetTextSize(TRMCustomMemoView(t).Font, t.Memo.Text).cx;

      lSaveOffsetLeft := THackRMView(t).OffsetLeft;
      lSaveOffsetTop := THackRMView(t).OffsetTop;
      THackRMView(t).OffsetLeft := 0;
      THackRMView(t).OffsetTop := 0;
      FNowDataRec := lDataRec;
      THackRMView(t).ExportData;
      THackRMView(t).OffsetLeft := lSaveOffsetLeft;
      THackRMView(t).OffsetTop := lSaveOffsetTop;
    end
    else
    begin
      lDataRec.ObjType := rmotPicture;
      if ExportImages then
      begin
        lDataRec.Bitmap := TBitmap.Create;
        lDataRec.Bitmap.PixelFormat := FPixelFormat;
        lDataRec.Bitmap.Width := Round(t.spWidth * ScaleX + 1);
        lDataRec.Bitmap.Height := Round(t.spHeight * ScaleY + 1);

        lSaveOffsetLeft := THackRMView(t).OffsetLeft;
        lSaveOffsetTop := THackRMView(t).OffsetTop;
        THackRMView(t).OffsetLeft := 0;
        THackRMView(t).OffsetTop := 0;
        t.SetspBounds(0, 0, lDataRec.Bitmap.Width - 1, lDataRec.Bitmap.Height - 1);
        t.Draw(lDataRec.Bitmap.Canvas);
        t.SetspBounds(t.spLeft, t.spTop, t.spWidth, t.spHeight);
        THackRMView(t).OffsetLeft := lSaveOffsetLeft;
        THackRMView(t).OffsetTop := lSaveOffsetTop;
      end;
    end;

    FDataList.Add(lDataRec);
  end;

  InternalOnePage(aPage);
end;

procedure TRMMainExportFilter.ClearDataList;
var
  i: Integer;
  p: TRMEFDataRec;
begin
  if FDataList = nil then Exit;

  for i := 0 to FDataList.Count - 1 do
  begin
    p := FdataList[i];
    if p.Bitmap <> nil then
      p.Bitmap.Free; //by waw
    p.Free;
  end;
  FDataList.Clear;
end;

procedure TRMMainExportFilter.SaveBitmapToPicture(aBmp: TBitmap; aImgFormat: TRMEFImageFormat
{$IFDEF JPEG}; aJPEGQuality: TJPEGQualityRange{$ENDIF}; var aPicture: TPicture);
var
  lGraphic: TGraphic;

  procedure SaveJpgGif;
  begin
    try
      lGraphic.Assign(aBmp);
      aPicture.Assign(lGraphic);
    finally
      lGraphic.Free;
    end;
  end;

begin
  aBmp.PixelFormat := FPixelFormat;
  case aImgFormat of
    ifBMP:
      begin
        aPicture.Assign(aBmp);
      end;
    ifGIF:
      begin
{$IFDEF RXGIF}
        lGraphic := TJvGIFImage.Create;
        SaveJpgGif;
{$ELSE}
{$IFDEF JPEG}
        lGraphic := TJPEGImage.Create;
        SaveJpgGif;
{$ELSE}
        aPicture.Assign(aBmp);
{$ENDIF}
{$ENDIF}
      end;
    ifJPG:
      begin
{$IFDEF JPEG}
        lGraphic := TJPEGImage.Create;
        TJPEGImage(lGraphic).CompressionQuality := JPEGQuality;
        SaveJpgGif;
{$ELSE}
        aPicture.Assign(aBmp);
{$ENDIF}
      end;
  end;
end;

end.

