object FormAlarmChange: TFormAlarmChange
  Left = 308
  Top = 110
  BorderStyle = bsDialog
  Caption = #36716#27966
  ClientHeight = 546
  ClientWidth = 569
  Color = 14991773
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Label3: TLabel
    Left = 11
    Top = 191
    Width = 72
    Height = 12
    Caption = #30446#30340#32500#25252#21333#20301
  end
  object Label4: TLabel
    Left = 11
    Top = 383
    Width = 48
    Height = 12
    Caption = #38468#21152#35828#26126
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 569
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 9
      Width = 48
      Height = 12
      Caption = #21407#21333#20301#65306
    end
    object Label2: TLabel
      Left = 67
      Top = 9
      Width = 18
      Height = 12
      Caption = 'DDD'
    end
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 488
    Width = 106
    Height = 17
    Caption = #21024#38500#21407#21333#20301#21578#35686
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object OKBtn: TButton
    Left = 217
    Top = 511
    Width = 75
    Height = 25
    Caption = #30830' '#23450
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 313
    Top = 511
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462' '#28040
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object Panel2: TPanel
    Left = 8
    Top = 209
    Width = 553
    Height = 163
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 4
    object cxGridCompany: TcxGrid
      Left = 0
      Top = 0
      Width = 553
      Height = 163
      Align = alClient
      TabOrder = 0
      object cxGridDBTableView1: TcxGridDBTableView
        OnMouseDown = cxGridDBTableView1MouseDown
        NavigatorButtons.ConfirmDelete = False
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
    Top = 401
    Width = 553
    Height = 81
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 5
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 553
      Height = 81
      Align = alClient
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 8
    Top = 33
    Width = 553
    Height = 150
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 6
    object cxGridAlarmChange: TcxGrid
      Left = 0
      Top = 0
      Width = 553
      Height = 150
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
    Left = 264
    Top = 251
  end
  object ClientDataSet3: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 232
    Top = 251
  end
  object ClientDataSet4: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 232
    Top = 291
  end
  object DataSource4: TDataSource
    DataSet = ClientDataSet4
    Left = 264
    Top = 291
  end
end
