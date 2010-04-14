object FormTestDetail: TFormTestDetail
  Left = 0
  Top = 0
  Caption = #25320#27979#35814#21333#26597#30475
  ClientHeight = 602
  ClientWidth = 799
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
  object Splitter2: TSplitter
    Left = 0
    Top = 160
    Width = 799
    Height = 2
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 113
    ExplicitWidth = 736
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 799
    Height = 160
    Align = alTop
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 1
      Top = 1
      Width = 797
      Height = 158
      Align = alClient
      Caption = 'MTU'#20449#24687#35774#32622
      TabOrder = 0
      object Label1: TLabel
        Left = 23
        Top = 26
        Width = 57
        Height = 13
        AutoSize = False
        Caption = 'MTU'#21517#31216
      end
      object Label2: TLabel
        Left = 23
        Top = 53
        Width = 74
        Height = 13
        AutoSize = False
        Caption = 'MTU'#22806#37096#32534#21495
      end
      object Label3: TLabel
        Left = 23
        Top = 85
        Width = 113
        Height = 13
        AutoSize = False
        Caption = #24403#21069#35813'MTU'#21578#35686#25968#65306
      end
      object Label4: TLabel
        Left = 252
        Top = 126
        Width = 60
        Height = 13
        Caption = #24320#22987#26102#38388#65306
      end
      object Label5: TLabel
        Left = 483
        Top = 126
        Width = 60
        Height = 13
        Caption = #25130#27490#26102#38388#65306
      end
      object Label11: TLabel
        Left = 384
        Top = 53
        Width = 57
        Height = 13
        AutoSize = False
        Caption = 'MTU'#20301#32622
      end
      object Label10: TLabel
        Left = 384
        Top = 26
        Width = 57
        Height = 13
        AutoSize = False
        Caption = #35206#30422#21306#22495
      end
      object Label14: TLabel
        Left = 596
        Top = 26
        Width = 61
        Height = 13
        AutoSize = False
        Caption = #36830#25509#22120#32534#21495
      end
      object Label15: TLabel
        Left = 596
        Top = 53
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #25152#23646#23460#20998#28857
      end
      object Label16: TLabel
        Left = 207
        Top = 26
        Width = 57
        Height = 13
        AutoSize = False
        Caption = 'PHS'#21495#30721
      end
      object Label17: TLabel
        Left = 207
        Top = 53
        Width = 57
        Height = 13
        AutoSize = False
        Caption = #34987#21483#21495#30721
      end
      object EditMTUNo: TEdit
        Left = 91
        Top = 50
        Width = 102
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object EditAlarmCount: TEdit
        Left = 23
        Top = 110
        Width = 59
        Height = 21
        Enabled = False
        TabOrder = 4
      end
      object RadioGroup1: TRadioGroup
        Left = 143
        Top = 78
        Width = 105
        Height = 70
        Caption = #26597#35810#31867#22411#36873#25321
        ItemIndex = 0
        Items.Strings = (
          #26368#36817#27425#25968
          #26102' '#38388' '#27573)
        TabOrder = 5
        OnClick = RadioGroup1Click
      end
      object EditRecentCount1: TEdit
        Left = 253
        Top = 94
        Width = 72
        Height = 21
        Enabled = False
        MaxLength = 3
        TabOrder = 0
        OnKeyPress = EditRecentCount1KeyPress
      end
      object DateTimePickerStartDate: TDateTimePicker
        Left = 313
        Top = 122
        Width = 81
        Height = 21
        Date = 39899.465345405090000000
        Format = 'yyyy-MM-dd'
        Time = 39899.465345405090000000
        Enabled = False
        TabOrder = 2
      end
      object DateTimePickerEndDate: TDateTimePicker
        Left = 545
        Top = 122
        Width = 81
        Height = 21
        Date = 39899.465345405090000000
        Format = 'yyyy-MM-dd'
        Time = 39899.465345405090000000
        Enabled = False
        TabOrder = 3
      end
      object BitBtnClose: TBitBtn
        Left = 714
        Top = 85
        Width = 65
        Height = 25
        Caption = #36864#20986
        TabOrder = 6
        OnClick = BitBtnCloseClick
      end
      object EditMTUName: TEdit
        Left = 91
        Top = 22
        Width = 102
        Height = 21
        Enabled = False
        TabOrder = 7
      end
      object EditADDR: TEdit
        Left = 441
        Top = 50
        Width = 138
        Height = 21
        Enabled = False
        TabOrder = 8
      end
      object EditCover: TEdit
        Left = 441
        Top = 22
        Width = 138
        Height = 21
        Enabled = False
        TabOrder = 9
      end
      object EditCalled: TEdit
        Left = 264
        Top = 50
        Width = 102
        Height = 21
        Enabled = False
        TabOrder = 10
      end
      object EditPHSNo: TEdit
        Left = 264
        Top = 22
        Width = 102
        Height = 21
        Enabled = False
        TabOrder = 11
      end
      object EditBuildingName: TEdit
        Left = 668
        Top = 50
        Width = 102
        Height = 21
        Enabled = False
        TabOrder = 12
      end
      object EditLinkNo: TEdit
        Left = 668
        Top = 22
        Width = 102
        Height = 21
        Enabled = False
        TabOrder = 13
      end
      object BitBtnOK: TBitBtn
        Left = 714
        Top = 119
        Width = 65
        Height = 25
        Caption = #30830#23450
        TabOrder = 14
        OnClick = BitBtnOKClick
      end
      object DateTimePickerStartTime: TDateTimePicker
        Left = 396
        Top = 122
        Width = 81
        Height = 21
        Date = 39899.465345405090000000
        Format = 'HH:mm:ss'
        Time = 39899.465345405090000000
        Enabled = False
        Kind = dtkTime
        TabOrder = 15
      end
      object DateTimePickerEndTime: TDateTimePicker
        Left = 628
        Top = 122
        Width = 81
        Height = 21
        Date = 39899.465345405090000000
        Format = 'HH:mm:ss'
        Time = 39899.465345405090000000
        Enabled = False
        Kind = dtkTime
        TabOrder = 16
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 162
    Width = 799
    Height = 440
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 169
      Top = 1
      Width = 2
      Height = 438
      ExplicitLeft = 123
      ExplicitHeight = 474
    end
    object Panel3: TPanel
      Left = 171
      Top = 1
      Width = 627
      Height = 438
      Align = alClient
      TabOrder = 0
      object GroupBox2: TGroupBox
        Left = 1
        Top = 1
        Width = 625
        Height = 436
        Align = alClient
        Caption = #27979#35797#35814#32454#20449#24687
        TabOrder = 0
        object Panel5: TPanel
          Left = 2
          Top = 15
          Width = 621
          Height = 98
          Align = alTop
          TabOrder = 0
          object Label6: TLabel
            Left = 23
            Top = 40
            Width = 92
            Height = 13
            AutoSize = False
            Caption = #24403#21069#35813'MTU'#29366#24577#65306
          end
          object Label7: TLabel
            Left = 23
            Top = 68
            Width = 92
            Height = 13
            AutoSize = False
            Caption = #24403#21069'WLAN'#29366#24577#65306
          end
          object Label8: TLabel
            Left = 238
            Top = 41
            Width = 113
            Height = 13
            AutoSize = False
            Caption = #24403#21069#35813'MTU'#30005#28304#29366#24577#65306
          end
          object Label9: TLabel
            Left = 23
            Top = 9
            Width = 58
            Height = 13
            AutoSize = False
            Caption = #26368#36817#27425#25968#65306
          end
          object EditRecentCount2: TEdit
            Left = 114
            Top = 6
            Width = 112
            Height = 21
            TabOrder = 0
            OnKeyPress = EditRecentCount1KeyPress
          end
          object EditMTUState: TEdit
            Left = 114
            Top = 35
            Width = 112
            Height = 21
            Enabled = False
            TabOrder = 1
          end
          object EditPowerState: TEdit
            Left = 358
            Top = 37
            Width = 105
            Height = 21
            Enabled = False
            TabOrder = 2
          end
          object EditWLANState: TEdit
            Left = 114
            Top = 65
            Width = 112
            Height = 21
            Enabled = False
            TabOrder = 3
          end
          object BitBtnOK2: TBitBtn
            Left = 238
            Top = 4
            Width = 73
            Height = 25
            Caption = #30830#23450
            TabOrder = 4
            OnClick = BitBtnOK2Click
          end
        end
        object Panel8: TPanel
          Left = 2
          Top = 113
          Width = 621
          Height = 321
          Align = alClient
          Caption = 'Panel8'
          TabOrder = 1
          object Splitter3: TSplitter
            Left = 233
            Top = 1
            Width = 5
            Height = 319
            Align = alRight
            ExplicitLeft = 235
          end
          object Panel7: TPanel
            Left = 238
            Top = 1
            Width = 382
            Height = 319
            Align = alRight
            TabOrder = 0
            object ChartScrollBar1: TChartScrollBar
              Left = 1
              Top = 296
              Width = 380
              Height = 22
              Align = alBottom
              Enabled = True
              LargeChange = 1
              Max = 1
              Min = 1
              PageSize = 1
              Position = 1
              SmallChange = 1
              TabOrder = 0
              Visible = False
              Chart = Chart2
            end
            object Chart2: TChart
              Left = 1
              Top = 1
              Width = 380
              Height = 295
              AllowPanning = pmHorizontal
              Gradient.EndColor = clWhite
              Gradient.StartColor = 12615808
              Gradient.Visible = True
              Legend.Alignment = laTop
              Legend.CheckBoxes = True
              Legend.CheckBoxesStyle = cbsRadio
              Legend.Title.Text.Strings = (
                #26816#27979#31867#22411#36873#25321)
              Legend.Title.TextAlignment = taCenter
              Title.Font.Height = -16
              Title.Text.Strings = (
                #26368#39640#22330#24378#22270#31034)
              OnClickLegend = Chart2ClickLegend
              BottomAxis.LabelsAngle = 90
              BottomAxis.LabelsMultiLine = True
              BottomAxis.Title.Caption = #26816#27979#26102#38388
              LeftAxis.Title.Caption = #26368#22823#22330#24378#20540
              MaxPointsPerPage = 5
              Zoom.Allow = False
              Zoom.Animated = True
              Align = alClient
              BevelInner = bvRaised
              Color = 16636410
              TabOrder = 1
              PrintMargins = (
                15
                11
                15
                11)
              object Series1: TBarSeries
                Marks.Callout.Brush.Color = clBlack
                Marks.Callout.ArrowHead = ahSolid
                Marks.MultiLine = True
                Marks.Style = smsXY
                Marks.Visible = True
                Title = #22522#31449#26368#39640#22330#24378
                Gradient.Direction = gdTopBottom
                SideMargins = False
                XValues.Name = 'X'
                XValues.Order = loNone
                YValues.Name = 'Bar'
                YValues.Order = loNone
              end
              object Series2: TBarSeries
                Active = False
                Marks.Callout.Brush.Color = clBlack
                Marks.MultiLine = True
                Marks.Style = smsXY
                Marks.Visible = True
                Title = 'AP'#26368#39640#22330#24378
                Gradient.Direction = gdTopBottom
                SideMargins = False
                XValues.Name = 'X'
                XValues.Order = loAscending
                YValues.Name = 'Bar'
                YValues.Order = loNone
              end
              object ChartTool3: TPageNumTool
                Callout.Brush.Color = clBlack
                Callout.Arrow.Visible = False
                Text = 'Page %d of %d'
              end
            end
          end
          object Panel6: TPanel
            Left = 1
            Top = 1
            Width = 232
            Height = 319
            Align = alClient
            TabOrder = 1
            object AdvStringGrid1: TAdvStringGrid
              Left = 1
              Top = 1
              Width = 230
              Height = 317
              Cursor = crDefault
              Align = alClient
              DefaultRowHeight = 21
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
              PopupMenu = PopupMenu1
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
            end
          end
        end
      end
    end
    object PanelTestType: TPanel
      Left = 1
      Top = 1
      Width = 168
      Height = 438
      Align = alLeft
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 1
        Top = 1
        Width = 166
        Height = 436
        Align = alClient
        Caption = #27979#35797#31867#22411
        TabOrder = 0
        object TreeView1: TTreeView
          Left = 2
          Top = 15
          Width = 162
          Height = 419
          Align = alClient
          HideSelection = False
          Indent = 19
          RowSelect = True
          TabOrder = 0
          OnChange = TreeView1Change
        end
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 664
    Top = 184
    object N1: TMenuItem
      Caption = #23548#20986#25968#25454
      OnClick = N1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = '*.xls|*.xls'
    Left = 704
    Top = 184
  end
end
