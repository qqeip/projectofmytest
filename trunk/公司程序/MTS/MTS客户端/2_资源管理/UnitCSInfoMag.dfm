object FormCSInfoMag: TFormCSInfoMag
  Left = 0
  Top = 0
  Caption = #22522#31449#20449#24687#31649#29702
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
    Caption = #22522#31449#20449#24687#24405#20837
    Style.Shadow = True
    TabOrder = 0
    Height = 182
    Width = 797
    object cxLabel1: TcxLabel
      Left = 49
      Top = 33
      AutoSize = False
      Caption = #21208#28857#32534#30721
      Height = 16
      Width = 71
    end
    object cxLabel2: TcxLabel
      Left = 244
      Top = 33
      AutoSize = False
      Caption = 'C S I D'
      Height = 16
      Width = 65
    end
    object cxLabel3: TcxLabel
      Left = 549
      Top = 33
      AutoSize = False
      Caption = #22522#31449#31867#22411
      Height = 16
      Width = 56
    end
    object cxLabel5: TcxLabel
      Left = 484
      Top = 61
      AutoSize = False
      Caption = #22522#31449#22320#22336
      Height = 16
      Width = 65
    end
    object cxLabel10: TcxLabel
      Left = 49
      Top = 86
      AutoSize = False
      Caption = #32593#20803#20449#24687
      Height = 16
      Width = 71
    end
    object cxLabel11: TcxLabel
      Left = 244
      Top = 86
      AutoSize = False
      Caption = #35206#30422#33539#22260
      Height = 16
      Width = 65
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
      Left = 326
      Top = 139
      Width = 75
      Height = 25
      Caption = #26032#22686
      TabOrder = 7
      OnClick = cxButtonAddClick
    end
    object cxButtonModify: TcxButton
      Left = 411
      Top = 139
      Width = 75
      Height = 25
      Caption = #20462#25913
      TabOrder = 8
      OnClick = cxButtonModifyClick
    end
    object cxButtonDel: TcxButton
      Left = 497
      Top = 139
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 9
      OnClick = cxButtonDelClick
    end
    object cxButtonClear: TcxButton
      Left = 582
      Top = 139
      Width = 75
      Height = 25
      Caption = #28165#31354
      TabOrder = 10
      OnClick = cxButtonClearClick
    end
    object cxButtonClose: TcxButton
      Left = 667
      Top = 139
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 11
      OnClick = cxButtonCloseClick
    end
    object cxLabel15: TcxLabel
      Left = 244
      Top = 61
      AutoSize = False
      Caption = #25152#23646#23460#20998#28857
      Height = 16
      Width = 71
    end
    object cxComboBoxBuilding: TcxComboBox
      Left = 315
      Top = 58
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxBuildingPropertiesChange
      TabOrder = 17
      Width = 141
    end
    object cxComboBoxCSType: TcxComboBox
      Left = 611
      Top = 31
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        #30452#25918#31449
        'RRU'
        #23439#22522#31449)
      TabOrder = 15
      Width = 128
    end
    object cxTextEditSurvery: TcxTextEdit
      Left = 113
      Top = 31
      TabOrder = 13
      Width = 100
    end
    object cxTextEditCSID: TcxTextEdit
      Left = 315
      Top = 31
      TabOrder = 14
      Width = 191
    end
    object cxTextEditNet: TcxTextEdit
      Left = 113
      Top = 84
      TabOrder = 19
      Width = 100
    end
    object cxTextEditCover: TcxTextEdit
      Left = 315
      Top = 84
      TabOrder = 20
      Width = 424
    end
    object cxTextEditAddress: TcxTextEdit
      Left = 548
      Top = 58
      TabOrder = 18
      Width = 191
    end
    object cxLabel4: TcxLabel
      Left = 47
      Top = 61
      AutoSize = False
      Caption = #25152#23646#20998#23616
      Height = 16
      Width = 80
    end
    object cxComboBoxSuburb: TcxComboBox
      Left = 113
      Top = 58
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = cxComboBoxSuburbPropertiesChange
      TabOrder = 16
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
    Left = 432
    Top = 208
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 504
    Top = 208
  end
end
