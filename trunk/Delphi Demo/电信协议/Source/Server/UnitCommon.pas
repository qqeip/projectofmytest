unit UnitCommon;

interface

uses Windows;

type
  {ҵ������Ϣ��������}
  Tcmd = record
    command: integer;
  end;
  {�û���Ϣ����}
  PUserData = ^TUserData;
  TUserData = record
    IP: string[20];
    ConnectTime: TDateTime;
    UserID :integer;
    UserNo :String[20];
  end;
implementation

end.
