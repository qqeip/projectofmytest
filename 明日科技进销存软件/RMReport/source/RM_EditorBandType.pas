
{*****************************************}
{                                         }
{          Report Machine v2.0            }
{           Select Band dialog            }
{                                         }
{*****************************************}

unit RM_EditorBandType;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, RM_Class, RM_Const;

type
  TRMBandTypesForm = class(TForm)
    btnOK: TButton;
    grbBands: TGroupBox;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure bClick(Sender: TObject);
    procedure Localize;
  public
    { Public declarations }
    SelectedTyp: TRMBandType;
    IsSubreport: Boolean;
  end;

implementation

uses RM_Designer, RM_Utils;

{$R *.DFM}

procedure TRMBandTypesForm.FormShow(Sender: TObject);
var
  b: TRadioButton;
  i: Integer;
  First: Boolean;
  ItemMaxLen: Integer;

  function FindMaxLen: Integer;
  var
    bt: TRMBandType;
  begin
    Result := 0;
    for bt := rmbtReportTitle to rmbtNone do
    begin
      if Canvas.TextWidth(RMBandNames[bt]) > Result then
        Result := Canvas.TextWidth(RMBandNames[bt]);
    end;
    Result := Result + 20;
  end;

begin
	Localize;
  First := True;
  ItemMaxLen := FindMaxLen;
  grbBands.ClientWidth := ItemMaxLen * 2 + 12 * 2 + 30;
  ClientWidth := grbBands.Width + grbBands.Left * 2;
  btnOK.Left := ClientWidth - btnOK.Width - btnCancel.Width - 10;
  btnCancel.Left := ClientWidth - btnOK.Width - 5;
  for i := Ord(rmbtReportTitle) to Ord(rmbtNone) - 1 do
  begin
    b := TRadioButton.Create(grbBands);
    b.Parent := grbBands;
    if i > 10 then
    begin
      b.Left := ItemMaxLen + 12 + 30;
      b.Top := (i - 11) * 20 + 20;
    end
    else
    begin
      b.Left := 12;
      b.Top := i * 20 + 20;
    end;
    b.Width := Canvas.TextWidth(RMBandNames[TRMBandType(i)]) + 20;
    b.Tag := i;
    b.Caption := RMBandNames[TRMBandType(i)];
    b.OnClick := bClick;
    b.Enabled := (TRMBandType(i) in [rmbtHeader, rmbtFooter, rmbtMasterData, rmbtDetailData,
      rmbtGroupHeader, rmbtGroupFooter, rmbtChild]) or (not TRMDesignerForm(RMDesigner).RMCheckBand(TRMBandType(i)));
    if IsSubreport and (TRMBandType(i) in
      [rmbtReportTitle, rmbtReportSummary, rmbtPageHeader, rmbtPageFooter,
       rmbtGroupHeader, rmbtGroupFooter, rmbtColumnHeader, rmbtColumnFooter]) then
      b.Enabled := False;

    if b.Enabled and First then
    begin
      b.Checked := True;
      SelectedTyp := TRMBandType(i);
      First := False;
    end;
  end;
end;

procedure TRMBandTypesForm.bClick(Sender: TObject);
begin
  SelectedTyp := TRMBandType((Sender as TComponent).Tag);
end;

procedure TRMBandTypesForm.Localize;
begin
	Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  RMSetStrProp(Self, 'Caption', rmRes + 510);
  RMSetStrProp(grbBands, 'Caption', rmRes + 511);

  btnOK.Caption := RMLoadStr(SOk);
  btnCancel.Caption := RMLoadStr(SCancel);
end;

end.

