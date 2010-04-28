unit UntAlarmAdjustThread;

interface

uses
  Classes, UntBaseDBThread, ComCtrls, StdCtrls, ADODB, SysUtils;

type
  TAlarmAdjustThread = class(TBaseDBThread)
  private
    blSendToMTS, blSaveErrLog: boolean;
    sCityID: string;
    slServerIP: TStringList;

    Ado_HWDBConn: TADOConnection;
    Ado_HWQuery: TADOQuery;

    procedure DoAlarmCollect;
    function PrepareSimulateClearAlarmEvn: boolean;      //准备模拟Clear告警数据环境
    procedure SingleAlarmSync(ServerBH: Integer; ServerIP: string);   
    procedure SyncWGAlarm(ServerBH: Integer);
    procedure SendAlarmData;
    procedure SendSimulateClearAlarmData; //派发Clear告警      


    //---------------------------内部调用功能函数-------------------------------   
    function  ConnectHWDB(ServerIP: string): boolean;   //连接HW数据库
    procedure OpenHWQuery(strSQL: string);    //查询数据
    function InitServerIP: boolean;
    function GetDeviceID(sAlarmLocation: string): string;
    function GetCoDeviceID(ContentCode: Integer; sAlarmLocation: string): string;
    function GetErrorContent(contentcode: integer; sAlarmLocation: string): string;
  protected
    procedure DoExecute; override;
  public
    constructor Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
    destructor Destroy; override;  
  end;

implementation     

{ TAlarmAdjustThread }

constructor TAlarmAdjustThread.Create(DBConn: string; reRunLog: TRichEdit; btRunThread: TButton);
begin
  inherited Create(DBConn, reRunLog, btRunThread);
  blDebug := true;
  blSendToMTS := false;
  blSaveErrLog := false;  
  sCityID := '571';

  Ado_HWDBConn := TADOConnection.Create(nil);
  Ado_HWDBConn.LoginPrompt:=false;  

  Ado_HWQuery := TAdoQuery.Create(nil);
  Ado_HWQuery.Connection := Ado_HWDBConn;
  Ado_HWQuery.LockType := ltBatchOptimistic;

  slServerIP := TStringList.Create;
end;

destructor TAlarmAdjustThread.Destroy;
begin
  Ado_HWQuery.Close;
  Ado_HWQuery.Free;  
  Ado_HWDBConn.Close;
  Ado_HWDBConn.Free;

  slServerIP.Free;

  inherited;
end; 

procedure TAlarmAdjustThread.DoExecute;
var
  StartTime,EndTime: TDateTime;
begin 
  self.AppendRunLog('开始执行 告警数据采集。。。', true);
  StartTime := Now;

  if not ConnectDB then exit;

  DoAlarmCollect;

  EndTime := Now;
  self.AppendRunLog('告警数据采集 执行完成。本次执行共花费时间：'+ GetBetweenTime(StartTime, EndTime), true);
end;

procedure TAlarmAdjustThread.DoAlarmCollect;
var  
  I: Integer;
begin
  if not InitServerIP then exit;
  if not PrepareSimulateClearAlarmEvn then exit;
  
  for I := 0 to slServerIP.Count-1 do
  begin
    AppendRunLog('开始服务器：'+IntToStr(I+1)+'告警数据采集。。。');
    SingleAlarmSync(I, slServerIP[I]);
    AppendRunLog('服务器：'+IntToStr(I+1)+'告警数据采集结束。。。');
  end; 

  Ado_DBConn.BeginTrans;
  try
    SendAlarmData;
    SendSimulateClearAlarmData;

    Ado_DBConn.CommitTrans;
  except
    on E: Exception do
    begin
      self.AppendRunLog('派发告警失败！'+E.Message, true);
      Ado_DBConn.RollbackTrans;
    end;
  end;     

end;

function TAlarmAdjustThread.PrepareSimulateClearAlarmEvn: boolean;
var
  TableFields, TableFieldsT, DataSQL: string;    
begin
  Result := false;
     
  TableFields := 'alarmautoid, alarmtype, deviceid, codeviceid, contentcode, isalarm, createtime, collectid, errorcontent, '+
                 'cityid, isprocess, collectionkind, collectioncode, serverid';
  TableFieldsT := 't.alarmautoid, 1 alarmtype, t.deviceid, t.codeviceid, t.contentcode, 1 isalarm, t.createtime, t.collectid, '+
                  't.errorcontent, '+sCityID+' cityid, null isprocess, 1 collectionkind, 1 collectioncode, 0 serverid';
                  
  Ado_DBConn.BeginTrans;
  try
    ExecSQL('delete ALARM_DATA_HUAWEI_COMP');

    DataSQL := 'insert into ALARM_DATA_HUAWEI_COMP ' +
             '( '+TableFields +') select '+TableFieldsT+' from alarm_data_huawei_WG_view t';  
    ExecSQL(DataSQL);  

    Ado_DBConn.CommitTrans;
    Result := true;
  except
    on E: Exception do
    begin
      blSaveErrLog := true;
      AppendRunLog('保存告警比较数据异常！'+E.Message, true);
      Ado_DBConn.RollbackTrans;
    end;
  end; 
end;

procedure TAlarmAdjustThread.SingleAlarmSync(ServerBH: Integer; ServerIP: string);
begin
  if not ConnectHWDB(ServerIP) then exit;
  
  Ado_DBConn.BeginTrans;
  try
    SyncWGAlarm(ServerBH);

    Ado_DBConn.CommitTrans;
  except
    on E: Exception do
    begin
      self.AppendRunLog('华为网管在线告警数据获取失败！服务器编号：'+IntToStr(ServerBH+1)+E.Message, true);
      Ado_DBConn.RollbackTrans;
    end;
  end;  
end;

procedure TAlarmAdjustThread.SyncWGAlarm(ServerBH: Integer);
var
  OpDate: TDateTime;
  sExtendInfo, sERRORCONTENT: string;
  iContentCode: Integer;
begin      
  OpenQuery('select id, serverid, opdate, ContentCode, CreateTime, ExtendInfo, deviceid, codeviceid, errorcontent from alarm_data_huawei_wg_on t where 1=2');
  OpDate := now;
  OpenHWQuery('select Csn, Id as ContentCode, dateadd(ss,OccurTime,''1970-1-1 00:00:00'') as CreateTime, ExtendInfo from tbl_cur_alm where IsCleared=0');
  if Ado_HWQuery.IsEmpty then exit;

  Ado_HWQuery.First;
  while not Ado_HWQuery.Eof do
  begin
    Ado_Query.Append;
    Ado_Query.FieldByName('ID').AsInteger := Ado_HWQuery.FieldByName('csn').AsInteger;
    Ado_Query.FieldByName('serverid').AsInteger := ServerBH;
    Ado_Query.FieldByName('opdate').AsDateTime := OpDate;
    Ado_Query.FieldByName('ContentCode').AsInteger := Ado_HWQuery.FieldByName('ContentCode').AsInteger;
    Ado_Query.FieldByName('CreateTime').AsDateTime := Ado_HWQuery.FieldByName('CreateTime').AsDateTime;
    Ado_Query.FieldByName('ExtendInfo').AsString := Ado_HWQuery.FieldByName('ExtendInfo').AsString;

    sExtendInfo := Ado_HWQuery.FieldByName('ExtendInfo').AsString;
    iContentCode := Ado_HWQuery.FieldByName('ContentCode').AsInteger;
    
    Ado_Query.FieldByName('DeviceID').Value := GetDeviceID(sExtendInfo);
    Ado_Query.FieldByName('CODeviceID').Value := GetCoDeviceID(iContentCode, sExtendInfo);
    Ado_Query.FieldByName('errorcontent').Value := GetErrorContent(iContentCode, sExtendInfo);

    if iContentCode = 2312 then
    begin
      sERRORCONTENT := trim(Ado_Query.FieldByName('errorcontent').AsString);
      if sERRORCONTENT <> '' then
      begin
        if pos('1X', sERRORCONTENT) > 0 then Ado_Query.FieldByName('ContentCode').Value := 231200001;
      end;
    end
    else if iContentCode = 1310 then
    begin
      sERRORCONTENT := trim(Ado_Query.FieldByName('errorcontent').AsString);
      if sERRORCONTENT <> '' then
      begin
        if pos('1X', sERRORCONTENT) > 0 then Ado_Query.FieldByName('ContentCode').Value := 131000001;
      end;
    end;

    Ado_Query.CheckBrowseMode;
        
    Ado_HWQuery.Next;
  end;

  ExecSQL('delete alarm_data_huawei_wg_on t where t.serverid='+inttostr(ServerBH));

  Ado_Query.CheckBrowseMode;
  Ado_Query.UpdateBatch;
end;

procedure TAlarmAdjustThread.SendAlarmData;
var
  DataSQL: string;

  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  strBH : String;
begin
  AppendRunLog('开始告警数据派发。。。');

  Present:= Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  strBH := Format('%.4d',[Year])+Format('%.2d',[month])+Format('%.2d',[day])+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+Format('%.4d',[MSec]);

  //into gather history    现在 alarm_data_gather_history 用在分析线程里
  DataSQL := 'insert into alarm_data_gather_history '+
    '(alarmautoid, collectid, deviceid, codeviceid, contentcode, isalarm, createtime, operatetime, BH) '+
    'select t.alarmautoid, t.collectid, t.deviceid, t.codeviceid, t.contentcode, 1 isalarm, t.createtime, sysdate operatetime, '+strBH+' BH '+
    'from alarm_data_huawei_WG_view t';
  try
    ExecSQL(DataSQL);
  except  
    on E: Exception do
    begin
      blSaveErrLog := true;
      AppendRunLog('alarm_data_gather进历史表出错。'+E.Message, true);
    end;
  end;    

  {DataSQL := 'insert into alarm_data_gather '+
    '(alarmautoid, alarmtype, deviceid, CODEVICEID, contentcode,ISALARM,createtime, '+
    'collectid,errorcontent,cityid,isprocess,collectionkind,collectioncode,ALARMLOCATION) '+
    'select t.alarmautoid, 1 alarmtype,t. deviceid, t.codeviceid, t.contentcode, 1 isalarm, t.createtime, '+
    't.collectid, t.errorcontent, '+sCityID+' cityid, null isprocess, 1 collectionkind, 1 collectioncode,t.ALARMLOCATION '+
    'from alarm_data_huawei_WG_view t '+
    'left join alarm_data_gather a '+
    'on a.cityid='+sCityID+' and a.collectid=t.collectid '+
    'where a.collectid is null';  }
  DataSQL := 'insert into alarm_data_gather '+
    '(alarmautoid, alarmtype, deviceid, CODEVICEID, contentcode,ISALARM,createtime, '+
    'collectid,errorcontent,cityid,isprocess,collectionkind,collectioncode,ALARMLOCATION) '+
    'select t.alarmautoid, 1 alarmtype,t. deviceid, t.codeviceid, t.contentcode, 1 isalarm, t.createtime, '+
    't.collectid, t.errorcontent, '+sCityID+' cityid, null isprocess, 1 collectionkind, 1 collectioncode,t.ALARMLOCATION '+
    'from alarm_data_huawei_WG_view t '+
    'left join alarm_data_gather a '+
    'on a.cityid='+sCityID+' and a.DEVICEID=t.DEVICEID and a.CODEVICEID=t.CODEVICEID and a.CONTENTCODE=t.CONTENTCODE '+   
    'where a.DEVICEID is null'; 
  ExecSQL(DataSQL);

  if blSendToMTS then
  begin
    DataSQL := 'insert into mtu_alarm_assistant '+
    '(id, csid, sector, contentcode, ServerID, collecttime ) '+
    'select collectid id, DEVICEID csid, CODEVICEID sector, contentcode, 0 ServerID, '+
    'createtime collecttime '+
    'from alarm_data_huawei_WG_view '+
    'where collectid not in (select id from mtu_alarm_assistant)';

    try
      ExecSQL(DataSQL);
    except
      on E: Exception do
      begin
        AppendRunLog('向MTS系统派发告警数据失败！'+E.Message);
      end;
    end;  
  end;

  AppendRunLog('告警数据派发结束。。。');
end;

procedure TAlarmAdjustThread.SendSimulateClearAlarmData;
var
  DataSQL, TableFields: string;    

  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  strBH : String;
begin
  AppendRunLog('开始模拟Clear告警派发。。。'); 

  TableFields := 'alarmautoid, alarmtype, deviceid, codeviceid, contentcode, isalarm, createtime, collectid, errorcontent, '+
                 'cityid, isprocess, collectionkind, collectioncode, serverid';  

  //模拟比较表改成 alarm_data_huawei_view 原先为  alarm_data_huawei_temp
  DataSQL := 'insert into alarm_data_gather '+
            '(alarmautoid, alarmtype, DEVICEID, CODEVICEID, contentcode,ISALARM,createtime, '+
            'collectid,errorcontent,cityid,isprocess,collectionkind,collectioncode,ALARMLOCATION ) '+
            'select '+IntToStr(slServerIP.Count)+' alarmautoid, 1 alarmtype, t.DEVICEID, t.CODEVICEID, t.contentcode,'+
            '0 ISALARM, sysdate createtime, t.collectid, t.errorcontent,'+
            sCityID+' cityid, null isprocess, 1 collectionkind, 1 collectioncode, null ALARMLOCATION '+
            'from ALARM_DATA_HUAWEI_COMP t '+   
            'left join alarm_data_huawei_WG_view a '+
            'on a.DEVICEID=t.DEVICEID and a.CODEVICEID=t.CODEVICEID and a.CONTENTCODE=t.CONTENTCODE '+
            'left join alarm_data_gather b '+
            'on b.cityid='+sCityID+' and b.ISALARM=0 and b.DEVICEID=t.DEVICEID and b.CODEVICEID=t.CODEVICEID and b.CONTENTCODE=t.CONTENTCODE '+
            'where t.cityid='+sCityID+' and a.DEVICEID is null and b.DEVICEID is null ';
  ExecSQL(DataSQL);  

  Present:= Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  strBH := Format('%.4d',[Year])+Format('%.2d',[month])+Format('%.2d',[day])+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+Format('%.4d',[MSec]);

   //模拟clear告警进历史 gather history
  DataSQL := 'insert into alarm_data_gather_history '+
     '(alarmautoid, collectid, deviceid, codeviceid, contentcode, isalarm, createtime, operatetime, BH) '+  
     'select '+IntToStr(slServerIP.Count)+' alarmautoid, t.collectid, t.deviceid, t.codeviceid, t.contentcode, 0 isalarm, t.createtime, '+
     'sysdate operatetime, '+strBH+' BH '+
     'from ALARM_DATA_HUAWEI_COMP t '+
     'left join alarm_data_huawei_WG_view a '+
     'on a.DEVICEID=t.DEVICEID and a.CODEVICEID=t.CODEVICEID and a.CONTENTCODE=t.CONTENTCODE '+
     'where t.cityid='+sCityID+' and a.DEVICEID is null ';
  try
    ExecSQL(DataSQL);
  except  
    on E: Exception do
    begin
      blSaveErrLog := true;
      AppendRunLog('alarm_data_gather Clear告警进历史表出错。'+E.Message, true);
    end;
  end; 

  {
  // 模拟clear告警进历史 若有重复 加alarmautoid的值
  DataSQL := 'insert into alarm_data_huawei_comp_history ( '+TableFields +') '+
             'select nvl(b.alarmautoid, '+IntToStr(slCorbaIOR.Count-1+ServerID)+')+1 alarmautoid, t.alarmtype, t.deviceid, t.codeviceid, t.contentcode, 0 isalarm, sysdate createtime, t.collectid, '+
             't.errorcontent, t.cityid, t.isprocess, t.collectionkind, t.collectioncode, t.serverid '+
             ' from ALARM_DATA_HUAWEI_COMP t '+
             'left join alarm_data_huawei_view a '+
             'on a.serverid='+IntToStr(ServerID)+' and a.collectid=t.collectid '+
             'left join alarm_data_huawei_comp_history b on b.serverid='+IntToStr(ServerID)+' and b.isalarm=0 and b.collectid=t.collectid '+
             'where t.serverid='+IntToStr(ServerID)+' and a.collectid is null ';
  try
    ExecSQL(DataSQL);
  except  
    on E: Exception do
    begin
      //blSaveErrLog := true;
      AppendRunLog('模拟Clear告警进历史表出错。'+E.Message, true);
    end;
  end;
  } 

  if blSendToMTS then
  begin
    DataSQL := 'delete mtu_alarm_assistant where id in ('+
              'select collectid '+
              'from ALARM_DATA_HUAWEI_COMP t '+
              'where t.collectid not in (select id collectid from alarm_data_huawei_WG_view ) )';

    try
      ExecSQL(DataSQL);
    except
      on E: Exception do
      begin
        AppendRunLog('向MTS系统派发Clear告警数据失败！'+E.Message);
      end;
    end;
  end;

  AppendRunLog('模拟Clear告警派发结束。。。');
end;
         


//-------------------------------内部调用功能函数-------------------------------

function TAlarmAdjustThread.ConnectHWDB(ServerIP: string): boolean;
begin
  try
    Ado_HWDBConn.Connected:=false;  
    Ado_HWDBConn.ConnectionString := 'Provider=MSDASQL.1;Password=emsems;Persist Security Info=True;User ID=sa;'
                                    +'Extended Properties="DSN=CFMS;UID=sa;PWD=emsems;NA='+ServerIP+';DB=fmdb"';

    Ado_HWDBConn.Connected:=true;
    Result := true;
  except
    on E: Exception do
    begin
      Result := false;
      AppendRunLog(self.ClassName+'线程打开华为数据库连接异常！'+E.Message, true);
    end;
  end;
end;

procedure TAlarmAdjustThread.OpenHWQuery(strSQL: string);
begin
  Ado_HWQuery.Close;
  Ado_HWQuery.SQL.Clear;
  Ado_HWQuery.SQL.Add(strSQL);
  Ado_HWQuery.Open;
end;

function TAlarmAdjustThread.InitServerIP: boolean;
begin
  Result := false;

  if slServerIP.Count<1 then
  begin  
    OpenQuery('select t.serverbh,t.serverip from fms_cbserver_info t order by t.serverbh');
    if Ado_Query.IsEmpty then
    begin
      AppendRunLog('Corba服务器地址未配置！退出告警采集！', true);
      exit;
    end;

    Ado_Query.First;
    while not Ado_Query.Eof do
    begin
      slServerIP.Add(Ado_Query.FieldByName('serverip').AsString);
      Ado_Query.Next;
    end;
  end;
  
  Result := true;
end;

function TAlarmAdjustThread.GetDeviceID(sAlarmLocation: string): string;
var
  iPos: Integer;
  sAlarmLocationBak: string;   
begin
  //'基站编号=363, '

  sAlarmLocationBak := sAlarmLocation;
  Result := '0';

  iPos := pos('基站编号=', sAlarmLocation);
  if iPos>0 then
  begin
    sAlarmLocation := copy(sAlarmLocation, iPos+9, Length(sAlarmLocation)-iPos);
    iPos := pos(',', sAlarmLocation);
    Result := copy(sAlarmLocation, 1, iPos-1);
    try
      StrToInt(Result);
    except
      AppendRunLog('基站编号错误：'+Result+#13#10+'错误详细信息：'+sAlarmLocationBak, true);
      Result := '0';
    end;
  end;
end;

function TAlarmAdjustThread.GetCoDeviceID(ContentCode: Integer; sAlarmLocation: string): string;
var
  iPos, I: Integer;
  sAlarmLocationBak: string;   
begin
  //'本地扇区编号=1, '     '扇区标识='      '扇区标识＝3， '

  //驻波告警  单板编号=6,

  sAlarmLocationBak := sAlarmLocation;
  Result := '0';

  if ((ContentCode=18400) or (ContentCode=19149)) then
  begin
    for I := 2 to 4 do
    begin
      sAlarmLocation := sAlarmLocationBak;
    
      iPos := pos('单板编号', sAlarmLocation);
      if iPos>0 then
      begin
        sAlarmLocation := trim(copy(sAlarmLocation, iPos+8, Length(sAlarmLocation)-iPos));
        Result := copy(sAlarmLocation, I, 1);  
      end;  

      if Result = '0' then break;

      try      
        StrToInt(Result);
        break;
      except
        if I<4 then continue;
        Result:='0';
        AppendRunLog('扇区编号错误：'+Result+#13#10+'错误详细信息：'+sAlarmLocationBak, true);
      end;
    end;

    try
      I := StrToInt(Result);
      case I of
        0: I := 1;
        2: I := 2;
        4: I := 3;
        6: I := 4;
        8: I := 5;
      end;
      Result := IntToStr(I);
    except
      AppendRunLog('扇区编号转换错误：'+Result+#13#10+'错误详细信息：'+sAlarmLocationBak, true);
    end;
  end
  else
  begin
    for I := 2 to 4 do
    begin
      sAlarmLocation := sAlarmLocationBak;
    
      iPos := pos('扇区编号', sAlarmLocation);
      if iPos>0 then
      begin
        sAlarmLocation := trim(copy(sAlarmLocation, iPos+8, Length(sAlarmLocation)-iPos));
        Result := copy(sAlarmLocation, I, 1);
      end
      else
      begin
        iPos := pos('扇区标识', sAlarmLocation);
        if iPos>0 then
        begin
          sAlarmLocation := trim(copy(sAlarmLocation, iPos+8, Length(sAlarmLocation)-iPos));
          Result := copy(sAlarmLocation, I, 1);
        end;
      end;  

      if Result = '0' then break;

      try      
        StrToInt(Result);
        break;
      except
        if I<4 then continue;
        Result:='0';
        AppendRunLog('扇区编号错误：'+Result+#13#10+'错误详细信息：'+sAlarmLocationBak, true);
      end;
    end;

  end;
end;

function TAlarmAdjustThread.GetErrorContent(contentcode: integer; sAlarmLocation: string): string;
var
  iPos: Integer;      
begin
  //2312 小区退服  服务类型=1X| appendInfo:  服务类型=EV-DO| appendInfo:
  //1310 服务器端口号=1X端口       服务器端口号=DO端口
  Result := '';

  try
    case contentcode of
      2312:
      begin
        sAlarmLocation := trim(sAlarmLocation);
        if sAlarmLocation = '' then exit;

        iPos := pos('服务类型=', sAlarmLocation);
        if iPos>0 then
        begin
          sAlarmLocation := copy(sAlarmLocation, iPos+9, Length(sAlarmLocation)-iPos);
         // iPos := pos('|', sAlarmLocation);
        //  Result := copy(sAlarmLocation, 1, iPos-1);
          Result := '服务类型='+sAlarmLocation;
        end;
      end;

      1310:  //Abis信令链路中断
      begin
        sAlarmLocation := trim(sAlarmLocation);
        if sAlarmLocation = '' then exit;

        iPos := pos('服务器端口号=', sAlarmLocation);
        if iPos>0 then
        begin
          sAlarmLocation := copy(sAlarmLocation, iPos+13, Length(sAlarmLocation)-iPos);
         // iPos := pos('|', sAlarmLocation);
        //  Result := copy(sAlarmLocation, 1, iPos-1);
          Result := '服务器端口号='+sAlarmLocation;
        end;
      end;

    end;

  except
    on E: exception do
    begin
      AppendRunLog('获取ErrorContent内容失败！'+E.Message, true);   
    end;
  end;

end;



end.
