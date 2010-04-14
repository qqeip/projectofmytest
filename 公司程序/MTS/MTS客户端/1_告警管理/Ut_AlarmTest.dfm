object Fm_AlarmTest: TFm_AlarmTest
  Left = 0
  Top = 0
  Caption = #21578#35686#25320#27979
  ClientHeight = 477
  ClientWidth = 846
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 846
    Height = 477
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 0
    object Page: TPageControl
      Left = 1
      Top = 1
      Width = 844
      Height = 475
      ActivePage = TabSheet_mtulist
      Align = alClient
      TabOrder = 0
      object TabSheet_mtulist: TTabSheet
        Caption = 'MTU'#21015#34920
        object Splitter1: TSplitter
          Left = 0
          Top = 145
          Width = 836
          Height = 3
          Cursor = crVSplit
          Align = alBottom
          ExplicitTop = 259
          ExplicitWidth = 643
        end
        object GroupBox6: TGroupBox
          Left = 0
          Top = 198
          Width = 836
          Height = 249
          Align = alBottom
          Caption = #21442#25968#35774#32622
          TabOrder = 0
          object AdvSG_ParaSet: TAdvStringGrid
            Left = 2
            Top = 15
            Width = 832
            Height = 232
            Cursor = crDefault
            Align = alClient
            BevelInner = bvNone
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
            ActiveCellFont.Charset = DEFAULT_CHARSET
            ActiveCellFont.Color = clWindowText
            ActiveCellFont.Height = -11
            ActiveCellFont.Name = 'Tahoma'
            ActiveCellFont.Style = [fsBold]
            OnCanEditCell = AdvSG_ParaSetCanEditCell
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
        object GroupBox4: TGroupBox
          Left = 0
          Top = 148
          Width = 836
          Height = 50
          Align = alBottom
          Caption = #27979#35797#21629#20196#31867#22411
          TabOrder = 1
          object CombComType: TComboBox
            Left = 79
            Top = 18
            Width = 145
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = CombComTypeChange
          end
          object ButtonSaveCom: TButton
            Left = 407
            Top = 15
            Width = 89
            Height = 25
            Caption = #29983#25104#27979#35797#20219#21153
            TabOrder = 1
            OnClick = ButtonSaveComClick
          end
          object ButtonAddToAutoTest: TButton
            Left = 502
            Top = 15
            Width = 123
            Height = 25
            Caption = #28155#21152#21040#33258#21160#27979#35797#21015#34920
            TabOrder = 2
            OnClick = ButtonAddToAutoTestClick
          end
          object ButtonTestDetail: TButton
            Left = 633
            Top = 15
            Width = 80
            Height = 25
            Caption = #27979#35797#35814#21333
            TabOrder = 3
            OnClick = ButtonTestDetailClick
          end
        end
        object GroupBox3: TGroupBox
          Left = 0
          Top = 0
          Width = 836
          Height = 145
          Align = alClient
          Caption = 'MTU'#20449#24687
          TabOrder = 2
          object AdvSG_mtuDetail: TAdvStringGrid
            Left = 2
            Top = 15
            Width = 832
            Height = 128
            Cursor = crDefault
            Align = alClient
            DefaultRowHeight = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect]
            ParentFont = False
            PopupMenu = PopupMenuMTU_Detail
            ScrollBars = ssBoth
            TabOrder = 0
            OnClick = AdvSG_mtuDetailClick
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
            SelectionColor = clMenuHighlight
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
      object TabSheetAutoTestList: TTabSheet
        Caption = #33258#21160#27979#35797#21015#34920
        ImageIndex = 2
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 836
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            Left = 16
            Top = 14
            Width = 72
            Height = 13
            Caption = #27979#35797#21629#20196#31867#22411
          end
          object CombComType2: TComboBox
            Left = 103
            Top = 11
            Width = 145
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = CombComType2Change
          end
        end
        object AdvStringGridAutoTest: TAdvStringGrid
          Left = 0
          Top = 41
          Width = 836
          Height = 364
          Cursor = crDefault
          Align = alClient
          ColCount = 7
          DefaultRowHeight = 21
          RowCount = 2
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect]
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 1
          OnClick = AdvStringGridAutoTestClick
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
        end
        object Panel6: TPanel
          Left = 0
          Top = 405
          Width = 836
          Height = 42
          Align = alBottom
          TabOrder = 2
          object Label3: TLabel
            Left = 24
            Top = 16
            Width = 48
            Height = 13
            Caption = #24490#29615#38388#38548
          end
          object Label4: TLabel
            Left = 173
            Top = 16
            Width = 48
            Height = 13
            Caption = #24490#29615#27425#25968
          end
          object Label5: TLabel
            Left = 125
            Top = 16
            Width = 24
            Height = 13
            Caption = #20998#38047
          end
          object Label6: TLabel
            Left = 276
            Top = 16
            Width = 12
            Height = 13
            Caption = #27425
          end
          object SpinEditInterval: TSpinEdit
            Left = 80
            Top = 12
            Width = 43
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 0
            Value = 1
          end
          object SpinEditCounts: TSpinEdit
            Left = 227
            Top = 12
            Width = 43
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 1
            Value = 1
          end
          object ButtonModifyAutoTest: TButton
            Left = 461
            Top = 9
            Width = 75
            Height = 25
            Caption = #20462#25913
            TabOrder = 2
            OnClick = ButtonModifyAutoTestClick
          end
          object ButtonDelAutotest: TButton
            Left = 536
            Top = 9
            Width = 75
            Height = 25
            Caption = #21024#38500
            TabOrder = 3
            OnClick = ButtonDelAutotestClick
          end
        end
      end
      object TabSheet_task: TTabSheet
        Caption = #25163#21160#27979#35797#20219#21153
        ImageIndex = 1
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 836
          Height = 447
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel3'
          TabOrder = 0
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 836
            Height = 447
            Align = alClient
            BevelOuter = bvNone
            Caption = 'Panel4'
            TabOrder = 0
            object Splitter2: TSplitter
              Left = 0
              Top = 195
              Width = 836
              Height = 3
              Cursor = crVSplit
              Align = alBottom
              ExplicitTop = 259
              ExplicitWidth = 643
            end
            object GroupBox2: TGroupBox
              Left = 0
              Top = 198
              Width = 836
              Height = 249
              Align = alBottom
              Caption = #20219#21153#32467#26524
              TabOrder = 0
              object AdvSG_Result: TAdvStringGrid
                Left = 2
                Top = 15
                Width = 832
                Height = 232
                Cursor = crDefault
                Align = alClient
                BevelInner = bvNone
                DefaultRowHeight = 21
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
                Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing, goRowSelect]
                ParentFont = False
                ScrollBars = ssBoth
                TabOrder = 0
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
            object GroupBox8: TGroupBox
              Left = 0
              Top = 145
              Width = 836
              Height = 50
              Align = alBottom
              Caption = #27979#35797#21629#20196#31867#22411
              TabOrder = 1
              object CombSelect: TComboBox
                Left = 77
                Top = 17
                Width = 145
                Height = 21
                Style = csDropDownList
                ItemHeight = 13
                TabOrder = 0
                OnChange = CombSelectChange
              end
              object BtStop: TButton
                Left = 368
                Top = 15
                Width = 73
                Height = 25
                Caption = #20572#27490#20219#21153
                TabOrder = 1
                Visible = False
                OnClick = BtStopClick
              end
              object Bt_deleteCom: TButton
                Left = 448
                Top = 15
                Width = 75
                Height = 25
                Caption = #21024#38500#20219#21153
                TabOrder = 2
                OnClick = Bt_deleteComClick
              end
              object Bt_comfirmResult: TButton
                Left = 529
                Top = 15
                Width = 75
                Height = 25
                Caption = #30830#35748#23436#25104
                TabOrder = 3
                OnClick = Bt_comfirmResultClick
              end
            end
            object GroupBox5: TGroupBox
              Left = 0
              Top = 0
              Width = 836
              Height = 145
              Align = alClient
              Caption = #20219#21153#20449#24687
              TabOrder = 2
            end
            object AdvSG_TaskDetail: TAdvStringGrid
              Left = 0
              Top = 0
              Width = 836
              Height = 145
              Cursor = crDefault
              Align = alClient
              DefaultRowHeight = 21
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect]
              ParentFont = False
              ScrollBars = ssBoth
              TabOrder = 3
              OnClick = AdvSG_TaskDetailClick
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
  end
  object PopupMenuMTU_Detail: TPopupMenu
    Left = 320
    Top = 56
    object MTU1: TMenuItem
      Caption = #21047#26032'MTU'#20449#24687
      OnClick = MTU1Click
    end
  end
end
