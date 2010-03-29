
{******************************************************}
{                                                      }
{          Report Machine v3.0                         }
{            XLS export filter                         }
{                                                      }
{         write by whf and jim_waw(jim_waw@163.com)    }
{******************************************************}

unit RM_e_ComXls;

interface

{$I RM.inc}
{$IFDEF Delphi4}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Forms, StdCtrls, Controls,
  Dialogs, ExtCtrls, Buttons, ComCtrls, ComObj, activex,
  RM_Class, RM_e_main, Excel2000
{$IFDEF RXGIF}, JvGIF{$ENDIF}
{$IFDEF JPEG}, JPeg{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

type

  TRMExcelApplication = TExcelApplication;
  TRMExcelWorkbook = TExcelWorkbook;
  TRMExcelWorksheet = TExcelWorksheet;
  TRMExcelRange = Range;

  { TRMComXLSExport }
  TRMComXLSExport = class(TRMMainExportFilter)
  private
    FFirstPage: Boolean;
    FExportPrecision: Integer;
    FExportPages: string;
    FShowAfterExport: Boolean;
    FMultiSheet: Boolean;
    LCID: Integer;
    KoefX, KoefY: double;

    FOldAfterExport: TRMAfterExportEvent;
    FCols, FRows: TList;
    FrStart: Integer;
    FpgList: TStringList;

    FExcelApplication: TRMExcelApplication;
    FExcelWorkbook: TRMExcelWorkbook;
    FExcelWorksheet: TRMExcelWorksheet;

    procedure _ClearColsAndRows;
    procedure DoAfterExport(const FileName: string);
  protected
    procedure InternalOnePage(aPage: TRMEndPage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ShowModal: Word; override;
    procedure OnBeginDoc; override;
    procedure OnEndDoc; override;
    procedure OnBeginPage; override;
//    procedure OnEndPage; override;
  published
    property ExportPages: string read FExportPages write FExportPages;
    property PixelFormat;
    property ShowAfterExport: Boolean read FShowAfterExport write FShowAfterExport;
    property MultiSheet: Boolean read FMultiSheet write FMultiSheet;
    property ExportPrecision: Integer read FExportPrecision write FExportPrecision;
  end;

  { TRMCSVExportForm }
  TRMComXLSExportForm = class(TForm)
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
    chkMultiSheet: TCheckBox;
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
uses Math, RM_Common, RM_Const, RM_Const1, RM_Utils;

{$R *.DFM}

const
  MAX_EXCEL_ROW_HEIGHT = 409;
  MAX_EXCEL_COLUMN_WIDTH = 255;

  XLS_EXPORT_LOGPIXELSX = 108;
  XLS_EXPORT_LOGPIXELSY = 96;

{------------------------------------------------------------------------------}
{TRMComXLSExport}

constructor TRMComXLSExport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RMRegisterExportFilter(Self, 'Export To xls use Com' + ' (*.xls)', '*.xls');

  ShowDialog := True;
  CreateFile := False;
  FExportPrecision := 1;
  ExportImages := True;
  ExportFrames := True;
  MultiSheet := True; //waw 03-07-26
  FShowAfterExport := True;
  FExportImageFormat := ifBMP;
  FIsXLSExport := True;
  CanMangeRotationText := True;
end;

destructor TRMComXLSExport.Destroy;
begin
  RMUnRegisterExportFilter(Self);
  inherited Destroy;
end;

procedure TRMComXLSExport.DoAfterExport(const FileName: string);
begin //by waw
  if Assigned(FOldAfterExport) then FOldAfterExport(FileName);
  OnAfterExport := FOldAfterExport;
end;

function TRMComXLSExport.ShowModal: Word;
begin
  if not ShowDialog then
    Result := mrOk
  else
  begin
    with TRMComXLSExportForm.Create(nil) do
    begin
      edtExportFileName.Text := Self.FileName;
      btnFileName.Enabled := edtExportFileName.Enabled;

      chkExportFrames.Checked := ExportFrames;
      chkShowAfterGenerate.Checked := Self.ShowAfterExport;
      chkMultiSheet.Checked := Self.MultiSheet;

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
        Self.MultiSheet := chkMultiSheet.Checked;

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

procedure TRMComXLSExport._ClearColsAndRows;
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

procedure TRMComXLSExport.OnBeginDoc;

  procedure _ParsePageNumbers; //确定需要打印的页
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
  FFirstPage := True;
  try
    FpgList := TStringList.Create;
    _ParsePageNumbers;

    FCols := TList.Create;
    FRows := TList.Create;

    FExcelApplication := TRMExcelApplication.Create(nil);
    FExcelWorkbook := TRMExcelWorkbook.Create(nil);
    FExcelWorkSheet := TRMExcelWorksheet.Create(nil);

    FExcelApplication.Visible[0] := True;
    FExcelApplication.DisplayAlerts[0] := False;
    FExcelApplication.Connect;

    LCID := LOCALE_USER_DEFAULT;
    LCID := GetUserDefaultLCID();

    FExcelApplication.WorkBooks.Add(EmptyParam, LCID);
    FExcelWorkbook.ConnectTo(FExcelApplication.Workbooks[1]);

    while FExcelWorkbook.Sheets.Count > 1 do
    begin
      FExcelWorkSheet.ConnectTo(FExcelWorkBook.Sheets[FExcelWorkbook.Sheets.Count] as _WorkSheet);
      FExcelWorkSheet.Delete;
    end;
    FExcelWorkSheet.ConnectTo(FExcelWorkBook.Sheets[1] as _WorkSheet);

    KoefX := 1;
    KoefY := 1;
//    KoefX := FExcelApplication.InchesToPoints(1) * FExcelWorksheet.Columns[1].ColumnWidth / XLS_EXPORT_LOGPIXELSX / FExcelWorksheet.Columns[1].Width;
//    KoefY := FExcelApplication.InchesToPoints(1) * FExcelWorksheet.Rows[1].RowHeight / XLS_EXPORT_LOGPIXELSY / FExcelWorksheet.Rows[1].Height;
  except
  end;
end;

procedure TRMComXLSExport.OnEndDoc;
begin
  try
    FExcelWorkBook.SaveCopyAs(Self.FileName); // 关闭并保存
//    FExcelWorkbook.Close(True, Self.FileName, EmptyParam, lCID); // 关闭并保存

    FExcelWorksheet.Disconnect;
    FExcelWorkbook.Disconnect;
    FExcelApplication.Disconnect;
//    FExcelApplication.Quit;
  finally
    _ClearColsAndRows;
    FCols.Free;
    FRows.Free;
    FpgList.Free;

    FreeAndNil(FExcelWorkSheet);
    FreeAndNil(FExcelWorkBook);
    FreeAndNil(FExcelApplication);

    inherited OnEndDoc;
  end;
end;

procedure TRMComXLSExport.OnBeginPage;
begin
  inherited OnBeginPage;
end;

procedure TRMComXLSExport.InternalOnePage(aPage: TRMEndPage);
var
  i, k: Integer;
  lDataRec, lDataRec1: TRMEFDataRec;
  lItem: pXLSExport;
  pe: TList;
  pr, r: TRow;
  lFlag: Boolean;
  lRange: TRMExcelRange;

  function _CEP(v1, v2: integer): boolean;
  begin
    Result := Abs(v1 - v2) <= FExportPrecision;
  end;

  procedure _ExportPicture; //by Waw
  var
    lTempDir: array[0..1024] of char;
    lTempFile: array[0..1024] of char;
    s: string;
    lPicture: TPicture;
  begin
    if not ExportImages then Exit;

    if GetTempPath(sizeof(lTempDir), lTempDir) = 0 then Exit;
    if GetTempFileName(lTempDir, 'rm_', 0, lTempFile) = 0 then Exit;

    lPicture := TPicture.Create;
    s := StrPas(lTempFile);
    try
      SaveBitmapToPicture(lDataRec.Bitmap, ExportImageFormat{$IFDEF JPEG}, JPEGQuality{$ENDIF}, lPicture);
      lPicture.SaveToFile(s);
      FExcelWorksheet.Shapes.AddPicture(s, 0, 1, lRange.Left, lRange.Top,
        lRange.Width, lRange.Height);
    finally
      DeleteFile(PChar(s));
      lPicture.Free;
    end;
  end;

  procedure _ExportText; //by waw
  var
    i, lCount: Integer;
    lText: string;

    procedure _SetXLSBorders;

      procedure _SetXLSBorder(bi: cardinal; b: TRMFrameLine);
      begin
        if not b.Visible then Exit;

        lRange.Borders[bi].Color := b.Color;
        case b.Style of
          psSolid: lRange.Borders[bi].LineStyle := xlContinuous;
          psDash: lRange.Borders[bi].LineStyle := xlDash;
          psDot: lRange.Borders[bi].LineStyle := xlDot;
          psDashDot: lRange.Borders[bi].LineStyle := xlDashDot;
          psDashDotDot: lRange.Borders[bi].LineStyle := xlDashDotDot;
          psClear: lRange.Borders[bi].LineStyle := xlLineStyleNone;
          psInsideFrame: lRange.Borders[bi].LineStyle := xlLineStyleNone;
        else
          lRange.Borders[bi].LineStyle := xlContinuous;
        end;

        lRange.Borders[bi].Weight := xlThin;
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
        lRange.Value := VarAsType(lText, varDouble);

      if ((Pos(#13#10, lText) > 0) or (Pos(#10, lText) > 0)) then
        lRange.WrapText := True
      else
        lRange.WrapText := False;
    end;

    lRange.Font.Color := TRMCustomMemoView(lDataRec.Obj).Font.Color;
    lRange.Font.Name := TRMCustomMemoView(lDataRec.Obj).Font.Name;
    lRange.Font.Size := TRMCustomMemoView(lDataRec.Obj).Font.Size;
    lRange.Font.Bold := fsBold in TRMCustomMemoView(lDataRec.Obj).Font.Style;
    lRange.Font.Italic := fsItalic in TRMCustomMemoView(lDataRec.Obj).Font.Style;
    lRange.Font.Underline := fsUnderline in TRMCustomMemoView(lDataRec.Obj).Font.Style;
    lRange.Font.Strikethrough := fsStrikeOut in TRMCustomMemoView(lDataRec.Obj).Font.Style;
    _SetXLSBorders;

    if (lDataRec.Obj.FillColor <> clNone) and (lDataRec.Obj.FillColor <> clWhite) then
    begin
    end;

    case THackMemoView(lDataRec.Obj).VAlign of
      rmvBottom:
        lRange.VerticalAlignment := xlVAlignBottom;
      rmvCenter:
        lRange.VerticalAlignment := xlVAlignCenter;
      rmvTop:
        lRange.VerticalAlignment := xlVAlignTop;
    else
      lRange.VerticalAlignment := xlVAlignJustify;
    end;

    case THackMemoView(lDataRec.Obj).HAlign of
      rmhLeft:
        lRange.HorizontalAlignment := xlHAlignLeft;
      rmhCenter:
        lRange.HorizontalAlignment := xlHAlignCenter;
      rmhRight:
        lRange.HorizontalAlignment := xlHAlignRight;
    else
      lRange.HorizontalAlignment := xlHAlignJustify;
    end;
  end;

begin
  if (FpgList.Count <> 0) and (FpgList.IndexOf(IntToStr(FPageNo + 1)) < 0) then
  begin
    inherited; //waw 03-07-27
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

    if MultiSheet then
    begin
    end
    else // 增加一页
    begin
    end;

    for i := 0 to FCols.Count - 1 do // 设置 Colnum 序号
    begin
      TCol(FCols[i]).Index := i;
    end;

    for i := 0 to FCols.Count - 1 do // 设置cell宽度
    begin
      if i = 0 then
        FExcelWorksheet.Cells.Item[EmptyParam, i + 1].ColumnWidth :=  Min(MAX_EXCEL_COLUMN_WIDTH, KoefX * TCol(FCols[i]).X) / 8
      else
        FExcelWorksheet.Cells.Item[EmptyParam, i + 1].ColumnWidth :=  Min(MAX_EXCEL_COLUMN_WIDTH, KoefX * (TCol(FCols[i]).X - TCol(FCols[i - 1]).X)) / 8;
    end;

    for i := 0 to FRows.Count - 1 do // 设置cell高度
    begin
      TRow(FRows[i]).Index := FrStart + i; // 设置 Row 序号
      r := TRow(FRows[i]);
      if i = 0 then
        FExcelWorksheet.Rows.Item[i + 1, EmptyParam].RowHeight := Min(MAX_EXCEL_ROW_HEIGHT, KoefY * r.Y) / 1.25
      else
      begin
        pr := TRow(FRows[i - 1]);
        if r.PageIndex = pr.PageIndex then
          FExcelWorksheet.Rows.Item[i + 1, EmptyParam].RowHeight := Min(MAX_EXCEL_ROW_HEIGHT, KoefY * (r.Y - pr.Y)) / 1.25
        else
        begin
          FExcelWorksheet.Rows.Item[i + 1, EmptyParam].RowHeight := Min(MAX_EXCEL_ROW_HEIGHT, KoefY * r.Y) / 1.25;
          FExcelWorksheet.Rows.Item[i + 1, EmptyParam].PageBreak := True;
        end;
      end;
    end;

    if FMultiSheet then
      FrStart := 0
    else
    begin
      FrStart := FrStart + FRows.Count;
      FExcelWorkSheet.HPageBreaks.Add(FExcelWorkSheet.Cells.Item[FrStart + 1, 1]);
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
        lRange := FExcelWorkSheet.Range[FExcelWorkSheet.Cells.Item[lItem^.LeftCol.Index + 2, lItem^.TopRow.Index + 2],
          FExcelWorkSheet.Cells.Item[lItem^.RightCol.Index + 1, lItem^.BottomRow.Index + 1]];
        lRange.MergeCells := True;
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
    FFirstPage := False;
    inherited; //waw 03-07-27
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMXLSExportForm }

procedure TRMComXLSExportForm.Localize;
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
//  RMSetStrProp(chkExportFrames, 'Caption', rmRes + 381);  //显示导出过程
  RMSetStrProp(chkExportFrames, 'Caption', rmRes + 1803); //导出框线
  RMSetStrProp(chkMultiSheet, 'Caption', rmRes + 382);

  RMSetStrProp(Self, 'Caption', rmRes + 1779);
  btnOK.Caption := RMLoadStr(SOk);
  btnCancel.Caption := RMLoadStr(SCancel);
end;

function TRMComXLSExportForm.GetExportPages: string;
begin
  Result := '';
  if rbdPrintCurPage.Checked then
    Result := 'CURPAGE'
  else if rbdPrintPages.Checked then
    Result := edtPages.Text;
end;

procedure TRMComXLSExportForm.FormCreate(Sender: TObject);
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

procedure TRMComXLSExportForm.btnFileNameClick(Sender: TObject);
begin
  SaveDialog.FileName := edtExportFileName.Text;
  if SaveDialog.Execute then
    edtExportFileName.Text := SaveDialog.FileName;
end;

procedure TRMComXLSExportForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and (edtExportFileName.Text = '') then
    CanClose := False;
end;

procedure TRMComXLSExportForm.rbdPrintPagesClick(Sender: TObject);
begin
  edtPages.SetFocus;
end;

procedure TRMComXLSExportForm.edtPagesEnter(Sender: TObject);
begin
  rbdPrintPages.Checked := True;
end;

procedure TRMComXLSExportForm.chkExportFramesClick(Sender: TObject);
begin
  RMSetControlsEnable(gbExportImages, chkExportImages.Checked);
  cmbImageFormatChange(Sender);
end;

procedure TRMComXLSExportForm.edJPEGQualityKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TRMComXLSExportForm.cmbImageFormatChange(Sender: TObject);
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

