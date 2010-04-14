object FormAPInfo: TFormAPInfo
  Left = 0
  Top = 0
  Caption = 'AP'#20449#24687#31649#29702
  ClientHeight = 481
  ClientWidth = 798
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
    Top = 264
    Align = alBottom
    Caption = 'AP'#20449#24687#24405#20837
    Style.Shadow = True
    TabOrder = 0
    Height = 217
    Width = 798
    object cxLabel1: TcxLabel
      Left = 34
      Top = 17
      AutoSize = False
      Caption = #25509#20837#28857#32534#21495
      Height = 16
      Width = 79
    end
    object cxLabel2: TcxLabel
      Left = 225
      Top = 17
      AutoSize = False
      Caption = #36830#25509#31867#22411
      Height = 16
      Width = 65
    end
    object cxLabel3: TcxLabel
      Left = 410
      Top = 17
      AutoSize = False
      Caption = #20379' '#24212' '#21830
      Height = 16
      Width = 55
    end
    object cxLabel4: TcxLabel
      Left = 581
      Top = 17
      AutoSize = False
      Caption = #23545#24212#31471#21475
      Height = 16
      Width = 55
    end
    object cxLabel5: TcxLabel
      Left = 225
      Top = 41
      AutoSize = False
      Caption = #25152#23646#23460#20998#28857
      Height = 16
      Width = 65
    end
    object cxLabel6: TcxLabel
      Left = 410
      Top = 67
      AutoSize = False
      Caption = #39057'  '#12288#28857
      Height = 16
      Width = 55
    end
    object cxLabel10: TcxLabel
      Left = 34
      Top = 67
      AutoSize = False
      Caption = 'A P '#24615' '#36136
      Height = 16
      Width = 79
    end
    object cxLabel11: TcxLabel
      Left = 225
      Top = 67
      AutoSize = False
      Caption = 'A P '#22411#21495
      Height = 16
      Width = 65
    end
    object cxHeader1: TcxHeader
      Left = 24
      Top = 168
      Width = 737
      Height = 1
      Color = clWindowText
      ParentColor = False
      Sections = <>
    end
    object cxButtonAdd: TcxButton
      Left = 334
      Top = 175
      Width = 75
      Height = 25
      Caption = #26032#22686
      TabOrder = 9
      OnClick = cxButtonAddClick
    end
    object cxButtonModify: TcxButton
      Left = 415
      Top = 176
      Width = 75
      Height = 25
      Caption = #20462#25913
      TabOrder = 10
      OnClick = cxButtonModifyClick
    end
    object cxButtonDel: TcxButton
      Left = 499
      Top = 176
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 11
      OnClick = cxButtonDelClick
    end
    object cxButtonClear: TcxButton
      Left = 582
      Top = 176
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 12
      OnClick = cxButtonClearClick
    end
    object cxButtonClose: TcxButton
      Left = 664
      Top = 176
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 13
      OnClick = cxButtonCloseClick
    end
    object cxLabel15: TcxLabel
      Left = 410
      Top = 41
      AutoSize = False
      Caption = #20132' '#25442' '#26426
      Height = 16
      Width = 55
    end
    object cxLabel16: TcxLabel
      Left = 581
      Top = 67
      AutoSize = False
      Caption = #20379#30005#26041#24335
      Height = 16
      Width = 55
    end
    object cxComboBoxSwitch: TcxComboBox
      Left = 468
      Top = 40
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 22
      Width = 100
    end
    object cxComboBoxAPPROPERTY: TcxComboBox
      Left = 113
      Top = 65
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 24
      Width = 110
    end
    object cxComboBoxPowerKind: TcxComboBox
      Left = 639
      Top = 65
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        #23460#22806
        #23460#20869)
      TabOrder = 27
      Width = 100
    end
    object cxComboBoxConType: TcxComboBox
      Left = 289
      Top = 15
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 17
      Width = 110
    end
    object cxEditAPName: TcxTextEdit
      Left = 113
      Top = 14
      TabOrder = 16
      Width = 110
    end
    object cxEditPort: TcxTextEdit
      Left = 639
      Top = 15
      TabOrder = 19
      OnKeyPress = cxEditPortKeyPress
      Width = 100
    end
    object cxEditFREQUENCY: TcxTextEdit
      Left = 468
      Top = 65
      TabOrder = 26
      OnKeyPress = cxEditFREQUENCYKeyPress
      Width = 100
    end
    object cxComboBoxFactory: TcxComboBox
      Left = 468
      Top = 15
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        'PHS'
        'WLAN'
        'CDMA'
        'PHS+WLAN'
        'PHS+CDMA'
        'WLAN+CDMA'
        'PHS+WLAN+CDMA')
      TabOrder = 18
      Width = 100
    end
    object cxComboBoxBuilding: TcxComboBox
      Left = 289
      Top = 41
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxBuildingPropertiesChange
      TabOrder = 21
      Width = 110
    end
    object cxComboBoxApType: TcxComboBox
      Left = 289
      Top = 65
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 25
      Width = 110
    end
    object cxLabel7: TcxLabel
      Left = 581
      Top = 41
      AutoSize = False
      Caption = #21151'    '#29575
      Height = 16
      Width = 55
    end
    object cxEditAPPOWER: TcxTextEdit
      Left = 639
      Top = 40
      TabOrder = 23
      OnKeyPress = cxEditAPPOWERKeyPress
      Width = 100
    end
    object cxEditAPIP: TcxTextEdit
      Left = 639
      Top = 90
      TabOrder = 31
      Width = 100
    end
    object cxLabel8: TcxLabel
      Left = 581
      Top = 92
      AutoSize = False
      Caption = 'A P I  P'
      Height = 16
      Width = 55
    end
    object cxLabel9: TcxLabel
      Left = 34
      Top = 92
      AutoSize = False
      Caption = 'A P '#22320' '#22336
      Height = 16
      Width = 79
    end
    object cxEditAPADDR: TcxTextEdit
      Left = 113
      Top = 90
      TabOrder = 28
      Width = 110
    end
    object cxLabel12: TcxLabel
      Left = 34
      Top = 115
      AutoSize = False
      Caption = 'AP'#31649#29702#22320#22336#27573
      Height = 16
      Width = 79
    end
    object cxEditMANAGEADDRSEG: TcxTextEdit
      Left = 113
      Top = 114
      TabOrder = 32
      Width = 286
    end
    object cxLabel13: TcxLabel
      Left = 410
      Top = 92
      AutoSize = False
      Caption = #19994#21153'VLAN'
      Height = 16
      Width = 55
    end
    object cxEditBUSINESSVLAN: TcxTextEdit
      Left = 468
      Top = 90
      TabOrder = 30
      Width = 100
    end
    object cxLabel14: TcxLabel
      Left = 225
      Top = 92
      AutoSize = False
      Caption = #35206#30422#33539#22260
      Height = 16
      Width = 65
    end
    object cxEditOVERLAY: TcxTextEdit
      Left = 289
      Top = 90
      TabOrder = 29
      Width = 110
    end
    object cxLabel17: TcxLabel
      Left = 410
      Top = 115
      AutoSize = False
      Caption = #32593#20851#22320#22336
      Height = 16
      Width = 55
    end
    object cxEditGWADDR: TcxTextEdit
      Left = 468
      Top = 114
      TabOrder = 33
      Width = 271
    end
    object cxLabel18: TcxLabel
      Left = 34
      Top = 141
      AutoSize = False
      Caption = 'MAC '#22320' '#22336
      Height = 16
      Width = 79
    end
    object cxEditMACADDR: TcxTextEdit
      Left = 113
      Top = 141
      TabOrder = 34
      Width = 286
    end
    object cxLabel19: TcxLabel
      Left = 410
      Top = 141
      AutoSize = False
      Caption = #31649#29702'VLAN'
      Height = 16
      Width = 55
    end
    object cxEditMANAGEVLAN: TcxTextEdit
      Left = 468
      Top = 141
      TabOrder = 35
      Width = 271
    end
    object cxLabel20: TcxLabel
      Left = 34
      Top = 41
      AutoSize = False
      Caption = #25152#23646#20998#23616
      Height = 16
      Width = 79
    end
    object cxComboBoxSuburb: TcxComboBox
      Left = 113
      Top = 40
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxSuburbPropertiesChange
      TabOrder = 20
      Width = 110
    end
  end
  object cxGroupBox2: TcxGroupBox
    Left = 0
    Top = 0
    Align = alClient
    Style.BorderStyle = ebsNone
    Style.Shadow = False
    TabOrder = 1
    Height = 264
    Width = 798
    object cxGrid1: TcxGrid
      Left = 2
      Top = 17
      Width = 794
      Height = 245
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
