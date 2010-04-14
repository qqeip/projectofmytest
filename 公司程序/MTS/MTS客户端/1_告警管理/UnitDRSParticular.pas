unit UnitDRSParticular;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, Menus, DB, DBClient;

type
  TFloatInfo = record
    Field :String;
    Value :String;
  end;
  TFloatArray = Array of TFloatInfo;
  TFormDRSParticular = class(TForm)
    VL: TValueListEditor;
    PopupMenu1: TPopupMenu;
    NDRSConfig: TMenuItem;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    procedure NDRSConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FDRSField : TFloatArray;
    FDRSID: integer;
  public
    { Public declarations }
  published
    property DRSID: integer read FDRSID write FDRSID;
  end;

var
  FormDRSParticular: TFormDRSParticular;

implementation

uses Ut_DataModule, Ut_MainForm, UnitDRSInfoMgr, UntDRSConfig;

{$R *.dfm}

procedure TFormDRSParticular.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormDRSParticular.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormDRSParticular.FormShow(Sender: TObject);
var
  i: Integer;
  lWhereStrBuilding: string;
begin
  lWhereStrBuilding:= ' and drsid=' + IntToStr(DRSID);
  VL.Strings.Clear;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,71,Fm_MainForm.PublicParam.PriveAreaidStrs,lWhereStrBuilding]),0);
    if recordcount>0 then
    begin
      SetLength(FDRSField,FieldDefs.Count);
      for i := 0 to FieldDefs.Count-1 do
      begin
        FDRSField[i].Field :=FieldDefs.Items[i].Name;
        FDRSField[i].Value := Fields[i].AsString;
      end;
      for i := Low(FDRSField) to High(FDRSField) do
         VL.InsertRow(FDRSField[i].Field,FDRSField[i].Value,true);
    end;
  end;
end;

procedure TFormDRSParticular.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormDRSParticular.NDRSConfigClick(Sender: TObject);
//var
//  i: Integer;
//begin
//  for I := 0 to Length(FDRSField) - 1 do
//  begin
//    if FDRSField[i].Field='直放站编号' then
//      FormDRSInfoMgr.EdtDRSID.Text:= FDRSField[i].Value;
//    if FDRSField[i].Field='设备编号' then
//      FormDRSInfoMgr.EdtR_DEVICEID.Text:= FDRSField[i].Value;
//    if FDRSField[i].Field='直放站名称' then
//      FormDRSInfoMgr.EdtDRSName.Text:= FDRSField[i].Value;
//  end;
var
  i, lDRS_Index: Integer;
begin
  if not assigned(FrmDRSConfig) then
  begin
    FrmDRSConfig:=TFrmDRSConfig.Create(Self);
    Fm_MainForm.AddToTab(FrmDRSConfig);
  end;
  Fm_MainForm.SetTabIndex(FrmDRSConfig);
  FrmDRSConfig.WindowState:=wsMaximized;
  FrmDRSConfig.Show;
  FrmDRSConfig.tsDRSConfigInfo.Show;

  FrmDRSConfig.CDSDRS.Locate('DRSID',DRSID,[]);
  FrmDRSConfig.cxGridDBTVDRSList.DataController.ClearSelection;
  lDRS_Index:= FrmDRSConfig.cxGridDBTVDRSList.GetColumnByFieldName('DRSID').Index;
  for i:=FrmDRSConfig.cxGridDBTVDRSList.DataController.RowCount-1 downto 0 do
  begin
    if DRSID=FrmDRSConfig.cxGridDBTVDRSList.DataController.GetValue(i,lDRS_Index) then
    begin
      FrmDRSConfig.cxGridDBTVDRSList.DataController.SelectRows(i,i);
      FrmDRSConfig.cxGridDBTVDRSListMouseUp(Self,mbLeft,[ssLeft],1,1);
      FrmDRSConfig.cxGridDBTVDRSList.Focused:= True;
      Self.close;
      Exit;
    end;
  end;
end;

end.
