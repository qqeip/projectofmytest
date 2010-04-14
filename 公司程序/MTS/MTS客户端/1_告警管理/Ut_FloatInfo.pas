unit Ut_FloatInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit;
type
  TFloatInfo = record
    Field :String;
    Value :String;
  end;
  TFloatArray = Array of TFloatInfo;
type
  TFm_FloatInfo = class(TForm)
    VL: TValueListEditor;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetFloatInfo(A : TFloatArray);
    { Public declarations }
  end;

var
  Fm_FloatInfo: TFm_FloatInfo;

implementation

{$R *.dfm}

{ TFm_FloatInfo }

procedure TFm_FloatInfo.SetFloatInfo(A: TFloatArray);
var
  i : integer;
begin
  VL.Strings.Clear;
  self.ClientHeight:= 40+High(A)*20;
  for i := Low(A) to High(A) do
    VL.InsertRow(A[i].Field,A[i].Value,true);
  self.Visible := true;
end;

procedure TFm_FloatInfo.FormShow(Sender: TObject);
begin
   self.Top :=0;
   self.Left := self.Parent.ClientWidth-self.ClientWidth;
end;

end.
