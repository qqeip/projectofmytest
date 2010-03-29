unit UnitAssociatorTypeMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls, CxGridUnit, ADODB;

type
  TFormAssociatorTypeMgr = class(TForm)
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EdtAssociatorTypeName: TEdit;
    EdtAssociatorTypeComment: TEdit;
    GroupBox1: TGroupBox;
    cxGridAssociatorType: TcxGrid;
    cxGridAssociatorTypeDBTableView1: TcxGridDBTableView;
    cxGridAssociatorTypeLevel1: TcxGridLevel;
    DataSourceAssociatorType: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure cxGridAssociatorTypeDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    AdoDepotQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;

    procedure AddcxGridViewField;
    procedure LoadAssociatorTypeInfo;
  public
    { Public declarations }
  end;

var
  FormAssociatorTypeMgr: TFormAssociatorTypeMgr;

implementation

uses UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormAssociatorTypeMgr.FormCreate(Sender: TObject);
begin
  AdoDepotQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAssociatorType,true,false,true);
end;

procedure TFormAssociatorTypeMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadAssociatorTypeInfo;
end;

procedure TFormAssociatorTypeMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormAssociatorTypeMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormAssociatorTypeMgr.AddcxGridViewField;
begin
  AddViewField(cxGridAssociatorTypeDBTableView1,'AssociatorTypeID','内部编号');
  AddViewField(cxGridAssociatorTypeDBTableView1,'AssociatorTypeName','会员类型名称', 85);
  AddViewField(cxGridAssociatorTypeDBTableView1,'COMMENT','会员类型说明', 358);
end;

procedure TFormAssociatorTypeMgr.LoadAssociatorTypeInfo;
begin
  with AdoDepotQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select * from AssociatorType';
    Active:= True;
    DataSourceAssociatorType.DataSet:= AdoDepotQuery;
  end;
end;

procedure TFormAssociatorTypeMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtAssociatorTypeName.Text='' then
  begin
    Application.MessageBox('会员类型名称不能为空！','提示',MB_OK+64)
  end;
  try
    IsRecordChanged:= True;
    AdoDepotQuery.Append;
    AdoDepotQuery.FieldByName('AssociatorTypeName').AsString:= EdtAssociatorTypeName.Text;
    AdoDepotQuery.FieldByName('COMMENT').AsString:= EdtAssociatorTypeComment.Text;
    AdoDepotQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormAssociatorTypeMgr.Btn_ModifyClick(Sender: TObject);
begin
  if EdtAssociatorTypeName.Text='' then
  begin
    Application.MessageBox('会员类型名称不能为空！','提示',MB_OK+64)
  end;
  try
    IsRecordChanged:= True;
    AdoDepotQuery.Edit;
    AdoDepotQuery.FieldByName('AssociatorTypeName').AsString:= EdtAssociatorTypeName.Text;
    AdoDepotQuery.FieldByName('COMMENT').AsString:= EdtAssociatorTypeComment.Text;
    AdoDepotQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormAssociatorTypeMgr.Btn_DeleteClick(Sender: TObject);
begin
  try
    IsRecordChanged:= True;
    AdoDepotQuery.Delete;
    IsRecordChanged:= False;
    Application.MessageBox('删除成功！','提示',MB_OK+64);
  except
    Application.MessageBox('删除失败！','提示',MB_OK+64);
  end;
end;

procedure TFormAssociatorTypeMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAssociatorTypeMgr.cxGridAssociatorTypeDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  EdtAssociatorTypeName.Text:= AdoDepotQuery.fieldbyname('AssociatorTypeName').AsString;
  EdtAssociatorTypeComment.Text:= AdoDepotQuery.fieldbyname('COMMENT').AsString;
end;

end.
