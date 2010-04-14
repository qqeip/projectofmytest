unit Ut_DataDicMag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, BaseGrid, AdvGrid, AdvGridUnit,
  Ut_common,DBClient;

type
  TFm_DataDicMag = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    AdvGrid_DDtable: TAdvStringGrid;
    Label1: TLabel;
    Cmb_DDType: TComboBox;
    Label2: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Edt_name: TEdit;
    Edt_remark: TEdit;
    Cmb_effect: TComboBox;
    Btn_Add: TButton;
    Btn_Modify: TButton;
    Btn_Del: TButton;
    Btn_Quit: TButton;
    Btn_Clear: TButton;
    procedure Btn_QuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Cmb_DDTypeChange(Sender: TObject);
    procedure AdvGrid_DDtableSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Btn_ClearClick(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DelClick(Sender: TObject);
  private
    { Private declarations }
    AdvGridset:TAdvGridset;
    procedure InitComboBox;
    procedure ClearText;
    procedure LoadDataDic;
    function  FindRepeatForAdd(Textname:String):Boolean;
    function  FindRepeatForModify(Textname:String):Boolean;
    procedure AdvStringGridInit; //初始化，好看些
  public
    { Public declarations }
    DICCodeID:integer;
    Index:Integer;
  end;

var
  Fm_DataDicMag: TFm_DataDicMag;

implementation

Uses Ut_DataModule;
{$R *.dfm}

procedure TFm_DataDicMag.AdvGrid_DDtableSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ARow<1 then exit;
  DICCodeID:=StrToIntDef(Trim(AdvGrid_DDtable.Rows[Arow].Strings[1]),-1);
  if DICCodeID=-1 then exit;

  Edt_name.Text:=Trim(AdvGrid_DDtable.Rows[Arow].Strings[2]);
  if AdvGrid_DDtable.Rows[Arow].Strings[4]='否' then
  Cmb_effect.ItemIndex:=0
  else
  Cmb_effect.ItemIndex:=1;
  Edt_remark.Text:=Trim(AdvGrid_DDtable.Rows[Arow].Strings[5]);
end;

procedure TFm_DataDicMag.AdvStringGridInit;
begin
  AdvGrid_DDtable.Cells[1,0]:='资料编号';
  AdvGrid_DDtable.Cells[2,0]:='资料名称';
  AdvGrid_DDtable.Cells[3,0]:='资料序号';
  AdvGrid_DDtable.Cells[4,0]:='是否有效';
  AdvGrid_DDtable.Cells[5,0]:='资料解释';
  AdvGrid_DDtable.Rows[1].Text:='';
end;

procedure TFm_DataDicMag.Btn_AddClick(Sender: TObject);
Var
  dic_type:Integer;
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;  
begin
  if Cmb_DDType.ItemIndex=-1 then Exit;
  if Edt_name.Text='' then
  begin
  Application.MessageBox('请填写资料名称！','信息',MB_ICONINFORMATION+MB_OK) ;
  exit;
  end;
  if FindRepeatForAdd(trim(Edt_name.Text)) then
  begin
  Application.MessageBox('资料名称重复，请检查后重试！','信息',MB_ICONINFORMATION+MB_OK) ;
  exit;
  end;

  dic_type:=GetNewDicCode(Index);
  if dic_type=-1 then Exit;

  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,14]),0);
    Append;
    FieldByName('diccode').Value :=dic_type;
    FieldByName('dictype').Value :=Index;
    FieldByName('dicname').Value :=trim(Edt_name.Text);
    FieldByName('parentid').Value :=0;
    FieldByName('DicOrder').Value :=dic_type;
    FieldByName('IfInEffect').Value :=Cmb_effect.ItemIndex;
    FieldByName('remark').Value :=trim(Edt_remark.Text);
    Post;
     try
       vCDSArray[0]:=Dm_MTS.cds_common;
       vDeltaArray:=RetrieveDeltas(vCDSArray);
       vProviderArray:=RetrieveProviders(vCDSArray);
       if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;

        LoadDataDic;//刷新AdvstringGrid
        DICCodeID:=0;
        application.MessageBox('添加成功！', '提示', mb_ok + mb_defbutton1);
     except
        application.MessageBox('添加失败！', '提示', mb_ok + mb_defbutton1);
     end;
  end;

end;

procedure TFm_DataDicMag.Btn_ClearClick(Sender: TObject);
begin
  ClearText;
end;

procedure TFm_DataDicMag.Btn_DelClick(Sender: TObject);
Var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if Cmb_DDType.ItemIndex=-1 then Exit;
  if (DICCodeID=-1) or (DICCodeID=0) then exit;   //对应某条选中的资料

  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,15,DICCodeID,Index]),0);
    Delete;
     try
       vCDSArray[0]:=Dm_MTS.cds_common;
       vDeltaArray:=RetrieveDeltas(vCDSArray);
       vProviderArray:=RetrieveProviders(vCDSArray);
       if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;

        LoadDataDic;//刷新AdvstringGrid
        DICCodeID:=0;
        application.MessageBox('删除成功！', '提示', mb_ok + mb_defbutton1);
     except
        application.MessageBox('删除失败！', '提示', mb_ok + mb_defbutton1);
     end;
  end;

end;

procedure TFm_DataDicMag.Btn_ModifyClick(Sender: TObject);
Var
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..0] of TClientDataset;
begin
  if Cmb_DDType.ItemIndex=-1 then Exit;
  if (DICCodeID=-1) or (DICCodeID=0) then exit;  //对应某条选中的资料
  if Edt_name.Text='' then
  begin
  Application.MessageBox('请填写资料名称！','信息',MB_ICONINFORMATION+MB_OK) ;
  exit;
  end;
  if FindRepeatForModify(trim(Edt_name.Text)) then
  begin
  Application.MessageBox('资料名称重复，请检查后重试！','信息',MB_ICONINFORMATION+MB_OK) ;
  exit;
  end;
  
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,15,DICCodeID,Index]),0);
    Edit;
    //FieldByName('diccode').Value :=DICCodeID;
    //FieldByName('dictype').Value :=Index;
    FieldByName('dicname').Value :=trim(Edt_name.Text);
    //FieldByName('parentid').Value :=0;
    //FieldByName('DicOrder').Value :=dic_type;
    FieldByName('IfInEffect').Value :=Cmb_effect.ItemIndex;
    FieldByName('remark').Value :=trim(Edt_remark.Text);
    Post;
     try
       vCDSArray[0]:=Dm_MTS.cds_common;
       vDeltaArray:=RetrieveDeltas(vCDSArray);
       vProviderArray:=RetrieveProviders(vCDSArray);
       if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
         SysUtils.Abort;

        LoadDataDic;//刷新AdvstringGrid
        DICCodeID:=0;
        application.MessageBox('修改成功！', '提示', mb_ok + mb_defbutton1);
     except
        application.MessageBox('修改失败！', '提示', mb_ok + mb_defbutton1);
     end;
  end;
end;

procedure TFm_DataDicMag.Btn_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFm_DataDicMag.ClearText;
begin
  Edt_name.Text:='';
  Cmb_effect.ItemIndex:=1;
  Edt_remark.Text:='';
end;

procedure TFm_DataDicMag.Cmb_DDTypeChange(Sender: TObject);
begin
  AdvGrid_DDtable.Clear;
  AdvStringGridInit;
  Index:=TCommonObj(Cmb_DDType.Items.Objects[Cmb_DDType.ItemIndex]).ID;
  LoadDataDic;
  DICCodeID:=0;
end;

function TFm_DataDicMag.FindRepeatForAdd(Textname: String): Boolean;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,13,Index,Textname]),0);
    if RecordCount >0 then
    result:=true
    else
    result:=false;
  end;
end;

function TFm_DataDicMag.FindRepeatForModify(Textname: String): Boolean;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,16,DICCodeID,Index,Textname]),0);
    if RecordCount >0 then
    result:=true
    else
    result:=false;
  end;
end;

procedure TFm_DataDicMag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(AdvGridSet);
end;

procedure TFm_DataDicMag.FormCreate(Sender: TObject);
begin
  AdvGridset:=TAdvGridset.Create;
  AdvGridset.AddGrid(AdvGrid_DDtable);
  AdvGridset.SetGridStyle;
end;

procedure TFm_DataDicMag.FormShow(Sender: TObject);
begin
  InitComboBox;
  DICCodeID:=0;
  Index:=0;
  AdvStringGridInit;
end;

procedure TFm_DataDicMag.InitComboBox;
var
  obj :TCommonObj;
begin
  Cmb_DDType.Items.Clear;
  With Dm_Mts.cds_common do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,8]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('typeid').AsInteger;
      obj.Name := FieldByName('typename').AsString;
      Cmb_DDType.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

procedure TFm_DataDicMag.LoadDataDic;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,9,Index]),0);
    if RecordCount >0 then
    begin
    AdvGridset.DrawGrid(Dm_MTS.cds_common,AdvGrid_DDtable);
    end;
  end;
end;

end.
