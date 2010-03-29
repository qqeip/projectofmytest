unit UnitConfigDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, DB, ADODB, Menus;

const
    DBStrings = 'Provider=MSDAORA.1;Password=%s;User ID=%s;Data Source=%s;Persist Security Info=True';

type
  TFormConfigDB = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditDBName: TEdit;
    EditDBPass: TEdit;
    EditDBInstance: TEdit;
    GroupBox2: TGroupBox;
    CheckListBoxTables: TCheckListBox;
    BtnConnTest: TButton;
    BtnOK: TButton;
    BtnCancel: TButton;
    ADOConnection: TADOConnection;
    PopupMenu1: TPopupMenu;
    CheckAll: TMenuItem;
    CheckReverse: TMenuItem;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnConnTestClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure CheckAllClick(Sender: TObject);
    procedure CheckReverseClick(Sender: TObject);
  private
    { Private declarations }
    function GetDBName: string;
    function GetDBPass: string;
    function GetInstance: string;
    function GetExpTables: string;
    function GetTableName(aExpTables: string): TStrings;
  public
    { Public declarations }
    IsConnSucc: Boolean;
    procedure GetDBInfo;
    procedure SetDBInfo;
  published
    property DBName: string read GetDBName;
    property DBPass: string read GetDBPass;
    property DBInstance: string read GetInstance;
    property ExpTables:string read GetExpTables;
  end;

var
  FormConfigDB: TFormConfigDB;

implementation

uses UnitPublic;

{$R *.dfm}

procedure TFormConfigDB.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormConfigDB.FormShow(Sender: TObject);
begin
  GetDBInfo;
end;

procedure TFormConfigDB.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//  Action:= caFree;
//  FormConfigDB:= nil;
end;

procedure TFormConfigDB.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormConfigDB.BtnConnTestClick(Sender: TObject);
var fConnectionString: string;
    fADOquery: TADOQuery;
begin
  try
    if IsConnSucc then Exit;
    fConnectionString:=Format(DBStrings,[EditDBName.Text,EditDBPass.Text,EditDBInstance.Text]);
    ADOConnection.ConnectionString:= fConnectionString;
    ADOConnection.Connected:= False;
    ADOConnection.Connected:= True;
    IsConnSucc:= True;
    MessageBox(0,'测试成功','提示',MB_OK+64);
    fADOquery:= TADOQuery.Create(Self);
    with fADOquery do
    begin
      SQL.Clear;
      SQL.Text:='select table_name from cat where table_type=''TABLE''';
      Connection:= ADOConnection;
      Active:= False;
      Active:= True;
      if IsEmpty then Exit;
      First;
      while not Eof do
      begin
        CheckListBoxTables.Items.Add(fieldbyname('table_name').AsString);
        Next;
      end;
    end;
//    GetDBInfo;
  except
    MessageBox(0,'测试失败','提示',MB_OK+64);
  end;
end;

procedure TFormConfigDB.BtnOKClick(Sender: TObject);
begin
  SetDBInfo;
  BtnOKStatus:= True;
  ModalResult:= mrOk;
end;

procedure TFormConfigDB.BtnCancelClick(Sender: TObject);
begin
  BtnOKStatus := False;
  ModalResult:= mrCancel;
  close;
end;

function TFormConfigDB.GetDBName: string;
begin
  Result:= EditDBName.Text;
end;

function TFormConfigDB.GetDBPass: string;
begin
  Result:= EditDBPass.Text;
end;

function TFormConfigDB.GetInstance: string;
begin
  Result:= EditDBInstance.Text;
end;

function TFormConfigDB.GetExpTables: string;
var i: Integer;
    tempStr: string;
begin
  for i:=0 to CheckListBoxTables.Count-1 do
  begin
    if CheckListBoxTables.Checked[i] then
      tempStr:= tempStr + CheckListBoxTables.Items.Strings[i] + ',';
  end;
  Delete(tempStr,Length(tempStr),1);
  result:= tempStr;
end;

procedure TFormConfigDB.SetDBInfo;
begin
  fDBName:= DBName;
  fDBPass:= DBPass;
  fDBInstance:= DBInstance;
  fExpTables:= ExpTables;
end;

procedure TFormConfigDB.GetDBInfo;
var i, j: Integer;
  tempStrList: TStrings;
begin
  EditDBName.Text:= fDBName;
  EditDBPass.Text:= fDBPass;
  EditDBInstance.Text:= fDBInstance;
  if CheckListBoxTables.Count=0 then
    Exit;
  tempStrList:= TStringList.Create;
  tempStrList:= GetTableName(fExpTables);
  for i:=0 to tempStrList.Count-1 do
  begin
    for j:=0 to CheckListBoxTables.Count-1 do
    begin
      if CheckListBoxTables.Items.Strings[j]=tempStrList.Strings[i] then
        CheckListBoxTables.Checked[j]:= True;
    end;
  end;
end;

function TFormConfigDB.GetTableName(aExpTables: string):TStrings;
var I: Integer;
  TempStr: string;
begin
  Result:= TStringList.Create;
  while i<>0 do
  begin
    i:= Pos(',',aExpTables);
    TempStr:= Copy(aExpTables,0,i-1);
    Delete(aExpTables,1,i);
    if TempStr<>'' then
      Result.Add(TempStr);
  end;
  Result.Add(aExpTables);
end;

procedure TFormConfigDB.CheckAllClick(Sender: TObject);
var i: Integer;
begin
  for i:=0 to CheckListBoxTables.Count-1 do
  begin
    CheckListBoxTables.Checked[i]:=True;
  end;
end;

procedure TFormConfigDB.CheckReverseClick(Sender: TObject);
var i: Integer;
begin
  for i:=0 to CheckListBoxTables.Count-1 do
  begin
      CheckListBoxTables.Checked[i]:= not CheckListBoxTables.Checked[i];
  end;
end;

end.
