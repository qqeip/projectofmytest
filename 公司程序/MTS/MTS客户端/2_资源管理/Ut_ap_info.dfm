object Fm_ap_info: TFm_ap_info
  Left = 0
  Top = 0
  Caption = 'AP'#20449#24687#31649#29702
  ClientHeight = 591
  ClientWidth = 782
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 782
    Height = 591
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 3
    ExplicitWidth = 869
    object GroupBox3: TGroupBox
      Left = 0
      Top = 302
      Width = 782
      Height = 289
      Align = alBottom
      Caption = 'AP'#20449#24687#24405#20837
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 306
      ExplicitWidth = 869
      object Label1: TLabel
        Left = 24
        Top = 25
        Width = 60
        Height = 13
        Caption = #25509#20837#28857#32534#21495
      end
      object Label2: TLabel
        Left = 214
        Top = 25
        Width = 48
        Height = 13
        Caption = #36830#25509#31867#22411
      end
      object Label3: TLabel
        Left = 31
        Top = 62
        Width = 42
        Height = 13
        Caption = #23460' '#20998' '#28857
      end
      object Label4: TLabel
        Left = 218
        Top = 62
        Width = 42
        Height = 13
        Caption = #20132' '#25442' '#26426
      end
      object Label5: TLabel
        Left = 595
        Top = 25
        Width = 48
        Height = 13
        Caption = #23545#24212#31471#21475
      end
      object Label6: TLabel
        Left = 405
        Top = 25
        Width = 42
        Height = 13
        Caption = #20379' '#24212' '#21830
      end
      object Label7: TLabel
        Left = 399
        Top = 62
        Width = 48
        Height = 13
        Caption = #21151#12288#12288#29575
      end
      object Label8: TLabel
        Left = 212
        Top = 100
        Width = 49
        Height = 13
        Caption = 'A P  '#22411' '#21495
      end
      object Label9: TLabel
        Left = 595
        Top = 62
        Width = 48
        Height = 13
        Caption = #20379#30005#26041#24335
      end
      object Label10: TLabel
        Left = 400
        Top = 100
        Width = 48
        Height = 13
        Caption = #39057#12288#12288#28857
      end
      object Label11: TLabel
        Left = 24
        Top = 137
        Width = 49
        Height = 13
        Caption = 'A P  '#22320' '#22336
      end
      object Label12: TLabel
        Left = 283
        Top = 137
        Width = 57
        Height = 13
        Caption = #35206' '#30422' '#33539' '#22260
      end
      object Label13: TLabel
        Left = 16
        Top = 175
        Width = 73
        Height = 13
        Caption = 'AP'#31649#29702#22320#22336#27573
      end
      object Label14: TLabel
        Left = 597
        Top = 100
        Width = 44
        Height = 13
        Caption = 'A  P  I   P'
      end
      object Label15: TLabel
        Left = 372
        Top = 176
        Width = 57
        Height = 13
        Caption = #32593' '#20851' '#22320' '#22336
      end
      object Label16: TLabel
        Left = 23
        Top = 213
        Width = 55
        Height = 13
        Caption = 'MAC  '#22320' '#22336
      end
      object Label17: TLabel
        Left = 555
        Top = 137
        Width = 55
        Height = 13
        Caption = #19994#21153'  VLAN'
      end
      object Label18: TLabel
        Left = 372
        Top = 213
        Width = 49
        Height = 13
        Caption = #31649#29702'VLAN'
      end
      object Label20: TLabel
        Left = 18
        Top = 25
        Width = 6
        Height = 12
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label21: TLabel
        Left = 208
        Top = 25
        Width = 6
        Height = 12
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label23: TLabel
        Left = 18
        Top = 63
        Width = 6
        Height = 12
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label24: TLabel
        Left = 397
        Top = 25
        Width = 6
        Height = 12
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label25: TLabel
        Left = 208
        Top = 63
        Width = 6
        Height = 12
        Caption = '*'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label26: TLabel
        Left = 24
        Top = 100
        Width = 46
        Height = 13
        Caption = 'A P '#24615' '#36136
      end
      object ButtonModify: TButton
        Left = 383
        Top = 250
        Width = 65
        Height = 25
        Caption = #20462#25913
        TabOrder = 18
        OnClick = ButtonModifyClick
      end
      object Button2: TButton
        Left = 674
        Top = 250
        Width = 65
        Height = 25
        Caption = #36820#22238
        TabOrder = 20
        OnClick = Button2Click
      end
      object ButtonAdd: TButton
        Left = 311
        Top = 250
        Width = 65
        Height = 25
        Caption = #22686#21152
        TabOrder = 17
        OnClick = ButtonAddClick
      end
      object ButtonConfirm: TButton
        Left = 455
        Top = 250
        Width = 65
        Height = 25
        Caption = #30830#23450
        TabOrder = 19
        OnClick = ButtonConfirmClick
      end
      object EditAPName: TEdit
        Left = 91
        Top = 22
        Width = 110
        Height = 21
        TabOrder = 0
      end
      object ComboBoxConType: TComboBox
        Left = 271
        Top = 22
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
      object EditPort: TEdit
        Left = 651
        Top = 22
        Width = 116
        Height = 21
        TabOrder = 3
        OnKeyPress = ImputNum
      end
      object ComboBoxSwitch: TComboBox
        Left = 271
        Top = 59
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
      end
      object ComboBoxFactory: TComboBox
        Left = 460
        Top = 22
        Width = 128
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
      end
      object ComboBoxPowerKind: TComboBox
        Left = 651
        Top = 59
        Width = 116
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 7
      end
      object EditAPPOWER: TEdit
        Left = 460
        Top = 59
        Width = 128
        Height = 21
        TabOrder = 6
        OnKeyPress = ImputFloat
      end
      object EditAPADDR: TEdit
        Left = 91
        Top = 135
        Width = 182
        Height = 21
        TabOrder = 9
      end
      object EditOVERLAY: TEdit
        Left = 349
        Top = 135
        Width = 198
        Height = 21
        TabOrder = 10
      end
      object EditMANAGEADDRSEG: TEdit
        Left = 91
        Top = 173
        Width = 262
        Height = 21
        TabOrder = 11
      end
      object ComboBoxApType: TComboBox
        Left = 271
        Top = 97
        Width = 121
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
      end
      object EditAPIP: TEdit
        Left = 651
        Top = 97
        Width = 116
        Height = 21
        TabOrder = 12
      end
      object EditGWADDR: TEdit
        Left = 432
        Top = 173
        Width = 335
        Height = 21
        TabOrder = 13
      end
      object EditMACADDR: TEdit
        Left = 91
        Top = 211
        Width = 262
        Height = 21
        TabOrder = 14
      end
      object EditBUSINESSVLAN: TEdit
        Left = 616
        Top = 135
        Width = 151
        Height = 21
        TabOrder = 15
      end
      object EditMANAGEVLAN: TEdit
        Left = 432
        Top = 211
        Width = 335
        Height = 21
        TabOrder = 16
      end
      object EditFREQUENCY: TEdit
        Left = 460
        Top = 97
        Width = 128
        Height = 21
        TabOrder = 8
        OnKeyPress = ImputFloat
      end
      object Bt_Del: TButton
        Left = 528
        Top = 250
        Width = 65
        Height = 25
        Caption = #21024#38500
        TabOrder = 21
        OnClick = Bt_DelClick
      end
      object ComboBoxAPPROPERTY: TComboBox
        Left = 91
        Top = 97
        Width = 110
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 22
      end
      object ComboBoxBuilding: TcxComboBox
        Left = 91
        Top = 59
        Properties.AutoSelect = False
        Properties.DropDownListStyle = lsFixedList
        Properties.OnChange = ComboBoxBuildingPropertiesChange
        Style.PopupBorderStyle = epbsFlat
        TabOrder = 23
        Width = 110
      end
      object ButtonClear: TButton
        Left = 601
        Top = 250
        Width = 65
        Height = 25
        Caption = #28165#31354
        TabOrder = 24
        OnClick = ButtonClearClick
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 782
      Height = 302
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 1
      ExplicitWidth = 869
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 782
        Height = 302
        Align = alClient
        Caption = #30456#20851#20449#24687
        TabOrder = 0
        ExplicitWidth = 869
        object AdvStringGrid1: TAdvStringGrid
          Left = 2
          Top = 15
          Width = 778
          Height = 285
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
          ExplicitWidth = 865
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
