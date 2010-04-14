unit UnitCSInfoMag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, DBClient, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, StdCtrls, cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  ExtCtrls, cxLookAndFeelPainters, Menus, cxButtons, cxHeader, cxLabel,
  cxGroupBox, CxGridUnit, StringUtils;

type
  TFormCSInfoMag = class(TForm)
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    cxGroupBox1: TcxGroupBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
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
    cxComboBoxCSType: TcxComboBox;
    cxTextEditSurvery: TcxTextEdit;
    cxTextEditCSID: TcxTextEdit;
    cxTextEditNet: TcxTextEdit;
    cxTextEditCover: TcxTextEdit;
    cxGroupBox2: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxTextEditAddress: TcxTextEdit;
    cxLabel4: TcxLabel;
    cxComboBoxSuburb: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure cxButtonAddClick(Sender: TObject);
    procedure cxButtonClearClick(Sender: TObject);
    procedure cxButtonCloseClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxComboBoxSuburbPropertiesChange(Sender: TObject);
    procedure cxComboBoxBuildingPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FCxGridHelper : TCxGridSet;
    FListSuburb,FListBuilding,FListLink: TStringList;
    FIsSysHandle: boolean;
    FConstruncting: boolean;
    procedure AddViewField_CS;
    procedure ClearText;
  public
    { Public declarations }
    gCondition: string;
    procedure ShowDevice_CS;
  end;

var
  FormCSInfoMag: TFormCSInfoMag;
  OperateFlag:integer;

implementation

uses Ut_DataModule, Ut_Common, Ut_MainForm;

{$R *.dfm}


procedure TFormCSInfoMag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCxGridHelper.Free;
  ClearTStrings(FListSuburb);
  ClearTStrings(FListBuilding);
  ClearTStrings(cxComboBoxCSType.Properties.Items);
  ClearTStrings(cxComboBoxBuilding.Properties.Items);

  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormCSInfoMag:=nil;
end;

procedure TFormCSInfoMag.FormCreate(Sender: TObject);
begin
  ClientDataSet1.RemoteServer:= Dm_MTS.SocketConnection1;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);

  FListSuburb:= TStringList.Create;
  FListBuilding:= TStringList.Create;
end;

procedure TFormCSInfoMag.FormShow(Sender: TObject);
begin
  GetDic(20,cxComboBoxCSType.Properties.Items); //��վ����
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,cxComboBoxBuilding.Properties.Items);
  cxComboBoxCSType.ItemIndex := -1;
  cxComboBoxBuilding.ItemIndex := -1;

  GetSuburbInfo(FListSuburb);
  GetBuildingInfo(FListBuilding);
  FilterList(FListSuburb,cxComboBoxSuburb.Properties.Items,-1,-1);
  FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);

  AddViewField_CS;
  ShowDevice_CS;
end;



procedure TFormCSInfoMag.AddViewField_CS;
begin
  AddViewField(cxGrid1DBTableView1,'CSID','�ڲ����');
  AddViewField(cxGrid1DBTableView1,'SURVERY_ID','������');
  AddViewField(cxGrid1DBTableView1,'CS_ID','CS_ID');
  AddViewField(cxGrid1DBTableView1,'CS_TYPENAME','��վ����'); 
  AddViewField(cxGrid1DBTableView1,'CSADDR','��վ��ַ');
  AddViewField(cxGrid1DBTableView1,'NETADDRESS','��Ԫ��Ϣ');
  AddViewField(cxGrid1DBTableView1,'CS_COVER','���Ƿ�Χ');
  AddViewField(cxGrid1DBTableView1,'suburbname','�����־�'); 
  AddViewField(cxGrid1DBTableView1,'BUILDINGNAME','�����ҷֵ�');
end;

procedure TFormCSInfoMag.ShowDevice_CS;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,41,Fm_MainForm.PublicParam.PriveAreaidStrs,gCondition]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormCSInfoMag.ClearText;
var
  i : integer;
begin
  for I := 0 to cxGroupBox1.ControlCount - 1 do
  begin
    if (cxGroupBox1.Controls[i] is TEdit) then
      (cxGroupBox1.Controls[i] as TEdit).Text :=''
    else if(cxGroupBox1.Controls[i] is TComboBox)then
      (cxGroupBox1.Controls[i] as TComboBox).ItemIndex :=-1;
  end;
end;

procedure TFormCSInfoMag.cxButtonAddClick(Sender: TObject);
var
  lSqlstr: string;
  lCSID: integer;
  lVariant: variant;
  lsuccess: boolean;
begin
  if trim(cxTextEditSurvery.Text)='' then
  begin
    application.MessageBox('������벻��Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if cxComboBoxBuilding.ItemIndex=-1 then
  begin
    application.MessageBox('�����ҷֵ㲻��Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if trim(cxTextEditNet.Text)='' then
  begin
    application.MessageBox('��Ԫ��Ϣ����Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;

  lCSID:= DM_MTS.TempInterface.GetTheSequenceId('mtu_deviceid');
  if IsExists('CS_INFO','SURVERY_ID',cxTextEditSurvery.Text,'CSID',lCSID) then
  begin
    application.MessageBox('������벻���ظ���', '��ʾ', mb_ok);
    exit;
  end;

  lSqlstr:= 'insert into cs_info'+
            ' (CSID,CS_ID,CS_TYPE,CS_COVER,SURVERY_ID,NETADDRESS,BUILDINGID,CSADDR) '+
            ' values'+
            ' ('+inttostr(lCSID)+','''+
             cxTextEditCSID.Text+''','+
             inttostr(GetDicCode(cxComboBoxCSType.Text,cxComboBoxCSType.Properties.Items))+','''+
             cxTextEditCover.Text +''','''+
             cxTextEditSurvery.Text +''','''+
             cxTextEditNet.Text +''','+
             inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+','''+
             cxTextEditAddress.Text+
             ''')';
  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('�����ɹ���','��ʾ',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.append;

    ClientDataSet1.FieldByName('CSID').AsString:= inttostr(lCSID);
    ClientDataSet1.FieldByName('CS_ID').AsString:= cxTextEditCSID.Text;
    ClientDataSet1.FieldByName('CS_TYPENAME').AsString:= cxComboBoxCSType.Text;
    ClientDataSet1.FieldByName('CS_COVER').AsString:= cxTextEditCover.Text;
    ClientDataSet1.FieldByName('SURVERY_ID').AsString:= cxTextEditSurvery.Text;
    ClientDataSet1.FieldByName('NETADDRESS').AsString:= cxTextEditNet.Text;
    ClientDataSet1.FieldByName('BUILDINGNAME').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('CSADDR').AsString:= cxTextEditAddress.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;
    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end
  else
    application.MessageBox('����ʧ�ܣ�','��ʾ',MB_OK );
end;

procedure TFormCSInfoMag.cxButtonClearClick(Sender: TObject);
begin
  cxTextEditSurvery.Text:= '';
  cxComboBoxBuilding.ItemIndex:= -1;
  cxTextEditNet.Text:= '';
  cxTextEditCSID.Text:= '';
  cxTextEditAddress.Text:= '';
  cxTextEditCover.Text:= '';
  cxComboBoxCSType.ItemIndex:= -1;
end;

procedure TFormCSInfoMag.cxButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCSInfoMag.cxButtonDelClick(Sender: TObject);
var
  lSqlstr: string;
  lCSID: integer;
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

  lCSID:= ClientDataSet1.FieldByName('csid').AsInteger;
  FListLink:= TStringList.Create;
  GetResInfo(FListLink,' suburbid, suburbname, buildingid, buildingname, 0 longitude, 0 latitude ','csId','linkno','linkmachine_info_view',' and csid='+inttostr(lCSID));
  if IsExistRelated(lCSID,FListLink,'��CS�ѱ�����������������'+#13+'%sɾ��CSǰ����ɾ����������������') then Exit;

  lSqlstr:= 'delete from cs_info where csid='+inttostr(lCSID);
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

procedure TFormCSInfoMag.cxButtonModifyClick(Sender: TObject);
var
  lSqlstr: string;
  lCSID: integer;
  lVariant: variant;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('��ѡ��һ����¼��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  lCSID:= ClientDataSet1.FieldByName('CSID').AsInteger;

  if trim(cxTextEditSurvery.Text)='' then
  begin
    application.MessageBox('������벻��Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if cxComboBoxBuilding.ItemIndex=-1 then
  begin
    application.MessageBox('�����ҷֵ㲻��Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;
  if trim(cxTextEditNet.Text)='' then
  begin
    application.MessageBox('��Ԫ��Ϣ����Ϊ�գ�', '��ʾ', mb_ok);
    exit;
  end;


  lSqlstr:= 'update cs_info set '+
            'CS_ID = '''+cxTextEditCSID.Text +''','+
            'BUILDINGID ='+inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+','+
            'CS_TYPE = '+inttostr(GetDicCode(cxComboBoxCSType.Text,cxComboBoxCSType.Properties.Items))+','+
            'CS_COVER = '''+cxTextEditCover.Text+''','+
            'SURVERY_ID = '''+cxTextEditSurvery.Text+''','+
            'NETADDRESS = '''+cxTextEditNet.Text+''','+
            'CSADDR = '''+cxTextEditAddress.Text+''''+
            ' where csid= '+inttostr(lCSID);
  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('�޸ĳɹ���','��ʾ',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.edit;
    ClientDataSet1.FieldByName('CS_ID').AsString:= cxTextEditCSID.Text;
    ClientDataSet1.FieldByName('CS_TYPENAME').AsString:= cxComboBoxCSType.Text;
    ClientDataSet1.FieldByName('CS_COVER').AsString:= cxTextEditCover.Text;
    ClientDataSet1.FieldByName('SURVERY_ID').AsString:= cxTextEditSurvery.Text;
    ClientDataSet1.FieldByName('NETADDRESS').AsString:= cxTextEditNet.Text;
    ClientDataSet1.FieldByName('BUILDINGNAME').AsString:= cxComboBoxBuilding.Text;
    ClientDataSet1.FieldByName('CSADDR').AsString:= cxTextEditAddress.Text;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;
    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end
  else
    application.MessageBox('�޸�ʧ�ܣ�','��ʾ',MB_OK );
end;

procedure TFormCSInfoMag.cxComboBoxBuildingPropertiesChange(Sender: TObject);
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
  end;
  //��������
  FConstruncting:= false;
end;

procedure TFormCSInfoMag.cxComboBoxSuburbPropertiesChange(Sender: TObject);
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

procedure TFormCSInfoMag.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if FIsSysHandle then exit;
  cxTextEditSurvery.Text := ClientDataSet1.FieldByName('SURVERY_ID').AsString;
  cxComboBoxBuilding.ItemIndex:= cxComboBoxBuilding.Properties.Items.IndexOf(ClientDataSet1.FieldByName('buildingname').AsString);
  cxTextEditNet.Text := ClientDataSet1.FieldByName('NETADDRESS').AsString;
  cxTextEditCSID.Text := ClientDataSet1.FieldByName('CS_ID').AsString;
  cxTextEditAddress.Text := ClientDataSet1.FieldByName('CSADDR').AsString;
  cxTextEditCover.Text := ClientDataSet1.FieldByName('CS_COVER').AsString;
  cxComboBoxCSType.ItemIndex := cxComboBoxCSType.Properties.Items.IndexOf(ClientDataSet1.FieldByName('cs_typename').AsString);
  cxComboBoxSuburb.ItemIndex:= cxComboBoxSuburb.Properties.Items.IndexOf(ClientDataSet1.FieldByName('suburbname').AsString);
end;

end.
