unit Ut_Common;

interface
uses
  Classes, DB, Jpeg, ExtCtrls, DBClient, Windows, SysUtils, Forms, StdCtrls,
  Variants, DBGrids, Messages, Dialogs, ComCtrls,ComObj, StringUtils,cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid,StrUtils, Graphics, DateUtils, md5,ExcelXP, OleServer, Controls,Spin, AdvGridUnit, AdvGrid,
  cxDataStorage;

const
  ADDFLAG = 1;
  MODIFYFLAG = 2;
  CANCELFLAG = 3;
  DELETEFLAG = 4;
  Queryflag =5;

  //日期设置
  DateValueIndexToday = 0;
  DateValueIndexYesterday = 1;
  DateValueIndexLastWeek = 2;
  DateValueIndexTwoWeeksAgo = 3;
  DateValueIndexOlder = 4;

  MTS_SUBURB   = 701;
  MTS_BUILDING = 702;
  MTS_AP       = 703;
  MTS_LINK     = 704;
  MTS_PHS      = 705;
  MTS_CDMA     = 706;
Type
  PByte = Array[1..7] of Array of String ; //个性查询
  TDBGridRec=^TDBGridSet;
  TDBGridSet = record
     TitleAlignment : TAlignment;
     TitleCaption : String;
     FieldName :String;
     ColAlignment : TAlignment;
     ColumnWidth : integer;
     ColumnShow : boolean;
  end;

  TFilterObject = class
    Suburbid: integer;
    SuburbName: string;
    Buildingid: integer;
    BuildingName: string;
    Captionid: integer;   //实际的ITEM对象值
    CaptionName: string;  //实际的ITEM显示内容
    Longitude: string;
    Latitude: string;
  end;

  TCommonObj = class
    ID : integer;
    Name : String;
    No : string;
  end;

  TParamObj = class
    ID : integer;
    Name : String;
    Value: String;
  end;

  TConnInfoObj = class
    ID : integer;
    Name : String;
    CONNTELE : String;
    DEPTNAME : String;
  end;

  TCamTree = class(TObject)
      ID : Integer;
      Name : String;
      types : Integer;
      ParentID : Integer;
      flag : integer; // 0:  1:辖区
  end;

  TPicInfo = Record
    picorder: integer;
    //scandoc:  TImage;
    fileformat: integer;
    uploadip : string;
    uploadpath: string;
    piccaption: string;
    uploaduser: integer;
    uploadtime: TDatetime;
    ismodify: boolean;
    OBJSIZE: String; //对象大小
    OBJTYPE: String; //对像类型
    MODIFYDATE:	String; //修改日期
    IMAGEINDEX: integer; //图标索引   
  end;
  
var
  fIsLocateEffect: boolean;
  fPathListIndex: integer;
  StreamInfo: array of TPicInfo;

  //检查必填值，如不正确，则返回false，同时incorrectValue参数返回不正确的标签值
  function CheckFillValue(TheCase: TWinControl; var incorrectValue: String):boolean;

  //将指定日期值保存到数据库的转换函数，HoldTime=false表示不保留时间部份
  function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
  function GetDateValueIndex(ADate: TDateTime): Integer;
  function GetGroupDateDisplayText(ADate: TDateTime): string;
  function StringToAlignment(StrAlignment:string):TAlignment;

  procedure MyKeyPress(frm:TForm; var Key: Char);
  procedure FreeButton(FormTag:integer);
  procedure LoadPicture(theField: TField;Mode: TBlobStreamMode;theImage: TImage);

  procedure InPutNum(var key: Char);
  procedure InPutfloat(var key: Char);
  function GetCDSData(aValue:OleVariant; DspID:integer=0):OleVariant;       //打开数据集
  function ExecTheSQL(aValue:OleVariant):boolean;
  //combobox 操作
  procedure InitComboBox(OwnerData:Variant; var Box:TComboBox);
  procedure InitConnInfoBox(OwnerData:Variant; var Box:TComboBox);
  Function GetIdFromObj(Box:TComboBox):Integer;
  Procedure GotoCmbIndex(Box:TComboBox;index:integer);
  function GetNameById(Box:TComboBox;Id:integer):String;
  //获取系统参数值
  function GetSysParamSet(Id,Kind :integer):String;

  //释放
  procedure DestroyCBObj(Box: TComboBox);
  procedure DestroyConnInfoBox(Box: TComboBox);

  //导出指定DBGrid中的数据到Excel中
  function ExportDataToExcel(DBGrid:TDBGrid; prompted: Boolean=true):String; overload ;


  function RetrieveDeltas(const cdsArray : array of TClientDataset): Variant;
  function RetrieveProviders(const cdsArray : array of TClientDataset): Variant;
  procedure ReconcileDeltas(const cdsArray : array of TClientDataset; vDeltaArray: OleVariant);
  procedure ReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);


  function GetPYIndexChar( hzchar:string):char;
  function GetPinMa(SourceStrs: String):String;

  //用户权限
  function GetFunArray(list :TStrings):OleVariant;
  //用户密码
  function LogEntry(Dig: MD5Digest): string;

  Procedure CopyPicData(PROID,RenewID,ChangingID: Integer; var SourceCDS, TargetCDS: TClientDataset; OnLineToHistory:Boolean=true);
  Procedure CopyAccessoryData(PROID,RenewID,ChangingID: Integer; var SourceCDS, TargetCDS: TClientDataset; OnLineToHistory:Boolean=true);

  //释放
  procedure FreeandNilTB(theTB:TToolBar);
  //
  Function CheckCondition(ThePanel:TPanel):Boolean;
  //根据指定的Panel获得where字句
  procedure BuildWhereSql(ThePanel:TPanel;Var Arr_searchCon :PByte);
  //根据给定的Tag查找相同Tag的控件
  Function GetCtrFromTag(ThePanel:TPanel;theTag:Integer;islabel:Boolean):Integer;
  //获取系统参数
  Function GetParam(Kind,itemcode:Integer):String ;
  //获取新的字典编号
  function GetNewDicCode(dictype:integer):integer;
  procedure InitTree(GeoTreeView:TTreeview;Cityid,Areaid :integer;FLevelStop:integer=-1;aISOnlyDRS: Boolean=False);
  //获取手指定序列的新值 参数:序列名称
  function GetTheSequenceId(Sequence:String):integer;
  //删除资源管理
  function DelFromGrid(lValue:integer;SqlIndex:integer):boolean;
  function HasChild(lValue:integer;SqlIndex:integer):boolean;
  //根据区域取他的所有叶子信息
  function GetAreaChildLeaf(aFirstID : integer):string;
  //根据权限取区域权限值  目前权限到行政区
  function GetPriveArea(aCityid,aAreaid :integer):String;
  //根据权限加载分局
  procedure LoadSuburb(aCityid,aAreaid :integer;Items:TStrings);
  procedure LoadBuilding(aCityid,aAreaid :integer;Items:TStrings);
  //室分点模糊匹配关键字
  procedure DarkMatch_BUILDING(aCityid,aAreaid: integer; aMatchField,aMatchValue :String;Items:TStrings);
  //取字典表
  procedure GetDic(aDicType:integer;DicCodeItems:TStrings);
  //取对象值
  function GetDicCode(DicName:string;Items:TStrings):integer;
  function GetItemIndex(DicName:string;Items:TStrings):integer;
  function GetItemByObject(aObjectid:integer;Items:TStrings):integer;
  procedure DeleteFromGrid(aGrid:TAdvStringGrid;aRowIndex:integer);
  procedure AutoSizeCol(aGridView:TcxGridDBTableView;const ACol: Integer);
  //加字段
  procedure AddViewField(aView : TcxGridDBTableView;aFieldName, aCaption : String; aWidth: integer=65; blVisible: boolean= true);overload;
  function CheckRecordSelected(aView :TcxGridDBTableView):boolean;
  //取加权限设备内容
  procedure GetSuburbInfo(aItems:TStrings);
  procedure GetBuildingInfo(aItems:TStrings);
  procedure GetAPInfo(aItems:TStrings);
  procedure GetPHSInfo(aItems:TStrings);
  procedure GetCNETInfo(aItems:TStrings);
  procedure GetLinkInfo(aItems:TStrings);
  procedure GetSwitchInfo(aItems:TStrings);
  procedure GetCSInfo(aItems:TStrings);
  procedure GetResInfo(aItems:TStrings;param1,param2,param3,param4,aCondition:string);
  function IsExistRelated(aID: Integer; aItems: TStrings; aStr: string): Boolean;
  function GetCaptionid(aCaptionName: string; aItems: TStrings):integer;
  //复制List   aList1->aList2
  procedure CopyList(aList1,aList2: TStrings);
  procedure FilterList(aList1,aList2: TStrings; aFileType, aFilterValue: integer);
  //是否存在
  function IsExists(aTableName,aFieldName,aName: string; aKeyName: string=''; aid: integer=-1): boolean;

  //树图定位
  function JudgeNode(aText1,aText2: string):boolean;
  function GetLocateFirstNode(aTreeView: TTreeView; aPathList: TStringList):TTreeNode;overload;
  function GetLocateFirstNode(aTopNode: TTreeNode; aKeyValue: string):TTreeNode;overload;
  function GetLocateNode(aTopNode: TTreeNode; aPathList: TStringList; aPathIndex: integer):TTreeNode;overload;
  //根据路径定位节点   //浙江省，杭州市，西湖区，MTU001
  function GetLocateNode(aTreeView: TTreeView; aPathList: TStringList):TTreeNode;overload;

implementation

uses Ut_MainForm,  RecError,Ut_DataModule,Ut_MTSTreeHelper;

function GetLocateNode(aTreeView: TTreeView; aPathList: TStringList):TTreeNode;overload;
var
  lCurrNode: TTreeNode;
begin
  result := nil;
  lCurrNode:= GetLocateFirstNode(aTreeView,aPathList);
  while lCurrNode<>nil do
  begin
    if fPathListIndex+1>=aPathList.Count then break;
    inc(fPathListIndex);
    lCurrNode:= GetLocateNode(lCurrNode,aPathList,fPathListIndex);
  end;
  result := lCurrNode;
end;

function GetLocateNode(aTopNode: TTreeNode; aPathList: TStringList; aPathIndex: integer):TTreeNode;overload;
var
  lNode: TTreeNode;
begin
  result := nil;
  aTopNode.Expand(false);
  lNode:= aTopNode.getFirstChild;
  while lNode<>nil do
  begin
    if JudgeNode(lNode.Text,aPathList.Strings[aPathIndex]) then
    begin
      result:= lNode;
      break;
    end;
    lNode:= lNode.getNextSibling;
  end;
end;

function GetLocateFirstNode(aTopNode: TTreeNode; aKeyValue: string):TTreeNode;overload;
var
  lNode: TTreeNode;
begin
  result := nil;
  aTopNode.Expand(false);
  lNode:= aTopNode.getFirstChild;
  while lNode<>nil do
  begin
    if JudgeNode(lNode.Text,aKeyValue) then
    begin
      result:= lNode;
    end
    else
    begin
      result:= GetLocateFirstNode(lNode,aKeyValue);
    end;
    if result<>nil then break;
    lNode:= lNode.getNextSibling;
  end;
end;

function GetLocateFirstNode(aTreeView: TTreeView; aPathList: TStringList):TTreeNode;overload;
var
  lFirstNode: TTreeNode;
  lKeyValue: string;
begin
  result:= nil;
  fPathListIndex:= 0;
  lFirstNode:= aTreeView.Items.GetFirstNode;
  if (lFirstNode=nil) or (aPathList.Count=0) then
  begin
    fIsLocateEffect:= false;
    exit;
  end;
  lKeyValue:= aPathList.Strings[fPathListIndex];
  if JudgeNode(lFirstNode.Text,lKeyValue) then
  begin
    result:= lFirstNode;
  end
  else
  begin
    result:= GetLocateFirstNode(lFirstNode,lKeyValue);
  end;
end;

function JudgeNode(aText1,aText2: string):boolean;
begin
  if uppercase(trim(aText1))=uppercase(trim(aText2)) then
    result:= true
  else result:= false;
end;

procedure GetLinkInfo(aItems:TStrings);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,4,Fm_MainForm.PublicParam.PriveAreaidStrs,'']),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

procedure GetSwitchInfo(aItems:TStrings);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,7,Fm_MainForm.PublicParam.PriveAreaidStrs,'']),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

procedure GetCSInfo(aItems:TStrings);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,8,Fm_MainForm.PublicParam.PriveAreaidStrs,'']),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

procedure GetResInfo(aItems:TStrings;param1,param2,param3,param4,aCondition:string);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,9,param1,param2,param3,param4,Fm_MainForm.PublicParam.PriveAreaidStrs,aCondition]),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

function IsExistRelated(aID: Integer; aItems: TStrings; aStr: string): Boolean;
var I: Integer;
    lTempStrList:TStrings;
    lStr:string;
begin
  Result:= False;
  lTempStrList:= TStringList.Create;
  for I := 0 to aItems.Count - 1 do
  begin
    if aID=TFilterObject(aItems.Objects[i]).Captionid then begin
      lTempStrList.Add(TFilterObject(aItems.Objects[i]).CaptionName);
    end;
  end;
  if lTempStrList.Count>0 then begin
    lStr:= Format(aStr,[lTempStrList.Text]);
    MessageBox(0,PChar(lStr),'提示',MB_OK+64);
    Result:=True;
  end;
end;

function IsExists(aTableName,aFieldName,aName: string;
  aKeyName: string=''; aid: integer=-1): boolean;
begin
  with DM_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if aid=-1 then  //新增
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,12,aTableName,aFieldName,aName,' and 1=1']),0);
    if aid<>-1 then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,12,aTableName,aFieldName,aName,' and '+aKeyName+'<>'+inttostr(aid)]),0);
    if eof then
      result:= false
    else
      result:= true;
  end;
end;

procedure FilterList(aList1,aList2: TStrings; aFileType, aFilterValue: integer);
var
  I: Integer;
begin
  CopyList(aList1,aList2);
  if aFileType=MTS_SUBURB then
  begin
    for I := aList2.Count - 1 downto 0 do
    begin
      if TFilterObject(aList2.Objects[i]).Suburbid<>aFilterValue then
      begin
        aList2.Objects[i].Free;
        aList2.Delete(i);
      end;
    end;
  end;
  if aFileType=MTS_BUILDING then
  begin
    for I := aList2.Count - 1 downto 0 do
    begin
      if TFilterObject(aList2.Objects[i]).Buildingid<>aFilterValue then
      begin
        aList2.Objects[i].Free;
        aList2.Delete(i);
      end;
    end;
  end;
end;

procedure CopyList(aList1,aList2: TStrings);
var
  I: Integer;
  lFilterObject, lFilterObjectSource:TFilterObject;
begin
  ClearTStrings(aList2);
  for I := 0 to aList1.Count - 1 do
  begin
    lFilterObjectSource:= TFilterObject(aList1.Objects[i]);
    lFilterObject:=TFilterObject.create;
    lFilterObject.Suburbid:= lFilterObjectSource.Suburbid;
    lFilterObject.SuburbName:= lFilterObjectSource.SuburbName;
    lFilterObject.Buildingid:= lFilterObjectSource.Buildingid;
    lFilterObject.BuildingName:= lFilterObjectSource.BuildingName;
    lFilterObject.Captionid:= lFilterObjectSource.Captionid;
    lFilterObject.CaptionName:= lFilterObjectSource.CaptionName;
    lFilterObject.Longitude:= lFilterObjectSource.Longitude;
    lFilterObject.Latitude:= lFilterObjectSource.Latitude;
    aList2.AddObject(lFilterObject.CaptionName,lFilterObject);
  end;
end;

function GetCaptionid(aCaptionName: string; aItems: TStrings):integer;
var
  i: Integer;
  lFilterObject:TFilterObject;
begin
  result:=-1;
  for i := 0 to aItems.Count - 1 do
  begin
    if aCaptionName=aItems.Strings[i] then
    begin
      lFilterObject:=TFilterObject(aItems.Objects[i]);
      result:=TFilterObject(lFilterObject).Captionid;
    end;
  end;
end;

procedure GetCNETInfo(aItems:TStrings);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,3,Fm_MainForm.PublicParam.PriveAreaidStrs,'']),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

procedure GetPHSInfo(aItems:TStrings);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,2,Fm_MainForm.PublicParam.PriveAreaidStrs,'']),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

procedure GetAPInfo(aItems:TStrings);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,1,Fm_MainForm.PublicParam.PriveAreaidStrs,'']),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

procedure GetBuildingInfo(aItems:TStrings);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,5,Fm_MainForm.PublicParam.PriveAreaidStrs,'']),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

procedure GetSuburbInfo(aItems:TStrings);
var
  lFilterObject:TFilterObject;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,6,Fm_MainForm.PublicParam.PriveAreaidStrs,'']),0);
    while not eof do
    begin
      lFilterObject:= TFilterObject.Create;
      lFilterObject.Suburbid:= Fieldbyname('suburbid').AsInteger;
      lFilterObject.SuburbName:= Fieldbyname('suburbname').AsString;
      lFilterObject.Buildingid:= Fieldbyname('buildingid').AsInteger;
      lFilterObject.BuildingName:= Fieldbyname('buildingname').AsString;
      lFilterObject.Captionid:= Fieldbyname('Captionid').AsInteger;
      lFilterObject.CaptionName:= Fieldbyname('CaptionName').AsString;
      lFilterObject.Longitude:= Fieldbyname('Longitude').AsString;
      lFilterObject.Latitude:= Fieldbyname('Latitude').AsString;
      aItems.AddObject(lFilterObject.CaptionName,lFilterObject);
      next;
    end;
    Close;
  end;
end;

function CheckRecordSelected(aView :TcxGridDBTableView):boolean;
begin
  if (aView.DataController.DataSource.DataSet = nil) or
     (not aView.DataController.DataSource.DataSet.Active) or
     (aView.DataController.DataSource.DataSet.RecordCount<=0) or
     (aView.DataController.GetSelectedCount<=0)
  then
    Result := false
  else
    Result := True;
end;

function GetItemIndex(DicName:string;Items:TStrings):integer;
var
  i: Integer;
begin
  result:=-1;
  for i := 0 to Items.Count - 1 do
  begin
    if DicName=Items.Strings[i] then
    begin
      result:= i;
    end;
  end;
end;

procedure AddViewField(aView : TcxGridDBTableView;aFieldName, aCaption : String; aWidth: integer=65; blVisible: boolean= true);overload;
begin
  aView.BeginUpdate;
  with aView.CreateColumn as TcxGridColumn do
  begin
    Caption := aCaption;
    DataBinding.FieldName:= aFieldName;
    DataBinding.ValueTypeClass := TcxStringValueType;
    HeaderAlignmentHorz := taCenter;
    Width:=aWidth;
    Visible := blVisible;
  end;
  aView.EndUpdate;
end;

procedure AutoSizeCol(aGridView:TcxGridDBTableView;const ACol: Integer);
var
  i,maxlen : Integer;
begin
  if aGridView.DataController.GetRecordCount=0 then
  begin
//    maxlen := Length(aGridView.Columns[0].BestFitMaxWidth;  .DataController.DisplayTexts[0,0]);
  end;
  maxlen := VarArrayDimCount(aGridView.DataController.GetValue(0,ACol));
  for I := 1 to aGridView.DataController.RowCount - 1 do
    if maxlen<Length(aGridView.DataController.GetValue(i,ACol)) then
       maxlen := Length(aGridView.DataController.GetValue(i,ACol));
  aGridView.Columns[ACol].Width := maxlen+2;
end;
function GetItemByObject(aObjectid:integer;Items:TStrings):integer;
var
  i: Integer;
begin
  result:=-1;
  for i := 0 to Items.Count - 1 do
  begin
    if TWdInteger(Items.Objects[I]).Value=aObjectid then
    begin
      result:=I;
      Break;
    end;
  end;
end;

function GetDicCode(DicName:string;Items:TStrings):integer;
var
  i: Integer;
  lObject:TObject;
begin
  result:=-1;
  for i := 0 to Items.Count - 1 do
  begin
    if DicName=Items.Strings[i] then
    begin
      lObject:=Items.Objects[i];
      result:=TWdInteger(lObject).Value;
    end;
  end;
end;

procedure LoadSuburb(aCityid,aAreaid :integer;Items:TStrings);
var
  lWdInteger:TWdInteger;
begin
  ClearTStrings(Items);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    if (acityid=0) and (aareaid=0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,21,0]),0)        //省
    else if (acityid<>0) and (aareaid=0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,21,acityid]),0)  //地市
    else if (acityid<>0) and (aareaid<>0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,21,aareaid]),0); //行政区
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('ID').AsInteger);
      Items.AddObject(Fieldbyname('NAME').AsString,lWdInteger);
      next;
    end;
    Close;
  end;
end;

procedure LoadBuilding(aCityid,aAreaid :integer;Items:TStrings);
var
  lWdInteger:TWdInteger;
begin
  ClearTStrings(Items);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    if (acityid=0) and (aareaid=0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,27,0]),0)        //省
    else if (acityid<>0) and (aareaid=0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,27,acityid]),0)  //地市
    else if (acityid<>0) and (aareaid<>0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,27,aareaid]),0); //行政区
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('buildingid').AsInteger);
      Items.AddObject(Fieldbyname('buildingname').AsString,lWdInteger);
      next;
    end;
    Close;
  end;
end;

function GetPriveArea(aCityid,aAreaid :integer):String;
begin
  result := '';
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    if (acityid=0) and (aareaid=0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,22,0]),0)        //省
    else if (acityid<>0) and (aareaid=0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,22,acityid]),0)  //地市
    else if (acityid<>0) and (aareaid<>0) then
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,22,aareaid]),0); //行政区
    while not eof do
    begin
      result := result + FieldByName('ID').AsString+',';
      next;
    end;
    Close;
  end;
  if length(result)>0 then
    result := Copy(result,1,length(result)-1)
  else
    result := '-1';
end;

procedure GetDic(aDicType:integer;DicCodeItems:TStrings);
var
  lWdInteger:TWdInteger;
begin
  ClearTStrings(DicCodeItems);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,2,aDicType]),0);
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('thecode').AsInteger);
      DicCodeItems.AddObject(Fieldbyname('thename').AsString,lWdInteger);
      next;
    end;
    Close;
  end;
end;

procedure DarkMatch_BUILDING(aCityid,aAreaid: integer;
  aMatchField,aMatchValue :String; Items:TStrings);
var
  lPriveCondition : string;
  lWdInteger:TWdInteger;
begin
  if (acityid=0) and (aareaid=0) then          //省级用户
  begin
    lPriveCondition := '';
  end
  else if (acityid<>0) and (aareaid=0) then
  begin
    lPriveCondition := ' and cityid='+inttostr(aCityid);
  end
  else if (acityid<>0) and (aareaid<>0) then
  begin
    lPriveCondition := ' and areaid='+inttostr(aAreaid);
  end;
  ClearTStrings(Items);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,18,aMatchField,aMatchValue,lPriveCondition]),0);
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('buildingid').AsInteger);
      Items.AddObject(Fieldbyname('buildingname').AsString,lWdInteger);
      next;
    end;
    Close;
  end;
end;

function GetAreaChildLeaf(aFirstID : integer):string;
begin
  result := '';
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,20,aFirstID]),0);
    while not eof do
    begin
      result := result + FieldByName('ID').AsString+',';
      next;
    end;
    Close;
  end;
  if length(result)>0 then
    result := Copy(result,1,length(result)-1)
  else
    result := '-1';
end;

procedure InitTree(GeoTreeView:TTreeview;Cityid,Areaid :integer;FLevelStop:integer=-1;aISOnlyDRS: Boolean=False);
var
  lTopNodeinfo :TNodeParam;
  MTSTreeHelper: TMTSTreeHelper;
begin
  MTSTreeHelper:=TMTSTreeHelper.Create;
  MTSTreeHelper.INIT('dsp_General_data',Dm_Mts.SocketConnection1.AppServer,Cityid,Areaid,FLevelStop,aISOnlyDRS);
  GeoTreeView.Items.Clear;
  lTopNodeinfo :=TNodeParam.Create;
  lTopNodeinfo.nodeType:=PROVINCE;
  lTopNodeinfo.Cityid:=0;
  lTopNodeinfo.AreaId:=0;
  lTopNodeinfo.DisplayName:='全省';
  MTSTreeHelper.InitGeoTree(lTopNodeinfo,GeoTreeView);
end;

function GetNewDicCode(dictype:integer):integer;
begin
  result :=-1;
  try
    with DM_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,9,dictype]),0);  //读取字典最大编码
      if IsEmpty then
        result := 1
      else
        result := FieldByName('diccode').AsInteger+1;
      Close;
    end;
  except
  end;
end;

function GetTheSequenceId(Sequence:String):integer;
begin
  result :=-1;
  try
    with DM_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,10,Sequence]),0);  //读取字典最大编码
      result := FieldByName('ID').AsInteger;
      Close;
    end;
  except
  end;
end;

Procedure CopyPicData(PROID,RenewID,ChangingID: Integer; var SourceCDS, TargetCDS: TClientDataset; OnLineToHistory:Boolean=true);
begin
  with TargetCDS do
  begin
    close;
    if OnLineToHistory then
    begin
      ProviderName:='dsp_General_data6';
      Data:=GetCDSData(VarArrayOf([0,2,6,PROID,RenewID,ChangingID]),6);  //打开一个空的协议历史扫描件数据集
    end else
    begin
      ProviderName:='dsp_General_data4';
      Data:=GetCDSData(VarArrayOf([2,1,9,PROID]),4);  //打开在线协议扫描件数据集
    end;
  end;
  with SourceCDS do
  begin
    close;
    if OnLineToHistory then
    begin
      ProviderName:='dsp_General_data4';
      Data:=GetCDSData(VarArrayOf([2,1,9,PROID]),4);  //打开在线协议扫描件数据集
    end else
    begin
      ProviderName:='dsp_General_data6';
      Data:=GetCDSData(VarArrayOf([0,2,6,PROID,RenewID,ChangingID]),6);  //打开一个空的协议历史扫描件数据集
    end;
    first;
    while not eof do  //将在线数据复制到历史表中
    begin
      TargetCDS.Append;
      TargetCDS.fieldbyname('PROID').AsInteger:=fieldbyname('PROID').AsInteger; //	NUMBER(10)	  N	协议编号
      TargetCDS.fieldbyname('RENEWID').AsInteger:=fieldbyname('RENEWID').AsInteger;  //	NUMBER(10)	  N	续签编号
      TargetCDS.fieldbyname('picorder').AsInteger:=fieldbyname('picorder').AsInteger;
      TargetCDS.fieldbyname('fileformat').AsInteger:=fieldbyname('fileformat').AsInteger;
      TargetCDS.fieldbyname('SCANDOC').AsVariant:=fieldbyname('SCANDOC').AsVariant;
      TargetCDS.fieldbyname('uploadip').AsString:=fieldbyname('uploadip').AsString;
      TargetCDS.fieldbyname('piccaption').AsString:=fieldbyname('piccaption').AsString;
      TargetCDS.fieldbyname('uploadpath').AsString:=fieldbyname('uploadpath').AsString;
      TargetCDS.fieldbyname('ChangingID').AsString:=fieldbyname('ChangingID').AsString;
      TargetCDS.fieldbyname('uploaduser').AsInteger:=fieldbyname('uploaduser').AsInteger;
      TargetCDS.fieldbyname('uploadtime').AsDateTime:=fieldbyname('uploadtime').AsDateTime;
      TargetCDS.post;
      next;
    end;
  end;
end;

Procedure CopyAccessoryData(PROID,RenewID,ChangingID: Integer; var SourceCDS, TargetCDS: TClientDataset; OnLineToHistory:Boolean=true);
begin
  with TargetCDS do
  begin
    close;
    if OnLineToHistory then
    begin
      ProviderName:='dsp_General_data7';
      Data:=GetCDSData(VarArrayOf([0,2,7,PROID,RenewID,ChangingID]),7);  //打开一个空的协议历史扫描件数据集
    end else
    begin
      ProviderName:='dsp_General_data5';
      Data:=GetCDSData(VarArrayOf([2,1,10,PROID]),5);  //打开在线协议扫描件数据集
    end;
  end;
  with SourceCDS do
  begin
    close;
    if OnLineToHistory then
    begin
      ProviderName:='dsp_General_data5';
      Data:=GetCDSData(VarArrayOf([2,1,10,PROID]),5);  //打开在线协议扫描件数据集
    end else
    begin
      ProviderName:='dsp_General_data7';
      Data:=GetCDSData(VarArrayOf([0,2,7,PROID,RenewID,ChangingID]),7);  //打开一个空的协议历史扫描件数据集
    end;
    first;
    while not eof do  //将在线数据复制到历史表中
    begin
      TargetCDS.Append;
      TargetCDS.fieldbyname('PROID').AsInteger:=fieldbyname('PROID').AsInteger; //	NUMBER(10)	  N	协议编号
      TargetCDS.fieldbyname('RENEWID').AsInteger:=fieldbyname('RENEWID').AsInteger;  //	NUMBER(10)	  N	续签编号
      TargetCDS.fieldbyname('picorder').AsInteger:=fieldbyname('picorder').AsInteger;
      TargetCDS.fieldbyname('fileformat').AsInteger:=fieldbyname('fileformat').AsInteger;
      TargetCDS.fieldbyname('ACCESSORY').AsVariant:=fieldbyname('ACCESSORY').AsVariant;
      TargetCDS.fieldbyname('uploadip').AsString:=fieldbyname('uploadip').AsString;
      TargetCDS.fieldbyname('ACCCAPTION').AsString:=fieldbyname('ACCCAPTION').AsString;
      TargetCDS.fieldbyname('uploadpath').AsString:=fieldbyname('uploadpath').AsString;
      TargetCDS.fieldbyname('ChangingID').AsString:=fieldbyname('ChangingID').AsString;
      TargetCDS.fieldbyname('uploaduser').AsInteger:=fieldbyname('uploaduser').AsInteger;
      TargetCDS.fieldbyname('uploadtime').AsDateTime:=fieldbyname('uploadtime').AsDateTime;
      TargetCDS.fieldbyname('objsize').AsString:=fieldbyname('objsize').AsString;
      TargetCDS.fieldbyname('objtype').AsString:=fieldbyname('objtype').AsString;
      TargetCDS.fieldbyname('modifydate').AsString:=fieldbyname('modifydate').AsString;
      TargetCDS.fieldbyname('imageindex').AsInteger:=fieldbyname('imageindex').AsInteger;
      TargetCDS.post;
      next;
    end;
  end;
end;

//检查必填值，如不正确，则返回false，同时incorrectValue参数返回不正确的标签值
function CheckFillValue(TheCase: TWinControl; var incorrectValue: String):boolean;
var
  i:integer;
begin
  Result:=true;
  with TheCase do
  for i:=0 to ControlCount-1 do
  begin
    //如果Controls[i].Tag=8，表示该内容为必填
    if (Controls[i] is TEdit) and (Controls[i].Tag=8) and ((Controls[i] as TEdit).Text='') then
    begin
      Result:=false;
      incorrectValue:=(Controls[i] as TEdit).Hint;
      break;
    end;
    if (Controls[i] is TComboBox) and (Controls[i].Tag=8) and ((Controls[i] as TComboBox).ItemIndex=-1) then
    begin
      Result:=false;
      incorrectValue:=(Controls[i] as TComboBox).Hint;
      break;
    end;
  end;
end;
 
//将指定日期值保存到数据库的转换函数，HoldTime=false表示不保留时间部份
function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
begin
  if HoldTime then
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD HH:MI:SS')+')'
  else
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD')+')';
end;

function GetDateValueIndex(ADate: TDateTime): Integer;
var
  ADaysBetween: Integer;
begin
  ADaysBetween := DaysBetween(Date, Trunc(ADate));
  Result := DateValueIndexOlder;
  if ADaysBetween = 0 then
    Result := DateValueIndexToday
  else
    if ADaysBetween = 1 then
      Result := DateValueIndexYesterday
    else
      if ADaysBetween < 7 then
        Result := DateValueIndexLastWeek
      else
        if ADaysBetween < 14 then
          Result := DateValueIndexTwoWeeksAgo;
end;

function GetGroupDateDisplayText(ADate: TDateTime): string;
const
   DisplayText: Array[DateValueIndexToday..DateValueIndexOlder] of String =
    ('今天', '昨天', '上周', '两周前', '更早');
    //('Today', 'Yesterday', 'Last Week', 'Two Weeks Ago', 'Older');
begin
  Result := DisplayText[GetDateValueIndex(ADate)];
end;

function StringToAlignment(StrAlignment:string):TAlignment;
begin
   if StrAlignment='taCenter' then
      Result:=taCenter
   else if StrAlignment='taRightJustify' then
      Result:=taRightJustify
   else
      Result:=taLeftJustify;
end;

procedure FillDGBTitleFromList(DBGrid:TDBGrid;FList:TList);overload;
var
  i:Integer;
  DBGridRec:TDBGridRec;
begin
  if FList.Count=0 then Exit;
  DBGrid.Columns.Clear;
  For i:=0 to FList.Count-1 do  //根据Alarm_Columns表的配置设置DBGRID相关内容
  begin
     DBGridRec:=FList.Items[i];
     DBGrid.Columns[i].Title.Alignment:=DBGridRec.TitleAlignment;
     DBGrid.Columns[i].Title.Caption:=DBGridRec.TitleCaption;
     DBGrid.Columns[i].Alignment:=DBGridRec.ColAlignment;
     DBGrid.Columns[i].Width:=DBGridRec.ColumnWidth;
     DBGrid.Columns[i].Visible:=DBGridRec.ColumnShow;
  end;
end;


procedure MyKeyPress(frm:TForm; var Key: Char);
var sClassName: string;
begin
  if Key = #13 then { 如果按下了回车键 }
  with TForm(frm) do
  begin
    sClassName := ActiveControl.ClassName;
    if (sClassName <> 'TDBMemo') And (sClassName <> 'TMemo') then
    begin
      if not (ActiveControl is TDbgrid) Then
      Begin { 不是在TDbgrid控件内}
        Key := #0; { 吃掉回车键 }
        TForm(frm).Perform(WM_NEXTDLGCTL, 0, 0); { 移动到下一个控制 }
      end else
      if (ActiveControl is TDbgrid) Then{是在 TDbgrid 控件内}
      begin
        With TDbgrid(ActiveControl) Do
        if Selectedindex<(FieldCount-1) then
          Selectedindex:=Selectedindex+1{ 移动到下一字段}
        else
          Selectedindex:=0;
      end;
    end;
  end;
end;

procedure FreeButton(FormTag:integer);
begin
  //Fm_Main_Client.Bg_Win.Items.FindItemID(FormTag).Free;
end;

procedure LoadPicture(theField: TField;Mode: TBlobStreamMode;theImage: TImage);
var
  MS: TStream;
  Pic: TJPEGImage;
begin
    If not theField.isNUll then
    begin   
      MS:=TDataSet(theField.DataSet).CreateBlobStream(theField,bmRead);
      pic := TJPEGImage.Create;
      Try
        pic.LoadFromStream(MS);
        theImage.Picture.Assign(pic);
      Finally
        pic.Free;
        MS.Free;
      end ;
    end
    Else
      theImage.Picture.Assign(nil);
end;

procedure InPutNum(var key: Char);
begin
    if not (key in ['0'..'9', #8,#13,#38,#40]) then
    begin
      Key := #0;
      MessageBeep(1);
    end;
end;

procedure InPutfloat(var key: Char);
begin
    if not (key in ['0'..'9','.','-', #8,#13,#38,#40]) then
    begin
      Key := #0;
      MessageBeep(1);
    end;
end;

function GetCDSData(aValue:OleVariant; DspID:integer=0):OleVariant;
begin
  Try
    result:=Dm_Mts.TempInterface.GetCDSData(aValue,DspID);
  except
    Application.MessageBox('数据获取失败!请检查条件后继续!','警告', MB_OK);
  end;
end;

function ExecTheSQL(aValue:OleVariant):boolean;
begin
  Try
    result:=Dm_Mts.TempInterface.ExecBatchSQL(aValue);
  except
    Application.MessageBox('SQL执行失败!请检查相关SQL语句是否正确!','警告', MB_OK);
    result:=False;
  end;
end;


procedure InitComboBox(OwnerData:Variant; var Box:TComboBox);
var
  obj :TCommonObj;
begin
  Box.Items.Clear;
  With Dm_Mts.cds_common do
  begin
    Data:=Dm_Mts.TempInterface.GetCDSData(OwnerData,0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('thecode').AsInteger;
      obj.Name := FieldByName('thename').AsString;
      Box.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
  if Box.Items.Count > 0 then
    Box.ItemIndex := 0;
end;

procedure InitConnInfoBox(OwnerData:Variant; var Box:TComboBox);
var
  obj :TConnInfoObj;
begin
  Box.Items.Clear;
  With Dm_Mts.cds_common do
  begin
    Data:=Dm_Mts.TempInterface.GetCDSData(OwnerData,0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TConnInfoObj.Create;
      obj.ID := FieldByName('PERSONCODE').AsInteger;
      obj.Name := FieldByName('PERSONNAME').AsString;
      obj.CONNTELE := FieldByName('CONNTELE').AsString;
      obj.DEPTNAME := FieldByName('DEPTNAME').AsString;
      Box.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
  if Box.Items.Count > 0 then
    Box.ItemIndex := 0;
end;

Function GetIdFromObj(Box:TComboBox):Integer;
begin
  if (box.Items.Count>0) and (Box.ItemIndex<>-1) then
    Result:=TCommonObj(Box.Items.Objects[Box.ItemIndex]).ID
  else
    Result:=-1;
end;

Procedure GotoCmbIndex(Box:TComboBox;index:integer);
var
  i : integer;
begin
  For i := 0 To Box.Items.Count-1  Do
  begin
    If TCommonObj(Box.Items.Objects[i]).ID = index Then
    begin
      Box.ItemIndex := i ;
      break ;
    end;
  end;
end;

function GetNameById(Box:TComboBox;Id:integer):String;
var
  i : integer;
begin
  For i := 0 To Box.Items.Count-1  Do
  begin
    If TCommonObj(Box.Items.Objects[i]).ID = ID Then
    begin
      result := Box.Items[i];
      break ;
    end;
  end;
end;

procedure DestroyConnInfoBox(Box: TComboBox);
var
  i : Integer;
begin
    for i:= 0 to Box.Items.Count -1 do
        TConnInfoObj(Box.Items.Objects[i]).Free;
    Box.Items.Clear;
end;


procedure DestroyCBObj(Box: TComboBox);
var
  i : Integer;
begin
    for i:= 0 to Box.Items.Count -1 do
        TCommonObj(Box.Items.Objects[i]).Free;
    Box.Items.Clear;
end;

function GetSysParamSet(Id,Kind :integer):String;
begin
  With Dm_Mts.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data0';
    Data:=GetCDSData(VarArrayOf([0,1,14,Kind,ID]),0);  //
    Result :=Trim(FieldByName('setvalue').AsString);
    Close;
  end;
end;


function ExportDataToExcel(DBGrid: TDBGrid; prompted: Boolean=true):String; overload ;
var
    s: TStringList;
    i: Integer;
    ASaveDialog: TSaveDialog;
    tofileName,str: string;
begin
    str := '';
    tofileName := '';
    with DBGrid do
    begin
      for i := 0 to Columns.Count - 1 do
        str := str + Trim(Columns[i].Title.Caption) + char(9);
    end;
    str :=str + #13;
    with DBGrid.DataSource.DataSet do
    begin
       DisableControls;
       try
          if not IsEmpty then
          begin
             First;
             while not eof do
             begin
                for i := 0 to FieldCount - 1 do
                   str := str + Trim(Fields[i].AsString) + char(9);
                   str := str + #13;
                Next;
             end;
          end;
       finally
          EnableControls;
       end;
    end;
    s := TStringList.Create;
    try
        s.Add(str);
        ASaveDialog := TSaveDialog.Create(nil);
        try
            ASaveDialog.Title := '保存文件';
            ASaveDialog.Filter := 'Microsof Excel (*.xls)|*.xls';
            if ASaveDialog.Execute then
            begin
                tofileName := ASaveDialog.FileName;
                if pos(uppercase('.xls'), uppercase(tofileName)) = 0 then
                    tofileName := tofileName + '.xls';
                if Fileexists(tofileName) then
                begin
                    if application.MessageBox('文件已存在，确认覆盖?', '提示', mb_okcancel + mb_defbutton1) = idok then
                    begin
                        Deletefile(pchar(tofileName));
                        s.SaveToFile(tofileName); //保存
                        if prompted then
                          application.MessageBox( '数据导出完毕!', '信息', MB_OK + MB_ICONINFORMATION);
                    end;
                end
                else
                begin
                    s.SaveToFile(tofileName); //保存
                    if prompted then
                      application.MessageBox('数据导出完毕!', '信息', MB_OK + MB_ICONINFORMATION);
                end;
            end;
        finally
            FreeAndNil(ASaveDialog);
        end;
    finally
        FreeAndNil(s);
        Result:=tofileName;
    end;
end;


//获取从表表头信息
function GetDetailTitle(List:TList;var TitleE,TitleC:String):Boolean;
var
    i:integer;
    DBGridRec:TDBGridRec;
begin
    result := true;
    if List.Count=0 then Exit;
    For i:=0 to List.Count-1 do
    begin
       DBGridRec:=List.Items[i];
       if DBGridRec.ColumnShow then
       begin
         TitleE := TitleE + DBGridRec.FieldName + ',';
         TitleC := TitleC + DBGridRec.TitleCaption +char(9);
       end;
    end;
    TitleE := ' '+leftstr(TitleE,length(TitleE)-1);
end;



function RetrieveDeltas(const cdsArray : array of TClientDataset): Variant;
var
  i : integer;
  LowCDS, HighCDS : integer;
begin
  Result:=NULL;
  LowCDS:=Low(cdsArray);
  HighCDS:=High(cdsArray);
  for i:=LowCDS to HighCDS do
    cdsArray[i].CheckBrowseMode;

  Result:=VarArrayCreate([LowCDS, HighCDS], varVariant);
  {Setup the variant with the changes (or NULL if there are none)}
  for i:=LowCDS to HighCDS do
  begin
    if cdsArray[i].ChangeCount>0 then
      Result[i]:=cdsArray[i].Delta
    else
      Result[i]:=NULL;
  end;
  //cdsArray[i].EditKey
end;

{We need to return the provider name AND the
 AppServer from this function. We will use ProviderName to call AS_ApplyUpdates
 in the CDSApplyUpdates function later.}
function RetrieveProviders(const cdsArray : array of TClientDataset): Variant;
var
  i: integer;
  LowCDS, HighCDS: integer;
begin
  Result:=NULL;
  LowCDS:=Low(cdsArray);
  HighCDS:=High(cdsArray);

  Result:=VarArrayCreate([LowCDS, HighCDS], varVariant);
  for i:=LowCDS to HighCDS do
    Result[i]:=cdsArray[i].ProviderName;
end;

procedure ReconcileDeltas(const cdsArray : array of TClientDataset; vDeltaArray: OleVariant);
var
  bReconcile : boolean;
  i: integer;
  LowCDS, HighCDS : integer;
begin
  LowCDS:=Low(cdsArray);
  HighCDS:=High(cdsArray);

  {If the previous step resulted in errors, Reconcile the error datapackets.}
  bReconcile:=false;
  for i:=LowCDS to HighCDS do
    if not VarIsNull(vDeltaArray[i]) then begin
      cdsArray[i].Reconcile(vDeltaArray[i]);
      bReconcile:=true;
      break;
    end;

  {Refresh the Datasets if needed}
  if not bReconcile then
    for i:=HighCDS downto LowCDS do begin
      cdsArray[i].Reconcile(vDeltaArray[i]);
      cdsArray[i].Refresh;
    end;
end;

procedure ReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  Action := HandleReconcileError(DataSet, UpdateKind, E);
end;


function GetPYIndexChar( hzchar:string):char;
begin
  case WORD(hzchar[1]) shl 8 + WORD(hzchar[2]) of
    $B0A1..$B0C4 : result := 'A';
    $B0C5..$B2C0 : result := 'B';
    $B2C1..$B4ED : result := 'C';
    $B4EE..$B6E9 : result := 'D';
    $B6EA..$B7A1 : result := 'E';
    $B7A2..$B8C0 : result := 'F';
    $B8C1..$B9FD : result := 'G';
    $B9FE..$BBF6 : result := 'H';
    $BBF7..$BFA5 : result := 'J';
    $BFA6..$C0AB : result := 'K';
    $C0AC..$C2E7 : result := 'L';
    $C2E8..$C4C2 : result := 'M';
    $C4C3..$C5B5 : result := 'N';
    $C5B6..$C5BD : result := 'O';
    $C5BE..$C6D9 : result := 'P';
    $C6DA..$C8BA : result := 'Q';
    $C8BB..$C8F5 : result := 'R';
    $C8F6..$CBF9 : result := 'S';
    $CBFA..$CDD9 : result := 'T';
    $CDDA..$CEF3 : result := 'W';
    $CEF4..$D1B8 : result := 'X';
    $D1B9..$D4D0 : result := 'Y';
    $D4D1..$D7F9 : result := 'Z';
  else
    result := char(0);
  end;
end;

function GetPinMa(SourceStrs: String):String;
var i:integer;
    hzchar :string;
    PYIndex:char;
begin
  Result:='';
  i:=1;
  while i<Length(SourceStrs) do
  begin
    hzchar:=SourceStrs[i] + SourceStrs[i+1];
    PYIndex:=GetPYIndexChar(hzchar);
    if PYIndex=char(0) then
    begin
      Result:=Result+SourceStrs[i];
      i:=i+1;
    end else
    begin
      Result:=Result+PYIndex;
      i:=i+2;
    end;
  end;
  if i=Length(SourceStrs) then
   Result:=Result+SourceStrs[i];
end;

function GetFunArray(list :TStrings):OleVariant;
var
  i :integer;
begin
  Result := varArrayCreate([0, list.Count-1], varVariant);
  for i := 0 to list.Count-1 do
    Result[i] := list.Strings[i];
end;

function LogEntry(Dig: MD5Digest): string;
begin
    Result := Format('%s', [MD5Print(Dig)]);
end;


procedure FreeandNilTB(theTB:TToolBar);
var
  i:Integer;
begin
    For i:= theTB.ButtonCount -1 Downto 0 Do
        theTB.Buttons[i].Free;
end;

Function CheckCondition(ThePanel:TPanel):Boolean;
var
  i,j:Integer;
  TheChBox:TCheckBox ;
begin
  Result:=True;
  For i:=0 To ThePanel.ControlCount -1 Do
  begin
    If (ThePanel.Controls[i] is TCheckBox)  and
       ((ThePanel.Controls[i] as TCheckBox).Tag>0 ) and
       (ThePanel.Controls[i] as TCheckBox).Checked Then
    begin
      TheChBox:= (ThePanel.Controls[i] as TCheckBox) ;
      //获取相同Tag的Edit,comboBox,spinedit
      j:= GetCtrFromTag(ThePanel,TheChBox.tag,False);

      If (ThePanel.Controls[j] is TEdit) Then
      begin
        If Trim((ThePanel.Controls[j] as TEdit).Text)='' Then
        begin
          Result:=False;
          Break;
        End;
      end
      else If (ThePanel.Controls[j] is tcombobox) Then
      begin
        If (ThePanel.Controls[j] as TComboBox).ItemIndex=-1 Then
        begin
          Result:=False;
          Break;
        end;
      end
      Else
      begin
        If Trim((ThePanel.Controls[j] as TSpinEdit).Text)='' then
        begin
          Result:=False;
          Break; 
        end;
      end;
    end;
  end;
end;
{ Arr_SYM_LOGIC Array of String;   0
  Arr_COL_NAME Array of String;    1
  Arr_SYM_COMP Array of String;    2
  Arr_COL_VALUE Array of String;   3
  Arr_COL_NAME_CN Array of String; 4}
procedure BuildWhereSql(ThePanel:TPanel;Var Arr_searchCon :PByte);
var
  i,j,h,selectcount,i_addstr :Integer;
  TheChBox:TCheckBox ;
  theName :String; //字段名
  theCOMP :String; //运算符
  theValue:String; //查询值
  theNAME_CN:String;//查询中文名
  theLeft :String;
  theRight:String;
begin
  selectcount := 0 ;
  For i:=0 To ThePanel.ControlCount -1 Do
  If (ThePanel.Controls[i] is  TCheckBox) and (TCheckBox(ThePanel.Controls[i]).Checked)
   and (TCheckBox(ThePanel.Controls[i]).Font.Color<>clWindowText) Then //颜色为clWindowText不支持个性查询
       selectcount:=selectcount+1 ;
  If selectcount=0 then Exit;
  SetLength(Arr_searchCon[1],selectcount);  //关系符
  SetLength(Arr_searchCon[2],selectcount);  //字段名
  SetLength(Arr_searchCon[3],selectcount);  //运算符
  SetLength(Arr_searchCon[4],selectcount);  //查询值
  SetLength(Arr_searchCon[5],selectcount);  //字段中文名
  SetLength(Arr_searchCon[6],selectcount);  //左括号
  SetLength(Arr_searchCon[7],selectcount);  //右括号
  i_addstr:=0 ;
  h:=0;
  For i:=0 To ThePanel.ControlCount -1 Do
  begin
    If (ThePanel.Controls[i] is TCheckBox)  and
       ((ThePanel.Controls[i] as TCheckBox).Tag>0 ) and
       (ThePanel.Controls[i] as TCheckBox).Checked Then
    begin
      TheChBox:= (ThePanel.Controls[i] as TCheckBox) ;
      //查询字段名
      theName:=QuotedStr(TheChBox.Hint) ;

      //查询中文名称
      theNAME_CN:= QuotedStr(TheChBox.Caption) ;
      //获取相同Tag的Edit,comboBox,spinedit
      j:= GetCtrFromTag(ThePanel,TheChBox.tag,False);
      //如果需要特殊处理的则获取相同Tag的Label
      If TheChBox.Tag>100 Then
      h:= GetCtrFromTag(ThePanel,TheChBox.tag,True);
      // 特殊查询条件的处理
      If  TheChBox.Tag= 101 then
      begin
        //查询运算符
        theCOMP:= QuotedStr(' '+ Trim((ThePanel.Controls[j] as TEdit).Hint)+' ') ;
        //查询值
        theValue := QuotedStr(StringReplace( Trim((ThePanel.Controls[h] as TLabel).Caption),
                                   'TheParam',
                                   QuotedStr(Trim((ThePanel.Controls[j] as TEdit).Text)),
                                   [rfReplaceAll, rfIgnoreCase] ));
      end
      Else
      begin
        If (ThePanel.Controls[j] is TEdit) Then
        begin
            //查询运算符
           theCOMP:=   QuotedStr(' '+ Trim((ThePanel.Controls[j] as TEdit).Hint)+' ') ;
           If LowerCase(Trim((ThePanel.Controls[j] as TEdit).Hint))='like' Then
              //查询值
             theValue := QuotedStr('%'+ Trim((ThePanel.Controls[j] as TEdit).Text)+'%')
           Else //查询值
             theValue := QuotedStr(QuotedStr(Trim((ThePanel.Controls[j] as TEdit).Text))) ;
        end
        else If (ThePanel.Controls[j] is tcombobox) Then
        begin
           //查询运算符
           theCOMP:=   QuotedStr(' '+ Trim((ThePanel.Controls[j] as TComboBox).Hint)+' ') ;
           //查询值
           theValue := IntToStr(GetIdFromObj(ThePanel.Controls[j] as TComboBox));
        end
        Else
        begin
           //查询运算符
           theCOMP:=   QuotedStr(' '+ Trim((ThePanel.Controls[j] as TSpinEdit).Hint)+' ') ;
           //查询值
           theValue := QuotedStr(' '+ Trim((ThePanel.Controls[j] as TSpinEdit).Text)+' ') ;//QComCtrls
        end;
      end;
      If i_addstr=0 Then
      begin
        If i_addstr= selectcount-1 Then
        begin
          theleft:=QuotedStr(' ( ') ;
          theRight:=QuotedStr(' ) ');
        end
        Else begin
          theleft:=QuotedStr(' ( ') ;
          theRight:=QuotedStr('  ');
        end;
      end
      Else If i_addstr= selectcount-1 Then
      begin
        theleft:=QuotedStr('  ') ;
        theRight:=QuotedStr(' ) ');
      end
      Else
      begin
        theleft:=QuotedStr('  ') ;
        theRight:=QuotedStr('  ');
      end;
      //组织Sql语句
      Arr_searchCon[1,i_addstr]:=QuotedStr(' And ');
      Arr_searchCon[2,i_addstr]:=theName;//QuotedStr(' '+TheChBox.Hint+' ');//' Fixtid '
      Arr_searchCon[3,i_addstr]:=theCOMP ;
      Arr_searchCon[4,i_addstr]:=theValue;
      Arr_searchCon[5,i_addstr]:=theNAME_CN;
      Arr_searchCon[6,i_addstr]:=theLeft;
      Arr_searchCon[7,i_addstr]:=theRight;
      i_addstr:=i_addstr+1 ;
    end;
  end;
end;
{ //组成SQl条件语句
     If i_addstr=1 then
      begin
        If Lowercase(theCOMP)='like' then
           theValue :=  ''''+theValue+'''';
        sqlWhere:= sqlWhere + ' And ' +'( '+TheName_Where+' '+ theCOMP_Where+ theValue_Where;
      end
      Else If i_addstr = selectcount then
      begin
        If Lowercase(theCOMP)='like' then
           theValue :=  ''''+theValue+'''';
        sqlWhere:= sqlWhere + ' And '+' '+TheName_Where+' '+ theCOMP_Where+ theValue_Where +')';
      end
      Else
      begin
        If Lowercase(theCOMP)='like' then
           theValue :=  ''''+theValue+'''';
        sqlWhere:= sqlWhere + ' And '+TheName_Where+ theCOMP_Where+ theValue_Where;
      end;    If i_addstr=1 then
      begin
        If Lowercase(theCOMP)='like' then
           theValue :=  ''''+theValue+'''';
        sqlWhere:= sqlWhere + ' And ' +'( '+TheName_Where+' '+ theCOMP_Where+ theValue_Where;
      end
      Else If i_addstr = selectcount then
      begin
        If Lowercase(theCOMP)='like' then
           theValue :=  ''''+theValue+'''';
        sqlWhere:= sqlWhere + ' And '+' '+TheName_Where+' '+ theCOMP_Where+ theValue_Where +')';
      end
      Else
      begin
        If Lowercase(theCOMP)='like' then
           theValue :=  ''''+theValue+'''';
        sqlWhere:= sqlWhere + ' And '+TheName_Where+ theCOMP_Where+ theValue_Where;
      end;}

Function GetCtrFromTag(ThePanel:TPanel;theTag:Integer;islabel:Boolean):Integer;
var
  i:Integer;
begin
  Result:= 0;
  For i:=0 To ThePanel.ControlCount-1 Do
  begin
     If (ThePanel.Controls[i].Tag=theTag) and Not(ThePanel.Controls[i] is TCheckBox)
        and Not(ThePanel.Controls[i] is TLabel) Then
     begin
        If Not islabel Then
        begin
           Result:= i ;
           break;
        end
        else If ( ThePanel.Controls[i] Is TLabel ) Then
        begin
           Result:= i ;
           break;
        end;
     end;
  end;
end;

Function GetParam(Kind,itemcode:Integer):String ;
begin
  With Dm_Mts.cds_common do
  Try
    close;
    //根据指定类型和指定编码取得sys_param_config表的值数据
    ProviderName:='dsp_General_data1';
    Data:=Dm_Mts.TempInterface.GetCDSData(VarArrayof([0,1,6,Kind,itemcode]),1);
    Result:= FieldByName('SetValue').AsString;
  Except
    Result:= '0';
  end;
end;

function DelFromGrid(lValue:integer;SqlIndex:integer):boolean;
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  result:=false;
  if lValue=-1 then  exit;
  
  with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,SqlIndex,lValue]),0);
      first;
      while not eof do
      begin
        delete;
      end;
    end;
   try
     vCDSArray[0]:=Dm_MTS.cds_common;
     vDeltaArray:=RetrieveDeltas(vCDSArray);
     vProviderArray:=RetrieveProviders(vCDSArray);
     if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
       SysUtils.Abort;
       result:=true;
   except
       result:=false;
   end;
end;

function HasChild(lValue:integer;SqlIndex:integer):boolean;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,SqlIndex,lValue]),0);
    if recordcount>0 then
      result:=true
    else
      result:=false;
  end;
end;

procedure DeleteFromGrid(aGrid:TAdvStringGrid;aRowIndex:integer);
begin
  if aGrid.RowCount>2  then
  begin
    aGrid.RemoveRows(aRowIndex,1);
    aGrid.AutoNumberCol(0);
  end
  else
    aGrid.ClearNormalCells;
end;
end.
