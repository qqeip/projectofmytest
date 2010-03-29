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
  //---判断选中那个日期
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
  //---判断选中那个日期
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
    CustomInfo:= '每天在 ' + TimeToStr(DTPlanTime.Time) + '时执行';
  if RbWeek.Checked then
  begin
    if RbMonday.Checked    then ftemp:= '周一';
    if RbTuesday.Checked   then ftemp:= '周二';
    if RbWednesday.Checked then ftemp:= '周三';
    if RbThursday.Checked  then ftemp:= '周四';
    if RbFriday.Checked    then ftemp:= '周五';
    if RbSaturday.Checked  then ftemp:= '周六';
    if RbSunday.Checked    then ftemp:= '周日';
    CustomInfo:= '每' + ftemp + '在' + TimeToStr(DTPlanTime.Time) + '时执行';
  end;
  if RbMonth.Checked then
    CustomInfo:= '每月在' + IntToStr(SeMonth_DayNum.Value) + '号的 ' + TimeToStr(DTPlanTime.Time) + '时执行';
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
