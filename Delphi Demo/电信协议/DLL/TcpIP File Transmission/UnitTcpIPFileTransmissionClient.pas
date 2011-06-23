unit UnitTcpIPFileTransmissionClient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  StdCtrls, Buttons, FileCtrl, ComCtrls;

type
  TFormTcpIPFileTransmissionClint = class(TForm)
    Label_IP: TLabel;
    Label_Port: TLabel;
    Label1CurFilePath: TLabel;
    LabelSerFilePath: TLabel;
    Label_CurFileName: TLabel;
    btnBtn_CurFilePath: TSpeedButton;
    btnBtn_SerFilePath: TSpeedButton;
    Label_SerFileName: TLabel;
    BtnTransmission: TButton;
    Edt_IP: TEdit;
    Edt_Port: TEdit;
    Edt_CurFilePath: TEdit;
    Edt_SerFilePath: TEdit;
    Edt_CurFileName: TEdit;
    CheckBox_ShowFlag: TCheckBox;
    btnBtn_Close: TButton;
    Edt_SerFileName: TEdit;
    IdTCPClientDowFiles: TIdTCPClient;
    Label1: TLabel;
    pb1: TProgressBar;
    procedure BtnTransmissionClick(Sender: TObject);
    procedure btnBtn_CurFilePathClick(Sender: TObject);
    procedure btnBtn_SerFilePathClick(Sender: TObject);
    procedure btnBtn_CloseClick(Sender: TObject);
  private
    Serverip: string;
    function Act_DownFiles(CurFilePath, SerFilePath, CurFileName,
      SerFileName: String; ShowFlag: Boolean): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTcpIPFileTransmissionClint: TFormTcpIPFileTransmissionClint;

implementation

uses UnitProgress, UnitDllPublic;

{$R *.dfm}

//CurFilePath:本地路径
//SerFilePath:服务器路径
//CurFileName:本地文件名
//SerFileName:服务器文件名
//ShowFlag:是否显示进度条窗口
Function TFormTcpIPFileTransmissionClint.Act_DownFiles(CurFilePath,SerFilePath,CurFileName,SerFileName:String;ShowFlag:Boolean):Boolean;
var
  TemFileName,RecevFileName:String;
  rbyte:array[0..4096] of byte;
  sFile:TFileStream;
  iFileSize:integer;
begin
  Result:=False;
  IdTCPClientDowFiles.Host:= serverip;//服务器的地址
  IdTCPClientDowFiles.Port:= 991;

  if IdTCPClientDowFiles.Connected then
    IdTCPClientDowFiles.Disconnect;

  Try
    IdTCPClientDowFiles.Connect;
  except
    MessageBox(Handle,'服务器没有开启','提示',MB_OK);
    Result:=False;
    Exit;
  end;

  with IdTCPClientDowFiles do
    begin
    while Connected do
    begin
      Try
        TemFileName:=SerFilePath+SerFileName;//服务器路径加名称
        WriteLn(TemFileName); //指定路径
        RecevFileName:=ReadLn;//从服务器端获得文件名
        if RecevFileName <> '文件不存在' then
        begin
          iFileSize:=IdTCPClientDowFiles.ReadInteger;
          sFile:=TFileStream.Create(CurFilePath+CurFileName,fmCreate);

          if ShowFlag then
          begin
            PB1.Position:=0;
            PB1.Max := iFileSize div 100 ;
          end;

          While iFileSize > 4096 do
          begin
            IdTCPClientDowFiles.ReadBuffer(rbyte,4096);// .ReadBuffer(rbyte,iLen);
            sFile.Write(rByte,4096);
            inc(iFileSize,-4096);

            Application.ProcessMessages;
            if ShowFlag then
            begin
//              Label1.Caption:='正在下载：'+SerFileName;
              PB1.Position:= PB1.Position +(4096 div 100) ;
            end;
          end;  

          if iFileSize > 0 then
            IdTCPClientDowFiles.ReadBuffer(rbyte,iFileSize);// .ReadBuffer(rbyte,iLen);
          Application.ProcessMessages;
          sFile.Write(rByte,iFileSize);
          if ShowFlag then
          begin
            FrmProgress.Close;
          end;
          sFile.Free;
        end;
      finally
        Disconnect;//断开连接
      end;
    end;
  end;
  Result:=True;
end;

procedure TFormTcpIPFileTransmissionClint.BtnTransmissionClick(Sender: TObject);
var
  FCurFilePath, FSerFilePath, FCurFileName, FSerFileName: string;
  FShowFlag: Boolean;
begin
  Serverip:= Edt_IP.Text;
  FCurFilePath:= Edt_CurFilePath.Text;
  FSerFilePath:= Edt_SerFilePath.Text;
  FCurFileName:= Edt_CurFileName.Text;
  FSerFileName:= Edt_SerFileName.Text;
  FShowFlag:= CheckBox_ShowFlag.Checked;
  Act_DownFiles(FCurFilePath, FSerFilePath, FCurFileName, FSerFileName, FShowFlag);
end;

procedure TFormTcpIPFileTransmissionClint.btnBtn_CurFilePathClick(Sender: TObject);
var
  TempStr: string;
begin
  if SelectDirectory('请选择目录','',TempStr) then
    Edt_CurFilePath.Text:= TempStr;
end;

procedure TFormTcpIPFileTransmissionClint.btnBtn_SerFilePathClick(Sender: TObject);
var
  TempStr: string;
begin
  if SelectDirectory('请选择目录','',TempStr) then
    Edt_SerFilePath.Text:= TempStr;
end;

procedure TFormTcpIPFileTransmissionClint.btnBtn_CloseClick(
  Sender: TObject);
begin
  FDllCloseRecall(FormTcpIPFileTransmissionClint);
end;

end.
