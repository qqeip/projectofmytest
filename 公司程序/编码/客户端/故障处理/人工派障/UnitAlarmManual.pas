unit UnitAlarmManual;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, ComCtrls,
  cxLookAndFeelPainters, Menus, CheckLst, cxButtons, cxTextEdit, cxLabel,
  Buttons, cxGroupBox, cxContainer, cxTreeView, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, dxDockPanel, dxDockControl, ImgList, DBClient,
  StringUtils, CxGridUnit, UDevExpressToChinese, UnitDBVerticalGridEditor,
  UnitCFMSTreeHelper;

type
  TFormAlarmManual = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    dxDockingManager1: TdxDockingManager;
    ImageTree: TImageList;
    dxDockSite1: TdxDockSite;
    dxLayoutDockSite3: TdxLayoutDockSite;
    dxLayoutDockSite5: TdxLayoutDockSite;
    dxLayoutDockSite2: TdxLayoutDockSite;
    dxDockPanel2: TdxDockPanel;
    cxGridAlarmMaster: TcxGrid;
    cxGridAlarmMasterDBTableView1: TcxGridDBTableView;
    cxGridAlarmMasterLevel1: TcxGridLevel;
    dxDockPanel4: TdxDockPanel;
    dxDockPanel1: TdxDockPanel;
    cxTreeView1: TcxTreeView;
    cxGroupBox8: TcxGroupBox;
    SpeedButtonSearch: TSpeedButton;
    SpeedButtonNext: TSpeedButton;
    cxLabel3: TcxLabel;
    cxTextEditSearch: TcxTextEdit;
    Panel2: TPanel;
    cxGroupBox1: TcxGroupBox;
    cxGroupBox2: TcxGroupBox;
    cxGroupBox3: TcxGroupBox;
    CheckListBoxCompany: TCheckListBox;
    Memo1: TMemo;
    CDS_AlarmMaster: TClientDataSet;
    DS_AlarmMaster: TDataSource;
    dxDockPanel3: TdxDockPanel;
    dxLayoutDockSite4: TdxLayoutDockSite;
    FrameDBVerticalGridEditor1: TFrameDBVerticalGridEditor;
    Panel3: TPanel;
    cxButtonSendAlarm: TcxButton;
    cxButtonClose: TcxButton;
    DSAlarm: TDataSource;
    CDSAlarm: TClientDataSet;
    cxGridAlarm: TcxGrid;
    cxGridAlarmDBTableView1: TcxGridDBTableView;
    cxGridAlarmLevel1: TcxGridLevel;
    imageList2: TImageList;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dxDockPanel1AutoHideChanged(Sender: TdxCustomDockControl);
    procedure dxDockPanel1AutoHideChanging(Sender: TdxCustomDockControl);
    procedure cxButtonCloseClick(Sender: TObject);
    procedure cxButtonSendAlarmClick(Sender: TObject);
    procedure SpeedButtonSearchClick(Sender: TObject);
    procedure SpeedButtonNextClick(Sender: TObject);
    procedure cxTextEditSearchKeyPress(Sender: TObject; var Key: Char);
    procedure cxTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure cxGridAlarmEnter(Sender: TObject);
    procedure cxGridAlarmExit(Sender: TObject);
  private
    //条件
    gAlarmStatusWhere: string;
    gGlobalWhere: string;
    gFilterWhere: string;
    FControlChanging: boolean;
    FCxGridHelper : TCxGridSet;
    FPathList: TStringList;
    FPathListIndex: integer;
    FIsLocateEffect: boolean;
    FDataSetLocate: TClientDataSet;
    gCFMS_TreeHelper: TCFMS_TreeHelper;
    FMenuAdd, FMenuModify: TMenuItem; //增加告警内容右键菜单
    //树图操作

    //树图定位
    function JudgeNode(aText1,aText2: string):boolean;
    function GetLocateFirstNode(aTreeView: TcxTreeView; aPathList: TStringList): TTreeNode;overload;
    function GetLocateFirstNode(aTopNode: TTreeNode; aKeyValue: string): TTreeNode;overload;
    function GetLocateNode(aTopNode: TTreeNode; aPathList: TStringList; aPathIndex: integer): TTreeNode;overload;
    //根据路径定位节点   //浙江省，杭州市，西湖区，MTU001
    function GetLocateNode(aTreeView: TcxTreeView; aPathList: TStringList): TTreeNode;overload;
    procedure GetPathList(aDataSet: TClientDataSet; aPathList: TStringList);


    //根据基站过滤告警
    procedure GetAlarmDetail(aCityid, aDeviceid: integer);
    //根据基站和告警内容过滤维护单位
//    procedure GetCompanyMutil(aCityid: integer; aDeviceid, aContentcode: string);
    procedure LoadAlarm(aCityid: Integer);
    procedure AddAlarmField;
    procedure GetCompanyMutil(aCityid: integer);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionModifyExecute(Sender: TObject);
  public
    FIsGotoAlarmManual: Integer; //是否是重复告警转人工 0 否 1 是
    FDeviceID, FCoDeviceID, FContentCode: Integer; //保存重复告警展现的内容
    FAlarmCaption: string;
    procedure ShowMasterAlarmOnline;     //在线主障告警
  end;

var
  FormAlarmManual: TFormAlarmManual;

implementation

uses UnitDllCommon, UnitAlarmMgr;

{$R *.dfm}

procedure TFormAlarmManual.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //回调，用DLLMGR去释放窗体
  gDllMsgCall(FormAlarmManual,1,'','');
end;

procedure TFormAlarmManual.FormCreate(Sender: TObject);
begin
  FDataSetLocate:= TClientDataSet.Create(nil);
  FPathList:= TStringList.Create;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAlarmMaster,false,true,true);
  FCxGridHelper.NewSetGridStyle(cxGridAlarm,false,true,true);


  //加告警内容的右键菜单
  FMenuAdd:= FCxGridHelper.AppendShowMenuItem('增加',ActionAddExecute,True);
  FMenuModify:= FCxGridHelper.AppendShowMenuItem('修改',ActionModifyExecute,True);
  FMenuAdd.Visible:= False;
  FMenuModify.Visible:= False;

  //加字段
  AddAlarmField;
  LoadFields(cxGridAlarmMasterDBTableView1,gPublicParam.cityid,gPublicParam.userid,21);
  //加载告警内容
  LoadAlarm(gPublicParam.cityid);
  //加载维护单位叶子
  GetCompanyMutil(gPublicParam.cityid);
  //画树
  gCFMS_TreeHelper:= TCFMS_TreeHelper.Create(cxTreeView1,gPublicParam.Cityid,gPublicParam.RuleCompanyidStr);
  gCFMS_TreeHelper.RefreshTree('',2,5,false);

  //加载设备信息
  FrameDBVerticalGridEditor1.IniFrameDevice;
  FrameDBVerticalGridEditor1.FieldGroup:= 22;
  FrameDBVerticalGridEditor1.LoadFields(22,gPublicParam.cityid,gPublicParam.userid);

  FDeviceID:= -1;
  FCoDeviceID:= -1;
  FContentCode:= -1;
  FIsGotoAlarmManual:= 0;
end;

procedure TFormAlarmManual.FormDestroy(Sender: TObject);
begin
  FDataSetLocate.Close;
  FDataSetLocate.Free;
  FPathList.Free;
  ClearTStrings(CheckListBoxCompany.Items);
  //菜单释放
  FCxGridHelper.Free;
end;

procedure TFormAlarmManual.FormShow(Sender: TObject);
begin
  //
end;

procedure TFormAlarmManual.ShowMasterAlarmOnline;
begin
  if not cxGridAlarmMaster.CanFocus then exit;

  DS_AlarmMaster.DataSet:= nil;
  try
    with CDS_AlarmMaster do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,2,'']),0);
    end;
  finally

  end;
  DS_AlarmMaster.DataSet:= CDS_AlarmMaster;
  cxGridAlarmMasterDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmManual.dxDockPanel1AutoHideChanged(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= false;
end;

procedure TFormAlarmManual.dxDockPanel1AutoHideChanging(
  Sender: TdxCustomDockControl);
begin
  FControlChanging:= true;
end;

procedure TFormAlarmManual.cxButtonCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFormAlarmManual.cxButtonSendAlarmClick(Sender: TObject);
var
  lNode: TTreeNode;
  lAlarm_Index, lRecordIndex: integer;
  lDeviceid, lCompanyid, lContentcode: integer;
  I, J: integer;
  lChecked: boolean;
  lMessageInfo: string;
  iError: integer;
begin
  try
    lAlarm_Index:= cxGridAlarmDBTableView1.GetColumnByFieldName('AlarmContentCode').Index;
  except
    Application.MessageBox('未获得关键字段AlarmContentCode！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lChecked:= false;
  for I:= 0 to CheckListBoxCompany.Items.Count -1 do
  begin
    if CheckListBoxCompany.Checked[i] then
    begin
      lChecked:= true;
      break;
    end;
  end;
  if not lChecked then
  begin
    Application.MessageBox('先选择维护单位！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if cxGridAlarmDBTableView1.DataController.GetSelectedCount<1 then
  begin
    Application.MessageBox('先选择告警内容！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;

  lNode:= cxTreeView1.Selected;
  if (lNode<>nil) and (lNode.Data<>nil)
     and (TNodeParamValue(lNode.Data).nodeType= Device) then
  begin
    lDeviceid:= TNodeParamValue(lNode.Data).Deviceid;
    for i:= cxGridAlarmDBTableView1.DataController.GetSelectedCount -1 downto 0 do   //告警内容
    begin
      lRecordIndex := cxGridAlarmDBTableView1.Controller.SelectedRows[I].RecordIndex;
      lContentcode := cxGridAlarmDBTableView1.DataController.GetValue(lRecordIndex,lAlarm_Index);
      for j:= CheckListBoxCompany.Items.Count - 1 downto 0 do//维护单位
      begin
        if CheckListBoxCompany.Checked[j] then
        begin
          lCompanyid:= TWdInteger(CheckListBoxCompany.Items.Objects[j]).Value;
          iError := gTempInterface.MaunalSendFault(gPublicParam.cityid, lCompanyid,
                           lDeviceid, 0, lContentcode, self.Memo1.Lines.Text, gPublicParam.userid,
                           FIsGotoAlarmManual,FCoDeviceID,FContentCode);
          case iError of
            -1: begin
                  lMessageInfo:= '存储过程内部执行异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end;
            -2: begin
                  lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end;
            -3: begin
                  lMessageInfo:= '接口异常错误!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end;
            else if iError < -3 then
                begin
                  lMessageInfo:= '接口未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end
            else if iError = 10 then
                begin
                  lMessageInfo:= '该维护单位已派发该告警!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end
            else if iError = 11 then
                begin
                  lMessageInfo:= '该告警已在待派库中!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end
            else if iError = 12 then
                begin
                  lMessageInfo:= '该基站设备缺失或没有该告警类型!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end
            else if iError = 13 then
                begin
                  lMessageInfo:= '手动派障表alarm_manuallist_view 中找不到该告警,可能该告警被屏蔽!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end
            else if iError > 0 then
                begin
                  lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
                  lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
                  exit;
                end;
          end;
        end;
      end;
    end;

    GetAlarmDetail(gPublicParam.cityid,lDeviceid);
    if  iError= 0 then
    begin
      lMessageInfo:= '人工派障成功!';
      Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
    end;
  end
  else
    Application.MessageBox('先选择一个基站设备！','提示',MB_OK	+MB_ICONINFORMATION);
end;




function TFormAlarmManual.GetLocateFirstNode(aTopNode: TTreeNode;
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

function TFormAlarmManual.GetLocateFirstNode(aTreeView: TcxTreeView;
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

function TFormAlarmManual.GetLocateNode(aTreeView: TcxTreeView;
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

function TFormAlarmManual.GetLocateNode(aTopNode: TTreeNode;
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

procedure TFormAlarmManual.GetPathList(aDataSet: TClientDataSet;
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
    aPathList.Add(aDataSet.FieldByName('bts_name').AsString);
  end;
end;

function TFormAlarmManual.JudgeNode(aText1, aText2: string): boolean;
begin
  if uppercase(trim(aText1))=uppercase(trim(aText2)) then
    result:= true
  else result:= false;
end;

procedure TFormAlarmManual.SpeedButtonSearchClick(Sender: TObject);
begin
  if trim(cxTextEditSearch.Text)='' then
    begin
       Application.MessageBox('先输入查询条件', '提示', MB_OK + MB_ICONINFORMATION);
       gCFMS_TreeHelper.RefreshTree('',2,5,false)
    end
  else
    gCFMS_TreeHelper.RefreshTree(cxTextEditSearch.Text,5,5,true);
end;

procedure TFormAlarmManual.SpeedButtonNextClick(Sender: TObject);
begin
       gCFMS_TreeHelper.RefreshTree('',2,5,false)
 { FDataSetLocate.Next;
  GetPathList(FDataSetLocate,FPathList);
  cxTreeView1.Selected:= GetLocateNode(cxTreeView1,FPathList);
  if FDataSetLocate.RecNo = FDataSetLocate.RecordCount then
    SpeedButtonNext.Enabled:= false;  }
end;

procedure TFormAlarmManual.cxTextEditSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    SpeedButtonSearchClick(self);
end;

procedure TFormAlarmManual.cxTreeView1Change(Sender: TObject;
  Node: TTreeNode);
var
  lDeviceid: integer;
  lContentcode: integer;
  lBtsid: integer;
begin
  //由于DOCKPANEL隐藏的时候会触发事件，所以要屏蔽掉
  if FControlChanging then exit;
  if (Node=nil) or (Node.Data=nil) then exit;
  //如果该节点是基站
  if TNodeParamValue(Node.Data).nodeType= Device then
  begin
    lDeviceid:= TNodeParamValue(Node.Data).Deviceid;
    lBtsid:= TNodeParamValue(Node.Data).BTSID;
    GetAlarmDetail(gPublicParam.cityid, lDeviceid);                                                                                     //BTSID,是基站的唯一标示
    FrameDBVerticalGridEditor1.LoadDeviceInfo(gPublicParam.cityid,gPublicParam.userid,22,lBtsid);
    //刷新维护单位
//    CheckListBoxContentClick(self);
  end;
end;

procedure TFormAlarmManual.GetAlarmDetail(aCityid, aDeviceid: integer);
begin
  if not cxGridAlarmMaster.CanFocus then exit;

  DS_AlarmMaster.DataSet:= nil;
  try
    with CDS_AlarmMaster do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,2,' and cityid='+inttostr(aCityid)+' and deviceid='+inttostr(aDeviceid)]),0);
    end;
  finally

  end;
  DS_AlarmMaster.DataSet:= CDS_AlarmMaster;
  cxGridAlarmMasterDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmManual.GetCompanyMutil(aCityid: integer);
var
  lClientDataSet: TClientDataSet;
  lWdInteger: TWdInteger;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  ClearTStrings(CheckListBoxCompany.Items);
  try
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'dsp_General_data';
      Data:=gTempInterface.GetCDSData(VarArrayOf([101,7,aCityid,1]),0);
      first;
      while not eof do
      begin
        lWdInteger:=TWdInteger.Create(Fieldbyname('companyid').AsInteger);
        CheckListBoxCompany.Items.AddObject(Fieldbyname('companyname').AsString,lWdInteger);
        next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmManual.LoadAlarm(aCityid: Integer);
var
  lSqlStr: string;
begin
  DSAlarm.DataSet:= nil;
  try
    with CDSAlarm do
    begin
      Close;
      ProviderName:='dsp_General_data';
      lSqlStr:= 'select * from AlarmSet_view where sendtype=''手工派障'' and cityid=' +
                IntToStr(gPublicParam.CityID);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
    end;
  finally

  end;
  DSAlarm.DataSet:= CDSAlarm;
  cxGridAlarmDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmManual.AddAlarmField;
begin
  AddViewField(cxGridAlarmDBTableView1,'alarmcontentcode','告警内容编号');
  AddViewField(cxGridAlarmDBTableView1,'alarmcontentname','告警内容名称');
  AddViewField(cxGridAlarmDBTableView1,'alarmlevel','告警等级');
  AddViewField(cxGridAlarmDBTableView1,'alarmtype','告警类型');
  AddViewField(cxGridAlarmDBTableView1,'isautowrecker','是否自动消障');
  AddViewField(cxGridAlarmDBTableView1,'isautosubmit','是否自动提交');
end;

procedure TFormAlarmManual.ActionAddExecute(Sender: TObject);  //增加人工派障告警
var
  lAlarmCode,lAlarmLevel,lAlarmType, lIsAutoWrecker, lIsAutoSubmit: Integer;
  lClientDataSet:TClientDataSet;
  lSqlStr, lAlarmName: string;
  lVariant: variant;
  lsuccess: Boolean;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    if not Assigned(FormAlarmMgr) then
      FormAlarmMgr:= TFormAlarmMgr.Create(Self);
      
    if FormAlarmMgr.ShowModal=mrOK then
    begin
      with FormAlarmMgr do
      begin
        lAlarmName:= EdtAlarmName.text;
        lAlarmType   := GetDicCode(CbbAlarmType.Text,CbbAlarmType.Properties.Items);
        lAlarmLevel  := GetDicCode(CbbAlarmLevel.Text,CbbAlarmLevel.Properties.Items);
        lIsAutoWrecker:= CbbIsAutoWrecker.Properties.Items.IndexOf(CbbIsAutoWrecker.Text);
        lIsAutoSubmit:= CbbIsAutoCommit.Properties.Items.IndexOf(CbbIsAutoCommit.Text);
      end;
      lAlarmCode:=gTempInterface.GetFlowNum('ManualAlarmContenCode',1);
      lVariant:= VarArrayCreate([0,1],varVariant);
      lSqlstr:=' insert into alarm_content_rule (alarmcontentcode, alarmlevel, alarmcount, cityid, sendtype, validhour, limithour, removelimit, isautowrecker, iseffect, isautosubmit) values(' +
               IntToStr(lAlarmCode) + ',' +
               IntToStr(lAlarmLevel) +
               ',1,' +
               IntToStr(gPublicParam.cityid) +
               ',3,8,6,1,' +
               IntToStr(lIsAutoWrecker) +',' +
               '1,' +
               inttostr(lIsAutoSubmit) +')';
      lVariant[0]:= VarArrayOf([lSqlstr]);

      lSqlstr:=' insert into alarm_content_info(alarmcontentcode, alarmcontentname, alarmkind, alarmtype, cityid, iscomb) values(' +
               IntToStr(lAlarmCode) + ',''' +
               lAlarmName + ''',' +
               '2,' + //1表示网管自带告警 2表示用户自定义告警
               IntToStr(lAlarmType) + ',' +
               IntToStr(gPublicParam.cityid) + ',' +
               '0)';
      lVariant[1]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if lsuccess then
      begin
        Application.MessageBox('修改成功！','提示',MB_OK+64);
        LoadAlarm(gPublicParam.cityid);
      end
      else
        Application.MessageBox('修改失败！','提示',MB_OK+64);
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmManual.ActionModifyExecute(Sender: TObject); //修改人工派障告警
var
  lAlarmCode,lAlarmLevel,lAlarmType, lIsAutoWrecker, lIsAutoSubmit: Integer;
  lVariant: variant;
  lSqlstr, lAlarmName: string;
  lsuccess: boolean;
begin
  lAlarmCode:= CDSAlarm.fieldbyname('alarmcontentcode').AsInteger;
  if not CheckRecordSelected(cxGridAlarmDBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK+64);
    Exit;
  end;
  if not Assigned(FormAlarmMgr) then
    FormAlarmMgr:= TFormAlarmMgr.Create(Self);
  with FormAlarmMgr do
  begin
    EdtAlarmName.Text:= CDSAlarm.fieldbyname('alarmcontentname').AsString;
    CbbAlarmLevel.ItemIndex:= CbbAlarmLevel.Properties.Items.IndexOf(CDSAlarm.fieldbyname('alarmlevel').AsString);
    CbbAlarmType.ItemIndex:= CbbAlarmType.Properties.Items.IndexOf(CDSAlarm.fieldbyname('alarmtype').AsString);
    CbbIsAutoWrecker.ItemIndex:= CbbIsAutoWrecker.Properties.Items.IndexOf(CDSAlarm.fieldbyname('isautowrecker').AsString);
    CbbIsAutoCommit.ItemIndex:= CbbIsAutoCommit.Properties.Items.IndexOf(CDSAlarm.fieldbyname('isautosubmit').AsString);
  end;
  if FormAlarmMgr.ShowModal=mrOK then
  begin
    with FormAlarmMgr do
    begin
      lAlarmName:= EdtAlarmName.text;
      lAlarmType   := GetDicCode(CbbAlarmType.Text,CbbAlarmType.Properties.Items);
      lAlarmLevel  := GetDicCode(CbbAlarmLevel.Text,CbbAlarmLevel.Properties.Items);
      lIsAutoWrecker:= CbbIsAutoWrecker.Properties.Items.IndexOf(CbbIsAutoWrecker.Text);
      lIsAutoSubmit:= CbbIsAutoCommit.Properties.Items.IndexOf(CbbIsAutoCommit.Text);
    end;
    lVariant:= VarArrayCreate([0,1],varVariant);
    lSqlstr:=' update alarm_content_rule set ' +
             ' ALARMLEVEL=' + IntToStr(lAlarmLevel) +
             ',SENDTYPE=3' +
             ',ISAUTOWRECKER=' + IntToStr(lIsAutoWrecker) +
             ',ISAUTOSUBMIT=' + IntToStr(lIsAutoSubmit) +
             ' where ALARMCONTENTCODE=' + IntToStr(lAlarmCode) +
             ' and cityid=' + IntToStr(gPublicParam.cityid);
    lVariant[0]:= VarArrayOf([lSqlstr]);

    lSqlstr:=' update alarm_content_info set alarmcontentname=''' + lAlarmName + '''' +
             ',ALARMTYPE=' + IntToStr(lAlarmType) +
             ' where ALARMCONTENTCODE=' + IntToStr(lAlarmCode) +
             ' and cityid=' + IntToStr(gPublicParam.cityid);
    lVariant[1]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      Application.MessageBox('修改成功！','提示',MB_OK+64);
      LoadAlarm(gPublicParam.cityid);
    end
    else
      Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormAlarmManual.cxGridAlarmEnter(Sender: TObject);
begin
  FMenuAdd.Visible:= True;
  FMenuModify.Visible:=True;
end;

procedure TFormAlarmManual.cxGridAlarmExit(Sender: TObject);
begin
  FMenuAdd.Visible:= False;
  FMenuModify.Visible:=False;
end;

end.
