unit gunFunSys;

interface
uses Forms,sysutils,classes,stdctrls,comctrls,
	  windows,Registry,Variants,Messages,Inifiles,adodb;
const
    gcstrRegKey='SoftWare\DBServer\';
type
  TDateDiff=record
    days,hours,minutes,seconds,mseconds:integer;
  end;
  TDTInfo=Record
    strLinkinfoFile        :string;
    strUploadInfoFile      :string;
    strDownLoadInfoFile    :string;
    strUnKownErrInfoFile   :string;
    strFilePressInfoFile    :string;
    strMemoMaxLine         :string;
    strFileMaxSize         :string;
    strMemoMaxLineProcMode :string;
  end;
  //#####################################组件操作函数#####################################
  procedure WriteToMemo(memTar:TMemo;astrLine:string);
  procedure SetStatusBar(stabTemp: TStatusBar; intPanel: integer; strText: string);
  procedure ClearAllEditTxt(frmParent:Tform);
  procedure ShowMeCenter(frmForm:TForm);
  //#####################################字符处理函数#####################################
  //得到字符串中用分隔符分开的字符串
  function gParseString(strStringToParse:string;var strlItems:Tstringlist;strDelimiter: string=' '):wordbool;
  //由replacestr替换Destinstr中的SearStr,若不存在,返回destinstr
  function gReplaceStr(strDestin,strSear,strReplace:string):string;
  {取得以指定分割符strSign分割的串strT中第intCount个分割符与第intCount-1个分割符
  之间的字符串}
  function gGetSubStr(strT,strSign:string;intCount:integer):string;
  function gIsValidInteger(strS:string):boolean;
  //#####################################时间处理函数#####################################
  function NowTime:string;
                        //被减数              //减数
  function  GetDateDiff(const astrdtmMinuend,astrdtmSubtrahend:string;var atdResult:TDateDiff):boolean;
  function GetRegStr(SubKey:string;ValueKey:string; var ResultValue:string;
          CreateBool:wordbool):wordbool;
  function IsExistKey(ValueKey:string):wordbool;
  function IsExistValue(Value:string):wordbool;
  function WriteToIniFile(astrIniFileName, astrSect,astrField: string;
                           astrValue:string): boolean;
  function  SetRegStr(SubKey:string;ValueKey:string; Value:string):wordbool;
  function WriteDataToFile(astrFileName, astrData: string): boolean;
  
  function  DelRegStr(SubKey:string;ValueKey:string):wordbool;
  procedure SaveTransInfoToFile(aintMemoIdx:integer;astrData:string);
  function GetMemoLineCount(memHandle:HWnd): integer; 
  procedure SetFilePara;
  function moveFileName(const sourceFileName,destFileName:String):boolean;
  /////////////////////////////////
  //#####################################程序控制函数#####################################

  procedure SetRegDbInfo(StrDBName,StrUserName,StrPWd: string);
  procedure GetRegDbInfo(var StrDBName, StrUserName,StrPWd: string);
  procedure ReadIniFile(Var Ip,port,UserName,Password,FilePath,FileName,Version,ZwFileName,zwVersion:String);
  procedure GetRegConnstr(var ConnStr:string);
  procedure SetRegDbConnstr(ConnStr:String);
  function ExecSQL(ConnectionString,CmdSQL:String):boolean;
  procedure ReadCongifgFile(Var UnitFtpPath,BankFtpPath,Ip,port,UserName,Password,
          Filepath,FileName,Version,ZwFileName,ZwVersion,
          UnitCreateDate,BankCreateDate,BankLoadDate,StrBoolAuto:String);
  procedure WriteCongifgFile(const UnitFtpPath,BankFtpPath,Ip,port,UserName,Password,
          Filepath,FileName,Version,ZwFileName,ZwVersion,
          UnitCreateDate,BankCreateDate,BankLoadDate,StrBoolAuto:String);
  procedure ProcessWindowsMessage;
var
  gdtInfo:TDTInfo;
  gstrAppPath:string;
  GStrUnitPath:String;
  gStrBankPath:String;
  gStrUnitCreateDate:String;
  gstrBankCreateDate:String;
  gstrBankLoadDate:String;
implementation

procedure ProcessWindowsMessage;
{$IFDEF LINUX}
begin
   Application.ProcessMessages;
end;
{$ELSE}
var
   MsgRec:TMsg;

begin
   if not IsConsole then
      while PeekMessage(MsgRec,0,0,0,PM_REMOVE) do begin
         TranslateMessage(MsgRec);
         DispatchMessage(MsgRec)
      end;
end;
{$ENDIF}
procedure SetRegDbConnstr(ConnStr:String);
var
  strKey:string;
begin
  strKey:=gcstrRegKey+'DataBase';
  try
    SetRegStr(strKey,'Connstr',ConnStr);
  except
  end;
end;
procedure GetRegConnstr(var ConnStr:string);
var
  strKey:string;
begin
  strKey:=gcstrRegKey+'DataBase';
  try
    GetRegStr(strKey, 'Connstr', ConnStr,False);
  except
  end;
end;

procedure SetRegDbInfo(StrDBName,StrUserName,
  StrPWd: string);
var
  strKey:string;
begin
  strKey:=gcstrRegKey+'DataBase';
  try
    SetRegStr(strKey,'NetServiceName',StrDBName);
    SetRegStr(strKey,'UserId',StrUserName);
    SetRegStr(strKey,'PassWord',StrPWd);
  except
  end;
end;

procedure GetRegDbInfo(var StrDBName, StrUserName,
  StrPWd: string);
var
  strKey:string;
begin
  StrDBName:='';
  StrUserName:='';
  StrPWd:='';
  strKey:=gcstrRegKey+'DataBase';
  try
    GetRegStr(strKey, 'NetServiceName', StrDBName,False);
    GetRegStr(strKey, 'UserId', StrUserName,False);
    GetRegStr(strKey, 'PassWord', StrPWd,False);
  except
  end;
end;
procedure WriteToMemo(memTar: TMemo; astrLine: string);
begin
   try
     if memTar<>nil then
     memTar.Lines.Add(astrLine+'（'+NowTime+'）');
   except
     exit;
   end;
end;

procedure SetStatusBar(stabTemp: TStatusBar; intPanel: integer;
  strText: string);
begin
  while intPanel >= stabTemp.Panels.Count  do
    stabTemp.Panels.Add;
  stabTemp.Panels.Items[intPanel].Text:=strText;
end;

function gParseString(strStringToParse:string;var strlItems:Tstringlist;strDelimiter: string=' '):wordbool;
var
  IntNextPos:Integer;
  strTemp:String;
  intDelimiterLen:integer;
begin
  result:=true;
  intDelimiterLen:=length(strDelimiter);
  repeat
    IntNextPos:=Pos(strDelimiter,strStringToParse);
    if IntNextPos=0 then begin
      StrTemp:=copy(strStringToParse,1,length(strStringToParse));
    end
    else
    begin
      StrTemp:=copy(strStringToParse,1,IntNextPos-1);
    end;
    StrlItems.Add(StrTemp);
    delete(strStringToParse,1,IntNextPos+intDelimiterLen-1);
  until IntNextPos = 0;
end;
function gReplaceStr(strDestin,strSear,strReplace:string):string;
var
  intI:integer;
  intSearLen:integer;
  intDesLen:integer;
  intTDesLen:integer;
  intPos:integer;
  strTmp:string;
begin
  strTmp:=strDestin;
  intDesLen:=length(strDestin);
  intSearLen:=length(strSear);
  for intI:=0 to intDesLen do
  begin
    intPos:=pos(strSear,strDestin);
    if intPos=0 then
    begin
      if intI=0 then
         Result:=strTmp
      else
        Result:=strTmp+strDestin;
      exit;
    end;
    if intI=0 then
      strTmp:='';
    intTDesLen:=length(strDestin);
    strTmp:=strTmp+Copy(strDestin,1,intPos-1)+strReplace;
    strDestin:=Copy(strDestin,intPos+intSearLen,intTDesLen-(intPos+intSearLen)+1);
    //I:=I+SearLen-1;
  end;
end;

function gGetSubStr(strT,strSign:string;intCount:integer):string;
var
  intI,intPos:integer;
  intSpltLen:integer;
begin
  intSpltLen:=length(strSign);
  for intI:=1 to intCount-1 do
    Delete(strT,1,Pos(strSign,strT)+intSpltLen-1);
  intPos:=Pos(strSign,strT);
  if intPos=0 then
    Result:=strT
  else
    Result:=Copy(strT,1,intPos-1);
end;

function NowTime:string;
begin
  result:=formatdatetime('yyyy-mm-dd hh:mm:ss',now);
end;

function  GetDateDiff(const astrdtmMinuend,astrdtmSubtrahend:string;var atdResult:TDateDiff):boolean;
var
  dtBegin,dtEnd:TDateTime;
  Diff:TDateTime;
  tdResult:TDateDiff;
begin
  try
    dtBegin:=StrToDateTime(astrdtmMinuend);
    dtEnd:= StrToDateTime(astrdtmSubtrahend);
    Diff:=dtBegin-dtEnd;
    tdResult.days:=trunc(Diff);
    Diff:=(Diff-tdResult.days)*24;
    tdResult.hours:=trunc(Diff);
    Diff:=(Diff-tdResult.hours)*60;
    tdResult.minutes:=trunc(Diff);
    Diff:=(Diff-tdResult.minutes)*60;
    tdResult.seconds:=trunc(Diff);
    Diff:=(Diff-tdResult.seconds)*1000;
    tdResult.mseconds:=trunc(Diff);
    atdResult:=tdResult;
    result:=true;
  except
    result:=false;
  end;
end;

//    读注册表信息，初始化登陆窗口
function GetRegStr(SubKey:string;ValueKey:string; var ResultValue:string;
CreateBool:wordbool):wordbool;
//SubKey         ：要操作的根键
//ValueKey       ：要操作的主键  如果为空则默认为读出SubKey根键的默认键值
//ResultValue    ：要读出的键值
//CreateBool     ：如果没有找z到相应的主键确认是否要创建。
var
  RegF:Tregistry; //定义变量RegF
begin
  Result:=False;
  SubKey:=trim(Subkey);
  ValueKey:=trim(ValueKey);
  RegF:=Tregistry.Create; //创建变量
  RegF.RootKey:=HKEY_LOCAL_MACHINE;// 指定要操作的根键
  try
    Result:=RegF.Openkey(SubKey,CreateBool);
    ResultValue:=RegF.ReadString(ValueKey);
    Result:=true;
  finally
    RegF.CloseKey ;
    RegF.Free;// 释放变量
  end;
end;

function IsExistKey(ValueKey:string):wordbool;
var
  RegF:Tregistry;
begin
  RegF:=Tregistry.Create; //创建变量
  RegF.RootKey:=HKEY_LOCAL_MACHINE;// 指定要操作的根键
  try
    Result:=RegF.keyexists(ValueKey);
  finally
    RegF.CloseKey ;
    RegF.Free;// 释放变量
  end;
end;

function IsExistValue(Value:string):wordbool;
var
  RegF:Tregistry;
begin
  RegF:=Tregistry.Create; //创建变量
  RegF.RootKey:=HKEY_LOCAL_MACHINE;// 指定要操作的根键
  try
    Result:=RegF.ValueExists(Value);
  finally
    RegF.CloseKey ;
    RegF.Free;// 释放变量
  end;
end;
function gIsValidInteger(strS:string):boolean;
begin
  try
    if (Length(strS)<>0) and not varisnull(strS) and (strS<>'')
      and (inttostr(strtoint(strS))<>'') then
      result:=true
    else
      result:=false;
  except
    result:=false;
  end;
end;
function WriteDataToFile(astrFileName, astrData: string): boolean;
var
  txtfileOutPut:Textfile;
  boolIsFileExist:boolean;
begin
  try
    result:=false;
    boolIsFileExist:=FileExists(astrFileName);
    assignFile(txtfileOutPut,astrFileName);
    if boolIsFileExist then
      Append(txtfileOutPut)
    else
      rewrite(txtfileOutPut);
    writeln(txtfileOutPut,astrData);
    if boolIsFileExist then Flush(txtfileOutPut);
    CloseFile(txtfileOutPut);
  except
    exit;
  end;
  result:=true;
end;

procedure SaveTransInfoToFile(aintMemoIdx:integer;astrData:string);
  //aintMemoIdx: 0:连接信息,memConn;1:上传信息，memUp;2：下载信息，memDown
var
  hFile:Cardinal;
  dwSize:Cardinal;
  boolOverMaxFileSize:boolean;
  strFileName:string;
  strSection:string;
  strIniFileName:string;
  strKey:string;
  boolToChangeFile:boolean;
  strFileEx:string;
  function GetFileSize(const FileName: string):Longint;
  var f : TFileStream;
  begin
    f := TFileStream.Create(FileName,fmOpenRead or fmShareDenyNone);
    Result :=f.Size;
    F.Free;
  end;
  function GetNextFileName(astrFileName:string):string;
  var
    intIdx:integer;
    intStrLen:integer;
    strNumber:string;
  begin
    result:=astrFileName;
    intStrLen:=length(astrFileName);
    for intIdx:=intStrLen downto 1 do
      if not (astrFileName[intIdx] in ['0','1','2','3','4','5','6','7','8','9']) then break;

    strNumber:=copy(astrFileName,intIdx+1,intStrLen-intIdx);
    if strNumber='' then strNumber:='-1';
    result:=copy(astrFileName,1,intIdx)+inttostr(strToint(strNumber)+1);
  end;
begin
  try
    case aintMemoIdx of
      0: strFileName:=gdtInfo.strLinkinfoFile;
      1: strFileName:=gdtInfo.strUploadInfoFile;
      2: strFileName:=gdtInfo.strDownLoadInfoFile;
      3: strFileName:=gdtInfo.strUnKownErrInfoFile;
      4: strFileName:=gdtInfo.strFilePressInfoFile;
    end;
    boolOverMaxFileSize:=FileExists(strFileName) and
      (GetFileSize(strFileName)>(StrToFloat(gdtInfo.strFileMaxSize)*1024*1024));
    boolToChangeFile:=boolOverMaxFileSize;
    if boolOverMaxFileSize then
    begin
			strFileEx:=ExtractFileExt(strFileName);
			strFileName:=copy(strFileName,1,length(strFileName)-length(strFileEx))+'_01'+strFileEx;
    end;

    while boolOverMaxFileSize do
		begin
			boolOverMaxFileSize:=(FileExists(strFileName) and
				(GetFileSize(strFileName)>(strtoint(gdtInfo.strFileMaxSize)*1024*1024)));
		 if boolOverMaxFileSize then
		 begin
       strFileEx:=ExtractFileExt(strFileName);
			 strFileName:=copy(strFileName,1,length(strFileName)-length(strFileEx))+'_01'+strFileEx;
		 end;
    end;
    WriteDataToFile(strFileName,astrData);
  except
  end;
end;
procedure SetFilePara;
Var
  NowTime:string;
  newFilepath:string;
begin
 try
    NowTime:=Formatdatetime('yyyymmdd',now);
    newFilepath:=gstrAppPath+'\UnittLog';
    if not DirectoryExists(newFilepath) then CreateDir(newFilepath);
    gdtInfo.strLinkinfoFile:=newFilepath+'\'+'Connection.log';
    gdtInfo.strUploadInfoFile:=newFilepath+'\'+'Recedata_'+NowTime+'.log';
    gdtInfo.strDownLoadInfoFile:=newFilepath+'\'+'SendData_'+NowTime+'.log';
    gdtInfo.strUnKownErrInfoFile:=newFilepath+'\'+'Error.log';
    gdtInfo.strFilePressInfoFile:=newFilepath+'\'+'File_'+NowTime+'.log';
    gdtInfo.strMemoMaxLine:='10000';
    gdtInfo.strFileMaxSize:='5';
    gdtInfo.strMemoMaxLineProcMode:='0';
  except
    exit;
  end;
end;
procedure ReadIniFile(Var Ip,port,UserName,Password,FilePath,FileName,Version,ZwFileName,zwVersion:String);
var
  ConnInfo :TIniFile;
  IniFile:String;
  strIp,strport,strUserName,strPassword,strFilePath,strFileName,
  strVersion:String;
begin
  IniFile := gstrAppPath + '\UpDate.ini';
  try
     ConnInfo := TIniFile.Create(IniFile);
    try

      strIp:= ConnInfo.ReadString('Server','Ip','');
      strport:= ConnInfo.ReadString('Server','port','');
      strUserName:= ConnInfo.ReadString('Server','UserName','');
      strPassword:= ConnInfo.ReadString('Server','Password','');
      strFilePath:= ConnInfo.ReadString('Server','FilePath','');
      strFileName:= ConnInfo.ReadString('Server','FileName','');
      strVersion:= ConnInfo.ReadString('Server','Version','');
      ZwFileName:= ConnInfo.ReadString('Server','ZwFileName','');
      zwVersion:= ConnInfo.ReadString('Server','zwVersion','');
      Ip:=strIp;
      port:=strport;
      UserName:=strUserName;
      Password:=strPassword;
      FilePath:=strFilePath;
      FileName:=strFileName;
      Version:=strVersion;
    finally
      ConnInfo.Free;
      ConnInfo:=nil;
    end;
  except
    Exit;
  end;
end;


procedure ReadCongifgFile(Var UnitFtpPath,BankFtpPath,Ip,port,UserName,Password,
          Filepath,FileName,Version,ZwFileName,ZwVersion,
          UnitCreateDate,BankCreateDate,BankLoadDate,StrBoolAuto:String);
var
  ConnInfo :TIniFile;
  IniFile:String;
  strUnitFtpPath,strBankFtpPath,strIp,strport,strUserName,strPassword,strFileName,
  strVersion,strUnitCreateDate,strBankCreateDate,strBankLoadDate:String;
begin
  IniFile := gstrAppPath + '\UpDate.ini';
  try
     ConnInfo := TIniFile.Create(IniFile);
    try
      strUnitFtpPath:= ConnInfo.ReadString('Server','UnitFtpPath','');
      strBankFtpPath:= ConnInfo.ReadString('Server','BankFtpPath','');
      strIp:= ConnInfo.ReadString('Server','Ip','');
      strport:= ConnInfo.ReadString('Server','port','');
      Filepath:= ConnInfo.ReadString('Server','FilePath','');
      strUserName:= ConnInfo.ReadString('Server','UserName','');
      strPassword:= ConnInfo.ReadString('Server','Password','');
      strFileName:= ConnInfo.ReadString('Server','FileName','');
      strVersion:= ConnInfo.ReadString('Server','Version','');
      ZwFileName:= ConnInfo.ReadString('Server','ZwFileName','');
      ZwVersion:= ConnInfo.ReadString('Server','ZwVersion','');
      strUnitCreateDate:= ConnInfo.ReadString('Server','UnitCreateDate','');
      strBankCreateDate:= ConnInfo.ReadString('Server','BankCreateDate','');
      strBankLoadDate:= ConnInfo.ReadString('Server','BankLoadDate','');
      StrBoolAuto:= ConnInfo.ReadString('Server','BankAuto','');
      UnitFtpPath:=strUnitFtpPath;
      BankFtpPath:=strBankFtpPath;
      Ip:=strIp;
      port:=strport;
      UserName:=strUserName;
      Password:=strPassword;
      FileName:=strFileName;
      Version:=strVersion;
      UnitCreateDate:=strUnitCreateDate;
      BankCreateDate:=strBankCreateDate;
      BankLoadDate:=strBankLoadDate;
    finally
      ConnInfo.Free;
      ConnInfo:=nil;
    end;
  except
    Exit;
  end;
end;

procedure WriteCongifgFile(const UnitFtpPath,BankFtpPath,Ip,port,UserName,Password,
          Filepath,FileName,Version,ZwFileName,ZwVersion,
          UnitCreateDate,BankCreateDate,BankLoadDate,StrBoolAuto:String);
var
  ConnInfo :TIniFile;
  IniFile: string;
begin
  IniFile := gstrAppPath + '\UpDate.ini';
  try
     ConnInfo := TIniFile.Create(IniFile);
    try
      ConnInfo.WriteString('Server', 'UnitFtpPath', UnitFtpPath);
      ConnInfo.WriteString('Server', 'BankFtpPath', BankFtpPath);
      ConnInfo.WriteString('Server', 'Ip', Ip);
      ConnInfo.WriteString('Server', 'port', port);
      ConnInfo.WriteString('Server', 'FilePath', Filepath);
      ConnInfo.WriteString('Server', 'UserName', UserName);
      ConnInfo.WriteString('Server', 'Password', Password);
      ConnInfo.WriteString('Server', 'FileName', FileName);
      ConnInfo.WriteString('Server', 'Version', Version);
      ConnInfo.WriteString('Server', 'ZwFileName', ZwFileName);
      ConnInfo.WriteString('Server', 'ZwVersion', ZwVersion);
      ConnInfo.WriteString('Server', 'UnitCreateDate', UnitCreateDate);
      ConnInfo.WriteString('Server', 'BankCreateDate', BankCreateDate);
      ConnInfo.WriteString('Server', 'BankLoadDate', BankLoadDate);
      ConnInfo.WriteString('Server', 'BankAuto', StrBoolAuto);
     finally
      ConnInfo.Free;
      ConnInfo:=nil;
    end;
  except
    Exit;
  end;
end;

function GetMemoLineCount(memHandle:HWnd): integer;
begin
  Result:= 0;
  if memHandle<>0 then
  begin
    Result:= SendMessage(memHandle, EM_GETLINECOUNT, 0, 0);
    if SendMessage(memHandle, EM_LINELENGTH, SendMessage(memHandle,
      EM_LINEINDEX, Result - 1, 0), 0) = 0 then Dec(Result);
  end;
end;
function WriteToIniFile(astrIniFileName, astrSect,
  astrField: string;astrValue:string): boolean;
begin
  try
    result:=WritePrivateProfileString(pchar(astrSect),pchar(astrField),pchar(astrValue),
      pchar(astrIniFileName));
  except
    result:=false;
  end;
end;

function  SetRegStr(SubKey:string;ValueKey:string; Value:string):wordbool;
//SubKey   ：要操作的根键
//ValueKey ：要操作的主键  如果为空则默认为写入键值到SubKey根键的默认主键
//Value    ：要写入的键值
var
  RegF:Tregistry; //定义变量RegF
begin
  Result:=false;
  SubKey:=trim(Subkey);
  ValueKey:=trim(ValueKey);
  RegF:=Tregistry.Create; //创建变量
  RegF.RootKey:=HKEY_LOCAL_MACHINE;// 指定要操作的根键
  try
    if RegF.Openkey(SubKey,true) then
    begin
      Regf.WriteString(ValueKey,Value);
      Result:=True;
    end;
  finally
    RegF.CloseKey ;
    RegF.Free;// 释放变量
  end;
end;


function  DelRegStr(SubKey:string;ValueKey:string):wordbool;
var
  RegF:Tregistry; //定义变量RegF
begin
  Result:=false;
  SubKey:=trim(Subkey);
  ValueKey:=trim(ValueKey);
  RegF:=Tregistry.Create; //创建变量
  RegF.RootKey:=HKEY_LOCAL_MACHINE;// 指定要操作的根键
  try
    if RegF.Openkey(SubKey,true) then
    begin
      Regf.DeleteValue(ValueKey);
      Result:=True;
    end;
  finally
    RegF.CloseKey ;
    RegF.Free;// 释放变量
  end;
end;

procedure ClearAllEditTxt(frmParent:Tform);
Var
  intCompIdx:Integer;
  Temp:Tcomponent;
Begin
   for intCompIdx:=0 to frmParent.ComponentCount-1 do
   Begin
     Temp:=frmParent.Components[intCompIdx];
     if Temp is Tedit Then
        TEdit(Temp).clear;
   End;
End;
function MoveFileName(const sourceFileName,destFileName:String):boolean;
begin
  try
    result:=False;
    MoveFile(pchar(sourceFileName),pchar(destFileName));
    result:=True;
  except
    result:=False;
  end;
end;
procedure ShowMeCenter(frmForm:TForm);
begin
  frmForm.top:=(Screen.Height-frmForm.Height)div 2;
  frmForm.Left:=(Screen.Width-frmForm.Width) div 2;
end;

function ExecSQL(ConnectionString,CmdSQL:String):boolean;
var
 adoQry:TadoQuery;
 Adoconn:Tadoconnection;
begin
    Result:=False;
    try
      Adoconn:=Tadoconnection.Create(nil);
      try
        Adoconn.CommandTimeout:=30;
        Adoconn.ConnectionString:=ConnectionString;
        Adoconn.LoginPrompt:=False;
        Adoconn.Open;
        if not Adoconn.InTransaction then
          Adoconn.BeginTrans;
        adoQry:=TAdoQuery.Create(nil);
        try
          adoQry.Close;
          adoQry.Connection:=Adoconn;
           try
            adoQry.SQL.Text:=CmdSQL;
            adoQry.Prepared:=true;
            adoQry.ExecSQL;
            if Adoconn.InTransaction then
              Adoconn.CommitTrans;
            Result:=True;
            except
               if Adoconn.InTransaction then
                 Adoconn.RollbackTrans;
               Raise;
            end;
        finally
          FreeAndNil(adoQry);
        end;
      finally
         FreeandNil(Adoconn);
      end;
    except
      Raise;
    end;
end;

end.
