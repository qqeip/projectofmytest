unit UnitAreaMgr;

{区域管理用到的表是：pop_area。是一个树形表，TopID是上级节点的ID值，Layer是级。
 CITYID是一个城市下的所有区域都为同一个CITYID.如：杭州及杭州下的所属地区的
 CITYID都为571。 而浙江省的CITYID未0.
 并可让用户自定义此CITYID值。
 需要实现功能：新增、修改、删除、刷新。用户自定义CITYID，已有的区域全部更新。
 如：杭州的CITYID改为570，则杭州的所有区域的CITYID都要更新为570
 参见：vfms的区域管理。
 }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, cxControls, cxContainer, cxTreeView, ExtCtrls, Menus,
  cxLookAndFeelPainters, StdCtrls, cxButtons, DB, DBClient, cxLabel,
  cxEdit, cxTextEdit, cxGroupBox;

type
  TAreaObject= class
    ID: Integer ;
    Top_ID: Integer;
    Name: string;
    Level: Integer;
    CITYID: Integer;
end;
type
  TFormAreaMgr = class(TForm)
    cxTreeViewArea: TcxTreeView;
    Panel1: TPanel;
    Splitter1: TSplitter;
    cxTextEditAreaName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxGroupBox1: TcxGroupBox;
    cxButtonAdd: TcxButton;
    cxButtonModify: TcxButton;
    cxButtonDel: TcxButton;
    cxButtonFresh: TcxButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxButtonFreshClick(Sender: TObject);
    procedure cxTreeViewAreaMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure N1Click(Sender: TObject);
  private
    procedure CreateAreaTree(aTreeView: TcxTreeView);
    procedure AddTreeViewNode(aTreeView: TcxTreeView;aID,aTOP_ID,aLAYER,aCITYID:Integer;aNAME:string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAreaMgr: TFormAreaMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormAreaMgr.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormAreaMgr.FormShow(Sender: TObject);
begin
  cxTreeViewArea.Items.Clear;
  CreateAreaTree(cxTreeViewArea);
end;

procedure TFormAreaMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormAreaMgr.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormAreaMgr.CreateAreaTree(aTreeView: TcxTreeView);
var
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,7]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        AddTreeViewNode(cxTreeViewArea,
                        FieldByName('ID').AsInteger,
                        FieldByName('TOP_ID').AsInteger,
                        FieldByName('LAYER').AsInteger,
                        FieldByName('CITYID').AsInteger,
                        FieldByName('NAME').AsString
                        );
        Next;
      end;
    end;
    aTreeView.FullExpand;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormAreaMgr.AddTreeViewNode(aTreeView: TcxTreeView; aID,aTOP_ID,aLAYER,aCITYID:Integer;aNAME:string);
var
  lAreaObject: TAreaObject;
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
        if TAreaObject(lTempNode.Data).ID=aParent then
        begin
          result:=lTempNode;
          Break;
        end;
        lTempNode:=lTempNode.getNext;
      end;
    end;
  end;
begin
  lAreaObject:= TAreaObject.Create;
  lAreaObject.ID:= aID;
  lAreaObject.Top_ID:= aTOP_ID;
  lAreaObject.Level:= aLAYER;
  lAreaObject.CITYID:= aCITYID;
  lAreaObject.Name:= aNAME;
  lParentNode:= GetParentNode(aLAYER,aTOP_ID);
  lNewNode:= aTreeView.Items.AddChildObject(lParentNode,lAreaObject.Name,lAreaObject);
end;

procedure TFormAreaMgr.cxButtonAddClick(Sender: TObject);
var
  lTempNode: TTreeNode;
  lAreaObject: TAreaObject;
  lAreaID: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lTempNode:= cxTreeViewArea.Selected;
  if (lTempNode=nil) or (lTempNode.Data=nil) then
  begin
    MessageBox(0,'请先选择一个节点','提示',MB_OK+64);
    Exit;
  end;
  if IsExists('pop_area','name',cxTextEditAreaName.Text) then
  begin
    MessageBox(0,'该地名已经存在!','提示',MB_OK+64);
    Exit;
  end;
  lAreaID:=gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr:= 'Insert into pop_area (ID,TOP_ID,NAME,LAYER,CITYID)'+
            ' values('+
            IntToStr(lAreaID)+','+
            IntToStr(TAreaObject(lTempNode.Data).ID)+','''+
            cxTextEditAreaName.Text+''','+
            IntToStr(lTempNode.Level+1)+','+
            IntToStr(TAreaObject(lTempNode.Data).CITYID)+')';
  lVariant[0]:=VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    MessageBox(0,'新增成功','提示',MB_OK+64);
    lAreaObject:= TAreaObject.Create;
    lAreaObject.ID:=lAreaID;
    lAreaObject.Top_ID:= TAreaObject(lTempNode.Data).ID;
    lAreaObject.Name:= cxTextEditAreaName.Text;
    lAreaObject.Level:= lTempNode.Level+1;
    lAreaObject.CITYID:= TAreaObject(lTempNode.Data).CITYID;
    cxTreeViewArea.Items.AddChildObject(lTempNode,lAreaObject.Name,lAreaObject);
  end
  else
    MessageBox(0,'新增失败','提示',MB_OK+64);
end;

procedure TFormAreaMgr.cxButtonModifyClick(Sender: TObject);
var
  lTempNode: TTreeNode;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lTempNode:= cxTreeViewArea.Selected;
  if (lTempNode=nil) or (lTempNode.Data=nil) then
  begin
    MessageBox(0,'请先选择一个节点','提示',MB_OK+64);
    Exit;
  end;
  if IsExists('pop_area','name',cxTextEditAreaName.Text) then
  begin
    MessageBox(0,'该地名已经存在!','提示',MB_OK+64);
    Exit;
  end;
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr:= 'update pop_area set NAME='''+
            cxTextEditAreaName.Text+
            ''' where ID='+
            IntToStr(TAreaObject(lTempNode.Data).ID)+
            ' and cityid='+
            IntToStr(TAreaObject(lTempNode.Data).CITYID);
  lVariant[0]:=VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    MessageBox(0,'修改成功','提示',MB_OK+64);
    TAreaObject(lTempNode.Data).Name:= cxTextEditAreaName.Text;
  end
  else
    MessageBox(0,'修改失败','提示',MB_OK+64);
end;

procedure TFormAreaMgr.cxButtonDelClick(Sender: TObject);
var
  lTempNode: TTreeNode;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  lTempNode:= cxTreeViewArea.Selected;
  if (lTempNode=nil) or (lTempNode.Data=nil) then
  begin
    MessageBox(0,'请先选择一个节点','提示',MB_OK+64);
    Exit;
  end;
  if Application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    Exit;
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr:= 'delete from pop_area where ID='+
            IntToStr(TAreaObject(lTempNode.Data).ID)+
            ' and cityid='+
            IntToStr(TAreaObject(lTempNode.Data).CITYID);
  lVariant[0]:=VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    MessageBox(0,'删除成功','提示',MB_OK+64);
    lTempNode.Delete;
  end
  else
    MessageBox(0,'删除失败','提示',MB_OK+64);
end;

procedure TFormAreaMgr.cxButtonFreshClick(Sender: TObject);
begin
  cxTreeViewArea.Items.Clear;
  CreateAreaTree(cxTreeViewArea);
end;

procedure TFormAreaMgr.cxTreeViewAreaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lTempNode: TTreeNode;
begin
  if (Button<> mbleft) or (not (htonItem in cxTreeViewArea.GetHitTestInfoAt(X,y))) then
    Exit;
  lTempNode:= cxTreeViewArea.Selected;
  if (lTempNode=nil)or(lTempNode.Data=nil) then Exit;
  cxTextEditAreaName.Text:= lTempNode.Text;
end;

procedure TFormAreaMgr.N1Click(Sender: TObject);
var
  lTempNode: TTreeNode;
  lCityID: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
//  lTempNode:= cxTreeViewArea.Selected;
//  lCityID:= TAreaObject(lTempNode.data).CITYID;
//  if (lTempNode=nil) or (lTempNode.Data=nil) or (lTempNode.Level<=0) then
//  begin
//    MessageBox(0,'请先选择一个城市节点','提示',MB_OK+64);
//    Exit;
//  end;
//
//  for i:=0 to lTempNode.Count-1 do
//  begin
//    lVariant:= VarArrayCreate([0,lTempNode.Count-1],varVariant);
//    lSqlstr:= 'update pop_area set cityid='+
//              IntToStr(lCityID)+
//              ' where id='+
//              IntToStr(TAreaObject(lTempNode.Data).ID) ;
//    lVariant[i]:= VarArrayOf([lSqlstr]);
//  end;
//  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
//
//  if lsuccess then
//    MessageBox(0,'更新城市编号成功','提示',MB_OK+64)
//  else
//    MessageBox(0,'更新城市编号成功','提示',MB_OK+64);
end;

end.
