unit UnitEditUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, UnitUserManager, ADODB;

type
  TEditUserMode = (eumAdd, eumEdit);
  TFormEditUser = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    GRPRepertoryMgr: TGroupBox;
    CHKRepertoryQuery: TCheckBox;
    CHKRepertoryStat: TCheckBox;
    grp1: TGroupBox;
    lblUserLevel: TLabel;
    cbbUserLevel: TComboBox;
    lbledtUserName: TLabeledEdit;
    lbledtPassword: TLabeledEdit;
    btnOK: TButton;
    btnCancel: TButton;
    GRPInformationMgr: TGroupBox;
    CHKDepotInfoMgr: TCheckBox;
    CHKAssociatorTypeInfoMgr: TCheckBox;
    CHKProviderInfoMgr: TCheckBox;
    CHKCustomerInfoMgr: TCheckBox;
    CHKGoodsTypeInfo: TCheckBox;
    CHKInDepotTypeMgr: TCheckBox;
    CHKOutDepotTypeMgr: TCheckBox;
    GRPInDepotMgr: TGroupBox;
    CHKInDepotMgr: TCheckBox;
    CHKInDepotStat: TCheckBox;
    GRPDataAnalyse: TGroupBox;
    CHKCustomAnalyse: TCheckBox;
    CHKBalanceAnalyse: TCheckBox;
    GRPOutDepotMgr: TGroupBox;
    CHKOutDepotMgr: TCheckBox;
    CHKOutDepotStat: TCheckBox;
    CHKRepertoryAnalyse: TCheckBox;
    GRPUserMgr: TGroupBox;
    CHKUserMgr: TCheckBox;
    CHKUserChangePass: TCheckBox;
    CHKSystemLock: TCheckBox;
    CHKLogOut: TCheckBox;
    procedure cbbUserLevelChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    AdoEdit: TAdoquery;
  public
    { Public declarations }
    class function Execute(aUser: TUser; aOperate: TEditUserMode): Boolean;
  end;

var
  FormEditUser: TFormEditUser;

implementation

uses UnitDataModule;


{$R *.dfm}

{ TFormEditUser }

class function TFormEditUser.Execute(aUser: TUser; aOperate: TEditUserMode): Boolean;
var
  iIndex: Integer;
  Dlg: TFormEditUser;
  aRights, lSqlStr: string;
begin
  Result:= False;
  Dlg := TFormEditUser.Create(nil);
  Dlg.AdoEdit:= TADOQuery.Create(Dlg);
  try
    case aOperate of
      eumAdd: Dlg.caption:= '新增操作员';
      eumEdit:
      begin
        Dlg.caption:= '修改操作员';
        Dlg.lbledtUserName.Text:= aUser.UserName;
        Dlg.lbledtPassword.Text:= aUser.PassWord;
        Dlg.cbbUserLevel.ItemIndex:= aUser.UserType;
        aRights:= aUser.UserRights;
      end;
    end;

    for iIndex :=1 to Length(aRights) do
    begin
      if UpperCase(Copy(aRights,iIndex,1)) = 'A' then
        Dlg.CHKDepotInfoMgr.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'B' then
        Dlg.CHKAssociatorTypeInfoMgr.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'C' then
        Dlg.CHKProviderInfoMgr.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'D' then
        Dlg.CHKCustomerInfoMgr.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'E' then
        Dlg.CHKGoodsTypeInfo.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'F' then
        Dlg.CHKInDepotTypeMgr.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'G' then
        Dlg.CHKOutDepotTypeMgr.Checked := True

      else if UpperCase(Copy(aRights,iIndex,1)) = 'H' then
        Dlg.CHKRepertoryQuery.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'I' then
        Dlg.CHKRepertoryStat.Checked := True

      else if UpperCase(Copy(aRights,iIndex,1)) = 'J' then
        Dlg.CHKInDepotMgr.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'K' then
        Dlg.CHKInDepotStat.Checked := True

      else if UpperCase(Copy(aRights,iIndex,1)) = 'L' then
        Dlg.CHKOutDepotMgr.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'M' then
        Dlg.CHKOutDepotStat.Checked := True

      else if UpperCase(Copy(aRights,iIndex,1)) = 'N' then
        Dlg.CHKCustomAnalyse.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'O' then
        Dlg.CHKBalanceAnalyse.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'P' then
        Dlg.CHKRepertoryAnalyse.Checked := True

      else if UpperCase(Copy(aRights,iIndex,1)) = 'Q' then
        Dlg.CHKUserMgr.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'R' then
        Dlg.CHKUserChangePass.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'S' then
        Dlg.CHKSystemLock.Checked := True
      else if UpperCase(Copy(aRights,iIndex,1)) = 'T' then
        Dlg.CHKLogOut.Checked := True;
    end;

    if Dlg.ShowModal = mrOk then begin
      Result := True;
      aRights:= '';
      if Dlg.CHKDepotInfoMgr.Checked then
        aRights := aRights + 'A';
      if Dlg.CHKAssociatorTypeInfoMgr.Checked then
        aRights := aRights + 'B';
      if Dlg.CHKProviderInfoMgr.Checked then
        aRights := aRights + 'C';
      if Dlg.CHKCustomerInfoMgr.Checked then
        aRights := aRights + 'D';
      if Dlg.CHKGoodsTypeInfo.Checked then
        aRights := aRights + 'E';
      if Dlg.CHKInDepotTypeMgr.Checked then
        aRights := aRights + 'F';
      if Dlg.CHKOutDepotTypeMgr.Checked then
        aRights := aRights + 'G';

      if Dlg.CHKRepertoryQuery.Checked then
        aRights := aRights + 'H';
      if Dlg.CHKRepertoryStat.Checked then
        aRights := aRights + 'I';

      if Dlg.CHKInDepotMgr.Checked then
        aRights := aRights + 'J';
      if Dlg.CHKInDepotStat.Checked then
        aRights := aRights + 'K';

      if Dlg.CHKOutDepotMgr.Checked then
        aRights := aRights + 'L';
      if Dlg.CHKOutDepotStat.Checked then
        aRights := aRights + 'M';

      if Dlg.CHKCustomAnalyse.Checked then
        aRights := aRights + 'N';
      if Dlg.CHKBalanceAnalyse.Checked then
        aRights := aRights + 'O';
      if Dlg.CHKRepertoryAnalyse.Checked then
        aRights := aRights + 'P';

      if Dlg.CHKUserMgr.Checked then
        aRights := aRights + 'Q';
      if Dlg.CHKUserChangePass.Checked then
        aRights := aRights + 'R';
      if Dlg.CHKSystemLock.Checked then
        aRights := aRights + 'S';
      if Dlg.CHKLogOut.Checked then
        aRights := aRights + 'T';
      aUser.UserName:= Dlg.lbledtUserName.Text;
      aUser.PassWord:= Dlg.lbledtPassword.Text;
      aUser.UserType:= Dlg.cbbUserLevel.ItemIndex;
      aUser.UserRights:= aRights;
      case aOperate of
        eumAdd: lSqlStr:= 'insert intto user(UserName,UserPWD,UserType,UserRights) values(:Name,:PWD,:Type,:Rights)';
        eumEdit: lSqlStr:= 'update User Set UserName=:Name,UserPWD=:PWD,UserType=:Type,UserRights=:Rights' +
                           ' where UserID=' + IntToStr(aUser.UserID);
      end;
      with Dlg.AdoEdit do
      begin
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= lSqlStr;
        Parameters.ParamByName('Name').Value:= Dlg.lbledtUserName.Text;
        Parameters.ParamByName('PWD').Value:= Dlg.lbledtPassword.Text;
        Parameters.ParamByName('Type').Value:= Dlg.cbbUserLevel.ItemIndex;
        Parameters.ParamByName('Rights').Value:= aRights;
        ExecSQL;
      end;
    end;
  finally
    FreeAndNil(Dlg);
  end;
end;

procedure TFormEditUser.cbbUserLevelChange(Sender: TObject);
var
  i: Integer;
begin
  //全置为不选中状态
  for i:=0 to GRPInformationMgr.ControlCount -1 do
      if (GRPInformationMgr.Controls[i] is TCheckBox) then
        (GRPInformationMgr.Controls[i] as TCheckBox).Checked:= False;
  for i:=0 to GRPRepertoryMgr.ControlCount -1 do
    if (GRPRepertoryMgr.Controls[i] is TCheckBox) then
      (GRPRepertoryMgr.Controls[i] as TCheckBox).Checked:= False;
  for i:=0 to GRPInDepotMgr.ControlCount -1 do
    if (GRPInDepotMgr.Controls[i] is TCheckBox) then
      (GRPInDepotMgr.Controls[i] as TCheckBox).Checked:= False;
  for i:=0 to GRPOutDepotMgr.ControlCount -1 do
    if (GRPOutDepotMgr.Controls[i] is TCheckBox) then
      (GRPOutDepotMgr.Controls[i] as TCheckBox).Checked:= False;
  for i:=0 to GRPDataAnalyse.ControlCount -1 do
    if (GRPDataAnalyse.Controls[i] is TCheckBox) then
      (GRPDataAnalyse.Controls[i] as TCheckBox).Checked:= False;
  for i:=0 to GRPUserMgr.ControlCount -1 do
    if (GRPUserMgr.Controls[i] is TCheckBox) then
      (GRPUserMgr.Controls[i] as TCheckBox).Checked:= False;
  //如果是管理员，全置为选中状态
  if cbbUserLevel.ItemIndex=0 then
  begin
    for i:=0 to GRPInformationMgr.ControlCount -1 do
      if (GRPInformationMgr.Controls[i] is TCheckBox) then
        (GRPInformationMgr.Controls[i] as TCheckBox).Checked:= True;
    for i:=0 to GRPRepertoryMgr.ControlCount -1 do
      if (GRPRepertoryMgr.Controls[i] is TCheckBox) then
        (GRPRepertoryMgr.Controls[i] as TCheckBox).Checked:= True;
    for i:=0 to GRPInDepotMgr.ControlCount -1 do
      if (GRPInDepotMgr.Controls[i] is TCheckBox) then
        (GRPInDepotMgr.Controls[i] as TCheckBox).Checked:= True;
    for i:=0 to GRPOutDepotMgr.ControlCount -1 do
      if (GRPOutDepotMgr.Controls[i] is TCheckBox) then
        (GRPOutDepotMgr.Controls[i] as TCheckBox).Checked:= True;
    for i:=0 to GRPDataAnalyse.ControlCount -1 do
      if (GRPDataAnalyse.Controls[i] is TCheckBox) then
        (GRPDataAnalyse.Controls[i] as TCheckBox).Checked:= True;
    for i:=0 to GRPUserMgr.ControlCount -1 do
      if (GRPUserMgr.Controls[i] is TCheckBox) then
        (GRPUserMgr.Controls[i] as TCheckBox).Checked:= True;
  end;
  if cbbUserLevel.ItemIndex=1 then
  begin
    for i:=0 to GRPInDepotMgr.ControlCount -1 do
      if (GRPInDepotMgr.Controls[i] is TCheckBox) then
        (GRPInDepotMgr.Controls[i] as TCheckBox).Checked:= True;
    for i:=0 to GRPOutDepotMgr.ControlCount -1 do
      if (GRPOutDepotMgr.Controls[i] is TCheckBox) then
        (GRPOutDepotMgr.Controls[i] as TCheckBox).Checked:= True;
    CHKSystemLock.Checked:= True;
    CHKLogOut.Checked:= True;
  end;
end;

procedure TFormEditUser.btnOKClick(Sender: TObject);
var
  str: string;
begin
  str := Trim(lbledtUserName.Text);
  if (str = '') then begin
    Application.MessageBox('用户名不能为空！', '提示信息', MB_OK or MB_ICONINFORMATION);
    pgc1.ActivePageIndex := 0;
    lbledtUserName.SetFocus;
    Exit;
  end;
  ModalResult := mrOk;
end;

procedure TFormEditUser.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
