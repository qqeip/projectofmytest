{alarm_content_advrule 告警规则组关系表}

unit UnitAdvSendRuleSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxControls, cxContainer, cxEdit,
  cxGroupBox, ComCtrls, Menus, StdCtrls, cxButtons, cxTextEdit, cxLabel,
  cxListView, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ExtCtrls, CxGridUnit, StringUtils, DBClient, cxMaskEdit, cxButtonEdit,
  cxEditRepositoryItems, IniFiles;

type
  TFormAdvSendRuleSet = class(TForm)
    cxGroupBox1: TcxGroupBox;
    LVAlarmRuleGroup: TcxListView;
    PopupMenu1: TPopupMenu;
    Menu_Add: TMenuItem;
    N3: TMenuItem;
    Menu_Modify: TMenuItem;
    N4: TMenuItem;
    Menu_Del: TMenuItem;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    cxGroupBox2: TcxGroupBox;
    BtnSave: TcxButton;
    BtnCancel: TcxButton;
    BtnAlarmQuery: TcxButton;
    LabelGroupName: TcxLabel;
    EdtAlarmRuleGroupName: TcxTextEdit;
    BtnAdd: TcxButton;
    cxGroupBox3: TcxGroupBox;
    cxGrid: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    BtnModify: TcxButton;
    BtnDel: TcxButton;
    LabelRemark: TLabel;
    cxEditRepository1: TcxEditRepository;
    cxEditRepository1ImageComboBoxItem1: TcxEditRepositoryImageComboBoxItem;
    ComboBox: TcxEditRepositoryImageComboBoxItem;
    cxEditRepository1CalcItem1: TcxEditRepositoryCalcItem;
    CheckBox: TcxEditRepositoryCheckBoxItem;
    ItemALARMCONTENTCODE: TcxGridDBColumn;
    ItemALARMCONTENTNAME: TcxGridDBColumn;
    ItemRULEFLAGTRUE: TcxGridDBColumn;
    ItemRULEFLAGFALSE: TcxGridDBColumn;
    BtnClose: TcxButton;
    EdtRemark: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnAlarmQueryClick(Sender: TObject);
    procedure Menu_AddClick(Sender: TObject);
    procedure Menu_ModifyClick(Sender: TObject);
    procedure Menu_DelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnModifyClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure LVAlarmRuleGroupClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    FOperateFlag: Integer;
    procedure LoadAlarmRuleGroupInfo;
    procedure AddcxGridViewField;
    procedure SetComponentEnabled(aBool: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAdvSendRuleSet: TFormAdvSendRuleSet;

implementation

uses UnitDllCommon, UnitAlarmContentModule;

{$R *.dfm}

procedure TFormAdvSendRuleSet.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
//  FCxGridHelper.SetGridStyle(cxGrid,true,false,true);
  AddcxGridViewField;
  LoadAlarmRuleGroupInfo;
  SetComponentEnabled(False);
end;

procedure TFormAdvSendRuleSet.FormShow(Sender: TObject);
begin
//
end;

procedure TFormAdvSendRuleSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
//  FCxGridHelper.Free;
  ClientDataSet.Close;
  gDllMsgCall(FormAdvSendRuleSet,1,'','');
end;

procedure TFormAdvSendRuleSet.FormDestroy(Sender: TObject);
begin
//  
end;

procedure TFormAdvSendRuleSet.AddcxGridViewField;
begin
//  AddViewField(cxGridDBTableView1,'ALARMCONTENTCODE','告警内容编号');
//  AddViewField(cxGridDBTableView1,'ALARMCONTENTNAME','告警内容名称');
//  AddViewField(cxGridDBTableView1,'RULEFLAGTRUE','同时存在派该告警');
//  AddViewField(cxGridDBTableView1,'RULEFLAGFALSE','不同时存在派该告警');
//  ItemRULEFLAGTRUE.RepositoryItem:= CheckBox;
//  cxGridDBTableView1.Columns[2].RepositoryItem:= CheckBox;
//  cxGridDBTableView1.Columns[3].RepositoryItem:= CheckBox;
end;

procedure TFormAdvSendRuleSet.LoadAlarmRuleGroupInfo;
var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
  lListItem: TListItem;
  lAlarmRuleGroup: TWdInteger;
  lAlarmRuleGroupID: Integer;
  lAlarmRuleGroupCaption, lAlarmRuleGroupRemark: string;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lSqlStr:= 'select ruleid,rulename,REMARK from (select ruleid,rulename,REMARK from alarm_content_advrule where cityid=' + IntToStr(gPublicParam.cityid) +
                ' ) group by ruleid,rulename,REMARK order by ruleid';
      ProviderName:= 'dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then Exit;
      First;
      while not Eof do
      begin
        lAlarmRuleGroupID:= FieldByName('ruleid').AsInteger;
        lAlarmRuleGroupCaption:= FieldByName('rulename').AsString;
        lAlarmRuleGroupRemark:= FieldByName('REMARK').AsString;
        lAlarmRuleGroup:= TWdInteger.Create(lAlarmRuleGroupID);
        lListItem :=LVAlarmRuleGroup.Items.Add;
        lListItem.Data :=lAlarmRuleGroup;
        lListItem.Caption := format('%.4d',[LVAlarmRuleGroup.Items.Count]);
        lListItem.SubItems.Add(lAlarmRuleGroupCaption);
        lListItem.SubItems.Add(lAlarmRuleGroupRemark);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAdvSendRuleSet.BtnAlarmQueryClick(Sender: TObject);
var
  i, j, lAlarmCode: Integer;
  lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lHashedAlarmList: THashedStringList;
begin
  try
    lHashedAlarmList:= THashedStringList.Create;
    with ClientDataSet do
    begin
      First;
      for i:=0 to RecordCount-1 do
      begin
        lAlarmCode:= FieldByName('ALARMCONTENTCODE').AsInteger;
        lAlarmCaption:= FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(lAlarmCode) + ']';
        if lHashedAlarmList.IndexOf(lAlarmCaption)<0 then
        begin
          lAlarmObject:= TWdInteger.create(lAlarmCode);
          lHashedAlarmList.AddObject(lAlarmCaption,lAlarmObject);
        end;
        Next;
      end;
      
      if not Assigned(FormAlarmContentModule) then
        FormAlarmContentModule:= TFormAlarmContentModule.Create(Self,lHashedAlarmList);
      if FormAlarmContentModule.ShowModal= mrOk then
      begin
        if Active then
        begin
          if not IsEmpty then EmptyDataSet;
          DisableControls;
          for i:= 0 to FormAlarmContentModule.gHashedAlarmList.Count-1 do
          begin
            lAlarmCode:= TWdInteger(FormAlarmContentModule.gHashedAlarmList.Objects[i]).value;
            lAlarmCaption:= FormAlarmContentModule.gHashedAlarmList.Strings[i];
            j:= Pos('[',lAlarmCaption);
            lAlarmCaption:= Copy(lAlarmCaption,0,j-1);
            Insert;
            FieldByName('ALARMCONTENTCODE').AsInteger:= lAlarmCode;
            FieldByName('ALARMCONTENTNAME').AsString:= lAlarmCaption;
            FieldByName('RULEFLAGTRUE').AsInteger:= 1;
            FieldByName('RULEFLAGFALSE').AsInteger:= 0;
            Post;
          end;
          EnableControls;
        end;
      end;
    end;
  finally
    lHashedAlarmList.Free;
    if Assigned(FormAlarmContentModule) then
      FreeAndNil(FormAlarmContentModule);
  end;
end;

procedure TFormAdvSendRuleSet.Menu_AddClick(Sender: TObject);
begin
  FOperateFlag:=1;
  SetComponentEnabled(True);
end;

procedure TFormAdvSendRuleSet.Menu_ModifyClick(Sender: TObject);
begin
  FOperateFlag:=2;
  SetComponentEnabled(True);
end;

procedure TFormAdvSendRuleSet.Menu_DelClick(Sender: TObject);
begin
  BtnDelClick(Sender);
end;

procedure TFormAdvSendRuleSet.SetComponentEnabled(aBool: Boolean);
var i: Integer;
begin
  BtnAdd.Enabled:= (not aBool);
  BtnModify.Enabled:= (not aBool);
  BtnAlarmQuery.Enabled:= aBool;
  BtnSave.Enabled:= aBool;
  BtnCancel.Enabled:= aBool;
  LabelGroupName.Enabled:= aBool;
  EdtAlarmRuleGroupName.Enabled:= aBool;
  LabelRemark.Enabled:= aBool;
  EdtRemark.Enabled:= aBool;
end;

procedure TFormAdvSendRuleSet.BtnAddClick(Sender: TObject);
var
  lSqlStr: string;
begin
  FOperateFlag:=1;
  SetComponentEnabled(True);
  EdtAlarmRuleGroupName.Text:= '';
  EdtRemark.Text:= '';
  with ClientDataSet do
  begin
    Close;
    lSqlStr:= 'select a.*,b.alarmcontentname from alarm_content_advrule a '+
              'left join alarm_content_info b on a.alarmcontentcode= b.alarmcontentcode and a.cityid=b.cityid' +
              ' where ruleid=''' +
              ''' and a.cityid=''' +
              ''' order by a.alarmcontentcode ';
    ProviderName:= 'dsp_General_data';
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
    Open;
  end;
end;

procedure TFormAdvSendRuleSet.BtnModifyClick(Sender: TObject);
begin
  if LVAlarmRuleGroup.Selected=nil then exit;
  FOperateFlag:=2;
  SetComponentEnabled(True);
end;

procedure TFormAdvSendRuleSet.BtnDelClick(Sender: TObject);
var
  lVariant: Variant;
  lSqlStr: string;
  lGroupCode: Integer;
  lsuccess: Boolean;
begin
  if MessageDlg('确定要删除此规则组么？',mtInformation,[mbYes,mbNo],0)=mrYes then
  begin
    if LVAlarmRuleGroup.Selected=nil then exit;
    lGroupCode:= TWdInteger(LVAlarmRuleGroup.Selected.Data).Value;
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlStr:= 'delete alarm_content_advrule where ruleid = ' + IntToStr(lGroupCode) +
              ' and cityid = ' + IntToStr(gPublicParam.cityid);
    lVariant[0]:= VarArrayOf([lsqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      Application.MessageBox('删除成功','提示',MB_OK+64);
      LVAlarmRuleGroup.Selected.Free;
      LVAlarmRuleGroup.DeleteSelected;
      if ClientDataSet.Active then
        ClientDataSet.EmptyDataSet;
    end
    else
      Application.MessageBox('删除失败','提示',MB_OK+64);
  end;
end;

procedure TFormAdvSendRuleSet.BtnSaveClick(Sender: TObject);
var
  lCount, lGroupCode, lAlarmCode: Integer;
  lVariant: Variant;
  lSqlStr, lHint: string;
  lsuccess: Boolean;
  lAlarmRuleGroup: TWdInteger;
  lListItem: TListItem;
begin
  try
    Screen.Cursor:= crHourGlass;
    if EdtAlarmRuleGroupName.Text='' then
    begin
      Application.MessageBox('告警规则组名称不能为空','提示',MB_OK + 64);
      Exit;
    end;
    if ClientDataSet.IsEmpty then
    begin
      Application.MessageBox('规则组无关联的告警内容，请选择“告警查询”查询告警内容','提示',MB_OK+64);
      Exit;
    end;

    with ClientDataSet do
    begin
      case FOperateFlag of
      1: //新增
      begin
        lCount:= 0;
        lGroupCode:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
        if IsExists('alarm_content_advrule','RULENAME',EdtAlarmRuleGroupName.Text) then
        begin
          Application.MessageBox('该告警组名称已经存在!','提示',MB_OK+64);
          Exit;
        end;
      
        lVariant:= VarArrayCreate([0,RecordCount-1],varVariant);
        First;
        while not Eof do
        begin
          lAlarmCode:= FieldByName('alarmcontentcode').AsInteger;
          lSqlStr:= 'insert into alarm_content_advrule(ruleid, rulename, alarmcontentcode, ruleflagtrue, ruleflagfalse, remark, cityid) values(' +
                    IntToStr(lGroupCode) + ',''' +
                    EdtAlarmRuleGroupName.Text + ''',' +
                    IntToStr(lAlarmCode) + ',' +
                    IntToStr(FieldByName('RULEFLAGTRUE').AsInteger) + ',' +
                    IntToStr(FieldByName('RULEFLAGFALSE').AsInteger) + ',''' +
                    EdtRemark.Text + ''','+
                    IntToStr(gPublicParam.cityid) + ')' ;
          lVariant[lCount]:= VarArrayOf([lsqlstr]);
          inc(lCount);
          Next;
        end;
        lHint:= '新增';
      end;
      2: //修改
      begin
        lCount:= 0;
        if LVAlarmRuleGroup.Selected=nil then exit;
        lGroupCode:= TWdInteger(LVAlarmRuleGroup.Selected.Data).Value;
        lVariant:= VarArrayCreate([0,RecordCount],varVariant);
        lSqlStr:= 'delete alarm_content_advrule where ruleid = ' + IntToStr(lGroupCode) +
                  ' and cityid = ' + IntToStr(gPublicParam.cityid);
        lVariant[0]:= VarArrayOf([lsqlstr]);

        First;
        while not Eof do
        begin
          lAlarmCode:= FieldByName('alarmcontentcode').AsInteger;
          lSqlStr:= 'insert into alarm_content_advrule(ruleid, rulename, alarmcontentcode, ruleflagtrue, ruleflagfalse, remark, cityid) values(' +
                    IntToStr(lGroupCode) + ',''' +
                    EdtAlarmRuleGroupName.Text + ''',' +
                    IntToStr(lAlarmCode) + ',' +
                    IntToStr(FieldByName('RULEFLAGTRUE').AsInteger) + ',' +
                    IntToStr(FieldByName('RULEFLAGFALSE').AsInteger) + ',''' +
                    EdtRemark.Text + ''',' +
                    IntToStr(gPublicParam.cityid) + ')' ;
          lVariant[lCount+1]:= VarArrayOf([lsqlstr]);
          Inc(lCount);
          Next;
        end;
        lHint:= '修改';
      end;
      end;
    end;
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      if FOperateFlag=1 then
      begin
        lAlarmRuleGroup:= TWdInteger.Create(lGroupCode);
        lListItem :=LVAlarmRuleGroup.Items.Add;
        lListItem.Data :=lAlarmRuleGroup;
        lListItem.Caption := format('%.4d',[LVAlarmRuleGroup.Items.Count]);
        lListItem.SubItems.Add(EdtAlarmRuleGroupName.Text);
        lListItem.SubItems.Add(EdtRemark.Text);
      end
      else if FOperateFlag=2 then
      begin
        LVAlarmRuleGroup.Selected.SubItems[0]:= EdtAlarmRuleGroupName.Text;
        LVAlarmRuleGroup.Selected.SubItems[1]:= EdtRemark.Text;
      end;
      Application.MessageBox(PChar(lHint + '成功'),'提示',MB_OK+64);
      SetComponentEnabled(False);
    end
    else
      Application.MessageBox(PChar(lHint + '失败'),'提示',MB_OK+64);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormAdvSendRuleSet.BtnCancelClick(Sender: TObject);
begin
  SetComponentEnabled(False);
end;

procedure TFormAdvSendRuleSet.LVAlarmRuleGroupClick(Sender: TObject);
var
  lAlarmRuleGroupID: Integer;
  lSqlStr: string;
  lListItem: TListItem;
begin
  lListItem:= (Sender as TcxListView).Selected ;
  if lListItem=nil then exit;


  EdtAlarmRuleGroupName.Text:= LVAlarmRuleGroup.Selected.SubItems[0];
  EdtRemark.Text:= LVAlarmRuleGroup.Selected.SubItems[1];

  lAlarmRuleGroupID:= TWdInteger(lListItem.Data).Value;
  with ClientDataSet do
  begin
    Close;
    lSqlStr:= 'select a.*,b.alarmcontentname from alarm_content_advrule a '+
              'left join alarm_content_info b on a.alarmcontentcode= b.alarmcontentcode and a.cityid=b.cityid' +
              ' where ruleid=' + IntToStr(lAlarmRuleGroupID) +
              ' and a.cityid=' + IntToStr(gPublicParam.cityid) +
              ' order by a.alarmcontentcode ';
    ProviderName:= 'dsp_General_data';
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
    Open;
  end;
end;

procedure TFormAdvSendRuleSet.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
