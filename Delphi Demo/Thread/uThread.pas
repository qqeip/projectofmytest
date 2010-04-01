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
  //此句标识在线程处理完毕后自动释放内存。
  FreeOnTerminate := True;

  SearchFile('D:\');
  frmMain.ListBox1.Items.Insert(0,'文件总数:'+IntToStr(FileCount));
  Synchronize(outTimeLength);
end;

//求时耗时
procedure TMyThread.outTimeLength;
begin
  frmMain.ListBox1.Items.Insert(0,'耗时'+ IntToStr(GetTickCount-TimeLength)+';约为:'+FloatToStr((GetTickCount-TimeLength)/1000)+'秒;');
end;



procedure TMyThread.SearchFile(DirName:String);
{-------------------------------------------------------------------------------
  过程名:    TMyThread.SearchFile
  作者:      developer
  日期:      2009.09.02
  参数:      DirName:String[目录名]
  返回值:    无
  说明:      采用递归的方式求文件总数      
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
    //处理中断
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
