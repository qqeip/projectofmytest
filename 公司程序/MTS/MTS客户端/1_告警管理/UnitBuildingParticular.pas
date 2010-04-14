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
    //1 室分点 2 MTU 3 DRS
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
         AddViewField(cxGrid1DBTableView1,'mtuid','内部编号');
         AddViewField(cxGrid1DBTableView1,'mtuno','MTU编号');
         AddViewField(cxGrid1DBTableView1,'mtuname','MTU名称');
         AddViewField(cxGrid1DBTableView1,'mtutypename','MTU类型');
         AddViewField(cxGrid1DBTableView1,'longitude','经度');
         AddViewField(cxGrid1DBTableView1,'latitude','纬度');
         AddViewField(cxGrid1DBTableView1,'linkno','上端连接器');
         AddViewField(cxGrid1DBTableView1,'call','电话号码');
         AddViewField(cxGrid1DBTableView1,'called','被叫号码');
         AddViewField(cxGrid1DBTableView1,'modelname','告警门限模板');
         AddViewField(cxGrid1DBTableView1,'mainlook_apname','主监控AP');
         AddViewField(cxGrid1DBTableView1,'mainlook_phsname','主监控PHS');
         AddViewField(cxGrid1DBTableView1,'mainlook_cnetname','主监控C网');
         AddViewField(cxGrid1DBTableView1,'mtuaddr','MTU位置');
         AddViewField(cxGrid1DBTableView1,'overlay','覆盖范围');
         AddViewField(cxGrid1DBTableView1,'isprogramname','是否室分');
         AddViewField(cxGrid1DBTableView1,'buildingname','室分点名称');
         AddViewField(cxGrid1DBTableView1,'suburbname','分局');
         AddViewField(cxGrid1DBTableView1,'shieldstatusname','是否屏蔽');
       end;
    2: begin
         AddViewField(cxGrid1DBTableView1,'apid','内部编号');
         AddViewField(cxGrid1DBTableView1,'apno','AP编号');
         AddViewField(cxGrid1DBTableView1,'connecttypename','连接类型');
         AddViewField(cxGrid1DBTableView1,'apport','对应端口');
         AddViewField(cxGrid1DBTableView1,'factoryname','供应商');
         AddViewField(cxGrid1DBTableView1,'apkindname','AP型号');
         AddViewField(cxGrid1DBTableView1,'appropertyname','AP性质');
         AddViewField(cxGrid1DBTableView1,'appower','功率');
         AddViewField(cxGrid1DBTableView1,'powerkindname','供电方式');
         AddViewField(cxGrid1DBTableView1,'frequency','频点');
         AddViewField(cxGrid1DBTableView1,'apaddr','AP地址');
         AddViewField(cxGrid1DBTableView1,'overlay','覆盖范围');
         AddViewField(cxGrid1DBTableView1,'manageaddrseg','AP管理地址段');
         AddViewField(cxGrid1DBTableView1,'apip','APIP');
         AddViewField(cxGrid1DBTableView1,'gwaddr','网关地址');
         AddViewField(cxGrid1DBTableView1,'macaddr','MAC地址');
         AddViewField(cxGrid1DBTableView1,'businessvlan','业务VLAN');
         AddViewField(cxGrid1DBTableView1,'managevlan','管理VLAN');
         AddViewField(cxGrid1DBTableView1,'switchno','所属交换机');
         AddViewField(cxGrid1DBTableView1,'buildingname','所属室分点');
         AddViewField(cxGrid1DBTableView1,'suburbname','所属分局');
       end;
    3: begin
         AddViewField(cxGrid1DBTableView1,'CSID','内部编号');
         AddViewField(cxGrid1DBTableView1,'CS_ID','CS_ID');
         AddViewField(cxGrid1DBTableView1,'SURVERY_ID','堪点编号');
         AddViewField(cxGrid1DBTableView1,'NETADDRESS','网元信息');
         AddViewField(cxGrid1DBTableView1,'CSADDR','基站地址');
         AddViewField(cxGrid1DBTableView1,'CS_COVER','覆盖范围');
         AddViewField(cxGrid1DBTableView1,'CS_TYPENAME','基站类型');
         AddViewField(cxGrid1DBTableView1,'suburbname','所属分局');
         AddViewField(cxGrid1DBTableView1,'BUILDINGNAME','所属室分点');
       end;
    4: begin
         AddViewField(cxGrid1DBTableView1,'CDMAID','内部编号');
         AddViewField(cxGrid1DBTableView1,'cdmano','信源编号');
         AddViewField(cxGrid1DBTableView1,'cdmaname','信源名称');
         AddViewField(cxGrid1DBTableView1,'cdmatypename','信源类型');
         AddViewField(cxGrid1DBTableView1,'longitude','经度');
         AddViewField(cxGrid1DBTableView1,'latitude','纬度');
         AddViewField(cxGrid1DBTableView1,'belong_msc','归属MSC编号');
         AddViewField(cxGrid1DBTableView1,'belong_bsc','归属BSC编号');
         AddViewField(cxGrid1DBTableView1,'belong_cell','归属扇区编号');
         AddViewField(cxGrid1DBTableView1,'belong_bts','归属基站编号');
         AddViewField(cxGrid1DBTableView1,'pncode','PN 码');
         AddViewField(cxGrid1DBTableView1,'devicetypename','设备型号');
         AddViewField(cxGrid1DBTableView1,'factorytypename','信源厂家');
         AddViewField(cxGrid1DBTableView1,'powertypename','信源功率');
         AddViewField(cxGrid1DBTableView1,'address','安装位置');
         AddViewField(cxGrid1DBTableView1,'cover','覆盖范围');
         AddViewField(cxGrid1DBTableView1,'isprogramname','是否室分');
         AddViewField(cxGrid1DBTableView1,'buildingname','室分点名称');
         AddViewField(cxGrid1DBTableView1,'suburbname','分局');
       end;
    5: begin
         AddViewField(cxGrid1DBTableView1,'SWITCHID','内部编号');
         AddViewField(cxGrid1DBTableView1,'switchno','交换机信息');
         AddViewField(cxGrid1DBTableView1,'uplinkport','上连端口');
         AddViewField(cxGrid1DBTableView1,'macaddr','物理地址');
         AddViewField(cxGrid1DBTableView1,'manageaddr','管理地址');
         AddViewField(cxGrid1DBTableView1,'POP','ＰＯＰ');
         AddViewField(cxGrid1DBTableView1,'suburbname','所属分局');
         AddViewField(cxGrid1DBTableView1,'buildingname','所属室分点');
       end;
    6: begin
         AddViewField(cxGrid1DBTableView1,'LINKID','内部编号');
         AddViewField(cxGrid1DBTableView1,'linkno','连接器编号');
         AddViewField(cxGrid1DBTableView1,'linkaddr','连接器位置');
         AddViewField(cxGrid1DBTableView1,'linktype','连接器类型');
         AddViewField(cxGrid1DBTableView1,'linktype','是否干放');
         AddViewField(cxGrid1DBTableView1,'trunkaddr','干放位置');
         AddViewField(cxGrid1DBTableView1,'linkequipment','连接设备类型');
         AddViewField(cxGrid1DBTableView1,'linkcs','连接基站');
         AddViewField(cxGrid1DBTableView1,'linkap','连接AP');
         AddViewField(cxGrid1DBTableView1,'linkcdma','连接CDMA');
         AddViewField(cxGrid1DBTableView1,'suburbname','所属分局');
         AddViewField(cxGrid1DBTableView1,'BUILDINGNAME','所属室分点');
       end;
    7: begin
         AddViewField(cxGrid1DBTableView1,'DRSID','直放站ID');
         AddViewField(cxGrid1DBTableView1,'DRSNO','直放站编号');
         AddViewField(cxGrid1DBTableView1,'R_DEVICEID','设备编号');
         AddViewField(cxGrid1DBTableView1,'DRSNAME','直放站名称');
         AddViewField(cxGrid1DBTableView1,'DRSTYPENAME','直放站类型');
         AddViewField(cxGrid1DBTableView1,'DRSMANUNAME','直放站厂家');
         AddViewField(cxGrid1DBTableView1,'DRSADRESS','地址');
         AddViewField(cxGrid1DBTableView1,'DRSPHONE','电话号码');
       end;
  end;
end;

procedure TFormBuildingParticular.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);
  FMenuConfig:= FCxGridHelper.AppendShowMenuItem('配置',ActionConfigExecute,True);
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
  //室分点
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
  //其他
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
    //如果没选中直放站，自动跳转到直放站编辑页面，并自动加载相关室分点信息
    if Analysistype=3 then
      Application.MessageBox('请先选择直放站！','提示',MB_OK+64)
    else
    begin
      FormDRSInfoMgr.CbBISPROGRAM.ItemIndex:= 0;   //是否室分
      for i := 0 to FormDRSInfoMgr.CbBSUBURB.Items.Count - 1 do  //所属分局
      begin
        if TFilterObject(FormDRSInfoMgr.CbBSUBURB.Items.Objects[i]).Suburbid=SUBURBID then
          FormDRSInfoMgr.CbBSUBURB.ItemIndex:=FormDRSInfoMgr.CbBSUBURB.Items.IndexOf(TFilterObject(FormDRSInfoMgr.CbBSUBURB.Items.Objects[i]).SuburbName);
      end;
      for i := 0 to FormDRSInfoMgr.CbBBUILDINGID.Items.Count - 1 do  //所属室分点
      begin
        if TFilterObject(FormDRSInfoMgr.CbBBUILDINGID.Items.Objects[i]).Buildingid=BUILDINGID then
          FormDRSInfoMgr.CbBBUILDINGID.ItemIndex:=FormDRSInfoMgr.CbBBUILDINGID.Items.IndexOf(TFilterObject(FormDRSInfoMgr.CbBBUILDINGID.Items.Objects[i]).BuildingName);
      end;
    end;
  end;
  if cxGrid1DBTableView1.DataController.GetSelectedCount=1 then
  begin
    //选择一条记录进行“配置”则自动跳转到直放站编辑页面并自动加载所选直放站信息
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
