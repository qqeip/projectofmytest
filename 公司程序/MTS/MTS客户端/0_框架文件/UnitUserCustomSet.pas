{用到的表alarm_sys_function_set（Kind=1）}
unit UnitUserCustomSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, Menus, cxCheckBox, StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, cxGroupBox, DB, DBClient;

type
  TFormUserCustomSet = class(TForm)
    cxGroupBox1: TcxGroupBox;
    CBIsMTUAlarmRing: TcxCheckBox;
    CBIsDRSAlarmRing: TcxCheckBox;
    BtnSave: TcxButton;
    BtnCancel: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure CBIsShowSuspendWndPropertiesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FIsMTUAlarmRing, FIsDRSAlarmRing: Integer; //0-未选 1-已选
    procedure GetShowInfo;
    procedure SetShowInfo;
    function GetSysTab(aKind, aCode, aType: Integer; aContent: string): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormUserCustomSet: TFormUserCustomSet;

implementation

uses Ut_DataModule, Ut_MainForm;

{$R *.dfm}

procedure TFormUserCustomSet.FormCreate(Sender: TObject);
begin
  GetShowInfo;
  if FIsMTUAlarmRing=1 then
    CBIsMTUAlarmRing.Checked:= True
  else
    CBIsMTUAlarmRing.Checked:= False;
  if FIsDRSAlarmRing=1 then
    CBIsDRSAlarmRing.Checked:= True
  else
    CBIsDRSAlarmRing.Checked:= False;
end;

procedure TFormUserCustomSet.FormShow(Sender: TObject);
begin
//
end;

procedure TFormUserCustomSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormUserCustomSet:=nil;
end;

procedure TFormUserCustomSet.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormUserCustomSet.BtnSaveClick(Sender: TObject);
var
  lSqlStr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  try
    Screen.Cursor:= crHourGlass;
    BtnSave.Enabled:= False;
    SetShowInfo;
    lVariant:= VarArrayCreate([0,1],varVariant);
  { MTU响铃时是否提示 }
    if GetSysTab(1,Fm_MainForm.PublicParam.userid,2,' and content=''1''')>0 then     //有数据时
      lSqlStr:= 'update alarm_sys_function_set' +
                '   set setvalue =' + IntToStr(FIsMTUAlarmRing) +
                ' where kind =1' +
                '   and code =' + IntToStr(Fm_MainForm.PublicParam.userid) +
                '   and content =''1''' +
                '   and cityid =' + IntToStr(Fm_MainForm.PublicParam.cityid)
    else
      lSqlStr:= 'insert into alarm_sys_function_set' +
                '  (code, content, setvalue, kind, kindnote, cityid)' + 
                'values(' +
                IntToStr(Fm_MainForm.PublicParam.userid) + ',''' +
                '1' + ''',' +
                IntToStr(FIsMTUAlarmRing) + ',1,''' +
                'MTU响铃提示设置' + ''',' +
                IntToStr(Fm_MainForm.PublicParam.cityid) + ')';
    lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  { DRS响铃时是否提示 }
    if GetSysTab(1,Fm_MainForm.PublicParam.userid,2,' and content=''2''')>0 then     //有数据时
      lSqlStr:= 'update alarm_sys_function_set' +
                '   set setvalue =' + IntToStr(FIsDRSAlarmRing) +
                ' where kind =1' +
                '   and code =' + IntToStr(Fm_MainForm.PublicParam.userid) +
                '   and content =''2''' +
                '   and cityid =' + IntToStr(Fm_MainForm.PublicParam.cityid)
    else
      lSqlStr:= 'insert into alarm_sys_function_set' +
                '  (code, content, setvalue, kind, kindnote, cityid)' + 
                'values(' +
                IntToStr(Fm_MainForm.PublicParam.userid) + ',''' +
                '2' + ''',' +
                IntToStr(FIsDRSAlarmRing) + ',1,''' +
                '直放站响铃提示设置' + ''',' +
                IntToStr(Fm_MainForm.PublicParam.cityid) + ')';
      lVariant[1]:= VarArrayOf([2,4,13,lSqlstr]);
    lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
      Application.MessageBox('保存成功','提示',MB_OK+64)
    else
      Application.MessageBox('保存失败','提示',MB_OK+64);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormUserCustomSet.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

function TFormUserCustomSet.GetSysTab(aKind, aCode, aType: Integer; aContent: string): Integer;
var      //aType 1- 查询 2- 保存
  lSqlStr: string;
  lClientDataSet: TClientDataSet;
begin
  Result:= -1;
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lSqlStr:= 'select SetValue from alarm_sys_function_set where kind=' +
                IntToStr(aKind) +
                ' and code=' +
                IntToStr(aCode) + aContent;
      ProviderName:= 'dsp_General_data';
      Data:= Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlStr]),0);
      if aType=1 then
      begin
        if RecordCount=1 then
          Result:= FieldByName('SetValue').AsInteger;
      end
      else if aType=2 then
      begin
        if IsEmpty then Result:= 0
        else Result:= RecordCount;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormUserCustomSet.GetShowInfo;
begin
  FIsMTUAlarmRing:= GetSysTab(1,Fm_MainForm.PublicParam.userid,1,' and content=''1''');
  FIsDRSAlarmRing:= GetSysTab(1,Fm_MainForm.PublicParam.userid,1,' and content=''2''');
end;

procedure TFormUserCustomSet.SetShowInfo;
begin
  if CBIsMTUAlarmRing.Checked then
    FIsMTUAlarmRing:= 1
  else
    FIsMTUAlarmRing:= 0;
  if CBIsDRSAlarmRing.Checked then
    FIsDRSAlarmRing:= 1
  else
    FIsDRSAlarmRing:= 0;
end;

procedure TFormUserCustomSet.CBIsShowSuspendWndPropertiesChange(
  Sender: TObject);
begin
  BtnSave.Enabled:= True;
end;

end.
