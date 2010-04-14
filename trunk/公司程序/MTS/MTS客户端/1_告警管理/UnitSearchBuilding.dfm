object FormSearchBuilding: TFormSearchBuilding
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #26597#25214
  ClientHeight = 258
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 50
    Width = 459
    Height = 8
    HotZoneClassName = 'TcxSimpleStyle'
    HotZone.SizePercent = 10
    AlignSplitter = salBottom
    Control = cxGroupBoxInfo
    OnAfterOpen = cxSplitter1AfterOpen
    OnAfterClose = cxSplitter1AfterClose
  end
  object cxGroupBoxInfo: TcxGroupBox
    Left = 0
    Top = 58
    Align = alBottom
    Style.BorderStyle = ebsNone
    TabOrder = 1
    Height = 200
    Width = 459
    object cxGrid1: TcxGrid
      Left = 2
      Top = 17
      Width = 455
      Height = 181
      Align = alClient
      TabOrder = 0
      object cxGrid1DBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        OnCellDblClick = cxGrid1DBTableView1CellDblClick
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
  object cxGroupBoxSearch: TcxGroupBox
    Left = 0
    Top = 0
    Align = alTop
    Style.Shadow = True
    TabOrder = 2
    Height = 50
    Width = 459
    object cxButton1: TcxButton
      Left = 343
      Top = 14
      Width = 50
      Height = 25
      Caption = #26597#25214
      TabOrder = 0
      OnClick = cxButton1Click
    end
    object cxButton2: TcxButton
      Left = 395
      Top = 14
      Width = 50
      Height = 25
      Caption = #20851#38381
      TabOrder = 1
      OnClick = cxButton2Click
    end
    object cxLabel1: TcxLabel
      Left = 5
      Top = 17
      Caption = #26597#25214#23545#35937
    end
    object cxComboBox1: TcxComboBox
      Left = 63
      Top = 16
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #23460#20998#28857
        'MTU'
        'AP'
        'PHS'#22522#31449
        'CDMA'#22522#31449
        #30452#25918#31449)
      Properties.OnChange = cxComboBox1PropertiesChange
      TabOrder = 3
      Width = 86
    end
    object cxLabel2: TcxLabel
      Left = 155
      Top = 17
      Caption = #26597#35810#26465#20214
    end
    object cxTextEdit1: TcxTextEdit
      Left = 213
      Top = 16
      TabOrder = 5
      Width = 121
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 272
    Top = 112
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 112
  end
end
