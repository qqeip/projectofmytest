object FrmDRSConfigParamSet: TFrmDRSConfigParamSet
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'FrmDRSConfigParamSet'
  ClientHeight = 402
  ClientWidth = 896
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 320
  ExplicitHeight = 240
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl2: TPageControl
    Left = 0
    Top = 0
    Width = 896
    Height = 402
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #24403#21069#37197#32622
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 888
        Height = 374
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Panel19: TPanel
          Left = 3
          Top = 301
          Width = 655
          Height = 58
          BevelOuter = bvNone
          TabOrder = 0
          object GroupBox16: TGroupBox
            Left = 3
            Top = 3
            Width = 505
            Height = 46
            TabOrder = 0
            object Label61: TLabel
              Left = 7
              Top = 18
              Width = 76
              Height = 13
              Caption = #26368#21518#37197#32622#26102#38388':'
            end
            object Label62: TLabel
              Left = 256
              Top = 18
              Width = 76
              Height = 13
              Caption = #26368#21518#26356#26032#26102#38388':'
            end
            object DBEdit12: TDBEdit
              Left = 89
              Top = 16
              Width = 150
              Height = 21
              DataField = 'updatetime3'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 0
            end
            object DBEdit13: TDBEdit
              Left = 342
              Top = 16
              Width = 150
              Height = 21
              DataField = 'updatetime4'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 1
            end
          end
        end
        object Panel2: TPanel
          Left = 3
          Top = 5
          Width = 376
          Height = 65
          BevelOuter = bvNone
          TabOrder = 1
          object GroupBox1: TGroupBox
            Left = 3
            Top = 3
            Width = 369
            Height = 53
            Caption = #35774#32622#30452#25918#31449#31995#32479#32534#21495
            TabOrder = 0
            object Label2: TLabel
              Left = 13
              Top = 26
              Width = 64
              Height = 13
              Caption = #30452#25918#31449#32534#21495':'
            end
            object Label3: TLabel
              Left = 198
              Top = 26
              Width = 52
              Height = 13
              Caption = #35774#22791#32534#21495':'
            end
            object DBEdit1: TDBEdit
              Left = 256
              Top = 25
              Width = 105
              Height = 21
              DataField = 'R_DEVICEID'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 0
            end
            object DBEdit2: TDBEdit
              Left = 83
              Top = 23
              Width = 105
              Height = 21
              DataField = 'DRSNO'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 1
            end
          end
          object CheckBox1: TCheckBox
            Left = 3
            Top = 3
            Width = 129
            Height = 17
            Caption = #35774#32622#30452#25918#31449#31995#32479#32534#21495
            TabOrder = 1
            Visible = False
          end
        end
        object Panel3: TPanel
          Left = 3
          Top = 64
          Width = 376
          Height = 242
          BevelOuter = bvNone
          TabOrder = 2
          object GroupBox2: TGroupBox
            Left = 3
            Top = 3
            Width = 369
            Height = 230
            Caption = #35774#32622#30452#25918#31449#20027#21160#21578#35686#20351#33021#26631#24535
            TabOrder = 0
            object Label4: TLabel
              Left = 13
              Top = 26
              Width = 82
              Height = 13
              Caption = #20449#36947'1'#26412#25391#22833#38145':'
            end
            object Label5: TLabel
              Left = 13
              Top = 49
              Width = 82
              Height = 13
              Caption = #20449#36947'2'#26412#25391#22833#38145':'
            end
            object Label6: TLabel
              Left = 13
              Top = 72
              Width = 52
              Height = 13
              Caption = #33258#28608#21578#35686':'
            end
            object Label7: TLabel
              Left = 13
              Top = 95
              Width = 52
              Height = 13
              Caption = #38376#31105#21578#35686':'
            end
            object Label8: TLabel
              Left = 13
              Top = 118
              Width = 52
              Height = 13
              Caption = #30005#28304#25481#30005':'
            end
            object Label9: TLabel
              Left = 13
              Top = 141
              Width = 88
              Height = 13
              Caption = #19978#34892#20302#22122#25918#25925#38556':'
            end
            object Label10: TLabel
              Left = 13
              Top = 164
              Width = 88
              Height = 13
              Caption = #19979#34892#20302#22122#25918#25925#38556':'
            end
            object Label11: TLabel
              Left = 13
              Top = 207
              Width = 76
              Height = 13
              Caption = #30005#28304#27169#22359#25925#38556':'
            end
            object Label12: TLabel
              Left = 178
              Top = 26
              Width = 88
              Height = 13
              Caption = #19978#34892#21151#25918#36807#21151#29575':'
            end
            object Label13: TLabel
              Left = 178
              Top = 49
              Width = 88
              Height = 13
              Caption = #19979#34892#21151#25918#36807#21151#29575':'
            end
            object Label14: TLabel
              Left = 178
              Top = 70
              Width = 76
              Height = 13
              Caption = #19978#34892#21151#25918#36807#28201':'
            end
            object Label15: TLabel
              Left = 178
              Top = 93
              Width = 76
              Height = 13
              Caption = #19979#34892#21151#25918#36807#28201':'
            end
            object Label16: TLabel
              Left = 178
              Top = 119
              Width = 124
              Height = 13
              Caption = #19978#34892#21151#25918#39547#27874#38376#38480#21578#35686':'
            end
            object Label17: TLabel
              Left = 178
              Top = 142
              Width = 124
              Height = 13
              Caption = #19979#34892#21151#25918#39547#27874#38376#38480#21578#35686':'
            end
            object Label18: TLabel
              Left = 178
              Top = 162
              Width = 76
              Height = 13
              Caption = #25910#21457#20449#21495#21578#35686':'
            end
            object Label19: TLabel
              Left = 178
              Top = 185
              Width = 88
              Height = 13
              Caption = #19979#34892#21151#25918#27424#21151#29575':'
            end
            object Label20: TLabel
              Left = 13
              Top = 185
              Width = 88
              Height = 13
              Caption = #20809#25910#21457#27169#22359#25925#38556':'
            end
            object DBCheckBox1: TDBCheckBox
              Left = 117
              Top = 23
              Width = 28
              Height = 17
              DataField = 'P0X32_01'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 0
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox2: TDBCheckBox
              Left = 117
              Top = 46
              Width = 28
              Height = 17
              DataField = 'P0X32_02'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 1
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox3: TDBCheckBox
              Left = 117
              Top = 69
              Width = 28
              Height = 17
              DataField = 'P0X32_03'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 2
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox4: TDBCheckBox
              Left = 117
              Top = 92
              Width = 28
              Height = 17
              DataField = 'P0X32_04'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 3
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox5: TDBCheckBox
              Left = 117
              Top = 115
              Width = 28
              Height = 17
              DataField = 'P0X32_05'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 4
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox6: TDBCheckBox
              Left = 117
              Top = 138
              Width = 28
              Height = 17
              DataField = 'P0X32_06'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 5
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox7: TDBCheckBox
              Left = 117
              Top = 161
              Width = 28
              Height = 17
              DataField = 'P0X32_07'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 6
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox8: TDBCheckBox
              Left = 117
              Top = 207
              Width = 28
              Height = 17
              DataField = 'P0X32_09'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 7
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox9: TDBCheckBox
              Left = 311
              Top = 23
              Width = 28
              Height = 17
              DataField = 'P0X32_10'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 8
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox10: TDBCheckBox
              Left = 311
              Top = 46
              Width = 28
              Height = 17
              DataField = 'P0X32_11'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 9
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox11: TDBCheckBox
              Left = 311
              Top = 67
              Width = 28
              Height = 17
              DataField = 'P0X32_12'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 10
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox12: TDBCheckBox
              Left = 311
              Top = 90
              Width = 28
              Height = 17
              DataField = 'P0X32_13'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 11
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox13: TDBCheckBox
              Left = 311
              Top = 113
              Width = 28
              Height = 17
              DataField = 'P0X32_14'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 12
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox14: TDBCheckBox
              Left = 311
              Top = 136
              Width = 28
              Height = 17
              DataField = 'P0X32_15'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 13
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox15: TDBCheckBox
              Left = 311
              Top = 159
              Width = 28
              Height = 17
              DataField = 'P0X32_16'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 14
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox16: TDBCheckBox
              Left = 311
              Top = 182
              Width = 28
              Height = 17
              DataField = 'P0X32_17'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 15
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox17: TDBCheckBox
              Left = 117
              Top = 184
              Width = 28
              Height = 17
              DataField = 'P0X32_08'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 16
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
          end
          object CheckBox2: TCheckBox
            Left = 3
            Top = 3
            Width = 177
            Height = 17
            Caption = #35774#32622#30452#25918#31449#20027#21160#21578#35686#20351#33021#26631#24535
            TabOrder = 1
            Visible = False
          end
        end
        object Panel4: TPanel
          Left = 385
          Top = 5
          Width = 496
          Height = 66
          BevelOuter = bvNone
          TabOrder = 3
          object GroupBox3: TGroupBox
            Left = 3
            Top = 3
            Width = 486
            Height = 53
            Caption = #35774#32622#36828#31243#36890#20449#21442#25968
            TabOrder = 0
            object Label21: TLabel
              Left = 13
              Top = 26
              Width = 52
              Height = 13
              Caption = #26597#35810#30005#35805':'
            end
            object Label22: TLabel
              Left = 190
              Top = 26
              Width = 52
              Height = 13
              Caption = #21578#35686#30005#35805':'
            end
            object Label23: TLabel
              Left = 366
              Top = 26
              Width = 52
              Height = 13
              Caption = #36890#20449#26041#24335':'
            end
            object DBEdit3: TDBEdit
              Left = 424
              Top = 23
              Width = 45
              Height = 21
              DataField = 'P0X31_03'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 0
            end
            object DBEdit4: TDBEdit
              Left = 71
              Top = 23
              Width = 113
              Height = 21
              DataField = 'P0X31_01'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 1
            end
            object DBEdit5: TDBEdit
              Left = 248
              Top = 23
              Width = 105
              Height = 21
              DataField = 'P0X31_02'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 2
            end
          end
          object CheckBox3: TCheckBox
            Left = 3
            Top = 3
            Width = 129
            Height = 17
            Caption = #35774#32622#36828#31243#36890#20449#21442#25968
            TabOrder = 1
            Visible = False
          end
        end
        object Panel5: TPanel
          Left = 385
          Top = 67
          Width = 496
          Height = 63
          BevelOuter = bvNone
          TabOrder = 4
          object GroupBox4: TGroupBox
            Left = 3
            Top = 3
            Width = 486
            Height = 53
            Caption = #35774#32622#38376#38480#20540
            TabOrder = 0
            object Label24: TLabel
              Left = 13
              Top = 26
              Width = 124
              Height = 13
              Caption = #19978#34892#36755#20986#21151#29575#21578#35686#19978#38480':'
            end
            object Label25: TLabel
              Left = 214
              Top = 26
              Width = 124
              Height = 13
              Caption = #19979#34892#36755#20986#21151#29575#21578#35686#19978#38480':'
            end
            object DBEdit6: TDBEdit
              Left = 344
              Top = 23
              Width = 45
              Height = 21
              DataField = 'P0X33_02'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 0
            end
            object DBEdit7: TDBEdit
              Left = 143
              Top = 29
              Width = 45
              Height = 21
              DataField = 'P0X33_01'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 1
            end
          end
          object CheckBox4: TCheckBox
            Left = 3
            Top = 3
            Width = 81
            Height = 17
            Caption = #35774#32622#38376#38480#20540
            TabOrder = 1
            Visible = False
          end
        end
        object Panel6: TPanel
          Left = 385
          Top = 126
          Width = 292
          Height = 63
          BevelOuter = bvNone
          TabOrder = 5
          object GroupBox5: TGroupBox
            Left = 3
            Top = 3
            Width = 273
            Height = 53
            Caption = #35774#32622#21151#25918#24320#20851#37327
            TabOrder = 0
            object Label26: TLabel
              Left = 13
              Top = 26
              Width = 76
              Height = 13
              Caption = #19978#34892#21151#25918#24320#20851':'
            end
            object Label27: TLabel
              Left = 142
              Top = 26
              Width = 76
              Height = 13
              Caption = #19979#34892#21151#25918#24320#20851':'
            end
            object DBCheckBox18: TDBCheckBox
              Left = 101
              Top = 23
              Width = 44
              Height = 17
              Caption = 'On'
              DataField = 'P0X34_01'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 0
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object DBCheckBox19: TDBCheckBox
              Left = 224
              Top = 23
              Width = 41
              Height = 17
              Caption = 'On'
              DataField = 'P0X34_02'
              DataSource = DSDRSCurrentConfig
              ReadOnly = True
              TabOrder = 1
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
          end
          object CheckBox5: TCheckBox
            Left = 3
            Top = 3
            Width = 105
            Height = 17
            Caption = #35774#32622#21151#25918#24320#20851#37327
            TabOrder = 1
            Visible = False
          end
        end
        object Panel7: TPanel
          Left = 385
          Top = 183
          Width = 458
          Height = 64
          BevelOuter = bvNone
          TabOrder = 6
          object GroupBox6: TGroupBox
            Left = 3
            Top = 3
            Width = 441
            Height = 53
            Caption = #35774#32622#34928#20943#37327
            TabOrder = 0
            object Label28: TLabel
              Left = 13
              Top = 26
              Width = 64
              Height = 13
              Caption = #19978#34892#34928#20943#20540':'
            end
            object Label58: TLabel
              Left = 238
              Top = 26
              Width = 64
              Height = 13
              Caption = #19979#34892#34928#20943#20540':'
            end
            object DBEdit8: TDBEdit
              Left = 320
              Top = 23
              Width = 105
              Height = 21
              DataField = 'P0X35_02'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 0
            end
            object DBEdit9: TDBEdit
              Left = 95
              Top = 23
              Width = 105
              Height = 21
              DataField = 'P0X35_01'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 1
            end
          end
          object CheckBox6: TCheckBox
            Left = 3
            Top = 3
            Width = 81
            Height = 17
            Caption = #35774#32622#34928#20943#37327
            TabOrder = 1
            Visible = False
          end
        end
        object Panel16: TPanel
          Left = 385
          Top = 242
          Width = 292
          Height = 64
          BevelOuter = bvNone
          TabOrder = 7
          object GroupBox7: TGroupBox
            Left = 3
            Top = 3
            Width = 270
            Height = 53
            Caption = #20449#36947#21495#35774#32622
            TabOrder = 0
            object Label59: TLabel
              Left = 13
              Top = 26
              Width = 46
              Height = 13
              Caption = #20449#36947#21495'1:'
            end
            object Label60: TLabel
              Left = 134
              Top = 26
              Width = 46
              Height = 13
              Caption = #20449#36947#21495'2:'
            end
            object DBEdit10: TDBEdit
              Left = 186
              Top = 23
              Width = 60
              Height = 21
              DataField = 'P0X36_02'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 0
            end
            object DBEdit11: TDBEdit
              Left = 63
              Top = 23
              Width = 60
              Height = 21
              DataField = 'P0X36_01'
              DataSource = DSDRSCurrentConfig
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 1
            end
          end
          object CheckBox7: TCheckBox
            Left = 3
            Top = 3
            Width = 81
            Height = 17
            Caption = #20449#36947#21495#35774#32622
            TabOrder = 1
            Visible = False
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #21442#25968#37197#32622
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 888
        Height = 374
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Panel12: TPanel
          Left = 385
          Top = 5
          Width = 496
          Height = 66
          BevelOuter = bvNone
          TabOrder = 3
          object GroupBox11: TGroupBox
            Left = 3
            Top = 3
            Width = 486
            Height = 53
            Caption = #35774#32622#36828#31243#36890#20449#21442#25968
            TabOrder = 0
            object Label49: TLabel
              Left = 13
              Top = 26
              Width = 52
              Height = 13
              Caption = #26597#35810#30005#35805':'
            end
            object Label50: TLabel
              Left = 190
              Top = 26
              Width = 52
              Height = 13
              Caption = #21578#35686#30005#35805':'
            end
            object Label51: TLabel
              Left = 366
              Top = 26
              Width = 52
              Height = 13
              Caption = #36890#20449#26041#24335':'
            end
            object dbe0X31_03: TDBEdit
              Left = 424
              Top = 23
              Width = 45
              Height = 21
              DataField = 'P0X31_03'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              ReadOnly = True
              TabOrder = 0
            end
            object ebe0X31_01: TDBEdit
              Left = 71
              Top = 23
              Width = 113
              Height = 21
              DataField = 'P0X31_01'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 1
            end
            object dbe0X31_02: TDBEdit
              Left = 248
              Top = 23
              Width = 105
              Height = 21
              DataField = 'P0X31_02'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 2
            end
          end
          object cb0X31: TCheckBox
            Left = 3
            Top = 3
            Width = 129
            Height = 17
            Caption = #35774#32622#36828#31243#36890#20449#21442#25968
            TabOrder = 1
          end
        end
        object Panel18: TPanel
          Left = 3
          Top = 5
          Width = 376
          Height = 64
          BevelOuter = bvNone
          TabOrder = 7
          object rgDRSConfig: TRadioGroup
            Left = 3
            Top = 3
            Width = 369
            Height = 53
            Caption = #37197#32622#36873#39033
            Columns = 4
            ItemIndex = 1
            Items.Strings = (
              #40664#35748#37197#32622
              #24403#21069#37197#32622
              #21382#21490#37197#32622)
            TabOrder = 0
            OnClick = rgDRSConfigClick
          end
          object cxLCBDRSConfigBatchID: TcxLookupComboBox
            Left = 258
            Top = 23
            Properties.KeyFieldNames = 'batchid'
            Properties.ListColumns = <
              item
                Caption = #37197#32622#26085#26399
                HeaderAlignment = taCenter
                FieldName = 'batchid'
              end>
            Properties.ListSource = DSDRSParamDate
            Properties.OnEditValueChanged = cxLCBDRSConfigBatchIDPropertiesEditValueChanged
            TabOrder = 1
            Width = 108
          end
        end
        object Panel20: TPanel
          Left = 644
          Top = 306
          Width = 185
          Height = 47
          BevelOuter = bvNone
          TabOrder = 8
          object btSelectAll: TButton
            Left = 15
            Top = 14
            Width = 75
            Height = 25
            Caption = #20840#36873
            TabOrder = 0
            OnClick = btSelectAllClick
          end
          object btApplyConfig: TButton
            Left = 96
            Top = 13
            Width = 75
            Height = 25
            Caption = #37197#32622
            TabOrder = 1
            OnClick = btApplyConfigClick
          end
        end
        object Panel10: TPanel
          Left = 3
          Top = 64
          Width = 376
          Height = 65
          BevelOuter = bvNone
          TabOrder = 1
          object GroupBox9: TGroupBox
            Left = 3
            Top = 3
            Width = 369
            Height = 53
            Caption = #35774#32622#30452#25918#31449#31995#32479#32534#21495
            TabOrder = 0
            object Label45: TLabel
              Left = 13
              Top = 26
              Width = 64
              Height = 13
              Caption = #30452#25918#31449#32534#21495':'
            end
            object Label46: TLabel
              Left = 198
              Top = 26
              Width = 52
              Height = 13
              Caption = #35774#22791#32534#21495':'
            end
            object dbeR_DEVICEID: TDBEdit
              Left = 256
              Top = 25
              Width = 105
              Height = 21
              DataField = 'R_DEVICEID'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 0
            end
            object dbeDRSNO: TDBEdit
              Left = 83
              Top = 23
              Width = 105
              Height = 21
              DataField = 'DRSNO'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 1
            end
          end
          object cb0X30: TCheckBox
            Left = 3
            Top = 3
            Width = 129
            Height = 17
            Caption = #35774#32622#30452#25918#31449#31995#32479#32534#21495
            TabOrder = 1
          end
        end
        object Panel9: TPanel
          Left = 3
          Top = 122
          Width = 376
          Height = 241
          BevelOuter = bvNone
          TabOrder = 0
          object GroupBox8: TGroupBox
            Left = 3
            Top = 3
            Width = 369
            Height = 230
            Caption = #35774#32622#30452#25918#31449#20027#21160#21578#35686#20351#33021#26631#24535
            TabOrder = 0
            object Label29: TLabel
              Left = 13
              Top = 26
              Width = 82
              Height = 13
              Caption = #20449#36947'1'#26412#25391#22833#38145':'
            end
            object Label30: TLabel
              Left = 13
              Top = 49
              Width = 82
              Height = 13
              Caption = #20449#36947'2'#26412#25391#22833#38145':'
            end
            object Label31: TLabel
              Left = 13
              Top = 72
              Width = 52
              Height = 13
              Caption = #33258#28608#21578#35686':'
            end
            object Label32: TLabel
              Left = 13
              Top = 95
              Width = 52
              Height = 13
              Caption = #38376#31105#21578#35686':'
            end
            object Label33: TLabel
              Left = 13
              Top = 118
              Width = 52
              Height = 13
              Caption = #30005#28304#25481#30005':'
            end
            object Label34: TLabel
              Left = 13
              Top = 141
              Width = 88
              Height = 13
              Caption = #19978#34892#20302#22122#25918#25925#38556':'
            end
            object Label35: TLabel
              Left = 13
              Top = 164
              Width = 88
              Height = 13
              Caption = #19979#34892#20302#22122#25918#25925#38556':'
            end
            object Label36: TLabel
              Left = 13
              Top = 207
              Width = 76
              Height = 13
              Caption = #30005#28304#27169#22359#25925#38556':'
            end
            object Label37: TLabel
              Left = 178
              Top = 26
              Width = 88
              Height = 13
              Caption = #19978#34892#21151#25918#36807#21151#29575':'
            end
            object Label38: TLabel
              Left = 178
              Top = 49
              Width = 88
              Height = 13
              Caption = #19979#34892#21151#25918#36807#21151#29575':'
            end
            object Label39: TLabel
              Left = 178
              Top = 70
              Width = 76
              Height = 13
              Caption = #19978#34892#21151#25918#36807#28201':'
            end
            object Label40: TLabel
              Left = 178
              Top = 93
              Width = 76
              Height = 13
              Caption = #19979#34892#21151#25918#36807#28201':'
            end
            object Label41: TLabel
              Left = 178
              Top = 119
              Width = 124
              Height = 13
              Caption = #19978#34892#21151#25918#39547#27874#38376#38480#21578#35686':'
            end
            object Label42: TLabel
              Left = 178
              Top = 142
              Width = 124
              Height = 13
              Caption = #19979#34892#21151#25918#39547#27874#38376#38480#21578#35686':'
            end
            object Label43: TLabel
              Left = 178
              Top = 162
              Width = 76
              Height = 13
              Caption = #25910#21457#20449#21495#21578#35686':'
            end
            object Label44: TLabel
              Left = 178
              Top = 185
              Width = 88
              Height = 13
              Caption = #19979#34892#21151#25918#27424#21151#29575':'
            end
            object Label1: TLabel
              Left = 13
              Top = 185
              Width = 88
              Height = 13
              Caption = #20809#25910#21457#27169#22359#25925#38556':'
            end
            object dbcb0X32_01: TDBCheckBox
              Left = 117
              Top = 23
              Width = 28
              Height = 17
              DataField = 'P0X32_01'
              DataSource = DSDRSParam
              TabOrder = 0
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_02: TDBCheckBox
              Left = 117
              Top = 46
              Width = 28
              Height = 17
              DataField = 'P0X32_02'
              DataSource = DSDRSParam
              TabOrder = 1
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_03: TDBCheckBox
              Left = 117
              Top = 69
              Width = 28
              Height = 17
              DataField = 'P0X32_03'
              DataSource = DSDRSParam
              TabOrder = 2
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_04: TDBCheckBox
              Left = 117
              Top = 92
              Width = 28
              Height = 17
              DataField = 'P0X32_04'
              DataSource = DSDRSParam
              TabOrder = 3
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_05: TDBCheckBox
              Left = 117
              Top = 115
              Width = 28
              Height = 17
              DataField = 'P0X32_05'
              DataSource = DSDRSParam
              TabOrder = 4
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_06: TDBCheckBox
              Left = 117
              Top = 138
              Width = 28
              Height = 17
              DataField = 'P0X32_06'
              DataSource = DSDRSParam
              TabOrder = 5
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_07: TDBCheckBox
              Left = 117
              Top = 161
              Width = 28
              Height = 17
              DataField = 'P0X32_07'
              DataSource = DSDRSParam
              TabOrder = 6
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_09: TDBCheckBox
              Left = 117
              Top = 207
              Width = 28
              Height = 17
              DataField = 'P0X32_09'
              DataSource = DSDRSParam
              TabOrder = 7
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_10: TDBCheckBox
              Left = 311
              Top = 23
              Width = 28
              Height = 17
              DataField = 'P0X32_10'
              DataSource = DSDRSParam
              TabOrder = 8
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_11: TDBCheckBox
              Left = 311
              Top = 46
              Width = 28
              Height = 17
              DataField = 'P0X32_11'
              DataSource = DSDRSParam
              TabOrder = 9
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_12: TDBCheckBox
              Left = 311
              Top = 67
              Width = 28
              Height = 17
              DataField = 'P0X32_12'
              DataSource = DSDRSParam
              TabOrder = 10
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_13: TDBCheckBox
              Left = 311
              Top = 90
              Width = 28
              Height = 17
              DataField = 'P0X32_13'
              DataSource = DSDRSParam
              TabOrder = 11
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_14: TDBCheckBox
              Left = 311
              Top = 113
              Width = 28
              Height = 17
              DataField = 'P0X32_14'
              DataSource = DSDRSParam
              TabOrder = 12
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_15: TDBCheckBox
              Left = 311
              Top = 136
              Width = 28
              Height = 17
              DataField = 'P0X32_15'
              DataSource = DSDRSParam
              TabOrder = 13
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_16: TDBCheckBox
              Left = 311
              Top = 159
              Width = 28
              Height = 17
              DataField = 'P0X32_16'
              DataSource = DSDRSParam
              TabOrder = 14
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_17: TDBCheckBox
              Left = 311
              Top = 182
              Width = 28
              Height = 17
              DataField = 'P0X32_17'
              DataSource = DSDRSParam
              TabOrder = 15
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X32_08: TDBCheckBox
              Left = 117
              Top = 184
              Width = 28
              Height = 17
              DataField = 'P0X32_08'
              DataSource = DSDRSParam
              TabOrder = 16
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
          end
          object cb0X32: TCheckBox
            Left = 3
            Top = 3
            Width = 177
            Height = 17
            Caption = #35774#32622#30452#25918#31449#20027#21160#21578#35686#20351#33021#26631#24535
            TabOrder = 1
          end
        end
        object Panel13: TPanel
          Left = 385
          Top = 67
          Width = 496
          Height = 63
          BevelOuter = bvNone
          TabOrder = 4
          object GroupBox12: TGroupBox
            Left = 3
            Top = 3
            Width = 486
            Height = 53
            Caption = #35774#32622#38376#38480#20540
            TabOrder = 0
            object Label52: TLabel
              Left = 13
              Top = 26
              Width = 124
              Height = 13
              Caption = #19978#34892#36755#20986#21151#29575#21578#35686#19978#38480':'
            end
            object Label53: TLabel
              Left = 214
              Top = 26
              Width = 124
              Height = 13
              Caption = #19979#34892#36755#20986#21151#29575#21578#35686#19978#38480':'
            end
            object dbe0X33_02: TDBEdit
              Left = 344
              Top = 23
              Width = 45
              Height = 21
              DataField = 'P0X33_02'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 0
            end
            object dbe0X33_01: TDBEdit
              Left = 143
              Top = 23
              Width = 45
              Height = 21
              DataField = 'P0X33_01'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 1
            end
          end
          object cb0X33: TCheckBox
            Left = 3
            Top = 3
            Width = 81
            Height = 17
            Caption = #35774#32622#38376#38480#20540
            TabOrder = 1
          end
        end
        object Panel11: TPanel
          Left = 385
          Top = 125
          Width = 292
          Height = 63
          BevelOuter = bvNone
          TabOrder = 2
          object GroupBox10: TGroupBox
            Left = 3
            Top = 3
            Width = 273
            Height = 53
            Caption = #35774#32622#21151#25918#24320#20851#37327
            TabOrder = 0
            object Label47: TLabel
              Left = 13
              Top = 26
              Width = 76
              Height = 13
              Caption = #19978#34892#21151#25918#24320#20851':'
            end
            object Label48: TLabel
              Left = 142
              Top = 26
              Width = 76
              Height = 13
              Caption = #19979#34892#21151#25918#24320#20851':'
            end
            object dbcb0X34_01: TDBCheckBox
              Left = 101
              Top = 23
              Width = 44
              Height = 17
              Caption = 'On'
              DataField = 'P0X34_01'
              DataSource = DSDRSParam
              TabOrder = 0
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbcb0X34_02: TDBCheckBox
              Left = 224
              Top = 23
              Width = 41
              Height = 17
              Caption = 'On'
              DataField = 'P0X34_02'
              DataSource = DSDRSParam
              TabOrder = 1
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
          end
          object cb0X34: TCheckBox
            Left = 3
            Top = 3
            Width = 105
            Height = 17
            Caption = #35774#32622#21151#25918#24320#20851#37327
            TabOrder = 1
          end
        end
        object Panel14: TPanel
          Left = 385
          Top = 184
          Width = 458
          Height = 64
          BevelOuter = bvNone
          TabOrder = 5
          object GroupBox13: TGroupBox
            Left = 3
            Top = 3
            Width = 441
            Height = 53
            Caption = #35774#32622#34928#20943#37327
            TabOrder = 0
            object Label54: TLabel
              Left = 13
              Top = 26
              Width = 64
              Height = 13
              Caption = #19978#34892#34928#20943#20540':'
            end
            object Label55: TLabel
              Left = 238
              Top = 26
              Width = 64
              Height = 13
              Caption = #19979#34892#34928#20943#20540':'
            end
            object dbe0X35_02: TDBEdit
              Left = 320
              Top = 23
              Width = 105
              Height = 21
              DataField = 'P0X35_02'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 0
            end
            object dbe0X35_01: TDBEdit
              Left = 95
              Top = 23
              Width = 105
              Height = 21
              DataField = 'P0X35_01'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 1
            end
          end
          object cb0X35: TCheckBox
            Left = 3
            Top = 3
            Width = 81
            Height = 17
            Caption = #35774#32622#34928#20943#37327
            TabOrder = 1
          end
        end
        object Panel15: TPanel
          Left = 385
          Top = 244
          Width = 292
          Height = 70
          BevelOuter = bvNone
          TabOrder = 6
          object GroupBox14: TGroupBox
            Left = 3
            Top = 3
            Width = 270
            Height = 53
            Caption = #20449#36947#21495#35774#32622
            TabOrder = 0
            object Label56: TLabel
              Left = 13
              Top = 26
              Width = 46
              Height = 13
              Caption = #20449#36947#21495'1:'
            end
            object Label57: TLabel
              Left = 134
              Top = 26
              Width = 46
              Height = 13
              Caption = #20449#36947#21495'2:'
            end
            object dbe0X36_02: TDBEdit
              Left = 186
              Top = 23
              Width = 60
              Height = 21
              DataField = 'P0X36_02'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 0
            end
            object dbe0X36_01: TDBEdit
              Left = 63
              Top = 23
              Width = 60
              Height = 21
              DataField = 'P0X36_01'
              DataSource = DSDRSParam
              ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
              TabOrder = 1
            end
          end
          object cb0X36: TCheckBox
            Left = 3
            Top = 3
            Width = 81
            Height = 17
            Caption = #20449#36947#21495#35774#32622
            TabOrder = 1
          end
        end
      end
    end
  end
  object DSDRSParam: TDataSource
    DataSet = CDSDRSParam
    Left = 712
    Top = 176
  end
  object CDSDRSParam: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 784
    Top = 176
  end
  object DSDRSParamDate: TDataSource
    DataSet = CDSDRSParamDate
    Left = 256
    Top = 72
  end
  object CDSDRSParamDate: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 328
    Top = 72
  end
  object DSDRSCurrentConfig: TDataSource
    DataSet = CDSDRSCurrentConfig
    Left = 704
    Top = 272
  end
  object CDSDRSCurrentConfig: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 776
    Top = 272
  end
end
