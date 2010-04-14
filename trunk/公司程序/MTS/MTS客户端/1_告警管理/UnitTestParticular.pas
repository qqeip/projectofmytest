unit UnitTestParticular;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxLabel, cxControls, cxContainer, cxEdit,
  cxGroupBox, cxTextEdit, cxHeader, StdCtrls, ExtCtrls, Menus, cxButtons,
  ComCtrls, cxRadioGroup, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, CxGridUnit,
  DBClient, IniFiles, math;

const
//  UD_STATUS_MONITOR = 1;  //״̬���
  UD_CDMA_TEST = 2;       //CDMA����
  UD_WLAN_TEST = 3;       //WLAN����
  UD_MTS_TEST = 4;        //MTS����
  UD_CALL_TEST = 5;       //���в�������
  UD_MOS_TEST = 6;        //MOSֵ��������
  UD_VOICE_TEST = 7;      //������ͨ��������
  UD_CALLED_TEST = 8;     //����ʱ�Ӳ�������
  UD_CCH_CQ_TEST = 9;     //��ǿ���֪ͨ
  UD_WLANSPEED_TEST = 10; //WLAN���ʲ�������
  UD_WLANLOSEPAG_TEST = 11;//WLANʱ�Ӷ��������������
  UD_WLAN_CQ_TEST = 12;   //WLAN��ǿ���֪ͨ
  UD_WLAN_OUT_TEST = 13;  //WLAN����֪ͨ
  UD_MTUSELF_TEST = 14;   //MTS�豸������֪ͨ
  UD_MTUSTATUS_TEST = 15; //MTU״̬��ѯ����
  UD_MTUPPP_TEST = 16;    //PPP���Ų�������
  UD_CDMA_REPORT = 17;    //CDMA��Ϣ���֪ͨ
  UD_SWITCH_REPORT = 18;  //�л���ز������֪ͨ
  UD_FINGER_REPORT =19;   //Finger��Ϣ���֪ͨ
  UD_ACTIVE_REPORT =20;   //�����Ϣ���֪ͨ
  UD_SECOND_REPORT =21;   //��ѡ����Ϣ���֪ͨ
  UD_NEIGHBOR_REPORT = 22;//������Ϣ���֪ͨ
  UD_CALL_CENTER =23;     //ƽ̨����
type
  TNodeData = class
    id: integer;
    DisplayName: string;
    ExtendValue: string;
    Layer: integer;
    NodeType: integer;
  end;
  TFormTestParticular = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxTextEditMTUNO: TcxTextEdit;
    cxTextEditMTUNAME: TcxTextEdit;
    cxTextEditMTUADDR: TcxTextEdit;
    cxTextEditBUILDING: TcxTextEdit;
    cxTextEditCALL: TcxTextEdit;
    cxTextEditCALLED: TcxTextEdit;
    cxTextEditOVER: TcxTextEdit;
    cxTextEditALARMS: TcxTextEdit;
    cxHeader1: TcxHeader;
    cxGroupBoxStat: TcxGroupBox;
    cxGroupBox4: TcxGroupBox;
    cxGroupBoxDetail: TcxGroupBox;
    cxGroupBoxByDate: TcxGroupBox;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    DateTimePickerStartTime: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    DateTimePickerStartDate: TDateTimePicker;
    DateTimePickerEndDate: TDateTimePicker;
    cxButtonStat: TcxButton;
    cxButtonClose: TcxButton;
    cxGroupBoxByCounts: TcxGroupBox;
    cxLabel13: TcxLabel;
    cxTextEditStatCounts: TcxTextEdit;
    cxRadioGroupSearchType: TcxRadioGroup;
    TreeView1: TTreeView;
    ClientDataSetDym: TClientDataSet;
    DataSourceResult: TDataSource;
    ClientDataSetResult: TClientDataSet;
    cxGridResult: TcxGrid;
    cxGridResultDBTableView1: TcxGridDBTableView;
    cxGridResultLevel1: TcxGridLevel;
    procedure cxButtonCloseClick(Sender: TObject);
    procedure cxRadioGroupSearchTypeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure cxButtonStatClick(Sender: TObject);
  private
    { Private declarations }
    FStatFlag: boolean; //true Ϊʱ�䷶Χͳ�� false ΪN��ֵͳ��
    FMtuid: integer;
    FCxGridHelper : TCxGridSet;
    procedure SetMtuid(const Value: integer);
    function ExistTable(atablename:string):Boolean;
    procedure DrawTree(aNode: TTreeNode; aTopid: integer);
    procedure GetCount;
    procedure SaveCount;
  public
    //��ʾMTU�豸��Ϣ �� ����״̬
    procedure ShowMTUDetails(aMtuid: integer);
    //������
    procedure DrawTitle(aTestType: integer);
    //���ݲ���������ʾ������Խ��
    procedure DrawGridRecentResult(aMtuid, aRecents, aTestType: integer);
  published
    property Mtuid: integer read FMtuid write SetMtuid;
  end;

var
  FormTestParticular: TFormTestParticular;

implementation

uses Ut_DataModule, Ut_Common;

{$R *.dfm}

procedure TFormTestParticular.cxButtonCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFormTestParticular.cxButtonStatClick(Sender: TObject);
begin
  if DateTimePickerStartDate.Date+DateTimePickerStartTime.Time>DateTimePickerEndDate.Date+DateTimePickerEndTime.Time then
  begin
    Application.MessageBox('"��ʼʱ��"���ܴ���"��ֹʱ��"�������䣡','��ʾ',MB_OK);
    Exit;
  end;
  if (DateTimePickerEndDate.Date-DateTimePickerStartDate.Date)>10 then
  begin
    Application.MessageBox('"��ʼʱ��"��"��ֹʱ��"�ļ�����ܳ���10�죬�����䣡','��ʾ',MB_OK);
    Exit;
  end;

  if cxRadioGroupSearchType.ItemIndex=1 then
    FStatFlag:= true;
  TreeView1Change(self,TreeView1.Selected);
  FStatFlag:= false;
end;

procedure TFormTestParticular.cxRadioGroupSearchTypeClick(Sender: TObject);
begin
  if cxRadioGroupSearchType.ItemIndex=0 then
  begin
    cxGroupBoxByCounts.Visible:= true;
    cxGroupBoxByDate.Visible:= false;
  end else
  if  cxRadioGroupSearchType.ItemIndex=1  then
  begin
    cxGroupBoxByDate.Visible:= true;
    cxGroupBoxByCounts.Visible:= false;
  end;
end;

procedure TFormTestParticular.DrawGridRecentResult(aMtuid, aRecents,
  aTestType: integer);
var
  ltablename: string;
  lSearchStr_Counts: string;
  lSearchStr_Time: string;
  lDate1,lDate2, lCurrDate: TDateTime;
begin
  if not FStatFlag then  //����ͳ�ƣ�������ڵ�ONCHANGE�¼�
  begin
    ltablename:= 'select * from mtu_testresult_online union all select * from mtu_testresult_history';
    if ExistTable('mtu_testresult_'+formatdatetime('yyyymmdd',date-1)) then
      ltablename:= ltablename+' union all select * from mtu_testresult_'+formatdatetime('yyyymmdd',date-1);
    if ExistTable('mtu_testresult_'+formatdatetime('yyyymmdd',date-2)) then
      ltablename:= ltablename+' union all select * from mtu_testresult_'+formatdatetime('yyyymmdd',date-2);


    lSearchStr_Counts:= 'where rowindex<='+inttostr(aRecents);
  end else
  begin
    lDate1:= floor(DateTimePickerStartDate.Date)+(DateTimePickerStartTime.Time-floor(DateTimePickerStartTime.Time));
    lDate2:= floor(DateTimePickerEndDate.Date)+(DateTimePickerEndTime.Time-floor(DateTimePickerStartTime.Time));
    ltablename:= 'select * from mtu_testresult_online union all select * from mtu_testresult_history';
    lCurrDate:= lDate1;
    while lCurrDate<=lDate2 do
    begin
      if ExistTable('mtu_testresult_'+formatdatetime('yyyymmdd',lCurrDate)) then
        ltablename:= ltablename+' union all select * from mtu_testresult_'+formatdatetime('yyyymmdd',lCurrDate);
      lCurrDate:=lCurrDate+1;
    end;
    lSearchStr_Time:= ' and to_date(to_char(a.collecttime,''yyyy-mm-dd hh24:mi:ss''),''yyyy-mm-dd hh24:mi:ss'')'+
                        ' between to_date('''+Datetimetostr(lDate1)+''',''yyyy-mm-dd hh24:mi:ss'')'+
                        ' and to_date('''+Datetimetostr(lDate2)+''',''yyyy-mm-dd hh24:mi:ss'')';
  end;

  DataSourceResult.DataSet:= nil;
  with ClientDataSetResult do
  begin
    Close;
    ProviderName:='dsp_General_data';
    case aTestType of
//      1: begin
//           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,45,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
//         end;
      5: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,44,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      6: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,45,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      7: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,46,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      8: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,47,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      9: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,48,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      10: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,49,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      11: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,50,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      12: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,51,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      13: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,52,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      14: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,53,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      15: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,54,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      16: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,55,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      17: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,56,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      18: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,57,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      19: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,58,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      20: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,59,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      21: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,60,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      22: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,61,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
      23: begin
           Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,62,ltablename,aMtuid,lSearchStr_Counts,lSearchStr_Time]),0);
         end;
    end;
  end;
  DataSourceResult.DataSet:= ClientDataSetResult;
  cxGridResultDBTableView1.ApplyBestFit();
end;

procedure TFormTestParticular.DrawTitle(aTestType: integer);
begin
  cxGridResultDBTableView1.ClearItems;
  case aTestType of
    1: begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'mtutypename','������ʽ');
         AddViewField(cxGridResultDBTableView1,'collecttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'testvalue','�����');
       end;
    5: begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'call','���к���');
         AddViewField(cxGridResultDBTableView1,'called','���к���');
         AddViewField(cxGridResultDBTableView1,'starttime','���Կ�ʼʱ��');
         AddViewField(cxGridResultDBTableView1,'endtime','���Խ���ʱ��');
         AddViewField(cxGridResultDBTableView1,'inDelaytime','����ʱ��');
         AddViewField(cxGridResultDBTableView1,'calldelaytime','ͨ��ʱ��');
         AddViewField(cxGridResultDBTableView1,'calllong','ͨ��ʱ��');
         AddViewField(cxGridResultDBTableView1,'CSID','���ڻ�վ���');
         AddViewField(cxGridResultDBTableView1,'calltry','���г���');
         AddViewField(cxGridResultDBTableView1,'callresult','���н��');
         AddViewField(cxGridResultDBTableView1,'Pointchangecounts','վ���л�����');
         AddViewField(cxGridResultDBTableView1,'TCHchangecounts','TCH�л�����');
         AddViewField(cxGridResultDBTableView1,'WML','��ǿ��������');
       end;
    6: begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'call','���к���');
         AddViewField(cxGridResultDBTableView1,'called','���к���');
         AddViewField(cxGridResultDBTableView1,'starttime','���Կ�ʼʱ��');
         AddViewField(cxGridResultDBTableView1,'endtime','���Խ���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'calllong','ͨ��ʱ��');
         AddViewField(cxGridResultDBTableView1,'playvoice','���ŵ������ļ�');
         AddViewField(cxGridResultDBTableView1,'recordvoice','¼�������������ļ���');
         AddViewField(cxGridResultDBTableView1,'testvalue','���Խ��');
       end;
    7: begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'call','���к���');
         AddViewField(cxGridResultDBTableView1,'called','���к���');
         AddViewField(cxGridResultDBTableView1,'starttime','���Կ�ʼʱ��');
         AddViewField(cxGridResultDBTableView1,'endtime','���Խ���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'inDelaytime','����ʱ��');
         AddViewField(cxGridResultDBTableView1,'calldelaytime','ͨ��ʱ��');
         AddViewField(cxGridResultDBTableView1,'calllong','ͨ��ʱ��');
         AddViewField(cxGridResultDBTableView1,'callresult','���н��');
         AddViewField(cxGridResultDBTableView1,'voiceresult','�������');
       end;
    8: begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'call','���к���');
         AddViewField(cxGridResultDBTableView1,'called','���к���');
         AddViewField(cxGridResultDBTableView1,'starttime','���Կ�ʼʱ��');
         AddViewField(cxGridResultDBTableView1,'endtime','���Խ���ʱ��');
         AddViewField(cxGridResultDBTableView1,'inDelaytime','����ʱ��');
       end;
    9: begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'CCHVALUE','�����');
       end;
    10:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'starttime','���Կ�ʼʱ��');
         AddViewField(cxGridResultDBTableView1,'endtime','���Խ���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'durationtime','����ʱ��');
         AddViewField(cxGridResultDBTableView1,'uplink','�ϴ�����');
         AddViewField(cxGridResultDBTableView1,'downlink','��������');
         AddViewField(cxGridResultDBTableView1,'testvalue','���Խ��');
       end;
    11:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'pingaddr','PingĿ���ַ');
         AddViewField(cxGridResultDBTableView1,'starttime','���Կ�ʼʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'durationtime','����ʱ��');
         AddViewField(cxGridResultDBTableView1,'sendpacket','���͵����ݰ���');
         AddViewField(cxGridResultDBTableView1,'receviepacket','���յ������ݰ���');
         AddViewField(cxGridResultDBTableView1,'maxdelay','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'mindelay','��Сʱ��');
         AddViewField(cxGridResultDBTableView1,'avgdelay','ƽ��ʱ��');
         AddViewField(cxGridResultDBTableView1,'errpercent','������');
       end;
    12:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','�������');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'WLANVALUE','�����');
       end;
    13:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'starttime','֪ͨʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'errreason','֪ͨ����');
       end;
    14:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'powerstatus','��Դ״̬');
       end;
    15:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'mtustatus','MTU״̬');
       end;
    16:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'testvalue','���Խ��');
       end;
    17:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'teststatus','����״̬');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'bandclass','Ƶ��');
         AddViewField(cxGridResultDBTableView1,'chan','�ŵ���');
         AddViewField(cxGridResultDBTableView1,'sid','ϵͳ��ʶ');
         AddViewField(cxGridResultDBTableView1,'nid','�����ʶ');
         AddViewField(cxGridResultDBTableView1,'pn','��Ƶƫ��');
         AddViewField(cxGridResultDBTableView1,'sci','Slot cycle index');
         AddViewField(cxGridResultDBTableView1,'tx_adj','���͹��ʿ���');
         AddViewField(cxGridResultDBTableView1,'fer','������');
       end;
    18:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'teststatus','����״̬');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'TX','TX');
         AddViewField(cxGridResultDBTableView1,'T_ADD','T_ADD');
         AddViewField(cxGridResultDBTableView1,'T_DROP','T_DROP');
         AddViewField(cxGridResultDBTableView1,'T_COMP','T_COMP');
         AddViewField(cxGridResultDBTableView1,'T_TDROP','T_TDROP');
       end;
    19:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'teststatus','����״̬');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'paramscount','����');
         AddViewField(cxGridResultDBTableView1,'testvalue','�����');
       end;
    20:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'teststatus','����״̬');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'paramscount','����');
         AddViewField(cxGridResultDBTableView1,'testvalue','�����');
       end;
    21:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'teststatus','����״̬');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'paramscount','����');
         AddViewField(cxGridResultDBTableView1,'testvalue','�����');
       end;
    22:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'teststatus','����״̬');
         AddViewField(cxGridResultDBTableView1,'starttime','���ʱ��');
         AddViewField(cxGridResultDBTableView1,'collecttime','�ɼ�ʱ��');
         AddViewField(cxGridResultDBTableView1,'paramscount','����');
         AddViewField(cxGridResultDBTableView1,'testvalue','�����');
       end;
    23:begin
         AddViewField(cxGridResultDBTableView1,'taskid','������');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU���');
         AddViewField(cxGridResultDBTableView1,'comname','��������');
         AddViewField(cxGridResultDBTableView1,'starttime','���Կ�ʼʱ��');
         AddViewField(cxGridResultDBTableView1,'endtime','���Խ���ʱ��');
         AddViewField(cxGridResultDBTableView1,'calllong','ͨ��ʱ��');
         AddViewField(cxGridResultDBTableView1,'inDelaytime','����ʱ��');
         AddViewField(cxGridResultDBTableView1,'calldelaytime','ͨ��ʱ��');
         AddViewField(cxGridResultDBTableView1,'callresult','���н��');
         AddViewField(cxGridResultDBTableView1,'voiceresult','�������');
       end;
  end;
end;

procedure TFormTestParticular.DrawTree(aNode: TTreeNode;
  aTopid: integer);
var
  pNode :TNodeData;
  lNode :TTreeNode;
  IdList :TStringList;
  i : integer;
begin
  if (not ClientDataSetDym.Active) or (ClientDataSetDym.RecordCount=0) then
    Exit;
  IdList :=TStringList.Create;
  try
    with ClientDataSetDym do
    begin
      Filter :='parentid = '+IntToStr(aTopid);
      Filtered := true;
      if recordcount > 0 then
      begin
        first;
        While Not Eof do
        begin
          pNode              := TNodeData.Create;
          pNode.ID           := FieldByName('diccode').AsInteger;
          pNode.DisplayName  := FieldByName('dicname').AsString;
          pNode.ExtendValue  := FieldByName('extendvalue').AsString;
          pNode.layer        := 0;
          pNode.NodeType     := FieldByName('diccode').AsInteger;

          IdList.AddObject(pNode.DisplayName,pNode);
          Next;
        end;
      end;
      //ע��Ҫ�������������ⲿDataSet�ᱨ��
      Filter :='';
      Filtered := false;
    end;
    for i := 0 to IdLIst.Count-1 do
    begin
      pNode := TNodeData(IdList.Objects[i]);
      lNode := TreeView1.Items.AddChildObject(aNode,pNode.DisplayName,pNode);
      lNode.ImageIndex :=pNode.layer+1;
      lNode.SelectedIndex := lNode.ImageIndex;
      DrawTree(lNode,pNode.ID);
    end;
  finally
    if IdList <> nil then IdList.Free;
  end;
  TreeView1.FullExpand;
  TreeView1.Perform(WM_VSCROLL,SB_TOP,0);
end;

function TFormTestParticular.ExistTable(atablename: string): Boolean;
begin
  Result := False;
  with ClientDataSetDym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,48,QuotedStr(uppercase(atablename))]),0);
    if Recordcount>0 then
       Result := True;
    Close;
  end;
end;

procedure TFormTestParticular.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //
end;

procedure TFormTestParticular.FormCreate(Sender: TObject);
begin
  ClientDataSetDym.RemoteServer:= Dm_MTS.SocketConnection1;
  DateTimePickerStartDate.Date:= now;
  DateTimePickerEndDate.Date:= now;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridResult,false,false,false);
  
  //��ȡ�������
  GetCount;
  //����
  with ClientDataSetDym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,41,0]),0);
  end;
  DrawTree(nil,0);
  //ѡ��һ���ڵ�
  TreeView1.Selected:= TreeView1.Items[0];
  ClientDataSetDym.Close;
end;

procedure TFormTestParticular.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  //�������������
  SaveCount;
  FCxGridHelper.Free;
  //�ͷ���
  for I := TreeView1.Items.Count - 1 downto 0 do
  begin
    dispose(TreeView1.Items[i].Data);
    TreeView1.Items[i].Delete;
  end;
end;

procedure TFormTestParticular.FormShow(Sender: TObject);
begin
  ShowMTUDetails(Mtuid);
end;

procedure TFormTestParticular.GetCount;
var
  linifile : Tinifile ;
  lFileName:string;
  lStringList:TStringList;
begin
  lFileName :=ExtractFileDir(application.ExeName)+'\'+ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');
  linifile := Tinifile.Create(lFileName);
  lStringList := TStringList.Create;

  linifile.ReadSectionValues('RecentCount',lStringList);
  if lStringList.Count<=0 then
  begin
     linifile.WriteString('RecentCount','TestCount','10');
     cxTextEditStatCounts.Text:= '10';
  end
  else
    cxTextEditStatCounts.Text := lStringList.Values['TestCount'];

  linifile.Free;
  lStringList.Free;
end;

procedure TFormTestParticular.SaveCount;
var
  linifile : Tinifile ;
  lFileName:string;
begin
  lFileName :=ExtractFileDir(application.ExeName)+'\'+ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');
  linifile := Tinifile.Create(lFileName);
  linifile.WriteString('RecentCount','TestCount',cxTextEditStatCounts.Text);
  linifile.Free;
end;

procedure TFormTestParticular.SetMtuid(const Value: integer);
begin
  FMtuid := Value;
end;

procedure TFormTestParticular.ShowMTUDetails(aMtuid: integer);
begin
  with ClientDataSetDym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,42,aMtuid]),0);
  end;
  if ClientDataSetDym.RecordCount>0 then
  begin
    with ClientDataSetDym do
    begin
      //�豸��Ϣ
      cxTextEditMTUNO.Text:= FieldByName('mtuno').AsString;
      cxTextEditMTUNAME.Text:= FieldByName('mtuname').AsString;
      cxTextEditMTUADDR.Text:= FieldByName('mtuaddr').AsString;
      cxTextEditBUILDING.Text:= FieldByName('buildingname').AsString;
      cxTextEditCALL.Text:= FieldByName('call').AsString;
      cxTextEditCALLED.Text:= FieldByName('called').AsString;
      cxTextEditOVER.Text:= FieldByName('overlay').AsString;
      //����״̬
      cxTextEditALARMS.Text:= FieldByName('alarmcount').AsString;
    end;
  end;
end;

procedure TFormTestParticular.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  lNode: TTreeNode;
begin
  lNode:= TreeView1.Selected;
  if (lNode=nil) or (lNode.Data=nil) then exit;

  DrawTitle(TNodeData(lNode.Data).NodeType);
  DrawGridRecentResult(FMtuid,strtoint(cxTextEditStatCounts.Text),TNodeData(lNode.Data).NodeType);
end;

end.
