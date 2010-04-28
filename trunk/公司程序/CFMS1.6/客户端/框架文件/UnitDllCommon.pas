unit UnitDllCommon;

interface

uses Classes, ProjectCFMS_Server_TLB, cxGridDBTableView, cxGridTableView, SysUtils,
     cxDataStorage, cxTreeView, ComCtrls, UnitVFMSGlobal, DB, DBClient, variants,
     StringUtils, Menus, Messages, cxMemo, cxEdit, cxTextEdit;

type
  AMenuItem = Array of TMenuItem;
  
  TNodeParam = class
    NodeCode    : integer;
    NodeType    : integer;
    Parentid    : integer;
    id          : integer;
    DisplayName : string;
    SetValue    : string;
    Remark      : string;
  end;
  TFlowColorSet = class
    Cityid,
    Batchid,
    Companyid: integer;
    Trackid: integer;
  end;
  procedure cxTreeViewMouseDown(acxTreeView: TcxTreeView; X,Y: Integer);
  procedure SetChildNode(aImageIndex: Integer; aNode: TTreeNode);
  procedure SetParentNode(aImageIndex: Integer; aNode: TTreeNode);
  function GetServerSysDate: TDateTime;

    //复制数据集
  procedure CloneDateSet(aSource,aTarget: TClientDataSet);
  function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
  procedure InPutNum(var key: Char);
  procedure InPutfloat(var key: Char);
  //取字典表
  procedure GetDic(aCityid, aDicType:integer;DicCodeItems:TStrings);
  procedure GetFlowtache(aCityid, aDicType:integer;DicCodeItems:TStrings);
  //去字典表 去掉未-1的父节点
  procedure GetDicItem(aCityid, aDicType:integer;DicCodeItems:TStrings);
  //取对象值
  function GetDicCode(DicName:string;Items:TStrings):integer;
  //根据ITEMNAME取ITEMDEX
  function GetItemIndex(DicName:string;Items:TStrings):integer;
  //根据ITEMOBJECT取ITEMDEX
  function GetItemIndexByObject(aWdInteger:integer;Items:TStrings):integer;
  //判断某表某字段内容是否重复
  function IsExists(aTableName,aFieldName,aFieldValue: string; aKeyFieldName: string=''; aKeyFieldValue: string=''): boolean;
  //设备集
  procedure GetDeviceGather(aCityid, aCompanyid: integer; Items:TStrings);
  //告警内容
  procedure GetContentCode(aCityid, aCompanyid: integer; Items:TStrings);
  //加载字段
  procedure LoadFields(aView : TcxGridDBTableView; aCityid, aUserid, aFieldGroup: integer);
  procedure AddCategory(aView : TcxGridDBTableView; aCityid, aUserid, aFieldGroup: integer);
  //CXGRIDVIEW加字段
  procedure AddViewField(aView : TcxGridDBTableView;aFieldName, aCaption : String; aWidth: integer=65);overload;
  procedure AddViewFieldVisiable(aView: TcxGridDBTableView; aFieldName, aCaption: String; aVisible: boolean; aWidth: integer=65);
  procedure AddViewFieldMemo(aView : TcxGridDBTableView;aFieldName, aCaption : String; aLines: integer; aWidth: integer=65);overload;
  //判断CXGRIDVIEW是否选择一条记录
  function CheckRecordSelected(aView :TcxGridDBTableView):boolean;

  //画告警状态树
  procedure DrawAlarmStatusTree(aTree: TcxTreeView; aCityid, aDictype: integer);
  procedure AddNode(aTree: TcxTreeView; aParentNode: TTreeNode; aCityid, aDictype, aParentid: integer);
  //function GetNodeType(aIndex: integer):TNodeType;
  procedure SelectNode(aTreeView: TcxTreeView; aNodeText: string);
  procedure LocateSigleNode(aTreeView: TcxTreeView; aNodeText: string);

  //针对告警
  //获取指定维护单位下所有的节点
  procedure LoadCompanyItemChild(aCityid,aCompanyid: integer;aItems: TStrings);
  //获取指定区域下所有的(叶子)节点
  function GetCompanyChildLeaf(aCityid,aCompanyid : integer):string;
  //根据类型和父节点返回 AMenuItem
  function GetMenuItem(kind:integer;AClickEvent: TNotifyEvent;parent:integer=0): AMenuItem;
  //模糊查询条件生成函数 aField-字段名 aValue-模糊值 返回-where后的条件语句
  function GetBlurQueryWhere(aFieldName, aFieldCode, aValue: string): string;
  //流程环节要显色
  function GetFlowColorSet(aDataSet: TDataSet; var aList: TStringList): boolean;
  //流程环节的隐藏字段
  procedure AddHindFlowField(aView: TcxGridDBTableView);

  var
    gTempInterface: IDataModuleRemoteDisp;   //给DLL传递的接口
    gPublicParam: TPublicParameter;
    gDllMsgCall: TDllMessage;

implementation

procedure AddHindFlowField(aView: TcxGridDBTableView);
begin
  aView.OptionsView.CellAutoHeight:= true;//实现自动换行
  AddViewFieldVisiable(aView,'trackid','操作流水号',false);
  AddViewFieldVisiable(aView,'cityid','地市编号',false);
  AddViewFieldVisiable(aView,'batchid','主障编号',false);
  AddViewFieldVisiable(aView,'alarmid','从障编号',false);
  try
    aView.GetColumnByFieldName('operatename').Width:= 120;
    //aView.GetColumnByFieldName('operatename').Properties.Alignment.Horz:= taLeftJustify;
    //aView.GetColumnByFieldName('operatename').Properties.Alignment.Vert:= taVCenter;
  except
  end;
  try
    aView.GetColumnByFieldName('stationname').Width:= 65;
  except
  end;
  try
    aView.GetColumnByFieldName('operatorname').Width:= 65;
  except
  end;
  try
    aView.GetColumnByFieldName('mobilephone').Width:= 120;
  except
  end;
  try
    aView.GetColumnByFieldName('flowinformation').Width:= 300;
  except
  end;
  try
    aView.GetColumnByFieldName('operatetime').Width:= 120;
  except
  end;
  try
    aView.GetColumnByFieldName('companyname').Width:= 65;
  except
  end;
  try
    aView.GetColumnByFieldName('oprecdiachronic').Width:= 65;
  except
  end;
end;

procedure AddViewFieldVisiable(aView: TcxGridDBTableView; aFieldName, aCaption: String; aVisible: boolean; aWidth: integer=65);
begin
  //aView.BeginUpdate;
  try
    with aView.CreateColumn as TcxGridColumn do
    begin
      Caption := aCaption;
      DataBinding.FieldName:= aFieldName;
      DataBinding.ValueTypeClass := TcxStringValueType;
      HeaderAlignmentHorz := taCenter;
      Width:=aWidth;
      Visible:= aVisible;
    end;
  finally
    //aView.EndUpdate;
  end;
end;

function GetFlowColorSet(aDataSet: TDataSet; var aList: TStringList): boolean;
var
  lFlowColorSet: TFlowColorSet;
  lSignStr: string;
  lIndex: integer;
  I: integer;
begin
  result:= false;
  ClearTStrings(aList);
  with aDataSet do
  begin
    if not Active then exit;
    first;
    while not eof do
    begin
      //如果从一个告警转发到另外一个单位且原单位不删除，
      //若原单位之后未做其他操作，则高亮显示转发流程前原单位的流程和目的单位的最后一个流程
      if FieldByName('operate').AsInteger = 16 then
      begin
        next;
        continue;
      end;
      //如果是转派表alarm_oprec_return的日志流程不显示
      if FieldByName('returnflag').AsInteger<>1 then
      begin
        next;
        continue;
      end;
      
      lSignStr:= FieldByName('Cityid').AsString+'&'+
                 FieldByName('Batchid').AsString+'&'+
                 FieldByName('Companyid').AsString;
      lIndex:= aList.IndexOf(lSignStr);
      if lIndex = -1 then
      begin
        lFlowColorSet:= TFlowColorSet.Create;
        lFlowColorSet.Cityid:= FieldByName('Cityid').AsInteger;
        lFlowColorSet.Batchid:= FieldByName('Batchid').AsInteger;
        lFlowColorSet.Companyid:= FieldByName('Companyid').AsInteger;
        lFlowColorSet.Trackid:= FieldByName('Trackid').AsInteger;
        aList.AddObject(lSignStr,lFlowColorSet);
      end
      else
      begin
        lFlowColorSet:= TFlowColorSet(aList.Objects[lIndex]);
        //根据  Trackid 判断谁先谁后
        if lFlowColorSet.Trackid< FieldByName('Trackid').AsInteger then
          lFlowColorSet.Trackid:= FieldByName('Trackid').AsInteger;
      end;
      next;
    end;
  end;
  //做个转换
  for i:= 0 to aList.Count -1 do
  begin
    lFlowColorSet:= TFlowColorSet(aList.Objects[i]);
    aList.Strings[i]:= inttostr(lFlowColorSet.Cityid)+'&'+inttostr(lFlowColorSet.Trackid);
  end;
  result:= true;
end;

procedure LocateSigleNode(aTreeView: TcxTreeView; aNodeText: string);
var
  I: integer;
begin
  for I:= 0 to aTreeView.Items.Count -1 do
  begin
    //if aTreeView.Items[i].Text= aNodeText then
    if (aTreeView.Items[i].Data<>nil)
      and (TNodeParam(aTreeView.Items[i].Data).DisplayName= aNodeText) then
    begin
      aTreeView.Selected:= aTreeView.Items[i];
      break;
    end;
  end;
end;

procedure SelectNode(aTreeView: TcxTreeView; aNodeText: string);
var
  I: integer;
begin
  for I:= 0 to aTreeView.Items.Count -1 do
  begin
    if aTreeView.Items[i].Text= aNodeText then
    begin
      if aTreeView.Selected = nil then
      begin
        aTreeView.Selected:= aTreeView.Items[i];
        break;
      end;
    end;
  end;
end;

procedure GetFlowtache(aCityid, aDicType:integer;DicCodeItems:TStrings);
var
  lWdInteger:TWdInteger;
  lDataSet: TClientDataSet;
begin
  ClearTStrings(DicCodeItems);
  lDataSet:= TClientDataSet.Create(nil);
  try
    with lDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,11,aCityid,aDicType]),0);
      while not eof do
      begin
        lWdInteger:=TWdInteger.Create(Fieldbyname('diccode').AsInteger);
        DicCodeItems.AddObject(Fieldbyname('dicname').AsString,lWdInteger);
        next;
      end;
      Close;
    end;
  finally
    lDataSet.Free;
  end;
end;

procedure GetContentCode(aCityid, aCompanyid: integer; Items:TStrings);
var
  lCompanyLeafStr: string;
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
begin
  lCompanyLeafStr:= GetCompanyChildLeaf(aCityid,aCompanyid);
  lClientDataSet:= TClientDataSet.create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,9,aCityid,lCompanyLeafStr]),0);
      first;
      while not eof do
      begin
        lWdInteger:=TWdInteger.Create(Fieldbyname('alarmcontentcode').AsInteger);
        Items.AddObject(Fieldbyname('alarmcontentname').AsString,lWdInteger);
        next;
      end;
    end;
  finally
    lClientDataSet.free;
  end;
end;

procedure GetDeviceGather(aCityid, aCompanyid: integer; Items:TStrings);
var
  lCompanyLeafStr: string;
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
begin
  lCompanyLeafStr:= GetCompanyChildLeaf(aCityid,aCompanyid);
  lClientDataSet:= TClientDataSet.create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,8,aCityid,lCompanyLeafStr]),0);
      first;
      while not eof do
      begin
        lWdInteger:=TWdInteger.Create(Fieldbyname('devicegatherid').AsInteger);
        Items.AddObject(Fieldbyname('devicegathername').AsString,lWdInteger);
        next;
      end;
    end;
  finally
    lClientDataSet.free;
  end;
end;

function GetMenuItem(kind:integer;AClickEvent: TNotifyEvent;parent:integer=0): AMenuItem;
var
  NewItem :TMenuItem;
  i : integer;
  sqlstr :String;
  AM :AMenuItem;
  levelstr :String;
  lClientDataSet: TClientDataSet;
begin
  AM :=nil;
  result := nil;
  if kind = 7 then
    levelstr := ' and setvalue <='''+IntToStr(gPublicParam.CauseLevel)+''''
  else
    levelstr :='';
  if parent <> 0 then
    sqlstr := 'select diccode,dicname,setvalue from alarm_dic_code_info where dictype = '+IntToStr(kind)+
              ' and ifineffect = 1 and parentid ='+inttostr(parent)+
              ' and cityid='+inttostr(gPublicParam.CityID)+levelstr
  else
    sqlstr := 'select diccode,dicname,setvalue from alarm_dic_code_info where dictype = '+IntToStr(kind)+
              ' and parentid = 0 and ifineffect = 1'+
              ' and cityid='+inttostr(gPublicParam.CityID)+levelstr;
  lClientDataSet:= TClientDataSet.create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,sqlstr]),0);
      first;
      i := 0;
      setlength(result, recordcount);
      while not eof do
      begin
        NewItem :=TMenuItem.Create(nil);
        NewItem.SubMenuImages := nil;
        NewItem.Caption := FieldByName('dicname').AsString;
        NewItem.Tag := FieldByName('diccode').AsInteger;
        NewItem.OnClick:= AClickEvent;
        AM := GetMenuItem(kind,AClickEvent,NewItem.Tag);
        NewItem.Add(AM);
        result[i] := NewItem;
        Inc(i);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

function GetCompanyChildLeaf(aCityid,aCompanyid : integer):string;
var
  lClientDataSet: TClientDataSet;
  lCompanyidStr: string;
begin
  lClientDataSet:= TClientDataSet.create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,7,aCityid,aCompanyid]),0);
      first;
      while not eof do
      begin
        lCompanyidStr:= lCompanyidStr+ FieldByName('companyid').AsString+ ',';
        next;
      end;
    end;
    result:= copy(lCompanyidStr,1,length(lCompanyidStr)-1);
  finally
    lClientDataSet.Free;
  end;
end;

procedure LoadCompanyItemChild(aCityid,aCompanyid: integer; aItems: TStrings);
var
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
begin
  lClientDataSet:= TClientDataSet.create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,6,aCityid,aCompanyid]),0);
      first;
      while not eof do
      begin
        lWdInteger:=TWdInteger.Create(Fieldbyname('companyid').AsInteger);
        aItems.AddObject(Fieldbyname('companyname').AsString,lWdInteger);
        next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

{function GetNodeType(aIndex: integer):TNodeType;
begin
  case aIndex of
    0: result:= wdAll;
    1: result:= wdAlarmOnline_S;
    2: result:= wdNoTake;
    3: result:= wdHasTake;
    4: result:= wdHasDeal;
    5: result:= wdHasBack;
    6: result:= wdHasClear;
    7: result:= wdHasCommit;
    8: result:= wdHasOutTime;
    9: result:= wdAlarmLevel_S;
    10: result:= wdUrgency;
    11: result:= wdImport;
    12: result:= wdAlarmType_S;
    13: result:= wdLineCause;
    14: result:= wdDeviceCause;
    15: result:= wdDifficulty_S;
    16: result:= wdDifficulty;
    17: result:= wdPriorOutTime;
    18: result:= wdAlarmSearch_S;
    else result:= wdAll;
  end;
end;}

procedure DrawAlarmStatusTree(aTree: TcxTreeView; aCityid, aDictype: integer);
begin
  AddNode(aTree,nil,aCityid,aDictype,-1);
  aTree.FullCollapse;
  aTree.FullExpand;
end;

procedure AddNode(aTree: TcxTreeView; aParentNode: TTreeNode; aCityid, aDictype, aParentid: integer);
var
  lClientDataSet: TClientDataSet;
  lNode: TTreeNode;
  lNodeParam: TNodeParam;
begin
  lClientDataSet:= TClientDataSet.create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,5,aCityid,aDictype,aParentid]),0);
      first;
      while not eof do
      begin
        lNodeParam:= TNodeParam.Create;
        lNodeParam.NodeCode:= FieldbyName('diccode').AsInteger;
        lNodeParam.NodeType:= FieldbyName('dictype').AsInteger;
        lNodeParam.Parentid:= FieldByName('parentid').asinteger;
        lNodeParam.id:= FieldByName('diccode').asinteger;
        lNodeParam.DisplayName:= FieldByName('dicname').AsString;
        lNodeParam.SetValue:= FieldByName('setvalue').AsString;
        if FieldByName('remark').AsString='' then
          lNodeParam.Remark:= '0'
        else
          lNodeParam.Remark:= FieldByName('remark').AsString;
        lNode:= aTree.Items.AddChildObject(aParentNode,lNodeParam.DisplayName,lNodeParam);
        lNode.ImageIndex:= lNode.Level;
        lNode.SelectedIndex:= lNode.ImageIndex;

        AddNode(aTree,lNode,aCityid,aDictype,lNodeParam.id);

        next;
      end;
    end;
  finally
    lClientDataSet.Close;
    lClientDataSet.free;
  end;
end;

procedure AddCategory(aView : TcxGridDBTableView;
  aCityid, aUserid, aFieldGroup: integer);
var
  lDataSet: TClientDataSet;
begin
  lDataSet:= TClientDataSet.Create(nil);
  try
    with lDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,2,aCityid,aUserid,aFieldGroup]),0);
      if Eof then //用户未自定义
      begin
        close;
        ProviderName:='dsp_General_data';
        Data:=gTempInterface.GetCDSData(VarArrayOf([101,3,aCityid,aFieldGroup]),0);
      end
      else        //用户自定义
      begin
        close;
        ProviderName:='dsp_General_data';
        Data:=gTempInterface.GetCDSData(VarArrayOf([101,4,aCityid,aUserid,aFieldGroup]),0);
      end;

      first;
      while not eof do
      begin
        AddViewField(aView, FieldByName('col_name_eng').AsString,
                     FieldByName('col_name_cn').AsString, FieldByName('colwide').AsInteger);
        next;
      end;
    end;
  finally
    lDataSet.Free;
  end;
end;

procedure LoadFields(aView : TcxGridDBTableView;
  aCityid, aUserid, aFieldGroup: integer);
begin
  AddCategory(aView, aCityid, aUserid, aFieldGroup);
end;

function IsExists(aTableName,aFieldName,aFieldValue: string;
  aKeyFieldName: string=''; aKeyFieldValue: string=''): boolean;
var
  lDataSet: TClientDataSet;
begin
  lDataSet:= TClientDataSet.Create(nil);
  try
    with lDataSet do
    begin
      close;
      ProviderName:='dsp_General_data';
      if trim(aKeyFieldValue)='' then  //新增
        Data:=gTempInterface.GetCDSData(VarArrayOf([101,1,aTableName,aFieldName,aFieldValue,' and 1=1']),0);
      if trim(aKeyFieldValue)<>'' then
        Data:=gTempInterface.GetCDSData(VarArrayOf([101,1,aTableName,aFieldName,aFieldValue,' and upper(to_char('+aKeyFieldName+'))<>'''+uppercase(aKeyFieldValue)+'''']),0);
      if eof then
        result:= false
      else
        result:= true;
    end;
  finally
    lDataSet.Free;
  end;
end;

procedure AddViewField(aView : TcxGridDBTableView;
  aFieldName, aCaption : String; aWidth: integer=65);overload;
begin
  //aView.BeginUpdate;
  try
    with aView.CreateColumn as TcxGridColumn do
    begin
      Caption := aCaption;
      DataBinding.FieldName:= aFieldName;
      DataBinding.ValueTypeClass := TcxStringValueType;
      HeaderAlignmentHorz := taCenter;
      Width:=aWidth;

      PropertiesClassName:= 'TcxTextEditProperties';
      TcxTextEditProperties(Properties).Alignment.Horz:= taLeftJustify;
      TcxTextEditProperties(Properties).Alignment.Vert:= taVCenter;
      HeaderAlignmentHorz := taCenter;
    end;
  finally
    //aView.EndUpdate;
  end;
end;

procedure AddViewFieldMemo(aView : TcxGridDBTableView;aFieldName, aCaption : String;
  aLines: integer; aWidth: integer=65);overload;
begin
  //aView.BeginUpdate;
  try
    with aView.CreateColumn as TcxGridColumn do
    begin
      Caption:= aCaption;
      DataBinding.FieldName:= aFieldName;
      DataBinding.ValueTypeClass:= TcxStringValueType;
      HeaderAlignmentHorz:= taCenter;
      Width:= aWidth;
      PropertiesClassName:= 'TcxMemoProperties';
      TcxMemoProperties(Properties).VisibleLineCount:= aLines;
      TcxMemoProperties(Properties).WantReturns := False;
    end;
  finally
    //aView.EndUpdate;
  end;
end;

function GetItemIndexByObject(aWdInteger:integer;Items:TStrings):integer;
var
  i: Integer;
begin
  result:=-1;
  for i := 0 to Items.Count - 1 do
  begin
    if TWdInteger(Items.Objects[i]).Value=aWdInteger then
    begin
      result:= I;
      break;
    end;
  end;
end;

function GetItemIndex(DicName:string;Items:TStrings):integer;
var
  i: Integer;
begin
  result:=-1;
  for i := 0 to Items.Count - 1 do
  begin
    if uppercase(DicName)=uppercase(Items.Strings[i]) then
    begin
      result:= i;
      break;
    end;
  end;
end;

function GetDicCode(DicName:string;Items:TStrings):integer;
var
  i: Integer;
  lWdInteger:TWdInteger;
begin
  result:=-1;
  for i := 0 to Items.Count - 1 do
  begin
    if uppercase(DicName)=uppercase(Items.Strings[i]) then
    begin
      lWdInteger:=TWdInteger(Items.Objects[i]);
      result:=lWdInteger.Value;
      break;
    end;
  end;
end;

procedure GetDic(aCityid, aDicType:integer;DicCodeItems:TStrings);
var
  lWdInteger:TWdInteger;
  lDataSet: TClientDataSet;
begin
  ClearTStrings(DicCodeItems);
  lDataSet:= TClientDataSet.Create(nil);
  try
    with lDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,10,aCityid,aDicType]),0);
      while not eof do
      begin
        lWdInteger:=TWdInteger.Create(Fieldbyname('diccode').AsInteger);
        DicCodeItems.AddObject(Fieldbyname('dicname').AsString,lWdInteger);
        next;
      end;
      Close;
    end;
  finally
    lDataSet.Free;
  end;
end;

procedure GetDicItem(aCityid, aDicType:integer;DicCodeItems:TStrings);
var
  lWdInteger:TWdInteger;
  lDataSet: TClientDataSet;
begin
  ClearTStrings(DicCodeItems);
  lDataSet:= TClientDataSet.Create(nil);
  try
    with lDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,12,aCityid,aDicType]),0);
      while not eof do
      begin
        lWdInteger:=TWdInteger.Create(Fieldbyname('diccode').AsInteger);
        DicCodeItems.AddObject(Fieldbyname('dicname').AsString,lWdInteger);
        next;
      end;
      Close;
    end;
  finally
    lDataSet.Free;
  end;
end;

procedure InPutfloat(var key: Char);
begin
  if not (key in ['0'..'9','.','-', #8,#13,#38,#40]) then
  begin
    Key := #0;
  end;
end;

procedure InPutNum(var key: Char);
begin
  if not (key in ['0'..'9', #8,#13,#38,#40]) then
  begin
    Key := #0;
  end;
end;

procedure CloneDateSet(aSource,aTarget: TClientDataSet);
var
  i:integer;
  lFieldDef:TFieldDef;
  lCDS:TClientDataSet;
begin
  lCDS:=TClientDataSet.Create(nil);
  for i := 0 to aSource.FieldDefs.Count - 1 do
  begin
    lFieldDef:=aSource.FieldDefs.Items[i];
    with lCDS.FieldDefs.AddFieldDef do
    begin
      DataType := lFieldDef.DataType;
      Size := lFieldDef.Size;
      Name := lFieldDef.Name;
    end;
  end;
  lCDS.CreateDataSet;
  aSource.First;
  while not aSource.Eof do
  begin
    lCDS.Edit;
      lCDS.Append;
      lCDS.Post;
      lCDS.Edit;
    for i := 0 to lCDS.FieldDefs.Count - 1 do
    begin
      lCDS.FieldValues[lCDS.FieldDefs.Items[i].Name]:=aSource.FieldValues[lCDS.FieldDefs.Items[i].Name];
    end;
    lCDS.Post;
    aSource.Next;
  end;
  aTarget.Data:=lCDS.Data;
  lCDS.Free;
end;

function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
begin
  if HoldTime then
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD HH:MI:SS')+')'
  else
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD')+')';
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

procedure cxTreeViewMouseDown(acxTreeView: TcxTreeView; X,Y: Integer);
  var FNode: TTreeNode;
begin
  if not(htonitem in acxTreeView.GetHitTestInfoAt(X,Y)) then
    Exit;
  FNode:= acxTreeView.Selected;
  if FNode=nil then Exit;
  acxTreeView.Items.BeginUpdate;
  if FNode.ImageIndex=0 then
    FNode.ImageIndex:=1
  else
    FNode.ImageIndex:=0;

  FNode.SelectedIndex:= FNode.ImageIndex;

  if FNode.HasChildren then
    SetChildNode(FNode.ImageIndex,FNode);
  SetParentNode(FNode.ImageIndex,FNode);
  acxTreeView.Items.EndUpdate;
end;

procedure SetChildNode(aImageIndex: Integer; aNode: TTreeNode);
 var I: Integer;
begin
  if aNode.HasChildren then
  begin
    for I:=0 to aNode.Count-1 do
    begin
      aNode.Item[I].ImageIndex:= aImageIndex;
      aNode.Item[I].SelectedIndex:= aNode.Item[I].ImageIndex;
      SetChildNode(aImageIndex,aNode.Item[i]);
    end;
  end;
end;

procedure SetParentNode(aImageIndex: Integer; aNode: TTreeNode);
var
  I: Integer;
  fTempNode: TTreeNode;
  fFlag: Boolean;
begin
  fFlag:= False;
  fTempNode:= aNode.Parent;
  if fTempNode<>nil then
  begin
    if aNode.ImageIndex=1 then
    begin
      for I:=0 to fTempNode.Count-1 do
      begin
        if (fTempNode.Item[i].ImageIndex=0)or(fTempNode.Item[i].ImageIndex=2) then
        begin
          fTempNode.ImageIndex:=2;
          fFlag:= True;
          Break;
        end;
      end;
      if not fFlag then
      begin
        fTempNode.ImageIndex:= aImageIndex;
        fTempNode.SelectedIndex:= fTempNode.ImageIndex;
      end;
    end
    else if aImageIndex=0 then
    begin
      for I:=0 to fTempNode.Count-1 do
      begin
        if (fTempNode.Item[i].ImageIndex=1)or(fTempNode.Item[i].ImageIndex=2) then
        begin
          fTempNode.ImageIndex:=2;
          fFlag:= True;
          Break;
        end;
      end;
      if not fFlag then
      begin
        fTempNode.ImageIndex:= aImageIndex;
        fTempNode.SelectedIndex:= fTempNode.ImageIndex;
      end;
    end;
    SetParentNode(aImageIndex,fTempNode);
  end;
end;

function GetServerSysDate: TDateTime;
var
  lClientDataSet : TClientDataSet;
begin
  Result := -1;
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,'select sysdate from dual']),0);
      if eof and (RecordCount<>1) then
        Exit
      else
        result:= FieldByName('Sysdate').AsDateTime;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

function GetBlurQueryWhere(aFieldName, aFieldCode, aValue: string): string;
begin
  Result:='';
  if (Trim(aFieldName)='')or (Trim(aFieldCode)='') or (aValue='') then
    Exit;
  Result:= ' and (upper(' + aFieldName + ') like ''' + '%' + UpperCase(aValue) +'%''' +
                ' or upper(' + aFieldCode + ') like ''' + '%' + UpperCase(aValue) +'%''' + ')';
end;

end.
