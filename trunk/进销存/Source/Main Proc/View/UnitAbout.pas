unit UnitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg;

type
  TFormAbout = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Image1: TImage;
    LabelVersion: TLabel;
    LabelDeveloper: TLabel;
    LabelEmail: TLabel;
    LabelTelephone: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

uses UnitResource;

{$R *.dfm}

procedure TFormAbout.FormCreate(Sender: TObject);
begin
  LabelVersion.Caption:= '�汾�ţ�' + sVersion;
  LabelDeveloper.Caption:= '������Ա��' + sDeveloper;
  LabelEmail.Caption:= '���䣺' + sDeveloperEmail;
  LabelTelephone.Caption:= '�绰���룺' + sDeveloperTelephone;
end;

procedure TFormAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
