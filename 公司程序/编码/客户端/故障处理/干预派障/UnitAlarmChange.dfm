object FormAlarmChange: TFormAlarmChange
  Left = 274
  Top = 21
  BorderStyle = bsDialog
  Caption = #24178#39044#27966#21457
  ClientHeight = 664
  ClientWidth = 569
  Color = 14991773
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label3: TLabel
    Left = 11
    Top = 323
    Width = 72
    Height = 12
    Caption = #30446#30340#32500#25252#21333#20301
  end
  object Label4: TLabel
    Left = 11
    Top = 549
    Width = 48
    Height = 12
    Caption = #38468#21152#35828#26126
  end
  object Label5: TLabel
    Left = 11
    Top = 165
    Width = 60
    Height = 12
    Caption = #20854#20182#24453#24178#39044
  end
  object Label1: TLabel
    Left = 96
    Top = 323
    Width = 234
    Height = 12
    Caption = '(*'#32418#33394#26631#27880#30340#32500#25252#21333#20301#20026#24050#23384#22312#35813#24178#39044#21578#35686')'
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object OKBtn: TButton
    Left = 217
    Top = 631
    Width = 75
    Height = 25
    Caption = #30830' '#23450
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 313
    Top = 631
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462' '#28040
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object Panel2: TPanel
    Left = 8
    Top = 341
    Width = 553
    Height = 201
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object cxGridCompany: TcxGrid
      Left = 0
      Top = 0
      Width = 553
      Height = 201
      Align = alClient
      TabOrder = 0
      object cxGridDBTableView1: TcxGridDBTableView
        OnMouseDown = cxGridDBTableView1MouseDown
        NavigatorButtons.ConfirmDelete = False
        OnCustomDrawCell = cxGridDBTableView1CustomDrawCell
        DataController.DataSource = DataSource3
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        DataController.OnDetailExpanding = cxGridDBTableView1DataControllerDetailExpanding
        OptionsView.GroupByBox = False
      end
      object cxGridDBTableView2: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource4
        DataController.DetailKeyFieldNames = 'companyid'
        DataController.MasterKeyFieldNames = 'companyid'
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableView1
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 8
    Top = 568
    Width = 553
    Height = 46
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 553
      Height = 46
      Align = alClient
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 8
    Top = 9
    Width = 553
    Height = 151
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 4
    object cxGridAlarmChange: TcxGrid
      Left = 0
      Top = 0
      Width = 553
      Height = 151
      Align = alClient
      TabOrder = 0
      object cxGridAlarmChangeDBTableView1: TcxGridDBTableView
        OnMouseDown = cxGridAlarmChangeDBTableView1MouseDown
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridAlarmChangeDBTableView2: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DetailKeyFieldNames = 'batchid'
        DataController.MasterKeyFieldNames = 'batchid'
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridAlarmChangeLevel1: TcxGridLevel
        GridView = cxGridAlarmChangeDBTableView1
      end
    end
  end
  object Panel5: TPanel
    Left = 8
    Top = 181
    Width = 553
    Height = 137
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 5
    object cxGridCollect: TcxGrid
      Left = 0
      Top = 0
      Width = 553
      Height = 137
      Align = alClient
      TabOrder = 0
      object cxGridDBTableView3: TcxGridDBTableView
        OnMouseDown = cxGridAlarmChangeDBTableView1MouseDown
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource2
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridDBTableView4: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DetailKeyFieldNames = 'batchid'
        DataController.MasterKeyFieldNames = 'batchid'
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridLevel3: TcxGridLevel
        GridView = cxGridDBTableView3
      end
    end
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 75
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 208
    Top = 75
  end
  object DataSource3: TDataSource
    DataSet = ClientDataSet3
    Left = 272
    Top = 419
  end
  object ClientDataSet3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 240
    Top = 419
  end
  object ClientDataSet4: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 240
    Top = 459
  end
  object DataSource4: TDataSource
    DataSet = ClientDataSet4
    Left = 272
    Top = 459
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 243
  end
  object DataSource2: TDataSource
    DataSet = ClientDataSet2
    Left = 288
    Top = 243
  end
end
