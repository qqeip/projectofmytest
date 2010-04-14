object FormSwitchInfo: TFormSwitchInfo
  Left = 0
  Top = 0
  Caption = #20132#25442#26426#20449#24687#31649#29702
  ClientHeight = 470
  ClientWidth = 790
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
    Caption = #20132#25442#26426#20449#24687#24405#20837
    Style.Shadow = True
    TabOrder = 0
    Height = 182
    Width = 790
    object cxLabel1: TcxLabel
      Left = 52
      Top = 21
      AutoSize = False
      Caption = #20132#25442#26426#32534#21495
      Height = 16
      Width = 91
    end
    object cxLabel2: TcxLabel
      Left = 395
      Top = 21
      AutoSize = False
      Caption = #29289' '#29702' '#22320' '#22336
      Height = 16
      Width = 77
    end
    object cxLabel5: TcxLabel
      Left = 395
      Top = 46
      AutoSize = False
      Caption = #31649' '#29702' '#22320' '#22336
      Height = 16
      Width = 77
    end
    object cxLabel10: TcxLabel
      Left = 395
      Top = 72
      AutoSize = False
      Caption = #25152#23646#23460#20998#28857
      Height = 16
      Width = 77
    end
    object cxLabel11: TcxLabel
      Left = 53
      Top = 98
      AutoSize = False
      Caption = #65328#65327#65328
      Height = 16
      Width = 77
    end
    object cxHeader1: TcxHeader
      Left = 24
      Top = 125
      Width = 737
      Height = 1
      Color = clWindowText
      LookAndFeel.Kind = lfOffice11
      ParentColor = False
      Sections = <>
    end
    object cxButtonAdd: TcxButton
      Left = 322
      Top = 139
      Width = 75
      Height = 25
      Caption = #26032#22686
      TabOrder = 6
      OnClick = cxButtonAddClick
    end
    object cxButtonModify: TcxButton
      Left = 406
      Top = 139
      Width = 75
      Height = 25
      Caption = #20462#25913
      TabOrder = 7
      OnClick = cxButtonModifyClick
    end
    object cxButtonDel: TcxButton
      Left = 492
      Top = 139
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 8
      OnClick = cxButtonDelClick
    end
    object cxButtonClear: TcxButton
      Left = 577
      Top = 139
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 9
      OnClick = cxButtonClearClick
    end
    object cxButtonClose: TcxButton
      Left = 661
      Top = 139
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 10
      OnClick = cxButtonCloseClick
    end
    object cxLabel15: TcxLabel
      Left = 52
      Top = 46
      AutoSize = False
      Caption = #19978#36830#31471#21475
      Height = 16
      Width = 70
    end
    object cxComboBoxBuilding: TcxComboBox
      Left = 476
      Top = 71
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxBuildingPropertiesChange
      TabOrder = 12
      Width = 260
    end
    object cxEditName: TcxTextEdit
      Left = 131
      Top = 19
      TabOrder = 13
      Width = 230
    end
    object cxEditAddress: TcxTextEdit
      Left = 476
      Top = 19
      TabOrder = 14
      Width = 260
    end
    object cxEditPort: TcxTextEdit
      Left = 131
      Top = 45
      TabOrder = 15
      Width = 230
    end
    object cxEditPOP: TcxTextEdit
      Left = 131
      Top = 97
      TabOrder = 16
      Width = 230
    end
    object cxEditAddress2: TcxTextEdit
      Left = 476
      Top = 45
      TabOrder = 17
      Width = 260
    end
    object cxComboBoxSuburb: TcxComboBox
      Left = 131
      Top = 71
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxSuburbPropertiesChange
      TabOrder = 18
      Width = 230
    end
    object cxLabel3: TcxLabel
      Left = 52
      Top = 72
      AutoSize = False
      Caption = #25152#23646#20998#23616
      Height = 16
      Width = 80
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
    Width = 790
    object cxGrid1: TcxGrid
      Left = 2
      Top = 17
      Width = 786
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
    Left = 376
    Top = 208
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 432
    Top = 208
  end
end
