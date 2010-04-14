unit UnitAddAlarmInfo;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls;

type
  TFormAddAlarmInfo = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Label6: TLabel;
    Ed_Remark: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  FormAddAlarmInfo: TFormAddAlarmInfo;

implementation

{$R *.dfm}

procedure TFormAddAlarmInfo.Button1Click(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TFormAddAlarmInfo.Button2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
