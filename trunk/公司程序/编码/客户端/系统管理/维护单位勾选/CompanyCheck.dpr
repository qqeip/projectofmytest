library CompanyCheck;

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
  UnitCompanyCheck in 'UnitCompanyCheck.pas' {FormCompanyCheck},
  UnitVFMSGlobal in '..\..\����ļ�\UnitVFMSGlobal.pas',
  UnitDllCommon in '..\..\����ļ�\UnitDllCommon.pas',
  ProjectCFMS_Server_TLB in '..\..\..\�����\ProjectCFMS_Server_TLB.pas';

{$R *.res}

  function CallDll(Application:TApplication;TempInterface:IDataModuleRemoteDisp;PublicParam:TPublicParameter;DllMessageCall: TDllMessage):TForm;
  begin
    Result:= nil;
    if Assigned(FormCompanyCheck) then Exit;
    gTempInterface:=TempInterface;
    gPublicParam:=PublicParam;
    gDllMsgCall := @DllMessageCall;
    FormCompanyCheck:=TFormCompanyCheck.create(Application);
    Result:=FormCompanyCheck;
  end;

  procedure CloseForm;stdcall;
  begin
    if Assigned(FormCompanyCheck) then
    begin
      FreeAndNil(FormCompanyCheck);
    end;
  end;

  procedure LocateTreeNode(aNodeText: string);stdcall;
  begin
//    if Assigned(FormAlarmTracker) then
//    begin
//      LocateSigleNode(FormAlarmTracker.cxTreeView1,aNodeText);
//    end;
  end;

  exports
    CallDll,
    CloseForm,
    LocateTreeNode;
    
end.
 