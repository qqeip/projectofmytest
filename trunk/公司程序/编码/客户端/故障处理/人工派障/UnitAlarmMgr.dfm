object FormAlarmMgr: TFormAlarmMgr
  Left = 480
  Top = 181
  Width = 358
  Height = 227
  Caption = #21578#35686#31649#29702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 150
    Top = 155
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
    OnClick = cxButton1Click
  end
  object cxButton2: TcxButton
    Left = 258
    Top = 155
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = cxButton2Click
  end
  object cxGroupBox1: TcxGroupBox
    Left = 8
    Top = 8
    Caption = #21578#35686#20869#23481
    TabOrder = 2
    Height = 133
    Width = 337
    object Label1: TLabel
      Left = 11
      Top = 60
      Width = 62
      Height = 13
      AutoSize = False
      Caption = #21578#35686#31561#32423
    end
    object Label2: TLabel
      Left = 11
      Top = 94
      Width = 62
      Height = 13
      AutoSize = False
      Caption = #21578#35686#31867#22411
    end
    object Label3: TLabel
      Left = 157
      Top = 60
      Width = 90
      Height = 13
      AutoSize = False
      Caption = #26159#21542#33258#21160#28040#38556
    end
    object Label4: TLabel
      Left = 157
      Top = 94
      Width = 90
      Height = 13
      AutoSize = False
      Caption = #26159#21542#33258#21160#25552#20132
    end
    object Label5: TLabel
      Left = 11
      Top = 29
      Width = 90
      Height = 13
      AutoSize = False
      Caption = #21578#35686#20869#23481#21517#31216
    end
    object CbbAlarmLevel: TcxComboBox
      Left = 71
      Top = 57
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 0
      Width = 80
    end
    object CbbAlarmType: TcxComboBox
      Left = 71
      Top = 90
      Properties.DropDownListStyle = lsFixedList
      TabOrder = 1
      Width = 80
    end
    object CbbIsAutoWrecker: TcxComboBox
      Left = 245
      Top = 57
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #21542
        #26159)
      TabOrder = 2
      Text = #21542
      Width = 80
    end
    object CbbIsAutoCommit: TcxComboBox
      Left = 245
      Top = 90
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        #21542
        #26159)
      TabOrder = 3
      Text = #21542
      Width = 80
    end
    object EdtAlarmName: TcxTextEdit
      Left = 104
      Top = 27
      TabOrder = 4
      Width = 221
    end
  end
end
