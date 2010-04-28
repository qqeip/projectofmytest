unit UnitDeviceGatherInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitBaseShowModal, StdCtrls, ExtCtrls, cxLabel, cxControls,
  cxContainer, cxEdit, cxTextEdit;

type
  TFormDeviceGatherInfo = class(TFormBaseShowModal)
    cxTextEditGatherName: TcxTextEdit;
    cxLabel1: TcxLabel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDeviceGatherInfo: TFormDeviceGatherInfo;

implementation

{$R *.dfm}

end.
