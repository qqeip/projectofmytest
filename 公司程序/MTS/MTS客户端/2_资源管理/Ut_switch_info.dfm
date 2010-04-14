object Frm_switch_info: TFrm_switch_info
  Left = 0
  Top = 0
  Caption = #20132#25442#26426#20449#24687#31649#29702
  ClientHeight = 489
  ClientWidth = 641
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
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Height = 489
    ExplicitLeft = 217
    ExplicitTop = 8
    ExplicitHeight = 399
  end
  object Panel2: TPanel
    Left = 3
    Top = 0
    Width = 638
    Height = 489
    Align = alClient
    Caption = #31649#29702#22320#22336
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 1
      Top = 320
      Width = 636
      Height = 168
      Align = alBottom
      Caption = #20132#25442#26426#20449#24687#24405#20837
      TabOrder = 0
      object Label5: TLabel
        Left = 288
        Top = 62
        Width = 57
        Height = 13
        Caption = #31649' '#29702' '#22320' '#22336
      end
      object Label2: TLabel
        Left = 288
        Top = 31
        Width = 57
        Height = 13
        Caption = #29289' '#29702' '#22320' '#22336
      end
      object Label1: TLabel
        Left = 30
        Top = 31
        Width = 60
        Height = 13
        Caption = #20132#25442#26426#32534#21495
      end
      object Label4: TLabel
        Left = 30
        Top = 94
        Width = 60
        Height = 13
        Caption = #25152#23646#23460#20998#28857
      end
      object Label6: TLabel
        Left = 33
        Top = 62
        Width = 57
        Height = 13
        Caption = #19978' '#36830' '#31471' '#21475
      end
      object Label7: TLabel
        Left = 297
        Top = 94
        Width = 36
        Height = 13
        Caption = #65328#65327#65328
      end
      object Label13: TLabel
        Left = 24
        Top = 32
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
      object Label9: TLabel
        Left = 24
        Top = 30
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
      object Label10: TLabel
        Left = 282
        Top = 32
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
      object Label11: TLabel
        Left = 24
        Top = 95
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
      object ButtonModify: TButton
        Left = 214
        Top = 130
        Width = 65
        Height = 25
        Caption = #20462#25913
        TabOrder = 6
        OnClick = ButtonModifyClick
      end
      object Button2: TButton
        Left = 507
        Top = 130
        Width = 65
        Height = 25
        Caption = #36820#22238
        TabOrder = 8
        OnClick = Button2Click
      end
      object ButtonAdd: TButton
        Left = 142
        Top = 130
        Width = 65
        Height = 25
        Caption = #22686#21152
        TabOrder = 5
        OnClick = ButtonAddClick
      end
      object ButtonConfirm: TButton
        Left = 286
        Top = 130
        Width = 65
        Height = 25
        Caption = #30830#23450
        TabOrder = 7
        OnClick = ButtonConfirmClick
      end
      object EditName: TEdit
        Left = 105
        Top = 28
        Width = 145
        Height = 21
        TabOrder = 0
      end
      object EditAddress: TEdit
        Left = 360
        Top = 28
        Width = 250
        Height = 21
        TabOrder = 1
      end
      object EditAddress2: TEdit
        Left = 360
        Top = 59
        Width = 250
        Height = 21
        TabOrder = 3
      end
      object EditPort: TEdit
        Left = 105
        Top = 59
        Width = 145
        Height = 21
        TabOrder = 2
      end
      object EditPOP: TEdit
        Left = 360
        Top = 91
        Width = 250
        Height = 21
        TabOrder = 4
      end
      object Bt_Del: TButton
        Left = 359
        Top = 130
        Width = 65
        Height = 25
        Caption = #21024#38500
        TabOrder = 9
        OnClick = Bt_DelClick
      end
      object ButtonClear: TButton
        Left = 433
        Top = 130
        Width = 65
        Height = 25
        Caption = #28165#31354
        TabOrder = 10
      end
      object ComboBoxBuilding: TcxComboBox
        Left = 105
        Top = 91
        Properties.AutoSelect = False
        Properties.DropDownListStyle = lsFixedList
        Style.PopupBorderStyle = epbsFlat
        TabOrder = 11
        Width = 145
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 636
      Height = 319
      Align = alClient
      Caption = 'Panel3'
      TabOrder = 1
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 634
        Height = 317
        Align = alClient
        Caption = #30456#20851#20449#24687
        TabOrder = 0
        object AdvStringGrid1: TAdvStringGrid
          Left = 2
          Top = 15
          Width = 630
          Height = 300
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
