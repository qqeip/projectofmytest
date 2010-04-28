library AlarmManualMgr;

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
  UnitAlarmManual in 'UnitAlarmManual.pas' {FormAlarmManual},
  UnitVFMSGlobal in '..\..\框架文件\UnitVFMSGlobal.pas',
  UnitDllCommon in '..\..\框架文件\UnitDllCommon.pas',
  ProjectCFMS_Server_TLB in '..\..\..\服务端\ProjectCFMS_Server_TLB.pas',
  UnitDBVerticalGridEditor in '..\..\框架文件\UnitDBVerticalGridEditor.pas' {FrameDBVerticalGridEditor: TFrame},
  UnitAlarmMgr in 'UnitAlarmMgr.pas' {FormAlarmMgr},
  UnitCFMSTreeHelper in '..\..\框架文件\UnitCFMSTreeHelper.pas';


{$R *.res}

  function CallDll(Application:TApplication;TempInterface:IDataModuleRemoteDisp;PublicParam: TPublicParameter; DllMessageCall: TDllMessage):TForm;
  begin
    Result:= nil;
    if Assigned(FormAlarmManual) then Exit;
    gTempInterface:= TempInterface;
    gPublicParam:= PublicParam;
    gDllMsgCall := @DllMessageCall;
    FormAlarmManual:=TFormAlarmManual.create(Application);
    Result:=FormAlarmManual;
  end;

  procedure CloseForm;stdcall;
  begin
    if Assigned(FormAlarmManual) then
    begin
      FreeAndNil(FormAlarmManual);
    end;
  end;

  procedure LocateTreeNode(aNodeText: string);stdcall;
  var
    i, j: Integer;
    lStr: string;
    fCFMS_TreeHelper:TCFMS_TreeHelper;
  begin
    lStr:= aNodeText;
    if Assigned(FormAlarmManual) then
    begin
      FormAlarmManual.FIsGotoAlarmManual:= 1;  //是从重复告警转人工的
      j:= 0;
      while Pos(',',lStr)>0 do
      begin
        i:= Pos(',',lStr);
        case j of
        0:
          FormAlarmManual.FDeviceID:= StrToInt(Copy(lStr,0,i-1));
        1:
          FormAlarmManual.FCoDeviceID:= StrToInt(Copy(lStr,0,i-1));
        2:
          FormAlarmManual.FContentCode:= StrToInt(Copy(lStr,0,i-1));
        end;
        Delete(lStr,1,i);
        Inc(j);
      end;
      FormAlarmManual.FAlarmCaption:= lStr;
      FormAlarmManual.Memo1.Text:= FormAlarmManual.FAlarmCaption;
      
      fCFMS_TreeHelper:= TCFMS_TreeHelper.Create(FormAlarmManual.cxTreeView1,gPublicParam.Cityid,gPublicParam.RuleCompanyidStr);
      fCFMS_TreeHelper.gExactOrFuzzySearching:= 1;
      fCFMS_TreeHelper.RefreshTree(IntToStr(FormAlarmManual.FDeviceID),5,5,true);
    end;
  end;

  exports
    CallDll,
    CloseForm,
    LocateTreeNode;
end.
