
{*****************************************}
{                                         }
{            Report Machine v2.0          }
{               Memo editor               }
{                                         }
{*****************************************}

unit RM_EditorMemo;

interface

{$I RM.inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, RM_Class;

type
  TRMEditorForm = class(TRMObjEditorForm)
    MemoPanel: TPanel;
    Memo: TMemo;
    Panel3: TPanel;
    Bevel1: TBevel;
    Panel1: TPanel;
    btnInsExpr: TSpeedButton;
    btnInsDBField: TSpeedButton;
    BtnWordWrap: TSpeedButton;
    Bevel2: TBevel;
    btnOK: TSpeedButton;
    btnCancel: TSpeedButton;
    btnCut: TSpeedButton;
    btnCopy: TSpeedButton;
    btnPaste: TSpeedButton;
    StatusBar: TStatusBar;
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnInsDBFieldClick(Sender: TObject);
    procedure BtnWordWrapClick(Sender: TObject);
    procedure btnInsExprClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MemoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FView: TRMView;
    FRowStr, FColStr: string;
    procedure Localize;
    procedure ShowStatusbar(Sender: TObject);
  public
    { Public declarations }
    function ShowEditor(View: TRMView): TModalResult; override;
    function Execute: Boolean;
  end;

implementation

{$R *.DFM}

uses
  Registry, RM_Const1, RM_Const, RM_Utils, RM_Common;

procedure TRMEditorForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  RMSetStrProp(Self, 'Caption', rmRes + 060);
  RMSetStrProp(btnInsExpr, 'Hint', rmRes + 061);
  RMSetStrProp(btnInsDBField, 'Hint', rmRes + 062);
  RMSetStrProp(btnCut, 'Hint', rmRes + 091);
  RMSetStrProp(btnCopy, 'Hint', rmRes + 092);
  RMSetStrProp(btnPaste, 'Hint', rmRes + 093);
  RMSetStrProp(BtnWordWrap, 'Hint', rmRes + 063);
  RMSetStrProp(btnInsExpr, 'Caption', rmRes + 701);
  RMSetStrProp(btnInsDBField, 'Caption', rmRes + 65);

  btnOK.Caption := RMLoadStr(SOk);
  btnCancel.Caption := RMLoadStr(SCancel);

  FRowStr := RMLoadStr(rmRes + 578);
  FColStr := RMLoadStr(rmRes + 579);
end;

function TRMEditorForm.Execute: Boolean;
begin
  Result := (ShowModal = mrOk);
end;

function TRMEditorForm.ShowEditor(View: TRMView): TModalResult;
var
  Ini: TRegIniFile;
  Nm: string;
begin
  Ini := TRegIniFile.Create(RMRegRootKey);
  try
    Nm := rsForm + RMDesigner.ClassName;
    FView := View;

    BtnWordWrap.Click;
    Memo.Lines.Assign(FView.Memo);
    Memo.Font.Name := Ini.ReadString(Nm, 'TextFontName', 'Arial');
    Memo.Font.Size := Ini.ReadInteger(Nm, 'TextFontSize', 10);

    Memo.Font.Name := TRMMemoView(FView).Font.Name;
    Memo.Font.Size := 10;
    Memo.Font.Charset := TRMMemoView(View).Font.Charset;
    Memo.ReadOnly := rmrtDontModify in FView.Restrictions;

    Result := ShowModal;
    if Result = mrOk then
    begin
      RMDesigner.BeforeChange;
      Memo.WordWrap := False;
      FView.Memo.Text := Memo.Lines.Text;
    end;
  finally
    Ini.Free;
  end;
end;

const
  VK_A = 65;
  VK_X = 88;
  VK_Y = 89;
  VK_W = 87;
  VK_Q = 81;

procedure TRMEditorForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Insert) and (Shift = []) then
    btnInsDBFieldClick(Self)
  else if (Key = VK_A) and (Shift = [ssCtrl]) then
  begin
    Memo.SelectAll
  end
  else if (Key = vk_X) and (Shift = [ssCtrl]) then
  begin
    Memo.CutToClipboard
  end
  else if (Shift = [ssCtrl]) and ((Key = VK_W) or (Key = VK_RETURN)) then
  begin
    Key := 0;
    btnOk.Click;
  end
  else if (Key = vk_Escape) or ((Key = VK_Q) and (Shift = [ssCtrl])) then
  begin
    Key := 0;
    btnCancel.Click;
  end;
end;

procedure TRMEditorForm.btnInsDBFieldClick(Sender: TObject);
var
  s: string;
begin
  s := RMDesigner.InsertDBField;
  if s <> '' then
    Memo.SelText := s;
  Memo.SetFocus;
end;

procedure TRMEditorForm.BtnWordWrapClick(Sender: TObject);
begin
  Memo.WordWrap := BtnWordWrap.Down;
end;

procedure TRMEditorForm.btnInsExprClick(Sender: TObject);
var
  s: string;
begin
  s := RMDesigner.InsertExpression;
  if s <> '' then
    Memo.SelText := s;
  Memo.SetFocus;
end;

procedure TRMEditorForm.FormCreate(Sender: TObject);
var
  Ini: TRegIniFile;
  Nm: string;
begin
  Localize;

  Ini := TRegIniFile.Create(RMRegRootKey);
  try
    Nm := rsForm + Self.ClassName;
    btnWordWrap.Down := Ini.ReadBool(Nm, 'WordWrap', True);
  finally
    Ini.Free;
  end;
end;

procedure TRMEditorForm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TRMEditorForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TRMEditorForm.btnCutClick(Sender: TObject);
begin
  Memo.CutToClipboard;
end;

procedure TRMEditorForm.btnCopyClick(Sender: TObject);
begin
  Memo.CopyToClipboard;
end;

procedure TRMEditorForm.btnPasteClick(Sender: TObject);
begin
  Memo.PasteFromClipboard;
end;

procedure TRMEditorForm.FormShow(Sender: TObject);
begin
  Memo.SetFocus;
  ShowStatusbar(Memo);
end;

procedure TRMEditorForm.FormDestroy(Sender: TObject);
var
  Ini: TRegIniFile;
  Nm: string;
begin
  Ini := TRegIniFile.Create(RMRegRootKey);
  try
    Nm := rsForm + Self.ClassName;
    Ini.WriteBool(Nm, 'WordWrap', BtnWordWrap.Down);
  finally
    Ini.Free;
  end;
end;

procedure TRMEditorForm.ShowStatusbar(Sender: TObject);
var
  Hang, Lie, Num, CharsLine: longint;
begin
  Num := SendMessage(TMemo(Sender).Handle, EM_LINEFROMCHAR,
    TMemo(Sender).SelStart, 0);
  CharsLine := SendMessage(TMemo(Sender).Handle, EM_LINEINDEX, Num, 0);
  Hang := Num + 1; //当前行
  Lie := (TMemo(Sender).SelStart - CharsLine) + 1; //当前列
  StatusBar.Panels[0].Text := FRowStr + IntToStr(Hang) + FColStr + IntToStr(Lie);
end;

procedure TRMEditorForm.MemoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ShowStatusbar(Memo);
end;

procedure TRMEditorForm.MemoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShowStatusbar(Memo);
end;

end.

