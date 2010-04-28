object FrmMain: TFrmMain
  Left = 400
  Top = 152
  BorderStyle = bsDialog
  Caption = 'Corba'#37319#38598#31243#24207
  ClientHeight = 425
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btCDMA: TButton
    Left = 384
    Top = 160
    Width = 75
    Height = 25
    Caption = 'CDMA'#36718#24490
    TabOrder = 0
    OnClick = btCDMAClick
  end
  object reLog: TRichEdit
    Left = 16
    Top = 16
    Width = 361
    Height = 377
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ADOConnection: TADOConnection
    Left = 72
    Top = 16
  end
  object tTime: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tTimeTimer
    Left = 408
    Top = 240
  end
  object tHeartBeat: TTimer
    OnTimer = tHeartBeatTimer
    Left = 416
    Top = 88
  end
end
