unit UnitAlarmChange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, DBClient,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView, CxGridUnit,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  CheckLst, StringUtils, cxCheckBox;

type
  TFormAlarmChange = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Panel3: TPanel;
    Memo1: TMemo;
    Panel4: TPanel;
    cxGridAlarmChange: TcxGrid;
    cxGridAlarmChangeDBTableView1: TcxGridDBTableView;
    cxGridAlarmChangeLevel1: TcxGridLevel;
    cxGridCompany: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    cxGridLevel2: TcxGridLevel;
    DataSource3: TDataSource;
    ClientDataSet3: TClientDataSet;
    ClientDataSet4: TClientDataSet;
    DataSource4: TDataSource;
    Panel5: TPanel;
    Label5: TLabel;
    cxGridCollect: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    cxGridDBTableView4: TcxGridDBTableView;
    cxGridLevel3: TcxGridLevel;
    ClientDataSet2: TClientDataSet;
    DataSource2: TDataSource;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure cxGridDBTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);
    procedure cxGridAlarmChangeDBTableView1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxGridDBTableView1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure cxGridDBTableView1CustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
  private
    gGlobalWhere: string;
    FCxGridHelper : TCxGridSet;
    procedure AddViewFieldAlarmChange(aView: TcxGridDBTableView);
    procedure AddViewFieldCompany(aView: TcxGridDBTableView);
    procedure AddViewFieldCompanyDetail(aView: TcxGridDBTableView);

    procedure ShowAlarmChange(aDeviceid, aContentcode, aCityid: integer);
    procedure ShowAlarmChangeOther(aDeviceid, aContentcode, aCityid: integer);
    procedure ShowAlarmCompany(aCityid, aCompanyid, aDeviceid, aCoDeviceid, aContentcode: integer);
    procedure ShowAlarmCompanyDetail(aCompanyid, aCityid: integer);
    procedure AddViewCheckField(aView: TcxGridDBTableView);
  public
    gCityid: integer;
    gDeviceid: integer;
    gCoDeviceid: integer;
    gContentcode: integer;
  end;

var
  FormAlarmChange: TFormAlarmChange;

implementation

uses UnitVFMSGlobal, UnitDllCommon, UnitAlarmManpower;

{$R *.dfm}

procedure TFormAlarmChange.FormCreate(Sender: TObject);
begin
  gGlobalWhere:= ' and isrevert=1';

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAlarmChange,true,true,true);
  FCxGridHelper.SetGridStyle(cxGridCollect,true,true,true);
  FCxGridHelper.SetGridStyle(cxGridCompany,true,true,true);
end;

procedure TFormAlarmChange.FormShow(Sender: TObject);
var
  I : integer;
begin
  AddViewFieldAlarmChange(cxGridAlarmChangeDBTableView1);
  AddViewFieldAlarmChange(cxGridDBTableView3);
  AddViewFieldCompany(cxGridDBTableView1);
  AddViewFieldCompanyDetail(cxGridDBTableView2);
  ShowAlarmChange(self.gDeviceid,self.gContentcode,self.gCityid);
  ShowAlarmChangeOther(self.gDeviceid,self.gContentcode,self.gCityid);
  ShowAlarmCompany(gCityid,1,gDeviceid,gCoDeviceid,gContentcode);
end;

procedure TFormAlarmChange.ShowAlarmChange(aDeviceid, aContentcode, aCityid: integer);
var
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  DataSource1.DataSet:= nil;
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([25,2,' and cityid='+inttostr(aCityid)+
             ' and deviceid='+inttostr(aDeviceid)+' and contentcode='+inttostr(aContentcode),1]),0);

      CloneDateSet(lClientDataSet,ClientDataSet1);
    end;
  finally
    lClientDataSet.Free;
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGridAlarmChangeDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmChange.AddViewFieldAlarmChange(
  aView: TcxGridDBTableView);
begin
  AddViewCheckField(aView);
  AddViewField(aView,'bts_name','基站中文名');
  AddViewField(aView,'deviceid','BTSID');
  AddViewField(aView,'codeviceid','扇区编号');
  AddViewField(aView,'station_addr','基站地址');
  AddViewField(aView,'createtime','告警创建时间');
  AddViewField(aView,'alarmcontentname','告警内容');
  AddViewField(aView,'errorcontent','告警备注');
  AddViewField(aView,'CITYID','区域编号');
  AddViewField(aView,'ALARMCONTENTCODE','告警内容编号');
end;

procedure TFormAlarmChange.OKBtnClick(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lisSelectCompany: boolean;
  I, J: integer;
  lCityid_Index, lDeviceid_Index, lCoDeviceid_Index, lContentcode_Index, lCompanyid_Index: integer;
  lCityid, lDeviceid, lCoDeviceid, lContentcode, lCompanyid: integer;
  lRecordIndex: integer;
  iError: integer;
  lMessageInfo: string;
  lCompanyidStr: string;
begin
  lisSelectCompany:= false;
  lActiveView:= cxGridAlarmChangeDBTableView1;
  try
    lCityid_Index:= lActiveView.GetColumnByFieldName('CITYID').Index;
    lDeviceid_Index:= lActiveView.GetColumnByFieldName('DEVICEID').Index;
    lCoDeviceid_Index:= lActiveView.GetColumnByFieldName('CODEVICEID').Index;
    lContentcode_Index:= lActiveView.GetColumnByFieldName('ALARMCONTENTCODE').Index;
  except
    Application.MessageBox('未获得关键字段CITYID,DEVICEID,CODEVICEID,ALARMCONTENTCODE！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lActiveView:= cxGridDBTableView1;
  try
    lCompanyid_Index:=  lActiveView.GetColumnByFieldName('COMPANYID').Index;
  except
    Application.MessageBox('未获得关键字段COMPANYID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  for I := 0 to lActiveView.DataController.RowCount - 1 do
  begin
    if lActiveView.DataController.GetValue(i,0)='1' then
    begin
      lisSelectCompany:= true;
      break;
    end;
  end;
  if not lisSelectCompany then
  begin
    Application.MessageBox('请选择一个维护单位！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  for I := cxGridDBTableView1.DataController.RowCount - 1 downto 0  do
  begin
    if cxGridDBTableView1.DataController.GetValue(i,0)='1' then
    begin
      lCompanyid:= cxGridDBTableView1.DataController.GetValue(i,lCompanyid_Index);
      lCompanyidStr:= lCompanyidStr+inttostr(lCompanyid)+',';
    end;
  end;
  lCompanyidStr:= copy(lCompanyidStr,1,length(lCompanyidStr)-1);

  for J := cxGridAlarmChangeDBTableView1.DataController.RowCount - 1 downto 0 do
  begin
    if cxGridAlarmChangeDBTableView1.DataController.GetValue(j,0)='1' then
    begin
      lCityid:= cxGridAlarmChangeDBTableView1.DataController.GetValue(J,lCityid_Index);
      lDeviceid:= cxGridAlarmChangeDBTableView1.DataController.GetValue(J,lDeviceid_Index);
      lCoDeviceid:= cxGridAlarmChangeDBTableView1.DataController.GetValue(J,lCoDeviceid_Index);
      lContentcode:= cxGridAlarmChangeDBTableView1.DataController.GetValue(J,lContentcode_Index);
      iError := gTempInterface.ContinueSendFault(lCityid, lCompanyidStr, lDeviceid, lCoDeviceid, lContentcode, self.Memo1.Lines.Text, gPublicParam.Userid);
      case iError of
        -1: begin
              lMessageInfo:= '存储过程内部执行异常错误!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              exit;
            end;
        -2: begin
              lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              exit;
            end;
        -3: begin
              lMessageInfo:= '接口异常错误!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              exit;
            end;
        else if iError < -3 then
            begin
              lMessageInfo:= '接口未成功执行的编码原因!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              exit;
            end
        else if iError > 0 then
            begin
              lMessageInfo:= '为存储过程执行返回的未成功执行的编码原因!';
              lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
              exit;
            end;
      end;
    end;
  end;
  if iError=0 then
  begin
    FormAlarmManpower.cxGridAlarmMasterDBTableView1.DataController.DeleteSelection;
    lMessageInfo:= '告警派发成功!';
    Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONINFORMATION);
    ModalResult:=mrOk;
  end;
end;

procedure TFormAlarmChange.CancelBtnClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TFormAlarmChange.FormPaint(Sender: TObject);
begin
  self.Color:= $00E4C19D;
end;

procedure TFormAlarmChange.ShowAlarmCompany(aCityid, aCompanyid,
aDeviceid, aCoDeviceid, aContentcode: integer);
var
  lClientDataSet: TClientDataSet;
begin
  DataSource3.DataSet:= nil;
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([25,3,aCityid,aCompanyid,-1,
                            aCityid,aDeviceid,aCoDeviceid,aContentcode]),0);
    end;
  finally
    CloneDateSet(lClientDataSet,ClientDataSet3);
    lClientDataSet.Free;
  end;
  DataSource3.DataSet:= ClientDataSet3;
  cxGridDBTableView1.ApplyBestFit();
end;

procedure TFormAlarmChange.ShowAlarmCompanyDetail(aCompanyid, aCityid: integer);
begin
  //不能显示自己的维护单位
  DataSource4.DataSet:= nil;
  try
    with ClientDataSet4 do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,2,' and cityid='+inttostr(aCityid)+
      ' and companyid='+inttostr(aCompanyid)+' and deviceid='+inttostr(gDeviceid)]),0);
    end;
  finally

  end;
  DataSource4.DataSet:= ClientDataSet4;
  cxGridDBTableView2.ApplyBestFit(); 
end;

procedure TFormAlarmChange.AddViewFieldCompany(aView: TcxGridDBTableView);
begin
  AddViewCheckField(aView);
  AddViewField(aView,'companyname','维护单位名称');
  AddViewField(aView,'cityid','地市编号');
  AddViewField(aView,'companyid','维护单位编号');
  AddViewField(aView,'isexists','系统标注');
end;

procedure TFormAlarmChange.AddViewFieldCompanyDetail(
  aView: TcxGridDBTableView);
begin
  AddViewField(aView,'createtime','告警创建时间');
  AddViewField(aView,'contentcodename','告警内容');
  AddViewField(aView,'errorcontent','告警备注');
  AddViewField(aView,'sendtime','派障时间');
  AddViewField(aView,'removetime','排障时间');
  AddViewField(aView,'deviceid','BTSID');
  AddViewField(aView,'codeviceid','扇区编号');
end;

procedure TFormAlarmChange.AddViewCheckField(aView: TcxGridDBTableView);
begin
  try
    with aView.CreateColumn as TcxGridDBColumn do
    begin
      Caption := '';
      DataBinding.FieldName:= 'isChecked';
      HeaderAlignmentHorz := taCenter;
      PropertiesClassName:= 'TcxCheckBoxProperties';
      Options.Filtering:= False;
      Options.FilteringFilteredItemsList:= False;
      Options.FilteringMRUItemsList:= False;
      Options.FilteringPopup:= False;
      Options.FilteringPopupMultiSelect:= False;
      Options.IncSearch:= False;
      Options.Grouping:= False;
      Options.Moving:=False;
      Options.ShowCaption:= False;
      Options.Sorting:= false;
      TcxCustomCheckBoxProperties(Properties).ValueChecked:= 1;
      TcxCustomCheckBoxProperties(Properties).ValueUnchecked:= 0;
      Width:=30;
      //HeaderGlyph.LoadFromFile('c:\ctrl_gotoclient_normal.bmp');
    end;
  finally
  end;
end;

procedure TFormAlarmChange.cxGridDBTableView1DataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
var
  lCityid,lCompanyid: integer;
  lCityid_Index, lCompanyid_Index: integer;
begin
  //收起所有从表
  ADataController.CollapseDetails;
  try
    lCityid_Index:= cxGridDBTableView1.GetColumnByFieldName('CITYID').Index;
    lCompanyid_Index:= cxGridDBTableView1.GetColumnByFieldName('COMPANYID').Index;
  except
    Application.MessageBox('未获得关键字段CITYID,COMPANYID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lCityid:= integer(ADataController.GetValue(ARecordIndex,lCityid_Index));
  lCompanyid:= integer(ADataController.GetValue(ARecordIndex,lCompanyid_Index));
  ShowAlarmCompanyDetail(lCompanyid,lCityid);
end;

procedure TFormAlarmChange.cxGridAlarmChangeDBTableView1MouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  lCheckIndex: integer;
  lFixColIndex,lFixRowIndex: integer;
begin
  if (Button <> mbLeft) or (not (cxGridAlarmChangeDBTableView1.GetHitTest(X, Y) is TcxGridRecordCellHitTest)) then
  begin
    Exit;
  end;
  lFixColIndex:= cxGridAlarmChangeDBTableView1.Controller.FocusedColumn.Index;
  lFixRowIndex:= cxGridAlarmChangeDBTableView1.Controller.FocusedRow.Index;
  lFixRowIndex := cxGridAlarmChangeDBTableView1.DataController.FilteredRecordIndex[lFixRowIndex];
  try
    lCheckIndex := cxGridAlarmChangeDBTableView1.GetColumnByFieldName('isChecked').Index;
  except
    lCheckIndex:= -1;
  end;
  if lCheckIndex=-1 then exit;

  if lFixColIndex = lCheckIndex then
  begin
    if cxGridAlarmChangeDBTableView1.DataController.GetValue(lFixRowIndex,lFixColIndex)='0' then
    begin
      cxGridAlarmChangeDBTableView1.DataController.SetValue(lFixRowIndex,lFixColIndex,'1');
    end
    else
      cxGridAlarmChangeDBTableView1.DataController.SetValue(lFixRowIndex,lFixColIndex,'0');
  end;
end;

procedure TFormAlarmChange.cxGridDBTableView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lCheckIndex: integer;
  lFixColIndex,lFixRowIndex: integer;
begin
  if (Button <> mbLeft) or (not (cxGridDBTableView1.GetHitTest(X, Y) is TcxGridRecordCellHitTest)) then
  begin
    Exit;
  end;
  lFixColIndex:= cxGridDBTableView1.Controller.FocusedColumn.Index;
  lFixRowIndex:= cxGridDBTableView1.Controller.FocusedRow.Index;
  lFixRowIndex := cxGridDBTableView1.DataController.FilteredRecordIndex[lFixRowIndex];
  try
    lCheckIndex := cxGridDBTableView1.GetColumnByFieldName('isChecked').Index;
  except
    lCheckIndex:= -1;
  end;
  if lCheckIndex=-1 then exit;

  if lFixColIndex = lCheckIndex then
  begin
    if cxGridDBTableView1.DataController.GetValue(lFixRowIndex,lFixColIndex)='0' then
    begin
      cxGridDBTableView1.DataController.SetValue(lFixRowIndex,lFixColIndex,'1');
    end
    else
      cxGridDBTableView1.DataController.SetValue(lFixRowIndex,lFixColIndex,'0');
  end;
end;

procedure TFormAlarmChange.ShowAlarmChangeOther(aDeviceid, aContentcode, aCityid: integer);
var
  lClientDataSet: TClientDataSet;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  DataSource2.DataSet:= nil;
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';                                                                           
      Data:= gTempInterface.GetCDSData(VarArrayOf([25,2,' and cityid='+inttostr(aCityid)+
             ' and deviceid='+inttostr(aDeviceid)+' and contentcode<>'+inttostr(aContentcode),0]),0);

      CloneDateSet(lClientDataSet,ClientDataSet2);
    end;
  finally
    lClientDataSet.Free;
  end;
  DataSource2.DataSet:= ClientDataSet2;
  cxGridDBTableView3.ApplyBestFit();
end;

procedure TFormAlarmChange.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormAlarmChange.cxGridDBTableView1CustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var
  lIsExists: integer;
  lIsExists_Index: integer;
begin
  try
    lIsExists_Index:=TcxGridDBTableView(Sender).GetColumnByFieldName('ISEXISTS').Index;
  except
    exit;
  end;
  if VarAsType(AViewInfo.GridRecord.Values[lIsExists_Index],VarString)='1' then
    ACanvas.Brush.Color := clRed;
end;

end.
