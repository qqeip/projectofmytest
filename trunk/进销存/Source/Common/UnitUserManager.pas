unit UnitUserManager;

interface

type
  PUser = ^Tuser;
  TUser = class
  private
    FUserID: Integer;
    FUserName: string;
    FPassWord: string;
    FUserType: string; //�û����ͣ�����Ա or ӪҵԱ
    FLogInType: Integer; //�û���½���ͣ���¼ or �˳� or ע�� 1,2,3
    FUserRights: string; //�û�Ȩ��
    procedure SetUserName(const Value: string);
    procedure SetPassWord(const Value: string);
    procedure SetUserType(const Value: string);
    procedure SetUserRight(const Value: string);
    procedure SetUserID(const Value: Integer);
  public
    constructor create;
    destructor destroy;override;
  public
    property UserID: Integer read FUserID write SetUserID;
    property UserName: string read FUserName write SetUserName;
    property PassWord: string read FPassWord write SetPassWord;
    property UserType: string read FUserType write SetUserType;
    property LonInType: Integer read FLogInType write FLogInType;
    property UserRights: string read FUserRights write SetUserRight;
  end;

implementation

{ TUser }

procedure TUser.SetUserID(const Value: Integer);
begin
  FUserID := Value;
end;

procedure TUser.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

procedure TUser.SetPassWord(const Value: string);
begin
  FPassWord := Value;
end;

procedure TUser.SetUserType(const Value: string);
begin
  FUserType := Value;
end;

procedure TUser.SetUserRight(const Value: string);
begin
  FUserRights := Value;
end;

constructor TUser.create;
begin
  inherited create; 
end;

destructor TUser.destroy;
begin

  inherited;
end;

end.

