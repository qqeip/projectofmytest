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
    GroupBox1: TGroupBox;
    cxGridDepot: TcxGrid;
    cxGridDepotDBTableView1: TcxGridDBTableView;
    cxGridDepotLevel1: TcxGridLevel;
    Btn_Add: TSpeedButton;
    Btn_Modify: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Close: TSpeedButton;
    Btn_Print: TSpeedButton;
    Btn_Calc: TSpeedButton;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    LabelDepotID: TLabel;
    Label2: TLabel;
    LabelDepotName: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    EdtDepotName: TEdit;
    EdtDepotComment: TEdit;
    EdtDepotID: TEdit;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    Edit5: TEdit;
    Label8: TLabel;
    Edit6: TEdit;
    Label9: TLabel;
    Edit7: TEdit;
    Label10: TLabel;
    Edit8: TEdit;
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
    procedure EdtDepotIDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOutDepotMgr: TFormOutDepotMgr;

implementation

uses UnitMain;

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
  FormMain.RemoveForm(FormOutDepotMgr);
//  Action:= caFree;
end;

procedure TFormOutDepotMgr.FormDestroy(Sender: TObject);
begin
  FormOutDepotMgr:= nil;
end;

procedure TFormOutDepotMgr.Btn_AddClick(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.Btn_ModifyClick(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.Btn_DeleteClick(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.Btn_PrintClick(Sender: TObject);
begin
//
end;

procedure TFormOutDepotMgr.Btn_CalcClick(Sender: TObject);
begin
  winexec('calc.exe',sw_normal);
end;

procedure TFormOutDepotMgr.Btn_CloseClick(Sender: TObject);
begin
  FormMain.RemoveForm(FormOutDepotMgr);
end;

procedure TFormOutDepotMgr.EdtDepotIDKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
//
end;

end.
