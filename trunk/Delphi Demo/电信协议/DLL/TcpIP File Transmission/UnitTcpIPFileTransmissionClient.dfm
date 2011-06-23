object FormTcpIPFileTransmissionClint: TFormTcpIPFileTransmissionClint
  Left = 268
  Top = 145
  Width = 363
  Height = 250
  Caption = 'FormTcpIPFileTransmissionClint'
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label_IP: TLabel
    Left = 25
    Top = 21
    Width = 70
    Height = 13
    AutoSize = False
    Caption = 'IP:'
  end
  object Label_Port: TLabel
    Left = 25
    Top = 46
    Width = 70
    Height = 13
    AutoSize = False
    Caption = 'Port:'
  end
  object Label1CurFilePath: TLabel
    Left = 25
    Top = 70
    Width = 70
    Height = 13
    AutoSize = False
    Caption = 'CurFilePath:'
  end
  object LabelSerFilePath: TLabel
    Left = 25
    Top = 95
    Width = 70
    Height = 13
    AutoSize = False
    Caption = 'SerFilePath:'
  end
  object Label_CurFileName: TLabel
    Left = 25
    Top = 119
    Width = 70
    Height = 13
    AutoSize = False
    Caption = 'CurFileName:'
  end
  object btnBtn_CurFilePath: TSpeedButton
    Left = 327
    Top = 66
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = btnBtn_CurFilePathClick
  end
  object btnBtn_SerFilePath: TSpeedButton
    Left = 327
    Top = 91
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = btnBtn_SerFilePathClick
  end
  object Label_SerFileName: TLabel
    Left = 25
    Top = 144
    Width = 70
    Height = 13
    AutoSize = False
    Caption = 'SerFileName:'
  end
  object BtnTransmission: TButton
    Left = 164
    Top = 184
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = BtnTransmissionClick
  end
  object Edt_IP: TEdit
    Left = 96
    Top = 16
    Width = 225
    Height = 21
    TabOrder = 1
    Text = '10.0.0.205'
  end
  object Edt_Port: TEdit
    Left = 96
    Top = 41
    Width = 225
    Height = 21
    TabOrder = 2
    Text = '991'
  end
  object Edt_CurFilePath: TEdit
    Left = 96
    Top = 66
    Width = 225
    Height = 21
    TabOrder = 3
    Text = 'D:\'
  end
  object Edt_SerFilePath: TEdit
    Left = 96
    Top = 90
    Width = 225
    Height = 21
    TabOrder = 4
    Text = 'D:\'
  end
  object Edt_CurFileName: TEdit
    Left = 96
    Top = 115
    Width = 225
    Height = 21
    TabOrder = 5
    Text = 'Edt_CurFileName'
  end
  object CheckBox_ShowFlag: TCheckBox
    Left = 96
    Top = 162
    Width = 169
    Height = 17
    Caption = #26159#21542#26174#31034#36827#24230#26465#31383#21475
    TabOrder = 6
  end
  object btnBtn_Close: TButton
    Left = 246
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 7
  end
  object Edt_SerFileName: TEdit
    Left = 96
    Top = 140
    Width = 225
    Height = 21
    TabOrder = 8
    Text = '2000.jpg'
  end
  object IdTCPClientDowFiles: TIdTCPClient
    MaxLineAction = maException
    ReadTimeout = 0
    Port = 0
    Left = 280
    Top = 18
  end
end
