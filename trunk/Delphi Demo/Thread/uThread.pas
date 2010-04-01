unit uThread;

interface

uses
  Classes,Dialogs,SysUtils,Windows;

type
  TMyThread = class(TThread)
  private
    FAnswer: Integer;
    FList:TStrings;
    FileCount:LongInt;
    TimeLength:LongInt;
    
    procedure searchFile(DirName:String);
    procedure outTimeLength;
    { Private declarations }
  protected
    procedure Execute; override;
  public
    property Answer:Integer Read FAnswer Write FAnswer;
  end;

implementation

uses
  MainForm;

{ TMyThread }

procedure TMyThread.Execute;
var
  i:Integer;
  stcLength:LongInt;
begin
  TimeLength := getTickCount;
  //�˾��ʶ���̴߳�����Ϻ��Զ��ͷ��ڴ档
  FreeOnTerminate := True;

  SearchFile('D:\');
  frmMain.ListBox1.Items.Insert(0,'�ļ�����:'+IntToStr(FileCount));
  Synchronize(outTimeLength);
end;

//��ʱ��ʱ
procedure TMyThread.outTimeLength;
begin
  frmMain.ListBox1.Items.Insert(0,'��ʱ'+ IntToStr(GetTickCount-TimeLength)+';ԼΪ:'+FloatToStr((GetTickCount-TimeLength)/1000)+'��;');
end;



procedure TMyThread.SearchFile(DirName:String);
{-------------------------------------------------------------------------------
  ������:    TMyThread.SearchFile
  ����:      developer
  ����:      2009.09.02
  ����:      DirName:String[Ŀ¼��]
  ����ֵ:    ��
  ˵��:      ���õݹ�ķ�ʽ���ļ�����      
-------------------------------------------------------------------------------}
var
  AExtractName: string;
  Found: Integer;
  MyFileName: string;
  rec: TSearchRec;
begin
  if DirName[Length(DirName)] <> '\' then
    DirName := DirName + '\';
  Found := FindFirst(DirName + '*.*', faAnyFile, Rec);
  while Found = 0 do begin
    //�����ж�
    if Terminated then Break;
    if ((rec.Attr and faDirectory) <> 0) then begin
      if (rec.Name <> '.') and (rec.Name <> '..') then
        SearchFile(DirName + rec.Name);
    end else begin
      MyFileName := dirName + rec.Name;
      FileCount := FileCount + 1;
      frmMain.ListBox1.Items.Insert(0,MyFileName+';'+IntToStr(FileCount));
    end;
    Found := FindNext(rec);
  end;
  SysUtils.FindClose(rec);
end;
end.
