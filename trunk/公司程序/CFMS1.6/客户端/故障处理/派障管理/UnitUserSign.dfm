object FormUserSign: TFormUserSign
  Left = 305
  Top = 270
  BorderStyle = bsDialog
  Caption = #35828#26126
  ClientHeight = 159
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Bevel1: TBevel
    Left = 8
    Top = 3
    Width = 365
    Height = 113
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 109
    Top = 124
    Width = 75
    Height = 25
    Caption = #30830' '#23450
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 205
    Top = 124
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462' '#28040
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object Memo1: TMemo
    Left = 11
    Top = 6
    Width = 358
    Height = 107
    TabOrder = 2
  end
end
