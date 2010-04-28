object FormBreakSiteStat: TFormBreakSiteStat
  Left = 269
  Top = 186
  Width = 870
  Height = 500
  Caption = #26029#31449#29575#32479#35745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 652
    Height = 466
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 389
      Width = 652
      Height = 77
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 364
        Height = 77
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object FxPivot1: TFxPivot
          Left = 0
          Top = 40
          Width = 364
          Height = 37
          ButtonAutoSize = True
          DecisionSource = Fs_RepShow
          GroupLayout = xtHorizontal
          Groups = [xtRows]
          ButtonSpacing = 0
          ButtonWidth = 64
          ButtonHeight = 24
          GroupSpacing = 10
          BorderWidth = 0
          BorderStyle = bsNone
          Align = alBottom
          BevelInner = bvLowered
          BevelOuter = bvSpace
          TabOrder = 0
        end
        object Cb_SubTotal: TCheckBox
          Left = 30
          Top = 10
          Width = 97
          Height = 17
          Caption = #26174#31034#25152#26377#21512#35745
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Cb_SubTotalClick
        end
        object Cb_RepDate: TCheckBox
          Left = 131
          Top = 10
          Width = 113
          Height = 17
          Caption = #26174#31034#26085#26399#32500#24230
          TabOrder = 2
          OnClick = Cb_RepDateClick
        end
        object Cbb_RepDate: TComboBox
          Left = 247
          Top = 8
          Width = 97
          Height = 21
          Style = csDropDownList
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ItemHeight = 13
          TabOrder = 3
          OnChange = Cbb_RepDateChange
          Items.Strings = (
            #27599#26085
            #27599#21608
            #27599#26376
            #27599#23395
            #24180#24230)
        end
      end
      object GroupBox3: TGroupBox
        Left = 364
        Top = 0
        Width = 288
        Height = 77
        Align = alRight
        Caption = #25253#34920#39068#33394#35774#32622
        TabOrder = 1
        object SpeedButton1: TSpeedButton
          Left = 241
          Top = 26
          Width = 36
          Height = 22
          Caption = #35774#32622
          OnClick = SpeedButton1Click
        end
        object RBCaption: TRadioButton
          Left = 10
          Top = 29
          Width = 50
          Height = 17
          Caption = #26631#39064
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RBLabel: TRadioButton
          Left = 68
          Top = 29
          Width = 50
          Height = 17
          Caption = #25351#26631
          TabOrder = 1
        end
        object RBData: TRadioButton
          Left = 126
          Top = 29
          Width = 50
          Height = 17
          Caption = #25968#25454
          TabOrder = 2
        end
        object RBBackground: TRadioButton
          Left = 184
          Top = 29
          Width = 50
          Height = 17
          Caption = #32972#26223
          TabOrder = 3
        end
      end
    end
    object Pc_RepShow: TPageControl
      Left = 0
      Top = 0
      Width = 652
      Height = 389
      ActivePage = Ts_Grid
      Align = alClient
      Style = tsFlatButtons
      TabHeight = 1
      TabOrder = 1
      TabWidth = 1
      object Ts_Grid: TTabSheet
        TabVisible = False
        object FG_RepShow: TFxGrid
          Left = 0
          Top = 0
          Width = 644
          Height = 379
          VTotal = False
          HTotal = False
          Options = [cgGridLines, cgPivotable]
          DefaultColWidth = 100
          DefaultRowHeight = 20
          CaptionColor = clPurple
          CaptionFont.Charset = DEFAULT_CHARSET
          CaptionFont.Color = clCaptionText
          CaptionFont.Height = -11
          CaptionFont.Name = 'MS Sans Serif'
          CaptionFont.Style = []
          DataColor = clTeal
          DataSumColor = clNone
          DataFont.Charset = DEFAULT_CHARSET
          DataFont.Color = clWindowText
          DataFont.Height = -11
          DataFont.Name = 'MS Sans Serif'
          DataFont.Style = []
          LabelFont.Charset = DEFAULT_CHARSET
          LabelFont.Color = clWindowText
          LabelFont.Height = -11
          LabelFont.Name = 'MS Sans Serif'
          LabelFont.Style = []
          LabelColor = clSkyBlue
          LabelSumColor = clMoneyGreen
          LabelSumFont.Charset = DEFAULT_CHARSET
          LabelSumFont.Color = clWindowText
          LabelSumFont.Height = -11
          LabelSumFont.Name = 'MS Sans Serif'
          LabelSumFont.Style = []
          DecisionSource = Fs_RepShow
          Dimensions = <
            item
              FieldName = #25351#26631#21517#31216
              Color = clNone
              Alignment = taLeftJustify
              Subtotals = True
              Width = 80
            end
            item
              FieldName = #21439#24066
              Color = clNone
              Alignment = taLeftJustify
              Subtotals = True
              Width = 240
            end
            item
              FieldName = #26102#38388
              Color = clNone
              Alignment = taLeftJustify
              Subtotals = True
              Width = 80
            end
            item
              FieldName = #25351#26631
              Color = clNone
              Alignment = taLeftJustify
              Subtotals = True
              Width = 80
            end>
          Totals = True
          ShowCubeEditor = False
          Align = alClient
          Color = clInactiveCaptionText
          Ctl3D = False
          GridLineWidth = 1
          GridLineColor = clWindowText
          ParentCtl3D = False
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnDecisionDrawCell = FG_RepShowDecisionDrawCell
          OnDecisionExamineCell = FG_RepShowDecisionExamineCell
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 652
    Top = 0
    Width = 210
    Height = 466
    Align = alRight
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 344
      Width = 208
      Height = 121
      Align = alBottom
      TabOrder = 0
      object Label1: TLabel
        Left = 18
        Top = 25
        Width = 71
        Height = 13
        AutoSize = False
        Caption = #24320#22987#26085#26399
      end
      object Label3: TLabel
        Left = 18
        Top = 54
        Width = 71
        Height = 13
        AutoSize = False
        Caption = #25130#33267#26085#26399
      end
      object Bt_Ok: TButton
        Left = 34
        Top = 85
        Width = 70
        Height = 25
        Caption = #30830' '#23450
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Bt_OkClick
      end
      object Bt_ShowType: TButton
        Left = 34
        Top = 85
        Width = 70
        Height = 25
        Caption = #22270' '#31034
        TabOrder = 1
        Visible = False
        OnClick = Bt_ShowTypeClick
      end
      object Bt_DataExport: TButton
        Left = 114
        Top = 85
        Width = 70
        Height = 25
        Caption = #23548' '#20986
        TabOrder = 2
        OnClick = Bt_DataExportClick
      end
      object Dtp_StartDate: TDateTimePicker
        Left = 79
        Top = 22
        Width = 114
        Height = 20
        Date = 38811.423535185180000000
        Time = 38811.423535185180000000
        DateFormat = dfLong
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
        TabOrder = 3
      end
      object Dtp_EndDate: TDateTimePicker
        Left = 79
        Top = 51
        Width = 114
        Height = 20
        Date = 38811.423535185180000000
        Time = 38811.423535185180000000
        DateFormat = dfLong
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
        TabOrder = 4
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 208
      Height = 343
      Align = alClient
      Caption = #21439#24066#36873#25321
      TabOrder = 1
      object CLB_TownList: TCheckListBox
        Left = 2
        Top = 15
        Width = 204
        Height = 326
        Align = alClient
        ItemHeight = 13
        PopupMenu = PopupMenu2
        TabOrder = 0
      end
    end
  end
  object Fs_RepShow: TFxSource
    ControlType = xtCheck
    DecisionCube = FxCube
    OnStateChange = Fs_RepShowStateChange
    Left = 80
    Top = 88
    DimensionCount = 3
    SummaryCount = 1
    CurrentSummary = 0
    SparseRows = False
    SparseCols = False
    DimensionInfo = (
      2
      0
      1
      0
      -1
      'ItemName'
      1
      0
      1
      0
      -1
      'CityName'
      1
      -1
      2
      1
      -1
      'STATDATE')
  end
  object FxCube: TFxCube
    DataSet = CDS_Rep
    DimensionMap = <
      item
        Active = False
        Caption = #25351#26631#21517#31216
        FieldName = 'ItemName'
        Name = 'ItemName'
        Params = 0
        ValueCount = 0
      end
      item
        Active = False
        Caption = #21439#24066
        FieldName = 'CityName'
        Name = 'CityName'
        Params = 0
        Width = 30
        ValueCount = 0
      end
      item
        Active = False
        Caption = #25351#26631
        DimensionType = dimSum
        FieldName = 'ITEMVALUE'
        Format = '0'
        Params = 0
        ValueCount = 0
      end
      item
        Active = False
        Caption = #26102#38388
        FieldName = 'STATDATE'
        Name = 'STATDATE'
        Params = 0
        StartDate = 40179.000000000000000000
        ValueCount = 0
      end>
    MaxDimensions = 10
    ShowProgressDialog = False
    Left = 139
    Top = 88
  end
  object CDS_Rep: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSP_Dynamic'
    Left = 198
    Top = 88
  end
  object SaveDialog: TSaveDialog
    Filter = 'Excel '#25991#20214'(*.xls)|*.xls'
    Left = 630
    Top = 256
  end
  object PopupMenu1: TPopupMenu
    Left = 268
    Top = 89
    object N1: TMenuItem
      Caption = #26597#35810#26126#32454#20449#24687
      OnClick = N1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 733
    Top = 201
    object N2: TMenuItem
      Caption = #20840#36873
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #21453#36873
      OnClick = N3Click
    end
  end
  object ColorDialog: TColorDialog
    Left = 484
    Top = 358
  end
end
