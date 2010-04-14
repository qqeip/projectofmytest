object Fm_CSInfoMag: TFm_CSInfoMag
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #22522#31449#20449#24687#31649#29702
  ClientHeight = 436
  ClientWidth = 723
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 723
    Height = 436
    Align = alClient
    TabOrder = 0
    object Panel3: TPanel
      Left = 1
      Top = 227
      Width = 721
      Height = 208
      Align = alBottom
      TabOrder = 0
      object GroupBox1: TGroupBox
        Left = 1
        Top = 1
        Width = 719
        Height = 159
        Align = alClient
        Caption = #22522#31449#20449#24687#24405#20837
        TabOrder = 0
        object Label1: TLabel
          Left = 24
          Top = 29
          Width = 48
          Height = 12
          Caption = #21208#28857#32534#30721
        end
        object Label2: TLabel
          Left = 23
          Top = 116
          Width = 48
          Height = 12
          Caption = #32593#20803#20449#24687
        end
        object Label3: TLabel
          Left = 270
          Top = 72
          Width = 48
          Height = 12
          Caption = #22522#31449#22320#22336
        end
        object Label4: TLabel
          Left = 270
          Top = 29
          Width = 52
          Height = 12
          AutoSize = False
          Caption = 'C S I D'
        end
        object Label5: TLabel
          Left = 519
          Top = 29
          Width = 52
          Height = 12
          AutoSize = False
          Caption = #22522#31449#31867#22411
        end
        object Label6: TLabel
          Left = 18
          Top = 72
          Width = 64
          Height = 13
          AutoSize = False
          Caption = #25152#23646#23460#20998#28857
        end
        object Label7: TLabel
          Left = 270
          Top = 116
          Width = 59
          Height = 11
          AutoSize = False
          Caption = #35206#30422#33539#22260
        end
        object Label9: TLabel
          Left = 10
          Top = 117
          Width = 6
          Height = 12
          Margins.Bottom = 0
          Caption = '*'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label10: TLabel
          Left = 10
          Top = 72
          Width = 6
          Height = 12
          Margins.Bottom = 0
          Caption = '*'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label11: TLabel
          Left = 10
          Top = 29
          Width = 6
          Height = 12
          Margins.Bottom = 0
          Caption = '*'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Edt_Address: TEdit
          Left = 331
          Top = 68
          Width = 364
          Height = 20
          TabOrder = 4
        end
        object Edt_Net: TEdit
          Left = 87
          Top = 111
          Width = 139
          Height = 20
          TabOrder = 5
        end
        object Edt_Survery: TEdit
          Left = 87
          Top = 26
          Width = 139
          Height = 20
          TabOrder = 1
        end
        object EditCSID: TEdit
          Left = 331
          Top = 26
          Width = 139
          Height = 20
          TabOrder = 0
        end
        object ComboBoxCSType: TComboBox
          Left = 583
          Top = 26
          Width = 112
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 2
        end
        object ComboBoxBuilding: TcxComboBox
          Left = 87
          Top = 68
          Properties.AutoSelect = False
          Properties.DropDownListStyle = lsFixedList
          Style.PopupBorderStyle = epbsFlat
          TabOrder = 3
          Width = 139
        end
        object EditCover: TEdit
          Left = 331
          Top = 111
          Width = 364
          Height = 20
          TabOrder = 6
        end
      end
      object Panel1: TPanel
        Left = 1
        Top = 160
        Width = 719
        Height = 47
        Align = alBottom
        TabOrder = 1
        ExplicitLeft = 88
        ExplicitTop = 152
        object Btn_Add: TButton
          Left = 232
          Top = 10
          Width = 65
          Height = 25
          Caption = #28155#21152
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = Btn_AddClick
        end
        object Btn_Clear: TButton
          Left = 527
          Top = 10
          Width = 65
          Height = 25
          Caption = #28165#31354
          TabOrder = 3
          OnClick = Btn_ClearClick
        end
        object Btn_Del: TButton
          Left = 453
          Top = 10
          Width = 65
          Height = 25
          Caption = #21024#38500
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = Btn_DelClick
        end
        object Btn_Modify: TButton
          Left = 305
          Top = 10
          Width = 65
          Height = 25
          Caption = #20462#25913
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Btn_ModifyClick
        end
        object Btn_Quit: TButton
          Left = 601
          Top = 10
          Width = 65
          Height = 25
          Caption = #36864#20986
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = Btn_QuitClick
        end
        object ButtonOK: TButton
          Left = 379
          Top = 10
          Width = 65
          Height = 25
          Caption = #30830#23450
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = ButtonOKClick
        end
      end
    end
    object AdvStringGrid1: TAdvStringGrid
      Left = 1
      Top = 1
      Width = 721
      Height = 226
      Cursor = crDefault
      Align = alClient
      DefaultRowHeight = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect]
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
      SelectionColor = clYellow
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
