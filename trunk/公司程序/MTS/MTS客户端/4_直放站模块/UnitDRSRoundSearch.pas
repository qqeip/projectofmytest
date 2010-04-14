unit UnitDRSRoundSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, StdCtrls, DBCtrls, ExtCtrls, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView, StringUtils,
  cxGridTableView, cxGridDBTableView, cxGrid, DBClient, CxGridUnit, WrmPLdrs_autotest_cmd,
  Spin, Menus;

type
  TActedPage= set of (wd_Acted_DrsList,
                      wd_Acted_TaskList);
type
  TFormDRSRoundSearch = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    cxGridDRSList: TcxGrid;
    cxGridDBTVDRSList: TcxGridDBTableView;
    cxGridDRSListLevel1: TcxGridLevel;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    Panel3: TPanel;
    Label1: TLabel;
    ButtonQuery: TButton;
    EditSearch: TEdit;
    ComboBoxDRSTYPE: TComboBox;
    ComboBoxCommand: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ButtonSend: TButton;
    GroupBox2: TGroupBox;
    PageControl3: TPageControl;
    TabSheet4: TTabSheet;
    Panel1: TPanel;
    Label10: TLabel;
    ButtonQuery1: TButton;
    EditSearch1: TEdit;
    ComboBoxDRSTYPE1: TComboBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    ClientDataSet2: TClientDataSet;
    DataSource2: TDataSource;
    Button5: TButton;
    SpinEditInterval: TSpinEdit;
    Label11: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    SpinEditInterval1: TSpinEdit;
    ClientDataSetDym: TClientDataSet;
    cxGridTaskListDBTableView1: TcxGridDBTableView;
    cxGridTaskListLevel1: TcxGridLevel;
    cxGridTaskList: TcxGrid;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DateTimePicker3: TDateTimePicker;
    DateTimePicker4: TDateTimePicker;
    Label12: TLabel;
    SpinEditCounts1: TSpinEdit;
    SpinEditCounts: TSpinEdit;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonQueryClick(Sender: TObject);
    procedure ButtonSendClick(Sender: TObject);
    procedure ComboBoxCommandChange(Sender: TObject);
    procedure cxGridDBTVDRSListCellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure PageControl1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cxGridTaskListDBTableView1CellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure cxGridTaskListDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    gIsSys: boolean;
    FMenu1: TMenuItem;
    gSearchWhere_Local1,gSearchWhere_Local2: string;
    gActedPage: TActedPage;
    FCxGridHelper, FCxGridHelper1: TCxGridSet;
    FWrmPLdrs_autotest_cmd: TWrmPLdrs_autotest_cmd;
    procedure GetCommandItem(DicCodeItems:TStrings);
    procedure AddDRSListField(aView: TcxGridDBTableView);
    procedure AddTaskListField(aView: TcxGridDBTableView);
    procedure LoadParams(aView: TcxGridDBTableView; aComBox: TComboBox);
    function CheckDatetime(aBegin, aEnd: TDateTime): boolean;
    procedure ActionSearchTaskExecute(Sender: TObject);
  public
    { Public declarations }
    procedure RefreshDRSList(aWhere: string);
    procedure RefreshTaskList(aWhere: string);
  end;

var
  FormDRSRoundSearch: TFormDRSRoundSearch;

implementation

uses Ut_Common, Ut_MainForm, Ut_DataModule;

{$R *.dfm}

procedure TFormDRSRoundSearch.ActionSearchTaskExecute(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
  lDrsid, lDrsid_Index: integer;
begin
  gIsSys:= true;
  try
    lActiveView:= self.cxGridDBTVDRSList;
    try
      lDRSID_Index:=lActiveView.GetColumnByFieldName('DRSID').Index;
    except
      Application.MessageBox('δ��ùؼ��ֶ�DRSID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    if lActiveView.DataController.GetSelectedCount=0 then exit;
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
    lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    lDRSID:= lActiveView.DataController.GetValue(lRecordIndex,lDRSID_Index);
    //�л�ҳ��
    PageControl1.ActivePageIndex:= 1;
    RefreshTaskList(' and b.drsid='+inttostr(lDRSID));
  finally
    gIsSys:= false;
  end;
end;

procedure TFormDRSRoundSearch.AddDRSListField(aView: TcxGridDBTableView);
begin
  AddViewField(aView,'DRSID','ֱ��վ�ڲ����');
  AddViewField(aView,'DRSNO','ֱ��վ���');
  AddViewField(aView,'R_DEVICEID','�����豸���');
  AddViewField(aView,'DRSNAME','ֱ��վ����');
  AddViewField(aView,'DRSTYPEName','ֱ��վ����');
  AddViewField(aView,'DRSMANUName','ֱ��վ����');
  AddViewField(aView,'ISPROGRAMName','�Ƿ��ҷ�');
  AddViewField(aView,'SUBURBName','�����־�');
  AddViewField(aView,'buildingname','�����ҷֵ�');
  AddViewField(aView,'CS','������վ');
  AddViewField(aView,'MSC','����MSC');
  AddViewField(aView,'BSC','����BSC');
  AddViewField(aView,'CELL','��������');
  AddViewField(aView,'PN','PN��');
  AddViewField(aView,'AGENTMANU','��ά��˾');
  AddViewField(aView,'LONGITUDE','����');
  AddViewField(aView,'LATITUDE','γ��');
  AddViewField(aView,'DRSADRESS','��ַ');
  AddViewField(aView,'DRSPHONE','�绰����');
  AddViewField(aView,'DRSSTATUSName','��ǰ״̬');
  AddViewField(aView,'UPDATETIME1','���״̬���ʱ��');
  AddViewField(aView,'UPDATETIME2','���״̬��ȡʱ��');
  AddViewField(aView,'ALARMCOUNTS','��ǰ�澯��');
  AddViewField(aView,'UPDATETIME3','�������ʱ��');
  AddViewField(aView,'UPDATETIME4','������ø���ʱ��');
  AddViewField(aView,'IS33','����ֱ��վ������ѯ����');
  AddViewField(aView,'IS32','���޼��ϵͳ������ѯ����');
end;

procedure TFormDRSRoundSearch.AddTaskListField(aView: TcxGridDBTableView);
begin
  AddViewField(aView,'ID','��ˮ��');
  AddViewField(aView,'DRSID','ֱ��վ�ڲ����');
  AddViewField(aView,'DRSNO','ֱ��վ���');
  AddViewField(aView,'R_DEVICEID','�����豸���');
  AddViewField(aView,'DRSNAME','ֱ��վ����');
  AddViewField(aView,'DRSTYPEName','ֱ��վ����');
  AddViewField(aView,'DRSMANUName','ֱ��վ����');
  AddViewField(aView,'DRSADRESS','��ַ');
  AddViewField(aView,'COMID','������');
  AddViewField(aView,'COMNAME','�����');
  AddViewField(aView,'ifpause','��ѵ״̬');
  AddViewField(aView,'BEGINTIME','��ѯ��ʼʱ��');
  AddViewField(aView,'ENDTIME','��ѯ����ʱ��');
  AddViewField(aView,'CYCCOUNTS','��ѯ����');
  AddViewField(aView,'TIME_INTERVAL','��ѯ���');
  AddViewField(aView,'CURR_CYCCOUNT','����ɴ���');
  AddViewField(aView,'SUCC_CYCCOUNT','�ɹ�����');
end;

procedure TFormDRSRoundSearch.Button2Click(Sender: TObject);
var
  lComid, lDrsid, lDrsid_Index, lComid_Index: integer;
  lId, lId_Index: integer;
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
  lIndex: integer;
  I, J: integer;
  lBegin_Index, lEnd_Index, lInterval_Index, lCycCounts_Index: integer;
begin
  lActiveView:= self.cxGridTaskListDBTableView1;
  try
    lDRSID_Index:=lActiveView.GetColumnByFieldName('DRSID').Index;
    lComid_Index:= lActiveView.GetColumnByFieldName('COMID').Index;
    lId_Index:=lActiveView.GetColumnByFieldName('ID').Index;
    lBegin_Index:= lActiveView.GetColumnByFieldName('BEGINTIME').Index;
    lEnd_Index:= lActiveView.GetColumnByFieldName('ENDTIME').Index;
    lInterval_Index:= lActiveView.GetColumnByFieldName('TIME_INTERVAL').Index;
    lCycCounts_Index:= lActiveView.GetColumnByFieldName('CYCCOUNTS').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�DRSID,COMID,ID,BEGINTIME,ENDTIME��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if lActiveView.DataController.GetSelectedCount=0 then exit;
  if not CheckDatetime(DateTimePicker3.DateTime,DateTimePicker4.DateTime) then
  begin
    Application.MessageBox('��ʼʱ�䲻�ܴ��ڽ���ʱ�䣡','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  //�ж���ѡ�Ƿ����
  for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
  begin
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
    lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    lDrsid:= lActiveView.DataController.GetValue(lRecordIndex,lDRSID_Index);
    lComid:= lActiveView.DataController.GetValue(lRecordIndex,lComid_Index);
    lId:= lActiveView.DataController.GetValue(lRecordIndex,lId_Index);
    //�Ѿ���������
    if FWrmPLdrs_autotest_cmd.IsExistsTask(lDrsid,lComid,
                      DateTimePicker3.DateTime,DateTimePicker4.DateTime,lId) then
    begin
      Application.MessageBox('�Ѿ����ڲ���������������ʱ��㽻�棡','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
  end;
  Screen.Cursor := crHourGlass;
  try
    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lId:= lActiveView.DataController.GetValue(lRecordIndex,lId_Index);
      FWrmPLdrs_autotest_cmd.ID:= lId;
      FWrmPLdrs_autotest_cmd.TIME_INTERVAL:= SpinEditInterval1.Value;
      FWrmPLdrs_autotest_cmd.CYCCOUNTS:= SpinEditCounts1.Value;
      FWrmPLdrs_autotest_cmd.BEGINTIME:= DateTimePicker3.DateTime;
      FWrmPLdrs_autotest_cmd.ENDTIME:= DateTimePicker4.DateTime;
      if FWrmPLdrs_autotest_cmd.Update then
      begin
        if I=0 then
        begin
          Application.MessageBox('�����ɹ���','��ʾ',MB_OK	+MB_ICONINFORMATION);
          //ˢ��ҳ��
          gActedPage:= gActedPage - [wd_Acted_DrsList];
          gActedPage:= gActedPage - [wd_Acted_TaskList];
          for j := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(j);
            lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
            lActiveView.DataController.setvalue(lRecordIndex, lBegin_Index,FormatDateTime('HH:MM',DateTimePicker3.DateTime));
            lActiveView.DataController.setvalue(lRecordIndex, lEnd_Index,FormatDateTime('HH:MM',DateTimePicker4.DateTime));
            lActiveView.DataController.setvalue(lRecordIndex, lInterval_Index,SpinEditInterval1.Value);
            lActiveView.DataController.setvalue(lRecordIndex, lCycCounts_Index,SpinEditCounts1.Value);
          end;
        end;
      end
      else
      begin
        Application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK	+MB_ICONERROR);
        break;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDRSRoundSearch.Button3Click(Sender: TObject);
var
  lId, lId_Index: integer;
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
  I, j: integer;
  lIfpause_Index: integer;
  lIfpauser: string;
begin
  lActiveView:= self.cxGridTaskListDBTableView1;
  try
    lId_Index:=lActiveView.GetColumnByFieldName('ID').Index;
    lIfpause_Index:= lActiveView.GetColumnByFieldName('IFPAUSE').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�ID,IFPAUSE��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if lActiveView.DataController.GetSelectedCount=0 then exit;
  Screen.Cursor := crHourGlass;
  try
    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lId:= lActiveView.DataController.GetValue(lRecordIndex,lId_Index);
      lIfpauser:= lActiveView.DataController.GetValue(lRecordIndex,lIfpause_Index);

      FWrmPLdrs_autotest_cmd.ID:= lId;
      if FWrmPLdrs_autotest_cmd.SetPause(1) then
      begin
        if I=0 then
        begin
          Application.MessageBox('�����ɹ���','��ʾ',MB_OK	+MB_ICONINFORMATION);
          //ˢ��ҳ��
          gActedPage:= gActedPage - [wd_Acted_DrsList];
          gActedPage:= gActedPage - [wd_Acted_TaskList];
          for j := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(j);
            lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
            lActiveView.DataController.setvalue(lRecordIndex, lIfpause_Index,'��ͣ');
          end;
          Button4.Enabled :=True;
          Button3.Enabled :=False;
        end;
      end
      else
      begin
        Application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK	+MB_ICONERROR);
        break;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDRSRoundSearch.Button4Click(Sender: TObject);
var
  lId, lId_Index: integer;
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
  I, j: integer;
  lIfpause_Index: integer;
  lIfpauser: string;
begin
  lActiveView:= self.cxGridTaskListDBTableView1;
  try
    lId_Index:=lActiveView.GetColumnByFieldName('ID').Index;
    lIfpause_Index:= lActiveView.GetColumnByFieldName('IFPAUSE').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�ID,IFPAUSE��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if lActiveView.DataController.GetSelectedCount=0 then exit;
  Screen.Cursor := crHourGlass;
  try
    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lId:= lActiveView.DataController.GetValue(lRecordIndex,lId_Index);
      lIfpauser:= lActiveView.DataController.GetValue(lRecordIndex,lIfpause_Index);

      FWrmPLdrs_autotest_cmd.ID:= lId;
      if FWrmPLdrs_autotest_cmd.SetPause(0) then
      begin
        if I=0 then
        begin
          Application.MessageBox('�����ɹ���','��ʾ',MB_OK	+MB_ICONINFORMATION);
          //ˢ��ҳ��
          gActedPage:= gActedPage - [wd_Acted_DrsList];
          gActedPage:= gActedPage - [wd_Acted_TaskList];
          for j := lActiveView.DataController.GetSelectedCount -1 downto 0 do
          begin
            lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(j);
            lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
            lActiveView.DataController.setvalue(lRecordIndex, lIfpause_Index,'ִ����');
          end;
          Button3.Enabled :=True;
          Button4.Enabled :=False;
        end;
      end
      else
      begin
        Application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK	+MB_ICONERROR);
        break;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDRSRoundSearch.Button5Click(Sender: TObject);
var
  lId, lId_Index: integer;
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
  I: integer;
begin
  lActiveView:= self.cxGridTaskListDBTableView1;
  try
    lId_Index:=lActiveView.GetColumnByFieldName('ID').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�ID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if lActiveView.DataController.GetSelectedCount=0 then exit;
  Screen.Cursor := crHourGlass;
  try
    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lId:= lActiveView.DataController.GetValue(lRecordIndex,lId_Index);
      FWrmPLdrs_autotest_cmd.ID:= lId;
      if FWrmPLdrs_autotest_cmd.DeleteByID then
      begin
        if I=0 then
        begin
          Application.MessageBox('�����ɹ���','��ʾ',MB_OK	+MB_ICONINFORMATION);
          //ˢ��ҳ��
          gActedPage:= gActedPage - [wd_Acted_DrsList];
          gActedPage:= gActedPage - [wd_Acted_TaskList];
          lActiveView.DataController.DeleteSelection;
        end;
      end
      else
      begin
        Application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK	+MB_ICONERROR);
        break;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDRSRoundSearch.ButtonQueryClick(Sender: TObject);
var
 lSearchStr: string;
begin
  if Sender=self.ButtonQuery then
  begin
    lSearchStr:= self.EditSearch.Text;
    if ComboBoxDRSTYPE.Items.IndexOf(ComboBoxDRSTYPE.Text)=-1 then
      gSearchWhere_Local1:= ''
    else
      gSearchWhere_Local1:= ' and a.drstype='+TWdInteger(ComboBoxDRSTYPE.Items.Objects[ComboBoxDRSTYPE.ItemIndex]).ToString;
    if lSearchStr<>'' then
      gSearchWhere_Local1:= gSearchWhere_Local1+ ' and (upper(a.drsno) like ''%'+uppercase(lSearchStr)+'%'''+
                             ' or upper(a.drsname) like ''%'+uppercase(lSearchStr)+'%'''+
                             ' or upper(a.DRSADRESS) like ''%'+uppercase(lSearchStr)+'%'''+
                             ' or upper(a.drsphone) like ''%'+uppercase(lSearchStr)+'%'''+
                             ')';
    RefreshDRSList(gSearchWhere_Local1);
  end
  else if Sender= self.ButtonQuery1 then
  begin
    lSearchStr:= self.EditSearch1.Text;
    if ComboBoxDRSTYPE1.Items.IndexOf(ComboBoxDRSTYPE1.Text)=-1 then
      gSearchWhere_Local2:= ''
    else
      gSearchWhere_Local2:= ' and a.drstype='+TWdInteger(ComboBoxDRSTYPE1.Items.Objects[ComboBoxDRSTYPE1.ItemIndex]).ToString;
    if lSearchStr<>'' then
      gSearchWhere_Local2:= gSearchWhere_Local2+ ' and (upper(a.drsno) like ''%'+uppercase(lSearchStr)+'%'''+
                           ' or upper(a.drsname) like ''%'+uppercase(lSearchStr)+'%'''+
                           ' or upper(a.DRSADRESS) like ''%'+uppercase(lSearchStr)+'%'''+
                           ' or upper(a.drsphone) like ''%'+uppercase(lSearchStr)+'%'''+
                           ')';
    RefreshTaskList(gSearchWhere_Local2)
  end
  else exit;
end;

procedure TFormDRSRoundSearch.ButtonSendClick(Sender: TObject);
var
  lComid, lDrsid, lDrsid_Index: integer;
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
  lIndex: integer;
  I: integer;
begin
  lActiveView:= self.cxGridDBTVDRSList;
  try
    lDRSID_Index:=lActiveView.GetColumnByFieldName('DRSID').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�DRSID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if lActiveView.DataController.GetSelectedCount=0 then
  begin
    Application.MessageBox('δѡ����Ӧֱ��վ��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lIndex:= ComboBoxCommand.Items.IndexOf(ComboBoxCommand.Text);
  if lIndex= -1 then
  begin
    Application.MessageBox('ѡ��һ���������','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lComid:= TWdInteger(ComboBoxCommand.Items.Objects[lIndex]).Value;
  if not CheckDatetime(DateTimePicker1.DateTime,DateTimePicker2.DateTime) then
  begin
    Application.MessageBox('��ʼʱ�䲻�ܴ��ڽ���ʱ�䣡','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  //�ж���ѡ�Ƿ����
  for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
  begin
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
    lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    lDrsid:= lActiveView.DataController.GetValue(lRecordIndex,lDRSID_Index);
    //�Ѿ���������
    if FWrmPLdrs_autotest_cmd.IsExistsTask(lDrsid,lComid,
                      DateTimePicker1.DateTime,DateTimePicker2.DateTime) then
    begin
      Application.MessageBox('�Ѿ����ڲ���������������ʱ��㽻�棡','��ʾ',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
  end;
  Screen.Cursor := crHourGlass;
  try
    for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
      lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
      lDrsid:= lActiveView.DataController.GetValue(lRecordIndex,lDRSID_Index);
      FWrmPLdrs_autotest_cmd.DRSID:= lDrsid;
      FWrmPLdrs_autotest_cmd.COMID:= lComid;
      FWrmPLdrs_autotest_cmd.TIME_INTERVAL:= SpinEditInterval.Value;
      FWrmPLdrs_autotest_cmd.CYCCOUNTS:= SpinEditCounts.Value;
      FWrmPLdrs_autotest_cmd.BEGINTIME:= DateTimePicker1.DateTime;
      FWrmPLdrs_autotest_cmd.ENDTIME:= DateTimePicker2.DateTime;
      if FWrmPLdrs_autotest_cmd.Insert then
      begin
        if I=0 then
        begin
          Application.MessageBox('�����ɹ���','��ʾ',MB_OK	+MB_ICONINFORMATION);
          //ˢ��ҳ��
          gActedPage:= gActedPage - [wd_Acted_DrsList];
          gActedPage:= gActedPage - [wd_Acted_TaskList];
        end;
      end
      else
      begin
        Application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK	+MB_ICONERROR);
        break;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TFormDRSRoundSearch.CheckDatetime(aBegin, aEnd: TDateTime): boolean;
begin
  if aBegin>aEnd then
    result:= false
  else
    result:= true;
end;

procedure TFormDRSRoundSearch.ComboBoxCommandChange(Sender: TObject);
begin
  LoadParams(self.cxGridDBTVDRSList,self.ComboBoxCommand);
end;

procedure TFormDRSRoundSearch.cxGridDBTVDRSListCellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  LoadParams(self.cxGridDBTVDRSList,self.ComboBoxCommand);
end;

procedure TFormDRSRoundSearch.cxGridTaskListDBTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
  lID, lID_Index: integer;
begin
  lActiveView:= cxGridTaskListDBTableView1;
  try
    lID_Index:=lActiveView.GetColumnByFieldName('ID').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�ID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if lActiveView.DataController.GetSelectedCount=0 then exit;
  lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
  lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
  Screen.Cursor := crHourGlass;
  try
    lID:= lActiveView.DataController.GetValue(lRecordIndex,lID_Index);
    if FWrmPLdrs_autotest_cmd.GetParamsInfo2(lID) then
    begin
    DateTimePicker3.DateTime:= FWrmPLdrs_autotest_cmd.BEGINTIME;
    DateTimePicker4.DateTime:= FWrmPLdrs_autotest_cmd.ENDTIME;
    SpinEditCounts1.Value:=  FWrmPLdrs_autotest_cmd.CYCCOUNTS;
    SpinEditInterval1.Value:= FWrmPLdrs_autotest_cmd.TIME_INTERVAL;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDRSRoundSearch.cxGridTaskListDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  Timer1.Enabled:= true;
end;

procedure TFormDRSRoundSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //
  ClearTStrings(ComboBoxDRSTYPE.Items);
  ClearTStrings(ComboBoxDRSTYPE1.Items);
  ClearTStrings(ComboBoxCommand.Items);

  FCxGridHelper.Free;
  FCxGridHelper1.Free;
  FWrmPLdrs_autotest_cmd.Free;

  Fm_MainForm.DeleteTab(self);
  Action:=caFree;
  FormDRSRoundSearch:= nil;
end;

procedure TFormDRSRoundSearch.FormCreate(Sender: TObject);
begin
  EditSearch.Hint:= 'ͨ��ֱ��վ��š�ֱ��վ���ơ�ֱ��վ��ַ��ֱ��վ�绰������в�ѯ';
  EditSearch1.Hint:= 'ͨ��ֱ��վ��š�ֱ��վ���ơ�ֱ��վ��ַ��ֱ��վ�绰������в�ѯ';
  EditSearch.ShowHint:= true;
  EditSearch1.ShowHint:= true;
  gIsSys:= true;
  PageControl1.ActivePageIndex:= 0;
  gIsSys:= false;
  gActedPage:= [];
  DateTimePicker1.DateTime:= now;
  DateTimePicker2.DateTime:= now;
  DateTimePicker3.DateTime:= now;
  DateTimePicker4.DateTime:= now;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper1:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDRSList,false,false,true);
  FCxGridHelper1.SetGridStyle(cxGridTaskList,false,false,true);
  FMenu1:= FCxGridHelper.AppendMenuItem('�鿴��ѵ����',ActionSearchTaskExecute);

  FWrmPLdrs_autotest_cmd:= TWrmPLdrs_autotest_cmd.Create;
end;

procedure TFormDRSRoundSearch.FormShow(Sender: TObject);
begin
  //
  GetDic(51,ComboBoxDRSTYPE.Items);
  GetDic(51,ComboBoxDRSTYPE1.Items);
  GetCommandItem(ComboBoxCommand.Items);

  AddDRSListField(cxGridDBTVDRSList);
  AddTaskListField(cxGridTaskListDBTableView1);
  RefreshDRSList(gSearchWhere_Local1);
end;

procedure TFormDRSRoundSearch.GetCommandItem(DicCodeItems: TStrings);
var
  lWdInteger:TWdInteger;
  lSqlstr: string;
begin
  ClearTStrings(DicCodeItems);
  with ClientDataSetDym do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select t.comid,t.comname from drs_command_define t'+
              ' where t.comid in (32,33) and t.ifineffect=1';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('comid').AsInteger);
      DicCodeItems.AddObject(Fieldbyname('comname').AsString,lWdInteger);
      next;
    end;
    Close;
  end;
end;

procedure TFormDRSRoundSearch.LoadParams(aView: TcxGridDBTableView;
  aComBox: TComboBox);
var
  lActiveView: TcxGridDBTableView;
  lRecordIndex: integer;
  lDRSID, lDRSID_Index: integer;
  lComid: integer;
  lIndex: integer;
begin
  lActiveView:= aView;
  try
    lDRSID_Index:=lActiveView.GetColumnByFieldName('DRSID').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�DRSID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if lActiveView.DataController.GetSelectedCount=0 then exit;
  lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(0);
  lRecordIndex:= lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
  Screen.Cursor := crHourGlass;
  try
    lDRSID:= lActiveView.DataController.GetValue(lRecordIndex,lDRSID_Index);
    lIndex:= aComBox.Items.IndexOf(aComBox.Text);
    if lIndex<> -1 then
    begin
      lComid:= TWdInteger(aComBox.Items.Objects[lIndex]).Value;
      if FWrmPLdrs_autotest_cmd.GetParamsInfo(lDRSID,lComid) then
      begin
      DateTimePicker1.DateTime:= FWrmPLdrs_autotest_cmd.BEGINTIME;
      DateTimePicker2.DateTime:= FWrmPLdrs_autotest_cmd.ENDTIME;
      SpinEditCounts.Value:=  FWrmPLdrs_autotest_cmd.CYCCOUNTS;
      SpinEditInterval.Value:= FWrmPLdrs_autotest_cmd.TIME_INTERVAL;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormDRSRoundSearch.PageControl1Change(Sender: TObject);
begin
  if self.gIsSys then exit;//ϵͳ�������Ͳ���Ҫ����
  if (PageControl1.ActivePage= TabSheet1) and not (wd_Acted_DrsList in gActedPage) then
  begin
    gActedPage:= gActedPage+ [wd_Acted_DrsList];
    RefreshDRSList(gSearchWhere_Local1);
  end
  else
  if (PageControl1.ActivePage= TabSheet2) and not (wd_Acted_TaskList in gActedPage) then
  begin
    gActedPage:= gActedPage+ [wd_Acted_TaskList];
    RefreshTaskList(gSearchWhere_Local2);
  end
end;

procedure TFormDRSRoundSearch.RefreshDRSList(aWhere: string);
var
  lSqlstr: string;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select a.*,decode(b.drsid,null,''��'',''��'') as IS33,'+
              ' decode(c.drsid,null,''��'',''��'') as IS32'+
              ' from drs_info_view a'+
              ' left join (select b.drsid,b.comid from drs_autotest_cmd b group by b.drsid,b.comid) b on a.drsid=b.drsid and b.comid=33'+
              ' left join (select c.drsid,c.comid from drs_autotest_cmd c group by c.drsid,c.comid) c on a.drsid=c.drsid and c.comid=32'+
//              ' where 1=1'+aWhere;
              ' where a.drsstatus<>1'+aWhere;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGridDBTVDRSList.ApplyBestFit();
end;

procedure TFormDRSRoundSearch.RefreshTaskList(aWhere: string);
var
  lSqlstr: string;
begin
  DataSource2.DataSet:= nil;
  with ClientDataSet2 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select b.id,b.drsid,a.drsno,a.r_deviceid,a.drsname,'+
              ' a.drstypename,a.drsmanuname,'+
              ' a.drsadress,b.comid,e.comname,b.createtime,'+
              ' to_char(b.begintime,''HH24:MI'') begintime,to_char(b.endtime,''HH24:MI'') endtime,b.cyccounts,'+
              ' b.time_interval,b.curr_cyccount,b.succ_cyccount,decode(b.ifpause,1,''��ͣ'',''ִ����'') as ifpause'+
              ' from drs_autotest_cmd b'+
              ' left join drs_info_view a on b.drsid=a.drsid'+
              ' left join drs_command_define e on b.comid=e.comid'+
              ' where 1=1'+aWhere;
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
  end;
  DataSource2.DataSet:= ClientDataSet2;
  self.cxGridTaskListDBTableView1.ApplyBestFit();
end;

procedure TFormDRSRoundSearch.Timer1Timer(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  I: Integer;
  lRecordIndex: integer;
  lIfpause_Index: integer;
  lIfpauser: string;
  lGet1, lGet2: boolean;
begin
  Timer1.Enabled:= false;
  lActiveView:= cxGridTaskListDBTableView1;
  try
    lIfpause_Index:=lActiveView.GetColumnByFieldName('IFPAUSE').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�IFPAUSE��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if lActiveView.DataController.GetSelectedCount=0 then exit;
  lGet1:= false; lGet2:= false;
  for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
  begin
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
    lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    lIfpauser:= lActiveView.DataController.GetValue(lRecordIndex,lIfpause_Index);
    if lIfpauser='��ͣ' then
    begin
      lGet1:= true;
    end;
    if lIfpauser='ִ����' then
    begin
      lGet2:= true;
    end;
  end;
  if lGet1 then
    self.Button4.Enabled:= true
  else
    self.Button4.Enabled:= false;

  if lGet2 then
    self.Button3.Enabled:= true
  else
    self.Button3.Enabled:= false;
end;

end.
