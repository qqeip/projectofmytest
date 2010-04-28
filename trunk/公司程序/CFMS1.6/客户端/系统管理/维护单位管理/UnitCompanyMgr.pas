{维护单位管理：
 用到的表有：
 1、维护单位信息表（FMS_COMPANY_INFO）
 2、设备集信息表（FMS_DEVICEGATHER_INFO）
 3、告警内容信息表（ALARM_CONTENT_INFO）
 4、维护单位设备集关系表（FMS_COMPANY_DEVGATHER_RELAT）
 5、维护单位告警类型关系表（FMS_COMPANY_ALARM_RELAT）
 实现的功能：
 维护单位信息新增、修改、删除。
 维护单位的树机构叶子节点才能与设备集和告警内容进行对应设置。
 非叶子节点只能查看其所包含的叶子节点所包含的所有设备集和告警内容的交集。

 }

unit UnitCompanyMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, ComCtrls, ExtCtrls, cxSplitter, StringUtils,
  cxTreeView, cxControls, cxContainer, cxEdit, cxGroupBox, DBClient, Menus,
  StdCtrls, cxButtons, cxCheckListBox, cxLabel, cxTextEdit, CheckLst, jpeg,
  ImgList, Buttons, cxListView, IniFiles;


type
  TCompanyObject= class
    ID: Integer ;
    Top_ID: Integer;
    Name: string;
    CITYID: Integer;
    Address:string;
    Phone:string;
    Fix:string;
    LinkMan:string;
end;

type
  TMasterAlarm = record
    Count: integer;    //存在在线告警的数量
    IsExsitAlarm: boolean; //是否存在在线告警
    AlarmCodeStr: string;  //告警编号字符串
//    AlarmList: array of Integer; //告警内容编号
  end;
  TFormCompanyMgr = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxTreeViewCompany: TcxTreeView;
    cxSplitter1: TcxSplitter;
    Panel1: TPanel;
    cxGroupBox5: TcxGroupBox;
    cxTextEditName: TcxTextEdit;
    cxTextEditAddr: TcxTextEdit;
    cxTextEditPhone: TcxTextEdit;
    cxTextEditFax: TcxTextEdit;
    cxTextEditLinkMan: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxGroupBox6: TcxGroupBox;
    cxButtonModify: TcxButton;
    cxButtonClose: TcxButton;
    PopupMenu1: TPopupMenu;
    N_Add: TMenuItem;
    N_Del: TMenuItem;
    PopupMenu2: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    ImageTree: TImageList;
    PopupMenu3: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    PopupMenu4: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel3: TPanel;
    cxGroupBox3: TcxGroupBox;
    CheckListBoxDev: TCheckListBox;
    cxGroupBox4: TcxGroupBox;
    CheckListBoxAlarmInfo: TcxListView;
    Panel4: TPanel;
    cxGroupBox7: TcxGroupBox;
    CheckListBoxAlarm: TCheckListBox;
    Panel5: TPanel;
    SpeedButtonSearch: TSpeedButton;
    EditAlarmFilter: TEdit;
    Panel6: TPanel;
    procedure ClickCheck(aIndex: integer; aChecked, aLastFlag: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cxTreeViewCompanyMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure N_AddClick(Sender: TObject);
    procedure N_DelClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure cxButtonCloseClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure SpeedButtonSearchClick(Sender: TObject);
    procedure EditAlarmFilterKeyPress(Sender: TObject; var Key: Char);
    procedure CheckListBoxAlarmClickCheck(Sender: TObject);

  private
    FirstNodeID : integer;
    gNodeStatus : Integer;
    gSelectedAlarmContentList: THashedStringList;
    procedure AddTreeViewNode(aTreeView: TcxTreeView; aID, aTOP_ID, aCITYID: Integer; aNAME,aAddr,aPhone,aFix,aLinkMan: string);
    procedure CreateCompanyTree(aTreeView: TcxTreeView);
    //初始化CheckListBox
    procedure InitAlarmSet;
    procedure InitDeveceSet;
    //获取两个CheckListBox的选中记录数
    function GetCheckListBoxCount: Integer;
    //判断是否有关联的设备集或告警
    function IfHasContent(aCompanyid:integer):boolean;
    //设置CheckListBox的是否选中的状态
    procedure SetCheckedStatus(aBox: TCheckListBox; aBool: Boolean);    
    procedure SelectBox(aBox: TCheckListBox; aKeyid: integer);
    //加载叶子节点，并得到是否选中的状态
    procedure LoadAlarmSet(aCompanyid: Integer; aFilterValue: string=''; aCheckFlag: boolean= false);
    procedure LoadDeveceSet(aCompanyid: Integer);
    //加载非叶子节点
    procedure LoadNotLeavesNode(aCompanyid: Integer);
    procedure InhertedFromParent(aParentid, aChildid: integer);
    function GetCheckBoxCount(aListBox: TChecklistbox): Integer;
    function CheckGatherHasDev(aCityID, aDevGather: Integer): Boolean;
    function IsExistsAlarm(aCompanyID, aAlarmCode: string): boolean;
    function IsExsitMasterAlarm(aCityid, aCompany: Integer; aListView: TcxListView): TMasterAlarm;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCompanyMgr: TFormCompanyMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}


{ TFormCompanyMgr }

procedure TFormCompanyMgr.FormCreate(Sender: TObject);
begin
  gNodeStatus :=-1;
  gSelectedAlarmContentList:= THashedStringList.Create;
end;

procedure TFormCompanyMgr.FormShow(Sender: TObject);
begin
  CreateCompanyTree(cxTreeViewCompany);
  InitDeveceSet;
  InitAlarmSet;
end;

procedure TFormCompanyMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gSelectedAlarmContentList.Free;
  gDllMsgCall(FormCompanyMgr,1,'','');
end;

procedure TFormCompanyMgr.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormCompanyMgr.CreateCompanyTree(aTreeView: TcxTreeView);
var
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,10]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        AddTreeViewNode(cxTreeViewCompany,
                        FieldByName('COMPANYID').AsInteger,
                        FieldByName('PARENTID').AsInteger,
                        FieldByName('CITYID').AsInteger,
                        FieldByName('COMPANYNAME').AsString,
                        FieldByName('Address').Asstring,
                        FieldByName('Phone').Asstring,
                        FieldByName('Fix').Asstring,
                        FieldByName('LinkMan').Asstring,
                        );
        Next;
      end;
    end;
    aTreeView.FullExpand;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanyMgr.AddTreeViewNode(aTreeView: TcxTreeView; aID,aTOP_ID,aCITYID:Integer;aNAME,aAddr,aPhone,aFix,aLinkMan:string);
var
  lObject: TCompanyObject;
  lNewNode,lParentNode : TTreeNode;
  function GetParentNode(aParent: Integer):TTreeNode;
  var
    lTempNode: TTreeNode;
  begin
    result:=nil;
//    if alevel=0 then Exit;
    with aTreeView.Items do
    begin
      lTempNode:= GetFirstNode;
      if lTempNode=nil then exit;
      while lTempNode<>nil do
      begin
        if TCompanyObject(lTempNode.Data).ID=aParent then
        begin
          result:=lTempNode;
          Break;
        end;
        lTempNode:=lTempNode.getNext;
      end;
    end;
  end;
begin
  lObject:= TCompanyObject.Create;
  lObject.ID:= aID;
  lObject.Top_ID := aTOP_ID;
  lObject.CITYID := aCITYID;
  lObject.Name   := aNAME;
  lObject.Address:= aAddr;
  lObject.Phone  := aPhone;
  lObject.Fix    := aFix;
  lObject.LinkMan:= aLinkMan;
  lParentNode:= GetParentNode(aTOP_ID);
  lNewNode:= aTreeView.Items.AddChildObject(lParentNode,lObject.Name,lObject);
end;

procedure TFormCompanyMgr.cxTreeViewCompanyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode: TTreeNode;
  I: integer;
begin
  if (Button<>mbleft) or (not(htonitem in cxTreeViewCompany.GetHitTestInfoAt(X,Y))) then
    Exit;
  lNode:= cxTreeViewCompany.Selected;
  if (lNode=nil) or (lNode.Data=nil) then Exit;

  if (TCompanyObject(lNode.Data).ID=FirstNodeID) then
    if (lNode.HasChildren) then
      gNodeStatus:=1
    else
      gNodeStatus:=0
  else if not lNode.HasChildren then
    gNodeStatus:=3
  else
    gNodeStatus:=2;

  if (gNodeStatus=3) or (gNodeStatus=0) then
  begin
    if gNodeStatus=3 then
      N_Del.Enabled:=True;
  end;
  try
    Screen.Cursor:=crHourGlass;
    cxTextEditName.Text:= TCompanyObject(lNode.Data).Name;
    cxTextEditAddr.Text:= TCompanyObject(lNode.Data).Address;
    cxTextEditPhone.Text:= TCompanyObject(lNode.Data).Phone;
    cxTextEditFax.Text := TCompanyObject(lNode.Data).Phone;
    cxTextEditLinkMan.Text:= TCompanyObject(lNode.Data).LinkMan;

    if (gNodeStatus=3) or (gNodeStatus=0) then
    begin
      CheckListBoxDev.Enabled:=False;
      CheckListBoxAlarm.Enabled:= False;
      LoadDeveceSet(TCompanyObject(lNode.Data).ID);
      LoadAlarmSet(TCompanyObject(lNode.Data).ID);

      CheckListBoxDev.Enabled:=True;
      CheckListBoxAlarm.Enabled:=True;
    end
    else
      LoadNotLeavesNode(TCompanyObject(lNode.Data).ID);    //加载非叶子节点
  finally
    screen.Cursor:= crDefault;
  end;
end;

procedure TFormCompanyMgr.LoadDeveceSet(aCompanyid: Integer);
var
  lClientDataSet: TClientDataSet;
  lDevAlarmObject: TWdInteger;
begin
  ClearTStrings(CheckListBoxDev.Items);
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,14,gPublicParam.cityid,aCompanyid]),0);
      if IsEmpty then Exit;
      First;
      while not Eof do
      begin
        lDevAlarmObject:= TWdInteger.create(FieldByName('DEVICEGATHERID').AsInteger);
        CheckListBoxDev.Items.AddObject(FieldByName('devicegathername').AsString,lDevAlarmObject);
        if FieldByName('checked').AsInteger=1 then
           CheckListBoxDev.Checked[CheckListBoxDev.Items.IndexOf(FieldByName('devicegathername').AsString)]:= True;
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanyMgr.LoadAlarmSet(aCompanyid: Integer; aFilterValue: string; aCheckFlag: boolean);
var
  lClientDataSet: TClientDataSet;
  i: Integer;
  lAlarmObject  : TWdInteger;
  lAlarmName : string;
  lFilterStr: string;
begin
  try
    ClearTStrings(CheckListBoxAlarm.Items);
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      if trim(aFilterValue)='' then
        lFilterStr:=''
      else
        lFilterStr:= ' and (upper(a.alarmcontentcode) like ''%'+uppercase(aFilterValue)+'%'' or upper(a.alarmcontentname) like ''%'+uppercase(aFilterValue)+'%'')';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,15,aCompanyid,inttostr(gPublicParam.cityid)+lFilterStr]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        lAlarmObject:=TWdInteger.Create(FieldByName('alarmcontentcode').asInteger);
        lAlarmName := FieldByName('alarmcontentname').AsString + '[' + IntToStr(FieldByName('alarmcontentcode').asInteger) + ']' ;
        CheckListBoxAlarm.Items.AddObject(lAlarmName,lAlarmObject);
        if FieldByName('checked').AsInteger=1 then
           CheckListBoxAlarm.Checked[CheckListBoxAlarm.Items.IndexOf(lAlarmName)]:= True;
//           CheckListBoxAlarm.Checked[CheckListBoxAlarm.Items.IndexOfObject(lAlarmObject)]:= True;
        Next;
      end;
    end;

    if not aCheckFlag then//初始化
    begin
      //根据告警内容选择值，完整列出到右边
      CheckListBoxAlarmInfo.Items.Clear;
      gSelectedAlarmContentList.Clear;
      for I:= 0 to CheckListBoxAlarm.Items.Count -1 do
      begin
        ClickCheck(i,CheckListBoxAlarm.Checked[i],i=CheckListBoxAlarm.Items.Count -1);
      end;
    end
    else //根据右边条目，勾选左边内容
    begin
      for i:= 0 to CheckListBoxAlarm.Items.Count - 1 do
      begin
        if gSelectedAlarmContentList.IndexOf(TWdInteger(CheckListBoxAlarm.Items.Objects[i]).ToString)>-1 then
          if not CheckListBoxAlarm.Checked[i] then
            CheckListBoxAlarm.Checked[i]:= true;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanyMgr.LoadNotLeavesNode(aCompanyid: Integer);
var
  lClientDataSet: TClientDataSet;
  lCaption: string;
  I: integer;
  lAlarmObject  : TWdInteger;
begin
  ClearTStrings(CheckListBoxDev .Items);
  ClearTStrings(CheckListBoxAlarm .Items);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,16,gPublicParam.cityid,aCompanyid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        lCaption:=FieldByName('devicegathername').AsString + '['+FieldByName('alarmcontentname').AsString+']';
        CheckListBoxDev.Items.Add(lCaption);
        lAlarmObject:=TWdInteger.Create(FieldByName('alarmcontentcode').asInteger);
        lCaption:= FieldByName('alarmcontentname').AsString + '[' + IntToStr(FieldByName('alarmcontentcode').asInteger) + ']';
        if not CheckListBoxAlarm.Items.IndexOf(lCaption)>-1 then
          CheckListBoxAlarm.Items.AddObject(lCaption,lAlarmObject);
        Next;
      end;
    end;
  finally
    SetCheckedStatus(CheckListBoxDev,True);
    SetCheckedStatus(CheckListBoxAlarm,True);
    lClientDataSet.Free;
  end;

  //根据告警内容选择值，完整列出到右边
  CheckListBoxAlarmInfo.Items.Clear;
  gSelectedAlarmContentList.Clear;
  for I:= 0 to CheckListBoxAlarm.Items.Count -1 do
  begin
    ClickCheck(i,CheckListBoxAlarm.Checked[i],i=CheckListBoxAlarm.Items.Count -1);
  end;
end;

procedure TFormCompanyMgr.SelectBox(aBox: TCheckListBox;
  aKeyid: integer);
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
        break;
      end;
    end;
  end;
end;

procedure TFormCompanyMgr.InitDeveceSet;
var
  lClientDataSet: TClientDataSet;
  lDevAlarmObject: TWdInteger;
begin
  ClearTStrings(CheckListBoxDev.Items);
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([2,305,gPublicParam.cityid]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        lDevAlarmObject:= TWdInteger.create(FieldByName('DEVICEGATHERID').AsInteger);
        CheckListBoxDev.Items.AddObject(FieldByName('devicegathername').AsString,lDevAlarmObject);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanyMgr.InitAlarmSet;
var
  lClientDataSet: TClientDataSet;
  lDevAlarmObject: TWdInteger;
  lAlarmName: string;
begin
  ClearTStrings(CheckListBoxAlarm .Items);
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
        lDevAlarmObject:= TWdInteger.create(FieldByName('ALARMCONTENTCODE').AsInteger);
        lAlarmName := FieldByName('ALARMCONTENTNAME').AsString + '[' + IntToStr(FieldByName('ALARMCONTENTCODE').AsInteger) + ']';
        CheckListBoxAlarm.Items.AddObject(lAlarmName,lDevAlarmObject);
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanyMgr.SetCheckedStatus(aBox: TCheckListBox; aBool: Boolean);
var i: Integer;
begin
  for I:=0 to abox.Count-1 do
    aBox.Checked[i]:= aBool;
end;

procedure TFormCompanyMgr.cxButtonModifyClick(Sender: TObject);
var
  i, j, k, lCompanyID, iError, lCount: Integer;
  lNode: TTreeNode;
  lVariant: variant;
  lSqlstr: string;
  lMasterAlarm: TMasterAlarm;
  lsuccess: boolean;
begin
  try
    Screen.Cursor := crHourGlass;
    lNode := cxTreeViewCompany.Selected;
    if (lNode=nil) or (lNode.Data=nil) then
    begin
      Application.MessageBox('获取树节点信息失败,请选择一个节点！','提示',MB_OK + 64);
      exit;
    end;
    if Trim(cxTextEditName.Text) = '' then
    begin
      application.MessageBox('单位名称不能为空！','提示',MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if GetCheckBoxCount(CheckListBoxDev)=0 then
    begin
      application.MessageBox('请选择设备集！','提示',MB_OK + MB_ICONINFORMATION);
      Exit;
    end;
    if CheckListBoxAlarmInfo.Items.Count=0 then
    begin
      application.MessageBox('请选择告警内容！','提示',MB_OK + MB_ICONINFORMATION);
      Exit;
    end;

    lCompanyID:= TCompanyObject(lNode.Data).ID;

    if (self.gNodeStatus=2) then
    begin
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr := 'update fms_company_info set' +
                 ' COMPANYNAME=''' + cxTextEditName.Text + ''',' +
                 ' ADDRESS=''' + cxTextEditAddr.Text + ''',' +
                 ' PHONE=''' + cxTextEditPhone.Text + ''',' +
                 ' FIX=''' + cxTextEditFax.Text + ''',' +
                 ' LINKMAN=''' + cxTextEditLinkMan.Text + '''' +
                 ' where COMPANYID=' + IntToStr(lCompanyID);
      lVariant[0]:= VarArrayOf([lsqlstr]);
    end;

    if (self.gNodeStatus=3) or (gNodeStatus=0) then
    begin
      lMasterAlarm:= IsExsitMasterAlarm(gPublicParam.cityid, lCompanyID, CheckListBoxAlarmInfo);
      if not lMasterAlarm.IsExsitAlarm then
        lVariant:= VarArrayCreate([0,GetCheckListBoxCount+2],varVariant)
      else
      begin
        if MessageDlg('将删除该单位下相关告警!'+#13+'是否继续？',mtInformation,[mbYes,mbNo],0)=mrNo then
          Exit
        else   //删除在线告警表中的告警
          lVariant:= VarArrayCreate([0,GetCheckListBoxCount+2],varVariant);
//          lVariant:= VarArrayCreate([0,GetCheckListBoxCount+lMasterAlarm.Count+2],varVariant);
      end;

      lSqlstr := 'update fms_company_info set' +
                 ' COMPANYNAME=''' + cxTextEditName.Text + ''',' +
                 ' ADDRESS=''' + cxTextEditAddr.Text + ''',' +
                 ' PHONE=''' + cxTextEditPhone.Text + ''',' +
                 ' FIX=''' + cxTextEditFax.Text + ''',' +
                 ' LINKMAN=''' + cxTextEditLinkMan.Text + '''' +
                 ' where COMPANYID=' + IntToStr(lCompanyID);
      lVariant[0]:= VarArrayOf([lsqlstr]);
      { delete FMS_COMPANY_DEVGATHER_RELAT }
      lSqlstr := 'delete from FMS_COMPANY_DEVGATHER_RELAT where cityid=' +
                 IntToStr(gPublicParam.cityid) +
                 ' and companyid=' + IntToStr(lCompanyID) ;
      lVariant[1]:= VarArrayOf([lsqlstr]);
      lCount:=0;
      { add FMS_COMPANY_DEVGATHER_RELAT }
      for i:=0 to CheckListBoxDev.count-1 do
      begin
        if CheckListBoxDev.Checked[i] then
        begin
          lSqlstr := 'insert into FMS_COMPANY_DEVGATHER_RELAT(CITYID,COMPANYID,DEVICEGATHERID)values(' +
                     IntToStr(gPublicParam.cityid) + ',' +
                     IntToStr(lCompanyID) + ',' +
                     IntToStr(TWdInteger(CheckListBoxDev.Items.Objects[i]).Value) + ')';
          lVariant[lCount+2]:= VarArrayOf([lsqlstr]);
          inc(lCount);
        end;
      end;

      { delete FMS_COMPANY_ALARM_RELAT }
      lSqlstr := 'delete from FMS_COMPANY_ALARM_RELAT where cityid=' +
                 IntToStr(gPublicParam.cityid) +
                 ' and companyid=' + IntToStr(lCompanyID) ;
      lVariant[lCount+2]:= VarArrayOf([lsqlstr]);

      { add FMS_COMPANY_ALARM_RELAT }
      for j:=0 to CheckListBoxAlarmInfo.Items.Count-1 do
      begin
        lSqlstr := 'insert into FMS_COMPANY_ALARM_RELAT(CITYID,COMPANYID,ALARMCONTENTCODE)values(' +
                   IntToStr(gPublicParam.cityid) + ',' +
                   IntToStr(lCompanyID) + ',' +
                   IntToStr(TWdInteger(CheckListBoxAlarmInfo.Items[j].Data).Value) + ')';
        lVariant[lCount+3]:= VarArrayOf([lsqlstr]);
        inc(lCount);
      end;
//      if lMasterAlarm.IsExsitAlarm then  //删除主障表告警
//        for k:=0 to lMasterAlarm.Count-1 do
//        begin
//          lSqlstr := 'delete from fault_master_online where cityid=' +
//                       IntToStr(gPublicParam.cityid) +
//                     ' and ALARMCONTENTCODE=' +
//                       IntToStr(lMasterAlarm.AlarmList[k]);
//          lVariant[lCount+3]:= VarArrayOf([lsqlstr]);
//        end;
    end;
    if lMasterAlarm.IsExsitAlarm then
    begin
      //iError:= gTempInterface.CompanyMgr(gPublicParam.cityid,lCompanyID,lMasterAlarm.AlarmCodeStr,gPublicParam.userid,lVariant);
      case iError of
      0:
        begin
          Application.MessageBox('修改成功','提示',MB_OK+64);
          lNode.Text:= cxTextEditName.Text;
          TCompanyObject(lNode.Data).Name:= cxTextEditName.Text;
          TCompanyObject(lNode.Data).Address:= cxTextEditAddr.Text;
          TCompanyObject(lNode.Data).Phone:= cxTextEditPhone.Text;
          TCompanyObject(lNode.Data).Fix:= cxTextEditFax.Text;
          TCompanyObject(lNode.Data).LinkMan:= cxTextEditLinkMan.Text;
        end;
      -1:
        Application.MessageBox('删除告警过程出错','提示',MB_OK+64);
      10: // 添加告警操作日志失败!
        Application.MessageBox('添加告警操作日志失败!','提示',MB_OK+64);
      11:
        Application.MessageBox('告警手动删除失败!','提示',MB_OK+64);
      end;
    end
    else
    begin
      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if lsuccess then
      begin
        Application.MessageBox('修改成功','提示',MB_OK+64);
        lNode.Text:= cxTextEditName.Text;
        TCompanyObject(lNode.Data).Name:= cxTextEditName.Text;
        TCompanyObject(lNode.Data).Address:= cxTextEditAddr.Text;
        TCompanyObject(lNode.Data).Phone:= cxTextEditPhone.Text;
        TCompanyObject(lNode.Data).Fix:= cxTextEditFax.Text;
        TCompanyObject(lNode.Data).LinkMan:= cxTextEditLinkMan.Text;
      end
      else
        Application.MessageBox('修改失败','提示',MB_OK+64)
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TFormCompanyMgr.GetCheckListBoxCount: Integer;
var i, lCount: Integer;
begin
  lCount:= 0;
  if (CheckListBoxAlarminfo.Items.Count=0) and (CheckListBoxDev.Items.Count=0) then
  begin
    Result:=-1;
    Exit;
  end;
  for i:=0 to CheckListBoxDev.count-1 do
  begin
    if CheckListBoxDev.Checked[i] then
      inc(lCount) ;
  end;
  for i:=0 to CheckListBoxAlarminfo.items.count-1 do
  begin
    inc(lCount) ;
  end;
  Result:= lCount;
end;

function TFormCompanyMgr.GetCheckBoxCount(aListBox:TChecklistbox): Integer;
var i: Integer;
begin
  Result:=0;
  for i:=0 to aListBox.Items.Count-1 do
    if aListBox.Checked[i] then
      inc(Result);
end;

function TFormCompanyMgr.IsExsitMasterAlarm(aCityid, aCompany: Integer; aListView: TcxListView): TMasterAlarm;
var
  i: Integer;
  lStr, lSqlStr: string;
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  with aListView do
  begin
    for i:= 0 to Items.Count-1 do
    begin
      lStr:= lStr + IntToStr(TWdInteger(Items[i].Data).Value) + ',';
    end;
    lStr:= Copy(lStr,0,Length(lStr)-1);
  end;

  with lClientDataSet do
  begin
    try
      Close;
      ProviderName:= 'DataSetProvider';
      lSqlStr:= 'select cityid,companyid,alarmcontentcode from fault_detail_online ' +
                ' where (cityid,companyid,alarmcontentcode) in ' +
                '(select cityid,companyid,alarmcontentcode from FMS_COMPANY_ALARM_RELAT where cityid=' +
                 IntToStr(aCityid) +
                ' and companyid=' +
                 IntToStr(aCompany) +
                ' and alarmcontentcode not in (' + lStr + '))'+
                'group by cityid,companyid,alarmcontentcode';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if not IsEmpty then
      begin
        Result.IsExsitAlarm:= True;
        Result.Count:= RecordCount;
//        SetLength(Result.AlarmList,Result.Count);
        for i:=0 to RecordCount-1 do
        begin
//          Result.AlarmList[i]:= FieldByName('alarmcontentcode').AsInteger;
          Result.AlarmCodeStr:= Result.AlarmCodeStr + IntToStr(FieldByName('alarmcontentcode').AsInteger) + ',';
        end;
        Result.AlarmCodeStr:= Copy(Result.AlarmCodeStr,0,Length(Result.AlarmCodeStr)-1);
      end
      else
      begin
        Result.Count:= 0;
        Result.IsExsitAlarm:= False;
        Result.AlarmCodeStr:= '';
      end;
    finally
      lClientDataSet.Free;
    end;
  end;
end;

procedure TFormCompanyMgr.N_AddClick(Sender: TObject);
var
  lNode: TTreeNode;
  lInputName : String;
  lCompanyID: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
  lNewNode: TCompanyObject;
begin
  lNode:= cxTreeViewCompany.Selected;
  if (lNode=nil) or (lNode.Data=nil) then
  begin
    application.MessageBox('获取树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  while lInputName='' do
  begin
    if InputQuery('输入维护单位名称','',lInputName) then
    begin
      if lInputName='' then
        application.MessageBox('维护单位名称不能为空！','提示',MB_OK + MB_ICONINFORMATION);
    end
    else
      break;
  end;
  if IsExists('fms_company_info','companyname',lInputName) then
  begin
    MessageBox(0,'该维护单位名称已经存在！','提示',MB_OK + 64);
    Exit;
  end;
  if lInputName<>'' then
  begin
    lCompanyID:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr:='insert into fms_company_info (companyid, cityid, parentid, companyname) values (' +
             IntToStr(lCompanyID)+',' +
             IntToStr(gPublicParam.cityid) + ',' +
             IntToStr(TCompanyObject(lNode.data).ID) + ',''' +
             lInputName+''')';
    lVariant[0]:= VarArrayOf([lsqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    //如果是唯一节点，或者是叶子节点，则从父亲节点继承
    if (gNodeStatus=3) or (gNodeStatus=0) then
      InhertedFromParent(TCompanyObject(lNode.data).ID,lCompanyid);
  end;
  if lsuccess then
  begin
    MessageBox(0,'新增成功','提示',MB_OK+64);
    lNewNode:= TCompanyObject.Create;
    lNewNode.ID:= lCompanyID;
    lNewNode.Top_ID:= TCompanyObject(lNode.data).ID;
    lNewNode.CITYID:= gPublicParam.cityid;
    lNewNode.Name:= lInputName;

    cxTreeViewCompany.Items.AddChildObject(lNode,lInputName,lNewNode);
  end
  else
    MessageBox(0,'新增失败','提示',MB_OK+64);
end;

procedure TFormCompanyMgr.N_DelClick(Sender: TObject);
var
  lNode: TTreeNode;
  lCompanyID: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lNode := self.cxTreeViewCompany.Selected;
  if (lNode=nil) or (lNode.Data=nil) then
  begin
    application.MessageBox('获取树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if IfHasContent(TCompanyObject(lNode.Data).ID) then
  begin
    application.MessageBox(pchar('单位['+TCompanyObject(lNode.Data).Name+']拥有告警信息,无法删除！'),'提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  if Application.MessageBox(PChar('确定删除单位['+TCompanyObject(lNode.Data).Name+']?'),'信息',MB_OKCANCEL+MB_ICONINFORMATION)=IDOK then
  begin
    lCompanyID:= TCompanyObject(lNode.Data).ID;
    lVariant:= VarArrayCreate([0,2],varVariant);
    lSqlstr := 'delete from FMS_COMPANY_INFO where cityid=' +
               IntToStr(gPublicParam.cityid) +
               ' and companyid=' + IntToStr(lCompanyID) ;
    lVariant[0]:= VarArrayOf([lsqlstr]);

    { delete FMS_COMPANY_DEVGATHER_RELAT }
    lSqlstr := 'delete from FMS_COMPANY_DEVGATHER_RELAT where cityid=' +
               IntToStr(gPublicParam.cityid) +
               ' and companyid=' + IntToStr(lCompanyID) ;
    lVariant[1]:= VarArrayOf([lsqlstr]);

    { delete FMS_COMPANY_ALARM_RELAT }
    lSqlstr := 'delete from FMS_COMPANY_ALARM_RELAT where cityid=' +
               IntToStr(gPublicParam.cityid) +
               ' and companyid=' + IntToStr(lCompanyID) ;
    lVariant[2]:= VarArrayOf([lsqlstr]);

    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  end;

  if lsuccess then
  begin
    MessageBox(0,'删除成功','提示',MB_OK+64);
    lNode.Delete;
  end
  else
    MessageBox(0,'删除失败','提示',MB_OK+64);
end;

//单位拥有告警信息
function TFormCompanyMgr.IfHasContent(aCompanyid: integer): boolean;
var
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,13,gPublicParam.cityid,aCompanyid]),0);
      if IsEmpty then
        Result:= False
      else
        Result:= True;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanyMgr.N1Click(Sender: TObject);
var
  lInputName : String;
  lDevID : Integer;
  lDevAlarmObject : TWdInteger;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if InputQuery('新增设备集','输入设备集名称',lInputName) then
  begin
    if lInputName='' then
    begin
      MessageBox(0,'设备集名称不能为空！','提示',MB_OK + 64);
      Exit;
    end;
  end;
  if IsExists('FMS_DEVICEGATHER_INFO','DEVICEGATHERNAME',lInputName) then
  begin
    MessageBox(0,'设备集已经存在！','提示',MB_OK + 64);
    Exit;
  end;
  lDevID:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr := 'insert into FMS_DEVICEGATHER_INFO(CITYID,DEVICEGATHERID,DEVICEGATHERNAME,OPERATER,CREATETIME) values(' +
             IntToStr(gPublicParam.cityid) +  ',' +
             IntToStr(lDevID) + ',''' +
             lInputName + ''',' +
             IntToStr(gPublicParam.userid) + ',' +
             'to_date('''+FormatDateTime('yyyy-mm-dd',now)+''',''yyyy-mm-dd''))';
  lVariant[0]:= VarArrayOf([lsqlstr]);

  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    MessageBox(0,'新增成功','提示',MB_OK+64);
    lDevAlarmObject:= TWdInteger.create(lDevID);
    CheckListBoxDev.Items.AddObject(lInputName,lDevAlarmObject);
  end
  else
    MessageBox(0,'新增失败','提示',MB_OK+64);
end;

procedure TFormCompanyMgr.N2Click(Sender: TObject);
var
  lDevID : Integer;
  lInputName : String;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if CheckListBoxDev.ItemIndex= -1 then
  begin
    application.MessageBox('请选择一个设备集！','提示',MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  while lInputName='' do
  begin
    lInputName := CheckListBoxDev.Items[CheckListBoxDev.ItemIndex];
    if InputQuery('修改设备集','输入设备集名称',lInputName) then
    begin
      if lInputName='' then
        application.MessageBox('设备集名称不能为空！','提示',MB_OK + MB_ICONINFORMATION);
    end
    else
      break;
  end;
  if lInputName<>'' then
  begin
    lDevID:= TWdInteger(CheckListBoxDev.Items.Objects[CheckListBoxDev.ItemIndex]).Value;
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr := ' update FMS_DEVICEGATHER_INFO set DEVICEGATHERNAME=''' +lInputName + ''',' +
               ' OPERATER=' + IntToStr(gPublicParam.userid) + ',' +
               ' CREATETIME=' + 'to_date('''+FormatDateTime('yyyy-mm-dd',now)+''',''yyyy-mm-dd'')' +
               ' where CITYID=' + IntToStr(gPublicParam.cityid) +
               ' and DEVICEGATHERID=' + IntToStr(lDevID);
    lVariant[0]:= VarArrayOf([lsqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  end;

  if lsuccess then
  begin
    MessageBox(0,'修改成功','提示',MB_OK+64);
    CheckListBoxDev.Items[CheckListBoxDev.ItemIndex] := lInputName;
  end
  else
    MessageBox(0,'修改失败','提示',MB_OK+64);
end;

procedure TFormCompanyMgr.N3Click(Sender: TObject);
var
  lGatherid: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if CheckListBoxDev.ItemIndex= -1 then
  begin
    application.MessageBox('请选择一个设备集！','提示',MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  lGatherid := TWdInteger(CheckListBoxDev.Items.Objects[CheckListBoxDev.ItemIndex]).Value;
  if CheckGatherHasDev(gPublicParam.cityid,lGatherid) then
  begin
    application.MessageBox('该设备集存在已规划设备，无法删除！','提示',MB_OK + MB_ICONINFORMATION);
    Exit;
  end;

  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr := ' delete from FMS_DEVICEGATHER_INFO where' +
             ' CITYID=' + IntToStr(gPublicParam.cityid) +
             ' and DEVICEGATHERID=' + IntToStr(lGatherid);
  lVariant[0]:= VarArrayOf([lsqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    MessageBox(0,'删除成功','提示',MB_OK+64);
    CheckListBoxDev.Items.Delete(CheckListBoxDev.ItemIndex);
  end
  else
    MessageBox(0,'删除失败','提示',MB_OK+64);
end;

procedure TFormCompanyMgr.cxButtonCloseClick(Sender: TObject);
 var i, j : Integer;
begin
  for i:=0 to CheckListBoxDev.count-1 do
  begin
    if CheckListBoxDev.Checked[i] then
    begin
      ShowMessage(IntToStr(TWdInteger(CheckListBoxDev.Items.Objects[i]).Value));
    end;
  end;
end;

procedure TFormCompanyMgr.PopupMenu2Popup(Sender: TObject);
begin
  if not cxTreeViewCompany.Selected.HasChildren then
  begin
    N1.Visible:=True;
    N2.Visible:=True;
    N3.Visible:=True;
  end;
end;

procedure TFormCompanyMgr.InhertedFromParent(aParentid, aChildid: integer);
var
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lVariant:= VarArrayCreate([0,1],varVariant);
  lSqlstr := 'update fms_company_devgather_relat set companyid='+inttostr(aChildid)+' where companyid='+
             inttostr(aParentid)+' and cityid='+inttostr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lsqlstr]);
  lSqlstr := 'update FMS_COMPANY_ALARM_RELAT set companyid='+inttostr(aChildid)+' where companyid='+
             inttostr(aParentid)+' and cityid='+inttostr(gPublicParam.cityid);
  lVariant[1]:= VarArrayOf([lsqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
end;

procedure TFormCompanyMgr.N4Click(Sender: TObject);
var i: Integer;
begin
  for i:=CheckListBoxAlarm.Count-1 downto 0 do
  begin
    CheckListBoxAlarm.Checked[i]:=True;
    if not CheckListBoxAlarm.Checked[i] then
      ClickCheck(i,CheckListBoxAlarm.Checked[i],false);
  end;
  for i:=CheckListBoxAlarm.Count-1 downto 0 do
  begin
    if CheckListBoxAlarm.Checked[i] then
      ClickCheck(i,CheckListBoxAlarm.Checked[i],i=0);
  end;
end;


procedure TFormCompanyMgr.N5Click(Sender: TObject);
var i: Integer;
begin
  for i:=CheckListBoxAlarm.Count-1 downto 0 do
  begin
    CheckListBoxAlarm.Checked[i]:= not CheckListBoxAlarm.Checked[i];
    if not CheckListBoxAlarm.Checked[i] then
      ClickCheck(i,CheckListBoxAlarm.Checked[i],false);
  end;
  for i:=CheckListBoxAlarm.Count-1 downto 0 do
  begin
    if CheckListBoxAlarm.Checked[i] then
      ClickCheck(i,CheckListBoxAlarm.Checked[i],i=0);
  end;
end;

function TFormCompanyMgr.CheckGatherHasDev(aCityID, aDevGather: Integer):Boolean;
var
  lClientDataSet: TClientDataSet;
  lStrSql: string;
begin
  Result:= False;
  lClientDataSet:= TClientDataSet.Create(nil);
  lStrSql:= 'select * from FMS_DEVICEGATHER_DETAIL where cityid=' +
            IntToStr(aCityID) +
            ' and devicegatherid=' +
            IntToStr(aDevGather);
  with lClientDataSet do
  begin
    Close;
    lClientDataSet.ProviderName:= 'DataSetProvider';
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lStrSql]),0);
    if IsEmpty then
      Result:= False
    else
      Result:= True;
  end;
end;

function TFormCompanyMgr.IsExistsAlarm(aCompanyID,aAlarmCode: string): boolean;
var
  lDataSet: TClientDataSet;
  lSqlStr: string;
begin
  lDataSet:= TClientDataSet.Create(nil);
  try
    with lDataSet do
    begin
      close;
      ProviderName:='dsp_General_data';
      lSqlStr:= 'select 1 from fms_company_alarm_relat where companyid='+
                aCompanyID +
                'and alarmcontentcode=' + aAlarmCode;
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if eof then
        result:= false
      else
        result:= true;
    end;
  finally
    lDataSet.Free;
  end;
end;

procedure TFormCompanyMgr.MenuItem1Click(Sender: TObject);
var
  i : integer;
begin
//  for i:=0 to CheckListBoxAlarmInfo.Items.Count-1 do
    CheckListBoxAlarmInfo.SelectAll;
end;

procedure TFormCompanyMgr.MenuItem2Click(Sender: TObject);
var
  i : integer;
begin
  for i:=0 to CheckListBoxAlarmInfo.Items.Count-1 do
    CheckListBoxAlarmInfo.Items[i].Selected := (not CheckListBoxAlarmInfo.Items[i].Selected);
end;

procedure TFormCompanyMgr.SpeedButtonSearchClick(Sender: TObject);
begin
  LoadAlarmSet(TCompanyObject(cxTreeViewCompany.Selected.Data).ID,EditAlarmFilter.Text,true)
end;

procedure TFormCompanyMgr.EditAlarmFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key=#13 then
    SpeedButtonSearchClick(self)
end;

procedure TFormCompanyMgr.ClickCheck(aIndex: integer; aChecked, aLastFlag: boolean);
  var
  lContentCode: integer;
  lWdInteger: TWdInteger;
  lDestListItem: TListItem;
  lHashIndex: integer;
  I: integer;
begin
  if aChecked then
  begin
    lContentCode:= TWdInteger(CheckListBoxAlarm.Items.Objects[aIndex]).Value;
    if gSelectedAlarmContentList.IndexOf(inttostr(lContentCode))<0 then
    begin
      gSelectedAlarmContentList.Add(inttostr(lContentCode));
      lWdInteger:= TWdInteger.create(lContentCode);
      lDestListItem :=CheckListBoxAlarmInfo.Items.Add;
      lDestListItem.Data :=lWdInteger;
      lDestListItem.Caption := format('%.4d',[CheckListBoxAlarmInfo.Items.Count]);
      lDestListItem.SubItems.Add(CheckListBoxAlarm.Items[aIndex]);
    end;
  end
  else
  begin
    lContentCode:= TWdInteger(CheckListBoxAlarm.Items.Objects[aIndex]).Value;
    lHashIndex:= gSelectedAlarmContentList.IndexOf(inttostr(lContentCode));
    if lHashIndex >-1 then
    begin
      Dispose(CheckListBoxAlarmInfo.Items[lHashIndex].Data);
      CheckListBoxAlarmInfo.Items[lHashIndex].Delete;
      gSelectedAlarmContentList.Delete(lHashIndex);
    end;

    if aLastFlag then
    begin
      CheckListBoxAlarmInfo.Items.BeginUpdate;
      for i:=  0 to CheckListBoxAlarmInfo.Items.Count -1 do
      begin
        lDestListItem:= CheckListBoxAlarmInfo.Items[i];
        lDestListItem.Caption := format('%.4d',[i+1]);
      end;
      CheckListBoxAlarmInfo.Items.EndUpdate;
    end;
  end;
end;


procedure TFormCompanyMgr.CheckListBoxAlarmClickCheck(Sender: TObject);
begin
  ClickCheck(CheckListBoxAlarm.ItemIndex,CheckListBoxAlarm.Checked[CheckListBoxAlarm.ItemIndex],true);

end;



end.
