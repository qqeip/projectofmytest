{*******************************************************}
{* 名称：  三态数据树图                                *}
{* 功能描述：指定树图结构表后动态生成三态树图          *}
{* 作者： cyx                                          *}
{* 公司名称：                                          *}
{*******************************************************}
unit DBThreeStateTree;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series, StdCtrls, DB, ADODB,
  Menus, Buttons, ComCtrls,DBClient;//DesignIntf;
type
  PDBThreeNodeInfo =^TNodeInfo;
  TNodeInfo = record
    ID : integer;
    Topid :integer;
    layer :integer;
    Name :String;
  end;


  TExPro = class(TPersistent)
  private
    FRootID :Integer;
    FDataSet :TDataSet;
    FTopFieldName :String;
    FIdFieldName :String;
    FSHowFieldName :String ;
    FThreeState :Boolean;
    procedure SetDataSet(const Value: TDataSet);
    //FFillTree :Boolean;
    //procedure SetFillTree(const Value: Boolean);
  published
    property RootId :integer read FRootid write Frootid default -1;
    property DataSet :TDataSet read FDataSet  write SetDataSet default nil;
    property TopFieldName :String read FTopFieldName write FTopFieldName;
    property IdFieldName :String read FIdFieldName write FIdFieldName;
    property SHowFieldName :String read FSHowFieldName write FSHowFieldName;
    property ThreeState :Boolean read FThreeState write FThreeState;
    //property IsFillTree :Boolean read FFillTree write SetFillTree;
  end;

  TDBThreeStateTree = class(TTreeView)
  private
    { Private declarations }
    FDBPro: TExPro;
    procedure CheckNode(Node: TTreeNode);
    procedure CheckParentNode(Node: TTreeNode);
    procedure SetProperties(const Value: TExPro);
    procedure SetThreeState(const Value: Boolean);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor CreateEx(AOwner: TComponent;IsThreeState:Boolean=false);overload;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure FillTree(Node:TTreeNode;topid :integer;layer:integer=-1);
    procedure ClearAllItem;

  published
    //生成树图的数据集
    property DBProperties:TExPro read FDBPro Write SetProperties;

    { Public declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MyVcl', [TDBThreeStateTree]);
end;

constructor TDBThreeStateTree.CreateEx(AOwner: TComponent;IsThreeState:Boolean);
begin
  inherited Create(AOwner);
  FDBPro := TExPro.Create;
end;

destructor TDBThreeStateTree.Destroy;
var
  i : integer;
begin
  for i := Self.Items.Count-1 downto 0 do
  begin
    Dispose(self.Items[i].Data);
    self.Items[i].Delete;
  end;
  inherited;
end;

// layer 指定是否需要通过 Layer 定位
procedure TDBThreeStateTree.FillTree(Node:TTreeNode;topid :integer;layer:integer);
var
  pNode :PDBThreeNodeInfo;
  lNode :TTreeNode;
  IdList :TStringList;
  i : integer;
begin
  if (not FDBPro.FDataSet.Active) or (FDBPro.FDataSet.RecordCount=0) then
    Exit;
  //IdList := nil;
  IdList :=TStringList.Create;
  try
    with FDBPro,FDBPro.FDataSet do
    begin
      if Layer =-1 then
        Filter :=FTopFieldName+' = '+IntToStr(topid)
      else
        Filter :=FTopFieldName+' = '+IntToStr(topid)+ ' and layer ='+IntToStr(layer);
      Filtered := true;
      if recordcount > 0 then
      begin
        first;
        While Not Eof do
        begin
          New(pNode);
          pNode.ID := FieldByName(FIDFieldName).AsInteger;
          pNode.layer := FieldByName('layer').AsInteger;
          pNode.Topid := topid;
          pNode.Name :=FieldByName(FShowFieldName).AsString;
          IdList.AddObject(pNode.Name,TObject(pNode));
          Next;
        end;
      end;
      //注意要加下面代码否则外部DataSet会报错
      Filter :='';
      Filtered := false;
    end;
    for i := 0 to IdLIst.Count-1 do
    begin
      pNode := PDBThreeNodeInfo(IdList.Objects[i]);
      lNode := self.Items.AddChildObject(Node,pNode.Name,pNode);
      lNode.ImageIndex :=pNode.layer+1;
      lNode.SelectedIndex := lNode.ImageIndex;
      if Layer=-1 then
        FillTree(lNode,pNode.ID,Layer)
      else
        FillTree(lNode,pNode.ID,pNode.layer+1);
    end;
  finally
    if IdList <> nil then IdList.Free;
  end;
  self.FullExpand;
  self.Perform(WM_VSCROLL,SB_TOP,0);
end;

procedure TDBThreeStateTree.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  lTreeNode:TTreeNode;
begin
  inherited;
  if (Self.Images <> nil) and FDBPro.FThreeState then
  begin
    if (Button = mbLeft ) and   (htOnItem	in self.GetHitTestInfoAt(x,y))   then
    begin
      lTreeNode:=self.Selected ;
      if lTreeNode <> nil then
      begin
        if lTreeNode.ImageIndex=1 then
        begin
          lTreeNode.ImageIndex:=0 ;
          lTreeNode.SelectedIndex:=0;
        end
        else
        begin
          lTreeNode.ImageIndex:=1  ;
          lTreeNode.SelectedIndex:=1;
        end;
        CheckNode(lTreeNode);
        CheckParentNode(lTreeNode);
      end;
    end;
    self.Refresh;
  end;
end;

procedure TDBThreeStateTree.CheckNode(Node: TTreeNode);
var
  lChildNode: TTreeNode;
begin
  if Node.HasChildren then
  begin
    lChildNode:=Node.GetFirstChild;
    while lChildNode<>nil do
    begin
      lChildNode.ImageIndex:=Node.ImageIndex;
      lChildNode.SelectedIndex:=Node.SelectedIndex;
      CheckNode(lChildNode);
      lChildNode:=Node.GetNextChild(lChildNode);
    end;
  end;
end;


procedure TDBThreeStateTree.CheckParentNode(Node: TTreeNode);
var
  lParentNode,lChildNode:TTreeNode;
  lCount,lGrayCount:integer;
begin
  lParentNode:=Node.Parent;
  if lParentNode<>nil then
  begin
    lCount:=0;
    lGrayCount:=0;
    lChildNode:=lParentNode.GetFirstChild;
    while lChildNode<>nil do
    begin
      if lChildNode.ImageIndex=1 then
        inc(lCount);
      if lChildNode.ImageIndex=2 then
        inc(lGrayCount);
      lChildNode:=lParentNode.GetNextChild(lChildNode);
    end;

    if lCount=0 then
    begin
      if lGrayCount>0 then
      begin
        lParentNode.ImageIndex:=2;
        lParentNode.SelectedIndex:=2;
      end else
      begin
        lParentNode.ImageIndex:=0;
        lParentNode.SelectedIndex:=0;
      end;
    end else
    if lCount<lParentNode.Count then
    begin
      lParentNode.ImageIndex:=2;
      lParentNode.SelectedIndex:=2;
    end else
    begin
      lParentNode.ImageIndex:=1;
      lParentNode.SelectedIndex:=1;
    end;
    CheckParentNode(lParentNode);
  end;
end;

procedure TDBThreeStateTree.ClearAllItem;
var
  i : integer;
begin
  for i := Self.Items.Count-1 downto 0 do
  begin
    Dispose(self.Items[i].Data);
    self.Items[i].Delete;
  end;
end;

procedure TDBThreeStateTree.SetProperties(const Value: TExPro);
begin
  FDBPro := Value;
end;

constructor TDBThreeStateTree.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDBPro := TExPro.Create;
  //self.OnClick := MyClick;
end;

procedure TDBThreeStateTree.SetThreeState(const Value: Boolean);
begin
 FDBPro.FThreeState := Value;
end;


{ TExPro }

procedure TExPro.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

end.
