unit UnitDRS_Alarm_mgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid, StdCtrls, Spin, Buttons,AdvGridUnit,DBClient,
  ComCtrls, ExtCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxMaskEdit, cxDropDownEdit, cxDBEdit, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxContainer, cxTextEdit, dxtree,
  dxdbtree, Menus, cxMemo, ImgList, cxSpinEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinGlassOceans, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinSilver, dxSkinStardust, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter;

type
  TFormDRS_ALARM_Mgr = class(TForm)
    Panel1: TPanel;
    CDSModel: TClientDataSet;
    DSModel: TDataSource;
    CDSModelContent: TClientDataSet;
    DSModelContent: TDataSource;
    CDSModelOnly: TClientDataSet;
    DSModelOnly: TDataSource;
    CDSDSAlarmKind: TClientDataSet;
    DSAlarmKind: TDataSource;
    CDSModelType: TClientDataSet;
    DSModelType: TDataSource;
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
    gb_info: TGroupBox;
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
    Et_AlarmContentName: TEdit;
    cbb_AlarmKind: TComboBox;
    cbb_AlarmLevel: TComboBox;
    cbb_AlarmCom: TComboBox;
    cbb_AlarmParam: TComboBox;
    SE_AlarmCount: TSpinEdit;
    SE_RemoveCount: TSpinEdit;
    SE_LimitHour: TSpinEdit;
    Et_ALARMCONDITION: TMemo;
    Et_REMOVECONDITION: TMemo;
    BtnModify: TBitBtn;
    BtnOk: TBitBtn;
    BtnClose: TBitBtn;
    cbb_Effect: TComboBox;
    cbb_SendType: TComboBox;
    AdvStringGrid1: TAdvStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnModifyClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure AdvStringGrid1Click(Sender: TObject);
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
  FormDRS_ALARM_Mgr: TFormDRS_ALARM_Mgr;
  Operation :Integer;
implementation
uses Ut_MainForm,Ut_Common,Ut_DataModule, UntDBFunc;
{$R *.dfm}

procedure TFormDRS_ALARM_Mgr.FormCreate(Sender: TObject);
begin
//  PageControl1.TabIndex := 0;
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



  DSModelContent.DataSet := CDSModelContent;
//  cxGrid1DBTableView1.ApplyBestFit();
  
  DSAlarmKind.DataSet := nil;
  with CDSDSAlarmKind do
  begin
    Close;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,14]),0);
  end;
  DSAlarmKind.DataSet := CDSDSAlarmKind;

end;   

procedure TFormDRS_ALARM_Mgr.FormShow(Sender: TObject);
var
 Lsqlstr: string;
begin
  InitComboBox(VarArrayOf([0,1,2,10]),cbb_AlarmLevel); //��ʼ���澯���ݵȼ�
  InitComboBox(VarArrayOf([0,1,2,11]),cbb_AlarmKind);   //��ʼ���澯����
  Lsqlstr:='select comid as thecode,comname as thename from drs_command_define where ifineffect=1 and COMTYPE=2' ;//and COMTYPE=2';
  InitComboBox(VarArrayOf([2,4,13,lSqlstr]),cbb_AlarmCom);   //��ʼ��DRS����
  Lsqlstr:='select paramid as thecode,paramname as thename from  drs_param_define where ifineffect=1';
  InitComboBox(VarArrayOf([2,4,13,lSqlstr]),cbb_AlarmParam);   //��ʼ��DRS�������
  ShowAlarmContent;
  SetControl(false);

  BtnModify.Enabled := false;
end;

procedure TFormDRS_ALARM_Mgr.RefreshModelTree(ModelID: Integer=0);
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
//  tAlarmModelTree.SetFocus;

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

procedure TFormDRS_ALARM_Mgr.btNewTypeClick(Sender: TObject);
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


procedure TFormDRS_ALARM_Mgr.btChangeTypeClick(Sender: TObject);
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


procedure TFormDRS_ALARM_Mgr.btNewClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
  I, J, NewModelID: Integer;
begin
//  try
////    btNew.Enabled := false;
//
//  //if CheckModelSaveValid then
//  begin
//    try
////      if trim(eModelName.EditValue) = '' then
////    begin
////      Application.MessageBox('ģ�����Ʋ���Ϊ�գ����������ƣ�','��ʾ',MB_OK	);
////      exit;
////    end;
////    with Dm_MTS.cds_common do
////    begin
////      Close;
////      ProviderName:='dsp_General_data1';
////      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,12, trim(eModelName.EditValue)]),1);
//    end;
//    if Dm_MTS.cds_common.RecordCount > 0 then
//    begin
//      Application.MessageBox('ģ�������Ѿ����ڣ��������޸�ģ�����ƣ�','��ʾ',MB_OK	);
//      Exit;
//    end; 
//
//      with Dm_MTS.cds_common do
//      begin
//        Close;
//        ProviderName:='dsp_General_data1';
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,10]),1);
//      end;
//      NewModelID := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');
//      Dm_MTS.cds_common.Append;
//      Dm_MTS.cds_common.FieldByName('ParentModelID').Value := CDSModel.FieldByName('ParentModelID').Value;
//      Dm_MTS.cds_common.FieldByName('ModelID').Value := NewModelID;
//      Dm_MTS.cds_common.FieldByName('ModelName').Value := trim(eModelName.EditValue);
//
//      with Dm_MTS.cds_Master do
//      begin
//        Close;
//        ProviderName:='dsp_General_data';
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,38, CurrentModelID]),0);
//      end;
//      if not CDSModelContent.IsEmpty then
//      begin
//        Dm_MTS.cds_common1.Data := CDSModelContent.Data;
//        Dm_MTS.cds_common1.First;
//        for I := 0 to Dm_MTS.cds_common1.RecordCount - 1 do
//        begin
//          Dm_MTS.cds_Master.Append;
//          for J := 0 to Dm_MTS.cds_Master.FieldCount - 1 do
//            Dm_MTS.cds_Master.Fields[J].Value := Dm_MTS.cds_common1.Fields[J].Value;
//          Dm_MTS.cds_Master.FieldByName('ID').Value := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');;
//          Dm_MTS.cds_Master.FieldByName('ModelID').Value := NewModelID;
//          Dm_MTS.cds_common1.Next;
//        end;
//      end;
//
//      vCDSArray[0]:=Dm_MTS.cds_common;
//      vCDSArray[1]:=Dm_MTS.cds_Master;
//
//      vDeltaArray:=RetrieveDeltas(vCDSArray);
//      vProviderArray:=RetrieveProviders(vCDSArray);
//      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
//        SysUtils.Abort;
//        Application.MessageBox('�ɹ���������','��ʾ',MB_OK	);
//
//      RefreshModelTree(NewModelID);
//    except
//       application.MessageBox('��������ʧ��,��������ԣ�', '��ʾ', mb_ok);
//    end;
//  end;
//  finally
//      btNew.Enabled := true;
//  end;

end;

procedure TFormDRS_ALARM_Mgr.btAddModelClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
  I, J, NewModelID: Integer;
  DoOK: boolean;
begin
//  DoOK := false;
//  try
//    btAddModel.Enabled := false;
//
//    if trim(eModelName.EditValue) = '' then
//    begin
//      Application.MessageBox('ģ�����Ʋ���Ϊ�գ����������ƣ�','��ʾ',MB_OK	);
//      exit;
//    end;
//    with Dm_MTS.cds_common do
//    begin
//      Close;
//      ProviderName:='dsp_General_data1';
//      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,12, trim(eModelName.EditValue)]),1);
//    end;
//    if Dm_MTS.cds_common.RecordCount > 0 then
//    begin
//      Application.MessageBox('ģ�������Ѿ����ڣ��������޸�ģ�����ƣ�','��ʾ',MB_OK	);
//      Exit;
//    end;
//
//    try
//      with Dm_MTS.cds_common do
//      begin
//        Close;
//        ProviderName:='dsp_General_data1';
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,10]),1);
//      end;
//      NewModelID := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');
//      Dm_MTS.cds_common.Append;
//      Dm_MTS.cds_common.FieldByName('ParentModelID').Value := CDSModel.FieldByName('ModelID').Value;
//      Dm_MTS.cds_common.FieldByName('ModelID').Value := NewModelID;
//      Dm_MTS.cds_common.FieldByName('ModelName').Value := trim(eModelName.EditValue);
//
//      with Dm_MTS.cds_Master do
//      begin
//        Close;
//        ProviderName:='dsp_General_data';
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,38, CurrentModelID]),0);
//      end;
//      if not CDSModelContent.IsEmpty then
//      begin
//        Dm_MTS.cds_common1.Data := CDSModelContent.Data;
//        Dm_MTS.cds_common1.First;
//        for I := 0 to Dm_MTS.cds_common1.RecordCount - 1 do
//        begin
//          Dm_MTS.cds_Master.Append;
//          for J := 0 to Dm_MTS.cds_Master.FieldCount - 1 do
//            Dm_MTS.cds_Master.Fields[J].Value := Dm_MTS.cds_common1.Fields[J].Value;
//          Dm_MTS.cds_Master.FieldByName('ID').Value := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');;
//          Dm_MTS.cds_Master.FieldByName('ModelID').Value := NewModelID;
//          Dm_MTS.cds_common1.Next;
//        end;
//      end;
//
//      vCDSArray[0]:=Dm_MTS.cds_common;
//      vCDSArray[1]:=Dm_MTS.cds_Master;
//
//      vDeltaArray:=RetrieveDeltas(vCDSArray);
//      vProviderArray:=RetrieveProviders(vCDSArray);
//      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
//        SysUtils.Abort;
//      Application.MessageBox('�ɹ���������','��ʾ',MB_OK	);
//      DoOK := true;
//    except
//       application.MessageBox('��������ʧ��,��������ԣ�', '��ʾ', mb_ok);
//    end;
//  
//  finally
//    btAddModel.Enabled := not DoOK;
//    if DoOK then RefreshModelTree(NewModelID);
//  end;

end;

procedure TFormDRS_ALARM_Mgr.btDeleteClick(Sender: TObject);
var
  DelModelID: Integer;
begin
//  if not CDSModel.IsEmpty then
//  begin
//    DelModelID := CDSModel.FieldByName('ModelID').AsInteger;
//    CurrentModelID := CDSModel.FieldByName('ParentModelID').AsInteger;
//
//    if CDSModel.FieldByName('ParentModelID').AsInteger = 1 then
//    begin
//      if Application.MessageBox('ɾ��ģ�����ͽ�ͬʱɾ��������������ģ�壬ȷ��ɾ����?', '��ʾ', MB_YESNO) = IDYES then
//      begin
//        with Dm_MTS.cds_common do
//        begin
//          Close;
//          ProviderName:='dsp_General_data1';
//          Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,48,DelModelID]),1);
//        end;
//
//        if Dm_MTS.cds_common.RecordCount > 0 then
//        begin
//          Application.MessageBox('ģ���ѱ�MTU����������ɾ����','��ʾ',MB_OK	);
//          Exit;
//        end;
//
//        try
//          Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,18,DelModelID]),VarArrayOf([1,2,19,DelModelID]),VarArrayOf([1,2,20,DelModelID])]));
//          Application.MessageBox('�ɹ�ɾ�����ѱ��������ݿ⣡','��ʾ',MB_OK	);
//
//          RefreshModelTree(CurrentModelID);
//          tAlarmModelTree.DBSelected.Expand(false);
//        except
//          Application.MessageBox('ɾ������ʧ��,��������ԣ�', '��ʾ', mb_ok);
//        end;
//      end;
//    end
//    else
//    begin
//      if Application.MessageBox(PAnsiChar('��ɾ��ģ�壺'+CDSModel.FieldByName('ModelName').AsString+'��ȷ����?'), '��ʾ', MB_YESNO) = IDYES then
//      begin
//        with Dm_MTS.cds_common do
//        begin
//          Close;
//          ProviderName:='dsp_General_data1';
//          Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,47,DelModelID]),1);
//        end;
//
//        if Dm_MTS.cds_common.RecordCount > 0 then
//        begin
//          Application.MessageBox('ģ���ѱ�MTU����������ɾ����','��ʾ',MB_OK	);
//          Exit;
//        end;
//
//
//
//        try
//          Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,16,DelModelID]),VarArrayOf([1,2,17,DelModelID])]));
//          Application.MessageBox('�ɹ�ɾ�����ѱ��������ݿ⣡','��ʾ',MB_OK	);
//
//          RefreshModelTree(CurrentModelID);
//          tAlarmModelTree.DBSelected.Expand(false);
//        except
//          Application.MessageBox('ɾ������ʧ��,��������ԣ�', '��ʾ', mb_ok);
//        end;
//      end;
//    end ;
//  end;
end;

procedure TFormDRS_ALARM_Mgr.btSaveClick(Sender: TObject);
var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
  I, J: Integer;
begin
//  try
//    btSave.Enabled := false;
//
//    if trim(eModelName.EditValue) = '' then
//    begin
//      Application.MessageBox('ģ�����Ʋ���Ϊ�գ����������ƣ�','��ʾ',MB_OK	);
//      exit;
//    end;
//    with Dm_MTS.cds_common do
//    begin
//      Close;
//      ProviderName:='dsp_General_data1';
//      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,12, trim(eModelName.EditValue)]),1);
//    end;
//    if Dm_MTS.cds_common.RecordCount > 0 then
//    begin
//      if Dm_MTS.cds_common.FieldByName('ModelID').AsInteger <> CDSModel.FieldByName('ModelID').AsInteger then
//      begin
//        Application.MessageBox('ģ�������Ѿ����ڣ��������޸�ģ�����ƣ�','��ʾ',MB_OK	);
//        Exit;
//      end;
//    end;
//
//    CDSModel.Edit;
//    CDSModel.FieldByName('ModelName').Value := trim(eModelName.EditValue);
//    CDSModel.FieldByName('ParentModelID').Value := cbModelType.EditValue;
//
//    try
//      Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,2,16,CurrentModelID])]));
//
//      with Dm_MTS.cds_common do
//      begin
//        Close;
//        ProviderName:='dsp_General_data';
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,38, CurrentModelID]),0);
//      end;
//
//      Dm_MTS.cds_common1.Data := CDSModelContent.Data;
//      Dm_MTS.cds_common1.First;
//      for I := 0 to Dm_MTS.cds_common1.RecordCount - 1 do
//      begin
//        Dm_MTS.cds_common.Append;
//        for J := 0 to Dm_MTS.cds_common.FieldCount - 1 do
//          Dm_MTS.cds_common.Fields[J].Value := Dm_MTS.cds_common1.Fields[J].Value;
//        Dm_MTS.cds_common.FieldByName('ID').Value := Dm_Mts.TempInterface.GetTheSequenceId('MTS_NORMAL');;
//        Dm_MTS.cds_common.FieldByName('ModelID').Value := CurrentModelID;
//        Dm_MTS.cds_common1.Next;
//      end;
//
//      vCDSArray[0]:=CDSModel;
//      vCDSArray[1]:=Dm_MTS.cds_common;
//      vDeltaArray:=RetrieveDeltas(vCDSArray);
//      vProviderArray:=RetrieveProviders(vCDSArray);
//      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
//        SysUtils.Abort;
//        Application.MessageBox('����ɹ���','��ʾ',MB_OK	);
//
//      RefreshModelTree(CurrentModelID);
//    except
//       application.MessageBox('����ʧ��,��������ԣ�', '��ʾ', mb_ok);
//    end;
//
//  finally
//    btSave.Enabled := true;
//  end;

end;

procedure TFormDRS_ALARM_Mgr.cxComboBoxIsEffectPropertiesChange(Sender: TObject);
begin
  CDSModelContent.Edit;
// CDSModelContent.FieldByName('IFINEFFECT').AsInteger := cxComboBoxIsEffect.ItemIndex
end;

procedure TFormDRS_ALARM_Mgr.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
//  cxComboBoxIsEffect.ItemIndex:=  CDSModelContent.FieldByName('IFINEFFECT').AsInteger;
  // cxComboBoxIsEffect.Properties.Items.IndexOf(CDSModelContent.FieldByName('IFINEFFECT').AsString);
end;

procedure TFormDRS_ALARM_Mgr.tAlarmModelTreeChange(Sender: TObject; Node: TTreeNode);
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

end;

procedure TFormDRS_ALARM_Mgr.tAlarmModelTreeSetDisplayItemText(Sender: TObject;
  var DisplayText: string);
begin
  if CDSModel.FieldByName('ParentModelID').AsInteger = 1 then
  begin
    ;
  end;
end;

procedure TFormDRS_ALARM_Mgr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyCBObj(cbb_AlarmLevel);
  DestroyCBObj(cbb_AlarmKind);
  DestroyCBObj(cbb_AlarmCom);
  DestroyCBObj(cbb_AlarmParam);
  FAdvGridSet.Free;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormDRS_ALARM_Mgr:=nil;    
end;

procedure TFormDRS_ALARM_Mgr.AdvStringGrid1Click(Sender: TObject);
var
  ContentId : integer;
  Lsqlstr:string;
begin
//  if strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1])>-1 then
  ContentId :=strtoint(AdvStringGrid1.Rows[AdvStringGrid1.Row].Strings[1]);
  //ContentId:=1;
  With Dm_MTS.cds_common Do
  begin
     Close;
     ProviderName:='dsp_General_data';
     Lsqlstr:=' select * from drs_alarm_content where alarmcontentcode='+inttostr(ContentId);
     Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,Lsqlstr]),0);   //
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



procedure TFormDRS_ALARM_Mgr.BtnAddClick(Sender: TObject);
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

procedure TFormDRS_ALARM_Mgr.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormDRS_ALARM_Mgr.BtnModifyClick(Sender: TObject);
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

procedure TFormDRS_ALARM_Mgr.BtnOkClick(Sender: TObject);
var
  ContentId :integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
  LsqlStr:string;
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
       LsqlStr:=' select * from Drs_alarm_content order by alarmcontentcode';
       Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,LsqlStr]),0);   //
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


procedure TFormDRS_ALARM_Mgr.ClearInfo;
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



procedure TFormDRS_ALARM_Mgr.SetControl(IsEdit: Boolean);
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

procedure TFormDRS_ALARM_Mgr.ShowAlarmContent;
var
  LsqlStr:string;

begin
  with Dm_MTS.cds_common do
  begin
    close;
    ProviderName:='dsp_General_data';
    LsqlStr:=' select alarmcontentcode as  �澯���ݱ��� , alarmcontentname as  �澯���� , alarmkindname as  �澯���� , alarmlevelname as �澯�ȼ� ,'+
                         ' alarmcondition as �澯��������,alarmcount as �澯�����ۼƴ�,'+
                         ' removecondition as �澯�ų�����,  removecount as �澯�ų��ۼƴ�,SENDTYPE as ��������,'+
                         ' limithour as �ų�ʱ��,  comname as �澯��Դ����, paramname as �澯��Դ����,'+
                         'IFINEFFECT as �Ƿ���Ч from drs_alarm_view order by alarmcontentcode';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
    FAdvGridSet.DrawGrid(Dm_MTS.cds_common,self.AdvStringGrid1);
    AdvStringGrid1.ColWidths[1]:=0;
    Close;
  end;
end;

procedure TFormDRS_ALARM_Mgr.UIChangeNormal;
begin
//  if BtnAdd.Tag=1 then
//    BtnAddClick(BtnAdd);
  if BtnModify.Tag=1 then
    BtnModifyClick(BtnModify);
end;

end.
