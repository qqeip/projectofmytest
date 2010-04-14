unit Ut_DataCollectThread;

interface

uses
  Windows, Classes, Log, SysUtils,DateUtils, IniFiles,
  Forms,Ut_BaseThread,ADODB,DB,Variants,UnitMosReader;

const
  ROLL_INTERVAL=300000;

type
  TAlarmArray = Array of Array of integer;
  
  TCollectThread = class(TMyThread)
  private
    { Private declarations }
    FAdoCon : TAdoConnection;
    FQuery,FQueryFree,FQueryDataCollect,FQueryAlarmContent : TAdoQuery;
    Sp_Alarm_FlowNumber: TADOStoredProc;
    MosReader :TMosReader;
    FIsConncetFtp : Boolean;
  protected
    procedure DoExecute; override;
    function ProduceFlowNumID(I_FLOWNAME:string;I_SERIESNUM:integer):Integer;
    // 0: 未知  1：告警 2:
    function JudgeIsAlarm(ParamValue,AlarmValue,RemoveValue:String):integer;
    procedure JudgeAlarmContent(const comid,paramid :integer;ParamValue:String;var AlarmS:TAlarmArray);
    //更新MTU的在线状态
    procedure UpdateMtuStatus;
    //获取录音文件计算MOS值
    procedure TreatmentMosValue;
    function ExecMySQL(TheQuery :TADOQUERY;sqlstr :String):integer;
    function GetSysDateTime():TDateTime;  //得到数据库服务器时间
  public
    constructor Create(ConnStr :String);
    destructor Destroy; override;
  end;

implementation
uses Ut_Global;

constructor TCollectThread.Create(ConnStr :String);
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

  FQueryFree :=TAdoQuery.Create(nil);
  FQueryFree.Connection := FAdoCon;

  FQueryDataCollect :=TAdoQuery.Create(nil);
  FQueryDataCollect.Connection := FAdoCon;

  FQueryAlarmContent :=TAdoQuery.Create(nil);
  FQueryAlarmContent.Connection := FAdoCon;

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
  MosReader :=TMosReader.Create;
end;

destructor TCollectThread.destroy;
begin
  MosReader.Free;
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FQueryAlarmContent.Close;
  FQueryAlarmContent.Free;
  FQueryDataCollect.Close;
  FQueryDataCollect.Free;
  Sp_Alarm_FlowNumber.Close;
  Sp_Alarm_FlowNumber.Free;
  FAdoCon.Close;
  FAdoCon.Free;
  inherited destroy;
end;

procedure TCollectThread.DoExecute;
var
  sqlstr,sql_collect,sql_del :String;
  AlarmS:TAlarmArray;
  i,iCount :integer;
  AData :PThreadData;
  handleCount :integer;
begin
  sqlstr :=' select a.*,b.mtuid from mtu_testresult_online a'+
           ' inner join mtu_info b on a.mtuno=b.mtuno'+
           ' order by a.taskid,a.execid,a.comid,a.paramid,a.valueindex';
  sql_collect :=' select COLLECTID,taskid, execid, mtuid, alarmcontentcode, status, collecttime from alarm_data_collect';
  iCount :=0;
  handleCount :=0;
  if not FAdoCon.Connected then
  try
    FAdoCon.Connected := true;
  Except
    self.Log.Write('MTU告警采集线程错误：连接数据库失败！',1);
    Exit;
  end;
  try
    //更新MTU在线状态
    UpdateMtuStatus;
    //Mos值处理
    TreatmentMosValue;
    //测试结果处理表
    with FQueryDataCollect do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sql_collect);
      Open;
    end;
    //测试结果表
    with FQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      Open;
      First;
      while Not Eof do
      begin
        if (FieldByName('valueindex').AsInteger=0) and (Trim(FieldByName('TESTRESULT').AsString)<>'') then
        begin
          //传入命令号、参数号、值 判断是否告警状态，同时获取告警内容编号
          JudgeAlarmContent(FieldByName('COMID').AsInteger,FieldByName('PARAMID').AsInteger,FieldByName('TESTRESULT').AsString,AlarmS);
          if AlarmS <> nil then
          begin
            for I := Low(AlarmS) to High(AlarmS) do
            begin
              if AlarmS[i,1] > 0 then
              begin
                FQueryDataCollect.Append;
                FQueryDataCollect.FieldByName('COLLECTID').Value := ProduceFlowNumID('COLLECTID',1);
                FQueryDataCollect.FieldByName('taskid').Value := FieldByName('taskid').AsInteger;
                FQueryDataCollect.FieldByName('execid').Value := FieldByName('execid').AsInteger;
                FQueryDataCollect.FieldByName('mtuid').Value := FieldByName('mtuid').AsInteger;
                FQueryDataCollect.FieldByName('alarmcontentcode').Value := AlarmS[i,0];
                FQueryDataCollect.FieldByName('status').Value := AlarmS[i,1];
                FQueryDataCollect.FieldByName('collecttime').Value := FieldByName('collecttime').AsDateTime;
                FQueryDataCollect.Post;
                Inc(iCount);
              end;
            end;
            SetLength(AlarmS,0);
          end;
        end;
        //写已处理标识
        Edit;
        FieldByName('ISPROCESS').AsInteger :=1;
        Post;
        Next;
      end;
    end;
    self.Log.Write('采集成功：共[ '+IntToStr(iCount)+' ]条',3);
  except
    on E:Exception do
    begin
      self.Log.Write('采集失败：'+E.Message,1);
    end;
  end;

  FAdoCon.BeginTrans;
  try
    //更新已经处理的手动测试结果
    //如果手动测试结果没有特殊性，这里操作手动测试结果可以移动到解析线程里
    sql_del :='update mtu_testtask_online a set status=4'+
              ' where exists (select 1 from mtu_testresult_online b where a.taskid=b.taskid'+
              ' and b.Isprocess=1 and b.userid <>-1)';
    ExecMySQL(FQueryFree,sql_del);
    //将用户已经处理的测试结果移动到用户拨测结果存放表中
    sql_del :='insert into mtu_usertestresult'+
              ' select a.* from mtu_testresult_online a'+
              ' inner join mtu_testtask_online b on a.taskid = b.taskid'+
              ' where a.Isprocess=1 and b.STATUS=4 and b.userid <>-1';
    handleCount := ExecMySQL(FQueryFree,sql_del);
    //处理完的数据移动到历史表
    sql_del :='insert into mtu_testresult_history select * from mtu_testresult_online where Isprocess=1';
    ExecMySQL(FQueryFree,sql_del);
    //删除在线表数据
    sql_del :='delete from mtu_testresult_online where Isprocess=1';
    ExecMySQL(FQueryFree,sql_del);
    FAdoCon.CommitTrans;
  except
     On E:Exception do
    begin
      FAdoCon.RollbackTrans;
      Log.Write('MTU告警采集线程清理测试结果数据异常：'+E.Message,1);
      Log.Write(sql_del,1);
    end;
  end;
  if handleCount > 0 then
  begin
    New(AData);
    AData.command := 3;
    AData.cityid := 0;
    AData.Msg := '手动测试';
    PostMessage(Application.MainForm.Handle, WM_SENDTHREAD_MSG, 0, Longint(AData));
  end;

  FAdoCon.Connected := false;
end;

function TCollectThread.ExecMySQL(TheQuery: TADOQUERY; sqlstr: String):integer;
begin
  result :=0;
  with TheQuery do
  begin
    close;
    SQL.Clear;
    SQL.Add(sqlstr);
    result :=ExecSQL;
    close;
  end;
end;

function TCollectThread.GetSysDateTime: TDateTime;
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

procedure TCollectThread.JudgeAlarmContent(const comid, paramid: integer;
  ParamValue: String; var AlarmS:TAlarmArray);
var
  sqlstr :String;
  vIndex :integer;
begin
  try
    sqlstr :='select * from mtu_alarm_content where comid=:comid and paramid=:paramid and sendtype =0 and IFINEFFECT =1 order by alarmcontentcode';
    with FQueryAlarmContent do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      parameters.ParamByName('comid').Value := comid;
      parameters.ParamByName('paramid').Value := paramid;
      Open;
      if RecordCount >0 then
      begin
        vIndex :=0;
        SetLength(AlarmS,RecordCount);
        first;
        while not Eof do
        begin
          SetLength(AlarmS[vIndex],2);
          AlarmS[vIndex,0] := FieldByName('ALARMCONTENTCODE').AsInteger;
          if (Trim(FieldByName('ALARMCONDITION').AsString)<>'') and (Trim(FieldByName('REMOVECONDITION').AsString)<>'') then
            AlarmS[vIndex,1] := JudgeIsAlarm(ParamValue,FieldByName('ALARMCONDITION').AsString,FieldByName('REMOVECONDITION').AsString)
          else
            AlarmS[vIndex,1] :=0;
          Next;
          Inc(vIndex);
        end;
      end;
      Close;
    end;
  except

  end;
end;
//// 0: 未知  1：告警 2:排障
function TCollectThread.JudgeIsAlarm(ParamValue,AlarmValue, RemoveValue: String): integer;
var
  sqlstr :string;
begin
  result :=0;
  sqlstr :='select 1 from dual where ';
  AlarmValue :=StringReplace(AlarmValue, '@Value',ParamValue, [rfReplaceAll, rfIgnoreCase]);
  RemoveValue :=StringReplace(RemoveValue, '@Value',ParamValue, [rfReplaceAll, rfIgnoreCase]);
  try
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
          result :=2;
      end
      else
        result :=1;
      Close;
    end;
  Except
    On E :Exception do
      self.Log.Write('判断是否告警时异常:'+E.Message,1);
  end;
end;

function TCollectThread.ProduceFlowNumID(I_FLOWNAME: string;
  I_SERIESNUM: integer): Integer;
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

//计算MOS值后入库
procedure TCollectThread.TreatmentMosValue;
const
  SQLMOS =' select a.taskid,a.mtuno,a.comid,a.cityid,a.execid,'+
          ' a.testresult as PlayVoice ,b.testresult as RecordVoice'+
          ' from mtu_testresult_online a'+
          ' inner join mtu_testresult_online b on a.taskid= b.taskid and a.comid=b.comid'+
          ' and a.execid=b.execid and a.execid =b.execid'+
          ' where a.paramid=21 and b.paramid=22';
  SQLINS =' insert into mtu_testresult_online(taskid, cityid, mtuno, comid, paramid, valueindex, testresult, collecttime, execid, isprocess)'+
          ' values (%d, %d, %s, %d, %d, %d, %s, sysdate, %d, 0)';
  SQLFTP =' select * from mtu_controlconfig where ftpip is not null';
var
  MosValue,LogStr :string;
begin
  with FQueryFree do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLFTP);
    Open;
    //循环地市
    while not eof do
    begin
      FIsConncetFtp := MosReader.ConnectToFTP(FieldByName('username').AsString,
                       FieldByName('passwd').AsString,FieldByName('ftpip').AsString,
                       FieldByName('ftpport').AsInteger);
      //是否能连接FTP
      if FIsConncetFtp then
      begin
        try
          FQuery.Close;
          FQuery.SQL.Text := SQLMOS+ ' and a.cityid='+FieldByName('cityid').AsString;
          FQuery.Open;
          //循环某地市的MOS测试结果做解析
          while not FQuery.Eof do
          begin
            case MosReader.GetMos(FQuery.FieldByName('playvoice').AsString,
                        FQuery.FieldByName('recordvoice').AsString,
                        FieldByName('ftppath').AsString,MosValue) of
              1: ExecMySQL(FQueryDataCollect,Format(SQLINS,
                               [FQuery.FieldByName('taskid').AsInteger,
                                FQuery.FieldByName('cityid').AsInteger,
                                QuotedStr(FQuery.FieldByName('mtuno').AsString),
                                FQuery.FieldByName('comid').AsInteger,FQuery.FieldByName('paramid').AsInteger,
                                FQuery.FieldByName('valueindex').AsInteger,FQuery.FieldByName('execid').AsInteger]));
              -1: Log.Write(LogStr+'本地不存在MOS目录',1);
              -3: Log.Write(LogStr+'下载文件失败',1);
              -4: Log.Write(LogStr+'调用外部程序失败',1);
              -5: Log.Write(LogStr+'被调用的文件或程序不存在',1);
            end;
          end;
          //是否修改解析结果？
        finally
          if not MosReader.DisConnectToFTP then
            Log.Write('地市编号为'+FieldByName('cityid').AsString+'断开FTP失败',1);
        end;
      end
      else
      begin
        Log.Write('地市编号为'+FieldByName('cityid').AsString+'不能连接到FTP',1);
      end;
    end;
  end;
end;

procedure TCollectThread.UpdateMtuStatus;
var
  sqlstr,sql_status :string;
  CurTime :TDateTime;
begin
  sqlstr :=' select b.mtuid,decode(TESTRESULT,''1'',1,''0'',0) as status '+
           ' from mtu_testresult_online a'+
           ' inner join mtu_info b on a.mtuno=b.mtuno'+
           ' where (comid=68 or comid=136) and paramid=35 and valueindex=0';
  sql_status :='select * from mtu_status_list ';
  CurTime :=GetSysDateTime;
  with FQueryFree do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sql_status);
    Open;
  end;

  with FQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sqlstr);
    Open;
    if RecordCount > 0 then
    begin
      First;
      while Not Eof do
      begin
        Log.Write('MTUID= '+FieldByName('MTUID').AsString+' Status='+FieldByName('STATUS').AsString,3);
        if not FQueryFree.Locate('MTUID',FieldByName('MTUID').AsInteger,[loCaseInsensitive]) then
        begin
          FQueryFree.Append;
          FQueryFree.FieldByName('MTUID').AsInteger := FieldByName('MTUID').AsInteger;
        end
        else
          FQueryFree.Edit;
        FQueryFree.FieldByName('STATUS').AsInteger :=FieldByName('STATUS').AsInteger;
        FQueryFree.FieldByName('UPDATETIME').AsDateTime :=CurTime;
        FQueryFree.Post;
        Next;
      end;                  
      Close;
    end;
  end;
  FQueryFree.Close;
end;

end.
