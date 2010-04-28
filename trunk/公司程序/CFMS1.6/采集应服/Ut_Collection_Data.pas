unit Ut_Collection_Data;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, ComCtrls, Spin,
  IdTCPConnection, IdTCPClient, IdBaseComponent, IdComponent, IdTCPServer,
  DBCtrls, dbcgrids, Buttons, ActnMan, ActnCtrls, ToolWin, DB, CheckLst,
  Ut_InteAttempCollect_Thread, Ut_AutoSendAlarm_Thread,
  ADODB,DateUtils, UntAlarmAdjustThread;

type
  TMyDBGrid=class(TDBGrid);

  TFm_Collection_Data = class(TForm)
    Timer_Scheduler: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    tsSourceSet: TTabSheet;
    GroupBox4: TGroupBox;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Et_LAST_DATASOURCE: TEdit;
    Et_TableName: TEdit;
    Et_Increment_Column: TEdit;
    DBGrid1: TDBGrid;
    GroupBox6: TGroupBox;
    Shape_DataCollect: TShape;
    Shape_AutoSend: TShape;
    Label11: TLabel;
    Label12: TLabel;
    Gb_DataCollect: TGroupBox;
    Sb_Dc_Start: TSpeedButton;
    Sb_Dc_Stop: TSpeedButton;
    Gb_AutoSend: TGroupBox;
    Sb_As_Start: TSpeedButton;
    Sb_As_Stop: TSpeedButton;
    Panel2: TPanel;
    Label8: TLabel;
    Label6: TLabel;
    Bt_DataCollect: TButton;
    Bt_AutoSend: TButton;
    btCDMART: TButton;
    Ed_DataCollect: TEdit;
    Ed_AutoSend: TEdit;
    gbCDMALX: TGroupBox;
    sbCDMALXStart: TSpeedButton;
    sbCDMALXStop: TSpeedButton;
    btCDMALX: TButton;
    Label4: TLabel;
    Ed_ZteRt: TEdit;
    Shape_ZTRT_2: TShape;
    Bt_EditDbConn: TButton;
    Bt_NewDbConn: TButton;
    Label16: TLabel;
    Ed_RealTime: TEdit;
    Bt_Append: TButton;
    Bt_Delete: TButton;
    TabSheet3: TTabSheet;
    DBGrid2: TDBGrid;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Se_CollectionCyc: TSpinEdit;
    Et_COLLECTNAME: TEdit;
    Et_Remark: TEdit;
    Bt_Refrash: TButton;
    Bt_Update: TButton;
    Bt_UpdCfg: TButton;
    Bt_RefCfg: TButton;
    Rg_ISCREATE: TRadioGroup;
    Rg_COLLECTSTATE: TRadioGroup;
    Label26: TLabel;
    Et_CityID: TEdit;
    Ed_COLLECTIONKIND: TEdit;
    Ed_COLLECTIONCODE: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Edit3: TEdit;
    Label22: TLabel;
    Et_COLLECTIONNAME: TEdit;
    Label25: TLabel;
    Se_SetValue: TSpinEdit;
    Label27: TLabel;
    Label28: TLabel;
    Se_DataBound: TSpinEdit;
    gbCDMART: TGroupBox;
    sbCDMARTStart: TSpeedButton;
    sbCDMARTStop: TSpeedButton;
    Shape1: TShape;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    cbDebugCDMAColl: TCheckBox;
    cbClearHis: TCheckBox;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Bt_UpdateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Sb_Rts_StartClick(Sender: TObject);
    procedure Timer_SchedulerTimer(Sender: TObject);
    procedure Bt_DataCollectClick(Sender: TObject);
    procedure Bt_AutoSendClick(Sender: TObject);
    procedure btCDMARTClick(Sender: TObject);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Bt_RefrashClick(Sender: TObject);
    procedure Bt_EditDbConnClick(Sender: TObject);
    procedure Bt_NewDbConnClick(Sender: TObject);
    procedure btCDMALXClick(Sender: TObject);
    procedure Bt_RefCfgClick(Sender: TObject);
    procedure Bt_UpdCfgClick(Sender: TObject);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure DBGrid2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cbDebugCDMACollClick(Sender: TObject);
    procedure cbClearHisClick(Sender: TObject);
  private
    ScheCYC : Integer;
    CollectionKind : integer;
    VToday, VTomorrow : TDate;
      //�ɼ�ʱ�����������и����澯����Ӧ�±�ֵ��
                                      // 0-ʵʱ�澯��
                                      // 1-15������·�澯��
                                      // 2-1Сʱ��ѯ�澯��CS����
                                      // 3-1Сʱ��ѯ�澯��RP����
                                      // 4-��վ���ϸ������ڡ�


    CDMACollecctThread : TAlarmAdjustThread;  //CDMA��ѯ�ɼ��߳�
    RealTimeAlarmThread : TAlarmAdjustThread; //����ʵʱ�澯�����߳�    

    InteAttempThread : InteAttempCollect;  //����澯�ɼ������߳�
    AutoSendThread : AutoSendAlarm;  //�����Զ����ϴ����߳�
    
    procedure SetAutoCollectStopState;
    procedure InitCollectThread();
    procedure SaveCollectState();
    function GetMaxCode(CollectKind:integer):integer;
    procedure refrashCollectParam();  //ˢ�²ɼ���������
    procedure refrashCollectConfig();
    //procedure UpdateSysFunSet(setvalue:string; kind, code:integer);  //����ϵͳ���ܱ�
    procedure JudgeIfSendAlarm();  //���ø���վ�����Ӧ�����ϱ�־
    procedure NewDayIfSendAlarm();  //���ø���վ�����Ӧ�����ϱ�־
    Function JudgeTodayIsSendAlarm(TheDate: TDate; CityID:integer):Boolean; //�жϽ����Ƿ��������
    function ConfigDBConn(IsNew:boolean=true; EditedConnStr:string=''):String;
    procedure ShowTheThreadState(Sb: TSpeedButton; IsEnable: Boolean; TheColor: TColor);
    procedure CollectActionEvent(var TheBtnAction: TButton);
      { Private declarations }
  public
    procedure PassCDMAMes(iFlag: Integer; iOption: Integer);
  end;

var
  Fm_Collection_Data: TFm_Collection_Data;

implementation

uses Ut_Data_Local, Ut_RunLog, Ut_Main_Build, MSDASC_TLB, Ut_PubObj_Define,
  UntFunc;

{$R *.dfm}

procedure TFm_Collection_Data.SetAutoCollectStopState;
begin    
  Ed_DataCollect.Enabled:=false;
  Ed_AutoSend.Enabled:=false;
  Ed_RealTime.Enabled:=false;
  Ed_ZteRt.Enabled:=false;

  Sb_Dc_Stop.Down:=not false;
  Sb_As_Stop.Down:=not false;
  sbCDMALXStop.Down:=not false;
  sbCDMARTStop.Down:=not false;
  Sb_Rts_StartClick(Sb_Dc_Stop);
  Sb_Rts_StartClick(Sb_As_Stop);
  Sb_Rts_StartClick(sbCDMALXStop);
  Sb_Rts_StartClick(sbCDMARTStop);
end;

procedure TFm_Collection_Data.InitCollectThread();
var i:integer;
begin
  with Dm_Collect_Local do
  begin
    if not InitCollectTheadParam(Ado_Collection_Cfg) then
    begin
      application.MessageBox('ϵͳ̽�⵽���ɼ�ϵͳ��ʼ��������Ϊ�գ�����������ء��ɼ�ϵͳ��ʼ�������ݣ����������ݲɼ�����','��ʾ',mb_ok+mb_defbutton1);
      exit;
    end;
    InitErrorContent();
    for i:=Low(Collect_Info) to High(Collect_Info) do
    with Collect_Info[i],Dm_Collect_Local do
    case CollectKind of
     1 :  ;
     2 :  ;
     3 :;
     4 : ;
     6 :  if IsCreate = 1 then      //CDMA��ѯ�澯�ɼ�
          begin
            if CDMACollecctThread=nil then
            begin
               gbCDMALX.Tag:=60 * CollectionCYC;
               CDMACollecctThread := TAlarmAdjustThread.Create(Fm_Main_Build_Server.ConnectionString, Fm_RunLog.Re_RunLog, btCDMALX);
               CDMACollecctThread.FreeOnTerminate:=false;
            end;
            if CollectState=1 then
            begin
               sbCDMALXStart.Down:=true;
               Sb_Rts_StartClick(sbCDMALXStart);
            end else
            begin
               sbCDMALXStop.Down:=true;
               Sb_Rts_StartClick(sbCDMALXStop);
            end;
            gbCDMALX.Enabled:=true;
          end else
          begin
            ShowTheThreadState(sbCDMALXStop,false,clBtnFace);
            gbCDMALX.Enabled:=false;
          end;
     7 :  if IsCreate = 1 then           //CDMAʵʱ�澯�ɼ�
          begin
            if RealTimeAlarmThread=nil then
            begin
               gbCDMART.Tag:=60 * CollectionCYC;
               RealTimeAlarmThread := TAlarmAdjustThread.Create(Fm_Main_Build_Server.ConnectionString, Fm_RunLog.Re_RunLog, btCDMALX);
               RealTimeAlarmThread.FreeOnTerminate:=false;
            end;
            if CollectState=1 then
            begin
               sbCDMARTStart.Down:=true;
               Sb_Rts_StartClick(sbCDMARTStart);
            end else
            begin
               sbCDMARTStop.Down:=true;
               Sb_Rts_StartClick(sbCDMARTStop);
            end;
            gbCDMART.Enabled:=true;
          end else
          begin
            ShowTheThreadState(sbCDMARTStop,false,clBtnFace);
            gbCDMART.Enabled:=false;
          end;
     8 :  if IsCreate = 1 then
          begin
            if InteAttempThread=nil then
            begin
               Gb_DataCollect.Tag:=60 * CollectionCYC;
               //�澯�ɼ��߳�
               InteAttempThread:=InteAttempCollect.Create(Fm_Main_Build_Server.ConnectionString); //�����̵߳�������ִ�У�falseΪ����ִ��
               InteAttempThread.FreeOnTerminate:=false;
            end;
            if CollectState=1 then
            begin
               Sb_Dc_Start.Down:=true;
               Sb_Rts_StartClick(Sb_Dc_Start);
            end else
            begin
               Sb_Dc_Stop.Down:=true;
               Sb_Rts_StartClick(Sb_Dc_Stop);
            end;
            Gb_DataCollect.Enabled:=true;
          end else
          begin
            ShowTheThreadState(Sb_Dc_Stop,false,clBtnFace);
            Gb_DataCollect.Enabled:=false;
          end;
     9 :  if IsCreate = 1 then
          begin
            if AutoSendThread=nil then
            begin
               Gb_AutoSend.Tag:=60 * CollectionCYC;
               //�Զ������߳�
               AutoSendThread:=AutoSendAlarm.Create(Fm_Main_Build_Server.ConnectionString); //�����̵߳�������ִ�У�falseΪ����ִ��
               AutoSendThread.FreeOnTerminate:=false;
            end;
            if CollectState=1 then
            begin
               Sb_As_Start.Down:=true;
               Sb_Rts_StartClick(Sb_As_Start);
            end else
            begin
               Sb_As_Stop.Down:=true;
               Sb_Rts_StartClick(Sb_As_Stop);
            end;
            Gb_AutoSend.Enabled:=true;
          end else
          begin
            ShowTheThreadState(Sb_As_Stop,false,clBtnFace);
            Gb_AutoSend.Enabled:=false;
          end;
    10 :  ;
    11 :  ;
    13 :  ;
    end;
  end;
  if not Timer_Scheduler.Enabled then
    Timer_Scheduler.Enabled:=true;
end;

procedure TFm_Collection_Data.SaveCollectState();
var
  i: integer;
  Sb: TSpeedButton;
begin
  try      
    with Dm_Collect_Local.Ado_Dynamic do
    begin
      close;
      sql.Clear;
      sql.Add('select collectkind,collectstate from Alarm_Collection_Config where collectkind in (1,2,3,4,6,7,8,9,10,11,13) order by collectkind');
      open;

      for i:=0 to Fm_Collection_Data.ComponentCount-1 do
      begin
        if Fm_Collection_Data.Components[i] is TSpeedButton then
        begin
          sb:= Fm_Collection_Data.Components[i] as TSpeedButton;
          if sb.Tag=1 then
          begin
            if Locate('collectkind',sb.GroupIndex,[loCaseInsensitive]) then
               if sb.Down and (fieldbyname('collectstate').AsInteger<>1) then
               begin
                  edit;
                  fieldbyname('collectstate').AsInteger:=1;
                  post;
               end;
          end;
          if sb.Tag=2 then
          begin
            if Locate('collectkind',sb.GroupIndex,[loCaseInsensitive]) then
               if sb.Down and (fieldbyname('collectstate').AsInteger=1) then
               begin
                  edit;
                  fieldbyname('collectstate').AsInteger:=0;
                  post;
               end;
          end;
        end; //if Controls[i] is TSpeedButton then
      end;//for
      close;
    end; //with

  except
     on E: Exception do
     begin
       Fm_RunLog.Re_RunLog.Lines.Add('ִ��SaveCollectState����ʧ�ܣ�'+ E.Message);
     end;
  end;

end;

procedure TFm_Collection_Data.FormClose(Sender: TObject; var Action: TCloseAction);
var
   AllowExit : Boolean;
   IsFree : array[0..3] of boolean;
   MaxNum, i:integer;
begin
   {
      �߳��ͷŲ���
   1���ȵȴ��߳��еĹ���ִ����ϣ��ȸ���ť��Чʱ��������Զ��������Է�ֹ�ٴ�ͨ���߳�ִ�й��̣�
   2����ֹ�߳�ִ�У�������Terminate��ʹ�߳������˳�������ִ��Resume��ʹ�߳��˳���
   3�������߳���ֹ���ͷ��̣߳�������Free��
   }
   //��ʾ�ȴ��߳�ִ����Ϻ����˳�
   if not (btCDMART.Enabled and Bt_DataCollect.Enabled and Bt_AutoSend.Enabled and btCDMALX.Enabled ) then
   begin
      application.MessageBox('�������ݲɼ��߳������У���ȴ��������ݲɼ���ť����Чʱ�������˳���','��ʾ',mb_ok+mb_defbutton1);
      action:=canone;
      exit;
   end;
   SaveCollectState();
   Timer_Scheduler.Enabled:=false;
   SetAutoCollectStopState;    

   AllowExit:=false;
   MaxNum:=0;
   for i:=0 to 3 do
     IsFree[i]:=false;

   while not AllowExit do
   begin
     if (not IsFree[0]) then
     with RealTimeAlarmThread do     //**UTʵʱ�澯
     case CheckThreadStatus(RealTimeAlarmThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;      //�ͷ��߳�
            IsFree[0]:=true;
          end;
      else
          IsFree[0]:=true;
     end;
     if (not IsFree[1]) then
     with InteAttempThread do  //**�����ۺϲɼ�
     case CheckThreadStatus(InteAttempThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
            IsFree[1]:=true;
          end;
      else
          IsFree[1]:=true;
     end;
     if (not IsFree[2]) then
     with AutoSendThread do      //**�Զ�����
     case CheckThreadStatus(AutoSendThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
            IsFree[2]:=true;
          end;
      else
          IsFree[2]:=true;
     end;
     if (not IsFree[3]) then
     with CDMACollecctThread do  //**����ʵʱ�澯
     case CheckThreadStatus(CDMACollecctThread) of
      1 : begin
            Terminate; //��ֹ�߳�
            Resume;
          end;
      2 : begin
            Free;        //�ͷ��߳�
            IsFree[3]:=true;
          end;
      else
          IsFree[3]:=true;
     end;
     
     AllowExit:=true;
     for i:=0 to 3 do
       AllowExit:=AllowExit and IsFree[i];

     application.ProcessMessages;
     inc(MaxNum);
     if (MaxNum>10000) and (not AllowExit) then
     begin
       if not IsFree[0] then
       begin
         IsFree[0]:=true;
         RealTimeAlarmThread.Free;
       end;
       if not IsFree[1] then
       begin
         IsFree[1]:=true;
         InteAttempThread.Free;
       end;
       if not IsFree[2] then
       begin
         IsFree[2]:=true;
         AutoSendThread.Free;
       end;
       if not IsFree[3] then
       begin
         IsFree[3]:=true;
         CDMACollecctThread.Free;
       end;

       for i:=0 to 3 do
         AllowExit:=AllowExit and IsFree[i];
     end;
   end;
   action:=cafree;
end;

function TFm_Collection_Data.GetMaxCode(CollectKind:integer):integer;
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

procedure TFm_Collection_Data.Bt_UpdateClick(Sender: TObject);
var button : tButton;
    COLLECTIONCODE:integer;
begin
  COLLECTIONCODE:=0;
  button:=sender as TButton;
  with Dm_Collect_Local.Ado_Collection_Cyc do
  if active then
  begin
    try
      try
        case button.Tag of
        1:
          begin
            CollectionKind:=fieldbyname('CollectionKind').AsInteger;
            COLLECTIONCODE:=fieldbyname('COLLECTIONCODE').AsInteger;
            Edit;
            fieldbyname('CollectionKind').AsInteger:=CollectionKind;
            fieldbyname('COLLECTIONCODE').AsString:=Ed_COLLECTIONCODE.Text;
            fieldbyname('CityID').AsString:=Et_CityID.Text;
            fieldbyname('SetValue').AsInteger:=Se_SetValue.Value;
            fieldbyname('FORWARDDAY').AsInteger:=Se_DataBound.Value;
            fieldbyname('Increment_Column').AsString:=Et_Increment_Column.Text;
            fieldbyname('LAST_DATASOURCE').AsString:=Et_LAST_DATASOURCE.Text;
            fieldbyname('CollectionName').AsString:=Et_CollectionName.Text;
            fieldbyname('TableName').AsString:=Et_TableName.Text;
            fieldbyname('Remark').AsString:=Et_Remark.Text;
            fieldbyname('OperTime').AsDateTime:=now;
            fieldbyname('Operator').AsString:=Dm_Collect_Local.Operator;
            post;
          end;
        2:
          begin
            delete;
            CollectionKind:=fieldbyname('CollectionKind').AsInteger;
            COLLECTIONCODE:=fieldbyname('COLLECTIONCODE').AsInteger;
          end;
        3:
          if collectionkind=0 then
          begin
            application.MessageBox('��ѡ����Ҫ�����Ƶļ�¼��Ȼ���ٵ������ť��','��ʾ',mb_ok+mb_defbutton1);
            exit;
          end else
          begin
            CollectionKind:=fieldbyname('CollectionKind').AsInteger;
            COLLECTIONCODE:=GetMaxCode(collectionkind)+1;
            append;          
            fieldbyname('collectionkind').AsInteger:=collectionkind;
            fieldbyname('CollectionCode').AsInteger:=COLLECTIONCODE;
            fieldbyname('CityID').AsString:=Et_CityID.Text;
            fieldbyname('SetValue').AsInteger:=Se_SetValue.Value;
            fieldbyname('FORWARDDAY').AsInteger:=Se_DataBound.Value;
            fieldbyname('Increment_Column').AsString:=Et_Increment_Column.Text;
            fieldbyname('LAST_DATASOURCE').AsString:=Et_LAST_DATASOURCE.Text;
            fieldbyname('CollectionName').AsString:=Et_CollectionName.Text;
            fieldbyname('TableName').AsString:=Et_TableName.Text;
            fieldbyname('Remark').AsString:=Et_Remark.Text;
            fieldbyname('OperTime').AsDateTime:=now;
            fieldbyname('Operator').AsString:=Dm_Collect_Local.Operator;
            post;
          end;
        end;
        application.MessageBox('�����ɹ�','��ʾ',mb_ok+mb_defbutton1);
      except
        application.MessageBox('���������г�����������ԣ�','��ʾ',mb_ok+mb_defbutton1);
      end;
    finally
      close;
      open;
      Locate('collectionkind;CollectionCode',VarArrayOf([CollectionKind,COLLECTIONCODE]),[loCaseInsensitive]);
    end; //try
  end;   //if
end;

procedure TFm_Collection_Data.FormShow(Sender: TObject);
var i:integer;
begin
   PageControl1.ActivePageIndex :=0;
   Fm_Main_Build_Server.InitVariable();
   ScheCYC:=0;
   VToday:=Date;
   VTomorrow:=VToday;
   with Dm_Collect_Local do
   for i:=Low(AlarmParam) to High(AlarmParam) do
     AlarmParam[i].TodayIsSend:=JudgeTodayIsSendAlarm(VToday,AlarmParam[i].CityID);
   InitCollectThread();
   
   with Dm_Collect_Local.Ado_Collection_Cyc do
   begin
     close;
     open
   end;

   tsSourceSet.TabVisible := false;

end;

procedure TFm_Collection_Data.Sb_Rts_StartClick(Sender: TObject);
var
   Sb: TSpeedButton;
   IsEnable: Boolean;
   TheColor: TColor;
begin
   Sb:= Sender as TSpeedButton;
   IsEnable:= ((Sb.Tag=1) and (Sb.Down));
   if IsEnable then                 //�����Ӧ�İ�ť��������������Ӧ�Ĳɼ�����
      TheColor:= clNavy
   else
      TheColor:= clGreen;
   ShowTheThreadState(Sb,IsEnable,TheColor);
end;

procedure TFm_Collection_Data.ShowTheThreadState(Sb: TSpeedButton; IsEnable: Boolean; TheColor: TColor);
begin
   case Sb.GroupIndex of
    1 :;
    2 : ;
    3 :;
    4 : ;
    6 : begin
           Shape_ZTRT_2.Pen.Color:=TheColor;
           Ed_ZteRt.Enabled:=IsEnable;
        end;
    7 : ;
    8 : begin
           Shape_DataCollect.Pen.Color:=TheColor;
           Ed_DataCollect.Enabled:=IsEnable;
        end;
    9 : begin
           Shape_AutoSend.Pen.Color:=TheColor;
           Ed_AutoSend.Enabled:=IsEnable;
        end;
   10 :;
   11 : ;
   13 : ;
   end;
   //sb.Down:=true;
end;    

//�������ϣ�������Ӧ����Ļ�վΪ��������
procedure TFm_Collection_Data.JudgeIfSendAlarm();
var
  Present: TTime;
  CurrTime: string;
  Hour, Min, Sec, MSec: Word;
  i,j:integer;
 begin
  Present:= Time();
  DecodeTime(Present, Hour, Min, Sec, MSec);
  CurrTime:=format('%0.2d',[Hour])+':'+format('%0.2d',[Min]);
  with Dm_Collect_Local do
  for j:=Low(AlarmParam) to High(AlarmParam) do
  for i:=Low(AlarmParam[j].CityParam.sendtimeList) to High(AlarmParam[j].CityParam.sendtimeList) do
  begin
    if (AlarmParam[j].CityParam.sendtimeList[i].TimeList <> nil) and (AlarmParam[j].CityParam.sendtimeList[i].TimeList.IndexOf(CurrTime)<>-1) then
      AlarmParam[j].CityParam.sendtimeList[i].AllowSend:=true; //������Ӧ����Ļ�վΪ��������
  end;
end;

//����ָ�������ڣ���������Ƿ��������
Function TFm_Collection_Data.JudgeTodayIsSendAlarm(TheDate: TDate; CityID:integer):Boolean;//�жϽ����Ƿ��������
var
  Today: string;
  Year, Month, Day: Word;
  i,j,TheWeek:integer;
 begin
  Result:=false;
  DecodeDate(TheDate, Year, Month, Day);
  Today:=format('%0.4d',[Year])+'-'+format('%0.2d',[Month])+'-'+format('%0.2d',[Day]);
  with Dm_Collect_Local do
  begin
    for j:=Low(AlarmParam) to High(AlarmParam) do
      if AlarmParam[j].CityID=CityID then break;
    for i:=Low(AlarmParam[j].CityParam.SendDateList) to High(AlarmParam[j].CityParam.SendDateList) do
    begin
      if (AlarmParam[j].CityParam.SendDateList[i].TimeList.IndexOf(Today)<>-1) then
      begin
        Result:=AlarmParam[j].CityParam.SendDateList[i].AllowSend; //�жϽ�������һ���������������б���
        exit;
      end;
    end;
    TheWeek:=DayOfTheWeek(TheDate);
    for i:=Low(AlarmParam[j].CityParam.WeekSendList) to High(AlarmParam[j].CityParam.WeekSendList) do
      if TheWeek=AlarmParam[j].CityParam.WeekSendList[i].Code then
      begin
        Result:=AlarmParam[j].CityParam.WeekSendList[i].SetValue;
        break;
      end;
  end;
end;

//ִ�и澯�ɼ��¼�
procedure TFm_Collection_Data.CollectActionEvent(var TheBtnAction: TButton);
begin
  if TheBtnAction.Enabled then
  begin
    TheBtnAction.Click; //ģ������ִ�и澯�ɼ�
    TheBtnAction.Tag:=0;
  end
  else
  begin
    TheBtnAction.Tag:=TheBtnAction.Tag+1;
    //----------------------------------------��ʱ������
    //if TheBtnAction.Tag>=3 then  //��������������ΰ�ť��ң���ǿ��Ӧ���ر�Ѳ���Ӧ�ó���
      //Dm_Collect_Local.TempInterface.ControlAppSvr(1);
  end;
end;

procedure TFm_Collection_Data.Timer_SchedulerTimer(Sender: TObject);
var i:integer;
begin
  //Fm_RunLog.SaveRunLog(Fm_RunLog.Re_RunLog, 'RunLog');
  
  inc(ScheCYC);
  VTomorrow:=Date();
  if VToday<>VTomorrow then //ÿ�����������
  begin
    VToday:=VTomorrow;
    NewDayIfSendAlarm;//�����Ƿ����ϱ�ʶ ,���򶨵����ϳ����������
    ScheCYC:=0;
    //���Ը����Ƿ���������
    with Dm_Collect_Local do
    begin
      for i:=Low(AlarmParam) to High(AlarmParam) do
        AlarmParam[i].TodayIsSend:=JudgeTodayIsSendAlarm(VToday,AlarmParam[i].CityID);
    end;
  end;
  with Dm_Collect_Local do
  for i:=Low(AlarmParam) to High(AlarmParam) do
  if not AlarmParam[i].CityParam.IsAutoSend then
   JudgeIfSendAlarm;   //���Ϊ�������ϣ���ÿ��ѭ�����ø���վ�����Ӧ�����ϱ�־
  if Sb_Dc_Start.Down then
    Ed_DataCollect.Text:=inttostr(ScheCYC+30)+'-'+inttostr(Gb_DataCollect.Tag)+'-'+inttostr((ScheCYC+30) mod Gb_DataCollect.Tag);
  if Sb_As_Start.Down then
    Ed_AutoSend.Text:=inttostr(ScheCYC)+'-'+inttostr(Gb_AutoSend.Tag)+'-'+inttostr(ScheCYC mod Gb_AutoSend.Tag);
  if sbCDMALXStart.Down then
    Ed_ZteRt.Text:=inttostr(ScheCYC)+'-'+inttostr(gbCDMALX.Tag)+'-'+inttostr(ScheCYC mod gbCDMALX.Tag);
  if sbCDMARTStart.Down then
    Ed_ZteRt.Text:=inttostr(ScheCYC)+'-'+inttostr(gbCDMART.Tag)+'-'+inttostr(ScheCYC mod gbCDMART.Tag);

    
  if sbCDMALXStart.Down and (ScheCYC mod gbCDMALX.Tag=0) then
    CollectActionEvent(btCDMALX);  //CDMA��ѯ�澯�ɼ�
  if sbCDMARTStart.Down and (ScheCYC mod gbCDMART.Tag=0) then
    CollectActionEvent(btCDMART);  //CDMAʵʱ�澯�ɼ�
  if Sb_Dc_Start.Down and ((ScheCYC+30) mod Gb_DataCollect.Tag=0) then
    CollectActionEvent(Bt_DataCollect);  //���ݲɼ�
  if Sb_As_Start.Down and (ScheCYC mod Gb_AutoSend.Tag=0) then
    CollectActionEvent(Bt_AutoSend);   //�Զ�����
end;

procedure TFm_Collection_Data.Bt_DataCollectClick(Sender: TObject);
begin
   if InteAttempThread=nil then exit;
   InteAttempThread.Resume;     //�澯�ۺϲɼ�    
end;

procedure TFm_Collection_Data.Bt_AutoSendClick(Sender: TObject);
begin
   if AutoSendThread=nil then exit;
   AutoSendThread.Resume;      //�Զ�����
end;

procedure TFm_Collection_Data.btCDMARTClick(Sender: TObject);
begin
   if RealTimeAlarmThread=nil then exit;
   RealTimeAlarmThread.Resume;  //ʵʱ�澯�ɼ�    
end;

procedure TFm_Collection_Data.btCDMALXClick(Sender: TObject);
begin
   if CDMACollecctThread=nil then exit;
   CDMACollecctThread.ResumeThread; //CDMA��ѯ�ɼ��߳�
end;

procedure TFm_Collection_Data.refrashCollectParam();
begin
  with Dm_Collect_Local.Ado_Collection_Cyc do
  if Active then
  begin
    CollectionKind:=fieldbyname('CollectionKind').AsInteger;
    Ed_COLLECTIONKIND.Text:=inttostr(CollectionKind);
    Ed_COLLECTIONCODE.Text:=fieldbyname('COLLECTIONCODE').AsString;
    Et_CityID.Text:=fieldbyname('CityID').AsString;
    Se_SetValue.Value:=fieldbyname('SetValue').AsInteger;
    Se_DataBound.Value:=fieldbyname('FORWARDDAY').AsInteger;
    Et_Increment_Column.Text:=fieldbyname('Increment_Column').AsString;
    Et_LAST_DATASOURCE.Text:=fieldbyname('LAST_DATASOURCE').AsString;
    Et_CollectionName.Text:=fieldbyname('CollectionName').AsString;
    Et_TableName.Text:=fieldbyname('TableName').AsString;
    Et_Remark.Text:=fieldbyname('Remark').AsString;
  end;
end;

procedure TFm_Collection_Data.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key =38) or (key=40) then
    refrashCollectParam();
end;

procedure TFm_Collection_Data.DBGrid1CellClick(Column: TColumn);
begin
  refrashCollectParam();
end;

procedure TFm_Collection_Data.Bt_RefrashClick(Sender: TObject);
begin
   with Dm_Collect_Local.Ado_Collection_Cyc do
   begin
      close;
      open;
      first;
      refrashCollectParam();
   end;
end;

function TFm_Collection_Data.ConfigDBConn(IsNew:boolean; EditedConnStr:string):String;
var
   DataSourceLocator : IDataSourceLocator;
   ADOConn : IDispatch;
   ADODbConn : TADOConnection;
begin
   ADODbConn := TADOConnection.Create(self);
   ADODbConn.ConnectionString := EditedConnStr;
   DataSourceLocator  :=  CoDataLinks.Create;     //�����ӿ�ָ��
   try
     if IsNew then //Ϊtrue���������ã�Ϊfalse�༭����
     begin
       ADOConn  :=  DataSourceLocator.PromptNew;      //�����ô���
       ADODbConn.ConnectionObject  :=  IDispatch(ADOConn)  as  _Connection;//��ֵ��ADOConnection
     end else
     try
       ADOConn:=IDispatch(ADODbConn.ConnectionObject);
       DataSourceLocator.PromptEdit(ADOConn);
     except
       on E : Exception do
          raise Exception.Create('����ʶ�����е����ݿ����Ӵ�������<�ؽ����ݿ�����>�������������ݿ����Ӵ���');
     end;
   finally
     Result:=ADODbConn.ConnectionString;
     DataSourceLocator  :=  nil;        //�����ͷŰ�
     ADODbConn.Free;
   end;
end;

procedure TFm_Collection_Data.Bt_EditDbConnClick(Sender: TObject);
begin
   Et_LAST_DATASOURCE.Text:=ConfigDBConn(false,Et_LAST_DATASOURCE.Text);
end;

procedure TFm_Collection_Data.Bt_NewDbConnClick(Sender: TObject);
begin
   Et_LAST_DATASOURCE.Text:=ConfigDBConn();
end;

procedure TFm_Collection_Data.refrashCollectConfig();
begin
  with Dm_Collect_Local.Ado_Collection_Cfg do
  if Active then
  begin
    Et_COLLECTNAME.Text:=fieldbyname('COLLECTNAME').asstring;
    Rg_ISCREATE.ItemIndex:=fieldbyname('ISCREATE').AsInteger;
    Rg_COLLECTSTATE.ItemIndex:=fieldbyname('COLLECTSTATE').AsInteger;
    Se_CollectionCyc.Value:= fieldbyname('CollectionCyc').AsInteger;
    Et_Remark.Text:=fieldbyname('Remark').AsString;
  end;
end;

procedure TFm_Collection_Data.Bt_RefCfgClick(Sender: TObject);
begin
  with Dm_Collect_Local.Ado_Collection_Cfg do
  begin
    close;
    open;
    first;
    refrashCollectConfig();
  end;
end;

procedure TFm_Collection_Data.Bt_UpdCfgClick(Sender: TObject);
var collectkind:integer;
begin
  with Dm_Collect_Local.Ado_Collection_Cfg do
  begin
    if Active then
    begin
      collectkind:=fieldbyname('collectkind').asinteger;
      edit;
      fieldbyname('COLLECTNAME').asstring:=Et_COLLECTNAME.Text;
      fieldbyname('ISCREATE').AsInteger:=Rg_ISCREATE.ItemIndex;
      fieldbyname('COLLECTSTATE').AsInteger:=Rg_COLLECTSTATE.ItemIndex;
      fieldbyname('CollectionCyc').AsInteger:=Se_CollectionCyc.Value;
      fieldbyname('Remark').AsString:=Et_Remark.Text;
      post;
      application.MessageBox('�����ɹ�','��ʾ',mb_ok+mb_defbutton1);
      close;
      open;
      Locate('collectkind',collectkind,[loCaseInsensitive]);
    end;
  end;
end;

procedure TFm_Collection_Data.DBGrid2CellClick(Column: TColumn);
begin
   refrashCollectConfig();
end;

procedure TFm_Collection_Data.DBGrid2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key =38) or (key=40) then
    refrashCollectConfig();
end;

procedure TFm_Collection_Data.DBGrid2DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
   with TDBGrid(Sender).DataSource.DataSet do
   begin
      if (RecNo Mod 2)=0 then
         TDBGrid(Sender).Canvas.Brush.color:= $00BAFAF9//$0060CFFF; //$0000CCFF//$00C9D3CA;//clMoneyGreen
      else
         TDBGrid(Sender).Canvas.Brush.color:=$00E6F6F8;//$00FFF3E7; //$00F7EFCC//$00CAB56C//$00FDF4EA//$00CFCFCD;//clGradientInactiveCaption;
   end;
   with TMyDBGrid(Sender) do
   begin
      if DataLink.ActiveRecord=Row-1 then
      begin
        Canvas.Font.Color:=clWhite;
        Canvas.Brush.Color:=$0023AF82;
      end ;
   end;
   TDBGrid(Sender).DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

procedure TFm_Collection_Data.NewDayIfSendAlarm;
var
  Present: TTime;
  CurrTime: string;
  Hour, Min, Sec, MSec: Word;
  i,j:integer;
begin
  Present:= Time();
  DecodeTime(Present, Hour, Min, Sec, MSec);
  CurrTime:=format('%0.2d',[Hour])+':'+format('%0.2d',[Min]);
  with Dm_Collect_Local do
  for j:=Low(AlarmParam) to High(AlarmParam) do
  for i:=Low(AlarmParam[j].CityParam.sendtimeList) to High(AlarmParam[j].CityParam.sendtimeList) do
    AlarmParam[j].CityParam.sendtimeList[i].AllowSend:=false;
end;

procedure TFm_Collection_Data.PassCDMAMes(iFlag: Integer; iOption: Integer);
begin
  if CDMACollecctThread=nil then exit;
  //CDMACollecctThread.ProcessCDMAMes(iFlag, iOption);
end;

procedure TFm_Collection_Data.cbDebugCDMACollClick(Sender: TObject);
begin
  //CDMACollecctThread.SetDebug(cbDebugCDMAColl.Checked);
end;

procedure TFm_Collection_Data.cbClearHisClick(Sender: TObject);
begin
  //CDMACollecctThread.blNoClearHis := cbClearHis.Checked;
end;

end.




