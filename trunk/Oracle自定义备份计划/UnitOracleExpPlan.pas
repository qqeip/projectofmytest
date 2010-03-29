unit UnitOracleExpPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CoolTrayIcon, ImgList, Menus, FileCtrl,
  IniFiles, ShellAPI, ExtCtrls;

type
  TFormMain = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditFilePath: TEdit;
    SpeedButton1: TSpeedButton;
    EditLogPath: TEdit;
    SpeedButton2: TSpeedButton;
    GroupBox2: TGroupBox;
    BtnOK: TButton;
    BtnBrowseLog: TButton;
    BtnDelLog: TButton;
    Label3: TLabel;
    SpeedButton3: TSpeedButton;
    GroupBox3: TGroupBox;
    CoolTrayIcon: TCoolTrayIcon;
    ImageList: TImageList;
    PopupMenu1: TPopupMenu;
    MenuShow: TMenuItem;
    MenuHide: TMenuItem;
    MenuClose: TMenuItem;
    ListBoxLog: TListBox;
    Timer1: TTimer;
    BtnConfigDB: TButton;
    LblCustomInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure CoolTrayIconClick(Sender: TObject);
    procedure MenuShowClick(Sender: TObject);
    procedure MenuHideClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnBrowseLogClick(Sender: TObject);
    procedure BtnDelLogClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnConfigDBClick(Sender: TObject);
  private
    procedure RefreshLog;
    function SearchFavorite(sPath, sType: string): TSTringList;
    procedure InitialState;
    procedure AddLog(aLogStr: string);
    function ExpFile: Boolean;
    function WinExecAndWait32(FileName: string;
      Visibility: integer): integer;
    procedure ExecPlan;
    procedure AnalysePlan;
    function CheckStatus: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TIniOptions = class(TObject)
  private

  public
    procedure LoadSettings(Ini: TIniFile);
    procedure SaveSettings(Ini: TIniFile);

    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    procedure LoadLastExecDate(const FileName: string);
    procedure SaveLastExecDate(const FileName: string);
  end;

var
  FormMain: TFormMain;
  IniOptions : TIniOptions;
  fFilePath, fLogPath: string;
  fLogFile: TStrings;

implementation

uses UnitConfigDB, UnitPublic, USetPlan;

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  IniOptions.LoadFromFile(ExtractFilePath(Application.ExeName)+IniFileName);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  InitialState;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone; //不对窗体进行任何操作
  FormMain.Hide;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormMain.InitialState;
begin
  EditFilePath.text := fFilePath;
  EditLogPath.Text  := fLogPath;
  fLogFile:= TStringList.Create;
  LblCustomInfo.Caption:= CustomInfo;
  LblCustomInfo.Hint   := CustomInfo;
  Timer1.Enabled:= CheckStatus;
  BtnOK.Enabled:=False;
  RefreshLog;
end;

function TFormMain.CheckStatus: Boolean;
begin
  if (fFilePath='') or (fLogPath='') or
     (fDBName='') or (fDBPass='') or (fDBInstance='') then
    Result:=False
  else
    Result:= True;
end;

procedure TFormMain.CoolTrayIconClick(Sender: TObject);
begin
  CoolTrayIcon.ShowMainForm;
end;

procedure TFormMain.MenuShowClick(Sender: TObject);
begin
  CoolTrayIcon.ShowMainForm;
end;

procedure TFormMain.MenuHideClick(Sender: TObject);
begin
  Application.Minimize;      // Will hide dialogs and popup windows as well (this demo has none)
  CoolTrayIcon.HideMainForm;
end;

procedure TFormMain.MenuCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.SpeedButton1Click(Sender: TObject);
var
  TempStr: string;
begin
   if selectdirectory('请选择目录','',TempStr) then
     EditFilePath.Text:= TempStr;
   if not BtnOK.Enabled then
     BtnOK.Enabled:= True;
end;

procedure TFormMain.SpeedButton2Click(Sender: TObject);
var
  TempStr: string;
begin
  if selectdirectory('请选择目录','',TempStr) then
    EditLogPath.Text:=TempStr;
  if not BtnOK.Enabled then
    BtnOK.Enabled := True;
end;

procedure TFormMain.SpeedButton3Click(Sender: TObject);
begin
  FormSetPlan.ShowModal;
  LblCustomInfo.Caption:= CustomInfo;
  LblCustomInfo.Hint:= CustomInfo;
  BtnOK.Enabled := BtnOKStatus;
end;

procedure TFormMain.RefreshLog;
begin
  if fLogPath='' then Exit;
  if FileExists(fLogPath+'\'+LogName) then
    fLogFile.LoadFromFile(fLogPath+'\'+LogName);
  ListBoxLog.Clear;
  ListBoxLog.Items:= fLogFile;
//  ListBoxLog.Clear;
//  ListBoxLog.Items.Text := SearchFavorite(fLogPath, '.txt').Text;
end;

procedure TFormMain.AddLog(aLogStr: string);
begin
  ListBoxLog.Items.Add(aLogStr);
  fLogFile:= ListBoxLog.Items;
  fLogFile.SaveToFile(fLogPath+'\'+LogName);
end;

procedure TFormMain.BtnOKClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  fFilePath := EditFilePath.Text;
  fLogPath  := EditLogPath.Text;
//  FormConfigDB.SetDBInfo;
//  FormSetPlan.SetStatus;
  IniOptions.SaveToFile(ExtractFilePath(Application.ExeName) + IniFileName);
  BtnOK.Enabled := False;
  Timer1.Enabled:= CheckStatus;
  Screen.Cursor := crDefault;
end;

procedure TFormMain.BtnConfigDBClick(Sender: TObject);
begin
  if not Assigned(FormConfigDB) then
  begin
    FormConfigDB:= TFormConfigDB.Create(nil);
    FormConfigDB.ShowModal;
  end;
  FormConfigDB.ShowModal;
  BtnOK.Enabled := BtnOKStatus;
end;

procedure TFormMain.BtnBrowseLogClick(Sender: TObject);
begin
  if FileExists(fLogPath+'\'+LogName) then
    ShellExecute(Handle,'Open',PChar('notepad.exe'),PChar(fLogPath+'\'+LogName),nil,SW_SHOWNORMAL);
end;

procedure TFormMain.BtnDelLogClick(Sender: TObject);
begin
//  if FileExists(fLogPath+'\'+LogName) then
//    DeleteFile(fLogPath+'\'+LogName);
  ListBoxLog.Clear;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  ExecPlan;
end;

{ TIniOptions }

procedure TIniOptions.LoadSettings(Ini: TIniFile);
var ftemp: Integer;
begin
  if Ini <> nil then
  begin
    fFilePath  := Ini.ReadString(IniSectionName,IniFilePath,'');
    fLogPath   := Ini.ReadString(IniSectionName,IniLogPath,'');

    //DB
    fDBName := Ini.ReadString(IniSectionDB,IniDBName,'');
    fDBPass := Ini.ReadString(IniSectionDB,IniDBPass,'');
    fDBInstance := Ini.ReadString(IniSectionDB,IniDBInstance,'');
    fExptables  := Ini.ReadString(IniSectionDB,IniExpTables,'');

    //plan
    CustomInfo   := Ini.ReadString(IniSecPlanStatus,IniCustomInfo,'');
    ftemp:= Ini.ReadInteger(IniSecPlanStatus, IniPlanStatus, -1);
    if ftemp=0 then fSetPlan.fPlantype := EveryDay;
    if ftemp=1 then fSetPlan.fPlantype := EveryWeek;
    if ftemp=2 then fSetPlan.fPlantype := EveryMonth;
    fSetPlan.fPlanWeek := Ini.ReadInteger(IniSecPlanStatus,IniPlanWeek,-1);
    fSetPlan.fPlanMonth:= Ini.ReadInteger(IniSecPlanStatus, IniPlanMonthDay,-1);
    fSetPlan.fPlanTime  := Ini.ReadInteger(IniSecPlanStatus,IniPlanTime,TimeToInt(Time));
  end;
end;

procedure TIniOptions.SaveSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    Ini.WriteString(IniSectionName,IniFilePath,fFilePath);
    Ini.WriteString(IniSectionName,IniLogPath,fLogPath);

    //DB
    Ini.WriteString(IniSectionDB,IniDBName,fDBName);
    Ini.WriteString(IniSectionDB,IniDBPass,fDBPass);
    Ini.WriteString(IniSectionDB,IniDBInstance,fDBInstance);
    Ini.WriteString(IniSectionDB,IniExpTables,fExptables);

    //plan
    Ini.WriteString(IniSecPlanStatus,IniCustomInfo,CustomInfo);
    if fSetPlan.fPlantype = EveryDay then
      Ini.WriteInteger(IniSecPlanStatus, IniPlanStatus, 0);
    if fSetPlan.fPlantype = EveryWeek then
      Ini.WriteInteger(IniSecPlanStatus, IniPlanStatus, 1);
    if fSetPlan.fPlantype = EveryMonth then
      Ini.WriteInteger(IniSecPlanStatus, IniPlanStatus, 2);

    Ini.WriteInteger(IniSecPlanStatus,IniPlanWeek,fSetPlan.fPlanWeek);
    Ini.WriteInteger(IniSecPlanStatus, IniPlanMonthDay, fSetPlan.fPlanMonth);
    Ini.WriteInteger(IniSecPlanStatus,IniPlanTime,fSetPlan.fPlanTime);

    //LastExecDate
    Ini.WriteDate(IniSecLastExecDate,IniLastExecDate,fLastExecDate);
    Ini.WriteBool(IniSecLastExecDate,IniIfTodayExec,IfTodayExec);
  end;
end;

procedure TIniOptions.LoadFromFile(const FileName: string);
var
  Ini: TIniFile;
begin
  if FileExists(FileName) then
  begin
    Ini := TIniFile.Create(FileName);
    try
      LoadSettings(Ini);
    finally
      Ini.Free;
    end;
  end;
end;

procedure TIniOptions.SaveToFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TIniOptions.LoadLastExecDate(const FileName: string);
var
  Ini: TIniFile;
begin
  if FileExists(FileName) then
  begin
    Ini := TIniFile.Create(FileName);
    try
      if Ini<>nil then
        fLastExecDate:= Ini.ReadDate(IniSecLastExecDate,IniLastExecDate,Date);
        IfTodayExec := Ini.ReadBool(IniSecLastExecDate,IniIfTodayExec,False);
    finally
      Ini.Free;
    end;
  end;
end;

procedure TIniOptions.SaveLastExecDate(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    if Ini<>nil then
       Ini.WriteDate(IniSecLastExecDate,IniLastExecDate,fLastExecDate);
       Ini.WriteBool(IniSecLastExecDate,IniIfTodayExec,IfTodayExec);
  finally
    Ini.Free;
  end;
end;

{ TFormMain }
function TFormMain.ExpFile: Boolean;
var i: Integer;
    fStr: string;
begin
  Result:= False;
  fStr:= 'exp '+fDBName+'/'+fDBPass+'@'+fDBInstance+
         ' file='+fFilePath+'\'+fDBName+datetostr(Date)+'.dmp tables=('+fExpTables+')';
//  i:= WinExecAndWait32(PChar(fStr),1);
  WinExec(PChar(fStr),1);
  AddLog(DateTimeToStr(Now) +#9+ fDBName +'数据备份成功，文件存放在:'+fFilePath+fDBName+datetostr(Date)+'.dmp');
  if i=0 then
    Result:= True
  else
    Result:= False;
end;

function TFormMain.SearchFavorite(sPath, sType: string): TSTringList;
var   
sch:TSearchrec;
  function formatPath(aPath:string):String;
  begin
      if aPath[Length(aPath)] <> '\' then
        aPath := aPath + '\';
    Result := apath;
  end;
begin
  Result:=TStringlist.Create;

  sPath := formatPath(sPath);

  if not DirectoryExists(sPath) then
  begin
    Result.Clear;
    exit;
  end;

  if FindFirst(sPath + '*', faAnyfile, sch) = 0 then
  begin
    repeat
      Application.ProcessMessages;
      if ((sch.Name = '.') or (sch.Name = '..')) then Continue;
      if DirectoryExists(sPath+sch.Name) then
      begin
        Result.AddStrings(SearchFavorite(sPath+sch.Name,sType));
      end
      else
      begin
        if (UpperCase(extractfileext(sPath+sch.Name)) = UpperCase(sType)) or (sType='.*') then
        Result.Add(sPath+sch.Name);
      end;
    until FindNext(sch) <> 0;
    SysUtils.FindClose(sch);
  end;
end;

function TFormMain.WinExecAndWait32(FileName: string; Visibility: integer): integer;
var
  zAppName: array[0..512] of char;
  zCurDir: array[0..255] of char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  ExecResult: DWORD;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName, { pointer to command line string }
    nil, { pointer to process security attributes }
    nil, { pointer to thread security attributes }
    false, { handle inheritance flag }
    CREATE_NEW_CONSOLE or { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil, { pointer to new environment block }
    nil, { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo)  then Result := -1 { pointer to PROCESS_INF }
  else
  begin
    //Application.Minimize;
    ShowWindow(Application.Handle, SW_show);
    WindowState := wsnormal;//wsminimized;
    Enabled := false;
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, ExecResult);
    Result := ExecResult;
    Enabled := true;
    WindowState := wsnormal;//wsMaximized;
    ShowWindow(Application.Handle, SW_SHOWNORMAL);
    BringToFront;
    Application.BringToFront;
    SetFocus;
  end;
end;

procedure TFormMain.ExecPlan;
begin
  case fSetPlan.fPlantype of
  EveryDay:
  begin
    if TimeToInt(Time)>=fSetPlan.fPlanTime then
    begin
      AnalysePlan;
    end;
  end;
  EveryWeek:
  begin
    if DayOfWeek(Now)= fSetPlan.fPlanWeek then
    begin
      if TimeToInt(Time)>=fSetPlan.fPlanTime then
        AnalysePlan;
    end;
  end;
  EveryMonth:
  begin
    if StrToInt(FormatDateTime('dd',Now))=fSetPlan.fPlanMonth then
      if TimeToInt(Time)>=fSetPlan.fPlanTime then
        AnalysePlan;
  end;
  end;
end;

procedure TFormMain.AnalysePlan;
var DateMinus : Integer;
begin
  IniOptions.LoadLastExecDate(ExtractFilePath(Application.ExeName)+IniFileName);
  DateMinus := StrToInt(FormatDateTime('yyyyMMdd',Now))-StrToInt(FormatDateTime('yyyyMMdd',fLastExecDate));
  if DateMinus>0 then IfTodayExec:= False;
  if (not IfTodayExec) then
  begin
    try
      ExpFile;
      fLastExecDate:= Date;
    finally
      IfTodayExec:= True;
      IniOptions.SaveLastExecDate(ExtractFilePath(Application.ExeName)+IniFileName);
    end;
  end;
end;

end.
