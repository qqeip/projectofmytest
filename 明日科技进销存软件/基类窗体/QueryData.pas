unit QueryData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, dbcgrids, DBCtrls, DB, ADODB,
  Mask, Buttons;

type
  TFrmQueryData = class(TFrmBase)
    Panel1: TPanel;
    Panel2: TPanel;
    DBCtrlGrid1: TDBCtrlGrid;
    DBText1: TDBText;
    DBCheckBox1: TDBCheckBox;
    ADOQueryData: TADODataSet;
    DSQueryData: TDataSource;
    ADOQueryDataSelect: TBooleanField;
    ADOQueryDataFieldName: TStringField;
    ADOQueryDataFieldValue: TStringField;
    DBEdit1: TDBEdit;
    ADOQueryDataFieldCaption: TStringField;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ADOQueryDataFieldType: TIntegerField;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    FWhereSQL:string;

    procedure InitDataSet(DataSet:TDataSet);
    procedure CreateWhereSQL;
  public
    class function ShowQueryData(const SelectSQL:string;const vDataSet:TDataSet;var ReturnSQL:string):TModalResult;
  end;

var
  FrmQueryData: TFrmQueryData;
  

implementation

{$R *.dfm}

procedure TFrmQueryData.CreateWhereSQL;
var
  i:Integer;
begin

  ADOQueryData.Edit;
  ADOQueryData.Post;
  DSQueryData.DataSet := nil;
  FWhereSQL := '';
  ADOQueryData.First;
  for i:=0 to ADOQueryData.RecordCount -1 do
  begin
    if (ADOQueryData.FieldByName('Select').AsBoolean) and
        (ADOQueryData.FieldByName('FieldValue').AsString <> '') then
    begin
      if FWhereSQL <> '' then
        FWhereSQL := FWhereSQL + ' and ';
      case TFieldType(ADOQueryData.FieldByName('FieldType').AsInteger) of
        ftString:
          FWhereSQL := FWhereSQL + ADOQueryData.FieldByName('FieldName').AsString +
              ' Like ' + QuotedStr('%'+ ADOQueryData.FieldByName('FieldValue').AsString +'%');
        ftSmallint, ftInteger, ftWord,
            ftBoolean, ftFloat, ftCurrency ,ftBCD:
          FWhereSQL := FWhereSQL + ADOQueryData.FieldByName('FieldName').AsString +
              ' = ' + ADOQueryData.FieldByName('FieldValue').AsString;
      end;
    end;
    ADOQueryData.Next;
  end;
  if FWhereSQL <> '' then
    FWhereSQL := ' Where ' + FWhereSQL;
end;

procedure TFrmQueryData.InitDataSet(DataSet: TDataSet);
var
  i:Integer;
begin
  ADOQueryData.Close;
  ADOQueryData.CreateDataSet;
  
  for i:=0 to DataSet.FieldCount -1 do
  begin
    if not DataSet.Fields[i].Visible then
      Continue;
    ADOQueryData.Append;
    ADOQueryData.FieldByName('Select').AsBoolean := False;
    ADOQueryData.FieldByName('FieldCaption').AsString :=
        DataSet.Fields[i].DisplayLabel;
    ADOQueryData.FieldByName('FieldName').AsString :=
        DataSet.Fields[i].DisplayName;
    ADOQueryData.FieldByName('FieldType').AsInteger :=
        Integer(DataSet.Fields[i].DataType);
    ADOQueryData.Post;
  end;
  if not ADOQueryData.IsEmpty then
    ADOQueryData.First;
end;

class function TFrmQueryData.ShowQueryData(const SelectSQL: string;
  const vDataSet: TDataSet; var ReturnSQL: string): TModalResult;
begin
  FrmQueryData := TFrmQueryData.Create(Application);
  FrmQueryData.InitDataSet(vDataSet);
  Result := FrmQueryData.ShowModal;
  if Result = mrOk then
    ReturnSQL := 'Select * From ('+ SelectSQL +') kkll ' + FrmQueryData.FWhereSQL
  else
    ReturnSQL := SelectSQL;
  FrmQueryData.Free;
end;

procedure TFrmQueryData.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  CreateWhereSQL;
  ModalResult := mrOk;
end;

procedure TFrmQueryData.SpeedButton2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TFrmQueryData.SpeedButton3Click(Sender: TObject);
begin
  inherited;
  FWhereSQL := '';
  ModalResult := mrOk;
end;

end.
