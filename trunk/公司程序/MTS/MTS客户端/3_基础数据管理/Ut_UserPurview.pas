unit Ut_UserPurview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst, DB, DBClient, Ut_common, Md5;

type
  TFm_UserUpdate = class(TForm)
    Gb_UserFun: TGroupBox;
    Panel3: TPanel;
    CB_FunAll: TCheckBox;
    GB_User: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    L_Email: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Button2: TButton;
    Edt_accounts: TEdit;
    Edt_name: TEdit;
    Edt_email: TEdit;
    Edt_dep: TEdit;
    Edt_OP: TEdit;
    Edt_MP: TEdit;
    Btn_Save: TButton;
    CLB_function: TCheckListBox;
    Cmb_Sex: TComboBox;
    Label5: TLabel;
    Label8: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure CB_FunAllClick(Sender: TObject);
    procedure Btn_SaveClick(Sender: TObject);
    procedure Edt_OPKeyPress(Sender: TObject; var Key: Char);
    procedure Edt_MPKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Procedure FillUserInfo(vUserId:String) ;
    function CheckUserExist(userno:String):Boolean;overload;
    function CheckUserExist(userid:Integer;userno:String):Boolean;overload;
  public
    { Public declarations }
    OperateFlag : Integer; // 1 : add;2 modify
  end;

var
  Fm_UserUpdate: TFm_UserUpdate;

implementation

uses Ut_DataModule,Ut_MainForm,Ut_UserInfoMag;
{$R *.dfm}

procedure TFm_UserUpdate.Btn_SaveClick(Sender: TObject);
var
  shint      : String ;
  vuserid    : String ; //用户帐号
  vDeltaArray: OleVariant;
  vProviderArray: OleVariant;
  vCDSArray: array[0..1] of TClientDataset;
begin
  if (trim(Edt_accounts.Text)='') or (trim(Edt_name.Text)='') then
  begin
    application.MessageBox('信息不全,请核对！','提示',mb_ok+mb_defbutton1);
    Exit;
  end;
  if OperateFlag = ADDFLAG then
      shint :='确定要新增此用户吗？'
  else if OperateFlag = MODIFYFLAG then
      shint :='确定要修改此用户吗？' ;
  if application.MessageBox(Pchar(shint), '提示', mb_okcancel + mb_defbutton1) = idcancel then
     Exit;
  if OperateFlag = ADDFLAG  then
  begin
    if CheckUserExist(trim(Edt_accounts.Text)) then
    begin
      application.MessageBox('此用户帐户已存在！','提示',mb_ok+mb_defbutton1);
      Exit;
    end ;
    vuserid:= IntToStr(Dm_MTS.TempInterface.ProduceFlowNumID('USERID',1));
  end
  else if  OperateFlag = MODIFYFLAG  then
  begin
    vuserid:=inttostr(Fm_UserInfoMag.lUserID);
    if CheckUserExist(strtoint(vuserid),trim(Edt_accounts.Text)) then
    begin
      application.MessageBox('此用户帐户已存在！','提示',mb_ok+mb_defbutton1);
      Exit;
    end;

  end;
  FillUserInfo(vuserid);
  try
    try
      vCDSArray[0]:=Dm_MTS.cds_common;
      vCDSArray[1]:=Dm_MTS.cds_common1;
      vDeltaArray:=RetrieveDeltas(vCDSArray);
      vProviderArray:=RetrieveProviders(vCDSArray);
      if not Dm_MTS.TempInterface.CDSApplyUpdates(vDeltaArray, vProviderArray, null) then
        SysUtils.Abort;
      application.MessageBox('用户信息保存成功！', '提示', mb_ok + mb_defbutton1);
    except
      application.MessageBox('用户信息保存失败，请检查后重试！', '提示', mb_ok + mb_defbutton1);
    end;
  finally
    //刷新数据
     Close;
    //SearchUserInfo(nil);
    //Dm_MTS.cds_common.Locate('USERID',vuserid,[loCaseInsensitive]);



  end;
end;

procedure TFm_UserUpdate.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFm_UserUpdate.CB_FunAllClick(Sender: TObject);
var
  i : integer;
  bCheck :Boolean;
begin
  bCheck := CB_FunAll.Checked;
  for i := 0 to CLB_function.Count-1 do
    CLB_function.Checked[i] := bCheck;
end;

function TFm_UserUpdate.CheckUserExist(userid:Integer;userno:String): Boolean;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:= Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,5,userid,userno]),0);
    if isEmpty then
      result := false
    else
      result := true;
    Close;
  end;
end;

procedure TFm_UserUpdate.FillUserInfo(vUserId: String);
var
  i :Integer;
begin
  With Dm_MTS.cds_common,Fm_MainForm.PublicParam do
  Begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,6,vUserId]),0);   //
    If OperateFlag = DELETEFLAG Then
    begin
      Delete ;
    end
    Else begin
      If OperateFlag = ADDFLAG Then
      begin
        Append ;
        FieldByName('CreateDATE').Value:= Date;
        FieldByName('Creator').Value:= userid;
        FieldByName('Cityid').Value:= Fm_UserInfoMag.city_id;
        FieldByName('Areaid').Value:= Fm_UserInfoMag.area_id;
      end
      Else
      begin
        Edit ;
        FieldByName('MODIFYDATE').Value:= Date;
      end;

      FieldByName('USERID').Value    := vUserId;
      FieldByName('USERNO').Value    := Trim(Edt_accounts.Text);
      FieldByName('USERNAME').Value  := Trim(Edt_name.Text);
      FieldByName('UserPWD').Value   := LogEntry(MD5String(Trim(Edt_accounts.Text)+String('')));
      FieldByName('EMAIL').Value     := Trim(Edt_Email.Text);
      FieldByName('Sex').Value       := Cmb_Sex.ItemIndex;
      FieldByName('DEPT').Value    := Trim(Edt_dep.Text);;
      FieldByName('OFFICEPHONE').Value  := Trim(Edt_OP.Text);
      FieldByName('MobilePHONE').Value  := Trim(Edt_MP.Text);
      FieldByName('Flag').Value      := 1;    //1 活动
    end;

  end;
  //权限
  with Dm_MTS.cds_common1 Do
  begin
    Close;
    ProviderName:='dsp_General_data1';
    Data:= Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,7,vUserId]),1) ;
    If OperateFlag = DELETEFLAG Then
      begin
        For i:=0 To RecordCount-1 Do
           Delete ;
      end
    Else
      For i:=0 To CLB_function.Items.Count -1 Do
      begin
        If CLB_function.Checked[i] Then
          begin
            If Not Locate('ModuleID',TCommonObj(CLB_function.Items.Objects[i]).ID,[loCaseInsensitive, loPartialKey]) Then
            begin
              Append;
              FieldByName('UserID').Value := vUserId ;
              FieldByName('ModuleID').Value  := TCommonObj(CLB_function.Items.Objects[i]).ID;
            end;
          end
        else
          begin
            If Locate('ModuleID',TCommonObj(CLB_function.Items.Objects[i]).ID,[loCaseInsensitive,lopartialkey]) Then
            begin
              Delete;
            end;
          end;
      end;
  end;
end;
function TFm_UserUpdate.CheckUserExist(userno: String): Boolean;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:= Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,5,userno]),0);
    if isEmpty then
      result := false
    else
      result := true;
    Close;
  end;
end;

procedure TFm_UserUpdate.Edt_MPKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8,#3,#22,'-']) then
      key := #0;
end;

procedure TFm_UserUpdate.Edt_OPKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8,#3,#22,'-']) then
      key := #0;
end;

end.
