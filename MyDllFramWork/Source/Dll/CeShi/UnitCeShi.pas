unit UnitCeShi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormCeShi = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCeShi: TFormCeShi;

implementation

uses UnitDllPublic;

{$R *.dfm}

procedure TFormCeShi.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDllCloseRecall(FormCeShi);
end;

end.












