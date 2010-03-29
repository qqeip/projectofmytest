//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("rm_r51.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vclsmp50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("vclbde50.bpi");
USEPACKAGE("vcljpg50.bpi");
USEPACKAGE("tee50.bpi");
USEPACKAGE("vclib50.bpi");
USEPACKAGE("dss50.bpi");
USEPACKAGE("vclado50.bpi");
USEPACKAGE("vclx50.bpi");
USEPACKAGE("vclmid50.bpi");
USEPACKAGE("teedb50.bpi");
USEFORMNS("RM_about.pas", Rm_about, RMFormAbout);
USEUNIT("RM_AngLbl.pas");
USEFORMNS("RM_BarCode.pas", Rm_barcode, RM2DBarCodeForm);
USEFORMNS("RM_Chart.pas", Rm_chart, RMChartForm);
USEUNIT("RM_CheckBox.pas");
USEUNIT("RM_ChineseMoneyMemo.pas");
USEUNIT("RM_Class.pas");
USEUNIT("RM_Common.pas");
USEUNIT("RM_Const.pas");
USEUNIT("RM_Const1.pas");
USEUNIT("RM_Ctrls.pas");
USEUNIT("RM_Dataset.pas");
USEUNIT("RM_DBDialogCtls.pas");
USEFORMNS("RM_Designer.pas", Rm_designer, RMDesignerForm);
USEFORMNS("RM_DesignerOptions.pas", Rm_designeroptions, RMDesOptionsForm);
USEUNIT("RM_Diagonal.pas");
USEUNIT("RM_DialogCtls.pas");
USEUNIT("RM_DsgCtrls.pas");
USEFORMNS("RM_e_bmp.pas", Rm_e_bmp, RMBMPExportForm);
USEFORMNS("RM_e_emf.pas", Rm_e_emf, RMEMFExportForm);
USEFORMNS("RM_e_gif.pas", Rm_e_gif, RMGIFExportForm);
USEUNIT("RM_E_Graphic.pas");
USEFORMNS("RM_e_Jpeg.pas", Rm_e_jpeg, RMJPEGExportForm);
USEFORMNS("RM_E_WMF.pas", Rm_e_wmf, RMWMFExportForm);
USEFORMNS("RM_EditorBand.pas", Rm_editorband, RMBandEditorForm);
USEFORMNS("RM_EditorBarCode.pas", Rm_editorbarcode, RMBarCodeForm);
USEFORMNS("RM_EditorCalc.pas", Rm_editorcalc, RMCalcMemoEditorForm);
USEFORMNS("RM_EditorCrossBand.pas", Rm_editorcrossband, RMVBandEditorForm);
USEFORMNS("RM_EditorDictionary.pas", Rm_editordictionary, RMDictionaryForm);
USEFORMNS("RM_EditorExpr.pas", Rm_editorexpr, RMFormExpressionBuilder);
USEFORMNS("RM_EditorField.pas", Rm_editorfield, RMFieldsForm);
USEFORMNS("RM_EditorFindReplace.pas", Rm_editorfindreplace, RMFindReplaceForm);
USEFORMNS("RM_EditorFormat.pas", Rm_editorformat, RMFmtForm);
USEFORMNS("RM_EditorFrame.pas", Rm_editorframe, RMFormFrameProp);
USEFORMNS("RM_EditorGroup.pas", Rm_editorgroup, RMGroupEditorForm);
USEFORMNS("RM_EditorHilit.pas", Rm_editorhilit, RMHilightForm);
USEFORMNS("RM_EditorMemo.pas", Rm_editormemo, RMEditorForm);
USEFORMNS("RM_EditorPicture.pas", Rm_editorpicture, RMPictureEditorForm);
USEFORMNS("RM_EditorReportProp.pas", Rm_editorreportprop, RMReportProperty);
USEFORMNS("RM_EditorStrings.pas", Rm_editorstrings, ELStringsEditorDlg);
USEFORMNS("RM_EditorTemplate.pas", Rm_editortemplate, RMTemplNewForm);
USEUNIT("RM_FormReport.pas");
USEUNIT("RM_Insp.pas");
USEFORMNS("RM_Ole.pas", Rm_ole, RMOleForm);
USEFORMNS("RM_PageSetup.pas", Rm_pagesetup, RMPageSetupForm);
USEUNIT("RM_Parser.pas");
USEUNIT("RM_PChart.pas");
USEUNIT("RM_PDBGrid.pas");
USEUNIT("RM_PdcsGrid.pas");
USEUNIT("RM_PEhGrid.pas");
USEUNIT("RM_Printer.pas");
USEFORMNS("RM_Progr.pas", Rm_progr, RMProgressForm);
USEUNIT("RM_PropAdds.pas");
USEUNIT("RM_PropInsp.pas");
USEUNIT("RM_PRxCtls.pas");
USEUNIT("RM_PwwGrid.pas");
USEFORMNS("RM_RichEdit.pas", Rm_richedit, RMRichForm);
USEFORMNS("RM_RxParaFmt.pas", Rm_rxparafmt, RMParaFormatDlg);
USEFORMNS("RM_RxRichEdit.pas", Rm_rxrichedit, RMRxRichForm);
USEUNIT("RM_Utils.pas");
USEFORMNS("RM_PreView.pas", Rm_preview, RMPreviewForm);
USEUNIT("RM_Wizard.pas");
USEFORMNS("RM_WizardNewReport.pas", Rm_wizardnewreport, RMTemplForm);
USEFORMNS("RM_wwRichEdit.pas", Rm_wwrichedit, RMwwRichForm);
USEFORMNS("RMD_ADO.pas", Rmd_ado, RMDFormADOConnEdit);
USEFORMNS("RMD_BDE.pas", Rmd_bde, RMDFormBDEDBProp);
USEFORMNS("RMD_DataPrv.pas", Rmd_dataprv, RMDFormPreviewData);
USEUNIT("RMD_DBWrap.pas");
USEFORMNS("RMD_Dbx.pas", Rmd_dbx, RMDFormDbxDBProp);
USEFORMNS("RMD_DlgListField.pas", Rmd_dlglistfield, RMDFieldsListForm);
USEFORMNS("RMD_DlgNewLookupField.pas", Rmd_dlgnewlookupfield, RMDLookupFieldForm);
USEFORMNS("RMD_EditorField.pas", Rmd_editorfield, RMDFieldsEditorForm);
USEFORMNS("RMD_Editorldlinks.pas", Rmd_editorldlinks, RMDFieldsLinkForm);
USEFORMNS("RMD_ExpFrm.pas", Rmd_expfrm, RMDFormReportExplorer);
USEFORMNS("RMD_IBX.pas", Rmd_ibx, RMDFormIBXPropEdit);
USEFORMNS("RMD_Qblnk.pas", Rmd_qblnk, RMDFormQBLink);
USEFORMNS("RMD_QryDesigner.pas", Rmd_qrydesigner, RMDQueryDesignerForm);
USEFORMNS("RMD_QueryParm.pas", Rmd_queryparm, RMDParamsForm);
USEUNIT("RMD_ReportExplorer.pas");
USEUNIT("RMInterpreter_Chart.pas");
USEUNIT("RM_DsgForm.pas");
USEFORMNS("RM_DsgGridReport.pas", Rm_dsggridreport, RMGridReportDesignerForm);
USEFORMNS("RM_EditorCellProp.pas", Rm_editorcellprop, RMCellPropForm);
USEFORMNS("RM_EditorCellWidth.pas", Rm_editorcellwidth, RMEditCellWidthForm);
USEFORMNS("RM_EditorGridCols.pas", Rm_editorgridcols, RMGetGridColumnsForm);
USEUNIT("RM_EditorInsField.pas");
USEUNIT("RM_Grid.pas");
USEUNIT("RM_GridReport.pas");
USEFORMNS("RM_PrintDlg.pas", Rm_printdlg, RMPrintDialogForm);
USEFORMNS("RMD_DlgSelectReportType.pas", Rmd_dlgselectreporttype, RMDSelectReportTypeForm);
USEFORMNS("RM_e_htm.pas", Rm_e_htm, RMHTMLExportForm);
USEFORMNS("RM_DlgFind.pas", Rm_dlgfind, RMPreviewSearchForm);
USEFORMNS("RM_EditorBandType.pas", Rm_editorbandtype, RMBandTypesForm);
USEFORMNS("RM_e_Xls.pas", Rm_e_xls, RMXLSExportForm);
USEFORMNS("RM_DBChart.pas", Rm_dbchart, RMDBChartForm);
USEUNIT("RM_TB97Vers.pas");
USEUNIT("RM_TB97Cmn.pas");
USEUNIT("RM_TB97Cnst.pas");
USEUNIT("RM_TB97Ctls.pas");
USEUNIT("RM_TB97Tlbr.pas");
USEUNIT("RM_TB97Tlwn.pas");
USEUNIT("RM_TB97.pas");
USEFORMNS("RM_e_csv.pas", Rm_e_csv, RMCSVExportForm);
USEUNIT("RM_AsBarView.pas");
USEFORMNS("RM_Cross.pas", Rm_cross, RMCrossForm);
USEUNIT("RM_AsBarCode.pas");
USEFORMNS("RM_e_txt.pas", Rm_e_txt, RMTXTExportForm);
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
	return 1;
}
//---------------------------------------------------------------------------
