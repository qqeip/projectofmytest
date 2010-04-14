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

    //��½�û��б�
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
  //ɾ���ɵĵ�½��Ϣ
  DelUser(IP,UserNo,CityId,AreaId);
  //����
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
  //�����ٽ���,������̲߳���VCL�ؼ�
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
    //WriteMessageLog('���Բɼ�ϵͳ�Ľӿ���Ϣ : ��Ϣ���� - '+IntToStr(Event));
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
    Status.Panels[1].Text:='ϵͳ���ڣ�'+datetimetostr(now);
    status.Panels[2].Text:='ServiceName : '+ServiceName+'    User ID : '+UserName;
  end;

  Bindings := nil;
  IpList := nil;
  try
    Bindings := TIdSocketHandles.Create(IdMsgServer);
    IpList :=TStringList.Create;
    GetLocalIPList(IpList); //ȡ������IP��ַ
    for i :=0 to IpList.Count-1 do
    begin
      if Trim(IpList.Strings[i])<>'0.0.0.0' then
        with Bindings.Add do
        begin
          IP := IpList.Strings[i];//GetLocalIP;
          Port :=LDM_MTS.ServiceInfo.MsgPort; //�����˿�
        end;
    end;
    try
      IdMsgServer.Bindings := Bindings;
      IdMsgServer.Active := TRUE;
      if IdMsgServer.Active then
        WriteMessageLog( 'ʵʱ��Ϣ���������ɹ�!');
    except on E: exception do
      begin
        MessageBox(Handle, 'ʵʱ��Ϣ��������ʧ��,�����˳�!', '��ʾ', MB_ICONINFORMATION + MB_OK);
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
      WriteMessageLog('������Ϣ������ ' + P^.IP + '�ĶϿ�����!');
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

          //��¼��½��Ա��Ϣ
          PClient(AContext.Data).Cityid := userdata.cityid;
          PClient(AContext.Data).Areaid := userdata.areaid;
          PClient(AContext.Data).UserNo := userdata.userno;
          AddUser(AContext.Connection.Socket.Binding.PeerIP,userdata.UserNo,IntToStr(userdata.cityid),IntToStr(userdata.areaid),DateTimeToStr(now));
          WriteMessageLog('��½��Ϣ������ '+AContext.Connection.Socket.Binding.IP+' ���б��Ϊ '+IntToStr(userdata.cityid)+'���ر��Ϊ '+IntToStr(userdata.areaid)+' �� '+userdata.userno+' ��½!');
        end;
      101 ://�û��˳�
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
      Flog.Write('����������ͻ���ʧ�ܣ�'+E.Message,1);
  end;
end;

procedure TFm_MTS_Server.WriteMessageLog(msg: String);
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  filename,FilePath : String;
  Present: TDateTime;
begin
  //������봰�ڹرվͲ�Ҫд��־�ˣ�����ԭ����.
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
