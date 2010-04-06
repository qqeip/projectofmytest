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
    LabelAssociatorTypeID: TLabel;
    Label2: TLabel;
    EdtAssociatorTypeID: TEdit;
    EdtAssociatorTypeComment: TEdit;
    GroupBox1: TGroupBox;
    cxGridAssociatorType: TcxGrid;
    cxGridAssociatorTypeDBTableView1: TcxGridDBTableView;
    cxGridAssociatorTypeLevel1: TcxGridLevel;
    DataSourceAssociatorType: TDataSource;
    EdtAssociatorTypeName: TEdit;
    LabelAssociatorTypeName: TLabel;
    Label1: TLabel;
    EdtDiscount: TEdit;
    Label3: TLabel;
    EdtIntegralRuler: TEdit;
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
    AdoQuery: TAdoquery;
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
  AdoQuery:= TADOQuery.Create(Self);
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
  AddViewField(cxGridAssociatorTypeDBTableView1,'AssociatorTypeID','会员类型编号',85);
  AddViewField(cxGridAssociatorTypeDBTableView1,'AssociatorTypeName','会员类型名称', 85);
  AddViewField(cxGridAssociatorTypeDBTableView1,'Discount','享受折扣');
  AddViewField(cxGridAssociatorTypeDBTableView1,'IntegralRuler','积分规则');
  AddViewField(cxGridAssociatorTypeDBTableView1,'COMMENT','会员类型说明', 208);
end;

procedure TFormAssociatorTypeMgr.LoadAssociatorTypeInfo;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select * from AssociatorType order by AssociatorTypeID';
    Active:= True;
    DataSourceAssociatorType.DataSet:= AdoQuery;
  end;
end;

procedure TFormAssociatorTypeMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtAssociatorTypeID.Text='' then
  begin
    Application.MessageBox('会员类型编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtAssociatorTypeName.Text='' then
  begin
    Application.MessageBox('会员类型名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('AssociatorTypeID', 'AssociatorType', EdtAssociatorTypeID.Text) then
  begin
    Application.MessageBox('会员类型编号已存在！','提示',MB_OK+64);
    Exit;
  end;
  try
    IsRecordChanged:= True;
    AdoQuery.Append;
    AdoQuery.FieldByName('AssociatorTypeID').AsString:= EdtAssociatorTypeID.Text;
    AdoQuery.FieldByName('AssociatorTypeName').AsString:= EdtAssociatorTypeName.Text;
    AdoQuery.FieldByName('Discount').AsString:= EdtDiscount.Text;
    AdoQuery.FieldByName('IntegralRuler').AsInteger:= StrToInt(EdtIntegralRuler.Text);
    AdoQuery.FieldByName('COMMENT').AsString:= EdtAssociatorTypeComment.Text;
    AdoQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormAssociatorTypeMgr.Btn_ModifyClick(Sender: TObject);
begin
  if EdtAssociatorTypeID.Text='' then
  begin
    Application.MessageBox('会员类型编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtAssociatorTypeName.Text='' then
  begin
    Application.MessageBox('会员类型名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtAssociatorTypeID.Text<> AdoQuery.fieldbyname('AssociatorTypeID').AsString then
    if IsExistID('AssociatorTypeID', 'AssociatorType', EdtAssociatorTypeID.Text) then
    begin
      Application.MessageBox('仓库编号已存在！','提示',MB_OK+64);
      Exit;
    end;
  try
    IsRecordChanged:= True;
    AdoQuery.Edit;
    AdoQuery.FieldByName('AssociatorTypeID').AsString:= EdtAssociatorTypeID.Text;
    AdoQuery.FieldByName('AssociatorTypeName').AsString:= EdtAssociatorTypeName.Text;
    AdoQuery.FieldByName('Discount').AsString:= EdtDiscount.Text;
    AdoQuery.FieldByName('IntegralRuler').AsInteger:= StrToInt(EdtIntegralRuler.Text);
    AdoQuery.FieldByName('COMMENT').AsString:= EdtAssociatorTypeComment.Text;
    AdoQuery.Post;
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
    AdoQuery.Delete;
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
  EdtAssociatorTypeID.Text:= AdoQuery.fieldbyname('AssociatorTypeID').AsString;
  EdtAssociatorTypeName.Text:= AdoQuery.fieldbyname('AssociatorTypeName').AsString;
  EdtDiscount.Text:= AdoQuery.FieldByName('Discount').AsString;
  EdtIntegralRuler.Text:= IntToStr(AdoQuery.FieldByName('IntegralRuler').AsInteger);
  EdtAssociatorTypeComment.Text:= AdoQuery.fieldbyname('COMMENT').AsString;
end;

end.
