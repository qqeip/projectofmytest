unit UnitBreakSiteStat;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, FxCommon, FxStore, FxDB,Grids, FxGrid, ComCtrls,
  StdCtrls, FxPivSrc, ExtCtrls, FxMap, ComObj, ExcelXP, FxArrays, Menus,
  CheckLst, StringUtils, Buttons, IniFiles;

type
  TItemInfo = record
    ItemCode : integer; //ָ�����
    ItemType : integer; //ָ������
    ItemName : string;  //ָ������
    PlaceCol : integer;
    PlaceRow : integer;
  end;
  TDimInfo = record
    ItemCode : String;
    ItemName : string;
  end;

type
  TFormBreakSiteStat = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    FxPivot1: TFxPivot;
    Cb_SubTotal: TCheckBox;
    Cb_RepDate: TCheckBox;
    Cbb_RepDate: TComboBox;
    Pc_RepShow: TPageControl;
    Ts_Grid: TTabSheet;
    FG_RepShow: TFxGrid;
    Fs_RepShow: TFxSource;
    FxCube: TFxCube;
    CDS_Rep: TClientDataSet;
    SaveDialog: TSaveDialog;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Bt_Ok: TButton;
    Bt_ShowType: TButton;
    Bt_DataExport: TButton;
    Dtp_StartDate: TDateTimePicker;
    Dtp_EndDate: TDateTimePicker;
    GroupBox2: TGroupBox;
    CLB_TownList: TCheckListBox;
    PopupMenu2: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    ColorDialog: TColorDialog;
    GroupBox3: TGroupBox;
    SpeedButton1: TSpeedButton;
    RBCaption: TRadioButton;
    RBLabel: TRadioButton;
    RBData: TRadioButton;
    RBBackground: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Bt_OkClick(Sender: TObject);
    procedure Cb_SubTotalClick(Sender: TObject);
    procedure Cb_RepDateClick(Sender: TObject);
    procedure Cbb_RepDateChange(Sender: TObject);
    procedure Bt_DataExportClick(Sender: TObject);
    procedure FG_RepShowDecisionDrawCell(Sender: TObject; Col,
      Row: Integer; var Value: String; var aFont: TFont;
      var aColor: TColor; AState: TGridDrawState;
      aDrawState: TDecisionDrawState);
    procedure Fs_RepShowStateChange(Sender: TObject);
    procedure Bt_ShowTypeClick(Sender: TObject);
    procedure FG_RepShowDecisionExamineCell(Sender: TObject; iCol, iRow,
      iSum: Integer; const ValueArray: TValueArray);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    gRepItem : Array of TItemInfo;
    gRepItem_City : Array of TDimInfo;
    lClientDataSet : TClientDataSet;
    iCol_Selected,iRow_Selected:Integer; //�һ�FG_RepShowʱ��ѡcol,row
    CsCodeList,AlarmCodeList,ProvinceCodeList:String;  // ��ͬ���͸澯�������
    FTownsIDList, FWhereCondition: string ;//ѡ�����������  ȫ����ϸ����
    FTimeScale: Integer; //ʱ�������
    procedure ShowRepDate(MapItem: TDimensionItem);
    procedure DimensionChange(MapItem: TDimensionItem);
    function SaveAsExcelFile(AGrid: TFxGrid; ASheetName,
      AFileName: string): Boolean;
    function ReviseCellsValue(Col, Row: Integer; Value: String): string;
    function GetAvailableMem: Integer;
    function GetValueFromCell(Col1, Col2, Row, ItemCode: integer): string;
    function GetColNum(ItemType, ItemCode: integer): integer;
    function FillHaveValue(ExecSQL: string): String;
    procedure InitTown;
    function GetRepDateEnd_TimeScale: string;
    procedure GetRepColor;
    { Private declarations }
  public
    { Public declarations }
    function GetTownsID: string;
  end;

var
  FormBreakSiteStat: TFormBreakSiteStat;

implementation

uses UnitDllCommon, UnitBreakSiteDetail;

{$R *.dfm}

procedure TFormBreakSiteStat.FormCreate(Sender: TObject);
var
  lSqlStr: string;
begin
  SetMemoryCapacity(GetAvailableMem);
  lClientDataSet := TClientDataSet.Create(nil);
  InitTown;

  //��ʼ�� <����ָ��> �������    PARENTID ����ָ������ : 1-��վ 2-�澯 3- ʡ��
  lSqlStr:= 'select DicCode as Itemcode, DicName as Itemname' +
            '  from (select diccode,dicname,dictype,cityid,' +
            '               decode(setvalue,null,0,''HaveDetail'',1,0) as itemkind' +
            '          from alarm_dic_code_info' +
            '         where dictype=2001' +
            '        )' +
            ' where itemkind=1' +
            '   and cityid=' + IntToStr(gPublicParam.cityid);
  CsCodeList:=FillHaveValue(lsqlstr);
end;

procedure TFormBreakSiteStat.FormShow(Sender: TObject);
begin
  Pc_RepShow.ActivePage:=Ts_Grid;
//  FC_RepShow.DecisionSource:=nil;

  Cb_SubTotal.Checked:=false;
  Dtp_StartDate.Date:=date;
  Dtp_EndDate.date:=date;
  GetRepColor;
end;

procedure TFormBreakSiteStat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  lClientDataSet.Free;
  gDllMsgCall(FormBreakSiteStat,1,'','');
end;

procedure TFormBreakSiteStat.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormBreakSiteStat.Bt_OkClick(Sender: TObject);
var
  lCompanyStrings,lContentStrings : string;
  i:integer;
  lsqlstr, lTimeScale,
  lYear_Start, lMonth_Start, lDay_Start,
  lYear_End, lMonth_End, lDay_End,
  lDate_Start, lDate_End: string;
begin
  FxCube.Active:=false;
  Screen.Cursor := crHourGlass;
  try
    FTownsIDList:= GetTownsID;
    lTimeScale:= GetRepDateEnd_TimeScale;
    lYear_Start:= FormatDateTime('yyyy',Dtp_StartDate.Date);
    lYear_End:= FormatDateTime('yyyy',Dtp_EndDate.Date);
    lMonth_Start:= FormatDateTime('mm',Dtp_StartDate.Date);
    lMonth_End:= FormatDateTime('mm',Dtp_EndDate.Date);
    lDay_Start:= FormatDateTime('dd',Dtp_StartDate.Date);
    lDay_End:= FormatDateTime('dd',Dtp_EndDate.Date);
    lDate_Start:= lYear_Start+lMonth_Start+lDay_Start;
    lDate_End:= lYear_End+lMonth_End+lDay_End;
    FWhereCondition:= ' and to_char(statdate,''yyyymmdd'')||lpad(TIMESCALE,3,''0'')>=''' + lDate_Start +'001''' +
                      ' and to_char(statdate,''yyyymmdd'')||lpad(TIMESCALE,3,''0'')<=''' + lDate_End +lTimeScale + '''';
    lsqlstr := 'select statdate,ItemName,CityName,TypeName,itemvalue from ' +
               '(select a.statdate,a.DICCODE as ItemName,e.id as Townid,e.name as CityName,d.dicname as TypeName, ' +
               //' sum(decode((to_char(a.statdate,'+'''yyyymmdd'''+')||a.timescale),f.repdate,a.itemvalue,decode(a.diccode,1,null,a.itemvalue))) itemvalue ' +
               ' sum(decode((to_char(a.statdate,'+'''yyyymmdd'''+')||a.timescale),f.repdate,decode(a.diccode,1,a.itemvalue,null),g.repdate,decode(a.diccode,2,a.itemvalue,null),decode(a.diccode,1,null,2,null,a.itemvalue))) itemvalue '+
               ' from ALARM_REP_BREAKSITE a  ' +
               ' left join pop_area b on a.cityid=b.cityid and a.suburbid=b.id and b.layer=3 ' +
               ' left join alarm_dic_type_info c on a.dictype=c.typeid ' +
               ' left join alarm_dic_code_info d on a.dictype=d.dictype and a.diccode=d.diccode ' +
               ' left join pop_area e on a.cityid=e.cityid and b.top_id=e.id and e.layer=2 ' +
               ' left join (select to_char(statdate,'+'''yyyymmdd'''+')||timescale as repdate,statdate,timescale,dictype,diccode,suburbid '+
               ' from (select * from alarm_rep_breaksite a '+
               ' where a.StatDate>= '+SaveDatetimetoDB(Dtp_StartDate.Date,false)+
               ' and a.StatDate<= '+ SaveDatetimetoDB(Dtp_EndDate.Date,false)+
               ' and diccode=1 order by a.statdate desc,a.timescale desc) where rownum=1) f '+
               ' on a.statdate=f.statdate and a.timescale=f.timescale and a.dictype=f.dictype and a.diccode=f.diccode '+
//               ' left join (select to_char(statdate,'+'''yyyymmdd'''+')||timescale as repdate,suburbid,cityid from ALARM_REP_BREAKSITE '+
//               '     where to_char(statdate,'+'''yyyymmdd'''+')||timescale= '+
//               '    (select to_char(statdate,'+'''yyyymmdd'''+')||max(timescale) as repdate from ALARM_REP_BREAKSITE '+
//               '       where a.StatDate>= '+SaveDatetimetoDB(Dtp_StartDate.Date,false)+
//               '        and a.StatDate<= '+ SaveDatetimetoDB(Dtp_EndDate.Date,false)+
//               '        and diccode=2 group by statdate)) g on g.suburbid=a.suburbid and g.cityid=a.cityid
               ' left join (select a.statdate,max(a.timescale) as timescale,a.cityid,to_char(a.statdate,'+'''yyyymmdd'''+')||max(a.timescale) as repdate,a.suburbid,a.dictype,a.diccode '+
               ' from ALARM_REP_BREAKSITE a '+
               ' where a.StatDate>= '+SaveDatetimetoDB(Dtp_StartDate.Date,false)+
               ' and a.StatDate<= '+ SaveDatetimetoDB(Dtp_EndDate.Date,false)+
               '         and diccode=2 and dictype=2001  '+
               ' group by a.statdate,a.cityid,to_char(a.statdate,'+'''yyyymmdd'''+'),a.suburbid,a.dictype,a.diccode '+
               ' ) g  '+
               ' on a.statdate=g.statdate and a.timescale=g.timescale and a.cityid=g.cityid '+
               ' and a.dictype=g.dictype and a.diccode=g.diccode and a.suburbid=g.suburbid '+

               ' where a.StatDate>= '+SaveDatetimetoDB(Dtp_StartDate.Date,false)+
               ' and a.StatDate<= '+ SaveDatetimetoDB(Dtp_EndDate.Date,false)+
               ' and a.dictype=2001 and a.cityid ='+inttostr(gPublicParam.cityid)+
               ' group by a.statdate,a.DICCODE,d.dicname,e.name) where Townid in (' + FTownsIDList + ')';
    with CDS_Rep do
    begin
      ProviderName := 'dsp_General_data';
      Close;
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
      if RecordCount=0 then
      begin
        application.MessageBox(pchar('û�м��������������ļ�¼��'), '��ʾ', mb_ok + mb_defbutton1);
        exit;
      end;
    end;
    FxCube.Active:=true;
    Fs_RepShow.SparseCols:=true;
    Cb_SubTotalClick(Self);
    //AutoColWideth;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormBreakSiteStat.Cb_SubTotalClick(Sender: TObject);
begin
  FG_RepShow.Totals:=Cb_SubTotal.Checked;
end;

procedure TFormBreakSiteStat.Cb_RepDateClick(Sender: TObject);
begin
  try
    ShowRepDate(FxCube.DimensionMap.Find('STATDATE'));
  except
  end;
  Cb_SubTotalClick(Self);
end;

procedure TFormBreakSiteStat.ShowRepDate(MapItem: TDimensionItem);
begin
  if MapItem=nil then exit;
  if Cb_RepDate.Checked then
  begin
     MapItem.ActiveFlag:=diAsNeeded ;
     Cbb_RepDate.ItemIndex:=0;
  end else
  begin
     MapItem.ActiveFlag:=diInactive;
     Cbb_RepDate.ItemIndex:=-1;
  end;
  MapItem.Active:=true;
end;

procedure TFormBreakSiteStat.Cbb_RepDateChange(Sender: TObject);
begin
  DimensionChange(Fxcube.DimensionMap.Find('STATDATE'));
end;

procedure TFormBreakSiteStat.DimensionChange(MapItem:TDimensionItem);
begin
  if MapItem=nil then Exit;
  case Cbb_RepDate.ItemIndex of
   0 : MapItem.BinType:=TBinType(binNone);    //��
   1 : MapItem.BinType:=TBinType(binWeek);    //��
   2 : MapItem.BinType:=TBinType(binMonth);   //��
   3 : MapItem.BinType:=TBinType(binQuarter); //��
   4 : MapItem.BinType:=TBinType(binYear);    //��
  end;
end;

procedure TFormBreakSiteStat.Bt_DataExportClick(Sender: TObject);
var
  Present: TDate;
  Year, Month, Day: Word;
  filename : String;
begin
  if Not (FxCube.DataSet.Active) then
  begin
    application.MessageBox('����ִ�б���Ĳ�ѯ�������ٽ���<����>����', '��ʾ', mb_ok + mb_defbutton1);
    exit;
  end;
  Present:= Date;
  DecodeDate(Present, Year, Month, Day);
  filename := '��վ�ʱ���'+Format('%.4d',[year])+Format('%.2d',[month])+Format('%.2d',[day])+'.xls';
  SaveAsExcelFile(FG_RepShow,'��վ�ʱ���',filename);
end;

function TFormBreakSiteStat.SaveAsExcelFile(AGrid: TFxGrid; ASheetName, AFileName: string): Boolean;
const
 xlWBATWorksheet = -4167;
var
 Row, Col: Integer;  //�����м����
 XLApp, Sheet, Data,Data_tmp: OLEVariant;
 ii,jj,ll: Integer;
 SelRange : variant;
 Value:string;
 XLRowCount, XlColCount: Integer;  //��ŵ�����excel�����������������
begin
  SaveDialog.FileName :=AFileName;
  if not SaveDialog.Execute then exit;
  // Prepare Data
  Row:= 0;
  Col:= 0;
  Data := VarArrayCreate([1, AGrid.RowCount, 1, AGrid.ColCount], varVariant);
  Data_tmp:= VarArrayCreate([1, AGrid.RowCount, 1, AGrid.ColCount], varVariant);
  //�������ݴ����������� Data_tmp (�������صĺϼ���)
  for jj := -AGrid.FixedRows to AGrid.RowCount - AGrid.FixedRows -1 do  //-1
   for ii := -AGrid.FixedCols to AGrid.ColCount - AGrid.FixedCols-1  do  //-1
   begin
     //�������ʾ�ϼ��� �����������Ҳ������ϼ�������  //���һ�кϼƱ���
     if (ii<0) and (jj<>AGrid.RowCount - AGrid.FixedRows -1 )
     and (not Cb_SubTotal.checked) and ((AGrid.Cells[ii, jj]='Sum') or (AGrid.Cells[ii, jj]='�ϼ�'))  then
     begin
       row:=row-1;
       break;
     end ;
     Data_tmp[jj+AGrid.FixedRows+row + 1, ii+AGrid.FixedCols+col + 1] := ReviseCellsValue(ii, jj, AGrid.Cells[ii, jj]);
   end;
  // ȷ��������������ʾȷ���Ƿ�ȥ���ϼ��У�
  XLRowCount:=AGrid.RowCount+Row;
  ////////
  Row:= 0;
  Col:= 0;
  For jj:= -AGrid.FixedCols to AGrid.ColCount - AGrid.FixedCols - 1 do
   For ii:= -AGrid.FixedRows to  XLRowCount - AGrid.FixedRows - 1 do
   Begin
     //�������ʾ�ϼ��� �����������Ҳ������ϼ�������  //���һ�кϼƱ���  and (jj<>AGrid.ColCount - AGrid.FixedCols - 1)
     If (ii<0) and (not Cb_SubTotal.checked) and ((Data_tmp[ii+AGrid.FixedRows+row + 1,jj+AGrid.FixedCols+1]='Sum') or (Data_tmp[ii+AGrid.FixedRows+row + 1,jj+AGrid.FixedCols+1]='�ϼ�'))
     then
     begin
       Col:=Col-1;
       break;
     end;
     Data[ii+AGrid.FixedRows+row + 1, jj+AGrid.FixedCols+col+1] := Data_tmp[ii+AGrid.FixedRows+row + 1,jj+AGrid.FixedCols+1];
   end;
  //ȷ��������������ʾȷ���Ƿ�ȥ���ϼ��У�
  //XlColCount:=AGrid.ColCount+Col;
  if Cb_SubTotal.checked then
   XlColCount:=AGrid.ColCount+Col
  else
   XlColCount:=AGrid.ColCount+Col-1;

  ///////
  // Create Excel-OLE Object
  Result := False;
  XLApp := CreateOleObject('Excel.Application');
  try
   // Hide Excel
   XLApp.Visible := false;
   // Add new Workbook
   XLApp.Workbooks.Add(xlWBatWorkSheet);
   Sheet := XLApp.Workbooks[1].WorkSheets[1];
   Sheet.Name := ASheetName;
   // Fill up the sheet
   SelRange:=Sheet.Range[sheet.Cells[1, 1], Sheet.Cells[XLRowCount, XlColCount]];
   SelRange.Value := Data; //��ֵ
   SelRange.select;
   SelRange.borders.linestyle:=xlcontinuous; //�ñ߿��߿ɼ�
   SelRange.font.size:=9; //�ı������ı������С
   SelRange.WrapText:=true;//�ı��Զ�����
   //SelRange.Interior.ColorIndex:=39;//�����ɫΪ����ɫ

   //���� �кϲ�  �� ͼ�� Ͻ��
   for ii:=1 to AGrid.FixedCols do
   begin
     Col:=ii;
     Row:=AGrid.FixedRows+1;
     Value:=Sheet.Cells[Row,Col].Value;
     for jj:=AGrid.FixedRows+2 to XlRowCount do
     begin
       if (trim(string(Sheet.Cells[jj, ii].Value))<>'') then
       begin
          if (jj>row+1) and (value<>'�ϼ�') then
          begin
            SelRange:=Sheet.Range[sheet.Cells[Row, Col], Sheet.Cells[jj-1,ii]];
            SelRange.select;
            SelRange.merge; //�ϲ���Ԫ��
          end;
          Col:= ii;
          Row:= jj;
          Value:=Sheet.Cells[Row,Col].Value;
       end;
     end;
     if value<>'�ϼ�' then
     begin
       SelRange:=Sheet.Range[sheet.Cells[Row, Col], Sheet.Cells[jj-1,ii]];
       SelRange.select;
       SelRange.merge; //�ϲ���Ԫ��
     end;
   end;
   //�ϲ���ͷ��  ��һ��Ϊָ�꡶��--qiusy
   for ll:=2 to AGrid.FixedRows do
   begin
     Row:=ll;
     Col:=AGrid.FixedCols+1;
     Value:=Sheet.Cells[Row,Col].Value;
     for jj:=AGrid.FixedCols+2 to XlColCount do
     begin
       if (trim(string(Sheet.Cells[ll, jj].Value))<>'') then
       begin
          if (jj>Col+1) and (value<>'�ϼ�') then
          begin
            SelRange:=Sheet.Range[sheet.Cells[Row, Col], Sheet.Cells[ll,jj-1]];
            SelRange.select;
            SelRange.merge; //�ϲ���Ԫ��
            SelRange.HorizontalAlignment:= xlCenter;// �ı�ˮƽ���з�ʽ
          end;
          Col:= jj;
          Row:= ll;
          Value:=Sheet.Cells[Row,Col].Value;
       end;
     end;
     if value<>'�ϼ�' then
     begin
       SelRange:=Sheet.Range[sheet.Cells[Row, Col], Sheet.Cells[ll,jj-1]];
       SelRange.select;
       SelRange.merge; //�ϲ���Ԫ��
       SelRange.HorizontalAlignment:= xlCenter;// �ı�ˮƽ���з�ʽ
     end;
   end;
   /////--end qiusy
   //�ϲ�<ָ������>��Ԫ��
   SelRange:=Sheet.Range[sheet.Cells[1, AGrid.FixedCols+1], Sheet.Cells[1,XlColCount]];
   SelRange.select;
   SelRange.merge; //�ϲ�<ָ������>��Ԫ��
   SelRange.HorizontalAlignment:= xlCenter;// �ı�ˮƽ���з�ʽ
   //�ϲ���������
   for ii:=1 to AGrid.FixedCols do
   begin
     SelRange:=Sheet.Range[sheet.Cells[1, ii], Sheet.Cells[AGrid.FixedRows,ii]];
     SelRange.select;
     SelRange.merge;
     SelRange.VerticalAlignment:= xlCenter;//�ı���ֱ���з�ʽ
     SelRange.HorizontalAlignment:= xlCenter;// �ı�ˮƽ���з�ʽ
   end;
   /////////////////////
   sheet.Cells[XlRowCount+1, 1].value:='�Ʊ����ڣ�'+datetimetostr(now);
   SelRange:=Sheet.Range[sheet.Cells[XlRowCount+1, 1], Sheet.Cells[XlRowCount+1,XlColCount]];
   SelRange.select;
   SelRange.merge; //�ϲ��Ʊ����ڵ�Ԫ��
   SelRange.font.size:=9;

   Sheet.rows[1].insert;
   sheet.Cells[1, 1].value:=ASheetName;
   SelRange:=Sheet.Range[sheet.Cells[1, 1], Sheet.Cells[1,XlColCount]];
   SelRange.select;
   SelRange.merge; //�ϲ����ⵥԪ��
   SelRange.font.size:=12; //�ı������ı������С
   SelRange.VerticalAlignment:= xlCenter;//�ı���ֱ���з�ʽ
   SelRange.HorizontalAlignment:= xlCenter;// �ı�ˮƽ���з�ʽ
   SelRange.font.Bold:=true;  //������������
   SelRange.RowHeight:=30;  //���ñ����и�

   try
     //���ô�ӡ����
     Sheet.PageSetup.Orientation:=2;
     Sheet.PageSetup.PaperSize:=xlPaperA4;
     //Sheet.PageSetup.Orientation:=2;
     Sheet.PageSetup.PrintTitleRows := 'A1:A1'; //Repeat this row
     Sheet.PageSetup.LeftMargin:=18; //0.25" Left Margin
     Sheet.PageSetup.RightMargin:=18; //0.25" will vary between printers
     Sheet.PageSetup.TopMargin:=18; //0.5"
     Sheet.PageSetup.BottomMargin:=36; //0.5"
     Sheet.PageSetup.CenterHorizontally:=True;

     //header setup
     Sheet.PageSetup.CenterHeader:='';
      //footer setup
     Sheet.PageSetup.LeftFooter:='���·���� &Z'+AFileName;
     Sheet.PageSetup.RightFooter:='�� &P ҳ �� &N ҳ';
     Sheet.PageSetup.FooterMargin:=18;
   except
     application.MessageBox('û�����ô�ӡ��������޷�����<ҳ������>��'+char(13)+'Ҫ������ȷԤ����������Ӵ�ӡ�����ٴε�����������ʾ�Ի�����ѡ�񡰰�ť��<��>��', '��ʾ', mb_ok + mb_defbutton1);
     //exit;
   end;
   // Save Excel Worksheet      AFileName
   try
     XLApp.Workbooks[1].SaveAs(SaveDialog.FileName);
     Result := True;
   except
     application.MessageBox('��ȡ�ļ�������ȷ���Ƿ��ļ����ڴ򿪻򱣻�״̬��', '��ʾ', mb_ok + mb_defbutton1);
     exit;
   end;
   XLApp.Visible := True;
   XLApp.Workbooks[1].PrintPreview;
  finally
   // Quit Excel
   if not VarIsEmpty(XLApp) then   //���������ر�Excel�ļ�
   begin
     XLApp.DisplayAlerts := False;
     XLApp.Quit;
     XLAPP := Unassigned;
     Sheet := Unassigned;
   end;
  end;
end;

Function TFormBreakSiteStat.ReviseCellsValue(Col, Row: Integer; Value: String):string;
  var tempint:integer;
begin
  if (row=-1) and (col>=0) and (value<>'Sum') then
  try
    if lClientDataSet.Active and (lClientDataSet.RecordCount>0) then
    if  lClientDataSet.Locate('dicorder',trim(value), [loCaseInsensitive]) then
        value:=lClientDataSet.fieldbyname('DICNAME').AsString;
  except
    postmessage(Self.Handle,WM_CLOSE,0,0);
  end;

  if (gRepItem[col].ItemCode=3) and (grepitem[col].ItemType=2001) and (row>gRepItem[col].PlaceRow) then
    value:=GetValueFromCell(GetColNum(2001, 1),GetColNum(2001, 2),Row,grepitem[col].ItemCode)
  else
  if (col>=0) and (row>=0) and (trim(value)<>'') and (value<>'<NULL>') then
  begin
//     Value:=Format('%0.2f',[strtofloat(value)]);
    tempint:=trunc(strtofloat(value));
     if tempint=0 then
       value:=''
     else
       Value:=format('%d',[tempint]);
  end;

  if Value='Sum' then
    Value:='�ϼ�'
  else
  if value='<NULL>' then
    value:=''
  else
  if (not Cb_SubTotal.Checked) and (Col=FG_RepShow.ColCount-FG_RepShow.FixedCols-1) then
     Value:=''
  else
  if Value='0.00' then
     Value:='';
  Result:=Value;
end;

function TFormBreakSiteStat.GetAvailableMem: Integer;
const
  MaxInt: Int64 = High(Integer);
var
  MemStats: TMemoryStatus;
  Available: Int64;
begin
  GlobalMemoryStatus(MemStats);
  if (MemStats.dwAvailPhys > MaxInt) or (Longint(MemStats.dwAvailPhys) = -1) then
    Available := MaxInt
  else
    Available := MemStats.dwAvailPhys;
  if (MemStats.dwAvailPageFile > MaxInt) or (Longint(MemStats.dwAvailPageFile) = -1) then
    Inc(Available, MaxInt div 2)
  else
    Inc(Available, MemStats.dwAvailPageFile div 2);
  if Available > MaxInt then
    Result := MaxInt
  else
    Result := Available;
end;

procedure TFormBreakSiteStat.FG_RepShowDecisionDrawCell(Sender: TObject;
  Col, Row: Integer; var Value: String; var aFont: TFont;
  var aColor: TColor; AState: TGridDrawState;
  aDrawState: TDecisionDrawState);
begin
  Value:= ReviseCellsValue(Col, Row, Value);
end;

function TFormBreakSiteStat.GetValueFromCell(Col1, Col2, Row,
  ItemCode: integer): string;
var
  Value1, Value2 : real;
begin
  Result:='';
  if (Col1=-1) or (FG_RepShow.cells[Col1,row]='') or (FG_RepShow.cells[Col1,row]='<NULL>') then
    exit
  else
    Value1:=strtofloat(FG_RepShow.cells[Col1,row]);

  if ((Col2=-1) or(Col2=-2) ) or (FG_RepShow.cells[Col2,row]='') or (FG_RepShow.cells[Col2,row]='<NULL>') then
    exit
  else
    Value2:=strtofloat(FG_RepShow.cells[Col2,row]);

  if Value1<>0 then
  case ItemCode of
    3 : Result:=format('%0.2f',[Value2/Value1*100]);             //��վ�ʣ���վ����/��վ����	  @02/@01
  end
  else Result:='';
end;

function TFormBreakSiteStat.GetColNum(ItemType, ItemCode: integer): integer;
var
  i:integer;
begin
  Result:=-1;
  for i:=0 to High(grepitem) do
  begin
    if (grepitem[i].ItemType=ItemType) and (grepitem[i].ItemCode=ItemCode) then
    begin
      Result:=grepitem[i].PlaceCol;
      break;
    end;
  end;
end;

procedure TFormBreakSiteStat.Fs_RepShowStateChange(Sender: TObject);
var
  i:integer;
  lClientDataSet1: TClientDataSet;
  str_dims, lSqlStr :String;
  lItemName,lAreaname :integer;
  M_ItemName,M_Areaname :integer;
begin
  lClientDataSet1:= TClientDataSet.Create(nil);
  lItemName := -1;
  lAreaname := -1;
  with Fs_RepShow,lClientDataSet do
  begin
    //��ָ�����ƽ����
    lSqlStr := 'select * from alarm_dic_code_info t where t.dictype=2001' ;
    ProviderName := 'dsp_General_data';
    Close;
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    //���Ҹ�ά��ֵ
    for i:=0 to nDims-1 do   //�õ���ָ�����ơ����ڵ�ά��
    begin
      str_dims:=Fs_RepShow.GetDimensionName(i);
      if str_dims='ָ������' then
           lItemName:=i
      else if str_dims='����' Then
           lAreaname:=i;
    end;
    //����ά�ȶ�Ӧ���б�ֵ����
    M_ItemName:=Fs_RepShow.GetDimensionMemberCount(lItemName);
    M_Areaname :=Fs_RepShow.GetDimensionMemberCount(lAreaname);
    //�õ�ָ��ά�ȵĳ�Ա��Ϣ --ָ������
    setlength(grepitem,M_ItemName);
    for i:=0 to M_ItemName-1 do
    begin
      grepitem[i].ItemName:= Fs_RepShow.GetMemberAsString(lItemName,i);
      if lClientDataSet.Locate('dicorder',grepitem[i].ItemName, [loCaseInsensitive]) then
      begin
        grepitem[i].ItemCode := fieldbyname('DICORDER').AsInteger;
        grepitem[i].ItemType := fieldbyname('dictype').AsInteger;
      end else
      begin
        grepitem[i].ItemCode := 0;
        grepitem[i].ItemType := 0;
      end;
      grepitem[i].PlaceCol :=i;
      grepitem[i].PlaceRow :=-1;
    end;

    ////�õ�ָ��ά�ȵĳ�Ա��Ϣ --����
    setlength(gRepItem_City,M_Areaname);
    With lClientDataSet1 do
    begin
      Close;
      lSqlStr:='Select id as itemcode,name as itemname From pop_area Where layer=2 and cityid=' + IntToStr(gPublicParam.cityid);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
      Open;
    end;
    for i:=0 to M_Areaname-1 do
    begin
      gRepItem_City[i].ItemName:= Fs_RepShow.GetMemberAsString(lAreaname,i);
      if lClientDataSet1.locate('itemname',gRepItem_City[i].ItemName, [loCaseInsensitive]) then
         gRepItem_City[i].ItemCode := lClientDataSet1.fieldbyname('ItemCode').AsString
      Else gRepItem_City[i].ItemCode := '0' ;
    end;
  end;
  if Fs_RepShow.GetGroupCount(dgCol,true)>1 then
     Fs_RepShow.MoveDimIndexes(dgCol,dgRow, 1,2,true);
end;

procedure TFormBreakSiteStat.Bt_ShowTypeClick(Sender: TObject);
begin
  if Pc_RepShow.ActivePage=Ts_Grid then
  begin
//    Pc_RepShow.ActivePage:=Ts_Chart;
//    FC_RepShow.DecisionSource:=Fs_RepShow;
    Bt_ShowType.Caption:='�� ��';
  end
  else
  begin
    Pc_RepShow.ActivePage:=Ts_Grid;
//    FC_RepShow.DecisionSource:=nil;
    Bt_ShowType.Caption:='ͼ ʾ';
  end;
end;

procedure TFormBreakSiteStat.FG_RepShowDecisionExamineCell(Sender: TObject;
  iCol, iRow, iSum: Integer; const ValueArray: TValueArray);
var
  vdictype,vdiccode:Integer;
begin
  iCol_Selected:=iCol;
  iRow_Selected:=iRow;

  vdictype:=gRepItem[iCol_selected].ItemType ;
  vdiccode:=gRepItem[iCol_selected].ItemCode ;

  ////�������е���ϸ������ϸ�б��е� �˳�
  If (vdictype=2001) and (gPublicParam.cityid<>0) and
     (Pos(','+IntToStr(vdiccode)+',',CsCodeList)>0) Then
  begin
     FG_RepShow.PopupMenu:= PopupMenu1 ;
  end
  Else FG_RepShow.PopupMenu:= Nil;
end;

procedure TFormBreakSiteStat.N1Click(Sender: TObject);
var
  i: Integer;
  lClientDataSet: TClientDataSet;
  ldictype,ldiccode, lCityid:Integer;
  lDimsname, lReportDate: String;
  col_city,Col_repdate:Integer;  //����ά�ȶ�Ӧ����
begin
  //����γ�ȱ���Ϊ��ÿ��'�ſ���Ϊ��Ϊ��ѯ����
  If (Cbb_RepDate.ItemIndex<>0) and (Cbb_RepDate.ItemIndex<>-1) Then
  begin
    application.MessageBox('��ϸ��ѯֻ֧������γ��Ϊ[ÿ��]�Ĳ�ѯ����ȷ����', '��ʾ', mb_ok + mb_defbutton1);
    Exit;
  end;
  //�ϼ����ʾ��ϸ
  For i:= 1 to  FG_RepShow.FixedCols do
  If (FG_RepShow.Cells[-i,iRow_selected] ='�ϼ�') Or (LowerCase(FG_RepShow.Cells[-i,iRow_selected]) ='sum')  Then
  begin
    application.MessageBox('�ϼ��֧�ֲ�ѯ��ϸ����ȷ����', '��ʾ', mb_ok + mb_defbutton1);
    Exit;
  end;
  For i:= 1 to  FG_RepShow.FixedRows do
  If (LowerCase(FG_RepShow.Cells[icol_selected,-i]) ='�ϼ�') Or ( LowerCase(FG_RepShow.Cells[icol_selected,-i])='sum')  Then
  begin
    application.MessageBox('�ϼ��֧�ֲ�ѯ��ϸ����ȷ����', '��ʾ', mb_ok + mb_defbutton1);
    Exit;
  end;
  col_city:=-9 ;Col_repdate:=-9;
  For i:=1 to FG_RepShow.FixedCols do
  begin
    If FG_RepShow.Cells[-i,-1] = '����' Then  //�����Ͻ������ά�� �������ѡ�е�Ͻ��ά��ֵ
       col_city:= -i
    Else If FG_RepShow.Cells[-i,-1] = 'ʱ��' Then
       Col_repdate:= -i ;
  end;
    //���ɲ�ѯ����   ָ������ ָ����
  ldictype:=grepitem[iCol_selected].ItemType ;
  ldiccode:=grepitem[iCol_selected].ItemCode ;

    //���ɲ�ѯ����   ����
  lDimsname:='';
  If col_city<>-9 then
  begin
    for i:=0 to iRow_selected do
    begin
      lDimsname:= FG_RepShow.Cells[col_city,iRow_selected-i] ;
      If lDimsname<>'' Then Break;
    end;
    For i:=0 To Length(gRepItem_City) Do
    If  grepitem_city[i].ItemName= lDimsname Then
    begin
      lCityid:= StrToInt(grepitem_city[i].ItemCode) ;
      break;
    end
    Else lCityid:= -9 ;
  end Else lCityid:= -1 ;  //����

    //���ɲ�ѯ����  ��������
  lDimsname:='';
  If Col_repdate<>-9 then
  begin
    for i:=0 to iRow_selected do
    begin
      lDimsname:= FG_RepShow.Cells[Col_repdate,iRow_selected-i] ;
      If lDimsname<>'' Then Break;
    end;
    lReportDate:=lDimsname;
  end else lReportDate:= '-1';

  if not Assigned(FormBreakSiteDetail) then
    FormBreakSiteDetail:= TFormBreakSiteDetail.Create(Self);
  with FormBreakSiteDetail do
  try
    SUBURBID:= lCityid;
    RepDate:= lReportDate;
    TownsIDList:= FTownsIDList;
    WholeWherecondition:= FWhereCondition;
    ShowModal;
  finally
    FreeAndNil(FormBreakSiteDetail);
    FormBreakSiteDetail:= nil;
  end;

end;

Function TFormBreakSiteStat.FillHaveValue(ExecSQL:string):String;
var
  lClientDataSet: TClientDataSet;
begin
  Result:=',';
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,ExecSQL]),0);
      Open;
      first;
      while not eof do
      begin
        Result:=Result+ FieldByName('Itemcode').AsString+',' ;
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormBreakSiteStat.InitTown;
var
  lstr:String;
  lWdInteger: TWdInteger;
  lClientDataSet: TClientDataSet;
  i:integer;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName := 'dsp_General_data';
    lstr:= 'select id as Townid,name as TownName from pop_area where layer=2 and cityid=' +
           IntToStr(gPublicParam.cityid);
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lstr]),0);
    First;
    for i:= 0 to RecordCount-1 do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('Townid').AsInteger);
      CLB_TownList.Items.AddObject(FieldByName('Townname').AsString,lWdInteger);
      CLB_TownList.Checked[i]:= True;
      Next;
    end;
  end;
end;

function TFormBreakSiteStat.GetTownsID: string;
var
  i: integer;
  lStr: string;
begin
  Result:= '';
  for i:= 0 to CLB_TownList.Items.Count-1 do
  begin
    if CLB_TownList.Checked[i] then
      lStr:= lStr + TWdInteger(CLB_TownList.Items.Objects[i]).ToString + ',';
  end;
  lStr:= Copy(lStr,1,Length(lStr)-1);
  if lStr='' then
    Result:= '-1'
  else
    Result:= lStr;
end;

function TFormBreakSiteStat.GetRepDateEnd_TimeScale: string;
var
  lstr:String;
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName := 'dsp_General_data';
    lstr:= 'select LPad(nvl(max(TIMESCALE),0), 3, ''0'') as TIMESCALE from alarm_rep_breaksite_record where statdate=' +
           SaveDatetimetoDB(Dtp_EndDate.Date,false);
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lstr]),0);
    if recordcount=1 then
      Result:= fieldByName('TIMESCALE').AsString
    else
      Result:= '-1';
  end;
end;

procedure TFormBreakSiteStat.N2Click(Sender: TObject);
var
  i: Integer;
begin
  for i:= 0 to CLB_TownList.Items.Count-1 do
    CLB_TownList.Checked[i]:= True;
end;

procedure TFormBreakSiteStat.N3Click(Sender: TObject);
var
  i: Integer;
begin
  for i:= 0 to CLB_TownList.Items.Count-1 do
    CLB_TownList.Checked[i]:= (not CLB_TownList.Checked[i]);
end;

procedure TFormBreakSiteStat.SpeedButton1Click(Sender: TObject);
var
  lIniPath: string;
  ini: TIniFile;
begin
  lIniPath:= ExtractFilePath(Application.ExeName)+'ProjectCFMS_Client.ini';
  ini:= TIniFile.Create(lIniPath);
  try
    if ColorDialog.Execute then
    begin
      if RBCaption.Checked then
      begin
        ini.WriteString('Color','CaptionColor',ColorToString(ColorDialog.Color));
        FG_RepShow.CaptionColor:= ColorDialog.Color;
      end;
      if RBLabel.Checked then
      begin
        ini.WriteString('Color','LabelColor',ColorToString(ColorDialog.Color));
        FG_RepShow.LabelColor:= ColorDialog.Color;
      end;
      if RBData.Checked then
      begin
        ini.WriteString('Color','DataColor',ColorToString(ColorDialog.Color));
        FG_RepShow.DataColor:= ColorDialog.Color;
      end;
      if RBBackground.Checked then
      begin
        ini.WriteString('Color','BackgroundColor',ColorToString(ColorDialog.Color));
        FG_RepShow.Color:= ColorDialog.Color;
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TFormBreakSiteStat.GetRepColor;
var
  lIniPath: string;
  ini: TIniFile;
begin
  lIniPath:= ExtractFilePath(Application.ExeName)+'ProjectCFMS_Client.ini';
  if FileExists(lIniPath) then
  begin
    ini:= TIniFile.Create(lIniPath);
    try
      FG_RepShow.CaptionColor:= StringToColor(ini.ReadString('Color','CaptionColor','clPurple'));
      FG_RepShow.LabelColor:= StringToColor(ini.ReadString('Color','LabelColor','clSkyBlue'));
      FG_RepShow.DataColor:= StringToColor(ini.ReadString('Color','DataColor','clTeal'));
      FG_RepShow.Color:= StringToColor(ini.ReadString('Color','BackgroundColor','clInactiveCaptionText'));
    finally
      ini.Free;
    end;
  end;

  
end;

end.
