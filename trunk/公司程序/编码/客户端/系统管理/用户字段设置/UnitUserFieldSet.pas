unit UnitUserFieldSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, StdCtrls, Buttons, ExtCtrls, CommCtrl, DB, DBClient,
  jpeg;

type
  TcolUserSetParam=class
    ID         :Integer;//NUMBER not null,
    CITYID     :Integer;//NUMBER not null,
    DEVICETYPE :Integer;//NUMBER,
    USERID     :Integer;//NUMBER,
    COLCODE    :Integer;//NUMBER,
    COL_NAME_ENG:String;
    COL_NAME_CN :String;
    COL_ORDER  :Integer;//NUMBER
    IF_SHOW    :Integer;
  end;

  TFormUserFieldSet = class(TForm)
    treeview: TTreeView;
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Button1: TButton;
    GroupBox1: TGroupBox;
    ListView: TListView;
    ImageList2: TImageList;
    Panel3: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure treeviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
  private
    OriginalListViewWindowProc : TWndMethod;

    procedure ListViewWindowProcEx(var Message: TMessage);
    procedure ShowGroupColInfo(aNode :TTreeNode);
  public
    { Public declarations }
  end;

var
  FormUserFieldSet: TFormUserFieldSet;

implementation

uses UnitColComentCommon, UnitVFMSGlobal, UnitDllCommon;

{$R *.dfm}

procedure TFormUserFieldSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  DestoryTreeview(TreeView);
  DestoryListView(ListView);

  inherited;
  gDllMsgCall(FormUserFieldSet,1,'','');
end;

procedure TFormUserFieldSet.ListViewWindowProcEx(var Message: TMessage);
var
  listItem : TListItem;
begin
  if Message.Msg = CN_NOTIFY then
  begin
    if PNMHdr(Message.LParam)^.Code = LVN_ITEMCHANGED then
    begin
      with PNMListView(Message.LParam)^ do
      begin
        if (uChanged and LVIF_STATE) <> 0 then
        begin
          if ((uNewState and LVIS_STATEIMAGEMASK) shr 12) <> ((uOldState and LVIS_STATEIMAGEMASK) shr 12) then
          begin
            listItem := listView.Items[iItem];
            if listItem.Data<>nil then
              if TcolUserSetParam(listItem.Data).if_show=2 then
                listItem.Checked:=true;
          end;
        end;
      end;
    end;
  end;
  //original ListView message handling
  OriginalListViewWindowProc(Message) ;
end;

procedure TFormUserFieldSet.FormShow(Sender: TObject);
begin
  InitDeviceType(TreeView,false);
end;

procedure TFormUserFieldSet.FormCreate(Sender: TObject);
begin
  OriginalListViewWindowProc := ListView.WindowProc;
  ListView.WindowProc := ListViewWindowProcEx;
end;

procedure TFormUserFieldSet.treeviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lNode:TTreeNode;
begin
  lNode:=TreeView.Selected;
  if (lNode=nil) or (lNode.Data=nil) or (lNode.Level=0) then exit;

  //显示本组中已经规划的字段
  ShowGroupColInfo(lNode);
end;

procedure TFormUserFieldSet.ShowGroupColInfo(aNode: TTreeNode);
var
  lcolUserSetParam:TcolUserSetParam;
  newlistItem:TlistItem;
  rowcaption:integer;
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=gTempInterface.GetCDSData(VarArrayOf([22,1,gPublicParam.userid, gPublicParam.cityid, TGroupParam(aNode.Data).devicetype]),0);
    first;
    rowcaption:= 1;
    ListView.Items.BeginUpdate;
    DestoryListView(ListView);
    try
      while not eof do
      begin
        lcolUserSetParam:=TcolUserSetParam.Create;
        lcolUserSetParam.ID := FieldByName('ID').AsInteger;
        lcolUserSetParam.CITYID:=FieldByName('cityid').AsInteger;
        lcolUserSetParam.DEVICETYPE:=FieldByName('DEVICETYPE').AsInteger;
        lcolUserSetParam.USERID:=FieldByName('USERID').AsInteger;
        lcolUserSetParam.COLCODE:=FieldByName('COLCODE').AsInteger;
        lcolUserSetParam.COL_NAME_ENG:=FieldByName('COL_NAME_ENG').AsString;
        lcolUserSetParam.COL_NAME_CN:=FieldByName('COL_NAME_CN').AsString;
        lcolUserSetParam.COL_ORDER:=FieldByName('COL_ORDER').AsInteger;
        lcolUserSetParam.IF_SHOW:=FieldByName('IF_SHOW').AsInteger;
        newlistItem:=ListView.Items.Add;
        newlistItem.Data :=lcolUserSetParam;
        if lcolUserSetParam.IF_SHOW=0 then
           newlistItem.Checked:=false
        else
           newlistItem.Checked:=true;
        newlistItem.Caption:=format('%0.3d',[rowcaption]);
        newlistItem.SubItems.add(lcolUserSetParam.col_name_CN);
        newlistItem.SubItems.Add(lcolUserSetParam.COL_NAME_Eng);

        next;
        Inc(rowcaption);
      end;
    finally
      ListView.Items.EndUpdate;
    end;
  end;
end;

procedure TFormUserFieldSet.SpeedButton3Click(Sender: TObject);
var
  i:integer;
begin
  for i := 0 to ListView.Items.Count- 1 do
  begin
    if TcolUserSetParam(ListView.Items[i].Data).IF_SHOW<>2 then
       ListView.Items[i].Checked:=((Sender as TSpeedButton).Tag=0)
    else
       ListView.Items[i].Checked:=true;
  end;
  if (Sender as TSpeedButton).Tag=1 then
  begin
    (Sender as TSpeedButton).Tag:=0;
    (Sender as TSpeedButton).Caption:='全选';
  end
  else
  begin
    (Sender as TSpeedButton).Tag:=1;
    (Sender as TSpeedButton).Caption:='反选';
  end;
end;

procedure TFormUserFieldSet.SpeedButton1Click(Sender: TObject);
var
  SourcItem,DesItem,TempItem: TListItem;
  DesItemCaption:String;
  i: Integer;
begin
  SourcItem := ListView.Selected;
  if SourcItem = nil then Exit;
  I := ListView.Selected.Index;
  if I - 1 < 0 then Exit;
  ListView.Items.BeginUpdate;
  TempItem := ListView.Items.Add;
  DesItem := ListView.Items[I -1];
  TempItem.Assign(DesItem);
  //TempItem.Data := DesItem.Data;
  TempItem.Caption:=SourcItem.Caption;
  DesItemCaption:=DesItem.Caption;
  DesItem.Assign(SourcItem);
  //DesItem.Data :=SourcItem.Data;
  DesItem.Caption:=DesItemCaption;
  SourcItem.Assign(TempItem);
  //SourcItem.Data := TempItem.Data;
  //TcolUserSetParam(TempItem.Data).Free;
  TempItem.Delete;
  SourcItem.Selected := False;
  DesItem.Selected := True;
  ListView.Items.EndUpdate;
end;

procedure TFormUserFieldSet.SpeedButton2Click(Sender: TObject);
var
  SourcItem,DesItem,TempItem: TListItem;
  DesItemCaption:String;
  i: Integer;
begin
  SourcItem := ListView.Selected;
  if SourcItem = nil then Exit;
  I := ListView.Selected.Index;
  if I + 1 >=ListView.Items.Count then Exit;
  ListView.Items.BeginUpdate;
  TempItem := ListView.Items.Add;
  DesItem := ListView.Items[I+1];
  TempItem.Assign(DesItem);
  TempItem.Caption:=SourcItem.Caption;
  //TempItem.Data :=DesItem.Data;
  DesItemCaption:=DesItem.Caption;
  DesItem.Assign(SourcItem);
  DesItem.Caption:=DesItemCaption;
  //DesItem.Data := SourcItem.Data;
  SourcItem.Assign(TempItem);
  //SourcItem.Data:=TempItem.Data;
  //TcolUserSetParam(TempItem.Data).Free;
  TempItem.Delete;
  SourcItem.Selected := False;
  DesItem.Selected := True;
  ListView.Items.EndUpdate;
end;

procedure TFormUserFieldSet.Button1Click(Sender: TObject);
var
  i: Integer;

  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
  lSelectedItemCount: integer;
  lNode: TTreeNode;
begin
  lNode:= treeview.Selected;
  if (lNode=nil) or (lNode.Data=nil) or (lNode.Level=0) then exit;
  //保存信息
  try
    lSelectedItemCount:= 0;
    for I := 0 to ListView.Items.Count - 1 do
    begin
      if ListView.Items[i].Checked then
        inc(lSelectedItemCount);
    end;
    lVariant:= VarArrayCreate([0,lSelectedItemCount],varVariant);
    lSqlstr:= 'delete from columns_user_set t'+
              ' where t.cityid='+inttostr(gPublicParam.cityid)+
              ' and t.userid='+inttostr(gPublicParam.userid)+
              ' and t.devicetype='+inttostr(TGroupParam(lNode.Data).devicetype);
    lVariant[0]:= VarArrayOf([lSqlstr]);
    lSelectedItemCount:= 1;
    for i := 0 to ListView.Items.Count - 1 do
    begin
      if ListView.Items[i].Checked then
      begin
        lSqlstr:= 'insert into columns_user_set (id, cityid, devicetype, userid, colcode, col_order, if_show, colwide) values'+
                  ' (cfms_seq_normal.nextval, '+inttostr(gPublicParam.cityid)+', '+
                  inttostr(TGroupParam(lNode.Data).devicetype)+', '+inttostr(gPublicParam.userid)+', '+
                  inttostr(TcolUserSetParam(ListView.Items[i].Data).COLCODE)+', '+inttostr(i+1)+', null, 80)';
        lVariant[lSelectedItemCount]:= VarArrayOf([lSqlstr]);
        inc(lSelectedItemCount);
      end;
    end;
    lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
    if not lsuccess then
    begin
      MessageBox(handle,Pchar('字段显示信息设置失败!'),'系统提示',MB_ICONWARNING);
      Exit;
    end
    else
      MessageBox(handle,'字段显示信息设置成功!','系统提示',MB_ICONINFORMATION);
  finally

  end;
end;

procedure TFormUserFieldSet.ListViewCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  i:integer;
begin
  i:= (Sender as TListView).Items.IndexOf(Item);
  if odd(i) then (Sender as TListView).Canvas.Brush.Color:=clSkyBlue
  else (Sender as TListView).Canvas.Brush.Color:=clWhite;

  if Item.Data<>nil then
    if TcolUserSetParam(Item.Data).if_show=2 then
      (Sender as TListView).Canvas.Brush.Color:=clred;

  (Sender as TListView).Canvas.FillRect(Item.DisplayRect(drIcon));
end;

procedure TFormUserFieldSet.ListViewDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  SourcItem,DesItem: TListItem;
  IndexSour,IndexDes: Integer;
begin
  SourcItem := ListView.Selected;
  DesItem:=ListView.GetItemAt(x,y);
  if (SourcItem = nil) or (DesItem=nil) then Exit;
  IndexSour:= ListView.Selected.Index;
  IndexDes:= DesItem.Index;
  if IndexDes>IndexSour then
  begin
    while IndexDes>IndexSour do
    begin
      SpeedButton2Click(SpeedButton2);
      Inc(IndexSour);
    end;
  end
  else if IndexDes<IndexSour then
  begin
    while IndexDes<IndexSour do
    begin
      SpeedButton1Click(SpeedButton1);
      IndexSour:=IndexSour-1;
    end;
  end;
end;

procedure TFormUserFieldSet.ListViewDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  //
end;

end.

