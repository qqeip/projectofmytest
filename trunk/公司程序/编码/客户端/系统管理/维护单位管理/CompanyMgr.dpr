library CompanyMgr;

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
  UnitVFMSGlobal in '..\..\框架文件\UnitVFMSGlobal.pas',
  UnitDllCommon in '..\..\框架文件\UnitDllCommon.pas',
  UnitCompanySet in 'UnitCompanySet.pas' {FormCompanySet},
  UnitBaseShowModal in '..\..\框架文件\UnitBaseShowModal.pas' {FormBaseShowModal},
  UnitCompanyInfo in 'UnitCompanyInfo.pas' {FormCompanyInfo},
  UnitDeviceGatherInfo in 'UnitDeviceGatherInfo.pas' {FormDeviceGatherInfo},
  UnitContentModelInfo in 'UnitContentModelInfo.pas' {FormContentModelInfo};

{$R *.res}

  function CallDll(Application:TApplication;TempInterface:IDataModuleRemoteDisp;PublicParam:TPublicParameter;DllMessageCall: TDllMessage):TForm;
  begin
    Result:= nil;
    if Assigned(FormCompanySet) then Exit;
    gTempInterface:=TempInterface;
    gPublicParam:= PublicParam;
    gDllMsgCall := @DllMessageCall;
    FormCompanySet:=TFormCompanySet.create(Application);
    Result:=FormCompanySet;
  end;

  procedure CloseForm;stdcall;
  begin
    if Assigned(FormCompanySet) then
    begin
      FreeAndNil(FormCompanySet);
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
 