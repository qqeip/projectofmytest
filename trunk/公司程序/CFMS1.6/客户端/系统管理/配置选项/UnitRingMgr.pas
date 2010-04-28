unit UnitRingMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, ComCtrls, Buttons, StdCtrls, cxSplitter,
  cxTreeView, cxControls, cxContainer, cxEdit, cxGroupBox, Menus,
  cxButtons, ImgList, DBClient, StringUtils, jpeg, ExtCtrls, mmsystem,
  cxGraphics, cxTextEdit, cxMaskEdit, cxDropDownEdit;

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
    cxGroupBox1: TcxGroupBox;
    cxTVAlarmLevel: TcxTreeView;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    Image5: TImage;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    cxBtnAlarmLevelOK: TcxButton;
    cxButton1: TcxButton;
    Panel4: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    Label3: TLabel;
    CBAlarmType: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cxTVAlarmLevelMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cxBtnAlarmLevelOKClick(Sender: TObject);
    procedure cxTVAlarmLevelChange(Sender: TObject; Node: TTreeNode);
    procedure cxTVAlarmLevelClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CBAlarmTypePropertiesChange(Sender: TObject);
  private
    procedure AddTreeViewNode(aTreeView: TcxTreeView; aID, aTOP_ID,
      aCITYID: Integer; aNAME, aAddr, aPhone, aFix, aLinkMan: string);
    procedure LoadAlarmLevel(aTreeView: TcxTreeView; aCityID: Integer);
    function IsExistRecord(aCode, aType, aKind: Integer): Boolean;
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
  LoadAlarmLevel(cxTVAlarmLevel,gPublicParam.cityid);
  GetDicItem(gPublicParam.cityid,35,CBAlarmType.Properties.Items);
  LoadRing;
end;

procedure TFormRingMgr.FormShow(Sender: TObject);
begin
//
end;

procedure TFormRingMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormRingMgr.FormDestroy(Sender: TObject);
begin
//  FormRingMgr:= nil;
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

procedure TFormRingMgr.cxBtnAlarmLevelOKClick(Sender: TObject);
var
  i, lCode, lType, lKind, lCount : Integer;
  lVariant : variant;
  lSqlStr : string;
  lIsSuccess : Boolean;
begin
  if GetSqlCount(cxTVAlarmLevel)=0 then
  begin
    Application.MessageBox('请先选择告警等级！','提示',MB_OK+64);
    Exit;
  end;
  if ComboBox1.Items.IndexOf(ComboBox1.Text) = -1 then
  begin
    Application.MessageBox('响铃音频文件不存在，请先选择响铃音频提示文件！','提示',MB_OK+64);
    Exit;
  end;
  if CBAlarmType.Properties.Items.IndexOf(CBAlarmType.Text)=-1 then
  begin
    Application.MessageBox('请先选择告警类型！','提示',MB_OK+64);
    Exit;
  end;


  lKind := 30;
  lType:= GetDicCode(CBAlarmType.Text,CBAlarmType.Properties.Items);
  lCount:=0;
  lVariant := VarArrayCreate([0,GetSqlCount(cxTVAlarmLevel)-1],varVariant);
//  lSqlStr := 'delete from ALARM_SYS_FUNCTION_SET where kind=30';
//  lVariant[0] := VarArrayOf([lSqlStr]);
  for i:=0 to cxTVAlarmLevel.Items.Count-1 do
  begin
    if (cxTVAlarmLevel.Items[i].ImageIndex=1) and (cxTVAlarmLevel.Items[i].Level<>0) then
    begin
      lCode := TWdInteger(cxTVAlarmLevel.Items[i].Data).Value;

      if IsExistRecord(lCode, lType, lKind) then
        lSqlStr:= 'update ALARM_SYS_FUNCTION_SET set setvalue=''' + ComboBox1.text +
                  ''' where code=' + IntToStr(lCode) +
                  ' and content=' + IntToStr(lType) +
                  ' and kind=' + IntToStr(lKind)
      else
        lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
                  IntToStr(lCode) + ',''' +
                  IntToStr(lType) + ''',''' +
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
    ComboBox1.Enabled := False;
  end
  else
    Application.MessageBox('<告警级别语音设置>保存失败!','提示',mb_ok+64);

end;

procedure TFormRingMgr.cxTVAlarmLevelChange(Sender: TObject;
  Node: TTreeNode);
begin
  cxBtnAlarmLevelOK.Enabled := True;
  ComboBox1.Enabled := True;
end;

procedure TFormRingMgr.cxTVAlarmLevelClick(Sender: TObject);
begin
  InitTree(cxTVAlarmLevel,30,gPublicParam.cityid);
end;

function TFormRingMgr.IsExistRecord(aCode, aType, aKind: Integer): Boolean;
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
                ' and content=' + IntToStr(aType) +
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
var i, lCode, lType: Integer;
  function GetSetValue(aCode, aType, aKind, aCityID : Integer): string;
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
                  ' and content=' + IntToStr(aType) +
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
  if (aTreeView=cxTVAlarmLevel) and (aTreeView.Selected.Level<>0) then
  begin
    if aTreeView.Selected=nil then Exit;
    lCode := TWdInteger(aTreeView.Selected.Data).Value;
    lType := GetDicCode(CBAlarmType.Text,CBAlarmType.Properties.Items);;
     ComboBox1.Text := GetSetValue(lCode, lType, aKind, aCityID);
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


procedure TFormRingMgr.cxButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormRingMgr.SpeedButton1Click(Sender: TObject);
begin
  sndPlaySound(PAnsiChar(ExtractFilePath(Application.ExeName)+'\Ring\'+ComboBox1.Text),
                  SND_NODEFAULT Or SND_ASYNC);
end;

procedure TFormRingMgr.CBAlarmTypePropertiesChange(Sender: TObject);
begin
  cxBtnAlarmLevelOK.Enabled := True;
  ComboBox1.Enabled := True;
end;

end.
