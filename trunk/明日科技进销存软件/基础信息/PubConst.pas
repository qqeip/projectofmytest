unit PubConst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Grids,DBGrids,ReportToolManage,Dialogs,ActiveX,ComObj;

const
  //UnitType  单位类型
  utClient    =   1;
  utProvide   =   2;

  //PersonLink  联系人
  PLink       =   3;

  //BillType      单据类型
  StockInStorage      =       1;      //采购入库
  StockOutStorage     =       2;      //采购退货（出库）
  SellOutStorage      =       3;      //销售出库单
  SellInStorage       =       4;      //销售退货单(入库)

  StorageMove         =       5;      //仓库调拨
  StorageQuery        =       6;      //仓库查询  

  rpWareInfo          =       1;      //商品信息报表
  rpStorage           =       2;      //仓库信息表
  rpComeUnit          =       3;      //往来单位信息表

  CustomVarible       =       '自定义变量';
  CustomUnitName      =       '单位名称';
  CustomDate          =       '发生日期';
  CustomStorageName   =       '仓库名称';
  CustomInStorage     =       '调入仓库';
  CustomOutStorage    =       '调出仓库';
  CustomWareName      =       '商品名称';
  CustomPerson        =       '经办人';
  CustomMemo          =       '摘要';
  CustomBillCode      =       '单号';
  CustomPriceType     =       '价格方式';

type
  TUnitType = type Integer;     //单位类型
  TBillType = type Integer;

  //工具管理类
  ToolManage = class(TObject)
    class function GetBillCode(BillType:TBillType):string;
    class procedure DesginReport(ReportTool:TAbsReportTool);
    class procedure SaveReport(ReportTool:TAbsReportTool;vrpType:Integer; var ReportName: String; SaveAs: Boolean; var Saved: Boolean);
  end;

var
  LoginID:string;
  LoginName:string;
  

//  function GetReportTool:TAbsReportTool;stdcall;external 'ReportTool.DLL';
  function GetReportTool:TAbsReportTool;
  procedure dbgridDrawColumnCell(Sender: TObject;
    const Rect: TRect; DataCol: Integer; Column: TColumn;
    State: TGridDrawState);

implementation

uses DataModu,DB, ReportForm;

function GetReportTool:TAbsReportTool;
begin
  Result := ReportForm.GetReportTool;
end;

procedure dbgridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if ((State = [gdSelected]) or (State=[gdSelected,gdFocused])) then
  begin
    if TDBGrid(Sender).Canvas.Font.Color <> clRed then
      TDBGrid(Sender).Canvas.Font.Color :=clHighlightText;
    TDBGrid(Sender).Canvas.Brush.Color :=clHighlight;
  end
  else
  begin
    if TDBGrid(Sender).DataSource.DataSet.RecNo mod 2=0 then
      TDBGrid(Sender).canvas.Brush.color := $00EFDFFF
    else
      TDBGrid(Sender).canvas.brush.color := $000D2FFFF;
  end;
  TDBGrid(Sender).DefaultDrawColumnCell(rect,datacol,column,state);
  
end;

{ ToolManage }

class procedure ToolManage.DesginReport(ReportTool:TAbsReportTool);
  function OpenReport(rpType:Integer; Stream:TStream):Boolean;
  begin
    Result := False;
    FrmDataModu.ADOReport.Active := False;
    FrmDataModu.ADOReport.CommandText := 'select * from 报表管理 Where ID = '+ IntToStr(rpType);
    FrmDataModu.ADOReport.Active := True;
    if FrmDataModu.ADOReport.IsEmpty then
      Exit;
    TBlobField(FrmDataModu.ADOReport.FieldByName('Report')).SaveToStream(Stream);
    Stream.Position := 0;
    Result := True;
  end;
  procedure AddReport(rpType:Integer);
  begin
    FrmDataModu.ADOReport.Active := False;
    FrmDataModu.ADOReport.CommandText := 'select * from 报表管理 ';
    FrmDataModu.ADOReport.Active := True;
    FrmDataModu.ADOReport.Append;
    FrmDataModu.ADOReport.FieldByName('ID').AsInteger := rpType;
    FrmDataModu.ADOReport.Post;
  end;
var
  MemoryStream:TMemoryStream;
  rpType:Integer;
begin
  rpType := ReportTool.ReportType;
  ReportTool.SaveToDataBase := True;
  ReportTool.OnSaveReport := SaveReport;
  MemoryStream := TMemoryStream.Create;
  if OpenReport(rpType,MemoryStream) then
  begin
    if MemoryStream.Size > 0 then
      ReportTool.LoadFromStream(MemoryStream);
  end
  else
  begin
    AddReport(rpType);
  end;
  MemoryStream.Free;

end;

class function ToolManage.GetBillCode(BillType:TBillType): string;
  function GetLoginID:string;
  begin
    if LoginID = '' then
      LoginID := '0';
    Result := Format('%.4d',[StrToInt(LoginID)]);
  end;
  function GetBillTypeCode:string;
  begin
    Result := Format('%.2d',[Integer(BillType)]);
  end;
  function GetDateCode:string;
  begin
    Result := FormatDateTime('YYYYMMDDHHNNSS',Now);
  end;
  function GetPrefix:string;
  begin
    Result := '';
  end;
begin
  Result := GetPrefix + GetBillTypeCode + GetLoginID + GetDateCode;
end;

class procedure ToolManage.SaveReport(ReportTool:TAbsReportTool;vrpType:Integer; var ReportName: String;
  SaveAs: Boolean; var Saved: Boolean);
  procedure FileSaveAs;
  var
    SaveDialog:TSaveDialog;
    FileName:string;
    MemoryStream:TMemoryStream;
  begin
    SaveDialog := TSaveDialog.Create(nil);
    SaveDialog.Filter := ' (*.rls)|*.rls|';
    SaveDialog.FilterIndex := 1;
    if SaveDialog.Execute then
    begin
      FileName := ChangeFileExt(SaveDialog.FileName, '.rls');
      MemoryStream := TMemoryStream.Create;
      ReportTool.SaveToStream(MemoryStream);
      MemoryStream.SaveToFile(FileName);
      MemoryStream.Free;
    end;
    SaveDialog.Free;
  end;
var
  MemoryStream:TMemoryStream;
begin
  if SaveAs then
  begin
    FileSaveAs;
    Exit;
  end;
  FrmDataModu.ADOReport.Active := False;
  FrmDataModu.ADOReport.CommandText := 'select * from 报表管理 Where ID = '+ IntToStr(vrpType);
  FrmDataModu.ADOReport.Active := True;
  MemoryStream := TMemoryStream.Create;
  ReportTool.SaveToStream(MemoryStream);
  FrmDataModu.ADOReport.Edit;
  TBlobField(FrmDataModu.ADOReport.FieldByName('Report')).LoadFromStream(MemoryStream);
  FrmDataModu.ADOReport.Post;
  MemoryStream.Free;
  Saved := True;
end;

initialization
  LoginID := '1';
  LoginName := '系统操作员';
  
end.
