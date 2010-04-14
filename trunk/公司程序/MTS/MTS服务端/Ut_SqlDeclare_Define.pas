unit Ut_SqlDeclare_Define;

interface

uses
  Classes,SysUtils,Variants,ADODB,Dialogs ;

const
  MaxType  = 50;
  SQLCount = 100;
type
  PByte = array[1..MaxType] of array of string;  // 动态二维数组

  var
  SqlStr_Common : PByte; //公用
  SqlStr_Resource :PByte; // 资源
  SqlStr_BaseData :PByte; // 基础数据
  //在指定AdoQuery中执行指定SQL语句
  procedure ExecTheSQL(Var Ado_LocalQuery: TADOQuery; TheSQLStr: String);

  function ProduceFlowNumID(var Sp_Alarm_FlowNumber: TADOStoredProc; I_FLOWNAME: string; I_SERIESNUM: integer):Integer;

  function GetRecCount(var TheADOQuery: TADOQuery; TheSql:string):integer;

  procedure OpenTheDataSet(var TheADOQuery: TADOQuery; thesql:string);

  //完成远程SQL语句的若干参数替换的函数
  Function ReplaceSQLParam(const TheSQL: string; OwnerData: OleVariant):String;
  //将指定日期值保存到数据库的转换函数，HoldTime=false表示不保留时间部份
  function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
  //初始化涉及的SQL执行语句
  procedure InitSQLVar();

  //初始化公用SQL语句
  procedure Init_SqlStr_Common();
  //初始化资源管理SQL语句
  procedure Init_SqlStr_Resource();
  //初始化基础数据SQL语句
  procedure Init_SqlStr_BaseData();
implementation

//在指定AdoQuery中执行指定SQL语句
procedure ExecTheSQL(Var Ado_LocalQuery: TADOQuery; TheSQLStr: String);
begin
  with Ado_LocalQuery do
  begin
    close;
    sql.Clear;
    sql.Add(TheSQLStr);
    ExecSQL;
  end;
end;

function ProduceFlowNumID(var Sp_Alarm_FlowNumber: TADOStoredProc; I_FLOWNAME: string; I_SERIESNUM: integer):Integer;
begin
   with Sp_Alarm_FlowNumber do
   begin
      close;
      Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //流水号命名
      Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //申请的连续流水号个数
      execproc;
      result:=Parameters.parambyname('O_FLOWVALUE').Value; //返回值为整型，过程只返回序列的第一个值，但下次返回值为：result+I_SERIESNUM
      close;
   end;
end;

function GetRecCount(var TheADOQuery: TADOQuery; TheSql:string):integer;
begin
   with TheADOQuery do
   begin
      close;
      sql.Clear;
      sql.Add(TheSql);
      open;
      result:=fieldbyname('reccount').AsInteger;
      close;
   end;
end;

procedure OpenTheDataSet(var TheADOQuery: TADOQuery; thesql:string);
begin
  with TheADOQuery do
  begin
    close;
    sql.Clear;
    sql.Add(thesql);
    open;
  end;
end;

//完成远程SQL语句的若干参数替换的函数
Function ReplaceSQLParam(const TheSQL: string; OwnerData: OleVariant):String;
var
  i: integer;
  paramname: string;
begin
  Result:=TheSQL;
  if varIsArray(OwnerData) then
  begin  //格式 [纬度1，纬度2，变量]
    for i := varArrayLowBound(OwnerData, 1)+3 to varArrayHighBound(OwnerData, 1) do
    begin
      paramname:='@Param'+inttostr(i-2);
      Result:=StringReplace(Result, paramname, OwnerData[i], [rfReplaceAll, rfIgnoreCase]);
    end;
  end;
end;

//将指定日期值保存到数据库的转换函数，HoldTime=false表示不保留时间部份
function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
begin
  if HoldTime then
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD HH:MI:SS')+')'
  else
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD')+')';
end;

{*********************************0公用SQL***************************************
  SqlStr_Common  存放公用SQL语句
********************************************************************************}
procedure Init_SqlStr_Common();
begin
  //dic_type_info- SqlStr_Common[1]
  SetLength(SqlStr_Common[1], SQLCount);
  //获取用户基本信息及所属地市
  SqlStr_Common[1,1]:='select * from userinfo where userid=@Param1';
  //获取指定类型的字典数据用户构造 ComBox对象
  SqlStr_Common[1,2]:='select DICCODE as thecode,DICNAME as thename from DIC_CODE_INFO where PARENTID <>-1 and dictype=@Param1 and ifineffect=1 order by dicorder';
  //查询指定的地市
  SqlStr_Common[1,3]:='select * from area_info where top_id in (-1,@Param1) or id=@Param2 order by id';
  //查询指定的郊县
  SqlStr_Common[1,4]:='select * from area_info where id in (0,@Param1,@Param2) order by id';
  //获取用户基本信息及所属地市
  SqlStr_Common[1,5]:='select * from userinfo where userno=''@Param1''';
  //获取MTU命令 参数 1 为测试 2 为结果反馈
  SqlStr_Common[1,6]:='select comid as thecode,comname as thename from mtu_command_define where ifineffect=1 and COMTYPE=@Param1';
  //获取MTU参数
  SqlStr_Common[1,7]:='select paramid as thecode,paramname as thename from  mtu_param_define where ifineffect=1';
  //获取AREA
  SqlStr_Common[1,8]:='select id as thecode,name as thename from  area_info ';
  //获取指定字典的最大编码值
  //SqlStr_Common[1,9]:='select nvl(max(diccode),0) diccode from dic_code_info where dictype =@Param1';
  SqlStr_Common[1,9]:='select diccode from dic_code_info where dictype =@Param1 order by diccode desc';

  //获取指定序列的新值
  SqlStr_Common[1,10]:='select @Param1.Nextval as ID from dual';

  //获取全部告警类型
  SqlStr_Common[1,11]:='select * from dic_code_info where dictype=11 order by diccode';

  //告警综合查询（在线）
  SqlStr_Common[1,12]:='select a.alarmid 告警编号,b.alarmcontentname 告警内容,'+
    'g.dicname as 告警类型,h.dicname as 告警等级,a.sendtime 派障时间,a.removetime 排障时间,'+
    'c.mtuname MTU名称,c.mtuno MTU设备编号,c.overlay MTU覆盖区域,c.mtuaddr MTU位置,'+
    'c.call 电话号码,d.buildingname 室分点名称,'+
    'd.address 室分点地址,e.name as 郊县,f.name as 地市 from alarm_master_online a '+
    'left join mtu_alarm_content b on a.alarmcontentcode=b.alarmcontentcode '+
    'left join dic_code_info g on b.alarmkind=g.diccode and g.dictype=11 '+
    'left join dic_code_info h on b.alarmlevel=h.diccode and h.dictype=10 '+
    'left join mtu_info c on a.mtuid=c.mtuid '+
    'left join building_info d on c.buildingid=d.buildingid '+
    'left join area_info e on d.areaid=e.id and e.layer=3 '+
    'left join area_info t1 on e.top_id=t1.id and t1.layer=2 '+
    'left join area_info f on t1.top_id=f.id and f.layer=1 '+
    'where a.flowtache=2 @param1 order by a.alarmid';
  //告警综合查询（历史）
  SqlStr_Common[1,13]:='select a.alarmid 告警编号,b.alarmcontentname 告警内容,'+
    'g.dicname as 告警类型,h.dicname as 告警等级,a.sendtime 派障时间,a.removetime 排障时间,'+
    'c.mtuname MTU名称,c.mtuno MTU设备编号,c.overlay MTU覆盖区域,c.mtuaddr MTU位置,'+
    'c.call 电话号码,d.buildingname 室分点名称,'+
    'd.address 室分点地址,e.name as 郊县,f.name as 地市 from alarm_master_history a '+
    'left join mtu_alarm_content b on a.alarmcontentcode=b.alarmcontentcode '+
    'left join dic_code_info g on b.alarmkind=g.diccode and g.dictype=11 '+
    'left join dic_code_info h on b.alarmlevel=h.diccode and h.dictype=10 '+
    'left join mtu_info c on a.mtuid=c.mtuid '+
    'left join building_info d on c.buildingid=d.buildingid '+
    'left join area_info e on d.areaid=e.id and e.layer=3 '+
    'left join area_info t1 on e.top_id=t1.id and t1.layer=2 '+
    'left join area_info f on t1.top_id=f.id and f.layer=1 '+
    'where a.flowtache=3 @param1 order by a.alarmid';

  //获取系统参数设置
  SqlStr_Common[1,14]:='select itemcode, itemkind, itemcontent, setvalue, itemnote from sys_param_config where itemkind=@param1 and itemcode=@param2';
  //****************    第 2维 SQL 为 树图保留使用    ******************************************
  SetLength(SqlStr_Common[2], SQLCount);
  //查询全部地市
  SqlStr_Common[2,1]:='select * from area_info where layer =1 order by id';
  //查询指定地市
  SqlStr_Common[2,2]:='select * from area_info where layer =1 and id =@Param1 order by id';
  //查询某地市的全部郊县
  SqlStr_Common[2,3]:='select * from area_info where layer =2 and top_id =@Param1 order by id';
  //查询指定郊县
  SqlStr_Common[2,4]:='select * from area_info where layer =2 and id=@Param1 order by id';
  SqlStr_Common[2,75]:= 'select * from area_info where layer =3 and top_id =@Param1 order by id';
  //查询某郊县的所有室分点
  SqlStr_Common[2,5]:='select buildingid,buildingno,buildingname,NETTYPE from building_info where areaid=@Param1 order by buildingid';
  //查询某室分点的所有交换机
  SqlStr_Common[2,6]:='select switchid,switchno from switch_info where buildingid=@Param1 order by switchid';
  //查询某室分点的所有PHS基站
  SqlStr_Common[2,7]:='select csid,netaddress,survery_id from cs_info where buildingid=@Param1 order by netaddress';
  //查询某交换机下的所有AP
  SqlStr_Common[2,8]:='select * from ap_info where switchid=@Param1 order by apid';
  //查询某室分点下的所有连接器及连接器下的MTU并集
  SqlStr_Common[2,9]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a  where a.buildingid=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' where b.buildingid=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''连接器集'' as name,0 as layer from dual ';
  //查询某AP下的所有连接器及连接器下的MTU并集
  SqlStr_Common[2,10]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a  where a.linkap=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' where b.linkap=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''连接器集'' as name,0 as layer from dual ';
  //查询某PHS下的所有连接器及连接器下的MTU并集
  SqlStr_Common[2,11]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a  where a.linkcs=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' where b.linkcs=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''连接器集'' as name,0 as layer from dual';
  //查询某个连接器的信息
  SqlStr_Common[2,12]:='select * from linkmachine_info where linkid=@Param1';
  //查询某交换机器下的所有连接器及连接器下的MTU并集
  SqlStr_Common[2,13]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a'+
                      ' inner join ap_info b on a.linkap=b.apid '+
                      ' where b.switchid=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' inner join ap_info c on b.linkap=c.apid'+
                      ' where c.switchid=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''连接器集'' as name,0 as layer from dual ';

  //20090317新增
  //查询某室分点的所有CDMA基站
  SqlStr_Common[2,14]:='select cdmaid,cdmaname,cdmano,cdmatype from cdma_info where buildingid=@Param1 order by cdmaname';
  //查询某CDMA下的所有连接器及连接器下的MTU并集
  SqlStr_Common[2,15]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a  where a.linkcdma=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' where b.linkcdma=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''连接器集'' as name,0 as layer from dual'; 
  //查询某郊县的全部分局
  SqlStr_Common[2,16]:='select * from area_info where layer =3 and top_id =@Param1 order by id';
  //查询指定分局
  SqlStr_Common[2,17]:='select * from area_info where layer =3 and id=@Param1 order by id';
  //模糊查询室分点
  SqlStr_Common[2,18]:= 'select * from'+
                        ' (select buildingid,buildingname,ROW_NUMBER () over (order by buildingname) rn from  building_info_view where @Param1 like ''%@Param2%''@Param3)'+
                        ' where rn<=5';
  //室内点信息管理
  SqlStr_Common[2,19]:='select buildingid,buildingno as 室分点编号 ,buildingname  as 室分点名称,'+
                         ' address as 地址,longitude as 经度,latitude as 纬度,'+
                         ' nettypename as 所属网络类型,factoryname as 集成厂商, connecttypename as 接入方式,'+
                         ' buildingtypename as 室分点类型,floorcount as 楼层数目,buildingarea as 楼层面积,suburbname as 所属分局,suburbid, agentcompanyname as 代维公司'+
                         ' from building_info_view t  where 1=1 @Param1 order by buildingname';
  SqlStr_Common[2,20] := 'select a.*'+
                          ' from'+
                          ' (select ROW_NUMBER () OVER (PARTITION BY part ORDER BY lev DESC) rn,a.*'+
                          '   from'+
                          '   (SELECT  level AS Lev,level-rownum as part,a.*'+
                          '    FROM area_info a start with  a.id=@param1 CONNECT BY PRIOR a.id=a.top_id'+
                          '    order siblings  by a.id'+
                          '    ) a'+
                          ' ) a'+
                          ' where a.rn=1';
  SqlStr_Common[2,21] := ' select * from (SELECT  level AS Lev,level-rownum as part,a.*'+
                         ' FROM area_info a start with  a.id=@param1 CONNECT BY PRIOR a.id=a.top_id'+
                         ' order siblings  by a.id)'+
                         ' where layer=3';
  SqlStr_Common[2,22] := ' select * from (SELECT  level AS Lev,level-rownum as part,a.*'+
                         ' FROM area_info a start with  a.id=@param1 CONNECT BY PRIOR a.id=a.top_id'+
                         ' order siblings  by a.id)'+
                         ' where layer=2';
//  SqlStr_Common[2,23] := 'select decode(alarmkindname,''全部告警'',1,2) as id,'+
//                                 'decode(alarmkindname,''全部告警'',0,1) as top_id,'+
//                                 'decode(alarmkindname,''全部告警'',1,2) as layer,'+
//                                 ' a.alarmkindname||''(''||a.counts||''个告警)'' as name from'+
//                                 ' (select decode(Grouping(t.alarmkindname),1,''全部告警'',alarmkindname) as alarmkindname, count(1) as counts'+
//                                 ' from alarm_master_online_view t where t.flowtache=2 @Param1'+
//                                 ' group by rollup(t.alarmkindname)) a';
  SqlStr_Common[2,23] := 'select a.id,nvl(prior a.id,0) as top_id,' + 
                         '       decode(alarmlevelname,''MTU全部告警'',1,''DRS全部告警'',1,''MTU级别告警'',2,''DRS级别告警'',2,3) as layer,' +
                         '       decode(alarmlevelname,''MTU全部告警'',alarmlevelname||''(''||counts||''个告警)'',' +
                         '                             ''DRS全部告警'',alarmlevelname||''(''||counts||''个告警)''' +
                         '             ,alarmkindname||''(''||counts||''个告警)'') as name' +
                         '  from   (select b.*,rownum as id from' +
                         '           (' +
                         '            (select decode(Grouping(t.alarmlevelname),1,''MTU全部告警'',decode(grouping(t.alarmkindname),1,''MTU级别告警'',''MTU''||alarmlevelname)) as alarmlevelname,' +
                         '                    decode(Grouping(t.alarmkindname),1,decode(Grouping(t.alarmlevelname),1,''MTU级别告警'',''MTU''||t.alarmlevelname),''MTU''||alarmkindname) as alarmkindname,' +
                         '                     count(1) as counts' +
                         '                from alarm_master_online_view t where t.flowtache=2 @Param1' +
                         '               group by rollup(t.alarmlevelname,t.alarmkindname)' +
                         '              )' +
                         '              union' +
                         '             (select decode(Grouping(t.alarmlevelname),1,''DRS全部告警'',decode(grouping(t.alarmkindname),1,''DRS级别告警'',''DRS''||alarmlevelname)) as alarmlevelname,' +
                         '                     decode(Grouping(t.alarmkindname),1,decode(Grouping(t.alarmlevelname),1,''DRS级别告警'',''DRS''||t.alarmlevelname),''DRS''||alarmkindname) as alarmkindname,' +
                         '                     count(1) as counts' +
                         '                from alarm_DRS_master_online_view t where t.flowtache=2 @Param2' +
                         '               group by rollup(t.alarmlevelname,t.alarmkindname)' +
                         '              )' +
                         '            )b' +
                         '          ) a ' +
                         ' connect by prior alarmkindname=alarmlevelname start with (alarmlevelname=''MTU全部告警'' or alarmlevelname=''DRS全部告警'')';
  SqlStr_Common[2,24] := 'select mtuid,mtuname as MTU名称,mtuno as MTU外部编号,overlay as 覆盖区域,'+
                         'mtuaddr as MTU位置,call as 电话号码,called as 被叫号码, '+
                         'MTUSTATUS as MTU状态,updatetime 状态变更时间,linkno as 连接器,'+
                         'buildingname as 所属室分点,isprogramname 室分情况,mainlook_apname 主监控AP,mainlook_phsname 主监控PHS,mainlook_cnetname 主监控C网,'+
                         ' cdmatypename C网信源类型,cdmaaddress C网信源安装位置,pncode PN码,'+
                         ' buildingid,suburbid,areaid,cityid'+
                         ' from mtu_info_view t where 1=1 @param1 order by mtuname';
  SqlStr_Common[2,25] := 'select taskid 任务编号,comname as 命令名称,status,statusname as 任务状态,'+
                         ' testresult as 测试结果,asktime as 请求测试时间, '+
                         ' rectime as 接收测试结果时间,mtuno as MTU名称,buildingname as 所属室分点,'+
                         ' username as 用户名,comid,mtuid,buildingid,cityid '+
                         ' from mtu_testtask_online_view t where 1=1 @param1 and userid<>-1 and status<>7 order by taskid desc';

  SqlStr_Common[2,26]:=  'select cdmaid,cdmano as C网信源编号 ,cdmaname  as C网信源名称,'+
                         ' cdmatypename as C网信源类型,address as C网信源安装位置,cover as C网信源覆盖范围,'+
                         ' factorytypename as C网信源厂家,devicetypename as 信源设备型号,'+
                         ' belong_msc as 归属MSC编号,belong_bsc as 归属BSC编号,'+
                         ' belong_cell as 归属扇区编号, belong_bts as 归属基站编号,'+
                         ' pncode as PN码,powertypename as C网信源功率,buildingname as 所属室分点,buildingid'+
                         ' from cdma_info_view t  where 1=1 @Param1 order by cdmaname';
  SqlStr_Common[2,27]:='select buildingid, buildingname from building_info'+
                       ' where areaid in (select id from (select * from area_info '+
                       ' start with id=@Param1 CONNECT BY PRIOR id=top_id) '+
                       ' where layer=3) order by buildingname ';
  SqlStr_Common[2,28]:='select SWITCHID,SWITCHNO as 交换机器编号,MACADDR as 物理地址,MANAGEADDR as 管理地址,UPLINKPORT as 上联端口,POP as pop,buildingname as 所属室分点,buildingid '+
                         ' from switch_info_view  t where 1=1 @param1 order by SWITCHNO';
  SqlStr_Common[2,29]:='select t.linkid,t.linkno as 连接器编号,t.linkaddr as 连接器位置,t.linktype as 连接器类型,t.istrunk as 是否干放,'+
                         ' t.trunkaddr as 干放位置,t.linkequipment as 连接设备类型,t.linkcs as 连接基站,t.linkap as 连接AP,'+
                         ' t.buildingname as 所属室分点,t.buildingid from linkmachine_info_view t where 1=1 @param1 order by linkno';
  SqlStr_Common[2,30]:='select t.mtuid,t.mtuno as MTU编号,t.mtuname as MTU名称,t.mtutypename as MTU类型,t.mtuaddr as MTU位置,t.overlay as 覆盖区域,'+
                       't.call as 电话号码,t.called as 被叫号码,t.linkno as 上端连接器,t.mtustatus as 是否屏蔽,t.modelname as 告警门限模板,'+
                       't.buildingname as 所属室分点,t.buildingid from mtu_info_view t where 1=1 @param1 order by t.mtuno ';
  SqlStr_Common[2,31]:='select t.csid,t.CS_ID,t.SURVERY_ID as 堪点编号,t.cs_type as 基站类型,t.NETADDRESS as 网元信息,'+
                       ' t.CSADDR as 基站地址,t.CS_COVER as 覆盖范围,t.buildingname as 所属室分点,t.buildingid '+
                       ' from cs_info_view t where 1=1 @param1 order by t.cs_id';
  SqlStr_Common[2,32]:='select t.apid,t.apno as 接入点编号,t.connecttypename as 连接类型,t.apport as 对应端口,t.factoryname as 供应商,'+
                       ' t.apkindname as AP型号,t.appropertyname as AP性质,t.appower as 功率,t.powerkindname as 供电方式 ,'+
                       ' t.frequency as 频点,t.APaddr as AP地址,t.overlay as 覆盖范围,t.manageaddrseg as AP管理地址段,'+
                       ' t.apip as APIP,t.gwaddr as 网关地址,t.macaddr as MAC地址,t.businessvlan as 业务VLAN,t.managevlan as 管理VLAN,'+
                       ' t.switchno as 所属交换机,t.buildingname as 所属室分点,t.switchid ,t.buildingid'+
                       ' from ap_info_view t where 1=1 @param1 order by apno';
  SqlStr_Common[2,33]:='select mtuid , mtuname ,mtuno from mtu_info_view';
  SqlStr_Common[2,34]:='select mtuid , mtuname,mtuno  from mtu_info_view where cityid=@param1';
  SqlStr_Common[2,35]:='select mtuid , mtuname,mtuno from mtu_info_view where areaid=@param1';
  SqlStr_Common[2,36] := 'select mtuname,mtuno,overlay,mtuaddr,call,called,mtustatus,power_chin,'+
                         ' wlan_chin,linkno,buildingname from mtu_info_view where 1=1 and mtuid=@param1';
//  SqlStr_Common[2,37] := 'select t1.taskid,max(case  when t1.paramid=1 then t1.testresult else null end ) as mtuno,t5.comname,'+
//                         ' t1.collecttime,max(case  when t1.paramid=15 then t1.testresult else null end ) as csid,'+
//                         ' max(case  when t1.paramid=4 then t1.testresult else null end ) as cchfield from  @param1 t1'+
//                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
//                         ' where exists (select 1 from'+
//                         ' (select taskid,row_number() over (order by t2.taskid desc) rn from  mtu_testresult_online t2) t3'+
//                         ' where t1.taskid=t3.taskid and rn<=@param3 and t1.mtuid=@param2) and t1.comid=66'+
//                         ' group by t1.taskid,t5.comname,t1.collecttime';
  SqlStr_Common[2,37] := ' select * from (select t1.taskid,t4.mtuno,t5.comname,'+
                         ' t1.collecttime,max(case  when t1.paramid=15 then t1.testresult else null end ) as csid,'+
                         ' max(case  when t1.paramid=4 then t1.testresult else null end ) as cchfield'+
                         ' from  @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.comid=66 and t1.mtuid=@param2'+
                         ' group by t1.taskid,t5.comname,t1.collecttime,t1.valueindex,t4.mtuno'+
                         ' order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,38] := 'select * from (select t1.taskid,t4.mtuno,t5.comname,'+
                         ' t1.collecttime,max(case  when t1.paramid=1003 then t1.testresult else null end ) as apid,'+
                         ' max(case  when t1.paramid=1004 then t1.testresult else null end ) as signid,'+
                         ' max(case  when t1.paramid=24 then t1.testresult else null end ) as wlanfield'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=67'+
                         ' group by t1.taskid,t5.comname,t1.collecttime,t1.valueindex,t4.mtuno'+
                         ' order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,39] := 'select * from (select q4.*,q2.csswitchcount,q2.tchswitchcount,q3.csid,q3.tchfield,q3.wrongper'+
                         ' from (select q1.taskid,q1.mtuno,q1.comname,q1.call,q1.called,q1.starttime,q1.endtime,q1.intime,q1.calltime,q1.calllong,q1.lastcsid,t10.tranlatevalue as calltest,t11.tranlatevalue as callresult'+
                         ' from (select t1.taskid,t4.mtuno,t5.comname,max(case  when t1.paramid=6 then t1.testresult else null end ) as call,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as called,max(case  when t1.paramid=2 then t1.testresult else null end ) as starttime,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as endtime,max(case  when t1.paramid=13 then t1.testresult else null end ) as intime,'+
                         ' max(case  when t1.paramid=14 then t1.testresult else null end ) as calltime,max(case  when t1.paramid=8 then t1.testresult else null end ) as calllong,'+
                         ' max(case  when t1.paramid=15 then t1.testresult else null end ) as lastcsid,'+
                         ' max(case  when t1.paramid=16 then t1.testresult else ''-1'' end) as calltest,'+
                         ' max(case  when t1.paramid=17 then t1.testresult else ''-1'' end) as callresult'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=129 group by t1.taskid,t4.mtuno,t5.comname) q1'+
                         ' left join mtu_testresult_translate t10 on t10.comid=129 and t10.paramid=16 and t10.orderindex=q1.calltest'+
                         ' left join mtu_testresult_translate t11 on t11.comid=129 and t11.paramid=17 and t11.orderindex=q1.callresult)q4'+
                         ' left join (select a1.taskid,max(case  when a1.paramid=1008 then a1.testresult else null end ) as csswitchcount,'+
                         ' max(case  when a1.paramid=1007 then a1.testresult else null end ) as tchswitchcount from @param1 a1'+
                         ' where a1.mtuid=@param2 and a1.comid=131 group by a1.taskid) q2 on q4.taskid=q2.taskid'+
                         ' left join (select b1.taskid,max(case  when b1.paramid=15 then b1.testresult else null end) as csid,'+
                         ' max(case  when b1.paramid=18 then b1.testresult else null end) as tchfield,'+
                         ' max(case  when b1.paramid=1002 then b1.testresult else null end) as wrongper'+
                         ' from @param1 b1'+
                         ' where b1.mtuid=@param2 and b1.comid=130 group by b1.taskid,b1.valueindex) q3'+
                         ' on q4.taskid=q3.taskid order by q4.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,40] := 'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.主叫号码,a.被叫号码,a.测试开始时间,'+
                         ' a.测试结束时间,a.collecttime as 采集时间,a.通话时长,a.播放的语音文件,a.录音产生的语音文件名,t10.tranlatevalue as 测试结果'+
                         ' from (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=6 then t1.testresult else null end ) as 主叫号码,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as 被叫号码,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as 测试结束时间,'+
                         ' max(case  when t1.paramid=8 then t1.testresult else null end ) as 通话时长,'+
                         ' max(case  when t1.paramid=21 then t1.testresult else null end ) as 播放的语音文件,'+
                         ' max(case  when t1.paramid=22 then t1.testresult else null end ) as 录音产生的语音文件名,'+
                         ' max(case  when t1.paramid=23 then t1.testresult else ''-1'' end) as 测试结果 from  @param1 t1'+
                         ' left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=132 group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname )a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=132 and t10.paramid=23 and t10.orderindex=a.测试结果'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,41] := 'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.主叫号码,a.被叫号码,a.测试开始时间,'+
                         ' a.测试结束时间,a.collecttime as 采集时间,a.接入时延,a.通话时延,a.通话时长,t10.tranlatevalue as 呼叫结果,t11.tranlatevalue as 语音结果'+
                         ' from (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=6 then t1.testresult else null end ) as 主叫号码,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as 被叫号码,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as 测试结束时间,'+
                         ' max(case  when t1.paramid=13 then t1.testresult else null end ) as 接入时延,'+
                         ' max(case  when t1.paramid=14 then t1.testresult else null end ) as 通话时延,'+
                         ' max(case  when t1.paramid=8 then t1.testresult else null end ) as 通话时长,'+
                         ' max(case  when t1.paramid=17 then t1.testresult else ''-1'' end) as 呼叫结果,'+
                         ' max(case  when t1.paramid=44 then t1.testresult else ''-1'' end) as 语音结果 from  @param1 t1'+
                         ' left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=137 group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=137 and t10.paramid=17 and t10.orderindex=a.呼叫结果'+
                         ' left join mtu_testresult_translate t11 on t11.comid=137 and t11.paramid=44 and t11.orderindex=a.语音结果'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,42] := 'select * from (select t1.taskid as 任务编号,t4.mtuno as MTU编号,t5.comname as 测试命令,'+
                         ' max(case  when t1.paramid=6 then t1.testresult else null end ) as 主叫号码,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as 被叫号码,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as 测试结束时间,t1.collecttime as 采集时间,'+
                         ' max(case  when t1.paramid=13 then t1.testresult else null end ) as 接入时延'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=133'+
                         ' group by t1.taskid,t1.collecttime,t4.mtuno,t5.comname order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,43] := 'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.测试开始时间,a.测试结束时间,a.collecttime as 采集时间,a.测试时长,'+
                         ' a.上传速率,a.下载速率,t10.tranlatevalue as 测试结果 from '+
                         ' (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as 测试结束时间,'+
                         ' max(case  when t1.paramid=28 then t1.testresult else null end ) as 测试时长,'+
                         ' max(case  when t1.paramid=25 then t1.testresult else null end ) as 上传速率,'+
                         ' max(case  when t1.paramid=26 then t1.testresult else null end ) as 下载速率,'+
                         ' max(case  when t1.paramid=23 then t1.testresult else ''-1'' end) as 测试结果'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=134 group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=134 and t10.paramid=23 and t10.orderindex=a.测试结果'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,44] := 'select * from (select t1.taskid as 任务编号,t4.mtuname as MTU编号,t5.comname as 测试命令,'+
                         ' max(case  when t1.paramid=41 then t1.testresult else null end ) as Ping目标地址,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,'+
                         ' t1.collecttime as 采集时间,'+
                         ' max(case  when t1.paramid=28 then t1.testresult else null end ) as 测试时长,'+
                         ' max(case  when t1.paramid=29 then t1.testresult else null end ) as 发送的数据包数,'+
                         ' max(case  when t1.paramid=30 then t1.testresult else null end ) as 接收到的数据包数,'+
                         ' max(case  when t1.paramid=31 then t1.testresult else null end ) as 最大时延,'+
                         ' max(case  when t1.paramid=32 then t1.testresult else null end ) as 最小时延,'+
                         ' max(case  when t1.paramid=33 then t1.testresult else null end ) as 平均时延,'+
                         ' max(case  when t1.paramid=34 then t1.testresult else null end ) as 误码率'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=135'+
                         ' group by t1.taskid,t1.collecttime,t4.mtuname,t5.comname order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,45] := 'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.通知时间,a.collecttime as 采集时间,t10.tranlatevalue as 通知内容 from'+
                         ' (select t1.taskid,t4.mtuno,t5.comname,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 通知时间,t1.collecttime,'+
                         ' max(case  when t1.paramid=42 then t1.testresult else ''-1'' end) as 通知内容'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=69 group by t1.taskid,t5.comname,t1.collecttime,t4.mtuno)a '+
                         ' left join mtu_testresult_translate t10 on t10.comid=69 and t10.paramid=42 and t10.orderindex=a.通知内容'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,46] := 'select a.taskid as 任务编号,a.MTU编号,a.测试命令,a.检测时间,a.collecttime as 采集时间,t10.tranlatevalue as 电源状态 from'+
                         ' (select t1.collecttime,t1.taskid,t4.mtuno as MTU编号,t5.comname as 测试命令,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 检测时间,'+
                         ' max(case  when t1.paramid=3 then t1.testresult else null end ) as powerstatus'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=65 group by t1.taskid,t5.comname,t1.collecttime,t4.mtuno )a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=65 and t10.paramid=3 and t10.orderindex=a.powerstatus'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,47] := 'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.collecttime as 采集时间,t10.tranlatevalue as MTU状态'+
                         ' from (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=35 then t1.testresult else null end ) as MTU状态'+
                         ' from  @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=136'+
                         ' group by t1.taskid,t4.mtuno,t5.comname,t1.collecttime)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=68 and t10.paramid=35 and t10.orderindex=a.MTU状态'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,48] := 'select table_name from user_tables where table_name=@param1';
  SqlStr_Common[2,49] := 'select * from (select t1.taskid,t1.collecttime as 检测时间,max(case  when t1.paramid=1005 then t1.testresult else ''0'' end ) as 最大场强值'+
                         ' from @param1 t1 where t1.mtuid=@param2 and t1.comid=66 group by t1.taskid,t1.collecttime'+
                         ' order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,50] := 'select * from (select t1.taskid,t1.collecttime as 检测时间,max(case  when t1.paramid=1009 then t1.testresult else ''0'' end ) as 最大场强值'+
                         ' from @param1 t1 where t1.mtuid=@param2 and t1.comid=67 group by t1.taskid,t1.collecttime'+
                         ' order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,51] := 'select * from (select PARENTMODELID,MODELID,MODELNAME,CYCCOUNT,TIMEINTERVAL,PLANDATE from MTU_AUTOTEST_Model'+
                         ' union all select 0,999999,''未制定计划MTU'',0,0,null from dual) order by ParentModelID,MODELID';


  SqlStr_Common[2,52] := 'select a.mtuid,mtuname,mtuno,overlay,mtuaddr,call,called, '+
                         'MTUSTATUS,updatetime,linkno,buildingname,buildingid,decode(b.mtuid,null,0,1) as flag,c.MODELNAME,'+
                         'isprogramname,cdmaaddress,mainlook_apname,mainlook_phsname,mainlook_cnetname,pncode,cdmatypename'+
                         ' from mtu_info_view a'+
                         ' inner join mtu_autotest_modelmtu_relation b on a.mtuid=b.mtuid @param1'+
                         ' inner join mtu_autotest_model c on b.MODELID=c.MODELID'+
                         ' where 1=1 @param2';
                         {'select mtuid,mtuname as MTU名称,mtuno as MTU外部编号,overlay as 覆盖区域,'+
                         'mtuaddr as MTU位置,call as 电话号码,called as 被叫号码, '+
                         'MTUSTATUS as MTU状态,updatetime 状态变更时间,linkno as 连接器,'+
                         'buildingname as 所属室分点,buildingid,decode(b.mtuid,null,0,1) as flag'+
                         ' from mtu_info_view a'+
                         ' left join mtu_autotest_modelmtu_relation b on a.mtuid=b.mtuid'+
                         ' where 1=1 @param1';}

  SqlStr_Common[2,53] := 'select t.comid,t.comname from mtu_command_define t'+
                         ' where t.comtype=1 and t.ifineffect=1 and t.comid<>9 order by t.comid';
  SqlStr_Common[2,54] := 'select t.modelid,t.modelname from mtu_autotest_model t'+
                         ' where t.parentmodelid not in (0,1)';
  SqlStr_Common[2,55] := //'select a.mtuid,b.comid,b.paramid,b.paramvalue,d.comname,e.paramname'+
//                         ' from mtu_info a'+
//                         ' left join mtu_userparam_config c on a.mtuid=c.mtuid'+
//                         ' inner join  (select t1.mtuid,t1.comid,t1.paramid,t1.paramvalue from mtu_userparam_config t1'+
//                         '              union all select -1,t2.comid,t2.paramid,t2.paramvalue from mtu_autotestparam_config t2) b'+
//                         '              on  nvl(c.mtuid,-1)=b.mtuid'+
//                         ' inner join mtu_command_define d on b.comid=d.comid'+
//                         ' inner join mtu_param_define e on b.paramid=e.paramid'+
//                         ' where 1=1 @param1';
                         'select * from mtu_testparam_view t where 1=1 @param1';
  SqlStr_Common[2,56]:=  'select * from mtu_autotest_modelmtu_relation where 1=1 @param1';
  SqlStr_Common[2,57]:= 'select * from mtu_autotest_cmd t where 1=1 @param1';
  SqlStr_Common[2,58]:= 'select q1.*,q2.csswitchcount,q2.tchswitchcount,q3.tchfield'+
                        ' (select t1.taskid,t4.mtuname,t5.comname,max(case  when t1.paramid=6 then t1.testresult else null end ) as call,'+
                        ' max(case  when t1.paramid=7 then t1.testresult else null end ) as called,max(case  when t1.paramid=2 then t1.testresult else null end ) as starttime,'+
                        ' max(case  when t1.paramid=12 then t1.testresult else null end ) as endtime,max(case  when t1.paramid=13 then t1.testresult else null end ) as intime,'+
                        ' max(case  when t1.paramid=14 then t1.testresult else null end ) as calltime,max(case  when t1.paramid=8 then t1.testresult else null end ) as calllong,'+
                        ' max(case  when t1.paramid=15 then t1.testresult else null end ) as lastcsid,max(case  when t1.paramid=16 then t1.testresult else null end ) as calltest,'+
                        ' max(case  when t1.paramid=17 then t1.testresult else null end ) as callresult from  @param1 t1'+
                        ' left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                        ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where t1.mtuid=@param2 and t1.comid=129'+
                        ' group by t1.taskid,t4.mtuname,t5.comname) q1'+
                        ''+
                        '';
  SqlStr_Common[2,59]:= 'select t1.taskid,max(case  when t1.paramid=1 then t1.testresult else null end ) as mtuno,t5.comname,'+
                        ' t1.collecttime,max(case  when t1.paramid=15 then t1.testresult else null end ) as csid,'+
                        ' max(case  when t1.paramid=4 then t1.testresult else null end ) as cchfield from  @param1 t1'+
                        ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where  t1.mtuid=@param2 and t1.comid=66'+
                        ' group by t1.taskid,t5.comname,t1.collecttime';
  SqlStr_Common[2,60]:= 'select t1.taskid,max(case  when t1.paramid=1 then t1.testresult else null end ) as mtuno,t5.comname,'+
                        ' t1.collecttime,max(case  when t1.paramid=1003 then t1.testresult else null end ) as apid,'+
                        ' max(case  when t1.paramid=24 then t1.testresult else null end ) as wlanfield from  @param1 t1'+
                        ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where t1.mtuid=@param2 and t1.comid=67'+
                        ' group by t1.taskid,t5.comname,t1.collecttime';
  SqlStr_Common[2,61]:= 'select a.modelid,a.modelname,a.plandate,'+
                        ' b.begintime,b.endtime,b.comid,b.cyccount,b.timeinterval,b.id'+
                        ' from mtu_autotest_model a'+
                        ' inner join mtu_autotest_modeltimecom b on a.modelid=b.modelid'+
                        ' where 1=1 @param1';

  SqlStr_Common[2,62]:= 'select * from mtu_userparam_config t where 1=1 @param1';
  SqlStr_Common[2,63]:= 'select t.mtuid,t.mtuno,t.mtuname,t.mtuaddr,t.mainlook_cnet from mtu_info_view t where 1=1 @param1';
  SqlStr_Common[2,64]:= 'select itemcode, itemkind, itemcontent, setvalue, itemnote from sys_param_config where itemkind=3 and itemcode=1';
  SqlStr_Common[2,65] := 'select a.mtuid,mtuname,mtuno,overlay,mtuaddr,call,called, '+
                         'MTUSTATUS,updatetime,linkno,buildingname,buildingid,decode(b.mtuid,null,0,1) as flag,c.MODELNAME,'+
                         'isprogramname,cdmaaddress,mainlook_apname,mainlook_phsname,mainlook_cnetname,pncode,cdmatypename'+
                         ' from mtu_info_view a'+
                         ' left join mtu_autotest_modelmtu_relation b on a.mtuid=b.mtuid @param1'+
                         ' left join mtu_autotest_model c on b.MODELID=c.MODELID'+
                         ' where 1=1 @param2 order by c.MODELNAME';
  SqlStr_Common[2,66] := 'select a.mtuid,mtuname,mtuno,overlay,mtuaddr,call,called, '+
                         'MTUSTATUS,updatetime,linkno,buildingname,buildingid,decode(b.mtuid,null,0,1) as flag,null as MODELNAME,'+
                         'isprogramname,cdmaaddress,mainlook_apname,mainlook_phsname,mainlook_cnetname,pncode,cdmatypename'+
                         ' from mtu_info_view a'+
                         ' left join mtu_autotest_modelmtu_relation b on a.mtuid=b.mtuid @param1'+
                         ' where 1=1 @param2 and b.mtuid is null';
  SqlStr_Common[2,67] := 'select * from mtu_autotest_param where 1=1 @param1';
  SqlStr_Common[2,68] := 'delete from mtu_autotest_param a where exists (select 1 from mtu_autotest_cmd b where a.testgroupid=b.testgroupid @param1)';
  SqlStr_Common[2,69] := 'delete from mtu_autotest_cmd where 1=1 @param1';
  SqlStr_Common[2,70] := ' insert into mtu_autotest_cmd'+
                         ' (testgroupid, mtuid, comid, asktime, time_interval, curr_cyccount, cyccounts, operstatus, begintime, endtime, plandate, modelid, ifpause)'+
                         ' select @param1,c.mtuid,b.comid,sysdate,b.timeinterval,0,b.cyccount,0,b.begintime,b.endtime,a.plandate,a.modelid,nvl(c.ISPAUSE,0)'+
                         ' from mtu_autotest_model a'+
                         ' inner join mtu_autotest_modeltimecom b on a.modelid=b.modelid'+
                         ' inner join MTU_AUTOTEST_MODELMTU_RELATION c on a.modelid=c.modelid'+
                         ' where a.modelid=@param2 and c.mtuid=@param3 and b.id=@param4';
  SqlStr_Common[2,71] := 'insert into mtu_autotest_param'+
                         ' (testgroupid, comid, paramid, paramvalue)'+
                         ' select @param1,a.comid,a.paramid,a.paramvalue'+
                         ' from mtu_testparam_view a'+
                         ' where a.mtuid=@param2 and a.comid=@param3';
  SqlStr_Common[2,72] := 'select * from mtu_autotest_cmd where 1=1 @param1';
  SqlStr_Common[2,73] := 'insert into mtu_testtask_online'+
                         ' (taskid, cityid, mtuid, comid, status, testresult, asktime,'+
                         ' sendtime, rectime, tasklevel, userid, modelid)'+
                         ' select @param1,@param2,@param3,@param4,0,null,sysdate,null,null,1,@param5,null from dual';
  SqlStr_Common[2,74] := 'insert into mtu_testtaskparam_online'+
                         ' (taskid, paramid, paramvalue)'+
                         ' select @param1,a.paramid,a.paramvalue'+
                         ' from mtu_testparam_view a where a.mtuid=@param2 and a.comid=@param3';
//  SqlStr_Common[2,76] := 'select t.cdmaid,t.cdmaname from cdma_info t'+
//                         ' where t.cdmaid=@param1';
  SqlStr_Common[2,76] := 'select id,name||''(''||decode(CDMATYPE,1,''直放站'',2,''RRU'',3,''宏基站'')||'')'' as cdmaname from' +
                          ' (select a.cdmaid as id,a.cdmaname as name,CDMATYPE from cdma_info a' +
                          '  union' +
                          ' select b.drsid as id,b.drsname as name,1 from drs_info b' +
                          ') t' +
                          ' where t.id=@param1';

  SqlStr_Common[2,77] := 'select drsid,drsname||''(''||drsstatusname||'')'' as drsname from drs_info_view ' +
                         ' where isprogram=1 @param1 order by drsID';
  SqlStr_Common[2,78] := 'select drsid,drsname||''(''||drsstatusname||'')'' as drsname from drs_info_view' +
                         ' where isprogram=0 @param1 order by drsID';
  SqlStr_Common[2,79] := ' select id,layer,nvl(prior a.id,0) as top_id' +
                         '      ,decode(a.drsstatusname,''直放站类型'',1,''直放站状态'',1,2) as layer' +
                         '      ,a.drsstatusname||''(''||counts||'')'' as name' +
                         '  from' +
                         ' (' +
                         '  select b.*,rownum as id from' +
                         '  (' +
                         '    (select ''直放站状态'' as drsstatusname,count(*) as counts,'''' as topname,1 as layer from drs_info_view' +
                         '      where 1=1 @Param1' +
                         '     union' +
                         '     select drsstatusname,count(*) as counts,''直放站状态'' as topname,2 as layer from drs_info_view' +
                         '      where 1=1 @Param1' +
                         '      group by drsstatusname' +
                         '     )' +
                         '     union' +
                         '    (select ''直放站类型'' as drsstatusname,count(*) as counts,'''' as topname,1 as layer from drs_info_view' +
                         '      where 1=1 @Param1' +
                         '     union' +
                         '     select drstypename,count(*) as counts,''直放站类型'' as topname,2 as layer from drs_info_view' +
                         '      where 1=1 @Param1' +
                         '      group by drstypename)' +
                         '  )b' +
                         ' )a' +
                         ' connect by prior drsstatusname=topname start with (drsstatusname=''直放站类型'' or drsstatusname=''直放站状态'')';
  SetLength(SqlStr_Common[3], SQLCount);
  SqlStr_Common[3,1] := 'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.主叫号码,a.被叫号码,a.测试开始时间,'+
                        ' a.测试结束时间,a.collecttime as 采集时间,a.通话时长,a.播放的语音文件,a.录音产生的语音文件名,t10.tranlatevalue as 测试结果'+
                        ' from (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,max(case  when t1.paramid=6 then t1.testresult else null end ) as 主叫号码,'+
                        ' max(case  when t1.paramid=7 then t1.testresult else null end ) as 被叫号码,max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,'+
                        ' max(case  when t1.paramid=12 then t1.testresult else null end ) as 测试结束时间,max(case  when t1.paramid=8 then t1.testresult else null end ) as 通话时长,'+
                        ' max(case  when t1.paramid=21 then t1.testresult else null end ) as 播放的语音文件,max(case  when t1.paramid=22 then t1.testresult else null end ) as 录音产生的语音文件名,'+
                        ' max(case  when t1.paramid=23 then t1.testresult else ''-1'' end) as 测试结果 from @param1 t1'+
                        ' left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where t1.mtuid=@param2 and t1.comid=132 and t1.collecttime @param3'+
                        ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                        ' left join mtu_testresult_translate t10 on t10.comid=132 and t10.paramid=23 and t10.orderindex=a.测试结果'+
                        ' order by a.collecttime desc';
  SqlStr_Common[3,2] := 'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.主叫号码,a.被叫号码,a.测试开始时间,'+
                        ' a.测试结束时间,a.collecttime as 采集时间,a.接入时延,a.通话时延,a.通话时长,t10.tranlatevalue as 呼叫结果,t11.tranlatevalue as 语音结果'+
                        ' from (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,'+
                        ' max(case  when t1.paramid=6 then t1.testresult else null end ) as 主叫号码,max(case  when t1.paramid=7 then t1.testresult else null end ) as 被叫号码,'+
                        ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,max(case  when t1.paramid=12 then t1.testresult else null end ) as 测试结束时间,'+
                        ' max(case  when t1.paramid=13 then t1.testresult else null end ) as 接入时延,max(case  when t1.paramid=14 then t1.testresult else null end ) as 通话时延,'+
                        ' max(case  when t1.paramid=8 then t1.testresult else null end ) as 通话时长,max(case  when t1.paramid=17 then t1.testresult else ''-1'' end) as 呼叫结果,'+
                        ' max(case  when t1.paramid=44 then t1.testresult else ''-1'' end) as 语音结果 from  @param1 t1'+
                        ' left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                        ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where t1.mtuid=@param2 and t1.comid=137 and t1.collecttime @param3'+
                        ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                        ' left join mtu_testresult_translate t10 on t10.comid=137 and t10.paramid=17 and t10.orderindex=a.呼叫结果'+
                        ' left join mtu_testresult_translate t11 on t11.comid=137 and t11.paramid=44 and t11.orderindex=a.语音结果'+
                        ' order by a.collecttime desc';
  SqlStr_Common[3,3] := 'select t1.taskid as 任务编号,t4.mtuno as MTU编号,t5.comname as 测试命令,max(case  when t1.paramid=6 then t1.testresult else null end ) as 主叫号码,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as 被叫号码,max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as 测试结束时间,t1.collecttime as 采集时间,max(case  when t1.paramid=13 then t1.testresult else null end ) as 接入时延'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=133 and t1.collecttime @param3'+
                         ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname order by t1.collecttime desc';
  SqlStr_Common[3,4] := 'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.测试开始时间,a.测试结束时间,a.collecttime as 采集时间,a.测试时长,a.上传速率,a.下载速率,t10.tranlatevalue as 测试结果'+
                        ' from (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,'+
                        ' max(case  when t1.paramid=12 then t1.testresult else null end ) as 测试结束时间,max(case  when t1.paramid=28 then t1.testresult else null end ) as 测试时长,'+
                        ' max(case  when t1.paramid=25 then t1.testresult else null end ) as 上传速率,max(case  when t1.paramid=26 then t1.testresult else null end ) as 下载速率,'+
                        ' max(case  when t1.paramid=23 then t1.testresult else ''-1'' end) as 测试结果'+
                        ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                        ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where t1.mtuid=@param2 and t1.comid=134 and t1.collecttime @param3'+
                        ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                        ' left join mtu_testresult_translate t10 on t10.comid=134 and t10.paramid=23 and t10.orderindex=a.测试结果'+
                        ' order by a.collecttime desc';
  SqlStr_Common[3,5] := 'select t1.taskid as 任务编号,t4.mtuno as MTU编号,t5.comname as 测试命令,max(case  when t1.paramid=41 then t1.testresult else null end ) as Ping目标地址,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 测试开始时间,t1.collecttime as 采集时间,max(case  when t1.paramid=28 then t1.testresult else null end ) as 测试时长,'+
                         ' max(case  when t1.paramid=29 then t1.testresult else null end ) as 发送的数据包数,max(case  when t1.paramid=30 then t1.testresult else null end ) as 接收到的数据包数,'+
                         ' max(case  when t1.paramid=31 then t1.testresult else null end ) as 最大时延,max(case  when t1.paramid=32 then t1.testresult else null end ) as 最小时延,'+
                         ' max(case  when t1.paramid=33 then t1.testresult else null end ) as 平均时延,max(case  when t1.paramid=34 then t1.testresult else null end ) as 误码率'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=135 and t1.collecttime @param3'+
                         ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname order by t1.collecttime desc';
  SqlStr_Common[3,6] :=  'select a.taskid as 任务编号,a.mtuno as MTU编,a.comname as 测试命令,a.通知时间,a.collecttime as 采集时间,t10.tranlatevalue as 通知内容 from'+
                         ' (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 通知时间,'+
                         ' max(case  when t1.paramid=42 then t1.testresult else ''-1'' end) as 通知内容'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=69 and t1.collecttime @param3'+
                         ' group by t1.taskid,t1.collecttime,t4.mtuno,t5.comname) a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=69 and t10.paramid=42 and t10.orderindex=a.通知内容 order by a.collecttime desc';
  SqlStr_Common[3,7] :=  'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.检测时间,a.collecttime as 采集时间,t10.tranlatevalue as 电源状态 from'+
                         ' (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as 检测时间,'+
                         ' max(case  when t1.paramid=3 then t1.testresult else null end ) as powerstatus'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=65 and t1.collecttime @param3'+
                         ' group by t1.taskid,t1.collecttime,t4.mtuno,t5.comname)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=65 and t10.paramid=3 and t10.orderindex=a.powerstatus order by a.collecttime desc';
  SqlStr_Common[3,8] :=  'select a.taskid as 任务编号,a.mtuno as MTU编号,a.comname as 测试命令,a.collecttime as 采集时间,t10.tranlatevalue as MTU状态'+ 
                         ' from (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=35 then t1.testresult else null end ) as MTU状态'+
                         ' from  @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=136 and t1.collecttime @param3'+
                         ' group by t1.taskid,t4.mtuno,t5.comname,t1.collecttime)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=68 and t10.paramid=35 and t10.orderindex=a.MTU状态'+
                         ' order by a.collecttime desc';
  SqlStr_Common[3,9] :=   'select q4.*,q2.csswitchcount,q2.tchswitchcount,q3.csid,q3.tchfield,q3.wrongper'+
                          ' from (select q1.taskid,q1.mtuno,q1.comname,q1.collecttime,q1.call,q1.called,q1.starttime,q1.endtime,q1.intime,q1.calltime,q1.calllong,q1.lastcsid,t10.tranlatevalue as calltest,t11.tranlatevalue as callresult'+
                          ' from (select t1.taskid,t1.collecttime,t4.mtuno,t5.comname,max(case  when t1.paramid=6 then t1.testresult else null end ) as call,'+
                          ' max(case  when t1.paramid=7 then t1.testresult else null end ) as called,max(case  when t1.paramid=2 then t1.testresult else null end ) as starttime,'+
                          ' max(case  when t1.paramid=12 then t1.testresult else null end ) as endtime,max(case  when t1.paramid=13 then t1.testresult else null end ) as intime,'+
                          ' max(case  when t1.paramid=14 then t1.testresult else null end ) as calltime,max(case  when t1.paramid=8 then t1.testresult else null end ) as calllong,'+
                          ' max(case  when t1.paramid=15 then t1.testresult else null end ) as lastcsid,'+
                          ' max(case  when t1.paramid=16 then t1.testresult else ''-1'' end) as calltest,'+
                          ' max(case  when t1.paramid=17 then t1.testresult else ''-1'' end) as callresult'+
                          ' from  @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                          ' where t1.mtuid=@param2 and t1.comid=129 and t1.collecttime @param3'+
                          ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname) q1'+
                          ' left join mtu_testresult_translate t10 on t10.comid=129 and t10.paramid=16 and t10.orderindex=q1.calltest'+
                          ' left join mtu_testresult_translate t11 on t11.comid=129 and t11.paramid=17 and t11.orderindex=q1.callresult)q4'+
                          ' left join (select a1.taskid,a1.collecttime,max(case  when a1.paramid=1008 then a1.testresult else null end ) as csswitchcount,'+
                          ' max(case  when a1.paramid=1007 then a1.testresult else null end ) as tchswitchcount from @param1 a1'+
                          ' where a1.mtuid=@param2 and a1.comid=131 and a1.collecttime @param3 group by a1.taskid,a1.collecttime) q2'+
                          ' on q4.taskid=q2.taskid left join (select b1.taskid,max(case  when b1.paramid=15 then b1.testresult else null end) as csid,'+
                          ' max(case  when b1.paramid=18 then b1.testresult else null end) as tchfield,'+
                          ' max(case  when b1.paramid=1002 then b1.testresult else null end) as wrongper'+
                          ' from @param1 b1 where b1.mtuid=@param2 and b1.comid=130 and b1.collecttime @param3 group by b1.taskid,b1.valueindex) q3'+
                          ' on q4.taskid=q3.taskid order by q4.collecttime desc';
  SqlStr_Common[3,10] := 'select t1.taskid,t4.mtuno,t5.comname,'+
                         ' t1.collecttime,max(case  when t1.paramid=15 then t1.testresult else null end ) as csid,'+
                         ' max(case  when t1.paramid=4 then t1.testresult else null end ) as cchfield from  @param1 t1'+
                         ' left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=66 and t1.collecttime @param3'+
                         ' group by t1.taskid,t4.mtuno,t5.comname,t1.valueindex,t1.collecttime  order by t1.collecttime desc';
  SqlStr_Common[3,11] := 'select t1.taskid,t4.mtuno,t5.comname,'+
                         ' t1.collecttime,max(case  when t1.paramid=1003 then t1.testresult else null end ) as apid,'+
                         ' max(case  when t1.paramid=1004 then t1.testresult else null end ) as signid,'+
                         ' max(case  when t1.paramid=24 then t1.testresult else null end ) as wlanfield from  @param1 t1'+
                         ' left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=67 and t1.collecttime @param3'+
                         ' group by t1.taskid,t4.mtuno,t5.comname,t1.valueindex,t1.collecttime order by t1.collecttime desc';
  SqlStr_Common[3,21] := 'select t3.tranlatevalue as now_status,t2.tranlatevalue as power_status,t4.tranlatevalue as wlan_status from mtu_status_list t1'+
                         ' left join mtu_testresult_translate t2 on t1.status_power=t2.orderindex'+
                         ' left join mtu_testresult_translate t3 on t1.status=t3.orderindex'+
                         ' left join mtu_testresult_translate t4 on t1.status=t4.orderindex'+
                         ' where t1.mtuid=@param1 and t2.comid=65 and t2.paramid=3 and t3.comid=68 and t3.paramid=35 and t4.comid=69 and t4.paramid=42';
  SqlStr_Common[3,22] := 'select t.mtuid,count(*) as alarmcount from alarm_master_online t where t.flowtache=2 and t.mtuid=@param1 group by t.mtuid';
end;

{**************** 1 源管理SQL语句*******************************
  SqlStr_Resource 存放资源管理用到的SQL语句
*********************************************************************}
procedure Init_SqlStr_Resource();
begin
  //dic_type_info- SqlStr_Common[1]
  SetLength(SqlStr_Resource[1], SQLCount);
  //树图中选省层
  SqlStr_Resource[1,1]:='select CSID 基站编号,SURVERY_ID 勘点编号,NETADDRESS 网元信息,CSADDR 基站地址 from cs_info';


  SqlStr_Resource[1,2]:='select * from building_info';
  SqlStr_Resource[1,3]:='insert into building_info (buildingid,buildingname,buildingno,adress) values (@param1,@param2,@param3,@param4)';
  SqlStr_Resource[1,4]:='select dicname from dic_code_info where dictype=2';
  SqlStr_Resource[1,5]:='select diccode,dictype,dicname from dic_code_info t';
  SqlStr_Resource[1,6]:='select * from building_info t where areaid=@para1';
  SqlStr_Resource[1,7]:='insert into picture_info (picid,picname,picorder,picture,pictype,outid) values (1,1,1,EMPTY_BLOB(),1,1) ';
  SqlStr_Resource[1,8]:='select * from picture_info' ;
  SqlStr_Resource[1,9]:='select pic from mytest where id=1 and name=2';
  SqlStr_Resource[1,10]:='select id,name from area_info t';
  SqlStr_Resource[1,11]:='delete from  picture_info  t where picid=@param1';
  SqlStr_Resource[1,12]:='select max(@param1) max from @param2';
  SqlStr_Resource[1,13]:='select * from building_info t where buildingid=@param1';
  SqlStr_Resource[1,14]:='select * from picture_info t where t.outid=@param1';
  //室内点信息管理 树接点click
  SqlStr_Resource[1,15]:='select buildingid,buildingno as 室分点编号 ,buildingname  as 室分点名称,'+
                         ' address as 地址,longitude as 经度,latitude as 纬度,'+
                         ' nettypename as 所属网络类型,factoryname as 集成厂商, connecttypename as 接入方式,'+
                         ' buildingtypename as 室分点类型,floorcount as 楼层数目,buildingarea as 楼层面积,area as 所属郊县,areaid'+
                         ' from building_info_view t  where t.areaid in  @param1 order by buildingid';
  //室内点信息管理 Grid.click
  SqlStr_Resource[1,16]:='select * from building_info where buildingid=@param1';
  //室内点信息管理 显示图片
  SqlStr_Resource[1,17]:='select * from picture_info t where outid=@PARAM1';
  SqlStr_Resource[1,18]:='select id from area_info t where layer =@param1';
  SqlStr_Resource[1,19]:='select id from area_info t ';      //省
  SqlStr_Resource[1,20]:='select id from area_info t where top_id=@param1';      //市
  //交换机信息管理 树接点click
  SqlStr_Resource[1,21]:='select SWITCHID,SWITCHNO as 交换机器编号,MACADDR as 物理地址,MANAGEADDR as 管理地址,UPLINKPORT as 上联端口,POP as pop,buildingname as 所属室分点,buildingid '+
                         ' from switch_info_view  t where areaid in @param1 order by SWITCHID';
  //交换机信息管理ComboBoxBuildinginof的item
  SqlStr_Resource[1,22]:='select buildingid,buildingname from building_info where areaid in @param1 order by buildingname';
  //交换机信息管理 Grid.click
  SqlStr_Resource[1,23]:='select * from switch_info where switchid=@param1';
  //交换机信息管理 根据权限显示　COM_AREA
  SqlStr_Resource[1,24]:='select * from area_info t where layer =2 @param1';
  SqlStr_Resource[1,25]:='select * from switch_info';
  //AP信息管理
  SqlStr_Resource[1,26]:='select t.switchid,t.switchno from switch_info_view t where t.areaid in @param1';
  SqlStr_Resource[1,41]:='select t.switchid,t.switchno from switch_info_view t where t.buildingid in @param1';
  SqlStr_Resource[1,27]:='select t.apid,t.apno as 接入点编号,t.connecttypename as 连接类型,t.apport as 对应端口,t.factoryname as 供应商, '+
                         ' t.apkindname as AP型号,t.appropertyname as AP性质,t.appower as 功率,t.powerkindname as 供电方式 ,t.frequency as 频点,t.APaddr as AP地址,t.overlay as 覆盖范围, '+
                         ' t.manageaddrseg as AP管理地址段,t.apip as APIP,t.gwaddr as 网关地址,t.macaddr as MAC地址,t.businessvlan as 业务VLAN,t.managevlan as 管理VLAN,t.switchno as 所属交换机,'+
                         ' t.buildingname as 所属室分点,t.switchid ,t.buildingid from ap_info_view t where 1=1 @param1 order by apno';
  SqlStr_Resource[1,28]:='select * from ap_info';
  SqlStr_Resource[1,29]:='select * from ap_info where APID = @param1';
  SqlStr_Resource[1,30]:='select switchid,switchno from switch_info where buildingid = @param1';
  SqlStr_Resource[1,31]:='select csid, survery_id from cs_info  where buildingid=@param1';
  SqlStr_Resource[1,32]:='select b.apid,b.apno from ap_info b left join switch_info a on b.switchid=a.switchid where a.buildingid=@param1';
  SqlStr_Resource[1,73]:='select cdmaid,cdmaname from cdma_info where buildingid=@param1';
  SqlStr_Resource[1,33]:='select a.linkid,a.linkno as 连接器编号,a.linkaddr as 连接器位置,a.linktype as 连接器类型,a.istrunk as 是否干放, '+
                         ' a.trunkaddr as 干放位置,a.linkequipment as 连接设备类型,a.linkcs as 连接基站,a.linkap as 连接AP,a.buildingname as 所属室分点,a.buildingno as 室分点编号,'+
                         ' a.area as 所属郊县,a.buildingid,a.areaid from linkmachine_info_view a where a.areaid in @param1 order by linkid';
  SqlStr_Resource[1,34]:='select * from linkmachine_info t where linkid=@param1';
  SqlStr_Resource[1,35]:='select * from linkmachine_info t ';
  SqlStr_Resource[1,45]:='select * from mtu_info t where mtuid=@param1';
  SqlStr_Resource[1,46]:='select * from mtu_info t ';

  SqlStr_Resource[1,36]:='select linkid,linkno from linkmachine_info_view where areaid IN @param1 ';
  SqlStr_Resource[1,42]:='select linkid,linkno from linkmachine_info_view where buildingid in @param1 ';
  SqlStr_Resource[1,37]:='select a.mtuid,a.mtuno as mtu设备编号,a.mtuname as MTU名称,a.overlay as 覆盖区域, '+
                         ' a.mtuaddr as MTU位置,a.call as 电话号码,a.called as 被叫号码,a.linkno as 上端连接器,a.buildingname as 所属室分点,a.buildingno as 室分点编号,a.area as 所属郊县,a.linkid, '+
                         ' a.buildingid,a.areaid,a.status 是否屏蔽 from mtu_info_view a where a.areaid in @param1 order by mtuid' ;
  //MTU信息管理  GridClick and UPdate
  SqlStr_Resource[1,38]:='select * from mtu_info t where t.mtuid=@param1';

  //树图中选地市层
  SqlStr_Resource[1,39]:='select CSID 基站编号,SURVERY_ID 勘点编号,NETADDRESS 网元信息,CSADDR 基站地址 from cs_info '+
                          'where buildingid in (select buildingid from building_info where areaid in '+
                          '(select id from area_info where top_id=@param1))';
  //树图中选郊县层
  SqlStr_Resource[1,40]:='select CSID 基站编号,SURVERY_ID 勘点编号,NETADDRESS 网元信息,CSADDR 基站地址 from cs_info '+
                          'where buildingid in (select buildingid from building_info where areaid=@param1)';
  //树图中选室分点层（楼宇）
  SqlStr_Resource[1,47]:='select CSID 基站编号,SURVERY_ID 勘点编号,NETADDRESS 网元信息,CSADDR 基站地址 from cs_info '+
                          'where buildingid=@param1';
  //查询勘点编码 1
  SqlStr_Resource[1,48]:='select * from cs_info '+
                          'where Survery_id=''@param1''';
  //查询基站信息
  SqlStr_Resource[1,49]:='select * from cs_info';
  // 查询勘点编码 2
  SqlStr_Resource[1,50]:='select * from cs_info '+
                          'where CSID<>@param1 and Survery_id=''@param2''';
  // 查询勘点编码 3
  SqlStr_Resource[1,51]:='select * from cs_info '+
                          'where CSID=@param1';
                          
  SqlStr_Resource[1,43]:='select  t.apid,t.apno  from ap_info t';       //ap
  SqlStr_Resource[1,44]:='select  t.csid, t.survery_id  from cs_info t';  //cs

  SqlStr_Resource[1,52]:='select * from mtu_info t where t.linkid=@param1';
  SqlStr_Resource[1,53]:='select * from ap_info t where t.switchid=@param1';
  SqlStr_Resource[1,54]:='select * from switch_info t where t.buildingid=@param1';
  SqlStr_Resource[1,55]:='select * from linkmachine_info t where t.linkap=@param1';
  SqlStr_Resource[1,56]:='select * from switch_info t where t.buildingid=@param1';
  SqlStr_Resource[1,57]:='select * from cs_info t where t.buildingid=@param1';
  SqlStr_Resource[1,58]:='select * from mtu_info t where t.buildingid=@param1';
  SqlStr_Resource[1,59]:='select * from ap_info t where t.switchid= @param1';
  SqlStr_Resource[1,60]:='select * from mtu_info t where t.linkid= @param1';
  SqlStr_Resource[1,61]:='select * from mtu_info t @param1';   //Modifyby cdj 20080819
  SqlStr_Resource[1,62]:='select * from mtu_shield_list t @param1';
  SqlStr_Resource[1,63]:='select id,name from area_info where top_id=@param1 and layer=3';   //Modify by wjy20090319
  SqlStr_Resource[1,64]:='select id,name from area_info where layer=2 order by id';
  SqlStr_Resource[1,65]:='select id,name from area_info where top_id in (-1,@Param1) or id=@Param2 and layer=2 order by id ';
  SqlStr_Resource[1,66]:='select id,name from area_info where id in (0,@Param1,@Param2) and layer=2 order by id ';
  SqlStr_Resource[1,67]:='select * from cdma_info @param1';
  SqlStr_Resource[1,68]:='select * from cdma_info ';
  SqlStr_Resource[1,69]:=' select * from cdma_info t where cdmaid=@param1 ';
  SqlStr_Resource[1,70]:=' select suburbid,suburbname,areaid,areaname from building_info_view t where buildingid=@param1 ';
  SqlStr_Resource[1,71]:='select * from switch_info @param1';
  SqlStr_Resource[1,74]:='select * from linkmachine_info @param1';
  SqlStr_Resource[1,75]:='select * from mtu_alarm_model t where t.parentmodelid<>0 and t.parentmodelid<>1';
  SqlStr_Resource[1,76]:='select * from cs_info @param1';
  SqlStr_Resource[1,77]:='select * from ap_info @param1';



  SetLength(SqlStr_Resource[2], SQLCount);   //51
  
  //----------------任务计划---------
  //MTU信息列表   
  SqlStr_Resource[2,1]:= 'select distinct t.modelid,t.mtuid, decode(b.ISPAUSE,1,''是'', 0, ''否'', ''否'') ISPAUSE, a.mtuname as MTU名称,a.mtuno as MTU外部编号,'+
                         'a.overlay as 覆盖区域,a.mtuaddr as MTU位置,a.call as 电话号码,'+
                         'a.called as 被叫号码, a.linkno as 连接器,a.buildingname as 所属室分点, '+
                         'a.isprogramname as "室内/室外", a.mainlook_apname as 主监控AP, '+
                         'a.mainlook_phsname as 主监控PHS, a.mainlook_cnetname as 主监控C网,'+
                         'a.cdmatypename as C网信源类型, a.cdmaaddress as C网信源安装位置, a.pncode as PN码 '+

                         'from mtu_autotest_cmd t left join mtu_info_view a on t.mtuid = a.mtuid '+
                         'left join mtu_autotest_modelmtu_relation b on t.modelid = b.modelid  and t.mtuid = b.mtuid '+
                         ' where t.ModelID=@param1 '+
                         'order by t.mtuid';
  SqlStr_Resource[2,49]:= 'select distinct t.modelid,t.mtuid, decode(b.ISPAUSE,1,''是'', 0, ''否'', ''否'') ISPAUSE ,a.mtuname as MTU名称,a.mtuno as MTU外部编号,'+
                         'a.overlay as 覆盖区域,a.mtuaddr as MTU位置,a.call as 电话号码,'+
                         'a.called as 被叫号码, a.linkno as 连接器,a.buildingname as 所属室分点, '+
                         'a.isprogramname as "室内/室外", a.mainlook_apname as 主监控AP, '+
                         'a.mainlook_phsname as 主监控PHS, a.mainlook_cnetname as 主监控C网,'+
                         'a.cdmatypename as C网信源类型, a.cdmaaddress as C网信源安装位置, a.pncode as PN码 '+

                         'from mtu_autotest_cmd t left join mtu_info_view a on t.mtuid = a.mtuid '+
                         'left join mtu_autotest_modelmtu_relation b on t.modelid = b.modelid  and t.mtuid = b.mtuid '+
                         ' where t.ModelID in (select MODELID from MTU_AUTOTEST_Model where parentmodelid=@param1) '+
                         'order by t.mtuid';

  SqlStr_Resource[2,50]:= 'select distinct t.modelid,t.mtuid, decode(b.ISPAUSE,1,''是'', 0, ''否'', ''否'') ISPAUSE,a.mtuname as MTU名称,a.mtuno as MTU外部编号,'+
                         'a.overlay as 覆盖区域,a.mtuaddr as MTU位置,a.call as 电话号码,'+
                         'a.called as 被叫号码, a.linkno as 连接器,a.buildingname as 所属室分点, '+
                         'a.isprogramname as "室内/室外", a.mainlook_apname as 主监控AP, '+
                         'a.mainlook_phsname as 主监控PHS, a.mainlook_cnetname as 主监控C网,'+
                         'a.cdmatypename as C网信源类型, a.cdmaaddress as C网信源安装位置, a.pncode as PN码 '+

                         'from mtu_autotest_cmd t left join mtu_info_view a on t.mtuid = a.mtuid '+
                         'left join mtu_autotest_modelmtu_relation b on t.modelid = b.modelid  and t.mtuid = b.mtuid '+
                         'where exists (select 1 from mtu_autotest_model c where c.modelid = t.modelid) '+
                         'order by t.mtuid';
  {SqlStr_Resource[2,50]:= 'select t.modelid,t.mtuid, t.ISPAUSE,a.mtuname as MTU名称,a.mtuno as MTU外部编号,'+
                         'a.overlay as 覆盖区域,a.mtuaddr as MTU位置,a.call as 电话号码,'+
                         'a.called as 被叫号码, a.linkno as 连接器,a.buildingname as 所属室分点, '+
                         'a.isprogramname as "室内/室外", a.mainlook_apname as 主监控AP, '+
                         'a.mainlook_phsname as 主监控PHS, a.mainlook_cnetname as 主监控C网,'+
                         'a.cdmatypename as C网信源类型, a.cdmaaddress as C网信源安装位置, a.pncode as PN码 '+

                         'from mtu_autotest_modelmtu_relation t left join mtu_info_view a '+
                         'on t.mtuid=a.mtuid '+
                         'where exists (select 1 from mtu_autotest_cmd c where c.modelid=t.modelid and c.mtuid=t.mtuid) '+
                         'order by t.mtuid'; }

  //任务模板树列表
  SqlStr_Resource[2,3]:= 'select PARENTMODELID, MODELID, MODELNAME,CYCCOUNT,TIMEINTERVAL,PLANDATE '+
                         'from MTU_AUTOTEST_Model Order by ParentModelID, ModelID';
  //任务模板树列表(测试计划执行监控)
  SqlStr_Resource[2,51]:= 'select PARENTMODELID, MODELID, MODELNAME, CYCCOUNT, TIMEINTERVAL, PLANDATE '+
                         'from MTU_AUTOTEST_Model  where ModelID in '+
                         '( select distinct a.modelid from mtu_autotest_cmd a) union '+
                         'select PARENTMODELID, MODELID, MODELNAME, CYCCOUNT, TIMEINTERVAL, PLANDATE '+
                         'from MTU_AUTOTEST_Model  where ModelID in ( '+
                         ' select PARENTMODELID ModelID from MTU_AUTOTEST_Model  ' +
                         ' where ModelID in ( select distinct a.modelid from mtu_autotest_cmd a)) '+
                         ' or (parentModelID = 0) Order by ParentModelID, ModelID';   

  //任务模板查询(判断名称重复)
  SqlStr_Resource[2,30]:= 'select MODELID from MTU_AUTOTEST_Model where ModelName = ''@param1'' ';

  //命令列表
  SqlStr_Resource[2,4]:='select t.comname, t.comid from mtu_command_define t where t.comtype=1 '+
                        'and t.ifineffect=1 and t.comid<>9 order by t.comid';
  //模板MTU命令集  
  SqlStr_Resource[2,7]:='select t.taskid, a.comname, a.comid from mtu_autotest_modelmtucom t ' +
                        ' left join mtu_command_define a  '+
                        ' on a.comid=t.comid '+
                        ' where t.ModelID=@param1 and t.mtuID=@param2 ';
  //命令参数默认值
  SqlStr_Resource[2,5]:='select a.paramid,a.paramname,b.paramvalue, a.comid from  mtu_comparam_config a '+
                         ' left join mtu_autotestparam_config b  '+
                         ' on a.paramid=b.paramid and a.comid=b.comid '+
                         ' where a.comid=@param1 ';
  //命令参数自定义值
  SqlStr_Resource[2,6]:='select a.paramid,a.paramname,b.paramvalue, b.taskid from  mtu_comparam_config a '+
                         ' left join MTU_AUTOTEST_ModelComParam b  '+
                         ' on a.paramid=b.paramid and a.comid=b.comid '+
                         ' where b.TaskID=@param1 ';
  //MTU命令任务设置值
  SqlStr_Resource[2,8]:= 'select * from mtu_autotest_model_mtu_view where modelid=@param1 Order by MTUID';
  //MTU命令任务参数设置值
  SqlStr_Resource[2,9]:= 'select * from mtu_autotest_model_mtup_view where modelid=@param1 Order by MTUID';

  //任务列表时间段
  SqlStr_Resource[2,24]:= 'select modelid, begintime, endtime, ID from mtu_autotest_model_time_view '+
                          'where modelid=@param1';  
   //任务列表时间段明细
  SqlStr_Resource[2,25]:= 'select ID, ModelID, begintime, endtime, comid, cyccount, '+
                          'timeinterval, comname, 0 CURR_CYCCOUNT, ParentID '+
                          'from mtu_autotest_model_timeC_view where '+
                          'modelid =@param1';
  //任务列表时间段明细(告警监控)
  SqlStr_Resource[2,37]:= 'select ID, ModelID, begintime, endtime, comid, cyccount, '+
                          'timeinterval, comname, CURR_CYCCOUNT, ParentID '+
                          'from mtu_autotest_model_timeCM_view where '+   
                          'modelid=@param1 and mtuid=@param2 ';
  //删除任务列表时间段
  SqlStr_Resource[2,26]:= 'delete mtu_autotest_modeltimecom where modelid=@param1';
  //删除告警内容
  SqlStr_Resource[2,27]:= 'delete mtu_alarm_model_content where modelid in '+
                          '(select modelid from mtu_alarm_model where parentmodelid=@param1)';
  //保存任务列表时间段表
  SqlStr_Resource[2,28]:= 'select id, modelid, begintime, endtime, comid, cyccount, timeinterval '+
                          'from mtu_autotest_modeltimecom where 1=2';

  //删除任务计划前查询是否已配置
  SqlStr_Resource[2,45]:= 'select MTUID from mtu_autotest_modelmtu_relation where MODELID = @param1';
  //删除任务计划类前查询是否已配置
  SqlStr_Resource[2,46]:= 'select MTUID from mtu_autotest_modelmtu_relation where MODELID in '+
                          '(select MODELID from MTU_AUTOTEST_Model where parentModelid=@param1)';


  //删除任务计划(叶)
  SqlStr_Resource[2,31]:= 'delete mtu_autotest_model where modelid=@param1';
  //删除任务计划
  SqlStr_Resource[2,32]:= 'delete mtu_autotest_modeltimecom where modelid=@param1';
  //删除任务计划
  SqlStr_Resource[2,33]:= 'delete mtu_autotest_modelmtu_relation where modelid=@param1';
  
  //删除任务计划(节点)
  SqlStr_Resource[2,34]:= 'delete mtu_autotest_modelmtu_relation where modelid in '+
                          '(select modelid from mtu_autotest_model where parentmodelid=@param1)';
  //删除任务计划(节点)
  SqlStr_Resource[2,35]:= 'delete mtu_autotest_modeltimecom where modelid in '+
                          '(select modelid from mtu_autotest_model where parentmodelid=@param1)';
  //删除任务计划(节点)
  SqlStr_Resource[2,36]:= 'delete mtu_autotest_model where parentmodelid=@param1 or modelid=@param1';

  //暂停执行任务计划
  //SqlStr_Resource[2,39]:= 'update mtu_autotest_cmd set ifpause = 1 where modelid=@param1 and mtuid=@param2';
  SqlStr_Resource[2,39]:= 'update mtu_autotest_cmd set ifpause = 1 where 1<>1 @param1';
  //SqlStr_Resource[2,40]:= 'update MTU_AUTOTEST_MODELMTU_RELATION set ISPAUSE = 1 where modelid=@param1 and mtuid=@param2';
  SqlStr_Resource[2,40]:= 'update MTU_AUTOTEST_MODELMTU_RELATION set ISPAUSE = 1 where 1<>1 @param1';

  //恢复执行任务计划
  //SqlStr_Resource[2,41]:= 'update mtu_autotest_cmd set ifpause = 0 where modelid=@param1 and mtuid=@param2';
  SqlStr_Resource[2,41]:= 'update mtu_autotest_cmd set ifpause = 0 where 1<>1 @param1';
  //SqlStr_Resource[2,42]:= 'update MTU_AUTOTEST_MODELMTU_RELATION set ISPAUSE = 0 where modelid=@param1 and mtuid=@param2';
  SqlStr_Resource[2,42]:= 'update MTU_AUTOTEST_MODELMTU_RELATION set ISPAUSE = 0 where 1<>1 @param1';

  //删除执行任务计划  
  SqlStr_Resource[2,43]:= 'delete mtu_autotest_param where TESTGROUPID in '+
                         '(select TESTGROUPID from mtu_autotest_cmd where 1<>1 @param1)';
  SqlStr_Resource[2,44]:= 'delete mtu_autotest_cmd where 1<>1 @param1';




  //----------------告警门限模板---------
  //告警门限模板树列表
  SqlStr_Resource[2,10]:= ' select * from  mtu_alarm_model Order by ParentModelID';
  //告警门限模板查询
  SqlStr_Resource[2,12]:= ' select * from mtu_alarm_model where ModelName = ''@param1'' ';

  //告警内容管理默认
  SqlStr_Resource[2,11]:= 'select * from mtu_alarm_model_defcon_view order by ALARMCONTENTCODE';
  //告警内容管理
  SqlStr_Resource[2,13]:= ' select * from  mtu_alarm_model_content_view '+
                          ' where ModelID = @param1 order by ALARMCONTENTCODE';
  //告警内容管理(保存)
  SqlStr_Resource[2,38]:= ' select * from  mtu_alarm_model_content '+
                          ' where ModelID = @param1 order by ALARMCONTENTCODE';
  //告警类型
  SqlStr_Resource[2,14]:= 'select DICCODE as ID,DICNAME as Name from DIC_CODE_INFO '+
                          ' where PARENTID <>-1 and dictype=11 and ifineffect=1 order by dicorder';

  //删除告警内容前查询是否已配置
  SqlStr_Resource[2,47]:= 'select MTUID from MTU_INFO where CONTENTCODEMODEL=@param1';
  //删除告警内容类前查询是否已配置
  SqlStr_Resource[2,48]:= 'select MTUID from MTU_INFO where CONTENTCODEMODEL in '+
                          '(select MODELID from MTU_ALARM_MODEL where parentModelid=@param1)';


  //删除告警内容(叶)
  SqlStr_Resource[2,16]:= 'delete mtu_alarm_model_content where modelid=@param1';
  //删除告警模板(叶)
  SqlStr_Resource[2,17]:= 'delete mtu_alarm_model where modelid=@param1';
  //删除告警内容
  SqlStr_Resource[2,18]:= 'delete mtu_alarm_model_content where modelid in '+
                          '(select modelid from mtu_alarm_model where parentmodelid=@param1)';
  //删除告警模板
  SqlStr_Resource[2,19]:= 'delete mtu_alarm_model where parentmodelid=@param1';
  //删除告警模板类
  SqlStr_Resource[2,20]:= 'delete mtu_alarm_model where modelid=@param1';
  


  //----------------告警监控---------
  //当前告警测试结果
//  SqlStr_Resource[2,21]:= 'select a.alarmid, b.* from alarmonline_result_relation a '+
//                          'left join mtu_testresult_Query_view b  '+
//                          'on b.taskid=a.taskid where a.alarmid=@param1';
  {SqlStr_Resource[2,21]:= 'select a.alarmid, b.taskid,b.mtuid,b.mtuno,b.comname,b.paramname,b.valueindex,b.testresult,b.collecttime,'+
                          ' b.execid,decode(b.isprocess,0,''未处理'',1,''待处理'',2,''已处理'') as isprocess,b.name,b.comid,'+
                          ' b.paramid,b.cityid from mtu_alarmresult a '+
                          ' left join mtu_testresult_Query_view b on b.taskid=a.taskid where a.alarmid=@param1';}
  SqlStr_Resource[2,21]:= 'select b.alarmid, b.taskid,b.mtuid,b.mtuno,b.comname,b.paramname,b.valueindex,b.testresult,b.collecttime,'+
                          ' b.execid,decode(b.isprocess,0,''未处理'',1,''待处理'',2,''已处理'') as isprocess,b.name,b.comid,'+
                          ' b.paramid,b.cityid from mtu_alarmresult_view b '+
                          ' where b.alarmid=@param1';


  //历史告警测试结果
  SqlStr_Resource[2,22]:= 'select a.alarmid, b.* from mtu_alarmresult a '+
                          'left join mtu_testresult_Query_view b  '+
                          'on b.taskid=a.taskid where a.alarmid=@param1';
  //MTU历史告警
  SqlStr_Resource[2,23]:= 'select mtuid,alarmcontentname,alarmkindname,alarmlevelname,sendtime,removetime,mtuname,mtuno'+
                          ' from (select * from alarm_master_online_view union '+
                          'select * from alarm_master_history_view) '+
                          'where mtuid=@param1 and rownum<=@param2 order by sendtime';

  //////////////////////////////////////////////////////////////////////////////
  //------------直放站配置管理--------------------------
  SetLength(SqlStr_Resource[3], SQLCount);   //2
  //直放站列表
  SqlStr_Resource[3,1]:= 'select * from drs_config_info_view a '+
                         'where @param1';
  //直放站锁定解锁
  SqlStr_Resource[3,2]:= 'update drs_statuslist t set t.drsstatus=@param2 where t.drsid=@param1 ';

  //直放站配置信息
  SqlStr_Resource[3,5]:= 'select t.* from drs_config_local_view t where t.drsid=@param1 ';
  SqlStr_Resource[3,6]:= 'select t.* from drs_config_default_view t where t.drsid=@param1 ';
  SqlStr_Resource[3,7]:= 'select t.drsid, t.drsno, t.r_deviceid, a.updatetime3, a.updatetime4, '+
                          'b1.paramvalue p0x31_01, b2.paramvalue p0x31_02, ''0X01'' p0x31_03,  '+
                          'nvl(c1.paramvalue,0) p0x32_01, nvl(c2.paramvalue,0) p0x32_02, nvl(c3.paramvalue,0) p0x32_03, nvl(c4.paramvalue,0) p0x32_04, '+
                          'nvl(c5.paramvalue,0) p0x32_05, nvl(c6.paramvalue,0) p0x32_06, nvl(c7.paramvalue,0) p0x32_07, nvl(c8.paramvalue,0) p0x32_08,  '+
                          'nvl(c9.paramvalue,0) p0x32_09, nvl(c10.paramvalue,0) p0x32_10, nvl(c11.paramvalue,0) p0x32_11, nvl(c12.paramvalue,0) p0x32_12, '+
                          'nvl(c13.paramvalue,0) p0x32_13, nvl(c14.paramvalue,0) p0x32_14, nvl(c15.paramvalue,0) p0x32_15, nvl(c16.paramvalue,0) p0x32_16, '+
                          'nvl(c17.paramvalue,0) p0x32_17, d1.paramvalue p0x33_01, d2.paramvalue p0x33_02, nvl(e1.paramvalue,0) p0x34_01, '+
                          'nvl(e2.paramvalue,0) p0x34_02, f1.paramvalue p0x35_01, f2.paramvalue p0x35_02, g1.paramvalue p0x36_01, '+
                          'g2.paramvalue p0x36_02 from drs_info t                   '+
                          'left join drs_statuslist a on a.drsid=t.drsid            '+
                          'left join @param1 b1 on b1.comid=49 and b1.paramid=4     '+
                          'left join @param1 b2 on b2.comid=49 and b2.paramid=5     '+
                          'left join @param1 c1 on c1.comid=50 and c1.paramid=7     '+
                          'left join @param1 c2 on c2.comid=50 and c2.paramid=8     '+
                          'left join @param1 c3 on c3.comid=50 and c3.paramid=9     '+
                          'left join @param1 c4 on c4.comid=50 and c4.paramid=10    '+
                          'left join @param1 c5 on c5.comid=50 and c5.paramid=11    '+
                          'left join @param1 c6 on c6.comid=50 and c6.paramid=12    '+
                          'left join @param1 c7 on c7.comid=50 and c7.paramid=13    '+
                          'left join @param1 c8 on c8.comid=50 and c8.paramid=14    '+
                          'left join @param1 c9 on c9.comid=50 and c9.paramid=15    '+
                          'left join @param1 c10 on c10.comid=50 and c10.paramid=16 '+
                          'left join @param1 c11 on c11.comid=50 and c11.paramid=17 '+
                          'left join @param1 c12 on c12.comid=50 and c12.paramid=18 '+
                          'left join @param1 c13 on c13.comid=50 and c13.paramid=19 '+
                          'left join @param1 c14 on c14.comid=50 and c14.paramid=20 '+
                          'left join @param1 c15 on c15.comid=50 and c15.paramid=21 '+
                          'left join @param1 c16 on c16.comid=50 and c16.paramid=22 '+
                          'left join @param1 c17 on c17.comid=50 and c17.paramid=23 '+
                          'left join @param1 d1 on d1.comid=51 and d1.paramid=27    '+
                          'left join @param1 d2 on d2.comid=51 and d2.paramid=76    '+
                          'left join @param1 e1 on e1.comid=52 and e1.paramid=56    '+
                          'left join @param1 e2 on e2.comid=52 and e2.paramid=55    '+
                          'left join @param1 f1 on f1.comid=53 and f1.paramid=54    '+
                          'left join @param1 f2 on f2.comid=53 and f2.paramid=53    '+
                          'left join @param1 g1 on g1.comid=54 and g1.paramid=77    '+
                          'left join @param1 g2 on g2.comid=54 and g2.paramid=78    '+
                          ' where t.drsid=@param2';


  //直放站历史配置信息
  SqlStr_Resource[3,10]:= 'select batchid from drs_prepparam_set_h t where t.drsid=@param1 group by t.batchid order by batchid desc';

  //------------直放站配置命令--------------------------
  SetLength(SqlStr_Resource[4], SQLCount);   //2
  SqlStr_Resource[4,1]:= 'insert into drs_testtask_online '+
                         '(taskid, cityid, drsid, comid, status, asktime, tasklevel, userid) '+
                         'values (@param1, @param2, @param3, @param4, 0, sysdate, 1, @param5) ';
  SqlStr_Resource[4,2]:= 'insert into drs_testparam_online '+
                         '(taskid, paramid, paramvalue) '+
                         'values (@param1, @param2, @param3) ';

  SqlStr_Resource[4,3]:= 'insert into drs_prepparam_set '+
                         '(drsid, comid, paramid, paramvalue, createtime, operator, taskid, issuccess) '+
                         'values (@param1, @param2, @param3, @param4, sysdate, @param5, @param6, 0) ';

  SqlStr_Resource[4,4]:= 'insert into drs_prepparam_set_h '+
                         '(batchid, drsid, comid, paramid, paramvalue, createtime, operator) '+
                         'select To_Char(Max(createtime), ''yyyymmddHH24MISS'') createtime,  drsid, comid, paramid, paramvalue, createtime, operator '+
                         'from drs_prepparam_set t where t.drsid=@param1 group by drsid, comid, paramid, paramvalue, createtime, operator';

  SqlStr_Resource[4,5]:= 'delete drs_prepparam_set t where t.drsid=@param1';

  //------------直SQL通用查询--------------------------
  SetLength(SqlStr_Resource[5], SQLCount);
//  SqlStr_Resource[5,1]:= 'select * from drs_config_com_on_view where DRSid=@param1 ';
  SqlStr_Resource[5,1]:= ' @param1 ';

  //////////////////////////////////////////////////////////////////////////////
  end;

{********************* 2基础数据管理SQL语句 ***************************
 SqlStr_BaseData 存放基础数据SQL
**********************************************************************}
procedure Init_SqlStr_BaseData();
begin
  //dic_type_info- SqlStr_Common[1]
  SetLength(SqlStr_BaseData[1], SQLCount);
  SetLength(SqlStr_BaseData[2], SQLCount);
  SetLength(SqlStr_BaseData[3], SQLCount);
  SetLength(SqlStr_BaseData[4], SQLCount);
  //查看所有区域信息
  SqlStr_BaseData[1,1]:='select * from area_info where layer in (0,1,2)';
  //查看特定用户基本信息（管理员除外）
  SqlStr_BaseData[1,2]:='select userid 用户编号,userno 用户帐号,username 姓名,email 邮箱,'+
  'decode(sex,0,''男'',1,''女'',''男'') 性别,dept 部门职位,officephone 办公电话,mobilephone 手机,'+
  'creator 创建者编号,cityid 所属地市,areaid 所属郊县 from userinfo '+
  'where userid<>@Param1 and cityid=@Param2 and areaid=@Param3';
  //管理员所有权限
  SqlStr_BaseData[1,3]:='select ModuleID,ModuleName from AppModuleInfo ';
  //普通用户权限
  SqlStr_BaseData[1,4]:='select t1.moduleid,t2.modulename from userprivinfo t1, appmoduleinfo t2 '+
  'where t1.moduleid=t2.moduleid and t1.userid=@Param1';
  //判断用户是否重复
  SqlStr_BaseData[1,5]:='select * from userinfo where userid<>@Param1 and userno=''@Param2'' ';
  //查找用户是否存在
  SqlStr_BaseData[1,6]:='select * from userinfo where userid=@Param1';
  //查找用户权限
  SqlStr_BaseData[1,7]:='select * from userprivinfo where userid=@Param1';
  //字典分类信息表
  SqlStr_BaseData[1,8]:='select * from dic_type_info order by typeid';
  //字典编码表(显示出来)
  SqlStr_BaseData[1,9]:='select diccode 资料编号,dicname 资料名称,dicorder 资料序号,decode(ifineffect,0,''否'',1,''是'',''否'') 是否有效,remark 资料解释 '+
  'from dic_code_info where dictype=@Param1 order by diccode';


  //  10-20 告警内容管理
  SqlStr_BaseData[1,10]:=' select alarmcontentcode as  告警内容编码 , alarmcontentname as  告警名称 , alarmkindname as  告警类型 , alarmlevelname as 告警等级 ,'+
                         ' alarmcondition as 告警产生条件,alarmcount as 告警产生累计门限,'+
                         ' removecondition as 告警排除条件,  removecount as 告警排除累计门限,'+
                         ' limithour as 排除时限,  comname as 告警来源命令, paramname as 告警来源参数'+
                         ' from mtu_alarm_content_view ';
  //获取全部告警内容
  SqlStr_BaseData[1,11]:=' select * from mtu_alarm_content order by alarmcontentcode';
  //获取某条告警内容
  SqlStr_BaseData[1,12]:=' select * from mtu_alarm_content where alarmcontentcode=@Param1';


  //添加时判断字典类型名称是否重复
  SqlStr_BaseData[1,13]:='select * from dic_code_info where dictype=@Param1 and dicname=''@Param2'' ';
  //字典编码表(不显示出来)
  SqlStr_BaseData[1,14]:='select * from dic_code_info';
  //字典编码表（修改\删除)
  SqlStr_BaseData[1,15]:='select * from dic_code_info where diccode=@Param1 and dictype=@Param2';
  //修改时判断字典类型名称是否重复
  SqlStr_BaseData[1,16]:='select * from dic_code_info where diccode<>@Param1 and dictype=@Param2 and dicname=''@Param3'' ';
  //告警拨测
  SqlStr_BaseData[1,17]:='select t.buildingid,t.buildingname from building_info t where t.areaid=@param1 ';
  //告警拨测＿showgrid
  SqlStr_BaseData[1,18]:='select a.mtuid,a.mtuname as MTU名称,a.mtuno as MTU外部编号,a.overlay as 覆盖区域,a.mtuaddr as MTU位置,a.call as 电话号码,a.called as 被叫号码, '+
                         ' b.status ,decode(b.status,1,''上线'',0,''下线'',''未知'') as MTU状态,b.updatetime 状态变更时间,a.linkno as 连接器,a.buildingno as 所属室分点, '+
                         ' a.area as 所属郊县,a.buildingid,a.areaid,a.top_id,a.cityid '+
                         ' from mtu_info_view a left join mtu_status_list b '+
                         ' on a.mtuid=b.mtuid where @param1';               //最后修改 CDJ 20080429
  //告警拨测＿ComboBoxTextType
  SqlStr_BaseData[1,19]:='select t.comid,t.comname from mtu_command_define t where t.comtype=1 and t.ifineffect=1 and t.comid<>9 order by t.comid';
  //告警拨测＿
  SqlStr_BaseData[1,20]:='select * from mtu_testtask_online t where taskid=@param1 ';

  SqlStr_BaseData[1,21]:={'select a.paramid,a.paramname,b.paramvalue from  mtu_param_define a  '+
                         ' left join mtu_autotestparam_config b  '+
                         ' on a.paramid=b.paramid where b.comid=@param1 ';   }
                         'select a.paramid,a.paramname,b.paramvalue from  mtu_comparam_config a '+
                         ' left join mtu_autotestparam_config b  '+
                         ' on a.paramid=b.paramid and a.comid=b.comid '+
                         ' where  a.comid=@param1 ';
  SqlStr_BaseData[1,22]:='select * from mtu_testtaskparam_online t';
  //告警拨测＿EXCEPTdelete
  SqlStr_BaseData[1,23]:='select * from mtu_testtaskparam_online t where  t.taskid=@param1';
  //警拨测＿show_task
  SqlStr_BaseData[1,24]:='select taskid 任务编号,comname as 命令名称,status,'+
                         ' decode(status,1,''未处理'',2,''已发送'',3,''已执行'',4,''测试成功'',5,''测试失败'',6,''未响应'',7,''被停止状态'',0) as 任务状态,'+
                         ' testresult as 测试结果,asktime as 请求测试时间, '+
                         ' rectime as 接收测试结果时间,mtuno as MTU名称,name as 所属地市,username as 用户名,comid,buildingid,cityid,mtuid '+
                         ' from mtu_testtask_online_view a  where @param1 and a.userid>-1 and  a.status<>7 order by taskid desc';

  SqlStr_BaseData[1,25]:='select * from mtu_testtask_online t where t.taskid=@param1';
  SqlStr_BaseData[1,26]:='select * from mtu_testtaskparam_online t where t.taskid=@param1';
  SqlStr_BaseData[1,27]:='select a.mtuno as MTU设备编号,a.comname as 命令名称,a.paramname as 测试参数,a.valueindex as 结果序号,a.testresult as 测试结果值,'+
                         ' a.collecttime as 采集时间,a.execid as 执行序号,decode(a.isprocess,0,''未处理'',1,''待处理'',2,''已处理'') as 是否已处理,a.name as 所属地市,a.comid,a.cityid '+
                         ' from mtu_usertestresult_view a where a.taskid = @param1 order by a.comid,a.execid,a.paramid,a.valueindex';

  //设置参数名称和值
  SqlStr_BaseData[1,31]:='select t1.comid 命令编号,t3.paramname 参数名称,t1.paramid 参数编号,t2.paramvalue 参数值 '+
                  'from mtu_comparam_config t1 left join mtu_autotestparam_config t2 '+
                  'on t1.comid=t2.comid and t1.paramid=t2.paramid '+
                  'left join mtu_param_define t3 on t1.paramid=t3.paramid '+
                  'where t1.comid=@param1';
  //命令类型为1（测试）的命令  不包括 "comid=9 停止任务命令"
  SqlStr_BaseData[1,32]:='select * from mtu_command_define where comtype=1 and comid<>9';
  //参数值（添加，修改）
  SqlStr_BaseData[1,33]:='select * from mtu_autotestparam_config where comid=@param1';
  SqlStr_BaseData[1,60]:='select * from mtu_usertestresult  t where t.taskid=@param1';
  SqlStr_BaseData[1,62]:='select * from mtu_testtaskparam_online t where t.taskid=@param1';

  //告警主表(省)   告警编号,告警内容,MTU名称,任务号,告警累计次数,室分点,郊县,地市
  SqlStr_BaseData[1,34]:='select * from alarm_master_online_view @param1 order by readed asc,sendtime desc';
  //告警从表   告警编号，告警内容，采集时间，告警状态，采集编号
  SqlStr_BaseData[1,35]:='select a.alarmid,b.alarmcontentname,a.collecttime,'+
      'decode(a.status,1,''告警'',2,''排除'') status,a.collectid from alarm_detail_online a '+
      'left join mtu_alarm_content b on a.alarmcontentcode=b.alarmcontentcode '+
      'where a.alarmid=@param1 order by a.collectid';

  //告警主表(地市)
  SqlStr_BaseData[1,36]:='select * from alarm_master_online_view where flowtache=2 and cityid =@param1 order by readed asc,sendtime desc';
  //告警主表(郊县)
  SqlStr_BaseData[1,37]:='select * from alarm_master_online_view where flowtache=2 and areaid=@param1 order by readed asc,sendtime desc';
  //告警主表(室分点)
  SqlStr_BaseData[1,38]:='select * from alarm_master_online_view where flowtache=2 and  buildingid=@param1 order by readed asc,sendtime desc';
  //告警主表(基站)
  SqlStr_BaseData[1,39]:='select * from alarm_master_online_view where flowtache=2 and  buildingid=(select buildingid from cs_info where csid=@param1) order by readed asc,sendtime desc';
  //告警主表(交换机)
  SqlStr_BaseData[1,40]:='select * from alarm_master_online_view where flowtache=2 and buildingid=(select buildingid from switch_info where switchid=@param1) order by readed asc,sendtime desc';

  //告警主表(AP)
  SqlStr_BaseData[1,41]:='select * from alarm_master_online_view where  flowtache=2 and  buildingid=(select buildingid from switch_info '+
      'where switchid=(select switchid from ap_info where apid=@param1)) order by readed asc,sendtime desc';
  //室分点信息
  SqlStr_BaseData[1,42]:='select buildingname,longitude,latitude from building_info where (longitude is not null) and (latitude is not null)';
  //查找室分点
  SqlStr_BaseData[1,43]:='select a.buildingname,a.longitude,a.latitude from building_info a where a.buildingname=''@Param1'' ';
  SqlStr_BaseData[1,44]:='select comid,orderid from mtu_autotestcyc_config';
  //GIS上显示室分点信息
//  SqlStr_BaseData[1,45]:='select a.buildingno 室分点编号,a.buildingname 室分点名称,a.address 室分点地址,'+
//            'a.longitude 经度,a.latitude 纬度,a.floorcount 室分点层数,a.buildingarea 室分点面积,'+
//            'b.dicname as 网络类型,c.dicname as 厂商,d.dicname as 接入类型,'+
//            'e.dicname as 室分点类型,f.name as 分局 from building_info a '+
//            'left join dic_code_info b on a.nettype=b.diccode and b.dictype =1 '+
//            'left join dic_code_info c on a.factory=c.diccode and c.dictype =3 '+
//            'left join dic_code_info d on a.connecttype=d.diccode and d.dictype=4 '+
//            'left join dic_code_info e on a.buildingtype=e.diccode and e.dictype=2 '+
//            'left join area_info f on a.areaid=f.id and f.layer=3 '+
//            'where a.buildingid=@param1';
  SqlStr_BaseData[1,45]:='select buildingno 室分点编号,buildingname 室分点名称,address 室分点地址,'+
                          'longitude 经度,latitude 纬度,floorcount 室分点层数,buildingarea 室分点面积,'+
                          'nettypename 网络类型,factoryname as 厂商,connecttypename as 接入类型,'+
                          'buildingtypename 室分点类型,suburbname 分局 from building_info_view t '+
                          ' where t.areaid in (@param1) @param2';
  //历史告警主表数据 (根据室分点名称查找)
  SqlStr_BaseData[1,46]:='select * from alarm_master_history_view '+
      'where flowtache=3 and buildingid in (select buildingid from building_info '+
      'where buildingname=''@param1'') @param2 order by removetime desc';
  //历史告警从表数据   告警编号，告警内容，采集时间，告警状态，采集编号
  SqlStr_BaseData[1,47]:='select a.alarmid,b.alarmcontentname,a.collecttime,'+
      'decode(a.status,1,''告警'',2,''排除'') status,a.collectid from alarm_detail_history a '+
      'left join mtu_alarm_content b on a.alarmcontentcode=b.alarmcontentcode '+
      'where a.alarmid=@param1 order by a.collectid';
  //历史告警主表(省)   告警编号,告警内容,MTU名称,任务号,告警累计次数,室分点,郊县,地市
  SqlStr_BaseData[1,48]:='select * from alarm_master_history_view @param1 order by removetime desc';

  //历史告警主表(地市)
  SqlStr_BaseData[1,49]:='select * from alarm_master_history_view '+
      'where flowtache=3 and cityid=@param1 @param2 order by removetime desc';

  //历史告警主表(郊县)
  SqlStr_BaseData[1,50]:='select * from alarm_master_history_view '+
      'where flowtache=3 and areaid=@param1 @param2 order by removetime desc';

  SqlStr_BaseData[1,51]:='select a.comid,b.comname  from mtu_autotestcyc_config a left join mtu_command_define b on a.comid=b.comid order by a.orderid';
  //更新已阅标识
  SqlStr_BaseData[1,52]:='update alarm_master_online set readed=1 where alarmid in ( @param1 )';

  //历史告警主表(室分点)
  SqlStr_BaseData[1,53]:='select * from alarm_master_history_view where flowtache=3 and buildingid=@param1 @param2 order by removetime desc';
  //历史告警主表(基站)
  SqlStr_BaseData[1,54]:='select * from alarm_master_history_view where flowtache=3 and buildingid=(select buildingid from cs_info where csid=@param1) @param2 order by removetime desc';
  //历史告警主表(交换机)
  SqlStr_BaseData[1,55]:='select * from alarm_master_history_view where flowtache=3 and buildingid=(select buildingid from switch_info where switchid=@param1) @param2 order by removetime desc';
  //告警主表(AP)
  SqlStr_BaseData[1,56]:='select * from alarm_master_history_view where flowtache=3 and buildingid=(select buildingid from switch_info '+
      'where switchid=(select switchid from ap_info where apid=@param1)) @param2 order by removetime desc';
  //告警主表数据 (根据室分点名称查找)
  SqlStr_BaseData[1,57]:='select * from alarm_master_online_view '+
      'where flowtache=2 and buildingid in (select buildingid from building_info '+
      'where buildingname=''@param1'') order by readed asc,sendtime desc';

//查看所有用户基本信息 （地市用户）
  SqlStr_BaseData[1,58]:='select userid 用户编号,userno 用户帐号,username 姓名,email 邮箱,'+
  'decode(sex,0,''男'',1,''女'',''男'') 性别,dept 部门职位,officephone 办公电话,mobilephone 手机,'+
  'creator 创建者编号,cityid 所属地市,areaid 所属郊县 from userinfo '+
  'where cityid=@param1 and areaid<>0';
//查看所有用户基本信息 （管理员）
  SqlStr_BaseData[1,59]:='select userid 用户编号,userno 用户帐号,username 姓名,email 邮箱,'+
  'decode(sex,0,''男'',1,''女'',''男'') 性别,dept 部门职位,officephone 办公电话,mobilephone 手机,'+
  'creator 创建者编号,cityid 所属地市,areaid 所属郊县 from userinfo '+
  'where userid<>0';
//查看所有用户基本信息 （省用户）
  SqlStr_BaseData[1,61]:='select userid 用户编号,userno 用户帐号,username 姓名,email 邮箱,'+
  'decode(sex,0,''男'',1,''女'',''男'') 性别,dept 部门职位,officephone 办公电话,mobilephone 手机,'+
  'creator 创建者编号,cityid 所属地市,areaid 所属郊县 from userinfo '+
  'where cityid<>0';

  SqlStr_BaseData[1,62]:='select * from mtu_testtaskparam_online t where t.TASKID=@param1';

  SqlStr_BaseData[1,63]:='select * from mtu_autotest_cmd where 1=2';
  SqlStr_BaseData[1,64]:='select * from mtu_autotest_param where 1=2';
  SqlStr_BaseData[1,65]:='select * from mtu_info t where Upper(mtuno)=Upper(@param1)';
  SqlStr_BaseData[1,66]:='select a.testgroupid,c.comname,a.time_interval,a.cyccounts,a.curr_cyccount,d.paramname,b.paramvalue'+
                         ' from mtu_autotest_cmd a'+
                         ' inner join mtu_autotest_param b on a.testgroupid=b.testgroupid'+
                         ' inner join mtu_command_define c on a.comid=c.comid'+
                         ' inner join mtu_param_define d on b.paramid=d.paramid'+
                         ' where @param1'+
                         ' order by a.testgroupid,a.comid,b.paramid';
  SqlStr_BaseData[1,67]:='select * from mtu_autotest_cmd where testgroupid=@param1';
  SqlStr_BaseData[1,68]:='select * from mtu_autotest_param where testgroupid=@param1';
  SqlStr_BaseData[1,69]:='delete from alarm_master_history where alarmid in (@param1)';
  SqlStr_BaseData[1,70]:='select * from area_info @param1';
  SqlStr_BaseData[1,71]:='select drsno 直放站编号,r_deviceid 设备编号,drsname 直放站名称,drstypename 类型,drsmanuname 地址,' +
                         '       drsadress 地址,drsphone 电话号码,longitude 经度,latitude 纬度,' +
                         '       isprogramname 是否室分,suburbname 所属分局,buildingname 所属室分点' +
                         '  from DRS_info_view t' +
                         ' where t.areaid in (@param1) @param2';

  //20080317新增
  //在线未消障告警
  SqlStr_BaseData[2,1] := 'select * from alarm_master_online_view where flowtache=2 @param1 order by readed asc,sendtime desc';
  SqlStr_BaseData[2,2] := 'select * from alarm_master_history_view where flowtache=3 @param1 order by readed asc,sendtime desc';
  SqlStr_BaseData[2,3]:='select * from area_info where layer in (0,1,2,3)';


  //告警监控
  //未消障告警
  SqlStr_BaseData[3,1]:= 'select * from alarm_master_online_view where flowtache=2 @param1 order by readed asc,sendtime desc';
  //当日已经消障告警（即界面上的历史告警TAB页）
  SqlStr_BaseData[3,2]:= 'select * from alarm_master_history_view'+
                         ' where flowtache=3 and to_char(removetime,''yyyy-mm-dd'')=to_char(sysdate,''yyyy-mm-dd'') @param1 order by alarmid desc';
  //最近N次测试结果详单
  SqlStr_BaseData[3,3]:= 'select * from mtu_alarmresult_view t where t.alarmid=@param1 order by t.taskid desc';
  //某MTU的N次告警
  SqlStr_BaseData[3,4]:= 'select * from (select t.*,dense_rank() over (order by t.alarmid desc) r '+
                                        ' from (select * from alarm_master_online_view union '+
                                               'select * from alarm_master_history_view) t'+
                                        ' where mtuid=@param1)'+
                          ' where r<=@param2';
  //查找室分点窗口 GIS定位 （这里不建视图而采用直接SQL）
  SqlStr_BaseData[3,5]:= 'select buildingid,buildingno,buildingname,buildingaddr,suburbname,areaname from '+
                             ' (select a.buildingid,a.buildingno,a.buildingname,a.address buildingaddr,'+
                             ' b.mtuname,b.mtuno,b.mtuaddr,b.call,'+
                             ' d.apno,d.apip,'+
                             ' e.cs_id,e.survery_id,'+
                             ' f.cdmano,f.cdmaname,f.pncode,f.address cdmaaddr,'+
                             ' l.id suburbid,l.name suburbname,m.id areaid,m.name areaname'+
                             ' from building_info a'+
                             ' left join mtu_info b on a.buildingid=b.mtuid'+
                             ' left join switch_info c on a.buildingid=c.buildingid'+
                             ' left join ap_info d on c.switchid=d.switchid'+
                             ' left join cs_info e on a.buildingid=e.buildingid'+
                             ' left join cdma_info f on a.buildingid=f.buildingid'+
                             ' left join area_info l on a.areaid=l.id and l.layer=3'+
                             ' left join area_info m on l.top_id=m.id and m.layer=2) a'+
                          ' where a.areaid in (@param1) @param2'+ //AREAID是权限
                          ' group by buildingid,buildingno,buildingname,buildingaddr,suburbname,areaname';
  //MTU树图定位
  SqlStr_BaseData[3,6]:=  'select a.mtuid,a.mtuno,a.mtuname,'+
                          ' case when a.buildingid<>-1 then ''MTU'' else null end as MTUSTATUS,'+
                          ' b.buildingid,b.buildingno,b.buildingname,'+
                          ' case when a.buildingid<>-1 then ''室内'' else ''室外'' end as isprogramname,'+
                          ' c.id suburbid,c.name suburbname,'+
                          ' d.id areaid,d.name areaname,'+
                          ' e.id cityid,e.name cityname'+
                          ' from mtu_info a'+
                          ' left join building_info b on a.buildingid=b.buildingid'+
                          ' left join area_info c on a.suburb=c.id and c.layer=3'+
                          ' left join area_info d on c.top_id=d.id and d.layer=2'+
                          ' left join area_info e on d.top_id=e.id and e.layer=1'+
                          ' where 1=1 @param1';
  //无线参数窗口
  SqlStr_BaseData[3,11]:= 'select a.mtuid,a.mtuno,b.status,decode(b.status,1,''上线'',0,''离线'',''未知'') statusname,'+
                          ' b.status_power,b.status_wlan,decode(h.tranlatevalue,null,''未知'',h.tranlatevalue) status_powername,decode(i.tranlatevalue,null,''未知'',i.tranlatevalue) status_wlanname,'+
                          ' nvl(c.alarmcounts,0) alarmcounts'+
                          ' from mtu_info a'+
                          ' left join mtu_status_list b on a.mtuid=b.mtuid'+
                          ' left join (select mtuid,count(1) alarmcounts from alarm_master_online where flowtache=2 group by mtuid) c on a.mtuid=c.mtuid '+
                          ' left join mtu_testresult_translate h on b.status_power=h.orderindex and h.comid=65 and h.paramid=3'+
                          ' left join mtu_testresult_translate i on b.status_wlan=i.orderindex and i.comid=69 and i.paramid=42'+
                          ' where a.mtuid=@param1';
  SqlStr_BaseData[3,12]:= 'select decode(a.paramid,50,''BC频段'',51,''信道号'',52,''系统标识'','+
                          ' 53,''网络标识'',54,''导频偏置'',55,''Slot cycle'','+
                          ' 56,''发送功率控制'',57,''误码率'') caption,decode(a.paramid,57,b.tranlatevalue,a.testresult) testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' left join mtu_testresult_translate b on a.comid=b.comid and a.paramid=b.paramid and a.testresult=to_char(b.orderindex)'+
                          ' where a.comid=@param2 and a.paramid>=50 and a.paramid<=57 and a.mtuid=@param1';
  SqlStr_BaseData[3,13]:= 'select decode(a.paramid,15,''基站'',1019,''RX场强'',1020,''EC/IO'') caption,'+
                          ' a.testresult testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (15,1019,1020) and a.mtuid=@param1';
  SqlStr_BaseData[3,14]:= 'select decode(a.paramid,1002,''(TX检测结果)TX场强'',1018,''(TX检测结果)接通误码率'') caption,'+
                          ' a.testresult testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (1002,1018) and a.mtuid=@param1';
  SqlStr_BaseData[3,15]:= 'select decode(a.paramid,59,''TX'',60,''T_ADD'',61,''T_DROP'',62,''T_COMP'',63,''T_TDROP'') caption,'+
                          ' a.testresult testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (59,60,61,62,63) and a.mtuid=@param1';
  SqlStr_BaseData[3,16]:= 'select * from (select a.valueindex,'+
                          ' max(case when a.paramid=1021 then ''激活集PN ''||a.testresult else null end) as caption,'+
                          ' max(case when a.paramid=58 then a.testresult else null end) as testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (1021,58) and a.mtuid =@param1'+
                          ' group by a.valueindex) order by testvalue';
  SqlStr_BaseData[3,17]:= 'select * from (select a.valueindex,'+
                          ' max(case when a.paramid=1021 then ''邻区PN ''||a.testresult else null end) as caption,'+
                          ' max(case when a.paramid=58 then a.testresult else null end) as testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (1021,58) and a.mtuid =@param1'+
                          ' group by a.valueindex) order by testvalue';
  SqlStr_BaseData[3,18]:= 'select * from (select a.valueindex,'+
                          ' max(case when a.paramid=1021 then ''FINGER_PN ''||a.testresult else null end) as caption,'+
                          ' max(case when a.paramid=58 then a.testresult else null end) as testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (1021,58) and a.mtuid =@param1'+
                          ' group by a.valueindex) order by testvalue';
  SqlStr_BaseData[3,19]:= 'select * from (select a.valueindex,'+
                          ' max(case when a.paramid=1021 then ''候选集PN ''||a.testresult else null end) as caption,'+
                          ' max(case when a.paramid=58 then a.testresult else null end) as testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (1021,58) and a.mtuid =@param1'+
                          ' group by a.valueindex) order by testvalue';
  SqlStr_BaseData[3,20]:= 'select a.valueindex,'+
                          ' max(case when a.paramid=15 then ''CSID ''||a.testresult else null end) as caption,'+
                          ' max(case when a.paramid=4 then a.testresult else null end) as testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=66 and a.paramid in (4,15) and a.mtuid=@param1'+
                          ' group by a.valueindex';
  SqlStr_BaseData[3,21]:= 'select a.valueindex,'+
                          ' max(case when a.paramid=15 then ''CSID ''||a.testresult else null end) as caption,'+
                          ' max(case when a.paramid=18 then a.testresult else null end) as testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=130 and a.paramid in (15,18) and a.mtuid=@param1'+
                          ' group by a.valueindex';
  SqlStr_BaseData[3,22]:= 'select decode(a.paramid,42,''WLAN状态'') caption,'+
                          ' decode(a.paramid,42,decode(b.tranlatevalue,null,a.testresult,b.tranlatevalue),a.testresult) testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' left join mtu_testresult_translate b on a.comid=b.comid and a.paramid=b.paramid and a.testresult=to_char(b.orderindex)'+
                          ' where a.comid=69 and a.paramid =42 and a.mtuid=@param1';
  SqlStr_BaseData[3,23]:= 'select a.valueindex,'+
                          ' max(case when a.paramid=1003 then a.testresult else null end) as caption,'+
                          ' max(case when a.paramid=24 then a.testresult else null end) as CQ,'+
                          ' max(case when a.paramid=1004 then a.testresult else null end) as XD'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=67 and a.paramid in (24,1003,1004) and a.mtuid=@param1'+
                          ' group by a.valueindex';
  SqlStr_BaseData[3,24]:= 'select * from (select decode(a.paramid,28,''测试时长'',23,''测试结果'',25,''上传速率'',26,''下载速率'',null) as caption,'+
                          ' decode(a.paramid,28,1,23,2,25,3,26,4,5) as ordervalue,'+
                          ' decode(a.paramid,23,decode(b.tranlatevalue,null,a.testresult,b.tranlatevalue),a.testresult) testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' left join mtu_testresult_translate b on a.comid=b.comid and a.paramid=b.paramid and a.testresult=to_char(b.orderindex)'+
                          ' where a.comid=134 and a.paramid in (23,25,26,28) and a.mtuid=@param1)'+
                          ' order by ordervalue';
  SqlStr_BaseData[3,25]:= 'select * from (select decode(a.paramid,28,''测试时长'',29,''发送的数据包数'',30,''接收的数据包数'',31,''最大时延'',32,''最小时延'',33,''平均时延'',34,''误码率'',null) as caption,'+
                          ' decode(a.paramid,28,1,29,2,30,3,31,4,32,5,33,6,34,7,8) as ordervalue,'+
                          ' a.testresult testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=135 and a.paramid in (28,29,30,31,32,33,34) and a.mtuid=@param1)'+
                          ' order by ordervalue';
  //异常事件监控制(此功能未开放)
  //未派告警
  //  SqlStr_BaseData[3,21]:= 'select * from alarm_master_online_view where flowtache=1 @param1 order by readed asc,sendtime desc';


  //告警综合查询
  SqlStr_BaseData[3,31]:= 'select * from alarm_master_online_view a where flowtache=2 @param1 order by sendtime desc';
  SqlStr_BaseData[3,32]:= 'select * from alarm_master_history_view a where 1=1 @param1 order by sendtime desc';


  //测试详单
  //画测试类型树
  SqlStr_BaseData[3,41]:= 'select * from dic_code_info t where t.dictype=21 order by t.dicorder';
  //显示各个MTU状态信息
  SqlStr_BaseData[3,42]:=' select * from mtu_recentstatue_view where mtuid=@param1';
  //呼叫测试节点
  SqlStr_BaseData[3,44]:= 'select * from'+
                            '(select a.taskid,b.mtuno,''呼叫测试命令'' comname,'+
                            ' max(case when a.comid=129 and a.paramid=6 then a.testresult else null end) as call,'+
                            ' max(case when a.comid=129 and a.paramid=7 then a.testresult else null end) as called,'+
                            ' max(case when a.comid=129 and a.paramid=2 then a.testresult else null end) as starttime,'+
                            ' max(case when a.comid=129 and a.paramid=12 then a.testresult else null end) as endtime,'+
                            ' max(case when a.comid=129 and a.paramid=13 then a.testresult else null end) as inDelaytime,'+
                            ' max(case when a.comid=129 and a.paramid=14 then a.testresult else null end ) as calldelaytime,'+
                            ' max(case when a.comid=129 and a.paramid=8 then a.testresult else null end) as calllong,'+
                            ' max(case when a.comid=129 and a.paramid=15 then a.testresult else null end) as CSID,'+
                            ' max(case when a.comid=129 and a.paramid=16 then d.tranlatevalue else null end) as calltry,'+
                            ' max(case when a.comid=129 and a.paramid=17 then d.tranlatevalue else null end) as callresult,'+
                            ' max(case when a.comid=131 and a.paramid=1008 then a.testresult else null end) as Pointchangecounts,'+
                            ' max(case when a.comid=131 and a.paramid=1007 then a.testresult else null end) as TCHchangecounts,'+
                            ' aa.WML,row_number() over (order by a.taskid desc) rowindex'+
                            ' from (@param1) a'+
                            ' left join'+
                                 '(select taskid,ltrim(max(sys_connect_by_path(WML,'';'')),'';'') as WML'+
                                   ' from'+
                                    ' (select taskid,valueindex,'+
                                    ' taskid+row_number() over (order by taskid) rn,'+
                                    ' row_number() over (partition by taskid order by valueindex) rn1,'+
                                    ' max(case when comid=130 and paramid=15 then testresult else null end)||''+''||'+
                                    ' max(case when comid=130 and paramid=18 then testresult else null end)||''+''||'+
                                    ' max(case when comid=130 and paramid=1002 then testresult else null end) as WML'+
                                    ' from (@param1) a'+
                                    ' where comid=130 and mtuid=@param2 @param4'+
                                    ' group by taskid,valueindex)'+
                                  ' start with rn1=1'+
                                  ' connect by rn-1=prior rn'+
                                  ' group by taskid) aa on a.taskid=aa.taskid'+
                            ' left join mtu_info b on a.mtuid=b.mtuid'+
                            ' left join mtu_command_define c on a.comid=c.comid'+
                            ' left join mtu_testresult_translate d on a.comid=d.comid and a.paramid=d.paramid and a.testresult=to_char(d.orderindex)'+
                            ' where  a.comid in (129,131) and a.mtuid=@param2 @param4'+
                            ' group by a.taskid,b.mtuno,aa.WML)'+
                            ' @param3';
  //MOS值测试命令节点
  SqlStr_BaseData[3,45]:=  'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' max(case when a.comid=132 and a.paramid=6 then a.testresult else null end) as call,'+
                          ' max(case when a.comid=132 and a.paramid=7 then a.testresult else null end) as called,'+
                          ' max(case when a.comid=132 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' max(case when a.comid=132 and a.paramid=12 then a.testresult else null end) as endtime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid=132 and a.paramid=8 then a.testresult else null end) as calllong,'+
                          ' max(case when a.comid=132 and a.paramid=21 then a.testresult else null end) as playvoice,'+
                          ' max(case when a.comid=132 and a.paramid=22 then a.testresult else null end) as recordvoice,'+
                          ' max(case when a.comid=132 and a.paramid=23 then a.testresult else null end) as testvalue,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where a.comid=132 and a.mtuid=@param2 @param4 '+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime)'+
                          ' @param3';
  //语音单通测试命令节点
  SqlStr_BaseData[3,46]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' max(case when a.comid=137 and a.paramid=6 then a.testresult else null end) as call,'+
                          ' max(case when a.comid=137 and a.paramid=7 then a.testresult else null end) as called,'+
                          ' max(case when a.comid=137 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' max(case when a.comid=137 and a.paramid=12 then a.testresult else null end) as endtime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid=137 and a.paramid=13 then a.testresult else null end) as inDelaytime,'+
                          ' max(case when a.comid=137 and a.paramid=14 then a.testresult else null end) as calldelaytime,'+
                          ' max(case when a.comid=137 and a.paramid=8 then a.testresult else null end) as calllong,'+
                          ' max(case when a.comid=137 and a.paramid=17 then a.testresult else null end) as callresult,'+
                          ' max(case when a.comid=137 and a.paramid=44 then a.testresult else null end) as voiceresult,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where a.comid=137 and a.mtuid=@param2 @param4 '+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime)'+
                          ' @param3';
  //被叫时延测试命令
  SqlStr_BaseData[3,47]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,'+
                          ' max(case when a.comid=133 and a.paramid=6 then a.testresult else null end) as call,'+
                          ' max(case when a.comid=133 and a.paramid=7 then a.testresult else null end) as called,'+
                          ' max(case when a.comid=133 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' max(case when a.comid=133 and a.paramid=12 then a.testresult else null end) as endtime,'+
                          ' max(case when a.comid=133 and a.paramid=13 then a.testresult else null end) as inDelaytime,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where a.comid=133 and a.mtuid=@param2 @param4 '+
                          ' group by a.taskid,b.mtuno,c.comname)'+
                          ' @param3';
  //场强检测通知
  SqlStr_BaseData[3,48]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,CCHVALUE,'+
                          ' max(case when a.comid=66 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join'+
                          '     (select taskid,ltrim(max(sys_connect_by_path(substr(CCHVALUE,1,length(CCHVALUE)-1),'';'')),'';'') as CCHVALUE from'+
                          '           ('+
                          '           select taskid,valueindex,'+
                          '           taskid+row_number() over (order by taskid) rn,'+
                          '           row_number() over (partition by taskid order by valueindex) rn1,'+
                          '           max(case when comid=66 and paramid=1019 then ''BSID:'' else null end)||'+
                          '           max(case when comid=66 and paramid=4 then ''CSID:'' else null end)||'+
                          '           max(case when comid=66 and paramid=15 then testresult||'','' else null end)||'+

                          '           max(case when comid=66 and paramid=1019 then ''RX:'' else null end)||'+
                          '           max(case when comid=66 and paramid=4 then ''场强:'' else null end)||'+
                          '           max(case when comid=66 and paramid=1019 then testresult||'','' else null end)||'+
                          '           max(case when comid=66 and paramid=4 then testresult||'','' else null end)||'+

                          '           max(case when comid=66 and paramid=1020 then ''VER:'' else null end)||'+
                          '           max(case when comid=66 and paramid=1023 then testresult||'','' else null end)||'+
                          '           max(case when comid=66 and paramid=1020 then ''EC/IO:'' else null end)||'+
                          '           max(case when comid=66 and paramid=1020 then testresult||'','' else null end) CCHVALUE'+
                          '           from (@param1) a'+
                          '           where comid=66 and mtuid=@param2 @param4'+
                          '           group by taskid,valueindex'+
                          '           )'+
                          '     start with rn1=1'+
                          '     connect by rn-1=prior rn'+
                          '     group by taskid) aa on a.taskid=aa.taskid'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid = 66 and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,CCHVALUE)'+
                          ' @param3';
  //WLAN速率测试命令
  SqlStr_BaseData[3,49]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' max(case when a.comid=134 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' max(case when a.comid=134 and a.paramid=12 then a.testresult else null end) as endtime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid=134 and a.paramid=28 then a.testresult else null end) as durationtime,'+
                          ' max(case when a.comid=134 and a.paramid=25 then a.testresult else null end) as uplink,'+
                          ' max(case when a.comid=134 and a.paramid=26 then a.testresult else null end) as downlink,'+
                          ' max(case when a.comid=134 and a.paramid=23 then a.testresult else null end) as testvalue,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where a.comid=134 and a.mtuid=@param2 @param4 '+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime)'+
                          ' @param3';
  //WLAN时延丢包误码测试命令
  SqlStr_BaseData[3,50]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' max(case when a.comid=135 and a.paramid=41 then a.testresult else null end) as pingaddr,'+
                          ' max(case when a.comid=135 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid=135 and a.paramid=28 then a.testresult else null end) as durationtime,'+
                          ' max(case when a.comid=135 and a.paramid=29 then a.testresult else null end) as sendpacket,'+
                          ' max(case when a.comid=135 and a.paramid=30 then a.testresult else null end) as receviepacket,'+
                          ' max(case when a.comid=135 and a.paramid=31 then a.testresult else null end) as maxdelay,'+
                          ' max(case when a.comid=135 and a.paramid=32 then a.testresult else null end) as mindelay,'+
                          ' max(case when a.comid=135 and a.paramid=33 then a.testresult else null end) as avgdelay,'+
                          ' max(case when a.comid=135 and a.paramid=34 then a.testresult else null end) as errpercent,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where a.comid=135 and a.mtuid=@param2 @param4 '+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime)'+
                          ' @param3';
  //WLAN场强检测通知
  SqlStr_BaseData[3,51]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,WLANVALUE,'+
                          ' max(case when a.comid=67 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join'+
                          '     (select taskid,ltrim(max(sys_connect_by_path(WLANVALUE,'';'')),'';'') as WLANVALUE from'+
                          '           ('+
                          '           select taskid,valueindex,'+
                          '           taskid+row_number() over (order by taskid) rn,'+
                          '           row_number() over (partition by taskid order by valueindex) rn1,'+
                          '           max(case when comid=67 and paramid=1003 then testresult else null end)||''+''||'+
                          '           max(case when comid=67 and paramid=24 then testresult else null end)||''+''||'+
                          '           max(case when comid=67 and paramid=1004 then testresult else null end) WLANVALUE'+
                          '           from (@param1) a'+
                          '           where comid=67 and mtuid=@param2 @param4'+
                          '           group by taskid,valueindex'+
                          '           )'+
                          '     start with rn1=1'+
                          '     connect by rn-1=prior rn'+
                          '     group by taskid) aa on a.taskid=aa.taskid'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid = 67 and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,WLANVALUE)'+
                          ' @param3';
  //WLAN掉线通知
  SqlStr_BaseData[3,52]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' max(case when a.comid=69 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid=69 and a.paramid=42 then a.testresult else null end) as errreason,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid = 69 and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime)'+
                          ' @param3';
  //MTS设备自身检测通知
  SqlStr_BaseData[3,53]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' max(case when a.comid=65 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid=65 and a.paramid=3 then a.testresult else null end) as powerstatus,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid = 65 and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime)'+
                          ' @param3';
  //MTU状态查询命令
  SqlStr_BaseData[3,54]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid=136 and a.paramid=35 then a.testresult else null end) as mtustatus,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid = 136 and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime)'+
                          ' @param3';
  //PPP拨号测试命令
  SqlStr_BaseData[3,55]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' max(case when a.comid=139 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid=139 and a.paramid=23 then a.testresult else null end) as testvalue,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid = 139 and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime)'+
                          ' @param3';
  //CDMA信息检测通知
  SqlStr_BaseData[3,56]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' decode(a.comid,73,''待机'',89,''通话'',null) as teststatus,'+
                          ' max(case when a.comid in (73,89) and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid in (73,89) and a.paramid=50 then a.testresult else null end) as bandclass,'+
                          ' max(case when a.comid in (73,89) and a.paramid=51 then a.testresult else null end) as chan,'+
                          ' max(case when a.comid in (73,89) and a.paramid=52 then a.testresult else null end) as sid,'+
                          ' max(case when a.comid in (73,89) and a.paramid=53 then a.testresult else null end) as nid,'+
                          ' max(case when a.comid in (73,89) and a.paramid=54 then a.testresult else null end) as pn,'+
                          ' max(case when a.comid in (73,89) and a.paramid=55 then a.testresult else null end) as sci,'+
                          ' max(case when a.comid in (73,89) and a.paramid=56 then a.testresult else null end) as tx_adj,'+
                          ' max(case when a.comid in (73,89) and a.paramid=57 then d.tranlatevalue else null end) as fer,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' left join mtu_testresult_translate d on a.comid=d.comid and a.paramid=d.paramid and a.testresult=to_char(d.orderindex)'+
                          ' where  a.comid in (73,89) and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime,decode(a.comid,73,''待机'',89,''通话'',null))'+
                          ' @param3';
  //切换相关参数检测通知
  SqlStr_BaseData[3,57]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' decode(a.comid,74,''待机'',90,''通话'',null) as teststatus,'+
                          ' max(case when a.comid in (74,90) and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid in (74,90) and a.paramid=59 then a.testresult else null end) as TX,'+
                          ' max(case when a.comid in (74,90) and a.paramid=60 then a.testresult else null end) as T_ADD,'+
                          ' max(case when a.comid in (74,90) and a.paramid=61 then a.testresult else null end) as T_DROP,'+
                          ' max(case when a.comid in (74,90) and a.paramid=62 then a.testresult else null end) as T_COMP,'+
                          ' max(case when a.comid in (74,90) and a.paramid=63 then a.testresult else null end) as T_TDROP,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid in (74,90) and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime,decode(a.comid,74,''待机'',90,''通话'',null))'+
                          ' @param3';
  //Finger信息检测通知
  SqlStr_BaseData[3,58]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,testvalue,'+
                          ' decode(a.comid,75,''待机'',91,''通话'',null) as teststatus,'+
                          ' max(case when a.comid in (75,91) and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid in (75,91) and a.paramid=1001 then a.testresult else null end) as paramscount,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join'+
                          '     (select taskid,ltrim(max(sys_connect_by_path(testvalue,'';'')),'';'') as testvalue from'+
                          '           ('+
                          '           select taskid,valueindex,'+
                          '           taskid+row_number() over (order by taskid) rn,'+
                          '           row_number() over (partition by taskid order by valueindex) rn1,'+
                          '           max(case when comid in (75,91) and paramid=1021 then testresult else null end)||'':''||'+
                          '           max(case when comid in (75,91) and paramid=58 then testresult else null end) testvalue'+
                          '           from (@param1) a'+
                          '           where comid in (75,91) and mtuid=@param2 @param4'+
                          '           group by taskid,valueindex'+
                          '           )'+
                          '     start with rn1=1'+
                          '     connect by rn-1=prior rn'+
                          '     group by taskid) aa on a.taskid=aa.taskid'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid in (75,91) and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,testvalue,a.collecttime,decode(a.comid,75,''待机'',91,''通话'',null))'+
                          ' @param3';
  //激活集信息检测通知
  SqlStr_BaseData[3,59]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,testvalue,'+
                          ' decode(a.comid,76,''待机'',92,''通话'',null) as teststatus,'+
                          ' max(case when a.comid in (76,92) and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid in (76,92) and a.paramid=1001 then a.testresult else null end) as paramscount,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join'+
                          '     (select taskid,ltrim(max(sys_connect_by_path(testvalue,'';'')),'';'') as testvalue from'+
                          '           ('+
                          '           select taskid,valueindex,'+
                          '           taskid+row_number() over (order by taskid) rn,'+
                          '           row_number() over (partition by taskid order by valueindex) rn1,'+
                          '           max(case when comid in (76,92) and paramid=1021 then testresult else null end)||'':''||'+
                          '           max(case when comid in (76,92) and paramid=58 then testresult else null end) testvalue'+
                          '           from (@param1) a'+
                          '           where comid in (76,92) and mtuid=@param2 @param4'+
                          '           group by taskid,valueindex'+
                          '           )'+
                          '     start with rn1=1'+
                          '     connect by rn-1=prior rn'+
                          '     group by taskid) aa on a.taskid=aa.taskid'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid in (76,92) and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,testvalue,a.collecttime,decode(a.comid,76,''待机'',92,''通话'',null))'+
                          ' @param3';
  //候选集信息检测通知
  SqlStr_BaseData[3,60]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,testvalue,'+
                          ' decode(a.comid,77,''待机'',93,''通话'',null) as teststatus,'+
                          ' max(case when a.comid in (77,93) and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid in (77,93) and a.paramid=1001 then a.testresult else null end) as paramscount,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join'+
                          '     (select taskid,ltrim(max(sys_connect_by_path(testvalue,'';'')),'';'') as testvalue from'+
                          '           ('+
                          '           select taskid,valueindex,'+
                          '           taskid+row_number() over (order by taskid) rn,'+
                          '           row_number() over (partition by taskid order by valueindex) rn1,'+
                          '           max(case when comid in (77,93) and paramid=1021 then testresult else null end)||'':''||'+
                          '           max(case when comid in (77,93) and paramid=58 then testresult else null end) testvalue'+
                          '           from (@param1) a'+
                          '           where comid in (77,93) and mtuid=@param2 @param4'+
                          '           group by taskid,valueindex'+
                          '           )'+
                          '     start with rn1=1'+
                          '     connect by rn-1=prior rn'+
                          '     group by taskid) aa on a.taskid=aa.taskid'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid in (77,93) and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,testvalue,a.collecttime,decode(a.comid,77,''待机'',93,''通话'',null))'+
                          ' @param3';
  //邻区信息检测通知
  SqlStr_BaseData[3,61]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,testvalue,'+
                          ' decode(a.comid,78,''待机'',94,''通话'',null) as teststatus,'+
                          ' max(case when a.comid in (78,94) and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' a.collecttime,'+
                          ' max(case when a.comid in (78,94) and a.paramid=1001 then a.testresult else null end) as paramscount,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join'+
                          '     (select taskid,ltrim(max(sys_connect_by_path(testvalue,'';'')),'';'') as testvalue from'+
                          '           ('+
                          '           select taskid,valueindex,'+
                          '           taskid+row_number() over (order by taskid) rn,'+
                          '           row_number() over (partition by taskid order by valueindex) rn1,'+
                          '           max(case when comid in (78,94) and paramid=1021 then testresult else null end)||'':''||'+
                          '           max(case when comid in (78,94) and paramid=58 then testresult else null end) testvalue'+
                          '           from (@param1) a'+
                          '           where comid in (78,94) and mtuid=@param2 @param4'+
                          '           group by taskid,valueindex'+
                          '           )'+
                          '     start with rn1=1'+
                          '     connect by rn-1=prior rn'+
                          '     group by taskid) aa on a.taskid=aa.taskid'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' where  a.comid in (78,94) and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno,c.comname,testvalue,a.collecttime,decode(a.comid,78,''待机'',94,''通话'',null))'+
                          ' @param3';
  //平台呼叫
  SqlStr_BaseData[3,62]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,''中心平台呼叫MTU测试结果'' comname,'+
                          ' max(case when a.comid=140 and a.paramid=2 then a.testresult else null end) as starttime,'+
                          ' max(case when a.comid=140 and a.paramid=12 then a.testresult else null end) as endtime,'+
                          ' max(case when a.comid=140 and a.paramid=8 then a.testresult else null end) as calllong,'+
                          ' max(case when a.comid=140 and a.paramid=13 then a.testresult else null end) as inDelaytime,'+
                          ' max(case when a.comid=140 and a.paramid=14 then a.testresult else null end ) as calldelaytime,'+
                          ' max(case when a.comid=140 and a.paramid=17 then d.tranlatevalue else a.testresult end) as callresult,'+
                          ' max(case when a.comid=140 and a.paramid=44 then e.tranlatevalue else a.testresult end) as voiceresult,'+
                          ' row_number() over (order by a.taskid desc) rowindex'+
                          ' from (@param1) a'+
                          ' left join mtu_info b on a.mtuid=b.mtuid'+
                          ' left join mtu_command_define c on a.comid=c.comid'+
                          ' left join mtu_testresult_translate d on a.comid=d.comid and a.paramid=d.paramid and a.testresult=to_char(d.orderindex)'+
                          ' left join mtu_testresult_translate e on a.comid=e.comid and a.paramid=e.paramid and a.testresult=to_char(e.orderindex)'+
                          ' where  a.comid=140 and a.mtuid=@param2 @param4'+
                          ' group by a.taskid,b.mtuno)'+
                          ' @param3';

  //CDMA资源管理
  //分局 室分点 AP 连接器 PHS CDMA
  SqlStr_BaseData[4,1] := 'select t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.apid Captionid,t.apno CaptionName,0 longitude,0 latitude from ap_info_view t'+
                          ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,2] := 'select t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.csid Captionid,t.cs_id CaptionName,0 longitude,0 latitude from cs_info_view t'+
                          ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,3] := 'select * from ('+
                          'select t.areaid,t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.cdmaid Captionid,t.cdmaname CaptionName,t.longitude,t.latitude from cdma_info_view t'+
                          ' union all select t.areaid,t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.drsid Captionid,t.drsname CaptionName,t.longitude,t.latitude from drs_info_view t) t'+
                          ' where t.areaid in (@param1) @param2';
//                          'select t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.cdmaid Captionid,t.cdmaname CaptionName,t.longitude,t.latitude from cdma_info_view t'+
//                          ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,4] := 'select t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.linkid Captionid,t.linkno CaptionName,0 longitude,0 latitude from linkmachine_info_view t'+
                          ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,5] := 'select t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.buildingid Captionid,t.buildingname CaptionName,t.longitude,t.latitude from building_info_view t'+
                          ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,6] := 'select t.id suburbid,t.name suburbname,-1 buildingid,null buildingname,t.id Captionid,t.name CaptionName,0 longitude,0 latitude  from area_info t'+
                          ' where t.top_id in (@param1) and t.layer=3 @param2';
  SqlStr_BaseData[4,7] := 'select t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.switchid Captionid,t.switchno CaptionName,0 longitude,0 latitude from switch_info_view t'+
                          ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,8] := 'select t.suburbid,t.suburbname,t.buildingid,t.buildingname,t.csid Captionid,t.survery_id CaptionName,0 longitude,0 latitude from cs_info_view t'+
                          ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,9] := 'select @param1,@param2 Captionid,@param3 CaptionName from @param4'+
                          ' where areaid in (@param5) @param6';
  //CDMA刷新用   其中 t.areaid in (@param1) 是区域权限
  SqlStr_BaseData[4,11] := 'select * from cdma_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  //判断是否存在
  SqlStr_BaseData[4,12] := 'select 1 from @param1 t'+
                           ' where upper(@param2)=upper(''@param3'') @param4';
  //针对整个SQL进行操作
  SqlStr_BaseData[4,13] := '@param1';



  //MTU资源管理
  //取告警内容模版
  SqlStr_BaseData[4,21] := 'select * from mtu_alarm_model t where t.parentmodelid<>0 and t.parentmodelid<>1';
  //刷新MTU
  SqlStr_BaseData[4,22] := 'select * from mtu_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  //刷新C网信息
  SqlStr_BaseData[4,23] := 'select t.cdmaid,t.cdmatype,decode(t.cdmatype,1,''直放站'',2,''RRU'',3,''宏基站'',''未知'') cdmatypename,t.pncode,t.address'+
                           ' from cdma_info t'+
                           ' where t.cdmaid=@param1';
  SqlStr_BaseData[4,41] := 'select * from cs_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,42] := 'select * from linkmachine_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,43] := 'select * from switch_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,44] := 'select * from ap_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,45] := 'select * from building_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  SqlStr_BaseData[4,46] := 'select DRSID,DRSNO,R_DEVICEID,DRSNAME,DRSADRESS,DRSPHONE,' +
                           '       DRSTYPE,b.dicname as DRSTYPENAME,' +
                           '       DRSMANU, C.Dicname as DRSMANUNAME' +
                           '  from drs_info t' +
                           '  left join (select * from dic_code_info where dictype=51) b on t.drstype=b.diccode' +
                           '  left join (select * from dic_code_info where dictype=54) c on t.drsmanu=c.diccode' +
                           ' where 1=1 @param1';
  SqlStr_BaseData[4,47] := 'select * from drs_info_view t'+
                           ' where t.areaid in (@param1) @param2 ';
  SqlStr_BaseData[4,48] := 'select ''0'' as proviceid,''全省'' as provicename,cityid as cityid,cityname as cityname,' +
                           '       areaid,areaname,suburbid,suburbname,isprogram,isprogramname,' +
                           '       buildingid,buildingname,''DRS'' as DRS,' +
                           '       drsid,drsname||''(''||drsstatusname||'')'' as drsname,drsno,drsadress,drsphone' +
                           '  from drs_info_view' +
                           ' where isprogram=1' +
                           '   and @drsid=@param1' +
                           ' order by cityid,areaid,suburbid,drsid ';
  SqlStr_BaseData[4,49] := 'select ''0'' as proviceid,''全省'' as provicename,cityid as cityid,cityname as cityname,' +
                           '       areaid,areaname,suburbid,suburbname,isprogram,isprogramname,''DRS'' as DRS,' +
                           '       drsid,drsname||''(''||drsstatusname||'')'' as drsname,drsno,drsadress,drsphone' +
                           '  from drs_info_view' +
                           ' where isprogram=0' +
                           '   and drsid=@param1' +
                           ' order by cityid,areaid,suburbid,drsid ';
  SqlStr_BaseData[4,50] := 'select ''0'' as proviceid,''全省'' as provicename,cityid as cityid,cityname as cityname,' +
                           '       areaid,areaname,suburbid,suburbname,isprogram,isprogramname,' +
                           '       buildingid,buildingname,''DRS'' as DRS,' +
                           '       drsid,drsname||''(''||drsstatusname||'')'' as drsname,drsno,drsadress,drsphone' +
                           ' from drs_info_view' +
                           ' where (upper(drsno) like upper(''%@param1%'')' +
                           '        or upper(drsname) like upper(''%@param1%'')' +
                           '        or upper(drsadress) like upper(''%@param1%'')' +
                           '        or upper(drsphone) like upper(''%@param1%'')' +
                           '        )';


end;

procedure InitSQLVar();
begin
  Init_SqlStr_Common();  //0 公用
  Init_SqlStr_Resource();//1 资源管理
  Init_SqlStr_BaseData();//2 基础数据管理
end;


end.
