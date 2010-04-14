{*************************************************************************
  MTU控制器测试结果解析入库
**********************************************************************}
unit Ut_MtuDataProcess;

interface
uses
  Windows,SysUtils,Classes,IdBaseComponent, IdComponent,IdContext,IdTCPServer,
  ADODB,IdGlobal,Log;

type

  TMtuDataProcess=Class
    private
      FContext: TIdContext;
      FCurRecData :TIdBytes; //当前接收数据
      FLog :TLog;
      FCityid :integer;
      FIp :String;
      FFtpIP :String;
      FFtpPort :integer;
      FFtpPath :String;
      FFtpUser :String;
      FFtpPassWd :String;
      FMtuControl :String;
      FStatus :integer;
      FAdoCon :TAdoConnection;
      FConnectTime :String;
      FQuery :TAdoQuery;
    protected
      //存放所有MTU测试结果
      FDataList :TStringList;
      procedure SaveMtuTestData(cityid:integer;sValue :String);
      function  CheckInstruction(sValue :String):boolean;
      function StrToIdBytes(sValue :String): TIdBytes;
      function GetIdFromByte(FBytes:TIdBytes):String;
    public
      constructor Create(Log:TLog;DBConStr:String);reintroduce;
      destructor Destroy; override;
      procedure Process;
      property Context:TIdContext read FContext write FContext;
      property IP:String read FIP write FIP;
      property FtpIP:String read FFtpIP write FFtpIP;
      property FtpPort:Integer read FFtpPort write FFtpPort;
      property FtpPath:String read FFtpPath write FFtpPath;
      property FtpUser:String read FFtpUser write FFtpUser;
      property FtpPassWd:String read FFtpPassWd write FFtpPassWd;
      property Status:Integer read FStatus write FStatus;
      property MtuControl:String read FMtuControl write FMtuControl;
      property Cityid:Integer read FCityid write FCityid;
      property ConnectTime:String read FConnectTime write FConnectTime;
  end;

implementation
uses Ut_MtuInfo;
{ TMtuDataProcess }

function TMtuDataProcess.CheckInstruction(sValue: String):boolean;
var                                    //由于JS更迫切想知道测试命令是否发送成功，
  MsgData :TIdBytes;                   //所以增加此过程
  lTaskId :String;
  lValue :TIdBytes;
  // 5D 13 01 10 A0 16 00 2B 01 01 05 04 4A 3E 48 00 01 08 30 38 30 39 41 30 39 30 17 01 00
begin
  result:=false;
  MsgData := StrToIdBytes(sValue);
  if MsgData[4]=MTU_COMMAND_ACK then //命令响应
  begin
    result:=True;
    lValue:=copy(MsgData,12,4);     //任务编号
    lTaskId:=GetIdFromByte(lValue);
    With FQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select * from mtu_testtask_online where taskid='+lTaskId+'');
      Open;
      if not IsEmpty then
      begin
        Edit;
        if MsgData[28]=0 then                //结果
          Fieldbyname('status').AsInteger:=3 //成功
        else if MsgData[28]=1 then
          Fieldbyname('status').AsInteger:=5;//失败
        Post;
      end;
    end;
  end;
end;

constructor TMtuDataProcess.Create(Log:TLog;DBConStr:String);
begin
  FCurRecData := nil;
  FLog := Log;
  FAdoCon :=TAdoConnection.Create(nil);
  with FAdoCon do
  begin
    ConnectionString := DBConStr;
    LoginPrompt := false;
  end;
  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FAdoCon;
  FDataList :=TStringList.Create;
end;
destructor TMtuDataProcess.destroy;
begin
  FDataList.Free;
  FQuery.Close;
  FQuery.Free;
  FAdoCon.Connected := false;
  FAdoCon.Free;
  inherited;
end;

function TMtuDataProcess.GetIdFromByte(FBytes: TIdBytes): String;
var
  lBytes :TIdBytes;
begin
  SetLength(lBytes,4);
  FillBytes(lBytes,4,0);
  Move(FBytes[0],lBytes[0],Length(FBytes));
  result :=IntToStr(BytesToInteger(lBytes));
  //result := IntToStr(ID);
end;

procedure TMtuDataProcess.Process;
var
  RecvBuf :TIdBytes;
  RecvCount,i,j: integer;
  iCount :integer;
  s :string;
begin
  RecvBuf := nil;
  if FContext = nil then Exit;
  try
    //FContext.Connection.IOHandler.ReadBytes(RecvBuf,0);

    RecvCount :=FContext.Connection.IOHandler.InputBuffer.Size;
    if RecvCount>0 then
    begin
      with FContext.Connection.IOHandler.InputBuffer do
      begin
        RecvCount:=size;
        //读TCP/IP数据到缓冲
        ExtractToBytes(RecvBuf,Size,false);
        Clear;
      end;
      iCount :=0;
      Move(RecvBuf[5],iCount,2);
      while Length(RecvBuf) >7 do
      begin
        SetLength(FCurRecData,iCount+7);
        Move(RecvBuf[0],FCurRecData[0],iCount+7);
        RecvBuf := Copy(RecvBuf,iCount+7,Length(RecvBuf)-(iCount+7));
        s :='';
        for j := Low(FCurRecData) to High(FCurRecData) do
          s :=s+' '+Format('%-.2x',[FCurRecData[j]]);
        FDataList.Add(s);
        iCount :=0;
        if Length(RecvBuf) > 7 then
          Move(RecvBuf[5],iCount,2);
      end;
      if FDataList.Count > 0 then
      begin
        for I := 0 to FDataList.Count-1 do
          SaveMtuTestData(FCityid,FDataList[i]);
        FDataList.Clear;
      end;
    end;
  except
     On E:Exception do
      FLog.Write('接收异常 -'+E.Message,1);
  end;
end;

procedure TMtuDataProcess.SaveMtuTestData(cityid:integer;sValue: String);
var
  sqlstr :String;
begin
  if not FAdoCon.Connected then
  try
    FAdoCon.Connected := true;
  Except
    FLog.Write('无法连接数据库!',1);
    Exit;
  end;
  try
//    //根据控制器返回的响应命令 更新状态
//    if CheckInstruction(sValue) then exit;
    //sqlstr := 'insert into mtu_testresult_base(baseid,testvalue,cityid,revecive) values(MTU_BASEID.Nextval,:testvalue,:cityid)';
    sqlstr:= 'insert into mtu_testresult_base'+
             ' (baseid, testvalue, cityid, RECEIVEDATE) values'+
             ' (MTU_BASEID.Nextval,'''+sValue+''','+inttostr(cityid)+',sysdate)';
    with FQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(sqlstr);
      ExecSQL;
    end;
  Except
    On E :Exception do
      Flog.Write('MTU测试原始结果入库失败 -'+E.Message,1);
  end;
end;
function TMtuDataProcess.StrToIdBytes(sValue: String): TIdBytes;
var
  i : integer;
  Msg :String;
begin
  Msg := StringReplace(sValue,' ','',[rfReplaceAll]);
  if Msg<>'' then
  begin
    SetLength(Result,Length(Msg) div 2);
    for I := 0 to Length(Msg) div 2-1 do
      Result[i] :=StrToInt('$'+Copy(Msg,i*2+1,2));
  end;
end;

end.
