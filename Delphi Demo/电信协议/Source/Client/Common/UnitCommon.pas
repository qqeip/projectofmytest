unit UnitCommon;

interface

uses Windows;

type
  {业务处理消息数据类型}
  Tcmd = record
    command: integer;
  end;
  {用户信息类型}
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
