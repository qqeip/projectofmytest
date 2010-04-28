unit UnitBreakSiteDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBClient, cxLookAndFeelPainters, Menus, StdCtrls, cxButtons,
  cxControls, cxContainer, cxEdit, cxGroupBox, cxStyles, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ExtCtrls, CxGridUnit;

type
  TFormBreakSiteDetail = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxGroupBox2: TcxGroupBox;
    BtnStop: TcxButton;
    cxButton2: TcxButton;
    LabelBreakSiteCount: TLabel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    FSuburbID: Integer;
    FTownsIDList: string;
    FWholeWherecondition: string;
    FRepDate: string;
    FTimeScale_End: Integer;
    procedure Add_ViewField;
    procedure GetWholeWherecondition(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    property SUBURBID: Integer read FSuburbID write FSuburbID;
    property RepDate: string read FRepDate write FRepDate;
    property TimeScale_End: Integer read FTimeScale_End write FTimeScale_End;
    property TownsIDList: string read FTownsIDList write FTownsIDList;
    property WholeWherecondition: string  read FWholeWherecondition write GetWholeWherecondition;
  end;

var
  FormBreakSiteDetail: TFormBreakSiteDetail;

implementation

uses UnitDllCommon, UnitBreakSiteStat;

{$R *.dfm}

{ TFormBreakSiteDetail }

procedure TFormBreakSiteDetail.FormCreate(Sender: TObject);
begin
  Self.Font.Charset:= GB2312_CHARSET;
  Self.Font.Height:= -12;
  Self.Font.Name:= '宋体';
  Self.Font.Size:= 9;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);
end;

procedure TFormBreakSiteDetail.FormShow(Sender: TObject);
begin
  Add_ViewField;
  Timer1.Enabled:= True;
end;

procedure TFormBreakSiteDetail.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormBreakSiteDetail.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormBreakSiteDetail.BtnStopClick(Sender: TObject);
begin
//
end;

procedure TFormBreakSiteDetail.cxButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TFormBreakSiteDetail.Timer1Timer(Sender: TObject);
var
  lSqlStr, lTownWhereCondition, lRepDateWhereCondition: String;
begin
  inherited;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:= 'dsp_General_data';
    if SUBURBID=-1 then
      lTownWhereCondition:= ' and townid in (' + FTownsIDList + ')'
    else
      lTownWhereCondition:= ' and townid=' + IntToStr(SuburbID) ;
    if RepDate='-1' then
      lRepDateWhereCondition:= ' and 1=1'
    else
      lRepDateWhereCondition:= ' and statdate=to_date(''' + FRepDate + ''',''yyyy-mm-dd'')';
    lSqlStr:= 'select * from fault_detail_break ' +
              ' where cityid=' +
              IntToStr(gPublicParam.cityid) +
              lTownWhereCondition +
              lRepDateWhereCondition +
              FWholeWherecondition;
    Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlstr]),0);
    FormBreakSiteDetail.LabelBreakSiteCount.Caption:= FormBreakSiteDetail.LabelBreakSiteCount.Caption + IntToStr(RecordCount);
  end;
  cxGrid1DBTableView1.ApplyBestFit();
  Timer1.Enabled:= False;
end;

procedure TFormBreakSiteDetail.Add_ViewField;
begin
  AddViewField(cxGrid1DBTableView1,'bts_name','基站中文名');
  AddViewField(cxGrid1DBTableView1,'townname','县市');
  AddViewField(cxGrid1DBTableView1,'suburbname','局向');
  AddViewField(cxGrid1DBTableView1,'bts_levelname','基站重要性');
  AddViewField(cxGrid1DBTableView1,'pop_statusname','基站状态');
  AddViewField(cxGrid1DBTableView1,'btsid','BTSID');
  AddViewField(cxGrid1DBTableView1,'bts_typename','基站类型');
  AddViewField(cxGrid1DBTableView1,'bts_kindname','基站型号');
  AddViewField(cxGrid1DBTableView1,'msc','MSC');
  AddViewField(cxGrid1DBTableView1,'bsc','BSC');
  AddViewField(cxGrid1DBTableView1,'lac','LAC');
  AddViewField(cxGrid1DBTableView1,'station_addr','基站地址');
  AddViewField(cxGrid1DBTableView1,'bts_netstatename','基站在网状态');
  AddViewField(cxGrid1DBTableView1,'commonality_typename','机房归属方');
  AddViewField(cxGrid1DBTableView1,'agent_manu','代维公司');
  AddViewField(cxGrid1DBTableView1,'source_mode','代维岗位');
  AddViewField(cxGrid1DBTableView1,'iron_tower_kind','代维区域');
  AddViewField(cxGrid1DBTableView1,'createtime','派障时间');
  AddViewField(cxGrid1DBTableView1,'alarmcontentname','告警内容');
end;

procedure TFormBreakSiteDetail.GetWholeWherecondition(const Value: string);
begin
  FWholeWherecondition := Value;
end;

end.
