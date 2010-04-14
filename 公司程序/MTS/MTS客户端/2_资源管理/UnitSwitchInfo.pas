unit UnitSwitchInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, Menus, cxGraphics, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, DBClient, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, StdCtrls, cxButtons, cxHeader, cxLabel, cxContainer,
  cxGroupBox, CxGridUnit, StringUtils;

type
  TFormSwitchInfo = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    cxHeader1: TcxHeader;
    cxButtonAdd: TcxButton;
    cxButtonModify: TcxButton;
    cxButtonDel: TcxButton;
    cxButtonClear: TcxButton;
    cxButtonClose: TcxButton;
    cxLabel15: TcxLabel;
    cxComboBoxBuilding: TcxComboBox;
    cxEditName: TcxTextEdit;
    cxEditAddress: TcxTextEdit;
    cxEditPort: TcxTextEdit;
    cxEditPOP: TcxTextEdit;
    cxEditAddress2: TcxTextEdit;
    cxGroupBox2: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    cxComboBoxSuburb: TcxComboBox;
    cxLabel3: TcxLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButtonCloseClick(Sender: TObject);
    procedure cxButtonClearClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxComboBoxSuburbPropertiesChange(Sender: TObject);
    procedure cxComboBoxBuildingPropertiesChange(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    FListSuburb,FListBuilding,FListAP: TStringList;
    FConstruncting: boolean;
    FIsSysHandle: boolean;
    procedure AddViewField_SWITCH;
    { Private declarations }
  public
    gCondition: string;
    procedure ShowDevice_LM;
    { Public declarations }
  end;

var
  FormSwitchInfo: TFormSwitchInfo;

implementation

uses Ut_DataModule, Ut_Common, Ut_MainForm;

{$R *.dfm}

procedure TFormSwitchInfo.cxButtonClearClick(Sender: TObject);
  procedure ClearInfo;
  var i : integer;
  begin
    for I := 0 to cxGroupBox1.ControlCount - 1 do
    begin
      if (cxGroupBox1.Controls[i] is TcxTextEdit) then
        (cxGroupBox1.Controls[i] as TcxTextEdit).Text :=''
      else if(cxGroupBox1.Controls[i] is TcxComboBox) then
        (cxGroupBox1.Controls[i] as TcxComboBox).ItemIndex :=-1;
    end;
  end;
begin
  ClearInfo;
end;

procedure TFormSwitchInfo.cxButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSwitchInfo.cxButtonDelClick(Sender: TObject);
var
  lSqlstr: string;
  lSwitchID: integer;
  lVariant: variant;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  if Application.MessageBox('确定要删除这条记录吗？','提示',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;

  lSwitchID:= ClientDataSet1.FieldByName('SWITCHID').AsInteger;
  FListAP:= TStringList.Create;
  GetResInfo(FListAP,' suburbid, suburbname, buildingid, buildingname, 0 longitude, 0 latitude ','switchid','apno','ap_info_view',' and switchid='+inttostr(lSwitchID));
  if IsExistRelated(lSwitchID,FListAP,'此路由器已被如下AP关联：'+#13+'%s删除路由器前请先删除关联的AP！') then Exit;

  lSqlstr:= 'delete from switch_info where SWITCHID='+inttostr(lSwitchID);
  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('删除成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.Delete;
    FIsSysHandle:= false;
  end else
    Application.MessageBox('删除失败！','提示',MB_OK	);
end;

procedure TFormSwitchInfo.cxButtonModifyClick(Sender: TObject);
var
  lSwitchID: integer;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  lSwitchID:= ClientDataSet1.FieldByName('SWITCHID').AsInteger;

  if trim(cxEditName.Text)='' then
  begin
    application.MessageBox('交换机编号不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxBuilding.ItemIndex=-1 then
  begin
    application.MessageBox('所属室分点不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxEditAddress.Text = '' then
  begin
    application.MessageBox('物理地址不能为空！', '提示', mb_ok);
    exit;
  end;

  if IsExists('SWITCH_INFO','SWITCHNO',cxEditName.Text,'SWITCHID',lSwitchID) then
  begin
    application.MessageBox(pchar('已经存在C网信源编号['+cxEditName.Text+']！'), '提示', mb_ok);
    exit;
  end;

  lSqlstr:= 'update switch_info set '+
            ' SWITCHNO= '''+cxEditName.Text+''','+
            ' MACADDR=  '''+cxEditAddress.Text+''','+
            ' MANAGEADDR= '''+cxEditAddress2.Text+''','+
            ' UPLINKPORT= '''+cxEditPort.Text+''','+
            ' POP= '''+ cxEditPOP.Text+''','+
            ' BUILDINGID= ' +inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+
      ' where SWITCHID= '+ IntToStr(lSwitchID);

  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('修改成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.edit;

    ClientDataSet1.FieldByName('SWITCHNO').AsString := cxEditName.Text ;
    ClientDataSet1.FieldByName('MACADDR').AsString   := cxEditAddress.Text;
    ClientDataSet1.FieldByName('MANAGEADDR').AsString := cxEditAddress2.Text;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('UPLINKPORT').AsString := cxEditPort.Text;
    ClientDataSet1.FieldByName('POP').AsString  := cxEditPOP.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;

    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end else
    application.MessageBox('修改失败！','提示',MB_OK );
end;

procedure TFormSwitchInfo.cxButtonAddClick(Sender: TObject);
var
  lSwitchID: integer;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  if trim(cxEditName.Text)='' then
  begin
    application.MessageBox('交换机编号不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxBuilding.ItemIndex=-1 then
  begin
    application.MessageBox('所属室分点不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxEditAddress.Text = '' then
  begin
    application.MessageBox('物理地址不能为空！', '提示', mb_ok);
    exit;
  end;

  lSwitchID:= DM_MTS.TempInterface.GetTheSequenceId('mtu_deviceid');
  if IsExists('SWITCH_INFO','SWITCHNO',cxEditName.Text,'SWITCHID',lSwitchID) then
  begin
    application.MessageBox(pchar('交换机编号已经存在['+cxEditName.Text+']！'), '提示', mb_ok);
    exit;
  end;
  
  lSqlstr:= 'insert into switch_info'+
            '(SWITCHID,SWITCHNO,MACADDR,MANAGEADDR,UPLINKPORT,POP,BUILDINGID)'+
            ' values'+
            ' ('+inttostr(lSwitchID)+','''+
              cxEditName.Text+''','''+
              cxEditAddress.Text+''','''+
              cxEditAddress2.Text+''','''+
              cxEditPort.Text+''','''+
              cxEditPOP.Text+''','+
              inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+
            ')';

  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('新增成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.append;

    ClientDataSet1.FieldByName('SWITCHID').AsString := inttostr(lSwitchID) ;
    ClientDataSet1.FieldByName('SWITCHNO').AsString := cxEditName.Text ;
    ClientDataSet1.FieldByName('MACADDR').AsString   := cxEditAddress.Text;
    ClientDataSet1.FieldByName('MANAGEADDR').AsString := cxEditAddress2.Text;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('UPLINKPORT').AsString := cxEditPort.Text;
    ClientDataSet1.FieldByName('POP').AsString  := cxEditPOP.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;

    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end
  else
    application.MessageBox('新增失败！','提示',MB_OK );
end;

procedure TFormSwitchInfo.cxComboBoxBuildingPropertiesChange(Sender: TObject);
var
  lBuildingid: integer;
  lSuburbid: integer;
  I: Integer;
begin
  if FConstruncting then exit;
  //开始构造
  FConstruncting:= true;
  
  //还原分局为未选
  cxComboBoxSuburb.ItemIndex:= -1;

  lBuildingid:= GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items);
  if lBuildingid>-1 then
  begin
    //根据室分点选择分局
    lSuburbid:= TFilterObject(cxComboBoxBuilding.Properties.Items.Objects[cxComboBoxBuilding.ItemIndex]).Suburbid;
    for I := 0 to cxComboBoxSuburb.Properties.Items.Count - 1 do
    begin
      if TFilterObject(cxComboBoxSuburb.Properties.Items.Objects[i]).Suburbid=lSuburbid  then
      begin
        cxComboBoxSuburb.ItemIndex:= i;
        break;
      end;
    end;
  end;
  //结束构造
  FConstruncting:= false;
end;

procedure TFormSwitchInfo.cxComboBoxSuburbPropertiesChange(Sender: TObject);
var
  lSuburbid: integer;
begin
  if FConstruncting then exit;
  //开始构造
  FConstruncting:= true;

  //还原室分点为未选
  cxComboBoxBuilding.ItemIndex:= -1;

  lSuburbid:= GetCaptionid(cxComboBoxSuburb.Text,cxComboBoxSuburb.Properties.Items);
  //更新室分点
  if lSuburbid>-1 then
  begin
    FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,MTS_SUBURB,lSuburbid);
  end else
  begin
    FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);
  end;
  //结束构造
  FConstruncting:= false;
end;

procedure TFormSwitchInfo.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if FIsSysHandle then exit;
  cxEditName.Text := ClientDataSet1.FieldByName('switchno').AsString;
  cxEditPort.Text := ClientDataSet1.FieldByName('uplinkport').AsString;
  cxComboBoxBuilding.ItemIndex:= cxComboBoxBuilding.Properties.Items.IndexOf(ClientDataSet1.FieldByName('buildingname').AsString);
  cxEditAddress.Text := ClientDataSet1.FieldByName('macaddr').AsString;
  cxEditAddress2.Text := ClientDataSet1.FieldByName('manageaddr').AsString;
  cxEditPOP.Text := ClientDataSet1.FieldByName('POP').AsString;
  cxComboBoxSuburb.ItemIndex:= cxComboBoxSuburb.Properties.Items.IndexOf(ClientDataSet1.FieldByName('suburbname').AsString);
end;

procedure TFormSwitchInfo.AddViewField_SWITCH;
begin
  AddViewField(cxGrid1DBTableView1,'switchid','内部编号');
  AddViewField(cxGrid1DBTableView1,'switchno','交换机编号');
  AddViewField(cxGrid1DBTableView1,'uplinkport','上连端口');
  AddViewField(cxGrid1DBTableView1,'macaddr','物理地址');
  AddViewField(cxGrid1DBTableView1,'manageaddr','管理地址');
  AddViewField(cxGrid1DBTableView1,'POP','ＰＯＰ');
  AddViewField(cxGrid1DBTableView1,'suburbname','所属分局'); 
  AddViewField(cxGrid1DBTableView1,'buildingname','所属室分点');
end;

procedure TFormSwitchInfo.ShowDevice_LM;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,43,Fm_MainForm.PublicParam.PriveAreaidStrs,gCondition]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormSwitchInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCxGridHelper.Free;
  ClearTStrings(FListSuburb);
  ClearTStrings(FListBuilding);
  ClearTStrings(cxComboBoxBuilding.Properties.Items);

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormSwitchInfo:=nil;
end;

procedure TFormSwitchInfo.FormCreate(Sender: TObject);
begin
  ClientDataSet1.RemoteServer:= Dm_MTS.SocketConnection1;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);

  FListSuburb:= TStringList.Create;
  FListBuilding:= TStringList.Create;
end;

procedure TFormSwitchInfo.FormShow(Sender: TObject);
begin
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,cxComboBoxBuilding.Properties.Items);
  cxComboBoxBuilding.ItemIndex := -1;

  GetSuburbInfo(FListSuburb);
  GetBuildingInfo(FListBuilding);

  FilterList(FListSuburb,cxComboBoxSuburb.Properties.Items,-1,-1);
  FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);

  AddViewField_SWITCH;
  ShowDevice_LM;
end;

end.
