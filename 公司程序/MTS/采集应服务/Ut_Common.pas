unit Ut_Common;

interface
uses
  Windows,DBGrids,Classes,SysUtils,Variants,WinSock;

const
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
  function GetLocalIP: string;
  procedure GetLocalIPList(iplist :TStrings);
  function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO;
        pOutBufLen: PDWORD): DWORD; stdcall;
        external 'IPHLPAPI.DLL' name 'GetAdaptersInfo';

implementation

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
function GetLocalIP: string;
var
  HostEnt: PHostEnt;
  addr: pchar;
  Buffer: array[0..63] of char;
  GInitData: TWSADATA;
  sIp: string; //存放本机IP
begin
  try // 绑定本机IP
    WSAStartup(2, GInitData);
    GetHostName(Buffer, SizeOf(Buffer));
    HostEnt := GetHostByName(Buffer);
    if HostEnt = nil then Exit;
    addr := HostEnt^.h_addr_list^;
    sIp := Format('%d.%d.%d.%d', [byte(addr[0]),
        byte(addr[1]), byte(addr[2]), byte(addr[3])]);
    result := sIP;
  finally
    WSACleanup;
  end;
end;

end.
