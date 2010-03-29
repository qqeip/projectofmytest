unit BaseForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, StdCtrls,ShellAPI;

type
  TFrmBase = class(TForm)
    Top: TPanel;
    TopClient: TImage;
    TopLeft: TImage;
    TopRight: TImage;
    Bottom: TImage;
    Left: TImage;
    Right: TImage;
    PanelBack: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    LabTitle: TLabel;
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure TopLeftMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  protected

  public
    { Public declarations }
  end;
  
function FindForm(FormName:string):TForm;

var
  FrmBase: TFrmBase;

implementation

{$R *.dfm}

procedure TFrmBase.Image1Click(Sender: TObject);
begin
  Close;  
end;

procedure TFrmBase.Image2Click(Sender: TObject);
var
 abd:TAppBarData;
begin
  if WindowState = wsMaximized then
    WindowState := wsNormal
  else
  begin
    WindowState := wsMaximized;
    abd.cbSize:=sizeof(abd);
    SHAppBarMessage(ABM_GETTASKBARPOS,abd);
    Self.Height := Self.Height - (abd.rc.Bottom - abd.rc.Top);
  end;
end;

procedure TFrmBase.Image3Click(Sender: TObject);
begin
  postmessage(Self.Handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
end;

procedure TFrmBase.TopLeftMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=Mbleft then
  begin
    ReleaseCapture;
    Perform(WM_NCLBUTTONDOWN,HTCAPTION,0);
  end;
end;

procedure TFrmBase.FormShow(Sender: TObject);
begin
  LabTitle.Caption := Caption;
end;

function FindForm(FormName: string): TForm;
var
  i:Integer;
begin
  Result := nil;
  for i:=0 to Application.ComponentCount-1 do
  begin
    if Application.Components[i].Name = FormName then
    begin
      Result := TForm(Application.Components[i]);
      Break;      
    end;
  end;
end;

end.
