{ ALARM_DATA_REP_COLLECT(重复告警表)
}

unit UnitRepeatAlarmMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ExtCtrls, StdCtrls, jpeg,
  cxLookAndFeelPainters, cxContainer, cxGroupBox, Menus, cxButtons,
  DBClient, CxGridUnit;
type
    TMasterAlarm = record
    Count: integer;    //存在在线告警的数量
    IsExsitAlarm: boolean; //是否存在在线告警
    AlarmCodeStr: string;  //告警编号字符串
  end;
type
  TFormRepeatAlarmMgr = class(TForm)
    PanelAlarmList: TPanel;
    Splitter1: TSplitter;
    PanelAlarmPreview: TPanel;
    cxGridRepeatAlarmPreview: TcxGrid;
    cxGridRepeatAlarmPreviewDBTableView1: TcxGridDBTableView;
    cxGridRepeatAlarmPreviewLevel1: TcxGridLevel;
    cxGridRepeatAlarmListDBTableView1: TcxGridDBTableView;
    cxGridRepeatAlarmListLevel1: TcxGridLevel;
    cxGridRepeatAlarmList: TcxGrid;
    Panel3: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    cxGroupBox1: TcxGroupBox;
    BtnGotoAlarmManualMgr: TcxButton;
    BtnClose: TcxButton;
    CDSAlarmPreview: TClientDataSet;
    CDSAlarmList: TClientDataSet;
    DSAlarmPreview: TDataSource;
    DSAlarmList: TDataSource;
    BtnRefresh: TcxButton;
    BtnDel: TcxButton;
    procedure BtnGotoAlarmManualMgrClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    gClientDataSet: TClientDataSet;
    procedure GetDeviceInfo;
//    function IsExsitMasterAlarm(aCityid: Integer): TMasterAlarm;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRepeatAlarmMgr: TFormRepeatAlarmMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormRepeatAlarmMgr.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.NewSetGridStyle(cxGridRepeatAlarmPreview,true,false,true);
  FCxGridHelper.NewSetGridStyle(cxGridRepeatAlarmList,true,false,true);
  AddCategory(cxGridRepeatAlarmPreviewDBTableView1,gPublicParam.cityid,gPublicParam.userid,26);
  GetDeviceInfo;
  gClientDataSet:= TClientDataSet.Create(nil);
end;

procedure TFormRepeatAlarmMgr.FormShow(Sender: TObject);
begin
//
end;

procedure TFormRepeatAlarmMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  gDllMsgCall(FormRepeatAlarmMgr,1,'','');
end;

procedure TFormRepeatAlarmMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
  gClientDataSet.Free;
end;

procedure TFormRepeatAlarmMgr.BtnGotoAlarmManualMgrClick(Sender: TObject);
var
  lDeviceID, lCoDeviceID, lContentCode: Integer;
  lDevCaption, lSqlStr, lAlarmCaption: string;
begin
  if cxGridRepeatAlarmPreviewDBTableView1.DataController.GetSelectedCount>1 then
  begin
    Application.MessageBox('每次只能一条转人工！','提示',MB_OK+64);
    Exit;
  end;
  lDeviceID:= CDSAlarmPreview.FieldByName('DEVICEID').AsInteger;
  lCoDeviceID:= CDSAlarmPreview.FieldByName('CODEVICEID').AsInteger;
  lContentCode:= CDSAlarmPreview.FieldByName('CONTENTCODE').AsInteger;
  lAlarmCaption:= CDSAlarmPreview.FieldByName('alarmcontentname').AsString;

  lDevCaption:= IntToStr(lDeviceID)+','+IntToStr(lCoDeviceID)+','+IntToStr(lContentCode)+','+lAlarmCaption;

  gDllMsgCall(nil,6,'FormAlarmManual',lDevCaption);
  exit;
end;

procedure TFormRepeatAlarmMgr.BtnCloseClick(Sender: TObject);
begin
  inherited;
  gDllMsgCall(FormRepeatAlarmMgr,1,'','');
end;

procedure TFormRepeatAlarmMgr.GetDeviceInfo;
var
  lSqlStr: string;
begin
  DSAlarmPreview.DataSet:=nil;
  with CDSAlarmPreview do
  begin
    Close;
    lSqlStr:= 'select a.deviceid,' +
                    ' c.contentcode,' +
                    ' c.codeviceid,' +
                    ' c.ALARMID,' +
                    ' a.bts_name,' +
                    ' a.branch,' +
                    ' a.branchname,' +
                    ' a.csid,' +
                    ' a.bts_label as BTSID,' +
                    ' a.bts_level,' +
                    ' e.name as btslevelname,' +
                    ' a.bts_state,' +
                    ' f.CS_STATUS as btsstatename,' +
                    ' a.bts_type,' +
                    ' j.name as btstypename,' +
                    ' a.bts_kind,' +
                    ' a.msc,' +
                    ' a.bsc,' +
                    ' a.lac,' +
                    ' a.station_addr,' +
                    ' a.commonality_type,' +
                    ' a.agent_manu,' +
                    ' a.source_mode,' +
                    ' a.iron_tower_kind,' +
                    ' a.fan_id,' +
                    ' a.cell_no,' +
                    ' a.cid_num_sixteen,' +
                    ' a.pn_code,' +
                    ' a.antenna_kind,' +
                    ' a.azimuth,' +
                    ' m.alarmtype,' +
                    ' n.dicname as alarmtypename,' +
                    ' m.alarmcontentcode,' +
                    ' m.alarmcontentname as alarmcontentname,' +
                    ' c.Alarmlocation,' +
                    ' decode(c.issend,0,''未派单'',1,''已派单'') as issend,' +
                    ' c.alarmcount,' +
                    ' c.COLLECTTIME,' +
                    ' c.createtime,' +
                    ' c.cleartime' +
              '  from (select t1.*,t2.fan_id,t2.cell_no,t2.cid_num_sixteen,t2.pn_code,t2.antenna_kind,t2.azimuth,t2.cell_state' +
              '          from fms_device_info t1' +
              '         inner join fms_cell_device_info t2 on t1.cityid=t2.cityid and t1.deviceid=t2.bts_label' +
              '         union all' +
              '        select t3.*,t4.fan_id,t4.cell_no,t4.cid_num_sixteen,t4.pn_code,t4.antenna_kind,t4.azimuth,t4.cell_state' +
              '          from fms_device_info t3' +
              '          left join fms_cell_device_info t4 on 1=2' +
              ') a' +
              ' inner join ALARM_DATA_REP_COLLECT c on a.cityid=c.cityid and a.deviceid=c.deviceid and nvl(a.fan_id,0)=c.codeviceid' +
              '  left join pop_cslevel e on a.cityid=e.cityid and a.bts_level=e.id' +
              '  left join pop_status f on a.cityid=f.cityid and a.bts_state=f.id ' +
              '  left join pop_cstype j on a.cityid=j.cityid and a.bts_type=j.id' +
              '  left join alarm_content_info m on a.cityid=m.cityid and c.contentcode=m.alarmcontentcode' +
              '  left join alarm_dic_code_info n on m.cityid=n.cityid and m.alarmtype=n.diccode and n.dictype=2' +
              ' where a.cityid=' + IntToStr(gPublicParam.cityid);
    ProviderName:= 'dsp_General_data';
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
  end;
  DSAlarmPreview.DataSet:= CDSAlarmPreview;
  cxGridRepeatAlarmPreviewDBTableView1.ApplyBestFit();
end;

procedure TFormRepeatAlarmMgr.BtnRefreshClick(Sender: TObject);
begin
  GetDeviceInfo;
end;

procedure TFormRepeatAlarmMgr.BtnDelClick(Sender: TObject);
var
  lSqlstr, lAlarmStr, lAlarmID, lMessageInfo: string;
  lDev_Index, lCoDev_Index, lContentCode_Index, lIsSend_Index, lAlarmID_Index,
  lDevID, lCoDevID, lContentCode, i, lRecordIndex, lIsSend, iError: Integer;
  lVariant: Variant;
  lsuccess: Boolean;
begin
  try
    lDev_Index:=cxGridRepeatAlarmPreviewDBTableView1.GetColumnByFieldName('DEVICEID').Index;
    lCoDev_Index:= cxGridRepeatAlarmPreviewDBTableView1.GetColumnByFieldName('CODEVICEID').Index;
    lContentCode_Index:= cxGridRepeatAlarmPreviewDBTableView1.GetColumnByFieldName('CONTENTCODE').Index;
    lIsSend_Index:= cxGridRepeatAlarmPreviewDBTableView1.GetColumnByFieldName('ISSEND').Index;
    lAlarmID_Index:= cxGridRepeatAlarmPreviewDBTableView1.GetColumnByFieldName('ALARMID').Index;
  except
    Application.MessageBox('未获得关键字段DEVICEID,CODEVICEID,CONTENTCODE,ISSEND,ALARMID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;

  if cxGridRepeatAlarmPreviewDBTableView1.DataController.GetSelectedCount<1 then
  begin
    Application.MessageBox('请先选择要删除的记录！','提示',MB_OK+64);
    Exit;
  end;

  try
    Screen.Cursor := crHourGlass;
    lVariant:= VarArrayCreate([0,cxGridRepeatAlarmPreviewDBTableView1.DataController.GetSelectedCount-1],varVariant);

    for i:=0 to cxGridRepeatAlarmPreviewDBTableView1.DataController.GetSelectedCount-1 do
    begin
      lRecordIndex := cxGridRepeatAlarmPreviewDBTableView1.Controller.SelectedRows[I].RecordIndex;
      lDevID := cxGridRepeatAlarmPreviewDBTableView1.DataController.GetValue(lRecordIndex,lDev_Index);
      lCoDevID:= cxGridRepeatAlarmPreviewDBTableView1.DataController.GetValue(lRecordIndex,lCoDev_Index);
      lContentCode:= cxGridRepeatAlarmPreviewDBTableView1.DataController.GetValue(lRecordIndex,lContentCode_Index);
      if cxGridRepeatAlarmPreviewDBTableView1.DataController.GetValue(lRecordIndex,lIsSend_Index)='未派单' then
        lIsSend:= 0
      else
        lIsSend:= 1;
      if cxGridRepeatAlarmPreviewDBTableView1.DataController.GetValue(lRecordIndex,lAlarmID_Index)=null then
        lAlarmID:= ''
      else
        lAlarmID:= cxGridRepeatAlarmPreviewDBTableView1.DataController.GetValue(lRecordIndex,lAlarmID_Index);
      lSqlstr:= 'delete from alarm_data_rep_collect' + 
                ' where cityid =' + IntToStr(gPublicParam.cityid) +
                '   and deviceid =' + IntToStr(lDevID) +
                '   and codeviceid =' + IntToStr(lCoDevID) +
                '   and contentcode =' + IntToStr(lContentCode);
      lVariant[i]:= VarArrayOf([lSqlstr]);
      if lIsSend=1 then
        lAlarmStr:= lAlarmID+',';
    end;

    lAlarmStr:= Copy(lAlarmStr,0,Length(lAlarmStr)-1);
    if lAlarmStr<>'' then
    begin
      iError:= gTempInterface.CompanyMgr(gPublicParam.cityid, -1, '', lAlarmStr, gPublicParam.userid,lVariant);
      case iError of
        0:
        begin
          cxGridRepeatAlarmPreviewDBTableView1.DataController.DeleteSelection;
          Application.MessageBox('删除成功','提示',MB_OK+64);
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
        Application.MessageBox('删除成功','提示',MB_OK+64);
        cxGridRepeatAlarmPreviewDBTableView1.DataController.DeleteSelection;
      end
      else
        Application.MessageBox('删除失败','提示',MB_OK+64);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;


end.
