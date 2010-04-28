unit UnitFieldGroupManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, ImgList, ComCtrls, Buttons, jpeg;

type
  TFormFieldGroupManager = class(TForm)
    TreeView: TTreeView;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    Et_COL_NAME_eng: TEdit;
    Et_COL_NAME_CHI: TEdit;
    btn_save: TButton;
    Panel2: TPanel;
    bt_togroup: TSpeedButton;
    bt_fromgroup: TSpeedButton;
    GroupBox2: TGroupBox;
    ListViewColumn: TListView;
    GroupBox3: TGroupBox;
    ListViewGroup: TListView;
    ImageList2: TImageList;
    PopupMenu1: TPopupMenu;
    NAddGroup: TMenuItem;
    NModiGroup: TMenuItem;
    NDelGroup: TMenuItem;
    Panel3: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NAddGroupClick(Sender: TObject);
    procedure NModiGroupClick(Sender: TObject);
    procedure NDelGroupClick(Sender: TObject);
    procedure bt_togroupClick(Sender: TObject);
    procedure bt_fromgroupClick(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure ListViewGroupClick(Sender: TObject);
    procedure ListViewGroupCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    ghasChildren: Boolean;
    gListView: TListView;
    function AddGroup(aNode: TTreeNode): boolean;
    function modifyGroup(anode: TTreeNode): boolean;
    function delGroup(anode: TTreeNode): boolean;

    procedure MoveCol(aSour, aDestination: TListView);
    procedure SaveToGroup;
    procedure DeleteFromGroup;
  public
    { Public declarations }
  end;

var
  FormFieldGroupManager: TFormFieldGroupManager;

implementation

uses UnitColComentCommon, UnitColGroup, UnitDllCommon;

{$R *.dfm}

procedure TFormFieldGroupManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DestoryTreeview(TreeView);
  DestoryListView(ListViewColumn);
  DestoryListView(ListViewGroup);

  inherited;
  gDllMsgCall(FormFieldGroupManager,1,'','');
end;

procedure TFormFieldGroupManager.FormCreate(Sender: TObject);
begin
  //
end;

procedure TFormFieldGroupManager.FormShow(Sender: TObject);
begin
  InitDeviceType(TreeView);
end;

procedure TFormFieldGroupManager.TreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode:TTreeNode;
begin
  if not (htOnItem	in (Sender as TTreeView).GetHitTestInfoAt(x,y)) then exit;
  lNode:=TreeView.Selected;
  if lNode=nil then exit;
  if lNode.Level=0 then
  begin
    TreeView.PopupMenu:=nil;
    bt_togroup.Enabled:=false;
    bt_fromgroup.Enabled:=false;
  end
  else
  begin
    TreeView.PopupMenu:=PopupMenu1 ;
    //如果结点含有子结点则显示所有子结点下的规划字段
    if lNode.HasChildren then
    begin
      bt_togroup.Enabled:=false;
      bt_fromgroup.Enabled:=false;
      ghasChildren:=true;
    end
    else
    begin
      bt_togroup.Enabled:=true;
      bt_fromgroup.Enabled:=true;
      ghasChildren:=false;
    end;

    if lNode.Level=1 then NDelGroup.Enabled:=false
    else NDelGroup.Enabled:=true;
  end;
  //根据结点类型 获取该类型字段中没有规划到组的字段
  ShowUnGroupColInfo(lNode,ListViewColumn);
  //显示本组中已经规划的字段
  ShowGroupColInfo(lNode,ListViewGroup);
  if not ghasChildren and (ListViewGroup.Items.Count>0 ) then
    NAddGroup.Enabled:= false
  else
    NAddGroup.Enabled:=true;
end;

procedure TFormFieldGroupManager.NAddGroupClick(Sender: TObject);
var
  lNode : TTreeNode;
begin
  lNode := TreeView.Selected;
  if (lNode=nil) or (lNode.Data=nil) or (TGroupParam(lNode.Data).nodetype=nt_root) then exit;
  addGroup(lNode);
end;

procedure TFormFieldGroupManager.NModiGroupClick(Sender: TObject);
var
  lNode:TTreeNode;
begin
  lNode := TreeView.Selected;
  if (lNode=nil) or (lNode.Data=nil) or (TGroupParam(lNode.Data).nodetype=nt_root) then exit;
    modifyGroup(lNode) ;
end;

function TFormFieldGroupManager.delGroup(aNode: TTreeNode): boolean;
var
  i:integer;
  lNode: TTreeNode;
  lGroupid: integer;
  lGroupidStr: string;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  Result:=false;
  if MessageBox(handle,Pchar('您确定要删除组['+TGroupParam(aNode.Data).name+']吗?'), '系统提示', mb_okcancel + mb_defbutton1+MB_ICONQUESTION)<>idok Then
     exit;
  //删除所有节点和自身
  lGroupidStr:= '';
  for i := 0 to aNode.Count - 1 do
  begin
    lNode:= aNode.Item[i] ;
    lGroupid:= TGroupParam(lNode.Data).id;
    lGroupidStr:= lGroupidStr+ inttostr(lGroupid)+ ',';
  end;
  lGroupidStr:= lGroupidStr+ inttostr(TGroupParam(aNode.Data).id)+ ',';
  lGroupidStr:= copy(lGroupidStr,1,length(lGroupidStr)-1);
  if length(lGroupidStr)>0 then
  begin
    lVariant:= VarArrayCreate([0,1],varVariant);
    lSqlstr:= 'delete from columngroup where id in ('+lGroupidStr+')';
    lVariant[0]:= VarArrayOf([lSqlstr]);
    lSqlstr:= 'delete from columngroup_set where group_code in ('+lGroupidStr+')';
    lVariant[1]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if not lsuccess then
    begin
      MessageBox(handle,Pchar('组信息删除失败!'),'系统提示',MB_ICONWARNING);
      Exit;
    end;

    for i := 0 to aNode.Count - 1 do
    begin
      lNode:=aNode.Item[i] ;
      TGroupParam(lNode.Data).Free;
      TreeView.Items.Delete(lNode);
    end;
    TGroupParam(aNode.Data).Free;
    TreeView.Items.Delete(anode);
    Result:=true;
  end;
end;

function TFormFieldGroupManager.modifyGroup(anode: TTreeNode): boolean;
var
  lNodeParam : TGroupParam;
  lFormcolGroup: TFormcolGroup;
  lGroupName: string;
  lGroupID: integer;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  Result:=false;
  lFormcolGroup:= TFormcolGroup.Create(self);
  try
    lFormcolGroup.Caption:='修改字段组';
    lFormcolGroup.EdGroupName.Text:=TGroupParam(aNode.Data).name;
    if lFormcolGroup.ShowModal =mrOK then
    begin
      lGroupName := Trim(lFormcolGroup.EdGroupName.Text);
      lGroupID:= TGroupParam(aNode.Data).id;
      if IsExists('columngroup','group_name',lGroupName,'ID',inttostr(lGroupID)) then
      begin
        MessageBox(handle,'该组名称已经存在!','系统提示',MB_ICONWARNING);
        Exit;
      end;
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:= 'update columngroup set group_name='''+lGroupName+''' where id='+inttostr(lGroupID);
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
      begin
        MessageBox(handle,Pchar('组信息['+lGroupName+']修改失败,请检查后继续!'),'系统提示',MB_ICONWARNING);
        Exit;
      end;
      lNodeParam := TGroupParam(aNode.Data);
      lNodeParam.name := lGroupName;

      TreeView.Items.BeginUpdate;
      aNode.Text:= lGroupName;
      TreeView.Items.EndUpdate;
      TreeView.Refresh;
      Result:=true;
    end;
  finally
    lFormcolGroup.Free;
  end;
end;

function TFormFieldGroupManager.AddGroup(aNode: TTreeNode): boolean;
var
  lNodeParam : TGroupParam;
  lFormcolGroup: TFormcolGroup;
  lNode:TTreeNode;
  lGroupName: string;
  lGroupID: integer;
  lDeviceType: integer;
  lCityid: integer;
  lParentid: integer;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  result:=false;
  lFormcolGroup:= TFormcolGroup.Create(self);
  try
    lFormcolGroup.Caption:='新增字段组';
    if lFormcolGroup.ShowModal=mrOK then
    begin
      lGroupName := Trim(lFormcolGroup.EdGroupName.Text);
      if IsExists('columngroup','group_name',lGroupName) then
      begin
        MessageBox(handle,'该组名称已经存在!','系统提示',MB_ICONWARNING);
        Exit;
      end;
      lCityid:= TGroupParam(anode.Data).Cityid;
      lDeviceType:= TGroupParam(anode.Data).devicetype;
      lParentid:= TGroupParam(anode.Data).id;
      lVariant:= VarArrayCreate([0,0],varVariant);
      lGroupID := gTempInterface.GetSequence('cfms_seq_normal');
      lSqlstr:= 'insert into columngroup'+
                ' (id, cityid, device_type, group_name, parent_id) values'+
                ' ('+inttostr(lGroupID)+', '+inttostr(lCityid)+', '+inttostr(lDeviceType)+', '''+lGroupName+''', '+inttostr(lParentid)+')';
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
      begin
        MessageBox(handle,Pchar('组信息['+lGroupName+']添加失败,请检查后继续!'),'系统提示',MB_ICONWARNING);
        Exit;
      end;

      lNodeParam := TGroupParam.Create;
      lNodeParam.id := lGroupID;
      lNodeParam.name := lGroupName;
      lNodeParam.CITYID:=TGroupParam(anode.Data).cityid;
      lNodeParam.devicetype:= TGroupParam(anode.Data).devicetype;
      lNodeParam.parentid := TGroupParam(anode.Data).id;
      lNodeParam.nodetype:= nt_group;

      TreeView.Items.BeginUpdate;
      lNode := TreeView.Items.AddChildObject(anode,lNodeParam.name,lNodeParam);
      lNode.ImageIndex := lNode.level;
      lNode.SelectedIndex :=lNode.ImageIndex;
      TreeView.Items.EndUpdate;
      TreeView.Refresh;

      bt_togroup.Enabled:=false;
      bt_fromgroup.Enabled:=false;

      Result:=true;
    end;
  finally
    lFormcolGroup.Free;
  end;
end;

procedure TFormFieldGroupManager.NDelGroupClick(Sender: TObject);
var
  lNode:TTreeNode;
begin
  lNode := TreeView.Selected;
  if (lNode=nil) or (lNode.Data=nil) or (lNode.Level=0) or (lNode.Level=1) then exit;
  delGroup(lNode);
end;

procedure TFormFieldGroupManager.MoveCol(aSour, aDestination: TListView);
var
  i:integer;
  lSourListItem,lDestListItem:TListItem;
begin
  if ghasChildren then exit;
  if TListView(aSour).Name='ListViewColumn' then
     SaveToGroup
  else
     DeleteFromGroup;
  for i := 0 to aSour.Items.Count - 1 do
  begin
    if aSour.Items[i].Selected then
    begin
      lSourListItem:=aSour.Items[i];
      lDestListItem :=aDestination.Items.Add;
      lDestListItem.Data :=lSourListItem.Data;
      lDestListItem.Caption := format('%.3d',[aDestination.Items.Count]);
      lDestListItem.SubItems.Add(TColumnParam(lSourListItem.Data).COL_NAME_CN);
      lDestListItem.SubItems.Add(TColumnParam(lSourListItem.Data).COL_NAME_Eng);
      lDestListItem.SubItems.Add(IntToStr(TColumnParam(lSourListItem.Data).ID));
    end;
  end;
  aSour.DeleteSelected;
end;

procedure TFormFieldGroupManager.SaveToGroup;
var
  i:Integer;
  lSourListItem:TListItem;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
  lSelectedItemCount: integer;
begin
  //保存分组信息
  try
    lSelectedItemCount:= 0;
    for i := 0 to ListViewColumn.Items.Count - 1 do
    begin
      if ListViewColumn.Items[i].Selected then
        inc(lSelectedItemCount);
    end;
    if lSelectedItemCount>0 then
    begin
      lVariant:= VarArrayCreate([0,lSelectedItemCount - 1],varVariant);
      lSelectedItemCount:= 0;
      for i := 0 to ListViewColumn.Items.Count - 1 do
      begin
        if ListViewColumn.Items[i].Selected then
        begin
          lSourListItem:=ListViewColumn.Items[i];
          lSqlstr:= 'insert into columngroup_set (id, cityid, group_code, colcode) values '+
                    ' (cfms_seq_normal.nextval, '+inttostr(TColumnParam(lSourListItem.Data).Cityid)+','+
                     inttostr(TGroupParam(TreeView.Selected.Data).id)+','+
                     inttostr(TColumnParam(lSourListItem.Data).ID)+')';
          lVariant[lSelectedItemCount]:= VarArrayOf([lSqlstr]);
          inc(lSelectedItemCount);
        end;
      end;
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
        MessageBox(handle,Pchar('保存失败'),'系统提示',MB_ICONWARNING);
    end;
  finally
  end;
end;
procedure TFormFieldGroupManager.DeleteFromGroup;
var
  i:Integer;
  lDestListItem:TListItem;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;

  lSelectedItemCount: integer;
begin
  //删除界面不存在 库中存在信息
  try
    lSelectedItemCount:= 0;
    for i := 0 to ListViewGroup.Items.Count - 1 do
    begin
      if ListViewGroup.Items[i].Selected then
        inc(lSelectedItemCount);
    end;
    if lSelectedItemCount>0 then
    begin
      lVariant:= VarArrayCreate([0,lSelectedItemCount - 1],varVariant);
      lSelectedItemCount:= 0;
      for i := 0 to ListViewGroup.Items.Count - 1 do
      begin
        if ListViewGroup.Items[i].Selected then
        begin
          lDestListItem:=ListViewGroup.Items[i];
          lSqlstr:= 'delete from columngroup_set'+
                    ' where group_code='+inttostr(TGroupParam(TreeView.Selected.Data).id)+
                    ' and colcode='+inttostr(TColumnParam(lDestListItem.Data).ID);
          lVariant[lSelectedItemCount]:= VarArrayOf([lSqlstr]);
          inc(lSelectedItemCount);
        end;
      end;
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then
        MessageBox(handle,Pchar('删除失败'),'系统提示',MB_ICONWARNING);
    end;
  finally
  end;
end;

procedure TFormFieldGroupManager.bt_togroupClick(Sender: TObject);
begin
  gListView:=nil;
  MoveCol(ListViewColumn,ListViewGroup);
end;

procedure TFormFieldGroupManager.bt_fromgroupClick(Sender: TObject);
begin
  gListView:=nil;
  MoveCol(ListViewGroup,ListViewColumn);
end;

procedure TFormFieldGroupManager.btn_saveClick(Sender: TObject);
var
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if gListView=nil then exit;
  if trim(Et_COL_NAME_eng.Text)='' then
  begin
    MessageBox(handle,Pchar('请选择要修改的字段信息!'), '系统提示',MB_ICONINFORMATION);
    exit;
  end;
  if trim(Et_COL_NAME_CHI.Text)='' then
  begin
    MessageBox(handle,Pchar('中文名称不能为空!'), '系统提示',MB_ICONINFORMATION);
    exit;
  end;

  if IsExists('columncoment','col_name_cn',Et_COL_NAME_CHI.Text,'col_name_eng',Et_COL_NAME_ENG.Text) then
  begin
    MessageBox(handle,Pchar('中文名称['+trim(Et_COL_NAME_CHI.Text)+']已经存在'), '系统提示',MB_ICONINFORMATION);
    exit;
  end;

  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr:= 'update columncoment set COL_NAME_CN='''+trim(Et_COL_NAME_CHI.Text)+''''+
            ' where upper(COL_NAME_ENG)='''+uppercase(trim(Et_COL_NAME_ENG.Text))+'''';
  lVariant[0]:= VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if not lsuccess then
    MessageBox(handle,'字段信息更改失败!','系统提示',MB_ICONWARNING)
  else
  begin
    gListView.Selected.SubItems[0]:= trim(Et_COL_NAME_CHI.Text) ;
    TColumnParam(gListView.Selected.Data).COL_NAME_CN:=trim(Et_COL_NAME_CHI.Text) ;
    MessageBox(handle,'字段信息保存成功!','系统提示',MB_ICONINFORMATION) ;
  end;
end;

procedure TFormFieldGroupManager.ListViewGroupClick(Sender: TObject);
var
  lListItem:TListItem;
begin
  lListItem:= (Sender as TListView).Selected ;
  if lListItem=nil then exit;
  gListView:= (Sender as TListView) ;
  with lListItem do
  begin
    Et_COL_NAME_eng.Text:=TColumnParam(Data).COL_NAME_ENG; //SubItems[2];
    Et_COL_NAME_chi.Text:=TColumnParam(Data).COL_NAME_CN;
    Et_COL_NAME_eng.Tag :=TColumnParam(Data).ID;
  end;
end;

procedure TFormFieldGroupManager.ListViewGroupCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  i:integer;
begin
  i:= (Sender as TListView).Items.IndexOf(Item);
  if odd(i) then (Sender as TListView).Canvas.Brush.Color:=clSkyBlue
  else (Sender as TListView).Canvas.Brush.Color:=clWhite;
  (Sender as TListView).Canvas.FillRect(Item.DisplayRect(drIcon));   
end;

end.
