unit Frm_building_info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, BaseGrid, AdvGrid, ExtCtrls, DB, DBClient, Buttons,
  ComCtrls, ImgList, ToolWin,jpeg,AdvGridUnit,DBThreeStateTree, StringUtils;

type
  TCommonObj = class
    ID : integer;
    Name : String;
  end;
  Tfm_building_info = class(TForm)
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ButtonModify: TButton;
    Button2: TButton;
    ButtonAdd: TButton;
    Edit1: TEdit;
    EditAreaSize: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    ComboBoxSuburb: TComboBox;
    OpenDialog1: TOpenDialog;
    ComboBoxNetType: TComboBox;
    ComboBoxConType: TComboBox;
    ComboBoxBuildingType: TComboBox;
    EditFloorCount: TEdit;
    EditAddress: TEdit;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    AdvStringGrid1: TAdvStringGrid;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButtonReturn: TToolButton;
    ToolButtonDel: TToolButton;
    ImageList1: TImageList;
    Panel4: TPanel;
    ButtonConfirm: TButton;
    GroupBox4: TGroupBox;
    ImageLogo: TImage;
    ToolButtonBefore: TToolButton;
    ToolButtonAfter: TToolButton;
    ToolButtonLoad: TToolButton;
    ComboBoxFac: TComboBox;
    Label12: TLabel;
    EditBUILDINGNO: TEdit;
    Bt_Del: TButton;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    ComboBoxAgentCompany: TComboBox;
    procedure ButtonModifyClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageLogoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageLogoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageLogoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ButtonConfirmClick(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButtonReturnClick(Sender: TObject);
    procedure ToolButtonDelClick(Sender: TObject);
    procedure ToolButtonBeforeClick(Sender: TObject);
    procedure ToolButtonAfterClick(Sender: TObject);
    procedure ToolButtonLoadClick(Sender: TObject);
    procedure ImputFloat(Sender: TObject; var Key: Char);
    procedure ImputNum(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bt_DelClick(Sender: TObject);
    procedure Edit4Exit(Sender: TObject);
  private
    N,M,T,L:integer;
    lFilename:string;
    CanMove : boolean;
    X1, Y1 : integer;
    FAdvGridSet:TAdvGridSet; 
    lbuildingID:integer;
    procedure AddPicFromLocal(LocalFileName:string);
    procedure fangdasuoxiao(I:extended);
    function ShowPicByStrlistItemIndex(lindex:integer):boolean;
    function GetFileName(lFilename:string):string;
    function  DeleteByBulidingID(lid:integer):boolean;
    procedure SaveToGrid(aGrid:TAdvStringGrid;aID:integer;aRow:integer=-1);
    procedure LoadFromGrid(aGrid:TAdvStringGrid;aRow :integer);
    function GetNetType:integer;
    procedure SetTitle;
  public
    procedure RefreshBuilding(aCondition :String);
    procedure UIChangeNormal;
    procedure ClearInfo;
    procedure ShowPicCount(l:integer; lstrlist:tstringlist);
    procedure SetControl(IsEdit:Boolean);
  end;

var
  fm_building_info: Tfm_building_info;
  OperateFlag:integer;
  PicStringlist:Tstringlist;
  StrListIndex:integer;

implementation

uses Ut_DataModule, Ut_Common, Ut_MTSTreeHelper, Ut_MainForm;

{$R *.dfm}

procedure Tfm_building_info.ClearInfo;
var
  i : integer;
begin
  for I := 0 to GroupBox3.ControlCount - 1 do
  begin
    if (GroupBox3.Controls[i] is TEdit) then
      (GroupBox3.Controls[i] as TEdit).Text :=''
    else if(GroupBox3.Controls[i] is TComboBox) then
      (GroupBox3.Controls[i] as TComboBox).ItemIndex :=-1
    else if (GroupBox3.Controls[i] is TMemo) then
      (GroupBox3.Controls[i]as TMemo).Text :='';
  end;
end;

procedure Tfm_building_info.RefreshBuilding(aCondition: String);
begin
  with Dm_MTS.cds_common do                                     
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,19,aCondition]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvStringGrid1);
    if recordcount>0 then
    begin
      //AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
      AdvStringGrid1.ColWidths[1]:=0;
      AdvStringGrid1.ColWidths[14]:=0;
    end;
  end;
end;

procedure Tfm_building_info.SaveToGrid(aGrid: TAdvStringGrid; aID,
  aRow: integer);
var
  lRow:integer;
begin
  if aRow=-1 then
  begin
    lRow:=aGrid.Row;
  end
  else if aRow>0 then
  begin
    lRow:=aRow;
    aGrid.RowCount:=lRow+1;
  end
  else exit;
  aGrid.Rows[lRow].Strings[0]:=inttostr(lRow);
  aGrid.Rows[lRow].Strings[1]:=inttostr(aID);
  aGrid.Rows[lRow].Strings[2]:=EditBUILDINGNO.Text;
  aGrid.Rows[lRow].Strings[3]:=Edit1.Text;
  aGrid.Rows[lRow].Strings[4]:=EditAddress.Text;
  aGrid.Rows[lRow].Strings[5]:=Edit3.Text;
  aGrid.Rows[lRow].Strings[6]:=Edit4.Text;
  aGrid.Rows[lRow].Strings[7]:=ComboBoxNetType.Text;
  aGrid.Rows[lRow].Strings[8]:=ComboBoxFac.Text;
  aGrid.Rows[lRow].Strings[9]:=ComboBoxConType.Text;
  aGrid.Rows[lRow].Strings[10]:=ComboBoxBuildingType.Text;
  aGrid.Rows[lRow].Strings[11]:=EditFloorCount.Text;
  aGrid.Rows[lRow].Strings[12]:=EditAreaSize.Text;
  aGrid.Rows[lRow].Strings[13]:=ComboBoxSuburb.Text;
  aGrid.Rows[lRow].Strings[14]:=inttostr(GetDicCode(ComboBoxSuburb.Text,ComboBoxSuburb.Items));
  aGrid.Rows[lRow].Strings[15]:=ComboBoxAgentCompany.Text;
  aGrid.Row:=lRow;
end;

procedure Tfm_building_info.SetControl(IsEdit: Boolean);
var
  i : integer;
begin
  for I := 0 to GroupBox3.ControlCount - 1 do
  begin
    if (GroupBox3.Controls[i] is TEdit) or (GroupBox3.Controls[i] is TComboBox)
      or (GroupBox3.Controls[i] is TMemo) then
        GroupBox3.Controls[i].Enabled := IsEdit;
  end;
  ButtonConfirm.Enabled :=IsEdit;
  Bt_Del.Enabled :=not(IsEdit);
end;

procedure Tfm_building_info.SetTitle;
var
  I: Integer;
begin
  AdvStringGrid1.ColCount := 16;
  AdvStringGrid1.RowCount := 2;
  AdvStringGrid1.Rows[0].Strings[1] := '';
  AdvStringGrid1.Rows[0].Strings[2] := '室分点编号';
  AdvStringGrid1.Rows[0].Strings[3] := '室分点名称';
  AdvStringGrid1.Rows[0].Strings[4] := '地址';
  AdvStringGrid1.Rows[0].Strings[5] := '经度';
  AdvStringGrid1.Rows[0].Strings[6] := '纬度';
  AdvStringGrid1.Rows[0].Strings[7] := '所属网络类型';
  AdvStringGrid1.Rows[0].Strings[8] := '集成厂商';
  AdvStringGrid1.Rows[0].Strings[9] := '接入方式';
  AdvStringGrid1.Rows[0].Strings[10] := '室分点类型';
  AdvStringGrid1.Rows[0].Strings[11] := '楼层数目';
  AdvStringGrid1.Rows[0].Strings[12] := '楼层面积';
  AdvStringGrid1.Rows[0].Strings[13] := '所属分局';
  AdvStringGrid1.Rows[0].Strings[14] := '';
  AdvStringGrid1.Rows[0].Strings[15] := '代维公司';
  //AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
  AdvStringGrid1.ColWidths[1]:=0;
  AdvStringGrid1.ColWidths[14]:=0;
  for I := 0 to AdvStringGrid1.ColCount - 1 do
  begin
    if (i<>1) and (i<>14) then
      AdvStringGrid1.AutoSizeCol(i);
  end;
end;

function  Tfm_building_info.DeleteByBulidingID(lid:integer):boolean;
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
  I: integer;
  lcount:integer;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,17,lid]),0);
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
    application.MessageBox('保存失败，请检查后重试！', '提示', mb_ok);
  end;
end;

procedure Tfm_building_info.Edit4Exit(Sender: TObject);
var
  lValue: string;
begin
  lValue:= TEdit(Sender).Text;
  if lValue='' then exit;
  try
    strtofloat(lValue);
  except
    application.MessageBox('请输入有效数字！','提示',MB_OK );
    TEdit(Sender).Text:= '';
  end;
end;

procedure Tfm_building_info.AddPicFromLocal(LocalFileName: string);
begin
  ImageLogo.Picture.LoadFromFile(LocalFileName);
end;

procedure Tfm_building_info.AdvStringGrid1Click(Sender: TObject);
var
  lstream:tmemorystream;
  PicField : TBLOBField;
  vsucces:boolean;
  MiniFileName:string;
  linteger:integer;
begin
  PicStringlist.Clear;
  if (ButtonModify.Tag=1) or (ButtonAdd.Tag=1) then
//    if application.MessageBox('正在进行其他操作，是否取消该操作?', '提示', mb_okcancel + mb_defbutton1) = idCancel then
      exit
    else
      UIChangeNormal;

  if AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]='' then
    exit;
  try
    begin
    Screen.Cursor := crHourGlass;
    LoadFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
    vsucces := true;
    
    
    if vsucces then
    begin
      with Dm_MTS.cds_common do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,14,strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1])]),0);
        while not eof do
        begin
          PicField := TBLOBField(FieldByName('picture'));
          lstream:=tmemorystream.Create;
          PicField.SaveToStream(lstream);
          lstream.Position:=0;
          MiniFileName:=FieldByName('picname').AsString;
          PicStringlist.AddObject(MiniFileName,lstream);
          next;
        end;
      end;
    end;
    StrListIndex:=PicStringlist.Count-1;
    if not ShowPicByStrlistItemIndex(StrListIndex) then
    begin
      ImageLogo.Picture.Bitmap.Assign(nil);
      StrListIndex:=PicStringlist.Count;
      ShowPicCount(0,PicStringlist);
    end
    else
      ShowPicCount(StrListIndex+1,PicStringlist);

    if PicStringlist.Count=1 then
      ToolButtonBefore.Enabled:=false
    else
      ToolButtonBefore.Enabled:=true;

    ToolButtonAfter.Enabled:=false;

    SetControl(false);
    ToolButtonLoad.Enabled:=false;
    ToolButtonDel.Enabled:=false;
    end;
  finally
    Screen.Cursor := crDefault ;
  end;
end;

procedure Tfm_building_info.ButtonConfirmClick(Sender: TObject);
var
  lsuccess:boolean;
  PicField:TBlobField;
  I: integer;
  lstream:tmemorystream;
  PicFlowNum:integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if (Edit1.Text='') or (self.EditBUILDINGNO.Text='')
      or (ComboBoxSuburb.ItemIndex<0) or (ComboBoxNetType.ItemIndex<0)
      or (ComboBoxBuildingType.ItemIndex<0) or (self.EditAddress.Text='')
      or (ComboBoxFac.ItemIndex<0)
  then
  begin
    Application.MessageBox('请详细添加信息','提示',MB_OK);
    Exit;
  end;
  if OperateFlag<>ADDFLAG then
  begin
    lbuildingID:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
    if IsExists('building_info','buildingno',EditBUILDINGNO.Text,'buildingid',lbuildingID) then
    begin
      application.MessageBox('室分点编号不能重复！', '提示', mb_ok);
      exit;
    end;
    if IsExists('building_info','buildingname',edit1.Text,'buildingid',lbuildingID) then
    begin
      application.MessageBox('室分点名称不能重复！', '提示', mb_ok);
      exit;
    end;
  end else
  begin
    if IsExists('building_info','buildingno',EditBUILDINGNO.Text) then
    begin
      application.MessageBox('室分点编号不能重复！', '提示', mb_ok);
      exit;
    end;
    if IsExists('building_info','buildingname',edit1.Text) then
    begin
      application.MessageBox('室分点名称不能重复！', '提示', mb_ok);
      exit;
    end;
  end;




  try
    Screen.Cursor := crHourGlass;
    lsuccess:=false;
    with Dm_MTS.cds_common1 do
    begin
      close;
      ProviderName:='dsp_General_data1';
      if OperateFlag=ADDFLAG then
      begin
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,2,0]),1);
        lbuildingID:=Dm_MTS.TempInterface.ProduceFlowNumID('BUILDINGID',1);
        if lbuildingID=-1 then
        begin
          application.MessageBox('连接数据库失败，请检查后重试！', '提示', mb_ok);
          exit;
        end;
        Append;
        FieldByName('buildingid').Value    :=  lbuildingID ;
      end
      else
      begin
        lbuildingID:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,16,lbuildingID]),1);
        Edit;
      end;
      FieldByName('buildingno').AsString    :=  EditBUILDINGNO.Text ;
      FieldByName('buildingname').AsString  :=  Edit1.Text ;
      FieldByName('address').AsString       :=  EditAddress.Text ;
      FieldByName('longitude').AsString     :=  Edit3.Text ;
      FieldByName('latitude').AsString      :=  Edit4.Text ;
      FieldByName('areaid').Value           :=  GetDicCode(ComboBoxSuburb.Text,ComboBoxSuburb.Items);
      FieldByName('nettype').Value          :=  GetNetType;
      FieldByName('factory').Value          :=  GetDicCode(ComboBoxFac.Text,ComboBoxFac.Items);
      FieldByName('connecttype').Value      :=  GetDicCode(ComboBoxConType.Text,ComboBoxConType.Items);
      FieldByName('buildingtype').Value     :=  GetDicCode(ComboBoxBuildingType.Text,ComboBoxBuildingType.Items);
      FieldByName('floorcount').AsString    :=  EditFloorCount.Text;
      FieldByName('buildingarea').AsString  :=  EditAreaSize.Text;
      FieldByName('agentcompany').Value  :=  GetDicCode(ComboBoxAgentCompany.Text,ComboBoxAgentCompany.Items);
      Post;
      try
        vCDSArray[0]:=Dm_MTS.cds_common1;
        vDeltaArray:=RetrieveDeltas(vCDSArray);
        vProviderArray:=RetrieveProviders(vCDSArray);
        if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
          SysUtils.Abort
        else
          lsuccess:=true;
      except
        application.MessageBox('保存失败，请检查后重试！', '提示', mb_ok);
      end;
    end;

    if lsuccess then                                      //增加图片入库
    begin
      DeleteByBulidingID(lbuildingID);                     //删除已有图片

      if PicStringlist.Count>0 then
      begin
        Try
          for I := 0 to PicStringlist.Count - 1 do
            begin
              PicField := Tblobfield.Create(nil);
              PicFlowNum:=Dm_MTS.TempInterface.ProduceFlowNumID('PICID',1);
              if PicFlowNum=-1 then
                begin
                  application.MessageBox('连接数据库失败，请检查后重试！', '提示', mb_ok);
                  exit;
                end;
              with Dm_MTS.cds_common1 do
              begin
                close;
                ProviderName:='dsp_General_data1';
                Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,8,0]),1);
                append;
                FieldByName('picid').Value := PicFlowNum;
                FieldByName('picname').Value := PicStringlist.Strings[i];
                FieldByName('picorder').Value := i+1;

                lstream:=tmemorystream(PicStringlist.Objects[i]);
                lstream.Position:=0;
                PicField:=TBlobField(Fieldbyname('picture'));
                PicField.LoadFromStream(lstream);

                FieldByName('pictype').Value :=   1;
                if OperateFlag=MODIFYFLAG then
                  FieldByName('outid').Value:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1])
                else if OperateFlag=ADDFLAG then
                  FieldByName('outid').Value :=  lbuildingID;

                post;
                try
                  vCDSArray[0]:=Dm_MTS.cds_common1;
                  vDeltaArray:=RetrieveDeltas(vCDSArray);
                  vProviderArray:=RetrieveProviders(vCDSArray);
                  if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
                    SysUtils.Abort;
                except
                  application.MessageBox('添加图片失败!！', '提示', mb_ok + mb_defbutton1);
                end;
              end;
            end;
        except

        end;
      end;
      application.MessageBox('保存成功！', '提示', mb_ok);
      //提供手动添加单条记录，不提供全部刷新
      if OperateFlag=ADDFLAG then
        if (AdvStringGrid1.RowCount=2) and (AdvStringGrid1.Rows[1].strings[1]='') then//判断是否无记录
          SaveToGrid(AdvStringGrid1,lbuildingID,1)
        else
          SaveToGrid(AdvStringGrid1,lbuildingID,AdvStringGrid1.RowCount)
      else
        SaveToGrid(AdvStringGrid1,lbuildingID);
    end;
    UIChangeNormal;
  finally
    Screen.Cursor := crDefault ;
  end;
end;

procedure Tfm_building_info.Bt_DelClick(Sender: TObject);
begin
  if (HasChild(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),56))      //Switch
    or (HasChild(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),57))    //CS
    or (HasChild(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),58))   //mtu
  then
  begin
    application.MessageBox('无法删除,请保证其下已不存在其他资源！', '提示', mb_ok);
    exit;
  end;
  if application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+mb_defbutton1)=IDOK then
  begin
    if (DelFromGrid(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),13))
      and (DelFromGrid(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),14)) then
    begin
        application.MessageBox('操作成功！', '提示', mb_ok);
        DeleteFromGrid(self.AdvStringGrid1,AdvStringGrid1.Row);
    end
      else  application.MessageBox('操作失败！', '提示', mb_ok);
  end;
end;

procedure Tfm_building_info.Button2Click(Sender: TObject);
begin
  close;
end;

procedure Tfm_building_info.ButtonAddClick(Sender: TObject);
begin
  PicStringlist.Clear;
  ImageLogo.Picture.Bitmap.Assign(nil);

  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    ClearInfo;
    OperateFlag := ADDFLAG;
    ButtonModify.Enabled := false;

    PicStringlist.Clear;
    ImageLogo.Picture.Bitmap.Assign(nil);
    StrListIndex:=0;
    ShowPicCount(StrListIndex,PicStringlist);

    ToolButtonLoad.Enabled:=true;
    ToolButtonDel.Enabled:=true;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='新增';
    SetControl(false);
    OperateFlag := CANCELFLAG;
    ButtonModify.Enabled := true;
  end;
end;

procedure Tfm_building_info.ButtonModifyClick(Sender: TObject);
begin
  if (Edit1.Text='') and (ButtonModify.Tag=0) then
  begin
    application.MessageBox('请选择要修改的室分点!','提示',mb_ok);
    exit;
  end;
  
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    OperateFlag := MODIFYFLAG;
    ButtonAdd.Enabled := false;

    ToolButtonLoad.Enabled:=true;
    ToolButtonDel.Enabled:=true;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='修改';
    SetControl(false);
    OperateFlag := CANCELFLAG;
    ButtonAdd.Enabled := true;
  end;
end;

procedure Tfm_building_info.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  ClearTStrings(ComboBoxSuburb.Items);
  ClearTStrings(ComboBoxNetType.Items);
  ClearTStrings(ComboBoxConType.Items);
  ClearTStrings(ComboBoxBuildingType.Items);
  ClearTStrings(ComboBoxFac.Items);
  FAdvGridSet.Free;
  PicStringlist.Free;

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  fm_building_info:=nil;
end;

procedure Tfm_building_info.FormCreate(Sender: TObject);

begin
  PicStringlist:=TStringlist.Create;

  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(self.AdvStringGrid1);
  FAdvGridSet.SetGridStyle;

  StrListIndex:=0;

  M:=ImageLogo.Height;
  N:=ImageLogo.Width;
  T:=ImageLogo.Top;
  L:=ImageLogo.Left;
end;

procedure Tfm_building_info.FormShow(Sender: TObject);
begin
  GetDic(2,ComboBoxBuildingType.Items);
  GetDic(3,ComboBoxFac.Items);
  GetDic(4,ComboBoxConType.Items);
  GetDic(33,ComboBoxAgentCompany.Items);
  ComboBoxNetType.ItemIndex:=-1;
  ComboBoxConType.ItemIndex:=-1;
  ComboBoxBuildingType.ItemIndex:=-1;
  ComboBoxFac.ItemIndex:=-1;
  ComboBoxAgentCompany.ItemIndex:= -1;
  LoadSuburb(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxSuburb.Items);
  SetTitle;
end;

procedure Tfm_building_info.ImageLogoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if self.ImageLogo.Cursor=crHandPoint then
  begin
    CanMove := True;
    X1 := X;
    Y1 := Y;
  end;
end;

procedure Tfm_building_info.ImageLogoMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if CanMove then
  begin
  ImageLogo.Left := ImageLogo.Left + X - X1;
  ImageLogo.Top := ImageLogo.Top + Y - Y1;
  X1 := X;
  Y1 := Y;
  end;
end;

procedure Tfm_building_info.ImageLogoMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CanMove := False;
end;

procedure Tfm_building_info.ImputFloat(Sender: TObject; var Key: Char);
var
  lstr:string;
  i:integer;
begin
  InPutfloat(Key);
  lstr:=TEdit(sender).Text;
  if (key='.') and (lstr<>'') then
  begin
    for I := 0 to length(lstr) do
      if lstr[i]='.' then
      begin
        key:=#0;
        break;
      end;
  end
  else if  (key='.') and (lstr='') then
    key:=#0;
end;

procedure Tfm_building_info.ImputNum(Sender: TObject; var Key: Char);
begin
  InPutNum(Key);
end;

procedure Tfm_building_info.LoadFromGrid(aGrid: TAdvStringGrid; aRow: integer);
begin
  EditBUILDINGNO.Text          := aGrid.Rows[aRow].Strings[2];
  Edit1.Text                   := aGrid.Rows[aRow].Strings[3];
  EditAddress.Text             := aGrid.Rows[aRow].Strings[4];
  Edit3.Text                   := aGrid.Rows[aRow].Strings[5];
  Edit4.Text                   := aGrid.Rows[aRow].Strings[6];
  ComboBoxNetType.ItemIndex    := ComboBoxNetType.Items.IndexOf(aGrid.Rows[aRow].Strings[7]);
  if ComboBoxNetType.ItemIndex=-1 then
    ComboBoxNetType.Text := aGrid.Rows[aRow].Strings[7];
  ComboBoxFac.ItemIndex        := ComboBoxFac.Items.IndexOf(aGrid.Rows[aRow].Strings[8]);
  if ComboBoxFac.ItemIndex=-1 then
    ComboBoxFac.Text := aGrid.Rows[aRow].Strings[8];
  ComboBoxConType.ItemIndex    := ComboBoxConType.Items.IndexOf(aGrid.Rows[aRow].Strings[9]);
  if ComboBoxConType.ItemIndex=-1 then
    ComboBoxConType.Text := aGrid.Rows[aRow].Strings[9];
  ComboBoxBuildingType.ItemIndex := ComboBoxBuildingType.Items.IndexOf(aGrid.Rows[aRow].Strings[10]);
  if ComboBoxBuildingType.ItemIndex=-1 then
    ComboBoxBuildingType.Text := aGrid.Rows[aRow].Strings[10];
  EditFloorCount.Text          := aGrid.Rows[aRow].Strings[11];
  EditAreaSize.Text            := aGrid.Rows[aRow].Strings[12];
  ComboBoxSuburb.ItemIndex     := ComboBoxSuburb.Items.IndexOf(aGrid.Rows[aRow].Strings[13]);
  if ComboBoxSuburb.ItemIndex=-1 then
    ComboBoxSuburb.Text := aGrid.Rows[aRow].Strings[13];
  ComboBoxAgentCompany.ItemIndex:= ComboBoxAgentCompany.Items.IndexOf(aGrid.Rows[aRow].Strings[15]);
  if ComboBoxAgentCompany.ItemIndex=-1 then
    ComboBoxAgentCompany.Text := aGrid.Rows[aRow].Strings[15];
end;

procedure Tfm_building_info.ToolButtonReturnClick(Sender: TObject);
begin
  ImageLogo.Height:=m;
  ImageLogo.Width:=N;
  ImageLogo.Top:=T;
  ImageLogo.Left:=L;
end;

procedure Tfm_building_info.UIChangeNormal;
begin
  if ButtonAdd.Tag=1 then
    ButtonAddClick(ButtonAdd);
  if ButtonModify.Tag=1 then
    ButtonModifyClick(ButtonModify);
end;

procedure Tfm_building_info.ToolButton2Click(Sender: TObject);
begin
  fangdasuoxiao(2);
end;

procedure Tfm_building_info.ToolButton3Click(Sender: TObject);
begin
  fangdasuoxiao(-2);
end;

procedure Tfm_building_info.ToolButton4Click(Sender: TObject);
begin
  if ImageLogo.Cursor=crHandPoint then
  ImageLogo.Cursor:=crDefault else
  ImageLogo.Cursor:=crHandPoint;
end;

procedure Tfm_building_info.ToolButtonLoadClick(Sender: TObject);
var
  lstream:tmemorystream;
  MiniFileName:string;
begin
  opendialog1.Filter :='图片文件(*.jpg)|*.jpg|图片文件(*.jpeg)|*.jpeg';
  opendialog1.Title := '加载图片';
  if OpenDialog1.Execute then
  begin
    lFilename:=OpenDialog1.FileName;
    AddPicFromLocal(lFilename);

    lstream:=tmemorystream.Create;
    lstream.LoadFromFile(lFilename);
    lstream.Position:=0;

    MiniFileName:=GetFileName(lFilename);
    PicStringlist.AddObject(MiniFileName,lstream);

    StrListIndex:=PicStringlist.Count-1;
    ShowPicByStrlistItemIndex(StrListIndex);
    ShowPicCount(StrListIndex+1,PicStringlist);

    //ToolButtonDel.Enabled:=true;
    if PicStringlist.Count=1 then
      ToolButtonBefore.Enabled:=false
    else
      ToolButtonBefore.Enabled:=true;
    ToolButtonAfter.Enabled:=false;
  end
  else
  exit;
end;

procedure Tfm_building_info.ToolButtonDelClick(Sender: TObject);
begin
  if PicStringlist.Count>0 then
  begin
    try
      tmemorystream(PicStringlist.Objects[StrListIndex]).Free;
      PicStringlist.Delete(StrListIndex);
    except
      application.MessageBox('删除失败！', '提示', mb_ok);
      exit;
    end;
    if ShowPicByStrlistItemIndex(PicStringlist.Count-1) then
    begin
      StrListIndex:=PicStringlist.Count-1;
      ShowPicCount(StrListIndex+1,PicStringlist);

      if  StrListIndex>0 then
        ToolButtonBefore.Enabled:=true
      else
        ToolButtonBefore.Enabled:=false;

      if  StrListIndex<PicStringlist.Count-1 then
        ToolButtonAfter.Enabled:=true
      else
        ToolButtonAfter.Enabled:=false;
    end
    else
    begin
      ImageLogo.Picture.Bitmap.Assign(nil);
      StrListIndex:=0;
      ShowPicCount(StrListIndex,PicStringlist);
    end;
  end;
end;

procedure Tfm_building_info.ToolButtonBeforeClick(Sender: TObject);
begin
  if ShowPicByStrlistItemIndex(StrListIndex-1) then
  dec(StrListIndex)
  else
  ShowPicByStrlistItemIndex(StrListIndex);
  ShowPicCount(StrListIndex+1,PicStringlist);

  if  StrListIndex>0 then
     ToolButtonBefore.Enabled:=true
   else
     ToolButtonBefore.Enabled:=false;

   if  StrListIndex<PicStringlist.Count-1 then
     ToolButtonAfter.Enabled:=true
   else
     ToolButtonAfter.Enabled:=false;
end;

procedure Tfm_building_info.ToolButtonAfterClick(Sender: TObject);
begin
  if ShowPicByStrlistItemIndex(StrListIndex+1) then
    inc(StrListIndex)
  else
  ShowPicByStrlistItemIndex(StrListIndex);
  ShowPicCount(StrListIndex+1,PicStringlist);

   if  StrListIndex>0 then
     ToolButtonBefore.Enabled:=true
   else
     ToolButtonBefore.Enabled:=false;

   if  StrListIndex<PicStringlist.Count-1 then
     ToolButtonAfter.Enabled:=true
   else
     ToolButtonAfter.Enabled:=false;
end;

procedure Tfm_building_info.fangdasuoxiao(I:extended);
begin
  if I>0 then
    BEGIN
      self.ImageLogo.Width:=ImageLogo.Width*trunc(i);
      self.ImageLogo.Height:=ImageLogo.Height*trunc(i);
    END
    ELSE
    BEGIN
      ImageLogo.Width:=ImageLogo.Width div trunc(abs(i));
      ImageLogo.Height:=ImageLogo.Height div trunc(abs(i));
    END;
end;
function Tfm_building_info.ShowPicByStrlistItemIndex(lindex:integer):boolean;
var
  lstream:tmemorystream;
  MyJPEG:TJPEGImage;
begin
  result:=false;
  if (PicStringlist.Count>0) and (lindex>-1) and (lindex<PicStringlist.Count) then
  begin
    try
    lstream:=tmemorystream(PicStringlist.Objects[lindex]);
    lstream.Position:=0;
    MyJPEG := TJPEGImage.Create;
    MyJPEG.LoadFromStream(lstream);
    ImageLogo.Picture.Bitmap.Assign(MyJPEG);
    result:=true;
    except

    end;
  end;
end;
procedure Tfm_building_info.ShowPicCount(l: integer; lstrlist: tstringlist);
begin
  GroupBox4.Caption:='网络拓扑图   第'+inttostr(l)+'页/'+'共'+inttostr(lstrlist.Count)+'页';
end;

function Tfm_building_info.GetFileName(lFilename:string):string;
var
  I: Integer;
  lstart,lend:integer;
begin
  for I := length(lFilename)-1 downto 0 do
  begin
    if lFilename[i]='.' then
      lend:=i;
    if lFilename[i]='\' then
    begin
      lstart:=i;
      break;
    end;
  end;
  result:=copy(lFilename,lstart+1,lend-lstart-1);
end;


function Tfm_building_info.GetNetType: integer;
begin
  result := -1;
  if ComboBoxNetType.Text='WLAN' then
    result := 2
  else if ComboBoxNetType.Text='PHS' then
    result := 1
  else if ComboBoxNetType.Text='CDMA' then
    result := 4
  else if ComboBoxNetType.Text='WLAN+PHS' then
    result := 3
  else if ComboBoxNetType.Text='WLAN+CDMA' then
    result := 6
  else if ComboBoxNetType.Text='PHS+CDMA' then
    result := 5
  else if ComboBoxNetType.Text='WLAN+PHS+CDMA' then
    result := 7;
end;

end.
