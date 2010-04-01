unit ButtonXControl1_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2009-10-16 22:05:30 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\ActiveX\ButtonXControl1.tlb (1)
// LIBID: {EE08324F-31B8-4CA7-9DDE-54D88DFE89FF}
// LCID: 0
// Helpfile: 
// HelpString: ButtonXControl1 Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  ButtonXControl1MajorVersion = 1;
  ButtonXControl1MinorVersion = 0;

  LIBID_ButtonXControl1: TGUID = '{EE08324F-31B8-4CA7-9DDE-54D88DFE89FF}';

  IID_IButtonX: TGUID = '{793126C9-7333-4315-98AE-4A5B1E9E2C9B}';
  DIID_IButtonXEvents: TGUID = '{2A85A8A9-3FF8-47CC-BB30-89620CC21C44}';
  CLASS_ButtonX: TGUID = '{AD197781-A001-4958-B903-80CEF045CE59}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum TxDragMode
type
  TxDragMode = TOleEnum;
const
  dmManual = $00000000;
  dmAutomatic = $00000001;

// Constants for enum TxMouseButton
type
  TxMouseButton = TOleEnum;
const
  mbLeft = $00000000;
  mbRight = $00000001;
  mbMiddle = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IButtonX = interface;
  IButtonXDisp = dispinterface;
  IButtonXEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  ButtonX = IButtonX;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PPUserType1 = ^IFontDisp; {*}


// *********************************************************************//
// Interface: IButtonX
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {793126C9-7333-4315-98AE-4A5B1E9E2C9B}
// *********************************************************************//
  IButtonX = interface(IDispatch)
    ['{793126C9-7333-4315-98AE-4A5B1E9E2C9B}']
    function Get_Cancel: WordBool; safecall;
    procedure Set_Cancel(Value: WordBool); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Default: WordBool; safecall;
    procedure Set_Default(Value: WordBool); safecall;
    function Get_DragCursor: Smallint; safecall;
    procedure Set_DragCursor(Value: Smallint); safecall;
    function Get_DragMode: TxDragMode; safecall;
    procedure Set_DragMode(Value: TxDragMode); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function Get_Font: IFontDisp; safecall;
    procedure Set_Font(const Value: IFontDisp); safecall;
    procedure _Set_Font(var Value: IFontDisp); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_WordWrap: WordBool; safecall;
    procedure Set_WordWrap(Value: WordBool); safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    function Get_AlignDisabled: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    procedure InitiateAction; safecall;
    function IsRightToLeft: WordBool; safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    procedure SetSubComponent(IsSubComponent: WordBool); safecall;
    procedure AboutBox; safecall;
    function Get_MyTag: WordBool; safecall;
    procedure Set_MyTag(Value: WordBool); safecall;
    property Cancel: WordBool read Get_Cancel write Set_Cancel;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Default: WordBool read Get_Default write Set_Default;
    property DragCursor: Smallint read Get_DragCursor write Set_DragCursor;
    property DragMode: TxDragMode read Get_DragMode write Set_DragMode;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Font: IFontDisp read Get_Font write Set_Font;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property WordWrap: WordBool read Get_WordWrap write Set_WordWrap;
    property DoubleBuffered: WordBool read Get_DoubleBuffered write Set_DoubleBuffered;
    property AlignDisabled: WordBool read Get_AlignDisabled;
    property VisibleDockClientCount: Integer read Get_VisibleDockClientCount;
    property MyTag: WordBool read Get_MyTag write Set_MyTag;
  end;

// *********************************************************************//
// DispIntf:  IButtonXDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {793126C9-7333-4315-98AE-4A5B1E9E2C9B}
// *********************************************************************//
  IButtonXDisp = dispinterface
    ['{793126C9-7333-4315-98AE-4A5B1E9E2C9B}']
    property Cancel: WordBool dispid 201;
    property Caption: WideString dispid -518;
    property Default: WordBool dispid 202;
    property DragCursor: Smallint dispid 203;
    property DragMode: TxDragMode dispid 204;
    property Enabled: WordBool dispid -514;
    property Font: IFontDisp dispid -512;
    property Visible: WordBool dispid 205;
    property WordWrap: WordBool dispid 206;
    property DoubleBuffered: WordBool dispid 207;
    property AlignDisabled: WordBool readonly dispid 208;
    property VisibleDockClientCount: Integer readonly dispid 209;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; dispid 210;
    procedure InitiateAction; dispid 211;
    function IsRightToLeft: WordBool; dispid 212;
    function UseRightToLeftReading: WordBool; dispid 213;
    function UseRightToLeftScrollBar: WordBool; dispid 214;
    procedure SetSubComponent(IsSubComponent: WordBool); dispid 215;
    procedure AboutBox; dispid -552;
    property MyTag: WordBool dispid 216;
  end;

// *********************************************************************//
// DispIntf:  IButtonXEvents
// Flags:     (0)
// GUID:      {2A85A8A9-3FF8-47CC-BB30-89620CC21C44}
// *********************************************************************//
  IButtonXEvents = dispinterface
    ['{2A85A8A9-3FF8-47CC-BB30-89620CC21C44}']
    procedure OnClick; dispid 201;
    procedure OnKeyPress(var Key: Smallint); dispid 202;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TButtonX
// Help String      : ButtonX Control
// Default Interface: IButtonX
// Def. Intf. DISP? : No
// Event   Interface: IButtonXEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TButtonXOnKeyPress = procedure(ASender: TObject; var Key: Smallint) of object;

  TButtonX = class(TOleControl)
  private
    FOnClick: TNotifyEvent;
    FOnKeyPress: TButtonXOnKeyPress;
    FIntf: IButtonX;
    function  GetControlInterface: IButtonX;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function DrawTextBiDiModeFlagsReadingOnly: Integer;
    procedure InitiateAction;
    function IsRightToLeft: WordBool;
    function UseRightToLeftReading: WordBool;
    function UseRightToLeftScrollBar: WordBool;
    procedure SetSubComponent(IsSubComponent: WordBool);
    procedure AboutBox;
    property  ControlInterface: IButtonX read GetControlInterface;
    property  DefaultInterface: IButtonX read GetControlInterface;
    property DoubleBuffered: WordBool index 207 read GetWordBoolProp write SetWordBoolProp;
    property AlignDisabled: WordBool index 208 read GetWordBoolProp;
    property VisibleDockClientCount: Integer index 209 read GetIntegerProp;
  published
    property Anchors;
    property Cancel: WordBool index 201 read GetWordBoolProp write SetWordBoolProp stored False;
    property Caption: WideString index -518 read GetWideStringProp write SetWideStringProp stored False;
    property Default: WordBool index 202 read GetWordBoolProp write SetWordBoolProp stored False;
    property DragCursor: Smallint index 203 read GetSmallintProp write SetSmallintProp stored False;
    property DragMode: TOleEnum index 204 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property Enabled: WordBool index -514 read GetWordBoolProp write SetWordBoolProp stored False;
    property Font: TFont index -512 read GetTFontProp write SetTFontProp stored False;
    property Visible: WordBool index 205 read GetWordBoolProp write SetWordBoolProp stored False;
    property WordWrap: WordBool index 206 read GetWordBoolProp write SetWordBoolProp stored False;
    property MyTag: WordBool index 216 read GetWordBoolProp write SetWordBoolProp stored False;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnKeyPress: TButtonXOnKeyPress read FOnKeyPress write FOnKeyPress;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TButtonX.InitControlData;
const
  CEventDispIDs: array [0..1] of DWORD = (
    $000000C9, $000000CA);
  CTFontIDs: array [0..0] of DWORD = (
    $FFFFFE00);
  CControlData: TControlData2 = (
    ClassID: '{AD197781-A001-4958-B903-80CEF045CE59}';
    EventIID: '{2A85A8A9-3FF8-47CC-BB30-89620CC21C44}';
    EventCount: 2;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80040154*);
    Flags: $0000001C;
    Version: 401;
    FontCount: 1;
    FontIDs: @CTFontIDs);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnClick) - Cardinal(Self);
end;

procedure TButtonX.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IButtonX;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TButtonX.GetControlInterface: IButtonX;
begin
  CreateControl;
  Result := FIntf;
end;

function TButtonX.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := DefaultInterface.DrawTextBiDiModeFlagsReadingOnly;
end;

procedure TButtonX.InitiateAction;
begin
  DefaultInterface.InitiateAction;
end;

function TButtonX.IsRightToLeft: WordBool;
begin
  Result := DefaultInterface.IsRightToLeft;
end;

function TButtonX.UseRightToLeftReading: WordBool;
begin
  Result := DefaultInterface.UseRightToLeftReading;
end;

function TButtonX.UseRightToLeftScrollBar: WordBool;
begin
  Result := DefaultInterface.UseRightToLeftScrollBar;
end;

procedure TButtonX.SetSubComponent(IsSubComponent: WordBool);
begin
  DefaultInterface.SetSubComponent(IsSubComponent);
end;

procedure TButtonX.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TButtonX]);
end;

end.
