library BreakSiteStat;

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
  Forms,
  Classes,
  UnitVFMSGlobal in '..\..\框架文件\UnitVFMSGlobal.pas',
  UnitDllCommon in '..\..\框架文件\UnitDllCommon.pas',
  ProjectCFMS_Server_TLB in '..\..\..\服务端\ProjectCFMS_Server_TLB.pas',
  UnitBreakSiteStat in 'UnitBreakSiteStat.pas' {FormBreakSiteStat},
  UnitBreakSiteDetail in 'UnitBreakSiteDetail.pas' {FormBreakSiteDetail};

{$R *.res}

  function CallDll(Application:TApplication;TempInterface:IDataModuleRemoteDisp;PublicParam: TPublicParameter; DllMessageCall: TDllMessage):TForm;
  begin
    Result:= nil;
    if Assigned(FormBreakSiteStat) then Exit;
    gTempInterface:= TempInterface;
    gPublicParam:= PublicParam;
    gDllMsgCall := @DllMessageCall;
    FormBreakSiteStat:=TFormBreakSiteStat.create(Application);
    Result:=FormBreakSiteStat;
  end;

  procedure CloseForm;stdcall;
  begin
    if Assigned(FormBreakSiteStat) then
    begin
      FreeAndNil(FormBreakSiteStat);
    end;
  end;

  procedure LocateTreeNode(aNodeText: string);stdcall;
  begin
   
  end;

  exports
    CallDll,
    CloseForm,
    LocateTreeNode;
end.
 