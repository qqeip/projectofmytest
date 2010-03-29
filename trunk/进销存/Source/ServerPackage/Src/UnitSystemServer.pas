unit UnitSystemServer;

interface

 uses Windows, Classes, Forms, SysUtils, Dialogs;

type
  TSystemServer = class
  private
    procedure DestroyObject;

  protected
    fPluginList:TList;
    
    procedure LoadPlugins;
    procedure LoadPlugin(const aFileName: string);
    procedure UnLoadPlugins;
    procedure CreateObject;
  public
    procedure StartUp;
    procedure ShutDown;
    constructor create;
    destructor destroy;override;
    class function getInstance:TSystemServer;
  published

  end;

implementation


var
    instance:TSystemServer;

{ TSystemServer }

constructor TSystemServer.create;
begin
  inherited create;
  fPluginList:= TList.Create;
end;

destructor TSystemServer.destroy;
begin
  fPluginList.Free;
  inherited;
end;

class function TSystemServer.getInstance: TSystemServer;
begin
  if(not assigned(instance)) then begin
    instance:= TSystemServer.Create;
  end;
    result:=instance;
end;

procedure TSystemServer.StartUp;
begin
  LoadPlugins;
  CreateObject;
end;

procedure TSystemServer.ShutDown;
begin
  UnLoadPlugins;
  DestroyObject;
end;

procedure TSystemServer.LoadPlugins;
const
  cPLUGIN_MASK  ='*.bpl';
var
  sr: TSearchRec;
  path,strFile: string;
  Found: Integer;
begin
  path := ExtractFilePath(Application.Exename)+'Plugin\';
  try
    Found := FindFirst(path+ cPLUGIN_MASK, 0, sr);
    while Found = 0 do begin
      strFile :=path+sr.Name;
      LoadPlugin(strFile);
      Found := FindNext(sr);
    end;
  finally
    SysUtils.FindClose(sr);
  end;
end;

procedure TSystemServer.LoadPlugin(const aFileName: string);
var
  LibHandle: THandle;
begin
  try
    LibHandle := LoadPackage(Pchar(aFileName));
    fPluginList.Add(Pointer(LibHandle));
  except on E : Exception do begin
      MessageBeep(Word(-1));
      ShowMessage(E.Message);
      Application.Terminate;
    end;
  end;
end;

procedure TSystemServer.UnLoadPlugins;
var
  i,TmpHandle:Integer;

  procedure UnLoadAddInPackage(ModuleInstance: HMODULE);
  var
    i: Integer;
    M: TMemoryBasicInformation;
  begin
    for i := Application.ComponentCount - 1 downto 0 do
    begin
      VirtualQuery(Classes.GetClass(Application.Components[i].ClassName), M, SizeOf(M));
      if (ModuleInstance = 0) or (HMODULE(M.AllocationBase) = ModuleInstance) then
        Application.Components[i].Free;
    end;
    //下面这两个函式应该是只要取其中一个呼叫即可
    UnRegisterModuleClasses(ModuleInstance); //直接注销 Package
//    UnloadPackage(ModuleInstance); //间接注销 , 呼叫 Package 中 的 finalization
  end;

begin
//  for i:=fPluginList.Count-1 downto 0 do begin
  for i:=0 to fPluginList.Count-1 do begin
    TmpHandle :=Integer(fPluginList.items[0]);
    try
      UnLoadAddInPackage(TmpHandle);
//      UnloadPackage(TmpHandle);
    except
    end;
    fPluginList.Delete(0);
  end;
end;

procedure TSystemServer.CreateObject;
begin
//  CurUser:= Tuser.Create;
end;

procedure TSystemServer.DestroyObject;
begin
//  FreeAndNil(CurUser);
end;

end.
