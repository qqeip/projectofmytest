{***********************************************************
// �������� :
// ��    �� :  None
//
// ��    �� :  �ӣɣΣͣ���            ��������������������
// �������� "._`-.�������� (\-.��              ��
// ������������'-.`;.--.___/ _`>��     ������������
// �������������� `"( )����, ) ��      ����������
// ������������������\\----\-\��       ����������
// ������ ~~ ~~~~~~ "" ~~ """ ~~~~~~~~~��������
// �������� :  2003-01-06      ��
// ʵ��Ŀ�� :  CheckBox ��Ԫ��                        �� ��������
// �޸ļ�¼ :   ���ߣ�WHF
// ����޸��ˡ� ������  Email : Sinmax@163.net
// ����·�� :              ��������
// ��    ע : RM3.0  Puls  CheckBox  ��Ԫ                               ����������
//***********************************************************}

unit RM_CheckBox;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Menus, RM_Class, RM_Common
{$IFDEF USE_INTERNAL_JVCL}, rm_JvInterpreter{$ELSE}, JvInterpreter{$ENDIF}
{$IFDEF Delphi6}, Variants{$ENDIF};

type
  TRMCheckBoxObject = class(TComponent) // fake component
  end;

  TRMCheckStyle = (rmcsCross, rmcsCheck);

  { TRMCheckBoxView }
  TRMCheckBoxView = class(TRMReportView)
  private
    FCheckStyle: TRMCheckStyle;
    FCheckColor: TColor;
  protected
    procedure PlaceOnEndPage(aStream: TStream); override;
  	function GetViewCommon: string; override;
  public
    constructor create; override;
    destructor Destroy; override;
    procedure Draw(aCanvas: TCanvas); override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
  published
    property CheckColor: TColor read FCheckColor write FCheckColor;
    property CheckStyle: TRMCheckStyle read FCheckStyle write FCheckStyle;
    property DataField;
    property ShiftWith;
    property ReprintOnOverFlow;
  end;

implementation

uses RM_Utils, RM_Const, RM_Const1;
{ TRMCheckBoxView }

constructor TRMCheckBoxView.create;
begin
  inherited Create;
  BaseName := 'Check';
  CheckStyle := rmcsCross;
end;

destructor TRMCheckBoxView.Destroy;
begin
  inherited Destroy;
end;

procedure TRMCheckBoxView.Draw(aCanvas: TCanvas);
var
  liChecked: Boolean;

  procedure _DrawCheck;
  var
    x, y, dx, dy: Integer;
    TheRect: TRect;
    S: string;
  begin
    x := spLeft;
    y := spTop;
    dx := spWidth;
    dy := spHeight;
    TheRect := Rect(x + 1, y + 1, x + dx - 1, y + dy - 1);
    Inflaterect(TheRect, -2, -2);
    with Canvas do
    begin
      Font.Name := 'Wingdings';
      Font.Color := CheckColor; //ClBlack;
      Font.Style := [];
      Font.Height := -(TheRect.Bottom - TheRect.Top);
      Font.CharSet := DEFAULT_CHARSET;
      if CheckStyle = rmcsCross then
        s := #251
      else
        s := #252;
      ExtTextOut(Handle, TheRect.Left + (TheRect.Right - TheRect.Left - TextWidth(s)) div 2,
        TheRect.Top, ETO_CLIPPED, @TheRect, PChar(s), 1, nil);
    end;
  end;

begin
  BeginDraw(aCanvas);
  Memo1.Assign(Memo);
  CalcGaps;
  ShowBackground;
  ShowFrame;
  liChecked := False;
  if DocMode = rmdmDesigning then
    liChecked := True
  else if (Memo1.Count > 0) and (Memo1[0] <> '') then
    liChecked := Memo1[0][1] <> '0';

  if liChecked then
    _DrawCheck;
  RestoreCoord;
end;

procedure TRMCheckBoxView.PlaceOnEndPage(aStream: TStream);
begin
  BeginDraw(Canvas);
  Memo1.Assign(Memo);
  InternalOnBeforePrint(Memo1, Self);
  if not Visible then Exit;

  if Memo1.Count > 0 then
    Memo1[0] := IntToStr(Trunc(ParentReport.Parser.Calc(Memo1[0])));

  aStream.Write(Typ, 1);
  RMWriteString(aStream, ClassName);
  SaveToStream(aStream);
end;

procedure TRMCheckBoxView.LoadFromStream(aStream: TStream);
begin
  inherited LoadFromStream(aStream);
  RMReadWord(aStream);
  FCheckColor := RMReadInt32(aStream);
  FCheckStyle := TRMCheckStyle(RMReadByte(aStream));
end;

procedure TRMCheckBoxView.SaveToStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 0);
  RMWriteInt32(aStream, FCheckColor);
  RMWriteByte(aStream, Byte(FCheckStyle));
end;

function TRMCheckBoxView.GetViewCommon: string;
begin
	Result := '[CheckBox]';
end;

const
	cRM = 'RM_CheckBox';

procedure RM_RegisterRAI2Adapter(RAI2Adapter: TJvInterpreterAdapter);
begin
  with RAI2Adapter do
  begin
    AddClass(cRM, TRMCheckBoxView, 'TRMCheckBoxView');
  end;
end;

initialization
  RM_RegisterRAI2Adapter(GlobalJvInterpreterAdapter);
  RMRegisterObjectByRes(TRMCheckBoxView, 'RM_CHBOXOBJECT', RMLoadStr(SInsCheckBox), nil);

end.

