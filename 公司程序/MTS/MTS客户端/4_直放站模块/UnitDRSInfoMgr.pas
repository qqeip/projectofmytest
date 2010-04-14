unit UnitDRSInfoMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, dxSkinsCore, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxLookAndFeelPainters, StdCtrls, cxContainer,
  cxGroupBox, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, ExtCtrls,
  DBClient,CxGridUnit, Menus, StringUtils, cxLabel;

type
  TFormDRSInfoMgr = class(TForm)
    lblDRS_ID: TLabel;
    lblDRS_Phone: TLabel;
    lblDRS_Name: TLabel;
    lblDRS_Addr: TLabel;
    lblDRS_SubURB: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    EdtCS: TEdit;
    Label19: TLabel;
    EdtALARMCOUNTS: TEdit;
    EdtUPDATETIME1: TEdit;
    EdtUPDATETIME3: TEdit;
    EdtMSC: TEdit;
    EdtPN: TEdit;
    EdtUPDATETIME2: TEdit;
    EdtLONGITUDE: TEdit;
    EdtR_DEVICEID: TEdit;
    EdtLATITUDE: TEdit;
    EdtBSC: TEdit;
    EdtCELL: TEdit;
    CbBDRSTYPE: TComboBox;
    CbBDRSMANU: TComboBox;
    CbBISPROGRAM: TComboBox;
    CbBSUBURB: TComboBox;
    CbBAGENTMANU: TComboBox;
    Label12: TLabel;
    EdtDRSSTATUS: TEdit;
    EdtDRSAddr: TEdit;
    CbBBUILDINGID: TComboBox;
    EdtDRSName: TEdit;
    EdtDRSPhone: TEdit;
    EdtDRSID: TEdit;
    Label20: TLabel;
    Label21: TLabel;
    EdtUPDATETIME4: TEdit;
    PanelInfo: TPanel;
    ButtonClear: TButton;
    ButtonAdd: TButton;
    ButtonChange: TButton;
    ButtonDelete: TButton;
    ButtonSave: TButton;
    ButtonCanel: TButton;
    Panel20: TPanel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel1: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure EdtDRSPhoneKeyPress(Sender: TObject; var Key: Char);
    procedure EdtDRSIDKeyPress(Sender: TObject; var Key: Char);
    procedure EdtR_DEVICEIDKeyPress(Sender: TObject; var Key: Char);

    procedure ButtonCanelClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonChangeClick(Sender: TObject);
    procedure ButtonDeleteClick(Sender: TObject);
    procedure CbBSUBURBChange(Sender: TObject);
    procedure CbBBUILDINGIDChange(Sender: TObject);
    procedure CbBISPROGRAMChange(Sender: TObject);
    procedure CbBDRSTYPEKeyPress(Sender: TObject; var Key: Char);
    procedure CbBDRSMANUKeyPress(Sender: TObject; var Key: Char);
    procedure CbBISPROGRAMKeyPress(Sender: TObject; var Key: Char);
    procedure CbBSUBURBKeyPress(Sender: TObject; var Key: Char);
    procedure CbBBUILDINGIDKeyPress(Sender: TObject; var Key: Char);
    procedure CbBAGENTMANUKeyPress(Sender: TObject; var Key: Char);
    procedure EdtDRSSTATUSKeyPress(Sender: TObject; var Key: Char);
    procedure EdtALARMCOUNTSKeyPress(Sender: TObject; var Key: Char);
    procedure EdtUPDATETIME3KeyPress(Sender: TObject; var Key: Char);
    procedure EdtUPDATETIME1KeyPress(Sender: TObject; var Key: Char);
    procedure EdtUPDATETIME2KeyPress(Sender: TObject; var Key: Char);
    procedure EdtUPDATETIME4KeyPress(Sender: TObject; var Key: Char);
    procedure EdtDRS_PhoneKeyPress(Sender: TObject; var Key: Char);
    procedure Edt_DRS_InfoKeyPress(Sender: TObject; var Key: Char);
    procedure CbBDRS_TYPEKeyPress(Sender: TObject; var Key: Char);
  private
   FConstruncting: boolean;   //过滤ITEMS自己引发的CHANGE
   gDrsID:Integer;
   FMenuAdd,FMenuChange,FMenuDelete: TMenuItem;
   FListSuburb,FListBuilding, FListDRSTYPE,
   FListAGENTMANU, FListDRSMANU : TStringList;


    { Private declarations }
  public
    ClientDataSet1: TClientDataSet;
    
    gIsInside: Boolean;
    gFlag:Integer;
    gIsOver: Boolean;
    gtempNum:string;
    gwhere: string;
    FCxGridHelper : TCxGridSet;
    procedure AddClickEvent(Sender: TObject);
    procedure ChangeClickEvent(Sender: TObject);
    procedure DeleteClickEvent(Sender: TObject);
    procedure UpDateClick(aPanel:TPanel);
    procedure EnableClick(aPanel:TPanel; aIsEnAble: Boolean);
    procedure InPutfloat(var key: Char);
    procedure InPutNum(var key: Char);
    procedure InPutChar(var key: Char);
    function JudgeChinese(aStr:string):Boolean;

    procedure DRSSelectChange;
    { Public declarations }
  end;

var
  FormDRSInfoMgr: TFormDRSInfoMgr;

implementation

uses MTS_Server_TLB, Ut_DataModule, Ut_Common, Ut_MainForm, UntCommandParam,UntDRSConfig;

{$R *.dfm}

procedure TFormDRSInfoMgr.AddClickEvent(Sender: TObject);
begin
    gFlag:=1;
    EnableClick(PanelInfo,True);
//    EdtDRSSTATUS.Enabled:=False;
//    EdtALARMCOUNTS.Enabled:=False;
//    EdtUPDATETIME1.Enabled:=False;
//    EdtUPDATETIME2.Enabled:=False;
//    EdtUPDATETIME3.Enabled:=False;
//    EdtUPDATETIME4.Enabled:=False;
//    ButtonSearch.Visible:=False;
    ButtonSave.Enabled :=True;
    ButtonCanel.Visible:=True;
    ButtonAdd.Enabled:=False;
    ButtonChange.Enabled:=False;
    ButtonDelete.Enabled:=False;
    if CbBISPROGRAM.Items.IndexOf('室外')>-1 then
    begin
      CbBBUILDINGID.Enabled:=False;
      CbBBUILDINGID.Text:='';
      gIsInside:=False;
    end
    else if CbBISPROGRAM.Items.IndexOf('室内')>-1 then         
    begin
      CbBBUILDINGID.Enabled:=True;
      CbBBUILDINGID.Text:='';
      gIsInside:=True;
    end;
//    if Trim(CbBISPROGRAM.Text)=Trim('室外') then
//        begin
//            CbBBUILDINGID.Enabled:=False;
//            CbBBUILDINGID.Text:='';
//            gIsInside:=False;
//        end
//    else
//        begin
//          CbBBUILDINGID.Enabled:=True;
//          CbBBUILDINGID.Text:='';
//           gIsInside:=True;
//        end;
//    EdtDRSAddr.Text:='';
//    EdtDRSAddr.Enabled:=True;
//    EdtDRSName.Text:='';
//    EdtDRSName.Enabled:=True;
//    EdtDRSPhone.Text:='';
//    EdtDRSPhone.Enabled:=True;
//    EdtDRSID.Text:='';
//    EdtDRSID.Enabled:=True;
//    EdtCS.Text:='';
//    EdtCS.Enabled:=True;
//    EdtALARMCOUNTS.Text:='0';
//    EdtUPDATETIME1.Text:='';
//    EdtUPDATETIME2.Text:='';
//    EdtUPDATETIME3.Text:='';
//    EdtUPDATETIME4.Text:='';
//    EdtMSC.Text:='';
//    EdtMSC.Enabled:=True;
//    EdtPN.Text:='';
//    EdtPN.Enabled:=True;
//    EdtLONGITUDE.Text:='';
//    EdtLONGITUDE.Enabled:=True;
//    EdtR_DEVICEID.Text:='';
//    EdtR_DEVICEID.Enabled:=True;
//    EdtLATITUDE.Text:='';
//    EdtLATITUDE.Enabled:=True;
//    EdtBSC.Text:='';
//    EdtBSC.Enabled:=True;
//    EdtCELL.Text:='';
//    EdtCELL.Enabled:=True;
//    EdtDRSSTATUS.Text:='未激活';
//    CbBDRSTYPE.Text:='';
//    CbBDRSTYPE.Enabled:=True;
//    CbBDRSMANU.Enabled:=True;
//    CbBDRSMANU.Text:='';
//    CbBAGENTMANU.Enabled:=True;
//    CbBAGENTMANU.Text:='';
//    CbBISPROGRAM.Enabled:=True;
//    CbBISPROGRAM.Text:='';
//    CbBSUBURB.Enabled:=True;
//    CbBSUBURB.Text:='';
//    CbBBUILDINGID.Enabled:=True;
//    CbBBUILDINGID.Text:='';
end;

procedure TFormDRSInfoMgr.ButtonAddClick(Sender: TObject);
begin
    AddClickEvent(Sender);
end;

procedure TFormDRSInfoMgr.ButtonCanelClick(Sender: TObject);
begin
    ButtonSave.Enabled:=False;
    ButtonCanel.Visible:=False;
    ButtonChange.Enabled:=True;
    ButtonDelete.Enabled:=True;
    ButtonAdd.Enabled:=True;
//    EnableClick(PanelInfo,False);
end;

procedure TFormDRSInfoMgr.ButtonChangeClick(Sender: TObject);
begin

 ChangeClickEvent(Sender);
// FrmDRSConfig.ShowDRSListData;
end;

procedure TFormDRSInfoMgr.ButtonClearClick(Sender: TObject);
begin
    UpDateClick(PanelInfo);
    EdtDRSSTATUS.Text:='未激活';
    EdtALARMCOUNTS.Text:='0';
end;

procedure TFormDRSInfoMgr.ButtonDeleteClick(Sender: TObject);
begin

    DeleteClickEvent(Sender);
    FrmDRSConfig.ShowDRSListData;
end;

procedure TFormDRSInfoMgr.ButtonSaveClick(Sender: TObject);
var
  LsqlStr:string;
  lMtuid: Integer;
  IsProgram:Integer;
  lVariant: variant;
  lsuccess: boolean;
  lClientSet,lClientSet2 : TClientDataSet;
  i:Integer;
begin
   lClientSet:= TClientDataSet.Create(nil);
   lSqlstr:='select * from DRS_Info_VIEW';
   with lClientSet do
   begin
      ProviderName:='DRS_Info';
      data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
   end;
   if EdtR_DEVICEID.Text='' then
     begin
        ShowMessage('设备编号不能为空');
        Exit;
     end;

   if EdtDRSID.Text='' then
   begin
      ShowMessage('直放站编号不能为空');
      Exit;
   end;
   if Length(EdtDRSID.Text)<>8 then
   begin
      ShowMessage('直放站的编号必须为8位！');
      Exit;
   end;
    if EdtDRSName.Text='' then
   begin
      ShowMessage('直放站名称不能为空');
      Exit;
   end;

   if CbBDRSTYPE.Text='' then
   begin
      ShowMessage('直放站类型未选择');
      Exit;
   end;
   if CbBISPROGRAM.Text='' then
   begin
      ShowMessage('请选择是否室内');
      Exit;
   end;
   if CbBSUBURB.Text='' then
   begin
      ShowMessage('请选择所属分局');
      Exit;
   end;

//   if CbBISPROGRAM.ItemIndex=0 then
//     if CbBBUILDINGID.Text='' then
//     begin
//        ShowMessage('请选择所属室分点');
//        Exit;
//     end;
   if gIsInside then
     if CbBBUILDINGID.Text='' then
     begin
        ShowMessage('请选择所属室分点');
        Exit;
     end;
   if EdtDRSAddr.Text='' then
   begin
      ShowMessage('地址不能为空');
      Exit;
   end;
   if EdtDRSPhone.Text='' then
     begin
        ShowMessage('电话号码不能为空');
        Exit;
     end;

   if JudgeChinese(EdtR_DEVICEID.Text) then
     begin
//      result:=true;
      ShowMessage('设备编号不能包含中文字符！');
      Exit;
     end;
   if JudgeChinese(EdtDRSID.Text) then
     begin
//      result:=true;
      ShowMessage('直放站编号不能包含中文字符！');
      Exit;
     end;
  if JudgeChinese(EdtDRSPhone.Text) then
     begin
//      result:=true;
      ShowMessage('电话号码不能包含中文字符！');
      Exit;
     end;
    if gFlag=1 then
      begin
         if lClientSet.Locate('R_DEVICEID;DRSNO',
            VarArrayOf([EdtR_DEVICEID.Text,EdtDRSID.Text]),[])  then
           begin
               ShowMessage('该直放站编号和设备编号的组合已存在');
               Exit;
           end;
        if lClientSet.Locate('DRSName',VarArrayOf([EdtDRSName.Text]),[]) and (gFlag=1)then
           begin
             ShowMessage('该直放站名称已存在');
             Exit;
           end;
        lClientSet2:=TClientDataSet.Create(nil);
        lSqlstr:='select CDMANO from CDMA_INFO';
        lClientSet2.ProviderName:='CDMA_INFO' ;
        lClientSet2.Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
        if lClientSet2.Locate('CDMANO', VarArrayOf([EdtDRSID.Text]),[]) then
          begin
              ShowMessage('直放站编号和CDMA信息管理页面的信源编号不能重复');
              Exit;
          end;
        lClientSet2:=TClientDataSet.Create(nil);
        lSqlstr:='select DRSPHONE,R_DEVICEID from drs_info_view';
        lClientSet2.ProviderName:='drs_info_phone' ;
        lClientSet2.Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
        if lClientSet2.Locate('DRSPHONE;R_DEVICEID', VarArrayOf([EdtDRSPhone.Text,EdtR_DEVICEID.Text]),[]) then
          begin
              ShowMessage('电话号码和设备编号的组合不能重复');
              Exit;
          end;
      end;
   if UpperCase(Trim(CbBISPROGRAM.Text))=UpperCase(Trim('室分')) then
         IsProgram:=1
   else
         IsProgram:=0;
   lVariant:= VarArrayCreate([0,3],varVariant);
   lVariant[0]:= VarArrayOf([2,4,13,'delete from  DRS_INFO where  1=2']);
   lVariant[1]:= VarArrayOf([2,4,13,'delete from  DRS_INFO where  1=2']);
   if gFlag=2 then
    begin

         if (Trim(ClientDataSet1.FieldByName('DRSPHONE').AsString)<>Trim(EdtDRSPhone.Text)) or
            (Trim(ClientDataSet1.FieldByName('DRSNO').AsString)<>Trim(EdtDRSID.Text))then
             begin
               if MessageDlg('号码/编号发生变化需要重新激活，是否继续？',mtInformation,[mbYes,mbNo],0)=mrYes then
                   begin
                    if StrToInt(ClientDataSet1.FieldByName('ALARMCOUNTS').AsString)>0 then
                      begin
                          LsqlStr:='delete from DRS_ALARM_ONLINE where DRSID in ('+
                                    'select DRSID from DRS_INFO where DRSNAME='+
                                    ''''+ClientDataSet1.FieldByName('DRSNAME').AsString+''')';
                         lVariant[0]:= VarArrayOf([2,4,13,LsqlStr]);   //删除告警
                      end
                    else
                      lVariant[0]:= VarArrayOf([2,4,13,'delete from  DRS_INFO where  1=2']);
                    //激活状态变更
                    LsqlStr:='update DRS_STATUSLIST set DRSSTATUS=1, ALARMCOUNTS=0 where DRSID='+
                                '(select DRSID from DRS_INFO where DRSNAME='+
                                ''''+ClientDataSet1.FieldByName('DRSNAME').AsString+''')';
                    lVariant[1]:= VarArrayOf([2,4,13,LsqlStr]);
                   end
               else
                 Exit;
             end;

         if (Trim(ClientDataSet1.FieldByName('DRSPHONE').AsString)<>Trim(EdtDRSPhone.Text))or
             (Trim(ClientDataSet1.FieldByName('R_DEVICEID').AsString)<>Trim(EdtR_DEVICEID.Text)) then
             begin
                lClientSet2:=TClientDataSet.Create(nil);
                lSqlstr:='select DRSPHONE,R_DEVICEID from drs_info_view';
                lClientSet2.ProviderName:='drs_info_phone' ;
                lClientSet2.Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
                if lClientSet2.Locate('DRSPHONE;R_DEVICEID', VarArrayOf([EdtDRSPhone.Text,StrToInt(EdtR_DEVICEID.Text)]),[]) then
                  begin
                      ShowMessage('电话号码和设备编号的组合不能重复');
                      Exit;
                  end;
             end;
        if Trim(ClientDataSet1.FieldByName('DRSNO').AsString)<>Trim(EdtDRSID.Text)then
            begin
               lClientSet2:=TClientDataSet.Create(nil);
               lSqlstr:='select CDMANO from CDMA_INFO';
               lClientSet2.ProviderName:='CDMA_INFO' ;
               lClientSet2.Data:=DM_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlstr]),0);
               if lClientSet2.Locate('CDMANO', VarArrayOf([EdtDRSID.Text]),[]) then
                 begin
                    ShowMessage('直放站编号和CDMA信息管理页面的信源编号不能重复');
                    Exit;
                 end;
            end;
         if Trim(ClientDataSet1.FieldByName('DRSName').AsString)<>Trim(EdtDRSName.Text)then
            if lClientSet.Locate('DRSName',VarArrayOf([EdtDRSName.Text]),[]) and (gFlag=1)then
               begin
                 ShowMessage('该直放站名称已存在');
                 Exit;
               end;
         if (Trim(ClientDataSet1.FieldByName('DRSNO').AsString)<>Trim(EdtDRSID.Text))or
             (Trim(ClientDataSet1.FieldByName('R_DEVICEID').AsString)<>Trim(EdtR_DEVICEID.Text)) then
            if lClientSet.Locate('R_DEVICEID;DRSNO',
                VarArrayOf([EdtR_DEVICEID.Text,EdtDRSID.Text]),[]) then
               begin
                   ShowMessage('该直放站编号和设备编号的组合已存在');
                   Exit;
               end;
    end;
   if gFlag=1 then   
     lMtuid:= DM_MTS.TempInterface.GetTheSequenceId('mtu_deviceid')
   else
     lMtuid:=gDrsID;

   if gFlag=2 then    //修改。。。
       LsqlStr:='delete from  DRS_INFO where DRSNAME='''+
                 ClientDataSet1.FieldByName('DRSNAME').AsString +''''
   else
       LsqlStr:='delete from  DRS_INFO where 1=2';
   if gFlag=1 then
      LsqlStr:='insert into drs_statuslist'+
                '(drsid, drsstatus, updatetime1, updatetime2, alarmcounts, updatetime3, updatetime4)'+
                'values'+
                '('+inttostr(lMtuid)+', 1, '''', '''', 0, '''', '''')';
   lVariant[2]:= VarArrayOf([2,4,13,LsqlStr]);
   LsqlStr:='insert into DRS_INFO values (' +
              inttostr(lMtuid)+','''+EdtDRSID.Text+''','+EdtR_DEVICEID.Text+
             ','''+EdtDRSName.Text+''','+
              inttostr(GetDicCode(CbBDRSTYPE.Text,CbBDRSTYPE.Items))+','+
              inttostr(GetDicCode(CbBDRSMANU.Text,CbBDRSMANU.Items))+','+
              inttostr(IsProgram)+','+
              inttostr(GetCaptionid(CbBSUBURB.Text,CbBSUBURB.Items))+','+
              inttostr(GetCaptionid(CbBBUILDINGID.Text,CbBBUILDINGID.Items))+','''+
              EdtCS.Text+''','''+EdtMSC.Text+''','''+EdtBSC.Text+''','''+EdtCELL.Text+''','''+
              EdtPN.Text+''','''+CbBAGENTMANU.Text+''','''+EdtLONGITUDE.Text+''','''+
              EdtLATITUDE.Text+''','''+EdtDRSAddr.Text+''','''+
              EdtDRSPhone.Text+''')';
   lVariant[3]:= VarArrayOf([2,4,13,LsqlStr]);
   //lVariant[1]:= VarArrayOf([2,4,13,LsqlStr]);
   lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
    begin
        ShowMessage('保存成功');
        FrmDRSConfig.ShowDRSListData;
       //需要重新刷新一下-------------------------------------///////-------------
    end
    else
      ShowMessage('保存失败');
    ButtonSave.Enabled :=False;
    ButtonCanel.Visible:=False;
    ButtonChange.Enabled:=True;
    ButtonDelete.Enabled:=True;
    ButtonAdd.Enabled:=True;
end;

procedure TFormDRSInfoMgr.CbBAGENTMANUKeyPress(Sender: TObject; var Key: Char);
begin
    key:=#0;
end;

procedure TFormDRSInfoMgr.CbBBUILDINGIDChange(Sender: TObject);
var
  lBuildingid: integer;
  lSuburbid: integer;
  I: Integer;
begin
  if FConstruncting then exit;
  //开始构造
  FConstruncting:= true;
  
  //还原分局为未选
  CbBSUBURB.ItemIndex:= -1;

  lBuildingid:= GetCaptionid(CbBBUILDINGID.Text,CbBBUILDINGID.Items);
  if lBuildingid>-1 then
  begin
    //根据室分点选择分局
    lSuburbid:= TFilterObject(CbBBUILDINGID.Items.Objects[CbBBUILDINGID.ItemIndex]).Suburbid;
    for I := 0 to CbBSUBURB.Items.Count - 1 do
    begin
      if TFilterObject(CbBSUBURB.Items.Objects[i]).Suburbid=lSuburbid  then
      begin
        CbBSUBURB.ItemIndex:= i;
        break;
      end;
    end;
    //根据室分点更新经纬度
    EdtLONGITUDE.Text:= TFilterObject(CbBBUILDINGID.Items.Objects[CbBBUILDINGID.ItemIndex]).Longitude;
    EdtLATITUDE.Text:= TFilterObject(CbBBUILDINGID.Items.Objects[CbBBUILDINGID.ItemIndex]).Latitude;
  end ;

  //结束构造
  FConstruncting:= false;
end;

procedure TFormDRSInfoMgr.CbBBUILDINGIDKeyPress(Sender: TObject; var Key: Char);
begin
    key:=#0;
end;

procedure TFormDRSInfoMgr.CbBDRSMANUKeyPress(Sender: TObject; var Key: Char);
begin
   key:=#0;
end;

procedure TFormDRSInfoMgr.CbBDRSTYPEKeyPress(Sender: TObject; var Key: Char);
begin
    key:=#0;
end;

procedure TFormDRSInfoMgr.CbBDRS_TYPEKeyPress(Sender: TObject; var Key: Char);
begin
     if not (key=#8) then
        key:=#0;
end;

procedure TFormDRSInfoMgr.CbBSUBURBChange(Sender: TObject);
var
  lSuburbid: integer;
begin
  if FConstruncting then exit;
  //开始构造
  FConstruncting:= true;

  //还原室分点为未选
  CbBBUILDINGID.ItemIndex:= -1;

  lSuburbid:= GetCaptionid(CbBSUBURB.Text,CbBSUBURB.Items);
  //更新室分点
  if lSuburbid>-1 then
  begin
    //这里会不会重复？？？？
    FilterList(FListBuilding,CbBBUILDINGID.Items,MTS_SUBURB,lSuburbid);
  end else
  begin
    FilterList(FListBuilding,CbBBUILDINGID.Items,-1,-1);

  end;
  //结束构造
  FConstruncting:= false;
end;

procedure TFormDRSInfoMgr.CbBSUBURBKeyPress(Sender: TObject; var Key: Char);
begin
    key:=#0;
end;

procedure TFormDRSInfoMgr.ChangeClickEvent(Sender: TObject);
begin

    if UntCommandParam.Current_DRSID=-1 then
    begin
      ShowMessage('请先选择一条记录');
      exit;
    end;
    gFlag:=2;
//    ButtonSearch.Visible:=False;
    ButtonSave.Enabled:=True;
    ButtonCanel.Visible:=True;
    ButtonAdd.Enabled:=False;
    ButtonChange.Enabled :=False;
    EnableClick(PanelInfo,True);
//    EdtDRSSTATUS.Enabled:=False;
//    EdtALARMCOUNTS.Enabled:=False;
//    EdtUPDATETIME1.Enabled:=False;
//    EdtUPDATETIME2.Enabled:=False;
//    EdtUPDATETIME3.Enabled:=False;
//    EdtUPDATETIME4.Enabled:=False;
    if Trim(CbBISPROGRAM.Text)=Trim('室外') then
        begin
            CbBBUILDINGID.Enabled:=False;
            CbBBUILDINGID.Text:='';
            gIsInside:=False;
        end
    else
        gIsInside:=True;

end;

procedure TFormDRSInfoMgr.DeleteClickEvent(Sender: TObject);
var
   LsqlStr: string;
   LclientDateSet: TClientDataSet;
   lVariant: Variant;
   lsuccess: Boolean;
begin
    if UntCommandParam.Current_DRSID=-1 then
    begin
      ShowMessage('请先选择一条记录');
      exit;
    end;
   if StrToInt(ClientDataSet1.FieldByName('ALARMCOUNTS').AsString)>0 then
     if MessageDlg('该直放站还存有告警，还要删除吗？',mtInformation,[mbYes,mbNo],0)=mrYes then
       begin
           lVariant:= VarArrayCreate([0,2],varVariant);
           LsqlStr:='delete from  DRS_STATUSLIST where DRSID in ('+
                      'select DRSID from DRS_INFO where DRSNAME='+
                      ''''+ClientDataSet1.FieldByName('DRSNAME').AsString+''')';
           lVariant[0]:= VarArrayOf([2,4,13,LsqlStr]);
           LsqlStr:='delete from DRS_ALARM_ONLINE where DRSID in ('+
                      'select DRSID from DRS_INFO where DRSNAME='+
                      ''''+ClientDataSet1.FieldByName('DRSNAME').AsString+''')';
           lVariant[1]:= VarArrayOf([2,4,13,LsqlStr]);          //删除告警
           LsqlStr:='delete from  DRS_INFO where DRSNAME='''+
                     ClientDataSet1.FieldByName('DRSNAME').AsString +'''';
           lVariant[2]:= VarArrayOf([2,4,13,LsqlStr]);
       end
     else
   else
     if MessageDlg('确认删除吗？',mtInformation,[mbYes,mbNo],0)=mrYes then
       begin
          lVariant:= VarArrayCreate([0,1],varVariant);
          LsqlStr:='delete from  DRS_STATUSLIST where DRSID in ('+
                      'select DRSID from DRS_INFO where DRSNAME='+
                      ''''+ClientDataSet1.FieldByName('DRSNAME').AsString+''')';
          lVariant[0]:= VarArrayOf([2,4,13,LsqlStr]);

          LsqlStr:='delete from  DRS_INFO where DRSNAME='''+
                    ClientDataSet1.FieldByName('DRSNAME').AsString +'''';
          lVariant[1]:= VarArrayOf([2,4,13,LsqlStr]);
       end;
   lsuccess:= Dm_MTS.TempInterface.ExecBatchSQL(lVariant);
    if lsuccess then
      begin
          ShowMessage('删除成功 ！');
          //刷新功能------------------------------------
      end
    else
       ShowMessage('删除失败 ！');
//   EnableClick(PanelInfo,False);
   UpDateClick(PanelInfo);
end;

procedure TFormDRSInfoMgr.DRSSelectChange;
begin
  if UntCommandParam.Current_DRSID=-1 then exit;

   ButtonSave.Enabled:=False;

    ButtonCanel.Visible:=False;
    ButtonChange.Enabled:=True;
    ButtonDelete.Enabled:=True;
    ButtonAdd.Enabled:=True;


    ButtonSave.Enabled:=False;
    ButtonCanel.Visible:=False;
    ButtonAdd.Enabled:=True;
    ButtonChange.Enabled:=True;
    ButtonDelete.Enabled:=True;

    gDrsID:=ClientDataSet1.FieldByName('DRSid').AsInteger;
    EdtDRSAddr.Text:=ClientDataSet1.FieldByName('DRSADRESS').AsString;
//    EdtDRSAddr.Enabled:=False;
    EdtDRSName.Text:=ClientDataSet1.FieldByName('DRSNAME').AsString;
//    EdtDRSName.Enabled:=False;
    EdtDRSPhone.Text:=ClientDataSet1.FieldByName('DRSPHONE').AsString;
//    EdtDRSPhone.Enabled:=False;
    EdtDRSID.Text:=ClientDataSet1.FieldByName('DRSNO').AsString;
//    EdtDRSID.Enabled:=False;
    EdtCS.Text:=ClientDataSet1.FieldByName('CS').AsString;
//    EdtCS.Enabled:=False;
    EdtALARMCOUNTS.Text:=ClientDataSet1.FieldByName('ALARMCOUNTS').AsString;
    EdtUPDATETIME1.Text:=ClientDataSet1.FieldByName('UPDATETIME1').AsString;
    EdtUPDATETIME2.Text:=ClientDataSet1.FieldByName('UPDATETIME2').AsString;
    EdtUPDATETIME3.Text:=ClientDataSet1.FieldByName('UPDATETIME3').AsString;
    EdtUPDATETIME4.Text:=ClientDataSet1.FieldByName('UPDATETIME4').AsString;
    EdtMSC.Text:=ClientDataSet1.FieldByName('MSC').AsString;
//    EdtMSC.Enabled:=False;
    EdtPN.Text:=ClientDataSet1.FieldByName('PN').AsString;
//    EdtPN.Enabled:=False;
    EdtLONGITUDE.Text:=ClientDataSet1.FieldByName('LONGITUDE').AsString;
//    EdtLONGITUDE.Enabled:=False;
    EdtR_DEVICEID.Text:=ClientDataSet1.FieldByName('R_DEVICEID').AsString;
//    EdtR_DEVICEID.Enabled:=False;
    EdtLATITUDE.Text:=ClientDataSet1.FieldByName('LATITUDE').AsString;
//    EdtLATITUDE.Enabled:=False;
    EdtBSC.Text:=ClientDataSet1.FieldByName('BSC').AsString;
//    EdtBSC.Enabled:=False;
    EdtCELL.Text:=ClientDataSet1.FieldByName('CELL').AsString;
//    EdtCELL.Enabled:=False;
    EdtDRSSTATUS.Text:=ClientDataSet1.FieldByName('DRSSTATUSName').AsString;
    CbBDRSTYPE.Text:=ClientDataSet1.FieldByName('DRSTYPEName').AsString;
//    CbBDRSTYPE.Enabled:=False;
//    CbBDRSMANU.Enabled:=False;
    CbBDRSMANU.Text:=ClientDataSet1.FieldByName('DRSMANUName').AsString;
//    CbBAGENTMANU.Enabled:=False;
    CbBAGENTMANU.Text:=ClientDataSet1.FieldByName('AGENTMANU').AsString;
//    CbBISPROGRAM.Enabled:=False;
    CbBISPROGRAM.Text:=ClientDataSet1.FieldByName('ISPROGRAMName').AsString;
//    CbBSUBURB.Enabled:=False;
    CbBSUBURB.Text:=ClientDataSet1.FieldByName('SUBURBName').AsString;
//    CbBBUILDINGID.Enabled:=False;
    CbBBUILDINGID.Text:=ClientDataSet1.FieldByName('buildingname').AsString;
end;

procedure TFormDRSInfoMgr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMenuAdd.Free;
  FMenuChange.Free;
  FMenuDelete.Free;
  FCxGridHelper.Free;
  ClearTStrings(FListDRSTYPE);
  ClearTStrings(FListSuburb);
  ClearTStrings(FListDRSMANU);
  ClearTStrings(FListBuilding);
  ClearTStrings(FListAGENTMANU);
  DestroyCBObj(CbBDRSTYPE);
  DestroyCBObj(CbBDRSMANU);
  DestroyCBObj(CbBSUBURB);
  DestroyCBObj(CbBBUILDINGID);
//  DestroyCBObj(CbBDRS_BUILDINGID);

  DestroyCBObj(CbBAGENTMANU);
  Fm_MainForm.DeleteTab(self);
  Action:=caFree;
  FormDRSInfoMgr:=nil;
end;

procedure TFormDRSInfoMgr.FormCreate(Sender: TObject);

begin
  gFlag:=0;
  gIsOver:=False;
  gtempNum:='';
  ClientDataSet1:=TClientDataSet.Create(nil);
//  ClientDataSet1.Open;
  FCxGridHelper:=TCxGridSet.Create;
  {FCxGridHelper.SetGridStyle(cxGrid1,false,false,true);
  FCxGridHelper.AppendMenuItem('-',nil);
  FMenuAdd:= FCxGridHelper.AppendMenuItem('新增',AddClickEvent);
  FMenuChange:= FCxGridHelper.AppendMenuItem('修改',ChangeClickEvent);
  FMenuDelete:= FCxGridHelper.AppendMenuItem('删除',DeleteClickEvent);}
  FListDRSTYPE:=TStringList.Create;
  FListSuburb:=TStringList.Create;
  FListBuilding:=TStringList.Create;
  FListDRSMANU:=TStringList.Create;
  FListAGENTMANU:=TStringList.Create;
end;

procedure TFormDRSInfoMgr.FormShow(Sender: TObject);
begin
    GetSuburbInfo(FListSuburb);
    GetBuildingInfo(FListBuilding);
//    FilterList(FListBuilding,CbBDRS_BUILDINGID.Items,-1,-1);    
    GetDic(51,CbBDRSTYPE.Items);
    GetDic(54,CbBDRSMANU.Items);
    GetDic(33,CbBAGENTMANU.Items);
    GetBuildingInfo(FListBuilding);
    FilterList(FListSuburb,CbBSUBURB.Items,-1,-1);
    FilterList(FListBuilding,CbBBUILDINGID.Items,-1,-1);
    //FilterList(CbBDRSTYPE.Items,CbBDRSTYPE.Items,-1,-1);
    //FilterList(CbBDRSMANU.Items,CbBDRSMANU.Items,-1,-1);
    //FilterList(CbBAGENTMANU.Items,CbBAGENTMANU.Items,-1,-1);  
end;

procedure TFormDRSInfoMgr.EdtALARMCOUNTSKeyPress(Sender: TObject;
  var Key: Char);
begin
      key:=#0;
end;

procedure TFormDRSInfoMgr.EdtDRSIDKeyPress(Sender: TObject; var Key: Char);
begin
//    try
//     InPutNum(key);
//     if not (key=#8) then
//       if Length(EdtDRSID.text)>3 then
//           Key:=#0;
//     except
//          ShowMessage('录入失败');
//          EdtDRSID.text:='';
//          Exit;
//    end ;
  InPutChar(key);
end;

procedure TFormDRSInfoMgr.EdtDRSPhoneKeyPress(Sender: TObject; var Key: Char);
begin
//     try
//       InPutNum(key);
//       if not (key=#8) then
//        if Length(EdtDRSPhone.text)>10 then
//             Key:=#0;
//      except
//          ShowMessage('录入失败');
//          EdtDRSPhone.text:='';
//          Exit;
//     end;
InPutNum(key);
end;

procedure TFormDRSInfoMgr.EdtDRSSTATUSKeyPress(Sender: TObject; var Key: Char);
begin
    key:=#0;
end;

procedure TFormDRSInfoMgr.Edt_DRS_InfoKeyPress(Sender: TObject; var Key: Char);
begin
//     InPutChar(key);
end;

procedure TFormDRSInfoMgr.EdtDRS_PhoneKeyPress(Sender: TObject; var Key: Char);
begin
    InPutNum(key);
end;

procedure TFormDRSInfoMgr.EdtR_DEVICEIDKeyPress(Sender: TObject; var Key: Char);
begin
//    try
//     InPutChar(key);
//     if not (key=#8) then
//       if Length(EdtR_DEVICEID.text)>0then
//        Key:=#0;
//    except
//          ShowMessage('录入失败');
//          EdtR_DEVICEID.text:='';
//          Exit;
//    end ;
InPutChar(key);
end;

procedure TFormDRSInfoMgr.EdtUPDATETIME1KeyPress(Sender: TObject;
  var Key: Char);
begin
        key:=#0;
end;

procedure TFormDRSInfoMgr.EdtUPDATETIME2KeyPress(Sender: TObject;
  var Key: Char);
begin
       key:=#0;
end;

procedure TFormDRSInfoMgr.EdtUPDATETIME3KeyPress(Sender: TObject;
  var Key: Char);
begin
       key:=#0;
end;

procedure TFormDRSInfoMgr.EdtUPDATETIME4KeyPress(Sender: TObject;
  var Key: Char);
begin
      key:=#0;
end;

procedure TFormDRSInfoMgr.EnableClick(aPanel: TPanel; aIsEnable: Boolean);
var
   i: Integer;
begin
 for i:=0 to aPanel.ControlCount-1 do
  begin
    if aPanel.Controls[i] is TEdit then
      TEdit(aPanel.Controls[i]).Enabled:=aIsEnable;
    if aPanel.Controls[i] is TComboBox then
       TComboBox(aPanel.Controls[i]).Enabled:=aIsEnable;
  end;

end;

procedure TFormDRSInfoMgr.UpDateClick(aPanel:TPanel);
var
   i: Integer;
begin
 for i:=0 to aPanel.ControlCount-1 do
  begin
    if aPanel.Controls[i] is TEdit then
      TEdit(aPanel.Controls[i]).Text:= '';
    if aPanel.Controls[i] is TComboBox then
      TComboBox(aPanel.Controls[i]).Text:= '';
  end;

end;

procedure TFormDRSInfoMgr.InPutfloat(var key: Char);
begin
  if not (key in ['0'..'9','.','-', #8,#13,#38,#40]) then
  begin
    Key := #0;
  end;
end;

procedure TFormDRSInfoMgr.InPutNum(var key: Char);
begin
  if not (key in ['0'..'9', #8,#13,#38,#40]) then
  begin
    Key := #0;
  end;
end;
function TFormDRSInfoMgr.JudgeChinese(aStr: string):Boolean;
var
  I : Integer;
begin
   Result:=False;
     for i:=0 to length(aStr) do
  begin
    if ByteType(aStr,i) = mbLeadByte then
    begin
//      result:=true;
//      ShowMessage('设备编号不能包含中文字符！');
      Result:=True;
    end;
  end;
end;

procedure TFormDRSInfoMgr.InPutChar(var key: Char);
begin
  if not (key in ['0'..'9','a'..'z','A'..'Z',#8,#13,#38,#40]) then
  begin
    Key := #0;
    Application.MessageBox(PChar('请输入八位十六进制数！'),PChar('提示'),48);
  end;
end;

procedure TFormDRSInfoMgr.CbBISPROGRAMChange(Sender: TObject);
begin
      if CbBISPROGRAM.ItemIndex<>1 then  //0室内   1   室外
        begin

            CbBBUILDINGID.Enabled:=True;
            cxLabel8.Visible :=True;
            CbBBUILDINGID.ItemIndex:= -1;
            gIsInside:=True;
        end
      else
        begin
           CbBBUILDINGID.Enabled:=False;
           cxLabel8.Visible :=False;
           CbBBUILDINGID.ItemIndex:= -1;
           gIsInside:=False;
        end;
end;

procedure TFormDRSInfoMgr.CbBISPROGRAMKeyPress(Sender: TObject; var Key: Char);
begin
    key:=#0;
end;

end.
