{��Ϣ�����
  ���÷���
  create;
  FMsgPort:=991;  //�˿ں� ��Ҫָ��
  FListView:=theListview; //��½�û���ʾ�б�
  Active;
  Rcmd.command
  00 �㲥
  90 �ͻ��˵�¼
  98 �ͻ����˳� ������ת
  99 Ӧ�÷�����Ҫ�˳�
  1  ɾ���澯
  2  ����ȷ��
  3  ת��
  5  ����
  51 �Զ�����
  52 ��Ϊ��Ԥ����
  53 �ֶ�����
  6  ����
  7  �ύ
  8  ��������
  9  ����
  10 �ֹ��������޸�
}
unit UnitTCPServer;

interface

uses Classes,Controls,SysUtils,StdCtrls,ComCtrls,Windows,WinSock,IdTCPServer,IdSocketHandle,UnitCommon;

const
  MAX_ADAPTER_NAME_LENGTH = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH = 8;
type
 {ҵ������Ϣ��������}
  Rcmd = record
    command: integer;
    NodeCode: integer;
  end;
  {�û���Ϣ����}
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
  {-----------------------��ſͻ������ݵļ�¼----------------------}
  PClient = ^TClient;
  TClient = record // ��ſͻ�������
      IP: string[20]; { �ͻ���IP }
      Connected, { ����ʱ�� }
      LastAction: TDateTime; { �����ʱ�� }
      Thread: Pointer; { Pointer to thread }
      //ת�����
      CompanyID,ParentNo,UserID,cityid : integer;
      ParentList,ChildList :String[200];
      UserNo :String[50];
      Filter :String[20];//�����������
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

  TTCPServer=Class(TObject)
  Private
    FTCPServer:TIdTCPServer;
    FBindings: TIdSocketHandles;
    FClients: TThreadList; //��½�û��б�
    //FStatList: TStringList; //��ͳ��Ͻ���б�
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
    //��� Cmd �����Ƿ��� Filter ���˴���
    function ReceiveCmd(cmd: integer; Filter: String): Boolean;
    //����ָ���û����߳�
    function FindThread(IP, UserNo, Cityid: String): TIdPeerThread;
    //�����ݰ����͸����пͻ���
    procedure BroadCastClients(cmd: Rcmd; R: Ruserdata);
  Public
    FMsgPort:Integer;  //�˿ں� ��Ҫָ��
    FListView:TListView; //��½�û���ʾ�б�
    Constructor Create;
    Destructor Destroy ; override;
    Function Active:Integer;
     //���㲥
    procedure BroadcastMsg_(Msg:String);
     //�ɼ�Ӧ��ͨ����������ת��Ϣ
    function CollectServerSendMsg(Event: integer; var CompanyID: integer;msg: String): Boolean;
    //�Ͽ�ָ���û�������
    procedure DisConnect;
  published
end;

  function GetAdaptersInfo(pAdapterInfo: PIP_ADAPTER_INFO;pOutBufLen: PDWORD): DWORD; stdcall;
        external 'IPHLPAPI.DLL' name 'GetAdaptersInfo';

implementation
{ TCPServer }
{
1�����ɹ� 0����ʧ�� -1��������}
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
    GetLocalIPList(IpList); //ȡ������IP��ַ
    for i :=0 to IpList.Count-1 do
    with Bindings.Add do
    begin
      IP := IpList.Strings[i];//GetLocalIP;
      Port :=FMsgPort; //�����˿�
    end;
    try
      FTCPServer.Bindings := Bindings;
      FTCPServer.Active := TRUE;
      if FTCPServer.Active then
      begin
        //WriteMessageLog( 'ʵʱ��Ϣ���������ɹ�!');
      end
      else Result:=0;
    except on E: exception do
      begin
        //WriteMessageLog('ʵʱ��Ϣ��������ʧ�� : ' + E.Message);
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
  //�Ƿ��Ѿ��д˿ͻ������б���
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
      //WriteMessageLog('������Ϣ������ ' + ActClient^.IP + ' Ͻ�����Ϊ '+IntToStr(ActClient.DeptNo)+' �� '+ActClient.UserNo+' �Ͽ�����!');
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

//��� Cmd �����Ƿ��� Filter ���˴���
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

//��ȡ����������IP��ַ
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
  sIp: string; //��ű���IP
begin
  try // �󶨱���IP
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
  //ɾ���ɵĵ�½��Ϣ
  DelUser(IP,UserNo,CityId,CompanyID);
  //����
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
  //�����ٽ���,������̲߳���VCL�ؼ� ,��۲캼���ֳ�
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

//����ͳ��Ͻ�������б�
procedure TTCPServer.PushStatItem(districtid: integer);
begin
  EnterCriticalSection(FCr);
  try
    //StatList.Add(IntToStr(districtid));
  finally
    LeaveCriticalSection(FCr);
  end;
end;
//ȡһ��ͳ��Ͻ����ɾ��
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
//���㲥
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

//�Ͽ�ָ���û������� ��Ϣ��ʽ : ����(2)+���ź�(5)+��������(2)+�ϼ����ź�(5)+�û�����(15)
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
  try  //IP���û��ʺš����б��
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

//�ɼ�Ӧ��ͨ����������ת��Ϣ
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
      91: //֪ͨʵʱͳ���Ѿ����
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
      14: //֪ͨԤ��
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

//�����ݰ��������пͻ���
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
      //���ͻ��Ƿ����δ�����
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
