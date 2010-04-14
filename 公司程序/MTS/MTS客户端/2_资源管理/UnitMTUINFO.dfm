object FormMTUINFO: TFormMTUINFO
  Left = 0
  Top = 0
  Caption = 'MTU'#20449#24687#31649#29702
  ClientHeight = 452
  ClientWidth = 797
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
    Top = 248
    Align = alBottom
    Caption = 'MTU'#20449#24687#24405#20837
    Style.Shadow = True
    TabOrder = 0
    Height = 204
    Width = 797
    object cxLabel1: TcxLabel
      Left = 24
      Top = 18
      AutoSize = False
      Caption = 'MTU'#32534#21495
      Height = 16
      Width = 80
    end
    object cxLabel2: TcxLabel
      Left = 212
      Top = 18
      AutoSize = False
      Caption = 'MTU'#21517#31216
      Height = 16
      Width = 80
    end
    object cxLabel3: TcxLabel
      Left = 400
      Top = 18
      AutoSize = False
      Caption = 'MTU'#31867#22411
      Height = 16
      Width = 80
    end
    object cxLabel4: TcxLabel
      Left = 24
      Top = 133
      AutoSize = False
      Caption = 'MTU'#20301#32622
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
      Top = 133
      AutoSize = False
      Caption = #35206#30422#33539#22260
      Height = 16
      Width = 80
    end
    object cxLabel8: TcxLabel
      Left = 400
      Top = 87
      AutoSize = False
      Caption = #20027#30417#25511'C'#32593
      Height = 16
      Width = 80
    end
    object cxLabel10: TcxLabel
      Left = 24
      Top = 64
      AutoSize = False
      Caption = #19978#31471#36830#25509#22120
      Height = 16
      Width = 80
    end
    object cxLabel11: TcxLabel
      Left = 212
      Top = 64
      AutoSize = False
      Caption = #30005#35805#21495#30721
      Height = 16
      Width = 80
    end
    object cxLabel12: TcxLabel
      Left = 400
      Top = 64
      AutoSize = False
      Caption = #34987#21483#21495#30721
      Height = 16
      Width = 80
    end
    object cxLabel13: TcxLabel
      Left = 589
      Top = 64
      AutoSize = False
      Caption = #21578#35686#38376#38480#27169#26495
      Height = 16
      Width = 80
    end
    object cxHeader1: TcxHeader
      Left = 24
      Top = 156
      Width = 737
      Height = 1
      Color = clWindowText
      ParentColor = False
      Sections = <>
    end
    object cxButtonAdd: TcxButton
      Left = 330
      Top = 166
      Width = 75
      Height = 25
      Caption = #26032#22686
      TabOrder = 11
      OnClick = cxButtonAddClick
    end
    object cxButtonModify: TcxButton
      Left = 415
      Top = 166
      Width = 75
      Height = 25
      Caption = #20462#25913
      TabOrder = 12
      OnClick = cxButtonModifyClick
    end
    object cxButtonDel: TcxButton
      Left = 501
      Top = 166
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 13
      OnClick = cxButtonDelClick
    end
    object cxButtonClear: TcxButton
      Left = 586
      Top = 166
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 14
      OnClick = cxButtonClearClick
    end
    object cxButtonClose: TcxButton
      Left = 672
      Top = 166
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 15
      OnClick = cxButtonCloseClick
    end
    object cxLabel9: TcxLabel
      Left = 212
      Top = 87
      AutoSize = False
      Caption = #20027#30417#25511'PHS'
      Height = 16
      Width = 80
    end
    object cxLabel14: TcxLabel
      Left = 24
      Top = 87
      AutoSize = False
      Caption = #20027#30417#25511'AP'
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
      TabOrder = 27
      Width = 100
    end
    object cxComboBoxBuilding: TcxComboBox
      Left = 292
      Top = 40
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxBuildingPropertiesChange
      TabOrder = 28
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
      TabOrder = 26
      Width = 100
    end
    object cxComboBoxCNET: TcxComboBox
      Left = 482
      Top = 86
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxAPPropertiesChange
      TabOrder = 37
      Width = 100
    end
    object cxComboBoxAP: TcxComboBox
      Left = 103
      Top = 86
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxAPPropertiesChange
      TabOrder = 35
      Width = 100
    end
    object cxTextEditMTUNO: TcxTextEdit
      Left = 103
      Top = 17
      TabOrder = 23
      Width = 100
    end
    object cxTextEditMTUNAME: TcxTextEdit
      Left = 292
      Top = 17
      TabOrder = 24
      Width = 100
    end
    object cxTextEditLONGITUDE: TcxTextEdit
      Left = 482
      Top = 40
      TabOrder = 29
      OnExit = cxTextEditLONGITUDEExit
      Width = 100
    end
    object cxTextEditLATITUDE: TcxTextEdit
      Left = 673
      Top = 40
      TabOrder = 30
      OnExit = cxTextEditLONGITUDEExit
      Width = 100
    end
    object cxTextEditCall: TcxTextEdit
      Left = 292
      Top = 63
      TabOrder = 32
      OnKeyPress = cxTextEditCallKeyPress
      Width = 100
    end
    object cxTextEditCalled: TcxTextEdit
      Left = 482
      Top = 63
      TabOrder = 33
      OnKeyPress = cxTextEditCallKeyPress
      Width = 100
    end
    object cxTextEditADDRESS: TcxTextEdit
      Left = 103
      Top = 132
      TabOrder = 43
      Width = 289
    end
    object cxTextEditCOVER: TcxTextEdit
      Left = 482
      Top = 132
      TabOrder = 44
      Width = 291
    end
    object cxLabel19: TcxLabel
      Left = 24
      Top = 110
      AutoSize = False
      Caption = 'C'#32593#20449#28304#31867#22411
      Height = 16
      Width = 80
    end
    object cxLabel20: TcxLabel
      Left = 589
      Top = 110
      AutoSize = False
      Caption = 'C'#32593#20449#28304#20301#32622
      Height = 16
      Width = 80
    end
    object cxLabel21: TcxLabel
      Left = 212
      Top = 110
      AutoSize = False
      Caption = 'PN'#30721
      Height = 16
      Width = 80
    end
    object cxComboBoxMTUType: TcxComboBox
      Left = 482
      Top = 17
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        'PHS'
        'WLAN'
        'CDMA'
        'PHS+WLAN'
        'PHS+CDMA'
        'WLAN+CDMA'
        'PHS+WLAN+CDMA')
      TabOrder = 25
      Width = 100
    end
    object cxComboBoxLink: TcxComboBox
      Left = 103
      Top = 63
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 31
      Width = 100
    end
    object cxComboBoxModel: TcxComboBox
      Left = 673
      Top = 63
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 34
      Width = 100
    end
    object cxComboBoxPHS: TcxComboBox
      Left = 292
      Top = 86
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxAPPropertiesChange
      TabOrder = 36
      Width = 100
    end
    object cxTextEditCNETType: TcxTextEdit
      Left = 103
      Top = 109
      Hint = #19981#21487#20462#25913
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 39
      Width = 100
    end
    object cxTextEditPN: TcxTextEdit
      Left = 292
      Top = 109
      Hint = #19981#21487#20462#25913
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 40
      Width = 100
    end
    object cxTextEditCADDR: TcxTextEdit
      Left = 673
      Top = 109
      Hint = #19981#21487#20462#25913
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 42
      Width = 100
    end
    object cxLabel7: TcxLabel
      Left = 589
      Top = 87
      AutoSize = False
      Caption = #26159#21542#23631#34109
      Height = 16
      Width = 80
    end
    object cxComboBoxShield: TcxComboBox
      Left = 673
      Top = 86
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        #26159
        #21542)
      TabOrder = 38
      Width = 100
    end
    object cxLabel22: TcxLabel
      Left = 400
      Top = 110
      AutoSize = False
      Caption = #31532#20108#26381#21153#21306
      Height = 16
      Width = 80
    end
    object cxTextEditReservPncode: TcxTextEdit
      Left = 482
      Top = 109
      TabOrder = 41
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
    Height = 248
    Width = 797
    object cxGrid1: TcxGrid
      Left = 2
      Top = 17
      Width = 793
      Height = 229
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
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 480
    Top = 184
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 448
    Top = 184
  end
end
