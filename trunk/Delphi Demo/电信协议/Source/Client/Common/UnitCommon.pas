unit UnitCommon;

interface

uses Windows;

type
  {ҵ������Ϣ��������}
  Tcmd = record
    command: integer;
  end;
  {�û���Ϣ����}
  Ruserdata = record
    userid :integer;
    userno :String[20];
    CompanyID :integer;
    cityid :integer;
    parentid :integer;
    Filter :String[20];
    ParentList :String[200];
    ChildList :String[200];
  end;
implementation

end.
