unit UnitDllMgr;

interface

uses Classes, Forms, SConnect, StringUtils, SysUtils, Windows,
     ProjectCFMS_Server_TLB, UnitVFMSGlobal;
type
  TShowForm = function(Application:TApplication;TempInterface: IDataModuleRemoteDisp; PublicParam:TPublicParameter; DllMessage: TDllMessage): TForm;
  TCloseForm = procedure; stdcall;
  TLocateTreeNode = procedure(aNodeText: string); stdcall;

  EDlllOadError = class(Exception);

  TPlugin = class(TObject)
  private
    FDllHandle: THandle;
    FName: string;
    FDllForm: TForm;
  public
    ShowForm: TShowForm;
    CloseForm: TCloseForm;
    LocateTreeNode: TLocateTreeNode;

    destructor Destroy; override;
    property DllHandle: THandle read FDllHandle write FDllHandle;
    property DllForm: TForm read FDllForm write FDllForm;
    property Name: string read FName write FName;


  end;

  TPluginMgr = class(TObject)
  private
    PluginList: TStrings;
    procedure FreePlugin(APluginName:String);overload;
  public
    constructor Create;
    destructor Destroy; override;
    procedure FreePlugin(AChildFormHandle: THandle);overload;
    procedure FreePlugin(AChildForm: TForm);overload; //free form
    function LoadPlugin(PluginName: string):TForm;
    function FindPlugin(ApluginName: string): TPlugin; overload;
    function GetPlugin(aFormName: string): TPlugin;
  end;

implementation

uses UnitDataModuleLocal;

constructor TPluginMgr.Create;
begin
  inherited Create;
  PluginList := TStringList.Create();
end;

destructor TPluginMgr.Destroy;
var
  i: Integer;
begin
  for i := pluginList.Count-1 downto 0 do
  begin
    (pluginList.Objects[i]).Free;
  end;
  FreeAndNil(PluginList);
  inherited Destroy;
end;

function TPluginMgr.FindPlugin(ApluginName: string): TPlugin;
begin
  if PluginList.IndexOf(ApluginName) = -1 then
    Result := nil
  else
    Result := TPlugin(PluginList.Objects[PluginList.IndexOf(ApluginName)]);
end;

procedure TPluginMgr.FreePlugin(AChildFormHandle: THandle);
var
  i: Integer;
  plg: TPlugin;
begin
  for i := PluginList.Count-1 downto 0 do
  begin
    plg := TPlugin(PluginList.Objects[i]);
    if Plg.DllForm.Handle = AChildFormHandle then
    begin
      FreePlugin(plg.FName);
      exit;
    end;
  end;
end;

procedure TPluginMgr.FreePlugin(APluginName:string);
begin
  PluginList.Objects[PluginList.IndexOf(APluginName)].Free;
  PluginList.Delete(PluginList.IndexOf(APluginName));
end;

function TPluginMgr.GetPlugin(aFormName: string): TPlugin;
var
  i: Integer;
  plg: TPlugin;
begin
  Result:= nil;
  for i := PluginList.Count-1 downto 0 do
  begin
    plg := TPlugin(PluginList.Objects[i]);
    if uppercase(Plg.DllForm.Name) = uppercase(aFormName) then
    begin
      Result:= plg;
      break;
    end;
  end;
end;

procedure TPluginMgr.FreePlugin(AChildForm: TForm);  //free form
var
  i: Integer;
  plg: TPlugin;
begin
  for i := PluginList.Count-1 downto 0 do
  begin
    plg := TPlugin(PluginList.Objects[i]);
    if Plg.DllForm = AChildForm then
    begin
      Plg.CloseForm;
      plg.DllForm:= nil;
      exit;
    end;
  end;
end;

function TPluginMgr.LoadPlugin(PluginName: string):TForm;
var
  plg: TPlugin;
begin
  //取得插件并将其装入到池中。
  result:=nil ;
  plg := FindPlugin(PluginName);
  if not (plg = nil) then
  begin
    with plg do
    begin
      if not Assigned(FDllForm) then
      begin
        @ShowForm := GetProcAddress(FDllHandle, 'CallDll');
        if @ShowForm = nil then exit;
        try
          DllForm := ShowForm(Application,DataModuleLocal.TempInterface,gPublicParam, gDllMessage);
          Result:= DllForm;
          Exit;
        except
        end;
      end
      else
      begin
        Result:=FDllForm;
        exit;
      end;
    end;
  end;
  plg := TPlugin.Create;
  with plg do
  begin
    Name := PluginName;
    FDllHandle := LoadLibrary(PChar(extractfilepath(application.ExeName) + PluginName));
    if FDllHandle = 0 then
    begin
      //raise EDLLLoadError.Create('不能载入 [' + extractfilepath(application.ExeName) + PluginName + ']模块文件!');
      Application.MessageBox(pchar('不能载入 [' + extractfilepath(application.ExeName) + PluginName + ']模块文件!'),'提示',MB_ICONWARNING	);
      FreeAndNil(plg);
      exit;
    end;

    @ShowForm := GetProcAddress(FDllHandle, 'CallDll');
    if @ShowForm = nil then exit;
    @CloseForm := GetProcAddress(FDllHandle, 'CloseForm');
    if @CloseForm = nil then exit;
    @LocateTreeNode:= GetProcAddress(FDllHandle, 'LocateTreeNode');
    if @LocateTreeNode = nil then exit;

    try
      DllForm := ShowForm(Application,DataModuleLocal.TempInterface,gPublicParam, gDllMessage);
      Result:= DllForm;
    except
      FreeLibrary(FDllHandle);
    end;
  end;
  PluginList.AddObject(plg.FName,plg);
end;

destructor TPlugin.Destroy;
begin
  inherited;
  CloseForm;
  FreeLibrary(FDllHandle);
  FDllHandle := 0; 
end;

end.
