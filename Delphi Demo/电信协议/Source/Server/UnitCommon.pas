unit UnitCommon;

interface

uses Windows;

type
  {业务处理消息数据类型}
  Tcmd = record
    command: integer;
  end;
  {用户信息类型}
  PUserData = ^TUserData;
  TUserData = record
    IP: string[20];
    ConnectTime: TDateTime;
    UserID :integer;
    UserNo :String[20];
  end;
implementation

end.
