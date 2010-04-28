unit UnitSystemMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ImgList, dxsbar, ExtCtrls, cxLookAndFeelPainters,
  Menus, StdCtrls, cxButtons, cxControls, cxContainer, cxEdit, cxGroupBox,
  WinSkinData, cxGraphics;

type
  TMyFrame = class of TFrame;
  TFormSystemMgr = class(TForm)
    dxSideBar: TdxSideBar;
    dxSideBarStore: TdxSideBarStore;
    ActionList: TActionList;
    imgSmall: TImageList;
    Act_RingSet: TAction;
    dxSideBarStoreItem1: TdxStoredSideItem;
    Splitter1: TSplitter;
    Act_SendRuleSet: TAction;
    Panel1: TPanel;
    dxSideBarStoreItem2: TdxStoredSideItem;
    dxSideBarStoreItem3: TdxStoredSideItem;
    Act_AlarmInfoSet: TAction;
    Act_AlarmAndSolutionSet: TAction;
    Act_DictSet: TAction;
    dxSideBarStoreItem4: TdxStoredSideItem;
    dxSideBarStoreItem5: TdxStoredSideItem;
    Act_AdvSendRuleSet: TAction;
    dxSideBarStoreItem6: TdxStoredSideItem;
    cxImageList1: TcxImageList;
    procedure Act_RingSetExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Act_SendRuleSetExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Act_AlarmInfoSetExecute(Sender: TObject);
    procedure Act_AlarmAndSolutionSetExecute(Sender: TObject);
    procedure Act_DictSetExecute(Sender: TObject);
    procedure Act_AdvSendRuleSetExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSystemMgr: TFormSystemMgr;

implementation

uses UnitRingMgr, UnitDllCommon, UnitDictMgr, UnitAlarmAndSolutionMgr,
  UnitAlarmInfoSet, UnitSendRulerSet, UnitAdvSendRuleSet;

{$R *.dfm}

procedure TFormSystemMgr.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormSystemMgr.FormShow(Sender: TObject);
begin
//
end;

procedure TFormSystemMgr.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormSystemMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(FormRingMgr) then
    FreeAndNil(FormRingMgr);
  if Assigned(FormDictMgr) then
    FreeAndNil(FormDictMgr);
  if Assigned(FormAlarmAndSolutionMgr) then
    FreeAndNil(FormAlarmAndSolutionMgr);
  if Assigned(FormAlarmInfoSet) then
    FreeAndNil(FormAlarmInfoSet);
  if Assigned(FormSendRulerSet) then
    FreeAndNil(FormSendRulerSet);
  if Assigned(FormAdvSendRuleSet) then
    FreeAndNil(FormAdvSendRuleSet);
  inherited;
  gDllMsgCall(FormSystemMgr,1,'','');
end;

procedure TFormSystemMgr.Act_RingSetExecute(Sender: TObject);  //响铃设置
begin
  if not Assigned(FormRingMgr) then
    FormRingMgr:= TFormRingMgr.Create(FormSystemMgr);
  FormRingMgr.Parent:= Panel1;
  FormRingMgr.WindowState:= wsMaximized;
  FormRingMgr.Show;
end;

procedure TFormSystemMgr.Act_SendRuleSetExecute(Sender: TObject); //派障规则设置
begin
  if not Assigned(FormSendRulerSet) then
    FormSendRulerSet:= TFormSendRulerSet.Create(FormSystemMgr);
  FormSendRulerSet.Parent:= Panel1;
  FormSendRulerSet.WindowState:= wsMaximized;
  FormSendRulerSet.Show;    
end;

procedure TFormSystemMgr.Act_AlarmInfoSetExecute(Sender: TObject);  //告警相关设置
begin
  if not Assigned(FormAlarmInfoSet) then
    FormAlarmInfoSet:= TFormAlarmInfoSet.Create(FormSystemMgr);
  FormAlarmInfoSet.Parent:= Panel1;
  FormAlarmInfoSet.WindowState:= wsMaximized;
  FormAlarmInfoSet.Show;
end;

procedure TFormSystemMgr.Act_AlarmAndSolutionSetExecute(Sender: TObject); //故障原因设置
begin
  if not Assigned(FormAlarmAndSolutionMgr) then
    FormAlarmAndSolutionMgr:= TFormAlarmAndSolutionMgr.Create(FormSystemMgr);
  FormAlarmAndSolutionMgr.Parent:= Panel1;
  FormAlarmAndSolutionMgr.WindowState:= wsMaximized;
  FormAlarmAndSolutionMgr.Show;
end;

procedure TFormSystemMgr.Act_DictSetExecute(Sender: TObject);  //字典管理
begin
  if not Assigned(FormDictMgr) then
    FormDictMgr:= TFormDictMgr.Create(FormSystemMgr);
  FormDictMgr.Parent:= Panel1;
  FormDictMgr.WindowState:= wsMaximized;
  FormDictMgr.Show;
end;

procedure TFormSystemMgr.Act_AdvSendRuleSetExecute(Sender: TObject);
begin
  if not Assigned(FormAdvSendRuleSet) then
    FormAdvSendRuleSet:= TFormAdvSendRuleSet.Create(FormSystemMgr);
  FormAdvSendRuleSet.Parent:= Panel1;
  FormAdvSendRuleSet.WindowState:= wsMaximized;
  FormAdvSendRuleSet.Show;
end;

end.
