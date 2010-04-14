unit Ut_AlarmContent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid, StdCtrls, Spin, Buttons,AdvGridUnit,DBClient,
  ComCtrls, ExtCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxMaskEdit, cxDropDownEdit, cxDBEdit, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxContainer, cxTextEdit, dxtree,
  dxdbtree, Menus, cxMemo, ImgList, cxSpinEdit;

type
  TFm_AlarmContent = class(TForm)
    gb_info: TGroupBox;
    AdvStringGrid1: TAdvStringGrid;
    Label1: TLabel;
    Et_AlarmContentName: TEdit;
    Label2: TLabel;
    cbb_AlarmKind: TComboBox;
    Label3: TLabel;
    cbb_AlarmLevel: TComboBox;
    cbb_AlarmCom: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    cbb_AlarmParam: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    SE_AlarmCount: TSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    SE_RemoveCount: TSpinEdit;
    SE_LimitHour: TSpinEdit;
    Label10: TLabel;
    Et_ALARMCONDITION: TMemo;
    Et_REMOVECONDITION: TMemo;
    BtnModify: TBitBtn;
    BtnOk: TBitBtn;
    BtnClose: TBitBtn;
    Label11: TLabel;
    cbb_Effect: TComboBox;
    Label12: TLabel;
    cbb_SendType: TComboBox;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    Label13: TLabel;
    GroupBox1: TGroupBox;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    gbParamEdit: TGroupBox;
    btNew: TButton;
    btSave: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    GroupBox3: TGroupBox;
    Panel6: TPanel;
    Label14: TLabel;
    cbLoadModel: TcxLookupComboBox;
    CDSModel: TClientDataSet;
    DSModel: TDataSource;
    tAlarmModelTree: TdxDBTreeView;
    CDSModelContent: TClientDataSet;
    DSModelContent: TDataSource;
    CDSModelOnly: TClientDataSet;
    DSModelOnly: TDataSource;
    Label15: TLabel;
    CDSDSAlarmKind: TClientDataSet;
    DSAlarmKind: TDataSource;
    Splitter1: TSplitter;
    Label17: TLabel;
    CDSModelType: TClientDataSet;
    DSModelType: TDataSource;
    btNewType: TButton;
    cxDBMemo1: TcxDBMemo;
    Label18: TLabel;
    Label19: TLabel;
    cxDBMemo2: TcxDBMemo;
    Label20: TLabel;
    Label21: TLabel;
    btDelete: TButton;
    btAddModel: TButton;
    cxDBSpinEdit1: TcxDBSpinEdit;
    Label22: TLabel;
    cxDBSpinEdit2: TcxDBSpinEdit;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    cxStyle2: TcxStyle;
    cxStyle3: TcxStyle;
    cxStyle4: TcxStyle;
    cxStyle5: TcxStyle;
    cxStyle6: TcxStyle;
    cxStyle7: TcxStyle;
    cxStyle8: TcxStyle;
    cxStyle9: TcxStyle;
    cxStyle10: TcxStyle;
    cxStyle11: TcxStyle;
    cxStyle13: TcxStyle;
    cxStyle12: TcxStyle;
    cxStyle14: TcxStyle;
    cxGridTableViewStyleSheet1: TcxGridTableViewStyleSheet;
    cxGridTableViewStyleSheet2: TcxGridTableViewStyleSheet;
    cxGridTableViewStyleSheet3: TcxGridTableViewStyleSheet;
    btChangeType: TButton;
    cbModelType: TcxLookupComboBox;
    eModelName: TcxTextEdit;
    Label16: TLabel;
    cxComboBoxIsEffect: TcxComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnModifyClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
    procedure cxLookupComboBox1PropertiesChange(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure tAlarmModelTreeChange(Sender: TObject; Node: TTreeNode);
    procedure btNewClick(Sender: TObject);
    procedure btNewTypeClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
    procedure tAlarmModelTreeSetDisplayItemText(Sender: TObject;
      var DisplayText: string);
    procedure btAddModelClick(Sender: TObject);
    procedure btChangeTypeClick(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxComboBoxIsEffectPropertiesChange(Sender: TObject);
  private
    { Private declarations }

    CurrentModelID: Integer;

    FAdvGridSet:TAdvGridSet;
    procedure ShowAlarmContent;
    procedure SetControl(IsEdit:Boolean);
    procedure UIChangeNormal;
    procedure ClearInfo;

    procedure RefreshModelTree(ModelID: Integer=0);
  public
    { Public declarations }
  end;

var
  Fm_AlarmContent: TFm_AlarmContent;
  Operation :Integer;
implementation
uses Ut_MainForm,Ut_Common,Ut_DataModule, UntDBFunc;
{$R *.dfm}

procedure TFm_AlarmContent.FormCreate(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(self.AdvStringGrid1);
  FAdvGridSet.SetGridStyle;

  CurrentModelID := 0;
  DSModel.DataSet := nil;
  with CDSModel do
  begin
    Close;
    ProviderName:='dsp_General_data6';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,10]),6);
  end;   
  DSModel.DataSet := CDSModel;

  DSModelType.DataSet := nil;
  CDSModelType.Data := CDSModel.Data;
  DSModelType.DataSet := CDSModelType;

  CDSModelOnly.Close;
  CDSModelOnly.Data := CDSModel.Data;  
  CDSModelOnly.Insert;
  CDSModelOnly.Fields[0].Value := 2;
  CDSModelOnly.Fields[1].Value := 0;
  CDSModelOnly.Fields[2].Value := 'Ĭ��ģ��';
  CDSModelOnly.Post;  
  DSModelOnly.DataSet := CDSModelOnly;

  //�澯����
  DSModelContent.DataSet := nil;
  with CDSModelContent do
  begin
    close;
    ProviderName:='dsp_General_data5';
    //Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,11]),5);
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,13,0]),5);
  end;
  AddGridFields(cxGrid1DBTableView1, CDSModelContent, '����,ģ��ID,����,'+
               '�澯��������,�澯����,�澯�ȼ�,�澯��������,�澯�ų�����,�澯�����ۼƴ�,'+
               '�澯�ų��ۼƴ�,��������,�澯��Դ�����,�澯���������,����ʱ��,'+
               '�Ƿ���Ч,�澯����,�澯�ȼ�,�澯��Դ����,�澯��Դ����');

  cxGrid1DBTableView1.GetColumnByFieldName('ALARMLEVEL').Visible:=false;
  cxGrid1DBTableView1.GetColumnByFieldName('ALARMKIND').Visible:=false;
  cxGrid1DBTableView1.GetColumnByFieldName('IFINEFFECT').Visible:=false;
  cxGrid1DBTableView1.GetColumnByFieldName('ID').Visible:=false;
  cxGrid1DBTableView1.GetColumnByFieldName('ModelID').Visible:=false;
  cxGrid1DBTableView1.GetColumnByFieldName('SENDTYPE').Visible:=false;
  cxGrid1DBTableView1.GetColumnByFieldName('LIMITHOUR').Visible:=false;
  cxGrid1DBTableView1.GetColumnByFieldName('COMID').Visible:=false;
  cxGrid1DBTableView1.GetColumnByFieldName('PARAMID').Visible:=false;


  DSModelContent.DataSet := CDSModelContent;
  cxGrid1DBTableView1.ApplyBestFit();
  
  DSAlarmKind.DataSet := nil;
  with CDSDSAlarmKind do
  begin
    Close;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,14]),0);
  end;
  DSAlarmKind.DataSet := CDSDSAlarmKind;

end;   

procedure TFm_AlarmContent.FormShow(Sender: TObject);
begin
  InitComboBox(VarArrayOf([0,1,2,10]),cbb_AlarmLevel); //��ʼ���澯���ݵȼ�
  InitComboBox(VarArrayOf([0,1,2,11]),cbb_AlarmKind);   //��ʼ���澯����
  InitComboBox(VarArrayOf([0,1,6,2]),cbb_AlarmCom);   //��ʼ��MTU����
  InitComboBox(VarArrayOf([0,1,7]),cbb_AlarmParam);   //��ʼ��MTU����
  ShowAlarmContent;
  SetControl(false);

  BtnModify.Enabled := false;
end;

procedure TFm_AlarmContent.RefreshModelTree(ModelID: Integer=0);
begin 
  DSModel.DataSet := nil;
  with CDSModel do
  begin
    Close;
    ProviderName:='dsp_General_data6';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,10]),6);
  end;
  CDSModel.Locate('ModelID', ModelID, [loCaseInsensitive]);
  DSModel.DataSet := CDSModel;    
  tAlarmModelTree.SetFocus;

  DSModelType.DataSet := nil;
  CDSModelType.Data := CDSModel.Data;
  DSModelType.DataSet := CDSModelType;

  DSModelOnly.DataSet := nil;
  CDSModelOnly.Data := CDSModel.Data;  
  CDSModelOnly.Insert;
  CDSModelOnly.Fields[0].Value := 2;
  CDSModelOnly.Fields[1].Value := 0;
  CDSModelOnly.Fields[2].Value := 'Ĭ��ģ��';
  CDSModelOnly.Post;
  DSModelOnly.DataSet := CDSModelOnly;
end;

procedure TFm_AlarmContent.btNewTypeClick(Sender: TObject);
var
  ModelType: String;
  vCDSArray: array[0..0] of TClientDataset;
  vDeltaArray, vProviderArray: OleVariant;   
begin
  ModelType := InputBox('��������', '��Ҫ�½�������ģ����������', '');

  if trim(ModelType) <> '' then
  begin
    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,12, ModelType]),1);
    end;

    if Dm_MTS.cds_common.RecordCount > 0 then
    begin
      Application.MessageBox('ģ���������Ʋ����ظ���','��ʾ',MB_OK	);
      Exit;
    end;

    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,10]),1);
    end;

    CurrentModelID := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');
    Dm_MTS.cds_common.Append;
    Dm_MTS.cds_common.FieldByName('ParentModelID').Value := 1;
    Dm_MTS.cds_common.FieldByName('ModelID').Value := CurrentModelID;
    Dm_MTS.cds_common.FieldByName('ModelName').Value := ModelType;

    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      Application.MessageBox('�ɹ���������','��ʾ',MB_OK	);

      RefreshModelTree(CurrentModelID);
    except
       application.MessageBox('��������ʧ��,��������ԣ�', '��ʾ', mb_ok);
    end;

  end;   
end;


procedure TFm_AlarmContent.btChangeTypeClick(Sender: TObject);
var
  ModelType: String;
  vCDSArray: array[0..0] of TClientDataset;
  vDeltaArray, vProviderArray: OleVariant;
begin
  ModelType := InputBox('��������', '�������µ�ģ����������', '');

  if trim(ModelType) <> '' then
  begin
    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,12, ModelType]),1);
    end;
    if Dm_MTS.cds_common.RecordCount > 0 then
    begin
      Application.MessageBox('ģ���������Ʋ����ظ���','��ʾ',MB_OK	);
      Exit;
    end;

    CDSModel.Edit;
    CDSModel.FieldByName('ModelName').Value := ModelType;

    try
      vCDSArray[0]:=CDSModel;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      Application.MessageBox('�ɹ��޸�ģ���������ƣ�','��ʾ',MB_OK	);

      RefreshModelTree(CurrentModelID);
    except
       application.MessageBox('�޸�ģ����������ʧ��, ��������ԣ�', '��ʾ', mb_ok);
    end;

  end;

end;


procedure TFm_AlarmContent.btNewClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset; 
  I, J, NewModelID: Integer;
begin 
  try
    btNew.Enabled := false;

  //if CheckModelSaveValid then
  begin
    try
      if trim(eModelName.EditValue) = '' then
    begin
      Application.MessageBox('ģ�����Ʋ���Ϊ�գ����������ƣ�','��ʾ',MB_OK	);
      exit;
    end;
    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,12, trim(eModelName.EditValue)]),1);
    end;
    if Dm_MTS.cds_common.RecordCount > 0 then
    begin
      Application.MessageBox('ģ�������Ѿ����ڣ��������޸�ģ�����ƣ�','��ʾ',MB_OK	);
      Exit;
    end; 

      with Dm_MTS.cds_common do
      begin
        Close;
        ProviderName:='dsp_General_data1';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,10]),1);
      end;
      NewModelID := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');
      Dm_MTS.cds_common.Append;
      Dm_MTS.cds_common.FieldByName('ParentModelID').Value := CDSModel.FieldByName('ParentModelID').Value;
      Dm_MTS.cds_common.FieldByName('ModelID').Value := NewModelID;
      Dm_MTS.cds_common.FieldByName('ModelName').Value := trim(eModelName.EditValue);

      with Dm_MTS.cds_Master do
      begin
        Close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,38, CurrentModelID]),0);
      end;
      if not CDSModelContent.IsEmpty then
      begin
        Dm_MTS.cds_common1.Data := CDSModelContent.Data;
        Dm_MTS.cds_common1.First;
        for I := 0 to Dm_MTS.cds_common1.RecordCount - 1 do
        begin
          Dm_MTS.cds_Master.Append;
          for J := 0 to Dm_MTS.cds_Master.FieldCount - 1 do
            Dm_MTS.cds_Master.Fields[J].Value := Dm_MTS.cds_common1.Fields[J].Value;
          Dm_MTS.cds_Master.FieldByName('ID').Value := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');;
          Dm_MTS.cds_Master.FieldByName('ModelID').Value := NewModelID;
          Dm_MTS.cds_common1.Next;
        end;
      end;

      vCDSArray[0]:=Dm_MTS.cds_common;
      vCDSArray[1]:=Dm_MTS.cds_Master;  

      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
        Application.MessageBox('�ɹ���������','��ʾ',MB_OK	);

      RefreshModelTree(NewModelID);
    except
       application.MessageBox('��������ʧ��,��������ԣ�', '��ʾ', mb_ok);
    end;
  end;
  finally
      btNew.Enabled := true;
  end;

end;

procedure TFm_AlarmContent.btAddModelClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
  I, J, NewModelID: Integer;
  DoOK: boolean;
begin
  DoOK := false;
  try
    btAddModel.Enabled := false;

    if trim(eModelName.EditValue) = '' then
    begin
      Application.MessageBox('ģ�����Ʋ���Ϊ�գ����������ƣ�','��ʾ',MB_OK	);
      exit;
    end;
    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,12, trim(eModelName.EditValue)]),1);
    end;
    if Dm_MTS.cds_common.RecordCount > 0 then
    begin
      Application.MessageBox('ģ�������Ѿ����ڣ��������޸�ģ�����ƣ�','��ʾ',MB_OK	);
      Exit;
    end;

    try
      with Dm_MTS.cds_common do
      begin
        Close;
        ProviderName:='dsp_General_data1';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,10]),1);
      end;
      NewModelID := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');
      Dm_MTS.cds_common.Append;
      Dm_MTS.cds_common.FieldByName('ParentModelID').Value := CDSModel.FieldByName('ModelID').Value;
      Dm_MTS.cds_common.FieldByName('ModelID').Value := NewModelID;
      Dm_MTS.cds_common.FieldByName('ModelName').Value := trim(eModelName.EditValue);

      with Dm_MTS.cds_Master do
      begin
        Close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,38, CurrentModelID]),0);
      end;
      if not CDSModelContent.IsEmpty then
      begin
        Dm_MTS.cds_common1.Data := CDSModelContent.Data;
        Dm_MTS.cds_common1.First;
        for I := 0 to Dm_MTS.cds_common1.RecordCount - 1 do
        begin
          Dm_MTS.cds_Master.Append;
          for J := 0 to Dm_MTS.cds_Master.FieldCount - 1 do
            Dm_MTS.cds_Master.Fields[J].Value := Dm_MTS.cds_common1.Fields[J].Value;
          Dm_MTS.cds_Master.FieldByName('ID').Value := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');;
          Dm_MTS.cds_Master.FieldByName('ModelID').Value := NewModelID;
          Dm_MTS.cds_common1.Next;
        end;
      end;

      vCDSArray[0]:=Dm_MTS.cds_common;
      vCDSArray[1]:=Dm_MTS.cds_Master;

      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      Application.MessageBox('�ɹ���������','��ʾ',MB_OK	);
      DoOK := true;
    except
       application.MessageBox('��������ʧ��,��������ԣ�', '��ʾ', mb_ok);
    end;
  
  finally
    btAddModel.Enabled := not DoOK;
    if DoOK then RefreshModelTree(NewModelID);
  end;

end;

procedure TFm_AlarmContent.btDeleteClick(Sender: TObject);
var
  DelModelID: Integer;
begin
  if not CDSModel.IsEmpty then
  begin
    DelModelID := CDSModel.FieldByName('ModelID').AsInteger;
    CurrentModelID := CDSModel.FieldByName('ParentModelID').AsInteger;

    if CDSModel.FieldByName('ParentModelID').AsInteger = 1 then
    begin
      if Application.MessageBox('ɾ��ģ�����ͽ�ͬʱɾ��������������ģ�壬ȷ��ɾ����?', '��ʾ', MB_YESNO) = IDYES then
      begin
        with Dm_MTS.cds_common do
        begin
          Close;
          ProviderName:='dsp_General_data1';
          Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,48,DelModelID]),1);
        end;

        if Dm_MTS.cds_common.RecordCount > 0 then
        begin
          Application.MessageBox('ģ���ѱ�MTU����������ɾ����','��ʾ',MB_OK	);
          Exit;
        end;

        try
          Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,18,DelModelID]),VarArrayOf([1,2,19,DelModelID]),VarArrayOf([1,2,20,DelModelID])]));
          Application.MessageBox('�ɹ�ɾ�����ѱ��������ݿ⣡','��ʾ',MB_OK	);

          RefreshModelTree(CurrentModelID);
          tAlarmModelTree.DBSelected.Expand(false);
        except
          Application.MessageBox('ɾ������ʧ��,��������ԣ�', '��ʾ', mb_ok);
        end;
      end;
    end
    else
    begin
      if Application.MessageBox(PAnsiChar('��ɾ��ģ�壺'+CDSModel.FieldByName('ModelName').AsString+'��ȷ����?'), '��ʾ', MB_YESNO) = IDYES then
      begin
        with Dm_MTS.cds_common do
        begin
          Close;
          ProviderName:='dsp_General_data1';
          Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,47,DelModelID]),1);
        end;

        if Dm_MTS.cds_common.RecordCount > 0 then
        begin
          Application.MessageBox('ģ���ѱ�MTU����������ɾ����','��ʾ',MB_OK	);
          Exit;
        end;



        try
          Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,16,DelModelID]),VarArrayOf([1,2,17,DelModelID])]));
          Application.MessageBox('�ɹ�ɾ�����ѱ��������ݿ⣡','��ʾ',MB_OK	);

          RefreshModelTree(CurrentModelID);
          tAlarmModelTree.DBSelected.Expand(false);
        except
          Application.MessageBox('ɾ������ʧ��,��������ԣ�', '��ʾ', mb_ok);
        end;
      end;
    end ;
  end;
end;

procedure TFm_AlarmContent.btSaveClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;  
  I, J: Integer;
begin
  try
    btSave.Enabled := false;

    if trim(eModelName.EditValue) = '' then
    begin
      Application.MessageBox('ģ�����Ʋ���Ϊ�գ����������ƣ�','��ʾ',MB_OK	);
      exit;
    end;
    with Dm_MTS.cds_common do
    begin
      Close;
      ProviderName:='dsp_General_data1';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,12, trim(eModelName.EditValue)]),1);
    end;
    if Dm_MTS.cds_common.RecordCount > 0 then
    begin
      if Dm_MTS.cds_common.FieldByName('ModelID').AsInteger <> CDSModel.FieldByName('ModelID').AsInteger then
      begin
        Application.MessageBox('ģ�������Ѿ����ڣ��������޸�ģ�����ƣ�','��ʾ',MB_OK	);
        Exit;
      end;
    end;

    CDSModel.Edit;
    CDSModel.FieldByName('ModelName').Value := trim(eModelName.EditValue);
    CDSModel.FieldByName('ParentModelID').Value := cbModelType.EditValue;

    try
      Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,16,CurrentModelID])]));

      with Dm_MTS.cds_common do
      begin
        Close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,38, CurrentModelID]),0);
      end;

      Dm_MTS.cds_common1.Data := CDSModelContent.Data;
      Dm_MTS.cds_common1.First;
      for I := 0 to Dm_MTS.cds_common1.RecordCount - 1 do
      begin
        Dm_MTS.cds_common.Append;
        for J := 0 to Dm_MTS.cds_common.FieldCount - 1 do
          Dm_MTS.cds_common.Fields[J].Value := Dm_MTS.cds_common1.Fields[J].Value;
        Dm_MTS.cds_common.FieldByName('ID').Value := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');;
        Dm_MTS.cds_common.FieldByName('ModelID').Value := CurrentModelID;
        Dm_MTS.cds_common1.Next;
      end;

      vCDSArray[0]:=CDSModel;
      vCDSArray[1]:=Dm_MTS.cds_common;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
        Application.MessageBox('����ɹ���','��ʾ',MB_OK	);

      RefreshModelTree(CurrentModelID);
    except
       application.MessageBox('����ʧ��,��������ԣ�', '��ʾ', mb_ok);
    end;

  finally
    btSave.Enabled := true;
  end;

end;

procedure TFm_AlarmContent.cxComboBoxIsEffectPropertiesChange(Sender: TObject);
begin
  CDSModelContent.Edit;
 CDSModelContent.FieldByName('IFINEFFECT').AsInteger := cxComboBoxIsEffect.ItemIndex
end;

procedure TFm_AlarmContent.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  cxComboBoxIsEffect.ItemIndex:=  CDSModelContent.FieldByName('IFINEFFECT').AsInteger;
  // cxComboBoxIsEffect.Properties.Items.IndexOf(CDSModelContent.FieldByName('IFINEFFECT').AsString);
end;

procedure TFm_AlarmContent.cxLookupComboBox1PropertiesChange(Sender: TObject);
begin
  if cbLoadModel.EditValue = null then exit; 
  if cbLoadModel.EditValue = '0' then
  begin
    DSModelContent.DataSet := nil;
    with CDSModelContent do
    begin
      close;
      ProviderName:='dsp_General_data5';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,11]),5); 
    end;
    DSModelContent.DataSet := CDSModelContent;
    cxGrid1DBTableView1.ApplyBestFit();
  end
  else
  begin
    DSModelContent.DataSet := nil;
    with CDSModelContent do
    begin
      close;
      ProviderName:='dsp_General_data5';
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,13,cbLoadModel.EditValue]),5);
    end;
    DSModelContent.DataSet := CDSModelContent;
    cxGrid1DBTableView1.ApplyBestFit(); 
  end;

  gbParamEdit.Enabled := not CDSModelContent.IsEmpty;
end;

procedure TFm_AlarmContent.tAlarmModelTreeChange(Sender: TObject; Node: TTreeNode);
begin
  CurrentModelID := CDSModel.FieldByName('ModelID').AsInteger;
  DSModelContent.DataSet := nil;
  with CDSModelContent do
  begin
    close;
    ProviderName:='dsp_General_data5';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,13,CurrentModelID]),5);
  end;
  DSModelContent.DataSet := CDSModelContent;
  cxGrid1DBTableView1.ApplyBestFit();  

  cbLoadModel.Clear;

  if CDSModel.FieldByName('ParentModelID').AsInteger in [0,1] then
  begin
    eModelName.EditValue := '';
    cbModelType.EditValue := CDSModel.FieldByName('ModelID').AsInteger;
    cbModelType.Enabled := false;
    btSave.Enabled := false;
    btNew.Enabled := false;
  end
  else
  begin
    eModelName.EditValue := CDSModel.FieldByName('ModelName').AsString;
    cbModelType.EditValue := CDSModel.FieldByName('ParentModelID').AsInteger;
    cbModelType.Enabled := true;
    btSave.Enabled := true;
    btNew.Enabled := true;
  end;

  gbParamEdit.Enabled := not CDSModelContent.IsEmpty;
  btAddModel.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger = 1;
  btDelete.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger <> 0;
  btChangeType.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger = 1;
  eModelName.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger <> 0;
  cbLoadModel.Enabled := CDSModel.FieldByName('ParentModelID').AsInteger <> 0;
end;

procedure TFm_AlarmContent.tAlarmModelTreeSetDisplayItemText(Sender: TObject;
  var DisplayText: string);
begin
  if CDSModel.FieldByName('ParentModelID').AsInteger = 1 then
  begin
    ;
  end;
end;

procedure TFm_AlarmContent.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyCBObj(cbb_AlarmLevel);
  DestroyCBObj(cbb_AlarmKind);
  DestroyCBObj(cbb_AlarmCom);
  DestroyCBObj(cbb_AlarmParam);
  FAdvGridSet.Free;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Fm_AlarmContent:=nil;    
end;

procedure TFm_AlarmContent.AdvStringGrid1Click(Sender: TObject);
var
  ContentId : integer;
begin
  
  ContentId :=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
  With Dm_MTS.cds_common Do
  begin
     Close;
     ProviderName:='dsp_General_data';
     Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,12,ContentId]),0);   //
     if RecordCount >0 then
     begin
       Et_AlarmContentName.Text := FieldByName('ALARMCONTENTNAME').AsString;
       GotoCmbIndex(cbb_AlarmKind,FieldByName('ALARMKIND').AsInteger);
       GotoCmbIndex(cbb_AlarmLevel,FieldByName('ALARMLEVEL').AsInteger);
       GotoCmbIndex(cbb_AlarmCom,FieldByName('COMID').AsInteger);
       GotoCmbIndex(cbb_AlarmParam,FieldByName('PARAMID').AsInteger);
       Et_ALARMCONDITION.Text :=FieldByName('ALARMCONDITION').AsString;
       Et_REMOVECONDITION.Text :=FieldByName('REMOVECONDITION').AsString;
       SE_AlarmCount.Value :=FieldByName('ALARMCOUNT').AsInteger;
       SE_RemoveCount.Value :=FieldByName('REMOVECOUNT').AsInteger;
       SE_LimitHour.Value := FieldByName('LIMITHOUR').AsInteger;
       cbb_Effect.ItemIndex := FieldByName('IFINEFFECT').AsInteger;
       cbb_SendType.ItemIndex := FieldByName('SENDTYPE').AsInteger;

       BtnModify.Enabled := true;
     end;
     Close;
  end;
end;



procedure TFm_AlarmContent.BtnAddClick(Sender: TObject);
begin
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='ȡ��';
    SetControl(true);
    ClearInfo;
    Operation := ADDFLAG;
    BtnModify.Enabled := false;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='����';
    SetControl(false);
    Operation := CANCELFLAG;
    BtnModify.Enabled := true;
  end;
end;

procedure TFm_AlarmContent.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFm_AlarmContent.BtnModifyClick(Sender: TObject);
begin
  if TButton(Sender).Tag =0  then
  begin
    TButton(Sender).Tag :=1;
    TButton(Sender).Caption :='ȡ��';
    SetControl(true);
    Operation := MODIFYFLAG;
//    BtnAdd.Enabled := false;
  end
  else
  begin
    TButton(Sender).Tag :=0;
    TButton(Sender).Caption :='�޸�';
    SetControl(false);
    Operation := CANCELFLAG;
//    BtnAdd.Enabled := true;
  end;
end;

procedure TFm_AlarmContent.BtnOkClick(Sender: TObject);
var
  ContentId :integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if (Trim(Et_AlarmContentName.Text)='') or (cbb_AlarmKind.ItemIndex=-1)
    or (cbb_AlarmLevel.ItemIndex =-1) or (cbb_AlarmCom.ItemIndex=-1)
    or (cbb_AlarmParam.ItemIndex=-1) or (cbb_Effect.ItemIndex=-1) or (cbb_SendType.ItemIndex=-1)then
  begin
    Application.MessageBox('��Ϣ��ȫ,��˶Ժ������','��ʾ');
    Exit;
  end;
  
  if cbb_SendType.ItemIndex=0 then
  begin
    if (Trim(Et_ALARMCONDITION.Text)='') or (Trim(Et_REMOVECONDITION.Text)='') then
    begin
      Application.MessageBox('�澯���������͸澯�ų���������Ϊ��,��˶Ժ������','��ʾ');
      Exit;
    end;
    if (Pos('@value',Trim(Et_ALARMCONDITION.Text))<>1) or (Pos('@value',Trim(Et_REMOVECONDITION.Text))<>1)  then
    begin
      Application.MessageBox('�澯���������͸澯�ų�������ʽ����ȷ,��˶Ժ������','��ʾ');
      Exit;
    end;
  end;
  
  try
    With Dm_MTS.cds_common Do
    begin
       Close;
       ProviderName:='dsp_General_data';
       Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,11]),0);   //
       if Operation = ADDFLAG then
       begin
         ContentId :=Dm_Mts.TempInterface.ProduceFlowNumID('ALARMCONTENTCODE',1);
         if ContentId=-1 then
           Raise Exception.Create('�޷���ȡ��Ч�澯���!')
         else
         begin
           Append;
           FieldByName('ALARMCONTENTCODE').AsInteger := ContentId;
         end;
       end
       else
       begin
         ContentId :=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
         if not Locate('ALARMCONTENTCODE',ContentId,[]) then
           Raise Exception.Create('���ݿ��в����ڴ˼�¼')
         else
           Edit;
       end;
       FieldByName('ALARMCONTENTNAME').AsString :=Trim(Et_AlarmContentName.Text);
       FieldByName('ALARMKIND').AsInteger :=GetIdFromObj(cbb_AlarmKind);
       FieldByName('ALARMLEVEL').AsInteger :=GetIdFromObj(cbb_AlarmLevel);
       FieldByName('ALARMCONDITION').AsString :=Trim(Et_ALARMCONDITION.Text);
       FieldByName('REMOVECONDITION').AsString :=Trim(Et_REMOVECONDITION.Text);
       FieldByName('ALARMCOUNT').AsInteger :=SE_AlarmCount.Value;
       FieldByName('REMOVECOUNT').AsInteger :=SE_RemoveCount.Value;
       FieldByName('SENDTYPE').AsInteger :=cbb_SendType.ItemIndex;
       FieldByName('COMID').AsInteger :=GetIdFromObj(cbb_AlarmCom);
       FieldByName('PARAMID').AsInteger :=GetIdFromObj(cbb_AlarmParam);
       FieldByName('LIMITHOUR').AsInteger :=SE_LimitHour.Value;
       FieldByName('IFINEFFECT').AsInteger :=cbb_Effect.ItemIndex;
       Post;
       vCDSArray[0]:=Dm_MTS.cds_common;
       vDeltaArray:=RetrieveDeltas(vCDSArray);
       vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_Mts.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        Raise Exception.Create('�ύ����ʧ��!');
      Application.MessageBox('���ݱ���ɹ���', '��ʾ', mb_ok + mb_defbutton1);
      ShowAlarmContent;
      UIChangeNormal;
    end;
  except
    on E: Exception do
      Application.MessageBox(Pchar('������ʾ: '+E.Message),'��ʾ');
  end;
end;


procedure TFm_AlarmContent.ClearInfo;
var
  i : integer;
begin
  for I := 0 to gb_info.ControlCount - 1 do
  begin
    if (gb_info.Controls[i] is TEdit) then
      (gb_info.Controls[i] as TEdit).Text :=''
    else if(gb_info.Controls[i] is TComboBox) then
      (gb_info.Controls[i] as TComboBox).ItemIndex :=-1
    else if (gb_info.Controls[i] is TMemo) then
      (gb_info.Controls[i]as TMemo).Text :=''
    else if (gb_info.Controls[i] is TSpinEdit) then
      (gb_info.Controls[i] as TSpinEdit).Value :=1;
  end;
end;



procedure TFm_AlarmContent.SetControl(IsEdit: Boolean);
var
  i : integer;
begin
  for I := 0 to gb_info.ControlCount - 1 do
  begin
    if (gb_info.Controls[i] is TEdit) or (gb_info.Controls[i] is TComboBox)
      or (gb_info.Controls[i] is TMemo) or (gb_info.Controls[i] is TSpinEdit) then
        gb_info.Controls[i].Enabled := IsEdit;
  end;
  BtnOk.Enabled :=IsEdit;
end;

procedure TFm_AlarmContent.ShowAlarmContent;
begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,10]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,self.AdvStringGrid1);
    AdvStringGrid1.ColWidths[1]:=0;
    Close;
  end;
end;

procedure TFm_AlarmContent.UIChangeNormal;
begin
//  if BtnAdd.Tag=1 then
//    BtnAddClick(BtnAdd);
  if BtnModify.Tag=1 then
    BtnModifyClick(BtnModify);
end;

end.
