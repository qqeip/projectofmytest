unit UnitUserMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, ComCtrls, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, Menus,
  ExtCtrls, StdCtrls, cxButtons, cxTextEdit, cxLabel, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxTreeView, cxContainer,
  cxGroupBox, cxMaskEdit, cxDropDownEdit, CxGridUnit, DBClient, ImgList,
  jpeg,UDevExpressToChinese;

type
  TUserInfo= class
    UserID  : Integer;
    UserName: string;
    UserNo  : string;
    UserPWD : string;
    UserSex : Integer;
    deptID  : Integer;
    OfficePhone, HomePhone, FexNo, Email : string;
  end;
type
  TRoleInfo= class
    RoleID  : Integer;
    RoleName: string;
  end;

type
  TFormUserMgr = class(TForm)
    pnl1: TPanel;
    cxGroupBox1: TcxGroupBox;
    cxTreeViewRole: TcxTreeView;
    pnl2: TPanel;
    cxGroupBoxRoleInfo: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGroupBoxRoleSet: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxTextEditUserName: TcxTextEdit;
    pnl3: TPanel;
    cxButtonAdd: TcxButton;
    cxButtonModify: TcxButton;
    cxButtonDel: TcxButton;
    spl1: TSplitter;
    cxLabel2: TcxLabel;
    cxTextEditUserPosition: TcxTextEdit;
    cxLabel3: TcxLabel;
    cxTextEditHomePhone: TcxTextEdit;
    cxLabel4: TcxLabel;
    cxComboBoxSex: TcxComboBox;
    cxLabel5: TcxLabel;
    cxTextEditOfficePhone: TcxTextEdit;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxTextEditUserEmail: TcxTextEdit;
    cxLabel9: TcxLabel;
    cxTextEditFax: TcxTextEdit;
    DateTimePickerBirth: TDateTimePicker;
    cxTextEditUserNo: TcxTextEdit;
    cxLabel11: TcxLabel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    cxLabel12: TcxLabel;
    cxTextEditMobilePhone: TcxTextEdit;
    ImageList1: TImageList;
    cxComboBoxCompany: TcxComboBox;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    cxLabel10: TcxLabel;
    cxComboBoxStation: TcxComboBox;
    cxButton1: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxTreeViewRoleMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxButton1Click(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    IsOperateSucc: Boolean ;
    procedure LoadRoleInfo();
    procedure AddViewField_Role;
    procedure LoadUserInfo();
    function GetTreeCheckedCount(aCxTreeView: TcxTreeView): Integer;
    procedure SetTreeNoCheck;
    procedure SetTreeCheck(aUserID:Integer);
    function GetCityName(aCityID: Integer): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormUserMgr: TFormUserMgr;

implementation

uses UnitDllCommon,UnitModifyPwd;

{$R *.dfm}

procedure TFormUserMgr.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);
end;

procedure TFormUserMgr.FormShow(Sender: TObject);
begin
  AddViewField_Role;
  LoadUserInfo;
  LoadRoleInfo;
  LoadCompanyItemChild(gPublicParam.cityid,gPublicParam.Companyid,cxComboBoxCompany.Properties.Items);
  GetDic(gPublicParam.cityid,36,cxComboBoxStation.Properties.Items);
end;

procedure TFormUserMgr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormUserMgr,1,'','');
end;

procedure TFormUserMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormUserMgr.LoadUserInfo;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='DataSetProvider';
    Data:= gTempInterface.GetCDSData(VarArrayOf([1,4,gPublicParam.cityid]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormUserMgr.AddViewField_Role;
begin
  AddViewField(cxGrid1DBTableView1,'USERID','内部编号');
  AddViewField(cxGrid1DBTableView1,'USERNO','用户编号');
  AddViewField(cxGrid1DBTableView1,'USERNAME','用户名称');
  AddViewField(cxGrid1DBTableView1,'COMPANYNAME','所属部门');
  AddViewField(cxGrid1DBTableView1,'STATIONNAME','所属岗位');
  AddViewField(cxGrid1DBTableView1,'EMAIL','E-MAIL');
  AddViewField(cxGrid1DBTableView1,'BIRTHDAY','生日');
  AddViewField(cxGrid1DBTableView1,'SEXNAME','性别');
  AddViewField(cxGrid1DBTableView1,'POSITION','住址');
  AddViewField(cxGrid1DBTableView1,'OFFICEPHONE','公司电话');
  AddViewField(cxGrid1DBTableView1,'HOMEPHONE','家庭电话');
  AddViewField(cxGrid1DBTableView1,'MOBILEPHONE','手机号');
  AddViewField(cxGrid1DBTableView1,'FAXPHONE','传真');
  AddViewField(cxGrid1DBTableView1,'name','所属城市');
end;

procedure TFormUserMgr.LoadRoleInfo;
 var lRoleInfo: TRoleInfo;
     lClientDataSet: TClientDataset;
     lRootNode, lTempNode: TTreeNode;
begin
  lRootNode:= cxTreeViewRole.Items.Add(nil,'角色');
  lClientDataSet:= TClientDataSet.Create(nil);
  with lClientDataSet do
  begin
    Close;
    lClientDataSet.ProviderName:= 'DataSetProvider';
    Data:= gTempInterface.GetCDSData(VarArrayOf([1,2,gPublicParam.cityid]),0);
    Open;

    if not IsEmpty then
    begin
      First;
      while not Eof do
      begin
        lRoleInfo:= TRoleInfo.Create;
        lRoleInfo.RoleID  := fieldbyName('RoleID').AsInteger;
        lRoleInfo.RoleName:= FieldByName('RoleName').AsString;
        lTempNode:= cxTreeViewRole.Items.AddChildObject(lRootNode,lRoleInfo.RoleName,lRoleInfo);
//        lTempNode.ImageIndex:=0;
//        lTempNode.SelectedIndex:=1;
        Next;
      end;
    end;
  end;
  cxTreeViewRole.AutoExpand:= True;
end;

procedure TFormUserMgr.cxTreeViewRoleMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cxTreeViewMouseDown(cxTreeViewRole,X,Y);
end;

procedure TFormUserMgr.cxButtonAddClick(Sender: TObject);
var
  I, J, lUserID, lRoleID, lTreeCheckedCount: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if cxTextEditUserNo.Text='' then
  begin
    Application.MessageBox('用户编号不能为空','提示',MB_OK + 64);
    Exit;
  end;
  if cxTextEditUserName.Text='' then
  begin
    Application.MessageBox('用户名称不能为空','提示',MB_OK + 64);
    Exit;
  end;
  if IsExists('fms_user_info','USERNO',cxTextEditUserNo.Text) then
  begin
    Application.MessageBox('该用户编号已经存在!','提示',MB_OK+64);
    Exit;
  end;
  if cxComboBoxCompany.ItemIndex=-1 then
  begin
    Application.MessageBox('请选择所属部门!','提示',MB_OK+64);
    Exit;
  end;
  if cxComboBoxStation.ItemIndex=-1 then
  begin
    Application.MessageBox('请选择所属岗位!','提示',MB_OK+64);
    Exit;
  end;

  lUserID:= gTempInterface.GetSequence('CFMS_SEQ_NORMAL');
  lTreeCheckedCount:= GetTreeCheckedCount(cxTreeViewRole);
  lVariant:= VarArrayCreate([0,lTreeCheckedCount],varVariant);

  lSqlstr:= 'insert into fms_user_info'+
            '(USERID,USERNO,USERNAME,USERPWD,'+
            ' DEPTID,stationid,EMAIL,BIRTHDAY,SEX,POSITION,OFFICEPHONE,HOMEPHONE,MOBILEPHONE,'+
            ' FAXPHONE,CREATEDATE,CITYID,CREATOR,MODIFYDATE) '+
            ' values '+
            ' ('+inttostr(lUserID)+',''' +
            cxTextEditUserNo.Text+''',''' +
            cxTextEditUserName.Text+ ''','''+
            gTempInterface.GetMD5(cxTextEditUserNo.Text,'')+ ''','+
            IntToStr(GetDicCode(cxComboBoxCompany.Text,cxComboBoxCompany.Properties.Items)) + ',' +
            IntToStr(GetDicCode(cxComboBoxStation.Text,cxComboBoxStation.Properties.Items)) + ',''' +
            cxTextEditUserEmail.Text+''',to_date('''+datetostr(DateTimePickerBirth.Date)+''','''+'yyyy-mm-dd'''+'),'+
            IntToStr(cxComboBoxSex.itemIndex)+',''' +
            cxTextEditUserPosition.Text + ''',''' +
            cxTextEditOfficePhone.Text+''','''+
            cxTextEditHomePhone.Text+''',''' +
            cxTextEditMobilePhone.Text+''','''+
            cxTextEditFax.Text+''',sysdate,' +
            IntToStr(gPublicParam.cityid)+','+inttostr(gPublicParam.userid)+
            ',sysdate)' ;
  lVariant[0]:= VarArrayOf([lSqlstr]);
  J:=0;
  for I:= 0 to cxTreeViewRole.Items.Count-1 do
  begin
    if (cxTreeViewRole.Items[i].ImageIndex=1) and (cxTreeViewRole.Items[i].level=1) then
    begin
      if J>lTreeCheckedCount then Exit;
      lRoleID:= TRoleInfo(cxTreeViewRole.Items[i].Data).RoleID;
      lSqlstr:= 'insert into fms_role_user_relat'+
                '(ROLEID,USERID,CITYID) '+
                'values '+
                '(' + IntToStr(lRoleID) +','+ IntToStr(lUserID) + ','+inttostr(gPublicParam.cityid)+')';
      lVariant[1+J]:= VarArrayOf([lSqlstr]);
      Inc(J);
    end;
  end;
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    MessageBox(0,'新增成功'+#13+'注：初始密码为空','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('USERID').AsInteger:= lUserID;
    ClientDataSet1.FieldByName('USERNO').AsString:= cxTextEditUserNo.Text;
    ClientDataSet1.FieldByName('USERNAME').AsString:= cxTextEditUserName.Text;
//    ClientDataSet1.FieldByName('USERPWD').AsString:= '';
    ClientDataSet1.FieldByName('companyname').AsString:= cxComboBoxCompany.Text;
    ClientDataSet1.FieldByName('STATIONNAME').AsString:= cxComboBoxStation.Text;
    ClientDataSet1.FieldByName('EMAIL').AsString:= cxTextEditUserEmail.Text;
    ClientDataSet1.FieldByName('BIRTHDAY').AsDateTime:= DateTimePickerBirth.DateTime;
    ClientDataSet1.FieldByName('SEXNAME').AsString:= cxComboBoxSex.Text;
    ClientDataSet1.FieldByName('POSITION').AsString:= cxTextEditUserPosition.Text;
    ClientDataSet1.FieldByName('OFFICEPHONE').AsString:= cxTextEditOfficePhone.Text;
    ClientDataSet1.FieldByName('HOMEPHONE').AsString:= cxTextEditHomePhone.Text;
    ClientDataSet1.FieldByName('MOBILEPHONE').AsString:= cxTextEditMobilePhone.Text;
    ClientDataSet1.FieldByName('FAXPHONE').AsString:= cxTextEditFax.Text;
    ClientDataSet1.FieldByName('name').AsString:= GetCityName(gPublicParam.cityid);
    ClientDataSet1.Post;
    IsOperateSucc:= False;
  end
  else
    MessageBox(0,'新增失败','提示',MB_OK+64);

end;

procedure TFormUserMgr.cxButtonModifyClick(Sender: TObject);
var
  I, J, lUserID, lRoleID, lTreeCheckedCount: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if cxTextEditUserNo.Text='' then
  begin
    MessageBox(0,'用户编号不能为空','提示',MB_OK + 64);
    Exit;
  end;
  if cxTextEditUserName.Text='' then
  begin
    MessageBox(0,'用户名称不能为空','提示',MB_OK + 64);
    Exit;
  end;

  lUserID:= ClientDataSet1.fieldbyname('USERID').AsInteger;
  lTreeCheckedCount:= GetTreeCheckedCount(cxTreeViewRole);
  lVariant:= VarArrayCreate([0,lTreeCheckedCount+1],varVariant);

  lSqlstr:= ' update fms_user_info'+
            ' set USERNO='''+cxTextEditUserNo.Text+''','+
            ' USERNAME='''+cxTextEditUserName.Text +''','+
            ' DEPTID=' + IntToStr(GetDicCode(cxComboBoxCompany.Text,cxComboBoxCompany.Properties.Items)) +','+
            ' STATIONID=' + IntToStr(GetDicCode(cxComboBoxStation.Text,cxComboBoxStation.Properties.Items)) +','+
            ' EMAIL='''+cxTextEditUserEmail.Text+''','+
            ' BIRTHDAY=to_date('''+datetimetostr(DateTimePickerBirth.DateTime)+''',''yyyy-mm-dd''),'+
            ' SEX='+ IntToStr(cxComboBoxSex.ItemIndex)+','+
            ' POSITION='''+cxTextEditUserPosition.Text+''','+
            ' OFFICEPHONE='''+cxTextEditOfficePhone.Text+''','+
            ' HOMEPHONE='''+cxTextEditHomePhone.Text+''','+
            ' MOBILEPHONE='''+cxTextEditMobilePhone.Text+''','+
            ' FAXPHONE='''+cxTextEditFax.Text+''','+
            ' CREATOR='+inttostr(gPublicParam.userid)+','+
            ' CITYID='+Inttostr(gPublicParam.cityid) +','+
            ' MODIFYDATE=sysdate'+
            ' WHERE USERID='+inttostr(lUserID)+
            ' and CITYID='+inttostr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lSqlstr]);

  lSqlstr:= 'delete from fms_role_user_relat where UserID=' + IntToStr(lUserID) +
                ' and cityID=' + IntToStr(gPublicParam.cityid);
  lVariant[1]:= VarArrayOf([lSqlstr]);
  
  J:=0;
  for I:= 0 to cxTreeViewRole.Items.Count-1 do
  begin
    if (cxTreeViewRole.Items[i].ImageIndex=1) and (cxTreeViewRole.Items[i].level=1) then
    begin
      if J>lTreeCheckedCount then Exit;
      lRoleID:= TRoleInfo(cxTreeViewRole.Items[i].Data).RoleID;
      lSqlstr:= ' insert into fms_role_user_relat  '+
                '(USERID,ROLEID,CITYID) '+
                'values '+
                '(' + IntToStr(lUserID) +','+ IntToStr(lRoleID) + ','+inttostr(gPublicParam.cityid)+')';;

      lVariant[2+J]:= VarArrayOf([lSqlstr]);
      Inc(J);
    end;
  end;
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);

  if lsuccess then
  begin
    MessageBox(0,'修改成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Edit;
    ClientDataSet1.FieldByName('USERID').AsInteger:= lUserID;
    ClientDataSet1.FieldByName('USERNO').AsString:= cxTextEditUserNo.Text;
    ClientDataSet1.FieldByName('USERNAME').AsString:= cxTextEditUserName.Text;
//    ClientDataSet1.FieldByName('USERPWD').AsString:= '';
    ClientDataSet1.FieldByName('companyname').AsString:= cxComboBoxCompany.Text;
    ClientDataSet1.FieldByName('STATIONNAME').AsString:= cxComboBoxStation.Text;
    ClientDataSet1.FieldByName('EMAIL').AsString:= cxTextEditUserEmail.Text;
    ClientDataSet1.FieldByName('BIRTHDAY').AsDateTime:= DateTimePickerBirth.DateTime;
    ClientDataSet1.FieldByName('SEXNAME').AsString:= cxComboBoxSex.Text;
    ClientDataSet1.FieldByName('POSITION').AsString:= cxTextEditUserPosition.Text;
    ClientDataSet1.FieldByName('OFFICEPHONE').AsString:= cxTextEditOfficePhone.Text;
    ClientDataSet1.FieldByName('HOMEPHONE').AsString:= cxTextEditHomePhone.Text;
    ClientDataSet1.FieldByName('MOBILEPHONE').AsString:= cxTextEditMobilePhone.Text;
    ClientDataSet1.FieldByName('FAXPHONE').AsString:= cxTextEditFax.Text;
    ClientDataSet1.FieldByName('CITYID').AsInteger:= gPublicParam.cityid;
    ClientDataSet1.Post;
    IsOperateSucc:= False;
  end
  else
    MessageBox(0,'修改失败','提示',MB_OK+64);
end;

procedure TFormUserMgr.cxButtonDelClick(Sender: TObject);
var
  lUserID: Integer;
  lVariant: variant;
  lSqlstr: string;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    MessageBox(0,'请选择一条记录！','提示',MB_OK+64);
    Exit;
  end;
  if Application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;

  lUserID:= ClientDataSet1.fieldbyname('USERID').AsInteger;
  lVariant:= VarArrayCreate([0,1],varVariant);
  lSqlstr:= 'delete from fms_user_info' +
            ' where UserID=' + inttostr(lUserID) +
            ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[0]:= VarArrayOf([lSqlstr]);

  lSqlstr:= 'delete from fms_role_user_relat' +
            ' where USERID=' + inttostr(lUserID) +
            ' and CITYID=' + IntToStr(gPublicParam.cityid);
  lVariant[1]:= VarArrayOf([lSqlstr]);
  lsuccess:= gTempInterface.ExecBatchSQL(lVariant);


  if lsuccess then
  begin
    MessageBox(0,'删除成功','提示',MB_OK+64);
    IsOperateSucc:= True;
    ClientDataSet1.Delete;
    IsOperateSucc:= False;
  end
  else
    MessageBox(0,'删除失败','提示',MB_OK+64);
end;

function TFormUserMgr.GetTreeCheckedCount(aCxTreeView: TcxTreeView): Integer;
var i,lResult: Integer;
begin
  Result:=0;
  lResult:=0;
  for i:=0 to aCxTreeView.Items.Count-1 do
  begin
    if (aCxTreeView.Items[i].ImageIndex=1) and (aCxTreeView.Items[i].level=1) then
    begin
      Inc(lResult);
    end;
  end;
  Result:= lResult;
end;

procedure TFormUserMgr.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsOperateSucc then Exit;
  cxTextEditUserNo.Text:= ClientDataSet1.fieldbyname('USERNO').AsString;
  cxTextEditUserName.Text:= ClientDataSet1.fieldbyname('USERNAME').AsString;
//    ClientDataSet1.FieldByName('USERPWD').AsString:= '';
  cxComboBoxCompany.Text:= ClientDataSet1.FieldByName('COMPANYNAME').AsString;
  cxComboBoxStation.Text:= ClientDataSet1.FieldByName('STATIONNAME').AsString;
  cxTextEditUserEmail.Text:= ClientDataSet1.FieldByName('EMAIL').AsString;
  DateTimePickerBirth.DateTime:= ClientDataSet1.FieldByName('BIRTHDAY').AsDateTime;
  cxComboBoxSex.Text:= ClientDataSet1.FieldByName('SEXNAME').AsString;
  cxTextEditUserPosition.Text:= ClientDataSet1.FieldByName('POSITION').AsString;
  cxTextEditOfficePhone.Text:= ClientDataSet1.FieldByName('OFFICEPHONE').AsString;
  cxTextEditHomePhone.Text:= ClientDataSet1.FieldByName('HOMEPHONE').AsString;
  cxTextEditMobilePhone.Text:= ClientDataSet1.FieldByName('MOBILEPHONE').AsString;
  cxTextEditFax.Text:= ClientDataSet1.FieldByName('FAXPHONE').AsString;
  gPublicParam.cityid:= ClientDataSet1.FieldByName('CITYID').AsInteger;
  SetTreeNoCheck;
  SetTreeCheck(ClientDataSet1.fieldbyname('USERID').AsInteger);
end;

procedure TFormUserMgr.SetTreeNoCheck;
var
  I: Integer;
begin
  for i:=0 to cxTreeViewRole.Items.Count-1 do
  begin
    cxTreeViewRole.Items[i].ImageIndex:=0;
    cxTreeViewRole.Items[i].SelectedIndex:=0;
  end;
end;

//选择角色记录时，设置菜单树节点选中状态。
procedure TFormUserMgr.SetTreeCheck(aUserID:Integer);
var
  I,lTemp: Integer ;
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,9,aUserID,gPublicParam.cityid]),0);
      Open;

      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        for i:=0 to cxTreeViewRole.Items.Count-1 do
        begin
          if cxTreeViewRole.Items[i].Level=1 then
          begin
            if TRoleInfo(cxTreeViewRole.Items[i].Data).RoleID=FieldByName('RoleId').AsInteger then
            begin
              cxTreeViewRole.Items[i].ImageIndex:=1;
              cxTreeViewRole.Items[i].SelectedIndex:=1;
            end;
          end;
        end;
        Next;
      end;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

function TFormUserMgr.GetCityName(aCityID: Integer): string;
var lClientDataSet : TClientDataSet;
begin
  Result:='';
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([2,304,aCityID]),0);
      if RecordCount=1 then
        Result:= fieldbyname('name').AsString;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormUserMgr.cxButton1Click(Sender: TObject);
var
  lCityID, lUserID, lResult: Integer;
  lVariant: variant;
  lSqlstr,lPwdStr,lUserNO: string;
  lsuccess:Boolean;
begin
  FrmModifyPwd:= TFrmModifyPwd.Create(self);
  try
    lUserID:= ClientDataSet1.fieldbyname('USERID').AsInteger;
    lCityID:= ClientDataSet1.fieldbyname('CITYID').AsInteger;
    lUserNO:= ClientDataSet1.fieldbyname('USERNO').AsString;

    if FrmModifyPwd.ShowModal = MrOk then
    begin
      if FrmModifyPwd.NewPwd1.Text<>FrmModifyPwd.NewPwd2.Text then
      begin
        Application.MessageBox('新密码和确认密码不一致！','修改密码',MB_OK);
        exit;
      end;

      lPwdStr:=gTempInterface.GetMD5(lUserNO,Trim(FrmModifyPwd.NewPwd1.Text));
      lVariant:= VarArrayCreate([0,0],varVariant);
      lSqlstr:='Update fms_user_info set USERPWD='''+lPwdStr+''' '+
               ' WHERE USERID='+inttostr(lUserID)+' and CITYID='+inttostr(lCityID);
      lVariant[0]:= VarArrayOf([lSqlstr]);

      lsuccess:= gTempInterface.ExecBatchSQL(lVariant);
      if lsuccess then
        Application.MessageBox('密码修改成功！','修改密码',MB_OK)
      else
        Application.MessageBox('密码修改失败！','修改密码',MB_OK);
    end;
  finally
    FrmModifyPwd.free;
  end;
end;

end.

