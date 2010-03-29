
{*******************************************}
{                                           }
{          Report Machine v2.0              }
{         Barcode Add-in object             }
{                                           }
{*******************************************}

unit RM_AsBarView;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls, Buttons, RM_Common, RM_Class, RM_Ctrls,
  RM_AsBarCode
{$IFDEF USE_INTERNAL_JVCL}, rm_JvInterpreter{$ELSE}, JvInterpreter{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

type
  TRMAsBarCodeObject = class(TComponent) // fake component
  end;

  TRMAsBarCodeAngleType = (rmatNone, rmat90, rmat180, rmat270);

  { TRMBarCodeInfo }
  TRMAsBarCodeInfo = class(TPersistent)
  private
    FBarCode: TAsBarcode;
    FShowText: Boolean;
    FAngle: TRMAsBarCodeAngleType;

    function GetText: string;
    procedure SetText(Value: string);
    function GetModul: Integer;
    procedure SetModul(Value: Integer);
    function GetRatio: Double;
    procedure SetRatio(Value: Double);
    function GetBarType: TBarcodeType;
    procedure SetBarType(Value: TBarcodeType);
    function GetChecksum: Boolean;
    procedure SetChecksum(Value: Boolean);
    function GetCheckSumMethod: TCheckSumMethod;
    procedure SetCheckSumMethod(Value: TCheckSumMethod);
    procedure SetAngle(Value: TRMAsBarCodeAngleType);
    function GetColor: TColor;
    procedure SetColor(Value: TColor);
    function GetColorBar: TColor;
    procedure SetColorBar(Value: TColor);
    function GetBarcodeHeight: Integer;
    function GetBarcodeWidth: Integer;
    procedure SetBarcodeHeight(const Value: Integer);
    procedure SetBarcodeWidth(const Value: Integer);
  protected
  public
    constructor Create;
    destructor Destroy; override;

    property BarCode: TAsBarcode read FBarCode write FBarCode;
    property Text: string read GetText write SetText;
  published
    property ShowText: Boolean read FShowText write FShowText;
    property Modul: integer read GetModul write SetModul;
    property Ratio: Double read GetRatio write SetRatio;
    property BarType: TBarcodeType read GetBarType write SetBarType;
    property Checksum: boolean read GetCheckSum write SetCheckSum;
    property CheckSumMethod: TCheckSumMethod read GetCheckSumMethod write SetCheckSumMethod;
    property Angle: TRMAsBarCodeAngleType read FAngle write SetAngle;
    property Color: TColor read GetColor write SetColor;
    property ColorBar: TColor read GetColorBar write SetColorBar;
    property BarcodeHeight: Integer read GetBarcodeHeight write SetBarcodeHeight;
    property BarcodeWidth: Integer read GetBarcodeWidth write SetBarcodeWidth;
  end;

  { TRMAsBarCodeView }
  TRMAsBarCodeView = class(TRMReportView)
  private
    FBarInfo: TRMAsBarCodeInfo;
    function GetDirectDraw: Boolean;
    procedure SetDirectDraw(Value: Boolean);
  protected
    function GetViewCommon: string; override;
    procedure PlaceOnEndPage(aStream: TStream); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure Draw(aCanvas: TCanvas); override;
    procedure DefinePopupMenu(aPopup: TRMCustomMenuItem); override;
    procedure ShowEditor; override;
  published
    property BarInfo: TRMAsBarCodeInfo read FBarInfo write FBarInfo;
    property LeftFrame;
    property TopFrame;
    property RightFrame;
    property BottomFrame;
    property FillColor;
    property DataField;
    property DirectDraw: Boolean read GetDirectDraw write SetDirectDraw;
    property PrintFrame;
    property Printable;
//    property GapLeft;
//    property GapTop;
  end;

implementation

uses RM_Const, RM_Const1, RM_Utils;

const
  flBarcodeDirectDraw = $2;
  cbDefaultText = '12345678';

function CreateRotatedFont(Font: TFont; Angle: Integer): HFont;
var
  F: TLogFont;
begin
  GetObject(Font.Handle, SizeOf(TLogFont), @F);
  F.lfEscapement := Angle * 10;
  F.lfOrientation := Angle * 10;
  Result := CreateFontIndirect(F);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMBarCodeInfo }

constructor TRMAsBarCodeInfo.Create;
begin
  inherited Create;

  FBarCode := TAsBarcode.Create(nil);
  FShowText := True;
  FBarCode.Height := 50;
  FBarCode.CheckSum := True;
  FBarCode.Modul := 1;
  FBarCode.Ratio := 2;
  FBarCode.Angle := 0;
end;

destructor TRMAsBarCodeInfo.Destroy;
begin
  FreeAndNil(FBarCode);
  inherited Destroy;
end;

function TRMAsBarCodeInfo.GetText: string;
begin
  Result := FBarCode.Text;
end;

procedure TRMAsBarCodeInfo.SetText(Value: string);
begin
  FBarCode.Text := Value;
end;

function TRMAsBarCodeInfo.GetModul: Integer;
begin
  Result := FBarCode.Modul;
end;

procedure TRMAsBarCodeInfo.SetModul(Value: Integer);
begin
  FBarCode.Modul := Value;
end;

function TRMAsBarCodeInfo.GetRatio: Double;
begin
  Result := FBarCode.Ratio;
end;

procedure TRMAsBarCodeInfo.SetRatio(Value: Double);
begin
  FBarCode.Ratio := Value;
end;

function TRMAsBarCodeInfo.GetBarType: TBarcodeType;
begin
  Result := FBarCode.Typ;
end;

procedure TRMAsBarCodeInfo.SetBarType(Value: TBarcodeType);
begin
  FBarCode.Typ := Value;
end;

function TRMAsBarCodeInfo.GetChecksum: Boolean;
begin
  Result := FBarCode.Checksum;
end;

procedure TRMAsBarCodeInfo.SetChecksum(Value: Boolean);
begin
  FBarCode.Checksum := Value;
end;

function TRMAsBarCodeInfo.GetCheckSumMethod: TCheckSumMethod;
begin
  Result := FBarCode.CheckSumMethod;
end;

procedure TRMAsBarCodeInfo.SetCheckSumMethod(Value: TCheckSumMethod);
begin
  FBarCode.CheckSumMethod := Value;
end;

procedure TRMAsBarCodeInfo.SetAngle(Value: TRMAsBarCodeAngleType);
begin
  FAngle := Value;
  case Value of
    rmatNone: FBarCode.Angle := 0;
    rmat90: FBarCode.Angle := 90;
    rmat180: FBarCode.Angle := 180;
    rmat270: FBarCode.Angle := 270;
  end;
end;

function TRMAsBarCodeInfo.GetColor: TColor;
begin
  Result := FBarCode.Color;
end;

procedure TRMAsBarCodeInfo.SetColor(Value: TColor);
begin
  FBarCode.Color := Value;
end;

function TRMAsBarCodeInfo.GetColorBar: TColor;
begin
  Result := FBarCode.ColorBar;
end;

procedure TRMAsBarCodeInfo.SetColorBar(Value: TColor);
begin
  FBarCode.ColorBar := Value;
end;

function TRMAsBarCodeInfo.GetBarcodeHeight: Integer;
begin
  Result := FBarcode.Height;
end;

procedure TRMAsBarCodeInfo.SetBarcodeHeight(const Value: Integer);
begin
  FBarcode.Height := Value;
end;

function TRMAsBarCodeInfo.GetBarcodeWidth: Integer;
begin
  Result := FBarcode.Width;
end;

procedure TRMAsBarCodeInfo.SetBarcodeWidth(const Value: Integer);
begin
  FBarcode.Width := Value;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{TRMAsBarCodeView}

constructor TRMAsBarCodeView.Create;
begin
  inherited Create;
  BaseName := 'Bar';
  Memo.Add(cbDefaultText);

  FBarInfo := TRMAsBarCodeInfo.Create;
end;

destructor TRMAsBarCodeView.Destroy;
begin
  FreeAndNil(FBarInfo);
  inherited Destroy;
end;

procedure TRMAsBarCodeView.LoadFromStream(aStream: TStream);
begin
  inherited LoadFromStream(aStream);
  RMReadWord(aStream);
  FBarInfo.ShowText := RMReadBoolean(aStream);
  FBarInfo.Modul := RMReadInt32(aStream);
  FBarInfo.Ratio := RMReadFloat(aStream);
  FBarInfo.BarType := TBarcodeType(RMReadByte(aStream));
  FBarInfo.Checksum := RMReadBoolean(aStream);
  FBarInfo.CheckSumMethod := TCheckSumMethod(RMReadByte(aStream));
  FBarInfo.Angle := TRMAsBarCodeAngleType(RMReadByte(aStream));
  FBarInfo.ColorBar := RMReadInt32(aStream);
end;

procedure TRMAsBarCodeView.SaveToStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 0); // °æ±¾ºÅ
  RMWriteBoolean(aStream, FBarInfo.ShowText);
  RMWriteInt32(aStream, FBarInfo.Modul);
  RMWriteFloat(aStream, FBarInfo.Ratio);
  RMWriteByte(aStream, Byte(FBarInfo.BarType));
  RMWriteBoolean(aStream, FBarInfo.Checksum);
  RMWriteByte(aStream, Byte(FBarInfo.CheckSumMethod));
  RMWriteByte(aStream, Byte(FBarInfo.Angle));
  RMWriteInt32(aStream, FBarInfo.ColorBar);
end;

procedure TRMAsBarCodeView.Draw(aCanvas: TCanvas);
var
  lStr: string;
  lEmf: TMetafile;
  lEmfCanvas: TMetafileCanvas;
  ldx, ldy, lHeight: Integer;

  procedure _DrawText;
  var
    lOldFont, lNewFont: HFont;
  begin
    if not FBarInfo.ShowText then Exit;

    lStr := FBarInfo.Text;
    with lEmfCanvas do
    begin
      Font.Color := clBlack;
      Font.Name := 'Courier New';
      Font.Height := -18{-12};
      Font.Style := [];
      lNewFont := CreateRotatedFont(Font, Round(FBarInfo.BarCode.Angle));
      lOldFont := SelectObject(Handle, lNewFont);
      if FBarInfo.BarCode.Angle = 0 then
        TextOut((ldx - TextWidth(lStr)) div 2, ldy - 12, lStr)
      else if FBarInfo.BarCode.Angle = 90 then
        TextOut(ldx - 12, ldy - (ldy - TextWidth(lStr)) div 2, lStr)
      else if FBarInfo.BarCode.Angle = 180 then
        TextOut(ldx - (ldx - TextWidth(lStr)) div 2, 12, lStr)
      else
        TextOut(12, (ldy - TextWidth(lStr)) div 2, lStr);

      SelectObject(Handle, lOldFont);
      DeleteObject(lNewFont);
    end;
  end;

begin
  if (spWidth < 0) or (spHeight < 0) then Exit;

  BeginDraw(aCanvas);
  Memo1.Assign(Memo);

  if (Memo1.Count > 0) and (Length(Memo1[0]) > 0) and (Memo1[0][1] <> '[') then
    lStr := Memo1.Strings[0]
  else
    lStr := cbDefaultText;

  if bcData[FBarInfo.BarType].Num = False then
    FBarInfo.Text := lStr
  else if RMIsNumeric(lStr) then
    FBarInfo.Text := lStr
  else
    FBarInfo.Text := cbDefaultText;

  if (FBarInfo.BarCode.Angle = 90) or (FBarInfo.BarCode.Angle = 270) then
    spHeight := FBarInfo.BarCode.Width + spGapTop * 2 + _CalcVFrameWidth(TopFrame.Width, BottomFrame.Width)
  else
    spWidth := FBarInfo.BarCode.Width + spGapLeft * 2 + _CalcHFrameWidth(LeftFrame.Width, RightFrame.Width);

  ldx := spWidth - spGapLeft * 2 - _CalcHFrameWidth(LeftFrame.Width, RightFrame.Width);
  ldy := spHeight - spGapTop * 2 - _CalcVFrameWidth(TopFrame.Width, BottomFrame.Width);
  if (ldx <= 0) or (ldy <= 0) or (Trim(FBarInfo.Text) = '0') then Exit;

  if (FBarInfo.BarCode.Angle = 90) or (FBarInfo.BarCode.Angle = 270) then
  begin
    if FBarInfo.ShowText then
      lHeight := ldx - 14
    else
      lHeight := ldx;
  end
  else if FBarInfo.ShowText then
    lHeight := ldy - 14
  else
    lHeight := ldy;

  FBarInfo.BarCode.Left := 0;
  FBarInfo.BarCode.Top := 0;
  FBarInfo.BarCode.Height := lHeight;
  if FBarInfo.BarCode.Angle = 180 then
    FBarInfo.BarCode.Top := ldy - lHeight
  else if FBarInfo.BarCode.Angle = 270 then
    FBarInfo.BarCode.Left := ldx - lHeight;

  lEmfCanvas := nil;
  lEmf := TMetafile.Create;
  lEmf.Width := spWidth;
  lEmf.Height := spHeight;
  lEmfCanvas := TMetafileCanvas.Create(lEmf, 0);
  try
    FBarInfo.BarCode.DrawBarcode(lEMFCanvas);
    _DrawText;
    FreeAndNil(lEmfCanvas);

    CalcGaps;
    ShowBackground;
    InflateRect(RealRect, -RMToScreenPixels(mmGapLeft, rmutMMThousandths),
      -RMToScreenPixels(mmGapTop, rmutMMThousandths));
    IntersectClipRect(aCanvas.Handle, RealRect.Left, RealRect.Top, RealRect.Right, RealRect.Bottom);
    RMPrintGraphic(aCanvas, RealRect, lEmf, IsPrinting, DirectDraw, False);
  finally
    Windows.SelectClipRgn(aCanvas.Handle, 0);
    ShowFrame;
    RestoreCoord;
    FreeAndNil(lEmfCanvas);
    FreeAndNil(lEmf);
  end;
end;

procedure TRMAsBarCodeView.PlaceOnEndPage(aStream: TStream);
begin
  inherited;
{  BeginDraw(Canvas);
  Memo1.Assign(Memo);
  InternalOnBeforePrint(Memo1, Self);
  if not Visible then Exit;
//  if IsPrinting and (not PPrintFrame) then Exit;

  if Memo1.Count > 0 then
  begin
    if (Length(Memo1[0]) > 0) and (Memo1[0][1] = '[') then
    begin
      try
        Memo1[0] := ParentReport.Parser.Calc(Memo1[0]);
      except
        Memo1[0] := '0';
      end;
    end;
  end;

  aStream.Write(Typ, 1);
  RMWriteString(aStream, ClassName);
  SaveToStream(aStream);
}end;

procedure TRMAsBarCodeView.DefinePopupMenu(aPopup: TRMCustomMenuItem);
begin
  inherited;
end;

procedure TRMAsBarCodeView.ShowEditor;
begin
end;

function TRMAsBarCodeView.GetDirectDraw: Boolean;
begin
  Result := (FFlags and flBarCodeDirectDraw) = flBarCodeDirectDraw;
end;

procedure TRMAsBarCodeView.SetDirectDraw(Value: Boolean);
begin
  FFlags := (FFlags and not flBarCodeDirectDraw);
  if Value then
    FFlags := FFlags + flBarCodeDirectDraw;
end;

function TRMAsBarCodeView.GetViewCommon: string;
begin
  Result := '[BarCode]';
end;

const
	cRM = 'RM_AsBarView';

procedure RM_RegisterRAI2Adapter(RAI2Adapter: TJvInterpreterAdapter);
begin
  with RAI2Adapter do
  begin
    AddClass(cRM, TRMAsBarCodeView, 'TRMAsBarCodeView');
  end;
end;

initialization
  RM_RegisterRAI2Adapter(GlobalJvInterpreterAdapter);
  RMRegisterObjectByRes(TRMAsBarCodeView, 'RM_BARCODEOBJECT', RMLoadStr(SInsBarcode), nil);
//  RMRegisterControl('ReportPage Additional', 'RM_OtherComponent', False,
//    TRMAsBarCodeView, 'RM_BARCODEOBJECT', RMLoadStr(SInsBarcode));

finalization

end.

