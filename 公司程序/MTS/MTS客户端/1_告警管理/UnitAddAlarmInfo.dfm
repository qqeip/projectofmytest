object FormAddAlarmInfo: TFormAddAlarmInfo
  Left = 235
  Top = 165
  BorderStyle = bsDialog
  Caption = #21578#35686#38468#21152#20449#24687#20462#25913#31383#21475
  ClientHeight = 197
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Bevel1: TBevel
    Left = 5
    Top = 8
    Width = 412
    Height = 137
    Shape = bsFrame
  end
  object Label6: TLabel
    Left = 32
    Top = 85
    Width = 60
    Height = 12
    Alignment = taRightJustify
    Caption = #21578#35686#22791#27880#65306
  end
  object Label2: TLabel
    Left = 38
    Top = 22
    Width = 54
    Height = 12
    Alignment = taRightJustify
    Caption = 'MTU'#32534#21495#65306
  end
  object Label4: TLabel
    Left = 32
    Top = 53
    Width = 60
    Height = 12
    Alignment = taRightJustify
    Caption = #21578#35686#21517#31216#65306
  end
  object Label1: TLabel
    Left = 104
    Top = 22
    Width = 36
    Height = 12
    Caption = 'Label1'
  end
  object Label7: TLabel
    Left = 104
    Top = 53
    Width = 36
    Height = 12
    Caption = 'Label7'
  end
  object Button1: TButton
    Left = 128
    Top = 160
    Width = 70
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 216
    Top = 160
    Width = 70
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = Button2Click
  end
  object Ed_Remark: TEdit
    Left = 104
    Top = 81
    Width = 289
    Height = 20
    TabOrder = 2
  end
end
