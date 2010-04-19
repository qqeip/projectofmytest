object FormOutDepotMgr: TFormOutDepotMgr
  Left = 276
  Top = 166
  Width = 879
  Height = 581
  Caption = #20986#24211#31649#29702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object spl1: TSplitter
    Left = 0
    Top = 305
    Width = 871
    Height = 6
    Cursor = crVSplit
    Align = alTop
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 311
    Width = 871
    Height = 236
    Align = alClient
    Caption = #20986#24211#35814#32454#20449#24687
    TabOrder = 0
    object cxGridDepot: TcxGrid
      Left = 2
      Top = 15
      Width = 867
      Height = 219
      Align = alClient
      TabOrder = 0
      object cxGridDepotDBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DS1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridDepotLevel1: TcxGridLevel
        GridView = cxGridDepotDBTableView1
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 871
    Height = 169
    Align = alTop
    TabOrder = 1
    object GroupBox2: TGroupBox
      Left = 1
      Top = 1
      Width = 424
      Height = 167
      Align = alLeft
      Caption = #20986#24211
      TabOrder = 0
      object LabelBarCode: TLabel
        Left = 29
        Top = 19
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #26465#24418#32534#30721#65306
      end
      object LabelCustomerName: TLabel
        Left = 29
        Top = 89
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #23458#25143#21517#31216#65306
        Enabled = False
      end
      object LabelIntegral: TLabel
        Left = 221
        Top = 112
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #23458#25143#31215#20998#65306
        Enabled = False
      end
      object LabelAssociatorType: TLabel
        Left = 221
        Top = 89
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #20250#21592#31561#32423#65306
        Enabled = False
      end
      object BtnGoodsSearch: TSpeedButton
        Left = 221
        Top = 15
        Width = 35
        Height = 20
        Caption = #26597#25214
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = BtnGoodsSearchClick
      end
      object BtnCustomerSearch: TSpeedButton
        Left = 221
        Top = 62
        Width = 35
        Height = 20
        Caption = #26597#25214
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = BtnCustomerSearchClick
      end
      object BtnSubmit: TSpeedButton
        Left = 197
        Top = 136
        Width = 65
        Height = 22
        Hint = #25152#26377#21830#21697#25195#25551#36807#26465#24418#30721#21518#32467#31639#24635#37329#39069
        Caption = #32467#31639
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = BtnSubmitClick
      end
      object BtnCancel: TSpeedButton
        Left = 269
        Top = 136
        Width = 65
        Height = 22
        Caption = #21462#28040
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = BtnCancelClick
      end
      object Btn1: TSpeedButton
        Left = 341
        Top = 136
        Width = 65
        Height = 22
        Caption = #25171#21360
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = Btn1Click
      end
      object LabelDiscount: TLabel
        Left = 29
        Top = 112
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #20139#21463#25240#25187#65306
      end
      object LabelCustomerID: TLabel
        Left = 29
        Top = 66
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #23458#25143#32534#21495#65306
      end
      object LabelOutDepotType: TLabel
        Left = 29
        Top = 42
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #20986#24211#31867#22411#65306
      end
      object LabelOutDepotNum: TLabel
        Left = 221
        Top = 42
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #20986#24211#25968#37327#65306
      end
      object EdtCustomerName: TEdit
        Left = 93
        Top = 86
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 1
      end
      object EdtBarCode: TEdit
        Left = 93
        Top = 16
        Width = 120
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        OnKeyDown = EdtBarCodeKeyDown
      end
      object EdtIntegral: TEdit
        Left = 285
        Top = 109
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 2
      end
      object EdtDiscount: TEdit
        Left = 93
        Top = 109
        Width = 120
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 3
        Text = '100'
        OnKeyPress = EdtDiscountKeyPress
      end
      object EdtCustomerID: TEdit
        Left = 93
        Top = 63
        Width = 120
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        OnKeyDown = EdtCustomerIDKeyDown
      end
      object EdtAssociatorType: TEdit
        Left = 285
        Top = 86
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 5
      end
      object CbbOutDepotType: TComboBox
        Left = 93
        Top = 39
        Width = 120
        Height = 21
        ItemHeight = 13
        TabOrder = 6
      end
      object EdtOutDepotNum: TEdit
        Left = 285
        Top = 39
        Width = 120
        Height = 19
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 7
        Text = '1'
        OnKeyDown = EdtOutDepotNumKeyDown
      end
    end
    object GroupBox3: TGroupBox
      Left = 425
      Top = 1
      Width = 445
      Height = 167
      Align = alClient
      Caption = #21830#21697#20449#24687
      TabOrder = 1
      object LabelGoodsID1: TLabel
        Left = 8
        Top = 23
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #21830#21697#32534#21495#65306
        Enabled = False
      end
      object LabelGoodsName1: TLabel
        Left = 8
        Top = 47
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #21830#21697#21517#31216#65306
        Enabled = False
      end
      object LabelDepotName: TLabel
        Left = 200
        Top = 47
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #25152#23646#24211#23384#65306
        Enabled = False
      end
      object LabelProvider: TLabel
        Left = 8
        Top = 71
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #20379' '#36135' '#21830#65306
        Enabled = False
      end
      object LabelConst: TLabel
        Left = 200
        Top = 71
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #38144#21806#21333#20215#65306
        Enabled = False
      end
      object LabelGoodsType: TLabel
        Left = 200
        Top = 23
        Width = 65
        Height = 13
        AutoSize = False
        Caption = #21830#21697#31867#21035#65306
        Enabled = False
      end
      object EdtGoodsID: TEdit
        Left = 72
        Top = 20
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 0
      end
      object EdtGoodsName: TEdit
        Left = 72
        Top = 44
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 1
      end
      object EdtDepotName: TEdit
        Left = 264
        Top = 44
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 2
      end
      object EdtProvider: TEdit
        Left = 72
        Top = 68
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 3
      end
      object EdtCostPrice: TEdit
        Left = 264
        Top = 68
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 4
      end
      object EdtGoodsType: TEdit
        Left = 264
        Top = 20
        Width = 120
        Height = 19
        Ctl3D = False
        Enabled = False
        ParentCtl3D = False
        TabOrder = 5
      end
    end
  end
  object grp1: TGroupBox
    Left = 0
    Top = 169
    Width = 871
    Height = 136
    Align = alTop
    Caption = #20986#24211#21382#21490#35760#24405
    TabOrder = 2
    object cxGrid1: TcxGrid
      Left = 2
      Top = 15
      Width = 867
      Height = 119
      Align = alClient
      TabOrder = 0
      object cxGridDBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DS1
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableView1
      end
    end
  end
  object DS1: TDataSource
    Left = 512
    Top = 409
  end
end
