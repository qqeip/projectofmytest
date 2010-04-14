unit Ut_RDM_MTS;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,md5,
  DBClient, MTS_Server_TLB, StdVcl, Provider, DB, ADODB,Variants,Ut_SqlDeclare_Define;

type
  PArrayData = ^TArrayData;
  TArrayData = array[0..1000] of Olevariant;
  
  TRDM_MTS = class(TRemoteDataModule, IRDM_MTS)
    Aq_General_data: TADOQuery;
    dsp_General_data: TDataSetProvider;
    dsp_General_data1: TDataSetProvider;
    Aq_General_data1: TADOQuery;
    dsp_General_data2: TDataSetProvider;
    Aq_General_data2: TADOQuery;
    dsp_General_data3: TDataSetProvider;
    Aq_General_data3: TADOQuery;
    dsp_General_data4: TDataSetProvider;
    Aq_General_data4: TADOQuery;
    dsp_General_data5: TDataSetProvider;
    Aq_General_data5: TADOQuery;
    dsp_General_data6: TDataSetProvider;
    Aq_General_data6: TADOQuery;
    dsp_General_data7: TDataSetProvider;
    Aq_General_data7: TADOQuery;
    AS_Flow_Number: TADOStoredProc;
    DSP_GIS: TDataSetProvider;
    ADOQueryGIS: TADOQuery;
    procedure RemoteDataModuleCreate(Sender: TObject);
    procedure RemoteDataModuleDestroy(Sender: TObject);
  private
    FGisConn: TAdoConnection;
    { Private declarations }
    procedure ApplyDelta(AProvider: OleVariant; var Delta : OleVariant);
    function GetFlowNumID(CurrConn: TAdoConnection;I_FLOWNAME:string;I_SERIESNUM:integer):Integer;
    function LogEntry(Dig: MD5Digest): string;
    function GetSQLSentence(TheAdoConn: TAdoConnection; OwnerData: OleVariant):String;
    Procedure ActivationDataSet(TheAdoConn:TADOConnection; TheData: OleVariant; TheAdoQuery: TAdoQuery);
    Procedure MoveData(SourceDataSet, TargetDataSet: TAdoQuery);
    function SaveDatetimetoDB(TheDateTime:TDateTime; HoldTime:Boolean=true):String;
    procedure ExecTheSQL(TheAdoConn:TADOConnection; OwnerData: OleVariant);
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
    function GetPriv(userid: Integer): OleVariant; safecall;
    //function Login(const UserNo, Password: WideString;
    //  out UserName: OleVariant): Smallint; safecall;
    function CDSApplyUpdates(var vDetailArray: OleVariant; vProviderArray,
      OwnerData: OleVariant): OleVariant; safecall;
    function GetCDSData(OwnerData: OleVariant; DspId: Integer): OleVariant;
      safecall;
    function LogIn(const UserNo, password: WideString;
      out userid: OleVariant): OleVariant; safecall;
    function ExecBatchSQL(OwnerData: OleVariant): OleVariant; safecall;
    function ProduceFlowNumID(const l_FLowName: WideString;
      l_SeriesNum: Integer): Integer; safecall;
    function CollectServerMsg(EventId, cityid: Integer;
      const Msg: WideString): OleVariant; safecall;
    function ChangePassword(const OldPassword, NewPassword,
      UserNo: WideString): Smallint; safecall;
    function GetTheSequenceId(const Seqname: WideString): Integer; safecall;
    function GetRingRemind(aCityID, aUserID, aRemindType: Integer;
      out vIsRing: Integer; out vWavName: WideString): Integer; safecall;

  public
    { Public declarations }
    SqlStr : PByte; //存放各<告警采集线程>涉及的SQL执行语句
  end;
var
  RDMFactory: TComponentFactory;
implementation
uses Ut_ComponentFactory, Ut_LDM_MTS, Ut_MTS_Main;

{$R *.DFM}

class procedure TRDM_MTS.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
begin
  if Register then
  begin
    inherited UpdateRegistry(Register, ClassID, ProgID);
    EnableSocketTransport(ClassID);
    EnableWebTransport(ClassID);
  end else
  begin
    DisableSocketTransport(ClassID);
    DisableWebTransport(ClassID);
    inherited UpdateRegistry(Register, ClassID, ProgID);
  end;
end;

function TRDM_MTS.GetPriv(userid: Integer): OleVariant;
var
  Conn: TAdoConnection;
  temQ : TADoQuery;
  sqlstr,PrivList :String;
begin
  result := -1;
  sqlstr :=' select t1.moduleid from userprivinfo t1,appmoduleinfo t2 '+
           ' where t1.userid=:userid and t1.moduleid=t2.moduleid and t2.appid= 17';
  Conn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    with temQ do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      Parameters.ParamByName('userid').Value := userid;
      Open;
      PrivList:='';
      while not Eof do
      begin
        PrivList:=PrivList+FieldByName('moduleid').AsString+';';
        Next;
      end;
      result:=PrivList;
    end;
  finally
    FreeExistAdoquery(temQ);
    LDM_MTS.ADOConnPool.FreeConnection(Conn);
  end;
end;

procedure TRDM_MTS.ActivationDataSet(TheAdoConn: TADOConnection;
  TheData: OleVariant; TheAdoQuery: TAdoQuery);
begin

end;

function TRDM_MTS.GetSQLSentence(TheAdoConn: TAdoConnection;
  OwnerData: OleVariant): String;
var
  i,j,k,typevalue: integer;
begin
  typevalue:= VarAsType(OwnerData[0],varInteger);
  i:=VarAsType(OwnerData[1],varInteger);
  j:=VarAsType(OwnerData[2],varInteger);
  Case typevalue of
  0: SqlStr:= SqlStr_Common ; //公用，一般为编码表
  1: SqlStr:= SqlStr_Resource ; //资源数据
  2: SqlStr:= SqlStr_BaseData;  //基础数据
  //3: SqlStr:= SqlStr_expen;   //费用
  //4: SqlStr:= SqlStr_owner  ; //业主
  //5: SqlStr:= SqlStr_Report ; //查询及报表
  //6: SqlStr:= SqlStr_Base   ; //基础信息管理
  //7: SqlStr:= SqlStr_Commlab; //机房、营业厅 
  end;
  if varArrayHighBound(OwnerData, 1)>2 then  //成员多于3个，则表明该SQL语句带有参数,调用参数替换过程
  begin
    //检查参数，如果后续参数中有“@”符号打头的，如'@ProtocolCode'的参数，
    //则表示需调用<申请流水号参数>过程来替换该参数
    for k := varArrayLowBound(OwnerData, 1)+3 to varArrayHighBound(OwnerData, 1) do
      if copy(OwnerData[k],1,1)='@' then
        OwnerData[k]:=GetFlowNumID(TheAdoConn, copy(OwnerData[k],2,length(OwnerData[k])-1), 1);
    Result:=ReplaceSQLParam(SqlStr[i,j],OwnerData);
  end else
    Result:=SqlStr[i,j];
end;

function TRDM_MTS.LogEntry(Dig: MD5Digest): string;
begin
  Result := Format('%s', [MD5Print(Dig)]);
end;

procedure TRDM_MTS.MoveData(SourceDataSet, TargetDataSet: TAdoQuery);
var i:integer;
begin
  with TargetDataSet do
  begin
    SourceDataSet.first;
    while not SourceDataSet.eof do  //将在线数据复制到历史表中
    begin
      Append;
      for i:=0 to FieldCount-1 do
        Fields[i].AsVariant:=SourceDataSet.Fields[i].AsVariant;
      post;
      SourceDataSet.next;
    end;
  end;
end;

function TRDM_MTS.SaveDatetimetoDB(TheDateTime: TDateTime;
  HoldTime: Boolean): String;
begin
  if HoldTime then
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD HH:MI:SS')+')'
  else
    Result:='to_date('+QuotedStr(datetostr(TheDateTime))+','+QuotedStr('YYYY-MM-DD')+')';
end;

procedure TRDM_MTS.ApplyDelta(AProvider: OleVariant; var Delta: OleVariant);
var
  ErrCount : integer;
  OwnerData: OleVariant;
begin
  if not VarIsNull(Delta) then
  begin
    Delta := AS_ApplyUpdates(AProvider, Delta, 0, ErrCount, OwnerData);
    if ErrCount > 0 then
      SysUtils.Abort;  // This will cause Rollback in the calling procedure
  end;
end;

function TRDM_MTS.CDSApplyUpdates(var vDetailArray: OleVariant; vProviderArray,
  OwnerData: OleVariant): OleVariant;
var
  Conn: TAdoConnection;
  i : integer;
  LowArr, HighArr: integer;
  P: PArrayData;
begin
  {Wrap the updates in a transaction. If any step results in an error, raise}
  {an exception, which will Rollback the transaction.}
  Conn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  //Conn.BeginTrans; //申请得到一个连接后，自动启动事务的，所以不需要这句
  try
    if varIsArray(OwnerData) then
    begin
      LowArr:=VarArrayLowBound(OwnerData,1);
      HighArr:=VarArrayHighBound(OwnerData,1);
      for i:=LowArr to HighArr do
        ExecTheSQL(Conn, OwnerData[i]);
    end;

    LowArr:=VarArrayLowBound(vDetailArray,1);
    HighArr:=VarArrayHighBound(vDetailArray,1);
    P:=VarArrayLock(vDetailArray);
    try
      for i:=LowArr to HighArr do
        ApplyDelta(vProviderArray[i], P^[i]);
    finally
      VarArrayUnlock(vDetailArray);
    end;

    Conn.CommitTrans;
    Result:=true;
  except
    Conn.RollbackTrans;
    Result:=false;
  end;
  LDM_MTS.ADOConnPool.FreeConnection(Conn);
end;

function TRDM_MTS.GetCDSData(OwnerData: OleVariant; DspId: Integer): OleVariant;
var
  Conn: TAdoConnection;
  CurrDsp: TDataSetProvider;
  s :string;
begin
  //OwnerData格式：0——哪个菜单下，1——的什么功能，2——的第N个SQL语句，3——参数1，4——参数2，。。。。
  Conn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  try
    if Conn.InTransaction then Conn.CommitTrans;
    case DspID of
     1 : CurrDsp:=dsp_General_data1;
     2 : CurrDsp:=dsp_General_data2;
     3 : CurrDsp:=dsp_General_data3;
     4 : CurrDsp:=dsp_General_data4;
     5 : CurrDsp:=dsp_General_data5;
     6 : CurrDsp:=dsp_General_data6;
     7 : CurrDsp:=dsp_General_data7;
     else
         CurrDsp:=dsp_General_data;
    end;
    with TADOQuery(CurrDsp.DataSet) do
    begin
      Close;
      Connection:=Conn;
      SQL.Text := GetSQLSentence(Conn,OwnerData);
      s := sql.text;
      Open;
      Result:=CurrDsp.Data;
      Close;
    end;
  finally
    LDM_MTS.ADOConnPool.FreeConnection(Conn);
    OwnerData := NULL;
  end;
end;

function TRDM_MTS.GetFlowNumID(CurrConn: TAdoConnection; I_FLOWNAME: string;
  I_SERIESNUM: integer): Integer;
var
  CL:TRTLCriticalSection;
begin
  InitializeCriticalSection(CL);
  EnterCriticalSection(CL);
  try
    with AS_Flow_Number do
    begin
      close;
      Connection:=CurrConn;
      Parameters.Clear;
      Parameters.CreateParameter('I_FLOWNAME', ftString, pdInput, 0, null);
      Parameters.CreateParameter('I_SERIESNUM', ftInteger, pdInput, 0, null);
      Parameters.CreateParameter('O_FLOWVALUE', ftInteger, pdOutput, 0, null);
      Parameters.parambyname('I_FLOWNAME').Value:=I_FLOWNAME;   //流水号命名
      Parameters.parambyname('I_SERIESNUM').Value:=I_SERIESNUM; //申请的连续流水号个数
      execproc;
      result:=Parameters.parambyname('O_FLOWVALUE').Value; //返回值为整型，过程只返回序列的第一个值，但下次返回值为：result+I_SERIESNUM
      close;
    end;
  finally
    LeaveCriticalSection(CL);
  end;
end;
function TRDM_MTS.LogIn(const UserNo, password: WideString;
  out userid: OleVariant): OleVariant;
var
  Conn: TAdoConnection;
  temQ : TADoQuery;
  lSqlText: string;
  lUserNo,lPassWord,lMd5 : String;
begin
  Result := 1;
  lUserNo:=UserNo;
  lPassWord:=PassWord;
  lMd5 := LogEntry(MD5String(String(lUserNo)+String(lPassWord)));

  lSqlText := 'select UserID,UserName,userpwd,flag from UserInfo where UserNo=:UserNo and USERPWD=:USERPWD';
  Conn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    with temQ do
    begin
      Close;
      SQL.Clear;
      SQL.Add(lSqlText);
      Parameters.ParamByName('UserNo').Value := lUserNo;
      Parameters.ParamByName('USERPWD').Value := lMd5;
      Open;
      if RecordCount = 0 then //查到记录为O，代表身份不存在
      begin
        result:=0;  //用户不存在
        Exit;
      end
      else
      begin
        userid := FieldByName('UserID').AsInteger;
      end;
    end;
  finally
    FreeExistAdoquery(temQ);
    LDM_MTS.ADOConnPool.FreeConnection(Conn);
  end;
end;


function TRDM_MTS.ExecBatchSQL(OwnerData: OleVariant): OleVariant;
var
  Conn: TAdoConnection;
  i : integer;
  LowArr, HighArr: integer;
begin
  {Wrap the updates in a transaction. If any step results in an error, raise}
  {an exception, which will Rollback the transaction.}
  Conn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  try
    //Conn.BeginTrans; //申请得到一个连接后，自动启动事务的，所以不需要这句
    try
      LowArr:=VarArrayLowBound(OwnerData,1);
      HighArr:=VarArrayHighBound(OwnerData,1);
      for i:=LowArr to HighArr do
        ExecTheSQL(Conn, OwnerData[i]);
      Conn.CommitTrans;
      Result:=true;
    except
      Conn.RollbackTrans;
      Result:=false;
    end;
  finally
    LDM_MTS.ADOConnPool.FreeConnection(Conn);
  end;
end;

procedure TRDM_MTS.ExecTheSQL(TheAdoConn: TADOConnection;
  OwnerData: OleVariant);
var
  s :string;
begin
  with Aq_General_data do
  begin
    Close;
    Connection:=TheAdoConn;
    SQL.Text := GetSQLSentence(TheAdoConn,OwnerData);
    s := sql.text;
    ExecSQL;
    Close;
  end;
end;

function TRDM_MTS.ProduceFlowNumID(const l_FLowName: WideString;
  l_SeriesNum: Integer): Integer;
var
  Conn: TAdoConnection;
begin
  Conn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then Conn.CommitTrans;
  try
    Result:=GetFlowNumID(Conn,l_FLowName,l_SeriesNum);
  finally
    LDM_MTS.ADOConnPool.FreeConnection(Conn);
  end;
end;
procedure TRDM_MTS.RemoteDataModuleCreate(Sender: TObject);
begin
  FGisConn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  if FGisConn.InTransaction then FGisConn.CommitTrans;
  ADOQueryGIS.Connection:= FGisConn;
end;

procedure TRDM_MTS.RemoteDataModuleDestroy(Sender: TObject);
begin
  LDM_MTS.ADOConnPool.FreeConnection(FGisConn);
end;

function TRDM_MTS.CollectServerMsg(EventId, cityid: Integer;
  const Msg: WideString): OleVariant;
begin
  result := Fm_MTS_Server.CollectServerSendMsg(EventID,cityid,Msg);
end;

function TRDM_MTS.ChangePassword(const OldPassword, NewPassword,
  UserNo: WideString): Smallint;
var
  lSqlText: string;
  lPassWord,lMd5_Old,lMd5_New : String;
  Conn: TAdoConnection;
  temQ : TADoQuery;
begin
  Result := 1;
  lPassWord:=OldPassword;
  lMd5_Old := LogEntry(MD5String(String(UserNo)+String(lPassWord)));
  lPassWord:=NewPassword;
  lMd5_New := LogEntry(MD5String(String(UserNo)+String(lPassWord)));

  lSqlText := 'update UserInfo set userpwd='''+lMd5_New+''' where UserNo=' + '''' + UserNo + ''' and '+
      ' userpwd=''' + lMd5_Old + '''';
  Conn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    temQ.Close;
    temQ.SQL.Text:=  lSqlText ;
    temQ.Prepared:=true;
    if temQ.ExecSQL>0 then
      result:=0;
  finally
    FreeExistAdoquery(temQ);
    LDM_MTS.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TRDM_MTS.GetTheSequenceId(const Seqname: WideString): Integer;
var
  sqlstr: string;
  Conn: TAdoConnection;
  temQ : TADoQuery;
begin
  Result := -1;
  sqlstr :='select '+Trim(Seqname)+'.Nextval as ID from dual';
  Conn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    temQ.Close;
    temQ.SQL.Clear;
    temQ.SQL.Add(sqlstr);
    temQ.Prepared:=true;
    temQ.Open;
    Result:=temQ.FieldByName('ID').AsInteger;
    temQ.Close;
  finally
    FreeExistAdoquery(temQ);
    LDM_MTS.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TRDM_MTS.GetRingRemind(aCityID, aUserID, aRemindType: Integer;
  out vIsRing: Integer; out vWavName: WideString): Integer;
var
  CurrConn: TAdoConnection;
  temQ:TADOQuery;
  lSqlStr: string;
begin
  Result := 0;
  CurrConn:=LDM_MTS.ADOConnPool.GetConnection as TADOConnection;
  temQ := GetNewAdoquery(CurrConn);
  try
    try
      with temQ do
      begin
        Close;
        sql.Clear;
        lSqlStr:= 'select a.cityid,a.companyid,c.userid,c.isUserRing,b.setvalue Wav' +
                  '  from alarm_ringremind_info a' +
                  '  left join alarm_sys_function_set b' +
                  '    on a.cityid=b.cityid and b.kind=2 and b.code=' + IntToStr(aRemindType) +
                  '  left join (select t.cityid, t.userid, nvl(t1.setvalue,0) as isUserRing' +
                  '               from userinfo t' +
                  '               left join alarm_sys_function_set t1' +
                  '                 on t.cityid=t1.cityid and t.userid=t1.code and t1.kind=1 and t1.content=''' + IntToStr(aRemindType) +
                  '''           ) c on a.cityid=c.cityid ' +
                  ' where a.isremind=1 and a.remindtype=' + IntToStr(aRemindType) +
                  '   and a.cityid=' + IntToStr(aCityid) +
                  '   and c.userid=' + IntToStr(aUserID);
        SQl.Add(lSqlStr);
        Open;
        if recordcount=0 then//没有告警
        begin
          result:= 1;
          vIsRing:= 0;
          vWavName:= '';
        end
        else if recordcount=1 then
        begin
          result:= 1;
          vIsRing:= FieldByName('isUserRing').AsInteger;
          vWavName:= FieldByName('Wav').AsString;
        end
        else
          result:= -1;
      end;
    except
      result:= -1;
    end;
  finally
    FreeExistAdoquery(temQ);
    LDM_MTS.ADOConnPool.FreeConnection(CurrConn);
  end;
end;

initialization
  TComponentFactory.Create(ComServer, TRDM_MTS,
    Class_RDM_MTS, ciMultiInstance, tmApartment);
  ComServer.UpdateRegistry(true);
end.
