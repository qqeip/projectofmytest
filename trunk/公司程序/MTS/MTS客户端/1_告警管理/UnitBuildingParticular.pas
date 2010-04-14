unit UnitBuildingParticular;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxPC, cxControls, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, CxGridUnit, DBClient, Grids, ValEdit, Menus;
const
  Loaded = 1;
  UnLoaded = 0;
type
  TFloatInfo = record
    Field :String;
    Value :String;
  end;
  TFloatArray = Array of TFloatInfo;
  TFormBuildingParticular = class(TForm)
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxTabSheet3: TcxTabSheet;
    cxTabSheet4: TcxTabSheet;
    cxTabSheet5: TcxTabSheet;
    cxTabSheet6: TcxTabSheet;
    cxTabSheet7: TcxTabSheet;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    VL: TValueListEditor;
    cxTabSheet8: TcxTabSheet;
    procedure cxPageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FIsSysHandle: boolean;
    FCxGridHelper : TCxGridSet;
    FBUILDINGID: integer;
    fFloatField : TFloatArray;
    FMTUID: integer;
    FAnalysistype: integer;
    FMenuConfig: TMenuItem;
    FSuburbid: integer;
    procedure DrawTitle(aTabIndex: integer);
    procedure ShowBuildingParticular(aBuildingid,aMtuid: integer);
    procedure SetBUILDINGID(const Value: integer);
    procedure SetAnalysistype(const Value: integer);
    procedure SetMTUID(const Value: integer);
    procedure ActionConfigExecute(sender: Tobject);
  public
    procedure LoadBuildingInfo;
  published
    property SUBURBID: integer read FSuburbid write FSuburbid;
    property BUILDINGID: integer read FBUILDINGID write SetBUILDINGID;
    property MTUID: integer read FMTUID write SetMTUID;
    //1 �ҷֵ� 2 MTU 3 DRS
    property Analysistype: integer read FAnalysistype write SetAnalysistype;
  end;

var
  FormBuildingParticular: TFormBuildingParticular;

implementation

uses Ut_Common, Ut_DataModule, Ut_MainForm, UntDRSConfig, UnitDRSInfoMgr;

{$R *.dfm}

procedure TFormBuildingParticular.cxPageControl1Change(Sender: TObject);
begin
  if FIsSysHandle then exit;

  case cxPageControl1.ActivePageIndex of
//    0: self.cxGrid1.Parent:= self.cxTabSheet1;
    1:
      begin
        self.cxGrid1.Parent:= self.cxTabSheet2;
        FMenuConfig.Visible:= False;
      end;
    2:
      begin
        self.cxGrid1.Parent:= self.cxTabSheet3;
        FMenuConfig.Visible:= False;
      end;
    3:
      begin
        self.cxGrid1.Parent:= self.cxTabSheet4;
        FMenuConfig.Visible:= False;
      end;
    4:
      begin
        self.cxGrid1.Parent:= self.cxTabSheet5;
        FMenuConfig.Visible:= False;
      end;
    5:
      begin
        self.cxGrid1.Parent:= self.cxTabSheet6;
        FMenuConfig.Visible:= False;
      end;
    6:
      begin
        self.cxGrid1.Parent:= self.cxTabSheet7;
        FMenuConfig.Visible:= False;
      end;
    7:
      begin
        Self.cxGrid1.Parent:= Self.cxTabSheet8;
        FMenuConfig.Visible:= True;
      end;
  end;
  if cxPageControl1.ActivePageIndex <> 0 then
    DrawTitle(cxPageControl1.ActivePageIndex);
  ShowBuildingParticular(FBUILDINGID,FMTUID);
end;

procedure TFormBuildingParticular.DrawTitle(aTabIndex: integer);
begin
  cxGrid1DBTableView1.ClearItems;
  case aTabIndex of
    1: begin
         AddViewField(cxGrid1DBTableView1,'mtuid','�ڲ����');
         AddViewField(cxGrid1DBTableView1,'mtuno','MTU���');
         AddViewField(cxGrid1DBTableView1,'mtuname','MTU����');
         AddViewField(cxGrid1DBTableView1,'mtutypename','MTU����');
         AddViewField(cxGrid1DBTableView1,'longitude','����');
         AddViewField(cxGrid1DBTableView1,'latitude','γ��');
         AddViewField(cxGrid1DBTableView1,'linkno','�϶�������');
         AddViewField(cxGrid1DBTableView1,'call','�绰����');
         AddViewField(cxGrid1DBTableView1,'called','���к���');
         AddViewField(cxGrid1DBTableView1,'modelname','�澯����ģ��');
         AddViewField(cxGrid1DBTableView1,'mainlook_apname','�����AP');
         AddViewField(cxGrid1DBTableView1,'mainlook_phsname','�����PHS');
         AddViewField(cxGrid1DBTableView1,'mainlook_cnetname','�����C��');
         AddViewField(cxGrid1DBTableView1,'mtuaddr','MTUλ��');
         AddViewField(cxGrid1DBTableView1,'overlay','���Ƿ�Χ');
         AddViewField(cxGrid1DBTableView1,'isprogramname','�Ƿ��ҷ�');
         AddViewField(cxGrid1DBTableView1,'buildingname','�ҷֵ�����');
         AddViewField(cxGrid1DBTableView1,'suburbname','�־�');
         AddViewField(cxGrid1DBTableView1,'shieldstatusname','�Ƿ�����');
       end;
    2: begin
         AddViewField(cxGrid1DBTableView1,'apid','�ڲ����');
         AddViewField(cxGrid1DBTableView1,'apno','AP���');
         AddViewField(cxGrid1DBTableView1,'connecttypename','��������');
         AddViewField(cxGrid1DBTableView1,'apport','��Ӧ�˿�');
         AddViewField(cxGrid1DBTableView1,'factoryname','��Ӧ��');
         AddViewField(cxGrid1DBTableView1,'apkindname','AP�ͺ�');
         AddViewField(cxGrid1DBTableView1,'appropertyname','AP����');
         AddViewField(cxGrid1DBTableView1,'appower','����');
         AddViewField(cxGrid1DBTableView1,'powerkindname','���緽ʽ');
         AddViewField(cxGrid1DBTableView1,'frequency','Ƶ��');
         AddViewField(cxGrid1DBTableView1,'apaddr','AP��ַ');
         AddViewField(cxGrid1DBTableView1,'overlay','���Ƿ�Χ');
         AddViewField(cxGrid1DBTableView1,'manageaddrseg','AP�����ַ��');
         AddViewField(cxGrid1DBTableView1,'apip','APIP');
         AddViewField(cxGrid1DBTableView1,'gwaddr','���ص�ַ');
         AddViewField(cxGrid1DBTableView1,'macaddr','MAC��ַ');
         AddViewField(cxGrid1DBTableView1,'businessvlan','ҵ��VLAN');
         AddViewField(cxGrid1DBTableView1,'managevlan','����VLAN');
         AddViewField(cxGrid1DBTableView1,'switchno','����������');
         AddViewField(cxGrid1DBTableView1,'buildingname','�����ҷֵ�');
         AddViewField(cxGrid1DBTableView1,'suburbname','�����־�');
       end;
    3: begin
         AddViewField(cxGrid1DBTableView1,'CSID','�ڲ����');
         AddViewField(cxGrid1DBTableView1,'CS_ID','CS_ID');
         AddViewField(cxGrid1DBTableView1,'SURVERY_ID','������');
         AddViewField(cxGrid1DBTableView1,'NETADDRESS','��Ԫ��Ϣ');
         AddViewField(cxGrid1DBTableView1,'CSADDR','��վ��ַ');
         AddViewField(cxGrid1DBTableView1,'CS_COVER','���Ƿ�Χ');
         AddViewField(cxGrid1DBTableView1,'CS_TYPENAME','��վ����');
         AddViewField(cxGrid1DBTableView1,'suburbname','�����־�');
         AddViewField(cxGrid1DBTableView1,'BUILDINGNAME','�����ҷֵ�');
       end;
    4: begin
         AddViewField(cxGrid1DBTableView1,'CDMAID','�ڲ����');
         AddViewField(cxGrid1DBTableView1,'cdmano','��Դ���');
         AddViewField(cxGrid1DBTableView1,'cdmaname','��Դ����');
         AddViewField(cxGrid1DBTableView1,'cdmatypename','��Դ����');
         AddViewField(cxGrid1DBTableView1,'longitude','����');
         AddViewField(cxGrid1DBTableView1,'latitude','γ��');
         AddViewField(cxGrid1DBTableView1,'belong_msc','����MSC���');
         AddViewField(cxGrid1DBTableView1,'belong_bsc','����BSC���');
         AddViewField(cxGrid1DBTableView1,'belong_cell','�����������');
         AddViewField(cxGrid1DBTableView1,'belong_bts','������վ���');
         AddViewField(cxGrid1DBTableView1,'pncode','PN ��');
         AddViewField(cxGrid1DBTableView1,'devicetypename','�豸�ͺ�');
         AddViewField(cxGrid1DBTableView1,'factorytypename','��Դ����');
         AddViewField(cxGrid1DBTableView1,'powertypename','��Դ����');
         AddViewField(cxGrid1DBTableView1,'address','��װλ��');
         AddViewField(cxGrid1DBTableView1,'cover','���Ƿ�Χ');
         AddViewField(cxGrid1DBTableView1,'isprogramname','�Ƿ��ҷ�');
         AddViewField(cxGrid1DBTableView1,'buildingname','�ҷֵ�����');
         AddViewField(cxGrid1DBTableView1,'suburbname','�־�');
       end;
    5: begin
         AddViewField(cxGrid1DBTableView1,'SWITCHID','�ڲ����');
         AddViewField(cxGrid1DBTableView1,'switchno','��������Ϣ');
         AddViewField(cxGrid1DBTableView1,'uplinkport','�����˿�');
         AddViewField(cxGrid1DBTableView1,'macaddr','�����ַ');
         AddViewField(cxGrid1DBTableView1,'manageaddr','�����ַ');
         AddViewField(cxGrid1DBTableView1,'POP','�Уϣ�');
         AddViewField(cxGrid1DBTableView1,'suburbname','�����־�');
         AddViewField(cxGrid1DBTableView1,'buildingname','�����ҷֵ�');
       end;
    6: begin
         AddViewField(cxGrid1DBTableView1,'LINKID','�ڲ����');
         AddViewField(cxGrid1DBTableView1,'linkno','���������');
         AddViewField(cxGrid1DBTableView1,'linkaddr','������λ��');
         AddViewField(cxGrid1DBTableView1,'linktype','����������');
         AddViewField(cxGrid1DBTableView1,'linktype','�Ƿ�ɷ�');
         AddViewField(cxGrid1DBTableView1,'trunkaddr','�ɷ�λ��');
         AddViewField(cxGrid1DBTableView1,'linkequipment','�����豸����');
         AddViewField(cxGrid1DBTableView1,'linkcs','���ӻ�վ');
         AddViewField(cxGrid1DBTableView1,'linkap','����AP');
         AddViewField(cxGrid1DBTableView1,'linkcdma','����CDMA');
         AddViewField(cxGrid1DBTableView1,'suburbname','�����־�');
         AddViewField(cxGrid1DBTableView1,'BUILDINGNAME','�����ҷֵ�');
       end;
    7: begin
         AddViewField(cxGrid1DBTableView1,'DRSID','ֱ��վID');
         AddViewField(cxGrid1DBTableView1,'DRSNO','ֱ��վ���');
         AddViewField(cxGrid1DBTableView1,'R_DEVICEID','�豸���');
         AddViewField(cxGrid1DBTableView1,'DRSNAME','ֱ��վ����');
         AddViewField(cxGrid1DBTableView1,'DRSTYPENAME','ֱ��վ����');
         AddViewField(cxGrid1DBTableView1,'DRSMANUNAME','ֱ��վ����');
         AddViewField(cxGrid1DBTableView1,'DRSADRESS','��ַ');
         AddViewField(cxGrid1DBTableView1,'DRSPHONE','�绰����');
       end;
  end;
end;

procedure TFormBuildingParticular.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);
  FMenuConfig:= FCxGridHelper.AppendShowMenuItem('����',ActionConfigExecute,True);
end;

procedure TFormBuildingParticular.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormBuildingParticular.FormPaint(Sender: TObject);
begin
  self.Color:= $00EBC4A4;
end;

procedure TFormBuildingParticular.FormShow(Sender: TObject);
begin
  //
end;

procedure TFormBuildingParticular.LoadBuildingInfo;
begin
  if FAnalysistype=1 then
  begin
    FIsSysHandle:= true;
    cxPageControl1.ActivePageIndex:= 0;
    FIsSysHandle:= false;
  end
  else if FAnalysistype=2 then
  begin
    FIsSysHandle:= true;
    cxPageControl1.ActivePageIndex:= 1;
    FIsSysHandle:= false;
  end
  else if FAnalysistype=3 then
  begin
    FIsSysHandle:= true;
    cxPageControl1.ActivePageIndex:= 7;
    FIsSysHandle:= false;
  end;
  cxPageControl1Change(self);
end;

procedure TFormBuildingParticular.SetAnalysistype(const Value: integer);
begin
  FAnalysistype := Value;
end;

procedure TFormBuildingParticular.SetBUILDINGID(const Value: integer);
begin
  FBUILDINGID := Value;
end;

procedure TFormBuildingParticular.SetMTUID(const Value: integer);
begin
  FMTUID := Value;
end;

procedure TFormBuildingParticular.ShowBuildingParticular(aBuildingid,aMtuid: integer);
var
  lWhereStrBuilding,lWhereStrMTU,lWhereStrOther, lWhereStrDRS: string;
  I: integer;
begin
  case FAnalysistype of
    1: begin
         lWhereStrBuilding:= ' and t.buildingid='+inttostr(aBuildingid);
         lWhereStrMTU:= ' and t.buildingid='+inttostr(aBuildingid);
         lWhereStrOther:= ' and t.buildingid='+inttostr(aBuildingid);
         lWhereStrDRS:= ' and t.buildingid='+inttostr(aBuildingid);
       end;
    2: begin
         lWhereStrBuilding:= ' and t.buildingid=(select nvl(buildingid,0) from mtu_info where mtuid='+inttostr(aMtuid)+')';
         lWhereStrMTU:= ' and t.mtuid='+inttostr(aMtuid);
         lWhereStrOther:= ' and 1=2';
         lWhereStrDRS:= ' and 1=2';
       end;
    3: begin
         lWhereStrBuilding:= ' and t.buildingid=(select nvl(buildingid,0) from drs_info where DRSid='+inttostr(aMtuid)+')';
         lWhereStrMTU:= ' and 1=2';
         lWhereStrDRS:= ' and t.DRSid='+inttostr(aMtuid);
         lWhereStrOther:= ' and 1=2';
       end
    else exit;
  end;
  //�ҷֵ�
  if cxPageControl1.ActivePageIndex=0 then
  begin
    VL.Strings.Clear;
    with ClientDataSet1 do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,45,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereStrBuilding]),0);
      if recordcount>0 then
      begin
        SetLength(fFloatField,FieldDefs.Count);
        for i := 0 to FieldDefs.Count-1 do
        begin
          fFloatField[i].Field :=FieldDefs.Items[i].Name;
          fFloatField[i].Value := Fields[i].AsString;
        end;
        for i := Low(fFloatField) to High(fFloatField) do
           VL.InsertRow(fFloatField[i].Field,fFloatField[i].Value,true);
      end;
    end;
  end;
  //����
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    case cxPageControl1.ActivePageIndex of
//      0: Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,48,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
      1:  Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,22,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereStrMTU]),0);
      2:  Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,44,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereStrOther]),0);
      3:  Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,41,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereStrOther]),0);
      4:  Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,11,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereStrOther]),0);
      5:  Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,43,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereStrOther]),0);
      6:  Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,42,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereStrOther]),0);
      7:  Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,46,lWhereStrDRS]),0);
    end;
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormBuildingParticular.ActionConfigExecute(sender: Tobject);
var
  i, lDRS_Index, lRecordIndex, lDRSID: Integer;
begin
  if cxPageControl1.ActivePageIndex<>7 then Exit;

  if not assigned(FrmDRSConfig) then
  begin
    FrmDRSConfig:=TFrmDRSConfig.Create(Self);
    Fm_MainForm.AddToTab(FrmDRSConfig);
  end;
  Fm_MainForm.SetTabIndex(FrmDRSConfig);
  FrmDRSConfig.WindowState:=wsMaximized;
  FrmDRSConfig.Show;

  if cxGrid1DBTableView1.DataController.GetSelectedCount=0 then
  begin
    //���ûѡ��ֱ��վ���Զ���ת��ֱ��վ�༭ҳ�棬���Զ���������ҷֵ���Ϣ
    if Analysistype=3 then
      Application.MessageBox('����ѡ��ֱ��վ��','��ʾ',MB_OK+64)
    else
    begin
      FormDRSInfoMgr.CbBISPROGRAM.ItemIndex:= 0;   //�Ƿ��ҷ�
      for i := 0 to FormDRSInfoMgr.CbBSUBURB.Items.Count - 1 do  //�����־�
      begin
        if TFilterObject(FormDRSInfoMgr.CbBSUBURB.Items.Objects[i]).Suburbid=SUBURBID then
          FormDRSInfoMgr.CbBSUBURB.ItemIndex:=FormDRSInfoMgr.CbBSUBURB.Items.IndexOf(TFilterObject(FormDRSInfoMgr.CbBSUBURB.Items.Objects[i]).SuburbName);
      end;
      for i := 0 to FormDRSInfoMgr.CbBBUILDINGID.Items.Count - 1 do  //�����ҷֵ�
      begin
        if TFilterObject(FormDRSInfoMgr.CbBBUILDINGID.Items.Objects[i]).Buildingid=BUILDINGID then
          FormDRSInfoMgr.CbBBUILDINGID.ItemIndex:=FormDRSInfoMgr.CbBBUILDINGID.Items.IndexOf(TFilterObject(FormDRSInfoMgr.CbBBUILDINGID.Items.Objects[i]).BuildingName);
      end;
    end;
  end;
  if cxGrid1DBTableView1.DataController.GetSelectedCount=1 then
  begin
    //ѡ��һ����¼���С����á����Զ���ת��ֱ��վ�༭ҳ�沢�Զ�������ѡֱ��վ��Ϣ
    lDRS_Index:= cxGrid1DBTableView1.GetColumnByFieldName('DRSID').Index;
    lRecordIndex := cxGrid1DBTableView1.Controller.SelectedRows[0].RecordIndex;
    lDRSID:= cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lDRS_Index);

    lDRS_Index:= FrmDRSConfig.cxGridDBTVDRSList.GetColumnByFieldName('DRSID').Index;
    FrmDRSConfig.CDSDRS.Locate('DRSID',lDRSID,[]);
    FrmDRSConfig.cxGridDBTVDRSList.DataController.ClearSelection;
    for i:=FrmDRSConfig.cxGridDBTVDRSList.DataController.RowCount-1 downto 0 do
    begin
      if lDRSID=FrmDRSConfig.cxGridDBTVDRSList.DataController.GetValue(i,lDRS_Index) then
      begin
        FrmDRSConfig.cxGridDBTVDRSList.DataController.SelectRows(i,i);
        FrmDRSConfig.cxGridDBTVDRSList.Focused:= True;
        Exit;
      end;
    end;
  end;
end;

end.
