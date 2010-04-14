program MTS_Client;

uses
  Forms,
  Ut_MainForm in '0_框架文件\Ut_MainForm.pas' {Fm_MainForm},
  DBThreeStateTree in 'DBThreeStateTree.pas',
  FrmChangePwd in '0_框架文件\FrmChangePwd.pas' {FormChangePwd},
  FrmLogin in '0_框架文件\FrmLogin.pas' {FormLogin},
  UserPwd in '0_框架文件\UserPwd.pas' {FormUserPWD},
  Ut_DataModule in '0_框架文件\Ut_DataModule.pas' {Dm_MTS: TDataModule},
  Ut_ServerSet in '0_框架文件\Ut_ServerSet.pas' {Fm_ServerSet},
  MTS_Server_TLB in 'MTS_Server_TLB.pas',
  Ut_Common in '0_框架文件\Ut_Common.pas',
  Ut_MTSTreeHelper in '0_框架文件\Ut_MTSTreeHelper.pas',
  Ut_UserInfoMag in '3_基础数据管理\Ut_UserInfoMag.pas' {Fm_UserInfoMag},
  Ut_UserPurview in '3_基础数据管理\Ut_UserPurview.pas' {Fm_UserPurview},
  Ut_AlarmContent in '3_基础数据管理\Ut_AlarmContent.pas' {Fm_AlarmContent},
  Frm_building_info in '2_资源管理\Frm_building_info.pas' {fm_building_info},
  Ut_DataDicMag in '3_基础数据管理\Ut_DataDicMag.pas' {Fm_DataDicMag},
  Ut_AlarmTest in '1_告警管理\Ut_AlarmTest.pas' {Fm_AlarmTest},
  Ut_TestParamSet in '3_基础数据管理\Ut_TestParamSet.pas' {Fm_TestParamSet},
  Ut_FloatInfo in '1_告警管理\Ut_FloatInfo.pas' {Fm_FloatInfo},
  Ut_AlarmQuery in '1_告警管理\Ut_AlarmQuery.pas' {Fm_AlarmQuery},
  UDevExpressToChinese in 'UDevExpressToChinese.pas',
  UntAlarmTestModel in '1_告警管理\UntAlarmTestModel.pas' {FrmAlarmTestModel},
  UnitInputArea in '3_基础数据管理\UnitInputArea.pas' {FormInputArea},
  UntDBFunc in '0_框架文件\UntDBFunc.pas',
  UnitMtuPlanSet in '1_告警管理\UnitMtuPlanSet.pas' {FormMtuPlanSet},
  UnitAlarmMonitor in '1_告警管理\UnitAlarmMonitor.pas' {FormAlarmMonitor},
  UnitGlobal in 'UnitGlobal.pas',
  FrmSelectLayer in '1_告警管理\FrmSelectLayer.pas' {FormSelectLayer},
  LayerSvrUnit in '1_告警管理\LayerSvrUnit.pas',
  UnitAlarmWait in '1_告警管理\UnitAlarmWait.pas' {FormAlarmWait},
  UnitTestParticular in '1_告警管理\UnitTestParticular.pas' {FormTestParticular},
  UnitCDMASource in '2_资源管理\UnitCDMASource.pas' {FormCDMASource},
  UnitMTUINFO in '2_资源管理\UnitMTUINFO.pas' {FormMTUINFO},
  UnitCSInfoMag in '2_资源管理\UnitCSInfoMag.pas' {FormCSInfoMag},
  UnitLinkMachineInfo in '2_资源管理\UnitLinkMachineInfo.pas' {FormLinkMachineInfo},
  UnitAPInfo in '2_资源管理\UnitAPInfo.pas' {FormAPInfo},
  UnitSwitchInfo in '2_资源管理\UnitSwitchInfo.pas' {FormSwitchInfo},
  UnitSearchBuilding in '1_告警管理\UnitSearchBuilding.pas' {FormSearchBuilding},
  UnitBuildingParticular in '1_告警管理\UnitBuildingParticular.pas' {FormBuildingParticular},
  UnitWirelessParticular in '1_告警管理\UnitWirelessParticular.pas' {FormWirelessParticular},
  Ut_CityInfoManage in '3_基础数据管理\Ut_CityInfoManage.pas' {Fm_CityManager},
  UnitAddAlarmInfo in '1_告警管理\UnitAddAlarmInfo.pas' {FormAddAlarmInfo},
  UntDRSConfig in '4_直放站模块\UntDRSConfig.pas' {FrmDRSConfig},
  UntDRSConfigParamSet in '4_直放站模块\UntDRSConfigParamSet.pas' {FrmDRSConfigParamSet},
  UnitDRS_Alarm_mgr in '4_直放站模块\UnitDRS_Alarm_mgr.pas' {FormDRS_ALARM_Mgr},
  UnitDRSInfoMgr in '4_直放站模块\UnitDRSInfoMgr.pas' {FormDRSInfoMgr},
  Unit_DRS_AlarmQuery in '4_直放站模块\Unit_DRS_AlarmQuery.pas' {Form_DRS_AlarmQuery},
  UnitBaseShowModal in '4_直放站模块\UnitBaseShowModal.pas' {FormBaseShowModal},
  UnitAlarmContentModule in '4_直放站模块\UnitAlarmContentModule.pas' {FormAlarmContentModule},
  UnitDRSRoundSearch in '4_直放站模块\UnitDRSRoundSearch.pas' {FormDRSRoundSearch},
  WrmPLdrs_autotest_cmd in '4_直放站模块\WrmPLdrs_autotest_cmd.pas',
  UntCommandParam in '4_直放站模块\UntCommandParam.pas',
  UnitDRSSingleAlarmSearch in '4_直放站模块\UnitDRSSingleAlarmSearch.pas' {FormDRSSingleAlarmSearch},
  UnitDRSParticular in '1_告警管理\UnitDRSParticular.pas' {FormDRSParticular},
  UntDRSConfigComQuery in '4_直放站模块\UntDRSConfigComQuery.pas' {FrmDRSConfigComQuery},
  UnitRingPopupWindows in '0_框架文件\UnitRingPopupWindows.pas' {FormRingPopupWindows},
  UnitUserCustomSet in '0_框架文件\UnitUserCustomSet.pas' {FormUserCustomSet},
  UnitRingMgr in '0_框架文件\UnitRingMgr.pas' {FormRingMgr},
  UntDRSComQuery in '4_直放站模块\UntDRSComQuery.pas' {FrmDRSComQuery},
  UnitDRSSearch in '0_框架文件\UnitDRSSearch.pas' {FormDRSSearch};

{$R *.res}

begin
  Application.Initialize;
  Application.Title :='室内分布测试监控系统';
  Application.CreateForm(TDm_MTS, Dm_MTS);
  Application.CreateForm(TFm_MainForm, Fm_MainForm);
  Application.Run;
end.
