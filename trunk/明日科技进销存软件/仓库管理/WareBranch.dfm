inherited FrmWareBranch: TFrmWareBranch
  Left = 356
  Top = 233
  Caption = #21830#21697#20998#24067
  ClientHeight = 303
  ClientWidth = 464
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited Bottom: TImage
    Top = 298
    Width = 464
  end
  inherited Left: TImage
    Height = 272
  end
  inherited Right: TImage
    Left = 462
    Height = 272
  end
  inherited Top: TPanel
    Width = 464
    inherited TopClient: TImage
      Width = 394
    end
    inherited TopRight: TImage
      Left = 428
    end
    inherited Image1: TImage
      Left = 440
    end
    inherited Image2: TImage
      Left = 420
    end
    inherited Image3: TImage
      Left = 400
    end
  end
  inherited PanelBack: TPanel
    Width = 460
    Height = 272
    object Panel1: TPanel
      Left = 0
      Top = 82
      Width = 460
      Height = 171
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object DBGrid1: TDBGrid
        Left = 2
        Top = 2
        Width = 456
        Height = 167
        Align = alClient
        BorderStyle = bsNone
        DataSource = DSMaster
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #23435#20307
        TitleFont.Style = []
        OnDrawColumnCell = DBGrid1DrawColumnCell
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 41
      Width = 460
      Height = 41
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object Label4: TLabel
        Left = 16
        Top = 16
        Width = 78
        Height = 12
        Caption = #20215#26684#26041#24335#65306'   '
      end
      object ComboBox1: TComboBox
        Left = 79
        Top = 11
        Width = 145
        Height = 20
        BevelKind = bkFlat
        Style = csDropDownList
        ItemHeight = 12
        ItemIndex = 0
        TabOrder = 0
        Text = #24179#22343#36827#20215
        OnChange = ComboBox1Change
        Items.Strings = (
          #24179#22343#36827#20215
          #24179#22343#21806#20215
          #39044#35774#36827#20215
          #39044#35774#21806#20215
          #26368#36817#19968#27425#36827#20215
          #26368#36817#19968#27425#21806#20215)
      end
    end
    object StatusBar1: TStatusBar
      Left = 0
      Top = 253
      Width = 460
      Height = 19
      Panels = <>
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 460
      Height = 41
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 3
      object Label1: TLabel
        Left = 8
        Top = 15
        Width = 72
        Height = 12
        Caption = #21830#21697#21517#31216#65306'  '
      end
      object Label2: TLabel
        Left = 208
        Top = 15
        Width = 54
        Height = 12
        Caption = #35268#26684#65306'   '
      end
      object Label3: TLabel
        Left = 344
        Top = 15
        Width = 54
        Height = 12
        Caption = #21333#20301#65306'   '
      end
      object Edit1: TEdit
        Left = 72
        Top = 10
        Width = 121
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 0
      end
      object Edit2: TEdit
        Left = 248
        Top = 10
        Width = 81
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 1
      end
      object Edit3: TEdit
        Left = 384
        Top = 10
        Width = 65
        Height = 20
        BevelKind = bkFlat
        BorderStyle = bsNone
        ReadOnly = True
        TabOrder = 2
      end
    end
  end
  object ADOMaster: TADODataSet
    Connection = FrmDataModu.ADOCon
    CursorType = ctStatic
    CommandText = 
      'Select c.'#20179#24211#21517#31216',a.'#39044#35774#36827#20215',Sum(b.'#25968#37327') '#24211#23384#37327','#13#10'a.'#39044#35774#36827#20215'*Sum(b.'#25968#37327') '#24211#23384#24635#20215' From ' +
      #21830#21697#26723#26696#34920' a,'#13#10'(Select m.'#20179#24211#32534#21495',d.* From '#19994#21153#21333#25454#20027#34920' m,'#19994#21153#21333#25454#26126#32454#34920' d'#13#10'          ' +
      ' Where m.'#21333#21495' = d.'#23450#21333#32534#21495' ) b'#13#10'Left Join '#20179#24211#26723#26696#34920' c On b.'#20179#24211#32534#21495' = c.'#32534#21495#13#10'Wh' +
      'ere a.'#21830#21697#32534#30721' = b.'#21830#21697#32534#21495' and '#21830#21697#32534#30721' = 1'#13#10'Group by c.'#20179#24211#21517#31216',a.'#39044#35774#36827#20215
    Parameters = <>
    Left = 90
    Top = 164
    object ADOMasterDSDesigner: TStringField
      DisplayWidth = 13
      FieldName = #20179#24211#21517#31216
      Size = 255
    end
    object ADOMasterField: TCurrencyField
      FieldName = #20215#26684
    end
    object ADOMasterDSDesigner3: TIntegerField
      DisplayWidth = 10
      FieldName = #24211#23384#37327
      ReadOnly = True
    end
    object ADOMasterDSDesigner4: TBCDField
      DisplayWidth = 15
      FieldName = #24211#23384#24635#39069
      ReadOnly = True
      currency = True
      Precision = 19
    end
  end
  object DSMaster: TDataSource
    DataSet = ADOMaster
    Left = 178
    Top = 172
  end
end
