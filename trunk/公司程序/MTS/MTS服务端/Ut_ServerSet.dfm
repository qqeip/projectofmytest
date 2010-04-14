object Fm_ServerSet: TFm_ServerSet
  Left = 383
  Top = 235
  Caption = #24212#29992#26381#21153#37197#32622
  ClientHeight = 195
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 346
    Height = 195
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 51
      Top = 121
      Width = 108
      Height = 12
      Margins.Bottom = 0
      Caption = #23454#26102#28040#24687#25509#25910#31471#21475#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 39
      Top = 27
      Width = 120
      Height = 12
      Margins.Bottom = 0
      Caption = 'Oracle'#25968#25454#24211#26381#21153#21517#65306
    end
    object Label3: TLabel
      Left = 63
      Top = 59
      Width = 96
      Height = 12
      Margins.Bottom = 0
      Caption = #25968#25454#24211#30331#24405#29992#25143#65306
    end
    object Label4: TLabel
      Left = 75
      Top = 91
      Width = 84
      Height = 12
      Margins.Bottom = 0
      Caption = #30331#24405#29992#25143#23494#30721#65306
    end
    object Button1: TButton
      Left = 85
      Top = 154
      Width = 75
      Height = 25
      Caption = #30830#23450
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 189
      Top = 154
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 2
      OnClick = Button2Click
    end
    object Ed_ComPort: TEdit
      Left = 167
      Top = 118
      Width = 121
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 0
      OnKeyPress = Ed_ComPortKeyPress
    end
    object Ed_ServiceName: TEdit
      Left = 167
      Top = 23
      Width = 121
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 3
    end
    object Ed_UserName: TEdit
      Left = 167
      Top = 55
      Width = 121
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 4
    end
    object Ed_Password: TEdit
      Left = 167
      Top = 87
      Width = 121
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 5
    end
  end
end
