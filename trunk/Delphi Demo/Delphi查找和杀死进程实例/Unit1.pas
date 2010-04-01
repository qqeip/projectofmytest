unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TLHelp32;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    Edit1: TEdit;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  lppe: TProcessEntry32;
  found : boolean;
  Hand : THandle;
begin
  listbox1.Items.Clear;
  Hand := CreateToolhelp32Snapshot(TH32CS_SNAPALL,0);
  found := Process32First(Hand,lppe);
  while found do
  begin
    ListBox1.Items.Add(StrPas(lppe.szExeFile));//�г����н��̡�
    {if StrPas(lppe.szExeFile)='sqlservr.exe'then
    begin
      showmessage('find sqlservr');
    end;}
    found := Process32Next(Hand,lppe);
  end;
  showmessage('��ǰϵͳ�ܹ���'+inttostr(listbox1.Items.Count)+'���̣�');
end;


procedure TForm1.Button2Click(Sender: TObject);
var
  I,J:INTEGER;
begin
  J:=0;
  With ListBox1 do
  for i := Count - 1 DownTo 0 do
  begin
    if (items[i]=trim(edit1.Text)) or (items[i]=UpperCase(trim(edit1.Text))) then
    begin
      inc(J);
    End;
  end;
  if J=1 then
  begin
    showmessage('�ҵ�����:'+trim(edit1.Text));
    exit;
  end;
  if J>1 then
  begin
    showmessage('�ҵ�����:'+trim(edit1.Text)+'��'+inttostr(J)+'��^_^');
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ListBox1.Items.Clear;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  edit1.Text:=listbox1.Items[listbox1.ItemIndex];
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  lppe: TProcessEntry32;
  found : boolean;
  Hand : THandle;
  KillHandle: THandle;//����ɱ������
begin
  lppe.dwSize := SizeOf(TProcessEntry32);
  Hand := CreateToolhelp32Snapshot(TH32CS_SNAPALL,0);
  found := Process32First(Hand,lppe);
  while found do
  begin
    //showmessage('�Ѿ��ر�'+listbox1.Items[listbox1.ItemIndex]+'���̣�');
    if StrPas(lppe.szExeFile)=listbox1.Items[listbox1.ItemIndex] then
    begin
      KillHandle := OpenProcess(PROCESS_TERMINATE, False, lppe.th32ProcessID);
      TerminateProcess(KillHandle, 0);//ǿ�ƹرս���
      CloseHandle(KillHandle);
      showmessage('�Ѿ��ر�'+StrPas(lppe.szExeFile)+'���̣�');
    end;
    found := Process32Next(Hand,lppe);
  end;
  //FormCreate(Self);//��ɱ������������б�
  self.Button1.Click;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  lppe: TProcessEntry32;
  found : boolean;
  Hand : THandle;
begin
  listbox1.Items.Clear;
  Hand := CreateToolhelp32Snapshot(TH32CS_SNAPALL,0);
  found := Process32First(Hand,lppe);
  while found do
  begin
    ListBox1.Items.Add(StrPas(lppe.szExeFile));//�г����н��̡�
    found := Process32Next(Hand,lppe);
  end;
end;

end.
