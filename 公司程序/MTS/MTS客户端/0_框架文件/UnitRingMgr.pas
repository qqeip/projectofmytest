{
  alarm_sys_function_set 响铃类型 1-MTU响铃 2-DRS响铃
}
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
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    ImageList1: TImageList;
    Image5: TImage;
    Panel4: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    CBAlarmType: TcxComboBox;
    cxBtnAlarmLevelOK: TcxButton;
    cxButton1: TcxButton;
    ComboBox1: TComboBox;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure cxBtnAlarmLevelOKClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CBAlarmTypePropertiesChange(Sender: TObject);
  private
    function IsExistRecord(aType, aKind: Integer): Boolean;
    procedure LoadRing;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormRingMgr: TFormRingMgr;

implementation

uses Ut_DataModule, Ut_MainForm;

{$R *.dfm}

procedure TFormRingMgr.FormCreate(Sender: TObject);
begin
  LoadRing;
end;

procedure TFormRingMgr.FormShow(Sender: TObject);
begin
//
end;

procedure TFormRingMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
  FormRingMgr:= nil;
end;

procedure TFormRingMgr.FormDestroy(Sender: TObject);
begin
// 
end;

procedure TFormRingMgr.cxBtnAlarmLevelOKClick(Sender: TObject);
var
  i, lType, lKind : Integer;
  lVariant : variant;
  lSqlStr : string;
  lIsSuccess : Boolean;
begin
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


  lKind := 2;
  lType:= CBAlarmType.ItemIndex+1;
  lVariant := VarArrayCreate([0,0],varVariant);
  if IsExistRecord(lType, lKind) then
    lSqlStr:= 'update ALARM_SYS_FUNCTION_SET set setvalue=''' + ComboBox1.text +
              ''' where code=' + IntToStr(lType) +
              ' and kind=' + IntToStr(lKind)
  else
    lSqlStr:= 'insert into ALARM_SYS_FUNCTION_SET(CODE,CONTENT,SETVALUE,KIND,KINDNOTE,CITYID) values(' +
              IntToStr(lType) + ',''' +
              '告警类型铃声设置' + ''',''' +
              ComboBox1.Text + ''',' +
              IntToStr(lKind) + ',''' +
              '告警类型铃声设置' + ''',' +
              IntToStr(Fm_MainForm.PublicParam.cityid) +')';
  lVariant[0]:= VarArrayOf([2,4,13,lSqlstr]);
  lIsSuccess:= dm_Mts.TempInterface.ExecBatchSQL(lVariant);
  if lIsSuccess then
  begin
    Application.MessageBox('<告警类型铃声设置>保存成功!','提示',mb_ok+64);
    cxBtnAlarmLevelOK.Enabled := False;
    ComboBox1.Enabled := False;
  end
  else
    Application.MessageBox('<告警类型铃声设置>保存失败!','提示',mb_ok+64);

end;

function TFormRingMgr.IsExistRecord(aType, aKind: Integer): Boolean;
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
                IntToStr(aType) +
                ' and kind=' +
                IntToStr(aKind);
      Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlStr]),0);
      if IsEmpty then
        result:= False
      else
        result:= True;
    end;
  finally
    lClientDataSet.Free;
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
  function GetRingFileName(aType, aKind, aCityID: Integer): string;
  var
    lSqlStr: string;
    lClientDataSet: TClientDataSet;
  begin
    Result:= '';
    lClientDataSet:= TClientDataSet.Create(nil);
    try
      with lClientDataSet do
      begin
        Close;
        lSqlStr:= 'select SETVALUE from ALARM_SYS_FUNCTION_SET where code='+
                      IntToStr(aType) +
                      ' and kind=' +
                      IntToStr(aKind) +
                      ' and cityid=' +
                      IntToStr(aCityID);
        Data:=Dm_MTS.TempInterface.GetCDSData(VarArrayOf([2,4,13,lSqlStr]),0);
        Result:= fieldbyname('SETVALUE').AsString;
      end;
    finally
      lClientDataSet.Free;
    end;
  end;
begin
  cxBtnAlarmLevelOK.Enabled := True;
  ComboBox1.Enabled := True;
  ComboBox1.ItemIndex:= ComboBox1.Items.IndexOf(GetRingFileName(CBAlarmType.ItemIndex+1,2,Fm_MainForm.PublicParam.cityid));
end;

end.
