object DMLocal: TDMLocal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 270
  Top = 175
  Height = 254
  Width = 289
  object SocketConnection: TSocketConnection
    ServerGUID = '{574DD770-5701-43A1-BB39-DE9A1DB24635}'
    ServerName = 'MyServer.DataModuleRemote'
    Left = 80
    Top = 64
  end
end
