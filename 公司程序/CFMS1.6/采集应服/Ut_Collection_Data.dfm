object Fm_Collection_Data: TFm_Collection_Data
  Left = 279
  Top = 116
  Width = 811
  Height = 577
  Caption = #25968#25454#37319#38598#31649#29702
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 803
    Height = 550
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = '@'#23435#20307
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabHeight = 25
    TabOrder = 0
    TabPosition = tpRight
    TabWidth = 150
    object TabSheet1: TTabSheet
      Caption = #37319#38598#24320#20851#25511#21046#38754#26495
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      object GroupBox6: TGroupBox
        Left = 0
        Top = 0
        Width = 770
        Height = 542
        Align = alClient
        TabOrder = 0
        object Shape_DataCollect: TShape
          Left = 327
          Top = 305
          Width = 130
          Height = 4
          Pen.Color = clGreen
          Pen.Width = 2
        end
        object Shape_AutoSend: TShape
          Left = 551
          Top = 305
          Width = 78
          Height = 4
          Pen.Color = clGreen
          Pen.Width = 2
        end
        object Label11: TLabel
          Left = 445
          Top = 103
          Width = 36
          Height = 12
          Caption = #37319#38598#65306
        end
        object Label12: TLabel
          Left = 607
          Top = 103
          Width = 36
          Height = 12
          Caption = #27966#38556#65306
        end
        object Label4: TLabel
          Left = 25
          Top = 103
          Width = 84
          Height = 12
          Caption = 'CDMA'#23454#26102#21578#35686#65306
        end
        object Shape_ZTRT_2: TShape
          Left = 136
          Top = 307
          Width = 85
          Height = 1
          Pen.Color = clGreen
        end
        object Label16: TLabel
          Left = 233
          Top = 103
          Width = 84
          Height = 12
          Caption = 'CDMA'#21578#35686#37319#38598#65306
        end
        object Shape1: TShape
          Left = 280
          Top = 203
          Width = 1
          Height = 86
          Pen.Color = clGreen
        end
        object Label5: TLabel
          Left = 234
          Top = 42
          Width = 268
          Height = 21
          Caption = 'CDMA'#21578#35686#37319#38598#32447#31243#24320#20851#35774#32622
          Font.Charset = GB2312_CHARSET
          Font.Color = clPurple
          Font.Height = -21
          Font.Name = #23435#20307
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Gb_DataCollect: TGroupBox
          Left = 221
          Top = 280
          Width = 105
          Height = 49
          Caption = #21578#35686#37319#38598
          TabOrder = 0
          object Sb_Dc_Start: TSpeedButton
            Tag = 1
            Left = 10
            Top = 19
            Width = 40
            Height = 22
            GroupIndex = 8
            Caption = #21551#21160
            OnClick = Sb_Rts_StartClick
          end
          object Sb_Dc_Stop: TSpeedButton
            Tag = 2
            Left = 57
            Top = 19
            Width = 40
            Height = 22
            GroupIndex = 8
            Down = True
            Caption = #20572#27490
            OnClick = Sb_Rts_StartClick
          end
        end
        object Gb_AutoSend: TGroupBox
          Left = 452
          Top = 279
          Width = 105
          Height = 49
          Caption = #33258#21160#27966#38556
          TabOrder = 1
          object Sb_As_Start: TSpeedButton
            Tag = 1
            Left = 10
            Top = 19
            Width = 40
            Height = 22
            GroupIndex = 9
            Caption = #21551#21160
            OnClick = Sb_Rts_StartClick
          end
          object Sb_As_Stop: TSpeedButton
            Tag = 2
            Left = 57
            Top = 19
            Width = 40
            Height = 22
            GroupIndex = 9
            Down = True
            Caption = #20572#27490
            OnClick = Sb_Rts_StartClick
          end
        end
        object Panel2: TPanel
          Left = 624
          Top = 258
          Width = 143
          Height = 97
          BevelInner = bvLowered
          TabOrder = 2
          object Label8: TLabel
            Left = 26
            Top = 55
            Width = 88
            Height = 21
            Caption = #31649#29702#31995#32479
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label6: TLabel
            Left = 26
            Top = 26
            Width = 88
            Height = 21
            Caption = #27966#38556#25490#38556
            Font.Charset = GB2312_CHARSET
            Font.Color = clBlue
            Font.Height = -21
            Font.Name = #23435#20307
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object Bt_DataCollect: TButton
          Left = 409
          Top = 382
          Width = 60
          Height = 25
          Caption = #37319#38598
          TabOrder = 3
          OnClick = Bt_DataCollectClick
        end
        object Bt_AutoSend: TButton
          Left = 525
          Top = 382
          Width = 60
          Height = 25
          Caption = #27966#38556
          TabOrder = 4
          OnClick = Bt_AutoSendClick
        end
        object btCDMART: TButton
          Left = 293
          Top = 382
          Width = 60
          Height = 25
          Caption = 'CDMA'#23454#26102
          TabOrder = 5
          Visible = False
          OnClick = btCDMARTClick
        end
        object Ed_DataCollect: TEdit
          Left = 495
          Top = 99
          Width = 99
          Height = 20
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ReadOnly = True
          TabOrder = 6
        end
        object Ed_AutoSend: TEdit
          Left = 648
          Top = 99
          Width = 99
          Height = 20
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ReadOnly = True
          TabOrder = 7
        end
        object gbCDMALX: TGroupBox
          Tag = 600000
          Left = 30
          Top = 278
          Width = 105
          Height = 49
          Caption = 'CDMA'#36718#35810#21578#35686
          TabOrder = 8
          object sbCDMALXStart: TSpeedButton
            Tag = 1
            Left = 10
            Top = 19
            Width = 40
            Height = 22
            GroupIndex = 6
            Caption = #21551#21160
            OnClick = Sb_Rts_StartClick
          end
          object sbCDMALXStop: TSpeedButton
            Tag = 2
            Left = 57
            Top = 19
            Width = 40
            Height = 22
            GroupIndex = 6
            Down = True
            Caption = #20572#27490
            OnClick = Sb_Rts_StartClick
          end
        end
        object btCDMALX: TButton
          Left = 198
          Top = 382
          Width = 60
          Height = 25
          Caption = 'CDMA'#21578#35686
          TabOrder = 9
          OnClick = btCDMALXClick
        end
        object Ed_ZteRt: TEdit
          Left = 322
          Top = 99
          Width = 99
          Height = 20
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ReadOnly = True
          TabOrder = 10
        end
        object Ed_RealTime: TEdit
          Left = 114
          Top = 99
          Width = 99
          Height = 20
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ReadOnly = True
          TabOrder = 11
        end
        object gbCDMART: TGroupBox
          Tag = 600000
          Left = 222
          Top = 158
          Width = 105
          Height = 49
          Caption = 'CDMA'#23454#26102#21578#35686
          TabOrder = 12
          object sbCDMARTStart: TSpeedButton
            Tag = 1
            Left = 10
            Top = 19
            Width = 40
            Height = 22
            GroupIndex = 7
            Caption = #21551#21160
            Enabled = False
            OnClick = Sb_Rts_StartClick
          end
          object sbCDMARTStop: TSpeedButton
            Tag = 2
            Left = 57
            Top = 19
            Width = 40
            Height = 22
            GroupIndex = 7
            Down = True
            Caption = #20572#27490
            Enabled = False
            OnClick = Sb_Rts_StartClick
          end
        end
        object GroupBox1: TGroupBox
          Left = 16
          Top = 344
          Width = 161
          Height = 97
          Caption = #31649#29702#21592#35843#24335#24320#20851
          TabOrder = 13
          object cbDebugCDMAColl: TCheckBox
            Left = 16
            Top = 24
            Width = 97
            Height = 17
            Caption = #26174#31034#35843#35797#20449#24687
            TabOrder = 0
            OnClick = cbDebugCDMACollClick
          end
          object cbClearHis: TCheckBox
            Left = 16
            Top = 56
            Width = 129
            Height = 17
            Caption = #19981#28165#38500#21382#21490#20020#26102#25968#25454
            TabOrder = 1
            OnClick = cbClearHisClick
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #37319#38598#21442#25968#35774#32622
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      object Label2: TLabel
        Left = 17
        Top = 294
        Width = 72
        Height = 12
        Caption = #25191#34892#32447#31243#21517#31216
      end
      object Label1: TLabel
        Left = 638
        Top = 294
        Width = 84
        Height = 12
        Caption = #25195#25551#21608#26399'('#20998#38047')'
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 35
        Top = 334
        Width = 36
        Height = 12
        Caption = #22791'  '#27880
      end
      object Label7: TLabel
        Left = 25
        Top = 408
        Width = 270
        Height = 12
        Caption = #27880'2'#65306#20197#19978#20449#24687#26356#26032#21518#65292#22312#31995#32479#37325#26032#21551#21160#21518#26041#33021#29983#25928
      end
      object Label27: TLabel
        Left = 25
        Top = 384
        Width = 366
        Height = 12
        Caption = #27880'1'#65306#21551#21160#31867#22411#27492#30028#38754#30340#35774#32622#26080#25928#65292#32780#22312'<'#37319#38598#24320#20851#25511#21046#38754#26495#36827#34892#35774#32622'>'
      end
      object DBGrid2: TDBGrid
        Left = 16
        Top = 22
        Width = 793
        Height = 243
        DataSource = Dm_Collect_Local.Ds_Collection_Cfg
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
        TabOrder = 0
        TitleFont.Charset = GB2312_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #23435#20307
        TitleFont.Style = []
        OnCellClick = DBGrid2CellClick
        OnDrawColumnCell = DBGrid2DrawColumnCell
        OnKeyUp = DBGrid2KeyUp
        Columns = <
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'COLLECTKIND'
            Title.Alignment = taCenter
            Title.Caption = #32534#21495
            Title.Color = clSkyBlue
            Width = 37
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COLLECTNAME'
            Title.Alignment = taCenter
            Title.Caption = #25191#34892#32447#31243#21517#31216
            Width = 133
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'ISCREATE'
            Title.Alignment = taCenter
            Title.Caption = #21019#24314#29366#24577
            Title.Color = clSkyBlue
            Width = 62
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'COLLECTSTATE'
            Title.Alignment = taCenter
            Title.Caption = #21551#21160#31867#22411
            Title.Color = clSkyBlue
            Width = 60
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'COLLECTIONCYC'
            Title.Alignment = taCenter
            Title.Caption = #25195#25551#21608#26399'('#20998#38047')'
            Title.Color = clSkyBlue
            Width = 92
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'STARTTIME'
            Title.Alignment = taCenter
            Title.Caption = #26412#27425#25195#25551#24320#22987#26102#38388
            Width = 116
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'LASTMODIFY'
            Title.Alignment = taCenter
            Title.Caption = #21442#25968#20462#25913#26102#38388
            Width = 121
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MENDER'
            Title.Alignment = taCenter
            Title.Caption = #26368#21518#20462#25913#20154
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'REMARK'
            Title.Alignment = taCenter
            Title.Caption = #22791#27880
            Width = 166
            Visible = True
          end>
      end
      object Se_CollectionCyc: TSpinEdit
        Left = 736
        Top = 290
        Width = 55
        Height = 21
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 3600
        MinValue = 1
        ParentFont = False
        TabOrder = 1
        Value = 1
      end
      object Et_COLLECTNAME: TEdit
        Left = 96
        Top = 290
        Width = 155
        Height = 20
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
        ParentFont = False
        TabOrder = 2
      end
      object Et_Remark: TEdit
        Left = 95
        Top = 330
        Width = 698
        Height = 20
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
        ParentFont = False
        TabOrder = 3
      end
      object Bt_UpdCfg: TButton
        Tag = 1
        Left = 632
        Top = 389
        Width = 75
        Height = 25
        Caption = #26356#26032#34892
        TabOrder = 4
        OnClick = Bt_UpdCfgClick
      end
      object Bt_RefCfg: TButton
        Left = 504
        Top = 389
        Width = 75
        Height = 25
        Caption = #21047' '#26032
        TabOrder = 5
        OnClick = Bt_RefCfgClick
      end
      object Rg_ISCREATE: TRadioGroup
        Left = 296
        Top = 283
        Width = 137
        Height = 35
        Caption = #21019#24314#29366#24577
        Columns = 2
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        Items.Strings = (
          #19981#21019#24314
          #21019#24314)
        ParentFont = False
        TabOrder = 6
      end
      object Rg_COLLECTSTATE: TRadioGroup
        Left = 464
        Top = 283
        Width = 137
        Height = 35
        Caption = #21551#21160#31867#22411
        Columns = 2
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        Items.Strings = (
          #25163#21160
          #33258#21160)
        ParentFont = False
        TabOrder = 7
      end
    end
    object tsSourceSet: TTabSheet
      Caption = #34987#37319#38598#30340#32593#31649#36335#24452#35774#32622
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 770
        Height = 542
        Align = alClient
        Caption = #32593#31649#21442#25968#35774#32622
        TabOrder = 0
        object Label21: TLabel
          Left = 18
          Top = 323
          Width = 96
          Height = 12
          Caption = #36828#31243#25968#25454#28304'('#32593#31649')'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label23: TLabel
          Left = 298
          Top = 356
          Width = 84
          Height = 12
          Caption = #25968#25454#28304#36741#21161#35828#26126
        end
        object Label24: TLabel
          Left = 648
          Top = 293
          Width = 36
          Height = 12
          Caption = #28304#24046#24322
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label26: TLabel
          Left = 209
          Top = 293
          Width = 48
          Height = 12
          Caption = #22478#24066#32534#21495
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label18: TLabel
          Left = 119
          Top = 293
          Width = 24
          Height = 12
          Caption = #24207#21495
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label19: TLabel
          Left = 18
          Top = 293
          Width = 24
          Height = 12
          Caption = #32452#21495
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label20: TLabel
          Left = 592
          Top = 356
          Width = 24
          Height = 12
          Caption = #22791#27880
        end
        object Label22: TLabel
          Left = 18
          Top = 356
          Width = 108
          Height = 12
          Caption = #32593#31649#21517#31216#21450#21578#35686#31867#22411
        end
        object Label25: TLabel
          Left = 345
          Top = 293
          Width = 84
          Height = 12
          Caption = #35266#23519#26102#38388'('#20998#38047')'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label28: TLabel
          Left = 489
          Top = 293
          Width = 96
          Height = 12
          Caption = #25968#25454#37319#38598#33539#22260'('#22825')'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Et_LAST_DATASOURCE: TEdit
          Left = 129
          Top = 319
          Width = 672
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ParentFont = False
          TabOrder = 0
        end
        object Et_TableName: TEdit
          Left = 392
          Top = 352
          Width = 185
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ParentFont = False
          TabOrder = 1
        end
        object Et_Increment_Column: TEdit
          Left = 696
          Top = 289
          Width = 105
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ParentFont = False
          TabOrder = 2
        end
        object DBGrid1: TDBGrid
          Left = 16
          Top = 22
          Width = 793
          Height = 243
          DataSource = Dm_Collect_Local.Ds_Collection_Cyc
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          TabOrder = 3
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
          OnCellClick = DBGrid1CellClick
          OnDrawColumnCell = DBGrid2DrawColumnCell
          OnKeyUp = DBGrid1KeyUp
          Columns = <
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'COLLECTIONKIND'
              Title.Alignment = taCenter
              Title.Caption = #32452#21495
              Title.Color = clSkyBlue
              Width = 26
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'COLLECTIONCODE'
              Title.Alignment = taCenter
              Title.Caption = #24207#21495
              Title.Color = clSkyBlue
              Width = 27
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'CITYID'
              Title.Alignment = taCenter
              Title.Caption = #22478#24066#21495
              Title.Color = clSkyBlue
              Width = 51
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'SETVALUE'
              Title.Alignment = taCenter
              Title.Caption = #35266#23519#26102#38388'('#20998#38047')'
              Title.Color = clSkyBlue
              Width = 88
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FORWARDDAY'
              Title.Alignment = taCenter
              Title.Caption = #25968#25454#37319#38598#33539#22260'('#22825')'
              Title.Color = clSkyBlue
              Width = 102
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'INCREMENT_COLUMN'
              Title.Alignment = taCenter
              Title.Caption = #28304#24046#24322
              Title.Color = clSkyBlue
              Width = 83
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'LAST_DATASOURCE'
              Title.Alignment = taCenter
              Title.Caption = #36828#31243#25968#25454#28304'('#32593#31649')'
              Title.Color = clSkyBlue
              Width = 190
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COLLECTIONNAME'
              Title.Alignment = taCenter
              Title.Caption = #32593#31649#21517#31216#21450#21578#35686#31867#22411
              Width = 131
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TABLENAME'
              Title.Alignment = taCenter
              Title.Caption = #25968#25454#28304#36741#21161#35828#26126
              Width = 189
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'REMARK'
              Title.Alignment = taCenter
              Title.Caption = #22791#27880
              Width = 67
              Visible = True
            end
            item
              Alignment = taCenter
              Expanded = False
              FieldName = 'OPERTIME'
              Title.Alignment = taCenter
              Title.Caption = #25805#20316#26102#38388
              Width = 122
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'OPERATOR'
              Title.Alignment = taCenter
              Title.Caption = #25805#20316#20154
              Width = 57
              Visible = True
            end>
        end
        object Bt_EditDbConn: TButton
          Left = 209
          Top = 396
          Width = 137
          Height = 25
          Caption = #37197#32622#25968#25454#24211#36830#25509
          TabOrder = 4
          OnClick = Bt_EditDbConnClick
        end
        object Bt_NewDbConn: TButton
          Left = 64
          Top = 396
          Width = 137
          Height = 25
          Caption = #37325#24314#25968#25454#24211#36830#25509
          TabOrder = 5
          OnClick = Bt_NewDbConnClick
        end
        object Bt_Append: TButton
          Tag = 3
          Left = 656
          Top = 396
          Width = 75
          Height = 25
          Caption = #22797#21046#34892
          TabOrder = 6
          OnClick = Bt_UpdateClick
        end
        object Bt_Delete: TButton
          Tag = 2
          Left = 576
          Top = 396
          Width = 75
          Height = 25
          Caption = #21024#38500#34892
          TabOrder = 7
          OnClick = Bt_UpdateClick
        end
        object Bt_Refrash: TButton
          Left = 416
          Top = 396
          Width = 75
          Height = 25
          Caption = #21047' '#26032
          TabOrder = 8
          OnClick = Bt_RefrashClick
        end
        object Bt_Update: TButton
          Tag = 1
          Left = 496
          Top = 396
          Width = 75
          Height = 25
          Caption = #26356#26032#34892
          TabOrder = 9
          OnClick = Bt_UpdateClick
        end
        object Et_CityID: TEdit
          Left = 268
          Top = 289
          Width = 61
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ParentFont = False
          TabOrder = 10
        end
        object Ed_COLLECTIONKIND: TEdit
          Left = 49
          Top = 289
          Width = 49
          Height = 20
          Color = cl3DLight
          Enabled = False
          TabOrder = 11
        end
        object Ed_COLLECTIONCODE: TEdit
          Left = 152
          Top = 289
          Width = 41
          Height = 20
          TabOrder = 12
        end
        object Edit3: TEdit
          Left = 632
          Top = 352
          Width = 169
          Height = 20
          TabOrder = 13
        end
        object Et_COLLECTIONNAME: TEdit
          Left = 128
          Top = 352
          Width = 161
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ParentFont = False
          TabOrder = 14
        end
        object Se_SetValue: TSpinEdit
          Left = 432
          Top = 289
          Width = 41
          Height = 21
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          MaxValue = 3600
          MinValue = 0
          ParentFont = False
          TabOrder = 15
          Value = 10
        end
        object Se_DataBound: TSpinEdit
          Left = 592
          Top = 289
          Width = 41
          Height = 21
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          MaxValue = 3600
          MinValue = 1
          ParentFont = False
          TabOrder = 16
          Value = 7
        end
      end
    end
  end
  object Timer_Scheduler: TTimer
    Enabled = False
    OnTimer = Timer_SchedulerTimer
    Left = 600
    Top = 120
  end
end
