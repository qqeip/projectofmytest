library AreaMgr;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Forms,
  ProjectCFMS_Server_TLB in '..\..\..\服务端\ProjectCFMS_Server_TLB.pas',
  UnitAreaMgr in 'UnitAreaMgr.pas' {FormAreaMgr},
  UnitVFMSGlobal in '..\..\框架文件\UnitVFMSGlobal.pas',
    UnitDllCommon in '..\..\框架文件\UnitDllCommon.pas';

{$R *.res}

  function CallDll(Application:TApplication;TempInterface:IDataModuleRemoteDisp;PublicParam:TPublicParameter):TForm;
  begin
    Result:= nil;
    if Assigned(FormAreaMgr) then Exit;
    gTempInterface:=TempInterface;
    gPublicParam:=PublicParam;
    FormAreaMgr:=TFormAreaMgr.create(Application);
    Result:=FormAreaMgr;
  end;

  procedure CloseForm;stdcall;
  begin
    if Assigned(FormAreaMgr) then
    begin
      FreeAndNil(FormAreaMgr);
    end;
  end;

  exports
    CallDll,
    CloseForm;
end.
end.
 