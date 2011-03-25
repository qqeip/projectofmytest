unit UnitTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList;

type
  TFormTest = class(TForm)
    GroupBox1: TGroupBox;
    TreeViewTest: TTreeView;
    Splitter1: TSplitter;
    Panel1: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    ImageList1: TImageList;
    procedure TreeViewTestMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure SetChildNode(aImageIndex: Integer; aNode: TTreeNode);
    procedure SetParentNode(aImageIndex: Integer; aNode: TTreeNode);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTest: TFormTest;

implementation

uses UnitDllPublic;

{$R *.dfm}

procedure TFormTest.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormTest.FormShow(Sender: TObject);
begin
//
end;

procedure TFormTest.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDllCloseRecall(FormTest);
end;

procedure TFormTest.TreeViewTestMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var FNode: TTreeNode;
begin
  if not(htonitem in TreeViewTest.GetHitTestInfoAt(X,Y)) then
    Exit;
  FNode:= TreeViewTest.Selected;
  if FNode=nil then Exit;
  TreeViewTest.Items.BeginUpdate;
  if FNode.ImageIndex=0 then
    FNode.ImageIndex:=1
  else
    FNode.ImageIndex:=0;
    
  FNode.SelectedIndex:= FNode.ImageIndex;

  if FNode.HasChildren then
    SetChildNode(FNode.ImageIndex,FNode);
  SetParentNode(FNode.ImageIndex,FNode);
  TreeViewTest.Items.EndUpdate;
end;

procedure TFormTest.SetChildNode(aImageIndex: Integer; aNode: TTreeNode);
 var I: Integer;
begin
  if aNode.HasChildren then
  begin
    for I:=0 to aNode.Count-1 do
    begin
      aNode.Item[I].ImageIndex:= aImageIndex;
      SetChildNode(aImageIndex,aNode.Item[i]);
    end;
  end;
end;

procedure TFormTest.SetParentNode(aImageIndex: Integer; aNode: TTreeNode);
 var I: Integer;
     fTempNode: TTreeNode;
     fFlag: Boolean;
begin
  fFlag:= False;
  fTempNode:= aNode.Parent;
  if fTempNode<>nil then
  begin
    if aNode.ImageIndex=1 then
    begin
      for I:=0 to fTempNode.Count-1 do
      begin
        if (fTempNode.Item[i].ImageIndex=0)or(fTempNode.Item[i].ImageIndex=2) then
        begin
          fTempNode.ImageIndex:=2;
          fFlag:= True;
          Break;
        end;
      end;
      if not fFlag then
      begin
        fTempNode.ImageIndex:= aImageIndex;
      end;
    end
    else if aImageIndex=0 then
    begin
      for I:=0 to fTempNode.Count-1 do
      begin
        if (fTempNode.Item[i].ImageIndex=1)or(fTempNode.Item[i].ImageIndex=2) then
        begin
          fTempNode.ImageIndex:=2;
          fFlag:= True;
          Break;
        end;
      end;
      if not fFlag then
      begin
        fTempNode.ImageIndex:= aImageIndex;
      end;
    end;
    SetParentNode(aImageIndex,fTempNode);
  end;
end;

end.



