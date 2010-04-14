object Fm_AlarmQuery: TFm_AlarmQuery
  Left = 0
  Top = 0
  Caption = #21578#35686#32508#21512#26597#35810
  ClientHeight = 544
  ClientWidth = 711
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 480
    Height = 544
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 451
    object cxGrid1: TcxGrid
      Left = 1
      Top = 1
      Width = 478
      Height = 542
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 120
      ExplicitTop = 266
      ExplicitWidth = 250
      ExplicitHeight = 200
      object cxGrid1DBTableView1: TcxGridDBTableView
        NavigatorButtons.ConfirmDelete = False
        DataController.DataSource = DataSourceOnLine
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
  end
  object Panel2: TPanel
    Left = 480
    Top = 0
    Width = 231
    Height = 544
    Align = alRight
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 229
      Height = 542
      Align = alClient
      Caption = #24453#36873#26465#20214'('#25353#39034#24207#36873#25321#22320#24066'-'#37066#21439'-'#23460#20998#28857')'
      TabOrder = 0
      ExplicitWidth = 252
      object Label10: TLabel
        Left = 73
        Top = 374
        Width = 12
        Height = 12
        Caption = #33267
      end
      object Label13: TLabel
        Left = 73
        Top = 453
        Width = 12
        Height = 12
        Caption = #33267
      end
      object Label1: TLabel
        Left = 7
        Top = 29
        Width = 48
        Height = 12
        Caption = #21010#20998#21578#35686
      end
      object Btn_Query: TButton
        Left = 28
        Top = 492
        Width = 75
        Height = 25
        Caption = #26597#35810
        TabOrder = 0
        OnClick = Btn_QueryClick
      end
      object Cmb_City: TComboBox
        Tag = 1
        Left = 91
        Top = 62
        Width = 132
        Height = 20
        Style = csDropDownList
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 1
        OnChange = Cmb_CityChange
      end
      object Cmb_Area: TComboBox
        Tag = 2
        Left = 91
        Top = 100
        Width = 132
        Height = 20
        Style = csDropDownList
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 2
        OnChange = Cmb_AreaChange
      end
      object Cmb_SFD: TComboBox
        Tag = 3
        Left = 91
        Top = 176
        Width = 132
        Height = 20
        Style = csDropDownList
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 3
        OnChange = Cmb_SFDChange
      end
      object Cmb_AC: TComboBox
        Tag = 4
        Left = 91
        Top = 214
        Width = 132
        Height = 20
        Style = csDropDownList
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 4
        OnChange = Cmb_ACChange
      end
      object Cmb_AT: TComboBox
        Tag = 5
        Left = 91
        Top = 252
        Width = 132
        Height = 20
        Style = csDropDownList
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 5
        OnChange = Cmb_ATChange
      end
      object Edt_MTUNO: TEdit
        Tag = 6
        Left = 91
        Top = 291
        Width = 132
        Height = 20
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 6
      end
      object Cmb_AlarmHF: TComboBox
        Left = 73
        Top = 26
        Width = 81
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 7
        Text = #22312#32447#21578#35686
        Items.Strings = (
          #22312#32447#21578#35686
          #21382#21490#21578#35686)
      end
      object SendD1: TDateTimePicker
        Left = 92
        Top = 333
        Width = 82
        Height = 20
        Date = 38612.592544849540000000
        Format = 'yyyy-MM-dd'
        Time = 38612.592544849540000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 8
      end
      object SendT1: TDateTimePicker
        Left = 171
        Top = 333
        Width = 52
        Height = 20
        Date = 38938.707921006940000000
        Format = 'HH:mm'
        Time = 38938.707921006940000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        Kind = dtkTime
        TabOrder = 9
      end
      object SendD2: TDateTimePicker
        Left = 91
        Top = 370
        Width = 82
        Height = 20
        Date = 38612.592544849540000000
        Format = 'yyyy-MM-dd'
        Time = 38612.592544849540000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 10
      end
      object SendT2: TDateTimePicker
        Left = 171
        Top = 370
        Width = 52
        Height = 20
        Date = 38938.707921006940000000
        Format = 'HH:mm'
        Time = 38938.707921006940000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        Kind = dtkTime
        TabOrder = 11
      end
      object MoveD1: TDateTimePicker
        Left = 91
        Top = 414
        Width = 82
        Height = 20
        Date = 38612.592544849540000000
        Format = 'yyyy-MM-dd'
        Time = 38612.592544849540000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 12
      end
      object MoveT1: TDateTimePicker
        Left = 171
        Top = 414
        Width = 52
        Height = 20
        Date = 38938.707921006940000000
        Format = 'HH:mm'
        Time = 38938.707921006940000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        Kind = dtkTime
        TabOrder = 13
      end
      object MoveD2: TDateTimePicker
        Left = 91
        Top = 449
        Width = 82
        Height = 20
        Date = 38612.592544849540000000
        Format = 'yyyy-MM-dd'
        Time = 38612.592544849540000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 14
      end
      object MoveT2: TDateTimePicker
        Left = 171
        Top = 449
        Width = 52
        Height = 20
        Date = 38938.707921006940000000
        Format = 'HH:mm'
        Time = 38938.707921006940000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        Kind = dtkTime
        TabOrder = 15
      end
      object Chb_City: TCheckBox
        Tag = 1
        Left = 7
        Top = 64
        Width = 83
        Height = 17
        Caption = #25152#23646#22320#24066
        TabOrder = 16
        OnClick = Chb_CityClick
      end
      object Chb_Area: TCheckBox
        Tag = 2
        Left = 7
        Top = 102
        Width = 83
        Height = 17
        Caption = #25152#23646#37066#21439
        Enabled = False
        TabOrder = 17
        OnClick = Chb_AreaClick
      end
      object Chb_SFD: TCheckBox
        Tag = 3
        Left = 7
        Top = 178
        Width = 83
        Height = 17
        Caption = #23460#20998#28857
        Enabled = False
        TabOrder = 18
        OnClick = Chb_SFDClick
      end
      object Chb_AC: TCheckBox
        Tag = 4
        Left = 7
        Top = 216
        Width = 83
        Height = 17
        Caption = #21578#35686#20869#23481
        TabOrder = 19
        OnClick = Chb_ACClick
      end
      object Chb_AT: TCheckBox
        Tag = 5
        Left = 7
        Top = 254
        Width = 83
        Height = 17
        Caption = #21578#35686#31867#22411
        TabOrder = 20
        OnClick = Chb_ATClick
      end
      object Chb_MTUNO: TCheckBox
        Tag = 6
        Left = 7
        Top = 293
        Width = 83
        Height = 17
        Caption = 'MTU'#32534#21495
        TabOrder = 21
        OnClick = Chb_MTUNOClick
      end
      object Chb_SendTime: TCheckBox
        Tag = 7
        Left = 7
        Top = 336
        Width = 83
        Height = 17
        Caption = #27966#38556#26102#38388#20174
        TabOrder = 22
        OnClick = Chb_SendTimeClick
      end
      object Chb_ClearTime: TCheckBox
        Tag = 8
        Left = 7
        Top = 417
        Width = 83
        Height = 17
        Caption = #25490#38556#26102#38388#20174
        TabOrder = 23
        OnClick = Chb_ClearTimeClick
      end
      object CheckBoxAll: TCheckBox
        Left = 157
        Top = 28
        Width = 68
        Height = 17
        Caption = #20840#37096#36873#23450
        TabOrder = 24
        OnClick = CheckBoxAllClick
      end
      object Btn_Close: TButton
        Left = 124
        Top = 492
        Width = 75
        Height = 25
        Caption = #20851#38381
        TabOrder = 25
        OnClick = Btn_CloseClick
      end
      object CheckBoxSuburb: TCheckBox
        Tag = 9
        Left = 7
        Top = 140
        Width = 83
        Height = 17
        Caption = #25152#23646#20998#23616
        Enabled = False
        TabOrder = 26
        OnClick = CheckBoxSuburbClick
      end
      object ComboBoxSuburb: TComboBox
        Tag = 9
        Left = 91
        Top = 138
        Width = 132
        Height = 20
        Style = csDropDownList
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 0
        TabOrder = 27
        OnChange = ComboBoxSuburbChange
      end
    end
  end
  object ClientDataSetOnLine: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 416
    Top = 360
  end
  object DataSourceOnLine: TDataSource
    DataSet = ClientDataSetOnLine
    Left = 384
    Top = 360
  end
end
