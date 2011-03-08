object ServerForm: TServerForm
  Left = 372
  Top = 277
  BorderStyle = bsDialog
  Caption = 'RemObjects Server'
  ClientHeight = 64
  ClientWidth = 228
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RoPoweredByRemObjectsButton1: TROPoweredByRemObjectsButton
    Left = 8
    Top = 8
    Width = 212
    Height = 48
    Cursor = crHandPoint
  end
  object ROMessage: TROBinMessage
    Left = 36
    Top = 8
  end
  object ROServer: TROIndyHTTPServer
    Active = True
    Dispatchers = <
      item
        Name = 'ROMessage'
        Message = ROMessage
        Enabled = True
        PathInfo = 'Bin'
      end>
    IndyServer.Bindings = <>
    IndyServer.CommandHandlers = <>
    IndyServer.DefaultPort = 8099
    IndyServer.Greeting.NumericCode = 0
    IndyServer.MaxConnectionReply.NumericCode = 0
    IndyServer.ReplyExceptionCode = 0
    IndyServer.ReplyTexts = <>
    IndyServer.ReplyUnknownCommand.NumericCode = 0
    Port = 8099
    Left = 8
    Top = 8
  end
end
