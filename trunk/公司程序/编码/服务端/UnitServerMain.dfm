object FormServerMain: TFormServerMain
  Left = 2
  Top = 137
  Width = 1022
  Height = 527
  Caption = #29992#25143#30331#24405#31649#29702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 1014
    Height = 59
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = #33258#21160#27966#38556#31995#32479#24212#29992#26381#21153
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -29
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Status: TStatusBar
    Left = 0
    Top = 475
    Width = 1014
    Height = 25
    Panels = <
      item
        Text = #27966#38556#24212#26381#29256#26412#21495#65306'1.0'
        Width = 300
      end
      item
        Text = ' '
        Width = 210
      end
      item
        Text = ' '
        Width = 300
      end
      item
        Alignment = taRightJustify
        Text = #24314#35758#22312#12304'1024'#215'768'#12305#20998#36776#29575#19979#36816#34892
        Width = 240
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 59
    Width = 1014
    Height = 416
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = '@'#23435#20307
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 2
    TabPosition = tpRight
    TabWidth = 250
    object TabSheet1: TTabSheet
      Caption = #29992#25143#30417#25511
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      object Panel4: TPanel
        Left = 0
        Top = 373
        Width = 970
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
        Left = 671
        Top = 0
        Width = 299
        Height = 373
        Align = alRight
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object Panel_Broad: TPanel
          Left = 2
          Top = 29
          Width = 295
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
            Width = 295
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
          Width = 295
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
        Width = 671
        Height = 373
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object Splitter1: TSplitter
          Left = 668
          Top = 0
          Height = 373
          Align = alRight
        end
        object ListView: TListView
          Left = 0
          Top = 0
          Width = 668
          Height = 373
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
              Caption = #22478#24066#32534#21495
              Width = 80
            end
            item
              Caption = #21333#20301#32534#21495
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
      object MsgLog: TRichEdit
        Left = 0
        Top = 0
        Width = 970
        Height = 157
        Align = alClient
        Lines.Strings = (
          '')
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Panel7: TPanel
        Left = 0
        Top = 157
        Width = 970
        Height = 251
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 1
        Visible = False
        object GroupBox1: TGroupBox
          Left = 19
          Top = 148
          Width = 814
          Height = 84
          Caption = 'scktsrvr'#35774#32622
          TabOrder = 0
          object Label6: TLabel
            Left = 16
            Top = 52
            Width = 144
            Height = 12
            Caption = '<scktsrvr'#26381#21153'>'#25152#22312#36335#24452#65306
          end
          object Sb_ScktSrvr: TSpeedButton
            Left = 744
            Top = 47
            Width = 49
            Height = 22
            Caption = #8230
            Flat = True
            OnClick = Sb_ScktSrvrClick
          end
          object Ed_ScktSrvr: TEdit
            Left = 166
            Top = 48
            Width = 571
            Height = 20
            TabOrder = 0
          end
          object Chb_Scktsrvr: TCheckBox
            Left = 16
            Top = 20
            Width = 433
            Height = 17
            Caption = #31995#32479#21551#21160#26102#33258#21160#21551#21160'<scktsrvr.exe>'#26381#21153'('#22914#26524#26381#21153#24050#23384#22312#65292#23558#20851#38381#21518#37325#21551')'
            TabOrder = 1
            OnClick = Chb_ScktsrvrClick
          end
          object Chb_ScktsrvrClose: TCheckBox
            Left = 480
            Top = 20
            Width = 241
            Height = 17
            Caption = #31995#32479#20851#38381#26102#21516#26102#20851#38381'<scktsrvr.exe>'#26381#21153
            TabOrder = 2
          end
        end
        object Chb_Startup: TCheckBox
          Left = 21
          Top = 18
          Width = 228
          Height = 17
          Caption = #33258#21160#21551#21160'<'#25968#25454#37319#38598#24212#26381'>'
          TabOrder = 1
        end
        object Chb_Patrol: TCheckBox
          Left = 286
          Top = 18
          Width = 265
          Height = 17
          Caption = #24033#26816'<'#25968#25454#37319#38598#24212#26381'>'#65292#33258#21160#20462#27491#19981#27491#24120#24773#20917
          TabOrder = 2
          OnClick = Chb_PatrolClick
        end
        object Gb_patrol: TGroupBox
          Left = 19
          Top = 43
          Width = 814
          Height = 98
          Caption = #24033#26816#21442#25968#35774#32622
          TabOrder = 3
          object Label1: TLabel
            Left = 16
            Top = 20
            Width = 144
            Height = 12
            Caption = '<'#25968#25454#37319#38598#24212#26381'>'#25152#22312#36335#24452#65306
          end
          object Label3: TLabel
            Left = 16
            Top = 48
            Width = 144
            Height = 12
            Caption = '<'#25968#25454#37319#38598#24212#26381'>'#26631#39064#21517#31216#65306
          end
          object Label4: TLabel
            Left = 488
            Top = 48
            Width = 24
            Height = 12
            Caption = #27599#38548
          end
          object Label5: TLabel
            Left = 576
            Top = 48
            Width = 156
            Height = 12
            Caption = #20998#38047#24033#26816'<'#25968#25454#37319#38598#24212#26381'>'#19968#27425
          end
          object Sb_AppPath: TSpeedButton
            Left = 744
            Top = 15
            Width = 49
            Height = 22
            Caption = #8230
            Flat = True
            OnClick = Sb_AppPathClick
          end
          object Sb_AppTitle: TSpeedButton
            Left = 376
            Top = 43
            Width = 49
            Height = 22
            Caption = #40664#35748#20540
            Flat = True
            OnClick = Sb_AppTitleClick
          end
          object Ed_AppPath: TEdit
            Left = 168
            Top = 16
            Width = 569
            Height = 20
            TabOrder = 0
          end
          object Se_Interval: TSpinEdit
            Left = 520
            Top = 44
            Width = 49
            Height = 21
            MaxValue = 30
            MinValue = 1
            TabOrder = 1
            Value = 5
            OnChange = Se_IntervalChange
          end
          object Ed_AppTitle: TEdit
            Left = 168
            Top = 44
            Width = 201
            Height = 20
            TabOrder = 2
            Text = #21578#35686#37319#38598#21450#27966#21457#26381#21153#31995#32479
          end
          object Pb_Patrol: TProgressBar
            Left = 16
            Top = 70
            Width = 721
            Height = 12
            Step = 1
            TabOrder = 3
          end
        end
        object Bt_CloseApp: TButton
          Left = 863
          Top = 52
          Width = 75
          Height = 25
          Caption = #31435#21363#20851#38381
          TabOrder = 4
          OnClick = Bt_CloseAppClick
        end
        object Bt_RunApp: TButton
          Left = 863
          Top = 92
          Width = 75
          Height = 25
          Caption = #31435#21363#36215#21160
          TabOrder = 5
          OnClick = Bt_RunAppClick
        end
        object Bt_SaveParam: TButton
          Left = 863
          Top = 196
          Width = 75
          Height = 25
          Caption = #20445#23384#21442#25968
          TabOrder = 6
          OnClick = Bt_SaveParamClick
        end
        object Chb_AppClose: TCheckBox
          Left = 592
          Top = 18
          Width = 241
          Height = 17
          Caption = #31995#32479#20851#38381#26102#21516#26102#20851#38381'<'#25968#25454#37319#38598#24212#26381'>'#26381#21153
          TabOrder = 7
        end
      end
    end
  end
  object PopMenu_User: TPopupMenu
    Images = ImageList1
    Left = 264
    Top = 111
    object PM_DisConnect: TMenuItem
      Caption = #26029#24320
      ImageIndex = 1
      OnClick = PM_DisConnectClick
    end
  end
  object ImageList1: TImageList
    Left = 296
    Top = 111
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BA641B00A9571900A9571900C77020000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000A6561800F6AF6300CF702000FDC79100BD6824000000
      00000000000000000000FFFAF200000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AE5C1C00F5A65400F9BF8600D36C1400FCCEA200C77635000000
      000000000000FFFAF200FFFAF200000000000000000000000000808000008080
      0000000000008080000000000000808000008080000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000AE5D1C00F9B26900F9B66F00FCD2A500D6690900FEDBBB00D18641000000
      000000000000FFFAF20000000000000000000000000000000000808000000000
      000080800000FFFFFF0080800000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D67E2B00B5611F00A8571900A857
      1900F8B97900F9BD8300FAC58B00FCDAB500DA690200FFEAD700E1893B00BD6D
      2900000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00C0C0C000000000000000000000000000000000000000FF000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B6662A00F7BB8200FBC58D00F18B
      3000FDCB9500FED2A100FFD9B400FFEAD400DD710D00FFF5E400E7985100F6D7
      B800BF6E2B000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF00800080000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BB6D3100FFDBB900FFDAB600F59D
      4F00FFDAB500FFF3E100FFFCF200FFF9F100E9872800FFFFFF00E79B5900FBF1
      E900CD7C330000000000FFFAF200FFFAF200000000000000000000000000C0C0
      C000FFFFFF00FFFFFF008080800000000000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C67E4800FFFFFF00FFFFFF00FBC2
      8E00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EB944000FFFFFF00E79B5900FEFF
      FF00D683380000000000FFFAF200FFFAF2000000000000000000C0C0C000C0C0
      C00000000000FFFFFF00FFFFFF00FFFFFF00C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DE863D00FEEFE200FFFFFF00FFDC
      BD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F4AA5700FFFFFF00E7954C00FDF8
      F300DE8A3D000000000000000000000000000000000000000000C0C0C000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E69B4C00E6893800E1863600E187
      3900FFF4E200FFFFFF00FFFFFF00FFFFFF00F7B56800FFFFFC00E4914500E38F
      4000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E2873600FFFDF600FFFFFF00FFFFFF00F6BB7900FFFBF600E49247000000
      000000000000FFFAF2000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E2873600FFFDF500FFFEF800F9C68300FFF9F100E49146000000
      000000000000FFFAF200FFFAF200000000000000000000000000000000000000
      00000000000000000000C0C0C00080808000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E3873700FFFCF400F9CA9400FFEEDD00E69348000000
      00000000000000000000FFFAF200000000000000000000000000000000000000
      000000000000FFFFFF00C0C0C000C0C0C0008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000E5904500E4883800E6893900EDA04C000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FE1FFFBD00000000
      FC1DFFDB00000000F819806700000000F01BC0E700000000000FE1DB00000000
      0007E00D000000000004C03F000000000004C03F000000000007C03F00000000
      000FC01F00000000F01BC01F00000000F819F03F00000000FC1DF81F00000000
      FE1FF83F00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 363
    Top = 111
  end
  object Od_AppPath: TOpenDialog
    FileName = 
      'D:\workdir\pop\SourceCode\POP_AMS\04'#12289#32534#30721'\2.95'#29256#26412#28304#30721'\'#27966#38556#24212#26381'\AlarmServi' +
      'ceApp.exe'
    Filter = #21487#25191#34892#25991#20214' (*.exe)|*.exe'
    FilterIndex = 0
    InitialDir = '.'
    Title = #36873#25321'<'#25968#25454#37319#38598#24212#26381'>'#24212#29992#31243#24207
    Left = 396
    Top = 111
  end
end
