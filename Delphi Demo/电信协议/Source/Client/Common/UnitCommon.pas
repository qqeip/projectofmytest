unit UnitCommon;

interface

uses Windows;

type
  {业务处理消息数据类型}
  TCmd = record
    Command: Integer;
  end;
  {用户信息类型}
  TUserData = record
    IP: string[20];
    ConnectTime: TDateTime;
    UserID :Integer;
    UserNo :String[20];
  end;
implementation

end.
