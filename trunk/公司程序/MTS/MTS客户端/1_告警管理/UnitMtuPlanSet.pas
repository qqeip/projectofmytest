unit UnitMtuPlanSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, StdCtrls, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, ComCtrls, ExtCtrls, dxtree, dxdbtree, DBClient, StringUtils,
  cxCheckBox, cxTimeEdit, CxGridUnit, ImgList;

type
  TFormMtuPlanSet = class(TForm)
    gbLeft: TGroupBox;
    TreeModel: TdxDBTreeView;
    Splitter1: TSplitter;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    cxGridMtuDBTableView1: TcxGridDBTableView;
    cxGridMtuLevel1: TcxGridLevel;
    cxGridMtu: TcxGrid;
    Panel2: TPanel;
    gbWeek: TGroupBox;
    cbWeek1: TCheckBox;
    cbWeek2: TCheckBox;
    cbWeek3: TCheckBox;
    cbWeek4: TCheckBox;
    cbWeek5: TCheckBox;
    cbWeek6: TCheckBox;
    cbWeek7: TCheckBox;
    Label1: TLabel;
    ComboBoxTestPlan: TComboBox;
    Panel3: TPanel;
    cxGridPlanDBTableView1: TcxGridDBTableView;
    cxGridPlanLevel1: TcxGridLevel;
    cxGridPlan: TcxGrid;
    cxGridPlanLevel2: TcxGridLevel;
    cxGridPlanDBTableView2: TcxGridDBTableView;
    Button1: TButton;
    Button2: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    GroupBox2: TGroupBox;
    cxGridCommand: TcxGrid;
    cxGridCommandDBTableView1: TcxGridDBTableView;
    cxGridCommandLevel1: TcxGridLevel;
    GroupBox3: TGroupBox;
    cxGridParam: TcxGrid;
    cxGridParamDBTableView1: TcxGridDBTableView;
    cxGridParamLevel1: TcxGridLevel;
    Button3: TButton;
    gDSTree: TDataSource;
    gCDSTree: TClientDataSet;
    gDS_Mtu: TDataSource;
    gCDS_Mtu: TClientDataSet;
    gDS_Command: TDataSource;
    gCDS_Command: TClientDataSet;
    gDS_PlanValue: TDataSource;
    gCDS_PlanValue: TClientDataSet;
    gCDS_PlanValue2: TClientDataSet;
    gDS_PlanValue2: TDataSource;
    gCDS_Param: TClientDataSet;
    gDS_Param: TDataSource;
    gCDS_Dym: TClientDataSet;
    Button4: TButton;
    Button5: TButton;
    cxGridPlanDBTableView1Column1: TcxGridDBColumn;
    cxGridPlanDBTableView1Column2: TcxGridDBColumn;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure TreeModelChange(Sender: TObject; Node: TTreeNode);
    procedure ComboBoxTestPlanChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cxGridCommandDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridMtuDBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure cxGridParamDBTableView1CustomDrawIndicatorCell(
      Sender: TcxGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
    procedure Button4Click(Sender: TObject);
    procedure TreeModelGetImageIndex(Sender: TObject; Node: TTreeNode);
  private
    FCxGridHelper : TCxGridSet;
    FIsSuccessPlaned: boolean;
    procedure LoadPlanTree;
    procedure LoadPlanComb;
    procedure LoadMtu(aModelID: integer);
    procedure LoadAllMtu;
    procedure LoadUnPlanMtu;
    procedure LoadParam(aMtuid,aComid: integer);
    procedure LoadCommand;
    procedure AddGridFieldMtu;
    procedure AddGridFieldCommand;
    procedure AddGridFieldParam;
    procedure AddGridFieldPlanValue;
    procedure AddGridFieldPlanValue2;
    procedure SetWeekChoose(aWeekStr: string);
    procedure SetPlanValue(aModelID: integer);
    procedure SaveMtuPlan(aMtuid,aModelID: integer);
    procedure SaveMtuParam(aMtuid,aComid,aParamid: integer;aValue:string);
    procedure ComfirmMtuPlan(aMtuid,aModelID: integer);
    function CheckRecordSelected(aView :TcxGridDBTableView):boolean;
    function CheckAlreadyApply(aModelid: integer; aMtuidStr:string):boolean;
  public
    { Public declarations }
  end;

var
  FormMtuPlanSet: TFormMtuPlanSet;

implementation

uses Ut_DataModule, Ut_Common, Ut_MainForm;
{$R *.dfm}


procedure TFormMtuPlanSet.AddGridFieldCommand;
begin
  AddViewField(cxGridCommandDBTableView1,'comname','������������',400);
end;

procedure TFormMtuPlanSet.AddGridFieldMtu;
begin
  AddViewField(cxGridMtuDBTableView1,'mtuid','�ڲ����');
  AddViewField(cxGridMtuDBTableView1,'mtuname','MTU����');
  AddViewField(cxGridMtuDBTableView1,'mtuno','MTU�ⲿ���',70);
  AddViewField(cxGridMtuDBTableView1,'overlay','��������',100);
  AddViewField(cxGridMtuDBTableView1,'mtuaddr','MTUλ��',300);
  AddViewField(cxGridMtuDBTableView1,'call','�绰����');
  AddViewField(cxGridMtuDBTableView1,'called','���к���');
  AddViewField(cxGridMtuDBTableView1,'MTUSTATUS','MTU״̬');
  AddViewField(cxGridMtuDBTableView1,'updatetime','״̬���ʱ��');
  AddViewField(cxGridMtuDBTableView1,'linkno','������');
  AddViewField(cxGridMtuDBTableView1,'buildingname','�����ҷֵ�',100);
  AddViewField(cxGridMtuDBTableView1,'MODELNAME','ģ������');

  AddViewField(cxGridMtuDBTableView1,'isprogramname','����/����');
  AddViewField(cxGridMtuDBTableView1,'mainlook_apname','�����AP');
  AddViewField(cxGridMtuDBTableView1,'mainlook_phsname','�����PHS');
  AddViewField(cxGridMtuDBTableView1,'mainlook_cnetname','�����C��');
  AddViewField(cxGridMtuDBTableView1,'cdmatypename','C����Դ����');
  AddViewField(cxGridMtuDBTableView1,'cdmaaddress','C����Դ��װλ��');
  AddViewField(cxGridMtuDBTableView1,'pncode','PN��');
end;

procedure TFormMtuPlanSet.AddGridFieldParam;
begin
  AddViewField(cxGridParamDBTableView1,'paramid','��������');
  AddViewField(cxGridParamDBTableView1,'paramname','��������',100);
  AddViewField(cxGridParamDBTableView1,'paramvalue','����ֵ',100);
  cxGridParamDBTableView1.Columns[0].Visible:= false;
end;

procedure TFormMtuPlanSet.AddGridFieldPlanValue;
begin
  AddViewField(cxGridPlanDBTableView1,'begintime','��ʼʱ��',300);
  AddViewField(cxGridPlanDBTableView1,'endtime','����ʱ��',300);
end;

procedure TFormMtuPlanSet.AddGridFieldPlanValue2;
begin
  AddViewField(cxGridPlanDBTableView2,'comname','��������',200);
  AddViewField(cxGridPlanDBTableView2,'cyccount','ѭ������',100);
  AddViewField(cxGridPlanDBTableView2,'timeinterval','ʱ����',100);
end;

procedure TFormMtuPlanSet.Button1Click(Sender: TObject);
var
  lModelID: integer;
  I: integer;
  lRecordIndex : integer;
  lMtuid, lMtuidIndex: integer;
  lModelPlanstr_Index: integer;
  vDeltaArray: OleVariant;
  lsuccess: boolean;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
  FIsSuccessPlaned:= false;
  if ComboBoxTestPlan.ItemIndex=-1 then
  begin
    application.MessageBox('δѡ����Լƻ���', '��ʾ', mb_ok);
    exit;
  end;
  try
    lMtuidIndex:=cxGridMtuDBTableView1.GetColumnByFieldName('mtuid').Index;
  except
    lMtuidIndex:=-1;
  end;
  try
    lModelPlanstr_Index:=cxGridMtuDBTableView1.GetColumnByFieldName('MODELNAME').Index;
  except
    lModelPlanstr_Index:=-1;
  end;
  if (lModelPlanstr_Index=-1) or (lModelPlanstr_Index=-1) then  exit;

  Screen.Cursor:= crHourglass;
  lsuccess:= false;
  try
    lModelID:= TWdInteger(ComboBoxTestPlan.Items.Objects[ComboBoxTestPlan.ItemIndex]).Value;
    for I := 0 to cxGridMtuDBTableView1.DataController.GetSelectedCount -1 do
    begin
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.GetSelectedRowIndex(i);
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
      lMtuid := cxGridMtuDBTableView1.DataController.GetValue(lRecordIndex,lMtuidIndex);
      //��ɾ�������е�ԭ��MODEL
      with Dm_MTS.cds_common do
      begin
        Close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,56,' and MTUID='+inttostr(lMtuid)]),0);
        while not Eof do
        begin
          delete;
        end;
      end;
      with Dm_MTS.cds_common1 do
      begin
        close;
        ProviderName:='dsp_General_data1';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,56,' and 1=2']),1);
        //����
        if lModelID<>-1 then //ȡ������
        begin
          append;
          Fieldbyname('ID').AsInteger:= Dm_MTS.TempInterface.GetTheSequenceId('mts_normal');
          Fieldbyname('modelid').AsInteger:= lModelID;
          Fieldbyname('mtuid').AsInteger:= lMtuid;
          Post;
        end;
      end;
      try
        vCDSArray[0]:=Dm_MTS.cds_common;
        vCDSArray[1]:=Dm_MTS.cds_common1;
        vDeltaArray:=RetrieveDeltas(vCDSArray);
        vProviderArray:=RetrieveProviders(vCDSArray);
        if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
          SysUtils.Abort;
        lsuccess:= true;
      except
        lsuccess:= false;
        break;
      end;
    end;
    if lsuccess then
    begin
      Application.MessageBox('�������óɹ���','��ʾ',MB_OK	);
      FIsSuccessPlaned:= true;
      //���½���
      for I := cxGridMtuDBTableView1.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := cxGridMtuDBTableView1.DataController.GetSelectedRowIndex(I);
        lRecordIndex := cxGridMtuDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
        cxGridMtuDBTableView1.DataController.SetValue(lRecordIndex,lModelPlanstr_Index,ComboBoxTestPlan.Text);
      end;
    end
    else
      application.MessageBox('��������ʧ�ܣ�','��ʾ',MB_OK );
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormMtuPlanSet.Button2Click(Sender: TObject);
var
  lModelID: integer;
  I, J: integer;
  lMtuid, lMtuidIndex: integer;
  ifPaste: boolean;
  lTestTaskid: integer;
  lComid: integer;
  lItemID: integer;
  lsuccess: boolean;
  lItemCount: integer;
  lRecordIndex: integer;
  lVariant: variant;
  lMtuidStr: string;
  lModelPlanvariant: variant;
  lModelPlanstr_Index: integer;
begin
  ifPaste:= false;
  try
    lMtuidIndex:=cxGridMtuDBTableView1.GetColumnByFieldName('mtuid').Index;
  except
    lMtuidIndex:=-1;
  end;
  try
    lModelPlanstr_Index:=cxGridMtuDBTableView1.GetColumnByFieldName('MODELNAME').Index;
  except
    lModelPlanstr_Index:=-1;
  end;
  if (lMtuidIndex=-1) or (lModelPlanstr_Index=-1) then  exit;

  Screen.Cursor:= crHourglass;
  lsuccess:= false;
  try
    if (ComboBoxTestPlan.itemindex=-1) or (ComboBoxTestPlan.ItemIndex=ComboBoxTestPlan.Items.Count-1) then
    begin
      Application.MessageBox('δѡ����Լƻ���','��ʾ',MB_OK	);
      exit;
    end;
    if not CheckRecordSelected(cxGridMtuDBTableView1) then
    begin
      Application.MessageBox('δѡ��MTU��','��ʾ',MB_OK	);
      exit;
    end;
    //�ж��Ƿ��Ѿ����üƻ�
    //�ж��Ƿ�ѡ��ƻ����ƺ���ǰ���õļƻ�һ�£������һ�£��ͰѸ�MTU���ó�ѡ��ļƻ�����
    for I := 0 to cxGridMtuDBTableView1.DataController.GetSelectedCount -1 do
    begin
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.GetSelectedRowIndex(i);
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
      lModelPlanvariant := cxGridMtuDBTableView1.DataController.GetValue(lRecordIndex,lModelPlanstr_Index);
      if (lModelPlanvariant = null) or (uppercase(vartostr(lModelPlanvariant))<>uppercase(ComboBoxTestPlan.Text))  then
      begin
        lMtuid := cxGridMtuDBTableView1.DataController.GetValue(lRecordIndex,lMtuidIndex);
        if application.MessageBox(pchar('MTU���Ϊ['+inttostr(lMtuid)+']δ���üƻ��������õļƻ���ѡ��ִ�еļƻ���һ��,'+#13+
                                 '�Ƿ��������¸�MTU�ļƻ�Ϊ['+ComboBoxTestPlan.Text+']?'), '��ʾ', mb_okcancel + mb_defbutton1) = idCancel then
          exit;
        Button1.OnClick(self);
        if not FIsSuccessPlaned then exit;
      end;
    end;
    //�ж��Ƿ����
    lModelID:= TWdInteger(ComboBoxTestPlan.Items.Objects[ComboBoxTestPlan.ItemIndex]).Value;
    lMtuidStr:= '';
    for I := 0 to cxGridMtuDBTableView1.DataController.GetSelectedCount -1 do
    begin
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.GetSelectedRowIndex(i);
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
      lMtuid := cxGridMtuDBTableView1.DataController.GetValue(lRecordIndex,lMtuidIndex);
      lMtuidStr:= lMtuidStr+inttostr(lMtuid)+',';
    end;
    if lMtuidStr<>'' then
      lMtuidStr:= copy(lMtuidStr,1,length(lMtuidStr)-1)
    else
      lMtuidStr:= '-1';
    if CheckAlreadyApply(lModelID,lMtuidStr) then
    begin
      if application.MessageBox('�Ƿ񸲸�ԭ����?', '��ʾ', mb_okcancel + mb_defbutton1) = idCancel then
        exit;
    end;
    //�ƻ����������
    gCDS_Dym.Close;
    gCDS_Dym.ProviderName:= 'dsp_General_data';
    gCDS_Dym.Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,61,' and a.modelid='+inttostr(lModelID)]),0);
    lItemCount:= gCDS_Dym.RecordCount;
    for I := 0 to cxGridMtuDBTableView1.DataController.GetSelectedCount -1 do
    begin
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.GetSelectedRowIndex(i);
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
      lMtuid := cxGridMtuDBTableView1.DataController.GetValue(lRecordIndex,lMtuidIndex);
      lVariant:= VarArrayCreate([0,lItemCount*2+1],varVariant);
      //ɾ�����ڲ���
      lVariant[0]:= VarArrayOf([0,2,68,' and modelid='+inttostr(lModelID)+' and mtuid='+inttostr(lMtuid)]);
      //ɾ����������
      lVariant[1]:= VarArrayOf([0,2,69,' and modelid='+inttostr(lModelID)+' and mtuid='+inttostr(lMtuid)]);
      gCDS_Dym.First;
      for J := 0 to gCDS_Dym.RecordCount - 1 do
      begin
        lComid:= gCDS_Dym.FieldByName('comid').AsInteger;
        lItemID:= gCDS_Dym.FieldByName('ID').AsInteger;
        lTestTaskid:=  Dm_MTS.TempInterface.GetTheSequenceId('mts_normal');
        //�������
        lVariant[2+J*2]:= VarArrayOf([0,2,70,lTestTaskid,lModelID,lMtuid,lItemID]);
        //��Ӳ���
        lVariant[2+J*2+1]:= VarArrayOf([0,2,71,lTestTaskid,lMtuid,lComid]);
        gCDS_Dym.Next;
      end;
      lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
      if not lsuccess then break;
    end;
    if lsuccess then
    begin
      Application.MessageBox('Ӧ�ò��Գɹ���','��ʾ',MB_OK	);
    end
    else
      application.MessageBox('Ӧ�ò���ʧ�ܣ�','��ʾ',MB_OK );
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormMtuPlanSet.Button3Click(Sender: TObject);
var
  I, J: integer;
  lRecordIndex : integer;
  lMtuid, lMtuidIndex: integer;
  lComid, lComidIndex: integer;
  lParamid, lParamidIndex: integer;
  lParamvalue: string;
  lParamvalueIndex: integer;
  lsuccess: boolean;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
  lsuccess:= false;
  try
    lMtuidIndex:=cxGridMtuDBTableView1.GetColumnByFieldName('mtuid').Index;
  except
    lMtuidIndex:=-1;
  end;
  try
    lComidIndex:=cxGridCommandDBTableView1.GetColumnByFieldName('comid').Index;
  except
    lComidIndex:=-1;
  end;
  try
    lParamidIndex:= cxGridParamDBTableView1.GetColumnByFieldName('paramid').Index;
  except
    lParamidIndex:= -1;
  end;
  try
    lParamvalueIndex:= cxGridParamDBTableView1.GetColumnByFieldName('paramvalue').Index;
  except
    lParamvalueIndex:= -1;
  end;
  if (lMtuidIndex=-1) or (lMtuidIndex=-1)
     or (lParamidIndex= -1) or (lParamvalueIndex=-1) then
  begin
    Application.MessageBox('δ��ùؼ��ֶ�MTUID,COMID,PARAMID��','��Ϣ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lComid := gCDS_Command.FieldByName('comid').AsInteger;
  if lComid=0 then
  begin
    Application.MessageBox('δѡ��������','��ʾ',MB_OK	);
    exit;
  end;

  Screen.Cursor:= crHourglass;
  try
    for I := 0 to cxGridMtuDBTableView1.DataController.GetSelectedCount - 1 do
    begin
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.GetSelectedRowIndex(i);
      lRecordIndex :=  cxGridMtuDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
      lMtuid := cxGridMtuDBTableView1.DataController.GetValue(lRecordIndex,lMtuidIndex);
      //ɾ��
      with Dm_MTS.cds_common do
      begin
        close;
        ProviderName:='dsp_General_data';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,62,
                                  ' and mtuid='+inttostr(lMtuid)+' and comid='+inttostr(lComid)]),0);
        while not eof do
        begin
          delete;
        end;
      end;
      with Dm_MTS.cds_common1 do
      begin
        close;
        ProviderName:='dsp_General_data1';
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,62,' and 1=2']),1);
        for J := 0 to cxGridParamDBTableView1.DataController.RecordCount - 1 do
        begin
          lParamid:=  cxGridParamDBTableView1.DataController.GetValue(J,lParamidIndex);
          lParamvalue:= cxGridParamDBTableView1.DataController.GetValue(J,lParamvalueIndex);
          append;
          Fieldbyname('mtuid').Value:= lMtuid;
          Fieldbyname('comid').Value:= lComid;
          Fieldbyname('paramid').Value:= lParamid;
          Fieldbyname('paramvalue').Value:= lParamvalue;
          post;
        end;
      end;
      try
        vCDSArray[0]:=Dm_MTS.cds_common;
        vCDSArray[1]:=Dm_MTS.cds_common1;
        vDeltaArray:=RetrieveDeltas(vCDSArray);
        vProviderArray:=RetrieveProviders(vCDSArray);
        if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
          SysUtils.Abort;
        lsuccess:= true;
      except
        lsuccess:= false;
        break;
      end;
    end;
    if lsuccess then
      Application.MessageBox('�������óɹ���','��ʾ',MB_OK	)
    else
      application.MessageBox('��������ʧ�ܣ�','��ʾ',MB_OK );
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormMtuPlanSet.Button4Click(Sender: TObject);
begin
  close;
end;

function TFormMtuPlanSet.CheckAlreadyApply(aModelid: integer;
  aMtuidStr: string): boolean;
begin
  with self.gCDS_Dym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,72,' and mtuid in ('+aMtuidStr+') and modelid='+inttostr(aModelid)]),0);
    if not eof then
      result:= true
    else
      result:= false;
  end;
end;

function TFormMtuPlanSet.CheckRecordSelected(
  aView: TcxGridDBTableView): boolean;
begin
  if (aView.DataController.DataSource.DataSet = nil) or
     (not aView.DataController.DataSource.DataSet.Active) or
     (aView.DataController.DataSource.DataSet.RecordCount<=0) or
     (aView.DataController.GetSelectedCount<=0)
  then
    Result := false
  else
    Result := True;
end;

procedure TFormMtuPlanSet.ComboBoxTestPlanChange(Sender: TObject);
var
  lModelID: integer;
begin
  if ComboBoxTestPlan.ItemIndex=-1 then exit;
  lModelID:= TWdInteger(ComboBoxTestPlan.Items.Objects[ComboBoxTestPlan.ItemIndex]).Value;
//  SetPlanValue(lModelID);

  //��ʾ�����б�ʱ���
  gDS_PlanValue.DataSet:= nil;
  with gCDS_PlanValue do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,24,lModelID]),0);
  end;
  gDS_PlanValue.DataSet:= gCDS_PlanValue;
  //��ʾ�����б�ϸ��
  gDS_PlanValue2.DataSet:= nil;
  with gCDS_PlanValue2 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,2,25,lModelID]),0);
  end;
  gDS_PlanValue2.DataSet:= gCDS_PlanValue2;
end;

procedure TFormMtuPlanSet.ComfirmMtuPlan(aMtuid, aModelID: integer);
begin
  //
end;

procedure TFormMtuPlanSet.cxGridCommandDBTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  lMtuid: integer;
  lComid: integer;
begin
  lMtuid:= gCDS_Mtu.FieldByName('mtuid').AsInteger;
  lComid:= gCDS_Command.FieldByName('comid').AsInteger;
  if (lMtuid<>0) and (lComid<>0) then
    LoadParam(lMtuid,lComid);
end;

procedure TFormMtuPlanSet.cxGridMtuDBTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  lMtuid: integer;
  lComid: integer;
begin
  lMtuid:= gCDS_Mtu.FieldByName('mtuid').AsInteger;
  lComid:= gCDS_Command.FieldByName('comid').AsInteger;
  if (lMtuid<>0) and (lComid<>0) then
    LoadParam(lMtuid,lComid);
end;

procedure TFormMtuPlanSet.cxGridParamDBTableView1CustomDrawIndicatorCell(
  Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
begin
  if not (AViewInfo is TcxGridIndicatorRowItemViewInfo) then
    exit;
end;

procedure TFormMtuPlanSet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCxGridHelper.Free;

  ClearTStrings(ComboBoxTestPlan.Items);
//  gCDS_Mtu.Close;
//  gCDSTree.Close;
//  gCDS_Command.Close;
//  gCDS_PlanValue.Close;
//  gCDS_PlanValue2.Close;
//  gCDS_Param.Close;
//  gCDS_Dym.Close;

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormMtuPlanSet:=nil;
end;

procedure TFormMtuPlanSet.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridMtu,true,false,true);
  FCxGridHelper.SetGridStyle(cxGridPlan,true,false,true);
  FCxGridHelper.SetGridStyle(cxGridCommand,true,false,true);
  FCxGridHelper.SetGridStyle(cxGridParam,true,false,true);
  cxGridParamDBTableView1.OptionsData.Editing:= true;
end;

procedure TFormMtuPlanSet.FormShow(Sender: TObject);
begin
  self.LoadPlanTree;
  self.LoadCommand;
  self.PageControl1.ActivePageIndex:= 0;

  AddGridFieldMtu;
  AddGridFieldCommand;
  AddGridFieldParam;
  LoadPlanComb;
//  AddGridFieldPlanValue;
  AddGridFieldPlanValue2;
end;

procedure TFormMtuPlanSet.LoadAllMtu;
begin
  gDS_Mtu.DataSet:= nil;
  with gCDS_Mtu do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,65,'','']),0);
  end;
  gDS_Mtu.DataSet:= gCDS_Mtu;
  cxGridMtuDBTableView1.ApplyBestFit();
end;

procedure TFormMtuPlanSet.LoadCommand;
begin
  gDS_Command.DataSet:= nil;
  with gCDS_Command do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,53]),0);
  end;
  gDS_Command.DataSet:= gCDS_Command;
end;

procedure TFormMtuPlanSet.LoadMtu(aModelID: integer);
begin
  gDS_Mtu.DataSet:= nil;
  with gCDS_Mtu do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,52,' and b.MODELID='+inttostr(aModelID),'']),0);
  end;
  gDS_Mtu.DataSet:= gCDS_Mtu;
  self.cxGridMtuDBTableView1.ApplyBestFit();
end;

procedure TFormMtuPlanSet.LoadParam(aMtuid, aComid: integer);
begin
  gDS_Param.DataSet:= nil;
  with gCDS_Param do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,55,' and mtuid='+inttostr(aMtuid)+' and comid='+inttostr(aComid),'']),0);
  end;
  gDS_Param.DataSet:= gCDS_Param;
end;

procedure TFormMtuPlanSet.LoadPlanComb;
var
  lWdInteger:TWdInteger;
begin
  ClearTStrings(ComboBoxTestPlan.Items);
  with gCDS_Dym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,54]),0);
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('modelid').AsInteger);
      ComboBoxTestPlan.Items.AddObject(Fieldbyname('modelname').AsString,lWdInteger);
      next;
    end;
    lWdInteger:=TWdInteger.Create(-1);
    ComboBoxTestPlan.Items.AddObject('δ����',lWdInteger);
  end;
end;

procedure TFormMtuPlanSet.LoadPlanTree;
begin
  gDSTree.DataSet:= nil;
  with gCDSTree do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,51]),0);
  end;
  gDSTree.DataSet:= gCDSTree;
end;

procedure TFormMtuPlanSet.LoadUnPlanMtu;
begin
  gDS_Mtu.DataSet:= nil;
  with gCDS_Mtu do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,66,'','']),0);
  end;
  gDS_Mtu.DataSet:= gCDS_Mtu;
  self.cxGridMtuDBTableView1.ApplyBestFit();
end;

procedure TFormMtuPlanSet.SaveMtuParam(aMtuid, aComid, aParamid: integer;
  aValue: string);
begin
  //
end;

procedure TFormMtuPlanSet.SaveMtuPlan(aMtuid, aModelID: integer);
begin
  //
end;

procedure TFormMtuPlanSet.SetPlanValue(aModelID: integer);
begin
  gDS_PlanValue.DataSet:= nil;
  with gCDS_PlanValue do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,61,' and a.modelid='+inttostr(aModelID)+'']),0);
  end;
  gDS_PlanValue.DataSet:= gCDS_PlanValue;

  gDS_PlanValue2.DataSet:= nil;
  with gCDS_PlanValue2 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,61,' and a.modelid='+inttostr(aModelID)+'']),0);
  end;
  gDS_PlanValue2.DataSet:= gCDS_PlanValue2;
end;

procedure TFormMtuPlanSet.SetWeekChoose(aWeekStr: string);
var
  I: integer;
begin
  for I := 0 to gbWeek.ControlCount - 1 do
    TCheckBox(gbWeek.Controls[I]).Checked := pos(IntToStr(I+1), aWeekStr) > 0;
end;

procedure TFormMtuPlanSet.TreeModelChange(Sender: TObject; Node: TTreeNode);
var
  lModelID: integer;
  lParentID: integer;
  lModelName: string;
  lOldIndex: integer;
begin
  lModelID:= gCDSTree.FieldByName('ModelID').AsInteger;
  lParentID:= gCDSTree.FieldByName('PARENTMODELID').AsInteger;
  lModelName:= gCDSTree.FieldByName('MODELNAME').AsString;
  //��ʾ����
  if (lParentID=0) and (lModelID<>999999) then
  begin
    LoadAllMtu;
    exit;
  end else
  if (lParentID=0) and (lModelID=999999) then
  begin
    LoadUnPlanMtu;
    exit;
  end;
  if lParentID=1 then exit;
  //��ʾ����
  SetWeekChoose(gCDSTree.FieldByName('PLANDATE').AsString);
  lOldIndex:=  ComboBoxTestPlan.ItemIndex;
  ComboBoxTestPlan.ItemIndex:= ComboBoxTestPlan.Items.IndexOf(lModelName);
  if lOldIndex<> ComboBoxTestPlan.ItemIndex then
    ComboBoxTestPlan.OnChange(self);
  LoadMtu(lModelID);
end;

procedure TFormMtuPlanSet.TreeModelGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  Node.SelectedIndex:= Node.Level;
  Node.ImageIndex:= Node.SelectedIndex;
end;

end.
