unit UnitCommon;

interface
uses
  Windows, DBGrids, Classes, SysUtils, Variants, WinSock, Messages;

const
  ADDFLAG = 1;
  MODIFYFLAG = 2;
  CANCELFLAG = 3;
  WM_THREAD_MSG=WM_USER+3 ;
type
  TCurrentParam = record
    UserName: WideString;
    //用户id，系统管理员帐号，用户帐号，单位编号，服务地址，城市编号
    UserID,AdminNo,UserNo,CompanyID,ServerID,CityID : OleVariant;
    ChildCompanyID,ParentCompanyID :TStrings;  //此用户所属单位的所有下级单位，上级单位不含自己
    GatherIdStr,ChildStr,ParentStr :String;
  end;

  PThreadData = ^ThreadData;
  ThreadData = record
    command :integer;
    Companyid :integer;
    Msg :String;
  end;          

  TTableMasterList = record
    ALARMID           :integer;
    DEVICEID          :integer;
    Companyid         :integer;
    FDID              :string;
    CHANNELID         :integer;
    GATHERID          :integer;
    AREAID            :integer;
    CONTENTCODE       :integer;
    FLOWTACHE         :integer;
    CREATETIME        :Variant;
    COLLECTTIME       :Variant;
    SENDTIME          :Variant;
    CLEARTIME         :Variant;
    CANCELSIGN        :integer;
    CANCELNOTE        :string;
    REMOVETIME        :Variant;
    STARTSEND         :string;
    ENDSEND           :string;
    LIMITEDHOUR       :integer;
    CAUSECODE         :integer;
    TROUBLEOCCURCAUSE :string;
    RESOLVENTCODE     :integer;
    TROUBLERESOLVENT  :string;
    RULEDEPT          :integer;
    ISSTAT            :Variant;
    SENDOPERATOR      :integer;
    REMOVEOPERATOR    :integer;
    COLLECTOPERATOR   :integer;
    CLEAROPERATOR     :integer;
    UPDATETIME        :Variant;
    CANCELTIME        :Variant;
    CANCELOPERATOR    :integer;
    ISPERFORM         :integer;
    DIACHRONIC        :integer;
    REPISSTAT         :Variant;
    RESENDTIME        :Variant;
    ISNEWLY           :integer;
    APPENDOPERATOR    :integer;
    REMARK            :string;
    ERRORCONTENT      :string;
    CITYID            :integer;
    RECEIVE           :integer;
    SUBMITTIME        :Variant;
    SUBMITOPERATOR    :integer;
    IFCOLLECTION      :integer;
    NEWCOLLECTTIME    :Variant;
    ISINCREMENT       :integer;
    FACTESERVICE      :integer;
    ESERVICETIME      :Variant;
    PROCESTATECODE    :integer;
    PROCESTATENAME    :string;
    PROCETIME         :Variant;
    LIMITTIME         :Variant;
    SENDTYPE          :integer;
    RETURNCOUNT       :integer;
    RETURNREMARK      :string;
    RETURNCOMPANYID   :integer;
    COLLECTIONKIND    :integer;
    COLLECTIONCODE    :integer;
    ALARMTYPE         :integer;
    occurid           :integer;
  end;

  TTable_FlowRec_List = record
    sflowtache : integer;
    updatenote : string;
    collecttime : Variant;
    collectoperator : integer;
    alarmid,occurid : integer;
    flowtrackid :integer;
    tflowtache : integer;
    DeviceID : Integer;
    ContentCode : integer;
    cityid :integer;
    remark :String;
  end;

  TCommonObj = class
    ID : integer;
    Name : String;
  end;
  
  TSysParam = record
    isConDB :Boolean; //是否成功连接
    isLogin : Boolean; //是否允许
    DBServer :String;
    DBUser :string;
    AdminNo : String;
    CurUserID : Integer;
    CurUserNo : String;
  end;
  function GetFunArray(list :TStrings):OleVariant;
  function GetFileTimeInfor(FileName:string;TimeFlag:integer):string;

implementation

function GetFunArray(list :TStrings):OleVariant;
var
  i :integer;
begin
  Result := varArrayCreate([0, list.Count-1], varVariant);
  for i := 0 to list.Count-1 do
    Result[i] := list.Strings[i];
end;

//==============================================================
//--函数名称: GetFileTimeInfor
//--函数参数: FileName 文件名  TimeFlag 时间参数  (1 返回文件创建时间 2 返回文件修改时间 3 返回上次访问文件的时间)
//--函数功能: 获取文件修改时间
//--返 回 值: 返回指定的文件修改时间
//--函数备注: 无
//==============================================================
function GetFileTimeInfor(FileName:string;TimeFlag:integer):string;
var
  LocalFileTime : TFileTime;
  fhandle:integer;
  DosFileTime : DWORD;
  FindData : TWin32FindData;
begin
  fhandle := FindFirstFile(Pchar(FileName), FindData);
  if (FHandle <> INVALID_HANDLE_VALUE) then
     begin
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        begin
          case TimeFlag of
          1:
            begin
               FileTimeToLocalFileTime(FindData.ftCreationTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
            3:
            begin
               FileTimeToLocalFileTime(FindData.ftLastAccessTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
            2:
            begin
               FileTimeToLocalFileTime(FindData.ftLastWriteTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
           end;  //case;
        end;
     end;
end;

end.
