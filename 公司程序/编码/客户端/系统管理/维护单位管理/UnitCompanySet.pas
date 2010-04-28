unit UnitCompanySet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, jpeg, ExtCtrls, CheckLst, Buttons, DBClient, DB,
  IniFiles, StringUtils, Menus, ImgList;

const gFiltedFieldName1= 'alarmcontentcode';
      gFiltedFieldName2= 'alarmcontentname';
type
  TActedPage= set of (wd_Acted_Preview,
                      wd_Acted_ContentModel,
                      wd_Acted_ContentSet);

  TCompanyNodeParam = class
    Cityid: integer;
    Companyid: integer;
    CompanyName: string;
    DisPlayName: string;
    ParentID: integer;
    IsLeaf: boolean;
    Modelid: integer;
    Address, Phone, Fix, Linkman: string;
  end;
  TAlarmParam= class
    CompanyParam: integer;
    GatherParam: integer;
    ContentParam: integer;
  end;
  TAlarmParamInput = class
    Companyid: integer;
    GatherStr: string;
    ContentStr: string;
  end;
  TFormCompanySet = class(TForm)
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    PageControl1: TPageControl;
    TabSheetPreview: TTabSheet;
    TabSheetContentModel: TTabSheet;
    TabSheetContentSet: TTabSheet;
    GroupBox1: TGroupBox;
    TreeViewCompany: TTreeView;
    Panel3: TPanel;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    CheckListBoxDeviceGather: TCheckListBox;
    Panel4: TPanel;
    GroupBox3: TGroupBox;
    Panel5: TPanel;
    ListViewContentDetail: TListView;
    GroupBox4: TGroupBox;
    GroupBox6: TGroupBox;
    Panel7: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    GroupBox7: TGroupBox;
    ListViewContentModelDetail: TListView;
    Panel9: TPanel;
    ButtonSave2: TButton;
    ButtonClose2: TButton;
    ButtonClose1: TButton;
    GroupBox8: TGroupBox;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel14: TPanel;
    GroupBox10: TGroupBox;
    ListViewContentDetailSet: TListView;
    Panel15: TPanel;
    ButtonSave3: TButton;
    ButtonClose3: TButton;
    GroupBox5: TGroupBox;
    CheckListBoxContent: TCheckListBox;
    Panel10: TPanel;
    SpeedButtonSearch: TSpeedButton;
    EditContentFilter: TEdit;
    GroupBox9: TGroupBox;
    TreeViewCompanySet: TTreeView;
    ButtonSave1: TButton;
    ComboBoxContentModel: TComboBox;
    ButtonLoad: TButton;
    ListViewContentModel: TListView;
    ListViewContentModelSet: TListView;
    PopupMenu3: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    PopupMenu1: TPopupMenu;
    NAddModel: TMenuItem;
    NModifyModel: TMenuItem;
    NDelModel: TMenuItem;
    PopupMenu2: TPopupMenu;
    NAddCompany: TMenuItem;
    NModifyCompany: TMenuItem;
    NDelCompany: TMenuItem;
    PopupMenu4: TPopupMenu;
    NAddGather: TMenuItem;
    NModifyGather: TMenuItem;
    NDelGather: TMenuItem;
    PopupMenu5: TPopupMenu;
    NDelSelContent: TMenuItem;
    ImageList1: TImageList;
    procedure ButtonClose3Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButtonSearchClick(Sender: TObject);
    procedure TreeViewCompanyChange(Sender: TObject; Node: TTreeNode);
    procedure ButtonLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonSave1Click(Sender: TObject);
    procedure CheckListBoxContentClickCheck(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure EditContentFilterKeyPress(Sender: TObject; var Key: Char);
    procedure NAddCompanyClick(Sender: TObject);
    procedure NModifyCompanyClick(Sender: TObject);
    procedure NDelCompanyClick(Sender: TObject);
    procedure NAddGatherClick(Sender: TObject);
    procedure NModifyGatherClick(Sender: TObject);
    procedure NDelGatherClick(Sender: TObject);
    procedure NAddModelClick(Sender: TObject);
    procedure NModifyModelClick(Sender: TObject);
    procedure NDelModelClick(Sender: TObject);
    procedure ButtonSave2Click(Sender: TObject);
    procedure ListViewContentModelClick(Sender: TObject);
    procedure ButtonSave3Click(Sender: TObject);
    procedure NDelSelContentClick(Sender: TObject);
    procedure ListViewContentModelSetClick(Sender: TObject);
    procedure TreeViewCompanySetMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CheckListBoxContentClick(Sender: TObject);
  private
    gActedPage: TActedPage;
    gIsSys: boolean;

    gCurrModelid: integer;  //预览页面的当前告警内容模板编号
    gCheckDataSet: TClientDataSet;
    gCheckAlarmParamList: THashedStringList;
    gSelectedContenList: THashedStringList;
    gAlarmParamInputList: THashedStringList;
    gFiltedContentDataSet: TClientDataSet;
    gFiltedValue: string;

    //找出原先有，保存后无的配置
    //取界面
    procedure GetAlarmParam(aFlag: integer);
    //取数据库
    procedure CheckAlarmParam(aFlag: integer);
    function IsEffectedAlarm: boolean;
    function GetEffectedCondition(aFlag: integer; var aCompanyidStr, aGatheridStr, aContentStr: string): boolean;
    procedure IniParams;
    procedure LoadPreview;
    procedure LoadContentModelView;
    procedure LoadContentSetView;
    //加载所有的告警内容
    procedure LoadAllContentDataSet(aCityid: integer; aDataSet: TClientDataSet);
    procedure SetFilted(aDataSet: TClientDataSet; aFilterValue: string);
    procedure OnMyFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    //加载已有的告警内容模板
    procedure LoadContentModel(aCityid: integer; aListView: TListView);overload;
    procedure LoadContentModel(aCityid: integer; aList: TStrings);overload;

    //初始化维护单位树
    procedure LoadCompanyTree(aCtiyid, aParentid: integer; aTopNode: TTreeNode; aTreeView: TTreeView);
    //aCompanyid=-1 为初始化 不勾选任何项
    procedure LoadDeviceGather(aCityid, aCompanyid: integer; aCheckListBox: TCheckListBox);overload;
    //根据维护单位显示告警内容明细
    procedure LoadContentModelDetailView(aCtiyid, aCompanyid: integer; aListView: TListView);overload;
    //根据维护单位显示告警内容模板
    procedure LoadContentModelItem(aNode: TTreeNode);
    //根据过滤的告警内容数据集和右边告警内容明细显示告警内容选择
    procedure LoadContentFilter(aDataSet: TClientDataSet; aCheckListBox: TCheckListBox);overload;

    //根据模板编号显示告警内容明细和gSelectedContenList，勾选选择告警内容
    procedure LoadContentModelDetail(aListView: TListView; aCtiyid, aModelID: integer; aEffectHash: boolean);overload;
    //根据模板编号显示维护单位
    procedure LoadCompanyByModel(aCtiyid, aModelID: integer);
    //根据gSelectedContenList勾选告警内容
    procedure SetCheckedContent(aTHashedStringList: THashedStringList; aCheckListBox: TCheckListBox);


    procedure ClearListView(aListView: TListView);
    procedure ClearTreeView(aTreeView: TTreeView);
    procedure ClickCheck(aIndex: integer; aChecked, aLastFlag: boolean);
    function AddListViewItem(aListView: TListView; aItemValue: string; aPointer: Pointer): TListItem;
    procedure InhertedFromParent(aCityid, aParentid, aChildid: integer);
    procedure SetTreeViewImage(aTreeView: TTreeView; aIndex: integer);
  public
    { Public declarations }
  end;

var
  FormCompanySet: TFormCompanySet;

implementation

uses UnitDllCommon, UnitCompanyInfo, UnitDeviceGatherInfo,
  UnitContentModelInfo;

{$R *.dfm}

procedure TFormCompanySet.ButtonClose3Click(Sender: TObject);
begin
  close;
end;

procedure TFormCompanySet.IniParams;
begin
  gActedPage:= [];
  gCurrModelid:= 0;
  gSelectedContenList:= THashedStringList.Create;
  gCheckAlarmParamList:= THashedStringList.Create;
  gAlarmParamInputList:= THashedStringList.Create;
  gFiltedContentDataSet:= TClientDataSet.Create(nil);
  gCheckDataSet:= TClientDataSet.Create(nil);
  
  gIsSys:= true;
  try
    PageControl1.ActivePage:= TabSheetPreview;

  finally
    gIsSys:= false;
  end;
  PageControl1Change(self);
end;

procedure TFormCompanySet.PageControl1Change(Sender: TObject);
begin
  if self.gIsSys then exit;//系统操作，就不需要触发
  if (PageControl1.ActivePage= TabSheetPreview) and not (wd_Acted_Preview in gActedPage) then
  begin
    gActedPage:= gActedPage+ [wd_Acted_Preview];
    LoadPreview;
  end
  else
  if (PageControl1.ActivePage= TabSheetContentModel) and not (wd_Acted_ContentModel in gActedPage) then
  begin
    gActedPage:= gActedPage+ [wd_Acted_ContentModel];
    LoadContentModelView;
  end
  else
  if (PageControl1.ActivePage= TabSheetContentSet) and not (wd_Acted_ContentSet in gActedPage) then
  begin
    gActedPage:= gActedPage+ [wd_Acted_ContentSet];
    LoadContentSetView;
  end;
end;

procedure TFormCompanySet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  gSelectedContenList.Clear;
  gSelectedContenList.Free;
  gCheckAlarmParamList.Clear;
  gCheckAlarmParamList.Free;
  gAlarmParamInputList.Clear;
  gAlarmParamInputList.Free;
  gFiltedContentDataSet.Close;
  gFiltedContentDataSet.Free;
  gCheckDataSet.Close;
  gCheckDataSet.Free;

  ClearListView(ListViewContentDetail);
  ClearListView(ListViewContentModelDetail);
  ClearListView(ListViewContentDetailSet);
  ClearListView(ListViewContentModel);
  ClearListView(ListViewContentModelSet);

  ClearTreeView(TreeViewCompany);
  ClearTreeView(TreeViewCompanySet);
  //关闭
  gDllMsgCall(FormCompanySet,1,'','');
end;

procedure TFormCompanySet.LoadCompanyTree(aCtiyid, aParentid: integer;
  aTopNode: TTreeNode; aTreeView: TTreeView);
var
  lClientDataSet: TClientDataSet;
  lNode: TTreeNode;
  lCompanyNodeParam: TCompanyNodeParam;
  lSqlstr: string;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lSqlstr:= 'select t.cityid,t.companyid,t.companyname,t.parentid,nvl(t1.modelid,0) modelid,'+
                ' address, phone, fix, linkman'+
                ' from fms_company_info t'+
                ' left join alarm_content_modelcompany t1 on t.cityid=t1.cityid and t.companyid=t1.companyid'+
                ' where t.cityid='+inttostr(aCtiyid)+' and t.parentid='+inttostr(aParentid)+
                ' order by t.cityid,t.parentid,t.companyid';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
      first;
      while not eof do
      begin
        lCompanyNodeParam:= TCompanyNodeParam.Create;
        lCompanyNodeParam.Cityid:= FieldByName('cityid').AsInteger;
        lCompanyNodeParam.Companyid:= FieldByName('companyid').AsInteger;
        lCompanyNodeParam.CompanyName:= FieldByName('companyname').AsString;
        lCompanyNodeParam.DisPlayName:= lCompanyNodeParam.CompanyName;
        lCompanyNodeParam.ParentID:= FieldByName('parentid').AsInteger;
        lCompanyNodeParam.Modelid:= FieldByName('modelid').AsInteger;

        lCompanyNodeParam.Address:= FieldByName('Address').AsString;
        lCompanyNodeParam.Phone:= FieldByName('Phone').AsString;
        lCompanyNodeParam.Fix:= FieldByName('Fix').AsString;
        lCompanyNodeParam.Linkman:= FieldByName('Linkman').AsString;

        lNode:= aTreeView.Items.AddChildObject(aTopNode, lCompanyNodeParam.DisPlayName, lCompanyNodeParam);
        lNode.ImageIndex:= lNode.Level;
        lNode.SelectedIndex:= lNode.ImageIndex;

        LoadCompanyTree(lCompanyNodeParam.Cityid,lCompanyNodeParam.Companyid,lNode,aTreeView);
        lCompanyNodeParam.IsLeaf:= not lNode.HasChildren;
        lNode.Expand(false);

        next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanySet.LoadContentModel(aCityid: integer;
  aList: TStrings);
var
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
  lSqlstr: string;
begin
  ClearTStrings(aList);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lSqlstr:= 'select t.modelid,t.modelname'+
                ' from alarm_content_model t'+
                ' where t.cityid='+inttostr(aCityid);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
      first;
      while not eof do
      begin
        lWdInteger:= TWdInteger.Create(FieldByName('modelid').AsInteger);
        aList.AddObject(FieldByName('modelname').AsString,lWdInteger);
        next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanySet.LoadContentModel(aCityid: integer;
  aListView: TListView);
var
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
  lSqlstr: string;
  lDestListItem: TListItem;
begin
  ClearListView(aListView);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lSqlstr:= 'select t.modelid,t.modelname'+
                ' from alarm_content_model t'+
                ' where t.cityid='+inttostr(aCityid);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
      first;
      while not eof do
      begin
        lWdInteger:= TWdInteger.Create(FieldByName('modelid').AsInteger);

        lDestListItem:= aListView.Items.Add;
        lDestListItem.Data:= lWdInteger;
        lDestListItem.Caption:= format('%.4d',[aListView.Items.Count]);
        lDestListItem.SubItems.Add(FieldByName('modelname').AsString);
        next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanySet.LoadContentModelView;
begin
  LoadContentModel(gPublicParam.cityid,ListViewContentModel);

  LoadAllContentDataSet(gPublicParam.cityid,gFiltedContentDataSet);
  SetFilted(gFiltedContentDataSet, '');
  LoadContentFilter(gFiltedContentDataSet, CheckListBoxContent);
end;

procedure TFormCompanySet.LoadContentSetView;
begin
  LoadContentModel(gPublicParam.cityid,ListViewContentModelSet);

  ClearTreeView(TreeViewCompanySet);
  LoadCompanyTree(gPublicParam.cityid, -1, nil, TreeViewCompanySet);
  SetTreeViewImage(TreeViewCompanySet,3);
end;

procedure TFormCompanySet.LoadPreview;
begin
  ClearTreeView(TreeViewCompany);
  LoadCompanyTree(gPublicParam.cityid, -1, nil, TreeViewCompany);
  LoadDeviceGather(gPublicParam.cityid, -1, CheckListBoxDeviceGather);
  LoadContentModel(gPublicParam.cityid,ComboBoxContentModel.Items);
end;

procedure TFormCompanySet.LoadDeviceGather(aCityid, aCompanyid: integer;
  aCheckListBox: TCheckListBox);
var
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
  lSqlstr: string;
  lCompanyidStr: string;
  lIndex: integer;
begin
  ClearTStrings(aCheckListBox.Items);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      if aCompanyid= -1 then
        lSqlstr:= 'select a.cityid,a.devicegatherid,a.devicegathername,'+
                  '  decode(b.cityid,null,0,1) as Checked'+
                  '  from fms_devicegather_info a'+
                  '  left join (select cityid,devicegatherid'+
                  '            from fms_company_devgather_relat'+
                  '            where companyid in (-1)'+
                  '            group by cityid,devicegatherid) b'+
                  '  on a.cityid=b.cityid and a.devicegatherid=b.devicegatherid'+
                  '  where a.cityid='+inttostr(aCityid)+
                  ' order by a.cityid,a.devicegatherid'
      else
      begin
        lCompanyidStr:= GetCompanyChildLeaf(aCityid,aCompanyid);
        lSqlstr:= 'select a.cityid,a.devicegatherid,a.devicegathername,'+
                  '  decode(b.cityid,null,0,1) as Checked'+
                  '  from fms_devicegather_info a'+
                  '  left join (select cityid,devicegatherid'+
                  '            from fms_company_devgather_relat'+
                  '            where companyid in ('+lCompanyidStr+')'+
                  '            group by cityid,devicegatherid) b'+
                  '  on a.cityid=b.cityid and a.devicegatherid=b.devicegatherid'+
                  '  where a.cityid='+inttostr(aCityid)+
                  ' order by a.cityid,a.devicegatherid';
      end;
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
      first;
      while not eof do
      begin
        lWdInteger:= TWdInteger.Create(FieldByName('devicegatherid').AsInteger);
        lIndex:= aCheckListBox.Items.AddObject(FieldByName('devicegathername').AsString,lWdInteger);
        if FieldByName('Checked').AsInteger= 1 then
          aCheckListBox.Checked[lIndex]:= true;
        next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanySet.LoadContentFilter(aDataSet: TClientDataSet;
  aCheckListBox: TCheckListBox);
var
  lWdInteger: TWdInteger;
begin
  ClearTStrings(aCheckListBox.Items);
  if (aDataSet=nil) or (not aDataSet.Active) or (aDataSet.RecordCount=0) then exit;
  with aDataSet do
  begin
    first;
    while not eof do
    begin
      lWdInteger:= TWdInteger.Create(FieldByName('alarmcontentcode').AsInteger);
      aCheckListBox.Items.AddObject(FieldByName('alarmcontentname').AsString+'['+lWdInteger.ToString+']',lWdInteger);
      next;
    end;
  end;
  //根据gSelectedContenList勾选内容
  SetCheckedContent(gSelectedContenList,aCheckListBox);
end;

procedure TFormCompanySet.LoadContentModelDetail(aListView: TListView;
  aCtiyid, aModelID: integer; aEffectHash: boolean);
var
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
  lSqlstr: string;
begin
  ClearListView(aListView);
  //勾选 哈希列表在此初始化
  if aEffectHash then
    gSelectedContenList.Clear;
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lSqlstr:= 'select a.alarmcontentcode,a.alarmcontentname'+
                ' from alarm_content_info a'+
                ' inner join alarm_content_model_relate b'+
                ' on a.cityid=b.cityid and a.alarmcontentcode=b.alarmcontentcode'+
                ' and b.cityid='+inttostr(aCtiyid)+' and b.modelid='+inttostr(aModelID)+
                ' order by a.alarmcontentcode';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
      first;
      while not eof do
      begin
        lWdInteger:= TWdInteger.Create(FieldByName('alarmcontentcode').AsInteger);
        AddListViewItem(aListView,FieldByName('alarmcontentname').AsString+'['+lWdInteger.ToString+']',lWdInteger);
        if aEffectHash and (gSelectedContenList.IndexOf(lWdInteger.ToString)= -1) then
          gSelectedContenList.Add(lWdInteger.ToString);
        next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanySet.LoadAllContentDataSet(aCityid: integer;
  aDataSet: TClientDataSet);
var
  lSqlstr: string;
begin
  with aDataSet do
  begin
    Close;
    lSqlstr:= 'select t.alarmcontentcode,t.alarmcontentname from alarm_content_info t'+
              '  where t.cityid='+inttostr(aCityid)+
              '  order by t.alarmcontentcode';
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
  end;
  aDataSet.OnFilterRecord:= OnMyFilterRecord;
end;

procedure TFormCompanySet.SetFilted(aDataSet: TClientDataSet;
  aFilterValue: string);
begin
  gFiltedValue:= aFilterValue;
  aDataSet.Filtered:= false;
  if trim(aFilterValue)<> '' then
    aDataSet.Filtered:= true;
end;

procedure TFormCompanySet.OnMyFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept:= (pos(trim(uppercase(gFiltedValue)),trim(uppercase(DataSet.FieldByName(gFiltedFieldName1).AsString)))>0)
            or (pos(trim(uppercase(gFiltedValue)),trim(uppercase(DataSet.FieldByName(gFiltedFieldName2).AsString)))>0)
end;

procedure TFormCompanySet.SpeedButtonSearchClick(Sender: TObject);
begin
  SetFilted(gFiltedContentDataSet, EditContentFilter.Text);
  LoadContentFilter(gFiltedContentDataSet, CheckListBoxContent);
end;

procedure TFormCompanySet.LoadContentModelDetailView(aCtiyid,
  aCompanyid: integer; aListView: TListView);
var
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
  lSqlstr: string;
begin
  ClearListView(aListView);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lSqlstr:= 'select a.alarmcontentcode,a.alarmcontentname'+
                ' from alarm_content_info a'+
                ' inner join fms_company_alarm_relat b'+
                ' on a.cityid=b.cityid and a.alarmcontentcode=b.alarmcontentcode'+
                ' and b.cityid='+inttostr(aCtiyid)+' and b.companyid='+inttostr(aCompanyid);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
      first;
      while not eof do
      begin
        lWdInteger:= TWdInteger.Create(FieldByName('alarmcontentcode').AsInteger);
        AddListViewItem(aListView,FieldByName('alarmcontentname').AsString+'['+lWdInteger.ToString+']',lWdInteger);
        next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanySet.LoadContentModelItem(aNode: TTreeNode);
var
  i: integer;
begin
  ComboBoxContentModel.ItemIndex:= -1;
  if (aNode<>nil) and (aNode.Data<>nil)
     and (TCompanyNodeParam(aNode.Data).IsLeaf) then
  begin
    for i:= 0 to ComboBoxContentModel.Items.Count -1 do
    begin
      if TCompanyNodeParam(aNode.Data).Modelid=
        TWdInteger(ComboBoxContentModel.Items.Objects[i]).Value then
        ComboBoxContentModel.ItemIndex:= i;
    end;
  end;
end;

procedure TFormCompanySet.TreeViewCompanyChange(Sender: TObject;
  Node: TTreeNode);
var
  lCompanyNodeParam: TCompanyNodeParam;
begin
  if Node.Data=nil then exit;

  Screen.Cursor:=crHourGlass;
  try
    lCompanyNodeParam:= TCompanyNodeParam(Node.Data);
    //如果不是叶子，以下按钮不可用
    if lCompanyNodeParam.IsLeaf then
    begin
      ButtonLoad.Enabled:= true;
      ButtonSave1.Enabled:= true;
    end
    else
    begin
      ButtonLoad.Enabled:= false;
      ButtonSave1.Enabled:= false;
    end;
    LoadDeviceGather(lCompanyNodeParam.Cityid,lCompanyNodeParam.Companyid,CheckListBoxDeviceGather);
    LoadContentModelDetailView(lCompanyNodeParam.Cityid,lCompanyNodeParam.Companyid,ListViewContentDetail);
    LoadContentModelItem(Node);
    gCurrModelid:= lCompanyNodeParam.Modelid;
  finally
    screen.Cursor:= crDefault;
  end;
end;

procedure TFormCompanySet.ButtonLoadClick(Sender: TObject);
begin
  if ComboBoxContentModel.ItemIndex= -1 then exit;
  LoadContentModelDetail(ListViewContentDetail,gPublicParam.cityid,
                        TWdInteger(ComboBoxContentModel.Items.Objects[ComboBoxContentModel.ItemIndex]).Value, false);
  gCurrModelid:= TWdInteger(ComboBoxContentModel.Items.Objects[ComboBoxContentModel.ItemIndex]).Value;
end;

procedure TFormCompanySet.FormCreate(Sender: TObject);
begin
  IniParams;

  CheckListBoxContent.ShowHint:= True;
  CheckListBoxContent.Hint:= '';
end;

procedure TFormCompanySet.ButtonSave1Click(Sender: TObject);
var
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  iError: integer;
  lCompanyid: integer;
  i: integer;
  lIndex: integer;
  lSelectGather: boolean;
  lEffect_CompanyidStr,
  lEffect_GatheridStr, lEffect_ContentStr: string;
  lEffectedAlarm: boolean;
  lAlarmParamInput: TAlarmParamInput;
  function GetVariantLength: integer;
  var
    ii: integer;
  begin
    result:= 0;
    for ii:= 0 to CheckListBoxDeviceGather.Count -1 do
    begin
      if CheckListBoxDeviceGather.Checked[ii] then
        inc(result);
    end;
    result:= result+ 5;
  end;
begin
  if TreeViewCompany.Selected=nil then
  begin
    application.MessageBox('请选择要修改的维护单位(本功能只提供修改叶子维护单位)','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  lSelectGather:= false;
  for i:= 0 to CheckListBoxDeviceGather.Items.Count -1 do
  begin
    if CheckListBoxDeviceGather.Checked[i] then
    begin
      lSelectGather:= true;
      break;
    end;
  end;
  if not lSelectGather then
  begin
    application.MessageBox('请选择设备集','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if self.gCurrModelid=0 then
  begin
    application.MessageBox('请选择告警内容模板','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  //判断取消的告警内容是否有告警 判断是否删除告警 更改主从关系
  GetAlarmParam(1);
  CheckAlarmParam(1);
  lEffectedAlarm:= false;
  if IsEffectedAlarm then
  begin
    lEffectedAlarm:= true;
    if Application.MessageBox(PChar('该操作会影响在线告警，是否继续？'),
                            '系统提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;
  end;

  Screen.Cursor:=crHourGlass;
  lsuccess:= false;
  iError:= 0;
  try
    //删除告警信息和调整主从关系
    if lEffectedAlarm and GetEffectedCondition(1,lEffect_CompanyidStr,lEffect_GatheridStr,lEffect_ContentStr) then
    begin
      for i:= 0 to gAlarmParamInputList.Count -1 do
      begin
        lAlarmParamInput:= TAlarmParamInput(gAlarmParamInputList.Objects[i]);
        iError:= gTempInterface.CompanyMgr(gPublicParam.cityid,lAlarmParamInput.Companyid,lAlarmParamInput.GatherStr,lAlarmParamInput.ContentStr,gPublicParam.userid,null);
        if iError<>0 then break;
      end;
    end;

    if iError= 0 then
    begin
      lVariant:= VarArrayCreate([0,GetVariantLength-1],varVariant);
      lCompanyid:= TCompanyNodeParam(TreeViewCompany.Selected.Data).Companyid;

      //lIndex:= 0;
      lSqlstr:= 'delete from fms_company_devgather_relat a'+
                ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.companyid='+inttostr(lCompanyid);
      lVariant[0]:= VarArrayOf([lsqlstr]);
      lSqlstr:= 'delete from fms_company_alarm_relat a'+
                ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.companyid='+inttostr(lCompanyid);
      lVariant[1]:= VarArrayOf([lsqlstr]);
      lSqlstr:= 'delete from alarm_content_modelcompany a'+
                ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.companyid='+inttostr(lCompanyid);
      lVariant[2]:= VarArrayOf([lsqlstr]);
      lIndex:= 3;
      //保存 设备集信息
      for i:= 0 to CheckListBoxDeviceGather.Items.Count -1 do
      begin
        if CheckListBoxDeviceGather.Checked[i] then
        begin
          lSqlstr:= 'insert into fms_company_devgather_relat'+
                    ' (cityid, companyid, devicegatherid) values'+
                    ' ('+inttostr(gPublicParam.cityid)+', '+inttostr(lCompanyid)+', '+
                    TWdInteger(CheckListBoxDeviceGather.Items.Objects[i]).ToString+')';
          lVariant[lIndex]:= VarArrayOf([lsqlstr]);
          inc(lIndex);
        end;
      end;
      //保存 模板维护单位信息
      lsqlstr:= 'insert into alarm_content_modelcompany'+
                ' (cityid, modelid, companyid) values'+
                ' ('+inttostr(gPublicParam.cityid)+', '+
                inttostr(gCurrModelid)+', '+
                inttostr(lCompanyid)+')';
      lVariant[lIndex]:= VarArrayOf([lsqlstr]);
      //保存 告警内容信息
      inc(lIndex);
      lsqlstr:= 'insert into fms_company_alarm_relat'+
                 ' (cityid, companyid, alarmcontentcode)'+
                 ' select a.cityid,a.companyid,b.alarmcontentcode'+
                 ' from alarm_content_modelcompany a'+
                 ' inner join alarm_content_model_relate b'+
                 ' on a.cityid=b.cityid and a.modelid=b.modelid'+
                 ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.companyid='+inttostr(lCompanyid);
      lVariant[lIndex]:= VarArrayOf([lsqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    end;
    if lsuccess then
    begin
      application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
      if TCompanyNodeParam(TreeViewCompany.Selected.Data).Modelid<>gCurrModelid then
        TCompanyNodeParam(TreeViewCompany.Selected.Data).Modelid:= gCurrModelid;
    end
    else
      application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
  finally
    screen.Cursor:= crDefault;
  end;
end;

procedure TFormCompanySet.ClearListView(aListView: TListView);
var
  i: integer;
begin
  for i:= aListView.Items.Count -1 downto 0 do
  begin
    dispose(aListView.Items[i].Data);
    aListView.Items[i].Delete;
  end;
  aListView.Items.Clear;
end;

procedure TFormCompanySet.ClearTreeView(aTreeView: TTreeView);
var
  i: integer;
begin
  for i:= aTreeView.Items.Count -1 downto 0 do
  begin
    dispose(aTreeView.Items[i].Data);
    aTreeView.Items[i].Delete;
  end;
  aTreeView.Items.Clear;
end;

procedure TFormCompanySet.SetCheckedContent(
  aTHashedStringList: THashedStringList; aCheckListBox: TCheckListBox);
var
  i: integer;
begin
  for i:= 0 to aCheckListBox.Items.Count - 1 do
  begin
    if aTHashedStringList.IndexOf(TWdInteger(aCheckListBox.Items.Objects[i]).ToString)>-1 then
      if not aCheckListBox.Checked[i] then
        aCheckListBox.Checked[i]:= true;
  end;
end;

procedure TFormCompanySet.CheckListBoxContentClickCheck(Sender: TObject);
begin
  ClickCheck((Sender as TCheckListBox).ItemIndex,(Sender as TCheckListBox).Checked[(Sender as TCheckListBox).ItemIndex],true);
end;

procedure TFormCompanySet.ClickCheck(aIndex: integer; aChecked,
  aLastFlag: boolean);
var
  lContentCode: integer;
  lWdInteger: TWdInteger;
  lHashIndex: integer;
  I: integer;
begin
  if aChecked then
  begin
    lContentCode:= TWdInteger(CheckListBoxContent.Items.Objects[aIndex]).Value;
    if gSelectedContenList.IndexOf(inttostr(lContentCode))<0 then
    begin
      gSelectedContenList.Add(inttostr(lContentCode));
      lWdInteger:= TWdInteger.create(lContentCode);
      AddListViewItem(ListViewContentModelDetail, CheckListBoxContent.Items[aIndex], lWdInteger);
    end;
  end
  else
  begin
    lContentCode:= TWdInteger(CheckListBoxContent.Items.Objects[aIndex]).Value;
    lHashIndex:= gSelectedContenList.IndexOf(inttostr(lContentCode));
    if lHashIndex >-1 then
    begin
      Dispose(ListViewContentModelDetail.Items[lHashIndex].Data);
      ListViewContentModelDetail.Items[lHashIndex].Delete;
      gSelectedContenList.Delete(lHashIndex);
    end;

    if aLastFlag then
    begin
      ListViewContentModelDetail.Items.BeginUpdate;
      for i:=  0 to ListViewContentModelDetail.Items.Count -1 do
        ListViewContentModelDetail.Items[i].Caption := format('%.4d',[i+1]);
      ListViewContentModelDetail.Items.EndUpdate;
    end;
  end;
end;


function TFormCompanySet.AddListViewItem(aListView: TListView; aItemValue: string;
  aPointer: Pointer): TListItem;
var
  lDestListItem: TListItem;
begin
  lDestListItem:= aListView.Items.Add;
  lDestListItem.Data :=aPointer;
  lDestListItem.Caption := format('%.4d',[aListView.Items.Count]);
  lDestListItem.SubItems.Add(aItemValue);
  result:= lDestListItem;
end;

procedure TFormCompanySet.N4Click(Sender: TObject);
var
  i: Integer;
begin
  for i:= CheckListBoxContent.Count-1 downto 0 do
  begin
    CheckListBoxContent.Checked[i]:=True;
    if not CheckListBoxContent.Checked[i] then
      ClickCheck(i,CheckListBoxContent.Checked[i],false);
  end;
  for i:= CheckListBoxContent.Count-1 downto 0 do
  begin
    if CheckListBoxContent.Checked[i] then
      ClickCheck(i,CheckListBoxContent.Checked[i],i=0);
  end;
end;

procedure TFormCompanySet.N5Click(Sender: TObject);
var
  i: Integer;
begin
  for i:=CheckListBoxContent.Count-1 downto 0 do
  begin
    CheckListBoxContent.Checked[i]:= not CheckListBoxContent.Checked[i];
    if not CheckListBoxContent.Checked[i] then
      ClickCheck(i,CheckListBoxContent.Checked[i],false);
  end;
  for i:=CheckListBoxContent.Count-1 downto 0 do
  begin
    if CheckListBoxContent.Checked[i] then
      ClickCheck(i,CheckListBoxContent.Checked[i],i=0);
  end;
end;

procedure TFormCompanySet.EditContentFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    SpeedButtonSearchClick(self)
end;

procedure TFormCompanySet.NAddCompanyClick(Sender: TObject);
var
  lFormCompanyInfo: TFormCompanyInfo;
  lNodeCurr, lNodeChild: TTreeNode;
  lCompanyNodeParam, lCompanyNodeParamChild: TCompanyNodeParam;
  lCompanyid: integer;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lNodeCurr:= TreeViewCompany.Selected;
  if (lNodeCurr=nil) or (lNodeCurr.Data=nil) then
  begin
    application.MessageBox('获取维护单位树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  lFormCompanyInfo:= TFormCompanyInfo.Create(nil);
  try
    repeat
      lFormCompanyInfo.ShowModal;
      if lFormCompanyInfo.ModalResult <> mrOk then
        break;
    until (lFormCompanyInfo.ModalResult = mrOk)
          and (not IsExists('fms_company_info','companyname',lFormCompanyInfo.cxTextEditName.Text))
          and (trim(lFormCompanyInfo.cxTextEditName.Text)<>'');
    if lFormCompanyInfo.ModalResult = mrOk then
    begin
      lCompanyNodeParam:= TCompanyNodeParam(lNodeCurr.Data);
      lCompanyID:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'insert into fms_company_info'+
                ' (cityid, companyid, parentid, companyname, address, phone, fix, linkman) values'+
                ' ('+inttostr(lCompanyNodeParam.Cityid)+', '+inttostr(lCompanyID)+', '+
                inttostr(lCompanyNodeParam.Companyid)+', '''+lFormCompanyInfo.cxTextEditName.Text+''', '''+
                lFormCompanyInfo.cxTextEditAddr.Text+''', '''+lFormCompanyInfo.cxTextEditPhone.Text+''', '''+
                lFormCompanyInfo.cxTextEditFax.Text+''', '''+lFormCompanyInfo.cxTextEditLinkMan.Text+''')';
      lVariant[0]:= VarArrayOf([lsqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

      //是叶子节点，新增节点从该节点继承维护单位信息
      if lCompanyNodeParam.IsLeaf then
      begin
        lCompanyNodeParam.IsLeaf:= false;
        InhertedFromParent(lCompanyNodeParam.Cityid,lCompanyNodeParam.Companyid,lCompanyID);
      end;

      if lsuccess then
      begin
        application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
        //分配页面
        gActedPage:= gActedPage - [wd_Acted_ContentSet];
        lCompanyNodeParamChild:= TCompanyNodeParam.Create;
        lCompanyNodeParamChild.Cityid:= lCompanyNodeParam.Cityid;
        lCompanyNodeParamChild.Companyid:= lCompanyID;
        lCompanyNodeParamChild.CompanyName:= lFormCompanyInfo.cxTextEditName.Text;
        lCompanyNodeParamChild.DisPlayName:= lFormCompanyInfo.cxTextEditName.Text;
        lCompanyNodeParamChild.ParentID:= lCompanyNodeParam.Companyid;
        lCompanyNodeParamChild.IsLeaf:= true;
        lCompanyNodeParamChild.Modelid:= lCompanyNodeParam.Modelid;

        lCompanyNodeParamChild.Address:= lFormCompanyInfo.cxTextEditAddr.Text;
        lCompanyNodeParamChild.Phone:= lFormCompanyInfo.cxTextEditPhone.Text;
        lCompanyNodeParamChild.Fix:= lFormCompanyInfo.cxTextEditFax.Text;
        lCompanyNodeParamChild.Linkman:= lFormCompanyInfo.cxTextEditLinkMan.Text;

        lNodeChild:= TreeViewCompany.Items.AddChildObject(lNodeCurr,lCompanyNodeParamChild.DisPlayName,lCompanyNodeParamChild);
        TreeViewCompany.Selected:= lNodeChild;
      end
      else
        application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
    end;
  finally
    lFormCompanyInfo.Free;
  end;
end;

procedure TFormCompanySet.InhertedFromParent(aCityid, aParentid, aChildid: integer);
var
  lVariant: variant;
  lSqlstr: string;
begin
  lVariant:= VarArrayCreate([0,2],varVariant);
  lSqlstr := 'update fms_company_devgather_relat set companyid='+inttostr(aChildid)+' where companyid='+
             inttostr(aParentid)+' and cityid='+inttostr(aCityid);
  lVariant[0]:= VarArrayOf([lsqlstr]);
  lSqlstr := 'update FMS_COMPANY_ALARM_RELAT set companyid='+inttostr(aChildid)+' where companyid='+
             inttostr(aParentid)+' and cityid='+inttostr(aCityid);
  lVariant[1]:= VarArrayOf([lsqlstr]);
  lSqlstr := 'update alarm_content_modelcompany set companyid='+inttostr(aChildid)+' where companyid='+
             inttostr(aParentid)+' and cityid='+inttostr(aCityid);
  lVariant[2]:= VarArrayOf([lsqlstr]);
  gTempInterface.ExecBatchSQL(lVariant);
end;

procedure TFormCompanySet.NModifyCompanyClick(Sender: TObject);
var
  lFormCompanyInfo: TFormCompanyInfo;
  lNodeCurr: TTreeNode;
  lCompanyNodeParam: TCompanyNodeParam;
  lCompanyid: integer;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lNodeCurr:= TreeViewCompany.Selected;
  if (lNodeCurr=nil) or (lNodeCurr.Data=nil) then
  begin
    application.MessageBox('获取维护单位树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  lFormCompanyInfo:= TFormCompanyInfo.Create(nil);
  try
    lCompanyNodeParam:= TCompanyNodeParam(lNodeCurr.Data);
    lFormCompanyInfo.cxTextEditName.Text:= lCompanyNodeParam.CompanyName;
    lFormCompanyInfo.cxTextEditAddr.Text:= lCompanyNodeParam.Address;
    lFormCompanyInfo.cxTextEditPhone.Text:= lCompanyNodeParam.Phone;
    lFormCompanyInfo.cxTextEditFax.Text:= lCompanyNodeParam.Fix;
    lFormCompanyInfo.cxTextEditLinkMan.Text:= lCompanyNodeParam.Linkman;
    lCompanyid:= lCompanyNodeParam.Companyid;
    repeat
      lFormCompanyInfo.ShowModal;
      if lFormCompanyInfo.ModalResult <> mrOk then
        break;
    until (lFormCompanyInfo.ModalResult = mrOk)
          and (not IsExists('fms_company_info','companyname',lFormCompanyInfo.cxTextEditName.Text,'companyid',inttostr(lCompanyid)))
          and (trim(lFormCompanyInfo.cxTextEditName.Text)<>'');
    if lFormCompanyInfo.ModalResult = mrOk then
    begin
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fms_company_info'+
                ' set companyname = '''+lFormCompanyInfo.cxTextEditName.Text+''','+
                '     address = '''+lFormCompanyInfo.cxTextEditAddr.Text+''','+
                '     phone = '''+lFormCompanyInfo.cxTextEditPhone.Text+''','+
                '     fix = '''+lFormCompanyInfo.cxTextEditFax.Text+''','+
                '     linkman = '''+lFormCompanyInfo.cxTextEditLinkMan.Text+''''+
                ' where companyid = '+inttostr(lCompanyNodeParam.Companyid)+
                '     and cityid = '+inttostr(lCompanyNodeParam.Cityid);
      lVariant[0]:= VarArrayOf([lsqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

      if lsuccess then
      begin
        application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
        //分配页面
        gActedPage:= gActedPage - [wd_Acted_ContentSet];

        lCompanyNodeParam.CompanyName:= lFormCompanyInfo.cxTextEditName.Text;
        lCompanyNodeParam.DisPlayName:= lCompanyNodeParam.CompanyName;
        lCompanyNodeParam.Address:= lFormCompanyInfo.cxTextEditAddr.Text;
        lCompanyNodeParam.Phone:= lFormCompanyInfo.cxTextEditPhone.Text;
        lCompanyNodeParam.Fix:= lFormCompanyInfo.cxTextEditFax.Text;
        lCompanyNodeParam.Linkman:= lFormCompanyInfo.cxTextEditLinkMan.Text;
        lNodeCurr.Text:= lCompanyNodeParam.DisPlayName;
      end
      else
        application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
    end;
  finally
    lFormCompanyInfo.Free;
  end;
end;

procedure TFormCompanySet.NDelCompanyClick(Sender: TObject);
var
  lNodeCurr, lNodeParent: TTreeNode;
  lCompanyNodeParam: TCompanyNodeParam;
  lCompanyid, lCityid: integer;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  iError: integer;
  lEffect_CompanyidStr,
  lEffect_GatheridStr, lEffect_ContentStr: string;
  lEffectedAlarm: boolean;
  i: integer;
  lAlarmParamInput: TAlarmParamInput;
begin
  lNodeCurr:= TreeViewCompany.Selected;
  if (lNodeCurr=nil) or (lNodeCurr.Data=nil) then
  begin
    application.MessageBox('获取维护单位树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if not TCompanyNodeParam(lNodeCurr.Data).IsLeaf then
  begin
    application.MessageBox('只提供删除维护单位叶子节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if TCompanyNodeParam(lNodeCurr.Data).Companyid= 1 then
  begin
    application.MessageBox('初始数据，无法删除！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  lCompanyNodeParam:= TCompanyNodeParam(lNodeCurr.Data);
  lCompanyid:= lCompanyNodeParam.Companyid;
  lCityid:= lCompanyNodeParam.Cityid;

  if Application.MessageBox(PChar('确定删除维护单位【'+lCompanyNodeParam.DisPlayName+'】？'),
                            '系统提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;

  //判断取消的告警内容是否有告警 判断是否删除告警 更改主从关系
  GetAlarmParam(4);
  CheckAlarmParam(4);
  lEffectedAlarm:= false;
  if IsEffectedAlarm then
  begin
    lEffectedAlarm:= true;
    if Application.MessageBox(PChar('该操作会影响在线告警，是否继续？'),
                            '系统提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;
  end;

  Screen.Cursor:=crHourGlass;
  lsuccess:= false;
  iError:= 0;
  try
    //删除告警信息和调整主从关系
    if lEffectedAlarm and GetEffectedCondition(4,lEffect_CompanyidStr,lEffect_GatheridStr,lEffect_ContentStr) then
    begin
      for i:= 0 to gAlarmParamInputList.Count -1 do
      begin
        lAlarmParamInput:= TAlarmParamInput(gAlarmParamInputList.Objects[i]);
        iError:= gTempInterface.CompanyMgr(gPublicParam.cityid,lAlarmParamInput.Companyid,lAlarmParamInput.GatherStr,lAlarmParamInput.ContentStr,gPublicParam.userid,null);
        if iError<>0 then break;
      end;
    end;

    if iError= 0 then
    begin
      lVariant:= VarArrayCreate([0,2],varVariant);
      lSqlstr := 'delete from FMS_COMPANY_INFO where cityid=' +
                 IntToStr(lCityid) +
                 ' and companyid=' + IntToStr(lCompanyid) ;
      lVariant[0]:= VarArrayOf([lsqlstr]);

      { delete FMS_COMPANY_DEVGATHER_RELAT }
      lSqlstr := 'delete from FMS_COMPANY_DEVGATHER_RELAT where cityid=' +
                 IntToStr(lCityid) +
                 ' and companyid=' + IntToStr(lCompanyid) ;
      lVariant[1]:= VarArrayOf([lsqlstr]);

      { delete FMS_COMPANY_ALARM_RELAT }
      lSqlstr := 'delete from FMS_COMPANY_ALARM_RELAT where cityid=' +
                 IntToStr(lCityid) +
                 ' and companyid=' + IntToStr(lCompanyid) ;
      lVariant[2]:= VarArrayOf([lsqlstr]);

      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

      if lsuccess then
      begin
        application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
        //分配页面
        gActedPage:= gActedPage - [wd_Acted_ContentSet];
        lNodeParent:= lNodeCurr.Parent;
        lNodeCurr.Delete;
        if (lNodeParent<>nil) and (lNodeParent.Data<>nil) then
        begin
          TCompanyNodeParam(lNodeParent.Data).IsLeaf:= not lNodeParent.HasChildren;
          TreeViewCompany.Selected:= lNodeParent;
        end;
      end
      else
        application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
    end;
  finally
    screen.Cursor:= crDefault;
  end;
end;

procedure TFormCompanySet.NAddGatherClick(Sender: TObject);
var
  lFormDeviceGatherInfo: TFormDeviceGatherInfo;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  lGatherid: integer;
  lWdInteger: TWdInteger;
begin
  lFormDeviceGatherInfo:= TFormDeviceGatherInfo.Create(nil);
  try
    repeat
      lFormDeviceGatherInfo.ShowModal;
      if lFormDeviceGatherInfo.ModalResult <> mrOk then
        break;
    until (lFormDeviceGatherInfo.ModalResult = mrOk)
          and (not IsExists('fms_devicegather_info','devicegathername',lFormDeviceGatherInfo.cxTextEditGatherName.Text))
          and (trim(lFormDeviceGatherInfo.cxTextEditGatherName.Text)<>'');
    if lFormDeviceGatherInfo.ModalResult = mrOk then
    begin
      lGatherid:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'insert into fms_devicegather_info'+
                ' (cityid, devicegatherid, devicegathername, operater, createtime) values'+
                ' ('+inttostr(gPublicParam.Cityid)+', '+inttostr(lGatherid)+', '''+
                lFormDeviceGatherInfo.cxTextEditGatherName.Text+''', '+inttostr(gPublicParam.userid)+', sysdate)';
      lVariant[0]:= VarArrayOf([lsqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

      if lsuccess then
      begin
        application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
        lWdInteger:= TWdInteger.Create(lGatherid);
        CheckListBoxDeviceGather.ItemIndex:= CheckListBoxDeviceGather.Items.AddObject(lFormDeviceGatherInfo.cxTextEditGatherName.Text,lWdInteger);
      end
      else
        application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
    end;
  finally
    lFormDeviceGatherInfo.Free;
  end;
end;

procedure TFormCompanySet.NModifyGatherClick(Sender: TObject);
var
  lFormDeviceGatherInfo: TFormDeviceGatherInfo;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  lGatherid: integer;
begin
  if CheckListBoxDeviceGather.ItemIndex= -1 then
  begin
    application.MessageBox('获取设备集信息失败，请先选择一个设备集！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  lFormDeviceGatherInfo:= TFormDeviceGatherInfo.Create(nil);
  try
    lFormDeviceGatherInfo.cxTextEditGatherName.Text:= CheckListBoxDeviceGather.Items.Strings[CheckListBoxDeviceGather.ItemIndex];
    lGatherid:= TWdInteger(CheckListBoxDeviceGather.Items.Objects[CheckListBoxDeviceGather.ItemIndex]).Value;
    repeat
      lFormDeviceGatherInfo.ShowModal;
      if lFormDeviceGatherInfo.ModalResult <> mrOk then
        break;
    until (lFormDeviceGatherInfo.ModalResult = mrOk)
          and (not IsExists('fms_devicegather_info','devicegathername',lFormDeviceGatherInfo.cxTextEditGatherName.Text,'devicegatherid',inttostr(lGatherid)))
          and (trim(lFormDeviceGatherInfo.cxTextEditGatherName.Text)<>'');
    if lFormDeviceGatherInfo.ModalResult = mrOk then
    begin
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update fms_devicegather_info'+
                ' set devicegathername = '''+lFormDeviceGatherInfo.cxTextEditGatherName.Text+''','+
                '     operater = '+inttostr(gPublicParam.userid)+','+
                '     createtime = sysdate'+
                ' where devicegatherid = '+inttostr(lGatherid)+
                '   and cityid = '+inttostr(gPublicParam.cityid);
      lVariant[0]:= VarArrayOf([lsqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

      if lsuccess then
      begin
        application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
        CheckListBoxDeviceGather.Items.Strings[CheckListBoxDeviceGather.ItemIndex]:=
                     lFormDeviceGatherInfo.cxTextEditGatherName.Text;
      end
      else
        application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
    end;
  finally
    lFormDeviceGatherInfo.Free;
  end;
end;

procedure TFormCompanySet.NDelGatherClick(Sender: TObject);
var
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  lWdInteger: TWdInteger;
  function GatherHasDevice(aCityid, aGatherid: integer): boolean;
  var
    llClientDataSet: TClientDataSet;
    llSqlstr: string;
  begin
    llClientDataSet:= TClientDataSet.Create(nil);
    try
      with llClientDataSet do
      begin
        Close;
        llSqlstr:= 'select 1 from fms_devicegather_detail t'+
                   ' where t.cityid='+inttostr(aCityid)+' and t.devicegatherid='+inttostr(aGatherid);
        Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,llSqlstr]),0);
        if eof then
          result:= false
        else
          result:= true;
      end;
    finally
      llClientDataSet.Free;
    end;
  end;
begin
  if CheckListBoxDeviceGather.ItemIndex= -1 then
  begin
    application.MessageBox('获取设备集信息失败，请先选择一个设备集！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  lWdInteger:= TWdInteger(CheckListBoxDeviceGather.Items.Objects[CheckListBoxDeviceGather.ItemIndex]);
  if GatherHasDevice(gPublicParam.cityid,lWdInteger.Value) then
  begin
    application.MessageBox('请先将该设备集下的设备规划到其他设备集！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr := 'delete from fms_devicegather_info where cityid=' +
             IntToStr(gPublicParam.cityid) +
             ' and devicegatherid='+ IntToStr(lWdInteger.Value);
  lVariant[0]:= VarArrayOf([lsqlstr]);

  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
    CheckListBoxDeviceGather.Items.Delete(CheckListBoxDeviceGather.ItemIndex);
  end
  else
    application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TFormCompanySet.NAddModelClick(Sender: TObject);
var
  lFormContentModelInfo: TFormContentModelInfo;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  lModelid: integer;
  lWdInteger: TWdInteger;
begin
  lFormContentModelInfo:= TFormContentModelInfo.Create(nil);
  try
    repeat
      lFormContentModelInfo.ShowModal;
      if lFormContentModelInfo.ModalResult <> mrOk then
        break;
    until (lFormContentModelInfo.ModalResult = mrOk)
          and (not IsExists('alarm_content_model','modelname',lFormContentModelInfo.cxTextEditModelName.Text))
          and (trim(lFormContentModelInfo.cxTextEditModelName.Text)<>'');
    if lFormContentModelInfo.ModalResult = mrOk then
    begin
      lModelid:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'insert into alarm_content_model'+
                ' (cityid, modelid, modelname, remark, updatetime) values'+
                ' ('+inttostr(gPublicParam.Cityid)+', '+inttostr(lModelid)+', '''+
                lFormContentModelInfo.cxTextEditModelName.Text+''', null, sysdate)';
      lVariant[0]:= VarArrayOf([lsqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

      if lsuccess then
      begin
        application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
        lWdInteger:= TWdInteger.Create(lModelid);
        ListViewContentModel.Selected:=
            AddListViewItem(ListViewContentModel,lFormContentModelInfo.cxTextEditModelName.Text,lWdInteger);
        lWdInteger:= TWdInteger.Create(lModelid);
        AddListViewItem(ListViewContentModelSet,lFormContentModelInfo.cxTextEditModelName.Text,lWdInteger);
        lWdInteger:= TWdInteger.Create(lModelid);
        ComboBoxContentModel.Items.AddObject(lFormContentModelInfo.cxTextEditModelName.Text,lWdInteger);
      end
      else
        application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
    end;
  finally
    lFormContentModelInfo.Free;
  end;
end;

procedure TFormCompanySet.NModifyModelClick(Sender: TObject);
var
  lFormContentModelInfo: TFormContentModelInfo;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  lModelid: integer;
  lItem: TListItem;
begin
  lItem:= ListViewContentModel.Selected;
  if (lItem= nil) or (lItem.Data= nil) then
  begin
    application.MessageBox('获取告警内容模板信息失败，请先选择一个告警内容模板！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  lFormContentModelInfo:= TFormContentModelInfo.Create(nil);
  try
    lFormContentModelInfo.cxTextEditModelName.Text:= lItem.SubItems.Strings[0];
    lModelid:= TWdInteger(lItem.Data).Value;
    repeat
      lFormContentModelInfo.ShowModal;
      if lFormContentModelInfo.ModalResult <> mrOk then
        break;
    until (lFormContentModelInfo.ModalResult = mrOk)
          and (not IsExists('alarm_content_model','modelname',lFormContentModelInfo.cxTextEditModelName.Text,'modelid',inttostr(lModelid)))
          and (trim(lFormContentModelInfo.cxTextEditModelName.Text)<>'');
    if lFormContentModelInfo.ModalResult = mrOk then
    begin
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update alarm_content_model'+
                ' set modelname = '''+lFormContentModelInfo.cxTextEditModelName.Text+''','+
                '     updatetime = sysdate'+
                ' where cityid = '+inttostr(gPublicParam.cityid)+
                '    and modelid = '+inttostr(lModelid);
      lVariant[0]:= VarArrayOf([lsqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

      if lsuccess then
      begin
        application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
        //分配页面
        gActedPage:= gActedPage - [wd_Acted_ContentSet];
        lItem.SubItems.Strings[0]:= lFormContentModelInfo.cxTextEditModelName.Text;
      end
      else
        application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
    end;
  finally
    lFormContentModelInfo.Free;
  end;
end;

procedure TFormCompanySet.NDelModelClick(Sender: TObject);
var
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  lWdInteger: TWdInteger;
  lItem: TListItem;
  function ContentModelEffected(aCityid, aModelid: integer): boolean;
  var
    llClientDataSet: TClientDataSet;
    llSqlstr: string;
  begin
    llClientDataSet:= TClientDataSet.Create(nil);
    try
      with llClientDataSet do
      begin
        Close;
        llSqlstr:= 'select 1 from alarm_content_modelcompany t'+
                   ' where t.cityid='+inttostr(aCityid)+' and t.modelid='+inttostr(aModelid);
        Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,llSqlstr]),0);
        if eof then
          result:= false
        else
          result:= true;
      end;
    finally
      llClientDataSet.Free;
    end;
  end;
begin
  lItem:= ListViewContentModel.Selected;
  if lItem= nil then
  begin
    application.MessageBox('获取告警内容模板信息失败，请先选择一个告警内容模板！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  lWdInteger:= TWdInteger(lItem.Data);
  if ContentModelEffected(gPublicParam.cityid,lWdInteger.Value) then
  begin
    application.MessageBox('已有维护单位应用该模板，无法删除！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  lVariant:= VarArrayCreate([0,1],varVariant);
  lSqlstr := 'delete from alarm_content_model where cityid=' +
             IntToStr(gPublicParam.cityid) +
             ' and modelid='+ IntToStr(lWdInteger.Value);
  lVariant[0]:= VarArrayOf([lsqlstr]);
  lSqlstr := 'delete from alarm_content_model_relate where cityid=' +
             IntToStr(gPublicParam.cityid) +
             ' and modelid='+ IntToStr(lWdInteger.Value);
  lVariant[1]:= VarArrayOf([lsqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
    //分配页面
    gActedPage:= gActedPage - [wd_Acted_ContentSet];
    lItem.Delete;
  end
  else
    application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TFormCompanySet.ButtonSave2Click(Sender: TObject);
var
  lItem: TListItem;
  lWdInteger: TWdInteger;
  lModelid: integer;
  i: integer;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  lIndex: integer;
  lEffect_CompanyidStr,
  lEffect_GatheridStr, lEffect_ContentStr: string;
  iError: integer;
  lList: TStringList;
  lEffectedAlarm: boolean;
  lAlarmParamInput: TAlarmParamInput;
  function ContentSelected: boolean;
  begin
    if ListViewContentModelDetail.Items.Count>0 then
      result:= true
    else
      result:= false;
  end;
begin
  lItem:= ListViewContentModel.Selected;
  if (lItem= nil) or (lItem.Data= nil) then
  begin
    application.MessageBox('获取告警内容模板信息失败，请先选择一个告警内容模板！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if not ContentSelected then
  begin
    application.MessageBox('未选择告警内容，无法保存！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  //判断取消的告警内容是否有告警 判断是否删除告警 更改主从关系
  GetAlarmParam(2);
  CheckAlarmParam(2);
  lEffectedAlarm:= false;
  if IsEffectedAlarm then
  begin
    lEffectedAlarm:= true;
    if Application.MessageBox(PChar('该操作会影响在线告警，是否继续？'),
                            '系统提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;
  end;

  Screen.Cursor:=crHourGlass;
  lsuccess:= false;
  iError:= 0;
  lList:= TStringList.Create;
  try
    //删除告警信息和调整主从关系
    if lEffectedAlarm and GetEffectedCondition(2,lEffect_CompanyidStr,lEffect_GatheridStr,lEffect_ContentStr) then
    begin
      for i:= 0 to gAlarmParamInputList.Count -1 do
      begin
        lAlarmParamInput:= TAlarmParamInput(gAlarmParamInputList.Objects[i]);
        iError:= gTempInterface.CompanyMgr(gPublicParam.cityid,lAlarmParamInput.Companyid,'',lAlarmParamInput.ContentStr,gPublicParam.userid,null);
        if iError<>0 then break;
      end;
    end;

    if iError= 0 then
    begin
      lModelid:= TWdInteger(lItem.Data).Value;
      lVariant:= VarArrayCreate([0,ListViewContentModelDetail.Items.Count+2],varVariant);
      //lIndex:= 0;
      lSqlstr:= 'delete from alarm_content_model_relate'+
                ' where cityid='+inttostr(gPublicParam.cityid)+' and modelid='+inttostr(lModelid);
      lVariant[0]:= VarArrayOf([lsqlstr]);
      lSqlstr:= 'delete from fms_company_alarm_relat a'+
                ' where a.cityid='+inttostr(gPublicParam.cityid)+
                ' and exists (select 1 from alarm_content_modelcompany b'+
                '            where a.cityid=b.cityid and a.companyid=b.companyid and b.modelid='+inttostr(lModelid)+')';
      lVariant[1]:= VarArrayOf([lsqlstr]);
      lIndex:= 2;

      for i:= 0 to ListViewContentModelDetail.Items.Count -1 do
      begin
        lWdInteger:= TWdInteger(ListViewContentModelDetail.Items[i].Data);
        lSqlstr:= 'insert into alarm_content_model_relate'+
                  ' (cityid, modelid, alarmcontentcode) values'+
                  ' ('+inttostr(gPublicParam.cityid)+', '+inttostr(lModelid)+', '+lWdInteger.ToString+')';
        lVariant[lIndex]:= VarArrayOf([lsqlstr]);
        inc(lIndex);
      end;
      lSqlstr:= 'insert into fms_company_alarm_relat'+
                ' (cityid, companyid, alarmcontentcode)'+
                ' select a.cityid,b.companyid,a.alarmcontentcode'+
                ' from alarm_content_model_relate a'+
                ' inner join alarm_content_modelcompany b'+
                ' on a.cityid=b.cityid and a.modelid=b.modelid'+
                ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.modelid='+inttostr(lModelid);
      lVariant[lIndex]:= VarArrayOf([lsqlstr]);

      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    end;
    if lsuccess then
    begin
      application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
    end
    else
      application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
  finally
    lList.Free;
    screen.Cursor:= crDefault;
  end;
end;

procedure TFormCompanySet.ListViewContentModelClick(Sender: TObject);
var
  lWdInteger: TWdInteger;
  lItem: TListItem;
begin
  lItem:= ListViewContentModel.Selected;
  if (lItem=nil) or (lItem.Data=nil) then exit;
  self.ButtonSave2.Enabled:= true;
  lWdInteger:= TWdInteger(lItem.Data);
  LoadContentModelDetail(ListViewContentModelDetail,gPublicParam.cityid,lWdInteger.Value,true);

  SetFilted(gFiltedContentDataSet, '');
  LoadContentFilter(gFiltedContentDataSet, CheckListBoxContent);
end;

procedure TFormCompanySet.ButtonSave3Click(Sender: TObject);
var
  lModelid: integer;
  lVariant: Variant;
  lSqlstr: string;
  lsuccess: boolean;
  lItem: TListItem;
  i: integer;
  lIndex: integer;
  lEffect_CompanyidStr,
  lEffect_GatheridStr, lEffect_ContentStr: string;
  iError: integer;
  lEffectedAlarm: boolean;
  lAlarmParamInput: TAlarmParamInput;
  lCompanyid: integer;
  lCompanyidStr: string;
  function CompanySelected: boolean;
  var
    ii: integer;
  begin
    result:= false;
    for ii:= 0 to TreeViewCompanySet.Items.Count -1 do
    begin
      if (TreeViewCompanySet.Items[ii].ImageIndex= 5)
        and (TCompanyNodeParam(TreeViewCompanySet.Items[ii].Data).IsLeaf) then
      begin
        result:= true;
        break;
      end;
    end;
  end;
  function GetVariantLength: integer;
  var
    ii: integer;
  begin
    result:= 0;
    for ii:= 0 to TreeViewCompanySet.Items.Count -1 do
    begin
      if (TreeViewCompanySet.Items[ii].ImageIndex=5)
         and TCompanyNodeParam(TreeViewCompanySet.Items[ii].Data).IsLeaf then
      begin
        inc(result);
      end;
    end;
    result:= result+ 3;
  end;
begin
  lItem:= ListViewContentModelSet.Selected;
  if (lItem= nil) or (lItem.Data= nil) then
  begin
    application.MessageBox('获取告警内容模板信息失败，请先选择一个告警内容模板！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if not CompanySelected then
  begin
    application.MessageBox('请选择维护单位(本功能只提供保存叶子维护单位)！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  //判断取消的告警内容是否有告警 判断是否删除告警 更改主从关系
  GetAlarmParam(3);
  CheckAlarmParam(3);
  lEffectedAlarm:= false;
  if IsEffectedAlarm then
  begin
    lEffectedAlarm:= true;
    if Application.MessageBox(PChar('该操作会影响在线告警，是否继续？'),
                            '系统提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;
  end;
  Screen.Cursor:=crHourGlass;
  lsuccess:= false;
  iError:= 0;
  try
    //删除告警信息和调整主从关系
    if lEffectedAlarm and GetEffectedCondition(3,lEffect_CompanyidStr,lEffect_GatheridStr,lEffect_ContentStr) then
    begin
      for i:= 0 to gAlarmParamInputList.Count -1 do
      begin
        lAlarmParamInput:= TAlarmParamInput(gAlarmParamInputList.Objects[i]);
        iError:= gTempInterface.CompanyMgr(gPublicParam.cityid,lAlarmParamInput.Companyid,'',lAlarmParamInput.ContentStr,gPublicParam.userid,null);
        if iError<>0 then break;
      end;
    end;
    if iError=0 then
    begin
      lModelid:= TWdInteger(lItem.Data).Value;
      for i:= 0 to TreeViewCompanySet.Items.Count - 1 do
      begin
        if (TreeViewCompanySet.Items[i].ImageIndex=5)
          and TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).IsLeaf then //勾选的
        begin
          lCompanyid:= TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).Companyid;
          lCompanyidStr:= lCompanyidStr+ inttostr(lCompanyid)+',';
        end;
      end;
      if length(lCompanyidStr)>0 then
        lCompanyidStr:= copy(lCompanyidStr,1,length(lCompanyidStr)-1);
      lVariant:= VarArrayCreate([0,GetVariantLength-1],varVariant);

      //lIndex:= 0;
      lSqlstr:= 'delete from fms_company_alarm_relat a'+
                ' where a.cityid='+inttostr(gPublicParam.cityid)+
                ' and exists (select 1 from alarm_content_modelcompany b'+
                '            where a.cityid=b.cityid and a.companyid=b.companyid'+
                             ' and ((b.modelid='+inttostr(lModelid)+' and b.companyid not in ('+lCompanyidStr+'))'+
                                    //' or (b.modelid<>'+inttostr(lModelid)+' and b.companyid in ('+lCompanyidStr+')))'+
                                    ' or (b.companyid in ('+lCompanyidStr+')))'+
                             ')';
      lVariant[0]:= VarArrayOf([lsqlstr]);
      inc(lIndex);
      lSqlstr:= 'delete from alarm_content_modelcompany a'+
                ' where a.cityid='+inttostr(gPublicParam.cityid)+
                ' and ((a.modelid='+inttostr(lModelid)+' and a.companyid not in ('+lCompanyidStr+'))'+
                       //' or (a.modelid<>'+inttostr(lModelid)+' and a.companyid in ('+lCompanyidStr+'))'+
                       ' or (a.companyid in ('+lCompanyidStr+'))'+
                       ')';
      lVariant[1]:= VarArrayOf([lsqlstr]);
      lIndex:= 2;
      //保存维护单位和告警模板关系
      for i:= 0 to TreeViewCompanySet.Items.Count -1 do
      begin
        if (TreeViewCompanySet.Items[i].ImageIndex= 5)
          and (TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).IsLeaf) then
        begin
          lsqlstr:= 'insert into alarm_content_modelcompany'+
                    ' (cityid, modelid, companyid) values'+
                    ' ('+inttostr(gPublicParam.cityid)+', '+inttostr(lModelid)+', '+
                    inttostr(TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).Companyid)+')';
          lVariant[lIndex]:= VarArrayOf([lsqlstr]);
          inc(lIndex);
        end;
      end;

      lsqlstr:= 'insert into fms_company_alarm_relat'+
                 ' (cityid, companyid, alarmcontentcode)'+
                 ' select a.cityid,a.companyid,b.alarmcontentcode'+
                 ' from alarm_content_modelcompany a'+
                 ' inner join alarm_content_model_relate b'+
                 ' on a.cityid=b.cityid and a.modelid=b.modelid'+
                 ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.modelid='+inttostr(lModelid);
      lVariant[lIndex]:= VarArrayOf([lsqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    end;
    if lsuccess then
    begin
      application.MessageBox('操作成功','提示',MB_OK + MB_ICONINFORMATION);
      gActedPage:= gActedPage - [wd_Acted_Preview];
    end
    else
      application.MessageBox('操作失败','提示',MB_OK + MB_ICONINFORMATION);
  finally
    screen.Cursor:= crDefault;
  end;
end;

procedure TFormCompanySet.NDelSelContentClick(Sender: TObject);
var
  i: integer;
begin
  ListViewContentModelDetail.Items.BeginUpdate;
  try
    for i:= ListViewContentModelDetail.Items.Count -1 downto 0 do
    begin
      if ListViewContentModelDetail.Items[i].Selected then
      begin
        dispose(ListViewContentModelDetail.Items[i].Data);
        ListViewContentModelDetail.Items[i].Delete;
        gSelectedContenList.Delete(i);
      end;
    end;
    for i:= 0 to CheckListBoxContent.Items.Count -1 do
    begin
      if CheckListBoxContent.Checked[i] then
      begin
        if gSelectedContenList.IndexOf(TWdInteger(CheckListBoxContent.Items.Objects[i]).ToString)=-1 then
          CheckListBoxContent.Checked[i]:= false;
      end;
    end;
    for i:= 0 to ListViewContentModelDetail.Items.Count -1 do
    begin
      ListViewContentModelDetail.Items[i].Caption:= format('%.4d',[i+1]);
    end;
  finally
    ListViewContentModelDetail.Items.EndUpdate;
  end;
end;

procedure TFormCompanySet.ListViewContentModelSetClick(Sender: TObject);
var
  lWdInteger: TWdInteger;
  lItem: TListItem;
begin
  lItem:= ListViewContentModelSet.Selected;
  if (lItem=nil) or (lItem.Data=nil) then exit;
  self.ButtonSave3.Enabled:= true;
  lWdInteger:= TWdInteger(lItem.Data);
  LoadContentModelDetail(ListViewContentDetailSet,gPublicParam.cityid,lWdInteger.Value,true);
  LoadCompanyByModel(gPublicParam.cityid,lWdInteger.Value);
end;
procedure TFormCompanySet.LoadCompanyByModel(aCtiyid, aModelID: integer);
var
  llClientDataSet: TClientDataSet;
  llSqlstr: string;
  lCompanyStr: string;
  i: integer;
  lList: TStringList;
begin
  llClientDataSet:= TClientDataSet.Create(nil);
  lList:= TStringList.Create;
  lCompanyStr:= '';
  try
    with llClientDataSet do
    begin
      Close;
      llSqlstr:= 'select distinct t.modelid,t.companyid from alarm_content_modelcompany t'+
                 ' where t.cityid='+inttostr(aCtiyid)+' and t.modelid='+inttostr(aModelID);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,llSqlstr]),0);
      while not eof do
      begin
        lCompanyStr:= lCompanyStr+ FieldByName('companyid').AsString+',';
        next;
      end;
    end;

    lList.Delimiter:= ',';
    lList.DelimitedText:= lCompanyStr;
    for i:= 0 to TreeViewCompanySet.Items.Count -1 do
    begin
      {if (lCompanyStr<>'')
        and (Pos(inttostr(TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).Companyid)+',',lCompanyStr)> 0) then}
      if lList.IndexOf(inttostr(TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).Companyid))> -1 then
      begin
        TreeViewCompanySet.Items[i].ImageIndex:= 5;
        TreeViewCompanySet.Items[i].SelectedIndex:= TreeViewCompanySet.Items[i].ImageIndex;
      end
      else
      begin
        TreeViewCompanySet.Items[i].ImageIndex:= 3;
        TreeViewCompanySet.Items[i].SelectedIndex:= TreeViewCompanySet.Items[i].ImageIndex;
      end;
    end;
  finally
    llClientDataSet.Free;
    lList.Free;
  end;
end;

procedure TFormCompanySet.SetTreeViewImage(aTreeView: TTreeView;
  aIndex: integer);
var
  i: integer;
begin
  for i:= 0 to aTreeView.Items.Count -1 do
  begin
    aTreeView.Items[i].ImageIndex:= aIndex;
    aTreeView.Items[i].SelectedIndex:= aTreeView.Items[i].ImageIndex;
  end;
end;

procedure TFormCompanySet.TreeViewCompanySetMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode: TTreeNode;
begin
  {lCompareTree:= true;
  if TreeViewCompany.Items.Count<>TreeViewCompanySet.Items.Count then
    lCompareTree:= false
  else
  begin
    for i:=0 to TreeViewCompany.Items.Count -1 do
    begin
      if TCompanyNodeParam(TreeViewCompany.Items[i].Data).Companyid<>
         TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).Companyid then
      begin
        lCompareTree:= false;
        break;
      end;
    end;
  end;
  if not lCompareTree then
  begin
    application.MessageBox('维护单位信息已经发生变化，请重新加载','提示',MB_OK + MB_ICONINFORMATION);
    ClearTreeView(TreeViewCompanySet);
    LoadCompanyTree(gPublicParam.cityid, -1, nil, TreeViewCompanySet);
    SetTreeViewImage(TreeViewCompanySet,3);
  end;}

  if not(htonitem in TreeViewCompanySet.GetHitTestInfoAt(X,Y)) then
    Exit;
  lNode:= TreeViewCompanySet.Selected;
  if lNode=nil then Exit;
  TreeViewCompanySet.Items.BeginUpdate;
  try
    if lNode.ImageIndex=3 then
      lNode.ImageIndex:=5
    else
      lNode.ImageIndex:=3;
    lNode.SelectedIndex:= lNode.ImageIndex;

    if lNode.HasChildren then
      SetChildNode(lNode.ImageIndex,lNode);
    SetParentNode(lNode.ImageIndex,lNode);
  finally
    TreeViewCompanySet.Items.EndUpdate;
  end;
end;

procedure TFormCompanySet.CheckAlarmParam(aFlag: integer);
var
  lCompanyid: integer;
  lCompanyidStr: String;
  lSqlstr: string;
  lAlarmParam: TAlarmParam;
  i: integer;
  lModelid: integer;
begin
  case aFlag of
    1: begin
         lCompanyid:= TCompanyNodeParam(TreeViewCompany.Selected.Data).Companyid;
         try
           with gCheckDataSet do
           begin
             close;
             lSqlstr:= 'select a.companyid,b.devicegatherid,c.alarmcontentcode'+
                           ' from alarm_content_modelcompany a'+
                           ' inner join fms_company_devgather_relat b'+
                           ' on a.cityid=b.cityid and a.companyid=b.companyid'+
                           ' inner join alarm_content_model_relate c'+
                           ' on a.cityid=c.cityid and a.modelid=c.modelid'+
                           ' inner join fms_devicegather_detail d'+
                           ' on b.cityid=d.cityid and b.devicegatherid=d.devicegatherid'+
                           ' inner join fault_detail_online e'+
                           ' on a.cityid=e.cityid and a.companyid=e.companyid'+
                           ' and c.alarmcontentcode=e.alarmcontentcode'+
                           ' and (d.deviceid=e.deviceid or e.alarmcontentcode=800000001)'+
                           ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.companyid='+inttostr(lCompanyid)+
                           ' group by a.companyid,b.devicegatherid,c.alarmcontentcode';
             Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
             for i:= 0 to gCheckAlarmParamList.Count -1 do
             begin
               lAlarmParam:= TAlarmParam(gCheckAlarmParamList.Objects[i]);
               if gCheckDataSet.Locate('companyid;devicegatherid;alarmcontentcode',
                              VarArrayOf([lAlarmParam.CompanyParam,lAlarmParam.GatherParam,lAlarmParam.ContentParam]),
                              []) then
                 gCheckDataSet.Delete;
             end;
           end;
         finally

         end;
    end;
    2: begin
         lModelid:= TWdInteger(ListViewContentModel.Selected.Data).Value;
         try
           with gCheckDataSet do
           begin
             close;
             lSqlstr:= 'select a.companyid,b.devicegatherid,c.alarmcontentcode'+
                           ' from alarm_content_modelcompany a'+
                           ' inner join fms_company_devgather_relat b'+
                           ' on a.cityid=b.cityid and a.companyid=b.companyid'+
                           ' inner join alarm_content_model_relate c'+
                           ' on a.cityid=c.cityid and a.modelid=c.modelid'+
                           ' inner join fms_devicegather_detail d'+
                           ' on b.cityid=d.cityid and b.devicegatherid=d.devicegatherid'+
                           ' inner join fault_detail_online e'+
                           ' on a.cityid=e.cityid and a.companyid=e.companyid'+
                           ' and c.alarmcontentcode=e.alarmcontentcode'+
                           ' and (d.deviceid=e.deviceid or e.alarmcontentcode=800000001)'+
                           ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.modelid='+inttostr(lModelid)+
                           ' group by a.companyid,b.devicegatherid,c.alarmcontentcode';
             Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
             for i:= 0 to gCheckAlarmParamList.Count -1 do
             begin
               lAlarmParam:= TAlarmParam(gCheckAlarmParamList.Objects[i]);
               if gCheckDataSet.Locate('companyid;devicegatherid;alarmcontentcode',
                              VarArrayOf([lAlarmParam.CompanyParam,lAlarmParam.GatherParam,lAlarmParam.ContentParam]),
                              [loCaseInsensitive]) then
                 gCheckDataSet.Delete;
             end;
           end;
         finally

         end;
    end;
    3: begin
         lModelid:= TWdInteger(ListViewContentModelSet.Selected.Data).Value;
         try
           for i:= 0 to TreeViewCompanySet.Items.Count - 1 do
           begin
             if (TreeViewCompanySet.Items[i].ImageIndex=5)
               and TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).IsLeaf then //勾选的
             begin
               lCompanyid:= TCompanyNodeParam(TreeViewCompanySet.Items[i].Data).Companyid;
               lCompanyidStr:= lCompanyidStr+ inttostr(lCompanyid)+',';
             end;
           end;
           if length(lCompanyidStr)>0 then
             lCompanyidStr:= copy(lCompanyidStr,1,length(lCompanyidStr)-1);

           with gCheckDataSet do
           begin
             close;
             lSqlstr:= 'select a.companyid,b.devicegatherid,c.alarmcontentcode'+
                           ' from alarm_content_modelcompany a'+
                           ' inner join fms_company_devgather_relat b'+
                           ' on a.cityid=b.cityid and a.companyid=b.companyid'+
                           ' inner join alarm_content_model_relate c'+
                           ' on a.cityid=c.cityid and a.modelid=c.modelid'+
                           ' inner join fms_devicegather_detail d'+
                           ' on b.cityid=d.cityid and b.devicegatherid=d.devicegatherid'+
                           ' inner join fault_detail_online e'+
                           ' on a.cityid=e.cityid and a.companyid=e.companyid'+
                           ' and c.alarmcontentcode=e.alarmcontentcode'+
                           ' and (d.deviceid=e.deviceid or e.alarmcontentcode=800000001)'+
                           ' where a.cityid='+inttostr(gPublicParam.cityid)+
                           ' and ((a.modelid='+inttostr(lModelid)+' and a.companyid not in ('+lCompanyidStr+'))'+
                           '      or (a.modelid<>'+inttostr(lModelid)+' and a.companyid in ('+lCompanyidStr+')))'+
                           ' group by a.companyid,b.devicegatherid,c.alarmcontentcode';
             Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
             for i:= 0 to gCheckAlarmParamList.Count -1 do
             begin
               lAlarmParam:= TAlarmParam(gCheckAlarmParamList.Objects[i]);
               if gCheckDataSet.Locate('companyid;devicegatherid;alarmcontentcode',
                              VarArrayOf([lAlarmParam.CompanyParam,lAlarmParam.GatherParam,lAlarmParam.ContentParam]),
                              [loCaseInsensitive]) then
                 gCheckDataSet.Delete;
             end;
           end;
         finally

         end;
    end;
    4: begin
         lCompanyid:= TCompanyNodeParam(TreeViewCompany.Selected.Data).Companyid;
         try
           with gCheckDataSet do
           begin
             close;
             lSqlstr:= 'select a.companyid,b.devicegatherid,c.alarmcontentcode'+
                           ' from alarm_content_modelcompany a'+
                           ' inner join fms_company_devgather_relat b'+
                           ' on a.cityid=b.cityid and a.companyid=b.companyid'+
                           ' inner join alarm_content_model_relate c'+
                           ' on a.cityid=c.cityid and a.modelid=c.modelid'+
                           ' inner join fms_devicegather_detail d'+
                           ' on b.cityid=d.cityid and b.devicegatherid=d.devicegatherid'+
                           ' inner join fault_detail_online e'+
                           ' on a.cityid=e.cityid and a.companyid=e.companyid'+
                           ' and c.alarmcontentcode=e.alarmcontentcode'+
                           ' and (d.deviceid=e.deviceid or e.alarmcontentcode=800000001)'+
                           ' where a.cityid='+inttostr(gPublicParam.cityid)+' and a.companyid in ('+inttostr(lCompanyid)+')'+
                           ' group by a.companyid,b.devicegatherid,c.alarmcontentcode';
             Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
             for i:= 0 to gCheckAlarmParamList.Count -1 do
             begin
               lAlarmParam:= TAlarmParam(gCheckAlarmParamList.Objects[i]);
               if gCheckDataSet.Locate('companyid;devicegatherid;alarmcontentcode',
                              VarArrayOf([lAlarmParam.CompanyParam,lAlarmParam.GatherParam,lAlarmParam.ContentParam]),
                              [loCaseInsensitive]) then
                 gCheckDataSet.Delete;
             end;
           end;
         finally

         end;
    end;
  end;
end;

procedure TFormCompanySet.GetAlarmParam(aFlag: integer);
var
  lCompanyid, lGatherid, lContentcode: integer;
  i, j: integer;
  lAlarmParam: TAlarmParam;
  lModelid: integer;
  lClientDataSet: TClientDataSet;
  lSqlstr: string;
begin
  ClearTStrings(gCheckAlarmParamList);
  case aFlag of
    1: begin        //第一个TABLE页面
         lCompanyid:= TCompanyNodeParam(TreeViewCompany.Selected.Data).Companyid;
         for i:= 0 to CheckListBoxDeviceGather.Items.Count - 1 do
         begin
           if CheckListBoxDeviceGather.Checked[i] then
           begin
             lGatherid:= TWdInteger(CheckListBoxDeviceGather.Items.Objects[i]).Value;
             for j:= 0 to ListViewContentDetail.Items.Count -1 do
             begin
               lContentcode:= TWdInteger(ListViewContentDetail.Items[j].Data).Value;
               lAlarmParam:= TAlarmParam.Create;
               lAlarmParam.CompanyParam:= lCompanyid;
               lAlarmParam.GatherParam:= lGatherid;
               lAlarmParam.ContentParam:= lContentcode;
               gCheckAlarmParamList.AddObject(inttostr(gCheckAlarmParamList.Count+1),lAlarmParam);
             end;
           end;
         end;
       end;
    2: begin        //第2个TABLE页面
         lModelid:= TWdInteger(ListViewContentModel.Selected.Data).Value;
         lClientDataSet:= TClientDataSet.Create(nil);
         try
           with lClientDataSet do
           begin
             close;
             lSqlstr:= 'select distinct a.companyid,b.devicegatherid from alarm_content_modelcompany a'+
                       ' inner join fms_company_devgather_relat b'+
                       ' on a.cityid=b.cityid and a.companyid=b.companyid'+
                       ' where a.modelid='+inttostr(lModelid)+' and a.cityid='+inttostr(gPublicParam.cityid);
             Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
             first;
             while not eof do
             begin
               lCompanyid:= FieldByName('companyid').AsInteger;
               lGatherid:= FieldByName('devicegatherid').AsInteger;
               for i:= 0 to ListViewContentModelDetail.Items.Count -1 do
               begin
                 lContentcode:= TWdInteger(ListViewContentModelDetail.Items[i].Data).Value;
                 lAlarmParam:= TAlarmParam.Create;
                 lAlarmParam.CompanyParam:= lCompanyid;
                 lAlarmParam.GatherParam:= lGatherid;
                 lAlarmParam.ContentParam:= lContentcode;
                 gCheckAlarmParamList.AddObject(inttostr(gCheckAlarmParamList.Count+1),lAlarmParam);
               end;
               next;
             end;
           end;
         finally
           lClientDataSet.Free;
         end;
       end;
    3: begin        //第3个TABLE页面
         //
       end;
    4: begin        //删除维护单位
         //
       end;
  end;
end;

function TFormCompanySet.IsEffectedAlarm: boolean;
begin
  result:= false;
  if gCheckDataSet.RecordCount>0 then
    result:= true;
end;

function TFormCompanySet.GetEffectedCondition(aFlag: integer;
  var aCompanyidStr, aGatheridStr, aContentStr: string): boolean;
var
  i: integer;
  lAlarmParamInput: TAlarmParamInput;
begin
  try
    gAlarmParamInputList.Clear;
    with gCheckDataSet do
    begin
      first;
      while not eof do
      begin
        if gAlarmParamInputList.IndexOf(fieldByName('companyid').AsString)=-1 then
        begin
          lAlarmParamInput:= TAlarmParamInput.Create;
          lAlarmParamInput.Companyid:= fieldByName('companyid').AsInteger;
          lAlarmParamInput.GatherStr:= fieldByName('devicegatherid').AsString+',';
          lAlarmParamInput.ContentStr:= fieldByName('alarmcontentcode').AsString+',';
          gAlarmParamInputList.AddObject(inttostr(lAlarmParamInput.Companyid),lAlarmParamInput);
        end
        else
        begin
          lAlarmParamInput:= TAlarmParamInput(gAlarmParamInputList.Objects[gAlarmParamInputList.IndexOf(fieldByName('companyid').AsString)]);
          lAlarmParamInput.GatherStr:= lAlarmParamInput.GatherStr+ fieldByName('devicegatherid').AsString+ ',';
          lAlarmParamInput.ContentStr:= lAlarmParamInput.ContentStr+ fieldByName('alarmcontentcode').AsString+ ','
        end;
        next;
      end;
    end;
    //调整样式
    for i:= 0 to gAlarmParamInputList.Count -1 do
    begin
      lAlarmParamInput:= TAlarmParamInput(gAlarmParamInputList.Objects[i]);
      if length(lAlarmParamInput.GatherStr)>0 then
        lAlarmParamInput.GatherStr:= copy(lAlarmParamInput.GatherStr,1,length(lAlarmParamInput.GatherStr)-1);
      if length(lAlarmParamInput.ContentStr)>0 then
        lAlarmParamInput.ContentStr:= copy(lAlarmParamInput.ContentStr,1,length(lAlarmParamInput.ContentStr)-1);
    end;
    result:= true;
  finally

  end;
end;

procedure TFormCompanySet.CheckListBoxContentClick(Sender: TObject);
var
  lItemIndex: Integer;
begin
  lItemIndex:= CheckListBoxContent.ItemIndex;
  if CheckListBoxContent.Selected[lItemIndex] then
    CheckListBoxContent.Hint:= CheckListBoxContent.Items.Strings[lItemIndex];
end;

end.
