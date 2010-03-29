object FormConfigDB: TFormConfigDB
  Left = 416
  Top = 274
  Width = 385
  Height = 366
  Caption = 'FormConfigDB'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 361
    Height = 96
    Caption = #25968#25454#24211#20449#24687
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 28
      Top = 22
      Width = 48
      Height = 13
      Caption = #29992#25143#21517#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 28
      Top = 46
      Width = 48
      Height = 13
      Caption = #23494'    '#30721#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 28
      Top = 70
      Width = 48
      Height = 13
      Caption = #23454#20363#21517#65306
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EditDBName: TEdit
      Left = 109
      Top = 19
      Width = 221
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object EditDBPass: TEdit
      Left = 109
      Top = 43
      Width = 221
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object EditDBInstance: TEdit
      Left = 109
      Top = 67
      Width = 221
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 112
    Width = 361
    Height = 169
    Caption = #36873#25321#35201#22791#20221#30340#34920
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object CheckListBoxTables: TCheckListBox
      Left = 2
      Top = 15
      Width = 357
      Height = 152
      Align = alClient
      ItemHeight = 13
      PopupMenu = PopupMenu1
      TabOrder = 0
    end
  end
  object BtnConnTest: TButton
    Left = 47
    Top = 295
    Width = 75
    Height = 25
    Caption = #27979#35797#36830#25509
    TabOrder = 2
    OnClick = BtnConnTestClick
  end
  object BtnOK: TButton
    Left = 149
    Top = 295
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 3
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 252
    Top = 295
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 4
    OnClick = BtnCancelClick
  end
  object ADOConnection: TADOConnection
    LoginPrompt = False
    Left = 48
    Top = 192
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 208
    object CheckAll: TMenuItem
      Caption = #20840#37096#36873#23450
      OnClick = CheckAllClick
    end
    object CheckReverse: TMenuItem
      Caption = #21453#21521#36873#25321
      OnClick = CheckReverseClick
    end
  end
end
