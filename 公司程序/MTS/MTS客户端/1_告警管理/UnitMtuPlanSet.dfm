object FormMtuPlanSet: TFormMtuPlanSet
  Left = 0
  Top = 0
  Caption = 'MTU'#27979#35797#35745#21010#37197#32622
  ClientHeight = 437
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object Splitter1: TSplitter
    Left = 202
    Top = 0
    Height = 437
    ExplicitLeft = 145
    ExplicitTop = -128
    ExplicitHeight = 565
  end
  object gbLeft: TGroupBox
    Left = 0
    Top = 0
    Width = 202
    Height = 437
    Align = alLeft
    Caption = #27979#35797#27169#26495#26641
    TabOrder = 0
    object TreeModel: TdxDBTreeView
      Left = 2
      Top = 14
      Width = 198
      Height = 421
      ShowNodeHint = True
      AutoExpand = True
      DataSource = gDSTree
      KeyField = 'ModelID'
      ListField = 'ModelName'
      ParentField = 'ParentModelID'
      RootValue = Null
      SeparatedSt = ' - '
      RaiseOnError = True
      ReadOnly = True
      Indent = 19
      OnChange = TreeModelChange
      OnGetImageIndex = TreeModelGetImageIndex
      Align = alClient
      ParentColor = False
      Options = [trDBCanDelete, trDBConfirmDelete, trCanDBNavigate, trSmartRecordCopy, trCheckHasChildren]
      SelectedIndex = -1
      TabOrder = 0
      Images = ImageList1
    end
  end
  object Panel1: TPanel
    Left = 205
    Top = 0
    Width = 527
    Height = 437
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 527
      Height = 112
      Align = alClient
      Caption = 'MTU'#21015#34920
      TabOrder = 0
      object cxGridMtu: TcxGrid
        Left = 2
        Top = 14
        Width = 523
        Height = 96
        Align = alClient
        TabOrder = 0
        object cxGridMtuDBTableView1: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          OnCellClick = cxGridMtuDBTableView1CellClick
          DataController.DataSource = gDS_Mtu
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Deleting = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.HideFocusRectOnExit = False
          OptionsSelection.MultiSelect = True
          OptionsView.GroupByBox = False
        end
        object cxGridMtuLevel1: TcxGridLevel
          GridView = cxGridMtuDBTableView1
        end
      end
    end
    object PageControl1: TPageControl
      Left = 0
      Top = 112
      Width = 527
      Height = 325
      ActivePage = TabSheet1
      Align = alBottom
      TabOrder = 1
      TabWidth = 150
      object TabSheet1: TTabSheet
        Caption = #27979#35797#35745#21010#37197#32622
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 519
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label1: TLabel
            Left = 24
            Top = 16
            Width = 72
            Height = 12
            Caption = #27979#35797#35745#21010#21517#31216
          end
          object ComboBoxTestPlan: TComboBox
            Left = 113
            Top = 15
            Width = 145
            Height = 20
            Style = csDropDownList
            ItemHeight = 12
            TabOrder = 0
            OnChange = ComboBoxTestPlanChange
          end
        end
        object gbWeek: TGroupBox
          Left = 0
          Top = 41
          Width = 519
          Height = 48
          Align = alTop
          Caption = #27599#21608#27979#35797#22825#25968
          TabOrder = 1
          object cbWeek1: TCheckBox
            Left = 36
            Top = 19
            Width = 57
            Height = 17
            Caption = #26143#26399#19968
            TabOrder = 0
          end
          object cbWeek2: TCheckBox
            Left = 100
            Top = 19
            Width = 57
            Height = 17
            Caption = #26143#26399#20108
            TabOrder = 1
          end
          object cbWeek3: TCheckBox
            Left = 165
            Top = 19
            Width = 57
            Height = 17
            Caption = #26143#26399#19977
            TabOrder = 2
          end
          object cbWeek4: TCheckBox
            Left = 230
            Top = 19
            Width = 57
            Height = 17
            Caption = #26143#26399#22235
            TabOrder = 3
          end
          object cbWeek5: TCheckBox
            Left = 295
            Top = 19
            Width = 57
            Height = 17
            Caption = #26143#26399#20116
            TabOrder = 4
          end
          object cbWeek6: TCheckBox
            Left = 360
            Top = 19
            Width = 57
            Height = 17
            Caption = #26143#26399#20845
            TabOrder = 5
          end
          object cbWeek7: TCheckBox
            Left = 425
            Top = 19
            Width = 57
            Height = 17
            Caption = #26143#26399#22825
            TabOrder = 6
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 257
          Width = 519
          Height = 41
          Align = alBottom
          TabOrder = 2
          object Button1: TButton
            Left = 31
            Top = 6
            Width = 75
            Height = 25
            Caption = #20445#23384#37197#32622
            TabOrder = 0
            OnClick = Button1Click
          end
          object Button2: TButton
            Left = 112
            Top = 6
            Width = 75
            Height = 25
            Caption = #24212#29992#27979#35797
            TabOrder = 1
            OnClick = Button2Click
          end
          object Button4: TButton
            Left = 193
            Top = 6
            Width = 75
            Height = 25
            Caption = #20851#38381
            TabOrder = 2
            OnClick = Button4Click
          end
        end
        object cxGridPlan: TcxGrid
          Left = 0
          Top = 89
          Width = 519
          Height = 168
          Align = alClient
          TabOrder = 3
          object cxGridPlanDBTableView1: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.DataSource = gDS_PlanValue
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsData.Deleting = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.GroupByBox = False
            object cxGridPlanDBTableView1Column1: TcxGridDBColumn
              Caption = #24320#22987#26102#38388
              DataBinding.FieldName = 'begintime'
              PropertiesClassName = 'TcxTimeEditProperties'
              Properties.ReadOnly = True
              Properties.TimeFormat = tfHourMin
              HeaderAlignmentHorz = taCenter
              Width = 250
            end
            object cxGridPlanDBTableView1Column2: TcxGridDBColumn
              Caption = #32467#26463#26102#38388
              DataBinding.FieldName = 'endtime'
              PropertiesClassName = 'TcxTimeEditProperties'
              Properties.ReadOnly = True
              Properties.TimeFormat = tfHourMin
              HeaderAlignmentHorz = taCenter
              Width = 250
            end
          end
          object cxGridPlanDBTableView2: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            DataController.DataSource = gDS_PlanValue2
            DataController.DetailKeyFieldNames = 'ParentID'
            DataController.KeyFieldNames = 'ID'
            DataController.MasterKeyFieldNames = 'ID'
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsData.Deleting = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.GroupByBox = False
          end
          object cxGridPlanLevel1: TcxGridLevel
            GridView = cxGridPlanDBTableView1
            object cxGridPlanLevel2: TcxGridLevel
              GridView = cxGridPlanDBTableView2
            end
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = #27979#35797#21442#25968#37197#32622
        ImageIndex = 1
        object Panel4: TPanel
          Left = 0
          Top = 257
          Width = 519
          Height = 41
          Align = alBottom
          TabOrder = 0
          object Button3: TButton
            Left = 15
            Top = 8
            Width = 75
            Height = 25
            Caption = #20445#23384#37197#32622
            TabOrder = 0
            OnClick = Button3Click
          end
          object Button5: TButton
            Left = 96
            Top = 8
            Width = 75
            Height = 25
            Caption = #20851#38381
            TabOrder = 1
            OnClick = Button4Click
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 519
          Height = 257
          Align = alClient
          Caption = 'Panel5'
          TabOrder = 1
          object GroupBox2: TGroupBox
            Left = 1
            Top = 1
            Width = 289
            Height = 255
            Align = alClient
            Caption = #27979#35797#21629#20196#31867#22411
            TabOrder = 0
            object cxGridCommand: TcxGrid
              Left = 2
              Top = 14
              Width = 285
              Height = 239
              Align = alClient
              TabOrder = 0
              object cxGridCommandDBTableView1: TcxGridDBTableView
                NavigatorButtons.ConfirmDelete = False
                OnCellClick = cxGridCommandDBTableView1CellClick
                DataController.DataSource = gDS_Command
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                OptionsCustomize.ColumnFiltering = False
                OptionsData.Deleting = False
                OptionsData.Editing = False
                OptionsData.Inserting = False
                OptionsSelection.HideFocusRectOnExit = False
                OptionsView.GroupByBox = False
                OptionsView.Indicator = True
              end
              object cxGridCommandLevel1: TcxGridLevel
                GridView = cxGridCommandDBTableView1
              end
            end
          end
          object GroupBox3: TGroupBox
            Left = 290
            Top = 1
            Width = 228
            Height = 255
            Align = alRight
            Caption = #21629#20196#21442#25968#37197#32622
            TabOrder = 1
            object cxGridParam: TcxGrid
              Left = 2
              Top = 14
              Width = 224
              Height = 239
              Align = alClient
              TabOrder = 0
              object cxGridParamDBTableView1: TcxGridDBTableView
                NavigatorButtons.ConfirmDelete = False
                DataController.DataSource = gDS_Param
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                OptionsCustomize.ColumnFiltering = False
                OptionsView.GroupByBox = False
                OptionsView.Indicator = True
                OnCustomDrawIndicatorCell = cxGridParamDBTableView1CustomDrawIndicatorCell
              end
              object cxGridParamLevel1: TcxGridLevel
                GridView = cxGridParamDBTableView1
              end
            end
          end
        end
      end
    end
  end
  object gDSTree: TDataSource
    DataSet = gCDSTree
    Left = 80
    Top = 96
  end
  object gCDSTree: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 64
  end
  object gDS_Mtu: TDataSource
    DataSet = gCDS_Mtu
    Left = 304
    Top = 64
  end
  object gCDS_Mtu: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 32
  end
  object gDS_Command: TDataSource
    DataSet = gCDS_Command
    Left = 344
    Top = 184
  end
  object gCDS_Command: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 184
  end
  object gDS_PlanValue: TDataSource
    DataSet = gCDS_PlanValue
    Left = 376
    Top = 352
  end
  object gCDS_PlanValue: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 376
    Top = 320
  end
  object gCDS_PlanValue2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 408
    Top = 320
  end
  object gDS_PlanValue2: TDataSource
    DataSet = gCDS_PlanValue2
    Left = 408
    Top = 352
  end
  object gCDS_Param: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 568
    Top = 184
  end
  object gDS_Param: TDataSource
    DataSet = gCDS_Param
    Left = 568
    Top = 216
  end
  object gCDS_Dym: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 56
    Top = 256
  end
  object ImageList1: TImageList
    Left = 128
    Top = 152
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
