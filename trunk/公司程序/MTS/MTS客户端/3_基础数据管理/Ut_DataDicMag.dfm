object Fm_DataDicMag: TFm_DataDicMag
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20998#31867#23383#20856#31649#29702
  ClientHeight = 405
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 506
    Height = 49
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 18
      Width = 60
      Height = 12
      Caption = #23383#20856#31867#22411' :'
    end
    object Cmb_DDType: TComboBox
      Left = 80
      Top = 15
      Width = 145
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      TabStop = False
      OnChange = Cmb_DDTypeChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 49
    Width = 506
    Height = 257
    Align = alClient
    TabOrder = 1
    object AdvGrid_DDtable: TAdvStringGrid
      Left = 1
      Top = 1
      Width = 504
      Height = 255
      Cursor = crDefault
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      OnSelectCell = AdvGrid_DDtableSelectCell
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
  object Panel3: TPanel
    Left = 0
    Top = 306
    Width = 506
    Height = 99
    Align = alBottom
    TabOrder = 2
    object Label2: TLabel
      Tag = 1
      Left = 10
      Top = 23
      Width = 54
      Height = 12
      Caption = #36164#26009#21517#31216' '
    end
    object Label6: TLabel
      Tag = 1
      Left = 322
      Top = 23
      Width = 48
      Height = 12
      Caption = #36164#26009#35299#37322
    end
    object Label5: TLabel
      Tag = 1
      Left = 201
      Top = 23
      Width = 48
      Height = 12
      Caption = #26159#21542#26377#25928
    end
    object Edt_name: TEdit
      Left = 64
      Top = 19
      Width = 121
      Height = 20
      TabOrder = 0
    end
    object Edt_remark: TEdit
      Left = 376
      Top = 19
      Width = 121
      Height = 20
      TabOrder = 1
    end
    object Cmb_effect: TComboBox
      Left = 258
      Top = 20
      Width = 49
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 1
      TabOrder = 2
      Text = #26159
      Items.Strings = (
        #21542
        #26159)
    end
    object Btn_Add: TButton
      Left = 30
      Top = 54
      Width = 80
      Height = 30
      Caption = #28155#21152
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = Btn_AddClick
    end
    object Btn_Modify: TButton
      Left = 122
      Top = 54
      Width = 80
      Height = 30
      Caption = #20462#25913
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Btn_ModifyClick
    end
    object Btn_Del: TButton
      Left = 215
      Top = 54
      Width = 80
      Height = 30
      Caption = #21024#38500
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = Btn_DelClick
    end
    object Btn_Quit: TButton
      Left = 400
      Top = 54
      Width = 80
      Height = 30
      Caption = #36864#20986
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = Btn_QuitClick
    end
    object Btn_Clear: TButton
      Left = 307
      Top = 54
      Width = 80
      Height = 30
      Caption = #28165#31354
      TabOrder = 7
      OnClick = Btn_ClearClick
    end
  end
end
