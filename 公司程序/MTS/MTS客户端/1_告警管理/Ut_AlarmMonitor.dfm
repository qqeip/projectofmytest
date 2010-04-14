object Fm_AlarmMonitor: TFm_AlarmMonitor
  Left = 183
  Top = 38
  Caption = #21578#35686#30417#25511#31383#21475
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
  Position = poDesigned
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 808
    Height = 562
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object p_gis: TPanel
      Left = 0
      Top = 0
      Width = 808
      Height = 200
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object ToolBar1: TToolBar
        Left = 0
        Top = 165
        Width = 808
        Height = 35
        Align = alBottom
        BorderWidth = 1
        ButtonHeight = 25
        ButtonWidth = 30
        Caption = 'ToolBar1'
        EdgeBorders = [ebLeft, ebTop, ebBottom]
        Images = MapBarImageList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        object TB_zoomout: TToolButton
          Left = 0
          Top = 0
          Hint = #25918#22823
          Caption = #25918#22823
          ImageIndex = 0
          OnClick = TB_zoomoutClick
        end
        object TB_zoomin: TToolButton
          Left = 30
          Top = 0
          Hint = #32553#23567
          Caption = #32553#23567
          ImageIndex = 1
          OnClick = TB_zoominClick
        end
        object TB_pan: TToolButton
          Left = 60
          Top = 0
          Hint = #28459#28216
          Caption = #28459#28216
          ImageIndex = 2
          OnClick = TB_panClick
        end
        object TB_showinfo: TToolButton
          Left = 90
          Top = 0
          Hint = #26174#31034#20449#24687
          Caption = #26174#31034#20449#24687
          ImageIndex = 10
          OnClick = TB_showinfoClick
        end
        object TB_locate: TToolButton
          Left = 120
          Top = 0
          Hint = #23450#20301#23460#20998#28857
          Caption = #23450#20301#23460#20998#28857
          ImageIndex = 31
          OnClick = TB_locateClick
        end
        object ToolButton2: TToolButton
          Left = 150
          Top = 0
          Hint = #22270#23618#25511#21046
          Caption = #22270#23618#25511#21046
          ImageIndex = 5
          OnClick = ToolButton2Click
        end
        object ToolButton6: TToolButton
          Left = 180
          Top = 0
          Hint = #27979#36317
          Caption = #27979#36317
          ImageIndex = 7
          OnClick = ToolButton6Click
        end
        object TB_refresh: TToolButton
          Left = 210
          Top = 0
          Hint = #38754#31215
          Caption = #38754#31215
          ImageIndex = 6
          OnClick = TB_refreshClick
        end
        object ToolButton3: TToolButton
          Left = 240
          Top = 0
          Hint = #28165#38500
          Caption = #28165#38500
          ImageIndex = 8
          OnClick = ToolButton3Click
        end
        object ToolButton1: TToolButton
          Left = 270
          Top = 0
          Hint = #23460#20998#28857#26679#24335#35774#32622
          Caption = #23460#20998#28857#26679#24335
          ImageIndex = 12
          OnClick = ToolButton1Click
        end
        object tb_csShow: TToolButton
          Left = 300
          Top = 0
          Hint = #38544#34255#23460#20998#28857
          Caption = 'tb_csShow'
          ImageIndex = 16
          OnClick = tb_csShowClick
        end
        object ToolButton5: TToolButton
          Left = 330
          Top = 0
          Hint = #23460#20998#28857#20449#24687
          Caption = 'ToolButton5'
          ImageIndex = 28
          OnClick = ToolButton5Click
        end
        object ToolButton9: TToolButton
          Left = 360
          Top = 0
          Hint = 'MTU'#21382#21490#21578#35686
          Caption = 'MTU'#21382#21490#21578#35686
          ImageIndex = 33
          OnClick = ToolButton9Click
        end
        object ToolButton12: TToolButton
          Left = 390
          Top = 0
          Hint = #20445#23384#35270#36317
          Caption = #20445#23384#35270#36317
          ImageIndex = 14
          OnClick = ToolButton12Click
        end
      end
    end
    object pGrid: TPanel
      Left = 0
      Top = 209
      Width = 808
      Height = 353
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 808
        Height = 207
        Align = alClient
        TabOrder = 0
        RootLevelOptions.DetailTabsPosition = dtpTop
        object Tv_MAlarm: TcxGridDBTableView
          PopupMenu = PopupMenu1
          OnMouseDown = Tv_MAlarmMouseDown
          NavigatorButtons.ConfirmDelete = False
          OnCustomDrawCell = Tv_MAlarmCustomDrawCell
          OnFocusedRecordChanged = Tv_MAlarmFocusedRecordChanged
          DataController.DataSource = DS_Master
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
            end>
          DataController.Summary.SummaryGroups = <>
          DataController.OnDetailExpanding = Tv_MAlarmDataControllerDetailExpanding
          OptionsData.Editing = False
          OptionsSelection.MultiSelect = True
          Styles.Content = cxStyle4
          Styles.ContentEven = cxStyle6
          Styles.Selection = cxStyle11
          Styles.Group = cxStyle5
          Styles.GroupByBox = cxStyle13
          Styles.Header = cxStyle13
          Styles.StyleSheet = cxGridTableViewStyleSheet1
          object v_MAlarmColumn20: TcxGridDBColumn
            Caption = #36873#25321#26694
            DataBinding.FieldName = 'isChecked'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.Alignment = taCenter
            Properties.ValueChecked = 'Y'
            Properties.ValueGrayed = 'UNABLED'
            Properties.ValueUnchecked = 'N'
            MinWidth = 27
            Options.Filtering = False
            Options.FilteringFilteredItemsList = False
            Options.FilteringMRUItemsList = False
            Options.FilteringPopup = False
            Options.FilteringPopupMultiSelect = False
            Options.IgnoreTimeForFiltering = False
            Options.IncSearch = False
            Options.GroupFooters = False
            Options.Grouping = False
            Options.HorzSizing = False
            Options.Moving = False
            Options.Sorting = False
            Width = 27
          end
          object v_MAlarmColumn1: TcxGridDBColumn
            Caption = #21578#35686#32534#21495
            DataBinding.FieldName = 'alarmid'
          end
          object v_MAlarmColumn2: TcxGridDBColumn
            Caption = #21578#35686#20869#23481
            DataBinding.FieldName = 'alarmcontentname'
          end
          object v_MAlarmColumn9: TcxGridDBColumn
            Caption = #21578#35686#31867#22411
            DataBinding.FieldName = 'alarmkindname'
          end
          object v_MAlarmColumn10: TcxGridDBColumn
            Caption = #21578#35686#31561#32423
            DataBinding.FieldName = 'alarmlevelname'
          end
          object v_MAlarmColumn14: TcxGridDBColumn
            Caption = #27966#38556#26102#38388
            DataBinding.FieldName = 'sendtime'
          end
          object v_MAlarmColumn19: TcxGridDBColumn
            Caption = #21040#26399#26102#38480
            DataBinding.FieldName = 'limithour'
          end
          object v_MAlarmColumn3: TcxGridDBColumn
            Caption = 'MTU'#21517#31216
            DataBinding.FieldName = 'mtuname'
          end
          object v_MAlarmColumn16: TcxGridDBColumn
            Caption = 'MTU'#32534#21495
            DataBinding.FieldName = 'MTUNO'
          end
          object v_MAlarmColumn11: TcxGridDBColumn
            Caption = 'MTU'#20301#32622
            DataBinding.FieldName = 'mtuaddr'
          end
          object v_MAlarmColumn12: TcxGridDBColumn
            Caption = 'PHS'#21495#30721
            DataBinding.FieldName = 'call'
          end
          object v_MAlarmColumn4: TcxGridDBColumn
            Caption = #20219#21153#21495
            DataBinding.FieldName = 'taskid'
            Visible = False
          end
          object v_MAlarmColumn5: TcxGridDBColumn
            Caption = #21578#35686#32047#35745#27425#25968
            DataBinding.FieldName = 'alarmcount'
            Width = 85
          end
          object v_MAlarmColumn15: TcxGridDBColumn
            Caption = #35206#30422#33539#22260
            DataBinding.FieldName = 'overlay'
          end
          object v_MAlarmColumn6: TcxGridDBColumn
            Caption = #23460#20998#28857#21517#31216
            DataBinding.FieldName = 'buildingname'
          end
          object v_MAlarmColumn13: TcxGridDBColumn
            Caption = #23460#20998#28857#22320#22336
            DataBinding.FieldName = 'address'
          end
          object v_MAlarmColumn7: TcxGridDBColumn
            Caption = #37066#21439
            DataBinding.FieldName = 'areaname'
          end
          object v_MAlarmColumn8: TcxGridDBColumn
            Caption = #22320#24066
            DataBinding.FieldName = 'cityname'
          end
          object v_MAlarmColumn17: TcxGridDBColumn
            Caption = #26159#21542#24050#38405
            DataBinding.FieldName = 'readed'
            Visible = False
          end
          object v_MAlarmColumn18: TcxGridDBColumn
            Caption = #21578#35686#29366#24577
            DataBinding.FieldName = 'flowtache'
            Visible = False
          end
        end
        object Tv_DAlarm: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          NavigatorButtons.First.Visible = True
          NavigatorButtons.PriorPage.Visible = True
          NavigatorButtons.Prior.Visible = True
          NavigatorButtons.Next.Visible = True
          NavigatorButtons.NextPage.Visible = True
          NavigatorButtons.Last.Visible = True
          NavigatorButtons.Insert.Visible = True
          NavigatorButtons.Append.Visible = False
          NavigatorButtons.Delete.Visible = True
          NavigatorButtons.Edit.Visible = True
          NavigatorButtons.Post.Visible = True
          NavigatorButtons.Cancel.Visible = True
          NavigatorButtons.Refresh.Visible = True
          NavigatorButtons.SaveBookmark.Visible = True
          NavigatorButtons.GotoBookmark.Visible = True
          NavigatorButtons.Filter.Visible = True
          OnCustomDrawCell = Tv_DAlarmCustomDrawCell
          DataController.DataSource = DS_Detail
          DataController.DetailKeyFieldNames = 'alarmid'
          DataController.MasterKeyFieldNames = 'alarmid'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Editing = False
          OptionsView.GroupByBox = False
          Styles.StyleSheet = cxGridTableViewStyleSheet1
        end
        object Tv_HMAlarm: TcxGridDBTableView
          PopupMenu = PopupMenu2
          OnMouseDown = Tv_HMAlarmMouseDown
          NavigatorButtons.ConfirmDelete = False
          NavigatorButtons.First.Visible = True
          NavigatorButtons.PriorPage.Visible = True
          NavigatorButtons.Prior.Visible = True
          NavigatorButtons.Next.Visible = True
          NavigatorButtons.NextPage.Visible = True
          NavigatorButtons.Last.Visible = True
          NavigatorButtons.Insert.Visible = True
          NavigatorButtons.Append.Visible = False
          NavigatorButtons.Delete.Visible = True
          NavigatorButtons.Edit.Visible = True
          NavigatorButtons.Post.Visible = True
          NavigatorButtons.Cancel.Visible = True
          NavigatorButtons.Refresh.Visible = True
          NavigatorButtons.SaveBookmark.Visible = True
          NavigatorButtons.GotoBookmark.Visible = True
          NavigatorButtons.Filter.Visible = True
          OnCustomDrawCell = Tv_HMAlarmCustomDrawCell
          DataController.DataSource = DS_HMaster
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          DataController.OnDetailExpanding = Tv_HMAlarmDataControllerDetailExpanding
          OptionsData.Editing = False
          Styles.Content = cxStyle4
          Styles.ContentEven = cxStyle6
          Styles.Selection = cxStyle11
          Styles.Group = cxStyle5
          Styles.GroupByBox = cxStyle13
          Styles.Header = cxStyle13
          Styles.StyleSheet = cxGridTableViewStyleSheet1
          object v_HMAlarmColumn20: TcxGridDBColumn
            Caption = #36873#25321#26694
            DataBinding.FieldName = 'isChecked'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.Alignment = taCenter
            Properties.ValueChecked = 'Y'
            Properties.ValueGrayed = 'UNABLED'
            Properties.ValueUnchecked = 'N'
            MinWidth = 27
            Options.Filtering = False
            Options.FilteringFilteredItemsList = False
            Options.FilteringMRUItemsList = False
            Options.FilteringPopup = False
            Options.FilteringPopupMultiSelect = False
            Options.IgnoreTimeForFiltering = False
            Options.IncSearch = False
            Options.GroupFooters = False
            Options.Grouping = False
            Options.HorzSizing = False
            Options.Moving = False
            Width = 27
          end
          object v_HMAlarmColumn1: TcxGridDBColumn
            Caption = #21578#35686#32534#21495
            DataBinding.FieldName = 'alarmid'
          end
          object v_HMAlarmColumn2: TcxGridDBColumn
            Caption = #21578#35686#20869#23481
            DataBinding.FieldName = 'alarmcontentname'
          end
          object v_HMAlarmColumn9: TcxGridDBColumn
            Caption = #21578#35686#31867#22411
            DataBinding.FieldName = 'alarmkindname'
          end
          object v_HMAlarmColumn10: TcxGridDBColumn
            Caption = #21578#35686#31561#32423
            DataBinding.FieldName = 'alarmlevelname'
          end
          object v_HMAlarmColumn14: TcxGridDBColumn
            Caption = #27966#38556#26102#38388
            DataBinding.FieldName = 'sendtime'
          end
          object v_HMAlarmColumn15: TcxGridDBColumn
            Caption = #25490#38556#26102#38388
            DataBinding.FieldName = 'removetime'
          end
          object v_HMAlarmColumn19: TcxGridDBColumn
            Caption = #21040#26399#26102#38480
            DataBinding.FieldName = 'limithour'
          end
          object v_HMAlarmColumn16: TcxGridDBColumn
            Caption = ' '#35206#30422#33539#22260
            DataBinding.FieldName = 'overlay'
          end
          object v_HMAlarmColumn3: TcxGridDBColumn
            Caption = 'MTU'#21517#31216
            DataBinding.FieldName = 'mtuname'
          end
          object v_HMAlarmColumn11: TcxGridDBColumn
            Caption = 'MTU'#20301#32622
            DataBinding.FieldName = 'mtuaddr'
          end
          object v_HMAlarmColumn12: TcxGridDBColumn
            Caption = 'PHS'#21495#30721
            DataBinding.FieldName = 'call'
          end
          object v_HMAlarmColumn4: TcxGridDBColumn
            Caption = #20219#21153#21495
            DataBinding.FieldName = 'taskid'
            Visible = False
          end
          object v_HMAlarmColumn5: TcxGridDBColumn
            Caption = #21578#35686#32047#35745#27425#25968
            DataBinding.FieldName = 'alarmcount'
            Width = 85
          end
          object v_HMAlarmColumn6: TcxGridDBColumn
            Caption = #23460#20998#28857#21517#31216
            DataBinding.FieldName = 'buildingname'
          end
          object v_HMAlarmColumn13: TcxGridDBColumn
            Caption = #23460#20998#28857#22320#22336
            DataBinding.FieldName = 'address'
          end
          object v_HMAlarmColumn7: TcxGridDBColumn
            Caption = #37066#21439
            DataBinding.FieldName = 'areaname'
          end
          object v_HMAlarmColumn8: TcxGridDBColumn
            Caption = #22320#24066
            DataBinding.FieldName = 'cityname'
          end
          object v_HMAlarmColumn17: TcxGridDBColumn
            Caption = #26159#21542#24050#38405
            DataBinding.FieldName = 'readed'
            Visible = False
          end
          object v_HMAlarmColumn18: TcxGridDBColumn
            Caption = #21578#35686#29366#24577
            DataBinding.FieldName = 'flowtache'
          end
        end
        object Tv_HDAlarm: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          NavigatorButtons.First.Visible = True
          NavigatorButtons.PriorPage.Visible = True
          NavigatorButtons.Prior.Visible = True
          NavigatorButtons.Next.Visible = True
          NavigatorButtons.NextPage.Visible = True
          NavigatorButtons.Last.Visible = True
          NavigatorButtons.Insert.Visible = True
          NavigatorButtons.Append.Visible = False
          NavigatorButtons.Delete.Visible = True
          NavigatorButtons.Edit.Visible = True
          NavigatorButtons.Post.Visible = True
          NavigatorButtons.Cancel.Visible = True
          NavigatorButtons.Refresh.Visible = True
          NavigatorButtons.SaveBookmark.Visible = True
          NavigatorButtons.GotoBookmark.Visible = True
          NavigatorButtons.Filter.Visible = True
          DataController.DataSource = DS_HDetail
          DataController.DetailKeyFieldNames = 'alarmid'
          DataController.MasterKeyFieldNames = 'alarmid'
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Editing = False
          OptionsView.GroupByBox = False
          Styles.StyleSheet = cxGridTableViewStyleSheet1
        end
        object Lv_MAlarm: TcxGridLevel
          Caption = #22312#32447#21578#35686
          GridView = Tv_MAlarm
          object Lv_DAlarm: TcxGridLevel
            GridView = Tv_DAlarm
          end
        end
        object Lv_HMAlarm: TcxGridLevel
          Caption = #21382#21490#21578#35686
          GridView = Tv_HMAlarm
          object Lv_HDAlarm: TcxGridLevel
            GridView = Tv_HDAlarm
            Visible = False
          end
        end
      end
      object pShowHisrotyTop: TPanel
        Left = 0
        Top = 207
        Width = 808
        Height = 146
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object pShowHistory: TPanel
          Left = 0
          Top = 0
          Width = 808
          Height = 115
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object cxGrid1: TcxGrid
            Left = 0
            Top = 0
            Width = 808
            Height = 115
            Align = alClient
            TabOrder = 0
            object tvHis: TcxGridDBTableView
              NavigatorButtons.ConfirmDelete = False
              DataController.DataSource = DSHis
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsData.Deleting = False
              OptionsData.Editing = False
              OptionsData.Inserting = False
              OptionsView.GroupByBox = False
            end
            object cxGrid1Level1: TcxGridLevel
              GridView = tvHis
            end
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 115
          Width = 808
          Height = 31
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object Label2: TLabel
            Left = 335
            Top = 12
            Width = 72
            Height = 13
            Caption = #26465#21382#21490#21578#35686#65289
          end
          object Label1: TLabel
            Left = 241
            Top = 12
            Width = 36
            Height = 13
            Caption = #65288#26368#36817
          end
          object btClose: TButton
            Left = 522
            Top = 6
            Width = 75
            Height = 25
            Caption = #20851#38381
            TabOrder = 0
            OnClick = btCloseClick
          end
          object cbShowHistory: TCheckBox
            Left = 114
            Top = 10
            Width = 121
            Height = 17
            Caption = #26174#31034'MTU'#21382#21490#21578#35686
            TabOrder = 1
            OnClick = cbShowHistoryClick
          end
          object seCount: TcxSpinEdit
            Left = 283
            Top = 8
            Properties.MinValue = 1.000000000000000000
            TabOrder = 2
            Value = 10
            Width = 46
          end
        end
      end
    end
    object pControl: TPanel
      Left = 0
      Top = 200
      Width = 808
      Height = 9
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object Panel5: TPanel
        Left = 423
        Top = 0
        Width = 385
        Height = 9
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object cxSplitter2: TcxSplitter
          Left = 0
          Top = 1
          Width = 385
          Height = 8
          HotZoneClassName = 'TcxMediaPlayer9Style'
          AlignSplitter = salBottom
          PositionAfterOpen = 28
          MinSize = 100
          Control = pGrid
          OnBeforeOpen = cxSplitter2BeforeOpen
          OnBeforeClose = cxSplitter2BeforeClose
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 385
        Height = 9
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object cxSplitter1: TcxSplitter
          Left = 0
          Top = 0
          Width = 385
          Height = 8
          HotZoneClassName = 'TcxMediaPlayer9Style'
          AlignSplitter = salTop
          PositionAfterOpen = 28
          MinSize = 100
          Control = p_gis
          OnBeforeOpen = cxSplitter1BeforeOpen
          OnBeforeClose = cxSplitter1BeforeClose
        end
      end
    end
  end
  object DS_Master: TDataSource
    Left = 248
    Top = 264
  end
  object DS_Detail: TDataSource
    Left = 296
    Top = 264
  end
  object MapBarImageList: TImageList
    Left = 304
    Top = 192
    Bitmap = {
      494C010124002600040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000A0000000010020000000000000A0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000630000009400290094310000FF63000029000000000000006331
      2900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF632900FF632900FF63
      2900CE31000094FFFF00CEFFFF0029946300FF632900FF632900CE310000FF63
      2900FF63290000630000CEFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002931
      000029310000FF630000946363009400290029000000BDBDBD00CE9494009463
      6300290000009431000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE310000CE310000CE31
      0000CE31000063FFFF0094CECE0063FFFF0029946300CE310000CE310000CE31
      0000CE3100003942390094FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000003100000063
      0000007B0000FFCE00009463630094CECE009400290094636300CE9494002900
      0000FF630000CE00000094310000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF632900FF632900FF63
      290094FFFF0063FFFF0094FFFF0063FFFF00CE949400FF630000CE310000FF63
      2900FF63290000632900CEFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000310000006300000063
      000029CE0000FFCE00009463630094FFFF0094CECE0094002900940029009400
      2900940029009400290029310000000000000000000000000000000000000000
      000084848400000000000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF0000000000FF632900CE310000CE31
      000094FFFF0094FFFF00FFFFFF00CE310000FF630000FF632900CE3100000063
      63001821180094FFFF00CEFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000310000006300000094
      290000CE0000FFFF63009463630094FFFF0094FFFF0094CEFF00CE9494009494
      CE00CE9494002900000029000000943100000000000000000000000000000000
      0000C6C6C600C6C6C60084848400848484000000000000000000000000000000
      00000000000000000000000000000000000000000000CE3100000094940063CE
      CE000000000029632900CE310000CE310000CE310000CE310000CE31000094FF
      FF0063FFFF0063CECE0063CECE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE0000000094290000CE000094CE
      2900FFCE6300FFFF63009463630094FFFF0094CECE00CE9494009494CE00CE94
      940029002900006300000031000063000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840000000000000000000000
      0000000000000000000000000000000000000000000094FFFF00639494009431
      290063CECE00FF632900FF632900CE310000FF632900FF632900CE31000094FF
      FF00CEFFFF0063FFFF00CEFFFF00000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000000000000000000000
      00000000000000000000000000000000000063310000FFFF290063CE6300FFCE
      6300FFCE630094FFFF009463630094FFFF0094CEFF009494CE00CE9494002900
      2900007B00000063290000310000630000000000000084848400C6C6C600C6C6
      C60084848400C6C6C600FFFFFF00C6C6C6008484840084848400000000000000
      00000000000000000000000000000000000000000000CEFFFF002994940063CE
      CE00CE310000CE630000FF632900CE310000FF632900FF632900CE3100009494
      940094FFFF0094CECE0094312900000000000000000000000000000000000000
      000000000000000084000000FF00000084000000FF0000008400000000000000
      00000000000000000000000000000000000094630000FFFF940063FFFF00FFCE
      0000FFCE000094FFFF009463630094FFFF009494CE00CE9494002900000029CE
      0000009400000063000000632900630000000000000000000000C6C6C6008484
      8400C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C60084848400848484000000
      0000000000000000000000000000000000000000000063CECE0094FFCE0094FF
      FF0029CECE0018211800CE310000CE310000CE310000CE310000CE31000094FF
      FF000031290000000000CE310000000000000000000000000000000000000000
      000000000000000084000000FF000000FF000000840000008400000000000000
      000000000000000000000000000000000000CE942900FFCE0000FFFF940029FF
      FF0000CEFF0063FFFF00946363009494CE00CE94940029002900FFCE630000CE
      000000CE0000007B00000063000063000000000000000000000000000000FFFF
      FF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600848484008484
      8400000000000000000000000000000000000000000094FFFF0063CEFF00CEFF
      FF0094FFFF0094FFFF0063636300CE310000FF632900FF632900CE310000CE00
      000063FFFF0094FFFF00CEFFFF00000000000000000000000000000000000000
      00000000000000008400000000000000FF000000FF0000008400000000000000
      0000000000000000000000000000000000006331000000CE0000FFCE000000CE
      FF0029FFFF0029FFFF0094636300CE9494002900000063FFCE00FFFF2900CEFF
      00009494000094942900CE312900CE0000000000000000000000000000000000
      0000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C6008484
      8400848484000000000000000000000000000000000063FFFF0094FFFF0094FF
      FF0094CECE0063FFFF0094CECE00CE310000FF632900FF632900CE31000063CE
      CE00ADB5AD0063CE940094FFFF00000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000000000000000000000
      0000000000000000000000000000000000006331000000CE000000CEFF00FFFF
      940029FFFF00CEFFFF00946363002900290094FFCE00FFCE0000CEFF0000FFCE
      6300FFCE0000CE946300CE312900943100000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600848484000000000000000000000000000000000094FFFF0000632900FF63
      290063FFFF0063949400CE31000000000000CE310000CE310000CE310000CE94
      63001821180063CEFF00CE310000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000094CE2900CECE940094FFFF0029FF
      FF0094FFFF00FFFFFF0029000000FFFFFF0063FFFF00CEFFFF00CEFFFF0094FF
      CE00299463000063000063000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C6000000000000000000000000000000000094FFFF0094FFFF001821
      180094FFCE0052525200FF63290063FFFF007B000000FF632900CE310000FF63
      0000FF63290063FFFF0063949400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000094CE2900FF630000FFFF
      940094FFFF0029FFFF00CEFFFF0000FFFF0094FFFF00FFCE0000FFCE63000094
      2900006329006300000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF000000000000000000000000000000000063FFFF0094FFCE006394
      CE00CE31000063FFFF00CE00000063FFFF0029CECE0000000000CE310000CE31
      0000CE3100002963630094FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE31290000CEFF0000FF
      FF00FFCE0000CEFFFF0000CEFF00FFCE000029FFFF0000FF630000CE00000031
      0000630000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000094CECE000000000094CE
      FF0063FFFF00FF6300001821180094FFFF0094FFFF00CEFFFF0029000000CE63
      0000FF632900CE310000CECECE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009494000000FFFF006331
      000094630000CEFFFF0000FF63009463000029946300CEFFFF0063942900CE00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094940000BDBD
      BD009494000063FFCE009494000063310000BDBDBD0094CE290094CE29000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000840000008400000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084000000FF000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084000000FF000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084000000FF000000848484000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008400000084000000840000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008400000084000000840000008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484008400000084000000840000008484840000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000C6C6C6000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000008400000084000000FFFF000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000008400000084000000FFFF000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000840000008400000084000000FFFF000084848400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000C6C6C6000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000084000000840000008400
      00008400000084840000FF000000848400008400000084000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      00008400000084840000FF000000848400008400000084000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      00008400000084840000FF000000848400008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000FF0000008400
      000084840000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000FF0000008400
      000084840000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000FF0000008400
      000084840000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000008400000084000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008400000084000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008400000084000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FFFF
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FFFF
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FFFF
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FF0000000000000000000000000000000000000084848400000000000000
      0000848484000000000000000000000000000000000000000000000000008400
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C600C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400008484000000
      0000000000000000000000000000C6C6C6000000000000848400000000000000
      00000000000000000000000000000000000000000000C6C6C600C6C6C600C6C6
      C600FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000848400008484000000
      0000000000000000000000000000C6C6C6000000000000848400000000000000
      00000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000C6C6C600FFFF
      FF00000000008484840084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000000000000848400000000000084
      84000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000008484840084848400000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000000000848484008484
      8400848484008484840084848400000000000000000000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000FFFFFF0000000000000000000000000000848400008484000084
      8400008484000084840000848400008484000084840000848400000000000084
      84000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00C6C6C600FFFF0000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF0000000000848484008484
      8400848484008484840084848400000000000000000000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000084840000848400000000000084
      84000000000000848400000000000000000000000000C6C6C600C6C6C600FFFF
      0000C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000084840000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000848400000000000084
      84000000000000848400000000000000000000000000C6C6C600C6C6C600C6C6
      C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000084840000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000848400000000000084
      84000000000000848400000000000000000000000000C6C6C600000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000848484008484
      840084848400848484008484840000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000000000FFFFFF000000000000000000000000000084840000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C6000000000000000000000000000084
      8400000000000084840000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C600000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      84008484840084848400848484000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000FFFFFF000000000000000000000000000084840000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C60000000000C6C6C600000000000084
      8400000000000084840000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C60000000000000000000000000000000000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000848484008484
      840084848400848484008484840000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000084
      840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000000000C6C6
      C600000000000084840000000000000000000000000000000000000000000000
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000084840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C60000000000C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000848400008484000084840000848400008484000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000008484000084
      8400008484000000000000848400008484000084840000848400008484000000
      0000008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000848400008484000084840000848400008484000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000008484000084
      8400008484000000000000848400008484000084840000848400008484000000
      0000008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000848400008484000084840000848400008484000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000008484000084
      8400008484000000000000848400008484000084840000848400008484000000
      0000008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000848400008484000084840000848400008484000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000008484000084
      8400008484000000000000848400008484000084840000848400008484000000
      0000008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00C6C6C600C6C6C60084848400000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00C6C6C600C6C6C60084848400000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000848400008484000084840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF00008484000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF000084840000FFFF000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF000084840000FFFF0000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF0000FFFF0000FFFF000084840000848400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00C6C6C600C6C6
      C600848484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00C6C6C600C6C6
      C600848484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD009494940031313100C6C6C6003131310094949400BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000084000000840000008400000000000000
      0000000000000000840000008400000084000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B0063636300949494000000000094949400636363007B7B
      7B000000000000000000000000000000000084848400FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000840000008400000084000000
      0000000084000000840000008400000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00C6C6C60000000000FFFFFF00C6C6
      C60000000000FFFFFF00FFFFFF00000000000000000000000000000000000084
      000000840000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B0063636300313131006363630031313100636363007B7B
      7B000000000000000000000000000000000084848400FFFFFF0000FFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF0000008400000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C6C600FFFFFF00FFFFFF00FFFFFF000000
      FF00C6C6C6000000FF00C6C6C600000000000000000000000000008400000084
      0000008400000084000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000000000000000000063636300C6C6C60063636300000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00C6C6C6000000000000000000000000000000000084848400000084000000
      8400000084000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF000000FF00C6C6C6000000
      FF00C6C6C6000000FF00FFFFFF00000000000000000000840000008400000084
      00000084000000840000008400000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000313131006363630031313100000000000000
      00000000000000000000000000000000000084848400FFFFFF0000FFFF00C6C6
      C60084000000FF00000084000000840000008484840000008400000084000000
      8400000084000000840000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000FF00C6C6C6000000FF00C6C6
      C6000000FF00C6C6C600FFFFFF00000000000000000000840000008400000084
      00000084000000840000008400000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000949494000000000094949400000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF008484
      8400FF000000FF00000000840000FF000000000084000000840000008400C6C6
      C60000008400000084000000840000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000008400000084
      0000008400000084000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B0000000000C6C6C600000000007B7B7B000000
      00000000000000000000000000000000000084848400FFFFFF0000FFFF008484
      0000C6C6C600848484000084000000008400000084000000840000FFFF00C6C6
      C60084848400000084000000840000008400000000000000FF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000084
      000000840000000000000000000000000000000000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B003131310000000000313131007B7B7B000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF008484
      0000FFFFFF00C6C6C60000840000840000000000840084000000FFFFFF00C6C6
      C60000000000000000000000840000000000000000000000FF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B003131310063636300313131007B7B7B000000
      00000000000000000000000000000000000084848400FFFFFF0000FFFF008484
      0000C6C6C60084840000FF00000084840000008400008484840000FFFF00C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000FFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848484000000FF000000FF000000FF000000FF00848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006363630000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00C6C6
      C6008484000084848400848400000084000084840000C6C6C600FFFFFF00C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000084000000FF000000FF000000FF000000FF00000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BDBDFF0000000000BDBDFF00000000006363630000000000BDBDFF000000
      0000BDBDFF0000000000000000000000000084848400FFFFFF0000FFFF00FFFF
      FF00C6C6C600848400008484000084840000C6C6C600FFFFFF0000FFFF00C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7BFF007B7BFF00000000007B7B7B00313131007B7B7B00000000007B7B
      FF007B7BFF0000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000084000000FF000000FF000000FF000000FF00000084000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7BFF007B7BFF0000000000000000000000000000000000000000007B7B
      FF007B7BFF0000000000000000000000000084848400FFFFFF0000FFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF00C6C6C600FFFFFF008484
      84000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000848484000000FF000000FF000000FF000000FF00848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7BFF00BDBDFF00BDBDFF00000000007B7B7B0000000000BDBDFF00BDBD
      FF007B7BFF0000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF0000FFFF00FFFFFF00FFFFFF00FFFFFF0000FFFF00C6C6C600848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6C6C600C6C6C60084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600848484008484840000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400C6C6C600C6C6
      C60084848400C6C6C600FFFFFF00C6C6C6008484840084848400000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000003131
      310031313100000000000000000000000000000000000000000000000000ADAD
      AD0000000000ADADAD0000000000000000000000000000000000C6C6C6008484
      8400C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C60084848400848484000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000393900219C9C000042
      4200004242002163630000424200004242000042420000424200004242002142
      420000848400215A5A000039390000000000000000000000000000000000FFFF
      FF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600848484008484
      8400000000000000000000000000000000000000000000000000008484000000
      000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000084840000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF000000000000000000397B7B0000FFFF0000BD
      BD0000BDBD0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00007B7B0000FFFF0000393900000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C6008484
      8400848484000000000000000000000000000000000000000000008484000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF000000000000848400000000000000000000000000000000000000000000FF
      FF000000000000FFFF0000FFFF00008484000084840000FFFF000084840000FF
      FF000084840000FFFF0000FFFF000000000000000000BDBDBD007B7B7B007B7B
      7B006363630094949400A5A5A500A5A5A500A5A5A500A5A5A500393939007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6
      C600848484000000000000000000000000000000000000000000008484000000
      000000FFFF00000000000000000000FFFF0000000000000000000000000000FF
      FF00000000000084840000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF00008484000084840000FFFF00008484000084
      84000084840000FFFF0000FFFF00000000000000000000000000000000000000
      0000BDBDBD00397B7B00007B7B00007B7B00007B7B00397B7B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6C600FFFF
      FF00C6C6C6000000000000000000000000000000000000000000008484000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000084840000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000000000009C9C9C009C9C9C0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00C6C6C600FFFFFF00C6C6
      C600FFFFFF000000000000000000000000000000000000000000008484000000
      000000FFFF00000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000008484000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008400000084
      0000008400000084000000840000008400000084000000840000008400000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      0000008400000084000000840000008400000084000000840000008400000084
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008400000084000000840000008400000084000000840000008400000084
      0000008400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      0000008400000084000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0084000000FFFFFF00FFFFFF00FFFFFF00840000008400000084000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000084
      8400008484000084840000000000000000000000000000000000FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C6000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF0000000000FFFFFF00C6C6C6000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF0084000000FFFFFF00FFFFFF00FFFFFF008400000084000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000C6C6C600FFFF
      FF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFFFF00C6C6
      C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF00C6C6C600FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000C6C6C600FFFF
      FF00C6C6C600FF000000FF000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000084000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FFFFFF000000000000000000000000000000
      0000848484000000000000000000000000000000000084848400000000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000084848400000000008400
      000084000000840000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FF000000FF00
      0000FF000000C6C6C600FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      000084000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008400
      00008400000084848400FFFFFF00000000000000000000000000000000008484
      840000000000000000000000000000000000FFFF000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000008484
      840000000000000000000000000000000000FFFF000000000000848484000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF0084000000C6C6C600FFFFFF000000FF000000FF008400
      000084000000FF000000FFFFFF00FFFFFF000000000084848400000000000000
      00000000000000000000000000000000000000000000FFFF0000000000000000
      0000848484000000000000000000000000000000000084848400000000000000
      00000000000000000000000000000000000000000000FFFF0000000000000000
      00008484840000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF00848484000000FF000000FF000000FF00C6C6
      C600FF000000FF000000FF000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000FF000000FF00C6C6
      C600FFFFFF00FFFFFF000000FF000000FF000000FF000000FF00C6C6C600FF00
      0000FF000000FF000000FF000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF0000000000FFFFFF000000FF000000FF00C6C6
      C600FFFFFF00FFFFFF00C6C6C6000000FF000000FF0084000000FF000000FF00
      0000FFFFFF00FF000000FF000000FFFFFF00000000000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF0000000000FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0084000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF0000000000FFFFFF00FFFFFF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000008484840000000000FFFF
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000084848400000000000000000000000000000000008484840000000000FFFF
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000084848400000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFF0000FFFFFF00FFFF0000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFF0000FFFFFF00FFFF0000000000000000000000000000848484000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF000000FF000000
      FF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      FF000000FF000000FF000000FF000000FF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000A00000000100010000000000000500000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFF82FFFFF8001FFFFE003FFFF
      8001EFEFC001FFFF8001DFF78001F0008001B7DB8000E07F8801AFEB0000C03F
      80016C6D0000801F800158350000800F800558350000C00780015A350000E003
      80016C6D0000F0038101AFEB0001F8038001B7DB8003FC038041DFF78007FE07
      A001EFEF800FFF0FFFFFFFFFC01FFFFFFFFFFFFFFFFFFFFFFFEFFFEFFFEF83E0
      FFDFFFDFFFDF83E0FF9FFF9FFF9F83E0F13FF13FF13F8080F07FF07FF07F8000
      F07FF07FF07F8000F03FF03FF03F8000803F803F803FC00183CF83FF83FFE083
      87CF87FF87EFE083C7CFC783C7EFF1C7E787E783E783F1C7FFB7FFFFFFEFF1C7
      FFB7FFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80FFFF801FF1FFFF808001
      001F81C3FF80800100078000F000800100078001F000800100018007F0008001
      00018007F000800100018007800780010001A007800780010001E00780078001
      0001E007800780010001E00780078001C001E03F80FF8001C001E3FF80FF8001
      F001FFFFFFFF8001F001FFFFFFFFFFFFFFFFFFFFFFFFFFFFF80FF80FF80FFFFD
      F80FF80FF80FF7FFF80FF80FF80FE3FBF80FF80FF80FE3F7F80FF80FF80FF1E7
      F80FF80FF80FF8CF800180018001FC1F800180018001FE3F800180018001FC3F
      800180018001F0CF800180018001E1E7800180018001E7F3800180018001FFFF
      800180018001FFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFEFFFFFFFFFEE1CFFDFF9F
      FFFFFE40EFF9FF9FFFFFEA00E000FF3FFC3FBE40F3E6F73FF81FFEC0F18EF27F
      F00F7FE1F81EF07FF00FFFBFF83EF00FF00FBFFFF87EF01FF00FFF7FF03EF03F
      F81F87FFE01EF07FFC3F037FC380F0FFFFFF03FF8447F1FFFFFF03AF8FE3F3FF
      FFFF03CFDFF1F7FFFFFF878FFFF9FFFFFFFFFF7DFFFFFFFFF80F1E38FC48E3E3
      F80F0311FC008181F80F0003FC008080FC1F0007FC008080FC1F00038C008080
      FC1F000100008181FC1F00000001C1C1FC1F00050003FC1FFC1F0007801FF81F
      FE3F0007F03FF80FF4170007F07FF80FF2270007E3FFF80FF367000FC7FFF81F
      F147001FCFFFFE3FFFFF003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFC001FFFFFFFF
      FFFF8001FFFFFFFFF0018001FFFFFFFFE07F8001BFFFFFFFC03F80017000FFFF
      801F80017000E7E3800F800160008001C0078001A0008001E003800180008003
      F0038001E000F03FF8038001E000FE7FFC038001F000FFFFFE078001F000FFFF
      FF0F8001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3FFFFFFFF001FFFF3FFFF
      F01F800FFF67FFFFFC3FC007FF078003FC3FE003FF0F8003FC3F00017D038003
      FC3F800080078003FC3FC007800F8003FC3FE003800F8003F83F0001800F8003
      FFFF800000078003FE7FC007800F8003FC3FE003800F8003FC3FF001800FFFFF
      FE7FF800800FFFFFFFFFFFFF7DF7FFFFFFFCFFFCF807F810FFF8FFF8F007F000
      FFF1FFF1E003F000F023F023C003F000E787E787C0018001CF4FCF4F80010000
      9CA79FA700010000BCD7BFD700000000B037B03790000000A037A037E0000000
      ACF7AFF7E000000F84E787E7C005803FC1CFC1CFC007803FE79FE79FE40F803F
      F03FF03FFE7F803FFFFFFFFFFFFFC07F00000000000000000000000000000000
      000000000000}
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 384
    Top = 322
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
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      TextColor = clBlack
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
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = [fsItalic]
      TextColor = 6592345
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
    object cxGridTableViewStyleSheet1: TcxGridTableViewStyleSheet
      BuiltIn = True
    end
  end
  object DS_HMaster: TDataSource
    Left = 272
    Top = 576
  end
  object DS_HDetail: TDataSource
    Left = 304
    Top = 608
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 440
    Top = 328
    object N_Export: TMenuItem
      Caption = #23548#20986
      OnClick = N_ExportClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object N_Shield: TMenuItem
      Caption = #23631#34109
      OnClick = N_ShieldClick
    end
    object N_CancelShield: TMenuItem
      Caption = #21462#28040#23631#34109
      OnClick = N_CancelShieldClick
    end
    object N_Readed: TMenuItem
      Caption = #24050#38405
      OnClick = N_ReadedClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N_SelectAll: TMenuItem
      Caption = #20840#36873
      OnClick = N_SelectAllClick
    end
  end
  object PopupMenu2: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 496
    Top = 320
    object N_Exproth: TMenuItem
      Caption = #23548#20986
      OnClick = N_ExportClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3_Del: TMenuItem
      Caption = #21024#38500
      OnClick = N3_DelClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N3_SelectAll: TMenuItem
      Caption = #20840#36873
      OnClick = N3_SelectAllClick
    end
  end
  object DSHis: TDataSource
    Left = 384
    Top = 448
  end
end
