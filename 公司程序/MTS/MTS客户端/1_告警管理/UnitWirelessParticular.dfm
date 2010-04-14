object FormWirelessParticular: TFormWirelessParticular
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #26080#32447#21442#25968#31383#21475
  ClientHeight = 486
  ClientWidth = 350
  Color = 15451300
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object cxLabelMTU: TcxLabel
    Left = 11
    Top = 8
    AutoSize = False
    ParentColor = False
    Properties.LabelEffect = cxleCool
    Properties.LabelStyle = cxlsRaised
    Style.BorderStyle = ebsOffice11
    Style.Color = clYellow
    Style.Shadow = True
    Style.TextColor = clRed
    Style.TextStyle = [fsBold]
    Height = 20
    Width = 89
  end
  object cxLabelMTUStatus: TcxLabel
    Left = 19
    Top = 31
    AutoSize = False
    Style.BorderStyle = ebsNone
    Style.Shadow = True
    Style.TextColor = clRed
    Style.TextStyle = [fsBold]
    Height = 21
    Width = 294
  end
  object cxLabelPower: TcxLabel
    Left = 19
    Top = 51
    AutoSize = False
    Style.BorderStyle = ebsNone
    Style.Shadow = True
    Style.TextColor = clRed
    Style.TextStyle = [fsBold]
    Height = 21
    Width = 294
  end
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 96
    Width = 350
    Height = 390
    ActivePage = cxTabSheet1
    Align = alBottom
    Style = 9
    TabOrder = 3
    OnChange = cxPageControl1Change
    ClientRectBottom = 390
    ClientRectRight = 350
    ClientRectTop = 19
    object cxTabSheet1: TcxTabSheet
      Caption = 'CDMA'
      ImageIndex = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxPageControl2: TcxPageControl
        Left = 0
        Top = 0
        Width = 350
        Height = 371
        ActivePage = cxTabSheet4
        Align = alClient
        Style = 9
        TabOrder = 0
        OnChange = cxPageControl2Change
        ClientRectBottom = 371
        ClientRectRight = 350
        ClientRectTop = 19
        object cxTabSheet4: TcxTabSheet
          Caption = #24453#26426#29366#24577
          ImageIndex = 0
          object cxVerticalGrid1: TcxVerticalGrid
            Left = 0
            Top = 0
            Width = 350
            Height = 181
            Align = alTop
            OptionsView.RowHeaderWidth = 129
            Styles.StyleSheet = cxVerticalGridStyleSheetDevExpress
            TabOrder = 0
          end
          object cxGroupBox1: TcxGroupBox
            Left = 0
            Top = 181
            Align = alClient
            Style.BorderStyle = ebsNone
            TabOrder = 1
            Height = 171
            Width = 350
            object cxLabel1: TcxLabel
              Left = 7
              Top = 129
              AutoSize = False
              Caption = 'Finger'#20449#24687
              ParentColor = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Style.BorderStyle = ebsNone
              Style.Color = clFuchsia
              Style.Shadow = False
              Style.TextColor = clBlack
              Style.TextStyle = []
              Height = 20
              Width = 78
            end
            object cxLabel2: TcxLabel
              Left = 7
              Top = 31
              AutoSize = False
              Caption = #28608#27963#38598#20449#24687
              ParentColor = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Style.BorderStyle = ebsNone
              Style.Color = clLime
              Style.Shadow = False
              Style.TextColor = clBlack
              Style.TextStyle = []
              Height = 20
              Width = 78
            end
            object cxLabel3: TcxLabel
              Left = 7
              Top = 96
              AutoSize = False
              Caption = #20505#36873#38598#20449#24687
              ParentColor = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Style.BorderStyle = ebsNone
              Style.Color = clMaroon
              Style.Shadow = False
              Style.TextColor = clBlack
              Style.TextStyle = []
              Height = 20
              Width = 78
            end
            object cxLabel4: TcxLabel
              Left = 7
              Top = 63
              AutoSize = False
              Caption = #37051#21306#20449#24687
              ParentColor = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Style.BorderStyle = ebsNone
              Style.Color = clMenuHighlight
              Style.Shadow = False
              Style.TextColor = clBlack
              Style.TextStyle = []
              Height = 20
              Width = 78
            end
            object cxLabel9: TcxLabel
              Left = 124
              Top = 6
              Caption = 'PN'#30721
            end
            object cxLabel10: TcxLabel
              Left = 191
              Top = 6
              Caption = 'EC/IO'
            end
          end
        end
        object cxTabSheet5: TcxTabSheet
          Caption = #36890#35805#29366#24577
          ImageIndex = 1
          object cxVerticalGrid2: TcxVerticalGrid
            Left = 0
            Top = 0
            Width = 350
            Height = 181
            Align = alTop
            OptionsView.RowHeaderWidth = 129
            Styles.StyleSheet = cxVerticalGridStyleSheetDevExpress
            TabOrder = 0
          end
          object cxGroupBox2: TcxGroupBox
            Left = 0
            Top = 181
            Align = alClient
            Style.BorderStyle = ebsNone
            TabOrder = 1
            Height = 171
            Width = 350
            object cxLabel5: TcxLabel
              Left = 7
              Top = 129
              AutoSize = False
              Caption = 'Finger'#20449#24687
              ParentColor = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Style.BorderStyle = ebsNone
              Style.Color = clFuchsia
              Style.Shadow = False
              Style.TextColor = clBlack
              Style.TextStyle = []
              Height = 20
              Width = 78
            end
            object cxLabel6: TcxLabel
              Left = 7
              Top = 31
              AutoSize = False
              Caption = #28608#27963#38598#20449#24687
              ParentColor = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Style.BorderStyle = ebsNone
              Style.Color = clLime
              Style.Shadow = False
              Style.TextColor = clBlack
              Style.TextStyle = []
              Height = 20
              Width = 78
            end
            object cxLabel7: TcxLabel
              Left = 7
              Top = 96
              AutoSize = False
              Caption = #20505#36873#38598#20449#24687
              ParentColor = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Style.BorderStyle = ebsNone
              Style.Color = clMaroon
              Style.Shadow = False
              Style.TextColor = clBlack
              Style.TextStyle = []
              Height = 20
              Width = 78
            end
            object cxLabel8: TcxLabel
              Left = 7
              Top = 63
              AutoSize = False
              Caption = #37051#21306#20449#24687
              ParentColor = False
              Properties.Alignment.Horz = taCenter
              Properties.Alignment.Vert = taVCenter
              Style.BorderStyle = ebsNone
              Style.Color = clMenuHighlight
              Style.Shadow = False
              Style.TextColor = clBlack
              Style.TextStyle = []
              Height = 20
              Width = 78
            end
            object cxLabel11: TcxLabel
              Left = 124
              Top = 6
              Caption = 'PN'#30721
            end
            object cxLabel12: TcxLabel
              Left = 191
              Top = 6
              Caption = 'EC/IO'
            end
          end
        end
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = 'PHS'
      ImageIndex = 1
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxVerticalGrid3: TcxVerticalGrid
        Left = 0
        Top = 0
        Width = 350
        Height = 371
        Align = alClient
        OptionsView.RowHeaderWidth = 129
        Styles.StyleSheet = cxVerticalGridStyleSheetDevExpress
        TabOrder = 0
      end
    end
    object cxTabSheet3: TcxTabSheet
      Caption = 'WLAN'
      ImageIndex = 2
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxVerticalGrid4: TcxVerticalGrid
        Left = 0
        Top = 0
        Width = 350
        Height = 371
        Align = alClient
        OptionsView.RowHeaderWidth = 129
        Styles.StyleSheet = cxVerticalGridStyleSheetDevExpress
        TabOrder = 0
      end
    end
  end
  object cxLabelalarmcounts: TcxLabel
    Left = 19
    Top = 71
    AutoSize = False
    Style.BorderStyle = ebsNone
    Style.Shadow = True
    Style.TextColor = clRed
    Style.TextStyle = [fsBold]
    Height = 21
    Width = 294
  end
  object ClientDataSetDym: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 160
  end
  object cxEditRepository: TcxEditRepository
    Left = 272
    Top = 160
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 240
    Top = 160
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 14590588
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 13795663
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      TextColor = clYellow
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16247513
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clNavy
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 14590588
      TextColor = clWhite
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor]
      Color = 15185807
    end
    object cxStyle6: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 4707838
      TextColor = clBlack
    end
    object cxStyle7: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 15120279
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      TextColor = clWhite
    end
    object cxVerticalGridStyleSheetDevExpress: TcxVerticalGridStyleSheet
      Caption = 'DevExpress'
      Styles.Background = cxStyle1
      Styles.Content = cxStyle3
      Styles.Inactive = cxStyle5
      Styles.Selection = cxStyle7
      Styles.Category = cxStyle2
      Styles.Header = cxStyle4
      Styles.IncSearch = cxStyle6
      BuiltIn = True
    end
  end
  object Timer1: TTimer
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 256
    Top = 8
  end
end
