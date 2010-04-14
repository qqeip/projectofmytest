object Fm_TestParamSet: TFm_TestParamSet
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #27979#35797#21442#25968#35774#32622
  ClientHeight = 479
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 559
    Height = 479
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #21629#20196#21442#25968#35774#32622
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 551
        Height = 65
        Align = alTop
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 1
          Top = 1
          Width = 549
          Height = 63
          Align = alClient
          Caption = #27979#35797#21629#20196
          TabOrder = 0
          object Label1: TLabel
            Left = 52
            Top = 29
            Width = 60
            Height = 12
            Margins.Bottom = 0
            Caption = #21629#20196#21517#31216#65306
          end
          object Cmb_CmdName: TComboBox
            Left = 118
            Top = 26
            Width = 145
            Height = 20
            Style = csDropDownList
            ItemHeight = 12
            TabOrder = 0
            TabStop = False
            OnChange = Cmb_CmdNameChange
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 65
        Width = 551
        Height = 387
        Align = alClient
        TabOrder = 1
        object GroupBox2: TGroupBox
          Left = 1
          Top = 1
          Width = 549
          Height = 385
          Align = alClient
          Caption = #21629#20196#21442#25968#35774#32622#65288#21333#20987#21442#25968#20540#36825#21015#65292#21487#32534#36753#65292#28857#30830#23450#20445#23384#65289
          TabOrder = 0
          object Panel3: TPanel
            Left = 2
            Top = 341
            Width = 545
            Height = 42
            Align = alBottom
            TabOrder = 0
            object Btn_OK: TButton
              Left = 390
              Top = 9
              Width = 75
              Height = 25
              Caption = #20445#23384
              TabOrder = 0
              OnClick = Btn_OKClick
            end
            object Btn_Quit: TButton
              Left = 464
              Top = 9
              Width = 75
              Height = 25
              Caption = #36864#20986
              TabOrder = 1
              OnClick = Btn_QuitClick
            end
          end
          object AdvGrid_PValue: TAdvStringGrid
            Left = 2
            Top = 14
            Width = 545
            Height = 327
            Cursor = crDefault
            Align = alClient
            DefaultRowHeight = 21
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Tahoma'
            Font.Style = []
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
            ActiveCellFont.Charset = DEFAULT_CHARSET
            ActiveCellFont.Color = clWindowText
            ActiveCellFont.Height = -11
            ActiveCellFont.Name = 'Tahoma'
            ActiveCellFont.Style = [fsBold]
            OnCanEditCell = AdvGrid_PValueCanEditCell
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
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #21629#20196#25191#34892#27425#24207#35774#32622
      ImageIndex = 1
      object SpeedButton1: TSpeedButton
        Left = 244
        Top = 190
        Width = 40
        Height = 24
        Caption = '>>>'
        OnClick = SpeedButton1Click
      end
      object Panel4: TPanel
        Left = 0
        Top = 410
        Width = 551
        Height = 42
        Align = alBottom
        TabOrder = 0
        object Label2: TLabel
          Left = 131
          Top = 17
          Width = 257
          Height = 12
          Margins.Bottom = 0
          Caption = #27880':'#25302#26355#24207#21495#36827#34892#25490#24207','#21452#20987#36873#20013#21629#20196#39033#21487#21024#38500
        end
        object Button1: TButton
          Left = 394
          Top = 10
          Width = 75
          Height = 25
          Caption = #20445#23384
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 468
          Top = 10
          Width = 75
          Height = 25
          Caption = #36864#20986
          TabOrder = 1
          OnClick = Btn_QuitClick
        end
      end
      object clb_cmd: TCheckListBox
        Left = 0
        Top = 3
        Width = 241
        Height = 401
        ItemHeight = 12
        TabOrder = 1
      end
      object ListView: TListView
        Left = 288
        Top = 2
        Width = 260
        Height = 402
        Hint = #25302#26355#24207#21495#36827#34892#25490#24207','#21452#20987#21629#20196#39033#21487#21024#38500
        Columns = <
          item
            Caption = #24207#21495
          end
          item
            Caption = #21629#20196#21517#31216
            Width = 200
          end>
        Ctl3D = False
        DragMode = dmAutomatic
        RowSelect = True
        ParentShowHint = False
        ShowHint = True
        SortType = stText
        TabOrder = 2
        ViewStyle = vsReport
        OnDblClick = ListViewDblClick
        OnDragDrop = ListViewDragDrop
        OnDragOver = ListViewDragOver
      end
    end
  end
end
