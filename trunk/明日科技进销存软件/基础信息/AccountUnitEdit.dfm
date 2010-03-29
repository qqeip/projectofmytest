inherited FrmAccountUnitEdit: TFrmAccountUnitEdit
  Left = 359
  Caption = 'FrmAccountUnitEdit'
  ClientHeight = 255
  ClientWidth = 482
  OnShow = nil
  PixelsPerInch = 96
  TextHeight = 12
  inherited Bottom: TImage
    Top = 250
    Width = 482
  end
  inherited Left: TImage
    Height = 224
  end
  inherited Right: TImage
    Left = 480
    Height = 224
  end
  inherited Top: TPanel
    Width = 482
    inherited TopClient: TImage
      Width = 412
    end
    inherited TopRight: TImage
      Left = 446
    end
    inherited Image1: TImage
      Left = 458
    end
    inherited Image2: TImage
      Left = 438
    end
    inherited Image3: TImage
      Left = 418
    end
  end
  inherited PanelBack: TPanel
    Width = 478
    Height = 224
    inherited Panel1: TPanel
      Top = 183
      Width = 478
      TabOrder = 1
      DesignSize = (
        478
        41)
      inherited Image4: TImage
        Width = 474
      end
      inherited Btn_Post: TSpeedButton
        Left = 312
        OnClick = Btn_PostClick
      end
      inherited Btn_Cancel: TSpeedButton
        Left = 392
        OnClick = Btn_CancelClick
      end
    end
    inherited Panel2: TPanel
      Width = 478
      Height = 183
      TabOrder = 0
      inherited Image5: TImage
        Width = 474
        Height = 179
      end
      object Label1: TLabel
        Left = 24
        Top = 16
        Width = 78
        Height = 12
        Caption = #21333#20301#21517#31216#65306'   '
        Transparent = True
      end
      object Label2: TLabel
        Left = 248
        Top = 13
        Width = 78
        Height = 12
        Caption = #25340#38899#31616#30721#65306'   '
        Transparent = True
      end
      object Label3: TLabel
        Left = 24
        Top = 67
        Width = 84
        Height = 12
        Caption = #21333#20301#22320#22336#65306'    '
        Transparent = True
      end
      object Label6: TLabel
        Left = 24
        Top = 43
        Width = 78
        Height = 12
        Caption = #37038'    '#32534#65306'   '
        Transparent = True
      end
      object Label12: TLabel
        Left = 24
        Top = 92
        Width = 78
        Height = 12
        Caption = #22791'    '#27880#65306'   '
        Transparent = True
      end
      object DBEdit1: TDBEdit
        Left = 88
        Top = 12
        Width = 137
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #21333#20301#21517#31216
        DataSource = DataSourceEdit
        TabOrder = 0
        OnChange = DBEdit1Change
      end
      object DBEdit2: TDBEdit
        Left = 312
        Top = 9
        Width = 137
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #25340#38899#31616#30721
        DataSource = DataSourceEdit
        TabOrder = 1
      end
      object DBEdit6: TDBEdit
        Left = 88
        Top = 63
        Width = 362
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #21333#20301#22320#22336
        DataSource = DataSourceEdit
        TabOrder = 3
      end
      object DBEdit7: TDBEdit
        Left = 88
        Top = 38
        Width = 137
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #37038#32534
        DataSource = DataSourceEdit
        TabOrder = 2
      end
      object DBMemo1: TDBMemo
        Left = 88
        Top = 88
        Width = 362
        Height = 61
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #22791#27880
        DataSource = DataSourceEdit
        ScrollBars = ssVertical
        TabOrder = 4
      end
    end
  end
  inherited DataSourceEdit: TDataSource
    Left = 74
    Top = 154
  end
  inherited ADOEdit: TADODataSet
    Connection = FrmDataModu.ADOCon
    CommandText = 'select * from '#23458#25143#26723#26696' where flg = 1'
    Top = 138
  end
end
