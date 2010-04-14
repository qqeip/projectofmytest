program MTS_Collect_Server;

uses
  Forms,
  Ut_Main_Collect in 'Ut_Main_Collect.pas' {Fm_Main_Collect},
  Ut_MtuInfo in 'Ut_MtuInfo.PAS',
  Ut_Common in 'Ut_Common.pas',
  Log in 'Log.pas',
  Ut_Global in 'Ut_Global.pas',
  Ut_BaseThread in 'Ut_BaseThread.pas',
  MTS_Server_TLB in 'MTS_Server_TLB.pas',
  Ut_MtuDataProcess in 'Ut_MtuDataProcess.pas',
  Ut_SystemSet in 'Ut_SystemSet.pas' {Fm_SystemSet},
  Ut_TestResultSearch in 'Ut_TestResultSearch.pas' {Fm_TestResult},
  UnitAutoTestListThread in 'UnitAutoTestListThread.pas',
  UnitTaskSendThread in 'UnitTaskSendThread.pas',
  UnitThreadCommon in 'UnitThreadCommon.pas',
  UntCDMACollectThread in 'UntCDMACollectThread.pas',
  UnitFunAnalyseThread in 'UnitFunAnalyseThread.pas',
  UnitResultParas in 'UnitResultParas.pas',
  UnitAlarmCollect in 'UnitAlarmCollect.pas',
  UnitAlarmSend in 'UnitAlarmSend.pas',
  UnitRepeaterInfo in 'UnitRepeaterInfo.pas',
  UnitDRS_TaskSendThread in 'UnitDRS_TaskSendThread.pas',
  UnitDRS_ResultReviceThread in 'UnitDRS_ResultReviceThread.pas',
  UnitDRS_ResultParasThread in 'UnitDRS_ResultParasThread.pas',
  UntSMSClass in 'UntSMSClass.pas',
  UnitDRS_AlarmCollect in 'UnitDRS_AlarmCollect.pas',
  UnitDRS_AlarmSend in 'UnitDRS_AlarmSend.pas',
  UnitDRS_AutoTestThread in 'UnitDRS_AutoTestThread.pas',
  UnitDRS_Math in 'UnitDRS_Math.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFm_Main_Collect, Fm_Main_Collect);
  Application.Run;
end.
