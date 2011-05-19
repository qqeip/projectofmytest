object FormServerMain: TFormServerMain
  Left = 297
  Top = 200
  Width = 685
  Height = 424
  Caption = 'FormServerMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel4: TPanel
    Left = 0
    Top = 330
    Width = 677
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
    object Label2: TLabel
      Left = 16
      Top = 9
      Width = 135
      Height = 14
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
      Caption = '0'
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlue
      Font.Height = -14
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 437
    Top = 0
    Width = 240
    Height = 330
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Panel_Broad: TPanel
      Left = 2
      Top = 29
      Width = 236
      Height = 236
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Btn_BroadCast: TSpeedButton
        Left = 101
        Top = 205
        Width = 73
        Height = 22
        Caption = #24191'   '#25773
        Flat = True
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00BA641B00A9571900A957
          1900C7702000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00A6561800F6AF6300CF702000FDC7
          9100BD682400FF00FF00FF00FF00FF00FF00FFFAF200FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00AE5C1C00F5A65400F9BF8600D36C1400FCCE
          A200C7763500FF00FF00FF00FF00FFFAF200FFFAF200FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00AE5D1C00F9B26900F9B66F00FCD2A500D6690900FEDB
          BB00D1864100FF00FF00FF00FF00FFFAF200FF00FF00FF00FF00D67E2B00B561
          1F00A8571900A8571900F8B97900F9BD8300FAC58B00FCDAB500DA690200FFEA
          D700E1893B00BD6D2900FF00FF00FF00FF00FF00FF00FF00FF00B6662A00F7BB
          8200FBC58D00F18B3000FDCB9500FED2A100FFD9B400FFEAD400DD710D00FFF5
          E400E7985100F6D7B800BF6E2B00FF00FF00FF00FF00FF00FF00BB6D3100FFDB
          B900FFDAB600F59D4F00FFDAB500FFF3E100FFFCF200FFF9F100E9872800FFFF
          FF00E79B5900FBF1E900CD7C3300FF00FF00FFFAF200FFFAF200C67E4800FFFF
          FF00FFFFFF00FBC28E00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EB944000FFFF
          FF00E79B5900FEFFFF00D6833800FF00FF00FFFAF200FFFAF200DE863D00FEEF
          E200FFFFFF00FFDCBD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F4AA5700FFFF
          FF00E7954C00FDF8F300DE8A3D00FF00FF00FF00FF00FF00FF00E69B4C00E689
          3800E1863600E1873900FFF4E200FFFFFF00FFFFFF00FFFFFF00F7B56800FFFF
          FC00E4914500E38F4000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00E2873600FFFDF600FFFFFF00FFFFFF00F6BB7900FFFB
          F600E4924700FF00FF00FF00FF00FFFAF200FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00E2873600FFFDF500FFFEF800F9C68300FFF9
          F100E4914600FF00FF00FF00FF00FFFAF200FFFAF200FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00E3873700FFFCF400F9CA9400FFEE
          DD00E6934800FF00FF00FF00FF00FF00FF00FFFAF200FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00E5904500E4883800E689
          3900EDA04C00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        ParentFont = False
        OnClick = Btn_BroadCastClick
      end
      object MsgInfo: TMemo
        Left = 0
        Top = 0
        Width = 236
        Height = 193
        Align = alTop
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 2
      Width = 236
      Height = 27
      Align = alTop
      BevelOuter = bvNone
      Caption = #24191' '#25773' '#28040' '#24687
      Font.Charset = GB2312_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 437
    Height = 330
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 434
      Top = 0
      Height = 330
      Align = alRight
    end
    object ListView: TListView
      Left = 0
      Top = 0
      Width = 434
      Height = 330
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
          Caption = #29992#25143#21517#31216
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
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object Status: TStatusBar
    Left = 0
    Top = 365
    Width = 677
    Height = 25
    Panels = <
      item
        Text = #29256#26412#21495#65306'1.0'
        Width = 150
      end
      item
        Text = ' '
        Width = 100
      end
      item
        Text = ' '
        Width = 100
      end
      item
        Alignment = taRightJustify
        Text = #24314#35758#22312#12304'1024'#215'768'#12305#20998#36776#29575#19979#36816#34892
        Width = 200
      end>
  end
  object IdTCPServer: TIdTCPServer
    Bindings = <>
    CommandHandlers = <>
    DefaultPort = 0
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = IdTCPServerConnect
    OnExecute = IdTCPServerExecute
    OnDisconnect = IdTCPServerDisconnect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 304
    Top = 104
  end
end
