unit Ut_MTSTreeHelper;

interface

uses
  Classes,SysUtils,dialogs,ConstDataType,ComCtrls, DBClient,ADODB,Forms,Controls,Variants ;
const FIfShowMTU = true;//�Ƿ���ʾMTU�⼶
type
  TNodeType = (PROVINCE,     //0  ʡ
               CITY,         //1  ����
               AREA,         //2  ����
               SUBURB,       //3  �־�
               INBUILDING,   //4  ����
               OUTBUILDING,  //5  ����
               BUILDING,     //6  �ҷֵ�
               DRSTYPE,      //ֱ��վ״̬�ڵ�
               DRSTYPEOUT,   //ֱ��վ����ڵ�״̬
               DRS,          //ֱ��վ
               MTUTYPEOUT,   //MTU����ڵ�״̬
               WLANTYPE,     //7  WLAN״̬�ڵ�
               PHSTYPE,      //8  PHS״̬�ڵ�
               CDMATYPE,     //9  CDMA״̬�ڵ�
               MTUTYPE,      //10 MTU״̬�ڵ�
               SWITCH,       //11 ������
               CS,
               AP,
               CDMASOURCE,    //CDMA��Դ
               MTU,          //MTU
               MAINLOOKCDMA  //�����C��

               //���� ��Ϊֱ��վ��MTU

               );

  TNodeParam = class(Tobject)
  public
    nodeType            : TNodeType;
    Parentid            : integer;
    DisplayName         : string;    //��ʾ���� ���� ȫ��
    Cityid              : integer;   //���б��
    AreaId              : integer;   //����ID
    Suburbid            : integer;   //�־�ID
    BuildingId          : integer;   //�ҷֵ�ID
    NetType             : integer;   //�ҷֵ���������  PHS / WLAN /PHS+WLAN   չ���ڵ�ʱ��Ҫ�ж�
    SwitchID            : integer;   //��������ID
    CSID                : integer;   //CS
    APID                : integer;   //AP
    CDMAID              : integer;   //CDMA
    MTUID               : integer;   //MTU
    DRSID               : Integer;   //ֱ��վ              
    MAINLOOK_CNET       : integer;   //�����C��
    HaveExpanded        : boolean;
    IsDraw              : boolean;
    DRSAddr             : string;    //DRS��ַ
    DRSPhone            : string;    //DRS�绰
  end;

  TMTSTreeHelper = Class(Tobject)
  private
    Cds_Dynamic: TClientDataSet;
    Cds_Tmp: TClientDataSet;
    Cds_Area: TClientDataSet;
    DataProviderName :String;       // ���ݹ�Ӧ��
    DataServer : Variant;           // ��������AppServer
    BranchIDStr,ZoneIDStr : string; // �ñ������ڱ����û�Ȩ���ڵ�  �־�id
    _GeoTreeTiew : TTreeView;       //�������ͼ
    LevelStop :Integer;             // ��ͼ��������
    DataStrlist : TStringList;      //����ڵ���Ϣ��list;
    CityId,AreaId : integer;        //

    fIsLocateEffect: boolean;
    fPathListIndex: integer;
    FOnlyShowDRS: Boolean;
    procedure GetDRS(ParentNodeParam: TNodeParam);
    procedure GetOUTBuildingWLAN(ParentNodeParam: TNodeParam); //�������MTU��DRS�ڵ�״̬
    procedure GetOUTDRS(ParentNodeParam: TNodeParam); 
    procedure GetOnlyDRS(ParentNodeParam: TNodeParam; aDRSTYPE: TNodeType); //ֻ���DRS�ڵ�״̬ �����ڡ����⣩
  protected
    procedure GetCity(ParentNodeParam: TNodeParam);               //ȫ��
    procedure GetArea(ParentNodeParam : TNodeParam);              //��ȡ����
    procedure GetSuburb(ParentNodeParam : TNodeParam);            //��ȡ�־�
    procedure GetBuilding(ParentNodeParam : TNodeParam);          //��ȡ�ҷֵ�
    procedure GetWLAN(ParentNodeParam : TNodeParam);              //��ȡ��������
    procedure GetSwitch(ParentNodeParam : TNodeParam);            //��ȡ��������
    procedure GetCS(ParentNodeParam : TNodeParam);                //��ȡ��վ��Ϣ
    procedure GetAP(ParentNodeParam : TNodeParam);                //��ȡAP��Ϣ
    procedure GetCDMA(ParentNodeParam : TNodeParam);              //��ȡCDMA��Ϣ
    procedure GetMTU(ParentNodeParam : TNodeParam);               //��ȡ����MTU��Ϣ
    procedure GetMTUOUTBUILDING(ParentNodeParam : TNodeParam);    //��ȡ����MTU��Ϣ
    procedure GetBUILDINGSTATUS(ParentNodeParam : TNodeParam);    //��ȡ�ҷ�״̬��Ϣ
    procedure GetMainLookCDMA(ParentNodeParam : TNodeParam);    //��ȡ�����C��

    procedure FreeObjets(var list : TStringList);
    //������ͼ
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
              var AllowExpansion: Boolean);

  public
    procedure INIT(DsProvName: String; FDataServer : Variant;Cityid,Areaid :integer;FLevelStop:Integer=-1;aISOnlyDRS: Boolean=False);
    procedure DRSSearch(aTree: TTreeView; aText: string);
    destructor Destroy;override;
    //������ͼ,LevelStop  ָ����ֹ���� 
    procedure InitGeoTree(TopNodeinfo :TNodeParam;Var treeView : TTreeView);
//  published
//    property OnlyShowDRS: Boolean read FOnlyShowDRS write FOnlyShowDRS;
  end;

implementation

{ TMTSTreeHelper }

destructor TMTSTreeHelper.Destroy;
begin
  Cds_Dynamic.Close;
  Cds_Dynamic.Free;
  Cds_Tmp.Close;
  Cds_Tmp.Free;
  Cds_Area.Close;
  Cds_Area.Free;
  inherited;
end;

procedure TMTSTreeHelper.FreeObjets(var list: TStringList);
begin
  try
    list.Free;
  finally
    list := TStringList.Create;
  end;
end;

procedure TMTSTreeHelper.GetAP(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,8,ParentNodeParam.SwitchID]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := AP;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId :=ParentNodeParam.BuildingId;
        CityNodeParam.SwitchID :=ParentNodeParam.SwitchID;
        CityNodeParam.APID := FieldByName('APID').AsInteger;
        CityNodeParam.DisplayName :=trim(fieldbyname('APNO').AsString)+'['+Trim(FieldByName('APADDR').AsString)+']';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;

end;

procedure TMTSTreeHelper.GetArea(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    //�м��û�
    if AreaId = 0 then
    begin
      with self.Cds_Dynamic do
      begin
        Close;
        Data :=DataServer.GetCDSData(VarArrayOf([0,2,3,ParentNodeParam.Cityid]),0);
      end;
    end
    else
    begin
      with self.Cds_Dynamic do
      begin
        Close;
        Data :=DataServer.GetCDSData(VarArrayOf([0,2,4,AreaId]),0);
      end;
    end;

    With self.cds_dynamic Do
    begin
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := AREA;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId :=fieldbyname('ID').AsInteger ;
        CityNodeParam.DisplayName :=trim(fieldbyname('name').AsString);
        CityNodeParam.Parentid := ParentNodeParam.Cityid ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetBuilding(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,5,ParentNodeParam.Suburbid]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := Building;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid := ParentNodeParam.Suburbid;
        CityNodeParam.BuildingId :=fieldbyname('buildingid').AsInteger ;//ParentNodeParam.Cityid;
        CityNodeParam.DisplayName :=trim(fieldbyname('buildingname').AsString);
        CityNodeParam.NetType := FieldByName('NETTYPE').AsInteger;
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;

end;

procedure TMTSTreeHelper.GetBUILDINGSTATUS(ParentNodeParam: TNodeParam);
var
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
    FreeObjets(DataStrlist);
  //����
  CityNodeParam := TNodeParam.Create;
  CityNodeParam.nodeType := INBUILDING;
  CityNodeParam.HaveExpanded := false;
  CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
  CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
  CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
  CityNodeParam.DisplayName :='����';
  CityNodeParam.Parentid := ParentNodeParam.Suburbid ;
  DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);

  //����
  CityNodeParam := TNodeParam.Create;
  CityNodeParam.nodeType := OUTBUILDING;
  CityNodeParam.HaveExpanded := false;
  CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
  CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
  CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
  CityNodeParam.DisplayName :='����';
  CityNodeParam.Parentid := ParentNodeParam.Suburbid ;
  DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
end;

procedure TMTSTreeHelper.GetCDMA(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,14,ParentNodeParam.BuildingId]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := CDMASOURCE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId  := ParentNodeParam.BuildingId;
        CityNodeParam.SwitchID :=ParentNodeParam.SwitchID;
        CityNodeParam.CDMAID :=fieldbyname('cdmaid').AsInteger ;
        CityNodeParam.DisplayName :=trim(fieldbyname('cdmaname').AsString);
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetCity(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    //ʡ���û�
    if cityid = 0 then
    begin
      with self.Cds_Dynamic do
      begin
        Close;
        Data :=DataServer.GetCDSData(VarArrayOf([0,2,1]),0);
      end;
    end
    else
    begin
      with self.Cds_Dynamic do
      begin
        Close;
        Data :=DataServer.GetCDSData(VarArrayOf([0,2,2,cityid]),0);
      end;
    end;

    With self.cds_dynamic Do
    begin
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := CITY;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=fieldbyname('ID').AsInteger ;//ParentNodeParam.Cityid;
        CityNodeParam.DisplayName :=trim(fieldbyname('name').AsString);
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetCS(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,7,ParentNodeParam.BuildingId]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := CS;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId  := ParentNodeParam.BuildingId;
        CityNodeParam.SwitchID :=ParentNodeParam.SwitchID;
        CityNodeParam.CSID :=fieldbyname('csid').AsInteger ;//ParentNodeParam.Cityid;
        CityNodeParam.DisplayName :=trim(fieldbyname('netaddress').AsString);
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetMainLookCDMA(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,76,ParentNodeParam.MAINLOOK_CNET]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := MAINLOOKCDMA;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId  := ParentNodeParam.Parentid;
        CityNodeParam.MTUID := ParentNodeParam.MTUID ;
        CityNodeParam.DisplayName := trim(fieldbyname('cdmaname').AsString);
        CityNodeParam.Parentid := ParentNodeParam.MTUID ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetMTU(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,63,' and buildingid='+inttostr(ParentNodeParam.BuildingId)]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := MTU;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId  := ParentNodeParam.BuildingId;
        CityNodeParam.MTUID :=fieldbyname('mtuid').AsInteger ;
        CityNodeParam.MAINLOOK_CNET:= fieldbyname('mainlook_cnet').AsInteger ;
        CityNodeParam.DisplayName :=trim(fieldbyname('mtuno').AsString);
        CityNodeParam.Parentid := ParentNodeParam.BuildingId;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetMTUOUTBUILDING(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,63,' and buildingid = -1 and suburbid='+inttostr(ParentNodeParam.Suburbid)]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := MTU;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId  := 0;
        CityNodeParam.MTUID :=fieldbyname('mtuid').AsInteger ;
        CityNodeParam.MAINLOOK_CNET:= fieldbyname('mainlook_cnet').AsInteger ;
        CityNodeParam.DisplayName :=trim(fieldbyname('mtuno').AsString);
        CityNodeParam.Parentid := 0;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetSuburb(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,16,ParentNodeParam.AreaId]),0);
    end;

    With self.cds_dynamic Do
    begin
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := SUBURB;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=fieldbyname('ID').AsInteger ;
        CityNodeParam.DisplayName :=trim(fieldbyname('name').AsString);
        CityNodeParam.Parentid := ParentNodeParam.AreaId ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetSwitch(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,6,ParentNodeParam.BuildingId]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := Switch;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId  := ParentNodeParam.BuildingId;
        CityNodeParam.SwitchID :=fieldbyname('switchid').AsInteger ;//ParentNodeParam.Cityid;
        CityNodeParam.DisplayName :=trim(fieldbyname('switchno').AsString);
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetOnlyDRS(ParentNodeParam: TNodeParam; aDRSTYPE: TNodeType);
var
  CityNodeParam : TNodeParam;
begin
  //���ֱ��վ�ڵ�
  CityNodeParam := TNodeParam.Create;
  CityNodeParam.nodeType := aDRSTYPE;
  CityNodeParam.HaveExpanded :=false;
  CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
  CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
  CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
  CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
  CityNodeParam.DisplayName :='DRS';
  CityNodeParam.Parentid := 0 ;
  DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
end;

procedure TMTSTreeHelper.GetWLAN(ParentNodeParam: TNodeParam);
var
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  case ParentNodeParam.NetType of
    1 :
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := PHSTYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='PHS';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
      end;
    2 :
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := WLANTYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='WLAN';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
      end;
    3 :
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := PHSTYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='PHS';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);

        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := WLANTYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='WLAN';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
      end;
    4 :
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := CDMATYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='CDMA';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
      end;
    5 :
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := PHSTYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='PHS';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);

        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := CDMATYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='CDMA';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
      end;
    6 :
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := WLANTYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='WLAN';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);

        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := CDMATYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='CDMA';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
      end;
    7 :
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := WLANTYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='WLAN';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);

        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := CDMATYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='CDMA';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);

        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := PHSTYPE;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
        CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
        CityNodeParam.DisplayName :='PHS';
        CityNodeParam.Parentid := 0 ;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
      end;
  end;
  //���ֱ��վ�ڵ�
  CityNodeParam := TNodeParam.Create;
  CityNodeParam.nodeType := DRSTYPE;
  CityNodeParam.HaveExpanded :=false;
  CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
  CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
  CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
  CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
  CityNodeParam.DisplayName :='DRS';
  CityNodeParam.Parentid := 0 ;
  DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);

  if FIfShowMTU then
  begin
    CityNodeParam := TNodeParam.Create;
    CityNodeParam.nodeType := MTUTYPE;
    CityNodeParam.HaveExpanded :=false;
    CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
    CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
    CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
    CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
    CityNodeParam.DisplayName :='MTU';
    CityNodeParam.Parentid := 0 ;
    DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
  end;
end;

procedure TMTSTreeHelper.GetOUTBuildingWLAN(ParentNodeParam: TNodeParam);
var
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  //���ֱ��վ�ڵ�״̬
  CityNodeParam := TNodeParam.Create;
  CityNodeParam.nodeType := DRSTYPEOUT;
  CityNodeParam.HaveExpanded :=false;
  CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
  CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
  CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
  CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
  CityNodeParam.DisplayName :='DRS';
  CityNodeParam.Parentid := 0 ;
  DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
  //���MTU�ڵ�״̬
  CityNodeParam := TNodeParam.Create;
  CityNodeParam.nodeType := MTUTYPEOUT;
  CityNodeParam.HaveExpanded :=false;
  CityNodeParam.Cityid :=ParentNodeParam.Cityid ;
  CityNodeParam.AreaId :=ParentNodeParam.AreaId ;
  CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
  CityNodeParam.BuildingId := ParentNodeParam.BuildingId;
  CityNodeParam.DisplayName :='MTU';
  CityNodeParam.Parentid := 0 ;
  DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
end;

procedure TMTSTreeHelper.INIT(DsProvName: String; FDataServer: Variant;Cityid,Areaid :integer;FLevelStop:Integer;aISOnlyDRS: Boolean);
begin
  DataServer := FDataServer;
  DataProviderName :=DsProvName;
  self.LevelStop := FLevelStop;
  self.CityId := Cityid;
  self.AreaId := Areaid;
  Self.FOnlyShowDRS:= aISOnlyDRS;
  
  Cds_Dynamic := TClientDataSet.Create(nil);
  Cds_Dynamic.ProviderName := DataProviderName;
  Cds_Dynamic.Close;
  
  Cds_Tmp := TClientDataSet.Create(nil);
  Cds_Tmp.ProviderName := DataProviderName;
  Cds_Tmp.Close;

  Cds_Area := TClientDataSet.Create(nil);
  Cds_Area.ProviderName := DataProviderName;
  Cds_Area.Close;
  
  BranchIDStr :=''; //��ʼ��Ϊδ����Ȩ�޻���
  ZoneIDStr :='-1'; //��ʼ��Ϊ��1 ����Ϊ��ʱ ��ʾ���û�û���κ�����Ȩ��
  DataStrlist := TStringList.Create;
end;

procedure TMTSTreeHelper.InitGeoTree(TopNodeinfo :TNodeParam;Var treeView : TTreeView);
var
  i : integer;
  TopTreeNode,ChildNode : TTreeNode;
  lFirstNode: TTreeNode;
begin

  _GeoTreeTiew := TreeView;
  _GeoTreeTiew.OnExpanding :=TreeViewExpanding;
  TopTreeNode:=_GeoTreeTiew.Items.AddObject(nil,TopNodeinfo.DisplayName,
                        TopNodeinfo);
  TopTreeNode.ImageIndex :=0;
  TopTreeNode.SelectedIndex :=0;
  //��ȡ��Ч������Ϣ
  GetCity(TopNodeInfo);

  //---���������ṹ����
  for i := 0 to DataStrlist.Count-1 do
  begin
   ChildNode:= _GeoTreeTiew.Items.AddChildObject(TopTreeNode,DataStrlist.Strings[i],DataStrlist.Objects[i]);
    _GeoTreeTiew.Items.AddChild(ChildNode,'temp');
    ChildNode.ImageIndex :=1;
    ChildNode.SelectedIndex :=1;
  end;
  _GeoTreeTiew.Items[0].Expanded := true;
  //��������
  lFirstNode:= _GeoTreeTiew.Items[0].getFirstChild;
  while lFirstNode<>nil do
  begin
    if (lFirstNode.Data<>nil)
    and (TNodeParam(lFirstNode.Data).nodeType = CITY) then
    begin
      lFirstNode.Expand(false);
    end;
    lFirstNode:= lFirstNode.getNextSibling;
  end;
end;

procedure TMTSTreeHelper.GetDRS(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,77,' and buildingid='+inttostr(ParentNodeParam.BuildingId)]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := DRS;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId  := ParentNodeParam.BuildingId;
        CityNodeParam.DRSID :=fieldbyname('DRSid').AsInteger ;
        CityNodeParam.DisplayName :=trim(fieldbyname('DRSName').AsString);
        CityNodeParam.Parentid := ParentNodeParam.BuildingId;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.GetOUTDRS(ParentNodeParam: TNodeParam);
var
  i : integer;
  CityNodeParam : TNodeParam;
begin
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  try
    with self.Cds_Dynamic do
    begin
      Close;
      Data :=DataServer.GetCDSData(VarArrayOf([0,2,78,' and buildingid = -1 and suburbid='+inttostr(ParentNodeParam.Suburbid)]),0);
      If IsEmpty Then exit ;
      First;
      for i := 0 to RecordCount-1 do
      begin
        CityNodeParam := TNodeParam.Create;
        CityNodeParam.nodeType := DRS;
        CityNodeParam.HaveExpanded :=false;
        CityNodeParam.Cityid := ParentNodeParam.Cityid;
        CityNodeParam.AreaId := ParentNodeParam.AreaId;
        CityNodeParam.Suburbid :=ParentNodeParam.Suburbid ;
        CityNodeParam.BuildingId  := 0;
        CityNodeParam.DRSID :=fieldbyname('DRSid').AsInteger ;
        CityNodeParam.DisplayName :=trim(fieldbyname('DRSName').AsString);
        CityNodeParam.Parentid := 0;
        DataStrlist.AddObject(CityNodeParam.DisplayName,CityNodeParam);
        Next;
      end;
    end;
  except
  end;
end;

procedure TMTSTreeHelper.TreeViewExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var
  i : integer;
  ChildNode : TTreeNode;
begin
  if node.Level=0 then exit;
  Screen.Cursor := crHourGlass ;
  If DataStrlist.Count> 0 Then
     FreeObjets(DataStrlist);
  case TNodeParam(Node.Data).nodeType of
  CITY: //����
    if TNodeParam(node.Data).HaveExpanded=false then
    begin
      Node.DeleteChildren;
      GetArea(TNodeParam(node.Data));
      if DataStrlist.Count<>0 then
        for i:=0 to DataStrlist.Count-1 do
          begin
            ChildNode:=_GeoTreeTiew.Items.AddChildObject(Node,DataStrlist[i],DataStrlist.Objects[i]);
            ChildNode.ImageIndex:=2;
            ChildNode.SelectedIndex:=2;
            if (Self.LevelStop=-1) or (Self.LevelStop > Ord(AREA)) then
              _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
          end;
      TNodeParam(node.Data).HaveExpanded:=true;
    end;
  Area ://����չ����ʾ�־�
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetSuburb(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then
        begin
           for i:=0 to DataStrlist.Count-1 do
           begin
               ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
               ChildNode.ImageIndex:=7;
               ChildNode.SelectedIndex:=7;
               if (Self.LevelStop= -1) or (Self.LevelStop > Ord(SUBURB)) then
                _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
           end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  SUBURB:  //�־�չ����ʾ ����/����
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetBUILDINGSTATUS(TNodeParam(node.Data));
        if DataStrlist.Count <> 0 Then
        begin
          for i:=0 to DataStrlist.Count-1 do
           begin
               ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
               ChildNode.ImageIndex:=11;
               ChildNode.SelectedIndex:=11;
                _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
           end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  INBUILDING:
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetBuilding(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then
        begin
          for i:=0 to DataStrlist.Count-1 do
          begin
              ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
              ChildNode.ImageIndex:=3;
              ChildNode.SelectedIndex:=3;
              if (Self.LevelStop= -1) or (Self.LevelStop > Ord(BUILDING)) then
               _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
          end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  OUTBUILDING:
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        if FOnlyShowDRS then
          GetOnlyDRS(TNodeParam(node.Data),DRSTYPEOUT)
        else
          GetOUTBuildingWLAN(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then
        begin
          for i:=0 to DataStrlist.Count-1 do
          begin
            ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
            ChildNode.ImageIndex:=4;
            ChildNode.SelectedIndex:=4;
            if (Self.LevelStop= -1) or (Self.LevelStop > Ord(MTUTYPEOUT)) or (Self.LevelStop > Ord(DRSTYPEOUT)) then
             _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
          end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  BUILDING :       //¥��չ����ʾ WLAN��PHS
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        if FOnlyShowDRS then
          GetOnlyDRS(TNodeParam(node.Data),DRSTYPE)
        else
          GetWLAN(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then 
        begin
           for i:=0 to DataStrlist.Count-1 do
           begin
             ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
             ChildNode.ImageIndex:=4;
             ChildNode.SelectedIndex:=4;
             if (Self.LevelStop = -1) or ((Self.LevelStop > Ord(WLANTYPE)) or (Self.LevelStop > Ord(PHSTYPE))
                or (Self.LevelStop > Ord(DRSTYPE)))  then
               _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
           end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  MTUTYPE  :
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetMTU(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then   
        begin
           for i:=0 to DataStrlist.Count-1 do
           begin
             ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
             ChildNode.ImageIndex:=37;
             ChildNode.SelectedIndex:=37;
              _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
           end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  WLANTYPE :       //¥��չ����ʾ WLAN��PHS
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetSwitch(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then  
        begin
           for i:=0 to DataStrlist.Count-1 do
           begin
               ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
               _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
               ChildNode.ImageIndex:=18;
               ChildNode.SelectedIndex:=18;
           end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  PHSTYPE :
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetCS(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then
        begin
           for i:=0 to DataStrlist.Count-1 do
           begin
               ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
               ChildNode.ImageIndex:=5;
               ChildNode.SelectedIndex:=5;
           end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  CDMATYPE :
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetCDMA(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then
        begin
           for i:=0 to DataStrlist.Count-1 do
           begin
               ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
               ChildNode.ImageIndex:=5;
               ChildNode.SelectedIndex:=5;
           end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  SWITCH :
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetAP(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then
        begin
           for i:=0 to DataStrlist.Count-1 do
           begin
             ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
             ChildNode.ImageIndex:=6;
             ChildNode.SelectedIndex:=6;
           end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  MTU :
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetMainLookCDMA(TNodeParam(node.Data));
        if DataStrlist.Count <> 0 Then
        begin
          for i:=0 to DataStrlist.Count-1 do
          begin
            ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
            ChildNode.ImageIndex:=20;
            ChildNode.SelectedIndex:=20;
          end;
        end;
      end;
    end;
  DRSTYPEOUT:
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetOUTDRS(TNodeParam(node.Data));
        if DataStrlist.Count <> 0 Then
        begin
          for i:=0 to DataStrlist.Count-1 do
          begin
            ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
            ChildNode.ImageIndex:=16;
            ChildNode.SelectedIndex:=16;
          end;
        end;
      end;
    end;
  MTUTYPEOUT:
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetMTUOUTBUILDING(TNodeParam(node.Data));
        If DataStrlist.Count <> 0 Then
        begin
          for i:=0 to DataStrlist.Count-1 do
          begin
            ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
            ChildNode.ImageIndex:=37;
            ChildNode.SelectedIndex:=37;
            if (Self.LevelStop= -1) or (Self.LevelStop > Ord(MTU)) then
             _GeoTreeTiew.Items.AddChild(ChildNode,'aa');
          end;
        end;
        TNodeParam(node.Data).HaveExpanded:=true;
      end;
    end;
  DRSTYPE :
    begin
      if TNodeParam(node.Data).HaveExpanded=false then
      begin
        node.DeleteChildren;
        GetDRS(TNodeParam(node.Data));
        if DataStrlist.Count <> 0 Then
        begin
          for i:=0 to DataStrlist.Count-1 do
          begin
            ChildNode:=_GeoTreeTiew.Items.AddChildObject(node,DataStrlist[i],DataStrlist.Objects[i]);
            ChildNode.ImageIndex:=16;
            ChildNode.SelectedIndex:=16;
          end;
        end;
      end;
    end;
  end;
  Screen.Cursor := crDefault;
end;

//ֱ��վ����������ֱ��վ��š����ơ���ַ���绰����ȶ�λ����Ӧֱ��վ
procedure TMTSTreeHelper.DRSSearch(aTree: TTreeView; aText: string);
var
  i: Integer;
  lSqlStr, lWhereStr: string;
  ltopNode, ltmpNode :TTreeNode;
  lNodeInfo: TNodeParam;
begin
  lWhereStr:= ' where drsphone='+aText+
              ' or drsadress='''+aText+''''+
              ' or drsno='+aText+
              ' or drsname='''+aText+'''';
  aTree.Items.Clear;
  lNodeInfo :=TNodeParam.Create;
  lNodeInfo.nodeType:=PROVINCE;
  lNodeInfo.Cityid:=0;
  lNodeInfo.AreaId:=0;
  lNodeInfo.DisplayName:='ȫʡ';
  ltmpNode:= aTree.Items.AddObject(nil,lNodeInfo.DisplayName,lNodeInfo);
  //city  2,4,13
  With self.cds_dynamic Do
  begin
    Close;
    lSqlStr:= 'select distinct cityid,cityname from drs_info_view ' + lWhereStr;
    Data :=DataServer.GetCDSData(VarArrayOf([2,4,13,lSqlStr]),0);
    If IsEmpty Then exit ;
    First;
    for i := 0 to RecordCount-1 do
    begin
      lNodeInfo := TNodeParam.Create;
      lNodeInfo.nodeType := CITY;
      lNodeInfo.HaveExpanded :=false;
      lNodeInfo.Cityid :=fieldbyname('ID').AsInteger ;//ParentNodeParam.Cityid;
      lNodeInfo.DisplayName :=trim(fieldbyname('name').AsString);
      lNodeInfo.Parentid := 0 ;
      aTree.Items.AddChildObject(ltmpNode,lNodeInfo.DisplayName,lNodeInfo);
      Next;
    end;
  end;
end;

end.
