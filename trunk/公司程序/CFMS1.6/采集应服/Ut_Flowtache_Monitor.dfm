object Fm_FlowMonitor: TFm_FlowMonitor
  Left = 281
  Top = 90
  Width = 861
  Height = 604
  Caption = #21518#21488#36816#34892#32447#31243#31649#29702#31383#21475
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
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 853
    Height = 577
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = '@'#23435#20307
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    TabPosition = tpRight
    TabWidth = 110
    object TabSheet1: TTabSheet
      Caption = #21518#21488#32447#31243#31649#29702
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 827
        Height = 569
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object GroupBox6: TGroupBox
          Left = 0
          Top = 474
          Width = 827
          Height = 95
          Align = alBottom
          Caption = #36807#31243#24037#20316#29366#24577#26631#24535#25353#38062
          TabOrder = 0
          object Bt_RepStat: TButton
            Tag = 3
            Left = 26
            Top = 28
            Width = 57
            Height = 25
            Caption = #25925#38556#25253#34920
            TabOrder = 0
          end
          object Bt_FlowLog: TButton
            Tag = 1
            Left = 94
            Top = 28
            Width = 57
            Height = 25
            Caption = #27969#31243#26085#24535
            TabOrder = 1
          end
          object Bt_ItemCompute: TButton
            Tag = 1
            Left = 164
            Top = 28
            Width = 57
            Height = 25
            Caption = #23454#26102#25351#26631
            TabOrder = 2
          end
          object Bt_AlarmReSend: TButton
            Tag = 2
            Left = 233
            Top = 28
            Width = 57
            Height = 25
            Caption = #20877#27966#38556
            TabOrder = 3
          end
          object bt_BreakSite: TButton
            Tag = 3
            Left = 447
            Top = 28
            Width = 57
            Height = 25
            Caption = #26029#31449#29575
            TabOrder = 4
            Visible = False
            OnClick = bt_BreakSiteClick
          end
          object Btn_POP: TButton
            Tag = 3
            Left = 303
            Top = 28
            Width = 57
            Height = 25
            Caption = 'POP'#21516#27493
            TabOrder = 5
          end
          object bt_AlarmRing: TButton
            Tag = 3
            Left = 519
            Top = 28
            Width = 57
            Height = 25
            Caption = #21709#38083
            TabOrder = 6
            Visible = False
            OnClick = bt_AlarmRingClick
          end
          object btAlarmAdjust: TButton
            Tag = 3
            Left = 375
            Top = 28
            Width = 57
            Height = 25
            Caption = #21578#35686#20462#27491
            TabOrder = 7
            OnClick = btAlarmAdjustClick
          end
          object btAlarmView: TButton
            Tag = 3
            Left = 591
            Top = 28
            Width = 57
            Height = 25
            Caption = #30417#25511#22266#21270
            TabOrder = 8
            Visible = False
            OnClick = btAlarmViewClick
          end
        end
        object GroupBox4: TGroupBox
          Left = 0
          Top = 0
          Width = 827
          Height = 177
          Align = alTop
          Caption = #22823#20107#21153#25490#38431#32447#31243#31649#29702
          TabOrder = 1
          object GroupBox1: TGroupBox
            Left = 32
            Top = 24
            Width = 777
            Height = 65
            Caption = #25925#38556#25253#34920#32479#35745#21442#25968#35774#32622
            TabOrder = 0
            object Label9: TLabel
              Left = 24
              Top = 31
              Width = 91
              Height = 14
              Caption = #26085#25253#32479#35745#26102#38388' '
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -14
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Dtp_RepStatTime: TDateTimePicker
              Left = 144
              Top = 28
              Width = 113
              Height = 20
              Date = 38734.564703240740000000
              Format = 'HH:mm'
              Time = 38734.564703240740000000
              ImeName = #20013#25991' ('#31616#20307') - '#29579#30721#20116#31508#22411'98'#29256
              Kind = dtkTime
              TabOrder = 0
            end
            object Bt_SaveRepSet: TButton
              Left = 680
              Top = 25
              Width = 75
              Height = 26
              Caption = #20445#23384#35774#32622
              TabOrder = 1
              OnClick = Bt_SaveRepSetClick
            end
            object Cb_IsAutoStat: TCheckBox
              Tag = 1
              Left = 565
              Top = 30
              Width = 97
              Height = 17
              Caption = #26159#21542#33258#21160#32479#35745
              TabOrder = 2
              OnClick = Cb_IsAutoStatClick
            end
            object Bt_Immediately: TButton
              Left = 313
              Top = 26
              Width = 169
              Height = 25
              Caption = #31435#21363#25191#34892#27966#38556#25253#34920#32479#35745#19968#27425
              TabOrder = 3
              Visible = False
              OnClick = Bt_ImmediatelyClick
            end
            object Button3: TButton
              Left = 488
              Top = 26
              Width = 49
              Height = 25
              Caption = #27979#35797
              TabOrder = 4
              OnClick = Button3Click
            end
          end
          object GroupBox3: TGroupBox
            Left = 32
            Top = 97
            Width = 777
            Height = 67
            Caption = #27969#31243#26085#24535#31649#29702
            TabOrder = 1
            object Label1: TLabel
              Left = 278
              Top = 34
              Width = 56
              Height = 14
              Caption = #33258#21160#28165#38500
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -14
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 392
              Top = 34
              Width = 126
              Height = 14
              Caption = #22825#21069#30340#22312#32447#27969#31243#26085#24535
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -14
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 24
              Top = 36
              Width = 112
              Height = 14
              Caption = #28165#38500#27969#31243#26085#24535#26102#38388
              Font.Charset = ANSI_CHARSET
              Font.Color = clWindowText
              Font.Height = -14
              Font.Name = #23435#20307
              Font.Style = []
              ParentFont = False
            end
            object Btn_Save: TButton
              Left = 682
              Top = 25
              Width = 75
              Height = 26
              Caption = #20445#23384#35774#32622
              TabOrder = 0
              OnClick = Btn_SaveClick
            end
            object edtClearDay: TEdit
              Left = 342
              Top = 31
              Width = 44
              Height = 20
              ImeName = #20013#25991' ('#31616#20307') - '#29579#30721#20116#31508#22411'98'#29256
              TabOrder = 1
              OnKeyPress = edtClearDayKeyPress
            end
            object CB_AutoClear: TCheckBox
              Tag = 3
              Left = 567
              Top = 33
              Width = 97
              Height = 17
              Caption = #26159#21542#33258#21160#28165#38500
              TabOrder = 2
              OnClick = Cb_IsAutoStatClick
            end
            object DTP_ClearTime: TDateTimePicker
              Left = 144
              Top = 32
              Width = 113
              Height = 20
              Date = 38734.564703240740000000
              Format = 'HH:mm'
              Time = 38734.564703240740000000
              ImeName = #20013#25991' ('#31616#20307') - '#29579#30721#20116#31508#22411'98'#29256
              Kind = dtkTime
              TabOrder = 3
            end
          end
        end
        object GroupBox5: TGroupBox
          Left = 0
          Top = 233
          Width = 827
          Height = 57
          Align = alTop
          Caption = #26029#31449#29575#32479#35745
          TabOrder = 2
          Visible = False
          object cbBreakState: TCheckBox
            Tag = 25
            Left = 542
            Top = 26
            Width = 113
            Height = 17
            Caption = #26159#21542#33258#21160#32479#35745
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object btBreakState: TButton
            Left = 715
            Top = 15
            Width = 83
            Height = 26
            Caption = #20445#23384#35774#32622
            TabOrder = 1
            OnClick = btBreakStateClick
          end
        end
        object Gb_in_phase: TGroupBox
          Tag = 60000
          Left = 0
          Top = 290
          Width = 827
          Height = 56
          Align = alTop
          Caption = #26032#21578#35686#25552#37266
          TabOrder = 3
          Visible = False
          object cbAlarmRing: TCheckBox
            Tag = 600
            Left = 541
            Top = 23
            Width = 156
            Height = 17
            Caption = #26159#21542#21551#29992
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object btAlarmRing: TButton
            Left = 718
            Top = 17
            Width = 78
            Height = 26
            Caption = #20445#23384#35774#32622
            TabOrder = 1
            OnClick = btAlarmRingClick
          end
        end
        object GroupBox7: TGroupBox
          Left = 0
          Top = 177
          Width = 827
          Height = 56
          Align = alTop
          Caption = 'POP'#25968#25454#21516#27493#35774#32622
          TabOrder = 4
          object P_Sync: TLabel
            Left = 55
            Top = 24
            Width = 514
            Height = 18
            AutoSize = False
            Caption = #21516#27493#20449#24687#25552#31034
          end
          object Btn_PopSet: TButton
            Left = 715
            Top = 18
            Width = 83
            Height = 26
            Caption = #20445#23384#35774#32622
            TabOrder = 0
            OnClick = Btn_PopSetClick
          end
          object CB_Pop: TCheckBox
            Tag = 3
            Left = 547
            Top = 24
            Width = 116
            Height = 17
            Caption = #26159#21542#33258#21160#21516#27493#25968#25454
            TabOrder = 1
            OnClick = CB_PopClick
          end
        end
        object GroupBox8: TGroupBox
          Tag = 60000
          Left = 0
          Top = 346
          Width = 827
          Height = 56
          Align = alTop
          Caption = #37325#22797#21578#35686#37319#38598
          TabOrder = 5
          Visible = False
          object Label8: TLabel
            Left = 682
            Top = 23
            Width = 28
            Height = 14
            Caption = #20998#38047
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -14
            Font.Name = #23435#20307
            Font.Style = []
            ParentFont = False
          end
          object cbAlarmAdjust: TCheckBox
            Tag = 600
            Left = 540
            Top = 23
            Width = 76
            Height = 17
            Caption = #26159#21542#21551#29992
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object Button1: TButton
            Left = 718
            Top = 17
            Width = 78
            Height = 26
            Caption = #35774#32622#38388#38548
            TabOrder = 1
            OnClick = Button1Click
          end
          object eAlarmAdjust: TEdit
            Left = 632
            Top = 20
            Width = 44
            Height = 20
            ImeName = #20013#25991' ('#31616#20307') - '#29579#30721#20116#31508#22411'98'#29256
            TabOrder = 2
            Text = '15'
            OnKeyPress = eAlarmAdjustKeyPress
          end
        end
        object GroupBox9: TGroupBox
          Tag = 60000
          Left = 0
          Top = 402
          Width = 827
          Height = 56
          Align = alTop
          Caption = #21578#35686#30417#25511#22266#21270#35270#22270#32447#31243
          TabOrder = 6
          Visible = False
          object cbAlarmMonitorView: TCheckBox
            Tag = 600
            Left = 541
            Top = 23
            Width = 156
            Height = 17
            Caption = #26159#21542#21551#29992
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object Button2: TButton
            Left = 718
            Top = 17
            Width = 78
            Height = 26
            Caption = #20445#23384#35774#32622
            TabOrder = 1
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #21516#27493#32447#31243#21442#25968#35774#32622
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      object Label3: TLabel
        Left = 17
        Top = 278
        Width = 72
        Height = 12
        Caption = #25191#34892#32447#31243#21517#31216
      end
      object Label4: TLabel
        Left = 646
        Top = 278
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
      object Label6: TLabel
        Left = 18
        Top = 318
        Width = 36
        Height = 12
        Caption = #22791'  '#27880
      end
      object Label7: TLabel
        Left = 33
        Top = 392
        Width = 264
        Height = 12
        Caption = #27880#65306#20197#19978#20449#24687#26356#26032#21518#65292#22312#31995#32479#37325#26032#21551#21160#21518#26041#33021#29983#25928
      end
      object Label25: TLabel
        Left = 646
        Top = 318
        Width = 84
        Height = 12
        Caption = #25195#25551#38388#27463'('#27627#31186')'
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object DBGrid2: TDBGrid
        Left = 16
        Top = 22
        Width = 793
        Height = 227
        DataSource = Dm_Collect_Local.Ds_Synchronize_Cfg
        ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #23435#20307
        TitleFont.Style = []
        OnCellClick = DBGrid2CellClick
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
            Width = 95
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COLLECTORDER'
            Title.Caption = #25195#25551#38388#27463'('#27627#31186')'
            Width = 90
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'STARTTIME'
            Title.Alignment = taCenter
            Title.Caption = #26412#27425#25195#25551#24320#22987#26102#38388
            Width = 133
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'LASTMODIFY'
            Title.Alignment = taCenter
            Title.Caption = #21442#25968#20462#25913#26102#38388
            Width = 126
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MENDER'
            Title.Alignment = taCenter
            Title.Caption = #26368#21518#20462#25913#20154
            Width = 72
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
        Left = 744
        Top = 274
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
        Top = 274
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
      object Edit1: TEdit
        Left = 96
        Top = 314
        Width = 489
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
        Left = 696
        Top = 381
        Width = 75
        Height = 25
        Caption = #26356#26032#34892
        TabOrder = 4
        OnClick = Bt_UpdCfgClick
      end
      object Bt_RefCfg: TButton
        Left = 568
        Top = 381
        Width = 75
        Height = 25
        Caption = #21047' '#26032
        TabOrder = 5
        OnClick = Bt_RefCfgClick
      end
      object Rg_ISCREATE: TRadioGroup
        Left = 288
        Top = 267
        Width = 145
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
        Left = 448
        Top = 267
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
      object Se_Sleep: TSpinEdit
        Left = 744
        Top = 314
        Width = 55
        Height = 21
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        MaxValue = 10000000
        MinValue = 1
        ParentFont = False
        TabOrder = 8
        Value = 50
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'POP'#25968#25454#24211#36335#24452#35774#32622
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 827
        Height = 569
        Align = alClient
        Caption = 'POP'#24211#36335#24452#35774#32622
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label21: TLabel
          Left = 18
          Top = 322
          Width = 90
          Height = 12
          Caption = #36828#31243#25968#25454#28304'(POP)'
          Font.Charset = GB2312_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ParentFont = False
        end
        object Label23: TLabel
          Left = 18
          Top = 355
          Width = 84
          Height = 12
          Caption = #25968#25454#28304#36741#21161#35828#26126
        end
        object Label26: TLabel
          Left = 185
          Top = 292
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
          Left = 103
          Top = 292
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
          Top = 292
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
          Left = 488
          Top = 355
          Width = 24
          Height = 12
          Caption = #22791#27880
        end
        object Label22: TLabel
          Left = 343
          Top = 293
          Width = 54
          Height = 12
          Caption = 'POP'#24211#21517#31216
        end
        object Label24: TLabel
          Left = 17
          Top = 464
          Width = 264
          Height = 12
          Caption = #27880#65306#20197#19978#20449#24687#26356#26032#21518#65292#22312#31995#32479#37325#26032#21551#21160#21518#26041#33021#29983#25928
        end
        object Label27: TLabel
          Left = 624
          Top = 296
          Width = 84
          Height = 12
          Caption = #32593#20803#22320#22336#20998#21106#31526
        end
        object Et_LAST_DATASOURCE: TEdit
          Left = 129
          Top = 318
          Width = 680
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
          Left = 130
          Top = 351
          Width = 303
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
        object DBGrid1: TDBGrid
          Left = 16
          Top = 29
          Width = 793
          Height = 164
          DataSource = Dm_Collect_Local.Ds_SynchronizePOP
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 2
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
          OnCellClick = DBGrid1CellClick
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
              FieldName = 'LAST_DATASOURCE'
              Title.Alignment = taCenter
              Title.Caption = #36828#31243#25968#25454#28304'(POP)'
              Title.Color = clSkyBlue
              Width = 190
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COLLECTIONNAME'
              Title.Alignment = taCenter
              Title.Caption = 'POP'#24211#21517#31216
              Width = 147
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
              Width = 42
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'INCREMENT_COLUMN'
              Title.Caption = #32593#20803#22320#22336#20998#21106#31526
              Width = 90
              Visible = True
            end>
        end
        object Bt_EditDbConn: TButton
          Left = 336
          Top = 397
          Width = 137
          Height = 25
          Caption = #37197#32622#25968#25454#24211#36830#25509
          TabOrder = 3
          OnClick = Bt_EditDbConnClick
        end
        object Bt_NewDbConn: TButton
          Left = 191
          Top = 397
          Width = 137
          Height = 25
          Caption = #37325#24314#25968#25454#24211#36830#25509
          TabOrder = 4
          OnClick = Bt_NewDbConnClick
        end
        object Bt_Append: TButton
          Tag = 3
          Left = 735
          Top = 397
          Width = 75
          Height = 25
          Caption = #22797#21046#34892
          TabOrder = 5
          OnClick = Bt_UpdateClick
        end
        object Bt_Delete: TButton
          Tag = 2
          Left = 655
          Top = 397
          Width = 75
          Height = 25
          Caption = #21024#38500#34892
          TabOrder = 6
          OnClick = Bt_UpdateClick
        end
        object Bt_Refrash: TButton
          Left = 495
          Top = 397
          Width = 75
          Height = 25
          Caption = #21047' '#26032
          TabOrder = 7
          OnClick = Bt_RefrashClick
        end
        object Bt_Update: TButton
          Tag = 1
          Left = 575
          Top = 397
          Width = 75
          Height = 25
          Caption = #26356#26032#34892
          TabOrder = 8
          OnClick = Bt_UpdateClick
        end
        object Et_CityID: TEdit
          Left = 244
          Top = 288
          Width = 93
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ParentFont = False
          TabOrder = 9
        end
        object Ed_COLLECTIONKIND: TEdit
          Left = 49
          Top = 288
          Width = 49
          Height = 20
          Color = cl3DLight
          Enabled = False
          TabOrder = 10
        end
        object Ed_COLLECTIONCODE: TEdit
          Left = 136
          Top = 288
          Width = 41
          Height = 20
          TabOrder = 11
        end
        object Et_Remark: TEdit
          Left = 528
          Top = 351
          Width = 281
          Height = 20
          TabOrder = 12
        end
        object Et_COLLECTIONNAME: TEdit
          Left = 405
          Top = 291
          Width = 212
          Height = 20
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = #23435#20307
          Font.Style = []
          ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
          ParentFont = False
          TabOrder = 13
        end
        object GB_poptable: TGroupBox
          Left = 16
          Top = 208
          Width = 793
          Height = 52
          Caption = #38656#21516#27493#25968#25454
          TabOrder = 14
          object clb_poptable: TCheckListBox
            Left = 2
            Top = 14
            Width = 783
            Height = 35
            BorderStyle = bsNone
            Color = cl3DLight
            Columns = 5
            ItemHeight = 12
            Items.Strings = (
              'pop_area'
              'pop_cstype'
              'pop_cslevel'
              'pop_status'
              'pop_powertype'
              'alarm_cs_detail_view'
              'installinfo2'
              'pop_grpctrl_view'
              'pop_material')
            TabOrder = 0
          end
        end
        object Ed_NetAddress: TEdit
          Left = 716
          Top = 291
          Width = 93
          Height = 20
          MaxLength = 50
          TabOrder = 15
        end
      end
    end
  end
  object RunLog_Timer: TTimer
    Enabled = False
    OnTimer = RunLog_TimerTimer
    Left = 144
    Top = 136
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = RunLog_TimerTimer
    Left = 144
    Top = 136
  end
end
