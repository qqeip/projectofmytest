unit UnitSearchBuilding;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, cxGraphics, cxSplitter, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxControls, cxContainer, cxEdit, cxLabel,
  StdCtrls, cxButtons, cxGroupBox, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, DBClient,
  CxGridUnit;

const
  fDefaultHeight= 200;
type
  TFormSearchBuilding = class(TForm)
    cxSplitter1: TcxSplitter;
    cxGroupBoxInfo: TcxGroupBox;
    cxGroupBoxSearch: TcxGroupBox;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxLabel1: TcxLabel;
    cxComboBox1: TcxComboBox;
    cxLabel2: TcxLabel;
    cxTextEdit1: TcxTextEdit;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure cxSplitter1AfterOpen(Sender: TObject);
    procedure cxSplitter1AfterClose(Sender: TObject);
    procedure cxComboBox1PropertiesChange(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxGrid1DBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    FStatedIndex: integer;
    FCxGridHelper : TCxGridSet;
    procedure AddBuildingField;
    procedure AddMTUField;
    procedure AddAPField;
    procedure AddPHSField;
    procedure AddCDMAField;
    procedure AddDRSField;
    function SearchBuilding(aTargetType: integer; aValue: string):boolean;
  public
    { Public declarations }
  end;

var
  FormSearchBuilding: TFormSearchBuilding;

implementation

uses Ut_Common, Ut_DataModule, Ut_MainForm, UnitAlarmMonitor, UnitGlobal;

{$R *.dfm}

procedure TFormSearchBuilding.AddAPField;
begin
  AddViewField(cxGrid1DBTableView1,'apid','�ڲ����');
  AddViewField(cxGrid1DBTableView1,'apno','AP���');
  AddViewField(cxGrid1DBTableView1,'suburbname','�����־�');
  AddViewField(cxGrid1DBTableView1,'buildingname','�����ҷֵ�');
  AddViewField(cxGrid1DBTableView1,'apaddr','AP�����ַ');
  AddViewField(cxGrid1DBTableView1,'overlay','���Ƿ�Χ');
  AddViewField(cxGrid1DBTableView1,'APIP','AP-IP��ַ');
end;

procedure TFormSearchBuilding.AddBuildingField;
begin
  AddViewField(cxGrid1DBTableView1,'buildingid','�ڲ����');
  AddViewField(cxGrid1DBTableView1,'buildingno','�ҷֵ���');
  AddViewField(cxGrid1DBTableView1,'buildingname','�ҷֵ�����');
  AddViewField(cxGrid1DBTableView1,'address','�ҷֵ��ַ');
  AddViewField(cxGrid1DBTableView1,'suburbname','�־�����');
  AddViewField(cxGrid1DBTableView1,'areaname','����');
end;

procedure TFormSearchBuilding.AddCDMAField;
begin
  AddViewField(cxGrid1DBTableView1,'CDMAID','�ڲ����');
  AddViewField(cxGrid1DBTableView1,'isprogramname','�ҷ�״̬');
  AddViewField(cxGrid1DBTableView1,'cdmano','C����Դ���');
  AddViewField(cxGrid1DBTableView1,'pncode','PN��');
  AddViewField(cxGrid1DBTableView1,'suburbname','�����־�');
  AddViewField(cxGrid1DBTableView1,'buildingname','�����ҷֵ�');
  AddViewField(cxGrid1DBTableView1,'belong_bts','������վ���');
  AddViewField(cxGrid1DBTableView1,'belong_cell','�����������');
  AddViewField(cxGrid1DBTableView1,'address','C����Դ��װλ��');
  AddViewField(cxGrid1DBTableView1,'cover','C����Դ���Ƿ�Χ');
end;

procedure TFormSearchBuilding.AddDRSField;
begin
  AddViewField(cxGrid1DBTableView1,'DRSid','�ڲ����');
  AddViewField(cxGrid1DBTableView1,'DRSNO','ֱ��վ���');
  AddViewField(cxGrid1DBTableView1,'R_DEVICEID','�豸���');
  AddViewField(cxGrid1DBTableView1,'DRSNAME','ֱ��վ����');
  AddViewField(cxGrid1DBTableView1,'isprogramname','�Ƿ��ҷ�');
  AddViewField(cxGrid1DBTableView1,'suburbname','�����־�');
  AddViewField(cxGrid1DBTableView1,'buildingname','�����ҷֵ�');  
  AddViewField(cxGrid1DBTableView1,'DRSTYPENAME','ֱ��վ����');
  AddViewField(cxGrid1DBTableView1,'DRSMANUNAME','ֱ��վ����');
  AddViewField(cxGrid1DBTableView1,'DRSADRESS','��ַ');
  AddViewField(cxGrid1DBTableView1,'DRSPHONE','�绰����');
end;

procedure TFormSearchBuilding.AddMTUField;
begin
  AddViewField(cxGrid1DBTableView1,'mtuid','�ڲ����');
  AddViewField(cxGrid1DBTableView1,'isprogramname','�ҷ�״̬');
  AddViewField(cxGrid1DBTableView1,'mtuno','MTU���');
  AddViewField(cxGrid1DBTableView1,'call','MTU����');
  AddViewField(cxGrid1DBTableView1,'buildingname','�����ҷֵ�');
  AddViewField(cxGrid1DBTableView1,'overlay','��������');
  AddViewField(cxGrid1DBTableView1,'mtuaddr','MTUλ��');
end;

procedure TFormSearchBuilding.AddPHSField;
begin
  AddViewField(cxGrid1DBTableView1,'csid','�ڲ����');
  AddViewField(cxGrid1DBTableView1,'SURVERY_ID','������');
  AddViewField(cxGrid1DBTableView1,'CS_ID','CSID');
  AddViewField(cxGrid1DBTableView1,'suburbname','�����־�');
  AddViewField(cxGrid1DBTableView1,'buildingname','�����ҷֵ�');
  AddViewField(cxGrid1DBTableView1,'CS_COVER','���Ƿ�Χ');
end;

procedure TFormSearchBuilding.cxButton1Click(Sender: TObject);
begin
  if self.cxComboBox1.ItemIndex=-1 then
  begin
    application.MessageBox('��ѡ����Ҷ���', '��ʾ', mb_ok);
    exit;
  end;
  if trim(self.cxTextEdit1.Text)='' then
  begin
    application.MessageBox('��ѯ��������Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  FStatedIndex:= cxComboBox1.ItemIndex;
  cxGrid1DBTableView1.ClearItems;
  case cxComboBox1.ItemIndex of
    0: AddBuildingField;
    1: AddMTUField;
    2: AddAPField;
    3: AddPHSField;
    4: AddCDMAField;
    5: AddDRSField;
  end;
  if not SearchBuilding(cxComboBox1.ItemIndex,cxTextEdit1.Text) then
    application.MessageBox('��ѯʧ�ܣ�', '��ʾ', mb_ok)
  else
    cxSplitter1.OpenSplitter;
end;

procedure TFormSearchBuilding.cxButton2Click(Sender: TObject);
begin
  close;
end;

procedure TFormSearchBuilding.cxComboBox1PropertiesChange(Sender: TObject);
var
  lstr: string;
begin
  case cxComboBox1.ItemIndex of
    0: lstr:= '�ҷֵ����ơ��ҷֵ��ַ';
    1: lstr:= 'MTU��š�MTU�绰����';
    2: lstr:= 'AP��š�APIP';
    3: lstr:= '�����š�CSID';
    4: lstr:= 'CDMA��š�PN��';
    5: lstr:= 'ֱ��վ��š����ơ���ַ���绰����';
  end;
  if lstr<>'' then
  begin
    lstr:= '����'+lstr+'�ɶ��ҷֵ���в�ѯ��λ';
    self.cxTextEdit1.Hint:= lstr;
    self.cxTextEdit1.ShowHint:= true;
  end else
    self.cxTextEdit1.ShowHint:= false;
end;

procedure TFormSearchBuilding.cxGrid1DBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  lBuildingid, lMtuid, lcdmaid, ldrsid: integer;
begin
  //GIS��λ
  if assigned(FormAlarmMonitor) then
  begin
    if FStatedIndex=0 then
    begin
      lBuildingid:=  cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('BUILDINGID').AsInteger;
      FormAlarmMonitor.Location(UD_LAYER_BUILDING,inttostr(lBuildingid));
    end;
    if FStatedIndex=1 then
    begin
      lBuildingid:=  cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('BUILDINGID').AsInteger;
      lmtuid:= cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('mtuid').AsInteger;
      if lBuildingid<=0 then
        FormAlarmMonitor.Location(UD_LAYER_MTU,inttostr(lmtuid))
      else
        FormAlarmMonitor.Location(UD_LAYER_BUILDING,inttostr(lBuildingid))
    end;
    if FStatedIndex=2 then
    begin
      lBuildingid:=  cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('BUILDINGID').AsInteger;
      FormAlarmMonitor.Location(UD_LAYER_BUILDING,inttostr(lBuildingid));
    end;
    if FStatedIndex=3 then
    begin
      lBuildingid:=  cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('BUILDINGID').AsInteger;
      FormAlarmMonitor.Location(UD_LAYER_BUILDING,inttostr(lBuildingid));
    end;
    if FStatedIndex=4 then
    begin
      lBuildingid:=  cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('BUILDINGID').AsInteger;
      lcdmaid:= cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('cdmaid').AsInteger;
      if lBuildingid<=0 then
        FormAlarmMonitor.Location(UD_LAYER_CDMA,inttostr(lcdmaid))
      else
        FormAlarmMonitor.Location(UD_LAYER_BUILDING,inttostr(lBuildingid))
    end;
    if FStatedIndex=5 then
    begin
      lBuildingid:=  cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('BUILDINGID').AsInteger;
      ldrsid:= cxGrid1DBTableView1.DataController.DataSource.DataSet.FieldByName('drsid').AsInteger;
      if lBuildingid<=0 then
        FormAlarmMonitor.Location(UD_LAYER_DRS,inttostr(ldrsid))
      else
        FormAlarmMonitor.Location(UD_LAYER_BUILDING,inttostr(lBuildingid))
    end;
  end;
end;

procedure TFormSearchBuilding.cxSplitter1AfterClose(Sender: TObject);
begin
  Height:= Height-fDefaultHeight;
//  cxGroupBoxInfo.Visible:= false;
end;

procedure TFormSearchBuilding.cxSplitter1AfterOpen(Sender: TObject);
begin
  Height:= 285;
  cxGroupBoxInfo.Height:= fDefaultHeight;
//  cxSplitter1.AlignSplitter:= salTop;
//  cxGroupBoxInfo.Visible:= true;
//  cxSplitter1.AlignSplitter:= salbottom;
end;

procedure TFormSearchBuilding.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);
end;

procedure TFormSearchBuilding.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormSearchBuilding.FormShow(Sender: TObject);
begin
  cxSplitter1.CloseSplitter;
end;

function TFormSearchBuilding.SearchBuilding(aTargetType: integer;
  aValue: string): boolean;
var
  lWhereConditon: string;
begin
  result:= false;
  case aTargetType of
    0: lWhereConditon:= ' and (upper(buildingname) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(address) like ''%'+uppercase(aValue)+'%'')';
    1: lWhereConditon:= ' and (upper(mtuname) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(mtuno) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(mtuaddr) like ''%'+uppercase(aValue)+'%'')';
    2: lWhereConditon:= ' and (upper(apno) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(apip) like ''%'+uppercase(aValue)+'%'')';
    3: lWhereConditon:= ' and (upper(survery_id) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(cs_id) like ''%'+uppercase(aValue)+'%'')';
    4: lWhereConditon:= ' and (upper(cdmano) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(cdmaname) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(pncode) like ''%'+uppercase(aValue)+'%'')';
    5: lWhereConditon:= ' and (upper(drsno) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(drsname) like ''%'+uppercase(aValue)+'%'''+
                              ' or upper(DRSADRESS) like ''%'+uppercase(aValue)+'%''' +
                              ' or upper(DRSPHONE) like ''%'+uppercase(aValue)+'%'')';
  end;
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    case aTargetType of
      0: Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,45,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereConditon]),0);
      1: Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,22,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereConditon]),0);
      2: Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,44,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereConditon]),0);
      3: Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,41,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereConditon]),0);
      4: Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,11,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereConditon]),0);
      5: Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,47,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereConditon]),0);
    end;
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
  result:= true;
end;

end.
