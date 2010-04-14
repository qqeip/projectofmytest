object FormDRSRoundSearch: TFormDRSRoundSearch
  Left = 0
  Top = 0
  Caption = #30452#25918#31449#36718#35810
  ClientHeight = 498
  ClientWidth = 722
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 722
    Height = 498
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = #36718#35810#37197#32622
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 714
        Height = 211
        Align = alClient
        Caption = #30452#25918#31449#21015#34920
        TabOrder = 0
        object cxGridDRSList: TcxGrid
          Left = 2
          Top = 14
          Width = 710
          Height = 195
          Align = alClient
          TabOrder = 0
          object cxGridDBTVDRSList: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            OnCellClick = cxGridDBTVDRSListCellClick
            DataController.DataSource = DataSource1
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsView.GroupByBox = False
          end
          object cxGridDRSListLevel1: TcxGridLevel
            GridView = cxGridDBTVDRSList
          end
        end
      end
      object PageControl2: TPageControl
        Left = 0
        Top = 249
        Width = 714
        Height = 222
        ActivePage = TabSheet3
        Align = alBottom
        TabOrder = 1
        object TabSheet3: TTabSheet
          Caption = #21442#25968#35774#32622
          object Label2: TLabel
            Left = 20
            Top = 55
            Width = 72
            Height = 12
            Caption = #36718#35810#24320#22987#26102#38388
          end
          object Label3: TLabel
            Left = 20
            Top = 89
            Width = 72
            Height = 12
            Caption = #36718#35810#32467#26463#26102#38388
          end
          object Label4: TLabel
            Left = 20
            Top = 123
            Width = 48
            Height = 12
            Caption = #36718#35810#27425#25968
          end
          object Label5: TLabel
            Left = 20
            Top = 157
            Width = 48
            Height = 12
            Caption = #36718#35810#38388#38548
          end
          object Label11: TLabel
            Left = 206
            Top = 159
            Width = 36
            Height = 12
            Caption = '('#20998#38047')'
          end
          object ComboBoxCommand: TComboBox
            Left = 20
            Top = 17
            Width = 241
            Height = 20
            Style = csDropDownList
            ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            ItemHeight = 12
            TabOrder = 0
            OnChange = ComboBoxCommandChange
          end
          object ButtonSend: TButton
            Left = 304
            Top = 15
            Width = 113
            Height = 25
            Caption = #21457#36865#36718#35810#20219#21153
            TabOrder = 1
            OnClick = ButtonSendClick
          end
          object SpinEditInterval: TSpinEdit
            Left = 116
            Top = 154
            Width = 86
            Height = 21
            MaxValue = 999999
            MinValue = 5
            TabOrder = 2
            Value = 60
          end
          object DateTimePicker1: TDateTimePicker
            Left = 116
            Top = 51
            Width = 86
            Height = 20
            Date = 40213.380067627320000000
            Format = 'HH:mm'
            Time = 40213.380067627320000000
            ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            Kind = dtkTime
            TabOrder = 3
          end
          object DateTimePicker2: TDateTimePicker
            Left = 116
            Top = 86
            Width = 86
            Height = 20
            Date = 40213.380067627320000000
            Format = 'HH:mm'
            Time = 40213.380067627320000000
            ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            Kind = dtkTime
            TabOrder = 4
          end
          object SpinEditCounts: TSpinEdit
            Left = 116
            Top = 120
            Width = 86
            Height = 21
            MaxValue = 999999
            MinValue = 0
            TabOrder = 5
            Value = 1
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 211
        Width = 714
        Height = 38
        Align = alBottom
        TabOrder = 2
        object Label1: TLabel
          Left = 24
          Top = 13
          Width = 72
          Height = 12
          Caption = #30452#25918#31449#31867#22411#65306
        end
        object ButtonQuery: TButton
          Left = 416
          Top = 7
          Width = 75
          Height = 25
          Caption = #26597#35810
          TabOrder = 0
          OnClick = ButtonQueryClick
        end
        object EditSearch: TEdit
          Left = 244
          Top = 9
          Width = 113
          Height = 20
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          TabOrder = 1
        end
        object ComboBoxDRSTYPE: TComboBox
          Left = 120
          Top = 9
          Width = 113
          Height = 20
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ItemHeight = 12
          TabOrder = 2
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #36718#35810#21015#34920
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 714
        Height = 211
        Align = alClient
        Caption = #36718#35810#20219#21153#21015#34920
        TabOrder = 0
        object cxGridTaskList: TcxGrid
          Left = 2
          Top = 14
          Width = 710
          Height = 195
          Align = alClient
          TabOrder = 0
          object cxGridTaskListDBTableView1: TcxGridDBTableView
            NavigatorButtons.ConfirmDelete = False
            OnCellClick = cxGridTaskListDBTableView1CellClick
            OnFocusedRecordChanged = cxGridTaskListDBTableView1FocusedRecordChanged
            DataController.DataSource = DataSource2
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsView.GroupByBox = False
          end
          object cxGridTaskListLevel1: TcxGridLevel
            GridView = cxGridTaskListDBTableView1
          end
        end
      end
      object PageControl3: TPageControl
        Left = 0
        Top = 249
        Width = 714
        Height = 222
        ActivePage = TabSheet4
        Align = alBottom
        TabOrder = 1
        object TabSheet4: TTabSheet
          Caption = #21442#25968#35774#32622
          object Label6: TLabel
            Left = 20
            Top = 55
            Width = 72
            Height = 12
            Caption = #36718#35810#24320#22987#26102#38388
          end
          object Label7: TLabel
            Left = 20
            Top = 89
            Width = 72
            Height = 12
            Caption = #36718#35810#32467#26463#26102#38388
          end
          object Label8: TLabel
            Left = 20
            Top = 123
            Width = 48
            Height = 12
            Caption = #36718#35810#27425#25968
          end
          object Label9: TLabel
            Left = 20
            Top = 157
            Width = 48
            Height = 12
            Caption = #36718#35810#38388#38548
          end
          object Label12: TLabel
            Left = 206
            Top = 159
            Width = 36
            Height = 12
            Caption = '('#20998#38047')'
          end
          object SpinEditInterval1: TSpinEdit
            Left = 116
            Top = 154
            Width = 86
            Height = 21
            MaxValue = 999999
            MinValue = 5
            TabOrder = 0
            Value = 60
          end
          object DateTimePicker3: TDateTimePicker
            Left = 116
            Top = 51
            Width = 86
            Height = 20
            Date = 40213.380067627320000000
            Format = 'HH:mm'
            Time = 40213.380067627320000000
            ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            Kind = dtkTime
            TabOrder = 1
          end
          object DateTimePicker4: TDateTimePicker
            Left = 116
            Top = 86
            Width = 86
            Height = 20
            Date = 40213.380067627320000000
            Format = 'HH:mm'
            Time = 40213.380067627320000000
            ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
            Kind = dtkTime
            TabOrder = 2
          end
          object SpinEditCounts1: TSpinEdit
            Left = 116
            Top = 120
            Width = 86
            Height = 21
            MaxValue = 999999
            MinValue = 0
            TabOrder = 3
            Value = 1
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 211
        Width = 714
        Height = 38
        Align = alBottom
        TabOrder = 2
        object Label10: TLabel
          Left = 24
          Top = 13
          Width = 72
          Height = 12
          Caption = #30452#25918#31449#31867#22411#65306
        end
        object ButtonQuery1: TButton
          Left = 392
          Top = 6
          Width = 57
          Height = 25
          Caption = #26597#35810
          TabOrder = 0
          OnClick = ButtonQueryClick
        end
        object EditSearch1: TEdit
          Left = 244
          Top = 9
          Width = 113
          Height = 20
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          TabOrder = 1
        end
        object ComboBoxDRSTYPE1: TComboBox
          Left = 120
          Top = 9
          Width = 113
          Height = 20
          ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ItemHeight = 12
          TabOrder = 2
        end
        object Button2: TButton
          Left = 453
          Top = 6
          Width = 57
          Height = 25
          Caption = #20462#25913
          TabOrder = 3
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 514
          Top = 6
          Width = 57
          Height = 25
          Caption = #26242#20572
          TabOrder = 4
          OnClick = Button3Click
        end
        object Button4: TButton
          Left = 575
          Top = 6
          Width = 57
          Height = 25
          Caption = #32487#32493
          TabOrder = 5
          OnClick = Button4Click
        end
        object Button5: TButton
          Left = 637
          Top = 6
          Width = 57
          Height = 25
          Caption = #21024#38500
          TabOrder = 6
          OnClick = Button5Click
        end
      end
    end
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 512
    Top = 80
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 480
    Top = 80
  end
  object ClientDataSet2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 584
    Top = 80
  end
  object DataSource2: TDataSource
    DataSet = ClientDataSet2
    Left = 552
    Top = 80
  end
  object ClientDataSetDym: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 88
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 360
    Top = 192
  end
end
