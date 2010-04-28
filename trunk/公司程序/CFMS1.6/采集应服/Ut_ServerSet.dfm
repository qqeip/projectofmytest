object Fm_ServerSet: TFm_ServerSet
  Left = 383
  Top = 235
  Width = 364
  Height = 283
  Caption = #37319#38598#12289#24033#26816#26381#21153#37197#32622
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
    Width = 356
    Height = 256
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 75
      Top = 176
      Width = 60
      Height = 12
      Caption = #25968#25454#31471#21475#65306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 27
      Width = 120
      Height = 12
      Caption = 'Oracle'#25968#25454#24211#26381#21153#21517#65306
    end
    object Label3: TLabel
      Left = 40
      Top = 59
      Width = 96
      Height = 12
      Caption = #25968#25454#24211#30331#24405#29992#25143#65306
    end
    object Label4: TLabel
      Left = 52
      Top = 91
      Width = 84
      Height = 12
      Caption = #30331#24405#29992#25143#23494#30721#65306
    end
    object Label5: TLabel
      Left = 52
      Top = 145
      Width = 84
      Height = 12
      Caption = #26381#21153#22120'IP'#22320#22336#65306
    end
    object Label6: TLabel
      Left = 54
      Top = 116
      Width = 77
      Height = 13
      Caption = 'ServerGUID:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 77
      Top = 210
      Width = 75
      Height = 25
      Caption = #30830#23450
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 181
      Top = 210
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 2
      OnClick = Button2Click
    end
    object Ed_ComPort: TEdit
      Left = 144
      Top = 173
      Width = 163
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 0
      OnKeyPress = Ed_ComPortKeyPress
    end
    object Ed_ServiceName: TEdit
      Left = 144
      Top = 23
      Width = 163
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 3
    end
    object Ed_UserName: TEdit
      Left = 144
      Top = 55
      Width = 163
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 4
    end
    object Ed_Password: TEdit
      Left = 144
      Top = 87
      Width = 163
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 5
    end
    object Ed_IP: TEdit
      Left = 144
      Top = 141
      Width = 163
      Height = 20
      ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
      TabOrder = 6
    end
    object Ed_ServerGUID: TEdit
      Left = 144
      Top = 113
      Width = 163
      Height = 20
      TabOrder = 7
      Text = '{09AB7282-0FBA-4C16-81DC-B722CA94C7D1}'
    end
  end
end
