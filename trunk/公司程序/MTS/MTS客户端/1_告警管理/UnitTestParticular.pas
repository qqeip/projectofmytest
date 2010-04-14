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
//  UD_STATUS_MONITOR = 1;  //状态监控
  UD_CDMA_TEST = 2;       //CDMA测试
  UD_WLAN_TEST = 3;       //WLAN测试
  UD_MTS_TEST = 4;        //MTS测试
  UD_CALL_TEST = 5;       //呼叫测试命令
  UD_MOS_TEST = 6;        //MOS值测试命令
  UD_VOICE_TEST = 7;      //语音单通测试命令
  UD_CALLED_TEST = 8;     //被叫时延测试命令
  UD_CCH_CQ_TEST = 9;     //场强检测通知
  UD_WLANSPEED_TEST = 10; //WLAN速率测试命令
  UD_WLANLOSEPAG_TEST = 11;//WLAN时延丢包误码测试命令
  UD_WLAN_CQ_TEST = 12;   //WLAN场强检测通知
  UD_WLAN_OUT_TEST = 13;  //WLAN掉线通知
  UD_MTUSELF_TEST = 14;   //MTS设备自身检测通知
  UD_MTUSTATUS_TEST = 15; //MTU状态查询命令
  UD_MTUPPP_TEST = 16;    //PPP拨号测试命令
  UD_CDMA_REPORT = 17;    //CDMA信息检测通知
  UD_SWITCH_REPORT = 18;  //切换相关参数检测通知
  UD_FINGER_REPORT =19;   //Finger信息检测通知
  UD_ACTIVE_REPORT =20;   //激活集信息检测通知
  UD_SECOND_REPORT =21;   //候选集信息检测通知
  UD_NEIGHBOR_REPORT = 22;//邻区信息检测通知
  UD_CALL_CENTER =23;     //平台呼叫
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
    FStatFlag: boolean; //true 为时间范围统计 false 为N次值统计
    FMtuid: integer;
    FCxGridHelper : TCxGridSet;
    procedure SetMtuid(const Value: integer);
    function ExistTable(atablename:string):Boolean;
    procedure DrawTree(aNode: TTreeNode; aTopid: integer);
    procedure GetCount;
    procedure SaveCount;
  public
    //显示MTU设备信息 和 测试状态
    procedure ShowMTUDetails(aMtuid: integer);
    //画标题
    procedure DrawTitle(aTestType: integer);
    //根据测试命令显示最近测试结果
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
    Application.MessageBox('"开始时间"不能大于"截止时间"，请重输！','提示',MB_OK);
    Exit;
  end;
  if (DateTimePickerEndDate.Date-DateTimePickerStartDate.Date)>10 then
  begin
    Application.MessageBox('"开始时间"与"截止时间"的间隔不能超过10天，请重输！','提示',MB_OK);
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
  if not FStatFlag then  //次数统计，针对树节点ONCHANGE事件
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
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'mtutypename','网络制式');
         AddViewField(cxGridResultDBTableView1,'collecttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'testvalue','检测结果');
       end;
    5: begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'call','主叫号码');
         AddViewField(cxGridResultDBTableView1,'called','被叫号码');
         AddViewField(cxGridResultDBTableView1,'starttime','测试开始时间');
         AddViewField(cxGridResultDBTableView1,'endtime','测试结束时间');
         AddViewField(cxGridResultDBTableView1,'inDelaytime','接入时延');
         AddViewField(cxGridResultDBTableView1,'calldelaytime','通话时延');
         AddViewField(cxGridResultDBTableView1,'calllong','通话时长');
         AddViewField(cxGridResultDBTableView1,'CSID','所在基站编号');
         AddViewField(cxGridResultDBTableView1,'calltry','呼叫尝试');
         AddViewField(cxGridResultDBTableView1,'callresult','呼叫结果');
         AddViewField(cxGridResultDBTableView1,'Pointchangecounts','站间切换次数');
         AddViewField(cxGridResultDBTableView1,'TCHchangecounts','TCH切换次数');
         AddViewField(cxGridResultDBTableView1,'WML','场强和误码率');
       end;
    6: begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'call','主叫号码');
         AddViewField(cxGridResultDBTableView1,'called','被叫号码');
         AddViewField(cxGridResultDBTableView1,'starttime','测试开始时间');
         AddViewField(cxGridResultDBTableView1,'endtime','测试结束时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'calllong','通话时长');
         AddViewField(cxGridResultDBTableView1,'playvoice','播放的语音文件');
         AddViewField(cxGridResultDBTableView1,'recordvoice','录音产生的语音文件名');
         AddViewField(cxGridResultDBTableView1,'testvalue','测试结果');
       end;
    7: begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'call','主叫号码');
         AddViewField(cxGridResultDBTableView1,'called','被叫号码');
         AddViewField(cxGridResultDBTableView1,'starttime','测试开始时间');
         AddViewField(cxGridResultDBTableView1,'endtime','测试结束时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'inDelaytime','接入时延');
         AddViewField(cxGridResultDBTableView1,'calldelaytime','通话时延');
         AddViewField(cxGridResultDBTableView1,'calllong','通话时长');
         AddViewField(cxGridResultDBTableView1,'callresult','呼叫结果');
         AddViewField(cxGridResultDBTableView1,'voiceresult','语音结果');
       end;
    8: begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'call','主叫号码');
         AddViewField(cxGridResultDBTableView1,'called','被叫号码');
         AddViewField(cxGridResultDBTableView1,'starttime','测试开始时间');
         AddViewField(cxGridResultDBTableView1,'endtime','测试结束时间');
         AddViewField(cxGridResultDBTableView1,'inDelaytime','接入时延');
       end;
    9: begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'CCHVALUE','检测结果');
       end;
    10:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'starttime','测试开始时间');
         AddViewField(cxGridResultDBTableView1,'endtime','测试结束时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'durationtime','测试时长');
         AddViewField(cxGridResultDBTableView1,'uplink','上传速率');
         AddViewField(cxGridResultDBTableView1,'downlink','下载速率');
         AddViewField(cxGridResultDBTableView1,'testvalue','测试结果');
       end;
    11:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'pingaddr','Ping目标地址');
         AddViewField(cxGridResultDBTableView1,'starttime','测试开始时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'durationtime','测试时长');
         AddViewField(cxGridResultDBTableView1,'sendpacket','发送的数据包数');
         AddViewField(cxGridResultDBTableView1,'receviepacket','接收到的数据包数');
         AddViewField(cxGridResultDBTableView1,'maxdelay','最大时延');
         AddViewField(cxGridResultDBTableView1,'mindelay','最小时延');
         AddViewField(cxGridResultDBTableView1,'avgdelay','平均时延');
         AddViewField(cxGridResultDBTableView1,'errpercent','误码率');
       end;
    12:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','检测类型');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'WLANVALUE','检测结果');
       end;
    13:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'starttime','通知时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'errreason','通知内容');
       end;
    14:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'powerstatus','电源状态');
       end;
    15:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'mtustatus','MTU状态');
       end;
    16:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'testvalue','测试结果');
       end;
    17:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'teststatus','测试状态');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'bandclass','频段');
         AddViewField(cxGridResultDBTableView1,'chan','信道号');
         AddViewField(cxGridResultDBTableView1,'sid','系统标识');
         AddViewField(cxGridResultDBTableView1,'nid','网络标识');
         AddViewField(cxGridResultDBTableView1,'pn','导频偏置');
         AddViewField(cxGridResultDBTableView1,'sci','Slot cycle index');
         AddViewField(cxGridResultDBTableView1,'tx_adj','发送功率控制');
         AddViewField(cxGridResultDBTableView1,'fer','误码率');
       end;
    18:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'teststatus','测试状态');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'TX','TX');
         AddViewField(cxGridResultDBTableView1,'T_ADD','T_ADD');
         AddViewField(cxGridResultDBTableView1,'T_DROP','T_DROP');
         AddViewField(cxGridResultDBTableView1,'T_COMP','T_COMP');
         AddViewField(cxGridResultDBTableView1,'T_TDROP','T_TDROP');
       end;
    19:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'teststatus','测试状态');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'paramscount','个数');
         AddViewField(cxGridResultDBTableView1,'testvalue','检测结果');
       end;
    20:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'teststatus','测试状态');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'paramscount','个数');
         AddViewField(cxGridResultDBTableView1,'testvalue','检测结果');
       end;
    21:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'teststatus','测试状态');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'paramscount','个数');
         AddViewField(cxGridResultDBTableView1,'testvalue','检测结果');
       end;
    22:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'teststatus','测试状态');
         AddViewField(cxGridResultDBTableView1,'starttime','检测时间');
         AddViewField(cxGridResultDBTableView1,'collecttime','采集时间');
         AddViewField(cxGridResultDBTableView1,'paramscount','个数');
         AddViewField(cxGridResultDBTableView1,'testvalue','检测结果');
       end;
    23:begin
         AddViewField(cxGridResultDBTableView1,'taskid','任务编号');
         AddViewField(cxGridResultDBTableView1,'mtuno','MTU编号');
         AddViewField(cxGridResultDBTableView1,'comname','测试命令');
         AddViewField(cxGridResultDBTableView1,'starttime','测试开始时间');
         AddViewField(cxGridResultDBTableView1,'endtime','测试结束时间');
         AddViewField(cxGridResultDBTableView1,'calllong','通话时长');
         AddViewField(cxGridResultDBTableView1,'inDelaytime','接入时延');
         AddViewField(cxGridResultDBTableView1,'calldelaytime','通话时延');
         AddViewField(cxGridResultDBTableView1,'callresult','呼叫结果');
         AddViewField(cxGridResultDBTableView1,'voiceresult','语音结果');
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
      //注意要加下面代码否则外部DataSet会报错
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
  
  //获取最近次数
  GetCount;
  //画树
  with ClientDataSetDym do
  begin
    close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,41,0]),0);
  end;
  DrawTree(nil,0);
  //选第一个节点
  TreeView1.Selected:= TreeView1.Items[0];
  ClientDataSetDym.Close;
end;

procedure TFormTestParticular.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  //将最近次数保存
  SaveCount;
  FCxGridHelper.Free;
  //释放树
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
      //设备信息
      cxTextEditMTUNO.Text:= FieldByName('mtuno').AsString;
      cxTextEditMTUNAME.Text:= FieldByName('mtuname').AsString;
      cxTextEditMTUADDR.Text:= FieldByName('mtuaddr').AsString;
      cxTextEditBUILDING.Text:= FieldByName('buildingname').AsString;
      cxTextEditCALL.Text:= FieldByName('call').AsString;
      cxTextEditCALLED.Text:= FieldByName('called').AsString;
      cxTextEditOVER.Text:= FieldByName('overlay').AsString;
      //测试状态
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
