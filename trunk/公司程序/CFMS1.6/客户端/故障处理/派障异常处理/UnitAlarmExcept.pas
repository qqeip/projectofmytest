unit UnitAlarmExcept;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CxGridUnit, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, StdCtrls, ExtCtrls, UDevExpressToChinese,
  DBClient, StringUtils, jpeg;

type
  TFormAlarmExcept = class(TForm)
    PanelLost: TPanel;
    ButtonResend: TButton;
    PanelUnplan: TPanel;
    ComboBoxGather: TComboBox;
    ButtonPlan: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    cxGridDeviceLostDBTableView1: TcxGridDBTableView;
    cxGridDeviceLostLevel1: TcxGridLevel;
    cxGridDeviceLost: TcxGrid;
    cxGridDeviceUnplanDBTableView1: TcxGridDBTableView;
    cxGridDeviceUnplanLevel1: TcxGridLevel;
    cxGridDeviceUnplan: TcxGrid;
    ClientDataSetLost: TClientDataSet;
    ClientDataSetUnplan: TClientDataSet;
    DataSourceLost: TDataSource;
    DataSourceUnplan: TDataSource;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Image4: TImage;
    cxGridDeviceUnplanLevel2: TcxGridLevel;
    cxGridDeviceUnplanDBTableView2: TcxGridDBTableView;
    DataSourceUnplan2: TDataSource;
    ClientDataSetUnplan2: TClientDataSet;
    Label1: TLabel;
    TabSheet3: TTabSheet;
    cxGridAlarmLost: TcxGrid;
    cxGridAlarmLostDBTableView: TcxGridDBTableView;
    cxGridAlarmLostDBTableView2: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxGridLevel2: TcxGridLevel;
    CDSAlarmLost: TClientDataSet;
    CDSAlarmLost2: TClientDataSet;
    DSAlarmLost: TDataSource;
    DSAlarmLost2: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonResendClick(Sender: TObject);
    procedure ButtonPlanClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxGridDeviceUnplanDBTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure cxGridAlarmLostDBTableViewDataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
  private
    FCxGridHelper : TCxGridSet;
  public
    procedure ShowAlarmDeviceLost(aCityid: integer);
    procedure ShowAlarmDeviceUnplan(aCityid: integer);
    procedure ShowAlarmDeviceUnplan2(aCityid, aDeviceid: integer);   
    procedure ShowAlarmUnplan(aCityid: integer);
    procedure ShowAlarmUnplan2(aCityid, aDeviceid: integer);
  end;

var
  FormAlarmExcept: TFormAlarmExcept;

implementation

uses UnitDllCommon, UnitVFMSGlobal;

{$R *.dfm}

procedure TFormAlarmExcept.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDeviceLost,false,true,true);
  FCxGridHelper.SetGridStyle(cxGridDeviceUnplan,true,true,true);
  FCxGridHelper.SetGridStyle(cxGridAlarmLost,true,true,true);
  //加字段
  LoadFields(cxGridDeviceLostDBTableView1,gPublicParam.cityid,gPublicParam.userid,5);
  LoadFields(cxGridDeviceUnplanDBTableView1,gPublicParam.cityid,gPublicParam.userid,8);
  LoadFields(cxGridDeviceUnplanDBTableView2,gPublicParam.cityid,gPublicParam.userid,15);

  LoadFields(cxGridAlarmLostDBTableView,gPublicParam.cityid,gPublicParam.userid,23);
  LoadFields(cxGridAlarmLostDBTableView2,gPublicParam.cityid,gPublicParam.userid,24);
end;

procedure TFormAlarmExcept.FormShow(Sender: TObject);
begin
  ShowAlarmDeviceLost(gPublicParam.cityid);
  ShowAlarmDeviceUnplan(gPublicParam.cityid);      
  ShowAlarmUnplan(gPublicParam.cityid);

  GetDeviceGather(gPublicParam.cityid,gPublicParam.Companyid,ComboBoxGather.Items);

  PageControl1.ActivePageIndex:= 0;
end;

procedure TFormAlarmExcept.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //回调，用DLLMGR去释放窗体
  gDllMsgCall(FormAlarmExcept,1,'','');
end;

procedure TFormAlarmExcept.FormDestroy(Sender: TObject);
begin
  //菜单释放
  FCxGridHelper.Free;
  ClearTStrings(ComboBoxGather.Items);
end;

procedure TFormAlarmExcept.ShowAlarmDeviceLost(aCityid: integer);
begin
  DataSourceLost.DataSet:= nil;
  try
    with ClientDataSetLost do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([24,1,aCityid]),0);
    end;
  finally

  end;
  DataSourceLost.DataSet:= ClientDataSetLost;
  cxGridDeviceLostDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmExcept.ShowAlarmDeviceUnplan(aCityid: integer);
begin
  DataSourceUnplan.DataSet:= nil;
  try
    with ClientDataSetUnplan do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([24,2,aCityid,' distinct bts_name,deviceid,branchname,btslevelname,BTSID,btsstatename,btstypename,'+
                                                   'bts_kindname,msc,bsc,lac,station_addr,bts_netstatename,commonality_typename,'+
                                                   'agent_manu,source_mode,cityid']),0);
    end;
  finally

  end;
  DataSourceUnplan.DataSet:= ClientDataSetUnplan;
  cxGridDeviceUnplanDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmExcept.ButtonResendClick(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lCityid, lDeviceid: integer;
  lCityid_Index, lDeviceid_Index: integer;
  lDeviceidStr: string;
  I: integer;
  lRecordIndex: integer;
  lMessageInfo: string;
begin
  lActiveView:= cxGridDeviceLostDBTableView1;
  if not CheckRecordSelected(lActiveView) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  try
    lDeviceid_Index:=lActiveView.GetColumnByFieldName('DEVICEID').Index;
    lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
  except
    Application.MessageBox('未获得关键字段CITYID,DEVICEID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
  begin
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
    lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
    lDeviceid:= lActiveView.DataController.GetValue(lRecordIndex,lDeviceid_Index);
    lDeviceidStr:= lDeviceidStr+ inttostr(lDeviceid) +',';
  end;
  lDeviceidStr:= copy(lDeviceidStr,1,length(lDeviceidStr)-1);

  if length(lDeviceidStr)>0 then
  begin
    iError:= gTempInterface.DeviceLostResend(lCityid, lDeviceidStr);
    case iError of
      0: begin
           lActiveView.DataController.DeleteSelection;
           lMessageInfo:= '操作成功!';
           Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
         end;
      -1: begin
            lMessageInfo:= '存储过程内部执行异常错误!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
          end;
      -2: begin
            lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
          end;
      -3: begin
            lMessageInfo:= '接口异常错误!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
          end;
      -4: begin
            lMessageInfo:= '在告警设备在线表中找不到该设备或信息已补全!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
          end;
      -5: begin
            lMessageInfo:= '在设备信息表该设备信息尚为补全!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
          end
      else if iError < -3 then
          begin
            lMessageInfo:= '接口未成功执行的编码原因!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
          end
      else if iError > 0 then
          begin
            lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
          end;
    end;
  end;
end;

procedure TFormAlarmExcept.ButtonPlanClick(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  iError: integer;
  lCityid, lDeviceid: integer;
  lCityid_Index, lDeviceid_Index: integer;
  I: integer;
  lRecordIndex: integer;
  lGatherid: integer;
  lMessageInfo: string;
begin
  if ComboBoxGather.Items.IndexOf(ComboBoxGather.Text)=-1 then
  begin
    Application.MessageBox('请选择一个设备集！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  lGatherid:= GetDicCode(ComboBoxGather.Text,ComboBoxGather.Items);
  lActiveView:= self.cxGridDeviceUnplanDBTableView1;
  if not CheckRecordSelected(lActiveView) then
  begin
    Application.MessageBox('请在主列表中选择一条基站信息！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  try
    lDeviceid_Index:=lActiveView.GetColumnByFieldName('DEVICEID').Index;
    lCityid_Index:=lActiveView.GetColumnByFieldName('CITYID').Index;
  except
    Application.MessageBox('未获得关键字段CITYID,DEVICEID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  for I := lActiveView.DataController.GetSelectedCount -1 downto 0 do
  begin
    lRecordIndex:= lActiveView.DataController.GetSelectedRowIndex(I);
    lRecordIndex := lActiveView.DataController.FilteredRecordIndex[lRecordIndex];
    lCityid:= lActiveView.DataController.GetValue(lRecordIndex,lCityid_Index);
    lDeviceid:= lActiveView.DataController.GetValue(lRecordIndex,lDeviceid_Index);

    iError := gTempInterface.DeviceGatherSet(lCityid, lGatherid, lDeviceid);
    case iError of
      0: if i = 0 then
         begin
           lActiveView.DataController.DeleteSelection;
           lMessageInfo:= '操作成功!';
           Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
         end;
      -1: begin
            lMessageInfo:= '存储过程内部执行异常错误!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            break;
          end;
      -2: begin
            lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            break;
          end;
      -3: begin
            lMessageInfo:= '接口异常错误!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            break;
          end;
      else if iError < -3 then
          begin
            lMessageInfo:= '接口未成功执行的编码原因!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            break;
          end
      else if iError > 0 then
          begin
            lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
            lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
            Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
            break;
          end;
    end;
  end;
end;

procedure TFormAlarmExcept.PageControl1Change(Sender: TObject);
begin
  ButtonResend.Visible := true;
  if PageControl1.ActivePageIndex = 0 then
  begin
    PanelLost.Visible := True;
    PanelUnplan.Visible := not PanelLost.Visible;
  end else
  if PageControl1.ActivePageIndex = 1 then
  begin
    PanelLost.Visible := false;
    PanelUnplan.Visible := not PanelLost.Visible;
  end
  else if PageControl1.ActivePageIndex = 2 then
  begin
    PanelLost.Visible := true;
    PanelUnplan.Visible :=false;
    ButtonResend.Visible := false;
  end;
end;


procedure TFormAlarmExcept.ShowAlarmDeviceUnplan2(aCityid,
  aDeviceid: integer);
begin
  DataSourceUnplan2.DataSet:= nil;
  try
    with ClientDataSetUnplan2 do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([24,2,inttostr(aCityid)+' and deviceid='+inttostr(aDeviceid),'*']),0);
    end;
  finally

  end;
  DataSourceUnplan2.DataSet:= ClientDataSetUnplan2;
  cxGridDeviceUnplanDBTableView2.ApplyBestFit();
end;

procedure TFormAlarmExcept.cxGridDeviceUnplanDBTableView1DataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  lCityid,lDeviceid: integer;
  lCityid_Index, lDevice_Index: integer;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  try
    lCityid_Index:= cxGridDeviceUnplanDBTableView1.GetColumnByFieldName('CITYID').Index;
    lDevice_Index:= cxGridDeviceUnplanDBTableView1.GetColumnByFieldName('DEVICEID').Index;
  except
    Application.MessageBox('未获得关键字段CITYID,DEVICEID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lCityid:= integer(ADataController.GetValue(ARecordIndex,lCityid_Index));
  lDeviceid:= integer(ADataController.GetValue(ARecordIndex,lDevice_Index));
  ShowAlarmDeviceUnplan2(lCityid,lDeviceid);
end;

//----------------------------------------------------------------------------------

procedure TFormAlarmExcept.cxGridAlarmLostDBTableViewDataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  lCityid,lDeviceid: integer;
  lCityid_Index, lDevice_Index: integer;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  try
    lCityid_Index:= cxGridAlarmLostDBTableView.GetColumnByFieldName('CITYID').Index;
    lDevice_Index:= cxGridAlarmLostDBTableView.GetColumnByFieldName('DEVICEID').Index;
  except
    Application.MessageBox('未获得关键字段CITYID,DEVICEID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lCityid:= integer(ADataController.GetValue(ARecordIndex,lCityid_Index));
  lDeviceid:= integer(ADataController.GetValue(ARecordIndex,lDevice_Index));
  ShowAlarmUnplan2(lCityid,lDeviceid);
end;

procedure TFormAlarmExcept.ShowAlarmUnplan(aCityid: integer);
begin
  DSAlarmLost.DataSet:= nil;
  try
    with CDSAlarmLost do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([24,3,aCityid,' distinct bts_name,deviceid,branchname,btslevelname,BTSID,btsstatename,btstypename,'+
                                                   'bts_kindname,msc,bsc,lac,station_addr,bts_netstatename,commonality_typename,'+
                                                   'agent_manu,source_mode,cityid']),0);
    end;
  finally

  end;
  DSAlarmLost.DataSet:= CDSAlarmLost;
  cxGridAlarmLostDBTableView.ApplyBestFit();
end;

procedure TFormAlarmExcept.ShowAlarmUnplan2(aCityid, aDeviceid: integer);
begin
  DSAlarmLost2.DataSet:= nil;
  try
    with CDSAlarmLost2 do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([24,3,inttostr(aCityid)+' and deviceid='+inttostr(aDeviceid),'*']),0);
    end;
  finally

  end;
  DSAlarmLost2.DataSet:= CDSAlarmLost2;
  cxGridAlarmLostDBTableView2.ApplyBestFit();
end;

end.
