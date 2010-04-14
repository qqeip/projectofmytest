object Fm_UserUpdate: TFm_UserUpdate
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #29992#25143#26356#26032
  ClientHeight = 405
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Gb_UserFun: TGroupBox
    Left = 272
    Top = 0
    Width = 262
    Height = 405
    Align = alRight
    Caption = #29992#25143#21151#33021#26435#38480
    TabOrder = 0
    object Panel3: TPanel
      Left = 2
      Top = 15
      Width = 258
      Height = 26
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object CB_FunAll: TCheckBox
        Left = 2
        Top = 3
        Width = 185
        Height = 17
        Caption = #21246#36873#25152#26377#21151#33021#36873#39033
        TabOrder = 0
        OnClick = CB_FunAllClick
      end
    end
    object CLB_function: TCheckListBox
      Left = 2
      Top = 41
      Width = 258
      Height = 362
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object GB_User: TGroupBox
    Left = 0
    Top = 0
    Width = 272
    Height = 405
    Align = alClient
    Caption = #29992#25143#22522#26412#20449#24687#65288'*'#20026#24517#22635#20449#24687#65289
    TabOrder = 1
    ExplicitLeft = -2
    object Label1: TLabel
      Left = 30
      Top = 61
      Width = 60
      Height = 13
      Caption = #29992#25143#24080#21495#65306
    end
    object Label2: TLabel
      Left = 30
      Top = 97
      Width = 60
      Height = 13
      Caption = #29992#25143#21517#31216#65306
    end
    object Label4: TLabel
      Left = 30
      Top = 174
      Width = 60
      Height = 13
      Caption = #24615'        '#21035#65306
    end
    object Label7: TLabel
      Left = 30
      Top = 210
      Width = 60
      Height = 13
      Caption = #37096'        '#38376#65306
    end
    object L_Email: TLabel
      Left = 30
      Top = 137
      Width = 60
      Height = 13
      Caption = #30005#23376#37038#20214#65306
    end
    object Label3: TLabel
      Left = 30
      Top = 246
      Width = 60
      Height = 13
      Caption = #21150#20844#30005#35805#65306
    end
    object Label6: TLabel
      Left = 30
      Top = 283
      Width = 60
      Height = 13
      Caption = #25163'        '#26426#65306
    end
    object Label5: TLabel
      Left = 15
      Top = 62
      Width = 6
      Height = 12
      Caption = '*'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 15
      Top = 98
      Width = 6
      Height = 12
      Caption = '*'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Button2: TButton
      Left = 168
      Top = 328
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 0
      OnClick = Button2Click
    end
    object Edt_accounts: TEdit
      Left = 96
      Top = 58
      Width = 150
      Height = 21
      TabOrder = 1
    end
    object Edt_name: TEdit
      Left = 96
      Top = 94
      Width = 150
      Height = 21
      TabOrder = 2
    end
    object Edt_email: TEdit
      Left = 96
      Top = 134
      Width = 150
      Height = 21
      TabOrder = 3
    end
    object Edt_dep: TEdit
      Left = 96
      Top = 207
      Width = 150
      Height = 21
      TabOrder = 4
    end
    object Edt_OP: TEdit
      Left = 96
      Top = 243
      Width = 150
      Height = 21
      TabOrder = 5
      OnKeyPress = Edt_OPKeyPress
    end
    object Edt_MP: TEdit
      Left = 96
      Top = 280
      Width = 150
      Height = 21
      TabOrder = 6
      OnKeyPress = Edt_MPKeyPress
    end
    object Btn_Save: TButton
      Left = 30
      Top = 328
      Width = 75
      Height = 25
      Caption = #20445#23384
      TabOrder = 7
      OnClick = Btn_SaveClick
    end
    object Cmb_Sex: TComboBox
      Left = 96
      Top = 171
      Width = 150
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 8
      Text = #30007
      Items.Strings = (
        #30007
        #22899)
    end
  end
end
