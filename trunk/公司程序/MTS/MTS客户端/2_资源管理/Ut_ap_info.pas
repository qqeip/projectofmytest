unit Ut_ap_info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, BaseGrid, AdvGrid, ExtCtrls ,DBThreeStateTree ,AdvGridUnit,
  ComCtrls, DBClient, cxGraphics, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit,StringUtils;

type
  TFm_ap_info = class(TForm)
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    ButtonModify: TButton;
    Button2: TButton;
    ButtonAdd: TButton;
    ButtonConfirm: TButton;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    AdvStringGrid1: TAdvStringGrid;
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
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    EditAPName: TEdit;
    ComboBoxConType: TComboBox;
    EditPort: TEdit;
    ComboBoxSwitch: TComboBox;
    ComboBoxFactory: TComboBox;
    ComboBoxPowerKind: TComboBox;
    EditAPPOWER: TEdit;
    EditAPADDR: TEdit;
    EditOVERLAY: TEdit;
    EditMANAGEADDRSEG: TEdit;
    ComboBoxApType: TComboBox;
    EditAPIP: TEdit;
    EditGWADDR: TEdit;
    EditMACADDR: TEdit;
    EditBUSINESSVLAN: TEdit;
    EditMANAGEVLAN: TEdit;
    EditFREQUENCY: TEdit;
    Bt_Del: TButton;
    Label20: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    ComboBoxAPPROPERTY: TComboBox;
    Label26: TLabel;
    ComboBoxBuilding: TcxComboBox;
    ButtonClear: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonModifyClick(Sender: TObject);
    procedure ButtonConfirmClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ImputNum(Sender: TObject; var Key: Char);
    procedure ImputFloat(Sender: TObject; var Key: Char);
    procedure Bt_DelClick(Sender: TObject);
    procedure ComboBoxBuildingPropertiesChange(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
  private
    FAreaID:integer;
    Flayer:integer;
    Tv_Area : TDBThreeStateTree;
    FAdvGridSet:TAdvGridSet;
    function  GetAreaIDByLayer(llayer,lareaid: integer):string;
    procedure SetIndexFromData(Box:TComboBox;lvalue:integer);
    procedure SelSwitch;
    procedure SetTitle;
    procedure LoadFromGrid(aGrid:TAdvStringGrid;aRow :integer);
    function HasExist(aAPno:string;aAPid:integer=-1):boolean;
    procedure SaveToGrid(aGrid:TAdvStringGrid;aID:integer;aRow:integer=-1);
  public
    procedure UIChangeNormal;
    procedure SetControl(IsEdit:Boolean);
    procedure ClearInfo;
    procedure RefreshBuilding(aCondition :String);
  end;

var
  Fm_ap_info: TFm_ap_info;
  OperateFlag:integer;
implementation

uses Ut_MainForm, Ut_Common, Ut_DataModule;

{$R *.dfm}


procedure TFm_ap_info.AdvStringGrid1Click(Sender: TObject);
begin
  if (ButtonAdd.Tag=1) or (ButtonModify.Tag=1) then
   //  if application.MessageBox('正在进行其他操作，是否取消该操作?', '提示', mb_okcancel + mb_defbutton1) = idCancel then
      exit
  else
      UIChangeNormal;
  if AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]='' then
    exit;
  LoadFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
end;

procedure TFm_ap_info.Bt_DelClick(Sender: TObject);
begin
  if EditAPName.Text='' then
  begin
    application.MessageBox('请选择一条记录！', '提示', mb_ok);
    exit;
  end;
  if application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+mb_defbutton1)=IDOK then
  begin
    if DelFromGrid(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),29) then
    begin
       application.MessageBox('操作成功！', '提示', mb_ok);
       DeleteFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
       ClearInfo;
    end
    else
       application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
  end;
end;

procedure TFm_ap_info.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFm_ap_info.ButtonAddClick(Sender: TObject);
begin
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    if ComboBoxBuilding.ItemIndex<>-1 then
       SelSwitch;
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

procedure TFm_ap_info.ButtonClearClick(Sender: TObject);
begin
  ClearInfo;
  ComboBoxBuilding.ItemIndex := -1;
end;

procedure TFm_ap_info.ButtonConfirmClick(Sender: TObject);
var
  FAPID:INTEGER;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
  I: Integer;
begin
  if (EditAPName.Text='') or (ComboBoxBuilding.ItemIndex<0)
      or (ComboBoxConType.ItemIndex<0)  or (ComboBoxSwitch.ItemIndex<0)
      or (ComboBoxFactory.ItemIndex<0)
  then
  begin
    Application.MessageBox('请完善必填项！','提示',MB_OK);
    Exit;
  end;
  try
  begin
  Screen.Cursor := crHourGlass;
  with Dm_MTS.cds_common do
    begin
      if OperateFlag=addflag then
      begin
        if HasExist(EditAPName.Text) then
        begin
          application.MessageBox(pchar('已经存在接入点编号['+EditAPName.Text+']！'), '提示', mb_ok);
          exit;
        end;
        FAPID:=Dm_MTS.TempInterface.ProduceFlowNumID('APID',1);
        if FAPID=-1 then
        begin
          application.MessageBox('连接数据库失败，请检查后重试！', '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,28,0]),0);
        append;
        
        FieldByName('APID').Value    :=  FAPID ;
      end
      else if OperateFlag=modifyflag then
      begin
        FAPID:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
        if HasExist(EditAPName.Text,FAPID) then
        begin
          application.MessageBox(pchar('已经存在接入点编号['+EditAPName.Text+']！'), '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,29,FAPID]),0);
        edit;
      end;

      FieldByName('APNO').Value:=EditAPName.Text;
      FieldByName('APPORT').AsString:=EditPort.Text;
      FieldByName('APPOWER').AsString:=EditAPPOWER.Text;
      FieldByName('APADDR').Value:=EditAPADDR.Text;
      FieldByName('OVERLAY').Value:=EditOVERLAY.Text;
      FieldByName('MANAGEADDRSEG').Value:=EditMANAGEADDRSEG.Text;
      FieldByName('APIP').Value:=EditAPIP.Text;
      FieldByName('GWADDR').Value:=EditGWADDR.Text;
      FieldByName('MACADDR').Value:=EditMACADDR.Text;
      FieldByName('BUSINESSVLAN').Value:=  EditBUSINESSVLAN.Text;
      FieldByName('MANAGEVLAN').Value:=  EditMANAGEVLAN.Text;
      FieldByName('FREQUENCY').AsString:=  EditFREQUENCY.Text;
      FieldByName('approperty').Value:=GetIdFromObj(ComboBoxAPPROPERTY);
      FieldByName('CONNECTTYPE').Value:=GetIdFromObj(ComboBoxConType);
      FieldByName('SWITCHID').Value:=GetIdFromObj(ComboBoxSwitch);
      FieldByName('FACTORY').Value:=GetIdFromObj(ComboBoxFactory);
      FieldByName('PowerKind').Value:=GetIdFromObj(ComboBoxPowerKind);
      FieldByName('APKIND').Value:=GetIdFromObj(ComboBoxApType);
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
              SaveToGrid(AdvStringGrid1,FAPID,1)
            else
              SaveToGrid(AdvStringGrid1,FAPID,AdvStringGrid1.RowCount);
          end
          else
          if OperateFlag=MODIFYFLAG then
             SaveToGrid(AdvStringGrid1,FAPID);
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

procedure TFm_ap_info.ButtonModifyClick(Sender: TObject);
begin
  if (EditAPName.Text='') and (ButtonModify.Tag=0) then
  begin
    application.MessageBox('请选择要修改的AP!','提示',mb_ok);
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

procedure TFm_ap_info.ClearInfo;
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

procedure TFm_ap_info.ComboBoxBuildingPropertiesChange(Sender: TObject);
begin
  if ComboBoxBuilding.ItemIndex=-1 then
  begin
    ComboBoxSwitch.ItemIndex := -1;
    ComboBoxSwitch.Enabled:=false;
  end
  else
    SelSwitch;
end;

procedure TFm_ap_info.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyCBObj(ComboBoxConType);
  ClearTStrings(ComboBoxBuilding.Properties.Items);
  DestroyCBObj(ComboBoxSwitch);
  DestroyCBObj(ComboBoxFactory);
  DestroyCBObj(ComboBoxPowerKind);
  DestroyCBObj(ComboBoxApType);
  DestroyCBObj(ComboBoxAPPROPERTY);
  FAdvGridSet.Free;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Fm_ap_info:=nil;
end;

procedure TFm_ap_info.FormCreate(Sender: TObject);
begin
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(self.AdvStringGrid1);
  FAdvGridSet.SetGridStyle;
  SetControl(false);
  ComboBoxBuilding.Properties.DropDownListStyle := lsFixedList;
end;

procedure TFm_ap_info.FormShow(Sender: TObject);
begin
  GetDic(5,ComboBoxConType.Items);
  GetDic(7,ComboBoxFactory.Items);
  GetDic(9,ComboBoxPowerKind.Items);
  GetDic(8,ComboBoxApType.Items);
  GetDic(6,ComboBoxAPPROPERTY.Items);
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxBuilding.Properties.Items);
  ComboBoxConType.ItemIndex:=-1;
  ComboBoxFactory.ItemIndex:=-1;
  ComboBoxPowerKind.ItemIndex:=-1;
  ComboBoxApType.ItemIndex:=-1;
  ComboBoxAPPROPERTY.ItemIndex:=-1;
  ComboBoxBuilding.ItemIndex:=-1;
  SetTitle;
end;

function TFm_ap_info.GetAreaIDByLayer(llayer, lareaid: integer): string;
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

function TFm_ap_info.HasExist(aAPno: string; aAPid: integer): boolean;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if aAPid=-1 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,77,'where upper(apno)='+quotedstr(uppercase(aAPno))+'']),0)
    else if aAPid>0 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,77,'where upper(apno)='+quotedstr(uppercase(aAPno))+' and apid<>'+inttostr(aAPid)+'']),0);
  end;
  if Dm_MTS.cds_common.RecordCount>0 then
  result:=true
  else
  result:=false;
end;

procedure TFm_ap_info.ImputFloat(Sender: TObject; var Key: Char);
var
  lstr:string;
  I: Integer;
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

procedure TFm_ap_info.ImputNum(Sender: TObject; var Key: Char);
begin
  InPutNum(Key);
end;

procedure TFm_ap_info.LoadFromGrid(aGrid: TAdvStringGrid; aRow: integer);
begin
  EditAPName.Text := aGrid.Rows[aRow].Strings[2];
  ComboBoxConType.ItemIndex := ComboBoxConType.Items.IndexOf(aGrid.Rows[aRow].Strings[3]);
  ComboBoxFactory.ItemIndex := ComboBoxFactory.Items.IndexOf(aGrid.Rows[aRow].Strings[5]);
  EditPort.Text := aGrid.Rows[aRow].Strings[4];
  ComboBoxBuilding.ItemIndex := ComboBoxBuilding.Properties.Items.IndexOf(aGrid.Rows[aRow].Strings[20]);
  ComboBoxSwitch.ItemIndex := ComboBoxSwitch.Items.IndexOf(aGrid.Rows[aRow].Strings[19]);
  EditAPPOWER.Text := aGrid.Rows[aRow].Strings[8];
  ComboBoxPowerKind.ItemIndex := ComboBoxPowerKind.Items.IndexOf(aGrid.Rows[aRow].Strings[9]);
  ComboBoxAPPROPERTY.ItemIndex := ComboBoxAPPROPERTY.Items.IndexOf(aGrid.Rows[aRow].Strings[7]);
  ComboBoxApType.ItemIndex := ComboBoxApType.Items.IndexOf(aGrid.Rows[aRow].Strings[6]);
  EditFREQUENCY.Text := aGrid.Rows[aRow].Strings[10];
  EditAPIP.Text := aGrid.Rows[aRow].Strings[14];
  EditAPADDR.Text := aGrid.Rows[aRow].Strings[11];
  EditOVERLAY.Text := aGrid.Rows[aRow].Strings[12];
  EditBUSINESSVLAN.Text := aGrid.Rows[aRow].Strings[17];
  EditMANAGEADDRSEG.Text := aGrid.Rows[aRow].Strings[13];
  EditGWADDR.Text := aGrid.Rows[aRow].Strings[15];
  EditMACADDR.Text := aGrid.Rows[aRow].Strings[16];
  EditMANAGEVLAN.Text := aGrid.Rows[aRow].Strings[18];
end;

procedure TFm_ap_info.RefreshBuilding(aCondition: String);
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,32,aCondition]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvStringGrid1);
    if recordcount>0 then
    begin
      AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
      AdvStringGrid1.ColWidths[1]:=0;
    end;
  end;
end;

procedure TFm_ap_info.SaveToGrid(aGrid: TAdvStringGrid; aID, aRow: integer);
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
  aGrid.Rows[lRow].Strings[2]:=EditAPName.Text;
  aGrid.Rows[lRow].Strings[3]:=ComboBoxConType.Text;
  aGrid.Rows[lRow].Strings[4]:=EditPort.Text;
  aGrid.Rows[lRow].Strings[5]:=ComboBoxFactory.Text;
  aGrid.Rows[lRow].Strings[6]:=ComboBoxApType.Text;
  aGrid.Rows[lRow].Strings[7]:=ComboBoxAPPROPERTY.Text;
  aGrid.Rows[lRow].Strings[8]:=EditAPPOWER.Text;
  aGrid.Rows[lRow].Strings[9]:=ComboBoxPowerKind.Text;
  aGrid.Rows[lRow].Strings[10]:=EditFREQUENCY.Text;
  aGrid.Rows[lRow].Strings[11]:=EditAPADDR.Text;
  aGrid.Rows[lRow].Strings[12]:=EditOVERLAY.Text;
  aGrid.Rows[lRow].Strings[13]:=EditMANAGEADDRSEG.Text;
  aGrid.Rows[lRow].Strings[14]:=EditAPIP.Text;
  aGrid.Rows[lRow].Strings[15]:=EditGWADDR.Text;
  aGrid.Rows[lRow].Strings[16]:=EditMACADDR.Text;
  aGrid.Rows[lRow].Strings[17]:=EditBUSINESSVLAN.Text;
  aGrid.Rows[lRow].Strings[18]:=EditMANAGEVLAN.Text;
  aGrid.Rows[lRow].Strings[19]:=ComboBoxSwitch.Text;
  aGrid.Rows[lRow].Strings[20]:=ComboBoxBuilding.Text;
  aGrid.Row:=lRow;
end;

procedure TFm_ap_info.SelSwitch;
var
  obj: TCommonObj;
  lBuildID:string;
begin
  ComboBoxSwitch.ItemIndex:=-1;
  DestroyCBObj(ComboBoxSwitch);
  lBuildID:=inttostr(TCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID);
  with Dm_MTS.cds_common1 do
  begin
    close;
    ProviderName:='dsp_General_data1';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,30,lBuildID]),1);
    while not eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID:=FieldByName('switchid').Value;
      obj.Name:=FieldByName('switchno').Value;
      ComboBoxSwitch.Items.AddObject(obj.Name,obj);
      next;
    end;
    if (OperateFlag=ADDFLAG) or (OperateFlag=MODIFYFLAG) then
       ComboBoxSwitch.Enabled:=true;
  end;
end;

procedure TFm_ap_info.SetControl(IsEdit: Boolean);
var
  i : integer;
begin
  for I := 0 to GroupBox3.ControlCount - 1 do
  begin
    if (GroupBox3.Controls[i] is TEdit) or (GroupBox3.Controls[i] is TComboBox)
      or (GroupBox3.Controls[i] is TcxComboBox) then
        GroupBox3.Controls[i].Enabled := IsEdit;
  end;
  ButtonConfirm.Enabled :=IsEdit;
  Bt_Del.Enabled :=not(IsEdit);
  ComboBoxSwitch.Enabled := False;
end;

procedure TFm_ap_info.SetIndexFromData(Box: TComboBox; lvalue: integer);
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

procedure TFm_ap_info.SetTitle;
var
  I: Integer;
begin
  AdvStringGrid1.ColCount := 23;
  AdvStringGrid1.RowCount := 2;
  AdvStringGrid1.Rows[0].Strings[1] := '';
  AdvStringGrid1.Rows[0].Strings[2] := '接入点编号';
  AdvStringGrid1.Rows[0].Strings[3] := '连接类型';
  AdvStringGrid1.Rows[0].Strings[4] := '对应端口';
  AdvStringGrid1.Rows[0].Strings[5] := '供应商';
  AdvStringGrid1.Rows[0].Strings[6] := 'AP型号';
  AdvStringGrid1.Rows[0].Strings[7] := 'AP性质';
  AdvStringGrid1.Rows[0].Strings[8] := '功率';
  AdvStringGrid1.Rows[0].Strings[9] := '供电方式';
  AdvStringGrid1.Rows[0].Strings[10] := '频点';
  AdvStringGrid1.Rows[0].Strings[11] := 'AP地址';
  AdvStringGrid1.Rows[0].Strings[12] := '覆盖范围';
  AdvStringGrid1.Rows[0].Strings[13] := 'AP管理地址段';
  AdvStringGrid1.Rows[0].Strings[14] := 'APIP';
  AdvStringGrid1.Rows[0].Strings[15] := '网关地址';
  AdvStringGrid1.Rows[0].Strings[16] := 'MAC地址';
  AdvStringGrid1.Rows[0].Strings[17] := '业务VLAN';
  AdvStringGrid1.Rows[0].Strings[18] := '管理VLAN';
  AdvStringGrid1.Rows[0].Strings[19] := '所属交换机';
  AdvStringGrid1.Rows[0].Strings[20] := '所属室分点';
  AdvStringGrid1.Rows[0].Strings[21] := '';
  AdvStringGrid1.Rows[0].Strings[22] := '';
  AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
  AdvStringGrid1.ColWidths[1]:=0;
  for I := 2 to AdvStringGrid1.ColCount - 1 do
  begin
    AdvStringGrid1.AutoSizeCol(i);
  end;
end;

procedure TFm_ap_info.UIChangeNormal;
begin
  if ButtonAdd.Tag=1 then
    ButtonAddClick(ButtonAdd);
  if ButtonModify.Tag=1 then
    ButtonModifyClick(ButtonModify);
end;

end.
