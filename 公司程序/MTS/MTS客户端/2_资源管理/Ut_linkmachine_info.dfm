object Fm_linkmachine_info: TFm_linkmachine_info
  Left = 0
  Top = 0
  Caption = #36830#25509#22120#20449#24687#31649#29702
  ClientHeight = 469
  ClientWidth = 797
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
    Width = 797
    Height = 469
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 0
      Top = 264
      Width = 797
      Height = 205
      Align = alBottom
      Caption = #36830#25509#22120#20449#24687#24405#20837
      TabOrder = 0
      object Label2: TLabel
        Left = 442
        Top = 31
        Width = 72
        Height = 13
        Caption = #36830' '#25509' '#22120' '#20301' '#32622
      end
      object Label1: TLabel
        Left = 23
        Top = 31
        Width = 60
        Height = 13
        Caption = #36830#25509#22120#32534#21495
      end
      object Label4: TLabel
        Left = 19
        Top = 75
        Width = 72
        Height = 13
        Caption = #25152' '#23646' '#23460' '#20998' '#28857
      end
      object Label8: TLabel
        Left = 223
        Top = 31
        Width = 72
        Height = 13
        Caption = #36830' '#25509' '#22120' '#31867' '#22411
      end
      object Label9: TLabel
        Left = 223
        Top = 117
        Width = 57
        Height = 13
        Caption = #26159' '#21542' '#24178' '#25918
      end
      object Label10: TLabel
        Left = 442
        Top = 117
        Width = 57
        Height = 13
        Caption = #24178' '#25918' '#20301' '#32622
      end
      object Label11: TLabel
        Left = 20
        Top = 117
        Width = 72
        Height = 13
        Caption = #36830#25509#35774#22791#31867#22411
      end
      object Label5: TLabel
        Left = 223
        Top = 75
        Width = 57
        Height = 13
        Caption = #36830' '#25509' '#22522' '#31449
      end
      object Label6: TLabel
        Left = 442
        Top = 75
        Width = 67
        Height = 13
        Caption = #36830'     '#25509'     AP'
      end
      object Label20: TLabel
        Left = 15
        Top = 31
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
      object Label12: TLabel
        Left = 216
        Top = 31
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
      object Label13: TLabel
        Left = 12
        Top = 117
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
      object Label14: TLabel
        Left = 435
        Top = 31
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
      object Label15: TLabel
        Left = 216
        Top = 117
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
      object Label16: TLabel
        Left = 12
        Top = 75
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
      object Label3: TLabel
        Left = 608
        Top = 75
        Width = 84
        Height = 13
        AutoSize = False
        Caption = #36830#25509'CDMA'#22522#31449
      end
      object ButtonModify: TButton
        Left = 427
        Top = 162
        Width = 65
        Height = 25
        Caption = #20462#25913
        TabOrder = 11
        OnClick = ButtonModifyClick
      end
      object Button2: TButton
        Left = 717
        Top = 162
        Width = 65
        Height = 25
        Caption = #36820#22238
        TabOrder = 14
        OnClick = Button2Click
      end
      object ButtonAdd: TButton
        Left = 356
        Top = 162
        Width = 65
        Height = 25
        Caption = #22686#21152
        TabOrder = 10
        OnClick = ButtonAddClick
      end
      object ButtonConfirm: TButton
        Left = 498
        Top = 162
        Width = 65
        Height = 25
        Caption = #30830#23450
        TabOrder = 12
        OnClick = ButtonConfirmClick
      end
      object EditLINKNO: TEdit
        Left = 97
        Top = 28
        Width = 112
        Height = 21
        TabOrder = 0
      end
      object EditLINKADDR: TEdit
        Left = 519
        Top = 28
        Width = 261
        Height = 21
        TabOrder = 2
      end
      object ComboBoxLINKTYPE: TComboBox
        Left = 298
        Top = 28
        Width = 129
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
      object ComboBoxISTRUNK: TComboBox
        Left = 298
        Top = 114
        Width = 129
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 8
        OnChange = ComboBoxISTRUNKChange
        Items.Strings = (
          #21542
          #26159)
      end
      object EditTRUNKADDR: TEdit
        Left = 519
        Top = 114
        Width = 261
        Height = 21
        TabOrder = 9
      end
      object ComboBoxLINKEQUIPMENT: TComboBox
        Left = 97
        Top = 114
        Width = 112
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 7
        OnChange = ComboBoxLINKEQUIPMENTChange
        Items.Strings = (
          'PHS'
          'WLAN'
          'CDMA'
          'PHS+WLAN'
          'PHS+CDMA'
          'WLAN+CDMA'
          'PHS+WLAN+CDMA')
      end
      object ComboBoxLINKCS: TComboBox
        Left = 298
        Top = 71
        Width = 129
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
      end
      object ComboBoxLINKAP: TComboBox
        Left = 519
        Top = 72
        Width = 83
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
      end
      object Bt_Del: TButton
        Left = 571
        Top = 162
        Width = 65
        Height = 25
        Caption = #21024#38500
        TabOrder = 13
        OnClick = Bt_DelClick
      end
      object ComboBoxLinkCDMA: TComboBox
        Left = 698
        Top = 71
        Width = 82
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 6
      end
      object ComboBoxBuilding: TcxComboBox
        Left = 97
        Top = 71
        Properties.AutoSelect = False
        Properties.DropDownListStyle = lsFixedList
        Properties.OnChange = ComboBoxBuildingPropertiesChange
        Style.PopupBorderStyle = epbsFlat
        TabOrder = 3
        Width = 112
      end
      object ButtonClear: TButton
        Left = 644
        Top = 162
        Width = 65
        Height = 25
        Caption = #28165#31354
        TabOrder = 15
        OnClick = ButtonClearClick
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 797
      Height = 264
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 1
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 797
        Height = 264
        Align = alClient
        Caption = #30456#20851#20449#24687
        TabOrder = 0
        object AdvStringGrid1: TAdvStringGrid
          Left = 2
          Top = 15
          Width = 793
          Height = 247
          Cursor = crDefault
          Align = alClient
          DefaultRowHeight = 21
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
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
          ExplicitLeft = 272
          ExplicitTop = 160
          ExplicitWidth = 400
          ExplicitHeight = 250
        end
      end
    end
  end
end
