unit UntCommandParam;

interface

uses Ut_DataModule, Variants;

var
  CurrentCityID,Current_DRSID, CurrentR_DeviceID, CurrentDRSType, CurrentDRSStatus: Integer;
  CurrentDRSNO:string;

function SendCommand32(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer;DRSNO:string): boolean;   //监控系统参数查询命令
function SendCommand33(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer;DRSNO:string): boolean;   //直放站参数查询命令

function SendCommand48(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID:Integer; DRSIDSet:string; R_DeviceIDSet: Integer;DRSNO:string): boolean;   //设置直放站系统编号命令
function SendCommand49(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X31_01, P0X31_02,DRSNO: string): boolean;   //设置远程通信参数
function SendCommand50(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X32_01, P0X32_02,
                        P0X32_03, P0X32_04, P0X32_05, P0X32_06, P0X32_07, P0X32_08, P0X32_09, P0X32_10,
                        P0X32_11, P0X32_12, P0X32_13, P0X32_14, P0X32_15, P0X32_16, P0X32_17,DRSNO: string): boolean;   //设置直放站主动告警使能标志命令
function SendCommand51(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X33_01, P0X33_02,DRSNO: string): boolean;   //设置门限值命令
function SendCommand52(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X34_01, P0X34_02,DRSNO: string): boolean;   //设置功放开关量命令
function SendCommand53(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X35_01, P0X35_02,DRSNO: string): boolean;   //设置衰减量命令
function SendCommand54(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X36_01, P0X36_02,DRSNO: string): boolean;   //设置信道号命令

implementation

function SendCommand32(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer;DRSNO:string): boolean;   //监控系统参数查询命令
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 32, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID])
    ]));
end;

function SendCommand33(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer;DRSNO:string): boolean;   //直放站参数查询命令
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 33, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID])
    ]));
end;


function SendCommand48(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID:Integer; DRSIDSet:string; R_DeviceIDSet: Integer;DRSNO:string): boolean;   //设置直放站系统编号命令
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 48, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID]),
    VarArrayOf([1,4,2, TaskID, 85, ''''+DRSIDSet+'''']),
    VarArrayOf([1,4,2, TaskID, 86, R_DeviceIDSet])
    ]));
end;

function SendCommand49(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X31_01, P0X31_02,DRSNO: string): boolean;   //设置远程通信参数
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 49, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID]),
    VarArrayOf([1,4,2, TaskID, 4, P0X31_01]),
    VarArrayOf([1,4,2, TaskID, 5, P0X31_02]),
    VarArrayOf([1,4,2, TaskID, 6, '''0X01'''])
    ]));
end;

function SendCommand50(TaskID, CityID:Integer; DRSID, R_DeviceID, DRSType, UserID: Integer; P0X32_01, P0X32_02,
                        P0X32_03, P0X32_04, P0X32_05, P0X32_06, P0X32_07, P0X32_08, P0X32_09, P0X32_10,
                        P0X32_11, P0X32_12, P0X32_13, P0X32_14, P0X32_15, P0X32_16, P0X32_17,DRSNO: string): boolean;   //设置直放站主动告警使能标志命令
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 50, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID]),   
    VarArrayOf([1,4,2, TaskID, 7, P0X32_01]),
    VarArrayOf([1,4,2, TaskID, 8, P0X32_02]),
    VarArrayOf([1,4,2, TaskID, 9, P0X32_03]),
    VarArrayOf([1,4,2, TaskID, 10, P0X32_04]),
    VarArrayOf([1,4,2, TaskID, 11, P0X32_05]),
    VarArrayOf([1,4,2, TaskID, 12, P0X32_06]),
    VarArrayOf([1,4,2, TaskID, 13, P0X32_07]),
    VarArrayOf([1,4,2, TaskID, 14, P0X32_08]),
    VarArrayOf([1,4,2, TaskID, 15, P0X32_09]),
    VarArrayOf([1,4,2, TaskID, 16, P0X32_10]),
    VarArrayOf([1,4,2, TaskID, 17, P0X32_11]),
    VarArrayOf([1,4,2, TaskID, 18, P0X32_12]),
    VarArrayOf([1,4,2, TaskID, 19, P0X32_13]),
    VarArrayOf([1,4,2, TaskID, 20, P0X32_14]),
    VarArrayOf([1,4,2, TaskID, 21, P0X32_15]),
    VarArrayOf([1,4,2, TaskID, 22, P0X32_16]),
    VarArrayOf([1,4,2, TaskID, 23, P0X32_17])
    ]));
end;

function SendCommand51(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X33_01, P0X33_02,DRSNO: string): boolean;   //设置门限值命令
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 51, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID]),
    VarArrayOf([1,4,2, TaskID, 27, P0X33_01]),
    VarArrayOf([1,4,2, TaskID, 76, P0X33_02])
    ]));
end;

function SendCommand52(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X34_01, P0X34_02,DRSNO: string): boolean;   //设置功放开关量命令
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 52, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID]),
    VarArrayOf([1,4,2, TaskID, 56, P0X34_01]),
    VarArrayOf([1,4,2, TaskID, 55, P0X34_02])
    ]));
end;

function SendCommand53(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X35_01, P0X35_02,DRSNO: string): boolean;   //设置衰减量命令
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 53, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID]),
    VarArrayOf([1,4,2, TaskID, 54, P0X35_01]),
    VarArrayOf([1,4,2, TaskID, 53, P0X35_02])
    ]));
end;

function SendCommand54(TaskID, CityID, DRSID, R_DeviceID, DRSType, UserID: Integer; P0X36_01, P0X36_02,DRSNO: string): boolean;   //设置信道号命令
begin
  Result := Dm_MTS.TempInterface.ExecBatchSQL(VarArrayOf([
    VarArrayOf([1,4,1, TaskID, CityID, DRSID, 54, UserID]),
    VarArrayOf([1,4,2, TaskID, 1, DRSType]),
    VarArrayOf([1,4,2, TaskID, 2, 0]),
    VarArrayOf([1,4,2, TaskID, 24, ''''+DRSNO+'''']),
    VarArrayOf([1,4,2, TaskID, 25, R_DeviceID]),
    VarArrayOf([1,4,2, TaskID, 77, P0X36_01]),
    VarArrayOf([1,4,2, TaskID, 78, P0X36_02])
    ]));
end;

end.
