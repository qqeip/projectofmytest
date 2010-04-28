object FrmModifyPwd: TFrmModifyPwd
  Left = 428
  Top = 235
  Width = 260
  Height = 203
  Caption = #20462#25913#23494#30721
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Label3: TLabel
    Left = 24
    Top = 32
    Width = 60
    Height = 12
    Caption = #26032' '#23494' '#30721#65306
  end
  object Label4: TLabel
    Left = 24
    Top = 82
    Width = 60
    Height = 12
    Caption = #23494#30721#30830#35748#65306
  end
  object NewPwd1: TEdit
    Left = 90
    Top = 28
    Width = 135
    Height = 20
    PasswordChar = '*'
    TabOrder = 0
  end
  object NewPwd2: TEdit
    Left = 90
    Top = 78
    Width = 135
    Height = 20
    PasswordChar = '*'
    TabOrder = 1
  end
  object OKB: TBitBtn
    Left = 37
    Top = 121
    Width = 75
    Height = 25
    Caption = #30830#35748'(&C)'
    TabOrder = 2
    OnClick = OKBClick
  end
  object CancleB: TBitBtn
    Left = 145
    Top = 121
    Width = 75
    Height = 25
    Caption = #20851#38381'(&O)'
    TabOrder = 3
    OnClick = CancleBClick
  end
end
