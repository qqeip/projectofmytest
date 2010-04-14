object Form_DRS_AlarmQuery: TForm_DRS_AlarmQuery
  Left = 0
  Top = 0
  Caption = #30452#25918#31449#21578#35686#32508#21512#26597#35810
  ClientHeight = 552
  ClientWidth = 865
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
    Width = 634
    Height = 552
    Align = alClient
    TabOrder = 0
    object cxGrid1: TcxGrid
      Left = 1
      Top = 1
      Width = 632
      Height = 550
      Align = alClient
      TabOrder = 0
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
    Left = 634
    Top = 0
    Width = 231
    Height = 552
    Align = alRight
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 229
      Height = 550
      Align = alClient
      Caption = #24453#36873#26465#20214'('#25353#39034#24207#36873#25321#22320#24066'-'#37066#21439'-'#23460#20998#28857')'
      TabOrder = 0
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
      object SpeedButtonSearch: TSpeedButton
        Left = 201
        Top = 213
        Width = 17
        Height = 19
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          FA050000424DFA05000000000000DA020000280000001D000000190000000100
          08000000000020030000120B0000120B0000A9000000A9000000FFFFFF0000FF
          FF00FF00FF000000FF00FFFF000000FF0000FF00000000000000E15C0F00E65F
          1100EF651500F76A1900FA6C1B00FD6E1C00E86A2100FA732600FF782B00FB89
          4700C54B0100C84D0200CB4F0400CF510600D3540800D8570A00DC590C00EA62
          1300F3681700CF5B1400D55D1500EB6C2200D76C2C00DC702E00DE713000F880
          3A00E3773500FD833C00F5864400D8783D00F3874700FE8E4D00E8824600E78E
          5500FAA47100F8A97800FEAE7D00EDA57700F7AD8000FCB38800FBB78C00ECB2
          8D00FDD7BF00E9976000EFA16F00E5A27700FCB98E00EDB28C00F7C5A200F9CB
          AC00FBCEAF00FDD3B700F4CFB500FCDBC400FDDFCB00FFA56200FFA66200FFA7
          6300FFA76400F3B98D00F6CBAC00FFA86300FFA86400FFAA6400FFAB6500FEAD
          6E00FFB67D00FBBB8800FCBD8900F8C69F00F8C8A200FCF0E600FFAC6500FFAE
          6600FFAF6700FFB16800FFCB9E00FFCFA200FFCEA300FFD0A500FFD3AA00FED8
          B500FEDAB900FEDCBD00FDE1C700FDE1C800FDE3CB00FDE3CC00FDE5CF00FDE7
          D300FDECDD00FCEBDC00FCEEE100FFF2E600FFF4EA00FFB26800FFB46900FFB5
          6A00FFCB9700FFCC9C00FFD0A300FFD1A400FFD2A500FFD2A700FFD3A800FFD4
          AA00FFD5AB00FED5AD00FED5AE00FED7B100FED7B200FED8B400FEDAB800FEDB
          BA00FEDCBC00FDDEBF00FDDEC000F7DABD00FEE0C300F6D9BD00FDE0C300FDE0
          C400FEE3C900FEE4CB00FEE5CC00FDE5CE00FAE3CC00FAE3CD00FDE7D200FDE8
          D400FCE8D500FDEAD700FFEDDB00FCEAD800FCEDDE00FDF1E500FFF4E900FFB7
          6B00FFB86B00FFBA6C00FCEBD900FCECDB00FFBB6D00FFBD6E00FFBE6E00FAC9
          8C00FAC98D00FEE2C000FFBF6F00FEC16F00FFC07000FFC27000FFC37100FCC1
          7400FFD19300FDFAF600FDC27000FFC47200FEE9CB00FDF5E900FFFFFF003F3F
          3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F424B7F7F000000406A
          6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6A6B544A497D000000416C
          55555555555555555555555555555555555555555555555557414C000000456E
          6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D6D56460000004770
          6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F90906F6F6F6F6F6F58470000004872
          7171717171717171717171717171717166121266717171717172480000005074
          7373737373737379848C65658C84796613131313737373737374500000005176
          757575757575823C35251B1B25353C1414141414757575757576510000005259
          777777777783311E1515151515151E151515157777777777775952000000535A
          787878787E371C161F334343331F161C1616787878787878785A53000000675B
          7A7A7A7A442017294D7A7A7A7A4D291720447A7A7A7A7A7A7A5B67000000687C
          7B7B7B7B2D18224E7B7B7B7B7B7B4E22182D7B7B7B7B7B7B7B7C680000006981
          808080802808348080808080808080340828808080808080808169000000915D
          5C5C5C5C0E09385C5C5C5C5C5C5C5C38090E5C5C5C5C5C5C5C5D91000000925F
          5E5E5E5E1D19395E5E5E5E5E5E5E5E39191D5E5E5E5E5E5E5E5F920000009360
          85858585260A2E89858585858585892E0A268585858585858560930000009661
          888888882B1A243D8B888888888B3D241A2B888888888888886196000000978A
          8A8A8A8A3A210B2A3E8F62628F3E2A0B213A8A8A8A8A8A8A8A8A97000000988D
          8D8D8D8D8D300F0C112F32322F110C0F308D8D8D8D8D8D8D8D8D980000009C63
          63636363636336230D0D0D0D0D0D2336636363636363636363639C0000009E8E
          8E8E8E8E8E8E8E3B2C271010272C3B8E8E8E8E8E8E8E8E8E8E949E0000009F64
          646464646464646464646464646464646464646464646464649B9D000000A04F
          4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F4F95A09A000000A0A3
          A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A3A7A6A2A186000000A5A5
          A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A4998787000000}
        OnClick = SpeedButtonSearchClick
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
        ItemHeight = 12
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
        ItemHeight = 12
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
        ItemHeight = 12
        TabOrder = 3
        OnChange = Cmb_SFDChange
      end
      object Cmb_AT: TComboBox
        Tag = 5
        Left = 91
        Top = 251
        Width = 132
        Height = 20
        Style = csDropDownList
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        TabOrder = 4
        OnChange = Cmb_ATChange
      end
      object Edt_DRS_Info: TEdit
        Tag = 6
        Left = 91
        Top = 291
        Width = 132
        Height = 20
        Hint = #25353#32534#21495','#21517#31216','#30005#35805#21495#30721','#22320#22336' '#26597#35810
        Enabled = False
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object Cmb_AlarmHF: TComboBox
        Left = 109
        Top = 26
        Width = 81
        Height = 20
        Style = csDropDownList
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 6
        Text = #22312#32447#21578#35686
        Visible = False
        Items.Strings = (
          #22312#32447#21578#35686
          #21382#21490#21578#35686)
      end
      object SendD1: TDateTimePicker
        Left = 91
        Top = 333
        Width = 82
        Height = 20
        Date = 38612.592544849540000000
        Format = 'yyyy-MM-dd'
        Time = 38612.592544849540000000
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        TabOrder = 7
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
        TabOrder = 8
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
        TabOrder = 9
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
        TabOrder = 10
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
        TabOrder = 11
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
        TabOrder = 12
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
        TabOrder = 13
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
        TabOrder = 14
      end
      object Chb_City: TCheckBox
        Tag = 1
        Left = 5
        Top = 64
        Width = 83
        Height = 17
        Caption = #25152#23646#22320#24066
        TabOrder = 15
        OnClick = Chb_CityClick
      end
      object Chb_Area: TCheckBox
        Tag = 2
        Left = 5
        Top = 102
        Width = 83
        Height = 17
        Caption = #25152#23646#37066#21439
        Enabled = False
        TabOrder = 16
        OnClick = Chb_AreaClick
      end
      object Chb_SFD: TCheckBox
        Tag = 3
        Left = 5
        Top = 178
        Width = 83
        Height = 17
        Caption = #23460#20998#28857
        Enabled = False
        TabOrder = 17
        OnClick = Chb_SFDClick
      end
      object Chb_AC: TCheckBox
        Tag = 4
        Left = 5
        Top = 216
        Width = 83
        Height = 17
        Caption = #21578#35686#20869#23481
        TabOrder = 18
        OnClick = Chb_ACClick
      end
      object Chb_AT: TCheckBox
        Tag = 5
        Left = 5
        Top = 250
        Width = 83
        Height = 17
        Caption = #30452#25918#31449#31867#22411
        TabOrder = 19
        OnClick = Chb_ATClick
      end
      object Chb_DRSInfo: TCheckBox
        Tag = 6
        Left = 5
        Top = 293
        Width = 83
        Height = 17
        Caption = #30452#25918#31449#20449#24687
        TabOrder = 20
        OnClick = Chb_DRSInfoClick
      end
      object Chb_SendTime: TCheckBox
        Tag = 7
        Left = 5
        Top = 336
        Width = 83
        Height = 17
        Caption = #27966#38556#26102#38388#20174
        TabOrder = 21
        OnClick = Chb_SendTimeClick
      end
      object Chb_ClearTime: TCheckBox
        Tag = 8
        Left = 5
        Top = 417
        Width = 83
        Height = 17
        Caption = #25490#38556#26102#38388#20174
        TabOrder = 22
        OnClick = Chb_ClearTimeClick
      end
      object CheckBoxAll: TCheckBox
        Left = 5
        Top = 28
        Width = 68
        Height = 17
        Caption = #20840#37096#36873#23450
        TabOrder = 23
        OnClick = CheckBoxAllClick
      end
      object Btn_Close: TButton
        Left = 124
        Top = 492
        Width = 75
        Height = 25
        Caption = #20851#38381
        TabOrder = 24
        OnClick = Btn_CloseClick
      end
      object CheckBoxSuburb: TCheckBox
        Tag = 9
        Left = 5
        Top = 140
        Width = 83
        Height = 17
        Caption = #25152#23646#20998#23616
        Enabled = False
        TabOrder = 25
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
        ItemHeight = 12
        TabOrder = 26
        OnChange = ComboBoxSuburbChange
      end
      object Cmb_AC: TEdit
        Left = 91
        Top = 213
        Width = 104
        Height = 20
        ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
        ReadOnly = True
        TabOrder = 27
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
