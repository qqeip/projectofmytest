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
    Application.MessageBox('Ftp信息不能为空，请填写后再试！','',MB_OK+64);
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
      Application.MessageBox('连接成功！','提示',MB_OK);
//    ListBoxLog.Items.Text := IdFTP.RetrieveCurrentDir;//得到初始目录
    IdFTP.ChangeDir('cna');    //进入到client子目录
    //IdFTP.ChangeDir('..'); //回到上一级目录
    IdFTP.List(FFileList); //得到client目录下所有文件列表
    IdFTP.List(FFileList,'*-活跃用户详单',False);
//    ListBoxLog.Items:= FFileList;
//    Memo.Lines.Assign(FFileList);
    FFileList.Free;
  except
    Application.MessageBox('连接失败！','提示',MB_OK);
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
begin  //下载
//  Label1.Caption := IdFTP1.DirectoryListing.Items[0].FileName;
//  ListBoxLog.Items.Text:= IdFTP.DirectoryListing.Items[0].FileName;
  IdFTP.TransferType:= ftBinary; //指定为二进制文件  或文本文件ftASCII
  for i:=0 to IdFTP.DirectoryListing.Count-1 do
  begin
    FDirectoryList := IdFTP.DirectoryListing; //得到当前目录下文件及目录列表
    FFileInfo := FDirectoryList.Items[i]; //得到一个文件相关信息
//    ListBoxLog.Items.Text:= FFileInfo.Text;  //取出一个文件信息内容
    FFileName := FFileInfo.FileName;
    showmessage(FFileInfo.OwnerName+'  '+FFileInfo.GroupName+'  '+FFileInfo.FileName+'   '+FFileInfo.LinkedItemName);
    if IdFTP.DirectoryListing.Items[i].ItemType = ditFile then //如果是文件
    begin
      IdFTP.Get(FFileName,'d:\FTPtest\'+FFileName,True,True);//下载到本地，并为覆盖，且支持断点续传
      TmpItem:= ListViewLog.Items.Add;
      TmpItem.Caption:= FFileName;
      TmpItem.SubItems.Add('月报');
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
  str:= ExtractFilePath(Application.ExeName)+'任务定制-'+ DateTimeToStr(Now);
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
