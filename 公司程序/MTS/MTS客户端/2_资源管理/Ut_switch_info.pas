unit Ut_switch_info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid, ExtCtrls, StdCtrls ,DBThreeStateTree ,AdvGridUnit,
  ComCtrls, DBClient, cxGraphics, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit,StringUtils;

type
  TFrm_switch_info = class(TForm)
    Splitter1: TSplitter;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    AdvStringGrid1: TAdvStringGrid;
    Label5: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    ButtonModify: TButton;
    Button2: TButton;
    ButtonAdd: TButton;
    ButtonConfirm: TButton;
    EditName: TEdit;
    EditAddress: TEdit;
    EditAddress2: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditPort: TEdit;
    EditPOP: TEdit;
    Bt_Del: TButton;
    Label13: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ButtonClear: TButton;
    ComboBoxBuilding: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonModifyClick(Sender: TObject);
    procedure ButtonConfirmClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bt_DelClick(Sender: TObject);
  private
    { Private declarations }
    FAreaID:integer;
    Flayer:integer;
    Tv_Area : TDBThreeStateTree;
    FAdvGridSet:TAdvGridSet;
    function  GetAreaIDByLayer(llayer, lareaid: integer): string;
    procedure SetIndexFromData(Box:TComboBox;lvalue:integer);
    procedure LoadFromGrid(aGrid:TAdvStringGrid;aRow :integer);
    procedure SetTitle;
    procedure SaveToGrid(aGrid:TAdvStringGrid;aID:integer;aRow:integer=-1);
    function HasExist(aSwitchno:string;aSwitchid:integer=-1):boolean;
  public
    procedure UIChangeNormal;
    procedure ClearInfo;
    procedure SetControl(IsEdit:Boolean);
    procedure RefreshBuilding(aCondition :String);
  end;

var
  Frm_switch_info: TFrm_switch_info;
  OperateFlag:integer;
implementation

uses Ut_MainForm, Ut_Common, Ut_DataModule;

{$R *.dfm}

procedure TFrm_switch_info.AdvStringGrid1Click(Sender: TObject);
var
  Fbuildingid:integer;
begin
  if (ButtonModify.Tag=1) or (ButtonAdd.Tag=1) then
   // if application.MessageBox('正在进行其他操作，是否取消该操作?', '提示', mb_okcancel + mb_defbutton1) = idCancel then
    exit
  else
    UIChangeNormal;
  if AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]='' then
    exit;
  LoadFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
end;

procedure TFrm_switch_info.Bt_DelClick(Sender: TObject);
begin
  if HasChild(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),59) then
  begin
    application.MessageBox('无法删除,请保证其下已不存在其他资源！', '提示', mb_ok);
    exit;
  end;
  if application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+mb_defbutton1)=IDOK then
  begin
    if DelFromGrid(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),23) then
    begin
      application.MessageBox('操作成功！', '提示', mb_ok);
      DeleteFromGrid(self.AdvStringGrid1,AdvStringGrid1.Row);
      ClearInfo;
    end
    else
      application.MessageBox('操作失败！', '提示', mb_ok);
  end;
end;

procedure TFrm_switch_info.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFrm_switch_info.ButtonAddClick(Sender: TObject);
begin
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    OperateFlag := ADDFLAG;
    ButtonModify.Enabled := false;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='新增';
    SetControl(false);
    OperateFlag := CANCELFLAG;
    ButtonModify.Enabled := true;
  end;
  ClearInfo;
end;

procedure TFrm_switch_info.ButtonConfirmClick(Sender: TObject);
var
  fswitchid:integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
  i:integer;
begin
  if (Editname.Text='') or (EditAddress.Text='') or (ComboBoxBuilding.ItemIndex<0)
  then
  begin
    Application.MessageBox('请完善必填项','提示',MB_OK);
    Exit;
  end;

  try
  begin
    Screen.Cursor := crHourGlass;
    with Dm_MTS.cds_common do
    begin
      if OperateFlag=addflag then
      begin
        if HasExist(EditName.Text) then
        begin
          application.MessageBox(pchar('已经存在C网信源编号['+EditName.Text+']！'), '提示', mb_ok);
          exit;
        end;
        fswitchid:=Dm_MTS.TempInterface.ProduceFlowNumID('SWITCHID',1);
        if fswitchid=-1 then
        begin
          application.MessageBox('连接数据库失败，请检查后重试！', '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,25,0]),0);
        append;
        FieldByName('SWITCHID').Value    :=  fswitchid ;
      end
      else if OperateFlag=Modifyflag then
      begin
        fswitchid:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
        if HasExist(EditName.Text,fswitchid) then
        begin
          application.MessageBox(pchar('已经存在C网信源编号['+EditName.Text+']！'), '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,23,fswitchid]),0);
        edit;
      end;
      FieldByName('SWITCHNO').Value    :=  EditName.Text ;
      FieldByName('MACADDR').Value    :=  EditAddress.Text ;
      FieldByName('MANAGEADDR').Value    :=  EditAddress2.Text ;
      FieldByName('UPLINKPORT').Value    :=  EditPort.Text ;
      FieldByName('POP').Value    :=  EditPOP.Text ;
      FieldByName('BUILDINGID').Value    := TCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID;
      post;
      try
        vCDSArray[0]:=Dm_MTS.cds_common;
        vDeltaArray:=RetrieveDeltas(vCDSArray);
        vProviderArray:=RetrieveProviders(vCDSArray);
        if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;
         application.MessageBox('保存成功！', '提示', mb_ok);
         if OperateFlag=ADDFLAG then
        begin
          if (AdvStringGrid1.RowCount=2) and (AdvStringGrid1.Rows[1].strings[1]='') then//判断是否无记录
            SaveToGrid(AdvStringGrid1,fswitchid,1)
          else
            SaveToGrid(AdvStringGrid1,fswitchid,AdvStringGrid1.RowCount);
        end
        else
        if OperateFlag=MODIFYFLAG then
           SaveToGrid(AdvStringGrid1,fswitchid);
         UIChangeNormal;
         ClearInfo;
      except
         application.MessageBox('保存失败，请检查后重试！', '提示', mb_ok);
      end;
    end;
  end;
  finally
    Screen.Cursor := crDefault ;
  end;
end;

procedure TFrm_switch_info.ButtonModifyClick(Sender: TObject);
begin
  if (EditName.Text='') and (ButtonModify.Tag=0) then
  begin
    application.MessageBox('请选择要修改的交换机!','提示',mb_ok);
    exit;
  end;

  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    OperateFlag := MODIFYFLAG;
    ButtonAdd.Enabled := false;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='修改';
    SetControl(false);
    OperateFlag := CANCELFLAG;
    ButtonAdd.Enabled := true;
    ClearInfo;
  end;
end;

procedure TFrm_switch_info.ClearInfo;
var
  i : integer;
begin
  for I := 0 to GroupBox3.ControlCount - 1 do
  begin
    if (GroupBox3.Controls[i] is TEdit) then
      (GroupBox3.Controls[i] as TEdit).Text :=''
//    else if(GroupBox3.Controls[i] is TComboBox) then
//      (GroupBox3.Controls[i] as TComboBox).ItemIndex :=-1
    else if (GroupBox3.Controls[i] is TMemo) then
      (GroupBox3.Controls[i]as TMemo).Text :='';
  end;
end;

procedure TFrm_switch_info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearTStrings(ComboBoxBuilding.Properties.Items);
  FAdvGridSet.Free;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Frm_switch_info:=nil;
end;

procedure TFrm_switch_info.FormCreate(Sender: TObject);
begin
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(AdvStringGrid1);
  FAdvGridSet.SetGridStyle;
  SetControl(false);
end;

procedure TFrm_switch_info.FormShow(Sender: TObject);
begin
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxBuilding.Properties.Items);
  ComboBoxBuilding.ItemIndex := -1;
  SetTitle;
end;

function TFrm_switch_info.GetAreaIDByLayer(llayer, lareaid: integer): string;
var
  lareas:string;
begin
  lareas:=inttostr(FAreaID)+',';
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if llayer=0 then
    begin
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,19,0]),0);        //省
      while not eof do
      begin
        lareas:=lareas+FieldByName('ID').AsString+',';
        next;
      end;
    end

    else if llayer=1 then                                                        //市
    begin
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,20,lareaid]),0);
      while not eof do
      begin
        lareas:=lareas+FieldByName('ID').AsString+',';
        next;
      end;
    end

    else if llayer=2 then                                                     //县
    begin
      //
    end;
  end;
  lareas:=copy(lareas,1,length(lareas)-1);
  result:=' ('+lareas+') ';
end;

function TFrm_switch_info.HasExist(aSwitchno: string;
  aSwitchid: integer): boolean;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if aSwitchid=-1 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,71,'where upper(SWITCHNO)='+quotedstr(uppercase(aSwitchno))+'']),0)
    else if aSwitchid>0 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,71,'where upper(SWITCHNO)='+quotedstr(uppercase(aSwitchno))+' and SWITCHID<>'+inttostr(aSwitchid)+'']),0);
  end;
  if Dm_MTS.cds_common.RecordCount>0 then
    result:=true
  else
    result:=false;
end;

procedure TFrm_switch_info.LoadFromGrid(aGrid: TAdvStringGrid; aRow: integer);
begin
  EditName.Text := aGrid.Rows[aRow].Strings[2];
  EditAddress.Text := aGrid.Rows[aRow].Strings[3];
  EditPort.Text := aGrid.Rows[aRow].Strings[5];
  EditAddress2.Text := aGrid.Rows[aRow].Strings[4];
  ComboBoxBuilding.ItemIndex := ComboBoxBuilding.Properties.Items.IndexOf(aGrid.Rows[aRow].Strings[7]);
  EditPOP.Text := aGrid.Rows[aRow].Strings[6];
end;

procedure TFrm_switch_info.RefreshBuilding(aCondition: String);
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,28,aCondition]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvStringGrid1);
    if recordcount>0 then
    begin
      AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
      AdvStringGrid1.ColWidths[1]:=0;
    end;
  end;
end;

procedure TFrm_switch_info.SaveToGrid(aGrid: TAdvStringGrid; aID,
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
  aGrid.Rows[lRow].Strings[2]:=EditName.Text;
  aGrid.Rows[lRow].Strings[3]:=EditAddress.Text;
  aGrid.Rows[lRow].Strings[4]:=EditAddress2.Text;
  aGrid.Rows[lRow].Strings[5]:=EditPort.Text;
  aGrid.Rows[lRow].Strings[6]:=EditPOP.Text;
  aGrid.Rows[lRow].Strings[7]:=ComboBoxBuilding.Text;
  aGrid.Rows[lRow].Strings[8]:=IntToStr(TCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID);
  aGrid.Row:=lRow;
end;

procedure TFrm_switch_info.SetControl(IsEdit: Boolean);
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

procedure TFrm_switch_info.SetIndexFromData(Box: TComboBox; lvalue: integer);
var
  i:integer;
begin
  for I := 0 to Box.Items.Count - 1 do
  if TCommonObj(Box.Items.Objects[i]).ID=lvalue then
  begin
    Box.ItemIndex:=i;
    break;
  end
  else
    Box.ItemIndex:=-1;
end;

procedure TFrm_switch_info.SetTitle;
var
  I: Integer;
begin
  AdvStringGrid1.ColCount := 9;
  AdvStringGrid1.RowCount := 2;
  AdvStringGrid1.Rows[0].Strings[1] := '';
  AdvStringGrid1.Rows[0].Strings[2] := '交换机器编号';
  AdvStringGrid1.Rows[0].Strings[3] := '物理地址';
  AdvStringGrid1.Rows[0].Strings[4] := '管理地址';
  AdvStringGrid1.Rows[0].Strings[5] := '上联端口';
  AdvStringGrid1.Rows[0].Strings[6] := 'pop';
  AdvStringGrid1.Rows[0].Strings[7] := '所属室分点';
  AdvStringGrid1.Rows[0].Strings[8] := '';
  AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
  AdvStringGrid1.ColWidths[1]:=0;
  for I := 2 to AdvStringGrid1.ColCount - 1 do
  begin
    AdvStringGrid1.AutoSizeCol(i);
  end;
end;

procedure TFrm_switch_info.UIChangeNormal;
begin
  if ButtonAdd.Tag=1 then
    ButtonAddClick(ButtonAdd);
  if ButtonModify.Tag=1 then
    ButtonModifyClick(ButtonModify);
end;

end.
