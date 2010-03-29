
{*****************************************}
{                                         }
{          Report Machine v2.0            }
{              Format editor              }
{                                         }
{*****************************************}

unit RM_EditorFormat;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, RM_Class;

type
  TRMDisplayFormatForm = class(TRMObjEditorForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lstFolder: TListBox;
    lstType: TListBox;
    edtForamt: TEdit;
    edtDec: TEdit;
    edtSpl: TEdit;
    procedure edtSplEnter(Sender: TObject);
    procedure lstFolderClick(Sender: TObject);
    procedure lstTypeClick(Sender: TObject);
    procedure lstTypeDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FDisplayFormat: TRMFormat;
    FDisplayFormatStr: string;

    procedure ShowPanels;
    procedure Localize;
  public
    { Public declarations }
    function ShowEditor(aView: TRMView): TModalResult; override;

    property DisplayFormat: TRMFormat read FDisplayFormat write FDisplayFormat;
    property DisplayFormatStr: string read FDisplayFormatStr write FDisplayFormatStr;
  end;

implementation

{$R *.DFM}

uses RM_Utils, RM_const, RM_Const1;

const
  CategCount = 5;

type
  THackMemoView = class(TRMCustomMemoView)
  end;

function TRMDisplayFormatForm.ShowEditor(aView: TRMView): TModalResult;
var
  i: Integer;
  t: TRMView;
  liList: TList;
begin
  FDisplayFormat := THackMemoView(aView).FormatFlag;
  FDisplayFormatStr := TRMCustomMemoView(aView).DisplayFormat;
  Result := ShowModal;
  if Result = mrOk then
  begin
    RMDesigner.BeforeChange;
    liList := RMDesigner.PageObjects;
    for i := 0 to liList.Count - 1 do
    begin
      t := liList[i];
      if t.Selected and (t is TRMCustomMemoView) then
      begin
        THackMemoView(t).FDisplayFormat := FDisplayFormatStr;
        THackMemoView(t).FormatFlag := FDisplayFormat;
      end;
    end;
    RMDesigner.AfterChange;
  end;
end;

procedure TRMDisplayFormatForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  RMSetStrProp(Self, 'Caption', rmRes + 420);
  RMSetStrProp(Label1, 'Caption', rmRes + 422);
  RMSetStrProp(Label2, 'Caption', rmRes + 423);
  RMSetStrProp(Label3, 'Caption', rmRes + 424);

  btnOK.Caption := RMLoadStr(SOk);
  btnCancel.Caption := RMLoadStr(SCancel);
end;

{$WARNINGS OFF}

procedure TRMDisplayFormatForm.ShowPanels;
begin
  RMEnableControls([Label1, Label2, edtDec, edtSpl], lstFolder.ItemIndex = 1);
  if edtDec.Enabled then
  begin
    edtDec.Text := IntToStr(FDisplayFormat.FormatPercent);
    edtSpl.Text := FDisplayFormat.FormatdelimiterChar;
  end;

  RMEnableControls([Label3, edtForamt], lstType.ItemIndex = lstType.Items.Count - 1);
  if edtForamt.Enabled then
    edtForamt.Text := FDisplayFormatStr
  else
    edtForamt.Text := '';
end;
{$WARNINGS ON}

procedure TRMDisplayFormatForm.lstFolderClick(Sender: TObject);
var
  i: Integer;
begin
  lstType.Items.Clear;
  case lstFolder.ItemIndex of
    0: // 字符型
      begin
        lstType.Items.Add(RMLoadStr(SFormat11));
      end;
    1: // 数字型
      begin
        for i := 0 to RMFormatNumCount do
          lstType.Items.Add(RMLoadStr(SFormat21 + i));
      end;
    2: // 日期型
      begin
        for i := 0 to RMFormatDateCount do
          lstType.Items.Add(RMLoadStr(SFormat31 + i));
      end;
    3: // 时间型
      begin
        for i := 0 to RMFormatTimeCount do
          lstType.Items.Add(RMLoadStr(SFormat41 + i));
      end;
    4: // 逻辑型
      begin
        for i := 0 to RMFormatBooleanCount do
          lstType.Items.Add(RMLoadStr(SFormat51 + i));
      end;
  end;

  lstType.ItemIndex := 0;
  lstTypeClick(nil);
end;

procedure TRMDisplayFormatForm.lstTypeClick(Sender: TObject);
begin
  ShowPanels;
end;

procedure TRMDisplayFormatForm.edtSplEnter(Sender: TObject);
begin
  edtSpl.SelectAll;
end;

procedure TRMDisplayFormatForm.lstTypeDblClick(Sender: TObject);
begin
  if lstType.ItemIndex >= 0 then
    btnOK.Click;
end;

procedure TRMDisplayFormatForm.FormCreate(Sender: TObject);
begin
  Localize;
end;

procedure TRMDisplayFormatForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    FDisplayFormat.FormatIndex1 := lstFolder.ItemIndex;
    FDisplayFormat.FormatIndex2 := lstType.ItemIndex;
    FDisplayFormat.FormatPercent := StrToIntDef(edtDec.Text, 0);
    if edtSpl.Text <> '' then
      FDisplayFormat.FormatdelimiterChar := edtSpl.Text[1]
    else
      FDisplayFormat.FormatdelimiterChar := '.';

    if edtForamt.Enabled then
      FDisplayFormatStr := edtForamt.Text;
  end;
end;

procedure TRMDisplayFormatForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  lstFolder.Items.Clear;
  for i := 0 to CategCount - 1 do
    lstFolder.Items.Add(RMLoadStr(SCateg1 + i));
  lstFolder.ItemIndex := FDisplayFormat.FormatIndex1;
  if lstFolder.ItemIndex < 0 then lstFolder.ItemIndex := 0;
  lstFolderClick(nil);
  lstType.ItemIndex := FDisplayFormat.FormatIndex2;
  if lstType.ItemIndex < 0 then lstType.ItemIndex := 0;
  lstTypeClick(nil);
end;

end.

