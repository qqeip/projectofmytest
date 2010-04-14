unit Ut_TestParamSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, BaseGrid, AdvGrid,AdvGridUnit,
  DBClient,Ut_Common,DB, Buttons, ComCtrls, CheckLst;

type
  TFm_TestParamSet = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Cmb_CmdName: TComboBox;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    Panel3: TPanel;
    Btn_OK: TButton;
    Btn_Quit: TButton;
    AdvGrid_PValue: TAdvStringGrid;
    Panel4: TPanel;
    Button1: TButton;
    clb_cmd: TCheckListBox;
    SpeedButton1: TSpeedButton;
    ListView: TListView;
    Button2: TButton;
    Label2: TLabel;
    procedure Btn_QuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure AdvGrid_PValueCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure Cmb_CmdNameChange(Sender: TObject);
    procedure Btn_OKClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ListViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
  private
    { Private declarations }
    CmdItem :TStrings;
    AdvGridset:TAdvGridset;
    procedure AdvStringGridInit; //初始化，好看些
    procedure InitComboBox;
    procedure ShowParameter;
    procedure ShowAutoCommand;  
  public
    { Public declarations }
    Com_ID:Integer;
  end;

var
  Fm_TestParamSet: TFm_TestParamSet;

implementation

Uses Ut_DataModule;
{$R *.dfm}

procedure TFm_TestParamSet.AdvGrid_PValueCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  if Acol =4 then
    CanEdit := true
  else
    CanEdit :=false;
end;

procedure TFm_TestParamSet.AdvStringGridInit;
begin
  AdvGrid_PValue.Cells[1,0]:='命令编号';
  AdvGrid_PValue.Cells[2,0]:='参数名称';
  AdvGrid_PValue.Cells[3,0]:='参数编号';
  AdvGrid_PValue.Cells[4,0]:='参数值';
  AdvGrid_PValue.Rows[1].Text:='';
end;

procedure TFm_TestParamSet.Btn_OKClick(Sender: TObject);
Var

  I,J:Integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin

  if AdvGrid_PValue.Cells[1,1]='' then
    begin
      for i := 1 to AdvGrid_PValue.RowCount - 1 do
      begin
      AdvGrid_PValue.Cells[4,i]:='';
      end;
    Exit;
    end;

  for I := 1 to AdvGrid_PValue.RowCount-1 do
  begin
    if AdvGrid_PValue.Cells[4,I]='' then
      begin
      Application.MessageBox('参数值不能为空！','信息',MB_ICONINFORMATION+MB_OK);
      Exit;
      end;
    if Length(WideString(AdvGrid_PValue.Cells[4,I])) <> Length(AdvGrid_PValue.Cells[4,I]) then
      begin
      Application.MessageBox('参数值不能含有汉字！','信息',MB_ICONINFORMATION+MB_OK);
      AdvGrid_PValue.Cells[4,I]:='';
      Exit;
      end;
  end;

     with Dm_MTS.cds_common do
     begin
        Close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,33,Com_ID]),0);
        if recordcount<=0 then
          begin
            for I := 1 to AdvGrid_PValue.RowCount-1 do
            begin
              Append;
              FieldByName('comid').Value :=strtoint(AdvGrid_PValue.Cells[1,I]);
              FieldByName('paramid').Value :=strtoint(AdvGrid_PValue.Cells[3,I]);;
              FieldByName('paramvalue').Value :=AdvGrid_PValue.Cells[4,I];
              Post;
            end;
          end
        else
          begin
            for J := 1 to AdvGrid_PValue.RowCount-1 do
            if locate('paramid',strtoint(AdvGrid_PValue.Cells[3,J]),[loCaseInsensitive,loPartialKey]) then //定位记录
            begin
              Edit;
              FieldByName('paramvalue').Value :=AdvGrid_PValue.Cells[4,J];
              Post;
            end;
          end;
     end;

   try
     vCDSArray[0]:=Dm_MTS.cds_common;
     vDeltaArray:=RetrieveDeltas(vCDSArray);
     vProviderArray:=RetrieveProviders(vCDSArray);
     if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
       SysUtils.Abort;
      ShowParameter;//刷新AdvstringGrid
      application.MessageBox('参数保存成功！', '提示', mb_ok + mb_defbutton1);
   except
      application.MessageBox('参数保存失败！', '提示', mb_ok + mb_defbutton1);
   end;
end;

procedure TFm_TestParamSet.Btn_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFm_TestParamSet.Button1Click(Sender: TObject);
Var
  I,J:Integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,44]),0);
    first;
    while Not Eof do
    begin
      delete;
    end;
    if ListView.Items.Count > 0 then
      for i := 0 to ListView.Items.Count-1 do
      begin
        Append;
        FieldByName('comid').AsInteger :=TCommonObj(ListView.Items[i].Data).ID;
        FieldByName('orderid').AsInteger :=i+1;
        Post;
      end;
    try
       vCDSArray[0]:=Dm_MTS.cds_common;
       vDeltaArray:=RetrieveDeltas(vCDSArray);
       vProviderArray:=RetrieveProviders(vCDSArray);
       if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;
        application.MessageBox('保存成功！', '提示', mb_ok + mb_defbutton1);
    except
        application.MessageBox('保存失败！', '提示', mb_ok + mb_defbutton1);
    end;
  end;

end;

procedure TFm_TestParamSet.Cmb_CmdNameChange(Sender: TObject);
begin
  AdvGrid_PValue.Clear;
  AdvStringGridInit;
  Com_ID:=TCommonObj(Cmb_CmdName.Items.Objects[Cmb_CmdName.ItemIndex]).ID;
  ShowParameter;
end;

procedure TFm_TestParamSet.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i : integer;
begin
  for i := CmdItem.Count-1 downto 0 do
  begin
    cmdItem.Objects[i].Free;
    CmdItem.Delete(i);
  end;
    
  FreeAndNil(AdvGridSet);
end;

procedure TFm_TestParamSet.FormCreate(Sender: TObject);
begin
  AdvGridset:=TAdvGridset.Create;
  AdvGridset.AddGrid(AdvGrid_PValue);
  AdvGridset.SetGridStyle;
  CmdItem :=TStringList.Create;
end;

procedure TFm_TestParamSet.FormShow(Sender: TObject);
begin
  AdvStringGridInit;
  InitComboBox;
  ShowAutoCommand;
end;

procedure TFm_TestParamSet.InitComboBox;
var
  obj :TCommonObj;
begin
  With Dm_Mts.cds_common do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,32]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('comid').AsInteger;
      obj.Name := FieldByName('comname').AsString;
      CmdItem.AddObject(obj.Name,obj);
      Next;
    end;
    Close;
  end;
  Cmb_CmdName.Items :=CmdItem;
  clb_cmd.Items :=CmdItem;
end;

procedure TFm_TestParamSet.ListViewDblClick(Sender: TObject);
var
  i,Idx :integer;
begin
  if TListView(Sender).Selected <> nil then
  begin
    Idx := TListView(Sender).Selected.Index;
    TListView(Sender).Selected.Delete;
    for i := Idx to TListView(Sender).Items.Count - 1 do
      TListView(Sender).Items[i].Caption :=IntToStr(i+1);
  end;
end;

procedure TFm_TestParamSet.ListViewDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
   listitem:Tlistitem;
   orderNum:string;
begin
   listitem:=listview.GetItemAt(x,y);
   if listitem=nil then exit;
   orderNum:=listitem.Caption;
   listitem.Caption:=listview.Selected.Caption;
   listview.Selected.Caption:=orderNum;
   //TCommonObj(listitem.Data).order:=listitem.Index+1;
   //TCommonObj(listview.Selected.Data).order:=listview.Selected.Index+1;

end;
procedure TFm_TestParamSet.ListViewDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := true;
end;

procedure TFm_TestParamSet.ShowAutoCommand;
var
  i,j:integer;
  listitem:Tlistitem;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,51]),0);
    if RecordCount >0 then
    begin
      first;
      j :=1;
      while not eof do
      begin
        with clb_cmd do
        begin
          for i:=0 to Items.Count-1 do
          if (TCommonObj(Items.Objects[i]).ID = FieldbyName('comid').AsInteger) then
          begin
             listitem:=listview.items.Add;
             listitem.Data:=Items.Objects[i];
             listitem.Caption:=format('%d',[j]);
             listitem.SubItems.Add(TCommonObj(Items.Objects[i]).Name);
             Checked[i] := true;
          end;
        end;
        Next;
        Inc(j);
      end;
    end;
    Close;
  end;
end;


procedure TFm_TestParamSet.ShowParameter;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,31,Com_ID]),0);
    if RecordCount >0 then
    begin
    AdvGridset.DrawGrid(Dm_MTS.cds_common,AdvGrid_PValue);
    end
    else
    begin
    AdvGrid_PValue.Clear;
    AdvStringGridInit;
    end;
  end;
end;

procedure TFm_TestParamSet.SpeedButton1Click(Sender: TObject);
var
  i:integer;
  listitem:Tlistitem;
begin
   with ListView do
   begin
     Items.Clear;
     SortType:=stNone;
     with clb_cmd do
     begin
       for i:=0 to Items.Count-1 do
       if Checked[i] then
       begin
          listitem:=listview.items.Add;
          listitem.Data:=clb_cmd.Items.Objects[i];
          listitem.Caption:=format('%d',[TCommonObj(Items.Objects[i]).ID]);
          listitem.SubItems.Add(TCommonObj(Items.Objects[i]).Name);
          //listitem.SubItems[0] :=TCommonObj(Items.Objects[i]).Name;
       end;
     end;
     SortType:=stText;
     SortType:=stNone;
     for i:=0 to Items.Count-1 do
        Items[i].Caption:=format('%d',[Items[i].Index+1]);
     SortType:=stText;
   end;
end;

end.
