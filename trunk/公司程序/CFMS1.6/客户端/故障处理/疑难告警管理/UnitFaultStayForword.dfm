object FormFaultStayForword: TFormFaultStayForword
  Left = 279
  Top = 277
  BorderStyle = bsDialog
  Caption = #30097#38590#24310#26399
  ClientHeight = 114
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 60
    Height = 12
    AutoSize = False
    Caption = #21040#26399#26102#38388
  end
  object Label2: TLabel
    Left = 24
    Top = 48
    Width = 60
    Height = 12
    AutoSize = False
    Caption = #24310#26399#33267
  end
  object Bevel1: TBevel
    Left = 3
    Top = 1
    Width = 310
    Height = 71
    Shape = bsFrame
  end
  object Panel7: TPanel
    Tag = 12
    Left = 89
    Top = 6
    Width = 212
    Height = 29
    BevelOuter = bvNone
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object DateTimePicker1: TDateTimePicker
      Left = 18
      Top = 5
      Width = 103
      Height = 20
      Date = 38612.592544849540000000
      Time = 38612.592544849540000000
      TabOrder = 0
    end
    object DateTimePicker2: TDateTimePicker
      Left = 132
      Top = 5
      Width = 69
      Height = 20
      Date = 38938.707921006940000000
      Format = 'HH:mm'
      Time = 38938.707921006940000000
      Kind = dtkTime
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Tag = 12
    Left = 89
    Top = 37
    Width = 212
    Height = 29
    BevelOuter = bvNone
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object DateTimePicker3: TDateTimePicker
      Left = 18
      Top = 5
      Width = 103
      Height = 20
      Date = 38612.592544849540000000
      Time = 38612.592544849540000000
      TabOrder = 0
    end
    object DateTimePicker4: TDateTimePicker
      Left = 132
      Top = 5
      Width = 69
      Height = 20
      Date = 38938.707921006940000000
      Format = 'HH:mm'
      Time = 38938.707921006940000000
      Kind = dtkTime
      TabOrder = 1
    end
  end
  object OKBtn: TButton
    Left = 85
    Top = 78
    Width = 75
    Height = 25
    Caption = #30830' '#23450
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 181
    Top = 78
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462' '#28040
    TabOrder = 3
    OnClick = CancelBtnClick
  end
end
