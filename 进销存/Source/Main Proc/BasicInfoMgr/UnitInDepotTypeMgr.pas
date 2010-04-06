unit UnitInDepotTypeMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls, ADODB, CxGridUnit;

type
  TFormInDepotTypeMgr = class(TForm)
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EdtInDepotTypeID: TEdit;
    EdtInDepotTypeComment: TEdit;
    GroupBox1: TGroupBox;
    cxGridInDepotType: TcxGrid;
    cxGridInDepotTypeDBTableView1: TcxGridDBTableView;
    cxGridInDepotTypeLevel1: TcxGridLevel;
    DataSourceInDepotType: TDataSource;
    Label3: TLabel;
    EdtInDepotTypeName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure cxGridInDepotTypeDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    AdoQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;
    procedure AddcxGridViewField;
    procedure LoadInDepotTypeInfo;
  public
    { Public declarations }
  end;

var
  FormInDepotTypeMgr: TFormInDepotTypeMgr;

implementation

uses UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormInDepotTypeMgr.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridInDepotType,true,false,true);
end;

procedure TFormInDepotTypeMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadInDepotTypeInfo;
end;

procedure TFormInDepotTypeMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormInDepotTypeMgr.AddcxGridViewField;
begin
  AddViewField(cxGridInDepotTypeDBTableView1,'InDepotTypeID','入库类型编号',85);
  AddViewField(cxGridInDepotTypeDBTableView1,'InDepotTypeNAME','入库类型名称', 85);
  AddViewField(cxGridInDepotTypeDBTableView1,'COMMENT','入库类型说明', 338);
end;

procedure TFormInDepotTypeMgr.LoadInDepotTypeInfo;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select * from InDepotType order by InDepotTypeID';
    Active:= True;
    DataSourceInDepotType.DataSet:= AdoQuery;
  end;
end;

procedure TFormInDepotTypeMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtInDepotTypeID.Text='' then
  begin
    Application.MessageBox('入库类型编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtInDepotTypeName.Text='' then
  begin
    Application.MessageBox('入库类型名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('InDepotTypeID', 'InDepotType', EdtInDepotTypeID.Text) then
  begin
    Application.MessageBox('入库类型编号已存在！','提示',MB_OK+64);
    Exit;
  end;

  try
    IsRecordChanged:= True;
    AdoQuery.Append;
    AdoQuery.FieldByName('INDEPOTTYPEID').AsString:= EdtInDepotTypeID.Text;
    AdoQuery.FieldByName('INDEPOTTYPENAME').AsString:= EdtInDepotTypeName.Text;
    AdoQuery.FieldByName('COMMENT').AsString:= EdtInDepotTypeComment.Text;
    AdoQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormInDepotTypeMgr.Btn_ModifyClick(Sender: TObject);
begin
  if EdtInDepotTypeID.Text='' then
  begin
    Application.MessageBox('入库类型编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtInDepotTypeName.Text='' then
  begin
    Application.MessageBox('入库类型名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtInDepotTypeID.Text<> AdoQuery.fieldbyname('InDepotTypeID').AsString then
    if IsExistID('InDepotTypeID', 'InDepotType', EdtInDepotTypeID.Text) then
    begin
      Application.MessageBox('入库类型编号已存在！','提示',MB_OK+64);
      Exit;
    end;

  try
    IsRecordChanged:= True;
    AdoQuery.Edit;
    AdoQuery.FieldByName('INDEPOTTYPEID').AsString:= EdtInDepotTypeID.Text;
    AdoQuery.FieldByName('INDEPOTTYPENAME').AsString:= EdtInDepotTypeName.Text;
    AdoQuery.FieldByName('COMMENT').AsString:= EdtInDepotTypeComment.Text;
    AdoQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormInDepotTypeMgr.Btn_DeleteClick(Sender: TObject);
begin
  try
    IsRecordChanged:= True;
    AdoQuery.Delete;
    IsRecordChanged:= False;
    Application.MessageBox('删除成功！','提示',MB_OK+64);
  except
    Application.MessageBox('删除失败！','提示',MB_OK+64);
  end;
end;

procedure TFormInDepotTypeMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormInDepotTypeMgr.cxGridInDepotTypeDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  EdtInDepotTypeID.Text:= AdoQuery.fieldbyname('InDepotTypeID').AsString;
  EdtInDepotTypeName.Text:= AdoQuery.fieldbyname('InDepotTypeName').AsString;
  EdtInDepotTypeComment.Text:= AdoQuery.fieldbyname('COMMENT').AsString;
end;

end.
