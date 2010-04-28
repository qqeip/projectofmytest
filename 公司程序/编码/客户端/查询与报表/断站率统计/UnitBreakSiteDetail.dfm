object FormBreakSiteDetail: TFormBreakSiteDetail
  Left = 288
  Top = 183
  Width = 646
  Height = 373
  Caption = #26029#31449#21578#35686#26126#32454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 0
    Align = alClient
    Caption = #26029#31449#21578#35686#26126#32454
    TabOrder = 0
    Height = 288
    Width = 638
    object cxGrid1: TcxGrid
      Left = 2
      Top = 18
      Width = 634
      Height = 268
      Align = alClient
      TabOrder = 0
      object cxGrid1DBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
  end
  object cxGroupBox2: TcxGroupBox
    Left = 0
    Top = 288
    Align = alBottom
    TabOrder = 1
    Height = 51
    Width = 638
    object LabelBreakSiteCount: TLabel
      Left = 24
      Top = 21
      Width = 169
      Height = 16
      AutoSize = False
      Caption = #26029#31449#21578#35686#25968#65306' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BtnStop: TcxButton
      Left = 440
      Top = 16
      Width = 75
      Height = 25
      Caption = #32456#27490
      TabOrder = 0
      Visible = False
      OnClick = BtnStopClick
    end
    object cxButton2: TcxButton
      Left = 536
      Top = 16
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 1
      OnClick = cxButton2Click
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 344
    Top = 216
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 272
    Top = 216
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 184
    Top = 216
  end
end
