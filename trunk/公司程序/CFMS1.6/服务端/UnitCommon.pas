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
    //�û�id��ϵͳ����Ա�ʺţ��û��ʺţ���λ��ţ������ַ�����б��
    UserID,AdminNo,UserNo,CompanyID,ServerID,CityID : OleVariant;
    ChildCompanyID,ParentCompanyID :TStrings;  //���û�������λ�������¼���λ���ϼ���λ�����Լ�
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
    isConDB :Boolean; //�Ƿ�ɹ�����
    isLogin : Boolean; //�Ƿ�����
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
//--��������: GetFileTimeInfor
//--��������: FileName �ļ���  TimeFlag ʱ�����  (1 �����ļ�����ʱ�� 2 �����ļ��޸�ʱ�� 3 �����ϴη����ļ���ʱ��)
//--��������: ��ȡ�ļ��޸�ʱ��
//--�� �� ֵ: ����ָ�����ļ��޸�ʱ��
//--������ע: ��
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
