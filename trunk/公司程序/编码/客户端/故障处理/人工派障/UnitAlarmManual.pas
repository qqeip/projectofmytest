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
    //����
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
    FMenuAdd, FMenuModify: TMenuItem; //���Ӹ澯�����Ҽ��˵�
    //��ͼ����

    //��ͼ��λ
    function JudgeNode(aText1,aText2: string):boolean;
    function GetLocateFirstNode(aTreeView: TcxTreeView; aPathList: TStringList): TTreeNode;overload;
    function GetLocateFirstNode(aTopNode: TTreeNode; aKeyValue: string): TTreeNode;overload;
    function GetLocateNode(aTopNode: TTreeNode; aPathList: TStringList; aPathIndex: integer): TTreeNode;overload;
    //����·����λ�ڵ�   //�㽭ʡ�������У���������MTU001
    function GetLocateNode(aTreeView: TcxTreeView; aPathList: TStringList): TTreeNode;overload;
    procedure GetPathList(aDataSet: TClientDataSet; aPathList: TStringList);


    //���ݻ�վ���˸澯
    procedure GetAlarmDetail(aCityid, aDeviceid: integer);
    //���ݻ�վ�͸澯���ݹ���ά����λ
//    procedure GetCompanyMutil(aCityid: integer; aDeviceid, aContentcode: string);
    procedure LoadAlarm(aCityid: Integer);
    procedure AddAlarmField;
    procedure GetCompanyMutil(aCityid: integer);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionModifyExecute(Sender: TObject);
  public
    FIsGotoAlarmManual: Integer; //�Ƿ����ظ��澯ת�˹� 0 �� 1 ��
    FDeviceID, FCoDeviceID, FContentCode: Integer; //�����ظ��澯չ�ֵ�����
    FAlarmCaption: string;
    procedure ShowMasterAlarmOnline;     //�������ϸ澯
  end;

var
  FormAlarmManual: TFormAlarmManual;

implementation

uses UnitDllCommon, UnitAlarmMgr;

{$R *.dfm}

procedure TFormAlarmManual.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //�ص�����DLLMGRȥ�ͷŴ���
  gDllMsgCall(FormAlarmManual,1,'','');
end;

procedure TFormAlarmManual.FormCreate(Sender: TObject);
begin
  FDataSetLocate:= TClientDataSet.Create(nil);
  FPathList:= TStringList.Create;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAlarmMaster,false,true,true);
  FCxGridHelper.NewSetGridStyle(cxGridAlarm,false,true,true);


  //�Ӹ澯���ݵ��Ҽ��˵�
  FMenuAdd:= FCxGridHelper.AppendShowMenuItem('����',ActionAddExecute,True);
  FMenuModify:= FCxGridHelper.AppendShowMenuItem('�޸�',ActionModifyExecute,True);
  FMenuAdd.Visible:= False;
  FMenuModify.Visible:= False;

  //���ֶ�
  AddAlarmField;
  LoadFields(cxGridAlarmMasterDBTableView1,gPublicParam.cityid,gPublicParam.userid,21);
  //���ظ澯����
  LoadAlarm(gPublicParam.cityid);
  //����ά����λҶ��
  GetCompanyMutil(gPublicParam.cityid);
  //����
  gCFMS_TreeHelper:= TCFMS_TreeHelper.Create(cxTreeView1,gPublicParam.Cityid,gPublicParam.RuleCompanyidStr);
  gCFMS_TreeHelper.RefreshTree('',2,5,false);

  //�����豸��Ϣ
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
  //�˵��ͷ�
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
    Application.MessageBox('δ��ùؼ��ֶ�AlarmContentCode��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
    Application.MessageBox('��ѡ��ά����λ��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if cxGridAlarmDBTableView1.DataController.GetSelectedCount<1 then
  begin
    Application.MessageBox('��ѡ��澯���ݣ�','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;

  lNode:= cxTreeView1.Selected;
  if (lNode<>nil) and (lNode.Data<>nil)
     and (TNodeParamValue(lNode.Data).nodeType= Device) then
  begin
    lDeviceid:= TNodeParamValue(lNode.Data).Deviceid;
    for i:= cxGridAlarmDBTableView1.DataController.GetSelectedCount -1 downto 0 do   //�澯����
    begin
      lRecordIndex := cxGridAlarmDBTableView1.Controller.SelectedRows[I].RecordIndex;
      lContentcode := cxGridAlarmDBTableView1.DataController.GetValue(lRecordIndex,lAlarm_Index);
      for j:= CheckListBoxCompany.Items.Count - 1 downto 0 do//ά����λ
      begin
        if CheckListBoxCompany.Checked[j] then
        begin
          lCompanyid:= TWdInteger(CheckListBoxCompany.Items.Objects[j]).Value;
          iError := gTempInterface.MaunalSendFault(gPublicParam.cityid, lCompanyid,
                           lDeviceid, 0, lContentcode, self.Memo1.Lines.Text, gPublicParam.userid,
                           FIsGotoAlarmManual,FCoDeviceID,FContentCode);
          case iError of
            -1: begin
                  lMessageInfo:= '�洢�����ڲ�ִ���쳣����!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end;
            -2: begin
                  lMessageInfo:= '���ô洢����ʧ�ܣ������Ǵ洢����ʧЧ�����±���洢����!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end;
            -3: begin
                  lMessageInfo:= '�ӿ��쳣����!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end;
            else if iError < -3 then
                begin
                  lMessageInfo:= '�ӿ�δ�ɹ�ִ�еı���ԭ��!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end
            else if iError = 10 then
                begin
                  lMessageInfo:= '��ά����λ���ɷ��ø澯!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end
            else if iError = 11 then
                begin
                  lMessageInfo:= '�ø澯���ڴ��ɿ���!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end
            else if iError = 12 then
                begin
                  lMessageInfo:= '�û�վ�豸ȱʧ��û�иø澯����!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end
            else if iError = 13 then
                begin
                  lMessageInfo:= '�ֶ����ϱ�alarm_manuallist_view ���Ҳ����ø澯,���ܸø澯������!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end
            else if iError > 0 then
                begin
                  lMessageInfo:= 'Ϊ�洢����ִ�з��ص�δ�ɹ�ִ�еı���ԭ��!';
                  lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                  Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
                  exit;
                end;
          end;
        end;
      end;
    end;

    GetAlarmDetail(gPublicParam.cityid,lDeviceid);
    if  iError= 0 then
    begin
      lMessageInfo:= '�˹����ϳɹ�!';
      Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONINFORMATION);
    end;
  end
  else
    Application.MessageBox('��ѡ��һ����վ�豸��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
    //���ڽ����ϵ����ڵ�����ʾbts_name ����ĩ���ֶ���bts_name
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
       Application.MessageBox('�������ѯ����', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
  //����DOCKPANEL���ص�ʱ��ᴥ���¼�������Ҫ���ε�
  if FControlChanging then exit;
  if (Node=nil) or (Node.Data=nil) then exit;
  //����ýڵ��ǻ�վ
  if TNodeParamValue(Node.Data).nodeType= Device then
  begin
    lDeviceid:= TNodeParamValue(Node.Data).Deviceid;
    lBtsid:= TNodeParamValue(Node.Data).BTSID;
    GetAlarmDetail(gPublicParam.cityid, lDeviceid);                                                                                     //BTSID,�ǻ�վ��Ψһ��ʾ
    FrameDBVerticalGridEditor1.LoadDeviceInfo(gPublicParam.cityid,gPublicParam.userid,22,lBtsid);
    //ˢ��ά����λ
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
      lSqlStr:= 'select * from AlarmSet_view where sendtype=''�ֹ�����'' and cityid=' +
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
  AddViewField(cxGridAlarmDBTableView1,'alarmcontentcode','�澯���ݱ��');
  AddViewField(cxGridAlarmDBTableView1,'alarmcontentname','�澯��������');
  AddViewField(cxGridAlarmDBTableView1,'alarmlevel','�澯�ȼ�');
  AddViewField(cxGridAlarmDBTableView1,'alarmtype','�澯����');
  AddViewField(cxGridAlarmDBTableView1,'isautowrecker','�Ƿ��Զ�����');
  AddViewField(cxGridAlarmDBTableView1,'isautosubmit','�Ƿ��Զ��ύ');
end;

procedure TFormAlarmManual.ActionAddExecute(Sender: TObject);  //�����˹����ϸ澯
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
               '2,' + //1��ʾ�����Դ��澯 2��ʾ�û��Զ���澯
               IntToStr(lAlarmType) + ',' +
               IntToStr(gPublicParam.cityid) + ',' +
               '0)';
      lVariant[1]:= VarArrayOf([lSqlstr]);
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if lsuccess then
      begin
        Application.MessageBox('�޸ĳɹ���','��ʾ',MB_OK+64);
        LoadAlarm(gPublicParam.cityid);
      end
      else
        Application.MessageBox('�޸�ʧ�ܣ�','��ʾ',MB_OK+64);
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmManual.ActionModifyExecute(Sender: TObject); //�޸��˹����ϸ澯
var
  lAlarmCode,lAlarmLevel,lAlarmType, lIsAutoWrecker, lIsAutoSubmit: Integer;
  lVariant: variant;
  lSqlstr, lAlarmName: string;
  lsuccess: boolean;
begin
  lAlarmCode:= CDSAlarm.fieldbyname('alarmcontentcode').AsInteger;
  if not CheckRecordSelected(cxGridAlarmDBTableView1) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK+64);
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
      Application.MessageBox('�޸ĳɹ���','��ʾ',MB_OK+64);
      LoadAlarm(gPublicParam.cityid);
    end
    else
      Application.MessageBox('�޸�ʧ�ܣ�','��ʾ',MB_OK+64);
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
