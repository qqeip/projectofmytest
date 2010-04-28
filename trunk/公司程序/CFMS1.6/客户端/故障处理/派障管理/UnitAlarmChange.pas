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
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  private
    gGlobalWhere: string;
    FCxGridHelper : TCxGridSet;
    procedure AddViewFieldAlarmChange(aView: TcxGridDBTableView);
    procedure AddViewFieldCompany(aView: TcxGridDBTableView);
    procedure AddViewFieldCompanyDetail(aView: TcxGridDBTableView);
    procedure ShowAlarmChange(aBatchid, aCompanyid, aCityid: integer);
    procedure ShowAlarmCompany(aCityid, aCompanyid: integer);
    procedure ShowAlarmCompanyDetail(aBatchid, aCompanyid, aCityid: integer);
    procedure AddViewCheckField(aView: TcxGridDBTableView);
    function GetRelateCompanysID: string;
  public
    gCompanystr: string;
    gCompanyid: integer;//用来剔除自己的
    gCityid: integer;
    gBatchid: integer;
  end;

var
  FormAlarmChange: TFormAlarmChange;

implementation

uses UnitVFMSGlobal, UnitDllCommon;

{$R *.dfm}

procedure TFormAlarmChange.FormCreate(Sender: TObject);
begin
  gGlobalWhere:= ' and isrevert=1';

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGridAlarmChange,true,true,true);
  FCxGridHelper.SetGridStyle(cxGridCompany,true,true,true);
end;

procedure TFormAlarmChange.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FCxGridHelper.Free;
end;

procedure TFormAlarmChange.FormShow(Sender: TObject);
begin
  Label2.Caption:= self.gCompanystr;
  AddViewFieldAlarmChange(cxGridAlarmChangeDBTableView1);
  AddViewFieldCompany(cxGridDBTableView1);
  AddViewFieldCompanyDetail(cxGridDBTableView2);
  ShowAlarmChange(self.gBatchid,self.gCompanyid,self.gCityid);
  ShowAlarmCompany(self.gCityid,1);
end;

procedure TFormAlarmChange.ShowAlarmChange(aBatchid, aCompanyid, aCityid: integer);
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
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,4,' and cityid='+inttostr(aCityid)+' and companyid='+inttostr(aCompanyid)+' and batchid='+inttostr(aBatchid)]),0);


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
  AddViewField(aView,'contentcodename','告警内容');
  AddViewField(aView,'errorcontent','告警备注');
  AddViewField(aView,'sendtime','派障时间');
  AddViewField(aView,'removetime','排障时间');
  AddViewField(aView,'bts_name','基站中文名');
  AddViewField(aView,'deviceid','BTSID');
  AddViewField(aView,'codeviceid','扇区编号');
  AddViewField(aView,'station_addr','基站地址');
  AddViewField(aView,'cityid','区域编号');
  AddViewField(aView,'companyid','维护单位编号');
  AddViewField(aView,'batchid','告警编号');
  AddViewField(aView,'alarmid','从障编号');
end;

procedure TFormAlarmChange.OKBtnClick(Sender: TObject);
var
  lActiveView: TcxGridDBTableView;
  lisSelectCompany, lisSelectAlarm: boolean;
  I, J: integer;
  lAlarmid: integer;
  lAlarmid_Index: integer;
  lReturnCompanyid: string;
  lReturnCompanyid_index: integer;
  lifDeal: boolean;
  iError: integer;
  lMessageInfo: string;
begin
  lisSelectAlarm:= false;
  lisSelectCompany:= false;
  lActiveView:= cxGridAlarmChangeDBTableView1;
  try
    lAlarmid_Index:= lActiveView.GetColumnByFieldName('ALARMID').Index;
  except
    Application.MessageBox('未获得关键字段ALARMID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  for I := 0 to lActiveView.DataController.RowCount - 1 do
  begin
    if lActiveView.DataController.GetValue(i,0)='1' then
    begin
      lisSelectAlarm:= true;
      break;
    end;
  end;
  if not lisSelectAlarm then
  begin
    Application.MessageBox('请选择一条告警！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lActiveView:= cxGridDBTableView1;
  try
    lReturnCompanyid_index:=  lActiveView.GetColumnByFieldName('COMPANYID').Index;
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
  for J := lActiveView.DataController.RowCount - 1 downto 0 do
  begin
    if lActiveView.DataController.GetValue(J,0)='1' then
    begin
      if varisnull(lActiveView.DataController.GetValue(J,lReturnCompanyid_index)) then
        lReturnCompanyid:= lReturnCompanyid+'null,'
      else
        lReturnCompanyid:= lReturnCompanyid+ varastype(lActiveView.DataController.GetValue(J,lReturnCompanyid_index),varstring)+ ',';
    end;
  end;
  if length(lReturnCompanyid)>0 then
    lReturnCompanyid:= copy(lReturnCompanyid,1,length(lReturnCompanyid)-1);

  lifDeal:= CheckBox1.Checked;
  for I := cxGridAlarmChangeDBTableView1.DataController.RowCount - 1 downto 0 do
  begin
    if cxGridAlarmChangeDBTableView1.DataController.GetValue(i,0)='1' then
    begin
      lAlarmid:= cxGridAlarmChangeDBTableView1.DataController.GetValue(i,lAlarmid_Index);
      iError := gTempInterface.ReturnFault(gCityid, gCompanyid, lReturnCompanyid, 0, inttostr(lAlarmid), lifDeal, Memo1.Lines.text, gPublicParam.Userid);
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
    lMessageInfo:= '告警转派成功!';
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

procedure TFormAlarmChange.ShowAlarmCompany(aCityid, aCompanyid: integer);
var
  lRelateCompanysID: string; //用户所属维护单位关联的维护单位
  lCompanysID: string; //要筛选掉的维护单位：当前告警所属维护单位、当前用户所属维护单位
  lWhereCondition: string;
  lClientDataSet: TClientDataSet;
begin
  //不能显示自己的维护单位 和 当前用户所属的维护单位
  //要显示当前用户关联的维护单位
  lRelateCompanysID:= GetRelateCompanysID;//关联的维护单位
  lCompanysID:= IntToStr(gCompanyid) + ',' + IntToStr(gPublicParam.Companyid);
  if lRelateCompanysID<>'' then
    lWhereCondition:= ' and a.companyid not in (' + lCompanysID +
                      ') and a.companyid in (' + lRelateCompanysID +
                      ')'
  else
    lWhereCondition:= ' and a.companyid not in (' + lCompanysID +
                      ')';
  DataSource3.DataSet:= nil;
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,5,aCityid,aCompanyid,lWhereCondition]),0);
    end;
  finally
    CloneDateSet(lClientDataSet,ClientDataSet3);
    lClientDataSet.Free;
  end;
  DataSource3.DataSet:= ClientDataSet3;
  cxGridDBTableView1.ApplyBestFit(); 
end;

procedure TFormAlarmChange.ShowAlarmCompanyDetail(aBatchid, aCompanyid, aCityid: integer);
begin
  //不能显示自己的维护单位
  DataSource4.DataSet:= nil;
  try
    with ClientDataSet4 do
    begin
      Close;
      ProviderName:='dsp_General_data';
      Data:= gTempInterface.GetCDSData(VarArrayOf([23,2,' and cityid='+inttostr(aCityid)+' and companyid='+inttostr(aCompanyid)+' and batchid='+inttostr(aBatchid)]),0);
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
  ShowAlarmCompanyDetail(gBatchid,lCompanyid,lCityid);
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

function TFormAlarmChange.GetRelateCompanysID(): string;
var
  lSqlStr: string;
  lClientDataSet: TClientDataSet;
begin
  Result:= '';
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      Close;
      ProviderName:= 'DataSetProvider';
      lSqlStr:= 'select * from fms_company_info where cityid=' +
                IntToStr(gPublicParam.cityid) +
                ' and companyid=' +
                IntToStr(gPublicParam.Companyid);
      Data:= gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      result:= FieldByName('relatecompany').AsString;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

end.
