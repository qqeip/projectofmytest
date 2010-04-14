unit UnitLinkMachineInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, Menus, DBClient, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, StdCtrls, cxButtons, cxHeader, cxLabel,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxContainer, cxGroupBox, Ut_DataModule,
  CxGridUnit, StringUtils;

type
  TFormLinkMachineInfo = class(TForm)
    cxGroupBox2: TcxGroupBox;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
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
    cxComboBoxLINKCS: TcxComboBox;
    cxComboBoxBuilding: TcxComboBox;
    cxComboBoxLinkCDMA: TcxComboBox;
    cxComboBoxLINKTYPE: TcxComboBox;
    cxEditLINKNO: TcxTextEdit;
    cxEditLINKADDR: TcxTextEdit;
    cxEditTRUNKADDR: TcxTextEdit;
    cxComboBoxLINKAP: TcxComboBox;
    cxComboBoxLINKEQUIPMENT: TcxComboBox;
    cxComboBoxISTRUNK: TcxComboBox;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    cxComboBoxSuburb: TcxComboBox;
    cxLabel7: TcxLabel;
    procedure cxButtonCloseClick(Sender: TObject);
    procedure cxButtonClearClick(Sender: TObject);
    procedure cxButtonDelClick(Sender: TObject);
    procedure cxButtonModifyClick(Sender: TObject);
    procedure cxButtonAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxComboBoxBuildingPropertiesChange(Sender: TObject);
    procedure cxComboBoxISTRUNKPropertiesChange(Sender: TObject);
    procedure cxGrid1DBTableView1FocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cxComboBoxSuburbPropertiesChange(Sender: TObject);
    procedure cxComboBoxLINKEQUIPMENTPropertiesChange(Sender: TObject);
  private
    FCxGridHelper : TCxGridSet;
    FListSuburb,FListBuilding,FListAP,FListCDMA,FListCS,FListMTU: TStringList;
    FConstruncting: boolean;
    FIsSysHandle: boolean;
    procedure ClearInfo;
    procedure AddViewField_LM;
    procedure SetEnableByCSAP;
    procedure DestroyOBJ(Box:TcxComboBox);
    { Private declarations }
  public
    gCondition: string;
    procedure ShowDevice_LM;
    { Public declarations }
  end;

var
  FormLinkMachineInfo: TFormLinkMachineInfo;

implementation

uses Ut_Common, Ut_MainForm;

{$R *.dfm}

procedure TFormLinkMachineInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FCxGridHelper.Free;
  ClearTStrings(FListAP);
  ClearTStrings(FListCDMA);
  ClearTStrings(FListCS);
  ClearTStrings(cxComboBoxBuilding.Properties.Items);
  ClearTStrings(cxComboBoxLINKEQUIPMENT.Properties.Items);
  ClearTStrings(cxComboBoxLINKTYPE.Properties.Items);
  ClearTStrings(cxComboBoxLINKCS.Properties.Items);
  ClearTStrings(cxComboBoxISTRUNK.Properties.Items);
  ClearTStrings(cxComboBoxLINKAP.Properties.Items);
  ClearTStrings(cxComboBoxLinkCDMA.Properties.Items);
  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  FormLinkMachineInfo:=nil;
end;

procedure TFormLinkMachineInfo.FormCreate(Sender: TObject);
begin
  ClientDataSet1.RemoteServer:= Dm_MTS.SocketConnection1;

  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);
  
  FListSuburb:= TStringList.Create;
  FListBuilding:= TStringList.Create;
  FListAP:= TStringList.Create;
  FListCDMA:= TStringList.Create;
  FListCS:= TStringList.Create;
end;

procedure TFormLinkMachineInfo.FormShow(Sender: TObject);
begin
  GetDic(13,cxComboBoxLINKTYPE.Properties.Items);   //连接器类型
  cxComboBoxLINKTYPE.ItemIndex:=-1;
  LoadBuilding(Fm_MainForm.PublicParam.cityid,Fm_MainForm.PublicParam.areaid,cxComboBoxBuilding.Properties.Items);
  cxComboBoxBuilding.ItemIndex := -1;

  GetSuburbInfo(FListSuburb);
  GetBuildingInfo(FListBuilding);
  GetAPInfo(FListAP);
  GetCSInfo(FListCS);
  GetCNETInfo(FListCDMA);
  FilterList(FListSuburb,cxComboBoxSuburb.Properties.Items,-1,-1);
  FilterList(FListBuilding,cxComboBoxBuilding.Properties.Items,-1,-1);
  FilterList(FListAP,cxComboBoxLINKAP.Properties.Items,-1,-1);
  FilterList(FListCS,cxComboBoxLINKCS.Properties.Items,-1,-1);
  FilterList(FListCDMA,cxComboBoxLinkCDMA.Properties.Items,-1,-1);

  AddViewField_LM;
  ShowDevice_LM;
end;

procedure TFormLinkMachineInfo.AddViewField_LM;
begin
  AddViewField(cxGrid1DBTableView1,'linkid','内部编号');
  AddViewField(cxGrid1DBTableView1,'linkno','连接器编号');
  AddViewField(cxGrid1DBTableView1,'linktype','连接器类型');
  AddViewField(cxGrid1DBTableView1,'linkaddr','连接器位置');
  AddViewField(cxGrid1DBTableView1,'linkequipment','连接设备类型');
  AddViewField(cxGrid1DBTableView1,'linkcs','连接基站');
  AddViewField(cxGrid1DBTableView1,'linkap','连接AP');
  AddViewField(cxGrid1DBTableView1,'linkcdma','连接CDMA');
  AddViewField(cxGrid1DBTableView1,'suburbname','所属分局');
  AddViewField(cxGrid1DBTableView1,'BUILDINGNAME','所属室分点');
  AddViewField(cxGrid1DBTableView1,'ISTRUNK','是否干放');
  AddViewField(cxGrid1DBTableView1,'trunkaddr','干放位置');

end;

procedure TFormLinkMachineInfo.ShowDevice_LM;
begin
  DataSource1.DataSet:= nil;
  with ClientDataSet1 do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,42,Fm_MainForm.PublicParam.PriveAreaidStrs,gCondition]),0);
  end;
  DataSource1.DataSet:= ClientDataSet1;
  cxGrid1DBTableView1.ApplyBestFit();
end;

procedure TFormLinkMachineInfo.SetEnableByCSAP;
begin
  if cxComboBoxLINKEQUIPMENT.ItemIndex=-1 then
  begin
    cxComboBoxLINKCS.ItemIndex:=-1;
    cxComboBoxLINKAP.ItemIndex:=-1;
    cxComboBoxLinkCDMA.ItemIndex := -1;
    cxComboBoxLINKCS.Enabled:=false;
    cxComboBoxLINKAP.Enabled:=false;
    cxComboBoxLinkCDMA.Enabled := False;
  end
  else if cxComboBoxLINKEQUIPMENT.ItemIndex=0 then  //PHS
  begin
    cxComboBoxLINKAP.ItemIndex:=-1;
    cxComboBoxLinkCDMA.ItemIndex := -1;
    cxComboBoxLINKCS.Enabled:=true;
    cxComboBoxLINKAP.Enabled:=false;
    cxComboBoxLinkCDMA.Enabled := False;
  end
  else if cxComboBoxLINKEQUIPMENT.ItemIndex=1 then  //WLAN
  begin
    cxComboBoxLINKCS.ItemIndex:=-1;
    cxComboBoxLinkCDMA.ItemIndex := -1;
    cxComboBoxLINKCS.Enabled:=false;
    cxComboBoxLinkCDMA.Enabled := false;
    cxComboBoxLINKAP.Enabled:=true;
  end
  else if  cxComboBoxLINKEQUIPMENT.ItemIndex=2 then  //CDMA
  begin
    cxComboBoxLINKCS.ItemIndex:=-1;
    cxComboBoxLINKAP.ItemIndex:=-1;
    cxComboBoxLINKCS.Enabled:=False;
    cxComboBoxLINKAP.Enabled:=False;
    cxComboBoxLinkCDMA.Enabled := True;
  end
  else if cxComboBoxLINKEQUIPMENT.ItemIndex=3 then    //PHS+WLAN
  begin
    cxComboBoxLINKCS.Enabled:=true;
    cxComboBoxLINKAP.Enabled:=true;
    cxComboBoxLinkCDMA.ItemIndex := -1;
    cxComboBoxLinkCDMA.Enabled := false;
  end
  else if cxComboBoxLINKEQUIPMENT.ItemIndex=4 then   //PHS+CDMA
  begin
    cxComboBoxLINKCS.Enabled:=true;
    cxComboBoxLINKAP.ItemIndex := -1;
    cxComboBoxLINKAP.Enabled:=false;
    cxComboBoxLinkCDMA.Enabled := True;
  end
  else if cxComboBoxLINKEQUIPMENT.ItemIndex=5 then   //WLAN+CDMA
  begin
    cxComboBoxLINKCS.ItemIndex := -1;
    cxComboBoxLINKCS.Enabled:=false;
    cxComboBoxLINKAP.Enabled:=True;
    cxComboBoxLinkCDMA.Enabled := True;
  end
  else if cxComboBoxLINKEQUIPMENT.ItemIndex=6 then   //PHS+WLAN+CDMA
  begin
    cxComboBoxLINKCS.Enabled:=True;
    cxComboBoxLINKAP.Enabled:=True;
    cxComboBoxLinkCDMA.Enabled := True;
  end;
end;

procedure TFormLinkMachineInfo.ClearInfo;
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

procedure TFormLinkMachineInfo.cxButtonClearClick(Sender: TObject);
begin
  ClearInfo;
end;

procedure TFormLinkMachineInfo.cxButtonCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormLinkMachineInfo.cxButtonDelClick(Sender: TObject);
var
  lSqlstr: string;
  lLinkid: integer;
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

  lLinkid:= ClientDataSet1.FieldByName('linkid').AsInteger;
  FListMTU:= TStringList.Create;
  GetResInfo(FListMTU,' suburbid, suburbname, buildingid, buildingname, 0 longitude, 0 latitude ','linkid','mtuname','mtu_info_view',' and linkid='+inttostr(lLinkid));
  if IsExistRelated(lLinkid,FListMTU,'此连接器已被如下MTU关联：'+#13+'%s删除连接器前请先删除关联的MTU！') then Exit;


  lSqlstr:= 'delete from linkmachine_info where linkid='+inttostr(lLinkid);
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

procedure TFormLinkMachineInfo.cxButtonModifyClick(Sender: TObject);
var
  lLinkid: integer;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  if not CheckRecordSelected(cxGrid1DBTableView1) then
  begin
    Application.MessageBox('请选择一条记录！','提示',MB_OK	+MB_ICONINFORMATION);
    Exit;
  end;
  lLinkid:= ClientDataSet1.FieldByName('LINKID').AsInteger;

  if trim(cxEditLINKNO.Text)='' then
  begin
    application.MessageBox('连接器编号不能为空！', '提示', mb_ok);
    exit;
  end;
if cxComboBoxBuilding.ItemIndex=-1 then
  begin
    application.MessageBox('所属室分点不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxLINKEQUIPMENT.ItemIndex=-1 then
  begin
    application.MessageBox('连接设备类型不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxLINKTYPE.ItemIndex=-1 then
  begin
    application.MessageBox('连接器类型不能为空！', '提示', mb_ok);
    exit;
  end;

  if cxComboBoxISTRUNK.ItemIndex=-1 then
  begin
    application.MessageBox('是否干放不能为空！', '提示', mb_ok);
    exit;
  end;

  if IsExists('linkmachine_info','linkno',cxEditLINKNO.Text,'LINKID',lLinkid) then
  begin
    application.MessageBox('连接器编号不能重复！', '提示', mb_ok);
    exit;
  end;

  lSqlstr:= 'update linkmachine_info '+
            'set LINKCDMA = '''+ inttostr(GetCaptionid(cxComboBoxLinkCDMA.Text,cxComboBoxLinkCDMA.Properties.Items))+''','+
            '    LINKNO = '''+ cxEditLINKNO.Text + ''','+
            '    LINKTYPE = '+ inttostr(GetDicCode(cxComboBoxLINKTYPE.Text,cxComboBoxLINKTYPE.Properties.Items))+','+
            '    BUILDINGID = '+inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+','+
            '    LINKADDR = '''+ cxEditLINKADDR.Text+''','+
            '    ISTRUNK =  '+ IntToStr(cxComboBoxISTRUNK.ItemIndex)+','+
            '    TRUNKADDR = '''+ cxEditTRUNKADDR.Text+''','+
            '    LINKEQUIPMENT = '+ IntToStr(cxComboBoxLINKEQUIPMENT.ItemIndex+1)+','+
            '    LINKCS = '+inttostr(GetCaptionid(cxComboBoxLINKCS.Text,cxComboBoxLINKCS.Properties.Items))+','+
            '    LINKAP = '+inttostr(GetCaptionid(cxComboBoxLINKAP.Text,cxComboBoxLINKAP.Properties.Items))+
            'where LinkID= '+ IntToStr(lLinkID);

  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('修改成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.edit;
    
    ClientDataSet1.FieldByName('LINKCDMA').AsString := cxComboBoxLinkCDMA.Text ;
    ClientDataSet1.FieldByName('LINKNO').AsString   := cxEditLINKNO.Text;
    ClientDataSet1.FieldByName('LINKTYPE').AsString := cxComboBoxLINKTYPE.Text ;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text ;
    ClientDataSet1.FieldByName('LINKADDR').AsString := cxEditLINKADDR.Text ;
    ClientDataSet1.FieldByName('ISTRUNK').AsString  := cxComboBoxISTRUNK.Text ;
    ClientDataSet1.FieldByName('TRUNKADDR').AsString:= cxEditTRUNKADDR.Text ;
    ClientDataSet1.FieldByName('LINKEQUIPMENT').AsString := cxComboBoxLINKEQUIPMENT.Text ;
    ClientDataSet1.FieldByName('LINKCS').AsString   := cxComboBoxLINKCS.Text;
    ClientDataSet1.FieldByName('LINKAP').AsString   := cxComboBoxLINKAP.Text ;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;

    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end else
    application.MessageBox('修改失败！','提示',MB_OK );
end;

procedure TFormLinkMachineInfo.cxComboBoxBuildingPropertiesChange(
  Sender: TObject);
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
  cxComboBoxLINKAP.ItemIndex:= -1;
  cxComboBoxLinkCDMA.ItemIndex:= -1;
  cxComboBoxLINKCS.ItemIndex:= -1;

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
    FilterList(FListAP,cxComboBoxLINKAP.Properties.Items,MTS_BUILDING,lBuildingid);
    //根据室分点更新PHS
    FilterList(FListCDMA,cxComboBoxLinkCDMA.Properties.Items,MTS_BUILDING,lBuildingid);
    //根据室分点更新CNET
    FilterList(FListCS,cxComboBoxLINKCS.Properties.Items,MTS_BUILDING,lBuildingid);
  end else
  begin
    FilterList(FListAP,cxComboBoxLINKAP.Properties.Items,-1,-1);
    FilterList(FListCDMA,cxComboBoxLinkCDMA.Properties.Items,-1,-1);
    FilterList(FListCS,cxComboBoxLINKCS.Properties.Items,-1,-1);
  end;
  //结束构造
  FConstruncting:= false;
end;

procedure TFormLinkMachineInfo.cxComboBoxLINKEQUIPMENTPropertiesChange(
  Sender: TObject);
  var
  lBuildingid : Integer;
begin
//  cxComboBoxLINKCS.ItemIndex:=-1;
//  cxComboBoxLINKAP.ItemIndex:=-1;
//  cxComboBoxLinkCDMA.ItemIndex := -1;
//  DestroyObj(cxComboBoxLINKCS);
//  DestroyObj(cxComboBoxLINKAP);
//  DestroyObj(cxComboBoxLinkCDMA);

  SetEnableByCSAP;
end;

procedure TFormLinkMachineInfo.cxComboBoxISTRUNKPropertiesChange(
  Sender: TObject);
begin
  cxEditTRUNKADDR.Text := '';
  if cxComboBoxISTRUNK.ItemIndex=1 then
    cxEditTRUNKADDR.Enabled:=true
  else
    cxEditTRUNKADDR.Enabled:=false;
end;

procedure TFormLinkMachineInfo.cxComboBoxSuburbPropertiesChange(
  Sender: TObject);
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

procedure TFormLinkMachineInfo.cxGrid1DBTableView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  if FIsSysHandle then exit;

  cxEditLINKNO.Text := ClientDataSet1.FieldByName('LINKNO').AsString;
  cxComboBoxLINKTYPE.ItemIndex:= cxComboBoxLINKTYPE.Properties.Items.IndexOf(ClientDataSet1.FieldByName('LINKTYPE').AsString);
  cxComboBoxBuilding.ItemIndex:= cxComboBoxBuilding.Properties.Items.IndexOf(ClientDataSet1.FieldByName('buildingname').AsString);
  cxEditLINKADDR.Text:= ClientDataSet1.FieldByName('LINKADDR').AsString;
  cxComboBoxISTRUNK.ItemIndex:= cxComboBoxISTRUNK.Properties.Items.IndexOf(ClientDataSet1.FieldByName('ISTRUNK').AsString);
  cxEditTRUNKADDR.Text:= ClientDataSet1.FieldByName('TRUNKADDR').AsString;
  cxComboBoxLINKEQUIPMENT.ItemIndex:= cxComboBoxLINKEQUIPMENT.Properties.Items.IndexOf(ClientDataSet1.FieldByName('LINKEQUIPMENT').AsString);
  cxComboBoxLINKCS.ItemIndex:= cxComboBoxLINKCS.Properties.Items.IndexOf(ClientDataSet1.FieldByName('LINKCS').AsString);
  cxComboBoxLINKAP.ItemIndex:= cxComboBoxLINKAP.Properties.Items.IndexOf(ClientDataSet1.FieldByName('LINKAP').AsString);
  cxComboBoxLinkCDMA.ItemIndex:= cxComboBoxLinkCDMA.Properties.Items.IndexOf(ClientDataSet1.FieldByName('LINKCDMA').AsString);
  cxComboBoxSuburb.ItemIndex:= cxComboBoxSuburb.Properties.Items.IndexOf(ClientDataSet1.FieldByName('suburbname').AsString);
end;

procedure TFormLinkMachineInfo.DestroyOBJ(Box: TcxComboBox);
var
  i : Integer;
begin
    for i:= 0 to Box.Properties.Items.Count -1 do
        TCommonObj(Box.Properties.Items.Objects[i]).Free;
    Box.Properties.Items.Clear;
end;

procedure TFormLinkMachineInfo.cxButtonAddClick(Sender: TObject);
var
  lLinkid: integer;
  lSqlstr: string;
  lVariant: variant;
  lsuccess: boolean;
begin
  if trim(cxEditLINKNO.Text)='' then
  begin
    application.MessageBox('连接器编号不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxBuilding.ItemIndex=-1 then
  begin
    application.MessageBox('所属室分点不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxLINKEQUIPMENT.ItemIndex=-1 then
  begin
    application.MessageBox('连接设备类型不能为空！', '提示', mb_ok);
    exit;
  end;
  if cxComboBoxLINKTYPE.ItemIndex=-1 then
  begin
    application.MessageBox('连接器类型不能为空！', '提示', mb_ok);
    exit;
  end;

  if cxComboBoxISTRUNK.ItemIndex=-1 then
  begin
    application.MessageBox('是否干放不能为空！', '提示', mb_ok);
    exit;
  end;

  lLinkid:=DM_MTS.TempInterface.GetTheSequenceId('mtu_deviceid');

  if IsExists('linkmachine_info','linkno',cxEditLINKNO.Text,'linkid',lLinkid) then
  begin
    application.MessageBox('连接器编号不能重复！', '提示', mb_ok);
    exit;
  end;

  lSqlstr:= 'insert into Linkmachine_Info'+
            '(LINKCDMA,LINKID,LINKNO,LINKTYPE,BUILDINGID,LINKADDR,ISTRUNK,TRUNKADDR,LINKEQUIPMENT,LINKCS,LINKAP)'+
            ' values( '+
             inttostr(GetCaptionid(cxComboBoxLinkCDMA.Text,cxComboBoxLinkCDMA.Properties.Items))+','+
             IntToStr(lLinkid) +','''+
             cxEditLINKNO.Text + ''','+
             inttostr(GetDicCode(cxComboBoxLINKTYPE.Text,cxComboBoxLINKTYPE.Properties.Items))+','+
             inttostr(GetCaptionid(cxComboBoxBuilding.Text,cxComboBoxBuilding.Properties.Items))+ ','''+
             cxEditLINKADDR.Text+''','+
             IntToStr(cxComboBoxISTRUNK.ItemIndex)+ ','''+
             cxEditTRUNKADDR.Text+''','+
             IntToStr(cxComboBoxLINKEQUIPMENT.ItemIndex+1)+','+
             inttostr(GetCaptionid(cxComboBoxLINKCS.Text,cxComboBoxLINKCS.Properties.Items))+','+
             inttostr(GetCaptionid(cxComboBoxLINKAP.Text,cxComboBoxLINKAP.Properties.Items))+
              ')';
  lVariant:= VarArrayCreate([0,0],varVariant);
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
  if lsuccess then
  begin
    Application.MessageBox('新增成功！','提示',MB_OK	);
    FIsSysHandle:= true;
    ClientDataSet1.append;

    ClientDataSet1.FieldByName('linkid').AsString := IntToStr(lLinkid) ;
    ClientDataSet1.FieldByName('LINKCDMA').AsString := cxComboBoxLinkCDMA.Text ;
    ClientDataSet1.FieldByName('LINKNO').AsString   := cxEditLINKNO.Text;
    ClientDataSet1.FieldByName('LINKTYPE').AsString := cxComboBoxLINKTYPE.Text ;
    ClientDataSet1.FieldByName('buildingname').AsString:= cxComboBoxBuilding.Text ;
    ClientDataSet1.FieldByName('LINKADDR').AsString := cxEditLINKADDR.Text ;
    ClientDataSet1.FieldByName('ISTRUNK').AsString  := cxComboBoxISTRUNK.Text ;
    ClientDataSet1.FieldByName('TRUNKADDR').AsString:= cxEditTRUNKADDR.Text ;
    ClientDataSet1.FieldByName('LINKEQUIPMENT').AsString:= cxComboBoxLINKEQUIPMENT.Text ;
    ClientDataSet1.FieldByName('LINKCS').AsString   := cxComboBoxLINKCS.Text;
    ClientDataSet1.FieldByName('LINKAP').AsString   := cxComboBoxLINKAP.Text ;
    ClientDataSet1.FieldByName('suburbname').AsString:= cxComboBoxSuburb.Text;

    ClientDataSet1.Post;
    FIsSysHandle:= false;
  end else
    application.MessageBox('新增失败！','提示',MB_OK );
end;

end.
