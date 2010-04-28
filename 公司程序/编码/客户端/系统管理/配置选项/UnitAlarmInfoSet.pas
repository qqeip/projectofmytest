unit UnitAlarmInfoSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxGraphics, ImgList, ComCtrls, ToolWin,
  StdCtrls, Spin, cxCheckBox, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxGroupBox, cxRadioGroup, cxControls, cxContainer, cxEdit, DBClient,
  jpeg, ExtCtrls;

type
  TFormAlarmInfoSet = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxRG_RemoveMethod: TcxRadioGroup;
    cxRG_Reasion: TcxRadioGroup;
    cxGroupBox2: TcxGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    SE_Cause: TcxComboBox;
    cb_wrecker: TcxCheckBox;
    cxGroupBox4: TcxGroupBox;
    Label12: TLabel;
    Label10: TLabel;
    Label16: TLabel;
    Label11: TLabel;
    SE_tq: TSpinEdit;
    SE_jg: TSpinEdit;
    cxGroupBox6: TcxGroupBox;
    Label14: TLabel;
    SE_Wreck: TSpinEdit;
    cxRGDiachronic: TcxRadioGroup;
    ToolBar1: TToolBar;
    ToolBtnRemoveMethod: TToolButton;
    ToolBtnReasion: TToolButton;
    ToolBtnDiachronic: TToolButton;
    ToolBtnWreck: TToolButton;
    ToolBtnCause: TToolButton;
    ToolBtnExpireAlarm: TToolButton;
    ToolBtnClose: TToolButton;
    ToolButton15: TToolButton;
    ImageList1: TImageList;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Image5: TImage;
    cxGroupBox3: TcxGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    SE_Min: TSpinEdit;
    Label4: TLabel;
    SE_Time: TSpinEdit;
    Label5: TLabel;
    ToolBtnRepeatAlarm: TToolButton;
    procedure ToolBtnCloseClick(Sender: TObject);
    procedure ToolBtnRemoveMethodClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure ToolBtnCauseClick(Sender: TObject);
    procedure cxRG_RemoveMethodPropertiesChange(Sender: TObject);
    procedure cxRG_ReasionPropertiesChange(Sender: TObject);
    procedure cxRGDiachronicPropertiesChange(Sender: TObject);
    procedure SE_WreckChange(Sender: TObject);
    procedure SE_CausePropertiesChange(Sender: TObject);
    procedure cb_wreckerPropertiesChange(Sender: TObject);
    procedure SE_tqChange(Sender: TObject);
    procedure SE_MinChange(Sender: TObject);
  private
    procedure InitSetInfo;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAlarmInfoSet: TFormAlarmInfoSet;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormAlarmInfoSet.FormCreate(Sender: TObject);
begin
  InitSetInfo;
end;

procedure TFormAlarmInfoSet.FormShow(Sender: TObject);
var
  i: Integer;
begin
  with ToolBar1 do
  begin
    for i:=0 to ControlCount-1 do
    begin
      Controls[i].Enabled:= False;
    end;
  end;
  ToolBtnClose.Enabled:= True;
end;

procedure TFormAlarmInfoSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormAlarmInfoSet.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormAlarmInfoSet.InitSetInfo;
var i: Integer;
  function GetSetValue(aCode, aKind, aCityID : Integer): Integer;
  var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
  begin
    lClientDataSet:= TClientDataSet.Create(nil);
    try
      with lClientDataSet do
      begin
        close;
        ProviderName:='dsp_General_data';
        lSqlStr:= 'select SETVALUE from ALARM_SYS_FUNCTION_SET where code='+
                  IntToStr(aCode) +
                  ' and kind=' +
                  IntToStr(aKind) +
                  ' and cityid=' +
                  IntToStr(aCityID);
        Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
        Result:= StrToInt(fieldbyname('SETVALUE').AsString);
      end;
    finally
      lClientDataSet.Free;
    end;
  end;
begin
  cxRG_RemoveMethod.ItemIndex:= GetSetValue(1,24,gPublicParam.cityid);
  cxRG_Reasion.ItemIndex:= GetSetValue(2,24,gPublicParam.cityid);
  cxRGDiachronic.ItemIndex:= GetSetValue(1,29,gPublicParam.cityid)-1;
  SE_Wreck.Value:= GetSetValue(1,27,gPublicParam.cityid);
  SE_Cause.ItemIndex:= GetSetValue(1,23,gPublicParam.cityid)-2;
  if GetSetValue(2,23,gPublicParam.cityid)=0 then
    cb_wrecker.Checked:= False
  else
    cb_wrecker.Checked:= True;
  SE_tq.Value:= GetSetValue(1,28,gPublicParam.cityid);
  SE_jg.Value:= GetSetValue(2,28,gPublicParam.cityid);
  SE_Min.Value:= GetSetValue(1,34,gPublicParam.cityid);
  SE_Time.Value:= GetSetValue(2,34,gPublicParam.cityid);
end;

procedure TFormAlarmInfoSet.ToolBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAlarmInfoSet.ToolBtnRemoveMethodClick(Sender: TObject);
var
  tempbutton:TToolButton;
  lKind, lCode, lSetValue : Integer;
  lVariant: variant;
  lSqlStr, lBoxText : string;
  lIsSuccess : Boolean;
begin
  tempbutton:=sender as TToolButton;
  lVariant:= VarArrayCreate([0,0],varVariant);
  case tempbutton.Tag of
    101:
    begin
      lKind := 24;
      lCode := 1;
      lSetValue := cxRG_RemoveMethod.ItemIndex;
      lBoxText:='<排障方法设置>设置';
    end;
    102:
    begin
      lKind := 24;
      lCode := 2;
      lSetValue := cxRG_Reasion.ItemIndex;
      lBoxText:='<故障原因设置>设置';
    end;
    103:
    begin
      lKind:= 29;
      lCode:= 1;
      lSetValue:= cxRGDiachronic.ItemIndex + 1;
      lBoxText:='<告警历时>设置';
    end;
    104:
    begin
      lKind:= 27;
      lCode:= 1;
      lSetValue:= SE_Wreck.Value;
      lBoxText:='<自动消障时限设置>设置';
    end;
  end;
  lSqlstr := 'update alarm_sys_function_set set setvalue=' +
             IntToStr(lSetValue) +
             ' where cityid=' + IntToStr(gPublicParam.cityid) + 
             ' and kind=' + IntToStr(lKind) +
             ' and code=' + IntToStr(lCode);
  lVariant[0]:= VarArrayOf([lSqlstr]);
  lIsSuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lIsSuccess then
    Application.MessageBox(PChar(lBoxText+'成功!'),'提示',mb_ok+mb_defbutton1)
  else
    Application.MessageBox(PChar(lBoxText+'失败!'),'提示',mb_ok+mb_defbutton1);
  tempbutton.Enabled:= False;
end;

procedure TFormAlarmInfoSet.ToolBtnCauseClick(Sender: TObject);
var
  tempbutton:TToolButton;
  lSetValue : Integer;
  lVariant: variant;
  lSqlStr, lBoxText : string;
  lIsSuccess : Boolean;
begin
  tempbutton:=sender as TToolButton;
  lVariant:= VarArrayCreate([0,1],varVariant);
  case tempbutton.Tag of
    105:
    begin
      lSqlstr := 'update alarm_sys_function_set set setvalue=' +
             IntToStr(SE_Cause.ItemIndex+2) +
             ' where cityid=' + IntToStr(gPublicParam.cityid) + 
             ' and kind=' + IntToStr(23) +
             ' and code=' + IntToStr(1);
      lVariant[0]:= VarArrayOf([lSqlstr]);
      if cb_wrecker.Checked then
        lSetValue:=1
      else
        lSetValue:=0;
      lSqlstr := 'update alarm_sys_function_set set setvalue=' +
             IntToStr(lSetValue) +
             ' where cityid=' + IntToStr(gPublicParam.cityid) + 
             ' and kind=' + IntToStr(23) +
             ' and code=' + IntToStr(2);
      lVariant[1]:= VarArrayOf([lSqlstr]);
      lIsSuccess:= gTempInterface.ExecBatchSQL(lVariant);
      ToolBtnCause.Enabled:= False;
      lBoxText:='<故障原因级数设置>设置';
    end;
    106:
    begin
      lSetValue:= SE_tq.Value;
      lSqlstr := 'update alarm_sys_function_set set setvalue=' +
             IntToStr(lSetValue) +
             ' where cityid=' + IntToStr(gPublicParam.cityid) +
             ' and kind=' + IntToStr(28) +
             ' and code=' + IntToStr(1);
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lSetValue:= SE_jg.Value;
      lSqlstr := 'update alarm_sys_function_set set setvalue=' +
             IntToStr(lSetValue) +
             ' where cityid=' + IntToStr(gPublicParam.cityid) + 
             ' and kind=' + IntToStr(28) +
             ' and code=' + IntToStr(2);
      lVariant[1]:= VarArrayOf([lSqlstr]);
      lIsSuccess:= gTempInterface.ExecBatchSQL(lVariant);
      ToolBtnExpireAlarm.Enabled:= False;
      lBoxText:='<即将到期告警提示设置>设置';
    end;
    107:
    begin
      lSetValue:= SE_Min.Value;
      if lSetValue>24 then
      begin
        if (lSetValue/24/se_time.Value)>1 then
        begin
          Application.MessageBox('设置间隔太小！天数除以次数要小于1！','提示',MB_OK+64);
          Exit;
        end;
      end;
      lSqlstr := 'update alarm_sys_function_set set setvalue=' +
             IntToStr(lSetValue) +
             ' where cityid=' + IntToStr(gPublicParam.cityid) +
             ' and kind=' + IntToStr(34) +
             ' and code=' + IntToStr(1);
      lVariant[0]:= VarArrayOf([lSqlstr]);
      lSetValue:= SE_Time.Value;
      lSqlstr := 'update alarm_sys_function_set set setvalue=' +
             IntToStr(lSetValue) +
             ' where cityid=' + IntToStr(gPublicParam.cityid) +
             ' and kind=' + IntToStr(34) +
             ' and code=' + IntToStr(2);
      lVariant[1]:= VarArrayOf([lSqlstr]);
      lIsSuccess:= gTempInterface.ExecBatchSQL(lVariant);
      ToolBtnExpireAlarm.Enabled:= False;
      lBoxText:='<重复告警设置>设置';
    end;
  end;
  if lIsSuccess then
    Application.MessageBox(PChar(lBoxText+'成功!'),'提示',mb_ok+mb_defbutton1)
  else
    Application.MessageBox(PChar(lBoxText+'失败!'),'提示',mb_ok+mb_defbutton1);
end;

procedure TFormAlarmInfoSet.cxRG_RemoveMethodPropertiesChange(
  Sender: TObject);
begin
  ToolBtnRemoveMethod.Enabled:= True;
end;

procedure TFormAlarmInfoSet.cxRG_ReasionPropertiesChange(Sender: TObject);
begin
  ToolBtnReasion.Enabled:= True;
end;

procedure TFormAlarmInfoSet.cxRGDiachronicPropertiesChange(
  Sender: TObject);
begin
  ToolBtnDiachronic.Enabled:= True;
end;

procedure TFormAlarmInfoSet.SE_WreckChange(Sender: TObject);
begin
  ToolBtnWreck.Enabled:= True;
end;

procedure TFormAlarmInfoSet.SE_CausePropertiesChange(Sender: TObject);
begin
  ToolBtnCause.Enabled:= True;
end;

procedure TFormAlarmInfoSet.cb_wreckerPropertiesChange(Sender: TObject);
begin
  ToolBtnCause.Enabled:= True;
end;

procedure TFormAlarmInfoSet.SE_tqChange(Sender: TObject);
begin
  ToolBtnExpireAlarm.Enabled:= True;
end;

procedure TFormAlarmInfoSet.SE_MinChange(Sender: TObject);
begin
  ToolBtnRepeatAlarm.Enabled:= True;
end;

end.
