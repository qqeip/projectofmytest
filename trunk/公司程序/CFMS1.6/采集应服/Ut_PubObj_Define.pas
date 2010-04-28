unit Ut_PubObj_Define;

interface

uses
  Classes,SysUtils,Variants,ADODB,Windows,Messages;//,AlarmServiceApp_TLB ;

const
  MaxThread = 9;

type
  //�ɼ��߳̽ṹ��
  TCollect_Info = record
    CollectKind : integer;
    IsCreate : integer;
    CollectState : integer;
    CollectionCYC : integer;
    CollectName : String;
  end;

  //���ܲ����ṹ��
  TRemoteSource = record
    collectionkind, collectioncode, CityID,
    SetValue, forwardday : integer; //�ɼ���N�����ڸ澯״̬δ�����ı�ĸ澯��վ, �ɼ����N���ڵ�����
    collectionname,
    RemoteConn, CSTabName : string; //Զ�����ݿ����ӣ�����Դ
  end;

  //�������ݲ����ṹ��
  TErrorContentParam = record
    ThreadSN : Integer; //�����̱߳��
    ErrorSN : Integer;  //�������ݱ��
    CurrTime : Tdatetime; //�磺now
    RunThreadName : String; //�磺���վ״̬�澯�ɼ��߳�
    CollectionKind : integer; //�߳������
    CollectionCode : integer; //�����е����
    AlarmKindName : String; //�磺���վ״̬�澯
    collectionname : String;  //�磺����2������
    ErrorNetMan : Integer; //�ɼ�����������
    SucceedNetMan : Integer; //�ɼ��ɹ�������
    PassTime : String; //�ɼ�����ʱ��
    BornError : String; //ԭʼ������Ϣ
  end;
  
var
  Collect_Info:array of TCollect_Info;  //��Ųɼ��̲߳���
  RemoteSource : array[1..MaxThread] of array of TRemoteSource; //��Ÿ�<�澯�ɼ��߳�>�漰�ĸ����ܲ���
  SqlStr : array[1..MaxThread] of array of string; //��Ÿ�<�澯�ɼ��߳�>�漰��SQLִ�����
  ErrorContentList : array[1..6] of string; //����߳��еĸ�������ʾ����

  //CR:   Trtlcriticalsection;
  //��ָ��AdoQuery��ִ��ָ��SQL���
  procedure PubExecTheSQL(Var Ado_LocalQuery: TADOQuery; TheSQLStr: String);

  //���Զ��SQL�������ɲ����滻�ĺ���
  Function PubReplaceSQLParam(const TheSQL: string; TheRemoteSource: TRemoteSource):String;

  //��ָ��SQL����ָ�����ݼ�
  procedure PubOpenTheDataSet(var TheADOQuery: TADOQuery; thesql: string);

  //�õ�ִ��ָ��SQL��ļ�¼����
  function PubGetRecCount(var TheADOQuery: TADOQuery; TheSql:string):integer;

  //�õ�ָ�����͵���ˮ��
  function PubProduceFlowNumID(var Sp_Alarm_FlowNumber: TADOStoredProc; I_FLOWNAME: string; I_SERIESNUM: integer):Integer;

  //���ø����̡�Դ���족��Ĭ��ֵ
  function SetDefaultValue(var Ado_RemoteQuery: TADOQuery; ThreadSN, NetManSN: integer):String;

  //��ʼ��ָ��<�澯�ɼ��߳�>�漰�ĸ����ܲ���
  function InitNetManParamSet(var Ado_LocalQuery,Ado_RemoteQuery: TADOQuery; ThreadSN,CollectionKind:integer):boolean;

  //��ʼ��ָ��<�澯�ɼ��߳�>�漰��SQLִ�����
  procedure InitSQLVar(ThreadSN:integer);

  //��ʼ��<�澯�ɼ��߳�>�Ĵ�������
  procedure InitErrorContent();

  //��ʼ���ɼ��̲߳���
  function InitCollectTheadParam(var Ado_Collection_Cfg : TADOQuery):boolean;

  //�õ�ִ���߳�����
  Function GetRunTheadName(var CollectKind:integer):String;

  //��ö�Ӧ�Ĳɼ�������Ϣ
  Function GetErrorContent(ErrorContentParam : TErrorContentParam):String;

  //�õ��澯��������
  Function GetAlarmKindName(CollectionKind: Integer):String;
  //function CollectServerMsg(Event:integer;districtid:integer=0;msg :String=' '):Boolean;

implementation

//��ָ��AdoQuery��ִ��ָ��SQL���
procedure PubExecTheSQL(Var Ado_LocalQuery: TADOQuery; TheSQLStr: String);
var
  CL:TRTLCriticalSection;
begin
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    with Ado_LocalQuery do
    begin
      close;
      sql.Clear;
      sql.Add(TheSQLStr);
      ExecSQL;
    end;
  finally
    LeaveCriticalSection(CL);
  end;
end;

//���Զ��SQL�������ɲ����滻�ĺ���
Function PubReplaceSQLParam(const TheSQL: string; TheRemoteSource: TRemoteSource):String;
var
  CL:TRTLCriticalSection;
begin
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    Result:=TheSQL;
    with TheRemoteSource do
    begin
      Result:=StringReplace(Result, '@tabname', CSTabName, [rfReplaceAll, rfIgnoreCase]);
      Result:=StringReplace(Result, '@CityID', inttostr(CityID), [rfReplaceAll, rfIgnoreCase]);
      Result:=StringReplace(Result, '@ForwardDay', inttostr(ForwardDay), [rfReplaceAll, rfIgnoreCase]);
      Result:=StringReplace(Result, '@SetValue', inttostr(SetValue), [rfReplaceAll, rfIgnoreCase]);
      Result:=StringReplace(Result, '@collectionkind', inttostr(collectionkind), [rfReplaceAll, rfIgnoreCase]);
      Result:=StringReplace(Result, '@collectioncode', inttostr(collectioncode), [rfReplaceAll, rfIgnoreCase]);
    end;
  finally
    LeaveCriticalSection(CL);
  end;
end;

//�����߳���ŵõ�ִ���߳�����
Function GetRunTheadName(var CollectKind:integer):String;
var i:integer;
begin
  Result:='';
  for i:=Low(Collect_Info) to High(Collect_Info) do
    if Collect_Info[i].CollectKind=CollectKind then
      Result:=Collect_Info[i].CollectName
end;

function PubProduceFlowNumID(var Sp_Alarm_FlowNumber: TADOStoredProc; I_FLOWNAME: string; I_SERIESNUM: integer):Integer;
var
  CL:TRTLCriticalSection;
begin
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    with Sp_Alarm_FlowNumber do
    begin
      close;
      Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //��ˮ������
      Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //�����������ˮ�Ÿ���
      execproc;
      result:=Parameters.parambyname('O_FLOWVALUE').Value; //����ֵΪ���ͣ�����ֻ�������еĵ�һ��ֵ�����´η���ֵΪ��result+I_SERIESNUM
      close;
    end;
  finally
    LeaveCriticalSection(CL);
  end;
end;

function PubGetRecCount(var TheADOQuery: TADOQuery; TheSql:string):integer;
var
  CL:TRTLCriticalSection;
begin
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    with TheADOQuery do
    begin
      close;
      sql.Clear;
      sql.Add(TheSql);
      open;
      result:=fieldbyname('reccount').AsInteger;
      close;
    end;
  finally
    LeaveCriticalSection(CL);
  end;
end;

function SetDefaultValue(var Ado_RemoteQuery: TADOQuery; ThreadSN, NetManSN: integer):String;
begin
  case ThreadSN of
  //Utʵʱ�澯
   1 : Result:='UTAlarm';
  //Ut��·�澯
   2 : Result:='VIEW_CSREPORT_CSLINE_163';
  //Ut���վ״̬�澯
   3 : Result:='VIEW_CSREPORT_MELCOCSRUN_163';
  //UtС��վ״̬�澯
   4 : Result:='VIEW_CSREPORT_RPRUN_163';
  //����ʵʱ�澯
   5 : begin
         Ado_RemoteQuery.Connection.ConnectionString:=RemoteSource[ThreadSN][NetManSN].RemoteConn;
         if PubGetRecCount(Ado_RemoteQuery, sqlstr[ThreadSN][10])>0 then //�����ݱ�����ANU�����ܿ�
           Result:='CurrAlmLog'  //ANU
         else
           Result:='CurrAlmInfo'; //ICSC
       end;
  //����״̬�澯
   6 : Result:='View_CsFaultData';
  //��Ѷʵʱ�澯
   7 : begin
         Ado_RemoteQuery.Connection.ConnectionString:=RemoteSource[ThreadSN][NetManSN].RemoteConn;
         if PubGetRecCount(Ado_RemoteQuery, sqlstr[ThreadSN][9])>0 then
           Result:='CsMainAll'
         else
           Result:='CsMain';
        end;
  //��Ѷ����·���Ը澯
   8 : begin
         Ado_RemoteQuery.Connection.ConnectionString:=RemoteSource[ThreadSN][NetManSN].RemoteConn;
         if PubGetRecCount(Ado_RemoteQuery, sqlstr[ThreadSN][12])>0 then
           Result:='CsMainAll'
         else
           Result:='CsMain';
       end;
  //��Ѷ��·���Ը澯
   9 : begin
         Ado_RemoteQuery.Connection.ConnectionString:=RemoteSource[ThreadSN][NetManSN].RemoteConn;
         if PubGetRecCount(Ado_RemoteQuery, sqlstr[ThreadSN][20])>0 then
           Result:='CsMainAll'
         else
           Result:='CsMain';
       end;
  end;
end;

procedure PubOpenTheDataSet(var TheADOQuery: TADOQuery; thesql:string);
var
  CL:TRTLCriticalSection;
begin
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    with TheADOQuery do
    begin
      close;
      sql.Clear;
      sql.Add(thesql);
      open;
    end;
  finally
    LeaveCriticalSection(CL);
  end;
end;

//��ʼ���ɼ��̲߳���  ִֻ��һ�Σ����Բ��ü��߳���������
function InitCollectTheadParam(var Ado_Collection_Cfg : TADOQuery):boolean;
var i:integer;
begin
  Result:=true;
  with Ado_Collection_Cfg do
  begin
    close;
    open;
    if IsEmpty then
    begin
      Result:=false;
      exit;
    end;
    SetLength(Collect_Info, RecordCount);
    first;  i:=0;
    while not eof do
    with Collect_Info[i] do
    begin
      CollectKind := fieldbyname('CollectKind').AsInteger;
      IsCreate := fieldbyname('IsCreate').AsInteger;
      CollectState := fieldbyname('CollectState').AsInteger;
      CollectionCYC := fieldbyname('CollectionCYC').AsInteger;
      CollectName := fieldbyname('CollectName').AsString;
      inc(i);
      next;
    end;
  end;
end;

//��ʼ���ɼ��̲߳���  ִֻ��һ�Σ����Բ��ü��߳���������
function InitNetManParamSet(var Ado_LocalQuery,Ado_RemoteQuery: TADOQuery; ThreadSN,CollectionKind:integer):boolean;
var
  i:integer;
  NetManSQL : string;
begin
  Result:=true;
  NetManSQL:=' select collectionkind, collectioncode, CityID, SetValue, forwardday,';
  NetManSQL:=NetManSQL + ' collectionname, Last_DataSource, increment_column';
  NetManSQL:=NetManSQL + ' from alarm_collection_cyc_list';
  NetManSQL:=NetManSQL + ' where collectionkind='+inttostr(collectionkind);
  NetManSQL:=NetManSQL + ' order by collectioncode ';
  PubOpenTheDataSet(Ado_LocalQuery, NetManSQL);

  with Ado_LocalQuery do
  begin
     SetLength(RemoteSource[ThreadSN], Recordcount);
     first;   i:=0;
     if IsEmpty then
     begin
       Result:=false;
       exit;
     end;
     while not eof do
     begin
       RemoteSource[ThreadSN][i].collectionkind:=fieldbyname('collectionkind').AsInteger;

       RemoteSource[ThreadSN][i].collectioncode:=fieldbyname('collectioncode').AsInteger;

       RemoteSource[ThreadSN][i].collectionname:=fieldbyname('collectionname').AsString;

       RemoteSource[ThreadSN][i].RemoteConn:=fieldbyname('Last_DataSource').AsString;

       RemoteSource[ThreadSN][i].CityID:=fieldbyname('CityID').AsInteger;

       if (fieldbyname('increment_column').AsString='') or fieldbyname('increment_column').IsNull then
         RemoteSource[ThreadSN][i].CSTabName:=SetDefaultValue(Ado_RemoteQuery,ThreadSN,i)
       else
         RemoteSource[ThreadSN][i].CSTabName:=fieldbyname('increment_column').AsString;

       if (fieldbyname('ForwardDay').AsString='') or fieldbyname('ForwardDay').IsNull then
         RemoteSource[ThreadSN][i].ForwardDay:=7     //Ĭ��Ϊ�ɼ�7�����ڵĸ澯����
       else
         RemoteSource[ThreadSN][i].ForwardDay:=fieldbyname('ForwardDay').AsInteger;

       if (fieldbyname('SetValue').AsString='') or fieldbyname('SetValue').IsNull then
         RemoteSource[ThreadSN][i].SetValue:=10     //Ĭ��Ϊ�۲�10���Ӻ�������
       else
         RemoteSource[ThreadSN][i].SetValue:=fieldbyname('SetValue').AsInteger;
       inc(i);
       next;
     end;
  end;
end;

Function GetAlarmKindName(CollectionKind: Integer):String;
begin
  case CollectionKind of
   1 : Result:='UTʵʱ�澯';
   2 : Result:='UT��·�澯';
   3 : Result:='UT���վ״̬�澯';
   4 : Result:='UTС��վ״̬�澯';
   6 : Result:='����ʵʱ�澯';
   7 : Result:='����״̬�澯';
  10 : Result:='��Ѷʵʱ�澯';
  11 : Result:='��Ѷ����·���Ը澯';
  13 : Result:='��Ѷ��·���Ը澯';
  end;
end;

//��ö�Ӧ�Ĳɼ�������Ϣ
Function GetErrorContent(ErrorContentParam : TErrorContentParam):String;
//�����Ӧ��ŵĳ�������ǰ����Ӧ��Ҫ����Ĳ����������£�
//�κ�ѡ����贫��Ĳ�����ErrorSN/ CollectionKind
  //1:
  //2: CollectionCode/ collectionname
  //3: ErrorNetMan/ SucceedNetMan
  //4: PassTime
  //5: BornError
  //6:

//�����贫����������
  //  ThreadSN : Integer; //�����̱߳��
  //  ErrorSN : Integer;  //�������ݱ��
  //  CollectionKind : integer; //�߳������
  //  CollectionCode : integer; //�����е����
  //  collectionname : String;  //�磺����2������
  //  ErrorNetMan : Integer; //�ɼ�����������
  //  SucceedNetMan : Integer; //�ɼ��ɹ�������
  //  PassTime : String; //�ɼ�����ʱ��
  //  BornError : String;  //ԭʼ������Ϣ
begin
  with ErrorContentParam do
  begin
    RunThreadName:=GetRunTheadName(CollectionKind);
    AlarmKindName:=GetAlarmKindName(CollectionKind);
    CurrTime:=now;
    Result:=ErrorContentList[ErrorSN];
    Result:=StringReplace(Result, '@CurrTime', datetimetostr(CurrTime), [rfReplaceAll, rfIgnoreCase]);
    Result:=StringReplace(Result, '@ErrorSN', inttostr(ErrorSN), [rfReplaceAll, rfIgnoreCase]);
    Result:=StringReplace(Result, '@CollectionKind', format('%0.2d',[CollectionKind]), [rfReplaceAll, rfIgnoreCase]);
    Result:=StringReplace(Result, '@RunThreadName', RunThreadName, [rfReplaceAll, rfIgnoreCase]);
    case ErrorSN of
     1 : begin
           Result:=StringReplace(Result, '@AlarmKindName', AlarmKindName, [rfReplaceAll, rfIgnoreCase]);
         end;
     2 : begin
           Result:=StringReplace(Result, '@CollectionCode', inttostr(CollectionCode), [rfReplaceAll, rfIgnoreCase]);
           Result:=StringReplace(Result, '@collectionname', collectionname, [rfReplaceAll, rfIgnoreCase]);
         end;
     3 : begin
           Result:=StringReplace(Result, '@ErrorNetMan', inttostr(ErrorNetMan), [rfReplaceAll, rfIgnoreCase]);
           Result:=StringReplace(Result, '@SucceedNetMan', inttostr(SucceedNetMan), [rfReplaceAll, rfIgnoreCase]);
         end;
     4 : begin
           Result:=StringReplace(Result, '@PassTime', PassTime, [rfReplaceAll, rfIgnoreCase]);
         end;
     5 : begin
           Result:=StringReplace(Result, '@BornError', BornError, [rfReplaceAll, rfIgnoreCase]);
         end;
     end;
  end;
end;

//��ʼ��<�澯�ɼ��߳�>�Ĵ�������
procedure InitErrorContent();
begin
  ErrorContentList[1]:='@CurrTime   @CollectionKind-@ErrorSN ���棺<@RunThreadName>���ܲ�������Ϊ�գ���Ӧ��CollectionKind=@CollectionKind����ϵͳ�޷��ԡ�@AlarmKindName�����вɼ������������ò�����Ӧ�������ԣ�';

  ErrorContentList[2]:='@CurrTime   @CollectionKind-@ErrorSN��@collectionname��<@RunThreadName>�ɼ�ʧ�ܣ�([CollectionKind=@CollectionKind][CollectionCode=@CollectionCode])'+char(13)
                      +'                      ���������Ӧ�����Ƿ����������������ܲ��������Ƿ���ȷ(�������ò����������������Ӧ�÷���)��';

  ErrorContentList[3]:='@CurrTime   @CollectionKind-@ErrorSN ����<@RunThreadName>�ɼ���Ϣ��failed-@ErrorNetMan   Succeed-@SucceedNetMan';

  ErrorContentList[4]:='@CurrTime   @CollectionKind-@ErrorSN �ѳɹ�ִ��<@RunThreadName>!  ���βɼ�������ʱ�䣺@PassTime';

  ErrorContentList[5]:='@CurrTime   @CollectionKind-@ErrorSN <@RunThreadName>�ɼ�ʧ��!ԭʼ��Ϣ��@BornError';

  //ErrorContentList[6]:='@CurrTime   @CollectionKind-@ErrorSN ����<@RunThreadName>����Ϣ�����߳�ִ�д�����֪ͨϵͳ����Ա����';
  ErrorContentList[6]:='@CurrTime   @CollectionKind-@ErrorSN ����<@RunThreadName>����Ϣ�������ظ澯���ݿ�����ʧ�ܣ���֪ͨϵͳ����Ա����';
end;

procedure InitSQLVar(ThreadSN:integer);
begin
case ThreadSN of
1:
//******************************************************************************
//UTʵʱ�澯 ThreadSN=1       //070601��jx��� severity�ֶ�
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 13);
  SqlStr[ThreadSN][1]:=' delete from alarm_rt_noarrange_temp ';

  SqlStr[ThreadSN][2]:=' delete from alarm_rt_arrange_temp ';

  SqlStr[ThreadSN][3]:=' select cityid,alarmcontentname from alarm_content_rule where alarmtype=1 and ifineffect=1';

  SqlStr[ThreadSN][4]:=' select a.cityid,a.deviceid,b.alarmcontentname from alarm_realtime_shield a ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' inner join alarm_content_rule b on a.code=b.alarmcontentcode and a.cityid=b.cityid';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' where b.alarmtype=1';

  SqlStr[ThreadSN][5]:=' select cityid, deviceid, contentname, createtime, cleartime, id, collectionkind, collectioncode ,severity from alarm_rt_noarrange_temp';

  SqlStr[ThreadSN][6]:=' select @cityid as cityid,deviceid,trim(contentname) as contentname,createtime,cleartime,id,collectionkind,collectioncode,severity ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from ( ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select source as deviceid, message as contentname,';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' to_date(''1970-01-01 00:00:00'',''yyyy-mm-dd hh24:mi:ss'')+(createtime/1000/3600+8)/24';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' as createtime, cast(decode(cleartime, -1,null ,to_date(''1970-01-01 00:00:00''';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' ,''yyyy-mm-dd hh24:mi:ss'')+(cleartime/1000/3600+8)/24) as date) as cleartime,id,';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' @collectionkind as collectionkind, @collectioncode as collectioncode,severity';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from @tabname ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where entitytype=''CS''';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' ) where createtime+@ForwardDay>=sysdate and createtime+@SetValue/60/24<=sysdate';

  SqlStr[ThreadSN][7]:=' insert into alarm_rt_arrange_temp(cityid, deviceid, contentcode, ISALARM,';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' createtime, id, collectionkind, collectioncode) select a.cityid, a.deviceid, b.alarmcontentcode, ''1''';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' as ISALARM, createtime, id, collectionkind, collectioncode from alarm_rt_noarrange_temp a';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' inner join alarm_content_rule b on a.cityid=b.cityid and b.alarmcontentname=a.contentname ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' where severity <> 5 and (a.cityid,a.deviceid,b.alarmcontentcode)';
 // SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' where cleartime is null and (a.cityid,a.deviceid,b.alarmcontentcode)';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' not in (select cityid,deviceid,contentcode from ALARM_ONLINE_DETAIL_VIEW)';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' order by id';

  SqlStr[ThreadSN][8]:=' insert into alarm_rt_arrange_temp(cityid,deviceid,contentcode,ISALARM,createtime,id, collectionkind, collectioncode) ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select a.cityid,deviceid,contentcode,0 as ISALARM,sysdate as createtime,1 as id, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from ALARM_ONLINE_DETAIL_VIEW a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where alarmtype=1 and ISALARM=1 and (a.cityid,deviceid,contentcode,ISALARM) not in ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' (select a.cityid,a.deviceid,b.alarmcontentcode,case when severity <> 5 then 1 else 0 end as ISALARM ';
  //SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' (select a.cityid,a.deviceid,b.alarmcontentcode,case when cleartime is null then 1 else 0 end as ISALARM ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_rt_noarrange_temp a ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentname=b.alarmcontentname ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where alarmtype=1 ) ';

  SqlStr[ThreadSN][9]:=' delete from alarm_rt_arrange_temp a where rowid not in (select max(rowid) ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from alarm_rt_arrange_temp b where a.cityid=b.cityid and a.deviceid = b.deviceid ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' and a.contentcode = b.contentcode and a.ISALARM = b.ISALARM )';

  SqlStr[ThreadSN][10]:= 'select count(*) as reccount from alarm_rt_arrange_temp';

  SqlStr[ThreadSN][11]:= ' insert into Alarm_Data_Gather (AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode)';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select rownum as AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from (';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select t1.CityID,cast(1 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_1 as CollectID, t1.collectionkind, t1.collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from alarm_rt_arrange_temp t1';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.deviceid=t2.deviceid and t1.ContentCode=t2.ContentCode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' where t1.ISALARM <> t2.ISALARM and t2.AlarmType=1';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' union';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select CityID,cast(1 as number(10)) as AlarmType,deviceid,ContentCode,ISALARM, CreateTime, :NewCollectID_2 as CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from alarm_rt_arrange_temp';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' where ISALARM=1';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' and ((cityid,deviceid,ContentCode) not in (select cityid,deviceid,contentcode from alarm_online_detail_view))';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' )';

  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][8] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';
end;

2:
//******************************************************************************
//UT��·�澯 ThreadSN=2
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 17);
  SqlStr[ThreadSN][1]:=' delete from alarm_line_nosplit_temp ';

  SqlStr[ThreadSN][2]:=' delete from alarm_line_split_temp ';

  SqlStr[ThreadSN][3]:=' select cityid,deviceid,cs_type_mismatch,line1,line2,line3,line4,param_not_down,cs_power_off,';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' cs_blocked,cs_blocked_user,cs_lost_con,slave_cs_not_com,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' from alarm_line_nosplit_temp';

  SqlStr[ThreadSN][4]:=' select @cityid as cityid,moname,CS_TYPE_MISMATCH,line1,line2,line3,line4,PARAM_NOT_DOWN,CS_POWER_OFF,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' CS_BLOCKED,CS_BLOCKED_USER,CS_LOST_CON,SLAVE_CS_NOT_COM,updatetime,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' from @tabname';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' where ( cs_power_off*CS_TYPE_MISMATCH*line1*line2*line3*line4*PARAM_NOT_DOWN';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' *CS_BLOCKED*CS_BLOCKED_USER*SLAVE_CS_NOT_COM*CS_LOST_CON )=0 ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' and updatetime+@ForwardDay>=sysdate ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' order by updatetime';

  SqlStr[ThreadSN][5]:=' delete from alarm_line_nosplit_temp where (CS_TYPE_MISMATCH*line1*line2*line3*line4*PARAM_NOT_DOWN';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' *CS_BLOCKED*CS_BLOCKED_USER*SLAVE_CS_NOT_COM*CS_LOST_CON)<>0 and cs_power_off = 0 ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' and (cityid,deviceid) not in ( select cityid,deviceid from alarm_device_info )';

  SqlStr[ThreadSN][6]:=' insert into alarm_line_split_temp (cityid,deviceid,ISALARM,contentcode,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid,a.deviceid,b.ISALARM,a.contentcode,a.createtime, collectionkind, collectioncode ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from (';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,CS_TYPE_MISMATCH as alarmstatus,cast(13 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(01)-13 ��վ���Ͳ�һ��
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,line1 as alarmstatus,cast(20 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(02)-20 ��һ���߶�
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,line2 as alarmstatus,cast(21 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(03)-21 �ڶ����߶�
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,line3 as alarmstatus,cast(22 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(04)-22 �������߶�
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,line4 as alarmstatus,cast(23 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(05)-23 ���Ķ��߶�
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,PARAM_NOT_DOWN as alarmstatus,cast(24 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(06)-24 ��վ����δ����
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,SLAVE_CS_NOT_COM as alarmstatus,cast(25 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(07)-25 �ӻ�վ����
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,CS_POWER_OFF as alarmstatus,cast(26 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(08)-26 ��վ�ϵ�
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,CS_BLOCKED as alarmstatus,cast(27 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(09)-27 ��վ����
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,CS_BLOCKED_USER as alarmstatus,cast(28 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(10)-28 ��վ��Ϊ����
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,CS_LOST_CON as alarmstatus,cast(29 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp ';   //--(11)-29 ��վʧȥ����
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid,a.deviceid,to_char(decode(decode(c.linenum,2,line1+line2,line1+line2+line3+line4),0,0,1)) as alarmstatus, ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' cast(44 as number) as contentcode,createtime, collectionkind, collectioncode ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp a, fms_device_info b, pop_cstype c '; //--(12)-44 ��վͣ��
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where a.cityid=b.cityid(+) and a.deviceid=b.deviceid(+) ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' and b.cstypeid=c.id(+) ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid,a.deviceid,to_char(decode(decode(c.linenum,2,line1+line2+CS_BLOCKED+CS_POWER_OFF+CS_LOST_CON,line1+line2+decode(line3,0,0,1)+decode(line4,0,0,1)+CS_BLOCKED+CS_POWER_OFF+CS_LOST_CON),0,0,1)) as alarmstatus, ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' cast(45 as number) as contentcode,createtime, collectionkind, collectioncode ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_line_nosplit_temp a, fms_device_info b, pop_cstype c '; //--(13)-45 ��վ��׼ͣ��
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where a.cityid=b.cityid(+) and a.deviceid=b.deviceid(+) ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' and b.cstypeid=c.id(+) ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' ) a inner join alarm_content_status_list b on a.cityid=b.cityid and a.contentcode=b.contentcode and a.alarmstatus=b.alarmstatus';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' inner join alarm_content_rule c on a.cityid=c.cityid and a.contentcode=c.alarmcontentcode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where c.ifineffect=1';

  SqlStr[ThreadSN][7]:=' insert into alarm_line_split_temp(cityid,deviceid,contentcode,ISALARM,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' select a.cityid,a.deviceid, a.contentcode, 0 as ISALARM, sysdate as createtime, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' from alarm_online_detail_view a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' where a.alarmtype=2 and a.ISALARM=1 and (a.cityid,deviceid) not in ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' (select cityid,deviceid from alarm_line_nosplit_temp) ';

  SqlStr[ThreadSN][8]:=' delete from alarm_line_split_temp a where rowid not in (select max(rowid) ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_line_split_temp b where a.cityid=b.cityid and a.deviceid = b.deviceid ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' and a.contentcode = b.contentcode and a.ISALARM = b.ISALARM )';

  //����С���վ��׼ͣ�硱��45���澯��������(20,21,22,23,26,27,29,44)
  //��һ�����������Ķ��߶ϣ���վ�ϵ磬��վ��������վʧȥ����,��վͣ��
  SqlStr[ThreadSN][9]:=' delete from alarm_line_split_temp a where contentcode in (20,21,22,23,26,27,29,44) and ISALARM=1 and exists';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' (select * from alarm_line_split_temp where contentcode=45 and ISALARM=1 and cityid=a.cityid and deviceid=a.deviceid)';

  SqlStr[ThreadSN][10]:=' select count(*) as reccount from alarm_line_split_temp';

  SqlStr[ThreadSN][11]:=' insert into Alarm_Data_Gather (AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode)';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select rownum as AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from (';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select t1.CityID,cast(2 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_1 as CollectID, t1.collectionkind, t1.collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from alarm_line_split_temp t1';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.deviceid=t2.deviceid and t1.ContentCode=t2.ContentCode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' where t1.ISALARM <> t2.ISALARM and t2.AlarmType=2 ';//and t1.cityid=@cityid';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' union ';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select t3.CityID,cast(2 as number(10)) as AlarmType,t3.deviceid,t3.ContentCode,t3.ISALARM, t3.CreateTime, :NewCollectID_2 as CollectID, t3.collectionkind, t3.collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from Alarm_UTline_look_list t3';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' where t3.ISALARM=1 and @SetValue/24/60+t3.createtime<=sysdate ';//and t3.cityid=@cityid';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' and ((t3.cityid,t3.deviceid,t3.ContentCode) not in (select cityid,deviceid,contentcode from alarm_online_detail_view))';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' )';

  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][7] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';

  SqlStr[ThreadSN][13]:=' insert into Alarm_UTline_look_list(cityid,deviceid,contentcode,ISALARM,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' select cityid,deviceid,contentcode,ISALARM,sysdate, collectionkind, collectioncode' ;
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' from alarm_line_split_temp t1';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' where t1.ISALARM=1 and (t1.cityid,t1.deviceid,t1.contentcode) not in ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' (select cityid,deviceid,contentcode from alarm_online_detail_look_view where ISALARM=1)' ;

  SqlStr[ThreadSN][14]:= ' delete from alarm_utline_look_list t ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' where (t.cityid,t.deviceid,t.contentcode) not in';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' (select cityid,deviceid,contentcode from alarm_line_split_temp where ISALARM=1 )';

  SqlStr[ThreadSN][15]:= ' delete from alarm_utline_look_list t ';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' where t.createtime+@SetValue/24/60<=sysdate ';

  SqlStr[ThreadSN][16]:= ' delete from alarm_utline_look_list t ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' where (t.cityid,t.deviceid,t.contentcode) in';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' (select cityid,deviceid,contentcode from ALARM_ONLINE_DETAIL_VIEW)';

end;

3:
//******************************************************************************
//UT���վ״̬�澯 ThreadSN=3
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 11);
  SqlStr[ThreadSN][1]:=' delete from alarm_oh_nosplit_temp ';

  SqlStr[ThreadSN][2]:=' delete from alarm_oh_split_temp ';

  SqlStr[ThreadSN][3]:=' select cityid, deviceid, PLLFAILURE, MEMORYFAILURE,	TRANSPOWERALARM, SYNCLOST, CCHLOST,';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' CCHANNELBLOCK,createtime, collectionkind, collectioncode,';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' linecircuit1_2,linecircuit3_4,linecircuit5_6,linecircuit7_8';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' from alarm_oh_nosplit_temp';

  SqlStr[ThreadSN][4]:=' select @cityid as cityid, moname, PLLFAILURE, MEMORYFAILURE,	TRANSPOWERALARM, SYNCLOST, CCHLOST,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' CCHANNELBLOCK,updatetime,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' @collectionkind as collectionkind, @collectioncode as collectioncode,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' case when 2 in (linecircuit1,linecircuit2) then 1 else 0 end as linecircuit1_2,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' case when 2 in (linecircuit3,linecircuit4) then 1 else 0 end as linecircuit3_4,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' case when 2 in (linecircuit5,linecircuit6) then 1 else 0 end as linecircuit5_6,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' case when 2 in (linecircuit7,linecircuit8) then 1 else 0 end as linecircuit7_8 ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' from @tabname';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' where (( PLLFAILURE + MEMORYFAILURE + TRANSPOWERALARM + SYNCLOST + CCHLOST + CCHANNELBLOCK)>0 or ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' 2 in (linecircuit1,linecircuit2,linecircuit3,linecircuit4,linecircuit5,linecircuit6,linecircuit7,linecircuit8)) ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' and updatetime+@ForwardDay>=sysdate ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' order by updatetime';

  SqlStr[ThreadSN][5]:='insert into alarm_oh_split_temp (cityid,deviceid,ISALARM,contentcode,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select a.cityid,a.deviceid,b.ISALARM,a.contentcode,a.createtime, collectionkind, collectioncode ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from (';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,PLLFAILURE as alarmstatus,cast(51 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(01)-51 ���໷�澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,MEMORYFAILURE as alarmstatus,cast(52 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(02)-52 �ڴ����
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,TRANSPOWERALARM as alarmstatus,cast(53 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(03)-53 ���书�ʸ澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,SYNCLOST as alarmstatus,cast(54 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(04)-54 �����ŵ�ͬ����ʧ�澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,CCHLOST as alarmstatus,cast(55 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(05)-55 �޷���������ŵ��澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,CCHANNELBLOCK as alarmstatus,cast(56 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(06)-56 �����ŵ�����
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,linecircuit1_2 as alarmstatus,cast(50 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(07)-50 ��һ����ҵ���ŵ�����
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,linecircuit3_4 as alarmstatus,cast(57 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(08)-57 �ڶ�����ҵ���ŵ�����
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,linecircuit5_6 as alarmstatus,cast(58 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(09)-58 ��������ҵ���ŵ�����
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,linecircuit7_8 as alarmstatus,cast(59 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_oh_nosplit_temp ';   //--(10)-59 ���Ķ���ҵ���ŵ�����
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ) a inner join alarm_content_status_list b on a.cityid=b.cityid and a.contentcode=b.contentcode and a.alarmstatus=b.alarmstatus';

  SqlStr[ThreadSN][6]:=' insert into alarm_oh_split_temp(cityid,deviceid,contentcode,ISALARM,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid, a.deviceid, a.contentcode, 0 as ISALARM, sysdate as createtime, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_online_detail_view a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where a.alarmtype=3 and ISALARM=1 and (a.cityid,deviceid) not in ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' (select cityid,deviceid from alarm_oh_nosplit_temp) ';

  SqlStr[ThreadSN][7]:=' delete from alarm_oh_split_temp where (cityid,contentcode) in (';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' select cityid,alarmcontentcode from alarm_content_rule where ifineffect=0 )';

  SqlStr[ThreadSN][8]:=' select count(*) as reccount from alarm_oh_split_temp';

  SqlStr[ThreadSN][9]:=' insert into Alarm_Data_Gather (AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode)';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select rownum as AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from (';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select t1.CityID,cast(3 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_1 as CollectID, t1.collectionkind, t1.collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from alarm_oh_split_temp t1';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.deviceid=t2.deviceid and t1.ContentCode=t2.ContentCode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where t1.ISALARM <> t2.ISALARM and t2.AlarmType=3';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' union ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select t1.CityID,cast(3 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_2 as CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from alarm_oh_split_temp t1';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where t1.ISALARM=1';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' and ((cityid,t1.deviceid,t1.ContentCode) not in (select cityid,deviceid,contentcode from alarm_online_detail_view))';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' )';

  SqlStr[ThreadSN][10]:=SqlStr[ThreadSN][6] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';
end;

4:
//******************************************************************************
//UTС��վ״̬�澯 ThreadSN=4
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 11);
  SqlStr[ThreadSN][1]:=' delete from alarm_rp_nosplit_temp ';

  SqlStr[ThreadSN][2]:=' delete from alarm_rp_split_temp ';

  SqlStr[ThreadSN][3]:=' select cityid, deviceid, blockofauto, blockofmaint, blockoffault, alarmofif, alarmoftrans,';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' alarmofsync, alarmofline, alarmofdl, alarmofrp, cchlost, createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' from alarm_rp_nosplit_temp';

  SqlStr[ThreadSN][4]:=' select @cityid as cityid, moname, blockofauto, blockofmaint, blockoffault, alarmofif, alarmoftrans, alarmofsync,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' alarmofline, alarmofdl, alarmofrp, cchlost, updatetime,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' from @tabname';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' where ( blockofauto + blockofmaint + blockoffault + alarmofif + alarmoftrans +';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' alarmofsync + alarmofline + alarmofdl + alarmofrp + cchlost )>0';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' and updatetime+@ForwardDay>=sysdate';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' order by updatetime';

  SqlStr[ThreadSN][5]:='insert into alarm_rp_split_temp (cityid,deviceid,ISALARM,contentcode,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select a.cityid,a.deviceid,b.ISALARM,a.contentcode,a.createtime, collectionkind, collectioncode ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from (';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,blockofauto as alarmstatus,cast(60 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(01)-60 �Զ�����
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,blockofmaint as alarmstatus,cast(61 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(02)-61 ά������
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,blockoffault as alarmstatus,cast(62 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(03)-62 ��������
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,alarmofif as alarmstatus,cast(63 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(04)-63 �ӿڸ澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,alarmoftrans as alarmstatus,cast(64 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(05)-64 ���书�ʸ澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,alarmofsync as alarmstatus,cast(65 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(06)-65 �ϳ����澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,alarmofline as alarmstatus,cast(66 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(07)-66 ��·�澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,alarmofdl as alarmstatus,cast(67 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(08)-67 �������ظ澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,alarmofrp as alarmstatus,cast(68 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(09)-68 ������Դ�澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select cityid,deviceid,cchlost as alarmstatus,cast(69 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_rp_nosplit_temp ';   //--(10)-69 �����ŵ�ͬ����ʧ�澯
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ) a inner join alarm_content_status_list b on a.cityid=b.cityid and a.contentcode=b.contentcode and a.alarmstatus=b.alarmstatus';

  //--���������û���ҵ������ϵĶ�Ӧ��clear�澯����Ĭ��Ϊ������--06.08.31���
  SqlStr[ThreadSN][6]:=' insert into alarm_rp_split_temp(cityid,deviceid,contentcode,ISALARM,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid, a.deviceid, a.contentcode, 0 as ISALARM, sysdate as createtime, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_online_detail_view a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where a.alarmtype=4 and a.ISALARM=1 and (a.cityid,deviceid) not in ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' (select cityid,deviceid from alarm_rp_nosplit_temp) ';

  SqlStr[ThreadSN][7]:=' delete from alarm_rp_split_temp where (cityid,contentcode) in (';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' select cityid,alarmcontentcode from alarm_content_rule where ifineffect=0 )';

  SqlStr[ThreadSN][8]:=' select count(*) as reccount from alarm_rp_split_temp';

  SqlStr[ThreadSN][9]:=' insert into Alarm_Data_Gather (AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode)';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select rownum as AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from (';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select t1.CityID,cast(4 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_1 as CollectID, t1.collectionkind, t1.collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from alarm_rp_split_temp t1';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.deviceid=t2.deviceid and t1.ContentCode=t2.ContentCode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where t1.ISALARM <> t2.ISALARM and t2.AlarmType=4';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' union ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select CityID,cast(4 as number(10)) as AlarmType,deviceid,ContentCode,ISALARM, CreateTime, :NewCollectID_2 as CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from alarm_rp_split_temp';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where ISALARM=1';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' and ((CityID,deviceid,ContentCode) not in (select CityID,deviceid,contentcode from alarm_online_detail_view))';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' )';

  SqlStr[ThreadSN][10]:=SqlStr[ThreadSN][6] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';
end;

5:
//******************************************************************************
//����ʵʱ�澯 ThreadSN=5
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 12);
  SqlStr[ThreadSN][1]:='delete from alarm_ztert_noarrange_temp';

  SqlStr[ThreadSN][2]:='delete from alarm_ztert_arrange_temp';

  SqlStr[ThreadSN][3]:='select cityid, deviceid, contentcode, alarmstatus, createtime, id, collectionkind, collectioncode from alarm_ztert_noarrange_temp';

  SqlStr[ThreadSN][4]:=' select @cityid as cityid,cast(Neno as varchar)+'+''''+'-'+''''+'+cast(unitno as varchar)+'+''''+'-'+'''';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' +cast(sunitno as varchar)+'+''''+'-'+''''+'+cast(csindex as varchar) as deviceid,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' almvalue as contentcode, RestoreFlag as alarmstatus, almtime as CreateTime, LogID as ID,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' from @tabname';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' where equiptype=4 and almtime>=GETDATE()-@ForwardDay and dateadd(minute,@SetValue,almtime)<=GETDATE()';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' order by Neno,unitno,sunitno,csindex,almvalue ';

  SqlStr[ThreadSN][5]:=' insert into alarm_ztert_arrange_temp(cityid,deviceid,contentcode,ISALARM,createtime,id, collectionkind, collectioncode) ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select a.cityid,a.deviceid,a.contentcode,c.ISALARM,a.createtime,a.id, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_ztert_noarrange_temp a';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' inner join alarm_content_rule b on a.cityid =b.cityid and a.contentcode=b.alarmcontentcode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' inner join alarm_content_status_list c on a.cityid=c.cityid and a.contentcode=c.contentcode and a.alarmstatus=c.alarmstatus ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' where b.ifineffect=1 and (a.cityid,a.deviceid,a.contentcode,c.ISALARM) not in  ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' (select cityid,deviceid,contentcode,ISALARM from ALARM_ONLINE_DETAIL_VIEW) ';

  SqlStr[ThreadSN][6]:=' insert into alarm_ztert_arrange_temp(cityid,deviceid,contentcode,ISALARM,createtime,id, collectionkind, collectioncode) ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid,deviceid,contentcode,0 as ISALARM,sysdate as createtime,null as id, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from ALARM_ONLINE_DETAIL_VIEW a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where alarmtype=6 and ISALARM=1 and (a.cityid,deviceid,contentcode,ISALARM) not in ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' (select a.cityid,a.deviceid,a.contentcode,b.ISALARM from alarm_ztert_noarrange_temp a ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' inner join alarm_content_status_list b on a.cityid=b.cityid and a.contentcode=b.contentcode and a.alarmstatus=b.alarmstatus )';

  SqlStr[ThreadSN][7] := 'select count(*) as reccount from alarm_ztert_arrange_temp';

  SqlStr[ThreadSN][8]:=' insert into Alarm_Data_Gather ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' (AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode)';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select rownum as AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from (';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select t1.CityID,cast(6 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_1 as CollectID, t1.collectionkind, t1.collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_ztert_arrange_temp t1';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.deviceid=t2.deviceid and t1.ContentCode=t2.ContentCode ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where t1.ISALARM <> t2.ISALARM and t2.AlarmType=6 ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' union ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select CityID,cast(6 as number(10)) as AlarmType,deviceid,ContentCode,ISALARM, CreateTime, :NewCollectID_2 as CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_ztert_arrange_temp ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where ISALARM=1 and ((cityid,deviceid,ContentCode) ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' not in (select cityid,deviceid,contentcode from alarm_online_detail_view)) ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' )';

  //����ANU��վ�澯���ݲɼ����
  SqlStr[ThreadSN][9]:=' select @cityid as cityid,cast(Neno as varchar)+'+''''+'-'+''''+'+cast(cscno as varchar)+'+''''+'-0-'+'''';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' +cast(csindex as varchar) as deviceid,';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' 500+almvalue as contentcode, RestoreFlag as alarmstatus, almtime as CreateTime, LogID as ID,';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';  
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from @tabname';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where equiptype=3 and almtime>=GETDATE()-@ForwardDay and dateadd(minute,@SetValue,almtime)<=GETDATE()';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' order by NeNo,cscno,CSIndex';

  SqlStr[ThreadSN][10]:=' select count(*) as reccount from sysobjects where id = object_id(''curralmlog'')';//����ANU��վʵʱ�澯ԭ��

  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][6] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';
end;

6:
//******************************************************************************
//����״̬�澯 ThreadSN=6
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 14);
  SqlStr[ThreadSN][1]:='delete from alarm_zteoh_nosplit_List';

  SqlStr[ThreadSN][2]:='delete from alarm_zteoh_split_temp';

  SqlStr[ThreadSN][3]:=' select cityid, deviceid, upcount, upstate1, upstate2, upstate3, upstate4, upstate5, upstate6,';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' upstate7, upstate8, svrstate, ';
       //SynState qiusy 1024
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' SEVRSTATE,SynState,USTATE1,USTATE2,USTATE3,USTATE4 ,';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' threesyn,foursyn, nosyn, upstate, createtime, Identification, collectionkind, collectioncode';
  SqlStr[ThreadSN][3]:=SqlStr[ThreadSN][3] + ' from alarm_zteoh_nosplit_List';

  //����iCSC��վ�澯���ݲɼ����
  SqlStr[ThreadSN][4]:=' select @cityid as cityid,cast(Neno_b as varchar)+'+''''+'-'+''''+'+cast(unit as varchar)+'+''''+'-'+'''';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' +cast(sunit as varchar)+'+''''+'-'+''''+'+cast(csindex as varchar) as deviceid,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when cstype in (0,1,3,7,11) then 2 when cstype in (2,4,5,8,10,13) then 4 else 8 end as tinyint) as upcount,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate1 in (1,5) then 1 when upstate1=255 then null else 0 end as tinyint) as upstate1,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate2 in (1,5) then 1 when upstate2=255 then null else 0 end as tinyint) as upstate2,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate3 in (1,5) then 1 when upstate3=255 then null else 0 end as tinyint) as upstate3,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate4 in (1,5) then 1 when upstate4=255 then null else 0 end as tinyint) as upstate4,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate5 in (1,5) then 1 when upstate5=255 then null else 0 end as tinyint) as upstate5,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate6 in (1,5) then 1 when upstate6=255 then null else 0 end as tinyint) as upstate6,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate7 in (1,5) then 1 when upstate7=255 then null else 0 end as tinyint) as upstate7,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate8 in (1,5) then 1 when upstate8=255 then null else 0 end as tinyint) as upstate8,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case SvrState when 0 then 1 else 0 end as tinyint) as SvrState,';
  //qiusy  1024 ��ӻ�վ��Ӫ״̬\֡ͬ��״̬\U��״̬�ɼ�
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when SvrState=0 then 1 when SvrState=1 then 2 when SvrState=2 then 3 else 4 end as tinyint) as SevrState,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(FrmSynState as tinyint) as SynState,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate1=0 then 1 when upstate1=1 then 2 when upstate1=2 then 3 when upstate1=3 then 4 when upstate1=4 then 5 when upstate1=5 then 6 else 7 end as tinyint) as ustate1,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate2=0 then 1 when upstate2=1 then 2 when upstate2=2 then 3 when upstate2=3 then 4 when upstate2=4 then 5 when upstate2=5 then 6 else 7 end as tinyint) as ustate2,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate3=0 then 1 when upstate3=1 then 2 when upstate3=2 then 3 when upstate3=3 then 4 when upstate3=4 then 5 when upstate3=5 then 6 else 7 end as tinyint) as ustate3,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case when upstate4=0 then 1 when upstate4=1 then 2 when upstate4=2 then 3 when upstate4=3 then 4 when upstate4=4 then 5 when upstate4=5 then 6 else 7 end as tinyint) as ustate4,';
  ///////////////////////////////////////////
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case FrmSynState when 11 then 0 else 1 end as tinyint) as ThreeSyn,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case FrmSynState when 12 then 0 else 1 end as tinyint) as FourSyn,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(case FrmSynState when 13 then 0 else 1 end as tinyint) as NoSyn,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' cast(';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' case when cstype IN (0,1,3,7,11) then case when (UPState1 % 83) * (UPState2 % 83) = 5 then 1 else 0 end';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + '      when cstype IN (2,4,5,8,10,13) then case when (((UPState1 % 83) * (UPState2 % 83) * (UPState3 % 83)) % 83) * (UPState4 % 83) = 5 then 1 else 0 end';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + '      when cstype IN (6,9) then case when (((UPState1 % 83) * (UPState2 % 83) * (UPState3 % 83)) % 83) * (((UPState4 % 83) *  (UPState5 % 83) * (UPState6 % 83)) % 83) * (((UPState7 % 83) * (UPState8 % 83)) % 83) = 5 then 1 else 0 end';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' else 2 end as tinyint) as UPState, getdate() as createtime,3 as Identification,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' from @tabname';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' order by NeNo_b,Unit,Sunit,CSIndex';

  SqlStr[ThreadSN][5]:=' insert into alarm_zteoh_split_temp(cityid,deviceid,contentcode,ISALARM,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select a.cityid, deviceid, contentcode, 0 as ISALARM, sysdate as createtime, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_online_detail_view a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' where alarmtype=7 and ISALARM=1 and (a.cityid,deviceid) not in ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' (select cityid,deviceid from alarm_zteoh_nosplit_List) ';

  SqlStr[ThreadSN][6]:=' insert into alarm_zteoh_split_temp (cityid,deviceid,ISALARM,contentcode,createtime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid, a.deviceid, b.ISALARM, a.contentcode, a.createtime, collectionkind, collectioncode from ( ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate as alarmstatus,cast(550 as number(10)) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(01)-550 U��״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate1 as alarmstatus,cast(551 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(02)-551 U��1״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate2 as alarmstatus,cast(552 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(03)-552 U��2״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate3 as alarmstatus,cast(553 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(04)-553 U��3״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate4 as alarmstatus,cast(554 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(05)-554 U��4״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate5 as alarmstatus,cast(555 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(06)-555 U��5״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate6 as alarmstatus,cast(556 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(07)-556 U��6״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate7 as alarmstatus,cast(557 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(08)-557 U��7״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,upstate8 as alarmstatus,cast(558 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(09)-558 U��8״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,SvrState as alarmstatus,cast(559 as number) as contentcode,createtime, collectionkind, collectioncode' ;
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(10)-559 ��Ӫ״̬�澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,ThreeSyn as alarmstatus,cast(560 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(11)-560 ����ͬ���澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,FourSyn as alarmstatus,cast(561 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(12)-561 �ļ�ͬ���澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,deviceid,NoSyn as alarmstatus,cast(562 as number) as contentcode,createtime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_zteoh_nosplit_List ';   //--(13)-562 ��ͬ���澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' ) a inner join alarm_content_status_list b on a.cityid=b.cityid and a.contentcode=b.contentcode ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' and a.alarmstatus=b.alarmstatus where a.alarmstatus is not null';

  SqlStr[ThreadSN][7]:=' delete from alarm_zteoh_split_temp where (cityid,contentcode) in ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' (select cityid,alarmcontentcode from alarm_content_rule where ifineffect=0 )';

  SqlStr[ThreadSN][8] := 'select count(*) as reccount from alarm_zteoh_split_temp';

  SqlStr[ThreadSN][9]:=' insert into Alarm_Data_Gather ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' (AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode)';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select rownum as AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from (';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select t1.CityID,cast(7 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_1 as CollectID, t1.collectionkind, t1.collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from alarm_zteoh_split_temp t1';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.deviceid=t2.deviceid and t1.ContentCode=t2.ContentCode ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where t1.ISALARM <> t2.ISALARM and t2.AlarmType=7 ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' union';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select CityID,cast(7 as number(10)) as AlarmType,deviceid,ContentCode,ISALARM, CreateTime, :NewCollectID_2 as CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from alarm_zteoh_split_temp ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where ISALARM=1 and ((cityid,deviceid,ContentCode) ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' not in (select cityid,deviceid,contentcode from alarm_online_detail_view)) ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' )';

  SqlStr[ThreadSN][10]:=' update alarm_zteoh_nosplit_List set Identification=0 ';

  SqlStr[ThreadSN][11]:=' select count(*) as reccount from sysobjects where id = object_id(''csinfo'')'; //����ANU��վ״̬�澯ԭ��

  //����ANU��վ�澯���ݲɼ����
  SqlStr[ThreadSN][12]:=' select @cityid as cityid,cast(Neno as varchar)+'+''''+'-'+''''+'+cast(cscno as varchar)+'+''''+'-0-'+'''';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' +cast(csindex as varchar) as deviceid,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when cstype in (0,1,3,7,11) then 2 when cstype in (2,4,5,8,10,13) then 4 else 8 end as tinyint) as upcount,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when upstate1 in (1,5) then 1 when upstate1 is null then null else 0 end as tinyint) as upstate1,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when upstate2 in (1,5) then 1 when upstate2 is null then null else 0 end as tinyint) as upstate2,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when cstype not in (0,1,3,7,11) then case when upstate3 in (1,5) then 1 when upstate3 is null then null else 0 end else null end as tinyint) as upstate3,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when cstype not in (0,1,3,7,11) then case when upstate4 in (1,5) then 1 when upstate4 is null then null else 0 end else null end as tinyint) as upstate4,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when cstype not in (0,1,3,7,11,2,4,5,8,10,13) then case when upstate5 in (1,5) then 1 when upstate5 is null then null else 0 end else null end as tinyint) as upstate5,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when cstype not in (0,1,3,7,11,2,4,5,8,10,13) then case when upstate6 in (1,5) then 1 when upstate6 is null then null else 0 end else null end as tinyint) as upstate6,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when cstype not in (0,1,3,7,11,2,4,5,8,10,13) then case when upstate7 in (1,5) then 1 when upstate7 is null then null else 0 end else null end as tinyint) as upstate7,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when cstype not in (0,1,3,7,11,2,4,5,8,10,13) then case when upstate8 in (1,5) then 1 when upstate8 is null then null else 0 end else null end as tinyint) as upstate8,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case SvrState when 0 then 1 else 0 end as tinyint) as SvrState,';
    //qiusy  1024 ��ӻ�վ��Ӫ״̬\֡ͬ��״̬\U��״̬�ɼ�
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when SvrState=0 then 1 when SvrState=1 then 2 when SvrState=2 then 3 else 4 end as tinyint) as SevrState,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(FrmSynState as tinyint) as SynState,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when upstate1=0 then 1 when upstate1=1 then 2 when upstate1=2 then 3 when upstate1=3 then 4 when upstate1=4 then 5 when upstate1=5 then 6 else 7 end as tinyint) as ustate1,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when upstate2=0 then 1 when upstate2=1 then 2 when upstate2=2 then 3 when upstate2=3 then 4 when upstate2=4 then 5 when upstate2=5 then 6 else 7 end as tinyint) as ustate2,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when upstate3=0 then 1 when upstate3=1 then 2 when upstate3=2 then 3 when upstate3=3 then 4 when upstate3=4 then 5 when upstate3=5 then 6 else 7 end as tinyint) as ustate3,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case when upstate4=0 then 1 when upstate4=1 then 2 when upstate4=2 then 3 when upstate4=3 then 4 when upstate4=4 then 5 when upstate4=5 then 6 else 7 end as tinyint) as ustate4,';
  ///////////////////////////////////////////

  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case FrmSynState when 11 then 0 else 1 end as tinyint) as ThreeSyn,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case FrmSynState when 12 then 0 else 1 end as tinyint) as FourSyn,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(case FrmSynState when 13 then 0 else 1 end as tinyint) as NoSyn,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' cast(';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' case when cstype IN (0,1,3,7,11) then case when (UPState1 % 83) * (UPState2 % 83) = 5 then 1 else 0 end';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + '      when cstype IN (2,4,5,8,10,13) then case when (((UPState1 % 83) * (UPState2 % 83) * (UPState3 % 83)) % 83) * (UPState4 % 83) = 5 then 1 else 0 end';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + '      when cstype IN (6,9) then case when (((UPState1 % 83) * (UPState2 % 83) * (UPState3 % 83)) % 83) * (((UPState4 % 83) *  (UPState5 % 83) * (UPState6 % 83)) % 83) * (((UPState7 % 83) * (UPState8 % 83)) % 83) = 5 then 1 else 0 end';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' else 2 end as tinyint) as UPState, getdate() as createtime,3 as Identification,';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' from @tabname';
  SqlStr[ThreadSN][12]:=SqlStr[ThreadSN][12] + ' order by NeNo,cscno,CSIndex';

  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][5] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';
end;

7:
//******************************************************************************
//��Ѷʵʱ�澯 ThreadSN=7
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 20);
  SqlStr[ThreadSN][1]:='delete from alarm_Lurt_noarrange_temp';

  SqlStr[ThreadSN][2]:='delete from alarm_Lurt_arrange_temp';

  SqlStr[ThreadSN][3]:='select cityid, deviceid, contentcode, alarmstatus, createtime, id,CS_DN,LineCount, collectionkind, collectioncode from alarm_Lurt_noarrange_temp';

  SqlStr[ThreadSN][4]:=' select @cityid as cityid,rtrim(ltrim(b.CS_TAG)) as deviceid,a.alarmdefineid+200 as contentcode,cast(0 as integer) as alarmstatus, ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' occurTime as CreateTime, SequenceID as ID,CS_DN,case when cs_channelnum in (3,4) then 2 else 4 end as LineCount,';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' from alarmcurrent a ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' inner join @tabname b on a.id=b.id';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' where occurTime+@ForwardDay>=GETDATE() and occurTime+@SetValue/60/24<=GETDATE()';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' order by b.CS_TAG,a.id ';

  SqlStr[ThreadSN][5]:=' insert into alarm_Lurt_arrange_temp(cityid,deviceid,contentcode,ISALARM,createtime,id, collectionkind, collectioncode) ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select a.cityid,a.deviceid,a.contentcode,c.ISALARM,a.createtime,a.id, collectionkind, collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_Lurt_noarrange_temp a';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' inner join alarm_content_status_list c on a.cityid=c.cityid and a.contentcode=c.contentcode and a.alarmstatus=c.alarmstatus ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' where b.ifineffect=1 and (a.cityid,a.deviceid,a.contentcode,c.ISALARM) not in  ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' (select cityid,deviceid,contentcode,ISALARM from ALARM_ONLINE_DETAIL_VIEW) ';

  SqlStr[ThreadSN][6]:=' insert into alarm_Lurt_arrange_temp(cityid,deviceid,contentcode,ISALARM,createtime,id, collectionkind, collectioncode) ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid,deviceid,contentcode,0 as ISALARM,sysdate as createtime,null as id, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from ALARM_ONLINE_DETAIL_VIEW a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where alarmtype=8 and ISALARM=1 and (a.cityid,deviceid,contentcode,ISALARM) not in ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' (select a.cityid,a.deviceid,a.contentcode,b.ISALARM from alarm_Lurt_noarrange_temp a ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' inner join alarm_content_status_list b on a.cityid=b.cityid and a.contentcode=b.contentcode and a.alarmstatus=b.alarmstatus ) ';

  SqlStr[ThreadSN][7] := 'select count(*) as reccount from alarm_Lurt_arrange_temp';

  SqlStr[ThreadSN][8]:=' insert into Alarm_Data_Gather ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' (AlarmAutoid,cityid,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode)';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select rownum as AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from (';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select t1.cityid,cast(8 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_1 as CollectID, t1.collectionkind, t1.collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_Lurt_arrange_temp t1';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.deviceid=t2.deviceid and t1.ContentCode=t2.ContentCode ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where t1.ISALARM <> t2.ISALARM and t2.AlarmType=8';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' union ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select cityid,cast(11 as number(10)) as AlarmType,deviceid,ContentCode,0 as ISALARM, sysdate as CreateTime, :NewCollectID_2 as CollectID, collectionkind, collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_online_detail_view ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where AlarmType=11 and ((cityid,deviceid) ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' not in (select cityid,deviceid from alarm_lurt_state_list)) ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' union ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select a.cityid,cast(8 as number(10)) as AlarmType,a.deviceid,a.ContentCode,a.ISALARM, a.CreateTime, :NewCollectID_3 as CollectID, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_Lurt_arrange_temp a';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode';
  //SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where a.ISALARM=1 and b.sendtype<>1 and b.ifineffect=1 and (a.cityid,a.deviceid,a.contentcode,a.ISALARM) not in';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where a.ISALARM=1 and b.alarmcontentcode not in (246,224,214,215) and b.ifineffect=1 and (a.cityid,a.deviceid,a.contentcode,a.ISALARM) not in';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' (select cityid,deviceid,contentcode,ISALARM from alarm_online_detail_view where AlarmType=8)';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' )';

  SqlStr[ThreadSN][9]:=' select count(*) as reccount from sysobjects where id = object_id(''CsMainAll'')';

  SqlStr[ThreadSN][10]:=SqlStr[ThreadSN][6] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';

  SqlStr[ThreadSN][11]:=' delete from alarm_lulinetest_state_temp ';

  SqlStr[ThreadSN][12]:=' select cityid, cs_tag, cs_dn, faulttime, LineCount, collectionkind, collectioncode from alarm_lulinetest_state_temp ';

  SqlStr[ThreadSN][13]:=' select @CityID as cityid, rtrim(ltrim(b.CS_TAG)) as cs_tag, b.CS_DN, a.logtime as faulttime, case when cs_channelnum in (3,4) then 2 else 4 end as LineCount, ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' from CSService a, @tabname b ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' where a.id=b.id and a.StaService>0 and a.logtime>=GETDATE()-@ForwardDay and dateadd(minute,@SetValue,a.logtime)<=GETDATE() ';

  SqlStr[ThreadSN][14]:=' insert into alarm_Lurt_state_list(cityid,deviceid,contentcode,ISALARM,createtime,id, collectionkind, collectioncode,CS_DN,LineCount) ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' select t1.cityid,t1.deviceid,t1.contentcode,t1.ISALARM,t1.createtime,t1.id,t1.collectionkind, t1.collectioncode,t1.CS_DN,t1.LineCount';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' from (';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' select a.cityid,a.deviceid,a.contentcode,c.ISALARM,a.createtime,a.id, collectionkind, collectioncode,CS_DN,LineCount';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' from alarm_Lurt_noarrange_temp a';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' inner join alarm_content_status_list c on a.cityid=c.cityid and a.contentcode=c.contentcode and a.alarmstatus=c.alarmstatus ';
  //SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' where b.ifineffect=1 and b.sendtype=1 and c.ISALARM=1 and (a.cityid,a.deviceid,a.contentcode,c.ISALARM) not in  ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' where b.ifineffect=1 and b.alarmcontentcode in (246,224,214,215) and c.ISALARM=1 and (a.cityid,a.deviceid,a.contentcode,c.ISALARM) not in  ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' (select cityid,deviceid,contentcode,ISALARM from alarm_Lurt_state_list) ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' union ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' select cityid,cs_tag as deviceid,0 as contentcode,1 as ISALARM,faulttime as createtime,1 as id, collectionkind, collectioncode,CS_DN,LineCount';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' from alarm_lulinetest_state_temp ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' where (cityid,cs_tag) not in ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' (select cityid,deviceid from alarm_Lurt_state_list where contentcode=0) ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' ) t1 ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' left join fms_device_info t2 on t1.deviceid=t2.deviceid and t1.cityid=t2.cityid ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' left join alarm_sys_function_set t3 on t3.cityid=t1.cityid and t3.kind=1 and t3.code=1 ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' where t2.cs_status_id in (t3.setvalue) ';

  SqlStr[ThreadSN][15]:=' delete from alarm_Lurt_state_list ';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' where contentcode<>0 and (cityid,deviceid,contentcode,ISALARM) not in ';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' (select a.cityid,a.deviceid,a.contentcode,c.ISALARM from alarm_Lurt_noarrange_temp a';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode ';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' inner join alarm_content_status_list c on a.cityid=c.cityid and a.contentcode=c.contentcode and a.alarmstatus=c.alarmstatus';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' where b.ifineffect=1 and b.sendtype=1 and c.ISALARM=1 ';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' )';

  SqlStr[ThreadSN][16]:=' delete from alarm_Lurt_state_list';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' where (cityid,deviceid) not in ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' (select cityid,cs_tag from alarm_lulinetest_state_temp ) and contentcode=0 ';

  SqlStr[ThreadSN][17]:=SqlStr[ThreadSN][15] + ' and (collectionkind,collectioncode) not in (@CollectFailedList)';

  SqlStr[ThreadSN][18]:=SqlStr[ThreadSN][16] + ' and (collectionkind,collectioncode) not in (@CollectFailedList)';

  SqlStr[ThreadSN][19] :=' select count(*) as reccount from alarm_lulinetest_State_Temp';
end;

8:
//******************************************************************************
//��Ѷ����·���Ը澯 ThreadSN=8
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 14);
  SqlStr[ThreadSN][1]:='delete from alarm_LuLine_noarrange_List where (Contentcode=301) or ';
  SqlStr[ThreadSN][1]:=SqlStr[ThreadSN][1] + ' ( Contentcode in (302,303) and (Identification in (0,2)) )';

  SqlStr[ThreadSN][2]:='delete from alarm_LuLine_arrange_temp ';

  SqlStr[ThreadSN][3]:='update alarm_LuLine_noarrange_List set Identification=0 ';

  SqlStr[ThreadSN][5]:='select CityID, deviceid, contentcode, alarmstatus, ErrorContent, createtime, Identification, collectionkind, collectioncode ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from alarm_LuLine_noarrange_List where Contentcode in (301,302,303) ';

  SqlStr[ThreadSN][6]:=' SELECT @CityID as cityid,rtrim(b.CS_Tag) as deviceid,301 as ContentCode,0 as AlarmStatue,null as ErrorContent, a.logtime as CreateTime,2 as Identification, ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' FROM CSAlarmChar_H a INNER JOIN @tabname b ON a.ID = b.ID '; //������վ�����߸澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' WHERE (SUBSTRING(a.staAlarm1, 5, 1) = ''1'') and a.logtime>=GETDATE()-@ForwardDay and dateadd(minute,@SetValue,a.logtime)<=GETDATE() ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' SELECT @CityID as cityid,rtrim(b.CS_Tag) as deviceid,301 as ContentCode,0 as AlarmStatue,null as ErrorContent, a.logtime as CreateTime,2 as Identification, ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' FROM CSAlarm_K a INNER JOIN @tabname b ON a.ID = b.ID ';    //���ɻ�վ�����߸澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' WHERE (SUBSTRING(a.staAlarm0, 5, 1) = ''1'') and vendortype=0 and a.logtime>=GETDATE()-@ForwardDay and dateadd(minute,@SetValue,a.logtime)<=GETDATE() ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' SELECT @CityID as cityid,rtrim(b.CS_Tag) as deviceid,301 as ContentCode,0 as AlarmStatue,null as ErrorContent, a.logtime as CreateTime,2 as Identification, ';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' FROM CSAlarm_K a INNER JOIN @tabname b ON a.ID = b.ID ';    //�����վ�����߸澯
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' WHERE (SUBSTRING(a.staAlarm0, 6, 1) = ''1'') and vendortype=1 and a.logtime>=GETDATE()-@ForwardDay and dateadd(minute,@SetValue,a.logtime)<=GETDATE() ';

  SqlStr[ThreadSN][7]:=' SELECT @CityID as cityid,rtrim(CS_Tag) as deviceid, CASE WHEN Line1 < 1 OR Line1 > 4 OR line2 < 1 OR line2 > 4 OR ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' line3 < 1 OR line3 > 4 OR line4 < 1 OR line4 > 4 THEN 303 ELSE 302 END AS ContentCode,0 as AlarmStatue, ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '''��''+ltrim(rtrim(CASE WHEN Line1 <> 1 THEN ''1'' ELSE '' '' END + CASE WHEN Line2 <> ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' 2 THEN ''2'' ELSE '' '' END + CASE WHEN Line3 <> 3 THEN ''3'' ELSE '' '' END + CASE WHEN ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' Line4 <> 4 THEN ''4'' ELSE '' '' END)) + ''����'' AS ErrorContent, ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' getdate() as CreateTime,3 as Identification, ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' FROM (SELECT b.CS_Tag, a.line1, a.line2, a.line3, a.line4 ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '       FROM linetest_H a, @tabname b ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '       WHERE (a.id = b.id) AND (a.line1 <> 1 OR a.line2 <> 2 OR ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '              a.line3 <> 3 OR a.line4 <> 4) AND a.line3 <> 0 AND a.line4 <> 0 ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '       UNION ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '       SELECT b.CS_Tag, a.linea, a.lineb, a.linec, a.lined ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '       FROM csinterfaces_k a, @tabname b ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '       WHERE (a.id = b.id) AND (a.linea <> 1 OR a.lineb <> 2 OR ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '              a.linec <> 3 OR a.lined <> 4) AND a.linec <> 0 AND a.lined <> 0 ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + '      ) a ';

  SqlStr[ThreadSN][8]:=' insert into alarm_LuLine_arrange_temp(cityid, deviceid, contentcode, ISALARM, ErrorContent, createtime, collectionkind, collectioncode) ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select a.cityid,a.deviceid,a.contentcode,c.ISALARM,a.ErrorContent,a.createtime, collectionkind, collectioncode ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_LuLine_noarrange_List a';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' inner join alarm_content_status_list c on a.cityid=c.cityid and a.contentcode=c.contentcode and a.alarmstatus=c.alarmstatus';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' where b.ifineffect=1 and a.Identification=2 and (a.cityid,a.deviceid,a.contentcode,c.ISALARM) not in ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' (select cityid,deviceid,contentcode,ISALARM from ALARM_ONLINE_DETAIL_VIEW) ';

  SqlStr[ThreadSN][9]:=' insert into alarm_LuLine_arrange_temp(cityid,deviceid,contentcode,ISALARM, ErrorContent, createtime, collectionkind, collectioncode) ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' select a.cityid,deviceid,contentcode,0 as ISALARM, ErrorContent,sysdate as createtime, a.collectionkind, a.collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' from ALARM_ONLINE_DETAIL_VIEW a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where alarmtype=9 and ISALARM=1 and (a.cityid,deviceid,contentcode,ISALARM) not in ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' (select a.cityid,a.deviceid,a.contentcode,b.ISALARM from alarm_LuLine_noarrange_list a';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' inner join alarm_content_status_list b on a.cityid=b.cityid and a.contentcode=b.contentcode ';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' and a.alarmstatus=b.alarmstatus ) ';

  SqlStr[ThreadSN][10] := 'select count(*) as reccount from alarm_LuLine_arrange_temp';

  SqlStr[ThreadSN][11]:=' insert into Alarm_Data_Gather ';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' (AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID, ErrorContent, collectionkind, collectioncode)';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select rownum as AlarmAutoid,CityID,AlarmType,deviceid,ContentCode,ISALARM,createtime,CollectID,ErrorContent, collectionkind, collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from (';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select t1.CityID,cast(9 as number(10)) as AlarmType,t1.deviceid,t1.ContentCode,t1.ISALARM, t1.CreateTime, :NewCollectID_1 as CollectID, t1.ErrorContent, t1.collectionkind, t1.collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from alarm_LuLine_arrange_temp t1';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.deviceid=t2.deviceid and t1.ContentCode=t2.ContentCode ';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' where t1.ISALARM <> t2.ISALARM and t2.AlarmType=9 ';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' union';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' select CityID,cast(9 as number(10)) as AlarmType,deviceid,ContentCode,ISALARM, CreateTime, :NewCollectID_2 as CollectID, ErrorContent, collectionkind, collectioncode';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' from alarm_LuLine_arrange_temp ';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' where ISALARM=1 and ((cityid,deviceid,ContentCode) ';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' not in (select cityid,deviceid,contentcode from alarm_online_detail_view)) ';
  SqlStr[ThreadSN][11]:=SqlStr[ThreadSN][11] + ' )';

  SqlStr[ThreadSN][12]:=' select count(*) as reccount from sysobjects where id = object_id(''CsMainAll'')';

  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][9] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';
end;

9:
//******************************************************************************
//��Ѷ��·���Ը澯 ThreadSN=9
//******************************************************************************
begin
  SetLength(SqlStr[ThreadSN], 23);
  SqlStr[ThreadSN][1]:='delete from alarm_lulinetest_nosplit_List where Identification in (0,2) ';

  SqlStr[ThreadSN][2]:='update alarm_lulinetest_nosplit_List set Identification=0 ';

  SqlStr[ThreadSN][3]:='delete from alarm_lulinetest_split_Temp ';

  SqlStr[ThreadSN][4]:=' select cityid, cs_tag, cs_dn, line1, line2, line3, line4, linecount, FaultTime, Identification, ';
  SqlStr[ThreadSN][4]:=SqlStr[ThreadSN][4] + ' testline1, testline2, testline3, testline4, collectionkind, collectioncode from ALARM_LULINETEST_NOSPLIT_List ';

  SqlStr[ThreadSN][5]:=' select @CityID as cityid,ltrim(rtrim(cs_tag)) as cs_tag,cs_dn,line1,line2,line3,line4,linecount,getdate() as FaultTime,3 as Identification, ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when len(cs_nr5ess1)>=10 then cast(cast(left(right(rtrim(cs_nr5ess1),10),3) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(left(right(rtrim(cs_nr5ess1), 7),3) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(left(right(rtrim(cs_nr5ess1), 4),2) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(right(rtrim(cs_nr5ess1),2) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' else null end as testline1,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when len(cs_nr5ess2)>=10 then cast(cast(left(right(rtrim(cs_nr5ess2),10),3) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(left(right(rtrim(cs_nr5ess2), 7),3) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(left(right(rtrim(cs_nr5ess2), 4),2) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(right(rtrim(cs_nr5ess2),2) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' else null end as testline2,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when len(cs_nr5ess3)>=10 then cast(cast(left(right(rtrim(cs_nr5ess3),10),3) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(left(right(rtrim(cs_nr5ess3), 7),3) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(left(right(rtrim(cs_nr5ess3), 4),2) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(right(rtrim(cs_nr5ess3),2) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' else null end as testline3,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when len(cs_nr5ess4)>=10 then cast(cast(left(right(rtrim(cs_nr5ess4),10),3) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(left(right(rtrim(cs_nr5ess4), 7),3) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(left(right(rtrim(cs_nr5ess4), 4),2) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' 			                       +''-''+cast(cast(right(rtrim(cs_nr5ess4),2) as int) as varchar)';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' else null end as testline4, ';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' @collectionkind as collectionkind, @collectioncode as collectioncode';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from (';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select x.cs_tag, x.CS_DN,x.Bwedline,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' dbo.IntToBin(x.Bwedline,16) as Bwedline_Bin,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when (substring(dbo.IntToBin(x.Bwedline,16),len(dbo.IntToBin(x.Bwedline,16))-11,4) in (''0000'',''0101'',''0100'',''0001'','''')) then 0 else 1 end as Line1,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when (substring(dbo.IntToBin(x.Bwedline,16),len(dbo.IntToBin(x.Bwedline,16))-15,4) in (''0000'',''0101'',''0100'',''0001'','''')) then 0 else 1 end as Line2,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when (substring(dbo.IntToBin(x.Bwedline,16),len(dbo.IntToBin(x.Bwedline,16))- 3,4) in (''0000'',''0101'',''0100'',''0001'','''')) or (x.LineCount=2) then 0 else 1 end as Line3,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when (substring(dbo.IntToBin(x.Bwedline,16),len(dbo.IntToBin(x.Bwedline,16))- 7,4) in (''0000'',''0101'',''0100'',''0001'','''')) or (x.LineCount=2) then 0 else 1 end as Line4,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' x.LineCount,''H'' as CS_Vonder,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from (';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' SELECT b.cs_tag, b.CS_DN, a.Bwedline, b.CS_Vendor,case when cs_channelnum in (3,4)  then 2 else 4 end as LineCount';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' FROM CSAlarm_H a, @tabname b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' WHERE a.id = b.id';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' UNION';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' SELECT b.cs_tag, b.CS_DN, staCircuit, b.CS_Vendor,case when cs_channelnum in (3,4)  then 2 else 4 end as LineCount';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' FROM CSstatus_k a, @tabname b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' WHERE a.id = b.id';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' UNION';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' SELECT b.cs_tag, b.CS_DN, a.Bwedline, b.CS_Vendor,case when cs_channelnum in (3,4)  then 2 else 4 end as LineCount';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' FROM CSAlarm_H a, @tabname b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' WHERE a.id = b.id';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' UNION';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' SELECT b.cs_tag, b.CS_DN, staCircuit, b.CS_Vendor,case when cs_channelnum in (3,4)  then 2 else 4 end as LineCount';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' FROM CSstatus_k a, @tabname b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' WHERE a.id = b.id';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ) x';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' where x.CS_Vendor=''Hitachi'' or x.CS_Vendor=''Kyocera''';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' union';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' select y.cs_tag, y.CS_DN,y.Bwedline,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' dbo.IntToBin(y.Bwedline,16) as Bwedline_Bin,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when (substring(dbo.IntToBin(y.Bwedline,16),len(dbo.IntToBin(y.Bwedline,16)),1) in (''0'','''')) and (substring(dbo.IntToBin(y.Bwedline,16),len(dbo.IntToBin(y.Bwedline,16))-8,1) in (''0'','''')) then 0 else 1 end as Line1,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when (substring(dbo.IntToBin(y.Bwedline,16),len(dbo.IntToBin(y.Bwedline,16))-1,1) in (''0'','''')) and (substring(dbo.IntToBin(y.Bwedline,16),len(dbo.IntToBin(y.Bwedline,16))-9,1) in (''0'','''')) then 0 else 1 end as Line2,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when ((substring(dbo.IntToBin(y.Bwedline,16),len(dbo.IntToBin(y.Bwedline,16))-2,1) in (''0'','''')) and (substring(dbo.IntToBin(y.Bwedline,16),len(dbo.IntToBin(y.Bwedline,16))-10,1) in (''0'',''''))) or (y.LineCount=2) then 0 else 1 end as Line3,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' case when ((substring(dbo.IntToBin(y.Bwedline,16),len(dbo.IntToBin(y.Bwedline,16))-3,1) in (''0'','''')) and (substring(dbo.IntToBin(y.Bwedline,16),len(dbo.IntToBin(y.Bwedline,16))-11,1) in (''0'',''''))) or (y.LineCount=2) then 0 else 1 end as Line4,';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' y.LineCount,''S'' as CS_Vonder,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' from (';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' SELECT b.cs_tag, b.CS_DN, a.Bwedline, b.CS_Vendor,case when cs_channelnum in (3,4) then 2 else 4 end as LineCount';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' FROM CSAlarm_H a, @tabname b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' WHERE a.id = b.id';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' UNION';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' SELECT b.cs_tag, b.CS_DN, staCircuit, b.CS_Vendor,case when cs_channelnum in (3,4) then 2 else 4 end as LineCount';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' FROM CSstatus_k a, @tabname b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' WHERE a.id = b.id';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' UNION';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' SELECT b.cs_tag, b.CS_DN, a.Bwedline, b.CS_Vendor,case when cs_channelnum in (3,4) then 2 else 4 end as LineCount';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' FROM CSAlarm_H a, @tabname b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' WHERE a.id = b.id';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' UNION';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' SELECT b.cs_tag, b.CS_DN, staCircuit, b.CS_Vendor,case when cs_channelnum in (3,4) then 2 else 4 end as LineCount';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ,cs_nr5ess1,cs_nr5ess2,cs_nr5ess3,cs_nr5ess4';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' FROM CSstatus_k a, @tabname b';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' WHERE a.id = b.id';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ) y';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' where CS_Vendor=''Sanyo''';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' ) c';
  SqlStr[ThreadSN][5]:=SqlStr[ThreadSN][5] + ' where (c.Line1=1 or c.Line2=1 or c.Line3=1 or c.Line4=1) and len(cs_nr5ess1)>=10 and len(cs_nr5ess2)>=10';

  SqlStr[ThreadSN][6]:=' insert into alarm_lulinetest_split_temp(cityid,Cs_tag,Cs_dn,ISALARM,ContentCode,TestLine,LineCount,FaultTime, collectionkind, collectioncode)';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select a.cityid,cs_tag,cs_dn,b.ISALARM,a.contentcode,TestLine,LineCount,FaultTime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from (';      //--(01)-311 ��Ѷ-��վ��һ���߹���
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,cs_tag,cs_dn,line1 as alarmstatus,cast(311 as number(10)) as contentcode,testLine1 as TestLine,LineCount,FaultTime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_lulinetest_nosplit_list where Identification=2';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union';       //--(02)-312 ��Ѷ-��վ�ڶ����߹���
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,cs_tag,cs_dn,line2 as alarmstatus,cast(312 as number(10)) as contentcode,testLine2 as TestLine,LineCount,FaultTime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_lulinetest_nosplit_list where Identification=2';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union';       //--(03)-313 ��Ѷ-��վ�������߹���
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,cs_tag,cs_dn,line3 as alarmstatus,cast(313 as number(10)) as contentcode,testLine3 as TestLine,LineCount,FaultTime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_lulinetest_nosplit_list where Identification=2';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' union';       //--(04)-314 ��Ѷ-��վ���Ķ��߹���
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' select cityid,cs_tag,cs_dn,line4 as alarmstatus,cast(314 as number(10)) as contentcode,testLine4 as TestLine,LineCount,FaultTime, collectionkind, collectioncode';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' from alarm_lulinetest_nosplit_list where Identification=2';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' ) a';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' inner join alarm_content_status_list b on a.cityid=b.cityid and a.contentcode=b.contentcode and cast(a.alarmstatus as varchar(2))=b.alarmstatus';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' where b.ISALARM=1 and (a.cityid,a.Cs_tag,a.contentcode,b.ISALARM) not in';
  SqlStr[ThreadSN][6]:=SqlStr[ThreadSN][6] + ' (select cityid,deviceid,contentcode,ISALARM from ALARM_ONLINE_DETAIL_VIEW where alarmtype=10)';

  SqlStr[ThreadSN][7]:=' delete from alarm_lulinetest_split_temp where (cityid,contentcode) in ';
  SqlStr[ThreadSN][7]:=SqlStr[ThreadSN][7] + ' (select cityid,alarmcontentcode from alarm_content_rule where ifineffect=0 )';

  SqlStr[ThreadSN][8]:=' insert into alarm_lulinetest_result  ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' select cs_tag, contentcode, errorcontent, faulttime, ISALARM, cityid, collectionkind, collectioncode  ';
  SqlStr[ThreadSN][8]:=SqlStr[ThreadSN][8] + ' from alarm_lulinetest_out where ISALARM=0';

  SqlStr[ThreadSN][9]:=' delete from alarm_lulinetest_result';
  SqlStr[ThreadSN][9]:=SqlStr[ThreadSN][9] + ' where faulttime+240/24/60<=sysdate ';

  SqlStr[ThreadSN][10]:=' ';

  SqlStr[ThreadSN][11]:=' select count(*) as reccount from alarm_lulinetest_split_temp';

  SqlStr[ThreadSN][12]:=' ';

  SqlStr[ThreadSN][13]:=' insert into alarm_lulinetest_in ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' (id, cityid, cs_tag, cs_dn, testline, testtype, testpriority, faulttime, testtime, linecount, memo, LuLineTestID, ContentCode, collectionkind, collectioncode )';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' select rownum, a.cityid, trim(cs_tag) as cs_tag, cs_dn, testline, testtype, 0 as testpriority, faulttime, null as testtime, linecount, null as memo, :LuLineTestID, ContentCode, collectionkind, collectioncode ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' from ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' (      /*ɸѡ���βɼ��ж������߱��������ϻ�վ��·�澯�����и澯���������ɸѡ���ָ澯���澯*/ ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' select  cs_tag,t1.cityid, cs_dn, testline, 1 as testtype, faulttime, linecount, t1.ContentCode, t1.collectionkind, t1.collectioncode ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' from alarm_lulinetest_split_temp t1';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' inner join ALARM_ONLINE_DETAIL_VIEW t2 on t1.cityid=t2.cityid and t1.cs_tag=t2.deviceid and t1.ContentCode=t2.ContentCode and t1.ISALARM <> t2.ISALARM ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' where t1.ISALARM=1 and testline is not null and (t1.cityid, t1.cs_tag, t1.contentcode) not in ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' (select cityid, cs_tag, contentcode from alarm_lulinetest_in where testtype = 1 ) ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' and (t1.cityid, t1.cs_tag, t1.contentcode) not in';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' (select cityid, cs_tag, contentcode from alarm_lulinetest_result where contentcode in (311,312,313,314)) ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' union  /*��·�澯�����¸澯�����߱���û�еĸ澯*/ ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' select  cs_tag,cityid, cs_dn, testline, 1 as testtype, faulttime, linecount, ContentCode, collectionkind, collectioncode ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' from alarm_lulinetest_split_temp ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' where ISALARM=1 and testline is not null';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' and (cityid, cs_tag, ContentCode) not in ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' (select cityid, deviceid, contentcode from alarm_online_detail_view where alarmtype = 10 )';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' and (cityid, cs_tag, contentcode) not in ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' (select cityid, cs_tag, contentcode from alarm_lulinetest_in where testtype = 1 ) ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' and (cityid,cs_tag,contentcode) not in';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' (select cityid, cs_tag, contentcode from alarm_lulinetest_result where contentcode in (311,312,313,314)) ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' union  /*״̬�澯�����¸澯�����߱���û�еĸ澯*/ ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' select distinct deviceid as cs_tag, cityid,cs_dn, null as testline, 0 as testtype,sysdate as faulttime, linecount, null as ContentCode, collectionkind, collectioncode ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' from alarm_Lurt_state_list';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' where (deviceid,cityid ) not in (select distinct deviceid,cityid from alarm_online_detail_view where alarmtype = 11)';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' and   (cityid,deviceid) not in (select cityid, cs_tag from alarm_lulinetest_in where testtype = 0 )';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' and   (deviceid,cityid) not in (select distinct cs_tag,cityid from alarm_lulinetest_result where contentcode in (321,322,323,324) )';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' and   (deviceid,cityid) not in (select distinct cs_tag,cityid from alarm_lulinetest_out where contentcode in (321,322,323,324) )';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' and   (deviceid,cityid) not in (select distinct deviceid,cityid from alarm_data_gather where contentcode in (321,322,323,324) )';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' ) a ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' left join fms_device_info b on a.cs_tag=b.deviceid and a.cityid=b.cityid ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' left join alarm_sys_function_set c on c.cityid=a.cityid and c.kind=1 and c.code=1 ';
  SqlStr[ThreadSN][13]:=SqlStr[ThreadSN][13] + ' where b.cs_status_id in (c.setvalue) ';

  //--ɾ���ظ���¼
  SqlStr[ThreadSN][14]:=' delete from alarm_lulinetest_out a ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' where LULINETESTAUTOID not in (select max(LULINETESTAUTOID) ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' from alarm_lulinetest_out b ';
  SqlStr[ThreadSN][14]:=SqlStr[ThreadSN][14] + ' where a.cityid=b.cityid and a.cs_tag = b.cs_tag and a.contentcode = b.contentcode) ';

  //--��δ�ɵ�alarm_data_collect��֮ǰ��������������·���Խ��Ϊ׼�������ҪɾAlarm_Data_Gather������
  SqlStr[ThreadSN][15]:=' delete from Alarm_Data_Gather ';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' where (cityid,deviceid,contentcode) in ';
  SqlStr[ThreadSN][15]:=SqlStr[ThreadSN][15] + ' (select cityid,cs_tag,contentcode from alarm_lulinetest_out )';

  SqlStr[ThreadSN][16]:=' insert into alarm_data_gather( alarmautoid, cityid, alarmtype, deviceid, ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' contentcode, ISALARM, createtime, collectid, errorcontent, collectionkind, collectioncode ) ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' select rownum, cityid, alarmtype, deviceid, contentcode, ISALARM, createtime, :NewCollectID, errorcontent, collectionkind, collectioncode ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' from ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' (      /*����·���Եģ���·��״̬�澯�����������¸澯������clear�澯 */ ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' select a.cityid, b.alarmtype, cs_tag as deviceid, a.contentcode, a.ISALARM, faulttime as Createtime, errorcontent, collectionkind, collectioncode ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' from alarm_lulinetest_out a ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode ';
  //SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' where a.contentcode<>324 ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' union  /*���ݸ澯���ϵĹ��ϻ�վ��clear�澯*/ ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' select a.cityid, b.alarmtype, cs_tag as deviceid, a.contentcode, a.ISALARM, faulttime as Createtime, null as errorcontent, collectionkind, collectioncode ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' from alarm_lulinetest_split_temp a ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' where a.ISALARM=0'; //****���testlineΪ�յĸ澯ҲҪ��ʾ�������ڴ˴������޸� */
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' union  /*���βɼ��û�վû����·�澯�������clear�澯*/ ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' select a.cityid, alarmtype, deviceid, contentcode, 0 as ISALARM, sysdate as createtime, errorcontent, a.collectionkind, a.collectioncode ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' from alarm_online_detail_view a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' where alarmtype=10 and ISALARM=1 and (a.cityid, deviceid) not in ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' (select cityid, cs_tag from alarm_lulinetest_nosplit_list ) ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' union  /*ɸѡ���βɼ��������ϻ�վ��·�澯�����ϵĸ澯����ɸѡclear�澯*/ ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' select a.cityid, cast(10 as number(10)) as alarmtype, a.cs_tag as deviceid, a.contentcode, a.ISALARM, faulttime as createtime, null as errorcontent, a.collectionkind, a.collectioncode ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' from alarm_lulinetest_split_temp a ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' inner join alarm_online_detail_view c on a.cityid=c.cityid and a.cs_tag=c.deviceid and a.contentcode=c.contentcode and a.ISALARM<>c.ISALARM';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' where a.ISALARM=0 ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' union  /*����·���Եģ�״̬�澯clear�澯*/ ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' select a.cityid, b.alarmtype, cs_tag as deviceid, b.contentcode, a.ISALARM, faulttime as Createtime, a.errorcontent, b.collectionkind, b.collectioncode  ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' from alarm_lulinetest_out a';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' inner join alarm_online_detail_view b on a.cityid=b.cityid and a.cs_tag=b.deviceid and b.alarmtype=11';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' where a.contentcode=324 and a.ISALARM=0  ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' union /*����·���Եģ���վ���������������ɳ���Ӧ��ʵʱ�澯*/';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' select a.cityid,cast(8 as number(10)) as alarmtype,a.deviceid,a.contentcode,a.ISALARM,a.createtime, ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' ''�������Ի�վ��������վ������Ҫ�µ�����'' as errorcontent,a.collectionkind,a.collectioncode';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' from alarm_lurt_state_list a';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' left join alarm_lulinetest_out b on a.cityid=b.cityid and a.deviceid=b.cs_tag ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' where a.contentcode<>0 and b.contentcode=324 and b.ISALARM=0';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' and (a.cityid,a.deviceid,a.contentcode,a.ISALARM) not in  ';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' (select cityid,deviceid,contentcode,ISALARM from ALARM_ONLINE_DETAIL_VIEW)';
  SqlStr[ThreadSN][16]:=SqlStr[ThreadSN][16] + ' ) ';

  SqlStr[ThreadSN][17]:=' delete from alarm_lulinetest_out ';

  SqlStr[ThreadSN][18]:=' select count(*) as reccount from alarm_lulinetest_out';

  SqlStr[ThreadSN][19]:=' delete from alarm_lulinetest_in where testpriority=0 and (CITYID, CS_TAG, CONTENTCODE) ';
  SqlStr[ThreadSN][19]:=SqlStr[ThreadSN][19] + ' in (select CITYID, CS_TAG, CONTENTCODE from alarm_lulinetest_split_temp where ISALARM=0)';
  //SqlStr[ThreadSN][19]:=SqlStr[ThreadSN][19] + ' or (LuLineTestID<=(select max(LuLineTestID) from alarm_lulinetest_in)-2) )';

  SqlStr[ThreadSN][20]:=' select count(*) as reccount from sysobjects where id = object_id(''CsMainAll'')';

  SqlStr[ThreadSN][21]:=' insert into alarm_data_gather( alarmautoid, cityid, alarmtype, deviceid, ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' contentcode, ISALARM, createtime, collectid, errorcontent, collectionkind, collectioncode ) ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' select rownum, cityid, alarmtype, deviceid, contentcode, ISALARM, createtime, :NewCollectID, errorcontent, collectionkind, collectioncode ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' from ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' (      /*����·���Եģ���·��״̬�澯�����������¸澯������clear�澯 */ ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' select a.cityid, b.alarmtype, cs_tag as deviceid, a.contentcode, a.ISALARM, faulttime as Createtime, errorcontent, collectionkind, collectioncode ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' from alarm_lulinetest_out a ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode ';
  //SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' where a.contentcode<>324 ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' union  /*���ݸ澯���ϵĹ��ϻ�վ��clear�澯*/ ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' select a.cityid, b.alarmtype, cs_tag as deviceid, a.contentcode, a.ISALARM, faulttime as Createtime, null as errorcontent, collectionkind, collectioncode ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' from alarm_lulinetest_split_temp a ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' inner join alarm_content_rule b on a.cityid=b.cityid and a.contentcode=b.alarmcontentcode ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' where a.ISALARM=0'; //****���testlineΪ�յĸ澯ҲҪ��ʾ�������ڴ˴������޸�
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' union  /*���βɼ��û�վû����·�澯�������clear�澯*/ ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' select a.cityid, alarmtype, deviceid, contentcode, 0 as ISALARM, sysdate as createtime, errorcontent, a.collectionkind, a.collectioncode ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' from alarm_online_detail_view a inner join alarm_collection_cyc_list b';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' on a.collectionkind=b.collectionkind and a.collectioncode=b.collectioncode';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' where alarmtype=10 and ISALARM=1 and (a.cityid, deviceid) not in ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' (select cityid, cs_tag from alarm_lulinetest_nosplit_list ) ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' and (a.collectionkind,a.collectioncode) not in (@CollectFailedList)';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' union  /*ɸѡ���βɼ��������ϻ�վ��·�澯�����ϵĸ澯����ɸѡclear�澯*/ ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' select a.cityid, cast(10 as number(10)) as alarmtype, a.cs_tag as deviceid, a.contentcode, a.ISALARM, faulttime as createtime, null as errorcontent, a.collectionkind, a.collectioncode ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' from alarm_lulinetest_split_temp a ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' inner join alarm_online_detail_view c on a.cityid=c.cityid and a.cs_tag=c.deviceid and a.contentcode=c.contentcode and a.ISALARM<>c.ISALARM';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' where a.ISALARM=0 ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' union  /*����·���Եģ�״̬�澯clear�澯*/ ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' select a.cityid, b.alarmtype, cs_tag as deviceid, b.contentcode, a.ISALARM, faulttime as Createtime, a.errorcontent, b.collectionkind, b.collectioncode  ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' from alarm_lulinetest_out a';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' inner join alarm_online_detail_view b on a.cityid=b.cityid and a.cs_tag=b.deviceid and b.alarmtype=11';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' where a.contentcode=324 and a.ISALARM=0  ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' union /*����·���Եģ���վ���������������ɳ���Ӧ��ʵʱ�澯*/';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' select a.cityid,cast(8 as number(10)) as alarmtype,a.deviceid,a.contentcode,a.ISALARM,a.createtime, ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' ''����������������Ҫ����״̬���'' as errorcontent,a.collectionkind,a.collectioncode';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' from alarm_lurt_state_list a';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' left join alarm_lulinetest_out b on a.cityid=b.cityid and a.deviceid=b.cs_tag ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' where a.contentcode<>0 and b.contentcode=324 and b.ISALARM=0';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' and (a.cityid,a.deviceid,a.contentcode,a.ISALARM) not in  ';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' (select cityid,deviceid,contentcode,ISALARM from ALARM_ONLINE_DETAIL_VIEW)';
  SqlStr[ThreadSN][21]:=SqlStr[ThreadSN][21] + ' ) ';

  SqlStr[ThreadSN][22]:=' delete from alarm_lulinetest_in where testpriority=0 and TESTTYPE=0 and (CS_TAG,CITYID) ';
  SqlStr[ThreadSN][22]:=SqlStr[ThreadSN][22] + ' not in (select distinct deviceid,CITYID from alarm_lurt_State_list)';
end;
end;
end;
{
// EventID �����ܱ��    1: ����  2������  3����ȡͳ��Ͻ�� 4��֪ͨͳ�����  5:Ԥ��֪ͨ
function CollectServerMsg(Event:integer;districtid:integer;msg :String):Boolean;
begin
  result := false;
  if TempInterface = nil then Exit;
  EnterCriticalSection(CR);
  try
    try
      TempInterface.CollectServerMsg(1,0,' ');
    except
    end;
  finally
    LeaveCriticalSection(CR);
  end;

end;
}
end.
