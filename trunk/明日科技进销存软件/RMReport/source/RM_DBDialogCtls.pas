
{******************************************}
{                                          }
{   Report Machine v2.0 - DB components    }
{         Standard Dialog controls         }
{                                          }
{******************************************}

unit RM_DBDialogCtls;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, RM_Class, StdCtrls,
  Controls, Forms, Menus, Dialogs, DB, DBCtrls, RM_DialogCtls
{$IFDEF Delphi6}, Variants{$ENDIF};

type
 { TRMDBLookupComboBoxControl }
  TRMDBLookupComboBoxControl = class(TRMCustomControl)
  private
    FDBLookupComboBox: TDBLookupComboBox;
    FListSource: string;

    function GetKeyField: string;
    procedure SetKeyField(Value: string);
    function GetListField: string;
    procedure SetListField(Value: string);
    function GetListSource: string;
    procedure SetListSource(Value: string);
  protected
    function GetPropValue(aObject: TObject; aPropName: string; var aValue: Variant; Args: array of Variant): Boolean; override;
    function SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(aStream: TStream); override;
    procedure SaveToStream(aStream: TStream); override;
    procedure Loaded; override;
  published
    property KeyField: string read GetKeyField write SetKeyField;
    property ListField: string read GetListField write SetListField;
    property ListSource: string read GetListSource write SetListSource;
  end;

implementation

uses RM_Common, RM_Utils, RM_Const, RMD_DBWrap;

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}
{ TRMDBLookupComboBoxControl }

constructor TRMDBLookupComboBoxControl.Create;
begin
  inherited Create;
  BaseName := 'DBLookupComboBox';

  FDBLookupComboBox := TDBLookupComboBox.Create(nil);
  FDBLookupComboBox.Parent := RMDialogForm;
  AssignControl(FDBLookupComboBox);
  spWidth := 145; spHeight := 21;
end;

destructor TRMDBLookupComboBoxControl.Destroy;
begin
  FDBLookupComboBox.Free;
  inherited Destroy;
end;

function TRMDBLookupComboBoxControl.GetPropValue(aObject: TObject; aPropName: string;
	var aValue: Variant; Args: array of Variant): Boolean;
begin
  Result := True;
  if aPropName = 'KEYVALUE' then
    aValue := FDBLookupComboBox.KeyValue
  else
    Result := inherited GetPropValue(aObject, aPropName, aValue, Args);
end;

function TRMDBLookupComboBoxControl.SetPropValue(aObject: TObject; aPropName: string; aValue: Variant): Boolean;
begin
  Result := True;
  if aPropName = 'DATE' then
    FDBLookupComboBox.KeyValue := aValue
  else
    Result := inherited SetPropValue(aObject, aPropName, aValue);
end;

procedure TRMDBLookupComboBoxControl.LoadFromStream(aStream: TStream);
begin
  inherited LoadFromStream(aStream);
  RMReadWord(aStream);
  FListSource := RMReadString(aStream);
  ListSource := FListSource;
  KeyField := RMReadString(aStream);
  ListField := RMReadString(aStream);
end;

procedure TRMDBLookupComboBoxControl.SaveToStream(aStream: TStream);
begin
  inherited SaveToStream(aStream);
  RMWriteWord(aStream, 0);
  RMWriteString(aStream, ListSource);
  RMWriteString(aStream, KeyField);
  RMWriteString(aStream, ListField);
end;

procedure TRMDBLookupComboBoxControl.Loaded;
begin
  ListSource := FListSource;
  inherited Loaded;
end;

function TRMDBLookupComboBoxControl.GetKeyField: string;
begin
  Result := FDBLookupComboBox.KeyField;
end;

procedure TRMDBLookupComboBoxControl.SetKeyField(Value: string);
begin
  FDBLookupComboBox.KeyField := Value;
end;

function TRMDBLookupComboBoxControl.GetListField: string;
begin
  Result := FDBLookupComboBox.ListField;
end;

procedure TRMDBLookupComboBoxControl.SetListField(Value: string);
begin
  FDBLookupComboBox.ListField := Value;
end;

function TRMDBLookupComboBoxControl.GetListSource: string;
begin
  Result := RMGetDataSetName(RMDialogForm, FDBLookupComboBox.ListSource)
end;

procedure TRMDBLookupComboBoxControl.SetListSource(Value: string);
var
  liComponent: TComponent;
begin
  liComponent := RMFindComponent(RMDialogForm, Value);
  if (liComponent <> nil) and (liComponent is TDataSet) then
    FDBLookupComboBox.ListSource := RMGetDataSource(RMDialogForm, TDataSet(liComponent))
  else
    FDBLookupComboBox.ListSource := nil;
end;

initialization
  RMRegisterControl(TRMDBLookupComboBoxControl, 'RM_DBLOOKUPCONTROL', RMLoadStr(SInsertDBLookup));

finalization

end.

