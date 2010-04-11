unit UnitInDepotMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls, CxGridUnit, ADODB;

type
  TFormInDepotMgr = class(TForm)
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    cxGridInDepot: TcxGrid;
    cxGridInDepotDBTableView1: TcxGridDBTableView;
    cxGridInDepotLevel1: TcxGridLevel;
    Label1: TLabel;
    CbbDepot: TComboBox;
    Label3: TLabel;
    CbbGoodsType: TComboBox;
    Label4: TLabel;
    CbbInDepotType: TComboBox;
    Btn_Print: TSpeedButton;
    Btn_Calc: TSpeedButton;
    Label2: TLabel;
    EdtNum: TEdit;
    DataSourceInDeopt: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
    procedure Btn_CalcClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure EdtNumKeyPress(Sender: TObject; var Key: Char);
    procedure cxGridInDepotDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    AdoQuery, AdoEdit: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;

    procedure AddcxGridViewField;
    procedure LoadInDepotInfo;
  public
    { Public declarations }
  end;

var
  FormInDepotMgr: TFormInDepotMgr;

implementation

uses UnitMain, UnitPublic, UnitDataModule, UnitPublicResourceManager;

{$R *.dfm}

procedure TFormInDepotMgr.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  AdoEdit:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridInDepot,true,false,true);
  SetItemCode('Depot', 'DepotID', 'DepotName', '', CbbDepot.Items);
  SetItemCode('Goods', 'GoodsID', 'GoodsName', '', CbbGoodsType.Items);
  SetItemCode('InDepotType', 'InDepotTypeID', 'InDepotTypeName', ' where InDepotTypeID<>1004', CbbInDepotType.Items);
end;

procedure TFormInDepotMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadInDepotInfo;
end;

procedure TFormInDepotMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormInDepotMgr);
//  Action:= caFree;
end;

procedure TFormInDepotMgr.FormDestroy(Sender: TObject);
begin
  FormInDepotMgr:= nil;
end;

procedure TFormInDepotMgr.Btn_AddClick(Sender: TObject);
begin
  if CbbDepot.ItemIndex=-1 then
  begin
    Application.MessageBox('����ѡ�����ֿ⣡','��ʾ',MB_OK+64);
    Exit;
  end;
  if CbbGoodsType.ItemIndex=-1 then
  begin
    Application.MessageBox('����ѡ����Ʒ���ͣ�','��ʾ',MB_OK+64);
    Exit;
  end;
  if CbbInDepotType.ItemIndex=-1 then
  begin
    Application.MessageBox('����ѡ��������ͣ�','��ʾ',MB_OK+64);
    Exit;
  end;
  try
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into InDepot(' +
                 'DepotID,GoodsID, UserID, InDepotTypeID, InDepotNum, CreateTime) ' +
                 'values(' +
                 IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items)) + ',' +
                 IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items)) + ',' +
                 IntToStr(CurUser.UserID) + ',' +
                 IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items)) + ',' +
                 EdtNum.Text + ',' +
                 'cdate(''' + DateTimeToStr(Now) + ''')' +
                 ')';

      {SQL.Text:= 'insert into InDepot(' +
                 'DepotID,GoodsID, UserID, InDepotTypeID, InDepotNum, CreateTime) ' +
                 'values(:DepotID,:GoodsID,:UserID,:InDepotTypeID,:InDepotNum,:CreateTime)';
      Parameters.ParamByName('DepotID').DataType:= ftInteger;
      Parameters.ParamByName('DepotID').Direction:=pdInput;
      Parameters.ParamByName('GoodsID').DataType:= ftInteger;
      Parameters.ParamByName('UserID').DataType:= ftInteger;
      Parameters.ParamByName('InDepotTypeID').DataType:= ftInteger;
      Parameters.ParamByName('InDepotNum').DataType:= ftString;
      Parameters.ParamByName('CreateTime').DataType:= ftDateTime;

      Parameters.ParamByName('DepotID').Value:= GetItemCode(CbbDepot.Text, CbbDepot.Items);
      Parameters.ParamByName('GoodsID').Value:= GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items);
      Parameters.ParamByName('UserID').Value:= CurUser.UserID;
      Parameters.ParamByName('InDepotTypeID').Value:= GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items);
      Parameters.ParamByName('InDepotNum').Value:= StrToInt(EdtNum.Text);
      Parameters.ParamByName('CreateTime').Value:= Now; }
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadInDepotInfo;
    Application.MessageBox('�����ɹ���','��ʾ',MB_OK+64);
  except
    Application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK+64);
  end;
end;

procedure TFormInDepotMgr.Btn_ModifyClick(Sender: TObject);
begin
  if CbbDepot.ItemIndex=-1 then
  begin
    Application.MessageBox('����ѡ�����ֿ⣡','��ʾ',MB_OK+64);
    Exit;
  end;
  if CbbGoodsType.ItemIndex=-1 then
  begin
    Application.MessageBox('����ѡ����Ʒ���ͣ�','��ʾ',MB_OK+64);
    Exit;
  end;
  if CbbInDepotType.ItemIndex=-1 then
  begin
    Application.MessageBox('����ѡ��������ͣ�','��ʾ',MB_OK+64);
    Exit;
  end;
  if DM.ADOConnection.InTransaction then  DM.ADOConnection.CommitTrans;
  try
    IsRecordChanged:= True;
    DM.ADOConnection.BeginTrans;
    with AdoEdit do
    begin
      //�޸�ǰ����ʷ����¼
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into InDepotHistory(' +
                 'Old_DepotID, Old_GoodsID, Old_UserID, Old_InDepotTypeID, Old_InDepotNum,'+
                 'New_DepotID, New_GoodsID, New_UserID, New_InDepotTypeID, New_InDepotNum,' +
                 'OperateType, CreateTime) ' +
                 'values(' +
                 AdoQuery.FieldByName('DepotID').AsString + ',' +
                 AdoQuery.FieldByName('GoodsID').AsString + ',' +
                 AdoQuery.FieldByName('UserID').AsString + ',' +
                 AdoQuery.FieldByName('InDepotTypeID').AsString + ',' +
                 AdoQuery.FieldByName('InDepotNum').AsString + ',' +
                 IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items)) + ',' +
                 IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items)) + ',' +
                 IntToStr(CurUser.UserID) + ',' +
                 IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items)) + ',' +
                 EdtNum.Text + ',' +
                 '1,' +
                 'cdate(''' + DateTimeToStr(Now) + '''))';
      ExecSQL;
      //������ʷ�����޸�
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'update InDepot set ' +
                 'DepotID=' + IntToStr(GetItemCode(CbbDepot.Text, CbbDepot.Items)) + ',' +
                 'GoodsID=' + IntToStr(GetItemCode(CbbGoodsType.Text, CbbGoodsType.Items)) + ',' +
                 'UserID=' + IntToStr(CurUser.UserID) + ',' +
                 'InDepotTypeID=' + IntToStr(GetItemCode(CbbInDepotType.Text, CbbInDepotType.Items)) + ',' +
                 'InDepotNum=' + EdtNum.Text + ',' +
                 'ModifyTime=cdate(''' + DateTimeToStr(Now) + ''')' +
                 ' where ID=' + AdoQuery.FieldByName('ID').AsString;
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadInDepotInfo;
    DM.ADOConnection.CommitTrans;
    Application.MessageBox('�޸ĳɹ���','��ʾ',MB_OK+64);
  except
    DM.ADOConnection.RollbackTrans;
    Application.MessageBox('�޸�ʧ�ܣ�','��ʾ',MB_OK+64);
  end;
end;

procedure TFormInDepotMgr.Btn_DeleteClick(Sender: TObject);
var
  lSqlStr: string;
begin
  if DM.ADOConnection.InTransaction then  DM.ADOConnection.CommitTrans;
  try
    DM.ADOConnection.BeginTrans;
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      //ɾ��ǰ����ʷ����¼
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into InDepotHistory(' +
                 'Old_DepotID, Old_GoodsID, Old_UserID, Old_InDepotTypeID, Old_InDepotNum,'+
                 'New_DepotID, New_GoodsID, New_UserID, New_InDepotTypeID, New_InDepotNum,' +
                 'OperateType, CreateTime) ' +
                 'values(' +
                 AdoQuery.FieldByName('DepotID').AsString + ',' +
                 AdoQuery.FieldByName('GoodsID').AsString + ',' +
                 AdoQuery.FieldByName('UserID').AsString + ',' +
                 AdoQuery.FieldByName('InDepotTypeID').AsString + ',' +
                 AdoQuery.FieldByName('InDepotNum').AsString + ',' +
                 '-1,-1,' +IntToStr(CurUser.UserID) + ',-1,-1,2,' +
                 'cdate(''' + DateTimeToStr(Now) + '''))';
      ExecSQL;
      //������ʷ����ɾ��
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lSqlStr:= 'delete from InDepot where ID=' + AdoQuery.FieldByName('ID').AsString;
      SQL.Add(lSqlStr);
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadInDepotInfo;
    DM.ADOConnection.CommitTrans;
    Application.MessageBox('ɾ���ɹ���','��ʾ',MB_OK+64);
  except
    DM.ADOConnection.RollbackTrans;
    Application.MessageBox('ɾ��ʧ�ܣ�','��ʾ',MB_OK+64);
  end;
end;

procedure TFormInDepotMgr.Btn_PrintClick(Sender: TObject);
begin
//
end;

procedure TFormInDepotMgr.Btn_CalcClick(Sender: TObject);
begin
  winexec('calc.exe',sw_normal);
end;

procedure TFormInDepotMgr.Btn_CloseClick(Sender: TObject);
begin
  FormMain.RemoveForm(FormInDepotMgr);
end;

procedure TFormInDepotMgr.AddcxGridViewField;
begin
  AddViewField(cxGridInDepotDBTableView1,'DepotName','�ֿ�����',100);
  AddViewField(cxGridInDepotDBTableView1,'GoodsName','��Ʒ����',200);
  AddViewField(cxGridInDepotDBTableView1,'InDepotTypeName','�������');
  AddViewField(cxGridInDepotDBTableView1,'InDepotNum','�������');
  AddViewField(cxGridInDepotDBTableView1,'CostPrice','�ɱ�����');
  AddViewField(cxGridInDepotDBTableView1,'SalePrice','���۵���');
  AddViewField(cxGridInDepotDBTableView1,'Cost','�ɱ���');
  AddViewField(cxGridInDepotDBTableView1,'Sale','���ۼ�');
  AddViewField(cxGridInDepotDBTableView1,'CreateTime','���ʱ��',100);
  AddViewField(cxGridInDepotDBTableView1,'ModifyTime','�޸�ʱ��',100);
end;

procedure TFormInDepotMgr.LoadInDepotInfo;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
//    SQL.Text:= 'SELECT InDepot.*, Depot.DepotName, Goods.GoodsName, InDepotType.InDepotTypeName,User.UserName ' +
//               ' FROM (((InDepot LEFT JOIN Depot ON Depot.DepotID=InDepot.DepotID) ' +
//               ' LEFT JOIN Goods ON Goods.GoodsID=InDepot.GoodsID) ' +
//               ' LEFT JOIN InDepotType ON InDepotType.InDepotTypeID=InDepot.InDepotTypeID) ' +
//               ' LEFT JOIN User ON Depot.UserID=User.UserID';
    SQL.Text:= 'SELECT InDepot.*, Depot.DepotName, Goods.GoodsName, InDepotType.InDepotTypeName, User.UserName,' +
               ' Goods.CostPrice, Goods.SalePrice,' +
               ' (Goods.CostPrice*InDepot.InDepotNum) AS Cost, (Goods.SalePrice*InDepot.InDepotNum) AS Sale ' +
               ' FROM (((InDepot LEFT JOIN Depot ON InDepot.DepotID=Depot.DepotID) ' +
               ' LEFT JOIN Goods ON InDepot.GoodsID=Goods.GoodsID) ' +
               ' INNER JOIN [User] ON InDepot.UserID=User.UserID) ' +
               ' INNER JOIN InDepotType ON InDepot.InDepotTypeID=InDepotType.InDepotTypeID';
    Active:= True;
    DataSourceInDeopt.DataSet:= AdoQuery;
  end;
end;

procedure TFormInDepotMgr.EdtNumKeyPress(Sender: TObject; var Key: Char);
begin
  InPutChar(Key);
end;

procedure TFormInDepotMgr.cxGridInDepotDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  with AdoQuery do
  begin
    CbbDepot.ItemIndex:= CbbDepot.Items.IndexOf(FieldByName('DepotName').AsString);
    CbbGoodsType.ItemIndex:= CbbGoodsType.Items.IndexOf(FieldByName('GoodsName').AsString);
    CbbInDepotType.ItemIndex:= CbbInDepotType.Items.IndexOf(FieldByName('InDepotTypeName').AsString);
    EdtNum.Text:= FieldByName('InDepotNum').AsString;
  end;
end;

end.
