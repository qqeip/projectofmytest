unit UnitAlarmContentModule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, UnitBaseShowModal, StdCtrls, cxLookAndFeelPainters, CheckLst,
  cxTextEdit, cxLabel, Buttons, cxControls, cxContainer, cxEdit, cxGroupBox,
  StringUtils, DBClient, IniFiles, Menus, ExtCtrls;

type
  TFormAlarmContentModule = class(TFormBaseShowModal)
    cxGroupBox4: TcxGroupBox;
    SpeedButtonSearch: TSpeedButton;
    cxLabel1: TcxLabel;
    AlarmEdtSearch: TcxTextEdit;
    CheckListBoxAlarmContent: TCheckListBox;
    PopupMenu: TPopupMenu;
    NCheckAll: TMenuItem;
    NCheckInverse: TMenuItem;
    procedure SpeedButtonSearchClick(Sender: TObject);
    procedure AlarmEdtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure BtnCancelClick(Sender: TObject);
    procedure CheckListBoxAlarmContentClickCheck(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NCheckAllClick(Sender: TObject);
    procedure NCheckInverseClick(Sender: TObject);
    procedure CheckListBoxAlarmContentClick(Sender: TObject);
  private
    procedure InitAlarmSet(aCheckListBox: TCheckListBox);
    procedure ClickCheck(aIndex: integer; aChecked, aLastFlag: boolean);
    { Private declarations }
  public
    gHashedAlarmList: THashedStringList;
    gListView: TListView;
    constructor create(AOwner: TComponent;aHashedAlarmList: THashedStringList);
    destructor  Destroy;
    { Public declarations }
  end;

var
  FormAlarmContentModule: TFormAlarmContentModule;

implementation

uses UnitDllCommon;

{$R *.dfm}

constructor TFormAlarmContentModule.create(AOwner: TComponent;aHashedAlarmList: THashedStringList);
var i: Integer;
begin
  inherited create(AOwner);
  if not Assigned(gHashedAlarmList) then
    gHashedAlarmList:= THashedStringList.Create;
  gHashedAlarmList:= aHashedAlarmList;
  InitAlarmSet(CheckListBoxAlarmContent);
  for i:=0 to CheckListBoxAlarmContent.Items.Count-1 do
    CheckListBoxAlarmContent.Checked[i]:= False;
  CheckListBoxAlarmContent.ShowHint:= True;
  CheckListBoxAlarmContent.Hint:= '';
end;

destructor TFormAlarmContentModule.Destroy;
begin
  gHashedAlarmList.Free;
  inherited;
end;

procedure TFormAlarmContentModule.FormShow(Sender: TObject);
var
  i, j: Integer;
  lAlarmCaption: string;
begin
  inherited;
  j:= 0;
  for i:=0 to CheckListBoxAlarmContent.Items.Count-1 do
  begin
    lAlarmCaption:= CheckListBoxAlarmContent.Items.Strings[i];
    if gHashedAlarmList.IndexOf(lAlarmCaption)>-1 then
    begin
      CheckListBoxAlarmContent.Checked[i]:= true;
      CheckListBoxAlarmContent.Items.Move(i,j);
      inc(j);
    end;
  end;
end;

procedure TFormAlarmContentModule.AlarmEdtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    SpeedButtonSearchClick(Self);
end;

procedure TFormAlarmContentModule.SpeedButtonSearchClick(Sender: TObject);
var
  i: Integer;
  lSqlStr, lWhereStr, lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lClientDataSet: TClientDataSet;
begin
  ClearTStrings(CheckListBoxAlarmContent.Items);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    if AlarmEdtSearch.Text='' then
      lWhereStr:= ''
    else
      lWhereStr:= GetBlurQueryWhere('ALARMCONTENTNAME','ALARMCONTENTCODE',AlarmEdtSearch.Text);
    lSqlStr:= 'select * from alarm_content_info where cityid=' +
              IntToStr(gPublicParam.cityid) +
              lWhereStr +
              ' order by ALARMCONTENTCODE';
    with lClientDataSet do
    begin
      close;
      ProviderName:= 'dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then exit;
      First;
      for i:=0 to RecordCount-1 do
      begin
        lAlarmObject:= TWdInteger.create(FieldByName('ALARMCONTENTCODE').AsInteger);
        lAlarmCaption:= FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(FieldByName('ALARMCONTENTCODE').AsInteger) + ']';
        CheckListBoxAlarmContent.Items.AddObject(lAlarmCaption,lAlarmObject);
        if gHashedAlarmList.IndexOf(lAlarmCaption)>-1 then
          CheckListBoxAlarmContent.Checked[i]:=True;
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmContentModule.InitAlarmSet(aCheckListBox: TCheckListBox);
var
  lClientDataSet: TClientDataSet;
  lAlarmObject: TWdInteger;
  lAlarmCode: Integer;
  lAlarmCaption: string;
begin
  ClearTStrings(aCheckListBox.Items);
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,12,gPublicParam.cityid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        lAlarmCode:= FieldByName('ALARMCONTENTCODE').AsInteger;
        lAlarmCaption:= FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(lAlarmCode) + ']';
        lAlarmObject:= TWdInteger.create(lAlarmCode);
        aCheckListBox.Items.AddObject(lAlarmCaption,lAlarmObject);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmContentModule.BtnCancelClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFormAlarmContentModule.CheckListBoxAlarmContentClickCheck(Sender: TObject);
var
  lIndex: Integer;
begin
  inherited;
  lIndex:= CheckListBoxAlarmContent.ItemIndex;
  ClickCheck(lIndex, CheckListBoxAlarmContent.Checked[lIndex], True);
end;

procedure TFormAlarmContentModule.ClickCheck(aIndex: integer; aChecked, aLastFlag: boolean);
var
  lHashIndex, lAlarmCode: Integer;
  lAlarmCaption: string;
  lAlarmObject: TWdInteger;
begin
  lAlarmCode:= TWdInteger(CheckListBoxAlarmContent.Items.Objects[aIndex]).Value;
  lAlarmCaption:= CheckListBoxAlarmContent.Items.Strings[aIndex];
  if aChecked then
  begin
    if gHashedAlarmList.Indexof(lAlarmCaption) <0 then
    begin
      lAlarmObject:= TWdInteger.Create(lAlarmCode);
      gHashedAlarmList.AddObject(lAlarmCaption,lAlarmObject);
    end;
  end
  else
  begin
    lHashIndex:= gHashedAlarmList.Indexof(lAlarmCaption);
    if lHashIndex >-1 then
    begin
      gHashedAlarmList.Objects[lHashIndex].Free;
      gHashedAlarmList.Delete(lHashIndex);
    end;
  end;
end;


procedure TFormAlarmContentModule.NCheckAllClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to CheckListBoxAlarmContent.Count-1 do
  begin
    CheckListBoxAlarmContent.Checked[i]:= True;
    ClickCheck(i,CheckListBoxAlarmContent.Checked[i],False);
  end;
end;

procedure TFormAlarmContentModule.NCheckInverseClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to CheckListBoxAlarmContent.Count-1 do
  begin
    CheckListBoxAlarmContent.Checked[i]:= not CheckListBoxAlarmContent.Checked[i];
    ClickCheck(i,CheckListBoxAlarmContent.Checked[i],False);
  end;
end;

procedure TFormAlarmContentModule.CheckListBoxAlarmContentClick(
  Sender: TObject);
begin
  if CheckListBoxAlarmContent.Selected[CheckListBoxAlarmContent.ItemIndex] then
    CheckListBoxAlarmContent.Hint:= CheckListBoxAlarmContent.Items.Strings[CheckListBoxAlarmContent.ItemIndex];
end;

end.
