unit UnitPatrolAppSrv;

interface

uses
  Windows, SysUtils, Tlhelp32, shellapi;

  function IsAppRespondig(wnd:   HWND): integer;
  function KillTask(ExeFileName: string): Integer;
  Function RunTheApp(ExeFileName: string): Boolean;
  function SeparatePath(ThePath:string):string;
implementation

//   For   Win9X/ME
function   IsAppRespondig9X(dwThreadId:   DWORD):   Boolean;
type
    TIsHungThread   =   function(dwThreadId:   DWORD):   BOOL;   stdcall;
var
    hUser32:   THandle;
    IsHungThread:   TIsHungThread;
begin
    Result   :=   True;
    hUser32   :=   GetModuleHandle('user32.dll');
    if   (hUser32   >   0)   then
    begin
        @IsHungThread   :=   GetProcAddress(hUser32,   'IsHungThread');
        if   Assigned(IsHungThread)   then
        begin
            Result   :=   not   IsHungThread(dwThreadId);
        end;
    end;
end;

//   For   Win   NT/2000/XP     
function   IsAppRespondigNT(wnd:   HWND):   Boolean;
type
    TIsHungAppWindow   =   function(wnd:hWnd):   BOOL;   stdcall;     
var     
    hUser32:   THandle;     
    IsHungAppWindow:   TIsHungAppWindow;     
begin
    Result   :=   True;     
    hUser32   :=   GetModuleHandle('user32.dll');     
    if   (hUser32   >   0)   then     
    begin     
        @IsHungAppWindow   :=   GetProcAddress(hUser32,   'IsHungAppWindow');
        if   Assigned(IsHungAppWindow)   then     
        begin     
            Result   :=   not   IsHungAppWindow(wnd);     
        end;     
    end;
end;     

function   IsAppRespondig(Wnd:   HWND):   Integer;
begin     
  if   IsWindow(Wnd)   then
    if   Win32Platform   =   VER_PLATFORM_WIN32_NT   then
      if IsAppRespondigNT(wnd) then
        Result   := 1
      else
        Result   := 0
    else
      if IsAppRespondig9X(GetWindowThreadProcessId(Wnd,nil)) then
        Result   := 1
      else
        Result   := 0
  else
    Result:=-1;
end;

function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))=
       UpperCase(ExeFileName))
    or (UpperCase(FProcessEntry32.szExeFile) =
       UpperCase(ExeFileName))) then
    Result := Integer(TerminateProcess(OpenProcess(
              PROCESS_TERMINATE, BOOL(0),
              FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32);
  end;
end;

Function RunTheApp(ExeFileName: string):Boolean;
var
//´°¿Ú¾ä±ú
   hCurWindow:HWnd;
begin
  hCurWindow:=0;
  if ShellExecute(hCurWindow,'Open',pchar(ExeFileName),nil,nil, SW_SHOW ) >0 then
    Result:=true
  else
    Result:=false;
end;

function SeparatePath(ThePath:string):string;
begin
  Result:=trim(ThePath);
  if copy(Result,0,1)='\' then
  delete(Result,0,1);
  while Pos('\',Result)>0 do
  begin
     Result:=copy(Result,Pos('\',Result)+1,Length(Result));
  end;
end;

end.
