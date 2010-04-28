unit Ut_Flowtache_Monitor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, DBGrids, Buttons,StrUtils,
  Ut_ClearFlowTacheThread,Ut_SynchronizeDataThread, UntAlarmRingThread,
  CheckLst,Ut_common, UntBreakSiteThread, Spin, UntRepAlarmThread, UntAlarmMonitorViewThread;

type
  TDoWhatWork = Record
    RepStatSign,
    ClearLogSign ,
    DayReportSign : Boolean;
  end;
  TPopTable = class
    ID :Integer;
    Name : String;
    IfEffect :integer;
  end;

  TCollect_Info = record
    CollectKind : integer;
    IsCreate : integer;
    CollectState : integer;
    CollectionCYC : integer;
  end;

  TFm_FlowMonitor = class(TForm)
    RunLog_Timer: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    GroupBox6: TGroupBox;
    Bt_RepStat: TButton;
    Bt_FlowLog: TButton;
    Bt_ItemCompute: TButton;
    Bt_AlarmReSend: TButton;
    bt_BreakSite: TButton;
    Btn_POP: TButton;
    GroupBox4: TGroupBox;
    GroupBox1: TGroupBox;
    Label9: TLabel;
    Dtp_RepStatTime: TDateTimePicker;
    Bt_SaveRepSet: TButton;
    Cb_IsAutoStat: TCheckBox;
    Bt_Immediately: TButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Btn_Save: TButton;
    edtClearDay: TEdit;
    CB_AutoClear: TCheckBox;
    DTP_ClearTime: TDateTimePicker;
    GroupBox5: TGroupBox;
    cbBreakState: TCheckBox;
    Gb_in_phase: TGroupBox;
    cbAlarmRing: TCheckBox;
    btAlarmRing: TButton;
    GroupBox2: TGroupBox;
    Label21: TLabel;
    Label23: TLabel;
    Label26: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Et_LAST_DATASOURCE: TEdit;
    Et_TableName: TEdit;
    DBGrid1: TDBGrid;
    Bt_EditDbConn: TButton;
    Bt_NewDbConn: TButton;
    Bt_Append: TButton;
    Bt_Delete: TButton;
    Bt_Refrash: TButton;
    Bt_Update: TButton;
    Et_CityID: TEdit;
    Ed_COLLECTIONKIND: TEdit;
    Ed_COLLECTIONCODE: TEdit;
    Et_Remark: TEdit;
    Label22: TLabel;
    Et_COLLECTIONNAME: TEdit;
    GB_poptable: TGroupBox;
    clb_poptable: TCheckListBox;
    GroupBox7: TGroupBox;
    P_Sync: TLabel;
    Btn_PopSet: TButton;
    CB_Pop: TCheckBox;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DBGrid2: TDBGrid;
    Se_CollectionCyc: TSpinEdit;
    Et_COLLECTNAME: TEdit;
    Edit1: TEdit;
    Bt_UpdCfg: TButton;
    Bt_RefCfg: TButton;
    Rg_ISCREATE: TRadioGroup;
    Rg_COLLECTSTATE: TRadioGroup;
    Timer1: TTimer;
    Label24: TLabel;
    Label25: TLabel;
    Se_Sleep: TSpinEdit;
    Label27: TLabel;
    Ed_NetAddress: TEdit;
    Button3: TButton;
    btBreakState: TButton;
    bt_AlarmRing: TButton;
    GroupBox8: TGroupBox;
    cbAlarmAdjust: TCheckBox;
    Button1: TButton;
    btAlarmAdjust: TButton;
    eAlarmAdjust: TEdit;
    Label8: TLabel;
    GroupBox9: TGroupBox;
    cbAlarmMonitorView: TCheckBox;
    Button2: TButton;
    btAlarmView: TButton;
    procedure Btn_SaveClick(Sender: TObject);
    procedure edtClearDayKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RunLog_TimerTimer(Sender: TObject);
    procedure Bt_ImmediatelyClick(Sender: TObject);
    procedure Bt_SaveRepSetClick(Sender: TObject);
    procedure Cb_IsAutoStatClick(Sender: TObject);
    procedure Btn_PopSetClick(Sender: TObject);

    procedure btAlarmRingClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Bt_RefrashClick(Sender: TObject);
    procedure Bt_UpdateClick(Sender: TObject);
    procedure Bt_EditDbConnClick(Sender: TObject);
    procedure Bt_NewDbConnClick(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure Bt_RefCfgClick(Sender: TObject);
    procedure Bt_UpdCfgClick(Sender: TObject);
    procedure CB_PopClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btBreakStateClick(Sender: TObject);
    procedure bt_BreakSiteClick(Sender: TObject);
    procedure bt_AlarmRingClick(Sender: TObject);
    procedure btAlarmAdjustClick(Sender: TObject);
    procedure eAlarmAdjustKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure btAlarmViewClick(Sender: TObject);
  private
    { Private declarations }
    Collect_Info:array of TCollect_Info;

    VToday, VTomorrow : TDate;
    Vprevious, VCurrTime :TDatetime;
    //POP ͬ��������������
    ScheCYC:Integer;
    CollectionKind_POP,CollectionKind_Interface : integer;

    function JudgeTheRepIfStat(Statkind:integer; Stateddate:TDatetime):boolean;
    procedure InitSetting;
    procedure SaveSet(Time : TDateTime;day,kind: String);
    Function SavePublicParamSet(SetValues:String; Code, Kind: integer):boolean;

    function  CheckThread(athread: TThread): Integer;
    procedure ResumeSynchronize();
    procedure refrashSynchronizePath();

    procedure refrashSynchronizeConfig();
    function  GetMaxCode(CollectKind:integer):integer;
    procedure InitPopTable;
    procedure UpdatePopTable(flag,cityid:integer);
    procedure DestroyPopTable;
  public
    { Public declarations }
    DoWhatWork : TDoWhatWork;
    FlowTacheThread :TClearFlowTacheThread;
    SynchronizeDataThread :TSynchronizeDataThread;
    BreakSiteThread: TBreakSiteThread;
    AlarmMonitorViewThread: TAlarmMonitorViewThread;
    AlarmRingThread: TAlarmRingThread;
    RepAlarmThread: TRepAlarmThread;
  end;

var
  Fm_FlowMonitor: TFm_FlowMonitor;

implementation
uses Ut_Data_Local,Ut_Main_Build, Ut_RunLog, Ut_Collection_Data;
{$R *.dfm}      

procedure TFm_FlowMonitor.FormShow(Sender: TObject);
begin
  PageControl1.TabIndex := 0;
  ScheCYC := 0;

  //POP��ͬ��
  InitPopTable;   
  with Dm_Collect_Local.ADO_SynchronizePOP do
  begin
    close;
    open
  end;

  //ͬ���̲߳�������
  ResumeSynchronize;
  with Fm_Main_Build_Server do
  begin
    FlowTacheThread := TClearFlowTacheThread.Create(ConnectionString);
    FlowTacheThread.FreeOnTerminate:=false;
  end;

  Fm_Main_Build_Server.InitPublicVariable();
  InitSetting;
  VToday:=Date-1;
  VTomorrow:=VToday;

  //���Դ���
  VPrevious:=now;
  //startdate:= date-strtoint(Dm_Collect_Local.PublicParam.DayReport_Day);

  with FlowTacheThread.DoWhat do
  begin
     ifRepStat:=false;
     ifDayReport:=false;
     ifClearLog:=false;
  end;

  with DoWhatWork do
  begin
     RepStatSign := JudgeTheRepIfStat(1, date);
     ClearLogSign := true;
  end;
  RunLog_Timer.Enabled := True;
end;

procedure TFm_FlowMonitor.Btn_SaveClick(Sender: TObject);
var isAutoStat:string;
begin
  if CB_AutoClear.Checked then
     isAutoStat:='1'
  else
     isAutoStat:='0';
  if Trim(edtClearDay.Text)='' then
  begin
      Application.MessageBox('��Ϣ��ȫ!','��ʾ',mb_ok);
      Exit;
  end;
  SavePublicParamSet(isAutoStat,3,9);
  SaveSet(DTP_ClearTime.Time,edtClearDay.Text,'9');

end;

procedure TFm_FlowMonitor.edtClearDayKeyPress(Sender: TObject;
  var Key: Char);
begin
    if not (key in ['0'..'9', #8]) then
    begin
        Key := #0;
    end;
end;

procedure TFm_FlowMonitor.InitSetting;
begin
    DTP_ClearTime.Time := StrToDateTime(Dm_Collect_Local.PublicParam.ClearLog_Time);
    edtClearDay.Text := Dm_Collect_Local.PublicParam.ClearLog_Day;
    if Trim(Dm_Collect_Local.PublicParam.IsAutoClearLog) = '1' then
        CB_AutoClear.Checked := true
    else
        CB_AutoClear.Checked := false;

    Dtp_RepStatTime.Time := StrToTime(Dm_Collect_Local.PublicParam.RepStatTime);
    if Trim(Dm_Collect_Local.PublicParam.IsAutoStatRep) = '1' then
        Cb_IsAutoStat.Checked := true
    else
        Cb_IsAutoStat.Checked := false;
end;

function TFm_FlowMonitor.JudgeTheRepIfStat(Statkind:integer; Stateddate:TDatetime):boolean;
begin
  with Dm_Collect_Local.Ado_Dynamic do
  begin
    close;
    sql.Clear;
    sql.Add('select issucceed from Alarm_stated_Record where Statkind = :Statkind and Stateddate = :Stateddate');
    Parameters.parambyname('Statkind').Value:=Statkind;
    Parameters.parambyname('Stateddate').Value:=Stateddate;
    open;
    if IsEmpty then
       Result:=IsEmpty
    else
       if fieldbyname('issucceed').AsInteger=1 then
          Result:=false
       else
          Result:=true;
    close;
  end;
end;

function TFm_FlowMonitor.CheckThread(athread: TThread): Integer;
var
    i: DWord;
    IsQuit: Boolean;
begin
  try
    if Assigned(aThread) then
     begin
       //ִ�гɹ�����true���˳��뱻iָ���ڴ��¼
       IsQuit := GetExitCodeThread(aThread.Handle, i);
       if IsQuit then
       begin
         // STILL_ACTIVE :�߳���Ȼ��ִ��
         if i = STILL_ACTIVE then
           Result := 1
         else
           Result := 2;              //aThreadδFree����ΪTthread.Destroy����ִ�����
       end
       else
         Result := 0;                //������GetLastErrorȡ�ô������
     end
     else
       Result := 3;

  except
    Result := 3;
    Fm_RunLog.Re_RunLog.Lines.Add('CheckThread ...... ');
  end;
end;

procedure TFm_FlowMonitor.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   AllowExit : Boolean;
   StatTargetSign, FlowTacheSign : Boolean;
   execcount:integer;
begin
   RunLog_Timer.Enabled := false;
   AllowExit:=false;
   StatTargetSign :=false;
   FlowTacheSign :=false;
   execcount:=0;
   while not AllowExit do
   begin
     with FlowTacheThread do
     case CheckThread(FlowTacheThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
            FlowTacheSign :=true;
          end;
     end;

     //ͬ��Pop
     CB_Pop.Checked := false;
     with SynchronizeDataThread do
     case CheckThread(SynchronizeDataThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
          end;
     end;

     //��վ��
     cbBreakState.Checked := false;
     with BreakSiteThread do
     case CheckThread(BreakSiteThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
          end;
     end;

     //�澯��ع̻���ͼ
     cbAlarmMonitorView.Checked := false;
     with AlarmMonitorViewThread do
     case CheckThread(AlarmMonitorViewThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
          end;
     end;

     //�¸澯����
     cbAlarmRing.Checked := false;
     with AlarmRingThread do
     case CheckThread(AlarmRingThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
          end;
     end;

     //�澯����
     cbAlarmAdjust.Checked := false;
     with RepAlarmThread do
     case CheckThread(RepAlarmThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
          end;
     end;

     AllowExit:= FlowTacheSign;
     application.ProcessMessages;
     inc(execcount);
     if (execcount>10000) and (not AllowExit) then
     try
        if not FlowTacheSign then
           FlowTacheThread.Free;
     except
     end;
   end;
   DestroyPopTable; 
end;

procedure TFm_FlowMonitor.SaveSet(Time : TDateTime;day,Kind: String);
var
  sqlstr : String;
begin
    if Trim(edtClearDay.Text)= '' then
    begin
        Application.MessageBox('��Ϣ��ȫ!','��ʾ',mb_ok);
        Exit;
    end;
    with Dm_Collect_Local.Ado_Dynamic do
    begin
        Close;
        SQL.Clear;
        sqlstr :='Update alarm_sys_function_set set setvalue = '''+FormatDateTime('hh:mm',Time)+''' where code = 1 and kind = '+Kind;
        SQL.Add(sqlstr);
        try
          ExecSQL;
          Close;
          SQL.Clear;
          sqlstr :='Update alarm_sys_function_set set setvalue = '''+Trim(Day)+''' where code = 2 and kind = '+Kind;
          SQL.Add(sqlstr);
          ExecSQL;
          Application.MessageBox('�������óɹ�!','��ʾ',mb_ok);
        except
          Application.MessageBox('��������ʧ��!','��ʾ',mb_ok);
        end;
    end;
end;

procedure TFm_FlowMonitor.RunLog_TimerTimer(Sender: TObject);
begin
  Inc(ScheCYC);
  VTomorrow:=Date();

  //���Դ���
  VCurrTime:=now;
  if (VCurrTime<Vprevious) or (VCurrTime>Vprevious+90/(3600*24)) then
    Fm_RunLog.Re_RunLog.Lines.Add('������Ϣ��ϵͳ̽�⵽Ӧ��ʱ���п��ܱ���Ϊ���ģ�Vprevious-<'+datetimetostr(Vprevious)+'>����VCurrTime-<'+datetimetostr(VCurrTime)+'>������Timer1.IntervalֵΪ��'+inttostr(Timer1.Interval));
  Vprevious:=VCurrTime;

  with Dm_Collect_Local.PublicParam, DoWhatWork do
  begin
    if VToday<>VTomorrow then //�µ�һ�쿪ʼ������ִ�б�־��Ϊ�������߳�ִ�к󣬱�־��Ϊ������
    begin
      //����һ��Ϊ���Դ��룬���Ա����Ƿ�����ȷͳ�ƣ��������ɾ��
      Fm_RunLog.Re_RunLog.Lines.Add('������Ϣ������VToday-<'+datetostr(VToday)+'>����VTomorrow-<'+datetostr(VTomorrow)+'>');

      VToday:=VTomorrow;
      ScheCYC:=0;
      { //���ε��жϴ洢���̻��ж�
      try
      //RepStatSign := JudgeTheRepIfStat(1, date);
      RepStatSign := JudgeTheRepIfStat(1, VToday);
      except
        on E :Exception do
        Fm_RunLog.Re_RunLog.Lines.Add('Vtoday = '+DateTimeToStr(VToday)+' ������Ϣ��JudgeTheRepIfStat ִ���쳣--'+E.Message);
      end;
      

      //��������Ϊ���Դ��룬���Ա����Ƿ�����ȷͳ�ƣ��������ɾ��
      if not RepStatSign then
        Fm_RunLog.Re_RunLog.Lines.Add('������'+datetimetostr(now)+'/'+datetimetostr(Dm_Collect_Local.GetSysDateTime)+'�����Ѵ��ڣ���ȡ��ִ�У�');
      }
      RepStatSign := true;
      //Fm_RunLog.Re_RunLog.Lines.Add('������Ϣ������������ʾ��ԭ���õı���ͳ��ʱ��-<'+RepStatTime+'>����ʱ���ʽ����-<'+FormatDateTime('hh:mm',Now)+'>');
      ClearLogSign := true;
    end;
    //����������������������߳�ִ�У�
    //1��ʱ���Ѿ�����  2����������ִ�б�־Ϊ��  3����������У�Կ�ѡ��  4�������߳̿���
    if (FormatDateTime('hh:mm',Now)>=RepStatTime) and RepStatSign and Cb_IsAutoStat.Checked then
    begin
       FlowTacheThread.DoWhat.ifRepStat:=true;
       RepStatSign:=false;
    end;

    if (FormatDateTime('hh:mm',Now)>=ClearLog_Time) and ClearLogSign and CB_AutoClear.Checked then
    begin
       FlowTacheThread.DoWhat.ifClearLog:=true;
       ClearLogSign:=false;
    end;

    with FlowTacheThread.DoWhat do
    if (ifRepStat or ifClearLog) and FlowTacheThread.Suspended  then
       FlowTacheThread.Resume;

    //ͬ��POP
    if CB_Pop.Checked and (ScheCYC mod cb_pop.Tag = 0) and (SynchronizeDataThread<>nil) then
    SynchronizeDataThread.Resume;

    //��վ��
    if cbBreakState.Checked and (ScheCYC mod cbBreakState.Tag = 0) and (BreakSiteThread<>nil) then
    BreakSiteThread.ResumeThread;

    //�澯��ع̻���ͼ
    if cbAlarmMonitorView.Checked and (ScheCYC mod cbAlarmMonitorView.Tag = 0) and (AlarmMonitorViewThread<>nil) then
    AlarmMonitorViewThread.ResumeThread;

    //�¸澯����
    if cbAlarmRing.Checked and (ScheCYC mod cbAlarmRing.Tag = 0) and (AlarmRingThread<>nil) then
    AlarmRingThread.ResumeThread;  

    //�澯����
    if cbAlarmAdjust.Checked and (ScheCYC mod cbAlarmAdjust.Tag = 0) and (RepAlarmThread<>nil) then
    RepAlarmThread.ResumeThread;

  end;

  if Fm_Main_Build_Server.Findform('Fm_RunLog',false) then
  with Fm_RunLog do   //����������־��ʵʱ��Ϣ��־
  begin
    if Re_RunLog.Lines.Count>10000 then
       SaveRunLog(Re_RunLog,'RunLog');
    if Message_Log.Lines.Count>10000 then
       SaveRunLog(Message_Log,'MsgLog');
  end;
end;

procedure TFm_FlowMonitor.Bt_ImmediatelyClick(Sender: TObject);
var sqlstr:string;
begin
   sqlstr:='select repdate as RecCount from alarm_rep_online where to_char(repdate,'+'''';
   sqlstr:=sqlstr+'YYYY-MM-DD'+''''+')=to_char( :today ,'+''''+'YYYY-MM-DD'+''''+')';
   with Dm_Collect_Local.Ado_Dynamic do
   begin
      close;
      sql.Clear;
      sql.Add(sqlstr);
      Parameters.ParamByName('today').Value:=Dm_Collect_Local.GetSysDateTime;
      open;
      //if fieldbyname('RecCount').AsInteger>=0 then
      if recordcount>0 then
      begin
         Application.MessageBox('�����������ͳ�ƣ������ظ��Ե������ݽ���ͳ��!','��ʾ',mb_ok+mb_defbutton1);
         close;
         exit;
      end;
      close;
   end;
   if FlowTacheThread.Suspended then
   begin
     FlowTacheThread.DoWhat.ifRepStat:=true;
     FlowTacheThread.Resume;
   end else
     Application.MessageBox('ͳ���߳�����æµ�У������ĵȴ�!','��ʾ',mb_ok+mb_defbutton1);
end;

procedure TFm_FlowMonitor.Bt_SaveRepSetClick(Sender: TObject);
var isAutoStat:string;
begin
  if Cb_IsAutoStat.Checked then
     isAutoStat:='1'
  else
     isAutoStat:='0';
  if SavePublicParamSet(FormatDateTime('hh:mm',Dtp_RepStatTime.Time),1,6) and SavePublicParamSet(isAutoStat,2,6) then
  begin
     Application.MessageBox('<���ϱ���ͳ�Ʋ�������>�������óɹ�!','��ʾ',mb_ok);
     Dm_Collect_Local.PublicParam.RepStatTime := FormatDateTime('hh:mm',Dtp_RepStatTime.Time);
     Dm_Collect_Local.PublicParam.IsAutoStatRep := isAutoStat;
  end else
     Application.MessageBox('<���ϱ���ͳ�Ʋ�������>��������ʧ��!','��ʾ',mb_ok);
end;


procedure TFm_FlowMonitor.Cb_IsAutoStatClick(Sender: TObject);
begin
    with DoWhatWork, FlowTacheThread.DoWhat do
    if not (sender as TCheckBox).Checked then
    case (sender as TCheckBox).tag of
     1 : begin
           ifRepStat:=false;
           RepStatSign:=false;
         end;
     2 : begin
           ifDayReport:=false;
           DayReportSign:=false;
         end;
     3 : begin
           ifClearLog:=false;
           ClearLogSign:=false;
         end;
    end;
end;


procedure TFm_FlowMonitor.Btn_PopSetClick(Sender: TObject);
var
  iAuto : Integer;
  sqlstr :String;
begin
    if CB_Pop.Checked then
      iAuto := 1
    else
      iAuto :=0;
    with Dm_Collect_Local.Ado_Dynamic do
    begin
      Close;
      SQL.Clear;
      sqlstr :='update Alarm_Collection_Config set Collectstate=:Collectstate ,lastmodify = sysdate where collectkind = 12';
      SQL.Add(sqlstr);
      Parameters.ParamByName('Collectstate').Value:= iAuto;
      try
        ExecSQL;
        Application.MessageBox('POP����ͬ���������óɹ�!','��ʾ',mb_ok);
      except
        Application.MessageBox('POP����ͬ����������ʧ��!','��ʾ',mb_ok);
      end;
    end;
end;

procedure TFm_FlowMonitor.refrashSynchronizePath;
var
  cityid:string;
  iHave,i : integer;
begin
  with Dm_Collect_Local.ADO_SynchronizePOP do
  if Active then
  begin
    CollectionKind_POP:=fieldbyname('CollectionKind').AsInteger;
    Ed_COLLECTIONKIND.Text:=inttostr(CollectionKind_POP);
    Ed_COLLECTIONCODE.Text:=fieldbyname('COLLECTIONCODE').AsString;
    cityid :=fieldbyname('CityID').AsString;
    Et_CityID.Text:=cityid;
    Et_LAST_DATASOURCE.Text:=fieldbyname('LAST_DATASOURCE').AsString;
    Et_CollectionName.Text:=fieldbyname('CollectionName').AsString;
    Et_TableName.Text:=fieldbyname('TableName').AsString;
    Et_Remark.Text:=fieldbyname('Remark').AsString;
    Ed_NetAddress.Text := FieldByName('INCREMENT_COLUMN').AsString;
    for i :=0 to clb_poptable.Count-1 do
      clb_poptable.Checked[i]:=false;
    with Dm_Collect_Local.Ado_Dynamic do
    begin
       Close;
       SQL.Clear;
       SQL.Add('select diccode,dicname from alarm_dic_code_info where dictype = 16 and ifineffect=1 and cityid ='+cityid);
       Open;
       if RecordCount > 0 then
       begin
         first; iHave :=-1;
         while not eof do
         begin
            for i :=0 to clb_poptable.Count-1 do
            begin
              if TPopTable(clb_poptable.Items.Objects[i]).ID =  Dm_Collect_Local.Ado_Dynamic.FieldByName('diccode').AsInteger then
                iHave := i;
            end;
            //iHave := clb_poptable.Items.IndexOf(Dm_Collect_Local.Ado_Dynamic.FieldByName('dicname').AsString);
            if iHave <>-1 then
              clb_poptable.Checked[iHave] := true;
            Next;
         end;
       end;
    end;
  end;
end;

procedure TFm_FlowMonitor.DBGrid1CellClick(Column: TColumn);
begin
  refrashSynchronizePath;
end;

procedure TFm_FlowMonitor.Bt_RefrashClick(Sender: TObject);
begin
  with Dm_Collect_Local.ADO_SynchronizePOP do
  begin
     close;
     open;
     first;
     refrashSynchronizePath();
  end;
end;

procedure TFm_FlowMonitor.Bt_UpdateClick(Sender: TObject);
var button : tButton;
begin
  button:=sender as TButton;
  with Dm_Collect_Local.ADO_SynchronizePOP do
  if active then
  begin
    try
      case button.Tag of
      1:
        begin
          if Trim(Et_CityID.Text)='' then
          begin
            application.MessageBox('��������б��','��ʾ',mb_ok+mb_defbutton1);
            Exit;
          end;
          Edit;
          fieldbyname('CollectionKind').AsInteger:=CollectionKind_POP;
          fieldbyname('COLLECTIONCODE').AsString:=Ed_COLLECTIONCODE.Text;
          fieldbyname('CityID').AsString:=Et_CityID.Text;
          fieldbyname('LAST_DATASOURCE').AsString:=Et_LAST_DATASOURCE.Text;
          fieldbyname('CollectionName').AsString:=Et_CollectionName.Text;
          fieldbyname('TableName').AsString:=Et_TableName.Text;
          fieldbyname('Remark').AsString:=Et_Remark.Text;
          fieldbyname('OperTime').AsDateTime:=now;
          fieldbyname('Operator').AsString:=Dm_Collect_Local.Operator;
          fieldByName('INCREMENT_COLUMN').AsString := Ed_NetAddress.Text;
          post;
          UpdatePopTable(1,StrToInt(Trim(Et_CityID.Text)));
        end;
      2:
        begin
          UpdatePopTable(2,fieldbyname('CityID').AsInteger);
          delete;
        end;
      3:
        if CollectionKind_POP=0 then
        begin
          application.MessageBox('��ѡ����Ҫ�����Ƶļ�¼��Ȼ���ٵ������ť��','��ʾ',mb_ok+mb_defbutton1);
          exit;
        end else
        begin
          append;
          fieldbyname('collectionkind').AsInteger:=CollectionKind_POP;
          fieldbyname('CollectionCode').AsInteger:=GetMaxCode(CollectionKind_POP)+1;
          fieldbyname('CityID').AsString:=Et_CityID.Text;
          fieldbyname('LAST_DATASOURCE').AsString:=Et_LAST_DATASOURCE.Text;
          fieldbyname('CollectionName').AsString:=Et_CollectionName.Text;
          fieldbyname('TableName').AsString:=Et_TableName.Text;
          fieldbyname('Remark').AsString:=Et_Remark.Text;
          fieldbyname('OperTime').AsDateTime:=now;
          fieldbyname('Operator').AsString:=Dm_Collect_Local.Operator;
          fieldByName('INCREMENT_COLUMN').AsString := Ed_NetAddress.Text;
          post;
        end;
      end;
      application.MessageBox('�����ɹ�','��ʾ',mb_ok+mb_defbutton1);
    finally
      close;
      open;
    end; //try
  end;   //if
end;

function TFm_FlowMonitor.GetMaxCode(CollectKind: integer): integer;
var
   SltSQL:string;
begin
   SltSQL:='select collectioncode from alarm_collection_cyc_list where collectionkind=:kind order by collectioncode desc';
   with Dm_Collect_Local.Ado_Dynamic do
   begin
      close;
      sql.Clear;
      sql.Add(SltSQL);
      Parameters.ParamByName('kind').Value:= CollectKind;
      open;
      Result:=fieldbyname('collectioncode').asinteger;
      close;
   end;
end;

procedure TFm_FlowMonitor.Bt_EditDbConnClick(Sender: TObject);
begin
   Et_LAST_DATASOURCE.Text:= Dm_Collect_Local.ConfigDBConn(false,Et_LAST_DATASOURCE.Text);
end;

procedure TFm_FlowMonitor.Bt_NewDbConnClick(Sender: TObject);
begin
  Et_LAST_DATASOURCE.Text:=Dm_Collect_Local.ConfigDBConn();
end;
//��ʼ��POP����Ҫͬ���ı�
procedure TFm_FlowMonitor.InitPopTable;
var
  poptable :TPopTable;
begin
  clb_poptable.Clear;

  poptable :=TPopTable.Create;
  poptable.ID :=1;
  poptable.Name :='alarm_dic_code_info';
  clb_poptable.AddItem(poptable.Name,poptable);

  poptable :=TPopTable.Create;
  poptable.ID :=3;
  poptable.Name :='pop_area';
  clb_poptable.AddItem(poptable.Name,poptable);
  
  poptable :=TPopTable.Create;
  poptable.ID :=5;
  poptable.Name :='pop_cstype';
  clb_poptable.AddItem(poptable.Name,poptable);   

  poptable :=TPopTable.Create;
  poptable.ID :=9;
  poptable.Name :='pop_cslevel';
  clb_poptable.AddItem(poptable.Name,poptable);
  poptable :=TPopTable.Create;

  poptable.ID :=10;
  poptable.Name :='pop_status';
  clb_poptable.AddItem(poptable.Name,poptable);
  poptable :=TPopTable.Create;

  poptable.ID :=11;
  poptable.Name :='pop_powertype';
  clb_poptable.AddItem(poptable.Name,poptable);
  poptable :=TPopTable.Create;

  poptable.ID :=12;
  poptable.Name :='fms_device_info';
  clb_poptable.AddItem(poptable.Name,poptable);
  poptable :=TPopTable.Create;

  poptable.ID :=13;
  poptable.Name :='fms_cell_device_info';
  clb_poptable.AddItem(poptable.Name,poptable); 
end;

procedure TFm_FlowMonitor.DestroyPopTable;
var
  i : integer;
begin
  for i:=0 to clb_poptable.Count-1 do
    TPopTable(clb_poptable.Items.Objects[i]).Free;
  clb_poptable.Clear;
end;

procedure TFm_FlowMonitor.UpdatePopTable(flag,cityid: integer);
var
  i :integer;
  sqlstr :String;
begin
  //��ӻ����
  if flag = 1 then
  begin
    sqlstr := 'select diccode, dictype, dicname, dicorder, ifineffect,  parentid, cityid from alarm_dic_code_info where dictype = 16 and cityid ='+IntToStr(cityid) ;
    with Dm_Collect_Local.Ado_Dynamic do
    begin
      close;
      sql.Clear;
      sql.Add(sqlstr);
      open;
      for i := 0 to clb_poptable.Count-1 do
      begin
        if Locate('diccode',TPopTable(clb_poptable.Items.Objects[i]).ID,[]) then
        begin
          Edit;
          if clb_poptable.Checked[i] then
            FieldByName('ifineffect').AsInteger :=1
          else
            FieldByName('ifineffect').AsInteger :=0;
          Post;
        end
        else
        begin
          Append;
          FieldByName('diccode').AsInteger := TPopTable(clb_poptable.Items.Objects[i]).ID;
          FieldByName('dictype').AsInteger := 16;
          FieldByName('dicname').AsString := TPopTable(clb_poptable.Items.Objects[i]).Name;
          FieldByName('dicorder').AsInteger :=1;
          if clb_poptable.Checked[i] then
            FieldByName('ifineffect').AsInteger :=1
          else
            FieldByName('ifineffect').AsInteger :=0;
          FieldByName('parentid').AsInteger :=-1;
          FieldByName('cityid').AsInteger :=cityid;
          Post;
        end;
      end;
      Close;
    end;
  end
  else
  begin
    sqlstr := 'delete from alarm_dic_code_info where dictype = 16 and cityid ='+inttostr(cityid);
    with Dm_Collect_Local.Ado_Dynamic do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      ExecSQL;
    end;
  end;
end;

procedure TFm_FlowMonitor.refrashSynchronizeConfig;
begin
  with Dm_Collect_Local.Ado_Synchronize_Cfg do
  if Active then
  begin
    Et_COLLECTNAME.Text:=fieldbyname('COLLECTNAME').asstring;
    Rg_ISCREATE.ItemIndex:=fieldbyname('ISCREATE').AsInteger;
    Rg_COLLECTSTATE.ItemIndex:=fieldbyname('COLLECTSTATE').AsInteger;
    Se_CollectionCyc.Value:= fieldbyname('CollectionCyc').AsInteger;
    Et_Remark.Text:=fieldbyname('Remark').AsString;
    Se_Sleep.Text:=fieldbyname('Collectorder').AsString;
  end;
end;

procedure TFm_FlowMonitor.DBGrid2CellClick(Column: TColumn);
begin
  refrashSynchronizeConfig;
end;

procedure TFm_FlowMonitor.Bt_RefCfgClick(Sender: TObject);
begin
  with Dm_Collect_Local.Ado_Synchronize_Cfg do
  begin
    close;
    open;
    first;
    refrashSynchronizeConfig();
  end;
end;

procedure TFm_FlowMonitor.Bt_UpdCfgClick(Sender: TObject);
begin
  try
    with Dm_Collect_Local.Ado_Synchronize_Cfg do
    begin
      if not Active then exit;
      Edit;
      fieldbyname('COLLECTNAME').asstring:=Et_COLLECTNAME.Text;
      fieldbyname('ISCREATE').AsInteger:=Rg_ISCREATE.ItemIndex;
      fieldbyname('COLLECTSTATE').AsInteger:=Rg_COLLECTSTATE.ItemIndex;
      fieldbyname('CollectionCyc').AsInteger:=Se_CollectionCyc.Value;
      fieldbyname('Remark').AsString:=Et_Remark.Text;
      fieldbyname('Collectorder').AsString:=Se_Sleep.Text;
      Post;
    end;
    application.MessageBox('�����ɹ���','��ʾ',mb_ok+mb_defbutton1);
  except
    application.MessageBox('����ʧ�ܣ�','��ʾ',mb_ok+mb_defbutton1);
  end;         
end;

procedure TFm_FlowMonitor.ResumeSynchronize;
var
  i:integer;
begin
  with Dm_Collect_Local do
  begin
    with Ado_Synchronize_Cfg do
    begin
      close;
      open;
      if not Active then
      begin
        application.MessageBox('ͬ�����ݼ�û�м������ϵͳ�����Գ��ָ���ʾ������ϵ����Ա�����','��ʾ',mb_ok+mb_defbutton1);
        exit;
      end;
      if IsEmpty then
      begin
        application.MessageBox('ϵͳ̽�⵽��ͬ���̲߳���������Ϊ�գ�����������ء�ͬ���̲߳��������ݣ�����������ͬ������','��ʾ',mb_ok+mb_defbutton1);
        exit;
      end;
      SetLength(Collect_Info, RecordCount);
      first;  i:=0;
      while not eof do
      with Collect_Info[i] do
      begin
        CollectKind := fieldbyname('CollectKind').AsInteger;
        IsCreate := fieldbyname('IsCreate').AsInteger;
        CollectState := fieldbyname('CollectState').AsInteger;
        CollectionCYC := fieldbyname('CollectionCYC').AsInteger;
        inc(i);
        next;
      end;
    end;
  end;
  for i:=Low(Collect_Info) to High(Collect_Info) do
  with Collect_Info[i],Dm_Collect_Local do
  case CollectKind of
   12 : begin
          if (IsCreate = 1) and (SynchronizeDataThread=nil) then //ͬ��POP�߳�
          begin
             CB_Pop.Tag:=60 * CollectionCYC;
             SynchronizeDataThread :=TSynchronizeDataThread.Create(Fm_Main_Build_Server.ConnectionString);
             SynchronizeDataThread.FreeOnTerminate:=false;
          end;

          if CollectState=1 then
             CB_Pop.Checked:=true
          else
             CB_Pop.Checked := false;
          if SynchronizeDataThread <> nil then
            SynchronizeDataThread.bStop :=not CB_Pop.Checked;
        end;
   {15 :
    begin
      //if (IsCreate = 1) and (BreakSiteThread=nil) then //��վ��
      if BreakSiteThread=nil then //��վ��
      begin
         //cbBreakState.Tag:=60 * CollectionCYC;
         cbBreakState.Tag:=25;
         BreakSiteThread :=TBreakSiteThread.Create(Fm_Main_Build_Server.ConnectionString, Fm_RunLog.Re_RunLog, bt_BreakSite);
         BreakSiteThread.FreeOnTerminate:=false;
      end;

      cbBreakState.Checked:=true

     // if CollectState=1 then
       //  cbBreakState.Checked:=true
    //  else
        // cbBreakState.Checked := false;
    end;   }

    {16 :
    begin
      if (IsCreate = 1) and (AlarmRingThread=nil) then //�¸澯����
      begin
         cbAlarmRing.Tag:=60 * CollectionCYC;
         AlarmRingThread :=TAlarmRingThread.Create(Fm_Main_Build_Server.ConnectionString, Fm_RunLog.Re_RunLog, bt_AlarmRing);
         AlarmRingThread.FreeOnTerminate:=false;
      end;

      if CollectState=1 then
         cbAlarmRing.Checked:=true
      else
         cbAlarmRing.Checked := false;
    end;  }

  end;

 // 5 :
    begin
      //if (IsCreate = 1) and (BreakSiteThread=nil) then //��վ��
      if BreakSiteThread=nil then //��վ��
      begin
         //cbBreakState.Tag:=60 * CollectionCYC;
         cbBreakState.Tag:=25;
         BreakSiteThread :=TBreakSiteThread.Create(Fm_Main_Build_Server.ConnectionString, Fm_RunLog.Re_RunLog, bt_BreakSite);
         BreakSiteThread.FreeOnTerminate:=false;
      end;

      cbBreakState.Checked:=true;

    end;

      begin
      //if (IsCreate = 1) and (BreakSiteThread=nil) then //�澯��ع̻���ͼ
      if AlarmMonitorViewThread=nil then //�澯��ع̻���ͼ
      begin
         //cbBreakState.Tag:=60 * CollectionCYC;
         cbAlarmMonitorView.Tag:=60*2;
         AlarmMonitorViewThread :=TAlarmMonitorViewThread.Create(Fm_Main_Build_Server.ConnectionString, Fm_RunLog.Re_RunLog, btAlarmView);
         AlarmMonitorViewThread.FreeOnTerminate:=false;
      end;

      cbAlarmMonitorView.Checked:=true;

    end;



  //16 :
    begin
      if AlarmRingThread=nil then //�¸澯����
      begin
         cbAlarmRing.Tag:=45;
         AlarmRingThread :=TAlarmRingThread.Create(Fm_Main_Build_Server.ConnectionString, Fm_RunLog.Re_RunLog, bt_AlarmRing);
         AlarmRingThread.FreeOnTerminate:=false;
      end;


         cbAlarmRing.Checked:=true;
    
    end;

  //16 :
    begin
      if RepAlarmThread=nil then //�ظ��澯�ɼ�
      begin
         cbAlarmAdjust.Tag:=60*15;
         RepAlarmThread :=TRepAlarmThread.Create(Fm_Main_Build_Server.ConnectionString, Fm_RunLog.Re_RunLog, btAlarmAdjust);
         RepAlarmThread.FreeOnTerminate:=false;
      end;
         cbAlarmAdjust.Checked:=true;
    end;

end;

function TFm_FlowMonitor.SavePublicParamSet(SetValues: String; Code,
  Kind: integer): boolean;
var
  sqlstr : String;
begin
    with Dm_Collect_Local.Ado_Dynamic do
    begin
        Close;
        SQL.Clear;
        sqlstr :='Update alarm_sys_function_set set setvalue = :setvalue where code = :code and kind = :Kind';
        SQL.Add(sqlstr);
        Parameters.ParamByName('setvalue').Value:= SetValues;
        Parameters.ParamByName('code').Value:= Code ;
        Parameters.ParamByName('Kind').Value:= Kind ;
        try
          ExecSQL;
          Result:=true;
        except
          Result:=false;
        end;
        Close;
    end;
end;

procedure TFm_FlowMonitor.CB_PopClick(Sender: TObject);
begin
  if SynchronizeDataThread = nil then Exit;
  SynchronizeDataThread.bStop :=not CB_Pop.Checked;
end;

procedure TFm_FlowMonitor.Button3Click(Sender: TObject);
begin
  Fm_RunLog.Re_RunLog.Lines.Add('������Ϣ���˹�������������VToday-<'+datetostr(VToday)+'>����VTomorrow-<'+datetostr(VTomorrow)+'>');
end;

procedure TFm_FlowMonitor.btBreakStateClick(Sender: TObject);
var
  iAuto : Integer;
  sqlstr :String;
begin
    if cbBreakState.Checked then
      iAuto := 1
    else
      iAuto :=0;
    with Dm_Collect_Local.Ado_Dynamic do
    begin
      Close;
      SQL.Clear;
      sqlstr :='update Alarm_Collection_Config set Collectstate=:Collectstate ,lastmodify = sysdate where collectkind = 15';
      SQL.Add(sqlstr);
      Parameters.ParamByName('Collectstate').Value:= iAuto;
      try
        ExecSQL;
        Application.MessageBox('��վ��ͳ�Ʋ������óɹ�!','��ʾ',mb_ok);
      except
        Application.MessageBox('��վ��ͳ�Ʋ�������ʧ��!','��ʾ',mb_ok);
      end;
    end;
end;

procedure TFm_FlowMonitor.btAlarmRingClick(Sender: TObject);
var
  iAuto : Integer;
  sqlstr :String;
begin
    if cbBreakState.Checked then
      iAuto := 1
    else
      iAuto :=0;
    with Dm_Collect_Local.Ado_Dynamic do
    begin
      Close;
      SQL.Clear;
      sqlstr :='update Alarm_Collection_Config set Collectstate=:Collectstate ,lastmodify = sysdate where collectkind = 16';
      SQL.Add(sqlstr);
      Parameters.ParamByName('Collectstate').Value:= iAuto;
      try
        ExecSQL;
        Application.MessageBox('�¸澯���Ѳ������óɹ�!','��ʾ',mb_ok);
      except
        Application.MessageBox('�¸澯���Ѳ�������ʧ��!','��ʾ',mb_ok);
      end;
    end;
end;


procedure TFm_FlowMonitor.bt_BreakSiteClick(Sender: TObject);
begin
  if BreakSiteThread=nil then exit;
   BreakSiteThread.ResumeThread;
end;

procedure TFm_FlowMonitor.bt_AlarmRingClick(Sender: TObject);
begin
  if AlarmRingThread=nil then exit;
   AlarmRingThread.ResumeThread;
end;

procedure TFm_FlowMonitor.btAlarmAdjustClick(Sender: TObject);
begin
  if RepAlarmThread=nil then exit;
    RepAlarmThread.ResumeThread;
end;

procedure TFm_FlowMonitor.eAlarmAdjustKeyPress(Sender: TObject; var Key: Char);
begin
    if not (key in ['0'..'9', #8]) then
    begin
        Key := #0;
    end;
end;

procedure TFm_FlowMonitor.Button1Click(Sender: TObject);
begin
  cbAlarmAdjust.Tag:=60*StrToInt(eAlarmAdjust.text);
end;

procedure TFm_FlowMonitor.btAlarmViewClick(Sender: TObject);
begin
  if AlarmMonitorViewThread=nil then exit;
    AlarmMonitorViewThread.ResumeThread;
end;

end.
