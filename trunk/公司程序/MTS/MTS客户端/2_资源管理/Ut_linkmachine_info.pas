unit Ut_linkmachine_info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid, StdCtrls, ExtCtrls, DBThreeStateTree ,AdvGridUnit,
  ComCtrls, DBClient, cxGraphics, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit,StringUtils;

type
  TFm_linkmachine_info = class(TForm)
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    ButtonModify: TButton;
    Button2: TButton;
    ButtonAdd: TButton;
    ButtonConfirm: TButton;
    EditLINKNO: TEdit;
    EditLINKADDR: TEdit;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    ComboBoxLINKTYPE: TComboBox;
    Label9: TLabel;
    ComboBoxISTRUNK: TComboBox;
    Label10: TLabel;
    EditTRUNKADDR: TEdit;
    Label11: TLabel;
    ComboBoxLINKEQUIPMENT: TComboBox;
    Label5: TLabel;
    ComboBoxLINKCS: TComboBox;
    Label6: TLabel;
    ComboBoxLINKAP: TComboBox;
    Bt_Del: TButton;
    Label20: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    ComboBoxLinkCDMA: TComboBox;
    ComboBoxBuilding: TcxComboBox;
    ButtonClear: TButton;
    AdvStringGrid1: TAdvStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonModifyClick(Sender: TObject);
    procedure ButtonConfirmClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
    procedure ComboBoxLINKEQUIPMENTChange(Sender: TObject);
    procedure ComboBoxISTRUNKChange(Sender: TObject);
    procedure Bt_DelClick(Sender: TObject);
    procedure ComboBoxBuildingPropertiesChange(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
  private
    FAreaID:integer;
    Flayer:integer;
    FAdvGridSet:TAdvGridSet;
    procedure SetComboxCsAp;
    function  GetAreaIDByLayer(llayer,lareaid: integer):string;
    procedure ChangeByBuilidingAndEquip(aBuildingid:Integer;ComBoxE:TComboBox);
    procedure SetIndexFromData(Box:TComboBox;lvalue:integer);
    procedure SetEnableByCSAP;
    procedure SetTitle;
    procedure LoadFromGrid(aGrid:TAdvStringGrid;aRow :integer);
    function HasExist(aLINKno:string;aLINKid:integer=-1):boolean;
    procedure SaveToGrid(aGrid:TAdvStringGrid;aID:integer;aRow:integer=-1);
  public
    procedure SetControl(IsEdit:Boolean);
    procedure ClearInfo;
    procedure UIChangeNormal;
    procedure RefreshBuilding(aCondition :String);
  end;

var
  Fm_linkmachine_info: TFm_linkmachine_info;
  OperateFlag:integer;
  
implementation

uses Ut_MainForm, Ut_Common, Ut_DataModule;

{$R *.dfm}

procedure TFm_linkmachine_info.AdvStringGrid1Click(Sender: TObject);
var
  linteger:integer;
  obj :TCommonObj;
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

procedure TFm_linkmachine_info.Bt_DelClick(Sender: TObject);
begin
  if EditLINKNO.Text='' then
  begin
    application.MessageBox('请选择一条记录！', '提示', mb_ok);
    exit;
  end;
  if application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+mb_defbutton1)=IDOK then
  begin
    if DelFromGrid(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),34) then
    begin
       application.MessageBox('操作成功！', '提示', mb_ok);
       DeleteFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
       ClearInfo;
    end
    else
       application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
  end;
end;

procedure TFm_linkmachine_info.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFm_linkmachine_info.ButtonAddClick(Sender: TObject);
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

procedure TFm_linkmachine_info.ButtonClearClick(Sender: TObject);
begin
  ClearInfo;
  ComboBoxBuilding.ItemIndex := -1;
end;

procedure TFm_linkmachine_info.ButtonConfirmClick(Sender: TObject);
var
  FLINKID:INTEGER;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if (EditLINKNO.Text='') or (EditLINKADDR.Text='') or (ComboBoxLINKTYPE.ItemIndex<0)
     or (ComboBoxBuilding.ItemIndex<0) or (ComboBoxLINKEQUIPMENT.ItemIndex<0) or (ComboBoxISTRUNK.ItemIndex<0)then
  begin
    application.MessageBox('请完善必填项！','提示',MB_OK);
    exit;
  end;
  if (ComboBoxISTRUNK.ItemIndex=1) and (EditTRUNKADDR.text='') then
  begin
    application.MessageBox('请填写"干放位置"信息！','提示',MB_OK);
    EditTRUNKADDR.SetFocus;
    exit;
  end;
  if (ComboBoxLINKCS.Enabled=true) and (ComboBoxLINKCS.ItemIndex=-1) then
  begin
    application.MessageBox('请选择"连接基站"信息！','提示',MB_OK);
    ComboBoxLINKCS.SetFocus;
    exit;
  end;
  if (ComboBoxLINKAP.Enabled=true) and (ComboBoxLINKAP.ItemIndex=-1) then
  begin
    application.MessageBox('请选择"连接AP"信息！','提示',MB_OK);
    ComboBoxLINKAP.SetFocus;
    exit;
  end;
  if (ComboBoxLINKCDMA.Enabled=true) and (ComboBoxLINKCDMA.ItemIndex=-1) then
  begin
    application.MessageBox('请选择"连接CDMA基站"信息！','提示',MB_OK);
    ComboBoxLINKCDMA.SetFocus;
    exit;
  end;

  try
  begin
    Screen.Cursor := crHourGlass;
    with Dm_MTS.cds_common do
    begin
      if OperateFlag=ADDflag then
      begin
        if HasExist(EditLINKNO.Text) then
        begin
          application.MessageBox(pchar('已经存在连接器编号['+EditLINKNO.Text+']！'), '提示', mb_ok);
          exit;
        end;
        FLINKID:=Dm_MTS.TempInterface.ProduceFlowNumID('LINKID',1);
        if FLINKID=-1 then
        begin
          application.MessageBox('连接数据库失败，请检查后重试！', '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,35,0]),0);
        append;
        FieldByName('LINKID').Value    :=  FLINKID ;
      end
      else if OperateFlag=Modifyflag then
      begin
        FLINKID:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
        if HasExist(EditLINKNO.Text,FLINKID) then
        begin
          application.MessageBox(pchar('已经存在连接器编号['+EditLINKNO.Text+']！'), '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,34,FLINKID]),0);
        edit;
      end;
      FieldByName('LINKNO').Value:=EditLINKNO.Text;
      FieldByName('LINKADDR').Value:=EditLINKADDR.Text;
      FieldByName('TRUNKADDR').Value:=EditTRUNKADDR.Text;
      FieldByName('LINKTYPE').Value:=GetIdFromObj(ComboBoxLINKTYPE);
      FieldByName('ISTRUNK').Value:=ComboBoxISTRUNK.ItemIndex;
      FieldByName('LINKEQUIPMENT').Value:=ComboBoxLINKEQUIPMENT.ItemIndex+1;
      FieldByName('LINKCS').Value:=GetIdFromObj(ComboBoxLINKCS);
      FieldByName('LINKAP').Value:=GetIdFromObj(ComboBoxLINKAP);
      FieldByName('LINKCDMA').Value:=GetIdFromObj(ComboBoxLINKCDMA);
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
              SaveToGrid(AdvStringGrid1,FLINKID,1)
            else
              SaveToGrid(AdvStringGrid1,FLINKID,AdvStringGrid1.RowCount);
          end
          else
          if OperateFlag=MODIFYFLAG then
             SaveToGrid(AdvStringGrid1,FLINKID);
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

procedure TFm_linkmachine_info.ButtonModifyClick(Sender: TObject);
begin
  if (EditLINKNO.Text='') and (ButtonModify.Tag=0) then
  begin
    application.MessageBox('请选择要修改的连接器！','提示',mb_ok);
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


procedure TFm_linkmachine_info.ChangeByBuilidingAndEquip(aBuildingid:Integer;ComBoxE: TComboBox);
var
  obj :TCommonObj;
begin
  if (ComBoxE.ItemIndex=0) or (ComBoxE.ItemIndex=3) or (ComBoxE.ItemIndex=4) or (ComBoxE.ItemIndex=6) then
  begin
    with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,31,aBuildingid]),0);
      while not eof do
      begin
        obj :=TCommonObj.Create;
        obj.ID:=FieldByName('csid').Value;
        obj.Name:=FieldByName('survery_id').Value;
        ComboBoxLINKCS.Items.AddObject(obj.Name,obj);
        next;
      end;
    end;
  end
  else
  if (ComBoxE.ItemIndex=1) or (ComBoxE.ItemIndex=3) or (ComBoxE.ItemIndex=5) or (ComBoxE.ItemIndex=6) then
  begin
    with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,32,aBuildingid]),0);
      while not eof do
      begin
        obj :=TCommonObj.Create;
        obj.ID:=FieldByName('apid').Value;
        obj.Name:=FieldByName('apno').Value;
        ComboBoxLINKAP.Items.AddObject(obj.Name,obj);
        next;
      end;
    end;
  end
  else
  if (ComBoxE.ItemIndex=2) or (ComBoxE.ItemIndex=4) or (ComBoxE.ItemIndex=5) or (ComBoxE.ItemIndex=6) then
  begin
    with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,73,aBuildingid]),0);
      while not eof do
      begin
        obj :=TCommonObj.Create;
        obj.ID:=FieldByName('cdmaid').Value;
        obj.Name:=FieldByName('cdmaname').Value;
        ComboBoxLINKCDMA.Items.AddObject(obj.Name,obj);
        next;
      end;
    end;
  end;
end;

procedure TFm_linkmachine_info.ClearInfo;
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

procedure TFm_linkmachine_info.ComboBoxBuildingPropertiesChange(
  Sender: TObject);
var
  lBuildingID : Integer;
begin
  if ComboBoxBuilding.ItemIndex<>-1 then
    ComboBoxLINKEQUIPMENT.Enabled := True
  else
  begin
    ComboBoxLINKEQUIPMENT.Enabled := False;
    ComboBoxLINKEQUIPMENT.ItemIndex := -1;
  end;
  if ComboBoxLINKEQUIPMENT.ItemIndex<>-1 then
  begin
    ComboBoxLINKCS.ItemIndex:=-1;
    ComboBoxLINKAP.ItemIndex:=-1;
    ComboBoxLinkCDMA.ItemIndex := -1;
    DestroyCBObj(ComboBoxLINKCS);
    DestroyCBObj(ComboBoxLINKAP);
    DestroyCBObj(ComboBoxLinkCDMA);
    lbuildingID:=TCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID ;
    ChangeByBuilidingAndEquip(lbuildingID,ComboBoxLINKEQUIPMENT);
    SetEnableByCSAP;
  end;
end;

procedure TFm_linkmachine_info.ComboBoxISTRUNKChange(Sender: TObject);
begin
  EditTRUNKADDR.Text := '';
  if ComboBoxISTRUNK.ItemIndex=1 then
    EditTRUNKADDR.Enabled:=true
  else
    EditTRUNKADDR.Enabled:=false;
end;

procedure TFm_linkmachine_info.ComboBoxLINKEQUIPMENTChange(Sender: TObject);
var
  lBuildingid : Integer;
begin
  ComboBoxLINKCS.ItemIndex:=-1;
  ComboBoxLINKAP.ItemIndex:=-1;
  ComboBoxLinkCDMA.ItemIndex := -1;
  DestroyCBObj(ComboBoxLINKCS);
  DestroyCBObj(ComboBoxLINKAP);
  DestroyCBObj(ComboBoxLinkCDMA);
  lbuildingID:=TCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID ;
  ChangeByBuilidingAndEquip(lbuildingID,ComboBoxLINKEQUIPMENT);
  SetEnableByCSAP;
end;

procedure TFm_linkmachine_info.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DestroyCBObj(ComboBoxISTRUNK);
  DestroyCBObj(ComboBoxLINKEQUIPMENT);
  DestroyCBObj(ComboBoxLINKTYPE);
  DestroyCBObj(ComboBoxLINKCS);
  DestroyCBObj(ComboBoxLINKAP);
  ClearTStrings(ComboBoxBuilding.Properties.Items);
  FAdvGridSet.Free;
  
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Fm_linkmachine_info:=nil;
end;

procedure TFm_linkmachine_info.FormCreate(Sender: TObject);
begin
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(self.AdvStringGrid1);
  FAdvGridSet.SetGridStyle;
  SetControl(false);
  ComboBoxBuilding.Properties.DropDownListStyle := lsFixedList;
end;

procedure TFm_linkmachine_info.FormShow(Sender: TObject);
begin
  GetDic(13,ComboBoxLINKTYPE.Items);   //连接器类型
  ComboBoxLINKTYPE.ItemIndex:=-1;
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxBuilding.Properties.Items);
  ComboBoxBuilding.ItemIndex := -1;
  SetTitle;
end;

function TFm_linkmachine_info.GetAreaIDByLayer(llayer,
  lareaid: integer): string;
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

function TFm_linkmachine_info.HasExist(aLINKno: string;
  aLINKid: integer): boolean;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if aLINKid=-1 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,74,'where upper(linkno)='+quotedstr(uppercase(aLINKno))+'']),0)
    else if aLINKid>0 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,74,'where upper(linkno)='+quotedstr(uppercase(aLINKno))+' and linkid<>'+inttostr(aLINKid)+'']),0);
  end;
  if Dm_MTS.cds_common.RecordCount>0 then
    result:=true
  else
    result:=false;
end;

procedure TFm_linkmachine_info.LoadFromGrid(aGrid: TAdvStringGrid;
  aRow: integer);
begin
  EditLINKNO.Text := aGrid.Rows[aRow].Strings[2];
  ComboBoxLINKTYPE.ItemIndex := ComboBoxLINKTYPE.Items.IndexOf(aGrid.Rows[aRow].Strings[4]);
  EditLINKADDR.Text := aGrid.Rows[aRow].Strings[3];
  ComboBoxBuilding.ItemIndex := ComboBoxBuilding.Properties.Items.IndexOf(aGrid.Rows[aRow].Strings[11]);
  ComboBoxLINKCS.ItemIndex := ComboBoxLINKCS.Items.IndexOf(aGrid.Rows[aRow].Strings[8]);
  ComboBoxLINKAP.ItemIndex := ComboBoxLINKAP.Items.IndexOf(aGrid.Rows[aRow].Strings[9]);
  ComboBoxLinkCDMA.ItemIndex := ComboBoxLinkCDMA.Items.IndexOf(aGrid.Rows[aRow].Strings[10]);
  ComboBoxLINKEQUIPMENT.ItemIndex := ComboBoxLINKEQUIPMENT.Items.IndexOf(aGrid.Rows[aRow].Strings[7]);
  ComboBoxISTRUNK.ItemIndex := ComboBoxISTRUNK.Items.IndexOf(aGrid.Rows[aRow].Strings[5]);
  EditTRUNKADDR.Text := aGrid.Rows[aRow].Strings[6];
end;

procedure TFm_linkmachine_info.RefreshBuilding(aCondition: String);
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,29,aCondition]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvStringGrid1);
    if recordcount>0 then
    begin
      AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
      AdvStringGrid1.ColWidths[1]:=0;
    end;
  end;
end;

procedure TFm_linkmachine_info.SaveToGrid(aGrid: TAdvStringGrid; aID,
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
  aGrid.Rows[lRow].Strings[2]:=EditLINKNO.Text;
  aGrid.Rows[lRow].Strings[3]:=EditLINKADDR.Text;
  aGrid.Rows[lRow].Strings[4]:=ComboBoxLINKTYPE.Text;
  aGrid.Rows[lRow].Strings[5]:=ComboBoxISTRUNK.Text;
  aGrid.Rows[lRow].Strings[6]:=EditTRUNKADDR.Text;
  aGrid.Rows[lRow].Strings[7]:=ComboBoxLINKEQUIPMENT.Text;
  aGrid.Rows[lRow].Strings[8]:=ComboBoxLINKCS.Text;
  aGrid.Rows[lRow].Strings[9]:=ComboBoxLINKAP.Text;
  aGrid.Rows[lRow].Strings[10]:=ComboBoxLinkCDMA.Text;
  aGrid.Rows[lRow].Strings[11]:=ComboBoxBuilding.Text;
  aGrid.Row:=lRow;
end;

procedure TFm_linkmachine_info.SetComboxCsAp;
var
  obj :TCommonObj;
begin
  with Dm_MTS.cds_common do
    begin
      close;
      ProviderName:='dsp_General_data';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,43,0]),0);
      while not eof do
      begin
        obj :=TCommonObj.Create;
        obj.ID:=FieldByName('apid').Value;
        obj.Name:=FieldByName('apno').Value;
        ComboBoxLINKAP.Items.AddObject(obj.Name,obj);
        next;
      end;
      close;
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,44,0]),0);
      while not eof do
      begin
        obj :=TCommonObj.Create;
        obj.ID:=FieldByName('csid').Value;
        obj.Name:=FieldByName('survery_id').Value;
        ComboBoxLINKCS.Items.AddObject(obj.Name,obj);
        next;
      end;
    end;
end;

procedure TFm_linkmachine_info.SetControl(IsEdit: Boolean);
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
  ComboBoxLINKCS.Enabled:=false;
  ComboBoxLINKAP.Enabled:=false;
  ComboBoxLinkCDMA.Enabled:=false;
  ComboBoxBuilding.Enabled := IsEdit;
  if ComboBoxBuilding.ItemIndex<>-1 then
     ComboBoxLINKEQUIPMENT.Enabled := IsEdit
  else
     ComboBoxLINKEQUIPMENT.Enabled:=false;
end;

procedure TFm_linkmachine_info.SetEnableByCSAP;
begin
  if ComboBoxLINKEQUIPMENT.ItemIndex=-1 then
  begin
    ComboBoxLINKCS.ItemIndex:=-1;
    ComboBoxLINKAP.ItemIndex:=-1;
    ComboBoxLinkCDMA.ItemIndex := -1;
    ComboBoxLINKCS.Enabled:=false;
    ComboBoxLINKAP.Enabled:=false;
    ComboBoxLinkCDMA.Enabled := False;
  end
  else if ComboBoxLINKEQUIPMENT.ItemIndex=0 then  //PHS
  begin
    ComboBoxLINKAP.ItemIndex:=-1;
    ComboBoxLinkCDMA.ItemIndex := -1;
    ComboBoxLINKCS.Enabled:=true;
    ComboBoxLINKAP.Enabled:=false;
    ComboBoxLinkCDMA.Enabled := False;
  end
  else if ComboBoxLINKEQUIPMENT.ItemIndex=1 then  //WLAN
  begin
    ComboBoxLINKCS.ItemIndex:=-1;
    ComboBoxLinkCDMA.ItemIndex := -1;
    ComboBoxLINKCS.Enabled:=false;
    ComboBoxLinkCDMA.Enabled := false;
    ComboBoxLINKAP.Enabled:=true;
  end
  else if  ComboBoxLINKEQUIPMENT.ItemIndex=2 then  //CDMA
  begin
    ComboBoxLINKCS.ItemIndex:=-1;
    ComboBoxLINKAP.ItemIndex:=-1;
    ComboBoxLINKCS.Enabled:=False;
    ComboBoxLINKAP.Enabled:=False;
    ComboBoxLinkCDMA.Enabled := True;
  end
  else if ComboBoxLINKEQUIPMENT.ItemIndex=3 then    //PHS+WLAN
  begin
    ComboBoxLINKCS.Enabled:=true;
    ComboBoxLINKAP.Enabled:=true;
    ComboBoxLinkCDMA.ItemIndex := -1;
    ComboBoxLinkCDMA.Enabled := false;
  end
  else if ComboBoxLINKEQUIPMENT.ItemIndex=4 then   //PHS+CDMA
  begin
    ComboBoxLINKCS.Enabled:=true;
    ComboBoxLINKAP.ItemIndex := -1;
    ComboBoxLINKAP.Enabled:=false;
    ComboBoxLinkCDMA.Enabled := True;
  end
  else if ComboBoxLINKEQUIPMENT.ItemIndex=5 then   //WLAN+CDMA
  begin
    ComboBoxLINKCS.ItemIndex := -1;
    ComboBoxLINKCS.Enabled:=false;
    ComboBoxLINKAP.Enabled:=True;
    ComboBoxLinkCDMA.Enabled := True;
  end
  else if ComboBoxLINKEQUIPMENT.ItemIndex=6 then   //PHS+WLAN+CDMA
  begin
    ComboBoxLINKCS.Enabled:=True;
    ComboBoxLINKAP.Enabled:=True;
    ComboBoxLinkCDMA.Enabled := True;
  end;
end;

procedure TFm_linkmachine_info.SetIndexFromData(Box: TComboBox;
  lvalue: integer);
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

procedure TFm_linkmachine_info.SetTitle;
var
  I: Integer;
begin
  AdvStringGrid1.ColCount := 13;
  AdvStringGrid1.RowCount := 2;
  AdvStringGrid1.Rows[0].Strings[1] := '';
  AdvStringGrid1.Rows[0].Strings[2] := '连接器编号';
  AdvStringGrid1.Rows[0].Strings[3] := '连接器位置';
  AdvStringGrid1.Rows[0].Strings[4] := '连接器类型';
  AdvStringGrid1.Rows[0].Strings[5] := '是否干放';
  AdvStringGrid1.Rows[0].Strings[6] := '干放位置';
  AdvStringGrid1.Rows[0].Strings[7] := '连接设备类型';
  AdvStringGrid1.Rows[0].Strings[8] := '连接基站';
  AdvStringGrid1.Rows[0].Strings[9] := '连接AP';
  AdvStringGrid1.Rows[0].Strings[10] := '连接CDMA';
  AdvStringGrid1.Rows[0].Strings[11] := '所属室分点';
  AdvStringGrid1.Rows[0].Strings[12] := '';
  AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
  AdvStringGrid1.ColWidths[1]:=0;
  for I := 2 to AdvStringGrid1.ColCount - 1 do
  begin
    AdvStringGrid1.AutoSizeCol(i);
  end;
end;

procedure TFm_linkmachine_info.UIChangeNormal;
begin
  if ButtonAdd.Tag=1 then
    ButtonAddClick(ButtonAdd);
  if ButtonModify.Tag=1 then
    ButtonModifyClick(ButtonModify);
end;

end.
