program Prj_Collect_Service;

uses
  Forms,
  windows,
  sysutils,
  controls,
  Ut_Main_Build in 'Ut_Main_Build.pas' {Fm_Main_Build_Server},
  Ut_Data_Local in 'Ut_Data_Local.pas' {Dm_Collect_Local: TDataModule},
  Ut_Collection_Data in 'Ut_Collection_Data.pas' {Fm_Collection_Data},
  Ut_RunLog in 'Ut_RunLog.pas' {Fm_RunLog},
  Ut_ServerSet in 'Ut_ServerSet.pas' {Fm_ServerSet},
  Ut_InteAttempCollect_Thread in 'Ut_InteAttempCollect_Thread.pas',
  Ut_AutoSendAlarm_Thread in 'Ut_AutoSendAlarm_Thread.pas',
  Ut_LoginWin in 'Ut_LoginWin.pas' {Fm_LoginWin},
  Ut_Flowtache_Monitor in 'Ut_Flowtache_Monitor.pas' {Fm_FlowMonitor},
  Ut_ClearFlowTacheThread in 'Ut_ClearFlowTacheThread.pas',
  MSDASC_TLB in 'MSDASC_TLB.pas',
  Ut_SynchronizeDataThread in 'Ut_SynchronizeDataThread.pas',
  Ut_common in 'Ut_common.pas',
  untExecutesql in 'untExecutesql.pas',
  untOpenSql in 'untOpenSql.pas',
  Ut_ComponentFactory in 'Ut_ComponentFactory.pas',
  Ut_PubObj_Define in 'Ut_PubObj_Define.pas',
  Ut_AlarmTestDefine in 'Ut_AlarmTestDefine.pas',
  AlarmServiceApp_TLB in 'AlarmServiceApp_TLB.pas',
  UntBaseDBThread in 'UntBaseDBThread.pas',
  UntFunc in 'UntFunc.pas',
  UntCDMACollecctThread in 'UntCDMACollecctThread.pas',
  UntBreakSiteThread in 'UntBreakSiteThread.pas',
  UntAlarmRingThread in 'UntAlarmRingThread.pas',
  UntAlarmAdjustThread in 'UntAlarmAdjustThread.pas',
  UntRepAlarmThread in 'UntRepAlarmThread.pas',
  UntAlarmMonitorViewThread in 'UntAlarmMonitorViewThread.pas';

{$R *.res}
var
  hMutex:HWND;
  Ret:Integer;
begin
  Application.Initialize;
  Application.Title := '基站故障采集及派发服务系统';
  //Application.Title := application.ExeName;
  hMutex:=CreateMutex(nil,False,'基站故障采集及派发服务系统');
  Ret:=GetLastError;
  Application.UpdateFormatSettings := False;
  DateSeparator   := '-';                    //系统原缺省为'-'
  ShortDateFormat := 'yyyy-mm-dd';           //短日期格式
  ShortTimeFormat := 'hh:nn:ss';             //短日期格式
  if Ret=ERROR_ALREADY_EXISTS then
  begin
     application.Terminate;
     ReleaseMutex(hMutex);
   EXIT;
  END;
  Application.CreateForm(TFm_Main_Build_Server, Fm_Main_Build_Server);
  if Fm_Main_Build_Server.Action_FirstLoginInit then
  begin
      Application.CreateForm(TDm_Collect_Local, Dm_Collect_Local);
      if Dm_Collect_Local.ConnectDB then
      begin
        Application.CreateForm(TFm_RunLog, Fm_RunLog);
        Application.CreateForm(TFm_Collection_Data, Fm_Collection_Data);
        Application.CreateForm(TFm_FlowMonitor, Fm_FlowMonitor);
        if Fm_Main_Build_Server.Findform('Fm_Collection_Data') then Fm_Collection_Data.BringToFront;
        Application.Run;
      end
      else
      begin
        Fm_Main_Build_Server.Free;
        Application.Terminate;
      end;
  end
  else
  begin
     Fm_Main_Build_Server.Free;
     Application.Terminate;
  end;
end.
