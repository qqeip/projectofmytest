object FormCompanyCheck: TFormCompanyCheck
  Left = 339
  Top = 191
  BorderStyle = bsDialog
  Caption = #32500#25252#21333#20301#21246#36873
  ClientHeight = 360
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LabelCompany: TLabel
    Left = 9
    Top = 8
    Width = 327
    Height = 16
    AutoSize = False
    Caption = #25152#23646#32500#25252#21333#20301#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 9
    Top = 26
    Width = 327
    Height = 327
    TabOrder = 0
    object Label2: TLabel
      Left = 64
      Top = 16
      Width = 224
      Height = 26
      AutoSize = False
      Caption = #21246#36873#30340#32500#25252#21333#20301#26174#31034#22312#25925#38556#30417#25511#39029#38754#13#10#36716#21457#31383#21475#30340#30446#30340#32500#25252#21333#20301#19979
    end
    object CheckListBoxCompany: TCheckListBox
      Left = 15
      Top = 49
      Width = 296
      Height = 234
      ItemHeight = 13
      TabOrder = 0
    end
    object BtnOK: TcxButton
      Left = 136
      Top = 293
      Width = 75
      Height = 25
      Caption = #30830#23450
      TabOrder = 1
      OnClick = BtnOKClick
    end
    object BtnCancel: TcxButton
      Left = 232
      Top = 293
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 2
      OnClick = BtnCancelClick
    end
  end
end
