object FormChangePWD: TFormChangePWD
  Left = 471
  Top = 324
  Width = 347
  Height = 250
  Caption = #23494#30721#20462#25913
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOK: TButton
    Left = 128
    Top = 173
    Width = 75
    Height = 25
    Caption = #30830#35748
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object BtnClose: TButton
    Left = 224
    Top = 173
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = BtnCloseClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 323
    Height = 145
    TabOrder = 2
    object Label1: TLabel
      Left = 22
      Top = 24
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #21407#23494#30721#65306
    end
    object Label2: TLabel
      Left = 22
      Top = 63
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #26032#23494#30721#65306
    end
    object Label3: TLabel
      Left = 22
      Top = 101
      Width = 80
      Height = 13
      AutoSize = False
      Caption = #30830#35748#26032#23494#30721#65306
    end
    object EdtOldPWD: TEdit
      Left = 103
      Top = 21
      Width = 201
      Height = 21
      TabOrder = 0
    end
    object EdtNewPWD: TEdit
      Left = 103
      Top = 60
      Width = 201
      Height = 21
      TabOrder = 1
    end
    object EdtNewPWDAgain: TEdit
      Left = 103
      Top = 98
      Width = 201
      Height = 21
      TabOrder = 2
    end
  end
end
