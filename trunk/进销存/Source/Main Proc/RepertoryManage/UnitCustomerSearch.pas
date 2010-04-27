unit UnitCustomerSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ADODB, CxGridUnit;

type
  TFormCustomerSearch = class(TForm)
    GroupBoxgrp1: TGroupBox;
    Label1: TLabel;
    BtnCancel: TSpeedButton;
    BtnOK: TSpeedButton;
    EdtName: TEdit;
    ChkName: TCheckBox;
    ChkAssociatorType: TCheckBox;
    CbbAssociatorType: TComboBox;
    GroupBoxgrp2: TGroupBox;
    cxGridCustomer: TcxGrid;
    cxGridCustomerDBTableView1: TcxGridDBTableView;
    cxGridCustomerLevel1: TcxGridLevel;
    DSCustomer: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cxGridCustomerDBTableView1DblClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    FCustomerID: String;
    AdoQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;
    procedure AddcxGridViewField;
    
    { Private declarations }
  public
    { Public declarations }
  property CustomerID: String read FCustomerID write FCustomerID;
  end;

var
  FormCustomerSearch: TFormCustomerSearch;

implementation

uses UnitPublic, UnitDataModule;

{$R *.dfm}

procedure TFormCustomerSearch.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridCustomer,true,false,true);
  SetItemCode('AssociatorType', 'AssociatorTypeID', 'AssociatorTypeName', '', CbbAssociatorType.Items);
end;

procedure TFormCustomerSearch.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
end;

procedure TFormCustomerSearch.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormCustomerSearch.FormDestroy(Sender: TObject);
begin
  AdoQuery.Free;
  FCxGridHelper.Free;
end;

procedure TFormCustomerSearch.AddcxGridViewField;
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
end;

procedure TFormCustomerSearch.cxGridCustomerDBTableView1DblClick(
  Sender: TObject);
var
  lCustomerID_Index, lRecordIndex: Integer;
begin
  try
    lCustomerID_Index:=cxGridCustomerDBTableView1.GetColumnByFieldName('CustomerID').Index;
  except
    Application.MessageBox('未获得"条形码"关键字！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  if cxGridCustomerDBTableView1.DataController.GetSelectedCount=0 then
  begin
    Application.MessageBox('请选择一条记录！！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  if cxGridCustomerDBTableView1.DataController.GetSelectedCount>1 then
  begin
    Application.MessageBox('只能选择一条记录！！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  if cxGridCustomerDBTableView1.DataController.GetSelectedCount=1 then
  begin
    lRecordIndex := cxGridCustomerDBTableView1.Controller.SelectedRows[0].RecordIndex;
    FCustomerID:= cxGridCustomerDBTableView1.DataController.GetValue(lRecordIndex,lCustomerID_Index);;
    ModalResult:= mrOk;
  end;
end;

procedure TFormCustomerSearch.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCustomerSearch.BtnOKClick(Sender: TObject);
var
  lWhereStr: string;
begin
  if ChkName.Checked then
  begin
    lWhereStr:= lWhereStr +
                ' and (a.CustomerName like ''%' + EdtName.Text + '%''' +
                ' or a.CustomerOfficePhone like ''%' + EdtName.Text + '%''' +
                ' or a.CustomerFamilyPhone like ''%' + EdtName.Text + '%''' +
                ' or a.CustomerMobilePhone like ''%' + EdtName.Text + '%''' +
                ' or a.CustomerFamilyAddress like ''%' + EdtName.Text + '%''' +
                ' or a.CustomerOfficeAddress like ''%' + EdtName.Text + '%''' + ')';
  end;
  if ChkAssociatorType.Checked then
  begin
    lWhereStr:= lWhereStr + ' and a.CustomerAssociatorTypeID=' +
                IntToStr(GetItemCode(CbbAssociatorType.Text, CbbAssociatorType.Items));
  end;

  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select a.*,b.AssociatorTypeName, IIf(CustomerSex=0,''男'',iif(CustomerSex=1,''女'')) AS CustomerSexName' +
               ' from Customer a,AssociatorType b' +
               ' where a.CustomerAssociatorTypeID=b.AssociatorTypeID' + lWhereStr +
               ' order by a.CustomerID';
    Active:= True;
    DSCustomer.DataSet:= AdoQuery;
  end;
end;

end.
