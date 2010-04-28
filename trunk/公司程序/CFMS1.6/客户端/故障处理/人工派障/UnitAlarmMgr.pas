unit UnitAlarmMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, cxGraphics, cxTextEdit, StdCtrls,
  cxMaskEdit, cxDropDownEdit, cxControls, cxContainer, cxEdit, cxGroupBox,
  cxButtons;

type
  TFormAlarmMgr = class(TForm)
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxGroupBox1: TcxGroupBox;
    CbbAlarmLevel: TcxComboBox;
    CbbAlarmType: TcxComboBox;
    CbbIsAutoWrecker: TcxComboBox;
    CbbIsAutoCommit: TcxComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EdtAlarmName: TcxTextEdit;
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAlarmMgr: TFormAlarmMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormAlarmMgr.FormCreate(Sender: TObject);
begin
  GetDicItem(gPublicParam.cityid,3,CbbAlarmLevel.Properties.Items);
  GetDicItem(gPublicParam.cityid,2,CbbAlarmType.Properties.Items);
end;

procedure TFormAlarmMgr.FormShow(Sender: TObject);
begin
//
end;

procedure TFormAlarmMgr.cxButton1Click(Sender: TObject);
begin
  if EdtAlarmName.Text= '' then
  begin
    Application.MessageBox('告警内容名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if CbbAlarmLevel.Properties.Items.IndexOf(CbbAlarmLevel.Text)=-1 then
  begin
    Application.MessageBox('请先选择告警等级！','提示',MB_OK+64);
    Exit;
  end;
  if CbbAlarmType.Properties.Items.IndexOf(CbbAlarmType.Text)=-1 then
  begin
    Application.MessageBox('请先选择告警类型！','提示',MB_OK+64);
    Exit;
  end;
  ModalResult:= mrOk;
end;

procedure TFormAlarmMgr.cxButton2Click(Sender: TObject);
begin
  Close;
end;


end.
