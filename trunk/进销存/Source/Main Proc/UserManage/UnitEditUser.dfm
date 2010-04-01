object FormEditUser: TFormEditUser
  Left = 417
  Top = 298
  Width = 393
  Height = 413
  Caption = #32534#35793#29992#25143
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pgc1: TPageControl
    Left = 6
    Top = 6
    Width = 378
    Height = 338
    ActivePage = ts1
    Style = tsFlatButtons
    TabOrder = 0
    object ts1: TTabSheet
      Caption = #25805#20316#21592#20449#24687
      object grp1: TGroupBox
        Left = 48
        Top = 37
        Width = 265
        Height = 209
        TabOrder = 0
        object lblUserLevel: TLabel
          Left = 19
          Top = 129
          Width = 150
          Height = 13
          AutoSize = False
          Caption = #25805#20316#21592#32423#21035#65306
        end
        object cbbUserLevel: TComboBox
          Left = 19
          Top = 147
          Width = 198
          Height = 21
          Style = csDropDownList
          ImeName = '???????'
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbbUserLevelChange
          Items.Strings = (
            #31649#29702#21592
            #33829#19994#21592)
        end
        object lbledtUserName: TLabeledEdit
          Left = 19
          Top = 40
          Width = 198
          Height = 21
          EditLabel.Width = 72
          EditLabel.Height = 13
          EditLabel.Caption = #25805#20316#21592#22995#21517#65306
          ImeName = '???????'
          TabOrder = 1
        end
        object lbledtPassword: TLabeledEdit
          Left = 19
          Top = 92
          Width = 198
          Height = 21
          EditLabel.Width = 72
          EditLabel.Height = 13
          EditLabel.Caption = #25805#20316#21592#23494#30721#65306
          ImeName = '???????'
          PasswordChar = '*'
          TabOrder = 2
        end
      end
    end
    object ts2: TTabSheet
      Caption = #25805#20316#21592#26435#38480
      ImageIndex = 1
      object GRPRepertoryMgr: TGroupBox
        Left = 1
        Top = 81
        Width = 365
        Height = 38
        Caption = #24211#23384#20449#24687#31649#29702
        TabOrder = 0
        object CHKRepertoryQuery: TCheckBox
          Left = 11
          Top = 16
          Width = 115
          Height = 17
          Caption = #24211#23384#26597#35810
          TabOrder = 0
        end
        object CHKRepertoryStat: TCheckBox
          Left = 127
          Top = 16
          Width = 115
          Height = 17
          Caption = #24211#23384#27719#24635
          TabOrder = 1
        end
      end
      object GRPInformationMgr: TGroupBox
        Left = 1
        Top = 0
        Width = 365
        Height = 80
        Caption = #36164#26009#31649#29702
        TabOrder = 1
        object CHKDepotInfoMgr: TCheckBox
          Left = 11
          Top = 17
          Width = 115
          Height = 17
          Caption = #20179#24211#20449#24687#31649#29702
          TabOrder = 0
        end
        object CHKAssociatorTypeInfoMgr: TCheckBox
          Left = 127
          Top = 17
          Width = 115
          Height = 17
          Caption = #20250#21592#32423#21035#31649#29702
          TabOrder = 1
        end
        object CHKProviderInfoMgr: TCheckBox
          Left = 243
          Top = 17
          Width = 118
          Height = 17
          Caption = #36827#36135#21830#20449#24687#31649#29702
          TabOrder = 2
        end
        object CHKCustomerInfoMgr: TCheckBox
          Left = 11
          Top = 37
          Width = 115
          Height = 17
          Caption = #23458#25143#36164#26009#31649#29702
          TabOrder = 3
        end
        object CHKGoodsTypeInfo: TCheckBox
          Left = 127
          Top = 37
          Width = 115
          Height = 17
          Caption = #21830#21697#31867#21035#31649#29702
          TabOrder = 4
        end
        object CHKInDepotTypeMgr: TCheckBox
          Left = 243
          Top = 37
          Width = 115
          Height = 17
          Caption = #20837#24211#31867#22411#31649#29702
          TabOrder = 5
        end
        object CHKOutDepotTypeMgr: TCheckBox
          Left = 11
          Top = 58
          Width = 115
          Height = 17
          Caption = #20986#24211#31867#22411#31649#29702
          TabOrder = 6
        end
      end
      object GRPInDepotMgr: TGroupBox
        Left = 1
        Top = 124
        Width = 365
        Height = 38
        Caption = #20837#24211#20449#24687#31649#29702
        TabOrder = 2
        object CHKInDepotMgr: TCheckBox
          Left = 11
          Top = 16
          Width = 115
          Height = 17
          Caption = #20837#24211#31649#29702
          TabOrder = 0
        end
        object CHKInDepotStat: TCheckBox
          Left = 127
          Top = 16
          Width = 115
          Height = 17
          Caption = #20837#24211#20449#24687#32479#35745
          TabOrder = 1
        end
      end
      object GRPDataAnalyse: TGroupBox
        Left = 1
        Top = 210
        Width = 365
        Height = 38
        Caption = #25968#25454#20998#26512
        TabOrder = 3
        object CHKCustomAnalyse: TCheckBox
          Left = 11
          Top = 16
          Width = 115
          Height = 17
          Caption = #33258#23450#20041#20998#26512#32479#35745
          TabOrder = 0
        end
        object CHKBalanceAnalyse: TCheckBox
          Left = 127
          Top = 16
          Width = 115
          Height = 17
          Caption = #24211#23384#24179#34913#20998#26512
          TabOrder = 1
        end
        object CHKRepertoryAnalyse: TCheckBox
          Left = 243
          Top = 16
          Width = 115
          Height = 17
          Caption = #24211#23384#24179#34913#20998#26512
          TabOrder = 2
        end
      end
      object GRPOutDepotMgr: TGroupBox
        Left = 1
        Top = 167
        Width = 365
        Height = 38
        Caption = #20986#24211#20449#24687#31649#29702
        TabOrder = 4
        object CHKOutDepotMgr: TCheckBox
          Left = 11
          Top = 16
          Width = 115
          Height = 17
          Caption = #20986#24211#31649#29702
          TabOrder = 0
        end
        object CHKOutDepotStat: TCheckBox
          Left = 127
          Top = 16
          Width = 115
          Height = 17
          Caption = #20986#24211#20449#24687#32479#35745
          TabOrder = 1
        end
      end
      object GRPUserMgr: TGroupBox
        Left = 1
        Top = 253
        Width = 365
        Height = 53
        Caption = #25805#20316#21592#31649#29702
        TabOrder = 5
        object CHKUserMgr: TCheckBox
          Left = 11
          Top = 16
          Width = 115
          Height = 17
          Caption = #25805#20316#21592#31649#29702
          TabOrder = 0
        end
        object CHKUserChangePass: TCheckBox
          Left = 127
          Top = 16
          Width = 122
          Height = 17
          Caption = #25805#20316#21592#23494#30721#20462#25913
          TabOrder = 1
        end
        object CHKSystemLock: TCheckBox
          Left = 11
          Top = 32
          Width = 115
          Height = 17
          Caption = #38145#23450#31995#32479
          TabOrder = 2
        end
        object CHKLogOut: TCheckBox
          Left = 127
          Top = 32
          Width = 115
          Height = 17
          Caption = #27880#38144#29992#25143
          TabOrder = 3
        end
      end
    end
  end
  object btnOK: TButton
    Left = 167
    Top = 346
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 257
    Top = 346
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
