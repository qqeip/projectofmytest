object ClientForm: TClientForm
  Left = 372
  Top = 277
  Width = 228
  Height = 172
  Caption = 'RemObjects Client'
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
  object Button1: TButton
    Left = 120
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Sum'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 96
    Width = 97
    Height = 25
    Caption = 'GetServerTime'
    TabOrder = 1
    OnClick = Button2Click
  end
  object ROMessage: TROBinMessage
    Left = 36
    Top = 8
  end
  object ROChannel: TROWinInetHTTPChannel
    UserAgent = 'RemObjects SDK'
    TargetURL = 'http://localhost:8099/BIN'
    ServerLocators = <>
    DispatchOptions = []
    Left = 8
    Top = 8
  end
  object RORemoteService: TRORemoteService
    Message = ROMessage
    Channel = ROChannel
    ServiceName = 'TestService'
    Left = 64
    Top = 8
  end
end
