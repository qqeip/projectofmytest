object DataModuleLocal: TDataModuleLocal
  OldCreateOrder = False
  Left = 260
  Top = 224
  Height = 323
  Width = 427
  object ADOConnPool: TADOConnectionPool
    Attributes = []
    Left = 120
    Top = 64
  end
  object Sp_FlowNumber: TADOStoredProc
    ProcedureName = 'ALARM_GET_FLOWNUMBER'
    Parameters = <
      item
        Name = 'I_FLOWNAME'
        Attributes = [paNullable]
        DataType = ftString
        Size = 4000
        Value = Null
      end
      item
        Name = 'I_SERIESNUM'
        Attributes = [paNullable]
        DataType = ftInteger
        Value = Null
      end
      item
        Name = 'O_FLOWVALUE'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdOutput
        Value = Null
      end>
    Left = 264
    Top = 64
  end
end
