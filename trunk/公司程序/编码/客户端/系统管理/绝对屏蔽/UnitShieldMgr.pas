{屏蔽告警管理：（绝对屏蔽）    --mj--
 用到的表：
 1、告警屏蔽组信息表 （ALARM_SHIELD_INFO）
 2、告警屏蔽组设备关系表 （ALARM_SHIELD_DEV_RELAT）
 3、告警屏蔽组告警类型关系表（ALARM_SHIELD_ALARM_RELAT）
 4、告警内容表（ALARM_CONTENT_INFO）
 5、设备信息表（FMS_DEVICE_INFO）存放基站信息
 需实现的功能：
   添加、修改、删除屏蔽组
   通过树图给屏蔽组添加基站：树图结构为：杭州市-维护单位-县市-分局-基站中文名
   通过告警信息列表给屏蔽组添加告警
   通过基站名或基站ID在树中定位基站
   导入功能：excel表中是设备ID，判断存在此基站（树图中）添加到对应的设备组，否则不添加
   并记录导入日志：如那些基站导入成功，那些导入失败。

 相对屏蔽用到的表  告警组基站状态表（ALARM_SHIELD_DEVSTATE_RELAT）
   要实现的功能：
   从数据字典中列出基站状态，把屏蔽组和基站状态对应放到  告警组基站状态表中
   此状态的告警将判断在此表中的告警组下的设备将不派发。
}
unit UnitShieldMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, Menus, StdCtrls,
  cxButtons, cxCheckListBox, ExtCtrls, cxTextEdit, cxCheckBox, cxLabel,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView, CxGridUnit,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  cxContainer, cxGroupBox, DBClient, CheckLst, ComCtrls, cxTreeView,
  ImgList, Buttons, jpeg, StringUtils, ComObj, UnitCFMSTreeHelper, IniFiles;


type
  TFormShieldMgr = class(TForm)
    cxGroupBoxShield: TcxGroupBox;
    cxGroupBox6: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxCheckBox1: TcxCheckBox;
    cxTextEditShieldName: TcxTextEdit;
    cxTextEditRemark: TcxTextEdit;
    Splitter1: TSplitter;
    PnlShieldGroup: TPanel;
    cxGroupBox2: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGroupBox3: TcxGroupBox;
    cxGroupBox4: TcxGroupBox;
    cxBtnAdd: TcxButton;
    cxBtnModify: TcxButton;
    cxBtnDel: TcxButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    CheckListBoxAlarm: TCheckListBox;
    cxGroupBoxTree: TcxGroupBox;
    cxTreeViewRes: TcxTreeView;
    cxGroupBox8: TcxGroupBox;
    cxLabel3: TcxLabel;
    cxTextEditSearch: TcxTextEdit;
    ImageList1: TImageList;
    SpeedButtonSearch: TSpeedButton;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    DataSource2: TDataSource;
    ClientDataSet2: TClientDataSet;
    cxBtnSave: TcxButton;
    cxBtnCancel: TcxButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    cxGrid2: TcxGrid;
    cxGrid2DBTableView1: TcxGridDBTableView;
    cxGrid2Level1: TcxGridLevel;
    SpeedButtonNext: TSpeedButton;
    cxBtnImport: TcxButton;
    OpenDialog1: TOpenDialog;
    PopupMenu2: TPopupMenu;
    cxGroupBox5: TcxGroupBox;
    LblSearch: TcxLabel;
    EdtSearch: TcxTextEdit;
    BtnSearch: TSpeedButton;
    ImageList2: TImageList;
    imagelist3: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Splitter3Moved(Sender: TObject);   //限定拖动时树图和屏蔽组的最小宽度
    procedure Splitter1Moved(Sender: TObject);
    procedure cxBtnAddClick(Sender: TObject);
    procedure cxBtnDelClick(Sender: TObject);
    procedure cxBtnModifyClick(Sender: TObject);
    procedure cxTreeViewResDblClick(Sender: TObject);
    procedure cxBtnSaveClick(Sender: TObject);
    procedure cxBtnCancelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure SpeedButtonSearchClick(Sender: TObject);
    procedure SpeedButtonNextClick(Sender: TObject);
    procedure cxTextEditSearchKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxBtnImportClick(Sender: TObject);
    procedure cxTreeViewResMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure cxGrid2DBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure cxGrid2Enter(Sender: TObject);
    procedure cxGrid1Enter(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure EdtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure CheckListBoxAlarmClickCheck(Sender: TObject);
    procedure CheckListBoxAlarmClick(Sender: TObject);
  private
    MenuAdd, MenuDel: TMenuItem;
    MenuAddShieldGroup: array of TMenuItem;
    MenuDelShieldGroup: array of TMenuItem;
    { Private declarations }
    FDataSetLocate: TClientDataSet;
    FPathList: TStringList;
    FPathListIndex: integer;
    FIsLocateEffect: boolean;

    FCxGridHelper : TCxGridSet;
    IsOperateSucc: boolean;
    MenuItem_Del : TMenuItem;
    FOperateFlag : Integer;
    gCFMS_TreeHelper: TCFMS_TreeHelper;
    procedure AddViewField_Shield;
    procedure LoadShieldInfo(aCityid: integer);
    procedure DelDevRecordOnClickEvent(Sender: TObject);
    procedure SetStatus(aBool: Boolean);
    procedure LoadDevInfo(aShield, aCityid: integer);
    function GetAlarmContentCount: Integer;
    procedure IsAlarmChecked(aShield, aCityid: integer);
    procedure SelectBox(aBox: TCheckListBox; aKeyid: integer);


    //树图定位
    function JudgeNode(aText1,aText2: string):boolean;
    function GetLocateFirstNode(aTreeView: TcxTreeView; aPathList: TStringList): TTreeNode;overload;
    function GetLocateFirstNode(aTopNode: TTreeNode; aKeyValue: string): TTreeNode;overload;
    function GetLocateNode(aTopNode: TTreeNode; aPathList: TStringList; aPathIndex: integer): TTreeNode;overload;
    //根据路径定位节点   //浙江省，杭州市，西湖区，MTU001
    function GetLocateNode(aTreeView: TcxTreeView; aPathList: TStringList): TTreeNode;overload;
    procedure GetPathList(aDataSet: TClientDataSet; aPathList: TStringList);
    procedure ParseXLS(FileName: string; CallList: TStrings);
    procedure ParseTxt(FileName: string; CallList: TStrings);
    procedure ImportCallNumber(var CallNumberList: OleVariant);
    function IsNum(lstr: string): boolean;
    procedure InitAlarmSet(aCheckListBox: TCheckListBox);
    function IsExistRecord(aSqlStr: string): Integer;
    procedure PopupMenuAdd(Sender: Tobject);
    procedure PopupMenuDel(Sender: Tobject);
    procedure FreeMenu;
    procedure AddResTreeFirstMenu;
  public
     gSearchcheck: Integer;
     gSelectedAlarmContentList: THashedStringList;
     procedure ClickCheck(aIndex: integer; aChecked, aLastFlag: boolean);
    { Public declarations }
  end;

var
  FormShieldMgr: TFormShieldMgr;

implementation

uses UnitDllCommon ;

{$R *.dfm}

{ TFormShieldMgr }

procedure TFormShieldMgr.FormCreate(Sender: TObject);
begin
  FDataSetLocate:= TClientDataSet.Create(nil);
  FPathList:= TStringList.Create;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);
  FCxGridHelper.SetGridStyle(cxGrid2,true,false,true);
  MenuItem_Del := FCxGridHelper.AppendMenuItem('删除',DelDevRecordOnClickEvent);
  AddCategory(cxGrid1DBTableView1,gPublicParam.cityid,gPublicParam.userid,16);
  //cxTreeViewRes.OnExpanding := TreeViewExpanding;

  gCFMS_TreeHelper:= TCFMS_TreeHelper.Create(cxTreeViewRes,gPublicParam.Cityid,gPublicParam.RuleCompanyidStr);
  gCFMS_TreeHelper.RefreshTree('',2,6,false);
  gSelectedAlarmContentList:=THashedStringList.Create;

  CheckListBoxAlarm.ShowHint:= True;
  CheckListBoxAlarm.Hint:= '';
  cxTextEditSearch.Hint:='可根据BTSID、基站中文名、小区编号进行模糊查询';
  cxTextEditSearch.ShowHint:= true;
end;

procedure TFormShieldMgr.FormShow(Sender: TObject);
begin
  AddViewField_Shield;
  //LoadTreeInfo(cxTreeViewRes);     //添加树图
  InitAlarmSet(CheckListBoxAlarm);   //添加告警
  LoadShieldInfo(gPublicParam.cityid);   //添加屏蔽组
  SetStatus(False);
  AddResTreeFirstMenu;
end;

procedure TFormShieldMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormShieldMgr,1,'','');
end;

procedure TFormShieldMgr.FormDestroy(Sender: TObject);
begin
  FDataSetLocate.Close;
  FDataSetLocate.Free;
  FPathList.Free;
  FCxGridHelper.Free;
end;

procedure TFormShieldMgr.AddViewField_Shield;
begin
  AddViewField(cxGrid2DBTableView1,'shieldgroupid','屏蔽组编号');
  AddViewField(cxGrid2DBTableView1,'shieldgroupname','屏蔽组名称');
  AddViewField(cxGrid2DBTableView1,'shieldremark','屏蔽原因说明');
  AddViewField(cxGrid2DBTableView1,'iseffectname','是否有效');
//  AddViewField(cxGrid1DBTableView1,'deviceid','设备编号');
//  AddViewField(cxGrid1DBTableView1,'BTS_NAME','设备名称');
end;

procedure TFormShieldMgr.LoadShieldInfo(aCityid: integer);
begin
  DataSource2.DataSet:= nil;
  with ClientDataSet2 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=gTempInterface.GetCDSData(VarArrayOf([1,203,gPublicParam.cityid]),0);
  end;
  DataSource2.DataSet:= ClientDataSet2;
  cxGrid2DBTableView1.ApplyBestFit();
end;

procedure TFormShieldMgr.LoadDevInfo(aShield, aCityid: integer);
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=gTempInterface.GetCDSData(VarArrayOf([1,208,aShield, gPublicParam.cityid]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormShieldMgr.InitAlarmSet(aCheckListBox: TCheckListBox);
var
  lClientDataSet: TClientDataSet;
  lAlarmObject: TWdInteger;
  lAlarmName : string;
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
        lAlarmName := FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(FieldByName('ALARMCONTENTCODE').AsInteger) + ']';
        aCheckListBox.Items.AddObject(lAlarmName,lAlarmObject);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormShieldMgr.IsAlarmChecked(aShield, aCityid: integer);
var
  i, j : Integer;
  lClientDataSet: TClientDataSet;
  lAlarmObject  : TWdInteger;
  lAlarmName : string;
  lHashIndex, lContentCode: Integer;
begin
  if gSearchcheck=0 then
     begin
        ClearTStrings(CheckListBoxAlarm.Items);
        gSelectedAlarmContentList.Clear;
     end;
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,209,aShield,aCityid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        lAlarmObject:=TWdInteger.Create(FieldByName('alarmcontentcode').asInteger);
        lAlarmName := FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(FieldByName('ALARMCONTENTCODE').AsInteger) + ']';
        if gSearchcheck=0 then
        begin
           CheckListBoxAlarm.Items.AddObject(lAlarmName, lAlarmObject);
           lContentCode:= TWdInteger(CheckListBoxAlarm.Items.Objects[CheckListBoxAlarm.Items.IndexOf(lAlarmName)]).Value;
             if FieldByName('checked').AsInteger=1 then
               begin
                if gSelectedAlarmContentList.IndexOf(inttostr(lContentCode))<0 then
                  begin
                     lAlarmObject:=TWdInteger.Create(lContentCode);
                     gSelectedAlarmContentList.AddObject(lAlarmName,lAlarmObject);
                  end;
               end
             else
               begin
                  lHashIndex:= gSelectedAlarmContentList.IndexOf(lAlarmName);
                  if lHashIndex >-1 then
                  begin
                    gSelectedAlarmContentList.Objects[lHashIndex].Free;
                    gSelectedAlarmContentList.Delete(lHashIndex);
                   end;
               end;
            if CheckListBoxAlarm.Items.IndexOf(lAlarmName)>-1 then
                begin
                  if FieldByName('checked').AsInteger=1 then
                   CheckListBoxAlarm.Checked[CheckListBoxAlarm.Items.IndexOf(lAlarmName)]:= True;
                end;
        end;
        Next;
      end;
    end;
  finally
    lClientDataSet.free;
  end;
end;

procedure TFormShieldMgr.SelectBox(aBox: TCheckListBox; aKeyid: integer);
var
  I :integer;
begin
  for I := 0 to aBox.Items.Count -1 do
  begin
    if not aBox.Checked[I] then
    begin
      if TWdInteger(aBox.Items.Objects[I]).Value=aKeyid then
      begin
        aBox.Checked[I]:=True;
      end;
    end;
  end;
end;

procedure TFormShieldMgr.Splitter3Moved(Sender: TObject);
begin
  if cxGroupBoxTree.Width<=210 then
    cxGroupBoxTree.Width:= 210;
  if cxGroupBoxShield.Width<=280 then
     cxGroupBoxShield.Width:=280;
  if PnlShieldGroup.Width<=350 then
    PnlShieldGroup.Width:=350;
end;

procedure TFormShieldMgr.Splitter1Moved(Sender: TObject);
begin
  if cxGroupBoxTree.Width<=210 then
    cxGroupBoxTree.Width:= 210;
  if cxGroupBoxShield.Width<=280 then
     cxGroupBoxShield.Width:=280;
  if PnlShieldGroup.Width<=350 then
    PnlShieldGroup.Width:=350;
end;

procedure TFormShieldMgr.cxBtnAddClick(Sender: TObject);
var i: Integer;
begin
  FOperateFlag := 1;
  SetStatus(True);
  for I:=0 to CheckListBoxAlarm.Count-1 do
    CheckListBoxAlarm.Checked[i]:= False;
  gSelectedAlarmContentList.Clear;
  LoadDevInfo(-1,-1);
end;

procedure TFormShieldMgr.cxBtnModifyClick(Sender: TObject);
 var
   lShieldID: Integer;
   lVariant: variant;
   lSqlstr: string;
   lsuccess: boolean;
begin
  FOperateFlag := 2;
  SetStatus(True);
  try
    lShieldID := ClientDataSet2.FieldByName('SHIELDGROUPID').AsInteger;
  except
    Application.MessageBox('请先选择要修改的屏蔽组','提示',MB_OK+64);
  end;
end;

procedure TFormShieldMgr.cxBtnDelClick(Sender: TObject);
var
  lShieldID: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid2DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK+64);
    Exit;
  end;
  lShieldID:= ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger;
  
  lSqlstr:= 'select * from alarm_shield_dev_relat where cityid=' + IntToStr(gPublicParam.cityid) +
            ' and SHIELDGROUPID=' + inttostr(lShieldID);
  if IsExistRecord(lSqlstr)=1 then
  begin
    Application.MessageBox('此屏蔽组下存在设备，请先删除设备后再删除屏蔽组！','提示',MB_OK+64);
    Exit;
  end;
  if Application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;

  lVariant:= VarArrayCreate([0,1],varVariant);
  lSqlstr:= 'delete from alarm_shield_alarm_relat' +
            ' where SHIELDGROUPID=' + inttostr(lShieldID) +
            ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lSqlstr]);
  lSqlstr:= 'delete from alarm_shield_info' +
            ' where SHIELDGROUPID=' + inttostr(lShieldID) +
            ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[1]:= VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('删除成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet2.Delete;
    IsOperateSucc:= False;
  end
  else
    Application.MessageBox('删除失败','提示',MB_OK+64);
end;

procedure TFormShieldMgr.cxBtnSaveClick(Sender: TObject);
var
  lShieldID,i , j, lCount : Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  try
    ClientDataSet1.RecordCount;
  except
    Application.MessageBox('不能获取设备信息','提示',MB_OK+64);
    Exit;
  end;
  lVariant:= VarArrayCreate([0,ClientDataSet1.RecordCount+gSelectedAlarmContentList.Count+2],varVariant);
  if GetAlarmContentCount=0 then
  begin
    Application.MessageBox('未选择屏蔽告警内容!!','提示',MB_OK+64);
    Exit;
  end;
  if FOperateFlag = 1 then      //新增加
  begin
    if cxTextEditShieldName.Text='' then
    begin
      Application.MessageBox('屏蔽组名称不能为空','提示',MB_OK + 64);
      Exit;
    end;
    if IsExists('alarm_shield_info','shieldgroupname',cxTextEditShieldName.Text) then
    begin
      Application.MessageBox('该屏蔽组名称已经存在!','提示',MB_OK+64);
      Exit;
    end;
    lShieldID:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
    lSqlstr:= 'insert into alarm_shield_info'+
              ' (CITYID,SHIELDGROUPID,SHIELDGROUPNAME,SHIELDREMARK,OPERATOR,LASTMODIFY,ISEFFECT)' +
              ' values('+
              IntToStr(gPublicParam.cityid)+','+
              IntToStr(lShieldID)+','''+
              cxTextEditShieldName.Text + ''',''' +
              cxTextEditRemark.Text + ''',' +
              IntToStr(gPublicParam.userid) + ',' +
              ' to_date('''+datetostr(Now)+''',''yyyy-mm-dd''),' +
              IntToStr(Ord(cxCheckBox1.Checked))+ ')';
    lVariant[0]:= VarArrayOf([lSqlstr]);
  end;

  if FOperateFlag = 2 then      //修改
  begin
    if cxTextEditShieldName.Text='' then
    begin
      Application.MessageBox('屏蔽组名称不能为空','提示',MB_OK + 64);
      Exit;
    end;
    lShieldID:= ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger;
    lSqlstr:= 'update alarm_shield_info set '+
              ' SHIELDGROUPNAME=''' + cxTextEditShieldName.Text + ''',' +
              ' SHIELDREMARK=''' + cxTextEditRemark.Text + ''',' +
              ' OPERATOR=' + IntToStr(gPublicParam.userid) + ',' +
              ' LASTMODIFY=' + ' to_date('''+datetostr(Now)+''',''yyyy-mm-dd''),' +
              ' ISEFFECT=' + IntToStr(Ord(cxCheckBox1.Checked)) +
              ' where SHIELDGROUPID=' + IntToStr(lShieldID) ;
    lVariant[0]:= VarArrayOf([lSqlstr]);
  end;
  lCount:=0;
  //设备
  lSqlstr:= 'delete from ALARM_SHIELD_DEV_RELAT where cityid='+IntToStr(gPublicParam.cityid)+
            ' and SHIELDGROUPID=' + IntToStr(lShieldID);
  lVariant[1]:= VarArrayOf([lSqlstr]);
  with ClientDataSet1 do
  begin
    First;
    for i:=0 to RecordCount-1 do
    begin
      lSqlstr:= 'insert into ALARM_SHIELD_DEV_RELAT(CITYID,SHIELDGROUPID,DEVICEID,CODEVICEID) values('+
                IntToStr(gPublicParam.cityid)+','+
                IntToStr(lShieldID)+','+
                IntToStr(fieldbyname('DEVICEID').AsInteger) + ',' +       
                IntToStr(FieldByName('codeviceid').AsInteger)+ ')';
      lVariant[lCount+2]:= VarArrayOf([lSqlstr]);
      Next;
      Inc(lCount);
    end;
  end;
  //告警
  lSqlstr:= ' delete from ALARM_SHIELD_ALARM_RELAT where cityid='+ IntToStr(gPublicParam.cityid) +
            ' and SHIELDGROUPID=' + IntToStr(lShieldID);
  lVariant[lCount+2]:= VarArrayOf([lSqlstr]);
  for j:=0 to gSelectedAlarmContentList.Count-1 do
  begin
    if True then
    begin
      lSqlstr:= 'insert into ALARM_SHIELD_ALARM_RELAT(CITYID,SHIELDGROUPID,ALARMCONTENTCODE) values('+
                IntToStr(gPublicParam.cityid)+','+
                IntToStr(lShieldID)+','+
                IntToStr(TWdInteger(gSelectedAlarmContentList.Objects[j]).Value) + ')';
      lVariant[lCount+3]:= VarArrayOf([lSqlstr]);
      Inc(lCount);
    end;
  end;
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    IsOperateSucc:= True;
    if FOperateFlag=1 then
    begin
      Application.MessageBox('新增成功','提示',MB_OK+64);
      ClientDataSet2.append;
    end;
    if FOperateFlag=2 then
    begin
      Application.MessageBox('修改成功','提示',MB_OK+64);
      ClientDataSet2.Edit;
    end;
    ClientDataSet2.FieldByName('shieldgroupid').AsInteger   := lShieldID;
    ClientDataSet2.FieldByName('shieldgroupname').AsString := cxTextEditShieldName.Text;
    ClientDataSet2.FieldByName('SHIELDREMARK').AsString    := cxTextEditRemark.Text;
    if cxCheckBox1.Checked then
    begin
      ClientDataSet2.FieldByName('iseffectname').AsString := '是';
      ClientDataSet2.FieldByName('iseffect').AsInteger := 1;
    end
    else
    begin
      ClientDataSet2.FieldByName('iseffectname').AsString := '否';
      ClientDataSet2.FieldByName('iseffect').AsInteger := 0;
    end;
    ClientDataSet2.Post;
    IsOperateSucc:= False;
  end
  else
  begin
    if FOperateFlag=1 then
      Application.MessageBox('新增失败','提示',MB_OK+64);
    if FOperateFlag=2 then
      Application.MessageBox('修改失败','提示',MB_OK+64);
  end;
  SetStatus(False);
  FOperateFlag:=0;
end;

procedure TFormShieldMgr.cxBtnCancelClick(Sender: TObject);
begin
  SetStatus(False);
end;

procedure TFormShieldMgr.cxGrid2DBTableView1CellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  Screen.Cursor:= crHourGlass;
  try
    if IsOperateSucc then Exit;
    cxTextEditShieldName.Text:= ClientDataSet2.fieldbyname('SHIELDGROUPNAME').AsString;
    cxTextEditRemark.Text:= ClientDataSet2.fieldbyname('SHIELDREMARK').AsString;
    if ClientDataSet2.fieldbyname('iseffect').AsInteger=0 then
      cxCheckBox1.Checked:= False
    else if ClientDataSet2.FieldByName('iseffect').AsInteger=1 then
      cxCheckBox1.Checked:= True;
    LoadDevInfo(ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger,gPublicParam.cityid);
    gSearchcheck:=0;
    IsAlarmChecked(ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger,gPublicParam.cityid);
  finally
    Screen.Cursor:= crDefault;
  end;
end;

function TFormShieldMgr.GetAlarmContentCount:Integer;
var i : Integer;
begin
  Result:=0;
  for i:=0 to CheckListBoxAlarm.count-1 do
  begin
    if CheckListBoxAlarm.Checked[i] then
      inc(Result);
  end;
end;

procedure TFormShieldMgr.DelDevRecordOnClickEvent(Sender: TObject);
var
  lVariant: Variant;
  lShieldID, i, lCount,lRecordIndex,
  lDevID, lDev_index,
  lCoDevID, lCoDev_index : Integer;
  lSqlstr: string;
  lsuccess: Boolean;
begin
  if  (cxGrid1DBTableView1.DataController.DataSource.DataSet=nil)
    or (not cxGrid1DBTableView1.DataController.DataSource.DataSet.Active)
    or (cxGrid1DBTableView1.DataController.DataSource.DataSet.RecordCount=0)
    or (cxGrid1DBTableView1.DataController.GetSelectedCount=0)
  then
  begin
    application.MessageBox('未选择设备！','提示',mb_ok+mb_defbutton1);
    Exit;
  end;
  //删除设备
  if MessageDlg('确定要删除此设备么？',mtInformation,[mbYes,mbNo],0)= mrYes then
  begin
    try
      lDev_index:= cxGrid1DBTableView1.GetColumnByFieldName('DEVICEID').Index;
      lCoDev_index:= cxGrid1DBTableView1.GetColumnByFieldName('codeviceid').Index;
    except
      Application.MessageBox('未获得关键字段DEVICEID,CODEVICEID！','提示',MB_OK	+MB_ICONINFORMATION);
      exit;
    end;
    lShieldID := ClientDataSet2.FieldByName('SHIELDGROUPID').AsInteger;
    lVariant:= VarArrayCreate([0,cxGrid1DBTableView1.DataController.GetSelectedCount-1],varVariant);
    lCount:= 0;
    for i := cxGrid1DBTableView1.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex := cxGrid1DBTableView1.Controller.SelectedRows[i].RecordIndex;
      lDevID := cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lDev_index);
      lCoDevID := cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lCoDev_index);
      lSqlstr:= 'delete from ALARM_SHIELD_DEV_RELAT where cityid='+IntToStr(gPublicParam.cityid)+
                ' and SHIELDGROUPID=' + IntToStr(lShieldID) +
                ' and DEVICEID=' + IntToStr(lDevID) +
                ' and CODEVICEID=' + IntToStr(lCoDevID);
      lVariant[lCount]:= VarArrayOf([lSqlstr]);
      Inc(lCount);
    end;
    cxGrid1DBTableView1.DataController.DeleteSelection;
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
      Application.MessageBox('删除成功！','提示',MB_OK+64)
    else
      Application.MessageBox('删除失败！','提示',MB_OK+64)
  end;
end;

procedure TFormShieldMgr.cxTreeViewResDblClick(Sender: TObject);
var
  lNode: TTreeNode;
  lClientDataSet: TClientDataSet;
begin
  lNode:= cxTreeViewRes.Selected;
  if (lNode = nil) or (lNode.Data =nil) then Exit;
  case TNodeParamValue(lNode.Data).nodeType of
    Device:
    begin
      if not ((FOperateFlag = 1) or (FOperateFlag = 2)) then
      begin
        application.MessageBox('不是编辑状态！','提示',mb_ok+mb_defbutton1);
        Exit;
      end;
      if cxGrid1DBTableView1.DataController.DataSource.DataSet = nil then
      begin
        application.MessageBox('先选择屏蔽组，再进行操作！','提示',mb_ok+mb_defbutton1);
        Exit;
      end;
      lClientDataSet:= TClientDataSet.Create(nil);
      try
        with lClientDataSet do
        begin
          Close;
          lClientDataSet.ProviderName:= 'DataSetProvider';
          Data:= gTempInterface.GetCDSData(VarArrayOf([1,272,TNodeParamValue(lNode.Data).cityid,TNodeParamValue(lNode.Data).DEVICEGATHERID,TNodeParamValue(lNode.Data).townid,TNodeParamValue(lNode.Data).SUBURBid,TNodeParamValue(lNode.Data).Deviceid]),0);
          if IsEmpty then exit;
          if recordcount<>1 then Exit;
          if ClientDataSet1.Locate('bts_label;codeviceid', VarArrayOf([FieldByName('bts_label').AsString,0]),[]) then
          begin
               ShowMessage('设备已加入该屏蔽组');
          end
          else
          begin
             ClientDataSet1.Append;
             ClientDataSet1.FieldByName('DeviceID').AsInteger  := TNodeParamValue(lNode.Data).Deviceid;
             ClientDataSet1.FieldByName('BTS_Name').AsString   := TNodeParamValue(lNode.Data).DisplayName;
  //           ClientDataSet1.Edit;
    //        ClientDataSet1.FieldByName('townname').AsString   := FieldByName('townname').AsString;
    //        ClientDataSet1.FieldByName('btslevelname').AsString := FieldByName('btslevelname').AsString;
            ClientDataSet1.FieldByName('bts_label').AsString    := FieldByName('bts_label').AsString;
  //          ClientDataSet1.FieldByName('branchname').AsString := FieldByName('branchname').AsString;
    //        ClientDataSet1.FieldByName('btsstatename').AsString := FieldByName('btsstatename').AsString;
    //        ClientDataSet1.FieldByName('btstypename').AsString  := FieldByName('btstypename').AsString;
    //        ClientDataSet1.FieldByName('bts_kindname').AsString := FieldByName('bts_kindname').AsString;
            ClientDataSet1.FieldByName('msc').AsString := FieldByName('msc').AsString;
            ClientDataSet1.FieldByName('bsc').AsString := FieldByName('bsc').AsString;
            ClientDataSet1.FieldByName('lac').AsString := FieldByName('lac').AsString;
            ClientDataSet1.FieldByName('station_addr').AsString     := FieldByName('station_addr').AsString;
    //        ClientDataSet1.FieldByName('bts_netstatename').AsString := FieldByName('bts_netstatename').AsString;
    //        ClientDataSet1.FieldByName('commonality_typename').AsString := FieldByName('commonality_typename').AsString;
            ClientDataSet1.FieldByName('agent_manu').AsString  := FieldByName('agent_manu').AsString;
            ClientDataSet1.FieldByName('source_mode').AsString := FieldByName('source_mode').AsString;
            ClientDataSet1.FieldByName('iron_tower_kind').AsString := FieldByName('iron_tower_kind').AsString;
            ClientDataSet1.FieldByName('codeviceid').AsInteger := 0;
            ClientDataSet1.Post;
          end;
        end;
      finally
        lClientDataSet.Free;
      end;
    end;
    CELL:
    begin
      if not ((FOperateFlag = 1) or (FOperateFlag = 2)) then
      begin
        application.MessageBox('不是编辑状态！','提示',mb_ok+mb_defbutton1);
        Exit;
      end;
      if cxGrid1DBTableView1.DataController.DataSource.DataSet = nil then
      begin
        application.MessageBox('先选择屏蔽组，再进行操作！','提示',mb_ok+mb_defbutton1);
        Exit;
      end;
      lClientDataSet:= TClientDataSet.Create(nil);
      try
        with lClientDataSet do
        begin
          Close;
          lClientDataSet.ProviderName:= 'DataSetProvider';
          Data:= gTempInterface.GetCDSData(VarArrayOf([1,273,TNodeParamValue(lNode.Data).cityid,TNodeParamValue(lNode.Data).DEVICEGATHERID,TNodeParamValue(lNode.Data).townid,TNodeParamValue(lNode.Data).SUBURBid,TNodeParamValue(lNode.Data).Deviceid,TNodeParamValue(lNode.Data).FAN_ID]),0);
          if IsEmpty then exit;
          if recordcount<>1 then Exit;
          if ClientDataSet1.Locate('bts_label;codeviceid', VarArrayOf([FieldByName('bts_label').AsString,FieldByName('fan_id').AsString]),[]) then
          begin
            ShowMessage('设备已加入该屏蔽组');
          end
          else
          begin
            ClientDataSet1.Append;
            ClientDataSet1.FieldByName('DeviceID').AsInteger  := TNodeParamValue(lNode.Data).Deviceid;
            ClientDataSet1.FieldByName('BTS_Name').AsString   := TNodeParamValue(lNode.Data).DisplayName;
            ClientDataSet1.FieldByName('bts_label').AsString    := FieldByName('bts_label').AsString;
            ClientDataSet1.FieldByName('msc').AsString := FieldByName('msc').AsString;
            ClientDataSet1.FieldByName('bsc').AsString := FieldByName('bsc').AsString;
            ClientDataSet1.FieldByName('lac').AsString := FieldByName('lac').AsString;
            ClientDataSet1.FieldByName('station_addr').AsString     := FieldByName('station_addr').AsString;
            ClientDataSet1.FieldByName('agent_manu').AsString  := FieldByName('agent_manu').AsString;
            ClientDataSet1.FieldByName('source_mode').AsString := FieldByName('source_mode').AsString;
            ClientDataSet1.FieldByName('iron_tower_kind').AsString := FieldByName('iron_tower_kind').AsString;
            ClientDataSet1.FieldByName('codeviceid').AsInteger := FieldByName('fan_id').AsInteger;
            ClientDataSet1.FieldByName('cell_no').AsString := FieldByName('cell_no').AsString;
            ClientDataSet1.FieldByName('cid_num_sixteen').AsString := FieldByName('cid_num_sixteen').AsString;
            ClientDataSet1.FieldByName('pn_code').AsString := FieldByName('pn_code').AsString;
            ClientDataSet1.FieldByName('antenna_kind').AsString := FieldByName('antenna_kind').AsString;
            ClientDataSet1.FieldByName('azimuth').AsString := FieldByName('azimuth').AsString;
            ClientDataSet1.Post;
          end;
        end;
      finally
        lClientDataSet.Free;
      end;
    end;
  end;
end;

procedure TFormShieldMgr.SetStatus(aBool: Boolean);
begin
  cxTextEditShieldName.Enabled:= aBool;
  cxTextEditRemark.Enabled:= aBool;
  cxCheckBox1.Enabled:= aBool;
  cxBtnAdd.Enabled:= not aBool;
  cxBtnModify.Enabled:= not aBool;
  cxBtnDel.Enabled:= not aBool;
  cxBtnSave.Enabled:= aBool;
  cxBtnCancel.Enabled:= aBool;
  cxBtnImport.Enabled:= aBool;
end;

procedure TFormShieldMgr.N1Click(Sender: TObject);
var i: Integer;
    lAlarmObject:TWdInteger;
    lAlarmName: string;
    lContentCode: integer;
begin

   
  for i:=0 to CheckListBoxAlarm.Count-1 do
  begin
    lAlarmName:= CheckListBoxAlarm.Items[i];
    lContentCode:= TWdInteger(CheckListBoxAlarm.Items.Objects[i]).Value;
    CheckListBoxAlarm.Checked[i]:=True;
    if gSelectedAlarmContentList.IndexOf(inttostr(lContentCode))<0 then
        begin
          lAlarmObject:=TWdInteger.Create(lContentCode);
          gSelectedAlarmContentList.AddObject(lAlarmName,lAlarmObject);
        end;
  end;
end;

procedure TFormShieldMgr.N2Click(Sender: TObject);
var i: Integer;
    lAlarmObject:TWdInteger;
    lAlarmName: string;
    lContentCode: integer;
begin
  for i:=0 to CheckListBoxAlarm.Count-1 do
  begin
   CheckListBoxAlarm.Checked[i]:= not CheckListBoxAlarm.Checked[i];
   lAlarmName:= CheckListBoxAlarm.Items[i];
   lContentCode:= TWdInteger(CheckListBoxAlarm.Items.Objects[i]).Value;
   if CheckListBoxAlarm.Checked[i] then
     begin
      if gSelectedAlarmContentList.IndexOf(inttostr(lContentCode))<0 then
        begin
          lAlarmObject:=TWdInteger.Create(lContentCode);
          gSelectedAlarmContentList.AddObject(lAlarmName,lAlarmObject);
        end;
     end
   else
     begin
        if gSelectedAlarmContentList.IndexOf(lAlarmName) >-1 then
        begin
          gSelectedAlarmContentList.Objects[gSelectedAlarmContentList.IndexOf(lAlarmName)].Free;
          gSelectedAlarmContentList.Delete(gSelectedAlarmContentList.IndexOf(lAlarmName));
         end;
     end;



  end;
end;

procedure TFormShieldMgr.GetPathList(aDataSet: TClientDataSet;
  aPathList: TStringList);
begin
  aPathList.Clear;
  if aDataSet.Active and (aDataSet.RecordCount>0) then
  begin
    aPathList.Add(aDataSet.FieldByName('provincename').AsString);
    aPathList.Add(aDataSet.FieldByName('cityname').AsString);
    aPathList.Add(aDataSet.FieldByName('devicegathername').AsString);
    aPathList.Add(aDataSet.FieldByName('areaname').AsString);  
    aPathList.Add(aDataSet.FieldByName('branchname').AsString);
    //由于界面上的树节点是显示bts_name 所以末个字段用bts_name
    aPathList.Add(aDataSet.FieldByName('bts_name').AsString+'['+IntToStr(aDataSet.fieldbyname('Bts_Label').AsInteger)+']');
  end;
end;

function TFormShieldMgr.GetLocateFirstNode(aTreeView: TcxTreeView;
  aPathList: TStringList): TTreeNode;
var
  lFirstNode: TTreeNode;
  lKeyValue: string;
begin
  result:= nil;
  FPathListIndex:= 0;
  lFirstNode:= aTreeView.Items.GetFirstNode;
  if (lFirstNode=nil) or (aPathList.Count=0) then
  begin
    FIsLocateEffect:= false;
    exit;
  end;
  lKeyValue:= aPathList.Strings[fPathListIndex];
  if JudgeNode(lFirstNode.Text,lKeyValue) then
  begin
    result:= lFirstNode;
  end
  else
  begin
    result:= GetLocateFirstNode(lFirstNode,lKeyValue);
  end;
end;

function TFormShieldMgr.GetLocateFirstNode(aTopNode: TTreeNode;
  aKeyValue: string): TTreeNode;
var
  lNode: TTreeNode;
begin
  result := nil;
  aTopNode.Expand(false);
  lNode:= aTopNode.getFirstChild;
  while lNode<>nil do
  begin
    if JudgeNode(lNode.Text,aKeyValue) then
    begin
      result:= lNode;
    end
    else
    begin
      result:= GetLocateFirstNode(lNode,aKeyValue);
    end;
    if result<>nil then break;
    lNode:= lNode.getNextSibling;
  end;
end;

function TFormShieldMgr.GetLocateNode(aTopNode: TTreeNode;
  aPathList: TStringList; aPathIndex: integer): TTreeNode;
var
  lNode: TTreeNode;
begin
  result := nil;
  aTopNode.Expand(false);
  lNode:= aTopNode.getFirstChild;
  while lNode<>nil do
  begin
    if JudgeNode(lNode.Text,aPathList.Strings[aPathIndex]) then
    begin
      result:= lNode;
      break;
    end;
    lNode:= lNode.getNextSibling;
  end;
end;

function TFormShieldMgr.GetLocateNode(aTreeView: TcxTreeView;
  aPathList: TStringList): TTreeNode;
var
  lCurrNode: TTreeNode;
begin
  aTreeView.Items.BeginUpdate;
  try
    lCurrNode:= GetLocateFirstNode(aTreeView,aPathList);
    while lCurrNode<>nil do
    begin
      if fPathListIndex+1>=aPathList.Count then break;
      inc(fPathListIndex);
      lCurrNode:= GetLocateNode(lCurrNode,aPathList,fPathListIndex);
    end;
    result := lCurrNode;
  finally
    aTreeView.Items.EndUpdate;
  end;
end;

function TFormShieldMgr.JudgeNode(aText1, aText2: string): boolean;
begin
  if uppercase(trim(aText1))=uppercase(trim(aText2)) then
    result:= true
  else result:= false;
end;

procedure TFormShieldMgr.SpeedButtonNextClick(Sender: TObject);
begin
  gCFMS_TreeHelper.RefreshTree('',2,6,false);
end;

procedure TFormShieldMgr.SpeedButtonSearchClick(Sender: TObject);
begin
  if trim(cxTextEditSearch.Text)='' then
    begin
       Application.MessageBox('先输入查询条件', '提示', MB_OK + MB_ICONINFORMATION);
       gCFMS_TreeHelper.RefreshTree('',2,6,false)
    end
  else//展开到第六级
    gCFMS_TreeHelper.RefreshTree(cxTextEditSearch.Text,6,6,true);
end;

procedure TFormShieldMgr.cxTextEditSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    SpeedButtonSearchClick(self);
end;
        {   增加导入设备到已知屏蔽组中  }
        
procedure TFormShieldMgr.cxBtnImportClick(Sender: TObject);
var
  lCallList:TStringList;
  lVarCallList:OleVariant;
  i,j,z,lTemp:integer;
  lSqlstr,lCall, lSqlDev, lSqlShield:string;
  lFileName,fFileName:string;
  lVariant: variant;
  lsuccess: boolean;
const
  MAX_COMMIT_COUNT=500;
begin
  if opendialog1.Execute then
  begin
    lFileName:= opendialog1.FileName;
    lCallList:=TStringList.Create;
  end
  else
    exit;

  try
    begin
    lCallList.Duplicates:=dupIgnore;
    lCallList.Sorted:=true;
    application.ProcessMessages;
    fFileName:=UpperCase(ExtractFileExt(lFileName));
    Screen.Cursor := crHourGlass;
    if fFileName='.XLS' then
      ParseXLS(lFileName,lCallList)
    else if (fFileName='.CSV') or (fFileName='.TXT') then
      ParseTxt(lFileName,lCallList);
    Screen.Cursor := crDefault ;
    application.ProcessMessages;
    Application.MessageBox(pchar('过滤重复记录后,文件共有'+inttostr(lCallList.Count)+'条记录..'),'提示',MB_OK);
    if lCallList.Count>20000 then
      begin
        Application.MessageBox(pchar('数据量太大，请联系管理员！'),'提示',MB_OK);
        exit;
      end;

    Screen.Cursor := crHourGlass;
    if lCallList.Count < MAX_COMMIT_COUNT then
    begin
      lVariant:= VarArrayCreate([0,0],varVariant);
      for z := 0 to lCallList.Count - 1 do
      begin
        lCall:=lCallList[Z];
        lSqlDev:= 'select * from fms_device_info where deviceid=' + lCall + 'and cityid=' + IntToStr(gPublicParam.cityid);
        lSqlShield:= 'select * from ALARM_SHIELD_DEV_RELAT where shieldgroupid=' +
                     IntToStr(ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger) +
                     ' and deviceid=' + lCall +
                     ' and cityid=' + IntToStr(gPublicParam.cityid);
        if IsExistRecord(lSqlDev)=1 then
          if IsExistRecord(lSqlShield)=0 then
          begin
            lSqlstr:='insert into ALARM_SHIELD_DEV_RELAT(CITYID,SHIELDGROUPID,DEVICEID) '+
                       'values(' +
                       IntToStr(gPublicParam.cityid) + ',' +
                       IntToStr(ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger) + ',' +
                       lCall + ')';
            lVariant[0]:= VarArrayOf([lSqlstr]);
            lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
          end;
      end;
    end
    else
    begin
      for i := 0 to (lCallList.Count div MAX_COMMIT_COUNT) do
      begin
        lTemp:= i*MAX_COMMIT_COUNT  ;
        if (lTemp+MAX_COMMIT_COUNT)>lCallList.Count then
          if lCallList.Count=lTemp then  break  else
          lVarCallList:=VarArrayCreate([0,lCallList.Count-lTemp-1],varVariant)
        else
          lVarCallList:=VarArrayCreate([0,MAX_COMMIT_COUNT-1],varVariant);
          for j := 0 to MAX_COMMIT_COUNT - 1 do
          begin
            if  (lTemp+j) > (lCallList.Count-1) then break;
            lVarCallList[j]:=lCallList.Strings[lTemp+j];
          end;
        application.ProcessMessages;
        ImportCallNumber(lVarCallList);
      end;
    end;
    Application.MessageBox('导入成功','提示',MB_OK);
    LoadDevInfo(ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger, gPublicParam.cityid);
    Screen.Cursor := crDefault ;
    end;
  except
    Screen.Cursor := crDefault ;
  end;
end;

procedure TFormShieldMgr.ParseXLS(FileName:string;CallList:TStrings);
var
  FExcel: Variant;
  FWorkbook: Variant;
  FWorksheet: Variant;
  lCount:integer;
  lCall:string;
begin
  CallList.Clear;
  try
    FExcel := CreateOleObject('excel.application');
  except
    Application.MessageBox('Excel OLE server not found','信息',MB_OK+MB_ICONINFORMATION	) ;
    Exit;
  end;
  try
    if not FileExists(FileName) then exit;

    FWorkBook := FExcel.WorkBooks.Open(FileName);
    FWorkSheet := FWorkBook.ActiveSheet  ;
    if VarIsEmpty(FWorksheet) then
    begin
      Exit;
    end;
    lCount:=2;    //lCount:=1;Excel列没有标题，2有标题，Tstrings加载时不加标题。
    while True do
    begin
      try
        lCall:=FWorksheet.Cells[lCount,1];
      except on E: Exception do
        break;
      end;
      lCall:=Trim(lCall);
      if lcall='' then
      break;
      if IsNum(lCall) then
      begin
      CallList.Add(lCall);
      inc(lCount);
      end else
      inc(lCount);
      if lCount>=65536 then //excel最大支持65536
        break;
    end;
  finally
    FExcel.Quit;
    FExcel := UnAssigned;
  end;
end;

procedure TFormShieldMgr.ParseTxt(FileName:string;CallList:TStrings);
var
  lCDRFile : TextFile;
  lLineContent:string;
begin
  CallList.Clear;
  AssignFile(lCDRFile,FileName);
  Reset(lCDRFile);
  while not Eof(lCDRFile) do
  begin
    lLineContent :='';
    Readln(lCDRFile,lLineContent);
    if Pos(',',lLineContent)>0 then
      lLineContent:=Copy(lLineContent,1,Pos(',',lLineContent)-1);
    if Pos('"',lLineContent)>0 then
      lLineContent:=Copy(lLineContent,2,length(lLineContent)-2);
    if IsNum(lLineContent) then
    begin
      CallList.Add(lLineContent);
    end;
  end;
  CloseFile(lCDRFile);
end;

procedure TFormShieldMgr.ImportCallNumber(var CallNumberList: OleVariant);
var
  I:integer;
  lCall, lSqlstr:string;
  lVariant: variant;
  lsuccess: boolean;
begin
  lVariant:= VarArrayCreate([0,0],varVariant);
  for I := VarArrayLowBound(CallNumberList,1) to VarArrayHighBound(CallNumberList,1) do
  begin
    lCall:=CallNumberList[I];
    lSqlstr:='insert into ALARM_SHIELD_DEV_RELAT(CITYID,SHIELDGROUPID,DEVICEID) '+
               'values(' +
               IntToStr(gPublicParam.cityid) + ',' +
               IntToStr(ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger) + ',' +
               lCall + ')';
    lVariant[0]:= VarArrayOf([lSqlstr]);;
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  end;
end;

function  TFormShieldMgr.IsNum(lstr:string):boolean;
var
  I: Integer;
  fstring:string;
begin
  fstring:=lstr;
  if fstring='' then
  begin
    result:=false;
    exit;
  end;
  for I := 1 to length(fstring)-1 do
  begin
    if (copy(fstring,i,1)>='0' ) and (copy(fstring,i,1)<='9' )then
      result:=true
    else
    begin
      result:=false;
      exit;
    end;
  end;
end;

function TFormShieldMgr.IsExistRecord(aSqlStr: string): Integer;
var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
begin
  lClientDataSet:= TClientDataSet.create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,aSqlStr]),0);
      if IsEmpty then
        Result:=0
      else
        Result:=1;
    end;
//    showmessage(aSqlStr+';'+IntToStr(Result));
  except

  end;
end;

procedure TFormShieldMgr.FreeMenu;
var
  i: Integer;
begin
  for i:=0 to MenuAdd.Count-1 do
    if Assigned(MenuAddShieldGroup[i]) then
      MenuAddShieldGroup[i].Free;
  SetLength(MenuAddShieldGroup,0);
  for i:=0 to MenuDel.Count-1 do
    if Assigned(MenuDelShieldGroup[i]) then
      MenuDelShieldGroup[i].Free;
  SetLength(MenuDelShieldGroup,0);

//  if Assigned(MenuAdd)then
//    MenuAdd.Free;
//  if Assigned(MenuDel)then
//    MenuDel.Free;
end;

procedure TFormShieldMgr.AddResTreeFirstMenu;
begin
    PopupMenu2.Items.Clear;

    MenuAdd:= TMenuItem.Create(nil);
    MenuAdd.RadioItem:= True;
    MenuAdd.Caption:= '添  加';
//    MenuAdd.OnClick:= PopupMenuAdd;
    PopupMenu2.Items.Add(MenuAdd);

    MenuDel:= TMenuItem.Create(nil);
    MenuDel.RadioItem:= True;
    MenuDel.Caption:= '解  除';
//    MenuDel.OnClick:= PopupMenuDel;
    PopupMenu2.Items.Add(MenuDel);
end;

procedure TFormShieldMgr.cxTreeViewResMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode: TTreeNode;
  lClientDataSetAdd, lClientDataSetDel: TClientDataSet;
  lSqlstr: string;
  i: Integer;
begin
  lNode:= cxTreeViewRes.Selected;
  if (lNode = nil) or (lNode.Data =nil) then Exit;
  MenuAdd.Enabled:= False;
  MenuDel.Enabled:= False;
  case TNodeParamValue(lNode.Data).nodeType of
  Device:
    begin
      MenuAdd.Enabled:= True;
      MenuDel.Enabled:= True;
      //add menu
      try
        lClientDataSetAdd:= TClientDataSet.Create(nil);
        with lClientDataSetAdd do
        begin
          MenuAdd.Clear;
          Close;
          ProviderName:= 'DataSetProvider';
          lSqlstr:= ' select * from alarm_shield_info where shieldgroupid not in '+
                    ' (select shieldgroupid from alarm_shield_dev_relat ' +
                    ' where cityid=' + IntToStr(gPublicParam.cityid) +
                    ' and deviceid=' + IntToStr(TNodeParamValue(lNode.Data).Deviceid) + ')';
          Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
          if IsEmpty then
          begin
            MenuAdd.Enabled:= False;
          end;

          SetLength(MenuAddShieldGroup,RecordCount);
          for i:=0 to RecordCount-1 do
          begin
            MenuAddShieldGroup[i]:= TMenuItem.Create(nil);
            MenuAddShieldGroup[i].RadioItem:= True;
            MenuAddShieldGroup[i].Caption:= FieldByName('shieldgroupname').AsString;
            MenuAddShieldGroup[i].Tag:= FieldByName('shieldgroupID').AsInteger;
            MenuAddShieldGroup[i].OnClick:= PopupMenuAdd;
            MenuAdd.Add(MenuAddShieldGroup[i]);
            Next;
          end;
        end;
      finally
        lClientDataSetAdd.Free;
      end;

      //del menu
      try
        lClientDataSetDel:= TClientDataSet.Create(nil);
        with lClientDataSetDel do
        begin
          MenuDel.Clear;
          Close;
          ProviderName:= 'DataSetProvider';
          lSqlstr:= ' select a.*,b.shieldgroupname from ALARM_SHIELD_DEV_RELAT a ' +
                    ' left join alarm_SHIELD_info b on a.cityid=b.cityid and a.shieldgroupid=b.shieldgroupid ' +
                    ' where a.cityid=' + IntToStr(gPublicParam.cityid) +
                    ' and a.deviceid=' + IntToStr(TNodeParamValue(lNode.Data).Deviceid);
          Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
          if IsEmpty then
          begin
            MenuDel.Enabled:= False;
            exit;
          end;

          SetLength(MenuDelShieldGroup,RecordCount);
          for i:=0 to RecordCount-1 do
          begin
            MenuDelShieldGroup[i]:= TMenuItem.Create(nil);
            MenuDelShieldGroup[i].RadioItem:= True;
            MenuDelShieldGroup[i].Caption:= FieldByName('shieldgroupname').AsString;
            MenuDelShieldGroup[i].Tag:= FieldByName('shieldgroupID').AsInteger;
            MenuDelShieldGroup[i].OnClick:= PopupMenuDel;
            MenuDel.Add(MenuDelShieldGroup[i]);
            Next;
          end;
        end;
      finally
        lClientDataSetDel.Free;
      end;
    end;
  CELL:
  begin

  end;
  end;
end;

procedure TFormShieldMgr.PopupMenuAdd(Sender: Tobject);
var
  lNode: TTreeNode;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lNode:= cxTreeViewRes.Selected;
  if (lNode = nil) or (lNode.Data =nil) then Exit;
  case TNodeParamValue(lNode.Data).nodeType of
  Device, CELL:
  begin
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr:= 'Insert into alarm_shield_dev_relat(CITYID,SHIELDGROUPID,DEVICEID,CODEVICEID) values(' +
              IntToStr(gPublicParam.cityid) + ',' +
              IntToStr((Sender as TMenuItem).Tag) + ',' +
              IntToStr(TNodeParamValue(lNode.Data).Deviceid) + ',' +
              IntToStr(TNodeParamValue(lNode.Data).FAN_ID) +
              ')';
    lVariant[0]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
      Application.MessageBox('添加成功','提示',MB_OK+64)
    else
      Application.MessageBox('添加失败','提示',MB_OK+64);
  end;
  end;
end;

procedure TFormShieldMgr.PopupMenuDel(Sender: Tobject);
var
  lNode: TTreeNode;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lNode:= cxTreeViewRes.Selected;
  if (lNode = nil) or (lNode.Data =nil) then Exit;
  case TNodeParamValue(lNode.Data).nodeType of
  Device, CELL:
  begin
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr:= 'Delete from alarm_shield_dev_relat where CITYID=' +
              IntToStr(gPublicParam.cityid) +
              ' and SHIELDGROUPID=' +
              IntToStr((Sender as TMenuItem).Tag) +
              ' and DEVICEID=' +
              IntToStr(TNodeParamValue(lNode.Data).Deviceid) +
              ' and codeviceid=' +
              IntToStr(TNodeParamValue(lNode.Data).FAN_ID);
    lVariant[0]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
      Application.MessageBox('删除成功','提示',MB_YESNO+64)
    else
      Application.MessageBox('删除失败','提示',MB_OK+64);
  end;
  end;
end;

procedure TFormShieldMgr.PopupMenu2Popup(Sender: TObject);
var
  lNode: TTreeNode;
  lClientDataSetAdd, lClientDataSetDel: TClientDataSet;
  lSqlstr: string;
  i: Integer;
begin
  lNode:= cxTreeViewRes.Selected;
  if (lNode = nil) or (lNode.Data =nil) then Exit;
  MenuAdd.Enabled:= False;
  MenuDel.Enabled:= False;
  case TNodeParamValue(lNode.Data).nodeType of
  Device:            //基站
    begin
      MenuAdd.Enabled:= True;
      MenuDel.Enabled:= True;
      //add menu
      try
        lClientDataSetAdd:= TClientDataSet.Create(nil);
        with lClientDataSetAdd do
        begin
          MenuAdd.Clear;
          Close;
          ProviderName:= 'DataSetProvider';
          lSqlstr:= ' select * from alarm_shield_info where shieldgroupid not in '+
                    ' (select shieldgroupid from alarm_shield_dev_relat ' +
                    ' where cityid=' + IntToStr(gPublicParam.cityid) +
                    ' and deviceid=' + IntToStr(TNodeParamValue(lNode.Data).Deviceid) +
                    ' and codeviceid=' + IntToStr(TNodeParamValue(lNode.Data).FAN_ID) +
                    ')';
          Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
          if IsEmpty then
          begin
            MenuAdd.Enabled:= False;
          end;

          SetLength(MenuAddShieldGroup,RecordCount);
          for i:=0 to RecordCount-1 do
          begin
            MenuAddShieldGroup[i]:= TMenuItem.Create(nil);
            MenuAddShieldGroup[i].RadioItem:= True;
            MenuAddShieldGroup[i].Caption:= FieldByName('shieldgroupname').AsString;
            MenuAddShieldGroup[i].Tag:= FieldByName('shieldgroupID').AsInteger;
            MenuAddShieldGroup[i].OnClick:= PopupMenuAdd;
            MenuAdd.Add(MenuAddShieldGroup[i]);
            Next;
          end;
        end;
      finally
        lClientDataSetAdd.Free;
      end;

      //del menu
      try
        lClientDataSetDel:= TClientDataSet.Create(nil);
        with lClientDataSetDel do
        begin
          MenuDel.Clear;
          Close;
          ProviderName:= 'DataSetProvider';
          lSqlstr:= ' select a.*,b.shieldgroupname from ALARM_SHIELD_DEV_RELAT a ' +
                    ' left join alarm_SHIELD_info b on a.cityid=b.cityid and a.shieldgroupid=b.shieldgroupid ' +
                    ' where a.cityid=' + IntToStr(gPublicParam.cityid) +
                    ' and a.deviceid=' + IntToStr(TNodeParamValue(lNode.Data).Deviceid) +
                    ' and a.codeviceid=' + IntToStr(TNodeParamValue(lNode.Data).FAN_ID) ;
          Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
          if IsEmpty then
          begin
            MenuDel.Enabled:= False;
            exit;
          end;

          SetLength(MenuDelShieldGroup,RecordCount);
          for i:=0 to RecordCount-1 do
          begin
            MenuDelShieldGroup[i]:= TMenuItem.Create(nil);
            MenuDelShieldGroup[i].RadioItem:= True;
            MenuDelShieldGroup[i].Caption:= FieldByName('shieldgroupname').AsString;
            MenuDelShieldGroup[i].Tag:= FieldByName('shieldgroupID').AsInteger;
            MenuDelShieldGroup[i].OnClick:= PopupMenuDel;
            MenuDel.Add(MenuDelShieldGroup[i]);
            Next;
          end;
        end;
      finally
        lClientDataSetDel.Free;
      end;
    end;
  CELL:        //小区
  begin
    MenuAdd.Enabled:= True;
    MenuDel.Enabled:= True;
    //add menu
    try
      lClientDataSetAdd:= TClientDataSet.Create(nil);
      with lClientDataSetAdd do
      begin
        MenuAdd.Clear;
        Close;
        ProviderName:= 'DataSetProvider';
        lSqlstr:= ' select * from alarm_shield_info where shieldgroupid not in '+
                  ' (select shieldgroupid from alarm_shield_dev_relat ' +
                  ' where cityid=' + IntToStr(gPublicParam.cityid) +
                  ' and deviceid=' + IntToStr(TNodeParamValue(lNode.Data).Deviceid) +
                  ' and codeviceid=' + IntToStr(TNodeParamValue(lNode.Data).FAN_ID) +
                  ')';
        Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
        if IsEmpty then
        begin
          MenuAdd.Enabled:= False;
        end;

        SetLength(MenuAddShieldGroup,RecordCount);
        for i:=0 to RecordCount-1 do
        begin
          MenuAddShieldGroup[i]:= TMenuItem.Create(nil);
          MenuAddShieldGroup[i].RadioItem:= True;
          MenuAddShieldGroup[i].Caption:= FieldByName('shieldgroupname').AsString;
          MenuAddShieldGroup[i].Tag:= FieldByName('shieldgroupID').AsInteger;
          MenuAddShieldGroup[i].OnClick:= PopupMenuAdd;
          MenuAdd.Add(MenuAddShieldGroup[i]);
          Next;
        end;
      end;
    finally
      lClientDataSetAdd.Free;
    end;

    //del Cell menu
      try
        lClientDataSetDel:= TClientDataSet.Create(nil);
        with lClientDataSetDel do
        begin
          MenuDel.Clear;
          Close;
          ProviderName:= 'DataSetProvider';
          lSqlstr:= ' select a.*,b.shieldgroupname from ALARM_SHIELD_DEV_RELAT a ' +
                    ' left join alarm_SHIELD_info b on a.cityid=b.cityid and a.shieldgroupid=b.shieldgroupid ' +
                    ' where a.cityid=' + IntToStr(gPublicParam.cityid) +
                    ' and a.deviceid=' + IntToStr(TNodeParamValue(lNode.Data).Deviceid) +
                    ' and a.codeviceid=' + IntToStr(TNodeParamValue(lNode.Data).FAN_ID) ;
          Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
          if IsEmpty then
          begin
            MenuDel.Enabled:= False;
            exit;
          end;

          SetLength(MenuDelShieldGroup,RecordCount);
          for i:=0 to RecordCount-1 do
          begin
            MenuDelShieldGroup[i]:= TMenuItem.Create(nil);
            MenuDelShieldGroup[i].RadioItem:= True;
            MenuDelShieldGroup[i].Caption:= FieldByName('shieldgroupname').AsString;
            MenuDelShieldGroup[i].Tag:= FieldByName('shieldgroupID').AsInteger;
            MenuDelShieldGroup[i].OnClick:= PopupMenuDel;
            MenuDel.Add(MenuDelShieldGroup[i]);
            Next;
          end;
        end;
      finally
        lClientDataSetDel.Free;
      end;
  end;
  end;
end;

procedure TFormShieldMgr.cxGrid2Enter(Sender: TObject);
begin
  MenuItem_Del.Visible:= False;
end;

procedure TFormShieldMgr.cxGrid1Enter(Sender: TObject);
begin
  MenuItem_Del.Visible:= True;
end;

procedure TFormShieldMgr.BtnSearchClick(Sender: TObject);
var
  lSqlStr, lWhereStr, lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lClientDataSet: TClientDataSet;
  I: Integer;
begin
  ClearTStrings(CheckListBoxAlarm.Items);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    if EdtSearch.Text='' then
      lWhereStr:= ''
    else
     lWhereStr:= GetBlurQueryWhere('ALARMCONTENTNAME','a.ALARMCONTENTCODE',EdtSearch.Text);
     lSqlStr:= 'select * from alarm_content_info a'+
              ' left join (select * from ALARM_SHIELD_ALARM_RELAT where shieldgroupid='+
              IntToStr(ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger) +') b'+
              ' on a.cityid=b.cityid and a.alarmcontentcode = b.alarmcontentcode'+
              ' where a.cityid=' +
              IntToStr(gPublicParam.cityid) +
              lWhereStr +
              ' order by a.ALARMCONTENTCODE';
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
        CheckListBoxAlarm.Items.AddObject(lAlarmCaption,lAlarmObject);
        Next;
      end;
      gSearchcheck:=1;
      IsAlarmChecked(ClientDataSet2.fieldbyname('SHIELDGROUPID').AsInteger,gPublicParam.cityid);
      for i:= 0 to CheckListBoxAlarm.Items.Count - 1 do
        begin
          if gSelectedAlarmContentList.IndexOf(CheckListBoxAlarm.Items[i])>-1 then
            if not CheckListBoxAlarm.Checked[i] then
              CheckListBoxAlarm.Checked[i]:= true;
        end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormShieldMgr.EdtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then
    BtnSearchClick(Self);
end;

procedure TFormShieldMgr.CheckListBoxAlarmClickCheck(Sender: TObject);
begin
    if ClientDataSet1.Active=False then
    begin
       Application.MessageBox('请先选择屏蔽组','提示',MB_OK+64);
       Exit;
    end;
    ClickCheck(CheckListBoxAlarm.ItemIndex,CheckListBoxAlarm.Checked[CheckListBoxAlarm.ItemIndex],true);
end;
procedure TFormShieldMgr.ClickCheck(aIndex: integer; aChecked, aLastFlag: boolean);
 var
  lContentCode: integer;
  lWdInteger: TWdInteger;
  lDestListItem: TListItem;
  lHashIndex: integer;
  I: integer;
  lAlarmObject:TWdInteger;
  lAlarmName: string;
begin
   lAlarmName:= CheckListBoxAlarm.Items[aIndex];
   lContentCode:= TWdInteger(CheckListBoxAlarm.Items.Objects[aIndex]).Value;
   if aChecked then
     begin
      if gSelectedAlarmContentList.IndexOf(inttostr(lContentCode))<0 then
        begin
          lAlarmObject:=TWdInteger.Create(lContentCode);
          gSelectedAlarmContentList.AddObject(lAlarmName,lAlarmObject);
        end;
     end
   else
     begin
        lHashIndex:= gSelectedAlarmContentList.IndexOf(lAlarmName);
        if lHashIndex >-1 then
        begin
          gSelectedAlarmContentList.Objects[lHashIndex].Free;
          gSelectedAlarmContentList.Delete(lHashIndex);
         end;
     end;
end;

procedure TFormShieldMgr.CheckListBoxAlarmClick(Sender: TObject);
begin
  if CheckListBoxAlarm.Selected[CheckListBoxAlarm.ItemIndex] then
    CheckListBoxAlarm.Hint:= CheckListBoxAlarm.Items.Strings[CheckListBoxAlarm.ItemIndex];
end;

end.



