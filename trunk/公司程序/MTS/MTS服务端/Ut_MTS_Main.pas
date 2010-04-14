unit Ut_MTS_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons, IdComponent,IdContext,
  IdCustomTCPServer, IdTCPServer, IdScheduler, IdSchedulerOfThread,IdGlobal,
  IdSchedulerOfThreadPool, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  IdSocketHandle,Ut_Global;


type
  TFm_MTS_Server = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Lb_ClientCount: TLabel;
    Panel5: TPanel;
    Splitter1: TSplitter;
    Lv_UserList: TListView;
    TabSheet2: TTabSheet;
    MsgLog: TRichEdit;
    Status: TStatusBar;
    IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool;
    IdMsgServer: TIdTCPServer;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure IdMsgServerDisconnect(AContext: TIdContext);
    procedure IdMsgServerExecute(AContext: TIdContext);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    IsClose :Boolean;

    //登陆用户列表
    //Clients: TThreadList;
    procedure AddUser(IP,UserNo,CityId,AreaId,ConnTime: String);
    procedure DelUser(IP,UserNo,CityId,AreaId:String);
    procedure WriteMessageLog(msg : String);
    procedure SendCmdToClients(cmd :Rcmd);
  public
    function CollectServerSendMsg(Event:integer;var cityid:integer;msg: String):Boolean;
    { Public declarations }
  end;

var
  Fm_MTS_Server: TFm_MTS_Server;
  
implementation

uses Ut_LDM_MTS;

{$R *.dfm}

procedure TFm_MTS_Server.AddUser(IP, UserNo, CityId, AreaId, ConnTime: String);
var
  aListItem: TListItem;
begin
  //删除旧的登陆信息
  DelUser(IP,UserNo,CityId,AreaId);
  //加上
  EnterCriticalSection(Cr);
  try
    with Lv_UserList do
    begin
      aListItem := Items.Add;
      aListItem.Caption := IP;
      aListItem.SubItems.add(UserNo);
      aListItem.SubItems.Add(CityId);
      aListItem.SubItems.Add(AreaId);
      aListItem.SubItems.Add(ConnTime);
    end;
    Lv_UserList.Refresh;
  finally
    LeaveCriticalSection(Cr);
  end;
end;

procedure TFm_MTS_Server.DelUser(IP, UserNo, CityId, AreaId: String);
var
  i: integer;
begin
  //加入临界区,避免多线程操作VCL控件
  EnterCriticalSection(Cr);
  try
    with Lv_UserList do
    begin
      for i := 0 to Items.Count - 1 do
      begin
        if (Trim(Items.Item[i].Caption) = Trim(IP)) and
          (Trim(Items.Item[i].SubItems[0]) = Trim(UserNo))and
          (Trim(Items.Item[i].SubItems[1]) = Trim(CityId))and
          (Trim(Items.Item[i].SubItems[2]) = Trim(AreaId)) then
        begin
          Items.Delete(i);
          Exit;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(Cr);
  end;
end;

procedure TFm_MTS_Server.Button1Click(Sender: TObject);
var
  cmd :Rcmd;
begin
  cmd.command :=2;
  self.SendCmdToClients(cmd);
end;

function TFm_MTS_Server.CollectServerSendMsg(Event: integer;
  var cityid: integer; msg: String): Boolean;
var
  cmd :RCmd;
begin
  result := true;
  try
    //WriteMessageLog('来自采集系统的接口消息 : 消息命令 - '+IntToStr(Event));
    case Event of
      1,2:
        begin
          cmd.command :=Event;
          self.SendCmdToClients(cmd);
        end;
    end;
  except
    result := false;
  end;
end;

procedure TFm_MTS_Server.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i :integer;
begin
  try
    with  IdMsgServer.Contexts.LockList do
    try
      for I :=Count - 1 downto 0 do
      try
        if TIdContext(Items[i]).Connection.Connected then
          TIdContext(Items[i]).Connection.Disconnect;
      except

      end;
    finally
      IdMsgServer.Contexts.UnlockList;
    end;
    IdMsgServer.Active := false;
  except
  end;
  Clients.Free;
  DeleteCriticalSection(CR);
end;

procedure TFm_MTS_Server.FormCreate(Sender: TObject);
begin
  Clients := TThreadList.Create;
  InitializeCriticalSection(CR);
end;

procedure TFm_MTS_Server.FormShow(Sender: TObject);
var
  Bindings: TIdSocketHandles;
  IpList :TStringList;
  i : integer;
begin
  PageControl1.ActivePageIndex :=0;
  //IdMsgServer
  with LDM_MTS.ServiceInfo do
  begin
    Status.Panels[1].Text:='系统起动于：'+datetimetostr(now);
    status.Panels[2].Text:='ServiceName : '+ServiceName+'    User ID : '+UserName;
  end;

  Bindings := nil;
  IpList := nil;
  try
    Bindings := TIdSocketHandles.Create(IdMsgServer);
    IpList :=TStringList.Create;
    GetLocalIPList(IpList); //取到所有IP地址
    for i :=0 to IpList.Count-1 do
    begin
      if Trim(IpList.Strings[i])<>'0.0.0.0' then
        with Bindings.Add do
        begin
          IP := IpList.Strings[i];//GetLocalIP;
          Port :=LDM_MTS.ServiceInfo.MsgPort; //监听端口
        end;
    end;
    try
      IdMsgServer.Bindings := Bindings;
      IdMsgServer.Active := TRUE;
      if IdMsgServer.Active then
        WriteMessageLog( '实时消息服务启动成功!');
    except on E: exception do
      begin
        MessageBox(Handle, '实时消息服务启动失败,程序退出!', '提示', MB_ICONINFORMATION + MB_OK);
        Application.Terminate;
      end;
    end;
  finally
    if IpList <> nil then
      IpList.Free;
    if Bindings <> nil then
      Bindings.Free;
  end;
end;

procedure TFm_MTS_Server.IdMsgServerDisconnect(AContext: TIdContext);
var
  P: PClient;
  userdata :Ruserdata;
begin
  try
    P := PClient(AContext.Data);
    userdata.cityid :=PClient(AContext.Data).Cityid ;
    userdata.areaid:=PClient(AContext.Data).Areaid ;
    userdata.userno :=PClient(AContext.Data).UserNo ;
    try
      WriteMessageLog('断连信息：来自 ' + P^.IP + '的断开连接!');
      DelUser(AContext.Connection.Socket.Binding.PeerIP,userdata.userno,IntToStr(userdata.cityid),IntToStr(userdata.AreaId));
      Clients.LockList.Remove(P);
    finally
      Clients.UnlockList;
    end;
    FreeMem(P);
    AContext.Data := nil;
  except
  end;
end;

procedure TFm_MTS_Server.IdMsgServerExecute(AContext: TIdContext);
var
  cmd: Rcmd;
  Buf :TIdBytes;
  userdata :Ruserdata;
  P: PClient;
begin
  if AContext.Connection.Connected then
  begin
    AContext.Connection.IOHandler.ReadBytes(Buf,SizeOf(Rcmd));
    BytesToRaw(Buf,cmd,SizeOf(Rcmd));
    case cmd.command of
      100:
        begin
          Buf := nil;
          AContext.Connection.IOHandler.ReadBytes(Buf, sizeof(Ruserdata));
          BytesToRaw(Buf,userdata,SizeOf(Ruserdata));

          GetMem(P, SizeOf(TClient));
          P^.IP := AContext.Connection.Socket.Binding.PeerIP;
          P^.LogonTime := Now;
          P^.Context := AContext;
          AContext.Data := TObject(P);
          try
            Clients.LockList.Add(P);
          finally
            Clients.UnlockList;
          end;

          //记录登陆人员信息
          PClient(AContext.Data).Cityid := userdata.cityid;
          PClient(AContext.Data).Areaid := userdata.areaid;
          PClient(AContext.Data).UserNo := userdata.userno;
          AddUser(AContext.Connection.Socket.Binding.PeerIP,userdata.UserNo,IntToStr(userdata.cityid),IntToStr(userdata.areaid),DateTimeToStr(now));
          WriteMessageLog('登陆信息：来自 '+AContext.Connection.Socket.Binding.IP+' 地市编号为 '+IntToStr(userdata.cityid)+'郊县编号为 '+IntToStr(userdata.areaid)+' 的 '+userdata.userno+' 登陆!');
        end;
      101 ://用户退出
        begin
          AContext.Connection.IOHandler.ReadBytes(Buf, sizeof(Ruserdata));
          BytesToRaw(Buf,userdata,SizeOf(Ruserdata));
          //DelUser(AContext.Connection.Socket.Binding.PeerIP,userdata.UserNo,IntToStr(userdata.cityid),IntToStr(userdata.Areaid));
        end;
    end;
  end;
end;

procedure TFm_MTS_Server.SendCmdToClients(cmd: Rcmd);
var
  RecClient: PClient;
  lContext: TIdContext;
  i : Integer;
  Buf:   TIdBytes;
begin
  try
    with Clients.LockList do
    try
      for i := 0 to Count - 1 do
      begin
        RecClient := Items[i];
        lContext := RecClient.Context;
        if lContext <> nil then
        begin
          try
            Buf:=RawToBytes(cmd,SizeOf(Rcmd));
            lContext.Connection.IOHandler.Write(Buf);
          except
            lContext.Connection.Disconnect;
          end;
        end;
      end;
    finally
      Clients.UnlockList;
    end;
  except
    On E:Exception do
      Flog.Write('发送命令给客户端失败！'+E.Message,1);
  end;
end;

procedure TFm_MTS_Server.WriteMessageLog(msg: String);
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  filename,FilePath : String;
  Present: TDateTime;
begin
  //如果进入窗口关闭就不要写日志了，会资原死锁.
  if IsClose then Exit;
  Present:= Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  filename :=Format('%.4d',[year])+Format('%.2d',[month])+Format('%.2d',[day])+'_'+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+'_'+Format('%.4d',[MSec])+'.Txt';
  with MsgLog.Lines do
  begin
    if Count > 10000 then
    begin
       FilePath:=ExtractFilePath(ParamStr(0))+'RunLog\';    //FilePath
       if not DirectoryExists(FilePath) then
         ForceDirectories(FilePath);
       SaveToFile(FilePath+'RunLog_'+filename);
       Clear;
    end;
    Add(DateTimeToStr(now)+'  '+msg);
  end;
end;

end.
