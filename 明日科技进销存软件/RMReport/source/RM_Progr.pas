
{*****************************************}
{                                         }
{         Report Machine v2.0             }
{             Progress dialog             }
{                                         }
{*****************************************}

unit RM_progr;

interface

{$I RM.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RM_Const, RM_Common;

type
  TRMProgressForm = class(TForm)
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FReport: TRMCustomReport;
  public
    FirstCaption: String;
    procedure Init(aReport: TRMCustomReport);
  end;

implementation

uses RM_Utils;

{$R *.DFM}

procedure TRMProgressForm.Init(aReport: TRMCustomReport);
begin
  FReport := aReport;
  Label2.Caption := '';
end;

procedure TRMProgressForm.btnCancelClick(Sender: TObject);
begin
  FReport.Terminated := True;
  ModalResult := mrCancel;
end;

procedure TRMProgressForm.FormCreate(Sender: TObject);
begin
	Font.Name := RMLoadStr(SRMDefaultFontName);
  Font.Size := StrToInt(RMLoadStr(SRMDefaultFontSize));
  Font.Charset := StrToInt(RMLoadStr(SCharset));

  btnCancel.Caption := RMLoadStr(SCancel);
end;

end.

