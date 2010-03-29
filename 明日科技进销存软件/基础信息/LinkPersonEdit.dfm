inherited FrmLinkPersonEdit: TFrmLinkPersonEdit
  Caption = 'FrmLinkPersonEdit'
  ClientHeight = 248
  ClientWidth = 460
  OnShow = nil
  PixelsPerInch = 96
  TextHeight = 12
  inherited Bottom: TImage
    Top = 243
    Width = 460
  end
  inherited Left: TImage
    Height = 217
  end
  inherited Right: TImage
    Left = 458
    Height = 217
  end
  inherited Top: TPanel
    Width = 460
    inherited TopClient: TImage
      Width = 390
    end
    inherited TopRight: TImage
      Left = 424
    end
    inherited Image1: TImage
      Left = 436
    end
    inherited Image2: TImage
      Left = 416
    end
    inherited Image3: TImage
      Left = 396
    end
  end
  inherited PanelBack: TPanel
    Width = 456
    Height = 217
    inherited Panel1: TPanel
      Top = 176
      Width = 456
      inherited Image4: TImage
        Width = 452
      end
      inherited Btn_Post: TSpeedButton
        Left = 288
        OnClick = Btn_PostClick
      end
      inherited Btn_Cancel: TSpeedButton
        Left = 368
        OnClick = Btn_CancelClick
      end
    end
    inherited Panel2: TPanel
      Width = 456
      Height = 176
      inherited Image5: TImage
        Width = 452
        Height = 172
      end
      object Label3: TLabel
        Left = 24
        Top = 22
        Width = 78
        Height = 12
        Caption = #32852' '#31995' '#20154#65306'   '
        Transparent = True
      end
      object Label5: TLabel
        Left = 232
        Top = 20
        Width = 72
        Height = 12
        Caption = #22266#23450#30005#35805#65306'  '
        Transparent = True
      end
      object Label7: TLabel
        Left = 24
        Top = 50
        Width = 72
        Height = 12
        Caption = #31227#21160#30005#35805#65306'  '
        Transparent = True
      end
      object Label9: TLabel
        Left = 24
        Top = 80
        Width = 78
        Height = 12
        Caption = #22791'    '#27880#65306'   '
        Transparent = True
      end
      object DBEdit2: TDBEdit
        Left = 88
        Top = 18
        Width = 134
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #32852#31995#20154
        DataSource = DataSourceEdit
        TabOrder = 0
      end
      object DBEdit3: TDBEdit
        Left = 296
        Top = 16
        Width = 134
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #22266#23450#30005#35805
        DataSource = DataSourceEdit
        TabOrder = 1
      end
      object DBEdit4: TDBEdit
        Left = 88
        Top = 46
        Width = 134
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #31227#21160#30005#35805
        DataSource = DataSourceEdit
        TabOrder = 2
      end
      object DBMemo1: TDBMemo
        Left = 88
        Top = 76
        Width = 341
        Height = 65
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #22791#27880
        DataSource = DataSourceEdit
        ScrollBars = ssVertical
        TabOrder = 3
      end
    end
  end
  inherited DataSourceEdit: TDataSource
    Left = 74
    Top = 138
  end
  inherited ADOEdit: TADODataSet
    Connection = FrmDataModu.ADOCon
    Left = 170
    Top = 138
  end
end
