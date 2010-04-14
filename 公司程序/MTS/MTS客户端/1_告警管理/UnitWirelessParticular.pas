unit UnitWirelessParticular;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxControls, cxContainer, cxEdit, cxLabel, cxPC, DB, DBClient,
  cxStyles, cxGraphics, cxVGrid, cxClasses, cxInplaceContainer,
  cxLookAndFeelPainters, cxGroupBox, StringUtils, math, StdCtrls, ExtCtrls;

const
  fMaxLength = 40;
  fMinLength = 16;
  fSetpPer = 0.9;
type
  TLineRecType = class
    Title: string;
    Value: string;
    LineType: integer;
  end;
  TFormWirelessParticular = class(TForm)
    cxLabelMTU: TcxLabel;
    cxLabelMTUStatus: TcxLabel;
    cxLabelPower: TcxLabel;
    cxPageControl1: TcxPageControl;
    cxLabelalarmcounts: TcxLabel;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxTabSheet3: TcxTabSheet;
    cxPageControl2: TcxPageControl;
    cxTabSheet4: TcxTabSheet;
    cxTabSheet5: TcxTabSheet;
    ClientDataSetDym: TClientDataSet;
    cxVerticalGrid1: TcxVerticalGrid;
    cxEditRepository: TcxEditRepository;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxVerticalGridStyleSheetDevExpress: TcxVerticalGridStyleSheet;
    cxVerticalGrid2: TcxVerticalGrid;
    cxVerticalGrid3: TcxVerticalGrid;
    cxVerticalGrid4: TcxVerticalGrid;
    cxGroupBox1: TcxGroupBox;
    Timer1: TTimer;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    cxGroupBox2: TcxGroupBox;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure cxPageControl2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxPageControl1Change(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FIsSysHandle: boolean;
    FMTUNO: string;
    FMTUID: integer;
    procedure SetMTUNO(const Value: string);
    procedure SetMTUID(const Value: integer);
    { Private declarations }
    function AddCategoryRow(Parent:TcxCustomRow; acxVerticalGrid: TcxVerticalGrid; Caption:string):TcxCategoryRow;
    function AddEditor(Parent:TcxCustomRow; acxVerticalGrid:TcxVerticalGrid; aRowName, aCaption, aValue: string):TcxEditorRow;
    procedure AddMultiValueEditor(Parent: TcxCustomRow; acxVerticalGrid:TcxVerticalGrid; aDataSet: TClientDataSet);
    procedure AddValueEdit(Parent:TcxCustomRow; acxVerticalGrid:TcxVerticalGrid;aDataSet: TClientDataSet);
    procedure SetTag(aInt: integer);
    procedure GetLineList(aDataSet: TClientDataSet; aList: TStringList; aType: integer);
    procedure DrawLines(aList: TStringList; aOnwer: TcxGroupBox);
    function GetWidth(aValue: string):integer;
    procedure mytestGetLineList(aList: TStringList);
    procedure ShowMTUStatus;
  public
    procedure ShowWirelessParticular;
  published
    property MTUNO: string read FMTUNO write SetMTUNO;
    property MTUID: integer read FMTUID write SetMTUID;
  end;

var
  FormWirelessParticular: TFormWirelessParticular;

implementation

uses Ut_DataModule;

{$R *.dfm}

{ TFormWirelessParticular }

function TFormWirelessParticular.AddCategoryRow(Parent: TcxCustomRow; acxVerticalGrid: TcxVerticalGrid;
  Caption: string): TcxCategoryRow;
var
  lGridCategoryRow: TcxCategoryRow;
begin
  lGridCategoryRow:=TcxCategoryRow(acxVerticalGrid.AddChild(Parent,TcxCategoryRow	));
  lGridCategoryRow.Properties.Caption:=Caption;
  lGridCategoryRow.Styles.StyleSheet:= cxVerticalGridStyleSheetDevExpress;
  result:=lGridCategoryRow;
end;

function TFormWirelessParticular.AddEditor(Parent:TcxCustomRow; acxVerticalGrid: TcxVerticalGrid;
  aRowName, aCaption, aValue: string): TcxEditorRow;
var
  lcxEditorRow:TcxEditorRow;
begin
  lcxEditorRow := TcxEditorRow(acxVerticalGrid.AddChild(Parent, TcxEditorRow));
  lcxEditorRow.Properties.Caption := aCaption;
  lcxEditorRow.Properties.Value:= aValue;
  lcxEditorRow.Properties.Options.Editing:= false;
  result:=lcxEditorRow;
end;

procedure TFormWirelessParticular.AddMultiValueEditor(Parent: TcxCustomRow;
  acxVerticalGrid: TcxVerticalGrid; aDataSet: TClientDataSet);
var
  lcxEditorRow:TcxMultiEditorRow;
  lcxEditorRowItemProperties: TcxEditorRowItemProperties;
begin
  //标题
  lcxEditorRow := TcxMultiEditorRow(acxVerticalGrid.AddChild(Parent, TcxMultiEditorRow));
  lcxEditorRowItemProperties:= lcxEditorRow.Properties.Editors.Add;
  lcxEditorRowItemProperties.Options.Editing:= false;
  lcxEditorRowItemProperties.Caption:= 'SSID';
  lcxEditorRowItemProperties.Value:= '场强';
  lcxEditorRowItemProperties:= lcxEditorRow.Properties.Editors.Add;
  lcxEditorRowItemProperties.Options.Editing:= false;
  lcxEditorRowItemProperties.Caption:= '';
  lcxEditorRowItemProperties.Width:= 0;
  lcxEditorRowItemProperties.Value:= '信道';

  if (aDataSet.Active) and (aDataSet.RecordCount>0) then
  begin
    while not aDataSet.Eof do
    begin
      lcxEditorRow := TcxMultiEditorRow(acxVerticalGrid.AddChild(Parent, TcxMultiEditorRow));
      lcxEditorRowItemProperties:= lcxEditorRow.Properties.Editors.Add;
      lcxEditorRowItemProperties.Options.Editing:= false;
      lcxEditorRowItemProperties.Caption:= aDataSet.FieldByName('caption').AsString;
      lcxEditorRowItemProperties.Value:= aDataSet.FieldByName('CQ').AsString;
      lcxEditorRowItemProperties:= lcxEditorRow.Properties.Editors.Add;
      lcxEditorRowItemProperties.Options.Editing:= false;
      lcxEditorRowItemProperties.Caption:= '';
      lcxEditorRowItemProperties.Width:= 0;
      lcxEditorRowItemProperties.Value:= aDataSet.FieldByName('XD').AsString;
      aDataSet.Next;
    end;
  end;
end;

procedure TFormWirelessParticular.AddValueEdit(Parent:TcxCustomRow; acxVerticalGrid: TcxVerticalGrid;
  aDataSet: TClientDataSet);
begin
  if (aDataSet.Active) and (aDataSet.RecordCount>0) then
  begin
    //标题
    AddEditor(Parent,acxVerticalGrid,'','参数','值');
    aDataSet.First;
    while not aDataSet.Eof do
    begin
      AddEditor(Parent,acxVerticalGrid,'',
        aDataSet.FieldByName('caption').AsString,aDataSet.FieldByName('testvalue').AsString);
      aDataSet.Next;
    end;
  end;
end;

procedure TFormWirelessParticular.cxPageControl1Change(Sender: TObject);
var
  I : integer;
  lGridCategoryRow: TcxCategoryRow;
begin
  if FIsSysHandle then exit;
  
  //PHS
  if cxPageControl1.ActivePage= cxTabSheet2 then
  begin
    if cxPageControl1.ActivePage.Tag=0 then
    begin
      for I := cxVerticalGrid3.Rows.Count - 1 downto 0 do
        cxVerticalGrid3.Rows.Items[i].Free;
      //场强检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid3,'场强检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,20,FMTUID]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid3,ClientDataSetDym);
      //TCH信道检测结果
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid3,'TCH信道检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,21,FMTUID]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid3,ClientDataSetDym);

      cxPageControl1.ActivePage.Tag:= 1;
    end;
  end
  else
  //WLAN
  if cxPageControl1.ActivePage= cxTabSheet3 then
  begin
    if cxPageControl1.ActivePage.Tag=0 then
    begin
      //释放row
      for I := cxVerticalGrid4.Rows.Count - 1 downto 0 do
        cxVerticalGrid4.Rows.Items[i].Free;

      //WLAN掉线通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid4,'WLAN掉线检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,22,FMTUID]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid4,ClientDataSetDym);
      //WLAN场强检测结果
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid4,'WLAN场强检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,23,FMTUID]),0);
      end;
      AddMultiValueEditor(lGridCategoryRow,cxVerticalGrid4,ClientDataSetDym);
      //WLAN速率检测结果
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid4,'WLAN速率检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,24,FMTUID]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid4,ClientDataSetDym);
      //时延、丢包、误码率结果
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid4,'时延丢包误码率结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,25,FMTUID]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid4,ClientDataSetDym);

      cxPageControl1.ActivePage.Tag:= 1;
//      //WLAN掉线通知
//      with ClientDataSetDym do
//      begin
//        close;
//        ProviderName:='dsp_General_data';
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,22,FMTUID]),0);
//      end;
//      AddValueEdit(cxVerticalGrid4,ClientDataSetDym);
//      //WLAN场强检测通知
//      with ClientDataSetDym do
//      begin
//        close;
//        ProviderName:='dsp_General_data';
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,23,FMTUID]),0);
//      end;
//      AddValueEdit(cxVerticalGrid4,ClientDataSetDym);
    end;
  end;
end;

procedure TFormWirelessParticular.cxPageControl2Change(Sender: TObject);
var
  I: Integer;
  lLineList: TStringList;
  lGridCategoryRow: TcxCategoryRow;
begin
  if FIsSysHandle then exit;

  lLineList:= TStringList.Create;
  //CDMA待机
  if cxPageControl2.ActivePage= cxTabSheet4 then
  begin
    if cxPageControl2.ActivePage.Tag=0 then //未刷新
    begin
      //CDMA信息检测通知
      for I := cxVerticalGrid1.Rows.Count - 1 downto 0 do
        cxVerticalGrid1.Rows.Items[i].Free;

     lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid1,'CDMA信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,12,FMTUID,73]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid1,ClientDataSetDym);
      //场强检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid1,'场强检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,13,FMTUID,66]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid1,ClientDataSetDym);
//      //TX检测结果
//      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid1,'TX检测结果');
//      with ClientDataSetDym do
//      begin
//        close;
//        ProviderName:='dsp_General_data';
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,14,FMTUID,130]),0);
//      end;
//      AddValueEdit(lGridCategoryRow,cxVerticalGrid1,ClientDataSetDym);
      //换相关参数检测
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid1,'切换相关参数检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,15,FMTUID,74]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid1,ClientDataSetDym);
      //激活集信息检测
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid1,'激活集信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,16,FMTUID,76]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid1,ClientDataSetDym);
      GetLineList(ClientDataSetDym,lLineList,2);
      //邻区信息检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid1,'邻区信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,17,FMTUID,78]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid1,ClientDataSetDym);
      GetLineList(ClientDataSetDym,lLineList,4);
      //候选集信息检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid1,'候选集信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,19,FMTUID,77]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid1,ClientDataSetDym);
      GetLineList(ClientDataSetDym,lLineList,3);
      //FINGER信息检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid1,'FINGER信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,18,FMTUID,75]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid1,ClientDataSetDym);
      GetLineList(ClientDataSetDym,lLineList,1);
      //画线
//      mytestGetLineList(lLineList);
      DrawLines(lLineList,cxGroupBox1);

      cxPageControl2.ActivePage.Tag:= 1;
    end;
  end
  //通话
  else
  if cxPageControl2.ActivePage= cxTabSheet5 then
  begin
    if cxPageControl2.ActivePage.Tag=0 then
    begin
      for I := cxVerticalGrid2.Rows.Count - 1 downto 0 do
        cxVerticalGrid2.Rows.Items[i].Free;
      //CDMA信息检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid2,'CDMA信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,12,FMTUID,89]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid2,ClientDataSetDym);
      //场强检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid2,'场强检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,13,FMTUID,82]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid2,ClientDataSetDym);
      //换相关参数检测
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid2,'切换相关参数检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,15,FMTUID,90]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid2,ClientDataSetDym);
      //激活集信息检测
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid2,'激活集信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,16,FMTUID,92]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid2,ClientDataSetDym);
      GetLineList(ClientDataSetDym,lLineList,2);
      //邻区信息检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid2,'邻区信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,17,FMTUID,94]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid2,ClientDataSetDym);
      GetLineList(ClientDataSetDym,lLineList,4);
      //候选集信息检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid2,'候选集信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,19,FMTUID,93]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid2,ClientDataSetDym);
      GetLineList(ClientDataSetDym,lLineList,3);
      //FINGER信息检测通知
      lGridCategoryRow:= AddCategoryRow(nil,cxVerticalGrid2,'FINGER信息检测结果');
      with ClientDataSetDym do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,18,FMTUID,91]),0);
      end;
      AddValueEdit(lGridCategoryRow,cxVerticalGrid2,ClientDataSetDym);
      GetLineList(ClientDataSetDym,lLineList,1);
      //画线
      DrawLines(lLineList,cxGroupBox2);

      cxPageControl2.ActivePage.Tag:= 1;
    end;
  end;
  ClearTStrings(lLineList);
end;

procedure TFormWirelessParticular.DrawLines(aList: TStringList;
  aOnwer: TcxGroupBox);
var
  I: Integer;
  lcxLabelTitle, lcxLabelValue, lcxLabelValue2: TcxLabel;
  lTop: integer;
  lDefinHeight,lDefinWidth, lDefineLeft, lDefineTop: integer;
  lLineRecType: TLineRecType;
  lColor: TColor;
  lVisable1,lVisable2,lVisable3,lVisable4: boolean;
begin
  lDefinHeight:= 15;
  lDefinWidth:= 60;
  lDefineLeft:= 105;
  lDefineTop:= 25;
  lTop:= 0;
  //释放
  for I := TcxGroupBox(aOnwer).ControlCount - 1 downto 0 do
  begin
    if (pos('FLAGTITLE',TcxGroupBox(aOnwer).Controls[i].Name)>0)
    or (pos('FLAGVALUE',TcxGroupBox(aOnwer).Controls[i].Name)>0)
    or (pos('FLAGLINE',TcxGroupBox(aOnwer).Controls[i].Name)>0) then
    TcxGroupBox(aOnwer).Controls[i].Free;
  end;
  //根据列表画
  lColor:= self.Color;
  lVisable1:= false;
  lVisable2:= false;
  lVisable3:= false;
  lVisable4:= false;
  for I := 0 to aList.Count - 1 do
  begin
    lLineRecType:= TLineRecType(aList.Objects[i]);
    lcxLabelTitle:= TcxLabel.Create(nil);
    lcxLabelTitle.Name:= 'FLAGTITLE'+inttostr(i);
    lcxLabelTitle.Caption:= '';
    lcxLabelTitle.Parent:= aOnwer;
    lcxLabelTitle.AutoSize:= false;
    lcxLabelTitle.ParentColor:= true;
    lcxLabelTitle.Top:= lDefineTop+lTop;
    lcxLabelTitle.Left:= lDefineLeft;
    lTop:= lTop+ lDefinHeight -5;
    lcxLabelTitle.Width:= lDefinWidth;
    lcxLabelTitle.Height:= lDefinHeight;
    lcxLabelTitle.Caption:= lLineRecType.Title;


    lcxLabelValue2:= TcxLabel.Create(nil);
    lcxLabelValue2.Name:= 'FLAGVALUE'+inttostr(i);
    lcxLabelValue2.Caption:= '';
    lcxLabelValue2.Parent:= aOnwer;
    lcxLabelValue2.Caption:= lLineRecType.Value;
    lcxLabelValue2.AutoSize:= true;
    lcxLabelValue2.ParentColor:= true;
    lcxLabelValue2.Top:=  lcxLabelTitle.Top;
    lcxLabelValue2.Left:=  lcxLabelTitle.Left+lcxLabelTitle.Width+20-lcxLabelValue2.Width;
    lcxLabelValue2.Height:= lDefinHeight;

    lcxLabelValue:= TcxLabel.Create(nil);
    lcxLabelValue.Name:= 'FLAGLINE'+inttostr(i);
    lcxLabelValue.Caption:= '';
    lcxLabelValue.Parent:= aOnwer;
    lcxLabelValue.AutoSize:= false;
    lcxLabelValue.ParentColor:= false;
    lcxLabelValue.Top:=  lcxLabelTitle.Top;
    lcxLabelValue.Left:=  lcxLabelTitle.Left+lcxLabelTitle.Width+20;
    lcxLabelValue.Width:= GetWidth(lLineRecType.Value);
    lcxLabelValue.Height:= lDefinHeight;
    case lLineRecType.LineType of
      1: begin
           if cxPageControl2.ActivePageIndex=0 then
           begin
             if lColor<>cxLabel1.Style.Color then
             begin
               lColor:= cxLabel1.Style.Color;
               cxLabel1.Top:= lcxLabelValue.Top;
               lVisable1:= true;
             end;
           end else
           begin
             if lColor<>cxLabel5.Style.Color then
             begin
               lColor:= cxLabel5.Style.Color;
               cxLabel5.Top:= lcxLabelValue.Top;
               lVisable1:= true;
             end;
           end;
         end;
      2: begin
           if cxPageControl2.ActivePageIndex=0 then
           begin
             if lColor<>cxLabel2.Style.Color then
             begin
               lColor:= cxLabel2.Style.Color;
               cxLabel2.Top:= lcxLabelValue.Top;
               lVisable2:= true;
             end;
           end else
           begin
             if lColor<>cxLabel6.Style.Color then
             begin
               lColor:= cxLabel6.Style.Color;
               cxLabel6.Top:= lcxLabelValue.Top;
               lVisable2:= true;
             end;
           end;
         end;
      3: begin
           if cxPageControl2.ActivePageIndex=0 then
           begin
             if lColor<>cxLabel3.Style.Color then
             begin
               lColor:= cxLabel3.Style.Color;
               cxLabel3.Top:= lcxLabelValue.Top;
               lVisable3:= true;
             end;
           end else
           begin
             if lColor<>cxLabel7.Style.Color then
             begin
               lColor:= cxLabel7.Style.Color;
               cxLabel7.Top:= lcxLabelValue.Top;
               lVisable3:= true;
             end;
           end;
         end;
      4: begin
           if cxPageControl2.ActivePageIndex=0 then
           begin
             if lColor<>cxLabel4.Style.Color then
             begin
               lColor:= cxLabel4.Style.Color;
               cxLabel4.Top:= lcxLabelValue.Top;
               lVisable4:= true;
             end;
           end else
           begin
             if lColor<>cxLabel8.Style.Color then
             begin
               lColor:= cxLabel8.Style.Color;
               cxLabel8.Top:= lcxLabelValue.Top;
               lVisable4:= true;
             end;
           end;
         end;
    end;

    lcxLabelValue.Style.Color:= lColor;
//    lcxLabelValue.Caption:= lLineRecType.Value;
  end;
  cxLabel1.Visible:= lVisable1;
  cxLabel5.Visible:= lVisable1;
  cxLabel2.Visible:= lVisable2;
  cxLabel6.Visible:= lVisable2;
  cxLabel3.Visible:= lVisable3;
  cxLabel7.Visible:= lVisable3;
  cxLabel4.Visible:= lVisable4;
  cxLabel8.Visible:= lVisable4;
  if (cxLabel4.Top<cxLabel2.Top+cxLabel2.Height-5) and cxLabel2.Visible then
    cxLabel4.Top:= cxLabel2.Top+cxLabel2.Height-5;
  if (cxLabel3.Top<cxLabel4.Top+cxLabel4.Height-5) and cxLabel4.Visible then
    cxLabel3.Top:= cxLabel4.Top+cxLabel4.Height-5;
  if (cxLabel1.Top<cxLabel3.Top+cxLabel3.Height-5) and cxLabel3.Visible then
    cxLabel1.Top:= cxLabel3.Top+cxLabel3.Height-5;

  if (cxLabel8.Top<cxLabel6.Top+cxLabel6.Height-5) and cxLabel6.Visible then
    cxLabel8.Top:= cxLabel6.Top+cxLabel6.Height-5;
  if (cxLabel7.Top<cxLabel8.Top+cxLabel8.Height-5) and cxLabel8.Visible then
    cxLabel7.Top:= cxLabel8.Top+cxLabel8.Height-5;
  if (cxLabel5.Top<cxLabel7.Top+cxLabel7.Height-5) and cxLabel7.Visible then
    cxLabel5.Top:= cxLabel7.Top+cxLabel7.Height-5;
end;

procedure TFormWirelessParticular.FormCreate(Sender: TObject);
begin
  ClientDataSetDym.RemoteServer:= Dm_MTS.SocketConnection1;
end;

procedure TFormWirelessParticular.FormPaint(Sender: TObject);
begin
  self.Color:= $00EBC4A4;
end;

procedure TFormWirelessParticular.FormShow(Sender: TObject);
begin
  //
end;

procedure TFormWirelessParticular.GetLineList(aDataSet: TClientDataSet;
  aList: TStringList; aType: integer);
var
  lLineRecType: TLineRecType;
  lCaption: string;
begin
  if (aDataSet.Active) and (aDataSet.RecordCount>0) then
  begin
    aDataSet.First;
    while not aDataSet.Eof do
    begin
      lLineRecType:= TLineRecType.Create;
      lCaption:= aDataSet.FieldByName('caption').AsString;
      lLineRecType.Title:= copy(lCaption,pos('PN',lCaption)+2,maxint);
      lLineRecType.Value:= aDataSet.FieldByName('testvalue').AsString;
      lLineRecType.LineType:= aType;
      aList.AddObject(lLineRecType.Title,lLineRecType);
      aDataSet.Next;
    end;
  end;
end;

function TFormWirelessParticular.GetWidth(aValue: string): integer;
var
  lValue: double;
begin
  lValue:= Strtofloat(aValue);
  if (lValue<0) and (abs(lValue)>=40) then
    result:=fMinLength
  else if (lValue<0) and (abs(lValue)<40) then
    result:= fMaxLength - abs(trunc(lValue*fSetpPer))
  else if ceil(lValue)>=0 then
    result:= fMaxLength;

  result:=result*4;
end;

procedure TFormWirelessParticular.mytestGetLineList(aList: TStringList);
var
  lLineRecType: TLineRecType;
  I: Integer;
begin
  for I := 0 to 10 do
  begin
    lLineRecType:= TLineRecType.Create;
    lLineRecType.Title:= 'hello'+inttostr(i);
    lLineRecType.Value:= inttostr(i);
    lLineRecType.LineType:= 1;
    aList.AddObject(lLineRecType.Title,lLineRecType);
  end;
end;

procedure TFormWirelessParticular.SetMTUID(const Value: integer);
begin
  FMTUID := Value;
end;

procedure TFormWirelessParticular.SetMTUNO(const Value: string);
begin
  FMTUNO := Value;
end;

procedure TFormWirelessParticular.SetTag(aInt: integer);
begin
  cxTabSheet1.Tag:= aInt;
  cxTabSheet2.Tag:= aInt;
  cxTabSheet3.Tag:= aInt;
  cxTabSheet4.Tag:= aInt;
  cxTabSheet5.Tag:= aInt;
end;

procedure TFormWirelessParticular.ShowMTUStatus;
begin
  with ClientDataSetDym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,11,FMTUID]),0);
  end;
  if ClientDataSetDym.RecordCount> 0 then
  begin
    cxLabelMTU.Caption:= ClientDataSetDym.FieldByName('MTUNO').AsString;
    cxLabelMTUStatus.Caption:= '当前MTU状态为：'+ClientDataSetDym.FieldByName('STATUSNAME').AsString;
    cxLabelPower.Caption:= '当前MTU电源状态为：'+ClientDataSetDym.FieldByName('status_powername').AsString;
    cxLabelalarmcounts.Caption:= '当前MTU告警数为：'+ClientDataSetDym.FieldByName('alarmcounts').AsString;
  end;
end;

procedure TFormWirelessParticular.ShowWirelessParticular;
begin
  ShowMTUStatus;
  SetTag(0);
  FIsSysHandle:= true;
  cxPageControl1.ActivePageIndex:= 0;
  cxPageControl2.ActivePageIndex:= 0;
  FIsSysHandle:= false;
  cxPageControl2.OnChange(self);
end;

procedure TFormWirelessParticular.Timer1Timer(Sender: TObject);
begin
  ShowMTUStatus;
  SetTag(0);
  cxPageControl1.OnChange(self);
  cxPageControl2.OnChange(self);
end;

end.
