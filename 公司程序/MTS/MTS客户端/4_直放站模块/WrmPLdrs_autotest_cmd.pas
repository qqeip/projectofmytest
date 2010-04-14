unit WrmPLdrs_autotest_cmd;

interface

uses Classes, Contnrs, Variants, DB, DBClient, SysUtils;

type

  TWrmPLdrs_autotest_cmd = class(TObject)
  private
    FID:Integer;
    FDRSID:Integer;
    FCOMID:Integer;
    FASKTIME:TDateTime;
    FTIME_INTERVAL:Integer;
    FCURR_CYCCOUNT:Integer;
    FCYCCOUNTS:Integer;
    FOPERSTATUS:Integer;
    FBEGINTIME:TDateTime;
    FENDTIME:TDateTime;
    FPLANDATE:String;
    FMODELID:Integer;
    FIFPAUSE:Integer;
    FCREATETIME:TDateTime;
    FSUCC_CYCCOUNT:Integer;
    function GetTableName:string;
    { private declarations }
  protected
    //procedure UpdateProperty(DataSet: TDataSet);override;
    { protected declarations }
  public
    function Insert: Boolean;
    function Update: boolean;
    function Search(aWhereClause: string): Boolean;
    function DeleteByID: Boolean;
    function GetParamsInfo(aDrsid, aComid: integer): boolean;
    function GetParamsInfo2(aFlowid: integer): boolean;
    function IsExistsTask(aDrsid, aComid: integer; aBegin, aEnd: TDateTime; aID: integer=-1): boolean;
    function SetPause(aFlag: integer): boolean;
    { public declarations }

  published
    property ID: Integer read FID write FID;
    property DRSID: Integer read FDRSID write FDRSID;
    property COMID: Integer read FCOMID write FCOMID;
    property ASKTIME: TDateTime read FASKTIME write FASKTIME;
    property TIME_INTERVAL: Integer read FTIME_INTERVAL write FTIME_INTERVAL;
    property CURR_CYCCOUNT: Integer read FCURR_CYCCOUNT write FCURR_CYCCOUNT;
    property CYCCOUNTS: Integer read FCYCCOUNTS write FCYCCOUNTS;
    property OPERSTATUS: Integer read FOPERSTATUS write FOPERSTATUS;
    property BEGINTIME: TDateTime read FBEGINTIME write FBEGINTIME;
    property ENDTIME: TDateTime read FENDTIME write FENDTIME;
    property PLANDATE: String read FPLANDATE write FPLANDATE;
    property MODELID: Integer read FMODELID write FMODELID;
    property IFPAUSE: Integer read FIFPAUSE write FIFPAUSE;
    property CREATETIME: TDateTime read FCREATETIME write FCREATETIME;
    property SUCC_CYCCOUNT: Integer read FSUCC_CYCCOUNT write FSUCC_CYCCOUNT;
    { published declarations }
  end;

implementation

uses Ut_DataModule;

{ TWrmPLdrs_autotest_cmd }

function TWrmPLdrs_autotest_cmd.GetParamsInfo(aDrsid, aComid: integer): boolean;
var
  lSqlstr: string;
begin
  result:= false;
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select * from drs_autotest_cmd t where t.drsid='+inttostr(aDrsid)+' and t.comid='+inttostr(aComid);
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
    if not eof then
    begin
      FID:=fieldbyname('ID').AsInteger;
      FDRSID:=fieldbyname('DRSID').AsInteger;
      FCOMID:=fieldbyname('COMID').AsInteger;
      FASKTIME:=fieldbyname('ASKTIME').AsDatetime;
      FTIME_INTERVAL:=fieldbyname('TIME_INTERVAL').AsInteger;
      FCURR_CYCCOUNT:=fieldbyname('CURR_CYCCOUNT').AsInteger;
      FCYCCOUNTS:=fieldbyname('CYCCOUNTS').AsInteger;
      FOPERSTATUS:=fieldbyname('OPERSTATUS').AsInteger;
      FBEGINTIME:=fieldbyname('BEGINTIME').AsDatetime;
      FENDTIME:=fieldbyname('ENDTIME').AsDatetime;
      FPLANDATE:=fieldbyname('PLANDATE').AsString;
      FMODELID:=fieldbyname('MODELID').AsInteger;
      FIFPAUSE:=fieldbyname('IFPAUSE').AsInteger;
      FCREATETIME:=fieldbyname('CREATETIME').AsDatetime;
      FSUCC_CYCCOUNT:=fieldbyname('SUCC_CYCCOUNT').AsInteger;

      result:= true;
    end;
  end;
end;

function TWrmPLdrs_autotest_cmd.GetParamsInfo2(aFlowid: integer): boolean;
var
  lSqlstr: string;
begin
  result:= false;
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    lSqlstr:= 'select * from drs_autotest_cmd t where t.id='+inttostr(aFlowid);
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
    if not eof then
    begin
      FID:=fieldbyname('ID').AsInteger;
      FDRSID:=fieldbyname('DRSID').AsInteger;
      FCOMID:=fieldbyname('COMID').AsInteger;
      FASKTIME:=fieldbyname('ASKTIME').AsDatetime;
      FTIME_INTERVAL:=fieldbyname('TIME_INTERVAL').AsInteger;
      FCURR_CYCCOUNT:=fieldbyname('CURR_CYCCOUNT').AsInteger;
      FCYCCOUNTS:=fieldbyname('CYCCOUNTS').AsInteger;
      FOPERSTATUS:=fieldbyname('OPERSTATUS').AsInteger;
      FBEGINTIME:=fieldbyname('BEGINTIME').AsDatetime;
      FENDTIME:=fieldbyname('ENDTIME').AsDatetime;
      FPLANDATE:=fieldbyname('PLANDATE').AsString;
      FMODELID:=fieldbyname('MODELID').AsInteger;
      FIFPAUSE:=fieldbyname('IFPAUSE').AsInteger;
      FCREATETIME:=fieldbyname('CREATETIME').AsDatetime;
      FSUCC_CYCCOUNT:=fieldbyname('SUCC_CYCCOUNT').AsInteger;

      result:= true;
    end;
  end;
end;

function TWrmPLdrs_autotest_cmd.GetTableName: string;
begin
  result:='drs_autotest_cmd';
end;

function TWrmPLdrs_autotest_cmd.Insert: Boolean;
var
  lSqlstr: string;
  lVariant: variant;
  lFlowid: integer;
begin
  lFlowid:=Dm_Mts.TempInterface.GetTheSequenceId('mts_normal');
  lVariant:= VarArrayCreate([0,1],varVariant);
  lSqlstr:= 'Insert Into '+GetTableName+
            '(ID,DRSID,COMID,ASKTIME,TIME_INTERVAL,CURR_CYCCOUNT,CYCCOUNTS,OPERSTATUS,BEGINTIME,ENDTIME,PLANDATE,MODELID,IFPAUSE,CREATETIME,SUCC_CYCCOUNT) '+
            'values ('+inttostr(lFlowid)+','+IntToStr(FDRSID)+','+IntToStr(FCOMID)+',SYSDATE,'+IntToStr(FTIME_INTERVAL)+',0,'+
            IntToStr(FCYCCOUNTS)+',0,'+
            'to_date('''+FormatDateTime('HH:MM',FBEGINTIME)+''',''HH24:MI'')'+','+
            'to_date('''+FormatDateTime('HH:MM',ENDTIME)+''',''HH24:MI'')'+','+
            'NULL,NULL,0,SYSDATE,0)';
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lSqlstr:= 'insert into drs_autotest_param'+
            ' (id, paramid, paramvalue)'+
            ' select '+inttostr(lFlowid)+',a.paramid,a.paramvalue'+
            ' from drs_comparam_default_view a'+
            ' where a.drsid='+inttostr(self.FDRSID)+' and a.comid='+inttostr(FCOMID);
  lVariant[1]:= VarArrayOf([2,4,13,lSqlstr]);
  result:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
end;

function TWrmPLdrs_autotest_cmd.IsExistsTask(aDrsid, aComid: integer; aBegin, aEnd: TDateTime; aID: integer=-1): boolean;
var
  lSqlstr: string;
begin
  with Dm_MTS.cds_common do
  begin
    Close;
    ProviderName:='dsp_General_data';
    if aID=-1 then
    lSqlstr:= 'select * from drs_autotest_cmd t'+
              ' where t.drsid='+inttostr(aDrsid)+' and t.comid='+inttostr(aComid)+
              ' and (to_date('''+FormatDateTime('HH:MM',aBegin)+''',''HH24:MI'')'+
                   ' between to_date(to_char(t.begintime,''HH24:MI''),''HH24:MI'') and to_date(to_char(t.endtime,''HH24:MI''),''HH24:MI'')'+
              ' or to_date('''+FormatDateTime('HH:MM',aEnd)+''',''HH24:MI'')'+
                   ' between to_date(to_char(t.begintime,''HH24:MI''),''HH24:MI'') and to_date(to_char(t.endtime,''HH24:MI''),''HH24:MI'')'+
              ' or to_date(to_char(t.begintime,''HH24:MI''),''HH24:MI'')'+
                   ' between to_date('''+FormatDateTime('HH:MM',aBegin)+''',''HH24:MI'') and to_date('''+FormatDateTime('HH:MM',aEnd)+''',''HH24:MI'')'+
              ' or to_date(to_char(t.endtime,''HH24:MI''),''HH24:MI'')'+
                   ' between to_date('''+FormatDateTime('HH:MM',aBegin)+''',''HH24:MI'') and to_date('''+FormatDateTime('HH:MM',aEnd)+''',''HH24:MI'')'+
              ')'
    else
    lSqlstr:= 'select * from drs_autotest_cmd t'+
              ' where t.drsid='+inttostr(aDrsid)+' and t.comid='+inttostr(aComid)+
              ' and t.id<>'+inttostr(aID)+
              ' and (to_date('''+FormatDateTime('HH:MM',aBegin)+''',''HH24:MI'')'+
                   ' between to_date(to_char(t.begintime,''HH24:MI''),''HH24:MI'') and to_date(to_char(t.endtime,''HH24:MI''),''HH24:MI'')'+
              ' or to_date('''+FormatDateTime('HH:MM',aEnd)+''',''HH24:MI'')'+
                   ' between to_date(to_char(t.begintime,''HH24:MI''),''HH24:MI'') and to_date(to_char(t.endtime,''HH24:MI''),''HH24:MI'')'+
              ' or to_date(to_char(t.begintime,''HH24:MI''),''HH24:MI'')'+
                   ' between to_date('''+FormatDateTime('HH:MM',aBegin)+''',''HH24:MI'') and to_date('''+FormatDateTime('HH:MM',aEnd)+''',''HH24:MI'')'+
              ' or to_date(to_char(t.endtime,''HH24:MI''),''HH24:MI'')'+
                   ' between to_date('''+FormatDateTime('HH:MM',aBegin)+''',''HH24:MI'') and to_date('''+FormatDateTime('HH:MM',aEnd)+''',''HH24:MI'')'+
              ')';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
    if not eof then
      result:= true
    else result:= false;
  end;
end;

function TWrmPLdrs_autotest_cmd.Search(aWhereClause: string): Boolean;
var
  lSqlText: string;
begin
  if trim(aWhereClause)='' then
    lSqlText:='select * from '+self.GetTableName
  else
    lSqlText:='select * from '+GetTableName+' where '+aWhereClause;
//  Result := Select(lSqlText);
end;

function TWrmPLdrs_autotest_cmd.SetPause(aFlag: integer): boolean;
var
  lSqlstr: string;
  lVariant: variant;
begin
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr:='update drs_autotest_cmd a'+
           ' set a.ifpause='+inttostr(aFlag)+
           ' where a.id='+IntToStr(FID);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  result:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
end;

function TWrmPLdrs_autotest_cmd.Update: boolean;
var
  lSqlstr: string;
  lVariant: variant;
begin
  lVariant:= VarArrayCreate([0,0],varVariant);
  lSqlstr:= 'update drs_autotest_cmd'+
            '  set time_interval = '+inttostr(self.FTIME_INTERVAL)+','+
            '      cyccounts = '+inttostr(self.FCYCCOUNTS)+','+
            '      begintime = to_date('''+FormatDateTime('HH:MM',FBEGINTIME)+''',''HH24:MI'')'+','+
            '      endtime = to_date('''+FormatDateTime('HH:MM',FENDTIME)+''',''HH24:MI'')'+
            '  where id = '+inttostr(self.FID);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  result:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
end;

function TWrmPLdrs_autotest_cmd.DeleteByID: Boolean;
var
  lSqlstr: string;
  lVariant: variant;
begin
  lVariant:= VarArrayCreate([0,1],varVariant);
  lSqlstr:='delete from '+GetTableName+' where id='+IntToStr(FID);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lSqlstr:='delete from drs_autotest_param where id='+IntToStr(FID);
  lVariant[1]:= VarArrayOf([2,4,13,lSqlstr]);
  result:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
//  Result := Execute(lSqlText);
end;

//procedure TWrmPLdrs_autotest_cmd.UpdateProperty(DataSet: TDataSet);
//begin
//  FID:=FQuery.fieldbyname('ID').AsInteger;
//  FDRSID:=FQuery.fieldbyname('DRSID').AsInteger;
//  FCOMID:=FQuery.fieldbyname('COMID').AsInteger;
//  FASKTIME:=FQuery.fieldbyname('ASKTIME').AsDatetime;
//  FTIME_INTERVAL:=FQuery.fieldbyname('TIME_INTERVAL').AsInteger;
//  FCURR_CYCCOUNT:=FQuery.fieldbyname('CURR_CYCCOUNT').AsInteger;
//  FCYCCOUNTS:=FQuery.fieldbyname('CYCCOUNTS').AsInteger;
//  FOPERSTATUS:=FQuery.fieldbyname('OPERSTATUS').AsInteger;
//  FBEGINTIME:=FQuery.fieldbyname('BEGINTIME').AsDatetime;
//  FENDTIME:=FQuery.fieldbyname('ENDTIME').AsDatetime;
//  FPLANDATE:=FQuery.fieldbyname('PLANDATE').AsString;
//  FMODELID:=FQuery.fieldbyname('MODELID').AsInteger;
//  FIFPAUSE:=FQuery.fieldbyname('IFPAUSE').AsInteger;
//  FCREATETIME:=FQuery.fieldbyname('CREATETIME').AsDatetime;
//  FSUCC_CYCCOUNT:=FQuery.fieldbyname('SUCC_CYCCOUNT').AsInteger;
//end;

end.
