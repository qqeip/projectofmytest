object DataModuleLocal: TDataModuleLocal
  OldCreateOrder = False
  Left = 192
  Top = 107
  Height = 337
  Width = 224
  object SocketConnection: TSocketConnection
    ServerGUID = '{AF4C6EA0-E6B8-43C4-A5F4-27B656042ECD}'
    ServerName = 'ProjectCFMS_Server.DataModuleRemote'
    AfterConnect = SocketConnectionAfterConnect
    Left = 16
    Top = 8
  end
  object ClientDataSetDym: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 56
  end
  object ClientDataSetWav: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 240
  end
end
