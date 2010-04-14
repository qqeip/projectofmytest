object LDM_MTS: TLDM_MTS
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 176
  Width = 315
  object ADOConnPool: TADOConnectionPool
    Attributes = []
    ConnectionString = 
      'Provider=OraOLEDB.Oracle.1;Password=camdb;Persist Security Info=' +
      'True;User ID=camdb;Data Source=pop_10.0.0.22'
    Left = 80
    Top = 16
  end
end
