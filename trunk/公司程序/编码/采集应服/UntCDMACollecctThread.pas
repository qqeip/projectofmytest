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
  AppendRunLog('���ɼ����� ����');
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
      AppendRunLog('�ɼ��̲߳ɼ���ʱ������ʱ��'+TimeToStr(EndTime-StartTime)+'; ��ֹ�ɼ��̣߳�', true);
      CheckCDMAProcess(true);
      break;
    end;

    if blCollectStart then blHeartBeatEnd := true;
    sleep(2000);
    if not blCollectFinished and blHeartBeatEnd then AppendRunLog('δ�յ��ɼ��߳�����֪ͨ���ɲɼ��߳��쳣��ֹ��', true);

  until blCollectFinished or blHeartBeatEnd or self.Terminated or Application.Terminated;    

  AppendRunLog('���ɼ����� ��ͣ');  
end;  


procedure TCDMACollecctThread.ProcessCDMAMes(iFlag: Integer; iOption: Integer);
begin
{
  -1 �ɼ�����
  
  0 �ɼ�������
  1 �����ɼ��̣߳�׼���ɼ��澯������
  2 ��ǰ�ɼ����������Ϊ��
  7 ������  �ɼ���ɡ�����
  8 һ�ֲɼ���ɣ���ͣ�ɼ��̡߳�����
  9 �ɼ������˳�

  10 �������  �ӿ�����ʧ�ܣ�������������������ӣ�
  11 �����ݿ������쳣��
  12 �����ɼ��߳��쳣��
}
  case iFlag of
    -1:
    begin
      blHeartBeatEnd := false;
    end;
    
    0:
    begin
      blCollectStart := true;
      AppendRunLog('�ɼ�������');
    end;
    1: AppendRunLog('�����ɼ��̣߳�׼���ɼ��澯������', true);
    2: AppendRunLog('��ǰ�ɼ����������Ϊ��'+IntToStr(iOption), true);
    7:
    begin
      AppendRunLog('������ '+IntToStr(iOption)+' �ɼ���ɡ�����', true);
    end;
    8: AppendRunLog('һ�ֲɼ���ɣ���ͣ�ɼ��̡߳�����', true);
    9:
    begin
      blCollectFinished := true;
      AppendRunLog('�ɼ������˳�');
    end;

    10: AppendRunLog('������� '+IntToStr(iOption)+' �ӿ�����ʧ�ܣ�������������������ӣ�', true);
    11: AppendRunLog('�����ݿ������쳣��', true);
    12: AppendRunLog('�����ɼ��߳��쳣��', true);
  end;


end;    

function TCDMACollecctThread.CheckCDMAProcess(blIsKilled: boolean=false): Boolean;
var
  lppe: TProcessEntry32;
  found : boolean;
  Hand : THandle;
  KillHandle: THandle;//����ɱ������
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
        TerminateProcess(KillHandle, 0);//ǿ�ƹرս���
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
