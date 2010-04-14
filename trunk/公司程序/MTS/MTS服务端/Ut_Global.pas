unit Ut_Global;

interface

Uses
  Windows,forms,SysUtils,inifiles,Messages,Classes,WinSock,Log,ComCtrls;
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
    IpAddress: TIP_ADDRESS_STRING;  //IP��ַ�ַ���
    IpMask: TIP_MASK_STRING;  //���������ַ���
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
{-----------------------��ſͻ������ݵļ�¼----------------------}
  PClient = ^TClient;
  TClient = record  // ��ſͻ�������
    IP: string[20]; //�ͻ���IP }
    LogonTime :TDateTime; //��½ʱ��
    Context: Pointer;     // ����������
    Cityid,Areaid: integer;
    UserNo :String[50];   //�û��ʺ�
  end;
  {ҵ������Ϣ��������}
  Rcmd = record
    command: integer;
  end;
  {�û���Ϣ����}
  Ruserdata = record
    userid :integer;
    userno :String[50];
    cityid :integer;
    AreaId :integer;
  end;

  {����������}
  Tctrl = class
  public
    cs: TRTLCriticalSection;
    onlineview: TListView;
    procedure addonline(IP:String;user_data: Ruserdata); //����������������
    procedure deleonline(IP:String;user_data: Ruserdata); //���߹���
  end;





  procedure GetLocalIPList(iplist :TStrings);
  function GetFileTimeInfor(FileName:string;TimeFlag:integer):string;
  function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO;
        pOutBufLen: PDWORD): DWORD; stdcall;
        external 'IPHLPAPI.DLL' name 'GetAdaptersInfo';
  function WinExecAndWait32(FileName: String;  Visibility: Integer): Cardinal;

var
  Clients: TThreadList;
  FLog : TLog;
  cr: TRTLCriticalSection;

implementation

//��ȡ����������IP��ַ
procedure GetLocalIPList(iplist :TStrings);
var
  pbuf: PIP_ADAPTER_INFO;
  buflen: DWORD;
begin
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
//--��������: GetFileTimeInfor
//--��������: FileName �ļ���  TimeFlag ʱ�����  (1 �����ļ�����ʱ�� 2 �����ļ��޸�ʱ�� 3 �����ϴη����ļ���ʱ��)
//--��������: ��ȡ�ļ��޸�ʱ��
//--�� �� ֵ: ����ָ�����ļ��޸�ʱ��
//--������ע: ��
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

{ Tctrl }

procedure Tctrl.addonline(IP:String;user_data: Ruserdata);
var
  alistItem :TListItem;
begin
  EnterCriticalSection(Cs);
  try
    with onlineview do
    begin
      aListItem := Items.Add;
      aListItem.Caption := IP;
      aListItem.SubItems.add(user_data.UserNo);
      aListItem.SubItems.Add(IntToStr(user_data.CityId));
      aListItem.SubItems.Add(IntToStr(user_data.AreaId));
      aListItem.SubItems.Add(DateTimeToStr(now));
    end;
  finally
    LeaveCriticalSection(Cs);
  end;
end;

procedure Tctrl.deleonline(IP:String;user_data: Ruserdata);
var
  i: integer;
begin
  //�����ٽ���,������̲߳���VCL�ؼ�
  EnterCriticalSection(Cs);
  try
    with self.onlineview do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        if (Trim(Items.Item[i].Caption) = Trim(IP)) and
          (Trim(Items.Item[i].SubItems[0]) = Trim(user_data.UserNo))and
          (Trim(Items.Item[i].SubItems[1]) =IntToStr(user_data.CityId))and
          (Trim(Items.Item[i].SubItems[2]) = IntToStr(user_data.AreaId)) then
        begin
          Items.Delete(i);
          Exit;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(Cs);
  end;
end;

end.
