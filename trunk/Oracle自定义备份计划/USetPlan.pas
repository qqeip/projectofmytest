unit USetPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin, IniFiles;

type
  TFormSetPlan = class(TForm)
    GrpDay: TGroupBox;
    GrpWeek: TGroupBox;
    GrpMonth: TGroupBox;
    GrpEveryDayFreq: TGroupBox;
    BtnOK: TButton;
    BtnCancel: TButton;
    RgOccurFreq: TGroupBox;
    RbDay: TRadioButton;
    RbWeek: TRadioButton;
    RbMonth: TRadioButton;
    SeMonth_DayNum: TSpinEdit;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    RbSunday: TRadioButton;
    RbMonday: TRadioButton;
    RbTuesday: TRadioButton;
    RbWednesday: TRadioButton;
    RbSaturday: TRadioButton;
    RbFriday: TRadioButton;
    RbThursday: TRadioButton;
    DTPlanTime: TDateTimePicker;
    procedure BtnCancelClick(Sender: TObject);
    procedure RbWeekClick(Sender: TObject);
    procedure RbMonthClick(Sender: TObject);
    procedure RbDayClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitialState;
    procedure SetStatus;
    procedure GetStatus;
    procedure SetCustomInfo;
  end;

var
  FormSetPlan: TFormSetPlan;

implementation

uses UnitPublic;

{$R *.dfm}

procedure TFormSetPlan.InitialState;
begin
  GrpDay.Visible   := False;
  GrpWeek.Visible  := False;
  GrpMonth.Visible := False;
end;

procedure TFormSetPlan.RbDayClick(Sender: TObject);
begin
  if RbDay.Checked then begin
    GrpDay.Visible   := False;
    GrpWeek.Visible  := False;
    GrpMonth.Visible := False;
  end;
end;

procedure TFormSetPlan.RbWeekClick(Sender: TObject);
begin
  if RbWeek.Checked then begin
    GrpDay.Visible   := False;
    GrpWeek.Visible  := True;
    GrpMonth.Visible := False;
  end;
end;

procedure TFormSetPlan.RbMonthClick(Sender: TObject);
begin
  if RbMonth.Checked then begin
    GrpDay.Visible   := False;
    GrpWeek.Visible  := False;
    GrpMonth.Visible := True;
  end;
end;

procedure TFormSetPlan.SetStatus;
begin
  if RbDay.Checked then fSetPlan.fPlantype := EveryDay;
  if RbWeek.Checked then fSetPlan.fPlantype := EveryWeek;
  if RbMonth.Checked then fSetPlan.fPlantype := EveryMonth;
  fSetPlan.fPlanMonth:= SeMonth_DayNum.Value;
  //---�ж�ѡ���Ǹ�����
  if RbMonday.Checked    then fSetPlan.fPlanWeek := 2;
  if RbTuesday.Checked   then fSetPlan.fPlanWeek := 3;
  if RbWednesday.Checked then fSetPlan.fPlanWeek := 4;
  if RbThursday.Checked  then fSetPlan.fPlanWeek := 5;
  if RbFriday.Checked    then fSetPlan.fPlanWeek := 6;
  if RbSaturday.Checked  then fSetPlan.fPlanWeek := 7;
  if RbSunday.Checked    then fSetPlan.fPlanWeek := 1;
  fSetPlan.fPlanTime:= TimeToInt(DTPlanTime.Time);
end;

procedure TFormSetPlan.GetStatus;
begin
  if fSetPlan.fPlantype = EveryDay then RbDay.Checked := True;
  if fSetPlan.fPlantype = EveryWeek then RbWeek.Checked := True;
  if fSetPlan.fPlantype = EveryMonth then RbMonth.Checked := True;
  SeMonth_DayNum.Value := fSetPlan.fPlanMonth ;
  //---�ж�ѡ���Ǹ�����
  if fSetPlan.fPlanWeek = 2 then RbMonday.Checked   := True;
  if fSetPlan.fPlanWeek = 3 then RbTuesday.Checked  := True;
  if fSetPlan.fPlanWeek = 4 then RbWednesday.Checked:= True;
  if fSetPlan.fPlanWeek = 5 then RbThursday.Checked := True;
  if fSetPlan.fPlanWeek = 6 then RbFriday.Checked   := True;
  if fSetPlan.fPlanWeek = 7 then RbSaturday.Checked := True ;
  if fSetPlan.fPlanWeek = 1 then RbSunday.Checked   := True;
  DTPlanTime.Time := IntTotime(fSetPlan.fPlanTime);
end;

procedure TFormSetPlan.SetCustomInfo;
 var ftemp: string;
begin
  if RbDay.Checked then
    CustomInfo:= 'ÿ���� ' + TimeToStr(DTPlanTime.Time) + 'ʱִ��';
  if RbWeek.Checked then
  begin
    if RbMonday.Checked    then ftemp:= '��һ';
    if RbTuesday.Checked   then ftemp:= '�ܶ�';
    if RbWednesday.Checked then ftemp:= '����';
    if RbThursday.Checked  then ftemp:= '����';
    if RbFriday.Checked    then ftemp:= '����';
    if RbSaturday.Checked  then ftemp:= '����';
    if RbSunday.Checked    then ftemp:= '����';
    CustomInfo:= 'ÿ' + ftemp + '��' + TimeToStr(DTPlanTime.Time) + 'ʱִ��';
  end;
  if RbMonth.Checked then
    CustomInfo:= 'ÿ����' + IntToStr(SeMonth_DayNum.Value) + '�ŵ� ' + TimeToStr(DTPlanTime.Time) + 'ʱִ��';
end;

procedure TFormSetPlan.BtnOKClick(Sender: TObject);
begin
  BtnOKStatus := True;
  SetStatus;
  SetCustomInfo;
  close;
end;

procedure TFormSetPlan.BtnCancelClick(Sender: TObject);
begin
  BtnOKStatus := False;
  close;
end;

procedure TFormSetPlan.FormShow(Sender: TObject);
begin
  GetStatus;
end;


end.
