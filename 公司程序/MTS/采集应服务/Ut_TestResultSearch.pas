unit Ut_TestResultSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, BaseGrid, AdvGrid,AdvGridUnit,StdCtrls, ComCtrls;

type
  PTItemCmd = ^TItemCmd;
  TItemCmd = record
    ItemCode :integer;
    ItemName :String;
  end;
  TFm_TestResult = class(TForm)
    GroupBox1: TGroupBox;
    Adv_TestResult: TAdvStringGrid;
    cbb_cmd: TComboBox;
    Label1: TLabel;
    Dtp_StartDate: TDateTimePicker;
    Label2: TLabel;
    Dtp_StartTime: TDateTimePicker;
    Dtp_EndDate: TDateTimePicker;
    Label3: TLabel;
    Dtp_EndTime: TDateTimePicker;
    Button1: TButton;
    Label4: TLabel;
    Et_TaskId: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Et_MtuNo: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Et_TaskIdKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    FAdvGridSet:TAdvGridSet;
    procedure FillCmd;
    procedure ClearCmd;
  public
    { Public declarations }
  end;

var
  Fm_TestResult: TFm_TestResult;

implementation
uses Ut_Main_Collect;
{$R *.dfm}

procedure TFm_TestResult.Button1Click(Sender: TObject);
const SQLSTR =' select a.taskid 测试任务号,a.collecttime 采集时间,d.mtuno MTU编号,b.comname 命令名称,'+
              ' a.execid 测试序号,c.paramname 参数名称,a.testresult 参数值'+
              ' from mtu_testresult_history a '+
              ' left join mtu_command_define b on a.comid=b.comid'+
              ' left join mtu_param_define c on a.paramid=c.paramid'+
              ' left join mtu_info d on a.mtuid=d.mtuid'+
              ' where 1=1 %s'+
              ' order by a.taskid,a.comid,a.execid,a.paramid,a.valueindex';
var
  wheresql,mysql :String;
begin
  if CheckBox1.Checked  then
    wheresql :=wheresql+' and a.comid='+IntToStr(PTItemCmd(cbb_cmd.Items.Objects[cbb_cmd.ItemIndex]).ItemCode);
  if CheckBox2.Checked then
    wheresql :=wheresql+' and a.collecttime between to_date('''+DateToStr(Dtp_StartDate.Date)+' '+TimeToStr(Dtp_StartTime.Time)+''',''YYYY-MM-DD HH24:MI:SS'')'+
       ' and to_date('''+DateToStr(Dtp_EndDate.Date)+' '+TimeToStr(Dtp_EndTime.Time)+''',''YYYY-MM-DD HH24:MI:SS'')';
  if CheckBox3.Checked  then
  begin
    if Trim(Et_TaskId.Text)='' then
    begin
      Application.MessageBox('请录入测试任务号后再继续!','提示',mb_ok+mb_defbutton1);
      Exit;
    end
    else
      wheresql :=wheresql+' and a.taskid='+Et_TaskId.Text
  end;
  if CheckBox4.Checked then
    wheresql :=wheresql+' and d.mtuno='+QuotedStr(Et_MtuNo.Text);
  mysql:=Format(SQLSTR,[wheresql]);
  with Fm_Main_Collect.AdoQ_Free do
  begin
    Close;
    SQL.Clear;
    SQL.Add(mysql);
    Open;
    FAdvGridSet.DrawGrid(Fm_Main_Collect.AdoQ_Free,Adv_TestResult);
    Close;
  end;
end;

procedure TFm_TestResult.CheckBox1Click(Sender: TObject);
begin
  case TCheckBox(Sender).Tag of
    1:cbb_cmd.Enabled :=TCheckBox(Sender).Checked;
    2:
      begin
        Dtp_StartDate.Enabled := TCheckBox(Sender).Checked;
        Dtp_StartTime.Enabled := TCheckBox(Sender).Checked;
        Dtp_EndDate.Enabled := TCheckBox(Sender).Checked;
        Dtp_EndTime.Enabled := TCheckBox(Sender).Checked;
      end;
    3:Et_TaskId.Enabled := TCheckBox(Sender).Checked;
    4:Et_MtuNo.Enabled := TCheckBox(Sender).Checked;
  end;
end;

procedure TFm_TestResult.ClearCmd;
var
  i : integer;
begin
  for I := cbb_cmd.Items.Count - 1 downto 0 do
  begin
    Dispose(PTItemCmd(cbb_cmd.Items.Objects[i]));
    cbb_cmd.Items.Delete(i);
  end;
end;

procedure TFm_TestResult.Et_TaskIdKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then
    Key := #0;
end;

procedure TFm_TestResult.FillCmd;
var
  P :PTItemCmd;
begin
  ClearCmd;
  with Fm_Main_Collect.AdoQ_Free do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from mtu_command_define where comtype=2');
    Open;
    while not Eof do
    begin
      New(P);
      P^.ItemCode := FieldByName('comid').AsInteger;
      P^.ItemName := FieldByName('comname').AsString;
      cbb_cmd.Items.AddObject(P^.ItemName,TObject(P));
      Next;
    end;
    Close;
  end;
  if cbb_cmd.Items.Count > 0 then
    cbb_cmd.ItemIndex :=0;
end;

procedure TFm_TestResult.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FAdvGridSet.Free;
  ClearCmd;
end;

procedure TFm_TestResult.FormCreate(Sender: TObject);
begin
  FAdvGridSet:=TAdvGridSet.Create;
  FAdvGridSet.AddGrid(Adv_TestResult);
  FAdvGridSet.SetGridStyle;
end;

procedure TFm_TestResult.FormShow(Sender: TObject);
begin
  Dtp_StartDate.Date := Date-1;
  Dtp_EndDate.Date := Date+1;
  Dtp_StartTime.Time := now;
  Dtp_EndTime.Time := now;
  self.Width :=980;
  FillCmd;
end;

end.
