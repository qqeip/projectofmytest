unit UnitCommon;

interface

uses Windows;

type
  {ҵ������Ϣ��������}
  TCmd = record
    Command: Integer;
  end;
  
  {�㲥��Ϣ�ṹ��}
  TBroadMsg = record
    Msg :String[255];
  end;

  {�û���Ϣ����}
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
