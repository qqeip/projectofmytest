unit UntFunc;

interface

uses Classes, Windows, SysUtils;

{  函数CheckThreadStatus各返回值的说明
    0: '线程已释放!';
    1: '线程正在运行!';
    2: '线程已终止但未释放';
    3: '线程未建立或不存在';
}
function CheckThreadStatus(aThread: TThread): Integer;

implementation

function CheckThreadStatus(aThread: TThread): Integer;
var
    I: DWORD;
    IsQuit: Boolean;
begin
     if Assigned(aThread) then
     begin
       //执行成功返回true，退出码被i指向内存记录
       IsQuit := GetExitCodeThread(aThread.Handle, i);
       if IsQuit then
       begin
         // STILL_ACTIVE :线程仍然在执行
         if i = STILL_ACTIVE then
           Result := 1
         else
           Result := 2;              //aThread未Free，因为Tthread.Destroy中有执行语句
       end
       else
         Result := 0;                //可以用GetLastError取得错误代码     Ret:Integer; Ret:=GetLastError; Ret=ERROR_ALREADY_EXISTS
     end
     else
       Result := 3;
end;   

end.
