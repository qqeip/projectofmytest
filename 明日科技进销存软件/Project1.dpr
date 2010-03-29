program Project1;

uses
  Forms,
  Main in '基础信息\Main.pas' {FrmMain},
  BaseForm in '基类窗体\BaseForm.pas' {FrmBase},
  EditBase in '基类窗体\EditBase.pas' {FrmEditBase},
  ComeUnit in '基础信息\ComeUnit.pas' {FrmComeUnit},
  DataModu in '基础信息\DataModu.pas' {FrmDataModu: TDataModule},
  PubConst in '基础信息\PubConst.pas',
  MessageBox in '基类窗体\MessageBox.pas' {FrmMessageBox},
  AccountUnitEdit in '基础信息\AccountUnitEdit.pas' {FrmAccountUnitEdit},
  LinkPersonEdit in '基础信息\LinkPersonEdit.pas' {FrmLinkPersonEdit},
  Storage in '基础信息\Storage.pas' {FrmStorage},
  StorageEdit in '基础信息\StorageEdit.pas' {FrmStorageEdit},
  DWareInfo in '基础信息\DWareInfo.pas' {FrmWareInfo},
  WareEdit in '基础信息\WareEdit.pas' {FrmWareEdit},
  DBill in '采购管理\DBill.pas' {FrmStockBill},
  SelectData in '基类窗体\SelectData.pas' {FrmSelectData},
  DWareMoveBill in '仓库管理\DWareMoveBill.pas' {FrmWareMove},
  StorageCount in '仓库管理\StorageCount.pas' {FrmStorageCount},
  WareBranch in '仓库管理\WareBranch.pas' {FrmWareBranch},
  GatherOne in '采购管理\GatherOne.pas' {FrmGatherOne},
  FindDate in '基类窗体\FindDate.pas' {FrmFindDate},
  GatherTwo in '采购管理\GatherTwo.pas' {FrmGatherTwo},
  GatherThree in '采购管理\GatherThree.pas' {FrmGatherThree},
  Gatherfour in '仓库管理\Gatherfour.pas' {FrmGatherfour},
  Gatherfive in '仓库管理\Gatherfive.pas' {FrmGatherfive},
  Gathersix in '仓库管理\Gathersix.pas' {FrmGathersix},
  Login in '基类窗体\Login.pas' {FrmLogin},
  md5 in '基类窗体\md5.pas',
  PassWordEdit in '基类窗体\PassWordEdit.pas' {FrmPassWordEdit},
  User in '基类窗体\User.pas' {FrmUser},
  UserEdit in '基类窗体\UserEdit.pas' {FrmUserEdit},
  QueryData in '基类窗体\QueryData.pas' {FrmQueryData},
  ReportToolManage in '基类窗体\ReportToolManage.pas',
  ReportForm in '基类窗体\ReportForm.pas' {FrmReport},
  BillQuery in '基类窗体\BillQuery.pas' {FrmBillQuery},
  Spell in '基类窗体\spell.pas',
  IMCode in '基类窗体\IMCode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '进销存系统 1.0';
  Application.CreateForm(TFrmDataModu, FrmDataModu);
  if TFrmLogin.isLogin then
    Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
