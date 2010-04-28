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
  TNodeType = (PROVINCE,  //0  省
               CITY,      //1  地市
               TOWN,      //2  行政区 杭州市区
               SUBURB,    //3  分局   西湖分局
               Company,   //4  维护单位
               Device      //5  设备
               );
  TNodeParam = class(Tobject)
  public
    NodeType     :TNodeType;
    Cityid       :integer;    //城市编号
    CompanyID    :integer;   //维护单位编号
    TownID       :integer;    //行政区编号
    SuburbID     :integer;    //分局编号
    DevID        :Integer;
    AlarmID      :integer; //告警编号
    ParentID     :integer;    // 父节点编号
    HaveExpanded :boolean;  //是否已经展开
    DisplayName  :string;    //显示名称 ，如 全网
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
//  MenuItem_Synchro := FCxGridHelper.AppendMenuItem('基站状态同步',SynchroDevStateOnClickEvent);
  gHashedAlarmListLocal:= THashedStringList.Create;
  TPopupMenu(cxGrid1.PopupMenu).OnPopup:= OnGridPopup;
end;

procedure TFormAlarmStateLook.FormShow(Sender: TObject);
begin
  AddCategory(cxGrid1DBTableView1,gPublicParam.cityid,gPublicParam.userid,25);  //添加字段
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
 { //收起所有从表
  ADataController.CollapseDetails;
  try
    lBTSID:=cxGrid1DBTableView1.GetColumnByFieldName('btsid').Index; //btsid其实对应内部的deviceid
    lDevID:= cxGrid1DBTableView1.DataController.GetValue(ARecordIndex,lBTSID);
  except
    Application.MessageBox('未获得关键字段CITYID,COMPANYID,BATCHID！','提示',MB_OK	+MB_ICONINFORMATION);
    exit;
  end;
      }
end;



procedure TFormAlarmStateLook.OnGridPopup(Sender: TObject);
//var
  //lIsSynchro: Integer;
begin// 同步字段
//  lIsSynchro:= ClientDataSet2.FieldByName('StatCompare').AsInteger;
//  if lIsSynchro=0 then
//    MenuItem_Synchro.Enabled:= True
//  else
//    MenuItem_Synchro.Enabled:= False;
end;

procedure TFormAlarmStateLook.SynchroDevStateOnClickEvent(Sender: TObject);  //基站状态同步
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
             Application.MessageBox('BTSID 必须填写 !!','提示',MB_OK	+MB_ICONINFORMATION);
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
                       Application.MessageBox(PChar('共查到'+IntToStr(RecordCount)+'条记录'),'提示',MB_OK	+MB_ICONINFORMATION);
                       DataSource1.DataSet:=lClientDataSet;
                       gHashedAlarmListLocal.free;
                       gHashedAlarmListLocal:= THashedStringList.Create;
                 end;

            end

         else
         begin
             if ierror=-2 then
               begin
                      lMessageInfo:= '调用存储过程失败，可能是存储过程失效，重新编译存储过程!';
                        lMessageInfo:= lMessageInfo+' 错误编号：'+inttostr(iError);
                        Application.MessageBox(pchar(lMessageInfo), '系统提示', MB_ICONWARNING);
               end;
          Application.MessageBox(pchar('告警状态更新异常'), '系统提示', MB_ICONWARNING);
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
         Application.MessageBox(pchar('选择一个告警内容'), '系统提示', MB_ICONWARNING);
      if gHashedAlarmListLocal.Count>1 then
         Application.MessageBox(pchar('该功能告警内容只能选择一个'), '系统提示', MB_ICONWARNING);
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
          ShowMessage('输入过长');
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
          ShowMessage('输入过长');
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

        //ShowMessage('请选择给定的扇区');
   //ComboBox1.Text:=ComboBox1.Items[1];
end;

end.
