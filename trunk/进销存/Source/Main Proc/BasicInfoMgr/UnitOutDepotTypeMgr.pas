unit UnitOutDepotTypeMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls, ADODB, CxGridUnit;

type
  TFormOutDepotTypeMgr = class(TForm)
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EdtOutDepotTypeID: TEdit;
    EdtOutDepotTypeComment: TEdit;
    GroupBox1: TGroupBox;
    cxGridOutDepotType: TcxGrid;
    cxGridOutDepotTypeDBTableView1: TcxGridDBTableView;
    cxGridOutDepotTypeLevel1: TcxGridLevel;
    DataSourceOutDepotType: TDataSource;
    Label3: TLabel;
    EdtOutDepotTypeName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure cxGridOutDepotTypeDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    AdoQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;
    
    procedure AddcxGridViewField;
    procedure LoadOutDepotTypeInfo;
  public
    { Public declarations }
  end;

var
  FormOutDepotTypeMgr: TFormOutDepotTypeMgr;

implementation

uses UnitDataModule, UnitPublic;

{$R *.dfm}

{ TFormOutDepotTypeMgr }

procedure TFormOutDepotTypeMgr.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridOutDepotType,true,false,true);
end;

procedure TFormOutDepotTypeMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadOutDepotTypeInfo;
end;

procedure TFormOutDepotTypeMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormOutDepotTypeMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormOutDepotTypeMgr.AddcxGridViewField;
begin
  AddViewField(cxGridOutDepotTypeDBTableView1,'OutDepotTypeID','出库类型编号',85);
  AddViewField(cxGridOutDepotTypeDBTableView1,'OutDepotTypeNAME','出库类型名称', 85);
  AddViewField(cxGridOutDepotTypeDBTableView1,'COMMENT','出库类型说明', 338);
end;

procedure TFormOutDepotTypeMgr.LoadOutDepotTypeInfo;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select * from OutDepotType order by OutDepotTypeID';
    Active:= True;
    DataSourceOutDepotType.DataSet:= AdoQuery;
  end;
end;

procedure TFormOutDepotTypeMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtOutDepotTypeID.Text='' then
  begin
    Application.MessageBox('出库类型编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtOutDepotTypeName.Text='' then
  begin
    Application.MessageBox('出库类型名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('OutDepotTypeID', 'OutDepotType', EdtOutDepotTypeID.Text) then
  begin
    Application.MessageBox('出库类型编号已存在！','提示',MB_OK+64);
    Exit;
  end;

  try
    IsRecordChanged:= True;
    AdoQuery.Append;
    AdoQuery.FieldByName('OUTDEPOTTYPEID').AsString:= EdtOutDepotTypeID.Text;
    AdoQuery.FieldByName('OUTDEPOTTYPENAME').AsString:= EdtOutDepotTypeName.Text;
    AdoQuery.FieldByName('COMMENT').AsString:= EdtOutDepotTypeComment.Text;
    AdoQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormOutDepotTypeMgr.Btn_ModifyClick(Sender: TObject);
begin
  if EdtOutDepotTypeID.Text='' then
  begin
    Application.MessageBox('出库类型编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtOutDepotTypeName.Text='' then
  begin
    Application.MessageBox('出库类型名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtOutDepotTypeID.Text<> AdoQuery.fieldbyname('OutDepotTypeID').AsString then
    if IsExistID('OutDepotTypeID', 'OutDepotType', EdtOutDepotTypeID.Text) then
    begin
      Application.MessageBox('出库类型编号已存在！','提示',MB_OK+64);
      Exit;
    end;

  try
    IsRecordChanged:= True;
    AdoQuery.Edit;
    AdoQuery.FieldByName('OutDEPOTTYPEID').AsString:= EdtOutDepotTypeID.Text;
    AdoQuery.FieldByName('OutDEPOTTYPENAME').AsString:= EdtOutDepotTypeName.Text;
    AdoQuery.FieldByName('COMMENT').AsString:= EdtOutDepotTypeComment.Text;
    AdoQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormOutDepotTypeMgr.Btn_DeleteClick(Sender: TObject);
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

procedure TFormOutDepotTypeMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormOutDepotTypeMgr.cxGridOutDepotTypeDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  EdtOutDepotTypeID.Text:= AdoQuery.fieldbyname('OutDepotTypeID').AsString;
  EdtOutDepotTypeName.Text:= AdoQuery.fieldbyname('OutDepotTypeName').AsString;
  EdtOutDepotTypeComment.Text:= AdoQuery.fieldbyname('COMMENT').AsString;
end;

end.
