object FrmDRSConfigComQuery: TFrmDRSConfigComQuery
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'FrmDRSConfigComQuery'
  ClientHeight = 404
  ClientWidth = 925
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 664
    Top = 0
    Width = 261
    Height = 404
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 0
      Top = 0
      Width = 261
      Height = 404
      Align = alClient
      Caption = #21629#20196#21442#25968
      TabOrder = 0
      object cxGridDRSComParam: TcxGrid
        Left = 2
        Top = 15
        Width = 257
        Height = 387
        Align = alClient
        TabOrder = 0
        object cxGridDBTVDRSComParam: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = DSDRSParam
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.GroupByBox = False
        end
        object cxGridDRSComParamLevel1: TcxGridLevel
          GridView = cxGridDBTVDRSComParam
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 404
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 0
      Top = 216
      Width = 664
      Height = 188
      Align = alBottom
      Caption = #21382#21490#25805#20316
      TabOrder = 0
      object Panel3: TPanel
        Left = 2
        Top = 15
        Width = 660
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label37: TLabel
          Left = 10
          Top = 3
          Width = 88
          Height = 13
          Caption = #21629#20196#25191#34892#26102#38388#27573':'
        end
        object btComHisQuery: TButton
          Left = 516
          Top = -2
          Width = 75
          Height = 25
          Caption = #26597#35810
          TabOrder = 0
          OnClick = btComHisQueryClick
        end
        object cxcbDRSType: TcxComboBox
          Left = 357
          Top = 2
          Properties.DropDownListStyle = lsEditFixedList
          TabOrder = 1
          Width = 139
        end
        object cxdeStartDate: TcxDateEdit
          Left = 103
          Top = 2
          Properties.Kind = ckDateTime
          TabOrder = 2
          Width = 121
        end
        object cxdeEndDate: TcxDateEdit
          Left = 230
          Top = 2
          Properties.Kind = ckDateTime
          TabOrder = 3
          Width = 121
        end
      end
      object Panel4: TPanel
        Left = 2
        Top = 44
        Width = 660
        Height = 142
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object cxGridDRSComHis: TcxGrid
          Left = 0
          Top = 0
          Width = 660
          Height = 142
          Align = alClient
          TabOrder = 0
          object cxGridDBTVDRSComHis: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            OnFocusedRecordChanged = cxGridDBTVDRSComHisFocusedRecordChanged
            DataController.DataSource = DSDRSComHis
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsView.GroupByBox = False
          end
          object cxGridLevel2: TcxGridLevel
            GridView = cxGridDBTVDRSComHis
          end
        end
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 664
      Height = 47
      Align = alTop
      Caption = #22522#26412#25805#20316
      TabOrder = 1
      object btSendCommand: TButton
        Left = 246
        Top = 16
        Width = 75
        Height = 25
        Caption = #25191#34892#21629#20196
        TabOrder = 0
        OnClick = btSendCommandClick
      end
      object cxcbDRSOp: TcxComboBox
        Left = 70
        Top = 20
        Properties.DropDownListStyle = lsFixedList
        TabOrder = 1
        Width = 139
      end
    end
    object GroupBox4: TGroupBox
      Left = 0
      Top = 47
      Width = 664
      Height = 161
      Align = alClient
      Caption = #24403#21069#25191#34892#21629#20196
      TabOrder = 2
      object cxGridDRSComOn: TcxGrid
        Left = 2
        Top = 15
        Width = 566
        Height = 144
        Align = alClient
        TabOrder = 0
        object cxGridDBTVDRSComOn: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          OnFocusedRecordChanged = cxGridDBTVDRSComOnFocusedRecordChanged
          DataController.DataSource = DSDRSCom
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.CellSelect = False
          OptionsView.GroupByBox = False
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTVDRSComOn
        end
      end
      object Panel5: TPanel
        Left = 568
        Top = 15
        Width = 94
        Height = 144
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object btEnsureOK: TButton
          Left = 6
          Top = 32
          Width = 83
          Height = 33
          Caption = #30830#35748#23436#25104
          TabOrder = 0
          OnClick = btEnsureOKClick
        end
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 0
      Top = 208
      Width = 664
      Height = 8
      HotZoneClassName = 'TcxMediaPlayer8Style'
      HotZone.SizePercent = 100
      AlignSplitter = salBottom
      Control = GroupBox1
    end
  end
  object DSDRSParam: TDataSource
    DataSet = CDSDRSParam
    Left = 776
    Top = 248
  end
  object CDSDRSParam: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 856
    Top = 248
  end
  object DSDRSComHis: TDataSource
    DataSet = CDSDRSComHis
    Left = 256
    Top = 264
  end
  object CDSDRSComHis: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 344
    Top = 264
  end
  object DSDRSCom: TDataSource
    DataSet = CDSDRSCom
    Left = 264
    Top = 80
  end
  object CDSDRSCom: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 352
    Top = 80
  end
end
