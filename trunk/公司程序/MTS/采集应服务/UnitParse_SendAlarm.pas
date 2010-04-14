unit UnitParse_SendAlarm;

interface
uses Windows, Classes, Log, DateUtils, IniFiles, IdGlobal, SysUtils,
  Forms,Ut_BaseThread,ADODB,DB,Variants,Ut_MtuInfo;

type
  TCollectIDArray = Array of Array of integer;

  TParse_SendAlarm = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn : TAdoConnection;
    FQuery, FQuery2, FQueryFree, FQueryAlarmData, FQueryAlarmContent: TAdoQuery;
    FSQLList :TStringList;
    FMTULIst :TStringList;
    FSQLList_Index: integer;
    FIfResend: boolean;
    //����MsgData������cityidΪ�������ĵ��б�ţ�����������
    function ParseBaseData(cityid:integer;MsgData:TIdBytes;var aTaskid:integer):integer;
    procedure ExecSQLList(FMyQuery :TAdoQuery;sqllist:TStringList);
    //�澯����
    function AlarmCollect_Rule(aCityid: integer;var aTaskid: integer; var CollectIDs:TCollectIDArray):boolean;
    //���Ϲ���
    function AlarmSend_Rule(aCityid, aCollectID, aTaskid, aAlarmType,
                             aMtuid, aContentcode, aAlarmcount, aRemovecount: integer):integer;
    function JudgeIsAlarm(ParamValue,AlarmValue,RemoveValue:String):integer;
    //��һվʽ�ṩ��������
    procedure GetAlarmData(aMtuid,aContentCode,aStatus : integer);
    //����
    function TaskResend(aTaskid, aCityid: integer):boolean;
    procedure doAfter;
    //�쳣�澯�Ĳ��Խ������  aAlarmcountΪ�澯����
    procedure SaveAlarmResult(aAlarmid,aCityid,aTaskid,aAlarmcount,aContentCode: integer);
    //��������һ��������ƽ̨����MTU�������
    procedure TaskSendCallCenter(aMtuid, aCityid: integer);
  protected
    procedure DoExecute; override;
  public
    constructor Create(Log :TLog;ConnStr :String);
    destructor Destroy; override;
  end;
implementation

uses Ut_Global, UnitThreadCommon;
{ TParse_SendAlarm }

function TParse_SendAlarm.AlarmCollect_Rule(aCityid: integer;
  var aTaskid: integer;var CollectIDs:TCollectIDArray):boolean;
var
  vIndex :integer;
  lCollectingFlag :integer;
  lSqlstr: string;
  lCollectID: integer;
begin
  result:= false;
  lSqlstr:= 'select * from MTU_TESTRESULT_ONLINE a where a.taskid='+inttostr(aTaskid);
  with FQuery2 do
  begin
    close;
    sql.Text:=  lSqlstr;
    open;
    if recordcount>0 then
    begin
      vIndex :=0;
      first;
      while not Eof do
      begin
//        FQueryAlarmContent.Filtered:= false;
//        FQueryAlarmContent.Filter:= ' MTUID='+Fieldbyname('MTUID').AsString+
//                                    ' and COMID='+Fieldbyname('COMID').AsString+
//                                    ' and PARAMID='+Fieldbyname('PARAMID').AsString;
//        FQueryAlarmContent.Filtered:= true;
        if FQueryAlarmContent.Locate('MTUID;COMID;PARAMID',
             VarArrayOf([Fieldbyname('MTUID').AsInteger,Fieldbyname('COMID').AsInteger,
             Fieldbyname('PARAMID').AsInteger]),[loCaseInsensitive]) then
//        if FQueryAlarmContent.RecordCount>0 then
        begin
          SetLength(CollectIDs,vIndex+1);
          SetLength(CollectIDs[vIndex],8);
          if (Trim(FQueryAlarmContent.FieldByName('ALARMCONDITION').AsString)='') or (Trim(FQueryAlarmContent.FieldByName('REMOVECONDITION').AsString)='') then
            lCollectingFlag :=0
          else
            lCollectingFlag := JudgeIsAlarm(FieldByName('testresult').AsString,
                               FQueryAlarmContent.FieldByName('ALARMCONDITION').AsString,FQueryAlarmContent.FieldByName('REMOVECONDITION').AsString);
          //Ŀǰ�澯���ݲ���collect��
          lCollectID:=0;
          CollectIDs[vIndex,0]:= aCityid;
          CollectIDs[vIndex,1]:= lCollectID;
          CollectIDs[vIndex,2]:= aTaskid;
          CollectIDs[vIndex,3]:= lCollectingFlag;
          CollectIDs[vIndex,4]:= FQueryAlarmContent.FieldByName('mtuid').AsInteger;
          CollectIDs[vIndex,5]:= FQueryAlarmContent.FieldByName('alarmcontentcode').AsInteger;
          CollectIDs[vIndex,6]:= FQueryAlarmContent.FieldByName('alarmcount').AsInteger;
          CollectIDs[vIndex,7]:= FQueryAlarmContent.FieldByName('removecount').AsInteger;
          Inc(vIndex);
        end;
        next;
      end;
    end;
  end;
  lSqlstr:= 'update MTU_TESTRESULT_ONLINE set ISPROCESS=2 where taskid='+inttostr(aTaskid);
  ExecMySQL(FQueryFree,lSqlstr);
  result:= true;
end;
{var
  vIndex :integer;
  lCollectingFlag :integer;
  lSqlstr: string;
  lCollectID: integer;
begin
  result:= false;
  lSqlstr:= 'update MTU_TESTRESULT_ONLINE a set ISPROCESS=1'+
            ' where a.cityid='+inttostr(aCityid)+' and ISPROCESS=0'+
            ' and a.taskid='+inttostr(aTaskid);
  ExecMySQL(FQueryFree,lSqlstr);
  with FQuery2 do
  begin
    close;
//    sql.Text := 'select a.*,b.alarmcontentcode,b.alarmcondition, b.removecondition, b.alarmcount, removecount'+
//                ' from MTU_TESTRESULT_ONLINE a'+
//                ' inner join mtu_alarmcontent_view b'+
//                ' on a.mtuid=b.mtuid and a.comid=b.comid and a.paramid=b.paramid'+
//                ' where a.ISPROCESS=1 and b.ifineffect=1';
//    sql.Text := 'select a.*,b.alarmcontentcode,b.alarmcondition, b.removecondition, b.alarmcount, removecount'+
//                ' from MTU_TESTRESULT_ONLINE a'+
//                ' left join mtu_alarmcontent_view b'+
//                ' on a.mtuid=b.mtuid and a.comid=b.comid and a.paramid=b.paramid'+
//                ' where a.ISPROCESS=1 and nvl(b.ifineffect,0)=1';
//    sql.Text := 'select a.*,b.alarmcontentcode,b.alarmcondition, b.removecondition, b.alarmcount, removecount'+
//                ' from MTU_TESTRESULT_ONLINE a'+
//                ' inner join mtu_alarmcontent_view b'+
//                ' on a.mtuid=b.mtuid and a.comid=b.comid and a.paramid=b.paramid'+
//                ' where a.taskid='+inttostr(aTaskid)+' and b.ifineffect=1';
    sql.Text := 'select a.*,b.alarmcontentcode,b.alarmcondition, b.removecondition, b.alarmcount, removecount'+
                ' from MTU_TESTRESULT_ONLINE a'+
                ' left join mtu_alarmcontent_view b'+
                ' on a.mtuid=b.mtuid and a.comid=b.comid and a.paramid=b.paramid'+
                ' where a.taskid='+inttostr(aTaskid)+' and b.ifineffect=1';
    open;
    if recordcount>0 then
    begin
      vIndex :=0;
      SetLength(CollectIDs,RecordCount);
      first;
      while not Eof do
      begin
        //aTaskid:= FieldByName('taskid').AsInteger;//ÿ�����Խ���ı��
        SetLength(CollectIDs[vIndex],8);
        if (Trim(FieldByName('ALARMCONDITION').AsString)='') or (Trim(FieldByName('REMOVECONDITION').AsString)='') then
          lCollectingFlag :=0
        else
          lCollectingFlag := JudgeIsAlarm(FieldByName('testresult').AsString,
                             FieldByName('ALARMCONDITION').AsString,FieldByName('REMOVECONDITION').AsString);
        //Ŀǰ�澯���ݲ���collect��
        lCollectID:=0;
        CollectIDs[vIndex,0]:= FieldByName('cityid').AsInteger;//aCityid;
        CollectIDs[vIndex,1]:= lCollectID;
        CollectIDs[vIndex,2]:= FieldByName('taskid').AsInteger;//aTaskid;
        CollectIDs[vIndex,3]:= lCollectingFlag;
        CollectIDs[vIndex,4]:= FieldByName('mtuid').AsInteger;
        CollectIDs[vIndex,5]:= FieldByName('alarmcontentcode').AsInteger;
        CollectIDs[vIndex,6]:= FieldByName('alarmcount').AsInteger;
        CollectIDs[vIndex,7]:= FieldByName('removecount').AsInteger;
        Next;
        Inc(vIndex);
      end;
    end;
  end;
  lSqlstr:= 'update MTU_TESTRESULT_ONLINE set ISPROCESS=2 where ISPROCESS=1';
//  lSqlstr:= 'update MTU_TESTRESULT_ONLINE set ISPROCESS=2 where taskid='+inttostr(aTaskid);
  ExecMySQL(FQueryFree,lSqlstr);
  result:= true;
end;}
//0 δִ�� 1 ���� 2 �ۼ��������� 3 ���� 4 �ۼƸ澯���� 5 �澯����
function TParse_SendAlarm.AlarmSend_Rule(aCityid, aCollectID, aTaskid, aAlarmType, aMtuid,
  aContentcode, aAlarmcount, aRemovecount: integer):integer;
var
  lSqlstr: string;
  lCurr_AlarmCount,lCurr_RemoveCount: integer;
  lAlarmID: integer;
begin
  result:= 0;
  with FQuery2 do
  begin
    close;
    lSqlstr:= 'select * from alarm_master_online t where t.cityid='+inttostr(aCityid)+
              ' and t.mtuid='+inttostr(aMtuid)+' and t.alarmcontentcode='+inttostr(aContentcode);
    sql.Text:=lSqlstr;
    open;
    if recordcount>0 then
    begin
      lAlarmID:= FieldByname('alarmid').AsInteger;
      if aAlarmType=0 then  //������Ϣ
      begin
        lCurr_RemoveCount:= Fieldbyname('removecount').AsInteger;
        if lCurr_RemoveCount+1= aRemovecount then//����
        begin
          if Fieldbyname('FLOWTACHE').AsInteger=2 then
          begin
            //��������ʱ��,����״̬,�ų�����,�澯����
            lSqlstr:= 'update alarm_master_online t set REMOVETIME=sysdate,FLOWTACHE=3,'+
                      ' removecount=removecount+1,alarmcount=0'+
                      ' where t.cityid='+inttostr(aCityid)+
                      ' and mtuid='+inttostr(aMtuid)+' and alarmcontentcode='+inttostr(aContentcode);
            ExecMySQL(FQueryFree,lSqlstr);
            //���ϵĽ���ʷ��
            lSqlstr:= 'insert into alarm_master_history select * from alarm_master_online'+
                      ' where cityid='+inttostr(aCityid)+' and mtuid='+inttostr(aMtuid)+
                      ' and alarmcontentcode='+inttostr(aContentcode);
            ExecMySQL(FQueryFree,lSqlstr);
            //���߱�ɾ��
            lSqlstr:= 'delete from alarm_master_online t where t.cityid='+inttostr(aCityid)+
                      ' and mtuid='+inttostr(aMtuid)+' and alarmcontentcode='+inttostr(aContentcode);
            ExecMySQL(FQueryFree,lSqlstr);
//            //�������ϵ�����,������һ�����ݽ�alarm_data_gather��   �ṩ������ϵͳ��
//            GetAlarmData(aMtuid,aContentcode,0);
            result:= 1;
          end;
        end
        else if lCurr_RemoveCount< aRemovecount then//�ۼ��ų�����,��ո澯����
        begin
          lSqlstr:= 'update alarm_master_online t set removecount=removecount+1, alarmcount=0 where t.cityid='+inttostr(aCityid)+
                    ' and mtuid='+inttostr(aMtuid)+' and alarmcontentcode='+inttostr(aContentcode);
          ExecMySQL(FQueryFree,lSqlstr);
          result:= 2;
        end;
      end
      else if aAlarmType=1 then  //�澯��Ϣ
      begin
        lCurr_AlarmCount:= Fieldbyname('alarmcount').AsInteger;
        if lCurr_AlarmCount+1= aAlarmcount then//�澯�ɳ�ȥ
        begin
          if Fieldbyname('FLOWTACHE').AsInteger<>2 then
          begin
            //��������״̬,����ʱ��,�ų�����,�澯����
            lSqlstr:= 'update alarm_master_online t set FLOWTACHE=2, SENDTIME=sysdate,'+
                      ' REMOVECOUNT=0, alarmcount=alarmcount+1'+
                      ' where t.cityid='+inttostr(aCityid)+
                      ' and mtuid='+inttostr(aMtuid)+' and alarmcontentcode='+inttostr(aContentcode);
            ExecMySQL(FQueryFree,lSqlstr);
//            //�Ӹ澯������,������һ�����ݽ�alarm_data_gather��
//            GetAlarmData(aMtuid,aContentcode,1);
            result:= 3;
          end;
        end
        else if lCurr_AlarmCount< aAlarmcount then//�ۼƸ澯����,����ų�����
        begin
          lSqlstr:= 'update alarm_master_online t set alarmcount=alarmcount+1, REMOVECOUNT=0 where t.cityid='+inttostr(aCityid)+
                    ' and mtuid='+inttostr(aMtuid)+' and alarmcontentcode='+inttostr(aContentcode);
          ExecMySQL(FQueryFree,lSqlstr);
          result:= 4;
        end;
      end;     
    end
    else
    begin
      if aAlarmType=1 then  //�澯��Ϣ
      begin
        lAlarmID:= GetSequence(FQueryFree,'mtu_alarmid');
        lSqlstr:= 'insert into alarm_master_online'+
                  ' (alarmid, cityid, mtuid, alarmcontentcode, flowtache,'+
                  ' sendtime, removetime, collecttime, alarmcount, removecount, readed) values'+
                  ' ('+inttostr(lAlarmID)+','+inttostr(aCityid)+','+inttostr(amtuid)+','+inttostr(aContentcode)+','+
                  ' 1,null,null,sysdate,0,0,0)';
        ExecMySQL(FQueryFree,lSqlstr);
        result:= 5;
        //�澯���ɺ��������������ж�
        lCurr_AlarmCount:= 0;
        if lCurr_AlarmCount+1= aAlarmcount then//�澯�ɳ�ȥ
        begin
          //��������״̬,����ʱ��,�ų�����,�澯����
          lSqlstr:= 'update alarm_master_online t set FLOWTACHE=2, SENDTIME=sysdate,'+
                    ' REMOVECOUNT=0, alarmcount=alarmcount+1'+
                    ' where t.cityid='+inttostr(aCityid)+
                    ' and mtuid='+inttostr(aMtuid)+' and alarmcontentcode='+inttostr(aContentcode);
          ExecMySQL(FQueryFree,lSqlstr);
//          //�Ӹ澯������,������һ�����ݽ�alarm_data_gather��
//          GetAlarmData(aMtuid,aContentcode,1);
          //�����δ�غ���������Ƶ�澯 �ɸ�����ƽ̨����
          if aContentcode=46 then
            TaskSendCallCenter(amtuid,aCityid);
          result:= 3;
        end
        else if lCurr_AlarmCount< aAlarmcount then//�ۼƸ澯����,����ų�����
        begin
          lSqlstr:= 'update alarm_master_online t set alarmcount=alarmcount+1, REMOVECOUNT=0 where t.cityid='+inttostr(aCityid)+
                    ' and mtuid='+inttostr(aMtuid)+' and alarmcontentcode='+inttostr(aContentcode);
          ExecMySQL(FQueryFree,lSqlstr);
          result:= 4;
        end;
      end;
    end;
    //����Ǹ澯��Ϣ,�������澯���Խ����
    if aAlarmType=1 then
      SaveAlarmResult(lAlarmID,aCityid,aTaskid,aAlarmcount,aContentcode);
  end;
end;

constructor TParse_SendAlarm.Create(Log: TLog; ConnStr: String);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConnStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := false;
  
  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FConn;
  FQuery2 :=TAdoQuery.Create(nil);
  FQuery2.Connection := FConn;
  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection := FConn;
  FQueryAlarmData:= TAdoQuery.Create(nil);
  FQueryAlarmData.Connection := FConn;
  FQueryAlarmContent:= TAdoQuery.Create(nil);
  FQueryAlarmContent.Connection := FConn;

  FSQLList :=TStringList.Create;
  FMTULIst :=TStringList.Create;
end;

destructor TParse_SendAlarm.Destroy;
begin
  FSQLList.Free;
  FMTULIst.Free;
  FQuery.Close;
  FQuery.Free;
  FQuery2.Close;
  FQuery2.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FQueryAlarmData.Close;
  FQueryAlarmData.Free;
  FQueryAlarmContent.Close;
  FQueryAlarmContent.Free;
  FConn.Close;
  FConn.Free;
  inherited destroy;
end;

procedure TParse_SendAlarm.doAfter;
var
  lSqlstr: string;
begin
        //�º��� ����SQL�������ܻ�
        //���²ɼ�ʱ��  ��֤һ��ѭ�����ڵĲɼ�ʱ��һ��
        lSqlstr:= 'update mtu_testresult_online set collecttime=sysdate where isprocess=2';
        ExecMySQL(FQueryFree,lSqlstr);
//        //�Ѿ�����Ĳ��Խ��������¼����mtu_status_list��Ϣ
//        lSqlstr:= 'merge into mtu_status_list x'+
//                  ' using (select a.mtuid,max(case when (comid=136 or comid=68) and paramid=35 then a.testresult end) as mtustatus,'+
//                        ' max(case when comid=65 and paramid=3 then a.testresult end) as powerstatus,'+
//                        ' max(case when comid=69 and paramid=42 then a.testresult end) as wlanstatus'+
//                        ' from mtu_testresult_online a'+
////                        ' inner join (select max(taskid) taskid from mtu_testresult_online'+
////                        ' where ((comid=136 or comid=68)  and paramid=35) or (comid=65 and paramid=3)'+
////                        ' or (comid=69 and paramid=42) and isprocess=2'+
////                        ' group by comid,paramid,mtuid) b'+
////                        ' on a.taskid=b.taskid'+
//                        ' group by a.mtuid) y'+
//                  ' on (x.mtuid=y.mtuid)'+
//                  ' when matched then'+
//                  ' update set x.status=decode(y.mtustatus,null,x.status,y.mtustatus),'+
//
//                             ' x.status_power=decode(y.powerstatus,null,x.status_power,y.powerstatus),'+
//                             ' x.status_wlan=decode(y.wlanstatus,null,x.status_wlan,y.wlanstatus),'+
//                             ' x.updatetime=sysdate'+
//                  ' when not matched then'+
//                  ' insert (mtuid, status, updatetime, status_power, status_wlan)'+
//                  ' values (y.mtuid,y.mtustatus,sysdate,y.powerstatus,y.wlanstatus)';
//        ExecMySQL(FQueryFree,lSqlstr);
        //<<���浽���±�
        lSqlstr:= 'delete from mtu_testresult_recent a'+
                  ' where exists (select 1 from mtu_testresult_online b'+
                  ' where a.mtuid=b.mtuid and a.comid=b.comid and b.isprocess=2)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'insert into mtu_testresult_recent'+
                  ' select a.* from mtu_testresult_online a'+
                  ' left join  (select max(b.taskid) taskid from mtu_testresult_online b'+
                  ' where b.isprocess=2 group by b.cityid,b.comid,b.mtuid) b'+
                  ' on a.taskid=b.taskid'+
                  ' where b.taskid is not null';
        ExecMySQL(FQueryFree,lSqlstr);
        //���浽���±�>>
        //�Ѿ�����Ĳ��Խ�����²�������ֵSTATUS=4
        lSqlstr:= 'update mtu_testtask_online a set a.status=4,RECTIME=sysdate'+
                  ' where exists (select 1 from mtu_testresult_online b '+
                                'where a.cityid=b.cityid and a.taskid=b.taskid and b.isprocess=2)';
        ExecMySQL(FQueryFree,lSqlstr);
        //�Ѿ������ֶ����Խ�����ֶ����Ա� (���߳�ʱMOS�ļ�����ֵ)
        lSqlstr:= 'insert into mtu_usertestresult'+
                  ' select * from mtu_testresult_online a'+
                  ' where a.isprocess=2'+
                  ' and exists (select 1 from mtu_testtask_online b where a.cityid=b.cityid and a.taskid=b.taskid and b.userid<>-1)';
//        lSqlstr:= 'insert into mtu_usertestresult'+
//                  ' select * from mtu_testresult_online a'+
//                  ' where a.isprocess=2'+
//                  ' and exists (select 1 from mtu_testtask_online b where a.cityid=b.cityid and a.taskid=b.taskid and b.userid<>-1)'+
//                  ' and (not (a.comid=132 and (a.paramid=21 or a.paramid=22))'+
//                  ' or (a.comid=132 and (a.paramid=21 or a.paramid=22) and sysdate-a.COLLECTTIME>10*1/24/60))';
        ExecMySQL(FQueryFree,lSqlstr);
        //�Ѿ�������Զ����Խ������ʷ�� (���߳�ʱMOS�ļ�����ֵ)
        lSqlstr:= 'insert into mtu_testresult_history'+
                  ' select * from mtu_testresult_online a'+
                  ' where a.isprocess=2';
//        lSqlstr:= 'insert into mtu_testresult_history'+
//                  ' select * from mtu_testresult_online a'+
//                  ' where a.isprocess=2'+
//                  ' and (not (a.comid=132 and (a.paramid=21 or a.paramid=22))'+
//                  ' or (a.comid=132 and (a.paramid=21 or a.paramid=22) and sysdate-a.COLLECTTIME>10*1/24/60))';
        ExecMySQL(FQueryFree,lSqlstr);
        //ɾ���Ѿ�����Ĳ��Խ����������δ��MOS����ֵ�������ļ�����������δ��MOS��������ֵ����10���ӣ�
        lSqlstr:= 'delete from mtu_testresult_online a where a.isprocess=2';
//        lSqlstr:= 'delete from mtu_testresult_online a where a.isprocess=2'+
//                  ' and (not (a.comid=132 and (a.paramid=21 or a.paramid=22))'+
//                  ' or (a.comid=132 and (a.paramid=21 or a.paramid=22) and sysdate-a.COLLECTTIME>10*1/24/60))';
        ExecMySQL(FQueryFree,lSqlstr);
        //���½��ԭʼ��Ϊ�Ѵ���
        lSqlstr:= 'update mtu_testresult_base set isprocess=2,ENDDATE=sysdate where isprocess=1';
        ExecMySQL(FQueryFree,lSqlstr);
        //ɾ���Ѿ�����Ľ��ԭʼ�����ʷ��
        lSqlstr:= 'insert into MTU_TESTRESULT_BASE_HISTORY'+
                  ' select * from MTU_TESTRESULT_BASE a where a.isprocess=2';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from MTU_TESTRESULT_BASE where isprocess=2';
        ExecMySQL(FQueryFree,lSqlstr);
        //ɾ���Ѿ�������Զ������������ʷ��
        lSqlstr:= 'insert into MTU_TESTTASK_HISTROY'+
                  ' select a.* from MTU_TESTTASK_ONLINE a'+
                  ' where a.STATUS>=4 and a.userid=-1'; // in (4,5,6,7,8,9)
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from mtu_testtaskparam_online a where exists'+
                  ' (select 1 from mtu_testtask_online b where a.taskid=b.taskid and b.userid=-1'+
                  ' and b.STATUS>=4)';
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from mtu_testtask_online a where a.STATUS>=4 and a.userid=-1';
        ExecMySQL(FQueryFree,lSqlstr);
end;

procedure TParse_SendAlarm.DoExecute;
var
  lSqlstr :string;
  MsgData :TIdBytes;
  lTaskID : integer;
  lCollectIDs :TCollectIDArray;
  I :integer;
  lStatus : integer;
  lSendAlarmcount, lRemoveAlarmcount, lResendTaskcount: integer;
  lAlarmSendRuleFlag: integer;
  lParaseBaseDataStatus: integer;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write('���������߳��쳣: �޷��������ݿ�!',1);
    Exit;
  end;

  //���ظ澯����
  FLog.Write('���ظ澯����...',3);
  with FQueryAlarmContent do
  begin
    close;
    sql.Text:='select * from mtu_alarmcontent_view where ifineffect=1';
    open;
  end;
  //��������MTU�б�
  FLog.Write('��������MTU�б�...',3);
  with FQueryFree do
  begin
    close;
    sql.Text:='select upper(t.mtuno) mtuno from mtu_info t group by upper(t.mtuno)';
    open;
    FMTULIst.Clear;
    while not eof do
    begin
      FMTULIst.Add(Fieldbyname('mtuno').AsString);
      Next;
    end;
  end;
  //�Ƿ�����
  with FQueryFree do
  begin
    close;
    sql.Text:='select t.setvalue ifresend from sys_param_config t where t.itemkind=2 and t.itemcode=1';
    open;
    if Fieldbyname('ifresend').AsInteger=1 then
      FIfResend:= true
    else
      FIfResend:= false;
  end;


  try
    while True do //����ѭ��
    begin
      //����ǰN����¼���ȴ�ִ��
      FCounterDatetime:= GetSysDateTime(FQueryFree);
//      lSqlstr := 'update mtu_testresult_base a set a.isprocess=1 where a.isprocess=0'+
//      ' and a.baseid<=(select min(baseid)+100 from mtu_testresult_base where isprocess=0)';
      lSqlstr:= 'update mtu_testresult_base a set a.isprocess=1 where a.isprocess=0'+
                ' and rownum<=100';
      ExecMySQL(FQueryFree,lSqlstr);
      with FQuery do
      begin
        close;
        sql.Text := 'select * from mtu_testresult_base where isprocess=1';
        open;
        first;
        lSendAlarmcount:= 0;
        lRemoveAlarmcount:= 0;
        lResendTaskcount:= 0;
        while not eof do
        begin
          //��ʼ����
          lStatus:= 0;
          FConn.BeginTrans;
          try
            try
              MsgData := StrToIdBytes(FieldByName('testvalue').AsString);
              lTaskID := 0;
              //����ԭʼ���� 0ʧ�� 1 �ɹ� 2 ������Ӧ
              lParaseBaseDataStatus:= ParseBaseData(FieldByname('cityid').AsInteger,MsgData,lTaskID);
              if (lParaseBaseDataStatus=1) or (lParaseBaseDataStatus=3) then
              begin
                lStatus:= 1;//����ԭʼ���ݳɹ�
                edit;
                Fieldbyname('taskid').AsInteger := lTaskID;
                post;
                //�ɼ��澯(�ĳ��������ONLINE����������ݣ�)
                if AlarmCollect_Rule(FieldByname('cityid').AsInteger, lTaskID, lCollectIDs) then
                begin
                  lStatus:= 2;//�ɼ��澯�ɹ�
                  if lCollectIDs <> nil then
                  begin
                    for I := Low(lCollectIDs) to High(lCollectIDs) do
                    begin
                      //����
                      lTaskID:= lCollectIDs[i,2];
                      lAlarmSendRuleFlag:= AlarmSend_Rule(lCollectIDs[i,0],lCollectIDs[i,1],lCollectIDs[i,2],
                                     lCollectIDs[i,3],lCollectIDs[i,4],lCollectIDs[i,5],
                                     lCollectIDs[i,6],lCollectIDs[i,7]);
                      if lAlarmSendRuleFlag=1 then
                        inc(lRemoveAlarmcount)
                      else if lAlarmSendRuleFlag=3 then
                        inc(lSendAlarmcount)
                      else if (lAlarmSendRuleFlag=5) or (lAlarmSendRuleFlag=4) then//�ٲ��ԣ�
                      begin
                        if FIfResend then
                        begin
                          lStatus:= 4;
                          if TaskResend(lTaskID,FieldByname('cityid').AsInteger) then
                            inc(lResendTaskcount);
                        end;
                      end;
                    end;
                  end;
                  lStatus:= 3;//���ϳɹ�
                end;
              end else
              if lParaseBaseDataStatus=2 then//������Ӧ
                lStatus:= 3;
              FConn.CommitTrans;
            except
              on e: Exception do
              begin
                FConn.RollbackTrans;
                FLog.Write('������ʾ��'+E.Message,1);
                edit;
                Fieldbyname('ISPROCESS').AsInteger := 3;
                post;
                case lStatus of
                  0 : begin
                        FLog.Write('���������̣߳�BASEID< '+FieldByname('baseid').AsString+' >ִ��ʧ��',1);
                        FLog.Write('����״̬���������Խ��ԭʼ����ʧ��',1);
                        if FSQLList.Count> FSQLList_Index then
                          FLog.Write(FSQLList.Strings[FSQLList_Index],1);
                      end;
                  1 : begin
                        FLog.Write('���������̣߳�BASEID< '+FieldByname('baseid').AsString+' >ִ��ʧ��',1);
                        FLog.Write('���������̣߳�TASKID< '+inttostr(lTaskID)+' >ִ��ʧ��',1);
                        FLog.Write('����״̬���ɼ��澯����ʧ��',1);
                      end;
                  2 : begin
                        FLog.Write('���������̣߳�BASEID< '+FieldByname('baseid').AsString+' >ִ��ʧ��',1);
                        FLog.Write('���������̣߳�TASKID< '+inttostr(lTaskID)+' >ִ��ʧ��',1);
                        FLog.Write('����״̬������ʧ��',1);
                      end;
                  4 : begin
                        FLog.Write('���������̣߳�BASEID< '+FieldByname('baseid').AsString+' >ִ��ʧ��',1);
                        FLog.Write('���������̣߳�TASKID< '+inttostr(lTaskID)+' >ִ��ʧ��',1);
                        FLog.Write('����״̬���ٲ���ʧ��',1);
                      end;
                end;
              end;
            end;
          finally
            //�ͷ�
            SetLength(lCollectIDs,0);
            //�������������꣬����������
            case lStatus of
               0 : begin
                     FLog.Write('���������̣߳�BASEID< '+FieldByname('baseid').AsString+' >ִ��ʧ��',1);
                     FLog.Write('����״̬���������Խ��ԭʼ����ʧ��',1);
                   end;
               1 : begin
                     FLog.Write('���������̣߳�TASKID< '+inttostr(lTaskID)+' >ִ��ʧ��',1);
                     FLog.Write('����״̬���ɼ��澯����ʧ��',1);
                   end;
               2 : begin
                     FLog.Write('���������̣߳�TASKID< '+inttostr(lTaskID)+' >ִ��ʧ��',1);
                     FLog.Write('����״̬������ʧ��',1);
                   end;
               4 : begin
                     FLog.Write('���������̣߳�TASKID< '+inttostr(lTaskID)+' >ִ��ʧ��',1);
                     FLog.Write('����״̬���ٲ���ʧ��',1);
                   end;
             end;
          end;
          next;
        end;//N��ѭ������
        self.doAfter;
        FLog.Write('���ϣ�'+IntToStr(lSendAlarmcount)+' ����: '+IntToStr(lRemoveAlarmcount)+
                   ' �澯�ٲ���: '+IntToStr(lResendTaskcount),3);
        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('����'+inttostr(FQuery.RecordCount)+'���������'+FormatDatetime('HH:MM:SS��',FCurrentDateTime-FCounterDatetime),3);
        //���û�м�¼���˳�ѭ��
        if recordcount=0 then break;
      end;
      //�ֶ��˳�
      if Terminated then
        break;
    end;//����ѭ��
  finally
    FConn.Connected := false;
  end;
end;

procedure TParse_SendAlarm.ExecSQLList(FMyQuery: TAdoQuery;
  sqllist: TStringList);
var
  i: integer;
begin
  for i:= 0 to sqllist.Count - 1 do
  with FMyQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqllist.Strings[i]);
    //��ǰSQL�б������
    FSQLList_Index:= i;
    ExecSQL;
    Close;
  end;
end;

procedure TParse_SendAlarm.GetAlarmData(aMtuid, aContentCode, aStatus: integer);
var
  lSqlstr : string;
begin
  with FQueryAlarmData do
  begin
    Close;
    lSqlstr:= 'delete from alarm_data_gather where mtuid='+inttostr(aMtuid)+' and contentcode='+inttostr(aContentCode);
    Sql.Text := lSqlstr;
    ExecSQL;
    Close;
    lSqlstr:= 'insert into alarm_data_gather'+
              ' (id, mtuid, contentcode, status, updatetime, contentname, mtuno) '+
              ' select mtu_alarmdatacollectid.nextval,t1.mtuid,t1.contentcode,'+inttostr(aStatus)+',sysdate,t2.alarmcontentname,t3.mtuno from'+
                   ' (select '+inttostr(aMtuid)+' mtuid,'+inttostr(aContentCode)+' contentcode from dual) t1'+
                   ' inner join mtu_alarm_content t2 on t1.contentcode=t2.alarmcontentcode'+
                   ' inner join mtu_info t3 on t1.mtuid=t3.mtuid';
    Sql.Text := lSqlstr;
    ExecSQL;
//    lSqlstr := 'Merge into alarm_data_gather a'+
//               ' USING (select t1.mtuid,t1.contentcode,t2.alarmcontentname,t3.mtuno from'+
//                        ' (select '+inttostr(aMtuid)+' mtuid,'+inttostr(aContentCode)+' contentcode from dual) t1'+
//                        ' inner join mtu_alarm_content t2 on t1.contentcode=t2.alarmcontentcode'+
//                        ' inner join mtu_info t3 on t1.mtuid=t3.mtuid) b'+
//               ' On (a.mtuid=b.mtuid and a.contentcode=b.contentcode)'+
//               ' when matched then update set status='+inttostr(aStatus)+',updatetime=sysdate'+
//               ' when not matched then insert values (mtu_alarmdatacollectid.nextval,'+
//               ' b.mtuid,b.contentcode,'+inttostr(aStatus)+',sysdate,b.alarmcontentname,b.mtuno)';
//    Sql.Text := lSqlstr;
//    ExecSQL;
  end;
end;
// 0: CLEAR  1���澯
function TParse_SendAlarm.JudgeIsAlarm(ParamValue, AlarmValue,
  RemoveValue: String): integer;
var
  sqlstr :string;
begin
  try
    result :=0;
    sqlstr :='select 1 from dual where ';
    AlarmValue :=StringReplace(AlarmValue, '@Value',ParamValue, [rfReplaceAll, rfIgnoreCase]);
    RemoveValue :=StringReplace(RemoveValue, '@Value',ParamValue, [rfReplaceAll, rfIgnoreCase]);
    with FQueryFree do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr+AlarmValue);
      Open;
      if IsEmpty then
      begin
        Close;
        SQL.Clear;
        SQL.Add(sqlstr+RemoveValue);
        Open;
        if not IsEmpty then
          result :=0;
      end
      else
        result :=1;
      Close;
    end;
  except
    on e: exception do
    begin
      FLog.Write(sqlstr+AlarmValue,1);
      FLog.Write(sqlstr+RemoveValue,1);
    end;
  end;
end;

function TParse_SendAlarm.ParseBaseData(cityid: integer; MsgData: TIdBytes;
  var aTaskid: integer):integer;
var
  Mtu :TMtuBase;
begin
  result := 0;
  FSQLList.Clear;
//  Mtu := nil;
  try
    //�����ֽ�Ϊ��Ϣ���
    case MsgData[4] of
      MTU_REPORT_SELF              :begin
                                      Mtu := TMtuSelf.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_REPORT_CCH               :begin
                                      Mtu := TMtuCch.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_TEST_CALL_RESULT         : Mtu := TMtuCall.create;
      MTU_TEST_TCH_RESULT          : Mtu := TMtuTch.create;
      MTU_TEST_HANDOVER_RESULT     : Mtu := TMtuHandOver.create;
      MTU_TEST_MOS_RESULT          : Mtu := TMtuMos.create;
      MTU_TEST_VOICE_RESULT        : Mtu := TMtuVoice.create;
      MTU_TEST_CALLEE_DELAY_RESULT : Mtu := TMtuCallEEDelay.create;
      MTU_REPORT_WLAN              :begin
                                      Mtu := TMtuWLan.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_TEST_WLAN_SPEED_RESULT   : Mtu := TMtuWLanSpeed.create;
      MTU_TEST_WLAN_DELAY_RESULT   : Mtu := TMtuWLanDelay.create;
      MTU_REPORT_STATUS            :begin
                                      Mtu := TMtuStatus.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_GET_STATUS_RESULT        :begin//����
                                      Mtu := TMtuGetStatus.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_REPORT_WLAN_ERROR        : begin
                                       Mtu := TMtuWLanError.create;
                                       Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                     end;
      MTU_REPORT_WLAN_OK           : Mtu := TMtuWLanOK.create;
      MTU_GET_CALLEE_RESULT        :begin//����
                                      Mtu := TMtuGetCallEE.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_COMMAND_ACK              : Mtu := TMtuCmdAck.create;
      MTU_NOWLAN_REPORT            :begin
                                      Mtu := TMtuNoLan.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_NOCCH_REPORT             :begin
                                      Mtu := TMtuNoCCH.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_MOS_VIRTUAL              :begin
                                      Mtu := TMtuMOSDone.create
                                    end;
      //20090612
      MTU_PPP_TEST_RESULT          :begin
                                      Mtu  := TMtuPPPTest.create;
                                    end;
      MTU_REPORT_SIGNALSTREAM_OFF  :begin
                                      Mtu  := TMtuCDMAREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_REPORT_SIGNALSTREAM_ON   :begin
                                      Mtu  := TMtuCDMAREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid');
                                    end;
      MTU_REPORT_NEIGHBOR_OFF      :begin
                                      Mtu  := TMtuNEIGHBORREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_NEIGHBOR_ON       :begin
                                      Mtu  := TMtuNEIGHBORREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_SWITCH_OFF        :begin
                                      Mtu  := TMtuSWITCHREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_SWITCH_ON         :begin
                                      Mtu  := TMtuSWITCHREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_FINGER_OFF        :begin
                                      Mtu  := TMtuFINGERREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_FINGER_ON         :begin
                                      Mtu  := TMtuFINGERREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_ACTIVE_OFF        :begin
                                      Mtu  := TMtuACTIVEREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_ACTIVE_ON         :begin
                                      Mtu  := TMtuACTIVEREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_SECOND_OFF        :begin
                                      Mtu  := TMtuSECONDREPORT_OFF.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_REPORT_SECOND_ON         :begin
                                      Mtu  := TMtuSECONDREPORT_ON.create;
                                      Mtu.TaskId:= GetSequence(FQueryFree,'mtu_taskid')
                                    end;
      MTU_TEST_CALL_CENTER_RESULT  :begin
                                      Mtu  := TMtuCallCenter.create;
                                    end;
      MTU_LOCALANALYSE             :begin
                                      Mtu  := TMtuLocalAnalyse.create;
                                    end
      else exit;
    end;
    try
      Mtu.Cityid := cityid;
      Mtu.MtuList:= FMTULIst;
      if Mtu.DecodeMsgSQL(MsgData,FSQLList) then
      begin
        aTaskid := Mtu.TaskId;
        if FSQLList.Count >0 then
        begin
          ExecSQLList(FQueryFree,FSQLList);
          if MsgData[4]=MTU_COMMAND_ACK then //������Ӧ
            result := 2
          else
            result := 1;                     //��������
        end
        else
          result := 3;                       //��������
      end;
    finally
      if Mtu <> nil then
        Mtu.Free;
    end;
  finally
  end;
end;

procedure TParse_SendAlarm.SaveAlarmResult(aAlarmid, aCityid, aTaskid,
  aAlarmcount, aContentCode: integer);
var
  lSqlstr: string;
begin
  lSqlstr:= 'insert into MTU_ALARMRESULT a'+
            ' select mts_normal.nextval,'+inttostr(aAlarmid)+',b.* from mtu_testresult_online b'+
            ' where b.cityid='+inttostr(aCityid)+' and b.taskid='+inttostr(aTaskid)+
            ' and exists (select 1 from mtu_alarm_content c where b.paramid=c.paramid and c.alarmcontentcode='+inttostr(aContentCode)+')';
  ExecMySQL(FQueryFree,lSqlstr);
  lSqlstr:= 'delete from MTU_ALARMRESULT a where'+
            ' exists (select 1 from'+
            ' (select t.*,row_number() over (order by id desc) rn from MTU_ALARMRESULT t'+
            ' where cityid='+inttostr(aCityid)+' and alarmid='+inttostr(aAlarmid)+') b'+
            ' where a.id=b.id and b.rn>'+inttostr(aAlarmcount)+')';
  ExecMySQL(FQueryFree,lSqlstr);
end;

function TParse_SendAlarm.TaskResend(aTaskid, aCityid: integer): boolean;
var
  lSqlstr: string;
  lTaskid: integer;
begin
  result:= false;
  lTaskid:= GetSequence(FQueryFree,'mtu_taskid');
  lSqlstr:='insert into mtu_testtask_online'+
           ' (taskid, cityid, mtuid, comid, status, testresult,'+
           ' asktime, rectime, userid, sendtime, tasklevel, modelid) '+
           ' select '+inttostr(lTaskid)+',cityid, mtuid, comid, status, testresult,'+
           ' sysdate,null,-1,null,2,null from mtu_testtask_online'+
           ' where taskid='+inttostr(aTaskid)+' and cityid='+inttostr(aCityid);
  ExecMySQL(FQueryFree,lSqlstr);
  lSqlstr:= 'insert into mtu_testtaskparam_online'+
            ' (taskid, paramid, paramvalue)'+
            ' select '+inttostr(lTaskid)+',paramid,paramvalue'+
            ' from mtu_testtaskparam_online where taskid='+inttostr(aTaskid);
  ExecMySQL(FQueryFree,lSqlstr);
  result:= true;
end;

procedure TParse_SendAlarm.TaskSendCallCenter(aMtuid, aCityid: integer);
var
  lSqlstr: string;
  lTaskid: integer;
begin
  lTaskid:= GetSequence(FQueryFree,'mtu_taskid');
  lSqlstr:= 'insert into mtu_testtask_online'+
            ' (taskid, cityid, mtuid, comid, status, testresult, asktime, sendtime, rectime, tasklevel, userid, modelid)'+
            ' values'+
            ' ('+inttostr(lTaskid)+', '+inttostr(aCityid)+', '+inttostr(aMtuid)+','+
            ' 12, 0, null, sysdate, null, null, 2, -1, null)';
  ExecMySQL(FQueryFree,lSqlstr);
  lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
            ' ('+inttostr(lTaskid)+', 1, (select decode(mtuno,null,''00000000'',mtuno) from mtu_info  where mtuid='+inttostr(aMtuid)+'))';
  ExecMySQL(FQueryFree,lSqlstr);
  lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
            ' ('+inttostr(lTaskid)+', 7, (select decode(call,null,''00000000'',call) from mtu_info  where mtuid='+inttostr(aMtuid)+'))';
  ExecMySQL(FQueryFree,lSqlstr);
  lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
            ' ('+inttostr(lTaskid)+', 8, 90)';
  ExecMySQL(FQueryFree,lSqlstr);
  lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
            ' ('+inttostr(lTaskid)+', 9, 1)';
  ExecMySQL(FQueryFree,lSqlstr);
  lSqlstr:= 'insert into mtu_testtaskparam_online (taskid, paramid, paramvalue) values'+
            ' ('+inttostr(lTaskid)+', 10, 1)';
  ExecMySQL(FQueryFree,lSqlstr);
end;

end.
