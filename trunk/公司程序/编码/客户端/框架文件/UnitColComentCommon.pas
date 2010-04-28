unit UnitColComentCommon;

interface

uses Classes, Contnrs, Variants, DB, DBClient,ComCtrls,SysUtils,Inifiles;

type
  TColumnParam=class
    ID:Integer;
    Cityid:Integer;
    COL_NAME_ENG:String;
    COL_NAME_CN:String;
  end;

  Tnodetype=(nt_root,nt_Group,nt_col);
  TGroupParam=class
    nodetype:Tnodetype;
    devicetype:Integer;
    id:integer;
    parentid:integer;
    cityid:integer;
    name:string;
    isExpand:Boolean;
  end;
  //分组树图
  procedure InitDeviceType(aTreeView:TTreeView;aChildLevel:Boolean=true);
  procedure AddChildNode(aTreeNode:TTreeNode;aParent_id:Integer;aChildLevel:Boolean=true);
  procedure DestoryTreeview(aTreeView:TTreeView);
  procedure DestoryListView(aListView: TListView);
  function GetGroupIDList(aNode:TTreeNode;var aidStr:string):String;
  procedure ShowGroupColInfo(aNode: TTreeNode; aListViewGroup:TListView);
  procedure ShowUnGroupColInfo(aNode: TTreeNode; aListViewGroup:TListView);

implementation

uses UnitDllCommon;


procedure InitDeviceType(aTreeView:TTreeView;aChildLevel:Boolean=true);
var
  lGroupParam:TGroupParam;
  lTreeNode:TTreeNode;
begin
  lGroupParam:=TGroupParam.Create;
  lGroupParam.id:=-2;
  lGroupParam.Name:='字段分组';
  lGroupParam.parentid:= -3;
  lGroupParam.devicetype:=0;
  lGroupParam.nodetype:= nt_root;
  lTreeNode:=aTreeView.Items.AddObject(nil,lGroupParam.Name,lGroupParam);
  lTreeNode.ImageIndex:= lTreeNode.Level ;
  lTreeNode.SelectedIndex:=lTreeNode.ImageIndex;
  AddChildNode(lTreeNode,-1,aChildLevel) ;
  aTreeView.FullCollapse;
  aTreeView.FullExpand;
  //aTreeView.Perform(WM_VSCROLL,SB_TOP,0);
end;

procedure AddChildNode(aTreeNode:TTreeNode;aParent_id:Integer;aChildLevel:Boolean);
var
  lGroupParam:TGroupParam;
  lTreeNode:TTreeNode;
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=gTempInterface.GetCDSData(VarArrayOf([21,1,aParent_id]),0);
    first;
    try
      while not eof do
      begin
        lGroupParam:=TGroupParam.Create;
        lGroupParam.id:=FieldByName('ID').AsInteger;
        lGroupParam.Name:=FieldByName('GROUP_NAME').AsString;
        lGroupParam.parentid:= FieldByName('PARENT_ID').AsInteger;
        lGroupParam.devicetype:=FieldByName('DEVICE_TYPE').AsInteger;
        lGroupParam.cityid:= FieldByName('CityID').AsInteger;
        lGroupParam.nodetype:= nt_Group;
        lTreeNode:=TTreeView(aTreeNode.TreeView).Items.AddChildObject(aTreeNode,lGroupParam.Name,lGroupParam);
        lTreeNode.ImageIndex:= lTreeNode.level ;
        lTreeNode.SelectedIndex:=lTreeNode.ImageIndex;
        //lTreeNode.Expand(true);
        //添加子结点
        if aChildLevel then
           AddChildNode(lTreeNode,lGroupParam.id);
        next;
      end;
    finally
      lClientDataSet.Close;
      lClientDataSet.free;
    end;
  end;
end;

function GetGroupIDList(aNode:TTreeNode;var aidStr:string):String;
var
  i:Integer;
begin
  if aNode.HasChildren then
  begin
    for i := 0 to aNode.Count - 1 do
    begin
      GetGroupIDList(aNode.Item[i],aidStr);
    end;
  end
  else
    aidstr:= aidstr+inttostr(TGroupParam(aNode.Data).id)+',';
  Result:= aidStr;
end;

procedure ShowUnGroupColInfo(aNode: TTreeNode; aListViewGroup:TListView);
var
  newlistItem:TlistItem;
  lorder:integer;
  lColParam:TColumnParam;
  lClientDataSet: TClientDataSet;
  lDeviceType: integer;
begin
  lDeviceType:= TGroupParam(aNode.Data).devicetype;

  lClientDataSet:= TClientDataSet.create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=gTempInterface.GetCDSData(VarArrayOf([21,3,lDeviceType]),0);
    first;
    lorder:=1;
    DestoryListView(aListViewGroup);
    aListViewGroup.Items.BeginUpdate;
    try
      while not eof do
      begin
        lColParam:=TColumnParam.Create ;
        lColParam.ID := FieldbyName('id').AsInteger;
        lColParam.Cityid:= FieldbyName('cityid').AsInteger;
        lColParam.COL_NAME_ENG:= FieldbyName('col_name_eng').AsString;
        lColParam.COL_NAME_CN:= FieldbyName('col_name_cn').AsString;

        newlistItem:=aListViewGroup.Items.Add;
        newlistItem.Data := lColParam;
        newlistItem.Caption:=format('%0.3d',[lorder]) ;
        newlistItem.SubItems.Add(lColParam.COL_NAME_CN);
        newlistItem.SubItems.Add(lColParam.COL_NAME_ENG);
        newlistItem.SubItems.Add(IntToStr(lColParam.ID));
        next;
        inc(lorder);
      end;
    finally
      aListViewGroup.Items.EndUpdate;
    end;
  end;
end;

procedure ShowGroupColInfo(aNode: TTreeNode; aListViewGroup:TListView);
var
  lidstr:String;
  lorder:integer;
  newlistItem:TlistItem;
  lColParam:TColumnParam;
  lClientDataSet: TClientDataSet;
begin
  GetGroupIDList(aNode,lidstr);
  lidstr:=Copy(lidstr,1,length(lidstr)-1);
  lClientDataSet:= TClientDataSet.create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=gTempInterface.GetCDSData(VarArrayOf([21,2,lidstr]),0);
    first;
    lorder:=1;
    DestoryListView(aListViewGroup);
    aListViewGroup.Items.BeginUpdate;
    try
      while not eof do
      begin
        lColParam:=TColumnParam.Create ;
        lColParam.ID := FieldbyName('id').AsInteger;
        lColParam.Cityid:= FieldbyName('cityid').AsInteger;
        lColParam.COL_NAME_ENG:= FieldbyName('col_name_eng').AsString;
        lColParam.COL_NAME_CN:= FieldbyName('col_name_cn').AsString;

        newlistItem:=aListViewGroup.Items.Add;
        newlistItem.Data := lColParam;
        newlistItem.Caption:=format('%0.3d',[lorder]) ;
        newlistItem.SubItems.Add(lColParam.COL_NAME_CN);
        newlistItem.SubItems.Add(lColParam.COL_NAME_ENG);
        newlistItem.SubItems.Add(IntToStr(lColParam.ID));
        next;
        inc(lorder);
      end;
    finally
      aListViewGroup.Items.EndUpdate;
    end;
  end;
end;


procedure DestoryTreeview(aTreeView:TTreeView);
var
  i:Integer;
begin
  for i := aTreeView.Items.Count - 1  downto 0  do
    TGroupParam(aTreeView.Items[i].Data).Free;
  aTreeView.Items.Clear;
end;

procedure DestoryListView(aListView: TListView);
var
  i:Integer;
begin
  for i := 0 to aListView.Items.Count - 1 do
     TColumnParam(aListView.Items[i].Data).Free;
  aListView.Items.Clear;
end;

end.
