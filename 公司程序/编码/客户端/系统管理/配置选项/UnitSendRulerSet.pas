unit UnitSendRulerSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, StdCtrls, cxGroupBox, cxControls,
  cxContainer, cxEdit, cxRadioGroup, ComCtrls, cxTreeView, Spin, cxListBox,
  Buttons, ToolWin, ImgList, StringUtils, DBClient, cxTextEdit, cxMaskEdit,
  cxSpinEdit, cxTimeEdit;

type
  TFormSendRulerSet = class(TForm)
    cxGroupBox8: TcxGroupBox;
    cxGroupBox11: TcxGroupBox;
    cxGroupBox12: TcxGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cxGroupBox13: TcxGroupBox;
    Label18: TLabel;
    Label17: TLabel;
    Sb_Clear: TSpeedButton;
    Sb_Delete: TSpeedButton;
    Sb_Ok: TSpeedButton;
    cxListBox_TheTime: TcxListBox;
    Ed_TheTime: TDateTimePicker;
    cxGroupBox5: TcxGroupBox;
    Label15: TLabel;
    Label3: TLabel;
    SEd_gy: TSpinEdit;
    cxGroupBox7: TcxGroupBox;
    Label4: TLabel;
    Label13: TLabel;
    SEWrecker: TSpinEdit;
    cxGroupBox14: TcxGroupBox;
    cxGroupBox9: TcxGroupBox;
    cxTreeViewDeviceLevel: TcxTreeView;
    cxGroupBox10: TcxGroupBox;
    cxTreeViewContentLevel: TcxTreeView;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolBtnSendType: TToolButton;
    ToolBtnSendWeekSet: TToolButton;
    ToolButton15: TToolButton;
    ToolBtnImmediateSent: TToolButton;
    ToolBtnPointSent: TToolButton;
    ToolBtnMeddle: TToolButton;
    ToolBtnWrecker: TToolButton;
    ToolButton1: TToolButton;
    ToolBtnClose: TToolButton;
    cxGroupBox1: TcxGroupBox;
    cxRG_SendType: TcxRadioGroup;
    cxGroupBoxSendWeekSet: TcxGroupBox;
    CheckBoxMon: TCheckBox;
    CheckBoxTues: TCheckBox;
    CheckBoxWed: TCheckBox;
    CheckBoxThurs: TCheckBox;
    CheckBoxFriday: TCheckBox;
    CheckBoxSat: TCheckBox;
    CheckBoxSun: TCheckBox;
    ImageList2: TImageList;
    Dtp_Starttime: TcxTimeEdit;
    Dtp_EndTime: TcxTimeEdit;
    procedure ToolBtnCloseClick(Sender: TObject);
    procedure ToolBtnSendTypeClick(Sender: TObject);
    procedure ToolBtnSendWeekSetClick(Sender: TObject);
    procedure ToolBtnImmediateSentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxTreeViewDeviceLevelChange(Sender: TObject;
      Node: TTreeNode);
    procedure cxTreeViewDeviceLevelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxTreeViewContentLevelChange(Sender: TObject;
      Node: TTreeNode);
    procedure cxTreeViewContentLevelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Sb_ClearClick(Sender: TObject);
    procedure SEd_gyClick(Sender: TObject);
    procedure SEWreckerClick(Sender: TObject);
    procedure cxRG_SendTypePropertiesChange(Sender: TObject);
    procedure CheckBoxMonClick(Sender: TObject);
    procedure Dtp_StarttimePropertiesChange(Sender: TObject);
  private
    function GetSqlCount(aDevTree, aAlarmTree: TcxTreeView): Integer;
    function IsExistRecord(aCode, aContent, aKind: Integer): Boolean;
    procedure InitSetInfo;
    procedure LoadLevel(aTreeView: TcxTreeView; aSqlType, aSqlBH,
      aCityID: Integer; aTopNodeTitle: string);
    function GetSetValue(aKind, aCode, aContent, aCityID: Integer): string;
    procedure GetTheTimeList(aKind, aCode, aContent, aCityID: Integer;
      aTheTime: Tstrings);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSendRulerSet: TFormSendRulerSet;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormSendRulerSet.FormCreate(Sender: TObject);
begin
  InitSetInfo;
end;

procedure TFormSendRulerSet.FormShow(Sender: TObject);
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
  LoadLevel(cxTreeViewDeviceLevel,1,231,gPublicParam.cityid,'设备等级');
  LoadLevel(cxTreeViewContentLevel,1,232,gPublicParam.cityid,'告警等级');

end;

procedure TFormSendRulerSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormSendRulerSet.ToolBtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSendRulerSet.ToolBtnSendTypeClick(Sender: TObject);
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
      lKind:= 5;
      lCode:= 1;
      lSetValue:= cxRG_SendType.ItemIndex;
      lBoxText:='<派障形式>设置';
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

procedure TFormSendRulerSet.ToolBtnSendWeekSetClick(Sender: TObject);
var
  lTempButton:TToolButton;
  lKind, lCode, lSetValue, i : Integer;
  lVariant: variant;
  lSqlStr, lBoxText : string;
  lIsSuccess : Boolean;
begin
  lTempButton:=sender as TToolButton;
  lVariant:= VarArrayCreate([0,6],varVariant);
  case lTempButton.Tag of
    102:
    begin
      lKind:= 14;
      with cxGroupBoxSendWeekSet do
      begin
        for i:=0 to ControlCount-1 do
        begin
          if (Controls[i] as TCheckBox).Checked then
            lSetValue:=1
          else
            lSetValue:=0;
          lCode:= i + 1;
          lSqlstr := 'update alarm_sys_function_set set setvalue=' +
                 IntToStr(lSetValue) +
                 ' where cityid=' + IntToStr(gPublicParam.cityid) +
                 ' and kind=' + IntToStr(lKind) +
                 ' and code=' + IntToStr(lCode);
          lVariant[i]:= VarArrayOf([lSqlstr]);
        end;
      end;
      lIsSuccess:= gTempInterface.ExecBatchSQL(lVariant);
      lTempButton.Enabled:= False;
      lBoxText:='<派障星期设置>设置';
    end;
  end;
  if lIsSuccess then
    Application.MessageBox(PChar(lBoxText+'成功!'),'提示',mb_ok+mb_defbutton1)
  else
    Application.MessageBox(PChar(lBoxText+'失败!'),'提示',mb_ok+mb_defbutton1);
end;

procedure TFormSendRulerSet.ToolBtnImmediateSentClick(Sender: TObject);
var
  tempbutton:TToolButton;
  i, j, k, lCount, lCode, lContent, lKind : Integer;
  lVariant: variant;
  lSqlStr, lBoxText : string;
  lIsSuccess : Boolean;
begin
  try
    tempbutton:=sender as TToolButton;
    if GetSqlCount(cxTreeViewDeviceLevel,cxTreeViewContentLevel)=0 then
    begin
      Application.MessageBox('请选择相应的设备等级和告警等级!','提示',mb_ok+mb_defbutton1);
      Exit
    end;

    lCount:=0;
    case tempbutton.Tag of
      201: lVariant:= VarArrayCreate([0,2*GetSqlCount(cxTreeViewDeviceLevel,cxTreeViewContentLevel)-1],varVariant);
      202:
      begin
        lVariant:= VarArrayCreate([0,GetSqlCount(cxTreeViewDeviceLevel,cxTreeViewContentLevel)*(cxListBox_TheTime.Items.Count+1)-1],varVariant);
        if cxListBox_TheTime.Items.Count=0 then
        begin
          Application.MessageBox('请先添加时间点!','提示',mb_ok+mb_defbutton1);
          Exit;
        end;
      end;
      203: lVariant:= VarArrayCreate([0,GetSqlCount(cxTreeViewDeviceLevel,cxTreeViewContentLevel)-1],varVariant);
      204: lVariant:= VarArrayCreate([0,GetSqlCount(cxTreeViewDeviceLevel,cxTreeViewContentLevel)-1],varVariant);
      205: lVariant:= VarArrayCreate([0,GetSqlCount(cxTreeViewDeviceLevel,cxTreeViewContentLevel)-1],varVariant);
    end;

    for i:=0 to cxTreeViewDeviceLevel.Items.Count-1 do
    begin
      if (cxTreeViewDeviceLevel.Items[i].ImageIndex=1) and (cxTreeViewDeviceLevel.Items[i].Level<>0) then
      begin
        for j:=0 to cxTreeViewContentLevel.Items.Count-1 do
        begin
          if (cxTreeViewContentLevel.Items[j].ImageIndex=1) and (cxTreeViewContentLevel.Items[j].Level<>0) then
          begin
            lCode:= TWdInteger(cxTreeViewContentLevel.Items[j].Data).Value;
            lContent:= TWdInteger(cxTreeViewDeviceLevel.Items[i].Data).Value;
            case tempbutton.Tag of
              201:
              begin
                lKind:=20;//派障起始时间
                if IsExistRecord(lCode,lContent,lKind) then
                begin
                  lSqlStr:= 'update ALARM_SYS_FUNCTION_SET set setvalue=''' + FormatdateTime('HH:mm:ss',Dtp_Starttime.Time) +
                            ''' where code=' + IntToStr(lCode) +
                            ' and content=' + IntToStr(lContent) +
                            ' and kind=' + IntToStr(lKind);
                  lVariant[2*lCount]:= VarArrayOf([lSqlstr]);
                end
                else
                begin
                  lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
                            IntToStr(lCode) + ',''' +
                            IntToStr(lContent) + ''',''' +
                            FormatdateTime('HH:mm:ss',Dtp_Starttime.Time) + ''',' +
                            IntToStr(lKind) + ',''' +
                            '派障起始时间' + ''',' +
                            IntToStr(gPublicParam.cityid) +')';
                  lVariant[2*lCount]:= VarArrayOf([lSqlstr]);
                end;
                lKind:=21;//派障截止时间
                if IsExistRecord(lCode,lContent,lKind) then
                begin
                  lSqlStr:= 'update ALARM_SYS_FUNCTION_SET set setvalue=''' + FormatdateTime('HH:mm:ss',Dtp_EndTime.Time) +
                            ''' where code=' + IntToStr(lCode) +
                            ' and content=' + IntToStr(lContent) +
                            ' and kind=' + IntToStr(lKind);
                  lVariant[2*lCount+1]:= VarArrayOf([lSqlstr]);
                end
                else
                begin
                  lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
                            IntToStr(lCode) + ',''' +
                            IntToStr(lContent) + ''',''' +
                            FormatdateTime('HH:mm:ss',Dtp_EndTime.Time) + ''',' +
                            IntToStr(lKind) + ',''' +
                            '派障起始时间' + ''',' +
                            IntToStr(gPublicParam.cityid) +')';
                  lVariant[2*lCount+1]:= VarArrayOf([lSqlstr]);
                end;
              end;
              202:  //[2-02]定点派障时点
              begin
                lKind:= 7;
                lSqlStr:= 'delete from ALARM_SYS_FUNCTION_SET ' +
                          ' where code=' + IntToStr(lCode) +
                          ' and content=''' + IntToStr(lContent) +
                          ''' and kind=' + IntToStr(lKind);
                lVariant[lcount]:= VarArrayOf([lSqlstr]);
                for k:=0 to cxListBox_TheTime.Items.Count-1 do
                begin
                  lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
                            IntToStr(lCode) + ',''' +
                            IntToStr(lContent) + ''',''' +
                            cxListBox_TheTime.Items.Strings[k] + ''',' +
                            IntToStr(lKind) + ',''' +
                            '定点派障' + ''',' +
                            IntToStr(gPublicParam.cityid) +')';
                  lVariant[lCount+k+1]:= VarArrayOf([lSqlstr]);
                end;
                lcount:=lCount+k;
              end;
              203:   //干预派障时限设置
              begin
                lKind:=18;
                if IsExistRecord(lCode,lContent,lKind) then
                begin
                  lSqlStr:= 'update ALARM_SYS_FUNCTION_SET set setvalue=''' + IntToStr(SEd_gy.Value) +
                            ''' where code=' + IntToStr(lCode) +
                            ' and content=' + IntToStr(lContent) +
                            ' and kind=' + IntToStr(lKind);
                  lVariant[lCount]:= VarArrayOf([lSqlstr]);
                end
                else
                begin
                  lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
                            IntToStr(lCode) + ',''' +
                            IntToStr(lContent) + ''',''' +
                            IntToStr(SEd_gy.Value) + ''',' +
                            IntToStr(lKind) + ',''' +
                            '干预派障时限设置' + ''',' +
                            IntToStr(gPublicParam.cityid) +')';
                  lVariant[lCount]:= VarArrayOf([lSqlstr]);
                end;
              end;
              204:
              begin
                lKind:=3;   //排障时限
                if IsExistRecord(lCode,lContent,lKind) then
                begin
                  lSqlStr:= 'update ALARM_SYS_FUNCTION_SET set setvalue=''' + IntToStr(SEWrecker.Value) +
                            ''' where code=' + IntToStr(lCode) +
                            ' and content=' + IntToStr(lContent) +
                            ' and kind=' + IntToStr(lKind);
                  lVariant[lCount]:= VarArrayOf([lSqlstr]);
                end
                else
                begin
                  lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
                            IntToStr(lCode) + ',''' +
                            IntToStr(lContent) + ''',''' +
                            IntToStr(SEWrecker.Value) + ''',' +
                            IntToStr(lKind) + ',''' +
                            '排障时限' + ''',' +
                            IntToStr(gPublicParam.cityid) +')';
                  lVariant[lCount]:= VarArrayOf([lSqlstr]);
                end;
              end;
            end;
            inc(lCount)
          end;
        end;
      end;
    end;

    lIsSuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lIsSuccess then
    begin
      Application.MessageBox('<派障时间设置>保存成功!','提示',mb_ok+mb_defbutton1);
      tempbutton.Enabled:= False;
    end
    else
      Application.MessageBox('<派障时间设置>保存失败!','提示',mb_ok+mb_defbutton1);
  except
    Application.MessageBox('保存失败!','提示',mb_ok+mb_defbutton1);
  end;
end;

function TFormSendRulerSet.GetSqlCount(aDevTree, aAlarmTree: TcxTreeView): Integer;
var i, j : Integer;
begin
  Result:=0;
  for i:=0 to aDevTree.Items.Count-1 do
  begin
    if (aDevTree.Items[i].ImageIndex=1) and (aDevTree.Items[i].Level<>0) then
      for j:=0 to aAlarmTree.Items.Count-1 do
        if (aAlarmTree.Items[j].ImageIndex=1) and (aAlarmTree.Items[j].Level<>0) then
          Inc(Result);
  end;
end;

function TFormSendRulerSet.IsExistRecord(aCode, aContent, aKind: Integer): Boolean;
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
      lSqlStr:= 'select * from ALARM_SYS_FUNCTION_SET where code='+
                IntToStr(aCode) +
                ' and content=' +
                IntToStr(aContent) +
                ' and kind=' +
                IntToStr(aKind);
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then
        result:= False
      else
        result:= True;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormSendRulerSet.InitSetInfo;
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
  cxRG_SendType.ItemIndex:= GetSetValue(1,5,gPublicParam.cityid);
  with cxGroupBoxSendWeekSet do
  begin
    for i:=0 to ControlCount-1 do
    begin
      if GetSetValue(i+1,14,gPublicParam.cityid)=1 then
        (Controls[i] as TCheckBox).Checked:= True
      else
        (Controls[i] as TCheckBox).Checked:= False;
    end;
  end;
end;

procedure TFormSendRulerSet.LoadLevel(aTreeView: TcxTreeView;
            aSqlType,aSqlBH,aCityID: Integer; aTopNodeTitle: string);
var
  lClientDataSet: TClientDataSet;
  lWdInteger:TWdInteger;
  lTopNode, lTempNode: TTreeNode;
begin
  aTreeView.Items.Clear;
  lTopNode:= aTreeView.Items.Add(nil,aTopNodeTitle);
  lClientDataSet:= TClientDataSet.create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=gTempInterface.GetCDSData(VarArrayOf([aSqlType,aSqlBH,aCityID]),0);//1,231
    first;
    while not Eof do
    begin
      lWdInteger:=TWdInteger.create(FieldByName('ID').AsInteger);
      lTempNode:= aTreeView.Items.AddChildObject(lTopNode,fieldbyname('NAME').AsString,lWdInteger);
      lTempNode.ImageIndex:=0;
      lTempNode.SelectedIndex:=0;
      Next;
    end;
  end;
  aTreeView.FullExpand;
end;

function TFormSendRulerSet.GetSetValue(aKind,aCode,aContent,aCityID:Integer): string;
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
                ' and content=''' +
                IntToStr(aContent)+
                ''' and cityid='+
                IntToStr(gPublicParam.cityid);
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then
        Result:='0'
      else
        Result:= FieldByName('SETVALUE').AsString;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormSendRulerSet.GetTheTimeList(aKind,aCode,aContent,aCityID: Integer; aTheTime: Tstrings);
var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
begin
  aTheTime.Clear;
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
                ' and content=''' +
                IntToStr(aContent)+
                ''' and cityid='+
                IntToStr(gPublicParam.cityid);
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then Exit;
      while not Eof do
      begin
        aTheTime.Add(FieldByName('SETVALUE').AsString);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormSendRulerSet.cxTreeViewDeviceLevelChange(Sender: TObject; Node: TTreeNode);
var
  lDevLevel, lAlarmLevel: Integer;
begin
  if (cxTreeViewDeviceLevel.Selected=nil) or (cxTreeViewContentLevel.Selected=nil) then exit;
  if (cxTreeViewDeviceLevel.Selected.Level=0) or (cxTreeViewContentLevel.Selected.Level=0) then exit;
  lAlarmLevel:= TWdInteger(cxTreeViewContentLevel.Selected.Data).Value;
  lDevLevel:= TWdInteger(cxTreeViewDeviceLevel.Selected.Data).Value;
  Dtp_Starttime.Time:= StrToTime(GetSetValue(20,lAlarmLevel,lDevLevel,gPublicParam.cityid));
  Dtp_EndTime.Time:= StrToTime(GetSetValue(21,lAlarmLevel,lDevLevel,gPublicParam.cityid));

  SEd_gy.Value:= StrToInt(GetSetValue(18,lAlarmLevel,lDevLevel,gPublicParam.cityid));
  SEWrecker.Value:= StrToInt(GetSetValue(3,lAlarmLevel,lDevLevel,gPublicParam.cityid));

  GetTheTimeList(7,lAlarmLevel,lDevLevel,gPublicParam.cityid,cxListBox_TheTime.Items);
end;

procedure TFormSendRulerSet.cxTreeViewDeviceLevelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cxTreeViewMouseDown(cxTreeViewDeviceLevel,x,y);
end;

procedure TFormSendRulerSet.cxTreeViewContentLevelChange(Sender: TObject; Node: TTreeNode);
var
  lDevLevel, lAlarmLevel: Integer;
begin
  if (cxTreeViewDeviceLevel.Selected=nil) or (cxTreeViewContentLevel.Selected=nil) then exit;
  if (cxTreeViewDeviceLevel.Selected.Level=0) or (cxTreeViewContentLevel.Selected.Level=0) then exit;
  lAlarmLevel:= TWdInteger(cxTreeViewContentLevel.Selected.Data).Value;
  lDevLevel:= TWdInteger(cxTreeViewDeviceLevel.Selected.Data).Value;
  Dtp_Starttime.Time:= StrToTime(GetSetValue(20,lAlarmLevel,lDevLevel,gPublicParam.cityid));
  Dtp_EndTime.Time:= StrToTime(GetSetValue(21,lAlarmLevel,lDevLevel,gPublicParam.cityid));

  SEd_gy.Value:= StrToInt(GetSetValue(18,lAlarmLevel,lDevLevel,gPublicParam.cityid));
  SEWrecker.Value:= StrToInt(GetSetValue(3,lAlarmLevel,lDevLevel,gPublicParam.cityid));

  GetTheTimeList(7,lAlarmLevel,lDevLevel,gPublicParam.cityid,cxListBox_TheTime.Items);
end;

procedure TFormSendRulerSet.cxTreeViewContentLevelMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  cxTreeViewMouseDown(cxTreeViewContentLevel,x,y);
end;

procedure TFormSendRulerSet.Sb_ClearClick(Sender: TObject);
var
  tempbutton:TSpeedButton;
begin
  tempbutton:=sender as TSpeedButton;
  case tempbutton.Tag of
  1 : if cxListBox_TheTime.Items.IndexOf(FormatdateTime('HH:mm',Ed_TheTime.Time))>=0 then
        application.MessageBox('已存在该派修时间点！','提示',mb_ok+mb_defbutton1)
      else
        cxListBox_TheTime.Items.Add(FormatdateTime('HH:mm',Ed_TheTime.Time));
  2 : cxListBox_TheTime.Items.Clear;
  3 : cxListBox_TheTime.Items.Delete(cxListBox_TheTime.ItemIndex);
  end;
  ToolBtnPointSent.Enabled:=True;
end;

procedure TFormSendRulerSet.SEd_gyClick(Sender: TObject);
begin
  ToolBtnMeddle.Enabled:=True;
end;

procedure TFormSendRulerSet.SEWreckerClick(Sender: TObject);
begin
  ToolBtnWrecker.Enabled:= True;
end;

procedure TFormSendRulerSet.cxRG_SendTypePropertiesChange(Sender: TObject);
begin
  ToolBtnSendType.Enabled:= True;
end;

procedure TFormSendRulerSet.CheckBoxMonClick(Sender: TObject);
var
  lTempBox : TCheckBox;
begin
  lTempBox:= Sender as TCheckBox;
  ToolBtnSendWeekSet.Enabled:= True;
end;

procedure TFormSendRulerSet.Dtp_StarttimePropertiesChange(Sender: TObject);
begin
  ToolBtnImmediateSent.Enabled:= True;
end;

end.
