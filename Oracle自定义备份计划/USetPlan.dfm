object FormSetPlan: TFormSetPlan
  Left = 448
  Top = 305
  Width = 330
  Height = 282
  Caption = #35745#21010#37197#32622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GrpDay: TGroupBox
    Left = 100
    Top = 7
    Width = 213
    Height = 120
    Caption = #27599#22825
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object GrpWeek: TGroupBox
    Left = 100
    Top = 7
    Width = 213
    Height = 120
    Caption = #27599#21608
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object RbSunday: TRadioButton
      Left = 16
      Top = 80
      Width = 60
      Height = 17
      Caption = #26143#26399#26085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object RbMonday: TRadioButton
      Left = 16
      Top = 27
      Width = 60
      Height = 17
      Caption = #26143#26399#19968
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object RbTuesday: TRadioButton
      Left = 79
      Top = 27
      Width = 60
      Height = 17
      Caption = #26143#26399#20108
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object RbWednesday: TRadioButton
      Left = 144
      Top = 27
      Width = 60
      Height = 17
      Caption = #26143#26399#19977
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object RbSaturday: TRadioButton
      Left = 144
      Top = 55
      Width = 60
      Height = 17
      Caption = #26143#26399#20845
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object RbFriday: TRadioButton
      Left = 79
      Top = 55
      Width = 60
      Height = 17
      Caption = #26143#26399#20116
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object RbThursday: TRadioButton
      Left = 16
      Top = 55
      Width = 60
      Height = 17
      Caption = #26143#26399#22235
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
  end
  object GrpMonth: TGroupBox
    Left = 100
    Top = 7
    Width = 213
    Height = 120
    Caption = #27599#26376
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object Label2: TLabel
      Left = 136
      Top = 45
      Width = 12
      Height = 15
      AutoSize = False
      Caption = #22825
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 52
      Top = 45
      Width = 12
      Height = 15
      AutoSize = False
      Caption = #31532
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SeMonth_DayNum: TSpinEdit
      Left = 77
      Top = 41
      Width = 50
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 2
      MaxValue = 31
      MinValue = 1
      ParentFont = False
      TabOrder = 0
      Value = 1
    end
  end
  object GrpEveryDayFreq: TGroupBox
    Left = 10
    Top = 132
    Width = 303
    Height = 72
    Caption = #25191#34892#26102#38388
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label3: TLabel
      Left = 14
      Top = 29
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #20107#20214#25191#34892#26102#38388
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object DTPlanTime: TDateTimePicker
      Left = 95
      Top = 25
      Width = 137
      Height = 21
      Date = 40024.983766631940000000
      Time = 40024.983766631940000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Kind = dtkTime
      ParentFont = False
      TabOrder = 0
    end
  end
  object BtnOK: TButton
    Left = 124
    Top = 213
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 4
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 236
    Top = 213
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 5
    OnClick = BtnCancelClick
  end
  object RgOccurFreq: TGroupBox
    Left = 9
    Top = 7
    Width = 81
    Height = 120
    Caption = #21457#29983#39057#29575
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    object RbDay: TRadioButton
      Left = 12
      Top = 24
      Width = 50
      Height = 17
      Caption = #27599#22825
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = RbDayClick
    end
    object RbWeek: TRadioButton
      Left = 12
      Top = 48
      Width = 50
      Height = 17
      Caption = #27599#21608
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = RbWeekClick
    end
    object RbMonth: TRadioButton
      Left = 12
      Top = 72
      Width = 50
      Height = 17
      Caption = #27599#26376
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = RbMonthClick
    end
  end
end
