unit UnitAPInfo;

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
  TFormAPInfo = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    cxHeader1: TcxHeader;
    cxButtonAdd: TcxButton;
    cxButtonModify: TcxButton;
    cxButtonDel: TcxButton;
    cxButtonClear: TcxButton;
    cxButtonClose: TcxButton;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    cxComboBoxSwitch: TcxComboBox;
    cxComboBoxAPPROPERTY: TcxComboBox;
    cxComboBoxPowerKind: TcxComboBox;
    cxComboBoxConType: TcxComboBox;
    cxEditAPName: TcxTextEdit;
    cxEditPort: TcxTextEdit;
    cxEditFREQUENCY: TcxTextEdit;
    cxComboBoxFactory: TcxComboBox;
    cxComboBoxBuilding: TcxComboBox;
    cxComboBoxApType: TcxComboBox;
    cxGroupBox2: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    cxLabel7: TcxLabel;
    cxEditAPPOWER: TcxTextEdit;
    cxEditAPIP: TcxTextEdit;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxEditAPADDR: TcxTextEdit;
    cxLabel12: TcxLabel;
    cxEditMANAGEADDRSEG: TcxTextEdit;
    cxLabel13: TcxLabel;
    cxEditBUSINESSVLAN: TcxTextEdit;
    cxLabel14: TcxLabel;
    cxEditOVERLAY: TcxTextEdit;
    cxLabel17: TcxLabel;
    cxEditGWADDR: TcxTextEdit;
    cxLabel18: TcxLabel;
    cxEditMACADDR: TcxTextEdit;
    cxLabel19: TcxLabel;
    cxEditMANAGEVLAN: TcxTextEdit;
    cxLabel20: TcxLabel;
    cxComboBoxSuburb: TcxComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cxButtonCloseClick(Sender: TObject);
    procedure cxButtonClearClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxComboBoxBuildingPropertiesChange(Sender: TObject);
    procedure cxComboBoxSuburbPropertiesChange(Sender: TObject);
    procedure cxEditPortKeyPress(Sender: TObject; var Key: Char);
    procedure cxEditAPPOWERKeyPress(Sender: TObject; var Key: Char);
    procedure cxEditFREQUENCYKeyPress(Sender: TObject; var Key: Char);
  private
    FCxGridHelper:TCxGridSet;
    FListSuburb,FListBuilding,FListSwitch,FListLink: TStringList;
    FConstruncting: boolean;
    FIsSysHandle: boolean;
    procedure AddViewField_AP;
    procedure DestroyOBJ(Box: TcxComboBox);
    procedure ClearInfo;
    { Private declarations }
  public
    gCondition: string;
    procedure ShowDevice_AP;
    { Public declarations }
  end;

var
  FormAPInfo: TFormAPInfo;

implementation

uses Ut_Common, Ut_MainForm, Ut_DataModule;

{$R *.dfm}

procedure TFormAPInfo.ClearInfo;
var
  i : integer;
begin
  for I := 0 to cxGroupBox1.ControlCount - 1 do
  begin
    if (cxGroupBox1.Controls[i] is TcxTextEdit) then
      (cxGroupBox1.Controls[i] as TcxTextEdit).Text :=''
    else if(cxGroupBox1.Controls[i] is TcxComboBox) then
      (cxGroupBox1.Controls[i] as TcxComboBox).ItemIndex :=-1;
  end;
end;

procedure TFormAPInfo.cxButtonClearClick(Sender: TObject);
begin
  ClearInfo;
end;

procedure TFormAPInfo.cxButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormAPInfo.cxButtonDelClick(Sender: TObject);
  var
  lSqlstr: string;
  lAPid: integer;
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

  lAPid:= ClientDataSet1.FieldByName('apid').AsInteger;
  FListLink:= TStringList.Create;
  GetResInfo(FListLink,' suburbid, suburbname, buildingid, buildingname, 0 longitude, 0 latitude ','apId','linkno','linkmachine_info_view',' and apid='+inttostr(lAPid));
  if IsExistRelated(lAPid,FListLink,'此AP已被如下连接器关联：'+#13+'%s删除AP前请先删除关联的连接器！') then Exit;


  lSqlstr:= 'delete from ap_info where apid='+inttostr(lAPid);
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

procedure TFormAPInfo.cxButtonModifyClick(Sender: TObject);
  var
  lSqlstr ,lPort, lAPPower, lFrequency: string;
  lAPID: integer;
  lVariant: variant;
  lsuccess: boolean;
begin
  //modify
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  lAPID:= ClientDataSet1.FieldByName('APID').AsInteger;

  if trim(cxEditAPName.Text)='' then
  begin
    application.MessageBox('接入点编号不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxBuilding.ItemIndex=-1 then
  begin
    application.MessageBox('所属室分点不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxConType.ItemIndex=-1 then
  begin
    application.MessageBox('连接类型不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxSwitch.ItemIndex=-1 then
  begin
    application.MessageBox('交换机不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxFactory.ItemIndex=-1 then
  begin
    application.MessageBox('供应商不能为空！', '提示', mb_ok);
    exit;
  end;
  if IsExists('AP_INFO','APNO',cxEditAPName.Text,'APID',lAPID) then
  begin
    application.MessageBox('接入点编号不能重复！', '提示', mb_ok);
    exit;
  end;

  if cxEditPort.Text<>'' then begin
    lPort:= cxEditPort.Text
  end else
    lPort:= 'null';

  if cxEditAPPOWER.Text<>'' then begin
    lAPPower:= cxEditAPPOWER.Text
  end else
    lAPPower:= 'null';

  if cxEditFREQUENCY.Text<>'' then begin
    lFrequency:= cxEditFREQUENCY.Text
  end else
    lFrequency:= 'null';

  lSqlstr:= 'update ap_info set '+
            ' APNO= '''+cxEditAPName.Text+''','+
            ' CONNECTTYPE= '+inttostr(GetDicCode(cxComboBoxConType.Text,cxComboBoxConType.Properties.Items))+','+
            ' SWITCHID= '+inttostr(GetCaptionid(cxComboBoxSwitch.Text,cxComboBoxSwitch.Properties.Items))+','+
            ' APPORT= '+lPort+','+
            ' FACTORY= '+inttostr(GetDicCode(cxComboBoxFactory.Text,cxComboBoxFactory.Properties.Items))+','+
            ' APPOWER= '+lAPPower+','+
            ' APKIND= '+ inttostr(GetDicCode(cxComboBoxApType.Text,cxComboBoxApType.Properties.Items))+','+
            ' POWERKIND= '+ inttostr(GetDicCode(cxComboBoxPowerKind.Text,cxComboBoxPowerKind.Properties.Items))+','+
            ' FREQUENCY= '+ lFrequency+','+
            ' APADDR= '''+cxEditAPADDR.Text+''','+
            ' OVERLAY= '''+ cxEditOVERLAY.Text+''','+
            ' MANAGEADDRSEG= '''+cxEditMANAGEADDRSEG.Text+''','+
            ' APIP= '''+cxEditAPIP.Text+''','+
            ' GWADDR= '''+cxEditGWADDR.Text+''','+
            ' MACADDR= '''+cxEditMACADDR.Text+''','+
            ' BUSINESSVLAN= '''+cxEditBUSINESSVLAN.Text+''','+
            ' MANAGEVLAN= '''+cxEditMANAGEVLAN.Text+''','+
            ' APPROPERTY= '+ inttostr(GetDicCode(cxComboBoxAPPROPERTY.Text,cxComboBoxAPPROPERTY.Properties.Items))+
            ' where apid= '+inttostr(lAPID);

  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('修改成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.edit;
    ClientDataSet1.FieldByName('APNO').AsString:= cxEditAPName.Text;
    ClientDataSet1.FieldByName('connecttypename').AsString:= cxComboBoxConType.Text;
    ClientDataSet1.FieldByName('APPORT').AsString:= cxEditPort.Text;
    ClientDataSet1.FieldByName('factoryname').AsString:= cxComboBoxFactory.Text;
    ClientDataSet1.FieldByName('apkindname').AsString:= cxComboBoxApType.Text;
    ClientDataSet1.FieldByName('appropertyname').AsString:= cxComboBoxAPPROPERTY.Text;
    ClientDataSet1.FieldByName('appower').AsString:= cxEditAPPOWER.Text;
    ClientDataSet1.FieldByName('powerkindname').AsString:= cxComboBoxPowerKind.Text;
    ClientDataSet1.FieldByName('frequency').AsString:= cxEditFREQUENCY.Text;
    ClientDataSet1.FieldByName('apaddr').AsString:= cxEditAPADDR.Text;
    ClientDataSet1.FieldByName('overlay').AsString:= cxEditOVERLAY.Text;
    ClientDataSet1.FieldByName('manageaddrseg').AsString:= cxEditMANAGEADDRSEG.Text;
    ClientDataSet1.FieldByName('apip').AsString:= cxEditAPIP.Text;
    ClientDataSet1.FieldByName('gwaddr').AsString:= cxEditGWADDR.Text;
    ClientDataSet1.FieldByName('macaddr').AsString:= cxEditMACADDR.Text;
    ClientDataSet1.FieldByName('businessvlan').AsString:= cxEditBUSINESSVLAN.Text;
    ClientDataSet1.FieldByName('managevlan').AsString:= cxEditMANAGEVLAN.Text;
    ClientDataSet1.FieldByName('switchno').AsString:= cxComboBoxSwitch.Text;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;

    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end
  else
    application.MessageBox('修改失败！','提示',MB_OK );
end;

procedure TFormAPInfo.cxButtonAddClick(Sender: TObject);
var
  lSqlstr ,lPort, lAPPower, lFrequency: string;
  lAPID   : integer;
  lVariant: variant;
  lsuccess: boolean;
begin
  if trim(cxEditAPName.Text)='' then
  begin
    application.MessageBox('接入点编号不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxBuilding.ItemIndex=-1 then
  begin
    application.MessageBox('所属室分点不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxConType.ItemIndex=-1 then
  begin
    application.MessageBox('连接类型不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxSwitch.ItemIndex=-1 then
  begin
    application.MessageBox('交换机不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxFactory.ItemIndex=-1 then
  begin
    application.MessageBox('供应商不能为空！', '提示', mb_ok);
    exit;
  end;
  if IsExists('AP_INFO','APNO',cxEditAPName.Text,'APID',lAPID) then
  begin
    application.MessageBox('接入点编号不能重复！', '提示', mb_ok);
    exit;
  end;

  lAPID:=DM_MTS.TempInterface.GetTheSequenceId('mtu_deviceid');

  if cxEditPort.Text<>'' then begin
    lPort:= cxEditPort.Text
  end else
    lPort:= 'null';

  if cxEditAPPOWER.Text<>'' then begin
    lAPPower:= cxEditAPPOWER.Text
  end else
    lAPPower:= 'null';

  if cxEditFREQUENCY.Text<>'' then begin
    lFrequency:= cxEditFREQUENCY.Text
  end else
    lFrequency:= 'null';

  lSqlstr:= 'insert into ap_info'+
            ' (APID,APNO,CONNECTTYPE,SWITCHID,APPORT,FACTORY,APPOWER,APKIND,POWERKIND,FREQUENCY,'+
            ' APADDR,OVERLAY,MANAGEADDRSEG,APIP,GWADDR,MACADDR,BUSINESSVLAN,MANAGEVLAN,APPROPERTY) '+
            ' values'+
            ' ('+inttostr(lAPID)+','''+
             cxEditAPName.Text+''','+
             inttostr(GetDicCode(cxComboBoxConType.Text,cxComboBoxConType.Properties.Items))+','+
             inttostr(GetCaptionid(cxComboBoxSwitch.Text,cxComboBoxSwitch.Properties.Items))+','+
             lPort+','+
             inttostr(GetDicCode(cxComboBoxFactory.Text,cxComboBoxFactory.Properties.Items))+','+
             lAPPower+','+
             inttostr(GetDicCode(cxComboBoxApType.Text,cxComboBoxApType.Properties.Items))+','+
             inttostr(GetDicCode(cxComboBoxPowerKind.Text,cxComboBoxPowerKind.Properties.Items))+','+
             lFrequency+','''+
             cxEditAPADDR.Text+''','''+
             cxEditOVERLAY.Text+''','''+
             cxEditMANAGEADDRSEG.Text+''','''+
             cxEditAPIP.Text+''','''+
             cxEditGWADDR.Text+''','''+
             cxEditMACADDR.Text+''','''+
             cxEditBUSINESSVLAN.Text+''','''+
             cxEditMANAGEVLAN.Text+''','+
             inttostr(GetDicCode(cxComboBoxAPPROPERTY.Text,cxComboBoxAPPROPERTY.Properties.Items))+
            ')';
  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('新增成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.append;

    ClientDataSet1.FieldByName('APID').AsString:= inttostr(lAPID);
    ClientDataSet1.FieldByName('APNO').AsString:= cxEditAPName.Text;
    ClientDataSet1.FieldByName('connecttypename').AsString:= cxComboBoxConType.Text;
    ClientDataSet1.FieldByName('APPORT').AsString:= cxEditPort.Text;
    ClientDataSet1.FieldByName('factoryname').AsString:= cxComboBoxFactory.Text;
    ClientDataSet1.FieldByName('apkindname').AsString:= cxComboBoxApType.Text;
    ClientDataSet1.FieldByName('appropertyname').AsString:= cxComboBoxAPPROPERTY.Text;
    ClientDataSet1.FieldByName('appower').AsString:= cxEditAPPOWER.Text;
    ClientDataSet1.FieldByName('powerkindname').AsString:= cxComboBoxPowerKind.Text;
    ClientDataSet1.FieldByName('frequency').AsString:= cxEditFREQUENCY.Text;
    ClientDataSet1.FieldByName('apaddr').AsString:= cxEditAPADDR.Text;
    ClientDataSet1.FieldByName('overlay').AsString:= cxEditOVERLAY.Text;
    ClientDataSet1.FieldByName('manageaddrseg').AsString:= cxEditMANAGEADDRSEG.Text;
    ClientDataSet1.FieldByName('apip').AsString:= cxEditAPIP.Text;
    ClientDataSet1.FieldByName('gwaddr').AsString:= cxEditGWADDR.Text;
    ClientDataSet1.FieldByName('macaddr').AsString:= cxEditMACADDR.Text;
    ClientDataSet1.FieldByName('businessvlan').AsString:= cxEditBUSINESSVLAN.Text;
    ClientDataSet1.FieldByName('managevlan').AsString:= cxEditMANAGEVLAN.Text;
    ClientDataSet1.FieldByName('switchno').AsString:= cxComboBoxSwitch.Text;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;

    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end
  else
    application.MessageBox('新增失败！','提示',MB_OK );
end;

procedure TFormAPInfo.cxComboBoxBuildingPropertiesChange(Sender: TObject);
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
//  cxComboBoxSwitch.ItemIndex:= -1;

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

    //根据室分点更新AP
    FilterList(FListSwitch,cxComboBoxSwitch.Properties.Items,MTS_BUILDING,lBuildingid);
  end else
  begin
    FilterList(FListSwitch,cxComboBoxSwitch.Properties.Items,-1,-1);
  end;
//  //判断是否清空cxComboBoxSwitch.Text
//  if cxComboBoxSwitch.Properties.Items.IndexOf(cxComboBoxSwitch.Text)=-1 then
//  begin
//    cxComboBoxSwitch.ItemIndex:= -1;
//  end;
  //结束构造
  FConstruncting:= false;
end;

procedure TFormAPInfo.cxComboBoxSuburbPropertiesChange(Sender: TObject);
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

procedure TFormAPInfo.cxEditAPPOWERKeyPress(Sender: TObject; var Key: Char);
begin
  InPutfloat(Key);
end;

procedure TFormAPInfo.cxEditFREQUENCYKeyPress(Sender: TObject; var Key: Char);
begin
InPutfloat(Key);
end;

procedure TFormAPInfo.cxEditPortKeyPress(Sender: TObject; var Key: Char);
begin
  InPutfloat(Key);
end;

procedure TFormAPInfo.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if FIsSysHandle then exit;
  
  cxEditAPName.Text        := ClientDataSet1.FieldByName('APNO').AsString;
  cxComboBoxConType.ItemIndex   := cxComboBoxConType.Properties.Items.IndexOf(ClientDataSet1.FieldByName('connecttypename').AsString);
  cxEditPort.Text          := ClientDataSet1.FieldByName('APPORT').AsString;
  cxComboBoxFactory.ItemIndex   := cxComboBoxFactory.Properties.Items.IndexOf(ClientDataSet1.FieldByName('factoryname').AsString);
  cxComboBoxApType.ItemIndex    := cxComboBoxApType.Properties.Items.IndexOf(ClientDataSet1.FieldByName('apkindname').AsString);
  cxComboBoxAPPROPERTY.ItemIndex:= cxComboBoxAPPROPERTY.Properties.Items.IndexOf(ClientDataSet1.FieldByName('appropertyname').AsString);
  cxEditAPPOWER.Text       := ClientDataSet1.FieldByName('appower').AsString;
  cxComboBoxPowerKind.ItemIndex := cxComboBoxPowerKind.Properties.Items.IndexOf(ClientDataSet1.FieldByName('powerkindname').AsString);
  cxEditFREQUENCY.Text     := ClientDataSet1.FieldByName('frequency').AsString;
  cxEditAPADDR.Text        := ClientDataSet1.FieldByName('apaddr').AsString;
  cxEditOVERLAY.Text       := ClientDataSet1.FieldByName('overlay').AsString;
  cxEditMANAGEADDRSEG.Text := ClientDataSet1.FieldByName('manageaddrseg').AsString;
  cxEditAPIP.Text          := ClientDataSet1.FieldByName('apip').AsString;
  cxEditGWADDR.Text        := ClientDataSet1.FieldByName('gwaddr').AsString;
  cxEditMACADDR.Text       := ClientDataSet1.FieldByName('macaddr').AsString;
  cxEditBUSINESSVLAN.Text  := ClientDataSet1.FieldByName('businessvlan').AsString;
  cxEditMANAGEVLAN.Text    := ClientDataSet1.FieldByName('managevlan').AsString;
  cxComboBoxBuilding.ItemIndex:= cxComboBoxBuilding.Properties.Items.IndexOf(ClientDataSet1.FieldByName('buildingname').AsString);
  cxComboBoxSuburb.ItemIndex  := cxComboBoxSuburb.Properties.Items.IndexOf(ClientDataSet1.FieldByName('suburbname').AsString);
//  cxComboBoxSwitch.Text  := ClientDataSet1.FieldByName('switchno').AsString;
  cxComboBoxSwitch.ItemIndex  := cxComboBoxSwitch.Properties.Items.IndexOf(ClientDataSet1.FieldByName('switchno').AsString);
end;

procedure TFormAPInfo.FormCreate(Sender: TObject);
begin
  ClientDataSet1.RemoteServer:= Dm_MTS.SocketConnection1;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);

  FListSuburb:= TStringList.Create;
  FListBuilding:= TStringList.Create;
  FListSwitch:= TStringList.Create;
end;

procedure TFormAPInfo.FormShow(Sender: TObject);
begin
  GetDic(5,cxComboBoxConType.Properties.Items);
  GetDic(7,cxComboBoxFactory.Properties.Items);
  GetDic(9,cxComboBoxPowerKind.Properties.Items);
  GetDic(8,cxComboBoxApType.Properties.Items);
  GetDic(6,cxComboBoxAPPROPERTY.Properties.Items);
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,cxComboBoxBuilding.Properties.Items);

  GetSuburbInfo(FListSuburb);
  GetBuildingInfo(FListBuilding);
  GetSwitchInfo(FListSwitch);

  FilterList(FListSuburb,cxComboBoxSuburb.Properties.Items,-1,-1);
  FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);
  FilterList(FListSwitch,cxComboBoxSwitch.Properties.Items,-1,-1);

  cxComboBoxConType.ItemIndex:=-1;
  cxComboBoxFactory.ItemIndex:=-1;
  cxComboBoxPowerKind.ItemIndex:=-1;
  cxComboBoxApType.ItemIndex:=-1;
  cxComboBoxAPPROPERTY.ItemIndex:=-1;
  cxComboBoxBuilding.ItemIndex:=-1;

  AddViewField_AP;
  ShowDevice_AP;
end;

procedure TFormAPInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyOBJ(cxComboBoxConType);
  DestroyOBJ(cxComboBoxBuilding);
  DestroyOBJ(cxComboBoxSwitch);
  DestroyOBJ(cxComboBoxFactory);
  DestroyOBJ(cxComboBoxPowerKind);
  DestroyOBJ(cxComboBoxApType);
  DestroyOBJ(cxComboBoxAPPROPERTY);
  FCxGridHelper.Free;
  ClearTStrings(FListSuburb);
  ClearTStrings(FListBuilding);

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormAPInfo:=nil;
end;

procedure TFormAPInfo.DestroyOBJ(Box: TcxComboBox);
var
  i : Integer;
begin
    for i:= 0 to Box.Properties.Items.Count -1 do
        TCommonObj(Box.Properties.Items.Objects[i]).Free;
    Box.Properties.Items.Clear;
end;

procedure TFormAPInfo.AddViewField_AP;
begin
  AddViewField(cxGrid1DBTableView1,'apid','内部编号');
  AddViewField(cxGrid1DBTableView1,'apno','AP编号');
  AddViewField(cxGrid1DBTableView1,'connecttypename','连接类型'); 
  AddViewField(cxGrid1DBTableView1,'factoryname','供应商');
  AddViewField(cxGrid1DBTableView1,'apport','对应端口');
  AddViewField(cxGrid1DBTableView1,'apkindname','AP型号');
  AddViewField(cxGrid1DBTableView1,'appropertyname','AP性质');
  AddViewField(cxGrid1DBTableView1,'appower','功率');
  AddViewField(cxGrid1DBTableView1,'powerkindname','供电方式');
  AddViewField(cxGrid1DBTableView1,'frequency','频点');
  AddViewField(cxGrid1DBTableView1,'apaddr','AP地址');
  AddViewField(cxGrid1DBTableView1,'overlay','覆盖范围');
  AddViewField(cxGrid1DBTableView1,'manageaddrseg','AP管理地址段');
  AddViewField(cxGrid1DBTableView1,'apip','APIP');
  AddViewField(cxGrid1DBTableView1,'gwaddr','网关地址');
  AddViewField(cxGrid1DBTableView1,'macaddr','MAC地址');
  AddViewField(cxGrid1DBTableView1,'businessvlan','业务VLAN');
  AddViewField(cxGrid1DBTableView1,'managevlan','管理VLAN');
  AddViewField(cxGrid1DBTableView1,'switchno','所属交换机');
  AddViewField(cxGrid1DBTableView1,'buildingname','所属室分点');
  AddViewField(cxGrid1DBTableView1,'suburbname','所属分局');
end;

procedure TFormAPInfo.ShowDevice_AP;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,44,Fm_MainForm.PublicParam.PriveAreaidStrs,gCondition]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

end.
