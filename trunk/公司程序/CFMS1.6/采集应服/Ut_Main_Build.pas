unit Ut_Main_Build;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, DB, ADODB, XPStyleActnCtrls,
  ActnList, ActnMan, ActnCtrls, ToolWin,Ut_common, ActnMenus, ImgList, ExtCtrls,IniFiles;

type //��ʼ��ϵͳ�������ñ�Alarm_sys_function_setʱ�õ�
  TSysFunction=^TSysFunSet;
  TSysFunSet = record
     Code : integer;
     SetValue : String;
  end;
  TServiceInfo = Record
    ServiceName: String;
    UserName: String;
    Password: String;
    ServerGUID :String;
    ServerIP:String;
    DBPort :integer;
  end;
type
  TFm_Main_Build_Server = class(TForm)
    ActionManager1: TActionManager;
    Action_Collect_Service: TAction;
    ImageList1: TImageList;
    Action_SystemExit: TAction;
    CoolBar1: TCoolBar;
    ActionToolBar1: TActionToolBar;
    Status: TStatusBar;
    Panel1: TPanel;
    Action_RunLog: TAction;
    Action_Flowtache_Monitor: TAction;
    Action_Lock: TAction;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Action_SystemExitExecute(Sender: TObject);
    procedure Action_Collect_ServiceExecute(Sender: TObject);
    procedure Action_RunLogExecute(Sender: TObject);
    procedure Action_Flowtache_MonitorExecute(Sender: TObject);
    procedure Action_LockExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private  
    FQueryCount, SQueryCount: Integer;
    FClientCount: Integer;
    SockConError :integer;
    function OpenPublicDataSet(Kind:integer):Tlist;
    function OpenTheDataSet(CityID,Kind:integer):Tlist;
    function Get_CS_Area(CityID,FilterKind:integer):string;   //�õ��������ɼ����ݵ������б�
    //function GetSendTimeList(CitySN,Kind:integer):integer;//��ʼ������ʱ�����
    function GetWeekSendList(CitySN,Kind:integer):integer;//��ʼ��ÿ�����Ϲ���
    procedure FreeTheList(FunList:TList);  //�ͷ�ָ�����б�
    function GetCsLevelList(CitySN:integer):Boolean;//ȡ��վ�ȼ�
    function GetTimeListByLevel(cityid,Level:integer):TStringList;//��վ�ȼ�����ʱ�̵�
    function GetTimeByLevel(level,cityid:integer;IsSend:Boolean=true):String;
    procedure GetAlarmTest(var IP:String;var Port :integer;cityid:integer);
    // �̷߳���Ϣ�������
    procedure WMThread_msg(var Msg: TMessage);MESSAGE WM_THREAD_MSG;
    procedure WMStateThread_msg(var Msg: TMessage);MESSAGE WM_THREADSTATE_MSG;

    procedure WMCDMA_msg(var Msg: TMessage); MESSAGE WM_CDMA_MSG;

    { Private declarations }
  public
    //��Ϣ�˿�
    //ServerPort : Integer;
    ConnectionString:WideString;
    IfAutoRun : Boolean;
    //DB
    DBName : String;
    ServiceInfo :TServiceInfo;
    function Findform(formname:string; IfBring:boolean=true):boolean; //������Ϊformname�Ĵ����Ƿ����,���ڷ���true
    procedure InitVariable();
    procedure InitPublicVariable();   
    function Action_FirstLoginInit():boolean;
    //�û�У��
    function CheckUser : Boolean;
    { Public declarations }
  end;

var
  Fm_Main_Build_Server: TFm_Main_Build_Server;

implementation

uses Ut_Data_Local, Ut_Collection_Data, Ut_RunLog,Ut_ServerSet,Ut_LoginWin,
  Ut_Flowtache_Monitor;

{$R *.dfm}
//==============================================================
//--��������: GetFileTimeInfor
//--��������: FileName �ļ���  TimeFlag ʱ�����  (1 �����ļ�����ʱ�� 2 �����ļ��޸�ʱ�� 3 �����ϴη����ļ���ʱ��)
//--��������: ��ȡ�ļ��޸�ʱ��
//--�� �� ֵ: ����ָ�����ļ��޸�ʱ��
//--������ע: ��
//==============================================================
function GetFileTimeInfor(FileName:string;TimeFlag:integer):string;
var
  LocalFileTime : TFileTime;
  fhandle:integer;
  DosFileTime : DWORD;
  FindData : TWin32FindData;
begin
  fhandle := FindFirstFile(Pchar(FileName), FindData);
  if (FHandle <> INVALID_HANDLE_VALUE) then
     begin
      if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
        begin
          case TimeFlag of
          1:
            begin
               FileTimeToLocalFileTime(FindData.ftCreationTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
            3:
            begin
               FileTimeToLocalFileTime(FindData.ftLastAccessTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
            2:
            begin
               FileTimeToLocalFileTime(FindData.ftLastWriteTime , LocalFileTime);
               FileTimeToDosDateTime(LocalFileTime, LongRec(DosFileTime).Hi,LongRec(DosFileTime).Lo);
               result :=DateTimeToStr(FileDateToDateTime(DosFileTime));
            end;
           end;  //case;
        end;
     end;
end;

function TFm_Main_Build_Server.Findform(formname:string; IfBring:boolean=true):boolean;        //������Ϊformname�Ĵ����Ƿ����,���ڷ���true
var
   fi:integer;
begin
     result:=false;
     for Fi:=0 to screen.Formcount-1 do
     	if uppercase(screen.forms[Fi].Name) = uppercase(formname) then
      	begin
          if IfBring then
            screen.forms[Fi].BringToFront;
          result:=true;
          break ;
        end
      else
      result:= false;
end;

function TFm_Main_Build_Server.OpenTheDataSet(CityID,Kind:integer):Tlist;
var
  SelSQL : string;
  tempSysFun : TSysFunction;
begin
  Result:= TList.Create;
  SelSQL:='select code,setvalue from alarm_sys_function_set where CityID=:CityID and kind=:kind order by code';
  with Dm_Collect_Local.Ado_Dynamic do
  begin
    close;
    sql.Clear;
    sql.Add(SelSQL);
    Parameters.ParamByName('CityID').Value:=CityID;
    Parameters.ParamByName('kind').Value:=kind;
    open;
    first;
    while not eof do
    begin
       New(tempSysFun);
       tempSysFun.Code:=fieldbyname('code').AsInteger;
       tempSysFun.SetValue:=fieldbyname('setvalue').AsString;
       Result.Add(tempSysFun);
       next;
    end;
  end;
end;

function TFm_Main_Build_Server.GetWeekSendList(CitySN, Kind:integer):integer;//��ʼ��ÿ�����Ϲ���
var
  SelSQL : string;
  i:integer;
begin
  SelSQL:=' select distinct Content from alarm_sys_function_set where CityID=:CityID and kind=:kind order by Content';
  try
    with Dm_Collect_Local do
    with Ado_Dynamic, AlarmParam[CitySN], AlarmParam[CitySN].CityParam do
    begin
      close;
      sql.Clear;
      sql.Add(SelSQL);
      Parameters.ParamByName('CityID').Value:=CityID;
      Parameters.ParamByName('kind').Value:=Kind;
      open;
      if recordcount>0 then
         SetLength(SendDateList, Recordcount);
      first;  i:=0;
      while not eof do
      begin
         if fieldbyname('Content').AsInteger=1 then
            SendDateList[i].AllowSend:=false
         else
            SendDateList[i].AllowSend:=true;
         SendDateList[i].CsLevelCode:=fieldbyname('Content').AsInteger;
         SelSQL:=' select Content,setvalue from alarm_sys_function_set where CityID=:CityID and kind=:kind and Content=:Content order by setvalue ';
         if SendDateList[i].TimeList=nil then
           SendDateList[i].TimeList:=TStringList.Create;
         with Ado_Free do
         begin
            close;
            sql.Clear;
            sql.Add(SelSQL);
            Parameters.ParamByName('CityID').Value:=CityID;
            Parameters.ParamByName('kind').Value:=kind;
            Parameters.ParamByName('Content').Value:=SendDateList[i].CsLevelCode;
            open;
            first;
            while not eof do
            begin
              SendDateList[i].TimeList.Add(fieldbyname('setvalue').AsString);
              next;
            end;
         end;
         inc(i);
         next;
      end;
      Result:=recordcount;
    end;
  except
    Result:=-1;
  end;
end;

procedure TFm_Main_Build_Server.FreeTheList(FunList:TList);
var i:integer;
begin
   with FunList do
   begin
      For i:=Count-1 DownTo 0 do Delete(i);
      Free;
   end;
end;

function TFm_Main_Build_Server.OpenPublicDataSet(Kind:integer):Tlist;
var
  SelSQL : string;
  tempSysFun : TSysFunction;
begin
  Result:= TList.Create;
  SelSQL:='select code,setvalue from alarm_sys_function_set where kind=:kind order by code';
  with Dm_Collect_Local.Ado_Dynamic do
  begin
    close;
    sql.Clear;
    sql.Add(SelSQL);
    Parameters.ParamByName('kind').Value:=kind;
    open;
    first;
    while not eof do
    begin
       New(tempSysFun);
       tempSysFun.Code:=fieldbyname('code').AsInteger;
       tempSysFun.SetValue:=fieldbyname('setvalue').AsString;
       Result.Add(tempSysFun);
       next;
    end;
  end;
end;

procedure TFm_Main_Build_Server.InitPublicVariable();
var
   selsql:string;
   i:integer;
   FunList:TList;
   tempSysFun : TSysFunction;
begin
   with FunList do
   begin
      FunList:=OpenPublicDataSet(2);  //kind=2��Ϊʡ��ÿ��Ŀ�����ֹʱ��
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : Dm_Collect_Local.PublicParam.SA_StartTime:=tempSysFun.SetValue;  //code=1��Ϊ������ʼʱ��
          2 : Dm_Collect_Local.PublicParam.SA_EndTime:=tempSysFun.SetValue;    //code=2��Ϊ���Ͻ���ʱ��
         end;
      end;
      FreeTheList(FunList);

      SelSQL:='select content,setvalue from alarm_sys_public t where kind=3 order by code';
      with Dm_Collect_Local.Ado_Dynamic,Dm_Collect_Local.PublicParam do   //kind=3��Ϊʡ��ÿ��Ļ�վ�ȡ�������ʱ��
      begin
        close;
        sql.Clear;
        sql.Add(SelSQL);
        open; i:=0;
        setlength(CSExamTimeLimit,recordcount);
        first;
        while not eof do
        begin
           CSExamTimeLimit[i].CsLevel:=fieldbyname('Content').AsInteger;
           CSExamTimeLimit[i].LimitedHour:=fieldbyname('setvalue').AsInteger;
           next; inc(i);
        end;
      end;

      //��ʼ�����ϱ���ͳ�Ʋ���
      FunList:=OpenPublicDataSet(6);  //kind=6��Ϊ���ϱ���ͳ��ʱ��
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : Dm_Collect_Local.PublicParam.RepStatTime:=tempSysFun.SetValue;  //code=1��Ϊ���ϱ���ͳ��ʱ��
          2 : Dm_Collect_Local.PublicParam.IsAutoStatRep:=tempSysFun.SetValue;  //code=2���Ƿ��Զ�ͳ��
         end;
      end;
      FreeTheList(FunList);

      //������־���
      FunList:=OpenPublicDataSet(9);  //kind=9��Ϊ������־������ѡ��
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : Dm_Collect_Local.PublicParam.ClearLog_Time:=tempSysFun.SetValue;  //code=1��Ϊ���ʱ��
          2 : Dm_Collect_Local.PublicParam.ClearLog_Day:=tempSysFun.SetValue;    //code=2��Ϊ�������
          3 : Dm_Collect_Local.PublicParam.IsAutoClearLog:=tempSysFun.SetValue;  //code=3���Ƿ��Զ����
         end;
      end;
      FreeTheList(FunList);

      FunList:=OpenPublicDataSet(12); //kind=12���Ƿ��Զ�ͬ��POP��10000����
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : Dm_Collect_Local.PublicParam.IsAutoSynPOP:=tempSysFun.SetValue;   //code=1��POP��ͬ��
          2 : Dm_Collect_Local.PublicParam.IsAutoSyn10000:=tempSysFun.SetValue;   //code=2��10000��ͬ��
         end;
      end;

      FreeTheList(FunList);
   end;
end;

procedure TFm_Main_Build_Server.InitVariable();
var
  i,CitySN:integer;
  FunList:TList;
  tempSysFun : TSysFunction;
begin
  //FunList:=nil;
  with Dm_Collect_Local.Ado_Free, FunList, Dm_Collect_Local do
  begin
    close;
    sql.clear;
    //sql.Add('select id as cityid,name as cityname from pop_area where layer in (0,1) and id in ( select distinct cityid from alarm_sys_function_set )');
    sql.Add('select id as cityid,name as cityname from pop_area where top_id in (0,1) and id in ( select distinct cityid from alarm_sys_function_set )');
    open;
    setlength(AlarmParam,RecordCount);
    Dm_Collect_Local.Ado_Free.first;  CitySN:=0;
    while not eof do
    begin
      AlarmParam[CitySN].CityID:=fieldbyname('CityID').AsInteger;
      AlarmParam[CitySN].CityName:=fieldbyname('CityName').AsString;
      GetAlarmTest(AlarmParam[CitySN].TestIP,AlarmParam[CitySN].TestPort,fieldbyname('CityID').AsInteger);
      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,1);  //kind=1��Ϊ�ɼ�����
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : AlarmParam[CitySN].CityParam.Cs_Status_Str:=tempSysFun.SetValue;  //code=1��Ϊ��վ״̬
          2 : AlarmParam[CitySN].CityParam.Cs_Area_Str:=Get_CS_Area(AlarmParam[CitySN].CityID, strtoint(tempSysFun.SetValue));//code=2��Ϊ����������
          3 : AlarmParam[CitySN].CityParam.Cs_Power_Str:=tempSysFun.SetValue;   //code=3��Ϊ��վ���緽ʽ
         end;
      end;
      FreeTheList(FunList);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,2);  //kind=2��Ϊ���Ϲ���
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : AlarmParam[CitySN].CityParam.SA_StartTime:=tempSysFun.SetValue;  //code=1��Ϊ������ʼʱ��
          2 : AlarmParam[CitySN].CityParam.SA_EndTime:=tempSysFun.SetValue;    //code=2��Ϊ���Ͻ���ʱ��
         end;
      end;
      FreeTheList(FunList);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,5);  //kind=5��Ϊ���Ϲ���
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : if tempSysFun.SetValue='1' then
                 AlarmParam[CitySN].CityParam.IsAutoSend:=false  //code=1��Ϊ������ʽ,0Ϊ��ʱ���ϣ�1Ϊ��������
              else
                 AlarmParam[CitySN].CityParam.IsAutoSend:=true;
         end;
      end;
      FreeTheList(FunList);

      if not GetCsLevelList(CitySN) then
        application.MessageBox('��ʼ����վ�ȼ���Ϣʧ��,�����վ�ȼ���Ϣ������Ƿ�ȱʧ���޼�¼��','��ʾ',mb_ok+mb_defbutton1);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,8); //kind=8��ΪӦ�÷���������
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : if tempSysFun.SetValue='1' then IfAutoRun :=true else IfAutoRun :=false;   //code=1��Ϊ��ά��˾�ύ���Ƿ��Զ�����
         end;
      end;
      FreeTheList(FunList);

      //ÿ�����������б�
      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,14);  //kind=14��Ϊÿ��������������
      if FunList.Count>0 then
      begin
        SetLength(AlarmParam[CitySN].CityParam.WeekSendList, Count);
        for i:=0 to Count-1 do
        begin
          tempSysFun:=Items[i];
          AlarmParam[CitySN].CityParam.WeekSendList[i].Code:=tempSysFun.Code;
          if tempSysFun.SetValue='1' then
            AlarmParam[CitySN].CityParam.WeekSendList[i].SetValue:=true
          else
            AlarmParam[CitySN].CityParam.WeekSendList[i].SetValue:=false;
        end;
      end;
      FreeTheList(FunList);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,17);  //kind=17��Ϊ��Ԥ���Ϲ���
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];

         case tempSysFun.Code of
          1 :  if tempSysFun.SetValue ='' then
                 AlarmParam[CitySN].CityParam.ManualLimit:='0'
               else
                 AlarmParam[CitySN].CityParam.ManualLimit:=tempSysFun.SetValue;  //code=1��Ϊ��Ԥ����ʱ��
         end;
      end;
      FreeTheList(FunList);

      FunList:=OpenTheDataSet(AlarmParam[CitySN].CityID,19);  //kind=19 Ԥ������
      for i:=0 to Count-1 do
      begin
         tempSysFun:=Items[i];
         case tempSysFun.Code of
          1 : AlarmParam[CitySN].CityParam.WarnConent := tempSysFun.SetValue;
          2 : if tempSysFun.SetValue ='' then       //Ͻ��Ԥ���ٷֱ�
                AlarmParam[CitySN].CityParam.WarnCount := 100
              else
                AlarmParam[CitySN].CityParam.WarnCount := StrToInt(Trim(tempSysFun.SetValue));
          3 : if tempSysFun.SetValue ='' then       //CSCԤ���ٷֱ�
                AlarmParam[CitySN].CityParam.WarnCount_CSC := 100
              else
                AlarmParam[CitySN].CityParam.WarnCount_CSC := StrToInt(Trim(tempSysFun.SetValue));
         end;
      end;
      FreeTheList(FunList);

      //<�������������б�>
      if GetWeekSendList(CitySN,15)=-1 then
        application.MessageBox('��ʼ��<�������������б�>ʱ�����������Ϲ����н������ú���������Ӧ�÷���','��ʾ',mb_ok+mb_defbutton1);
      inc(CitySN);
      Dm_Collect_Local.Ado_Free.next;
    end;  //while not eof do
  end;
end;

function TFm_Main_Build_Server.Get_CS_Area(CityID, FilterKind:integer):string;
var
  SelSQL:string;
begin
  Result:='';
  SelSQL:='select AreaID from alarm_depart_witharea where CityID= :CityID and DeptID = :DeptID ';
  with Dm_Collect_Local.Ado_Dynamic do
  begin
    close;
    sql.Clear;
    sql.Add(SelSQL);
    Parameters.ParamByName('CityID').Value:=CityID;
    Parameters.ParamByName('DeptID').Value:=FilterKind;
    open;
    first;
    while not eof do
    begin
       Result:=Result+fieldbyname('AreaID').AsString+',';
       next;
    end;
    close;
  end;
  delete(Result,length(Result),1);
end;

procedure TFm_Main_Build_Server.FormShow(Sender: TObject);
begin
  SockConError :=0;
   Width:=860;
   Height:=600;
   left:=0;
   top:=0;
   FQueryCount:=0;
   FClientCount:=0;
   Dm_Collect_Local.Operator:='SYS';
   Status.Panels[1].Text:='ϵͳ���ڣ�'+datetimetostr(now);
   Status.Panels[0].Text :=Status.Panels[0].Text+' Bulid:'+GetFileTimeInfor(Application.ExeName,2);
   //���¿�ʼ��ʼ�����ϲ���
   //InitVariable();
end;

procedure TFm_Main_Build_Server.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if application.MessageBox('���Ҫ�˳�����վ���ϲɼ����ɷ�����ϵͳ����','��ʾ',mb_okcancel+mb_defbutton1)=idok then
   begin
        if findform('Fm_Collection_Data') then
        if not (Fm_Collection_Data.btCDMALX.Enabled
            and Fm_Collection_Data.btCDMART.Enabled
            and Fm_Collection_Data.Bt_DataCollect.Enabled
            and Fm_Collection_Data.Bt_AutoSend.Enabled)
        then
        begin
           application.MessageBox('�ڡ����ݲɼ����������������ݲɼ��߳������У���ȴ��������ݲɼ���ť����Ч��ֹͣ���вɼ����غ������˳���','��ʾ',mb_ok+mb_defbutton1);
           action:=canone;
           exit;
        end;
        if findform('Fm_FlowMonitor') then
        if not (Fm_FlowMonitor.Bt_FlowLog.Enabled
            and Fm_FlowMonitor.Bt_RepStat.Enabled
            and Fm_FlowMonitor.Bt_ItemCompute.Enabled
            and Fm_FlowMonitor.Bt_AlarmReSend.Enabled)
        then
        begin
           application.MessageBox('�ڡ���̨�����̹߳������������й����߳������У���ȴ�����ͳ�ư�ť����Ч��ȡ������У�Կ��ѡ��������˳���','��ʾ',mb_ok+mb_defbutton1);
           action:=canone;
           exit;
        end;

      if findform('Fm_Collection_Data') then
         Fm_Collection_Data.Close;
      if findform('Fm_FlowMonitor') then
         Fm_FlowMonitor.Close;

      if findform('Fm_RunLog') then
         Fm_RunLog.Close;

      action:=cafree ;
   end
   else
      action:=canone;
end;

procedure TFm_Main_Build_Server.Action_SystemExitExecute(Sender: TObject);
begin
   Close;
end;

procedure TFm_Main_Build_Server.Action_Collect_ServiceExecute(
  Sender: TObject);
begin
   if not Fm_Main_Build_Server.findform('Fm_Collection_Data') then
      Fm_Collection_Data:=tFm_Collection_Data.create(application);
end;

procedure TFm_Main_Build_Server.Action_RunLogExecute(Sender: TObject);
begin
   if not Fm_Main_Build_Server.findform('Fm_RunLog') then
      Fm_RunLog:=tFm_RunLog.create(application);
end;

function TFm_Main_Build_Server.Action_FirstLoginInit():boolean;
var
  IniFile : TIniFile;
  temForm : TFm_ServerSet;
begin
   iniFile:=nil;
   with ServiceInfo do
   try
     Result := false;
     iniFile := TIniFile.Create(ExtractFilePath(Application.ExeName)+'AlarmServiceInfo.ini');
     ServiceName := IniFile.ReadString('Server Config','DB_ServiceName','0');
     UserName := IniFile.ReadString('Server Config','DB_LoginName','0');
     Password := IniFile.ReadString('Server Config','DB_LoginPassword','0');
     ServerGUID :=IniFile.ReadString('Server Config','ServerGUID','{09AB7282-0FBA-4C16-81DC-B722CA94C7D1}');
     ServerIP := IniFile.ReadString('Server Config','SERVERIP','127.0.0.1');
     DBPort := StrToInt(IniFile.ReadString('Server Config','DBPort','0'));
     if (ServiceName = '0') or (UserName = '0') or (Password = '0') or (DBPort = 0) then
     begin
       temForm := TFm_ServerSet.Create(nil);
       try
          if temForm.ShowModal = mrOk then
          with temForm do
          begin
            ServiceName := Trim(Ed_ServiceName.Text);
            UserName := Trim(Ed_UserName.Text);
            Password := Trim(Ed_Password.Text);
            ServerGUID := Trim(Ed_ServerGUID.Text);
            ServerIP := Trim(Ed_IP.Text);
            DBPort := StrToInt(Trim(Ed_ComPort.Text));
            iniFile.WriteString('Server Config','DB_ServiceName', ServiceName);
            iniFile.WriteString('Server Config','DB_LoginName', UserName);
            iniFile.WriteString('Server Config','DB_LoginPassword', Password);
            iniFile.WriteString('Server Config','ServerGUID', ServerGUID);
            iniFile.WriteString('Server Config','SERVERIP', SERVERIP);
            iniFile.WriteString('Server Config','DBPort', IntToStr(DBPort));
            Result := true;
          end
          else
            Result := false;
       finally
          temForm.Free;
       end;
     end
     else
        Result := True;
     if not Result then exit;
     ConnectionString:='Provider=MSDAORA.1;Password='+Password+';User ID='+UserName+';Data Source='+ServiceName+';Persist Security Info=True;Extended Properties="PLSQLRSET=1"';
     status.Panels[2].Text:='ServiceName : '+ServiceName+'    User ID : '+UserName;
     DBName := UserName;
  finally
     iniFile.Free;
  end;    

end;

function TFm_Main_Build_Server.CheckUser: Boolean;
begin
  result := false;
  Fm_LoginWin.ShowModal;
  if Fm_LoginWin.Flag then
  begin
      result := true;
  end;
end;

procedure TFm_Main_Build_Server.Action_Flowtache_MonitorExecute(
  Sender: TObject);
begin
  if not Fm_Main_Build_Server.findform('Fm_FlowMonitor') then
      Fm_FlowMonitor:=TFm_FlowMonitor.create(application);
end;

procedure TFm_Main_Build_Server.Action_LockExecute(Sender: TObject);
begin
    Fm_LoginWin:=TFm_LoginWin.Create(self);
    Fm_LoginWin.edtUserName.Text := '';
    Fm_LoginWin.BorderStyle := bsNone;
    Fm_LoginWin.Bt_OK.Left := 137;
    Fm_LoginWin.Bt_Cancel.Visible := false;
    Fm_LoginWin.ShowModal;
end;

//��ȡ����IP���˿�
procedure TFm_Main_Build_Server.GetAlarmTest(var IP: String;
  var Port: integer; cityid: integer);
var
  SelSQL : string;
begin
  SelSQL:='select SetValue as IP,dicorder as Port from alarm_dic_code_info where ifineffect =1 and dictype = 25 and cityid=:cityid and diccode=1';
  with Dm_Collect_Local.Ado_Dynamic do
  begin
    close;
    sql.Clear;
    sql.Add(SelSQL);
    Parameters.ParamByName('CityID').Value:=CityID;
    open;
    if RecordCount > 0 then
    begin
      IP := FieldByName('IP').AsString;
      Port := FieldByName('Port').AsInteger;
    end;
    Close;
  end;
end;

function TFm_Main_Build_Server.GetCsLevelList(CitySN: integer): Boolean;
var
  SelSQL : string;
  i:integer;
begin
  result := false;
  SelSQL:=' select to_char(id) id, name, cityid from pop_cslevel where cityid = :cityid order by id ';
  with Dm_Collect_Local do
  //���������Ado_Free����Ϊ����GetTimeByLevel����Ado_Free�����������ͻ
  with Ado_Dynamic, AlarmParam[CitySN], AlarmParam[CitySN].CityParam do
  begin
    close;
    sql.Clear;
    sql.Add(SelSQL);
    Parameters.ParamByName('CityID').Value:=CityID;
    open;
    if recordcount= 0 then
    begin
      Close;
      Exit;
    end;
    SetLength(sendtimeList, Recordcount);
    first;  i := 0;
    while not eof do
    begin
      sendtimeList[i].AllowSend:=false;
      sendtimeList[i].CsLevelCode:=fieldbyname('id').AsInteger;
      sendtimeList[i].SA_StartTime := GetTimeByLevel(fieldbyname('id').AsInteger,CityID);
      sendtimeList[i].SA_EndTime :=  GetTimeByLevel(fieldbyname('id').AsInteger,CityID,false);
      if not IsAutoSend then
        sendtimeList[i].TimeList :=GetTimeListByLevel(cityid,fieldbyname('id').AsInteger);
      Next;
      Inc(i);
    end;
    result := true;
  end;
end;

function TFm_Main_Build_Server.GetTimeListByLevel(cityid,
  Level: integer): TStringList;
var
  SelSQL : string;
  TimeList :TStringList;
begin
  result := nil;
  try
    SelSQL:=' select a.setvalue from alarm_sys_function_set a where kind =7 and content =:content and cityid=:cityid ';
    with  Dm_Collect_Local.Ado_Temp do
    begin
      close;
      sql.Clear;
      sql.Add(SelSQL);
      Parameters.ParamByName('CityID').Value:=CityID;
      Parameters.ParamByName('content').Value:=Level;
      open;
      if RecordCount = 0 then
      begin
        Close;
        Exit;
      end;
      first;
      TimeList :=TStringList.Create;
      while not eof do
      begin
        TimeList.Add(fieldbyname('setvalue').AsString);
        Next;
      end;
      result := TimeList;
    end;
  except
    application.MessageBox(Pchar('��ȡ�ȼ�����Ϊ'+IntToStr(Level)+'������ʱ�̱�ʱ����,�������Ϲ����н������ú���������Ӧ�÷���!'),'��ʾ',mb_ok+mb_defbutton1);
  end;
end;

function TFm_Main_Build_Server.GetTimeByLevel(level, cityid: integer;
  IsSend: Boolean): String;
var
  SelSQL : string;
begin
   Result:= '';
   SelSQL:='select code,setvalue from alarm_sys_function_set where CityID=:CityID and kind=:kind and content =:content ';
   with Dm_Collect_Local.Ado_Temp do   //�����Ҫ��Ado_Dynamic��Ado_Free���������������ͻ
   begin
     close;
     sql.Clear;
     sql.Add(SelSQL);
     Parameters.ParamByName('CityID').Value:=CityID;
     if IsSend then
       Parameters.ParamByName('kind').Value:=20
     else
       Parameters.ParamByName('kind').Value:=21;
     Parameters.ParamByName('content').Value:=level;
     open;
     if RecordCount > 0 then
       result := FieldByName('setvalue').AsString;
   end;
end;

procedure TFm_Main_Build_Server.Button1Click(Sender: TObject);
begin
end;
//�̷߳���Ϣ����ýӿ�
procedure TFm_Main_Build_Server.WMThread_msg(var Msg: TMessage);
var
  Adata :PThreadData;
begin
  exit;
  //-----------------��ʱ������


  Adata := nil;
  if SockConError > 100 then
  begin
    if Fm_RunLog <> nil then
          Fm_RunLog.WriteMessageLog('�ɼ�Ӧ����������Ӧ��ʧ�ܣ�����scktsrvr.exe �Ƿ���������!');
    Exit;
  end;
  if Dm_Collect_Local.TempInterface = nil then  //����Ͽ�������
  try
    Dm_Collect_Local.Sc_Client.Connected := true;
    SockConError :=0;
  except
    Inc(SockConError);
  end;
  if Dm_Collect_Local.TempInterface <> nil then
  try
    try
      Adata := PThreadData(Msg.LParam);
    except
        On E:Exception do
        if Fm_RunLog <> nil then
          Fm_RunLog.WriteMessageLog('��ȡWMThread_msg �� Msg.LParam ʱ�����쳣��'+E.Message);
      end;
    case Adata.command of
      5,6,14,91,96,97 :
      try
        Dm_Collect_Local.TempInterface.CollectServerMsg(Adata.command,Adata.districtid,Adata.Msg);
      except
        On E:Exception do
        if Fm_RunLog <> nil then
          Fm_RunLog.WriteMessageLog('����CollectServerMsg�ӿ�ʱ�����쳣��'+E.Message);
      end;
    end;
  finally
    if Adata <> nil then  //�߳��������ڴ棬����ʹ�ù����ͷŵ�
      Dispose(Adata);
  end;
end;

procedure TFm_Main_Build_Server.WMStateThread_msg(var Msg: TMessage);
var
  Adata :PThreadData;
  districtid : integer;
begin
  exit;
  //------------------------------��ʱ������

  Adata := nil;
  if SockConError > 100 then
  begin
    SockConError :=0;
    if Fm_RunLog <> nil then
          Fm_RunLog.WriteMessageLog('�ɼ�Ӧ����������Ӧ��ʧ�ܣ�����scktsrvr.exe �Ƿ���������!');
    Exit;
  end;
  if Dm_Collect_Local.TempInterface = nil then  //����Ͽ�������
  try
    Dm_Collect_Local.Sc_Client.Connected := true;
  except
    Inc(SockConError);
  end;
  if Dm_Collect_Local.TempInterface <> nil then
  try
    try
      Adata := PThreadData(Msg.LParam);
    except
        On E:Exception do
        if Fm_RunLog <> nil then
          Fm_RunLog.WriteMessageLog('��ȡWMThread_msg �� Msg.LParam ʱ�����쳣��'+E.Message);
      end;
    case Adata.command of
      100:
        //��ȡͳ��Ͻ��
        begin
          try
            districtid := Dm_Collect_Local.TempInterface.GetStatDistrict;
          Except
           On E:Exception do
           begin
              if Fm_RunLog <> nil then
                Fm_RunLog.WriteMessageLog('����GetStatDistrict�ӿ�ʱ�����쳣��'+E.Message);
           end;
          End;  
        end;
    end;
  finally
    if Adata <> nil then
      Dispose(Adata);
  end;
end;

procedure TFm_Main_Build_Server.WMCDMA_msg(var Msg: TMessage);
begin
  Fm_Collection_Data.PassCDMAMes(Msg.LParam, Msg.WParam);  
end;

end.
