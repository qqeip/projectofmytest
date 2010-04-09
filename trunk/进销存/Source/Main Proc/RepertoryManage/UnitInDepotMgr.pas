unit UnitInDepotMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, StdCtrls, Buttons, ExtCtrls;

type
  TFormInDepotMgr = class(TForm)
    Panel1: TPanel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    EdtDepotComment: TEdit;
    GroupBox1: TGroupBox;
    cxGridDepot: TcxGrid;
    cxGridDepotDBTableView1: TcxGridDBTableView;
    cxGridDepotLevel1: TcxGridLevel;
    Label1: TLabel;
    CBAssociatorType: TComboBox;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Btn_Print: TSpeedButton;
    Btn_Calc: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Btn_ModifyClick(Sender: TObject);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_PrintClick(Sender: TObject);
    procedure Btn_CalcClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormInDepotMgr: TFormInDepotMgr;

implementation

uses UnitMain;

{$R *.dfm}

procedure TFormInDepotMgr.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormInDepotMgr.FormShow(Sender: TObject);
begin
//
end;

procedure TFormInDepotMgr.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FormMain.RemoveForm(FormInDepotMgr);
  Action:= caFree;
end;

procedure TFormInDepotMgr.FormDestroy(Sender: TObject);
begin
  FormInDepotMgr:= nil;
end;

procedure TFormInDepotMgr.Btn_AddClick(Sender: TObject);
begin
//
end;

procedure TFormInDepotMgr.Btn_ModifyClick(Sender: TObject);
begin
//
end;

procedure TFormInDepotMgr.Btn_DeleteClick(Sender: TObject);
begin
//
end;

procedure TFormInDepotMgr.Btn_PrintClick(Sender: TObject);
begin
//
end;

procedure TFormInDepotMgr.Btn_CalcClick(Sender: TObject);
begin
  winexec('calc.exe',sw_normal);
end;

procedure TFormInDepotMgr.Btn_CloseClick(Sender: TObject);
begin
  Close;
end;

end.
