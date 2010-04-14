unit UnitCDMASource;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxContainer, cxGroupBox, Menus, StdCtrls,
  cxButtons, cxHeader, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, CxGridUnit,
  DBClient, StringUtils;

type
  TFormCDMASource = class(TForm)
    cxGroupBox1: TcxGroupBox;
    cxGroupBox2: TcxGroupBox;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
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
    cxComboBoxDeviceType: TcxComboBox;
    cxComboBoxFactory: TcxComboBox;
    cxComboBoxCDMAType: TcxComboBox;
    cxComboBoxPower: TcxComboBox;
    cxTextEditCDMANO: TcxTextEdit;
    cxTextEditCDMANAME: TcxTextEdit;
    cxTextEditLONGITUDE: TcxTextEdit;
    cxTextEditLATITUDE: TcxTextEdit;
    cxTextEditBELONG_MSC: TcxTextEdit;
    cxTextEditBELONG_BSC: TcxTextEdit;
    cxTextEditBELONG_CELL: TcxTextEdit;
    cxTextEditBELONG_BTS: TcxTextEdit;
    cxTextEditADDRESS: TcxTextEdit;
    cxTextEditCOVER: TcxTextEdit;
    cxTextEditPN: TcxTextEdit;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxComboBoxSuburbPropertiesChange(Sender: TObject);
    procedure cxComboBoxBuildingPropertiesChange(Sender: TObject);
    procedure cxButtonCloseClick(Sender: TObject);
    procedure cxButtonClearClick(Sender: TObject);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxComboBoxIsProgramPropertiesChange(Sender: TObject);
    procedure cxTextEditLONGITUDEKeyPress(Sender: TObject; var Key: Char);
    procedure cxTextEditLONGITUDEExit(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    FListSuburb,FListBuilding,FListLink: TStringList;
    FIsSysHandle: boolean;
    FConstruncting: boolean;   //����ITEMS�Լ�������CHANGE
    //���ֶ�
    procedure AddViewField_CDMA;
  public
    gCondition :String;
    procedure ShowDevice_CDMA;
  end;

var
  FormCDMASource: TFormCDMASource;

implementation

uses Ut_DataModule, Ut_MainForm, Ut_Common;

{$R *.dfm}

procedure TFormCDMASource.AddViewField_CDMA;
begin
  AddViewField(cxGrid1DBTableView1,'CDMAID','�ڲ����');
  AddViewField(cxGrid1DBTableView1,'cdmano','��Դ���');
  AddViewField(cxGrid1DBTableView1,'cdmaname','��Դ����');
  AddViewField(cxGrid1DBTableView1,'cdmatypename','��Դ����');
  AddViewField(cxGrid1DBTableView1,'longitude','����');
  AddViewField(cxGrid1DBTableView1,'latitude','γ��');
  AddViewField(cxGrid1DBTableView1,'belong_msc','����MSC���');
  AddViewField(cxGrid1DBTableView1,'belong_bsc','����BSC���');
  AddViewField(cxGrid1DBTableView1,'belong_cell','�����������');
  AddViewField(cxGrid1DBTableView1,'belong_bts','������վ���');
  AddViewField(cxGrid1DBTableView1,'pncode','PN ��');
  AddViewField(cxGrid1DBTableView1,'devicetypename','�豸�ͺ�');
  AddViewField(cxGrid1DBTableView1,'factorytypename','��Դ����');
  AddViewField(cxGrid1DBTableView1,'powertypename','��Դ����');
  AddViewField(cxGrid1DBTableView1,'address','��װλ��');
  AddViewField(cxGrid1DBTableView1,'cover','���Ƿ�Χ');
  AddViewField(cxGrid1DBTableView1,'isprogramname','�Ƿ��ҷ�');
  AddViewField(cxGrid1DBTableView1,'buildingname','�ҷֵ�����');
  AddViewField(cxGrid1DBTableView1,'suburbname','�־�');
//  AddViewField(cxGrid1DBTableView1,'areaname','������');
//  AddViewField(cxGrid1DBTableView1,'cityname','����');
end;

procedure TFormCDMASource.cxButtonAddClick(Sender: TObject);
var
  lSqlstr: string;
  lCDMAid: integer;
  lVariant: variant;
  lsuccess: boolean;
begin
  if trim(cxTextEditCDMANO.Text)='' then
  begin
    application.MessageBox('��Դ��Ų���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if trim(cxTextEditCDMANAME.Text)='' then
  begin
    application.MessageBox('��Դ���Ʋ���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if cxComboBoxCDMAType.ItemIndex=-1 then
  begin
    application.MessageBox('��Դ���Ͳ���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if cxComboBoxIsProgram.ItemIndex=-1 then
  begin
    application.MessageBox('�Ƿ��ҷֲ���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if trim(cxTextEditADDRESS.Text)='' then
  begin
    application.MessageBox('��װλ�ò���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if trim(cxTextEditCOVER.Text)='' then
  begin
    application.MessageBox('���Ƿ�Χ����Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;

  if cxComboBoxSuburb.ItemIndex=-1 then
  begin
    application.MessageBox('�����־ֲ���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if cxComboBoxIsProgram.Text='����' then    //���� ����
  begin
    if cxComboBoxBuilding.ItemIndex=-1 then
    begin
      application.MessageBox('������Դ���ҷֵ���Ϣ����Ϊ�գ�', '��ʾ', mb_ok);
      exit;
    end;
  end else
  begin
    if cxComboBoxBuilding.ItemIndex<>-1 then
    begin
      application.MessageBox('������Դ���ҷֵ���Ϣ����Ϊ�գ�', '��ʾ', mb_ok);
      exit;
    end;
  end;

  if IsExists('CDMA_INFO','CDMANO',cxTextEditCDMANO.Text) then
  begin
    application.MessageBox('��Դ��Ų����ظ���', '��ʾ', mb_ok);
    exit;
  end;
  if IsExists('CDMA_INFO','CDMANAME',cxTextEditCDMANAME.Text) then
  begin
    application.MessageBox('��Դ���Ʋ����ظ���', '��ʾ', mb_ok);
    exit;
  end;

  lCDMAid:= DM_MTS.TempInterface.GetTheSequenceId('mtu_deviceid');
  lSqlstr:= 'insert into cdma_info'+
            ' (cdmaid, buildingid, cdmano, cdmaname, cdmatype, belong_bts,'+
            ' belong_msc, belong_bsc, belong_cell, pncode, devicetype,'+
            ' factory, power, address, cover, longitude, latitude, suburb, isprogram)'+
            ' values'+
            ' ('+inttostr(lCDMAid)+','+
             inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+','''+
             cxTextEditCDMANO.Text+''','''+
             cxTextEditCDMANAME.Text+''','+
             inttostr(cxComboBoxCDMAType.ItemIndex+1)+','''+
             cxTextEditBELONG_BTS.Text+''','''+
             cxTextEditBELONG_MSC.Text+''','''+
             cxTextEditBELONG_BSC.Text+''','''+
             cxTextEditBELONG_CELL.Text+''','''+
             cxTextEditPN.Text+''','+
             inttostr(GetDicCode(cxComboBoxDeviceType.Text,cxComboBoxDeviceType.Properties.Items))+','+
             inttostr(GetDicCode(cxComboBoxFactory.Text,cxComboBoxFactory.Properties.Items))+','+
             inttostr(GetDicCode(cxComboBoxPower.Text,cxComboBoxPower.Properties.Items))+','''+
             cxTextEditADDRESS.Text+''','''+
             cxTextEditCOVER.Text+''','''+
             cxTextEditLONGITUDE.Text+''','''+
             cxTextEditLATITUDE.Text+''','+
             inttostr(GetCaptionid(cxComboBoxSuburb.Text,cxComboBoxSuburb.Properties.Items))+','+
             inttostr(cxComboBoxIsProgram.ItemIndex)+
             ')';
  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('�����ɹ���','��ʾ',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.append;
    ClientDataSet1.FieldByName('cdmaid').AsString:= inttostr(lCDMAid);
    ClientDataSet1.FieldByName('cdmano').AsString:= cxTextEditCDMANO.Text;
    ClientDataSet1.FieldByName('cdmaname').AsString:= cxTextEditCDMANAME.Text;
    ClientDataSet1.FieldByName('cdmatypename').AsString:= cxComboBoxCDMAType.Text;
    ClientDataSet1.FieldByName('longitude').AsString:= cxTextEditLONGITUDE.Text;
    ClientDataSet1.FieldByName('latitude').AsString:= cxTextEditLATITUDE.Text;
    ClientDataSet1.FieldByName('belong_msc').AsString:= cxTextEditBELONG_MSC.Text;
    ClientDataSet1.FieldByName('belong_bsc').AsString:= cxTextEditBELONG_BSC.Text;
    ClientDataSet1.FieldByName('belong_cell').AsString:= cxTextEditBELONG_CELL.Text;
    ClientDataSet1.FieldByName('belong_bts').AsString:= cxTextEditBELONG_BTS.Text;
    ClientDataSet1.FieldByName('pncode').AsString:= cxTextEditPN.Text;
    ClientDataSet1.FieldByName('devicetypename').AsString:= cxComboBoxDeviceType.Text;
    ClientDataSet1.FieldByName('factorytypename').AsString:= cxComboBoxFactory.Text;
    ClientDataSet1.FieldByName('powertypename').AsString:= cxComboBoxPower.Text;
    ClientDataSet1.FieldByName('address').AsString:= cxTextEditADDRESS.Text;
    ClientDataSet1.FieldByName('cover').AsString:= cxTextEditCOVER.Text;
    ClientDataSet1.FieldByName('isprogramname').AsString:= cxComboBoxIsProgram.Text;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;
    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end
  else
    application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK );
end;

procedure TFormCDMASource.cxButtonClearClick(Sender: TObject);
begin
  cxTextEditCDMANO.Text:= '';
  cxTextEditCDMANAME.Text:= '';
  cxTextEditLONGITUDE.Text:= '';
  cxTextEditLATITUDE.Text:= '';
  cxTextEditBELONG_MSC.Text:= '';
  cxTextEditBELONG_BSC.Text:= '';
  cxTextEditBELONG_CELL.Text:= '';
  cxTextEditBELONG_BTS.Text:= '';
  cxTextEditADDRESS.Text:= '';
  cxTextEditCOVER.Text:= '';
  cxTextEditPN.Text:= '';

  cxComboBoxSuburb.ItemIndex:= -1;
  cxComboBoxBuilding.ItemIndex:= -1;
  cxComboBoxIsProgram.ItemIndex:= -1;
  cxComboBoxDeviceType.ItemIndex:= -1;
  cxComboBoxFactory.ItemIndex:= -1;
  cxComboBoxCDMAType.ItemIndex:= -1;
  cxComboBoxPower.ItemIndex:= -1;
end;

procedure TFormCDMASource.cxButtonCloseClick(Sender: TObject);
begin
  close;
end;

procedure TFormCDMASource.cxButtonDelClick(Sender: TObject);
var
  lSqlstr: string;
  lCDMAid: integer;
  lVariant: variant;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  if Application.MessageBox('ȷ��Ҫɾ��������¼��','��ʾ',MB_OKCANCEL+MB_ICONINFORMATION)=IDCANCEL then
    exit;

  lCDMAid:= ClientDataSet1.FieldByName('cdmaid').AsInteger;
  FListLink:= TStringList.Create;
  GetResInfo(FListLink,' suburbid, suburbname, buildingid, buildingname, 0 longitude, 0 latitude ','cdmaId','linkno','linkmachine_info_view',' and cdmaid='+inttostr(lCDMAid));
  if IsExistRelated(lCDMAid,FListLink,'��CDMA�ѱ�����������������'+#13+'%sɾ��CDMAǰ����ɾ����������������') then Exit;


  lSqlstr:= 'delete from cdma_info where cdmaid='+inttostr(lCDMAid);
  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('ɾ���ɹ���','��ʾ',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.Delete;
    FIsSysHandle:= false;
  end else
    Application.MessageBox('ɾ��ʧ�ܣ�','��ʾ',MB_OK	);
end;

procedure TFormCDMASource.cxButtonModifyClick(Sender: TObject);
var
  lSqlstr: string;
  lCDMAid: integer;
  lVariant: variant;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  lCDMAid:= ClientDataSet1.FieldByName('cdmaid').AsInteger;

  if trim(cxTextEditCDMANO.Text)='' then
  begin
    application.MessageBox('��Դ��Ų���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if trim(cxTextEditCDMANAME.Text)='' then
  begin
    application.MessageBox('��Դ���Ʋ���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if cxComboBoxCDMAType.ItemIndex=-1 then
  begin
    application.MessageBox('��Դ���Ͳ���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if cxComboBoxIsProgram.ItemIndex=-1 then
  begin
    application.MessageBox('�Ƿ��ҷֲ���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if trim(cxTextEditADDRESS.Text)='' then
  begin
    application.MessageBox('��װλ�ò���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if trim(cxTextEditCOVER.Text)='' then
  begin
    application.MessageBox('���Ƿ�Χ����Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;

  if cxComboBoxSuburb.ItemIndex=-1 then
  begin
    application.MessageBox('�����־ֲ���Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if cxComboBoxIsProgram.Text='����' then    //���� ����
  begin
    if cxComboBoxBuilding.ItemIndex=-1 then
    begin
      application.MessageBox('������Դ���ҷֵ���Ϣ����Ϊ�գ�', '��ʾ', mb_ok);
      exit;
    end;
  end else
  begin
    if cxComboBoxBuilding.ItemIndex<>-1 then
    begin
      application.MessageBox('������Դ���ҷֵ���Ϣ����Ϊ�գ�', '��ʾ', mb_ok);
      exit;
    end;
  end;

  if IsExists('CDMA_INFO','CDMANO',cxTextEditCDMANO.Text,'CDMAID',lCDMAid) then
  begin
    application.MessageBox('��Դ��Ų����ظ���', '��ʾ', mb_ok);
    exit;
  end;
  if IsExists('CDMA_INFO','CDMANAME',cxTextEditCDMANAME.Text,'CDMAID',lCDMAid) then
  begin
    application.MessageBox('��Դ���Ʋ����ظ���', '��ʾ', mb_ok);
    exit;
  end;

  lSqlstr:= 'update cdma_info set '+
            'buildingid ='+inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+','+
            'cdmano = '''+cxTextEditCDMANO.Text+''','+
            'cdmaname = '''+cxTextEditCDMANAME.Text+''','+
            'cdmatype = '+inttostr(cxComboBoxCDMAType.ItemIndex+1)+','+
            'belong_bts = '''+cxTextEditBELONG_BTS.Text+''','+
            'belong_msc = '''+cxTextEditBELONG_MSC.Text+''','+
            'belong_bsc = '''+cxTextEditBELONG_BSC.Text+''','+
            'belong_cell = '''+cxTextEditBELONG_CELL.Text+''','+
            'pncode = '''+cxTextEditPN.Text+''','+
            'devicetype = '+inttostr(GetDicCode(cxComboBoxDeviceType.Text,cxComboBoxDeviceType.Properties.Items))+','+
            'factory = '+inttostr(GetDicCode(cxComboBoxFactory.Text,cxComboBoxFactory.Properties.Items))+','+
            'power = '+inttostr(GetDicCode(cxComboBoxPower.Text,cxComboBoxPower.Properties.Items))+','+
            'address = '''+cxTextEditADDRESS.Text+''','+
            'cover = '''+cxTextEditCOVER.Text+''','+
            'longitude = '''+cxTextEditLONGITUDE.Text+''','+
            'latitude = '''+cxTextEditLATITUDE.Text+''','+
            'suburb = '+inttostr(GetCaptionid(cxComboBoxSuburb.Text,cxComboBoxSuburb.Properties.Items))+','+
            'isprogram = '+inttostr(self.cxComboBoxIsProgram.ItemIndex)+
            ' where cdmaid='+inttostr(lCDMAid);

  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('�޸ĳɹ���','��ʾ',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.edit;
    ClientDataSet1.FieldByName('cdmaid').AsString:= inttostr(lCDMAid);
    ClientDataSet1.FieldByName('cdmano').AsString:= cxTextEditCDMANO.Text;
    ClientDataSet1.FieldByName('cdmaname').AsString:= cxTextEditCDMANAME.Text;
    ClientDataSet1.FieldByName('cdmatypename').AsString:= cxComboBoxCDMAType.Text;
    ClientDataSet1.FieldByName('longitude').AsString:= cxTextEditLONGITUDE.Text;
    ClientDataSet1.FieldByName('latitude').AsString:= cxTextEditLATITUDE.Text;
    ClientDataSet1.FieldByName('belong_msc').AsString:= cxTextEditBELONG_MSC.Text;
    ClientDataSet1.FieldByName('belong_bsc').AsString:= cxTextEditBELONG_BSC.Text;
    ClientDataSet1.FieldByName('belong_cell').AsString:= cxTextEditBELONG_CELL.Text;
    ClientDataSet1.FieldByName('belong_bts').AsString:= cxTextEditBELONG_BTS.Text;
    ClientDataSet1.FieldByName('pncode').AsString:= cxTextEditPN.Text;
    ClientDataSet1.FieldByName('devicetypename').AsString:= cxComboBoxDeviceType.Text;
    ClientDataSet1.FieldByName('factorytypename').AsString:= cxComboBoxFactory.Text;
    ClientDataSet1.FieldByName('powertypename').AsString:= cxComboBoxPower.Text;
    ClientDataSet1.FieldByName('address').AsString:= cxTextEditADDRESS.Text;
    ClientDataSet1.FieldByName('cover').AsString:= cxTextEditCOVER.Text;
    ClientDataSet1.FieldByName('isprogramname').AsString:= cxComboBoxIsProgram.Text;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;
    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end
  else
    application.MessageBox('�޸�ʧ�ܣ�','��ʾ',MB_OK );
end;

procedure TFormCDMASource.cxComboBoxBuildingPropertiesChange(Sender: TObject);
var
  lBuildingid: integer;
  lSuburbid: integer;
  I: Integer;
begin
  if FConstruncting then exit;
  //��ʼ����
  FConstruncting:= true;
  //��ԭ�־�Ϊδѡ
  cxComboBoxSuburb.ItemIndex:= -1;

  lBuildingid:= GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items);
  if lBuildingid>-1 then
  begin
    //�����ҷֵ�ѡ��־�
    lSuburbid:= TFilterObject(cxComboBoxBuilding.Properties.Items.Objects[cxComboBoxBuilding.ItemIndex]).Suburbid;
    for I := 0 to cxComboBoxSuburb.Properties.Items.Count - 1 do
    begin
      if TFilterObject(cxComboBoxSuburb.Properties.Items.Objects[i]).Suburbid=lSuburbid  then
      begin
        cxComboBoxSuburb.ItemIndex:= i;
        break;
      end;
    end;
    //�����ҷֵ���¾�γ��
    cxTextEditLONGITUDE.Text:= TFilterObject(cxComboBoxBuilding.Properties.Items.Objects[cxComboBoxBuilding.ItemIndex]).Longitude;
    cxTextEditLATITUDE.Text:= TFilterObject(cxComboBoxBuilding.Properties.Items.Objects[cxComboBoxBuilding.ItemIndex]).Latitude;
  end;
  //��������
  FConstruncting:= false;
end;

procedure TFormCDMASource.cxComboBoxIsProgramPropertiesChange(Sender: TObject);
begin
  if cxComboBoxIsProgram.ItemIndex=1 then
  begin
    cxComboBoxBuilding.Enabled:= true;
  end else
  begin
    cxComboBoxBuilding.Enabled:= false;
    cxComboBoxBuilding.ItemIndex:= -1;
  end;
end;

procedure TFormCDMASource.cxComboBoxSuburbPropertiesChange(Sender: TObject);
var
  lSuburbid: integer;
begin
  if FConstruncting then exit;
  //��ʼ����
  FConstruncting:= true;

  //��ԭ�ҷֵ�Ϊδѡ
  cxComboBoxBuilding.ItemIndex:= -1;

  lSuburbid:= GetCaptionid(cxComboBoxSuburb.Text,cxComboBoxSuburb.Properties.Items);
  //�����ҷֵ�
  if lSuburbid>-1 then
  begin
    FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,MTS_SUBURB,lSuburbid);
  end else
  begin
    FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);
  end;
  //��������
  FConstruncting:= false;
end;

procedure TFormCDMASource.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if FIsSysHandle then exit;

//  ClientDataSet1.FieldByName('cdmaid').AsString:= inttostr(lCDMAid);
    cxTextEditCDMANO.Text:= ClientDataSet1.FieldByName('cdmano').AsString;
    cxTextEditCDMANAME.Text:= ClientDataSet1.FieldByName('cdmaname').AsString;
    cxComboBoxCDMAType.ItemIndex:= cxComboBoxCDMAType.Properties.Items.IndexOf(ClientDataSet1.FieldByName('cdmatypename').AsString);
    cxTextEditLONGITUDE.Text:= ClientDataSet1.FieldByName('longitude').AsString;
    cxTextEditLATITUDE.Text:= ClientDataSet1.FieldByName('latitude').AsString;
    cxTextEditBELONG_MSC.Text:= ClientDataSet1.FieldByName('belong_msc').AsString;
    cxTextEditBELONG_BSC.Text:= ClientDataSet1.FieldByName('belong_bsc').AsString;
    cxTextEditBELONG_CELL.Text:= ClientDataSet1.FieldByName('belong_cell').AsString;
    cxTextEditBELONG_BTS.Text:= ClientDataSet1.FieldByName('belong_bts').AsString;
    cxTextEditPN.Text:= ClientDataSet1.FieldByName('pncode').AsString;
    cxComboBoxDeviceType.ItemIndex:= cxComboBoxDeviceType.Properties.Items.IndexOf(ClientDataSet1.FieldByName('devicetypename').AsString);
    cxComboBoxFactory.ItemIndex:= cxComboBoxFactory.Properties.Items.IndexOf(ClientDataSet1.FieldByName('factorytypename').AsString);
    cxComboBoxPower.ItemIndex:= cxComboBoxPower.Properties.Items.IndexOf(ClientDataSet1.FieldByName('powertypename').AsString);
    cxTextEditADDRESS.Text:= ClientDataSet1.FieldByName('address').AsString;
    cxTextEditCOVER.Text:= ClientDataSet1.FieldByName('cover').AsString;
    cxComboBoxIsProgram.ItemIndex:= cxComboBoxIsProgram.Properties.Items.IndexOf(ClientDataSet1.FieldByName('isprogramname').AsString);
    cxComboBoxSuburb.ItemIndex:= cxComboBoxSuburb.Properties.Items.IndexOf(ClientDataSet1.FieldByName('suburbname').AsString);
    cxComboBoxBuilding.ItemIndex:= cxComboBoxBuilding.Properties.Items.IndexOf(ClientDataSet1.FieldByName('buildingname').AsString);
//    cxComboBoxSuburb.Text:= ClientDataSet1.FieldByName('suburbname').AsString;
//    cxComboBoxBuilding.Text:= ClientDataSet1.FieldByName('buildingname').AsString;
end;

procedure TFormCDMASource.cxTextEditLONGITUDEExit(Sender: TObject);
var
  lValue: string;
begin
  lValue:= TcxTextEdit(Sender).Text;
  if lValue='' then exit;
  try
    strtofloat(lValue);
  except
    application.MessageBox('��������Ч���֣�','��ʾ',MB_OK );
    TcxTextEdit(Sender).Text:= '';
  end;
end;

procedure TFormCDMASource.cxTextEditLONGITUDEKeyPress(Sender: TObject;
  var Key: Char);
begin
  InPutfloat(Key);
end;

procedure TFormCDMASource.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCxGridHelper.Free;
  ClearTStrings(FListSuburb);
  ClearTStrings(FListBuilding);
  ClearTStrings(cxComboBoxSuburb.Properties.Items);
  ClearTStrings(cxComboBoxBuilding.Properties.Items);

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormCDMASource:=nil;
end;

procedure TFormCDMASource.FormCreate(Sender: TObject);
begin
  ClientDataSet1.RemoteServer:= Dm_MTS.SocketConnection1;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);

  FListSuburb:= TStringList.Create;
  FListBuilding:= TStringList.Create;
end;

procedure TFormCDMASource.FormShow(Sender: TObject);
begin
  GetDic(17,cxComboBoxPower.Properties.Items);       //C����Դ����
  GetDic(16,cxComboBoxFactory.Properties.Items);     //C����Դ����
  GetDic(15,cxComboBoxDeviceType.Properties.Items);  //��Դ�豸�ͺ�

  GetSuburbInfo(FListSuburb);
  GetBuildingInfo(FListBuilding);

  FilterList(FListSuburb,cxComboBoxSuburb.Properties.Items,-1,-1);
  FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);

  AddViewField_CDMA;
  ShowDevice_CDMA;
end;

procedure TFormCDMASource.ShowDevice_CDMA;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,11,Fm_MainForm.PublicParam.PriveAreaidStrs,gCondition]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

end.
