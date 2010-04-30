{
    �����Ԫ����ϵͳ�����д��ڵ���Դ������Դ��ص�ȫ�ֱ�������������
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
