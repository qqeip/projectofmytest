unit Ut_ServerSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFm_ServerSet = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    IPanel: TPanel;
    L1: TLabel;
    L2: TLabel;
    L3: TLabel;
    L4: TLabel;
    IP1: TEdit;
    IP2: TEdit;
    IP4: TEdit;
    IP3: TEdit;
    Label1: TLabel;
    edtPort: TEdit;
    Label6: TLabel;
    DBPort: TEdit;
    procedure edtPortKeyPress(Sender: TObject; var Key: Char);
    procedure IP1KeyPress(Sender: TObject; var Key: Char);
    procedure IP2KeyPress(Sender: TObject; var Key: Char);
    procedure IP3KeyPress(Sender: TObject; var Key: Char);
    procedure IP4KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure dbIp1KeyPress(Sender: TObject; var Key: Char);
    procedure dbIp2KeyPress(Sender: TObject; var Key: Char);
    procedure dbIp3KeyPress(Sender: TObject; var Key: Char);
    procedure dbIp4KeyPress(Sender: TObject; var Key: Char);
    procedure DBPortKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    //只允许输入数字
    procedure InPutNum(var key : Char);
  public
    { Public declarations }
  end;

var
  Fm_ServerSet: TFm_ServerSet;

implementation

{$R *.dfm}

{ TForm1 }

procedure TFm_ServerSet.InPutNum(var key: Char);
begin
  if not (key  in ['0'..'9',#8]) then
  begin
    Key:=#0;
  end
end;

procedure TFm_ServerSet.edtPortKeyPress(Sender: TObject; var Key: Char);
begin
    InPutNum(key);
end;

procedure TFm_ServerSet.FormShow(Sender: TObject);
begin
  IP1.SetFocus;
end;

procedure TFm_ServerSet.IP1KeyPress(Sender: TObject; var Key: Char);
begin
    InPutNum(key);
end;

procedure TFm_ServerSet.IP2KeyPress(Sender: TObject; var Key: Char);
begin
    InPutNum(key);
end;

procedure TFm_ServerSet.IP3KeyPress(Sender: TObject; var Key: Char);
begin
  InPutNum(key);
end;

procedure TFm_ServerSet.IP4KeyPress(Sender: TObject; var Key: Char);
begin
    InPutNum(key);
end;

procedure TFm_ServerSet.Button1Click(Sender: TObject);
begin
    ModalResult := mrOK;
end;

procedure TFm_ServerSet.Button2Click(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TFm_ServerSet.dbIp1KeyPress(Sender: TObject; var Key: Char);
begin
    InPutNum(key);
end;

procedure TFm_ServerSet.dbIp2KeyPress(Sender: TObject; var Key: Char);
begin
 InPutNum(key);
end;

procedure TFm_ServerSet.dbIp3KeyPress(Sender: TObject; var Key: Char);
begin
 InPutNum(key);
end;

procedure TFm_ServerSet.dbIp4KeyPress(Sender: TObject; var Key: Char);
begin
 InPutNum(key);
end;

procedure TFm_ServerSet.DBPortKeyPress(Sender: TObject; var Key: Char);
begin
   InPutNum(key);
end;

end.
