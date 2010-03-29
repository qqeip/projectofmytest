unit RM_PChart;

interface

{$I RM.inc}

{$IFDEF TeeChart}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TeeProcs, TeEngine, Chart, Series, RM_Class, RM_Chart, RM_FormReport;

type
  TRMPrintChart = class(TComponent) // fake component
  end;

 { TRMFormPrintChart }
  TRMFormPrintChart = class(TRMFormReportObject)
  public
    procedure OnGenerate_Object(aFormReport: TRMFormReport; aPage: TRMReportPage;
      aControl: TControl; var t: TRMView); override;
  end;
{$ENDIF}

implementation

{$IFDEF TeeChart}
uses RM_Common, RM_Utils;

type
  THackFormReport = class(TRMFormReport)
  end;
  
procedure TRMFormPrintChart.OnGenerate_Object(aFormReport: TRMFormReport;
  aPage: TRMReportPage; aControl: TControl; var t: TRMView);
begin
  t := RMCreateObject(rmgtAddin, 'TRMChartView');
  t.ParentPage := aPage;
  t.spLeft := aControl.Left + THackFormReport(aFormReport).OffsX;
  t.spTop := aControl.Top + THackFormReport(aFormReport).OffsY;
  t.spWidth := aControl.Width + 4;
  t.spHeight := aControl.Height + 4;
  TRMChartView(t).AssignChart(TCustomChart(aControl));
  if rmgoDrawBorder in aFormReport.ReportOptions then
  begin
    t.LeftFrame.Visible := True;
    t.TopFrame.Visible := True;
    t.RightFrame.Visible := True;
    t.BottomFrame.Visible := True;
  end
  else
  begin
    t.LeftFrame.Visible := False;
    t.TopFrame.Visible := False;
    t.RightFrame.Visible := False;
    t.BottomFrame.Visible := False;
  end;

  if aFormReport.DrawOnPageFooter then
    aFormReport.ColumnFooterViews.Add(t)
  else
    aFormReport.ColumnHeaderViews.Add(t);
end;

initialization
  RMRegisterFormReportControl(TCustomChart, TRMFormPrintChart);
{$ENDIF}
end.
