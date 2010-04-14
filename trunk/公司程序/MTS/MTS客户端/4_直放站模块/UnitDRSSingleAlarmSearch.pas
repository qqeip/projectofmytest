unit UnitDRSSingleAlarmSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, CxGridUnit, DBClient;

type
  TFormDRSSingleAlarmSearch = class(TForm)
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Button1: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Panel4: TPanel;
    SendD1: TDateTimePicker;
    SendT1: TDateTimePicker;
    SendD2: TDateTimePicker;
    SendT2: TDateTimePicker;
    cxGridAlarmOnlineDBTableView1: TcxGridDBTableView;
    cxGridAlarmOnlineLevel1: TcxGridLevel;
    cxGridAlarmOnline: TcxGrid;
    cxGridAlarmHisDBTableView1: TcxGridDBTableView;
    cxGridAlarmHisLevel1: TcxGridLevel;
    cxGridAlarmHis: TcxGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    DataSource2: TDataSource;
    ClientDataSet2: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FCxGridHelper: TCxGridSet;
    FDRSID: Integer;
    procedure AddAlarmOnlineField(aView: TcxGridDBTableView);
    procedure AddAlarmHisField(aView: TcxGridDBTableView);
    procedure SetDRSID(const Value: Integer);

    procedure ShowAlarmOnline(aDrsid: Integer);
    procedure ShowAlarmHis(aDrsid:Integer; aBeyondDays: integer);overload;
    procedure ShowAlarmHis(aDrsid: Integer; aBegin, aEnd: TDatetime);overload;
    function CheckDate: boolean;
  public
    { Public declarations }
    //打开该TAB页默认显示的是当前告警和最近3天的历史告警
    function SetDefaultShowAlarm: boolean;
    procedure DRSSelectChange;

  property DRSID: Integer read FDRSID write SetDRSID;
  end;

var
  FormDRSSingleAlarmSearch: TFormDRSSingleAlarmSearch;

implementation

uses Ut_Common, Ut_DataModule, UntCommandParam;

{$R *.dfm}

procedure TFormDRSSingleAlarmSearch.AddAlarmHisField(aView: TcxGridDBTableView);
begin
  AddViewField(aView,'DRSID','直放站内部编号');
  AddViewField(aView,'DRSNO','直放站编号');
  AddViewField(aView,'R_DEVICEID','关联设备编号');
  AddViewField(aView,'ALARMID','告警编号');
  AddViewField(aView,'ALARMCONTENTNAME','告警名称');
  AddViewField(aView,'ALARMLEVELNAME','告警等级');
  AddViewField(aView,'ALARMKINDNAME','告警类型');
  AddViewField(aView,'SENDTIME','告警产生时间');
  AddViewField(aView,'REMOVETIME','告警清除时间');
end;

procedure TFormDRSSingleAlarmSearch.AddAlarmOnlineField(
  aView: TcxGridDBTableView);
begin
  AddViewField(aView,'DRSID','直放站内部编号');
  AddViewField(aView,'DRSNO','直放站编号');
  AddViewField(aView,'R_DEVICEID','关联设备编号');
  AddViewField(aView,'ALARMID','告警编号');
  AddViewField(aView,'ALARMCONTENTNAME','告警名称');
  AddViewField(aView,'ALARMLEVELNAME','告警等级');
  AddViewField(aView,'ALARMKINDNAME','告警类型');
  AddViewField(aView,'SENDTIME','告警产生时间');
  AddViewField(aView,'UPDATETIME','最后更新时间');
end;

procedure TFormDRSSingleAlarmSearch.Button1Click(Sender: TObject);
var
  lDays: integer;
  lBegin, lEnd: TDatetime;
begin
  if self.RadioButton1.Checked then
  begin
    lDays:= 3;
    ShowAlarmHis(FDRSID,lDays);
  end
  else if self.RadioButton2.Checked then
  begin
    if not CheckDate then
    begin
      MessageBox(Handle, '起始时间不能大于截止时间!', '信息', MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    lBegin:= strtoDatetime(DateToStr(SendD1.Date)+' '+FormatDateTime('HH:mm',SendT1.Time));
    lEnd:= strtoDatetime(DateToStr(SendD2.Date)+' '+FormatDateTime('HH:mm',SendT2.Time));
    ShowAlarmHis(FDRSID,lBegin,lEnd);
  end;
end;

function TFormDRSSingleAlarmSearch.CheckDate: boolean;
begin
  Result := True;
  if SendD1.Date+SendT1.Date > SendD2.Date+SendT2.Date then
  begin
    Result := False;
    Exit;
  end;
end;

procedure TFormDRSSingleAlarmSearch.DRSSelectChange;
begin
  self.RadioButton1.Checked:= true;
  DRSID := UntCommandParam.current_DRSID;
  SetDefaultShowAlarm;
end;

procedure TFormDRSSingleAlarmSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FCxGridHelper.Free;
end;

procedure TFormDRSSingleAlarmSearch.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAlarmOnline,false,false,true);
  FCxGridHelper.SetGridStyle(cxGridAlarmHis,false,false,true);

  self.FDRSID:= -1;
end;

procedure TFormDRSSingleAlarmSearch.FormShow(Sender: TObject);
begin
  SendD1.Date  := date-1;
  SendT1.Time  := time;
  SendD2.Date  := date;
  SendT2.Time  := time;
  
  AddAlarmOnlineField(cxGridAlarmOnlineDBTableView1);
  AddAlarmHisField(cxGridAlarmHisDBTableView1);
end;

function TFormDRSSingleAlarmSearch.SetDefaultShowAlarm: boolean;
begin
  if FDRSID=-1 then
  begin
    if not ClientDataSet1.IsEmpty then
      ClientDataSet1.EmptyDataSet;
    if not ClientDataSet2.IsEmpty then
      ClientDataSet2.EmptyDataSet;
  end
  else
  begin
    self.ShowAlarmOnline(self.FDRSID);
    self.ShowAlarmHis(self.FDRSID,3);
  end;
end;

procedure TFormDRSSingleAlarmSearch.SetDRSID(const Value: Integer);
begin
  FDRSID := Value;
end;

procedure TFormDRSSingleAlarmSearch.ShowAlarmHis(aDrsid:Integer ; aBeyondDays: integer);
var
  lSqlstr: string;
begin
  DataSource2.DataSet:= nil;
  with ClientDataSet2 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select * from alarm_drs_master_history_view a'+
              ' where a.removetime between trunc(sysdate)-'+inttostr(aBeyondDays)+' and sysdate'+
              ' and a.drsid= '+inttostr(aDrsid) ;
    lSqlstr:=lSqlstr+' order by alarmid desc';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
  end;
  DataSource2.DataSet:= ClientDataSet2;
  cxGridAlarmHisDBTableView1.ApplyBestFit();
end;

procedure TFormDRSSingleAlarmSearch.ShowAlarmHis(aDrsid: Integer; aBegin,
  aEnd: TDatetime);
var
  lSqlstr: string;
begin
  DataSource2.DataSet:= nil;
  with ClientDataSet2 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select * from alarm_drs_master_history_view a'+
              ' where a.removetime between to_date('''+FormatDateTime('YYYY-MM-DD HH:MM',aBegin)+''',''YYYY-MM-DD HH24:MI'')'+
              ' and to_date('''+FormatDateTime('YYYY-MM-DD HH:MM',aEnd)+''',''YYYY-MM-DD HH24:MI'')'+
              ' and a.drsid='+inttostr(aDrsid);
    lSqlstr:=lSqlstr+' order by alarmid desc';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
  end;
  DataSource2.DataSet:= ClientDataSet2;
  cxGridAlarmHisDBTableView1.ApplyBestFit();
end;

procedure TFormDRSSingleAlarmSearch.ShowAlarmOnline(aDrsid: Integer);
var
  lSqlstr: string;
begin
  /////如果未派障的告警，如何算历史
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select * from alarm_drs_master_online_view a'+
              ' where a.flowtache=2 and a.drsid='+inttostr(aDrsid);
    lSqlstr:=lSqlstr+' order by alarmid desc';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  self.cxGridAlarmOnlineDBTableView1.ApplyBestFit();
end;

end.
