object FrmDataModu: TFrmDataModu
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 405
  Top = 274
  Height = 249
  Width = 362
  object ADOCon: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=sa;Initi' +
      'al Catalog=JXCData;Data Source=.'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 88
    Top = 40
  end
  object ADOQuery1: TADOQuery
    Connection = ADOCon
    Parameters = <>
    Left = 176
    Top = 40
  end
  object ADOReport: TADODataSet
    Connection = ADOCon
    CommandText = 'select * from '#25253#34920#31649#29702
    Parameters = <>
    Left = 104
    Top = 128
  end
end
