 unit Ado_ConnectionPool;

 interface
 uses
   Windows,Classes,SysUtils, ADODB, SyncObjs,Variants,ADODB_TLB,ActiveX;
 type
  
 TAdoPoolConnection = record
    Connection: _Connection;
    InUse: Boolean;
    ReleaseTime: TDateTime;
  end;
  TAdoPoolBehavior = (pbAdoFail, pbAdoWait, pbAdoCreateAdditional);
  TConnectionPools=class(TInterfacedObject)
  private
    FCriticalSection:TCriticalSection;
    FAdoPoolConnection:array of TAdoPoolConnection;
    fPoolBehavior:TAdoPoolBehavior;
    FPoolSize:integer;
    FConnectionString:String;
    FDataBaseUser:String;
    FDataBasePass:String;
    procedure  SetConnectionString(const  Value:  string);
    procedure  SetDataBasePass(const  Value:  string);
    procedure  SetDataBaseUser(const  Value:  string);
  public
    procedure CreateInstance(out anInstance : _Connection);
    procedure ReleaseInstance(var anInstance:_Connection);
    constructor Create(aPoolSize : Integer;aPoolBehavior:TAdoPoolBehavior=pbAdoCreateAdditional);
    destructor Destroy; override;
    property  PoolSize: Integer read FPoolSize;
    property ConnectionString:String Read FConnectionString Write
    SetConnectionString;
    property DataBaseUser:String Read FDataBaseUser Write SetDataBaseUser;
    property DataBasePass:String Read FDataBasePass Write SetDataBasePass;
    procedure ClearPool();
    procedure Create_Connection(out anInstance : _Connection);
  end;
  var
    ConnectionPools:TConnectionPools;
  const
    err_NoFreeObjectsInPool = 'There are no Free Objects in the Pool. Try again ' +
    'later.';
    POOL_SLEEP_MS_WHILE_WAITING=500;
//////////////////////////////////////////////////////////////////////
implementation

constructor  TConnectionPools.Create(aPoolSize : Integer;
                       aPoolBehavior:TAdoPoolBehavior=pbAdoCreateAdditional);
begin
   inherited Create;
   FCriticalSection  :=  TCriticalSection.Create;
   FPoolSize  := aPoolSize;
   SetLength(FAdoPoolConnection, PoolSize);
   fPoolBehavior := aPoolBehavior;
end;
destructor  TConnectionPools.Destroy;
var
   i:  Integer;
begin
  for i := Low( FAdoPoolConnection) to High( FAdoPoolConnection) do
  FAdoPoolConnection[i].Connection:=Nil;
  FreeAndNil(fCriticalSection);
  inherited  Destroy;
end;

procedure TConnectionPools.Create_Connection(out anInstance : _Connection);
begin
  CoInitialize(NIL);
  try
    if anInstance<>Nil then
    begin
      if (anInstance<>NIL) and (anInstance.State=adStateOpen)
      then anInstance.Close;
      anInstance:=Nil;
    end;
    anInstance :=CoConnection.Create;
    try
      anInstance.Open(ConnectionPools.ConnectionString, ConnectionPools.DataBaseUser, ConnectionPools.DataBasePass, 0);
    except
     anInstance:=nil;
     Exit;
    end;
  finally
    CoUninitialize;
  end;
end;
procedure TConnectionPools.ClearPool;
var i:Integer;
begin
  fCriticalSection.Acquire();
  try

    for i := 0 to fPoolSize-1 do begin
      FAdoPoolConnection[i].InUse := false;
      FAdoPoolConnection[i].Connection := nil;
    end; { for }

  finally
    fCriticalSection.Release();
  end;
end;

procedure  TConnectionPools.SetConnectionString(const  Value:  string);
begin  
   FConnectionString  :=  Value;  
end;  
 
procedure  TConnectionPools.SetDataBasePass(const  Value:  string);  
begin  
   FDataBasePass  :=  Value;  
end;
procedure  TConnectionPools.SetDataBaseUser(const  Value:  string);
begin  
   FDataBaseUser  :=  Value;
end;

procedure TConnectionPools.CreateInstance(out anInstance: _Connection);
var i:Integer;
    //, refcnt : integer;
begin
  anInstance := nil;

  repeat

    fCriticalSection.Acquire();
    try

      for I := 0 to PoolSize-1 do
      begin
        if not FAdoPoolConnection[i].InUse then
        begin

          { is this pool instance initialized yet? if not, create pool instance now }
          if FAdoPoolConnection[i].Connection=Nil then
           Create_Connection(FAdoPoolConnection[i].Connection);

          { return instance and break loop }
          anInstance := FAdoPoolConnection[i].Connection;
          FAdoPoolConnection[i].InUse := True;
          break;

        end;
      end; { for }

    finally
      fCriticalSection.Release();
    end;

    if anInstance=Nil  then
      case fPoolBehavior of
        pbAdoFail:raise Exception.Create(err_NoFreeObjectsInPool);
        pbAdoWait:Sleep(POOL_SLEEP_MS_WHILE_WAITING);
        pbAdoCreateAdditional:Create_Connection(anInstance);
      end; { case }

  until (fPoolBehavior <> pbAdoWait) or (Assigned(anInstance));
end;

procedure TConnectionPools.ReleaseInstance(var anInstance: _Connection);
var i:Integer;
begin
  fCriticalSection.Acquire();
  try

    for i := 0 to fPoolSize-1 do begin
      if FAdoPoolConnection[i].Connection = anInstance then
      begin
        { return instance and break loop }
        anInstance := nil;
        FAdoPoolConnection[i].InUse := false;
        break;

      end;
    end;    { for }

  finally
    fCriticalSection.Release();
  end;
  if Assigned(anInstance) then anInstance := nil;
end;

{ TAdoPoolService }
initialization
  ConnectionPools:=TConnectionPools.Create(20);
finalization
  ConnectionPools.Free;
end.