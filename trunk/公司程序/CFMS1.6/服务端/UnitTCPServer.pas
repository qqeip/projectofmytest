{消息服务端
  调用方法
  create;
  FMsgPort:=991;  //端口号 需要指定
  FListView:=theListview; //登陆用户显示列表
  Active;
  Rcmd.command
  00 广播
  90 客户端登录
  98 客户端退出 其他中转
  99 应用服务器要退出
  1  删除告警
  2  疑难确认
  3  转发
  5  派障
  51 自动派障
  52 人为干预派障
  53 手动派障
  6  排障
  7  提交
  8  疑难申请
  9  消障
  10 手工派障已修复
}
unit UnitTCPServer;

interface

uses Classes,Controls,SysUtils,StdCtrls,ComCtrls,Windows,WinSock,IdTCPServer,IdSocketHandle,UnitCommon;

const
  MAX_ADAPTER_NAME_LENGTH = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH = 8;
type
 {业务处理消息数据类型}
  Rcmd = record
    command: integer;
    NodeCode: integer;
  end;
  {用户信息类型}
  Ruserdata = record
    userid :integer;
    userno :String[20];
    ComPanyID :integer;
    cityid :integer;
    parentid :integer;
    Filter :String[20];
    ParentList :String[200];
    ChildList :String[200];
  end;
  RBroadData = record
    msg :String[255];
  end;
  {-----------------------存放客户端数据的记录----------------------}
  PClient = ^TClient;
  TClient = record // 存放客户端数据
      IP: string[20]; { 客户端IP }
      Connected, { 连接时间 }
      LastAction: TDateTime; { 最后交易时间 }
      Thread: Pointer; { Pointer to thread }
      //转发相关
      CompanyID,ParentNo,UserID,cityid : integer;
      ParentList,ChildList :String[200];
      UserNo :String[50];
      Filter :String[20];//接收命令过滤
    end;
  {----------------------------------------------------------------}
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

  TTCPServer=Class(TObject)
  Private
    FTCPServer:TIdTCPServer;
    FBindings: TIdSocketHandles;
    FClients: TThreadList; //登陆用户列表
    //FStatList: TStringList; //待统计辖区列表
    FCr :Trtlcriticalsection;
    procedure GetLocalIPList(iplist: TStrings);
    function GetLocalIP: string;
    procedure MsgServerConnect(AThread: TIdPeerThread);
    procedure MsgServerExecute(AThread: TIdPeerThread);
    procedure MsgServerDisconnect(AThread: TIdPeerThread);
    procedure AddUser(IP, UserNo, CityId, CompanyID, ConnTime: String);
    procedure DelUser(IP, UserNo, CityId, CompanyID: String);
    function PullStatItem: Integer;
    procedure PushStatItem(districtid: integer);
    procedure SendMessageToClients(cmd: Rcmd; IP: String; R: Ruserdata);
    //检测 Cmd 命令是否在 Filter 过滤串中
    function ReceiveCmd(cmd: integer; Filter: String): Boolean;
    //查找指定用户的线程
    function FindThread(IP, UserNo, Cityid: String): TIdPeerThread;
    //将数据包发送给所有客户端
    procedure BroadCastClients(cmd: Rcmd; R: Ruserdata);
  Public
    FMsgPort:Integer;  //端口号 需要指定
    FListView:TListView; //登陆用户显示列表
    Constructor Create;
    Destructor Destroy ; override;
    Function Active:Integer;
     //发广播
    procedure BroadcastMsg_(Msg:String);
     //采集应服通过服务器中转信息
    function CollectServerSendMsg(Event: integer; var CompanyID: integer;msg: String): Boolean;
    //断开指定用户的连接
    procedure DisConnect;
  published
end;

  function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO;pOutBufLen: PDWORD): DWORD; stdcall;
        external 'IPHLPAPI.DLL' name 'GetAdaptersInfo';

implementation
{ TCPServer }
{
1启动成功 0启动失败 -1启动出错}
function TTCPServer.Active: Integer;
var
  Bindings: TIdSocketHandles;
  IpList :TStringList;
  i : integer;
begin
  Result:=1;
  Bindings := nil;
  IpList := nil;
  try
    Bindings := TIdSocketHandles.Create(FTCPServer);
    IpList :=TStringList.Create;
    GetLocalIPList(IpList); //取到所有IP地址
    for i :=0 to IpList.Count-1 do
    with Bindings.Add do
    begin
      IP := IpList.Strings[i];//GetLocalIP;
      Port :=FMsgPort; //监听端口
    end;
    try
      FTCPServer.Bindings := Bindings;
      FTCPServer.Active := TRUE;
      if FTCPServer.Active then
      begin
        //WriteMessageLog( '实时消息服务启动成功!');
      end
      else Result:=0;
    except on E: exception do
      begin
        //WriteMessageLog('实时消息服务启动失败 : ' + E.Message);
        Result:=-1;
      end;
    end;
  finally
    if IpList <> nil then
      IpList.Free;
    if Bindings <> nil then
      Bindings.Free;
  end;
end;

constructor TTCPServer.Create;
begin
  InitializeCriticalSection(FCr);
  FClients := TThreadList.Create;
  //StatList:= TStringList.Create;
  FTCPServer:=TIdTCPServer.Create(nil);
  FTCPServer.OnConnect:=MsgServerConnect;
  FTCPServer.OnDisconnect:=MsgServerDisconnect;
  FTCPServer.OnExecute:= MsgServerExecute;
  FTCPServer.Active:=false;
end;

procedure TTCPServer.MsgServerConnect(AThread: TIdPeerThread);
var
    NewClient: PClient;
begin
  //是否已经有此客户端在列表中
  GetMem(NewClient, SizeOf(TClient));
  NewClient.IP := AThread.Connection.Socket.Binding.PeerIP;
  NewClient.Connected := Now;
  NewClient.LastAction := NewClient.Connected;
  NewClient.Thread := AThread;
  AThread.Data := TObject(NewClient);
  try
    FClients.LockList.Add(NewClient);
  finally
    FClients.UnlockList;
  end;
end;

procedure TTCPServer.MsgServerDisconnect(AThread: TIdPeerThread);
var
    ActClient: PClient;
begin
  try
    ActClient := PClient(AThread.Data);
    try
      //WriteMessageLog('断连信息：来自 ' + ActClient^.IP + ' 辖区编号为 '+IntToStr(ActClient.DeptNo)+' 的 '+ActClient.UserNo+' 断开连接!');
      FClients.LockList.Remove(ActClient);
    finally
      FClients.UnlockList;
    end;
    FreeMem(ActClient);
    AThread.Data := nil;
  except
  end;
end;

procedure TTCPServer.MsgServerExecute(AThread: TIdPeerThread);
var
  ActClient: PClient;
  userdata: Ruserdata;
  cmd: Rcmd;
begin
  if ((not AThread.Terminated) and (AThread.Connection.Connected)) then
  begin
    try
      AThread.Connection.ReadBuffer(cmd, sizeof(Rcmd));
      case cmd.command of
      101:
        begin
          SendMessageToClients(cmd,AThread.Connection.Socket.Binding.PeerIP,userdata);
        end;
      end;
    except
      AThread.Connection.Disconnect;
      Exit;
    end;
  end;
end;

procedure TTCPServer.SendMessageToClients(cmd: Rcmd; IP: String;
  R: Ruserdata);
var
  RecClient: PClient;
  RecThread: TIdPeerThread;
  i : Integer;
begin
  with FClients.LockList do
  try
    for i := 0 to Count - 1 do
    begin
      RecClient := Items[i];
      if true {(RecClient.Filter='') or ReceiveCmd(cmd.command,RecClient.Filter)} then
      begin
        RecThread := RecClient.Thread;
        if RecThread <> nil then
        begin
          try
            RecThread.Connection.WriteBuffer(cmd,sizeof(Rcmd));
          except
            RecThread.Connection.Disconnect;
          end;
        end;
      end;
    end;
  finally
    FClients.UnlockList;
  end;
end;

//检测 Cmd 命令是否在 Filter 过滤串中
function TTCPServer.ReceiveCmd(cmd:integer;Filter:String):Boolean;
begin
  result := false;
  if Pos(','+IntToStr(cmd)+',',','+Filter+',') > 0 then
    result := true;
end;

destructor TTCPServer.Destroy;
begin
  DeleteCriticalSection(FCr);
  if FTCPServer.Active then
    FTCPServer.Active := false;
  FClients.Free;
  inherited;
end;

//获取本机的所有IP地址
procedure TTCPServer.GetLocalIPList(iplist :TStrings);
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

function TTCPServer.GetLocalIP: string;
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

procedure TTCPServer.AddUser(IP, UserNo, CityId, CompanyID,
  ConnTime: String);
var
  aListItem: TListItem;
begin
  //删除旧的登陆信息
  DelUser(IP,UserNo,CityId,CompanyID);
  //加上
  EnterCriticalSection(FCr);
  try
    aListItem := FListView.Items.Add;
    aListItem.Caption := IP;
    aListItem.SubItems.add(UserNo);
    aListItem.SubItems.Add(CityId);
    aListItem.SubItems.Add(CompanyID);
    aListItem.SubItems.Add(ConnTime);
  finally
    LeaveCriticalSection(FCr);
  end;
end;

procedure TTCPServer.DelUser(IP, UserNo, CityId,
  CompanyID: String);
var
  i: integer;
begin
  //加入临界区,避免多线程操作VCL控件 ,需观察杭电现场
  EnterCriticalSection(FCr);
  try
    for i := 0 to FListView.Items.Count - 1 do
    begin
      if (Trim(FListView.Items.Item[i].Caption) = Trim(IP)) and
        (Trim(FListView.Items.Item[i].SubItems[0]) = Trim(UserNo))and
        (Trim(FListView.Items.Item[i].SubItems[1]) = Trim(CityId))and
        (Trim(FListView.Items.Item[i].SubItems[2]) = Trim(CompanyID)) then
      begin
        FListView.Items.Delete(i);
        Exit;
      end;
    end;
  finally
    LeaveCriticalSection(FCr);
  end;
end;

//将待统计辖区推入列表
procedure TTCPServer.PushStatItem(districtid: integer);
begin
  EnterCriticalSection(FCr);
  try
    //StatList.Add(IntToStr(districtid));
  finally
    LeaveCriticalSection(FCr);
  end;
end;
//取一个统计辖区后删除
function TTCPServer.PullStatItem: Integer;
begin
 { result := -2;
  EnterCriticalSection(FCr);
  try
    if StatList.Count> 0 then
    begin
      result := StrToInt(StatList.Strings[0]);
      StatList.Delete(0);
    end;
  finally
    LeaveCriticalSection(FCr);
  end;}
end;
//发广播
procedure TTCPServer.BroadcastMsg_(Msg:String);
var
  RecClient: PClient;
  RecThread: TIdPeerThread;
  i : Integer;
  cmd :Rcmd;
  R :RBroadData;
begin
  cmd.command :=100;
  R.msg := Msg;
  with FClients.LockList do
  try
    for i := 0 to Count - 1 do
    begin
      RecClient := Items[i];
      if (RecClient.Filter='') or ReceiveCmd(cmd.command,RecClient.Filter) then
      begin
        RecThread := RecClient.Thread;
        if RecThread <> nil then
        begin
          try
            RecThread.Connection.WriteBuffer(cmd,sizeof(cmd));
            RecThread.Connection.WriteBuffer(R,sizeof(RBroadData));
          except
              RecThread.Connection.Disconnect;
          end;
        end;
      end;
    end;
  finally
    FClients.UnlockList;
  end;
end;

//断开指定用户的连接 消息格式 : 命令(2)+部门号(5)+部门类型(2)+上级部门号(5)+用户功号(15)
procedure TTCPServer.DisConnect;
var
  RecThread: TIdPeerThread;
  Item :TListItem;
  cmd :RCmd;
  R :RUserData;
begin
  RecThread := nil;
  Item := FLIstView.Selected;
  if Item = nil then Exit;
  try  //IP、用户帐号、城市编号
    RecThread := FindThread(Item.Caption,Item.SubItems[0],Item.SubItems[1]);
    if RecThread <> nil then
    begin
      cmd.command := 99;
      //R.userid :=RecClient.UserID;
      R.userno :=Item.SubItems[0];
      R.ComPanyID :=StrToInt(Item.SubItems[2]);
      R.parentid := 0;
      R.cityid :=StrToInt(Item.SubItems[1]);
      RecThread.Connection.WriteBuffer(cmd,SizeOf(RCmd));
      RecThread.Connection.WriteBuffer(R,SizeOf(RUserData));
    end
    else
      FListView.DeleteSelected;
  except
    if RecThread <> nil then
      RecThread.Connection.Disconnect;
  end;
end;

function TTCPServer.FindThread(IP,UserNo,Cityid: String): TIdPeerThread;
var
  RecClient: PClient;
  RecThread: TIdPeerThread;
  i : Integer;
begin
  result := nil;
  with FClients.LockList do
  try
      for i := 0 to Count - 1 do
      begin
          RecClient := Items[i];
          RecThread := RecClient.Thread;
          if (RecClient.IP = IP) and (RecClient.UserNo=UserNo) and (RecClient.cityid = StrToInt(cityid)) then
          begin
              result := RecThread;
              Exit;
          end;
      end;
  finally
      FClients.UnlockList;
  end;
end;

//采集应服通过服务器中转信息
function TTCPServer.CollectServerSendMsg(Event:integer;var CompanyID:integer;msg: String):Boolean;
var
  cmd :RCmd;
  R:RUserData;
  RB:RBroadData;
  RecClient: PClient;
  RecThread: TIdPeerThread;
  i : integer;
begin
  result := true;
  try
    case Event of
      1,2,3,5,6,7,8,9:
        begin
          cmd.command :=Event;
          R.ComPanyID := 0;
          R.userid := 0;
          R.userno :='SYS';
          R.parentid := 0;
          R.cityid := 0;
          BroadCastClients(cmd,R);
        end;
      91: //通知实时统计已经完成
        begin
          cmd.command :=91;
          with FClients.LockList do
          try
            for i := 0 to Count - 1 do
            begin
              RecClient := Items[i];
              RecThread := RecClient.Thread;
              //
              if (RecClient.CompanyID =CompanyID) and ((RecClient.Filter='') or ReceiveCmd(cmd.command,RecClient.Filter)) then
              try
                cmd.command := 91;
                R.userid :=RecClient.UserID;
                R.userno :=RecClient.UserNo;
                R.ComPanyID :=  RecClient.CompanyID;
                R.parentid := RecClient.ParentNo;
                R.cityid :=RecClient.cityid;
                RecThread.Connection.WriteBuffer(cmd,SizeOf(RCmd));
                RecThread.Connection.WriteBuffer(R,SizeOf(RUserData));
              except
                RecThread.Connection.Disconnect;
              end;
            end;
          finally
            FClients.UnlockList;
          end;
        end;
      14: //通知预警
        begin
          cmd.command :=14;
          with FClients.LockList do
          try
            for i := 0 to Count - 1 do
            begin
              RecClient := Items[i];
              if (RecClient.Filter='') or ReceiveCmd(cmd.command,RecClient.Filter) then
              begin
                RecThread := RecClient.Thread;
                if RecThread <> nil then
                begin
                  if  (RecClient.CompanyID =CompanyID) or (Pos(','+IntToStr(CompanyID)+',',','+RecClient.ChildList+',')>0)   then
                  try
                    RecThread.Connection.WriteBuffer(cmd,sizeof(Rcmd));
                    RB.msg := msg;
                    RecThread.Connection.WriteBuffer(RB,sizeof(RBroadData));
                  except
                    RecThread.Connection.Disconnect;
                  end;
                end;
              end;
            end;
          finally
            FClients.UnlockList;
          end;
        end;
    end;
  except
    result := false;
  end;
end;

//将数据包发给所有客户端
procedure TTCPServer.BroadCastClients(cmd: Rcmd; R: Ruserdata);
var
  RecClient: PClient;
  RecThread: TIdPeerThread;
  i : Integer;
begin
  with FClients.LockList do
  try
    for i := 0 to Count - 1 do
    begin
      RecClient := Items[i];
      //检测客户是否屏蔽此命令
      if true{(RecClient.Filter='') or ReceiveCmd(cmd.command,RecClient.Filter)} then
      begin
        RecThread := RecClient.Thread;
        if RecThread <> nil then
        begin
          try
            RecThread.Connection.WriteBuffer(cmd,sizeof(Rcmd));
          except
            RecThread.Connection.Disconnect;
          end;
        end;
      end;
    end;
  finally
    FClients.UnlockList;
  end;
end;

end.
