object Fm_MTS_Server: TFm_MTS_Server
  Left = 0
  Top = 0
  Caption = #23460#20869#20998#24067#33258#21160#30417#27979#31995#32479#24212#26381
  ClientHeight = 512
  ClientWidth = 772
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 772
    Height = 493
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    TabWidth = 250
    object TabSheet1: TTabSheet
      Caption = #29992#25143#30417#25511
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      object Panel1: TPanel
        Left = 0
        Top = 431
        Width = 764
        Height = 35
        Align = alBottom
        BevelInner = bvLowered
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 9
          Width = 135
          Height = 14
          Margins.Bottom = 0
          Caption = #24403#21069#25968#25454#24211#36830#25509#25968#65306
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Lb_ClientCount: TLabel
          Left = 176
          Top = 9
          Width = 8
          Height = 14
          Margins.Bottom = 0
          Caption = '0'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -14
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 764
        Height = 431
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Splitter1: TSplitter
          Left = 761
          Top = 0
          Height = 431
          Align = alRight
          ExplicitLeft = 624
          ExplicitHeight = 420
        end
        object Lv_UserList: TListView
          Left = 0
          Top = 0
          Width = 761
          Height = 431
          Align = alClient
          Columns = <
            item
              Caption = 'IP'#22320#22336
              Width = 100
            end
            item
              Caption = #29992#25143#24080#21495
              Width = 100
            end
            item
              Caption = #22320#24066#32534#21495
              Width = 80
            end
            item
              Caption = #37066#21439#32534#21495
              Width = 80
            end
            item
              Caption = #24320#22987#36830#25509#26102#38388
              Width = 150
            end>
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          GridLines = True
          RowSelect = True
          ParentFont = False
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #28040#24687#26085#24535
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 4
      ExplicitWidth = 728
      ExplicitHeight = 485
      object MsgLog: TRichEdit
        Left = 0
        Top = 0
        Width = 764
        Height = 466
        Align = alClient
        Lines.Strings = (
          '')
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Button1: TButton
        Left = 280
        Top = 160
        Width = 73
        Height = 25
        Caption = #27979#35797#25353#38062
        TabOrder = 1
        Visible = False
        OnClick = Button1Click
      end
    end
  end
  object Status: TStatusBar
    Left = 0
    Top = 493
    Width = 772
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool
    MaxThreads = 0
    Left = 256
    Top = 80
  end
  object IdMsgServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnDisconnect = IdMsgServerDisconnect
    Scheduler = IdSchedulerOfThreadPool1
    OnExecute = IdMsgServerExecute
    Left = 192
    Top = 80
  end
end
