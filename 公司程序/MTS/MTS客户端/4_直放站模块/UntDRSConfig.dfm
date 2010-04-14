object FrmDRSConfig: TFrmDRSConfig
  Left = 0
  Top = 0
  Caption = #31995#32479#37197#32622#31649#29702
  ClientHeight = 591
  ClientWidth = 906
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 906
    Height = 591
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 906
      Height = 122
      Align = alClient
      Caption = #30452#25918#31449#21015#34920
      TabOrder = 0
      object cxGridDRSList: TcxGrid
        Left = 2
        Top = 15
        Width = 902
        Height = 105
        Align = alClient
        TabOrder = 0
        object cxGridDBTVDRSList: TcxGridDBTableView
          OnMouseUp = cxGridDBTVDRSListMouseUp
          NavigatorButtons.ConfirmDelete = False
          OnCustomDrawCell = cxGridDBTVDRSListCustomDrawCell
          OnFocusedRecordChanged = cxGridDBTVDRSListFocusedRecordChanged
          DataController.DataSource = DSDRS
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
    object Panel3: TPanel
      Left = 0
      Top = 122
      Width = 906
      Height = 38
      Align = alBottom
      TabOrder = 1
      object Label1: TLabel
        Left = 32
        Top = 9
        Width = 72
        Height = 13
        Caption = #30452#25918#31449#31867#22411#65306
      end
      object btQuery: TButton
        Left = 416
        Top = 6
        Width = 75
        Height = 25
        Caption = #26597#35810
        TabOrder = 0
        OnClick = btQueryClick
      end
      object btManualActive: TButton
        Left = 544
        Top = 7
        Width = 75
        Height = 25
        Caption = #25163#21160#28608#27963
        TabOrder = 1
        OnClick = btManualActiveClick
      end
      object btAutoActive: TButton
        Left = 625
        Top = 6
        Width = 75
        Height = 25
        Caption = #33258#21160#28608#27963
        TabOrder = 2
      end
      object btLock: TButton
        Left = 706
        Top = 6
        Width = 75
        Height = 25
        Caption = #38145#23450
        TabOrder = 3
        OnClick = btLockClick
      end
      object btClose: TButton
        Left = 793
        Top = 6
        Width = 75
        Height = 25
        Caption = #20851#38381
        TabOrder = 4
        OnClick = btCloseClick
      end
      object CbBDRS_TYPE: TComboBox
        Left = 110
        Top = 6
        Width = 115
        Height = 21
        ItemHeight = 13
        TabOrder = 5
        OnKeyPress = CbBDRS_TYPEKeyPress
      end
      object Edt_DRS_Info: TEdit
        Left = 231
        Top = 6
        Width = 170
        Height = 21
        Hint = #25353' '#32534#21495','#21517#31216','#22320#22336','#30005#35805#21495#30721' '#26597#35810
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
    end
    object pgDRSConfig: TPageControl
      Left = 0
      Top = 168
      Width = 906
      Height = 423
      ActivePage = tsDRSConfigParam
      Align = alBottom
      TabOrder = 2
      OnChange = pgDRSConfigChange
      object tsDRSConfigInfo: TTabSheet
        Caption = #22522#26412#36164#26009
      end
      object tsDRSConfigParam: TTabSheet
        Caption = #37197#32622#20449#24687
        ImageIndex = 1
      end
      object tsDRSConfigCom: TTabSheet
        Caption = #21629#20196#21015#34920
        ImageIndex = 2
      end
      object tsDRSConfigAlarm: TTabSheet
        Caption = #21578#35686#20449#24687
        ImageIndex = 3
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 0
      Top = 160
      Width = 906
      Height = 8
      HotZoneClassName = 'TcxMediaPlayer8Style'
      HotZone.SizePercent = 100
      AlignSplitter = salBottom
      Control = pgDRSConfig
    end
  end
  object DSDRS: TDataSource
    DataSet = CDSDRS
    Left = 480
    Top = 80
  end
  object CDSDRS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 544
    Top = 80
  end
end
