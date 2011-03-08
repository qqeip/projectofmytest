{*******************************************************}
{                                                       }
{         Delphi VCL Extensions (RX)                    }
{                                                       }
{         Copyright (c) 1997 Master-Bank                }
{                                                       }
{*******************************************************}

unit unHook;

{$T-,W-,X+,P+}

interface

uses Windows,Messages, SysUtils, Classes, Controls, Forms,contnrs;

type
  PClass = ^TClass;
  THookMessageEvent = procedure (Sender: TObject; Handle: HWnd;var Msg: TMessage;
    var Handled: Boolean) of object;
  TWinHookList=class;
  TWinHook = class(TComponent)
  private
    FActive: Boolean;
    FControl: TWinControl;
    FControlHook: TObject;
    FBeforeMessage: THookMessageEvent;
    FAfterMessage: THookMessageEvent;
    function GetWinControl: TWinControl;
    function GetHookHandle: HWnd;
    procedure SetActive(Value: Boolean);
    procedure SetWinControl(Value: TWinControl);
    function IsForm: Boolean;
    function NotIsForm: Boolean;
    function DoUnhookControl: Pointer;
    procedure ReadForm(Reader: TReader);
    procedure WriteForm(Writer: TWriter);
  protected
    FWinHookList:TWinHookList;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoAfterMessage(Handle: HWnd;var Msg: TMessage; var Handled: Boolean); dynamic;
    procedure DoBeforeMessage(Handle: HWnd;var Msg: TMessage; var Handled: Boolean); dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure HookControl;
    procedure UnhookControl;
    property HookWindow: HWnd read GetHookHandle;
  published
    property Active: Boolean read FActive write SetActive default True;
    property WinControl: TWinControl read GetWinControl write SetWinControl
      stored NotIsForm;
    property BeforeMessage: THookMessageEvent read FBeforeMessage write FBeforeMessage;
    property AfterMessage: THookMessageEvent read FAfterMessage write FAfterMessage;
  end;
  TWinHookList=class(TComponent)
    private
      FObjectList:TObjectList;
      FAfterMessage: THookMessageEvent;
      FBeforeMessage: THookMessageEvent;
      function GetActive:boolean;
      procedure SetActive(Value:boolean);
    public
      constructor Create(AOwner:TComponent);override;
      destructor Destroy;override;
      procedure Add(WinHook:TWinHook);
      procedure Remove(WinHook:TWinHook);
      procedure Clear;
      function WinHookItem(intIdx:integer):TWinHook;overload;
      function WinHookItem(aWinControl:TWinControl):TWinHook;overload;
      function GetWinControl(Handle: HWnd):TWinControl;
    published
      property Active:boolean read GetActive write SetActive;
      property BeforeMessage: THookMessageEvent read FBeforeMessage write FBeforeMessage;
      property AfterMessage: THookMessageEvent read FAfterMessage write FAfterMessage;
  end;

const
{ Command message for Speedbar editor }
  CM_SPEEDBARCHANGED = CM_BASE + 80;
{ Command message for TRxSpeedButton }
  CM_RXBUTTONPRESSED = CM_BASE + 81;
{ Command messages for TWinHook }
  CM_RECREATEWINDOW  = CM_BASE + 82;
  CM_DESTROYHOOK     = CM_BASE + 83;
{ Notify message for TRxTrayIcon }
  CM_TRAYICON        = CM_BASE + 84;

function GetVirtualMethodAddress(AClass: TClass; AIndex: Integer): Pointer;
function SetVirtualMethodAddress(AClass: TClass; AIndex: Integer;
  NewAddress: Pointer): Pointer;
function FindVirtualMethodIndex(AClass: TClass; MethodAddr: Pointer): Integer;

implementation

type
  THack = class(TWinControl);
  THookOrder = (hoBeforeMsg, hoAfterMsg);

{ TControlHook }

  TControlHook = class(TObject)
  private
    FControl: TWinControl;
    FNewWndProc: Pointer;
    FPrevWndProc: Pointer;
    FList: TList;
    FDestroying: Boolean;
    procedure SetWinControl(Value: TWinControl);
    procedure HookWndProc(var AMsg: TMessage);
    procedure NotifyHooks(Order: THookOrder; Handle: HWnd; var Msg: TMessage;
      var Handled: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure HookControl;
    procedure UnhookControl;
    procedure AddHook(AHook: TWinHook);
    procedure RemoveHook(AHook: TWinHook);
    property WinControl: TWinControl read FControl write SetWinControl;
  end;

{ THookList }

  THookList = class(TList)
  private
    FHandle: HWnd;
    procedure WndProc(var Msg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    function FindControlHook(AControl: TWinControl): TControlHook;
    function GetControlHook(AControl: TWinControl): TControlHook;
    property Handle: HWnd read FHandle;
  end;

var
  HookList: THookList;

function GetHookList: THookList;
begin
  if HookList = nil then HookList := THookList.Create;
  Result := HookList;
end;

procedure DropHookList; far;
begin
  HookList.Free;
  HookList := nil;
end;

{ TControlHook }

constructor TControlHook.Create;
begin
  inherited Create;
  FList := TList.Create;
  FNewWndProc := MakeObjectInstance(HookWndProc);
  FPrevWndProc := nil;
  FControl := nil;
end;

destructor TControlHook.Destroy;
begin
  FDestroying := True;
  if Assigned(HookList) then
    if HookList.IndexOf(Self) >= 0 then HookList.Remove(Self);
  while FList.Count > 0 do RemoveHook(TWinHook(FList.Last));
  FControl := nil;
  FList.Free;
  FreeObjectInstance(FNewWndProc);
  FNewWndProc := nil;
  inherited Destroy;
end;

procedure TControlHook.AddHook(AHook: TWinHook);
begin
  if FList.IndexOf(AHook) < 0 then begin
    FList.Add(AHook);
    AHook.FControlHook := Self;
    WinControl := AHook.FControl;
  end;
  HookControl;
end;

procedure TControlHook.RemoveHook(AHook: TWinHook);
begin
  AHook.FControlHook := nil;
  FList.Remove(AHook);
  if FList.Count = 0 then UnhookControl;
end;

procedure TControlHook.NotifyHooks(Order: THookOrder;Handle: HWnd; var Msg: TMessage;
  var Handled: Boolean);
var
  I: Integer;
begin
  if (FList.Count > 0) and Assigned(FControl) and
    not (FDestroying or (csDestroying in FControl.ComponentState)) then
    for I := FList.Count - 1 downto 0 do begin
      try
        if Order = hoBeforeMsg then
          TWinHook(FList[I]).DoBeforeMessage(Handle,Msg, Handled)
        else if Order = hoAfterMsg then
          TWinHook(FList[I]).DoAfterMessage(Handle,Msg, Handled);
      except
        Application.HandleException(Self);
      end;
      if Handled then Break;
    end;
end;

procedure TControlHook.HookControl;
var
  P: Pointer;
begin
  if Assigned(FControl) and not ((csDesigning in FControl.ComponentState) or
    (csDestroying in FControl.ComponentState) or FDestroying) then
  begin
    FControl.HandleNeeded;
    P := Pointer(GetWindowLong(FControl.Handle, GWL_WNDPROC));
    if (P <> FNewWndProc) then begin
      FPrevWndProc := P;
      SetWindowLong(FControl.Handle, GWL_WNDPROC, LongInt(FNewWndProc));
    end;
  end;
end;

procedure TControlHook.UnhookControl;
begin
  if Assigned(FControl) then begin
    if Assigned(FPrevWndProc) and FControl.HandleAllocated and
    (Pointer(GetWindowLong(FControl.Handle, GWL_WNDPROC)) = FNewWndProc) then
      SetWindowLong(FControl.Handle, GWL_WNDPROC, LongInt(FPrevWndProc));
  end;
  FPrevWndProc := nil;
end;

procedure TControlHook.HookWndProc(var AMsg: TMessage);
var
  Handled: Boolean;
begin
  Handled := False;
  if Assigned(FControl) then begin
    if (AMsg.Msg <> WM_QUIT) then NotifyHooks(hoBeforeMsg, FControl.Handle,AMsg, Handled);
    with AMsg do begin
      if (not Handled) or (Msg = WM_DESTROY) then
        try
          if Assigned(FPrevWndProc) then
            Result := CallWindowProc(FPrevWndProc, FControl.Handle, Msg,
              WParam, LParam)
          else
            Result := CallWindowProc(THack(FControl).DefWndProc,
              FControl.Handle, Msg, WParam, LParam);
        finally
          NotifyHooks(hoAfterMsg,FControl.Handle,AMsg, Handled);
        end;
      if Msg = WM_DESTROY then begin
        UnhookControl;
        if Assigned(HookList) and not (FDestroying or
          (csDestroying in FControl.ComponentState)) then
          PostMessage(HookList.FHandle, CM_RECREATEWINDOW, 0, Longint(Self));
      end;
    end;
  end;
end;

procedure TControlHook.SetWinControl(Value: TWinControl);
begin
  if Value <> FControl then begin
    UnhookControl;
    FControl := Value;
    if FList.Count > 0 then HookControl;
  end;
end;

{ THookList }

constructor THookList.Create;
begin
  inherited Create;
  FHandle := AllocateHWnd(WndProc);
end;

destructor THookList.Destroy;
begin
  while Count > 0 do TControlHook(Last).Free;
  DeallocateHWnd(FHandle);
  inherited Destroy;
end;

procedure THookList.WndProc(var Msg: TMessage);
var
  Hook: TControlHook;
begin
  try
    with Msg do begin
      if Msg = CM_RECREATEWINDOW then begin
        Hook := TControlHook(LParam);
        if (Hook <> nil) and (IndexOf(Hook) >= 0) then
          Hook.HookControl;
      end
      else if Msg = CM_DESTROYHOOK then begin
        Hook := TControlHook(LParam);
        if Assigned(Hook) and (IndexOf(Hook) >= 0) and
          (Hook.FList.Count = 0) then Hook.Free;
      end
      else Result := DefWindowProc(FHandle, Msg, wParam, lParam);
    end;
  except
    Application.HandleException(Self);
  end;
end;

function THookList.FindControlHook(AControl: TWinControl): TControlHook;
var
  I: Integer;
begin
  if Assigned(AControl) then
    for I := 0 to Count - 1 do
      if (TControlHook(Items[I]).WinControl = AControl) then begin
        Result := TControlHook(Items[I]);
        Exit;
      end;
  Result := nil;
end;

function THookList.GetControlHook(AControl: TWinControl): TControlHook;
begin
  Result := FindControlHook(AControl);
  if Result = nil then begin
    Result := TControlHook.Create;
    try
      Add(Result);
      Result.WinControl := AControl;
    except
      Result.Free;
      raise;
    end;
  end;
end;

{ TWinHook }

constructor TWinHook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := True;
end;

destructor TWinHook.Destroy;
begin
  Active := False;
  WinControl := nil;
  inherited Destroy;
end;

procedure TWinHook.SetActive(Value: Boolean);
begin
  if FActive <> Value then
    if Value then HookControl else UnhookControl;
end;

function TWinHook.GetHookHandle: HWnd;
begin
  if Assigned(HookList) then Result := HookList.Handle
  else
    Result := INVALID_HANDLE_VALUE; 
end;

procedure TWinHook.HookControl;
begin
  if Assigned(FControl) and not (csDestroying in ComponentState) then
    GetHookList.GetControlHook(FControl).AddHook(Self);
  FActive := True;
end;

function TWinHook.DoUnhookControl: Pointer;
begin
  Result := FControlHook;
  if Result <> nil then TControlHook(Result).RemoveHook(Self);
  FActive := False;
end;

procedure TWinHook.UnhookControl;
begin
  DoUnhookControl;
  FActive := False;
end;

function TWinHook.NotIsForm: Boolean;
begin
  Result := (WinControl <> nil) and not (WinControl is TCustomForm);
end;

function TWinHook.IsForm: Boolean;
begin
  Result := (WinControl <> nil) and ((WinControl = Owner) and
    (Owner is TCustomForm));
end;

procedure TWinHook.ReadForm(Reader: TReader);
begin
  if Reader.ReadBoolean then
    if Owner is TCustomForm then WinControl := TWinControl(Owner);
end;

procedure TWinHook.WriteForm(Writer: TWriter);
begin
  Writer.WriteBoolean(IsForm);
end;

procedure TWinHook.DefineProperties(Filer: TFiler);
  function DoWrite: Boolean;
  begin
    if Assigned(Filer.Ancestor) then
      Result := IsForm <> TWinHook(Filer.Ancestor).IsForm
    else Result := IsForm;
  end;
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('IsForm', ReadForm, WriteForm,
    DoWrite);
end;

function TWinHook.GetWinControl: TWinControl;
begin
  if Assigned(FControlHook) then Result := TControlHook(FControlHook).WinControl
  else Result := FControl;
end;

procedure TWinHook.DoAfterMessage(Handle: HWnd;var Msg: TMessage; var Handled: Boolean);
begin
  if Assigned(FWinHookList) and Assigned(FWinHookList.AfterMessage) then
    FWinHookList.AfterMessage(FWinHookList,Handle,Msg, Handled);
  if Assigned(FAfterMessage) then FAfterMessage(Self,Handle,Msg, Handled);
end;

procedure TWinHook.DoBeforeMessage(Handle: HWnd;var Msg: TMessage; var Handled: Boolean);
begin
  if Assigned(FWinHookList) and Assigned(FWinHookList.BeforeMessage) then
    FWinHookList.BeforeMessage(FWinHookList,Handle,Msg, Handled);
  if Assigned(FBeforeMessage) then FBeforeMessage(Self,Handle,Msg, Handled);
end;

procedure TWinHook.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = WinControl) and (Operation = opRemove) then
    WinControl := nil
  else if (Operation = opRemove) and ((Owner = AComponent) or
    (Owner = nil)) then WinControl := nil;
end;

procedure TWinHook.SetWinControl(Value: TWinControl);
var
  SaveActive: Boolean;
  Hook: TControlHook;
begin
  if Value <> WinControl then begin
    SaveActive := FActive;
    Hook := TControlHook(DoUnhookControl);
    FControl := Value;
    if Value <> nil then Value.FreeNotification(Self);
    if Assigned(Hook) and (Hook.FList.Count = 0) and Assigned(HookList) then
      PostMessage(HookList.Handle, CM_DESTROYHOOK, 0, Longint(Hook));
    if SaveActive then HookControl;
  end;
end;

{ SetVirtualMethodAddress procedure. Destroy destructor has index 0,
  first user defined virtual method has index 1. }

type
  PPointer = ^Pointer;

function GetVirtualMethodAddress(AClass: TClass; AIndex: Integer): Pointer;
var
  Table: PPointer;
begin
  Table := PPointer(AClass);
  Inc(Table, AIndex - 1);
  Result := Table^;
end;

function SetVirtualMethodAddress(AClass: TClass; AIndex: Integer;
  NewAddress: Pointer): Pointer;
const
  PageSize = SizeOf(Pointer);
var
  Table: PPointer;
  SaveFlag: DWORD;
begin
  Table := PPointer(AClass);
  Inc(Table, AIndex - 1);
  Result := Table^;
  if VirtualProtect(Table, PageSize, PAGE_EXECUTE_READWRITE, @SaveFlag) then
  try
    Table^ := NewAddress;
  finally
    VirtualProtect(Table, PageSize, SaveFlag, @SaveFlag);
  end;
end;

function FindVirtualMethodIndex(AClass: TClass; MethodAddr: Pointer): Integer;
begin
  Result := 0;
  repeat
    Inc(Result);
  until (GetVirtualMethodAddress(AClass, Result) = MethodAddr);
end;

{ TWinHookList }

procedure TWinHookList.Add(WinHook: TWinHook);
begin
  WinHook.FWinHookList:=Self;
  FObjectList.Add(WinHook);
end;

procedure TWinHookList.Clear;
begin
  FObjectList.Clear;
end;

function TWinHookList.WinHookItem(intIdx: integer): TWinHook;
begin
  Result:=TWinHook(FObjectList.Items[intIdx]);
end;

function TWinHookList.GetWinControl(Handle: HWnd): TWinControl;
var
  intIdx:integer;
begin
  for intIdx:=0 to FObjectList.Count-1 do
  begin
    result:=TWinHook(FObjectList.Items[intIdx]).WinControl;
    if Handle=TWinControl(result).Handle then exit;
  end;
  result:=nil;
end;

function TWinHookList.WinHookItem(aWinControl: TWinControl): TWinHook;
var
  intI:integer;
begin
  for intI:=0 to FObjectList.Count-1 do
  begin
    Result:=TWinHook(FObjectList.Items[intI]);
    if result.WinControl.Handle=aWinControl.Handle then
      Exit;
  end;
  Result:=nil;
end;

procedure TWinHookList.Remove(WinHook: TWinHook);
begin
  FObjectList.Remove(WinHook);
end;

constructor TWinHookList.Create(AOwner: TComponent);
begin
  FObjectList:=TObjectList.Create;
end;

destructor TWinHookList.Destroy;
begin
  FreeAndNil(FObjectList);
  inherited;
end;

function TWinHookList.GetActive: boolean;
var
  intIdx:integer;
begin
  result:=FObjectList.Count>0;
  for intIdx:=0 to FObjectList.Count-1 do
    result:=result and TWinHook(FObjectList.Items[intIdx]).Active;
end;

procedure TWinHookList.SetActive(Value: boolean);
var
  intIdx:integer;
begin
  for intIdx:=0 to FObjectList.Count-1 do
    TWinHook(FObjectList.Items[intIdx]).Active:=true;
end;

initialization
  HookList := nil;
finalization
  DropHookList;
end.
