library CapacityMonitor;


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
  UnitVFMSGlobal in '..\..\����ļ�\UnitVFMSGlobal.pas',
  UnitDllCommon in '..\..\����ļ�\UnitDllCommon.pas',
  ProjectCFMS_Server_TLB in '..\..\..\�����\ProjectCFMS_Server_TLB.pas',
  UnitCapacityMonitor in 'UnitCapacityMonitor.pas' {FormCapacityMonitor};

{$R *.res}

  function CallDll(Application:TApplication;TempInterface:IDataModuleRemoteDisp;PublicParam: TPublicParameter; DllMessageCall: TDllMessage):TForm;
  begin
    Result:= nil;
    if Assigned(FormCapacityMonitor) then Exit;
    gTempInterface:= TempInterface;
    gPublicParam:= PublicParam;
    gDllMsgCall := @DllMessageCall;
    FormCapacityMonitor:=TFormCapacityMonitor.create(Application);
    Result:=FormCapacityMonitor;
  end;

  procedure CloseForm;stdcall;
  begin
    if Assigned(FormCapacityMonitor) then
    begin
      FreeAndNil(FormCapacityMonitor);
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
 