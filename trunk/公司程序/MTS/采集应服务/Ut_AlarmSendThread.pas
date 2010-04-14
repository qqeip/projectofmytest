unit Ut_AlarmSendThread;

interface

uses
  Windows, Classes, Log, SysUtils,DateUtils, IniFiles,
  Forms,Ut_BaseThread,ADODB,DB,Variants;

const
  ROLL_INTERVAL=300000;

type
  TAlarmArray = Array of Array of integer;
  
  TAlarmSendThread = class(TMyThread)
  private
    { Private declarations }
    FAdoCon : TAdoConnection;
    FQuery,FQueryDetail,FQueryDataCollect,FQueryMaster,FQueryContent,
    FQueryMaster_H,FQueryDetail_H, FQueryAlarmData : TAdoQuery;
    Sp_Alarm_FlowNumber: TADOStoredProc;
  protected
    procedure DoExecute; override;
    function GetSysDateTime():TDateTime;  //�õ����ݿ������ʱ��
    function ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer;
    procedure ExecMySQL(TheQuery :TADOQUERY;sqlstr :String);
    procedure GetAlarmData(aMtuid,aContentCode,aStatus : integer);
  public
    constructor Create(ConnStr :String);
    destructor Destroy; override;
  end;

implementation
uses Ut_Global;

{ TAlarmSendThread }

constructor TAlarmSendThread.Create(ConnStr: String);
begin
  inherited create;

  FAdoCon := TAdoConnection.Create(nil);
  with FAdoCon do
  begin
    ConnectionString :=ConnStr;
    LoginPrompt := false;
    KeepConnection := true;
  end;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FAdoCon;

  FQueryDetail :=TAdoQuery.Create(nil);
  FQueryDetail.Connection := FAdoCon;

  FQueryDataCollect :=TAdoQuery.Create(nil);
  FQueryDataCollect.Connection := FAdoCon;

  FQueryMaster :=TAdoQuery.Create(nil);
  FQueryMaster.Connection := FAdoCon;

  FQueryContent :=TAdoQuery.Create(nil);
  FQueryContent.Connection := FAdoCon;

  FQueryMaster_H :=TAdoQuery.Create(nil);
  FQueryMaster_H.Connection := FAdoCon;

  FQueryDetail_H :=TAdoQuery.Create(nil);
  FQueryDetail_H.Connection := FAdoCon;

  FQueryAlarmData :=TAdoQuery.Create(nil);
  FQueryAlarmData.Connection := FAdoCon;

  Sp_Alarm_FlowNumber:= TADOStoredProc.Create(nil);
  with Sp_Alarm_FlowNumber do
  begin
    Close;
    Connection := FAdoCon;
    ProcedureName:='MTS_GET_FLOWNUMBER';
    Parameters.Clear;
    Parameters.CreateParameter('I_FLOWNAME',ftString,pdInput,100,null);
    Parameters.CreateParameter('I_SERIESNUM',ftInteger,pdInput,0,null);
    Parameters.CreateParameter('O_FLOWVALUE',ftInteger,pdOutput,0,null);
    Prepared;
  end;
end;

destructor TAlarmSendThread.destroy;
begin
  FQuery.Close;
  FQuery.Free;
  FQueryDetail.Close;
  FQueryDetail.Free;
  FQueryMaster.Close;
  FQueryMaster.Free;
  FQueryDataCollect.Close;
  FQueryDataCollect.Free;
  Sp_Alarm_FlowNumber.Close;
  Sp_Alarm_FlowNumber.Free;
  FQueryContent.Close;
  FQueryContent.Free;
  FQueryMaster_H.Close;
  FQueryMaster_H.Free;
  FQueryDetail_H.Close;
  FQueryDetail_H.Free;
  FQueryAlarmData.Close;
  FQueryAlarmData.Free;
  
  FAdoCon.Close;
  FAdoCon.Free;
  inherited destroy;
end;
//
procedure TAlarmSendThread.DoExecute;
const
  SQLMASTER_H ='select alarmid, alarmcontentcode, mtuid, taskid, execid, flowtache, sendtime,removetime, collecttime, alarmcount, removecount from alarm_master_history where alarmid=-1';
  SQLDETAIL_H ='select alarmid, alarmcontentcode, collecttime, status, collectid from alarm_detail_history where alarmid=-1';
var
  sql_collect,sql_Master,sql_detail,sql_remove :String;
  CurTime :TDateTime;
  NewAlarmId,iAlarmCount,iRemoveCount :Integer;
  AData :PThreadData;
begin
  if not FAdoCon.Connected then
  try
    FAdoCon.Connected := true;
  Except
    self.Log.Write('�����̴߳����������ݿ�ʧ�ܣ�',1);
    Exit;
  end;
  iAlarmCount :=0;
  iRemoveCount:=0;
  CurTime :=GetSysDateTime;
  //sql_history :='';
  sql_master :=' select alarmid, alarmcontentcode, mtuid, taskid, execid, flowtache,'+
               ' sendtime, removetime, collecttime, alarmcount, removecount'+
               ' from alarm_master_online';  
  sql_collect:=' select * from alarm_data_collect order by collectid,taskid,execid';
  sql_detail :=' select alarmid,collectid, alarmcontentcode, collecttime, status from alarm_detail_online';
  //FAdoCon.BeginTrans;
  try
    with FQueryMaster_H do
    begin
      Close;
      SQL.Clear;
      SQL.Add(SQLMASTER_H);
      Open;
    end;
    with FQueryDetail_H do
    begin
      Close;
      SQL.Clear;
      SQL.Add(SQLDETAIL_H);
      Open;
    end;
    with FQueryContent do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select alarmcontentcode,alarmcount,removecount from mtu_alarm_content where ifineffect =1');
      Open;
    end;
    with FQueryMaster do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sql_master);
      Open;
    end;
    with FQueryDetail do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sql_detail);
      Open;
    end;
    //�жϸ澯�ɼ�����
    with FQueryDataCollect do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sql_collect);
      Open;
      if RecordCount > 0 then
      begin
        first;
        while Not Eof do
        begin
          if FQueryDetail.Filtered then
            FQueryDetail.Filtered := false;
          //�澯
          if FieldByName('STATUS').AsInteger = 1 then
          begin
            if not FQueryMaster.Locate('ALARMCONTENTCODE;MTUID',VarArrayOf([FieldByName('ALARMCONTENTCODE').AsInteger,FieldByName('MTUID').AsInteger]),[loCaseInsensitive]) then
            begin
              NewAlarmId :=ProduceFlowNumID('ALARMID',1);
              FQueryMaster.Append;
              FQueryMaster.FieldByName('ALARMID').AsInteger := NewAlarmId;
              FQueryMaster.FieldByName('ALARMCONTENTCODE').AsInteger :=FieldByName('ALARMCONTENTCODE').AsInteger;
              FQueryMaster.FieldByName('MTUID').AsInteger :=FieldByName('MTUID').AsInteger;
              FQueryMaster.FieldByName('TASKID').AsInteger :=FieldByName('TASKID').AsInteger;
              FQueryMaster.FieldByName('EXECID').AsInteger :=FieldByName('EXECID').AsInteger;
              FQueryMaster.FieldByName('FLOWTACHE').AsInteger :=1;
              FQueryMaster.FieldByName('COLLECTTIME').AsDateTime :=FieldByName('COLLECTTIME').AsDateTime;
              FQueryMaster.FieldByName('ALARMCOUNT').AsInteger :=1;
              FQueryMaster.FieldByName('REMOVECOUNT').AsInteger :=0;
              //
            end
            else
            begin
              NewAlarmId := FQueryMaster.FieldByName('alarmid').AsInteger;
              FQueryMaster.Edit;
              FQueryMaster.FieldByName('ALARMCOUNT').AsInteger :=FQueryMaster.FieldByName('ALARMCOUNT').AsInteger+1;
              FQueryMaster.FieldByName('REMOVECOUNT').AsInteger:=0;
            end;
            //�ɼ���������ϸ��
            FQueryDetail.Append;
            FQueryDetail.FieldByName('alarmid').AsInteger :=NewAlarmId;
            FQueryDetail.FieldByName('collectid').AsInteger :=FieldByName('collectid').AsInteger;
            FQueryDetail.FieldByName('alarmcontentcode').AsInteger :=FieldByName('alarmcontentcode').AsInteger;
            FQueryDetail.FieldByName('collecttime').AsDateTime :=FieldByName('COLLECTTIME').AsDateTime;
            FQueryDetail.FieldByName('status').AsInteger :=FieldByName('status').AsInteger;
            FQueryDetail.Post;

            //�ж��Ƿ���������
            if FQueryMaster.FieldByName('FLOWTACHE').AsInteger<> 2 then
            if FQueryContent.Locate('alarmcontentcode',FieldByName('alarmcontentcode').AsInteger,[]) then
            begin
              if FQueryContent.FieldByName('ALARMCOUNT').AsInteger<=FQueryMaster.FieldByName('ALARMCOUNT').AsInteger then
              begin
                FQueryMaster.FieldByName('FLOWTACHE').AsInteger := 2;
                FQueryMaster.FieldByName('SENDTIME').AsDateTime := CurTime;
                Inc(iAlarmCount);
                //�Ӹ澯������,������һ�����ݽ�alarm_data_gather��
                GetAlarmData(FieldByName('MTUID').AsInteger,FieldByName('ALARMCONTENTCODE').AsInteger,1);
              end;
            end;
            FQueryMaster.Post;
          end
          //�ų�
          else if FieldByName('STATUS').AsInteger = 2 then
          begin
            if FQueryMaster.Locate('ALARMCONTENTCODE;MTUID',VarArrayOf([FieldByName('ALARMCONTENTCODE').AsInteger,FieldByName('MTUID').AsInteger]),[loCaseInsensitive]) then
            begin
              //����澯�Ѿ��ɳ�,��ô�����ۼƣ�1, �ж��Ƿ��Ѿ�������������
              if FQueryMaster.FieldByName('FLOWTACHE').AsInteger = 2 then
              begin
                if FQueryContent.Locate('alarmcontentcode',FieldByName('alarmcontentcode').AsInteger,[]) then
                begin
                  if FQueryContent.FieldByName('REMOVECOUNT').AsInteger<=FQueryMaster.FieldByName('REMOVECOUNT').AsInteger+1 then
                  begin
                    //�����������ƶ�����ʷ��
                    FQueryMaster_H.Append;
                    FQueryMaster_H.FieldByName('alarmid').Value := FQueryMaster.FieldByName('alarmid').Value;
                    FQueryMaster_H.FieldByName('alarmcontentcode').Value := FQueryMaster.FieldByName('alarmcontentcode').Value;
                    FQueryMaster_H.FieldByName('mtuid').Value := FQueryMaster.FieldByName('mtuid').Value;
                    FQueryMaster_H.FieldByName('taskid').Value := FQueryMaster.FieldByName('taskid').Value;
                    FQueryMaster_H.FieldByName('execid').Value := FQueryMaster.FieldByName('execid').Value;
                    FQueryMaster_H.FieldByName('flowtache').Value := 3;
                    FQueryMaster_H.FieldByName('sendtime').Value := FQueryMaster.FieldByName('sendtime').Value;
                    FQueryMaster_H.FieldByName('removetime').AsDateTime := CurTime;
                    FQueryMaster_H.FieldByName('collecttime').Value := FQueryMaster.FieldByName('collecttime').Value;
                    FQueryMaster_H.FieldByName('alarmcount').Value := FQueryMaster.FieldByName('alarmcount').Value;
                    FQueryMaster_H.FieldByName('removecount').Value := FQueryMaster.FieldByName('removecount').Value+1;
                    FQueryMaster_H.Post;
                    //���� ����ʷ��
                    sql_remove := 'insert into alarm_detail_history select * from alarm_detail_online where alarmid='+FQueryMaster.FieldByName('alarmid').AsString;
                    ExecMySQL(FQuery,sql_remove);
                    //ɾ�������ӱ��еĸ澯����
                    sql_remove := 'delete from alarm_detail_online where alarmid='+FQueryMaster.FieldByName('alarmid').AsString;
                    ExecMySQL(FQuery,sql_remove);
                    Inc(iRemoveCount);
                    FQueryMaster.Delete;
                    //�������ϵ�����,������һ�����ݽ�alarm_data_gather��
                    GetAlarmData(FieldByName('MTUID').AsInteger,FieldByName('ALARMCONTENTCODE').AsInteger,0);
                  end
                  else
                  begin
                    FQueryMaster.Edit;
                    FQueryMaster.FieldByName('REMOVECOUNT').AsInteger :=FQueryMaster.FieldByName('REMOVECOUNT').AsInteger+1;
                    FQueryMaster.Post;
                  end;
                end;
              end
              //�澯δ�ɳ�,ɾ������ϸ��ļ�¼
              else
              begin
                //ɾ����ϸ��
                FQueryDetail.Filtered := false;
                FQueryDetail.Filter :='alarmid='+ FQueryMaster.FieldByName('alarmid').AsString;
                FQueryDetail.Filtered :=true;
                if FQueryDetail.RecordCount > 0 then
                begin
                  while Not FQueryDetail.Eof do
                    FQueryDetail.Delete;
                end;
                FQueryDetail.Filtered := false;
                FQueryMaster.Delete;
              end;
            end;
          end;
          //д�����ʶ
          Edit;
          FieldByName('ISPROCESS').AsInteger :=1;
          Post;
          Next;
        end;
      end;
      Close;
    end;
    //ɾ���Ѵ��������
    sql_remove := 'delete from alarm_data_collect where isprocess=1';
    ExecMySQL(FQuery,sql_remove);
   
    //FAdoCon.CommitTrans;
    self.Log.Write('���ϣ�'+IntToStr(iAlarmCount)+' ����: '+IntToStr(iRemoveCount),3);
  Except
    On E :Exception do
    begin
      self.Log.Write('����ʧ��: '+E.Message,1);
      //FAdoCon.RollbackTrans;
    end;
  end;
  
  if iAlarmCount > 0 then
  begin
    New(AData);
    AData.command := 1;
    AData.cityid := 0;
    AData.Msg := '����';
    PostMessage(Application.MainForm.Handle, WM_SENDTHREAD_MSG, 0, Longint(AData));
  end;
  
  if iRemoveCount > 0 then
  begin
    New(AData);
    AData.command := 2;
    AData.cityid := 0;
    AData.Msg := '����';
    PostMessage(Application.MainForm.Handle, WM_SENDTHREAD_MSG, 0, Longint(AData));
  end;
  FAdoCon.Connected := false;
  
end;

procedure TAlarmSendThread.ExecMySQL(TheQuery: TADOQUERY; sqlstr: String);
begin
  with TheQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add(sqlstr);
    ExecSQL;
    close;
  end;
end;

procedure TAlarmSendThread.GetAlarmData(aMtuid, aContentCode, aStatus: integer);
var
  lSqlstr : string;
begin
  with FQueryAlarmData do
  begin
    Close;
    lSqlstr := 'Merge into alarm_data_gather a'+
               ' USING (select t1.mtuid,t1.contentcode,t2.alarmcontentname,t3.mtuno from'+
                        ' (select '+inttostr(aMtuid)+' mtuid,'+inttostr(aContentCode)+' contentcode from dual) t1'+
                        ' inner join mtu_alarm_content t2 on t1.contentcode=t2.alarmcontentcode'+
                        ' inner join mtu_info t3 on t1.mtuid=t3.mtuid) b'+
               ' On (a.mtuid=b.mtuid and a.contentcode=b.contentcode)'+
               ' when matched then update set status='+inttostr(aStatus)+',updatetime=sysdate'+
               ' when not matched then insert values (mtu_alarmdatacollectid.nextval,'+
               ' b.mtuid,b.contentcode,'+inttostr(aStatus)+',sysdate,b.alarmcontentname,b.mtuno)';
    Sql.Text := lSqlstr;
    ExecSQL;
  end;
end;

function TAlarmSendThread.GetSysDateTime: TDateTime;
begin
  with FQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add('select sysdate from dual');
    open;
    result:=fieldbyname('sysdate').asdatetime;
    close;
  end;
end;

function TAlarmSendThread.ProduceFlowNumID(I_FLOWNAME: string;
  I_SERIESNUM: integer): Integer;
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

end.
