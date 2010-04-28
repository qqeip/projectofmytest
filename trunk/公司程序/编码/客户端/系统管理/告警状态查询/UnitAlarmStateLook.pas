unit UnitAlarmStateLook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StringUtils, IniFiles, Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, DBClient, CxGridUnit, UDevExpressToChinese,
  StdCtrls, jpeg, ExtCtrls, cxLookAndFeelPainters, ComCtrls, cxTextEdit,
  cxLabel, Buttons, cxTreeView, cxContainer, cxGroupBox, Menus, ImgList,
  cxButtons, ADODB, Mask;

type
  TNodeType = (PROVINCE,  //0  ʡ
               CITY,      //1  ����
               TOWN,      //2  ������ ��������
               SUBURB,    //3  �־�   �����־�
               Company,   //4  ά����λ
               Device      //5  �豸
               );
  TNodeParam = class(Tobject)
  public
    NodeType     :TNodeType;
    Cityid       :integer;    //���б��
    CompanyID    :integer;   //ά����λ���
    TownID       :integer;    //���������
    SuburbID     :integer;    //�־ֱ��
    DevID        :Integer;
    AlarmID      :integer; //�澯���
    ParentID     :integer;    // ���ڵ���
    HaveExpanded :boolean;  //�Ƿ��Ѿ�չ��
    DisplayName  :string;    //��ʾ���� ���� ȫ��
  end;

type
  TFormAlarmStateLook = class(TForm)
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    Panel2: TPanel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1DBTableView2: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGroupBox1: TcxGroupBox;
    cxButton1: TcxButton;
    imageList2: TImageList;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    CheckBox2: TCheckBox;
    Edit2: TEdit;
    Button1: TButton;
    ADOQuery1: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cxGrid1DBTableView1DataControllerDetailExpanding(
      ADataController: TcxCustomDataController; ARecordIndex: Integer;
      var AAllow: Boolean);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxButton1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
  private
    FCxGridHelper : TCxGridSet;
    MenuItem_Synchro : TMenuItem;
    //procedure ShowDevInfo(aCityID: Integer);

    procedure SynchroDevStateOnClickEvent(Sender: TObject);
    procedure OnGridPopup(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAlarmStateLook: TFormAlarmStateLook;
  gHashedAlarmListLocal:THashedStringList;

implementation

uses UnitDllCommon, UnitAlarmContentModule;

{$R *.dfm}

procedure TFormAlarmStateLook.FormCreate(Sender: TObject);
begin
  FCxGridHelper:=TCxGridSet.Create;
  FCxGridHelper.SetGridStyle(cxGrid1,true,false,true);
//  MenuItem_Synchro := FCxGridHelper.AppendMenuItem('��վ״̬ͬ��',SynchroDevStateOnClickEvent);
  gHashedAlarmListLocal:= THashedStringList.Create;
  TPopupMenu(cxGrid1.PopupMenu).OnPopup:= OnGridPopup;
end;

procedure TFormAlarmStateLook.FormShow(Sender: TObject);
begin
  AddCategory(cxGrid1DBTableView1,gPublicParam.cityid,gPublicParam.userid,25);  //����ֶ�
  //AddCategory(cxGrid1DBTableView2,gPublicParam.cityid,gPublicParam.userid,7);
  //ShowDevInfo(gPublicParam.cityid);

end;

procedure TFormAlarmStateLook.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormAlarmStateLook,1,'','');
end;

procedure TFormAlarmStateLook.FormDestroy(Sender: TObject);
begin
  FCxGridHelper.Free;
end;

procedure TFormAlarmStateLook.cxGrid1DBTableView1DataControllerDetailExpanding(
  ADataController: TcxCustomDataController; ARecordIndex: Integer;
  var AAllow: Boolean);
//var
 // lDevID, lBTSID: Integer;
begin
 { //�������дӱ�
  ADataController.CollapseDetails;
  try
    lBTSID:=cxGrid1DBTableView1.GetColumnByFieldName('btsid').Index; //btsid��ʵ��Ӧ�ڲ���deviceid
    lDevID:= cxGrid1DBTableView1.DataController.GetValue(ARecordIndex,lBTSID);
  except
    Application.MessageBox('δ��ùؼ��ֶ�CITYID,COMPANYID,BATCHID��','��ʾ',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
      }
end;



procedure TFormAlarmStateLook.OnGridPopup(Sender: TObject);
//var
  //lIsSynchro: Integer;
begin// ͬ���ֶ�
//  lIsSynchro:= ClientDataSet2.FieldByName('StatCompare').AsInteger;
//  if lIsSynchro=0 then
//    MenuItem_Synchro.Enabled:= True
//  else
//    MenuItem_Synchro.Enabled:= False;
end;

procedure TFormAlarmStateLook.SynchroDevStateOnClickEvent(Sender: TObject);  //��վ״̬ͬ��
begin
//
end;

procedure TFormAlarmStateLook.cxButton1Click(Sender: TObject);
var lClientDataSet: TClientDataSet;
    i, lAlarmCode: Integer;
    lAlarmCaption: string;
    iError:Integer;
    lMessageInfo: string;
    lVDeviceid, lVCoDeviceID,  lVAlarmContentCode:Integer;
    lsqltr: string;
begin
         if Edit1.Text='' then
         begin
             Application.MessageBox('BTSID ������д !!','��ʾ',MB_OK	+MB_ICONINFORMATION);
             Exit;
         end;
           lVDeviceid:=StrToInt(Edit1.Text);

         if ComboBox1.text='' then
            lVCoDeviceID:=-1
         else
            lVCoDeviceID:=StrToInt(ComboBox1.text);
         if Edit2.Text='' then
            lVAlarmContentCode:=-1
         else
            lVAlarmContentCode:=StrToInt(Edit2.Text);
         iError := gTempInterface.AlarmQueryStatus(gPublicParam.cityid, lVDeviceid, lVCoDeviceID, lVAlarmContentCode, gPublicParam.userid);
         if iError=0 then
            begin
               lClientDataSet:=TClientDataSet.Create(nil);
               lClientDataSet.ProviderName:='ALARM_DATA_STATUE' ;
               lsqltr:='select codeviceid from alarm_data_statue t where deviceid like '+#39+'%'+Edit1.Text+'%'+#39;
               lClientDataSet.Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lsqltr]),0);
               if lClientDataSet.FieldByName('codeviceid').AsString='' then
               begin
                 lsqltr:='select b.deviceid as bts_label ,a.dicname as alarm_status'+
                         ' from alarm_data_statue b '+
                         ' left join alarm_dic_code_info a' +
                         ' on a.diccode=b.alarm_status and dictype=26 ' +
                         ' where b.deviceid like '+#39+'%'+Edit1.Text+'%'+#39 ;
                 lClientDataSet.Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lsqltr]),0);
                 DataSource1.DataSet:=lClientDataSet;
                 Exit;
               end;
               lClientDataSet.Data:=gTempInterface.GetCDSData(VarArrayOf([1,225]),0);
               with lClientDataSet do
                 begin
                   if gHashedAlarmListLocal.Count<1 then
                      begin
                          Data:=gTempInterface.GetCDSData(VarArrayOf([1,225]),0);
                      end
                   else
                      begin
                      for i:=0 to gHashedAlarmListLocal.Count-1 do
                        begin
                           lAlarmCode:=TWdInteger(gHashedAlarmListLocal.Objects[i]).Value;
                           Data:=gTempInterface.GetCDSData(VarArrayOf([1,225]),0);
                        end;
                      end;
                       DataSource1.DataSet:=nil;
                       Application.MessageBox(PChar('���鵽'+IntToStr(RecordCount)+'����¼'),'��ʾ',MB_OK	+MB_ICONINFORMATION);
                       DataSource1.DataSet:=lClientDataSet;
                       gHashedAlarmListLocal.free;
                       gHashedAlarmListLocal:= THashedStringList.Create;
                 end;

            end

         else
         begin
             if ierror=-2 then
               begin
                      lMessageInfo:= '���ô洢����ʧ�ܣ������Ǵ洢����ʧЧ�����±���洢����!';
                        lMessageInfo:= lMessageInfo+' �����ţ�'+inttostr(iError);
                        Application.MessageBox(pchar(lMessageInfo), 'ϵͳ��ʾ', MB_ICONWARNING);
               end;
          Application.MessageBox(pchar('�澯״̬�����쳣'), 'ϵͳ��ʾ', MB_ICONWARNING);
         end;



end;

procedure TFormAlarmStateLook.CheckBox2Click(Sender: TObject);
begin
     if CheckBox2.Checked then
        begin
           Edit2.Enabled:=True;
           Button1.Enabled:=True;
           exit;
        end
     else
     begin
        Edit2.Enabled:=False;
        Button1.Enabled:=False;
        Edit2.Text:='';
        exit;
     end;
end;

procedure TFormAlarmStateLook.Button1Click(Sender: TObject);
var
  i, j, lAlarmCode: Integer;
  lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lHashedAlarmList: THashedStringList;
  sqlstr:string;
  lClientDataSet:TClientDataSet;
  lFormAlarmContentModule: TFormAlarmContentModule;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  lHashedAlarmList:= THashedStringList.Create;
  lHashedAlarmList:=gHashedAlarmListLocal;
  lFormAlarmContentModule:= TFormAlarmContentModule.create(nil,lHashedAlarmList);
  try
    repeat
      lFormAlarmContentModule.ShowModal;
      if lFormAlarmContentModule.ModalResult <> mrOk then
        break;
      if gHashedAlarmListLocal.Count=0 then
         Application.MessageBox(pchar('ѡ��һ���澯����'), 'ϵͳ��ʾ', MB_ICONWARNING);
      if gHashedAlarmListLocal.Count>1 then
         Application.MessageBox(pchar('�ù��ܸ澯����ֻ��ѡ��һ��'), 'ϵͳ��ʾ', MB_ICONWARNING);
    until (lFormAlarmContentModule.gHashedAlarmList.Count=1)
          and (lFormAlarmContentModule.ModalResult = mrOk);
    if lFormAlarmContentModule.ModalResult = mrOk then
    begin
      sqlstr:='select * from alarm_content_info t where t.alarmcontentname||'+#39+'['+#39+'||t.alarmcontentcode||'+#39+']'+#39+
              '='+#39+gHashedAlarmListLocal.Strings[0]+#39;
      lClientDataSet.Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,sqlstr]),0);
      Edit2.Text:=lClientDataSet.FieldByName('alarmcontentcode').AsString;
    end;
  finally
    lClientDataSet.Free;
    lFormAlarmContentModule.Free;
  end;
end;

procedure TFormAlarmStateLook.CheckBox1Click(Sender: TObject);
begin
     if CheckBox1.Checked then
        begin
           ComboBox1.Enabled:=True;
           exit;
        end
     else
     begin
        ComboBox1.Enabled:=False;
        ComboBox1.Text:='';
        exit;
     end;
end;

procedure TFormAlarmStateLook.Edit1KeyPress(Sender: TObject;
  var Key: Char);
begin
     InPutNum(key);
     if Edit1.text<>'' then
       try
            StrToInt(Edit1.text);
        except
          ShowMessage('�������');
          Edit1.text:='';
          Exit;
        end

end;

procedure TFormAlarmStateLook.Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
     InPutNum(key);
     if Edit2.text<>'' then
       try
            StrToInt(Edit2.text);
        except
          ShowMessage('�������');
          Edit2.text:='';
          Exit;
        end

end;

procedure TFormAlarmStateLook.ComboBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
   if  ComboBox1.Text=''then
          begin
              if not (key in ['0'..'5']) then
              begin
                Key := #0;
              end;
          end
   else
     begin
          Key := #0
     end;

        //ShowMessage('��ѡ�����������');
   //ComboBox1.Text:=ComboBox1.Items[1];
end;

end.
