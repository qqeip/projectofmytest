object FormFtpLoad: TFormFtpLoad
  Left = 321
  Top = 232
  Width = 688
  Height = 456
  Caption = 'Ftp'#19978#20256#19979#36733
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox4: TGroupBox
    Left = 0
    Top = 0
    Width = 680
    Height = 129
    Align = alTop
    Caption = 'FTP'#35774#32622
    TabOrder = 0
    object Label1: TLabel
      Left = 50
      Top = 24
      Width = 50
      Height = 13
      AutoSize = False
      Caption = 'FTP'#22320#22336#65306
    end
    object Label2: TLabel
      Left = 50
      Top = 48
      Width = 50
      Height = 13
      AutoSize = False
      Caption = #29992#25143#21517#65306
    end
    object Label3: TLabel
      Left = 50
      Top = 73
      Width = 50
      Height = 13
      AutoSize = False
      Caption = #23494#30721#65306
    end
    object Label6: TLabel
      Left = 50
      Top = 97
      Width = 50
      Height = 13
      AutoSize = False
      Caption = #31471#21475#65306
    end
    object Edt_FTPAddr: TEdit
      Left = 116
      Top = 21
      Width = 146
      Height = 21
      TabOrder = 0
      Text = '10.0.0.205'
    end
    object Edt_FTPUser: TEdit
      Left = 116
      Top = 45
      Width = 146
      Height = 21
      TabOrder = 1
      Text = 'administrator'
    end
    object Edt_FTPPass: TEdit
      Left = 116
      Top = 70
      Width = 146
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
      Text = 'pmj888666'
    end
    object Btn_TestLink: TButton
      Left = 374
      Top = 20
      Width = 75
      Height = 25
      Caption = #27979#35797#36830#25509
      TabOrder = 3
      OnClick = Btn_TestLinkClick
    end
    object Btn_Save: TButton
      Left = 374
      Top = 53
      Width = 75
      Height = 25
      Caption = #20445#23384
      TabOrder = 4
      OnClick = Btn_SaveClick
    end
    object Edt_FTPPort: TEdit
      Left = 116
      Top = 94
      Width = 146
      Height = 21
      TabOrder = 5
      Text = '21'
    end
    object Btn_Close: TButton
      Left = 374
      Top = 86
      Width = 75
      Height = 25
      Caption = #36864#20986
      TabOrder = 6
      OnClick = Btn_CloseClick
    end
    object Btn_UpLoad: TButton
      Left = 472
      Top = 20
      Width = 75
      Height = 25
      Caption = #19978#20256
      TabOrder = 7
      OnClick = Btn_UpLoadClick
    end
    object Btn_DownLoad: TButton
      Left = 472
      Top = 86
      Width = 75
      Height = 25
      Caption = #19979#36733
      TabOrder = 8
      OnClick = Btn_DownLoadClick
    end
  end
  object GroupBox7: TGroupBox
    Left = 0
    Top = 129
    Width = 680
    Height = 293
    Align = alClient
    Caption = #33719#21462#32467#26524
    TabOrder = 1
    object ListBoxLog: TListBox
      Left = 2
      Top = 15
      Width = 676
      Height = 276
      Align = alClient
      BiDiMode = bdLeftToRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object IdFTP: TIdFTP
    MaxLineAction = maException
    ReadTimeout = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 48
    Top = 153
  end
  object OpenDialog: TOpenDialog
    Left = 112
    Top = 153
  end
end
