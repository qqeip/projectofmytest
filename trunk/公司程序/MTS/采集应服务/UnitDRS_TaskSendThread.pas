{ֱ��վ�����������߳�}
unit UnitDRS_TaskSendThread;

interface
uses
  Classes, ADODB, DB, SysUtils, Ut_BaseThread, IniFiles, UnitRepeaterInfo, UntSMSClass;

const
  WD_THREADFUNCTION_NAME = 'ֱ��վ�������߳�';

type
  TDRS_TaskSendThread = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn :TAdoConnection;
    FQuery :TAdoQuery;
    FQueryFree :TAdoQuery;
    FSMSClass: TSMSClass;            //������

    function GetTestEnCode(aCityid,aTaskID,aCommandID,aDRSID :integer;var EnCode:string; var aDestCall: string):integer;
    function GetParamValue(FDataSet:TDataSet;ParamId :integer):String;
    function GetBinParamValue(FDataSet:TDataSet;ParamId :integer):String;
    function AddDRSInfoList(aKey: string; aRepBase: TRepBase): integer;
    procedure DelOutTimeDRSInfoList(aNow: TDateTime);
  protected
    procedure DoExecute; override;
  public
    constructor Create(ConStr:String);
    destructor Destroy; override;
  end;

implementation

uses UnitThreadCommon, Ut_Global, UnitDRS_Math;

{ TDRS_TaskSendThread }

function TDRS_TaskSendThread.AddDRSInfoList(aKey: string; aRepBase: TRepBase): integer;
var
  lIndex: integer;
begin
  FDRSInfoList.BeginUpdate;
  lIndex:= FDRSInfoList.IndexOf(aKey);
  if lIndex=-1 then
    FDRSInfoList.AddObject(aKey,aRepBase);
  FDRSInfoList.EndUpdate;
  result:= lIndex;
end;

constructor TDRS_TaskSendThread.Create(ConStr: String);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := true;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection :=FConn;
  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection :=FConn;

  //���Žӿ�
  FSMSClass:= TSMSClass.Create(FLog);
end;

procedure TDRS_TaskSendThread.DelOutTimeDRSInfoList(aNow: TDateTime);
var
  I: Integer;
  lDuring: TDatetime;
  lHour, lMin, lSec, lMSec: word;
begin
  for I := FDRSInfoList.Count - 1 downto 0 do
  begin
    lDuring:=  aNow- TRepBase(FDRSInfoList.Objects[i]).CreateTime;

    DecodeTime(lDuring, lHour, lMin, lSec, lMSec);

    FLog.Write('lHour��'+inttostr(lHour),3);
    FLog.Write('lMin��'+inttostr(lMin),3);
    FLog.Write('lSec��'+inttostr(lSec),3);

    if WD_OUTTIME_SET*60 <= lHour*60*60+lMin*60 then
    begin
      FDRSInfoList.Objects[i].Free;
      FDRSInfoList.Delete(i);
    end;
  end;
end;

destructor TDRS_TaskSendThread.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;

  //�ͷŶ��Žӿ�
  FSMSClass.FreeSMS;
  FSMSClass.Free;
  inherited destroy;
end;

procedure TDRS_TaskSendThread.DoExecute;
var
  lSqlstr: string;
  EnCode: string;
  DestCall: string;
  lRecordcount: integer;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write(WD_THREADFUNCTION_NAME+' �޷��������ݿ�!',1);
    Exit;
  end;
  if not FSMSClass.GetActiveSMC then
  begin
    FLog.Write('������Žӿڷ�����ʧ�ܣ�',2);
    exit;
  end;
  try
    try
      while True do
      begin
        FCounterDatetime:= GetSysDateTime(FQueryFree);
        //������Ӧ�ı�״̬
        //ɾ�����豸�Ĳ�������,�����豸��������Ϣ�ǿյģ�
        lSqlstr:= 'delete from drs_testtask_online a'+
                  ' where not exists (select 1 from (select d.id cityid,a.drsid from drs_info a'+
                                                     ' inner join area_info b on a.suburb=b.id and b.layer=3'+
                                                     ' inner join area_info c on b.top_id=c.id and c.layer=2'+
                                                     ' inner join area_info d on c.top_id=d.id and d.layer=1) b'+
                                      ' where a.cityid=b.cityid and a.drsid=b.drsid)';
        ExecMySQL(FQueryFree,lSqlstr);
        //���¡�δ�������񡱵�ֱ��վ��������Ϊ"����"״̬
        lSqlstr:= 'update drs_testtask_online a'+
                  ' set a.status=5,isprocess='+inttostr(WD_TABLESTATUS_HASTREATED)+
                  ' where a.status=0'+
                  '       and exists (select 1 from drs_statuslist b'+
                  '             where a.drsid=b.drsid and b.drsstatus=5)';
        ExecMySQL(FQueryFree,lSqlstr);
        //ɾ���ڴ��г�ʱ�Ĵ�����
        DelOutTimeDRSInfoList(GetSysDateTime(FQueryFree));
        //���¡�ִ���С����񳬹�������Ϊ������ʱ
        lSqlstr:= 'update drs_testtask_online a'+
                  ' set a.status=4,isprocess='+inttostr(WD_TABLESTATUS_HASTREATED)+
                  ' where a.status=1 and sendtime<= sysdate- '+inttostr(WD_OUTTIME_SET)+'/60/24';
        ExecMySQL(FQueryFree,lSqlstr);
        //�����ֶ���ϵͳ�ٲ�
        lSqlstr:= 'update drs_testtask_online a set a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+
                  ' and tasklevel != 3';
        ExecMySQL(FQueryFree,lSqlstr);
        //����ǰN����¼��״̬���ȴ�ִ��(�����������)
        lSqlstr:= 'update drs_testtask_online a set a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+
                  ' and rownum<=100';
        ExecMySQL(FQueryFree,lSqlstr);
        //����֮ǰ<WD_TABLESTATUS_WAITFOR>��status�������0
        with FQuery do
        begin
          lSqlstr:= 'select * from drs_testtask_online t'+
                    ' where isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                    ' order by tasklevel,taskid';
          OpenDataSet(FQuery,lSqlstr);
          //��ǰ��¼��
          lRecordcount:= recordcount;
          first;
          while not eof do
          begin
            try
              if GetTestEnCode(FieldByName('CITYID').AsInteger,
                               FieldByName('TASKID').AsInteger,
                               FieldByName('COMID').AsInteger,
                               FieldByName('DRSID').AsInteger,
                               EnCode, DestCall)=1 then
              begin
                FLog.Write('���룺'+EnCode,3);
                FSMSClass.FeeCall:= DestCall;
                FSMSClass.DestCall:= DestCall;
                if not FSMSClass.GetActiveSMC then
                  raise exception.Create('������Žӿ���ʧ�ܣ�');
                if not FSMSClass.SubmitSM(EnCode) then
                  raise exception.Create('���ͱ���ʧ��');
              end
              else
                raise exception.Create('�������ʧ��');
            except
              on e: Exception do
              begin
                //����ʧ�ܱ�ʶ
                edit;
                Fieldbyname('ISPROCESS').AsInteger := WD_TABLESTATUS_EXCEPTION;
                post;
                FLog.Write(WD_THREADFUNCTION_NAME+'ִ��ʧ��'+#13+
                           ' ������ʾ��'+E.Message+#13+
                           ' TASKID=<'+FieldByname('TASKID').AsString+'>',2);
              end;
            end;
            Sleep(60);   //������֤������Ҫ60mS
            next;
          end;
        end;//N��ѭ������
        //��������������BCD�������״̬Ϊ�ѷ���
        lSqlstr:= 'update drs_testtask_online a'+
                  ' set a.status= 1,a.sendtime=sysdate,a.isprocess='+inttostr(WD_TABLESTATUS_TREATING)+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR);
        ExecMySQL(FQueryFree,lSqlstr);

        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('����'+inttostr(lRecordcount)+'�����񻨷�'+FormatDatetime('HH:MM:SS��',FCurrentDateTime-FCounterDatetime),3);
        if lRecordcount=0 then break;
        //�ֶ��˳�
        if self.IsStop then
          break;
      end;
    except
      on e: Exception do
      begin
        FLog.Write(e.Message,2);
        FLog.Write(WD_THREADFUNCTION_NAME+'   ִ��ʧ��',2);
      end;
    end;
  finally
    FConn.Connected := false;
  end;
end;

function TDRS_TaskSendThread.GetBinParamValue(FDataSet: TDataSet;
  ParamId: integer): String;
begin
  result := '';
  if FDataSet.Active then
    with FDataSet do
    begin
      if Locate('PARAMID',ParamId,[]) then
        result := FieldByName('PARAMVALUE').AsString;
    end;
end;

function TDRS_TaskSendThread.GetParamValue(FDataSet: TDataSet;
  ParamId: integer): String;
begin
  result := '';
  if FDataSet.Active then
    with FDataSet do
    begin
      if Locate('PARAMID',ParamId,[]) then
        result := LeftPad(FieldByName('PARAMVALUE').AsString,2,'0');
    end;
end;
//0 δִ�� 1 ���� -1 �쳣
function TDRS_TaskSendThread.GetTestEnCode(aCityid,aTaskID,aCommandID,aDRSID: integer;
  var EnCode: string; var aDestCall: string): integer;
var
  lSqlstr: string;
  lRepBase: TRepBase;
begin
  result:= 0;
  lRepBase:= nil;
  try
    try
      lSqlstr:= 'select * from drs_testparam_online where taskid ='+inttostr(aTaskID);
      OpenDataSet(FQueryFree,lSqlstr);
      if FQueryFree.RecordCount>0 then
      begin
        //���²�����ASCII �� INTEGER
        case aCommandID of
          WD_REP_PARAMQUERY_ASK:
          begin
            lRepBase:= TRepParamQuery.create(true);
            TRepParamQuery(lRepBase).Taskid:= aTaskID;
            TRepParamQuery(lRepBase).Cityid:= aCityid;
            TRepParamQuery(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepParamQuery(lRepBase).DRSID:= aDRSID;
            TRepParamQuery(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepParamQuery(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepParamQuery(lRepBase).AskTag:= GetParamValue(FQueryFree,2);
            TRepParamQuery(lRepBase).DataLength:= '0';
          end;
          WD_REP_PARAMDRSQUERY_ASK:
          begin
            lRepBase:= TRepDRSParamQuery.create(true);
            TRepDRSParamQuery(lRepBase).Taskid:= aTaskID;
            TRepDRSParamQuery(lRepBase).Cityid:= aCityid;
            TRepDRSParamQuery(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepDRSParamQuery(lRepBase).DRSID:= aDRSID;
            TRepDRSParamQuery(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepDRSParamQuery(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepDRSParamQuery(lRepBase).AskTag:= GetParamValue(FQueryFree,2);
            TRepDRSParamQuery(lRepBase).DataLength:= '0';
          end;
          WD_REP_PARAMWDPQUERY_ASK:
          begin
            lRepBase:= TRepWDPParamQuery.create(true);
            TRepDRSParamQuery(lRepBase).Taskid:= aTaskID;
            TRepDRSParamQuery(lRepBase).Cityid:= aCityid;
            TRepDRSParamQuery(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepDRSParamQuery(lRepBase).DRSID:= aDRSID;
            TRepDRSParamQuery(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepDRSParamQuery(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepDRSParamQuery(lRepBase).AskTag:= GetParamValue(FQueryFree,2);
            TRepDRSParamQuery(lRepBase).DataLength:= '0';
          end;
          WD_REP_PARAMDRSNOSET_ASK:
          begin
            lRepBase:= TRepDRSNOParamSet.create(true);
            TRepDRSNOParamSet(lRepBase).Taskid:= aTaskID;
            TRepDRSNOParamSet(lRepBase).Cityid:= aCityid;
            TRepDRSNOParamSet(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepDRSNOParamSet(lRepBase).DRSID:= aDRSID;

            TRepDRSNOParamSet(lRepBase).DRSNO:= GetParamValue(FQueryFree,85);
            TRepDRSNOParamSet(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,86);
            TRepDRSNOParamSet(lRepBase).AskTag:= GetParamValue(FQueryFree,2);
            TRepDRSNOParamSet(lRepBase).DataLength:= '3';
          end;
          WD_REP_PARAMRCOMSET_ASK:
          begin
            lRepBase:= TRepRCOMParamSet.create(true);
            TRepRCOMParamSet(lRepBase).Taskid:= aTaskID;
            TRepRCOMParamSet(lRepBase).Cityid:= aCityid;
            TRepRCOMParamSet(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepRCOMParamSet(lRepBase).DRSID:= aDRSID;
            TRepRCOMParamSet(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepRCOMParamSet(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepRCOMParamSet(lRepBase).AskTag:= GetParamValue(FQueryFree,2);

            TRepRCOMParamSet(lRepBase).ParamQueryCall:= GetParamValue(FQueryFree,4);
            TRepRCOMParamSet(lRepBase).ParamAlarmCall:= GetParamValue(FQueryFree,5);
            TRepRCOMParamSet(lRepBase).ParamComtype:= GetParamValue(FQueryFree,6);
            TRepRCOMParamSet(lRepBase).DataLength:= '16';
          end;
          WD_REP_PARAMRAUTOALARMSET_ASK:
          begin
            lRepBase:= TRepAUTOALARMParamSet.create(true);
            TRepAUTOALARMParamSet(lRepBase).Taskid:= aTaskID;
            TRepAUTOALARMParamSet(lRepBase).Cityid:= aCityid;
            TRepAUTOALARMParamSet(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepAUTOALARMParamSet(lRepBase).DRSID:= aDRSID;
            TRepAUTOALARMParamSet(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepAUTOALARMParamSet(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepAUTOALARMParamSet(lRepBase).AskTag:= GetParamValue(FQueryFree,2);

            TRepAUTOALARMParamSet(lRepBase).Param_17:= GetBinParamValue(FQueryFree,7);
            TRepAUTOALARMParamSet(lRepBase).Param_16:= GetBinParamValue(FQueryFree,8);
            TRepAUTOALARMParamSet(lRepBase).Param_15:= GetBinParamValue(FQueryFree,9);
            TRepAUTOALARMParamSet(lRepBase).Param_14:= GetBinParamValue(FQueryFree,10);
            TRepAUTOALARMParamSet(lRepBase).Param_13:= GetBinParamValue(FQueryFree,11);
            TRepAUTOALARMParamSet(lRepBase).Param_12:= GetBinParamValue(FQueryFree,12);
            TRepAUTOALARMParamSet(lRepBase).Param_11:= GetBinParamValue(FQueryFree,13);
            TRepAUTOALARMParamSet(lRepBase).Param_10:= GetBinParamValue(FQueryFree,14);

            TRepAUTOALARMParamSet(lRepBase).Param_27:= GetBinParamValue(FQueryFree,15);
            TRepAUTOALARMParamSet(lRepBase).Param_26:= GetBinParamValue(FQueryFree,16);
            TRepAUTOALARMParamSet(lRepBase).Param_25:= GetBinParamValue(FQueryFree,17);
            TRepAUTOALARMParamSet(lRepBase).Param_24:= GetBinParamValue(FQueryFree,18);
            TRepAUTOALARMParamSet(lRepBase).Param_23:= GetBinParamValue(FQueryFree,19);
            TRepAUTOALARMParamSet(lRepBase).Param_22:= GetBinParamValue(FQueryFree,20);
            TRepAUTOALARMParamSet(lRepBase).Param_21:= GetBinParamValue(FQueryFree,21);
            TRepAUTOALARMParamSet(lRepBase).Param_20:= GetBinParamValue(FQueryFree,22);

            TRepAUTOALARMParamSet(lRepBase).Param_37:= '0';
            TRepAUTOALARMParamSet(lRepBase).Param_36:= '0';
            TRepAUTOALARMParamSet(lRepBase).Param_35:= '0';
            TRepAUTOALARMParamSet(lRepBase).Param_34:= '0';
            TRepAUTOALARMParamSet(lRepBase).Param_33:= '0';
            TRepAUTOALARMParamSet(lRepBase).Param_32:= '0';
            TRepAUTOALARMParamSet(lRepBase).Param_31:= '0';
            TRepAUTOALARMParamSet(lRepBase).Param_30:= GetBinParamValue(FQueryFree,23);

            TRepAUTOALARMParamSet(lRepBase).DataLength:= '4';
          end;
          WD_REP_PARAMRESHOLDSET_ASK:
          begin
            lRepBase:= TRepESHOLDParamSet.create(true);
            TRepESHOLDParamSet(lRepBase).Taskid:= aTaskID;
            TRepESHOLDParamSet(lRepBase).Cityid:= aCityid;
            TRepESHOLDParamSet(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepESHOLDParamSet(lRepBase).DRSID:= aDRSID;
            TRepESHOLDParamSet(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepESHOLDParamSet(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepESHOLDParamSet(lRepBase).AskTag:= GetParamValue(FQueryFree,2);

            TRepESHOLDParamSet(lRepBase).Param1:= GetParamValue(FQueryFree,27);
            TRepESHOLDParamSet(lRepBase).Param2:= GetParamValue(FQueryFree,76);
            TRepESHOLDParamSet(lRepBase).DataLength:= '2';
          end;
          WD_REP_PARAMSWITCHSET_ASK:
          begin
            lRepBase:= TRepSWITCHParamSet.create(true);
            TRepSWITCHParamSet(lRepBase).Taskid:= aTaskID;
            TRepSWITCHParamSet(lRepBase).Cityid:= aCityid;
            TRepSWITCHParamSet(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepSWITCHParamSet(lRepBase).DRSID:= aDRSID;
            TRepSWITCHParamSet(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepSWITCHParamSet(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepSWITCHParamSet(lRepBase).AskTag:= GetParamValue(FQueryFree,2);

            TRepSWITCHParamSet(lRepBase).Param1:= GetParamValue(FQueryFree,56);
            TRepSWITCHParamSet(lRepBase).Param2:= GetParamValue(FQueryFree,55);
            TRepSWITCHParamSet(lRepBase).DataLength:= '2';
          end;
          WD_REP_PARAMDAMPSET_ASK:
          begin
            lRepBase:= TRepDAMPParamSet.create(true);
            TRepDAMPParamSet(lRepBase).Taskid:= aTaskID;
            TRepDAMPParamSet(lRepBase).Cityid:= aCityid;
            TRepDAMPParamSet(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepDAMPParamSet(lRepBase).DRSID:= aDRSID;
            TRepDAMPParamSet(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepDAMPParamSet(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepDAMPParamSet(lRepBase).AskTag:= GetParamValue(FQueryFree,2);

            TRepDAMPParamSet(lRepBase).Param1:= GetParamValue(FQueryFree,54);
            TRepDAMPParamSet(lRepBase).Param2:= GetParamValue(FQueryFree,53);
            TRepDAMPParamSet(lRepBase).DataLength:= '2';
          end;
          WD_REP_PARAMCHANNELSET_ASK:
          begin
            lRepBase:= TRepCHANNELParamSet.create(true);
            TRepCHANNELParamSet(lRepBase).Taskid:= aTaskID;
            TRepCHANNELParamSet(lRepBase).Cityid:= aCityid;
            TRepCHANNELParamSet(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepCHANNELParamSet(lRepBase).DRSID:= aDRSID;
            TRepCHANNELParamSet(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepCHANNELParamSet(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepCHANNELParamSet(lRepBase).AskTag:= GetParamValue(FQueryFree,2);

            TRepCHANNELParamSet(lRepBase).Param1:= GetParamValue(FQueryFree,77);
            TRepCHANNELParamSet(lRepBase).Param2:= GetParamValue(FQueryFree,78);
            TRepCHANNELParamSet(lRepBase).DataLength:= '2';
          end;
          WD_REP_PARAMWDPFSJSET_ASK:
          begin
            lRepBase:= TRepWDPFSJParamSet.create(true);
            TRepWDPFSJParamSet(lRepBase).Taskid:= aTaskID;
            TRepWDPFSJParamSet(lRepBase).Cityid:= aCityid;
            TRepWDPFSJParamSet(lRepBase).DeviceType:= GetParamValue(FQueryFree,1);
            TRepWDPFSJParamSet(lRepBase).DRSID:= aDRSID;
            TRepWDPFSJParamSet(lRepBase).DRSNO:= GetParamValue(FQueryFree,24);
            TRepWDPFSJParamSet(lRepBase).R_Deviceid:= GetParamValue(FQueryFree,25);
            TRepWDPFSJParamSet(lRepBase).AskTag:= GetParamValue(FQueryFree,2);

            TRepWDPFSJParamSet(lRepBase).Param1:= GetBinParamValue(FQueryFree,58);
            TRepWDPFSJParamSet(lRepBase).Param2:= GetBinParamValue(FQueryFree,59);
            TRepWDPFSJParamSet(lRepBase).Param3:= GetBinParamValue(FQueryFree,60);
            TRepWDPFSJParamSet(lRepBase).Param4:= GetBinParamValue(FQueryFree,61);
            TRepWDPFSJParamSet(lRepBase).Param6:= GetBinParamValue(FQueryFree,62);
            TRepWDPFSJParamSet(lRepBase).Param8:= GetBinParamValue(FQueryFree,63);
            TRepWDPFSJParamSet(lRepBase).Param9:= GetBinParamValue(FQueryFree,64);
            TRepWDPFSJParamSet(lRepBase).Param10:= GetBinParamValue(FQueryFree,65);
            TRepWDPFSJParamSet(lRepBase).Param11:= GetBinParamValue(FQueryFree,66);
            TRepWDPFSJParamSet(lRepBase).Param12:= GetBinParamValue(FQueryFree,67);
            TRepWDPFSJParamSet(lRepBase).Param13:= GetBinParamValue(FQueryFree,68);
            TRepWDPFSJParamSet(lRepBase).Param14:= GetBinParamValue(FQueryFree,69);
            TRepWDPFSJParamSet(lRepBase).Param15:= GetBinParamValue(FQueryFree,70);
            TRepWDPFSJParamSet(lRepBase).Param16:= GetBinParamValue(FQueryFree,71);
            TRepWDPFSJParamSet(lRepBase).Param17:= GetBinParamValue(FQueryFree,79);
            TRepWDPFSJParamSet(lRepBase).DataLength:= '17';
          end;
        end;
        if (lRepBase <> nil) and (lRepBase.GetTestEnCode(EnCode)) then
        begin
          TRepParamQuery(lRepBase).DestCall:= GetDRSCall(FQueryFree,aDRSID);
          TRepParamQuery(lRepBase).CreateTime:= GetSysDateTime(FQueryFree);
          aDestCall:= TRepParamQuery(lRepBase).DestCall;
          //��ӵ��������б���
          AddDRSInfoList(lRepBase.ReturnFlag,lRepBase);

          Log.Write('����DRS  '+ lRepBase.ReturnFlag,1);
          result:= 1;
        end;
      end;
    except
      result:= -1;
    end;
  finally

  end;
end;

end.
