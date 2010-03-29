unit UnitDataModule;

interface

uses
  SysUtils, Classes, Forms, Windows, DB, ADODB;

type
  TDM = class(TDataModule)
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure ConnectDatabase;
    { Private declarations }
  public
    { Public declarations }
    function LocateUser(aUserName, aUserPWD: string): Boolean;
  end;

var
  DM: TDM;

implementation

uses UnitResource, UnitPublicResourceManager;

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  ConnectDatabase;
end;

procedure TDM.ConnectDatabase;
begin
  try
    ADOConnection.Connected:= False;
    ADOConnection.ConnectionString:= Format(sDatabaseStr,[sDatabaseUserPWD,sDataBaseName,sDataBaseName]);
    ADOConnection.Connected:= True;
  except
    Application.MessageBox('数据库连接失败！','提示信息',MB_OK+64);
  end;
end;

function TDM.LocateUser(aUserName, aUserPWD: string): Boolean;
begin
  result:= False;
  with ADOQuery do
  begin
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'select * from user where username=''' + aUserName + ''' and userpwd=''' + aUserPWD + '''';
    Active:= True;
    if recordcount=0 then
    begin
//      Application.MessageBox('用户不存在！','提示信息',MB_OK+64);
      Exit;
    end;
    if recordCount=1 then
    begin
      CurUser.UserID:= FieldByName('UserID').AsInteger;
      CurUser.UserName:= FieldByName('UserName').AsString;
      CurUser.PassWord:= FieldByName('UserPWD').AsString;
      CurUser.UserType:= FieldByName('UserType').AsString;
      CurUser.UserRights:= FieldByName('UserRights').AsString;
      result:= True;
    end;
    Active:= False;
  end;
end;

end.
