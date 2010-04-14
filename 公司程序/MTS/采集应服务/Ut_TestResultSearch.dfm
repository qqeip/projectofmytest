object Fm_TestResult: TFm_TestResult
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #27979#35797#32467#26524#26597#35810
  ClientHeight = 467
  ClientWidth = 842
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 635
    Top = 0
    Width = 207
    Height = 467
    Align = alRight
    Caption = #26597#35810#26465#20214
    TabOrder = 0
    object Label1: TLabel
      Left = 36
      Top = 32
      Width = 84
      Height = 13
      Margins.Bottom = 0
      Caption = #27979#35797#32467#26524#21629#20196#65306
    end
    object Label2: TLabel
      Left = 37
      Top = 96
      Width = 63
      Height = 13
      Margins.Bottom = 0
      Caption = #27979#35797#26102#38388#20174' '
    end
    object Label3: TLabel
      Left = 37
      Top = 152
      Width = 15
      Height = 13
      Margins.Bottom = 0
      Caption = #33267' '
    end
    object Label4: TLabel
      Left = 35
      Top = 216
      Width = 72
      Height = 13
      Margins.Bottom = 0
      Caption = #27979#35797#20219#21153#21495#65306
    end
    object cbb_cmd: TComboBox
      Left = 36
      Top = 57
      Width = 164
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 13
      TabOrder = 0
    end
    object Dtp_StartDate: TDateTimePicker
      Left = 35
      Top = 120
      Width = 83
      Height = 21
      Date = 39567.388115405090000000
      Time = 39567.388115405090000000
      Enabled = False
      TabOrder = 1
    end
    object Dtp_StartTime: TDateTimePicker
      Left = 115
      Top = 120
      Width = 83
      Height = 21
      Date = 39567.388115405090000000
      Time = 39567.388115405090000000
      Enabled = False
      Kind = dtkTime
      TabOrder = 2
    end
    object Dtp_EndDate: TDateTimePicker
      Left = 35
      Top = 176
      Width = 83
      Height = 21
      Date = 39567.388115405090000000
      Time = 39567.388115405090000000
      Enabled = False
      TabOrder = 3
    end
    object Dtp_EndTime: TDateTimePicker
      Left = 115
      Top = 176
      Width = 83
      Height = 21
      Date = 39567.388115405090000000
      Time = 39567.388115405090000000
      Enabled = False
      Kind = dtkTime
      TabOrder = 4
    end
    object Button1: TButton
      Left = 66
      Top = 334
      Width = 75
      Height = 25
      Caption = #26597#35810
      TabOrder = 5
      OnClick = Button1Click
    end
    object Et_TaskId: TEdit
      Left = 35
      Top = 240
      Width = 163
      Height = 21
      Enabled = False
      TabOrder = 6
      OnKeyPress = Et_TaskIdKeyPress
    end
    object CheckBox1: TCheckBox
      Tag = 1
      Left = 9
      Top = 30
      Width = 20
      Height = 17
      TabOrder = 7
      OnClick = CheckBox1Click
    end
    object CheckBox2: TCheckBox
      Tag = 2
      Left = 9
      Top = 96
      Width = 20
      Height = 17
      TabOrder = 8
      OnClick = CheckBox1Click
    end
    object CheckBox3: TCheckBox
      Tag = 3
      Left = 9
      Top = 216
      Width = 20
      Height = 17
      TabOrder = 9
      OnClick = CheckBox1Click
    end
    object CheckBox4: TCheckBox
      Tag = 4
      Left = 9
      Top = 272
      Width = 88
      Height = 17
      Caption = 'MTU'#32534#21495
      TabOrder = 10
      OnClick = CheckBox1Click
    end
    object Et_MtuNo: TEdit
      Left = 41
      Top = 295
      Width = 163
      Height = 21
      Enabled = False
      TabOrder = 11
    end
  end
  object Adv_TestResult: TAdvStringGrid
    Left = 0
    Top = 0
    Width = 635
    Height = 467
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
    TabOrder = 1
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
