unit FrmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,ExtCtrls,inifiles, WinSkinData;

type
  TFormLogin = class(TForm)
    PanelLogin: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    ImageLogo: TImage;
    LabelTitle: TLabel;
    ExitB: TBitBtn;
    LoginB: TBitBtn;
    EditPassword: TEdit;
    EditUserName: TComboBox;
    PanelFlash: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Image3: TImage;
    TipInfo: TLabel;
    Image4: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Image5: TImage;
    Image2: TImage;
    LabelVer: TLabel;
    procedure LoginBClick(Sender: TObject);
    procedure ExitBClick(Sender: TObject);
    procedure UserNameKeyPress(Sender: TObject; var Key: Char);
    procedure EditPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure EditUserNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ResponseEnterKey(aFormHandle: THandle; aKey: word);
    { Private declarations }
  public
    procedure LoadUser;
    procedure SaveUser(UserNo:string);
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.dfm}


procedure TFormLogin.LoginBClick(Sender: TObject);
begin
  if (Trim(EditUserName.Text)='') then
  begin
    MessageDLG('用户名不能为空！',mtWarning,[mbOK],0);
    exit;
  end;
  ModalResult:=mrOK;
end;


procedure TFormLogin.ExitBClick(Sender: TObject);
begin
  ModalResult:=mrcancel;
end;

procedure TFormLogin.UserNameKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    EditPassword.SetFocus;
end;

procedure TFormLogin.EditPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    LoginBClick(nil);
end;

procedure TFormLogin.FormDestroy(Sender: TObject);
begin
//
end;

procedure TFormLogin.LoadUser;
var
  linifile : Tinifile ;
  lFileName:string;
  lStringList:TStringList;
  i:integer;
begin
  lFileName :=ExtractFileDir(application.ExeName)+'\'+ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');

  linifile := Tinifile.Create(lFileName);
  lStringList:=TStringList.Create;
  try
    linifile.ReadSectionValues('LoginUser',lStringList);
    for i:=0 to lStringList.Count-1 do
      EditUserName.Items.Add( lStringList.Values['User'+IntToStr(i+1)]);
   //
    EditUserName.Text:= linifile.ReadString('LastLogin','UserNo','')
  finally
    linifile.Free;
    lStringList.Free;
  end;
end;

procedure TFormLogin.SaveUser(UserNo:string);
var
  linifile : Tinifile ;
  lFileName:string;
  lStringList:TStringList;
  i:integer;
  lFlag:boolean;
begin
  lFileName :=ExtractFileDir(application.ExeName)+'\'+ChangeFileExt(ExtractFileName(Application.ExeName), '.ini');

  linifile := Tinifile.Create(lFileName);
  lStringList:=TStringList.Create;
  try
    linifile.ReadSectionValues('LoginUser',lStringList);
    lFlag:=false;
    for i:=0 to lStringList.Count-1 do
    begin
      if lStringList.Values['User'+IntToStr(i+1)]=UserNo then
        lFlag:=true;
    end;
    if not lFlag then
    begin
      if lStringList.IndexOf(UserNo)<0 then
      begin
        linifile.WriteString('LoginUser','User'+IntToStr(lStringList.Count+1),UserNo);
      end;
    end;
    linifile.WriteString('LastLogin','UserNo',UserNo);
  finally
    linifile.Free;
    lStringList.Free;
  end;

end;

procedure TFormLogin.ResponseEnterKey(aFormHandle:THandle; aKey:word);
begin
  if aKey=VK_RETURN then
    PostMessage(aFormHandle,WM_KEYDOWN,VK_TAB,0);
end;

procedure TFormLogin.EditUserNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ResponseEnterKey(self.Handle,Key);
end;

procedure TFormLogin.EditPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ResponseEnterKey(self.Handle,Key);
end;

procedure TFormLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormLogin.Hide;
  //
end;

end.
