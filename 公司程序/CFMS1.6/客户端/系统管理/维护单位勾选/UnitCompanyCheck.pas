unit UnitCompanyCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Menus, cxLookAndFeelPainters, cxButtons,
  DBClient, StringUtils;

type
  TFormCompanyCheck = class(TForm)
    LabelCompany: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    CheckListBoxCompany: TCheckListBox;
    BtnOK: TcxButton;
    BtnCancel: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    function GetCompanyName(aCompanyID: Integer): string;
    function GetCompanysID: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCompanyCheck: TFormCompanyCheck;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormCompanyCheck.FormCreate(Sender: TObject);
begin
  LabelCompany.Caption:= LabelCompany.Caption + GetCompanyName(gPublicParam.Companyid);
end;

procedure TFormCompanyCheck.FormShow(Sender: TObject);
var
  i, lCompanyID: Integer;
  lSqlStr, lCompanyName, lCompanysID: string;
  lAlarmObject: TWdInteger;
  lClientDataSet: TClientDataSet;
begin
  lCompanysID:= GetCompanysID;
  ClearTStrings(CheckListBoxCompany.Items);
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:= 'DataSetProvider';
      lSqlStr:= 'select a.*' + #13#10 +
                ' from' +
                ' (select ROW_NUMBER () OVER (PARTITION BY part ORDER BY lev DESC) rn,a.*' +
                '   from' + #13#10 +
                '   (SELECT  level AS Lev,level-rownum as part,a.*' +
                '    FROM fms_company_info a start with a.cityid=' + IntToStr(gPublicParam.cityid) +
                '     and a.companyid=1 CONNECT BY PRIOR a.companyid=a.parentid and a.cityid=a.cityid' +
                '    order siblings  by a.cityid,a.companyid' +
                '    ) a' +
                ' ) a' +
                ' where a.rn=1 and a.companyid not in (' + IntToStr(gPublicParam.Companyid) + ')';
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then exit;
      First;
      for i:=0 to RecordCount-1 do
      begin
        lCompanyID:= FieldByName('COMPANYID').AsInteger;
        lCompanyName:= FieldByName('COMPANYNAME').AsString;
        lAlarmObject:= TWdInteger.create(lCompanyID);
        CheckListBoxCompany.Items.AddObject(lCompanyName,lAlarmObject);
        if lCompanysID<>'' then
        begin
          if Pos(IntToStr(lCompanyID),lCompanysID)>0 then
            CheckListBoxCompany.Checked[i]:= True;
        end
        else
          CheckListBoxCompany.Checked[i]:= True;
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormCompanyCheck.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormCompanyCheck.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormCompanyCheck.BtnOKClick(Sender: TObject);
var
  i: Integer;
  lVariant: variant;
  lsuccess: Boolean;
  FCompanysID, lSqlStr: string;
begin
  FCompanysID:= '';
  for i:=0 to CheckListBoxCompany.Items.Count-1 do
    if CheckListBoxCompany.Checked[i] then
      FCompanysID:= FCompanysID + IntToStr(TWdInteger(CheckListBoxCompany.Items.Objects[i]).Value) + ',';
  FCompanysID:= Copy(FCompanysID,1,Length(FCompanysID)-1);
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlStr:= 'update fms_company_info' +
            '   set relatecompany = ''' + FCompanysID +
            ''' where companyid = ' + IntToStr(gPublicParam.Companyid) +
            '   and cityid = ' + IntToStr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
    Application.MessageBox('保存成功', '提示', MB_OK+64)
  else
    Application.MessageBox('保存失败', '提示', MB_OK+64);
end;

procedure TFormCompanyCheck.BtnCancelClick(Sender: TObject);
begin
  close;
end;

function TFormCompanyCheck.GetCompanyName(aCompanyID: Integer):string;
var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
  lSuccess: Boolean;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='DataSetProvider';
      lSqlStr:= 'select COMPANYNAME from fms_company_info where cityid='+
                IntToStr(gPublicParam.cityid) +
                ' and companyid=' +
                IntToStr(aCompanyID);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      Result:= FieldByName('COMPANYNAME').AsString;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

function TFormCompanyCheck.GetCompanysID(): string;
var
  lSqlStr: string;
  lClientDataSet: TClientDataSet;
begin
  Result:= '';
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:= 'DataSetProvider';
      lSqlStr:= 'select * from fms_company_info where cityid=' +
                IntToStr(gPublicParam.cityid) +
                ' and companyid=' +
                IntToStr(gPublicParam.Companyid);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      result:= FieldByName('relatecompany').AsString;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

end.
