{*******************************************************}
{* 名称：            文本日志管理模块                  *}
{* 功能描述：文本日志模块负责日志文件的读写和自我管理。*}
{*           能够以按天的方式（一天一个日志文件）自动管*}
{*           理文件,根据设置自动删除多少天以前折日志文 *}
{*           件,自动控制日志文件的最大行数。           *}
{* 作者：                  hlwu                        *}
{* 版本：                  1.0                         *}
{* 公司名称：            widetech                      *}
{* 修改时间:             2005-6-28                     *}
{* 修改人:                Wuyj                         *}
{* 修改内容:             增加临界区                    *}
{*******************************************************}

unit Log;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,SyncObjs,StdCtrls;

type

  TLog = class(Tobject)
  public
    MesStrList : TStringList;  // 消息载体
    {日志文件临界区，新增
    在create时初始化
    ---------------------------------------------------------------------}
    logCS : TCriticalSection;
    constructor create;
    procedure SetFileMgrType(filetype:integer);//设置文件管理方式
    procedure SetSaveDayNum(daynum:integer);   //设置文件保存天数
    procedure SetMaxLines(linenum : integer);  //设置文件最大行数
    procedure Write(info:string;level:integer);//将信息写入日志文件
    procedure SetPath(Path:string);            //设置文件保存路径
    destructor destroy;override;
  private
    SaveDayNum : integer;//保存天数
    MaxLines : integer;  //日志文件最大行数
    LogFile : TextFile;  //关联文件日志
    LogPath : string;    //存放文件路径
    LogTime : string;    //存放记录日志的当前时间
    AppLogName : string; //日志进程名
    LogType : integer;   //文件类型
    NowUsed : string;    //目前正使用的日志文件名
    {--------------------------------------------------------------------
    //--------------------------------------------------------------------}
    procedure OpenLog(FileType : integer;Path : string);//打开或创建新文件
  end;
  
implementation

{ TLog }

constructor TLog.create;
var
  AName:string;
begin
  logCS := TCriticalSection.Create;
  MesStrList := TStringList.Create;
  AName := ExtractFileName(Application.ExeName);//取得当前进程的进程名(含.exe)
  Delete(AName,Pos('.exe',AName),4);            //去掉进程名的'.exe'
  AppLogName := AName;
  LogPath := ExtractFilePath(paramstr(0))+'\Log';
  if not DirectoryExists(LogPath) then
     mkDir(LogPath);                            //默认为当前程序所存放的路径
  SetMaxLines(1000);                            //默认最大行数为1000
  SetSaveDayNum(30);                            //默认保存天数为30
  SetFileMgrType(1);                            //默认保存类型为一天一日志形式
  OpenLog(LogType,LogPath);
end;

procedure TLog.OpenLog(FileType: integer; Path: string);
var
  FileName: string;
begin
  if LogType = 1 then   //判断是否为一天一日志形式
  begin
    FileName := LogPath+'\'+AppLogName+FormatDateTime('yyyy-m-d',Date)+'.log';
    //文件名为'路径+进程名+当前日期+.Log',当前日期字符串为'年-月-日'形式
    try
      if FileExists(FileName) then //存在该日日志文件则以追加形式打开
      begin
        Assign(LogFile,FileName);
        Append(LogFile);
        NowUsed := FileName;       //设置当前使用日志文件标志
      end
      else begin                   //不存在则创建一个新文件
        Assign(LogFile,FileName);
        Rewrite(LogFile);
        NowUsed := FileName;
      end;
    except
    end;
  end;
end;

procedure TLog.SetMaxLines(linenum: integer);//保留
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
    if FileExists(OldFileName) then   //删除保存日期以前的文件
    begin
      Assign(OldFile,OldFileName);
      Erase(OldFile);
    end;

    LogTime := FormatDateTime('hh:nn:ss',time);//将时间转化为'时:分:秒'形式的字符串
    if LogType=1 then             //判断是否为一天一日志形式
    begin
      FileName2 := LogPath+'\'+AppLogName+FormatDateTime('yyyy-m-d',Date)+'.log';
      if FileName2<>NowUsed then  //判断当前使用的是否为当前日期的日志文件
      begin
        try
          CloseFile(LogFile);     //关闭原文件
          Assign(LogFile,FileName2);
          Rewrite(LogFile);       //创建当前日期的日志文件
          NowUsed := FileName2;   //重新设置当前的使用日志
        except
        end;
      end;
    end;
    case level of    //判断信息类型
      1:    //错误信息
        begin
        try
          writeln(LogFile,Format('%-12s',[LogTime]),format('%-12s',['[Error]']),':  ',info);
                           //以 '时间  信息类型 :  信息' 形式存入日志
          Flush(LogFile);  //刷新日志文件
          if MesStrList.Count > 1002 then
            begin
              MesStrList.Delete(0);
            end;
          MesStrList.Add(Format('%-12s',[LogTime])+format('%-12s',['[Error]'])+':  '+info);
        except
        end;
        end;
      2:    //告警信息
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
      3:    //一般信息
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
    else   //其它
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

procedure TLog.SetFileMgrType(filetype: integer); //保留
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
