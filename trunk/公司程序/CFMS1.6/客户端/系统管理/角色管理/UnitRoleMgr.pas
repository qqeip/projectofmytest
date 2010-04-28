unit UnitRoleMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ProjectCFMS_Server_TLB, ExtCtrls, SConnect,
  cxLookAndFeelPainters, ComCtrls, cxTreeView, cxControls, cxContainer,
  cxEdit, cxGroupBox, Menus, cxButtons, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, CxGridUnit,
  ImgList, DBClient, cxTextEdit, cxLabel, cxGridDBTableView, cxGrid,
  cxMaskEdit, cxDropDownEdit, jpeg;
type
  TModule = class(Tobject)
    ModuleId: Integer;
    ModuleName: string;
end;

type
  TFormRoleMgr = class(TForm)
    pnl1: TPanel;
    spl1: TSplitter;
    pnl2: TPanel;
    cxGroupBox1: TcxGroupBox;
    cxTreeViewRole: TcxTreeView;
    cxGroupBoxRoleInfo: TcxGroupBox;
    cxGroupBoxRoleSet: TcxGroupBox;
    pnl3: TPanel;
    cxButtonAdd: TcxButton;
    cxButtonModify: TcxButton;
    cxButtonDel: TcxButton;
    cxLabel1: TcxLabel;
    cxTextEditRoleName: TcxTextEdit;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    ImageList1: TImageList;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxLabel2: TcxLabel;
    cxComboBoxPrivilegeFlag: TcxComboBox;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxTreeViewRoleMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FCxGridHelper : TCxGridSet;
    IsOperateSucc: boolean;
    procedure LoadModuleTree();
    procedure LoadRoleInfo();
    procedure AddViewField_Role;
    procedure SetTreeNoCheck;
    procedure SetTreeCheck(aRoleID:Integer);
    function  GetTreeCheckedCount(aCxTreeView: TcxTreeView):Integer;
    function  GetCityName(aCityID: Integer): string;
  public
    { Public declarations }
  end;

var
  FormRoleMgr: TFormRoleMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormRoleMgr.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);
end;

procedure TFormRoleMgr.FormShow(Sender: TObject);
begin
//
  AddViewField_Role;
  LoadRoleInfo;
  LoadModuleTree;
end;

procedure TFormRoleMgr.FormClose(Sender: TObject;var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormRoleMgr,1,'','');
end;

procedure TFormRoleMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormRoleMgr.cxButtonAddClick(Sender: TObject);
 var
   I, J, lModuleID, lTreeCheckedCount : Integer;
   lRoleID: Integer;
   lVariant: variant;
   lSqlstr: string;
   lsuccess: boolean;
begin
  if cxTextEditRoleName.Text='' then
  begin
    Application.MessageBox('角色名称不能为空','提示',MB_OK + 64);
    Exit;
  end;
  if IsExists('fms_role_info','ROLENAME',cxTextEditRoleName.Text) then
  begin
    Application.MessageBox('该角色名称已经存在!','提示',MB_OK+64);
    Exit;
  end;
  lTreeCheckedCount:= GetTreeCheckedCount(cxTreeViewRole);
  lRoleID:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
  lVariant:= VarArrayCreate([0,lTreeCheckedCount],varVariant);

  lSqlstr:= 'insert into fms_role_info'+
            '(ROLEID,ROLENAME,CITYID,PRIVEFLAG) '+
            ' values '+
            ' ('+inttostr(lroleID)+','''+cxTextEditRoleName.Text+''','+ IntToStr(gPublicParam.cityid)+','+ IntToStr(cxComboBoxPrivilegeFlag.ItemIndex) +')';
  lVariant[0]:= VarArrayOf([lSqlstr]);
  J:=0;
  for I:= 0 to cxTreeViewRole.Items.Count-1 do
  begin
    if (cxTreeViewRole.Items[i].ImageIndex=1) and (cxTreeViewRole.Items[i].level=1) then
    begin
      if J>lTreeCheckedCount then Exit;
      lModuleID:= TModule(cxTreeViewRole.Items[i].Data).ModuleId;
      lSqlstr:= 'insert into fms_role_power_relat'+
                '(ROLEID,MODULEID,CITYID) '+
                'values '+
                '(' + IntToStr(lRoleID) +','+ IntToStr(lModuleID) + ','+inttostr(gPublicParam.cityid)+')';
      lVariant[1+J]:= VarArrayOf([lSqlstr]);
      Inc(J);
    end;
  end;
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    Application.MessageBox('新增成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('ROLEID').AsInteger:= lRoleID;
    ClientDataSet1.FieldByName('ROLENAME').AsString:= cxTextEditRoleName.Text;
    ClientDataSet1.FieldByName('name').AsString:= GetCityName(gPublicParam.cityid);
    ClientDataSet1.FieldByName('FLAGNAME').AsString:= cxComboBoxPrivilegeFlag.Text;
    ClientDataSet1.Post;
    IsOperateSucc:= False;

  end
  else
    Application.MessageBox('新增失败','提示',MB_OK+64);

end;


procedure TFormRoleMgr.cxButtonModifyClick(Sender: TObject);
 var
   I, J, lRoleID, lModuleID, lTreeCheckedCount: Integer;
   lVariant: variant;
   lSqlstr: string;
   lsuccess: boolean;
begin
  if cxTextEditRoleName.Text='' then
  begin
    Application.MessageBox('角色名称不能为空','提示',MB_OK + 64);
    Exit;
  end;
//  if IsExists('fms_role_info','ROLENAME',cxTextEditRoleName.Text) then
//  begin
//    MessageBox(0,'该角色名称已经存在!','提示',MB_OK+64);
//    Exit;
//  end;

  lTreeCheckedCount:= GetTreeCheckedCount(cxTreeViewRole);
  lRoleID:= ClientDataSet1.fieldbyname('ROLEID').AsInteger;

  lVariant:= VarArrayCreate([0,lTreeCheckedCount+1],varVariant);

  lSqlstr:= 'update fms_role_info' +
            ' Set ROLENAME=''' + cxTextEditRoleName.Text +''','+
            ' PRIVEFLAG= ' + IntToStr(cxComboBoxPrivilegeFlag.ItemIndex)+
            ' where ROLEID=' + inttostr(lroleID) +
            ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lSqlstr]);

  lSqlstr:= 'delete fms_role_power_relat where RoleID=' + IntToStr(lRoleID) +
                ' and cityID=' + IntToStr(gPublicParam.cityid);
  lVariant[1]:= VarArrayOf([lSqlstr]);
  J:=0;
  for I:= 0 to cxTreeViewRole.Items.Count-1 do
  begin
    if (cxTreeViewRole.Items[i].ImageIndex=1) and (cxTreeViewRole.Items[i].level=1) then
    begin
      if J>lTreeCheckedCount then Exit;
      lModuleID:= TModule(cxTreeViewRole.Items[i].Data).ModuleId;
      lSqlstr:= 'insert into fms_role_power_relat'+
                '(ROLEID,MODULEID,CITYID) '+
                'values '+
                '(' + IntToStr(lRoleID) +','+ IntToStr(lModuleID) + ','+inttostr(gPublicParam.cityid)+')';
      lVariant[2+J]:= VarArrayOf([lSqlstr]);
      Inc(J);
    end;
  end;
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    Application.MessageBox('修改成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Edit;
    ClientDataSet1.FieldByName('ROLENAME').AsString:= cxTextEditRoleName.Text;
    ClientDataSet1.FieldByName('FLAGNAME').AsString:= cxComboBoxPrivilegeFlag.Text;
    ClientDataSet1.Post;
    IsOperateSucc:= False;
  end
  else
    Application.MessageBox('修改失败','提示',MB_OK+64);
end;

procedure TFormRoleMgr.cxButtonDelClick(Sender: TObject);
var
  lRoleID: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK+64);
    Exit;
  end;
  if Application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;

  lRoleID:= ClientDataSet1.fieldbyname('ROLEID').AsInteger;

  lVariant:= VarArrayCreate([0,1],varVariant);

  lSqlstr:= 'delete from fms_role_info' +
            ' where ROLEID=' + inttostr(lroleID) +
            ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lSqlstr]);

  lSqlstr:= 'delete from fms_role_power_relat' +
            ' where ROLEID=' + inttostr(lroleID) +
            ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[1]:= VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);


  if lsuccess then
  begin
    Application.MessageBox('删除成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Delete;
    IsOperateSucc:= False;
  end
  else
    Application.MessageBox('删除失败','提示',MB_OK+64);
end;

procedure TFormRoleMgr.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
var
  lRoleID: Integer;
begin
  if IsOperateSucc then Exit;
  cxTextEditRoleName.Text:= ClientDataSet1.fieldbyname('ROLENAME').AsString;
  cxComboBoxPrivilegeFlag.ItemIndex:= cxComboBoxPrivilegeFlag.Properties.Items.IndexOf(ClientDataSet1.fieldbyname('flagname').AsString);
  lRoleID:= ClientDataSet1.fieldbyname('ROLEID').AsInteger;
  SetTreeNoCheck;
  SetTreeCheck(lRoleID);
end;

procedure TFormRoleMgr.AddViewField_Role;
begin
  AddViewField(cxGrid1DBTableView1,'ROLEID','内部编号');
  AddViewField(cxGrid1DBTableView1,'ROLENAME','角色名称');
  AddViewField(cxGrid1DBTableView1,'name','所属城市');
  AddViewField(cxGrid1DBTableView1,'FLAGNAME','维护权限');
end;
//加载角色信息
procedure TFormRoleMgr.LoadRoleInfo;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='DataSetProvider';
    Data:= gTempInterface.GetCDSData(VarArrayOf([1,2,gPublicParam.cityid]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;
//增加菜单树节点
procedure TFormRoleMgr.LoadModuleTree;
 var fModule: TModule;
     fClientDataSet: TClientDataset;
     fTempNode, fRootNode: TTreeNode;
begin
  try
    fRootNode:= cxTreeViewRole.Items.Add(nil,'功能菜单');
    fClientDataSet:= TClientDataSet.Create(nil);
    with fClientDataSet do
    begin
      Close;
      fClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,1]),0);

      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        fModule:= TModule.Create;
        fModule.ModuleId:= FieldByName('ModuleId').AsInteger;
        fModule.ModuleName:= FieldByName('ModuleName').AsString;
        fTempNode:= cxTreeViewRole.Items.AddChildObject(fRootNode,'['+IntToStr(fModule.ModuleId)+']'+fModule.ModuleName,fModule);
        fTempNode.ImageIndex:= 0;
        fTempNode.SelectedIndex:= 0;
        Next;
      end;
    end;
    cxTreeViewRole.FullExpand;
  finally
    fClientDataSet.Free;
  end;
end;

procedure TFormRoleMgr.cxTreeViewRoleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cxTreeViewMouseDown(cxTreeViewRole,X,Y);
end;
//清楚菜单树为非选中状态
procedure TFormRoleMgr.SetTreeNoCheck;
var
  I: Integer;
begin
  for i:=0 to cxTreeViewRole.Items.Count-1 do
  begin
    cxTreeViewRole.Items[i].ImageIndex:=0;
    cxTreeViewRole.Items[i].SelectedIndex:=0;
  end;
end;
//选择角色记录时，设置菜单树节点选中状态。
procedure TFormRoleMgr.SetTreeCheck(aRoleID:Integer);
var
  I,lTemp: Integer ;
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,3,aRoleID,gPublicParam.cityid]),0);
      Open;

      if IsEmpty then exit;
      First;
      cxTreeViewRole.Items.BeginUpdate;
      while not Eof do
      begin
        for i:=0 to cxTreeViewRole.Items.Count-1 do
        begin
          if cxTreeViewRole.Items[i].Level=1 then
          begin
            if TModule(cxTreeViewRole.Items[i].Data).ModuleId=FieldByName('ModuleId').AsInteger then
            begin
              cxTreeViewRole.Items[i].ImageIndex:=1;
              cxTreeViewRole.Items[i].SelectedIndex:=1;
            end;
          end;
        end;
        Next;
      end;
      cxTreeViewRole.Items.EndUpdate;
    end;
  finally
    lClientDataSet.Free;
  end;
end;
//获取选中菜单的数量
function TFormRoleMgr.GetTreeCheckedCount(aCxTreeView: TcxTreeView): Integer;
var i,lResult: Integer;
begin
  Result:=0;
  lResult:=0;
  for i:=0 to aCxTreeView.Items.Count-1 do
  begin
    if (aCxTreeView.Items[i].ImageIndex=1) and (aCxTreeView.Items[i].level=1) then
    begin
      Inc(lResult);
    end;
  end;
  Result:= lResult;
end;

function TFormRoleMgr.GetCityName(aCityID: Integer): string;
var lClientDataSet : TClientDataSet;
begin
  Result:='';
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([2,304,aCityID]),0);
      if RecordCount=1 then
        Result:= fieldbyname('name').AsString;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

end.

