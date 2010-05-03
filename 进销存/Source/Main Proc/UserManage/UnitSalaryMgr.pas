unit UnitSalaryMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, Buttons, ExtCtrls, StdCtrls,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  ADODB, CxGridUnit, ComCtrls, DateUtils;

type
  TFormSalaryMgr = class(TForm)
    GroupBox1: TGroupBox;
    cxGridSalary: TcxGrid;
    cxGridSalaryDBTableView: TcxGridDBTableView;
    cxGridSalaryLevel1: TcxGridLevel;
    GroupBox2: TGroupBox;
    LabelDepotID: TLabel;
    EdtBaseSalary: TEdit;
    pnl1: TPanel;
    Btn_OK: TSpeedButton;
    Btn_Close: TSpeedButton;
    DSSalary: TDataSource;
    cxGridSalaryDBTableView2: TcxGridDBTableView;
    cxGridSalaryLevel2: TcxGridLevel;
    cxGridSalaryDetailsDBTableView: TcxGridDBTableView;
    Btn_Modify: TSpeedButton;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    DtpEnd: TDateTimePicker;
    DtpBegin: TDateTimePicker;
    DSSalaryDetails: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_OKClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure cxGridSalaryDBTableViewDataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure cxGridSalaryDBTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure EdtBaseSalaryKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    AdoQuery, AdoQueryDetails, AdoEdit: TAdoquery;
    FCxGridHelper : TCxGridSet;
    IsRecordChanged: Boolean;

    procedure AddcxGridViewField;
    procedure LoadUserSalaryInfo;
    procedure GetUserSalaryDetails(aUserID: string);
    function GetTotalPushSalary(aUserID: String): Double; //结算员工这个月总提成
    Function ISSettlement(aUserID, aSettlementDate: string): Boolean;
  public
    { Public declarations }
  end;

var
  FormSalaryMgr: TFormSalaryMgr;

implementation

uses UnitDataModule, UnitPublic;

{$R *.dfm}

procedure TFormSalaryMgr.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  AdoQueryDetails:= TADOQuery.Create(Self);
  AdoEdit:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridSalary,true,false,true);
end;

procedure TFormSalaryMgr.FormShow(Sender: TObject);
var
  lastdate: string;
begin
  AddcxGridViewField;
  LoadUserSalaryInfo;
  lastdate:= inttostr(DaysInAMonth(YearOf(Now()),MonthOf(Now())));
  DtpBegin.Date:= StrToDate(IntToStr(YearOf(Now()))+'-'+IntToStr(MonthOf(Now()))+'-'+'01');
  DtpEnd.Date:= StrToDate(IntToStr(YearOf(Now()))+'-'+IntToStr(MonthOf(Now()))+'-'+lastdate);
end;

procedure TFormSalaryMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormSalaryMgr.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
  AdoQuery.Free;
  AdoEdit.Free;
  AdoQueryDetails.Free;
end;

procedure TFormSalaryMgr.Btn_OKClick(Sender: TObject);
var
  i: Integer;
  lBasicSalary, lPushSalary, lTotalSalary: Double;
  lSettlementDate, lMonth: string;
begin
  lMonth:= IntToStr(MonthOf(DtpBegin.Date));
  for i:= 0 to (1-Length(lMonth)) do    //月份设置成2位
    lMonth:= '0' + lMonth;
  lSettlementDate:= IntToStr(YearOf(DtpBegin.Date)) + lMonth;

  if DM.ADOConnection.InTransaction then  DM.ADOConnection.CommitTrans;
  DM.ADOConnection.BeginTrans;
  with AdoQuery do
  begin
    First;
    for i:=0 to AdoQuery.RecordCount-1 do
    begin
      if ISSettlement(FieldByName('UserID').AsString, lSettlementDate) then
        Continue;
      lBasicSalary:= FieldByName('UserBasicSalary').AsFloat;
      lPushSalary:= GetTotalPushSalary(FieldByName('UserID').AsString);
      lTotalSalary:= lBasicSalary + lPushSalary;
      with AdoEdit do
      begin
        Active:= False;
        Connection:= DM.ADOConnection;
        SQL.Clear;
        SQL.Text:= 'INSERT INTO UserSalary(UserID,BasicSalary,PushMoney,TotalMoney,SettlementDate)' +
                   ' VALUES(' +
                   AdoQuery.FieldByName('UserID').AsString + ',' +
                   FloatToStr(lBasicSalary) + ',' +
                   FloatToStr(lPushSalary) + ',' +
                   FloatToStr(lTotalSalary) + ',''' +
                   lSettlementDate +
                   ''')';
        ExecSQL;
      end;
      Next;
    end;
  end;
  DM.ADOConnection.CommitTrans;
  Application.MessageBox('工资结算完成！','提示',MB_OK+64);
end;

procedure TFormSalaryMgr.Btn_ModifyClick(Sender: TObject);
begin
  try
    IsRecordChanged:= True;
    AdoQuery.Edit;
    AdoQuery.fieldbyname('UserBasicSalary').AsString:= EdtBaseSalary.Text;
    AdoQuery.Post;
    IsRecordChanged:= False;
    Application.MessageBox('修改成功！','提示',MB_OK+64);
  except
    Application.MessageBox('修改失败！','提示',MB_OK+64);
  end;
end;

procedure TFormSalaryMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSalaryMgr.AddcxGridViewField;
begin
  AddViewField(cxGridSalaryDBTableView,'UserID','员工编号');
  AddViewField(cxGridSalaryDBTableView,'UserName','员工名称',100);
  AddViewField(cxGridSalaryDBTableView,'UserBasicSalary','基本工资',100);

  AddViewField(cxGridSalaryDetailsDBTableView,'UserID','员工编号');
  AddViewField(cxGridSalaryDetailsDBTableView,'UserName','员工名称');
  AddViewField(cxGridSalaryDetailsDBTableView,'BasicSalary','基本工资');
  AddViewField(cxGridSalaryDetailsDBTableView,'PushMoney','提成工资');
  AddViewField(cxGridSalaryDetailsDBTableView,'TotalMoney','总工资');
  AddViewField(cxGridSalaryDetailsDBTableView,'SettlementDate','结算日期',100);
end;

procedure TFormSalaryMgr.LoadUserSalaryInfo;
var
  lSqlStr: string;
begin
  with AdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    lSqlStr:= 'select * from user where userType=''1''';
    SQL.Text:= lSqlStr;
    Active:= True;
    DSSalary.DataSet:= AdoQuery;
  end;
end;

procedure TFormSalaryMgr.cxGridSalaryDBTableViewDataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  lUserID_Index: Integer;
  lUserID: string;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  try
    lUserID_Index:=cxGridSalaryDBTableView.GetColumnByFieldName('UserID').Index;
    lUserID:= cxGridSalaryDBTableView.DataController.GetValue(ARecordIndex,lUserID_Index);
  except
    Application.MessageBox('未获得"员工编号"关键字！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  GetUserSalaryDetails(lUserID);
end;

procedure TFormSalaryMgr.GetUserSalaryDetails(aUserID: string);
begin
with AdoQueryDetails do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'SELECT UserSalary.*,User.UserName' +
                 ' from UserSalary' +
                 ' LEFT JOIN User ON User.UserID=UserSalary.UserID' +
                 ' WHERE UserSalary.UserID=' + aUserID;
      Active:= True;
      DSSalaryDetails.DataSet:= AdoQueryDetails;
    finally
    end;
  end;
end;

function TFormSalaryMgr.GetTotalPushSalary(aUserID: String): Double;
var
  lSqlStr, lEndDate: string;
begin
  lEndDate:= DateToStr(DtpEnd.Date);
  lEndDate:= lEndDate + ' 23:59:59';
  Result:= 0;
  with TADOQuery.Create(nil) do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      lSqlStr:= 'SELECT UserID,SUM(UserPercent) AS UserPushSalary FROM OutDepotSummary' +
                 ' WHERE UserID=' + aUserID +
                 ' AND CreateTime BETWEEN  CDATE(''' + DateToStr(DtpBegin.Date) +
                 ''') AND CDATE(''' + lEndDate + ''') ' +
                 ' GROUP BY UserID';
      SQL.Text:= lSqlStr;
      Active:= True;
      if IsEmpty then
        Result:= 0
      else
        Result:= FieldByName('UserPushSalary').AsFloat;
    finally
      Free;
    end;
  end;
end;

procedure TFormSalaryMgr.cxGridSalaryDBTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if IsRecordChanged then Exit;
  EdtBaseSalary.Text:= AdoQuery.fieldbyname('UserBasicSalary').AsString;
end;

procedure TFormSalaryMgr.EdtBaseSalaryKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9',#8,#13,#38]) then
  begin
    Key := #0;
  end;
end;

function TFormSalaryMgr.ISSettlement(aUserID, aSettlementDate: string): Boolean;
begin
  Result:= False;
  with TADOQuery.Create(nil) do
  begin
    Active:= False;
    Connection:= DM.ADOConnection;
    SQL.Clear;
    SQL.Text:= 'SELECT * FROM UserSalary WHERE USERID=' +
               aUserID +
               ' AND SettlementDate=''' + aSettlementDate + '''' ;
    Active:= True;
    if IsEmpty then
      Result:= False
    else
      Result:= True;
  end;
end;

end.
