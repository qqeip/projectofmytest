{故障原因及排障方法管理
 用到得表：alarm_dic_code_info
 1、故障原因树：alarm_dic_code_info dictype := 7
 2、排障方法：
}
unit UnitAlarmAndSolutionMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, ComCtrls, Menus, StdCtrls, DBClient,
  cxButtons, cxTreeView, cxContainer, cxEdit, cxGroupBox, cxPC, cxControls,
  cxGraphics, cxMemo, cxMaskEdit, cxDropDownEdit, cxTextEdit, cxLabel,
  ImgList, jpeg, ExtCtrls;

type
  TNodeInfo = class
    diccode : integer;
    dicname : String;
    dicorder : integer;
    remark : string;
    parentid : integer;
    Level : integer;
    cityid : integer;
    dictype: Integer;
  end;

type
  TFormAlarmAndSolutionMgr = class(TForm)
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxGroupBox1: TcxGroupBox;
    cxTreeViewMethod: TcxTreeView;
    cxTreeViewReason: TcxTreeView;
    PopupMenuAuto: TPopupMenu;
    N_Add: TMenuItem;
    N_Modify: TMenuItem;
    N_Del: TMenuItem;
    N2: TMenuItem;
    N_Refresh: TMenuItem;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxTextEditName: TcxTextEdit;
    cxComboBoxIsChecked: TcxComboBox;
    cxMemoRemark: TcxMemo;
    cxBtnOK: TcxButton;
    ImageMenu: TImageList;
    cxButton1: TcxButton;
    Panel3: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Image4: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cxBtnOKClick(Sender: TObject);
    procedure N_AddClick(Sender: TObject);
    procedure N_ModifyClick(Sender: TObject);
    procedure cxTreeViewReasonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N_DelClick(Sender: TObject);
    procedure N_RefreshClick(Sender: TObject);
    procedure cxPageControl1Change(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
  private
    { Private declarations }
    FMaxReasionTreeLevel : integer;     //最大故障原因级别

    procedure CreateTree(aTreeView: TcxTreeView; aDicType: Integer);
    procedure AddTreeViewNode(aTreeView: TcxTreeView; aCODE, aORDER,
      aPARENTID, aCITYID, aDicType: Integer;aSETVALUE, aNAME, aREMARK: string);
    procedure SetVisible(aBool: Boolean);
    procedure AutoMenuItem(aNode: TTreeNode);
    function GetMaxReasonTreeLevel: Integer;
    function GetActiveNode : TTreeNode;
    function IfCheck(aDiccode: integer): integer;
    function GetChildCounts(aNode: TTreeNode): integer;
    procedure CheckKaohe(aDiccode,aIfCheck:integer);
  public
    { Public declarations }
  end;

var
  FormAlarmAndSolutionMgr: TFormAlarmAndSolutionMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormAlarmAndSolutionMgr.FormCreate(Sender: TObject);
begin
  FMaxReasionTreeLevel:= GetMaxReasonTreeLevel;
end;

procedure TFormAlarmAndSolutionMgr.FormShow(Sender: TObject);
begin
//
  CreateTree(cxTreeViewReason,7);
  CreateTree(cxTreeViewMethod,6);
  SetVisible(False);
end;

procedure TFormAlarmAndSolutionMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormAlarmAndSolutionMgr,1,'','');
end;

procedure TFormAlarmAndSolutionMgr.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormAlarmAndSolutionMgr.CreateTree(aTreeView: TcxTreeView; aDicType: Integer);
var
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,200,aDicType]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        AddTreeViewNode(aTreeView,
                        FieldByName('DICCODE').AsInteger,
                        FieldByName('DICORDER').AsInteger,
                        FieldByName('PARENTID').AsInteger,
                        FieldByName('CITYID').AsInteger,
                        adictype,
                        FieldByName('SETVALUE').asString,
                        FieldByName('DICNAME').AsString,
                        FieldByName('REMARK').AsString
                        );
        Next;
      end;
    end;
    aTreeView.FullExpand;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmAndSolutionMgr.AddTreeViewNode(aTreeView: TcxTreeView;
            aCODE,aORDER,aPARENTID,aCITYID,aDicType:Integer;aSETVALUE,aNAME,aREMARK:string);
var
  lNodeInfo:TNodeInfo;
  lNewNode,lParentNode : TTreeNode;
  function GetParentNode(aLevel,aParent: Integer):TTreeNode;
  var
    lTempNode: TTreeNode;
  begin
    result:=nil;
    if alevel=0 then Exit;
    with aTreeView.Items do
    begin
      lTempNode:= GetFirstNode;
      if lTempNode=nil then exit;
      while lTempNode<>nil do
      begin
        if TNodeInfo(lTempNode.Data).diccode=aParent then
        begin
          result:=lTempNode;
          Break;
        end;
        lTempNode:=lTempNode.getNext;
      end;
    end;
  end;
begin
  lNodeInfo:= TNodeInfo.Create;
  lNodeInfo.diccode  := aCODE;
  lNodeInfo.dicorder := aORDER;
  lNodeInfo.parentid := aPARENTID;
  lNodeInfo.Level    := StrToInt(aSETVALUE);
  lNodeInfo.cityid := gPublicParam.cityid;
  lNodeInfo.dictype:= aDicType;
  lNodeInfo.dicname := aNAME;
  lNodeInfo.remark := aREMARK;
  lParentNode:= GetParentNode(StrToInt(aSETVALUE),aPARENTID);
  lNewNode:= aTreeView.Items.AddChildObject(lParentNode,lNodeInfo.dicname,lNodeInfo);
  lNewNode.ImageIndex:=StrToInt(aSETVALUE);
end;

procedure TFormAlarmAndSolutionMgr.SetVisible(aBool: Boolean);
var i: Integer;
begin
  for i:=0 to cxGroupBox1.ControlCount-1 do
  begin
    cxGroupBox1.Controls[i].Enabled:= aBool;
  end;
end;

procedure TFormAlarmAndSolutionMgr.cxBtnOKClick(Sender: TObject);
var
  lNode: TTreeNode;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
  lNodeInfo : TNodeInfo;
  lDiccode, lDictype, lDicorder, lParentid, lSetvalue, lCityid  : integer;
  lDicname, lRemark : string;
begin
  if Trim(cxTextEditName.Text) = '' then
  begin
    application.MessageBox('资料小类名称不能为空！','提示',MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  lNode := GetActiveNode;
  if (lNode=nil) or (lNode.Data=nil) then
  begin
    application.MessageBox('获取树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  lVariant:= VarArrayCreate([0,0],varVariant);
  if cxBtnOK.Tag=1 then
  begin
    lDiccode  := gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
    lDicorder := GetChildCounts(lNode)+1;
    lParentid := TNodeInfo(lNode.Data).diccode;
    lSetvalue := TNodeInfo(lNode.Data).Level+1;
    lCityid   := TNodeInfo(lNode.Data).cityid;
    lDictype  := TNodeInfo(lNode.Data).dictype;
    lDicname  := cxTextEditName.Text;
    lRemark   :=  cxMemoRemark.Lines.Text;
    lSqlstr   := 'insert into alarm_dic_code_info (diccode, dictype, dicname, dicorder, ifineffect,'+
                 ' remark, parentid, setvalue, cityid) values ('+
                 inttostr(lDiccode)+','+inttostr(lDictype)+','+Quotedstr(lDicname)+','+inttostr(lDicorder)+','+
                 '1,'+Quotedstr(lRemark)+','+inttostr(lParentid)+','+inttostr(lSetvalue)+','+inttostr(lCityid)+')';
    lVariant[0]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      CheckKaohe(lDiccode,cxComboBoxIsChecked.ItemIndex);
      application.MessageBox(pchar('操作成功！'),'提示',MB_OK + MB_ICONINFORMATION);

      lNodeInfo:= TNodeInfo.Create;
      lNodeInfo.diccode  :=lDiccode;
      lNodeInfo.dictype  :=lDictype;
      lNodeInfo.dicorder :=lDicorder;
      lNodeInfo.parentid :=lParentid;
      lNodeInfo.Level    :=lSetvalue;
      lNodeInfo.cityid   :=lCityid;
      lNodeInfo.dicname  :=lDicname;
      lNodeInfo.remark   :=lRemark;
      if cxPageControl1.ActivePageIndex=0 then
        cxTreeViewReason.Items.AddChildObject(lNode,lDicname,lNodeInfo)
      else
      if cxPageControl1.ActivePageIndex=1 then
        cxTreeViewMethod.Items.AddChildObject(lNode,lDicname,lNodeInfo);
    end
    else
      application.MessageBox(pchar('操作失败！'),'提示',MB_OK + MB_ICONINFORMATION);
  end
  else if cxBtnOK.Tag=2 then
  begin
    lDiccode := TNodeInfo(lNode.Data).diccode;
    lDictype  := TNodeInfo(lNode.Data).dictype;
    lCityid  := TNodeInfo(lNode.Data).cityid;
    lDicname := cxTextEditName.Text;
    lRemark := cxMemoRemark.Lines.Text;
    lSqlstr:='update alarm_dic_code_info set dicname='+quotedstr(lDicname)+','+
             'remark='+Quotedstr(lRemark)+
             ' where diccode='+inttostr(lDiccode)+' and cityid='+inttostr(lCityid)+ ' and Dictype='+inttostr(lDictype);
    lVariant[0]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      CheckKaohe(lDiccode,cxComboBoxIsChecked.ItemIndex);
      application.MessageBox(pchar('操作成功！'),'提示',MB_OK + MB_ICONINFORMATION);

      TNodeInfo(lNode.Data).dicname:=lDicname;
      TNodeInfo(lNode.Data).remark:=lRemark;
      lNode.Text:= lDicname;
    end;
  end;

  SetVisible(False);
end;

procedure TFormAlarmAndSolutionMgr.N_AddClick(Sender: TObject);
var
  lNode: TTreeNode;
begin
  SetVisible(True);
  cxBtnOK.Tag:=1;
  lNode := GetActiveNode;
  if (lNode = nil ) or (lNode.Data=nil ) then Exit;
  cxTextEditName.text:=lNode.Text;
  cxComboBoxIsChecked.ItemIndex:=IfCheck(TNodeInfo(lNode.Data).diccode);
  cxMemoRemark.Text := TNodeInfo(lNode.Data).remark;
  
end;

procedure TFormAlarmAndSolutionMgr.N_ModifyClick(Sender: TObject);
var
  lNode: TTreeNode;
begin
  SetVisible(True);
  cxBtnOK.Tag:=2;
  lNode := GetActiveNode;
  if (lNode = nil ) or (lNode.Data=nil ) then Exit;
  cxTextEditName.text:=lNode.Text;
  cxComboBoxIsChecked.ItemIndex:=IfCheck(TNodeInfo(lNode.Data).diccode);
  cxMemoRemark.Text := TNodeInfo(lNode.Data).remark;
end;

procedure TFormAlarmAndSolutionMgr.N_DelClick(Sender: TObject);
var
  lNode: TTreeNode;
  lMsg: string;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lNode := GetActiveNode;
  if (lNode=nil) or (lNode.Data=nil) then
  begin
    application.MessageBox('获取树节点信息失败,请选择一个节点！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  lMsg:= '确定删除['+TNodeInfo(lNode.Data).dicname+']?';
  if Application.MessageBox(PChar(lMsg),'信息',MB_OKCANCEL+MB_ICONINFORMATION)=IDOK then
  begin
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr:='delete from alarm_dic_code_info where diccode='+inttostr(TNodeInfo(lNode.Data).diccode)+' and cityid='+inttostr(TNodeInfo(lNode.Data).cityid);
    lVariant[0]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      lNode.delete;
      MessageBox(0,'删除成功','提示',MB_OK+64);
    end
    else
      MessageBox(0,'删除失败','提示',MB_OK+64);
  end;

  SetVisible(False);
end;

procedure TFormAlarmAndSolutionMgr.N_RefreshClick(Sender: TObject);
begin
//
end;

procedure TFormAlarmAndSolutionMgr.cxTreeViewReasonMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
var
  lNode: TTreeNode;
begin
  if (( not (htOnItem	in TcxTreeView(Sender).GetHitTestInfoAt(x,y)))) then    //(Button <> mbLeft ) or
    exit;
  lNode:=TcxTreeView(Sender).Selected;
  if (lNode=nil) or (lNode.Data=nil) then exit;
  SetVisible(False);
  AutoMenuItem(lNode);
end;

procedure TFormAlarmAndSolutionMgr.AutoMenuItem(aNode: TTreeNode);
var
  aNodeInfo:TNodeInfo;
begin
  aNodeInfo := TNodeInfo(aNode.Data);
  N_Add.Enabled:=true;
  N_Modify.Enabled:=true;
  N_Del.Enabled:=true;
  if aNode.HasChildren or (aNodeInfo.Level=0) then
    N_Del.Enabled:=false;
  if aNodeInfo.Level=0 then
    N_Modify.Enabled := false;

  if aNodeInfo.dictype = 7 then //告警原因
  begin
    if aNodeInfo.Level>=FMaxReasionTreeLevel then
    begin
      N_Add.Enabled:=false;
    end;
  end;
end;

function TFormAlarmAndSolutionMgr.GetMaxReasonTreeLevel:Integer;
var
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,201,gPublicParam.cityid]),0);
      if IsEmpty then exit;
      Result:= fieldbyname('setvalue').AsInteger;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAlarmAndSolutionMgr.cxPageControl1Change(Sender: TObject);
begin
  SetVisible(False);
end;


function TFormAlarmAndSolutionMgr.GetActiveNode: TTreeNode;
begin
  result := nil;
  if cxPageControl1.ActivePageIndex=0 then
    result:=cxTreeViewReason.Selected
  else if cxPageControl1.ActivePageIndex=1 then
    result:=cxTreeViewMethod.Selected;
end;

function TFormAlarmAndSolutionMgr.IfCheck(aDiccode:integer): integer;
var
  lClientDataSet: TClientDataSet;
  lList :TstringList;
  lIndex :integer;
begin
  lList := TstringList.Create;
  lList.Delimiter:=',';
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,202,gPublicParam.cityid]),0);
      lList.DelimitedText:=FieldByName('setvalue').AsString;
    end;
    lIndex := lList.IndexOf(inttostr(aDiccode));
    if lIndex>-1 then
      result:=1
    else
      result:=0  
  finally

  end;
end;

procedure TFormAlarmAndSolutionMgr.CheckKaohe(aDiccode, aIfCheck: integer);
var
  lClientDataSet: TClientDataSet;
  lList :TstringList;
  lIndex :integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lList := TstringList.Create;
  lList.Delimiter:=',';
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,202,gPublicParam.cityid]),0);
      lList.DelimitedText:=FieldByName('setvalue').AsString;
    end;
    lIndex := lList.IndexOf(inttostr(aDiccode));
    if lIndex>-1 then
    begin
      if aIfCheck=0 then
        lList.Delete(lIndex);
    end else
    begin
      if aIfCheck=1 then
        lList.Add(inttostr(aDiccode));
    end;
    lVariant:= VarArrayCreate([0,0],varVariant);
    lSqlstr:= 'update alarm_sys_function_set set setvalue='+Quotedstr(lList.DelimitedText)+
              ' where cityid='+inttostr(gPublicParam.cityid)+' and kind=17';
    lVariant[0]:= VarArrayOf([lSqlstr]);
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
    end;              
  finally
    lList.Free;
    lClientDataSet.Free;
  end;
end;

function TFormAlarmAndSolutionMgr.GetChildCounts(aNode: TTreeNode): integer;
var
  lChildNode : TTreeNode;
  lCount : integer;
begin
  result := 0;
  lCount := 0;
  lChildNode := aNode.getFirstChild;
  while lChildNode<> nil  do
  begin
    inc(lCount);
    lChildNode:=lChildNode.getNextSibling;
  end;
  result := lCount;
end;

procedure TFormAlarmAndSolutionMgr.cxButton1Click(Sender: TObject);
begin
  SetVisible(False);
end;

end.
