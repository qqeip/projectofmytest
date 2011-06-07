unit UnitGetPingResult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TShowMethod = procedure(str: string) of object;
  TFormGetPingResult = class(TForm)
    BtnPing: TButton;
    Memo1: TMemo;
    EdtIP: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnPingClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowMethod(str: string);
  end;

  function RunCommand(const cmd: string; Show: TShowMethod = nil): string;

var
  FormGetPingResult: TFormGetPingResult;

implementation

{$R *.dfm}

procedure TFormGetPingResult.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormGetPingResult.FormShow(Sender: TObject);
begin
//
end;

procedure TFormGetPingResult.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormGetPingResult.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormGetPingResult.ShowMethod(str: string);
begin
  Memo1.Lines.Add(str);
end;

procedure TFormGetPingResult.BtnPingClick(Sender: TObject);
var
  res: string;
begin
  res := RunCommand('ping '+EdtIP.Text, ShowMethod);
  ShowMessage(res);
end;

function RunCommand(const cmd: string; Show: TShowMethod = nil): string;
var
  hReadPipe,hWritePipe:THandle;
  si:STARTUPINFO;
  lsa:SECURITY_ATTRIBUTES;
  pi:PROCESS_INFORMATION;
  cchReadBuffer:DWORD;
  pOutStr:PChar;
  res, strCMD:string;
begin
  strcmd := 'cmd.exe /k ' + cmd;
  pOutStr := AllocMem(5000);
  lsa.nLength := SizeOf(SECURITY_ATTRIBUTES);
  lsa.lpSecurityDescriptor := nil;
  lsa.bInheritHandle := True;
  if not CreatePipe(hReadPipe, hWritePipe, @lsa, 0) then Exit;
  FillChar(si, SizeOf(STARTUPINFO), 0);
  si.cb:=sizeof(STARTUPINFO);
  si.dwFlags:=(STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW);
  si.wShowWindow:=SW_HIDE;
  si.hStdOutput:=hWritePipe;

  if not CreateProcess(nil, PChar(strCMD), nil, nil, true, 0, nil, nil, si, pi) then Exit;
  while(true) do
  begin
    if not PeekNamedPipe(hReadPipe, pOutStr, 1, @cchReadBuffer, nil, nil) then break;
    if cchReadBuffer <> 0 then
    begin
      if not ReadFile(hReadPipe, pOutStr^, 4096, cchReadBuffer, nil) then break;
      pOutStr[cchReadbuffer]:=chr(0);
      if @Show <> nil then Show(pOutStr);
      res := res + pOutStr;
    end else if(WaitForSingleObject(pi.hProcess ,0) = WAIT_OBJECT_0) then break;
    Sleep(10);
    Application.ProcessMessages;
  end;
  pOutStr[cchReadBuffer]:=chr(0);

  CloseHandle(hReadPipe);
  CloseHandle(pi.hThread);
  CloseHandle(pi.hProcess);
  CloseHandle(hWritePipe);
  FreeMem(pOutStr);
  Result := res;
end;

end.
