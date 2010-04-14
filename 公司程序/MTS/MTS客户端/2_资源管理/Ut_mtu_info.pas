unit Ut_mtu_info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid, StdCtrls, ExtCtrls, DBThreeStateTree ,AdvGridUnit,
  ComCtrls, DBClient, cxGraphics, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, StringUtils;
type
  TFm_mtu_info = class(TForm)
    Panel3: TPanel;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ButtonModify: TButton;
    Button2: TButton;
    ButtonAdd: TButton;
    ButtonConfirm: TButton;
    EditMTUNO: TEdit;
    EditMTUADDR: TEdit;
    EditOVERLAY: TEdit;
    EditCALL: TEdit;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    AdvStringGrid1: TAdvStringGrid;
    ComboBoxLINKID: TComboBox;
    Label8: TLabel;
    EditMTUNAME: TEdit;
    Bt_Del: TButton;
    Label16: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Et_Called: TEdit;
    Label3: TLabel;
    Label9: TLabel;
    ComboBoxMTUType: TComboBox;
    Label18: TLabel;
    Label19: TLabel;
    ComboBoxAlarmTemp: TComboBox;
    ComboBoxBuilding: TcxComboBox;
    ButtonClear: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonModifyClick(Sender: TObject);
    procedure ButtonConfirmClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
    procedure ImputNum(Sender: TObject; var Key: Char);
    procedure Bt_DelClick(Sender: TObject);
    procedure ComboBoxBuildingPropertiesChange(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
  private
    FAreaID:integer;
    Flayer:integer;
    Tv_Area : TDBThreeStateTree;
    FAdvGridSet:TAdvGridSet;
    function  GetAreaIDByLayer(llayer, lareaid: integer): string;
    procedure SetIndexFromData(Box: TComboBox; lvalue: integer);
    procedure SelLink;
    function HasExist(aMtuno:string;aMtuid:integer=-1):boolean;
    procedure ShieldOnClick(Sender :TObject);
    procedure UnShieldOnClick(Sender :TObject);
    procedure GetAlarmTemp(aItems:TStrings);
    procedure SetTitle;
    procedure LoadFromGrid(aGrid:TAdvStringGrid;aRow :integer);
    procedure SaveToGrid(aGrid:TAdvStringGrid;aID:integer;aRow:integer=-1);
  public
    procedure UIChangeNormal;
    procedure SetControl(IsEdit:Boolean);
    procedure ClearInfo;
    procedure RefreshBuilding(aCondition :String);
  end;

var
  Fm_mtu_info: TFm_mtu_info;
  OperateFlag:integer;
  
implementation

uses Ut_DataModule, Ut_MainForm, Ut_Common;

{$R *.dfm}

procedure TFm_mtu_info.AdvStringGrid1Click(Sender: TObject);
var
  linteger:integer;
begin
  if (ButtonModify.Tag=1) or (ButtonAdd.Tag=1) then
    //if application.MessageBox('正在进行其他操作，是否取消该操作?', '提示', mb_okcancel + mb_defbutton1) = idCancel then
    exit
  else
    UIChangeNormal;
  if AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]='' then
    exit;
  LoadFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
end;

procedure TFm_mtu_info.Bt_DelClick(Sender: TObject);
begin
  if EditMTUNO.Text='' then
  begin
    application.MessageBox('请选择一条记录！', '提示', mb_ok);
    exit;
  end;
  if application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+mb_defbutton1)=IDOK then
  begin
    if DelFromGrid(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),38) then
    begin
       application.MessageBox('操作成功！', '提示', mb_ok);
       DeleteFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
       ClearInfo;
    end
    else
       application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
  end;
end;

procedure TFm_mtu_info.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFm_mtu_info.ButtonAddClick(Sender: TObject);
begin
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    if ComboBoxBuilding.ItemIndex<>-1 then
       SelLink;
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

procedure TFm_mtu_info.ButtonClearClick(Sender: TObject);
begin
  ClearInfo;
  ComboBoxBuilding.ItemIndex := -1;
end;

procedure TFm_mtu_info.ButtonConfirmClick(Sender: TObject);
var
  FMTUID:INTEGER;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
  i:integer;
begin
//  for I := 0 to GroupBox3.ControlCount - 1 do
//  begin
//    if (GroupBox3.Controls[i] is TEdit) then
//       if (GroupBox3.Controls[i] as TEdit).Text ='' then
//       begin
//         application.MessageBox('请完善必填项！', '提示', mb_ok);
//         (GroupBox3.Controls[i] as TEdit).SetFocus;
//         exit;
//       end;
//    if (GroupBox3.Controls[i] is TComboBox) then
//       if (GroupBox3.Controls[i] as TComboBox).ItemIndex =-1 then
//       begin
//         application.MessageBox('请完善必填项！', '提示', mb_ok);
//         (GroupBox3.Controls[i] as TComboBox).SetFocus;
//         exit;
//       end;
//  end;
//  if ComboBoxBuilding.ItemIndex=-1 then
//  begin
//    application.MessageBox('请完善必填项！', '提示', mb_ok);
//    ComboBoxBuilding.SetFocus;
//    exit;
//  end;
  if (EditMTUNO.Text='') or (self.EditMTUNAME.Text='') or (self.EditMTUADDR.Text='') or
  (self.ComboBoxBuilding.Text='') or (self.ComboBoxMTUType.Text='') or (self.ComboBoxAlarmTemp.Text='') or
  (self.EditOVERLAY.Text='') or (self.EditCALL.Text='') then
  begin
    application.MessageBox('请完善必填项！', '提示', mb_ok);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  try
    with Dm_MTS.cds_common do
    begin
      if OperateFlag=ADDflag then
      begin
        if HasExist(EditMTUNO.Text) then
        begin
          application.MessageBox(pchar('已经存在MTU编号['+EditMTUNO.Text+']！'), '提示', mb_ok);
          exit;
        end;
        FMTUID:=Dm_MTS.TempInterface.ProduceFlowNumID('MTUID',1);
        if FMTUID=-1 then
        begin
          application.MessageBox('连接数据库失败，请检查后重试！', '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,46,0]),0);
        append;
        FieldByName('MTUID').Value    :=  FMTUID ;
      end
      else if OperateFlag=Modifyflag then
      begin
        FMTUID:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
        if HasExist(EditMTUNO.Text,FMTUID) then
        begin
          application.MessageBox(pchar('已经存在MTU编号['+EditMTUNO.Text+']！'), '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,45,FMTUID]),0);
        edit;
      end;

      FieldByName('MTUNO').Value:=EditMTUNO.Text;
      FieldByName('mtuname').Value:=EditMTUNAME.Text;
      FieldByName('mtutype').Value:=ComboBoxMTUType.ItemIndex+1;
      FieldByName('MTUADDR').Value:=EditMTUADDR.Text;
      FieldByName('OVERLAY').Value:=EditOVERLAY.Text;
      FieldByName('CALL').Value:=EditCALL.Text;
      FieldByName('CALLED').Value:=Et_Called.Text;
      FieldByName('linkid').Value:=GetIdFromObj(ComboBoxLINKID);
      FieldByName('CONTENTCODEMODEL').Value:=GetIdFromObj(ComboBoxAlarmTemp);
      FieldByName('buildingid').Value:=TCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID;      
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
              SaveToGrid(AdvStringGrid1,FMTUID,1)
            else
              SaveToGrid(AdvStringGrid1,FMTUID,AdvStringGrid1.RowCount);
          end
          else
          if OperateFlag=MODIFYFLAG then
             SaveToGrid(AdvStringGrid1,FMTUID);
         UIChangeNormal;
         ClearInfo;
      except
         application.MessageBox('保存失败，请检查后重试！', '提示', mb_ok);
      end;
    end;
  finally
    Screen.Cursor := crDefault ;
  end;
end;

procedure TFm_mtu_info.ButtonModifyClick(Sender: TObject);
begin
  if (EditMTUNO.Text='') and (ButtonModify.Tag=0) then
  begin
    application.MessageBox('请选择要修改的MTU!','提示',mb_ok);
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

procedure TFm_mtu_info.ClearInfo;
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

procedure TFm_mtu_info.ComboBoxBuildingPropertiesChange(Sender: TObject);
begin
  if ComboBoxBuilding.ItemIndex=-1 then
  begin
    ComboBoxLINKID.ItemIndex := -1;
    ComboBoxLINKID.Enabled:=false;
  end
  else
    SelLink;
end;

procedure TFm_mtu_info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyCBObj(ComboBoxLINKID);
  DestroyCBObj(ComboBoxAlarmTemp);
  DestroyCBObj(ComboBoxMTUType);
  ClearTStrings(ComboBoxBuilding.Properties.Items);
  FAdvGridSet.Free;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Fm_mtu_info:=nil;
end;

procedure TFm_mtu_info.FormCreate(Sender: TObject);
begin
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AppendMenuItem('屏蔽',ShieldOnClick);
  FAdvGridSet.AppendMenuItem('取消屏蔽',UnShieldOnClick);
  FAdvGridSet.AddGrid(AdvStringGrid1);
  FAdvGridSet.SetGridStyle;
  ComboBoxBuilding.Properties.DropDownListStyle := lsFixedList;
  SetControl(false);
end;

procedure TFm_mtu_info.FormShow(Sender: TObject);
begin
  GetAlarmTemp(ComboBoxAlarmTemp.Items);
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxBuilding.Properties.Items);
  ComboBoxBuilding.ItemIndex := -1;
  ComboBoxAlarmTemp.ItemIndex := -1;
  SetTitle;
end;

procedure TFm_mtu_info.GetAlarmTemp(aItems: TStrings);
var
  lWdInteger:TWdInteger;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    lWdInteger:=TWdInteger.Create(-1);
    aItems.AddObject('默认模板',lWdInteger);
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,75]),0);
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('modelid').AsInteger);
      aItems.AddObject(Fieldbyname('modelname').AsString,lWdInteger);
      next;
    end;
    Close;
  end;
end;

function TFm_mtu_info.GetAreaIDByLayer(llayer, lareaid: integer): string;
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

function TFm_mtu_info.HasExist(aMtuno: string; aMtuid: integer): boolean;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if aMtuid=-1 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,61,'where upper(mtuno)='+quotedstr(uppercase(aMtuno))+'']),0)
    else if aMtuid>0 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,61,'where upper(mtuno)='+quotedstr(uppercase(aMtuno))+' and mtuid<>'+inttostr(aMtuid)+'']),0);
  end;
  if Dm_MTS.cds_common.RecordCount>0 then
  result:=true
  else
  result:=false;
end;

procedure TFm_mtu_info.ImputNum(Sender: TObject; var Key: Char);
begin
  InPutNum(Key);
end;

procedure TFm_mtu_info.LoadFromGrid(aGrid: TAdvStringGrid; aRow: integer);
begin
  EditMTUNAME.Text := aGrid.Rows[aRow].Strings[3];
  EditMTUNO.Text := aGrid.Rows[aRow].Strings[2];
  EditMTUADDR.Text := aGrid.Rows[aRow].Strings[5];
  ComboBoxBuilding.ItemIndex := ComboBoxBuilding.Properties.Items.IndexOf(aGrid.Rows[aRow].Strings[12]);
  ComboBoxLINKID.ItemIndex := ComboBoxLINKID.Items.IndexOf(aGrid.Rows[aRow].Strings[9]);
  ComboBoxMTUType.ItemIndex := ComboBoxMTUType.Items.IndexOf(aGrid.Rows[aRow].Strings[4]);
  ComboBoxAlarmTemp.ItemIndex := ComboBoxAlarmTemp.Items.IndexOf(aGrid.Rows[aRow].Strings[11]);
  EditOVERLAY.Text := aGrid.Rows[aRow].Strings[6];
  EditCALL.Text := aGrid.Rows[aRow].Strings[7];
  Et_Called.Text := aGrid.Rows[aRow].Strings[8];
end;

procedure TFm_mtu_info.RefreshBuilding(aCondition: String);
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,30,aCondition]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvStringGrid1);
    if recordcount>0 then
    begin
      AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
      AdvStringGrid1.ColWidths[1]:=0;
      AdvStringGrid1.ColWidths[10]:=0;
    end;
  end;
end;

procedure TFm_mtu_info.SaveToGrid(aGrid: TAdvStringGrid; aID, aRow: integer);
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
  aGrid.Rows[lRow].Strings[2]:=EditMTUNO.Text;
  aGrid.Rows[lRow].Strings[3]:=EditMTUNAME.Text;
  aGrid.Rows[lRow].Strings[4]:=ComboBoxMTUType.Text;
  aGrid.Rows[lRow].Strings[5]:=EditMTUADDR.Text;
  aGrid.Rows[lRow].Strings[6]:=EditOVERLAY.Text;
  aGrid.Rows[lRow].Strings[7]:=EditCALL.Text;
  aGrid.Rows[lRow].Strings[8]:=Et_Called.Text;
  aGrid.Rows[lRow].Strings[9]:=ComboBoxLINKID.Text;
  aGrid.Rows[lRow].Strings[10]:='否';
  aGrid.Rows[lRow].Strings[11]:=ComboBoxAlarmTemp.Text;
  aGrid.Rows[lRow].Strings[12]:=ComboBoxBuilding.Text;
  aGrid.Row:=lRow;
end;

procedure TFm_mtu_info.SelLink;
var
  obj: TCommonObj;
  lBuildID:string;
begin
  ComboBoxLINKID.ItemIndex:=-1;
  DestroyCBObj(ComboBoxLINKID);
  lBuildID:=inttostr(tCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID);
  with Dm_MTS.cds_common1 do
  begin
    close;
    ProviderName:='dsp_General_data1';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,42, '('+lBuildID+')']),1);
    while not eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID:=FieldByName('linkid').Value;
      obj.Name:=FieldByName('linkno').Value;
      ComboBoxLINKID.Items.AddObject(obj.Name,obj);
      next;
    end;
    if (OperateFlag=ADDFLAG) or (OperateFlag=MODIFYFLAG) then
       ComboBoxLINKID.Enabled:=true;
  end;
end;

procedure TFm_mtu_info.SetControl(IsEdit: Boolean);
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
  ComboBoxBuilding.Enabled := IsEdit;
  ComboBoxLINKID.Enabled := false;
end;

procedure TFm_mtu_info.SetIndexFromData(Box: TComboBox; lvalue: integer);
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

procedure TFm_mtu_info.SetTitle;
var
  I: Integer;
begin
  AdvStringGrid1.ColCount := 14;
  AdvStringGrid1.RowCount := 2;
  AdvStringGrid1.Rows[0].Strings[1] := '';
  AdvStringGrid1.Rows[0].Strings[2] := 'MTU编号';
  AdvStringGrid1.Rows[0].Strings[3] := 'MTU名称';
  AdvStringGrid1.Rows[0].Strings[4] := 'MTU类型';
  AdvStringGrid1.Rows[0].Strings[5] := 'MTU位置';
  AdvStringGrid1.Rows[0].Strings[6] := '覆盖区域';
  AdvStringGrid1.Rows[0].Strings[7] := '电话号码';
  AdvStringGrid1.Rows[0].Strings[8] := '被叫号码';
  AdvStringGrid1.Rows[0].Strings[9] := '上端连接器';
  AdvStringGrid1.Rows[0].Strings[10] := '是否屏蔽';
  AdvStringGrid1.Rows[0].Strings[11] := '告警门限模板';
  AdvStringGrid1.Rows[0].Strings[12] := '所属室分点';
  AdvStringGrid1.Rows[0].Strings[13] := '';
  AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
  AdvStringGrid1.ColWidths[1]:=0;
  for I := 2 to AdvStringGrid1.ColCount - 1 do
  begin
    AdvStringGrid1.AutoSizeCol(i);
  end;
  AdvStringGrid1.ColWidths[10]:=0;
end;

procedure TFm_mtu_info.ShieldOnClick(Sender: TObject);
var
  lShieldStr : string;
  lMutid : string;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]='' then exit;
  lShieldStr := AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[AdvStringGrid1.ColCount-1];
  if lShieldStr<>'否' then Exit;
  
  lMutid := AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1];
  Screen.Cursor := crHourGlass;
  try
    with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,62,' where mtuid='+lMutid]),0);
      if Recordcount<=0 then
        Append
      else
        Edit;
      FieldByName('mtuid').Value:=lMutid;
      FieldByName('status').Value:=0;
      Post;
      try
        vCDSArray[0]:=Dm_MTS.cds_common;
        vDeltaArray:=RetrieveDeltas(vCDSArray);
        vProviderArray:=RetrieveProviders(vCDSArray);
        if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;
        AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[AdvStringGrid1.ColCount-1] := '是';
      except
        application.MessageBox('操作失败，请检查后重试！', '提示', mb_ok);
      end;
    end;
  finally
    Screen.Cursor := crDefault ;
  end;
end;

procedure TFm_mtu_info.UIChangeNormal;
begin
  if ButtonAdd.Tag=1 then
    ButtonAddClick(ButtonAdd);
  if ButtonModify.Tag=1 then
    ButtonModifyClick(ButtonModify);
end;

procedure TFm_mtu_info.UnShieldOnClick(Sender: TObject);
var
  lShieldStr : string;
  lMutid : string;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]='' then exit;
  lShieldStr := AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[AdvStringGrid1.ColCount-1];
  if lShieldStr<>'是' then Exit;
  
  lMutid := AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1];
  Screen.Cursor := crHourGlass;
  try
    with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,62,' where mtuid='+lMutid]),0);
      if Recordcount<=0 then
        Append
      else
        Edit;
      FieldByName('mtuid').Value:=lMutid;
      FieldByName('status').Value:=1;
      Post;
      try
        vCDSArray[0]:=Dm_MTS.cds_common;
        vDeltaArray:=RetrieveDeltas(vCDSArray);
        vProviderArray:=RetrieveProviders(vCDSArray);
        if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;
        AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[AdvStringGrid1.ColCount-1] := '否';
      except
        application.MessageBox('操作失败，请检查后重试！', '提示', mb_ok);
      end;
    end;
  finally
    Screen.Cursor := crDefault ;
  end;
end;

end.
