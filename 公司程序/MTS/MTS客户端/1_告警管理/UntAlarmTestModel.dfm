object FrmAlarmTestModel: TFrmAlarmTestModel
  Left = 0
  Top = 0
  Caption = #27979#35797#35745#21010#37197#32622
  ClientHeight = 565
  ClientWidth = 979
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDesigned
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 0
    Top = 0
    Width = 979
    Height = 565
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 145
      Top = 0
      Height = 565
      ExplicitLeft = 120
      ExplicitTop = 3
    end
    object pLeft: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 565
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object gbLeft: TGroupBox
        Left = 0
        Top = 0
        Width = 145
        Height = 565
        Align = alClient
        Caption = #27979#35797#35745#21010#26641
        TabOrder = 0
        object tTaskModelTree: TdxDBTreeView
          Left = 2
          Top = 15
          Width = 141
          Height = 548
          ShowNodeHint = True
          DataSource = DSModel
          KeyField = 'ModelID'
          ListField = 'ModelName'
          ParentField = 'ParentModelID'
          RootValue = Null
          SeparatedSt = ' - '
          RaiseOnError = True
          ReadOnly = True
          Indent = 19
          OnChange = tTaskModelTreeChange
          OnGetImageIndex = tTaskModelTreeGetImageIndex
          Align = alClient
          ParentColor = False
          Options = [trDBCanDelete, trDBConfirmDelete, trCanDBNavigate, trSmartRecordCopy, trCheckHasChildren]
          SelectedIndex = -1
          TabOrder = 0
          Images = ImageList1
        end
      end
    end
    object pRight: TPanel
      Left = 148
      Top = 0
      Width = 831
      Height = 565
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object pgSetting: TPageControl
        Left = 0
        Top = 0
        Width = 831
        Height = 565
        ActivePage = TabSheet1
        Align = alClient
        TabOrder = 0
        object TabSheet1: TTabSheet
          Caption = #20219#21153#27169#26495#37197#32622
          object spMain: TSplitter
            Left = 0
            Top = 190
            Width = 823
            Height = 3
            Cursor = crVSplit
            Align = alTop
            ExplicitTop = 198
            ExplicitWidth = 339
          end
          object pTop: TPanel
            Left = 0
            Top = 0
            Width = 823
            Height = 190
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object GroupBox6: TGroupBox
              Left = 0
              Top = 0
              Width = 823
              Height = 190
              Align = alClient
              Caption = 'MTU'#20449#24687
              TabOrder = 0
              object cxgMTUInfo: TcxGrid
                Left = 2
                Top = 15
                Width = 819
                Height = 173
                Align = alClient
                TabOrder = 0
                object cxgtvMTUInfo: TcxGridDBTableView
                  NavigatorButtons.ConfirmDelete = False
                  OnCustomDrawCell = cxgtvMTUInfoCustomDrawCell
                  OnFocusedRecordChanged = cxgtvMTUInfoFocusedRecordChanged
                  DataController.DataSource = DSMTUList
                  DataController.Summary.DefaultGroupSummaryItems = <>
                  DataController.Summary.FooterSummaryItems = <>
                  DataController.Summary.SummaryGroups = <>
                  OptionsCustomize.ColumnFiltering = False
                  OptionsData.Deleting = False
                  OptionsData.Editing = False
                  OptionsData.Inserting = False
                  OptionsSelection.CellSelect = False
                  OptionsSelection.MultiSelect = True
                  OptionsView.GroupByBox = False
                end
                object cxGridLevel3: TcxGridLevel
                  GridView = cxgtvMTUInfo
                end
              end
            end
          end
          object pBottom: TPanel
            Left = 0
            Top = 193
            Width = 823
            Height = 344
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            object pBRight: TPanel
              Left = 659
              Top = 0
              Width = 164
              Height = 344
              Align = alRight
              BevelOuter = bvNone
              TabOrder = 0
              object gbParams: TGroupBox
                Left = 0
                Top = 0
                Width = 164
                Height = 465
                Caption = #35774#32622#20219#21153#21442#25968
                TabOrder = 0
                object Panel1: TPanel
                  Left = 6
                  Top = 199
                  Width = 158
                  Height = 67
                  BevelOuter = bvNone
                  TabOrder = 0
                  object Label5: TLabel
                    Left = 127
                    Top = 13
                    Width = 24
                    Height = 13
                    Caption = #20998#38047
                  end
                  object Label2: TLabel
                    Left = 127
                    Top = 42
                    Width = 12
                    Height = 13
                    Caption = #27425
                  end
                  object cxLabel2: TcxLabel
                    Left = 10
                    Top = 10
                    Caption = #24490#29615#38388#38548#65306
                  end
                  object cxLabel3: TcxLabel
                    Left = 10
                    Top = 39
                    Caption = #24490#29615#27425#25968#65306
                  end
                  object cxDBSpinEdit1: TcxDBSpinEdit
                    Left = 72
                    Top = 10
                    DataBinding.DataField = 'TIMEINTERVAL'
                    DataBinding.DataSource = DSModel
                    Properties.AssignedValues.MinValue = True
                    TabOrder = 2
                    Width = 49
                  end
                  object cxDBSpinEdit2: TcxDBSpinEdit
                    Left = 72
                    Top = 37
                    DataBinding.DataField = 'CYCCOUNT'
                    DataBinding.DataSource = DSModel
                    Properties.AssignedValues.MinValue = True
                    TabOrder = 3
                    Width = 49
                  end
                end
                object Panel3: TPanel
                  Left = 3
                  Top = 25
                  Width = 150
                  Height = 67
                  BevelOuter = bvNone
                  TabOrder = 1
                  object Label4: TLabel
                    Left = 128
                    Top = 13
                    Width = 12
                    Height = 13
                    Caption = #33267
                  end
                  object cxLabel4: TcxLabel
                    Left = 10
                    Top = 10
                    Caption = #26102#38388#27573#65306
                  end
                  object SendT2: TDateTimePicker
                    Left = 67
                    Top = 36
                    Width = 53
                    Height = 20
                    Date = 38938.625000000000000000
                    Format = 'HH:mm'
                    Time = 38938.625000000000000000
                    Kind = dtkTime
                    TabOrder = 1
                  end
                  object SendT1: TDateTimePicker
                    Left = 67
                    Top = 10
                    Width = 53
                    Height = 20
                    Date = 38938.416666666660000000
                    Format = 'HH:mm'
                    Time = 38938.416666666660000000
                    Kind = dtkTime
                    TabOrder = 2
                  end
                end
                object Panel4: TPanel
                  Left = 3
                  Top = 98
                  Width = 159
                  Height = 95
                  BevelOuter = bvNone
                  TabOrder = 2
                  object btAddTime: TButton
                    Left = 3
                    Top = 8
                    Width = 75
                    Height = 25
                    Caption = #26032#22686#26102#27573
                    TabOrder = 0
                    OnClick = btAddTimeClick
                  end
                  object btRemoveCom: TButton
                    Left = 81
                    Top = 59
                    Width = 75
                    Height = 25
                    Caption = #21024#38500#21629#20196
                    TabOrder = 1
                    OnClick = btRemoveComClick
                  end
                  object btAddCom: TButton
                    Left = 3
                    Top = 59
                    Width = 75
                    Height = 25
                    Caption = #26032#22686#21629#20196
                    TabOrder = 2
                    OnClick = btAddComClick
                  end
                  object btRemoveTime: TButton
                    Left = 81
                    Top = 8
                    Width = 75
                    Height = 25
                    Caption = #21024#38500#26102#27573
                    TabOrder = 3
                    OnClick = btRemoveTimeClick
                  end
                end
                object clbModelCom: TCheckListBox
                  Left = 9
                  Top = 262
                  Width = 152
                  Height = 252
                  ItemHeight = 13
                  TabOrder = 3
                end
              end
            end
            object pBLeft: TPanel
              Left = 0
              Top = 0
              Width = 659
              Height = 344
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              object pModelEdit: TPanel
                Left = 0
                Top = 269
                Width = 659
                Height = 75
                Align = alBottom
                BevelOuter = bvNone
                TabOrder = 1
                object pModelChange: TPanel
                  Left = 0
                  Top = 0
                  Width = 659
                  Height = 37
                  Align = alTop
                  BevelOuter = bvNone
                  TabOrder = 0
                  object cxLabel1: TcxLabel
                    Left = 2
                    Top = 8
                    Caption = #35745#21010#21517#31216#65306
                  end
                  object lModelType: TcxLabel
                    Left = 174
                    Top = 8
                    Caption = #35745#21010#31867#21035#65306
                  end
                  object btNewType: TButton
                    Left = 350
                    Top = 6
                    Width = 75
                    Height = 25
                    Caption = #26032#22686#31867#22411'...'
                    TabOrder = 2
                    OnClick = btNewTypeClick
                  end
                  object cbModelType: TcxLookupComboBox
                    Left = 234
                    Top = 8
                    Properties.DropDownListStyle = lsFixedList
                    Properties.KeyFieldNames = 'ModelID'
                    Properties.ListColumns = <
                      item
                        Caption = #27169#26495#31867#22411
                        FieldName = 'ModelName'
                      end>
                    Properties.ListSource = DSModelType
                    TabOrder = 3
                    Width = 112
                  end
                  object eModelName: TcxTextEdit
                    Left = 65
                    Top = 8
                    TabOrder = 4
                    Text = 'eModelName'
                    Width = 108
                  end
                  object btChangeType: TButton
                    Left = 428
                    Top = 6
                    Width = 75
                    Height = 25
                    Caption = #20462#25913#31867#22411'...'
                    TabOrder = 5
                    OnClick = btChangeTypeClick
                  end
                end
                object pDBSave: TPanel
                  Left = 0
                  Top = 37
                  Width = 659
                  Height = 38
                  Align = alClient
                  BevelOuter = bvNone
                  TabOrder = 1
                  object btNew: TButton
                    Left = 319
                    Top = 6
                    Width = 75
                    Height = 25
                    Caption = #26032#22686
                    TabOrder = 0
                    Visible = False
                    OnClick = btNewClick
                  end
                  object btSave: TButton
                    Left = 142
                    Top = 6
                    Width = 75
                    Height = 25
                    Caption = #20445#23384#20462#25913
                    TabOrder = 1
                    OnClick = btSaveClick
                  end
                  object btAdd: TButton
                    Left = 365
                    Top = 6
                    Width = 113
                    Height = 25
                    Caption = #28155#21152#21040#33258#21160#21015#34920
                    TabOrder = 2
                    Visible = False
                    OnClick = btAddClick
                  end
                  object btAddModel: TButton
                    Left = 53
                    Top = 6
                    Width = 75
                    Height = 25
                    Caption = #26032#22686#35745#21010
                    TabOrder = 3
                    OnClick = btAddModelClick
                  end
                  object btDelete: TButton
                    Left = 240
                    Top = 6
                    Width = 75
                    Height = 25
                    Caption = #21024#38500
                    TabOrder = 4
                    OnClick = btDeleteClick
                  end
                end
              end
              object Panel8: TPanel
                Left = 0
                Top = 0
                Width = 659
                Height = 269
                Align = alClient
                BevelOuter = bvNone
                TabOrder = 0
                object gbTaskList: TGroupBox
                  Left = 0
                  Top = 58
                  Width = 659
                  Height = 211
                  Align = alClient
                  Caption = #27979#35797#20219#21153#21015#34920
                  TabOrder = 0
                  object cxgTaskListTime: TcxGrid
                    Left = 2
                    Top = 15
                    Width = 655
                    Height = 194
                    Align = alClient
                    TabOrder = 0
                    object cxgtvTaskListTime: TcxGridDBTableView
                      NavigatorButtons.ConfirmDelete = False
                      DataController.DataSource = DSTaskListTime
                      DataController.Summary.DefaultGroupSummaryItems = <>
                      DataController.Summary.FooterSummaryItems = <>
                      DataController.Summary.SummaryGroups = <>
                      OptionsCustomize.ColumnFiltering = False
                      OptionsData.Deleting = False
                      OptionsData.Inserting = False
                      OptionsView.GroupByBox = False
                      object cxgtvTaskListTimeColumnbegintime: TcxGridDBColumn
                        Caption = #24320#22987#26102#38388
                        DataBinding.FieldName = 'begintime'
                        PropertiesClassName = 'TcxTimeEditProperties'
                        Properties.Alignment.Horz = taCenter
                        Properties.TimeFormat = tfHourMin
                        HeaderAlignmentHorz = taCenter
                        Options.Editing = False
                        SortIndex = 0
                        SortOrder = soAscending
                        Width = 201
                      end
                      object cxgtvTaskListTimeColumnendtime: TcxGridDBColumn
                        Caption = #32467#26463#26102#38388
                        DataBinding.FieldName = 'endtime'
                        PropertiesClassName = 'TcxTimeEditProperties'
                        Properties.Alignment.Horz = taCenter
                        Properties.TimeFormat = tfHourMin
                        HeaderAlignmentHorz = taCenter
                        Options.Editing = False
                        Width = 200
                      end
                    end
                    object cxgtvTaskListTimeDetail: TcxGridDBTableView
                      NavigatorButtons.ConfirmDelete = False
                      DataController.DataSource = DSTaskListTimeDetail
                      DataController.DetailKeyFieldNames = 'ParentID'
                      DataController.KeyFieldNames = 'ID'
                      DataController.MasterKeyFieldNames = 'ID'
                      DataController.Summary.DefaultGroupSummaryItems = <>
                      DataController.Summary.FooterSummaryItems = <>
                      DataController.Summary.SummaryGroups = <>
                      OptionsCustomize.ColumnFiltering = False
                      OptionsCustomize.ColumnSorting = False
                      OptionsData.Deleting = False
                      OptionsData.Inserting = False
                      OptionsView.GroupByBox = False
                      object cxgtvTaskListTimeDetailColumnComName: TcxGridDBColumn
                        Caption = #27979#35797#21629#20196
                        DataBinding.FieldName = 'ComName'
                        HeaderAlignmentHorz = taCenter
                        Options.Editing = False
                        Width = 200
                      end
                      object cxgtvTaskListTimeDetailColumn2: TcxGridDBColumn
                        Caption = #24490#29615#27425#25968
                        DataBinding.FieldName = 'cyccount'
                        HeaderAlignmentHorz = taCenter
                        Width = 100
                      end
                      object cxgtvTaskListTimeDetailColumn3: TcxGridDBColumn
                        Caption = #24490#29615#38388#38548
                        DataBinding.FieldName = 'timeinterval'
                        HeaderAlignmentHorz = taCenter
                        Width = 100
                      end
                      object cxgtvTaskListTimeDetailColumnCURR_CYCCOUNT: TcxGridDBColumn
                        Caption = #24403#21069#24050#25191#34892#27425#25968
                        DataBinding.FieldName = 'CURR_CYCCOUNT'
                        Width = 100
                      end
                    end
                    object cxglTaskListTime: TcxGridLevel
                      GridView = cxgtvTaskListTime
                      object cxglTaskListTimeDetail: TcxGridLevel
                        GridView = cxgtvTaskListTimeDetail
                      end
                    end
                  end
                end
                object pWeek: TPanel
                  Left = 0
                  Top = 0
                  Width = 659
                  Height = 58
                  Align = alTop
                  BevelOuter = bvNone
                  TabOrder = 1
                  object gbWeek: TGroupBox
                    Left = 4
                    Top = 6
                    Width = 467
                    Height = 48
                    Caption = #27599#21608#27979#35797#22825#25968
                    TabOrder = 0
                    object cbWeek1: TCheckBox
                      Left = 12
                      Top = 19
                      Width = 57
                      Height = 17
                      Caption = #26143#26399#19968
                      TabOrder = 0
                    end
                    object cbWeek2: TCheckBox
                      Left = 75
                      Top = 19
                      Width = 57
                      Height = 17
                      Caption = #26143#26399#20108
                      TabOrder = 1
                    end
                    object cbWeek3: TCheckBox
                      Left = 138
                      Top = 19
                      Width = 57
                      Height = 17
                      Caption = #26143#26399#19977
                      TabOrder = 2
                    end
                    object cbWeek4: TCheckBox
                      Left = 201
                      Top = 19
                      Width = 57
                      Height = 17
                      Caption = #26143#26399#22235
                      TabOrder = 3
                    end
                    object cbWeek5: TCheckBox
                      Left = 264
                      Top = 19
                      Width = 57
                      Height = 17
                      Caption = #26143#26399#20116
                      TabOrder = 4
                    end
                    object cbWeek6: TCheckBox
                      Left = 338
                      Top = 19
                      Width = 57
                      Height = 17
                      Caption = #26143#26399#20845
                      TabOrder = 5
                    end
                    object cbWeek7: TCheckBox
                      Left = 401
                      Top = 19
                      Width = 57
                      Height = 17
                      Caption = #26143#26399#22825
                      TabOrder = 6
                    end
                  end
                  object btJHControl: TButton
                    Left = 480
                    Top = 20
                    Width = 75
                    Height = 25
                    Caption = #26242#20572#35745#21010
                    Enabled = False
                    TabOrder = 1
                    OnClick = btJHControlClick
                  end
                  object btJHDelete: TButton
                    Left = 561
                    Top = 20
                    Width = 75
                    Height = 25
                    Caption = #21024#38500#35745#21010
                    Enabled = False
                    TabOrder = 2
                    OnClick = btJHDeleteClick
                  end
                end
              end
            end
          end
        end
        object TabSheet2: TTabSheet
          Caption = #27169#26495#21629#20196#21442#25968#37197#32622
          ImageIndex = 1
          object pTop2: TPanel
            Left = 0
            Top = 0
            Width = 823
            Height = 216
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object GroupBox5: TGroupBox
              Left = 0
              Top = 0
              Width = 823
              Height = 216
              Align = alClient
              Caption = 'MTU'#20449#24687
              TabOrder = 0
              object cxGrid2: TcxGrid
                Left = 2
                Top = 15
                Width = 819
                Height = 199
                Align = alClient
                TabOrder = 0
                object cxGridDBTableView1: TcxGridDBTableView
                  NavigatorButtons.ConfirmDelete = False
                  OnFocusedRecordChanged = cxGridDBTableView1FocusedRecordChanged
                  DataController.DataSource = DSMTUList
                  DataController.Summary.DefaultGroupSummaryItems = <>
                  DataController.Summary.FooterSummaryItems = <>
                  DataController.Summary.SummaryGroups = <>
                  OptionsCustomize.ColumnFiltering = False
                  OptionsData.Deleting = False
                  OptionsData.Editing = False
                  OptionsData.Inserting = False
                end
                object cxGridLevel1: TcxGridLevel
                  GridView = cxGridDBTableView1
                end
              end
            end
          end
          object pBottom2: TPanel
            Left = 0
            Top = 216
            Width = 823
            Height = 321
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object Panel9: TPanel
              Left = 0
              Top = 0
              Width = 823
              Height = 53
              Align = alTop
              TabOrder = 0
              object Panel2: TPanel
                Left = 161
                Top = 6
                Width = 265
                Height = 41
                TabOrder = 0
                object Button5: TButton
                  Left = 96
                  Top = 8
                  Width = 75
                  Height = 25
                  Caption = #20445#23384#20462#25913
                  TabOrder = 0
                end
              end
            end
            object Panel7: TPanel
              Left = 0
              Top = 53
              Width = 823
              Height = 268
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              object GroupBox4: TGroupBox
                Left = 353
                Top = 0
                Width = 470
                Height = 268
                Align = alClient
                Caption = #21629#20196#21442#25968#35774#32622
                TabOrder = 0
                object cxGrid3: TcxGrid
                  Left = 2
                  Top = 15
                  Width = 466
                  Height = 251
                  Align = alClient
                  TabOrder = 0
                  object cxGridDBTableView2: TcxGridDBTableView
                    NavigatorButtons.ConfirmDelete = False
                    DataController.DataSource = DSModelComParam
                    DataController.Summary.DefaultGroupSummaryItems = <>
                    DataController.Summary.FooterSummaryItems = <>
                    DataController.Summary.SummaryGroups = <>
                  end
                  object cxGridLevel2: TcxGridLevel
                    GridView = cxGridDBTableView2
                  end
                end
              end
              object GroupBox3: TGroupBox
                Left = 0
                Top = 0
                Width = 353
                Height = 268
                Align = alLeft
                Caption = #27979#35797#21629#20196#31867#22411
                TabOrder = 1
                object cxGrid4: TcxGrid
                  Left = 2
                  Top = 15
                  Width = 349
                  Height = 251
                  Align = alClient
                  TabOrder = 0
                  object cxGridDBTableView4: TcxGridDBTableView
                    NavigatorButtons.ConfirmDelete = False
                    OnFocusedRecordChanged = cxGridDBTableView4FocusedRecordChanged
                    DataController.DataSource = DSModelCom
                    DataController.Summary.DefaultGroupSummaryItems = <>
                    DataController.Summary.FooterSummaryItems = <>
                    DataController.Summary.SummaryGroups = <>
                  end
                  object cxGridLevel4: TcxGridLevel
                    GridView = cxGridDBTableView4
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  object CDSMTUList: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 320
    Top = 64
  end
  object DSMTUList: TDataSource
    DataSet = CDSMTUList
    Left = 376
    Top = 64
  end
  object CDSModelComParam: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 632
    Top = 496
  end
  object DSModelComParam: TDataSource
    DataSet = CDSModelComParam
    Left = 704
    Top = 496
  end
  object CDSModel: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 64
  end
  object DSModel: TDataSource
    DataSet = CDSModel
    Left = 80
    Top = 120
  end
  object DSModelCom: TDataSource
    DataSet = CDSModelCom
    Left = 704
    Top = 456
  end
  object CDSModelCom: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 640
    Top = 456
  end
  object DSTaskListTime: TDataSource
    DataSet = CDSTaskListTime
    Left = 312
    Top = 200
  end
  object CDSTaskListTimeDetail: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 208
    Top = 256
  end
  object DSTaskListTimeDetail: TDataSource
    DataSet = CDSTaskListTimeDetail
    Left = 312
    Top = 256
  end
  object CDSTaskListTime: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 208
    Top = 200
  end
  object CDSModelType: TClientDataSet
    Aggregates = <>
    Filter = 'parentmodelid=1'
    Filtered = True
    Params = <>
    Left = 392
    Top = 424
  end
  object DSModelType: TDataSource
    DataSet = CDSModelType
    Left = 472
    Top = 424
  end
  object ImageList1: TImageList
    Left = 80
    Top = 176
    Bitmap = {
      494C010103000500040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      00000000000000000000000000000000000000000000F8F8F8FFF4F4F4FFEFEF
      EFFFEAEAEAFFC4C4C4FFC4C4C4FFC4C4C4FFC4C4C4FFCFCFCFFFDDDDDDFFE5E5
      E5FFECECECFFF4F4F4FFFCFCFCFF00000000FEFEFEFFE4E4E4FFBEBEBEFFB1B1
      B1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1
      D1FFD1D1D1FFD3D3D3FFEDEDEDFF000000000000000000000000E8E8E8FFD8D8
      D8FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000E5E5E5FF404040FF050505FF040404FF040404FF050505FF050505FF2020
      20FFAFAFAFFF000000000000000000000000F6F6F6FF919393FFA0A1A2FFA6A8
      A8FFA6A8A8FFA2A4A5FF9FA1A1FFA3A5A5FFA6A8A8FFA6A8A8FFA5A7A8FFA6A7
      A8FF7A8F8FFFA7A8A8FF8C8D8EFFFDFDFDFF0000000000000000AFAFAFFFFFFF
      FFFFFAFAFAFFC0C0C0FF989898FFD1D1D1FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      84FF040404FF040404FF040404FF040404FF040303FF040404FF040404FF0404
      04FF040404FF353535FFF9F9F9FF00000000EBEBEBFFBCBCBCFFB0B0B0FFAFAF
      AFFFAEB0B0FFAEAEAEFFAEB0B0FFB0B0B0FFB0B0B0FFAEAEAEFFAEAEAEFFADAD
      ADFFD8B5B5FFAAACACFF9E9F9FFFFCFCFCFF0000000000000000D4D4D4FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFBFBFBFFF969696FFC8C8
      C8FFFEFEFEFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007C7C7CFF0404
      04FF040404FF030303FF091210FF0E9680FF21AC89FF4C9463FF1A291EFF0000
      00FF050505FF020202FFFDFDFDFF00000000E9E9E9FFE4E2E1FFD6D6D6FFD3D3
      D2FFD4D3D3FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD1D1D1FFD0CF
      CFFFD0CFCFFFD1D0D0FFB5B6B6FFFCFCFCFF0000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFB4B4B4FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6D6D6FF040404FF0404
      04FF040000FF0DBEA2FF04DEBCFF05D3B2FF22CDA2FF5FBC7CFF61C07FFF66C8
      82FF090D0FFF000000000000000000000000F8F8F8FFAEA9A5FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF9CA2A5FF0000000000000000F2F2F2FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFF5F5F5FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000191919FF040404FF0400
      00FF0CB3DAFF05C7D1FF04D5B3FF05D4B4FF22CEA2FF5FBD7CFF60BD7AFF71B3
      62FFC29C02FFC2C2C2FF0000000000000000FDFDFDFF0E64A9FF0096FFFF0095
      FDFF0099FDFF009DFCFF00A2FCFF03A6FCFF07ADFBFF0BB1FBFF11B7FBFF17BB
      FBFF1EC2FBFF32D9FEFF477598FF0000000000000000B7B7B7FFFAFAFAFFEFEF
      EFFFFFFFFFFFFFFFFFFFFCFCFCFFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF8F8F8FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FAFAFAFF050505FF040404FF0B3E
      4AFF04C0EBFF05BFE9FF05C8D6FF05D4B2FF22CEA2FF5FBD7CFF79AF57FFB691
      01FFB29204FF988326FF0000000000000000000000001A5F95FF29ACFFFF24A6
      FFFF29AAFFFF2BAEFFFF2FB2FFFF35B6FFFF38BAFFFF3CBFFFFF41C3FFFF47C8
      FFFF4ACDFFFF66E9FFFF67869DFF0000000000000000BCBCBCFFEBEBEBFFCECE
      CEFFDCDCDCFFDADADAFFD5D5D5FF435163FFB3C9E4FFFFFFFFFFFDFDFDFFFEFE
      FEFFB8B8B8FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D4D4D4FF040404FF040202FF0DA3
      C6FF04BFE8FF04BFE9FF04BFE9FF05C5D9FF22CEA2FF7DAE51FFB59101FFB292
      04FFB29204FFBF9D06FFF8F8F8FF00000000000000003A6B91FF2AACFFFF25A6
      FFFF28A9FFFF2CADFFFF30B1FFFF34B5FFFF3AB9FFFF3DBFFFFF43C2FFFF46C8
      FFFF4CCCFFFF6AEEFFFF8B9CA9FF0000000000000000F1F1F1FFE7E7E7FFCDCD
      CDFFC5C5C5FFE0E0E0FFD6D6D6FFB3BFC4FF2DAFFFFF6281C4FFD0CFCCFFFFFF
      FFFFF3F3F3FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BFBFBFFF040404FF030000FF0D87
      DCFF0684DDFF0684DDFF0684DDFF0684DEFF3A71B6FFC4AA32FFBEA538FFBEA5
      38FFBEA538FFCAAE3AFFF6F6F6FF00000000000000005E7D94FF26A8FFFF24A2
      FFFF28A6FFFF2CAAFFFF30AEFFFF34B2FFFF38B6FFFF3EBBFFFF41BFFFFF46C5
      FFFF4AC8FFFF6BEEFFFFAFB7BDFF0000000000000000FFFFFFFFD6D6D6FFD3D3
      D3FFC9C9C9FFD8D8D8FFDADADAFFD3D1D0FF7ACDDEFF32CAFFFF5E81CFFFFFFF
      FFFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D8D8D8FF040404FF030202FF0C5C
      B7FF0467D8FF0467D8FF0368D8FF2F38D1FF5C02B8FF732388FFC7B64EFFC3AE
      52FFC3AE52FFD0B956FF0000000000000000000000008293A0FF22A2FFFF249F
      FDFF29A3FFFF2BA7FFFF2FABFFFF33AFFFFF38B3FFFF3CB8FFFF42BCFFFF45C2
      FFFF48C5FFFF63E5FEFFCDD0D3FF00000000D8D8D8FFFFFFFFFFD1D1D1FFC7C7
      C7FFD1D1D1FFD2D2D2FFCFCFCFFFDCDCDCFFD7D5D4FF9FE3E9FF39D6FFFF5B7E
      C5FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000050505FF040404FF0925
      45FF0467D9FF0467D9FF3234D0FF5803CAFF5B05B8FF660491FF70208BFFC8B7
      4FFFC2AD51FFB6A76CFF0000000000000000000000009AA1A7FF1D9BFCFF229C
      F7FF27A0FEFF2BA4FFFF2FA8FFFF33ACFFFF37B0FFFF3BB6FFFF41B9FFFF44BD
      FFFF47C1FFFF53D0FCFFE4E5E5FF00000000AFAFAFFFECECECFFCFCFCFFFD7D7
      D7FFD3D3D3FFC9C9C9FFC8C8C8FFCBCBCBFFC6C6C6FFD6D4D4FFC3E7E4FF3DD8
      FFFF608ED3FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000232323FF040404FF0300
      00FF0967D0FF3B29CEFF5803CAFF5604CAFF5B05B8FF660490FF660490FF6913
      8FFFD8C753FFFCFCFCFF000000000000000000000000BDBFC2FF1491F1FF2199
      F2FF269DF8FF2AA1FCFF2EA5FFFF32A9FFFF36ADFFFF3AB1FFFF3EB5FFFF43BA
      FFFF44BAFEFF40B5F2FFF2F2F2FF00000000D7D7D7FFF3F3F3FFD1D1D1FFCCCC
      CCFFC5C5C5FFCBCBCBFFD4D4D4FFC1C1C1FFCECECEFFD4D4D4FFFAF9F9FFB7C7
      C6FF3DD8FFFF699DD7FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EDEDEDFF040404FF0404
      04FF040000FF530BBEFF5704CEFF5604CAFF5B05B8FF660490FF65038FFF6F07
      9DFF080610FFDBDBDBFF000000000000000000000000D6D6D7FF0D84DEFF2296
      EDFF279AF3FF299EF8FF2DA1FAFF31A5FFFF35A9FFFF39AFFFFF3DB2FFFF43B6
      FFFF41B5FEFF359BDEFF7272A7FF00000000E6E6E6FFF5F5F5FFFFFFFFFFFAFA
      FAFFF4F4F4FFF1F1F1FFE7E7E7FFD6D6D6FFC8C8C8FFF7F7F7FFBABABAFF0000
      0000B0C7C6FFC5C0BEFF7474AAFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A5A5A5FF0404
      04FF040404FF010400FF0D091AFF40108BFF560AABFF561077FF1D0A27FF0004
      00FF050404FF050505FFEEEEEEFF0000000000000000EFEFEFFF0874C5FF2092
      E8FF2597EEFF289AF1FF2C9EF5FF2EA2F9FF33A6FEFF36AAFFFF3CAEFFFF40B2
      FFFF3EB1FCFF2D82C2FFA6A6F8FF00000000000000000000000000000000F3F3
      F3FFDFDFDFFFE4E4E4FFFCFCFCFFFFFFFFFFF6F6F6FFFFFFFFFFFCFCFCFF0000
      000000000000AAAABFFFA7A7F9FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BDFF040404FF040404FF040404FF030303FF010300FF020302FF040404FF0404
      04FF040404FF7C7C7CFF000000000000000000000000F7F7F7FF0A5DA7FF178D
      E5FF1890EAFF1D92EEFF1F97F1FF239BF5FF259DF9FF29A1FDFF2DA5FFFF31A9
      FFFF34A8FCFF3D81B4FF00000000000000000000000000000000000000000000
      0000000000000000000000000000FEFEFEFFE9E9E9FFD2D2D2FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000818181FF090909FF040404FF040404FF040404FF050505FF5757
      57FFFAFAFAFF00000000000000000000000000000000FEFEFEFF9BA3A8FFCFD6
      DCFFCFD8DDFFD1D9DFFFD2DBE0FFD4DDE2FFD6DFE3FFD8E0E5FFD9E2E7FFDBE3
      E8FFDCE4E9FFAEB2B4FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0080010001CFFF0000F0070000C0FF0000
      E0010000C0070000C0010000C003000080070001800300008003000180070000
      0003800180070000000180018007000000018001800F000000038001000F0000
      800380010007000080038001000300008003800100110000C0018001E0190000
      E0038003FE3F0000F8078003FFFF0000}
  end
end
