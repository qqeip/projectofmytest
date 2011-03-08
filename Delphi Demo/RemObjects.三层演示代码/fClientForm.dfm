object ClientForm: TClientForm
  Left = 283
  Top = 106
  Width = 849
  Height = 397
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
  object DBGrid1: TDBGrid
    Left = 32
    Top = 168
    Width = 689
    Height = 185
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 744
    Top = 48
    Width = 81
    Height = 25
    Caption = #26597#35810'SQL'
    TabOrder = 1
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 32
    Top = 32
    Width = 689
    Height = 129
    Caption = 'SQL'#35821#21477
    TabOrder = 2
    object Memo1: TMemo
      Left = 2
      Top = 15
      Width = 685
      Height = 112
      Align = alClient
      TabOrder = 0
    end
  end
  object Button2: TButton
    Left = 744
    Top = 88
    Width = 82
    Height = 25
    Caption = #25191#34892'SQL'
    TabOrder = 3
    OnClick = Button2Click
  end
  object ROMessage: TROBinMessage
    Left = 36
    Top = 8
  end
  object ROChannel: TROIndyTCPChannel
    ServerLocators = <>
    DispatchOptions = []
    Port = 4325
    Host = '127.0.0.1'
    IndyClient.MaxLineAction = maException
    IndyClient.ReadTimeout = 0
    IndyClient.Host = '127.0.0.1'
    IndyClient.Port = 4325
    Left = 8
    Top = 8
  end
  object RORemoteService: TRORemoteService
    Message = ROMessage
    Channel = ROChannel
    ServiceName = 'OracleAccessService'
    Left = 64
    Top = 8
  end
  object DataSource1: TDataSource
    Left = 168
    Top = 40
  end
  object ADODataSet1: TADODataSet
    Parameters = <>
    Left = 256
    Top = 72
  end
end
