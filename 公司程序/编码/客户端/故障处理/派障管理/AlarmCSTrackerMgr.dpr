library AlarmCSTrackerMgr;

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
  UnitVFMSGlobal in '..\..\框架文件\UnitVFMSGlobal.pas',
  UnitDllCommon in '..\..\框架文件\UnitDllCommon.pas',
  ProjectCFMS_Server_TLB in '..\..\..\服务端\ProjectCFMS_Server_TLB.pas',
  UnitAlarmCSTracker in 'UnitAlarmCSTracker.pas' {FormAlarmCSTracker},
  UnitUserSign in 'UnitUserSign.pas' {FormUserSign},
  UnitFaultStaySet in '..\故障监视\UnitFaultStaySet.pas' {FormFaultStaySet},
  UnitAlarmChange in 'UnitAlarmChange.pas' {FormAlarmChange},
  UnitSubmitInfo in 'UnitSubmitInfo.pas' {FormSubmitInfo};

{$R *.res}

  function CallDll(Application:TApplication;TempInterface:IDataModuleRemoteDisp;PublicParam: TPublicParameter; DllMessageCall: TDllMessage):TForm;
  begin
    Result:= nil;
    if Assigned(FormAlarmCSTracker) then Exit;
    gTempInterface:= TempInterface;
    gPublicParam:= PublicParam;
    gDllMsgCall := @DllMessageCall;
    FormAlarmCSTracker:=tFormAlarmCSTracker.create(Application);
    Result:=FormAlarmCSTracker;
  end;

  procedure CloseForm;stdcall;
  begin
    Application.OnMessage :=nil;
    if Assigned(FormAlarmCSTracker) then
    begin
      FreeAndNil(FormAlarmCSTracker);
    end;
  end;

  procedure LocateTreeNode(aNodeText: string);stdcall;
  begin
    //
  end;

  exports
    CallDll,
    CloseForm,
    LocateTreeNode;
end.
