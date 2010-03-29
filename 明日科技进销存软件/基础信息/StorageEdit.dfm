inherited FrmStorageEdit: TFrmStorageEdit
  Caption = #20179#24211#31649#29702
  ClientHeight = 216
  ClientWidth = 326
  OnShow = nil
  PixelsPerInch = 96
  TextHeight = 12
  inherited Bottom: TImage
    Top = 211
    Width = 326
  end
  inherited Left: TImage
    Height = 185
  end
  inherited Right: TImage
    Left = 324
    Height = 185
  end
  inherited Top: TPanel
    Width = 326
    inherited TopClient: TImage
      Width = 256
    end
    inherited TopRight: TImage
      Left = 290
    end
    inherited Image1: TImage
      Left = 302
    end
    inherited Image2: TImage
      Left = 282
    end
    inherited Image3: TImage
      Left = 262
    end
  end
  inherited PanelBack: TPanel
    Width = 322
    Height = 185
    inherited Panel1: TPanel
      Top = 144
      Width = 322
      inherited Image4: TImage
        Width = 318
      end
      inherited Btn_Post: TSpeedButton
        Left = 152
        OnClick = Btn_PostClick
      end
      inherited Btn_Cancel: TSpeedButton
        Left = 232
        OnClick = Btn_CancelClick
      end
    end
    inherited Panel2: TPanel
      Width = 322
      Height = 144
      inherited Image5: TImage
        Width = 318
        Height = 140
      end
      object Label1: TLabel
        Left = 32
        Top = 24
        Width = 78
        Height = 12
        Caption = #20179#24211#21517#31216#65306'   '
        Transparent = True
      end
      object Label2: TLabel
        Left = 32
        Top = 52
        Width = 78
        Height = 12
        Caption = #36127' '#36131' '#20154#65306'   '
        Transparent = True
      end
      object Label3: TLabel
        Left = 32
        Top = 80
        Width = 78
        Height = 12
        Caption = #22791'    '#27880#65306'   '
        Transparent = True
      end
      object DBEdit1: TDBEdit
        Left = 95
        Top = 20
        Width = 185
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #20179#24211#21517#31216
        DataSource = DataSourceEdit
        TabOrder = 0
      end
      object DBMemo1: TDBMemo
        Left = 95
        Top = 77
        Width = 185
        Height = 49
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #22791#27880
        DataSource = DataSourceEdit
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object DBEdit2: TDBEdit
        Left = 95
        Top = 48
        Width = 185
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #36127#36131#20154
        DataSource = DataSourceEdit
        TabOrder = 1
      end
    end
  end
  inherited DataSourceEdit: TDataSource
    Left = 66
    Top = 122
  end
  inherited ADOEdit: TADODataSet
    Connection = FrmDataModu.ADOCon
    Left = 26
    Top = 114
  end
end
