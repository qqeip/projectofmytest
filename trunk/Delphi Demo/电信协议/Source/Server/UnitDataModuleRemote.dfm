object DataModuleRemote: TDataModuleRemote
  OldCreateOrder = False
  Left = 337
  Top = 157
  Height = 150
  Width = 215
  object ADOQuery: TADOQuery
    Parameters = <>
    Left = 72
    Top = 56
  end
  object DataSetProvider: TDataSetProvider
    DataSet = ADOQuery
    ResolveToDataSet = True
    Left = 72
    Top = 8
  end
end
