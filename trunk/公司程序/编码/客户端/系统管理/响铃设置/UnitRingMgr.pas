unit UnitRingMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, ComCtrls, Buttons, StdCtrls, cxSplitter,
  cxTreeView, cxControls, cxContainer, cxEdit, cxGroupBox, Menus, mmsystem,
  ImgList, cxButtons, jpeg, ExtCtrls ,
   DBClient, StringUtils;

type
  TCompanyObject= class
    ID: Integer ;
    Top_ID: Integer;
    Name: string;
    CITYID: Integer;
    Address:string;
    Phone:string;
    Fix:string;
    LinkMan:string;
end;

type
  TFormRingMgr = class(TForm)
    cxGBCompany: TcxGroupBox;
    cxTVCompany: TcxTreeView;
    cxSplitter1: TcxSplitter;
    cxGroupBox1: TcxGroupBox;
    cxTVAlarmLevel: TcxTreeView;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    cxGroupBox2: TcxGroupBox;
    cxBtnCompanyOK: TcxButton;
    Image5: TImage;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    cxBtnAlarmLevelOK: TcxButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    //procedure SBtnPathClick(Sender: TObject);
    procedure cxTVCompanyMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cxTVAlarmLevelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxBtnCompanyOKClick(Sender: TObject);
    procedure cxBtnAlarmLevelOKClick(Sender: TObject);
    procedure cxTVCompanyChange(Sender: TObject; Node: TTreeNode);
    procedure cxTVAlarmLevelChange(Sender: TObject; Node: TTreeNode);
    procedure cxTVAlarmLevelClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure LoadCompanyTree(aTreeView: TcxTreeView; aCityID: Integer);
    procedure AddTreeViewNode(aTreeView: TcxTreeView; aID, aTOP_ID,
      aCITYID: Integer; aNAME, aAddr, aPhone, aFix, aLinkMan: string);
    procedure LoadAlarmLevel(aTreeView: TcxTreeView; aCityID: Integer);
    function IsExistRecord(aCode, aKind: Integer): Boolean;
    function GetSqlCount(aAlarmLevelTree: TcxTreeView): Integer;
    procedure InitTree(aTreeView: TcxTreeView; aKind, aCityID: Integer);
    procedure LoadRing;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRingMgr: TFormRingMgr;

implementation

uses UnitDllCommon;

{$R *.dfm}

procedure TFormRingMgr.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormRingMgr.FormShow(Sender: TObject);
begin
  LoadCompanyTree(cxTVCompany,gPublicParam.CityID);
  LoadAlarmLevel(cxTVAlarmLevel,gPublicParam.cityid);
  InitTree(cxTVCompany,31,gPublicParam.cityid);
  LoadRing;
end;

procedure TFormRingMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  gDllMsgCall(FormRingMgr,1,'','');
end;

procedure TFormRingMgr.FormDestroy(Sender: TObject);
begin
//
end;

//procedure TFormRingMgr.SBtnPathClick(Sender: TObject);
//begin
  //if OpenDialog1.Execute then
 ///begin
    //EditPath.Text:= OpenDialog1.FileName;
  //end;
//end;

procedure TFormRingMgr.LoadCompanyTree(aTreeView: TcxTreeView; aCityID: Integer);
var
  lClientDataSet: TClientDataSet;
begin
  try
    lClientDataSet:= TClientDataSet.Create(nil);
    with lClientDataSet do
    begin
      Close;
      lClientDataSet.ProviderName:= 'DataSetProvider';
      Data:= gTempInterface.GetCDSData(VarArrayOf([1,10]),0);
      if IsEmpty then exit;
      First;
      while not Eof do
      begin
        AddTreeViewNode(aTreeView,
                        FieldByName('COMPANYID').AsInteger,
                        FieldByName('PARENTID').AsInteger,
                        FieldByName('CITYID').AsInteger,
                        FieldByName('COMPANYNAME').AsString,
                        FieldByName('Address').Asstring,
                        FieldByName('Phone').Asstring,
                        FieldByName('Fix').Asstring,
                        FieldByName('LinkMan').Asstring,
                        );
        Next;
      end;
    end;
    aTreeView.FullExpand;
  finally
    lClientDataSet.Free;
  end;
end;

procedure TFormRingMgr.AddTreeViewNode(aTreeView: TcxTreeView; aID,aTOP_ID,aCITYID:Integer;aNAME,aAddr,aPhone,aFix,aLinkMan:string);
var
  lObject: TCompanyObject;
  lNewNode,lParentNode : TTreeNode;
  function GetParentNode(aParent: Integer):TTreeNode;
  var
    lTempNode: TTreeNode;
  begin
    result:=nil;
//    if alevel=0 then Exit;
    with aTreeView.Items do
    begin
      lTempNode:= GetFirstNode;
      if lTempNode=nil then exit;
      while lTempNode<>nil do
      begin
        if TCompanyObject(lTempNode.Data).ID=aParent then
        begin
          result:=lTempNode;
          Break;
        end;
        lTempNode:=lTempNode.getNext;
      end;
    end;
  end;
begin
  lObject:= TCompanyObject.Create;
  lObject.ID:= aID;
  lObject.Top_ID := aTOP_ID;
  lObject.CITYID := aCITYID;
  lObject.Name   := aNAME;
  lObject.Address:= aAddr;
  lObject.Phone  := aPhone;
  lObject.Fix    := aFix;
  lObject.LinkMan:= aLinkMan;
  lParentNode:= GetParentNode(aTOP_ID);
  lNewNode:= aTreeView.Items.AddChildObject(lParentNode,lObject.Name,lObject);
end;

procedure TFormRingMgr.cxTVCompanyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cxTreeViewMouseDown(cxTVCompany,x,y);
end;

procedure TFormRingMgr.LoadAlarmLevel(aTreeView: TcxTreeView; aCityID: Integer);
var
  lClientDataSet: TClientDataSet;
  lWdInteger:TWdInteger;
  lTopNode, lTempNode: TTreeNode;
begin
  aTreeView.Items.Clear;
  lTopNode:= aTreeView.Items.Add(nil,'告警等级');
  lClientDataSet:= TClientDataSet.create(nil);
  with lClientDataSet do
  begin
    Close;
    ProviderName:='dsp_General_data';
    Data:=gTempInterface.GetCDSData(VarArrayOf([1,232,aCityID]),0);//1,231
    first;
    while not Eof do
    begin
      lWdInteger:=TWdInteger.create(FieldByName('ID').AsInteger);
      lTempNode:= aTreeView.Items.AddChildObject(lTopNode,fieldbyname('NAME').AsString,lWdInteger);
      lTempNode.ImageIndex:=0;
      lTempNode.SelectedIndex:=0;
      Next;
    end;
  end;
  aTreeView.FullExpand;
end;

procedure TFormRingMgr.cxTVAlarmLevelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  cxTreeViewMouseDown(cxTVAlarmLevel,x,y);
end;

procedure TFormRingMgr.cxBtnCompanyOKClick(Sender: TObject);
var
  lVariant : variant;
  lSqlStr : string;
  lIsSuccess : Boolean;
  i, lSetValue, lKind : Integer;
begin
  lVariant:= VarArrayCreate([0,cxTVCompany.Items.Count],varVariant);
  lKind:= 31; //维护单位是否告警语音提示
  lSqlStr:= 'delete ALARM_SYS_FUNCTION_SET where kind=31';
  lVariant[0]:= VarArrayOf([lSqlstr]);

  for i:=0 to cxTVCompany.Items.Count-1 do
  begin
    if cxTVCompany.Items[i].ImageIndex=0 then
      lSetValue := 0
    else
      lSetValue := 1;
    lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
              IntToStr(TCompanyObject(cxTVCompany.Items[i].Data).ID) + ',''' +
              '维护单位是否告警语音提示' + ''',''' +
              IntToStr(lSetValue) + ''',' +
              IntToStr(lKind) + ',''' +
              '维护单位是否告警语音提示' + ''',' +
              IntToStr(gPublicParam.cityid) +')';
    lVariant[i+1]:= VarArrayOf([lSqlstr]);
  end;

  lIsSuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lIsSuccess then
  begin
    Application.MessageBox('<维护单位是否告警语音提示>保存成功!','提示',mb_ok+64);
    cxBtnCompanyOK.Enabled:= False;
  end
  else
    Application.MessageBox('<维护单位是否告警语音提示>保存失败!','提示',mb_ok+64);
end;

procedure TFormRingMgr.cxBtnAlarmLevelOKClick(Sender: TObject);
var
  i, lCode, lKind, lCount : Integer;
  lVariant : variant;
  lSqlStr : string;
  lIsSuccess : Boolean;
begin
  if ComboBox1.Text = '' then
  begin
    Application.MessageBox('请先选择响铃提示音文件！','提示',MB_OK+64);
    Exit;
  end;

  lKind := 30;
  lCount:=0;
  lVariant := VarArrayCreate([0,GetSqlCount(cxTVAlarmLevel)-1],varVariant);
//  lSqlStr := 'delete from ALARM_SYS_FUNCTION_SET where kind=30';
//  lVariant[0] := VarArrayOf([lSqlStr]);
  for i:=0 to cxTVAlarmLevel.Items.Count-1 do
  begin
    if (cxTVAlarmLevel.Items[i].ImageIndex=1) and (cxTVAlarmLevel.Items[i].Level<>0) then
    begin
      lCode := TWdInteger(cxTVAlarmLevel.Items[i].Data).Value;

      if IsExistRecord(lCode,lKind) then
        lSqlStr:= 'update ALARM_SYS_FUNCTION_SET set setvalue=''' + ComboBox1.text +
                  ''' where code=' + IntToStr(lCode) +
                  ' and kind=' + IntToStr(lKind)
      else
        lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
                  IntToStr(lCode) + ',''' +
                  '告警级别语音设置' + ''',''' +
                  ComboBox1.Text + ''',' +
                  IntToStr(lKind) + ',''' +
                  '告警级别语音设置' + ''',' +
                  IntToStr(gPublicParam.cityid) +')';
      lVariant[lCount]:= VarArrayOf([lSqlstr]);
      inc(lcount);
    end;
  end;
  lIsSuccess:= gTempInterface.ExecBatchSQL(lVariant);
  if lIsSuccess then
  begin
    Application.MessageBox('<告警级别语音设置>保存成功!','提示',mb_ok+64);
    cxBtnAlarmLevelOK.Enabled := False;
  end
  else
    Application.MessageBox('<告警级别语音设置>保存失败!','提示',mb_ok+64);

end;

procedure TFormRingMgr.cxTVCompanyChange(Sender: TObject; Node: TTreeNode);
begin
  if (cxTVCompany.Selected=nil) then exit;
  cxBtnCompanyOK.Enabled := True;
end;

procedure TFormRingMgr.cxTVAlarmLevelChange(Sender: TObject;
  Node: TTreeNode);
begin
//  if (cxTVCompany.Selected=nil) then exit;
  cxBtnAlarmLevelOK.Enabled := True;
  ComboBox1.Enabled := True;
end;

procedure TFormRingMgr.cxTVAlarmLevelClick(Sender: TObject);
begin
  InitTree(cxTVAlarmLevel,30,gPublicParam.cityid);
end;

function TFormRingMgr.IsExistRecord(aCode, aKind: Integer): Boolean;
var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
begin
  lClientDataSet:= TClientDataSet.Create(nil);
  try
    with lClientDataSet do
    begin
      close;
      ProviderName:='dsp_General_data';
      lSqlStr:= 'select * from ALARM_SYS_FUNCTION_SET where code='+
                IntToStr(aCode) +
                ' and kind=' +
                IntToStr(aKind);
      Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
      if IsEmpty then
        result:= False
      else
        result:= True;
    end;
  finally
    lClientDataSet.Free;
  end;
end;

function TFormRingMgr.GetSqlCount(aAlarmLevelTree: TcxTreeView): Integer;
var i, j : Integer;
begin
  Result:=0;
  for i:=0 to aAlarmLevelTree.Items.Count-1 do
  begin
    if (aAlarmLevelTree.Items[i].ImageIndex=1) and (aAlarmLevelTree.Items[i].Level<>0) then
      Inc(Result);
  end;
end;

procedure TFormRingMgr.InitTree(aTreeView: TcxTreeView; aKind, aCityID: Integer);
var i, lCode: Integer;
  function GetSetValue(aCode, aKind, aCityID : Integer): string;
  var
  lClientDataSet: TClientDataSet;
  lSqlStr: string;
  begin
    lClientDataSet:= TClientDataSet.Create(nil);
    try
      with lClientDataSet do
      begin
        close;
        ProviderName:='dsp_General_data';
        lSqlStr:= 'select SETVALUE from ALARM_SYS_FUNCTION_SET where code='+
                  IntToStr(aCode) +
                  ' and kind=' +
                  IntToStr(aKind) +
                  ' and cityid=' +
                  IntToStr(aCityID);
        Data:=gTempInterface.GetCDSData(VarArrayOf([102,1,lSqlStr]),0);
        Result:= fieldbyname('SETVALUE').AsString;
      end;
    finally
      lClientDataSet.Free;
    end;
  end;
begin
  if (aTreeView=cxTVCompany) then
    for i:=aTreeView.Items.Count-1 downto 0 do
    begin
      lCode := TCompanyObject(aTreeView.Items[i].Data).ID;
      if GetSetValue(lCode, aKind, aCityID)='1' then
        aTreeView.Items[i].ImageIndex := 1
      else
        aTreeView.Items[i].ImageIndex := 0;
    end
    else if (aTreeView=cxTVAlarmLevel) and (aTreeView.Selected.Level<>0) then
    begin
      if aTreeView.Selected=nil then Exit;
      lCode := TWdInteger(aTreeView.Selected.Data).Value;
       ComboBox1.Text := GetSetValue(lCode, aKind, aCityID);
    end;
end;

procedure TFormRingMgr.LoadRing();
var
  sr: TSearchRec;
  i : integer;
begin
  //在指定文件夹中查询*.wav文件
  ComboBox1.Items.Clear;
  i:= FindFirst(ExtractFilePath(Application.ExeName)+'\Ring\*.wav',faAnyFile,sr);
  while i=0 do
  begin
    if sr.Name[1] <> '.' then //如果文件名不为"."或".."
    begin
      ComboBox1.Items.Add(sr.Name);
    end;
    {* 查找下一个文件}
    i := FindNext(sr);
  end;
  FindClose(sr);
end;


procedure TFormRingMgr.Button1Click(Sender: TObject);
begin
  sndPlaySound(PAnsiChar(ExtractFilePath(Application.ExeName)+'\Ring\'+ComboBox1.Text),
                  SND_NODEFAULT Or SND_ASYNC Or SND_LOOP);
end;

end.
