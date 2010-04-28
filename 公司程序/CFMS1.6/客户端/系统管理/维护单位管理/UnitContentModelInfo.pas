unit UnitContentModelInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitBaseShowModal, StdCtrls, ExtCtrls, cxLabel, cxControls,
  cxContainer, cxEdit, cxTextEdit;

type
  TFormContentModelInfo = class(TFormBaseShowModal)
    cxTextEditModelName: TcxTextEdit;
    cxLabel1: TcxLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormContentModelInfo: TFormContentModelInfo;

implementation

{$R *.dfm}

end.
