unit Ut_CityInfoManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ExtCtrls, ComCtrls, DBThreeStateTree, ImgList,DB, DBClient;

type
  TFm_CityManager = class(TForm)
    PopMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    P_area: TPanel;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PopMenuPopup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    { Private declarations }
    Tv_Area : TDBThreeStateTree;
    function  HasExist(aAreaName:string;aAreaid:Integer=-1):Boolean;
    procedure PopupCityVisible;
    procedure PopupCountyVisible;
    procedure PopupBranchVisible;
    procedure popupNoVisible;
    procedure popupAddCounty;
    procedure popupModifyCounty;
    procedure popupAllNoVisible;
    procedure AddOrUpdateTownInfo(Sender: TObject);  //地市
    procedure AddOrUpdateCountyInfo(Sender: TObject);//郊县
    procedure AddOrUpdateBranchInfo(Sender: TObject);//分局
    procedure DeleteTownOrCounty(Sender: TObject);
  public
    { Public declarations }
  end;
var
  Fm_CityManager: TFm_CityManager;

implementation
uses Ut_MainForm,Ut_DataModule,Ut_Common,UnitInputArea;
{$R *.dfm}

procedure TFm_CityManager.AddOrUpdateTownInfo(Sender: TObject);
var
  isappend:Boolean;
  ID,Topid,cityname:string;
  pNode :PDBThreeNodeInfo;
  lNode :TTreeNode;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if (sender as TMenuItem).Tag =0 then
  begin
    isappend:=true;
    FormInputArea:=TFormInputArea.Create(nil);
    if FormInputArea.ShowModal=mrOk then
    begin
      ID := FormInputArea.FAreaID;
      cityname := FormInputArea.FAreaName;
    end;
    if trim(cityname)='' then Exit;
    if HasExist(cityname) then
    begin
      application.MessageBox(PChar('该区域名称['+cityname+']已存在，请确认后重新修改地市名称！'), '提示', mb_ok + mb_defbutton1);
      Exit;
    end;
  end
  else
  begin
    isappend:=false;
    cityname := PDBThreeNodeInfo(Tv_Area.Selected.Data).Name;
    if not InputQuery('修改地市','新地市名称:  ',cityname) then
       Exit;
    if trim(cityname)='' then Exit;
    if HasExist(cityname,PDBThreeNodeInfo(Tv_Area.Selected.Data).id) then
    begin
      application.MessageBox(PChar('该区域名称['+cityname+']已存在，请确认后重新修改地市名称！'), '提示', mb_ok + mb_defbutton1);
      Exit;
    end;
  end;

  With Dm_MTS.cds_common Do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,2,3]),0);

      If IsAppend then //新增
      begin
        Topid:=inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).id);
        Append ;
        FieldByName('id').Value :=ID;
        FieldByName('top_id').Value :=Topid;
        FieldByName('name').Value :=cityname;
        FieldByName('layer').Value :=1;
      end
      else//修改
      begin
        ID:=   inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).ID);
        Topid:=inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).Topid);
        if locate('id',ID,[loCaseInsensitive,loPartialKey]) then    //定位记录
        begin
        Edit;
        FieldByName('name').Value :=cityname;
        end
        else
        begin
        application.MessageBox('没找到相关地市！', '提示', mb_ok + mb_defbutton1);
        Exit;
        end;
      end;
     Post;    //提交
     try
       vCDSArray[0]:=Dm_MTS.cds_common;
       vDeltaArray:=RetrieveDeltas(vCDSArray);
       vProviderArray:=RetrieveProviders(vCDSArray);
       if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;

        If IsAppend then //新增
        begin
        New(pNode);
        pNode.ID :=strtoint(ID);
        pNode.Topid := strtoint(Topid);
        pNode.Name := cityname;
        pNode.layer :=1;
        lNode := Tv_Area.Items.AddChildObject(Tv_area.Selected,cityname,pNode);
        lNode.ImageIndex := pNode.layer+1;
        lNode.SelectedIndex := lNode.ImageIndex;
        Tv_Area.Selected.Expand(true);
        end
        else
        begin
          Tv_area.Selected.Text:=cityname;
          PDBThreeNodeInfo(Tv_Area.Selected.Data).Name := cityname;
        end;
        application.MessageBox('操作成功！', '提示', mb_ok + mb_defbutton1);
     except
        application.MessageBox('操作失败！', '提示', mb_ok + mb_defbutton1);
     end;
  end;
end;

procedure TFm_CityManager.DeleteTownOrCounty(Sender: TObject);
var
  ID,lOut:string;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if (Tv_Area.Selected.HasChildren) then
  begin
    if PDBThreeNodeInfo(Tv_Area.Selected.Data).layer=1 then
       lOut := '当前地市包含郊县,请先删除其下所有郊县信息！';
    if PDBThreeNodeInfo(Tv_Area.Selected.Data).layer=2 then
       lOut := '当前郊县包含分局,请先删除其下所有分局信息！';
    application.MessageBox(PChar(lOut), '提示', mb_ok + mb_defbutton1);
    Exit;
  end
  else
    begin
        if application.MessageBox('是否要删除选中的对象？', '提示', MB_OKCANCEL + mb_defbutton2)=IDCANCEL  then
           Exit
        else
          begin
            With Dm_MTS.cds_common Do
            begin
              Close;
              ProviderName:='dsp_General_data';
              Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,2,3]),0);
              ID:=inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).ID);
              if locate('id',ID,[loCaseInsensitive,loPartialKey]) then    //定位记录
                begin
                Delete;
                end
              else
                begin
                application.MessageBox('没找到相关信息！', '提示', mb_ok + mb_defbutton1);
                Exit;
                end;

                try
                 vCDSArray[0]:=Dm_MTS.cds_common;
                 vDeltaArray:=RetrieveDeltas(vCDSArray);
                 vProviderArray:=RetrieveProviders(vCDSArray);
                 if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
                   SysUtils.Abort;

                 Dispose(Tv_Area.Selected.Data);   // 释放选中节点的内存空间
                 Tv_Area.Selected.Delete;
                 application.MessageBox('删除成功！', '提示', mb_ok + mb_defbutton1);
                except
                 application.MessageBox('删除失败！', '提示', mb_ok + mb_defbutton1);
                end;
            end;
        end;

    end;
end;


procedure TFm_CityManager.AddOrUpdateBranchInfo(Sender: TObject);
var
  isappend:Boolean;
  ID,Topid,lbranchname:string;
  lID:Integer;
  pNode :PDBThreeNodeInfo;
  lNode :TTreeNode;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if (sender as TMenuItem).Tag =0 then
  begin
    isappend:=true;
    lbranchname := InputBox('新增分局','分局名称:  ','');
    if trim(lbranchname)='' then Exit;
    if HasExist(lbranchname) then
    begin
      application.MessageBox(PChar('该区域名称['+lbranchname+']已存在，请确认后重新修改分局名称！'), '提示', mb_ok + mb_defbutton1);
      Exit;
    end;
  end
  else
  begin
    isappend:=false;
    lbranchname := PDBThreeNodeInfo(Tv_Area.Selected.Data).name;
    if not InputQuery('修改分局','新分局名称:  ',lbranchname) then
       Exit;
    if trim(lbranchname)='' then Exit;
    lID := PDBThreeNodeInfo(Tv_Area.Selected.Data).ID;
    if HasExist(lbranchname,lID) then
    begin
      application.MessageBox(PChar('该区域名称['+lbranchname+']已存在，请确认后重新修改分局名称！'), '提示', mb_ok + mb_defbutton1);
      Exit;
    end;
  end;

  With Dm_MTS.cds_common Do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,2,3]),0);
    If IsAppend then //新增
    begin
      Topid:=inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).id);
      ID:=inttostr(Dm_MTS.TempInterface.ProduceFlowNumID('AREAID',1));  //添加节点用的
      if trim(ID)='-1' then
      begin
        application.MessageBox('获取分局ID失败！', '提示', mb_ok + mb_defbutton1);
        Exit;
      end;
      Append ;
      FieldByName('id').Value :=ID;
      FieldByName('top_id').Value :=Topid;
      FieldByName('name').Value :=lbranchname;
      FieldByName('layer').Value :=3;
    end
    else//修改
    begin
      ID := inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).ID);
      Topid := inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).Topid);
      if locate('id',ID,[loCaseInsensitive,loPartialKey]) then    //定位记录
      begin
        Edit;
        FieldByName('name').Value := lbranchname;
      end
      else
      begin
        application.MessageBox('没找到相关分局！', '提示', mb_ok + mb_defbutton1);
        Exit;
      end;
    end;
    Post;    //提交
    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      If IsAppend then //新增
      begin
        New(pNode);
        pNode.ID :=strtoint(ID);
        pNode.Topid := strtoint(Topid);
        pNode.Name := lbranchname;
        pNode.layer :=3;
        lNode := Tv_Area.Items.AddChildObject(Tv_area.Selected,lbranchname,pNode);
        lNode.ImageIndex :=pNode.layer+1;
        lNode.SelectedIndex := lNode.ImageIndex;
        Tv_Area.Selected.Expand(true);
      end
      else
      begin
        Tv_area.Selected.Text:=lbranchname;
        PDBThreeNodeInfo(Tv_Area.Selected.Data).Name := lbranchname;
      end;
      application.MessageBox('操作成功！', '提示', mb_ok + mb_defbutton1);
    except
      application.MessageBox('操作失败！', '提示', mb_ok + mb_defbutton1);
    end;
  end;
end;

procedure TFm_CityManager.AddOrUpdateCountyInfo(Sender: TObject);
var
  isappend:Boolean;
  ID,Topid,countyname:string;
  pNode :PDBThreeNodeInfo;
  lNode :TTreeNode;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if (sender as TMenuItem).Tag =0 then
  begin
    isappend:=true;
    countyname := InputBox('新增郊县','郊县名称:  ','');
    if trim(countyname)='' then Exit;
    if HasExist(countyname) then
    begin
      application.MessageBox(PChar('该区域名称['+countyname+']已存在，请确认后重新修改郊县名称！'), '提示', mb_ok + mb_defbutton1);
      Exit;
    end;
  end
  else
  begin
    isappend:=false;
    countyname := PDBThreeNodeInfo(Tv_Area.Selected.Data).name;
    if not InputQuery('修改郊县','新郊县名称:  ',countyname) then
       Exit;
    if trim(countyname)='' then Exit;
    if HasExist(countyname,PDBThreeNodeInfo(Tv_Area.Selected.Data).ID) then
    begin
      application.MessageBox(PChar('该区域名称['+countyname+']已存在，请确认后重新修改郊县名称！'), '提示', mb_ok + mb_defbutton1);
      Exit;
    end;
  end;

  With Dm_MTS.cds_common Do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,2,3]),0);

    If IsAppend then //新增
    begin
      Topid:=inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).id);
      ID:=inttostr(Dm_MTS.TempInterface.ProduceFlowNumID('AREAID',1));  //添加节点用的
      if trim(ID)='-1' then
      begin
      application.MessageBox('获取郊县ID失败！', '提示', mb_ok + mb_defbutton1);
      Exit;
      end;
      Append ;
      FieldByName('id').Value :=ID;
      FieldByName('top_id').Value :=Topid;
      FieldByName('name').Value :=countyname;
      FieldByName('layer').Value :=2;
    end
    else//修改
    begin
      ID:=inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).ID);
      Topid:=inttostr(PDBThreeNodeInfo(Tv_Area.Selected.Data).Topid);
      if locate('id',ID,[loCaseInsensitive,loPartialKey]) then    //定位记录
      begin
      Edit;
      FieldByName('name').Value :=countyname;
      end
      else
      begin
      application.MessageBox('没找到相关郊县！', '提示', mb_ok + mb_defbutton1);
      Exit;
      end;
    end;
    Post;    //提交
    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;

     If IsAppend then //新增
     begin
       New(pNode);
       pNode.ID :=strtoint(ID);
       pNode.Topid := strtoint(Topid);
       pNode.Name := countyname;
       pNode.layer :=2;
       lNode := Tv_Area.Items.AddChildObject(Tv_area.Selected,countyname,pNode);
       lNode.ImageIndex :=pNode.layer+1;
       lNode.SelectedIndex := lNode.ImageIndex;
       Tv_Area.Selected.Expand(true);
     end
     else
     begin
     begin
       Tv_area.Selected.Text:=countyname;
       PDBThreeNodeInfo(Tv_Area.Selected.Data).Name := countyname;
     end;
     end;
     application.MessageBox('操作成功！', '提示', mb_ok + mb_defbutton1);
    except
       application.MessageBox('操作失败！', '提示', mb_ok + mb_defbutton1);
    end;
  end;
end;

procedure TFm_CityManager.FormCreate(Sender: TObject);
begin
  Tv_Area :=TDBThreeStateTree.Create(Application);
  with Tv_Area,Tv_Area.DBProperties do
  begin
    Align := alClient;
    Parent := p_area;
    TopFieldName :='top_id';
    IDFieldName :='id';
    ShowFieldName :='Name';
    Hint:='选中后，右键菜单可操作！';
    ShowHint:=true;
    Images:=Fm_MainForm.BarImageList;
  end;
end;

procedure TFm_CityManager.FormShow(Sender: TObject);
begin
 With Dm_MTS.cds_common,Fm_MainForm.PublicParam Do
  begin
    Close;
    ProviderName:='dsp_General_data';
    if (cityid=0) and (areaid=0) then
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,2,3]),0) //省级
    else if (cityid<>0) and (areaid=0) then
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,3,cityid,cityid]),0)  //地市级
    else if (cityid<>0) and (areaid<>0) then
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,4,cityid,areaid]),0); //郊县级
    Tv_Area.DBProperties.DataSet :=Dm_MTS.cds_common;
    Tv_Area.DBProperties.ThreeState := false;
    Tv_Area.FillTree(nil,-1);
    Tv_Area.DBProperties.DataSet := nil;
    Dm_MTS.cds_common.Close;
    Tv_Area.ReadOnly := true;
    Tv_Area.PopupMenu:=PopMenu;
  end;
end;

function TFm_CityManager.HasExist(aAreaName: string;aAreaid:Integer): Boolean;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if aAreaid=-1 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,70,'where upper(name)='+quotedstr(uppercase(aAreaName))+'']),0)
    else if aAreaid>0 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,70,'where upper(name)='+quotedstr(uppercase(aAreaName))+' and id<>'+inttostr(aAreaid)+'']),0);
    if Dm_MTS.cds_common.RecordCount>0 then
      result:=true                                                
    else
      result:=false;
  end;
end;

procedure TFm_CityManager.N1Click(Sender: TObject);
begin
  AddOrUpdateTownInfo(Sender);
end;

procedure TFm_CityManager.N2Click(Sender: TObject);
begin
  AddOrUpdateTownInfo(Sender);
end;

procedure TFm_CityManager.N3Click(Sender: TObject);
begin
  DeleteTownOrCounty(Sender);
end;

procedure TFm_CityManager.N4Click(Sender: TObject);
begin
  AddOrUpdateCountyInfo(Sender);
end;

procedure TFm_CityManager.N5Click(Sender: TObject);
begin
  AddOrUpdateCountyInfo(Sender);
end;

procedure TFm_CityManager.N6Click(Sender: TObject);
begin
  DeleteTownOrCounty(Sender);
end;

procedure TFm_CityManager.N7Click(Sender: TObject);
begin
  AddOrUpdateBranchInfo(Sender);
end;

procedure TFm_CityManager.N8Click(Sender: TObject);
begin
  AddOrUpdateBranchInfo(Sender);
end;

procedure TFm_CityManager.N9Click(Sender: TObject);
begin
  DeleteTownOrCounty(Sender);
end;

procedure TFm_CityManager.PopMenuPopup(Sender: TObject);
var
  selecttown:integer;
begin
  selecttown:=PDBThreeNodeInfo(Tv_Area.Selected.Data).layer;
  with Fm_MainForm.PublicParam  do
  begin
  if userid=0 then
    case selecttown of
    0:PopupCityVisible;
    1:PopupCountyVisible;
    2:popupNoVisible;
    3:PopupBranchVisible;
    else popupAllNoVisible;
    end
  else
   begin
    if (cityid=0) and (areaid=0) then  //省级
        case selecttown of
        0:PopupCityVisible;
        1:PopupCountyVisible;
        2:popupNoVisible;
        else popupAllNoVisible;
        end
    else if (cityid<>0) and (areaid=0) then   //地市级
        case selecttown of
        0:popupAllNoVisible;
        1:popupAddCounty;
        2:popupModifyCounty;
        else popupAllNoVisible;
        end
    else if (cityid<>0) and (areaid<>0) then  //郊县级
        popupAllNoVisible;
   end;
  end;

end;

procedure TFm_CityManager.popupAddCounty;
begin
 N1.Visible:=false;
 N2.Visible:=false;
 N3.Visible:=false;
 N4.Visible:=true;
 N5.Visible:=false;
 N6.Visible:=false;
end;

procedure TFm_CityManager.popupAllNoVisible;
begin
 N1.Visible:=false;
 N2.Visible:=false;
 N3.Visible:=false;
 N4.Visible:=false;
 N5.Visible:=false;
 N6.Visible:=false;
 N7.visible:=False;
 N8.visible:=False;
 N9.visible:=False;
end;

procedure TFm_CityManager.PopupBranchVisible;
begin
  N1.Visible:=false;
  N2.Visible:=false;
  N3.Visible:=false;
  N4.Visible:=false;
  N5.Visible:=false;
  N6.Visible:=false;
  N7.visible:=False;
  N8.visible:=true;
  N9.visible:=true;
end;

procedure TFm_CityManager.PopupCityVisible;
begin
 N1.Visible:=true;
 N2.Visible:=false;
 N3.Visible:=false;
 N4.Visible:=false;
 N5.Visible:=false;
 N6.Visible:=false;
 N7.visible:=False;
 N8.visible:=False;
 N9.visible:=False;
end;

procedure TFm_CityManager.PopupCountyVisible;
begin
 N1.Visible:=false;
 N2.Visible:=true;
 N3.Visible:=true;
 N4.Visible:=true;
 N5.Visible:=false;
 N6.Visible:=false;
 N7.visible:=False;
 N8.visible:=False;
 N9.visible:=False;
end;

procedure TFm_CityManager.popupModifyCounty;
begin
 N1.Visible:=false;
 N2.Visible:=false;
 N3.Visible:=false;
 N4.Visible:=false;
 N5.Visible:=true;
 N6.Visible:=true;
 N7.visible:=False;
 N8.visible:=False;
 N9.visible:=False;
end;

procedure TFm_CityManager.popupNoVisible;
begin
 N1.Visible:=false;
 N2.Visible:=false;
 N3.Visible:=false;
 N4.Visible:=false;
 N5.Visible:=true;
 N6.Visible:=true;
 N7.visible:=true;
 N8.visible:=False;
 N9.visible:=False;
end;

end.
