object FormDRSSingleAlarmSearch: TFormDRSSingleAlarmSearch
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FormDRSSingleAlarmSearch'
  ClientHeight = 438
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 750
    Height = 171
    Align = alClient
    Caption = #24403#21069#21578#35686
    TabOrder = 0
    object cxGridAlarmOnline: TcxGrid
      Left = 2
      Top = 15
      Width = 746
      Height = 154
      Align = alClient
      TabOrder = 0
      object cxGridAlarmOnlineDBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridAlarmOnlineLevel1: TcxGridLevel
        GridView = cxGridAlarmOnlineDBTableView1
      end
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 171
    Width = 750
    Height = 267
    Align = alBottom
    Caption = #21382#21490#21578#35686
    TabOrder = 1
    object Panel1: TPanel
      Left = 2
      Top = 15
      Width = 746
      Height = 38
      Align = alTop
      TabOrder = 0
      object Button1: TButton
        Left = 544
        Top = 8
        Width = 75
        Height = 25
        Caption = #26597#35810
        TabOrder = 0
        OnClick = Button1Click
      end
      object RadioButton1: TRadioButton
        Left = 24
        Top = 12
        Width = 70
        Height = 17
        Caption = #26368#36817'3'#22825
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object RadioButton2: TRadioButton
        Left = 121
        Top = 12
        Width = 24
        Height = 17
        TabOrder = 2
      end
      object Panel4: TPanel
        Tag = 13
        Left = 151
        Top = 6
        Width = 321
        Height = 29
        BevelOuter = bvNone
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        object SendD1: TDateTimePicker
          Left = 12
          Top = 5
          Width = 82
          Height = 20
          Date = 38612.592544849540000000
          Time = 38612.592544849540000000
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          TabOrder = 0
        end
        object SendT1: TDateTimePicker
          Left = 94
          Top = 5
          Width = 54
          Height = 20
          Date = 38938.707921006940000000
          Format = 'HH:mm'
          Time = 38938.707921006940000000
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          Kind = dtkTime
          TabOrder = 1
        end
        object SendD2: TDateTimePicker
          Left = 169
          Top = 5
          Width = 82
          Height = 20
          Date = 38612.592544849540000000
          Time = 38612.592544849540000000
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          TabOrder = 2
        end
        object SendT2: TDateTimePicker
          Left = 251
          Top = 5
          Width = 54
          Height = 20
          Date = 38938.707921006940000000
          Format = 'HH:mm'
          Time = 38938.707921006940000000
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          Kind = dtkTime
          TabOrder = 3
        end
      end
    end
    object cxGridAlarmHis: TcxGrid
      Left = 2
      Top = 53
      Width = 746
      Height = 212
      Align = alClient
      TabOrder = 1
      object cxGridAlarmHisDBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource2
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridAlarmHisLevel1: TcxGridLevel
        GridView = cxGridAlarmHisDBTableView1
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 480
    Top = 80
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 512
    Top = 80
  end
  object DataSource2: TDataSource
    DataSet = ClientDataSet2
    Left = 480
    Top = 240
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 512
    Top = 240
  end
end
