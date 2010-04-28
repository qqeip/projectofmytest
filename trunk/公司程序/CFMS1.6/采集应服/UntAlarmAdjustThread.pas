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
    function PrepareSimulateClearAlarmEvn: boolean;      //׼��ģ��Clear�澯���ݻ���
    procedure SingleAlarmSync(ServerBH: Integer; ServerIP: string);   
    procedure SyncWGAlarm(ServerBH: Integer);
    procedure SendAlarmData;
    procedure SendSimulateClearAlarmData; //�ɷ�Clear�澯      


    //---------------------------�ڲ����ù��ܺ���-------------------------------   
    function  ConnectHWDB(ServerIP: string): boolean;   //����HW���ݿ�
    procedure OpenHWQuery(strSQL: string);    //��ѯ����
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
  self.AppendRunLog('��ʼִ�� �澯���ݲɼ�������', true);
  StartTime := Now;

  if not ConnectDB then exit;

  DoAlarmCollect;

  EndTime := Now;
  self.AppendRunLog('�澯���ݲɼ� ִ����ɡ�����ִ�й�����ʱ�䣺'+ GetBetweenTime(StartTime, EndTime), true);
end;

procedure TAlarmAdjustThread.DoAlarmCollect;
var  
  I: Integer;
begin
  if not InitServerIP then exit;
  if not PrepareSimulateClearAlarmEvn then exit;
  
  for I := 0 to slServerIP.Count-1 do
  begin
    AppendRunLog('��ʼ��������'+IntToStr(I+1)+'�澯���ݲɼ�������');
    SingleAlarmSync(I, slServerIP[I]);
    AppendRunLog('��������'+IntToStr(I+1)+'�澯���ݲɼ�����������');
  end; 

  Ado_DBConn.BeginTrans;
  try
    SendAlarmData;
    SendSimulateClearAlarmData;

    Ado_DBConn.CommitTrans;
  except
    on E: Exception do
    begin
      self.AppendRunLog('�ɷ��澯ʧ�ܣ�'+E.Message, true);
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
      AppendRunLog('����澯�Ƚ������쳣��'+E.Message, true);
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
      self.AppendRunLog('��Ϊ�������߸澯���ݻ�ȡʧ�ܣ���������ţ�'+IntToStr(ServerBH+1)+E.Message, true);
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
  AppendRunLog('��ʼ�澯�����ɷ�������');

  Present:= Now;
  DecodeDate(Present, Year, Month, Day);
  DecodeTime(Present, Hour, Min, Sec, MSec);
  strBH := Format('%.4d',[Year])+Format('%.2d',[month])+Format('%.2d',[day])+Format('%.2d',[Hour])+Format('%.2d',[Min])+Format('%.2d',[Sec])+Format('%.4d',[MSec]);

  //into gather history    ���� alarm_data_gather_history ���ڷ����߳���
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
      AppendRunLog('alarm_data_gather����ʷ�����'+E.Message, true);
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
        AppendRunLog('��MTSϵͳ�ɷ��澯����ʧ�ܣ�'+E.Message);
      end;
    end;  
  end;

  AppendRunLog('�澯�����ɷ�����������');
end;

procedure TAlarmAdjustThread.SendSimulateClearAlarmData;
var
  DataSQL, TableFields: string;    

  Present: TDateTime;
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  strBH : String;
begin
  AppendRunLog('��ʼģ��Clear�澯�ɷ�������'); 

  TableFields := 'alarmautoid, alarmtype, deviceid, codeviceid, contentcode, isalarm, createtime, collectid, errorcontent, '+
                 'cityid, isprocess, collectionkind, collectioncode, serverid';  

  //ģ��Ƚϱ�ĳ� alarm_data_huawei_view ԭ��Ϊ  alarm_data_huawei_temp
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

   //ģ��clear�澯����ʷ gather history
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
      AppendRunLog('alarm_data_gather Clear�澯����ʷ�����'+E.Message, true);
    end;
  end; 

  {
  // ģ��clear�澯����ʷ �����ظ� ��alarmautoid��ֵ
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
      AppendRunLog('ģ��Clear�澯����ʷ�����'+E.Message, true);
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
        AppendRunLog('��MTSϵͳ�ɷ�Clear�澯����ʧ�ܣ�'+E.Message);
      end;
    end;
  end;

  AppendRunLog('ģ��Clear�澯�ɷ�����������');
end;
         


//-------------------------------�ڲ����ù��ܺ���-------------------------------

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
      AppendRunLog(self.ClassName+'�̴߳򿪻�Ϊ���ݿ������쳣��'+E.Message, true);
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
      AppendRunLog('Corba��������ַδ���ã��˳��澯�ɼ���', true);
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
  //'��վ���=363, '

  sAlarmLocationBak := sAlarmLocation;
  Result := '0';

  iPos := pos('��վ���=', sAlarmLocation);
  if iPos>0 then
  begin
    sAlarmLocation := copy(sAlarmLocation, iPos+9, Length(sAlarmLocation)-iPos);
    iPos := pos(',', sAlarmLocation);
    Result := copy(sAlarmLocation, 1, iPos-1);
    try
      StrToInt(Result);
    except
      AppendRunLog('��վ��Ŵ���'+Result+#13#10+'������ϸ��Ϣ��'+sAlarmLocationBak, true);
      Result := '0';
    end;
  end;
end;

function TAlarmAdjustThread.GetCoDeviceID(ContentCode: Integer; sAlarmLocation: string): string;
var
  iPos, I: Integer;
  sAlarmLocationBak: string;   
begin
  //'�����������=1, '     '������ʶ='      '������ʶ��3�� '

  //פ���澯  ������=6,

  sAlarmLocationBak := sAlarmLocation;
  Result := '0';

  if ((ContentCode=18400) or (ContentCode=19149)) then
  begin
    for I := 2 to 4 do
    begin
      sAlarmLocation := sAlarmLocationBak;
    
      iPos := pos('������', sAlarmLocation);
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
        AppendRunLog('������Ŵ���'+Result+#13#10+'������ϸ��Ϣ��'+sAlarmLocationBak, true);
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
      AppendRunLog('�������ת������'+Result+#13#10+'������ϸ��Ϣ��'+sAlarmLocationBak, true);
    end;
  end
  else
  begin
    for I := 2 to 4 do
    begin
      sAlarmLocation := sAlarmLocationBak;
    
      iPos := pos('�������', sAlarmLocation);
      if iPos>0 then
      begin
        sAlarmLocation := trim(copy(sAlarmLocation, iPos+8, Length(sAlarmLocation)-iPos));
        Result := copy(sAlarmLocation, I, 1);
      end
      else
      begin
        iPos := pos('������ʶ', sAlarmLocation);
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
        AppendRunLog('������Ŵ���'+Result+#13#10+'������ϸ��Ϣ��'+sAlarmLocationBak, true);
      end;
    end;

  end;
end;

function TAlarmAdjustThread.GetErrorContent(contentcode: integer; sAlarmLocation: string): string;
var
  iPos: Integer;      
begin
  //2312 С���˷�  ��������=1X| appendInfo:  ��������=EV-DO| appendInfo:
  //1310 �������˿ں�=1X�˿�       �������˿ں�=DO�˿�
  Result := '';

  try
    case contentcode of
      2312:
      begin
        sAlarmLocation := trim(sAlarmLocation);
        if sAlarmLocation = '' then exit;

        iPos := pos('��������=', sAlarmLocation);
        if iPos>0 then
        begin
          sAlarmLocation := copy(sAlarmLocation, iPos+9, Length(sAlarmLocation)-iPos);
         // iPos := pos('|', sAlarmLocation);
        //  Result := copy(sAlarmLocation, 1, iPos-1);
          Result := '��������='+sAlarmLocation;
        end;
      end;

      1310:  //Abis������·�ж�
      begin
        sAlarmLocation := trim(sAlarmLocation);
        if sAlarmLocation = '' then exit;

        iPos := pos('�������˿ں�=', sAlarmLocation);
        if iPos>0 then
        begin
          sAlarmLocation := copy(sAlarmLocation, iPos+13, Length(sAlarmLocation)-iPos);
         // iPos := pos('|', sAlarmLocation);
        //  Result := copy(sAlarmLocation, 1, iPos-1);
          Result := '�������˿ں�='+sAlarmLocation;
        end;
      end;

    end;

  except
    on E: exception do
    begin
      AppendRunLog('��ȡErrorContent����ʧ�ܣ�'+E.Message, true);   
    end;
  end;

end;



end.
