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
    Label1: TLabel;
    Ed_ComPort: TEdit;
    Ed_ServiceName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Ed_UserName: TEdit;
    Label4: TLabel;
    Ed_Password: TEdit;
    Label5: TLabel;
    Ed_IP: TEdit;
    Label6: TLabel;
    Ed_ServerGUID: TEdit;
    procedure Ed_ComPortKeyPress(Sender: TObject; var Key: Char);

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TFm_ServerSet.Ed_ComPortKeyPress(Sender: TObject; var Key: Char);
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


procedure TFm_ServerSet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   action:=cafree
end;

procedure TFm_ServerSet.FormShow(Sender: TObject);
begin
   Ed_ServiceName.SetFocus;
end;

end.
