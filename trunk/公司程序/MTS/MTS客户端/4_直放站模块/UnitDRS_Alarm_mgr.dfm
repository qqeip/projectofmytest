object FormDRS_ALARM_Mgr: TFormDRS_ALARM_Mgr
  Left = 0
  Top = 0
  Caption = #30452#25918#31449#21578#35686#20869#23481#31649#29702
  ClientHeight = 540
  ClientWidth = 931
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 931
    Height = 540
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object gb_info: TGroupBox
      Left = 705
      Top = 0
      Width = 226
      Height = 540
      Align = alRight
      Caption = #21578#35686#20869#23481#20449#24687
      TabOrder = 0
      object Label1: TLabel
        Left = 5
        Top = 23
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#20869#23481#21517#31216
      end
      object Label2: TLabel
        Left = 5
        Top = 51
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#20869#23481#31867#22411
      end
      object Label3: TLabel
        Left = 5
        Top = 80
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#20869#23481#31561#32423
      end
      object Label4: TLabel
        Left = 5
        Top = 107
        Width = 75
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#26469#28304#21629#20196' '
      end
      object Label5: TLabel
        Left = 5
        Top = 133
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#26469#28304#21442#25968
      end
      object Label6: TLabel
        Left = 5
        Top = 156
        Width = 160
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#20135#29983#26465#20214' ('#26684#24335' @value=1)'
      end
      object Label7: TLabel
        Left = 5
        Top = 241
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#20135#29983#38376#38480
      end
      object Label8: TLabel
        Left = 3
        Top = 270
        Width = 160
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#25490#38500#26465#20214' ('#26684#24335' @value=1)'
      end
      object Label9: TLabel
        Left = 5
        Top = 357
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#25490#38500#38376#38480
      end
      object Label10: TLabel
        Left = 5
        Top = 390
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#25490#38500#26102#38480
      end
      object Label11: TLabel
        Left = 3
        Top = 424
        Width = 75
        Height = 13
        Margins.Bottom = 0
        Caption = ' '#21578#35686#26159#21542#26377#25928
      end
      object Label12: TLabel
        Left = 5
        Top = 455
        Width = 72
        Height = 13
        Margins.Bottom = 0
        Caption = #21578#35686#22788#29702#31867#22411
      end
      object Et_AlarmContentName: TEdit
        Left = 87
        Top = 19
        Width = 134
        Height = 21
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 0
      end
      object cbb_AlarmKind: TComboBox
        Left = 87
        Top = 47
        Width = 136
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 1
      end
      object cbb_AlarmLevel: TComboBox
        Left = 87
        Top = 76
        Width = 136
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 2
      end
      object cbb_AlarmCom: TComboBox
        Left = 87
        Top = 103
        Width = 136
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 3
      end
      object cbb_AlarmParam: TComboBox
        Left = 87
        Top = 130
        Width = 136
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 4
      end
      object SE_AlarmCount: TSpinEdit
        Left = 87
        Top = 237
        Width = 134
        Height = 22
        MaxValue = 9999
        MinValue = 1
        TabOrder = 5
        Value = 1
      end
      object SE_RemoveCount: TSpinEdit
        Left = 87
        Top = 353
        Width = 134
        Height = 22
        MaxValue = 9999
        MinValue = 1
        TabOrder = 6
        Value = 1
      end
      object SE_LimitHour: TSpinEdit
        Left = 89
        Top = 381
        Width = 134
        Height = 22
        MaxValue = 9999
        MinValue = 1
        TabOrder = 7
        Value = 1
      end
      object Et_ALARMCONDITION: TMemo
        Left = 7
        Top = 173
        Width = 214
        Height = 54
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        Lines.Strings = (
          '')
        TabOrder = 8
      end
      object Et_REMOVECONDITION: TMemo
        Left = 7
        Top = 286
        Width = 214
        Height = 61
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        Lines.Strings = (
          '')
        TabOrder = 9
      end
      object BtnModify: TBitBtn
        Left = 6
        Top = 496
        Width = 65
        Height = 34
        Caption = #20462#25913
        TabOrder = 10
        OnClick = BtnModifyClick
      end
      object BtnOk: TBitBtn
        Left = 81
        Top = 496
        Width = 65
        Height = 34
        Caption = #30830#23450
        TabOrder = 11
        OnClick = BtnOkClick
      end
      object BtnClose: TBitBtn
        Left = 156
        Top = 496
        Width = 65
        Height = 34
        Caption = #36820#22238
        TabOrder = 12
        OnClick = BtnCloseClick
      end
      object cbb_Effect: TComboBox
        Left = 86
        Top = 420
        Width = 136
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 13
        Items.Strings = (
          #21542
          #26159)
      end
      object cbb_SendType: TComboBox
        Left = 87
        Top = 451
        Width = 136
        Height = 21
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 13
        TabOrder = 14
        Items.Strings = (
          #30452#25509#21028#26029
          #20998#26512)
      end
    end
    object AdvStringGrid1: TAdvStringGrid
      Left = 0
      Top = 0
      Width = 705
      Height = 540
      Cursor = crDefault
      Align = alClient
      DefaultRowHeight = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
      OnClick = AdvStringGrid1Click
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
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
  object CDSModel: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 8
    Top = 488
  end
  object DSModel: TDataSource
    DataSet = CDSModel
    Left = 40
    Top = 488
  end
  object CDSModelContent: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 496
  end
  object DSModelContent: TDataSource
    DataSet = CDSModelContent
    Left = 64
    Top = 344
  end
  object CDSModelOnly: TClientDataSet
    Aggregates = <>
    Filter = 'parentmodelid<>0 and parentmodelid <> 1'
    Filtered = True
    Params = <>
    Left = 80
    Top = 432
  end
  object DSModelOnly: TDataSource
    DataSet = CDSModelOnly
    Left = 32
    Top = 384
  end
  object CDSDSAlarmKind: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 480
  end
  object DSAlarmKind: TDataSource
    DataSet = CDSDSAlarmKind
    Left = 16
    Top = 344
  end
  object CDSModelType: TClientDataSet
    Aggregates = <>
    Filter = 'parentmodelid=1'
    Filtered = True
    Params = <>
    Left = 24
    Top = 440
  end
  object DSModelType: TDataSource
    DataSet = CDSModelType
    Left = 120
    Top = 416
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 80
    Top = 386
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 15725290
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      TextColor = clTeal
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      TextColor = clTeal
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle6: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 13886416
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TextColor = clPurple
    end
    object cxStyle7: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle8: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 8170097
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clWhite
    end
    object cxStyle9: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      TextColor = clBlack
    end
    object cxStyle10: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clGradientActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      TextColor = clGreen
    end
    object cxStyle11: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 6592345
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clWhite
    end
    object cxStyle13: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clGradientInactiveCaption
      TextColor = clBlack
    end
    object cxStyle12: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clBackground
      TextColor = clPurple
    end
    object cxStyle14: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clSilver
      TextColor = clPurple
    end
    object cxGridTableViewStyleSheet1: TcxGridTableViewStyleSheet
      Styles.Background = cxStyle1
      Styles.Content = cxStyle14
      Styles.ContentEven = cxStyle6
      BuiltIn = True
    end
    object cxGridTableViewStyleSheet2: TcxGridTableViewStyleSheet
      Styles.Background = cxStyle1
      BuiltIn = True
    end
    object cxGridTableViewStyleSheet3: TcxGridTableViewStyleSheet
      Styles.Background = cxStyle1
      Styles.Content = cxStyle10
      Styles.Inactive = cxStyle10
      Styles.Selection = cxStyle5
      BuiltIn = True
    end
  end
end
