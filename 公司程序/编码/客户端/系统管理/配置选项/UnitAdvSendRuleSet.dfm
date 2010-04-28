object FormAdvSendRuleSet: TFormAdvSendRuleSet
  Left = 307
  Top = 224
  BorderStyle = bsNone
  Caption = #39640#32423#27966#38556#35268#21017#35774#32622
  ClientHeight = 431
  ClientWidth = 547
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
    Align = alLeft
    Caption = #21578#35686#35268#21017#32452#20449#24687#35774#32622
    TabOrder = 0
    Height = 350
    Width = 148
    object LVAlarmRuleGroup: TcxListView
      Left = 2
      Top = 18
      Width = 144
      Height = 330
      Align = alClient
      Columns = <
        item
          Caption = #24207#21495
          Width = 40
        end
        item
          Caption = #21578#35686#35268#21017#32452#21517#31216
          Width = 100
        end
        item
          Caption = #22791#27880
          Width = 0
        end>
      DragMode = dmAutomatic
      HideSelection = False
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      RowSelect = True
      ShowHint = True
      SortType = stText
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = LVAlarmRuleGroupClick
    end
  end
  object cxGroupBox2: TcxGroupBox
    Left = 0
    Top = 350
    Align = alBottom
    TabOrder = 1
    Height = 81
    Width = 547
    object LabelRemark: TLabel
      Left = 273
      Top = 19
      Width = 24
      Height = 13
      Caption = #22791#27880
      Enabled = False
    end
    object BtnSave: TcxButton
      Left = 309
      Top = 45
      Width = 60
      Height = 25
      Caption = #20445#23384
      TabOrder = 5
      OnClick = BtnSaveClick
    end
    object BtnCancel: TcxButton
      Left = 377
      Top = 45
      Width = 60
      Height = 25
      Caption = #21462#28040
      TabOrder = 6
      OnClick = BtnCancelClick
    end
    object BtnAlarmQuery: TcxButton
      Left = 240
      Top = 45
      Width = 60
      Height = 25
      Caption = #21578#35686#26597#35810
      TabOrder = 4
      OnClick = BtnAlarmQueryClick
    end
    object LabelGroupName: TcxLabel
      Left = 31
      Top = 18
      Caption = #35268#21017#32452#21517#31216
      Enabled = False
    end
    object EdtAlarmRuleGroupName: TcxTextEdit
      Left = 98
      Top = 16
      Enabled = False
      TabOrder = 0
      Width = 163
    end
    object BtnAdd: TcxButton
      Left = 32
      Top = 45
      Width = 60
      Height = 25
      Caption = #26032#22686
      TabOrder = 1
      OnClick = BtnAddClick
    end
    object BtnModify: TcxButton
      Left = 101
      Top = 45
      Width = 60
      Height = 25
      Caption = #20462#25913
      TabOrder = 2
      OnClick = BtnModifyClick
    end
    object BtnDel: TcxButton
      Left = 170
      Top = 45
      Width = 60
      Height = 25
      Caption = #21024#38500
      TabOrder = 3
      OnClick = BtnDelClick
    end
    object BtnClose: TcxButton
      Left = 447
      Top = 45
      Width = 60
      Height = 25
      Caption = #20851#38381
      TabOrder = 7
      OnClick = BtnCloseClick
    end
    object EdtRemark: TcxTextEdit
      Left = 308
      Top = 16
      Enabled = False
      TabOrder = 9
      Width = 205
    end
  end
  object cxGroupBox3: TcxGroupBox
    Left = 148
    Top = 0
    Align = alClient
    Caption = #21578#35686#20869#23481
    TabOrder = 2
    Height = 350
    Width = 399
    object cxGrid: TcxGrid
      Left = 2
      Top = 18
      Width = 395
      Height = 330
      Align = alClient
      TabOrder = 0
      object cxGridDBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSource
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
        object ItemALARMCONTENTCODE: TcxGridDBColumn
          Caption = #21578#35686#20869#23481#32534#21495
          DataBinding.FieldName = 'ALARMCONTENTCODE'
          Options.Editing = False
          Width = 75
        end
        object ItemALARMCONTENTNAME: TcxGridDBColumn
          Caption = #21578#35686#20869#23481#21517#31216
          DataBinding.FieldName = 'ALARMCONTENTNAME'
          Options.Editing = False
          Width = 102
        end
        object ItemRULEFLAGTRUE: TcxGridDBColumn
          Caption = #21516#26102#23384#22312#27966#35813#21578#35686
          DataBinding.FieldName = 'RULEFLAGTRUE'
          RepositoryItem = CheckBox
          Visible = False
          Width = 100
        end
        object ItemRULEFLAGFALSE: TcxGridDBColumn
          Caption = #19981#21516#26102#23384#22312#27966#35813#21578#35686
          DataBinding.FieldName = 'RULEFLAGFALSE'
          RepositoryItem = CheckBox
          Visible = False
          Width = 112
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableView1
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 61
    Top = 146
    object Menu_Add: TMenuItem
      Caption = #26032'  '#22686
      OnClick = Menu_AddClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Menu_Modify: TMenuItem
      Caption = #20462'  '#25913
      OnClick = Menu_ModifyClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Menu_Del: TMenuItem
      Caption = #21024'  '#38500
      OnClick = Menu_DelClick
    end
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 386
    Top = 177
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 387
    Top = 219
  end
  object cxEditRepository1: TcxEditRepository
    Left = 304
    Top = 280
    object cxEditRepository1ImageComboBoxItem1: TcxEditRepositoryImageComboBoxItem
      Properties.Items = <
        item
          Description = 'Sport'
          ImageIndex = 25
          Value = 'SPORTS'
        end
        item
          Description = 'Saloon'
          ImageIndex = 23
          Value = 'SALOON'
        end
        item
          Description = 'Truck'
          ImageIndex = 27
          Value = 'TRUCK'
        end>
    end
    object ComboBox: TcxEditRepositoryImageComboBoxItem
      Properties.Items = <
        item
          Description = #26159
          ImageIndex = 0
          Value = 1
        end
        item
          Description = #21542
          ImageIndex = 19
          Value = 0
        end>
    end
    object cxEditRepository1CalcItem1: TcxEditRepositoryCalcItem
    end
    object CheckBox: TcxEditRepositoryCheckBoxItem
      Properties.ValueChecked = 1
      Properties.ValueGrayed = -1
      Properties.ValueUnchecked = 0
    end
  end
end
