object Dm_MTS: TDm_MTS
  OldCreateOrder = False
  Height = 288
  Width = 530
  object cds_common: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 144
    Top = 16
  end
  object SocketConnection1: TSocketConnection
    ServerGUID = '{80D76DB8-03D2-4B73-993C-C3685201EFDC}'
    ServerName = 'MTS_Server.RDM_MTS'
    AfterConnect = SocketConnection1AfterConnect
    Address = '127.0.0.1'
    Left = 40
    Top = 16
  end
  object cds_common1: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 144
    Top = 80
  end
  object cds_Master: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 336
    Top = 16
  end
  object cds_Detail: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 336
    Top = 80
  end
  object cds_Map: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 440
    Top = 16
  end
  object cds_EyeMap: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 440
    Top = 80
  end
  object cds_HMaster: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 336
    Top = 144
  end
  object cds_HDetail: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 336
    Top = 208
  end
  object cds_common2: TClientDataSet
    Aggregates = <>
    Params = <>
    RemoteServer = SocketConnection1
    Left = 144
    Top = 144
  end
end
