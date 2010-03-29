unit ReportToolManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,ADODB;

type
  TAbsReportTool = class;
  
  TSaveReportEvent = procedure (AbsReportTool:TAbsReportTool;vrpType:Integer; var ReportName: String; SaveAs: Boolean; var Saved: Boolean) of object;

  TAbsReportTool = class(TForm)
  procedure OpenDesgin;virtual;abstract;
  procedure AddDataSet(vDataSet:TADODataSet);virtual;abstract;
  procedure AddDirectory(DirectoryName:string);virtual;abstract;
  procedure AddVariable(DirectoryName:string;VariableName:string;VariableValue:string = '');virtual;abstract;
  procedure SetVarible(VaribleName:string; Value:Variant);virtual;abstract;
  procedure LoadFromFile(FileName:string);virtual;abstract;
  procedure LoadFromStream(Stream:TStream);virtual;abstract;
  procedure SaveToStream(Stream:TStream);virtual;abstract;
  procedure SetSaveToDataBase(value:Boolean);virtual;abstract;
  procedure Preview;virtual;abstract;
  procedure Print;virtual;abstract;
  function GetSaveToDataBase:Boolean;virtual;abstract;
  procedure SetOnSaveReport(value:TSaveReportEvent);virtual;abstract;
  procedure SetReportType(value:Integer);virtual;abstract;
  function GetReportType:Integer;virtual;abstract;
  property ReportType:Integer read GetReportType write SetReportType;
  property SaveToDataBase: Boolean read GetSaveToDataBase write SetSaveToDataBase;
  property OnSaveReport:TSaveReportEvent write SetOnSaveReport;
  end;
  
  
//function GetReportTool:IReportTool;stdcall;external 'ReportTool.DLL';

implementation

end.
