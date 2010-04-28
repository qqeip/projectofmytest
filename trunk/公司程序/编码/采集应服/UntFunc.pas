unit UntFunc;

interface

uses Classes, Windows, SysUtils;

{  ����CheckThreadStatus������ֵ��˵��
    0: '�߳����ͷ�!';
    1: '�߳���������!';
    2: '�߳�����ֹ��δ�ͷ�';
    3: '�߳�δ�����򲻴���';
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
       //ִ�гɹ�����true���˳��뱻iָ���ڴ��¼
       IsQuit := GetExitCodeThread(aThread.Handle, i);
       if IsQuit then
       begin
         // STILL_ACTIVE :�߳���Ȼ��ִ��
         if i = STILL_ACTIVE then
           Result := 1
         else
           Result := 2;              //aThreadδFree����ΪTthread.Destroy����ִ�����
       end
       else
         Result := 0;                //������GetLastErrorȡ�ô������     Ret:Integer; Ret:=GetLastError; Ret=ERROR_ALREADY_EXISTS
     end
     else
       Result := 3;
end;   

end.
