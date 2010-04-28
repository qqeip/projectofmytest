object Dm_Collect_Local: TDm_Collect_Local
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 352
  Top = 138
  Height = 450
  Width = 485
  object Ado_Dynamic: TADOQuery
    Connection = Ado_Conn
    CursorType = ctStatic
    Parameters = <>
    Left = 168
    Top = 80
  end
  object Ado_Free: TADOQuery
    Connection = Ado_Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'nodeaddress'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select cityid, cityname, csid, gw, pa, csc, csname, '
      'cs_index, substation, location,area, csc_name, '
      'csc_index,cs_address, cs_status_id, cs_status, '
      'cstypename, levelflagcode, levelflag'
      'from alarm_cs_info'
      'where nodeaddress in ( :nodeaddress  )'
      'order by nodeaddress')
    Left = 168
    Top = 136
  end
  object Ado_Collection_Cyc: TADOQuery
    Connection = Ado_Conn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * '
      'from Alarm_Collection_Cyc_List'
      'where collectionkind in (1,2,3,4,6,7,10,11,13)'
      'order by COLLECTIONKIND,collectioncode')
    Left = 392
    Top = 62
  end
  object Ds_Collection_Cyc: TDataSource
    DataSet = Ado_Collection_Cyc
    Left = 280
    Top = 62
  end
  object Ado_Collection_Cfg: TADOQuery
    Connection = Ado_Conn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * '
      'from Alarm_Collection_Config'
      'where collectkind in (1,2,3,4,6,7,8,9,10,11,13)'
      'order by COLLECTorder')
    Left = 392
    Top = 6
  end
  object Ds_Collection_Cfg: TDataSource
    DataSet = Ado_Collection_Cfg
    Left = 280
    Top = 6
  end
  object Ado_Synchronize_Cfg: TADOQuery
    Connection = Ado_Conn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *  '
      ' from Alarm_Collection_Config '
      ' where collectkind in (12) '
      ' order by COLLECTorder ')
    Left = 392
    Top = 174
  end
  object Ds_Synchronize_Cfg: TDataSource
    DataSet = Ado_Synchronize_Cfg
    Left = 280
    Top = 174
  end
  object ADO_SynchronizePOP: TADOQuery
    Connection = Ado_Conn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *  '
      ' from Alarm_Collection_Cyc_List '
      ' where collectionkind in (12) '
      ' order by COLLECTIONKIND,collectioncode')
    Left = 392
    Top = 118
  end
  object Ds_SynchronizePOP: TDataSource
    DataSet = ADO_SynchronizePOP
    Left = 280
    Top = 118
  end
  object Ds_AlarmTest: TDataSource
    DataSet = Ado_AlarmTest
    Left = 280
    Top = 232
  end
  object Ado_AlarmTest: TADOQuery
    Connection = Ado_Conn
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select *  '
      ' from Alarm_Collection_Cyc_List '
      ' where collectionkind =15'
      ' order by COLLECTIONKIND,collectioncode')
    Left = 392
    Top = 232
  end
  object Ado_Conn: TADOConnection
    LoginPrompt = False
    Left = 168
    Top = 16
  end
  object Sc_Client: TSocketConnection
    ServerGUID = '{09AB7282-0FBA-4C16-81DC-B722CA94C7D1}'
    ServerName = 'AlarmServiceApp.CollectServer'
    AfterConnect = Sc_ClientAfterConnect
    AfterDisconnect = Sc_ClientAfterDisconnect
    Address = '10.0.0.15'
    Port = 990
    Left = 56
    Top = 24
  end
  object Cb_Client: TConnectionBroker
    Connection = Sc_Client
    Left = 56
    Top = 96
  end
  object ADO_temp: TADOQuery
    Connection = Ado_Conn
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'nodeaddress'
        DataType = ftString
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'select cityid, cityname, csid, gw, pa, csc, csname, '
      'cs_index, substation, location,area, csc_name, '
      'csc_index,cs_address, cs_status_id, cs_status, '
      'cstypename, levelflagcode, levelflag'
      'from alarm_cs_info'
      'where nodeaddress in ( :nodeaddress  )'
      'order by nodeaddress')
    Left = 176
    Top = 200
  end
end
