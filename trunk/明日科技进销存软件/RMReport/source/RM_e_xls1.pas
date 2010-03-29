
{*****************************************}
{                                         }
{          Report Machine v2.0            }
{            XLS export filter            }
{                                         }
{*****************************************}

unit RM_e_xls1;

interface

{$I RM.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Forms, StdCtrls, Controls,
  Dialogs, ExtCtrls, Buttons, ComCtrls, ComObj, ShellApi,
  RM_Common, RM_Class, RM_e_main,
  XLSReadWriteII, BIFFRecsII //szc
{$IFDEF RXGIF}, JvGIF{$ENDIF}
{$IFDEF JPEG}, JPeg{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

type
  RMEXCELCELL = ^TRMEXCELCELL;
  TRMEXCELCELL = record
    row: integer;
    col: integer;
    fdatalistindex: integer;
    rowindex: integer;
    colindex: integer;
  end;

  { TRMXlsExport1 }
  TRMXlsExport1 = class(TRMMainExportFilter)
  private
    FExportPages: string;
    FExportFileName: string;
    Fsheet: tlist;
    FCols, FRows: TList;
    Fpagemaxrowindex: array of integer;
    FShowAfterExport: Boolean;
    FMultiSheet: Boolean;

    FOldAfterExport: TRMAfterExportEvent;
    FExcel: txlsreadwriteii;

    procedure DoAfterExport(const aFileName: string);
  protected
    procedure InternalOnePage(aPage: TRMEndPage); override;
  public
    constructor Create(AOwner: TComponent); override;
    function ShowModal: Word; override;
    procedure OnBeginDoc; override;
    procedure OnEndDoc; override;
    procedure OnBeginPage; override;
  published
    property ExportPages: string read FExportPages write FExportPages;
    property ExportFileName: string read FExportFileName write FExportFileName;
    property MultiSheet: Boolean read FMultiSheet write FMultiSheet;
    property ShowAfterExport: Boolean read FShowAfterExport write FShowAfterExport;
    property PixelFormat;
  end;

  { TRMCSVExportForm }
  TRMXLSExport1Form = class(TForm)
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
    gbExportImages: TGroupBox;
    lblExportImageFormat: TLabel;
    lblJPEGQuality: TLabel;
    cmbImageFormat: TComboBox;
    edJPEGQuality: TEdit;
    UpDown1: TUpDown;
    Label4: TLabel;
    cmbPixelFormat: TComboBox;
    GroupBox2: TGroupBox;
    chkShowAfterGenerate: TCheckBox;
    chkMultiSheet: TCheckBox;
    chkExportFrames: TCheckBox;
    chkExportImages: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnFileNameClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure rbdPrintPagesClick(Sender: TObject);
    procedure edtPagesEnter(Sender: TObject);
    procedure chkExportImagesClick(Sender: TObject);
    procedure cmbImageFormatChange(Sender: TObject);
    procedure edJPEGQualityKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure Localize;
    function GetExportPages: string;
  public
    { Public declarations }
  end;

implementation

uses Math, RM_Const, RM_Const1, RM_Utils;

{$R *.DFM}

const
  XLSscalewidth = 35;
  XLSscaleheight = 13;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMXlsExport1 }

constructor TRMXlsExport1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RMRegisterExportFilter(Self, RMLoadStr(SCSVFile) + ' (*.xls)', '*.xls');

  ShowDialog := True;
  CreateFile := False;
  ExportImages := True;
  ExportFrames := True;
  MultiSheet := True; //waw 03-07-26
  FShowAfterExport := True;
  FExportImageFormat := ifBMP;
  FIsXLSExport := True;
end;

function TRMXlsExport1.ShowModal: Word;
begin
  if not ShowDialog then
    Result := mrOk
  else
  begin
    with TRMXLSExport1Form.Create(nil) do
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
      chkExportImagesClick(Self);

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

procedure TRMXlsExport1.OnBeginDoc;
begin
  FOldAfterExport := OnAfterExport;
  OnAfterExport := DoAfterExport;

  FCols := TList.Create;
  FRows := TList.Create;
  Fsheet := TList.Create;

  FExcel := txlsreadwriteii.Create(nil);
  SetLength(Fpagemaxrowindex, pagecount);

  inherited OnBeginDoc;
end;

procedure TRMXlsExport1.OnEndDoc;
begin
  FCols.free;
  FRows.free;
  Fsheet.free;
  inherited OnEndDoc;
end;

procedure TRMXlsExport1.DoAfterExport(const aFileName: string);
begin
  try
    FExcel.Filename := aFileName;
    FExcel.Write;
  finally
    FExcel.Free;
    if FShowAfterExport then //by waw
      ShellExecute(0, 'open', PChar(FileName), '', '', SW_SHOWNORMAL);

    if Assigned(FOldAfterExport) then FOldAfterExport(FileName);
    OnAfterExport := FOldAfterExport;
  end;
end;

procedure TRMXlsExport1.OnBeginPage;
begin
  inherited OnBeginPage;
end;

procedure TRMXlsExport1.InternalOnePage(aPage: TRMEndPage); ///主力程序
var
  lDataRec, lDataRec1: TRMEFDataRec;
  i, x, y, li_col, li_row, index: integer;
  ECELL1, ECELL2, ECELL3: RMEXCELCELL;
  fpicture: tpicture;

  function getrowcount: integer;
  var
    i: integer;
  begin
    result := 0;
    for i := 1 to FPageNo do begin
      result := result + Fpagemaxrowindex[i - 1];
    end;
    if FPageNo <> 0 then
      result := result + 1
  end;

{  procedure setrowcol(lDataRec: TRMEFDataRec; i: integer; ECELL: RMEXCELCELL);
  begin

  end;
}
  procedure sortcol(fcols: tlist; FExcel: txlsreadwriteii);
  var
    i, i2, index: integer;
  begin
    x := 0;
    for i := 0 to fcols.Count - 1 do begin
      x := RMEXCELCELL(fcols.Items[i]).col;
      index := -1;
      for i2 := i + 1 to fcols.count - 1 do begin
        if x > RMEXCELCELL(fcols.Items[i2]).col then begin
          x := RMEXCELCELL(fcols.Items[i2]).col;
          index := i2;
        end;
      end;
      if index <> -1 then begin
        fcols.Exchange(i, index);
      end;
      if i = 0 then begin
        RMEXCELCELL(fcols.Items[i]).colindex := 0;
      end else begin
        if RMEXCELCELL(fcols.Items[i]).col = RMEXCELCELL(fcols.Items[i - 1]).col then begin
          RMEXCELCELL(fcols.Items[i]).colindex := RMEXCELCELL(fcols.Items[i - 1]).colindex;
        end else begin
          RMEXCELCELL(fcols.Items[i]).colindex := RMEXCELCELL(fcols.Items[i - 1]).colindex + 1;
        end;
      end;
        ///设置列宽
      with FExcel.Sheets[0].ColumnFormats.add do
      begin
        col1 := RMEXCELCELL(fcols.Items[i]).colindex;
        col2 := RMEXCELCELL(fcols.Items[i]).colindex;
//        width := TRMEFDataRec(fdatalist.Items[RMEXCELCELL(fcols.Items[i]).fdatalistindex]).dx * XLSscalewidth;
      end;
    end;
  end;

  procedure sortrow(frows: tlist; FExcel: txlsreadwriteii);
  var
    i, i2, index: integer;
  begin
    x := 0;
    for i := 0 to frows.Count - 1 do
    begin
      x := RMEXCELCELL(frows.Items[i]).row;
      index := -1;
      for i2 := i + 1 to frows.count - 1 do
      begin
        if x > RMEXCELCELL(frows.Items[i2]).row then
        begin
          x := RMEXCELCELL(frows.Items[i2]).row;
          index := i2;
        end;
      end;

      if index <> -1 then
        frows.Exchange(i, index);
      if i = 0 then
      begin
        RMEXCELCELL(frows.Items[i]).rowindex := 0;
      end
      else
      begin
        if RMEXCELCELL(frows.Items[i]).row = RMEXCELCELL(frows.Items[i - 1]).row then
        begin
          RMEXCELCELL(frows.Items[i]).rowindex := RMEXCELCELL(frows.Items[i - 1]).rowindex;
        end
        else
        begin
          RMEXCELCELL(frows.Items[i]).rowindex := RMEXCELCELL(frows.Items[i - 1]).rowindex + 1;
        end;
      end;
        ///设置行高
      if FPageNo = 0 then
      begin
        FExcel.Sheets[0].RowHeights[RMEXCELCELL(frows.Items[i]).rowindex] := TRMEFDataRec(fdatalist.Items[RMEXCELCELL(frows.Items[i]).fdatalistindex]).Width * XLSscaleheight;
      end
      else
      begin
        FExcel.Sheets[0].RowHeights[RMEXCELCELL(frows.Items[i]).rowindex + getrowcount] := TRMEFDataRec(fdatalist.Items[RMEXCELCELL(frows.Items[i]).fdatalistindex]).Height * XLSscaleheight;
      end;
    end;
      //记录行数
    i2 := RMEXCELCELL(frows.Items[frows.count - 1]).rowindex;
    Fpagemaxrowindex[FPageNo] := RMEXCELCELL(frows.Items[frows.count - 1]).rowindex;
  end;

  function getrowindex(frows: tlist; index: integer): integer;
  var
    i: integer;
  begin
    for i := 0 to frows.Count - 1 do
    begin
      if index = RMEXCELCELL(frows.Items[i]).fdatalistindex then
      begin
        result := RMEXCELCELL(frows.Items[i]).rowindex;
        exit;
      end;
    end;
  end;

  function getrowvalue(frows: tlist; index: integer): integer;
  var
    i: integer;
  begin
    for i := 0 to frows.Count - 1 do
    begin
      if index = RMEXCELCELL(frows.Items[i]).fdatalistindex then
      begin
        result := RMEXCELCELL(frows.Items[i]).row;
        exit;
      end;
    end;
  end;

  procedure setpicwidth(Pic: TPicture; NewWidth, NewHeight: Integer); //根据产品编号获取图片
  var
    PicW, PicH: Integer;
    rz, Rz1, rz2: Double;
    Bmp1, Bmp2: TBitMap;
  begin
    if NewWidth * NewHeight > 0 then
    begin
      Picw := pic.Width;
      PicH := pic.Height;
      if PicW * Picw = 0 then
      begin
   //      ShowMessage('Width Or Height Is 0');
        exit;
      end;
      Rz1 := NewWidth / Picw;
      Rz2 := NewHeight / Pich;
      Rz := Min(Rz1, Rz2);
      if Rz < 1 then
      begin
        Bmp1 := TBitMap.Create;
        Bmp1.Width := Picw;
        Bmp1.Height := PicH;
        Bmp1.Assign(Pic.Graphic);
        Picw := Trunc(Picw * Rz);
        PicH := Trunc(Pich * Rz);
        Bmp2 := TBitMap.Create;
        Bmp2.Width := Picw;
        Bmp2.Height := Pich;
        Bmp2.Canvas.StretchDraw(Bmp2.Canvas.ClipRect, Bmp1); // 伸展缩小图片
        Pic.Assign(Bmp2);
        Bmp1.Free;
        Bmp2.Free;
      end;
    end;
  end;

  procedure setpic(picpath: string; fpicture: tpicture);
  var
    jpeg: tjpegimage;
    viewform: tform;
    ls_datasetname, ls_fieldname, ls_datafield: string;
    i: integer;
  begin
    if fileexists(picpath) then
    begin
      Jpeg := TJPEGImage.Create();
      jpeg.LoadFromFile(picpath);
      fpicture.Assign(jpeg);
    end;
  end;

  procedure _ExportPicture;
  begin
{    if fileexists(lDataRec.picturename) then
    begin
      fpicture := tpicture.Create;
      setpic(lDataRec.picturename, fpicture); //szcadd
      setpicwidth(fpicture, lDataRec.dx, lDataRec.dy);
//        FExcel.Sheets[0].MergedCells := FExcel.Sheets[0].Cells[1,1,2,2];
      with FExcel.Pictures.Add do
      begin
        Filename := lDataRec.picturename;
        Width := trunc(fpicture.Width / 1.15);
        Height := trunc(16 / 1.15); //fpicture.Height - (lDataRec.dy-20)  ;
        FExcel.Sheets[0].RowHeights[RMEXCELCELL(frows.Items[i]).rowindex] := TRMEFDataRec(fdatalist.Items[RMEXCELCELL(frows.Items[i]).fdatalistindex]).dy * XLSscaleheight;
//          showmessage(inttostr(height));
      end;
      fpicture.free;
      with FExcel.Sheets[0].SheetPictures.add do
      begin
        col := li_col;
        row := li_row;
        PictureName := lDataRec.picturename;
      end;
    end;
}  end;

  procedure _ExportText;
  var
    i, lCount: Integer;
    lText: string;
  begin
    lCount := lDataRec.Obj.Memo.Count;
    lText := '';
    for i := 0 to lCount - 1 do
    begin
      if i <> 0 then
        lText := lText + #13#10;
      lText := lText + lDataRec.Obj.Memo[i];
    end;
    lText := RMReplaceString(lText, #1, '');

    FExcel.Sheets[0].WriteWideString(li_col, li_row, 0, lText);
  end;

begin
  for i := 0 to fdatalist.Count - 1 do
  begin
    new(ECELL1);
    new(ECELL2);
    new(ECELL3);
    ECELL1^.row := 0;
    ECELL1^.col := 0;
    ECELL1^.fdatalistindex := 0;
    ECELL2^.row := 0;
    ECELL2^.col := 0;
    ECELL2^.fdatalistindex := 0;
    ECELL3^.row := 0;
    ECELL3^.col := 0;
    ECELL3^.fdatalistindex := 0;
    Fsheet.Add(ECELL1);
    fcols.Add(ECELL2);
    frows.Add(ECELL3);
  end;

  x := 0; y := 0; index := 0;
  for i := 0 to fdatalist.Count - 1 do
  begin
    lDataRec := TRMEFDataRec(Fdatalist.items[i]);
    RMEXCELCELL(fcols.Items[i]).col := lDataRec.Left;
    RMEXCELCELL(fcols.Items[i]).fdatalistindex := i;
    RMEXCELCELL(frows.Items[i]).row := lDataRec.Top;
    RMEXCELCELL(frows.Items[i]).fdatalistindex := i;
  end;

  sortcol(fcols, FExcel); //排序
  sortrow(frows, FExcel);
  //设置行列
  for i := 0 to fcols.Count - 1 do
  begin
    index := RMEXCELCELL(fcols.Items[i]).fdatalistindex;
    RMEXCELCELL(Fsheet.Items[i]).fdatalistindex := index;
    RMEXCELCELL(Fsheet.Items[i]).colindex := RMEXCELCELL(fcols.Items[i]).colindex;
    RMEXCELCELL(Fsheet.Items[i]).rowindex := getrowindex(frows, index) + getrowcount;
    RMEXCELCELL(Fsheet.Items[i]).col := RMEXCELCELL(fcols.Items[i]).col;
    RMEXCELCELL(Fsheet.Items[i]).row := getrowvalue(frows, index);
  end;

  FExcel.FuncArgSeparator := ';';
  FExcel.WriteUnicodeStrings := true;
  self.Stream.free;
  self.Stream := nil;
  if fileexists(self.FExportFileName) then
    DeleteFile(pchar(self.FExportFileName));
  if fileexists(self.FExportFileName) then
    DeleteFile(pchar(self.FExportFileName));
  with FExcel.Formats.Add do
  begin
    FontIndex := FExcel.Fonts.AddIndex;
    FExcel.Fonts[FontIndex].Name := 'Courier new';
    FExcel.Fonts[FontIndex].Size := 14;
    FExcel.Fonts[FontIndex].Color := xcred;
  end;
  y := 0;
  for i := 0 to fsheet.Count - 1 do
  begin
    li_col := RMEXCELCELL(fsheet.Items[i]).colindex;
    li_row := RMEXCELCELL(fsheet.Items[i]).rowindex;
    index := RMEXCELCELL(fsheet.Items[i]).fdatalistindex;
    lDataRec := TRMEFDataRec(Fdatalist.items[index]);
    case lDataRec.ObjType of
      rmotMemo: _ExportText;
      rmotPicture: _ExportPicture;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMXLSExportForm }

procedure TRMXLSExport1Form.Localize;
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
  RMSetStrProp(chkExportFrames, 'Caption', rmRes + 1803); //导出框线
  RMSetStrProp(chkMultiSheet, 'Caption', rmRes + 382);

  RMSetStrProp(Self, 'Caption', rmRes + 1779);
  btnOK.Caption := RMLoadStr(SOk);
  btnCancel.Caption := RMLoadStr(SCancel);
end;

function TRMXLSExport1Form.GetExportPages: string;
begin
  Result := '';
  if rbdPrintCurPage.Checked then
    Result := 'CURPAGE'
  else if rbdPrintPages.Checked then
    Result := edtPages.Text;
end;

procedure TRMXLSExport1Form.FormCreate(Sender: TObject);
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

procedure TRMXLSExport1Form.btnFileNameClick(Sender: TObject);
begin
  SaveDialog.FileName := edtExportFileName.Text;
  if SaveDialog.Execute then
    edtExportFileName.Text := SaveDialog.FileName;
end;

procedure TRMXLSExport1Form.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ModalResult = mrOK) and (edtExportFileName.Text = '') then
    CanClose := False;
end;

procedure TRMXLSExport1Form.rbdPrintPagesClick(Sender: TObject);
begin
  edtPages.SetFocus;
end;

procedure TRMXLSExport1Form.edtPagesEnter(Sender: TObject);
begin
  rbdPrintPages.Checked := True;
end;

procedure TRMXLSExport1Form.chkExportImagesClick(Sender: TObject);
begin
  RMSetControlsEnable(gbExportImages, chkExportImages.Checked);
  cmbImageFormatChange(Sender);
end;

procedure TRMXLSExport1Form.cmbImageFormatChange(Sender: TObject);
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

procedure TRMXLSExport1Form.edJPEGQualityKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

initialization

finalization

end.

