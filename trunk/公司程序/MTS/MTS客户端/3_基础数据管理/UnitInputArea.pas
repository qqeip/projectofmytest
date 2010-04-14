unit UnitInputArea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Ut_Common, ExtCtrls;

type
  TFormInputArea = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditAreaId: TEdit;
    EditAreaName: TEdit;
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    procedure EditAreaIdKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    FAreaID,FAreaName : string;
  end;

var
  FormInputArea: TFormInputArea;

implementation

{$R *.dfm}

procedure TFormInputArea.BitBtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormInputArea.BitBtnOKClick(Sender: TObject);
begin
  if (EditAreaId.Text='') or (EditAreaName.Text='')  then
  begin
    MessageBox(Handle, '请填写详细信息！', '提示', MB_OK + MB_ICONINFORMATION) ;
    Exit;
  end;
  FAreaID := EditAreaId.Text;
  FAreaName := EditAreaName.Text;
  ModalResult := mrOk;
end;

procedure TFormInputArea.EditAreaIdKeyPress(Sender: TObject; var Key: Char);
begin
  InPutNum(Key);
end;

end.
