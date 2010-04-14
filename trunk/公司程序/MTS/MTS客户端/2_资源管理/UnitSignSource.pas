unit UnitSignSource;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, BaseGrid, AdvGrid, ExtCtrls, Buttons, AdvGridUnit, DBClient, StringUtils,
  cxGraphics, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit;

type
  TFormSignSource = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    Panel1: TPanel;
    Panel2: TPanel;
    AdvStringGrid1: TAdvStringGrid;
    Label20: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    ComboBoxSourceType: TComboBox;
    EditSourceNo: TEdit;
    EditSourceName: TEdit;
    EditSourcePosition: TEdit;
    EditCoverRangle: TEdit;
    ComboBoxEqiupModel: TComboBox;
    EditMSCNo: TEdit;
    EditBSCNo: TEdit;
    EditSectorNo: TEdit;
    EditCSNo: TEdit;
    EditPNNo: TEdit;
    ComboBoxPower: TComboBox;
    ComboBoxproductor: TComboBox;
    BitBtnADD: TBitBtn;
    BitBtnAlter: TBitBtn;
    BitBtnQuery: TBitBtn;
    BitBtnDelete: TBitBtn;
    BitBtnClose: TBitBtn;
    BitBtnOK: TBitBtn;
    BitBtnClear: TBitBtn;
    Label23: TLabel;
    Label24: TLabel;
    GroupBox1: TGroupBox;
    ComboBoxBuilding: TcxComboBox;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtnClearClick(Sender: TObject);
    procedure BitBtnADDClick(Sender: TObject);
    procedure BitBtnAlterClick(Sender: TObject);
    procedure BitBtnQueryClick(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnDeleteClick(Sender: TObject);
    procedure ComboBoxBuildingPropertiesChange(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
  private
    FAdvGridSet:TAdvGridSet;
    function HasExist(aCDMAno:string;aCDMAid:integer=-1):boolean;
    function InitiaGrid(aDBClient:TClientDataSet;aGrid:TAdvStringGrid):boolean;
    procedure GetBranchAndArea(aBuildingid:integer;aBranchItem,aAreaItem:TStrings);
    procedure SetTitle;
    procedure SaveToGrid(aGrid:TAdvStringGrid;aID:integer;aRow:integer=-1);
    procedure LoadFromGrid(aGrid:TAdvStringGrid;aRow :integer);
  public
    procedure UIChangeNormal;
    procedure ClearText;
    procedure SetControl(IsEdit:Boolean);
    procedure RefreshBuilding(aCondition :String);

  end;

var
  FormSignSource: TFormSignSource;
  OperateFlag:integer;

implementation
uses Ut_MainForm, Ut_Common, Ut_DataModule;
{$R *.dfm}

procedure TFormSignSource.AdvStringGrid1Click(Sender: TObject);
begin
  if (BitBtnADD.Tag=1) or (BitBtnAlter.Tag=1) or (BitBtnQuery.Tag=1) then
   //  if application.MessageBox('正在进行其他操作，是否取消该操作?', '提示', mb_okcancel + mb_defbutton1) = idCancel then
      exit
  else
      UIChangeNormal;
  if AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]='' then
    exit;
  LoadFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
end;

procedure TFormSignSource.BitBtnADDClick(Sender: TObject);
begin
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    OperateFlag := ADDFLAG;
    BitBtnAlter.Enabled := false;
    BitBtnQuery.Enabled := false;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='新增';
    SetControl(false);
    OperateFlag := CANCELFLAG;
    BitBtnAlter.Enabled := true;
    BitBtnQuery.Enabled := true;
  end;
  ClearText;
end;

procedure TFormSignSource.BitBtnAlterClick(Sender: TObject);
begin
  if (EditSourceNo.Text='') and (BitBtnAlter.Tag=0) then
  begin
    application.MessageBox('请选择一条记录！', '提示', mb_ok);
    exit;
  end;
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    OperateFlag := MODIFYFLAG;
    BitBtnADD.Enabled := false;
    BitBtnQuery.Enabled := false;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='修改';
    SetControl(false);
    OperateFlag := CANCELFLAG;
    BitBtnADD.Enabled := true;
    BitBtnQuery.Enabled := true;
    ClearText;
  end;
end;

procedure TFormSignSource.BitBtnClearClick(Sender: TObject);
begin
  ClearText;
  ComboBoxBuilding.ItemIndex := -1;
end;

procedure TFormSignSource.BitBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSignSource.BitBtnDeleteClick(Sender: TObject);
begin
  if EditSourceNo.Text='' then
  begin
    application.MessageBox('请选择一条记录！', '提示', mb_ok);
    exit;
  end;
  if application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+mb_defbutton1)=IDOK then
  begin
    if DelFromGrid(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),69) then
    begin
       application.MessageBox('操作成功！', '提示', mb_ok);
       DeleteFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
       ClearText;
    end
    else
       application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
  end;
end;

procedure TFormSignSource.BitBtnOKClick(Sender: TObject);
var
  FCDMAID : Integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
  lCondition : string;
begin
  if OperateFlag=Queryflag then
  begin
    lCondition := GetPriveArea(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid);
    lCondition := ' and t.areaid in ('+lCondition+')';
    if EditSourceNo.Text<>'' then
       lCondition := lCondition+' and cdmano like ''%'+Trim(EditSourceNo.Text)+'%''';
    if EditSourceName.Text<>'' then
       lCondition := lCondition+' and cdmaname like ''%'+Trim(EditSourceName.Text)+'%''';
    if ComboBoxBuilding.ItemIndex<>-1 then
       lCondition := lCondition+' and buildingname= '+QuotedStr(Trim(ComboBoxBuilding.Text));
    RefreshBuilding(lCondition);
    UIChangeNormal;
    ClearText;
    LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxBuilding.Properties.Items);
    Exit;
  end;
  
  if (ComboBoxSourceType.ItemIndex=-1) or (EditSourceNo.Text='') or (EditSourceName.Text='')
     or (EditSourcePosition.Text='') or (ComboBoxBuilding.ItemIndex=-1) or (EditCoverRangle.Text='') then
  begin
    application.MessageBox('请完善必填项！', '提示', mb_ok);
    exit;
  end;

  try
  begin
    Screen.Cursor := crHourGlass;
    with Dm_MTS.cds_common do
    begin
      if OperateFlag=ADDflag then
      begin
        if HasExist(EditSourceNo.Text) then
        begin
          application.MessageBox(pchar('已经存在C网信源编号['+EditSourceNo.Text+']！'), '提示', mb_ok);
          exit;
        end;
        FCDMAID:=Dm_MTS.TempInterface.ProduceFlowNumID('CDMAID',1);
        if FCDMAID=-1 then
        begin
          application.MessageBox('连接数据库失败，请检查后重试！', '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,68,0]),0);
        append;
        FieldByName('CDMAID').Value := FCDMAID;
      end
      else if OperateFlag=Modifyflag then
      begin
        FCDMAID:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
        if HasExist(EditSourceNo.Text,FCDMAID) then
        begin
          application.MessageBox(pchar('已经存在C网信源编号['+EditSourceNo.Text+']！'), '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,69,FCDMAID]),0);
        edit;
      end;
      if (ComboBoxBuilding.Properties.Items.Count>0) and (ComboBoxBuilding.ItemIndex<>-1) then
          FieldByName('BUILDINGID').Value:=TCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID;
      FieldByName('CDMANO').Value := trim(EditSourceNo.Text);
      FieldByName('CDMANAME').Value := trim(EditSourceName.Text);
      FieldByName('CDMATYPE').Value := GetIdFromObj(ComboBoxSourceType);
      FieldByName('BELONG_BTS').Value := trim(EditCSNo.Text);
      FieldByName('BELONG_MSC').Value := trim(EditMSCNo.Text);
      FieldByName('BELONG_BSC').Value := trim(EditBSCNo.Text);
      FieldByName('BELONG_CELL').Value := trim(EditSectorNo.Text);
      FieldByName('PNCODE').Value := trim(EditPNNo.Text);
      FieldByName('DEVICETYPE').Value := GetIdFromObj(ComboBoxEqiupModel);
      FieldByName('FACTORY').Value := GetIdFromObj(ComboBoxproductor);
      FieldByName('POWER').Value := GetIdFromObj(ComboBoxPower);
      FieldByName('ADDRESS').Value := trim(EditSourcePosition.Text);
      FieldByName('COVER').Value := trim(EditCoverRangle.Text);
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
            SaveToGrid(AdvStringGrid1,FCDMAID,1)
          else
            SaveToGrid(AdvStringGrid1,FCDMAID,AdvStringGrid1.RowCount);
        end
        else
        if OperateFlag=MODIFYFLAG then
           SaveToGrid(AdvStringGrid1,FCDMAID);
        UIChangeNormal;
        ClearText;
      except
        application.MessageBox('保存失败，请检查后重试！', '提示', mb_ok);
      end;
    end;
  end;
  finally
    Screen.Cursor := crDefault ;
  end;
end;

procedure TFormSignSource.BitBtnQueryClick(Sender: TObject);
begin
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(false);
    EditSourceNo.Enabled := true;
    EditSourceName.Enabled := true;
    ComboBoxBuilding.Enabled := true;
    Label11.Font.Color := clRed;
    Label12.Font.Color := clRed;
    Label5.Font.Color := clRed;
    OperateFlag := QUERYFLAG;
    BitBtnADD.Enabled := false;
    BitBtnAlter.Enabled := false;
    BitBtnOK.Enabled := True;
    ComboBoxBuilding.Properties.DropDownListStyle := lsEditList;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='查询';
    SetControl(false);
    Label11.Font.Color := clWindowText;
    Label12.Font.Color := clWindowText;
    Label5.Font.Color := clWindowText;
    OperateFlag := CANCELFLAG;
    BitBtnADD.Enabled := true;
    BitBtnAlter.Enabled := true;
    ComboBoxBuilding.Properties.DropDownListStyle := lsFixedList;
    LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxBuilding.Properties.Items);
  end;
  ClearText;
end;

procedure TFormSignSource.ClearText;
var
  i : integer;
begin
  for I := 0 to GroupBox1.ControlCount - 1 do
  begin
    if (GroupBox1.Controls[i] is TEdit) then
      (GroupBox1.Controls[i] as TEdit).Text :=''
    else if(GroupBox1.Controls[i] is TComboBox)then
      (GroupBox1.Controls[i] as TComboBox).ItemIndex :=-1;
  end;
end;

procedure TFormSignSource.ComboBoxBuildingPropertiesChange(Sender: TObject);
begin
  if OperateFlag=Queryflag then
  begin
    DarkMatch_BUILDING(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,'buildingname',ComboBoxBuilding.Text,ComboBoxBuilding.Properties.Items);
  end;
end;

procedure TFormSignSource.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyCBObj(ComboBoxSourceType);
  ClearTStrings(ComboBoxBuilding.Properties.Items);
  DestroyCBObj(ComboBoxPower);
  DestroyCBObj(ComboBoxproductor);
  DestroyCBObj(ComboBoxEqiupModel);
  FAdvGridSet.Free;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormSignSource:=nil;
end;

procedure TFormSignSource.FormCreate(Sender: TObject);
begin
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(AdvStringGrid1);
  FAdvGridSet.SetGridStyle;
  SetControl(false);
  ComboBoxBuilding.Properties.DropDownListStyle := lsFixedList;
  {if not InitiaGrid(Dm_MTS.cds_common,AdvStringGrid1) then
  begin
    application.MessageBox('获取数据失败，请检查数据库连接是否正常！', '提示', MB_ICONINFORMATION+MB_OK);
    exit;
  end;}
end;

procedure TFormSignSource.FormShow(Sender: TObject);
begin
  //初始化ComboBox
  GetDic(14,ComboBoxSourceType.Items);  //C网信源类型
  GetDic(17,ComboBoxPower.Items);      //C网信源功率
  GetDic(16,ComboBoxproductor.Items); //C网信源厂家
  GetDic(15,ComboBoxEqiupModel.Items);//信源设备型号
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxBuilding.Properties.Items);
  ComboBoxSourceType.ItemIndex := -1;
  ComboBoxPower.ItemIndex := -1;
  ComboBoxproductor.ItemIndex := -1;
  ComboBoxEqiupModel.ItemIndex := -1;
  ComboBoxBuilding.ItemIndex := -1;
  SetTitle;
end;

procedure TFormSignSource.GetBranchAndArea(aBuildingid: integer; aBranchItem,
  aAreaItem: TStrings);
var
  lBranchid,lAreaid:Integer;
  lBranchname,lAreaname:string;
  obj1,obj2: TCommonObj;
begin
  ClearTStrings(aBranchItem);
  ClearTStrings(aAreaItem);
  with DM_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,70,aBuildingid]),0);
    while not eof do
    begin
      obj1 :=TCommonObj.Create;
      obj1.ID:=FieldByName('suburbid').Value;
      obj1.Name:=FieldByName('suburbname').Value;
      aBranchItem.AddObject(obj1.Name,obj1);
      obj2 :=TCommonObj.Create;
      obj2.ID:=FieldByName('areaid').Value;
      obj2.Name:=FieldByName('areaname').Value;
      aAreaItem.AddObject(obj2.Name,obj2);
      next;
    end;
    Close;
  end;
end;

function TFormSignSource.HasExist(aCDMAno: string; aCDMAid: integer): boolean;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if aCDMAid=-1 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,67,'where upper(cdmano)='+quotedstr(uppercase(aCDMAno))+'']),0)
    else if aCDMAid>0 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,67,'where upper(cdmano)='+quotedstr(uppercase(aCDMAno))+' and cdmaid<>'+inttostr(aCDMAid)+'']),0);
  end;
  if Dm_MTS.cds_common.RecordCount>0 then
    result:=true
  else
    result:=false;
end;

function TFormSignSource.InitiaGrid(aDBClient: TClientDataSet;
  aGrid: TAdvStringGrid): boolean;
begin
 { Result := False;
  try
    with aDBClient do
    begin
      close;
      ProviderName:='dsp_General_data';
     // Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,37,fareas]),0);
      FAdvGridSet.DrawGrid(aDBClient,aGrid);
      if recordcount>0 then
      begin
        //

      end;
      result := True;
    end;
  except
    //
  end;  }
end;

procedure TFormSignSource.LoadFromGrid(aGrid: TAdvStringGrid; aRow: integer);
begin
  EditSourceNo.Text := aGrid.Rows[aRow].Strings[2];
  EditSourceName.Text := aGrid.Rows[aRow].Strings[3];
  ComboBoxSourceType.ItemIndex := ComboBoxSourceType.Items.IndexOf(aGrid.Rows[aRow].Strings[4]);
  EditSourcePosition.Text := aGrid.Rows[aRow].Strings[5];
  EditCoverRangle.Text := aGrid.Rows[aRow].Strings[6];
  ComboBoxproductor.ItemIndex := ComboBoxproductor.Items.IndexOf(aGrid.Rows[aRow].Strings[7]);
  ComboBoxEqiupModel.ItemIndex := ComboBoxEqiupModel.Items.IndexOf(aGrid.Rows[aRow].Strings[8]);
  EditMSCNo.Text := aGrid.Rows[aRow].Strings[9];
  EditBSCNo.Text := aGrid.Rows[aRow].Strings[10];
  EditSectorNo.Text := aGrid.Rows[aRow].Strings[11];
  EditCSNo.Text := aGrid.Rows[aRow].Strings[12];
  EditPNNo.Text := aGrid.Rows[aRow].Strings[13];
  ComboBoxPower.ItemIndex := ComboBoxPower.Items.IndexOf(aGrid.Rows[aRow].Strings[14]);
  ComboBoxBuilding.ItemIndex := ComboBoxBuilding.Properties.Items.IndexOf(aGrid.Rows[aRow].Strings[15]);
end;

procedure TFormSignSource.RefreshBuilding(aCondition: String);
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,26,aCondition]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,AdvStringGrid1);
    if recordcount>0 then
    begin
      AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
      AdvStringGrid1.ColWidths[1]:=0;
    end;
  end;
end;

procedure TFormSignSource.SaveToGrid(aGrid: TAdvStringGrid; aID, aRow: integer);
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
  aGrid.Rows[lRow].Strings[2]:=EditSourceNo.Text;
  aGrid.Rows[lRow].Strings[3]:=EditSourceName.Text;
  aGrid.Rows[lRow].Strings[4]:=ComboBoxSourceType.Text;
  aGrid.Rows[lRow].Strings[5]:=EditSourcePosition.Text;
  aGrid.Rows[lRow].Strings[6]:=EditCoverRangle.Text;
  aGrid.Rows[lRow].Strings[7]:=ComboBoxproductor.Text;
  aGrid.Rows[lRow].Strings[8]:=ComboBoxEqiupModel.Text;
  aGrid.Rows[lRow].Strings[9]:=EditMSCNo.Text;
  aGrid.Rows[lRow].Strings[10]:=EditBSCNo.Text;
  aGrid.Rows[lRow].Strings[11]:=EditSectorNo.Text;
  aGrid.Rows[lRow].Strings[12]:=EditCSNo.Text;
  aGrid.Rows[lRow].Strings[13]:=EditPNNo.Text;
  aGrid.Rows[lRow].Strings[14]:=ComboBoxPower.Text;
  aGrid.Rows[lRow].Strings[15]:=ComboBoxBuilding.Text;
  aGrid.Rows[lRow].Strings[16]:=IntToStr(TCommonObj(ComboBoxBuilding.Properties.Items.Objects[ComboBoxBuilding.ItemIndex]).ID);
  aGrid.Row:=lRow;
end;

procedure TFormSignSource.SetControl(IsEdit: Boolean);
var
  i : integer;
begin
  for I := 0 to GroupBox1.ControlCount - 1 do
  begin
    if (GroupBox1.Controls[i] is TEdit) or (GroupBox1.Controls[i] is TComboBox)
       or (GroupBox1.Controls[i] is TcxComboBox) then
        GroupBox1.Controls[i].Enabled := IsEdit;
  end;
  BitBtnOK.Enabled :=IsEdit;
  BitBtnDelete.Enabled := not(IsEdit);
end;

procedure TFormSignSource.SetTitle;
var
  I: Integer;
begin
  AdvStringGrid1.ColCount := 17;
  AdvStringGrid1.RowCount := 2;
  AdvStringGrid1.Rows[0].Strings[1] := '';
  AdvStringGrid1.Rows[0].Strings[2] := 'C网信源编号';
  AdvStringGrid1.Rows[0].Strings[3] := 'C网信源名称';
  AdvStringGrid1.Rows[0].Strings[4] := 'C网信源类型';
  AdvStringGrid1.Rows[0].Strings[5] := 'C网信源安装位置';
  AdvStringGrid1.Rows[0].Strings[6] := 'C网信源覆盖范围';
  AdvStringGrid1.Rows[0].Strings[7] := 'C网信源厂家';
  AdvStringGrid1.Rows[0].Strings[8] := '信源设备型号';
  AdvStringGrid1.Rows[0].Strings[9] := '归属MSC编号';
  AdvStringGrid1.Rows[0].Strings[10] := '归属BSC编号';
  AdvStringGrid1.Rows[0].Strings[11] := '归属扇区编号';
  AdvStringGrid1.Rows[0].Strings[12] := '归属基站编号';
  AdvStringGrid1.Rows[0].Strings[13] := 'PN码';
  AdvStringGrid1.Rows[0].Strings[14] := 'C网信源功率';
  AdvStringGrid1.Rows[0].Strings[15] := '所属室分点';
  AdvStringGrid1.Rows[0].Strings[16] := '';
  AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
  AdvStringGrid1.ColWidths[1]:=0;
  for I := 2 to AdvStringGrid1.ColCount - 1 do
  begin
    AdvStringGrid1.AutoSizeCol(i);
  end;
end;

procedure TFormSignSource.UIChangeNormal;
begin
  if BitBtnADD.Tag=1 then
    BitBtnADDClick(BitBtnADD);
  if BitBtnAlter.Tag=1 then
    BitBtnAlterClick(BitBtnAlter);
  if BitBtnQuery.Tag=1 then
    BitBtnQueryClick(BitBtnQuery);
end;

end.
