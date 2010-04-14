object Fm_AlarmContent: TFm_AlarmContent
  Left = 0
  Top = 0
  Caption = #21578#35686#20869#23481#31649#29702
  ClientHeight = 563
  ClientWidth = 811
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 811
    Height = 563
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 0
      Top = 0
      Width = 811
      Height = 563
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #21578#35686#20869#23481#31649#29702
        object AdvStringGrid1: TAdvStringGrid
          Left = 0
          Top = 0
          Width = 577
          Height = 535
          Cursor = crDefault
          Align = alClient
          DefaultRowHeight = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 0
          OnClick = AdvStringGrid1Click
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWindowText
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          SearchFooter.FindNextCaption = 'Find next'
          SearchFooter.FindPrevCaption = 'Find previous'
          SearchFooter.HighLightCaption = 'Highlight'
          SearchFooter.HintClose = 'Close'
          SearchFooter.HintFindNext = 'Find next occurence'
          SearchFooter.HintFindPrev = 'Find previous occurence'
          SearchFooter.HintHighlight = 'Highlight occurences'
          SearchFooter.MatchCaseCaption = 'Match case'
          PrintSettings.DateFormat = 'dd/mm/yyyy'
          PrintSettings.Font.Charset = DEFAULT_CHARSET
          PrintSettings.Font.Color = clWindowText
          PrintSettings.Font.Height = -11
          PrintSettings.Font.Name = 'Tahoma'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'Tahoma'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'Tahoma'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'Tahoma'
          PrintSettings.FooterFont.Style = []
          PrintSettings.PageNumSep = '/'
          ScrollWidth = 16
          FixedFont.Charset = DEFAULT_CHARSET
          FixedFont.Color = clWindowText
          FixedFont.Height = -11
          FixedFont.Name = 'Tahoma'
          FixedFont.Style = [fsBold]
          FloatFormat = '%.2f'
          Filter = <>
          Version = '3.3.0.1'
        end
        object gb_info: TGroupBox
          Left = 577
          Top = 0
          Width = 226
          Height = 535
          Align = alRight
          Caption = #21578#35686#20869#23481#20449#24687
          TabOrder = 1
          object Label1: TLabel
            Left = 5
            Top = 23
            Width = 72
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#20869#23481#21517#31216
          end
          object Label2: TLabel
            Left = 5
            Top = 51
            Width = 72
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#20869#23481#31867#22411
          end
          object Label3: TLabel
            Left = 5
            Top = 80
            Width = 72
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#20869#23481#31561#32423
          end
          object Label4: TLabel
            Left = 5
            Top = 107
            Width = 75
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#26469#28304#21629#20196' '
          end
          object Label5: TLabel
            Left = 5
            Top = 133
            Width = 72
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#26469#28304#21442#25968
          end
          object Label6: TLabel
            Left = 5
            Top = 156
            Width = 160
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#20135#29983#26465#20214' ('#26684#24335' @value=1)'
          end
          object Label7: TLabel
            Left = 5
            Top = 241
            Width = 72
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#20135#29983#38376#38480
          end
          object Label8: TLabel
            Left = 3
            Top = 270
            Width = 160
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#25490#38500#26465#20214' ('#26684#24335' @value=1)'
          end
          object Label9: TLabel
            Left = 5
            Top = 357
            Width = 72
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#25490#38500#38376#38480
          end
          object Label10: TLabel
            Left = 5
            Top = 390
            Width = 72
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#25490#38500#26102#38480
          end
          object Label11: TLabel
            Left = 3
            Top = 424
            Width = 75
            Height = 13
            Margins.Bottom = 0
            Caption = ' '#21578#35686#26159#21542#26377#25928
          end
          object Label12: TLabel
            Left = 5
            Top = 455
            Width = 72
            Height = 13
            Margins.Bottom = 0
            Caption = #21578#35686#22788#29702#31867#22411
          end
          object Et_AlarmContentName: TEdit
            Left = 87
            Top = 19
            Width = 134
            Height = 21
            TabOrder = 0
          end
          object cbb_AlarmKind: TComboBox
            Left = 87
            Top = 47
            Width = 136
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 1
          end
          object cbb_AlarmLevel: TComboBox
            Left = 87
            Top = 76
            Width = 136
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 2
          end
          object cbb_AlarmCom: TComboBox
            Left = 87
            Top = 103
            Width = 136
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 3
          end
          object cbb_AlarmParam: TComboBox
            Left = 87
            Top = 130
            Width = 136
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 4
          end
          object SE_AlarmCount: TSpinEdit
            Left = 87
            Top = 237
            Width = 134
            Height = 22
            MaxValue = 9999
            MinValue = 1
            TabOrder = 5
            Value = 1
          end
          object SE_RemoveCount: TSpinEdit
            Left = 87
            Top = 353
            Width = 134
            Height = 22
            MaxValue = 9999
            MinValue = 1
            TabOrder = 6
            Value = 1
          end
          object SE_LimitHour: TSpinEdit
            Left = 89
            Top = 381
            Width = 134
            Height = 22
            MaxValue = 9999
            MinValue = 1
            TabOrder = 7
            Value = 1
          end
          object Et_ALARMCONDITION: TMemo
            Left = 7
            Top = 173
            Width = 214
            Height = 54
            Lines.Strings = (
              '')
            TabOrder = 8
          end
          object Et_REMOVECONDITION: TMemo
            Left = 7
            Top = 286
            Width = 214
            Height = 61
            Lines.Strings = (
              '')
            TabOrder = 9
          end
          object BtnModify: TBitBtn
            Left = 6
            Top = 496
            Width = 65
            Height = 34
            Caption = #20462#25913
            TabOrder = 10
            OnClick = BtnModifyClick
          end
          object BtnOk: TBitBtn
            Left = 81
            Top = 496
            Width = 65
            Height = 34
            Caption = #30830#23450
            TabOrder = 11
            OnClick = BtnOkClick
          end
          object BtnClose: TBitBtn
            Left = 156
            Top = 496
            Width = 65
            Height = 34
            Caption = #36820#22238
            TabOrder = 12
            OnClick = BtnCloseClick
          end
          object cbb_Effect: TComboBox
            Left = 86
            Top = 420
            Width = 136
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 13
            Items.Strings = (
              #21542
              #26159)
          end
          object cbb_SendType: TComboBox
            Left = 87
            Top = 451
            Width = 136
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 14
            Items.Strings = (
              #30452#25509#21028#26029
              #20998#26512)
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = #21578#35686#38376#38480#23450#20041
        ImageIndex = 1
        object Splitter1: TSplitter
          Left = 161
          Top = 0
          Height = 535
          ExplicitLeft = 120
          ExplicitTop = 3
        end
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 161
          Height = 535
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object GroupBox3: TGroupBox
            Left = 0
            Top = 0
            Width = 161
            Height = 535
            Align = alClient
            Caption = #21578#35686#38376#38480#27169#26495#26641
            TabOrder = 0
            object tAlarmModelTree: TdxDBTreeView
              Left = 2
              Top = 15
              Width = 157
              Height = 518
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
              OnChange = tAlarmModelTreeChange
              Align = alClient
              ParentColor = False
              Options = [trDBCanDelete, trDBConfirmDelete, trCanDBNavigate, trSmartRecordCopy, trCheckHasChildren]
              SelectedIndex = -1
              TabOrder = 0
              OnSetDisplayItemText = tAlarmModelTreeSetDisplayItemText
            end
          end
        end
        object Panel5: TPanel
          Left = 164
          Top = 0
          Width = 639
          Height = 535
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Panel3: TPanel
            Left = 0
            Top = 68
            Width = 639
            Height = 467
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object GroupBox1: TGroupBox
              Left = 0
              Top = 0
              Width = 511
              Height = 467
              Align = alClient
              Caption = #21442#25968#21015#34920
              TabOrder = 0
              object cxGrid1: TcxGrid
                Left = 2
                Top = 50
                Width = 507
                Height = 415
                Align = alClient
                TabOrder = 0
                object cxGrid1DBTableView1: TcxGridDBTableView
                  NavigatorButtons.ConfirmDelete = False
                  OnFocusedRecordChanged = cxGrid1DBTableView1FocusedRecordChanged
                  DataController.DataSource = DSModelContent
                  DataController.Summary.DefaultGroupSummaryItems = <>
                  DataController.Summary.FooterSummaryItems = <>
                  DataController.Summary.SummaryGroups = <>
                  OptionsData.Deleting = False
                  OptionsData.Editing = False
                  OptionsData.Inserting = False
                  OptionsView.GroupByBox = False
                  Styles.StyleSheet = cxGridTableViewStyleSheet1
                end
                object cxGrid1Level1: TcxGridLevel
                  GridView = cxGrid1DBTableView1
                end
              end
              object Panel6: TPanel
                Left = 2
                Top = 15
                Width = 507
                Height = 35
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 1
                object Label14: TLabel
                  Left = 14
                  Top = 10
                  Width = 108
                  Height = 13
                  Caption = #21152#36733#27169#26495#21578#35686#20869#23481#65306
                end
                object cbLoadModel: TcxLookupComboBox
                  Left = 128
                  Top = 8
                  Properties.DropDownListStyle = lsFixedList
                  Properties.KeyFieldNames = 'ModelID'
                  Properties.ListColumns = <
                    item
                      Caption = #27169#22359#21517#31216
                      FieldName = 'ModelName'
                    end>
                  Properties.ListSource = DSModelOnly
                  Properties.OnChange = cxLookupComboBox1PropertiesChange
                  TabOrder = 0
                  Width = 145
                end
              end
            end
            object gbParamEdit: TGroupBox
              Left = 511
              Top = 0
              Width = 128
              Height = 467
              Align = alRight
              Caption = #21442#25968#35774#32622
              TabOrder = 1
              object Label15: TLabel
                Left = 6
                Top = 25
                Width = 96
                Height = 13
                Margins.Bottom = 0
                Caption = #21578#35686#20135#29983#32047#35745#27425#65306
              end
              object Label18: TLabel
                Left = 6
                Top = 140
                Width = 87
                Height = 13
                Margins.Bottom = 0
                Caption = #21578#35686#20135#29983#26465#20214' '#65306
              end
              object Label19: TLabel
                Left = 37
                Top = 301
                Width = 88
                Height = 13
                Margins.Bottom = 0
                Caption = ' ('#26684#24335' @value=1)'
              end
              object Label20: TLabel
                Left = 6
                Top = 285
                Width = 84
                Height = 13
                Margins.Bottom = 0
                Caption = #21578#35686#25490#38500#26465#20214#65306
              end
              object Label21: TLabel
                Left = 37
                Top = 156
                Width = 88
                Height = 13
                Margins.Bottom = 0
                Caption = ' ('#26684#24335' @value=1)'
              end
              object Label22: TLabel
                Left = 6
                Top = 82
                Width = 96
                Height = 13
                Margins.Bottom = 0
                Caption = #21578#35686#25490#38500#32047#35745#27425#65306
              end
              object Label16: TLabel
                Left = 6
                Top = 422
                Width = 60
                Height = 13
                Caption = #26159#21542#26377#25928#65306
              end
              object cxDBMemo1: TcxDBMemo
                Left = 4
                Top = 181
                DataBinding.DataField = 'ALARMCONDITION'
                DataBinding.DataSource = DSModelContent
                TabOrder = 0
                Height = 89
                Width = 121
              end
              object cxDBMemo2: TcxDBMemo
                Left = 6
                Top = 323
                DataBinding.DataField = 'REMOVECONDITION'
                DataBinding.DataSource = DSModelContent
                TabOrder = 1
                Height = 89
                Width = 119
              end
              object cxDBSpinEdit1: TcxDBSpinEdit
                Left = 16
                Top = 50
                DataBinding.DataField = 'ALARMCOUNT'
                DataBinding.DataSource = DSModelContent
                Properties.AssignedValues.MinValue = True
                TabOrder = 2
                Width = 89
              end
              object cxDBSpinEdit2: TcxDBSpinEdit
                Left = 16
                Top = 107
                DataBinding.DataField = 'REMOVECOUNT'
                DataBinding.DataSource = DSModelContent
                Properties.AssignedValues.MinValue = True
                TabOrder = 3
                Width = 89
              end
              object cxComboBoxIsEffect: TcxComboBox
                Left = 6
                Top = 442
                Properties.DropDownListStyle = lsFixedList
                Properties.Items.Strings = (
                  #21542
                  #26159)
                Properties.OnChange = cxComboBoxIsEffectPropertiesChange
                TabOrder = 4
                Width = 119
              end
            end
          end
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 639
            Height = 68
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object Label13: TLabel
              Left = 8
              Top = 14
              Width = 60
              Height = 13
              Caption = #27169#26495#21517#31216#65306
            end
            object Label17: TLabel
              Left = 188
              Top = 14
              Width = 60
              Height = 13
              Caption = #27169#26495#31867#22411#65306
            end
            object btNew: TButton
              Left = 130
              Top = 38
              Width = 75
              Height = 25
              Caption = #21478#23384#27169#26495
              TabOrder = 0
              OnClick = btNewClick
            end
            object btSave: TButton
              Left = 211
              Top = 38
              Width = 75
              Height = 25
              Caption = #20445#23384#20462#25913
              TabOrder = 1
              OnClick = btSaveClick
            end
            object btNewType: TButton
              Left = 352
              Top = 9
              Width = 75
              Height = 25
              Caption = #26032#22686#31867#22411'...'
              TabOrder = 2
              OnClick = btNewTypeClick
            end
            object btDelete: TButton
              Left = 297
              Top = 37
              Width = 75
              Height = 25
              Caption = #21024#38500
              TabOrder = 3
              OnClick = btDeleteClick
            end
            object btAddModel: TButton
              Left = 49
              Top = 38
              Width = 75
              Height = 25
              Caption = #26032#22686#27169#26495
              TabOrder = 4
              OnClick = btAddModelClick
            end
            object btChangeType: TButton
              Left = 430
              Top = 9
              Width = 75
              Height = 25
              Caption = #20462#25913#31867#22411'...'
              TabOrder = 5
              OnClick = btChangeTypeClick
            end
            object cbModelType: TcxLookupComboBox
              Left = 250
              Top = 11
              Properties.DropDownListStyle = lsFixedList
              Properties.KeyFieldNames = 'ModelID'
              Properties.ListColumns = <
                item
                  Caption = #27169#26495#31867#22411
                  FieldName = 'ModelName'
                end>
              Properties.ListSource = DSModelType
              TabOrder = 6
              Width = 90
            end
            object eModelName: TcxTextEdit
              Left = 66
              Top = 11
              TabOrder = 7
              Text = 'eModelName'
              Width = 118
            end
          end
        end
      end
    end
  end
  object CDSModel: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 72
    Top = 96
  end
  object DSModel: TDataSource
    DataSet = CDSModel
    Left = 72
    Top = 152
  end
  object CDSModelContent: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 240
  end
  object DSModelContent: TDataSource
    DataSet = CDSModelContent
    Left = 368
    Top = 240
  end
  object CDSModelOnly: TClientDataSet
    Aggregates = <>
    Filter = 'parentmodelid<>0 and parentmodelid <> 1'
    Filtered = True
    Params = <>
    Left = 408
    Top = 96
  end
  object DSModelOnly: TDataSource
    DataSet = CDSModelOnly
    Left = 488
    Top = 96
  end
  object CDSDSAlarmKind: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 608
    Top = 216
  end
  object DSAlarmKind: TDataSource
    DataSet = CDSDSAlarmKind
    Left = 688
    Top = 216
  end
  object CDSModelType: TClientDataSet
    Aggregates = <>
    Filter = 'parentmodelid=1'
    Filtered = True
    Params = <>
    Left = 448
    Top = 24
  end
  object DSModelType: TDataSource
    DataSet = CDSModelType
    Left = 528
    Top = 24
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 488
    Top = 306
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 15725290
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      TextColor = clTeal
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      TextColor = clTeal
    end
    object cxStyle4: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle5: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle6: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 13886416
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TextColor = clPurple
    end
    object cxStyle7: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clBlack
    end
    object cxStyle8: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 8170097
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clWhite
    end
    object cxStyle9: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 11126946
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      TextColor = clBlack
    end
    object cxStyle10: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clGradientActiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsBold]
      TextColor = clGreen
    end
    object cxStyle11: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 6592345
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clWhite
    end
    object cxStyle13: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clGradientInactiveCaption
      TextColor = clBlack
    end
    object cxStyle12: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clBackground
      TextColor = clPurple
    end
    object cxStyle14: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clSilver
      TextColor = clPurple
    end
    object cxGridTableViewStyleSheet1: TcxGridTableViewStyleSheet
      Styles.Background = cxStyle1
      Styles.Content = cxStyle14
      Styles.ContentEven = cxStyle6
      BuiltIn = True
    end
    object cxGridTableViewStyleSheet2: TcxGridTableViewStyleSheet
      Styles.Background = cxStyle1
      BuiltIn = True
    end
    object cxGridTableViewStyleSheet3: TcxGridTableViewStyleSheet
      Styles.Background = cxStyle1
      Styles.Content = cxStyle10
      Styles.Inactive = cxStyle10
      Styles.Selection = cxStyle5
      BuiltIn = True
    end
  end
end
