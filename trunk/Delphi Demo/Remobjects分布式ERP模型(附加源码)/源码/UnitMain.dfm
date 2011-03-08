object MainForm: TMainForm
  Left = 234
  Top = 157
  BorderStyle = bsDialog
  Caption = #20998#24067#24335'ERP'#27169#22411'('#23458#25143#31471')'
  ClientHeight = 357
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 216
    Top = 16
    Width = 54
    Height = 12
    Caption = #39564#35777#31471#21475':'
  end
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 66
    Height = 12
    Caption = #26381#21153#22120#22320#22336':'
  end
  object Button1: TButton
    Left = 16
    Top = 40
    Width = 75
    Height = 25
    Caption = #26597#35810
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 16
    Top = 72
    Width = 481
    Height = 273
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object Button2: TButton
    Left = 96
    Top = 40
    Width = 105
    Height = 25
    Caption = #25191#34892'('#21333#25805#20316')'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 208
    Top = 40
    Width = 137
    Height = 25
    Caption = #25191#34892'('#22810#25805#20316'/'#20107#21153#22411')'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 86
    Top = 11
    Width = 121
    Height = 20
    TabOrder = 4
    Text = '127.0.0.1'
  end
  object Edit2: TEdit
    Left = 272
    Top = 10
    Width = 121
    Height = 20
    TabOrder = 5
    Text = '6666'
  end
  object DataSource1: TDataSource
    DataSet = Cds
    Left = 288
    Top = 152
  end
  object Cds: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 160
  end
end
