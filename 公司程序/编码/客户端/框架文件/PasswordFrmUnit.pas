unit PasswordFrmUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TPasswordFrm = class(TForm)
    UserID: TSpeedButton;
    Label11: TLabel;
    Label1: TLabel;
    OldLable: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    UserName: TEdit;
    OldPSW: TEdit;
    NewPSW1: TEdit;
    NewPSW2: TEdit;
    OKB: TBitBtn;
    CancleB: TBitBtn;
    procedure CancleBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PasswordFrm: TPasswordFrm;

implementation

{$R *.DFM}

procedure TPasswordFrm.CancleBClick(Sender: TObject);
begin
  Close;
end;

procedure TPasswordFrm.FormCreate(Sender: TObject);
begin
  //
end;

procedure TPasswordFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //
end;

procedure TPasswordFrm.OKBClick(Sender: TObject);
begin
  ModalResult:=mrok;
end;

end.
