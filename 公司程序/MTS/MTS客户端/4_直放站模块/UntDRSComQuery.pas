unit UntDRSComQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, DBClient, cxContainer, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, CxGridUnit, cxSplitter, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, cxCheckBox, StringUtils;

type
  TFrmDRSComQuery = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    cxGridDRSComParam: TcxGrid;
    cxGridDBTVDRSComParam: TcxGridDBTableView;
    cxGridDRSComParamLevel1: TcxGridLevel;
    GroupBox4: TGroupBox;
    cxGridDRSComOn: TcxGrid;
    cxGridDBTVDRSComOn: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    DSDRSParam: TDataSource;
    CDSDRSParam: TClientDataSet;
    DSDRSCom: TDataSource;
    CDSDRSCom: TClientDataSet;
    Panel5: TPanel;
    btEnsureOK: TButton;
    Panel7: TPanel;
    GroupBox5: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    rgComQueryType: TRadioGroup;
    Panel8: TPanel;
    Label6: TLabel;
    cxdeStartDate: TcxDateEdit;
    cxdeEndDate: TcxDateEdit;
    cxcbDRSOp: TcxComboBox;
    Panel9: TPanel;
    btQuery: TButton;
    cxTextEdit1: TcxTextEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    cbHasAlarm: TCheckBox;
    CDSDRSType: TClientDataSet;
    DSDRSType: TDataSource;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
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
    procedure btQueryClick(Sender: TObject);
    procedure rgComQueryTypeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1Change(Sender: TObject);
  private
    FCxGridHelper: TCxGridSet;
    VatID:Integer;
    gIsHisSearch: boolean;

    procedure InitDRSType;
    procedure AddDRSCommandOnFields;
    procedure AddDRSCommandParamFields;
    procedure ShowDRSCommandOnData;
    procedure ShowDRSCommandHisData; 
    procedure ShowDRSCommandParamData(TaskID: Integer; IsHis, IsQuery: Boolean);

    procedure ComSelectChange(IsHis: Boolean);
  public
    procedure DRSSelectChange;
  end;

var
  FrmDRSComQuery: TFrmDRSComQuery;

implementation

uses Ut_DataModule, Ut_MainForm, UntCommandParam, Ut_Common;

{$R *.dfm}
 
procedure TFrmDRSComQuery.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := cafree;
  FCxGridHelper.Free;
  Fm_MainForm.DeleteTab(self);
  FrmDRSComQuery:=nil;
end;

procedure TFrmDRSComQuery.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDRSComOn,false,true,false);

  FCxGridHelper.SetGridStyle(cxGridDRSComParam,false,true,false);   

  cxcbDRSOp.Properties.Items.Add('监控系统参数查询');
  cxcbDRSOp.Properties.Items.Add('直放站参数查询');
  cxcbDRSOp.Properties.Items.Add('直放站配置命令');
  cxcbDRSOp.ItemIndex:=0; 

  cxdeStartDate.Date := now-1;
  cxdeEndDate.Date := now;

  InitDRSType;

  AddDRSCommandOnFields;  
  AddDRSCommandParamFields;
end;

procedure TFrmDRSComQuery.FormShow(Sender: TObject);
begin
  //ShowDRSCommandOnData;
end;

procedure TFrmDRSComQuery.InitDRSType;
var
  lWdInteger:TWdInteger;
  strSQL: string;
begin
  ClearTStrings(ComboBox1.Items);

  strSQL := 'select t.diccode,t.dicname from dic_code_info t where t.dictype=51';
  with CDSDRSType do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,5,1,strSQL]),0);
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('diccode').AsInteger);
      ComboBox1.Items.AddObject(Fieldbyname('dicname').AsString,lWdInteger);
      next;
    end;
    Close;
  end;
end;
{var
  strSQL: string;
begin
  strSQL := 'select t.diccode,t.dicname from dic_code_info t where t.dictype=51';

  with CDSDRSType do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,5,1,strSQL]),0);
  end;
end; }

procedure TFrmDRSComQuery.AddDRSCommandOnFields;
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

procedure TFrmDRSComQuery.AddDRSCommandParamFields;
begin
  AddViewField(cxGridDBTVDRSComParam,'paramname','参数名');
  AddViewField(cxGridDBTVDRSComParam,'paramvalue','参数值');
end;

procedure TFrmDRSComQuery.ShowDRSCommandOnData;
var
  strSQL, strCond, strCondin: string;
begin
  strCond := ' ';

  //命令执行时间段
  strCond := strCond+' and sendtime >= to_date('''+DateTimeToStr(cxdeStartDate.Date)+''',''yyyy-mm-dd hh24:mi:ss'')';
  strCond := strCond+' and sendtime <= to_date('''+DateTimeToStr(cxdeEndDate.Date)+''',''yyyy-mm-dd hh24:mi:ss'')';

  if cxcbDRSOp.ItemIndex=0 then    //操作类型 
    strCond :=strCond+ ' and ComID=32'
  else if cxcbDRSOp.ItemIndex=1 then
    strCond :=strCond+ ' and ComID=33'
  else if cxcbDRSOp.ItemIndex=2 then
    strCond :=strCond+ ' and ComID not in (32,33)';


  strCondin := '1=2 ';

  //手动发起 或 自动轮询
  if CheckBox2.Checked then
    strCondin := strCondin+' or tasklevel=3';
    //strCond :=strCond+ ' and tasklevel=3';
  if CheckBox3.Checked then
    strCondin := strCondin+' or tasklevel=1';
    //strCond :=strCond+ ' and tasklevel=1';
  //if (CheckBox2.Checked) and CheckBox3.Checked  then
   // strCond :=strCond+ ' and (tasklevel=1 or tasklevel=3)';

  //只显示失败或超时命令
  if CheckBox1.Checked  then
    strCondin := strCondin+' or respfalg=0';
    //strCond :=strCond+ ' and respfalg=0';

    if strCondin <> '1=2 ' then
      strCond := strCond+' and ('+strCondin+') ';

  //直放站类型
  if Trim(ComboBox1.Text)<>'' then
    strCond:=strCond+' and DRSTYPE='+inttostr(VatID);
  if Trim(cxTextEdit1.Text)<>'' then
    strCond:=strCond+' and (upper(drsno) like ''%'+uppercase(cxTextEdit1.Text)+
                   '%'' or upper(drsname) like ''%'+uppercase(cxTextEdit1.Text)+
                   '%'' or upper(DRSADRESS) like ''%'+uppercase(cxTextEdit1.Text)+
                   '%'' or upper(drsphone) like ''%'+uppercase(cxTextEdit1.Text)+'%'')';
  strCond:=strCond+' order by taskid desc';

  strSQL := 'select * from drs_config_com_on_view where 1=1 '+strCond;

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

procedure TFrmDRSComQuery.ShowDRSCommandHisData;
var
  strSQL, strCond, strCondin: string;
begin
  strCond := ' ';

  //命令执行时间段
  strCond := strCond+' and sendtime >= to_date('''+DateTimeToStr(cxdeStartDate.Date)+''',''yyyy-mm-dd hh24:mi:ss'')';
  strCond := strCond+' and sendtime <= to_date('''+DateTimeToStr(cxdeEndDate.Date)+''',''yyyy-mm-dd hh24:mi:ss'')';

  if cxcbDRSOp.ItemIndex=0 then    //操作类型 
    strCond :=strCond+ ' and ComID=32'
  else if cxcbDRSOp.ItemIndex=1 then
    strCond :=strCond+ ' and ComID=33'
  else if cxcbDRSOp.ItemIndex=2 then
    strCond :=strCond+ ' and ComID not in (32,33)';

  strCondin := '1=2 ';

  //手动发起 或 自动轮询
  if CheckBox2.Checked then
    //strCond :=strCond+ ' and tasklevel=3';
    strCondin := strCondin+' or tasklevel=3';
  if CheckBox3.Checked then
    //strCond :=strCond+ ' and tasklevel=1';
    strCondin := strCondin+' or tasklevel=1';
  //if (CheckBox2.Checked) and CheckBox3.Checked  then
    //strCond :=strCond+ ' and (tasklevel=1 or tasklevel=3)';

  //只显示失败或超时命令
  if CheckBox1.Checked  then
    //strCond :=strCond+ ' and respfalg=0';
    strCondin := strCondin+' or respfalg=0';

  //直放站类型
  if Trim(ComboBox1.Text)<>'' then
    strCond:=strCond+' and DRSTYPE='+inttostr(VatID);
  if Trim(cxTextEdit1.Text)<>'' then
    strCond:=strCond+' and (upper(drsno) like ''%'+uppercase(cxTextEdit1.Text)+
                   '%'' or upper(drsname) like ''%'+uppercase(cxTextEdit1.Text)+
                   '%'' or upper(DRSADRESS) like ''%'+uppercase(cxTextEdit1.Text)+
                   '%'' or upper(drsphone) like ''%'+uppercase(cxTextEdit1.Text)+'%'')';


  //直放站告警
  if cbHasAlarm.Checked then
    //strCond :=strCond+ ' and tasklevel=2';
    strCondin := strCondin+' or tasklevel=2';

    if strCondin <> '1=2 ' then
      strCond := strCond+' and ('+strCondin+') ';

   strCond:=strCond+' order by taskid desc';
  strSQL := 'select * from drs_config_com_his_view where 1=1 '+strCond;

  cxGridDBTVDRSComOn.BeginUpdate;
  with CDSDRSCom do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,5,1,strSQL]),0);
  end;
  cxGridDBTVDRSComOn.EndUpdate;
  cxGridDBTVDRSComOn.ApplyBestFit();

end;

procedure TFrmDRSComQuery.ShowDRSCommandParamData(TaskID: Integer; IsHis, IsQuery: Boolean);
var
  strSQL: string;
begin
//  if IsHis then
//    strSQL := 'select * from drs_config_comparam_His_view where taskid='+IntToStr(TaskID)+' order by ParamID'
//  else
//    strSQL := 'select * from drs_config_comparam_on_view where taskid='+IntToStr(TaskID)+' order by ParamID';
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

procedure TFrmDRSComQuery.DRSSelectChange;
begin

  ShowDRSCommandOnData;
end;  

procedure TFrmDRSComQuery.cxGridDBTVDRSComOnFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  ComSelectChange(gIsHisSearch);
end;

procedure TFrmDRSComQuery.cxGridDBTVDRSComHisFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  ComSelectChange(true);
end;

procedure TFrmDRSComQuery.ComboBox1Change(Sender: TObject);
begin
  try
    VatID:=TCommonObj(ComboBox1.Items.Objects[ComboBox1.ItemIndex]).ID;
  except

  end;
end;

procedure TFrmDRSComQuery.ComSelectChange(IsHis: Boolean);
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

  if lIsUserSend then
    btEnsureOK.Enabled:= true
  else
    btEnsureOK.Enabled:= false;

  ShowDRSCommandParamData(TaskID, IsHis, lIsQuery);
end;
           
procedure TFrmDRSComQuery.rgComQueryTypeClick(Sender: TObject);
begin
  cbHasAlarm.Enabled := rgComQueryType.ItemIndex=1;
end;

procedure TFrmDRSComQuery.btEnsureOKClick(Sender: TObject);
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
    Application.MessageBox('确认操作成功！','操作成功')
end;

procedure TFrmDRSComQuery.btQueryClick(Sender: TObject);
begin
  if rgComQueryType.ItemIndex=0 then
  begin
    ShowDRSCommandOnData;
    gIsHisSearch:= false;
  end
  else
  begin
    ShowDRSCommandHisData;
    gIsHisSearch:= true;
  end;
end;

end.
