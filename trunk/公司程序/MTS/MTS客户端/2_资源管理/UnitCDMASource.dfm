object FormCDMASource: TFormCDMASource
  Left = 0
  Top = 0
  Caption = 'CDMA'#20449#28304#32500#25252
  ClientHeight = 470
  ClientWidth = 797
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 288
    Align = alBottom
    Caption = 'CDMA'#20449#24687#24405#20837
    Style.Shadow = True
    TabOrder = 0
    Height = 182
    Width = 797
    object cxLabel1: TcxLabel
      Left = 24
      Top = 18
      AutoSize = False
      Caption = #20449#28304#32534#21495
      Height = 16
      Width = 80
    end
    object cxLabel2: TcxLabel
      Left = 212
      Top = 18
      AutoSize = False
      Caption = #20449#28304#21517#31216
      Height = 16
      Width = 80
    end
    object cxLabel3: TcxLabel
      Left = 400
      Top = 18
      AutoSize = False
      Caption = #20449#28304#31867#22411
      Height = 16
      Width = 80
    end
    object cxLabel4: TcxLabel
      Left = 24
      Top = 111
      AutoSize = False
      Caption = #23433#35013#20301#32622
      Height = 16
      Width = 80
    end
    object cxLabel5: TcxLabel
      Left = 212
      Top = 41
      AutoSize = False
      Caption = #25152#23646#23460#20998#28857
      Height = 16
      Width = 80
    end
    object cxLabel6: TcxLabel
      Left = 400
      Top = 111
      AutoSize = False
      Caption = #35206#30422#33539#22260
      Height = 16
      Width = 80
    end
    object cxLabel7: TcxLabel
      Left = 589
      Top = 87
      AutoSize = False
      Caption = #20449#28304#21378#23478
      Height = 16
      Width = 80
    end
    object cxLabel8: TcxLabel
      Left = 400
      Top = 87
      AutoSize = False
      Caption = #35774#22791#22411#21495
      Height = 16
      Width = 80
    end
    object cxLabel10: TcxLabel
      Left = 24
      Top = 64
      AutoSize = False
      Caption = #24402#23646'MSC'#32534#21495
      Height = 16
      Width = 80
    end
    object cxLabel11: TcxLabel
      Left = 212
      Top = 64
      AutoSize = False
      Caption = #24402#23646'BSC'#32534#21495
      Height = 16
      Width = 80
    end
    object cxLabel12: TcxLabel
      Left = 400
      Top = 64
      AutoSize = False
      Caption = #24402#23646#25159#21306#32534#21495
      Height = 16
      Width = 80
    end
    object cxLabel13: TcxLabel
      Left = 589
      Top = 64
      AutoSize = False
      Caption = #24402#23646#22522#31449#32534#21495
      Height = 16
      Width = 80
    end
    object cxHeader1: TcxHeader
      Left = 24
      Top = 135
      Width = 737
      Height = 1
      Color = clWindowText
      LookAndFeel.Kind = lfOffice11
      ParentColor = False
      Sections = <>
    end
    object cxButtonAdd: TcxButton
      Left = 330
      Top = 145
      Width = 75
      Height = 25
      Caption = #26032#22686
      TabOrder = 13
      OnClick = cxButtonAddClick
    end
    object cxButtonModify: TcxButton
      Left = 415
      Top = 145
      Width = 75
      Height = 25
      Caption = #20462#25913
      TabOrder = 14
      OnClick = cxButtonModifyClick
    end
    object cxButtonDel: TcxButton
      Left = 501
      Top = 145
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 15
      OnClick = cxButtonDelClick
    end
    object cxButtonClear: TcxButton
      Left = 586
      Top = 145
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 16
      OnClick = cxButtonClearClick
    end
    object cxButtonClose: TcxButton
      Left = 672
      Top = 145
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 17
      OnClick = cxButtonCloseClick
    end
    object cxLabel9: TcxLabel
      Left = 212
      Top = 87
      AutoSize = False
      Caption = 'PN '#30721
      Height = 16
      Width = 80
    end
    object cxLabel14: TcxLabel
      Left = 24
      Top = 87
      AutoSize = False
      Caption = #20449#28304#21151#29575
      Height = 16
      Width = 80
    end
    object cxLabel15: TcxLabel
      Left = 24
      Top = 41
      AutoSize = False
      Caption = #25152#23646#20998#23616
      Height = 16
      Width = 80
    end
    object cxLabel16: TcxLabel
      Left = 589
      Top = 18
      AutoSize = False
      Caption = #26159#21542#23460#20998
      Height = 16
      Width = 80
    end
    object cxLabel17: TcxLabel
      Left = 400
      Top = 41
      AutoSize = False
      Caption = #32463#24230
      Height = 16
      Width = 80
    end
    object cxLabel18: TcxLabel
      Left = 589
      Top = 41
      AutoSize = False
      Caption = #32428#24230
      Height = 16
      Width = 80
    end
    object cxComboBoxSuburb: TcxComboBox
      Left = 103
      Top = 40
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxSuburbPropertiesChange
      TabOrder = 28
      Width = 100
    end
    object cxComboBoxBuilding: TcxComboBox
      Left = 292
      Top = 40
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxBuildingPropertiesChange
      TabOrder = 29
      Width = 100
    end
    object cxComboBoxIsProgram: TcxComboBox
      Left = 673
      Top = 17
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        #23460#22806
        #23460#20869)
      Properties.OnChange = cxComboBoxIsProgramPropertiesChange
      TabOrder = 27
      Width = 100
    end
    object cxComboBoxDeviceType: TcxComboBox
      Left = 482
      Top = 86
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 38
      Width = 100
    end
    object cxComboBoxFactory: TcxComboBox
      Left = 673
      Top = 86
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 39
      Width = 100
    end
    object cxComboBoxCDMAType: TcxComboBox
      Left = 482
      Top = 17
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        #30452#25918#31449
        'RRU'
        #23439#22522#31449)
      TabOrder = 26
      Width = 100
    end
    object cxComboBoxPower: TcxComboBox
      Left = 103
      Top = 86
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 36
      Width = 100
    end
    object cxTextEditCDMANO: TcxTextEdit
      Left = 103
      Top = 17
      TabOrder = 24
      Width = 100
    end
    object cxTextEditCDMANAME: TcxTextEdit
      Left = 292
      Top = 17
      TabOrder = 25
      Width = 100
    end
    object cxTextEditLONGITUDE: TcxTextEdit
      Left = 482
      Top = 40
      TabOrder = 30
      OnExit = cxTextEditLONGITUDEExit
      Width = 100
    end
    object cxTextEditLATITUDE: TcxTextEdit
      Left = 673
      Top = 40
      TabOrder = 31
      OnExit = cxTextEditLONGITUDEExit
      Width = 100
    end
    object cxTextEditBELONG_MSC: TcxTextEdit
      Left = 103
      Top = 63
      TabOrder = 32
      Width = 100
    end
    object cxTextEditBELONG_BSC: TcxTextEdit
      Left = 292
      Top = 63
      TabOrder = 33
      Width = 100
    end
    object cxTextEditBELONG_CELL: TcxTextEdit
      Left = 482
      Top = 63
      TabOrder = 34
      Width = 100
    end
    object cxTextEditBELONG_BTS: TcxTextEdit
      Left = 673
      Top = 63
      TabOrder = 35
      Width = 100
    end
    object cxTextEditADDRESS: TcxTextEdit
      Left = 103
      Top = 110
      TabOrder = 40
      Width = 289
    end
    object cxTextEditCOVER: TcxTextEdit
      Left = 482
      Top = 110
      TabOrder = 41
      Width = 291
    end
    object cxTextEditPN: TcxTextEdit
      Left = 292
      Top = 86
      TabOrder = 37
      Width = 100
    end
  end
  object cxGroupBox2: TcxGroupBox
    Left = 0
    Top = 0
    Align = alClient
    Style.BorderStyle = ebsNone
    Style.Shadow = False
    TabOrder = 1
    Height = 288
    Width = 797
    object cxGrid1: TcxGrid
      Left = 2
      Top = 17
      Width = 793
      Height = 269
      Align = alClient
      TabOrder = 0
      object cxGrid1DBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        OnFocusedRecordChanged = cxGrid1DBTableView1FocusedRecordChanged
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 448
    Top = 184
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 480
    Top = 184
  end
end
