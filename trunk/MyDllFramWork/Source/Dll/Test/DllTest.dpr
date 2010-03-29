library DllTest;

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
  forms,
  UnitTest in 'UnitTest.pas' {FormTest},
  UnitDllPublic in '..\..\Common\UnitDllPublic.pas';

{$R *.res}

  function CallDll(Application:TApplication; DllCloseRecall:TDllCloseRecall):TForm;
  begin
    Result:= nil;
    if Assigned(FormTest) then Exit;
    FDllCloseRecall:= DllCloseRecall;
    FormTest:=TFormTest.create(Application);
    Result:=FormTest;
  end;

  procedure CloseForm;stdcall;
  begin
    if Assigned(FormTest) then
    begin
      FreeAndNil(FormTest);
    end;
  end;

  exports
    CallDll,
    CloseForm;

end.
