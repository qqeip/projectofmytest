unit UnitRemoteLibary;

{数据访问交互单元}
{by 滕启荣 5月31日 QQ：317877706；Tel:15850543069}
{索取DLL源码请联系我}

interface

  uses  Windows, Messages, SysUtils, Variants, Classes,Controls,ExtCtrls,forms;

type
    TGetdatas=function (RoServerAddress:string;Iport:Integer;var vDatas:OleVariant):Boolean; stdcall;
    TSetdatas=function (RoServerAddress:string;Iport:Integer;var vDatas:OleVariant):Boolean; stdcall;
    function Getdatas(RoServerAddress:string;Iport:Integer;var vDatas:OleVariant):Boolean;
    function Setdatas(RoServerAddress:string;Iport:Integer;var vDatas:OleVariant):Boolean;
    function MakeVarSql(SqlList:TStringList;var vSql:OleVariant):Boolean;
    procedure ShowVarError(HD:hwnd;vErrors:olevariant;sErr:string);

implementation

function MakeVarSql(SqlList:TStringList;var vSql:OleVariant):Boolean;
var
  i:Integer;
begin
Result:=False;
try
  if SqlList.Count=0 then
     vSql:=''
  else
  begin
    vSql:=VarArrayCreate([0, SqlList.Count-1], varvariant);
    for i:=0 to SqlList.Count-1 do
    vSql[i]:=SqlList.Strings[i];
  end;
  Result:=true;
except
end;
end;

procedure ShowVarError(HD:hwnd;vErrors:olevariant;sErr:string);
var
  sError:string;
  icount:integer;
begin
  try
    if sErr<>'' then
      sError:=sErr+#13#10;
    if VarIsArray(vErrors) then
    begin
        for iCount:=VarArrayLowBound(vErrors,1) to VarArrayHighBound(vErrors,1) do
        begin
           if (trim(vErrors[iCount])<>'') then
           begin
             if icount>0 then
             begin
                if (trim(vErrors[iCount]))<>(trim(vErrors[iCount-1])) then
                sError:=sError+vErrors[iCount]+#13#10;
             end
             else
                sError:=sError+vErrors[iCount]+#13#10;
           end;
        end;
    end
    else
    begin
       sError:=sError+String(vErrors)+#13#10;
    end;
  except
    sError:=sError+'未知错误！'+#13#10;
  end;
  sError:=copy(sError,1,length(sError)-2);
  if HD<>0 then
    messagebox(HD,pchar(sError),'错误',MB_ICONError+mb_ok);
end;

function Getdatas(RoServerAddress:string;Iport:Integer;var vDatas:OleVariant):Boolean;
var
  DllHandle:THandle;
  ProcAddr:FarProc;
  _GetDatas:TSetdatas;
begin
      if not FileExists(ExtractFilePath(Application.ExeName)+'DLL\DllDataAccessObject.dll') then
      begin
        vDatas:='DLL目录下缺少动态连接库文件"DllDataAccessObject.dll"';
        Result:=False;
        exit;
      end;
      DllHandle := GetModuleHandle(pChar(ExtractFilePath(Application.ExeName)+'DLL\DllDataAccessObject.dll'));
      if DllHandle=0 then
      DllHandle := LoadLibrary(pChar(ExtractFilePath(Application.ExeName)+'DLL\DllDataAccessObject.dll'));
      if DllHandle<>0 then
      begin
        ProcAddr := GetProcAddress(DllHandle, pchar('GetRemoDatas'));
        if ProcAddr <> nil then
        begin
            _GetDatas:=ProcAddr;
            if _GetDatas(RoServerAddress,Iport,vDatas) then
               Result:=True
            else
               Result:=False;
            FreeLibrary(DllHandle);
        end
        else
        begin
            vDatas:='动态链接库DllDataAccessObject.dll内部错误!';
            Result:=False;
        end;
      end
      else
      begin
          vDatas:='装载动态链接库DllDataAccessObject.dll失败!';
          Result:=False;
      end;
end;

function Setdatas(RoServerAddress:string;Iport:Integer;var vDatas:OleVariant):Boolean;
var
  DllHandle:THandle;
  ProcAddr:FarProc;
  _SetDatas:TSetdatas;
begin
      if not FileExists(ExtractFilePath(Application.ExeName)+'DLL\DllDataAccessObject.dll') then
      begin
        vDatas:='DLL目录下缺少动态连接库文件"DllDataAccessObject.dll"';
        Result:=False;
        exit;
      end;
      DllHandle := GetModuleHandle(pChar(ExtractFilePath(Application.ExeName)+'DLL\DllDataAccessObject.dll'));
      if DllHandle=0 then
      DllHandle := LoadLibrary(pChar(ExtractFilePath(Application.ExeName)+'DLL\DllDataAccessObject.dll'));
      if DllHandle<>0 then
      begin
        ProcAddr := GetProcAddress(DllHandle, pchar('RemoteSetDatas'));
        if ProcAddr <> nil then
        begin
            _SetDatas:=ProcAddr;
            if _SetDatas(RoServerAddress,Iport,vDatas) then
               Result:=True
            else
               Result:=False;
            FreeLibrary(DllHandle);   
        end
        else
        begin
            vDatas:='动态链接库DllDataAccessObject.dll内部错误!';
            Result:=False;
        end;
      end
      else
      begin
          vDatas:='装载动态链接库DllDataAccessObject.dll失败!';
          Result:=False;
      end;
end;

end.
