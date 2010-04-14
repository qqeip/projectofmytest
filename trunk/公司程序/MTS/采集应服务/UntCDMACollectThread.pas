unit UntCDMACollectThread;

interface

uses
  Classes, SysUtils, Ut_BaseThread, ADODB, Log, Ut_Global;

type
  TCDMACollectThread = class(TMyThread)
  private
    FAdoCon, FCDMAAdoCon : TAdoConnection;
    FQuery,FQueryFree, FQuerySeq: TAdoQuery;

    procedure DoExecute; override;


  public
    constructor Create(ConnStr :String; CDMAConnStr: String);
    destructor destroy; override;
  end;

implementation

uses UnitThreadCommon;



{ TCDMACollectThread }

constructor TCDMACollectThread.Create(ConnStr: String; CDMAConnStr: String);
begin
  inherited create;

  FAdoCon := TAdoConnection.Create(nil);
  FCDMAAdoCon := TAdoConnection.Create(nil);
  FAdoCon.ConnectionString :=ConnStr;
  FAdoCon.LoginPrompt := false;

  FCDMAAdoCon.ConnectionString :=CDMAConnStr;
  FCDMAAdoCon.LoginPrompt := false;
//  try
//    with FAdoCon do
//    begin
//      ConnectionString :=ConnStr;
//      LoginPrompt := false;
//      Connected:=true;
//    end;
//    with FCDMAAdoCon do
//    begin
//      ConnectionString :=CDMAConnStr;
//
//      Connected:=true;
//    end;
//  except
//    self.Log.Write('错误状态：CDMA数据库连接失败',1);
//    exit;
//  end;

  FQuery :=TAdoQuery.Create(nil);
  FQuery.Connection := FAdoCon;

  FQuerySeq :=TAdoQuery.Create(nil);
  FQuerySeq.Connection := FAdoCon;

  FQueryFree :=TAdoQuery.Create(nil);
  FQuery.LockType := ltBatchOptimistic;
  FQueryFree.Connection := FCDMAAdoCon;
end;

destructor TCDMACollectThread.destroy;
begin
  FQuerySeq.Close;
  FQuerySeq.Free;
  FQuery.Close;
  FQuery.Free;
  FQueryFree.Close;
  FQueryFree.Free;
  FAdoCon.Close;
  FAdoCon.Free;
  FCDMAAdoCon.Close;
  FCDMAAdoCon.Free;
  inherited destroy;
end;

procedure TCDMACollectThread.DoExecute;
var
  ID, I,J: Integer;
begin
  inherited;
  if not FAdoCon.Connected then
  begin
    try
      FAdoCon.Connected:=true;
    except
      FLog.Write('CDMA采集: 无法连接数据库!',1);
      Exit;
    end;
  end;
  if not FCDMAAdoCon.Connected then
  begin
    try
      FCDMAAdoCon.Connected:=true;
    except
      FLog.Write('CDMA采集: 无法连接数据库!',1);
      Exit;
    end;
  end;
  try
    with FQueryFree do
    begin
      Close;
      sql.Text:='select * from mtu_alarm_assistant_view';
      open;
    end;

    with FQuery do
    begin
      Close;
      sql.Text:='select * from mtu_alarm_assistant';
      open;
    end;

    if FQueryFree.IsEmpty then exit;

    FQueryFree.First;

    ID := 0;
    for I := 0 to FQuery.RecordCount - 1 do
    begin
      FQuery.Delete;
    end;
    for I := 0 to FQueryFree.RecordCount - 1 do
    begin
      //ID := GetSequence(FQuerySeq, 'mtu_alarmid');
      ID := ID+1;
      FQuery.Append;  

      for J := 0 to FQuery.FieldCount - 1 do
      begin
        FQuery.Fields[J].Value := FQueryFree.Fields[J].Value;
      end;
      FQuery.FieldByName('ID').AsInteger := ID;

      FQueryFree.Next;
    end;
    FQuery.CheckBrowseMode;
  
    try
      FAdoCon.BeginTrans;  
      FQuery.UpdateBatch();
      FAdoCon.CommitTrans;
    except
      self.Log.Write('错误状态：保存数据库失败',1);
      FAdoCon.RollbackTrans;
    end;

    with FQuery do
    begin
      Close;
      sql.Text:='truncate table  mtu_alarm_assistant_parased';
      ExecSQL;
    end;
    with FQuery do
    begin
      Close;
      sql.Text:='insert into mtu_alarm_assistant_parased (id, csid, sector, contentcode) select rownum id, csid, sector, contentcode from mtu_alarm_assistant_view';
      ExecSQL;
    end;
  finally
    FAdoCon.Connected:= false;
    FCDMAAdoCon.Connected:= false;
  end;
end;

end.
