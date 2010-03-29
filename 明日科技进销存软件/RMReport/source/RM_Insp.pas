unit RM_Insp;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Comctrls, RM_Common, RM_DsgCtrls, RM_PropInsp, TypInfo
  {$IFDEF USE_TB2K}
  , TB2Item, TB2Dock, TB2Toolbar
  {$ELSE}
  {$IFDEF USE_INTERNALTB97}
  , RM_TB97Ctls, RM_TB97Tlbr, RM_TB97
  {$ELSE}
  , TB97Ctls, TB97Tlbr, TB97
  {$ENDIF}
  {$ENDIF}
  {$IFDEF Delphi6}, Variants{$ENDIF};

const
  RMCompletionStr: array[0..21] of string = (
    'arrayd * array declaration (var) *array[0..|] of ;',
    'arrayc * array declaration (const) *array[0..|] of = ()',
    'ifeb * if then else *if | then/nbegin/n/nend/nelse/nbegin/n/nend;',
    'ife * if then (no begin/end) else (no begin/end) *if | then/n/nelse',
    'ifb * if statement *if | then/nbegin/n/nend;',
    'ifs * if (no begin/end) *if | then',
    'casee * case statement (with else) *case | of /n  : ;/n  : ;/nelse/n  ;/nend;',
    'cases * case statement *case | of/n  : ;/n  : ;/nend;',
    'forb * for statement *for | :=  to  do/nbegin/n/nend;',
    'fors * for (no begin/end) *for | :=  to  do',
    'whiles * while (no begin) *while | do',
    'whileb * while statement *while | do/nbegin/n/nend;',
    'procedure * procedure declaration *procedure |();/nbegin/n/nend;',
    'function * function declaration *function |(): ;/nbegin/n/nend;',
    'withs * with (no begin) *with | do',
    'withb * with statement *with | do/nbegin/n/nend;',
    'trycf * try finally (with Create/Free) *variable := typename.Create;/ntry/n/nfinally/n  variable.Free;/nend;',
    'tryf * try finally *try/n  |/nfinally/n/nend;',
    'trye * try except *try/n  |/nexcept/n/nend;',
    'classc * class declaration (with Create/Destroy overrides) *T| = class(T)/nprivate/n/nprotected/n/npublic/n  constructor Create; override;/n  destructor Destroy; override;/npublished/n/nend;',
    'classd * class declaration (no parts) *T| = class(T)/n/nend;',
    'classf * class declaration (all parts) *T| = class(T)/nprivate/n/nprotected/n/npublic/n/npublished/n/nend;'
    );
type

  TGetObjectsEvent = procedure(List: TStrings) of object;
  TSelectionChangedEvent = procedure(ObjName: string) of object;

  { TRMInspForm }
  TRMInspForm = class(TRMToolWin)
  private
    FTab: TTabControl;
    FcmbObjects: TComboBox;
    FInsp: TELPropertyInspector;
    FPanelTop: TPanel;
    FSplitter1: TSplitter;
    FPanelBottom, FPanel2: TPanel;
    FLabelTitle, FLabelCommon: TLabel;

    FCurObjectClassName: string;
    FSaveHeight: Integer;

    FOnGetObjects: TGetObjectsEvent;
    FOnSelectionChanged: TSelectionChangedEvent;

    function GetSplitterPos: Integer;
    procedure SetSplitterPos(Value: Integer);
    function GetSplitterPos1: Integer;
    procedure SetSplitterPos1(Value: Integer);
    procedure Localize;
    procedure OnResizeEvent(Sender: TObject);
    procedure OnVisibleChangedEvent(Sender: TObject);
    procedure OnTabChangeEvent(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure Insp_OnClick(Sender: TObject);
    procedure OnGetEditorClassEvent(Sender: TObject;
      AInstance: TPersistent; APropInfo: PPropInfo; var AEditorClass: TELPropEditorClass);

    procedure cmbObjectsDropDown(Sender: TObject);
    procedure cmbObjectsClick(Sender: TObject);
    procedure cmbObjectsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);

    procedure WMLButtonDBLCLK(var Message: TWMNCLButtonDown); message WM_LBUTTONDBLCLK;
    procedure WMRButtonDBLCLK(var Message: TWMNCRButtonDown); message WM_RBUTTONDBLCLK;
    procedure OnMoveEvent(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure AddObject(aObject: TPersistent);
    procedure ClearObjects;
    procedure SetCurrentObject(aClassName, s: string);
    procedure SetCurReport(aObject: TObject);
    procedure RestorePos;

    property Insp: TELPropertyInspector read FInsp;
    property Tab: TTabControl read FTab;
    property SplitterPos: Integer read GetSplitterPos write SetSplitterPos;
    property SplitterPos1: Integer read GetSplitterPos1 write SetSplitterPos1;
    property OnGetObjects: TGetObjectsEvent read FOnGetObjects write FOnGetObjects;
    property OnSelectionChanged: TSelectionChangedEvent read FOnSelectionChanged write FOnSelectionChanged;
    property cmbObjects: TComboBox read FcmbObjects;
  end;

procedure RMRegisterPropEditor(ATypeInfo: PTypeInfo; AObjectClass: TClass;
  const APropName: string; AEditorClass: TELPropEditorClass);

implementation

uses RM_Class, RM_Const, RM_Const1, RM_Utils, RM_EditorMemo,
  RM_EditorBand, RM_EditorCrossBand, RM_EditorGroup, RM_EditorCalc, RM_EditorHilit,
  RM_EditorPicture, RM_EditorFormat, RM_EditorExpr;

var
  FCurReport: TRMReport;
  FAddinPropEditors: TList;

type
  TRMAddinPropEditor = class
  private
  public
    TypeInfo: PTypeInfo;
    ObjectClass: TClass;
    PropName: string;
    EditorClass: TELPropEditorClass;
    constructor Create(ATypeInfo: PTypeInfo; AObjectClass: TClass;
      const APropName: string; AEditorClass: TELPropEditorClass);
  end;

constructor TRMAddinPropEditor.Create(ATypeInfo: PTypeInfo; AObjectClass: TClass;
  const APropName: string; AEditorClass: TELPropEditorClass);
begin
  inherited Create;
  TypeInfo := aTypeInfo;
  ObjectClass := aObjectClass;
  PropName := aPropName;
  EditorClass := aEditorClass;
end;

function RMAddinPropEditors: TList;
begin
  if FAddinPropEditors = nil then
    FAddinPropEditors := TList.Create;
  Result := FAddinPropEditors;
end;

procedure RMRegisterPropEditor(ATypeInfo: PTypeInfo; AObjectClass: TClass;
  const APropName: string; AEditorClass: TELPropEditorClass);
var
  liItem: TRMAddinPropEditor;
begin
  liItem := TRMAddinPropEditor.Create(aTypeInfo, aObjectClass, aPropName, aEditorClass);
  RMAddinPropEditors.Add(liItem);
end;

type
  THackView = class(TRMView)
  end;

  THackReportView = class(TRMReportView)
  end;

  THackPage = class(TRMCustomPage)
  end;

  TStringsPropEditor = class(TELClassPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TChildBandEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure GetValues(AValues: TStrings); override;
  end;

  TGroupHeaderBandEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure GetValues(AValues: TStrings); override;
  end;

  TGroupFooterBandEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure GetValues(AValues: TStrings); override;
  end;

  TResetGroupNameEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure GetValues(AValues: TStrings); override;
  end;

  TDataSetEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TCrossDataBandDataSourceEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TGroupConditionEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TExpressionEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TCalcOptionsEditor = class(TELClassPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  THighlightEditor = class(TELClassPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TShiftWithEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure GetValues(AValues: TStrings); override;
  end;

  TMasterMemoViewEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure GetValues(AValues: TStrings); override;
  end;

  TPictureView_PictureEditor = class(TELClassPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TPageBackPictureEditor = class(TELClassPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TDataFieldEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TDisplayFormatEditor = class(TELStringPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TMethodEditor = class(TELClassPropEditor)
  private
    procedure GetFuncParams(aParams: PRMParamRecArray; var aParamCount: Integer);
  protected
    function AllEqual: Boolean; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    function GetAttrs: TELPropAttrs; override;
    procedure GetValues(AValues: TStrings); override;
    procedure Edit; override;
  end;

  TPicturePropEditor = class(TELClassPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  TBitmapPropEditor = class(TELClassPropEditor)
  protected
    function GetAttrs: TELPropAttrs; override;
    procedure Edit; override;
  end;

  {------------------------------------------------------------------------------}
  {------------------------------------------------------------------------------}
  { TStringsPropEditor }

function TStringsPropEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praDialog, praReadOnly];
end;

procedure TStringsPropEditor.Edit;
var
  tmp: TRMEditorForm;
begin
  tmp := TRMEditorForm(RMDesigner.EditorForm);
  tmp.Memo.Lines.Assign(TStrings(GetOrdValue(0)));
  if tmp.Execute then
    SetOrdValue(Longint(tmp.Memo.Lines));
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TChildBandEditor }

function TChildBandEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praValueList, praSortList];
end;

procedure TChildBandEditor.GetValues(AValues: TStrings);
var
  i: Integer;
  t: TRMView;
  lList: TList;
begin
  lList := RMDesigner.PageObjects;
  for i := 0 to lList.Count - 1 do
  begin
    t := lList[i];
    if (t.IsBand) and (GetInstance(0) <> t) and
      (TRMCustomBandView(t).BandType in [rmbtChild]) then
      aValues.Add(t.Name);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TGroupHeaderBandEditor }

function TGroupHeaderBandEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praValueList, praSortList];
end;

procedure TGroupHeaderBandEditor.GetValues(AValues: TStrings);
var
  i: Integer;
  t: TRMView;
  lList: TList;
begin
  lList := RMDesigner.PageObjects;
  for i := 0 to lList.Count - 1 do
  begin
    t := lList[i];
    if (t.IsBand) and (GetInstance(0) <> t) and
      (TRMCustomBandView(t).BandType in [rmbtMasterData, rmbtDetailData]) then
      aValues.Add(t.Name);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TGroupFooterBandEditor }

function TGroupFooterBandEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praValueList, praSortList];
end;

procedure TGroupFooterBandEditor.GetValues(AValues: TStrings);
var
  i: Integer;
  t: TRMView;
  lList: TList;
begin
  lList := RMDesigner.PageObjects;
  for i := 0 to lList.Count - 1 do
  begin
    t := lList[i];
    if (t.IsBand) and (GetInstance(0) <> t) and
      (TRMCustomBandView(t).BandType in [rmbtGroupHeader]) then
      aValues.Add(t.Name);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TResetGroupNameEditor }

function TResetGroupNameEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praValueList, praSortList];
end;

procedure TResetGroupNameEditor.GetValues(AValues: TStrings);
var
  i: Integer;
  t: TRMView;
  lList: TList;
begin
  lList := RMDesigner.PageObjects;
  for i := 0 to lList.Count - 1 do
  begin
    t := lList[i];
    if t.IsBand and (GetInstance(0) <> t) and
      (TRMCustomBandView(t).BandType in [rmbtGroupHeader]) then
      aValues.Add(t.Name);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TDataSetEditor }

function TDataSetEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praDialog];
end;

procedure TDataSetEditor.Edit;
var
  tmp: TRMBandEditorForm;
begin
  tmp := TRMBandEditorForm.Create(nil);
  try
    if tmp.ShowEditor(TRMView(GetInstance(0))) = mrOK then
      SetStrValue(TRMBandMasterData(GetInstance(0)).DataSetName);
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TCrossDataBandDataSourceEditor }

function TCrossDataBandDataSourceEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praDialog, praReadOnly];
end;

procedure TCrossDataBandDataSourceEditor.Edit;
var
  tmp: TRMVBandEditorForm;
begin
  tmp := TRMVBandEditorForm.Create(nil);
  try
    tmp.ShowEditor(TRMView(GetInstance(0)));
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TGroupConditionEditor }

function TGroupConditionEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praDialog];
end;

procedure TGroupConditionEditor.Edit;
var
  tmp: TRMGroupEditorForm;
begin
  tmp := TRMGroupEditorForm.Create(nil);
  try
    tmp.ShowEditor(TRMView(GetInstance(0)));
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TExpressionEditor }

function TExpressionEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praDialog];
end;

procedure TExpressionEditor.Edit;
var
  lStr: string;
begin
  lStr := GetStrValue(0);
  if RM_EditorExpr.RMGetExpression('', lStr, nil, False) then
  begin
    if lStr <> '' then
    begin
      if not ((lStr[1] = '[') and (lStr[Length(lStr)] = ']') and
        (Pos('[', Copy(lStr, 2, 999999)) = 0)) then
        lStr := '[' + lStr + ']';
    end;

    SetStrValue(lStr);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TCalcOptionsEditor }

function TCalcOptionsEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praSubProperties, praDialog, praReadOnly];
end;

procedure TCalcOptionsEditor.Edit;
var
  tmp: TRMCalcMemoEditorForm;
begin
  tmp := TRMCalcMemoEditorForm.Create(nil);
  try
    tmp.ShowEditor(TRMView(GetInstance(0)));
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ THighlightEditor }

function THighlightEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praSubProperties, praDialog, praReadOnly];
end;

procedure THighlightEditor.Edit;
var
  tmp: TRMHilightForm;
begin
  tmp := TRMHilightForm.Create(nil);
  try
    tmp.ShowEditor(TRMView(GetInstance(0)));
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TShiftWithEditor }

function TShiftWithEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praValueList, praSortList];
end;

procedure TShiftWithEditor.GetValues(AValues: TStrings);
var
  i, j: Integer;
  t: TRMView;
  liParentBand: TRMView;
  lList: TList;
begin
  lList := RMDesigner.PageObjects;
  t := TRMView(GetInstance(0));
  for i := 0 to lList.Count - 1 do
  begin
    liParentBand := lList[i];
    if (t.spTop >= liParentBand.spTop) and (t.spBottom <= liParentBand.spBottom) then
    begin
      for j := 0 to lList.Count - 1 do
      begin
        t := lList[j];
        if THackView(t).Stretched and (t is TRMStretcheableView) and (GetInstance(0) <> t) and
          (t.spTop >= liParentBand.spTop) and (t.spBottom <= liParentBand.spBottom) then
          aValues.Add(t.Name);
      end;
      Break;
    end;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TMasterMemoViewEditor }

function TMasterMemoViewEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praValueList, praSortList];
end;

procedure TMasterMemoViewEditor.GetValues(AValues: TStrings);
var
  i: Integer;
  t: TRMView;
  lList: TList;
begin
  lList := RMDesigner.PageObjects;
  for i := 0 to lList.Count - 1 do
  begin
    t := lList[i];
    if (t is TRMCustomMemoView) and (GetInstance(0) <> t) then
      aValues.Add(t.Name);
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TPictureView_PictureEditor }

function TPictureView_PictureEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praSubProperties, praDialog, praReadOnly];
end;

procedure TPictureView_PictureEditor.Edit;
var
  tmp: TRMPictureEditorForm;
begin
  tmp := TRMPictureEditorForm.Create(nil);
  try
    tmp.ShowEditor(TRMView(GetInstance(0)));
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TPageBackPictureEditor }

function TPageBackPictureEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praSubProperties, praDialog, praReadOnly];
end;

procedure TPageBackPictureEditor.Edit;
var
  tmp: TRMPictureEditorForm;
begin
  tmp := TRMPictureEditorForm.Create(nil);
  try
    tmp.ShowbkPicture(TRMReportPage(GetInstance(0)));
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TDataFieldEditor }

function TDataFieldEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praDialog];
end;

procedure TDataFieldEditor.Edit;
var
  liStr: string;
begin
  liStr := RMDesigner.InsertDBField;
  if liStr <> '' then
    SetStrValue(liStr);
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TDisplayFormatEditor }

type
  THackMemoView = class(TRMCustomMemoView)
  end;

function TDisplayFormatEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praDialog, praMultiSelect];
end;

procedure TDisplayFormatEditor.Edit;
var
  t: TRMView;
  tmp: TRMDisplayFormatForm;
begin
  t := TRMView(GetInstance(0));
  if not (t is TRMCustomMemoView) then Exit;

  tmp := TRMDisplayFormatForm.Create(nil);
  try
    tmp.ShowEditor(t);
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TMethodEditor }

type
  PParamRecord = ^TParamRecord;
  TParamRecord = record
    Flags: TParamFlags;
    ParamName: ShortString;
    TypeName: ShortString;
  end;

procedure TMethodEditor.GetFuncParams(aParams: PRMParamRecArray; var aParamCount: Integer);
var
  i: Integer;
  lTypeData: PTypeData;
  lParamRecord: PParamRecord;
  lTypeStr: PShortString;
begin
  aParamCount := 0;
  lTypeData := TypInfo.GetTypeData(PropTypeInfo);
  lParamRecord := @lTypeData.ParamList;
	for i := 1 to lTypeData.ParamCount do
  begin
    lTypeStr := Pointer(Integer(@lParamRecord.ParamName) +
      Length(lParamRecord.ParamName) + 1);
    aParams[aParamCount].IsVar := pfVar in lParamRecord.Flags;
    aParams[aParamCount].IsConst := pfConst in lParamRecord.Flags;
    aParams[aParamCount].IsArray := pfArray in lParamRecord.Flags;
    aParams[aParamCount].ClassType := lTypeStr^;
    aParams[aParamCount].Name := lParamRecord.ParamName;
    Inc(aParamCount);

    lParamRecord := PParamRecord(Integer(lParamRecord) + SizeOf(TParamFlags) +
      (Length(lParamRecord^.ParamName) + 1) + (Length(lTypeStr^) + 1));
  end;
end;

function TMethodEditor.AllEqual: Boolean;
begin
  Result := False;
  if PropCount > 1 then
  begin
    Exit;
  end;
  Result := True;
end;

function TMethodEditor.GetValue: string;
var
  lValue: Variant;
begin
  lValue := TRMPersistent(GetInstance(0)).PropVars[PropName];
  if lValue <> Null then
    Result := lValue
  else
    Result := '';
end;

procedure TMethodEditor.SetValue(const Value: string);
begin
  TRMPersistent(GetInstance(0)).PropVars[PropName] := Value;
end;

function TMethodEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praValueList, praSortList, praMethodProp];
end;

procedure TMethodEditor.GetValues(AValues: TStrings);
var
  lParamCount: Integer;
  lParams: TRMParamRecArray;
begin
  aValues.Clear;

  GetFuncParams(@lParams, lParamCount);
  RMDesigner.GetEventFunctions(aValues, @lParams, lParamCount);
end;

procedure TMethodEditor.Edit;
var
  lFuncName, lNewFuncName: string;
  lParamCount: Integer;
  lParams: TRMParamRecArray;
begin
  lFuncName := GetValue;
  lNewFuncName := lFuncName;
  if lNewFuncName = '' then
    lNewFuncName := TRMPersistent(GetInstance(0)).Name + PropName;

  GetFuncParams(@lParams, lParamCount);
  RMDesigner.EditMethod(lNewFuncName, @lParams, lParamCount);
  if lNewFuncName <> lFuncName then
  begin
    SetValue(lNewFuncName);
    Modified;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TPicturePropEditor }

function TPicturePropEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praDialog, praReadOnly];
end;

procedure TPicturePropEditor.Edit;
var
  tmp: TRMPictureEditorForm;
begin
  tmp := TRMPictureEditorForm.Create(nil);
  try
    tmp.Picture := TPicture(GetOrdValue(0));
    if tmp.ShowModal = mrOK then
      SetOrdValue(Longint(tmp.Picture));
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TBitmapPropEditor }

function TBitmapPropEditor.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praDialog, praReadOnly];
end;

procedure TBitmapPropEditor.Edit;
var
  tmp: TRMPictureEditorForm;
begin
  tmp := TRMPictureEditorForm.Create(nil);
  try
    tmp.PictureTypes := ' (*.bmp)|*.bmp';
    tmp.Picture.Assign(TBitmap(GetOrdValue(0)));
    if tmp.ShowModal = mrOK then
      SetOrdValue(Longint(tmp.Picture.Bitmap));
  finally
    tmp.Free;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMInspForm }

procedure TRMInspForm.OnGetEditorClassEvent(Sender: TObject;
  AInstance: TPersistent; APropInfo: PPropInfo; var AEditorClass: TELPropEditorClass);
begin
  aEditorClass := nil;
  if aPropInfo.PropType^.Kind = tkMethod then
  begin
    aEditorClass := TMethodEditor;
  end;
end;

constructor TRMInspForm.Create(AOwner: TComponent);

  procedure _RegisterPropEditor;
  var
    i: Integer;
    liItem: TRMAddinPropEditor;
  begin
    FInsp.RegisterPropEditor(TypeInfo(TStrings), nil, 'Memo', TStringsPropEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBand, 'ChildBand', TChildBandEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBandHeader, 'DataBandName', TGroupHeaderBandEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBandFooter, 'DataBandName', TGroupHeaderBandEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBandGroupHeader, 'MasterBandName', TGroupHeaderBandEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBandGroupFooter, 'GroupHeaderBandName', TGroupFooterBandEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBandDetailData, 'MasterBandName', TGroupHeaderBandEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMCustomBandView, 'DataSetName', TDataSetEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBandCrossData, 'DataSource', TCrossDataBandDataSourceEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBandGroupHeader, 'GroupCondition', TGroupConditionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMCalcMemoView, 'ResultExpression', TExpressionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBand, 'PrintCondition', TExpressionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBand, 'NewPageCondition', TExpressionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMBand, 'OutlineText', TExpressionEditor);

    FInsp.RegisterPropEditor(TypeInfo(TRMHighlight), TRMCustomMemoView, 'Highlight', THighlightEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMHighlight, 'Condition', TExpressionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMReportView, 'ShiftWith', TShiftWithEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMReportView, 'StretchWith', TShiftWithEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMReportView, 'ShiftRelativeTo', TShiftWithEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMReportView, 'DataField', TDataFieldEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMRepeatedOptions, 'MasterMemoView', TMasterMemoViewEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), nil, 'DisplayFormat', TDisplayFormatEditor);

    FInsp.RegisterPropEditor(TypeInfo(TRMCalcOptions), TRMCalcMemoView, 'CalcOptions', TCalcOptionsEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMCalcOptions, 'Filter', TExpressionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMCalcOptions, 'IntalizeValue', TExpressionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMCalcOptions, 'AggregateValue', TExpressionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMCalcOptions, 'AggrBandName', TExpressionEditor);
    FInsp.RegisterPropEditor(TypeInfo(string), TRMCalcOptions, 'ResetGroupName', TExpressionEditor);

    FInsp.RegisterPropEditor(TypeInfo(TPicture), TRMPictureView, 'Picture', TPictureView_PictureEditor);
    FInsp.RegisterPropEditor(TypeInfo(TPicture), TRMReportPage, 'BackPicture', TPageBackPictureEditor);
    FInsp.RegisterPropEditor(TypeInfo(TPicture), nil, 'Picture', TPicturePropEditor);
    FInsp.RegisterPropEditor(TypeInfo(TBitmap), nil, '', TBitmappropEditor);

    if FAddinPropEditors <> nil then
    begin
      for i := 0 to FAddinPropEditors.Count - 1 do
      begin
        liItem := FAddinPropEditors[i];
        with liItem do
          FInsp.RegisterPropEditor(TypeInfo, ObjectClass, PropName, EditorClass);
      end;
    end;
  end;

begin
  inherited Create(AOwner);

  FPanelTop := TPanel.Create(Self);
  FPanelTop.Parent := Self;
  FPanelTop.Align := alTop;
  FPanelTop.Height := 26;
  FPanelTop.BevelOuter := bvNone;

  FcmbObjects := TComboBox.Create(Self);
  with FcmbObjects do
  begin
    Parent := FPanelTop;
    SetBounds(0, 2, 21, 169);
    Style := csOwnerDrawFixed;
    DropDownCount := 12;
    ItemHeight := 15;
    Sorted := True;
    OnClick := cmbObjectsClick;
    OnDrawItem := cmbObjectsDrawItem;
    OnDropDown := cmbObjectsDropDown;
  end;

  FTab := TTabControl.Create(Self);
  with FTab do
  begin
    Parent := Self;
    HotTrack := True;
    Align := alClient;
    OnChange := OnTabChangeEvent;
  end;

  FInsp := TELPropertyInspector.Create(Self);
  with FInsp do
  begin
    Parent := FTab;
    Align := alClient;
    OnClick := Insp_OnClick;
    OnGetEditorClass := OnGetEditorClassEvent;
  end;
  _RegisterPropEditor;

  FSplitter1 := TSplitter.Create(Self);
  with FSplitter1 do
  begin
    Parent := Self;
    Align := alBottom;
    Cursor := crVSplit;
  end;

  FPanelBottom := TPanel.Create(Self);
  with FPanelBottom do
  begin
    Parent := Self;
    Align := alBottom;
    Height := 54;
    BevelOuter := bvNone;
    BorderWidth := 2;
  end;
  FPanel2 := TPanel.Create(Self);
  with FPanel2 do
  begin
    Parent := FPanelBottom;
    SetBounds(2, 2, 172, 50);
    Align := alClient;
    BevelOuter := bvLowered;
    OnResize := Panel2Resize;
  end;
  FLabelTitle := TLabel.Create(Self);
  with FLabelTitle do
  begin
    Parent := FPanel2;
    SetBounds(6, 1, 155, 13);
    AutoSize := False;
  end;
  FLabelCommon := TLabel.Create(Self);
  with FLabelCommon do
  begin
    Parent := FPanel2;
    SetBounds(12, 17, 154, 28);
    AutoSize := False;
    Color := clBtnFace;
    WordWrap := True;
  end;

  {$IFDEF USE_TB2k}
  Parent := TWinControl(AOwner);
  Floating := True;
  {$ENDIF}
  FullSize := False;
  CloseButtonWhenDocked := True;
  UseLastDock := False;

  SetBounds(438, 179, 184, 308);
  FSaveHeight := ClientHeight;
  OnResize := OnResizeEvent;
  OnVisibleChanged := OnVisibleChangedEvent;
  OnMove := OnMoveEvent;

  OnResizeEvent(nil);
  Localize;
end;

destructor TRMInspForm.Destroy;
begin
  inherited Destroy;
end;

procedure TRMInspForm.SetCurReport(aObject: TObject);
begin
  FCurReport := TRMReport(aObject);
end;

procedure TRMInspForm.Localize;
begin
  Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  FInsp.Font.Assign(Font);

  RMSetStrProp(Self, 'Caption', rmRes + 70);
  Tab.Tabs.Add(RMLoadStr(rmRes + 71));
  Tab.Tabs.Add(RMLoadStr(rmRes + 72));

  FLabelCommon.Font.Color := clBlue;
end;

procedure TRMInspForm.BeginUpdate;
begin
  FInsp.BeginUpdate;
end;

procedure TRMInspForm.EndUpdate;
begin
  FInsp.EndUpdate;
  Insp_OnClick(nil);
end;

procedure TRMInspForm.AddObject(aObject: TPersistent);
begin
  FInsp.Add(aObject);
end;

procedure TRMInspForm.ClearObjects;
begin
  FInsp.Clear;
end;

procedure TRMInspForm.SetCurrentObject(aClassName, s: string);
begin
  if (FcmbObjects.ItemIndex < 0) or (FcmbObjects.Items[FcmbObjects.ItemIndex] <> s) then
  begin
    FCurObjectClassName := aClassName;
    cmbObjectsDropDown(nil);
    FcmbObjects.ItemIndex := FcmbObjects.Items.IndexOf(s);
  end;
end;

procedure TRMInspForm.cmbObjectsDropDown(Sender: TObject);
var
  s: string;
begin
  if FcmbObjects.ItemIndex <> -1 then
    s := FcmbObjects.Items[FcmbObjects.ItemIndex]
  else
    s := '';
  if Assigned(FOnGetObjects) then
    FOnGetObjects(FcmbObjects.Items);
  FcmbObjects.ItemIndex := FcmbObjects.Items.IndexOf(s);
end;

procedure TRMInspForm.cmbObjectsClick(Sender: TObject);
begin
  if Assigned(FOnSelectionChanged) then
    FOnSelectionChanged(FcmbObjects.Items[FcmbObjects.ItemIndex]);
end;

procedure TRMInspForm.cmbObjectsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with FcmbObjects.Canvas do
  begin
    FillRect(Rect);
    if FcmbObjects.DroppedDown then
      TextOut(Rect.Left + 2, Rect.Top + 1, FcmbObjects.Items[Index])
    else
      TextOut(Rect.Left + 2, Rect.Top + 1, FcmbObjects.Items[Index] + ': ' + FCurObjectClassName);
  end;
end;

procedure TRMInspForm.OnResizeEvent(Sender: TObject);
begin
  FSaveHeight := ClientHeight;
  FcmbObjects.Width := ClientWidth;
end;

procedure TRMInspForm.OnVisibleChangedEvent(Sender: TObject);
begin
end;

function TRMInspForm.GetSplitterPos: Integer;
begin
  Result := FInsp.Splitter;
end;

procedure TRMInspForm.SetSplitterPos(Value: Integer);
begin
  if (Value > 10) and (Value < FInsp.ClientWidth - 10) then
  begin
    FInsp.Splitter := Value;
  end;
end;

function TRMInspForm.GetSplitterPos1: Integer;
begin
  Result := FInsp.Height;
end;

procedure TRMInspForm.SetSplitterPos1(Value: Integer);
begin
  FInsp.Height := Value;
end;

procedure TRMInspForm.OnTabChangeEvent(Sender: TObject);
begin
  BeginUpdate;
  if FTab.TabIndex = 0 then
    FInsp.PropKinds := [pkProperties]
  else
    FInsp.PropKinds := [pkEvents];
  EndUpdate;
end;

procedure TRMInspForm.WMLButtonDBLCLK(var Message: TWMNCLButtonDown);
var
  liSaveHeight: Integer;
begin
  FInsp.ClosePopup;
  if ClientHeight > 0 then
  begin
    liSaveHeight := ClientHeight;
    ClientHeight := 0;
    FSaveHeight := liSaveHeight;
  end
  else
    ClientHeight := FSaveHeight;
end;

procedure TRMInspForm.RestorePos;
begin
  if ClientHeight > 0 then
  begin
  end
  else
    ClientHeight := FSaveHeight;
end;

procedure TRMInspForm.WMRButtonDBLCLK(var Message: TWMNCRButtonDown);
var
  liSaveHeight: Integer;
begin
  FInsp.ClosePopup;
  if ClientHeight > 0 then
  begin
    liSaveHeight := ClientHeight;
    ClientHeight := 0;
    FSaveHeight := liSaveHeight;
  end
  else
    ClientHeight := FSaveHeight;
end;

procedure TRMInspForm.OnMoveEvent(Sender: TObject);
begin
  FInsp.ClosePopup;
end;

procedure TRMInspForm.Panel2Resize(Sender: TObject);
begin
  FLabelTitle.Width := FPanel2.ClientWidth - FLabelTitle.Left - 2;
  FLabelCommon.Width := FPanel2.ClientWidth - FLabelCommon.Left - 2;
  FLabelCommon.Height := FPanel2.ClientHeight - FLabelCommon.Top - 2;
end;

procedure TRMInspForm.Insp_OnClick(Sender: TObject);
var
  lActiveItem: TELPropsPageItem;
begin
  lActiveItem := FInsp.ActiveItem;
  if lActiveItem = nil then
  begin
    FLabelTitle.Caption := '';
    FLabelCommon.Caption := '';
  end
  else
  begin
    if RMLocalizedPropertyNames then
      FLabelTitle.Caption := lActiveItem.VirtualCaption
    else
      FLabelTitle.Caption := lActiveItem.Caption;
    FLabelCommon.Caption := lActiveItem.PropCommon;
  end;
end;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

procedure ClearPropeditors;
var
  i: Integer;
begin
  if FAddinPropEditors <> nil then
  begin
    for i := 0 to FAddinPropEditors.Count - 1 do
    begin
      TRMAddinPropEditor(FAddinPropEditors[i]).Free;
    end;
    FAddinPropEditors.Clear;
  end;
end;

initialization

finalization
  if FAddinPropEditors <> nil then
  begin
    ClearPropeditors;
    FAddinPropEditors.Free;
    FAddinPropEditors := nil;
  end;

end.

