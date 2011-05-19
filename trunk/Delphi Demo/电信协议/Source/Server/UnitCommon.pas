unit UnitCommon;

interface

uses Windows;

type
  {业务处理消息数据类型}
  TCmd = record
    Command: Integer;
  end;
  
  {广播消息结构体}
  TBroadMsg = record
    Msg :String[255];
  end;

  {用户信息类型}
  PUserData = ^TUserData;
  TUserData = record
    IP: string[20];
    ConnectTime: TDateTime;
    UserID :Integer;
    UserNo :String[20];
    Thread: Pointer;
  end;

implementation

end.
