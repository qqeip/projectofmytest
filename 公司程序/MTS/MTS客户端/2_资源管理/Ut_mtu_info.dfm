object Fm_mtu_info: TFm_mtu_info
  Left = 0
  Top = 0
  Caption = 'MTU'#20449#24687#31649#29702
  ClientHeight = 504
  ClientWidth = 884
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
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 884
    Height = 504
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel3'
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 0
      Top = 305
      Width = 884
      Height = 199
      Align = alBottom
      Caption = 'MTU'#20449#24687#24405#20837
      TabOrder = 0
      object Label5: TLabel
        Left = 253
        Top = 124
        Width = 48
        Height = 13
        Margins.Bottom = 0
        Caption = #35206#30422#21306#22495
      end
      object Label2: TLabel
        Left = 483
        Top = 31
        Width = 54
        Height = 13
        Margins.Bottom = 0
        Caption = 'MTU  '#20301' '#32622
      end
      object Label1: TLabel
        Left = 29
        Top = 31
        Width = 51
        Height = 13
        Margins.Bottom = 0
        Caption = 'MTU '#21517' '#31216
      end
      object Label4: TLabel
        Left = 28
        Top = 76
        Width = 60
        Height = 13
        Margins.Bottom = 0
        Caption = #25152#23646#23460#20998#28857
      end
      object Label6: TLabel
        Left = 251
        Top = 76
        Width = 60
        Height = 13
        Margins.Bottom = 0
        Caption = #19978#31471#36830#25509#22120
      end
      object Label7: TLabel
        Left = 487
        Top = 124
        Width = 52
        Height = 13
        Margins.Bottom = 0
        Caption = 'PHS  '#21495' '#30721
      end
      object Label8: TLabel
        Left = 253
        Top = 31
        Width = 51
        Height = 13
        Margins.Bottom = 0
        Caption = 'MTU '#32534' '#21495
      end
      object Label16: TLabel
        Left = 19
        Top = 31
        Width = 6
        Height = 12
        Margins.Bottom = 0
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 18
        Top = 76
        Width = 6
        Height = 12
        Margins.Bottom = 0
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 245
        Top = 31
        Width = 6
        Height = 12
        Margins.Bottom = 0
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 474
        Top = 124
        Width = 6
        Height = 12
        Margins.Bottom = 0
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 474
        Top = 31
        Width = 6
        Height = 12
        Margins.Bottom = 0
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 245
        Top = 124
        Width = 6
        Height = 12
        Margins.Bottom = 0
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label17: TLabel
        Left = 649
        Top = 124
        Width = 48
        Height = 13
        Margins.Bottom = 0
        Caption = #34987#21483#21495#30721
      end
      object Label3: TLabel
        Left = 483
        Top = 76
        Width = 67
        Height = 13
        Margins.Bottom = 0
        AutoSize = False
        Caption = 'MTU   '#31867' '#22411
      end
      object Label9: TLabel
        Left = 474
        Top = 76
        Width = 6
        Height = 12
        Margins.Bottom = 0
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 26
        Top = 124
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#38376#38480#27169#26495
      end
      object Label19: TLabel
        Left = 19
        Top = 124
        Width = 6
        Height = 12
        Margins.Bottom = 0
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object ButtonModify: TButton
        Left = 418
        Top = 160
        Width = 65
        Height = 25
        Caption = #20462#25913
        TabOrder = 8
        OnClick = ButtonModifyClick
      end
      object Button2: TButton
        Left = 709
        Top = 160
        Width = 65
        Height = 25
        Caption = #36820#22238
        TabOrder = 10
        OnClick = Button2Click
      end
      object ButtonAdd: TButton
        Left = 346
        Top = 160
        Width = 65
        Height = 25
        Caption = #22686#21152
        TabOrder = 7
        OnClick = ButtonAddClick
      end
      object ButtonConfirm: TButton
        Left = 492
        Top = 160
        Width = 65
        Height = 25
        Caption = #30830#23450
        TabOrder = 9
        OnClick = ButtonConfirmClick
      end
      object EditMTUNO: TEdit
        Left = 327
        Top = 27
        Width = 138
        Height = 21
        TabOrder = 1
      end
      object EditMTUADDR: TEdit
        Left = 551
        Top = 27
        Width = 233
        Height = 21
        TabOrder = 4
      end
      object EditOVERLAY: TEdit
        Left = 327
        Top = 120
        Width = 139
        Height = 21
        TabOrder = 6
      end
      object EditCALL: TEdit
        Left = 552
        Top = 120
        Width = 89
        Height = 21
        TabOrder = 2
        OnKeyPress = ImputNum
      end
      object ComboBoxLINKID: TComboBox
        Left = 327
        Top = 73
        Width = 138
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
      end
      object EditMTUNAME: TEdit
        Left = 102
        Top = 27
        Width = 129
        Height = 21
        TabOrder = 0
      end
      object Bt_Del: TButton
        Left = 567
        Top = 160
        Width = 65
        Height = 25
        Caption = #21024#38500
        TabOrder = 11
        OnClick = Bt_DelClick
      end
      object Et_Called: TEdit
        Left = 708
        Top = 120
        Width = 82
        Height = 21
        TabOrder = 3
        OnKeyPress = ImputNum
      end
      object ComboBoxMTUType: TComboBox
        Left = 551
        Top = 73
        Width = 138
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 12
        Items.Strings = (
          'PHS'
          'WLAN'
          'CDMA'
          'PHS+WLAN'
          'PHS+CDMA'
          'WLAN+CDMA'
          'PHS+WLAN+CDMA')
      end
      object ComboBoxAlarmTemp: TComboBox
        Left = 102
        Top = 120
        Width = 129
        Height = 21
        ItemHeight = 13
        TabOrder = 13
      end
      object ComboBoxBuilding: TcxComboBox
        Left = 102
        Top = 73
        Properties.AutoSelect = False
        Properties.DropDownListStyle = lsFixedList
        Properties.OnChange = ComboBoxBuildingPropertiesChange
        Style.BorderStyle = ebsUltraFlat
        Style.PopupBorderStyle = epbsFlat
        TabOrder = 14
        Width = 129
      end
      object ButtonClear: TButton
        Left = 637
        Top = 160
        Width = 65
        Height = 25
        Caption = #28165#31354
        TabOrder = 15
        OnClick = ButtonClearClick
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 884
      Height = 305
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 1
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 882
        Height = 303
        Align = alClient
        Caption = #30456#20851#20449#24687
        TabOrder = 0
        object AdvStringGrid1: TAdvStringGrid
          Left = 2
          Top = 15
          Width = 878
          Height = 286
          Cursor = crDefault
          Align = alClient
          DefaultRowHeight = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          OnClick = AdvStringGrid1Click
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          SearchFooter.FindNextCaption = 'Find next'
          SearchFooter.FindPrevCaption = 'Find previous'
          SearchFooter.HighLightCaption = 'Highlight'
          SearchFooter.HintClose = 'Close'
          SearchFooter.HintFindNext = 'Find next occurence'
          SearchFooter.HintFindPrev = 'Find previous occurence'
          SearchFooter.HintHighlight = 'Highlight occurences'
          SearchFooter.MatchCaseCaption = 'Match case'
          PrintSettings.DateFormat = 'dd/mm/yyyy'
          PrintSettings.Font.Charset = DEFAULT_CHARSET
          PrintSettings.Font.Color = clWindowText
          PrintSettings.Font.Height = -11
          PrintSettings.Font.Name = 'Tahoma'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'Tahoma'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'Tahoma'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'Tahoma'
          PrintSettings.FooterFont.Style = []
          PrintSettings.PageNumSep = '/'
          ScrollWidth = 16
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
          Filter = <>
          Version = '3.3.0.1'
          RowHeights = (
            21
            21
            21
            21
            21
            21
            21
            21
            21
            21)
        end
      end
    end
  end
end
