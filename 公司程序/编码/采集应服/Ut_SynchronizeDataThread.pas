unit Ut_SynchronizeDataThread;

interface

uses
  Classes,ADODB,DB,Variants,SysUtils,ComCtrls,Windows,Controls,StrUtils,Forms;

type

  TRemoteSource = record
    RemoteConn: string;
    RemoteTable:TStrings;  //需要同步的表
    CityID : integer;
    SetValue : integer;
    NetAddressSplit :String;
  end;
  
  //需更新的表或视图
  TSynchronizeTable = class
    ID : Integer;
    Name :string;   
    sqlsearch :string;
    locatelist :TStrings;
  end;
  TLocalField = class
    Name : String;
    Ftype :Integer;   // 1 : Int  ;2 :String
  end;

  TSynchronizeDataThread = class(TThread)
  private
    { Private declarations }
    AdoQDy :TAdoQuery;
    Ado_LocalConn: TADOConnection;
    Ado_RemoteConn: TADOConnection;
    Ado_LocalQuery: TADOQuery;
    Ado_RemoteQuery: TADOQuery;
    //存放需要同步的POP库信息
    RemoteSource : array of TRemoteSource;
    MessageContent,TableName : String;
    //模板表
    TableModelList : TList;
    ButtonIsEnable:Boolean;
    iSleep : Integer;

    procedure Pop_IsEnable();
  protected
    procedure Execute; override;
    procedure AppendRunLog();  //添加消息到运行日志
    procedure AppendSynLog();   
    //初始化需同步表的查询语句
    procedure InitTableList(var list :TList);
    //获取POP库接口表配置名称
    function GetRemoteTableName(tableid,cityid:integer):String;
    procedure Syn_Table(list :TList);
    function GetLocateValue(const Query :TAdoQuery;list :TStrings):Variant;
    //同步某个表
    function SynchronizeData(table :TSynchronizeTable;Field:String;List:TStrings;cityid:integer;netsplit :String=''):integer;
    procedure ShieldStatusSet(sCityID: string);
    procedure OpenTheDataSet(TheADOQuery: TADOQuery; thesql:string); //用指定SQL激活指定数据集
    //返回某本地网设置要同步的POP库表编码
    function ReturnPopTableList(cityid:integer):TStrings;
    function GetSleepTime :integer;
  public
    //源数据库连接是否异常
    iError : Integer;
    bStop : Boolean;//是否终止
    constructor Create(LocalConn:String);
    destructor Destroy;override;
  end;
                   
implementation
uses Ut_RunLog,Ut_Flowtache_Monitor;

{ SynchronizeDataThread }

procedure TSynchronizeDataThread.AppendRunLog;
begin
    if Fm_RunLog = nil then Exit;
    Fm_RunLog.Re_RunLog.Lines.Add(MessageContent);
end;

constructor TSynchronizeDataThread.Create(LocalConn:String);
var
  sqlstr :String;
  i : integer;
begin
  inherited Create(true);
  //初始化需要同步表的信息
  TableModelList := TList.Create;
  InitTableList(TableModelList);

  //本地连接(FMS)
  Ado_LocalConn := TADOConnection.Create(nil);
  Ado_LocalConn.LoginPrompt := false;
  Ado_LocalConn.ConnectionString := LocalConn;

  Ado_LocalQuery := TAdoQuery.Create(nil);
  Ado_LocalQuery.CommandTimeout := 70;
  Ado_LocalQuery.Connection := Ado_LocalConn;
  Ado_LocalQuery.LockType := ltBatchOptimistic;
  //动态查询
  AdoQDy:= TAdoQuery.Create(nil);
  AdoQDy.Connection :=Ado_LocalConn;
  //初始化POP库信息
  sqlstr:=' select Last_DataSource,increment_column,cityid,SetValue from alarm_collection_cyc_list where collectionkind=12 order by collectioncode ';
  OpenTheDataSet(Ado_LocalQuery,sqlstr);
  with Ado_LocalQuery do
  begin
     SetLength(RemoteSource, Recordcount);
     first;   i:=0;
     while not eof do
     begin
       RemoteSource[i].RemoteConn:=fieldbyname('Last_DataSource').AsString;
       RemoteSource[i].RemoteTable :=ReturnPopTableList(fieldbyname('CityID').AsInteger);
       RemoteSource[i].CityID:=fieldbyname('CityID').AsInteger;
       RemoteSource[i].NetAddressSplit := FieldByName('increment_column').AsString;
       inc(i);
       next;
     end;
  end;
  //初始化数据源连接(POP)
  Ado_RemoteConn := TADOConnection.Create(nil);
  Ado_RemoteConn.LoginPrompt:=false;
  Ado_RemoteQuery := TAdoQuery.Create(nil);
  Ado_RemoteQuery.Connection := Ado_RemoteConn;
  Ado_RemoteQuery.LockType := ltBatchOptimistic;
end;

destructor TSynchronizeDataThread.Destroy;
var
  i : integer;
begin
   for i := 0 to TableModelList.Count-1 do
      TSynchronizeTable(TableModelList.Items[i]).Free;
   TableModelList.Clear;
   TableModelList.Free;

   Ado_RemoteQuery.Close;
   Ado_RemoteQuery.Free;
   if Ado_LocalQuery <> nil then
   begin
      Ado_LocalQuery.Close;
      Ado_LocalQuery.Free;
   end;
   AdoQDy.Close;
   AdoQDy.Free;
   Ado_RemoteConn.Connected := false;
   Ado_RemoteConn.Free;
  inherited;
end;

procedure TSynchronizeDataThread.Execute;
begin
  { Place thread code here }
  while (not terminated) do
  begin
    try
        iSleep := GetSleepTime;
        //同步表
        Syn_Table(tablemodellist);
    finally
      Suspend;
    end;
  end;
end;

//初始化需要同步的表的编码、 sql及定位字段 ，其中的编码不可以乱变需和数据库中一致
//如果需新增字段请在sqlsearch中增加，如果新增字段是定位字段，请在LocList中增加
procedure TSynchronizeDataThread.InitTableList(var list: TList);
var
  Table : TSynchronizeTable;
  LocList : TStrings;
begin
  //alarm_dic_code_info
  Table := TSynchronizeTable.Create;
  Table.ID := 1;
  Table.Name := 'alarm_dic_code_info';
  Table.sqlsearch := 'select diccode, dictype, dicname, dicorder, ifineffect, remark, parentid, setvalue, @cityid cityid from @table @where order by cityid,dictype,diccode';
  LocList := TStringList.Create;
  //定位字段
  LocList.Add('dictype');
  LocList.Add('cityid');
  Table.locatelist := LocList;
  List.Add(Table);

  //pop_area
  Table := TSynchronizeTable.Create;
  Table.ID := 3;
  Table.Name := 'pop_area';
  Table.sqlsearch := 'select id, top_id, zonecode, name, layer, zoneaddress, zonephone, flag, net_flag,@cityid cityid from @table @where order by cityid,id';
  LocList := TStringList.Create;
  //定位字段
  LocList.Add('id');
  LocList.Add('cityid');
  Table.locatelist := LocList;
  List.Add(Table);

  //pop_cstype
  Table := TSynchronizeTable.Create;
  Table.ID := 5;
  Table.Name := 'pop_cstype';
  Table.sqlsearch := 'select id, name, manufacturer, power, iodoor, aliasflag,LINENUM,@cityid  cityid from @table @where order by cityid,id';
  LocList := TStringList.Create;
  LocList.Add('id');
  LocList.Add('cityid');
  Table.locatelist := LocList;
  List.Add(Table);
  
  //pop_cslevel
  Table := TSynchronizeTable.Create;
  Table.ID := 9;
  Table.Name := 'pop_cslevel';
  Table.sqlsearch := 'select id,name,@cityid  cityid from @table @where order by cityid,id';
  LocList := TStringList.Create;
  LocList.Add('id');
  LocList.Add('cityid');
  Table.locatelist := LocList;
  List.Add(Table);

  //pop_status
  Table := TSynchronizeTable.Create;
  Table.ID := 10;
  Table.Name := 'pop_status';
  Table.sqlsearch := 'select id,cs_status,@cityid  cityid, STATUS_TYPE from @table @where order by cityid,id';
  LocList := TStringList.Create;
  LocList.Add('id');
  LocList.Add('cityid');
  Table.locatelist := LocList;
  List.Add(Table);

  //pop_powertype
  Table := TSynchronizeTable.Create;
  Table.ID := 11;
  Table.Name := 'pop_powertype';
  Table.sqlsearch := 'select ID,NAME,@cityid  cityid from @table @where order by cityid,ID';
  LocList := TStringList.Create;
  LocList.Add('ID');
  LocList.Add('cityid');
  Table.locatelist := LocList;
  List.Add(Table);

  //fms_device_info
  Table := TSynchronizeTable.Create;
  Table.ID := 12;
  Table.Name := 'fms_device_info';
  Table.sqlsearch :=' select @cityid cityid, deviceid, areaid, branch, branchname, csid, bts_name, '+
                    ' bts_level, bts_state, bts_label, bts_type, bts_kind, msc, bsc, '+
                    ' lac, station_addr, bts_netstate, commonality_type, agent_manu, source_mode, iron_tower_kind, DEVICETYPE ' +   
                    ' from @table @where order by cityid,deviceid ';
  LocList := TStringList.Create;
  LocList.Add('deviceid');
  LocList.Add('cityid');
  Table.locatelist := LocList;
  List.Add(Table);

  //fms_cell_device_info
  Table := TSynchronizeTable.Create;
  Table.ID := 13;
  Table.Name := 'fms_cell_device_info';
  Table.sqlsearch :=' select @cityid cityid, bts_label, '+
                    ' fan_id, cell_no, cid_num_sixteen, pn_code, antenna_kind, azimuth, cell_state ' +
                    ' from @table @where order by cityid,bts_label ';
  LocList := TStringList.Create;
  LocList.Add('bts_label');
  LocList.Add('cityid');
  Table.locatelist := LocList;
  List.Add(Table); 
end;

function TSynchronizeDataThread.SynchronizeData(table :TSynchronizeTable;Field:String;List:TStrings;cityid:integer;netsplit :String):integer;
var
  i : integer;
  sqlstr : String;
  strSQLDelete, strSQLLocal: string;
begin
    result := 0;
    try
      //POP库不需要加查询条件，但需要手工赋值cityid
      sqlstr:=StringReplace(table.sqlsearch, '@cityid',IntToStr(cityid), [rfReplaceAll, rfIgnoreCase]);
      //替换@table 配置的远程表名
      sqlstr:=StringReplace(sqlstr, '@table',GetRemoteTableName(table.ID,cityid), [rfReplaceAll, rfIgnoreCase]);  
      sqlstr:=StringReplace(sqlstr, '@where',' ', [rfReplaceAll, rfIgnoreCase]);
      with Ado_RemoteQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add(sqlstr);
        Open;
        if RecordCount = 0 then Exit;

        if Table.ID = 1 then  //字典表同步 特殊处理
        begin
          Ado_RemoteQuery.Filter := 'dictype<1000 and dictype>=2000';
          Ado_RemoteQuery.Filtered := true;
          if Ado_RemoteQuery.RecordCount <> 0 then
          begin
            Ado_RemoteQuery.Filtered := false;
            MessageContent:=datetimetostr(now)+'   字典表同步'+table.Name+' 数据错误，dictype需在1000与2000之间！';
            Synchronize(AppendRunLog);
            Exit;
          end;
          Ado_RemoteQuery.Filtered := false;
        end;
      end;   

      //派障库需要加查询条件，而且手工赋值cityid
      sqlstr:=StringReplace(table.sqlsearch, '@cityid',' ', [rfReplaceAll, rfIgnoreCase]);
      //替换@table 配置的本地表名
      sqlstr:=StringReplace(sqlstr, '@table',table.Name, [rfReplaceAll, rfIgnoreCase]);   
      sqlstr:=StringReplace(sqlstr, '@where',' where cityid ='+IntToStr(cityid), [rfReplaceAll, rfIgnoreCase]);
      strSQLLocal := sqlstr;
      {with Ado_LocalQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add(sqlstr);
        Open;
        if RecordCount > 0 then First;
      end;}

    except
      MessageContent:=datetimetostr(now)+'   获取 cityid = '+IntToStr(cityid)+' 的POP库中的 '+table.Name+' 数据失败,请联系系统管理员!';
      Synchronize(AppendRunLog);
      Exit;
    end;
    
    Ado_LocalConn.BeginTrans;
    try
      if Table.ID = 1 then  //字典表同步 删除原始数据 特殊处理
        strSQLDelete := 'delete '+Table.Name+' where cityid='+IntToStr(cityid)+' and dictype>=1000 and dictype<2000'
      else
        strSQLDelete := 'delete '+Table.Name+' where cityid='+IntToStr(cityid);

      with Ado_LocalQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add(strSQLDelete);
        ExecSQL;  
      end;

      with Ado_LocalQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add(strSQLLocal);
        Open;  
      end;

      with Ado_RemoteQuery do
      begin
        first;
        while not eof do
        begin
          Ado_LocalQuery.Append;

          try
            for i := 0 to Fields.Count -1 do
            begin 
              Ado_LocalQuery.Fields[i].Value := Fields[i].Value;
            end;
          except
            MessageContent:=datetimetostr(now)+'   cityid = '+IntToStr(cityid)+' 的POP库中的 '+table.Name+'同步字段出错！'+Fields[i].FieldName+': '+Fields[i].AsString;
            Synchronize(AppendRunLog);
            //application.MessageBox(PAnsichar('同步字段出错！'+Fields[i].FieldName+': '+Fields[i].AsString),'');
          end;
          //Ado_LocalQuery.CheckBrowseMode;   
          Next;  
        end;          
      end; 

      //如果是POP_Area表则需要处理省的数据
      if Table.ID = 3 then
      begin
        Ado_LocalQuery.Locate('top_id',0,[]);
        Ado_LocalQuery.Delete;
        //UpdatePOP_Area;
      end;

      Ado_LocalQuery.CheckBrowseMode;

      Ado_LocalQuery.UpdateBatch;
      Ado_LocalConn.CommitTrans;
      result := 1;
    except
      Ado_LocalConn.RollbackTrans;
      MessageContent:=datetimetostr(now)+'   同步 cityid = '+IntToStr(cityid)+' 的POP库中的 '+table.Name+' 失败，请联系系统管理员!';
      Synchronize(AppendRunLog);
    end;

    //如果是pop_status表
    if Table.ID = 10 then
    begin
      ShieldStatusSet(IntToStr(cityid));   
    end;
end;

procedure TSynchronizeDataThread.Pop_IsEnable;
begin
    Fm_FlowMonitor.Btn_POP.Enabled:=ButtonIsEnable;
end;

procedure TSynchronizeDataThread.Syn_Table(list: TList);
var
  i,j,iCount,CurrConn: integer;
  table :TSynchronizeTable;
  LF,Field,Flstr :String;
  starttime,endtime:TTime;
  SynTables: string;
begin
   starttime := now;
   try
     ButtonIsEnable:=false;
     Synchronize(pop_IsEnable);
     for CurrConn:=Low(RemoteSource) to High(RemoteSource) do
     begin
       iCount := 0;
       Ado_RemoteConn.Connected:=false;
       Ado_RemoteConn.ConnectionString:=RemoteSource[CurrConn].RemoteConn;
       Ado_RemoteConn.Connected:=true;

       SynTables := '';
       for i := 0 to list.Count -1 do
       begin
          Field := '';
          Flstr := '';
          table :=TSynchronizeTable(List.Items[i]);
          if table.locatelist.Count = 0 then continue;
          //判断允许当前表是否允许同步
          if RemoteSource[CurrConn].RemoteTable.IndexOf(IntToStr(table.ID))= -1 then Continue;
          for j := 0 to table.locatelist.Count -1 do
          begin
              LF := table.locatelist.Strings[j];
              Field := Field+LF+';';
          end;
          Field := leftstr(Field, length(Field) - 1);
          if Terminated or bStop then break;    //退出循环
          
          TableName := 'cityid = '+IntToStr(RemoteSource[CurrConn].cityid)+'的'+Table.Name;
          Synchronize(AppendSynLog);

          SynTables := SynTables + Table.Name + '  ';
          iCount := iCount + SynchronizeData(table,Field,Table.locatelist,RemoteSource[CurrConn].cityid,RemoteSource[CurrConn].NetAddressSplit);
       end;
       endtime := now;
       if iCount > 0 then
       begin
         MessageContent:=datetimetostr(now)+'   成功同步了 cityid = '+IntToStr(RemoteSource[CurrConn].cityid)+' 的POP库中的 '+IntToStr(iCount)+' 个对象,共花费时间：'+timetostr(endtime-starttime);
         Synchronize(AppendRunLog);
         MessageContent:=datetimetostr(now)+'   此次应同步表为：'+SynTables;
         Synchronize(AppendRunLog);
       end;
     end;
   except
     on E: Exception do
     begin
       MessageContent:=datetimetostr(now)+'   来自《同步POP数据线程》的消息——同步统计失败，请通知系统管理员处理！'+E.Message;
       Synchronize(AppendRunLog);
     end;
   end;
   TableName := '';
   Synchronize(AppendSynLog);
   ButtonIsEnable:=true;
   Synchronize(pop_IsEnable);
end;
//产生AdoQuery Locate 的Variant参数
function TSynchronizeDataThread.GetLocateValue(const Query :TAdoQuery;list :TStrings):Variant;
var
  I: Integer;
  LF :String;
begin
  with Query do
  begin
      if list.Count > 1 then
      begin
        Result := VarArrayCreate([0, List.Count-1], varVariant);
        for I := 0 to List.Count-1 do
        begin
          LF :=list.Strings[i];
          Result[I] := FieldByName(LF).Value;
        end;
      end
      else
      begin
        LF :=list.Strings[0];
        Result :=  FieldByName(LF).Value;
      end;
  end;    
end;

procedure TSynchronizeDataThread.AppendSynLog;
begin
    if Trim(TableName) <> '' then
      Fm_FlowMonitor.P_Sync.Caption := '正在同步 '+TableName +'....'
    else
      Fm_FlowMonitor.P_Sync.Caption :='';
end;

procedure TSynchronizeDataThread.OpenTheDataSet(TheADOQuery: TADOQuery;
  thesql: string);
begin
  with TheADOQuery do
  begin
    close;
    sql.Clear;
    sql.Add(thesql);
    open;
  end;
end;
//根据cityid返回需要同步的POP库表编码
function TSynchronizeDataThread.ReturnPopTableList(
  cityid: integer): TStrings;
var
  list : TStrings;
begin
  list := TStringList.Create;
  with AdoQDy do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select diccode from alarm_dic_code_info where dictype = 16 and ifineffect =1 and cityid ='+IntToStr(cityid));
    Open;
    if RecordCount > 0 then
    begin
      first;
      while not Eof do
      begin
        list.Add(FieldByName('diccode').AsString);
        Next;
      end;
    end;
    result := list;
  end;
end;


function TSynchronizeDataThread.GetRemoteTableName(tableid,
  cityid: integer): String;
begin
  result :='';
  with AdoQDy do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select dicname,setvalue from alarm_dic_code_info where dictype = 16 and ifineffect =1 and cityid =:cityid and diccode =:diccode');
    Parameters.ParamByName('cityid').Value :=cityid;
    Parameters.ParamByName('diccode').Value :=tableid;
    Open;
    if RecordCount = 0 then Exit;
    if Trim(FieldByName('setvalue').AsString)<>'' then
      result := FieldByName('setvalue').AsString
    else
      result := FieldByName('dicname').AsString
  end;
end;


function TSynchronizeDataThread.GetSleepTime: integer;
begin
  result := 50;
  with AdoQDy do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select Collectorder from Alarm_Collection_Config where collectkind =12');
    Open;
    if RecordCount >0 then
      result := FieldByName('Collectorder').AsInteger;
    Close;
  end;
end;

procedure TSynchronizeDataThread.ShieldStatusSet(sCityID: string);
var
  strSQL: string;
begin
  Ado_LocalConn.BeginTrans;
  try
    strSQL :=  'insert into alarm_shield_devstate_relat '+
               '(cityid, shieldgroupid, devicestate, shieldflag) '+
              'select a.cityid, a.status devicestate, a.status shieldgroupid, 2 shieldflag  from '+
              '(select t.cityid, t.id status from pop_status t where t.cityid='+sCityID+' and t.status_type=1) a '+
              'left join alarm_shield_devstate_relat b on a.cityid=b.cityid and a.status=b.devicestate '+
              'where b.shieldgroupid is null';
    with Ado_LocalQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(strSQL);
      ExecSQL;
    end;

    strSQL :=  'insert into alarm_shield_codevstate_relat '+
               '(cityid, shieldgroupid, codevicestate, shieldflag) '+
              'select a.cityid, a.status codevicestate, a.status shieldgroupid, 2 shieldflag  from '+
              '(select t.cityid, t.id status from pop_status t where t.cityid='+sCityID+' and t.status_type=2) a '+
              'left join alarm_shield_codevstate_relat b on a.cityid=b.cityid and a.status=b.codevicestate '+
              'where b.shieldgroupid is null';
    with Ado_LocalQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(strSQL);
      ExecSQL;
    end;
    
    Ado_LocalConn.CommitTrans;
  except
    on E: Exception do
    begin
      MessageContent := datetimetostr(now)+'   基站/小区状态默认屏蔽设置失败!'+E.Message;
      Synchronize(AppendRunLog);
      Ado_LocalConn.RollbackTrans;  
    end;
  end;  
end;

end.
