unit UnitServerMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin, ExtCtrls, Buttons, IdBaseComponent,
  IdComponent, IdTCPServer, ImgList, Menus, IdSocketHandle, IniFiles, UnitTCPServer,
  UnitCommon;

type
  TFormServerMain = class(TForm)
    Panel6: TPanel;
    Status: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel4: TPanel;
    Label2: TLabel;
    Lb_ClientCount: TLabel;
    Panel2: TPanel;
    Panel_Broad: TPanel;
    Btn_BroadCast: TSpeedButton;
    MsgInfo: TMemo;
    Panel3: TPanel;
    Panel1: TPanel;
    Splitter1: TSplitter;
    ListView: TListView;
    TabSheet2: TTabSheet;
    MsgLog: TRichEdit;
    Panel7: TPanel;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Sb_ScktSrvr: TSpeedButton;
    Ed_ScktSrvr: TEdit;
    Chb_Scktsrvr: TCheckBox;
    Chb_ScktsrvrClose: TCheckBox;
    Chb_Startup: TCheckBox;
    Chb_Patrol: TCheckBox;
    Gb_patrol: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Sb_AppPath: TSpeedButton;
    Sb_AppTitle: TSpeedButton;
    Ed_AppPath: TEdit;
    Se_Interval: TSpinEdit;
    Ed_AppTitle: TEdit;
    Pb_Patrol: TProgressBar;
    Bt_CloseApp: TButton;
    Bt_RunApp: TButton;
    Bt_SaveParam: TButton;
    Chb_AppClose: TCheckBox;
    PopMenu_User: TPopupMenu;
    PM_DisConnect: TMenuItem;
    ImageList1: TImageList;
    Timer: TTimer;
    Od_AppPath: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Se_IntervalChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_BroadCastClick(Sender: TObject);
    procedure PM_DisConnectClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure Chb_PatrolClick(Sender: TObject);
    procedure Sb_AppPathClick(Sender: TObject);
    procedure Bt_SaveParamClick(Sender: TObject);
    procedure Bt_CloseAppClick(Sender: TObject);
    procedure Bt_RunAppClick(Sender: TObject);
    procedure Chb_ScktsrvrClick(Sender: TObject);
    procedure Sb_ScktSrvrClick(Sender: TObject);
    procedure Sb_AppTitleClick(Sender: TObject);
  private
    NoRespondNum: Integer;  //无反应次数、巡检间隔
    lTcpServer:TTCPServer;
    FClientCount: Integer;
    procedure PatrolConfig;
    procedure WriteMessageLog(msg: String);
    procedure AppSrvPatrol;
    function CollectServerSendMsg(Event: integer; var Companyid: integer;
      msg: String): Boolean;
    { Private declarations }
    procedure ServerException(Sender: TObject; E: Exception);
  public
    IsClose :Boolean;
    { Public declarations }
    procedure WMThread_msg(var Msg: TMessage);MESSAGE WM_THREAD_MSG;
    procedure UpdateClientCount(Incr: Integer);
  end;

var
  FormServerMain: TFormServerMain;

implementation

uses UnitDataModuleLocal, UnitPatrolAppSrv;

{$R *.dfm}

procedure TFormServerMain.FormCreate(Sender: TObject);
begin
  lTcpServer:=TTCPServer.Create;
  lTcpServer.FMsgPort:=DataModuleLocal.ServiceInfo.MsgPort;
  lTcpServer.FListView:=ListView;
  if lTcpServer.Active<>1 then
  begin
    if Application.MessageBox(pchar('实时消息服务启动失败,消息通知将无法发送给客户端,是否退出程序？'), '警告', mb_okcancel + mb_defbutton1) = IDOK then
      Application.Terminate;
  end;
  PageControl1.ActivePageIndex :=0;
  IsClose := false;
  //Maxlength属性设置为$7FFFFFF0,可存放接近2GB的文本
  MsgLog.MaxLength := $7FFFFFF0;
  MsgLog.PlainText := true;

  application.OnException := ServerException;
end;

procedure TFormServerMain.FormShow(Sender: TObject);
begin
  DataModuleLocal.InitVariable;
  with DataModuleLocal.ServiceInfo do
  begin
    Status.Panels[1].Text:='系统起动于：'+datetimetostr(now);
    status.Panels[2].Text:='ServiceName : '+ServiceName+'    User ID : '+UserName;
  end;
  Status.Panels[0].Text := Status.Panels[0].Text +' Bulid:'+GetFileTimeInfor(Application.ExeName,2);
  PatrolConfig();
end;

procedure TFormServerMain.PatrolConfig();
var
  IniFile : TIniFile;
begin
  iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'CFMSServiceInfo.ini');
  try
    Ed_AppPath.Text := IniFile.ReadString('Patrol Config','AppPath','');
    Ed_AppTitle.Text := IniFile.ReadString('Patrol Config','AppTitle','');
    Se_Interval.Value := IniFile.ReadInteger('Patrol Config','Interval',5);

    Chb_Startup.Checked := IniFile.ReadBool('Patrol Config','Startup',false);
    Chb_Patrol.Checked := IniFile.ReadBool('Patrol Config','Patrol',false);
    Chb_AppClose.Checked := IniFile.ReadBool('Patrol Config','AppClose',false);

    Ed_ScktSrvr.Text := IniFile.ReadString('ScktSrvr Config','SrvrPath','');
    Chb_Scktsrvr.Checked := IniFile.ReadBool('ScktSrvr Config','IsStartup',False);
    Chb_ScktSrvrClose.Checked := IniFile.ReadBool('ScktSrvr Config','IsClose',true);
  finally
    iniFile.Free;
  end;

  NoRespondNum:=0;
  if Chb_Scktsrvr.Checked then
  begin
    KillTask(SeparatePath(Ed_ScktSrvr.Text));
    if not RunTheApp(Ed_ScktSrvr.Text) then
      MsgLog.Lines.Add(datetimetostr(now)+'<ScktSrvr服务>启动：<scktsrvr服务>启动失败！');
  end;
  if Chb_Startup.Checked then
  begin
    KillTask(SeparatePath(Ed_AppPath.Text));
    if not RunTheApp(Ed_AppPath.Text) then
      MsgLog.Lines.Add(datetimetostr(now)+'<数据采集应服>启动：<数据采集应服>启动失败！');
  end;
  Se_IntervalChange(Self);
  Timer.Enabled:=true;
end;

procedure TFormServerMain.Se_IntervalChange(Sender: TObject);
begin
  Pb_Patrol.Min:=0;
  Pb_Patrol.Max:=Se_Interval.Value*60;
  Pb_Patrol.Position:=0;
  Pb_Patrol.Step:=1;
end;

procedure TFormServerMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if application.MessageBox('确定要退出《自动派障系统应服》吗？','提示',mb_okcancel+MB_ICONQUESTION)=IDOK then
  begin
    IsClose := true;
    if Chb_ScktsrvrClose.Checked then
      KillTask(SeparatePath(Ed_ScktSrvr.Text));
    if Chb_AppClose.Checked then
      KillTask(SeparatePath(Ed_AppPath.Text));
    lTcpServer.DisConnect;
    lTcpServer.Free;
    Action:=cafree;   
  end
  else
    Action:=caNone;
end;

procedure TFormServerMain.Btn_BroadCastClick(Sender: TObject);
var
  Msg : String;
begin
  Msg := Trim(MsgInfo.Lines.Text);
  lTcpServer.BroadcastMsg_(Msg);
end;

procedure TFormServerMain.PM_DisConnectClick(Sender: TObject);
begin
  lTcpServer.DisConnect;
end;

procedure TFormServerMain.TimerTimer(Sender: TObject);
begin
  if Chb_Patrol.Checked then
  begin
    Pb_Patrol.StepIt;
    if Pb_Patrol.Position>=Pb_Patrol.Max then //如到指定间隔，则巡检一次
    begin
      AppSrvPatrol;
      Pb_Patrol.Position:=0;
    end;
  end;
end;

procedure TFormServerMain.AppSrvPatrol;
const
  NoRespondLimited = 3;
var
  hCurWindow: HWnd;  //窗口句柄
  tempstr:string;
begin
  //   Find   Word   by   classname
  hCurWindow := FindWindow(nil, PChar(Ed_AppTitle.Text));
  if hCurWindow <> 0 then
    case IsAppRespondig(hCurWindow) of
      0 : begin
            Inc(NoRespondNum);
            MsgLog.Lines.Add(datetimetostr(now)+' <数据采集应服>巡检：<数据采集应服>无响应<'+inttostr(NoRespondNum)+'>次！');
          end;
      1 : NoRespondNum:=0;
    else
      MsgLog.Lines.Add(datetimetostr(now)+' <数据采集应服>巡检：无效句柄！');
    end
  else
  begin
    MsgLog.Lines.Add(datetimetostr(now)+' <数据采集应服>巡检：<数据采集应服>未运行！');
    if Chb_Startup.Checked then
      if RunTheApp(Ed_AppPath.Text) then
        MsgLog.Lines.Add(datetimetostr(now)+' <数据采集应服>巡检：<数据采集应服>启动成功！')
      else
        MsgLog.Lines.Add(datetimetostr(now)+' <数据采集应服>巡检：<数据采集应服>启动失败！');
  end;

  if NoRespondNum>=NoRespondLimited then
  begin
    tempstr:=SeparatePath(Ed_AppPath.Text);
    KillTask(tempstr);
    //sleep(500);
    if not RunTheApp(Ed_AppPath.Text) then
      MsgLog.Lines.Add(datetimetostr(now)+' <数据采集应服>巡检：<数据采集应服>启动失败！');
    MsgLog.Lines.Add(datetimetostr(now)+' <数据采集应服>巡检：关闭目标和重新运行目标已被执行到，分离后的目标名称：'+tempstr);
    NoRespondNum:=0;
  end;
end;

procedure TFormServerMain.WriteMessageLog(msg: String);
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  filename,FilePath : String;
  Present: TDateTime;
begin
  //如果进入窗口关闭就不要写日志了，会资原死锁.
  if FormServerMain.IsClose then Exit;
  Present:= Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  filename :=Format('%.4d',[year])+Format('%.2d',[month])+Format('%.2d',[day])+'_'+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+'_'+Format('%.4d',[MSec])+'.Txt';
  with FormServerMain.MsgLog.Lines do
  begin
    if Count > 10000 then
    begin
       FilePath:=ExtractFilePath(ParamStr(0))+'RunLog\';    //FilePath
       if not DirectoryExists(FilePath) then
         ForceDirectories(FilePath);
       SaveToFile(FilePath+'MsgLog_'+filename);
       Clear;
    end;
    Add(DateTimeToStr(now)+'  '+msg);
  end;
end;


procedure TFormServerMain.Chb_PatrolClick(Sender: TObject);
begin
  if Chb_Patrol.Checked then
  begin
    if not FileExists(Ed_AppPath.Text) then
    begin
      ShowMessage('无效的<数据采集应服>路径，请检查后重设！');
      Chb_Patrol.Checked:=false;
    end;
    if trim(Ed_AppTitle.Text)='' then
    begin
      ShowMessage('请设置<数据采集应服>标题名称！');
      Chb_Patrol.Checked:=false;
    end;
  end;
end;

procedure TFormServerMain.Sb_AppPathClick(Sender: TObject);
begin
  Od_AppPath.Title:='选择<数据采集应服>应用程序';
  if Od_AppPath.Execute then
    Ed_AppPath.Text:=Od_AppPath.FileName;
end;

procedure TFormServerMain.Bt_SaveParamClick(Sender: TObject);
var
  IniFile : TIniFile;
begin
  iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'CFMSServiceInfo.ini');
  try
    iniFile.WriteBool('Patrol Config','Startup', Chb_Startup.Checked);
    iniFile.WriteBool('Patrol Config','Patrol', Chb_Patrol.Checked);
    iniFile.WriteBool('Patrol Config','AppClose', Chb_AppClose.Checked);

    iniFile.WriteString('Patrol Config','AppPath', Ed_AppPath.Text);
    iniFile.WriteString('Patrol Config','AppTitle', Ed_AppTitle.Text);
    iniFile.WriteInteger('Patrol Config','Interval', Se_Interval.Value);

    iniFile.WriteBool('ScktSrvr Config','IsStartup', Chb_Scktsrvr.Checked);
    iniFile.WriteBool('ScktSrvr Config','IsClose', Chb_ScktsrvrClose.Checked);
    iniFile.WriteString('ScktSrvr Config','SrvrPath', Ed_ScktSrvr.Text);
  finally
    iniFile.Free;
  end;
end;

procedure TFormServerMain.Bt_CloseAppClick(Sender: TObject);
begin  
  KillTask(SeparatePath(Ed_AppPath.Text));
end;

procedure TFormServerMain.Bt_RunAppClick(Sender: TObject);
begin
  if not RunTheApp(Ed_AppPath.Text) then
    MsgLog.Lines.Add(datetimetostr(now)+'<数据采集应服>操作：<数据采集应服>启动失败！');
end;

procedure TFormServerMain.Chb_ScktsrvrClick(Sender: TObject);
begin
  if Chb_Scktsrvr.Checked and (not FileExists(Ed_ScktSrvr.Text)) then
  begin
    ShowMessage('无效的<scktsrvr服务>路径，请检查后重设！');
    Chb_Scktsrvr.Checked:=false;
  end;
end;

procedure TFormServerMain.Sb_ScktSrvrClick(Sender: TObject);
begin
  Od_AppPath.Title:='选择<ScktSrvr服务>应用程序';
  if Od_AppPath.Execute then
    Ed_ScktSrvr.Text:=Od_AppPath.FileName;
end;

procedure TFormServerMain.Sb_AppTitleClick(Sender: TObject);
begin
  Ed_AppTitle.Text:='告警采集及派发服务系统';
end;

procedure TFormServerMain.WMThread_msg(var Msg: TMessage);
var
  AData :PThreadData;
begin
  Adata := nil;
  try
    try
      Adata := PThreadData(Msg.LParam);
      CollectServerSendMsg(AData.command,AData.Companyid,AData.Msg);
    except
      On E:Exception do
      if MsgLog <> nil then
        MsgLog.Lines.Add('读取WMThread_msg － Msg.LParam 时出现异常：'+E.Message);
    end;
  finally
    if Adata <> nil then
      Dispose(Adata);
  end;
end;

function TFormServerMain.CollectServerSendMsg(Event:integer;var Companyid:integer;msg: String):Boolean;
begin
  WriteMessageLog('来自巡检系统的接口消息 : 消息命令 - '+IntToStr(Event)+'维修单位编号 - '+IntToStr(Companyid));
  result :=lTcpServer.CollectServerSendMsg(Event,Companyid,msg);
end;

procedure TFormServerMain.UpdateClientCount(Incr: Integer);
begin
  FClientCount := FClientCount + Incr;
  Lb_ClientCount.Caption := IntToStr(FClientCount);
end;

procedure TFormServerMain.ServerException(Sender: TObject; E: Exception);
begin
  MsgLog.Lines.Add(datetimetostr(now)+'内部调式信息：'+E.Message);
end;

end.
