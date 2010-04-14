object FormAlarmWait: TFormAlarmWait
  Left = 0
  Top = 0
  Caption = #24322#24120#20107#20214#30417#25511
  ClientHeight = 562
  ClientWidth = 808
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PaneAlarm: TPanel
    Left = 0
    Top = 0
    Width = 808
    Height = 531
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object cxGridAlarmWait: TcxGrid
      Left = 0
      Top = 0
      Width = 808
      Height = 531
      Align = alClient
      TabOrder = 0
      object cxGridAlarmWaitDBTableViewWait: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSourceWait
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
      end
      object cxGridAlarmWaitLevel1: TcxGridLevel
        GridView = cxGridAlarmWaitDBTableViewWait
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 531
    Width = 808
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 335
      Top = 10
      Width = 72
      Height = 13
      Caption = #26465#21382#21490#21578#35686#65289
      Visible = False
    end
    object Label1: TLabel
      Left = 241
      Top = 10
      Width = 36
      Height = 13
      Caption = #65288#26368#36817
      Visible = False
    end
    object btClose: TButton
      Left = 595
      Top = 4
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 0
      OnClick = btCloseClick
    end
    object cbShowHistory: TCheckBox
      Left = 114
      Top = 8
      Width = 121
      Height = 17
      Caption = #26174#31034'MTU'#21382#21490#21578#35686
      TabOrder = 1
      Visible = False
    end
    object seCount: TcxSpinEdit
      Left = 283
      Top = 6
      Properties.MinValue = 1.000000000000000000
      TabOrder = 2
      Value = 10
      Visible = False
      Width = 46
    end
  end
  object DataSourceWait: TDataSource
    DataSet = ClientDataSetWait
    Left = 584
    Top = 384
  end
  object ClientDataSetWait: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 616
    Top = 384
  end
end
