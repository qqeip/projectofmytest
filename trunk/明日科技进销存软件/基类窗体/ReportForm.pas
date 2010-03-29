unit ReportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RM_Common, RM_Class, RM_GridReport, RM_DsgGridReport,Contnrs,
  DB, ADODB, RM_Dataset,ReportToolManage,RM_Parser,ActiveX;

type

  TFrmReport = class(TAbsReportTool)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    RMGridReport1: TRMGridReport;
    RMGridReportDesigner1: TRMGridReportDesigner;
    FDataSetList:TObjectList;
    FSaveToDataBase:Boolean;
    FOnSaveReport:TSaveReportEvent;
    FReportType:Integer;

    function CreateRMDataSet(vDataSet:TADODataSet):TRMDBDataSet;
    procedure RMGridReportSave(Report: TRMReport;
      var ReportName: String; SaveAs: Boolean; var Saved: Boolean);
  public
  
    procedure SetSaveToDataBase(value:Boolean);override;
    function GetSaveToDataBase:Boolean;override;

    procedure SetOnSaveReport(value:TSaveReportEvent);override;
    procedure SetReportType(value:Integer);override;
    function GetReportType:Integer;override;

    procedure OpenDesgin;override;
    procedure AddDataSet(vDataSet:TADODataSet);override;
    procedure AddDirectory(DirectoryName:string);override;
    procedure AddVariable(DirectoryName:string;VariableName:string;VariableValue:string = '');override;
    procedure SetVarible(VaribleName:string; Value:Variant);override;
    procedure LoadFromFile(FileName:string);override;
    procedure LoadFromStream(Stream:TStream);override;
    procedure SaveToStream(Stream:TStream);override;
    procedure Preview;override;
    procedure Print;override;

  end;

var
  FrmReport: TFrmReport;


function GetReportTool:TAbsReportTool;stdcall;

exports GetReportTool;

implementation

{$R *.dfm}

function GetReportTool:TAbsReportTool;
begin
  Result := TFrmReport.Create(nil);
end;

{ TFrmReport }

procedure TFrmReport.AddDataSet(vDataSet: TADODataSet);
begin
  CreateRMDataSet(vDataSet);
end;

function TFrmReport.CreateRMDataSet(vDataSet: TADODataSet): TRMDBDataSet;
var
  RMDataSet:TRMDBDataSet;
begin
  RMDataSet := TRMDBDataSet.Create(Self);
  FDataSetList.Add(RMDataSet);
  RMDataSet.DataSet := vDataSet;
  RMDataSet.Name := 'RM'+ vDataSet.Name;
  Result := RMDataSet;
end;

procedure TFrmReport.OpenDesgin;
begin
  RMGridReport1.DesignReport;
end;

procedure TFrmReport.FormCreate(Sender: TObject);
begin
  FDataSetList := TObjectList.Create;
  RMGridReport1 := TRMGridReport.Create(Self);
  RMGridReportDesigner1 := TRMGridReportDesigner.Create(Self);
end;

procedure TFrmReport.AddDirectory(DirectoryName: string);
  function FindDictionary:Boolean;
  var
    i:Integer;
  begin
    Result := False;
    for i:=0 to RMGridReport1.Dictionary.Variables.Count -1 do
    begin
      if RMGridReport1.Dictionary.Variables.IndexOf(' '+ DirectoryName) <> -1 then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
  procedure CreateDictionary;
  begin
    RMGridReport1.Dictionary.Variables.Insert(RMGridReport1.Dictionary.Variables.Count,' '+ DirectoryName);
  end;
begin
  if not FindDictionary then
    CreateDictionary;  
end;

procedure TFrmReport.AddVariable(DirectoryName, VariableName: string;VariableValue:string = '');
  function FindVariable:Integer;
  var
    i:Integer;
  begin
    Result := -1;
    for i:=0 to RMGridReport1.Dictionary.Variables.Count -1 do
    begin
      if RMGridReport1.Dictionary.Variables.IndexOf(VariableName) <> -1 then
      begin
        Result := i+1;
        Break;
      end;
    end;
  end;
  function FindDictionary:Integer;
  begin
    Result := RMGridReport1.Dictionary.Variables.IndexOf(' '+ DirectoryName);
  end;
  procedure CreateVariable;
  begin
    RMGridReport1.Dictionary.Variables.Insert(FindDictionary+1,VariableName);
  end;
  procedure SetVariableValue;
  begin
    RMGridReport1.Dictionary.Variables.Variable[VariableName] := VariableValue;
  end;
begin
  AddDirectory(DirectoryName);
  if FindVariable = -1 then
    CreateVariable;
  SetVariableValue;
end;

procedure TFrmReport.LoadFromFile(FileName: string);
begin
  RMGridReport1.LoadFromFile(FileName);
end;

procedure TFrmReport.LoadFromStream(Stream: TStream);
begin
  RMGridReport1.LoadFromStream(Stream);
end;

procedure TFrmReport.RMGridReportSave(Report: TRMReport;
  var ReportName: String; SaveAs: Boolean; var Saved: Boolean);
begin
  if Assigned(FOnSaveReport) then
  begin
    FOnSaveReport(Self,FReportType,ReportName,SaveAs,Saved);
    Saved := True;
  end;
end;

function TFrmReport.GetSaveToDataBase: Boolean;
begin
  Result := FSaveToDataBase;
end;

procedure TFrmReport.SetSaveToDataBase(value: Boolean);
begin
  FSaveToDataBase := value;
  if FSaveToDataBase then
  begin
    RMGridReportDesigner1.OnSaveReport := RMGridReportSave;
  end
  else
  begin
    RMGridReportDesigner1.OnSaveReport := nil;
  end;
end;

procedure TFrmReport.SetOnSaveReport(value: TSaveReportEvent);
begin
  FOnSaveReport := value;
end;


procedure TFrmReport.SetReportType(value: Integer);
begin
  FReportType := value;  
end;

function TFrmReport.GetReportType: Integer;
begin
  Result := FReportType;
end;

procedure TFrmReport.SaveToStream(Stream: TStream);
begin
  RMGridReport1.SaveToStream(Stream);
end;

procedure TFrmReport.SetVarible(VaribleName: string; Value: Variant);
begin
  inherited;
  try
    RMGridReport1.Dictionary.Variables.Variable[VaribleName] := Value;
  except

  end;
end;

procedure TFrmReport.FormDestroy(Sender: TObject);
var
  i:Integer;
begin
  for i :=0 to FDataSetList.Count -1 do
  begin
    TRMDBDataSet(FDataSetList[i]).DataSet := nil;
  end;
  FDataSetList.Clear;
  FDataSetList.Free;
  RMGridReport1.Free;
  RMGridReportDesigner1.Free;
end;

procedure TFrmReport.Preview;
begin
  inherited;
  RMGridReport1.ShowReport;
end;

procedure TFrmReport.Print;
begin
  inherited;
  RMGridReport1.PrintReport;
end;

end.
