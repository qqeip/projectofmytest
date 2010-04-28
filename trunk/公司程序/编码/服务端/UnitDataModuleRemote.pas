unit UnitDataModuleRemote;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, ProjectCFMS_Server_TLB, StdVcl, ADODB, Variants, DB, Provider,
  md5, ComCtrls;

type
  PArrayData = ^TArrayData;
  TArrayData = array[0..1000] of Olevariant;

  TDataModuleRemote = class(TRemoteDataModule, IDataModuleRemote)
    DataSetProvider1: TDataSetProvider;
    DataSetProvider2: TDataSetProvider;
    DataSetProvider3: TDataSetProvider;
    DataSetProvider4: TDataSetProvider;
    DataSetProvider5: TDataSetProvider;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    ADOQuery3: TADOQuery;
    ADOQuery4: TADOQuery;
    ADOQuery5: TADOQuery;
    DataSetProvider: TDataSetProvider;
    ADOQuery: TADOQuery;
    DataSetProviderWav: TDataSetProvider;
    ADOQueryWav: TADOQuery;
  private
    function GetSQLSentence(aConn: TADOConnection; aOwnerData: OleVariant):String;
    function LogEntry(Dig: MD5Digest): string;
    procedure ApplyDelta(aProvider: OleVariant; var aDelta : OleVariant);
    procedure ExecTheSQL(aConn:TADOConnection; aOwnerData: OleVariant);
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
    //获取序列号
    function GetSequence(const aSeqName: WideString): Integer; safecall;
    //修改密码
    function ChangePassword(const aUserNo: WideString; aCityid: Integer;
      const aOldPSW, aNewPSW: WideString): OleVariant; safecall;
    //获取数据集
    function GetCDSData(aOwnerData: OleVariant; aDSPID: Integer): OleVariant;
      safecall;
    //更新数据集某字段，提交数据库
    function CDSApplyUpdates(var aDetailArray: OleVariant; aProviderArray,
      aOwnerData: OleVariant): OleVariant; safecall;
    //执行SQL数组，可用于插入更新
    function ExecBatchSQL(aOwnerData: OleVariant): OleVariant; safecall;
    function Login(const aUserNo, aPassword: WideString; out aUserid, aCityid,
      aCompanyid: Integer; out aCompanyidstr: WideString;
      out aManagePrive: Integer): Integer; safecall;
    //用户上线登记  0 失败 1 成功
    function AddUser(const aUserNo, aIP: WideString): Integer; safecall;
    //用户下线登记  0 失败 1 成功
    function DelUser(const aUserNo, aIP: WideString): Integer; safecall;
    //获取系统时间
    function GetSystemDateTime: TDateTime; safecall;
    function GetMD5(const aUserNo, aPSW: WideString): WideString; safecall;

    //驳回消障
    function CancelClearFault(aCityid, aCompanyid, aBatchid,
      aOperator: Integer; const aReason: WideString): Integer; safecall;
    //排除告警
    function RemoveFault(VCityID, VCompanyID, PBatchID, VOperator: Integer;
      const VAlarmIDS: WideString): Integer; safecall;
    //删除告警
    function DeleteFault(VCityID, VCompanyID, PBatchID, VOperator: Integer;
      const VAlarmIDS, VReason: WideString): Integer; safecall;
      //手动提交
    function SubmitFault(VCityID, VCompanyID, VBatchid, VOperator, VCauseCode,
      VResolventCode: Integer; const VRevertCause: WideString): Integer;
      safecall;
    //确认消障
    function ClearFault(VCityid, VCompanyid, VBatchid,
      VOperator: Integer): Integer; safecall;
    function ReturnFault(VCityID, VCompanyID: Integer;
      const VReturnCompanyIDS: WideString; PBatchID: Integer;
      const VAlarmIDS: WideString; VIsDel: WordBool;
      const VReturnMark: WideString; VOperator: Integer): Integer;
      safecall;
    //转为疑难
    function StayFault(VCityID, VCompanyID, VBatchid: Integer;
      const VStayCause: WideString; VStayIntever, VStayRemind,
      VOperator: Integer): Integer; safecall;
    //设备缺失再派
    function DeviceLostResend(VCityid: Integer;
      const VDeviceids: WideString): Integer; safecall;
      //设备集更新 (未配置维护单位设备)
    function DeviceGatherSet(VCityid, VDevGatherID,
      VDeviceid: Integer): Integer; safecall;
      //疑难再派
    function StayResendFault(VCityID, VCompanyID, VBatchid,
      VOperator: Integer): Integer; safecall;
      //干预派障
    function ContinueSendFault(VCityID: Integer; const VCompanyIDS: WideString;
      VDeviceid, VCoDeviceID, VAlarmContentCode: Integer;
      const VReason: WideString; VOperator: Integer): Integer; safecall;
    //日志流程
    function AlarmProc(aCityid, aCompanyid, aBatchid, aOperateFlag: Integer;
      const aAlarmids: WideString; aOperator: Integer): Integer; safecall;
    function AlarmProcs(aCityid, aCompanyid: Integer;
      const aBatchids: WideString; aOperateFlag: Integer;
      const aAlarmids: WideString; aOperator: Integer): Integer; safecall;
  // 手动派障
    function IDataModuleRemote_MaunalSendFault(VCityID,
      VCompanyID, VDeviceid, VCoDeviceID, VAlarmContentCode: Integer;
      const VRemark: WideString; VOperator, VIsGotoAlarmManual, VRepeatCoDevice,
      VRepeatContentCode: Integer): Integer; safecall;
    function GetFlowNum(const aFlowName: WideString;
      aFlowCount: Integer): OleVariant; safecall;
    function CompanyMgr(VCityID, VCompanyID: Integer; const VGatherIDStr,
      vAlarmCodeStr: WideString; VOperator: Integer;
      vSqlVariant: OleVariant): Integer; safecall;  function IDataModuleRemote.MaunalSendFault = IDataModuleRemote_MaunalSendFault;
    function AlarmQueryStatus(VCityID, VDeviceid, VCoDeviceID,
      VAlarmContentCode, VOperator: Integer): Integer; safecall;
    function GetRingRemind(aCityid, aUserid, aRemindtype: Integer;
      out vIsRing: Integer; out vWavName: WideString): Integer; safecall;

    //调用存储过程错误编码说明
    //0 正常 -1 存储过程内部执行异常错误 -2 调用存储过程失败，可能是存储过程失效，重新编译存储过程
    //-3 接口异常错误 <-3 接口未成功执行的编码原因 >0 为存储过程执行返回的未成功执行的编码原因


  public
    { Public declarations }
  end;

var
  Cr: TRTLCriticalSection;

implementation

uses UnitDataModuleLocal, UnitComponentFactory, UnitServerMain;

{$R *.DFM}

class procedure TDataModuleRemote.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
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

function TDataModuleRemote.GetSequence(
  const aSeqName: WideString): Integer;
var
  lSqlstr: string;
  Conn: TADOConnection;
  temQ : TADoQuery;
begin
  Result := -1;
  lSqlstr :='select '+Trim(aSeqName)+'.Nextval as ID from dual';
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    temQ.Close;
    temQ.SQL.Clear;
    temQ.SQL.Add(lSqlstr);
    temQ.Prepared:=true;
    temQ.Open;
    Result:=temQ.FieldByName('ID').AsInteger;
    temQ.Close;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

//0失败 1 成功
function TDataModuleRemote.ChangePassword(const aUserNo: WideString;
  aCityid: Integer; const aOldPSW, aNewPSW: WideString): OleVariant;
var
  lSqlstr: string;
  lPassWord,lMd5_Old,lMd5_New : String;
  Conn: TADOConnection;
  temQ : TADoQuery;
begin
  Result := 0;
  lPassWord:=aOldPSW;
  lMd5_Old := LogEntry(MD5String(String(aUserNo)+String(lPassWord)));
  lPassWord:=aNewPSW;
  lMd5_New := LogEntry(MD5String(String(aUserNo)+String(lPassWord)));

  lSqlstr := 'update fms_user_info set userpwd='''+lMd5_New+''' where userno=' + '''' + aUserNo + ''' and '+
      ' userpwd=''' + lMd5_Old + ''' and cityid='+inttostr(aCityid)+'';
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    temQ.Close;
    temQ.SQL.Clear;
    temQ.SQL.Add(lSqlstr);
    temQ.Prepared:=true;
    if temQ.ExecSQL> 0 then
      result:= 1;
    temQ.Close;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.GetCDSData(aOwnerData: OleVariant;
  aDSPID: Integer): OleVariant;
var
  Conn: TAdoConnection;
  CurrDsp: TDataSetProvider;
  s :string;
begin
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;

  try
    case aDSPID of
      1 : CurrDsp:= DataSetProvider1;
      2 : CurrDsp:= DataSetProvider2;
      3 : CurrDsp:= DataSetProvider3;
      4 : CurrDsp:= DataSetProvider4;
      5 : CurrDsp:= DataSetProvider5;
      6 : CurrDsp:= DataSetProviderWav;//告警语音提示
    else
      CurrDsp:=DataSetProvider;
    end;

    with TADOQuery(CurrDsp.DataSet) do
    begin
      Close;
      Connection:=Conn;
      SQL.Text := GetSQLSentence(Conn,aOwnerData);
      s := sql.text;
      Open;
      Result:=CurrDsp.Data;
      Close;
    end;
  finally
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
    aOwnerData := NULL;
  end;
end;

function TDataModuleRemote.GetSQLSentence(aConn: TADOConnection;
  aOwnerData: OleVariant): String;
var
  lSqlType: integer;
  lSqlCode: integer;
  lSqlSentence: string;
  lSqlstr: string;
  Conn: TADOConnection;
  temQ: TADoQuery;
  I: integer;
  lParamName: string;
begin
  result:= '';
  lSqlType:= VarAsType(aOwnerData[0],varInteger);
  lSqlCode:= VarAsType(aOwnerData[1],varInteger);
  lSqlstr:= 'select * from fms_sql_info t where t.sqltype='+inttostr(lSqlType)+' and t.sqlbh='+inttostr(lSqlCode);
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    temQ.Close;
    temQ.SQL.Clear;
    temQ.SQL.Add(lSqlstr);
    temQ.Prepared:=true;
    temQ.Open;
    if temQ.RecordCount=1 then
    begin
      lSqlSentence:= temQ.FieldByName('SQL').AsString;
      if varArrayHighBound(aOwnerData, 1)> 1 then
        for i := varArrayLowBound(aOwnerData, 1)+2 to varArrayHighBound(aOwnerData, 1) do
        begin
          lParamName:= '@Param'+inttostr(i-1);
          lSqlSentence:= StringReplace(lSqlSentence, lParamName, aOwnerData[i], [rfReplaceAll, rfIgnoreCase]);
        end;
      result:= lSqlSentence;
    end;
    temQ.Close;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.LogEntry(Dig: MD5Digest): string;
begin
  Result := Format('%s', [MD5Print(Dig)]);
end;

function TDataModuleRemote.CDSApplyUpdates(var aDetailArray: OleVariant;
  aProviderArray, aOwnerData: OleVariant): OleVariant;
var
  Conn: TADOConnection;
  i : integer;
  LowArr, HighArr: integer;
  P: PArrayData;
begin
  {Wrap the updates in a transaction. If any step results in an error, raise}
  {an exception, which will Rollback the transaction.}
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  //Conn.BeginTrans; //申请得到一个连接后，自动启动事务的，所以不需要这句
  try
    if varIsArray(aOwnerData) then
    begin
      LowArr:=VarArrayLowBound(aOwnerData,1);
      HighArr:=VarArrayHighBound(aOwnerData,1);
      for i:=LowArr to HighArr do
        ExecTheSQL(Conn, aOwnerData[i]);
    end;

    LowArr:=VarArrayLowBound(aDetailArray,1);
    HighArr:=VarArrayHighBound(aDetailArray,1);
    P:=VarArrayLock(aDetailArray);
    try
      for i:=LowArr to HighArr do
        ApplyDelta(aProviderArray[i], P^[i]);
    finally
      VarArrayUnlock(aDetailArray);
    end;

    Conn.CommitTrans;
    Result:=true;
  except
    Conn.RollbackTrans;
    Result:=false;
  end;
  DataModuleLocal.ADOConnPool.FreeConnection(Conn);
end;

procedure TDataModuleRemote.ApplyDelta(aProvider: OleVariant;
  var aDelta: OleVariant);
var
  lErrCount : integer;
  lOwnerData: OleVariant;
begin
  if not VarIsNull(aDelta) then
  begin
    aDelta := AS_ApplyUpdates(aProvider, aDelta, 0, lErrCount, lOwnerData);
    if lErrCount > 0 then
      SysUtils.Abort;  // This will cause Rollback in the calling procedure
  end;
end;

function TDataModuleRemote.ExecBatchSQL(
  aOwnerData: OleVariant): OleVariant;
var
  Conn: TADOConnection;
  i : integer;
  LowArr, HighArr: integer;
begin
  {Wrap the updates in a transaction. If any step results in an error, raise}
  {an exception, which will Rollback the transaction.}
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  try
    //Conn.BeginTrans; //申请得到一个连接后，自动启动事务的，所以不需要这句
    try
      LowArr:=VarArrayLowBound(aOwnerData,1);
      HighArr:=VarArrayHighBound(aOwnerData,1);
      for i:=LowArr to HighArr do
        ExecTheSQL(Conn, aOwnerData[i]);
      Conn.CommitTrans;
      Result:=true;
    except
      Conn.RollbackTrans;
      Result:=false;
    end;
  finally
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;
//返回结果 0 失败 1成功
//用户名全网不能重复
function TDataModuleRemote.Login(const aUserNo, aPassword: WideString;
  out aUserid, aCityid, aCompanyid: Integer; out aCompanyidstr: WideString;
  out aManagePrive: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  lSqlText: string;
  lUserNo,lPassWord,lMd5 : String;
begin
  Result := 0;
  lUserNo:=aUserNo;
  lPassWord:=aPassword;
  lMd5 := LogEntry(MD5String(String(lUserNo)+String(lPassWord)));

  lSqlText := 'select userid,userno,userpwd,cityid,deptid as companyid from fms_user_info'+
              ' where userno=:userno and userpwd=:userpwd';
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if not Conn.Connected then
  begin
    Result:= -1;
    exit;
  end;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      with temQ do
      begin
        Close;
        SQL.Clear;
        SQL.Add(lSqlText);
        Parameters.ParamByName('userno').Value := lUserNo;
        Parameters.ParamByName('userpwd').Value := lMd5;
        Open;
        if RecordCount = 1 then
        begin
          result:= 1;
          aUserid:= FieldByName('UserID').AsInteger;
          aCityid:= FieldByName('cityid').AsInteger;
          aCompanyid:= FieldByName('companyid').AsInteger;
          //获取当前维护单位的所有子维护单位
          lSqlText:= 'select a.*'+
                     ' from'+
                     ' (select ROW_NUMBER () OVER (PARTITION BY part ORDER BY lev DESC) rn,a.*'+
                     '   from'+
                     '   (SELECT  level AS Lev,level-rownum as part,a.*'+
                     '    FROM fms_company_info a start with  a.companyid='+inttostr(aCompanyid)+' CONNECT BY PRIOR a.companyid=a.parentid'+
                     '    order siblings  by a.companyid'+
                     '    ) a'+
                     ' ) a'+
                     ' where a.rn=1';
          Close;
          SQL.Clear;
          SQL.Add(lSqlText);
          Open;
          first;
          while not eof do
          begin
            aCompanyidstr:= aCompanyidstr+ FieldbyName('companyid').AsString+',';
            next;
          end;
          aCompanyidstr:= copy(aCompanyidstr,1,length(aCompanyidstr)-1);
          if length(aCompanyidstr)=0 then
            result:= 2;
          //获取管理权限
          if aUserNo= '管理员' then
          begin
            aManagePrive:= 0;
          end else
          begin
            lSqlText:= 'select min(a.priveflag) priveflag from fms_role_info a'+
                       ' left join fms_role_user_relat b on a.cityid=b.cityid and a.roleid=b.roleid'+
                       ' where b.cityid='+inttostr(aCityid)+' and b.userid='+inttostr(aUserid);
            Close;
            SQL.Clear;
            SQL.Add(lSqlText);
            Open;
            aManagePrive:= FieldbyName('priveflag').asinteger;
          end;
        end;
      end;
    except
      result:= 0;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

procedure TDataModuleRemote.ExecTheSQL(aConn: TADOConnection;
  aOwnerData: OleVariant);
var
  s :string;
  temQ: TADoQuery;
begin
  temQ := GetNewAdoquery(aConn);
  try
    temQ.Close;
    temQ.SQL.Clear;
    s := VarAsType(aOwnerData[0],varString);
    temQ.SQL.Add(s);
    temQ.Prepared:=true;
    temQ.ExecSQL;
    temQ.Close;
  finally
    FreeExistAdoquery(temQ);
  end;
end;

function TDataModuleRemote.AddUser(const aUserNo,
  aIP: WideString): Integer;
var
  lSqlstr: string;
  Conn: TADOConnection;
  temQ : TADoQuery;
  lListItem: TListItem;
  lSysDate: TDateTime;
begin
  Result := 0;
  lSysDate:= GetSystemDateTime;
  lSqlstr :='insert into userloginrecord (id, cityid, userno, ip, updatetime, status) values'+
            ' (cfms_seq_userlogin.Nextval, null, '''+aUserNo+''', '''+aIP+''', to_date('+FormatDateTime('yyyy-mm-dd hh:mm:ss',lSysDate)+',''yyyy-mm-dd hh24:mi:ss''), 1)';
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    temQ.Close;
    temQ.SQL.Clear;
    temQ.SQL.Add(lSqlstr);
    temQ.Prepared:=true;
    if temQ.ExecSQL> 0 then
    begin
      result:= 1;
      //界面增加
      EnterCriticalSection(Cr);
      try
        with FormServerMain.ListView do
        begin
          lListItem:= Items.Add;
          lListItem.Caption:= aIP;
          lListItem.SubItems.Add(aUserNo);
          lListItem.SubItems.Add('');
          lListItem.SubItems.Add('');
          lListItem.SubItems.Add(FormatDateTime('yyyy-mm-dd hh:mm:ss',lSysDate));
          Refresh;
        end;
      finally
        LeaveCriticalSection(Cr);
      end;
    end;
    temQ.Close;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;


function TDataModuleRemote.DelUser(const aUserNo,
  aIP: WideString): Integer;
var
  lSqlstr: string;
  Conn: TADOConnection;
  temQ : TADoQuery;
  I: integer;
  lSysDate: TDateTime;
begin
  Result := 0;
  lSysDate:= GetSystemDateTime;
  lSqlstr :='insert into userloginrecord (id, cityid, userno, ip, updatetime, status) values'+
            ' (cfms_seq_userlogin.Nextval, null, '''+aUserNo+''', '''+aIP+''', to_date('+FormatDateTime('yyyy-mm-dd hh:mm:ss',lSysDate)+',''yyyy-mm-dd hh24:mi:ss''), 0)';
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    temQ.Close;
    temQ.SQL.Clear;
    temQ.SQL.Add(lSqlstr);
    temQ.Prepared:=true;
    if temQ.ExecSQL> 0 then
    begin
      result:= 1;
      //界面删除
      EnterCriticalSection(Cr);
      try
        with FormServerMain.ListView do
        begin
          for I:= Items.Count - 1 downto 0 do
          begin
            if (uppercase(trim(Items.Item[i].Caption)) = uppercase(trim(aIP))) and
               (uppercase(trim(Items.Item[i].SubItems[0])) = uppercase(trim(aUserNo))) then
            begin
              Items.Delete(i);
              break;
            end;
          end;
          Refresh;
        end;
      finally
        LeaveCriticalSection(Cr);
      end;
    end;
    temQ.Close;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.GetSystemDateTime: TDateTime;
var
  lSqlstr: string;
  Conn: TADOConnection;
  temQ : TADoQuery;
begin
  Result := -1;
  lSqlstr :='select sysdate from dual';
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    temQ.Close;
    temQ.SQL.Clear;
    temQ.SQL.Add(lSqlstr);
    temQ.Prepared:=true;
    temQ.Open;
    Result:=temQ.FieldByName('sysdate').AsDateTime;
    temQ.Close;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.GetMD5(const aUserNo,
  aPSW: WideString): WideString;
begin
  result := LogEntry(MD5String(String(aUserNo)+String(aPSW)));
end;

function TDataModuleRemote.CancelClearFault(aCityid, aCompanyid, aBatchid, aOperator: Integer; const aReason: WideString): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close;
        Sql.Text:= 'update fault_master_online t set CANCELNOTE='''+aReason+''''+
                   ' where cityid='+inttostr(aCityid)+' and companyid='+inttostr(aCompanyid)+
                   ' and batchid='+inttostr(aBatchid);
        Prepared:=true;
        ExecSQL;

        close;
        Sql.Text:= '{call Fault_CancelClear_Proc ('+inttostr(aCityid)+','+inttostr(aCompanyid)+','+
                                                  inttostr(aBatchid)+','+inttostr(aOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[FAULT_CANCELCLEAR_PROC]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.RemoveFault(VCityID, VCompanyID, PBatchID,
  VOperator: Integer; const VAlarmIDS: WideString): Integer;
var
  lSqlstr: string;
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        {close;
        Sql.Text:= 'update fault_detail_online t set CANCELNOTE='''+aReason+''''+
                   ' where cityid='+inttostr(aCityid)+' and companyid='+inttostr(aCompanyid)+
                   ' and batchid='+inttostr(aBatchid);
        Prepared:=true;
        ExecSQL; }

        close;
        Sql.Text:= '{call Fault_Remove_Proc ('+inttostr(VCityID)+','+inttostr(VCompanyID)+','+
                                                  inttostr(PBatchID)+','''+VAlarmIDS+''','+inttostr(VOperator)+',:iError)}';
        lSqlstr:=SQL.Text;
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_Remove_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;


function TDataModuleRemote.DeleteFault(VCityID, VCompanyID, PBatchID,
  VOperator: Integer; const VAlarmIDS, VReason: WideString): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close;
        if PBatchID<> 0 then
        begin
          Sql.Text:= 'update fault_detail_online t set DELETECAUSE='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+' and companyid='+inttostr(VCompanyID)+
                   ' and batchid='+inttostr(PBatchID);

          Prepared:=true;
          ExecSQL;
          Sql.Text:= 'update fault_master_online t set DELETECAUSE='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+' and companyid='+inttostr(VCompanyID)+
                   ' and batchid='+inttostr(PBatchID);

          Prepared:=true;
          ExecSQL;
        end
        else
        begin
          Sql.Text:= 'update fault_detail_online t set DELETECAUSE='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+' and companyid='+inttostr(VCompanyID)+
                   ' and alarmid in '''+VAlarmIDS+'''';
          Prepared:=true;
          ExecSQL;
        end;

        close;         
        Sql.Text:= '{call Fault_Delete_Proc ('+inttostr(VCityID)+','+inttostr(VCompanyID)+','+
                                                  inttostr(PBatchID)+','''+VAlarmIDS+''','+inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_Delete_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.SubmitFault(VCityID, VCompanyID, VBatchid,
  VOperator, VCauseCode, VResolventCode: Integer;
  const VRevertCause: WideString): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        {close;
        if PBatchID<> 0 then
          Sql.Text:= 'update fault_detail_online t set DELETECAUSE='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+' and companyid='+inttostr(VCompanyID)+
                   ' and batchid='+inttostr(PBatchID)
        else
          Sql.Text:= 'update fault_detail_online t set DELETECAUSE='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+' and companyid='+inttostr(VCompanyID)+
                   ' and alarmid in '''+VAlarmIDS+'''';
        Prepared:=true;
        ExecSQL; }

        close;
        Sql.Text:= '{call Fault_Submit_Proc ('+inttostr(VCityID)+','+inttostr(VCompanyID)+','+
                                                  inttostr(VBatchid)+','+inttostr(VCauseCode)+','+
                                                  inttostr(VResolventCode)+','''+VRevertCause+''','+
                                                  inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_Submit_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.ClearFault(VCityid, VCompanyid, VBatchid,
  VOperator: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        {close;
        if PBatchID<> 0 then
          Sql.Text:= 'update fault_detail_online t set DELETECAUSE='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+' and companyid='+inttostr(VCompanyID)+
                   ' and batchid='+inttostr(PBatchID)
        else
          Sql.Text:= 'update fault_detail_online t set DELETECAUSE='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+' and companyid='+inttostr(VCompanyID)+
                   ' and alarmid in '''+VAlarmIDS+'''';
        Prepared:=true;
        ExecSQL; }

        close;         
        Sql.Text:= '{call Fault_Clear_Proc ('+inttostr(VCityID)+','+inttostr(VCompanyID)+','+
                                                  inttostr(VBatchid)+','+inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_Clear_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.ReturnFault(VCityID, VCompanyID: Integer;
  const VReturnCompanyIDS: WideString; PBatchID: Integer;
  const VAlarmIDS: WideString; VIsDel: WordBool;
  const VReturnMark: WideString; VOperator: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  iIsDel, liError: integer;
begin
  // 转发 只针对从障
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close; 
        Sql.Text:= 'update fault_detail_online t set RETURNREMARK='''+VReturnMark+''''+
                   ' where cityid='+inttostr(VCityID)+' and companyid='+inttostr(VCompanyID)+
                   ' and alarmid in ('+VAlarmIDS+')';
        Prepared:=true;
        ExecSQL;

        if VIsDel then
          iIsDel :=1
        else
          iIsDel :=0;

        close;         
        Sql.Text:= '{call Fault_Return_Proc ('+inttostr(VCityID)+','+inttostr(VCompanyID)+','''+ VReturnCompanyIDS+''','+
                                                  inttostr(0)+','''+VAlarmIDS+''','+inttostr(iIsDel)+','+inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;

        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;

        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_Return_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.StayFault(VCityID, VCompanyID,
  VBatchid: Integer; const VStayCause: WideString; VStayIntever,
  VStayRemind, VOperator: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close;

        Sql.Text:= 'insert into fault_stay_online (cityid, companyid, batchid, staycause, stayinterval, '+
                   ' stayenddate, stayremind, staytime, stayoperator) '+
                   ' select cityid, companyid, batchid, '''+VStayCause+''' staycause, '+inttostr(VStayIntever)+' stayinterval,'+
                   ' null stayenddate, '+inttostr(VStayRemind)+' stayremind, sysdate staytime, '+inttostr(VOperator)+' stayoperator'+
                   ' from fault_master_online t '+
                   ' where t.cityid='+inttostr(VCityID)+' and t.companyid='+inttostr(VCompanyID)+' and t.batchid='+inttostr(VBatchid);

        Prepared:=true;
        ExecSQL;

        close;
        Sql.Text:= '{call Fault_Stay_Proc ('+inttostr(VCityID)+','+inttostr(VCompanyID)+','+
                                                  inttostr(VBatchid)+','+inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_Stay_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.DeviceLostResend(VCityid: Integer;
  const VDeviceids: WideString): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
begin
  // -4 在告警设备在线表中找不到该设备或信息已补全!
  // -5 在设备信息表该设备信息尚为补全。
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin  
        close;
        Sql.Text:= 'select 1  from alarm_device_info t where t.cityid='+inttostr(VCityid)+
                   ' and t.deviceid in ('+VDeviceIDS+') and t.csid is null';
        Prepared:=true;
        Open;  
       if recordcount = 0 then
       begin
         result := -4;  // 在告警设备在线表中找不到该设备或信息已补全!
         raise Exception.Create('错误编号为: -4');
       end;

       close;
        Sql.Text:= 'select 1  from fms_device_info t where t.cityid='+inttostr(VCityid)+
                   ' and t.deviceid in ('+VDeviceIDS+') ';
        Prepared:=true;
        Open;
       if recordcount = 0 then
       begin
         result := -5;  // 在设备信息表该设备信息尚为补全。
         raise Exception.Create('错误编号为: -5');
       end;

       Sql.Text:= 'update alarm_device_info t set (areaid, branch, branchname, csid, bts_name, bts_level, bts_state, bts_label, bts_type, bts_kind,'+
                  'msc, bsc, lac, station_addr, bts_netstate, commonality_type, agent_manu, source_mode, iron_tower_kind)='+
                   '(select areaid, branch, branchname, csid, bts_name, bts_level, bts_state, bts_label, bts_type, bts_kind, '+
                   'msc, bsc, lac, station_addr, bts_netstate, commonality_type, agent_manu, source_mode, iron_tower_kind '+
                   'from fms_device_info a where t.cityid=a.cityid and t.deviceid=a.deviceid)'+
                   ' where t.cityid='+inttostr(VCityid)+' and t.deviceid in ('''+VDeviceIDS+''')';
        Prepared:=true;
        ExecSQL;  

        close;     

        Result:=0;
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.DeviceGatherSet(VCityid, VDevGatherID,
  VDeviceid: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close;  

        Sql.Text:= ' insert into fms_devicegather_detail (cityid, devicegatherid, deviceid)  values ('  +
                   inttostr(VCityid)+','+inttostr(VDevGatherID)+','+inttostr(VDeviceid)+')';

        Prepared:=true;
        ExecSQL; 
      end;
      Conn.CommitTrans;

      Result:=0;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.StayResendFault(VCityID, VCompanyID, VBatchid,
  VOperator: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin 
        close;         
        Sql.Text:= '{call Fault_StayResend_Proc ('+inttostr(VCityID)+','+inttostr(VCompanyID)+','+
                                                  inttostr(VBatchid)+','+inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_StayResend_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.ContinueSendFault(VCityID: Integer;
  const VCompanyIDS: WideString; VDeviceid, VCoDeviceID,
  VAlarmContentCode: Integer; const VReason: WideString;
  VOperator: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close;
        Sql.Text:= 'update alarm_data_collect t set Remark='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+  ' and DeviceID='+inttostr(VDeviceID)+' and CoDeviceID='+inttostr(VCoDeviceID)+
                   ' and ContentCode='+inttostr(VAlarmContentCode);
        Prepared:=true;
        ExecSQL;


        close;         
        Sql.Text:= '{call Fault_ContinueSendAlarm_Proc ('+inttostr(VCityID)+','''+VCompanyIDS+''','+
                                                  inttostr(VDeviceID)+','+inttostr(VCoDeviceID)+','+
                                                  inttostr(VAlarmContentCode)+','+inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_ContinueSendAlarm_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.AlarmProc(aCityid, aCompanyid, aBatchid,
  aOperateFlag: Integer; const aAlarmids: WideString;
  aOperator: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close;
        Sql.Text:= '{call Alarm_oprec ('+inttostr(aCityid)+','+inttostr(aCompanyid)+','+
            inttostr(aBatchid)+','+inttostr(aOperateFlag)+','''+aAlarmids+''','+inttostr(aOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        ExecSQL;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Alarm_oprec]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.AlarmProcs(aCityid, aCompanyid: Integer;
  const aBatchids: WideString; aOperateFlag: Integer;
  const aAlarmids: WideString; aOperator: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close;
        Sql.Text:= '{call Alarm_oprecs ('+inttostr(aCityid)+','+inttostr(aCompanyid)+','''+
            aBatchids+''','+inttostr(aOperateFlag)+','''+aAlarmids+''','+inttostr(aOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        ExecSQL;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Alarm_oprecs]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.GetFlowNum(const aFlowName: WideString;
  aFlowCount: Integer): OleVariant;
var
  Conn: TADOConnection;
begin
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  try
    result:= DataModuleLocal.ProduceFlowNumID(Conn,aFlowName,aFlowCount);
  finally
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.CompanyMgr(VCityID, VCompanyID: Integer;
  const VGatherIDStr, vAlarmCodeStr: WideString; VOperator: Integer;
  vSqlVariant: OleVariant): Integer;
var
  i, LowArr, HighArr: integer;
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;

      if not varisnull(vSqlVariant) then
      begin
        LowArr:=VarArrayLowBound(vSqlVariant,1);
        HighArr:=VarArrayHighBound(vSqlVariant,1);
        for i:=LowArr to HighArr do
          ExecTheSQL(Conn, vSqlVariant[i]);
      end;
      with temQ do
      begin
        close;         
        Sql.Text:= '{call Fault_Delete_Comp_ContentCode ('+inttostr(vCityID)+','+
                                                  inttostr(vCompanyID)+','''+
                                                  VGatherIDStr+''','''+
                                                  vAlarmCodeStr + ''','''+
                                                  inttostr(vOperator)+''',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -1;
          raise Exception.Create('删除告警错误，错误编号为: -1');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError
      end;
      Conn.CommitTrans;
      Result:=0;
    except
      Conn.RollbackTrans;
      Result:=-1;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.IDataModuleRemote_MaunalSendFault(VCityID,
  VCompanyID, VDeviceid, VCoDeviceID, VAlarmContentCode: Integer;
  const VRemark: WideString; VOperator, VIsGotoAlarmManual, VRepeatCoDevice,
  VRepeatContentCode: Integer): Integer;
var
  lSqlstr: string;
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError, lAlarmID: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        close;
        Sql.Text:= '{call Fault_ManualSendAlarm_Proc ('+inttostr(VCityID)+','+inttostr(VCompanyID)+','+
                                                  inttostr(VDeviceID)+','+inttostr(VCoDeviceID)+','+
                                                  inttostr(VAlarmContentCode)+','''+VRemark+''''+','+inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_ManualSendAlarm_Proc]失败')
        else
        begin
          if VIsGotoAlarmManual=1 then
          begin
            Close;
            SQL.Text:= 'select alarmid from fault_detail_online where cityid=' + inttostr(VCityID) +
                       ' and deviceid=' + inttostr(VDeviceID) +
                       ' and companyid=' + inttostr(VCompanyID) +
                       ' and codeviceid=' + inttostr(VCoDeviceID) +
                       ' and alarmcontentcode=' + inttostr(VAlarmContentCode) ;
            Open;
            lAlarmID:= FieldByName('alarmid').AsInteger;
            close;
            lSqlstr:= 'update ALARM_DATA_REP_COLLECT set ALARMID=' + IntToStr(lAlarmID) + ',' +
                       ' ISSEND=1' +
                       ' where cityid=' + inttostr(VCityID) +
                       ' and deviceid=' + inttostr(VDeviceID) +
                       ' and codeviceid=' + inttostr(VRepeatCoDevice) +
                       ' and contentcode=' + inttostr(VRepeatContentCode) ;
            Sql.Text:= lSqlstr;
            Prepared:=true;
            ExecSQL;
          end;
        end;
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

function TDataModuleRemote.AlarmQueryStatus(VCityID, VDeviceid,
  VCoDeviceID, VAlarmContentCode, VOperator: Integer): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  liError: integer;
begin
  Result := -3;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      Conn.BeginTrans;
      with temQ do
      begin
        {close;
        Sql.Text:= 'update alarm_data_collect t set Remark='''+VReason+''''+
                   ' where cityid='+inttostr(VCityID)+  ' and DeviceID='+inttostr(VDeviceID)+' and CoDeviceID='+inttostr(VCoDeviceID)+
                   ' and ContentCode='+inttostr(VAlarmContentCode);
        Prepared:=true;
        ExecSQL; }


        close;
        Sql.Text:= '{call Fault_Query_AlarmStatus_Proc ('+inttostr(VCityID)+','+inttostr(VDeviceID)+','+inttostr(VCoDeviceID)+','+
                                                  inttostr(VAlarmContentCode)+','+inttostr(VOperator)+',:iError)}';
        Parameters.ParamByName('iError').DataType:= ftInteger;
        Parameters.ParamByName('iError').Direction:=pdOutput;
        try
          ExecSQL;
        except
          Result := -2;
          raise Exception.Create('错误编号为: -2');
        end;
        liError:= Parameters.ParamByName('iError').Value;
        result:= liError;//接口的返回结果跟存储过程返回的一致
        close;
        if liError<>0 then
          raise Exception.Create('调用存储过程[Fault_Query_AlarmStatus_Proc]失败');
      end;
      Conn.CommitTrans;
    except
      Conn.RollbackTrans;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

//result -1 调用异常 0 未执行 1 调用成功
//vIsRing 0 不响铃  1 响铃
function TDataModuleRemote.GetRingRemind(aCityid, aUserid,
  aRemindtype: Integer; out vIsRing: Integer;
  out vWavName: WideString): Integer;
var
  Conn: TADOConnection;
  temQ : TADoQuery;
  lSqlStr: string;
begin
  Result := 0;
  Conn:=DataModuleLocal.ADOConnPool.GetConnection as TADOConnection;
  if Conn.InTransaction then  Conn.CommitTrans;
  temQ := GetNewAdoquery(Conn);
  try
    try
      with temQ do
      begin
        Close;
        lSqlStr:= 'select a.cityid,a.companyid,c.userid,c.isUserRing,b.setvalue Wav'+
                 ' from alarm_ringremind_info a'+
                 ' left join alarm_sys_function_set b'+
                 ' on a.cityid=b.cityid and a.alarmlevel=b.code and b.kind=30 and b.content='''+inttostr(aRemindtype)+''''+
                 ' left join (select t.cityid,t.deptid as companyid,'+
                 '           t.userid,nvl(t1.setvalue,1) as isUserRing'+
                 '           from fms_user_info t'+
                 '           left join alarm_sys_function_set t1'+
                 '           on t.cityid=t1.cityid and t.userid=t1.code and t1.kind=35 and t1.content='''+inttostr(aRemindtype)+''') c'+
                 ' on a.cityid=c.cityid and a.companyid=c.companyid'+
                 ' where a.cityid=:Cityid and a.remindtype=:remindtype and c.userid=:userid and a.isremind=1';
        SQL.Clear;
        SQL.Add(lSqlStr);
        Parameters.ParamByName('Cityid').Value := aCityid;
        Parameters.ParamByName('userid').Value := aUserid;
        Parameters.ParamByName('remindtype').Value := aRemindtype;
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
        else result:= -1;
      end;
    except
      result:= -1;
    end;
  finally
    FreeExistAdoquery(temQ);
    DataModuleLocal.ADOConnPool.FreeConnection(Conn);
  end;
end;

initialization
  TComponentFactory.Create(ComServer, TDataModuleRemote,
    Class_DataModuleRemote, ciMultiInstance, tmApartment);
end.
