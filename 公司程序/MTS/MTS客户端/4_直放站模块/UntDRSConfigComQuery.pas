unit UntDRSConfigComQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, DBClient, cxContainer, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, CxGridUnit, cxSplitter;

type
  TFrmDRSConfigComQuery = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    cxGridDRSComParam: TcxGrid;
    cxGridDBTVDRSComParam: TcxGridDBTableView;
    cxGridDRSComParamLevel1: TcxGridLevel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    btSendCommand: TButton;
    GroupBox4: TGroupBox;
    cxGridDRSComOn: TcxGrid;
    cxGridDBTVDRSComOn: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    Panel3: TPanel;
    Panel4: TPanel;
    btComHisQuery: TButton;
    cxGridDRSComHis: TcxGrid;
    cxGridDBTVDRSComHis: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    DSDRSParam: TDataSource;
    CDSDRSParam: TClientDataSet;
    DSDRSComHis: TDataSource;
    CDSDRSComHis: TClientDataSet;
    DSDRSCom: TDataSource;
    CDSDRSCom: TClientDataSet;
    cxcbDRSOp: TcxComboBox;
    cxcbDRSType: TcxComboBox;
    cxdeStartDate: TcxDateEdit;
    cxdeEndDate: TcxDateEdit;
    Panel5: TPanel;
    btEnsureOK: TButton;
    cxSplitter1: TcxSplitter;
    Label37: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btSendCommandClick(Sender: TObject);
    procedure btComHisQueryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxGridDBTVDRSComOnFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxGridDBTVDRSComHisFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure btEnsureOKClick(Sender: TObject);
  private
    FCxGridHelper: TCxGridSet;
    
    procedure AddDRSCommandOnFields;
    procedure AddDRSCommandHisFields;
    procedure AddDRSCommandParamFields;
    procedure ShowDRSCommandOnData;
    procedure ShowDRSCommandHisData; 
    procedure ShowDRSCommandParamData(TaskID: Integer; IsHis, IsQuery: Boolean);

    procedure ComSelectChange(IsHis,bTable: Boolean);
  public
    procedure DRSSelectChange;
  end;

var
  FrmDRSConfigComQuery: TFrmDRSConfigComQuery;

implementation

uses Ut_DataModule, Ut_MainForm, UntCommandParam, Ut_Common;

{$R *.dfm}
 
procedure TFrmDRSConfigComQuery.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDRSComOn,false,true,false);
  FCxGridHelper.SetGridStyle(cxGridDRSComHis,false,true,false);
  FCxGridHelper.SetGridStyle(cxGridDRSComParam,false,true,false);   
  
  cxcbDRSOp.Properties.Items.Add('监控系统参数查询');
  cxcbDRSOp.Properties.Items.Add('直放站参数查询');
  cxcbDRSOp.ItemIndex:=0;

  cxcbDRSType.Properties.Items.Add('监控系统参数查询');
  cxcbDRSType.Properties.Items.Add('直放站参数查询');
  cxcbDRSType.Properties.Items.Add('直放站配置命令');

  cxdeStartDate.Date := now-1;
  cxdeEndDate.Date := now;

  AddDRSCommandOnFields;
  AddDRSCommandHisFields;
  AddDRSCommandParamFields;
end;

procedure TFrmDRSConfigComQuery.FormShow(Sender: TObject);
begin
  //ShowDRSCommandOnData;
end;

procedure TFrmDRSConfigComQuery.AddDRSCommandOnFields;
begin
  AddViewField(cxGridDBTVDRSComOn,'taskid','任务编号');
  AddViewField(cxGridDBTVDRSComOn,'drsid','直放站主键',65,false);
  AddViewField(cxGridDBTVDRSComOn,'drsno','直放站编号');
  AddViewField(cxGridDBTVDRSComOn,'r_deviceid','设备编号');
  //AddViewField(cxGridDBTVDRSComOn,'drsname','直放站名称');   
  AddViewField(cxGridDBTVDRSComOn,'drstypename','直放站类型');
  AddViewField(cxGridDBTVDRSComOn,'DRSPHONE','电话号码');
  AddViewField(cxGridDBTVDRSComOn,'drsstatusname','直放站状态');
  AddViewField(cxGridDBTVDRSComOn,'comtype','命令大类');
  AddViewField(cxGridDBTVDRSComOn,'comid','命令编号');
  AddViewField(cxGridDBTVDRSComOn,'comname','命令含义');
  AddViewField(cxGridDBTVDRSComOn,'sendtime','命令发起时间');
  AddViewField(cxGridDBTVDRSComOn,'rectime','命令响应时间');   
  AddViewField(cxGridDBTVDRSComOn,'respfalg','应答标志');
  AddViewField(cxGridDBTVDRSComOn,'respdrsno','返回直放站编号');
  AddViewField(cxGridDBTVDRSComOn,'respr_deviceid','返回设备编号');
  AddViewField(cxGridDBTVDRSComOn,'respdrstypename','返回设备类型');
  AddViewField(cxGridDBTVDRSComOn,'IsUserComOK','手动完成命令',65,false);  
end;

procedure TFrmDRSConfigComQuery.AddDRSCommandHisFields;
begin
  AddViewField(cxGridDBTVDRSComHis,'taskid','任务编号');
  AddViewField(cxGridDBTVDRSComHis,'drsid','直放站主键',65,false);
  AddViewField(cxGridDBTVDRSComHis,'drsno','直放站编号');
  AddViewField(cxGridDBTVDRSComHis,'r_deviceid','设备编号');
  //AddViewField(cxGridDBTVDRSComHis,'drsname','直放站名称');
  AddViewField(cxGridDBTVDRSComHis,'drstypename','直放站类型');
  AddViewField(cxGridDBTVDRSComHis,'DRSPHONE','电话号码');
  AddViewField(cxGridDBTVDRSComHis,'drsstatusname','直放站状态');
  AddViewField(cxGridDBTVDRSComHis,'comtype','命令大类');
  AddViewField(cxGridDBTVDRSComHis,'comid','命令编号');
  AddViewField(cxGridDBTVDRSComHis,'comname','命令含义');
  AddViewField(cxGridDBTVDRSComHis,'sendtime','命令发起时间');
  AddViewField(cxGridDBTVDRSComHis,'rectime','命令响应时间');
  AddViewField(cxGridDBTVDRSComHis,'respfalg','应答标志');
  AddViewField(cxGridDBTVDRSComHis,'respdrsno','返回直放站编号');
  AddViewField(cxGridDBTVDRSComHis,'respr_deviceid','返回设备编号');
  AddViewField(cxGridDBTVDRSComHis,'respdrstypename','返回设备类型');
  AddViewField(cxGridDBTVDRSComHis,'IsUserComOK','手动完成命令',65,false);  
end;

procedure TFrmDRSConfigComQuery.AddDRSCommandParamFields;
begin
  AddViewField(cxGridDBTVDRSComParam,'paramname','参数名');
  AddViewField(cxGridDBTVDRSComParam,'paramvalue','参数值');
end;

procedure TFrmDRSConfigComQuery.ShowDRSCommandOnData;
var
  strSQL: string;
begin
  strSQL := 'select * from drs_config_com_on_view where DRSid='+inttostr(UntCommandParam.Current_DRSID);
  strSQL:=strSQL+' order by taskid desc';
  cxGridDBTVDRSComOn.BeginUpdate;
  //DSDRSCom.DataSet:= nil;
  with CDSDRSCom do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,5,1,strSQL]),0);
  end;
  //DSDRSCom.DataSet:= CDSDRSCom;   
  cxGridDBTVDRSComOn.EndUpdate;
  cxGridDBTVDRSComOn.ApplyBestFit();
end;


procedure TFrmDRSConfigComQuery.ShowDRSCommandHisData;
var
  strSQL, strCond: string;
begin
  strCond := ' ';
  strCond := strCond+' and sendtime >= to_date('''+DateTimeToStr(cxdeStartDate.Date)+''',''yyyy-mm-dd hh24:mi:ss'')';
  strCond := strCond+' and sendtime <= to_date('''+DateTimeToStr(cxdeEndDate.Date)+''',''yyyy-mm-dd hh24:mi:ss'')';
  
  if cxcbDRSType.ItemIndex=0 then
    strCond := ' and ComID=32'
  else if cxcbDRSType.ItemIndex=1 then
    strCond := ' and ComID=33'
  else if cxcbDRSType.ItemIndex=2 then
    strCond := ' and ComID not in (32,33)';
  strCond:=strCond+' order by taskid desc';

  strSQL := 'select * from drs_config_com_his_view where DRSid='+inttostr(UntCommandParam.Current_DRSid)+strCond;

  cxGridDBTVDRSComHis.BeginUpdate;
  DSDRSComHis.DataSet:= nil;
  with CDSDRSComHis do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,5,1,strSQL]),0);
  end;
  DSDRSComHis.DataSet:= CDSDRSComHis;   
  cxGridDBTVDRSComHis.EndUpdate;
  cxGridDBTVDRSComHis.ApplyBestFit();
end;

procedure TFrmDRSConfigComQuery.ShowDRSCommandParamData(TaskID: Integer; IsHis, IsQuery: Boolean);
var
  strSQL: string;
begin
  if IsQuery then//查询
    if IsHis then
      strSQL := 'select * from drs_config_comparamq_his_view where taskid='+IntToStr(TaskID)+' order by ParamID'
    else
      strSQL := 'select * from drs_config_comparamq_on_view where taskid='+IntToStr(TaskID)+' order by ParamID'
  else//设置
    if IsHis then
      strSQL := 'select * from drs_config_comparam_His_view where taskid='+IntToStr(TaskID)+' order by ParamID'
    else
      strSQL := 'select * from drs_config_comparam_on_view where taskid='+IntToStr(TaskID)+' order by ParamID';


  cxGridDBTVDRSComParam.BeginUpdate;
  //DSDRSCom.DataSet:= nil;
  with CDSDRSParam do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,5,1,strSQL]),0);
  end;
  //DSDRSCom.DataSet:= CDSDRSCom;
  cxGridDBTVDRSComParam.EndUpdate;
  cxGridDBTVDRSComParam.ApplyBestFit();
end;

procedure TFrmDRSConfigComQuery.DRSSelectChange;
begin
  btSendCommand.Enabled := (UntCommandParam.CurrentDRSStatus<>1) and (UntCommandParam.CurrentDRSStatus<>-1);

  ShowDRSCommandOnData;
end;  

procedure TFrmDRSConfigComQuery.cxGridDBTVDRSComOnFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  ComSelectChange(false,True);
end;

procedure TFrmDRSConfigComQuery.cxGridDBTVDRSComHisFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  ComSelectChange(true,False);
end;

procedure TFrmDRSConfigComQuery.ComSelectChange(IsHis,bTable: Boolean);
var
  TaskID: Integer;
  lIsQuery: boolean;
  lIsUserSend: boolean;
  function CheckIsQuery(aStr: string): boolean;
  begin
    if aStr='设置命令' then
      result:= false
    else
      result:= true;
  end;
  function CheckIsUserSend(aStr: string): boolean;
  begin
    if aStr='1' then
      result:= true
    else
      result:= false;
  end;
begin
  if IsHis then
  begin
    if CDSDRSComHis.IsEmpty then
      TaskID := -1
    else
    begin
      TaskID := CDSDRSComHis.FieldByName('TaskID').AsInteger;
      lIsQuery:= CheckIsQuery(CDSDRSComHis.FieldByName('comtype').AsString);
      lIsUserSend:= CheckIsUserSend(CDSDRSComHis.FieldByName('IsUserComOK').AsString);
    end;
  end
  else
  begin
    if CDSDRSCom.IsEmpty then
      TaskID := -1
    else
    begin
      TaskID := CDSDRSCom.FieldByName('TaskID').AsInteger;
      lIsQuery:= CheckIsQuery(CDSDRSCom.FieldByName('comtype').AsString);
      lIsUserSend:= CheckIsUserSend(CDSDRSCom.FieldByName('IsUserComOK').AsString);
    end;
  end;

  if (lIsUserSend and bTable) then
    btEnsureOK.Enabled:= true
  else
    btEnsureOK.Enabled:= false;
    
  ShowDRSCommandParamData(TaskID, IsHis, lIsQuery);
end;  

procedure TFrmDRSConfigComQuery.btSendCommandClick(Sender: TObject);
var  
  TaskID, UserID: Integer;
begin
  TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');
  UserID := Fm_MainForm.PublicParam.userid;
  if cxcbDRSOp.ItemIndex=0 then
  begin
    if SendCommand32(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,UntCommandParam.CurrentDRSNO) then
      Application.MessageBox('命令执行成功！','提示')
    else
      Application.MessageBox('命令执行失败！','提示');
  end
  else
  begin
    if SendCommand33(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,UntCommandParam.CurrentDRSNO) then
      Application.MessageBox('命令执行成功！','提示')
    else
      Application.MessageBox('命令执行失败！','提示');
      ShowDRSCommandOnData;
  end;
end;

procedure TFrmDRSConfigComQuery.btEnsureOKClick(Sender: TObject);
var
  strSQL: string;
  TaskID: Integer;
begin
  if CDSDRSCom.IsEmpty then
      TaskID := -1
    else
      TaskID := CDSDRSCom.FieldByName('TaskID').AsInteger;
  strSQL := 'delete drs_testtask_user where taskid='+IntToStr(TaskID);
  if not Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,5,1,strSQL])])) then
    Application.MessageBox('确认操作失败！','操作失败')
  else
  begin
    strSQL := 'delete drs_testparam_user where taskid='+IntToStr(TaskID);
    Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([VarArrayOf([1,5,1,strSQL])]));
    Application.MessageBox('确认操作成功！','操作成功');
    ShowDRSCommandOnData;
  end;
end;

procedure TFrmDRSConfigComQuery.btComHisQueryClick(Sender: TObject);
begin
  ShowDRSCommandHisData;
end;




end.
