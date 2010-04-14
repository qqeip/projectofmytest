unit Ut_SqlDeclare_Define;

interface

uses
  Classes,SysUtils,Variants,ADODB,Dialogs ;

const
  MaxType  = 50;
  SQLCount = 100;
type
  PByte = array[1..MaxType] of array of string;  // ��̬��ά����

  var
  SqlStr_Common : PByte; //����
  SqlStr_Resource :PByte; // ��Դ
  SqlStr_BaseData :PByte; // ��������
  //��ָ��AdoQuery��ִ��ָ��SQL���
  procedure ExecTheSQL(Var Ado_LocalQuery: TADOQuery; TheSQLStr: String);

  function ProduceFlowNumID(var Sp_Alarm_FlowNumber: TADOStoredProc; I_FLOWNAME: string; I_SERIESNUM: integer):Integer;

  function GetRecCount(var TheADOQuery: TADOQuery; TheSql:string):integer;

  procedure OpenTheDataSet(var TheADOQuery: TADOQuery; thesql:string);

  //���Զ��SQL�������ɲ����滻�ĺ���
  Function ReplaceSQLParam(const TheSQL: string; OwnerData: OleVariant):String;
  //��ָ������ֵ���浽���ݿ��ת��������HoldTime=false��ʾ������ʱ�䲿��
  function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
  //��ʼ���漰��SQLִ�����
  procedure InitSQLVar();

  //��ʼ������SQL���
  procedure Init_SqlStr_Common();
  //��ʼ����Դ����SQL���
  procedure Init_SqlStr_Resource();
  //��ʼ����������SQL���
  procedure Init_SqlStr_BaseData();
implementation

//��ָ��AdoQuery��ִ��ָ��SQL���
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
      Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //��ˮ������
      Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //�����������ˮ�Ÿ���
      execproc;
      result:=Parameters.parambyname('O_FLOWVALUE').Value; //����ֵΪ���ͣ�����ֻ�������еĵ�һ��ֵ�����´η���ֵΪ��result+I_SERIESNUM
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

//���Զ��SQL�������ɲ����滻�ĺ���
Function ReplaceSQLParam(const TheSQL: string; OwnerData: OleVariant):String;
var
  i: integer;
  paramname: string;
begin
  Result:=TheSQL;
  if varIsArray(OwnerData) then
  begin  //��ʽ [γ��1��γ��2������]
    for i := varArrayLowBound(OwnerData, 1)+3 to varArrayHighBound(OwnerData, 1) do
    begin
      paramname:='@Param'+inttostr(i-2);
      Result:=StringReplace(Result, paramname, OwnerData[i], [rfReplaceAll, rfIgnoreCase]);
    end;
  end;
end;

//��ָ������ֵ���浽���ݿ��ת��������HoldTime=false��ʾ������ʱ�䲿��
function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
begin
  if HoldTime then
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD HH:MI:SS')+')'
  else
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD')+')';
end;

{*********************************0����SQL***************************************
  SqlStr_Common  ��Ź���SQL���
********************************************************************************}
procedure Init_SqlStr_Common();
begin
  //dic_type_info- SqlStr_Common[1]
  SetLength(SqlStr_Common[1], SQLCount);
  //��ȡ�û�������Ϣ����������
  SqlStr_Common[1,1]:='select * from userinfo where userid=@Param1';
  //��ȡָ�����͵��ֵ������û����� ComBox����
  SqlStr_Common[1,2]:='select DICCODE as thecode,DICNAME as thename from DIC_CODE_INFO where PARENTID <>-1 and dictype=@Param1 and ifineffect=1 order by dicorder';
  //��ѯָ���ĵ���
  SqlStr_Common[1,3]:='select * from area_info where top_id in (-1,@Param1) or id=@Param2 order by id';
  //��ѯָ���Ľ���
  SqlStr_Common[1,4]:='select * from area_info where id in (0,@Param1,@Param2) order by id';
  //��ȡ�û�������Ϣ����������
  SqlStr_Common[1,5]:='select * from userinfo where userno=''@Param1''';
  //��ȡMTU���� ���� 1 Ϊ���� 2 Ϊ�������
  SqlStr_Common[1,6]:='select comid as thecode,comname as thename from mtu_command_define where ifineffect=1 and COMTYPE=@Param1';
  //��ȡMTU����
  SqlStr_Common[1,7]:='select paramid as thecode,paramname as thename from  mtu_param_define where ifineffect=1';
  //��ȡAREA
  SqlStr_Common[1,8]:='select id as thecode,name as thename from  area_info ';
  //��ȡָ���ֵ��������ֵ
  //SqlStr_Common[1,9]:='select nvl(max(diccode),0) diccode from dic_code_info where dictype =@Param1';
  SqlStr_Common[1,9]:='select diccode from dic_code_info where dictype =@Param1 order by diccode desc';

  //��ȡָ�����е���ֵ
  SqlStr_Common[1,10]:='select @Param1.Nextval as ID from dual';

  //��ȡȫ���澯����
  SqlStr_Common[1,11]:='select * from dic_code_info where dictype=11 order by diccode';

  //�澯�ۺϲ�ѯ�����ߣ�
  SqlStr_Common[1,12]:='select a.alarmid �澯���,b.alarmcontentname �澯����,'+
    'g.dicname as �澯����,h.dicname as �澯�ȼ�,a.sendtime ����ʱ��,a.removetime ����ʱ��,'+
    'c.mtuname MTU����,c.mtuno MTU�豸���,c.overlay MTU��������,c.mtuaddr MTUλ��,'+
    'c.call �绰����,d.buildingname �ҷֵ�����,'+
    'd.address �ҷֵ��ַ,e.name as ����,f.name as ���� from alarm_master_online a '+
    'left join mtu_alarm_content b on a.alarmcontentcode=b.alarmcontentcode '+
    'left join dic_code_info g on b.alarmkind=g.diccode and g.dictype=11 '+
    'left join dic_code_info h on b.alarmlevel=h.diccode and h.dictype=10 '+
    'left join mtu_info c on a.mtuid=c.mtuid '+
    'left join building_info d on c.buildingid=d.buildingid '+
    'left join area_info e on d.areaid=e.id and e.layer=3 '+
    'left join area_info t1 on e.top_id=t1.id and t1.layer=2 '+
    'left join area_info f on t1.top_id=f.id and f.layer=1 '+
    'where a.flowtache=2 @param1 order by a.alarmid';
  //�澯�ۺϲ�ѯ����ʷ��
  SqlStr_Common[1,13]:='select a.alarmid �澯���,b.alarmcontentname �澯����,'+
    'g.dicname as �澯����,h.dicname as �澯�ȼ�,a.sendtime ����ʱ��,a.removetime ����ʱ��,'+
    'c.mtuname MTU����,c.mtuno MTU�豸���,c.overlay MTU��������,c.mtuaddr MTUλ��,'+
    'c.call �绰����,d.buildingname �ҷֵ�����,'+
    'd.address �ҷֵ��ַ,e.name as ����,f.name as ���� from alarm_master_history a '+
    'left join mtu_alarm_content b on a.alarmcontentcode=b.alarmcontentcode '+
    'left join dic_code_info g on b.alarmkind=g.diccode and g.dictype=11 '+
    'left join dic_code_info h on b.alarmlevel=h.diccode and h.dictype=10 '+
    'left join mtu_info c on a.mtuid=c.mtuid '+
    'left join building_info d on c.buildingid=d.buildingid '+
    'left join area_info e on d.areaid=e.id and e.layer=3 '+
    'left join area_info t1 on e.top_id=t1.id and t1.layer=2 '+
    'left join area_info f on t1.top_id=f.id and f.layer=1 '+
    'where a.flowtache=3 @param1 order by a.alarmid';

  //��ȡϵͳ��������
  SqlStr_Common[1,14]:='select itemcode, itemkind, itemcontent, setvalue, itemnote from sys_param_config where itemkind=@param1 and itemcode=@param2';
  //****************    �� 2ά SQL Ϊ ��ͼ����ʹ��    ******************************************
  SetLength(SqlStr_Common[2], SQLCount);
  //��ѯȫ������
  SqlStr_Common[2,1]:='select * from area_info where layer =1 order by id';
  //��ѯָ������
  SqlStr_Common[2,2]:='select * from area_info where layer =1 and id =@Param1 order by id';
  //��ѯĳ���е�ȫ������
  SqlStr_Common[2,3]:='select * from area_info where layer =2 and top_id =@Param1 order by id';
  //��ѯָ������
  SqlStr_Common[2,4]:='select * from area_info where layer =2 and id=@Param1 order by id';
  SqlStr_Common[2,75]:= 'select * from area_info where layer =3 and top_id =@Param1 order by id';
  //��ѯĳ���ص������ҷֵ�
  SqlStr_Common[2,5]:='select buildingid,buildingno,buildingname,NETTYPE from building_info where areaid=@Param1 order by buildingid';
  //��ѯĳ�ҷֵ�����н�����
  SqlStr_Common[2,6]:='select switchid,switchno from switch_info where buildingid=@Param1 order by switchid';
  //��ѯĳ�ҷֵ������PHS��վ
  SqlStr_Common[2,7]:='select csid,netaddress,survery_id from cs_info where buildingid=@Param1 order by netaddress';
  //��ѯĳ�������µ�����AP
  SqlStr_Common[2,8]:='select * from ap_info where switchid=@Param1 order by apid';
  //��ѯĳ�ҷֵ��µ��������������������µ�MTU����
  SqlStr_Common[2,9]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a  where a.buildingid=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' where b.buildingid=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''��������'' as name,0 as layer from dual ';
  //��ѯĳAP�µ��������������������µ�MTU����
  SqlStr_Common[2,10]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a  where a.linkap=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' where b.linkap=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''��������'' as name,0 as layer from dual ';
  //��ѯĳPHS�µ��������������������µ�MTU����
  SqlStr_Common[2,11]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a  where a.linkcs=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' where b.linkcs=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''��������'' as name,0 as layer from dual';
  //��ѯĳ������������Ϣ
  SqlStr_Common[2,12]:='select * from linkmachine_info where linkid=@Param1';
  //��ѯĳ���������µ��������������������µ�MTU����
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
                      ' union select 0 as id,-1 as top_id, ''��������'' as name,0 as layer from dual ';

  //20090317����
  //��ѯĳ�ҷֵ������CDMA��վ
  SqlStr_Common[2,14]:='select cdmaid,cdmaname,cdmano,cdmatype from cdma_info where buildingid=@Param1 order by cdmaname';
  //��ѯĳCDMA�µ��������������������µ�MTU����
  SqlStr_Common[2,15]:='select a.linkid as id,0 as top_id,'+
                      ' a.linkno||''(''||decode(a.linkequipment,1,''P'',2,''W'',3,''P+W'')||''  '' ||a.linkaddr||'')'' as name,1 as layer'+
                      ' from linkmachine_info a  where a.linkcdma=@Param1'+
                      ' union'+
                      ' select a.mtuid as id,a.linkid as top_id,a.mtuname||''(''||a.mtuaddr||'')'' as name,2 as layer'+
                      ' from mtu_info a'+
                      ' inner join linkmachine_info b on a.linkid=b.linkid'+
                      ' where b.linkcdma=@Param2'+
                      ' union select 0 as id,-1 as top_id, ''��������'' as name,0 as layer from dual'; 
  //��ѯĳ���ص�ȫ���־�
  SqlStr_Common[2,16]:='select * from area_info where layer =3 and top_id =@Param1 order by id';
  //��ѯָ���־�
  SqlStr_Common[2,17]:='select * from area_info where layer =3 and id=@Param1 order by id';
  //ģ����ѯ�ҷֵ�
  SqlStr_Common[2,18]:= 'select * from'+
                        ' (select buildingid,buildingname,ROW_NUMBER () over (order by buildingname) rn from  building_info_view where @Param1 like ''%@Param2%''@Param3)'+
                        ' where rn<=5';
  //���ڵ���Ϣ����
  SqlStr_Common[2,19]:='select buildingid,buildingno as �ҷֵ��� ,buildingname  as �ҷֵ�����,'+
                         ' address as ��ַ,longitude as ����,latitude as γ��,'+
                         ' nettypename as ������������,factoryname as ���ɳ���, connecttypename as ���뷽ʽ,'+
                         ' buildingtypename as �ҷֵ�����,floorcount as ¥����Ŀ,buildingarea as ¥�����,suburbname as �����־�,suburbid, agentcompanyname as ��ά��˾'+
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
//  SqlStr_Common[2,23] := 'select decode(alarmkindname,''ȫ���澯'',1,2) as id,'+
//                                 'decode(alarmkindname,''ȫ���澯'',0,1) as top_id,'+
//                                 'decode(alarmkindname,''ȫ���澯'',1,2) as layer,'+
//                                 ' a.alarmkindname||''(''||a.counts||''���澯)'' as name from'+
//                                 ' (select decode(Grouping(t.alarmkindname),1,''ȫ���澯'',alarmkindname) as alarmkindname, count(1) as counts'+
//                                 ' from alarm_master_online_view t where t.flowtache=2 @Param1'+
//                                 ' group by rollup(t.alarmkindname)) a';
  SqlStr_Common[2,23] := 'select a.id,nvl(prior a.id,0) as top_id,' + 
                         '       decode(alarmlevelname,''MTUȫ���澯'',1,''DRSȫ���澯'',1,''MTU����澯'',2,''DRS����澯'',2,3) as layer,' +
                         '       decode(alarmlevelname,''MTUȫ���澯'',alarmlevelname||''(''||counts||''���澯)'',' +
                         '                             ''DRSȫ���澯'',alarmlevelname||''(''||counts||''���澯)''' +
                         '             ,alarmkindname||''(''||counts||''���澯)'') as name' +
                         '  from   (select b.*,rownum as id from' +
                         '           (' +
                         '            (select decode(Grouping(t.alarmlevelname),1,''MTUȫ���澯'',decode(grouping(t.alarmkindname),1,''MTU����澯'',''MTU''||alarmlevelname)) as alarmlevelname,' +
                         '                    decode(Grouping(t.alarmkindname),1,decode(Grouping(t.alarmlevelname),1,''MTU����澯'',''MTU''||t.alarmlevelname),''MTU''||alarmkindname) as alarmkindname,' +
                         '                     count(1) as counts' +
                         '                from alarm_master_online_view t where t.flowtache=2 @Param1' +
                         '               group by rollup(t.alarmlevelname,t.alarmkindname)' +
                         '              )' +
                         '              union' +
                         '             (select decode(Grouping(t.alarmlevelname),1,''DRSȫ���澯'',decode(grouping(t.alarmkindname),1,''DRS����澯'',''DRS''||alarmlevelname)) as alarmlevelname,' +
                         '                     decode(Grouping(t.alarmkindname),1,decode(Grouping(t.alarmlevelname),1,''DRS����澯'',''DRS''||t.alarmlevelname),''DRS''||alarmkindname) as alarmkindname,' +
                         '                     count(1) as counts' +
                         '                from alarm_DRS_master_online_view t where t.flowtache=2 @Param2' +
                         '               group by rollup(t.alarmlevelname,t.alarmkindname)' +
                         '              )' +
                         '            )b' +
                         '          ) a ' +
                         ' connect by prior alarmkindname=alarmlevelname start with (alarmlevelname=''MTUȫ���澯'' or alarmlevelname=''DRSȫ���澯'')';
  SqlStr_Common[2,24] := 'select mtuid,mtuname as MTU����,mtuno as MTU�ⲿ���,overlay as ��������,'+
                         'mtuaddr as MTUλ��,call as �绰����,called as ���к���, '+
                         'MTUSTATUS as MTU״̬,updatetime ״̬���ʱ��,linkno as ������,'+
                         'buildingname as �����ҷֵ�,isprogramname �ҷ����,mainlook_apname �����AP,mainlook_phsname �����PHS,mainlook_cnetname �����C��,'+
                         ' cdmatypename C����Դ����,cdmaaddress C����Դ��װλ��,pncode PN��,'+
                         ' buildingid,suburbid,areaid,cityid'+
                         ' from mtu_info_view t where 1=1 @param1 order by mtuname';
  SqlStr_Common[2,25] := 'select taskid ������,comname as ��������,status,statusname as ����״̬,'+
                         ' testresult as ���Խ��,asktime as �������ʱ��, '+
                         ' rectime as ���ղ��Խ��ʱ��,mtuno as MTU����,buildingname as �����ҷֵ�,'+
                         ' username as �û���,comid,mtuid,buildingid,cityid '+
                         ' from mtu_testtask_online_view t where 1=1 @param1 and userid<>-1 and status<>7 order by taskid desc';

  SqlStr_Common[2,26]:=  'select cdmaid,cdmano as C����Դ��� ,cdmaname  as C����Դ����,'+
                         ' cdmatypename as C����Դ����,address as C����Դ��װλ��,cover as C����Դ���Ƿ�Χ,'+
                         ' factorytypename as C����Դ����,devicetypename as ��Դ�豸�ͺ�,'+
                         ' belong_msc as ����MSC���,belong_bsc as ����BSC���,'+
                         ' belong_cell as �����������, belong_bts as ������վ���,'+
                         ' pncode as PN��,powertypename as C����Դ����,buildingname as �����ҷֵ�,buildingid'+
                         ' from cdma_info_view t  where 1=1 @Param1 order by cdmaname';
  SqlStr_Common[2,27]:='select buildingid, buildingname from building_info'+
                       ' where areaid in (select id from (select * from area_info '+
                       ' start with id=@Param1 CONNECT BY PRIOR id=top_id) '+
                       ' where layer=3) order by buildingname ';
  SqlStr_Common[2,28]:='select SWITCHID,SWITCHNO as �����������,MACADDR as �����ַ,MANAGEADDR as �����ַ,UPLINKPORT as �����˿�,POP as pop,buildingname as �����ҷֵ�,buildingid '+
                         ' from switch_info_view  t where 1=1 @param1 order by SWITCHNO';
  SqlStr_Common[2,29]:='select t.linkid,t.linkno as ���������,t.linkaddr as ������λ��,t.linktype as ����������,t.istrunk as �Ƿ�ɷ�,'+
                         ' t.trunkaddr as �ɷ�λ��,t.linkequipment as �����豸����,t.linkcs as ���ӻ�վ,t.linkap as ����AP,'+
                         ' t.buildingname as �����ҷֵ�,t.buildingid from linkmachine_info_view t where 1=1 @param1 order by linkno';
  SqlStr_Common[2,30]:='select t.mtuid,t.mtuno as MTU���,t.mtuname as MTU����,t.mtutypename as MTU����,t.mtuaddr as MTUλ��,t.overlay as ��������,'+
                       't.call as �绰����,t.called as ���к���,t.linkno as �϶�������,t.mtustatus as �Ƿ�����,t.modelname as �澯����ģ��,'+
                       't.buildingname as �����ҷֵ�,t.buildingid from mtu_info_view t where 1=1 @param1 order by t.mtuno ';
  SqlStr_Common[2,31]:='select t.csid,t.CS_ID,t.SURVERY_ID as ������,t.cs_type as ��վ����,t.NETADDRESS as ��Ԫ��Ϣ,'+
                       ' t.CSADDR as ��վ��ַ,t.CS_COVER as ���Ƿ�Χ,t.buildingname as �����ҷֵ�,t.buildingid '+
                       ' from cs_info_view t where 1=1 @param1 order by t.cs_id';
  SqlStr_Common[2,32]:='select t.apid,t.apno as �������,t.connecttypename as ��������,t.apport as ��Ӧ�˿�,t.factoryname as ��Ӧ��,'+
                       ' t.apkindname as AP�ͺ�,t.appropertyname as AP����,t.appower as ����,t.powerkindname as ���緽ʽ ,'+
                       ' t.frequency as Ƶ��,t.APaddr as AP��ַ,t.overlay as ���Ƿ�Χ,t.manageaddrseg as AP�����ַ��,'+
                       ' t.apip as APIP,t.gwaddr as ���ص�ַ,t.macaddr as MAC��ַ,t.businessvlan as ҵ��VLAN,t.managevlan as ����VLAN,'+
                       ' t.switchno as ����������,t.buildingname as �����ҷֵ�,t.switchid ,t.buildingid'+
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
  SqlStr_Common[2,40] := 'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.���к���,a.���к���,a.���Կ�ʼʱ��,'+
                         ' a.���Խ���ʱ��,a.collecttime as �ɼ�ʱ��,a.ͨ��ʱ��,a.���ŵ������ļ�,a.¼�������������ļ���,t10.tranlatevalue as ���Խ��'+
                         ' from (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=6 then t1.testresult else null end ) as ���к���,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as ���к���,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as ���Խ���ʱ��,'+
                         ' max(case  when t1.paramid=8 then t1.testresult else null end ) as ͨ��ʱ��,'+
                         ' max(case  when t1.paramid=21 then t1.testresult else null end ) as ���ŵ������ļ�,'+
                         ' max(case  when t1.paramid=22 then t1.testresult else null end ) as ¼�������������ļ���,'+
                         ' max(case  when t1.paramid=23 then t1.testresult else ''-1'' end) as ���Խ�� from  @param1 t1'+
                         ' left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=132 group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname )a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=132 and t10.paramid=23 and t10.orderindex=a.���Խ��'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,41] := 'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.���к���,a.���к���,a.���Կ�ʼʱ��,'+
                         ' a.���Խ���ʱ��,a.collecttime as �ɼ�ʱ��,a.����ʱ��,a.ͨ��ʱ��,a.ͨ��ʱ��,t10.tranlatevalue as ���н��,t11.tranlatevalue as �������'+
                         ' from (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=6 then t1.testresult else null end ) as ���к���,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as ���к���,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as ���Խ���ʱ��,'+
                         ' max(case  when t1.paramid=13 then t1.testresult else null end ) as ����ʱ��,'+
                         ' max(case  when t1.paramid=14 then t1.testresult else null end ) as ͨ��ʱ��,'+
                         ' max(case  when t1.paramid=8 then t1.testresult else null end ) as ͨ��ʱ��,'+
                         ' max(case  when t1.paramid=17 then t1.testresult else ''-1'' end) as ���н��,'+
                         ' max(case  when t1.paramid=44 then t1.testresult else ''-1'' end) as ������� from  @param1 t1'+
                         ' left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=137 group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=137 and t10.paramid=17 and t10.orderindex=a.���н��'+
                         ' left join mtu_testresult_translate t11 on t11.comid=137 and t11.paramid=44 and t11.orderindex=a.�������'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,42] := 'select * from (select t1.taskid as ������,t4.mtuno as MTU���,t5.comname as ��������,'+
                         ' max(case  when t1.paramid=6 then t1.testresult else null end ) as ���к���,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as ���к���,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as ���Խ���ʱ��,t1.collecttime as �ɼ�ʱ��,'+
                         ' max(case  when t1.paramid=13 then t1.testresult else null end ) as ����ʱ��'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=133'+
                         ' group by t1.taskid,t1.collecttime,t4.mtuno,t5.comname order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,43] := 'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.���Կ�ʼʱ��,a.���Խ���ʱ��,a.collecttime as �ɼ�ʱ��,a.����ʱ��,'+
                         ' a.�ϴ�����,a.��������,t10.tranlatevalue as ���Խ�� from '+
                         ' (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as ���Խ���ʱ��,'+
                         ' max(case  when t1.paramid=28 then t1.testresult else null end ) as ����ʱ��,'+
                         ' max(case  when t1.paramid=25 then t1.testresult else null end ) as �ϴ�����,'+
                         ' max(case  when t1.paramid=26 then t1.testresult else null end ) as ��������,'+
                         ' max(case  when t1.paramid=23 then t1.testresult else ''-1'' end) as ���Խ��'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=134 group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=134 and t10.paramid=23 and t10.orderindex=a.���Խ��'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,44] := 'select * from (select t1.taskid as ������,t4.mtuname as MTU���,t5.comname as ��������,'+
                         ' max(case  when t1.paramid=41 then t1.testresult else null end ) as PingĿ���ַ,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,'+
                         ' t1.collecttime as �ɼ�ʱ��,'+
                         ' max(case  when t1.paramid=28 then t1.testresult else null end ) as ����ʱ��,'+
                         ' max(case  when t1.paramid=29 then t1.testresult else null end ) as ���͵����ݰ���,'+
                         ' max(case  when t1.paramid=30 then t1.testresult else null end ) as ���յ������ݰ���,'+
                         ' max(case  when t1.paramid=31 then t1.testresult else null end ) as ���ʱ��,'+
                         ' max(case  when t1.paramid=32 then t1.testresult else null end ) as ��Сʱ��,'+
                         ' max(case  when t1.paramid=33 then t1.testresult else null end ) as ƽ��ʱ��,'+
                         ' max(case  when t1.paramid=34 then t1.testresult else null end ) as ������'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=135'+
                         ' group by t1.taskid,t1.collecttime,t4.mtuname,t5.comname order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,45] := 'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.֪ͨʱ��,a.collecttime as �ɼ�ʱ��,t10.tranlatevalue as ֪ͨ���� from'+
                         ' (select t1.taskid,t4.mtuno,t5.comname,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ֪ͨʱ��,t1.collecttime,'+
                         ' max(case  when t1.paramid=42 then t1.testresult else ''-1'' end) as ֪ͨ����'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=69 group by t1.taskid,t5.comname,t1.collecttime,t4.mtuno)a '+
                         ' left join mtu_testresult_translate t10 on t10.comid=69 and t10.paramid=42 and t10.orderindex=a.֪ͨ����'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,46] := 'select a.taskid as ������,a.MTU���,a.��������,a.���ʱ��,a.collecttime as �ɼ�ʱ��,t10.tranlatevalue as ��Դ״̬ from'+
                         ' (select t1.collecttime,t1.taskid,t4.mtuno as MTU���,t5.comname as ��������,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���ʱ��,'+
                         ' max(case  when t1.paramid=3 then t1.testresult else null end ) as powerstatus'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=65 group by t1.taskid,t5.comname,t1.collecttime,t4.mtuno )a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=65 and t10.paramid=3 and t10.orderindex=a.powerstatus'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,47] := 'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.collecttime as �ɼ�ʱ��,t10.tranlatevalue as MTU״̬'+
                         ' from (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=35 then t1.testresult else null end ) as MTU״̬'+
                         ' from  @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=136'+
                         ' group by t1.taskid,t4.mtuno,t5.comname,t1.collecttime)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=68 and t10.paramid=35 and t10.orderindex=a.MTU״̬'+
                         ' where rownum<=@param3 order by a.taskid desc';
  SqlStr_Common[2,48] := 'select table_name from user_tables where table_name=@param1';
  SqlStr_Common[2,49] := 'select * from (select t1.taskid,t1.collecttime as ���ʱ��,max(case  when t1.paramid=1005 then t1.testresult else ''0'' end ) as ���ǿֵ'+
                         ' from @param1 t1 where t1.mtuid=@param2 and t1.comid=66 group by t1.taskid,t1.collecttime'+
                         ' order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,50] := 'select * from (select t1.taskid,t1.collecttime as ���ʱ��,max(case  when t1.paramid=1009 then t1.testresult else ''0'' end ) as ���ǿֵ'+
                         ' from @param1 t1 where t1.mtuid=@param2 and t1.comid=67 group by t1.taskid,t1.collecttime'+
                         ' order by t1.taskid desc)a where rownum<=@param3';
  SqlStr_Common[2,51] := 'select * from (select PARENTMODELID,MODELID,MODELNAME,CYCCOUNT,TIMEINTERVAL,PLANDATE from MTU_AUTOTEST_Model'+
                         ' union all select 0,999999,''δ�ƶ��ƻ�MTU'',0,0,null from dual) order by ParentModelID,MODELID';


  SqlStr_Common[2,52] := 'select a.mtuid,mtuname,mtuno,overlay,mtuaddr,call,called, '+
                         'MTUSTATUS,updatetime,linkno,buildingname,buildingid,decode(b.mtuid,null,0,1) as flag,c.MODELNAME,'+
                         'isprogramname,cdmaaddress,mainlook_apname,mainlook_phsname,mainlook_cnetname,pncode,cdmatypename'+
                         ' from mtu_info_view a'+
                         ' inner join mtu_autotest_modelmtu_relation b on a.mtuid=b.mtuid @param1'+
                         ' inner join mtu_autotest_model c on b.MODELID=c.MODELID'+
                         ' where 1=1 @param2';
                         {'select mtuid,mtuname as MTU����,mtuno as MTU�ⲿ���,overlay as ��������,'+
                         'mtuaddr as MTUλ��,call as �绰����,called as ���к���, '+
                         'MTUSTATUS as MTU״̬,updatetime ״̬���ʱ��,linkno as ������,'+
                         'buildingname as �����ҷֵ�,buildingid,decode(b.mtuid,null,0,1) as flag'+
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
  SqlStr_Common[2,76] := 'select id,name||''(''||decode(CDMATYPE,1,''ֱ��վ'',2,''RRU'',3,''���վ'')||'')'' as cdmaname from' +
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
                         '      ,decode(a.drsstatusname,''ֱ��վ����'',1,''ֱ��վ״̬'',1,2) as layer' +
                         '      ,a.drsstatusname||''(''||counts||'')'' as name' +
                         '  from' +
                         ' (' +
                         '  select b.*,rownum as id from' +
                         '  (' +
                         '    (select ''ֱ��վ״̬'' as drsstatusname,count(*) as counts,'''' as topname,1 as layer from drs_info_view' +
                         '      where 1=1 @Param1' +
                         '     union' +
                         '     select drsstatusname,count(*) as counts,''ֱ��վ״̬'' as topname,2 as layer from drs_info_view' +
                         '      where 1=1 @Param1' +
                         '      group by drsstatusname' +
                         '     )' +
                         '     union' +
                         '    (select ''ֱ��վ����'' as drsstatusname,count(*) as counts,'''' as topname,1 as layer from drs_info_view' +
                         '      where 1=1 @Param1' +
                         '     union' +
                         '     select drstypename,count(*) as counts,''ֱ��վ����'' as topname,2 as layer from drs_info_view' +
                         '      where 1=1 @Param1' +
                         '      group by drstypename)' +
                         '  )b' +
                         ' )a' +
                         ' connect by prior drsstatusname=topname start with (drsstatusname=''ֱ��վ����'' or drsstatusname=''ֱ��վ״̬'')';
  SetLength(SqlStr_Common[3], SQLCount);
  SqlStr_Common[3,1] := 'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.���к���,a.���к���,a.���Կ�ʼʱ��,'+
                        ' a.���Խ���ʱ��,a.collecttime as �ɼ�ʱ��,a.ͨ��ʱ��,a.���ŵ������ļ�,a.¼�������������ļ���,t10.tranlatevalue as ���Խ��'+
                        ' from (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,max(case  when t1.paramid=6 then t1.testresult else null end ) as ���к���,'+
                        ' max(case  when t1.paramid=7 then t1.testresult else null end ) as ���к���,max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,'+
                        ' max(case  when t1.paramid=12 then t1.testresult else null end ) as ���Խ���ʱ��,max(case  when t1.paramid=8 then t1.testresult else null end ) as ͨ��ʱ��,'+
                        ' max(case  when t1.paramid=21 then t1.testresult else null end ) as ���ŵ������ļ�,max(case  when t1.paramid=22 then t1.testresult else null end ) as ¼�������������ļ���,'+
                        ' max(case  when t1.paramid=23 then t1.testresult else ''-1'' end) as ���Խ�� from @param1 t1'+
                        ' left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where t1.mtuid=@param2 and t1.comid=132 and t1.collecttime @param3'+
                        ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                        ' left join mtu_testresult_translate t10 on t10.comid=132 and t10.paramid=23 and t10.orderindex=a.���Խ��'+
                        ' order by a.collecttime desc';
  SqlStr_Common[3,2] := 'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.���к���,a.���к���,a.���Կ�ʼʱ��,'+
                        ' a.���Խ���ʱ��,a.collecttime as �ɼ�ʱ��,a.����ʱ��,a.ͨ��ʱ��,a.ͨ��ʱ��,t10.tranlatevalue as ���н��,t11.tranlatevalue as �������'+
                        ' from (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,'+
                        ' max(case  when t1.paramid=6 then t1.testresult else null end ) as ���к���,max(case  when t1.paramid=7 then t1.testresult else null end ) as ���к���,'+
                        ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,max(case  when t1.paramid=12 then t1.testresult else null end ) as ���Խ���ʱ��,'+
                        ' max(case  when t1.paramid=13 then t1.testresult else null end ) as ����ʱ��,max(case  when t1.paramid=14 then t1.testresult else null end ) as ͨ��ʱ��,'+
                        ' max(case  when t1.paramid=8 then t1.testresult else null end ) as ͨ��ʱ��,max(case  when t1.paramid=17 then t1.testresult else ''-1'' end) as ���н��,'+
                        ' max(case  when t1.paramid=44 then t1.testresult else ''-1'' end) as ������� from  @param1 t1'+
                        ' left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                        ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where t1.mtuid=@param2 and t1.comid=137 and t1.collecttime @param3'+
                        ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                        ' left join mtu_testresult_translate t10 on t10.comid=137 and t10.paramid=17 and t10.orderindex=a.���н��'+
                        ' left join mtu_testresult_translate t11 on t11.comid=137 and t11.paramid=44 and t11.orderindex=a.�������'+
                        ' order by a.collecttime desc';
  SqlStr_Common[3,3] := 'select t1.taskid as ������,t4.mtuno as MTU���,t5.comname as ��������,max(case  when t1.paramid=6 then t1.testresult else null end ) as ���к���,'+
                         ' max(case  when t1.paramid=7 then t1.testresult else null end ) as ���к���,max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,'+
                         ' max(case  when t1.paramid=12 then t1.testresult else null end ) as ���Խ���ʱ��,t1.collecttime as �ɼ�ʱ��,max(case  when t1.paramid=13 then t1.testresult else null end ) as ����ʱ��'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=133 and t1.collecttime @param3'+
                         ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname order by t1.collecttime desc';
  SqlStr_Common[3,4] := 'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.���Կ�ʼʱ��,a.���Խ���ʱ��,a.collecttime as �ɼ�ʱ��,a.����ʱ��,a.�ϴ�����,a.��������,t10.tranlatevalue as ���Խ��'+
                        ' from (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,'+
                        ' max(case  when t1.paramid=12 then t1.testresult else null end ) as ���Խ���ʱ��,max(case  when t1.paramid=28 then t1.testresult else null end ) as ����ʱ��,'+
                        ' max(case  when t1.paramid=25 then t1.testresult else null end ) as �ϴ�����,max(case  when t1.paramid=26 then t1.testresult else null end ) as ��������,'+
                        ' max(case  when t1.paramid=23 then t1.testresult else ''-1'' end) as ���Խ��'+
                        ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                        ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                        ' where t1.mtuid=@param2 and t1.comid=134 and t1.collecttime @param3'+
                        ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname)a'+
                        ' left join mtu_testresult_translate t10 on t10.comid=134 and t10.paramid=23 and t10.orderindex=a.���Խ��'+
                        ' order by a.collecttime desc';
  SqlStr_Common[3,5] := 'select t1.taskid as ������,t4.mtuno as MTU���,t5.comname as ��������,max(case  when t1.paramid=41 then t1.testresult else null end ) as PingĿ���ַ,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���Կ�ʼʱ��,t1.collecttime as �ɼ�ʱ��,max(case  when t1.paramid=28 then t1.testresult else null end ) as ����ʱ��,'+
                         ' max(case  when t1.paramid=29 then t1.testresult else null end ) as ���͵����ݰ���,max(case  when t1.paramid=30 then t1.testresult else null end ) as ���յ������ݰ���,'+
                         ' max(case  when t1.paramid=31 then t1.testresult else null end ) as ���ʱ��,max(case  when t1.paramid=32 then t1.testresult else null end ) as ��Сʱ��,'+
                         ' max(case  when t1.paramid=33 then t1.testresult else null end ) as ƽ��ʱ��,max(case  when t1.paramid=34 then t1.testresult else null end ) as ������'+
                         ' from  @param1 t1  left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=135 and t1.collecttime @param3'+
                         ' group by t1.taskid,t4.mtuno,t1.collecttime,t5.comname order by t1.collecttime desc';
  SqlStr_Common[3,6] :=  'select a.taskid as ������,a.mtuno as MTU��,a.comname as ��������,a.֪ͨʱ��,a.collecttime as �ɼ�ʱ��,t10.tranlatevalue as ֪ͨ���� from'+
                         ' (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ֪ͨʱ��,'+
                         ' max(case  when t1.paramid=42 then t1.testresult else ''-1'' end) as ֪ͨ����'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=69 and t1.collecttime @param3'+
                         ' group by t1.taskid,t1.collecttime,t4.mtuno,t5.comname) a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=69 and t10.paramid=42 and t10.orderindex=a.֪ͨ���� order by a.collecttime desc';
  SqlStr_Common[3,7] :=  'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.���ʱ��,a.collecttime as �ɼ�ʱ��,t10.tranlatevalue as ��Դ״̬ from'+
                         ' (select t1.collecttime,t1.taskid,t4.mtuno,t5.comname,'+
                         ' max(case  when t1.paramid=2 then t1.testresult else null end ) as ���ʱ��,'+
                         ' max(case  when t1.paramid=3 then t1.testresult else null end ) as powerstatus'+
                         ' from @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=65 and t1.collecttime @param3'+
                         ' group by t1.taskid,t1.collecttime,t4.mtuno,t5.comname)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=65 and t10.paramid=3 and t10.orderindex=a.powerstatus order by a.collecttime desc';
  SqlStr_Common[3,8] :=  'select a.taskid as ������,a.mtuno as MTU���,a.comname as ��������,a.collecttime as �ɼ�ʱ��,t10.tranlatevalue as MTU״̬'+ 
                         ' from (select t1.taskid,t4.mtuno,t5.comname,t1.collecttime,'+
                         ' max(case  when t1.paramid=35 then t1.testresult else null end ) as MTU״̬'+
                         ' from  @param1 t1 left join mtu_info t4 on t1.mtuid=t4.mtuid'+
                         ' left join mtu_command_define t5 on t1.comid=t5.comid'+
                         ' where t1.mtuid=@param2 and t1.comid=136 and t1.collecttime @param3'+
                         ' group by t1.taskid,t4.mtuno,t5.comname,t1.collecttime)a'+
                         ' left join mtu_testresult_translate t10 on t10.comid=68 and t10.paramid=35 and t10.orderindex=a.MTU״̬'+
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

{**************** 1 Դ����SQL���*******************************
  SqlStr_Resource �����Դ�����õ���SQL���
*********************************************************************}
procedure Init_SqlStr_Resource();
begin
  //dic_type_info- SqlStr_Common[1]
  SetLength(SqlStr_Resource[1], SQLCount);
  //��ͼ��ѡʡ��
  SqlStr_Resource[1,1]:='select CSID ��վ���,SURVERY_ID ������,NETADDRESS ��Ԫ��Ϣ,CSADDR ��վ��ַ from cs_info';


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
  //���ڵ���Ϣ���� ���ӵ�click
  SqlStr_Resource[1,15]:='select buildingid,buildingno as �ҷֵ��� ,buildingname  as �ҷֵ�����,'+
                         ' address as ��ַ,longitude as ����,latitude as γ��,'+
                         ' nettypename as ������������,factoryname as ���ɳ���, connecttypename as ���뷽ʽ,'+
                         ' buildingtypename as �ҷֵ�����,floorcount as ¥����Ŀ,buildingarea as ¥�����,area as ��������,areaid'+
                         ' from building_info_view t  where t.areaid in  @param1 order by buildingid';
  //���ڵ���Ϣ���� Grid.click
  SqlStr_Resource[1,16]:='select * from building_info where buildingid=@param1';
  //���ڵ���Ϣ���� ��ʾͼƬ
  SqlStr_Resource[1,17]:='select * from picture_info t where outid=@PARAM1';
  SqlStr_Resource[1,18]:='select id from area_info t where layer =@param1';
  SqlStr_Resource[1,19]:='select id from area_info t ';      //ʡ
  SqlStr_Resource[1,20]:='select id from area_info t where top_id=@param1';      //��
  //��������Ϣ���� ���ӵ�click
  SqlStr_Resource[1,21]:='select SWITCHID,SWITCHNO as �����������,MACADDR as �����ַ,MANAGEADDR as �����ַ,UPLINKPORT as �����˿�,POP as pop,buildingname as �����ҷֵ�,buildingid '+
                         ' from switch_info_view  t where areaid in @param1 order by SWITCHID';
  //��������Ϣ����ComboBoxBuildinginof��item
  SqlStr_Resource[1,22]:='select buildingid,buildingname from building_info where areaid in @param1 order by buildingname';
  //��������Ϣ���� Grid.click
  SqlStr_Resource[1,23]:='select * from switch_info where switchid=@param1';
  //��������Ϣ���� ����Ȩ����ʾ��COM_AREA
  SqlStr_Resource[1,24]:='select * from area_info t where layer =2 @param1';
  SqlStr_Resource[1,25]:='select * from switch_info';
  //AP��Ϣ����
  SqlStr_Resource[1,26]:='select t.switchid,t.switchno from switch_info_view t where t.areaid in @param1';
  SqlStr_Resource[1,41]:='select t.switchid,t.switchno from switch_info_view t where t.buildingid in @param1';
  SqlStr_Resource[1,27]:='select t.apid,t.apno as �������,t.connecttypename as ��������,t.apport as ��Ӧ�˿�,t.factoryname as ��Ӧ��, '+
                         ' t.apkindname as AP�ͺ�,t.appropertyname as AP����,t.appower as ����,t.powerkindname as ���緽ʽ ,t.frequency as Ƶ��,t.APaddr as AP��ַ,t.overlay as ���Ƿ�Χ, '+
                         ' t.manageaddrseg as AP�����ַ��,t.apip as APIP,t.gwaddr as ���ص�ַ,t.macaddr as MAC��ַ,t.businessvlan as ҵ��VLAN,t.managevlan as ����VLAN,t.switchno as ����������,'+
                         ' t.buildingname as �����ҷֵ�,t.switchid ,t.buildingid from ap_info_view t where 1=1 @param1 order by apno';
  SqlStr_Resource[1,28]:='select * from ap_info';
  SqlStr_Resource[1,29]:='select * from ap_info where APID = @param1';
  SqlStr_Resource[1,30]:='select switchid,switchno from switch_info where buildingid = @param1';
  SqlStr_Resource[1,31]:='select csid, survery_id from cs_info  where buildingid=@param1';
  SqlStr_Resource[1,32]:='select b.apid,b.apno from ap_info b left join switch_info a on b.switchid=a.switchid where a.buildingid=@param1';
  SqlStr_Resource[1,73]:='select cdmaid,cdmaname from cdma_info where buildingid=@param1';
  SqlStr_Resource[1,33]:='select a.linkid,a.linkno as ���������,a.linkaddr as ������λ��,a.linktype as ����������,a.istrunk as �Ƿ�ɷ�, '+
                         ' a.trunkaddr as �ɷ�λ��,a.linkequipment as �����豸����,a.linkcs as ���ӻ�վ,a.linkap as ����AP,a.buildingname as �����ҷֵ�,a.buildingno as �ҷֵ���,'+
                         ' a.area as ��������,a.buildingid,a.areaid from linkmachine_info_view a where a.areaid in @param1 order by linkid';
  SqlStr_Resource[1,34]:='select * from linkmachine_info t where linkid=@param1';
  SqlStr_Resource[1,35]:='select * from linkmachine_info t ';
  SqlStr_Resource[1,45]:='select * from mtu_info t where mtuid=@param1';
  SqlStr_Resource[1,46]:='select * from mtu_info t ';

  SqlStr_Resource[1,36]:='select linkid,linkno from linkmachine_info_view where areaid IN @param1 ';
  SqlStr_Resource[1,42]:='select linkid,linkno from linkmachine_info_view where buildingid in @param1 ';
  SqlStr_Resource[1,37]:='select a.mtuid,a.mtuno as mtu�豸���,a.mtuname as MTU����,a.overlay as ��������, '+
                         ' a.mtuaddr as MTUλ��,a.call as �绰����,a.called as ���к���,a.linkno as �϶�������,a.buildingname as �����ҷֵ�,a.buildingno as �ҷֵ���,a.area as ��������,a.linkid, '+
                         ' a.buildingid,a.areaid,a.status �Ƿ����� from mtu_info_view a where a.areaid in @param1 order by mtuid' ;
  //MTU��Ϣ����  GridClick and UPdate
  SqlStr_Resource[1,38]:='select * from mtu_info t where t.mtuid=@param1';

  //��ͼ��ѡ���в�
  SqlStr_Resource[1,39]:='select CSID ��վ���,SURVERY_ID ������,NETADDRESS ��Ԫ��Ϣ,CSADDR ��վ��ַ from cs_info '+
                          'where buildingid in (select buildingid from building_info where areaid in '+
                          '(select id from area_info where top_id=@param1))';
  //��ͼ��ѡ���ز�
  SqlStr_Resource[1,40]:='select CSID ��վ���,SURVERY_ID ������,NETADDRESS ��Ԫ��Ϣ,CSADDR ��վ��ַ from cs_info '+
                          'where buildingid in (select buildingid from building_info where areaid=@param1)';
  //��ͼ��ѡ�ҷֵ�㣨¥�
  SqlStr_Resource[1,47]:='select CSID ��վ���,SURVERY_ID ������,NETADDRESS ��Ԫ��Ϣ,CSADDR ��վ��ַ from cs_info '+
                          'where buildingid=@param1';
  //��ѯ������� 1
  SqlStr_Resource[1,48]:='select * from cs_info '+
                          'where Survery_id=''@param1''';
  //��ѯ��վ��Ϣ
  SqlStr_Resource[1,49]:='select * from cs_info';
  // ��ѯ������� 2
  SqlStr_Resource[1,50]:='select * from cs_info '+
                          'where CSID<>@param1 and Survery_id=''@param2''';
  // ��ѯ������� 3
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
  
  //----------------����ƻ�---------
  //MTU��Ϣ�б�   
  SqlStr_Resource[2,1]:= 'select distinct t.modelid,t.mtuid, decode(b.ISPAUSE,1,''��'', 0, ''��'', ''��'') ISPAUSE, a.mtuname as MTU����,a.mtuno as MTU�ⲿ���,'+
                         'a.overlay as ��������,a.mtuaddr as MTUλ��,a.call as �绰����,'+
                         'a.called as ���к���, a.linkno as ������,a.buildingname as �����ҷֵ�, '+
                         'a.isprogramname as "����/����", a.mainlook_apname as �����AP, '+
                         'a.mainlook_phsname as �����PHS, a.mainlook_cnetname as �����C��,'+
                         'a.cdmatypename as C����Դ����, a.cdmaaddress as C����Դ��װλ��, a.pncode as PN�� '+

                         'from mtu_autotest_cmd t left join mtu_info_view a on t.mtuid = a.mtuid '+
                         'left join mtu_autotest_modelmtu_relation b on t.modelid = b.modelid  and t.mtuid = b.mtuid '+
                         ' where t.ModelID=@param1 '+
                         'order by t.mtuid';
  SqlStr_Resource[2,49]:= 'select distinct t.modelid,t.mtuid, decode(b.ISPAUSE,1,''��'', 0, ''��'', ''��'') ISPAUSE ,a.mtuname as MTU����,a.mtuno as MTU�ⲿ���,'+
                         'a.overlay as ��������,a.mtuaddr as MTUλ��,a.call as �绰����,'+
                         'a.called as ���к���, a.linkno as ������,a.buildingname as �����ҷֵ�, '+
                         'a.isprogramname as "����/����", a.mainlook_apname as �����AP, '+
                         'a.mainlook_phsname as �����PHS, a.mainlook_cnetname as �����C��,'+
                         'a.cdmatypename as C����Դ����, a.cdmaaddress as C����Դ��װλ��, a.pncode as PN�� '+

                         'from mtu_autotest_cmd t left join mtu_info_view a on t.mtuid = a.mtuid '+
                         'left join mtu_autotest_modelmtu_relation b on t.modelid = b.modelid  and t.mtuid = b.mtuid '+
                         ' where t.ModelID in (select MODELID from MTU_AUTOTEST_Model where parentmodelid=@param1) '+
                         'order by t.mtuid';

  SqlStr_Resource[2,50]:= 'select distinct t.modelid,t.mtuid, decode(b.ISPAUSE,1,''��'', 0, ''��'', ''��'') ISPAUSE,a.mtuname as MTU����,a.mtuno as MTU�ⲿ���,'+
                         'a.overlay as ��������,a.mtuaddr as MTUλ��,a.call as �绰����,'+
                         'a.called as ���к���, a.linkno as ������,a.buildingname as �����ҷֵ�, '+
                         'a.isprogramname as "����/����", a.mainlook_apname as �����AP, '+
                         'a.mainlook_phsname as �����PHS, a.mainlook_cnetname as �����C��,'+
                         'a.cdmatypename as C����Դ����, a.cdmaaddress as C����Դ��װλ��, a.pncode as PN�� '+

                         'from mtu_autotest_cmd t left join mtu_info_view a on t.mtuid = a.mtuid '+
                         'left join mtu_autotest_modelmtu_relation b on t.modelid = b.modelid  and t.mtuid = b.mtuid '+
                         'where exists (select 1 from mtu_autotest_model c where c.modelid = t.modelid) '+
                         'order by t.mtuid';
  {SqlStr_Resource[2,50]:= 'select t.modelid,t.mtuid, t.ISPAUSE,a.mtuname as MTU����,a.mtuno as MTU�ⲿ���,'+
                         'a.overlay as ��������,a.mtuaddr as MTUλ��,a.call as �绰����,'+
                         'a.called as ���к���, a.linkno as ������,a.buildingname as �����ҷֵ�, '+
                         'a.isprogramname as "����/����", a.mainlook_apname as �����AP, '+
                         'a.mainlook_phsname as �����PHS, a.mainlook_cnetname as �����C��,'+
                         'a.cdmatypename as C����Դ����, a.cdmaaddress as C����Դ��װλ��, a.pncode as PN�� '+

                         'from mtu_autotest_modelmtu_relation t left join mtu_info_view a '+
                         'on t.mtuid=a.mtuid '+
                         'where exists (select 1 from mtu_autotest_cmd c where c.modelid=t.modelid and c.mtuid=t.mtuid) '+
                         'order by t.mtuid'; }

  //����ģ�����б�
  SqlStr_Resource[2,3]:= 'select PARENTMODELID, MODELID, MODELNAME,CYCCOUNT,TIMEINTERVAL,PLANDATE '+
                         'from MTU_AUTOTEST_Model Order by ParentModelID, ModelID';
  //����ģ�����б�(���Լƻ�ִ�м��)
  SqlStr_Resource[2,51]:= 'select PARENTMODELID, MODELID, MODELNAME, CYCCOUNT, TIMEINTERVAL, PLANDATE '+
                         'from MTU_AUTOTEST_Model  where ModelID in '+
                         '( select distinct a.modelid from mtu_autotest_cmd a) union '+
                         'select PARENTMODELID, MODELID, MODELNAME, CYCCOUNT, TIMEINTERVAL, PLANDATE '+
                         'from MTU_AUTOTEST_Model  where ModelID in ( '+
                         ' select PARENTMODELID ModelID from MTU_AUTOTEST_Model  ' +
                         ' where ModelID in ( select distinct a.modelid from mtu_autotest_cmd a)) '+
                         ' or (parentModelID = 0) Order by ParentModelID, ModelID';   

  //����ģ���ѯ(�ж������ظ�)
  SqlStr_Resource[2,30]:= 'select MODELID from MTU_AUTOTEST_Model where ModelName = ''@param1'' ';

  //�����б�
  SqlStr_Resource[2,4]:='select t.comname, t.comid from mtu_command_define t where t.comtype=1 '+
                        'and t.ifineffect=1 and t.comid<>9 order by t.comid';
  //ģ��MTU���  
  SqlStr_Resource[2,7]:='select t.taskid, a.comname, a.comid from mtu_autotest_modelmtucom t ' +
                        ' left join mtu_command_define a  '+
                        ' on a.comid=t.comid '+
                        ' where t.ModelID=@param1 and t.mtuID=@param2 ';
  //�������Ĭ��ֵ
  SqlStr_Resource[2,5]:='select a.paramid,a.paramname,b.paramvalue, a.comid from  mtu_comparam_config a '+
                         ' left join mtu_autotestparam_config b  '+
                         ' on a.paramid=b.paramid and a.comid=b.comid '+
                         ' where a.comid=@param1 ';
  //��������Զ���ֵ
  SqlStr_Resource[2,6]:='select a.paramid,a.paramname,b.paramvalue, b.taskid from  mtu_comparam_config a '+
                         ' left join MTU_AUTOTEST_ModelComParam b  '+
                         ' on a.paramid=b.paramid and a.comid=b.comid '+
                         ' where b.TaskID=@param1 ';
  //MTU������������ֵ
  SqlStr_Resource[2,8]:= 'select * from mtu_autotest_model_mtu_view where modelid=@param1 Order by MTUID';
  //MTU���������������ֵ
  SqlStr_Resource[2,9]:= 'select * from mtu_autotest_model_mtup_view where modelid=@param1 Order by MTUID';

  //�����б�ʱ���
  SqlStr_Resource[2,24]:= 'select modelid, begintime, endtime, ID from mtu_autotest_model_time_view '+
                          'where modelid=@param1';  
   //�����б�ʱ�����ϸ
  SqlStr_Resource[2,25]:= 'select ID, ModelID, begintime, endtime, comid, cyccount, '+
                          'timeinterval, comname, 0 CURR_CYCCOUNT, ParentID '+
                          'from mtu_autotest_model_timeC_view where '+
                          'modelid =@param1';
  //�����б�ʱ�����ϸ(�澯���)
  SqlStr_Resource[2,37]:= 'select ID, ModelID, begintime, endtime, comid, cyccount, '+
                          'timeinterval, comname, CURR_CYCCOUNT, ParentID '+
                          'from mtu_autotest_model_timeCM_view where '+   
                          'modelid=@param1 and mtuid=@param2 ';
  //ɾ�������б�ʱ���
  SqlStr_Resource[2,26]:= 'delete mtu_autotest_modeltimecom where modelid=@param1';
  //ɾ���澯����
  SqlStr_Resource[2,27]:= 'delete mtu_alarm_model_content where modelid in '+
                          '(select modelid from mtu_alarm_model where parentmodelid=@param1)';
  //���������б�ʱ��α�
  SqlStr_Resource[2,28]:= 'select id, modelid, begintime, endtime, comid, cyccount, timeinterval '+
                          'from mtu_autotest_modeltimecom where 1=2';

  //ɾ������ƻ�ǰ��ѯ�Ƿ�������
  SqlStr_Resource[2,45]:= 'select MTUID from mtu_autotest_modelmtu_relation where MODELID = @param1';
  //ɾ������ƻ���ǰ��ѯ�Ƿ�������
  SqlStr_Resource[2,46]:= 'select MTUID from mtu_autotest_modelmtu_relation where MODELID in '+
                          '(select MODELID from MTU_AUTOTEST_Model where parentModelid=@param1)';


  //ɾ������ƻ�(Ҷ)
  SqlStr_Resource[2,31]:= 'delete mtu_autotest_model where modelid=@param1';
  //ɾ������ƻ�
  SqlStr_Resource[2,32]:= 'delete mtu_autotest_modeltimecom where modelid=@param1';
  //ɾ������ƻ�
  SqlStr_Resource[2,33]:= 'delete mtu_autotest_modelmtu_relation where modelid=@param1';
  
  //ɾ������ƻ�(�ڵ�)
  SqlStr_Resource[2,34]:= 'delete mtu_autotest_modelmtu_relation where modelid in '+
                          '(select modelid from mtu_autotest_model where parentmodelid=@param1)';
  //ɾ������ƻ�(�ڵ�)
  SqlStr_Resource[2,35]:= 'delete mtu_autotest_modeltimecom where modelid in '+
                          '(select modelid from mtu_autotest_model where parentmodelid=@param1)';
  //ɾ������ƻ�(�ڵ�)
  SqlStr_Resource[2,36]:= 'delete mtu_autotest_model where parentmodelid=@param1 or modelid=@param1';

  //��ִͣ������ƻ�
  //SqlStr_Resource[2,39]:= 'update mtu_autotest_cmd set ifpause = 1 where modelid=@param1 and mtuid=@param2';
  SqlStr_Resource[2,39]:= 'update mtu_autotest_cmd set ifpause = 1 where 1<>1 @param1';
  //SqlStr_Resource[2,40]:= 'update MTU_AUTOTEST_MODELMTU_RELATION set ISPAUSE = 1 where modelid=@param1 and mtuid=@param2';
  SqlStr_Resource[2,40]:= 'update MTU_AUTOTEST_MODELMTU_RELATION set ISPAUSE = 1 where 1<>1 @param1';

  //�ָ�ִ������ƻ�
  //SqlStr_Resource[2,41]:= 'update mtu_autotest_cmd set ifpause = 0 where modelid=@param1 and mtuid=@param2';
  SqlStr_Resource[2,41]:= 'update mtu_autotest_cmd set ifpause = 0 where 1<>1 @param1';
  //SqlStr_Resource[2,42]:= 'update MTU_AUTOTEST_MODELMTU_RELATION set ISPAUSE = 0 where modelid=@param1 and mtuid=@param2';
  SqlStr_Resource[2,42]:= 'update MTU_AUTOTEST_MODELMTU_RELATION set ISPAUSE = 0 where 1<>1 @param1';

  //ɾ��ִ������ƻ�  
  SqlStr_Resource[2,43]:= 'delete mtu_autotest_param where TESTGROUPID in '+
                         '(select TESTGROUPID from mtu_autotest_cmd where 1<>1 @param1)';
  SqlStr_Resource[2,44]:= 'delete mtu_autotest_cmd where 1<>1 @param1';




  //----------------�澯����ģ��---------
  //�澯����ģ�����б�
  SqlStr_Resource[2,10]:= ' select * from  mtu_alarm_model Order by ParentModelID';
  //�澯����ģ���ѯ
  SqlStr_Resource[2,12]:= ' select * from mtu_alarm_model where ModelName = ''@param1'' ';

  //�澯���ݹ���Ĭ��
  SqlStr_Resource[2,11]:= 'select * from mtu_alarm_model_defcon_view order by ALARMCONTENTCODE';
  //�澯���ݹ���
  SqlStr_Resource[2,13]:= ' select * from  mtu_alarm_model_content_view '+
                          ' where ModelID = @param1 order by ALARMCONTENTCODE';
  //�澯���ݹ���(����)
  SqlStr_Resource[2,38]:= ' select * from  mtu_alarm_model_content '+
                          ' where ModelID = @param1 order by ALARMCONTENTCODE';
  //�澯����
  SqlStr_Resource[2,14]:= 'select DICCODE as ID,DICNAME as Name from DIC_CODE_INFO '+
                          ' where PARENTID <>-1 and dictype=11 and ifineffect=1 order by dicorder';

  //ɾ���澯����ǰ��ѯ�Ƿ�������
  SqlStr_Resource[2,47]:= 'select MTUID from MTU_INFO where CONTENTCODEMODEL=@param1';
  //ɾ���澯������ǰ��ѯ�Ƿ�������
  SqlStr_Resource[2,48]:= 'select MTUID from MTU_INFO where CONTENTCODEMODEL in '+
                          '(select MODELID from MTU_ALARM_MODEL where parentModelid=@param1)';


  //ɾ���澯����(Ҷ)
  SqlStr_Resource[2,16]:= 'delete mtu_alarm_model_content where modelid=@param1';
  //ɾ���澯ģ��(Ҷ)
  SqlStr_Resource[2,17]:= 'delete mtu_alarm_model where modelid=@param1';
  //ɾ���澯����
  SqlStr_Resource[2,18]:= 'delete mtu_alarm_model_content where modelid in '+
                          '(select modelid from mtu_alarm_model where parentmodelid=@param1)';
  //ɾ���澯ģ��
  SqlStr_Resource[2,19]:= 'delete mtu_alarm_model where parentmodelid=@param1';
  //ɾ���澯ģ����
  SqlStr_Resource[2,20]:= 'delete mtu_alarm_model where modelid=@param1';
  


  //----------------�澯���---------
  //��ǰ�澯���Խ��
//  SqlStr_Resource[2,21]:= 'select a.alarmid, b.* from alarmonline_result_relation a '+
//                          'left join mtu_testresult_Query_view b  '+
//                          'on b.taskid=a.taskid where a.alarmid=@param1';
  {SqlStr_Resource[2,21]:= 'select a.alarmid, b.taskid,b.mtuid,b.mtuno,b.comname,b.paramname,b.valueindex,b.testresult,b.collecttime,'+
                          ' b.execid,decode(b.isprocess,0,''δ����'',1,''������'',2,''�Ѵ���'') as isprocess,b.name,b.comid,'+
                          ' b.paramid,b.cityid from mtu_alarmresult a '+
                          ' left join mtu_testresult_Query_view b on b.taskid=a.taskid where a.alarmid=@param1';}
  SqlStr_Resource[2,21]:= 'select b.alarmid, b.taskid,b.mtuid,b.mtuno,b.comname,b.paramname,b.valueindex,b.testresult,b.collecttime,'+
                          ' b.execid,decode(b.isprocess,0,''δ����'',1,''������'',2,''�Ѵ���'') as isprocess,b.name,b.comid,'+
                          ' b.paramid,b.cityid from mtu_alarmresult_view b '+
                          ' where b.alarmid=@param1';


  //��ʷ�澯���Խ��
  SqlStr_Resource[2,22]:= 'select a.alarmid, b.* from mtu_alarmresult a '+
                          'left join mtu_testresult_Query_view b  '+
                          'on b.taskid=a.taskid where a.alarmid=@param1';
  //MTU��ʷ�澯
  SqlStr_Resource[2,23]:= 'select mtuid,alarmcontentname,alarmkindname,alarmlevelname,sendtime,removetime,mtuname,mtuno'+
                          ' from (select * from alarm_master_online_view union '+
                          'select * from alarm_master_history_view) '+
                          'where mtuid=@param1 and rownum<=@param2 order by sendtime';

  //////////////////////////////////////////////////////////////////////////////
  //------------ֱ��վ���ù���--------------------------
  SetLength(SqlStr_Resource[3], SQLCount);   //2
  //ֱ��վ�б�
  SqlStr_Resource[3,1]:= 'select * from drs_config_info_view a '+
                         'where @param1';
  //ֱ��վ��������
  SqlStr_Resource[3,2]:= 'update drs_statuslist t set t.drsstatus=@param2 where t.drsid=@param1 ';

  //ֱ��վ������Ϣ
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


  //ֱ��վ��ʷ������Ϣ
  SqlStr_Resource[3,10]:= 'select batchid from drs_prepparam_set_h t where t.drsid=@param1 group by t.batchid order by batchid desc';

  //------------ֱ��վ��������--------------------------
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

  //------------ֱSQLͨ�ò�ѯ--------------------------
  SetLength(SqlStr_Resource[5], SQLCount);
//  SqlStr_Resource[5,1]:= 'select * from drs_config_com_on_view where DRSid=@param1 ';
  SqlStr_Resource[5,1]:= ' @param1 ';

  //////////////////////////////////////////////////////////////////////////////
  end;

{********************* 2�������ݹ���SQL��� ***************************
 SqlStr_BaseData ��Ż�������SQL
**********************************************************************}
procedure Init_SqlStr_BaseData();
begin
  //dic_type_info- SqlStr_Common[1]
  SetLength(SqlStr_BaseData[1], SQLCount);
  SetLength(SqlStr_BaseData[2], SQLCount);
  SetLength(SqlStr_BaseData[3], SQLCount);
  SetLength(SqlStr_BaseData[4], SQLCount);
  //�鿴����������Ϣ
  SqlStr_BaseData[1,1]:='select * from area_info where layer in (0,1,2)';
  //�鿴�ض��û�������Ϣ������Ա���⣩
  SqlStr_BaseData[1,2]:='select userid �û����,userno �û��ʺ�,username ����,email ����,'+
  'decode(sex,0,''��'',1,''Ů'',''��'') �Ա�,dept ����ְλ,officephone �칫�绰,mobilephone �ֻ�,'+
  'creator �����߱��,cityid ��������,areaid �������� from userinfo '+
  'where userid<>@Param1 and cityid=@Param2 and areaid=@Param3';
  //����Ա����Ȩ��
  SqlStr_BaseData[1,3]:='select ModuleID,ModuleName from AppModuleInfo ';
  //��ͨ�û�Ȩ��
  SqlStr_BaseData[1,4]:='select t1.moduleid,t2.modulename from userprivinfo t1, appmoduleinfo t2 '+
  'where t1.moduleid=t2.moduleid and t1.userid=@Param1';
  //�ж��û��Ƿ��ظ�
  SqlStr_BaseData[1,5]:='select * from userinfo where userid<>@Param1 and userno=''@Param2'' ';
  //�����û��Ƿ����
  SqlStr_BaseData[1,6]:='select * from userinfo where userid=@Param1';
  //�����û�Ȩ��
  SqlStr_BaseData[1,7]:='select * from userprivinfo where userid=@Param1';
  //�ֵ������Ϣ��
  SqlStr_BaseData[1,8]:='select * from dic_type_info order by typeid';
  //�ֵ�����(��ʾ����)
  SqlStr_BaseData[1,9]:='select diccode ���ϱ��,dicname ��������,dicorder �������,decode(ifineffect,0,''��'',1,''��'',''��'') �Ƿ���Ч,remark ���Ͻ��� '+
  'from dic_code_info where dictype=@Param1 order by diccode';


  //  10-20 �澯���ݹ���
  SqlStr_BaseData[1,10]:=' select alarmcontentcode as  �澯���ݱ��� , alarmcontentname as  �澯���� , alarmkindname as  �澯���� , alarmlevelname as �澯�ȼ� ,'+
                         ' alarmcondition as �澯��������,alarmcount as �澯�����ۼ�����,'+
                         ' removecondition as �澯�ų�����,  removecount as �澯�ų��ۼ�����,'+
                         ' limithour as �ų�ʱ��,  comname as �澯��Դ����, paramname as �澯��Դ����'+
                         ' from mtu_alarm_content_view ';
  //��ȡȫ���澯����
  SqlStr_BaseData[1,11]:=' select * from mtu_alarm_content order by alarmcontentcode';
  //��ȡĳ���澯����
  SqlStr_BaseData[1,12]:=' select * from mtu_alarm_content where alarmcontentcode=@Param1';


  //���ʱ�ж��ֵ����������Ƿ��ظ�
  SqlStr_BaseData[1,13]:='select * from dic_code_info where dictype=@Param1 and dicname=''@Param2'' ';
  //�ֵ�����(����ʾ����)
  SqlStr_BaseData[1,14]:='select * from dic_code_info';
  //�ֵ������޸�\ɾ��)
  SqlStr_BaseData[1,15]:='select * from dic_code_info where diccode=@Param1 and dictype=@Param2';
  //�޸�ʱ�ж��ֵ����������Ƿ��ظ�
  SqlStr_BaseData[1,16]:='select * from dic_code_info where diccode<>@Param1 and dictype=@Param2 and dicname=''@Param3'' ';
  //�澯����
  SqlStr_BaseData[1,17]:='select t.buildingid,t.buildingname from building_info t where t.areaid=@param1 ';
  //�澯�����showgrid
  SqlStr_BaseData[1,18]:='select a.mtuid,a.mtuname as MTU����,a.mtuno as MTU�ⲿ���,a.overlay as ��������,a.mtuaddr as MTUλ��,a.call as �绰����,a.called as ���к���, '+
                         ' b.status ,decode(b.status,1,''����'',0,''����'',''δ֪'') as MTU״̬,b.updatetime ״̬���ʱ��,a.linkno as ������,a.buildingno as �����ҷֵ�, '+
                         ' a.area as ��������,a.buildingid,a.areaid,a.top_id,a.cityid '+
                         ' from mtu_info_view a left join mtu_status_list b '+
                         ' on a.mtuid=b.mtuid where @param1';               //����޸� CDJ 20080429
  //�澯�����ComboBoxTextType
  SqlStr_BaseData[1,19]:='select t.comid,t.comname from mtu_command_define t where t.comtype=1 and t.ifineffect=1 and t.comid<>9 order by t.comid';
  //�澯�����
  SqlStr_BaseData[1,20]:='select * from mtu_testtask_online t where taskid=@param1 ';

  SqlStr_BaseData[1,21]:={'select a.paramid,a.paramname,b.paramvalue from  mtu_param_define a  '+
                         ' left join mtu_autotestparam_config b  '+
                         ' on a.paramid=b.paramid where b.comid=@param1 ';   }
                         'select a.paramid,a.paramname,b.paramvalue from  mtu_comparam_config a '+
                         ' left join mtu_autotestparam_config b  '+
                         ' on a.paramid=b.paramid and a.comid=b.comid '+
                         ' where  a.comid=@param1 ';
  SqlStr_BaseData[1,22]:='select * from mtu_testtaskparam_online t';
  //�澯�����EXCEPTdelete
  SqlStr_BaseData[1,23]:='select * from mtu_testtaskparam_online t where  t.taskid=@param1';
  //�������show_task
  SqlStr_BaseData[1,24]:='select taskid ������,comname as ��������,status,'+
                         ' decode(status,1,''δ����'',2,''�ѷ���'',3,''��ִ��'',4,''���Գɹ�'',5,''����ʧ��'',6,''δ��Ӧ'',7,''��ֹͣ״̬'',0) as ����״̬,'+
                         ' testresult as ���Խ��,asktime as �������ʱ��, '+
                         ' rectime as ���ղ��Խ��ʱ��,mtuno as MTU����,name as ��������,username as �û���,comid,buildingid,cityid,mtuid '+
                         ' from mtu_testtask_online_view a  where @param1 and a.userid>-1 and  a.status<>7 order by taskid desc';

  SqlStr_BaseData[1,25]:='select * from mtu_testtask_online t where t.taskid=@param1';
  SqlStr_BaseData[1,26]:='select * from mtu_testtaskparam_online t where t.taskid=@param1';
  SqlStr_BaseData[1,27]:='select a.mtuno as MTU�豸���,a.comname as ��������,a.paramname as ���Բ���,a.valueindex as ������,a.testresult as ���Խ��ֵ,'+
                         ' a.collecttime as �ɼ�ʱ��,a.execid as ִ�����,decode(a.isprocess,0,''δ����'',1,''������'',2,''�Ѵ���'') as �Ƿ��Ѵ���,a.name as ��������,a.comid,a.cityid '+
                         ' from mtu_usertestresult_view a where a.taskid = @param1 order by a.comid,a.execid,a.paramid,a.valueindex';

  //���ò������ƺ�ֵ
  SqlStr_BaseData[1,31]:='select t1.comid ������,t3.paramname ��������,t1.paramid �������,t2.paramvalue ����ֵ '+
                  'from mtu_comparam_config t1 left join mtu_autotestparam_config t2 '+
                  'on t1.comid=t2.comid and t1.paramid=t2.paramid '+
                  'left join mtu_param_define t3 on t1.paramid=t3.paramid '+
                  'where t1.comid=@param1';
  //��������Ϊ1�����ԣ�������  ������ "comid=9 ֹͣ��������"
  SqlStr_BaseData[1,32]:='select * from mtu_command_define where comtype=1 and comid<>9';
  //����ֵ����ӣ��޸ģ�
  SqlStr_BaseData[1,33]:='select * from mtu_autotestparam_config where comid=@param1';
  SqlStr_BaseData[1,60]:='select * from mtu_usertestresult  t where t.taskid=@param1';
  SqlStr_BaseData[1,62]:='select * from mtu_testtaskparam_online t where t.taskid=@param1';

  //�澯����(ʡ)   �澯���,�澯����,MTU����,�����,�澯�ۼƴ���,�ҷֵ�,����,����
  SqlStr_BaseData[1,34]:='select * from alarm_master_online_view @param1 order by readed asc,sendtime desc';
  //�澯�ӱ�   �澯��ţ��澯���ݣ��ɼ�ʱ�䣬�澯״̬���ɼ����
  SqlStr_BaseData[1,35]:='select a.alarmid,b.alarmcontentname,a.collecttime,'+
      'decode(a.status,1,''�澯'',2,''�ų�'') status,a.collectid from alarm_detail_online a '+
      'left join mtu_alarm_content b on a.alarmcontentcode=b.alarmcontentcode '+
      'where a.alarmid=@param1 order by a.collectid';

  //�澯����(����)
  SqlStr_BaseData[1,36]:='select * from alarm_master_online_view where flowtache=2 and cityid =@param1 order by readed asc,sendtime desc';
  //�澯����(����)
  SqlStr_BaseData[1,37]:='select * from alarm_master_online_view where flowtache=2 and areaid=@param1 order by readed asc,sendtime desc';
  //�澯����(�ҷֵ�)
  SqlStr_BaseData[1,38]:='select * from alarm_master_online_view where flowtache=2 and  buildingid=@param1 order by readed asc,sendtime desc';
  //�澯����(��վ)
  SqlStr_BaseData[1,39]:='select * from alarm_master_online_view where flowtache=2 and  buildingid=(select buildingid from cs_info where csid=@param1) order by readed asc,sendtime desc';
  //�澯����(������)
  SqlStr_BaseData[1,40]:='select * from alarm_master_online_view where flowtache=2 and buildingid=(select buildingid from switch_info where switchid=@param1) order by readed asc,sendtime desc';

  //�澯����(AP)
  SqlStr_BaseData[1,41]:='select * from alarm_master_online_view where  flowtache=2 and  buildingid=(select buildingid from switch_info '+
      'where switchid=(select switchid from ap_info where apid=@param1)) order by readed asc,sendtime desc';
  //�ҷֵ���Ϣ
  SqlStr_BaseData[1,42]:='select buildingname,longitude,latitude from building_info where (longitude is not null) and (latitude is not null)';
  //�����ҷֵ�
  SqlStr_BaseData[1,43]:='select a.buildingname,a.longitude,a.latitude from building_info a where a.buildingname=''@Param1'' ';
  SqlStr_BaseData[1,44]:='select comid,orderid from mtu_autotestcyc_config';
  //GIS����ʾ�ҷֵ���Ϣ
//  SqlStr_BaseData[1,45]:='select a.buildingno �ҷֵ���,a.buildingname �ҷֵ�����,a.address �ҷֵ��ַ,'+
//            'a.longitude ����,a.latitude γ��,a.floorcount �ҷֵ����,a.buildingarea �ҷֵ����,'+
//            'b.dicname as ��������,c.dicname as ����,d.dicname as ��������,'+
//            'e.dicname as �ҷֵ�����,f.name as �־� from building_info a '+
//            'left join dic_code_info b on a.nettype=b.diccode and b.dictype =1 '+
//            'left join dic_code_info c on a.factory=c.diccode and c.dictype =3 '+
//            'left join dic_code_info d on a.connecttype=d.diccode and d.dictype=4 '+
//            'left join dic_code_info e on a.buildingtype=e.diccode and e.dictype=2 '+
//            'left join area_info f on a.areaid=f.id and f.layer=3 '+
//            'where a.buildingid=@param1';
  SqlStr_BaseData[1,45]:='select buildingno �ҷֵ���,buildingname �ҷֵ�����,address �ҷֵ��ַ,'+
                          'longitude ����,latitude γ��,floorcount �ҷֵ����,buildingarea �ҷֵ����,'+
                          'nettypename ��������,factoryname as ����,connecttypename as ��������,'+
                          'buildingtypename �ҷֵ�����,suburbname �־� from building_info_view t '+
                          ' where t.areaid in (@param1) @param2';
  //��ʷ�澯�������� (�����ҷֵ����Ʋ���)
  SqlStr_BaseData[1,46]:='select * from alarm_master_history_view '+
      'where flowtache=3 and buildingid in (select buildingid from building_info '+
      'where buildingname=''@param1'') @param2 order by removetime desc';
  //��ʷ�澯�ӱ�����   �澯��ţ��澯���ݣ��ɼ�ʱ�䣬�澯״̬���ɼ����
  SqlStr_BaseData[1,47]:='select a.alarmid,b.alarmcontentname,a.collecttime,'+
      'decode(a.status,1,''�澯'',2,''�ų�'') status,a.collectid from alarm_detail_history a '+
      'left join mtu_alarm_content b on a.alarmcontentcode=b.alarmcontentcode '+
      'where a.alarmid=@param1 order by a.collectid';
  //��ʷ�澯����(ʡ)   �澯���,�澯����,MTU����,�����,�澯�ۼƴ���,�ҷֵ�,����,����
  SqlStr_BaseData[1,48]:='select * from alarm_master_history_view @param1 order by removetime desc';

  //��ʷ�澯����(����)
  SqlStr_BaseData[1,49]:='select * from alarm_master_history_view '+
      'where flowtache=3 and cityid=@param1 @param2 order by removetime desc';

  //��ʷ�澯����(����)
  SqlStr_BaseData[1,50]:='select * from alarm_master_history_view '+
      'where flowtache=3 and areaid=@param1 @param2 order by removetime desc';

  SqlStr_BaseData[1,51]:='select a.comid,b.comname  from mtu_autotestcyc_config a left join mtu_command_define b on a.comid=b.comid order by a.orderid';
  //�������ı�ʶ
  SqlStr_BaseData[1,52]:='update alarm_master_online set readed=1 where alarmid in ( @param1 )';

  //��ʷ�澯����(�ҷֵ�)
  SqlStr_BaseData[1,53]:='select * from alarm_master_history_view where flowtache=3 and buildingid=@param1 @param2 order by removetime desc';
  //��ʷ�澯����(��վ)
  SqlStr_BaseData[1,54]:='select * from alarm_master_history_view where flowtache=3 and buildingid=(select buildingid from cs_info where csid=@param1) @param2 order by removetime desc';
  //��ʷ�澯����(������)
  SqlStr_BaseData[1,55]:='select * from alarm_master_history_view where flowtache=3 and buildingid=(select buildingid from switch_info where switchid=@param1) @param2 order by removetime desc';
  //�澯����(AP)
  SqlStr_BaseData[1,56]:='select * from alarm_master_history_view where flowtache=3 and buildingid=(select buildingid from switch_info '+
      'where switchid=(select switchid from ap_info where apid=@param1)) @param2 order by removetime desc';
  //�澯�������� (�����ҷֵ����Ʋ���)
  SqlStr_BaseData[1,57]:='select * from alarm_master_online_view '+
      'where flowtache=2 and buildingid in (select buildingid from building_info '+
      'where buildingname=''@param1'') order by readed asc,sendtime desc';

//�鿴�����û�������Ϣ �������û���
  SqlStr_BaseData[1,58]:='select userid �û����,userno �û��ʺ�,username ����,email ����,'+
  'decode(sex,0,''��'',1,''Ů'',''��'') �Ա�,dept ����ְλ,officephone �칫�绰,mobilephone �ֻ�,'+
  'creator �����߱��,cityid ��������,areaid �������� from userinfo '+
  'where cityid=@param1 and areaid<>0';
//�鿴�����û�������Ϣ ������Ա��
  SqlStr_BaseData[1,59]:='select userid �û����,userno �û��ʺ�,username ����,email ����,'+
  'decode(sex,0,''��'',1,''Ů'',''��'') �Ա�,dept ����ְλ,officephone �칫�绰,mobilephone �ֻ�,'+
  'creator �����߱��,cityid ��������,areaid �������� from userinfo '+
  'where userid<>0';
//�鿴�����û�������Ϣ ��ʡ�û���
  SqlStr_BaseData[1,61]:='select userid �û����,userno �û��ʺ�,username ����,email ����,'+
  'decode(sex,0,''��'',1,''Ů'',''��'') �Ա�,dept ����ְλ,officephone �칫�绰,mobilephone �ֻ�,'+
  'creator �����߱��,cityid ��������,areaid �������� from userinfo '+
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
  SqlStr_BaseData[1,71]:='select drsno ֱ��վ���,r_deviceid �豸���,drsname ֱ��վ����,drstypename ����,drsmanuname ��ַ,' +
                         '       drsadress ��ַ,drsphone �绰����,longitude ����,latitude γ��,' +
                         '       isprogramname �Ƿ��ҷ�,suburbname �����־�,buildingname �����ҷֵ�' +
                         '  from DRS_info_view t' +
                         ' where t.areaid in (@param1) @param2';

  //20080317����
  //����δ���ϸ澯
  SqlStr_BaseData[2,1] := 'select * from alarm_master_online_view where flowtache=2 @param1 order by readed asc,sendtime desc';
  SqlStr_BaseData[2,2] := 'select * from alarm_master_history_view where flowtache=3 @param1 order by readed asc,sendtime desc';
  SqlStr_BaseData[2,3]:='select * from area_info where layer in (0,1,2,3)';


  //�澯���
  //δ���ϸ澯
  SqlStr_BaseData[3,1]:= 'select * from alarm_master_online_view where flowtache=2 @param1 order by readed asc,sendtime desc';
  //�����Ѿ����ϸ澯���������ϵ���ʷ�澯TABҳ��
  SqlStr_BaseData[3,2]:= 'select * from alarm_master_history_view'+
                         ' where flowtache=3 and to_char(removetime,''yyyy-mm-dd'')=to_char(sysdate,''yyyy-mm-dd'') @param1 order by alarmid desc';
  //���N�β��Խ���굥
  SqlStr_BaseData[3,3]:= 'select * from mtu_alarmresult_view t where t.alarmid=@param1 order by t.taskid desc';
  //ĳMTU��N�θ澯
  SqlStr_BaseData[3,4]:= 'select * from (select t.*,dense_rank() over (order by t.alarmid desc) r '+
                                        ' from (select * from alarm_master_online_view union '+
                                               'select * from alarm_master_history_view) t'+
                                        ' where mtuid=@param1)'+
                          ' where r<=@param2';
  //�����ҷֵ㴰�� GIS��λ �����ﲻ����ͼ������ֱ��SQL��
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
                          ' where a.areaid in (@param1) @param2'+ //AREAID��Ȩ��
                          ' group by buildingid,buildingno,buildingname,buildingaddr,suburbname,areaname';
  //MTU��ͼ��λ
  SqlStr_BaseData[3,6]:=  'select a.mtuid,a.mtuno,a.mtuname,'+
                          ' case when a.buildingid<>-1 then ''MTU'' else null end as MTUSTATUS,'+
                          ' b.buildingid,b.buildingno,b.buildingname,'+
                          ' case when a.buildingid<>-1 then ''����'' else ''����'' end as isprogramname,'+
                          ' c.id suburbid,c.name suburbname,'+
                          ' d.id areaid,d.name areaname,'+
                          ' e.id cityid,e.name cityname'+
                          ' from mtu_info a'+
                          ' left join building_info b on a.buildingid=b.buildingid'+
                          ' left join area_info c on a.suburb=c.id and c.layer=3'+
                          ' left join area_info d on c.top_id=d.id and d.layer=2'+
                          ' left join area_info e on d.top_id=e.id and e.layer=1'+
                          ' where 1=1 @param1';
  //���߲�������
  SqlStr_BaseData[3,11]:= 'select a.mtuid,a.mtuno,b.status,decode(b.status,1,''����'',0,''����'',''δ֪'') statusname,'+
                          ' b.status_power,b.status_wlan,decode(h.tranlatevalue,null,''δ֪'',h.tranlatevalue) status_powername,decode(i.tranlatevalue,null,''δ֪'',i.tranlatevalue) status_wlanname,'+
                          ' nvl(c.alarmcounts,0) alarmcounts'+
                          ' from mtu_info a'+
                          ' left join mtu_status_list b on a.mtuid=b.mtuid'+
                          ' left join (select mtuid,count(1) alarmcounts from alarm_master_online where flowtache=2 group by mtuid) c on a.mtuid=c.mtuid '+
                          ' left join mtu_testresult_translate h on b.status_power=h.orderindex and h.comid=65 and h.paramid=3'+
                          ' left join mtu_testresult_translate i on b.status_wlan=i.orderindex and i.comid=69 and i.paramid=42'+
                          ' where a.mtuid=@param1';
  SqlStr_BaseData[3,12]:= 'select decode(a.paramid,50,''BCƵ��'',51,''�ŵ���'',52,''ϵͳ��ʶ'','+
                          ' 53,''�����ʶ'',54,''��Ƶƫ��'',55,''Slot cycle'','+
                          ' 56,''���͹��ʿ���'',57,''������'') caption,decode(a.paramid,57,b.tranlatevalue,a.testresult) testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' left join mtu_testresult_translate b on a.comid=b.comid and a.paramid=b.paramid and a.testresult=to_char(b.orderindex)'+
                          ' where a.comid=@param2 and a.paramid>=50 and a.paramid<=57 and a.mtuid=@param1';
  SqlStr_BaseData[3,13]:= 'select decode(a.paramid,15,''��վ'',1019,''RX��ǿ'',1020,''EC/IO'') caption,'+
                          ' a.testresult testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (15,1019,1020) and a.mtuid=@param1';
  SqlStr_BaseData[3,14]:= 'select decode(a.paramid,1002,''(TX�����)TX��ǿ'',1018,''(TX�����)��ͨ������'') caption,'+
                          ' a.testresult testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (1002,1018) and a.mtuid=@param1';
  SqlStr_BaseData[3,15]:= 'select decode(a.paramid,59,''TX'',60,''T_ADD'',61,''T_DROP'',62,''T_COMP'',63,''T_TDROP'') caption,'+
                          ' a.testresult testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (59,60,61,62,63) and a.mtuid=@param1';
  SqlStr_BaseData[3,16]:= 'select * from (select a.valueindex,'+
                          ' max(case when a.paramid=1021 then ''���PN ''||a.testresult else null end) as caption,'+
                          ' max(case when a.paramid=58 then a.testresult else null end) as testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=@param2 and a.paramid in (1021,58) and a.mtuid =@param1'+
                          ' group by a.valueindex) order by testvalue';
  SqlStr_BaseData[3,17]:= 'select * from (select a.valueindex,'+
                          ' max(case when a.paramid=1021 then ''����PN ''||a.testresult else null end) as caption,'+
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
                          ' max(case when a.paramid=1021 then ''��ѡ��PN ''||a.testresult else null end) as caption,'+
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
  SqlStr_BaseData[3,22]:= 'select decode(a.paramid,42,''WLAN״̬'') caption,'+
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
  SqlStr_BaseData[3,24]:= 'select * from (select decode(a.paramid,28,''����ʱ��'',23,''���Խ��'',25,''�ϴ�����'',26,''��������'',null) as caption,'+
                          ' decode(a.paramid,28,1,23,2,25,3,26,4,5) as ordervalue,'+
                          ' decode(a.paramid,23,decode(b.tranlatevalue,null,a.testresult,b.tranlatevalue),a.testresult) testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' left join mtu_testresult_translate b on a.comid=b.comid and a.paramid=b.paramid and a.testresult=to_char(b.orderindex)'+
                          ' where a.comid=134 and a.paramid in (23,25,26,28) and a.mtuid=@param1)'+
                          ' order by ordervalue';
  SqlStr_BaseData[3,25]:= 'select * from (select decode(a.paramid,28,''����ʱ��'',29,''���͵����ݰ���'',30,''���յ����ݰ���'',31,''���ʱ��'',32,''��Сʱ��'',33,''ƽ��ʱ��'',34,''������'',null) as caption,'+
                          ' decode(a.paramid,28,1,29,2,30,3,31,4,32,5,33,6,34,7,8) as ordervalue,'+
                          ' a.testresult testvalue'+
                          ' from mtu_testresult_recent a'+
                          ' where a.comid=135 and a.paramid in (28,29,30,31,32,33,34) and a.mtuid=@param1)'+
                          ' order by ordervalue';
  //�쳣�¼������(�˹���δ����)
  //δ�ɸ澯
  //  SqlStr_BaseData[3,21]:= 'select * from alarm_master_online_view where flowtache=1 @param1 order by readed asc,sendtime desc';


  //�澯�ۺϲ�ѯ
  SqlStr_BaseData[3,31]:= 'select * from alarm_master_online_view a where flowtache=2 @param1 order by sendtime desc';
  SqlStr_BaseData[3,32]:= 'select * from alarm_master_history_view a where 1=1 @param1 order by sendtime desc';


  //�����굥
  //������������
  SqlStr_BaseData[3,41]:= 'select * from dic_code_info t where t.dictype=21 order by t.dicorder';
  //��ʾ����MTU״̬��Ϣ
  SqlStr_BaseData[3,42]:=' select * from mtu_recentstatue_view where mtuid=@param1';
  //���в��Խڵ�
  SqlStr_BaseData[3,44]:= 'select * from'+
                            '(select a.taskid,b.mtuno,''���в�������'' comname,'+
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
  //MOSֵ��������ڵ�
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
  //������ͨ��������ڵ�
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
  //����ʱ�Ӳ�������
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
  //��ǿ���֪ͨ
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
                          '           max(case when comid=66 and paramid=4 then ''��ǿ:'' else null end)||'+
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
  //WLAN���ʲ�������
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
  //WLANʱ�Ӷ��������������
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
  //WLAN��ǿ���֪ͨ
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
  //WLAN����֪ͨ
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
  //MTS�豸������֪ͨ
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
  //MTU״̬��ѯ����
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
  //PPP���Ų�������
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
  //CDMA��Ϣ���֪ͨ
  SqlStr_BaseData[3,56]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' decode(a.comid,73,''����'',89,''ͨ��'',null) as teststatus,'+
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
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime,decode(a.comid,73,''����'',89,''ͨ��'',null))'+
                          ' @param3';
  //�л���ز������֪ͨ
  SqlStr_BaseData[3,57]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,c.comname,'+
                          ' decode(a.comid,74,''����'',90,''ͨ��'',null) as teststatus,'+
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
                          ' group by a.taskid,b.mtuno,c.comname,a.collecttime,decode(a.comid,74,''����'',90,''ͨ��'',null))'+
                          ' @param3';
  //Finger��Ϣ���֪ͨ
  SqlStr_BaseData[3,58]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,testvalue,'+
                          ' decode(a.comid,75,''����'',91,''ͨ��'',null) as teststatus,'+
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
                          ' group by a.taskid,b.mtuno,c.comname,testvalue,a.collecttime,decode(a.comid,75,''����'',91,''ͨ��'',null))'+
                          ' @param3';
  //�����Ϣ���֪ͨ
  SqlStr_BaseData[3,59]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,testvalue,'+
                          ' decode(a.comid,76,''����'',92,''ͨ��'',null) as teststatus,'+
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
                          ' group by a.taskid,b.mtuno,c.comname,testvalue,a.collecttime,decode(a.comid,76,''����'',92,''ͨ��'',null))'+
                          ' @param3';
  //��ѡ����Ϣ���֪ͨ
  SqlStr_BaseData[3,60]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,testvalue,'+
                          ' decode(a.comid,77,''����'',93,''ͨ��'',null) as teststatus,'+
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
                          ' group by a.taskid,b.mtuno,c.comname,testvalue,a.collecttime,decode(a.comid,77,''����'',93,''ͨ��'',null))'+
                          ' @param3';
  //������Ϣ���֪ͨ
  SqlStr_BaseData[3,61]:= 'select * from'+
                          '(select a.taskid,b.mtuno,c.comname,testvalue,'+
                          ' decode(a.comid,78,''����'',94,''ͨ��'',null) as teststatus,'+
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
                          ' group by a.taskid,b.mtuno,c.comname,testvalue,a.collecttime,decode(a.comid,78,''����'',94,''ͨ��'',null))'+
                          ' @param3';
  //ƽ̨����
  SqlStr_BaseData[3,62]:= 'select * from'+
                          ' (select a.taskid,b.mtuno,''����ƽ̨����MTU���Խ��'' comname,'+
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

  //CDMA��Դ����
  //�־� �ҷֵ� AP ������ PHS CDMA
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
  //CDMAˢ����   ���� t.areaid in (@param1) ������Ȩ��
  SqlStr_BaseData[4,11] := 'select * from cdma_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  //�ж��Ƿ����
  SqlStr_BaseData[4,12] := 'select 1 from @param1 t'+
                           ' where upper(@param2)=upper(''@param3'') @param4';
  //�������SQL���в���
  SqlStr_BaseData[4,13] := '@param1';



  //MTU��Դ����
  //ȡ�澯����ģ��
  SqlStr_BaseData[4,21] := 'select * from mtu_alarm_model t where t.parentmodelid<>0 and t.parentmodelid<>1';
  //ˢ��MTU
  SqlStr_BaseData[4,22] := 'select * from mtu_info_view t'+
                           ' where t.areaid in (@param1) @param2';
  //ˢ��C����Ϣ
  SqlStr_BaseData[4,23] := 'select t.cdmaid,t.cdmatype,decode(t.cdmatype,1,''ֱ��վ'',2,''RRU'',3,''���վ'',''δ֪'') cdmatypename,t.pncode,t.address'+
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
  SqlStr_BaseData[4,48] := 'select ''0'' as proviceid,''ȫʡ'' as provicename,cityid as cityid,cityname as cityname,' +
                           '       areaid,areaname,suburbid,suburbname,isprogram,isprogramname,' +
                           '       buildingid,buildingname,''DRS'' as DRS,' +
                           '       drsid,drsname||''(''||drsstatusname||'')'' as drsname,drsno,drsadress,drsphone' +
                           '  from drs_info_view' +
                           ' where isprogram=1' +
                           '   and @drsid=@param1' +
                           ' order by cityid,areaid,suburbid,drsid ';
  SqlStr_BaseData[4,49] := 'select ''0'' as proviceid,''ȫʡ'' as provicename,cityid as cityid,cityname as cityname,' +
                           '       areaid,areaname,suburbid,suburbname,isprogram,isprogramname,''DRS'' as DRS,' +
                           '       drsid,drsname||''(''||drsstatusname||'')'' as drsname,drsno,drsadress,drsphone' +
                           '  from drs_info_view' +
                           ' where isprogram=0' +
                           '   and drsid=@param1' +
                           ' order by cityid,areaid,suburbid,drsid ';
  SqlStr_BaseData[4,50] := 'select ''0'' as proviceid,''ȫʡ'' as provicename,cityid as cityid,cityname as cityname,' +
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
  Init_SqlStr_Common();  //0 ����
  Init_SqlStr_Resource();//1 ��Դ����
  Init_SqlStr_BaseData();//2 �������ݹ���
end;


end.
