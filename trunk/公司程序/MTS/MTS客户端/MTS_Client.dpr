program MTS_Client;

uses
  Forms,
  Ut_MainForm in '0_����ļ�\Ut_MainForm.pas' {Fm_MainForm},
  DBThreeStateTree in 'DBThreeStateTree.pas',
  FrmChangePwd in '0_����ļ�\FrmChangePwd.pas' {FormChangePwd},
  FrmLogin in '0_����ļ�\FrmLogin.pas' {FormLogin},
  UserPwd in '0_����ļ�\UserPwd.pas' {FormUserPWD},
  Ut_DataModule in '0_����ļ�\Ut_DataModule.pas' {Dm_MTS: TDataModule},
  Ut_ServerSet in '0_����ļ�\Ut_ServerSet.pas' {Fm_ServerSet},
  MTS_Server_TLB in 'MTS_Server_TLB.pas',
  Ut_Common in '0_����ļ�\Ut_Common.pas',
  Ut_MTSTreeHelper in '0_����ļ�\Ut_MTSTreeHelper.pas',
  Ut_UserInfoMag in '3_�������ݹ���\Ut_UserInfoMag.pas' {Fm_UserInfoMag},
  Ut_UserPurview in '3_�������ݹ���\Ut_UserPurview.pas' {Fm_UserPurview},
  Ut_AlarmContent in '3_�������ݹ���\Ut_AlarmContent.pas' {Fm_AlarmContent},
  Frm_building_info in '2_��Դ����\Frm_building_info.pas' {fm_building_info},
  Ut_DataDicMag in '3_�������ݹ���\Ut_DataDicMag.pas' {Fm_DataDicMag},
  Ut_AlarmTest in '1_�澯����\Ut_AlarmTest.pas' {Fm_AlarmTest},
  Ut_TestParamSet in '3_�������ݹ���\Ut_TestParamSet.pas' {Fm_TestParamSet},
  Ut_FloatInfo in '1_�澯����\Ut_FloatInfo.pas' {Fm_FloatInfo},
  Ut_AlarmQuery in '1_�澯����\Ut_AlarmQuery.pas' {Fm_AlarmQuery},
  UDevExpressToChinese in 'UDevExpressToChinese.pas',
  UntAlarmTestModel in '1_�澯����\UntAlarmTestModel.pas' {FrmAlarmTestModel},
  UnitInputArea in '3_�������ݹ���\UnitInputArea.pas' {FormInputArea},
  UntDBFunc in '0_����ļ�\UntDBFunc.pas',
  UnitMtuPlanSet in '1_�澯����\UnitMtuPlanSet.pas' {FormMtuPlanSet},
  UnitAlarmMonitor in '1_�澯����\UnitAlarmMonitor.pas' {FormAlarmMonitor},
  UnitGlobal in 'UnitGlobal.pas',
  FrmSelectLayer in '1_�澯����\FrmSelectLayer.pas' {FormSelectLayer},
  LayerSvrUnit in '1_�澯����\LayerSvrUnit.pas',
  UnitAlarmWait in '1_�澯����\UnitAlarmWait.pas' {FormAlarmWait},
  UnitTestParticular in '1_�澯����\UnitTestParticular.pas' {FormTestParticular},
  UnitCDMASource in '2_��Դ����\UnitCDMASource.pas' {FormCDMASource},
  UnitMTUINFO in '2_��Դ����\UnitMTUINFO.pas' {FormMTUINFO},
  UnitCSInfoMag in '2_��Դ����\UnitCSInfoMag.pas' {FormCSInfoMag},
  UnitLinkMachineInfo in '2_��Դ����\UnitLinkMachineInfo.pas' {FormLinkMachineInfo},
  UnitAPInfo in '2_��Դ����\UnitAPInfo.pas' {FormAPInfo},
  UnitSwitchInfo in '2_��Դ����\UnitSwitchInfo.pas' {FormSwitchInfo},
  UnitSearchBuilding in '1_�澯����\UnitSearchBuilding.pas' {FormSearchBuilding},
  UnitBuildingParticular in '1_�澯����\UnitBuildingParticular.pas' {FormBuildingParticular},
  UnitWirelessParticular in '1_�澯����\UnitWirelessParticular.pas' {FormWirelessParticular},
  Ut_CityInfoManage in '3_�������ݹ���\Ut_CityInfoManage.pas' {Fm_CityManager},
  UnitAddAlarmInfo in '1_�澯����\UnitAddAlarmInfo.pas' {FormAddAlarmInfo},
  UntDRSConfig in '4_ֱ��վģ��\UntDRSConfig.pas' {FrmDRSConfig},
  UntDRSConfigParamSet in '4_ֱ��վģ��\UntDRSConfigParamSet.pas' {FrmDRSConfigParamSet},
  UnitDRS_Alarm_mgr in '4_ֱ��վģ��\UnitDRS_Alarm_mgr.pas' {FormDRS_ALARM_Mgr},
  UnitDRSInfoMgr in '4_ֱ��վģ��\UnitDRSInfoMgr.pas' {FormDRSInfoMgr},
  Unit_DRS_AlarmQuery in '4_ֱ��վģ��\Unit_DRS_AlarmQuery.pas' {Form_DRS_AlarmQuery},
  UnitBaseShowModal in '4_ֱ��վģ��\UnitBaseShowModal.pas' {FormBaseShowModal},
  UnitAlarmContentModule in '4_ֱ��վģ��\UnitAlarmContentModule.pas' {FormAlarmContentModule},
  UnitDRSRoundSearch in '4_ֱ��վģ��\UnitDRSRoundSearch.pas' {FormDRSRoundSearch},
  WrmPLdrs_autotest_cmd in '4_ֱ��վģ��\WrmPLdrs_autotest_cmd.pas',
  UntCommandParam in '4_ֱ��վģ��\UntCommandParam.pas',
  UnitDRSSingleAlarmSearch in '4_ֱ��վģ��\UnitDRSSingleAlarmSearch.pas' {FormDRSSingleAlarmSearch},
  UnitDRSParticular in '1_�澯����\UnitDRSParticular.pas' {FormDRSParticular},
  UntDRSConfigComQuery in '4_ֱ��վģ��\UntDRSConfigComQuery.pas' {FrmDRSConfigComQuery},
  UnitRingPopupWindows in '0_����ļ�\UnitRingPopupWindows.pas' {FormRingPopupWindows},
  UnitUserCustomSet in '0_����ļ�\UnitUserCustomSet.pas' {FormUserCustomSet},
  UnitRingMgr in '0_����ļ�\UnitRingMgr.pas' {FormRingMgr},
  UntDRSComQuery in '4_ֱ��վģ��\UntDRSComQuery.pas' {FrmDRSComQuery},
  UnitDRSSearch in '0_����ļ�\UnitDRSSearch.pas' {FormDRSSearch};

{$R *.res}

begin
  Application.Initialize;
  Application.Title :='���ڷֲ����Լ��ϵͳ';
  Application.CreateForm(TDm_MTS, Dm_MTS);
  Application.CreateForm(TFm_MainForm, Fm_MainForm);
  Application.Run;
end.
