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
  LabelVersion.Caption:= '版本号：' + sVersion;
  LabelDeveloper.Caption:= '开发人员：' + sDeveloper;
  LabelEmail.Caption:= '邮箱：' + sDeveloperEmail;
  LabelTelephone.Caption:= '电话号码：' + sDeveloperTelephone;
end;

procedure TFormAbout.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
