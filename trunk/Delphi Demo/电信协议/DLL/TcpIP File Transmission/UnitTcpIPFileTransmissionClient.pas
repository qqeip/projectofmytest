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

//CurFilePath:����·��
//SerFilePath:������·��
//CurFileName:�����ļ���
//SerFileName:�������ļ���
//ShowFlag:�Ƿ���ʾ����������
Function TFormTcpIPFileTransmissionClint.Act_DownFiles(CurFilePath,SerFilePath,CurFileName,SerFileName:String;ShowFlag:Boolean):Boolean;
var
  TemFileName,RecevFileName:String;
  rbyte:array[0..4096] of byte;
  sFile:TFileStream;
  iFileSize:integer;
begin
  Result:=False;
  IdTCPClientDowFiles.Host:= serverip;//�������ĵ�ַ
  IdTCPClientDowFiles.Port:= 991;

  if IdTCPClientDowFiles.Connected then
    IdTCPClientDowFiles.Disconnect;

  Try
    IdTCPClientDowFiles.Connect;
  except
    MessageBox(Handle,'������û�п���','��ʾ',MB_OK);
    Result:=False;
    Exit;
  end;

  with IdTCPClientDowFiles do
    begin
    while Connected do
    begin
      Try
        TemFileName:=SerFilePath+SerFileName;//������·��������
        WriteLn(TemFileName); //ָ��·��
        RecevFileName:=ReadLn;//�ӷ������˻���ļ���
        if RecevFileName <> '�ļ�������' then
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
//              Label1.Caption:='�������أ�'+SerFileName;
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
        Disconnect;//�Ͽ�����
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
  if SelectDirectory('��ѡ��Ŀ¼','',TempStr) then
    Edt_CurFilePath.Text:= TempStr;
end;

procedure TFormTcpIPFileTransmissionClint.btnBtn_SerFilePathClick(Sender: TObject);
var
  TempStr: string;
begin
  if SelectDirectory('��ѡ��Ŀ¼','',TempStr) then
    Edt_SerFilePath.Text:= TempStr;
end;

procedure TFormTcpIPFileTransmissionClint.btnBtn_CloseClick(
  Sender: TObject);
begin
  FDllCloseRecall(FormTcpIPFileTransmissionClint);
end;

end.
