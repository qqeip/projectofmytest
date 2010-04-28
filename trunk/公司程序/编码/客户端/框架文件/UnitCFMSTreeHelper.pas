unit UnitCFMSTreeHelper;

interface

uses cxTreeView, Windows, Messages, DBClient, DB, ComCtrls, SysUtils, Variants, IniFiles, Forms, Controls,
       Classes, Graphics;

type

  TNodeType = (PROVINCE,  //0  省
               CITY,      //1  地市
               TOWN,      //2  行政区 杭州市区
               SUBURB,    //3  分局   西湖分局
               BRANCH,    //4  支局   翠苑支局
               DevGather, //5  设备集
               Device,    //6  基站设备
               CELL       //  小区设备
               );
  TNodeParamValue = class(Tobject)
  public
    NodeType   :TNodeType;
    PROVINCEID,
    CITYID,
    DEVICEGATHERID,
    TOWNID,
    SUBURBID,
    BRANCHID,
    DEVICEID,
    CELLID: integer;
    PARENTPROVINCEID,
    PARENTCITYID,
    PARENTDEVICEGATHERID,
    PARENTTOWNID,
    PARENTSUBURBID,
    PARENTBRANCHID,
    PARENTDEVICEID,
    PARENTCELLID: integer;
    {DevGatherID   :integer; //设备集编号
    townid     :integer;    //行政区编号
    SUBURBid   :integer;    //分局编号
    Branchid   :integer;    //支局编号
    Deviceid      :integer; //设备编号}

    NodeLevel: integer;
    HaveExpanded :boolean;  //是否已经展开
    DisplayName :string;    //显示名称 ，如 全网
    BTSID: integer;
    FAN_ID: integer; //扇区号
  end;

  TCFMS_TreeHelper = Class
  private
    gCityid, ResultCount: integer;
    gCompanyStr: string;
    gWhereStr: string;
    gStopLevel, gLastLevel: integer;
    gSearchFlag: boolean;
    gClientDataSet: TClientDataSet;
    gcxTreeView: TcxTreeView;
    gFieldName, gFieldValue, gFieldName1, gFieldValue1: string;
    function GetChildNodes(aParentNode: TTreeNode): boolean;
    procedure ClearTreeViewNodes;
    procedure MyFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure DoMyFilterRecord(aFieldName, aFieldValue, aFieldName1, aFieldValue1: string);
    procedure GetPathDataSet;
    procedure TreeViewExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure MyExactFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ReNewTreeOnStyle;
    function HaveDeviceLeaf(aNode: TTReeNode): boolean;
  public
    gExactOrFuzzySearching: Integer; //0 模糊，1 精确
    function RefreshTree(aWhereStr: string; aStopLevel, aLastLevel: integer; aSearch: boolean): boolean;
    constructor Create(acxTreeView: TcxTreeView; aCityid: integer; aCompanyStr: string);
    destructor Destroy; override;
  end;

implementation

uses UnitDllCommon;

{ TCFMS_TreeHelper }


{ TCFMS_TreeHelper }


procedure TCFMS_TreeHelper.ClearTreeViewNodes;
var
  i: integer;
begin
  for i := gcxTreeView.Items.Count-1 downto 0 do
  begin
    Dispose(gcxTreeView.Items[i].Data);
    gcxTreeView.Items[i].Delete;
  end;
end;

constructor TCFMS_TreeHelper.Create(acxTreeView: TcxTreeView; aCityid: integer; aCompanyStr: string);
begin
  inherited Create;
  gExactOrFuzzySearching:= 0;
  gcxTreeView:= acxTreeView;
  gcxTreeView.OnExpanding := TreeViewExpanding;
  gCityid:= aCityid;
  gCompanyStr:= aCompanyStr;
  gClientDataSet:= TClientDataSet.Create(nil);
  GetPathDataSet;
end;

destructor TCFMS_TreeHelper.Destroy;
begin
  gClientDataSet.Close;
  gClientDataSet.Free;
  ClearTreeViewNodes;
  inherited;
end;

procedure TCFMS_TreeHelper.DoMyFilterRecord(aFieldName, aFieldValue,
  aFieldName1, aFieldValue1: string);
begin
  gClientDataSet.Filtered:= false;
  gFieldName:= aFieldName;
  gFieldValue:= aFieldValue;
  gFieldName1:= aFieldName1;
  gFieldValue1:= aFieldValue1;
  if gExactOrFuzzySearching=0 then
    gClientDataSet.OnFilterRecord:= MyFilterRecord
  else
    gClientDataSet.OnFilterRecord:= MyExactFilterRecord;
  gClientDataSet.Filtered:= true;
end;

function TCFMS_TreeHelper.GetChildNodes(aParentNode: TTreeNode): boolean;
var
  lParentNodeParam, lChildNodeParam: TNodeParamValue;
  lChildNode: TTreeNode;
  lHashStringList: THashedStringList;
  I: integer;
begin
  result:= false;
  lHashStringList:= THashedStringList.Create;
  try
    try
      if (not gClientDataSet.Active) and (gClientDataSet.RecordCount=0) then
        exit;
      if (aParentNode=nil) or (aParentNode.Data=nil) then
        exit;
      lParentNodeParam:= TNodeParamValue(aParentNode.Data);
      if lParentNodeParam.HaveExpanded then exit;

      with gClientDataSet do
       begin
        case lParentNodeParam.NodeType of
          PROVINCE: begin
                      //先删除预留的子节点
                      aParentNode.DeleteChildren;
                      DoMyFilterRecord('PARENTCITYID',inttostr(lParentNodeParam.PROVINCEID),'','');
                      first;
                      lChildNodeParam:= nil;
                      while not eof do
                      begin
                        if lHashStringList.IndexOf(inttostr(FieldByName('CITYID').AsInteger))<0 then
                        begin
                          //lHashStringList.Add(inttostr(FieldByName('CITYID').AsInteger));
                          lChildNodeParam:= TNodeParamValue.Create;
                          lChildNodeParam.NodeType:= CITY;
                          lChildNodeParam.PROVINCEID:= lParentNodeParam.PROVINCEID;
                          lChildNodeParam.PARENTPROVINCEID:= lParentNodeParam.PARENTPROVINCEID;

                          lChildNodeParam.CITYID:= FieldByName('CITYID').AsInteger;
                          lChildNodeParam.PARENTCITYID:= lParentNodeParam.PROVINCEID;
                          lChildNodeParam.DisplayName:= FieldByName('CITYNAME').AsString;
                          lChildNodeParam.HaveExpanded:= false;
                          lChildNodeParam.NodeLevel:= 1;

                          lChildNode:= gcxTreeView.Items.AddChildObject(aParentNode, lChildNodeParam.DisplayName, lChildNodeParam);
                          lChildNode.ImageIndex:= lChildNodeParam.NodeLevel;
                          lChildNode.SelectedIndex:= lChildNode.ImageIndex;
                          lHashStringList.AddObject(inttostr(FieldByName('CITYID').AsInteger),lChildNode);

                          if (lChildNodeParam.NodeLevel< gLastLevel) then
                            gcxTreeView.Items.AddChild(lChildNode,'aa');
                        end;
                        next;
                      end;
                      if ((lChildNodeParam<>nil) and (lChildNodeParam.NodeLevel<=gStopLevel)) or (gSearchFlag) then
                      begin
                        for i:= 0 to lHashStringList.Count -1 do
                        begin
                          lChildNode:= TTreeNode(lHashStringList.Objects[i]);
                          lChildNode.Expand(false);
                        end;
                      end;
                    end;
          CITY:     begin
                      //先删除预留的子节点
                      aParentNode.DeleteChildren;
                      DoMyFilterRecord('PARENTDEVICEGATHERID',inttostr(lParentNodeParam.CITYID),'','');
                      first;
                      lChildNodeParam:= nil;
                      while not eof do
                      begin
                        if lHashStringList.IndexOf(inttostr(FieldByName('DEVICEGATHERID').AsInteger))<0 then
                        begin
                          //lHashStringList.Add(inttostr(FieldByName('DEVICEGATHERID').AsInteger));
                          lChildNodeParam:= TNodeParamValue.Create;
                          lChildNodeParam.NodeType:= DevGather;
                          lChildNodeParam.PROVINCEID:= lParentNodeParam.PROVINCEID;
                          lChildNodeParam.PARENTPROVINCEID:= lParentNodeParam.PARENTPROVINCEID;
                          lChildNodeParam.CITYID:= lParentNodeParam.CITYID;
                          lChildNodeParam.PARENTCITYID:= lParentNodeParam.PARENTCITYID;

                          lChildNodeParam.DEVICEGATHERID:= FieldByName('DEVICEGATHERID').AsInteger;
                          lChildNodeParam.PARENTDEVICEGATHERID:= lParentNodeParam.CITYID;
                          lChildNodeParam.DisplayName:= FieldByName('DEVICEGATHERNAME').AsString;
                          lChildNodeParam.HaveExpanded:= false;
                          lChildNodeParam.NodeLevel:= 2;

                          lChildNode:= gcxTreeView.Items.AddChildObject(aParentNode, lChildNodeParam.DisplayName, lChildNodeParam);
                          lChildNode.ImageIndex:= lChildNodeParam.NodeLevel;
                          lChildNode.SelectedIndex:= lChildNode.ImageIndex;
                          lHashStringList.AddObject(inttostr(FieldByName('DEVICEGATHERID').AsInteger),lChildNode);

                          if (lChildNodeParam.NodeLevel< gLastLevel) then
                            gcxTreeView.Items.AddChild(lChildNode,'aa');
                        end;
                        next;
                      end;
                      if ((lChildNodeParam<>nil) and (lChildNodeParam.NodeLevel<=gStopLevel)) or (gSearchFlag) then
                      begin
                        for i:= 0 to lHashStringList.Count -1 do
                        begin
                          lChildNode:= TTreeNode(lHashStringList.Objects[i]);
                          lChildNode.Expand(false);
                        end;
                      end;
                    end;
          DevGather:begin
                      //先删除预留的子节点
                      aParentNode.DeleteChildren;
                      DoMyFilterRecord('PARENTTOWNID',inttostr(lParentNodeParam.CITYID),'DEVICEGATHERID',inttostr(lParentNodeParam.DEVICEGATHERID));
                      first;
                      lChildNodeParam:= nil;
                      while not eof do
                      begin
                        if lHashStringList.IndexOf(inttostr(FieldByName('TOWNID').AsInteger))<0 then
                        begin
                          //lHashStringList.Add(inttostr(FieldByName('TOWNID').AsInteger));
                          lChildNodeParam:= TNodeParamValue.Create;
                          lChildNodeParam.NodeType:= TOWN;
                          lChildNodeParam.PROVINCEID:= lParentNodeParam.PROVINCEID;
                          lChildNodeParam.PARENTPROVINCEID:= lParentNodeParam.PARENTPROVINCEID;
                          lChildNodeParam.CITYID:= lParentNodeParam.CITYID;
                          lChildNodeParam.PARENTCITYID:= lParentNodeParam.PARENTCITYID;
                          lChildNodeParam.DEVICEGATHERID:= lParentNodeParam.DEVICEGATHERID;
                          lChildNodeParam.PARENTDEVICEGATHERID:= lParentNodeParam.PARENTDEVICEGATHERID;

                          lChildNodeParam.TOWNID:= FieldByName('TOWNID').AsInteger;
                          lChildNodeParam.PARENTTOWNID:= lParentNodeParam.CITYID;
                          lChildNodeParam.DisplayName:= FieldByName('TOWNNAME').AsString;
                          lChildNodeParam.HaveExpanded:= false;
                          lChildNodeParam.NodeLevel:= 3;

                          lChildNode:= gcxTreeView.Items.AddChildObject(aParentNode, lChildNodeParam.DisplayName, lChildNodeParam);
                          lChildNode.ImageIndex:= lChildNodeParam.NodeLevel;
                          lChildNode.SelectedIndex:= lChildNode.ImageIndex;
                          lHashStringList.AddObject(inttostr(FieldByName('TOWNID').AsInteger),lChildNode);

                          if (lChildNodeParam.NodeLevel< gLastLevel) then
                            gcxTreeView.Items.AddChild(lChildNode,'aa');
                        end;
                        next;
                      end;
                      if ((lChildNodeParam<>nil) and (lChildNodeParam.NodeLevel<=gStopLevel)) or (gSearchFlag) then
                      begin
                        for i:= 0 to lHashStringList.Count -1 do
                        begin
                          lChildNode:= TTreeNode(lHashStringList.Objects[i]);
                          lChildNode.Expand(false);
                        end;
                      end;
                    end;
          TOWN:     begin
                      //先删除预留的子节点
                      aParentNode.DeleteChildren;
                      DoMyFilterRecord('PARENTSUBURBID',inttostr(lParentNodeParam.TOWNID),'','');
                      first;
                      lChildNodeParam:= nil;
                      while not eof do
                      begin
                        if lHashStringList.IndexOf(inttostr(FieldByName('SUBURBID').AsInteger))<0 then
                        begin
                          //lHashStringList.Add(inttostr(FieldByName('SUBURBID').AsInteger));
                          lChildNodeParam:= TNodeParamValue.Create;
                          lChildNodeParam.NodeType:= SUBURB;
                          lChildNodeParam.PROVINCEID:= lParentNodeParam.PROVINCEID;
                          lChildNodeParam.PARENTPROVINCEID:= lParentNodeParam.PARENTPROVINCEID;
                          lChildNodeParam.CITYID:= lParentNodeParam.CITYID;
                          lChildNodeParam.PARENTCITYID:= lParentNodeParam.PARENTCITYID;
                          lChildNodeParam.DEVICEGATHERID:= lParentNodeParam.DEVICEGATHERID;
                          lChildNodeParam.PARENTDEVICEGATHERID:= lParentNodeParam.PARENTDEVICEGATHERID;
                          lChildNodeParam.TOWNID:= lParentNodeParam.TOWNID;
                          lChildNodeParam.PARENTTOWNID:= lParentNodeParam.PARENTTOWNID;

                          lChildNodeParam.SUBURBID:= FieldByName('SUBURBID').AsInteger;
                          lChildNodeParam.PARENTSUBURBID:= lParentNodeParam.TOWNID;
                          lChildNodeParam.DisplayName:= FieldByName('SUBURBNAME').AsString;
                          lChildNodeParam.HaveExpanded:= false;
                          lChildNodeParam.NodeLevel:= 4;

                          lChildNode:= gcxTreeView.Items.AddChildObject(aParentNode, lChildNodeParam.DisplayName, lChildNodeParam);
                          lChildNode.ImageIndex:= lChildNodeParam.NodeLevel;
                          lChildNode.SelectedIndex:= lChildNode.ImageIndex;
                          lHashStringList.AddObject(inttostr(FieldByName('SUBURBID').AsInteger),lChildNode);

                          if (lChildNodeParam.NodeLevel< gLastLevel) then
                            gcxTreeView.Items.AddChild(lChildNode,'aa');
                        end;
                        next;
                      end;
                      if ((lChildNodeParam<>nil) and (lChildNodeParam.NodeLevel<=gStopLevel)) or (gSearchFlag) then
                      begin
                        for i:= 0 to lHashStringList.Count -1 do
                        begin
                          lChildNode:= TTreeNode(lHashStringList.Objects[i]);
                          lChildNode.Expand(false);
                        end;
                      end;
                    end;
          SUBURB:   begin
                      //先删除预留的子节点
                      aParentNode.DeleteChildren;
                      DoMyFilterRecord('PARENTDEVICEID1',inttostr(lParentNodeParam.SUBURBID),'PARENTDEVICEID2',inttostr(lParentNodeParam.DEVICEGATHERID));
                      first;
                      lChildNodeParam:= nil;
                      while not eof do
                      begin
                        if lHashStringList.IndexOf(inttostr(FieldByName('DEVICEID').AsInteger))<0 then
                        begin
                          //lHashStringList.Add(inttostr(FieldByName('DEVICEID').AsInteger));
                          lChildNodeParam:= TNodeParamValue.Create;
                          lChildNodeParam.NodeType:= Device;
                          lChildNodeParam.PROVINCEID:= lParentNodeParam.PROVINCEID;
                          lChildNodeParam.PARENTPROVINCEID:= lParentNodeParam.PARENTPROVINCEID;
                          lChildNodeParam.CITYID:= lParentNodeParam.CITYID;
                          lChildNodeParam.PARENTCITYID:= lParentNodeParam.PARENTCITYID;
                          lChildNodeParam.DEVICEGATHERID:= lParentNodeParam.DEVICEGATHERID;
                          lChildNodeParam.PARENTDEVICEGATHERID:= lParentNodeParam.PARENTDEVICEGATHERID;
                          lChildNodeParam.TOWNID:= lParentNodeParam.TOWNID;
                          lChildNodeParam.PARENTTOWNID:= lParentNodeParam.PARENTTOWNID;
                          lChildNodeParam.SUBURBID:= lParentNodeParam.SUBURBID;
                          lChildNodeParam.PARENTSUBURBID:= lParentNodeParam.PARENTSUBURBID;
                          lChildNodeParam.BTSID:= fieldbyname('BTS_LABEL').AsInteger;
                          lChildNodeParam.DEVICEID:= FieldByName('DEVICEID').AsInteger;
                          //lChildNodeParam.PARENTDEVICEID:= lParentNodeParam.SUBURBID;   不需要？？？？
                          lChildNodeParam.DisplayName:= FieldByName('DEVICENAME').AsString;
                          lChildNodeParam.HaveExpanded:= false;
                          lChildNodeParam.NodeLevel:= 5;

                          lChildNode:= gcxTreeView.Items.AddChildObject(aParentNode, lChildNodeParam.DisplayName, lChildNodeParam);
                          lChildNode.ImageIndex:= lChildNodeParam.NodeLevel;
                          lChildNode.SelectedIndex:= lChildNode.ImageIndex;
                          lHashStringList.AddObject(inttostr(FieldByName('DEVICEID').AsInteger),lChildNode);
                          ResultCount:=ResultCount+1;

                          if (lChildNodeParam.NodeLevel< gLastLevel) then
                            gcxTreeView.Items.AddChild(lChildNode,'aa');
                          if gExactOrFuzzySearching=1 then
                            lChildNode.Selected:= True;
                        end;
                        next;
                      end;
                      if ((lChildNodeParam<>nil) and (lChildNodeParam.NodeLevel<=gStopLevel)) or (gSearchFlag) then
                      begin
                        for i:= 0 to lHashStringList.Count -1 do
                        begin
                          lChildNode:= TTreeNode(lHashStringList.Objects[i]);
                          lChildNode.Expand(false);
                        end;
                      end;
                    end;
          Device:   begin    //从基站获取小区
                      //先删除预留的子节点
                      aParentNode.DeleteChildren;
                      DoMyFilterRecord('PARENTCELLID',inttostr(lParentNodeParam.DEVICEID),'','');
                      first;
                      lChildNodeParam:= nil;
                      while not eof do
                      begin
                        if (lHashStringList.IndexOf(inttostr(FieldByName('CELLID').AsInteger))<0)
                           //无小区
                           AND (FieldByName('CELLID').AsInteger<>-1) then
                        begin
                          lChildNodeParam:= TNodeParamValue.Create;
                          lChildNodeParam.NodeType:= CELL;
                          lChildNodeParam.PROVINCEID:= lParentNodeParam.PROVINCEID;
                          lChildNodeParam.PARENTPROVINCEID:= lParentNodeParam.PARENTPROVINCEID;
                          lChildNodeParam.CITYID:= lParentNodeParam.CITYID;
                          lChildNodeParam.PARENTCITYID:= lParentNodeParam.PARENTCITYID;
                          lChildNodeParam.DEVICEGATHERID:= lParentNodeParam.DEVICEGATHERID;
                          lChildNodeParam.PARENTDEVICEGATHERID:= lParentNodeParam.PARENTDEVICEGATHERID;
                          lChildNodeParam.TOWNID:= lParentNodeParam.TOWNID;
                          lChildNodeParam.PARENTTOWNID:= lParentNodeParam.PARENTTOWNID;
                          lChildNodeParam.SUBURBID:= lParentNodeParam.SUBURBID;
                          lChildNodeParam.PARENTSUBURBID:= lParentNodeParam.PARENTSUBURBID;
                          lChildNodeParam.BTSID:= lParentNodeParam.BTSID;
                          lChildNodeParam.DEVICEID:= lParentNodeParam.DEVICEID;
                          lChildNodeParam.PARENTDEVICEID:= lParentNodeParam.PARENTDEVICEID;

                          lChildNodeParam.CELLID:= fieldbyname('CELLID').AsInteger;
                          lChildNodeParam.FAN_ID:= fieldbyname('FAN_ID').AsInteger;
                          lChildNodeParam.PARENTCELLID:= lParentNodeParam.DEVICEID;
                          lChildNodeParam.DisplayName:= FieldByName('CELLNAME').AsString;

                          lChildNodeParam.HaveExpanded:= false;
                          lChildNodeParam.NodeLevel:= 6;

                          lChildNode:= gcxTreeView.Items.AddChildObject(aParentNode, lChildNodeParam.DisplayName, lChildNodeParam);
                          lChildNode.ImageIndex:= lChildNodeParam.NodeLevel;
                          lChildNode.SelectedIndex:= lChildNode.ImageIndex;
                          lHashStringList.AddObject(inttostr(FieldByName('CELLID').AsInteger),lChildNode);
                          //ResultCount:=ResultCount+1;

                          if (lChildNodeParam.NodeLevel< gLastLevel) then
                            gcxTreeView.Items.AddChild(lChildNode,'aa');
                          if gExactOrFuzzySearching=1 then
                            lChildNode.Selected:= True;
                        end;
                        next;
                      end;
                      if ((lChildNodeParam<>nil) and (lChildNodeParam.NodeLevel<=gStopLevel)) or (gSearchFlag) then
                      begin
                        for i:= 0 to lHashStringList.Count -1 do
                        begin
                          lChildNode:= TTreeNode(lHashStringList.Objects[i]);
                          lChildNode.Expand(false);
                        end;
                      end;
                    end;
        end;
      end;//with 结束
      //设置成已经展开
      lParentNodeParam.HaveExpanded:= true;
    except

    end;
  finally
    lHashStringList.Free;
  end;
end;

procedure TCFMS_TreeHelper.GetPathDataSet;
var
  lSqlstr: string;
begin
  //记得控制全局权限
  lSqlstr:= 'SELECT'+
            ' A.ID AS CITYID,'+
            ' A.TOP_ID AS PARENTCITYID,'+
            ' A.NAME AS CITYNAME,'+
            ' B.DEVICEGATHERID AS DEVICEGATHERID,'+
            ' A.ID AS PARENTDEVICEGATHERID,'+
            ' B.DEVICEGATHERNAME AS DEVICEGATHERNAME,'+
            ' C.ID AS TOWNID,'+
            ' C.TOP_ID AS PARENTTOWNID,'+
            ' C.NAME AS TOWNNAME,'+
            ' D.ID AS SUBURBID,'+
            ' D.TOP_ID AS PARENTSUBURBID,'+
            ' D.NAME AS SUBURBNAME,'+
            ' F.DEVICEID AS DEVICEID,'+
            ' F.BRANCH AS PARENTDEVICEID1,'+
            ' E.DEVICEGATHERID AS PARENTDEVICEID2,'+
            ' F.BTS_NAME||''[''||F.BTS_LABEL||'']'' AS DEVICENAME,'+
            ' F.BTS_NAME,F.BTS_LABEL,'+
            ' NVL(G.BTS_LABEL||G.FAN_ID,-1) AS CELLID,'+
            ' G.BTS_LABEL AS PARENTCELLID,'+
            ' G.FAN_ID AS FAN_ID,'+
            ' G.CELL_NO AS CELLNAME'+
            ' FROM POP_AREA A'+
            ' LEFT JOIN FMS_DEVICEGATHER_INFO B'+
            '     ON A.CITYID=B.CITYID'+
            ' LEFT JOIN POP_AREA C'+
            '     ON A.CITYID=C.CITYID AND A.ID=C.TOP_ID AND C.LAYER=2'+
            ' LEFT JOIN POP_AREA D'+
            '     ON C.CITYID=D.CITYID AND C.ID=D.TOP_ID AND D.LAYER=3'+
            ' LEFT JOIN FMS_DEVICEGATHER_DETAIL E'+
            '     ON B.CITYID=E.CITYID AND B.DEVICEGATHERID=E.DEVICEGATHERID'+
            ' INNER JOIN FMS_DEVICE_INFO F'+
            '     ON E.CITYID=F.CITYID AND E.DEVICEID=F.DEVICEID'+
            '     AND D.CITYID=F.CITYID AND D.ID=F.BRANCH'+
            ' LEFT JOIN FMS_CELL_DEVICE_INFO G'+
            '     ON F.CITYID=G.CITYID AND F.DEVICEID=G.BTS_LABEL'+
            ' WHERE A.LAYER=1 AND A.CITYID='+INTTOSTR(gCityid)+
            ' AND EXISTS (SELECT 1 FROM FMS_COMPANY_DEVGATHER_RELAT BB'+
            '     WHERE B.CITYID=BB.CITYID AND B.DEVICEGATHERID=BB.DEVICEGATHERID AND BB.COMPANYID IN ('+gCompanyStr+'))';
  with gClientDataSet do
  begin
    Close;
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
  end;
end;

procedure TCFMS_TreeHelper.MyFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  if self.gSearchFlag then
  begin
    if (gFieldName1='') and (gFieldValue1='') then
      Accept:= (DataSet.FindField(gFieldName).AsString= gFieldValue)
                and (   (pos(trim(uppercase(gWhereStr)),trim(uppercase(DataSet.FieldByName('BTS_LABEL').AsString)))>0)
                     or (pos(trim(uppercase(gWhereStr)),trim(uppercase(DataSet.FieldByName('BTS_NAME').AsString)))>0)
                     //第六级才有小区查询
                     or ((gStopLevel=6) and (pos(trim(uppercase(gWhereStr)),trim(uppercase(DataSet.FieldByName('CELLNAME').AsString)))>0))
                     )
    else
      Accept:= (DataSet.FindField(gFieldName).AsString= gFieldValue)
                and (DataSet.FindField(gFieldName1).AsString= gFieldValue1)
                and (   (pos(trim(uppercase(gWhereStr)),trim(uppercase(DataSet.FieldByName('BTS_LABEL').AsString)))>0)
                     or (pos(trim(uppercase(gWhereStr)),trim(uppercase(DataSet.FieldByName('BTS_NAME').AsString)))>0)
                     //第六级才有小区查询
                     or ((gStopLevel=6) and (pos(trim(uppercase(gWhereStr)),trim(uppercase(DataSet.FieldByName('CELLNAME').AsString)))>0))
                     )
  end
  else
  begin
    if (gFieldName1='') and (gFieldValue1='') then
      Accept:= (DataSet.FindField(gFieldName).AsString= gFieldValue)
    else
      Accept:= (DataSet.FindField(gFieldName).AsString= gFieldValue)
                and (DataSet.FindField(gFieldName1).AsString= gFieldValue1)
  end;
end;

procedure TCFMS_TreeHelper.MyExactFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
    if (gFieldName1='') and (gFieldValue1='') then
      Accept:= (DataSet.FindField(gFieldName).AsString= gFieldValue)
                and (trim(uppercase(gWhereStr))=trim(uppercase(DataSet.FieldByName('DEVICEID').AsString)))
    else
      Accept:= (DataSet.FindField(gFieldName).AsString= gFieldValue)
                and (DataSet.FindField(gFieldName1).AsString= gFieldValue1)
                and (trim(uppercase(gWhereStr))=trim(uppercase(DataSet.FieldByName('DEVICEID').AsString)))

end;

function TCFMS_TreeHelper.RefreshTree(aWhereStr: string; aStopLevel, aLastLevel: integer; aSearch: boolean): boolean;
var
  lTopNode: TTreeNode;
  lNodeParam: TNodeParamValue;
begin
  result:= false;
  gWhereStr:= aWhereStr;
  gStopLevel:= aStopLevel;
  gLastLevel:= aLastLevel;
  gSearchFlag:= aSearch;
  Screen.Cursor := crHourGlass;
  gcxTreeView.Items.BeginUpdate;
  ResultCount:=0;
  try
    //清空树
    ClearTreeViewNodes;
    //初始化第一个节点
    lNodeParam:= TNodeParamValue.Create;
    lNodeParam.NodeType:= PROVINCE;
    lNodeParam.PROVINCEID:= 1;
    lNodeParam.PARENTPROVINCEID:= 0;
    lNodeParam.HaveExpanded:= false;
    lNodeParam.DisplayName:= '浙江省';
    lNodeParam.HaveExpanded:= false;
    lNodeParam.NodeLevel:= 0;
    lTopNode:= gcxTreeView.Items.AddChildObject(nil,lNodeParam.DisplayName,lNodeParam);
    gcxTreeView.Items.AddChild(lTopNode,'aa');
    lTopNode.Expand(false);
  finally
    if aSearch then
      ReNewTreeOnStyle;
    gcxTreeView.Items.EndUpdate;
    Screen.Cursor := crDefault;
  end;
  if (ResultCount>0) and (gExactOrFuzzySearching=0) then
    Application.MessageBox(pchar('共有'+inttostr(ResultCount)+'个基站满足条件'), '提示', MB_OK + MB_ICONINFORMATION);
end;

procedure TCFMS_TreeHelper.TreeViewExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
  GetChildNodes(Node);
end;

procedure TCFMS_TreeHelper.ReNewTreeOnStyle;
var
  i: integer;
  lNodeParam: TNodeParamValue;
  lNodei: TTreeNode;
begin
  for i:= gcxTreeView.Items.Count -1 downto 0 do
  begin
    lNodei:= gcxTreeView.Items[i];
    lNodeParam:= TNodeParamValue(lNodei.Data);
    if lNodeParam.NodeType= DevGather then
    begin
      if not HaveDeviceLeaf(lNodei) then
      begin
        lNodei.DeleteChildren;
        lNodei.Delete;
      end;
    end;
  end;
  for i:= gcxTreeView.Items.Count -1 downto 0 do
  begin
    lNodei:= gcxTreeView.Items[i];
    lNodeParam:= TNodeParamValue(lNodei.Data);
    if lNodeParam.NodeType= TOWN then
    begin
      if not HaveDeviceLeaf(lNodei) then
      begin
        lNodei.DeleteChildren;
        lNodei.Delete;
      end;
    end;
  end;
  for i:= gcxTreeView.Items.Count -1 downto 0 do
  begin
    lNodei:= gcxTreeView.Items[i];
    lNodeParam:= TNodeParamValue(lNodei.Data);
    if lNodeParam.NodeType= SUBURB then
    begin
      if not HaveDeviceLeaf(lNodei) then
      begin
        lNodei.DeleteChildren;
        lNodei.Delete;
      end;
    end;
  end;
end;

function TCFMS_TreeHelper.HaveDeviceLeaf(aNode: TTReeNode): boolean;
var
  lNode: TTreeNode;
begin
  result:= false;
  lNode:= aNode.getFirstChild;
  while lNode<>nil do
  begin
    if TNodeParamValue(lNode.Data).NodeType = Device then
    begin
      result:= true;
      break;
    end
    else
    begin
      result:= HaveDeviceLeaf(lNode);
    end;
    if result= true then
      break;
    lNode:= lNode.getNextSibling;
  end;
end;

end.
