unit UnitCommon;

interface

uses Windows;

type
  {ҵ������Ϣ��������}
  Tcmd = record
    command: integer;
  end;
  {�û���Ϣ����}
  TUserData = record
    UserID :integer;
    UserNo :String[20];
    CompanyID :integer;
    CityID :integer;
    ParentID :integer;
    Filter :String[20];
    ParentList :String[200];
    ChildList :String[200];
  end;
implementation

end.
