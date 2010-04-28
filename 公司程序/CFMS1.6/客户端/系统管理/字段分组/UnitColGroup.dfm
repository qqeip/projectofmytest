object FormcolGroup: TFormcolGroup
  Left = 345
  Top = 268
  BorderStyle = bsDialog
  ClientHeight = 105
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 60
    Height = 12
    Caption = #23383#27573#32452#21517#31216
  end
  object EdGroupName: TEdit
    Left = 94
    Top = 21
    Width = 206
    Height = 20
    MaxLength = 50
    TabOrder = 0
    OnKeyPress = EdGroupNameKeyPress
  end
  object Button: TButton
    Left = 136
    Top = 64
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = ButtonClick
  end
  object Button2: TButton
    Left = 225
    Top = 64
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = Button2Click
  end
end
