object Fm_SystemSet: TFm_SystemSet
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21442#25968#35774#32622
  ClientHeight = 446
  ClientWidth = 679
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 679
    Height = 446
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = '@'#23435#20307
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    TabPosition = tpRight
    TabWidth = 120
    ExplicitWidth = 663
    object TabSheet1: TTabSheet
      Caption = 'MTU'#25511#21046#22120#31649#29702
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 638
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 654
        Height = 438
        Align = alClient
        Caption = 'MTU'#25511#21046#22120#21442#25968#35774#32622
        TabOrder = 0
        ExplicitWidth = 638
        object Label1: TLabel
          Left = 16
          Top = 267
          Width = 84
          Height = 11
          Margins.Bottom = 0
          Caption = 'MTU'#25511#21046#22120#21517#31216#65306
        end
        object Label2: TLabel
          Left = 335
          Top = 268
          Width = 74
          Height = 11
          Margins.Bottom = 0
          Caption = 'MTU'#25511#21046#22120'IP'#65306
        end
        object Label3: TLabel
          Left = 16
          Top = 292
          Width = 74
          Height = 11
          Margins.Bottom = 0
          Caption = #25511#21046#22120'FTPIP'#65306
        end
        object Label4: TLabel
          Left = 16
          Top = 317
          Width = 84
          Height = 11
          Margins.Bottom = 0
          Caption = #25511#21046#22120'FTP'#29992#25143#65306
        end
        object Label5: TLabel
          Left = 335
          Top = 318
          Width = 84
          Height = 11
          Margins.Bottom = 0
          Caption = #25511#21046#22120'FTP'#21475#20196#65306
        end
        object Label6: TLabel
          Left = 16
          Top = 343
          Width = 84
          Height = 11
          Margins.Bottom = 0
          Caption = #25511#21046#22120'FTP'#36335#24452#65306
        end
        object Label7: TLabel
          Left = 334
          Top = 293
          Width = 84
          Height = 11
          Margins.Bottom = 0
          Caption = #25511#21046#22120'FTP'#31471#21475#65306
        end
        object Label8: TLabel
          Left = 16
          Top = 364
          Width = 66
          Height = 11
          Margins.Bottom = 0
          Caption = #25511#21046#22120#22791#27880#65306
        end
        object Btn_Ok: TButton
          Left = 406
          Top = 399
          Width = 75
          Height = 25
          Caption = #30830#23450
          TabOrder = 0
          OnClick = Btn_OkClick
        end
        object Btn_Refresh: TButton
          Left = 480
          Top = 399
          Width = 75
          Height = 25
          Caption = #21047#26032
          TabOrder = 1
          OnClick = Btn_RefreshClick
        end
        object Button3: TButton
          Left = 554
          Top = 399
          Width = 75
          Height = 25
          Caption = #36864#20986
          TabOrder = 2
          OnClick = Button3Click
        end
        object Et_Name: TEdit
          Left = 106
          Top = 264
          Width = 216
          Height = 19
          TabOrder = 3
        end
        object Et_Ip: TEdit
          Left = 417
          Top = 264
          Width = 201
          Height = 19
          TabOrder = 4
          OnKeyPress = Et_IpKeyPress
        end
        object Et_FtpIp: TEdit
          Left = 106
          Top = 288
          Width = 216
          Height = 19
          TabOrder = 5
          OnKeyPress = Et_IpKeyPress
        end
        object Et_FtpUser: TEdit
          Left = 106
          Top = 313
          Width = 216
          Height = 19
          TabOrder = 6
        end
        object Et_FtpPass: TEdit
          Left = 417
          Top = 314
          Width = 201
          Height = 19
          TabOrder = 7
        end
        object Et_FtpPath: TEdit
          Left = 106
          Top = 339
          Width = 216
          Height = 19
          TabOrder = 8
        end
        object Et_FtpPort: TEdit
          Left = 417
          Top = 289
          Width = 201
          Height = 19
          TabOrder = 9
          OnKeyPress = Et_FtpPortKeyPress
        end
        object Et_Remark: TEdit
          Left = 106
          Top = 364
          Width = 512
          Height = 19
          TabOrder = 10
        end
        object adv_mtucontrol: TAdvStringGrid
          Left = 3
          Top = 13
          Width = 630
          Height = 236
          Cursor = crDefault
          DefaultRowHeight = 21
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 11
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          OnClickCell = adv_mtucontrolClickCell
          SearchFooter.FindNextCaption = 'Find next'
          SearchFooter.FindPrevCaption = 'Find previous'
          SearchFooter.HighLightCaption = 'Highlight'
          SearchFooter.HintClose = 'Close'
          SearchFooter.HintFindNext = 'Find next occurence'
          SearchFooter.HintFindPrev = 'Find previous occurence'
          SearchFooter.HintHighlight = 'Highlight occurences'
          SearchFooter.MatchCaseCaption = 'Match case'
          PrintSettings.DateFormat = 'dd/mm/yyyy'
          PrintSettings.Font.Charset = DEFAULT_CHARSET
          PrintSettings.Font.Color = clWindowText
          PrintSettings.Font.Height = -11
          PrintSettings.Font.Name = 'Tahoma'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'Tahoma'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'Tahoma'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'Tahoma'
          PrintSettings.FooterFont.Style = []
          PrintSettings.PageNumSep = '/'
          ScrollWidth = 16
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
          Filter = <>
          Version = '3.3.0.1'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25191#34892#32447#31243#31649#29702
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      ExplicitWidth = 621
      object Label9: TLabel
        Left = 257
        Top = 352
        Width = 55
        Height = 11
        Margins.Bottom = 0
        Caption = #25191#34892#21608#26399#65306
      end
      object Label10: TLabel
        Left = 428
        Top = 352
        Width = 55
        Height = 11
        Margins.Bottom = 0
        Caption = #25191#34892#29366#24577#65306
      end
      object Label11: TLabel
        Left = 8
        Top = 353
        Width = 55
        Height = 11
        Margins.Bottom = 0
        Caption = #32447#31243#21517#31216#65306
      end
      object adv_Thread: TAdvStringGrid
        Left = 3
        Top = 13
        Width = 630
        Height = 316
        Cursor = crDefault
        DefaultRowHeight = 21
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
        ActiveCellFont.Charset = DEFAULT_CHARSET
        ActiveCellFont.Color = clWindowText
        ActiveCellFont.Height = -11
        ActiveCellFont.Name = 'Tahoma'
        ActiveCellFont.Style = [fsBold]
        OnClickCell = adv_ThreadClickCell
        SearchFooter.FindNextCaption = 'Find next'
        SearchFooter.FindPrevCaption = 'Find previous'
        SearchFooter.HighLightCaption = 'Highlight'
        SearchFooter.HintClose = 'Close'
        SearchFooter.HintFindNext = 'Find next occurence'
        SearchFooter.HintFindPrev = 'Find previous occurence'
        SearchFooter.HintHighlight = 'Highlight occurences'
        SearchFooter.MatchCaseCaption = 'Match case'
        PrintSettings.DateFormat = 'dd/mm/yyyy'
        PrintSettings.Font.Charset = DEFAULT_CHARSET
        PrintSettings.Font.Color = clWindowText
        PrintSettings.Font.Height = -11
        PrintSettings.Font.Name = 'Tahoma'
        PrintSettings.Font.Style = []
        PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
        PrintSettings.FixedFont.Color = clWindowText
        PrintSettings.FixedFont.Height = -11
        PrintSettings.FixedFont.Name = 'Tahoma'
        PrintSettings.FixedFont.Style = []
        PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
        PrintSettings.HeaderFont.Color = clWindowText
        PrintSettings.HeaderFont.Height = -11
        PrintSettings.HeaderFont.Name = 'Tahoma'
        PrintSettings.HeaderFont.Style = []
        PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
        PrintSettings.FooterFont.Color = clWindowText
        PrintSettings.FooterFont.Height = -11
        PrintSettings.FooterFont.Name = 'Tahoma'
        PrintSettings.FooterFont.Style = []
        PrintSettings.PageNumSep = '/'
        ScrollWidth = 16
        FixedFont.Charset = DEFAULT_CHARSET
        FixedFont.Color = clWindowText
        FixedFont.Height = -11
        FixedFont.Name = 'Tahoma'
        FixedFont.Style = [fsBold]
        FloatFormat = '%.2f'
        Filter = <>
        Version = '3.3.0.1'
      end
      object Button1: TButton
        Left = 406
        Top = 399
        Width = 75
        Height = 25
        Caption = #30830#23450
        TabOrder = 1
        OnClick = Button1Click
      end
      object Btn_ThredResh: TButton
        Left = 480
        Top = 399
        Width = 75
        Height = 25
        Caption = #21047#26032
        TabOrder = 2
        OnClick = Btn_ThredReshClick
      end
      object Button4: TButton
        Left = 554
        Top = 399
        Width = 75
        Height = 25
        Caption = #36864#20986
        TabOrder = 3
        OnClick = Button3Click
      end
      object Sp_CycTime: TSpinEdit
        Left = 312
        Top = 349
        Width = 103
        Height = 19
        MaxValue = 999999999
        MinValue = 10
        TabOrder = 4
        Value = 10
      end
      object cbb_State: TComboBox
        Left = 489
        Top = 349
        Width = 145
        Height = 19
        Style = csDropDownList
        ItemHeight = 11
        TabOrder = 5
        Items.Strings = (
          #25163#21160
          #33258#21160)
      end
      object Et_ThreadName: TEdit
        Left = 64
        Top = 349
        Width = 177
        Height = 19
        TabOrder = 6
      end
    end
    object TabSheet3: TTabSheet
      Caption = #24615#33021#20998#26512#35774#32622
      ImageIndex = 2
      ExplicitWidth = 621
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 214
        Height = 113
        Caption = #23548#39057#27745#26579#35774#32622
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label12: TLabel
          Left = 12
          Top = 24
          Width = 44
          Height = 11
          Caption = #20998#26512#38388#38548
        end
        object Label13: TLabel
          Left = 12
          Top = 45
          Width = 44
          Height = 11
          Caption = #26102#38388#33539#22260
        end
        object Label14: TLabel
          Left = 12
          Top = 66
          Width = 56
          Height = 11
          Caption = 'PN'#25968#37327#22823#20110
        end
        object Label15: TLabel
          Left = 149
          Top = 24
          Width = 22
          Height = 11
          Caption = #20998#38047
        end
        object Label16: TLabel
          Left = 149
          Top = 45
          Width = 55
          Height = 11
          Caption = #22825#21069#21040#20170#22825
        end
        object Label17: TLabel
          Left = 149
          Top = 66
          Width = 11
          Height = 11
          Caption = #20010
        end
        object SpinEdit1: TSpinEdit
          Left = 82
          Top = 21
          Width = 57
          Height = 19
          MaxValue = 999999999
          MinValue = 10
          TabOrder = 0
          Value = 10
        end
        object SpinEdit2: TSpinEdit
          Left = 82
          Top = 42
          Width = 57
          Height = 19
          MaxValue = 999999999
          MinValue = 1
          TabOrder = 1
          Value = 1
        end
        object SpinEdit3: TSpinEdit
          Left = 82
          Top = 63
          Width = 57
          Height = 19
          MaxValue = 999999999
          MinValue = 1
          TabOrder = 2
          Value = 1
        end
        object CheckBox1: TCheckBox
          Left = 12
          Top = 88
          Width = 97
          Height = 17
          Caption = #26159#21542#26377#25928
          TabOrder = 3
        end
      end
      object Button2: TButton
        Left = 406
        Top = 399
        Width = 75
        Height = 25
        Caption = #30830#23450
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = Button2Click
      end
      object ButtonPoint: TButton
        Left = 480
        Top = 399
        Width = 75
        Height = 25
        Caption = #21047#26032
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = ButtonPointClick
      end
      object Button6: TButton
        Left = 554
        Top = 399
        Width = 75
        Height = 25
        Caption = #36864#20986
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Button3Click
      end
    end
  end
  object Ado_Query: TADOQuery
    Connection = Fm_Main_Collect.Adoc_Main
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select a.name as city,b.* from area_info a'
      'left join mtu_controlconfig b on a.id=b.cityid'
      'where a.layer=1')
    Left = 176
    Top = 184
  end
end
