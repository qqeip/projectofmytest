unit UnitDictMgr;
{字典管理：编码分类表(ALARM_DIC_CODE_INFO)、编码类型表(ALARM_DIC_TYPE_INFO)
 编码分类表的内容是根据需求直接写入到数据库中的，
 用户根据编码分类设置编码类型具体值。
 参见：vfms的字典管理模块。
 }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StringUtils, Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, cxTextEdit, cxMaskEdit,
  CxGridUnit, cxDropDownEdit, StdCtrls, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ExtCtrls, cxLabel, Menus,
  cxLookAndFeelPainters, cxButtons, DBClient, jpeg;

type
  TFilterObject = class
    ID : Integer;
    NO : string;
    Name : string;
    Remark  : string;
  end;

type
  TFormDictMgr = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxTextEditName: TcxTextEdit;
    cxLabel3: TcxLabel;
    cxTextEditRemark: TcxTextEdit;
    cxLabel4: TcxLabel;
    cxComboBoxIsIneffect: TcxComboBox;
    cxButtonAdd: TcxButton;
    cxButtonModify: TcxButton;
    cxButtonDel: TcxButton;
    cxComboboxDictType: TcxComboBox;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    Panel4: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxComboboxDictTypePropertiesChange(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    FCxGridHelper : TCxGridSet;
    IsOperateSucc: boolean;
    procedure AddViewField_Dict;
    procedure ShowDict;
    procedure LoadDictType(aItems:TStrings);
    function GetCaptionid(aCaptionName: string; aItems: TStrings): integer;
    function GetMaxDicOrder(aTypeCode,aCityID: Integer):Integer;
    { Private declarations }
  public
    gDictTypeID: Integer;
    { Public declarations }
  end;

var
  FormDictMgr: TFormDictMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormDictMgr.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);
end;

procedure TFormDictMgr.FormShow(Sender: TObject);
begin
  LoadDictType(cxComboboxDictType.Properties.Items);
  AddViewField_Dict;
end;

procedure TFormDictMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormDictMgr,1,'','');
end;

procedure TFormDictMgr.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormDictMgr.cxButtonAddClick(Sender: TObject);
var
  lDicCode, lDicOrder: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if cxTextEditName.Text='' then
  begin
    Application.MessageBox('名称不能为空','提示',MB_OK + 64);
    Exit;
  end;
  if IsExists('ALARM_DIC_CODE_INFO','DICNAME',cxTextEditName.Text) then
  begin
    Application.MessageBox('该名称已经存在!','提示',MB_OK+64);
    Exit;
  end;
  lDicCode:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
  lDicOrder:= GetMaxDicOrder(gDictTypeID,gPublicParam.cityid);
  if lDicOrder=-1 then
  begin
    Application.MessageBox('序号生成错误','提示',MB_OK+64);
    Exit;
  end;
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr:=' insert into ALARM_DIC_CODE_INFO('+
           ' DICCODE,'+
           ' DICTYPE,'+
           ' DICNAME,'+
           ' DICORDER,'+
           ' IFINEFFECT,'+
           ' REMARK,'+
           ' PARENTID,'+
           ' SETVALUE,'+
           ' CITYID)'+
           ' values('+
           IntToStr(lDicCode)+','+
           IntToStr(gDictTypeID)+','''+
           cxTextEditName.Text+''','+
           IntToStr(lDicCode)+','+
           IntToStr(cxComboBoxIsIneffect.ItemIndex)+','''+
           cxTextEditRemark.Text+''','+
           '0'+','+
           'null'+','+
           IntToStr(gPublicParam.cityid)+
           ')';
  lVariant[0]:= VarArrayOf([lSqlStr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('新增成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('DICCODE').AsInteger:= lDicCode;
    ClientDataSet1.FieldByName('DICNAME').AsString:= cxTextEditName.Text;
    ClientDataSet1.FieldByName('REMARK').AsString:= cxTextEditRemark.Text;
    ClientDataSet1.FieldByName('ifineffectname').AsString:= cxComboBoxIsIneffect.Text;
    ClientDataSet1.FieldByName('DICORDER').AsInteger:=lDicCode;
    ClientDataSet1.Post;
    IsOperateSucc:= False;

  end
  else
    Application.MessageBox('新增失败','提示',MB_OK+64);
end;

procedure TFormDictMgr.cxButtonModifyClick(Sender: TObject);
var
  lDicCode: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if cxTextEditName.Text='' then
  begin
    Application.MessageBox('名称不能为空','提示',MB_OK + 64);
    Exit;
  end;
//  if IsExists('ALARM_DIC_CODE_INFO','DICNAME',cxTextEditName.Text) then
//  begin
//    MessageBox(0,'该名称已经存在!','提示',MB_OK+64);
//    Exit;
//  end;
  lDicCode:= ClientDataSet1.fieldbyname('DICCODE').AsInteger;
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr:=' update ALARM_DIC_CODE_INFO set'+
           ' DICNAME='''+ cxTextEditName.Text+''','+
           ' IFINEFFECT='+ IntToStr(cxComboBoxIsIneffect.ItemIndex)+','+
           ' REMARK='''+cxTextEditRemark.Text+''''+
           ' where DICCODE='+inttostr(lDicCode)+
           ' and DICTYPE='+ IntToStr(gDictTypeID)+
           ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lSqlStr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('修改成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Edit;
    ClientDataSet1.FieldByName('DICNAME').AsString:= cxTextEditName.Text;
    ClientDataSet1.FieldByName('REMARK').AsString:= cxTextEditRemark.Text;
    ClientDataSet1.FieldByName('ifineffectname').AsString:= cxComboBoxIsIneffect.Text;
    ClientDataSet1.Post;
    IsOperateSucc:= False;

  end
  else
    Application.MessageBox('修改失败','提示',MB_OK+64);
end;

procedure TFormDictMgr.cxButtonDelClick(Sender: TObject);
var
  lDicCode: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK+64);
    Exit;
  end;
  if Application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;

  lDicCode:= ClientDataSet1.fieldbyname('DICCODE').AsInteger;

  lVariant:= VarArrayCreate([0,0],varVariant);

  lSqlstr:= 'delete from alarm_dic_code_info' +
            ' where DICCODE=' + inttostr(lDicCode) +
            ' and DICTYPE='+ IntToStr(gDictTypeID) +
            ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    Application.MessageBox('删除成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Delete;
    IsOperateSucc:= False;
  end
  else
    Application.MessageBox('删除失败','提示',MB_OK+64);
end;

procedure TFormDictMgr.AddViewField_Dict;
begin
  AddViewField(cxGrid1DBTableView1,'DICCODE','字典编号');
  AddViewField(cxGrid1DBTableView1,'DICNAME','角色名称');
  AddViewField(cxGrid1DBTableView1,'DICORDER','序号');
  AddViewField(cxGrid1DBTableView1,'ifineffectname','是否有效');
  AddViewField(cxGrid1DBTableView1,'REMARK','备注');
end;

procedure TFormDictMgr.ShowDict;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='DataSetProvider';
    Data:= gTempInterface.GetCDSData(VarArrayOf([1,5,gPublicParam.cityid,gDictTypeID]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormDictMgr.LoadDictType(aItems:TStrings);
var
  I : Integer;
  lClientDataSet: TClientDataSet;
  lFilterObject: TFilterObject;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    ClearTStrings(aItems);
    with lClientDataSet do
    begin
      Close;
      ProviderName:='DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,6]),0);
      if IsEmpty then Exit;
      First;
      while not Eof do
      begin
        lFilterObject:= TFilterObject.Create;
        lFilterObject.ID:= fieldbyname('TYPEID').AsInteger;
        lFilterObject.NO:= fieldbyname('TYPECODE').AsString;
        lFilterObject.Name:= fieldbyname('TYPENAME').AsString;
        lFilterObject.Remark:= fieldbyname('REMARK').AsString;
        aItems.AddObject(lFilterObject.Name,lFilterObject);
        Next;
      end;
      Close;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

function TFormDictMgr.GetCaptionid(aCaptionName: string; aItems: TStrings):integer;
var
  i: Integer;
  lFilterObject:TFilterObject;
begin
  result:=-1;
  for i := 0 to aItems.Count - 1 do
  begin
    if aCaptionName=aItems.Strings[i] then
    begin
      lFilterObject:=TFilterObject(aItems.Objects[i]);
      result:=TFilterObject(lFilterObject).id;
    end;
  end;
end;

procedure TFormDictMgr.cxComboboxDictTypePropertiesChange(Sender: TObject);
begin
  gDictTypeID:= GetCaptionid(cxComboboxDictType.Text,cxComboboxDictType.Properties.Items);
  ShowDict;
end;

procedure TFormDictMgr.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsOperateSucc then Exit;
  cxTextEditName.Text:= ClientDataSet1.fieldbyname('DICNAME').AsString;
  cxTextEditRemark.Text:= ClientDataSet1.fieldbyname('REMARK').AsString;
  cxComboBoxIsIneffect.ItemIndex:= ClientDataSet1.fieldbyname('IFINEFFECT').AsInteger;
end;

function TFormDictMgr.GetMaxDicOrder(aTypeCode, aCityID: Integer): Integer;
var
  lClientDataSet: TClientDataSet;
  lsqlstr: string;
begin
  Result:=-1;
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      ProviderName:='DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,8,aTypeCode,aCityID]),0);
      Result:= fieldbyname('maxorder').AsInteger;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

end.

