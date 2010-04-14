unit Ut_CSInfoMag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Grids, BaseGrid, AdvGrid,
  AdvGridUnit,Ut_Common,DBClient, cxGraphics, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit,StringUtils;

type
  TFm_CSInfoMag = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    AdvStringGrid1: TAdvStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Edt_Survery: TEdit;
    Edt_Net: TEdit;
    Edt_Address: TEdit;
    Label3: TLabel;
    Btn_Add: TButton;
    Btn_Modify: TButton;
    Btn_Del: TButton;
    Btn_Clear: TButton;
    Btn_Quit: TButton;
    Label4: TLabel;
    EditCSID: TEdit;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Label5: TLabel;
    ComboBoxCSType: TComboBox;
    Label6: TLabel;
    ComboBoxBuilding: TcxComboBox;
    Label7: TLabel;
    EditCover: TEdit;
    ButtonOK: TButton;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure Btn_ClearClick(Sender: TObject);
    procedure Btn_QuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DelClick(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
    AdvGridset:TAdvGridset;
    procedure ClearText;
    function  CSRepeatForAdd(Textname:String):Boolean;
    function  CSRepeatForModify(Textname:String):Boolean;
    procedure RefreshGrid;
    procedure EnableBtn;
    procedure SetTitle;
    procedure LoadFromGrid(aGrid:TAdvStringGrid;aRow :integer);
    function HasExist(aCSno:string;aCSid:integer=-1):boolean;
    procedure SaveToGrid(aGrid:TAdvStringGrid;aID:integer;aRow:integer=-1);
  public
    { Public declarations }
    CS_ID:integer;
    Building_Id:integer;
    procedure SetControl(IsEdit:Boolean);
    procedure UIChangeNormal;
    procedure RefreshBuilding(aCondition :String);
  end;

var
  Fm_CSInfoMag: TFm_CSInfoMag;
  OperateFlag:integer;
implementation

Uses Ut_MainForm,Ut_DataModule,Ut_MTSTreeHelper;
{$R *.dfm}

{ TFm_CSInfoMag }


procedure TFm_CSInfoMag.AdvStringGrid1Click(Sender: TObject);
begin
  if (Btn_Add.Tag=1) or (Btn_Modify.Tag=1) then
   //  if application.MessageBox('正在进行其他操作，是否取消该操作?', '提示', mb_okcancel + mb_defbutton1) = idCancel then
      exit
  else
      UIChangeNormal;
  if AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]='' then
    exit;
  LoadFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
end;

procedure TFm_CSInfoMag.Btn_AddClick(Sender: TObject);
begin
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='取消';
    SetControl(true);
    OperateFlag := ADDFLAG;
    Btn_Modify.Enabled := false;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='新增';
    SetControl(false);
    OperateFlag := CANCELFLAG;
    Btn_Modify.Enabled := true;
  end;
  ClearText;
end;

procedure TFm_CSInfoMag.Btn_ClearClick(Sender: TObject);
begin
  ClearText;
  ComboBoxBuilding.ItemIndex := -1;
end;

procedure TFm_CSInfoMag.Btn_DelClick(Sender: TObject);
begin
  if Edt_Survery.Text='' then
  begin
    application.MessageBox('请选择一条记录！', '提示', mb_ok);
    exit;
  end;
  if application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+mb_defbutton1)=IDOK then
  begin
    if DelFromGrid(StrToIntDef(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1],-1),51) then
    begin
       application.MessageBox('操作成功！', '提示', mb_ok);
       DeleteFromGrid(AdvStringGrid1,AdvStringGrid1.Row);
       ClearText;
    end
    else
       application.MessageBox('操作失败，请检查后重新操作！', '提示', mb_ok);
  end;
end;

procedure TFm_CSInfoMag.Btn_ModifyClick(Sender: TObject);
begin
  if (Edt_Survery.Text='') and (Btn_Modify.Tag=0) then
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
    Btn_Add.Enabled := false;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='修改';
    SetControl(false);
    OperateFlag := CANCELFLAG;
    Btn_Add.Enabled := true;
    ClearText;
  end;
end;

procedure TFm_CSInfoMag.Btn_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFm_CSInfoMag.ButtonOKClick(Sender: TObject);
var
  FCSID:INTEGER;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
  i:integer;
begin
  if (Edt_Survery.Text ='') or (ComboBoxBuilding.ItemIndex =-1) or (Edt_Net.Text ='') then
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
        if HasExist(Edt_Survery.Text) then
        begin
          application.MessageBox(pchar('已经存在堪点编号['+Edt_Survery.Text+']！'), '提示', mb_ok);
          exit;
        end;
        FCSID:=Dm_MTS.TempInterface.ProduceFlowNumID('CSID',1);
        if FCSID=-1 then
        begin
          application.MessageBox('连接数据库失败，请检查后重试！', '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,49,0]),0);
        append;
        FieldByName('CSID').Value := FCSID ;
      end
      else if OperateFlag=Modifyflag then
      begin
        FCSID:=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
        if HasExist(Edt_Survery.Text,FCSID) then
        begin
          application.MessageBox(pchar('已经存在堪点编号['+Edt_Survery.Text+']！'), '提示', mb_ok);
          exit;
        end;
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,51,FCSID]),0);
        edit;
      end;

      FieldByName('SURVERY_ID').Value:=Edt_Survery.Text;
      FieldByName('CS_ID').Value:=EditCSID.Text;
      FieldByName('cs_type').Value:=GetIdFromObj(ComboBoxCSType);
      FieldByName('NETADDRESS').Value:=Edt_Net.Text;
      FieldByName('CSADDR').Value:=Edt_Address.Text;
      FieldByName('CS_COVER').Value:=EditCover.Text;
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
              SaveToGrid(AdvStringGrid1,FCSID,1)
            else
              SaveToGrid(AdvStringGrid1,FCSID,AdvStringGrid1.RowCount);
          end
          else
          if OperateFlag=MODIFYFLAG then
             SaveToGrid(AdvStringGrid1,FCSID);
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

procedure TFm_CSInfoMag.ClearText;
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



function TFm_CSInfoMag.CSRepeatForAdd(Textname: String): Boolean;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,48,Textname]),0);
    if RecordCount >0 then
    result:=true
    else
    result:=false;
  end;
end;

function TFm_CSInfoMag.CSRepeatForModify(Textname: String): Boolean;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,50,CS_ID,Textname]),0);
    if RecordCount >0 then
    result:=true
    else
    result:=false;
  end;
end;

procedure TFm_CSInfoMag.EnableBtn;
begin
  Btn_Add.Enabled:=true;
  Btn_Modify.Enabled:=true;
  Btn_Del.Enabled:=true;
end;

procedure TFm_CSInfoMag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  AdvGridSet.Free;
  ClearTStrings(ComboBoxBuilding.Properties.Items);
  DestroyCBObj(ComboBoxCSType);
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Fm_CSInfoMag:=nil;
end;

procedure TFm_CSInfoMag.FormCreate(Sender: TObject);
begin
  AdvGridset:=TAdvGridset.Create;
  AdvGridset.AddGrid(AdvStringGrid1);
  AdvGridset.SetGridStyle;
  SetControl(false);
  ComboBoxBuilding.Properties.DropDownListStyle := lsFixedList;
end;

procedure TFm_CSInfoMag.FormShow(Sender: TObject);
begin
  GetDic(20,ComboBoxCSType.Items); //基站类型
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,ComboBoxBuilding.Properties.Items);
  ComboBoxCSType.ItemIndex := -1;
  ComboBoxBuilding.ItemIndex := -1;
  SetTitle;
end;

function TFm_CSInfoMag.HasExist(aCSno: string; aCSid: integer): boolean;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    if aCSid=-1 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,76,'where upper(survery_id)='+quotedstr(uppercase(aCSno))+'']),0)
    else if aCSid>0 then
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,76,'where upper(survery_id)='+quotedstr(uppercase(aCSno))+' and csid<>'+inttostr(aCSid)+'']),0);
  end;
  if Dm_MTS.cds_common.RecordCount>0 then
    result:=true
  else
    result:=false;
end;

procedure TFm_CSInfoMag.LoadFromGrid(aGrid: TAdvStringGrid; aRow: integer);
begin
  EditCSID.Text := aGrid.Rows[aRow].Strings[2];
  Edt_Survery.Text := aGrid.Rows[aRow].Strings[3];
  ComboBoxCSType.ItemIndex := ComboBoxCSType.Items.IndexOf(aGrid.Rows[aRow].Strings[4]);
  ComboBoxBuilding.ItemIndex := ComboBoxBuilding.Properties.Items.IndexOf(aGrid.Rows[aRow].Strings[8]);
  Edt_Address.Text := aGrid.Rows[aRow].Strings[6];
  Edt_Net.Text := aGrid.Rows[aRow].Strings[5];
  EditCover.Text := aGrid.Rows[aRow].Strings[7];
end;

procedure TFm_CSInfoMag.RefreshBuilding(aCondition: String);
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,31,aCondition]),0);
    AdvGridset.DrawGrid(Dm_MTS.cds_common,AdvStringGrid1);
    if recordcount>0 then
    begin
      AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
      AdvStringGrid1.ColWidths[1]:=0;
    end;
  end;
end;

procedure TFm_CSInfoMag.RefreshGrid;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,1,47,Building_ID]),0); //选地市层
    if RecordCount >0 then
    begin
    AdvGridset.DrawGrid(Dm_MTS.cds_common,AdvStringGrid1);
    end;
  end;
end;

procedure TFm_CSInfoMag.SaveToGrid(aGrid: TAdvStringGrid; aID, aRow: integer);
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
  aGrid.Rows[lRow].Strings[2]:=EditCSID.Text;
  aGrid.Rows[lRow].Strings[3]:=Edt_Survery.Text;
  aGrid.Rows[lRow].Strings[4]:=ComboBoxCSType.Text;
  aGrid.Rows[lRow].Strings[5]:=Edt_Net.Text;
  aGrid.Rows[lRow].Strings[6]:=Edt_Address.Text;
  aGrid.Rows[lRow].Strings[7]:=EditCover.Text;
  aGrid.Rows[lRow].Strings[8]:=ComboBoxBuilding.Text;
  aGrid.Row:=lRow;
end;

procedure TFm_CSInfoMag.SetControl(IsEdit: Boolean);
var
  i : integer;
begin
  for I := 0 to GroupBox1.ControlCount - 1 do
  begin
    if (GroupBox1.Controls[i] is TEdit) or (GroupBox1.Controls[i] is TComboBox)
       or (GroupBox1.Controls[i] is TcxComboBox) then
        GroupBox1.Controls[i].Enabled := IsEdit;
  end;
  ButtonOK.Enabled :=IsEdit;
  Btn_Del.Enabled := not(IsEdit);

end;

procedure TFm_CSInfoMag.SetTitle;
var
  I: Integer;
begin
  AdvStringGrid1.ColCount := 10;
  AdvStringGrid1.RowCount := 2;
  AdvStringGrid1.Rows[0].Strings[1] := '';
  AdvStringGrid1.Rows[0].Strings[2] := 'CS_ID';
  AdvStringGrid1.Rows[0].Strings[3] := '堪点编号';
  AdvStringGrid1.Rows[0].Strings[4] := '基站类型';
  AdvStringGrid1.Rows[0].Strings[5] := '网元信息';
  AdvStringGrid1.Rows[0].Strings[6] := '基站地址';
  AdvStringGrid1.Rows[0].Strings[7] := '覆盖范围';
  AdvStringGrid1.Rows[0].Strings[8] := '所属室分点';
  AdvStringGrid1.Rows[0].Strings[9] := '';
  AdvStringGrid1.ColCount:=AdvStringGrid1.ColCount-1;
  AdvStringGrid1.ColWidths[1]:=0;
  for I := 2 to AdvStringGrid1.ColCount - 1 do
  begin
    AdvStringGrid1.AutoSizeCol(i);
  end;
end;

procedure TFm_CSInfoMag.UIChangeNormal;
begin
  if Btn_Add.Tag=1 then
    Btn_AddClick(Btn_Add);
  if Btn_Modify.Tag=1 then
    Btn_ModifyClick(Btn_Modify);
end;

end.
