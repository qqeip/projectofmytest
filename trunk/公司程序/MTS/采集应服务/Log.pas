{*******************************************************}
{* ���ƣ�            �ı���־����ģ��                  *}
{* �����������ı���־ģ�鸺����־�ļ��Ķ�д�����ҹ���*}
{*           �ܹ��԰���ķ�ʽ��һ��һ����־�ļ����Զ���*}
{*           ���ļ�,���������Զ�ɾ����������ǰ����־�� *}
{*           ��,�Զ�������־�ļ������������           *}
{* ���ߣ�                  hlwu                        *}
{* �汾��                  1.0                         *}
{* ��˾���ƣ�            widetech                      *}
{* �޸�ʱ��:             2005-6-28                     *}
{* �޸���:                Wuyj                         *}
{* �޸�����:             �����ٽ���                    *}
{*******************************************************}

unit Log;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,SyncObjs,StdCtrls;

type

  TLog = class(Tobject)
  public
    MesStrList : TStringList;  // ��Ϣ����
    {��־�ļ��ٽ���������
    ��createʱ��ʼ��
    ---------------------------------------------------------------------}
    logCS : TCriticalSection;
    constructor create;
    procedure SetFileMgrType(filetype:integer);//�����ļ�����ʽ
    procedure SetSaveDayNum(daynum:integer);   //�����ļ���������
    procedure SetMaxLines(linenum : integer);  //�����ļ��������
    procedure Write(info:string;level:integer);//����Ϣд����־�ļ�
    procedure SetPath(Path:string);            //�����ļ�����·��
    destructor destroy;override;
  private
    SaveDayNum : integer;//��������
    MaxLines : integer;  //��־�ļ��������
    LogFile : TextFile;  //�����ļ���־
    LogPath : string;    //����ļ�·��
    LogTime : string;    //��ż�¼��־�ĵ�ǰʱ��
    AppLogName : string; //��־������
    LogType : integer;   //�ļ�����
    NowUsed : string;    //Ŀǰ��ʹ�õ���־�ļ���
    {--------------------------------------------------------------------
    //--------------------------------------------------------------------}
    procedure OpenLog(FileType : integer;Path : string);//�򿪻򴴽����ļ�
  end;
  
implementation

{ TLog }

constructor TLog.create;
var
  AName:string;
begin
  logCS := TCriticalSection.Create;
  MesStrList := TStringList.Create;
  AName := ExtractFileName(Application.ExeName);//ȡ�õ�ǰ���̵Ľ�����(��.exe)
  Delete(AName,Pos('.exe',AName),4);            //ȥ����������'.exe'
  AppLogName := AName;
  LogPath := ExtractFilePath(paramstr(0))+'\Log';
  if not DirectoryExists(LogPath) then
     mkDir(LogPath);                            //Ĭ��Ϊ��ǰ��������ŵ�·��
  SetMaxLines(1000);                            //Ĭ���������Ϊ1000
  SetSaveDayNum(30);                            //Ĭ�ϱ�������Ϊ30
  SetFileMgrType(1);                            //Ĭ�ϱ�������Ϊһ��һ��־��ʽ
  OpenLog(LogType,LogPath);
end;

procedure TLog.OpenLog(FileType: integer; Path: string);
var
  FileName: string;
begin
  if LogType = 1 then   //�ж��Ƿ�Ϊһ��һ��־��ʽ
  begin
    FileName := LogPath+'\'+AppLogName+FormatDateTime('yyyy-m-d',Date)+'.log';
    //�ļ���Ϊ'·��+������+��ǰ����+.Log',��ǰ�����ַ���Ϊ'��-��-��'��ʽ
    try
      if FileExists(FileName) then //���ڸ�����־�ļ�����׷����ʽ��
      begin
        Assign(LogFile,FileName);
        Append(LogFile);
        NowUsed := FileName;       //���õ�ǰʹ����־�ļ���־
      end
      else begin                   //�������򴴽�һ�����ļ�
        Assign(LogFile,FileName);
        Rewrite(LogFile);
        NowUsed := FileName;
      end;
    except
    end;
  end;
end;

procedure TLog.SetMaxLines(linenum: integer);//����
begin
  MaxLines := linenum;
end;

procedure TLog.SetSaveDayNum(daynum: integer);
begin
  SaveDayNum := daynum;
end;

procedure TLog.Write(info: string; level: integer);
var
  FileName2 : string;
  OldFileName : string;
  OldFile : textFile;
begin
  LogCs.Enter;
  try
    OldFileName:=LogPath+'\'+ApplogName+FormatDateTime('yyyy-m-d',Date-SaveDayNum)+'.log';
    if FileExists(OldFileName) then   //ɾ������������ǰ���ļ�
    begin
      Assign(OldFile,OldFileName);
      Erase(OldFile);
    end;

    LogTime := FormatDateTime('hh:nn:ss',time);//��ʱ��ת��Ϊ'ʱ:��:��'��ʽ���ַ���
    if LogType=1 then             //�ж��Ƿ�Ϊһ��һ��־��ʽ
    begin
      FileName2 := LogPath+'\'+AppLogName+FormatDateTime('yyyy-m-d',Date)+'.log';
      if FileName2<>NowUsed then  //�жϵ�ǰʹ�õ��Ƿ�Ϊ��ǰ���ڵ���־�ļ�
      begin
        try
          CloseFile(LogFile);     //�ر�ԭ�ļ�
          Assign(LogFile,FileName2);
          Rewrite(LogFile);       //������ǰ���ڵ���־�ļ�
          NowUsed := FileName2;   //�������õ�ǰ��ʹ����־
        except
        end;
      end;
    end;
    case level of    //�ж���Ϣ����
      1:    //������Ϣ
        begin
        try
          writeln(LogFile,Format('%-12s',[LogTime]),format('%-12s',['[Error]']),':  ',info);
                           //�� 'ʱ��  ��Ϣ���� :  ��Ϣ' ��ʽ������־
          Flush(LogFile);  //ˢ����־�ļ�
          if MesStrList.Count > 1002 then
            begin
              MesStrList.Delete(0);
            end;
          MesStrList.Add(Format('%-12s',[LogTime])+format('%-12s',['[Error]'])+':  '+info);
        except
        end;
        end;
      2:    //�澯��Ϣ
        begin
        try
          writeln(LogFile,Format('%-12s',[LogTime]),format('%-12s',['[Warning]']),':  ',info);
          Flush(LogFile);
          if MesStrList.Count > 1002 then
            begin
              MesStrList.Delete(0);
            end;
          MesStrList.Add(Format('%-12s',[LogTime])+format('%-12s',['[Warning]'])+':  '+info);
        except
        end;
        end;
      3:    //һ����Ϣ
        begin
        try
          writeln(LogFile,Format('%-12s',[LogTime]),format('%-12s',['[Info]']),':  ',info);
          Flush(LogFile);
          if MesStrList.Count > 1002 then
            begin
              MesStrList.Delete(0);
            end;
          MesStrList.Add(Format('%-12s',[LogTime])+format('%-12s',['[Info]'])+':  '+info);
        except
        end;
        end;
    else   //����
      begin
        try
          writeln(LogFile,Format('%-12s',[LogTime]),format('%-12s',['[Other]']),':  ',info);
          Flush(LogFile);
          if MesStrList.Count > 1002 then
            begin
              MesStrList.Delete(0);
            end;
          MesStrList.Add(Format('%-12s',[LogTime])+format('%-12s',['[Other]'])+':  '+info);
        except
        end;
      end;
    end;
  Finally
    Logcs.Leave;
  end;
end;

procedure TLog.SetFileMgrType(filetype: integer); //����
begin
  LogType := filetype;
end;

procedure TLog.SetPath(Path: string);
begin
  LogPath := Path;
end;

destructor TLog.destroy;
begin
  try
    LogCS.Free;
    MesStrList.Free;
    Flush(LogFile);
    CloseFile(LogFile);
  except
  end;
  inherited;
end;


end.
