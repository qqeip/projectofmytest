{用到的表alarm_sys_function_set（Kind=35）}
unit UnitUserCustomSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, Menus, cxCheckBox, StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, cxGroupBox, DB, DBClient;

type
  TFormUserCustomSet = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxGroupBox2: TcxGroupBox;
    BtnSave: TcxButton;
    BtnCancel: TcxButton;
    CBIsShowSuspendWnd: TcxCheckBox;
    CBIsSendAlarmRing: TcxCheckBox;
    CBIsOvertimeRing: TcxCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure CBIsShowSuspendWndPropertiesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FIsShowSuspendWnd, FIsSendAlarmRing, FIsOvertimeRing: Integer; //0-未选 1-已选
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

uses UnitDllCommon;

{$R *.dfm}

procedure TFormUserCustomSet.FormCreate(Sender: TObject);
begin
  Self.Font.Charset:= GB2312_CHARSET;
  Self.Font.Height:= -12;
  Self.Font.Name:= '宋体';
  Self.Font.Size:= 9;

  GetShowInfo;
  if FIsShowSuspendWnd=1 then
    CBIsShowSuspendWnd.Checked:= True
  else
    CBIsShowSuspendWnd.Checked:= False;
  if FIsSendAlarmRing=1 then
    CBIsSendAlarmRing.Checked:= True
  else
    CBIsSendAlarmRing.Checked:= False;
  if FIsOvertimeRing=1 then
    CBIsOvertimeRing.Checked:= True
  else
    CBIsOvertimeRing.Checked:= False;
end;

procedure TFormUserCustomSet.FormShow(Sender: TObject);
begin
//
end;

procedure TFormUserCustomSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormUserCustomSet,1,'','');
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
    lVariant:= VarArrayCreate([0,2],varVariant);
    if GetSysTab(36,gPublicParam.userid,2,'')>0 then     //有数据时     悬浮窗设置
      lSqlStr:= 'update alarm_sys_function_set' +
                '   set setvalue =' + IntToStr(FIsShowSuspendWnd) +
                ' where kind =36' +
                '   and cityid =' + IntToStr(gPublicParam.cityid)

    else
      lSqlStr:= 'insert into alarm_sys_function_set' +
                '  (code, content, setvalue, kind, kindnote, cityid)' +
                'values(' +
                IntToStr(gPublicParam.userid) + ',''' +
                '用户自定义是否显示悬浮窗' + ''',' +
                IntToStr(FIsShowSuspendWnd) + ',36,'''+
                '用户自定义是否显示悬浮窗' + ''',' +
                IntToStr(gPublicParam.cityid) + ')';
    lVariant[0]:= VarArrayOf([lSqlstr]);
  { 故障派单响铃时是否提示 }
    if GetSysTab(35,gPublicParam.userid,2,' and content=''1''')>0 then     //有数据时
      lSqlStr:= 'update alarm_sys_function_set' +
                '   set setvalue =' + IntToStr(FIsSendAlarmRing) +
                ' where kind =35' +
                '   and code =' + IntToStr(gPublicParam.userid) +
                '   and content =''1''' +
                '   and cityid =' + IntToStr(gPublicParam.cityid)
    else
      lSqlStr:= 'insert into alarm_sys_function_set' +
                '  (code, content, setvalue, kind, kindnote, cityid)' + #13#10 +
                'values(' +
                IntToStr(gPublicParam.userid) + ',''' +
                '1' + ''',' +
                IntToStr(FIsShowSuspendWnd) + ',35,''' +
                '故障派单响铃设置' + ''',' +
                IntToStr(gPublicParam.cityid) + ')';
    lVariant[1]:= VarArrayOf([lSqlstr]);
  { 故障将超时提醒响铃时是否提示 }
    if GetSysTab(35,gPublicParam.userid,2,' and content=''2''')>0 then     //有数据时
      lSqlStr:= 'update alarm_sys_function_set' +
                '   set setvalue =' + IntToStr(FIsOvertimeRing) +
                ' where kind =35' +
                '   and code =' + IntToStr(gPublicParam.userid) +
                '   and content =''2''' +
                '   and cityid =' + IntToStr(gPublicParam.cityid)
    else
      lSqlStr:= 'insert into alarm_sys_function_set' +
                '  (code, content, setvalue, kind, kindnote, cityid)' + #13#10 +
                'values(' +
                IntToStr(gPublicParam.userid) + ',''' +
                '2' + ''',' +
                IntToStr(FIsOvertimeRing) + ',35,''' +
                '故障将超时响铃设置' + ''',' +
                IntToStr(gPublicParam.cityid) + ')';
      lVariant[2]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
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
var      //aType 0- 查询 1- 保存
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
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
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
  FIsShowSuspendWnd:= GetSysTab(36,gPublicParam.userid,1,''); //登录时是否显示悬浮窗
  FIsSendAlarmRing:= GetSysTab(35,gPublicParam.userid,1,' and content=''1''');
  FIsOvertimeRing:= GetSysTab(35,gPublicParam.userid,1,'and content=''2''');
end;

procedure TFormUserCustomSet.SetShowInfo;
begin
  if CBIsShowSuspendWnd.Checked then
    FIsShowSuspendWnd:= 1
  else
    FIsShowSuspendWnd:= 0;
  if CBIsSendAlarmRing.Checked then
    FIsSendAlarmRing:= 1
  else
    FIsSendAlarmRing:= 0;
  if CBIsOvertimeRing.Checked then
    FIsOvertimeRing:= 1
  else
    FIsOvertimeRing:= 0;
end;

procedure TFormUserCustomSet.CBIsShowSuspendWndPropertiesChange(
  Sender: TObject);
begin
  BtnSave.Enabled:= True;
end;

end.
