inherited FrmWareEdit: TFrmWareEdit
  Left = 303
  Top = 175
  Caption = #21830#21697#20449#24687#31649#29702
  ClientHeight = 308
  ClientWidth = 505
  OnShow = nil
  PixelsPerInch = 96
  TextHeight = 12
  inherited Bottom: TImage
    Top = 303
    Width = 505
  end
  inherited Left: TImage
    Height = 277
  end
  inherited Right: TImage
    Left = 503
    Height = 277
  end
  inherited Top: TPanel
    Width = 505
    inherited TopClient: TImage
      Width = 435
    end
    inherited TopRight: TImage
      Left = 469
    end
    inherited Image1: TImage
      Left = 481
    end
    inherited Image2: TImage
      Left = 461
    end
    inherited Image3: TImage
      Left = 441
    end
  end
  inherited PanelBack: TPanel
    Width = 501
    Height = 277
    inherited Panel1: TPanel
      Top = 236
      Width = 501
      TabOrder = 1
      inherited Image4: TImage
        Width = 497
      end
      inherited Btn_Post: TSpeedButton
        Left = 304
        OnClick = Btn_PostClick
      end
      inherited Btn_Cancel: TSpeedButton
        Left = 400
        OnClick = Btn_CancelClick
      end
    end
    inherited Panel2: TPanel
      Width = 501
      Height = 236
      TabOrder = 0
      inherited Image5: TImage
        Width = 497
        Height = 232
      end
      object Label1: TLabel
        Left = 14
        Top = 24
        Width = 84
        Height = 12
        Caption = #21830#21697#21517#31216#65306'    '
        Transparent = True
      end
      object Label2: TLabel
        Left = 261
        Top = 24
        Width = 84
        Height = 12
        Caption = #25340#38899#31616#30721#65306'    '
        Transparent = True
      end
      object Label4: TLabel
        Left = 261
        Top = 53
        Width = 78
        Height = 12
        Caption = #35268#26684#22411#21495#65306'   '
        Transparent = True
      end
      object Label5: TLabel
        Left = 14
        Top = 54
        Width = 78
        Height = 12
        Caption = #21333'    '#20301#65306'   '
        Transparent = True
      end
      object Label7: TLabel
        Left = 261
        Top = 83
        Width = 72
        Height = 12
        Caption = #39044#35774#21806#20215#65306'  '
        Transparent = True
      end
      object Label9: TLabel
        Left = 14
        Top = 83
        Width = 72
        Height = 12
        Caption = #39044#35774#36827#20215#65306'  '
        Transparent = True
      end
      object Label11: TLabel
        Left = 14
        Top = 113
        Width = 78
        Height = 12
        Caption = #24211#23384#19978#38480#65306'   '
        Transparent = True
      end
      object Label12: TLabel
        Left = 261
        Top = 113
        Width = 84
        Height = 12
        Caption = #24211#23384#19979#38480#65306'    '
        Transparent = True
      end
      object Label15: TLabel
        Left = 14
        Top = 142
        Width = 78
        Height = 12
        Caption = #20135'    '#22320#65306'   '
        Transparent = True
      end
      object Label16: TLabel
        Left = 261
        Top = 142
        Width = 78
        Height = 12
        Caption = #29983' '#20135' '#21830#65306'   '
        Transparent = True
      end
      object Label18: TLabel
        Left = 14
        Top = 172
        Width = 78
        Height = 12
        Caption = #22791'    '#27880#65306'   '
        Transparent = True
      end
      object DBEdit1: TDBEdit
        Left = 77
        Top = 20
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #21830#21697#21517#31216
        DataSource = DataSourceEdit
        TabOrder = 0
        OnChange = DBEdit1Change
      end
      object DBEdit3: TDBEdit
        Left = 77
        Top = 50
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #21333#20301
        DataSource = DataSourceEdit
        TabOrder = 2
      end
      object DBEdit4: TDBEdit
        Left = 324
        Top = 79
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #39044#35774#21806#20215
        DataSource = DataSourceEdit
        TabOrder = 5
      end
      object DBEdit5: TDBEdit
        Left = 77
        Top = 80
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #39044#35774#36827#20215
        DataSource = DataSourceEdit
        TabOrder = 4
      end
      object DBEdit6: TDBEdit
        Left = 77
        Top = 109
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #24211#23384#19978#38480
        DataSource = DataSourceEdit
        TabOrder = 6
      end
      object DBEdit7: TDBEdit
        Left = 77
        Top = 139
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #20135#22320
        DataSource = DataSourceEdit
        TabOrder = 8
      end
      object DBEdit8: TDBEdit
        Left = 324
        Top = 139
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #29983#20135#21830
        DataSource = DataSourceEdit
        TabOrder = 9
      end
      object DBEdit9: TDBEdit
        Left = 324
        Top = 20
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #25340#38899#32534#30721
        DataSource = DataSourceEdit
        TabOrder = 1
      end
      object DBEdit10: TDBEdit
        Left = 324
        Top = 50
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #35268#26684#22411#21495
        DataSource = DataSourceEdit
        TabOrder = 3
      end
      object DBEdit14: TDBEdit
        Left = 324
        Top = 109
        Width = 162
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #24211#23384#19979#38480
        DataSource = DataSourceEdit
        TabOrder = 7
      end
      object DBMemo1: TDBMemo
        Left = 77
        Top = 169
        Width = 409
        Height = 48
        BevelKind = bkFlat
        BorderStyle = bsNone
        DataField = #22791#27880
        DataSource = DataSourceEdit
        ScrollBars = ssVertical
        TabOrder = 10
      end
    end
  end
  inherited DataSourceEdit: TDataSource
    Left = 338
  end
  inherited ADOEdit: TADODataSet
    Connection = FrmDataModu.ADOCon
    CursorType = ctStatic
    CommandText = 'select * from '#21830#21697#26723#26696#34920
    Left = 258
    Top = 202
    object ADOEditDSDesigner: TAutoIncField
      FieldName = #21830#21697#32534#30721
      ReadOnly = True
    end
    object ADOEditDSDesigner2: TStringField
      FieldName = #21830#21697#21517#31216
      Size = 255
    end
    object ADOEditDSDesigner3: TStringField
      FieldName = #35268#26684#22411#21495
      Size = 255
    end
    object ADOEditDSDesigner4: TStringField
      FieldName = #21333#20301
      Size = 255
    end
    object ADOEditDSDesigner5: TBCDField
      FieldName = #39044#35774#36827#20215
      currency = True
      Precision = 19
    end
    object ADOEditDSDesigner6: TBCDField
      FieldName = #39044#35774#21806#20215
      currency = True
      Precision = 19
    end
    object ADOEditDSDesigner7: TFloatField
      FieldName = #24211#23384#19979#38480
    end
    object ADOEditDSDesigner8: TFloatField
      FieldName = #24211#23384#19978#38480
    end
    object ADOEditDSDesigner9: TStringField
      FieldName = #20135#22320
      Size = 255
    end
    object ADOEditDSDesigner10: TStringField
      FieldName = #29983#20135#21830
      Size = 255
    end
    object ADOEditDSDesigner11: TStringField
      FieldName = #25340#38899#32534#30721
      Size = 255
    end
    object ADOEditDSDesigner12: TStringField
      FieldName = #22791#27880
      Size = 4000
    end
    object ADOEditflg: TBooleanField
      FieldName = 'flg'
    end
  end
end
