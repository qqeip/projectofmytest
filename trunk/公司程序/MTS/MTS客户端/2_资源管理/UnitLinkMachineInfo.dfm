object FormLinkMachineInfo: TFormLinkMachineInfo
  Left = 0
  Top = 0
  Caption = #36830#25509#22120#20449#24687#31649#29702
  ClientHeight = 469
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
  object cxGroupBox2: TcxGroupBox
    Left = 0
    Top = 0
    Align = alClient
    Style.BorderStyle = ebsNone
    Style.Shadow = False
    TabOrder = 0
    Height = 265
    Width = 797
    object cxGrid1: TcxGrid
      Left = 2
      Top = 17
      Width = 793
      Height = 246
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
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 265
    Align = alBottom
    Caption = #36830#25509#22120#20449#24687#24405#20837
    Style.Shadow = True
    TabOrder = 1
    Height = 204
    Width = 797
    object cxLabel1: TcxLabel
      Left = 22
      Top = 30
      AutoSize = False
      Caption = #36830#25509#22120#32534#21495
      Height = 16
      Width = 79
    end
    object cxLabel2: TcxLabel
      Left = 219
      Top = 30
      AutoSize = False
      Caption = #36830#25509#22120#31867#22411
      Height = 16
      Width = 67
    end
    object cxLabel3: TcxLabel
      Left = 400
      Top = 68
      AutoSize = False
      Caption = #36830#25509' AP'
      Height = 16
      Width = 56
    end
    object cxLabel4: TcxLabel
      Left = 22
      Top = 106
      AutoSize = False
      Caption = #36830#25509#22120#20301#32622
      Height = 16
      Width = 79
    end
    object cxLabel5: TcxLabel
      Left = 572
      Top = 30
      AutoSize = False
      Caption = #25152#23646#23460#20998#28857
      Height = 16
      Width = 79
    end
    object cxLabel6: TcxLabel
      Left = 400
      Top = 106
      AutoSize = False
      Caption = #24178#25918#20301#32622
      Height = 16
      Width = 56
    end
    object cxLabel10: TcxLabel
      Left = 22
      Top = 68
      AutoSize = False
      Caption = #36830#25509#35774#22791#31867#22411
      Height = 16
      Width = 79
    end
    object cxLabel11: TcxLabel
      Left = 219
      Top = 106
      AutoSize = False
      Caption = #26159#21542#24178#25918
      Height = 16
      Width = 67
    end
    object cxHeader1: TcxHeader
      Left = 24
      Top = 142
      Width = 737
      Height = 1
      Color = clWindowText
      ParentColor = False
      Sections = <>
    end
    object cxButtonAdd: TcxButton
      Left = 334
      Top = 158
      Width = 75
      Height = 25
      Caption = #26032#22686
      TabOrder = 9
      OnClick = cxButtonAddClick
    end
    object cxButtonModify: TcxButton
      Left = 419
      Top = 158
      Width = 75
      Height = 25
      Caption = #20462#25913
      TabOrder = 10
      OnClick = cxButtonModifyClick
    end
    object cxButtonDel: TcxButton
      Left = 505
      Top = 158
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 11
      OnClick = cxButtonDelClick
    end
    object cxButtonClear: TcxButton
      Left = 590
      Top = 158
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 12
      OnClick = cxButtonClearClick
    end
    object cxButtonClose: TcxButton
      Left = 675
      Top = 158
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 13
      OnClick = cxButtonCloseClick
    end
    object cxLabel15: TcxLabel
      Left = 219
      Top = 68
      AutoSize = False
      Caption = #36830#25509#22522#31449
      Height = 16
      Width = 67
    end
    object cxLabel16: TcxLabel
      Left = 572
      Top = 68
      AutoSize = False
      Caption = #36830#25509'CDMA'#22522#31449
      Height = 16
      Width = 79
    end
    object cxComboBoxLINKCS: TcxComboBox
      Left = 285
      Top = 67
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 21
      Width = 110
    end
    object cxComboBoxBuilding: TcxComboBox
      Left = 652
      Top = 29
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxBuildingPropertiesChange
      TabOrder = 19
      Width = 110
    end
    object cxComboBoxLinkCDMA: TcxComboBox
      Left = 652
      Top = 67
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 23
      Width = 110
    end
    object cxComboBoxLINKTYPE: TcxComboBox
      Left = 285
      Top = 29
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 17
      Width = 110
    end
    object cxEditLINKNO: TcxTextEdit
      Left = 103
      Top = 29
      TabOrder = 16
      Width = 110
    end
    object cxEditLINKADDR: TcxTextEdit
      Left = 103
      Top = 105
      TabOrder = 24
      Width = 110
    end
    object cxEditTRUNKADDR: TcxTextEdit
      Left = 457
      Top = 105
      TabOrder = 26
      Width = 304
    end
    object cxComboBoxLINKAP: TcxComboBox
      Left = 457
      Top = 67
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 22
      Width = 110
    end
    object cxComboBoxLINKEQUIPMENT: TcxComboBox
      Left = 103
      Top = 67
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        'PHS'
        'WLAN'
        'CDMA'
        'PHS+WLAN'
        'PHS+CDMA'
        'WLAN+CDMA'
        'PHS+WLAN+CDMA')
      Properties.OnChange = cxComboBoxLINKEQUIPMENTPropertiesChange
      TabOrder = 20
      Width = 110
    end
    object cxComboBoxISTRUNK: TcxComboBox
      Left = 285
      Top = 105
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        #21542
        #26159)
      Properties.OnChange = cxComboBoxISTRUNKPropertiesChange
      TabOrder = 25
      Width = 110
    end
    object cxComboBoxSuburb: TcxComboBox
      Left = 457
      Top = 29
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxSuburbPropertiesChange
      TabOrder = 18
      Width = 110
    end
    object cxLabel7: TcxLabel
      Left = 400
      Top = 30
      AutoSize = False
      Caption = #25152#23646#20998#23616
      Height = 16
      Width = 56
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
