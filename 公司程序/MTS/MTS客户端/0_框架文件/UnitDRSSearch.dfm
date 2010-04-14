object FormDRSSearch: TFormDRSSearch
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #30452#25918#31449#26597#35810#32467#26524
  ClientHeight = 286
  ClientWidth = 498
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 498
    Height = 286
    Align = alClient
    TabOrder = 0
    object cxGroupBox1: TcxGroupBox
      Left = 1
      Top = 1
      Align = alClient
      Caption = #30452#25918#31449#26597#35810#32467#26524
      TabOrder = 0
      Height = 284
      Width = 496
      object cxGridDRSSearch: TcxGrid
        Left = 2
        Top = 18
        Width = 492
        Height = 264
        Align = alClient
        TabOrder = 0
        object cxGridDRSSearchDBTableView1: TcxGridDBTableView
          OnDblClick = cxGridDRSSearchDBTableView1DblClick
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = DataSource1
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.GroupByBox = False
        end
        object cxGridDRSSearchLevel1: TcxGridLevel
          GridView = cxGridDRSSearchDBTableView1
        end
      end
    end
  end
  object DataSource1: TDataSource
    Left = 360
    Top = 144
  end
end
