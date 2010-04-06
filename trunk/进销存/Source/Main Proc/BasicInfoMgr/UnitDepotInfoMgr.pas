unit UnitDepotInfoMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, Buttons, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ExtCtrls, StdCtrls, CxGridUnit, ADODB;

type
  TFormDepotInfoMgr = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    cxGridDepot: TcxGrid;
    cxGridDepotDBTableView1: TcxGridDBTableView;
    cxGridDepotLevel1: TcxGridLevel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    DataSourceDepot: TDataSource;
    LabelDepotID: TLabel;
    Label2: TLabel;
    EdtDepotName: TEdit;
    EdtDepotComment: TEdit;
    EdtDepotID: TEdit;
    LabelDepotName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure cxGridDepotDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    AdoDepotQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;
    
    procedure AddcxGridViewField;
    procedure LoadDepotInfo;
  public
    { Public declarations }
  end;

var
  FormDepotInfoMgr: TFormDepotInfoMgr;

implementation

uses UnitPublic, UnitDataModule;

{$R *.dfm}

procedure TFormDepotInfoMgr.FormCreate(Sender: TObject);
begin
  AdoDepotQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridDepot,true,false,true);
end;

procedure TFormDepotInfoMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormDepotInfoMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadDepotInfo;
end;

procedure TFormDepotInfoMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormDepotInfoMgr.AddcxGridViewField;
begin
  AddViewField(cxGridDepotDBTableView1,'DEPOTID','仓库编号');
  AddViewField(cxGridDepotDBTableView1,'DEPOTNAME','仓库名称');
  AddViewField(cxGridDepotDBTableView1,'COMMENT','仓库说明', 378);
end;

procedure TFormDepotInfoMgr.LoadDepotInfo;
begin
  with AdoDepotQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select * from depot order by depotid';
    Active:= True;
    DataSourceDepot.DataSet:= AdoDepotQuery;
  end;
end;

procedure TFormDepotInfoMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtDepotID.Text='' then
  begin
    Application.MessageBox('仓库编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtDepotName.Text='' then
  begin
    Application.MessageBox('仓库名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('DEPOTID', 'DEPOT', EdtDepotID.Text) then
  begin
    Application.MessageBox('仓库编号已存在！','提示',MB_OK+64);
    Exit;
  end;
//  wit·h AdoDepotEdit do
//  begin
//    Connection:= DM.ADOConnection;
//    Active:= False;
//    SQL.Clear;
//    SQL.Text:= 'insert into depot (DEPOTNAME, COMMENT) values (:DepotName, :Comment)';
//    Parameters.ParamByName('DepotName').Value:=trim(EdtDepotName.Text);
//    Parameters.ParamByName('Comment').Value:=trim(EdtDepotComment.Text);
//    ExecSQL;
//  end;
  try
    IsRecordChanged:= True;
    AdoDepotQuery.Append;
    AdoDepotQuery.FieldByName('DEPOTID').AsInteger:= StrToInt(EdtDepotID.Text);
    AdoDepotQuery.FieldByName('DEPOTNAME').AsString:= EdtDepotName.Text;
    AdoDepotQuery.FieldByName('COMMENT').AsString:= EdtDepotComment.Text;
    AdoDepotQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormDepotInfoMgr.Btn_ModifyClick(Sender: TObject);
begin
  if EdtDepotID.Text='' then
  begin
    Application.MessageBox('仓库编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtDepotName.Text='' then
  begin
    Application.MessageBox('仓库名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtDepotID.Text<> AdoDepotQuery.fieldbyname('DEPOTID').AsString then
    if IsExistID('DEPOTID', 'DEPOT', EdtDepotID.Text) then
    begin
      Application.MessageBox('仓库编号已存在！','提示',MB_OK+64);
      Exit;
    end;

  try
    IsRecordChanged:= True;
    AdoDepotQuery.Edit;
    AdoDepotQuery.FieldByName('DEPOTID').AsString:= EdtDepotID.Text;
    AdoDepotQuery.FieldByName('DEPOTNAME').AsString:= EdtDepotName.Text;
    AdoDepotQuery.FieldByName('COMMENT').AsString:= EdtDepotComment.Text;
    AdoDepotQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormDepotInfoMgr.Btn_DeleteClick(Sender: TObject);
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

procedure TFormDepotInfoMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormDepotInfoMgr.cxGridDepotDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  EdtDepotID.Text:= AdoDepotQuery.fieldbyname('DEPOTID').AsString;
  EdtDepotName.Text:= AdoDepotQuery.fieldbyname('DEPOTNAME').AsString;
  EdtDepotComment.Text:= AdoDepotQuery.fieldbyname('COMMENT').AsString;
end;

end.
