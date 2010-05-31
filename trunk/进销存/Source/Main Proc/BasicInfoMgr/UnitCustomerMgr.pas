unit UnitCustomerMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Buttons, ExtCtrls, StdCtrls, CxGridUnit, ADODB,
  ComCtrls;

type
  TFormCustomerMgr = class(TForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EdtCustomerName: TEdit;
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox1: TGroupBox;
    cxGridCustomer: TcxGrid;
    cxGridCustomerDBTableView1: TcxGridDBTableView;
    cxGridCustomerLevel1: TcxGridLevel;
    DataSourceCustomer: TDataSource;
    Label3: TLabel;
    CBCustomerSex: TComboBox;
    Label4: TLabel;
    DTPCustomerBirthday: TDateTimePicker;
    CBAssociatorType: TComboBox;
    Label5: TLabel;
    EdtOfficePhone: TEdit;
    Label6: TLabel;
    EdtFamilyPhone: TEdit;
    Label7: TLabel;
    EdtMobilePhone: TEdit;
    Label10: TLabel;
    EdtFamilyAddress: TEdit;
    Label9: TLabel;
    EdtOfficeAddress: TEdit;
    Label11: TLabel;
    EdtCustomerIntegral: TEdit;
    Label8: TLabel;
    EdtEmail: TEdit;
    Label12: TLabel;
    EdtCustomerID: TEdit;
    Label13: TLabel;
    DTPBabyBirthday: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure cxGridCustomerDBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    AdoQuery, AdoEdit: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;

    procedure AddcxGridViewField;
    procedure LoadCustomerInfo;
  public
    { Public declarations }
  end;

var
  FormCustomerMgr: TFormCustomerMgr;

implementation

uses UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormCustomerMgr.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  AdoEdit:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridCustomer,true,false,true);
  SetItemCode('AssociatorType', 'AssociatorTypeID', 'AssociatorTypeName', '', CBAssociatorType.Items);
end;

procedure TFormCustomerMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
  LoadCustomerInfo;
end;

procedure TFormCustomerMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormCustomerMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormCustomerMgr.AddcxGridViewField;
begin
  AddViewField(cxGridCustomerDBTableView1,'CustomerID','客户编号');
  AddViewField(cxGridCustomerDBTableView1,'CustomerName','客户名称');
  AddViewField(cxGridCustomerDBTableView1,'CustomerIntegral','客户积分');
  AddViewField(cxGridCustomerDBTableView1,'AssociatorTypeName','会员类型');
  AddViewField(cxGridCustomerDBTableView1,'CustomerSexName','性别');
  AddViewField(cxGridCustomerDBTableView1,'CustomerBirthday','客户生日'); 
  AddViewField(cxGridCustomerDBTableView1,'CustomerOfficePhone','公司电话');
  AddViewField(cxGridCustomerDBTableView1,'CustomerFamilyPhone','固定电话');
  AddViewField(cxGridCustomerDBTableView1,'CustomerMobilePhone','手机号');
  AddViewField(cxGridCustomerDBTableView1,'CustomerEmail','Email');
  AddViewField(cxGridCustomerDBTableView1,'CustomerFamilyAddress','家庭住址');
  AddViewField(cxGridCustomerDBTableView1,'CustomerOfficeAddress','公司地址');
  AddViewField(cxGridCustomerDBTableView1,'BabyBirthday','宝宝生日');
end;

procedure TFormCustomerMgr.LoadCustomerInfo;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select a.*,b.AssociatorTypeName, IIf(CustomerSex=0,''男'',iif(CustomerSex=1,''女'')) AS CustomerSexName' +
               ' from Customer a,AssociatorType b' +
               ' where a.CustomerAssociatorTypeID=b.AssociatorTypeID' +
               ' order by a.CustomerID';
    Active:= True;
    DataSourceCustomer.DataSet:= AdoQuery;
  end;
end;

procedure TFormCustomerMgr.Btn_AddClick(Sender: TObject);
begin
  if EdtCustomerID.Text='' then
  begin
    Application.MessageBox('客户编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtCustomerName.Text='' then
  begin
    Application.MessageBox('客户名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if IsExistID('CustomerID', 'Customer', EdtCustomerID.Text) then
  begin
    Application.MessageBox('客户编号已存在！','提示',MB_OK+64);
    Exit;
  end;
  try
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'insert into Customer(' +
                 'CustomerID,CustomerName, CustomerSex, CustomerBirthday, CustomerAssociatorTypeID, ' +
                 'CustomerIntegral, CustomerOfficePhone, CustomerFamilyPhone, CustomerMobilePhone, ' +
                 'CustomerFamilyAddress, CustomerOfficeAddress, CustomerEmail, BabyBirthday) ' +
                 'values(:ID,:name,:sex,:birthday,:associatortypeid,:integral,:officephone,:familyphone,' +
                 ':mobilephone,:familyaddress,:officeaddress,:email,:BabyBirthday)';
      Parameters.ParamByName('ID').DataType:= ftInteger;
      Parameters.ParamByName('ID').Direction:=pdInput;
      Parameters.ParamByName('name').DataType:= ftString;
      Parameters.ParamByName('name').Direction:=pdInput;
      Parameters.ParamByName('sex').DataType:= ftInteger;
      Parameters.ParamByName('birthday').DataType:= ftDate;
      Parameters.ParamByName('associatortypeid').DataType:= ftInteger;
      Parameters.ParamByName('integral').DataType:= ftInteger;
      Parameters.ParamByName('officephone').DataType:= ftString;
      Parameters.ParamByName('familyphone').DataType:= ftString;
      Parameters.ParamByName('mobilephone').DataType:= ftString;
      Parameters.ParamByName('familyaddress').DataType:= ftString;
      Parameters.ParamByName('officeaddress').DataType:= ftString;
      Parameters.ParamByName('email').DataType:= ftString;
      Parameters.ParamByName('BabyBirthday').DataType:= ftDate;

      Parameters.ParamByName('ID').Value:= StrToInt(EdtCustomerID.Text);
      Parameters.ParamByName('name').Value:= EdtCustomerName.Text;
      Parameters.ParamByName('sex').Value:= CBCustomerSex.ItemIndex;
      Parameters.ParamByName('birthday').Value:= DTPCustomerBirthday.Date;
      Parameters.ParamByName('associatortypeid').Value:= GetItemCode(CBAssociatorType.Text, CBAssociatorType.Items);
      Parameters.ParamByName('integral').Value:= EdtCustomerIntegral.Text;
      Parameters.ParamByName('officephone').Value:= EdtOfficePhone.Text;
      Parameters.ParamByName('familyphone').Value:= EdtFamilyPhone.Text;
      Parameters.ParamByName('mobilephone').Value:= EdtMobilePhone.Text;
      Parameters.ParamByName('familyaddress').Value:= EdtFamilyAddress.Text;
      Parameters.ParamByName('officeaddress').Value:= EdtOfficeAddress.Text;
      Parameters.ParamByName('email').Value:= EdtEmail.Text;
      Parameters.ParamByName('BabyBirthday').Value:= DTPBabyBirthday.Date;
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadCustomerInfo;
    Application.MessageBox('新增成功！','提示',MB_OK+64);
  except
    Application.MessageBox('新增失败！','提示',MB_OK+64);
  end;
end;

procedure TFormCustomerMgr.Btn_ModifyClick(Sender: TObject);
var
  lSqlStr: string;
begin
  if EdtCustomerID.Text='' then
  begin
    Application.MessageBox('客户编号不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtCustomerName.Text='' then
  begin
    Application.MessageBox('客户名称不能为空！','提示',MB_OK+64);
    Exit;
  end;
  if EdtCustomerID.Text<> AdoQuery.fieldbyname('CustomerID').AsString then
    if IsExistID('CustomerID', 'Customer', EdtCustomerID.Text) then
    begin
      Application.MessageBox('客户编号已存在！','提示',MB_OK+64);
      Exit;
    end;

  try
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lSqlStr := 'update Customer set ' +
                 'CustomerID=' + EdtCustomerID.Text + ',' + 
                 'CustomerName=''' + EdtCustomerName.Text + ''',' +
                 'CustomerSex=' + IntToStr(CBCustomerSex.ItemIndex) + ',' +
                 'CustomerBirthday=cdate(''' + DateToStr(DTPCustomerBirthday.Date) + '''),' +
                 'CustomerAssociatorTypeID=' + IntToStr(GetItemCode(CBAssociatorType.Text, CBAssociatorType.Items)) + ',' +
                 'CustomerIntegral=' + EdtCustomerIntegral.Text + ',' +
                 'CustomerOfficePhone=''' + EdtOfficePhone.Text + ''',' +
                 'CustomerFamilyPhone=''' + EdtFamilyPhone.Text + ''',' +
                 'CustomerMobilePhone=''' + EdtMobilePhone.Text + ''',' +
                 'CustomerFamilyAddress=''' + EdtFamilyAddress.Text + ''',' +
                 'CustomerOfficeAddress=''' + EdtOfficeAddress.Text + ''',' +
                 'CustomerEmail=''' + EdtEmail.Text + ''',' +
                 'BabyBirthday=cdate(''' + DateToStr(DTPBabyBirthday.Date) + ''')' +
                 ' where CustomerID=' + AdoQuery.FieldByName('CustomerID').AsString;
      SQL.Add(lSqlStr);
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadCustomerInfo;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormCustomerMgr.Btn_DeleteClick(Sender: TObject);
var
  lSqlStr: string;
begin
  try
    IsRecordChanged:= True;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lSqlStr:= 'delete from Customer where CustomerID=' + AdoQuery.FieldByName('CustomerID').AsString;
      SQL.Add(lSqlStr);
      ExecSQL;
    end;
    IsRecordChanged:= False;
    LoadCustomerInfo;
    Application.MessageBox('删除成功！','提示',MB_OK+64);
  except
    Application.MessageBox('删除失败！','提示',MB_OK+64);
  end;
end;

procedure TFormCustomerMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCustomerMgr.cxGridCustomerDBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  with AdoQuery do
  begin
    EdtCustomerID.Text:=FieldByName('CustomerID').AsString;
    EdtCustomerName.Text:=FieldByName('CustomerName').AsString;
    CBCustomerSex.ItemIndex:= FieldByName('CustomerSex').AsInteger;
    DTPCustomerBirthday.Date:= FieldByName('CustomerBirthday').AsDateTime;
    CBAssociatorType.ItemIndex:= CBAssociatorType.Items.IndexOf(FieldByName('AssociatorTypeName').AsString);
    EdtCustomerIntegral.Text:= FieldByName('CustomerIntegral').AsString;
    EdtOfficePhone.Text:= FieldByName('CustomerOfficePhone').AsString;
    EdtFamilyPhone.Text:= FieldByName('CustomerFamilyPhone').AsString;
    EdtMobilePhone.Text:= FieldByName('CustomerMobilePhone').AsString;
    EdtEmail.Text:= FieldByName('CustomerEmail').AsString;
    EdtFamilyAddress.Text:= FieldByName('CustomerFamilyAddress').AsString;
    EdtOfficeAddress.Text:= FieldByName('CustomerOfficeAddress').AsString;
    DTPBabyBirthday.Date:= FieldByName('BabyBirthday').AsDateTime;
  end;
end;

end.
