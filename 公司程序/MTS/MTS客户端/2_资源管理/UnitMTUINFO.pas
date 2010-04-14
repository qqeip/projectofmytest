unit UnitMTUINFO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, Menus, cxGraphics, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, DBClient, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, StdCtrls, cxButtons, cxHeader, cxLabel, cxContainer, CxGridUnit,
  cxGroupBox, StringUtils;

type
  TFormMTUINFO = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    cxHeader1: TcxHeader;
    cxButtonAdd: TcxButton;
    cxButtonModify: TcxButton;
    cxButtonDel: TcxButton;
    cxButtonClear: TcxButton;
    cxButtonClose: TcxButton;
    cxLabel9: TcxLabel;
    cxLabel14: TcxLabel;
    cxLabel15: TcxLabel;
    cxLabel16: TcxLabel;
    cxLabel17: TcxLabel;
    cxLabel18: TcxLabel;
    cxComboBoxSuburb: TcxComboBox;
    cxComboBoxBuilding: TcxComboBox;
    cxComboBoxIsProgram: TcxComboBox;
    cxComboBoxCNET: TcxComboBox;
    cxComboBoxAP: TcxComboBox;
    cxTextEditMTUNO: TcxTextEdit;
    cxTextEditMTUNAME: TcxTextEdit;
    cxTextEditLONGITUDE: TcxTextEdit;
    cxTextEditLATITUDE: TcxTextEdit;
    cxTextEditCall: TcxTextEdit;
    cxTextEditCalled: TcxTextEdit;
    cxTextEditADDRESS: TcxTextEdit;
    cxTextEditCOVER: TcxTextEdit;
    cxGroupBox2: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    cxLabel21: TcxLabel;
    cxComboBoxMTUType: TcxComboBox;
    cxComboBoxLink: TcxComboBox;
    cxComboBoxModel: TcxComboBox;
    cxComboBoxPHS: TcxComboBox;
    cxTextEditCNETType: TcxTextEdit;
    cxTextEditPN: TcxTextEdit;
    cxTextEditCADDR: TcxTextEdit;
    cxLabel7: TcxLabel;
    cxComboBoxShield: TcxComboBox;
    cxLabel22: TcxLabel;
    cxTextEditReservPncode: TcxTextEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxButtonClearClick(Sender: TObject);
    procedure cxButtonCloseClick(Sender: TObject);
    procedure cxComboBoxSuburbPropertiesChange(Sender: TObject);
    procedure cxComboBoxBuildingPropertiesChange(Sender: TObject);
    procedure cxComboBoxAPPropertiesChange(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxComboBoxIsProgramPropertiesChange(Sender: TObject);
    procedure cxTextEditCallKeyPress(Sender: TObject; var Key: Char);
    procedure cxTextEditLONGITUDEKeyPress(Sender: TObject; var Key: Char);
    procedure cxTextEditLONGITUDEExit(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    FMenuShield,FMenuUnShield: TMenuItem;
    FListSuburb,FListBuilding, FListAP, FListCDMA,
    FListPHS, FListLinkMachine: TStringList;
    FIsSysHandle: boolean;
    FConstruncting: boolean;   //过滤ITEMS自己引发的CHANGE
    //加字段
    procedure AddViewField_MTU;
    //取告警模版
    procedure GetAlarmContentModel(aItems:TStrings);
    procedure ShieldOnClickEvent(Sender: TObject);
    procedure UnShieldOnClickEvent(Sender: TObject);
  public
    gCondition :String;
    procedure ShowDevice_MTU;
  end;

var
  FormMTUINFO: TFormMTUINFO;

implementation

uses Ut_DataModule, Ut_Common, Ut_MainForm;

{$R *.dfm}

{ TFormMTUINFO }

procedure TFormMTUINFO.AddViewField_MTU;
begin
  AddViewField(cxGrid1DBTableView1,'mtuid','内部编号');
  AddViewField(cxGrid1DBTableView1,'mtuno','MTU编号');
  AddViewField(cxGrid1DBTableView1,'mtuname','MTU名称');
  AddViewField(cxGrid1DBTableView1,'mtutypename','MTU类型');
  AddViewField(cxGrid1DBTableView1,'longitude','经度');
  AddViewField(cxGrid1DBTableView1,'latitude','纬度');
  AddViewField(cxGrid1DBTableView1,'linkno','上端连接器');
  AddViewField(cxGrid1DBTableView1,'call','电话号码');
  AddViewField(cxGrid1DBTableView1,'called','被叫号码');
  AddViewField(cxGrid1DBTableView1,'modelname','告警门限模板');
  AddViewField(cxGrid1DBTableView1,'mainlook_apname','主监控AP');
  AddViewField(cxGrid1DBTableView1,'mainlook_phsname','主监控PHS');
  AddViewField(cxGrid1DBTableView1,'mainlook_cnetname','主监控C网');
  AddViewField(cxGrid1DBTableView1,'cdmatypename','C网信源类型');
  AddViewField(cxGrid1DBTableView1,'cdmaaddress','C网信源安装位置');
  AddViewField(cxGrid1DBTableView1,'pncode','PN码');
  AddViewField(cxGrid1DBTableView1,'reserve_pncode','第二服务区');
  AddViewField(cxGrid1DBTableView1,'mtuaddr','MTU位置');
  AddViewField(cxGrid1DBTableView1,'overlay','覆盖范围');
  AddViewField(cxGrid1DBTableView1,'isprogramname','是否室分');
  AddViewField(cxGrid1DBTableView1,'buildingname','室分点名称');
  AddViewField(cxGrid1DBTableView1,'suburbname','分局');
  AddViewField(cxGrid1DBTableView1,'shieldstatusname','是否屏蔽');
end;

procedure TFormMTUINFO.cxButtonAddClick(Sender: TObject);
var
  lMtuid: integer;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  if trim(cxTextEditMTUNO.Text)='' then
  begin
    application.MessageBox('MTU编号不能为空！', '提示', mb_ok);
    exit;
  end;
  if trim(cxTextEditMTUNAME.Text)='' then
  begin
    application.MessageBox('MTU名称不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxMTUType.ItemIndex=-1 then
  begin
    application.MessageBox('MTU类型不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxIsProgram.ItemIndex=-1 then
  begin
    application.MessageBox('是否室分不能为空！', '提示', mb_ok);
    exit;
  end;
  if trim(cxTextEditCall.Text)='' then
  begin
    application.MessageBox('电话号码不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxModel.ItemIndex=-1 then
  begin
    application.MessageBox('告警门限模板不能为空！', '提示', mb_ok);
    exit;
  end;
  if trim(cxTextEditADDRESS.Text)='' then
  begin
    application.MessageBox('MTU位置不能为空！', '提示', mb_ok);
    exit;
  end;
  if trim(cxTextEditCOVER.Text)='' then
  begin
    application.MessageBox('覆盖范围不能为空！', '提示', mb_ok);
    exit;
  end;

  if cxComboBoxSuburb.ItemIndex=-1 then
  begin
    application.MessageBox('所属分局不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxIsProgram.Text='室内' then    //室内 室外
  begin
    if cxComboBoxBuilding.ItemIndex=-1 then
    begin
      application.MessageBox('室内MTU的室分点信息不能为空！', '提示', mb_ok);
      exit;
    end;
  end else
  begin
    if cxComboBoxBuilding.ItemIndex<>-1 then
    begin
      application.MessageBox('室外MTU的室分点信息必须为空！', '提示', mb_ok);
      exit;
    end;
  end;

  if IsExists('mtu_info','mtuno',cxTextEditMTUNO.Text) then
  begin
    application.MessageBox('MTU编号不能重复！', '提示', mb_ok);
    exit;
  end;
  if IsExists('mtu_info','mtuname',cxTextEditMTUNAME.Text) then
  begin
    application.MessageBox('MTU名称不能重复！', '提示', mb_ok);
    exit;
  end;

  lMtuid:= DM_MTS.TempInterface.GetTheSequenceId('mtu_deviceid');
  lSqlstr:= 'insert into mtu_info'+
            '(mtuid, mtuno, mtuname, buildingid, overlay, linkid,'+
            ' mtuaddr, call, called, contentcodemodel, mtutype, longitude,'+
            ' latitude, suburb, mainlook_ap, mainlook_phs, mainlook_cnet,'+
            ' isprogram, isstatic, reserve_pncode) values '+
            ' ('+inttostr(lMtuid)+','''+
              uppercase(cxTextEditMTUNO.Text)+''','''+
              cxTextEditMTUNAME.Text+''','+
              inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+','''+
              cxTextEditCOVER.Text+''','+
              inttostr(GetCaptionid(cxComboBoxLink.Text,cxComboBoxLink.Properties.Items))+','''+
              cxTextEditADDRESS.Text+''','''+
              cxTextEditCall.Text+''','''+
              cxTextEditCalled.Text+''','+
              inttostr(GetDicCode(cxComboBoxModel.Text,cxComboBoxModel.Properties.Items))+','+
              inttostr(cxComboBoxMTUType.ItemIndex+1)+','''+
              cxTextEditLONGITUDE.Text+''','''+
              cxTextEditLATITUDE.Text+''','+
              inttostr(GetCaptionid(cxComboBoxSuburb.Text,cxComboBoxSuburb.Properties.Items))+','+
              inttostr(GetCaptionid(cxComboBoxAP.Text,cxComboBoxAP.Properties.Items))+','+
              inttostr(GetCaptionid(cxComboBoxPHS.Text,cxComboBoxPHS.Properties.Items))+','+
              inttostr(GetCaptionid(cxComboBoxCNET.Text,cxComboBoxCNET.Properties.Items))+','+
              inttostr(cxComboBoxIsProgram.ItemIndex)+',1,'''+
              cxTextEditReservPncode.Text+''''+
              ')';
  lVariant:= VarArrayCreate([0,1],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lSqlstr:= 'insert into mtu_shield_list'+
            ' (mtuid, status)'+
            ' values'+
            ' ('+inttostr(lMtuid)+','+inttostr(cxComboBoxShield.ItemIndex)+')';
  lVariant[1]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('新增成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.append;
    ClientDataSet1.FieldByName('mtuid').AsString:= inttostr(lMtuid);
    ClientDataSet1.FieldByName('mtuno').AsString:= cxTextEditMTUNO.Text;
    ClientDataSet1.FieldByName('mtuname').AsString:= cxTextEditMTUNAME.Text;
    ClientDataSet1.FieldByName('mtutypename').AsString:= cxComboBoxMTUType.Text;
    ClientDataSet1.FieldByName('longitude').AsString:= cxTextEditLONGITUDE.Text;
    ClientDataSet1.FieldByName('latitude').AsString:= cxTextEditLATITUDE.Text;
    ClientDataSet1.FieldByName('linkno').AsString:= cxComboBoxLink.Text;
    ClientDataSet1.FieldByName('call').AsString:= cxTextEditCall.Text;
    ClientDataSet1.FieldByName('called').AsString:= cxTextEditCalled.Text;
    ClientDataSet1.FieldByName('modelname').AsString:= cxComboBoxModel.Text;
    ClientDataSet1.FieldByName('mainlook_apname').AsString:= cxComboBoxAP.Text;
    ClientDataSet1.FieldByName('mainlook_phsname').AsString:= cxComboBoxPHS.Text;
    ClientDataSet1.FieldByName('mainlook_cnetname').AsString:= cxComboBoxCNET.Text;
    ClientDataSet1.FieldByName('mtuaddr').AsString:= cxTextEditADDRESS.Text;
    ClientDataSet1.FieldByName('overlay').AsString:= cxTextEditCOVER.Text;
    ClientDataSet1.FieldByName('isprogramname').AsString:= cxComboBoxIsProgram.Text;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;
    ClientDataSet1.FieldByName('shieldstatusname').AsString:= cxComboBoxShield.Text;
    ClientDataSet1.FieldByName('reserve_pncode').AsString:= cxTextEditReservPncode.Text;
    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end else
    application.MessageBox('新增失败！','提示',MB_OK );
end;

procedure TFormMTUINFO.cxButtonClearClick(Sender: TObject);
begin
  cxTextEditMTUNO.Text:= '';
  cxTextEditMTUNAME.Text:= '';
  cxTextEditLONGITUDE.Text:= '';
  cxTextEditLATITUDE.Text:= '';
  cxTextEditCall.Text:= '';
  cxTextEditCalled.Text:= '';
  cxTextEditADDRESS.Text:= '';
  cxTextEditCOVER.Text:= '';
  cxTextEditCNETType.Text:= '';
  cxTextEditPN.Text:= '';
  cxTextEditCADDR.Text:= '';
  cxTextEditReservPncode.Text:= '';

  cxComboBoxSuburb.ItemIndex:= -1;
  cxComboBoxBuilding.ItemIndex:= -1;
  cxComboBoxIsProgram.ItemIndex:= -1;
  cxComboBoxCNET.ItemIndex:= -1;
  cxComboBoxAP.ItemIndex:= -1;
  cxComboBoxMTUType.ItemIndex:= -1;
  cxComboBoxLink.ItemIndex:= -1;
  cxComboBoxModel.ItemIndex:= -1;
  cxComboBoxPHS.ItemIndex:= -1;
  cxComboBoxShield.ItemIndex:= -1;
end;

procedure TFormMTUINFO.cxButtonCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFormMTUINFO.cxButtonDelClick(Sender: TObject);
var
  lSqlstr: string;
  lMtuid: integer;
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

  lMtuid:= ClientDataSet1.FieldByName('mtuid').AsInteger;


  lVariant:= VarArrayCreate([0,1],varVariant);
  lSqlstr:= 'delete from mtu_info where mtuid='+inttostr(lMtuid);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lSqlstr:= 'delete from mtu_shield_list where mtuid='+inttostr(lMtuid);
  lVariant[1]:= VarArrayOf([2,4,13,lSqlstr]);
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

procedure TFormMTUINFO.cxButtonModifyClick(Sender: TObject);
var
  lMtuid: integer;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  lMtuid:= ClientDataSet1.FieldByName('mtuid').AsInteger;

  if trim(cxTextEditMTUNO.Text)='' then
  begin
    application.MessageBox('MTU编号不能为空！', '提示', mb_ok);
    exit;
  end;
  if trim(cxTextEditMTUNAME.Text)='' then
  begin
    application.MessageBox('MTU名称不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxMTUType.ItemIndex=-1 then
  begin
    application.MessageBox('MTU类型不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxIsProgram.ItemIndex=-1 then
  begin
    application.MessageBox('是否室分不能为空！', '提示', mb_ok);
    exit;
  end;
  if trim(cxTextEditCall.Text)='' then
  begin
    application.MessageBox('电话号码不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxModel.ItemIndex=-1 then
  begin
    application.MessageBox('告警门限模板不能为空！', '提示', mb_ok);
    exit;
  end;
  if trim(cxTextEditADDRESS.Text)='' then
  begin
    application.MessageBox('MTU位置不能为空！', '提示', mb_ok);
    exit;
  end;
  if trim(cxTextEditCOVER.Text)='' then
  begin
    application.MessageBox('覆盖范围不能为空！', '提示', mb_ok);
    exit;
  end;

  if cxComboBoxSuburb.ItemIndex=-1 then
  begin
    application.MessageBox('所属分局不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxIsProgram.Text='室内' then    //室内 室外
  begin
    if cxComboBoxBuilding.ItemIndex=-1 then
    begin
      application.MessageBox('室内MTU的室分点信息不能为空！', '提示', mb_ok);
      exit;
    end;
  end else
  begin
    if cxComboBoxBuilding.ItemIndex<>-1 then
    begin
      application.MessageBox('室外MTU的室分点信息必须为空！', '提示', mb_ok);
      exit;
    end;
  end;

  if IsExists('mtu_info','mtuno',cxTextEditMTUNO.Text,'MTUID',lMtuid) then
  begin
    application.MessageBox('MTU编号不能重复！', '提示', mb_ok);
    exit;
  end;
  if IsExists('mtu_info','mtuname',cxTextEditMTUNAME.Text,'MTUID',lMtuid) then
  begin
    application.MessageBox('MTU名称不能重复！', '提示', mb_ok);
    exit;
  end;
  lSqlstr:='update mtu_info'+
           ' set mtuno = '''+uppercase(cxTextEditMTUNO.Text)+''','+
           'mtuname = '''+cxTextEditMTUNAME.Text+''','+
           'buildingid = '+inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+','+
           'overlay = '''+cxTextEditCOVER.Text+''','+
           'linkid = '+inttostr(GetCaptionid(cxComboBoxLink.Text,cxComboBoxLink.Properties.Items))+','+
           'mtuaddr = '''+cxTextEditADDRESS.Text+''','+
           'call = '''+cxTextEditCall.Text+''','+
           'called = '''+cxTextEditCalled.Text+''','+
           'contentcodemodel = '+inttostr(GetDicCode(cxComboBoxModel.Text,cxComboBoxModel.Properties.Items))+','+
           'mtutype = '''+inttostr(cxComboBoxMTUType.ItemIndex+1)+''','+
           'longitude = '''+cxTextEditLONGITUDE.Text+''','+
           'latitude = '''+cxTextEditLATITUDE.Text+''','+
           'suburb = '+inttostr(GetCaptionid(cxComboBoxSuburb.Text,cxComboBoxSuburb.Properties.Items))+','+
           'mainlook_ap = '+inttostr(GetCaptionid(cxComboBoxAP.Text,cxComboBoxAP.Properties.Items))+','+
           'mainlook_phs = '+inttostr(GetCaptionid(cxComboBoxPHS.Text,cxComboBoxPHS.Properties.Items))+','+
           'mainlook_cnet = '+inttostr(GetCaptionid(cxComboBoxCNET.Text,cxComboBoxCNET.Properties.Items))+','+
           'isprogram = '+inttostr(cxComboBoxIsProgram.ItemIndex)+','+
           'reserve_pncode = '''+cxTextEditReservPncode.Text+''''+
           ' where mtuid='+inttostr(lMtuid);
  lVariant:= VarArrayCreate([0,1],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lSqlstr:= 'update mtu_shield_list set'+
            '  status='+inttostr(cxComboBoxShield.ItemIndex)+
            ' where mtuid='+inttostr(lMtuid);
  lVariant[1]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('修改成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.edit;
    ClientDataSet1.FieldByName('mtuid').AsString:= inttostr(lMtuid);
    ClientDataSet1.FieldByName('mtuno').AsString:= cxTextEditMTUNO.Text;
    ClientDataSet1.FieldByName('mtuname').AsString:= cxTextEditMTUNAME.Text;
    ClientDataSet1.FieldByName('mtutypename').AsString:= cxComboBoxMTUType.Text;
    ClientDataSet1.FieldByName('longitude').AsString:= cxTextEditLONGITUDE.Text;
    ClientDataSet1.FieldByName('latitude').AsString:= cxTextEditLATITUDE.Text;
    ClientDataSet1.FieldByName('linkno').AsString:= cxComboBoxLink.Text;
    ClientDataSet1.FieldByName('call').AsString:= cxTextEditCall.Text;
    ClientDataSet1.FieldByName('called').AsString:= cxTextEditCalled.Text;
    ClientDataSet1.FieldByName('modelname').AsString:= cxComboBoxModel.Text;
    ClientDataSet1.FieldByName('mainlook_apname').AsString:= cxComboBoxAP.Text;
    ClientDataSet1.FieldByName('mainlook_phsname').AsString:= cxComboBoxPHS.Text;
    ClientDataSet1.FieldByName('mainlook_cnetname').AsString:= cxComboBoxCNET.Text;
    ClientDataSet1.FieldByName('mtuaddr').AsString:= cxTextEditADDRESS.Text;
    ClientDataSet1.FieldByName('overlay').AsString:= cxTextEditCOVER.Text;
    ClientDataSet1.FieldByName('isprogramname').AsString:= cxComboBoxIsProgram.Text;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;
    ClientDataSet1.FieldByName('shieldstatusname').AsString:= cxComboBoxShield.Text;
    ClientDataSet1.FieldByName('reserve_pncode').AsString:= cxTextEditReservPncode.Text;
    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end else
    application.MessageBox('修改失败！','提示',MB_OK );
end;

procedure TFormMTUINFO.cxComboBoxAPPropertiesChange(Sender: TObject);
var
  lCDMAid: integer;
begin
//  if TcxComboBox(Sender).Text='' then
//  begin
//    if cxComboBoxIsProgram.ItemIndex=1 then
//    begin
//      cxComboBoxAP.Enabled:= true;
//      cxComboBoxPHS.Enabled:= true;
//    end;
//    cxComboBoxCNET.Enabled:= true;
//    //exit;
//  end else
//  begin 
//    if Sender = cxComboBoxAP then
//    begin
//      cxComboBoxPHS.Enabled:= false;
//      cxComboBoxCNET.Enabled:= false;
//    end
//    else if Sender = cxComboBoxPHS then
//    begin
//      cxComboBoxAP.Enabled:= false;
//      cxComboBoxCNET.Enabled:= false;
//    end
//    else if Sender = cxComboBoxCNET then
//    begin
//      cxComboBoxAP.Enabled:= false;
//      cxComboBoxPHS.Enabled:= false;
//    end;
//  end;


  //刷新对应的信息
  if Sender = cxComboBoxCNET then
  begin
    lCDMAid:= GetCaptionid(cxComboBoxCNET.Text,cxComboBoxCNET.Properties.Items);
    if lCDMAid>-1 then
    begin
      with DM_MTS.cds_common do
      begin
        Close;
        ProviderName:='dsp_General_data';
        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,23,lCDMAid]),0);
        if not eof then
        begin
          cxTextEditPN.Text:= Fieldbyname('pncode').AsString;
          cxTextEditCADDR.Text:= Fieldbyname('address').AsString;
          cxTextEditCNETType.Text:= Fieldbyname('cdmatypename').AsString;
        end;
      end;
    end else
      begin
        cxTextEditPN.Text:= '';
        cxTextEditCADDR.Text:= '';
        cxTextEditCNETType.Text:= '';
      end;
  end;
end;

procedure TFormMTUINFO.cxComboBoxBuildingPropertiesChange(Sender: TObject);
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
  cxComboBoxAP.ItemIndex:= -1;
  cxComboBoxPHS.ItemIndex:= -1;
  cxComboBoxCNET.ItemIndex:= -1;
  cxComboBoxLink.ItemIndex:= -1;

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
    //根据室分点更新经纬度
    cxTextEditLONGITUDE.Text:= TFilterObject(cxComboBoxBuilding.Properties.Items.Objects[cxComboBoxBuilding.ItemIndex]).Longitude;
    cxTextEditLATITUDE.Text:= TFilterObject(cxComboBoxBuilding.Properties.Items.Objects[cxComboBoxBuilding.ItemIndex]).Latitude;

    //根据室分点更新AP
    FilterList(FListAP,cxComboBoxAP.Properties.Items,MTS_BUILDING,lBuildingid);
    //根据室分点更新PHS
    FilterList(FListPHS,cxComboBoxPHS.Properties.Items,MTS_BUILDING,lBuildingid);
    //根据室分点更新CNET
    FilterList(FListCDMA,cxComboBoxCNET.Properties.Items,MTS_BUILDING,lBuildingid);
    //根据室分点更新LINK
    FilterList(FListLinkMachine,cxComboBoxLink.Properties.Items,MTS_BUILDING,lBuildingid);
  end else
  begin
    FilterList(FListAP,cxComboBoxAP.Properties.Items,-1,-1);
    FilterList(FListPHS,cxComboBoxPHS.Properties.Items,-1,-1);
    FilterList(FListCDMA,cxComboBoxCNET.Properties.Items,-1,-1);
    FilterList(FListLinkMachine,cxComboBoxLink.Properties.Items,-1,-1);
  end;
  //结束构造
  FConstruncting:= false;
end;

procedure TFormMTUINFO.cxComboBoxIsProgramPropertiesChange(Sender: TObject);
begin
  if cxComboBoxIsProgram.ItemIndex=1 then  //0 室外 1 室内
  begin
    cxComboBoxBuilding.Enabled:= true;
    cxComboBoxAP.Enabled:= true;
    cxComboBoxPHS.Enabled:= true;
  end else
  begin
    cxComboBoxBuilding.Enabled:= false;
    cxComboBoxAP.Enabled:= false;
    cxComboBoxPHS.Enabled:= false;
    cxComboBoxBuilding.ItemIndex:= -1;
    cxComboBoxAP.ItemIndex:= -1;
    cxComboBoxPHS.ItemIndex:= -1;
  end;
end;

procedure TFormMTUINFO.cxComboBoxSuburbPropertiesChange(Sender: TObject);
var
  lSuburbid: integer;
begin
  if FConstruncting then exit;
  //开始构造
  FConstruncting:= true;

  //还原室分点为未选
  cxComboBoxBuilding.ItemIndex:= -1;
  cxComboBoxCNET.ItemIndex:= -1;

  lSuburbid:= GetCaptionid(cxComboBoxSuburb.Text,cxComboBoxSuburb.Properties.Items);
  //更新室分点
  if lSuburbid>-1 then
  begin
    //这里会不会重复？？？？
    FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,MTS_SUBURB,lSuburbid);
    FilterList(FListCDMA,cxComboBoxCNET.Properties.Items,MTS_SUBURB,lSuburbid);
  end else
  begin
    FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);
    FilterList(FListCDMA,cxComboBoxCNET.Properties.Items,-1,-1);
  end;
  //结束构造
  FConstruncting:= false;
end;

procedure TFormMTUINFO.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if FIsSysHandle then exit;
//  ClientDataSet1.FieldByName('mtuid').AsString:= inttostr(lMtuid);
  cxTextEditMTUNO.Text:= ClientDataSet1.FieldByName('mtuno').AsString;
  cxTextEditMTUNAME.Text:= ClientDataSet1.FieldByName('mtuname').AsString;
  cxComboBoxMTUType.ItemIndex:= cxComboBoxMTUType.Properties.Items.IndexOf(ClientDataSet1.FieldByName('mtutypename').AsString);
  cxTextEditLONGITUDE.Text:= ClientDataSet1.FieldByName('longitude').AsString;
  cxTextEditLATITUDE.Text:= ClientDataSet1.FieldByName('latitude').AsString;
  cxTextEditCall.Text:= ClientDataSet1.FieldByName('call').AsString;
  cxTextEditCalled.Text:= ClientDataSet1.FieldByName('called').AsString;
  cxComboBoxModel.ItemIndex:= cxComboBoxModel.Properties.Items.IndexOf(ClientDataSet1.FieldByName('modelname').AsString);
  cxTextEditADDRESS.Text:= ClientDataSet1.FieldByName('mtuaddr').AsString;
  cxTextEditCOVER.Text:= ClientDataSet1.FieldByName('overlay').AsString;
  cxComboBoxIsProgram.ItemIndex:= cxComboBoxIsProgram.Properties.Items.IndexOf(ClientDataSet1.FieldByName('isprogramname').AsString);
  cxComboBoxSuburb.ItemIndex:= cxComboBoxSuburb.Properties.Items.IndexOf(ClientDataSet1.FieldByName('suburbname').AsString);
  cxComboBoxBuilding.ItemIndex:= cxComboBoxBuilding.Properties.Items.IndexOf(ClientDataSet1.FieldByName('buildingname').AsString);
  cxComboBoxAP.ItemIndex:= cxComboBoxAP.Properties.Items.IndexOf(ClientDataSet1.FieldByName('mainlook_apname').AsString);
  cxComboBoxPHS.ItemIndex:= cxComboBoxPHS.Properties.Items.IndexOf(ClientDataSet1.FieldByName('mainlook_phsname').AsString);
  cxComboBoxCNET.ItemIndex:= cxComboBoxCNET.Properties.Items.IndexOf(ClientDataSet1.FieldByName('mainlook_cnetname').AsString);
  cxComboBoxLink.ItemIndex:= cxComboBoxLink.Properties.Items.IndexOf(ClientDataSet1.FieldByName('linkno').AsString);
  cxComboBoxShield.ItemIndex:= cxComboBoxShield.Properties.Items.IndexOf(ClientDataSet1.FieldByName('shieldstatusname').AsString);
  cxTextEditReservPncode.Text:= ClientDataSet1.FieldByName('reserve_pncode').AsString;
end;

procedure TFormMTUINFO.cxTextEditCallKeyPress(Sender: TObject; var Key: Char);
begin
  InPutNum(Key);
end;

procedure TFormMTUINFO.cxTextEditLONGITUDEExit(Sender: TObject);
var
  lValue: string;
begin
  lValue:= TcxTextEdit(Sender).Text;
  if lValue='' then exit;
  try
    strtofloat(lValue);
  except
    application.MessageBox('请输入有效数字！','提示',MB_OK );
    TcxTextEdit(Sender).Text:= '';
  end;
end;

procedure TFormMTUINFO.cxTextEditLONGITUDEKeyPress(Sender: TObject;
  var Key: Char);
begin
  InPutfloat(Key);
end;

procedure TFormMTUINFO.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMenuShield.Free;
  FMenuUnShield.Free;
  FCxGridHelper.Free;
  ClearTStrings(FListSuburb);
  ClearTStrings(FListBuilding);
  ClearTStrings(FListAP);
  ClearTStrings(FListCDMA);
  ClearTStrings(FListPHS);
  ClearTStrings(FListLinkMachine);

  ClearTStrings(cxComboBoxSuburb.Properties.Items);
  ClearTStrings(cxComboBoxBuilding.Properties.Items);
  ClearTStrings(cxComboBoxModel.Properties.Items);
  ClearTStrings(cxComboBoxAP.Properties.Items);
  ClearTStrings(cxComboBoxPHS.Properties.Items);
  ClearTStrings(cxComboBoxCNET.Properties.Items);
  ClearTStrings(cxComboBoxLink.Properties.Items);

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormMTUINFO:=nil;
end;

procedure TFormMTUINFO.FormCreate(Sender: TObject);
begin
  ClientDataSet1.RemoteServer:= Dm_MTS.SocketConnection1;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);
  FCxGridHelper.AppendMenuItem('-',nil);
  FMenuShield:= FCxGridHelper.AppendMenuItem('屏蔽MTU告警',ShieldOnClickEvent);
  FMenuUnShield:= FCxGridHelper.AppendMenuItem('取消屏蔽',UnShieldOnClickEvent);

  FListSuburb:= TStringList.Create;
  FListBuilding:= TStringList.Create;
  FListAP:= TStringList.Create;
  FListCDMA:= TStringList.Create;
  FListPHS:= TStringList.Create;
  FListLinkMachine := TStringList.Create;
end;

procedure TFormMTUINFO.FormShow(Sender: TObject);
begin
  GetAlarmContentModel(cxComboBoxModel.Properties.Items);

  GetSuburbInfo(FListSuburb);
  GetBuildingInfo(FListBuilding);
  GetAPInfo(FListAP);
  GetPHSInfo(FListPHS);
  GetCNETInfo(FListCDMA);
  GetLinkInfo(FListLinkMachine);

  FilterList(FListSuburb,cxComboBoxSuburb.Properties.Items,-1,-1);
  FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);
  FilterList(FListAP,cxComboBoxAP.Properties.Items,-1,-1);
  FilterList(FListPHS,cxComboBoxPHS.Properties.Items,-1,-1);
  FilterList(FListCDMA,cxComboBoxCNET.Properties.Items,-1,-1);
  FilterList(FListLinkMachine,cxComboBoxLink.Properties.Items,-1,-1);

  AddViewField_MTU;
  ShowDevice_MTU;
end;

procedure TFormMTUINFO.GetAlarmContentModel(aItems: TStrings);
var
  lWdInteger:TWdInteger;
begin
  ClearTStrings(aItems);
  with DM_MTS.cds_common do
  begin
    lWdInteger:=TWdInteger.Create(-1);
    aItems.AddObject('默认模板',lWdInteger);
    Close;
    ProviderName:='dsp_General_data';
    Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,21]),0);
    while not eof do
    begin
      lWdInteger:=TWdInteger.Create(Fieldbyname('modelid').AsInteger);
      aItems.AddObject(Fieldbyname('modelname').AsString,lWdInteger);
      next;
    end;
    Close;
  end;
end;

procedure TFormMTUINFO.ShowDevice_MTU;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,22,Fm_MainForm.PublicParam.PriveAreaidStrs,gCondition]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormMTUINFO.ShieldOnClickEvent(Sender: TObject);
var
  lMtuid: integer;
  lMtuid_Index,lShield_Index: integer;
  I: integer;
  lRecordIndex  : integer;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;

  try
    lMtuid_Index:=cxGrid1DBTableView1.GetColumnByFieldName('MTUID').Index;
  except
    lMtuid_Index:=-1;
  end;
  try
    lShield_Index:=cxGrid1DBTableView1.GetColumnByFieldName('SHIELDSTATUSNAME').Index;
  except
    lShield_Index:=-1;
  end;
  if (lMtuid_Index=-1) or (lShield_Index=-1) then
  begin
    Application.MessageBox('未获得关键字段MTUID,SHIELDSTATUSNAME！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  try
    for I := cxGrid1DBTableView1.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex := cxGrid1DBTableView1.DataController.GetSelectedRowIndex(I);
      lRecordIndex := cxGrid1DBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
      lMtuid := cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lMtuid_Index);
      lSqlstr:=lSqlstr+'select '+inttostr(lMtuid)+' mtuid,0 status from dual union all ';
    end;
    lSqlstr:= copy(lSqlstr,1,length(lSqlstr)-11);
    lSqlstr:='merge into mtu_shield_list a'+
             '    using ('+lSqlstr+') b'+
             '    on (a.mtuid=b.mtuid)'+
             ' when matched then'+
             '    update set a.status=b.status'+
             ' when not matched then'+
             '    insert (mtuid,status) values (b.mtuid,b.status)';
    lVariant:= VarArrayCreate([0,0],varVariant);
    lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
    lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      //更新屏蔽字段
      for I := cxGrid1DBTableView1.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := cxGrid1DBTableView1.DataController.GetSelectedRowIndex(I);
        lRecordIndex := cxGrid1DBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
        cxGrid1DBTableView1.DataController.SetValue(lRecordIndex,lShield_Index,'是');
      end;
    end else
      application.MessageBox('屏蔽失败！','提示',MB_OK );
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFormMTUINFO.UnShieldOnClickEvent(Sender: TObject);
var
  lMtuid: integer;
  lMtuid_Index,lShield_Index: integer;
  I: integer;
  lRecordIndex  : integer;
  lSuccess :Boolean;
  lSqlstr: string;
  lVariant: variant;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;

  try
    lMtuid_Index:=cxGrid1DBTableView1.GetColumnByFieldName('MTUID').Index;
  except
    lMtuid_Index:=-1;
  end;
  try
    lShield_Index:=cxGrid1DBTableView1.GetColumnByFieldName('SHIELDSTATUSNAME').Index;
  except
    lShield_Index:=-1;
  end;
  if (lMtuid_Index=-1) or (lShield_Index=-1) then
  begin
    Application.MessageBox('未获得关键字段MTUID,SHIELDSTATUSNAME！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
  Screen.Cursor := crHourGlass;
  try
    for I := cxGrid1DBTableView1.DataController.GetSelectedCount -1 downto 0 do
    begin
      lRecordIndex := cxGrid1DBTableView1.DataController.GetSelectedRowIndex(I);
      lRecordIndex := cxGrid1DBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
      lMtuid := cxGrid1DBTableView1.DataController.GetValue(lRecordIndex,lMtuid_Index);
      lSqlstr:=lSqlstr+'select '+inttostr(lMtuid)+' mtuid,1 status from dual union all ';
    end;
    lSqlstr:= copy(lSqlstr,1,length(lSqlstr)-11);
    lSqlstr:='merge into mtu_shield_list a'+
             '    using ('+lSqlstr+') b'+
             '    on (a.mtuid=b.mtuid)'+
             ' when matched then'+
             '    update set a.status=b.status'+
             ' when not matched then'+
             '    insert (mtuid,status) values (b.mtuid,b.status)';
    lVariant:= VarArrayCreate([0,0],varVariant);
    lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
    lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
      //更新屏蔽字段
      for I := cxGrid1DBTableView1.DataController.GetSelectedCount -1 downto 0 do
      begin
        lRecordIndex := cxGrid1DBTableView1.DataController.GetSelectedRowIndex(I);
        lRecordIndex := cxGrid1DBTableView1.DataController.FilteredRecordIndex[lRecordIndex];
        cxGrid1DBTableView1.DataController.SetValue(lRecordIndex,lShield_Index,'否');
      end;
    end else
      application.MessageBox('取消屏蔽失败！','提示',MB_OK );
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
