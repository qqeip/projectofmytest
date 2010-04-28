unit UnitJumpButton;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, mmsystem;

type
  TBtnJump = class(TSpeedButton)
  private
    FOnClick: TNotifyEvent;
    FWavName: string;
    FWavChanged: boolean;
    FBmp_H,FBmp_L,FBmp :TBitmap;
    Timer1: TTimer;//闪烁计时器
    FCurrCounts: integer;
    procedure MyOnClick(Sender: TObject);
    procedure OnMyTimer(Sender: TObject);
    procedure SetWavName(const Value: string);
    procedure SetWavChanged(const Value: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property WavName: string read FWavName write SetWavName;
    property WavChanged: boolean read FWavChanged write SetWavChanged;

    procedure DisPlay;
    procedure CancelPlay;
    procedure DisShine;
    procedure CancelShine;
  end;

implementation
{$R BMP_new.RES}   //主意此资原文件不能少

{ TBtnJump }

procedure TBtnJump.CancelPlay;
begin
  sndPlaySound(nil, SND_LOOP);
end;

procedure TBtnJump.CancelShine;
begin
  Timer1.Enabled:= false;
  self.Glyph := FBmp;
  FCurrCounts:= 0;
end;

constructor TBtnJump.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBmp_H :=TBitmap.Create;
  FBmp_L :=TBitmap.Create;
  FBmp   :=TBitmap.Create;
  FBmp_H.LoadFromResourceName(hInstance,'HRED');
  FBmp_L.LoadFromResourceName(hInstance,'LRED');
  FBmp.LoadFromResourceName(hInstance,'GREEN');
  self.Glyph := FBmp;

  Timer1:= TTimer.Create(nil);
  Timer1.Enabled:= false;
  Timer1.Interval:= 1000;
  Timer1.OnTimer:= OnMyTimer;

  FCurrCounts:= 0;
  inherited OnClick := MyOnClick; //** override original OnClick method **//
end;

destructor TBtnJump.Destroy;
begin
  Timer1.Enabled:= false;
  Timer1.Free;
  FBmp_H.Free;
  FBmp_L.Free;
  FBmp.Free;
  inherited Destroy;
end;

procedure TBtnJump.DisPlay;
begin
  if FWavChanged then
  begin
    //先关闭
    CancelPlay;
    //重新播放
    sndPlaySound(pchar(FWavName), SND_NODEFAULT Or SND_ASYNC Or SND_LOOP);
  end;
end;

procedure TBtnJump.DisShine;
begin
  Timer1.Enabled:= true;
end;

procedure TBtnJump.MyOnClick(Sender: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Sender);
end;

procedure TBtnJump.OnMyTimer(Sender: TObject);
begin
  if (FCurrCounts mod 2 = 0) then
  begin
    self.Glyph := FBmp_H;
  end
  else
  begin
    self.Glyph := FBmp_L;
  end;
  Inc(FCurrCounts);
end;

procedure TBtnJump.SetWavChanged(const Value: boolean);
begin
  FWavChanged := Value;
end;

procedure TBtnJump.SetWavName(const Value: string);
begin
  FWavName := Value;
end;

end.
