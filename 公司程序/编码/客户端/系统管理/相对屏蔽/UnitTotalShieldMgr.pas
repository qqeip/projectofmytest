{ 相对屏蔽用到的表
   告警组基站状态表（ALARM_SHIELD_DEVSTATE_RELAT）、
   告警屏蔽组小区状态关系表(ALARM_SHIELD_CODEVSTATE_RELAT)、
   告警屏蔽组基站状态关系表(ALARM_SHIELD_DEVSTATE_RELAT)
   要实现的功能：
   从数据字典中列出基站状态，把屏蔽组和基站状态对应放到  告警组基站状态表中
   此状态的告警将判断在此表中的告警组下的设备将不派发。
 }
unit UnitTotalShieldMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, ExtCtrls,
  cxTextEdit, cxCheckBox, cxLabel, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, StringUtils,
  cxGridDBTableView, cxGrid, cxContainer, cxGroupBox, Menus, StdCtrls,
  CheckLst, cxButtons, CxGridUnit, DBClient, jpeg, UDevExpressToChinese,
  cxRadioGroup, Buttons, ComCtrls, cxListView, cxImageComboBox;

type
  TRbStatus = (None, All, Part);
  TFormTotalShieldMgr = class(TForm)
    cxGroupBox2: TcxGroupBox;
    BtnDev: TcxButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Image5: TImage;
    Panel2: TPanel;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox3: TcxGroupBox;
    Panel3: TPanel;
    cxGroupBox4: TcxGroupBox;
    CheckListBoxAlarmContent: TCheckListBox;
    cxGroupBox5: TcxGroupBox;
    BtnSearch: TSpeedButton;
    LblSearch: TcxLabel;
    EdtSearch: TcxTextEdit;
    RbNone: TcxRadioButton;
    RbAll: TcxRadioButton;
    RbPart: TcxRadioButton;
    cxGroupBox6: TcxGroupBox;
    cxListViewShieldAlaim: TcxListView;
    cxGridDevStateDBTableView1: TcxGridDBTableView;
    cxGridDevStateLevel1: TcxGridLevel;
    cxGridDevState: TcxGrid;
    cxGridCodeDevStateDBTableView1: TcxGridDBTableView;
    cxGridCodeDevStateLevel1: TcxGridLevel;
    cxGridCodeDevState: TcxGrid;
    DataSource2: TDataSource;
    ClientDataSet2: TClientDataSet;
    BtnCoDev: TcxButton;
    PopupMenu: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnDevClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure RbAllClick(Sender: TObject);
    procedure RbNoneClick(Sender: TObject);
    procedure RbPartClick(Sender: TObject);
    procedure CheckListBoxAlarmContentClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxGridDevStateDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure cxGridCodeDevStateDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure BtnCoDevClick(Sender: TObject);
    procedure cxGridCodeDevStateDBTableView1CellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGridDevStateDBTableView1CellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure EdtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure cxGridDevStateEnter(Sender: TObject);
    procedure cxGridCodeDevStateEnter(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
//    procedure LoadDevStatusInfo(aCheckBox: TCheckListBox; aCityID,aType: Integer);
    procedure LoadDevStatusInfo(acxGridTableView: TcxGridDBTableView;
               aClient: TClientDataSet; aDataSource:TDataSource;aCityID,aSqlBH: Integer);
//    procedure IsDevStatusChecked(aCheckListBox:TCheckListBox;aShieldGroupID, aCityID, aType: Integer);
//    procedure SelectBox(aBox: TCheckListBox; aKeyid: integer);
//    function GetCheckCount(aBox: TCheckListBox): Integer;
    procedure InitAlarmSet(aCheckListBox: TCheckListBox);
    procedure SetCheckedStatus(aBox: TCheckListBox; aBool: Boolean); //设置告警全选或全部选
    procedure SetAlarmEnabled(aStatus: TRbStatus);
    procedure AddViewField_State;
    function IsExistRecord(aDevID, aType: Integer): Boolean;
    procedure AddToListView(lIndex: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTotalShieldMgr: TFormTotalShieldMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormTotalShieldMgr.FormCreate(Sender: TObject);
begin
  BtnDev.Enabled:= False;
  BtnCoDev.Enabled:= False;
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDevState,true,false,true);
  FCxGridHelper.SetGridStyle(cxGridCodeDevState,true,false,true);
end;

procedure TFormTotalShieldMgr.FormShow(Sender: TObject);
begin
  AddViewField_State;
  LoadDevStatusInfo(cxGridDevStateDBTableView1,ClientDataSet1,DataSource1,gPublicParam.cityid,310); //添加基站状态
  LoadDevStatusInfo(cxGridCodeDevStateDBTableView1,ClientDataSet2,DataSource2,gPublicParam.cityid,210); //添加小区状态
  InitAlarmSet(CheckListBoxAlarmContent); //添加告警
  RbNone.Checked:= True;
  SetAlarmEnabled(None);
end;

procedure TFormTotalShieldMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormTotalShieldMgr,1,'','');
end;

procedure TFormTotalShieldMgr.BtnDevClick(Sender: TObject);
var
  i, j, lCount: Integer;
  lState_Index, lRecordIndex, lShieldFlag_index, lDevID, lState: Integer;
  lVariant: variant;
  lSqlstr, lstatname: string;
  lsuccess: boolean;
begin
  try
    Screen.Cursor:= crHourGlass;

    if RbNone.Checked then
      lState:= 0
    else if RbPart.Checked then
      lState:= 1
    else if RbAll.Checked then
      lState:= 2;

    try
      lState_Index:=cxGridDevStateDBTableView1.GetColumnByFieldName('id').Index;
      lShieldFlag_index:=cxGridCodeDevStateDBTableView1.GetColumnByFieldName('shieldflag').Index;
    except
      Application.MessageBox('未获得 状态编号！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;

    if RbNone.Checked or RbAll.Checked then
    begin
      lCount:= 0;
      lVariant:= VarArrayCreate([0,2*cxGridDevStateDBTableView1.DataController.GetSelectedCount-1],varVariant);
      for i := cxGridDevStateDBTableView1.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := cxGridDevStateDBTableView1.Controller.SelectedRows[I].RecordIndex;
        lDevID := cxGridDevStateDBTableView1.DataController.GetValue(lRecordIndex,lState_Index);
        if IsExistRecord(lDevID,1) then // 1 是 基站  2是小区
        begin
          lSqlstr:= ' update ALARM_SHIELD_DEVSTATE_RELAT set SHIELDFLAG=' +
                    IntToStr(lState) +
                    ' where SHIELDGROUPID=' + IntToStr(lDevID) +
                    ' and DEVICESTATE=' + IntToStr(lDevID) +
                    ' and cityid=' + IntToStr(gPublicParam.cityid);
          lVariant[lCount]:= VarArrayOf([lSqlstr]);
        end
        else
        begin
          lSqlstr:= ' insert into ALARM_SHIELD_DEVSTATE_RELAT(CITYID,SHIELDGROUPID,DEVICESTATE,SHIELDFLAG) values(' +
                    IntToStr(gPublicParam.cityid) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(lState) + ')';
        end;

        lSqlstr:= ' Delete from ALARM_SHIELD_RELAT_ALARM_RELAT where cityid=' + IntToStr(gPublicParam.cityid) +
                  ' and SHIELDGROUPID=' + IntToStr(lDevID);
        lVariant[lCount+1]:= VarArrayOf([lSqlstr]);
        lCount:= lCount + 2;
      end;
    end
    else if RbPart.Checked then
    begin
      lCount:= 0;
      lVariant:= VarArrayCreate([0,cxGridDevStateDBTableView1.DataController.GetSelectedCount*(2+cxListViewShieldAlaim.Items.Count)-1],varVariant);
      for i := cxGridDevStateDBTableView1.DataController.GetSelectedCount-1 downto 0 do
      begin
        lRecordIndex := cxGridDevStateDBTableView1.Controller.SelectedRows[I].RecordIndex;
        lDevID := cxGridDevStateDBTableView1.DataController.GetValue(lRecordIndex,lState_Index);
        if IsExistRecord(lDevID,1) then //1 是 基站 2是小区
        begin
          lSqlstr:= ' update ALARM_SHIELD_DEVSTATE_RELAT set SHIELDFLAG=' +
                    IntToStr(lState) +
                    ' where SHIELDGROUPID=' + IntToStr(lDevID) +
                    ' and cityid=' + IntToStr(gPublicParam.cityid);
        end
        else
        begin
          lSqlstr:= ' insert into ALARM_SHIELD_DEVSTATE_RELAT(CITYID,SHIELDGROUPID,DEVICESTATE,SHIELDFLAG) values(' +
                    IntToStr(gPublicParam.cityid) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(lState) + ')';
        end;
        lVariant[lCount]:= VarArrayOf([lSqlstr]);

        lSqlstr:= ' Delete from ALARM_SHIELD_RELAT_ALARM_RELAT where cityid=' + IntToStr(gPublicParam.cityid) +
                  ' and SHIELDGROUPID=' + IntToStr(lDevID);
        lVariant[lCount+1]:= VarArrayOf([lSqlstr]);
      
        for J:=0 to cxListViewShieldAlaim.Items.Count-1 do
        begin
          lSqlstr:= ' insert into ALARM_SHIELD_RELAT_ALARM_RELAT(CITYID,SHIELDGROUPID,ALARMCONTENTCODE) values(' +
                    IntToStr(gPublicParam.cityid) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(TWdInteger(cxListViewShieldAlaim.Items[J].Data).Value) + ')';
          lVariant[lCount+J+2]:= VarArrayOf([lSqlstr]);
        end;
        lCount:= lCount + J + 2;
      end;
    end;

    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      Application.MessageBox('修改成功','提示',MB_OK+64);
      //更新界面
      for I := cxGridDevStateDBTableView1.DataController.GetSelectedCount -1 downto 0 do
      begin
        if lState=0 then
          lstatname:= '不屏蔽'
        else if lState=1 then
          lstatname:= '部分屏蔽'
        else if lState=2 then
          lstatname:= '全屏蔽';
        lRecordIndex := cxGridDevStateDBTableView1.DataController.GetSelectedRowIndex(I);
        lRecordIndex := cxGridDevStateDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
        cxGridDevStateDBTableView1.DataController.SetValue(lRecordIndex,lShieldFlag_index,lstatname);
      end;
    end
    else
      Application.MessageBox('修改失败','提示',MB_OK+64);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormTotalShieldMgr.InitAlarmSet(aCheckListBox: TCheckListBox); //添加告警
var
  lAlarmCaption: string;
  lClientDataSet: TClientDataSet;
  lAlarmObject: TWdInteger;
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
        lAlarmObject:= TWdInteger.create(FieldByName('ALARMCONTENTCODE').AsInteger);
        lAlarmCaption:= FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(FieldByName('ALARMCONTENTCODE').AsInteger) + ']';
        aCheckListBox.Items.AddObject(lAlarmCaption,lAlarmObject);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormTotalShieldMgr.BtnSearchClick(Sender: TObject);
var
  lSqlStr, lWhereStr, lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lClientDataSet: TClientDataSet;
begin
  ClearTStrings(CheckListBoxAlarmContent.Items);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    if EdtSearch.Text='' then
      lWhereStr:= ''
    else
      lWhereStr:= GetBlurQueryWhere('ALARMCONTENTNAME','ALARMCONTENTCODE',EdtSearch.Text);
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
      while not Eof do
      begin
        lAlarmObject:= TWdInteger.create(FieldByName('ALARMCONTENTCODE').AsInteger);
        lAlarmCaption:= FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(FieldByName('ALARMCONTENTCODE').AsInteger) + ']';
        CheckListBoxAlarmContent.Items.AddObject(lAlarmCaption,lAlarmObject);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormTotalShieldMgr.SetCheckedStatus(aBox: TCheckListBox; aBool: Boolean);
var i: Integer;
begin
  for I:=0 to abox.Count-1 do
    aBox.Checked[i]:= aBool;
end;

procedure TFormTotalShieldMgr.SetAlarmEnabled(aStatus: TRbStatus); //设置是否可用的状态
begin
  case aStatus of
  None:
    begin
      CheckListBoxAlarmContent.Enabled:= False;
      cxListViewShieldAlaim.Clear;
      cxListViewShieldAlaim.Enabled:= False;
      LblSearch.Enabled:= False;
      EdtSearch.Enabled:= False;
      BtnSearch.Enabled:= False;
    end;
  All :
    begin
      CheckListBoxAlarmContent.Enabled:= False;
      cxListViewShieldAlaim.Clear;
      cxListViewShieldAlaim.Enabled:= False;
      LblSearch.Enabled:= False;
      EdtSearch.Enabled:= False;
      BtnSearch.Enabled:= False;
    end;
  Part:
    begin
      CheckListBoxAlarmContent.Enabled:= True;
      cxListViewShieldAlaim.Clear;
      cxListViewShieldAlaim.Enabled:= True;
      LblSearch.Enabled:= True;
      EdtSearch.Enabled:= True;
      BtnSearch.Enabled:= True;
    end;
  end;


end;

procedure TFormTotalShieldMgr.RbNoneClick(Sender: TObject); //不屏蔽
begin
  SetCheckedStatus(CheckListBoxAlarmContent,False);
  SetAlarmEnabled(None);
end;

procedure TFormTotalShieldMgr.RbAllClick(Sender: TObject);   //全屏蔽
begin
  SetAlarmEnabled(All);
  SetCheckedStatus(CheckListBoxAlarmContent,True);
end;

procedure TFormTotalShieldMgr.RbPartClick(Sender: TObject);   //部分屏蔽
begin
  SetAlarmEnabled(Part);
  SetCheckedStatus(CheckListBoxAlarmContent,False);
end;

//选中checkListBox中的告警内容时，告警内容加载到ListView中
procedure TFormTotalShieldMgr.CheckListBoxAlarmContentClickCheck(Sender: TObject);
var
  lIndex, i, j: Integer;
begin
  lIndex:= CheckListBoxAlarmContent.ItemIndex;
  if CheckListBoxAlarmContent.Checked[lIndex] then
  begin
    AddToListView(lIndex);
  end
  else
  begin
    for i:=0 to cxListViewShieldAlaim.Items.Count-1 do
    begin
      if TWdInteger(cxListViewShieldAlaim.Items[i].Data).Value=TWdInteger(CheckListBoxAlarmContent.Items.Objects[lIndex]).Value then
      begin
        cxListViewShieldAlaim.Items[i].Delete ;
        for j:=i to cxListViewShieldAlaim.Items.Count-1 do
          cxListViewShieldAlaim.Items[j].Caption := format('%0.4d',[j+1]);
        break;
      end;
    end;
  end;
end;

//加载基站状态信息
procedure TFormTotalShieldMgr.LoadDevStatusInfo(acxGridTableView: TcxGridDBTableView;
 aClient: TClientDataSet; aDataSource:TDataSource; aCityID, aSqlBH: Integer);
begin
  aDataSource.DataSet:= nil;
  with aClient do
  begin
    Close;
    ProviderName:='DataSetProvider';
    Data:= gTempInterface.GetCDSData(VarArrayOf([1,aSqlBH,aCityid]),0);
  end;
  aDataSource.DataSet:= aClient;
  acxGridTableView.ApplyBestFit();
end;

procedure TFormTotalShieldMgr.AddViewField_State;  //加载cxGrid字段名称
begin
  AddViewField(cxGridDevStateDBTableView1,'id','状态编号');
  AddViewField(cxGridDevStateDBTableView1,'cs_status','基站状态');
  AddViewField(cxGridDevStateDBTableView1,'shieldflag','屏蔽方式');
  AddViewField(cxGridCodeDevStateDBTableView1,'id','状态编号');
  AddViewField(cxGridCodeDevStateDBTableView1,'cs_status','小区状态');
  AddViewField(cxGridCodeDevStateDBTableView1,'shieldflag','屏蔽方式');
end;

//加载基站信息时，记录用颜色区分不同状态
procedure TFormTotalShieldMgr.cxGridDevStateDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  lShieldFlag_Index: Integer;
begin
  try
    lShieldFlag_Index:=TcxGridDBTableView(Sender).GetColumnByFieldName('shieldflag').Index;
  except
    exit;
  end;

//  if AViewInfo.GridRecord.Values[lShieldFlag_Index]='不屏蔽' then
//    ACanvas.Brush.Color := $004080FF;
  if AViewInfo.GridRecord.Values[lShieldFlag_Index]='部分屏蔽' then
    ACanvas.Brush.Color := clYellow;
  if AViewInfo.GridRecord.Values[lShieldFlag_Index]='全屏蔽' then
    ACanvas.Brush.Color := clRed;
end;

//加载小区信息时，记录用颜色区分不同状态
procedure TFormTotalShieldMgr.cxGridCodeDevStateDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  lShieldFlag_Index: Integer;
begin
  try
    lShieldFlag_Index:=TcxGridDBTableView(Sender).GetColumnByFieldName('shieldflag').Index;
  except
    exit;
  end;

//  if AViewInfo.GridRecord.Values[lShieldFlag_Index]='不屏蔽' then
//    ACanvas.Brush.Color := $004080FF;
  if AViewInfo.GridRecord.Values[lShieldFlag_Index]='部分屏蔽' then
    ACanvas.Brush.Color := clYellow;
  if AViewInfo.GridRecord.Values[lShieldFlag_Index]='全屏蔽' then
    ACanvas.Brush.Color := clRed;
end;

//是否存在基站、小区记录
function TFormTotalShieldMgr.IsExistRecord(aDevID, aType: Integer): Boolean;
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
      if aType=1 then      //基站
        lSqlStr:= 'select * from alarm_shield_devstate_relat where DEVICESTATE='+
                  IntToStr(aDevID) +
                  ' and cityid=' +
                  IntToStr(gPublicParam.cityid)
      else     //小区
        lSqlStr:= 'select * from ALARM_SHIELD_CODEVSTATE_RELAT where CODEVICESTATE='+
                  IntToStr(aDevID) +
                  ' and cityid=' +
                  IntToStr(gPublicParam.cityid);
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

//选中基站状态记录
procedure TFormTotalShieldMgr.N4Click(Sender: TObject);    //全选
var
  i: Integer;
begin
  try
    Screen.Cursor:= crHourGlass;
    cxListViewShieldAlaim.Items.Clear;
    for i:=0 to CheckListBoxAlarmContent.Count-1 do
    begin
      CheckListBoxAlarmContent.Checked[i]:=True;
      AddToListView(i);
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormTotalShieldMgr.N5Click(Sender: TObject);    //反选
var i: Integer;
begin
  try
    Screen.Cursor:= crHourGlass;
    cxListViewShieldAlaim.Items.Clear;
    for i:=0 to CheckListBoxAlarmContent.Count-1 do
    begin
      CheckListBoxAlarmContent.Checked[i]:= not CheckListBoxAlarmContent.Checked[i];
      if CheckListBoxAlarmContent.Checked[i]=True then
        AddToListView(i);
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormTotalShieldMgr.BtnCoDevClick(Sender: TObject);
var
  i, j, lCount: Integer;
  lState_Index, lShieldFlag_index, lRecordIndex, lDevID, lState: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
  lstatname: string;
begin
  try
    Screen.Cursor:= crHourGlass;
    if RbNone.Checked then
      lState:= 0
    else if RbPart.Checked then
      lState:= 1
    else if RbAll.Checked then
      lState:= 2;

    try
      lState_Index:=cxGridCodeDevStateDBTableView1.GetColumnByFieldName('id').Index;
      lShieldFlag_index:=cxGridCodeDevStateDBTableView1.GetColumnByFieldName('shieldflag').Index;
    except
      Application.MessageBox('未获得 状态编号！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;

    if RbNone.Checked or RbAll.Checked then
    begin
      lCount:= 0;
      lVariant:= VarArrayCreate([0,2*cxGridCodeDevStateDBTableView1.DataController.GetSelectedCount-1],varVariant);
      for i := cxGridCodeDevStateDBTableView1.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := cxGridCodeDevStateDBTableView1.Controller.SelectedRows[I].RecordIndex;
        lDevID := cxGridCodeDevStateDBTableView1.DataController.GetValue(lRecordIndex,lState_Index);
        if IsExistRecord(lDevID,2) then // 1 是 基站  2是小区
        begin
          lSqlstr:= ' update ALARM_SHIELD_CODEVSTATE_RELAT set SHIELDFLAG=' +
                    IntToStr(lState) +
                    ' where CODEVICESTATE=' + IntToStr(lDevID) +
                    ' and cityid=' + IntToStr(gPublicParam.cityid);
        end
        else
        begin
          lSqlstr:= ' insert into ALARM_SHIELD_CODEVSTATE_RELAT(CITYID,SHIELDGROUPID,CODEVICESTATE,SHIELDFLAG) values(' +
                    IntToStr(gPublicParam.cityid) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(lState) + ')';
        end;
        lVariant[lCount]:= VarArrayOf([lSqlstr]);

        lSqlstr:= ' Delete from ALARM_SHIELD_RELAT_ALARM_RELAT where cityid=' + IntToStr(gPublicParam.cityid) +
                  ' and SHIELDGROUPID=' + IntToStr(lDevID);
        lVariant[lCount+1]:= VarArrayOf([lSqlstr]);
        lCount:= lCount + 2;
      end;
    end
    else if RbPart.Checked then
    begin
      lCount:= 0;
      lVariant:= VarArrayCreate([0,cxGridCodeDevStateDBTableView1.DataController.GetSelectedCount*(2+cxListViewShieldAlaim.Items.Count)-1],varVariant);
      for i := cxGridCodeDevStateDBTableView1.DataController.GetSelectedCount-1 downto 0 do
      begin
        lRecordIndex := cxGridCodeDevStateDBTableView1.Controller.SelectedRows[I].RecordIndex;
        lDevID := cxGridCodeDevStateDBTableView1.DataController.GetValue(lRecordIndex,lState_Index);
        if IsExistRecord(lDevID,2) then //1 是 基站 2是小区
        begin
          lSqlstr:= ' update ALARM_SHIELD_CODEVSTATE_RELAT set SHIELDFLAG=' +
                    IntToStr(lState) +
                    ' where CODEVICESTATE=' + IntToStr(lDevID) +
                    ' and cityid=' + IntToStr(gPublicParam.cityid);
        end
        else
        begin
          lSqlstr:= ' insert into ALARM_SHIELD_CODEVSTATE_RELAT(CITYID,SHIELDGROUPID,CODEVICESTATE,SHIELDFLAG) values(' +
                    IntToStr(gPublicParam.cityid) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(lState) + ')';
        end;
        lVariant[lCount]:= VarArrayOf([lSqlstr]);

        lSqlstr:= ' Delete from ALARM_SHIELD_RELAT_ALARM_RELAT where cityid=' + IntToStr(gPublicParam.cityid) +
                  ' and SHIELDGROUPID=' + IntToStr(lDevID);
        lVariant[lCount+1]:= VarArrayOf([lSqlstr]);
      
        for J:=0 to cxListViewShieldAlaim.Items.Count-1 do
        begin
          lSqlstr:= ' insert into ALARM_SHIELD_RELAT_ALARM_RELAT(CITYID,SHIELDGROUPID,ALARMCONTENTCODE) values(' +
                    IntToStr(gPublicParam.cityid) + ',' +
                    IntToStr(lDevID) + ',' +
                    IntToStr(TWdInteger(cxListViewShieldAlaim.Items[J].Data).Value) + ')';
          lVariant[lCount+J+2]:= VarArrayOf([lSqlstr]);
        end;
        lCount:= lCount + J + 2;
      end;
    end;
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      Application.MessageBox('修改成功','提示',MB_OK+64);
      //更新界面
      for I := cxGridCodeDevStateDBTableView1.DataController.GetSelectedCount -1 downto 0 do
      begin
        if lState=0 then
          lstatname:= '不屏蔽'
        else if lState=1 then
          lstatname:= '部分屏蔽'
        else if lState=2 then
          lstatname:= '全屏蔽';
        lRecordIndex := cxGridCodeDevStateDBTableView1.DataController.GetSelectedRowIndex(I);
        lRecordIndex := cxGridCodeDevStateDBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
        cxGridCodeDevStateDBTableView1.DataController.SetValue(lRecordIndex,lShieldFlag_index,lstatname);
      end;
    end
    else
      Application.MessageBox('修改失败','提示',MB_OK+64);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormTotalShieldMgr.AddToListView(lIndex: Integer);
var
  lListItem: TListItem;
begin
  lListItem:=cxListViewShieldAlaim.items.Add;
  lListItem.Data:=CheckListBoxAlarmContent.Items.Objects[lindex];
  lListItem.Caption:=format('%0.4d',[cxListViewShieldAlaim.Items.Count-1]);
  lListItem.SubItems.Add(CheckListBoxAlarmContent.Items.Strings[lindex]);
end;

procedure TFormTotalShieldMgr.cxGridCodeDevStateDBTableView1CellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  lClientDataSet: TClientDataSet;
  lAlarmObject  : TWdInteger;
  lSqlStr, lAlarmName: string;
  i, lShieldGroupID, lShieldFlag_Index, lRecordIndex: Integer;
  newlistItem:TlistItem;
begin
  try
    Screen.Cursor:= crHourGlass;
    lShieldGroupID:= ClientDataSet2.FieldByName('ID').AsInteger;
    lShieldFlag_Index:= cxGridCodeDevStateDBTableView1.GetColumnByFieldName('shieldflag').Index;
    lRecordIndex:= cxGridCodeDevStateDBTableView1.DataController.GetSelectedRowIndex(0);

    if cxGridCodeDevStateDBTableView1.DataController.GetValue(lRecordIndex,lShieldFlag_Index)= '不屏蔽' then
      RbNone.Checked:= True;
    if cxGridCodeDevStateDBTableView1.DataController.GetValue(lRecordIndex,lShieldFlag_Index) = '全屏蔽' then
      RbAll.Checked:= True;
    if cxGridCodeDevStateDBTableView1.DataController.GetValue(lRecordIndex,lShieldFlag_Index) = '部分屏蔽' then
    begin
      RbPart.Checked:= True;
      ClearTStrings(CheckListBoxAlarmContent.Items);
      cxListViewShieldAlaim.Items.Clear;
       try
         lClientDataSet:= TClientDataSet.Create(nil);
         with lClientDataSet do
         begin
           Close;
           lClientDataSet.ProviderName:= 'DataSetProvider';
           lSqlStr := 'select a.alarmcontentcode,a.alarmcontentname,b.shieldgroupid,decode(b.alarmcontentcode,null,0,1) as checked' +
                      '  from alarm_content_info a' +
                      '  left join (select * from ALARM_SHIELD_RELAT_ALARM_RELAT where shieldgroupid=' + IntToStr(lShieldGroupID) +
                      ') b on a.cityid=b.cityid and a.alarmcontentcode = b.alarmcontentcode' +
                      ' where a.cityid=' + IntToStr(gPublicParam.cityid) +
                      ' order by checked desc,alarmcontentcode';

           Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
           if IsEmpty then exit;
           First;
           while not Eof do
           begin
             lAlarmObject:=TWdInteger.Create(FieldByName('alarmcontentcode').asInteger);
             lAlarmName := FieldByName('alarmcontentname').AsString + '[' + IntToStr(FieldByName('alarmcontentcode').asInteger) + ']' ;
             CheckListBoxAlarmContent.Items.AddObject(lAlarmName,lAlarmObject);
             if FieldByName('checked').AsInteger=1 then
             begin
               CheckListBoxAlarmContent.Checked[CheckListBoxAlarmContent.Items.IndexOf(lAlarmName)]:= True;
               newlistItem:=cxListViewShieldAlaim.Items.Add;
               newlistItem.Data := lAlarmObject;
               newlistItem.Caption:=format('%0.4d',[i]);
               newlistItem.SubItems.Add(lAlarmName);
               inc(i);
             end;
             Next;
           end;
         end;
       finally
         lClientDataSet.free;
       end;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormTotalShieldMgr.cxGridDevStateDBTableView1CellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
var
  lClientDataSet: TClientDataSet;
  lAlarmObject  : TWdInteger;
  lSqlStr, lAlarmName: string;
  i, lShieldGroupID, lRecordIndex, lShieldFlag_Index: Integer;
  newlistItem:TlistItem;
begin
  try
    Screen.Cursor:= crHourGlass;
    lShieldGroupID:= ClientDataSet1.FieldByName('ID').AsInteger;
    lShieldFlag_Index:= cxGridDevStateDBTableView1.GetColumnByFieldName('shieldflag').Index;
    lRecordIndex:= cxGridDevStateDBTableView1.DataController.GetSelectedRowIndex(0);

    if cxGridDevStateDBTableView1.DataController.GetValue(lRecordIndex,lShieldFlag_Index)= '不屏蔽' then
      RbNone.Checked:= True;
    if cxGridDevStateDBTableView1.DataController.GetValue(lRecordIndex,lShieldFlag_Index) = '全屏蔽' then
      RbAll.Checked:= True;
    if cxGridDevStateDBTableView1.DataController.GetValue(lRecordIndex,lShieldFlag_Index) = '部分屏蔽' then
    begin
      RbPart.Checked:= True;
      ClearTStrings(CheckListBoxAlarmContent.Items);
      cxListViewShieldAlaim.Items.Clear;
       try
         lClientDataSet:= TClientDataSet.Create(nil);
         with lClientDataSet do
         begin
           Close;
           lClientDataSet.ProviderName:= 'DataSetProvider';
           lSqlStr := 'select a.alarmcontentcode,a.alarmcontentname,b.shieldgroupid,decode(b.alarmcontentcode,null,0,1) as checked' +
                      '  from alarm_content_info a' +
                      '  left join (select * from ALARM_SHIELD_RELAT_ALARM_RELAT where shieldgroupid=' + IntToStr(lShieldGroupID) +
                      ') b on a.cityid=b.cityid and a.alarmcontentcode = b.alarmcontentcode' +
                      ' where a.cityid=' + IntToStr(gPublicParam.cityid) +
                      ' order by checked desc,alarmcontentcode';

           Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
           if IsEmpty then exit;
           First;
           while not Eof do
           begin
             lAlarmObject:=TWdInteger.Create(FieldByName('alarmcontentcode').asInteger);
             lAlarmName := FieldByName('alarmcontentname').AsString + '[' + IntToStr(FieldByName('alarmcontentcode').asInteger) + ']' ;
             CheckListBoxAlarmContent.Items.AddObject(lAlarmName,lAlarmObject);
             if FieldByName('checked').AsInteger=1 then
             begin
               CheckListBoxAlarmContent.Checked[CheckListBoxAlarmContent.Items.IndexOf(lAlarmName)]:= True;
               newlistItem:=cxListViewShieldAlaim.Items.Add;
               newlistItem.Data := lAlarmObject;
               newlistItem.Caption:=format('%0.4d',[i]);
               newlistItem.SubItems.Add(lAlarmName);
               inc(i);
             end;
             Next;
           end;
         end;
       finally
         lClientDataSet.free;
       end;

    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure TFormTotalShieldMgr.EdtSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    BtnSearchClick(Self);
end;

procedure TFormTotalShieldMgr.cxGridDevStateEnter(Sender: TObject);
begin
  BtnDev.Enabled:= True;
  BtnCoDev.Enabled:= False;
end;

procedure TFormTotalShieldMgr.cxGridCodeDevStateEnter(Sender: TObject);
begin
  BtnDev.Enabled:= False;
  BtnCoDev.Enabled:= True;
end;

end.
