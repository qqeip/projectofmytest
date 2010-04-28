object DataModuleRemote: TDataModuleRemote
  OldCreateOrder = False
  Left = 278
  Top = 199
  Height = 422
  Width = 498
  object DataSetProvider1: TDataSetProvider
    DataSet = ADOQuery1
    ResolveToDataSet = True
    Left = 272
    Top = 56
  end
  object DataSetProvider2: TDataSetProvider
    DataSet = ADOQuery2
    ResolveToDataSet = True
    Left = 272
    Top = 112
  end
  object DataSetProvider3: TDataSetProvider
    DataSet = ADOQuery3
    ResolveToDataSet = True
    Left = 272
    Top = 168
  end
  object DataSetProvider4: TDataSetProvider
    DataSet = ADOQuery4
    ResolveToDataSet = True
    Left = 272
    Top = 224
  end
  object DataSetProvider5: TDataSetProvider
    DataSet = ADOQuery5
    ResolveToDataSet = True
    Left = 272
    Top = 280
  end
  object ADOQuery1: TADOQuery
    EnableBCD = False
    Parameters = <>
    Left = 376
    Top = 56
  end
  object ADOQuery2: TADOQuery
    Parameters = <>
    Left = 376
    Top = 112
  end
  object ADOQuery3: TADOQuery
    Parameters = <>
    Left = 376
    Top = 168
  end
  object ADOQuery4: TADOQuery
    Parameters = <>
    Left = 376
    Top = 224
  end
  object ADOQuery5: TADOQuery
    Parameters = <>
    Left = 376
    Top = 280
  end
  object DataSetProvider: TDataSetProvider
    DataSet = ADOQuery
    ResolveToDataSet = True
    Left = 272
    Top = 8
  end
  object ADOQuery: TADOQuery
    Parameters = <>
    Left = 376
    Top = 8
  end
  object DataSetProviderWav: TDataSetProvider
    DataSet = ADOQueryWav
    ResolveToDataSet = True
    Left = 40
    Top = 160
  end
  object ADOQueryWav: TADOQuery
    Parameters = <>
    Left = 96
    Top = 160
  end
end
