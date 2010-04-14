unit UnitAlarmWait;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxContainer, cxTextEdit, cxMaskEdit, cxSpinEdit,
  StdCtrls, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, ExtCtrls,
  DBClient, CxGridUnit;

type
  TFormAlarmWait = class(TForm)
    PaneAlarm: TPanel;
    cxGridAlarmWait: TcxGrid;
    cxGridAlarmWaitDBTableViewWait: TcxGridDBTableView;
    cxGridAlarmWaitLevel1: TcxGridLevel;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    btClose: TButton;
    cbShowHistory: TCheckBox;
    seCount: TcxSpinEdit;
    DataSourceWait: TDataSource;
    ClientDataSetWait: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FCxGridHelper : TCxGridSet;
    procedure AddViewField(aView : TcxGridDBTableView;aFieldName, aCaption : String; aWidth: integer=65);overload;
    procedure AddViewField_AlarmWait;
  public
    { Public declarations }
    gCondition :String;
    gAlarmKindCondition :String;
    procedure ShowAlarm_AlarmWait;    //异常事件
  end;

var
  FormAlarmWait: TFormAlarmWait;

implementation

uses Ut_DataModule, Ut_MainForm;

{$R *.dfm}

procedure TFormAlarmWait.AddViewField(aView: TcxGridDBTableView; aFieldName,
  aCaption: String; aWidth: integer);
begin
  aView.BeginUpdate;
  with aView.CreateColumn as TcxGridColumn do
  begin
    Caption := aCaption;
    DataBinding.FieldName:= aFieldName;
    DataBinding.ValueTypeClass := TcxStringValueType;
    HeaderAlignmentHorz := taCenter;
    Width:=aWidth;
  end;
  aView.EndUpdate;
end;

procedure TFormAlarmWait.AddViewField_AlarmWait;
begin
{异常事件发生时间、MTU编号、MTU名称、MTU位置、电话号码、
所属县市、所属室分点、室分点地址、覆盖区域、
异常事件名称（同告警名称）、异常值（测试结果值）。}
  AddViewField(cxGridAlarmWaitDBTableViewWait,'collecttime','异常事件发生时间');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'MTUNO','MTU编号');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'mtuname','MTU名称');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'mtuaddr','MTU位置');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'call','电话号码');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'cityname','地市');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'areaname','郊县');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'buildingname','室分点名称');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'address','室分点地址');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'overlay','覆盖范围');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'alarmcontentname','异常事件名称');
  AddViewField(cxGridAlarmWaitDBTableViewWait,'alarmcount','告警累计次数')
end;

procedure TFormAlarmWait.btCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFormAlarmWait.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCxGridHelper.Free;

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormAlarmWait:=nil;
end;

procedure TFormAlarmWait.FormCreate(Sender: TObject);
begin
  ClientDataSetWait.RemoteServer:= Dm_MTS.SocketConnection1;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAlarmWait,false,false,true);
end;

procedure TFormAlarmWait.FormShow(Sender: TObject);
begin
  AddViewField_AlarmWait;

  ShowAlarm_AlarmWait;
end;

procedure TFormAlarmWait.ShowAlarm_AlarmWait;
begin
  DataSourceWait.DataSet:= nil;
  with ClientDataSetWait do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,21,gCondition+gAlarmKindCondition]),0);
  end;
  DataSourceWait.DataSet:= ClientDataSetWait;
  cxGridAlarmWaitDBTableViewWait.ApplyBestFit();
end;

end.
