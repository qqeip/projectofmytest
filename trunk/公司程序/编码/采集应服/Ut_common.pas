unit Ut_common;

interface
uses
  DBGrids,Classes,SysUtils,Variants,Messages;

const
    ADDFLAG = 1;
    MODIFYFLAG = 2;
    CANCELFLAG = 3;
    WM_THREAD_MSG  = WM_USER + 100;
    WM_THREADSTATE_MSG = WM_USER + 101;
    WM_CDMA_MSG  = WM_USER + 110;
type
  ThreadData = record
    command :integer;
    districtid :integer;
    Msg :String;
  end;
  PThreadData = ^ThreadData;
type

 {业务处理消息数据类型}
  Rcmd = record
    command: integer;
  end;
  {用户信息类型}
  Ruserdata = record
    userid :integer;
    userno :String[20];
    districtid :integer;
    cityid :integer;
    parentid :integer;
    Filter :String[20];
  end;
  RBroadData = record
    msg :String[255];
  end;

type
    TTable_Cs_Index = record
    CityID : integer;
    batchid : integer;
    ALARMCONTENTCODE : integer;
    csid : integer;
    flowtache : integer;
    createtime : Variant;
    collecttime : Variant;
    sendtime : Variant;
    cleartime : Variant;
    cancelsign : integer;
    cancelnote : string;
    removetime : Variant;
    LimitedHour : Integer;
    ISALARM : string;
    ESERVICECOCODE : integer;
    deviceid : String;
    RuleDept : integer;
    SendOperator : integer;
    RemoveOperator : integer;
    CollectOperator : integer;
    ClearOperator : integer;
    updatetime : Variant;
    occurid : integer;
    eserviceentitycode : integer;
    notenum : integer;
    calleffect : integer;
    RESENDTIME : Variant;
    ErrorContent : string;
    NewCollectTime : Variant;
    startsend : string;
    endsend : string;
  end;

  TTable_FlowRec_List = record
    sflowtache : integer;
    updatenote : string;
    collecttime : Variant;
    collectoperator : string;
    batchid : integer;
    flowtrackid :integer;
    tflowtache : integer;
    occurid : integer;
    deviceid : string;
    csid,cityid : integer;
    remark :String;
  end;
  
  TUser = class
    userno,username,email,position,officephone, homephone :string;
    birthday :TDateTime;
    userid,sex, creator,districtid,cityid,ZONEID,flag : Integer;
    FunList :TStrings;
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

  TDistrict = class(TObject)
    id,kind,parent:integer;
    name,remark:string;
    AreaList:TStrings;
  end;

  TArea = class(TObject)
    id:integer;
    name:string;
    top_id:integer;
    layer:integer;
    iCheck :Integer;
  end;
  function GetUserArray(Auser:TUser):OleVariant;
  function GetUserObj(AUser:OleVariant) : TUser;
  function GetFunArray(list :TStrings):OleVariant;
  function GetBetweenTime(StartTime, EndTime: TDateTime): string;

implementation

function GetUserObj(AUser:OleVariant) : TUser;
var
  User : TUser;
begin
  result := nil;
  if VarIsEmpty(AUser) then
    Exit;
  User := TUser.Create;
  user.userno     :=AUser[0];
  user.username   :=AUser[1];
  user.email      := AUser[2];
  user.position   :=AUser[3];
  user.officephone:= AUser[4];
  user.homephone  := AUser[5];
  user.birthday   :=AUser[6];
  user.userid     := AUser[7];
  user.sex        :=AUser[8];
  user.creator    :=AUser[9];
  user.districtid :=AUser[10];
  user.cityid := AUser[11];
  User.ZONEID := AUser[12];
  User.flag := AUser[13];
  result := user;
end;

function GetUserArray(Auser:TUser):OleVariant;
begin
  //11 个属性
  Result := varArrayCreate([0, 13], varVariant);
  Result[0] := Auser.userno;
  Result[1] := Auser.username;
  Result[2] := Auser.email;
  Result[3] := Auser.position;
  Result[4] := Auser.officephone;
  Result[5] := Auser.homephone;
  Result[6] := Auser.birthday;
  Result[7] := Auser.userid;
  Result[8] := Auser.sex;
  Result[9] := Auser.creator;
  Result[10]:= Auser.districtid;
  Result[11]:= Auser.cityid;
  Result[12]:= Auser.ZONEID;
  Result[13]:= Auser.flag;
end;
function GetFunArray(list :TStrings):OleVariant;
var
  i :integer;
begin
  Result := varArrayCreate([0, list.Count-1], varVariant);
  for i := 0 to list.Count-1 do
    Result[i] := list.Strings[i];
end;

function GetBetweenTime(StartTime, EndTime: TDateTime): string;
var
  Days,Hours,Minutes,Seconds: Int64;
  sResult: string;
begin
  if EndTime>StartTime then
    Seconds := Trunc(60*60*24*(EndTime-StartTime))
  else
    Seconds := Trunc(60*60*24*(StartTime-EndTime));

  Days := Seconds div (60*60*24);
  Seconds := Seconds - Days*60*60*24;
  Hours := Seconds div (60*60);
  Seconds := Seconds - Hours*60*60;
  Hours := Seconds div (60*60);
  Seconds := Seconds - Hours*60*60; 
  Minutes := Seconds div 60;
  Seconds := Seconds - Minutes*60;

  sResult := '';
  if Days>0 then
    sResult := sResult+IntToStr(Days)+'天';
  if (Days+Hours)>0 then
    sResult := sResult+IntToStr(Hours)+'小时';
  if (Days+Hours+Minutes)>0 then
    sResult := sResult+IntToStr(Minutes)+'分'; 
  sResult := sResult+IntToStr(Seconds)+'秒。';

  Result := sResult;    
end;

end.
