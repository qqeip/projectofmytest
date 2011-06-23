unit UnitProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TFrmProgress = class(TForm)
    Label1: TLabel;
    pb1: TProgressBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmProgress: TFrmProgress;

implementation

{$R *.dfm}

end.
