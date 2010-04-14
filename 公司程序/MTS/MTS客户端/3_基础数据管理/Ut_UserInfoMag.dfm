object Fm_UserInfoMag: TFm_UserInfoMag
  Left = 0
  Top = 0
  Caption = #29992#25143#20449#24687#31649#29702
  ClientHeight = 568
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object p_area: TPanel
    Left = 0
    Top = 0
    Width = 209
    Height = 527
    Align = alLeft
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 209
    Top = 0
    Width = 529
    Height = 527
    Align = alClient
    TabOrder = 1
    object AdvGrid_UserInfo: TAdvStringGrid
      Left = 1
      Top = 1
      Width = 527
      Height = 525
      Cursor = crDefault
      Align = alClient
      ColCount = 12
      DefaultRowHeight = 21
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
      ScrollBars = ssBoth
      TabOrder = 0
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
      RowHeights = (
        21
        21
        21
        21
        21
        21
        21
        21
        21
        21)
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 527
    Width = 738
    Height = 41
    Align = alBottom
    TabOrder = 2
    object Btn_Add: TButton
      Left = 298
      Top = 6
      Width = 75
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
    object Btn_Modify: TButton
      Left = 403
      Top = 6
      Width = 75
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
    object Btn_Del: TButton
      Left = 615
      Top = 6
      Width = 75
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
    object ButtonChangePWD: TButton
      Left = 509
      Top = 6
      Width = 75
      Height = 25
      Caption = #35774#32622#23494#30721
      TabOrder = 3
      OnClick = ButtonChangePWDClick
    end
    object Btn_Close: TButton
      Left = 721
      Top = 6
      Width = 75
      Height = 25
      Caption = #20851#38381
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = Btn_CloseClick
    end
  end
end
