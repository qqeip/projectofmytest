unit UnitParamConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, DBClient, ComCtrls, StdCtrls, ImgList,
  ExtCtrls, cxLookAndFeelPainters, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, cxDBData, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxContainer, cxGroupBox, cxPC,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar;

type
  TFormParamConfig = class(TForm)
    cxGroupBox_DRS: TcxGroupBox;
    cxGrid_DRS: TcxGrid;
    cxGrid_DRSDBTV_DRS: TcxGridDBTableView;
    cxGrid_DRSLevel: TcxGridLevel;
    Splitter1: TSplitter;
    Panel1: TPanel;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxGridParam: TcxGrid;
    cxGridParamDBTV_Param: TcxGridDBTableView;
    cxGridParamLevel: TcxGridLevel;
    cxGridDRSComHis: TcxGrid;
    cxGridDBTVDRSComHis: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    Panel24: TPanel;
    Btn_QuerySet: TButton;
    Btn_ConfigSet: TButton;
    Panel2: TPanel;
    Button1: TButton;
    cxdeStartDate: TcxDateEdit;
    cxdeEndDate: TcxDateEdit;
    Label37: TLabel;
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
  FormParamConfig: TFormParamConfig;

implementation

uses UnitDllPublic;

{$R *.dfm}

procedure TFormParamConfig.FormCreate(Sender: TObject);
begin
//
end;

procedure TFormParamConfig.FormShow(Sender: TObject);
begin
//
end;

procedure TFormParamConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDllCloseRecall(FormParamConfig);
end;

procedure TFormParamConfig.FormDestroy(Sender: TObject);
begin
//
end;

end.
