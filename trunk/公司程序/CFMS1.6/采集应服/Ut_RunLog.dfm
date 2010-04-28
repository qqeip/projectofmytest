object Fm_RunLog: TFm_RunLog
  Left = 65
  Top = 114
  Width = 807
  Height = 569
  Caption = #31995#32479#36816#34892#26085#24535#26597#30475#31383#21475
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 799
    Height = 542
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    TabHeight = 30
    TabOrder = 0
    TabPosition = tpRight
    TabWidth = 200
    object TabSheet1: TTabSheet
      Caption = #31995#32479#36816#34892#26085#24535
      object Re_RunLog: TRichEdit
        Left = 0
        Top = 0
        Width = 761
        Height = 534
        Align = alClient
        ImeName = #20013#25991' ('#31616#20307') - '#29579#30721#20116#31508#22411'98'#29256
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = #23454#26102#28040#24687#26085#24535
      ImageIndex = 1
      object Message_Log: TRichEdit
        Left = 0
        Top = 0
        Width = 761
        Height = 534
        Align = alClient
        ImeName = #20013#25991' ('#31616#20307') - '#29579#30721#20116#31508#22411'98'#29256
        Lines.Strings = (
          '')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object AlarmTestClient: TIdUDPClient
    Port = 0
    Left = 284
    Top = 84
  end
  object AlarmTestServer: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    OnUDPRead = AlarmTestServerUDPRead
    Left = 284
    Top = 44
  end
end
