object Fm_CityManager: TFm_CityManager
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #22320#24066#20449#24687#31649#29702
  ClientHeight = 359
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object P_area: TPanel
    Left = 0
    Top = 0
    Width = 441
    Height = 359
    Align = alClient
    TabOrder = 0
  end
  object PopMenu: TPopupMenu
    OnPopup = PopMenuPopup
    Left = 208
    Top = 80
    object N1: TMenuItem
      Caption = #26032#22686#22320#24066
      OnClick = N1Click
    end
    object N2: TMenuItem
      Tag = 1
      Caption = #20462#25913#22320#24066
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #21024#38500#22320#24066
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #26032#22686#37066#21439
      OnClick = N4Click
    end
    object N5: TMenuItem
      Tag = 1
      Caption = #20462#25913#37066#21439
      OnClick = N5Click
    end
    object N6: TMenuItem
      Caption = #21024#38500#37066#21439
      OnClick = N6Click
    end
    object N7: TMenuItem
      Caption = #26032#22686#20998#23616
      OnClick = N7Click
    end
    object N8: TMenuItem
      Tag = 1
      Caption = #20462#25913#20998#23616
      OnClick = N8Click
    end
    object N9: TMenuItem
      Caption = #21024#38500#20998#23616
      OnClick = N9Click
    end
  end
end
