unit LinkPersonEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EditBase, DB, ADODB, Buttons, StdCtrls, ExtCtrls, jpeg, Mask,
  DBCtrls;

type
  TFrmLinkPersonEdit = class(TFrmEditBase)
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBMemo1: TDBMemo;
    procedure Btn_PostClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLinkPersonEdit: TFrmLinkPersonEdit;

implementation

uses DataModu;



{$R *.dfm}

procedure TFrmLinkPersonEdit.Btn_PostClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrOk;
end;

procedure TFrmLinkPersonEdit.Btn_CancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
