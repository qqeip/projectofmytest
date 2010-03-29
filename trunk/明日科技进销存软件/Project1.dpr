program Project1;

uses
  Forms,
  Main in '������Ϣ\Main.pas' {FrmMain},
  BaseForm in '���ര��\BaseForm.pas' {FrmBase},
  EditBase in '���ര��\EditBase.pas' {FrmEditBase},
  ComeUnit in '������Ϣ\ComeUnit.pas' {FrmComeUnit},
  DataModu in '������Ϣ\DataModu.pas' {FrmDataModu: TDataModule},
  PubConst in '������Ϣ\PubConst.pas',
  MessageBox in '���ര��\MessageBox.pas' {FrmMessageBox},
  AccountUnitEdit in '������Ϣ\AccountUnitEdit.pas' {FrmAccountUnitEdit},
  LinkPersonEdit in '������Ϣ\LinkPersonEdit.pas' {FrmLinkPersonEdit},
  Storage in '������Ϣ\Storage.pas' {FrmStorage},
  StorageEdit in '������Ϣ\StorageEdit.pas' {FrmStorageEdit},
  DWareInfo in '������Ϣ\DWareInfo.pas' {FrmWareInfo},
  WareEdit in '������Ϣ\WareEdit.pas' {FrmWareEdit},
  DBill in '�ɹ�����\DBill.pas' {FrmStockBill},
  SelectData in '���ര��\SelectData.pas' {FrmSelectData},
  DWareMoveBill in '�ֿ����\DWareMoveBill.pas' {FrmWareMove},
  StorageCount in '�ֿ����\StorageCount.pas' {FrmStorageCount},
  WareBranch in '�ֿ����\WareBranch.pas' {FrmWareBranch},
  GatherOne in '�ɹ�����\GatherOne.pas' {FrmGatherOne},
  FindDate in '���ര��\FindDate.pas' {FrmFindDate},
  GatherTwo in '�ɹ�����\GatherTwo.pas' {FrmGatherTwo},
  GatherThree in '�ɹ�����\GatherThree.pas' {FrmGatherThree},
  Gatherfour in '�ֿ����\Gatherfour.pas' {FrmGatherfour},
  Gatherfive in '�ֿ����\Gatherfive.pas' {FrmGatherfive},
  Gathersix in '�ֿ����\Gathersix.pas' {FrmGathersix},
  Login in '���ര��\Login.pas' {FrmLogin},
  md5 in '���ര��\md5.pas',
  PassWordEdit in '���ര��\PassWordEdit.pas' {FrmPassWordEdit},
  User in '���ര��\User.pas' {FrmUser},
  UserEdit in '���ര��\UserEdit.pas' {FrmUserEdit},
  QueryData in '���ര��\QueryData.pas' {FrmQueryData},
  ReportToolManage in '���ര��\ReportToolManage.pas',
  ReportForm in '���ര��\ReportForm.pas' {FrmReport},
  BillQuery in '���ര��\BillQuery.pas' {FrmBillQuery},
  Spell in '���ര��\spell.pas',
  IMCode in '���ര��\IMCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '������ϵͳ 1.0';
  Application.CreateForm(TFrmDataModu, FrmDataModu);
  if TFrmLogin.isLogin then
    Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
