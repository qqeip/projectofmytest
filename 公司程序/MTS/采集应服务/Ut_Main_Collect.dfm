object Fm_Main_Collect: TFm_Main_Collect
  Left = 0
  Top = 0
  Caption = #23460#20869#20998#24067#33258#21160#30417#27979#31995#32479#37319#38598#26381#21153
  ClientHeight = 734
  ClientWidth = 688
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 0
    Top = 313
    Width = 688
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 198
    ExplicitWidth = 652
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 316
    Width = 688
    Height = 399
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #36816#34892#26085#24535
      object Memo_LOG: TMemo
        Left = 0
        Top = 0
        Width = 680
        Height = 372
        Align = alClient
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        PopupMenu = PopupMenu1
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 715
    Width = 688
    Height = 19
    Panels = <
      item
        Text = #29256#26435#65306#26477#24030#32428#22320#36890#35759#31185#25216#26377#38480#20844#21496
        Width = 200
      end
      item
        Text = #29256#26412#65306'4.0.1 Build120'
        Width = 250
      end
      item
        Width = 50
      end>
  end
  object PageControl2: TPageControl
    Left = 0
    Top = 0
    Width = 688
    Height = 313
    ActivePage = TabSheet3
    Align = alTop
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 2
    TabWidth = 100
    object TabSheet2: TTabSheet
      Caption = 'MTU'#25511#21046#22120#21015#34920
      object Lv_MtuCsc: TListView
        Left = 0
        Top = 0
        Width = 680
        Height = 286
        Align = alClient
        Columns = <
          item
            Caption = #22320#24066#32534#21495
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = 'MTU'#25511#21046#22120
            Width = 200
          end
          item
            Alignment = taCenter
            Caption = 'IP'#22320#22336
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = #29366#24577#21464#26356#26102#38388
            Width = 150
          end
          item
            Alignment = taCenter
            Caption = #24403#21069#29366#24577
            Width = 100
          end>
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object TabSheet3: TTabSheet
      Caption = #32447#31243#21015#34920
      ImageIndex = 1
      object Lv_ThreadList: TListView
        Left = 0
        Top = 0
        Width = 680
        Height = 286
        Align = alClient
        Columns = <
          item
            Caption = #24207#21495
          end
          item
            Alignment = taCenter
            Caption = #32447#31243#21517#31216
            Width = 200
          end
          item
            Alignment = taCenter
            Caption = #32447#31243#29366#24577
            Width = 100
          end
          item
            Alignment = taCenter
            Caption = #25191#34892#21608#26399
            Width = 80
          end
          item
            Alignment = taCenter
            Caption = #25191#34892#29366#24577
            Width = 80
          end
          item
            Alignment = taCenter
            Caption = #21551#21160#26102#38388
            Width = 200
          end>
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = #23435#20307
        Font.Style = []
        GridLines = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        PopupMenu = PopupMenuThread
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 160
    Top = 64
    object N1: TMenuItem
      Caption = #31995#32479
      object N3: TMenuItem
        Caption = #35774#32622
        OnClick = N3Click
      end
      object N6: TMenuItem
        Caption = #27979#35797#32467#26524#26597#35810
        OnClick = N6Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object N7: TMenuItem
        Caption = #36864#20986
      end
    end
    object N4: TMenuItem
      Caption = #24110#21161
      object N5: TMenuItem
        Caption = #20851#20110
      end
    end
  end
  object LogTimer: TTimer
    Enabled = False
    Interval = 3000
    Left = 328
    Top = 64
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 200
    Top = 64
    object RefreshLog: TMenuItem
      Caption = #21047#26032#26085#24535
      OnClick = RefreshLogClick
    end
    object MenuItem1: TMenuItem
      Caption = #21047#26032#35774#32622
    end
  end
  object PopupMenuThread: TPopupMenu
    OnPopup = PopupMenuThreadPopup
    Left = 120
    Top = 64
    object MenuItemThreadStart: TMenuItem
      Caption = #21551#21160
      OnClick = MenuItemThreadStartClick
    end
    object MenuItemThreadStop: TMenuItem
      Caption = #20572#27490
      Enabled = False
      OnClick = MenuItemThreadStopClick
    end
  end
  object IdCollectServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnConnect = IdCollectServerConnect
    OnDisconnect = IdCollectServerDisconnect
    OnException = IdCollectServerException
    Scheduler = IdSchedulerOfThreadPool1
    OnExecute = IdCollectServerExecute
    Left = 240
    Top = 64
  end
  object Adoc_Main: TADOConnection
    ConnectionString = 
      'Provider=MSDAORA.1;Password=mts;User ID=mts;Data Source=pop_10.0' +
      '.0.22;Persist Security Info=True'
    KeepConnection = False
    LoginPrompt = False
    Provider = 'MSDAORA.1'
    Left = 368
    Top = 64
  end
  object AdoQ_Free: TADOQuery
    Connection = Adoc_Main
    Parameters = <>
    Left = 400
    Top = 64
  end
  object IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool
    MaxThreads = 0
    Left = 440
    Top = 64
  end
  object Sc_Client: TSocketConnection
    ServerGUID = '{80D76DB8-03D2-4B73-993C-C3685201EFDC}'
    ServerName = 'MTS_Server.RDM_MTS'
    AfterConnect = Sc_ClientAfterConnect
    AfterDisconnect = Sc_ClientAfterDisconnect
    Address = '10.0.0.15'
    Left = 488
    Top = 64
  end
end
