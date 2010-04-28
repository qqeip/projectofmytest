unit UnitAlarmContentMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxListBox, cxControls, cxContainer,
  cxEdit, cxGroupBox, StdCtrls, CheckLst, Buttons, ComCtrls, cxListView,
  cxTextEdit, cxLabel, DBClient, StringUtils, Menus, cxButtons, cxPC,
  cxGraphics, cxCheckBox, cxSpinEdit, cxSpinButton, cxMaskEdit,
  cxDropDownEdit, ExtCtrls, Spin, ImgList, jpeg, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, CxGridUnit,
  cxGridDBTableView, cxGrid,UDevExpressToChinese;

type TAlarmTable=(ALARM_CONTENT_INFO,ALARM_CONTENT_RULE);
type
  TAlarmObject= class
    code: Integer;
    Name: string;
    ALARMTYPE: Integer;
  end;

type
    TMasterAlarm = record
    Count: integer;    //存在在线告警的数量
    IsExsitAlarm: boolean; //是否存在在线告警
    AlarmCodeStr: string;  //告警编号字符串
  end;
  TFormAlarmContentMgr = class(TForm)
    cxGroupBox3: TcxGroupBox;
    cxListViewCombAlaimInfo: TcxListView;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxGroupBox1: TcxGroupBox;
    cxListViewCombAlarm: TcxListView;
    cxGroupBox2: TcxGroupBox;
    CheckListBoxAlarmContent: TCheckListBox;
    cxGroupBox4: TcxGroupBox;
    cxLabel1: TcxLabel;
    AlarmEdtSearch: TcxTextEdit;
    Panel2: TPanel;
    bt_fromgroup: TSpeedButton;
    bt_togroup: TSpeedButton;
    Panel3: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    ImageTree: TImageList;
    ImageList1: TImageList;
    Image4: TImage;
    PopupMenu1: TPopupMenu;
    Menu_Add: TMenuItem;
    Menu_Modify: TMenuItem;
    Menu_Del: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    cxGroupBox7: TcxGroupBox;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxTextEditCombName: TcxTextEdit;
    cxComboBoxCombType: TcxComboBox;
    cxBtnOK: TcxButton;
    cxBtnCancel: TcxButton;
    PopupMenu2: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N5: TMenuItem;
    cxTabSheet3: TcxTabSheet;
    cxGroupBox8: TcxGroupBox;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    Image5: TImage;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    cxGroupBox9: TcxGroupBox;
    BtnSearch: TSpeedButton;
    cxLabel15: TcxLabel;
    EdtSearch: TcxTextEdit;
    Panel4: TPanel;
    cxComboBoxMode: TcxComboBox;
    BtnOK: TcxButton;
    SpinEditRemove: TSpinEdit;
    cxComboBoxLevel: TcxComboBox;
    cxComboBoxType: TcxComboBox;
    SpinEditAlarm: TSpinEdit;
    Splitter1: TSplitter;
    CheckBoxLevel: TCheckBox;
    CheckBoxType: TCheckBox;
    CheckBoxMode: TCheckBox;
    CheckBoxRemove: TCheckBox;
    CheckBoxAlarm: TCheckBox;
    CheckBoxEffect: TCheckBox;
    CheckBoxWrecker: TCheckBox;
    CheckBoxCommit: TCheckBox;
    cxComboBoxEffect: TcxComboBox;
    cxComboBoxWrecker: TcxComboBox;
    cxComboBoxCommit: TcxComboBox;
    SpeedButtonSearch: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cxListViewCombAlarmClick(Sender: TObject);
    procedure bt_fromgroupClick(Sender: TObject);
    procedure bt_togroupClick(Sender: TObject);
    procedure SaveChange;
    procedure Menu_AddClick(Sender: TObject);
    procedure Menu_ModifyClick(Sender: TObject);
    procedure Menu_DelClick(Sender: TObject);
    procedure cxBtnOKClick(Sender: TObject);
    procedure cxBtnCancelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure cxGrid1DBTableView1SelectionChanged(Sender: TcxCustomGridTableView);
    procedure CheckBoxLevelClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure EdtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure SpeedButtonSearchClick(Sender: TObject);
    procedure AlarmEdtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure CheckListBoxAlarmContentClick(Sender: TObject);
  private
    FOperateFlag : Integer;
    FCxGridHelper : TCxGridSet;
    procedure LoadCombAlarm(aListView: TcxListView; aSqlType,aSqlBH: Integer; aWhereStr: string);
    procedure InitAlarmSet(aCheckListBox: TCheckListBox);
    procedure DestoryListView(aListView: TcxListView);
    procedure SelectBox(aBox: TCheckListBox; aKeyid: integer);
    procedure SetCheckedStatus(aBox: TCheckListBox; aBool: Boolean);
    function IsExistsAlarm(aCombAlarm, aFieldValue: string): boolean;
    procedure setCombEnabled(aBool: Boolean);
    procedure AllCheck(Sender: TChecklistbox);
    procedure ReverseCheck(Sender: TChecklistbox);
    function  UpdateSetInfo(aTable: TAlarmTable): string;
    procedure InitAlarmSetInfo;
    function IsExsitMasterAlarm(aCityid: Integer): TMasterAlarm;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAlarmContentMgr: TFormAlarmContentMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormAlarmContentMgr.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);

  CheckListBoxAlarmContent.ShowHint:= True;
  CheckListBoxAlarmContent.Hint:= '';
end;

procedure TFormAlarmContentMgr.FormShow(Sender: TObject);
begin
  LoadCombAlarm(cxListViewCombAlarm,1,221,'');
  InitAlarmSet(CheckListBoxAlarmContent);

  GetDicItem(gPublicParam.cityid,3,cxComboBoxLevel.Properties.Items);
  GetDicItem(gPublicParam.cityid,2,cxComboBoxType.Properties.Items);
  GetDicItem(gPublicParam.cityid,2,cxComboBoxCombType.Properties.Items);
  AddViewField(cxGrid1DBTableView1,'alarmcontentcode','告警编号');
  AddViewField(cxGrid1DBTableView1,'alarmcontentname','告警名称');
  AddViewField(cxGrid1DBTableView1,'alarmlevel','告警等级');
  AddViewField(cxGrid1DBTableView1,'alarmtype','告警类型');
  AddViewField(cxGrid1DBTableView1,'sendtype','派障方式');
  AddViewField(cxGrid1DBTableView1,'iseffect','是否有效');
  AddViewField(cxGrid1DBTableView1,'isautowrecker','是否自动消障');
  AddViewField(cxGrid1DBTableView1,'isautosubmit','是否自动提交');
  AddViewField(cxGrid1DBTableView1,'alarmcount','告警门限');
  AddViewField(cxGrid1DBTableView1,'Removelimit','排障门限');
  InitAlarmSetInfo;
end;

procedure TFormAlarmContentMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormAlarmContentMgr,1,'','');
end;

procedure TFormAlarmContentMgr.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormAlarmContentMgr.LoadCombAlarm(aListView: TcxListView; aSqlType,aSqlBH: Integer; aWhereStr: string);
var
  i: Integer;
  lClientDataSet: TClientDataSet;
  lCombAlarmObject: TAlarmObject;
  newlistItem:TlistItem;
begin
  lClientDataSet:= TClientDataSet.create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=gTempInterface.GetCDSData(VarArrayOf([aSqlType,aSqlBH,aWhereStr]),0);//1,221
    first;
    i:= 0;
    while not Eof do
    begin
      lCombAlarmObject:=TAlarmObject.Create;
      lCombAlarmObject.code:= fieldbyname('ALARMCONTENTCODE').asInteger;
      lCombAlarmObject.Name:= fieldbyname('ALARMCONTENTNAME').AsString;
      lCombAlarmObject.ALARMTYPE:= fieldbyname('ALARMTYPE').AsInteger;
      newlistItem:=aListView.Items.Add;
      newlistItem.Data := lCombAlarmObject;
      newlistItem.Caption:=format('%.3d',[i]);
      newlistItem.SubItems.Add(FieldByName('ALARMCONTENTNAME').AsString);
      inc(i);
      Next;
    end;
  end;
end;

procedure TFormAlarmContentMgr.InitAlarmSetInfo;
begin
  DataSource1.DataSet:=nil;
  with ClientDataSet1 do
  begin
    close;
    ProviderName:= 'dsp_General_data';
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,'select * from AlarmSet_view order by alarmcontentcode']),0);
    Open;
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormAlarmContentMgr.InitAlarmSet(aCheckListBox: TCheckListBox);
var
  lClientDataSet: TClientDataSet;
  lAlarmObject: TWdInteger;
  lAlarmCaption: string;
begin
  ClearTStrings(aCheckListBox.Items);
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,12,gPublicParam.cityid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        lAlarmCaption:= FieldByName('ALARMCONTENTNAME').AsString+'['+inttostr(FieldByName('ALARMCONTENTCODE').AsInteger)+']';
        lAlarmObject:= TWdInteger.create(FieldByName('ALARMCONTENTCODE').AsInteger);
        aCheckListBox.Items.AddObject(lAlarmCaption,lAlarmObject);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;


procedure TFormAlarmContentMgr.cxListViewCombAlarmClick(Sender: TObject);
var
  lListItem: TListItem;
  lClientDataSet: TClientDataSet;
begin
  lListItem:= (Sender as TcxListView).Selected ;
  if lListItem=nil then exit;

  cxTextEditCombName.Text:= cxListViewCombAlarm.Selected.SubItems.Text;
  cxComboBoxCombType.ItemIndex:= GetItemIndexByObject(TAlarmObject(cxListViewCombAlarm.Selected.Data).ALARMTYPE,cxComboBoxCombType.Properties.Items); 

  DestoryListView(cxListViewCombAlaimInfo);
  LoadCombAlarm(cxListViewCombAlaimInfo,1,222,IntToStr(TAlarmObject(lListItem.Data).code));
  SetCheckedStatus(CheckListBoxAlarmContent,False);
  try
    cxListViewCombAlarm.Enabled:= False;
    CheckListBoxAlarmContent.Enabled:= False;
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,222,TAlarmObject(lListItem.Data).code]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        SelectBox(CheckListBoxAlarmContent,fieldbyname('ALARMCONTENTCODE').AsInteger);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
    cxListViewCombAlarm.Enabled:= True;
    CheckListBoxAlarmContent.Enabled:= True;    
  end;
end;

procedure TFormAlarmContentMgr.DestoryListView(aListView: TcxListView);
var
  i:Integer;
begin
  for i := 0 to aListView.Items.Count - 1 do
     TWdInteger(aListView.Items[i].Data).Free;
  aListView.Items.Clear;
end;

procedure TFormAlarmContentMgr.SelectBox(aBox: TCheckListBox; aKeyid: integer);
var
  I :integer;
begin
  for I := 0 to aBox.Items.Count -1 do
  begin
    if not aBox.Checked[I] then
    begin
      if TWdInteger(aBox.Items.Objects[I]).Value=aKeyid then
      begin
        aBox.Checked[I]:=True;
      end;
    end;
  end;
end;

procedure TFormAlarmContentMgr.SetCheckedStatus(aBox: TCheckListBox; aBool: Boolean);
var i: Integer;
begin
  for I:=0 to abox.Count-1 do
    aBox.Checked[i]:= aBool;
end;

procedure TFormAlarmContentMgr.bt_fromgroupClick(Sender: TObject);
var
  i, lCombAlarm, lAlarm: integer;
  lDestListItem: TListItem;
  lAlarmObject: TWdInteger;
begin
  if cxListViewCombAlarm.Selected=nil then
  begin
    Application.MessageBox('请选择组合告警','提示',MB_OK + 64);
    Exit;
  end;
  lCombAlarm:= TAlarmObject(cxListViewCombAlarm.Selected.data).code;
  for i := 0 to CheckListBoxAlarmContent.Items.Count - 1 do
  begin
    if CheckListBoxAlarmContent.Checked[i] then
    begin
      lAlarm:= TWdInteger(CheckListBoxAlarmContent.Items.Objects[i]).Value;
      if not IsExistsAlarm(IntToStr(lCombAlarm),IntToStr(lAlarm)) then
      begin
        lAlarmObject:= TWdInteger.create(lAlarm);
        lDestListItem :=cxListViewCombAlaimInfo.Items.Add;
        lDestListItem.Data :=lAlarmObject;
        lDestListItem.Caption := format('%.3d',[cxListViewCombAlaimInfo.Items.Count-1]);
        lDestListItem.SubItems.Add(CheckListBoxAlarmContent.Items[i]);
      end;
    end;
  end;
  SaveChange;
end;

procedure TFormAlarmContentMgr.bt_togroupClick(Sender: TObject);
var i: Integer;
begin
  for i:= cxListViewCombAlaimInfo.Items.Count-1 downto 0 do
    if cxListViewCombAlaimInfo.Items[i].Selected then
      cxListViewCombAlaimInfo.Items[i].Delete;
  SaveChange;
end;

function TFormAlarmContentMgr.IsExistsAlarm(aCombAlarm,aFieldValue: string): boolean;
var
  lDataSet: TClientDataSet;
  lSqlStr: string;
begin
  lDataSet:= TClientDataSet.Create(nil);
  try
    with lDataSet do
    begin
      close;
      ProviderName:='dsp_General_data';
      lSqlStr:= 'select 1 from alarm_content_comb_detail where alarmcontentcombcode='+
                aCombAlarm +
                'and alarmcontentcode=' + aFieldValue;
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if eof then
        result:= false
      else
        result:= true;
    end;
  finally
    lDataSet.Free;
  end;
end;

procedure TFormAlarmContentMgr.SaveChange;
var
  i, lCombAlarm: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lCombAlarm:= TAlarmObject(cxListViewCombAlarm.Selected.data).code;
  lVariant:= VarArrayCreate([0,cxListViewCombAlaimInfo.Items.Count],varVariant);
  lSqlstr:='delete from alarm_content_comb_detail where alarmcontentcombcode=' + IntToStr(lCombAlarm);
  lVariant[0]:= VarArrayOf([lSqlstr]);
  for i:=0 to cxListViewCombAlaimInfo.Items.Count-1 do
  begin
    lSqlstr:= 'insert into alarm_content_comb_detail(CITYID,ALARMCONTENTCOMBCODE,ALARMCONTENTCODE) values(' +
              IntToStr(gPublicParam.cityid) + ',' +
              IntToStr(lCombAlarm) + ',' +
              IntToStr(TWdInteger(cxListViewCombAlaimInfo.Items[i].Data).Value) + ')';
    lVariant[i+1]:= VarArrayOf([lSqlstr]);
  end;
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if not lsuccess then
    Application.MessageBox('保存失败','提示',MB_OK+64);
end;

procedure TFormAlarmContentMgr.AllCheck(Sender: TChecklistbox);
var i: Integer;
begin
  for i:=0 to Sender.Count-1 do
  begin
    Sender.Checked[i]:=True;
  end;
end;

procedure TFormAlarmContentMgr.ReverseCheck(Sender: TChecklistbox);
var i: Integer;
begin
  for i:=0 to Sender.Count-1 do
  begin
      Sender.Checked[i]:= not Sender.Checked[i];
  end;
end;

procedure TFormAlarmContentMgr.Menu_AddClick(Sender: TObject);
begin
  FOperateFlag:=1;
  setCombEnabled(True);
end;

procedure TFormAlarmContentMgr.Menu_ModifyClick(Sender: TObject);
begin
  FOperateFlag:=2;
  setCombEnabled(True);
end;

procedure TFormAlarmContentMgr.Menu_DelClick(Sender: TObject);
var
  lAlarmCode, i: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if cxListViewCombAlarm.Selected=nil then
  begin
    Application.MessageBox('请选择组合告警','提示',MB_OK + 64);
    Exit;
  end;
  lAlarmCode:= TAlarmObject(cxListViewCombAlarm.Selected.Data).code;
  lVariant:= VarArrayCreate([0,1],varVariant);
  lSqlstr:= 'delete from alarm_content_info where ALARMCONTENTCODE=' +
             IntToStr(lAlarmCode) +
            ' and ISCOMB=1 and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[0]:=VarArrayOf([lSqlstr]);
  lSqlstr:='delete from alarm_content_comb_detail where alarmcontentcombcode=' + IntToStr(lAlarmCode);
  lVariant[1]:=VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    for i:= cxListViewCombAlaimInfo.Items.Count-1 downto 0 do
      cxListViewCombAlaimInfo.Items[i].Delete;
    for i:= cxListViewCombAlarm.Items.Count-1 downto 0 do
      if cxListViewCombAlarm.Items[i].Selected then
         cxListViewCombAlarm.Items[i].Delete;
    Application.MessageBox('删除成功','提示',MB_OK+64);
  end
  else
    Application.MessageBox('删除失败','提示',MB_OK+64);
end;

procedure TFormAlarmContentMgr.cxBtnOKClick(Sender: TObject);
var
  lAlarmCode: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
  lCombAlarmObject: TAlarmObject;
  newlistItem:TlistItem;
begin
  if cxTextEditCombName.Text='' then
  begin
    Application.MessageBox('组合告警名称不能为空','提示',MB_OK + 64);
    Exit;
  end;
  if cxComboBoxCombType.ItemIndex=-1 then
  begin
    Application.MessageBox('请选择组合告警类型不能为空','提示',MB_OK + 64);
    Exit;
  end;
  if FOperateFlag=1 then
  begin
    if IsExists('alarm_content_info','ALARMCONTENTNAME',cxTextEditCombName.Text) then
    begin
      Application.MessageBox('该告警组名称已经存在!','提示',MB_OK+64);
      Exit;
    end;
    lAlarmCode:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr:= 'insert into alarm_content_info(ALARMCONTENTCODE,ALARMCONTENTNAME,ALARMKIND,ALARMTYPE,CITYID,ISCOMB) values(' +
              IntToStr(lAlarmCode) + ',''' +
              cxTextEditCombName.Text + ''',1,' +
              IntToStr(GetDicCode(cxComboBoxCombType.Text,cxComboBoxCombType.Properties.Items)) + ',' +
              IntToStr(gPublicParam.cityid) + ',1)';
    lVariant[0]:=VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      Application.MessageBox('新增成功','提示',MB_OK+64);
      lCombAlarmObject:=TAlarmObject.Create;
      lCombAlarmObject.code:= lAlarmCode;
      lCombAlarmObject.Name:= cxTextEditCombName.Text;
      lCombAlarmObject.ALARMTYPE:= GetDicCode(cxComboBoxCombType.Text,cxComboBoxCombType.Properties.Items);
      newlistItem:=cxListViewCombAlarm.Items.Add;
      newlistItem.Data := lCombAlarmObject;
      newlistItem.Caption:=format('%.3d',[cxListViewCombAlarm.Items.Count-1]);
      newlistItem.SubItems.Add(cxTextEditCombName.Text);
    end
    else
      Application.MessageBox('新增失败','提示',MB_OK+64);
  end;
  if FOperateFlag=2 then
  begin
    if cxListViewCombAlarm.Selected=nil then
    begin
      Application.MessageBox('请选择组合告警','提示',MB_OK + 64);
      Exit;
    end;
    lAlarmCode:= TAlarmObject(cxListViewCombAlarm.Selected.Data).code;
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr:= 'update alarm_content_info set ALARMCONTENTNAME=''' +
              cxTextEditCombName.Text + ''',' +
              ' ALARMTYPE=' + IntToStr(GetDicCode(cxComboBoxCombType.Text,cxComboBoxCombType.Properties.Items)) +
              ' where ALARMCONTENTCODE=' + IntToStr(lAlarmCode) +
              ' and ISCOMB=1 and CITYID=' + IntToStr(gPublicParam.cityid);
    lVariant[0]:=VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      Application.MessageBox('修改成功','提示',MB_OK+64);
      cxListViewCombAlarm.Selected.SubItems.Text:= cxTextEditCombName.Text;
      TAlarmObject(cxListViewCombAlarm.Selected.Data).Name:= cxTextEditCombName.Text;
      TAlarmObject(cxListViewCombAlarm.Selected.Data).ALARMTYPE:= GetDicCode(cxComboBoxCombType.Text,cxComboBoxCombType.Properties.Items);
    end
    else
      Application.MessageBox('修改失败','提示',MB_OK+64);
  end;
  setCombEnabled(False);
end;

procedure TFormAlarmContentMgr.cxBtnCancelClick(Sender: TObject);
begin
  setCombEnabled(False);
end;

procedure TFormAlarmContentMgr.setCombEnabled(aBool: Boolean);
var i: Integer;
begin
  for i:=0 to cxGroupBox7.ControlCount-1 do
  begin
    cxGroupBox7.Controls[i].Enabled:= aBool;
  end;
end;

procedure TFormAlarmContentMgr.N1Click(Sender: TObject);
begin
  AllCheck(CheckListBoxAlarmContent);
end;

procedure TFormAlarmContentMgr.N5Click(Sender: TObject);
begin
  ReverseCheck(CheckListBoxAlarmContent);
end;





{        告警设置新页面           }



function TFormAlarmContentMgr.UpdateSetInfo(aTable: TAlarmTable): string;
var Str: string;
    lAlarmLevel,lAlarmType ,lAlarmCount, lSendType, lRemoveLimit, lIsAutoWrecker, lIsEffect, lIsAutoSubmit: Integer;
begin
  case aTable of
    ALARM_CONTENT_INFO:
    begin
      if CheckBoxType.Checked then
        if cxComboBoxType.ItemIndex=-1 then
        begin
          Application.MessageBox('请先选择告警类型！','提示',MB_OK+64);
          Exit;
        end
        else
        begin
          lAlarmType   := GetDicCode(cxComboBoxType.Text,cxComboBoxType.Properties.Items);
          Str:= Str + ',ALARMTYPE=' + IntToStr(lAlarmType);
        end;
    end;
    ALARM_CONTENT_RULE:
    begin
      if CheckBoxLevel.Checked then
        if cxComboBoxLevel.ItemIndex=-1 then
        begin
          Application.MessageBox('请先选择告警等级！','提示',MB_OK+64);
          Exit ;
        end
        else
        begin
          lAlarmLevel  := GetDicCode(cxComboBoxLevel.Text,cxComboBoxLevel.Properties.Items);
          Str:= Str + ',ALARMLEVEL=' + IntToStr(lAlarmLevel);
        end;
      if CheckBoxMode.Checked then
        if cxComboBoxMode.ItemIndex=-1 then
        begin
          Application.MessageBox('请先选择派障方式！','提示',MB_OK+64);
          Exit;
        end
        else
        begin
          lSendType := cxComboBoxMode.Properties.Items.IndexOf(cxComboBoxMode.Text)+1;
          Str:= Str + ',SENDTYPE=' + IntToStr(lSendType) ;
        end;
      if CheckBoxRemove.Checked then
      begin
        lRemoveLimit := SpinEditRemove.Value;
        Str:= Str + ',REMOVELIMIT=' + IntToStr(lRemoveLimit);
      end;
      if CheckBoxAlarm.Checked then
      begin
        lAlarmCount  := SpinEditAlarm.Value;
        Str:= Str + ',ALARMCOUNT=' + IntToStr(lAlarmCount) ;
      end;
      if CheckBoxEffect.Checked then
      begin
        lIsEffect:= cxComboBoxEffect.Properties.Items.IndexOf(cxComboBoxEffect.Text);
        Str:= Str + ',ISEFFECT=' + IntToStr(lIsEffect) ;
      end;
      if CheckBoxWrecker.Checked then
      begin
        lIsAutoWrecker:= cxComboBoxWrecker.Properties.Items.IndexOf(cxComboBoxWrecker.Text);
        Str:= Str + ',ISAUTOWRECKER=' + IntToStr(lIsAutoWrecker) ;
      end;
      if CheckBoxCommit.Checked then
      begin
        lIsAutoSubmit:= cxComboBoxCommit.Properties.Items.IndexOf(cxComboBoxCommit.Text);
        Str:= Str + ',ISAUTOSUBMIT=' + IntToStr(lIsAutoSubmit);
      end;
    end;
  END;
  if Str<>'' then
    Result:= Copy(Str,2,Length(Str));
end;

procedure TFormAlarmContentMgr.BtnOKClick(Sender: TObject);
var
  i, lCount, lAlarm_Index, lRecordIndex, lAlarmContentCode, iError: Integer;
  lVariant: variant;
  lSqlstr: string;
  lMasterAlarm: TMasterAlarm;
  lsuccess: boolean;
begin
  try
    lAlarm_Index:=cxGrid1DBTableView1.GetColumnByFieldName('AlarmContentCode').Index;
  except
    Application.MessageBox('未获得关键字段AlarmContentCode！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if (UpdateSetInfo(ALARM_CONTENT_RULE)+UpdateSetInfo(ALARM_CONTENT_INFO))='' then
  begin
    Application.MessageBox('未选择修改条件，请先选择！','提示',MB_OK+64);
    Exit;
  end;
  try
    lCount:= 0;
    Screen.Cursor := crHourGlass;
    lMasterAlarm:= IsExsitMasterAlarm(gPublicParam.cityid);
    if CheckBoxType.Checked then
    begin
      if CheckBoxLevel.checked or CheckBoxMode.Checked or CheckBoxRemove.Checked
        or CheckBoxAlarm.Checked or CheckBoxEffect.Checked or CheckBoxWrecker.Checked
        or CheckBoxCommit.Checked then
      begin
        lVariant:= VarArrayCreate([0,2*cxGrid1DBTableView1.DataController.GetSelectedCount-1],varVariant);
        for i := cxGrid1DBTableView1.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex := cxGrid1DBTableView1.Controller.SelectedRows[I].RecordIndex;
          lAlarmContentCode := cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lAlarm_Index);
          lSqlstr:=' update alarm_content_rule set ' + UpdateSetInfo(ALARM_CONTENT_RULE) +
                   ' where ALARMCONTENTCODE=' + IntToStr(lAlarmContentCode) +
                    ' and cityid=' + IntToStr(gPublicParam.cityid);
          lVariant[2*lCount]:= VarArrayOf([lSqlstr]);
          lSqlstr:=' update alarm_content_info set ' + UpdateSetInfo(ALARM_CONTENT_INFO) +
               ' where ALARMCONTENTCODE=' + IntToStr(lAlarmContentCode) +
               ' and cityid=' + IntToStr(gPublicParam.cityid);
          lVariant[2*lCount+1]:= VarArrayOf([lSqlstr]);
          Inc(lCount);
        end;
      end
      else
      begin
        lVariant:= VarArrayCreate([0,cxGrid1DBTableView1.DataController.GetSelectedCount-1],varVariant);
        for i := cxGrid1DBTableView1.DataController.GetSelectedCount -1 downto 0 do
        begin
          lRecordIndex := cxGrid1DBTableView1.Controller.SelectedRows[I].RecordIndex;
          lAlarmContentCode := cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lAlarm_Index);
          lSqlstr:=' update alarm_content_info set ' + UpdateSetInfo(ALARM_CONTENT_INFO) +
               ' where ALARMCONTENTCODE=' + IntToStr(lAlarmContentCode) +
               ' and cityid=' + IntToStr(gPublicParam.cityid);
          lVariant[lCount]:= VarArrayOf([lSqlstr]);
          Inc(lCount);
        end;
      end;
    end
    else
    begin
      lVariant:= VarArrayCreate([0,cxGrid1DBTableView1.DataController.GetSelectedCount-1],varVariant);
      for i := cxGrid1DBTableView1.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := cxGrid1DBTableView1.Controller.SelectedRows[I].RecordIndex;
        lAlarmContentCode := cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lAlarm_Index);
        lSqlstr:=' update alarm_content_rule set ' + UpdateSetInfo(ALARM_CONTENT_RULE) +
                 ' where ALARMCONTENTCODE=' + IntToStr(lAlarmContentCode) +
                  ' and cityid=' + IntToStr(gPublicParam.cityid);
        lVariant[lCount]:= VarArrayOf([lSqlstr]);
      Inc(lCount);
      end;
    end;
    if CheckBoxEffect.Checked and (cxComboBoxEffect.Properties.Items.IndexOf(cxComboBoxEffect.Text)=0) and lMasterAlarm.IsExsitAlarm then
    begin
      if MessageDlg('将删除当前已派单该告警，是否继续',mtWarning,[mbYes,mbNo],0)= mrNo then
        Exit;
      iError:= gTempInterface.CompanyMgr(gPublicParam.cityid,0,'',lMasterAlarm.AlarmCodeStr,gPublicParam.userid,lVariant);
      case iError of
        0:
        begin
          Application.MessageBox('修改成功','提示',MB_OK+64);
          InitAlarmSetInfo;
        end;
        -1:
          Application.MessageBox('删除告警过程出错','提示',MB_OK+64);
        10: // 添加告警操作日志失败!
          Application.MessageBox('添加告警操作日志失败!','提示',MB_OK+64);
        11:
          Application.MessageBox('告警手动删除失败!','提示',MB_OK+64);
        end;
    end
    else
    begin
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if lsuccess then
      begin
        Application.MessageBox('保存成功','提示',MB_OK+64);
        InitAlarmSetInfo;
      end
      else
        Application.MessageBox('保存失败','提示',MB_OK+64);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;


procedure TFormAlarmContentMgr.cxGrid1DBTableView1SelectionChanged(
  Sender: TcxCustomGridTableView);
begin
  cxComboBoxLevel.ItemIndex:=cxComboBoxLevel.Properties.Items.IndexOf(ClientDataSet1.fieldbyname('alarmlevel').AsString);
  cxComboBoxType.ItemIndex:=cxComboBoxType.Properties.Items.IndexOf(ClientDataSet1.fieldbyname('alarmtype').AsString);
  cxComboBoxMode.ItemIndex:=cxComboBoxMode.Properties.Items.IndexOf(ClientDataSet1.fieldbyname('sendtype').AsString);
  SpinEditRemove.Value:=ClientDataSet1.fieldbyname('Removelimit').AsInteger;
  SpinEditAlarm.Value:=ClientDataSet1.fieldbyname('alarmcount').AsInteger;
  cxComboBoxEffect.ItemIndex:=cxComboBoxEffect.Properties.Items.IndexOf(ClientDataSet1.fieldbyname('iseffect').AsString);
  cxComboBoxWrecker.ItemIndex:=cxComboBoxWrecker.Properties.Items.IndexOf(ClientDataSet1.fieldbyname('isautowrecker').AsString);
  cxComboBoxCommit.ItemIndex:=cxComboBoxCommit.Properties.Items.IndexOf(ClientDataSet1.fieldbyname('isautosubmit').AsString);
end;

procedure TFormAlarmContentMgr.CheckBoxLevelClick(Sender: TObject);
begin
    if CheckBoxLevel.Checked then
    cxComboBoxLevel.Enabled:=True
  else
    cxComboBoxLevel.Enabled:= False;

  if CheckBoxType.Checked then
    cxComboBoxType.Enabled:= True
  else
    cxComboBoxType.Enabled:= False;

  if CheckBoxMode.Checked then
    cxComboBoxMode.Enabled:= True
  else
    cxComboBoxMode.Enabled:= False;

  if CheckBoxRemove.Checked then
    SpinEditRemove.Enabled:= True
  else
    SpinEditRemove.Enabled:= False;

  if CheckBoxAlarm.Checked then
    SpinEditAlarm.Enabled:= True
  else
    SpinEditAlarm.Enabled:= False;

  if CheckBoxEffect.Checked then
    cxComboBoxEffect.Enabled:= True
  else
    cxComboBoxEffect.Enabled:= False;

  if CheckBoxWrecker.Checked then
    cxComboBoxWrecker.Enabled:= True
  else
    cxComboBoxWrecker.Enabled:= False;

  if CheckBoxCommit.Checked then
    cxComboBoxCommit.Enabled:= True
  else
    cxComboBoxCommit.Enabled:= False;
end;

procedure TFormAlarmContentMgr.BtnSearchClick(Sender: TObject);
begin
  ClientDataSet1.Filtered:= false;
  if trim(uppercase(EdtSearch.Text))<>'' then
    ClientDataSet1.Filtered:= true;
  ClientDataSet1.OnFilterRecord:= FilterRecord;
end;

procedure TFormAlarmContentMgr.EdtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    BtnSearchClick(self)
end;

procedure TFormAlarmContentMgr.FilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept:= (pos(trim(uppercase(EdtSearch.Text)),trim(uppercase(DataSet.FieldByName('alarmcontentname').AsString)))>0) or
           (pos(trim(uppercase(EdtSearch.Text)),trim(uppercase(DataSet.FieldByName('alarmcontentcode').AsString)))>0);
end;

procedure TFormAlarmContentMgr.SpeedButtonSearchClick(Sender: TObject);
var
  lSqlStr, lWhereStr, lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lClientDataSet: TClientDataSet;
begin
  ClearTStrings(CheckListBoxAlarmContent.Items);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    if AlarmEdtSearch.Text='' then
      lWhereStr:= ''
    else
      lWhereStr:= GetBlurQueryWhere('ALARMCONTENTNAME','ALARMCONTENTCODE',AlarmEdtSearch.Text);
    lSqlStr:= 'select * from alarm_content_info where cityid=' +
              IntToStr(gPublicParam.cityid) +
              lWhereStr +
              ' order by ALARMCONTENTCODE';
    with lClientDataSet do
    begin
      close;
      ProviderName:= 'dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        lAlarmObject:= TWdInteger.create(FieldByName('ALARMCONTENTCODE').AsInteger);
        lAlarmCaption:= FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(FieldByName('ALARMCONTENTCODE').AsInteger) + ']';
        CheckListBoxAlarmContent.Items.AddObject(lAlarmCaption,lAlarmObject);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmContentMgr.AlarmEdtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    SpeedButtonSearchClick(Self);
end;

function TFormAlarmContentMgr.IsExsitMasterAlarm(aCityid: Integer): TMasterAlarm;
var
  i: Integer;
  lStr, lSqlStr: string;
  lClientDataSet: TClientDataSet;
  function GetAlarmStr: string;
  var
    i, lAlarm_Index, lRecordIndex, lAlarmContentCode: Integer;
  begin
    Result:= '';
    with cxGrid1DBTableView1 do
    begin
      try
        lAlarm_Index:=GetColumnByFieldName('AlarmContentCode').Index;
      except
        Application.MessageBox('未获得关键字段AlarmContentCode！','提示',MB_OK	+MB_ICONINFORMATION);
        exit;
      end;
      for i:= DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := cxGrid1DBTableView1.Controller.SelectedRows[I].RecordIndex;
        lAlarmContentCode := cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lAlarm_Index);
        Result:= Result + IntToStr(lAlarmContentCode) + ',';
      end;
      Result:= Copy(Result,0,Length(Result)-1);
    end;
  end;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  with lClientDataSet do
  begin
    try
      Close;
      ProviderName:= 'DataSetProvider';
      lSqlStr:= 'select cityid,alarmcontentcode from fault_detail_online ' +
                ' where cityid=' + IntToStr(aCityid) +
                ' and alarmcontentcode in (' + GetAlarmStr + ')'+
                'group by cityid,alarmcontentcode';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if not IsEmpty then
      begin
        Result.IsExsitAlarm:= True;
        Result.Count:= RecordCount;
        First;
        for i:=0 to RecordCount-1 do
        begin
          Result.AlarmCodeStr:= Result.AlarmCodeStr + IntToStr(FieldByName('alarmcontentcode').AsInteger) + ',';
          Next;
        end;
        Result.AlarmCodeStr:= Copy(Result.AlarmCodeStr,0,Length(Result.AlarmCodeStr)-1);
      end
      else
      begin
        Result.Count:= 0;
        Result.IsExsitAlarm:= False;
        Result.AlarmCodeStr:= '';
      end;
    finally
      lClientDataSet.Free;
    end;
  end;
end;

procedure TFormAlarmContentMgr.CheckListBoxAlarmContentClick(
  Sender: TObject);
var
  lItemIndex: Integer;
begin
  lItemIndex:= CheckListBoxAlarmContent.ItemIndex;
  if CheckListBoxAlarmContent.Selected[lItemIndex] then
    CheckListBoxAlarmContent.Hint:= CheckListBoxAlarmContent.Items.Strings[lItemIndex];
end;

end.
