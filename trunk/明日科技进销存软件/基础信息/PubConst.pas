unit PubConst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Grids,DBGrids,ReportToolManage,Dialogs,ActiveX,ComObj;

const
  //UnitType  ��λ����
  utClient    =   1;
  utProvide   =   2;

  //PersonLink  ��ϵ��
  PLink       =   3;

  //BillType      ��������
  StockInStorage      =       1;      //�ɹ����
  StockOutStorage     =       2;      //�ɹ��˻������⣩
  SellOutStorage      =       3;      //���۳��ⵥ
  SellInStorage       =       4;      //�����˻���(���)

  StorageMove         =       5;      //�ֿ����
  StorageQuery        =       6;      //�ֿ��ѯ  

  rpWareInfo          =       1;      //��Ʒ��Ϣ����
  rpStorage           =       2;      //�ֿ���Ϣ��
  rpComeUnit          =       3;      //������λ��Ϣ��

  CustomVarible       =       '�Զ������';
  CustomUnitName      =       '��λ����';
  CustomDate          =       '��������';
  CustomStorageName   =       '�ֿ�����';
  CustomInStorage     =       '����ֿ�';
  CustomOutStorage    =       '�����ֿ�';
  CustomWareName      =       '��Ʒ����';
  CustomPerson        =       '������';
  CustomMemo          =       'ժҪ';
  CustomBillCode      =       '����';
  CustomPriceType     =       '�۸�ʽ';

type
  TUnitType = type Integer;     //��λ����
  TBillType = type Integer;

  //���߹�����
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
    FrmDataModu.ADOReport.CommandText := 'select * from ������� Where ID = '+ IntToStr(rpType);
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
    FrmDataModu.ADOReport.CommandText := 'select * from ������� ';
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
  FrmDataModu.ADOReport.CommandText := 'select * from ������� Where ID = '+ IntToStr(vrpType);
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
  LoginName := 'ϵͳ����Ա';
  
end.
