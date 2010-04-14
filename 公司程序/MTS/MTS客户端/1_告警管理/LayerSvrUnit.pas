unit LayerSvrUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, MapXLib_TLB, MapTools, Forms,
  StringUtils, DB,DBClient,MConnect,SConnect, ActiveX, UnitGlobal;

const
  PROGRESS_STEP=50;
type
  TOnEvent=procedure(Sender:TObject;EventLevel:Integer;EventMsg:string) of object;
  TOnProgress=procedure(Sender:TObject;Position,Max:integer) of object;
  TLayerType=(ltBuilding,ltMTU,ltCDMA,ltDRS);
  TLayerTypeSet=set of TLayerType;
  TLayerSvrThread = class(TThread)
  private
    FMap:TMap;
    FWdMapWrapper:TWdMapWrapper;
    FLayerPath,FTmpPath:string;
    FCityID: integer;
    FOnEvent: TOnEvent;
    FUserID: integer;
    FLayerTypeSet: TLayerTypeSet;
    FOnProgress: TOnProgress;
    FProgressFlag: boolean;

    FSocketConn: TSocketConnection;
    FDataSet: TClientDataSet;
    FProviderName: string;
    FPort: integer;
    FIpAddress: string;
    FServerName: string;
    procedure SetPort(const Value: integer);
    procedure SetServerName(const Value: string);
    { private declarations }
  protected
    FFields,FDatas:TStringList;
    FEventLevel:integer;
    FEventMsg:string;
    FProgressPos,FProgressMax:integer;
    FExitFlag:boolean;
    function AddStringField(Name,Caption:string;FieldLength:integer=20):TLayerField;
    function Nvl(Value:Variant):string;

    procedure Execute; override;
    procedure CreateRelationLayer;
    procedure CreateBuildingLayer;
    procedure CreateMTULayer;
    procedure CreateCDMALayer;
    procedure CreateDRSLayer;
    procedure Move_Layer(aLayerName:string);

    procedure DoEvent(aEventLevel:integer;aEventMsg:string);
    procedure ProcessEvent;
    procedure DoProgress(aPos,aMax:integer);
    procedure ProcessProgress;
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;
  published
    property IpAddress:string read FIpAddress write FIpAddress;
    property Port:integer read FPort write SetPort;
    property ServerName:string read FServerName write SetServerName;
    property ProviderName:string read FProviderName write FProviderName;

    property CityID:integer read FCityID write FCityID;
    property UserID:integer read FUserID write FUserID;

    property LayerTypeSet:TLayerTypeSet read FLayerTypeSet write FLayerTypeSet;  //要创建的图层
    property ProgressFlag:boolean read FProgressFlag write FProgressFlag;
    property OnEvent: TOnEvent read FOnEvent write FOnEvent;
    property OnProgress: TOnProgress read FOnProgress write FOnProgress;
  end;

implementation

{ TLayerSvrThread }

function TLayerSvrThread.AddStringField(Name, Caption: string;
  FieldLength: integer): TLayerField;
var
  lLayerField:TLayerField;
begin
  lLayerField:=TLayerField.Create;
  lLayerField.Name:=Name;
  lLayerField.Caption:=Caption;
  lLayerField.FieldType:=$00000000;
  lLayerField.Length:=FieldLength;
  result:=lLayerField;
end;

constructor TLayerSvrThread.Create;
begin
  inherited Create(true);
  FExitFlag:=false;
  try
    FMap:=TMap.Create(nil);
  except
    self.Terminate;
    FExitFlag:=true;
    exit;
  end;

  FSocketConn:=TSocketConnection.Create(nil);
  FSocketConn.Connected:=false;


  FMap.MousewheelSupport := 3;
  FWdMapWrapper:=TWdMapWrapper.Create(nil);
  FWdMapWrapper.MapMain:=FMap ;
  FWdMapWrapper.Startup;
  FFields:=TStringList.Create;
  FDatas:=TStringList.Create;
  FLayerPath:=ExtractFilePath(Application.ExeName)+'Layers\';
  if not DirectoryExists(FLayerPath) then
    CreateDir(FLayerPath);
  FTmpPath:=FLayerPath+'\Temp\';
  if not DirectoryExists(FTmpPath) then
    CreateDir(FTmpPath);
  self.FreeOnTerminate:=true;
  FProgressFlag:=false;
end;

procedure TLayerSvrThread.CreateBuildingLayer;
var
  lFeatureData:TFeatureData;
  lLayer:Layer;
  lMapXDataSet : CMapXDataSet;
  lRowValues : CMapXRowValues;
  lLayerField:Field;
  j:integer;
  lSqlstr: string;
begin
  FWdMapWrapper.DeleteLayerFile(UD_LAYER_BUILDING,FTmpPath);
  //创建图层
  //定义字段
  ClearTStrings(FFields);
  FFields.AddObject('',AddStringField('BUILDINGID','BUILDINGID',20));
  FFields.AddObject('',AddStringField('BUILDINGNO','BUILDINGNO',100));
  FFields.AddObject('',AddStringField('BUILDINGNAME','BUILDINGNAME',100));
  FFields.AddObject('',AddStringField('ADDRESS','ADDRESS',200));
  FFields.AddObject('',AddStringField('AREAID','AREAID',20));
  FFields.AddObject('',AddStringField('ALARMSTATUS','ALARMSTATUS',20));

  FWdMapWrapper.CreateLayer(UD_LAYER_BUILDING,FTmpPath,FFields);
  if FWdMapWrapper.GetLayer(UD_LAYER_BUILDING,lLayer) then
  begin
    FMap.AutoRedraw:=false;
    try
      //加载数据
      try
//        if FCityID=0 then   //管理员
//          lSqlstr:= 'select BUILDINGID,BUILDINGNO,BUILDINGNAME,ADDRESS,AREAID,LONGITUDE,LATITUDE from BUILDING_INFO_VIEW t';
//        if FCityID<>0 then
//          lSqlstr:= 'select BUILDINGID,BUILDINGNO,BUILDINGNAME,ADDRESS,AREAID,LONGITUDE,LATITUDE from BUILDING_INFO_VIEW t'+
//                    ' where t.cityid='+inttostr(self.FCityID);
        lSqlstr:= 'select t.BUILDINGID,t.BUILDINGNO,t.BUILDINGNAME,t.ADDRESS,t.AREAID,t.LONGITUDE,t.LATITUDE,decode(t1.alarmcount,NULL,''正常'',0,''正常'',''告警'') ALARMSTATUS'+
                  ' from BUILDING_INFO t'+
                  ' left join (select a.buildingid,sum(decode(b.mtuid,null,0,1)) alarmcount'+
                             ' from mtu_info a'+
                             ' left join alarm_master_online b on a.mtuid=b.mtuid and b.flowtache=2'+
                             ' group by a.buildingid) t1'+
                  ' on t.buildingid=t1.buildingid';
        FDataSet.Close;
        FDataSet.CommandText:= lSqlstr;
        FDataSet.Open;
        if FDataSet.RecordCount>0 then
        begin
          FDataSet.First;
          lMapXDataSet := FMap.Datasets.Add(miDataSetLayer,lLayer,emptyparam,emptyparam,
            emptyparam,emptyparam,emptyparam,emptyparam);
          lRowValues:=lMapXDataSet.RowValues[lMapXDataSet.RowCount];
          lFeatureData:=TFeatureData.Create;

          while not FDataSet.Eof do
          begin
            if Terminated then exit;
            if not (VarIsNull(FDataSet.FieldValues['Longitude']) or VarIsNull(FDataSet.FieldValues['Latitude']) ) then
            begin
              lFeatureData.Longitude:=FDataSet.FieldValues['Longitude'];
              lFeatureData.Latitude:=FDataSet.FieldValues['Latitude'];
              for j :=1  to lMapXDataSet.Fields.Count do
              begin
                lLayerField:=lMapXDataSet.Fields.Item[j];
                lRowValues.Item[lLayerField.Name].Value:=Nvl(FDataSet.FieldValues[lLayerField.Name]);
              end;
              FWdMapWrapper.DrawPictureBitmap(lLayer,'HOUS1-32.bmp',16,lFeatureData,lRowValues);
            end;
            FDataSet.Next;
            if (FDataSet.RecNo mod PROGRESS_STEP)=0 then
              DoProgress(FDataSet.RecNo,FDataSet.RecordCount);
          end;
          DoProgress(FDataSet.RecordCount,FDataSet.RecordCount);
          lFeatureData.Free;
        end;
      except

      end;
    finally
      FMap.AutoRedraw:=true;
    end;
  end;
end;

function IfStrisNumber(aStr :String):boolean;
var
  I : integer;
begin
  result := false;
  if length(aStr)=0 then Exit;
  for I := 1 to length(aStr) do
  begin
    if not (aStr[I] in ['0'..'9','.']) then
    begin
      result := false;
      Exit;
    end;
  end;
  result := True;
end;

procedure TLayerSvrThread.CreateCDMALayer;
var
  lFeatureData:TFeatureData;
  lLayer:Layer;
  lMapXDataSet : CMapXDataSet;
  lRowValues : CMapXRowValues;
  lLayerField:Field;
  j:integer;
  lSqlstr: string;
begin
  FWdMapWrapper.DeleteLayerFile(UD_LAYER_CDMA,FTmpPath);
  //创建图层
  //定义字段
  ClearTStrings(FFields);
  FFields.AddObject('',AddStringField('CDMAID','CDMA编号',20));
  FFields.AddObject('',AddStringField('CDMANAME','CDMA名称',100));
//  FFields.AddObject('',AddStringField('BUILDINGNAME','室分点名称',100));
//  FFields.AddObject('',AddStringField('ADDRESS','室分点地址',200));
//  FFields.AddObject('',AddStringField('AREAID','所属区域编号',20));

  FWdMapWrapper.CreateLayer(UD_LAYER_CDMA,FTmpPath,FFields);
  if FWdMapWrapper.GetLayer(UD_LAYER_CDMA,lLayer) then
  begin
    FMap.AutoRedraw:=false;
    try
      //加载数据
      try
        lSqlstr:= 'select CDMAID,CDMANAME,LONGITUDE,LATITUDE from CDMA_INFO t where t.isprogram=0';
        FDataSet.Close;
        FDataSet.CommandText:= lSqlstr;
        FDataSet.Open;
        if FDataSet.RecordCount>0 then
        begin
          FDataSet.First;
          lMapXDataSet := FMap.Datasets.Add(miDataSetLayer,lLayer,emptyparam,emptyparam,
            emptyparam,emptyparam,emptyparam,emptyparam);
          lRowValues:=lMapXDataSet.RowValues[lMapXDataSet.RowCount];
          lFeatureData:=TFeatureData.Create;

          while not FDataSet.Eof do
          begin
            if Terminated then exit;
            if not (VarIsNull(FDataSet.FieldValues['Longitude']) or VarIsNull(FDataSet.FieldValues['Latitude']) ) then
            begin
              lFeatureData.Longitude:=FDataSet.FieldValues['Longitude'];
              lFeatureData.Latitude:=FDataSet.FieldValues['Latitude'];
              for j :=1  to lMapXDataSet.Fields.Count do
              begin
                lLayerField:=lMapXDataSet.Fields.Item[j];
                lRowValues.Item[lLayerField.Name].Value:=Nvl(FDataSet.FieldValues[lLayerField.Name]);
              end;
              FWdMapWrapper.DrawPictureBitmap(lLayer,'500mw.bmp',16,lFeatureData,lRowValues);
            end;
            FDataSet.Next;
            if (FDataSet.RecNo mod PROGRESS_STEP)=0 then
              DoProgress(FDataSet.RecNo,FDataSet.RecordCount);
          end;
          DoProgress(FDataSet.RecordCount,FDataSet.RecordCount);
          lFeatureData.Free;
        end;
      except

      end;
    finally
      FMap.AutoRedraw:=true;
    end;
  end;
end;

procedure TLayerSvrThread.CreateDRSLayer;
var
  lFeatureData:TFeatureData;
  lLayer:Layer;
  lMapXDataSet : CMapXDataSet;
  lRowValues : CMapXRowValues;
  lLayerField:Field;
  j:integer;
  lSqlstr: string;
begin
  FWdMapWrapper.DeleteLayerFile(UD_LAYER_DRS,FTmpPath);
  //创建图层
  //定义字段
  ClearTStrings(FFields);
  FFields.AddObject('',AddStringField('DRSID','DRSID',20));
  FFields.AddObject('',AddStringField('DRSNAME','DRSNAME',100));
  FFields.AddObject('',AddStringField('DRSSTATUS','DRSSTATUS',100));
  FWdMapWrapper.CreateLayer(UD_LAYER_DRS,FTmpPath,FFields);
  if FWdMapWrapper.GetLayer(UD_LAYER_DRS,lLayer) then
  begin
    FMap.AutoRedraw:=false;
    try
      //加载数据 室外的   {室内的不需要，根据他的室分点来}
      try
        lSqlstr:= 'select t.DRSID,t.DRSNAME,t.LONGITUDE,t.LATITUDE,decode(t1.alarmcount,NULL,''正常'',0,''正常'',''告警'') DRSSTATUS' +
                  '  from drs_info t' +
                  '  left join (select a.drsid,sum(decode(b.drsid,null,0,1)) alarmcount' +
                  '               from drs_info a' +
                  '               left join drs_alarm_online b on a.drsid=b.drsid and b.flowtache=2' +
                  '              group by a.drsid) t1' +
                  '   on t.drsid=t1.drsid' +
                  '   where t.isprogram=0';
        FDataSet.Close;
        FDataSet.CommandText:= lSqlstr;
        FDataSet.Open;
        if FDataSet.RecordCount>0 then
        begin
          FDataSet.First;
          lMapXDataSet := FMap.Datasets.Add(miDataSetLayer,lLayer,emptyparam,emptyparam,
                                            emptyparam,emptyparam,emptyparam,emptyparam);
          lRowValues:=lMapXDataSet.RowValues[lMapXDataSet.RowCount];
          lFeatureData:=TFeatureData.Create;

          while not FDataSet.Eof do
          begin
            if Terminated then exit;
            if not (VarIsNull(FDataSet.FieldValues['Longitude']) or VarIsNull(FDataSet.FieldValues['Latitude']) ) then
            begin
              lFeatureData.Longitude:=FDataSet.FieldValues['Longitude'];
              lFeatureData.Latitude:=FDataSet.FieldValues['Latitude'];
              for j :=1  to lMapXDataSet.Fields.Count do
              begin
                lLayerField:=lMapXDataSet.Fields.Item[j];
                lRowValues.Item[lLayerField.Name].Value:=Nvl(FDataSet.FieldValues[lLayerField.Name]);
              end;
              FWdMapWrapper.DrawPictureBitmap(lLayer,'LITE1-32.BMP',16,lFeatureData,lRowValues);
            end;
            FDataSet.Next;
            if (FDataSet.RecNo mod PROGRESS_STEP)=0 then
              DoProgress(FDataSet.RecNo,FDataSet.RecordCount);
          end;
          DoProgress(FDataSet.RecordCount,FDataSet.RecordCount);
          lFeatureData.Free;
        end;
      except

      end;
    finally
      FMap.AutoRedraw:=true;
    end;
  end;
end;

procedure TLayerSvrThread.CreateMTULayer;
var
  lFeatureData:TFeatureData;
  lLayer:Layer;
  lMapXDataSet : CMapXDataSet;
  lRowValues : CMapXRowValues;
  lLayerField:Field;
  j:integer;
  lSqlstr: string;
begin
  FWdMapWrapper.DeleteLayerFile(UD_LAYER_MTU,FTmpPath);
  //创建图层
  //定义字段
  ClearTStrings(FFields);
  FFields.AddObject('',AddStringField('MTUID','MTUID',20));
  FFields.AddObject('',AddStringField('MTUNAME','MTUNAME',100));
  FFields.AddObject('',AddStringField('ALARMSTATUS','ALARMSTATUS',100));
//  FFields.AddObject('',AddStringField('BUILDINGNAME','室分点名称',100));
//  FFields.AddObject('',AddStringField('ADDRESS','室分点地址',200));
//  FFields.AddObject('',AddStringField('AREAID','所属区域编号',20));

  FWdMapWrapper.CreateLayer(UD_LAYER_MTU,FTmpPath,FFields);
  if FWdMapWrapper.GetLayer(UD_LAYER_MTU,lLayer) then
  begin
    FMap.AutoRedraw:=false;
    try
      //加载数据 室外的   {室内的不需要，根据他的室分点来}
      try
        lSqlstr:= 'select t.MTUID,t.MTUNAME,t.LONGITUDE,t.LATITUDE,decode(t1.alarmcount,NULL,''正常'',0,''正常'',''告警'') ALARMSTATUS'+
                  ' from MTU_INFO t'+
                  ' left join (select a.mtuid,sum(decode(b.mtuid,null,0,1)) alarmcount'+
                            ' from mtu_info a'+
                            ' left join alarm_master_online b on a.mtuid=b.mtuid and b.flowtache=2'+
                            ' group by a.mtuid) t1'+
                  ' on t.mtuid=t1.mtuid'+
                  ' where t.isprogram=0';
        FDataSet.Close;
        FDataSet.CommandText:= lSqlstr;
        FDataSet.Open;
        if FDataSet.RecordCount>0 then
        begin
          FDataSet.First;
          lMapXDataSet := FMap.Datasets.Add(miDataSetLayer,lLayer,emptyparam,emptyparam,
            emptyparam,emptyparam,emptyparam,emptyparam);
          lRowValues:=lMapXDataSet.RowValues[lMapXDataSet.RowCount];
          lFeatureData:=TFeatureData.Create;

          while not FDataSet.Eof do
          begin
            if Terminated then exit;
            if not (VarIsNull(FDataSet.FieldValues['Longitude']) or VarIsNull(FDataSet.FieldValues['Latitude']) ) then
            begin
              lFeatureData.Longitude:=FDataSet.FieldValues['Longitude'];
              lFeatureData.Latitude:=FDataSet.FieldValues['Latitude'];
              for j :=1  to lMapXDataSet.Fields.Count do
              begin
                lLayerField:=lMapXDataSet.Fields.Item[j];
                lRowValues.Item[lLayerField.Name].Value:=Nvl(FDataSet.FieldValues[lLayerField.Name]);
              end;
              FWdMapWrapper.DrawPictureBitmap(lLayer,'PIN5-32.BMP',16,lFeatureData,lRowValues);
            end;
            FDataSet.Next;
            if (FDataSet.RecNo mod PROGRESS_STEP)=0 then
              DoProgress(FDataSet.RecNo,FDataSet.RecordCount);
          end;
          DoProgress(FDataSet.RecordCount,FDataSet.RecordCount);
          lFeatureData.Free;
        end;
      except

      end;
    finally
      FMap.AutoRedraw:=true;
    end;
  end;
end;

procedure TLayerSvrThread.CreateRelationLayer;
//var
//  lFeatureData:TFeatureData;
//  lLayer:Layer;
//  lAngel1,lAngel2:double;
begin
//  FWdMapWrapper.DeleteLayerFile(UD_LAYER_RELATION,FTmpPath);
//  //创建图层
//  //定义字段
//  ClearTStrings(FFields);
//  FFields.AddObject('',AddStringField('REPEATER_ID','REPEATER_ID',50));
//  FFields.AddObject('',AddStringField('CELL_ID','CELL_ID',50));
//  FWdMapWrapper.CreateLayer(UD_LAYER_RELATION,FTmpPath,FFields);
//  if FWdMapWrapper.GetLayer(UD_LAYER_RELATION,lLayer) then
//  begin
//    self.FMap.AutoRedraw:=false;
//    try
//      //加载数据
//      lFeatureData:=TFeatureData.Create;
//      FWdPLBasic.Select('select t.id REPEATER_ID,t1.id CELL_ID,t.longitude rplongitude,t.latitude rplatitude,'+
//            't2.longitude celllongitude,t2.latitude celllatitude from device_repeaters t,device_cells t1,device_bts t2 '+
//            'where t.parent_cell_id=t1.id and t1.bts_id=t2.id and t1.CITYID='+IntToStr(FCityID)+
//            ' and t2.area_id in ('+FBranchStr+')');
//      while not FWdPLBasic.IsEof do
//      begin
//        if Terminated then exit;
//        if not ( VarIsNull(FWdPLBasic.FieldValues['rplongitude']) or
//                 VarIsNull(FWdPLBasic.FieldValues['rplatitude']) or
//                 VarIsNull(FWdPLBasic.FieldValues['celllongitude']) or
//                 VarIsNull(FWdPLBasic.FieldValues['celllatitude'])
//                 ) then
//        begin
//          
//          lFeatureData.KeyValue:=Nvl(FWdPLBasic.FieldValues['CELL_ID']);
//          lFeatureData.FieldValues['CELL_ID'] :=Nvl(FWdPLBasic.FieldValues['CELL_ID']);
//          lFeatureData.FieldValues['REPEATER_ID'] :=Nvl(FWdPLBasic.FieldValues['REPEATER_ID']);
//
//          FWdMapWrapper.DrawLine(UD_LAYER_RELATION,
//                FWdPLBasic.Query.FieldByName('rplongitude').AsFloat,
//                FWdPLBasic.Query.FieldByName('rplatitude').AsFloat,
//                FWdPLBasic.Query.FieldByName('celllongitude').AsFloat,
//                FWdPLBasic.Query.FieldByName('celllatitude').AsFloat,
//                1,$00914FF4,14,lFeatureData);
//        end;
//        FWdPLBasic.NextRecord;
//        if (FWdPLBasic.Query.RecNo mod PROGRESS_STEP)=0 then
//          DoProgress(FWdPLBasic.Query.RecNo,FWdPLBasic.Query.RecordCount);
//      end;
//      DoProgress(FWdPLBasic.Query.RecordCount,FWdPLBasic.Query.RecordCount);
//      lFeatureData.Free;
//    finally
//      self.FMap.AutoRedraw:=true;
//    end;
//  end;
end;

destructor TLayerSvrThread.Destroy;
begin
  if not FExitFlag then
  begin
    ClearTStrings(FFields);
    FFields.Free;
    ClearTStrings(FDatas);
    FDatas.Free;

    FSocketConn.Close;
    FSocketConn.Free;
    FMap.Free;
    FWdMapWrapper.Free;
    FExitFlag:=true;
  end;
  inherited Destroy;
end;

procedure TLayerSvrThread.DoEvent(aEventLevel:integer;aEventMsg:string);
begin
  FEventLevel:=aEventLevel;
  FEventMsg:=aEventMsg;
  Synchronize(ProcessEvent);
end;

procedure TLayerSvrThread.DoProgress(aPos, aMax: integer);
begin
  FProgressPos:=aPos;
  FProgressMax:=aMax;
  Synchronize(ProcessProgress);
end;

procedure TLayerSvrThread.Execute;
begin
  FProgressFlag:=TRUE;
  try
    if not FExitFlag then
    begin
      CoInitialize(nil);
      FSocketConn.ServerName:=ServerName;
      FSocketConn.Address:=IpAddress;
      FSocketConn.Port:=Port;

      FDataSet:= TClientDataSet.Create(nil);
      FDataSet.RemoteServer:= FSocketConn;
      FDataSet.ProviderName:= FProviderName;

      DoEvent(0,'创建图层线程启动');
      if (ltBuilding in FLayerTypeSet) and not self.Terminated then
      begin
        DoEvent(0,UD_LAYER_BUILDING+'创建中...');
        CreateBuildingLayer;
        DoEvent(0,UD_LAYER_BUILDING+'创建成功');
        Move_Layer(UD_LAYER_BUILDING);
      end;
      if (ltMTU in FLayerTypeSet) and not self.Terminated then
      begin
        DoEvent(0,UD_LAYER_MTU+'创建中...');
        CreateMTULayer;
        DoEvent(0,UD_LAYER_MTU+'创建成功');
        Move_Layer(UD_LAYER_MTU);
      end;
      if (ltCDMA in FLayerTypeSet) and not self.Terminated then
      begin
        DoEvent(0,UD_LAYER_CDMA+'创建中...');
        CreateCDMALayer;
        DoEvent(0,UD_LAYER_CDMA+'创建成功');
        Move_Layer(UD_LAYER_CDMA);
      end;
      if (ltDRS in FLayerTypeSet) and not self.Terminated then
      begin
        DoEvent(0,UD_LAYER_DRS+'创建中...');
        CreateDRSLayer;
        DoEvent(0,UD_LAYER_DRS+'创建成功');
        Move_Layer(UD_LAYER_DRS);
      end;

      FDataSet.Close;
      FDataSet.Free;
      DoEvent(1,'创建图层线程结束');
      CoUninitialize;
    end;
  finally
    FProgressFlag:=false;
  end;
end;

procedure TLayerSvrThread.Move_Layer(aLayerName:string);
var
  lFileName:string;
begin
  lFileName:=FTmpPath+aLayerName+'.tab' ;
  if FileExists(lFileName) then
    MoveFileEx(PChar(lFileName),PChar(FLayerPath+aLayerName+'.tab'),MOVEFILE_REPLACE_EXISTING);

  lFileName:=FTmpPath+aLayerName+'.id' ;
  if FileExists(lFileName) then
    MoveFileEx(PChar(lFileName),PChar(FLayerPath+aLayerName+'.id'),MOVEFILE_REPLACE_EXISTING);

  lFileName:=FTmpPath+aLayerName+'.dat' ;
  if FileExists(lFileName) then
    MoveFileEx(PChar(lFileName),PChar(FLayerPath+aLayerName+'.dat'),MOVEFILE_REPLACE_EXISTING);

  lFileName:=FTmpPath+aLayerName+'.map' ;
  if FileExists(lFileName) then
    MoveFileEx(PChar(lFileName),PChar(FLayerPath+aLayerName+'.map'),MOVEFILE_REPLACE_EXISTING);

  lFileName:=FTmpPath+aLayerName+'.ind' ;
  if FileExists(lFileName) then
    MoveFileEx(PChar(lFileName),PChar(FLayerPath+aLayerName+'.ind'),MOVEFILE_REPLACE_EXISTING);
end;

function TLayerSvrThread.Nvl(Value: Variant): string;
begin
if VarIsNull(Value) then
      result:='未知'
    else result:=Value;
end;

procedure TLayerSvrThread.ProcessEvent;
begin
  if assigned(FOnEvent) then FOnEvent(self,self.FEventLevel,self.FEventMsg);
end;

procedure TLayerSvrThread.ProcessProgress;
begin
  if assigned(FOnProgress) then
    FOnProgress(self,self.FProgressPos,self.FProgressMax);
end;

procedure TLayerSvrThread.SetPort(const Value: integer);
begin
  FPort := Value;
end;

procedure TLayerSvrThread.SetServerName(const Value: string);
begin
  FServerName := Value;
end;

end.
