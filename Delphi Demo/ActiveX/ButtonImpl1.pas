unit ButtonImpl1;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, ActiveX, Classes, Controls, Graphics, Menus, Forms, StdCtrls,
  ComServ, StdVCL, AXCtrls, ButtonXControl1_TLB;

type
  TButtonX = class(TActiveXControl, IButtonX)
  private
    { Private declarations }
    FDelphiControl: TButton;
    FEvents: IButtonXEvents;
    procedure ClickEvent(Sender: TObject);
    procedure KeyPressEvent(Sender: TObject; var Key: Char);
  protected
    { Protected declarations }
    procedure DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage); override;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    procedure InitializeControl; override;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function Get_AlignDisabled: WordBool; safecall;
    function Get_Cancel: WordBool; safecall;
    function Get_Caption: WideString; safecall;
    function Get_Default: WordBool; safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    function Get_DragCursor: Smallint; safecall;
    function Get_DragMode: TxDragMode; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_Font: IFontDisp; safecall;
    function Get_Visible: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    function Get_WordWrap: WordBool; safecall;
    function IsRightToLeft: WordBool; safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    procedure _Set_Font(var Value: IFontDisp); safecall;
    procedure AboutBox; safecall;
    procedure InitiateAction; safecall;
    procedure Set_Cancel(Value: WordBool); safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure Set_Default(Value: WordBool); safecall;
    procedure Set_DoubleBuffered(Value: WordBool); safecall;
    procedure Set_DragCursor(Value: Smallint); safecall;
    procedure Set_DragMode(Value: TxDragMode); safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    procedure Set_Font(const Value: IFontDisp); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    procedure Set_WordWrap(Value: WordBool); safecall;
    procedure SetSubComponent(IsSubComponent: WordBool); safecall;
    function Get_MyTag: WordBool; safecall;
    procedure Set_MyTag(Value: WordBool); safecall;

  end;

implementation

uses ComObj, About1;

{ TButtonX }

procedure TButtonX.DefinePropertyPages(DefinePropertyPage: TDefinePropertyPage);
begin
  {TODO: Define property pages here.  Property pages are defined by calling
    DefinePropertyPage with the class id of the page.  For example,
      DefinePropertyPage(Class_ButtonXPage); }
end;

procedure TButtonX.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IButtonXEvents;
end;

procedure TButtonX.InitializeControl;
begin
  FDelphiControl := Control as TButton;
  FDelphiControl.OnClick := ClickEvent;
  FDelphiControl.OnKeyPress := KeyPressEvent;
end;

function TButtonX.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := FDelphiControl.DrawTextBiDiModeFlagsReadingOnly;
end;

function TButtonX.Get_AlignDisabled: WordBool;
begin
  Result := FDelphiControl.AlignDisabled;
end;

function TButtonX.Get_Cancel: WordBool;
begin
  Result := FDelphiControl.Cancel;
end;

function TButtonX.Get_Caption: WideString;
begin
  Result := WideString(FDelphiControl.Caption);
end;

function TButtonX.Get_Default: WordBool;
begin
  Result := FDelphiControl.Default;
end;

function TButtonX.Get_DoubleBuffered: WordBool;
begin
  Result := FDelphiControl.DoubleBuffered;
end;

function TButtonX.Get_DragCursor: Smallint;
begin
  Result := Smallint(FDelphiControl.DragCursor);
end;

function TButtonX.Get_DragMode: TxDragMode;
begin
  Result := Ord(FDelphiControl.DragMode);
end;

function TButtonX.Get_Enabled: WordBool;
begin
  Result := FDelphiControl.Enabled;
end;

function TButtonX.Get_Font: IFontDisp;
begin
  GetOleFont(FDelphiControl.Font, Result);
end;

function TButtonX.Get_Visible: WordBool;
begin
  Result := FDelphiControl.Visible;
end;

function TButtonX.Get_VisibleDockClientCount: Integer;
begin
  Result := FDelphiControl.VisibleDockClientCount;
end;

function TButtonX.Get_WordWrap: WordBool;
begin
  Result := FDelphiControl.WordWrap;
end;

function TButtonX.IsRightToLeft: WordBool;
begin
  Result := FDelphiControl.IsRightToLeft;
end;

function TButtonX.UseRightToLeftReading: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftReading;
end;

function TButtonX.UseRightToLeftScrollBar: WordBool;
begin
  Result := FDelphiControl.UseRightToLeftScrollBar;
end;

procedure TButtonX._Set_Font(var Value: IFontDisp);
begin
  SetOleFont(FDelphiControl.Font, Value);
end;

procedure TButtonX.AboutBox;
begin
  ShowButtonXAbout;
end;

procedure TButtonX.ClickEvent(Sender: TObject);
begin
  if FEvents <> nil then FEvents.OnClick;
end;

procedure TButtonX.InitiateAction;
begin
  FDelphiControl.InitiateAction;
end;

procedure TButtonX.KeyPressEvent(Sender: TObject; var Key: Char);
var
  TempKey: Smallint;
begin
  TempKey := Smallint(Key);
  if FEvents <> nil then FEvents.OnKeyPress(TempKey);
  Key := Char(TempKey);
end;

procedure TButtonX.Set_Cancel(Value: WordBool);
begin
  FDelphiControl.Cancel := Value;
end;

procedure TButtonX.Set_Caption(const Value: WideString);
begin
  FDelphiControl.Caption := TCaption(Value);
end;

procedure TButtonX.Set_Default(Value: WordBool);
begin
  FDelphiControl.Default := Value;
end;

procedure TButtonX.Set_DoubleBuffered(Value: WordBool);
begin
  FDelphiControl.DoubleBuffered := Value;
end;

procedure TButtonX.Set_DragCursor(Value: Smallint);
begin
  FDelphiControl.DragCursor := TCursor(Value);
end;

procedure TButtonX.Set_DragMode(Value: TxDragMode);
begin
  FDelphiControl.DragMode := TDragMode(Value);
end;

procedure TButtonX.Set_Enabled(Value: WordBool);
begin
  FDelphiControl.Enabled := Value;
end;

procedure TButtonX.Set_Font(const Value: IFontDisp);
begin
  SetOleFont(FDelphiControl.Font, Value);
end;

procedure TButtonX.Set_Visible(Value: WordBool);
begin
  FDelphiControl.Visible := Value;
end;

procedure TButtonX.Set_WordWrap(Value: WordBool);
begin
  FDelphiControl.WordWrap := Value;
end;

procedure TButtonX.SetSubComponent(IsSubComponent: WordBool);
begin
  FDelphiControl.SetSubComponent(IsSubComponent);
end;

function TButtonX.Get_MyTag: WordBool;
begin
  Result := True;
end;

procedure TButtonX.Set_MyTag(Value: WordBool);
begin

end;

initialization
  TActiveXControlFactory.Create(
    ComServer,
    TButtonX,
    TButton,
    Class_ButtonX,
    1,
    '',
    0,
    tmApartment);
end.
