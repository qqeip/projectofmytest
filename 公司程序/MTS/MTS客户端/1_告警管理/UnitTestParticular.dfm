object FormTestParticular: TFormTestParticular
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #27979#35797#35814#21333
  ClientHeight = 545
  ClientWidth = 772
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 0
    Align = alTop
    Caption = 'MTU'#20449#24687
    Style.BorderStyle = ebsUltraFlat
    Style.Shadow = False
    TabOrder = 0
    Height = 145
    Width = 772
    object cxLabel1: TcxLabel
      Left = 191
      Top = 21
      AutoSize = False
      Caption = 'MTU'#21517#31216
      Height = 16
      Width = 64
    end
    object cxLabel2: TcxLabel
      Left = 20
      Top = 45
      AutoSize = False
      Caption = #30005#35805#21495#30721
      Height = 16
      Width = 64
    end
    object cxLabel3: TcxLabel
      Left = 368
      Top = 45
      AutoSize = False
      Caption = #35206#30422#21306#22495
      Height = 16
      Width = 64
    end
    object cxLabel4: TcxLabel
      Left = 562
      Top = 45
      AutoSize = False
      Caption = #24403#21069#21578#35686#25968
      Height = 16
      Width = 64
    end
    object cxLabel5: TcxLabel
      Left = 20
      Top = 21
      AutoSize = False
      Caption = 'MTU'#32534#21495
      Height = 16
      Width = 64
    end
    object cxLabel6: TcxLabel
      Left = 191
      Top = 45
      AutoSize = False
      Caption = #34987#21483#21495#30721
      Height = 16
      Width = 64
    end
    object cxLabel7: TcxLabel
      Left = 368
      Top = 21
      AutoSize = False
      Caption = 'MTU'#20301#32622
      Height = 16
      Width = 64
    end
    object cxLabel8: TcxLabel
      Left = 562
      Top = 21
      AutoSize = False
      Caption = #25152#23646#23460#20998#28857
      Height = 16
      Width = 64
    end
    object cxTextEditMTUNO: TcxTextEdit
      Left = 83
      Top = 16
      Properties.ReadOnly = True
      Style.Shadow = True
      TabOrder = 8
      Width = 95
    end
    object cxTextEditMTUNAME: TcxTextEdit
      Left = 254
      Top = 16
      Properties.ReadOnly = True
      Style.Shadow = True
      TabOrder = 9
      Width = 95
    end
    object cxTextEditMTUADDR: TcxTextEdit
      Left = 432
      Top = 16
      Properties.ReadOnly = True
      Style.Shadow = True
      TabOrder = 10
      Width = 120
    end
    object cxTextEditBUILDING: TcxTextEdit
      Left = 630
      Top = 16
      Properties.ReadOnly = True
      Style.Shadow = True
      TabOrder = 11
      Width = 120
    end
    object cxTextEditCALL: TcxTextEdit
      Left = 83
      Top = 44
      Properties.ReadOnly = True
      Style.Shadow = True
      TabOrder = 12
      Width = 95
    end
    object cxTextEditCALLED: TcxTextEdit
      Left = 254
      Top = 44
      Properties.ReadOnly = True
      Style.Shadow = True
      TabOrder = 13
      Width = 95
    end
    object cxTextEditOVER: TcxTextEdit
      Left = 432
      Top = 44
      Properties.ReadOnly = True
      Style.Shadow = True
      TabOrder = 14
      Width = 120
    end
    object cxTextEditALARMS: TcxTextEdit
      Left = 630
      Top = 44
      Properties.ReadOnly = True
      Style.Shadow = True
      TabOrder = 15
      Width = 120
    end
    object cxHeader1: TcxHeader
      Left = 20
      Top = 74
      Width = 688
      Height = 1
      Color = clBlack
      LookAndFeel.Kind = lfOffice11
      ParentColor = False
      Sections = <>
    end
    object cxGroupBoxByDate: TcxGroupBox
      Left = 211
      Top = 81
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsOffice11
      Style.Shadow = True
      TabOrder = 17
      Visible = False
      Height = 58
      Width = 278
      object cxLabel14: TcxLabel
        Left = 13
        Top = 9
        AutoSize = False
        Caption = #24320#22987#26102#38388
        Height = 16
        Width = 64
      end
      object cxLabel15: TcxLabel
        Left = 13
        Top = 30
        AutoSize = False
        Caption = #32467#26463#26102#38388
        Height = 16
        Width = 64
      end
      object DateTimePickerStartTime: TDateTimePicker
        Left = 176
        Top = 9
        Width = 81
        Height = 21
        Date = 39899.465345405090000000
        Format = 'HH:mm:ss'
        Time = 39899.465345405090000000
        Kind = dtkTime
        TabOrder = 2
      end
      object DateTimePickerEndTime: TDateTimePicker
        Left = 176
        Top = 30
        Width = 81
        Height = 21
        Date = 39899.465345405090000000
        Format = 'HH:mm:ss'
        Time = 39899.465345405090000000
        Kind = dtkTime
        TabOrder = 3
      end
      object DateTimePickerStartDate: TDateTimePicker
        Left = 79
        Top = 9
        Width = 89
        Height = 21
        Date = 39899.465345405090000000
        Format = 'yyyy-MM-dd'
        Time = 39899.465345405090000000
        TabOrder = 4
      end
      object DateTimePickerEndDate: TDateTimePicker
        Left = 79
        Top = 30
        Width = 89
        Height = 21
        Date = 39899.465345405090000000
        Format = 'yyyy-MM-dd'
        Time = 39899.465345405090000000
        TabOrder = 5
      end
    end
    object cxButtonStat: TcxButton
      Left = 568
      Top = 111
      Width = 75
      Height = 25
      Caption = #30830#23450
      TabOrder = 18
      OnClick = cxButtonStatClick
    end
    object cxButtonClose: TcxButton
      Left = 654
      Top = 111
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 19
      OnClick = cxButtonCloseClick
    end
    object cxGroupBoxByCounts: TcxGroupBox
      Left = 211
      Top = 81
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsOffice11
      Style.LookAndFeel.Kind = lfUltraFlat
      Style.Shadow = True
      StyleDisabled.LookAndFeel.Kind = lfUltraFlat
      StyleFocused.LookAndFeel.Kind = lfUltraFlat
      StyleHot.LookAndFeel.Kind = lfUltraFlat
      TabOrder = 20
      Height = 58
      Width = 198
      object cxLabel13: TcxLabel
        Left = 20
        Top = 19
        AutoSize = False
        Caption = #26368#36817#27425#25968
        Height = 16
        Width = 64
      end
      object cxTextEditStatCounts: TcxTextEdit
        Left = 85
        Top = 18
        Style.Shadow = True
        TabOrder = 1
        Text = '10'
        Width = 95
      end
    end
    object cxRadioGroupSearchType: TcxRadioGroup
      Left = 20
      Top = 81
      Caption = #26597#35810#26041#24335
      Properties.Columns = 2
      Properties.Items = <
        item
          Caption = #26368#36817#27425#25968
        end
        item
          Caption = #26102' '#38388' '#27573
        end>
      ItemIndex = 0
      Style.BorderColor = clBtnFace
      Style.BorderStyle = ebsOffice11
      Style.Shadow = True
      TabOrder = 21
      OnClick = cxRadioGroupSearchTypeClick
      Height = 58
      Width = 185
    end
  end
  object cxGroupBoxStat: TcxGroupBox
    Left = 0
    Top = 145
    Align = alClient
    Style.BorderStyle = ebsNone
    Style.Shadow = True
    TabOrder = 1
    Height = 400
    Width = 772
    object cxGroupBox4: TcxGroupBox
      Left = 2
      Top = 17
      Align = alLeft
      Caption = #27979#35797#31867#22411
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsOffice11
      TabOrder = 0
      Height = 378
      Width = 185
      object TreeView1: TTreeView
        Left = 2
        Top = 17
        Width = 181
        Height = 359
        Align = alClient
        HideSelection = False
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnChange = TreeView1Change
      end
    end
    object cxGroupBoxDetail: TcxGroupBox
      Left = 187
      Top = 17
      Align = alClient
      Caption = #27979#35797#35814#32454#20449#24687
      Style.BorderColor = clSkyBlue
      Style.BorderStyle = ebsOffice11
      TabOrder = 1
      Height = 378
      Width = 580
      object cxGridResult: TcxGrid
        Left = 2
        Top = 17
        Width = 576
        Height = 359
        Align = alClient
        TabOrder = 0
        object cxGridResultDBTableView1: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = DataSourceResult
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.GroupByBox = False
        end
        object cxGridResultLevel1: TcxGridLevel
          GridView = cxGridResultDBTableView1
        end
      end
    end
  end
  object ClientDataSetDym: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 304
  end
  object DataSourceResult: TDataSource
    DataSet = ClientDataSetResult
    Left = 392
    Top = 336
  end
  object ClientDataSetResult: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 424
    Top = 336
  end
end
