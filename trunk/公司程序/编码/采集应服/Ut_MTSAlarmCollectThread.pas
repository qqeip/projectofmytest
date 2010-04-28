unit Ut_MTSAlarmCollectThread;

interface

uses
  Classes,ADODB,DB,Variants,SysUtils,ComCtrls,Windows,Controls,StrUtils,Forms,Ut_PubObj_Define;
const
  ThreadSN = 10;  //线程号
  CollectionKind = 16;  //alarm_collection_cyc_list 表中 MTS告警

type
  TMTSAlarmCollect = class(TThread)
  private
    Ado_LocalConn: TADOConnection;
    Ado_RemoteConn: TADOConnection;
    Ado_LocalQuery: TADOQuery;
    Ado_LocalQuery_1: TADOQuery;
    Ado_LocalQuery_2: TADOQuery;
    Ado_RemoteQuery: TADOQuery;
    Sp_Alarm_FlowNumber: TADOStoredProc;
    
    ButtonIsEnable:Boolean;
    MessageContent:String;
    ErrConParam : TErrorContentParam;

    procedure SetName;
    procedure AppendRunLog;
    procedure WriteErrorInfo(ErrorSN: integer);
    procedure ExecSQL(SQLCASE: integer);
    procedure SetButton_IsEnable;
    function CollectSigleNetMan(CurrConn: integer): boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(LocalConn:String);
    destructor Destroy;override;
    procedure MTSAlarmDataCollect;
  end;

implementation

uses Ut_RunLog, Ut_Collection_Data;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TMTSAlarmCollect.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{$IFDEF MSWINDOWS}
type
  TThreadNameInfo = record
    FType: LongWord;     // must be 0x1000
    FName: PChar;        // pointer to name (in user address space)
    FThreadID: LongWord; // thread ID (-1 indicates caller thread)
    FFlags: LongWord;    // reserved for future use, must be zero
  end;
{$ENDIF}

{ TMTSAlarmCollect }

procedure TMTSAlarmCollect.SetName;
{$IFDEF MSWINDOWS}
var
  ThreadNameInfo: TThreadNameInfo;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ThreadNameInfo.FType := $1000;
  ThreadNameInfo.FName := 'TMTSAlarmCollect';
  ThreadNameInfo.FThreadID := $FFFFFFFF;
  ThreadNameInfo.FFlags := 0;

  try
    RaiseException( $406D1388, 0, sizeof(ThreadNameInfo) div sizeof(LongWord), @ThreadNameInfo );
  except
  end;
{$ENDIF}
end;

procedure TMTSAlarmCollect.Execute;
begin
  SetName;
  { Place thread code here }
  while (not terminated) do
  begin
    try
      MTSAlarmDataCollect;
    finally
      Suspend;
    end;
  end;
end;

procedure TMTSAlarmCollect.MTSAlarmDataCollect;
var
  starttime,endtime:TTime;
  CurrConn,ErrorNetMan:integer;
  CurrSqlStr, CollectFailedList:string;
begin
  ButtonIsEnable:=false;
  Synchronize(SetButton_IsEnable);
  try
    starttime:=now;
    ErrorNetMan:=0;
    try  //测试本地连接
      if Ado_LocalConn.Connected then
        Ado_LocalConn.Connected:=false;
      Ado_LocalConn.Connected:=true;
    except
      WriteErrorInfo(6);
      exit;
    end;

    Ado_LocalConn.BeginTrans;
    try
      ExecSQL(1);
      ExecSQL(2);
      //--采集的告警内容必须在《告警内容编码表》中，并且该告警内容编码被设为有效
      OpenTheDataSet(Ado_LocalQuery_1,SqlStr[ThreadSN][3]);
      //--采集的告警内容不在《告警内容屏避表》中
      OpenTheDataSet(Ado_LocalQuery_2,SqlStr[ThreadSN][4]);
      //--打开本地数据集 alarm_mts_noarrange_temp
      OpenTheDataSet(Ado_LocalQuery,SqlStr[ThreadSN][5]);
      CollectFailedList:='';
      for CurrConn:=Low(RemoteSource[ThreadSN]) to High(RemoteSource[ThreadSN]) do
        if not CollectSigleNetMan(CurrConn) then
        begin
          inc(ErrorNetMan);
          with RemoteSource[ThreadSN][CurrConn] do
          begin
            CollectFailedList:=',('+inttostr(collectionkind)+','+inttostr(collectioncode)+')';
            ErrConParam.CollectionCode:=collectioncode;
            ErrConParam.collectionname:=collectionname;
          end;
          WriteErrorInfo(2);
        end;

      //--将<新告警信息> 筛选出来，存入alarm_rt_arrange_temp表中，筛选出的<新告警信息>满足以下条件：
      //--1、该告警内容不在“在线告警明细视图”中(alarm_online_detail_view)
      ExecSQL(7);
      //--删除alarm_mts_arrange_temp表中的重复记录(一般情况下应该没有重复记录)
      ExecSQL(9);
      //--检查该表是否有记录
      if GetRecCount(Ado_LocalQuery,SqlStr[ThreadSN][10])>0 then
      //--将网管线路告警表和ALARM_ONLINE_DETAIL_VIEW表中基站相同、告警内容相同但告警状态不一样的记录筛选出来，存入Alarm_Data_Gather表中
      //--将网管线路告警表中基站、告警内容均不在 alarm_online_detail_view表中并且非Clear告警的记录筛选出来，存入Alarm_Data_Gather表中
         ExecSQL(11);

      Ado_LocalConn.CommitTrans;
      endtime:=now;
      if ErrorNetMan>0 then
      begin
        ErrConParam.ErrorNetMan:=ErrorNetMan;
        ErrConParam.SucceedNetMan:=High(RemoteSource[ThreadSN])+1-ErrorNetMan;
        WriteErrorInfo(3);
      end
      else
      begin
        ErrConParam.PassTime:=timetostr(endtime-starttime);
        WriteErrorInfo(4);
      end;
    except
      on E: exception do
      begin
        Ado_LocalConn.RollbackTrans;
        ErrConParam.BornError:=e.Message;
        WriteErrorInfo(5);
      end;
    end;
  finally
    ButtonIsEnable:=true;
    Synchronize(SetButton_IsEnable);
    Ado_LocalConn.Connected:=false;
  end;
end;

//采集单个网管
Function TMTSAlarmCollect.CollectSigleNetMan(CurrConn:integer):boolean;
var
  i:integer;
begin
  try
    Ado_RemoteConn.Connected:=false;
    Ado_RemoteConn.ConnectionString:=RemoteSource[ThreadSN][CurrConn].RemoteConn;
    Ado_RemoteConn.Connected:=true;

    //--将网管侧 告警数据迁移到本地alarm_mts_noarrange_temp表中
    OpenTheDataSet(Ado_RemoteQuery,ReplaceSQLParam(SqlStr[ThreadSN][6],RemoteSource[ThreadSN][CurrConn])); //此处完成远程SQL语句的若干参数替换
    with Ado_RemoteQuery do
    begin
       first;
       while not eof do
       begin
          if Ado_LocalQuery_1.Locate('cityid;alarmcontentname',VarArrayOf([fieldbyname('cityid').asinteger,fieldbyname('contentname').AsString]),[loCaseInsensitive])
          and (not Ado_LocalQuery_2.Locate('cityid;nodeaddress;alarmcontentname',VarArrayOf([fieldbyname('cityid').asinteger,fieldbyname('nodeaddress').AsString,fieldbyname('contentname').AsString]),[loCaseInsensitive])) then
          begin
            Ado_LocalQuery.Append;
            for i:=0 to FieldCount-1 do
               Ado_LocalQuery.Fields[i].Value:= Fields[i].Value;
            Ado_LocalQuery.Post;
          end;
          next;
       end;
    end;
    Result:=true;
  except
    Result:=false;
  end;
end;

constructor TMTSAlarmCollect.Create(LocalConn: String);
begin
  inherited Create(true);

  InitSQLVar(ThreadSN);

  Ado_LocalConn := TADOConnection.Create(nil);
  Ado_LocalConn.LoginPrompt:=false;
  Ado_LocalConn.ConnectionString:=LocalConn;

  Ado_LocalQuery_1 := TAdoQuery.Create(nil);
  Ado_LocalQuery_1.Connection := Ado_LocalConn;

  Ado_LocalQuery_2 := TAdoQuery.Create(nil);
  Ado_LocalQuery_2.Connection := Ado_LocalConn;

  Ado_LocalQuery := TAdoQuery.Create(nil);
  Ado_LocalQuery.Connection := Ado_LocalConn;

  Ado_RemoteConn := TADOConnection.Create(nil);
  Ado_RemoteConn.connectiontimeout:=60 ;
  Ado_RemoteConn.LoginPrompt:=false;

  Ado_RemoteQuery := TAdoQuery.Create(nil);
  Ado_RemoteQuery.CommandTimeout :=60;
  Ado_RemoteQuery.Connection := Ado_RemoteConn;

  Sp_Alarm_FlowNumber:= TADOStoredProc.Create(nil);
  with Sp_Alarm_FlowNumber do
  begin
     Close;
     Connection := Ado_LocalConn;
     ProcedureName:='ALARM_GET_FLOWNUMBER';
     Parameters.Clear;
     Parameters.CreateParameter('I_FLOWNAME',ftString,pdInput,100,null);
     Parameters.CreateParameter('I_SERIESNUM',ftInteger,pdInput,0,null);
     Parameters.CreateParameter('O_FLOWVALUE',ftInteger,pdOutput,0,null);
     Prepared;
  end;

  if not InitNetManParamSet(Ado_LocalQuery,Ado_RemoteQuery,ThreadSN,CollectionKind) then
    WriteErrorInfo(1);
  Ado_LocalConn.Connected:=false;
end;

destructor TMTSAlarmCollect.Destroy;
begin
  Ado_RemoteQuery.Close;
  Ado_RemoteQuery.Free;
  Ado_LocalQuery_2.Close;
  Ado_LocalQuery_2.Free;
  Ado_LocalQuery_1.Close;
  Ado_LocalQuery_1.Free;
  Ado_LocalQuery.Close;
  Ado_LocalQuery.Free;
  Sp_Alarm_FlowNumber.Close;
  Sp_Alarm_FlowNumber.Free;
  Ado_RemoteConn.Close;
  Ado_RemoteConn.Free;
  Ado_LocalConn.Close;
  Ado_LocalConn.Free;
  inherited;
end;

procedure TMTSAlarmCollect.AppendRunLog;
begin
  if Fm_RunLog = nil then Exit;
  Fm_RunLog.Re_RunLog.Lines.Add(MessageContent);
end;

procedure TMTSAlarmCollect.WriteErrorInfo(ErrorSN:integer); //写错误信息
begin
  ErrConParam.ErrorSN:=ErrorSN;
  ErrConParam.CollectionKind:=CollectionKind;
  MessageContent:=GetErrorContent(ErrConParam);
  Synchronize(AppendRunLog);
end;

//设置“按钮”是否可用
procedure TMTSAlarmCollect.SetButton_IsEnable();
begin
   Fm_Collection_Data.Bt_RealTime.Enabled:=ButtonIsEnable;
end;

procedure TMTSAlarmCollect.ExecSQL(SQLCASE:integer);
begin
  with Ado_LocalQuery do
  begin
    close;
    sql.Clear;
    sql.Add(SqlStr[ThreadSN][SQLCASE]);
    if SQLCASE=11 then
    begin
      SQLCASE:=ProduceFlowNumID(Sp_Alarm_FlowNumber,'CollectID', 1);
      Parameters.ParamByName('NewCollectID_1').Value:= SQLCASE;
      Parameters.ParamByName('NewCollectID_2').Value:= SQLCASE;
    end;
    ExecSQL; 
  end;
end;

end.
