unit UnitCommon;

interface

uses Windows;

type
  {ҵ������Ϣ��������}
  TCmd = record
    Command: Integer;
  end;
  {�û���Ϣ����}
  TUserData = record
    IP: string[20];
    ConnectTime: TDateTime;
    UserID :Integer;
    UserNo :String[20];
  end;
implementation

end.
