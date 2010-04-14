{��վ���Խ�������߳�}
unit UnitDRS_ResultParasThread;

interface
uses
  Classes, ADODB, DB, SysUtils, Ut_BaseThread, UnitRepeaterInfo;

const
  WD_THREADFUNCTION_NAME = 'ֱ��վ��������߳�';
type
  TDRS_ResultParasThread = class(TMyThread)
  private
    FCounterDatetime: TDateTime;
    FCurrentDateTime: TDateTime;
    FConn: TAdoConnection;
    FQuery: TAdoQuery;
    FQueryFree: TAdoQuery;
    FThreadFlag: integer;

    FMTUList :TStringList;
    FSQLList :TStringList;
    FSQLList_Index: integer;

    function ParseBaseData(MsgData: string):integer;
    procedure ExecSQLList(aAdoQuery: TAdoQuery; aSqlList: TStringList);
    function GetDRSInfoList(aKey: string): TRepBase;
    function GetDRSInfoObject(aDrsNo, aR_Deviceid: string; aMsgid: integer): TRepBase;
  protected
    procedure DoExecute; override;
  public
    constructor Create(ConStr:String; aThreadFlag: integer);
    destructor Destroy; override;
  end;

implementation

uses Ut_Global, UnitThreadCommon, UnitDRS_Math;

{ TDRS_ResultParasThread }

constructor TDRS_ResultParasThread.Create(ConStr: String; aThreadFlag: integer);
begin
  inherited create;
  FConn :=TAdoConnection.Create(nil);
  FConn.ConnectionString := ConStr;
  FConn.LoginPrompt := false;
  FConn.KeepConnection := true;

  FQuery:= TAdoQuery.Create(nil);
  FQuery.Connection:= FConn;
  FQueryFree:= TAdoQuery.Create(nil);
  FQueryFree.Connection:= FConn;

  FThreadFlag:= aThreadFlag;

  FMTUList:= TStringList.Create;
  FSQLList:= TStringList.Create;
end;

destructor TDRS_ResultParasThread.Destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FConn.Close;
  FConn.Free;

  FMTUList.Free;
  FSQLList.Free;
  inherited;
end;

procedure TDRS_ResultParasThread.DoExecute;
var
  lSqlstr: string;
  lRecordcount: integer;
  lResult: integer;
begin
  inherited;
  if not FConn.Connected then
  try
    FConn.Connected := true;
  except
    FLog.Write(WD_THREADFUNCTION_NAME+' ��'+inttostr(FThreadFlag)+'ִ�ж���'+' �޷��������ݿ�!',1);
    Exit;
  end;
  try
    try
      while True do
      begin
        //����ǰN����¼���ȴ�ִ��
        FCounterDatetime:= GetSysDateTime(FQueryFree);
        lSqlstr:= 'update drs_testresult_base a'+
                  ' set a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+','+
                  ' a.threadflag='+inttostr(FThreadFlag)+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_NORMAL)+
                  ' and rownum<=200';
        ExecMySQL(FQueryFree,lSqlstr);
        //�ж�ֱ��վ�Ƿ����
        with FQuery do
        begin
          close;
          lSqlstr:= 'select * from drs_testresult_base'+
                    ' where isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                    ' and threadflag='+inttostr(FThreadFlag);
          sql.Text := lSqlstr;
          open;
          //��ǰ��¼��
          lRecordcount:= recordcount;
          first;
          while not eof do
          begin
            try
              //��������
              lResult:= ParseBaseData(FieldByName('testvalue').AsString);
              case lResult of
                -1: raise exception.Create('�������ʧ��');
                0: raise exception.Create('�������δִ��');
                1: begin end;
                2: begin end;
              end;
            except
              on e: Exception do
              begin
                //����ʧ�ܱ�ʶ
                edit;
                Fieldbyname('ISPROCESS').AsInteger := WD_TABLESTATUS_EXCEPTION;
                post;
                FLog.Write(WD_THREADFUNCTION_NAME+'ִ��ʧ��'+#13+
                           ' ������ʾ��'+E.Message+#13+
                           ' BASEID=<'+FieldByname('BASEID').AsString+'>',2);
                if FSQLList.Count> FSQLList_Index then
                  FLog.Write(FSQLList.Strings[FSQLList_Index],1);
              end;
            end;
            //Sleep(30);   //������֤������Ҫ30mS
            next;
          end;
        end;
        //ɾ���Ѿ�����Ľ��ԭʼ�����ʷ��
        lSqlstr:= 'insert into drs_testresult_base_h'+
                  ' select * from drs_testresult_base a'+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' and a.threadflag='+inttostr(FThreadFlag);
        ExecMySQL(FQueryFree,lSqlstr);
        lSqlstr:= 'delete from drs_testresult_base a'+
                  ' where a.isprocess='+inttostr(WD_TABLESTATUS_WAITFOR)+
                  ' and a.threadflag='+inttostr(FThreadFlag);
        ExecMySQL(FQueryFree,lSqlstr);
        FCurrentDateTime:= GetSysDateTime(FQueryFree);
        FLog.Write('����'+inttostr(lRecordcount)+'���������'+FormatDatetime('HH:MM:SS��',FCurrentDateTime-FCounterDatetime),3);
        if lRecordcount=0 then break;
        //�ֶ��˳�
        if self.IsStop then
          break;
      end;
    except
//      FLog.Write(WD_THREADFUNCTION_NAME+'   ִ��ʧ��',2);
//      FLog.Write(WD_THREADFUNCTION_NAME+'   ִ��ʧ��'+lSqlstr,2);
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

procedure TDRS_ResultParasThread.ExecSQLList(aAdoQuery: TAdoQuery;
  aSqlList: TStringList);
var
  i: integer;
begin
  for i:= 0 to aSqlList.Count - 1 do
  with aAdoQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(aSqlList.Strings[i]);
    //��ǰSQL�б������
    FSQLList_Index:= i;
    ExecSQL;
    Close;
  end;
end;
function TDRS_ResultParasThread.GetDRSInfoList(aKey: string): TRepBase;
var
  lIndex: integer;
begin
  FDRSInfoList.BeginUpdate;
  result:= nil;
  lIndex:= FDRSInfoList.IndexOf(aKey);
  if lIndex> -1 then
  begin
    result:= TRepBase(FDRSInfoList.Objects[lIndex]);
    FDRSInfoList.Delete(lIndex);
  end;
  FDRSInfoList.EndUpdate;
end;

function TDRS_ResultParasThread.GetDRSInfoObject(aDrsNo, aR_Deviceid: string;
  aMsgid: integer): TRepBase;
var
  lRepBase: TRepBase;
  lSqlstr: string;
  lTaskid: integer;
begin
  result:= nil;
  case aMsgid of
    WD_REP_PARAMAUTOALARMQUERY_ASK:
    begin
      lTaskid:= GetSequence(FQueryFree,'mtu_taskid');
      lSqlstr:= 'select * from drs_info t'+
                ' where upper(t.drsno)='+uppercase(aDrsNo)+' and upper(t.r_deviceid)='+uppercase(aR_Deviceid);
      OpenDataSet(FQueryFree,lSqlstr);
      if FQueryFree.RecordCount=1 then
      begin
        lRepBase:= TRepAUTOALARMParamQuery.create(true);
        TRepAUTOALARMParamQuery(lRepBase).Taskid:= lTaskid;
        TRepAUTOALARMParamQuery(lRepBase).Cityid:= FQueryFree.FieldByName('cityid').AsInteger;
        TRepAUTOALARMParamQuery(lRepBase).DeviceType:= FQueryFree.FieldByName('drstype').AsString;
        TRepAUTOALARMParamQuery(lRepBase).DRSID:= FQueryFree.FieldByName('drsid').AsInteger;
        TRepAUTOALARMParamQuery(lRepBase).DRSNO:= FQueryFree.FieldByName('drsno').AsString;
        TRepAUTOALARMParamQuery(lRepBase).R_Deviceid:= FQueryFree.FieldByName('r_deviceid').AsString;
        TRepAUTOALARMParamQuery(lRepBase).AskTag:= '0';
        TRepAUTOALARMParamQuery(lRepBase).DataLength:= '0';
      end;
    end;
  end;
  result:= lRepBase;
end;

//0 δִ�� 1 ���� -1 �쳣
function TDRS_ResultParasThread.ParseBaseData(MsgData: string): integer;
var
  lRepBase: TRepBase;
  lMsgID: integer;
  ldrsno, lr_deviceid: string;
begin
  result:= 0;
  lRepBase:= nil;
  try
    try
      Log.Write('��ȡ����DRS  '+ copy(MsgData,1,21),1);
      lMsgID:= HexToInt(GetSubStr(MsgData,10,11));
      case lMsgID of
        WD_REP_PARAMQUERY_ASK,
        WD_REP_PARAMDRSQUERY_ASK,
        WD_REP_PARAMWDPQUERY_ASK,
        WD_REP_PARAMDRSNOSET_ASK,
        WD_REP_PARAMRCOMSET_ASK,
        WD_REP_PARAMRAUTOALARMSET_ASK,
        WD_REP_PARAMRESHOLDSET_ASK,
        WD_REP_PARAMSWITCHSET_ASK,
        WD_REP_PARAMDAMPSET_ASK,
        WD_REP_PARAMCHANNELSET_ASK,
        WD_REP_PARAMWDPFSJSET_ASK
        :
        begin
          lRepBase:= GetDRSInfoList(copy(MsgData,1,21));
        end;
        //�Զ��ϱ�
        WD_REP_PARAMAUTOALARMQUERY_ASK
        :
        begin
          ldrsno:= OffGetDrsNo(copy(MsgData,12,8));
          lr_deviceid:= OffGetDrsNo(copy(MsgData,20,2));
          lRepBase:= GetDRSInfoObject(ldrsno,lr_deviceid,WD_REP_PARAMAUTOALARMQUERY_ASK);
        end;
      end;
      //�õ����Խ��������
      //�жϸ�ֱ��վ�Ƿ���Ҫ�������
      if lRepBase= nil then
        Log.Write('δ�ҵ���Ӧ�Ľ����࣬���ܳ�ʱ��ɾ����',1);
      if lRepBase<> nil then
      begin
        lRepBase.MsgID:= lMsgID+100;//����ͽ������100
        lRepBase.CollectTime:= GetSysDateTime(FQueryFree);
        if lRepBase.DecodeMsgSQL(MsgData,FSQLList) then
        begin
          if FSQLList.Count >0 then
          begin
            ExecSQLList(FQueryFree,FSQLList);
            result:= 1;
          end;
        end;
      end;
    except
      result:= -1;
    end;
  finally
    if lRepBase<>nil then
      lRepBase.Free;
  end;
end;

end.
