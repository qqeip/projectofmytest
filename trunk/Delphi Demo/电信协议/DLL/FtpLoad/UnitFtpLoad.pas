unit UnitFtpLoad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP, IdFTPCommon, IdFTPList;

type
  TFormFtpLoad = class(TForm)
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Edt_FTPAddr: TEdit;
    Edt_FTPUser: TEdit;
    Edt_FTPPass: TEdit;
    Btn_TestLink: TButton;
    Btn_Save: TButton;
    Edt_FTPPort: TEdit;
    GroupBox7: TGroupBox;
    Btn_Close: TButton;
    IdFTP: TIdFTP;
    Btn_UpLoad: TButton;
    Btn_DownLoad: TButton;
    OpenDialog: TOpenDialog;
    ListViewLog: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure Btn_TestLinkClick(Sender: TObject);
    procedure Btn_SaveClick(Sender: TObject);
    procedure Btn_DownLoadClick(Sender: TObject);
    procedure Btn_UpLoadClick(Sender: TObject);
  private
    procedure SaveLoadLog;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFtpLoad: TFormFtpLoad;

implementation

uses UnitDllPublic;

{$R *.dfm}

procedure TFormFtpLoad.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormFtpLoad.FormShow(Sender: TObject);
begin
//
end;

procedure TFormFtpLoad.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FDllCloseRecall(FormFtpLoad);
end;

procedure TFormFtpLoad.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormFtpLoad.Btn_TestLinkClick(Sender: TObject);
var FFileList: TStrings;
begin
  if ((Trim(Edt_FTPAddr.Text)='')or(Trim(Edt_FTPUser.Text)='')or(Trim(Edt_FTPPass.Text)='')or(Trim(Edt_FTPPort.Text)='')) then begin
    Application.MessageBox('Ftp��Ϣ����Ϊ�գ�����д�����ԣ�','',MB_OK+64);
    Exit;
  end;
  FFileList:= TStringList.Create;
  IdFTP.Host:= Edt_FTPAddr.Text;
  IdFTP.Username:= Edt_FTPUser.Text;
  IdFTP.Password:= Edt_FTPPass.Text;
//  IdFTP.Port:= StrToInt(Edt_FTPPort.Text);
  try
    IdFTP.Connect();
    if IdFTP.Connected then
      Application.MessageBox('���ӳɹ���','��ʾ',MB_OK);
//    ListBoxLog.Items.Text := IdFTP.RetrieveCurrentDir;//�õ���ʼĿ¼
    IdFTP.ChangeDir('cna');    //���뵽client��Ŀ¼
    //IdFTP.ChangeDir('..'); //�ص���һ��Ŀ¼
    IdFTP.List(FFileList); //�õ�clientĿ¼�������ļ��б�
    IdFTP.List(FFileList,'*-��Ծ�û��굥',False);
//    ListBoxLog.Items:= FFileList;
//    Memo.Lines.Assign(FFileList);
    FFileList.Free;
  except
    Application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK);
  end;
end;

procedure TFormFtpLoad.Btn_SaveClick(Sender: TObject);
begin
//
end;

procedure TFormFtpLoad.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormFtpLoad.Btn_DownLoadClick(Sender: TObject);
var
  FDirectoryList :TIdFTPListItems;
  FFileInfo : TIdFTPListItem;
  i : integer;
  FFileName : String;
  TmpItem:TListItem;
begin  //����
//  Label1.Caption := IdFTP1.DirectoryListing.Items[0].FileName;
//  ListBoxLog.Items.Text:= IdFTP.DirectoryListing.Items[0].FileName;
  IdFTP.TransferType:= ftBinary; //ָ��Ϊ�������ļ�  ���ı��ļ�ftASCII
  for i:=0 to IdFTP.DirectoryListing.Count-1 do
  begin
    FDirectoryList := IdFTP.DirectoryListing; //�õ���ǰĿ¼���ļ���Ŀ¼�б�
    FFileInfo := FDirectoryList.Items[i]; //�õ�һ���ļ������Ϣ
//    ListBoxLog.Items.Text:= FFileInfo.Text;  //ȡ��һ���ļ���Ϣ����
    FFileName := FFileInfo.FileName;
    showmessage(FFileInfo.OwnerName+'  '+FFileInfo.GroupName+'  '+FFileInfo.FileName+'   '+FFileInfo.LinkedItemName);
    if IdFTP.DirectoryListing.Items[i].ItemType = ditFile then //������ļ�
    begin
      IdFTP.Get(FFileName,'d:\FTPtest\'+FFileName,True,True);//���ص����أ���Ϊ���ǣ���֧�ֶϵ�����
      TmpItem:= ListViewLog.Items.Add;
      TmpItem.Caption:= FFileName;
      TmpItem.SubItems.Add('�±�');
      TmpItem.SubItems.Add(DateTimeToStr(Now));
    end;
  end;
  SaveLoadLog;
end;

procedure TFormFtpLoad.Btn_UpLoadClick(Sender: TObject);
var FUpLoadFileName: string;
begin
  if OpenDialog.Execute then
  begin
    FUpLoadFileName:= OpenDialog.FileName;
    IdFTP.Put(FUpLoadFileName,'2000.jpg');
  end;
end;

procedure TFormFtpLoad.SaveLoadLog;
const
  FmtLog='%s'+#9+'%s'+#9+'%s';
var
//  Dlg:TSaveDialog;
  str:string;
  i:Integer;
  filevar: textfile;
  TmpItem:TListItem;
begin
//  Dlg:=TSaveDialog.Create(Self);
//  try
//    Dlg.Filter := 'Log info(*.txt)|*.txt';
//    Dlg.DefaultExt :='txt';
//    if not Dlg.Execute then begin
//      exit;
//    end;
//    str:=Dlg.FileName;
//  finally
//    Dlg.Free;
//  end;
  str:= ExtractFilePath(Application.ExeName)+'������-'+ DateTimeToStr(Now);
  assignfile(filevar,str);
  if FileExists(Str) then begin
    Append(filevar);
    write(filevar);
  end
  else
    Rewrite(filevar);
  for i:=0 to ListViewLog.Items.Count -1 do begin
    TmpItem:=ListViewLog.Items[i];
    str:=Format(FmtLog,[TmpItem.Caption,TmpItem.SubItems[0],TmpItem.SubItems[1]]);
    writeln(filevar,str);
  end;
  closefile(filevar);
end;

end.
