{
    这个单元管理系统中所有存在的资源，和资源相关的全局变量都放在这里
}

unit UnitPublicResourceManager;

interface

uses
  SysUtils, UnitUserManager, UnitRepertoryManager;

var
  CurUser: TUser;
  CurBackUPDir: string;

  procedure initAllScreenAndFormResources;
  procedure freeAllScreenAndFormResources;

implementation

  procedure initAllScreenAndFormResources;
  begin
    CurUser:= TUser.Create;
  end;

  procedure freeAllScreenAndFormResources;
  begin
    FreeAndNil(CurUser);
  end;



end.
