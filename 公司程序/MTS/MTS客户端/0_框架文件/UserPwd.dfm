object FormUserPWD: TFormUserPWD
  Left = 370
  Top = 257
  BorderStyle = bsDialog
  Caption = #35774#32622#23494#30721
  ClientHeight = 148
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 68
    Top = 32
    Width = 48
    Height = 13
    Caption = #26032#23494#30721#65306
  end
  object Label2: TLabel
    Left = 56
    Top = 64
    Width = 60
    Height = 13
    Caption = #30830#35748#23494#30721#65306
  end
  object EditNewPwd: TEdit
    Left = 120
    Top = 24
    Width = 161
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
  end
  object EditConfirmPWD: TEdit
    Left = 120
    Top = 56
    Width = 161
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 128
    Top = 104
    Width = 75
    Height = 25
    Caption = #30830#35748
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 224
    Top = 104
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 3
  end
end
