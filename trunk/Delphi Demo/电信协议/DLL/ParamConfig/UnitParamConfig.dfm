object FormParamConfig: TFormParamConfig
  Left = 318
  Top = 108
  Width = 706
  Height = 485
  Caption = #37197#32622#20449#24687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 153
    Width = 698
    Height = 4
    Cursor = crVSplit
    Align = alTop
  end
  object cxGroupBox_DRS: TcxGroupBox
    Left = 0
    Top = 0
    Align = alTop
    Caption = #30452#25918#31449#20449#24687
    TabOrder = 0
    Height = 153
    Width = 698
    object cxGrid_DRS: TcxGrid
      Left = 2
      Top = 18
      Width = 694
      Height = 133
      Align = alClient
      TabOrder = 0
      object cxGrid_DRSDBTV_DRS: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
      end
      object cxGrid_DRSLevel: TcxGridLevel
        GridView = cxGrid_DRSDBTV_DRS
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 157
    Width = 698
    Height = 294
    Align = alClient
    TabOrder = 1
    object cxPageControl1: TcxPageControl
      Left = 1
      Top = 1
      Width = 696
      Height = 292
      ActivePage = cxTabSheet1
      Align = alClient
      Style = 8
      TabOrder = 0
      ClientRectBottom = 292
      ClientRectRight = 696
      ClientRectTop = 24
      object cxTabSheet1: TcxTabSheet
        Caption = #21442#25968#37197#32622#26597#35810#20449#24687
        ImageIndex = 0
        object cxGridParam: TcxGrid
          Left = 0
          Top = 0
          Width = 549
          Height = 268
          Align = alClient
          TabOrder = 0
          object cxGridParamDBTV_Param: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsView.GroupByBox = False
            OptionsView.Indicator = True
          end
          object cxGridParamLevel: TcxGridLevel
            GridView = cxGridParamDBTV_Param
          end
        end
        object Panel24: TPanel
          Left = 549
          Top = 0
          Width = 147
          Height = 268
          Align = alRight
          TabOrder = 1
          object Btn_QuerySet: TButton
            Left = 38
            Top = 64
            Width = 75
            Height = 25
            Caption = #26597#35810
            TabOrder = 0
          end
          object Btn_ConfigSet: TButton
            Left = 38
            Top = 120
            Width = 75
            Height = 25
            Caption = #37197#32622
            TabOrder = 1
          end
        end
      end
      object cxTabSheet2: TcxTabSheet
        Caption = #21442#25968#37197#32622#26597#35810#21382#21490
        ImageIndex = 1
        object cxGridDRSComHis: TcxGrid
          Left = 0
          Top = 0
          Width = 549
          Height = 268
          Align = alClient
          TabOrder = 0
          object cxGridDBTVDRSComHis: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsView.GroupByBox = False
          end
          object cxGridLevel2: TcxGridLevel
            GridView = cxGridDBTVDRSComHis
          end
        end
        object Panel2: TPanel
          Left = 549
          Top = 0
          Width = 147
          Height = 268
          Align = alRight
          TabOrder = 1
          object Label37: TLabel
            Left = 14
            Top = 20
            Width = 87
            Height = 13
            Caption = #21629#20196#25191#34892#26102#38388#27573':'
          end
          object Button1: TButton
            Left = 38
            Top = 200
            Width = 75
            Height = 25
            Caption = #26597#35810
            TabOrder = 0
          end
          object cxdeStartDate: TcxDateEdit
            Left = 14
            Top = 36
            Properties.Kind = ckDateTime
            TabOrder = 1
            Width = 121
          end
          object cxdeEndDate: TcxDateEdit
            Left = 14
            Top = 60
            Properties.Kind = ckDateTime
            TabOrder = 2
            Width = 121
          end
        end
      end
    end
  end
end
