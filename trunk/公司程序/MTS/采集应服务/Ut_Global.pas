unit Ut_Global;

interface

Uses
  Windows,forms,SysUtils,inifiles,Messages,Classes,WinSock,Log;
const
  WM_SENDTHREAD_MSG  = WM_USER + 100;
    MAX_ADAPTER_NAME_LENGTH = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH = 8;
type
  TIP_ADDRESS_STRING = record
     IPstring: array [0..15] of Char;
  end;
  PIP_ADDRESS_STRING = ^TIP_ADDRESS_STRING;
  TIP_MASK_STRING = TIP_ADDRESS_STRING;
  PIP_MASK_STRING = ^TIP_MASK_STRING;

  PIP_ADDR_STRING = ^TIP_ADDR_STRING;
  TIP_ADDR_STRING = record
    Next: PIP_ADDR_STRING;
    IpAddress: TIP_ADDRESS_STRING;  //IP地址字符串
    IpMask: TIP_MASK_STRING;  //子网掩码字符串
    Context: DWORD; //Netword table entry
  end;
  PIP_ADAPTER_INFO = ^TIP_ADAPTER_INFO;
  TIP_ADAPTER_INFO = packed record
     Next: PIP_ADAPTER_INFO;
     ComboIndex: DWORD;
     AdapterName: array [0..MAX_ADAPTER_NAME_LENGTH + 4-1] of Char;
     Description: array [0..MAX_ADAPTER_DESCRIPTION_LENGTH + 4-1] of Char;
     AddressLength: UINT;
     Address: array [0..MAX_ADAPTER_ADDRESS_LENGTH-1] of BYTE;
     Index: DWORD;
     dwType: UINT;
     DhcpEnabled: UINT;
     CurrentIpAddress: PIP_ADDR_STRING;
     IpAddressList: TIP_ADDR_STRING;
     GatewayList: TIP_ADDR_STRING;
     DhcpServer: TIP_ADDR_STRING ;
     HaveWins: BOOL;
     PrimaryWinsServer: TIP_ADDR_STRING;
     SecondaryWinsServer: TIP_ADDR_STRING;
  end;
type
  PThreadData = ^ThreadData;
  ThreadData = record
    command :integer;
    cityid :integer;
    msg :String;
  end;
type
  //MTU控制器信息
  PMtuClient = ^TMtuClient;
  TMtuClient = record
    Cityid : integer;
    MtuControl:String[100];
    Ip :String[20];
    ConnectTime: String[30];
    Context: Pointer; { Pointer to thread }
    Status : integer;  // 1: 连接 0: 未连接
  end;

  procedure GetLocalIPList(iplist :TStrings);
  function GetFileTimeInfor(FileName:string;TimeFlag:integer):string;
  function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO;
        pOutBufLen: PDWORD): DWORD; stdcall;
        external 'IPHLPAPI.DLL' name 'GetAdaptersInfo';
  function WinExecAndWait32(FileName: String;  Visibility: Integer): Cardinal;

var
  MtuClients: TThreadList;         //MTU控制器列表
  FLog : TLog;                     //日志
  FDRSInfoList: THashedStringList; //直放站发送任务列表 等待接收

implementation

//获取本机的所有IP地址
procedure GetLocalIPList(iplist :TStrings);
var
  pbuf: PIP_ADAPTER_INFO;
  buflen: DWORD;
begin
  pbuf := nil;
  buflen := 0;
  if GetAdaptersInfo(pbuf, @bufLen) = ERROR_BUFFER_OVERFLOW then
  begin
    pbuf := AllocMem(buflen);
    if GetAdaptersInfo(pbuf, @bufLen) = ERROR_SUCCESS then
    while pbuf <> nil do
    begin
      iplist.Add(pbuf.IpAddressList.IpAddress.IPstring);
      pbuf := pbuf.Next;
    end;
    FreeMem(pbuf);
  end;
end;

//==============================================================
//--函数名称: GetFileTimeInfor
//--函数参数: FileName 文件名  TimeFlag 时间参数  (1 返回文件创建时间 2 返回文件修改时间 3 返回上次访问文件的时间)
//--函数功能: 获取文件修改时间
//--返 回 值: 返回指定的文件修改时间
//--函数备注: 无
//==============================================================
function GetFileTimeInfor(FileName:string;TimeFlag:integer):string;
var
  LocalFileTime : TFileTime;
  fhandle:integer;
  DosFileTime : DWORD;                       
  FindData : TWin32FindData;
begin
  fhandle := FindFirstFile(Pchar(FileName), FindData);
  if (FHandle <> INVALID_HANDLE_VALUE) then
     begin
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        begin
          case TimeFlag of
          1:
            begin
               FileTimeToLocalFileTime(FindData.ftCreationTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
            3:
            begin
               FileTimeToLocalFileTime(FindData.ftLastAccessTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
            2:
            begin
               FileTimeToLocalFileTime(FindData.ftLastWriteTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
           end;  //case;
        end;
     end;
end;

function WinExecAndWait32(FileName: String;  Visibility: Integer): Cardinal;
var 
  WorkDir:String;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
begin
  WorkDir:=ExtractFileDir(Application.ExeName);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb:=Sizeof(StartupInfo);
  StartupInfo.dwFlags:=STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  StartupInfo.wShowWindow:=Visibility;

  if not CreateProcess(nil,
    PChar(FileName),               { pointer to command line string }
    nil,                           { pointer to process security attributes }
    nil,                           { pointer to thread security attributes }
    True,                          { handle inheritance flag }
//    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    PChar(WorkDir),                { pointer to current directory name, PChar}
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo)                   { pointer to PROCESS_INF }
    then Result := INFINITE {-1} else
  begin
    Application.ProcessMessages;
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
    CloseHandle(ProcessInfo.hProcess);  { to prevent memory leaks }
    CloseHandle(ProcessInfo.hThread);
  end;
end;
end.
