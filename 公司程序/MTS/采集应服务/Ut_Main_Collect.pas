unit Ut_Main_Collect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdBaseComponent, IdAntiFreezeBase,IdContext,IdAntiFreeze, Menus, ExtCtrls, DB, ADODB,
  IniFiles,IdSocketHandle,Log, IdScheduler, IdSchedulerOfThread,IdGlobal,
  IdSchedulerOfThreadPool, DBClient, MConnect, SConnect,MTS_Server_TLB,Ut_Global;

type
  TCurParam = record
    IP :String;
    DBName :String;
    DBPWD :String;
    SID   :String;
    MTUPORT :integer;
    ServerIP :String;
    DataPort :integer;
  end;

type
  TCDMACall = function(aForm: TForm): boolean; stdcall;    

type
  TFm_Main_Collect = class(TForm)
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo_LOG: TMemo;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N3: TMenuItem;
    N2: TMenuItem;
    N7: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    LogTimer: TTimer;
    PopupMenu1: TPopupMenu;
    RefreshLog: TMenuItem;
    MenuItem1: TMenuItem;
    PopupMenuThread: TPopupMenu;
    MenuItemThreadStart: TMenuItem;
    MenuItemThreadStop: TMenuItem;
    IdCollectServer: TIdTCPServer;
    Adoc_Main: TADOConnection;
    AdoQ_Free: TADOQuery;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Lv_MtuCsc: TListView;
    Lv_ThreadList: TListView;
    IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool;
    Sc_Client: TSocketConnection;
    N6: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdCollectServerExecute(AContext: TIdContext);
    procedure RefreshLogClick(Sender: TObject);
    procedure IdCollectServerConnect(AContext: TIdContext);
    procedure IdCollectServerDisconnect(AContext: TIdContext);
    procedure MenuItemThreadStartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuItemThreadStopClick(Sender: TObject);
    procedure PopupMenuThreadPopup(Sender: TObject);
    procedure Sc_ClientAfterConnect(Sender: TObject);
    procedure Sc_ClientAfterDisconnect(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure IdCollectServerException(AContext: TIdContext;
      AException: Exception);
    procedure N6Click(Sender: TObject);
  private
    { Private declarations }
    SockConError :integer;
    LogNum : integer;
    Cr :Trtlcriticalsection;
    //初始化系统相关参数
    function InitParam :integer;
    function OpenMtuMonitor : integer;
    procedure GetLog;
    //加载MTU控制器
    procedure LoadMtuConfig;
    //MTU控制器状态变更  上线/下线
    procedure MtuCSCLogon(FIp:String;FStatus:integer);
    //加载线程
    procedure LoadThreadInfo;
    procedure CollectTimerProgress(Caption:string; Progress:string) ;
    procedure WMSendThread_MSG(var Msg: TMessage);MESSAGE WM_SENDTHREAD_MSG;
  public
    CurDBConStr, CDMADBConStr :String;        //数据库连接字符串
    CurParam:TCurParam;
    AlarmServer : Variant;
    TempInterface: IRDM_MTSDisp;
    { Public declarations }
  end;

var
  Fm_Main_Collect: TFm_Main_Collect;

implementation
uses Ut_MtuInfo,Ut_Common,Ut_TestControlThread,Ut_ParseDataThread,Ut_TestResultSearch,
     Ut_BaseThread,Ut_MtuDataProcess,Ut_SystemSet,UnitAutoTestListThread, UnitTaskSendThread,
     UntCDMACollectThread, UnitFunAnalyseThread,
     UnitAlarmCollect, UnitAlarmSend, UnitResultParas, UnitDRS_TaskSendThread,
     UnitDRS_ResultReviceThread, UnitDRS_ResultParasThread, UnitDRS_AlarmSend,
  UnitDRS_AlarmCollect, UnitDRS_AutoTestThread;
{$R *.dfm}

procedure TFm_Main_Collect.CollectTimerProgress(Caption, Progress: string);
var
  i: Integer;
  lSelectItem:TListItem;
begin
  for i := 0 to Lv_ThreadList.Items.Count - 1 do
  begin
    lSelectItem:=self.Lv_ThreadList.Items[i];
    if lSelectItem.SubItems.Strings[0]=Caption then
      lSelectItem.SubItems[1]:= Progress;
  end;
end;

procedure TFm_Main_Collect.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i : integer;
begin
  //关闭开启的线程
  for I := 0 to Lv_ThreadList.Items.Count - 1 do
  begin
    if (Lv_ThreadList.Items[i].SubItems[1] <> '未启动') then
    begin
      Lv_ThreadList.Items[i].Selected := true;
      MenuItemThreadStopClick(self);
    end;
  end;

  try
    with  IdCollectServer.Contexts.LockList do
    try
      for I :=Count - 1 downto 0 do
      try
        if TIdContext(Items[i]).Connection.Connected then
          TIdContext(Items[i]).Connection.Disconnect;
      except

      end;
    finally
      IdCollectServer.Contexts.UnlockList;
    end;
    try
      IdCollectServer.Active := false;
    except

    end;
    //需要验证,是否可行
    //IdCollectServer.StopListening;
    //IdCollectServer.Free;
  except

  end;
end;

procedure TFm_Main_Collect.FormCreate(Sender: TObject);
begin
  FLog :=TLog.create;
  MtuClients:= TThreadList.Create;
  FDRSInfoList:= THashedStringList.Create;
  LogNum :=20;
  InitializeCriticalSection(Cr);
end;

procedure TFm_Main_Collect.FormDestroy(Sender: TObject);
var
  i : integer;
begin
  FLog.Free;
  DeleteCriticalSection(Cr);
  with MtuClients.LockList do
  for I := Count-1 downto 0 do
  begin
    TMtuDataProcess(Items[i]).Free;
    Delete(i);
  end;
  MtuClients.Free; 

  for I := FDRSInfoList.Count - 1 downto 0 do
  begin
    FDRSInfoList.Objects[i].Free;
    FDRSInfoList.Delete(i);
  end;
  FDRSInfoList.Clear;
  FDRSInfoList.Free;
end;

procedure TFm_Main_Collect.FormShow(Sender: TObject);
var
  Flag : integer;
  HintStr :String;
begin
  Flag :=InitParam;
  case Flag of
    0: HintStr :='初始化系统参数失败!';
    -1:HintStr :='未发现配置文件!';
    -2:HintStr :='数据库无法连接,请检查配置信息是否正确!';
     1:LoadMtuConfig;  //加载MTU控制器信息
  end;
  if Flag <> 1 then
  begin
    Application.MessageBox(Pchar(HintStr),'提示');
    Application.Terminate;
  end;

  if OpenMtuMonitor <> 1 then
  begin
    Application.MessageBox('MTU监测服务启动失败!','提示');
    Application.Terminate;
  end;
  //加载线程列表信息
  LoadThreadInfo;

  Sc_Client.Address :=CurParam.ServerIP;
  Sc_Client.Port := CurParam.DataPort;
  try
    Sc_Client.Open;
  except
    Application.MessageBox('连接MTU应用服务失败,将无法发送消息给应用服务!', '警告', MB_OK + MB_ICONINFORMATION);
  end;
end;
procedure TFm_Main_Collect.IdCollectServerConnect(AContext: TIdContext);
var
  I: Integer;
  P :TMtuDataProcess;
begin
  with MtuClients.LockList do
  try
    for I := 0 to Count - 1 do
    begin
      P := Items[i];
      if P.Ip = AContext.Connection.Socket.Binding.PeerIP then
      begin
        FLog.Write('地市编号为 '+IntToStr(P.Cityid)+' IP为 '+P.Ip+' 的MTU控制器上线.',3);
        P.ConnectTime := DateTimeToStr(Now);
        P.Status :=1;
        P.Context := AContext;
        //登记上线
        MtuCSCLogon(P.Ip,P.Status);
        AContext.Data := P;
        Break;
      end;
    end;
  finally
    MtuClients.UnlockList;
  end;
end;

procedure TFm_Main_Collect.IdCollectServerDisconnect(AContext: TIdContext);
var
  P :TMtuDataProcess;
  I : Integer;
begin
  with MtuClients.LockList do
  try
    for I := 0 to Count - 1 do
    begin
      P := Items[i];
      P.Context :=nil;
      if P.Ip = AContext.Connection.Socket.Binding.PeerIP then
      begin
        FLog.Write('地市编号为 '+IntToStr(P.Cityid)+' IP为 '+P.Ip+' 的MTU控制器下线.',3);
        P.Status :=0;
        //登记下线
        MtuCSCLogon(P.Ip,P.Status);        P.ConnectTime := DateTimeToStr(Now);
        P.Context := nil;
        //TMtuDataProcess(AContext.Data).free;
        AContext.Data := nil;
        Break;
      end;
    end;
  finally
    MtuClients.UnlockList;
  end;
  with IdCollectServer.Contexts.LockList do
  try
    Remove(AContext);
  finally
     IdCollectServer.Contexts.UnlockList;
  end;
end;

//接收MTU控制器发送的测试信息
procedure TFm_Main_Collect.IdCollectServerException(AContext: TIdContext;
  AException: Exception);
begin
  FLog.Write('监听服务异常-'+AException.Message,1);
end;

procedure TFm_Main_Collect.IdCollectServerExecute(AContext: TIdContext);
begin
  if not AContext.Connection.IOHandler.InputBufferIsEmpty then
    TMtuDataProcess(AContext.Data).Process;
  sleep(100);
end;

function TFm_Main_Collect.InitParam: integer;
var
  lIniFile:TIniFile;
  CDMAUserID, CDMAUserPWD, CDMASID: string;
begin
  if not FileExists(ExtractFilePath(Application.ExeName)+'MTS_Collect_Server.ini') then
  begin
    result :=-1;
    Exit;
  end;
  //连接字符串
  lIniFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'MTS_Collect_Server.ini');
  try
    CurParam.DBName := lIniFile.ReadString('MTS_DB','USERNAME','');
    CurParam.DBPWD := lIniFile.ReadString('MTS_DB','PASSWORD','');
    CurParam.SID := lIniFile.ReadString('MTS_DB','SERVERNAME','');
    CurParam.MTUPORT :=lIniFile.ReadInteger('MTS_PORT','MTUPORT',1026);
    CurParam.ServerIP := lIniFile.ReadString('MTS_SERVER','SERVERIP','127.0.0.1');
    CurParam.DataPort :=lIniFile.ReadInteger('MTS_SERVER','DATAPORT',211);

    CDMAUserID := lIniFile.ReadString('CDMA_DB','USERNAME','');
    CDMAUserPWD := lIniFile.ReadString('CDMA_DB','PASSWORD','');
    CDMASID := lIniFile.ReadString('CDMA_DB','SERVERNAME','');
  finally
    lIniFile.Free;
  end;
  CurDBConStr:='PLSQLRSET=1;Provider=MSDAORA.1;Password='+CurParam.DBPWD+
    ';Persist Security Info=True;User ID='+CurParam.DBName+
    ';Data Source='+CurParam.SID;

  CDMADBConStr:='PLSQLRSET=1;Provider=MSDAORA.1;Password='+CDMAUserPWD+
    ';Persist Security Info=True;User ID='+CDMAUserID+
    ';Data Source='+CDMASID;

  try
    Adoc_Main.Connected:=false;
    Adoc_Main.ConnectionString:=CurDBConStr;
    Adoc_Main.Connected:=true;
    FLog.Write('数据库连接成功!',3);
    StatusBar1.Panels[2].Text :='用户: '+CurParam.DBName+' 数据库服务名: '+CurParam.SID;
    result :=1;
  except
    result :=-2;
    Exit;
  end;
end;

procedure TFm_Main_Collect.LoadMtuConfig;
var
  sqlstr :String;
  lItem: TListItem;
  P :TMtuDataProcess ;
  i : integer;
begin
  sqlstr :='select * from mtu_controlconfig where ifineffect =1 order by cityid';
  with AdoQ_Free do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    Open;
    first;
    while not Eof do
    begin
      P :=TMtuDataProcess.Create(Flog,CurDBConStr);
      P.Cityid := FieldByName('cityid').AsInteger;
      P.MtuControl := Trim(FieldByName('mtucontrol').AsString);
      P.Status :=0;
      P.Context :=nil;
      P.Ip := Trim(FieldByName('IP').AsString);
      P.FtpIP :=FieldByName('FTPIP').AsString;
      P.ftppath :=FieldByName('FTPPATH').AsString;
      P.FtpPort :=FieldByName('FTPPORT').AsInteger;
      P.FtpUser :=FieldByName('USERNAME').AsString;
      P.FtpPassWd :=FieldByName('PASSWD').AsString;
      try
        MtuClients.LockList.Add(P);
      finally
        MtuClients.UnlockList;
      end;
      Next;
    end;
    Close;
  end;
  //加载到前台界面
  with MtuClients.LockList do
  try
    for I := 0 to Count - 1 do
    begin
      P := TMtuDataProcess(Items[i]);
      lItem :=Lv_MtuCsc.Items.Add;
      lItem.Caption :=IntToStr(P.Cityid);
      lItem.SubItems.Add(P.MtuControl);
      lItem.SubItems.Add(P.Ip);
      lItem.SubItems.Add('');
      lItem.SubItems.Add('未接入');
    end;
  finally
    MtuClients.UnlockList;
  end;

end;

procedure TFm_Main_Collect.LoadThreadInfo;
var
  i :integer;
begin
  with AdoQ_Free do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from mtu_threadconfig order by threadid');
    Open;
    first;
    while Not Eof do
    begin
      with Lv_ThreadList.Items.Add  do
      begin
        Caption:=FieldByName('threadid').AsString;
        SubItems.Add(FieldByName('threadname').AsString);
        SubItems.Add('未启动');
        SubItems.Add(FieldByName('cyctime').AsString);
        if FieldByName('state').AsInteger =0 then
          SubItems.Add('手动')
        else
          SubItems.Add('自动');
        SubItems.Add(' ');
      end;
      Next;
    end;
    Close;
  end;
  for I := 0 to Lv_ThreadList.Items.Count - 1 do
  begin
    if (Lv_ThreadList.Items[i].SubItems[1] ='未启动') and
    (Lv_ThreadList.Items[i].SubItems[3] ='自动') then
    begin
      Lv_ThreadList.Items[i].Selected := true;
      MenuItemThreadStartClick(MenuItemThreadStart);
    end;
  end;
end;

procedure TFm_Main_Collect.MenuItemThreadStartClick(Sender: TObject);
var
  lSelectItem:TListItem;
  lMyThread:TMyThread;
  lThreadFlag: integer;
begin
  lMyThread:= nil;
  lSelectItem:=Lv_ThreadList.Selected;
  if lSelectItem<>nil then
  begin
    lSelectItem.SubItems.Strings[1]:='处理中';
    //MTU自动测试线程
    if lSelectItem.Caption='1' then
      lMyThread:= AutoTestListThread.Create(CurDBConStr)
    //MTU任务发送线程
    else if lSelectItem.Caption='2' then
      lMyThread:=TTaskSendThread.Create(CurDBConStr)
    //MTU结果解析线程
    else if lSelectItem.Caption='3' then
      lMyThread:=TResultParas.Create(CurDBConStr)
    //MTU告警采集线程
    else if lSelectItem.Caption='4' then
      lMyThread:=TAlarmCollect.Create(CurDBConStr)
    //MTU告警派障线程
    else if lSelectItem.Caption='5' then
      lMyThread:=TAlarmSend.Create(CurDBConStr)
    //直放站自动测试线程
    else if lSelectItem.Caption='6' then
      lMyThread:= TDRS_AutoTestThread.Create(CurDBConStr)
    //直放站任务发送线程
    else if lSelectItem.Caption='7' then
      lMyThread:= TDRS_TaskSendThread.Create(CurDBConStr)
    //直放站短信接收线程
    else if lSelectItem.Caption='8' then
      lMyThread:= TDRS_ResultReviceThread.Create(CurDBConStr)
    //直放站结果解析线程
    else if lSelectItem.Caption='9' then
      lMyThread:= TDRS_ResultParasThread.Create(CurDBConStr,1)
    //直放站告警采集线程
    else if lSelectItem.Caption='10' then
      lMyThread:= TDRS_AlarmCollectThread.Create(CurDBConStr)
    //直放站告警派障线程
    else if lSelectItem.Caption='11' then
      lMyThread:= TDRS_AlarmSendThread.Create(CurDBConStr)
    //性能分析线程
    else if lSelectItem.Caption='21' then
      lMyThread:= TFunAnalyseThread.Create(CurDBConStr)
    //CDMA告警采集线程
    else if lSelectItem.Caption='22' then
      lMyThread:= TCDMACollectThread.Create(CurDBConStr, CDMADBConStr);

    if lMyThread<>nil then
    begin
      lMyThread.Caption :=lSelectItem.SubItems.Strings[0];
      //lMyThread.RollInterval:=StrToInt(lSelectItem.SubItems.Strings[2])*60;
      lMyThread.RollInterval:=StrToInt(lSelectItem.SubItems.Strings[2]);
      lSelectItem.Data:=lMyThread;
      lMyThread.OnProgress:=CollectTimerProgress;
      lMyThread.Log:=FLog;
      lMyThread.Resume;
      lSelectItem.SubItems.Strings[4] := DateTimeToStr(now);
    end;
  end;
end;

procedure TFm_Main_Collect.MenuItemThreadStopClick(Sender: TObject);
var
  lSelectItem:TListItem;
  lMyThread:TMyThread;
begin
  lSelectItem:=Lv_ThreadList.Selected;
  if lSelectItem<>nil then
  begin
    lMyThread:=TMyThread(lSelectItem.Data);
    if lMyThread<>nil then
    begin
      lMyThread.SetStop;
      lSelectItem.SubItems.Strings[1]:='关闭中';
      self.Lv_ThreadList.Refresh;
      while True do
      begin
        if WaitforSingleObject(lMyThread.Handle, 3000)=WAIT_OBJECT_0 then
          break;
        Application.ProcessMessages;
      end;
      lMyThread.Free;
//      CloseHandle(lMyThread.Handle);
      lSelectItem.SubItems.Strings[1]:='未启动';
      lSelectItem.Data:=nil;
    end;
  end;
end;

procedure TFm_Main_Collect.MtuCSCLogon(FIp: String; FStatus: integer);
var
  lItem: TListItem;
  i : integer;
begin
  //加上
  EnterCriticalSection(Cr);
  try
    for I := 0 to Lv_MtuCsc.Items.Count - 1 do
    begin
      lItem := Lv_MtuCsc.Items[i];
      If Trim(lItem.SubItems[1]) =FIp then
      begin
        lItem.SubItems[2] :=DateTimeToStr(now);
        if FStatus =1 then
          lItem.SubItems[3] :='已接入'
        else
          lItem.SubItems[3] :='未接入';
        break;
      end;
    end;
  finally
    LeaveCriticalSection(Cr);
  end;
end;

procedure TFm_Main_Collect.N3Click(Sender: TObject);
var
  Fm :TFm_SystemSet;
begin
  Fm :=TFm_SystemSet.Create(nil);
  try
    Fm.ShowModal;
  finally
    if Fm <> nil then
      Fm.Free;
  end;
end;

procedure TFm_Main_Collect.N6Click(Sender: TObject);
var
  Fm :TFm_TestResult;
begin
  Fm :=TFm_TestResult.Create(nil);
  try
    Fm.ShowModal;
  finally
    if Fm <> nil then
      Fm.Free;
  end;
end;

function TFm_Main_Collect.OpenMtuMonitor: integer;
var
  Bindings: TIdSocketHandles;
  IpList :TStringList;
  i : integer;
begin
  result :=0;
  Bindings := TIdSocketHandles.Create(IdCollectServer);
  IpList :=TStringList.Create;
  try
    GetLocalIPList(IpList); //取到所有IP地址
    for i :=0 to IpList.Count-1 do
    with Bindings.Add do
    begin
      IP := IpList.Strings[i];//GetLocalIP;
      Port :=CurParam.MTUPORT; //监听端口
    end;
    try
      IdCollectServer.Bindings := Bindings;
      IdCollectServer.Active := TRUE;
      if IdCollectServer.Active then
        FLog.Write('MTU监测服务启动成功!',3);
      result :=1;
    except
    end;
  finally
    if IpList <> nil then
      IpList.Free;
    if Bindings <> nil then
      Bindings.Free;
  end;
end;

procedure TFm_Main_Collect.PopupMenuThreadPopup(Sender: TObject);
var
  lSelectItem:TListItem;
begin
  lSelectItem:=Lv_ThreadList.Selected;
  if lSelectItem<>nil then
  begin
    if lSelectItem.Data=nil then
    begin
      MenuItemThreadStart.Enabled:=true;
      MenuItemThreadStop.Enabled:=false;
    end else
    begin
      MenuItemThreadStart.Enabled:=false;
      MenuItemThreadStop.Enabled:=true;
    end;
  end;
end;

procedure TFm_Main_Collect.RefreshLogClick(Sender: TObject);
begin
  GetLog;
end;

procedure TFm_Main_Collect.Sc_ClientAfterConnect(Sender: TObject);
begin
  TempInterface := IRDM_MTSDisp(IDispatch(Sc_Client.AppServer));
  AlarmServer :=  Sc_Client.AppServer;
end;

procedure TFm_Main_Collect.Sc_ClientAfterDisconnect(Sender: TObject);
begin
  TempInterface := nil;
end;

procedure TFm_Main_Collect.WMSendThread_MSG(var Msg: TMessage);
var
  Adata :PThreadData;
begin
  Adata := nil;
  if SockConError > 100 then
  begin
    FLog.Write('采集应服连接派障应服失败，请检查scktsrvr.exe 是否正常启动!',1);
    Exit;
  end;
  if TempInterface = nil then  //如果断开就重连
  try
    Sc_Client.Connected := true;
    SockConError :=0;
  except
    Inc(SockConError);
  end;
  if TempInterface <> nil then
  try
    try
      Adata := PThreadData(Msg.LParam);
    except
        On E:Exception do
        FLog.Write('读取WM_SENDTHREAD_MSG - Msg.LParam 时出现异常：'+E.Message,1);
      end;
    case Adata.command of
      1,2,3 :
      try
        TempInterface.CollectServerMsg(Adata.command,Adata.cityid,Adata.Msg);
      except
        On E:Exception do
          FLog.Write('调用CollectServerMsg接口时出现异常：'+E.Message,1);
      end;
    end;
  finally
    if Adata <> nil then  //线程里分配的内存，这里使用过后释放掉
      Dispose(Adata);
  end;
end;

procedure TFm_Main_Collect.GetLog;
var
  i,j,StrNum,Flag : integer;
  Str,SS : String;
begin
  Try
    FLog.logCS.Enter;
    StrNum := FLog.MesStrList.Count ;
    if StrNum <= LogNum then
      begin
        for i := 0  to StrNum-1 do
          begin
            Str := Trim(FLog.MesStrList.Strings[i]);
            Flag := 0;
            for j := 0 to Memo_log.Lines.Count-1 do
              begin
                ss := Trim(Memo_log.Lines[j]);
                if uppercase(SS) = UpperCase(Str) then
                  begin
                    Flag := 1;
                    Break;
                  end;
              end;
            if FLag <> 1 then
              begin
                if Memo_log.Lines.Count > LogNum then
                  begin
                    Memo_Log.Lines.Delete(0);
                  end;
                Memo_Log.Lines.Add(Str);
              end;
          end;
      end
    else
      begin
        for i := StrNum-LogNum  to StrNum-1 do
          begin
            Str := Trim(FLog.MesStrList.Strings[i]);
            Flag := 0;
            for j := 0 to Memo_log.Lines.Count-1 do
              begin
                ss := Trim(Memo_log.Lines[j]);
                if uppercase(SS) = UpperCase(Str) then
                  begin
                    Flag := 1;
                    Break;
                  end;
              end;
            if FLag <> 1 then
              begin
                if Memo_log.Lines.Count > LogNum then
                  begin
                    Memo_Log.Lines.Delete(0);
                  end;
                Memo_Log.Lines.Add(Str);
              end;
          end;
      end;
  Finally
    FLog.logCS.Leave;
  end;
  
end;


end.
