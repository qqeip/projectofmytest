library GetPingResult;

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
  UnitDllPublic in '..\..\Source\Client\Common\UnitDllPublic.pas',
  UnitGetPingResult in 'UnitGetPingResult.pas' {FormGetPingResult};

{$R *.res}

function CallDll(Application:TApplication; DllCloseRecall:TDllCloseRecall):TForm;
  begin
    Result:= nil;
    if Assigned(FormGetPingResult) then Exit;
    FDllCloseRecall:= DllCloseRecall;
    FormGetPingResult:=TFormGetPingResult.create(Application);
    Result:=FormGetPingResult;
  end;

  procedure CloseForm;stdcall;
  begin
    if Assigned(FormGetPingResult) then
    begin
      FreeAndNil(FormGetPingResult);
    end;
  end;

  exports
    CallDll,
    CloseForm;

end.

 