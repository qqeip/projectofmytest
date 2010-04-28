object FormAreaMgr: TFormAreaMgr
  Left = 273
  Top = 160
  Width = 667
  Height = 421
  BorderIcons = [biMinimize, biMaximize]
  Caption = #21306#22495#31649#29702
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
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 209
    Top = 0
    Height = 387
  end
  object cxTreeViewArea: TcxTreeView
    Left = 0
    Top = 0
    Width = 209
    Height = 387
    Align = alLeft
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnMouseDown = cxTreeViewAreaMouseDown
  end
  object Panel1: TPanel
    Left = 212
    Top = 0
    Width = 447
    Height = 387
    Align = alClient
    TabOrder = 1
    object cxTextEditAreaName: TcxTextEdit
      Left = 112
      Top = 48
      TabOrder = 0
      Width = 121
    end
    object cxLabel1: TcxLabel
      Left = 40
      Top = 48
      Caption = #22320#21306#21517#31216#65306
    end
    object cxGroupBox1: TcxGroupBox
      Left = 1
      Top = 296
      Align = alBottom
      TabOrder = 2
      Height = 90
      Width = 445
      object cxButtonAdd: TcxButton
        Left = 48
        Top = 35
        Width = 75
        Height = 25
        Caption = #28155#21152
        TabOrder = 0
        OnClick = cxButtonAddClick
      end
      object cxButtonModify: TcxButton
        Left = 135
        Top = 35
        Width = 75
        Height = 25
        Caption = #20462#25913
        TabOrder = 1
        OnClick = cxButtonModifyClick
      end
      object cxButtonDel: TcxButton
        Left = 222
        Top = 35
        Width = 75
        Height = 25
        Caption = #21024#38500
        TabOrder = 2
        OnClick = cxButtonDelClick
      end
      object cxButtonFresh: TcxButton
        Left = 310
        Top = 35
        Width = 75
        Height = 25
        Caption = #21047#26032
        TabOrder = 3
        OnClick = cxButtonFreshClick
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 128
    Top = 176
    object N1: TMenuItem
      Caption = #32479#19968#22320#21306#21495
      OnClick = N1Click
    end
  end
end
