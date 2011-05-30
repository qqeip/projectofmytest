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
    ListBoxLog: TListBox;
    Btn_UpLoad: TButton;
    Btn_DownLoad: TButton;
    OpenDialog: TOpenDialog;
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
    ListBoxLog.Items.Text := IdFTP.RetrieveCurrentDir;//�õ���ʼĿ¼
    IdFTP.ChangeDir('cna');    //���뵽client��Ŀ¼
    //IdFTP.ChangeDir('..'); //�ص���һ��Ŀ¼
    IdFTP.List(FFileList); //�õ�clientĿ¼�������ļ��б�
    ListBoxLog.Items:= FFileList;
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
begin  //����
//  Label1.Caption := IdFTP1.DirectoryListing.Items[0].FileName;
  ListBoxLog.Items.Text:= IdFTP.DirectoryListing.Items[0].FileName;
  IdFTP.TransferType:= ftBinary; //ָ��Ϊ�������ļ�  ���ı��ļ�ftASCII
  for i:=0 to IdFTP.DirectoryListing.Count-1 do
  begin
    FDirectoryList := IdFTP.DirectoryListing; //�õ���ǰĿ¼���ļ���Ŀ¼�б�
    FFileInfo := FDirectoryList.Items[i]; //�õ�һ���ļ������Ϣ
    ListBoxLog.Items.Text:= FFileInfo.Text;  //ȡ��һ���ļ���Ϣ����
    FFileName := FFileInfo.FileName;
    showmessage(FFileInfo.OwnerName+'  '+FFileInfo.GroupName+'  '+FFileInfo.FileName+'   '+FFileInfo.LinkedItemName);
    if IdFTP.DirectoryListing.Items[i].ItemType = ditFile then //������ļ�
    begin
      IdFTP.Get(FFileName,'d:\FTPtest\'+FFileName,True,True);//���ص����أ���Ϊ���ǣ���֧�ֶϵ�����
    end;
  end;
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

end.
