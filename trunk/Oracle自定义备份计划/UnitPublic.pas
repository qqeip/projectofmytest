unit UnitPublic;

interface

uses Classes, SysUtils, Controls;
  const
  IniFileName    = 'IniConfig.ini';
  IniSectionName = 'Set';
  IniFilePath    = 'FilePath';
  IniLogPath     = 'LogPath';

  //DB
  IniSectionDB   = 'DataBase';
  IniExpTables   = 'ExpTables';
  IniDBName      = 'DBName';
  IniDBPass      = 'DBPass';
  IniDBInstance  = 'DBInstance';
  LogName        = 'LogFile.txt';

  //plan
  IniSecPlanStatus      = 'PlanState';
  IniPlanStatus         = 'State';
  IniPlanMonthDay       = 'MonthDay';
  IniPlanWeek           = 'Week';
  IniPlanTime           = 'Time';
  IniCustomInfo         = 'CustomInfo';

  //LastExecDate
  IniSecLastExecDate = 'LastExecDateTimeSec';
  IniLastExecDate    = 'LastExecDateTime';
  IniIfTodayExec     = 'IfTodayExec';

 type   //·¢ÉúÆµÂÊ
   TPlantype = (EveryDay, EveryWeek, EveryMonth);

   TSetPlan = record
     fPlantype : TPlantype;
     fPlanWeek : Integer;
     fPlanMonth: Integer;
     fPlanTime  : Integer;
   end;

var
  BtnOKStatus : Boolean;
  CustomInfo  : string;
  fSetPlan : TSetPlan;
  fLastExecDate : TDate;
  IfTodayExec : Boolean;
  fDBName, fDBPass, fDBInstance, fExpTables: string;

function TimeToInt(fTime: TTime): Integer;
function IntTotime(fInt: Integer): TTime;

implementation

function TimeToInt(fTime: TTime): Integer;
 var h, m, s, ms : Word;
begin
  DecodeTime(fTime,h,m,s,ms);
  Result:= h*3600+m*60+s;
end;
function IntTotime(fInt: Integer): TTime;
 var h, m, s :Integer;
begin
  h:= (fInt div 3600);
  m:= ((fInt mod 3600) div 60);
  s:= ((fInt mod 3600) mod 60);
  Result :=StrToTime(IntToStr(h)+':'+inttostr(m)+':'+inttostr(s));
end;

end.
