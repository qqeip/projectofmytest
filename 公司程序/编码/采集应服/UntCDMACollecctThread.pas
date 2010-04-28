unit UntCDMACollecctThread;

interface

uses
  Classes, SysUtils, Windows, UntBaseDBThread, ComCtrls, StdCtrls, Variants,
  Forms, ShellAPI, Messages, TLHelp32;

const
  EXE_CDMA_Name = 'EXE_CDMA.exe';

type
  TCDMACollecctThread = class(TBaseDBThread)
  private
    blCollectFinished, blHeartBeatEnd, blCollectStart: boolean;

    function CheckCDMAProcess(blIsKilled: boolean=false): Boolean;
  protected
    procedure DoExecute; override;   
  public
    blNoClearHis: boolean;
    
    constructor Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
    destructor Destroy; override;

    procedure SetDebug(pblDebug: boolean);
    procedure ProcessCDMAMes(iFlag: Integer; iOption: Integer);
  end;

implementation

uses UntFunc;

constructor TCDMACollecctThread.Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
begin
  inherited Create(DBConn, reRunLog, btRunThread);

  blDebug := true;
  blNoClearHis := false;
end;

destructor TCDMACollecctThread.Destroy;
begin   
  CheckCDMAProcess(true);

  inherited;
end;

procedure TCDMACollecctThread.DoExecute;
var
  strCon: string;
  MainHandle: THandle;
  StartTime, EndTime: TDateTime;
  sIsDebug, sblNoClearHis: string;
begin
  AppendRunLog('主采集程序 开启');
  blCollectFinished := false;

  strCon := '"'+Ado_DBConn.ConnectionString+'"';
  MainHandle := Application.MainForm.Handle;

  CheckCDMAProcess(true);
  StartTime := now;
  blCollectStart := false;

  sIsDebug := '0';
  if blDebug then sIsDebug := '1';
  sblNoClearHis := '0';
  if blNoClearHis then sblNoClearHis := '1';    

  ShellExecute(0,PChar('Open'),PChar(EXE_CDMA_Name),PChar(strCon+' '+IntToStr(MainHandle)+' '+sIsDebug+' '+sblNoClearHis),nil,SW_SHOW);

  repeat
    EndTime := now;

    if (EndTime-StartTime)>10/60/24then
    begin
      AppendRunLog('采集线程采集超时，已用时：'+TimeToStr(EndTime-StartTime)+'; 中止采集线程！', true);
      CheckCDMAProcess(true);
      break;
    end;

    if blCollectStart then blHeartBeatEnd := true;
    sleep(2000);
    if not blCollectFinished and blHeartBeatEnd then AppendRunLog('未收到采集线程心跳通知，疑采集线程异常终止！', true);

  until blCollectFinished or blHeartBeatEnd or self.Terminated or Application.Terminated;    

  AppendRunLog('主采集程序 暂停');  
end;  


procedure TCDMACollecctThread.ProcessCDMAMes(iFlag: Integer; iOption: Integer);
begin
{
  -1 采集心跳
  
  0 采集程序开启
  1 启动采集线程，准备采集告警。。。
  2 当前采集服务器序号为：
  7 服务器  采集完成。。。
  8 一轮采集完成，暂停采集线程。。。
  9 采集程序退出

  10 与服务器  接口连接失败，请检查与服务器网络连接！
  11 打开数据库连接异常！
  12 创建采集线程异常！
}
  case iFlag of
    -1:
    begin
      blHeartBeatEnd := false;
    end;
    
    0:
    begin
      blCollectStart := true;
      AppendRunLog('采集程序开启');
    end;
    1: AppendRunLog('启动采集线程，准备采集告警。。。', true);
    2: AppendRunLog('当前采集服务器序号为：'+IntToStr(iOption), true);
    7:
    begin
      AppendRunLog('服务器 '+IntToStr(iOption)+' 采集完成。。。', true);
    end;
    8: AppendRunLog('一轮采集完成，暂停采集线程。。。', true);
    9:
    begin
      blCollectFinished := true;
      AppendRunLog('采集程序退出');
    end;

    10: AppendRunLog('与服务器 '+IntToStr(iOption)+' 接口连接失败，请检查与服务器网络连接！', true);
    11: AppendRunLog('打开数据库连接异常！', true);
    12: AppendRunLog('创建采集线程异常！', true);
  end;


end;    

function TCDMACollecctThread.CheckCDMAProcess(blIsKilled: boolean=false): Boolean;
var
  lppe: TProcessEntry32;
  found : boolean;
  Hand : THandle;
  KillHandle: THandle;//用于杀死进程
  iCount: Integer;
begin
  iCount := 0;
  lppe.dwSize := SizeOf(TProcessEntry32);
  Hand := CreateToolhelp32Snapshot(TH32CS_SNAPALL,0);
  found := Process32First(Hand,lppe);
  while found do
  begin
    if StrPas(lppe.szExeFile)=EXE_CDMA_Name then
    begin
      iCount := iCount+1;
      if blIsKilled then
      begin
        KillHandle := OpenProcess(PROCESS_TERMINATE, False, lppe.th32ProcessID);
        TerminateProcess(KillHandle, 0);//强制关闭进程
        CloseHandle(KillHandle);
      end;
    end;
    found := Process32Next(Hand,lppe);
  end;     
  Result := iCount=1;
end;

procedure TCDMACollecctThread.SetDebug(pblDebug: boolean);
begin
  self.blDebug := pblDebug;
end;


end.
