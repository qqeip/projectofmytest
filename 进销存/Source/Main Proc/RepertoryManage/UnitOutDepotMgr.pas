unit UnitOutDepotMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls;

type
  TFormOutDepotMgr = class(TForm)
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    LabelDepotID: TLabel;
    Label2: TLabel;
    LabelDepotName: TLabel;
    EdtDepotName: TEdit;
    EdtDepotComment: TEdit;
    EdtDepotID: TEdit;
    GroupBox1: TGroupBox;
    cxGridDepot: TcxGrid;
    cxGridDepotDBTableView1: TcxGridDBTableView;
    cxGridDepotLevel1: TcxGridLevel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOutDepotMgr: TFormOutDepotMgr;

implementation

{$R *.dfm}

procedure TFormOutDepotMgr.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.FormShow(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFormOutDepotMgr.FormDestroy(Sender: TObject);
begin
  FormOutDepotMgr:= nil;
end;

end.
