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
// ʵ��Ŀ�� :  �й���ʽ б�ߵ�Ԫ��                      �� ��������
// �޸ļ�¼ :   ����:�ɡ���
//              ����޸���:�ɡ�����  Email : Sinmax@163.net
// ����·�� :              ��������
// ��    ע : RM3.0  Puls��Ԫ                               ����������
//***********************************************************}

unit RM_Diagonal;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Menus, RM_Class, RM_Common
{$IFDEF Delphi6}, Variants{$ENDIF};

type
  TRMDiagonalObject = class(TComponent) // fake component
  end;

  { TRMDiagonalView }
  TRMDiagonalView = class(TRMCustomMemoView)
  private
    FGridLineWidth: integer;
    FGridLineColor: TColor;
  protected

    procedure DrawGrid;
    procedure DrawText(Canvas: TCanvas; Text: string);

  public

    constructor create; override;
    destructor Destroy; override;
    procedure Draw(aCanvas: TCanvas); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;

  published
    property GridLineWidth: integer read FGridLineWidth write FGridLineWidth;
    property GridLineColor: TColor read FGridLineColor write FGridLineColor;
  end;

implementation

uses RM_Utils, RM_Const, RM_Const1;

{TRMDiagonalView}

procedure TRMDiagonalView.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  FGridLineWidth := RMReadInt32(Stream);
  FGridLineColor := RMReadInt32(Stream);

end;

procedure TRMDiagonalView.SaveToStream(Stream: TStream);
begin

  inherited SaveToStream(Stream);
  RMWriteInt32(Stream, FGridLineWidth);
  RMWriteInt32(Stream, FGridLineColor);

end;

procedure TRMDiagonalView.DrawText(Canvas: TCanvas; Text: string);
  function WordCount(StrSS: string; SS: Char): integer;
  var
    S_count, i: integer;
  begin

    S_count := 0;
    if (StrSS = '') or (ss = '') then
    begin
      WordCount := 0;
      exit;
    end;
    for i := 0 to length(StrSS) do
    begin
      if StrSS[i] = SS then
        S_count := S_count + 1;
    end;
    Wordcount := S_count;
  end;

var
  AS1: array[1..3] of string;
  x, y, dx, dy: Integer;
  lineNumber, i, j, k: integer;
  S: string;
  R: TRect;
begin
  x := spLeft;
  y := spTop;
  dx := spWidth;
  dy := spHeight;
  R := Rect(x + 1, y + 1, x + dx - 1, y + dy - 1);

  lineNumber := WordCount(Text, ';'); //��������

  s := Trim(Text + ';;;');
  As1[1] := ' ';
  As1[2] := ' ';
  As1[3] := ' ';
  j := 0;
  k := 0;
  for i := 1 to Length(s) do
  begin
    if S[i] = ';' then
    begin
      k := K + 1;
      if K > 3 then
        break;
      if Length(Copy(S, j + 1, i - j - 1)) <> 0 then
        As1[k] := Copy(S, j + 1, i - j - 1);
      j := i;

    end;
  end;

  Canvas.Font.Assign(Font);

  case lineNumber of
    1: //һ����
      begin
        Canvas.Pen.Color := GridLineColor;
        Canvas.Pen.Width := GridLineWidth;
        Canvas.MoveTo(R.Left, R.Top);
        Canvas.LineTo(R.Right - 1, R.Bottom - 1);

        canvas.TextOut(r.Right - (Canvas.TextWidth(as1[1][1]) *
          length(AS1[1]) + 5), r.Top + 1, AS1[1]);
        canvas.TextOut(r.Left + 5, r.Bottom -
          Canvas.TextHeight(as1[2][1]) - 5, As1[2]);

      end;
    2:
      begin
        Canvas.Pen.Color := GridLineColor;
        Canvas.Pen.Width := GridLineWidth;
        Canvas.MoveTo(R.Left, R.Top);
        Canvas.LineTo(R.TopLeft.X + Round(ABS(R.Right - R.Left) / 2) -
          1, R.Bottom - 1);
        Canvas.MoveTo(R.Left, R.Top);
        Canvas.LineTo(R.Right - 1, R.TopLeft.Y + Round(ABS(R.Top -
          R.Bottom) / 2) - 1);
        canvas.TextOut(r.Right - (Canvas.TextWidth(as1[1][1]) *
          length(AS1[1]) + 5), r.Top + 1, AS1[1]);
        canvas.TextOut(r.Left + 5, r.Bottom -
          Canvas.TextHeight(as1[2][1]) - 5, As1[2]);
        canvas.TextOut(r.Right - (Canvas.TextWidth(as1[3][1]) *
          length(AS1[3]) + 5), r.Bottom - Canvas.TextHeight(as1[3][1]) -
          5, AS1[3]);
      end; //2����
    3:
      begin
        Canvas.Pen.Color := GridLineColor;
        Canvas.Pen.Width := GridLineWidth;
        Canvas.MoveTo(R.Right, R.Bottom);
        Canvas.LineTo(R.TopLeft.X + Round(ABS(R.Right - R.Left) / 2) -
          1, R.top - 1);
        Canvas.MoveTo(R.Right, R.Bottom);
        Canvas.LineTo(R.Left - 1, R.TopLeft.Y + Round(ABS(R.Top -
          R.Bottom) / 2) - 1);
        canvas.TextOut(r.Right - (Canvas.TextWidth(as1[1][1]) *
          length(AS1[1]) + 5), r.Top + 5, AS1[1]);
        canvas.TextOut(r.Left + 5, r.Bottom -
          Canvas.TextHeight(as1[2][1]) - 5, As1[2]);
        canvas.TextOut(r.Left + 5, r.top + 5, AS1[3]);
      end //2����  ��ʽ2
  else //if ̫���� ֻ��һ��
    begin
      Canvas.MoveTo(R.Left, R.Top);
      Canvas.LineTo(R.Right, R.Bottom);
    end;
  end;
end;

constructor TRMDiagonalView.create;
begin
  inherited Create;
  BaseName := 'Diagonal';
  GridLineWidth := 1; //�ָ��ߵĿ��
  GridLineColor := clblack; //�ָ��ߵ���ɫ

end;

destructor TRMDiagonalView.Destroy;
begin

  inherited Destroy;
end;

procedure TRMDiagonalView.DrawGrid;
var
  ARect: TRect;
  x, y, dx, dy: Integer;
begin
  x := spLeft;
  y := spTop;
  dx := spWidth;
  dy := spHeight;
  ARect := Rect(x + 1, y + 1, x + dx - 1, y + dy - 1);

  Canvas.Pen.Color := GridLineColor;
  Canvas.Pen.Width := GridLineWidth;
  Canvas.MoveTo(ARect.Left, ARect.Top);
  Canvas.LineTo(ARect.Right - 1, ARect.Bottom - 1);

end;

procedure TRMDiagonalView.Draw(aCanvas: TCanvas);

begin
  BeginDraw(aCanvas);
  Memo1.Assign(Memo);
  CalcGaps;
  ShowBackground;
  ShowFrame;

  if trim(Memo1.Text) <> '' then
    DrawText(aCanvas, trim(Memo1.Text)) //д��
  else
    drawGrid; //����

  RestoreCoord;
end;

initialization
  RMRegisterObjectByRes(TRMDiagonalView, 'RM_DiagonalObject', '�й���ʽ б�ߵ�Ԫ��', nil);

end.

