unit Unt_EXE_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Unt_EXE_CDMACollecctThread, StdCtrls, ComCtrls, DB, ADODB,
  ExtCtrls;

const
  WM_CDMA_MSG  = WM_USER + 110;    

type
  TFrmMain = class(TForm)
    btCDMA: TButton;
    reLog: TRichEdit;
    ADOConnection: TADOConnection;
    tTime: TTimer;
    tHeartBeat: TTimer;
    procedure btCDMAClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tTimeTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tHeartBeatTimer(Sender: TObject);
  private
    { Private declarations }

    CDMACollecctThread : TCDMACollecctThread;  //CDMA轮询采集线程
    CDMAMainHandle: THandle;
    strCon, sIsNoClearHis, sIsDebug: string;

    procedure SaveRunLog;
  public
    { Public declarations }

    blSaveLogInDepend: boolean;
    procedure GiveMainCDMAMsg(iFlag: Integer; iOption: Integer=0);
  end;

var
  FrmMain: TFrmMain;  

implementation

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);     
begin
  //strCon := 'Provider=MSDAORA.1;Password=cfmstest;User ID=cfmstest;Data Source=pop_10.0.0.22;Persist Security Info=True;Extended Properties="PLSQLRSET=1"';

  blSaveLogInDepend := false;

  strCon := trim(ParamStr(1));
  CDMAMainHandle := StrToInt(ParamStr(2));

  sIsDebug := trim(ParamStr(3));
  sIsNoClearHis := trim(ParamStr(4));

  GiveMainCDMAMsg(0);

  reLog.MaxLength := $7FFFFFF0;
  reLog.PlainText := true;

  ADOConnection.ConnectionString := strCon;
  try
    ADOConnection.Connected := true;
  except
    GiveMainCDMAMsg(11);
    reLog.Lines.Add('打开数据库连接异常！');
    Application.Terminate;
    Exit;
  end;

  btCDMAClick(self);
end;

procedure TFrmMain.btCDMAClick(Sender: TObject);
begin
  try
    CDMACollecctThread := TCDMACollecctThread.Create(strCon, reLog, btCDMA);
    CDMACollecctThread.blIsNoClearHis := sIsNoClearHis='1';
    CDMACollecctThread.SetDebug(sIsDebug='1');

    CDMACollecctThread.ResumeThread; //CDMA轮询采集线程
  except
    GiveMainCDMAMsg(12);
    reLog.Lines.Add('创建采集线程异常！');
    Application.Terminate;
    Exit;
  end;
end;  

procedure TFrmMain.tTimeTimer(Sender: TObject);
begin
  tTime.Enabled := false;

  if (sIsDebug='1') or blSaveLogInDepend then SaveRunLog;

  tHeartBeat.Enabled := false;

  self.Visible := false;

  Application.Terminate;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  GiveMainCDMAMsg(9);
end;

procedure TFrmMain.GiveMainCDMAMsg(iFlag: Integer; iOption: Integer=0);
begin
  SendMessage(CDMAMainHandle, WM_CDMA_MSG, iOption, iFlag);
end;

procedure TFrmMain.tHeartBeatTimer(Sender: TObject);
begin
  GiveMainCDMAMsg(-1);
end;

procedure TFrmMain.SaveRunLog;
var
  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  filename,FilePath : String;
begin
  try
    Present:= Now;
    DecodeDate(Present, Year, Month, Day);
    DecodeTime(Present, Hour, Min, Sec, MSec);
    if blSaveLogInDepend then
      filename :=Format('%.4d',[year])+Format('%.2d',[month])+Format('%.2d',[day])+'_'+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+'_'+Format('%.4d',[MSec])+'.Txt'
    else
      filename :=Format('%.4d',[year])+Format('%.2d',[month])+Format('%.2d',[day])+'.Txt';
      
    FilePath:=ExtractFilePath(ParamStr(0))+'RunLog\';    //FilePath
    if not DirectoryExists(FilePath) then
     ForceDirectories(FilePath);
    with reLog.Lines do
    begin
       SaveToFile(FilePath+'CollDebug'+filename);
       Clear;
    end;
  except
    on E: Exception do
    begin
      reLog.Lines.Add('调试日志保存出错！'+E.Message);
    end;
  end;  

end;

end.
