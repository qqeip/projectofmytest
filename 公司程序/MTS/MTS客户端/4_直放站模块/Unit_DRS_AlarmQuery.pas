unit Unit_DRS_AlarmQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, BaseGrid, AdvGrid, StdCtrls, ComCtrls,
  Ut_Common, CxGridUnit, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, DBClient, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, dxSkinsCore, IniFiles, StringUtils, Buttons;

type
  TForm_DRS_AlarmQuery = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Btn_Query: TButton;
    Cmb_City: TComboBox;
    Cmb_Area: TComboBox;
    Cmb_SFD: TComboBox;
//    Cmb_AC: TComboBox;
    Cmb_AT: TComboBox;
    Edt_DRS_Info: TEdit;
    Cmb_AlarmHF: TComboBox;
    SendD1: TDateTimePicker;
    SendT1: TDateTimePicker;
    SendD2: TDateTimePicker;
    SendT2: TDateTimePicker;
    Label13: TLabel;
    MoveD1: TDateTimePicker;
    MoveT1: TDateTimePicker;
    MoveD2: TDateTimePicker;
    MoveT2: TDateTimePicker;
    Chb_City: TCheckBox;
    Chb_Area: TCheckBox;
    Chb_SFD: TCheckBox;
    Chb_AC: TCheckBox;
    Chb_AT: TCheckBox;
    Chb_DRSInfo: TCheckBox;
    Chb_SendTime: TCheckBox;
    Chb_ClearTime: TCheckBox;
    CheckBoxAll: TCheckBox;
    Btn_Close: TButton;
    CheckBoxSuburb: TCheckBox;
    ComboBoxSuburb: TComboBox;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    ClientDataSetOnLine: TClientDataSet;
    DataSourceOnLine: TDataSource;
    Cmb_AC: TEdit;
    SpeedButtonSearch: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Cmb_CityChange(Sender: TObject);
    procedure Cmb_AreaChange(Sender: TObject);
    procedure Cmb_SFDChange(Sender: TObject);
    procedure Cmb_ACChange(Sender: TObject);
    procedure Cmb_ATChange(Sender: TObject);
    procedure Btn_QueryClick(Sender: TObject);
    procedure CheckBoxAllClick(Sender: TObject);
    procedure Chb_CityClick(Sender: TObject);
    procedure Chb_AreaClick(Sender: TObject);
    procedure Chb_SFDClick(Sender: TObject);
    procedure Chb_ACClick(Sender: TObject);
    procedure Chb_ATClick(Sender: TObject);
    procedure Chb_DRSInfoClick(Sender: TObject);
    procedure Chb_SendTimeClick(Sender: TObject);
    procedure Chb_ClearTimeClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
    procedure ComboBoxSuburbChange(Sender: TObject);
    procedure CheckBoxSuburbClick(Sender: TObject);
    procedure ButtonALARM_CONTENTClick(Sender: TObject);
    procedure SpeedButtonSearchClick(Sender: TObject);
  private
    { Private declarations }
    FCxGridHelper : TCxGridSet;
    procedure InitCity;    //加载全部地市
    procedure InitOneCity(vcity:integer); //加载指定地市
    procedure InitOneArea(varea:integer); //加载指定郊县
    procedure InitArea(vcity:integer); //加载某地市的全部郊县
    procedure InitSuburb(aAreaid: integer);
    procedure InitSFD(varea:integer);  //加载某郊县的所有室分点
    procedure InitAlarmContent;    //加载全部告警内容
    procedure InitAlarmType;       //加载全部告警类型
    procedure InitDRSType;         //加载全部直放站类型
    //显示当前日期
    procedure SetToDay;
    //控制选项是否有效
    procedure SetEdit(index: integer);
    //判断是否选择了条件
    function IsSelectCondition() : Boolean;
    //判断时间是否合法
    function CheckTime() : Boolean;
    // 获取查询条件
    function GetSelectCondition() : String;
    procedure AddViewField_AlarmOnline;
  public
    { Public declarations }
    gSelectCode: string;
    gHashedAlarmListLocal:THashedStringList;
    //（地市，郊县，室分点，告警内容，告警类型）的 ID
    
    VcityID,VareaID,VsuburbID,VsfdID,VacID,VatID:Integer;
  end;

var
  Form_DRS_AlarmQuery: TForm_DRS_AlarmQuery;

implementation

Uses Ut_MainForm,Ut_DataModule, Ut_AlarmQuery, UnitAlarmContentModule,
  UnitBaseShowModal;
{$R *.dfm}

procedure TForm_DRS_AlarmQuery.AddViewField_AlarmOnline;
begin
  AddViewField(cxGrid1DBTableView1,'alarmid','告警编号');
  AddViewField(cxGrid1DBTableView1,'alarmcontentname','告警内容');
  AddViewField(cxGrid1DBTableView1,'alarmkindname','告警类型');
  AddViewField(cxGrid1DBTableView1,'alarmlevelname','告警等级');
  AddViewField(cxGrid1DBTableView1,'sendtime','派障时间');
  AddViewField(cxGrid1DBTableView1,'limithour','到期时限');
  AddViewField(cxGrid1DBTableView1,'removetime','排障时间');
  AddViewField(cxGrid1DBTableView1,'drsname','直放站名称');
  AddViewField(cxGrid1DBTableView1,'drsno','直放站编号');
  AddViewField(cxGrid1DBTableView1,'drstypename','直放站类型');
  AddViewField(cxGrid1DBTableView1,'DRSADRESS','地址');
  AddViewField(cxGrid1DBTableView1,'drsphone','电话号码');
  AddViewField(cxGrid1DBTableView1,'alarmcount','告警累计次数');
//  AddViewField(cxGrid1DBTableView1,'overlay','覆盖范围');
  AddViewField(cxGrid1DBTableView1,'buildingname','室分点名称');
  AddViewField(cxGrid1DBTableView1,'agentcompanyname','代维公司');
  AddViewField(cxGrid1DBTableView1,'isprogramname','室内/室外');
  AddViewField(cxGrid1DBTableView1,'address','室分点地址');
  AddViewField(cxGrid1DBTableView1,'areaname','郊县');
  AddViewField(cxGrid1DBTableView1,'suburbname','分局');
  AddViewField(cxGrid1DBTableView1,'cityname','地市');
  AddViewField(cxGrid1DBTableView1,'readedname','是否已阅');
  AddViewField(cxGrid1DBTableView1,'flowtachename','告警状态');
//  AddViewField(cxGrid1DBTableView1,'assistantContentcode','网管告警内容');
  AddViewField(cxGrid1DBTableView1,'Longitude','经度');
  AddViewField(cxGrid1DBTableView1,'Latitude','纬度');
  AddViewField(cxGrid1DBTableView1,'drsmanuname','厂家');
  AddViewField(cxGrid1DBTableView1,'msc','归属MSC');
  AddViewField(cxGrid1DBTableView1,'bsc','归属BSC');
  AddViewField(cxGrid1DBTableView1,'cell','归属扇区');
//  AddViewField(cxGrid1DBTableView1,'mainlook_apname','主监控AP');
//  AddViewField(cxGrid1DBTableView1,'mainlook_phsname','主监控PHS');
//  AddViewField(cxGrid1DBTableView1,'mainlook_cnetname','主监控C网');
//  AddViewField(cxGrid1DBTableView1,'cdmatypename','C网信源类型');
//  AddViewField(cxGrid1DBTableView1,'cdmaaddress','C网信源安装位置');
 AddViewField(cxGrid1DBTableView1,'pn','PN码');
end;


procedure TForm_DRS_AlarmQuery.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_DRS_AlarmQuery.Btn_QueryClick(Sender: TObject);
var
  StrSQL:string;
begin
  StrSQL:='';

  if not IsSelectCondition  then
  begin
      MessageBox(Handle, '请选择至少一个条件并设置该条件后继续!', '信息', MB_OK + MB_ICONINFORMATION);
      Exit;
  end;
  if not CheckTime then
  begin
      MessageBox(Handle, '起始时间不能大于截止时间!', '信息', MB_OK + MB_ICONINFORMATION);
      Exit;
  end;

  StrSQL := GetSelectCondition;
  if StrSQL='' then
     Exit;
  Screen.Cursor := crHourGlass;
  try
    DataSourceOnLine.DataSet:= nil;
    with ClientDataSetOnLine do
    begin
      close;
      ProviderName:='dsp_General_data';
      StrSQL:= 'select * from '+
               '(select * from alarm_drs_master_online_view a  '+   //where flowtache=2
               'union all select * from alarm_drs_master_history_view a) a'+
               ' where 1=1 '+StrSQL ;//+ ' order by t.sendtime desc';
      Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,StrSQL]),0);


//      if Cmb_AlarmHF.ItemIndex=0 then
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,31,StrSQL]),0)
//      else
//        Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,3,32,StrSQL]),0);
    end;
    DataSourceOnLine.DataSet:= ClientDataSetOnLine;
    cxGrid1DBTableView1.ApplyBestFit();
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm_DRS_AlarmQuery.ButtonALARM_CONTENTClick(Sender: TObject);
var
  i, j, lAlarmCode: Integer;
  lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lHashedAlarmList: THashedStringList;
  lsqlstr:string;
  lClientDataSet:TClientDataSet;
  lFormAlarmContentModule: TFormAlarmContentModule;
  lContentcodeStr,lContentNameStr: string;

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
      if gHashedAlarmListLocal.Count>18 then
         Application.MessageBox(pchar('该功能告警内容最多只能选择十八个'), '系统提示', MB_ICONWARNING);
    until (lFormAlarmContentModule.gHashedAlarmList.Count>0) and  (lFormAlarmContentModule.gHashedAlarmList.Count<19)
          and (lFormAlarmContentModule.ModalResult = mrOk);
    if lFormAlarmContentModule.ModalResult = mrOk then
    begin
      gSelectCode:='';
      Cmb_AC.Text:='';
      Cmb_AC.hint:='';
      Cmb_AC.ShowHint:=false;
      for j:= 0 to lFormAlarmContentModule.gHashedAlarmList.Count -1 do
      begin
        lContentNameStr:= lContentNameStr+ lFormAlarmContentModule.gHashedAlarmList.Strings[j]+',';
        lContentcodeStr:= lContentcodeStr+ TWdInteger(lFormAlarmContentModule.gHashedAlarmList.Objects[j]).ToString+',';
      end;
      if length(lContentNameStr)>0 then
        lContentNameStr:= copy(lContentNameStr,1,length(lContentNameStr)-1)
      else
        lContentNameStr:= '';
      if length(lContentcodeStr)>0 then
        lContentcodeStr:= copy(lContentcodeStr,1,length(lContentcodeStr)-1)
      else
        lContentcodeStr:= '-1';
        
      Cmb_AC.Text:= lContentNameStr;
      gSelectCode:= lContentcodeStr;
      Cmb_AC.Hint:=Cmb_AC.Text;
      Cmb_AC.ShowHint:=True;
    end;
  finally
     lFormAlarmContentModule.gHashedAlarmList.Clear;
     lClientDataSet.Free;
     lFormAlarmContentModule.Free;
  end;
end;

procedure TForm_DRS_AlarmQuery.Chb_ACClick(Sender: TObject);
begin
  SetEdit(Chb_AC.Tag);
end;

procedure TForm_DRS_AlarmQuery.Chb_AreaClick(Sender: TObject);
begin
//  SetEdit(Chb_Area.Tag);
//    If (Chb_Area.Checked)  Then
//    begin
//       Chb_SFD.Enabled := True;
//       if Cmb_SFD.Items.Count > 0 then
//        Chb_SFD.Enabled := True;
//    end
//    Else
//    begin
//       Chb_SFD.Checked := False;
//       Chb_SFD.Enabled := False;
//    end;
  SetEdit(Chb_Area.Tag);
  If (Chb_Area.Checked)  Then
  begin
//     Chb_SFD.Enabled := True;
     CheckBoxSuburb.Enabled:= true;
     if Cmb_SFD.Items.Count > 0 then
//      Chb_SFD.Enabled := True;
       CheckBoxSuburb.Enabled:= true;
  end
  Else
  begin
     CheckBoxSuburb.Checked := False;
     CheckBoxSuburb.Enabled := False;
  end;
end;

procedure TForm_DRS_AlarmQuery.Chb_ATClick(Sender: TObject);
begin
  SetEdit(Chb_AT.Tag);
end;

procedure TForm_DRS_AlarmQuery.Chb_CityClick(Sender: TObject);
begin
    SetEdit(Chb_City.Tag);
    If (Chb_City.Checked)  Then
    begin
       Chb_Area.Enabled := True;
       CheckBoxSuburb.Enabled := true;
       if Cmb_SFD.Items.Count > 0 then
        Chb_SFD.Enabled := True;
    end
    Else
    begin
       Chb_Area.Checked := False;
       Chb_Area.Enabled := False;
       self.CheckBoxSuburb.Checked := False;
       self.CheckBoxSuburb.Enabled := False;
       Chb_SFD.Checked := False;
       Chb_SFD.Enabled := False;
    end;
end;

procedure TForm_DRS_AlarmQuery.Chb_ClearTimeClick(Sender: TObject);
begin
  SetEdit(Chb_ClearTime.Tag);
end;

procedure TForm_DRS_AlarmQuery.Chb_DRSInfoClick(Sender: TObject);
begin
  SetEdit(Chb_DRSInfo.Tag);
//  if Chb_DRSInfo.Checked then
    Edt_DRS_Info.ShowHint:=True;

end;

procedure TForm_DRS_AlarmQuery.Chb_SendTimeClick(Sender: TObject);
begin
  SetEdit(Chb_SendTime.Tag);
end;

procedure TForm_DRS_AlarmQuery.Chb_SFDClick(Sender: TObject);
begin
    SetEdit(Chb_SFD.Tag);
end;

procedure TForm_DRS_AlarmQuery.CheckBoxAllClick(Sender: TObject);
var
    i: integer;
begin
    if CheckBoxAll.Checked then //选中
    begin
        for i := 0 to ComponentCount-1 do
        begin
            if (Components[i] is TCheckBox) then
                (Components[i] as TCheckBox).Checked := true;
        end;
    end
    else
    begin
        for i := 0 to ComponentCount-1 do
        begin
            if (Components[i] is TCheckBox) then
                (Components[i] as TCheckBox).Checked := false;
        end;
    end;
end;

procedure TForm_DRS_AlarmQuery.CheckBoxSuburbClick(Sender: TObject);
begin
  SetEdit(self.CheckBoxSuburb.Tag);
  If (CheckBoxSuburb.Checked)  Then
  begin
     Chb_SFD.Enabled := True;
     if Cmb_SFD.Items.Count > 0 then
      Chb_SFD.Enabled := True;
  end
  Else
  begin
     Chb_SFD.Checked := False;
     Chb_SFD.Enabled := False;
  end;
end;

function TForm_DRS_AlarmQuery.CheckTime: Boolean;
begin
   result := true;
   if chb_SendTime.Checked then
        if SendD1.Date > SendD2.Date then
        begin
            result := false;
            Exit;
        end;
   if Chb_ClearTime.Checked then
        if MoveD1.Date > MoveD2.Date then
        begin
            result := false;
            Exit;
        end;
end;

procedure TForm_DRS_AlarmQuery.Cmb_ACChange(Sender: TObject);
begin
//  VacID:=TCommonObj(Cmb_AC.Items.Objects[Cmb_AC.ItemIndex]).ID;
end;

procedure TForm_DRS_AlarmQuery.Cmb_AreaChange(Sender: TObject);
begin
  VareaID:=TCommonObj(Cmb_Area.Items.Objects[Cmb_Area.ItemIndex]).ID;

  If (Chb_Area.Checked) and (VareaID<>0) Then
  begin
    Chb_Area.Enabled:=True;
    InitSuburb(VareaID);
  end
  Else
  begin
    Chb_Area.Checked := False ;
    Chb_Area.Enabled :=False;
  end;
end;

procedure TForm_DRS_AlarmQuery.Cmb_ATChange(Sender: TObject);
begin
  VatID:=TCommonObj(Cmb_AT.Items.Objects[Cmb_AT.ItemIndex]).ID;
end;

procedure TForm_DRS_AlarmQuery.Cmb_CityChange(Sender: TObject);
begin
  VcityID:=TCommonObj(Cmb_City.Items.Objects[Cmb_City.ItemIndex]).ID;

  If (Chb_City.Checked) and (VcityID<>0) Then
  begin
     Chb_Area.Enabled:=True;
     With Fm_MainForm.PublicParam Do
     begin
         if (cityid=0) and (areaid=0) then          //省级用户
         begin
         InitArea(VcityID);
         end
         else if (cityid<>0) and (areaid=0) then    //地市用户
         begin
         InitArea(VcityID);
         end
         else if (cityid<>0) and (areaid<>0) then   //郊县用户
         begin
         InitOneArea(areaid);
         end;
     end;
  end
  Else
  begin
    Chb_Area.Checked :=False ;
    Chb_Area.Enabled :=False;
    Cmb_Area.Enabled := False ;
  end;



end;

procedure TForm_DRS_AlarmQuery.Cmb_SFDChange(Sender: TObject);
begin
  VsfdID:=TCommonObj(Cmb_SFD.Items.Objects[Cmb_SFD.ItemIndex]).ID;
end;

procedure TForm_DRS_AlarmQuery.ComboBoxSuburbChange(Sender: TObject);
begin
  VsuburbID:=TCommonObj(ComboBoxSuburb.Items.Objects[ComboBoxSuburb.ItemIndex]).ID;

  If (self.CheckBoxSuburb.Checked) and (VsuburbID<>0) Then
  begin
    ComboBoxSuburb.Enabled:=True;
    InitSFD(VsuburbID);
  end
  Else
  begin
    CheckBoxSuburb.Checked := False ;
    CheckBoxSuburb.Enabled :=False;
  end;
end;

procedure TForm_DRS_AlarmQuery.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FCxGridHelper.Free;
  gHashedAlarmListLocal.Free;
  ClearTStrings(Cmb_City.Items);
  ClearTStrings(Cmb_Area.Items);
  ClearTStrings(Cmb_SFD.Items);
  ClearTStrings(Cmb_AT.Items);
  ClearTStrings(ComboBoxSuburb.Items);


  Fm_MainForm.DeleteTab(self);
  Action := cafree;
  Form_DRS_AlarmQuery:=nil;
end;

procedure TForm_DRS_AlarmQuery.FormCreate(Sender: TObject);
begin
  ClientDataSetOnLine.RemoteServer:= Dm_MTS.SocketConnection1;
  
  FCxGridHelper:=TCxGridSet.Create;
//  FCxGridHelper.SetGridStyle(cxGrid1,false,true,false);
  FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);
  gHashedAlarmListLocal:=THashedStringList.Create();
end;

procedure TForm_DRS_AlarmQuery.FormShow(Sender: TObject);
begin
 With Fm_MainForm.PublicParam Do
 begin
     if (cityid=0) and (areaid=0) then          //省级用户
     begin
       InitCity;
       InitAlarmContent;
//       InitAlarmType;
       InitDRSType;
       SetToDay;
     end
     else if (cityid<>0) and (areaid=0) then    //地市用户
     begin
       InitOneCity(cityid);
       InitAlarmContent;
//       InitAlarmType;
       InitDRSType;
       SetToDay;
     end
     else if (cityid<>0) and (areaid<>0) then   //郊县用户
     begin
       InitOneCity(cityid);
       InitAlarmContent;
//       InitAlarmType;
       InitDRSType;
       SetToDay;
     end;
 end;

 AddViewField_AlarmOnline;
end;

function TForm_DRS_AlarmQuery.GetSelectCondition: String;
var
  StrSQL : String;
  i : Integer;
begin
  StrSQL := '';
  for i := 0 to GroupBox1.ControlCount - 1 do
  begin
        if GroupBox1.Controls[i] is TCheckBox then
            if (GroupBox1.Controls[i] as TCheckBox).Checked then
            begin
                case (GroupBox1.Controls[i] as TCheckBox).Tag of
                    1:  //所属地市
                        begin
                            if Cmb_City.ItemIndex=-1 then
                              begin
                                MessageBox(Handle, '查询条件未填写,请核对!', '信息', MB_OK + MB_ICONINFORMATION);
                                StrSQL := '';
                                Exit;
                              end
                            else
//                              StrSQL:=StrSQL+' and f.id='+inttostr(VcityID);
                              StrSQL:= StrSQL+' and a.cityid='+inttostr(VcityID);
                        end;
                    2: //所属郊县
                        begin
                            if Cmb_Area.ItemIndex=-1 then
                              begin
                                MessageBox(Handle, '查询条件未填写,请核对!', '信息', MB_OK + MB_ICONINFORMATION);
                                StrSQL := '';
                                Exit
                              end
                            else
//                              StrSQL:=StrSQL+' and e.id='+inttostr(VareaID);
                              StrSQL:=StrSQL+' and a.areaid='+inttostr(VareaID);
                        end;
                    9://所属分局
                        begin
                          if ComboBoxSuburb.ItemIndex=-1 then
                              begin
                                MessageBox(Handle, '查询条件未填写,请核对!', '信息', MB_OK + MB_ICONINFORMATION);
                                StrSQL := '';
                                Exit
                              end
                            else
//                              StrSQL:=StrSQL+' and e.id='+inttostr(VareaID);
                              StrSQL:=StrSQL+' and a.suburbid='+inttostr(VsuburbID);
                        end;
                    3: //室分点
                        begin
                            if Cmb_SFD.ItemIndex=-1 then
                              begin
                                MessageBox(Handle, '查询条件未填写,请核对!', '信息', MB_OK + MB_ICONINFORMATION);
                                StrSQL := '';
                                Exit
                              end
                            else
                                StrSQL:=StrSQL+' and a.buildingid='+inttostr(VsfdID);
                        end;
                    4: //告警内容
                        begin
                          if gSelectCode=''then
                            begin
                                MessageBox(Handle, '查询条件未填写,请核对!', '信息', MB_OK + MB_ICONINFORMATION);
                                StrSQL := '';
                                Exit
                            end
                          else
                                StrSQL:=StrSQL+' and (a.alarmcontentcode='+inttostr(VacID)+' or '+
                                               'a.alarmcontentcode in ('+gSelectCode+' )) ';
                        end;
                    5: //告警类型
                        begin
                          if Cmb_AT.ItemIndex=-1 then
                            begin
                                MessageBox(Handle, '查询条件未填写,请核对!', '信息', MB_OK + MB_ICONINFORMATION);
                                StrSQL := '';
                                Exit
                            end
                          else
                            StrSQL:=StrSQL+' and a.DRSTYPE='+inttostr(VatID);
                        end;
                    6: //DRS编号、名称、地址、电话号码
                        begin
                            if Trim(Edt_DRS_Info.Text) = '' then
                              begin
                                  MessageBox(Handle, '查询条件未填写,请核对!', '信息', MB_OK + MB_ICONINFORMATION);
                                  StrSQL := '';
                                  Exit;
                              end
                            else
                              StrSQL:=StrSQL+' and (upper(a.drsno) like ''%'+uppercase(Edt_DRS_Info.Text)+
                                             '%'' or upper(a.drsname) like ''%'+uppercase(Edt_DRS_Info.Text)+
                                             '%'' or upper(a.DRSADRESS) like ''%'+uppercase(Edt_DRS_Info.Text)+
                                             '%'' or upper(a.drsphone) like ''%'+uppercase(Edt_DRS_Info.Text)+'%'')';
                        end;
                    7:  //派障时间
                        begin
                        StrSQL := StrSQL +
                        ' and to_char(a.SendTime,''YYYY-MM-DD HH24:MI'')>= '''+FormatDateTime('YYYY-MM-DD',SendD1.Date)+' '+FormatDateTime('HH:mm',SendT1.Time)+''' '+
                        ' and to_char(a.SendTime,''YYYY-MM-DD HH24:MI'')<= '''+FormatDateTime('YYYY-MM-DD',SendD2.Date)+' '+FormatDateTime('HH:mm',SendT2.Time)+''' ';
                        end;
                    8: //排障时间
                        begin
                        StrSQL := StrSQL +
                        ' and to_char(a.removetime,''YYYY-MM-DD HH24:MI'')>= '''+FormatDateTime('YYYY-MM-DD',MoveD1.Date)+' '+FormatDateTime('HH:mm',MoveT1.Time)+''' '+
                        ' and to_char(a.removetime,''YYYY-MM-DD HH24:MI'')<= '''+FormatDateTime('YYYY-MM-DD',MoveD2.Date)+' '+FormatDateTime('HH:mm',MoveT2.Time)+''' ';
                        end;

                end;// end of case
            end;
  end;
  result := StrSQL;
end;


procedure TForm_DRS_AlarmQuery.InitAlarmContent;
var
  obj :TCommonObj;
  Lsqlstr:string;
begin
//  Cmb_AC.Items.Clear;
  Lsqlstr:= ' select * from DRS_alarm_content order by alarmcontentcode';
  With Dm_Mts.cds_common1 do
  begin
//    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,1,11]),0);
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,Lsqlstr]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('alarmcontentcode').AsInteger;
      obj.Name := FieldByName('alarmcontentname').AsString;
//      Cmb_AC.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

procedure TForm_DRS_AlarmQuery.InitAlarmType;
var
  obj :TCommonObj;
begin
  Cmb_AT.Items.Clear;
  With Dm_Mts.cds_common1 do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,1,11]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('diccode').AsInteger;
      obj.Name := FieldByName('dicname').AsString;
      Cmb_AT.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

procedure TForm_DRS_AlarmQuery.InitArea(vcity:integer);
var
  obj :TCommonObj;
begin
  Cmb_Area.Items.Clear;
  With Dm_Mts.cds_common1 do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,3,vcity]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('id').AsInteger;
      obj.Name := FieldByName('name').AsString;
      Cmb_Area.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

procedure TForm_DRS_AlarmQuery.InitCity;
var
  obj :TCommonObj;
begin
  Cmb_City.Items.Clear;
  With Dm_Mts.cds_common1 do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,1]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('id').AsInteger;
      obj.Name := FieldByName('name').AsString;
      Cmb_City.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

procedure TForm_DRS_AlarmQuery.InitDRSType;
begin
   GetDic(51,Cmb_AT.Items);
end;

procedure TForm_DRS_AlarmQuery.InitOneArea(varea: integer);
var
  obj :TCommonObj;
begin
  Cmb_Area.Items.Clear;
  With Dm_Mts.cds_common1 do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,4,varea]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('id').AsInteger;
      obj.Name := FieldByName('name').AsString;
      Cmb_Area.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

procedure TForm_DRS_AlarmQuery.InitOneCity(vcity:integer);
var
  obj :TCommonObj;
begin
  Cmb_City.Items.Clear;
  With Dm_Mts.cds_common1 do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,2,vcity]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('id').AsInteger;
      obj.Name := FieldByName('name').AsString;
      Cmb_City.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

procedure TForm_DRS_AlarmQuery.InitSFD(varea: integer);
var
  obj :TCommonObj;
begin
  Cmb_SFD.Items.Clear;
  With Dm_Mts.cds_common1 do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,5,varea]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('buildingid').AsInteger;
      obj.Name := FieldByName('buildingname').AsString;
      Cmb_SFD.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

procedure TForm_DRS_AlarmQuery.InitSuburb(aAreaid: integer);
var
  obj :TCommonObj;
begin
  ComboBoxSuburb.Items.Clear;
  With Dm_Mts.cds_common1 do
  begin
    Data :=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([0,2,75,aAreaid]),0);
    if IsEmpty then Exit;
    first;
    while not Eof do
    begin
      obj :=TCommonObj.Create;
      obj.ID := FieldByName('id').AsInteger;
      obj.Name := FieldByName('name').AsString;
      ComboBoxSuburb.Items.AddObject(obj.Name,obj);
      Next;
    end;
  end;
end;

function TForm_DRS_AlarmQuery.IsSelectCondition: Boolean;
var
    i : Integer;
begin
    result := false;
    for i := 0 to ComponentCount - 1 do
    begin
        if Components[i] is TCheckBox then
            if (Components[i] as TCheckBox).Checked then
            begin
                result := true;
                Exit;
            end;
    end;
end;

procedure TForm_DRS_AlarmQuery.SetEdit(index: integer);
var
    i, j: integer;
begin
    for i := 0 to ComponentCount - 1 do
    begin
        if (Components[i] is TCheckBox) and (Components[i].Tag = index) then
            if (Components[i] as TCheckBox).Checked then
            begin
                for j := 0 to ComponentCount - 1 do
                begin
                    if (Components[j].Tag = index) and (not (Components[j] is TCheckBox)) then
                    begin
                        (Components[j] as TWinControl).Enabled := true;
                        (Components[j] as TWinControl).SetFocus;
                        Exit;
                    end;
                end;
            end
            else
            begin
                for j := 0 to ComponentCount - 1 do
                begin
                    if (Components[j].Tag = index) and (not (Components[j] is TCheckBox)) then
                    begin
                        (Components[j] as TWinControl).Enabled := false;
                        if (Components[j] is TEdit) then
                            (Components[j] as TEdit).Text := '';
                        Exit;
                    end;
                end;
            end;
    end;
end;

procedure TForm_DRS_AlarmQuery.SetToDay;
begin
  SendD1.Date := date;
  SendT1.Time := time;
  SendD2.Date := date;
  SendT2.Time := time;
  MoveD1.Date := date;
  MoveT1.Time := time;
  MoveD2.Date := date;
  MoveT2.Time := time;
end;

procedure TForm_DRS_AlarmQuery.SpeedButtonSearchClick(Sender: TObject);
var
  i, j, lAlarmCode: Integer;
  lAlarmCaption: string;
  lAlarmObject: TWdInteger;
  lHashedAlarmList: THashedStringList;
  lsqlstr:string;
  lClientDataSet:TClientDataSet;
  lFormAlarmContentModule: TFormAlarmContentModule;
  lContentcodeStr,lContentNameStr: string;

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
      if gHashedAlarmListLocal.Count>18 then
         Application.MessageBox(pchar('该功能告警内容最多只能选择十八个'), '系统提示', MB_ICONWARNING);
    until (lFormAlarmContentModule.gHashedAlarmList.Count>0) and  (lFormAlarmContentModule.gHashedAlarmList.Count<19)
          and (lFormAlarmContentModule.ModalResult = mrOk);
    if lFormAlarmContentModule.ModalResult = mrOk then
    begin
      gSelectCode:='';
      Cmb_AC.Text:='';
      Cmb_AC.hint:='';
      Cmb_AC.ShowHint:=false;
      for j:= 0 to lFormAlarmContentModule.gHashedAlarmList.Count -1 do
      begin
        lContentNameStr:= lContentNameStr+ lFormAlarmContentModule.gHashedAlarmList.Strings[j]+',';
        lContentcodeStr:= lContentcodeStr+ TWdInteger(lFormAlarmContentModule.gHashedAlarmList.Objects[j]).ToString+',';
      end;
      if length(lContentNameStr)>0 then
        lContentNameStr:= copy(lContentNameStr,1,length(lContentNameStr)-1)
      else
        lContentNameStr:= '';
      if length(lContentcodeStr)>0 then
        lContentcodeStr:= copy(lContentcodeStr,1,length(lContentcodeStr)-1)
      else
        lContentcodeStr:= '-1';
        
      Cmb_AC.Text:= lContentNameStr;
      gSelectCode:= lContentcodeStr;
      Cmb_AC.Hint:=Cmb_AC.Text;
      Cmb_AC.ShowHint:=True;
    end;
  finally
     lFormAlarmContentModule.gHashedAlarmList.Clear;
     lClientDataSet.Free;
     lFormAlarmContentModule.Free;
  end;
end;

end.
