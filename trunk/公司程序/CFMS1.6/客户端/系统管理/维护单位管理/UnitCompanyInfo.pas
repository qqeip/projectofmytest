unit UnitCompanyInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitBaseShowModal, StdCtrls, cxLabel, cxControls, cxContainer,
  cxEdit, cxTextEdit, ExtCtrls;

type
  TFormCompanyInfo = class(TFormBaseShowModal)
    cxTextEditName: TcxTextEdit;
    cxTextEditAddr: TcxTextEdit;
    cxTextEditPhone: TcxTextEdit;
    cxTextEditFax: TcxTextEdit;
    cxTextEditLinkMan: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    Label1: TLabel;
  private

  public
    { Public declarations }
  end;

var
  FormCompanyInfo: TFormCompanyInfo;

implementation

{$R *.dfm}

end.
