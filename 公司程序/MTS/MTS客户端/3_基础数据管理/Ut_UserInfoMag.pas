unit Ut_UserInfoMag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, BaseGrid, AdvGrid, StdCtrls, ComCtrls, Menus,
  DBThreeStateTree, ImgList,CheckLst,DB, DBClient,AdvGridUnit,Ut_common, md5;

const
  InputBoxMessage = WM_USER + 100;

type
  TFm_UserInfoMag = class(TForm)
    p_area: TPanel;
    Panel2: TPanel;
    AdvGrid_UserInfo: TAdvStringGrid;
    Panel1: TPanel;
    Btn_Add: TButton;
    Btn_Modify: TButton;
    Btn_Del: TButton;
    ButtonChangePWD: TButton;
    Btn_Close: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DelClick(Sender: TObject);
    procedure ButtonChangePWDClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);

  private
    { Private declarations }
    ARowId:Integer;
    AdvGridset:TAdvGridset;
    Tv_Area : TDBThreeStateTree;
    procedure Tv_AreaMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
    procedure AdvStringGridInit; //初始化，好看些
    procedure InitCheckListBox(Var checklist : TCheckListBox);//点添加,初始化权限
    procedure InitCheckListBox2(Var checklist : TCheckListBox);//点修改,初始化权限
    procedure LoadPurviewAdd;//点添加，调用权限窗体
    procedure LoadPurviewModify;//点修改，调用权限窗体
    procedure InputBoxSetPasswordChar(var Msg: TMessage); message InputBoxMessage; //传消息,密码输入不可见
    procedure RefreshDate(CityId,AreaId:Integer);  //刷新某区域用户
    procedure ShowAllChildUserinfo;                //刷新所有用户 （属于某区域的所有子用户）
    procedure HideColumns;
  public
    { Public declarations }
    obj : TCommonObj;
    city_id,area_id:Integer;
    lUserID,Creater:Integer;
  end;

var
  Fm_UserInfoMag: TFm_UserInfoMag;

implementation

uses Ut_MainForm,Ut_DataModule,Ut_UserPurview;
{$R *.dfm}

{ TFm_UserInfoMag }

procedure TFm_UserInfoMag.AdvStringGridInit;
begin
  AdvGrid_UserInfo.Cells[1,0]:='用户编号';
  AdvGrid_UserInfo.Cells[2,0]:='用户帐号';
  AdvGrid_UserInfo.Cells[3,0]:='姓名';
  AdvGrid_UserInfo.Cells[4,0]:='邮箱';
  AdvGrid_UserInfo.Cells[5,0]:='性别';
  AdvGrid_UserInfo.Cells[6,0]:='部门职位';
  AdvGrid_UserInfo.Cells[7,0]:='办公电话';
  AdvGrid_UserInfo.Cells[8,0]:='手机';
  AdvGrid_UserInfo.Cells[9,0]:='创建者';
  AdvGrid_UserInfo.cells[10,0]:='所属地市';
  AdvGrid_UserInfo.cells[11,0]:='所属郊县';
  AdvGrid_UserInfo.Rows[1].Text:='';
end;

procedure TFm_UserInfoMag.Btn_AddClick(Sender: TObject);
var
  lTreeNode:TTreeNode;
  Checklayer:integer;
begin
  lTreeNode:=Tv_Area.Selected;

  if lTreeNode=nil then
  begin
  Application.MessageBox('请在左边树图里选择用户归属区域！','信息',MB_ICONINFORMATION+MB_OK) ;
  exit;
  end;
  if lTreeNode.Data=nil then
  begin
  Application.MessageBox('请在左边树图里选择用户归属区域！','信息',MB_ICONINFORMATION+MB_OK) ;
  exit;
  end;
  Checklayer:=PDBThreeNodeInfo(lTreeNode.Data).layer;
  with Fm_MainForm.PublicParam  do
  begin
    if userid=0 then
      LoadPurviewAdd
    else
      begin
      if (cityid=0) and (areaid=0) then  //省用户
        case Checklayer of
        0:Exit;
        else
          LoadPurviewAdd;
        end
      else if (cityid<>0) and (areaid=0) then   //地市用户
        case Checklayer of
        0,1:Exit;
        else
          LoadPurviewAdd;
        end
      else if (cityid<>0) and (areaid<>0) then  //郊县用户
        Exit;
      end;
  end;
  RefreshDate(city_id,area_id);
end;


procedure TFm_UserInfoMag.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFm_UserInfoMag.Btn_DelClick(Sender: TObject);
var
  lTreeNode:TTreeNode;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
    ARowId:= AdvGrid_UserInfo.Row;
    if ARowId<1 then
    begin
      Application.MessageBox('请选择用户！','信息',MB_ICONINFORMATION+MB_OK) ;
      exit;
    end;
    lUserID:=StrToIntDef(Trim(AdvGrid_UserInfo.Rows[ArowId].Strings[1]),-1);
    if lUserID=-1 then
    begin
      Application.MessageBox('请选择用户！','信息',MB_ICONINFORMATION+MB_OK) ;
      exit;
    end;

    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,6,lUserID]),0);
      Delete;
    end;

    with Dm_MTS.cds_common1 do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,7,lUserID]),1);
      First;
      while not Eof do
      begin
      Delete;
      end;
    end;

    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vCDSArray[1]:=Dm_MTS.cds_common1;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      application.MessageBox('用户信息删除成功！', '提示', mb_ok + mb_defbutton1);
      //AdvGrid_UserInfo.RemoveSelectedRows;

      lTreeNode:=Tv_Area.Selected;
      if lTreeNode=nil then
        ShowAllChildUserinfo
      else
        RefreshDate(city_id,area_id);
    except
      application.MessageBox('用户信息删除失败！', '提示', mb_ok + mb_defbutton1);
      Exit;
    end;
end;


procedure TFm_UserInfoMag.Btn_ModifyClick(Sender: TObject);
var
  lTreeNode:TTreeNode;
begin
  ARowId:= AdvGrid_UserInfo.Row;
  if ARowId<1 then
  begin
    Application.MessageBox('请选择用户！','信息',MB_ICONINFORMATION+MB_OK) ;
    exit;
  end;
  lUserID:=StrToIntDef(Trim(AdvGrid_UserInfo.Rows[ArowId].Strings[1]),-1);
  Creater:=StrToIntDef(Trim(AdvGrid_UserInfo.Rows[ArowId].Strings[9]),-1);
  if lUserID=-1 then
  begin
    Application.MessageBox('请选择用户！','信息',MB_ICONINFORMATION+MB_OK) ;
    exit;
  end;
  LoadPurviewModify;

  lTreeNode:=Tv_Area.Selected;
  if lTreeNode=nil then          //全部刷新
  ShowAllChildUserinfo
  else
  RefreshDate(city_id,area_id);  //部分刷新

end;

procedure TFm_UserInfoMag.ButtonChangePWDClick(Sender: TObject);
Var
  Password :String;
  UserNo :String;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  ARowId:= AdvGrid_UserInfo.Row;
  if ARowId<1 then
  begin
    Application.MessageBox('请选择用户！','信息',MB_ICONINFORMATION+MB_OK) ;
    exit;
  end;
  lUserID:=StrToIntDef(Trim(AdvGrid_UserInfo.Rows[ArowId].Strings[1]),-1);
  if lUserID=-1 then
  begin
    Application.MessageBox('请选择用户！','信息',MB_ICONINFORMATION+MB_OK) ;
    exit;
  end;
  UserNo:=Trim(AdvGrid_UserInfo.Rows[ArowId].Strings[2]);

   PostMessage(Handle, InputBoxMessage, 0, 0);
   if not InputQuery('用户密码修改窗口','请输入新密码：', Password) then Exit;
   With Dm_MTS.cds_common Do
   begin
     Close;
     ProviderName:='dsp_General_data';
     Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,6,lUserID]),0);   //
     If RecordCount<=0 Then Exit;
     Edit;
     Password:=LogEntry(MD5String(String(UserNo)+String(Password)));
     FieldByName('USERPWD').Value :=  Password;
     FieldByName('ModifyDate').Value :=  Date;
     try
        try
          vCDSArray[0]:=Dm_MTS.cds_common;
          vDeltaArray:=RetrieveDeltas(vCDSArray);
          vProviderArray:=RetrieveProviders(vCDSArray);
          if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
            SysUtils.Abort;
          application.MessageBox('密码修改成功!', '提示', mb_ok + mb_defbutton1);
        except
          application.MessageBox('密码修改失败,请检查后重试!', '提示', mb_ok + mb_defbutton1);
        end;
     finally
     end;
   end;
  
end;


procedure TFm_UserInfoMag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(AdvGridSet);
  FreeAndNil(obj);
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Fm_UserInfoMag:=nil;

end;

procedure TFm_UserInfoMag.FormCreate(Sender: TObject);
begin
  AdvGridset:=TAdvGridset.Create;
  AdvGridset.AddGrid(AdvGrid_UserInfo);
  AdvGridset.SetGridStyle;
  AdvStringGridInit;
  Tv_Area:=TDBThreeStateTree.Create(Application);
  with Tv_Area,Tv_Area.DBProperties do
  begin
    Align := alClient;
    Parent := p_area;
    TopFieldName :='top_id';
    IDFieldName :='id';
    ShowFieldName :='Name';
    Images:=Fm_MainForm.BarImageList;
    hideselection:=false;              //保持选中的状态
  end;
    Tv_Area.OnMouseDown := Tv_AreaMouseDown;

end;

procedure TFm_UserInfoMag.FormShow(Sender: TObject);
begin
  city_id:=0;
  area_id:=0;
  lUserID:=0;
  Creater:=0;
  With Fm_MainForm.PublicParam Do
  begin
    Dm_MTS.cds_common.Close;
    Dm_MTS.cds_common.ProviderName:='dsp_General_data';
    if (cityid=0) and (areaid=0) then
      Dm_MTS.cds_common.Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,1]),0) //省级
    else if (cityid<>0) and (areaid=0) then
      Dm_MTS.cds_common.Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,3,cityid,cityid]),0)  //地市级
    else if (cityid<>0) and (areaid<>0) then
      Dm_MTS.cds_common.Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,4,cityid,areaid]),0); //郊县级

  Tv_Area.DBProperties.DataSet :=Dm_MTS.cds_common;
  Tv_Area.DBProperties.ThreeState := false;
  Tv_Area.FillTree(nil,-1);
  Tv_Area.DBProperties.DataSet := nil;
  Dm_MTS.cds_common.Close;
  Tv_Area.ReadOnly := true;
  end;
  AdvGrid_UserInfo.SetFocus;
  ShowAllChildUserinfo;

end;

procedure TFm_UserInfoMag.HideColumns;
begin
  AdvGrid_UserInfo.ColWidths[1]:=0;
  AdvGrid_UserInfo.ColWidths[9]:=0;
  AdvGrid_UserInfo.ColWidths[10]:=0;
  AdvGrid_UserInfo.ColWidths[11]:=0;
end;

procedure TFm_UserInfoMag.InitCheckListBox(var checklist: TCheckListBox);
begin
    with Dm_MTS.cds_common,Fm_MainForm.PublicParam do
    begin
      Close;
      ProviderName:='dsp_General_data';
      if Fm_MainForm.PublicParam.userid=0 then  //超级管理员
         Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,3]),0)
      else
         Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,4,userid]),0);

      if RecordCount <= 0 then Exit;
      first;
      while not eof do
      begin
        obj := TCommonObj.Create;
        obj.Name := FieldByName('ModuleName').AsString;
        obj.ID := FieldByName('ModuleID').AsInteger;
        checklist.AddItem(obj.Name,obj);
        Next;
      end;
      Close;
    end;

end;

procedure TFm_UserInfoMag.InitCheckListBox2(var checklist: TCheckListBox);
Var
  i:Integer;
begin
   //加载创建者权限
    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,4,Creater]),0);
      if RecordCount <= 0 then Exit;
      first;
      while not eof do
      begin
        obj := TCommonObj.Create;
        obj.Name := FieldByName('ModuleName').AsString;
        obj.ID := FieldByName('ModuleID').AsInteger;
        checklist.AddItem(obj.Name,obj);
        Next;
      end;
      Close;
    end;
  //选中自己已有的权限
  with Dm_MTS.cds_common1 Do
  begin
    Close;
    ProviderName:='dsp_General_data1';
    Data:= Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,7,lUserID]),1);
    First;
    while not Eof do
    begin
      For i:=0 To checklist.Items.Count -1 Do
      begin
        If (TCommonObj(checklist.Items.Objects[i]).ID=FieldByName('ModuleID').AsInteger) then
         checklist.Checked[i]:=true;
      end;
      Next;
    end;
    Close;
  end;

end;


procedure TFm_UserInfoMag.InputBoxSetPasswordChar(var Msg: TMessage);
var
  hInputForm, hEdit: HWND;
begin
  hInputForm := Screen.Forms[0].Handle;
  if (hInputForm <> 0) then
  begin
    hEdit := FindWindowEx(hInputForm, 0, 'TEdit', nil);
    SendMessage(hEdit, EM_SETPASSWORDCHAR, Ord('*'), 0);
  end;
end;


procedure TFm_UserInfoMag.LoadPurviewAdd;
begin
  Fm_UserUpdate:= TFm_UserUpdate.Create(self);
  try
    Fm_UserUpdate.Caption:='新增用户';
    Fm_UserUpdate.OperateFlag:=1;
    InitCheckListBox(Fm_UserUpdate.CLB_function);
    Fm_UserUpdate.ShowModal;
  finally
    Fm_UserUpdate.Free;
  end;

end;

procedure TFm_UserInfoMag.LoadPurviewModify;
begin
  Fm_UserUpdate:= TFm_UserUpdate.Create(self);
  try
    Fm_UserUpdate.Caption:='修改用户';
    Fm_UserUpdate.OperateFlag:=2;
    Fm_UserUpdate.Edt_accounts.Text:=AdvGrid_UserInfo.Rows[ArowId].Strings[2];
    Fm_UserUpdate.Edt_name.Text:=AdvGrid_UserInfo.Rows[ArowId].Strings[3];
    Fm_UserUpdate.Edt_Email.Text:=AdvGrid_UserInfo.Rows[ArowId].Strings[4];
    Fm_UserUpdate.Cmb_Sex.ItemIndex:=
    Fm_UserUpdate.Cmb_Sex.Items.IndexOf(AdvGrid_UserInfo.Rows[ArowId].Strings[5]);
    Fm_UserUpdate.Edt_dep.Text:=AdvGrid_UserInfo.Rows[ArowId].Strings[6];
    Fm_UserUpdate.Edt_OP.Text:=AdvGrid_UserInfo.Rows[ArowId].Strings[7];
    Fm_UserUpdate.Edt_MP.Text:=AdvGrid_UserInfo.Rows[ArowId].Strings[8];

    InitCheckListBox2(Fm_UserUpdate.CLB_function);
    Fm_UserUpdate.ShowModal;
  finally
    Fm_UserUpdate.Free;
  end;

end;

procedure TFm_UserInfoMag.RefreshDate(CityId, AreaId: Integer);
Var
  Vcity ,Varea:integer;
begin
  Vcity:=CityId;
  Varea:=AreaId;
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,2,0,Vcity,Varea]),0); //选地市层
    if RecordCount >=0 then
    begin
    AdvGridset.DrawGrid(Dm_MTS.cds_common,AdvGrid_UserInfo);
    end;
  end;
  if (AdvGrid_UserInfo.Cells[0,1]='1') and (AdvGrid_UserInfo.Cells[1,1]='') then
     AdvGrid_UserInfo.Cells[0,1]:='';
end;


procedure TFm_UserInfoMag.ShowAllChildUserinfo;
begin
    with Dm_MTS.Cds_common,Fm_MainForm.PublicParam do
    begin
      Close;
      ProviderName:='dsp_General_data';

      if userid=0 then   //管理员
      begin
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,59]),0);
      end
      else
      begin
        if (cityid=0) and (areaid=0) then   //省级用户
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,61]),0)

        else if (cityid<>0) and (areaid=0) then    //地市级用户
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,58,cityid]),0)
           
        else if (cityid<>0) and (areaid<>0) then//郊县级用户
           Exit;
      end;

      if RecordCount>0 then
        begin
          AdvGridset.DrawGrid(Dm_MTS.cds_common,AdvGrid_UserInfo);
          HideColumns;
        end
      else
        begin
        AdvStringGridInit;
        HideColumns;
        end;

    end;
end;


procedure TFm_UserInfoMag.Tv_AreaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Node:TTreeNode;
begin
   if (Button = mbRight) then Exit;
   if not (htOnItem	in TTreeView(Sender).GetHitTestInfoAt(x,y)) then 
     Exit;  //判断鼠标是否点击在树图的节点上

    Node :=TTreeView(Sender).Selected;
    AdvGrid_UserInfo.Clear;
    AdvStringGridInit;
    with Dm_MTS.cds_common,Fm_MainForm.PublicParam do
    begin
      Close;
      ProviderName:='dsp_General_data';

    if userid=0 then   //管理员
      case PDBThreeNodeInfo(node.Data).layer of
       0:begin
          city_id:=0;
          area_id:=0;
          Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,2,0,city_id,area_id]),0);  //选省层
         end;
       1:begin
         city_id:=PDBThreeNodeInfo(node.Data).id;
         area_id:=0;
         Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,2,0,city_id,area_id]),0); //选地市层
         end;
       2:begin
         city_id:=PDBThreeNodeInfo(node.Data).Topid;
         area_id:=PDBThreeNodeInfo(node.Data).id;
         Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,2,0,city_id,area_id]),0);  //选郊县层
         end;
      end
    else
      begin
        if (cityid=0) and (areaid=0) then   //省级用户
          case PDBThreeNodeInfo(node.Data).layer of
           0:Exit;  //省级
           1:begin
             city_id:=PDBThreeNodeInfo(node.Data).id;
             area_id:=0;
             Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,2,0,city_id,area_id]),0); //地市级
             end;
           2:begin
             city_id:=PDBThreeNodeInfo(node.Data).Topid;
             area_id:=PDBThreeNodeInfo(node.Data).id;
             Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,2,0,city_id,area_id]),0);  //郊县级
             end;
          end
        else if (cityid<>0) and (areaid=0) then    //地市级用户
          case PDBThreeNodeInfo(node.Data).layer of
           0:Exit;  //省级
           1:Exit; //地市级
           2:begin
             city_id:=PDBThreeNodeInfo(node.Data).Topid;
             area_id:=PDBThreeNodeInfo(node.Data).id;
             Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,2,0,city_id,area_id]),0);  //郊县级
             end;
          end
        else if (cityid<>0) and (areaid<>0) then    //郊县级用户
          Exit;//什么也看不到
      end;

        if RecordCount >0 then
        begin
        AdvGridset.DrawGrid(Dm_MTS.cds_common,AdvGrid_UserInfo);
        HideColumns;
        end;
    end;

end;


end.

