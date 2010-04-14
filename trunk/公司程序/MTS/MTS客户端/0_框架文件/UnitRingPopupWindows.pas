unit UnitRingPopupWindows;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, jpeg, ExtCtrls, MMSystem, StdCtrls, Menus,
  cxLookAndFeelPainters, cxButtons, dxGDIPlusClasses;

type
  TFormRingPopupWindows = class(TForm)
    ImgBackgrounds: TImage;
    LabelRemindType: TLabel;
    Btnview: TcxButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BtnviewClick(Sender: TObject);
  private
    { Private declarations }
    FIsRing: Boolean;
    FRingFileName: string;
    FRemindType: Integer; //�������� 0-�����ɵ����� 1-���Ͻ���ʱ��������

    procedure PlayRing;
    procedure StopRing;

  public
    { Public declarations }
//    property IsRing:Boolean read FIsRing write FIsRing;
//    property RingFileName: string read FRingFileName write FRingFileName;
//    property RemindType: Integer read FRemindType write FRemindType;

    constructor Create(AOwner: TComponent; aIsRing: Boolean; aRingFileName: string;
                   aRemindType: Integer);
  end;

const              
  AlarmMTURing = 'MTU�¸澯��������';
  AlarmDRSRing = 'ֱ��վ�¸澯��������';
var
  FormRingPopupWindows: TFormRingPopupWindows;

implementation

uses Ut_DataModule, Ut_MainForm;


{$R *.dfm}

constructor TFormRingPopupWindows.Create(AOwner: TComponent;
  aIsRing: Boolean; aRingFileName: string; aRemindType: Integer);
begin
  inherited create(AOwner);
  FIsRing:= aIsRing;
  FRingFileName:= aRingFileName;
  FRemindType:= aRemindType;
  if FRemindType=1 then
    LabelRemindType.Caption:= AlarmMTURing;
  if FRemindType=2 then
    LabelRemindType.Caption:= AlarmDRSRing;
end;

procedure TFormRingPopupWindows.FormShow(Sender: TObject);
var
  a: TPoint;
begin
  ClientToScreen(a);
  a.X:= Screen.DesktopLeft + Screen.DesktopWidth;
  a.Y:= Screen.DesktopTop + Screen.DesktopHeight;
  ScreenToClient(a);
  Self.Left:= a.X - 195;
  Self.Top:= a.Y - Self.Height - 30;

  AnimateWindow(Handle, 1000, AW_ACTIVATE+AW_VER_NEGATIVE+AW_SLIDE);

  if FIsRing then
    PlayRing;
end;

procedure TFormRingPopupWindows.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  StopRing;
  ANimateWindow(Handle,800,AW_SLIDE+AW_VER_POSITIVE+AW_HIDE);
end;

procedure TFormRingPopupWindows.PlayRing;
begin
  sndPlaySound(pchar(FRingFileName), SND_NODEFAULT Or SND_ASYNC Or SND_LOOP);
end;

procedure TFormRingPopupWindows.StopRing;
var
  lSqlstr: string;
  lsuccess: Boolean;
  lVariant: variant;
begin
  try
    lSqlstr:= 'update alarm_ringremind_info t set t.isremind=0' + ',' +
              'UPDATETIME=sysdate' +
              ' where t.companyid='+
              '(select COMPANYID from userinfo where cityid=' +
              inttostr(Fm_MainForm.PublicParam.CityID) +
              ' and userid=' + IntToStr(Fm_MainForm.PublicParam.userid) +
              ') and cityid=' +
              inttostr(Fm_MainForm.PublicParam.CityID) +
              ' and REMINDTYPE=' + IntToStr(FRemindType);
    lVariant:= VarArrayCreate([0,0],varVariant);
    lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
    lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    sndPlaySound(nil, SND_LOOP);
  finally
  end;
end;

procedure TFormRingPopupWindows.BtnviewClick(Sender: TObject);
begin
  Close;
  UpdateWindow(Self.Handle);
end;

end.
