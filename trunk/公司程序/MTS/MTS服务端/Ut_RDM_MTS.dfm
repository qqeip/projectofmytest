object RDM_MTS: TRDM_MTS
  OldCreateOrder = False
  OnCreate = RemoteDataModuleCreate
  OnDestroy = RemoteDataModuleDestroy
  Height = 480
  Width = 646
  object Aq_General_data: TADOQuery
    EnableBCD = False
    Parameters = <>
    Left = 392
    Top = 8
  end
  object dsp_General_data: TDataSetProvider
    DataSet = Aq_General_data
    ResolveToDataSet = True
    Left = 296
    Top = 8
  end
  object dsp_General_data1: TDataSetProvider
    DataSet = Aq_General_data1
    ResolveToDataSet = True
    Left = 296
    Top = 56
  end
  object Aq_General_data1: TADOQuery
    Parameters = <>
    Left = 392
    Top = 56
  end
  object dsp_General_data2: TDataSetProvider
    DataSet = Aq_General_data2
    ResolveToDataSet = True
    Left = 296
    Top = 104
  end
  object Aq_General_data2: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.ENTRYFEE,a.CSADDRESS,a.POWERTYPE,a.STARTDATE,a.CSADDRCo' +
        'de,a.ENTRYNAME,'
      'a.ENTRYKIND,a.CORRESCODE,b.dicname as powername'
      'from pro_entry_online a left join dic_code_info b'
      'on a.powertype=b.diccode and b.dictype=17'
      'order by entryid')
    Left = 392
    Top = 104
  end
  object dsp_General_data3: TDataSetProvider
    DataSet = Aq_General_data3
    ResolveToDataSet = True
    Left = 296
    Top = 160
  end
  object Aq_General_data3: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.PRENAME,a.PREKIND,a.PREMODEL,a.PREPRICE,a.PRECOUNT,a.RE' +
        'CEIVECONN,a.REMARK,'
      
        'a.PREDATE,b.dicname as PreKindName,b.dicname as Premodelname,d.p' +
        'ersonname,d.conntele'
      'from pro_presend_online a'
      
        'left join dic_code_info b on a.prekind=b.diccode and b.dictype=1' +
        '2'
      
        'left join dic_code_info c on a.premodel=b.diccode and b.dictype=' +
        '13'
      'left join owner_conn_info d on a.receiveconn=d.personcode')
    Left = 392
    Top = 160
  end
  object dsp_General_data4: TDataSetProvider
    DataSet = Aq_General_data4
    ResolveToDataSet = True
    Left = 296
    Top = 208
  end
  object Aq_General_data4: TADOQuery
    Parameters = <>
    SQL.Strings = (
      'select * from pro_scandoc_online_pic')
    Left = 392
    Top = 208
  end
  object dsp_General_data5: TDataSetProvider
    DataSet = Aq_General_data5
    ResolveToDataSet = True
    Left = 296
    Top = 256
  end
  object Aq_General_data5: TADOQuery
    Parameters = <>
    Left = 392
    Top = 256
  end
  object dsp_General_data6: TDataSetProvider
    DataSet = Aq_General_data6
    ResolveToDataSet = True
    Left = 296
    Top = 304
  end
  object Aq_General_data6: TADOQuery
    Parameters = <>
    Left = 392
    Top = 304
  end
  object dsp_General_data7: TDataSetProvider
    DataSet = Aq_General_data7
    ResolveToDataSet = True
    Left = 296
    Top = 368
  end
  object Aq_General_data7: TADOQuery
    Parameters = <>
    Left = 392
    Top = 368
  end
  object AS_Flow_Number: TADOStoredProc
    ProcedureName = 'MTS_GET_FLOWNUMBER'
    Parameters = <>
    Left = 104
    Top = 48
  end
  object DSP_GIS: TDataSetProvider
    DataSet = ADOQueryGIS
    Options = [poAllowCommandText, poUseQuoteChar]
    Left = 120
    Top = 408
  end
  object ADOQueryGIS: TADOQuery
    EnableBCD = False
    Parameters = <>
    Left = 168
    Top = 408
  end
end
