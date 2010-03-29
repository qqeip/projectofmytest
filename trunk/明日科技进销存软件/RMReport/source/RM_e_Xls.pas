
{******************************************************}
{                                                      }
{          Report Machine v3.0                         }
{            XLS export filter                         }
{                                                      }
{         write by whf and jim_waw(jim_waw@163.com)    }
{******************************************************}

unit RM_e_Xls;

interface

{$I RM.inc}
{$IFDEF Delphi4}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Forms, StdCtrls, Controls,
  Dialogs, ExtCtrls, Buttons, ComCtrls, ShellApi,
  RM_Class, RM_e_main, RM_wawExcel
{$IFDEF RXGIF}, JvGIF{$ENDIF}
{$IFDEF JPEG}, JPeg{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

type
  { TRMXLSExport }
  TRMXLSExport = class(TRMMainExportFilter)
  private
    FExportPrecision: Integer;
    FExportPages: string;
    FShowAfterExport: Boolean;

    FOldAfterExport: TRMAfterExportEvent;
    FCols, FRows: TList;
    FPagesOfSheet: Integer;     //waw
    FCurPageNo: Integer;        //waw
    FTotalPages: Integer;        //waw
    FrStart: Integer;
    FpgList: TStringList;
    FWorkBook: TwawXLSWorkbook; //waw

    procedure _ClearColsAndRows;
    procedure DoAfterExport(const aFileName: string);
    procedure SaveToFile(const aFileName: string);
  protected
    procedure InternalOnePage(aPage: TRMEndPage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowModal: Word; override;
    procedure OnBeginDoc; override;
    procedure OnEndDoc; override;
    procedure OnBeginPage; override;
  published
    property ExportPages: string read FExportPages write FExportPages;
    property PixelFormat;
    property ShowAfterExport: Boolean read FShowAfterExport write FShowAfterExport;
    property ExportPrecision: Integer read FExportPrecision write FExportPrecision;
    property PagesOfSheet: Integer read FPagesOfSheet write FPagesOfSheet;
  end;

  { TRMCSVExportForm }
  TRMXLSExportForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edtExportFileName: TEdit;
    btnFileName: TSpeedButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    SaveDialog: TSaveDialog;
    rdbPrintAll: TRadioButton;
    rbdPrintCurPage: TRadioButton;
    rbdPrintPages: TRadioButton;
    edtPages: TEdit;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    chkShowAfterGenerate: TCheckBox;
    chkExportFrames: TCheckBox;
    gbExportImages: TGroupBox;
    lblExportImageFormat: TLabel;
    lblJPEGQuality: TLabel;
    Label4: TLabel;
    cmbImageFormat: TComboBox;
    edJPEGQuality: TEdit;
    UpDown1: TUpDown;
    cmbPixelFormat: TComboBox;
    chkExportImages: TCheckBox;
    edPages: TEdit;
    UpDown2: TUpDown;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnFileNameClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure rbdPrintPagesClick(Sender: TObject);
    procedure edtPagesEnter(Sender: TObject);
    procedure chkExportFramesClick(Sender: TObject);
    procedure edJPEGQualityKeyPress(Sender: TObject; var Key: Char);
    procedure cmbImageFormatChange(Sender: TObject);
  private
    { Private declarations }
    procedure Localize;
    function GetExportPages: string;
  public
    { Public declarations }
  end;

{$ENDIF}
implementation

{$IFDEF Delphi4}
uses Math, RM_wawWriters, RM_wawExcelFmt,
  RM_Common, RM_Const, RM_Const1, RM_Utils;

{$R *.DFM}

const
  xlEdgeBottom = $00000009;
  xlEdgeLeft = $00000007;
  xlEdgeRight = $0000000A;
  xlEdgeTop = $00000008;

{------------------------------------------------------------------------------}
{TRMXLSExport}

constructor TRMXLSExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RMRegisterExportFilter(Self, RMLoadStr(SCSVFile) + ' (*.xls)', '*.xls');

  ShowDialog := True;
  CreateFile := False;
  FExportPrecision := 1;
  FPagesOfSheet := 10;    //waw
  ExportImages := True;
  ExportFrames := True;
  FShowAfterExport := True;
  FExportImageFormat := ifBMP;
  FIsXLSExport := True;
  CanMangeRotationText := True;
end;

destructor TRMXLSExport.Destroy;
begin
  RMUnRegisterExportFilter(Self);
  inherited Destroy;
end;

procedure TRMXLSExport.DoAfterExport(const aFileName: string);
begin //by waw
  SaveToFile(aFileName);
  if FShowAfterExport then //by waw
    ShellExecute(0, 'open', PChar(aFileName), '', '', SW_SHOWNORMAL);

  if Assigned(FOldAfterExport) then FOldAfterExport(aFileName);
  OnAfterExport := FOldAfterExport;
end;

function TRMXLSExport.ShowModal: Word;
begin
  if not ShowDialog then
    Result := mrOk
  else
  begin
    with TRMXLSExportForm.Create(nil) do
    begin
      edtExportFileName.Text := Self.FileName;
      btnFileName.Enabled := edtExportFileName.Enabled;

      chkExportFrames.Checked := ExportFrames;
      chkShowAfterGenerate.Checked := Self.ShowAfterExport;
      UpDown2.Position := FPagesOfSheet;     //waw

      cmbPixelFormat.ItemIndex := Integer(Self.PixelFormat);
      chkExportImages.Checked := ExportImages;
      cmbImageFormat.ItemIndex := cmbImageFormat.Items.IndexOfObject(TObject(Ord(ExportImageFormat)));
{$IFDEF JPEG}
      UpDown1.Position := JPEGQuality;
{$ENDIF}
      chkExportFramesClick(Self);

      Result := ShowModal;
      if Result = mrOK then
      begin
        Self.FileName := edtExportFileName.Text;
        Self.ExportFrames := chkExportFrames.Checked;
        Self.ExportPages := GetExportPages;
        Self.ShowAfterExport := chkShowAfterGenerate.Checked;
        FPagesOfSheet := UpDown2.Position;

        ExportImages := chkExportImages.Checked;
        if ExportImages then
        begin
          Self.PixelFormat := TPixelFormat(cmbPixelFormat.ItemIndex);
          ExportImageFormat := TRMEFImageFormat
            (cmbImageFormat.Items.Objects[cmbImageFormat.ItemIndex]);
{$IFDEF JPEG}
          JPEGQuality := StrToInt(edJPEGQuality.Text);
{$ENDIF}
        end;
      end;
      Free;
    end;
  end;
end;

type
  TCol = class(TObject)
  public
    Index: integer;
    X: integer;
    constructor CreateCol(_X: integer);
  end;

constructor TCol.CreateCol;
begin
  inherited Create;
  X := _X;
end;

type
  TRow = class(TObject)
  private
    Index: integer;
    Y: integer;
    PageIndex: integer;
  public
    constructor CreateRow(_Y: integer; _PageIndex: integer);
  end;

constructor TRow.CreateRow;
begin
  inherited Create;
  Y := _Y;
  PageIndex := _PageIndex;
end;

procedure TRMXLSExport._ClearColsAndRows;
begin
  while FCols.Count > 0 do
  begin
    TCol(FCols[0]).Free;
    FCols.Delete(0);
  end;
  while FRows.Count > 0 do
  begin
    TRow(FRows[0]).Free;
    FRows.Delete(0);
  end;
end;

type
  rXLSExport = record
    LeftCol: TCol;
    RightCol: TCol;
    TopRow: TRow;
    BottomRow: TRow;
  end;
  pXLSExport = ^rXLSExport;

  THackMemoView = class(TRMCustomMemoView)
  end;

function SortCols(Item1, Item2: pointer): integer;
begin
  Result := TCol(Item1).X - TCol(Item2).X;
end;

function SortRows(Item1, Item2: pointer): integer;
begin
  if TRow(Item1).PageIndex = TRow(Item2).PageIndex then
    Result := TRow(Item1).Y - TRow(Item2).Y
  else
    Result := TRow(Item1).PageIndex - TRow(Item2).PageIndex;
end;

procedure TRMXLSExport.OnBeginDoc;

  procedure _ParsePageNumbers; //ȷ����Ҫ��ӡ��ҳ
  var
    i, j, n1, n2: Integer;
    s: string;
    IsRange: Boolean;
  begin
    s := ExportPages;
    if s = 'CURPAGE' then
    begin
      FpgList.Add(IntToStr(TRMEndPages(TRMReport(ParentReport).EndPages).CurPageNo));
      Exit;
    end;
    while Pos(' ', s) <> 0 do
      Delete(s, Pos(' ', s), 1);
    if s = '' then
      Exit;

    if s[Length(s)] = '-' then
      s := s + IntToStr(ParentReport.EndPages.Count);
    s := s + ',';
    i := 1; j := 1; n1 := 1;
    IsRange := False;
    while i <= Length(s) do
    begin
      if s[i] = ',' then
      begin
        n2 := StrToInt(Copy(s, j, i - j));
        j := i + 1;
        if IsRange then
        begin
          while n1 <= n2 do
          begin
            FpgList.Add(IntToStr(n1));
            Inc(n1);
          end;
        end
        else
          FpgList.Add(IntToStr(n2));
        IsRange := False;
      end
      else if s[i] = '-' then
      begin
        IsRange := True;
        n1 := StrToInt(Copy(s, j, i - j));
        j := i + 1;
      end;
      Inc(i);
    end;
  end;

begin
  ParentReport.Terminated := False;
  FOldAfterExport := OnAfterExport;
  OnAfterExport := DoAfterExport;
  inherited OnBeginDoc;
  FrStart := 0;
  FCurPageNo := 0;
  FTotalPages := 0;
  try
    FpgList := TStringList.Create;
    _ParsePageNumbers;

    FCols := TList.Create;
    FRows := TList.Create;

    FWorkBook := TwawXLSWorkbook.Create; //By waw
    FWorkBook.Clear;
  except
  end;
end;

procedure TRMXLSExport.OnEndDoc;
begin
  _ClearColsAndRows;
  FCols.Free;
  FRows.Free;
  FpgList.Free;
  inherited OnEndDoc;
end;

procedure TRMXLSExport.OnBeginPage;
begin
  inherited OnBeginPage;
end;

procedure TRMXLSExport.InternalOnePage(aPage: TRMEndPage);
var
  i, k: Integer;
  lDataRec, lDataRec1: TRMEFDataRec;
  lItem: pXLSExport;
  pe: TList;
  pr, r: TRow;
  lRange: TwawXLSRange; //by waw
  lSheet: TwawXLSWorkSheet; //waw
  lFlag: Boolean;
  lOffset: Integer;

  function _CEP(v1, v2: integer): boolean;
  begin
    Result := Abs(v1 - v2) <= FExportPrecision;
  end;

  procedure _ExportPicture; //by Waw
  var
    lPicture: TPicture;
  begin
    if not ExportImages then Exit;

    lPicture := TPicture.Create;
    try
      SaveBitmapToPicture(lDataRec.Bitmap, ExportImageFormat{$IFDEF JPEG}, JPEGQuality{$ENDIF}, lPicture);
      lSheet.AddImage(lItem^.LeftCol.Index + 1, lItem^.TopRow.Index + 1,
        lItem^.RightCol.Index + 1, lItem^.BottomRow.Index + 1, lPicture, true);

      FreeAndNil(lDataRec.Bitmap);
    finally
      lPicture.Free;
    end;
  end;

  procedure _ExportText; //by waw
  var
    i, lCount: Integer;
    lText: string;

    procedure _SetXLSBorders;

      procedure _SetXLSBorder(bi: cardinal; b: TRMFrameLine);
      var
        bt: TwawXLSBorderType;
      begin
        bt := TwawXLSBorderType(nil);
        if not b.Visible then exit;
        case bi of
          xlEdgeLeft: bt := wawxlEdgeLeft;
          xlEdgeTop: bt := wawxlEdgeTop;
          xlEdgeRight: bt := wawxlEdgeRight;
          xlEdgeBottom: bt := wawxlEdgeBottom;
        end;
        case TPenStyle(b.Style) of
          psSolid: lRange.Borders[bt].LineStyle := wawlsThin;
          psDash: lRange.Borders[bt].LineStyle := wawlsDashed;
          psDot: lRange.Borders[bt].LineStyle := wawlsDotted;
          psDashDot: lRange.Borders[bt].LineStyle := wawlsDashDot;
          psDashDotDot: lRange.Borders[bt].LineStyle := wawlsDashDotDot;
          psClear: lRange.Borders[bt].LineStyle := wawlsNone;
          psInsideFrame: lRange.Borders[bt].LineStyle := wawlsNone;
        end;
        lRange.Borders[bt].Color := b.Color;
        lRange.Borders[bt].Weight := wawxlThin;
      end;

    begin
      if ExportFrames then
      begin
        _SetXLSBorder(xlEdgeLeft, lDataRec.Obj.LeftFrame);
        _SetXLSBorder(xlEdgeTop, lDataRec.Obj.TopFrame);
        _SetXLSBorder(xlEdgeRight, lDataRec.Obj.RightFrame);
        _SetXLSBorder(xlEdgeBottom, lDataRec.Obj.BottomFrame);
      end;
    end;

  begin
    lRange := lSheet.Ranges[lItem^.LeftCol.Index + 1, lItem^.TopRow.Index + 1,
      lItem^.RightCol.Index, lItem^.BottomRow.Index];
    if lDataRec.BmpWidth > 0 then
    begin
      lRange.Value := ' ';
      Exit;
    end;

    lCount := lDataRec.Obj.Memo.Count;
    lText := '';
    for i := 0 to lCount - 1 do
    begin
      if i <> 0 then
        lText := lText + #13#10;
      lText := lText + lDataRec.Obj.Memo[i];
    end;

    lText := RMReplaceString(lText, #1, '');
    if (lText = '') or (lText = #13#10) then
    begin
      lRange.Value := ' ';
      lRange.WrapText := False;
    end
    else
    begin
      if (Copy(lText, Length(lText) - 1, 2) = #13#10) then
        lText := Copy(lText, 1, Length(lText) - 2);
      lText := StringReplace(lText, 'm~2|', #$A9#$4F, [rfReplaceAll]);
      lRange.Value := lText;
      if THackMemoView(lDataRec.Obj).ExportAsNumber then
      begin
      	try
	        lRange.Value := VarAsType(lText, varDouble);
        except
        end;  
      end;

      if ((Pos(#13#10, lText) > 0) or (Pos(#10, lText) > 0)) then
        lRange.WrapText := True
      else
        lRange.WrapText := False;
    end;

    lRange.Font.Assign(TRMCustomMemoView(lDataRec.Obj).Font);
    _SetXLSBorders;

    if (lDataRec.Obj.FillColor <> clNone) and (lDataRec.Obj.FillColor <> clWhite) then
    begin
      lRange.ForegroundFillPatternColor := lDataRec.Obj.FillColor;
      lRange.BackgroundFillPatternColor := clWhite;
      lRange.FillPattern := wawfpSolid;
    end;

    case THackMemoView(lDataRec.Obj).RotationType of //waw Add
      rmrt90:
        lRange.Rotation := 90; //Rotation +90
      rmrt270:
        lRange.Rotation := 180; //Rotation -90
    else
      lRange.Rotation := 0; //Excel Rotation Range Is -90...+90
    end;

    case THackMemoView(lDataRec.Obj).VAlign of
      rmvBottom:
        lRange.VerticalAlignment := wawxlVAlignBottom;
      rmvCenter:
        lRange.VerticalAlignment := wawxlVAlignCenter;
      rmvTop:
        lRange.VerticalAlignment := wawxlVAlignTop;
    else
      lRange.VerticalAlignment := wawxlVAlignJustify;
    end;

    case THackMemoView(lDataRec.Obj).HAlign of
      rmhLeft:
        lRange.HorizontalAlignment := wawxlHAlignLeft;
      rmhCenter:
        lRange.HorizontalAlignment := wawxlHAlignCenter;
      rmhRight:
        lRange.HorizontalAlignment := wawxlHAlignRight;
    else
      lRange.HorizontalAlignment := wawxlHAlignJustify;
    end;
  end;

begin
  if (FpgList.Count <> 0) and (FpgList.IndexOf(IntToStr(FPageNo + 1)) < 0) then
  begin
    inherited;   //waw 03-07-27
    Exit;
  end;

  pe := TList.Create;
  for i := 0 to FDataList.Count - 1 do
  begin
    New(lItem);
    pe.Add(lItem);
  end;

  try
    for i := 0 to FDataList.Count - 1 do
    begin
      Application.ProcessMessages;
      lDataRec := FDataList[i];
      lItem := pXLSExport(pe[i]);

      k := 0;
      while (k < FCols.Count) and not _CEP(TCol(FCols[k]).X, lDataRec.Left) do Inc(k);
      if k >= FCols.Count then
        lItem^.LeftCol := TCol(FCols[FCols.Add(TCol.CreateCol(lDataRec.Left))])
      else
        lItem^.LeftCol := TCol(FCols[k]);

      k := 0;
      while (k < FCols.Count) and not _CEP(TCol(FCols[k]).X, lDataRec.Left + lDataRec.Width) do Inc(k);
      if k >= FCols.Count then
        lItem^.RightCol := TCol(FCols[FCols.Add(TCol.CreateCol(lDataRec.Left + lDataRec.Width))])
      else
        lItem^.RightCol := TCol(FCols[k]);

      k := 0;
      while (k < FRows.Count) and not _CEP(TRow(FRows[k]).Y, lDataRec.Top) do Inc(k);
      if k >= FRows.Count then
        lItem^.TopRow := TRow(FRows[FRows.Add(TRow.CreateRow(lDataRec.Top, FPageNo))])
      else
        lItem^.TopRow := TRow(FRows[k]);
      k := 0;
      while (k < FRows.Count) and not _CEP(TRow(FRows[k]).Y, lDataRec.Top + lDataRec.Height) do Inc(k);
      if k >= FRows.Count then
        lItem^.BottomRow := TRow(FRows[FRows.Add(TRow.CreateRow(lDataRec.Top + lDataRec.Height, FPageNo))])
      else
        lItem^.BottomRow := TRow(FRows[k]);
    end;

    FCols.Sort(SortCols);
    FRows.Sort(SortRows);

    if (FCols.Count > 0) and (TCol(FCols[0]).X < 0) then
    begin
      lOffset := -TCol(FCols[0]).X;
      for i := 0 to FCols.Count - 1 do // ����cell���
      begin
        TCol(FCols[i]).X := TCol(FCols[i]).X + lOffset;
      end;
    end;

    if FCurPageNo = 0 then         //by waw
    begin
      lSheet := FWorkBook.AddSheet; //by waw
      if (aPage.PageSize < 256) and (aPage.PageSize < Integer(wawxlPaperA3ExtraTransverse)) then
      begin
        lSheet.PageSetup.PaperSize := TwawXLSPaperSizeType(aPage.PageSize);
        lSheet.PageSetup.FitToPagesWide := 1;
        lSheet.PageSetup.FitToPagesTall := 1;
      end;
      if aPage.PageOrientation = rmpoPortrait then
        lSheet.PageSetup.Orientation := wawxlPortrait
      else
        lSheet.PageSetup.Orientation := wawxlLandscape;
      lSheet.PageSetup.LeftMargin := (Round(RMFromScreenPixels(aPage.spMarginLeft, rmutInches) * 100) / 100) - 0.18;
      lSheet.PageSetup.TopMargin := Round(RMFromScreenPixels(aPage.spMarginTop, rmutInches) * 100) / 100;
      lSheet.PageSetup.RightMargin := (Round(RMFromScreenPixels(aPage.spMarginRight, rmutInches) * 100) / 100) - 0.18;
      lSheet.PageSetup.BottomMargin := Round(RMFromScreenPixels(aPage.spMarginBottom, rmutInches) * 100) / 100;
      lSheet.PageSetup.HeaderMargin := 0.0;
      lSheet.PageSetup.FooterMargin := 0.0;
      Inc(FTotalPages);                                      //waw
      lSheet.Title := Format('Sheet%d', [FTotalPages]);      //waw

      for i := 0 to FCols.Count - 1 do // ����cell���
      begin
        if i = 0 then
          lSheet.Cols[i].InchWidth := Round(RMFromScreenPixels(TCol(FCols[i]).X, rmutInches) * 100) / 100
        else
          lSheet.Cols[i].InchWidth := Round(RMFromScreenPixels(TCol(FCols[i]).X - TCol(FCols[i - 1]).X -2, rmutInches) * 100) / 100;
      end;
    end
    else
      lSheet := FWorkBook.Sheets[FTotalPages -1];

    for i := 0 to FCols.Count - 1 do // ���� Colnum ���
    begin
      TCol(FCols[i]).Index := i;
    end;

    for i := 0 to FRows.Count - 1 do // ����cell�߶�
    begin
      TRow(FRows[i]).Index := FrStart + i; // ���� Row ���
      r := TRow(FRows[i]);
      if i = 0 then
        lSheet.Rows[TRow(FRows[i]).Index].InchHeight := Round(RMFromScreenPixels(r.Y, rmutInches) * 100) / 100   //waw
      else
      begin
        pr := TRow(FRows[i - 1]);
        if r.PageIndex = pr.PageIndex then
          lSheet.Rows[TRow(FRows[i]).Index].InchHeight := Round(RMFromScreenPixels(r.Y - pr.Y, rmutInches) * 100) / 100  //waw
        else
          lSheet.Rows[TRow(FRows[i]).Index].InchHeight := Round(RMFromScreenPixels(r.Y, rmutInches) * 100) / 100;        //waw
      end;
    end;

    Inc(FCurPageNo);                     //waw
    if FCurPageNo >= FPagesOfSheet then  //waw
    begin
      FCurPageNo := 0;                   //waw
      FrStart := 0;
    end
    else
    begin
      FrStart := FrStart + FRows.Count;
      lSheet.AddPageBreakAfterRow(FrStart);
    end;

    for i := 0 to FDataList.Count - 1 do
    begin
      Application.ProcessMessages;
      lDataRec := FDataList[i];
      lItem := pXLSExport(pe[i]);
      lFlag := True;
      for k := i + 1 to FDataList.Count - 1 do
      begin
        Application.ProcessMessages;
        lDataRec1 := FDataList[k];
        if (lDataRec1.Left >= lDataRec.Left) and (lDataRec1.Top >= lDataRec.Top) and
          (lDataRec1.Left + lDataRec1.Width <= lDataRec.Left + lDataRec.Width) and
          (lDataRec1.Top + lDataRec1.Height <= lDataRec.Top + lDataRec.Height) then
        begin
          lFlag := False;
          Break;
        end;
      end;

      if lFlag then
      begin
        case lDataRec.ObjType of
          rmotMemo: _ExportText;
          rmotPicture: _ExportPicture;
        end;  
      end;
    end;
  finally
    while pe.Count > 0 do
    begin
      Dispose(pXLSExport(pe[0]));
      pe.Delete(0);
    end;
    pe.Free;

    _ClearColsAndRows;
    inherited;   //waw 03-07-27
  end;
end;

procedure TRMXLSExport.SaveToFile(const aFileName: string);
var
  Writer: TwawCustomWriter; //By waw
begin
  if FWorkBook = nil then exit;
  if ExtractFileExt(aFileName) = '.xls' then
    Writer := TwawExcelWriter.Create //By waw
  else
    Writer := TwawHTMLWriter.Create; //By waw
  try
    Writer.Save(FWorkBook, aFileName); //By waw
  finally
    Writer.Free; //By waw
  end;
  FWorkBook.Free; //By waw
  FWorkBook := nil;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMXLSExportForm }

procedure TRMXLSExportForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  RMSetStrProp(chkExportImages, 'Caption', rmRes + 1821);
  RMSetStrProp(lblExportImageFormat, 'Caption', rmRes + 1816);
  RMSetStrProp(lblJPEGQuality, 'Caption', rmRes + 1814);
  RMSetStrProp(Label4, 'Caption', rmRes + 1788);

  RMSetStrProp(GroupBox1, 'Caption', rmRes + 044);
  RMSetStrProp(rdbPrintAll, 'Caption', rmRes + 045);
  RMSetStrProp(rbdPrintCurPage, 'Caption', rmRes + 046);
  RMSetStrProp(rbdPrintPages, 'Caption', rmRes + 047);
  RMSetStrProp(Label2, 'Caption', rmRes + 048);
  RMSetStrProp(GroupBox2, 'Caption', rmRes + 379);
  RMSetStrProp(Label1, 'Caption', rmRes + 378);
  RMSetStrProp(chkShowAfterGenerate, 'Caption', rmRes + 380);
//  RMSetStrProp(chkExportFrames, 'Caption', rmRes + 381);  //��ʾ��������
  RMSetStrProp(chkExportFrames, 'Caption', rmRes + 1803); //��������
//  RMSetStrProp(chkMultiSheet, 'Caption', rmRes + 382);   //waw
  RMSetStrProp(Label3, 'Caption', rmRes + 382);            //waw

  RMSetStrProp(Self, 'Caption', rmRes + 1779);
  btnOK.Caption := RMLoadStr(SOk);
  btnCancel.Caption := RMLoadStr(SCancel);
end;

function TRMXLSExportForm.GetExportPages: string;
begin
  Result := '';
  if rbdPrintCurPage.Checked then
    Result := 'CURPAGE'
  else if rbdPrintPages.Checked then
    Result := edtPages.Text;
end;

procedure TRMXLSExportForm.FormCreate(Sender: TObject);
begin
  Localize;
  cmbImageFormat.Items.Clear;
{$IFDEF RXGIF}
  cmbImageFormat.Items.AddObject(ImageFormats[ifGIF], TObject(ifGIF));
{$ENDIF}
{$IFDEF JPEG}
  cmbImageFormat.Items.AddObject(ImageFormats[ifJPG], TObject(ifJPG));
{$ENDIF}
  cmbImageFormat.Items.AddObject(ImageFormats[ifBMP], TObject(ifBMP));
  cmbImageFormat.ItemIndex := 0;
end;

procedure TRMXLSExportForm.btnFileNameClick(Sender: TObject);
begin
  SaveDialog.FileName := edtExportFileName.Text;
  if SaveDialog.Execute then
    edtExportFileName.Text := SaveDialog.FileName;
end;

procedure TRMXLSExportForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and (edtExportFileName.Text = '') then
    CanClose := False;
end;

procedure TRMXLSExportForm.rbdPrintPagesClick(Sender: TObject);
begin
  edtPages.SetFocus;
end;

procedure TRMXLSExportForm.edtPagesEnter(Sender: TObject);
begin
  rbdPrintPages.Checked := True;
end;

procedure TRMXLSExportForm.chkExportFramesClick(Sender: TObject);
begin
  RMSetControlsEnable(gbExportImages, chkExportImages.Checked);
  cmbImageFormatChange(Sender);
end;

procedure TRMXLSExportForm.edJPEGQualityKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TRMXLSExportForm.cmbImageFormatChange(Sender: TObject);
begin
  if chkExportImages.Checked and (cmbImageFormat.Text = ImageFormats[ifJPG]) then
  begin
    lblJPEGQuality.Enabled := True;
    edJPEGQuality.Enabled := True;
    edJPEGQuality.Color := clWindow;
  end
  else
  begin
    lblJPEGQuality.Enabled := False;
    edJPEGQuality.Enabled := False;
    edJPEGQuality.Color := clInactiveBorder;
  end;
end;

initialization

finalization

{$ENDIF}
end.

