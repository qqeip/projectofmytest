{*******************************************************
 ���ߣ�֣־ǿ
 Email:hnstronger@gmail.com
 �������ڣ�2006-7-10
*******************************************************}
unit UDevExpressToChinese;

interface
uses
  cxClasses, cxGridStrs, cxExportStrs, cxLibraryStrs, cxGridPopupMenuConsts, dxExtCtrlsStrs, dxPSRes, cxFilterConsts, cxDataConsts,
  cxFilterControlStrs, cxEditConsts;

procedure toChinese;

implementation

procedure toChinese;
begin
 //cxExportStrs.pas
 //------------------------------------------------------------------
  cxSetResourceString(@scxUnsupportedExport, '���ṩ���������: %1');
  //'Unsupported export type: %1');
  cxSetResourceString(@scxStyleManagerKill, '��ʽ���������ڱ�ʹ�û����ͷ�');
  //'The Style Manager is currently being used elsewhere and can not be released at this stage');
  cxSetResourceString(@scxStyleManagerCreate, '���ܴ�����ʽ������');
  //'Can''t create style manager');

  cxSetResourceString(@scxExportToHtml, '�������ҳ (*.html)');
  //'Export to Web page (*.html)');
  cxSetResourceString(@scxExportToXml, '�����XML�ĵ� (*.xml)');
  //'Export to XML document (*.xml)');
  cxSetResourceString(@scxExportToText, '������ı��ļ� (*.txt)');
  //'Export to text format (*.txt)');

  cxSetResourceString(@scxEmptyExportCache, '�������Ϊ��');
  //'Export cache is empty');
  cxSetResourceString(@scxIncorrectUnion, '����ȷ�ĵ�Ԫ���');
  //'Incorrect union of cells');
  cxSetResourceString(@scxIllegalWidth, '�Ƿ����п�');
  //'Illegal width of the column');
  cxSetResourceString(@scxInvalidColumnRowCount, '��Ч������������');
  //'Invalid column or row count');
  cxSetResourceString(@scxIllegalHeight, '�Ƿ����и�');
  //'Illegal height of the row');
  cxSetResourceString(@scxInvalidColumnIndex, '�б� %d ������Χ');
  //'The column index %d out of bounds');
  cxSetResourceString(@scxInvalidRowIndex, '�к� %d ������Χ');
  //'The row index %d out of bounds');
  cxSetResourceString(@scxInvalidStyleIndex, '��Ч����ʽ���� %d');
  //'Invalid style index %d');

  cxSetResourceString(@scxExportToExcel, '����� MS Excel�ļ� (*.xls)');
  //'Export to MS Excel (*.xls)');
  cxSetResourceString(@scxWorkbookWrite, 'д XLS �ļ�����');
  cxSetResourceString(@scxInvalidCellDimension, '��Ч�ĵ�Ԫά��');
  //'Invalid cell dimension');
  cxSetResourceString(@scxBoolTrue, '��');
  //'True');
  cxSetResourceString(@scxBoolFalse, '��');
  //'False';
  //-------------------------------------------------------------------------

  //cxLibraryStrs.pas
  //-------------------------------------------------------------------------
  cxSetResourceString(@scxCantCreateRegistryKey, '���ܴ���registry key: \%s');
  //tt8//'Can''t create the registry key: \%s');
{$IFNDEF DELPHI5}
  cxSetResourceString(@scxInvalidPropertyElement, '��Ч������Ԫ��: %s');
  //tt8//'Invalid property element: %s');
{$ENDIF}
  cxSetResourceString(@scxConverterCantCreateStyleRepository, '���ܴ���Style Repository');
  //tt8//'Can''t create the Style Repository');
  //-------------------------------------------------------------------------

  //cxGridStrs.pas
  //-------------------------------------------------------------------------
  cxSetResourceString(@scxGridRecursiveLevels, '�����ܴ����ݹ��');
  //'You cannot create recursive levels');

  cxSetResourceString(@scxGridDeletingConfirmationCaption, '��ʾ');
  //'Confirm');
  cxSetResourceString(@scxGridDeletingFocusedConfirmationText, 'ɾ��������?');
  //'Delete record?');
  cxSetResourceString(@scxGridDeletingSelectedConfirmationText, 'ɾ������ѡ���ļ�¼��?');

  cxSetResourceString(@scxGridNoDataInfoText, '<û���κμ�¼>');

  cxSetResourceString(@scxGridNewItemRowInfoText, '�����˴����һ����');
  //'Click here to add a new row');

  cxSetResourceString(@scxGridFilterIsEmpty, '<���ݹ�������Ϊ��>');
  //'<Filter is Empty>');

  cxSetResourceString(@scxGridCustomizationFormCaption, '����');
  //'Customization');
  cxSetResourceString(@scxGridCustomizationFormColumnsPageCaption, '��');
  cxSetResourceString(@scxGridGroupByBoxCaption, '���б����Ϸŵ��˴�ʹ��¼�����н��з���');
  //'Drag a column header here to group by that column');
  cxSetResourceString(@scxGridFilterCustomizeButtonCaption, '����...');
  //'Customize...');
  cxSetResourceString(@scxGridColumnsQuickCustomizationHint, '���ѡ�������');
  // 'Click here to select visible columns');

  cxSetResourceString(@scxGridCustomizationFormBandsPageCaption, '����');
  // 'Bands');
  cxSetResourceString(@scxGridBandsQuickCustomizationHint, '���ѡ���������');
  //'Click here to select visible bands');

  cxSetResourceString(@scxGridCustomizationFormRowsPageCaption, '��'); // 'Rows');

  cxSetResourceString(@scxGridConverterIntermediaryMissing, 'ȱ��һ���м����!'#13#10'�����һ�� %s ���������.');
  //'Missing an intermediary component!'#13#10'Please add a %s component to the form.');
  cxSetResourceString(@scxGridConverterNotExistGrid, 'cxGrid ������');
  //'cxGrid does not exist');
  cxSetResourceString(@scxGridConverterNotExistComponent, '���������');
  //'Component does not exist');
  cxSetResourceString(@scxImportErrorCaption, '�������');
  //'Import error');

  cxSetResourceString(@scxNotExistGridView, 'Grid ��ͼ������');
  //'Grid view does not exist');
  cxSetResourceString(@scxNotExistGridLevel, '��� grid �㲻����');
  //'Active grid level does not exist');
  cxSetResourceString(@scxCantCreateExportOutputFile, '���ܽ��������ļ�');
  //'Can''t create the export output file');

  cxSetResourceString(@cxSEditRepositoryExtLookupComboBoxItem,
    'ExtLookupComboBox|Represents an ultra-advanced lookup using the QuantumGrid as its drop down control');

  cxSetResourceString(@scxGridChartValueHintFormat, '%s for %s is %s'); // series display text, category, value
  //-------------------------------------------------------------------------

  //cxGridPopupMenuConsts.pas
  //-------------------------------------------------------------------------
  cxSetResourceString(@cxSGridNone, '��');
  //'None');

//Header popup menu captions

  cxSetResourceString(@cxSGridSortColumnAsc, '����');
  //'Sort Ascending');
  cxSetResourceString(@cxSGridSortColumnDesc, '����');
  //'Sort Descending');
  cxSetResourceString(@cxSGridClearSorting, '�������');

  //'Clear Sorting');
  cxSetResourceString(@cxSGridGroupByThisField, '���մ��ֶη���');
  //'Group By This Field');
  cxSetResourceString(@cxSGridRemoveThisGroupItem, '�Ӹ���ɾ��');
  //'Remove from grouping');
  cxSetResourceString(@cxSGridGroupByBox, '��ʾ/���ط����');
  //'Group By Box');
  cxSetResourceString(@cxSGridAlignmentSubMenu, '����');
  //'Alignment');
  cxSetResourceString(@cxSGridAlignLeft, '�����');
  //'Align Left');
  cxSetResourceString(@cxSGridAlignRight, '�Ҷ���');
  //'Align Right');
  cxSetResourceString(@cxSGridAlignCenter, '���ж���');
  //'Align Center');
  cxSetResourceString(@cxSGridRemoveColumn, 'ɾ������');
  //'Remove This Column');
  cxSetResourceString(@cxSGridFieldChooser, 'ѡ���ֶ�');
  //'Field Chooser');
  cxSetResourceString(@cxSGridBestFit, '�ʺ��п�');
  //'Best Fit');
  cxSetResourceString(@cxSGridBestFitAllColumns, '�ʺ��п� (������)');
  //'Best Fit (all columns)');
  cxSetResourceString(@cxSGridShowFooter, '��ע');
  //'Footer');
  cxSetResourceString(@cxSGridShowGroupFooter, '���ע');
  //'Group Footers');

//Footer popup menu captions

  cxSetResourceString(@cxSGridSumMenuItem, '�ϼ�');
  //'Sum');
  cxSetResourceString(@cxSGridMinMenuItem, '��С');
  //'Min');
  cxSetResourceString(@cxSGridMaxMenuItem, '���');
  //'Max');
  cxSetResourceString(@cxSGridCountMenuItem, '����');
  //'Count');
  cxSetResourceString(@cxSGridAvgMenuItem, 'ƽ��');
  //'Average');
  cxSetResourceString(@cxSGridNoneMenuItem, '��');
  //'None');

  //-------------------------------------------------------------------------

  //dxExtCtrlsStrs.pas
  //-------------------------------------------------------------------------
  cxSetResourceString(@sdxAutoColorText, '�Զ�');
  //tt8//'Auto');
  cxSetResourceString(@sdxCustomColorText, '����...');
  //tt8//'Custom...');

  cxSetResourceString(@sdxSysColorScrollBar, '������');
  //tt8//'ScrollBar');
  cxSetResourceString(@sdxSysColorBackground, '����');
  //tt8//'Background');
  cxSetResourceString(@sdxSysColorActiveCaption, '��������');
  //tt8//'Active Caption');
  cxSetResourceString(@sdxSysColorInactiveCaption, '�������');
  //tt8//'Inactive Caption');
  cxSetResourceString(@sdxSysColorMenu, '�˵�');
  //tt8//'Menu');
  cxSetResourceString(@sdxSysColorWindow, '����');
  //tt8//'Window');
  cxSetResourceString(@sdxSysColorWindowFrame, '���ڿ��');
  //tt8//'Window Frame');
  cxSetResourceString(@sdxSysColorMenuText, '�˵��ı�');
  //tt8//'Menu Text');
  cxSetResourceString(@sdxSysColorWindowText, '�����ı�t');
  //tt8//'Window Text');
  cxSetResourceString(@sdxSysColorCaptionText, '�����ı�');
  //tt8//'Caption Text');
  cxSetResourceString(@sdxSysColorActiveBorder, '��߿�');
  //tt8//'Active Border');
  cxSetResourceString(@sdxSysColorInactiveBorder, '����߿�');
  //tt8//'Inactive Border');
  cxSetResourceString(@sdxSysColorAppWorkSpace, '�������ռ�');
  //tt8//'App Workspace');
  cxSetResourceString(@sdxSysColorHighLight, '����');
  //tt8//'Highlight');
  cxSetResourceString(@sdxSysColorHighLighText, '�����ı�');
  //tt8//'Highlight Text');
  cxSetResourceString(@sdxSysColorBtnFace, '��ť����');
  //tt8//'Button Face');
  cxSetResourceString(@sdxSysColorBtnShadow, '��ť��Ӱ');
  //tt8//'Button Shadow');
  cxSetResourceString(@sdxSysColorGrayText, '��ɫ�ı�');
  //tt8//'Gray Text');
  cxSetResourceString(@sdxSysColorBtnText, '��ť�ı�');
  //tt8//'Button Text');
  cxSetResourceString(@sdxSysColorInactiveCaptionText, '����ı����ı�');
  //tt8//'Inactive Caption Text');
  cxSetResourceString(@sdxSysColorBtnHighligh, '��ť����');
  //tt8//'Button Highlight');
  cxSetResourceString(@sdxSysColor3DDkShadow, '3DDk ��Ӱ');
  //tt8//'3DDk Shadow');
  cxSetResourceString(@sdxSysColor3DLight, '3D ����');
  //tt8//'3DLight');
  cxSetResourceString(@sdxSysColorInfoText, '��Ϣ�ı�');
  //tt8//'Info Text');
  cxSetResourceString(@sdxSysColorInfoBk, '��Ϣ����');
  //tt8//'InfoBk');

  cxSetResourceString(@sdxPureColorBlack, '��');
  //tt8//'Black');
  cxSetResourceString(@sdxPureColorRed, '��');
  //tt8//'Red');
  cxSetResourceString(@sdxPureColorLime, '��');
  //tt8//'Lime');
  cxSetResourceString(@sdxPureColorYellow, '��');
  //tt8//'Yellow');
  cxSetResourceString(@sdxPureColorGreen, '��');
  //tt8//'Green');
  cxSetResourceString(@sdxPureColorTeal, '��');
  //tt8//'Teal');
  cxSetResourceString(@sdxPureColorAqua, 'ǳ��');
  //tt8//'Aqua');
  cxSetResourceString(@sdxPureColorBlue, '��');
  //tt8//'Blue');
  cxSetResourceString(@sdxPureColorWhite, '��');
  //tt8//'White');
  cxSetResourceString(@sdxPureColorOlive, 'ǳ��');
  //tt8//'Olive');
  cxSetResourceString(@sdxPureColorMoneyGreen, '����');
  //tt8//'Money Green');
  cxSetResourceString(@sdxPureColorNavy, '����');
  //tt8//'Navy');
  cxSetResourceString(@sdxPureColorSkyBlue, '����');
  //tt8//'Sky Blue');
  cxSetResourceString(@sdxPureColorGray, '��');
  //tt8//'Gray');
  cxSetResourceString(@sdxPureColorMedGray, '�л�');
  //tt8//'Medium Gray');
  cxSetResourceString(@sdxPureColorSilver, '��');
  //tt8//'Silver');
  cxSetResourceString(@sdxPureColorMaroon, '��ɫ');
  //tt8//'Maroon');
  cxSetResourceString(@sdxPureColorPurple, '��');
  //tt8//'Purple');
  cxSetResourceString(@sdxPureColorFuchsia, '�Ϻ�');
  //tt8//'Fuchsia');
  cxSetResourceString(@sdxPureColorCream, '��ɫ');
  //tt8//'Cream');

  cxSetResourceString(@sdxBrushStyleSolid, '����');
  //tt8//'Solid');
  cxSetResourceString(@sdxBrushStyleClear, '���');
  //tt8//'Clear');
  cxSetResourceString(@sdxBrushStyleHorizontal, 'ˮƽ');
  //tt8//'Horizontal');
  cxSetResourceString(@sdxBrushStyleVertical, '��ֱ');
  //tt8//'Vertical');
  cxSetResourceString(@sdxBrushStyleFDiagonal, 'Fб��');
  //tt8//'FDiagonal');
  cxSetResourceString(@sdxBrushStyleBDiagonal, 'Bб��');
  //tt8//'BDiagonal');
  cxSetResourceString(@sdxBrushStyleCross, '����');
  //tt8//'Cross');
  cxSetResourceString(@sdxBrushStyleDiagCross, '������');
  //tt8//'DiagCross');
  //-------------------------------------------------------------------------

  //cxFilterConsts.pas
  //-------------------------------------------------------------------------
  // base operators
  cxSetResourceString(@cxSFilterOperatorEqual, '����');
  //'equals');
  cxSetResourceString(@cxSFilterOperatorNotEqual, '������');
  //'does not equal');
  cxSetResourceString(@cxSFilterOperatorLess, 'С��');
  //'is less than');
  cxSetResourceString(@cxSFilterOperatorLessEqual, 'С�ڵ���');
  //'is less than or equal to');
  cxSetResourceString(@cxSFilterOperatorGreater, '����');
  //'is greater than');
  cxSetResourceString(@cxSFilterOperatorGreaterEqual, '���ڵ���');
  //'is greater than or equal to');
  cxSetResourceString(@cxSFilterOperatorLike, '����');
  //'like');
  cxSetResourceString(@cxSFilterOperatorNotLike, '������');
  //'not like');
  cxSetResourceString(@cxSFilterOperatorBetween, '��...֮��');
  //'between');
  cxSetResourceString(@cxSFilterOperatorNotBetween, '����...֮��');
  //'not between');
  cxSetResourceString(@cxSFilterOperatorInList, '����');
  //'in');
  cxSetResourceString(@cxSFilterOperatorNotInList, '������');
  //'not in');

  cxSetResourceString(@cxSFilterOperatorYesterday, '����');
  //'is yesterday');
  cxSetResourceString(@cxSFilterOperatorToday, '����');
  //'is today');
  cxSetResourceString(@cxSFilterOperatorTomorrow, '����');
  //'is tomorrow');

  cxSetResourceString(@cxSFilterOperatorLastWeek, 'ǰһ��');
  //'is last week');
  cxSetResourceString(@cxSFilterOperatorLastMonth, 'ǰһ��');
  //'is last month');
  cxSetResourceString(@cxSFilterOperatorLastYear, 'ǰһ��');
  //'is last year');

  cxSetResourceString(@cxSFilterOperatorThisWeek, '����');
  //'is this week');
  cxSetResourceString(@cxSFilterOperatorThisMonth, '����');
  //'is this month');
  cxSetResourceString(@cxSFilterOperatorThisYear, '����');
  //'is this year');

  cxSetResourceString(@cxSFilterOperatorNextWeek, '��һ��');
  //'is next week');
  cxSetResourceString(@cxSFilterOperatorNextMonth, '��һ��');
  //'is next month');
  cxSetResourceString(@cxSFilterOperatorNextYear, '��һ��');
  //'is next year');

  cxSetResourceString(@cxSFilterAndCaption, '����');
  //'and');
  cxSetResourceString(@cxSFilterOrCaption, '����');
  //'or');
  cxSetResourceString(@cxSFilterNotCaption, '��');
  //'not');
  cxSetResourceString(@cxSFilterBlankCaption, '��');
  //'blank');

  // derived
  cxSetResourceString(@cxSFilterOperatorIsNull, 'Ϊ��');
  //'is blank');
  cxSetResourceString(@cxSFilterOperatorIsNotNull, '��Ϊ��');
  //'is not blank');
  cxSetResourceString(@cxSFilterOperatorBeginsWith, '��ʼ��');
  //'begins with');
  cxSetResourceString(@cxSFilterOperatorDoesNotBeginWith, '����ʼ��');
  //'does not begin with');
  cxSetResourceString(@cxSFilterOperatorEndsWith, '������');
  //'ends with');
  cxSetResourceString(@cxSFilterOperatorDoesNotEndWith, '��������');
  //'does not end with');
  cxSetResourceString(@cxSFilterOperatorContains, '����');
  //'contains');
  cxSetResourceString(@cxSFilterOperatorDoesNotContain, '������');
  //'does not contain');
  // filter listbox's values
  cxSetResourceString(@cxSFilterBoxAllCaption, '(ȫ����ʾ)');
  //'(All)');
  cxSetResourceString(@cxSFilterBoxCustomCaption, '(���ƹ���...)');
  //'(Custom...)');
  cxSetResourceString(@cxSFilterBoxBlanksCaption, '(Ϊ��)');
  //'(Blanks)');
  cxSetResourceString(@cxSFilterBoxNonBlanksCaption, '(��Ϊ��)');
  //'(NonBlanks)');
  //-------------------------------------------------------------------------

  //cxDataConsts.pas
  //-------------------------------------------------------------------------
   // Data
  cxSetResourceString(@cxSDataReadError, '����������');
  //tt8//'Stream read error');
  cxSetResourceString(@cxSDataWriteError, '���������');
  //tt8//'Stream write error');
  cxSetResourceString(@cxSDataItemExistError, '��Ŀ�Ѿ�����');
  //tt8//'Item already exists');
  cxSetResourceString(@cxSDataRecordIndexError, '��¼����������Χ');
  //tt8//'RecordIndex out of range');
  cxSetResourceString(@cxSDataItemIndexError, '��Ŀ����������Χ');
  //tt8//'ItemIndex out of range');
  cxSetResourceString(@cxSDataProviderModeError, '�����ṩ�߲��ṩ�ò���');
  //tt8//'This operation is not supported in provider mode');
  cxSetResourceString(@cxSDataInvalidStreamFormat, '���������ʽ');
  //tt8//'Invalid stream format');
  cxSetResourceString(@cxSDataRowIndexError, '������������Χ');
  //tt8//'RowIndex out of range');
//  cxSetResourceString(@cxSDataRelationItemExistError,'������Ŀ������');
  //tt8//'Relation Item already exists');
//  cxSetResourceString(@cxSDataRelationCircularReference,'ϸ�����ݿ�����ѭ������');
  //tt8//'Circular Reference on Detail DataController');
//  cxSetResourceString(@cxSDataRelationMultiReferenceError,'����ϸ�����ݿ������Ѿ�����');
  //tt8//'Reference on Detail DataController already exists');
  cxSetResourceString(@cxSDataCustomDataSourceInvalidCompare, 'GetInfoForCompare û��ʵ��');
  //tt8//'GetInfoForCompare not implemented');
  // DB
//  cxSDBDataSetNil,'���ݼ�Ϊ��');
  //tt8//'DataSet is nil');
  cxSetResourceString(@cxSDBDetailFilterControllerNotFound, 'ϸ�����ݿ�����û�з���');
  //tt8//'DetailFilterController not found');
  cxSetResourceString(@cxSDBNotInGridMode, '���ݿ��������ڱ��(Grid)ģʽe');
  //tt8//'DataController not in GridMode');
  cxSetResourceString(@cxSDBKeyFieldNotFound, 'Key Field not found');
  //-------------------------------------------------------------------------

  //cxFilterControlStrs.pas
  //-------------------------------------------------------------------------
  // cxFilterBoolOperator
  cxSetResourceString(@cxSFilterBoolOperatorAnd, '����'); // all
  //'AND');        // all
  cxSetResourceString(@cxSFilterBoolOperatorOr, '����'); // any
  //'OR');          // any
  cxSetResourceString(@cxSFilterBoolOperatorNotAnd, '�ǲ���'); // not all
  //'NOT AND'); // not all
  cxSetResourceString(@cxSFilterBoolOperatorNotOr, '�ǻ���'); // not any
  //'NOT OR');   // not any
  //
  cxSetResourceString(@cxSFilterRootButtonCaption, '����');
  //'Filter');
  cxSetResourceString(@cxSFilterAddCondition, '�������(&C)');
  //'Add &Condition');
  cxSetResourceString(@cxSFilterAddGroup, '�����(&G)');
  //'Add &Group');
  cxSetResourceString(@cxSFilterRemoveRow, 'ɾ����(&R)');
  //'&Remove Row');
  cxSetResourceString(@cxSFilterClearAll, '���(&A)');
  //'Clear &All');
  cxSetResourceString(@cxSFilterFooterAddCondition, '���˰�ť����������');
  //'press the button to add a new condition');

  cxSetResourceString(@cxSFilterGroupCaption, 'ʹ�����������');

  //'applies to the following conditions');
  cxSetResourceString(@cxSFilterRootGroupCaption, '<��>');
  //'<root>');
  cxSetResourceString(@cxSFilterControlNullString, '<��>');
  //'<empty>');

  cxSetResourceString(@cxSFilterErrorBuilding, '���ܴ�Դ��������');
  //'Can''t build filter from source');

  //FilterDialog
  cxSetResourceString(@cxSFilterDialogCaption, '���ƹ���');
  //'Custom Filter');
  cxSetResourceString(@cxSFilterDialogInvalidValue, '����ֵ�Ƿ�');
  //'Invalid value');
  cxSetResourceString(@cxSFilterDialogUse, 'ʹ��');
  //'Use');
  cxSetResourceString(@cxSFilterDialogSingleCharacter, '��ʾ�κε����ַ�');
  //'to represent any single character');
  cxSetResourceString(@cxSFilterDialogCharactersSeries, '��ʾ�����ַ�');
  //'to represent any series of characters');
  cxSetResourceString(@cxSFilterDialogOperationAnd, '����');
  //'AND');
  cxSetResourceString(@cxSFilterDialogOperationOr, '����');
  //'OR');
  cxSetResourceString(@cxSFilterDialogRows, '��ʾ������:');
  //'Show rows where:');

  // FilterControlDialog
  cxSetResourceString(@cxSFilterControlDialogCaption, '����������');
  //'Filter builder');
  cxSetResourceString(@cxSFilterControlDialogNewFile, 'δ����.flt');
  //'untitled.flt');
  cxSetResourceString(@cxSFilterControlDialogOpenDialogCaption, '��һ���Ѵ��ļ�');
  cxSetResourceString(@cxSFilterControlDialogSaveDialogCaption, '���浱ǰ��ļ�'); //'Save the active filter to file');
  cxSetResourceString(@cxSFilterControlDialogActionSaveCaption, '���');
  cxSetResourceString(@cxSFilterControlDialogActionOpenCaption, '��');
  cxSetResourceString(@cxSFilterControlDialogActionApplyCaption, 'Ӧ��');
  cxSetResourceString(@cxSFilterControlDialogActionOkCaption, 'ȷ��');
  //'OK');
  cxSetResourceString(@cxSFilterControlDialogActionCancelCaption, 'ȡ��');
  cxSetResourceString(@cxSFilterControlDialogFileExt, 'flt');
  //'flt');
  cxSetResourceString(@cxSFilterControlDialogFileFilter, '�����ļ� (*.flt)|*.flt');

  //-------------------------------------------------------------------------

  //cxEditConsts.pas
  //-------------------------------------------------------------------------
  cxSetResourceString(@cxSEditButtonCancel, 'ȡ��');
  //sdl//'Cancel'
  cxSetResourceString(@cxSEditButtonOK, 'ȷ��');
  //sdl//'OK'
  cxSetResourceString(@cxSEditDateConvertError, 'Could not convert to date');
  cxSetResourceString(@cxSEditInvalidRepositoryItem, '�˲ֿ���Ŀ���ɽ���');
  //tt8//'The repository item is not acceptable');
  cxSetResourceString(@cxSEditNumericValueConvertError, '����ת��������');
  //tt8//'Could not convert to numeric value');
  cxSetResourceString(@cxSEditPopupCircularReferencingError, '������ѭ������');
  //tt8//'Circular referencing is not allowed');
  cxSetResourceString(@cxSEditPostError, '���ύ�༭ֵʱ��������');
  //tt8//'An error occured during posting edit value');
  cxSetResourceString(@cxSEditTimeConvertError, '����ת����ʱ��');
  //tt8//'Could not convert to time');
  cxSetResourceString(@cxSEditValidateErrorText, '����ȷ������ֵ. ʹ��ESC�������ı�');
  //tt8//'Invalid input value. Use escape key to abandon changes');
  cxSetResourceString(@cxSEditValueOutOfBounds, 'ֵ������Χ');
  //tt8//'Value out of bounds');

  // TODO
  cxSetResourceString(@cxSEditCheckBoxChecked, '��');
  //tt8//'True');
  cxSetResourceString(@cxSEditCheckBoxGrayed, '');
  //tt8//'');
  cxSetResourceString(@cxSEditCheckBoxUnchecked, '��');
  //tt8//'False');
  cxSetResourceString(@cxSRadioGroupDefaultCaption, '');
  //tt8//'');

  cxSetResourceString(@cxSTextTrue, '��');
  //tt8//'True');
  cxSetResourceString(@cxSTextFalse, '��');
  //tt8//'False');

  // blob
  cxSetResourceString(@cxSBlobButtonOK, 'ȷ��(&O)');
  //tt8//'&OK');
  cxSetResourceString(@cxSBlobButtonCancel, 'ȡ��(&C)');
  //tt8//'&Cancel');
  cxSetResourceString(@cxSBlobButtonClose, '�ر�(&C)');
  //tt8//'&Close');
  cxSetResourceString(@cxSBlobMemo, '(�ı�)');
  //tt8//'(MEMO)');
  cxSetResourceString(@cxSBlobMemoEmpty, '(���ı�)');
  //tt8//'(memo)');
  cxSetResourceString(@cxSBlobPicture, '(ͼ��)');
  //tt8//'(PICTURE)');
  cxSetResourceString(@cxSBlobPictureEmpty, '(��ͼ��)');
  //tt8//'(picture)');

  // popup menu items
  cxSetResourceString(@cxSMenuItemCaptionCut, '����(&T)');
  //tt8//'Cu&t');
  cxSetResourceString(@cxSMenuItemCaptionCopy, '����(&C)');
  //tt8//'&Copy');
  cxSetResourceString(@cxSMenuItemCaptionPaste, 'ճ��(&P)');
  //tt8//'&Paste');
  cxSetResourceString(@cxSMenuItemCaptionDelete, 'ɾ��(&D)');
  //tt8//'&Delete');
  cxSetResourceString(@cxSMenuItemCaptionLoad, 'װ��(&L)...');
  //tt8//'&Load...');
  cxSetResourceString(@cxSMenuItemCaptionSave, '���Ϊ(&A)...');
  //tt8//'Save &As...');

  // date
  cxSetResourceString(@cxSDatePopupClear, '���');
  //tt8//'Clear');
  cxSetResourceString(@cxSDatePopupNow, 'Now');
  cxSetResourceString(@cxSDatePopupOK, 'OK');
  cxSetResourceString(@cxSDatePopupToday, '����');
  //tt8//'Today');
  cxSetResourceString(@cxSDateError, '�Ƿ�����');
  //tt8//'Invalid Date');
  // smart input consts
  cxSetResourceString(@cxSDateToday, '����');
  //tt8//'today');
  cxSetResourceString(@cxSDateYesterday, '����');
  //tt8//'yesterday');
  cxSetResourceString(@cxSDateTomorrow, '����');
  //tt8//'tomorrow');
  cxSetResourceString(@cxSDateSunday, '������');
  //tt8//'Sunday');
  cxSetResourceString(@cxSDateMonday, '����һ');
  //tt8//'Monday');
  cxSetResourceString(@cxSDateTuesday, '���ڶ�');
  //tt8//'Tuesday');
  cxSetResourceString(@cxSDateWednesday, '������');
  //tt8//'Wednesday');
  cxSetResourceString(@cxSDateThursday, '������');
  //tt8//'Thursday');
  cxSetResourceString(@cxSDateFriday, '������');
  //tt8//'Friday');
  cxSetResourceString(@cxSDateSaturday, '������');
  //tt8//'Saturday');
  cxSetResourceString(@cxSDateFirst, '��һ');
  //tt8//'first');
  cxSetResourceString(@cxSDateSecond, '�ڶ�');
  //tt8//'second');
  cxSetResourceString(@cxSDateThird, '����');
  //tt8//'third');
  cxSetResourceString(@cxSDateFourth, '����');
  //tt8//'fourth');
  cxSetResourceString(@cxSDateFifth, '����');
  //tt8//'fifth');
  cxSetResourceString(@cxSDateSixth, '����');
  //tt8//'sixth');
  cxSetResourceString(@cxSDateSeventh, '����');
  //tt8//'seventh');
  cxSetResourceString(@cxSDateBOM, '�³�');
  //tt8//'bom');
  cxSetResourceString(@cxSDateEOM, '��ĩ');
  //tt8//'eom');
  cxSetResourceString(@cxSDateNow, '����');
  //tt8//'now');

  // calculator
  cxSetResourceString(@scxSCalcError, '����');
  //tt8//'Error'

  // HyperLink
  cxSetResourceString(@scxSHyperLinkPrefix, 'http://');
  cxSetResourceString(@scxSHyperLinkDoubleSlash, '//');

  // edit repository
  cxSetResourceString(@scxSEditRepositoryBlobItem, 'BlobEdit|Represents the BLOB editor');
  cxSetResourceString(@scxSEditRepositoryButtonItem, 'ButtonEdit|Represents an edit control with embedded buttons');
  cxSetResourceString(@scxSEditRepositoryCalcItem, 'CalcEdit|Represents an edit control with a dropdown calculator window');
  cxSetResourceString(@scxSEditRepositoryCheckBoxItem, 'CheckBox|Represents a check box control that allows selecting an option');
  cxSetResourceString(@scxSEditRepositoryComboBoxItem, 'ComboBox|Represents the combo box editor');
  cxSetResourceString(@scxSEditRepositoryCurrencyItem, 'CurrencyEdit|Represents an editor enabling editing currency data');
  cxSetResourceString(@scxSEditRepositoryDateItem, 'DateEdit|Represents an edit control with a dropdown calendar');
  cxSetResourceString(@scxSEditRepositoryHyperLinkItem, 'HyperLink|Represents a text editor with hyperlink functionality');
  cxSetResourceString(@scxSEditRepositoryImageComboBoxItem,
    'ImageComboBox|Represents an editor displaying the list of images and text strings within the dropdown window');
  cxSetResourceString(@scxSEditRepositoryImageItem, 'Image|Represents an image editor');
  cxSetResourceString(@scxSEditRepositoryLookupComboBoxItem, 'LookupComboBox|Represents a lookup combo box control');
  cxSetResourceString(@scxSEditRepositoryMaskItem, 'MaskEdit|Represents a generic masked edit control.');
  cxSetResourceString(@scxSEditRepositoryMemoItem, 'Memo|Represents an edit control that allows editing memo data');
  cxSetResourceString(@scxSEditRepositoryMRUItem,
    'MRUEdit|Represents a text editor displaying the list of most recently used items (MRU) within a dropdown window');
  cxSetResourceString(@scxSEditRepositoryPopupItem, 'PopupEdit|Represents an edit control with a dropdown list');
  cxSetResourceString(@scxSEditRepositorySpinItem, 'SpinEdit|Represents a spin editor');
  cxSetResourceString(@scxSEditRepositoryRadioGroupItem, 'RadioGroup|Represents a group of radio buttons');
  cxSetResourceString(@scxSEditRepositoryTextItem, 'TextEdit|Represents a single line text editor');
  cxSetResourceString(@scxSEditRepositoryTimeItem, 'TimeEdit|Represents an editor displaying time values');

  cxSetResourceString(@scxRegExprLine, '��');
  //tt8//'Line');
  cxSetResourceString(@scxRegExprChar, '�ַ�');
  //tt8//'Char');
  cxSetResourceString(@scxRegExprNotAssignedSourceStream, '��Դ��û�б���ֵ');
  //tt8//'The source stream is not assigned');
  cxSetResourceString(@scxRegExprEmptySourceStream, '��Դ���ǿյ�');
  //tt8//'The source stream is empty');
  cxSetResourceString(@scxRegExprCantUsePlusQuantifier, '���� ''+'' ����Ӧ�õ���');
  //tt8//'The ''+'' quantifier cannot be applied here');
  cxSetResourceString(@scxRegExprCantUseStarQuantifier, '���� ''*'' ����Ӧ�õ���');
  //tt8//'The ''*'' quantifier cannot be applied here');
  cxSetResourceString(@scxRegExprCantCreateEmptyAlt, '������һ����Ϊ��');
  //tt8//'The alternative should not be empty');
  cxSetResourceString(@scxRegExprCantCreateEmptyBlock, '�˿�Ӧ��Ϊ��');
  //tt8//'The block should not be empty');
  cxSetResourceString(@scxRegExprIllegalSymbol, '���Ϲ涨�� ''%s''');
  //tt8//'Illegal ''%s''');
  cxSetResourceString(@scxRegExprIllegalQuantifier, '���Ϲ涨������ ''%s''');
  //tt8//'Illegal quantifier ''%s''');
  cxSetResourceString(@scxRegExprNotSupportQuantifier, '�˲������ʲ�֧��');
  //tt8//'The parameter quantifiers are not supported');
  cxSetResourceString(@scxRegExprIllegalIntegerValue, '���Ϸ�������ֵ');
  //tt8//'Illegal integer value');
  cxSetResourceString(@scxRegExprTooBigReferenceNumber, '������̫��');
  //tt8//'Too big reference number');
  cxSetResourceString(@scxRegExprCantCreateEmptyEnum, '���ܴ����յ�ö��ֵ');
  //tt8//'Can''t create empty enumeration');
  cxSetResourceString(@scxRegExprSubrangeOrder, '�Ӵ��Ŀ�ʼ�ַ�λ�ò��ܳ��������ַ�λ��');
  //tt8//'The starting character of the subrange must be less than the finishing one');
  cxSetResourceString(@scxRegExprHexNumberExpected0, '�ڴ�ʮ��������');
  //tt8//'Hexadecimal number expected');
  cxSetResourceString(@scxRegExprHexNumberExpected, '�ڴ�ʮ����������λ�÷����� ''%s'' ');
  //tt8//'Hexadecimal number expected but ''%s'' found');
  cxSetResourceString(@scxRegExprMissing, 'ȱ�� ''%s''');
  //tt8//'Missing ''%s''');
  cxSetResourceString(@scxRegExprUnnecessary, '����Ҫ�� ''%s''');
  //tt8//'Unnecessary ''%s''');
  cxSetResourceString(@scxRegExprIncorrectSpace, '�� ''\'' ���ܳ��ֿո��ַ�');
  //tt8//'The space character is not allowed after ''\''');
  cxSetResourceString(@scxRegExprNotCompiled, '������ʽ���ܱ���');
  //tt8//'Regular expression is not compiled');
  cxSetResourceString(@scxRegExprIncorrectParameterQuantifier, '����Ĳ���');
  //tt8//'Incorrect parameter quantifier');
  cxSetResourceString(@scxRegExprCantUseParameterQuantifier, '�˲�������Ӧ���ڴ˴�');
  //tt8//'The parameter quantifier cannot be applied here');

  cxSetResourceString(@scxMaskEditRegExprError, '������ʽ����:');
  //tt8//'Regular expression errors:');
  cxSetResourceString(@scxMaskEditInvalidEditValue, '�༭ֵ�Ƿ�');
  //tt8//'The edit value is invalid');
  cxSetResourceString(@scxMaskEditNoMask, 'û��');
  //tt8//'None');
  cxSetResourceString(@scxMaskEditIllegalFileFormat, '�ļ���ʽ�Ƿ�');
  //tt8//'Illegal file format');
  cxSetResourceString(@scxMaskEditEmptyMaskCollectionFile, '�����ʽ�ļ�Ϊ��');
  //tt8//'The mask collection file is empty');
  cxSetResourceString(@scxMaskEditMaskCollectionFiles, '�����ʽ�ļ�');
  //tt8//'Mask collection files');
  cxSetResourceString(@cxSSpinEditInvalidNumericValue, 'Invalid numeric value');
  //-------------------------------------------------------------------------

  //dxPSRes.pas
  //-------------------------------------------------------------------------
  cxSetResourceString(@sdxBtnOK,'ȷ��(&O)');
  //tt8//'OK');                                                                                                                                                                                                                  
  cxSetResourceString(@sdxBtnOKAccelerated,'ȷ��(&O');
  //tt8//'&OK');                                                                                                                                                                                                       
  cxSetResourceString(@sdxBtnCancel,'ȡ��');
  //tt8//'Cancel');                                                                                                                                                                                                              
  cxSetResourceString(@sdxBtnClose,'�ر�');
  //tt8//'Close');                                                                                                                                                                                                                
  cxSetResourceString(@sdxBtnApply,'Ӧ��(&A)');
  //tt8//'&Apply');                                                                                                                                                                                                           
  cxSetResourceString(@sdxBtnHelp,'����(&H)');
  //tt8//'&Help');                                                                                                                                                                                                             
  cxSetResourceString(@sdxBtnFix,'����(&F)');
  //tt8//'&Fix');                                                                                                                                                                                                               
  cxSetResourceString(@sdxBtnNew,'�½�(&N)...');
  //tt8//'&New...');                                                                                                                                                                                                         
  cxSetResourceString(@sdxBtnIgnore,'����(&I)');
  //tt8//'&Ignore');                                                                                                                                                                                                         
  cxSetResourceString(@sdxBtnYes,'��(&Y)');
  //tt8//'&Yes');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnNo,'��(&N)');
  //tt8//'&No');                                                                                                                                                                                                                   
  cxSetResourceString(@sdxBtnEdit,'�༭(&E)...');
  //tt8//'&Edit...');                                                                                                                                                                                                       
  cxSetResourceString(@sdxBtnReset,'��λ(&R)');
  //tt8//'&Reset');                                                                                                                                                                                                           
  cxSetResourceString(@sdxBtnAdd,'����(&A');
  //tt8//'&Add');                                                                                                                                                                                                                
  cxSetResourceString(@sdxBtnAddComposition,'���Ӳ���(&C)');
  //tt8//'Add &Composition');                                                                                                                                                                                    
  cxSetResourceString(@sdxBtnDefault,'Ĭ��(&D)...');
  //tt8//'&Default...');                                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnDelete,'ɾ��(&D)...');
  //tt8//'&Delete...');                                                                                                                                                                                                   
  cxSetResourceString(@sdxBtnDescription,'����(&D)...');
  //tt8//'&Description...');                                                                                                                                                                                         
  cxSetResourceString(@sdxBtnCopy,'����(&C)...');
  //tt8//'&Copy...');                                                                                                                                                                                                       
  cxSetResourceString(@sdxBtnYesToAll,'ȫ����(&A)');
  //tt8//'Yes To &All');                                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnRestoreDefaults,'�ָ�Ĭ��ֵ(&R)');
  //tt8//'&Restore Defaults');                                                                                                                                                                                
  cxSetResourceString(@sdxBtnRestoreOriginal,'��ԭ(&O)');
  //tt8//'Restore &Original');                                                                                                                                                                                      
  cxSetResourceString(@sdxBtnTitleProperties,'��������...');
  //tt8//'Title Properties...');                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnProperties,'����(&R)...');
  //tt8//'P&roperties...');                                                                                                                                                                                           
  cxSetResourceString(@sdxBtnNetwork,'����(&W)...');
  //tt8//'Net&work...');                                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnBrowse,'���(&B)...');
  //tt8//'&Browse...');                                                                                                                                                                                                   
  cxSetResourceString(@sdxBtnPageSetup,'ҳ������(&G)...');
  //tt8//'Pa&ge Setup...');                                                                                                                                                                                        
  cxSetResourceString(@sdxBtnPrintPreview,'��ӡԤ��(&V)...');
  //tt8//'Print Pre&view...');                                                                                                                                                                                  
  cxSetResourceString(@sdxBtnPreview,'Ԥ��(&V)...');
  //tt8//'Pre&view...');                                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnPrint,'��ӡ...');
  //tt8//'Print...');                                                                                                                                                                                                          
  cxSetResourceString(@sdxBtnOptions,'ѡ��(&O)...');
  //tt8//'&Options...');                                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnStyleOptions,'��ʽѡ��...');
  //tt8//'Style Options...');                                                                                                                                                                                       
  cxSetResourceString(@sdxBtnDefinePrintStyles,'������ʽ(&D)...');
  //tt8//'&Define Styles...');                                                                                                                                                                             
  cxSetResourceString(@sdxBtnPrintStyles,'��ӡ��ʽ');
  //tt8//'Print Styles');                                                                                                                                                                                               
  cxSetResourceString(@sdxBtnBackground,'����');
  //tt8//'Background');                                                                                                                                                                                                      
  cxSetResourceString(@sdxBtnShowToolBar,'��ʾ������(&T)');
  //tt8//'Show &ToolBar');                                                                                                                                                                                        
  cxSetResourceString(@sdxBtnDesign,'���(&E)...');
  //tt8//'D&esign...');                                                                                                                                                                                                   
  cxSetResourceString(@sdxBtnMoveUp,'����(&U)');
  //tt8//'Move &Up');                                                                                                                                                                                                        
  cxSetResourceString(@sdxBtnMoveDown,'����(&N)');
  //tt8//'Move Dow&n'); 

  cxSetResourceString(@sdxBtnMoreColors,'������ɫ(&M)...');
  //tt8//'&More Colors...');                                                                                                                                                                                      
  cxSetResourceString(@sdxBtnFillEffects,'���Ч��(&F)...');
  //tt8//'&Fill Effects...');                                                                                                                                                                                    
  cxSetResourceString(@sdxBtnNoFill,'�����');
  //tt8//'&No Fill');                                                                                                                                                                                                          
  cxSetResourceString(@sdxBtnAutomatic,'�Զ�(&A)');
  //tt8//'&Automatic');                                                                                                                                                                                                   
  cxSetResourceString(@sdxBtnNone,'��(&N)');
  //tt8//'&None'); 

  cxSetResourceString(@sdxBtnOtherTexture,'��������(&X)...');
  //tt8//'Other Te&xture...');                                                                                                                                                                                  
  cxSetResourceString(@sdxBtnInvertColors,'��ת��ɫ(&N)');
  //tt8//'I&nvert Colors');                                                                                                                                                                                        
  cxSetResourceString(@sdxBtnSelectPicture,'ѡ��ͼƬ(&L)...');
  //tt8//'Se&lect Picture...'); 

  cxSetResourceString(@sdxEditReports,'�༭����');
  //tt8//'Edit Reports');                                                                                                                                                                                                  
  cxSetResourceString(@sdxComposition,'����');
  //tt8//'Composition');                                                                                                                                                                                                       
  cxSetResourceString(@sdxReportTitleDlgCaption,'�������');
  //tt8//'Report Title');                                                                                                                                                                                        
  cxSetResourceString(@sdxMode,'ģʽ(&M):');
  //tt8//'&Mode:');                                                                                                                                                                                                              
  cxSetResourceString(@sdxText,'����(&T)');
  //tt8//'&Text');                                                                                                                                                                                                                
  cxSetResourceString(@sdxProperties,'����(&P)');
  //tt8//'&Properties');                                                                                                                                                                                                    
  cxSetResourceString(@sdxAdjustOnScale,'�ʺ�ҳ��(&A)');
  //tt8//'&Adjust on Scale');                                                                                                                                                                                        
  cxSetResourceString(@sdxTitleModeNone,'��');
  //tt8//'None');                                                                                                                                                                                                              
  cxSetResourceString(@sdxTitleModeOnEveryTopPage,'��ÿ�Ŷ�ҳ');
  //tt8//'On Every Top Page');                                                                                                                                                                               
  cxSetResourceString(@sdxTitleModeOnFirstPage,'�ڵ�һҳ');
  //tt8//'On First Page'); 

  cxSetResourceString(@sdxEditDescription,'�༭����');
  //tt8//'Edit Description');                                                                                                                                                                                          
  cxSetResourceString(@sdxRename,'������(&M)');
  //tt8//'Rena&me');                                                                                                                                                                                                          
  cxSetResourceString(@sdxSelectAll,'ȫѡ');
  //tt8//'&Select All'); 
  
  cxSetResourceString(@sdxAddReport,'���ӱ���');
  //tt8//'Add Report');                                                                                                                                                                                                      
  cxSetResourceString(@sdxAddAndDesignReport,'���Ӳ���Ʊ���(&D)...');
  //tt8//'Add and D&esign Report...');                                                                                                                                                                 
  cxSetResourceString(@sdxNewCompositionCaption,'�½�����');
  //tt8//'New Composition');                                                                                                                                                                                     
  cxSetResourceString(@sdxName,'����(&N):');
  //tt8//'&Name:');                                                                                                                                                                                                              
  cxSetResourceString(@sdxCaption,'����(&C):');
  //tt8//'&Caption:');                                                                                                                                                                                                        
  cxSetResourceString(@sdxAvailableSources,'���õ�Դ(&A)');
  //tt8//'&Available Source(s)');                                                                                                                                                                                 
  cxSetResourceString(@sdxOnlyComponentsInActiveForm,'ֻ��ʾ��ǰ�������');
  //tt8//'Only Components in Active &Form');                                                                                                                                                    
  cxSetResourceString(@sdxOnlyComponentsWithoutLinks,'ֻ��ʾ�����б���������������');
  //tt8//'Only Components &without Existing ReportLinks');                                                                                                                            
  cxSetResourceString(@sdxItemName,'����');
  //tt8//'Name');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxItemDescription,'����');
  //tt8//'Description');
    
  cxSetResourceString(@sdxConfirmDeleteItem,'Ҫɾ����һ����Ŀ�� %s ��?');
  //tt8//'Do you want to delete next items: %s ?');                                                                                                                                                 
  cxSetResourceString(@sdxAddItemsToComposition,'������Ŀ������');
  //tt8//'Add Items to Composition');                                                                                                                                                                      
  cxSetResourceString(@sdxHideAlreadyIncludedItems,'�����Ѱ�����Ŀ');
  //tt8//'Hide Already &Included Items');                                                                                                                                                               
  cxSetResourceString(@sdxAvailableItems,'������Ŀ(&I)');
  //tt8//'A&vailable Items');                                                                                                                                                                                       
  cxSetResourceString(@sdxItems,'��Ŀ(&I)');
  //tt8//'&Items');                                                                                                                                                                                                              
  cxSetResourceString(@sdxEnable,'����(&E)');
  //tt8//'&Enable');                                                                                                                                                                                                            
  cxSetResourceString(@sdxOptions,'ѡ��');
  //tt8//'Options');                                                                                                                                                                                                               
  cxSetResourceString(@sdxShow,'��ʾ');
  //tt8//'Show');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxPaintItemsGraphics,'������Ŀͼʾ(&P)');
  //tt8//'&Paint Item Graphics');                                                                                                                                                                           
  cxSetResourceString(@sdxDescription,'����:');
  //tt8//'&Description:');

  cxSetResourceString(@sdxNewReport,'�±���');
  //tt8//'NewReport');
    
  cxSetResourceString(@sdxOnlySelected,'ֻ��ѡ����(&S)');
  //tt8//'Only &Selected');                                                                                                                                                                                         
  cxSetResourceString(@sdxExtendedSelect,'��չѡ����(&E)');
  //tt8//'&Extended Select');                                                                                                                                                                                     
  cxSetResourceString(@sdxIncludeFixed,'�����̶���(&I)');
  //tt8//'&Include Fixed');

  cxSetResourceString(@sdxFonts,'����');
  //tt8//'Fonts');                                                                                                                                                                                                                   
  cxSetResourceString(@sdxBtnFont,'����(&N)...');
  //tt8//'Fo&nt...');                                                                                                                                                                                                       
  cxSetResourceString(@sdxBtnEvenFont,'ż��������(&V)...');
  //tt8//'E&ven Font...');                                                                                                                                                                                        
  cxSetResourceString(@sdxBtnOddFont,'����������(&N)...');
  //tt8//'Odd Fo&nt...');                                                                                                                                                                                          
  cxSetResourceString(@sdxBtnFixedFont,'�̶�������(&I)...');
  //tt8//'F&ixed Font...');                                                                                                                                                                                      
  cxSetResourceString(@sdxBtnGroupFont,'������(&P)...');
  //tt8//'Grou&p Font...');                                                                                                                                                                                          
  cxSetResourceString(@sdxBtnChangeFont,'��������(&N)...');
  //tt8//'Change Fo&nt...');

  cxSetResourceString(@sdxFont,'����');
  //tt8//'Font');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxOddFont,'����������');
  //tt8//'Odd Font');                                                                                                                                                                                                        
  cxSetResourceString(@sdxEvenFont,'ż��������');
  //tt8//'Even Font');                                                                                                                                                                                                      
  cxSetResourceString(@sdxPreviewFont,'Ԥ������');
  //tt8//'Preview Font');                                                                                                                                                                                                  
  cxSetResourceString(@sdxCaptionNodeFont,'��α�������');
  //tt8//'Level Caption Font');                                                                                                                                                                                    
  cxSetResourceString(@sdxGroupNodeFont,'��ڵ�����');
  //tt8//'Group Node Font');                                                                                                                                                                                           
  cxSetResourceString(@sdxGroupFooterFont,'�������');
  //tt8//'Group Footer Font');                                                                                                                                                                                         
  cxSetResourceString(@sdxHeaderFont,'ҳü����');
  //tt8//'Header Font');                                                                                                                                                                                                    
  cxSetResourceString(@sdxFooterFont,'ҳ������');
  //tt8//'Footer Font');                                                                                                                                                                                                    
  cxSetResourceString(@sdxBandFont,'��������');
  //tt8//'Band Font');

  cxSetResourceString(@sdxTransparent,'͸��(&T)');
  //tt8//'&Transparent');                                                                                                                                                                                                  
  cxSetResourceString(@sdxFixedTransparent,'͸��(&X)');
  //tt8//'Fi&xed Transparent');                                                                                                                                                                                       
  cxSetResourceString(@sdxCaptionTransparent,'����͸��');
  //tt8//'Caption Transparent');                                                                                                                                                                                    
  cxSetResourceString(@sdxGroupTransparent,'��͸��');
  //tt8//'Group Transparent'); 

  cxSetResourceString(@sdxGraphicAsTextValue,'(ͼ��)');
  //tt8//'(GRAPHIC)');                                                                                                                                                                                                
  cxSetResourceString(@sdxColors,'��ɫ');
  //tt8//'Colors');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxColor,'��ɫ(&L):');
  //tt8//'Co&lor:');                                                                                                                                                                                                            
  cxSetResourceString(@sdxOddColor,'��������ɫ(&L):');
  //tt8//'Odd Co&lor:');                                                                                                                                                                                               
  cxSetResourceString(@sdxEvenColor,'ż������ɫ(&V):');
  //tt8//'E&ven Color:');                                                                                                                                                                                             
  cxSetResourceString(@sdxPreviewColor,'Ԥ����ɫ(&P):');
  //tt8//'&Preview Color:');                                                                                                                                                                                         
  cxSetResourceString(@sdxBandColor,'������ɫ(&B):');
  //tt8//'&Band Color:');                                                                                                                                                                                               
  cxSetResourceString(@sdxLevelCaptionColor,'��α�����ɫ(&V):');
  //tt8//'Le&vel Caption Color:');                                                                                                                                                                          
  cxSetResourceString(@sdxHeaderColor,'������ɫ(&E):');
  //tt8//'H&eader Color:');                                                                                                                                                                                           
  cxSetResourceString(@sdxGroupNodeColor,'��ڵ���ɫ(&N):');
  //tt8//'Group &Node Color:');                                                                                                                                                                                  
  cxSetResourceString(@sdxGroupFooterColor,'�����ɫ(&G):');
  //tt8//'&Group Footer Color:');                                                                                                                                                                                
  cxSetResourceString(@sdxFooterColor,'ҳ����ɫ(&T):');
  //tt8//'Foo&ter Color:');                                                                                                                                                                                           
  cxSetResourceString(@sdxFixedColor,'�̶���ɫ(&I):');
  //tt8//'F&ixed Color:');                                                                                                                                                                                             
  cxSetResourceString(@sdxGroupColor,'����ɫ(&I):');
  //tt8//'Grou&p Color:');                                                                                                                                                                                               
  cxSetResourceString(@sdxCaptionColor,'������ɫ:');
  //tt8//'Caption Color:');                                                                                                                                                                                              
  cxSetResourceString(@sdxGridLinesColor,'��������ɫ(&D):');
  //tt8//'Gri&d Line Color:');

  cxSetResourceString(@sdxBands,'����(&B)');
  //tt8//'&Bands');                                                                                                                                                                                                              
  cxSetResourceString(@sdxLevelCaptions,'��α���(&C)');
  //tt8//'Levels &Caption');                                                                                                                                                                                         
  cxSetResourceString(@sdxHeaders,'ҳü(&E)');
  //tt8//'H&eaders');                                                                                                                                                                                                          
  cxSetResourceString(@sdxFooters,'ҳ��(&R)');
  //tt8//'Foote&rs');                                                                                                                                                                                                          
  cxSetResourceString(@sdxGroupFooters,'���(&G)');
  //tt8//'&Group Footers');                                                                                                                                                                                               
  cxSetResourceString(@sdxPreview,'Ԥ��(&W)');
  //tt8//'Previe&w');                                                                                                                                                                                                          
  cxSetResourceString(@sdxPreviewLineCount,'Ԥ������(&T):');
  //tt8//'Preview Line Coun&t:');                                                                                                                                                                                
  cxSetResourceString(@sdxAutoCalcPreviewLineCount,'�Զ�����Ԥ������(&U)');
  //tt8//'A&uto Calculate Preview Lines');

  cxSetResourceString(@sdxGrid,'����(&D)');
  //tt8//'Grid Lines');                                                                                                                                                                                                           
  cxSetResourceString(@sdxNodesGrid,'�ڵ�����(&N)');
  //tt8//'Node Grid Lines');                                                                                                                                                                                             
  cxSetResourceString(@sdxGroupFooterGrid,'�������(&P)');
  //tt8//'GroupFooter Grid Lines');                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxStateImages,'״̬ͼ��(&S)');
  //tt8//'&State Images');                                                                                                                                                                                             
  cxSetResourceString(@sdxImages,'ͼ��(&I)');
  //tt8//'&Images'); 

  cxSetResourceString(@sdxTextAlign,'�ı�����(&A)');
  //tt8//'Text&Align');                                                                                                                                                                                                  
  cxSetResourceString(@sdxTextAlignHorz,'ˮƽ(&Z)');
  //tt8//'Hori&zontally');                                                                                                                                                                                               
  cxSetResourceString(@sdxTextAlignVert,'��ֱ(&V)');
  //tt8//'&Vertically');                                                                                                                                                                                                 
  cxSetResourceString(@sdxTextAlignLeft,'����');
  //tt8//'Left');                                                                                                                                                                                                            
  cxSetResourceString(@sdxTextAlignCenter,'����');
  //tt8//'Center');                                                                                                                                                                                                        
  cxSetResourceString(@sdxTextAlignRight,'����');
  //tt8//'Right');                                                                                                                                                                                                          
  cxSetResourceString(@sdxTextAlignTop,'����');
  //tt8//'Top');                                                                                                                                                                                                              
  cxSetResourceString(@sdxTextAlignVCenter,'����');
  //tt8//'Center');                                                                                                                                                                                                       
  cxSetResourceString(@sdxTextAlignBottom,'�ײ�');
  //tt8//'Bottom');                                                                                                                                                                                                        
  cxSetResourceString(@sdxBorderLines,'�߿�����(&B)');
  //tt8//'&Border');                                                                                                                                                                                                   
  cxSetResourceString(@sdxHorzLines,'ˮƽ��(&Z)');
  //tt8//'Hori&zontal Lines');                                                                                                                                                                                             
  cxSetResourceString(@sdxVertLines,'��ֱ��(&V)');
  //tt8//'&Vertical Lines');                                                                                                                                                                                               
  cxSetResourceString(@sdxFixedHorzLines,'�̶�ˮƽ��(&X)');
  //tt8//'Fi&xed Horizontal Lines');                                                                                                                                                                              
  cxSetResourceString(@sdxFixedVertLines,'�̶���ֱ��(&D)');
  //tt8//'Fixe&d Vertical Lines');                                                                                                                                                                                
  cxSetResourceString(@sdxFlatCheckMarks,'ƽ�����(&L)');
  //tt8//'F&lat CheckMarks');                                                                                                                                                                                     
  cxSetResourceString(@sdxCheckMarksAsText,'���ı���ʾ����(&D)');
  //tt8//'&Display CheckMarks as Text');

  cxSetResourceString(@sdxRowAutoHeight,'�Զ������и�(&W)');
  //tt8//'Ro&w AutoHeight');                                                                                                                                                                                     
  cxSetResourceString(@sdxEndEllipsis,'����ʡ�Է�(&E)');
  //tt8//'&EndEllipsis');                                                                                                                                                                                            
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxDrawBorder,'���Ʊ߿�(&D)');
  //tt8//'&Draw Border');                                                                                                                                                                                               
  cxSetResourceString(@sdxFullExpand,'��ȫչ��(&E)');
  //tt8//'Full &Expand');                                                                                                                                                                                               
  cxSetResourceString(@sdxBorderColor,'�߿���ɫ(&B):');
  //tt8//'&Border Color:');                                                                                                                                                                                           
  cxSetResourceString(@sdxAutoNodesExpand,'�Զ�չ���ڵ�(&U)');
  //tt8//'A&uto Nodes Expand');                                                                                                                                                                                
  cxSetResourceString(@sdxExpandLevel,'չ�����(&L):');
  //tt8//'Expand &Level:');                                                                                                                                                                                           
  cxSetResourceString(@sdxFixedRowOnEveryPage,'�̶�ÿҳ����(&E)');
  //tt8//'Fixed Rows');

  cxSetResourceString(@sdxDrawMode,'����ģʽ(&M):');
  //tt8//'Draw &Mode:');                                                                                                                                                                                                 
  cxSetResourceString(@sdxDrawModeStrict,'��ȷ');
  //tt8//'Strict');                                                                                                                                                                                                         
  cxSetResourceString(@sdxDrawModeOddEven,'��/ż��ģʽ');
  //tt8//'Odd/Even Rows Mode');                                                                                                                                                                                     
  cxSetResourceString(@sdxDrawModeChess,'��������ģʽ');
  //tt8//'Chess Mode');                                                                                                                                                                                              
  cxSetResourceString(@sdxDrawModeBorrow,'��Դ����');
  //tt8//'Borrow From Source');                                                                                                                                                                                         
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdx3DEffects,'��άЧ��');
  //tt8//'3D Effects');                                                                                                                                                                                                      
  cxSetResourceString(@sdxUse3DEffects,'ʹ����άЧ��(&3)');
  //tt8//'Use &3D Effects');                                                                                                                                                                                      
  cxSetResourceString(@sdxSoft3D,'�����ά(&3)');
  //tt8//'Sof&t3D');                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxBehaviors,'����');
  //tt8//'Behaviors');                                                                                                                                                                                                           
  cxSetResourceString(@sdxMiscellaneous,'����');
  //tt8//'Miscellaneous');                                                                                                                                                                                                   
  cxSetResourceString(@sdxOnEveryPage,'��ÿҳ');
  //tt8//'On Every Page');                                                                                                                                                                                                   
  cxSetResourceString(@sdxNodeExpanding,'չ���ڵ�');
  //tt8//'Node Expanding');                                                                                                                                                                                              
  cxSetResourceString(@sdxSelection,'ѡ��');
  //tt8//'Selection');                                                                                                                                                                                                           
  cxSetResourceString(@sdxNodeAutoHeight,'�ڵ��Զ������߶�(&N)');
  //tt8//'&Node Auto Height');                                                                                                                                                                              
  cxSetResourceString(@sdxTransparentGraphics,'ͼ��͸��(&T)');
  //tt8//'&Transparent Graphics');                                                                                                                                                                             
  cxSetResourceString(@sdxAutoWidth,'�Զ��������(&W)');
  //tt8//'Auto &Width');                                                                                                                                                                                             
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxDisplayGraphicsAsText,'���ı���ʽ��ʾͼ��(&T)');
  //tt8//'Display Graphic As &Text');                                                                                                                                                              
  cxSetResourceString(@sdxTransparentColumnGraphics,'ͼ��͸��(&G)');
  //tt8//'Transparent &Graphics');                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxBandsOnEveryPage,'ÿҳ��ʾ����');
  //tt8//'Bands');                                                                                                                                                                                                
  cxSetResourceString(@sdxHeadersOnEveryPage,'ÿҳ��ʾҳü');
  //tt8//'Headers');                                                                                                                                                                                            
  cxSetResourceString(@sdxFootersOnEveryPage,'ÿҳ��ʾҳ��');
  //tt8//'Footers');                                                                                                                                                                                            
  cxSetResourceString(@sdxGraphics,'ͼ��');
  //tt8//'&Graphics');

  { Common messages }
  
  cxSetResourceString(@sdxOutOfResources,'��Դ����');
  //tt8//'Out of Resources');                                                                                                                                                                                           
  cxSetResourceString(@sdxFileAlreadyExists,'�ļ� "%s" �Ѿ����ڡ�');
  //tt8//'File "%s" Already Exists.');                                                                                                                                                                   
  cxSetResourceString(@sdxConfirmOverWrite,'�ļ� "%s" �Ѿ����ڡ� ������ ?');
  //tt8//'File "%s" already exists. Overwrite ?');                                                                                                                                               
  cxSetResourceString(@sdxInvalidFileName,'��Ч���ļ��� "%s"');
  //tt8//'Invalid File Name "%s"');                                                                                                                                                                           
  cxSetResourceString(@sdxRequiredFileName,'�����ļ����ơ�');
  //tt8//'Enter file name.'); 
  cxSetResourceString(@sdxOutsideMarginsMessage,
    'One or more margins are set outside the printable area of the page.' + #13#10 +
    'Do you want to continue ?');
  cxSetResourceString(@sdxOutsideMarginsMessage2,
    'One or more margins are set outside the printable area of the page.' + #13#10 +
    'Choose the Fix button to increase the appropriate margins.');
  cxSetResourceString(@sdxInvalidMarginsMessage,
    'One or more margins are set to the invalid values.' + #13#10 +
    'Choose the Fix button to correct this problem.' + #13#10 +
    'Choose the Restore button to restore original values.');
  cxSetResourceString(@sdxInvalidMargins,'һ������ҳ�߾�����Чֵ');
  //tt8//'One or more margins has invalid values');                                                                                                                                                     
  cxSetResourceString(@sdxOutsideMargins,'һ������ҳ�߾೬��ҳ��Ŀɴ�ӡ����');
  //tt8//'One or more margins are set outside the printable area of the page');                                                                                                             
  cxSetResourceString(@sdxThereAreNowItemsForShow,'û����Ŀ');
  //tt8//'There are no items in this view');

  { Color palette }
  
  cxSetResourceString(@sdxPageBackground,' ҳ�汳��');
  //tt8//' Page Background');                                                                                                                                                                                          
  cxSetResourceString(@sdxPenColor,'Ǧ����ɫ');
  //tt8//'Pen Color');                                                                                                                                                                                                        
  cxSetResourceString(@sdxFontColor,'������ɫ');
  //tt8//'Font Color');                                                                                                                                                                                                      
  cxSetResourceString(@sdxBrushColor,'ˢ����ɫ');
  //tt8//'Brush Color');                                                                                                                                                                                                    
  cxSetResourceString(@sdxHighLight,'����');
  //tt8//'HighLight');

  { Color names }
  
  cxSetResourceString(@sdxColorBlack,'��ɫ');
  //tt8//'Black');                                                                                                                                                                                                              
  cxSetResourceString(@sdxColorDarkRed,'���');
  //tt8//'Dark Red');                                                                                                                                                                                                         
  cxSetResourceString(@sdxColorRed,'��ɫ');
  //tt8//'Red');                                                                                                                                                                                                                  
  cxSetResourceString(@sdxColorPink,'�ۺ�');
  //tt8//'Pink');                                                                                                                                                                                                                
  cxSetResourceString(@sdxColorRose,'õ���');
  //tt8//'Rose');                                                                                                                                                                                                              
  cxSetResourceString(@sdxColorBrown,'��ɫ');
  //tt8//'Brown');                                                                                                                                                                                                              
  cxSetResourceString(@sdxColorOrange,'�ۻ�');
  //tt8//'Orange');                                                                                                                                                                                                            
  cxSetResourceString(@sdxColorLightOrange,'ǳ�ۻ�');
  //tt8//'Light Orange');                                                                                                                                                                                               
  cxSetResourceString(@sdxColorGold,'��ɫ');
  //tt8//'Gold');                                                                                                                                                                                                                
  cxSetResourceString(@sdxColorTan,'�ػ�');
  //tt8//'Tan');                                                                                                                                                                                                                  
  cxSetResourceString(@sdxColorOliveGreen,'�����');
  //tt8//'Olive Green');                                                                                                                                                                                                 
  cxSetResourceString(@sdxColorDrakYellow,'���');
  //tt8//'Dark Yellow');                                                                                                                                                                                                   
  cxSetResourceString(@sdxColorLime,'���ɫ');
  //tt8//'Lime');                                                                                                                                                                                                              
  cxSetResourceString(@sdxColorYellow,'��ɫ');
  //tt8//'Yellow');                                                                                                                                                                                                            
  cxSetResourceString(@sdxColorLightYellow,'ǳ��');
  //tt8//'Light Yellow');                                                                                                                                                                                                 
  cxSetResourceString(@sdxColorDarkGreen,'����');
  //tt8//'Dark Green');                                                                                                                                                                                                     
  cxSetResourceString(@sdxColorGreen,'��ɫ');
  //tt8//'Green');                                                                                                                                                                                                              
  cxSetResourceString(@sdxColorSeaGreen,'����');
  //tt8//'Sea Green');                                                                                                                                                                                                       
  cxSetResourceString(@sdxColorBrighthGreen,'����');
  //tt8//'Bright Green');                                                                                                                                                                                                
  cxSetResourceString(@sdxColorLightGreen,'ǳ��');
  //tt8//'Light Green');                                                                                                                                                                                                   
  cxSetResourceString(@sdxColorDarkTeal,'�����');
  //tt8//'Dark Teal');                                                                                                                                                                                                     
  cxSetResourceString(@sdxColorTeal,'��ɫ');
  //tt8//'Teal');                                                                                                                                                                                                                
  cxSetResourceString(@sdxColorAqua,'��ʯ��');
  //tt8//'Aqua');                                                                                                                                                                                                              
  cxSetResourceString(@sdxColorTurquoise,'����');
  //tt8//'Turquoise');                                                                                                                                                                                                      
  cxSetResourceString(@sdxColorLightTurquoise,'ǳ����');
  //tt8//'Light Turquoise');                                                                                                                                                                                         
  cxSetResourceString(@sdxColorDarkBlue,'����');
  //tt8//'Dark Blue');                                                                                                                                                                                                       
  cxSetResourceString(@sdxColorBlue,'��ɫ');
  //tt8//'Blue');                                                                                                                                                                                                                
  cxSetResourceString(@sdxColorLightBlue,'ǳ��');
  //tt8//'Light Blue');                                                                                                                                                                                                     
  cxSetResourceString(@sdxColorSkyBlue,'����');
  //tt8//'Sky Blue');                                                                                                                                                                                                         
  cxSetResourceString(@sdxColorPaleBlue,'����');
  //tt8//'Pale Blue');                                                                                                                                                                                                       
  cxSetResourceString(@sdxColorIndigo,'����');
  //tt8//'Indigo');                                                                                                                                                                                                            
  cxSetResourceString(@sdxColorBlueGray,'��-��');
  //tt8//'Blue Gray');                                                                                                                                                                                                      
  cxSetResourceString(@sdxColorViolet,'��ɫ');
  //tt8//'Violet');                                                                                                                                                                                                            
  cxSetResourceString(@sdxColorPlum,'÷��');
  //tt8//'Plum');                                                                                                                                                                                                                
  cxSetResourceString(@sdxColorLavender,'����');
  //tt8//'Lavender');                                                                                                                                                                                                        
  cxSetResourceString(@sdxColorGray80,'��ɫ-80%');
  //tt8//'Gray-80%');                                                                                                                                                                                                      
  cxSetResourceString(@sdxColorGray50,'��ɫ-50%');
  //tt8//'Gray-50%');                                                                                                                                                                                                      
  cxSetResourceString(@sdxColorGray40,'��ɫ-40%');
  //tt8//'Gray-40%');                                                                                                                                                                                                      
  cxSetResourceString(@sdxColorGray25,'��ɫ-25%');
  //tt8//'Gray-25%');                                                                                                                                                                                                      
  cxSetResourceString(@sdxColorWhite,'��ɫ');
  //tt8//'White');
 
  { FEF Dialog }
  
  cxSetResourceString(@sdxTexture,'����(&T)');
  //tt8//'&Texture');                                                                                                                                                                                                          
  cxSetResourceString(@sdxPattern,'ͼ��(&P)');
  //tt8//'&Pattern');                                                                                                                                                                                                          
  cxSetResourceString(@sdxPicture,'ͼƬ(&I)');
  //tt8//'P&icture');                                                                                                                                                                                                          
  cxSetResourceString(@sdxForeground,'ǰ��(&F)');
  //tt8//'&Foreground');                                                                                                                                                                                                    
  cxSetResourceString(@sdxBackground,'����(&B)');
  //tt8//'&Background');                                                                                                                                                                                                    
  cxSetResourceString(@sdxSample,'ʾ��:');
  //tt8//'Sample:');                                                                                                                                                                                                               
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxFEFCaption,'���Ч��');
  //tt8//'Fill Effects');                                                                                                                                                                                                   
  cxSetResourceString(@sdxPaintMode,'��ͼģʽ');
  //tt8//'Paint &Mode');                                                                                                                                                                                                     
  cxSetResourceString(@sdxPaintModeCenter,'����');
  //tt8//'Center');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPaintModeStretch,'����');
  //tt8//'Stretch');                                                                                                                                                                                                      
  cxSetResourceString(@sdxPaintModeTile,'ƽ��');
  //tt8//'Tile');                                                                                                                                                                                                            
  cxSetResourceString(@sdxPaintModeProportional,'��������');
  //tt8//'Proportional');                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  { Pattern names }                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPatternGray5,'5%');
  //tt8//'5%');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxPatternGray10,'10%');
  //tt8//'10%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray20,'20%');
  //tt8//'20%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray25,'25%');
  //tt8//'25%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray30,'30%');
  //tt8//'30%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray40,'40%');
  //tt8//'40%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray50,'50%');
  //tt8//'50%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray60,'60%');
  //tt8//'60%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray70,'70%');
  //tt8//'70%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray75,'75%');
  //tt8//'75%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray80,'80%');
  //tt8//'80%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternGray90,'90%');
  //tt8//'90%');                                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternLightDownwardDiagonal,'ǳɫ�¶Խ���');
  //tt8//'Light downward diagonal');                                                                                                                                                                  
  cxSetResourceString(@sdxPatternLightUpwardDiagonal,'ǳɫ�϶Խ���');
  //tt8//'Light upward diagonal');                                                                                                                                                                      
  cxSetResourceString(@sdxPatternDarkDownwardDiagonal,'��ɫ�¶Խ���');
  //tt8//'Dark downward diagonal');                                                                                                                                                                    
  cxSetResourceString(@sdxPatternDarkUpwardDiagonal,'��ɫ�϶Խ���');
  //tt8//'Dark upward diagonal');                                                                                                                                                                        
  cxSetResourceString(@sdxPatternWideDownwardDiagonal,'���¶Խ���');
  //tt8//'Wide downward diagonal');                                                                                                                                                                      
  cxSetResourceString(@sdxPatternWideUpwardDiagonal,'���϶Խ���');
  //tt8//'Wide upward diagonal');                                                                                                                                                                          
  cxSetResourceString(@sdxPatternLightVertical,'ǳɫ����');
  //tt8//'Light vertical');                                                                                                                                                                                       
  cxSetResourceString(@sdxPatternLightHorizontal,'ǳɫ����');
  //tt8//'Light horizontal');                                                                                                                                                                                   
  cxSetResourceString(@sdxPatternNarrowVertical,'խ����');
  //tt8//'Narrow vertical');                                                                                                                                                                                       
  cxSetResourceString(@sdxPatternNarrowHorizontal,'խ����');
  //tt8//'Narrow horizontal');                                                                                                                                                                                   
  cxSetResourceString(@sdxPatternDarkVertical,'��ɫ����');
  //tt8//'Dark vertical');                                                                                                                                                                                         
  cxSetResourceString(@sdxPatternDarkHorizontal,'��ɫ����');
  //tt8//'Dark horizontal');                                                                                                                                                                                     
  cxSetResourceString(@sdxPatternDashedDownward,'�¶Խ�����');
  //tt8//'Dashed downward');                                                                                                                                                                                   
  cxSetResourceString(@sdxPatternDashedUpward,'�϶Խ�����');
  //tt8//'Dashed upward');                                                                                                                                                                                       
  cxSetResourceString(@sdxPatternDashedVertical,'������');
  //tt8//'Dashed vertical');                                                                                                                                                                                       
  cxSetResourceString(@sdxPatternDashedHorizontal,'������');
  //tt8//'Dashed horizontal');                                                                                                                                                                                   
  cxSetResourceString(@sdxPatternSmallConfetti,'Сֽм');
  //tt8//'Small confetti');                                                                                                                                                                                         
  cxSetResourceString(@sdxPatternLargeConfetti,'��ֽм');
  //tt8//'Large confetti');                                                                                                                                                                                         
  cxSetResourceString(@sdxPatternZigZag,'֮����');
  //tt8//'Zig zag');                                                                                                                                                                                                       
  cxSetResourceString(@sdxPatternWave,'������');
  //tt8//'Wave');                                                                                                                                                                                                            
  cxSetResourceString(@sdxPatternDiagonalBrick,'�Խ�ש��');
  //tt8//'Diagonal brick');                                                                                                                                                                                       
  cxSetResourceString(@sdxPatternHorizantalBrick,'����ש��');
  //tt8//'Horizontal brick');                                                                                                                                                                                   
  cxSetResourceString(@sdxPatternWeave,'��֯��');
  //tt8//'Weave');                                                                                                                                                                                                          
  cxSetResourceString(@sdxPatternPlaid,'�ո���������');
  //tt8//'Plaid');                                                                                                                                                                                                    
  cxSetResourceString(@sdxPatternDivot,'��Ƥ');
  //tt8//'Divot');                                                                                                                                                                                                            
  cxSetResourceString(@sdxPatternDottedGrid,'��������');
  //tt8//'Dottedgrid');                                                                                                                                                                                              
  cxSetResourceString(@sdxPatternDottedDiamond,'��ʽ����');
  //tt8//'Dotted diamond');                                                                                                                                                                                       
  cxSetResourceString(@sdxPatternShingle,'����');
  //tt8//'Shingle');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPatternTrellis,'���');
  //tt8//'Trellis');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPatternSphere,'����');
  //tt8//'Sphere');                                                                                                                                                                                                          
  cxSetResourceString(@sdxPatternSmallGrid,'С����');
  //tt8//'Small grid');                                                                                                                                                                                                 
  cxSetResourceString(@sdxPatternLargeGrid,'������');
  //tt8//'Large grid');                                                                                                                                                                                                 
  cxSetResourceString(@sdxPatternSmallCheckedBoard,'С����');
  //tt8//'Small checked board');                                                                                                                                                                                
  cxSetResourceString(@sdxPatternLargeCheckedBoard,'������');
  //tt8//'Large checked board');                                                                                                                                                                                
  cxSetResourceString(@sdxPatternOutlinedDiamond,'����ʽ����');
  //tt8//'Outlined diamond');                                                                                                                                                                                 
  cxSetResourceString(@sdxPatternSolidDiamond,'ʵ������');
  //tt8//'Solid diamond');                                                                                                                                                                                         
                                                                                                                                                                                                                                                          
  { Texture names }                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxTextureNewSprint,'����ֽ');
  //tt8//'Newsprint');                                                                                                                                                                                                  
  cxSetResourceString(@sdxTextureGreenMarble,'��ɫ����ʯ');
  //tt8//'Green marble');                                                                                                                                                                                         
  cxSetResourceString(@sdxTextureBlueTissuePaper,'��ɫɰֽ');
  //tt8//'Blue tissue paper');                                                                                                                                                                                  
  cxSetResourceString(@sdxTexturePapyrus,'ֽɯ��ֽ');
  //tt8//'Papyrus');                                                                                                                                                                                                    
  cxSetResourceString(@sdxTextureWaterDroplets,'ˮ��');
  //tt8//'Water droplets');                                                                                                                                                                                           
  cxSetResourceString(@sdxTextureCork,'��ľ��');
  //tt8//'Cork');                                                                                                                                                                                                            
  cxSetResourceString(@sdxTextureRecycledPaper,'����ֽ');
  //tt8//'Recycled paper');                                                                                                                                                                                         
  cxSetResourceString(@sdxTextureWhiteMarble,'��ɫ����ʯ');
  //tt8//'White marble');                                                                                                                                                                                         
  cxSetResourceString(@sdxTexturePinkMarble,'��ɫɰֽ');
  //tt8//'Pink marble');                                                                                                                                                                                             
  cxSetResourceString(@sdxTextureCanvas,'����');
  //tt8//'Canvas');                                                                                                                                                                                                          
  cxSetResourceString(@sdxTexturePaperBag,'ֽ��');
  //tt8//'Paper bag');                                                                                                                                                                                                     
  cxSetResourceString(@sdxTextureWalnut,'����');
  //tt8//'Walnut');                                                                                                                                                                                                          
  cxSetResourceString(@sdxTextureParchment,'��Ƥֽ');
  //tt8//'Parchment');                                                                                                                                                                                                  
  cxSetResourceString(@sdxTextureBrownMarble,'��ɫ����ʯ');
  //tt8//'Brown marble');                                                                                                                                                                                         
  cxSetResourceString(@sdxTexturePurpleMesh,'��ɫ����');
  //tt8//'Purple mesh');                                                                                                                                                                                             
  cxSetResourceString(@sdxTextureDenim,'б�Ʋ�');
  //tt8//'Denim');                                                                                                                                                                                                          
  cxSetResourceString(@sdxTextureFishFossil,'���໯ʯ');
  //tt8//'Fish fossil');                                                                                                                                                                                             
  cxSetResourceString(@sdxTextureOak,'��ľ');
  //tt8//'Oak');                                                                                                                                                                                                                
  cxSetResourceString(@sdxTextureStationary,'��ֽ');
  //tt8//'Stationary');                                                                                                                                                                                                  
  cxSetResourceString(@sdxTextureGranite,'������');
  //tt8//'Granite');                                                                                                                                                                                                      
  cxSetResourceString(@sdxTextureBouquet,'����');
  //tt8//'Bouquet');                                                                                                                                                                                                        
  cxSetResourceString(@sdxTextureWonenMat,'��֯��');
  //tt8//'Woven mat');                                                                                                                                                                                                   
  cxSetResourceString(@sdxTextureSand,'ɳ̲');
  //tt8//'Sand');                                                                                                                                                                                                              
  cxSetResourceString(@sdxTextureMediumWood,'��ɫľ��');
  //tt8//'Medium wood');                                                                                                                                                                                             
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxFSPCaption,'ͼ��Ԥ��');
  //tt8//'Picture Preview');                                                                                                                                                                                                
  cxSetResourceString(@sdxWidth,'���');
  //tt8//'Width');                                                                                                                                                                                                                   
  cxSetResourceString(@sdxHeight,'�߶�');
  //tt8//'Height');                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                          
  { Brush Dialog }                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxBrushDlgCaption,'��������');
  //tt8//'Brush properties');                                                                                                                                                                                          
  cxSetResourceString(@sdxStyle,'��ʽ:');
  //tt8//'&Style:');                                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  { Enter New File Name dialog }                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxENFNCaption,'ѡ�����ļ�����');
  //tt8//'Choose New File Name');                                                                                                                                                                                    
  cxSetResourceString(@sdxEnterNewFileName,'�������ļ�����');
  //tt8//'Enter New File Name');                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  { Define styles dialog }                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxDefinePrintStylesCaption,'�����ӡ��ʽ');
  //tt8//'Define Print Styles');                                                                                                                                                                          
  cxSetResourceString(@sdxDefinePrintStylesTitle,'��ӡ��ʽ(&S)');
  //tt8//'Print &Styles');                                                                                                                                                                                  
  cxSetResourceString(@sdxDefinePrintStylesWarningDelete,'ȷ��Ҫɾ�� "%s" ��?');
  //tt8//'Do you want to delete "%s" ?');                                                                                                                                                    
  cxSetResourceString(@sdxDefinePrintStylesWarningClear,'Ҫɾ�����з�������ʽ��?');
  //tt8//'Do you want to delete all not built-in styles ?');                                                                                                                              
  cxSetResourceString(@sdxClear,'���(&L)...');
  //tt8//'C&lear...');                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  { Print device }                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCustomSize,'�Զ����С');
  //tt8//'Custom Size');                                                                                                                                                                                                  
  cxSetResourceString(@sdxDefaultTray,'Ĭ��ֽ��');
  //tt8//'Default Tray');                                                                                                                                                                                                  
  cxSetResourceString(@sdxInvalidPrintDevice,'��ѡ��ӡ����Ч');
  //tt8//'Printer selected is not valid');                                                                                                                                                                    
  cxSetResourceString(@sdxNotPrinting,'��ǰ��ӡ������ӡ');
  //tt8//'Printer is not currently printing');                                                                                                                                                                     
  cxSetResourceString(@sdxPrinting,'���ڴ�ӡ');
  //tt8//'Printing in progress');                                                                                                                                                                                             
  cxSetResourceString(@sdxDeviceOnPort,'%s �� %s');
  //tt8//'%s on %s');                                                                                                                                                                                                     
  cxSetResourceString(@sdxPrinterIndexError,'��ӡ������������Χ');
  //tt8//'Printer index out of range');                                                                                                                                                                    
  cxSetResourceString(@sdxNoDefaultPrintDevice,'û��ѡ��Ĭ�ϴ�ӡ��');
  //tt8//'There is no default printer selected');                                                                                                                                                       
                                                                                                                                                                                                                                                          
  { Edit AutoText Entries Dialog }                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxAutoTextDialogCaption,'�༭�Զ�ͼ�ļ�');
  //tt8//'Edit AutoText Entries');                                                                                                                                                                         
  cxSetResourceString(@sdxEnterAutoTextEntriesHere,'�����Զ�ͼ�ļ���');
  //tt8//' Enter A&utoText Entries Here: ');                                                                                                                                                          
                                                                                                                                                                                                                                                          
  { Print dialog }                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPrintDialogCaption,'��ӡ');
  //tt8//'Print');                                                                                                                                                                                                      
  cxSetResourceString(@sdxPrintDialogPrinter,'��ӡ��');
  //tt8//' Printer ');                                                                                                                                                                                                
  cxSetResourceString(@sdxPrintDialogName,'����(&N):');
  //tt8//'&Name:');                                                                                                                                                                                                   
  cxSetResourceString(@sdxPrintDialogStatus,'״̬:');
  //tt8//'Status:');                                                                                                                                                                                                    
  cxSetResourceString(@sdxPrintDialogType,'����:');
  //tt8//'Type:');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPrintDialogWhere,'λ��:');
  //tt8//'Where:');                                                                                                                                                                                                      
  cxSetResourceString(@sdxPrintDialogComment,'��ע:');
  //tt8//'Comment:');                                                                                                                                                                                                  
  cxSetResourceString(@sdxPrintDialogPrintToFile,'��ӡ���ļ�(&F)');
  //tt8//'Print to &File');                                                                                                                                                                               
  cxSetResourceString(@sdxPrintDialogPageRange,' ҳ�淶Χ ');
  //tt8//' Page range ');                                                                                                                                                                                       
  cxSetResourceString(@sdxPrintDialogAll,'ȫ��(&A)');
  //tt8//'&All');                                                                                                                                                                                                       
  cxSetResourceString(@sdxPrintDialogCurrentPage,'��ǰҳ(&E)');
  //tt8//'Curr&ent Page');                                                                                                                                                                                    
  cxSetResourceString(@sdxPrintDialogSelection,'��ѡ����(&S)');
  //tt8//'&Selection');                                                                                                                                                                                       
  cxSetResourceString(@sdxPrintDialogPages,'ҳ�뷶Χ:');
  //tt8//'&Pages:');                                                                                                                                                                                                 
  cxSetResourceString(@sdxPrintDialogRangeLegend,'�����ҳ���/���ö��ŷָ���ҳ�뷶Χ'+#10#13+
  //tt8//'Enter page number and/or page ranges' + #10#13 +                                                                                                                   
    'separated by commas. For example: 1,3,5-12.');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPrintDialogCopies,' ����');
  //tt8//' Copies ');                                                                                                                                                                                                   
  cxSetResourceString(@sdxPrintDialogNumberOfPages,'ҳ��(&U):');
  //tt8//'N&umber of Pages:');                                                                                                                                                                               
  cxSetResourceString(@sdxPrintDialogNumberOfCopies,'����(&C):');
  //tt8//'Number of &Copies:');                                                                                                                                                                             
  cxSetResourceString(@sdxPrintDialogCollateCopies,'��ݴ�ӡ(&T)');
  //tt8//'Colla&te Copies');                                                                                                                                                                              
  cxSetResourceString(@sdxPrintDialogAllPages,'ȫ��');
  //tt8//'All');                                                                                                                                                                                                       
  cxSetResourceString(@sdxPrintDialogEvenPages,'ż��ҳ');
  //tt8//'Even');                                                                                                                                                                                                   
  cxSetResourceString(@sdxPrintDialogOddPages,'����ҳ');
  //tt8//'Odd');                                                                                                                                                                                                     
  cxSetResourceString(@sdxPrintDialogPrintStyles,' ��ӡ��ʽ(&Y)');
  //tt8//' Print St&yles ');                                                                                                                                                                               
                                                                                                                                                                                                                                                          
  { PrintToFile Dialog }                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPrintDialogOpenDlgTitle,'ѡ���ļ�����');
  //tt8//'Choose File Name');                                                                                                                                                                              
  cxSetResourceString(@sdxPrintDialogOpenDlgAllFiles,'ȫ���ļ�');
  //tt8//'All Files');                                                                                                                                                                                      
  cxSetResourceString(@sdxPrintDialogOpenDlgPrinterFiles,'��ӡ���ļ�');
  //tt8//'Printer Files');                                                                                                                                                                            
  cxSetResourceString(@sdxPrintDialogPageNumbersOutOfRange,'ҳ�볬����Χ (%d - %d)');
  //tt8//'Page numbers out of range (%d - %d)');                                                                                                                                        
  cxSetResourceString(@sdxPrintDialogInvalidPageRanges,'��Ч��ҳ�뷶Χ');
  //tt8//'Invalid page ranges');                                                                                                                                                                    
  cxSetResourceString(@sdxPrintDialogRequiredPageNumbers,'����ҳ��');
  //tt8//'Enter page numbers');                                                                                                                                                                         
  cxSetResourceString(@sdxPrintDialogNoPrinters,'û�а�װ��ӡ���� Ҫ��װ��ӡ����'+
  //tt8//'No printers are installed. To install a printer, ' +                                                                                                                           
    'point to Settings on the Windows Start menu, click Printers, and then double-click Add Printer. ' +                                                                                                                                                  
    'Follow the instructions in the wizard.');                                                                                                                                                                                                             
  cxSetResourceString(@sdxPrintDialogInPrintingState,'��ӡ�����ڴ�ӡ��'+#10#13+
  //tt8//'Printer is currently printing.' + #10#13 +                                                                                                                                        
    'Please wait.');                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  { Printer State }                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPrintDialogPSPaused,'��ͣ');
  //tt8//'Paused');                                                                                                                                                                                                    
  cxSetResourceString(@sdxPrintDialogPSPendingDeletion,'����ɾ��');
  //tt8//'Pending Deletion');                                                                                                                                                                             
  cxSetResourceString(@sdxPrintDialogPSBusy,'��æ');
  //tt8//'Busy');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPrintDialogPSDoorOpen,'ͨ����');
  //tt8//'Door Open');                                                                                                                                                                                           
  cxSetResourceString(@sdxPrintDialogPSError,'����');
  //tt8//'Error');                                                                                                                                                                                                      
  cxSetResourceString(@sdxPrintDialogPSInitializing,'��ʼ��');
  //tt8//'Initializing');                                                                                                                                                                                      
  cxSetResourceString(@sdxPrintDialogPSIOActive,'���������Ч');
  //tt8//'IO Active');                                                                                                                                                                                       
  cxSetResourceString(@sdxPrintDialogPSManualFeed,'�ֹ���ֽ');
  //tt8//'Manual Feed');                                                                                                                                                                                       
  cxSetResourceString(@sdxPrintDialogPSNoToner,'û��ī��');
  //tt8//'No Toner');                                                                                                                                                                                             
  cxSetResourceString(@sdxPrintDialogPSNotAvailable,'������');
  //tt8//'Not Available');                                                                                                                                                                                     
  cxSetResourceString(@sdxPrintDialogPSOFFLine,'�ѻ�');
  //tt8//'Offline');                                                                                                                                                                                                  
  cxSetResourceString(@sdxPrintDialogPSOutOfMemory,'�ڴ����');
  //tt8//'Out of Memory');                                                                                                                                                                                    
  cxSetResourceString(@sdxPrintDialogPSOutBinFull,'�������������');
  //tt8//'Output Bin Full');                                                                                                                                                                             
  cxSetResourceString(@sdxPrintDialogPSPagePunt,'ҳƽ��');
  //tt8//'Page Punt');                                                                                                                                                                                             
  cxSetResourceString(@sdxPrintDialogPSPaperJam,'��ֽ');
  //tt8//'Paper Jam');                                                                                                                                                                                               
  cxSetResourceString(@sdxPrintDialogPSPaperOut,'ֽ������');
  //tt8//'Paper Out');                                                                                                                                                                                           
  cxSetResourceString(@sdxPrintDialogPSPaperProblem,'ֽ������');
  //tt8//'Paper Problem');                                                                                                                                                                                   
  cxSetResourceString(@sdxPrintDialogPSPrinting,'���ڴ�ӡ');
  //tt8//'Printing');                                                                                                                                                                                            
  cxSetResourceString(@sdxPrintDialogPSProcessing,'���ڴ���');
  //tt8//'Processing');                                                                                                                                                                                        
  cxSetResourceString(@sdxPrintDialogPSTonerLow,'ī�۽���');
  //tt8//'Toner Low');                                                                                                                                                                                           
  cxSetResourceString(@sdxPrintDialogPSUserIntervention,'���û�����');
  //tt8//'User Intervention');                                                                                                                                                                         
  cxSetResourceString(@sdxPrintDialogPSWaiting,'���ڵȴ�');
  //tt8//'Waiting');                                                                                                                                                                                              
  cxSetResourceString(@sdxPrintDialogPSWarningUp,'����Ԥ��');
  //tt8//'Warming Up');                                                                                                                                                                                         
  cxSetResourceString(@sdxPrintDialogPSReady,'����');
  //tt8//'Ready');                                                                                                                                                                                                      
  cxSetResourceString(@sdxPrintDialogPSPrintingAndWaiting,'���ڴ�ӡ��%d document(s)  ��ȴ�');
  //tt8//'Printing: %d document(s) waiting');                                                                                                                                  
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxLeftMargin,'��߾�');
  //tt8//'Left Margin');                                                                                                                                                                                                      
  cxSetResourceString(@sdxTopMargin,'�ϱ߾�');
  //tt8//'Top Margin');                                                                                                                                                                                                        
  cxSetResourceString(@sdxRightMargin,'�ұ߾�');
  //tt8//'Right Margin');                                                                                                                                                                                                    
  cxSetResourceString(@sdxBottomMargin,'�±߾�');
  //tt8//'Bottom Margin');                                                                                                                                                                                                  
  cxSetResourceString(@sdxGutterMargin,'װ����');
  //tt8//'Gutter');                                                                                                                                                                                                         
  cxSetResourceString(@sdxHeaderMargin,'ҳü');
  //tt8//'Header');                                                                                                                                                                                                           
  cxSetResourceString(@sdxFooterMargin,'ҳ��');
  //tt8//'Footer');                                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxUnitsInches,'"');
  //tt8//'"');                                                                                                                                                                                                                    
  cxSetResourceString(@sdxUnitsCentimeters,'����');
  //tt8//'cm');                                                                                                                                                                                                           
  cxSetResourceString(@sdxUnitsMillimeters,'����');
  //tt8//'mm');                                                                                                                                                                                                           
  cxSetResourceString(@sdxUnitsPoints,'��');
  //tt8//'pt');                                                                                                                                                                                                                  
  cxSetResourceString(@sdxUnitsPicas,'����');
  //tt8//'pi');                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxUnitsDefaultName,'Ĭ��');
  //tt8//'Default');                                                                                                                                                                                                      
  cxSetResourceString(@sdxUnitsInchesName,'Ӣ��');
  //tt8//'Inches');                                                                                                                                                                                                        
  cxSetResourceString(@sdxUnitsCentimetersName,'����');
  //tt8//'Centimeters');                                                                                                                                                                                              
  cxSetResourceString(@sdxUnitsMillimetersName,'����');
  //tt8//'Millimeters');                                                                                                                                                                                              
  cxSetResourceString(@sdxUnitsPointsName,'��');
  //tt8//'Points');                                                                                                                                                                                                          
  cxSetResourceString(@sdxUnitsPicasName,'�ɿ�');
  //tt8//'Picas');                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPrintPreview,'��ӡԤ��');
  //tt8//'Print Preview');                                                                                                                                                                                                
  cxSetResourceString(@sdxReportDesignerCaption,'�������');
  //tt8//'Format Report');                                                                                                                                                                                       
  cxSetResourceString(@sdxCompositionDesignerCaption,'�������');
  //tt8//'Composition Editor');                                                                                                                                                                             
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxComponentNotSupportedByLink,'��� "%s" ������ӡ���֧��');
  //tt8//'Component "%s" not supported by TdxComponentPrinter');                                                                                                                         
  cxSetResourceString(@sdxComponentNotSupported,'��� "%s" ������ӡ���֧��');
  //tt8//'Component "%s" not supported by TdxComponentPrinter');                                                                                                                               
  cxSetResourceString(@sdxPrintDeviceNotReady,'��ӡ����δ��װ����û�о���');
  //tt8//'Printer has not been installed or is not ready');                                                                                                                                      
  cxSetResourceString(@sdxUnableToGenerateReport,'���ܲ�������');
  //tt8//'Unable to generate report');                                                                                                                                                                      
  cxSetResourceString(@sdxPreviewNotRegistered,'û����ע���Ԥ����');
  //tt8//'There is no registered preview form');                                                                                                                                                      
  cxSetResourceString(@sdxComponentNotAssigned,'%s' + #13#10 + 'û��ָ���������');
  //tt8//'%s' + #13#10 + 'Not assigned "Component" property');                                                                                                                            
  cxSetResourceString(@sdxPrintDeviceIsBusy,'��ӡ����æ');
  //tt8//'Printer is busy');                                                                                                                                                                                       
  cxSetResourceString(@sdxPrintDeviceError,'��ӡ������!');
  //tt8//'Printer has encountered error !');                                                                                                                                                                       
  cxSetResourceString(@sdxMissingComponent,'ȱ���������');
  //tt8//'Missing "Component" property');                                                                                                                                                                         
  cxSetResourceString(@sdxDataProviderDontPresent,'�ڲ�����û��ָ�����ӵ����');
  //tt8//'There are no Links with Assigned Component in Composition');                                                                                                                       
  cxSetResourceString(@sdxBuildingReport,'������������� %d%%');
  //tt8//'Building report: Completed %d%%');                            // obsolete                                                                                                                        
  cxSetResourceString(@sdxPrintingReport,'���ڴ�ӡ��������� %d ҳ�� ��ESC���ж�...');
  //tt8//'Printing report: Completed %d page(s). Press Esc to cancel'); // obsolete                                                                                                  
  cxSetResourceString(@sdxDefinePrintStylesMenuItem,'�����ӡ��ʽ(&S)...');
  //tt8//'Define Print &Styles...');                                                                                                                                                              
  cxSetResourceString(@sdxAbortPrinting,'Ҫ�жϴ�ӡ��?');
  //tt8//'Abort printing ?');                                                                                                                                                                                       
  cxSetResourceString(@sdxStandardStyle,'��׼��ʽ');
  //tt8//'Standard Style');                                                                                                                                                                                              
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxFontStyleBold,'����');
  //tt8//'Bold');                                                                                                                                                                                                            
  cxSetResourceString(@sdxFontStyleItalic,'б��');
  //tt8//'Italic');                                                                                                                                                                                                        
  cxSetResourceString(@sdxFontStyleUnderline,'�»���');
  //tt8//'Underline');                                                                                                                                                                                                
  cxSetResourceString(@sdxFontStyleStrikeOut,'ɾ����');
  //tt8//'StrikeOut');                                                                                                                                                                                                
  cxSetResourceString(@sdxPt,'��');
  //tt8//'pt.');                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxNoPages,'[û��ҳ��]');
  //tt8//'There are no pages to display');                                                                                                                                                                                   
  cxSetResourceString(@sdxPageWidth,'ҳ��');
  //tt8//'Page Width');                                                                                                                                                                                                          
  cxSetResourceString(@sdxWholePage,'��ҳ');
  //tt8//'Whole Page');                                                                                                                                                                                                          
  cxSetResourceString(@sdxTwoPages,'��ҳ');
  //tt8//'Two Pages');                                                                                                                                                                                                            
  cxSetResourceString(@sdxFourPages,'��ҳ');
  //tt8//'Four Pages');                                                                                                                                                                                                          
  cxSetResourceString(@sdxWidenToSourceWidth,'ԭʼ���');
  //tt8//'Widen to Source Width');                                                                                                                                                                                  
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuBar,'�˵���');
  //tt8//'MenuBar');                                                                                                                                                                                                             
  cxSetResourceString(@sdxStandardBar,'��׼');
  //tt8//'Standard');                                                                                                                                                                                                          
  cxSetResourceString(@sdxHeaderFooterBar,'ҳü��ҳ��');
  //tt8//'Header and Footer');                                                                                                                                                                                       
  cxSetResourceString(@sdxShortcutMenusBar,'��ݲ˵�');
  //tt8//'Shortcut Menus');                                                                                                                                                                                           
  cxSetResourceString(@sdxAutoTextBar,'�Զ�ͼ�ļ�');
  //tt8//'AutoText');                                                                                                                                                                                                    
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuFile,'�ļ�(&F)');
  //tt8//'&File');                                                                                                                                                                                                            
  cxSetResourceString(@sdxMenuFileDesign,'���(&D)...');
  //tt8//'&Design...');                                                                                                                                                                                              
  cxSetResourceString(@sdxMenuFilePrint,'��ӡ(&P)...');
  //tt8//'&Print...');                                                                                                                                                                                                
  cxSetResourceString(@sdxMenuFilePageSetup,'ҳ������(&U)...');
  //tt8//'Page Set&up...');                                                                                                                                                                                   
  cxSetResourceString(@sdxMenuPrintStyles,'��ӡ��ʽ');
  //tt8//'Print Styles');                                                                                                                                                                                              
  cxSetResourceString(@sdxMenuFileExit,'�ر�(&C)');
  //tt8//'&Close');                                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuEdit,'�༭(&E)');
  //tt8//'&Edit');                                                                                                                                                                                                            
  cxSetResourceString(@sdxMenuEditCut,'����(&T)');
  //tt8//'Cu&t');                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuEditCopy,'����(&C)');
  //tt8//'&Copy');                                                                                                                                                                                                        
  cxSetResourceString(@sdxMenuEditPaste,'ճ��(&P)');
  //tt8//'&Paste');                                                                                                                                                                                                      
  cxSetResourceString(@sdxMenuEditDelete,'ɾ��(&D)');
  //tt8//'&Delete');                                                                                                                                                                                                    
  cxSetResourceString(@sdxMenuEditFind,'����(&F)...');
  //tt8//'&Find...');                                                                                                                                                                                                  
  cxSetResourceString(@sdxMenuEditFindNext,'������һ��(&X)');
  //tt8//'Find Ne&xt');                                                                                                                                                                                         
  cxSetResourceString(@sdxMenuEditReplace,'�滻(&R)...');
  //tt8//'&Replace...');                                                                                                                                                                                            
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuLoad,'����(&L)...');
  //tt8//'&Load...');                                                                                                                                                                                                      
  cxSetResourceString(@sdxMenuPreview,'Ԥ��(&V)...');
  //tt8//'Pre&view...');                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuInsert,'����(&I)');
  //tt8//'&Insert');                                                                                                                                                                                                        
  cxSetResourceString(@sdxMenuInsertAutoText,'�Զ�ͼ�ļ�(&A)');
  //tt8//'&AutoText');                                                                                                                                                                                        
  cxSetResourceString(@sdxMenuInsertEditAutoTextEntries,'�Զ�ͼ�ļ�(&X)...');
  //tt8//'AutoTe&xt...');                                                                                                                                                                       
  cxSetResourceString(@sdxMenuInsertAutoTextEntries,'�Զ�ͼ�ļ��б�');
  //tt8//'List of AutoText Entries');                                                                                                                                                                  
  cxSetResourceString(@sdxMenuInsertAutoTextEntriesSubItem,'�����Զ�ͼ�ļ�(&S)');
  //tt8//'In&sert AutoText');                                                                                                                                                               
  cxSetResourceString(@sdxMenuInsertPageNumber,'ҳ��(&P)');
  //tt8//'&Page Number');                                                                                                                                                                                         
  cxSetResourceString(@sdxMenuInsertTotalPages,'ҳ��(&N)');
  //tt8//'&Number of Pages');                                                                                                                                                                                     
  cxSetResourceString(@sdxMenuInsertPageOfPages,'ҳ��ҳ��(&G)');
  //tt8//'Pa&ge Number of Pages');                                                                                                                                                                           
  cxSetResourceString(@sdxMenuInsertDateTime,'���ں�ʱ��');
  //tt8//'Date and Time');                                                                                                                                                                                        
  cxSetResourceString(@sdxMenuInsertDate,'����(&D)');
  //tt8//'&Date');                                                                                                                                                                                                      
  cxSetResourceString(@sdxMenuInsertTime,'ʱ��(&T)');
  //tt8//'&Time');                                                                                                                                                                                                      
  cxSetResourceString(@sdxMenuInsertUserName,'�û�����(&U)');
  //tt8//'&User Name');                                                                                                                                                                                         
  cxSetResourceString(@sdxMenuInsertMachineName,'��������(&M)');
  //tt8//'&Machine Name');                                                                                                                                                                                   
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuView,'��ͼ(&V)');
  //tt8//'&View');                                                                                                                                                                                                            
  cxSetResourceString(@sdxMenuViewMargins,'ҳ�߾�(&M)');
  //tt8//'&Margins');                                                                                                                                                                                                
  cxSetResourceString(@sdxMenuViewFlatToolBarButtons,'ƽ�湤������ť');
  //tt8//'&Flat ToolBar Buttons');                                                                                                                                                                    
  cxSetResourceString(@sdxMenuViewLargeToolBarButtons,'�󹤾�����ť');
  //tt8//'&Large ToolBar Buttons');                                                                                                                                                                    
  cxSetResourceString(@sdxMenuViewMarginsStatusBar,'ҳ�߾���');
  //tt8//'M&argins Bar');                                                                                                                                                                                     
  cxSetResourceString(@sdxMenuViewPagesStatusBar,'״̬��');
  //tt8//'&Status Bar');                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuViewToolBars,'������');
  //tt8//'&Toolbars');                                                                                                                                                                                                  
  cxSetResourceString(@sdxMenuViewPagesHeaders,'ҳü');
  //tt8//'Page &Headers');                                                                                                                                                                                            
  cxSetResourceString(@sdxMenuViewPagesFooters,'ҳ��');
  //tt8//'Page Foote&rs');                                                                                                                                                                                            
  cxSetResourceString(@sdxMenuViewSwitchToLeftPart,'�л�����');
  //tt8//'Switch to Left Part');                                                                                                                                                                            
  cxSetResourceString(@sdxMenuViewSwitchToRightPart,'�л����Ҳ�');
  //tt8//'Switch to Right Part');                                                                                                                                                                          
  cxSetResourceString(@sdxMenuViewSwitchToCenterPart,'�л����в�');
  //tt8//'Switch to Center Part');                                                                                                                                                                        
  cxSetResourceString(@sdxMenuViewHFSwitchHeaderFooter,'��ʾҳü/ҳ��(&S)');
  //tt8//'&Show Header/Footer');                                                                                                                                                                 
  cxSetResourceString(@sdxMenuViewHFClose,'�ر�(&C)');
  //tt8//'&Close');                                                                                                                                                                                                    
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuZoom,'����(&Z)');
  //tt8//'&Zoom');                                                                                                                                                                                                            
  cxSetResourceString(@sdxMenuZoomPercent100,'�ٷ�&100');
  //tt8//'Percent &100');                                                                                                                                                                                           
  cxSetResourceString(@sdxMenuZoomPageWidth,'ҳ��(&W)');
  //tt8//'Page &Width');                                                                                                                                                                                             
  cxSetResourceString(@sdxMenuZoomWholePage,'��ҳ(&H)');
  //tt8//'W&hole Page');                                                                                                                                                                                             
  cxSetResourceString(@sdxMenuZoomTwoPages,'��ҳ(&T)');
  //tt8//'&Two Pages');                                                                                                                                                                                               
  cxSetResourceString(@sdxMenuZoomFourPages,'��ҳ(&F)');
  //tt8//'&Four Pages');                                                                                                                                                                                             
  cxSetResourceString(@sdxMenuZoomMultiplyPages,'��ҳ(&M)');
  //tt8//'&Multiple Pages');                                                                                                                                                                                     
  cxSetResourceString(@sdxMenuZoomWidenToSourceWidth,'��չ��ԭʼ���');
  //tt8//'Widen To S&ource Width');                                                                                                                                                                   
  cxSetResourceString(@sdxMenuZoomSetup,'����(&S)...');
  //tt8//'&Setup...');                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuPages,'ҳ��(&P)');
  //tt8//'&Pages');                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuGotoPage,'ת��(&G)');
  //tt8//'&Go');                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuGotoPageFirst,'��ҳ(&F)');
  //tt8//'&First Page');                                                                                                                                                                                             
  cxSetResourceString(@sdxMenuGotoPagePrev,'ǰһҳ(&P)');
  //tt8//'&Previous Page');                                                                                                                                                                                         
  cxSetResourceString(@sdxMenuGotoPageNext,'��һҳ(&N)');
  //tt8//'&Next Page');                                                                                                                                                                                             
  cxSetResourceString(@sdxMenuGotoPageLast,'βҳ(&L)');
  //tt8//'&Last Page');                                                                                                                                                                                               
  cxSetResourceString(@sdxMenuActivePage,'��ǰҳ(&A):');
  //tt8//'&Active Page:');                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuFormat,'��ʽ(&O)');
  //tt8//'F&ormat');                                                                                                                                                                                                        
  cxSetResourceString(@sdxMenuFormatHeaderAndFooter,'ҳü��ҳ��');
  //tt8//'&Header and Footer');                                                                                                                                                                            
  cxSetResourceString(@sdxMenuFormatAutoTextEntries,'�Զ�ͼ�ļ�(&A)...');
  //tt8//'&Auto Text Entries...');                                                                                                                                                                  
  cxSetResourceString(@sdxMenuFormatDateTime,'���ں�ʱ��(&T)...');
  //tt8//'Date And &Time...');                                                                                                                                                                             
  cxSetResourceString(@sdxMenuFormatPageNumbering,'ҳ��(&N)...');
  //tt8//'Page &Numbering...');                                                                                                                                                                             
  cxSetResourceString(@sdxMenuFormatPageBackground,'����(&K)...');
  //tt8//'Bac&kground...');                                                                                                                                                                                
  cxSetResourceString(@sdxMenuFormatShrinkToPage,'��С�ʺ�ҳ��(&F)');
  //tt8//'&Fit to Page');                                                                                                                                                                               
  cxSetResourceString(@sdxMenuShowEmptyPages,'��ʾ�հ�ҳ(&E)');
  //tt8//'Show &Empty Pages');                                                                                                                                                                                
  cxSetResourceString(@sdxMenuFormatHFBackground,'ҳü/ҳ�ű���...');
  //tt8//'Header/Footer Background...');                                                                                                                                                                
  cxSetResourceString(@sdxMenuFormatHFClear,'����ı�');
  //tt8//'Clear Text');                                                                                                                                                                                              
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuTools,'����(&T)');
  //tt8//'&Tools');                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuToolsCustomize,'�Զ���(&C)...');
  //tt8//'&Customize...');                                                                                                                                                                                     
  cxSetResourceString(@sdxMenuToolsOptions,'ѡ��(&O)...');
  //tt8//'&Options...');                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuHelp,'����(&H)');
  //tt8//'&Help');                                                                                                                                                                                                            
  cxSetResourceString(@sdxMenuHelpTopics,'��������(&T)...');
  //tt8//'Help &Topics...');                                                                                                                                                                                     
  cxSetResourceString(@sdxMenuHelpAbout,'����(&A)...');
  //tt8//'&About...');                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuShortcutPreview,'Ԥ��');
  //tt8//'Preview');                                                                                                                                                                                                   
  cxSetResourceString(@sdxMenuShortcutAutoText,'�Զ�ͼ�ļ�');
  //tt8//'AutoText');                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuBuiltInMenus,'���ò˵�');
  //tt8//'Built-in Menus');                                                                                                                                                                                           
  cxSetResourceString(@sdxMenuShortCutMenus,'��ݲ˵�');
  //tt8//'Shortcut Menus');                                                                                                                                                                                          
  cxSetResourceString(@sdxMenuNewMenu,'�½��˵�');
  //tt8//'New Menu');                                                                                                                                                                                                      
                                                                                                                                                                                                                                                          
  { Hints }                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintFileDesign,'��Ʊ���');
  //tt8//'Design Report');                                                                                                                                                                                              
  cxSetResourceString(@sdxHintFilePrint,'��ӡ');
  //tt8//'Print');                                                                                                                                                                                                           
  cxSetResourceString(@sdxHintFilePrintDialog,'��ӡ�Ի���');
  //tt8//'Print Dialog');                                                                                                                                                                                        
  cxSetResourceString(@sdxHintFilePageSetup,'ҳ������');
  //tt8//'Page Setup');                                                                                                                                                                                              
  cxSetResourceString(@sdxHintFileExit,'�ر�Ԥ��');
  //tt8//'Close Preview');                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintEditFind,'����');
  //tt8//'Find');                                                                                                                                                                                                             
  cxSetResourceString(@sdxHintEditFindNext,'������һ��');
  //tt8//'Find Next');                                                                                                                                                                                              
  cxSetResourceString(@sdxHintEditReplace,'�滻');
  //tt8//'Replace');                                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintInsertEditAutoTextEntries,'�༭�Զ�ͼ�ļ�');
  //tt8//'Edit AutoText Entries');                                                                                                                                                                 
  cxSetResourceString(@sdxHintInsertPageNumber,'����ҳ��');
  //tt8//'Insert Page Number');                                                                                                                                                                                   
  cxSetResourceString(@sdxHintInsertTotalPages,'����ҳ��');
  //tt8//'Insert Number of Pages');                                                                                                                                                                               
  cxSetResourceString(@sdxHintInsertPageOfPages,'����ҳ��');
  //tt8//'Insert Page Number of Pages');                                                                                                                                                                         
  cxSetResourceString(@sdxHintInsertDateTime,'�������ں�ʱ��');
  //tt8//'Insert Date and Time');                                                                                                                                                                             
  cxSetResourceString(@sdxHintInsertDate,'��������');
  //tt8//'Insert Date');                                                                                                                                                                                                
  cxSetResourceString(@sdxHintInsertTime,'����ʱ��');
  //tt8//'Insert Time');                                                                                                                                                                                                
  cxSetResourceString(@sdxHintInsertUserName,'�����û�����');
  //tt8//'Insert User Name');                                                                                                                                                                                   
  cxSetResourceString(@sdxHintInsertMachineName,'�����������');
  //tt8//'Insert Machine Name');                                                                                                                                                                             
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintViewMargins,'�鿴ҳ�߾�');
  //tt8//'View Margins');                                                                                                                                                                                            
  cxSetResourceString(@sdxHintViewLargeButtons,'�鿴��ť');
  //tt8//'View Large Buttons');                                                                                                                                                                                 
  cxSetResourceString(@sdxHintViewMarginsStatusBar,'�鿴ҳ�߾�״̬��');
  //tt8//'View Margins Status Bar');                                                                                                                                                                  
  cxSetResourceString(@sdxHintViewPagesStatusBar,'�鿴ҳ��״̬��');
  //tt8//'View Page Status Bar');                                                                                                                                                                         
  cxSetResourceString(@sdxHintViewPagesHeaders,'�鿴ҳü');
  //tt8//'View Page Header');                                                                                                                                                                                     
  cxSetResourceString(@sdxHintViewPagesFooters,'�鿴ҳ��');
  //tt8//'View Page Footer');                                                                                                                                                                                     
  cxSetResourceString(@sdxHintViewSwitchToLeftPart,'�л�����ߵ�ҳü/ҳ��');
  //tt8//'Switch to Left Header/Footer Part');                                                                                                                                                   
  cxSetResourceString(@sdxHintViewSwitchToRightPart,'�л����ұߵ�ҳü/ҳ��');
  //tt8//'Switch to Right Header/Footer Part');                                                                                                                                                 
  cxSetResourceString(@sdxHintViewSwitchToCenterPart,'�л����м��ҳü/ҳ��');
  //tt8//'Switch to Center Header/Footer Part');                                                                                                                                               
  cxSetResourceString(@sdxHintViewHFSwitchHeaderFooter,'��ҳü��ҳ��֮���л�');
  //tt8//'Switch Between Header and Footer');                                                                                                                                                 
  cxSetResourceString(@sdxHintViewHFClose,'�ر�');
  //tt8//'Close');                                                                                                                                                                                                         
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintViewZoom,'����');
  //tt8//'Zoom');                                                                                                                                                                                                             
  cxSetResourceString(@sdxHintZoomPercent100,'�ٷ�100%');
  //tt8//'Zoom 100%');                                                                                                                                                                                              
  cxSetResourceString(@sdxHintZoomPageWidth,'ҳ��');
  //tt8//'Zoom Page Width');                                                                                                                                                                                             
  cxSetResourceString(@sdxHintZoomWholePage,'��ҳ');
  //tt8//'Whole Page');                                                                                                                                                                                                  
  cxSetResourceString(@sdxHintZoomTwoPages,'��ҳ');
  //tt8//'Two Pages');                                                                                                                                                                                                    
  cxSetResourceString(@sdxHintZoomFourPages,'��ҳ');
  //tt8//'Four Pages');                                                                                                                                                                                                  
  cxSetResourceString(@sdxHintZoomMultiplyPages,'��ҳ');
  //tt8//'Multiple Pages');                                                                                                                                                                                          
  cxSetResourceString(@sdxHintZoomWidenToSourceWidth,'��չ��ԭʼ���');
  //tt8//'Widen To Source Width');                                                                                                                                                                    
  cxSetResourceString(@sdxHintZoomSetup,'�������ű���');
  //tt8//'Setup Zoom Factor');                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintFormatDateTime,'��ʽ�����ں�ʱ��');
  //tt8//'Format Date and Time');                                                                                                                                                                           
  cxSetResourceString(@sdxHintFormatPageNumbering,'��ʽ��ҳ��');
  //tt8//'Format Page Number');                                                                                                                                                                              
  cxSetResourceString(@sdxHintFormatPageBackground,'����');
  //tt8//'Background');                                                                                                                                                                                           
  cxSetResourceString(@sdxHintFormatShrinkToPage,'��С�ʺ�ҳ��');
  //tt8//'Shrink To Page');                                                                                                                                                                                 
  cxSetResourceString(@sdxHintFormatHFBackground,'ҳü/ҳ�ű���');
  //tt8//'Header/Footer Background');                                                                                                                                                                      
  cxSetResourceString(@sdxHintFormatHFClear,'���ҳü/ҳ���ı�');
  //tt8//'Clear Header/Footer Text');                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintGotoPageFirst,'��ҳ');
  //tt8//'First Page');                                                                                                                                                                                                  
  cxSetResourceString(@sdxHintGotoPagePrev,'ǰһҳ');
  //tt8//'Previous Page');                                                                                                                                                                                              
  cxSetResourceString(@sdxHintGotoPageNext,'��һҳ');
  //tt8//'Next Page');                                                                                                                                                                                                  
  cxSetResourceString(@sdxHintGotoPageLast,'βҳ');
  //tt8//'Last Page');                                                                                                                                                                                                    
  cxSetResourceString(@sdxHintActivePage,'��ǰҳ');
  //tt8//'Active Page');                                                                                                                                                                                                  
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintToolsCustomize,'�Զ��幤����');
  //tt8//'Customize Toolbars');                                                                                                                                                                                 
  cxSetResourceString(@sdxHintToolsOptions,'ѡ��');
  //tt8//'Options');                                                                                                                                                                                                      
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintHelpTopics,'��������');
  //tt8//'Help Topics');                                                                                                                                                                                                
  cxSetResourceString(@sdxHintHelpAbout,'����');
  //tt8//'About');                                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPopupMenuLargeButtons,'��ť');
  //tt8//'&Large Buttons');                                                                                                                                                                                        
  cxSetResourceString(@sdxPopupMenuFlatButtons,'ƽ�水ť');
  //tt8//'&Flat Buttons');                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPaperSize,'ֽ�Ŵ�С');
  //tt8//'Paper Size:');                                                                                                                                                                                                     
  cxSetResourceString(@sdxStatus,'״̬');
  //tt8//'Status:');                                                                                                                                                                                                                
  cxSetResourceString(@sdxStatusReady,'����');
  //tt8//'Ready');                                                                                                                                                                                                             
  cxSetResourceString(@sdxStatusPrinting,'���ڴ�ӡ������� %d ҳ');
  //tt8//'Printing. Completed %d page(s)');                                                                                                                                                               
  cxSetResourceString(@sdxStatusGenerateReport,'������������� %d%%');
  //tt8//'Generating Report. Completed %d%%');                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHintDoubleClickForChangePaperSize,'˫���ı�ֽ�Ŵ�С');
  //tt8//'Double Click for Change Paper Size');                                                                                                                                              
  cxSetResourceString(@sdxHintDoubleClickForChangeMargins,'˫���ı�ҳ�߾�');
  //tt8//'Double Click for Change Margins');                                                                                                                                                     
                                                                                                                                                                                                                                                          
  { Date&Time Formats Dialog }                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxDTFormatsCaption,'������ʱ��');
  //tt8//'Date and Time');                                                                                                                                                                                          
  cxSetResourceString(@sdxDTFormatsAvailableDateFormats,'��Ч�����ڸ�ʽ:');
  //tt8//'&Available Date Formats:');                                                                                                                                                             
  cxSetResourceString(@sdxDTFormatsAvailableTimeFormats,'��Ч��ʱ���ʽ:');
  //tt8//'Available &Time Formats:');                                                                                                                                                             
  cxSetResourceString(@sdxDTFormatsAutoUpdate,'�Զ�����');
  //tt8//'&Update Automatically');                                                                                                                                                                                 
  cxSetResourceString(@sdxDTFormatsChangeDefaultFormat,                                                                                                                                                                                                                      
    'Do you want to change the default date and time formats to match "%s"  - "%s" ?');                                                                                                                                                                    
                                                                                                                                                                                                                                                          
  { PageNumber Formats Dialog }                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPNFormatsCaption,'ҳ���ʽ');
  //tt8//'Page Number Format');                                                                                                                                                                                       
  cxSetResourceString(@sdxPageNumbering,'ҳ��');
  //tt8//'Page Numbering');                                                                                                                                                                                                  
  cxSetResourceString(@sdxPNFormatsNumberFormat,'���ָ�ʽ(&F):');
  //tt8//'Number &Format:');                                                                                                                                                                                
  cxSetResourceString(@sdxPNFormatsContinueFromPrevious,'��ǰ��(&C)');
  //tt8//'&Continue from Previous Section');                                                                                                                                                           
  cxSetResourceString(@sdxPNFormatsStartAt,'��ʼҳ��:');
  //tt8//'Start &At:');                                                                                                                                                                                              
  cxSetResourceString(@sdxPNFormatsChangeDefaultFormat,                                                                                                                                                                                                                      
    'Do you want to change the default Page numbering format to match "%s" ?');                                                                                                                                                                            
                                                                                                                                                                                                                                                          
  { Zoom Dialog }                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxZoomDlgCaption,'����');
  //tt8//'Zoom');                                                                                                                                                                                                           
  cxSetResourceString(@sdxZoomDlgZoomTo,' ������ ');
  //tt8//' Zoom To ');                                                                                                                                                                                                   
  cxSetResourceString(@sdxZoomDlgPageWidth,'ҳ��(&W)');
  //tt8//'Page &Width');                                                                                                                                                                                              
  cxSetResourceString(@sdxZoomDlgWholePage,'��ҳ(&H)');
  //tt8//'W&hole Page');                                                                                                                                                                                              
  cxSetResourceString(@sdxZoomDlgTwoPages,'��ҳ(&T)');
  //tt8//'&Two Pages');                                                                                                                                                                                                
  cxSetResourceString(@sdxZoomDlgFourPages,'��ҳ(&F)');
  //tt8//'&Four Pages');                                                                                                                                                                                              
  cxSetResourceString(@sdxZoomDlgManyPages,'��ҳ(&M):');
  //tt8//'&Many Pages:');                                                                                                                                                                                            
  cxSetResourceString(@sdxZoomDlgPercent,'����:(&E)');
  //tt8//'P&ercent:');                                                                                                                                                                                                 
  cxSetResourceString(@sdxZoomDlgPreview,'Ԥ��');
  //tt8//' Preview ');                                                                                                                                                                                                      
  cxSetResourceString(@sdxZoomDlgFontPreview,' 12pt Times New Roman ');
  //tt8//' 12pt Times New Roman ');                                                                                                                                                                   
  cxSetResourceString(@sdxZoomDlgFontPreviewString,'xypxy@163.net');
  //tt8//'AaBbCcDdEeXxYyZz');                                                                                                                                                                            
                                                                                                                                                                                                                                                          
  { Select page X x Y }                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPages,'ҳ');
  //tt8//'Pages');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxCancel,'ȡ��');
  //tt8//'Cancel');                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                          
  { preferences dialog }                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPreferenceDlgCaption,'ѡ��');
  //tt8//'Options');                                                                                                                                                                                                  
  cxSetResourceString(@sdxPreferenceDlgTab1,'����(&G)');
  //tt8//'&General');                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab2,'');
  //tt8//'');                                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab3,'');
  //tt8//'');                                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab4,'');
  //tt8//'');                                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab5,'');
  //tt8//'');                                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab6,'');
  //tt8//'');                                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab7,'');
  //tt8//'');                                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab8,'');
  //tt8//'');                                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab9,'');
  //tt8//'');                                                                                                                                                                                                                
  cxSetResourceString(@sdxPreferenceDlgTab10,'');
  //tt8//'');                                                                                                                                                                                                               
  cxSetResourceString(@sdxPreferenceDlgShow,'��ʾ(&S)');
  //tt8//' &Show ');                                                                                                                                                                                                 
  cxSetResourceString(@sdxPreferenceDlgMargins,'ҳ�߾�(&M)');
  //tt8//'&Margins ');                                                                                                                                                                                          
  cxSetResourceString(@sdxPreferenceDlgMarginsHints,'ҳ�߾���ʾ(&H)');
  //tt8//'Margins &Hints');                                                                                                                                                                            
  cxSetResourceString(@sdxPreferenceDlgMargingWhileDragging,'����ҷʱ��ʾҳ�߾���ʾ(&D)');
  //tt8//'Margins Hints While &Dragging');                                                                                                                                         
  cxSetResourceString(@sdxPreferenceDlgLargeBtns,'�󹤾�����ť(&L)');
  //tt8//'&Large Toolbar Buttons');                                                                                                                                                                     
  cxSetResourceString(@sdxPreferenceDlgFlatBtns,'ƽ�湤������ť(&F)');
  //tt8//'&Flat Toolbar Buttons');                                                                                                                                                                     
  cxSetResourceString(@sdxPreferenceDlgMarginsColor,'ҳ�߾���ɫ(&C):');
  //tt8//'Margins &Color:');                                                                                                                                                                          
  cxSetResourceString(@sdxPreferenceDlgMeasurementUnits,'������λ(&U):');
  //tt8//'Measurement &Units:');                                                                                                                                                                    
  cxSetResourceString(@sdxPreferenceDlgSaveForRunTimeToo,'��������(&R)');
  //tt8//'Save for &RunTime too');                                                                                                                                                                  
  cxSetResourceString(@sdxPreferenceDlgZoomScroll,'�����ֿ�������(&Z)');
  //tt8//'&Zoom on roll with IntelliMouse');                                                                                                                                                       
  cxSetResourceString(@sdxPreferenceDlgZoomStep,'���ű���(&P):');
  //tt8//'Zoom Ste&p:');                                                                                                                                                                                    
                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  { Page Setup }                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCloneStyleCaptionPrefix,'���� (%d) / ');
  //tt8//'Copy (%d) of ');                                                                                                                                                                                 
  cxSetResourceString(@sdxInvalideStyleCaption,'��ʽ���� "%s" �Ѿ����ڡ� ���ṩ��һ�����ơ�');
  //tt8//'The style name "%s" already exists. Please supply another name.');                                                                                                   
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPageSetupCaption,'ҳ������');
  //tt8//'Page Setup');                                                                                                                                                                                               
  cxSetResourceString(@sdxStyleName,'��ʽ����(&N):');
  //tt8//'Style &Name:');                                                                                                                                                                                               
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPage,'ҳ��(&P)');
  //tt8//'&Page');                                                                                                                                                                                                                
  cxSetResourceString(@sdxMargins,'ҳ�߾�(&M)');
  //tt8//'&Margins');                                                                                                                                                                                                        
  cxSetResourceString(@sdxHeaderFooter,'ҳü/ҳ�� (&H)');
  //tt8//'&Header\Footer');                                                                                                                                                                                         
  cxSetResourceString(@sdxScaling,'����(&S)');
  //tt8//'&Scaling');                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPaper,' ֽ�� ');
  //tt8//' Paper ');                                                                                                                                                                                                               
  cxSetResourceString(@sdxPaperType,'ֽ��(&Y)');
  //tt8//'T&ype');                                                                                                                                                                                                           
  cxSetResourceString(@sdxPaperDimension,'�ߴ�(&S)');
  //tt8//'Dimension');                                                                                                                                                                                                  
  cxSetResourceString(@sdxPaperWidth,'���(&W):');
  //tt8//'&Width:');                                                                                                                                                                                                       
  cxSetResourceString(@sdxPaperHeight,'�߶�(&E):');
  //tt8//'H&eight:');                                                                                                                                                                                                     
  cxSetResourceString(@sdxPaperSource,'ֽ����Դ(&U)');
  //tt8//'Paper so&urce');                                                                                                                                                                                             
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxOrientation,' ����');
  //tt8//' Orientation ');                                                                                                                                                                                                    
  cxSetResourceString(@sdxPortrait,'����(&O)');
  //tt8//'P&ortrait');                                                                                                                                                                                                        
  cxSetResourceString(@sdxLandscape,'����(&L)');
  //tt8//'&Landscape');                                                                                                                                                                                                      
  cxSetResourceString(@sdxPrintOrder,' ��ӡ����');
  //tt8//' Print Order ');                                                                                                                                                                                                 
  cxSetResourceString(@sdxDownThenOver,'���к���(&D)');
  //tt8//'&Down, then over');                                                                                                                                                                                         
  cxSetResourceString(@sdxOverThenDown,'���к���(&V)');
  //tt8//'O&ver, then down');                                                                                                                                                                                         
  cxSetResourceString(@sdxShading,' ��Ӱ ');
  //tt8//' Shading ');                                                                                                                                                                                                           
  cxSetResourceString(@sdxPrintUsingGrayShading,'ʹ�û�ɫ��Ӱ��ӡ(&G)');
  //tt8//'Print using &gray shading');                                                                                                                                                               
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCenterOnPage,'���з�ʽ');
  //tt8//'Center on page');                                                                                                                                                                                               
  cxSetResourceString(@sdxHorizontally,'ˮƽ(&Z)');
  //tt8//'Hori&zontally');                                                                                                                                                                                                
  cxSetResourceString(@sdxVertically,'��ֱ(&V)');
  //tt8//'&Vertically');                                                                                                                                                                                                    
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxHeader,'ҳü ');
  //tt8//'Header ');                                                                                                                                                                                                               
  cxSetResourceString(@sdxBtnHeaderFont,'����(&F)...');
  //tt8//'&Font...');                                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnHeaderBackground,'����(&B)');
  //tt8//'&Background');                                                                                                                                                                                           
  cxSetResourceString(@sdxFooter,'ҳ�� ');
  //tt8//'Footer ');                                                                                                                                                                                                               
  cxSetResourceString(@sdxBtnFooterFont,'����(&N)...');
  //tt8//'Fo&nt...');                                                                                                                                                                                                 
  cxSetResourceString(@sdxBtnFooterBackground,'����(&G)');
  //tt8//'Back&ground');                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxTop,'��(&T):');
  //tt8//'&Top:');                                                                                                                                                                                                                  
  cxSetResourceString(@sdxLeft,'��(&L):');
  //tt8//'&Left:');                                                                                                                                                                                                                
  cxSetResourceString(@sdxRight,'��(&G):');
  //tt8//'Ri&ght:');                                                                                                                                                                                                              
  cxSetResourceString(@sdxBottom,'��(&B):');
  //tt8//'&Bottom:');                                                                                                                                                                                                            
  cxSetResourceString(@sdxHeader2,'ҳü(&E):');
  //tt8//'H&eader:');                                                                                                                                                                                                         
  cxSetResourceString(@sdxFooter2,'ҳ��(&R):');
  //tt8//'Foote&r:');                                                                                                                                                                                                         
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxAlignment,'���뷽ʽ');
  //tt8//'Alignment');                                                                                                                                                                                                       
  cxSetResourceString(@sdxVertAlignment,' ��ֱ����');
  //tt8//' Vertical Alignment ');                                                                                                                                                                                       
  cxSetResourceString(@sdxReverseOnEvenPages,'żҳ�෴(&R)');
  //tt8//'&Reverse on even pages');                                                                                                                                                                             
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxAdjustTo,'������:');
  //tt8//'&Adjust To:');                                                                                                                                                                                                       
  cxSetResourceString(@sdxFitTo,'�ʺ�:');
  //tt8//'&Fit To:');                                                                                                                                                                                                               
  cxSetResourceString(@sdxPercentOfNormalSize,'% ������С');
  //tt8//'% normal size');                                                                                                                                                                                       
  cxSetResourceString(@sdxPagesWideBy,'ҳ��(&W)');
  //tt8//'page(s) &wide by');                                                                                                                                                                                              
  cxSetResourceString(@sdxTall,'ҳ��(&T)');
  //tt8//'&tall');                                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxOf,'��');
  //tt8//'Of');                                                                                                                                                                                                                           
  cxSetResourceString(@sdxLastPrinted,'�ϴδ�ӡʱ�� ');
  //tt8//'Last Printed ');                                                                                                                                                                                            
  cxSetResourceString(@sdxFileName,'�ļ����� ');
  //tt8//'Filename ');                                                                                                                                                                                                       
  cxSetResourceString(@sdxFileNameAndPath,'�ļ����ƺ�·�� ');
  //tt8//'Filename and path ');                                                                                                                                                                                 
  cxSetResourceString(@sdxPrintedBy,'��ӡ�� ');
  //tt8//'Printed By ');                                                                                                                                                                                                      
  cxSetResourceString(@sdxPrintedOn,'��ӡ�� ');
  //tt8//'Printed On ');                                                                                                                                                                                                      
  cxSetResourceString(@sdxCreatedBy,'������ ');
  //tt8//'Created By ');                                                                                                                                                                                                      
  cxSetResourceString(@sdxCreatedOn,'������ ');
  //tt8//'Created On ');                                                                                                                                                                                                      
  cxSetResourceString(@sdxConfidential,'����');
  //tt8//'Confidential'); 

  { HF function }
  
  cxSetResourceString(@sdxHFFunctionNameUnknown,'Unknown');
  cxSetResourceString(@sdxHFFunctionNamePageNumber,'Page Number');
  cxSetResourceString(@sdxHFFunctionNameTotalPages,'Total Pages');
  cxSetResourceString(@sdxHFFunctionNamePageOfPages,'Page # of Pages #');
  cxSetResourceString(@sdxHFFunctionNameDateTime,'Date and Time');
  cxSetResourceString(@sdxHFFunctionNameDate,'Date');
  cxSetResourceString(@sdxHFFunctionNameTime,'Time');
  cxSetResourceString(@sdxHFFunctionNameUserName,'User Name');
  cxSetResourceString(@sdxHFFunctionNameMachineName,'Machine Name');

  cxSetResourceString(@sdxHFFunctionHintPageNumber,'Page Number');
  cxSetResourceString(@sdxHFFunctionHintTotalPages,'Total Pages');
  cxSetResourceString(@sdxHFFunctionHintPageOfPages,'Page # of Pages #');
  cxSetResourceString(@sdxHFFunctionHintDateTime,'Date and Time Printed');
  cxSetResourceString(@sdxHFFunctionHintDate,'Date Printed');
  cxSetResourceString(@sdxHFFunctionHintTime,'Time Printed');
  cxSetResourceString(@sdxHFFunctionHintUserName,'User Name');
  cxSetResourceString(@sdxHFFunctionHintMachineName,'Machine Name');

  cxSetResourceString(@sdxHFFunctionTemplatePageNumber,'Page #');
  cxSetResourceString(@sdxHFFunctionTemplateTotalPages,'Total Pages');
  cxSetResourceString(@sdxHFFunctionTemplatePageOfPages,'Page # of Pages #');
  cxSetResourceString(@sdxHFFunctionTemplateDateTime,'Date & Time Printed');
  cxSetResourceString(@sdxHFFunctionTemplateDate,'Date Printed');
  cxSetResourceString(@sdxHFFunctionTemplateTime,'Time Printed');
  cxSetResourceString(@sdxHFFunctionTemplateUserName,'User Name');
  cxSetResourceString(@sdxHFFunctionTemplateMachineName,'Machine Name');

  { Designer strings }
  
  { Months }
  
  cxSetResourceString(@sdxJanuary,'һ��');
  //tt8//'January');                                                                                                                                                                                                               
  cxSetResourceString(@sdxFebruary,'����');
  //tt8//'February');                                                                                                                                                                                                             
  cxSetResourceString(@sdxMarch,'����');
  //tt8//'March');                                                                                                                                                                                                                   
  cxSetResourceString(@sdxApril,'����');
  //tt8//'April');                                                                                                                                                                                                                   
  cxSetResourceString(@sdxMay,'����');
  //tt8//'May');                                                                                                                                                                                                                       
  cxSetResourceString(@sdxJune,'����');
  //tt8//'June');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxJuly,'����');
  //tt8//'July');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxAugust,'����');
  //tt8//'August');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxSeptember,'����');
  //tt8//'September');                                                                                                                                                                                                           
  cxSetResourceString(@sdxOctober,'ʮ��');
  //tt8//'October');                                                                                                                                                                                                               
  cxSetResourceString(@sdxNovember,'ʮһ��');
  //tt8//'November');                                                                                                                                                                                                           
  cxSetResourceString(@sdxDecember,'ʮ����');
  //tt8//'December');                                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxEast,'����');
  //tt8//'East');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxWest,'����');
  //tt8//'West');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxSouth,'�Ϸ�');
  //tt8//'South');                                                                                                                                                                                                                   
  cxSetResourceString(@sdxNorth,'����');
  //tt8//'North');                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxTotal,'�ϼ�');
  //tt8//'Total');                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                          
  { dxFlowChart }                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPlan,'���ͼ');
  //tt8//'Plan');                                                                                                                                                                                                                   
  cxSetResourceString(@sdxSwimmingPool,'��Ӿ��');
  //tt8//'Swimming-pool');                                                                                                                                                                                                  
  cxSetResourceString(@sdxAdministration,'����Ա');
  //tt8//'Administration');                                                                                                                                                                                               
  cxSetResourceString(@sdxPark,'��԰');
  //tt8//'Park');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxCarParking,'ͣ����');
  //tt8//'Car-Parking');                                                                                                                                                                                                      
                                                                                                                                                                                                                                                          
  { dxOrgChart }                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCorporateHeadquarters,'��˾'+#13#10+'�ܲ�');
  //tt8//'Corporate' + #13#10 + 'Headquarters');                                                                                                                                                       
  cxSetResourceString(@sdxSalesAndMarketing,'���۲�'+#13#10+'�г���');
  //tt8//'Sales and' + #13#10 + 'Marketing');                                                                                                                                                          
  cxSetResourceString(@sdxEngineering,'���̼�����');
  //tt8//'Engineering');                                                                                                                                                                                                 
  cxSetResourceString(@sdxFieldOfficeCanada,'�칫��:'+#13#10+'���ô�');
  //tt8//'Field Office:' + #13#10 + 'Canada');                                                                                                                                                        
                                                                                                                                                                                                                                                          
  { dxMasterView }                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxOrderNoCaption,'���');
  //tt8//'OrderNo');                                                                                                                                                                                                        
  cxSetResourceString(@sdxNameCaption,'����');
  //tt8//'Name');                                                                                                                                                                                                              
  cxSetResourceString(@sdxCountCaption,'����');
  //tt8//'Count');                                                                                                                                                                                                            
  cxSetResourceString(@sdxCompanyCaption,'��˾');
  //tt8//'Company');                                                                                                                                                                                                        
  cxSetResourceString(@sdxAddressCaption,'��ַ');
  //tt8//'Address');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPriceCaption,'�۸�');
  //tt8//'Price');                                                                                                                                                                                                            
  cxSetResourceString(@sdxCashCaption,'�ֽ�');
  //tt8//'Cash');                                                                                                                                                                                                              
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxName1,'����');
  //tt8//'Jennie Valentine');                                                                                                                                                                                                        
  cxSetResourceString(@sdxName2,'����');
  //tt8//'Sam Hill');                                                                                                                                                                                                                
  cxSetResourceString(@sdxCompany1,'�������޹�˾');
  //tt8//'Jennie Inc.');                                                                                                                                                                                                  
  cxSetResourceString(@sdxCompany2,'������');
  //tt8//'Daimler-Chrysler AG');                                                                                                                                                                                              
  cxSetResourceString(@sdxAddress1,'123 Home Lane');
  //tt8//'123 Home Lane');                                                                                                                                                                                               
  cxSetResourceString(@sdxAddress2,'9333 Holmes Dr.');
  //tt8//'9333 Holmes Dr.');                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  { dxTreeList }                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCountIs,'������%d');
  //tt8//'Count is: %d');                                                                                                                                                                                                      
  cxSetResourceString(@sdxRegular,'����');
  //tt8//'Regular');                                                                                                                                                                                                               
  cxSetResourceString(@sdxIrregular,'������');
  //tt8//'Irregular');                                                                                                                                                                                                         
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxTLBand,'��Ŀ����');
  //tt8//'Item Data');                                                                                                                                                                                                          
  cxSetResourceString(@sdxTLColumnName,'����');
  //tt8//'Name');                                                                                                                                                                                                             
  cxSetResourceString(@sdxTLColumnAxisymmetric,'��Գ�');
  //tt8//'Axisymmetric');                                                                                                                                                                                           
  cxSetResourceString(@sdxTLColumnItemShape,'��״');
  //tt8//'Shape');                                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxItemShapeAsText,'(ͼ��)');
  //tt8//'(Graphic)');                                                                                                                                                                                                   
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxItem1Name,'׶����');
  //tt8//'Cylinder');                                                                                                                                                                                                          
  cxSetResourceString(@sdxItem2Name,'Բ����');
  //tt8//'Cone');                                                                                                                                                                                                              
  cxSetResourceString(@sdxItem3Name,'��׶');
  //tt8//'Pyramid');                                                                                                                                                                                                             
  cxSetResourceString(@sdxItem4Name,'����');
  //tt8//'Box');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxItem5Name,'���ɱ���');
  //tt8//'Free Surface');                                                                                                                                                                                                    
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxItem1Description,'');
  //tt8//'');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxItem2Description,'��ԳƼ���ͼ��');
  //tt8//'Axisymmetric geometry figure');                                                                                                                                                                       
  cxSetResourceString(@sdxItem3Description,'��ԳƼ���ͼ��');
  //tt8//'Axisymmetric geometry figure');                                                                                                                                                                       
  cxSetResourceString(@sdxItem4Description,'��Ǽ���ͼ��');
  //tt8//'Acute-angled geometry figure');                                                                                                                                                                         
  cxSetResourceString(@sdxItem5Description,'');
  //tt8//'');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxItem6Description,'');
  //tt8//'');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxItem7Description,'��ͻ������');
  //tt8//'Simple extrusion surface');                                                                                                                                                                             
                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  { PS 2.3 }                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                          
  { Patterns common }                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxPatternIsNotRegistered,'ģʽ "%s" û��ע��');
  //tt8//'Pattern "%s" is not registered');                                                                                                                                                           
                                                                                                                                                                                                                                                          
  { Excel edge patterns }                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxSolidEdgePattern,'ʵ��');
  //tt8//'Solid');                                                                                                                                                                                                        
  cxSetResourceString(@sdxThinSolidEdgePattern,'ϸʵ��');
  //tt8//'Medium Solid');                                                                                                                                                                                           
  cxSetResourceString(@sdxMediumSolidEdgePattern,'��ʵ��');
  //tt8//'Medium Solid');                                                                                                                                                                                         
  cxSetResourceString(@sdxThickSolidEdgePattern,'��ʵ��');
  //tt8//'Thick Solid');                                                                                                                                                                                           
  cxSetResourceString(@sdxDottedEdgePattern,'Բ��');
  //tt8//'Dotted');                                                                                                                                                                                                      
  cxSetResourceString(@sdxDashedEdgePattern,'�̻���');
  //tt8//'Dashed');                                                                                                                                                                                                    
  cxSetResourceString(@sdxDashDotDotEdgePattern,'�̻���-��-��');
  //tt8//'Dash Dot Dot');                                                                                                                                                                                    
  cxSetResourceString(@sdxDashDotEdgePattern,'�̻���-��');
  //tt8//'Dash Dot');                                                                                                                                                                                              
  cxSetResourceString(@sdxSlantedDashDotEdgePattern,'б�̻���-��');
  //tt8//'Slanted Dash Dot');                                                                                                                                                                             
  cxSetResourceString(@sdxMediumDashDotDotEdgePattern,'�еȶ̻���-��-��');
  //tt8//'Medium Dash Dot Dot');                                                                                                                                                                   
  cxSetResourceString(@sdxHairEdgePattern,'˿״');
  //tt8//'Hair');                                                                                                                                                                                                          
  cxSetResourceString(@sdxMediumDashDotEdgePattern,'�еȶ̻���-��');
  //tt8//'Medium Dash Dot');                                                                                                                                                                             
  cxSetResourceString(@sdxMediumDashedEdgePattern,'�еȶ̻���');
  //tt8//'Medium Dashed');                                                                                                                                                                                   
  cxSetResourceString(@sdxDoubleLineEdgePattern,'˫��');
  //tt8//'Double Line');                                                                                                                                                                                             
                                                                                                                                                                                                                                                          
  { Excel fill patterns names}                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxSolidFillPattern,'ԭɫ');
  //tt8//'Solid');                                                                                                                                                                                                        
  cxSetResourceString(@sdxGray75FillPattern,'75% ��ɫ');
  //tt8//'75% Gray');                                                                                                                                                                                                
  cxSetResourceString(@sdxGray50FillPattern,'50% ��ɫ');
  //tt8//'50% Gray');                                                                                                                                                                                                
  cxSetResourceString(@sdxGray25FillPattern,'25% ��ɫ');
  //tt8//'25% Gray');                                                                                                                                                                                                
  cxSetResourceString(@sdxGray125FillPattern,'12.5% ��ɫ');
  //tt8//'12.5% Gray');                                                                                                                                                                                           
  cxSetResourceString(@sdxGray625FillPattern,'6.25% ��ɫ');
  //tt8//'6.25% Gray');                                                                                                                                                                                           
  cxSetResourceString(@sdxHorizontalStripeFillPattern,'ˮƽ����');
  //tt8//'Horizontal Stripe');                                                                                                                                                                             
  cxSetResourceString(@sdxVerticalStripeFillPattern,'��ֱ����');
  //tt8//'Vertical Stripe');                                                                                                                                                                                 
  cxSetResourceString(@sdxReverseDiagonalStripeFillPattern,'��Խ�������');
  //tt8//'Reverse Diagonal Stripe');                                                                                                                                                              
  cxSetResourceString(@sdxDiagonalStripeFillPattern,'�Խ�������');
  //tt8//'Diagonal Stripe');                                                                                                                                                                               
  cxSetResourceString(@sdxDiagonalCrossHatchFillPattern,'�Խ���������');
  //tt8//'Diagonal Cross Hatch');                                                                                                                                                                    
  cxSetResourceString(@sdxThickCrossHatchFillPattern,'�ֶԽ���������');
  //tt8//'Thick Cross Hatch');                                                                                                                                                                        
  cxSetResourceString(@sdxThinHorizontalStripeFillPattern,'ϸˮƽ����');
  //tt8//'Thin Horizontal Stripe');                                                                                                                                                                  
  cxSetResourceString(@sdxThinVerticalStripeFillPattern,'ϸ��ֱ����');
  //tt8//'Thin Vertical Stripe');                                                                                                                                                                      
  cxSetResourceString(@sdxThinReverseDiagonalStripeFillPattern,'Thin Reverse Diagonal Stripe');                                                                                                                                                                               
  cxSetResourceString(@sdxThinDiagonalStripeFillPattern,'ϸ�Խ�������');
  //tt8//'Thin Diagonal Stripe');                                                                                                                                                                    
  cxSetResourceString(@sdxThinHorizontalCrossHatchFillPattern,'ϸˮƽ������');
  //tt8//'Thin Horizontal Cross Hatch');                                                                                                                                                       
  cxSetResourceString(@sdxThinDiagonalCrossHatchFillPattern,'ϸ�Խ���������');
  //tt8//'Thin Diagonal Cross Hatch');                                                                                                                                                         
                                                                                                                                                                                                                                                          
  { cxSpreadSheet }                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxShowRowAndColumnHeadings,'�к��б���(&R)');
  //tt8//'&Row and Column Headings');                                                                                                                                                                   
  cxSetResourceString(@sdxShowGridLines,'������');
  //tt8//'GridLines');                                                                                                                                                                                                     
  cxSetResourceString(@sdxSuppressSourceFormats,'��ֹԴ��ʽ(&S)');
  //tt8//'&Suppress Source Formats');                                                                                                                                                                      
  cxSetResourceString(@sdxRepeatHeaderRowAtTop,'�ڶ����ظ�������');
  //tt8//'Repeat Header Row at Top');                                                                                                                                                                     
  cxSetResourceString(@sdxDataToPrintDoesNotExist,                                                                                                                                                                                                                           
    'Cannot activate ReportLink because PrintingSystem did not find anything to print.');                                                                                                                                                                  
                                                                                                                                                                                                                                                          
  { Designer strings }                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                          
  { Short names of month }                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxJanuaryShort,'һ��');
  //tt8//'Jan');                                                                                                                                                                                                              
  cxSetResourceString(@sdxFebruaryShort,'����');
  //tt8//'Feb');                                                                                                                                                                                                             
  cxSetResourceString(@sdxMarchShort,'����');
  //tt8//'March');                                                                                                                                                                                                              
  cxSetResourceString(@sdxAprilShort,'����');
  //tt8//'April');                                                                                                                                                                                                              
  cxSetResourceString(@sdxMayShort,'����');
  //tt8//'May');                                                                                                                                                                                                                  
  cxSetResourceString(@sdxJuneShort,'����');
  //tt8//'June');                                                                                                                                                                                                                
  cxSetResourceString(@sdxJulyShort,'����');
  //tt8//'July');                                                                                                                                                                                                                
  cxSetResourceString(@sdxAugustShort,'����');
  //tt8//'Aug');                                                                                                                                                                                                               
  cxSetResourceString(@sdxSeptemberShort,'����');
  //tt8//'Sept');                                                                                                                                                                                                           
  cxSetResourceString(@sdxOctoberShort,'ʮ��');
  //tt8//'Oct');                                                                                                                                                                                                              
  cxSetResourceString(@sdxNovemberShort,'ʮһ��');
  //tt8//'Nov');                                                                                                                                                                                                           
  cxSetResourceString(@sdxDecemberShort,'ʮ����');
  //tt8//'Dec');                                                                                                                                                                                                           
                                                                                                                                                                                                                                                          
  { TreeView }                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxTechnicalDepartment,'��������');
  //tt8//'Technical Department');                                                                                                                                                                                  
  cxSetResourceString(@sdxSoftwareDepartment,'�������');
  //tt8//'Software Department');                                                                                                                                                                                    
  cxSetResourceString(@sdxSystemProgrammers,'ϵͳ����Ա');
  //tt8//'Core Developers');                                                                                                                                                                                       
  cxSetResourceString(@sdxEndUserProgrammers,'�ն��û�����Ա');
  //tt8//'GUI Developers');                                                                                                                                                                                   
  cxSetResourceString(@sdxBetaTesters,'����Ա');
  //tt8//'Beta Testers');                                                                                                                                                                                                    
  cxSetResourceString(@sdxHumanResourceDepartment,'������Դ����');
  //tt8//'Human Resource Department');                                                                                                                                                                     
                                                                                                                                                                                                                                                          
  { misc. }                                                                                                                                                                                                                                               
  cxSetResourceString(@sdxTreeLines,'����');
  //tt8//'&TreeLines');                                                                                                                                                                                                          
  cxSetResourceString(@sdxTreeLinesColor,'������ɫ:');
  //tt8//'T&ree Line Color:');                                                                                                                                                                                         
  cxSetResourceString(@sdxExpandButtons,'չ����ť');
  //tt8//'E&xpand Buttons');                                                                                                                                                                                             
  cxSetResourceString(@sdxCheckMarks,'�����');
  //tt8//'Check Marks');                                                                                                                                                                                                    
  cxSetResourceString(@sdxTreeEffects,'��Ч��');
  //tt8//'Tree Effects');                                                                                                                                                                                                    
  cxSetResourceString(@sdxAppearance,'���');
  //tt8//'Appearance');                                                                                                                                                                                                         
                                                                                                                                                                                                                                                          
  { Designer previews }                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                          
  { Localize if you want (they are used inside FormatReport dialog -> ReportPreview) }                                                                                                                                                                    
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCarLevelCaption,'����');
  //tt8//'Cars');                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxManufacturerBandCaption,'Manufacturer Data');                                                                                                                                                                                                       
  cxSetResourceString(@sdxModelBandCaption,'��������');
  //tt8//'Car Data');                                                                                                                                                                                                 
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxManufacturerNameColumnCaption,'Name');                                                                                                                                                                                                              
  cxSetResourceString(@sdxManufacturerLogoColumnCaption,'Logo');                                                                                                                                                                                                              
  cxSetResourceString(@sdxManufacturerCountryColumnCaption,'Country');                                                                                                                                                                                                        
  cxSetResourceString(@sdxCarModelColumnCaption,'ģ��');
  //tt8//'Model');                                                                                                                                                                                                   
  cxSetResourceString(@sdxCarIsSUVColumnCaption,'SUV');
  //tt8//'SUV');                                                                                                                                                                                                      
  cxSetResourceString(@sdxCarPhotoColumnCaption,'��Ƭ');
  //tt8//'Photo');                                                                                                                                                                                                   
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCarManufacturerName1,'BMW');                                                                                                                                                                                                                        
  cxSetResourceString(@sdxCarManufacturerName2,'Ford');                                                                                                                                                                                                                       
  cxSetResourceString(@sdxCarManufacturerName3,'Audi');                                                                                                                                                                                                                       
  cxSetResourceString(@sdxCarManufacturerName4,'Land Rover');                                                                                                                                                                                                                 
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCarManufacturerCountry1,'Germany');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxCarManufacturerCountry2,'United States');                                                                                                                                                                                                           
  cxSetResourceString(@sdxCarManufacturerCountry3,'Germany');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxCarManufacturerCountry4,'United Kingdom');                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCarModel1,'X5 4WD');
  //tt8//'X5 4.6is');                                                                                                                                                                                                          
  cxSetResourceString(@sdxCarModel2,'����');
  //tt8//'Excursion');                                                                                                                                                                                                           
  cxSetResourceString(@sdxCarModel3,'S8 Quattro');
  //tt8//'S8 Quattro');                                                                                                                                                                                                    
  cxSetResourceString(@sdxCarModel4,'G4 ��ս');
  //tt8//'G4 Challenge');                                                                                                                                                                                                     
                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxTrue,'��');
  //tt8//'True');                                                                                                                                                                                                                       
  cxSetResourceString(@sdxFalse,'��');
  //tt8//'False');                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                          
  { PS 2.4 }                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                          
  { dxPrnDev.pas }                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxAuto,'�Զ�');
  //tt8//'Auto');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxCustom,'����');
  //tt8//'Custom');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxEnv,'Env');
  //tt8//'Env');                                                                                                                                                                                                                        
                                                                                                                                                                                                                                                          
  { Grid 4 }                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxLookAndFeelFlat,'ƽ��');
  //tt8//'Flat');                                                                                                                                                                                                          
  cxSetResourceString(@sdxLookAndFeelStandard,'��׼');
  //tt8//'Standard');                                                                                                                                                                                                  
  cxSetResourceString(@sdxLookAndFeelUltraFlat,'��ƽ��');
  //tt8//'UltraFlat');                                                                                                                                                                                              
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxViewTab,'��ͼ');
  //tt8//'View');                                                                                                                                                                                                                  
  cxSetResourceString(@sdxBehaviorsTab,'����');
  //tt8//'Behaviors');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPreviewTab,'Ԥ��');
  //tt8//'Preview');                                                                                                                                                                                                            
  cxSetResourceString(@sdxCardsTab,'��Ƭ');
  //tt8//'Cards');                                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxFormatting,'��ʽ');
  //tt8//'Formatting');                                                                                                                                                                                                         
  cxSetResourceString(@sdxLookAndFeel,'���');
  //tt8//'Look and Feel');                                                                                                                                                                                                     
  cxSetResourceString(@sdxLevelCaption,'����');
  //tt8//'&Caption');                                                                                                                                                                                                         
  cxSetResourceString(@sdxFilterBar,'������״̬��');
  //tt8//'&Filter Bar');                                                                                                                                                                                                 
  cxSetResourceString(@sdxRefinements,'����');
  //tt8//'Refinements');                                                                                                                                                                                                       
  cxSetResourceString(@sdxProcessSelection,'����ѡ��(&S)');
  //tt8//'Process &Selection');                                                                                                                                                                                   
  cxSetResourceString(@sdxProcessExactSelection,'����ȷѡ��(&X)');
  //tt8//'Process E&xact Selection');                                                                                                                                                                    
  cxSetResourceString(@sdxExpanding,'����');
  //tt8//'Expanding');                                                                                                                                                                                                           
  cxSetResourceString(@sdxGroups,'��(&G)');
  //tt8//'&Groups');                                                                                                                                                                                                              
  cxSetResourceString(@sdxDetails,'ϸ��(&D)');
  //tt8//'&Details');                                                                                                                                                                                                          
  cxSetResourceString(@sdxStartFromActiveDetails,'�ӵ�ǰϸ�ڿ�ʼ');
  //tt8//'Start from Active Details');                                                                                                                                                                    
  cxSetResourceString(@sdxOnlyActiveDetails,'������ǰϸ��');
  //tt8//'Only Active Details');                                                                                                                                                                                 
  cxSetResourceString(@sdxVisible,'�ɼ�(&V)');
  //tt8//'&Visible');                                                                                                                                                                                                          
  cxSetResourceString(@sdxPreviewAutoHeight,'�Զ��߶�(&U)');
  //tt8//'A&uto Height');                                                                                                                                                                                        
  cxSetResourceString(@sdxPreviewMaxLineCount,'����м���(&M)�� ');
  //tt8//'&Max Line Count: ');                                                                                                                                                                            
  cxSetResourceString(@sdxSizes,'��С');
  //tt8//'Sizes');                                                                                                                                                                                                                   
  cxSetResourceString(@sdxKeepSameWidth,'����ͬ�����(&K)');
  //tt8//'&Keep Same Width');                                                                                                                                                                                    
  cxSetResourceString(@sdxKeepSameHeight,'����ͬ���߶�(&H)');
  //tt8//'Keep Same &Height');                                                                                                                                                                                  
  cxSetResourceString(@sdxFraming,'���');
  //tt8//'Framing');                                                                                                                                                                                                               
  cxSetResourceString(@sdxSpacing,'���');
  //tt8//'Spacing');                                                                                                                                                                                                               
  cxSetResourceString(@sdxShadow,'��Ӱ');
  //tt8//'Shadow');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxDepth,'Ũ��(&D):');
  //tt8//'&Depth:');                                                                                                                                                                                                            
  cxSetResourceString(@sdxPosition,'λ��(&P)');
  //tt8//'&Position');                                                                                                                                                                                                        
  cxSetResourceString(@sdxPositioning,'λ��');
  //tt8//'Positioning');                                                                                                                                                                                                       
  cxSetResourceString(@sdxHorizontal,'ˮƽ(&O):');
  //tt8//'H&orizontal:');                                                                                                                                                                                                  
  cxSetResourceString(@sdxVertical,'��ֱ(&E):');
  //tt8//'V&ertical:');                                                                                                                                                                                                      
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxSummaryFormat,'����,0');
  //tt8//'Count,0');                                                                                                                                                                                                   
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxCannotUseOnEveryPageMode,'����ʹ����ÿҳ��ʽ'+#13#10+
  //tt8//'Cannot Use OnEveryPage Mode'+ #13#10 +                                                                                                                                            
    #13#10 +                                                                                                                                                                                                                                              
    'You should or(and)' + #13#10 +                                                                                                                                                                                                                       
    '  - Collapse all Master Records' + #13#10 +                                                                                                                                                                                                          
    '  - Toggle "Unwrap" Option off on "Behaviors" Tab');                                                                                                                                                                                                  
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxIncorrectBandHeadersState,'����ʹ�ô�����ͷ��ÿһҳ��ʽ'+#13#10+
  //tt8//'Cannot Use BandHeaders OnEveryPage Mode' + #13#10 +                                                                                                                    
    #13#10 +                                                                                                                                                                                                                                              
    'You should either:' + #13#10 +                                                                                                                                                                                                                       
    '  - Set Caption OnEveryPage Option On' + #13#10 +                                                                                                                                                                                                    
    '  - Set Caption Visible Option Off');                                                                                                                                                                                                                 
  cxSetResourceString(@sdxIncorrectHeadersState,'����ʹ�ñ�ͷ��ÿһҳ��ʽ'+#13#10+
  //tt8//'Cannot Use Headers OnEveryPage Mode' + #13#10 +                                                                                                                                
    #13#10 +                                                                                                                                                                                                                                              
    'You should either:' + #13#10 +                                                                                                                                                                                                                       
    '  - Set Caption and Band OnEveryPage Option On' + #13#10 +                                                                                                                                                                                           
    '  - Set Caption and Band Visible Option Off');                                                                                                                                                                                                        
  cxSetResourceString(@sdxIncorrectFootersState,'����ʹ��ҳ����ÿһҳ��ʽ'+#13#10+
  //tt8//'Cannot Use Footers OnEveryPage Mode' + #13#10 +                                                                                                                                
    #13#10 +                                                                                                                                                                                                                                              
    'You should either:' + #13#10 +                                                                                                                                                                                                                       
    '  - Set FilterBar OnEveryPage Option On' + #13#10 +                                                                                                                                                                                                  
    '  - Set FilterBar Visible Option Off');

  cxSetResourceString(@sdxCharts,'ͼ��');
  //sdl//'Charts'
                                                                                                                                                                                                                                                          
  { PS 3 }                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxTPicture,'TPicture');                                                                                                                                                                                                                               
  cxSetResourceString(@sdxCopy,'&Copy');                                                                                                                                                                                                                                      
  cxSetResourceString(@sdxSave,'&Save...');                                                                                                                                                                                                                                   
  cxSetResourceString(@sdxBaseStyle,'Base Style');                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxComponentAlreadyExists,'Component named "%s" already exists');                                                                                                                                                                                      
  cxSetResourceString(@sdxInvalidComponentName,'"%s" is not a valid component name');
  
  { shapes } 
 
  cxSetResourceString(@sdxRectangle,'Rectangle');
  cxSetResourceString(@sdxSquare,'Square');
  cxSetResourceString(@sdxEllipse,'Ellipse');
  cxSetResourceString(@sdxCircle,'Circle');
  cxSetResourceString(@sdxRoundRect,'RoundRect');
  cxSetResourceString(@sdxRoundSquare,'RoundSquare');

  { standard pattern names}
    
  cxSetResourceString(@sdxHorizontalFillPattern,'Horizontal');
  cxSetResourceString(@sdxVerticalFillPattern,'Vertical');
  cxSetResourceString(@sdxFDiagonalFillPattern,'FDiagonal');
  cxSetResourceString(@sdxBDiagonalFillPattern,'BDiagonal');
  cxSetResourceString(@sdxCrossFillPattern,'Cross');
  cxSetResourceString(@sdxDiagCrossFillPattern,'DiagCros');
  
  { explorer }
                                                             
  cxSetResourceString(@sdxCyclicIDReferences,'Cyclic ID references %s and %s');
  cxSetResourceString(@sdxLoadReportDataToFileTitle,'Load Report');
  cxSetResourceString(@sdxSaveReportDataToFileTitle,'Save Report As');
  cxSetResourceString(@sdxInvalidExternalStorage,'Invalid External Storage');
  cxSetResourceString(@sdxLinkIsNotIncludedInUsesClause,
    'ReportFile contains ReportLink "%0:s"' + #13#10 + 
    'Unit with declaration of "%0:s" must be included in uses clause');
  cxSetResourceString(@sdxInvalidStorageVersion,'Invalid Storage Verison: %d');
  cxSetResourceString(@sdxPSReportFiles,'Report Files');
  cxSetResourceString(@sdxReportFileLoadError,
    'Cannot load Report File "%s".' + #13#10 + 
    'File is corrupted or is locked by another User or Application.' + #13#10 + 
    #13#10 +
    'Original Report will be restored.');
  
  cxSetResourceString(@sdxNone,'(None)');
  cxSetResourceString(@sdxReportDocumentIsCorrupted,'(File is not a ReportDocument or Corrupted)');
  
  cxSetResourceString(@sdxCloseExplorerHint,'Close Explorer');
  cxSetResourceString(@sdxExplorerCaption,'Explorer');
  cxSetResourceString(@sdxExplorerRootFolderCaption,'Root');
  cxSetResourceString(@sdxNewExplorerFolderItem,'New Folder');
  cxSetResourceString(@sdxCopyOfItem,'Copy of ');
  cxSetResourceString(@sdxReportExplorer,'Report Explorer');
                                
  cxSetResourceString(@sdxDataLoadErrorText,'Cannot load Report Data');
  cxSetResourceString(@sdxDBBasedExplorerItemDataLoadError,
    'Cannot load Report Data.' + #13#10 + 
    'Data are corrupted or are locked');
  cxSetResourceString(@sdxFileBasedExplorerItemDataLoadError,
    'Cannot load Report Data.' + #13#10 + 
    'File is corruted or is locked by another User or Application');
  cxSetResourceString(@sdxDeleteNonEmptyFolderMessageText,'Folder "%s" is not Empty. Delete anyway?');
  cxSetResourceString(@sdxDeleteFolderMessageText,'Delete Folder "%s" ?');
  cxSetResourceString(@sdxDeleteItemMessageText,'Delete Item "%s" ?');
  cxSetResourceString(@sdxCannotRenameFolderText,'Cannot rename folder "%s". A folder with name "%s" already exists. Specify a different name.');
  cxSetResourceString(@sdxCannotRenameItemText,'Cannot rename item "%s". An item with name "%s" already exists. Specify a different name.');
  cxSetResourceString(@sdxOverwriteFolderMessageText,
    'This folder "%s" already contains folder named "%s".' + #13#10 + 
    #13#10 + 
    'If the items in existing folder have the same name as items in the' + #13#10 + 
    'folder you are moving or copying, they will be replaced. Do you still?' + #13#10 +
    'want to move or copy the folder?');
  cxSetResourceString(@sdxOverwriteItemMessageText,
    'This Folder "%s" already contains item named "%s".' + #13#10 + 
    #13#10 + 
    'Would you like to overwrite existing item?');
  cxSetResourceString(@sdxSelectNewRoot,'Select new Root Directory where the Reports will be stored');
  cxSetResourceString(@sdxInvalidFolderName,'Invalid Folder Name "%s"');
  cxSetResourceString(@sdxInvalidReportName,'Invalid Report Name "%s"');
  
  cxSetResourceString(@sdxExplorerBar,'Explorer');

  cxSetResourceString(@sdxMenuFileSave,'&Save');
  cxSetResourceString(@sdxMenuFileSaveAs,'Save &As...');
  cxSetResourceString(@sdxMenuFileLoad,'&Load');
  cxSetResourceString(@sdxMenuFileClose,'U&nload');
  cxSetResourceString(@sdxHintFileSave,'Save Report');
  cxSetResourceString(@sdxHintFileSaveAs,'Save Report As');
  cxSetResourceString(@sdxHintFileLoad,'Load Report');
  cxSetResourceString(@sdxHintFileClose,'Unload Report');
  
  cxSetResourceString(@sdxMenuExplorer,'E&xplorer');
  cxSetResourceString(@sdxMenuExplorerCreateFolder,'Create &Folder');
  cxSetResourceString(@sdxMenuExplorerDelete,'&Delete...');
  cxSetResourceString(@sdxMenuExplorerRename,'Rena&me');
  cxSetResourceString(@sdxMenuExplorerProperties,'&Properties...');
  cxSetResourceString(@sdxMenuExplorerRefresh,'Refresh');
  cxSetResourceString(@sdxMenuExplorerChangeRootPath,'Change Root...');
  cxSetResourceString(@sdxMenuExplorerSetAsRoot,'Set As Root');
  cxSetResourceString(@sdxMenuExplorerGoToUpOneLevel,'Up One Level');

  cxSetResourceString(@sdxHintExplorerCreateFolder,'Create New Folder');
  cxSetResourceString(@sdxHintExplorerDelete,'Delete');
  cxSetResourceString(@sdxHintExplorerRename,'Rename');
  cxSetResourceString(@sdxHintExplorerProperties,'Properties');
  cxSetResourceString(@sdxHintExplorerRefresh,'Refresh');
  cxSetResourceString(@sdxHintExplorerChangeRootPath,'Change Root');
  cxSetResourceString(@sdxHintExplorerSetAsRoot,'Set Current Folder as Root');
  cxSetResourceString(@sdxHintExplorerGoToUpOneLevel,'Up One Level');
  
  cxSetResourceString(@sdxMenuViewExplorer,'E&xplorer');
  cxSetResourceString(@sdxHintViewExplorer,'Show Explorer');

  cxSetResourceString(@sdxSummary,'Summary');
  cxSetResourceString(@sdxCreator,'Creato&r:');
  cxSetResourceString(@sdxCreationDate,'Create&d:');
 
  cxSetResourceString(@sdxMenuViewThumbnails,'Th&umbnails');
  cxSetResourceString(@sdxMenuThumbnailsLarge,'&Large Thumbnails');
  cxSetResourceString(@sdxMenuThumbnailsSmall,'&Small Thumbnails');
  
  cxSetResourceString(@sdxHintViewThumbnails,'Show Thumbnails');
  cxSetResourceString(@sdxHintThumbnailsLarge,'Switch to large thumbnails');
  cxSetResourceString(@sdxHintThumbnailsSmall,'Switch to small thumbnails');
    
  cxSetResourceString(@sdxMenuFormatTitle,'T&itle...');
  cxSetResourceString(@sdxHintFormatTitle,'Format Report Title');

  cxSetResourceString(@sdxHalf,'һ��');
  //tt8//'Half');                                                                                                                                                                                                                     
  cxSetResourceString(@sdxPredefinedFunctions,'Ԥ���庯��'); // dxPgsDlg.pas
  //tt8//' Predefined Functions '); // dxPgsDlg.pas                                                                                                                                              
  cxSetResourceString(@sdxZoomParameters,'���Ų���(&P)');          // dxPSPrvwOpt.pas
  //tt8//' Zoom &Parameters ');          // dxPSPrvwOpt.pas                                                                                                                             
                                                                                                                                                                                                                                                          
  cxSetResourceString(@sdxWrapData,'��װ����');
  //tt8//'&Wrap Data');

  {cxSetResourceString(@sdxMenuShortcutExplorer,'Explorer');
  cxSetResourceString(@sdxExplorerToolBar,'Explorer');

  cxSetResourceString(@sdxMenuShortcutThumbnails,'Thumbnails');
  
  { TreeView New}
  
 { cxSetResourceString(@sdxButtons,'Buttons');
  
  { ListView }

 { cxSetResourceString(@sdxBtnHeadersFont,'&Headers Font...');
  cxSetResourceString(@sdxHeadersTransparent,'Transparent &Headers');
  cxSetResourceString(@sdxHintListViewDesignerMessage,' Most Options Are Being Taken Into Account Only In Detailed View');
  cxSetResourceString(@sdxColumnHeaders,'&Column Headers');
  
  { Group LookAndFeel Names }

 { cxSetResourceString(@sdxReportGroupNullLookAndFeel,'Null');
  cxSetResourceString(@sdxReportGroupStandardLookAndFeel,'Standard');
  cxSetResourceString(@sdxReportGroupOfficeLookAndFeel,'Office');  
  cxSetResourceString(@sdxReportGroupWebLookAndFeel,'Web');
  
  cxSetResourceString(@sdxLayoutGroupDefaultCaption,'Layout Group');
  cxSetResourceString(@sdxLayoutItemDefaultCaption,'Layout Item');

  { Designer Previews}

  { Localize if you want (they are used inside FormatReport dialog -> ReportPreview) }
    
 { cxSetResourceString(@sdxCarManufacturerName5,'DaimlerChrysler AG');
  cxSetResourceString(@sdxCarManufacturerCountry5,'Germany');
  cxSetResourceString(@sdxCarModel5,'Maybach 62');

  cxSetResourceString(@sdxLuxurySedans,'Luxury Sedans');
  cxSetResourceString(@sdxCarManufacturer,'Manufacturer');
  cxSetResourceString(@sdxCarModel,'Model');
  cxSetResourceString(@sdxCarEngine,'Engine');
  cxSetResourceString(@sdxCarTransmission,'Transmission');
  cxSetResourceString(@sdxCarTires,'Tires');
  cxSetResourceString(@sdx760V12Manufacturer,'BMW');
  cxSetResourceString(@sdx760V12Model,'760Li V12');
  cxSetResourceString(@sdx760V12Engine,'6.0L DOHC V12 438 HP 48V DI Valvetronic 12-cylinder engine with 6.0-liter displacement, dual overhead cam valvetrain');
  cxSetResourceString(@sdx760V12Transmission,'Elec 6-Speed Automatic w/Steptronic');
  cxSetResourceString(@sdx760V12Tires,'P245/45R19 Fr - P275/40R19 Rr Performance. Low Profile tires with 245mm width, 19.0" rim');
      
  { Styles }

 { cxSetResourceString(@sdxBandHeaderStyle,'BandHeader');
  cxSetResourceString(@sdxCaptionStyle,'Caption');
  cxSetResourceString(@sdxCardCaptionRowStyle,'Card Caption Row');
  cxSetResourceString(@sdxCardRowCaptionStyle,'Card Row Caption');
  cxSetResourceString(@sdxCategoryStyle,'Category');
  cxSetResourceString(@sdxContentStyle,'Content');
  cxSetResourceString(@sdxContentEvenStyle,'Content Even Rows');
  cxSetResourceString(@sdxContentOddStyle,'Content Odd Rows');
  cxSetResourceString(@sdxFilterBarStyle,'Filter Bar');
  cxSetResourceString(@sdxFooterStyle,'Footer');
  cxSetResourceString(@sdxFooterRowStyle,'Footer Row');
  cxSetResourceString(@sdxGroupStyle,'Group');
  cxSetResourceString(@sdxHeaderStyle,'Header');
  cxSetResourceString(@sdxIndentStyle,'Indent');
  cxSetResourceString(@sdxPreviewStyle,'Preview');
  cxSetResourceString(@sdxSelectionStyle,'Selection');

  cxSetResourceString(@sdxStyles,'Styles');
  cxSetResourceString(@sdxStyleSheets,'Style Sheets');
  cxSetResourceString(@sdxBtnTexture,'&Texture...');
  cxSetResourceString(@sdxBtnTextureClear,'Cl&ear');
  cxSetResourceString(@sdxBtnColor,'Co&lor...');
  cxSetResourceString(@sdxBtnSaveAs,'Save &As...');
  cxSetResourceString(@sdxBtnRename,'&Rename...');
  
  cxSetResourceString(@sdxLoadBitmapDlgTitle,'Load Texture');
  
  cxSetResourceString(@sdxDeleteStyleSheet,'Delete StyleSheet Named "%s"?');
  cxSetResourceString(@sdxUnnamedStyleSheet,'Unnamed');
  cxSetResourceString(@sdxCreateNewStyleQueryNamePrompt,'Enter New StyleSheet Name: ');
  cxSetResourceString(@sdxStyleSheetNameAlreadyExists,'StyleSheet named "%s" Already Exists');

  cxSetResourceString(@sdxCannotLoadImage,'Cannot Load Image "%s"');
  cxSetResourceString(@sdxUseNativeStyles,'&Use Native Styles');
  cxSetResourceString(@sdxSuppressBackgroundBitmaps,'&Suppress Background Textures');
  cxSetResourceString(@sdxConsumeSelectionStyle,'Consume Selection Style');
  
  { Grid4 new }

 { cxSetResourceString(@sdxSize,'��С');
  //tt8//'Size'); 
  cxSetResourceString(@sdxLevels,'Levels');
  cxSetResourceString(@sdxUnwrap,'&Unwrap');
  cxSetResourceString(@sdxUnwrapTopLevel,'Un&wrap Top Level');
  cxSetResourceString(@sdxRiseActiveToTop,'Rise Active Level onto Top');
  cxSetResourceString(@sdxCannotUseOnEveryPageModeInAggregatedState,
    'Cannot Use OnEveryPage Mode'+ #13#10 + 
    'While Performing in Aggregated State');

  cxSetResourceString(@sdxPagination,'Pagination');
  cxSetResourceString(@sdxByBands,'By Bands');
  cxSetResourceString(@sdxByColumns,'By Columns');
  cxSetResourceString(@sdxByRows,'By &Rows');
  cxSetResourceString(@sdxByTopLevelGroups,'By TopLevel Groups'); 
  cxSetResourceString(@sdxOneGroupPerPage,'One Group Per Page'); 

  {* For those who will translate *}
  {* You should also check "cxSetResourceString(@sdxCannotUseOnEveryPageMode" resource string - see above *}
  {* It was changed to "- Toggle "Unwrap" Option off on "Behaviors" Tab"*}
   
  { TL 4 }
 { cxSetResourceString(@sdxBorders,'Borders');
  cxSetResourceString(@sdxExplicitlyExpandNodes,'Explicitly Expand Nodes');
  cxSetResourceString(@sdxNodes,'&Nodes');
  cxSetResourceString(@sdxSeparators,'Separators');
  cxSetResourceString(@sdxThickness,'Thickness');
  cxSetResourceString(@sdxTLIncorrectHeadersState,
    'Cannot Use Headers OnEveryPage Mode' + #13#10 + 
    #13#10 +
    'You should either:' + #13#10 +
    '  - Set Band OnEveryPage Option On' + #13#10 +
    '  - Set Band Visible Option Off');

  { cxVerticalGrid }

 { cxSetResourceString(@sdxRows,'&Rows');

  cxSetResourceString(@sdxMultipleRecords,'&Multiple Records');
  cxSetResourceString(@sdxBestFit,'&Best Fit');
  cxSetResourceString(@sdxKeepSameRecordWidths,'&Keep Same Record Widths');
  cxSetResourceString(@sdxWrapRecords,'&Wrap Records');

  cxSetResourceString(@sdxByWrapping,'By &Wrapping');
  cxSetResourceString(@sdxOneWrappingPerPage,'&One Wrapping Per Page');

  {new in 3.01}
 { cxSetResourceString(@sdxCurrentRecord,'Current Record');
  cxSetResourceString(@sdxLoadedRecords,'Loaded Records');
  cxSetResourceString(@sdxAllRecords,'All Records');
  
  { Container Designer }
  
 { cxSetResourceString(@sdxPaginateByControlDetails,'Control Details');
  cxSetResourceString(@sdxPaginateByControls,'Controls');
  cxSetResourceString(@sdxPaginateByGroups,'Groups');
  cxSetResourceString(@sdxPaginateByItems,'Items');
  
  cxSetResourceString(@sdxControlsPlace,'Controls Place');
  cxSetResourceString(@sdxExpandHeight,'Expand Height');
  cxSetResourceString(@sdxExpandWidth,'Expand Width');
  cxSetResourceString(@sdxShrinkHeight,'Shrink Height');
  cxSetResourceString(@sdxShrinkWidth,'Shrink Width');
  
  cxSetResourceString(@sdxCheckAll,'Check &All');
  cxSetResourceString(@sdxCheckAllChildren,'Check All &Children');
  cxSetResourceString(@sdxControlsTab,'Controls');
  cxSetResourceString(@sdxExpandAll,'E&xpand All');
  cxSetResourceString(@sdxHiddenControlsTab,'Hidden Controls');
  cxSetResourceString(@sdxReportLinksTab,'Aggregated Designers');
  cxSetResourceString(@sdxAvailableLinks,'&Available Links:');
  cxSetResourceString(@sdxAggregatedLinks,'A&ggregated Links:');
  cxSetResourceString(@sdxTransparents,'Transparents');
  cxSetResourceString(@sdxUncheckAllChildren,'Uncheck &All Children');
  
  cxSetResourceString(@sdxRoot,'&Root');
  cxSetResourceString(@sdxRootBorders,'Root &Borders');
  cxSetResourceString(@sdxControls,'&Controls');
  cxSetResourceString(@sdxContainers,'C&ontainers');

  cxSetResourceString(@sdxHideCustomContainers,'&Hide Custom Containers');

  { General }
  
  // FileSize abbreviation

  {cxSetResourceString(@sdxBytes,'Bytes');
  cxSetResourceString(@sdxKiloBytes,'KB');
  cxSetResourceString(@sdxMegaBytes,'MB');
  cxSetResourceString(@sdxGigaBytes,'GB');

  // Misc.

  cxSetResourceString(@sdxThereIsNoPictureToDisplay,'There is no picture to display');
  cxSetResourceString(@sdxInvalidRootDirectory,'Directory "%s" does not exists. Continue selection ?');
  cxSetResourceString(@sdxPressEscToCancel,'Press Esc to cancel');
  cxSetResourceString(@sdxMenuFileRebuild,'&Rebuild');
  cxSetResourceString(@sdxBuildingReportStatusText,'Building report - Press Esc to cancel');
  cxSetResourceString(@sdxPrintingReportStatusText,'Printing report - Press Esc to cancel');
  
  cxSetResourceString(@sdxBuiltIn,'[BuiltIn]');
  cxSetResourceString(@sdxUserDefined,'[User Defined]');
  cxSetResourceString(@sdxNewStyleRepositoryWasCreated,'New StyleRepository "%s" was created and assigned');

  { new in PS 3.1}
 { cxSetResourceString(@sdxLineSpacing,'&Line spacing:');
  cxSetResourceString(@sdxTextAlignJustified,'Justified');
  cxSetResourceString(@sdxSampleText,'Sample Text Sample Text');
  
  cxSetResourceString(@sdxCardsRows,'&Cards');
  cxSetResourceString(@sdxTransparentRichEdits,'Transparent &RichEdit Content');

  cxSetResourceString(@sdxIncorrectFilterBarState,
    'Cannot Use FilterBar OnEveryPage Mode' + #13#10 +
    #13#10 +
    'You should either:' + #13#10 +  
    '  - Set Caption OnEveryPage Option On' + #13#10 +
    '  - Set Caption Visible Option Off');
  cxSetResourceString(@sdxIncorrectBandHeadersState2,
    'Cannot Use BandHeaders OnEveryPage Mode' + #13#10 +
    #13#10 +
    'You should either:' + #13#10 +  
    '  - Set Caption and FilterBar OnEveryPage Option On' + #13#10 + 
    '  - Set Caption and FilterBar Visible Option Off');
  cxSetResourceString(@sdxIncorrectHeadersState2,
    'Cannot Use Headers OnEveryPage Mode' + #13#10 +
    #13#10 +
    'You should either:' + #13#10 +  
    '  - Set Caption, FilterBar and Band OnEveryPage Option On' + #13#10 +
    '  - Set Caption, FilterBar and Band Visible Option Off');

 { new in PS 3.2}   
{  cxSetResourceString(@sdxAvailableReportLinks,'Available ReportLinks');
  cxSetResourceString(@sdxBtnRemoveInconsistents,'Remove Unneeded');
  cxSetResourceString(@sdxColumnHeadersOnEveryPage,'Column &Headers');
  
 { Scheduler }   

 { cxSetResourceString(@sdxNotes,'Notes');
  cxSetResourceString(@sdxTaskPad,'TaskPad');
  cxSetResourceString(@sdxPrimaryTimeZone,'Primary');
  cxSetResourceString(@sdxSecondaryTimeZone,'Secondary');
  
  cxSetResourceString(@sdxDay,'Day');
  cxSetResourceString(@sdxWeek,'Week');
  cxSetResourceString(@sdxMonth,'Month');
  
  cxSetResourceString(@sdxSchedulerSchedulerHeader,'Scheduler Header');
  cxSetResourceString(@sdxSchedulerContent,'Content');
  cxSetResourceString(@sdxSchedulerDateNavigatorContent,'DateNavigator Content');
  cxSetResourceString(@sdxSchedulerDateNavigatorHeader,'DateNavigator Header');
  cxSetResourceString(@sdxSchedulerDayHeader,'Day Header');
  cxSetResourceString(@sdxSchedulerEvent,'Event');
  cxSetResourceString(@sdxSchedulerResourceHeader,'Resource Header');
  cxSetResourceString(@sdxSchedulerNotesAreaBlank,'Notes Area (Blank)');
  cxSetResourceString(@sdxSchedulerNotesAreaLined,'Notes Area (Lined)');
  cxSetResourceString(@sdxSchedulerTaskPad,'TaskPad');
  cxSetResourceString(@sdxSchedulerTimeRuler,'Time Ruler');
  
  cxSetResourceString(@sdxPrintStyleNameDaily,'Daily');
  cxSetResourceString(@sdxPrintStyleNameWeekly,'Weekly');
  cxSetResourceString(@sdxPrintStyleNameMonthly,'Monthly');
  cxSetResourceString(@sdxPrintStyleNameDetails,'Details');
  cxSetResourceString(@sdxPrintStyleNameMemo,'Memo');
  cxSetResourceString(@sdxPrintStyleNameTrifold,'Trifold');
  
  cxSetResourceString(@sdxPrintStyleCaptionDaily,'Daily Style');
  cxSetResourceString(@sdxPrintStyleCaptionWeekly,'Weekly Style');
  cxSetResourceString(@sdxPrintStyleCaptionMonthly,'Monthly Style');
  cxSetResourceString(@sdxPrintStyleCaptionDetails,'Calendar Details Style');
  cxSetResourceString(@sdxPrintStyleCaptionMemo,'Memo Style');
  cxSetResourceString(@sdxPrintStyleCaptionTrifold,'Tri-fold Style');

  cxSetResourceString(@sdxTabPrintStyles,'Print Styles');
  
  cxSetResourceString(@sdxPrintStyleDontPrintWeekEnds,'&Don''t Print Weekends');
  cxSetResourceString(@sdxPrintStyleInclude,'Include:');
  cxSetResourceString(@sdxPrintStyleIncludeTaskPad,'Task&Pad');
  cxSetResourceString(@sdxPrintStyleIncludeNotesAreaBlank,'Notes Area (&Blank)');
  cxSetResourceString(@sdxPrintStyleIncludeNotesAreaLined,'Notes Area (&Lined)');
  cxSetResourceString(@sdxPrintStyleLayout,'&Layout:');
  cxSetResourceString(@sdxPrintStylePrintFrom,'Print &From:');
  cxSetResourceString(@sdxPrintStylePrintTo,'Print &To:');
  
  cxSetResourceString(@sdxPrintStyleDailyLayout1PPD,'1 page/day');
  cxSetResourceString(@sdxPrintStyleDailyLayout2PPD,'2 pages/day');
  
  cxSetResourceString(@sdxPrintStyleWeeklyArrange,'&Arrange:');
  cxSetResourceString(@sdxPrintStyleWeeklyArrangeT2B,'Top to bottom');
  cxSetResourceString(@sdxPrintStyleWeeklyArrangeL2R,'Left to right');
  cxSetResourceString(@sdxPrintStyleWeeklyLayout1PPW,'1 page/week');
  cxSetResourceString(@sdxPrintStyleWeeklyLayout2PPW,'2 pages/week');

  cxSetResourceString(@sdxPrintStyleMemoPrintOnlySelectedEvents,'Print Only Selected Events');

  cxSetResourceString(@sdxPrintStyleMonthlyLayout1PPM,'1 page/month');
  cxSetResourceString(@sdxPrintStyleMonthlyLayout2PPM,'2 pages/month');
  cxSetResourceString(@sdxPrintStyleMonthlyPrintExactly1MPP,'Print &Exactly One Month Per Page');
  
  cxSetResourceString(@sdxPrintStyleTrifoldSectionModeDailyCalendar,'Daily Calendar');
  cxSetResourceString(@sdxPrintStyleTrifoldSectionModeWeeklyCalendar,'Weekly Calendar');
  cxSetResourceString(@sdxPrintStyleTrifoldSectionModeMonthlyCalendar,'Monthly Calendar');
  cxSetResourceString(@sdxPrintStyleTrifoldSectionModeTaskPad,'TaskPad');
  cxSetResourceString(@sdxPrintStyleTrifoldSectionModeNotesBlank,'Notes (Blank)');
  cxSetResourceString(@sdxPrintStyleTrifoldSectionModeNotesLined,'Notes (Lined)');
  cxSetResourceString(@sdxPrintStyleTrifoldSectionLeft,'&Left Section:');
  cxSetResourceString(@sdxPrintStyleTrifoldSectionMiddle,'&Monthly Section:');
  cxSetResourceString(@sdxPrintStyleTrifoldSectionRight,'&Right Section:');

  cxSetResourceString(@sdxPrintStyleDetailsStartNewPageEach,'Start a New Page Each:');

  cxSetResourceString(@sdxSuppressContentColoration,'Suppress &Content Coloration');
  cxSetResourceString(@sdxOneResourcePerPage,'One &Resource Per Page');

  cxSetResourceString(@sdxPrintRanges,'Print Ranges');
  cxSetResourceString(@sdxPrintRangeStart,'&Start:');
  cxSetResourceString(@sdxPrintRangeEnd,'&End:');
  cxSetResourceString(@sdxHideDetailsOfPrivateAppointments,'&Hide Details of Private Appointments');
  cxSetResourceString(@sdxResourceCountPerPage,'&Resources/Page:');

  cxSetResourceString(@sdxSubjectLabelCaption,'Subject:');
  cxSetResourceString(@sdxLocationLabelCaption,'Location:');
  cxSetResourceString(@sdxStartLabelCaption,'Start:');
  cxSetResourceString(@sdxFinishLabelCaption,'End:');
  cxSetResourceString(@sdxShowTimeAsLabelCaption,'Show Time As:');
  cxSetResourceString(@sdxRecurrenceLabelCaption,'Recurrence:');
  cxSetResourceString(@sdxRecurrencePatternLabelCaption,'Recurrence Pattern:');

  //messages
  cxSetResourceString(@sdxSeeAboveMessage,'Please See Above');
  cxSetResourceString(@sdxAllDayMessage,'All Day');
  cxSetResourceString(@sdxContinuedMessage,'Continued');
  cxSetResourceString(@sdxShowTimeAsFreeMessage,'Free');
  cxSetResourceString(@sdxShowTimeAsTentativeMessage,'Tentative');
  cxSetResourceString(@sdxShowTimeAsOutOfOfficeMessage,'Out of Office');

  cxSetResourceString(@sdxRecurrenceNoneMessage,'(none)');
  cxSetResourceString(@scxRecurrenceDailyMessage,'Daily');
  cxSetResourceString(@scxRecurrenceWeeklyMessage,'Weekly');
  cxSetResourceString(@scxRecurrenceMonthlyMessage,'Monthly');
  cxSetResourceString(@scxRecurrenceYearlyMessage,'Yearly');

  //error messages
  cxSetResourceString(@sdxInconsistentTrifoldStyle,'The Tri-fold style requires at least one calendar section. ' +
    'Select Daily, Weekly, or Monthly Calendar for one of section under Options.');
  cxSetResourceString(@sdxBadTimePrintRange,'The hours to print are not valid. The start time must precede the end time.');
  cxSetResourceString(@sdxBadDatePrintRange,'The date in the End box cannot be prior to the date in the Start box.');
  cxSetResourceString(@sdxCannotPrintNoSelectedItems,'Cannot print unless an item is selected. Select an item, and then try to print again.');
  cxSetResourceString(@sdxCannotPrintNoItemsAvailable,'No items available within the specified print range.');      }
  //-------------------------------------------------------------------------
end;

initialization
  toChinese;

finalization

end.

