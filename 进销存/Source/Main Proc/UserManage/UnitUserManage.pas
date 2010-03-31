unit UnitUserManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, StdCtrls, ADODB;

type
  TFormUserManage = class(TForm)
    lbllbuser: TLabel;
    ListUser: TListView;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    AdoQuery, AdoEdit: TAdoquery;

    procedure ClearListView;
    procedure GetUserInfo;
  public
    { Public declarations }
  end;

var
  FormUserManage: TFormUserManage;

implementation

uses UnitUserManager, UnitDataModule, UnitPublicResourceManager,
  UnitEditUser;

{$R *.dfm}

procedure TFormUserManage.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  AdoEdit:= TADOQuery.Create(Self);
end;

procedure TFormUserManage.FormShow(Sender: TObject);
begin
  GetUserInfo;
end;

procedure TFormUserManage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormUserManage.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormUserManage.Btn_AddClick(Sender: TObject);
begin
  with TFormEditUser.create(nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TFormUserManage.Btn_ModifyClick(Sender: TObject);
var
  lListItem: TListItem;
begin
  if ListUser.SelCount>0 then
  begin
    lListItem:= ListUser.Selected;
    if (lListItem=nil) and (lListItem.Data=nil) then
      Exit;
    if TFormEditUser.Execute(TUser(lListItem.Data), eumEdit) then
    begin
      ShowMessage(TUser(lListItem.Data).UserName);
    end;
  end;
end;

procedure TFormUserManage.Btn_DeleteClick(Sender: TObject);
var
  lListItem: TListItem;
begin
  if ListUser.SelCount>0 then
  begin
    lListItem:= ListUser.Selected;
    if (lListItem=nil) and (lListItem.Data=nil) then
      Exit;
    if TUser(ListUser.Selected.Data).UserID=CurUser.UserID then
    begin
      Application.MessageBox('不能删除自己！','提示',MB_OK+64);
      Exit;
    end;
    with AdoEdit do
    begin
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'delete from User where UserID=' + IntToStr(TUser(lListItem.Data).UserID);
      ExecSQL;
      GetUserInfo;
    end;
  end;
end;

procedure TFormUserManage.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormUserManage.ClearListView;
var
  I: Integer;
begin
  for i:=0 to ListUser.Items.Count-1 do
  begin
    ListUser.Items[i].Free;
  end;
  ListUser.Clear;
end;

procedure TFormUserManage.GetUserInfo;
var
  lUser: TUser;
  lNewListItem: TListItem;
  lUserRightsStr: string;
begin
  ClearListView;
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT * FROM User';
    Active:= True;
    First;
    while not Eof do
    begin
      lUser:= TUser.create;
      lUser.UserID:= FieldByName('UserID').AsInteger;
      lUser.UserName:= FieldByName('UserName').AsString;
      lUser.PassWord:= FieldByName('UserPWD').AsString;
      lUser.UserType:= FieldByName('UserType').AsInteger;
      lUser.UserRights:= FieldByName('UserRights').AsString;
      case lUser.UserType of
        0: lUserRightsStr:= '管理员';
        1: lUserRightsStr:= '营业员';
      end; 
      lNewListItem:= ListUser.Items.Add;
      lNewListItem.Data:= lUser;
      lNewListItem.Caption:= lUser.UserName;
      lNewListItem.SubItems.Add(lUserRightsStr);
      Next;
    end;
  end;
end;

end.
