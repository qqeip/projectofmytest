object FormLockSystem: TFormLockSystem
  Left = 395
  Top = 289
  BorderStyle = bsNone
  Caption = 'FormLockSystem'
  ClientHeight = 144
  ClientWidth = 366
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
  object grp1: TGroupBox
    Left = 0
    Top = 0
    Width = 366
    Height = 144
    Align = alClient
    TabOrder = 0
    object lblCaption: TLabel
      Left = 24
      Top = 12
      Width = 249
      Height = 13
      AutoSize = False
      Caption = #31995#32479#24050#34987#38145#23450
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object grp2: TGroupBox
      Left = 24
      Top = 33
      Width = 321
      Height = 65
      TabOrder = 0
      object lbl1: TLabel
        Left = 8
        Top = 32
        Width = 81
        Height = 13
        AutoSize = False
        Caption = #35831#36755#20837#23494#30721#65306
      end
      object EdtUserPWD: TEdit
        Left = 91
        Top = 28
        Width = 215
        Height = 21
        PasswordChar = '*'
        TabOrder = 0
      end
    end
    object btnOK: TButton
      Left = 270
      Top = 108
      Width = 75
      Height = 25
      Caption = #35299#38145
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
