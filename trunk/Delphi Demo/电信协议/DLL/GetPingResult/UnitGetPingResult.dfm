object FormGetPingResult: TFormGetPingResult
  Left = 387
  Top = 263
  Width = 419
  Height = 377
  Caption = #33719#21462'Ping'#21629#20196#30340#32467#26524
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 36
    Top = 28
    Width = 49
    Height = 13
    AutoSize = False
    Caption = 'IP'#22320#22336
  end
  object BtnPing: TButton
    Left = 292
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Ping'
    TabOrder = 0
    OnClick = BtnPingClick
  end
  object Memo1: TMemo
    Left = 36
    Top = 72
    Width = 337
    Height = 249
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object EdtIP: TEdit
    Left = 92
    Top = 24
    Width = 193
    Height = 21
    TabOrder = 2
    Text = '127.0.0.1'
  end
end
