unit UntDRSConfigParamSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Mask, DBCtrls, DB, DBClient,
  cxGraphics, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxCalendar,
  cxDBEdit;

type
  TFrmDRSConfigParamSet = class(TForm)
    PageControl2: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DSDRSParam: TDataSource;
    CDSDRSParam: TClientDataSet;
    Panel8: TPanel;
    Panel9: TPanel;
    GroupBox8: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    dbcb0X32_01: TDBCheckBox;
    dbcb0X32_02: TDBCheckBox;
    dbcb0X32_03: TDBCheckBox;
    dbcb0X32_04: TDBCheckBox;
    dbcb0X32_05: TDBCheckBox;
    dbcb0X32_06: TDBCheckBox;
    dbcb0X32_07: TDBCheckBox;
    dbcb0X32_09: TDBCheckBox;
    dbcb0X32_10: TDBCheckBox;
    dbcb0X32_11: TDBCheckBox;
    dbcb0X32_12: TDBCheckBox;
    dbcb0X32_13: TDBCheckBox;
    dbcb0X32_14: TDBCheckBox;
    dbcb0X32_15: TDBCheckBox;
    dbcb0X32_16: TDBCheckBox;
    dbcb0X32_17: TDBCheckBox;
    cb0X32: TCheckBox;
    Panel10: TPanel;
    GroupBox9: TGroupBox;
    Label45: TLabel;
    Label46: TLabel;
    dbeR_DEVICEID: TDBEdit;
    dbeDRSNO: TDBEdit;
    cb0X30: TCheckBox;
    Panel11: TPanel;
    GroupBox10: TGroupBox;
    Label47: TLabel;
    Label48: TLabel;
    dbcb0X34_01: TDBCheckBox;
    dbcb0X34_02: TDBCheckBox;
    cb0X34: TCheckBox;
    Panel12: TPanel;
    GroupBox11: TGroupBox;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    dbe0X31_03: TDBEdit;
    ebe0X31_01: TDBEdit;
    dbe0X31_02: TDBEdit;
    cb0X31: TCheckBox;
    Panel13: TPanel;
    GroupBox12: TGroupBox;
    Label52: TLabel;
    Label53: TLabel;
    dbe0X33_02: TDBEdit;
    dbe0X33_01: TDBEdit;
    cb0X33: TCheckBox;
    Panel14: TPanel;
    GroupBox13: TGroupBox;
    Label54: TLabel;
    Label55: TLabel;
    dbe0X35_02: TDBEdit;
    dbe0X35_01: TDBEdit;
    cb0X35: TCheckBox;
    Panel15: TPanel;
    GroupBox14: TGroupBox;
    Label56: TLabel;
    Label57: TLabel;
    dbe0X36_02: TDBEdit;
    dbe0X36_01: TDBEdit;
    cb0X36: TCheckBox;
    Panel1: TPanel;
    Panel18: TPanel;
    rgDRSConfig: TRadioGroup;
    Panel19: TPanel;
    GroupBox16: TGroupBox;
    Label61: TLabel;
    Label62: TLabel;
    DSDRSParamDate: TDataSource;
    CDSDRSParamDate: TClientDataSet;
    Panel20: TPanel;
    btSelectAll: TButton;
    btApplyConfig: TButton;
    Label1: TLabel;
    dbcb0X32_08: TDBCheckBox;
    cxLCBDRSConfigBatchID: TcxLookupComboBox;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    CheckBox1: TCheckBox;
    Panel3: TPanel;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    DBCheckBox8: TDBCheckBox;
    DBCheckBox9: TDBCheckBox;
    DBCheckBox10: TDBCheckBox;
    DBCheckBox11: TDBCheckBox;
    DBCheckBox12: TDBCheckBox;
    DBCheckBox13: TDBCheckBox;
    DBCheckBox14: TDBCheckBox;
    DBCheckBox15: TDBCheckBox;
    DBCheckBox16: TDBCheckBox;
    DBCheckBox17: TDBCheckBox;
    CheckBox2: TCheckBox;
    Panel4: TPanel;
    GroupBox3: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    CheckBox3: TCheckBox;
    Panel5: TPanel;
    GroupBox4: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    CheckBox4: TCheckBox;
    Panel6: TPanel;
    GroupBox5: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    DBCheckBox18: TDBCheckBox;
    DBCheckBox19: TDBCheckBox;
    CheckBox5: TCheckBox;
    Panel7: TPanel;
    GroupBox6: TGroupBox;
    Label28: TLabel;
    Label58: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    CheckBox6: TCheckBox;
    Panel16: TPanel;
    GroupBox7: TGroupBox;
    Label59: TLabel;
    Label60: TLabel;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    CheckBox7: TCheckBox;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DSDRSCurrentConfig: TDataSource;
    CDSDRSCurrentConfig: TClientDataSet;
    procedure FormShow(Sender: TObject);
    procedure btSelectAllClick(Sender: TObject);
    procedure btApplyConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgDRSConfigClick(Sender: TObject);
    procedure cxLCBDRSConfigBatchIDPropertiesEditValueChanged(Sender: TObject);
  private
    procedure ShowDRSCurrentConfigData;
    procedure ShowDRSConfigData;
    procedure ShowDRSConfigHisData;

    function CheckValidData: boolean;
    function ApplyConfig: boolean;
  public
    procedure DRSSelectChange;
  end;

var
  FrmDRSConfigParamSet: TFrmDRSConfigParamSet;

implementation

uses Ut_DataModule, Ut_MainForm, UntCommandParam;

{$R *.dfm}

{ TFrmDRSConfigParamSet }

procedure TFrmDRSConfigParamSet.FormCreate(Sender: TObject);
begin
 //
end;

procedure TFrmDRSConfigParamSet.FormShow(Sender: TObject);
begin
 // ShowDRSConfigData;   
end;

procedure TFrmDRSConfigParamSet.ShowDRSCurrentConfigData;
begin
  DSDRSCurrentConfig.DataSet:= nil;
  with CDSDRSCurrentConfig do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,3,5, UntCommandParam.Current_DRSID]),0);
  end;
  DSDRSCurrentConfig.DataSet:= CDSDRSCurrentConfig;
end;

procedure TFrmDRSConfigParamSet.ShowDRSConfigData;
begin
  DSDRSParam.DataSet:= nil;
  with CDSDRSParam do
  begin
    Close;
    ProviderName:='dsp_General_data';

    if rgDRSConfig.ItemIndex=0 then
    begin
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,3,6, UntCommandParam.Current_DRSID]),0);
    end
    else if rgDRSConfig.ItemIndex=1 then
    begin
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,3,5, UntCommandParam.Current_DRSID]),0);
    end
    else
    begin
      if CDSDRSParamDate.IsEmpty or (cxLCBDRSConfigBatchID.EditText='') then
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,3,5, UntCommandParam.Current_DRSID]),0)
      else
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,3,7,
          '(select comid, paramid, paramvalue from drs_prepparam_set_h t where t.batchid='+
          cxLCBDRSConfigBatchID.EditText+' and t.drsid='+
          IntToStr(UntCommandParam.Current_DRSID)+')', UntCommandParam.Current_DRSID]),0);
    end; 
  end;
  DSDRSParam.DataSet:= CDSDRSParam;
end;

procedure TFrmDRSConfigParamSet.ShowDRSConfigHisData;
begin
  DSDRSParamDate.DataSet:= nil;
  with CDSDRSParamDate do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([1,3,10, UntCommandParam.Current_DRSID]),0);
  end;
  DSDRSParamDate.DataSet:= CDSDRSParamDate;
end;

procedure TFrmDRSConfigParamSet.DRSSelectChange;
begin
  ShowDRSConfigHisData;
  ShowDRSCurrentConfigData;
  ShowDRSConfigData;  
end;

procedure TFrmDRSConfigParamSet.rgDRSConfigClick(Sender: TObject);
begin
  ShowDRSConfigData;
end;

procedure TFrmDRSConfigParamSet.cxLCBDRSConfigBatchIDPropertiesEditValueChanged(
  Sender: TObject);
begin
  if rgDRSConfig.ItemIndex=2 then ShowDRSConfigData;
end; 

procedure TFrmDRSConfigParamSet.btSelectAllClick(Sender: TObject);
begin
  cb0X30.Checked := true;
  cb0X31.Checked := true;
  cb0X32.Checked := true;
  cb0X33.Checked := true;
  cb0X34.Checked := true;
  cb0X35.Checked := true;
  cb0X36.Checked := true;
end;

procedure TFrmDRSConfigParamSet.btApplyConfigClick(Sender: TObject);
begin
  if ApplyConfig then
    Application.MessageBox('参数配置成功！','提示')
  else
    Application.MessageBox('参数配置失败！','提示');
end;

function TFrmDRSConfigParamSet.CheckValidData: boolean;
begin
  Result := false;

  if cb0X30.Checked then
  begin
    if (CDSDRSParam.FieldByName('DRSNO').AsString='') or (CDSDRSParam.FieldByName('R_DEVICEID').AsString='') then
    begin
      Application.MessageBox('直放站编号和设备编号不能为空！', '警告');
      exit;
    end;
  end;
  if cb0X31.Checked then
  begin
    if (CDSDRSParam.FieldByName('P0X31_01').AsString='') or (CDSDRSParam.FieldByName('P0X31_02').AsString='') then
    begin
      Application.MessageBox('查询电话和告警电话不能为空！', '警告');
      exit;
    end;
  end;
  if cb0X33.Checked then
  begin
    if (CDSDRSParam.FieldByName('P0X33_01').AsString='') or (CDSDRSParam.FieldByName('P0X33_02').AsString='') then
    begin
      Application.MessageBox('上行/下行输出功率告警上限不能为空！', '警告');
      exit;
    end;
  end;
  if cb0X35.Checked then
  begin
    if (CDSDRSParam.FieldByName('P0X35_01').AsString='') or (CDSDRSParam.FieldByName('P0X35_02').AsString='') then
    begin
      Application.MessageBox('上行/下行输衰减量不能为空！', '警告');
      exit;
    end;
  end;
  if cb0X36.Checked then
  begin
    if (CDSDRSParam.FieldByName('P0X36_01').AsString='') or (CDSDRSParam.FieldByName('P0X36_02').AsString='') then
    begin
      Application.MessageBox('信道号1/2不能为空！', '警告');
      exit;
    end;
  end;   

  Result := true;
end;

function TFrmDRSConfigParamSet.ApplyConfig: boolean;
var
  TaskID, UserID, iSelectCount, I: Integer;
  varData, varDataTemp: Variant;
  lClientSet:TClientDataSet;
  lSqlstr:string;
begin
  if not CheckValidData then exit;

  UserID := Fm_MainForm.PublicParam.userid;

  varDataTemp := VarArrayCreate([0, 60], varVariant);
  iSelectCount := 0;
  if cb0X30.Checked then
  begin
    lClientSet:= TClientDataSet.Create(nil);
    lSqlstr:='select * from DRS_Info_VIEW';

    with lClientSet do
    begin
      ProviderName:='DRS_Info';
      data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
    end;
    if lClientSet.Locate('R_DEVICEID;DRSNO',VarArrayOf([dbeR_DEVICEID.Text,dbeDRSNO.Text]),[])  then
    begin
      ShowMessage('该直放站编号和设备编号的组合已存在');
      Exit;
    end;

    TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');
    Result := SendCommand48(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                            UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,
                            CDSDRSParam.FieldByName('DRSNO').Value, CDSDRSParam.FieldByName('R_DEVICEID').Value,
                            UntCommandParam.CurrentDRSNO);

    varDataTemp[iSelectCount] := VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 48, 1, UntCommandParam.CurrentDRSType,UserID, TaskID]);
    varDataTemp[iSelectCount+1] := VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 48, 2, 0,UserID, TaskID]);
    varDataTemp[iSelectCount+2] := VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 48, 24, ''''+UntCommandParam.CurrentDRSNO+'''',UserID, TaskID]);
    varDataTemp[iSelectCount+3] := VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 48, 25, UntCommandParam.CurrentR_DeviceID,UserID, TaskID]);
    varDataTemp[iSelectCount+4] := VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 48, 85, ''''+CDSDRSParam.FieldByName('DRSNO').Value+'''',UserID, TaskID]);
    varDataTemp[iSelectCount+5] := VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 48, 86, CDSDRSParam.FieldByName('R_DEVICEID').Value,UserID, TaskID]);
    iSelectCount := iSelectCount+6;
  end;
  if cb0X31.Checked then
  begin
    TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');

    Result := SendCommand49(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                            UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,
                            CDSDRSParam.FieldByName('P0X31_01').Value, CDSDRSParam.FieldByName('P0X31_02').Value,
                            UntCommandParam.CurrentDRSNO);


    varDataTemp[iSelectCount]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 49, 1, UntCommandParam.CurrentDRSType,UserID, TaskID]);
    varDataTemp[iSelectCount+1]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 49, 2, 0,UserID, TaskID]);
    varDataTemp[iSelectCount+2]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 49, 24, ''''+UntCommandParam.CurrentDRSNO+'''',UserID, TaskID]);
    varDataTemp[iSelectCount+3]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 49, 25, UntCommandParam.CurrentR_DeviceID,UserID, TaskID]);
    varDataTemp[iSelectCount+4]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 49, 4, CDSDRSParam.FieldByName('P0X31_01').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+5]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 49, 5, CDSDRSParam.FieldByName('P0X31_02').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+6]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 49, 6, '''0X01''',UserID, TaskID]);
    iSelectCount := iSelectCount+7;
  end;
  if cb0X32.Checked then
  begin
    TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');

    Result := SendCommand50(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                            UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,
                            CDSDRSParam.FieldByName('P0X32_01').Value, CDSDRSParam.FieldByName('P0X32_02').Value,
                            CDSDRSParam.FieldByName('P0X32_03').Value, CDSDRSParam.FieldByName('P0X32_04').Value,
                            CDSDRSParam.FieldByName('P0X32_05').Value, CDSDRSParam.FieldByName('P0X32_06').Value,
                            CDSDRSParam.FieldByName('P0X32_07').Value, CDSDRSParam.FieldByName('P0X32_08').Value,
                            CDSDRSParam.FieldByName('P0X32_09').Value, CDSDRSParam.FieldByName('P0X32_10').Value,
                            CDSDRSParam.FieldByName('P0X32_11').Value, CDSDRSParam.FieldByName('P0X32_12').Value,
                            CDSDRSParam.FieldByName('P0X32_13').Value, CDSDRSParam.FieldByName('P0X32_14').Value,
                            CDSDRSParam.FieldByName('P0X32_15').Value, CDSDRSParam.FieldByName('P0X32_16').Value,
                            CDSDRSParam.FieldByName('P0X32_17').Value,UntCommandParam.CurrentDRSNO);


    varDataTemp[iSelectCount]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 1, UntCommandParam.CurrentDRSType,UserID, TaskID]);
    varDataTemp[iSelectCount+1]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 2, 0,UserID, TaskID]);
    varDataTemp[iSelectCount+2]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 24, ''''+UntCommandParam.CurrentDRSNO+'''',UserID, TaskID]);
    varDataTemp[iSelectCount+3]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 25, UntCommandParam.CurrentR_DeviceID,UserID, TaskID]);
    varDataTemp[iSelectCount+4]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 7, CDSDRSParam.FieldByName('P0X32_01').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+5]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 8, CDSDRSParam.FieldByName('P0X32_02').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+6]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 9, CDSDRSParam.FieldByName('P0X32_03').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+7]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 10, CDSDRSParam.FieldByName('P0X32_04').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+8]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 11, CDSDRSParam.FieldByName('P0X32_05').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+9]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 12, CDSDRSParam.FieldByName('P0X32_06').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+10]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 13, CDSDRSParam.FieldByName('P0X32_07').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+11]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 14, CDSDRSParam.FieldByName('P0X32_08').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+12]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 15, CDSDRSParam.FieldByName('P0X32_09').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+13]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 16, CDSDRSParam.FieldByName('P0X32_10').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+14]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 17, CDSDRSParam.FieldByName('P0X32_11').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+15]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 18, CDSDRSParam.FieldByName('P0X32_12').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+16]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 19, CDSDRSParam.FieldByName('P0X32_13').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+17]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 20, CDSDRSParam.FieldByName('P0X32_14').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+18]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 21, CDSDRSParam.FieldByName('P0X32_15').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+19]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 22, CDSDRSParam.FieldByName('P0X32_16').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+20]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 50, 23, CDSDRSParam.FieldByName('P0X32_17').Value,UserID, TaskID]);
    
    iSelectCount := iSelectCount+21;
  end;
  if cb0X33.Checked then
  begin
    TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');

    Result := SendCommand51(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                            UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,
                            CDSDRSParam.FieldByName('P0X33_01').Value, CDSDRSParam.FieldByName('P0X33_02').Value,
                            UntCommandParam.CurrentDRSNO);


    varDataTemp[iSelectCount]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 51, 1, UntCommandParam.CurrentDRSType,UserID, TaskID]);
    varDataTemp[iSelectCount+1]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 51, 2, 0,UserID, TaskID]);
    varDataTemp[iSelectCount+2]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 51, 24, ''''+UntCommandParam.CurrentDRSNO+'''',UserID, TaskID]);
    varDataTemp[iSelectCount+3]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 51, 25, UntCommandParam.CurrentR_DeviceID,UserID, TaskID]);
    varDataTemp[iSelectCount+4]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 51, 27, CDSDRSParam.FieldByName('P0X33_01').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+5]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 51, 76, CDSDRSParam.FieldByName('P0X33_02').Value,UserID, TaskID]);

    iSelectCount := iSelectCount+6;
  end;
  if cb0X34.Checked then
  begin
    TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');

    Result := SendCommand52(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                            UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,
                            CDSDRSParam.FieldByName('P0X34_01').Value, CDSDRSParam.FieldByName('P0X34_02').Value,
                            UntCommandParam.CurrentDRSNO);


    varDataTemp[iSelectCount]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 52, 1, UntCommandParam.CurrentDRSType,UserID, TaskID]);
    varDataTemp[iSelectCount+1]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 52, 2, 0,UserID, TaskID]);
    varDataTemp[iSelectCount+2]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 52, 24, ''''+UntCommandParam.CurrentDRSNO+'''',UserID, TaskID]);
    varDataTemp[iSelectCount+3]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 52, 25, UntCommandParam.CurrentR_DeviceID,UserID, TaskID]);
    varDataTemp[iSelectCount+4]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 52, 56, CDSDRSParam.FieldByName('P0X34_01').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+5]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 52, 55, CDSDRSParam.FieldByName('P0X34_02').Value,UserID, TaskID]);

    iSelectCount := iSelectCount+6;
  end;
  if cb0X35.Checked then
  begin
    TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');

    Result := SendCommand53(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                            UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,
                            CDSDRSParam.FieldByName('P0X35_01').Value, CDSDRSParam.FieldByName('P0X35_02').Value,
                            UntCommandParam.CurrentDRSNO);


    varDataTemp[iSelectCount]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 53, 1, UntCommandParam.CurrentDRSType,UserID, TaskID]);
    varDataTemp[iSelectCount+1]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 53, 2, 0,UserID, TaskID]);
    varDataTemp[iSelectCount+2]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 53, 24, ''''+UntCommandParam.CurrentDRSNO+'''',UserID, TaskID]);
    varDataTemp[iSelectCount+3]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 53, 25, UntCommandParam.CurrentR_DeviceID,UserID, TaskID]);
    varDataTemp[iSelectCount+4]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 53, 54, CDSDRSParam.FieldByName('P0X35_01').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+5]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 53, 53, CDSDRSParam.FieldByName('P0X35_02').Value,UserID, TaskID]);

    iSelectCount := iSelectCount+6;
  end;
  if cb0X36.Checked then
  begin
    TaskID := Dm_Mts.TempInterface.GetTheSequenceId('mtu_taskid');

    Result := SendCommand54(TaskID, UntCommandParam.CurrentCityID, UntCommandParam.Current_DRSID,
                            UntCommandParam.CurrentR_DeviceID, UntCommandParam.CurrentDRSType, UserID,
                            CDSDRSParam.FieldByName('P0X36_01').Value, CDSDRSParam.FieldByName('P0X36_02').Value,
                            UntCommandParam.CurrentDRSNO);


    varDataTemp[iSelectCount]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 54, 1, UntCommandParam.CurrentDRSType,UserID, TaskID]);
    varDataTemp[iSelectCount+1]:=  VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 54, 2, 0,UserID, TaskID]);
    varDataTemp[iSelectCount+2]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 54, 24, ''''+UntCommandParam.CurrentDRSNO+'''',UserID, TaskID]);
    varDataTemp[iSelectCount+3]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 54, 25, UntCommandParam.CurrentR_DeviceID,UserID, TaskID]);
    varDataTemp[iSelectCount+4]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 54, 77, CDSDRSParam.FieldByName('P0X36_01').Value,UserID, TaskID]);
    varDataTemp[iSelectCount+5]:=   VarArrayOf([1,4,3, UntCommandParam.Current_DRSID, 54, 78, CDSDRSParam.FieldByName('P0X36_02').Value,UserID, TaskID]);

    iSelectCount := iSelectCount+6;
  end;

  if iSelectCount>0 then
  begin
//    iSelectCount := iSelectCount+1;
    varData := VarArrayCreate([0, iSelectCount+1], varVariant);
    for I := 1 to iSelectCount do
    begin
      varData[I] := varDataTemp[I-1];
    end;
    varData[0]:= VarArrayOf([1,4,5, UntCommandParam.Current_DRSID]);
    varData[iSelectCount+1]:=  VarArrayOf([1,4,4, UntCommandParam.Current_DRSID]);



    Result := Dm_MTS.TempInterface.ExecBatchSQL(varData);
  end;

end;

end.
