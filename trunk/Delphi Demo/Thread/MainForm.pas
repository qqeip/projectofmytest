unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uThread;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
  FMyThread:TMyThread;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  FMyThread := TMyThread.Create(False);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin   
  //暂停
  if not FMyThread.Suspended then
  FMyThread.Suspend;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  //恢复
  FMyThread.Resume;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
  //强行终止进程
  FMyThread.Terminate;
end;

procedure TfrmMain.Button5Click(Sender: TObject);
begin
  FMyThread.WaitFor;
end;

end.
