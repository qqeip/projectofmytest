object FormDRSParticular: TFormDRSParticular
  Left = 0
  Top = 0
  Caption = #30452#25918#31449#20449#24687
  ClientHeight = 292
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object VL: TValueListEditor
    Left = 0
    Top = 0
    Width = 332
    Height = 292
    Align = alClient
    Ctl3D = False
    DefaultColWidth = 100
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goAlwaysShowEditor, goThumbTracking]
    ParentCtl3D = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    TitleCaptions.Strings = (
      #39033#30446
      #20540)
    ColWidths = (
      137
      191)
  end
  object PopupMenu1: TPopupMenu
    Left = 160
    Top = 168
    object NDRSConfig: TMenuItem
      Caption = #37197#32622
      OnClick = NDRSConfigClick
    end
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 248
    Top = 168
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 216
    Top = 168
  end
end
