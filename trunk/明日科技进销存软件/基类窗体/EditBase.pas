unit EditBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseForm, StdCtrls, ExtCtrls, jpeg, Buttons, DB, DBClient,
  SQLConst, ADODB;

type
  TFrmEditBase = class(TFrmBase)
    Panel1: TPanel;
    Image4: TImage;
    Btn_Post: TSpeedButton;
    Btn_Cancel: TSpeedButton;
    Panel2: TPanel;
    Image5: TImage;
    DataSourceEdit: TDataSource;
    ADOEdit: TADODataSet;
  private

  protected

  public

  end;

var
  FrmEditBase: TFrmEditBase;

implementation


{$R *.dfm}

{ TFrmEditBase }


end.
