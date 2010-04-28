unit UnitDBVerticalGridEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, cxStyles, cxGraphics, cxEdit, cxControls,
  cxInplaceContainer, cxVGrid, cxDBVGrid, WdInspectorWrapper, DBClient, DB;

type
  TFrameDBVerticalGridEditor = class(TFrame)
    GroupBox1: TGroupBox;
    cxDBVerticalGrid: TcxDBVerticalGrid;
    DataSource: TDataSource;
  private
    { Private declarations }
    gWdInspectorWrapper:TWdInspectorWrapper;
    FFieldGroup : integer;
    FTitle: String;
    gClientDataSet: TClientDataSet;

    procedure AddEidtorRow(Parent: TcxCustomRow;RowName,RowCaption:string;Optional:boolean);
    procedure AddCategory(Parent: TcxCustomRow;CategoryID:integer;CategoryName:string;aFieldGroup,aCityid,aUserid:integer);
    procedure SetFieldGroup(const Value: integer);
    procedure SetTitle(const Value: String);
  public
    { Public declarations }
    //初始化
    procedure IniFrameDevice;
    //释放
    procedure DestroyFrameDevice;
    //加载字段 所有字段不可编辑
    procedure LoadFields(aFieldGroup,aCityid,aUserid:integer);
    function LoadDeviceInfo(aCityid, aUserid, aFieldGroup, aDeviceid: integer): boolean;
  published
    property Title : String read FTitle write SetTitle;
    property FieldGroup : integer read FFieldGroup write SetFieldGroup;
  end;

implementation

uses UnitDllCommon;

{$R *.dfm}

{ TFrameDBVerticalGridEditor }

procedure TFrameDBVerticalGridEditor.AddCategory(Parent: TcxCustomRow;
  CategoryID: integer; CategoryName: string; aFieldGroup, aCityid,
  aUserid: integer);
var
  lcxCustomRow:TcxCustomRow;
  lOptional:boolean;
  lid: integer;
  lGroupName:string;
  lClientDataSet, lClientDataSet2: TClientDataSet;
  lSqlstr: string;
begin
  lcxCustomRow:=nil;
  if CategoryID<>-1 then
    lcxCustomRow:=gWdInspectorWrapper.AddCategoryRow(Parent,CategoryName);
  //添加child category
  lClientDataSet:= TClientDataSet.Create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select * from columngroup where device_type='+IntToStr(aFieldGroup)+
              ' and Parent_id='+IntToStr(CategoryID)+' and cityid='+IntToStr(aCityid)+' order by id';
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    while not eof do
    begin
      lid:= FieldByName('ID').AsInteger;
      lGroupName:= FieldByName('GROUP_NAME').AsString;
      AddCategory(lcxCustomRow,lid,lGroupName,aFieldGroup,aCityid,aUserid);
      next;
    end;
  end;
  lClientDataSet.Free;
  //添加field
  lClientDataSet2:= TClientDataSet.Create(nil);
  with lClientDataSet2 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select id from columns_user_set where devicetype='+IntToStr(aFieldGroup)+
              ' and userid='+IntToStr(aUserid)+' and cityid='+IntToStr(aCityid);
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    if recordcount>0 then
    begin
      Close;
      ProviderName:='dsp_General_data';
      lSqlstr:= 'select t3.id,t3.col_name_eng,t3.col_name_cn,t3.ismust'+
                ' from columns_user_set t1,columngroup_set t2,columncoment t3'+
                ' where t1.colcode=t2.colcode and t2.colcode=t3.id and t2.group_code='+IntToStr(CategoryID)+
                ' and t1.userid='+IntToStr(aUserid)+' and t1.cityid='+IntToStr(aCityid)+' order by t1.col_order';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    end
    else
    begin
      Close;
      ProviderName:='dsp_General_data';
      lSqlstr:= 'select t3.id,t3.col_name_eng,t3.col_name_cn,t3.ismust'+
                ' from columngroup_set t2,columncoment t3'+
                ' where t2.colcode=t3.id and t2.group_code='+IntToStr(CategoryID)+' and t2.cityid='+IntToStr(aCityid);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    end;

    first;
    while not eof do
    begin
      AddEidtorRow(lcxCustomRow,FieldbyName('col_name_eng').AsString,FieldbyName('col_name_cn').AsString,lOptional);
      next;
    end;
  end;
  lClientDataSet2.Free;
end;

procedure TFrameDBVerticalGridEditor.AddEidtorRow(Parent: TcxCustomRow;
  RowName, RowCaption: string; Optional: boolean);
var
  lcxEditorRow:TcxDBEditorRow;
begin
  lcxEditorRow := nil;
  lcxEditorRow := gWdInspectorWrapper.AddEditorRow(Parent,RowCaption,RowName);
  lcxEditorRow.Properties.EditProperties.ReadOnly:=true;
  if lcxEditorRow<>nil then
    lcxEditorRow.Properties.DataBinding.FieldName:=RowName;
end;

procedure TFrameDBVerticalGridEditor.DestroyFrameDevice;
begin
  gClientDataSet.Free;
  gWdInspectorWrapper.Free;
end;

procedure TFrameDBVerticalGridEditor.IniFrameDevice;
begin
  gWdInspectorWrapper:=TWdInspectorWrapper.Create;
  gWdInspectorWrapper.cxVerticalGrid:= cxDBVerticalGrid;
  gWdInspectorWrapper.SetStyle;
  gClientDataSet:= TClientDataSet.Create(nil);

  self.FFieldGroup := -1;
end;

function TFrameDBVerticalGridEditor.LoadDeviceInfo(aCityid, aUserid,
  aFieldGroup, aDeviceid: integer): boolean;
var
  lSqlStr: string;
begin
  case aFieldGroup of
    22: begin
          lSqlStr:= 'select * from fms_device_info_view a where a.btsid='+inttostr(aDeviceid);
        end;
  end;
  with gClientDataSet do
  begin
    ProviderName:='dsp_General_data';
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
  end;
  cxDBVerticalGrid.DataController.DataSource.DataSet:=gClientDataSet;
end;

procedure TFrameDBVerticalGridEditor.LoadFields(aFieldGroup, aCityid,
  aUserid: integer);
begin
  cxDBVerticalGrid.BeginUpdate;
  cxDBVerticalGrid.ClearRows;
  AddCategory(nil,-1,'',aFieldGroup,aCityid,aUserid);
  cxDBVerticalGrid.EndUpdate;
end;

procedure TFrameDBVerticalGridEditor.SetFieldGroup(const Value: integer);
begin
  FFieldGroup := Value;
end;

procedure TFrameDBVerticalGridEditor.SetTitle(const Value: String);
begin
  FTitle := Value;
end;

end.
