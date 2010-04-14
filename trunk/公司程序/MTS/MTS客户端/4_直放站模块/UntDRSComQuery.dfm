object FrmDRSComQuery: TFrmDRSComQuery
  Left = 0
  Top = 0
  Caption = #21629#20196#26597#35810
  ClientHeight = 377
  ClientWidth = 917
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 656
    Top = 113
    Width = 261
    Height = 264
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 0
      Top = 0
      Width = 261
      Height = 264
      Align = alClient
      Caption = #21629#20196#21442#25968
      TabOrder = 0
      object cxGridDRSComParam: TcxGrid
        Left = 2
        Top = 15
        Width = 257
        Height = 247
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
    Top = 113
    Width = 656
    Height = 264
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox4: TGroupBox
      Left = 0
      Top = 0
      Width = 656
      Height = 264
      Align = alClient
      Caption = #21629#20196#21015#34920
      TabOrder = 0
      object cxGridDRSComOn: TcxGrid
        Left = 2
        Top = 15
        Width = 558
        Height = 247
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
        Left = 560
        Top = 15
        Width = 94
        Height = 247
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object btEnsureOK: TButton
          Left = 6
          Top = 32
          Width = 83
          Height = 33
          Caption = #30830#35748#23436#25104
          Enabled = False
          TabOrder = 0
          OnClick = btEnsureOKClick
        end
      end
    end
  end
  object Panel7: TPanel
    Left = 0
    Top = 0
    Width = 917
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object GroupBox5: TGroupBox
      Left = 0
      Top = 7
      Width = 917
      Height = 106
      Align = alBottom
      Caption = #26597#35810#26465#20214
      TabOrder = 0
      object Label4: TLabel
        Left = 202
        Top = 34
        Width = 52
        Height = 13
        Caption = #25805#20316#31867#22411':'
      end
      object Label5: TLabel
        Left = 12
        Top = 75
        Width = 64
        Height = 13
        Caption = #30452#25918#31449#31867#22411':'
      end
      object rgComQueryType: TRadioGroup
        Left = 14
        Top = 15
        Width = 173
        Height = 45
        Columns = 2
        Ctl3D = False
        ItemIndex = 0
        Items.Strings = (
          #24403#21069#21629#20196
          #21382#21490#26597#35810)
        ParentCtl3D = False
        TabOrder = 0
        OnClick = rgComQueryTypeClick
      end
      object Panel8: TPanel
        Left = 405
        Top = 29
        Width = 384
        Height = 23
        BevelOuter = bvNone
        TabOrder = 1
        object Label6: TLabel
          Left = 10
          Top = 3
          Width = 96
          Height = 13
          Caption = #21629#20196#25191#34892#26102#38388#27573#65306
        end
        object cxdeStartDate: TcxDateEdit
          Left = 116
          Top = 1
          Properties.Kind = ckDateTime
          TabOrder = 0
          Width = 121
        end
        object cxdeEndDate: TcxDateEdit
          Left = 256
          Top = 0
          Properties.Kind = ckDateTime
          TabOrder = 1
          Width = 121
        end
      end
      object cxcbDRSOp: TcxComboBox
        Left = 260
        Top = 30
        TabOrder = 2
        Width = 139
      end
      object Panel9: TPanel
        Left = 366
        Top = 71
        Width = 435
        Height = 22
        BevelOuter = bvNone
        TabOrder = 3
        object CheckBox1: TCheckBox
          Left = 6
          Top = 2
          Width = 147
          Height = 17
          Caption = #21482#26174#31034#22833#36133#25110#36229#26102#21629#20196
          TabOrder = 0
        end
        object CheckBox2: TCheckBox
          Left = 150
          Top = 1
          Width = 75
          Height = 17
          Caption = #33258#21160#36718#35810
          TabOrder = 1
        end
        object CheckBox3: TCheckBox
          Left = 231
          Top = 1
          Width = 75
          Height = 17
          Caption = #25163#21160#21457#36215
          TabOrder = 2
        end
        object cbHasAlarm: TCheckBox
          Left = 312
          Top = 1
          Width = 89
          Height = 17
          Caption = #30452#25918#31449#21578#35686
          Enabled = False
          TabOrder = 3
        end
      end
      object btQuery: TButton
        Left = 779
        Top = 63
        Width = 75
        Height = 25
        Caption = #26597#35810
        TabOrder = 4
        OnClick = btQueryClick
      end
      object cxTextEdit1: TcxTextEdit
        Left = 215
        Top = 71
        TabOrder = 5
        Width = 145
      end
      object ComboBox1: TComboBox
        Left = 82
        Top = 71
        Width = 127
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 6
        OnChange = ComboBox1Change
      end
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
  object DSDRSCom: TDataSource
    DataSet = CDSDRSCom
    Left = 112
    Top = 232
  end
  object CDSDRSCom: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 200
    Top = 232
  end
  object CDSDRSType: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 88
    Top = 104
  end
  object DSDRSType: TDataSource
    DataSet = CDSDRSType
    Left = 152
    Top = 104
  end
end
