unit UnitAttendanceMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, ADODB, cxGridUnit, ComCtrls, Buttons,
  ppDB, ppDBPipe, ppBands, ppClass, ppCtrls, ppVar, ppPrnabl, ppCache,
  ppComm, ppRelatv, ppProd, ppReport, DateUtils;

type
  TFormAttendanceMgr = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    cxGridAttendance: TcxGrid;
    cxGridAttendanceDBTableView1: TcxGridDBTableView;
    cxGridAttendanceLevel1: TcxGridLevel;
    Label1: TLabel;
    Label2: TLabel;
    DtpOnWork: TDateTimePicker;
    DtpOffWork: TDateTimePicker;
    ChkBeLate: TCheckBox;
    ChkLeaveEarly: TCheckBox;
    CbbUser: TComboBox;
    DtpStatMonth: TDateTimePicker;
    ChkUser: TCheckBox;
    Btn_Query: TSpeedButton;
    Btn_Print: TSpeedButton;
    DSAttendance: TDataSource;
    ppReport: TppReport;
    ppHeaderBand2: TppHeaderBand;
    ppLabel19: TppLabel;
    ppLine26: TppLine;
    ppLabel20: TppLabel;
    ppSystemVariable4: TppSystemVariable;
    ppLabel21: TppLabel;
    ppLabel22: TppLabel;
    ppSystemVariable5: TppSystemVariable;
    ppLabel23: TppLabel;
    ppLine27: TppLine;
    ppLine37: TppLine;
    ppLine38: TppLine;
    ppLine46: TppLine;
    ppLine48: TppLine;
    ppLabel24: TppLabel;
    ppLabel25: TppLabel;
    ppLabel26: TppLabel;
    ppDetailBand2: TppDetailBand;
    ppDBText15: TppDBText;
    ppDBText16: TppDBText;
    ppDBText17: TppDBText;
    ppLine54: TppLine;
    ppLine55: TppLine;
    ppLine56: TppLine;
    ppLine57: TppLine;
    ppLine59: TppLine;
    ppFooterBand2: TppFooterBand;
    ppLabel33: TppLabel;
    ppSystemVariable6: TppSystemVariable;
    ppLabel34: TppLabel;
    ppSummaryBand2: TppSummaryBand;
    ppDBPipeline: TppDBPipeline;
    ppLabel2: TppLabel;
    ppLabelStatMonth: TppLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
  private
    { Private declarations }
    AdoQuery: TAdoquery;
    FCxGridHelper : TCxGridSet;

    procedure AddcxGridViewField;
  public
    { Public declarations }
  end;

var
  FormAttendanceMgr: TFormAttendanceMgr;

implementation

uses UnitPublic, UnitDataModule;

{$R *.dfm}

procedure TFormAttendanceMgr.FormCreate(Sender: TObject);
begin
  AdoQuery:= TADOQuery.Create(Self);
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAttendance,true,false,true);

  SetItemCode('User', 'UserID', 'UserNAME', ' where UserType=''1''', CbbUser.Items);
end;

procedure TFormAttendanceMgr.FormShow(Sender: TObject);
begin
  AddcxGridViewField;
end;

procedure TFormAttendanceMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormAttendanceMgr.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormAttendanceMgr.AddcxGridViewField;
begin
  AddViewField(cxGridAttendanceDBTableView1,'UserID','员工编号');
  AddViewField(cxGridAttendanceDBTableView1,'UserName','员工名称');
  AddViewField(cxGridAttendanceDBTableView1,'CreateDate','日期');
  AddViewField(cxGridAttendanceDBTableView1,'OnWorkTime','上班时间');
  AddViewField(cxGridAttendanceDBTableView1,'OffWorkTime','下班时间');
end;

procedure TFormAttendanceMgr.Btn_QueryClick(Sender: TObject);
var
  lWhereStr: string;
  procedure GetWhere;
  begin
    lWhereStr:= '';
    if ChkUser.Checked then
      lWhereStr:= lWhereStr + ' and UserID=' + IntToStr(GetItemCode(CbbUser.Text, CbbUser.Items));
    if ChkBeLate.Checked then
      lWhereStr:= lWhereStr + ' and Format(OnWorkTime,''hh:mm:ss'')>Format(''' + TimeToStr(DtpOnWork.Time) + ''',''hh:mm:ss'')';
    if ChkLeaveEarly.Checked then
      lWhereStr:= lWhereStr + ' and Format(OffWorkTime,''hh:mm:ss'')<Format(''' + TimeToStr(DtpOffWork.Time) + ''',''hh:mm:ss'')';
  end;
begin
  GetWhere;
  with AdoQuery do
  begin
    try
      Active:= False;
      Connection:= DM.ADOConnection;
      SQL.Clear;
      SQL.Text:= 'SELECT * FROM (' +
                 'SELECT Attendance.UserID,Format(Attendance.OnWork,''hh:mm:ss'') AS OnWorkTime,' +
                 '       Format(Attendance.OffWork,''hh:mm:ss'') AS OffWorkTime,' +
                 '       Attendance.CreateDate,USER.UserName' +
                 '  FROM Attendance' +
                 '  LEFT JOIN USER ON Attendance.UserID=USER.UserID) AS Attendance1' +
                 ' WHERE Format(Attendance.CreateDate,''YYYY-MM'')=Format(''' + DateToStr(DtpStatMonth.Date) + ''',''YYYY-MM'')' +
                   lWhereStr +
                 ' ORDER BY CREATEDATE';
      Active:= True;
      DSAttendance.DataSet:= AdoQuery;
    finally
    end;
  end;
end;

procedure TFormAttendanceMgr.Btn_PrintClick(Sender: TObject);
VAR
  lAdoquery: TADOQuery;
  DSPrint: TDataSource;
begin
  lAdoquery:= TADOQuery.Create(Self);
  DSPrint:= TDataSource.Create(Self);
  with lAdoQuery do
  begin
    Connection:= DM.ADOConnection;
    Active:= False;
    SQL.Clear;
    SQL.Text:= 'SELECT UserID,UserName,sum(OnWork) AS OnWorkTime,sum(OffWork) AS OffWorkTime FROM' +
                '(' +
                'SELECT Attendance.UserID,USER.UserName,count(Attendance.UserID) AS OnWork, 0 AS OffWork' +
                '  FROM Attendance' +
                '  LEFT JOIN USER ON Attendance.UserID=USER.UserID' +
                ' WHERE Format(Attendance.CreateDate,''YYYY-MM'')=Format(''' + DateToStr(DtpStatMonth.Date) + ''',''YYYY-MM'')' +
                '   and Format(OnWork,''hh:mm:ss'')>Format(''' + TimeToStr(DtpOnWork.Time) + ''',''hh:mm:ss'')' +
                'group by Attendance.UserID,user.username' +
                ' union ' +
                'SELECT Attendance.UserID,USER.UserName,0 AS OnWork, count(Attendance.UserID) AS OffWork' +
                '  FROM Attendance' +
                '  LEFT JOIN USER ON Attendance.UserID=USER.UserID' +
                ' WHERE Format(Attendance.CreateDate,''YYYY-MM'')=Format(''' + DateToStr(DtpStatMonth.Date) + ''',''YYYY-MM'')' +
                '   and Format(OffWork,''hh:mm:ss'')<Format(''' + TimeToStr(DtpOffWork.Time) + ''',''hh:mm:ss'')' +
                'group by Attendance.UserID,User.username' +
                ')' +
                'group by UserID,UserName';

    Active:= True;
    DSPrint.DataSet:= lAdoQuery;
  end;
  ppLabelStatMonth.Caption:= IntToStr(YearOf(DtpStatMonth.Date))+'-'+IntToStr(MonthOf(DtpStatMonth.Date));
  ppDBPipeline.DataSource:= DSPrint;
  ppReport.Print;
end;

end.
