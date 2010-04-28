object FormServerSet: TFormServerSet
  Left = 250
  Top = 160
  Width = 320
  Height = 210
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #24212#29992#26381#21153#37197#32622
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 31
    Top = 19
    Width = 60
    Height = 12
    Caption = #25968#25454#24211#21517#31216
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 31
    Top = 50
    Width = 72
    Height = 12
    Caption = #25968#25454#24211#29992#25143#21517
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 31
    Top = 81
    Width = 60
    Height = 12
    Caption = #25968#25454#24211#23494#30721
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 31
    Top = 113
    Width = 84
    Height = 12
    Caption = #23454#26102#28040#24687#31471#21475#21495
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Ed_ServiceName: TEdit
    Left = 135
    Top = 15
    Width = 146
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
    TabOrder = 0
  end
  object Ed_UserName: TEdit
    Left = 135
    Top = 47
    Width = 146
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
    TabOrder = 1
  end
  object Ed_Password: TEdit
    Left = 135
    Top = 79
    Width = 146
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
    TabOrder = 2
  end
  object Ed_ComPort: TEdit
    Left = 135
    Top = 110
    Width = 146
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#26497#28857#20013#25991
    TabOrder = 3
    OnKeyPress = Ed_ComPortKeyPress
  end
  object Button1: TButton
    Left = 133
    Top = 142
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 213
    Top = 142
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 5
    OnClick = Button2Click
  end
end
