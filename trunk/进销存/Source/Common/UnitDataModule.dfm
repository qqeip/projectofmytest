object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 271
  Top = 140
  Height = 268
  Width = 368
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=888666;Persist Security Info=True;Us' +
      'er ID=admin;Data Source=Stockpile System'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 40
    Top = 24
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 144
    Top = 24
  end
end
