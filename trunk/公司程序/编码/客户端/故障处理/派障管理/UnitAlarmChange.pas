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
    gCompanyid: integer;//�����޳��Լ���
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
  AddViewField(aView,'contentcodename','�澯����');
  AddViewField(aView,'errorcontent','�澯��ע');
  AddViewField(aView,'sendtime','����ʱ��');
  AddViewField(aView,'removetime','����ʱ��');
  AddViewField(aView,'bts_name','��վ������');
  AddViewField(aView,'deviceid','BTSID');
  AddViewField(aView,'codeviceid','�������');
  AddViewField(aView,'station_addr','��վ��ַ');
  AddViewField(aView,'cityid','������');
  AddViewField(aView,'companyid','ά����λ���');
  AddViewField(aView,'batchid','�澯���');
  AddViewField(aView,'alarmid','���ϱ��');
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
    Application.MessageBox('δ��ùؼ��ֶ�ALARMID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
    Application.MessageBox('��ѡ��һ���澯��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  lActiveView:= cxGridDBTableView1;
  try
    lReturnCompanyid_index:=  lActiveView.GetColumnByFieldName('COMPANYID').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�COMPANYID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
    Application.MessageBox('��ѡ��һ��ά����λ��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
              lMessageInfo:= '�洢�����ڲ�ִ���쳣����!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              exit;
            end;
        -2: begin
              lMessageInfo:= '���ô洢����ʧ�ܣ������Ǵ洢����ʧЧ�����±���洢����!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              exit;
            end;
        -3: begin
              lMessageInfo:= '�ӿ��쳣����!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              exit;
            end;
        else if iError < -3 then
            begin
              lMessageInfo:= '�ӿ�δ�ɹ�ִ�еı���ԭ��!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              exit;
            end
        else if iError > 0 then
            begin
              lMessageInfo:= 'Ϊ�洢����ִ�з��ص�δ�ɹ�ִ�еı���ԭ��!';
              lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
              Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
              exit;
            end;
      end;
    end;
  end;
  if iError=0 then
  begin
    lMessageInfo:= '�澯ת�ɳɹ�!';
    Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONINFORMATION);
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
  lRelateCompanysID: string; //�û�����ά����λ������ά����λ
  lCompanysID: string; //Ҫɸѡ����ά����λ����ǰ�澯����ά����λ����ǰ�û�����ά����λ
  lWhereCondition: string;
  lClientDataSet: TClientDataSet;
begin
  //������ʾ�Լ���ά����λ �� ��ǰ�û�������ά����λ
  //Ҫ��ʾ��ǰ�û�������ά����λ
  lRelateCompanysID:= GetRelateCompanysID;//������ά����λ
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
  //������ʾ�Լ���ά����λ
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
  AddViewField(aView,'companyname','ά����λ����');
  AddViewField(aView,'cityid','���б��');
  AddViewField(aView,'companyid','ά����λ���');
end;

procedure TFormAlarmChange.AddViewFieldCompanyDetail(
  aView: TcxGridDBTableView);
begin
  AddViewField(aView,'createtime','�澯����ʱ��');
  AddViewField(aView,'contentcodename','�澯����');
  AddViewField(aView,'errorcontent','�澯��ע');
  AddViewField(aView,'sendtime','����ʱ��');
  AddViewField(aView,'removetime','����ʱ��');
  AddViewField(aView,'deviceid','BTSID');
  AddViewField(aView,'codeviceid','�������');
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
  //�������дӱ�
  ADataController.CollapseDetails;
  try
    lCityid_Index:= cxGridDBTableView1.GetColumnByFieldName('CITYID').Index;
    lCompanyid_Index:= cxGridDBTableView1.GetColumnByFieldName('COMPANYID').Index;
  except
    Application.MessageBox('δ��ùؼ��ֶ�CITYID,COMPANYID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
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
